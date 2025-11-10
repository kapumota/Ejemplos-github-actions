SHELL := /bin/bash
IMAGE := ci-lab:local
EVID := .evidence
PY := python -m

.DEFAULT_GOAL := help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## ' Makefile | sed -E 's/:.*?## / — /'

venv: ## Crear venv local
	python -m venv .venv && . .venv/bin/activate && pip install -r requirements-dev.txt

lint: ## SAST (semgrep, bandit)
	. .venv/bin/activate; semgrep --config .semgrep.yaml --error || true
	. .venv/bin/activate; bandit -c bandit.yml -r src || true

test: ## Pytest + coverage
	. .venv/bin/activate; coverage run -m pytest -q && coverage xml -o $(EVID)/coverage.xml && coverage report

sbom: ## SBOM (syft) de la imagen local
	mkdir -p $(EVID)
	syft $(IMAGE) -o json > $(EVID)/sbom.json

sca: ## SCA deps Python
	. .venv/bin/activate; pip-audit -r requirements-dev.txt -f json -o $(EVID)/pip-audit.json || true

build: ## Build docker
	docker build -t $(IMAGE) .

scan-image: ## Grype scan
	grype $(IMAGE) -o sarif > $(EVID)/grype.sarif || true

kind-up: ## Crear cluster KinD
	kind create cluster --name ci-lab --wait 60s || true

kind-down: ## Borrar cluster
	kind delete cluster --name ci-lab || true

kind-load: build ## Cargar imagen al cluster
	kind load docker-image $(IMAGE) --name ci-lab

k8s-apply: ## Aplicar manifiestos
	kubectl apply -f k8s/deployment.yaml

k8s-wait: ## Esperar readiness
	./scripts/wait-for-url.sh http://$(shell kubectl get svc ci-lab -o jsonpath='{.spec.clusterIP}'):8080/healthz 60

zap: ## DAST ZAP baseline
	docker run --rm --network host -v $(PWD)/$(EVID):/zap/wrk:rw \
		owasp/zap2docker-stable zap-baseline.py -t http://localhost:8080 -r /zap/wrk/zap.html || true

all: lint test build sbom sca scan-image ## Pipeline local completo

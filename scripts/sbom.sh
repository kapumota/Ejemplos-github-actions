#!/usr/bin/env bash
# Genera SBOM SPDX para una imagen Docker local (sin registry)
set -euo pipefail

IMG="${1:-}"
if [[ -z "${IMG}" ]]; then
  echo "Uso: $0 <imagen>"
  echo "Ejemplo: $0 ci-lab:$(git rev-parse --short HEAD)"
  exit 1
fi

mkdir -p ./.evidence
# Salida a stdout + redirección: más portable entre runners
syft "${IMG}" -o spdx-json > ./.evidence/sbom.spdx.json
echo "[OK] SBOM generado en ./.evidence/sbom.spdx.json"

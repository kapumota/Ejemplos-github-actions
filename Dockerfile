# Multi-stage
FROM python:3.12-slim AS build
WORKDIR /app
COPY pyproject.toml README.md ./
COPY src ./src
RUN pip install --upgrade pip build && python -m build

FROM python:3.12-slim
WORKDIR /app
# Usuario no-root
RUN useradd -m appuser
# Copiar el/los wheels sin renombrar
COPY --from=build /app/dist/*.whl /tmp/wheels/
# Instalar usando el nombre original del wheel
RUN pip install --no-cache-dir /tmp/wheels/*.whl && rm -rf /tmp/wheels
COPY src ./src
ENV PYTHONPATH=/app/src
USER appuser
EXPOSE 8080
CMD ["python", "-m", "app.serve"]

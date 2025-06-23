## ¿Qué es GitHub Actions?

GitHub Actions es la plataforma de CI/CD integrada en GitHub que permite definir y ejecutar flujos de trabajo (workflows) en respuesta a eventos como `push`, `pull_request`, o programaciones periódicas.

Cada workflow se define en un archivo YAML ubicado en `.github/workflows/` y consta de uno o más jobs que se ejecutan en runners (por ejemplo, `ubuntu-latest`).

### Procedimiento de configuración

A continuación se describen los pasos para ejecutar este proyecto desde cero:

1. **Crear el repositorio en GitHub**

   * Nombre sugerido: `Ejemplos-github-actions`.
   * Inicializar con un `README.md` opcional.

2. **Clonar el repositorio localmente**

   ```bash
   git clone git@github.com:<TU_USUARIO>/Ejemplos-github-actions.git
   cd Ejemplo-github-actions
   ```

3. **Añadir el script de ejemplo**

   * Crear `index.sh` con permisos de ejecución:

     ```bash
     #!/usr/bin/env bash
     set -euo pipefail

     echo "¡Hola desde el pipeline de GitHub Actions!"
     ```
   * Hacerlo ejecutable y confirmar cambios:

     ```bash
     chmod +x index.sh
     git add index.sh
     git commit -m "Añadir script de ejemplo index.sh"
     ```

4. **Configurar el workflow de GitHub Actions**

   * Crear carpeta `.github/workflows/` y archivo `ci.yml`:

     ```yaml
     name: CI

     on: [push]

     jobs:
       build:
         runs-on: ubuntu-latest

         steps:
           - name: Checkout repository
             uses: actions/checkout@v4

           - name: Ejecutar index.sh
             run: bash index.sh
     ```
   * Añadir y subir:

     ```bash
     git add .github/workflows/ci.yml
     git commit -m "Configurar GitHub Actions para ejecutar index.sh"
     git push origin main
     ```

5. **Verificar la ejecución**

   * En GitHub, pestaña **Actions**, seleccionar el workflow y revisar los logs.


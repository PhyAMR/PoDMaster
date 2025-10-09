#!/bin/bash
# ===============================================
# Script: update_notes.sh
# Autor: Álvaro
# Descripción:
#   Sincroniza tu fork con el upstream y crea
#   automáticamente un Pull Request en GitHub.
# ===============================================

# --- CONFIGURACIÓN ---
SUBMODULE_DIR="Models-of-Theoretical-Physics-Personal"
UPSTREAM_URL="git@github.com:amirh0ss3in/Models-of-Theoretical-Physics.git"  # 🔁 Cambia esto
OWNER="PhyAMR"         # 🔁 Tu usuario de GitHub
REPO="$SUBMODULE_DIR"     # 🔁 Nombre de tu fork
BRANCH="main"          # Rama principal
DATE=$(date +"%Y%m%d")
SYNC_BRANCH="sync-upstream-$DATE"

echo "📘 Actualizando submódulo: $SUBMODULE_DIR"
cd "$SUBMODULE_DIR" || { echo "❌ No se encuentra el submódulo"; exit 1; }

# --- Añadir upstream si no existe ---
if ! git remote | grep -q "upstream"; then
    echo "🔗 Añadiendo remote 'upstream'..."
    git remote add upstream "$UPSTREAM_URL"
else
    echo "🔗 Remote 'upstream' ya existe."
fi

# --- Obtener cambios del upstream ---
echo "⬇️  Descargando cambios del repositorio original..."
git fetch upstream

# --- Crear rama temporal ---
echo "🌿 Creando rama temporal: $SYNC_BRANCH"
git checkout -b "$SYNC_BRANCH" origin/$BRANCH

# --- Fusionar cambios ---
echo "🔄 Combinando cambios desde upstream/$BRANCH..."
git merge upstream/$BRANCH --no-edit

# --- Subir rama al fork ---
echo "⬆️  Subiendo rama al fork..."
git push origin "$SYNC_BRANCH"

echo "✅ Rama '$SYNC_BRANCH' creada y subida a tu fork."
echo "👉 Puedes revisar los cambios en GitHub y hacer el Pull Request manualmente si lo deseas."

# --- Volver al repositorio principal ---
cd ..

echo "🔁 Si deseas actualizar el submódulo en tu repo principal, ejecuta:"
echo "   git add $SUBMODULE_DIR && git commit -m 'Actualizar submódulo tras sync' && git push"

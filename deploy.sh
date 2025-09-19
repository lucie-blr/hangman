#!/bin/bash

# === CONFIGURATION ===
APP_NAME="hangman"
DOMAIN="hangman.lucieblr.com"    # ← À personnaliser
NETWORK="runtipi_tipi_main_network"
CONTAINER_NAME="$APP_NAME"
PROJECT_DIR="/home/lucie/sites/$APP_NAME"  # ← À adapter
DOCKER_COMPOSE_CMD="docker compose"        # ou "docker-compose"
BUILD_DIR="dist"

echo "🔧 Déploiement de l'application $APP_NAME dans $PROJECT_DIR"

# === Pull des dernières modifications Git ===
echo "📥 Pull des dernières modifications Git..."
if git pull --rebase --stat; then
  echo "✅ Pull réussi."
else
  echo "❌ Échec du pull Git."
  exit 1
fi

# === Détection de projet Vue/Node.js ===
if [ -f package.json ]; then
  echo "📦 Détection d’un projet Node.js, installation des dépendances..."
  if ! npm install; then
    echo "❌ Échec de 'npm install'."
    exit 1
  fi

  echo "🏗 Build du projet (npm run build)..."
  if ! npm run build; then
    echo "❌ Échec du build Vue.js."
    exit 1
  fi
else
  echo "⚠️ Aucun package.json détecté. Supposition : projet HTML/CSS statique."
  BUILD_DIR="."
fi

# === Vérification du dossier de build ===
if [ ! -d "$BUILD_DIR" ]; then
  echo "❌ Dossier de build '$BUILD_DIR' introuvable."
  exit 1
fi

# === Génération Dockerfile si absent ===
if [ ! -f Dockerfile ]; then
  echo "📝 Création d'un Dockerfile..."
  cat <<EOF > Dockerfile
FROM nginx:alpine
COPY $BUILD_DIR/ /usr/share/nginx/html
EOF
else
  echo "📄 Dockerfile existant détecté."
fi

# === Génération docker-compose.yml si absent ===
if [ ! -f docker-compose.yml ]; then
  echo "📝 Création d'un docker-compose.yml..."
  cat <<EOF > docker-compose.yml
version: "3.8"

services:
  $APP_NAME:
    build: .
    container_name: $CONTAINER_NAME
    restart: unless-stopped
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.$APP_NAME.rule=Host(\`$DOMAIN\`)"
      - "traefik.http.routers.$APP_NAME.entrypoints=websecure"
      - "traefik.http.routers.$APP_NAME.tls.certresolver=myresolver"
    networks:
      - $NETWORK

networks:
  $NETWORK:
    external: true
EOF
else
  echo "📄 docker-compose.yml existant détecté."
fi

# === Restart Docker ===
echo "🧹 Arrêt du conteneur existant (si présent)..."
$DOCKER_COMPOSE_CMD down

echo "🚀 Build et lancement du conteneur Docker..."
if $DOCKER_COMPOSE_CMD up -d --build; then
  echo "✅ Déploiement terminé avec succès !"
  echo "🌍 Site disponible à l'adresse : https://$DOMAIN"
else
  echo "❌ Échec du redémarrage Docker."
  exit 1
fi
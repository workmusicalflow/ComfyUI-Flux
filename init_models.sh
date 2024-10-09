#!/bin/bash

MODEL_DIR="/ComfyUI/models"

# Fonction pour télécharger un modèle s'il n'existe pas
download_if_not_exists() {
    local file="$1"
    local url="$2"
    if [ ! -f "$file" ]; then
        echo "Downloading $file..."
        wget "$url" -O "$file"
    else
        echo "$file already exists. Skipping download."
    fi
}

# Gestion du dossier CatVTON
CATVTON_DIR="$MODEL_DIR/CatVTON"
CATVTON_ZIP="$MODEL_DIR/CatVTON.zip"
CATVTON_URL="https://storage.googleapis.com/vok01/Docker-save/CatVTON.zip"

if [ ! -d "$CATVTON_DIR" ] || [ -z "$(ls -A "$CATVTON_DIR")" ]; then
    echo "CatVTON directory is missing or empty. Downloading and extracting..."
    mkdir -p "$CATVTON_DIR"
    wget "$CATVTON_URL" -O "$CATVTON_ZIP"
    unzip "$CATVTON_ZIP" -d "$CATVTON_DIR"
    rm "$CATVTON_ZIP"
    echo "CatVTON files extracted to $CATVTON_DIR"
else
    echo "CatVTON directory already exists and is not empty. Skipping download."
fi

# ... Ajouter d'autres modèles selon vos besoins

echo "Model initialization complete."
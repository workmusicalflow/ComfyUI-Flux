# Use the official Python base image
FROM python:3.12

# Install necessary tools
RUN apt-get update && apt-get install -y wget unzip

# Clone the ComfyUI repository
RUN git clone https://github.com/comfyanonymous/ComfyUI.git

# Set the working directory
WORKDIR /ComfyUI

# Update pip, install GPU dependencies, and install Comfy dependencies
RUN pip install --upgrade pip && \
    pip install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu121 && \
    pip install -r requirements.txt

# Clone ComfyUI-Manager
RUN git clone https://github.com/ltdrdata/ComfyUI-Manager.git /ComfyUI/custom_nodes/ComfyUI-Manager

# Télécharger flux_dev
RUN wget -O /ComfyUI/models/checkpoints/flux_dev.safetensors https://huggingface.co/Comfy-Org/flux1-dev/resolve/main/flux1-dev-fp8.safetensors

# Télécharger et extraire CatVTON
RUN wget -O /tmp/CatVTON.zip https://storage.googleapis.com/vok01/Docker-save/CatVTON.zip && \
    unzip /tmp/CatVTON.zip -d /ComfyUI/models/CatVTON && \
    rm /tmp/CatVTON.zip

# Ajoutez ici d'autres téléchargements ou configurations nécessaires
# Par exemple :
# RUN wget -O /ComfyUI/models/loras/some_lora.safetensors https://example.com/some_lora.safetensors

# Nettoyage pour réduire la taille de l'image
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Set the entry point for the container
CMD ["python3", "main.py", "--listen", "0.0.0.0", "--port", "${PORT:-8188}"]
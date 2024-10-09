# Use the official Python base image
FROM python:3.12

# Install necessary tools
RUN apt-get update && apt-get install -y wget

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

# Script d'initialisation
COPY init_models.sh /ComfyUI/init_models.sh
RUN chmod +x /ComfyUI/init_models.sh

# Utiliser le script d'initialisation comme point d'entrée
CMD ["/bin/bash", "-c", "/ComfyUI/init_models.sh && python3 main.py --listen 0.0.0.0 --port ${PORT:-8188}"]
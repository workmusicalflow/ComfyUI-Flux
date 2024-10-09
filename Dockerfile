# Use the official Python base image
FROM python:3.12

# Install necessary tools
RUN apt-get update && apt-get install -y git wget unzip

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

# Clone CatVTON wrapper
RUN git clone https://github.com/chflame163/ComfyUI_CatVTON_Wrapper.git /ComfyUI/custom_nodes/ComfyUI_CatVTON_Wrapper

# Download and extract CatVTON content
RUN mkdir -p /ComfyUI/models/CatVTON && \
    wget -O /tmp/CatVTON.zip "https://storage.googleapis.com/vok01/Docker-save/CatVTON.zip" && \
    unzip /tmp/CatVTON.zip -d /ComfyUI/models/CatVTON && \
    rm /tmp/CatVTON.zip

# Install additional dependencies for CatVTON
RUN pip install opencv-python-headless

# Set the entry point for the container
CMD python3 main.py --listen 0.0.0.0 --port ${PORT:-8188}
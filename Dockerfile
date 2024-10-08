# Use the official Python base image
FROM python:3.12

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

# Set the entry point for the container
CMD python3 main.py --listen 0.0.0.0 --port ${PORT:-8188}
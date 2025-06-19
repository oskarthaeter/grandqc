FROM nvcr.io/nvidia/pytorch:25.03-py3

ENV DEBIAN_FRONTEND=noninteractive

# Build-time arguments for user id mapping
ARG USERNAME
ARG UID
ARG GID

RUN apt-get update && apt-get install -y --no-install-recommends \
    sudo \
    openslide-tools \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Create a user and group with the specified UID and GID
RUN groupadd --gid $GID $USERNAME && \
    useradd --no-log-init --uid $UID --gid $GID --create-home --shell /bin/bash $USERNAME && \
    echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Install python packages
RUN pip3 install --no-cache-dir \
    numpy==1.26.4
    opencv_python_headless==4.7.0.72 \
    Pillow==10.4.0 \
    scipy==1.14.1 \
    segmentation_models_pytorch==0.3.1 \
    scikit-image==0.21.0 \
    six==1.16.0 \
    tifffile==2023.4.12 \
    torch==2.0.1 \
    tqdm==4.65.0 \
    zarr==2.16.1 \
    rasterio==1.4.3 \
    imagecodecs==2024.12.30 \
    openslide-python \
    && rm -rf /root/.cache/pip

ENV LD_LIBRARY_PATH=/opt/hpcx/ucx/lib:$LD_LIBRARY_PATH

# Switch to the new user
USER $USERNAME

# Set the working directory
WORKDIR /workspaces

# ENVIRONMENT VARIABLES
ENV DEV_CWD=/workspaces/grandqc

ENV HUGGINGFACE_HUB_CACHE=/mnt/.cache
ENV TORCH_HOME=/mnt/.torchhome

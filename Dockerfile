# Simple Dockerfile for terminal access
FROM ubuntu:22.04

# Install some basic tools
RUN apt-get update && apt-get install -y \
    bash curl nano vim git net-tools iputils-ping \
    && rm -rf /var/lib/apt/lists/*

# Default working directory
WORKDIR /root

# Keep the container running with bash
CMD ["bash"]

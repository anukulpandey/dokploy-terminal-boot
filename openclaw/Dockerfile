FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    openssh-server sudo curl git vim \
    && rm -rf /var/lib/apt/lists/*

# Setup SSH
RUN mkdir -p /run/sshd

# Create user
RUN useradd -m -s /bin/bash anukul && \
    echo "anukul:anukul" | chpasswd && \
    usermod -aG sudo anukul

# Enable password auth
RUN sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config && \
    sed -i 's/^#\?UsePAM.*/UsePAM yes/' /etc/ssh/sshd_config

# Install OpenClaw
RUN curl -fsSL https://openclaw.ai/install.sh | bash

# Environment variables (you will pass at runtime)
ENV GEMINI_API_KEY=""
ENV TELEGRAM_BOT_TOKEN=""

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]

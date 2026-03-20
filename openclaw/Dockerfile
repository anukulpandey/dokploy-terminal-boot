FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install SSH
RUN apt-get update && apt-get install -y \
    openssh-server sudo \
    && rm -rf /var/lib/apt/lists/*

# Setup SSH
RUN mkdir /var/run/sshd

# Create user
RUN useradd -m -s /bin/bash anukul && \
    echo "anukul:anukul" | chpasswd && \
    usermod -aG sudo anukul

# Enable password login
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config || true && \
    echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config && \
    echo "PermitRootLogin no" >> /etc/ssh/sshd_config

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]

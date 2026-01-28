FROM ubuntu:22.04

# Install OpenSSH and utilities
RUN apt-get update && apt-get install -y \
    openssh-server sudo curl vim git iputils-ping net-tools \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user with sudo access
RUN useradd -ms /bin/bash reef && echo "reef:reefpass" | chpasswd && adduser reef sudo

# Prepare SSH daemon
RUN mkdir /var/run/sshd
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]

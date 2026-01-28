FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install SSH and basics
RUN apt-get update && apt-get install -y \
    openssh-server sudo curl vim git iputils-ping net-tools \
    && rm -rf /var/lib/apt/lists/*

# Create SSH directory
RUN mkdir /var/run/sshd

# Create user anukul with password anukul
RUN useradd -m -s /bin/bash anukul \
 && echo "anukul:anukul" | chpasswd \
 && usermod -aG sudo anukul

# Configure SSH to allow password login on port 22
RUN sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config \
 && sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config \
 && sed -i 's/^#Port 22/Port 22/' /etc/ssh/sshd_config \
 && sed -i 's/^PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]

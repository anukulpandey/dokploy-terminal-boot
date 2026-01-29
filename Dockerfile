FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    openssh-server sudo curl vim git iputils-ping net-tools \
    && rm -rf /var/lib/apt/lists/*

# Required by sshd
RUN mkdir -p /run/sshd

# Create user
RUN useradd -m -s /bin/bash anukul && \
    echo "anukul:anukul" | chpasswd && \
    usermod -aG sudo anukul

# SSH config
RUN sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config && \
    sed -i 's/^#\?UsePAM.*/UsePAM no/' /etc/ssh/sshd_config

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]

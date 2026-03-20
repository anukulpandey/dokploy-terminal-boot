FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    openssh-server sudo curl git vim expect \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /run/sshd

RUN useradd -m -s /bin/bash anukul && \
    echo "anukul:anukul" | chpasswd && \
    usermod -aG sudo anukul

RUN sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config && \
    sed -i 's/^#\?UsePAM.*/UsePAM yes/' /etc/ssh/sshd_config

# 🔥 FIXED INSTALL
RUN curl -fsSL https://openclaw.ai/install.sh | script -q -c "bash" /dev/null

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]

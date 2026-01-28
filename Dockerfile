FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    openssh-server sudo curl vim git iputils-ping net-tools \
    && rm -rf /var/lib/apt/lists/*

# Create user anukul with sudo access
RUN useradd -ms /bin/bash anukul \
 && echo "anukul:anukul" | chpasswd \
 && adduser anukul sudo

# Configure SSH
RUN mkdir /var/run/sshd \
 && sed -i 's/#Port 22/Port 2222/' /etc/ssh/sshd_config \
 && sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

EXPOSE 2222
CMD ["/usr/sbin/sshd", "-D"]

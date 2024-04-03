#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "apply-templates.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#

FROM python:3.9.19-alpine3.19

RUN apk add --no-cache openssh shadow sudo bash exiftool
RUN mkdir /var/run/sshd
RUN mkdir -p /mnt/hdd0 && mkdir -p /mnt/mypool

RUN echo '%wheel ALL=(ALL) ALL' > /etc/sudoers.d/wheel
RUN echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers.d/wheel

RUN useradd -m -d /home/ubuntu -s /bin/ash -u 1000 ubuntu && \
    echo "ubuntu:ubuntu" | chpasswd && \
    adduser ubuntu wheel

RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

RUN echo 'HostKey /etc/ssh/keys/ssh_host_rsa_key' >> /etc/ssh/sshd_config && \
    echo 'HostKey /etc/ssh/keys/ssh_host_dsa_key' >> /etc/ssh/sshd_config && \
    echo 'HostKey /etc/ssh/keys/ssh_host_ecdsa_key' >> /etc/ssh/sshd_config && \
    echo 'HostKey /etc/ssh/keys/ssh_host_ed25519_key' >> /etc/ssh/sshd_config


EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]

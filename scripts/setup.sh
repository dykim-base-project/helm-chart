#!/bin/bash
set -e

# SSH 키 설정
mkdir -p /root/.ssh
echo "${SSH_PUBLIC_KEY}" | base64 -d > /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys
chown root:root /root/.ssh/authorized_keys

# 사용자 계정 생성 및 sudo 설정
useradd -m -s /bin/bash "${USERNAME}"
usermod -a -G "${GROUP}" "${USERNAME}"
echo "%${GROUP} ALL=(ALL:ALL) ALL" >> /etc/sudoers

# SSH 설정 (sshd_config 수정)
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/g' /etc/ssh/sshd_config

# SSH 서비스 시작
service ssh restart
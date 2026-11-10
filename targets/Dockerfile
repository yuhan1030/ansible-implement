# 模擬「被管理的伺服器」：一台有 SSH + Python 的 Ubuntu
# Ansible 只需要目標機器有兩樣東西：SSH 連得進去、有 Python
FROM ubuntu:24.04

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      openssh-server python3 sudo \
 && rm -rf /var/lib/apt/lists/*

# 建立 ansible 使用者，並允許免密碼 sudo（playbook 裡的 become: true 會用到）
RUN useradd -m -s /bin/bash ansible \
 && echo 'ansible ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/ansible \
 && chmod 440 /etc/sudoers.d/ansible

# 只允許金鑰登入
RUN mkdir -p /run/sshd \
 && sed -i 's/^#\?PasswordAuthentication .*/PasswordAuthentication no/' /etc/ssh/sshd_config

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 22 80
ENTRYPOINT ["/entrypoint.sh"]

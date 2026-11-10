#!/bin/bash
# 容器啟動時：把控制端的公鑰放進 authorized_keys，然後啟動 sshd
set -e
mkdir -p /home/ansible/.ssh
cp /tmp/authorized_keys /home/ansible/.ssh/authorized_keys
chown -R ansible:ansible /home/ansible/.ssh
chmod 700 /home/ansible/.ssh
chmod 600 /home/ansible/.ssh/authorized_keys
exec /usr/sbin/sshd -D -e

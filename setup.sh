#!/usr/bin/env bash
# 一鍵建立練習環境：產生 SSH 金鑰 → 啟動 3 台模擬伺服器
set -euo pipefail
cd "$(dirname "$0")"

KEY="$HOME/.ssh/ansible_lab"
if [ ! -f "$KEY" ]; then
  mkdir -p "$HOME/.ssh" && chmod 700 "$HOME/.ssh"
  ssh-keygen -t ed25519 -N "" -f "$KEY" -C "ansible-implement"
  echo "已產生金鑰：$KEY"
fi

mkdir -p keys
cp "$KEY.pub" keys/authorized_keys

docker compose up -d --build
echo
echo "環境已啟動，接著試試：ansible all -m ping"

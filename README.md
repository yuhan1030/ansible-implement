# ansible-implement

用 Docker 模擬 3 台伺服器，在 WSL2（Ubuntu）上練習 Ansible。

```
WSL2 Ubuntu（控制端，執行 ansible 指令）
   │  SSH
   ├── web1  127.0.0.1:2221   網站 → http://localhost:8081
   ├── web2  127.0.0.1:2222   網站 → http://localhost:8082
   └── db1   127.0.0.1:2223
```

> **為什麼專案放在 WSL 的家目錄（~/ansible-implement），而不是 Windows 桌面？**
> 從 WSL 存取 `/mnt/c/...` 時，所有檔案權限都是 777。Ansible 看到這種權限會**忽略 ansible.cfg**，
> SSH 也會拒絕使用權限太寬的私鑰。放在 Linux 檔案系統裡就沒有這些問題，速度也比較快。
> 在 Windows 檔案總管可以從 `\\wsl$\Ubuntu\home\b22754212\ansible-implement` 打開，
> 或在 WSL 裡執行 `code .` 用 VS Code 開啟。

## 一次性準備

1. 打開 **Docker Desktop**，確認 Settings → Resources → WSL integration 有勾選 Ubuntu
2. 打開 Ubuntu 終端機，安裝 Ansible：
   ```bash
   sudo apt update && sudo apt install -y ansible
   ansible --version
   ```

## 啟動環境

```bash
cd ~/ansible-implement
bash setup.sh          # 產生 SSH 金鑰並啟動 3 台模擬伺服器
```

## 第 1 階段：連線

```bash
ansible all -m ping                 # ad-hoc 指令：對所有主機執行 ping 模組
ansible web -a "hostname"           # 只對 web 群組執行 shell 指令
ansible-inventory --graph           # 看主機分組
ansible-playbook playbooks/01-ping.yml
```

## 第 2 階段：第一個真正的 playbook

```bash
ansible-playbook playbooks/02-install-nginx.yml
curl localhost:8081    # Hello from web1
curl localhost:8082    # Hello from web2
```

**練習：** 再執行一次 playbook，觀察輸出從 `changed` 變成 `ok`。這就是冪等性：
playbook 描述的是「應該長怎樣」，不是「要做哪些步驟」，所以重複執行是安全的。

## 後續路線

3. 變數與 Jinja2 模板（`group_vars/`、`template` 模組）
4. handlers：設定檔有改動才重啟服務
5. roles：把 playbook 拆成可重用的模組
6. Vault 加密密碼、`when`、`loop`、tags
7. 用 Ansible 安裝 Docker 並部署 compose 專案

## 重來 / 關閉

```bash
docker compose down        # 關掉並刪除容器（下次 setup.sh 就是全新的機器）
```

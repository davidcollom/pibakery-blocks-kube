#!/bin/bash
set -e

# 1 - Master
# 2 - Token
# 3 - Token CA
cat > /etc/systemd/system/kubejoin.service <<EOF
[Unit]
Wants=network-online.target
After=docker.service

[Service]
Type=oneshot
RemainAfterExit=no
ExecStart=/usr/bin/kubeadm join --ignore-preflight-errors=all --token "${2}" "${1}" --discovery-token-ca-cert-hash "${3}"
ExecStartPost=/bin/systemctl try-restart kubelet.service

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl enable kubejoin

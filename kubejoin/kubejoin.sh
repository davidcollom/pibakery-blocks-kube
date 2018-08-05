#!/bin/bash
set -e

# 1 - Master
# 2 - Token
# 3 - Token CA
master="${1}"
token="${1}"
token_ca="${1}"

echo "Creating SystemD Unit for kubejoin..."
cat > /etc/systemd/system/kubejoin.service <<EOF
[Unit]
Wants=network-online.target
After=docker.service

[Service]
Type=oneshot
RemainAfterExit=no
ExecStart=/usr/bin/kubeadm join --ignore-preflight-errors=all --token "${token}" "${master}" --discovery-token-ca-cert-hash "${token_ca}"
ExecStartPost=/bin/systemctl try-restart kubelet.service

[Install]
WantedBy=multi-user.target
EOF
echo "Done"

systemctl daemon-reload
echo "Enabling SystemD kubejoin service"
systemctl enable kubejoin
echo "Done"

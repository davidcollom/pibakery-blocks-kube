#!/bin/bash
set -e

# 1 - Master
# 2 - Token
# 3 - Token CA

kubeadm join --token "${2}" "${1}" --discovery-token-ca-cert-hash ${3}

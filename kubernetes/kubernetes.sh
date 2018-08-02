#!/bin/bash
set -e

echo "Installing Kubernetes"
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - && \
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list && \
sudo apt-get update -q

echo

sudo apt-get install -qy kubeadm kubectl kubelet

echo

if [[ "$node_type" == "master" ]]; then
  echo "Removing \"KUBELET_NETWORK_ARGS\" from 10-kubeadm.conf"
  sudo sed -i '/KUBELET_NETWORK_ARGS=/d' /etc/systemd/system/kubelet.service.d/10-kubeadm.conf

  exit 0
elif [[ "$node_type" == "slave" ]]; then
  exit 0
fi

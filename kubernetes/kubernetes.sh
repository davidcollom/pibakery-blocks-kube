#!/bin/bash

echo "Installing Kubernetes"
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - && \
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list && \
sudo apt-get update -q

echo

if [[ $2 != "latest" ]]; then
  sudo apt-get install --allow-downgrades -qy kubeadm="${2}-00" kubectl="${2}-00" kubelet="${2}-00"
else
  sudo apt-get install -qy kubeadm kubectl kubelet
fi

echo

if [[ "${1}" == "master" ]]; then
  echo "Removing \"KUBELET_NETWORK_ARGS\" from 10-kubeadm.conf"
  sudo sed -i '/KUBELET_NETWORK_ARGS=/d' /etc/systemd/system/kubelet.service.d/10-kubeadm.conf

  # etcd doesn't like their being a search definition here
  echo "Removing search domain from /etc/resolv.conf"
  sudo sed -e 's/^search/#search/' -i /etc/resolv.conf

fi

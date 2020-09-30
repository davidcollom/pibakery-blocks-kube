#!/bin/bash

echo "Installing Docker"
curl -sSL get.docker.com | sh

if [[ $1 != "latest" ]]; then
    sudo apt-get install -qy --allow-downgrades docker-ce="${1}~ce-0~raspbian"
fi

echo "Locking docker-ce package..."
echo "docker-ce hold" | sudo dpkg --set-selections
echo "Done"

if uname -a | grep hypriot; then
os_type=hypriot
elif uname -a | grep raspbian; then
os_type=raspbian
elif id pi > /dev/null; then
os_type=raspbian
fi

if [[ "$os_type" == "raspbian" ]]; then
sudo usermod pi -aG docker
elif [[ "$os_type" == "hypriot" ]]; then
sudo usermod pirate -aG docker
else
echo "OS type not known"
exit 1
fi

echo

echo "Disabling Swap.."
sudo dphys-swapfile swapoff && \
sudo dphys-swapfile uninstall && \
sudo update-rc.d dphys-swapfile remove
echo "Done"

echo "Backing up cmdline.txt to /boot/cmdline_backup.txt.."
sudo cp /boot/cmdline.txt /boot/cmdline_backup.txt
echo "Done"

echo

echo Adding " cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory " to /boot/cmdline.txt ...
orig="$(head -n1 /boot/cmdline.txt) cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory"
echo "$orig" | sudo tee /boot/cmdline.txt
echo "Done"

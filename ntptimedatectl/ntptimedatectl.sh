#!/bin/bash
sudo timedatectl set-ntp True
sudo systemctl daemon-reload
sudo systemctl restart systemd-timesyncd

#!/bin/bash

ROLE=$1
MASTER_IP="192.168.56.10"

apt-get update -y
apt-get install -y curl

if [ "$ROLE" = "server" ]; then

  echo "Installing K3s server..."

  curl -sfL https://get.k3s.io | sh -

  sleep 10

  # ── Save node token for workers ───────────────────────────────────
  sudo cat /var/lib/rancher/k3s/server/node-token | sudo tee /vagrant/node-token

  # ── Fix kubeconfig permissions for vagrant user ───────────────────
  mkdir -p /home/vagrant/.kube
  sudo cp /etc/rancher/k3s/k3s.yaml /home/vagrant/.kube/config
  sudo chown vagrant:vagrant /home/vagrant/.kube/config
  sudo chmod 600 /home/vagrant/.kube/config

  # ── Set KUBECONFIG in bashrc ──────────────────────────────────────
  echo 'export KUBECONFIG=/home/vagrant/.kube/config' >> /home/vagrant/.bashrc

  echo "✅ K3s server ready. kubeconfig set for vagrant user."

else

  echo "Waiting for server token..."

  while [ ! -f /vagrant/node-token ]; do
      sleep 3
  done

  TOKEN=$(cat /vagrant/node-token)

  echo "Joining cluster as agent..."

  curl -sfL https://get.k3s.io | \
  K3S_URL=https://${MASTER_IP}:6443 \
  K3S_TOKEN=$TOKEN sh -

  echo "✅ Worker joined the cluster."

fi
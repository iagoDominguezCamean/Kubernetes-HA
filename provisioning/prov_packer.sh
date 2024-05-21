#!/bin/bash
#sudo dnf -y update

# Install Docker
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl enable docker
sudo systemctl start docker
sudo rm -f /etc/containerd/config.toml
sudo usermod -a -G docker vagrant
sudo systemctl restart docker

# Install k8s
sudo echo "[kubernetes]" | sudo tee -a /etc/yum.repos.d/kubernetes.repo
sudo echo "name=Kubernetes" | sudo tee -a /etc/yum.repos.d/kubernetes.repo
sudo echo "baseurl=https://pkgs.k8s.io/core:/stable:/v1.28/rpm/" | sudo tee -a /etc/yum.repos.d/kubernetes.repo
sudo echo "enabled=1" | sudo tee -a /etc/yum.repos.d/kubernetes.repo
sudo echo "gpgcheck=1" | sudo tee -a /etc/yum.repos.d/kubernetes.repo
sudo echo "gpgkey=https://pkgs.k8s.io/core:/stable:/v1.28/rpm/repodata/repomd.xml.key" | sudo tee -a /etc/yum.repos.d/kubernetes.repo

sudo yum install -y kubelet kubeadm kubectl
sudo kubeadm reset -f
sudo rm home/vagrant/.kube/config
sudo rm /etc/cni/net.d/10-flannel.conflist
sudo iptables -F && sudo iptables -t nat -F && sudo iptables -t mangle -F && sudo iptables -X

# Disable swap
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
sudo swapoff -a

# SELinux as Permissive
sudo setenforce 0
sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

# Manage services
sudo containerd config default | sudo tee /etc/containerd/config.toml
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml
sudo kubeadm config images pull
sudo systemctl enable kubelet
sudo systemctl disable firewalld
sudo systemctl restart docker
sudo systemctl restart containerd

# Add Cluster-endpoint IP
sudo echo "192.168.56.30   idc-cluster-endpoint" >> sudo /etc/hosts

# Install nfs-utils Keppalived Haproxy
sudo yum install -y nfs-utils keepalived haproxy
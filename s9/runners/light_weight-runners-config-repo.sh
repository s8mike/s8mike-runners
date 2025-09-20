#!/bin/bash

# Lightweight DevOps environment for t2.micro

# Update system
sudo apt update -y
sudo apt upgrade -y

# Basic utilities
packages=(
  curl 
  wget 
  vim 
  git 
  jq 
  unzip 
  tree 
  postgresql-client 
  mariadb-client 
  mysql-client
)

echo "Installing basic packages..."
for package in "${packages[@]}"; do
    echo "Installing $package ..."
    sudo apt install -y "$package"
done

echo "Basic package installation completed."

# Install AWS CLI v2
echo "Installing AWS CLI..."
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
rm -rf awscliv2.zip aws
aws --version

# Install Docker
echo "Installing Docker..."
sudo apt-get remove docker docker-engine docker.io containerd runc -y
sudo apt-get update
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt install -y docker-ce docker-ce-cli containerd.io

sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER

# Install Docker Compose
echo "Installing Docker Compose..."
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version

echo "Lightweight DevOps setup completed ✅"

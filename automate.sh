#!/bin/bash

set -euo pipefail

if [[ $EUID -ne 0 ]]; then
    echo "Please run as root: sudo $0"
    exit 1
fi

echo "Updating system..."
apt update && apt upgrade -y

echo "Installing Git..."
apt install git -y

echo "Installing Python..."
apt install python3 python3-pip -y
echo "Python installed: $(python3 --version)"

echo "Installing Docker..."
apt install docker.io -y
systemctl enable --now docker

echo "Installing Kubernetes CLI..."
snap install kubectl --classic
echo "kubectl installed: $(kubectl version --client 2>/dev/null | head -1)"

echo "Installing Helm..."
curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

echo "Installing Terraform (IaC)..."
apt install -y gnupg software-properties-common wget lsb-release
wget -qO - https://apt.releases.hashicorp.com/gpg \
    | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
    | tee /etc/apt/sources.list.d/hashicorp.list > /dev/null
apt update && apt install terraform -y

echo "Installing Ansible (Configuration Management)..."
apt install software-properties-common -y
add-apt-repository --yes --update ppa:ansible/ansible
apt update
apt install ansible -y

echo "Installing AWS CLI..."
apt install unzip -y
TMP=$(mktemp -d)
curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" \
    -o "$TMP/awscliv2.zip"
unzip -q "$TMP/awscliv2.zip" -d "$TMP"
"$TMP/aws/install" --update
rm -rf "$TMP"
echo "AWS CLI installed: $(aws --version)"

echo "Installing Jenkins (CI/CD)..."
apt update
apt install fontconfig openjdk-21-jre -y
java -version
mkdir -p /etc/apt/keyrings
wget -O /etc/apt/keyrings/jenkins-keyring.asc \
    https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] \
https://pkg.jenkins.io/debian-stable binary/" \
    | tee /etc/apt/sources.list.d/jenkins.list > /dev/null
apt update
apt install jenkins -y
systemctl enable --now jenkins

echo "Installing Prometheus..."
apt install prometheus -y
systemctl enable --now prometheus

echo "Installing Grafana..."
apt install -y apt-transport-https software-properties-common wget gpg
mkdir -p /etc/apt/keyrings
wget -q -O - https://apt.grafana.com/gpg.key \
    | gpg --dearmor \
    | tee /etc/apt/keyrings/grafana.gpg > /dev/null
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] \
https://apt.grafana.com stable main" \
    | tee /etc/apt/sources.list.d/grafana.list > /dev/null
apt update
apt install grafana -y
systemctl enable --now grafana-server

echo "Tools Installed:-"
echo ""
echo "GIT (Version Control Tool)"
echo "python-3"
echo "Docker (Containerization Tool)"
echo "kubernetes - kubectl (Orchestration Tool)"
echo "Helm (Package manager(Kubernetes))"
echo "Terraform (Iac)"
echo "Ansible (Configuration)"
echo "AWS CLI(Cloud-services in CLI)"
echo "Jenkins (CI/CD)"
echo "Prometheus (Monitoring Tool)"
echo "Grafana (Obsevability Tool)"


echo "Note:-"
echo "Run 'aws configure' to set AWS Credentials"
echo "Jenkins runs on 'localhost:8080' in browser"
echo "Prometheus runs on 'localhost:9090' in browser"
echo "Grafana runs on 'localhost:3000'-> (credentials : Admin/Admin) in your browser"

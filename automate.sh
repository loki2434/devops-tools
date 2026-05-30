#!/bin/bash
echo "Updating system..."
sudo apt update && sudo apt upgrade -y
echo "Installing Git..."
sudo apt install git -y
echo "Installing Python"
sudo apt install python3 -y 
echo "Python installed: $(python3 --version)"
echo "Installing Docker..."
sudo apt install docker.io -y
echo "Installing kubernetes.CLI"
sudo snap install k8s --classic
sudo k8s bootstrap
sudo k8s status
sudo k8s kubectl get all --all-namespaces
echo "Installing Helm..."
sudo curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
echo "Installing Terraform(Iaac)" 
wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg -y
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform -y
echo "Installing Ansible(Configuration management)"
sudo apt install software-properties-common -y
sudo add-apt-repository --yes --update ppa:ansible/ansible -y
sudo apt update
sudo apt install ansible -y
echo "Installing AWS-CLI..."
    TMP=$(mktemp -d)
    curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" \
        -o "$TMP/awscliv2.zip"
    unzip -q "$TMP/awscliv2.zip" -d "$TMP"
    "$TMP/aws/install" --update
    rm -rf "$TMP"
    echo "AWS CLI installed: $(aws --version)"
echo "Installing Jenkins(CI/CD)"
sudo apt update
sudo apt install fontconfig openjdk-21-jre -y
java -version
sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \ 
	https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" \ https://pkg.jenkins.io/debian-stable binary/ | sudo tee \ /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt update
sudo apt install jenkins -y
sudo systemctl enable jenkins 
echo "Installing Prometheus..."
sudo apt install prometheus -y
echo "Installing Grafana"
sudo apt install -y apt-transport-https software-properties-common wget gpg -y
# Add Grafana GPG key
mkdir -p /etc/apt/keyrings
wget -q -O - https://packages.grafana.com/gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/grafana.gpg > /dev/null
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://packages.grafana.com/oss/deb stable main" | sudo tee /etc/apt/sources.list.d/grafana.list
sudo apt install grafana -y
sudo systemctl start grafana-server
sudo systemctl enable grafana-server

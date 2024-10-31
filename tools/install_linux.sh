#!/bin/bash

# Обновление и установка базовых зависимостей
echo -e "\033[32mОбновление системы и установка необходимых зависимостей...\033[0m"
sudo apt update && sudo apt install -y curl wget apt-transport-https gnupg lsb-release

# Установка Docker
if ! command -v docker &> /dev/null; then
    echo -e "\033[32mУстановка Docker...\033[0m"
    curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update && sudo apt install -y docker-ce docker-ce-cli containerd.io
    sudo systemctl enable docker --now
else
    echo -e "\033[32mDocker уже установлен.\033[0m"
fi

# Установка Ansible
if ! command -v ansible &> /dev/null; then
    echo -e "\033[32mУстановка Ansible...\033[0m"
    sudo apt install -y ansible
else
    echo -e "\033[32mAnsible уже установлен.\033[0m"
fi

# Установка Terraform
if ! command -v terraform &> /dev/null; then
    echo -e "\033[32mУстановка Terraform...\033[0m"
    wget -q -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt update && sudo apt install -y terraform
else
    echo -e "\033[32mTerraform уже установлен.\033[0m"
fi

# Установка Helm
if ! command -v helm &> /dev/null; then
    echo -e "\033[32mУстановка Helm...\033[0m"
    curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg
    echo "deb [signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
    sudo apt update && sudo apt install -y helm
else
    echo -e "\033[32mHelm уже установлен.\033[0m"
fi

# Установка k9s
if ! command -v k9s &> /dev/null; then
    echo -e "\033[32mУстановка k9s...\033[0m"
    wget https://github.com/derailed/k9s/releases/download/v0.27.4/k9s_Linux_amd64.tar.gz -O k9s.tar.gz
    tar -xzf k9s.tar.gz
    sudo mv k9s /usr/local/bin/
    rm k9s.tar.gz
else
    echo -e "\033[32mk9s уже установлен.\033[0m"
fi

# Установка Minikube
if ! command -v minikube &> /dev/null; then
    echo -e "\033[32mУстановка Minikube...\033[0m"
    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    sudo install minikube-linux-amd64 /usr/local/bin/minikube
    rm minikube-linux-amd64
else
    echo -e "\033[32mMinikube уже установлен.\033[0m"
fi

# Установка kubectl
if ! command -v kubectl &> /dev/null; then
    echo -e "\033[32mУстановка kubectl...\033[0m"
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    rm kubectl
else
    echo -e "\033[32mkubectl уже установлен.\033[0m"
fi

# Проверка версий установленных инструментов
echo -e "\n\033[35mПроверка версий установленных инструментов:\033[0m"
echo -e "\033[32mDocker версия: $(docker --version)\033[0m"
echo -e "\033[32mAnsible версия: $(ansible --version | head -n 1)\033[0m"
echo -e "\033[32mTerraform версия: $(terraform --version | head -n 1)\033[0m"
echo -e "\033[32mHelm версия: $(helm version --short)\033[0m"
echo -e "\033[32mk9s версия: $(k9s version | head -n 1)\033[0m"
echo -e "\033[32mMinikube версия: $(minikube version)\033[0m"
#echo -e "\033[32mkubectl версия: $(kubectl version | head -n 1)\033[0m"

echo -e "\033[35mВсе инструменты установлены и готовы к использованию!\033[0m"

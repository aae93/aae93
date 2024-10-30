#!/bin/bash

# Установка Homebrew
if ! command -v brew &> /dev/null; then
    echo "Установка Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Homebrew уже установлен."
fi

# Установка Ansible
if ! command -v ansible &> /dev/null; then
    echo "Установка Ansible..."
    brew install ansible
else
    echo "Ansible уже установлен."
fi

# Установка Terraform
if ! command -v terraform &> /dev/null; then
    echo "Установка Terraform..."
    brew tap hashicorp/tap
    brew install hashicorp/tap/terraform
else
    echo "Terraform уже установлен."
fi

# Установка Packer
#if ! command -v packer &> /dev/null; then
#    echo "Установка Packer..."
#    brew install hashicorp/tap/packer
#else
#    echo "Packer уже установлен."
#fi

# Установка Helm
if ! command -v helm &> /dev/null; then
    echo "Установка Helm..."
    brew install helm
else
    echo "Helm уже установлен."
fi

# Установка make
if ! command -v make &> /dev/null; then
    echo "Установка make..."
    brew install make
else
    echo "make уже установлен."
fi

# Установка k9s
if ! command -v k9s &> /dev/null; then
    echo "Установка k9s..."
    brew install k9s
else
    echo "k9s уже установлен."
fi


# Установка Minikube
echo "Установка Minikube..."
brew install minikube

# Установка hyperkit (Процессор INTEL)
#if ! command -v hyperkit &> /dev/null; then
#    echo "Установка hyperkit..."
#    brew install hyperkit
#else
#    echo "hyperkit уже установлен."
#fi

# Проверка и установка Docker Desktop (Универсальный вариант. Ручная установка)
#if ! command -v docker &> /dev/null; then
#    echo "Docker не установлен. Пожалуйста, установи Docker Desktop вручную: https://www.docker.com/products/docker-desktop/"
#    exit 1
#else
#    echo "Docker уже установлен."
#fi

# Определение архитектуры процессора
ARCH=$(uname -m)

# Установка Docker Desktop
if ! command -v docker &> /dev/null; then
    echo "Docker не установлен. Устанавливаю Docker Desktop..."

    if [[ "$ARCH" == "arm64" ]]; then
        echo "Обнаружен процессор Apple. Скачиваю Docker для мобильного процессора ..."
        curl -L -o Docker.dmg "https://desktop.docker.com/mac/stable/arm64/Docker.dmg"
    else
        echo "Скачиваю Docker для Intel..."
        curl -L -o Docker.dmg "https://desktop.docker.com/mac/stable/Docker.dmg"
    fi

    echo "Сейчас будет запрос пароля рута (на том)"
    # Монтируем и устанавливаем Docker
    hdiutil attach Docker.dmg
    sudo cp -R /Volumes/Docker/Docker.app /Applications
    hdiutil detach /Volumes/Docker

    # Удаляем скачанный установочный файл
    # rm Docker.dmg

    # Запускаем Docker Desktop
    open /Applications/Docker.app

    echo "Docker Desktop установлен. Пожалуйста, дождись завершения запуска Docker перед продолжением."
else
    echo "Docker уже установлен."
fi

# Ожидание запуска Docker
while ! docker system info > /dev/null 2>&1; do
    echo "Запускаю Docker..."
    sleep 5
done


# Запуск Minikube
echo "Запуск Minikube..."
#minikube start --driver=hyperkit (Процессор Intel)
minikube start --driver=docker


# Проверка статуса Minikube
echo "Проверка статуса Minikube..."
minikube status

# Установка kubectl
if ! command -v kubectl &> /dev/null; then
    echo "Установка kubectl..."
    brew install kubectl
else
    echo "kubectl уже установлен."
fi

# Проверка версий установленных пакетов
echo
echo "Проверка версий установленных пакетов:"
echo "Ansible версия: $(ansible --version | head -n 1)"
echo "Terraform версия: $(terraform --version | head -n 1)"
#echo "Packer версия: $(packer --version)"
echo "Helm версия: $(helm version --short)"
echo "$(make --version | head -n 1)"
echo "k9s версия: $(k9s version | sed -n 8p)"
echo "Minikube версия: $(minikube version | head -n 1)"


echo "Установка инструментов завершена"

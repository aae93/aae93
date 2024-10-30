#!/bin/bash

echo "Остановка Minikube, если он запущен..."
minikube stop

# Запуск кластера с тремя нодами
echo "Запуск Minikube"
minikube start --nodes 3 --driver=docker

# Проверка статуса Minikube
echo "Проверка статуса"
minikube status

# Добавление репозитория Argo CD в Helm
echo "Добавление репозитория Argo CD в Helm..."
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update

# Установка Argo CD в кластер
echo "Установка Argo CD в кластер..."
kubectl create namespace argocd
helm install argocd argo/argo-cd --namespace argocd --create-namespace

# Проверка установки Argo CD
echo "Проверка установки Argo CD..."
kubectl get pods -n argocd

# Вывод информации о том, как получить доступ к Argo CD
echo -e "\033[35mArgo CD установлен. Чтобы получить доступ к его интерфейсу, используйте следующие команды:\033[0m"
echo -e "\033[35mkubectl port-forward svc/argocd-server -n argocd 8080:443\033[0m"
echo -e "\033[32mБез привязки к текущему терминалу:\033[0m"
echo -e "\033[32mnohup kubectl port-forward svc/argocd-server -n argocd 8080:443 > port-forward.log 2>&1 &\033[0m"
echo -e "\033[35mТеперь вы можете открыть браузер и перейти по адресу: http://localhost:8080\033[0m"
echo -e "\033[32mСтандартное имя пользователя - admin\033[0m"
echo -e "\033[32mЧтобы получить пароль от ArgoCD - введи следующую команду:\033[0m"
echo -e "\033[32mkubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath=\"{.data.password}\" | base64 --decode; echo\033[0m"

echo "Установка кластера Minikube с Argo CD завершена!"

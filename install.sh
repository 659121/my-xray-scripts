#!/bin/bash

# ===== НАСТРОЙКИ =====
GITHUB_USER="659121"
GITHUB_REPO="my-xray-scripts"
BRANCH="main" # или master
# ====================

BASE_URL="https://raw.githubusercontent.com/${GITHUB_USER}/${GITHUB_REPO}/${BRANCH}"
INSTALL_DIR="/usr/local/bin"

echo "--- Установка скриптов управления Xray ---"

# 1. Установка зависимостей
echo "Проверка зависимостей..."
apt update -y
apt install -y curl jq qrencode

# 2. Список скриптов для скачивания
SCRIPTS=("xray-setup" "xray-qr" "xray-add" "xray-del")

# 3. Скачивание и установка
for script in "${SCRIPTS[@]}"; do
    echo "Загрузка $script..."
    curl -L -o "${INSTALL_DIR}/${script}" "${BASE_URL}/${script}"
    
    if [ $? -eq 0 ]; then
        chmod +x "${INSTALL_DIR}/${script}"
        echo "$script установлен."
    else
        echo "Ошибка при загрузке $script!"
    fi
done

echo ""
echo "--- Установка завершена! ---"
echo "Теперь запустите: sudo xray-setup"
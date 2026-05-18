#!/bin/bash

CONFIG_FILE="/usr/local/etc/xray/config.json"
VAR_FILE="/usr/local/etc/xray/settings.conf"

# Проверка прав
if [ "$EUID" -ne 0 ]; then echo "Запустите через sudo или root"; exit; fi

echo "--- Автоматическая настройка Xray Reality ---"

# 1. Получаем IP автоматически
SERVER_IP=$(curl -s https://api.ipify.org)
if [ -z "$SERVER_IP" ]; then
    echo "Ошибка: Не удалось получить IP адрес."
    exit 1
fi
echo "IP сервера: $SERVER_IP"

# 2. Константы (без вопросов)
PORT=443
SNI="www.microsoft.com"

# 3. Генерация ключей Reality
echo "Генерация ключей..."
KEYS=$(xray x25519)
PRIVATE_KEY=$(echo "$KEYS" | grep -i "private" | awk '{print $NF}')
PUBLIC_KEY=$(echo "$KEYS" | grep -i -E "public|password" | awk '{print $NF}')
HASH32=$(echo "$KEYS" | grep -i "hash" | awk '{print $NF}')

# 4. Сохраняем переменные для других скриптов (qr, add)
# Записываем в формат ключ=значение
cat <<EOF > $VAR_FILE
SERVER_IP=$SERVER_IP
PORT=$PORT
SNI=$SNI
PUBLIC_KEY=$PUBLIC_KEY
PRIVATE_KEY=$PRIVATE_KEY
HASH32=$HASH32
EOF

# 5. Создаем пустой конфиг (без пользователей)
# Пользователи добавятся через скрипт xray-add
cat <<EOF > $CONFIG_FILE
{
  "log": {"loglevel": "warning"},
  "inbounds": [
    {
      "listen": "0.0.0.0",
      "port": $PORT,
      "protocol": "vless",
      "settings": {
        "clients": [],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "tcp",
        "security": "reality",
        "realitySettings": {
          "dest": "$SNI:443",
          "serverNames": ["$SNI"],
          "privateKey": "$PRIVATE_KEY",
          "shortIds": [""]
        }
      },
      "sniffing": {
        "enabled": true,
        "destOverride": ["http", "tls", "quic"]
      }
    }
  ],
  "outbounds": [
    {"protocol": "freedom", "tag": "direct"},
    {"protocol": "blackhole", "tag": "block"}
  ]
}
EOF

chmod 644 $CONFIG_FILE
chmod 600 $VAR_FILE

echo "Конфигурация создана."
echo "Перезапуск Xray..."
systemctl restart xray
systemctl enable xray

echo ""
echo "=== УСПЕШНО ==="
echo "Сервер готов к работе."
echo "Public Key: $PUBLIC_KEY"
echo "Добавьте пользователя командой: xray-add"

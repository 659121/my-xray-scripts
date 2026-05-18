#!/bin/bash

CONFIG_FILE="/usr/local/etc/xray/config.json"

read -p "Введите имя нового пользователя: " NAME
if [ -z "$NAME" ]; then echo "Имя не может быть пустым"; exit; fi

NEW_UUID=$(xray uuid)

# Добавляем новый объект в массив clients
# jq возьмет текущий конфиг, добавит элемент и сохранит обратно
TMP=$(mktemp)
jq ".inbounds[0].settings.clients += [{\"id\": \"$NEW_UUID\", \"email\": \"$NAME\", \"flow\": \"xtls-rprx-vision\"}]" $CONFIG_FILE > "$TMP" && mv "$TMP" $CONFIG_FILE

chmod 644 $CONFIG_FILE

echo "Пользователь $NAME добавлен."
echo "UUID: $NEW_UUID"
echo "Перезапуск Xray..."
systemctl restart xray
echo "Готово! Чтобы получить QR, запустите xray-qr"

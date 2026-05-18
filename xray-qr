#!/bin/bash

CONFIG_FILE="/usr/local/etc/xray/config.json"
VAR_FILE="/usr/local/etc/xray/settings.conf"

if [ ! -f "$VAR_FILE" ]; then echo "Ошибка: Сначала запустите xray-setup"; exit; fi

source $VAR_FILE

# Читаем имена и UUID в массивы
mapfile -t EMAILS < <(jq -r '.inbounds[0].settings.clients[].email' $CONFIG_FILE)
mapfile -t UUIDS < <(jq -r '.inbounds[0].settings.clients[].id' $CONFIG_FILE)

if [ ${#EMAILS[@]} -eq 0 ]; then
    echo "Пользователи не найдены."
    exit
fi

echo "--- Выберите пользователя для QR-кода ---"

# Выводим список красиво
for i in "${!EMAILS[@]}"; do
    printf "%s) %s (UUID: ...%s)\n" "$((i+1))" "${EMAILS[$i]}" "${UUIDS[$i]: -4}"
done

read -p "Введите номер: " choice

# Проверка, что введено число
if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le ${#EMAILS[@]} ]; then
    index=$((choice-1))

    UUID="${UUIDS[$index]}"
    NAME="${EMAILS[$index]}"

    # Формируем ссылку (sid оставляем пустым, так как в конфиге он пуст)
    LINK="vless://${UUID}@${SERVER_IP}:${PORT}?security=reality&encryption=none&flow=xtls-rprx-vision&type=tcp&sni=${SNI}&fp=chrome&pbk=${PUBLIC_KEY}&sid=#${NAME}"

    echo ""
    echo $LINK
    echo ""
    echo "Генерация QR для: $NAME"
    qrencode -t ANSIUTF8 "$LINK"
else
    echo "Неверный выбор."
fi

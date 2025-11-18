#!/bin/bash

CONFIG_FILE="/usr/local/etc/xray/config.json"
BACKEND_FILE="/tmp/xray_backend.txt"

if [ ! -f "$BACKEND_FILE" ]; then
    read -p "Qual seu backend? (ex: app1): " backend
    [ -z "$backend" ] && exit 1
    echo "${backend#/}" | sed 's|/$||' > "$BACKEND_FILE"
fi

screen -dmS xray_backend bash -c "
backend=\$(<'$BACKEND_FILE')
new_path=\"/\$backend/\"

trap 'exit 0' INT TERM

while sleep 5; do
    current_path=\$(grep -m1 -o '\"path\": *\"[^\"]*\"' '$CONFIG_FILE' | cut -d'\"' -f4)
    [ \"\$current_path\" = \"\$new_path\" ] || sed -i 's|\"path\": *\"[^\"]*\"|\"path\": \"'\"\$new_path\"'\"|' '$CONFIG_FILE'
done
"

#!/bin/bash

pkill -f "x.sh"

read -p "Backend? " backend
echo "${backend#/}" | sed 's|/$||' > /tmp/xray_backend.txt

curl -s https://raw.githubusercontent.com/smoll-ops/tools/main/x.sh -o /usr/local/bin/xray-monitor.sh
chmod +x /usr/local/bin/xray-monitor.sh

cat > /etc/systemd/system/xray-monitor.service << EOF
[Unit]
Description=Xray Path Monitor
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/xray-monitor.sh
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable xray-monitor.service
systemctl start xray-monitor.service

echo "✅"

#!/bin/bash
mkdir -p "$HOME/.vnc"
echo "vscode" | vncpasswd -f > "$HOME/.vnc/passwd"
chmod 600 "$HOME/.vnc/passwd"

cat > "$HOME/.vnc/xstartup" <<'EOF'
#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
exec dbus-launch --exit-with-session startxfce4
EOF
chmod +x "$HOME/.vnc/xstartup"

[ -d "$HOME/noVNC" ] || git clone --depth 1 --branch v1.4.0 https://github.com/novnc/noVNC.git "$HOME/noVNC"

vncserver -kill :1 >/dev/null 2>&1
rm -f /tmp/.X1-lock /tmp/.X11-unix/X1
vncserver :1 -geometry 1440x900 -depth 24 -localhost yes

pkill -f "websockify.*6080" >/dev/null 2>&1
websockify -D --web="$HOME/noVNC" 6080 localhost:5901
echo "Desktop ready: open port 6080 and use password 'vscode'"

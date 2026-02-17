#!/bin/bash

echo "===== SYSTEM HYGIENE START ====="

# -----------------------------
# OS Detection
# -----------------------------
if [ -f /etc/debian_version ]; then
    OS="debian"
elif [ -f /etc/redhat-release ]; then
    OS="redhat"
else
    OS="unknown"
fi

echo "Detected OS: $OS"

# -----------------------------
# Updates
# -----------------------------
echo ">>> Updating system..."

if [ "$OS" = "debian" ]; then
    sudo apt update && sudo apt upgrade -y
elif [ "$OS" = "redhat" ]; then
    sudo yum update -y
else
    echo "Unsupported OS"
fi

# -----------------------------
# Cleanup packages
# -----------------------------
echo ">>> Cleaning unused packages..."

if [ "$OS" = "debian" ]; then
    sudo apt autoremove -y
    sudo apt autoclean
elif [ "$OS" = "redhat" ]; then
    sudo yum autoremove -y
    sudo yum clean all
fi

# -----------------------------
# Disk usage
# -----------------------------
echo ">>> Disk usage:"
df -h

echo ">>> Large files (>500MB):"
sudo find / -type f -size +500M 2>/dev/null

# -----------------------------
# Memory usage
# -----------------------------
echo ">>> Memory usage:"
free -h

# -----------------------------
# Zombie processes
# -----------------------------
echo ">>> Checking zombie processes:"
ps aux | awk '{ print $8 " " $2 }' | grep Z

# -----------------------------
# Failed services
# -----------------------------
echo ">>> Failed services:"
systemctl --failed

# -----------------------------
# Journal cleanup (systemd)
# -----------------------------
echo ">>> Cleaning old logs..."
sudo journalctl --vacuum-time=7d

# -----------------------------
# CPU Load
# -----------------------------
echo ">>> CPU Load:"
uptime

# -----------------------------
# Security quick checks
# -----------------------------
echo ">>> Listening ports:"
ss -tulnp

echo ">>> Last logins:"
last -a | head

# -----------------------------
# Temp cleanup
# -----------------------------
echo ">>> Cleaning /tmp..."
sudo rm -rf /tmp/*

echo "===== SYSTEM HYGIENE COMPLETE ====="

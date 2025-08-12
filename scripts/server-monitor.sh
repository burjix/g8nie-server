#!/bin/bash

# Server Monitoring Script
# Displays key metrics about server health

echo "======================================"
echo "        SERVER STATUS REPORT          "
echo "======================================"
echo "Date: $(date)"
echo ""

# System Info
echo "SYSTEM INFORMATION:"
echo "-------------------"
echo "Hostname: $(hostname)"
echo "IP Address: 188.166.46.109"
echo "Uptime: $(uptime -p)"
echo ""

# CPU Usage
echo "CPU USAGE:"
echo "----------"
echo "Load Average: $(uptime | awk -F'load average:' '{print $2}')"
top -bn1 | grep "Cpu(s)" | awk '{print "CPU Usage: " $2 + $4"%"}'
echo ""

# Memory Usage
echo "MEMORY USAGE:"
echo "-------------"
free -h | grep -E "^Mem|^Swap"
echo ""

# Disk Usage
echo "DISK USAGE:"
echo "-----------"
df -h | grep -E "^/dev/" | awk '{print $1 " - Used: " $3 "/" $2 " (" $5 ")"}'
echo ""

# Service Status
echo "SERVICE STATUS:"
echo "---------------"
services=("nginx" "postgresql" "redis-server" "fail2ban" "pm2-root")
for service in "${services[@]}"; do
    if systemctl is-active --quiet $service; then
        echo "✓ $service: Running"
    else
        echo "✗ $service: Not Running"
    fi
done
echo ""

# Network Connections
echo "NETWORK CONNECTIONS:"
echo "--------------------"
echo "Active connections: $(ss -tun | tail -n +2 | wc -l)"
echo "Listening ports:"
ss -tulpn | grep LISTEN | awk '{print "  " $5}' | sort -u
echo ""

# Recent Auth Logs
echo "RECENT AUTH ATTEMPTS (last 5):"
echo "-------------------------------"
tail -5 /var/log/auth.log | grep -E "sshd|sudo" || echo "No recent auth attempts"
echo ""

echo "======================================"
echo "         END OF REPORT                "
echo "======================================
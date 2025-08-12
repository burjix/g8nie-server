# G8NIE Server Setup Documentation

## Server Information
- **IP Address**: 188.166.46.109
- **Domain**: g8nie.com
- **OS**: Ubuntu 24.04 LTS
- **Hostname**: claude-server

## Installed Services

### 1. Web Server (Nginx)
- **Status**: Active and configured
- **Config**: `/etc/nginx/sites-available/g8nie.com`
- **Web Root**: `/var/www/g8nie.com`
- **Features**: Gzip compression, security headers, caching

### 2. Database (PostgreSQL)
- **Version**: 16
- **Users**: 
  - postgres (admin): Password: `G8nie2025SecureDB!`
  - appuser (application): Password: `App2025SecurePass!`
- **Config**: `/etc/postgresql/16/main/postgresql.conf`

### 3. Cache (Redis)
- **Status**: Active
- **Max Memory**: 256MB
- **Eviction Policy**: allkeys-lru

### 4. Process Manager (PM2)
- **Status**: Configured with systemd
- **Commands**:
  - `pm2 list` - View running apps
  - `pm2 monit` - Real-time monitoring
  - `pm2 logs` - View logs

### 5. Security

#### Firewall (UFW)
- **Allowed Ports**: 22 (SSH), 80 (HTTP), 443 (HTTPS)

#### Fail2ban
- **Config**: `/etc/fail2ban/jail.local`
- **Protected Services**: SSH, Nginx
- **Ban Time**: 1 hour
- **Max Retries**: 3-5 depending on service

### 6. Git & GitHub
- **SSH Key**: Added to `/root/.ssh/id_ed25519`
- **Public Key for GitHub**:
```
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJegvgS4WvGjuXKMo3nn7jCOPrLSNAkrLrgMsbUlpy0D skander@g8nie.com
```

## Important Scripts

### 1. Deploy Application
```bash
/home/claude/scripts/deploy-app.sh <app-name> <git-repo> <port>
```

### 2. Server Monitoring
```bash
/home/claude/scripts/server-monitor.sh
```

## DNS Configuration Required

To complete the setup, configure your domain DNS:

1. **A Records**:
   - `g8nie.com` → 188.166.46.109
   - `www.g8nie.com` → 188.166.46.109

2. **After DNS Propagation**, enable SSL:
```bash
certbot --nginx -d g8nie.com -d www.g8nie.com
```

## Quick Commands

### Service Management
```bash
# Check service status
systemctl status nginx
systemctl status postgresql
systemctl status redis-server
systemctl status fail2ban

# Restart services
systemctl restart nginx
systemctl restart postgresql
systemctl restart redis-server
```

### Database Access
```bash
# Connect to PostgreSQL
sudo -u postgres psql

# Connect as app user
psql -U appuser -h localhost
```

### Monitoring
```bash
# System resources
htop

# Disk usage
ncdu /

# I/O monitoring
iotop

# Network connections
ss -tulpn

# Nginx logs
tail -f /var/log/nginx/access.log
tail -f /var/log/nginx/error.log
```

### PM2 Management
```bash
# List apps
pm2 list

# View logs
pm2 logs

# Restart app
pm2 restart <app-name>

# Monitor
pm2 monit
```

## Security Best Practices

1. **Regular Updates**:
```bash
apt update && apt upgrade -y
```

2. **Check Failed Login Attempts**:
```bash
fail2ban-client status sshd
```

3. **Review Auth Logs**:
```bash
tail -f /var/log/auth.log
```

4. **Firewall Status**:
```bash
ufw status verbose
```

## Performance Optimizations Applied

1. **PostgreSQL**: Increased shared_buffers to 256MB
2. **Redis**: Configured with 256MB max memory and LRU eviction
3. **Nginx**: Enabled gzip compression and static file caching
4. **PM2**: Configured for cluster mode with auto-restart

## Next Steps

1. ✅ Add GitHub SSH key to your account
2. ✅ Configure DNS A records for g8nie.com
3. ✅ Wait for DNS propagation (usually 5-30 minutes)
4. ✅ Run SSL certificate setup
5. ✅ Deploy your first application

## Troubleshooting

### If services are down:
```bash
# Check status
systemctl status <service-name>

# View logs
journalctl -u <service-name> -n 50

# Restart
systemctl restart <service-name>
```

### If disk is full:
```bash
# Check disk usage
df -h

# Find large files
ncdu /

# Clean package cache
apt autoremove && apt autoclean
```

---
*Server configured on: 2025-08-12*
*Configuration by: Claude (Full Stack CTO)*
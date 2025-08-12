#!/bin/bash

# Universal App Deployment Script
# Usage: ./deploy-app.sh <app-name> <git-repo-url> <port>

APP_NAME=$1
GIT_REPO=$2
PORT=$3

if [ -z "$APP_NAME" ] || [ -z "$GIT_REPO" ] || [ -z "$PORT" ]; then
    echo "Usage: ./deploy-app.sh <app-name> <git-repo-url> <port>"
    echo "Example: ./deploy-app.sh myapp git@github.com:user/repo.git 3000"
    exit 1
fi

APP_DIR="/home/claude/projects/$APP_NAME"

echo "🚀 Deploying $APP_NAME..."

# Clone or update repository
if [ -d "$APP_DIR" ]; then
    echo "📂 Updating existing repository..."
    cd "$APP_DIR"
    git pull origin main
else
    echo "📥 Cloning repository..."
    git clone "$GIT_REPO" "$APP_DIR"
    cd "$APP_DIR"
fi

# Install dependencies
if [ -f "package.json" ]; then
    echo "📦 Installing Node.js dependencies..."
    npm ci --production
fi

if [ -f "requirements.txt" ]; then
    echo "🐍 Installing Python dependencies..."
    pip3 install -r requirements.txt
fi

if [ -f "Gemfile" ]; then
    echo "💎 Installing Ruby dependencies..."
    bundle install
fi

# Database migrations
if [ -f "migrate.js" ] || [ -f "migrate.py" ] || [ -f "db/migrate" ]; then
    echo "🗄️ Running database migrations..."
    if [ -f "migrate.js" ]; then
        node migrate.js
    elif [ -f "migrate.py" ]; then
        python3 migrate.py
    fi
fi

# Build assets
if [ -f "webpack.config.js" ] || [ -f "vite.config.js" ]; then
    echo "🏗️ Building assets..."
    npm run build
fi

# Configure PM2 for Node.js apps
if [ -f "package.json" ]; then
    echo "⚙️ Configuring PM2..."
    
    # Create ecosystem file
    cat > ecosystem.config.js << EOF
module.exports = {
  apps: [{
    name: '$APP_NAME',
    script: './index.js',
    instances: 'max',
    exec_mode: 'cluster',
    env: {
      NODE_ENV: 'production',
      PORT: $PORT
    },
    error_file: '/home/claude/logs/$APP_NAME-error.log',
    out_file: '/home/claude/logs/$APP_NAME-out.log',
    log_date_format: 'YYYY-MM-DD HH:mm:ss Z',
    merge_logs: true,
    max_memory_restart: '500M'
  }]
};
EOF
    
    # Start or restart with PM2
    pm2 delete "$APP_NAME" 2>/dev/null || true
    pm2 start ecosystem.config.js
    pm2 save
fi

# Configure Nginx
echo "🌐 Configuring Nginx..."
cat > /etc/nginx/sites-available/$APP_NAME << EOF
server {
    listen 80;
    server_name $APP_NAME.g8nie.com;

    location / {
        proxy_pass http://localhost:$PORT;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF

ln -sf /etc/nginx/sites-available/$APP_NAME /etc/nginx/sites-enabled/
nginx -t && systemctl reload nginx

echo "✅ Deployment complete!"
echo "📍 App running at: http://$APP_NAME.g8nie.com"
echo "📊 Monitor with: pm2 monit $APP_NAME"
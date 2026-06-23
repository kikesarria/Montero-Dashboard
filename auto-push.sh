#!/bin/bash
# Auto-push dashboard a GitHub cuando cambia el archivo
REPO="/Users/kike/montero-dashboard"
HASH_FILE="/tmp/dashboard_last_hash"
FILE="$REPO/index.html"

# Hash actual del archivo
CURRENT=$(md5 -q "$FILE" 2>/dev/null)
PREV=$(cat "$HASH_FILE" 2>/dev/null || echo "")

if [ "$CURRENT" != "$PREV" ]; then
    echo "[$(date)] Cambio detectado — subiendo a GitHub..." >> /tmp/dashboard-push.log
    cd "$REPO"
    git add index.html
    git commit -m "Dashboard actualizado automaticamente $(date '+%Y-%m-%d %H:%M')"
    git push origin main >> /tmp/dashboard-push.log 2>&1
    echo "$CURRENT" > "$HASH_FILE"
    echo "[$(date)] OK — Vercel redespliegando" >> /tmp/dashboard-push.log
else
    echo "[$(date)] Sin cambios" >> /tmp/dashboard-push.log
fi

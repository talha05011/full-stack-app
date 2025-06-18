#!/bin/bash

# Health check for frontend (port 3000) and backend (port 5000)
# Returns 0 if healthy, 1 if any service fails

# Configuration
FRONTEND_PORT=3000
BACKEND_PORT=5000
MAX_RETRIES=2
TIMEOUT_SEC=5

# Slack/webhook notification (optional)
SLACK_WEBHOOK="https://hooks.slack.com/services/..." # Replace with your webhook
NOTIFY=true

# Log file
LOG_FILE="/var/log/healthcheck.log"

# Timestamp
timestamp() {
  date +"%Y-%m-%d %T"
}

# Notify function
notify() {
  if [ "$NOTIFY" = true ]; then
    curl -X POST -H 'Content-type: application/json' \
    --data "{\"text\":\"$1\"}" \
    $SLACK_WEBHOOK >/dev/null 2>&1
  fi
  echo "$(timestamp) - $1" >> $LOG_FILE
}

# Check service health
check_service() {
  local SERVICE=$1
  local PORT=$2
  local RETRY=0
  
  while [ $RETRY -lt $MAX_RETRIES ]; do
    HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" --max-time $TIMEOUT_SEC http://localhost:$PORT/health)
    
    if [ "$HTTP_STATUS" = "200" ]; then
      echo "$(timestamp) - $SERVICE healthy (HTTP $HTTP_STATUS)" >> $LOG_FILE
      return 0
    fi
    
    RETRY=$((RETRY+1))
    sleep 1
  done
  
  notify "🚨 $SERVICE unhealthy! HTTP status: ${HTTP_STATUS:-Timeout}"
  return 1
}

# Main execution
FRONTEND_FAILED=0
BACKEND_FAILED=0

check_service "frontend" $FRONTEND_PORT || FRONTEND_FAILED=1
check_service "backend" $BACKEND_PORT || BACKEND_FAILED=1

# Auto-rollback if enabled
if [ $FRONTEND_FAILED -eq 1 ]; then
  if [ -f "/home/ubuntu/last_stable_frontend" ]; then
    LAST_GOOD=$(cat /home/ubuntu/last_stable_frontend)
    notify "Attempting frontend rollback to $LAST_GOOD"
    docker stop frontend && docker rm frontend
    docker run -d -p $FRONTEND_PORT:$FRONTEND_PORT --name frontend $LAST_GOOD
  fi
fi

if [ $BACKEND_FAILED -eq 1 ]; then
  if [ -f "/home/ubuntu/last_stable_backend" ]; then
    LAST_GOOD=$(cat /home/ubuntu/last_stable_backend)
    notify "Attempting backend rollback to $LAST_GOOD"
    docker stop backend && docker rm backend
    docker run -d -p $BACKEND_PORT:$BACKEND_PORT -e DB_HOST=$DB_HOST --name backend $LAST_GOOD
  fi
fi

# Exit code (0 = all healthy, 1 = any failed)
[ $FRONTEND_FAILED -eq 0 ] && [ $BACKEND_FAILED -eq 0 ] || exit 1

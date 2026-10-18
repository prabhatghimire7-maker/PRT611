#!/usr/bin/env bash
set -u

# Worker in the background; restarts itself if it crashes
(
  while true; do
    PORTAL_ROLE=worker python -m pipeline.railway_worker
    echo "worker exited with code $?, restarting in 30s" >&2
    sleep 30
  done
) &

# Web in the foreground; Railway monitors this process
PORTAL_ROLE=web exec gunicorn app.app:server --bind 0.0.0.0:$PORT --workers 1 --threads 4 --timeout 180

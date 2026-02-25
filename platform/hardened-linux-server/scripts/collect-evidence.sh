#!/usr/bin/env bash
set -euo pipefail

DATE="${1:-$(date +%d%m%Y)}"
EVDIR="$HOME/evidence-hardened-linux-$DATE"

mkdir -p "$EVDIR"

sudo ufw status verbose  | tee "$EVDIR/ufw-status.txt"
sudo ufw status numbered | tee "$EVDIR/ufw-status-numbered.txt"

( id ops; id app; sudo -l -U ops; sudo -l -U app ) \
  | tee "$EVDIR/users-sudo.txt"

( sudo systemctl status ssh --no-pager; sudo ss -lntp | grep ':22' || true ) \
  | tee "$EVDIR/ssh-status.txt"

echo "Evidence folder: $EVDIR"
ls -la "$EVDIR"


# Hardened Linux Server — Baseline (UFW + Users)

Goal (simple): make a Linux “house” safer:
- Users = who has keys (and who is admin)
- UFW = the fence that blocks unwanted doors (only SSH allowed)

## Environment
- Ubuntu 24.04 LTS (noble) on OrbStack (arm64)
- Hostname: ubuntu-clean
- Evidence date: 25022026

## What was done

### Users
- Created:
  - `ops` (admin): member of `sudo`
  - `app` (standard): no sudo privileges
- Validated with:
  - `groups ops`, `groups app`
  - `sudo -l -U ops`, `sudo -l -U app`

### Firewall (UFW)
- Default: deny incoming / allow outgoing / deny routed
- Allowed inbound: `22/tcp` (SSH)
- Logging: on (low)

## Validation (DoD)
Run on the server:
- `sudo ufw status verbose`
- `sudo ufw status numbered`
- `id ops && id app`
- `sudo -l -U ops && sudo -l -U app`
- `sudo systemctl status ssh --no-pager`
- `sudo ss -lntp | grep ':22'`

## Evidence
Evidence files are stored centrally in the repo:
- `evidence/01-week1/hardened-linux-server/25022026/`
  - `ufw-status.txt`
  - `ufw-status-numbered.txt`
  - `users-sudo.txt`
  - `ssh-status.txt`

## Automation
See `scripts/collect-evidence.sh` to regenerate evidence outputs on the server.
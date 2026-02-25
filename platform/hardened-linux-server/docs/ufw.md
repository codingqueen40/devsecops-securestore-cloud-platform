# UFW baseline

## Policy
- Default incoming: deny
- Default outgoing: allow
- Default routed: deny
- Allowed inbound: SSH 22/tcp
- Logging: on (low)

## Commands used
- Install: `sudo apt install -y ufw`
- Defaults:
  - `sudo ufw default deny incoming`
  - `sudo ufw default allow outgoing`
- Allow SSH: `sudo ufw allow 22/tcp`
- Enable: `sudo ufw enable`
- Verify:
  - `sudo ufw status verbose`
  - `sudo ufw status numbered`

## Rollback
- Disable: `sudo ufw disable`
- Reset: `sudo ufw reset`
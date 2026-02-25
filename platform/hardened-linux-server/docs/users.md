# Users baseline

## Users created
- `ops` (admin): added to `sudo`
- `app` (standard): no sudo access

## Commands used
- Create:
  - `sudo adduser ops`
  - `sudo adduser app`
- Grant admin:
  - `sudo usermod -aG sudo ops`

## Validation
- `groups ops` includes `sudo`
- `sudo -l -U ops` => allowed
- `sudo -l -U app` => not allowed
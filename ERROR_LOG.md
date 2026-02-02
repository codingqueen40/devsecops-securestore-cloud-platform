# ERROR_LOG — Incidents, blocages & solutions

Ce fichier sert à capturer rapidement les erreurs rencontrées, le diagnostic, la résolution et la leçon retenue.

---

## Format standard (à copier pour chaque entrée)

### YYYY-MM-DD — <TITRE COURT>

#### Contexte

- Projet / composant :
- Objectif :
- Environnement : (local / VM / cloud)
- Contrainte : (temps, droits, réseau…)

#### Commande / action

```bash
# ce que j’ai fait
```

#### Erreur / Symptôme

- Message d’erreur exact :
- Ce que j’observe :

#### Diagnostic

- Hypothèses :
- Vérifications :
```bash
# commandes de vérification
```

#### Fix / Résolution

```bash
# commandes correctives
```

#### Validation (preuve que c’est réglé)

```bash
# commande + résultat attendu
```

#### Leçon / Prévention

- Ce que je ferai directement la prochaine fois :
- Runbook lié : (lien si existant)
- Evidence : (captures / logs à archiver)

---

## 2026-02-01 — SSH : Permission denied (publickey) + host key changed

#### Contexte

- Projet / composant : Lab Ubuntu (OrbStack) — accès SSH depuis macOS  
- Objectif : établir un SSH sécurisé par clé, puis durcir (password off / root off)  
- Environnement : macOS (client SSH) → Ubuntu 24.04 (VM OrbStack)  
- Contrainte : la cible (domain OrbStack / IP) peut changer après clone/restart

#### Commande / action

```bash
ssh -i ~/.ssh/orbstack_ed25519 grey972_c@ubuntu.orb.local
# puis tests en verbose
ssh -vvv -i ~/.ssh/orbstack_ed25519 grey972_c@ubuntu.orb.local
```

#### Erreur / Symptôme

- `Permission denied (publickey).`
- Puis plus tard : `REMOTE HOST IDENTIFICATION HAS CHANGED!`

#### Diagnostic

- Vérifier si le port 22 est accessible sur la bonne IP (celle affichée dans OrbStack) :
```bash
nc -vz 192.168.139.25 22
```

- Vérifier si `sshd` écoute côté Ubuntu :
```bash
sudo ss -tulpn | grep :22 || sudo netstat -tulpn | grep :22
```

- Vérifier la présence et les permissions des clés côté Ubuntu :
```bash
whoami
ls -ld ~ ~/.ssh ~/.ssh/authorized_keys
cat -n ~/.ssh/authorized_keys
```

- Vérifier la config effective SSH (et confirmer password/root) :
```bash
sudo sshd -T | egrep 'pubkeyauthentication|passwordauthentication|permitrootlogin|kbdinteractiveauthentication'
```

- Quand `REMOTE HOST IDENTIFICATION HAS CHANGED` apparaît : l’empreinte a changé (clone/rebuild), il faut nettoyer `known_hosts` :
```bash
ssh-keygen -R ubuntu.orb.local
# ou si connexion par IP :
ssh-keygen -R 192.168.139.25
```

#### Fix / Résolution

- Installer/activer OpenSSH si nécessaire :
```bash
sudo apt update
sudo apt install -y openssh-server
sudo systemctl enable --now ssh
```

- Se connecter via IP (plus fiable que certains domains OrbStack pour diagnostiquer) :
```bash
ssh -i ~/.ssh/orbstack_ed25519 grey972_c@192.168.139.25
```

- Durcir SSH (clé uniquement + root interdit) dans `/etc/ssh/sshd_config` :
```conf
# --- Hardening lab ---
PasswordAuthentication no
PermitRootLogin no
PubkeyAuthentication yes
```

- Recharger SSH sans casser les sessions :
```bash
sudo systemctl reload ssh
```

#### Validation (preuve que c’est réglé)

- Depuis Ubuntu, confirmer les valeurs effectives :
```bash
sudo sshd -T | egrep 'permitrootlogin|passwordauthentication|pubkeyauthentication'
# attendu :
# permitrootlogin no
# passwordauthentication no
# pubkeyauthentication yes
```

- Depuis macOS, confirmer l’auth par clé (alias ou IP) :
```bash
ssh -v ubuntu-lab
# ou :
ssh -v -i ~/.ssh/orbstack_ed25519 grey972_c@192.168.139.25
# attendu :
# Authenticated ... using "publickey".
```

#### Leçon / Prévention

- Toujours tester d’abord : IP + port 22 (`nc -vz <IP> 22`) avant d’accuser la clé.
- Les clones/redémarrages peuvent changer le host key → nettoyer `known_hosts`.
- Conserver un runbook “SSH access” et un clone baseline stable.
- Runbook lié : `RUNBOOK — Accès SSH OrbStack Ubuntu`
- Evidence : captures OrbStack (IP), logs `ssh -v`, sortie `sshd -T`, capture clone baseline.
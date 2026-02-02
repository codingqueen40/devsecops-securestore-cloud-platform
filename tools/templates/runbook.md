# RUNBOOK — <TITLE>

> But : documenter une procédure actionnable “comme en prod”.
> Ce document doit permettre de résoudre un incident même sous stress.

---

## 1) Contexte
- **Service / composant :**
- **Environnement :** (local / VM / cloud)
- **Owner :**
- **Priorité :** Low / Med / High
- **Dernière mise à jour :** YYYY-MM-DD

---

## 2) Symptômes (what you see)
- Symptôme 1 :
- Symptôme 2 :
- Message(s) d’erreur :
- Ce qui est impacté :

---

## 3) Prérequis / accès
- Accès requis : (SSH, console cloud, droits admin…)
- Outils requis : (cli, scripts, UI…)
- Variables utiles : (IP, user, region…)

---

## 4) Checks rapides (5 minutes max)
> Objectif : confirmer ou éliminer les causes fréquentes.

### 4.1 Réseau / accessibilité
```bash
# ex : vérifier port / DNS
# nc -vz <IP> 22
# ping <host>
# dig <host> +short
```

### 4.2 Service / process
```bash
# ex : état du service / processus / ports
# systemctl status <service>
# ps aux | grep <process>
# ss -tulpn | grep :<port>
```

### 4.3 Config / permissions
```bash
# ex : fichiers de config + permissions
# ls -la /path/to/config
# cat /path/to/config
# sudo -l
```

---

## 5) Diagnostic approfondi
> Objectif : obtenir une preuve claire de la cause racine.

### Hypothèse A — <EXEMPLE>
```bash
# commandes de vérification
```

### Hypothèse B — <EXEMPLE>
```bash
# commandes de vérification
```

### Hypothèse C — <EXEMPLE>
```bash
# commandes de vérification
```

---

## 6) Procédure de résolution (pas à pas)
> Écrire en étapes courtes, reproductibles, et sécurisées.

1) Étape 1 — …
```bash
# commande
```

2) Étape 2 — …
```bash
# commande
```

3) Étape 3 — …
```bash
# commande
```

---

## 7) Validation (done when)
> Comment prouver que le problème est réglé.

### Test fonctionnel
```bash
# commande + résultat attendu
```

### Test logs / monitoring
```bash
# commande + résultat attendu
```

---

## 8) Rollback / plan B
> Que faire si la résolution échoue.

### Rollback
```bash
# commande
```

### Alternative
```bash
# commande
```

---

## 9) Evidence à collecter
> Permet d’alimenter `evidence/` et un éventuel postmortem.

- [ ] Logs (chemins / commandes) :
- [ ] Captures (UI / terminal) :
- [ ] Configs modifiées (fichiers / diff) :
- [ ] Lien PR / commit :
- [ ] Timeline courte :

---

## 10) Post-actions
- Postmortem nécessaire ? Oui / Non
- Actions correctives (tickets) :
- Mise à jour documentation : (liens)
- ADR nécessaire ? Oui / Non
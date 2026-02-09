# JOURNAL — DevSecOps Securestore Cloud Platform

## Semaine 0 — Préparation (26 Jan → 1 Fév 2026)

### Objectifs
- Initialiser le repo monorepo + arborescence
- Ajouter les templates (runbook, postmortem, security review, ADR)
- Mettre en place un CI minimal (GitHub Actions)
- Démarrer un système de documentation (index, journal, error log)

### Livrables
- Structure repo + fichiers standards
- Templates Markdown prêts
- Workflow GitHub Actions opérationnel
- Evidence initiale dans `evidence/00-week0/`

#### AWS — Compte Free Tier + IAM + MFA (terminé)

- ✅ AWS CLI installé et vérifié (`aws --version`)
- ✅ Root : MFA activé
- ✅ IAM users créés :
  - `grey-admin` : accès console + `AdministratorAccess` + MFA (TOTP)
  - `grey-ops` : accès console + MFA (TOTP) + permissions via groupe
- ✅ Groupe IAM :
  - `grp-ops` : `PowerUserAccess` + `IAMUserChangePassword`
  - `grey-ops` ajouté au groupe

**Choix retenus**
- Pas de clés d’accès long-terme sur root / `grey-admin` (sécurité + hygiène).
- Séparation des usages : admin (IAM/config) vs ops (labs).

**Problèmes rencontrés**
- Accès refusé sur `grey-ops` tant qu’il n’était pas membre de `grp-ops` / policies non attachées → corrigé en ajoutant `grey-ops` au groupe + reconnexion.

**Evidence**
- `evidence/00-week0/2026-02-09_aws-iam-mfa/` (screenshots CLI + IAM + MFA)

### Notes / points appris
- Standardiser la documentation dès le départ évite la dette plus tard.
- Sécuriser la base (scan secrets + clés SSH) est prioritaire.

### Next (Semaine 1)
- Démarrer le premier lab Linux/hardening (UFW, SSH, Fail2Ban) + runbook associé
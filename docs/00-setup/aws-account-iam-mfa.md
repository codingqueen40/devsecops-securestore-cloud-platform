# AWS Account Setup — IAM users + MFA (root + admin + ops)

> Objectif : sécuriser le compte AWS dès le départ et travailler au quotidien avec des utilisateurs IAM (pas le root), protégés par MFA.

---

## Pourquoi root MFA + IAM users

### Root (compte racine)
- Le **root** a **tous les droits** sur le compte (facturation, fermeture du compte, changements critiques).
- Il doit être utilisé **rarement** (uniquement pour les actions “account-level”).
- **MFA sur root = non négociable** : barrière essentielle contre le vol de compte.

### IAM users (usage quotidien)
On a créé **deux utilisateurs IAM** :
- `grey-admin` : administration AWS (console), protégé par MFA.
- `grey-ops` : usage “ops/labs” au quotidien (console + labs), protégé par MFA et permissions via groupe.

> But : ne jamais travailler avec root, et séparer un compte “admin” d’un compte “ops” (bonne pratique + moins de risques).

---

## Utilisateurs créés

### `grey-admin` (admin)
- Accès console : **oui**
- MFA : **oui (TOTP)**
- Permissions : **AdministratorAccess** (directement attachée)
- Usage : actions d’admin IAM / configuration globale / dépannage permissions

### `grey-ops` (ops / labs)
- Accès console : **oui**
- MFA : **oui (TOTP)**
- Permissions : via groupe `grp-ops` (ex: `PowerUserAccess`)
- Usage : exécution des labs / services AWS courants sans être “full admin”

---

## Étapes — Création de `grey-admin` + permissions

1. AWS Console → **IAM** → **Utilisateurs** → **Créer un utilisateur**
2. Nom : `grey-admin`
3. Cocher : **Fournir l’accès à la console**  
4. Mot de passe :
   - **auto-généré** (rapide) ou personnalisé
5. Cocher : **Demander un nouveau mot de passe à la prochaine connexion** (recommandé)
6. Permissions :
   - Option choisie : **Attacher directement des politiques**
   - Policy attachée : `AdministratorAccess`
7. Créer l’utilisateur

✅ Résultat attendu : `grey-admin` existe et a `AdministratorAccess`.

---

## Étapes — Groupe `grp-ops` + utilisateur `grey-ops` + policies

### 1) Créer le groupe `grp-ops`
1. IAM → **Groupes de personnes** → **Créer un groupe**
2. Nom : `grp-ops`
3. Attacher les policies gérées AWS :
   - `PowerUserAccess`
   - `IAMUserChangePassword`

> Pourquoi ces policies ?
- **PowerUserAccess** : assez large pour la majorité des labs (EC2, S3, CloudWatch, etc.) sans full admin.
- **IAMUserChangePassword** : l’utilisateur peut gérer son mot de passe.

### 2) Créer l’utilisateur IAM `grey-ops`
1. IAM → **Utilisateurs** → **Créer un utilisateur**
2. Nom : `grey-ops`
3. Cocher : **Fournir l’accès à la console**
4. Mot de passe : auto-généré ou personnalisé
5. Cocher : **Demander un nouveau mot de passe à la prochaine connexion**
6. Permissions :
   - Choisir : **Ajouter l’utilisateur à un groupe**
   - Sélectionner : `grp-ops`
7. Créer l’utilisateur

✅ Résultat attendu : `grey-ops` hérite des permissions via `grp-ops`.

---

## Étapes — Activer MFA TOTP sur `grey-admin` et `grey-ops`

### Qu’est-ce que TOTP ?
- **TOTP** = *Time-based One-Time Password*  
- Code à 6 chiffres qui change toutes les ~30 secondes dans une app (Google Authenticator, 1Password, Authy, etc.)

### Activer MFA (Virtual / Authenticator app)
À faire **pour chaque utilisateur** (`grey-admin` puis `grey-ops`) :

1. IAM → **Utilisateurs** → sélectionner l’utilisateur
2. Onglet **Informations d’identification de sécurité**
3. Section **MFA** → **Attribuer un dispositif MFA**
4. Choisir : **Application d’authentification** (Virtual MFA / TOTP)
5. Nom du device (ex) :
   - `AWS-IAM-grey-admin`
   - `AWS-IAM-grey-ops`
6. Scanner le QR code dans l’app d’auth
7. Entrer les codes demandés
8. Valider

✅ Résultat attendu : chaque user affiche **MFA (1)** avec un device “Virtual”.

---

## Choix retenus

### ✅ Pas de clés d’accès long-terme sur admin/root
- Pas d’**Access Keys** pour root ni `grey-admin`.
- Raison : éviter fuite de clés, compromission durable, erreurs d’hygiène sécurité.

### Séparation admin vs ops
- `grey-admin` : admin pur (IAM / configuration / dépannage)
- `grey-ops` : labs / usage quotidien (permissions via groupe)

> Si un jour on a besoin d’AWS CLI durable “propre”, on privilégie :
- Identity Center / SSO,
- ou rôles + sessions temporaires,
plutôt que des clés permanentes.

---

## Troubles rencontrés + solutions

### 1) “Accès refusé” côté `grey-ops`
**Symptômes**
- Erreurs `Access denied` sur certains écrans/actions.

**Cause**
- `grey-ops` n’avait pas encore les permissions suffisantes tant que :
  - il n’était pas dans `grp-ops`,
  - ou que `PowerUserAccess` n’était pas attachée au groupe.

**Solution**
- Vérifier : IAM → `grp-ops` → onglet **Personnes** → `grey-ops` présent.
- Vérifier : IAM → `grp-ops` → onglet **Autorisations** → `PowerUserAccess` attachée.
- Se déconnecter/reconnecter (rafraîchissement permissions).

---

## Checklist de validation (rapide)

- [ x] Root : MFA activé ✅
- [x ] `grey-admin` :
- [ x] `AdministratorAccess`
- [ x] MFA (TOTP) actif
- [x ] `grp-ops` :
- [x ] `PowerUserAccess`
- [x ] `IAMUserChangePassword`
- [x ] `grey-ops` :
- [x ] membre de `grp-ops`
- [x ] MFA (TOTP) actif

---

## Evidence (à archiver)

Dossier recommandé :
- `evidence/00-week0/2026-02-09_aws-iam-mfa/`

---
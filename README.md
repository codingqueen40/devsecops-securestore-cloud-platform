# DevSecOps – Securestore Cloud Platform

Monorepo fil rouge (2026–2028) pour construire une plateforme cloud-native sécurisée, avec preuves, runbooks et documentation exploitable en entretien (DevSecOps / Cloud Security).

## Objectifs
- Construire des fondations solides : infra, sécurité, gouvernance, automatisation CI.
- Documenter “comme en prod” : runbooks, postmortems, ADRs, journal, error log.
- Produire des **preuves** réutilisables (screens, logs, exports) par semaine.

## Structure du repo
- `platform/` : implémentation plateforme (infra, services, app)  
- `security/` : durcissement, IAM, threat modeling, contrôles  
- `governance/` : décisions (ADR), politiques, standards  
- `docs/` : documentation et index  
- `tools/` : scripts + templates Markdown  
- `evidence/` : preuves par sprint/semaine (captures, logs, exports)

## Workflow
- Chaque tâche importante => 1 trace dans `JOURNAL.md`
- Chaque incident/blocage => 1 entrée dans `ERROR_LOG.md`
- Chaque décision structurante => 1 ADR dans `tools/templates/adr.md` puis copiée dans `governance/adr/` (plus tard)

## CI
GitHub Actions exécute :
- checks “foundation”
- lint Markdown
- scan de secrets
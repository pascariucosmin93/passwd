# Passwd GitOps

Password manager local bazat pe Vaultwarden, pregatit pentru:

- build si push imagine Docker in `ghcr.io`
- deploy prin Argo CD din acest repo
- acces web pe `https://passwd.cosmin-lab.com`

## Structura

- `Dockerfile` - imaginea aplicatiei
- `base/` - manifestele Kubernetes de baza
- `overlays/prod/` - overlay-ul pe care il urmareste Argo
- `argocd/application.yaml` - exemplu de `Application` pentru Argo CD
- `.github/workflows/production.yaml` - build, push, update tag GitOps
- `.github/workflows/validate.yaml` - validare la PR si manual
- `scripts/generate-secret.sh` - genereaza secretul local pentru overlay

## Fluxul de deploy

1. Faci push in `main`.
2. GitHub Actions construieste imaginea si o publica in `ghcr.io/pascariucosmin93/passwd:<git-sha>`.
3. Workflow-ul actualizeaza `overlays/prod/kustomization.yaml` cu noul tag.
4. Argo CD detecteaza commitul si face sync in cluster.

## Ce trebuie setat in GitHub

- repo `passwd` trebuie sa aiba Actions activate
- package-ul GHCR trebuie sa poata fi tras din cluster
  - fie faci imaginea publica
  - fie clusterul foloseste un `imagePullSecret`
- daca folosesti branch protection pe `main`, trebuie sa permiti push pentru `GITHUB_TOKEN` sau sa schimbi workflow-ul sa scrie intr-un repo GitOps separat

## Secretul aplicatiei

Secretul nu trebuie tinut in git. Genereaza-l local:

```bash
cd /home/cosmin/passwd
./scripts/generate-secret.sh passwd.cosmin-lab.com
```

Asta creeaza:

- `overlays/prod/secret.yaml`

Fisierul este ignorat de git.

## Deploy manual fara Argo

```bash
cd /home/cosmin/passwd
kubectl apply -k overlays/prod
```

## Argo CD

Manifestul pentru Argo este aici:

- [argocd/application.yaml](/home/cosmin/passwd/argocd/application.yaml:1)

Argo trebuie configurat sa urmareasca:

- repo: `https://github.com/pascariucosmin93/passwd.git`
- branch: `main`
- path: `overlays/prod`

## Fisiere pe care probabil le vei ajusta

- [overlays/prod/kustomization.yaml](/home/cosmin/passwd/overlays/prod/kustomization.yaml:1)
- [base/pvc.yaml](/home/cosmin/passwd/base/pvc.yaml:1)

## Note

- manifestele presupun `ingressClassName: nginx`
- manifestele presupun `cert-manager` cu `letsencrypt-prod`
- daca in cluster ai alt `StorageClass`, schimba `storageClassName` in PVC

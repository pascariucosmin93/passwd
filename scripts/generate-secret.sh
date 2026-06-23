#!/usr/bin/env bash

set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <domain>" >&2
  echo "Example: $0 passwd.cosmin-lab.com" >&2
  exit 1
fi

domain="$1"
admin_token="$(openssl rand -base64 32 | tr -d '\n')"

cat > /home/cosmin/passwd/overlays/prod/secret.yaml <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: vaultwarden-secret
  namespace: vaultwarden
type: Opaque
stringData:
  DOMAIN: "https://${domain}"
  ADMIN_TOKEN: "${admin_token}"
  SIGNUPS_ALLOWED: "false"
  WEBSOCKET_ENABLED: "true"
  ROCKET_PORT: "80"
  TZ: "Europe/Bucharest"
EOF

echo "Generated /home/cosmin/passwd/overlays/prod/secret.yaml"
echo "Admin token: ${admin_token}"

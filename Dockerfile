ARG VAULTWARDEN_VERSION=1.36.0
FROM vaultwarden/server:${VAULTWARDEN_VERSION}

LABEL org.opencontainers.image.title="passwd"
LABEL org.opencontainers.image.description="Vaultwarden deployment image for passwd.cosmin-lab.com"
LABEL org.opencontainers.image.source="https://github.com/pascariucosmin93/passwd"


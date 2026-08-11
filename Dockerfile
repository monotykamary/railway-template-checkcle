FROM operacle/checkcle:v1.6.0@sha256:c3d1729d4044898817c4615929252caf913a0077a3a1dc632adb342c2e0871b7

LABEL org.opencontainers.image.source="https://github.com/monotykamary/railway-template-checkcle"
LABEL org.opencontainers.image.version="1.6.0-railway.1"
LABEL org.opencontainers.image.licenses="MIT"

COPY railway-entrypoint.sh /app/railway-entrypoint.sh
RUN chmod 0755 /app/railway-entrypoint.sh

ENV CHECKCLE_HTTP_PORT=8090
ENV CHECKCLE_OPERATION_PORT=8091
ENV POCKETBASE_ENABLED=true

ENTRYPOINT ["/app/railway-entrypoint.sh"]

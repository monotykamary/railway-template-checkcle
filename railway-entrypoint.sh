#!/bin/sh
set -eu

: "${CHECKCLE_ADMIN_EMAIL:?CHECKCLE_ADMIN_EMAIL is required}"
: "${CHECKCLE_ADMIN_PASSWORD:?CHECKCLE_ADMIN_PASSWORD is required}"
: "${CHECKCLE_ENCRYPTION_KEY:?CHECKCLE_ENCRYPTION_KEY is required}"

DATA_DIR="${CHECKCLE_DATA_DIR:-/mnt/pb_data}"
DEFAULT_ADMIN_EMAIL="admin@example.com"

mkdir -p "$DATA_DIR"

if [ ! -f "$DATA_DIR/data.db" ] && [ -d /app/pb_data ] && [ -n "$(ls -A /app/pb_data 2>/dev/null)" ]; then
  cp -a /app/pb_data/. "$DATA_DIR"/
fi

/app/pocketbase superuser upsert \
  "$CHECKCLE_ADMIN_EMAIL" \
  "$CHECKCLE_ADMIN_PASSWORD" \
  --dir "$DATA_DIR" \
  --encryptionEnv CHECKCLE_ENCRYPTION_KEY

if [ "$CHECKCLE_ADMIN_EMAIL" != "$DEFAULT_ADMIN_EMAIL" ]; then
  /app/pocketbase superuser delete \
    "$DEFAULT_ADMIN_EMAIL" \
    --dir "$DATA_DIR" \
    --encryptionEnv CHECKCLE_ENCRYPTION_KEY >/dev/null 2>&1 || true
fi

/app/pocketbase serve \
  --http=0.0.0.0:8090 \
  --dir "$DATA_DIR" \
  --encryptionEnv CHECKCLE_ENCRYPTION_KEY 2>&1 | grep -vE 'REST API|Dashboard' &
pocketbase_pid=$!
operation_pid=''

shutdown() {
  if [ -n "$operation_pid" ]; then
    kill "$operation_pid" 2>/dev/null || true
  fi
  kill "$pocketbase_pid" 2>/dev/null || true
  wait 2>/dev/null || true
}
trap shutdown INT TERM EXIT

until curl -fsS http://127.0.0.1:8090/api/health >/dev/null; do
  if ! kill -0 "$pocketbase_pid" 2>/dev/null; then
    echo "PocketBase exited before becoming healthy." >&2
    exit 1
  fi
  sleep 1
done

/app/service-operation &
operation_pid=$!

while kill -0 "$pocketbase_pid" 2>/dev/null && kill -0 "$operation_pid" 2>/dev/null; do
  sleep 2
done

echo "A CheckCle process exited unexpectedly." >&2
exit 1

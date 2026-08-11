# CheckCle on Railway

A pinned, credential-safe Railway deployment for [CheckCle](https://github.com/operacle/checkcle), an open-source uptime and infrastructure monitoring platform.

The verified Deploy on Railway button is added only after the published route passes identity and topology checks.

## What this deploys

- CheckCle `v1.6.0`
- PocketBase `0.28.4` and the CheckCle operation service from the official image
- One persistent data volume with scheduled backups
- Generated administrator credentials and a generated PocketBase settings-encryption key

The adapter replaces the upstream public default password before the application starts and removes the seeded default superuser when a different administrator email is configured.

## First login

Read `CHECKCLE_ADMIN_EMAIL` and the generated `CHECKCLE_ADMIN_PASSWORD` from the service variables. Sign in to CheckCle and rotate the password.

## Important limits

- CheckCle monitors internet-reachable HTTP(S), TCP, DNS, and SSL targets from Railway's network location.
- Private LAN hosts are not reachable unless you deploy a supported CheckCle regional agent inside that network.
- ICMP ping depends on raw-socket capability and is treated as unavailable unless the target Railway runtime probe succeeds.
- Server and Docker metrics require separately deployed CheckCle agents; Docker socket access is intentionally not bundled.
- SMTP and notification providers require external credentials.

## Version pin

`operacle/checkcle:v1.6.0@sha256:c3d1729d4044898817c4615929252caf913a0077a3a1dc632adb342c2e0871b7`

No production service uses `latest`.

## Updating

1. Back up the CheckCle volume.
2. Review the upstream release and PocketBase migration notes.
3. Update the image tag and digest deliberately.
4. Validate login, HTTP/TCP/DNS/SSL monitors, notifications, retention jobs, persistence, and logs on a disposable Railway project.

## Upstream and license

- Source: https://github.com/operacle/checkcle
- Release: https://github.com/operacle/checkcle/releases/tag/v1.6.0
- Documentation: https://docs.checkcle.io
- License: MIT; see [`LICENSE`](LICENSE) and [`NOTICE`](NOTICE)

# Deploy and Host CheckCle on Railway

## About Hosting CheckCle

CheckCle is an open-source uptime, SSL, status-page, and server-monitoring platform. This template deploys stable release `v1.6.0` as one public Railway service with durable PocketBase storage and generated administrator credentials.

## Common Use Cases

- Monitor public HTTP and HTTPS endpoints
- Check TCP ports, DNS records, and TLS certificates
- Publish status pages and incidents
- Collect server metrics through separately deployed CheckCle agents

## Dependencies for CheckCle Hosting

### Deployment Dependencies

The template creates one `checkcle` service and one persistent volume mounted at `/mnt/pb_data`, with a backup schedule. No external database is required.

### Implementation Details

The CheckCle service owns the public HTTPS domain on port `8090`. The container runs PocketBase and CheckCle's operation service together, matching the upstream release topology. A narrow adapter rotates the upstream seeded administrator before serving traffic and encrypts PocketBase settings with a generated key.

Read `CHECKCLE_ADMIN_EMAIL` and the generated `CHECKCLE_ADMIN_PASSWORD` from the service variables, then sign in and rotate the password. Do not change the encryption key after data has been written.

Railway monitors internet-reachable targets from its own network location. LAN targets require a regional agent in that LAN. ICMP is available only when the Railway runtime grants raw-socket capability; HTTP(S), TCP, DNS, and SSL monitoring do not depend on it.

### Why Deploy CheckCle on Railway?

Railway provides HTTPS, persistent storage, scheduled backups, generated secrets, and a stable public location for continuous monitoring without exposing the upstream default credentials.

# Tailscale based AdguardHome docker image

This image is based on my [tailscale-node](https://github.com/ida-greuelr/tailscale-node) image. It will automatically connect to a tailscale network and start [AdguardHome](https://github.com/AdguardTeam/AdGuardHome/). The env vars for the tailscale connection can be found at the base image repo. Here are the diverging defaults:

| VAR | Default | Comment |
|-----|---------|---------|
| `TS_AUTHKEY`        | tskey-auth-XYZ  | **mandatory** |
| `TS_UP`             | true            | disable the setup of yout tailscale connection, e.g. debug purpose |
| `TS_ACCEPT_DNS`     | false           | --accept-dns on tailscale |
| `TS_CERT`           | true            | _tailscale will try to [fetch a SSL cert](https://tailscale.com/kb/1153/enabling-https/?q=https#provision-tls-certificates-for-your-devices)_ |
| `TS_HOSTNAME`       | ts-adguard      |  |

To run your ephemeral node simply exececute:

```shell
docker pull ghcr.io/ida-greuelr/ts-adguardhome:main
docker run --rm -it -e TS_AUTHKEY="tskey-auth-XYZ-XYZ" ghcr.io/ida-greuelr/ts-adguardhome:main
```

Take a look into the logs to check if tailscale and the corresponding certs are configured correctly. When AdGuardHome has started you should be able to access it on your tailscale name on port 3000 for initial setup.

By default the image is pre-configured to download a cert for your ts.net hostname, your cert and key can be found at `/etc/ssl/private/tailscale.{crt|key}`. You should be able to configure the encryption settings for AdGuardHome by using the cert and key file.

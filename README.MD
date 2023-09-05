# Tailscale based AdguardHome docker image

This image is based on my [tailscale-node](https://github.com/ida-greuelr/tailscale-node) image. It will automatically connect to a tailscale network and start [AdguardHome](https://github.com/AdguardTeam/AdGuardHome/). The env vars for the tailscale connection can be found at the base image repo. Here are the diverging defaults:

| VAR | Default | Comment |
|-----|---------|---------|
| `TS_AUTHKEY`        | tskey-auth-XYZ  | **mandatory** |
| `TS_UP`             | true            | disable the setup of yout tailscale connection, e.g. debug purpose |
| `TS_CERT`           | true            | _tailscale will try to [fetch a SSL cert](https://tailscale.com/kb/1153/enabling-https/?q=https#provision-tls-certificates-for-your-devices)_ |
| `TS_HOSTNAME`       | ts-adguard      |  |
| `AG_CONFIG_URL`     | ""              | A valid url which which provides a [template config](#template-config)|
| `AG_USER`           | admin           | This username will be used for the AdGuardHome admin panel if you provide a template config |
| `AG_HTPASSWD`       | admin123        | Same as user [details here](#ag_htpasswd) |

To run your ephemeral node simply exececute:

```shell
docker pull ghcr.io/ida-greuelr/ts-adguardhome:main
docker run --rm -it -e TS_AUTHKEY="tskey-auth-XYZ-XYZ" ghcr.io/ida-greuelr/ts-adguardhome:main
```

Take a look into the logs to check if tailscale and the corresponding certs are configured correctly. When AdGuardHome has started you should be able to access it on your tailscale name on port 3000 for initial setup.

By default the image is pre-configured to download a cert for your ts.net hostname, your cert and key can be found at `/etc/ssl/private/tailscale.{crt|key}`. You should be able to configure the encryption settings for AdGuardHome by using the cert and key file.

## Template config

You can copy an existing AdGuardHome.yaml and upload it to an web server. All you have to do before is to replace the users block like this:

```yaml
users:
  - name: ADMINUSER
    password: ADMINPASS
```

as well as the tls part for server name like this:

```yaml
tls:
  enabled: true
  server_name: SERVERNAME
  certificate_path: /etc/ssl/private/tailscale.crt
  private_key_path: /etc/ssl/private/tailscale.key

```

The startup script inside the container will check for the three AG env vars to be set, downloads the config from ${AG_CONFIG_URL}/AdGuardHome.yaml and replaces the corresponding placeholer values in this template config. This will enable SSL and automatically uses your tailscales node name as server name.

### AG_HTPASSWD

```shell
htpasswd -B -n -b USER PASSWORD
```

and take the hash after the `:` as the password. But keep in mind, you'll have to escape `$` chars like this `\$` to use them in an env var.

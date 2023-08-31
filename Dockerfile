FROM --platform=$BUILDPLATFORM ghcr.io/ida-greuelr/tailscale-node:main
LABEL org.opencontainers.image.authors="rene.greuel@ida-sds.com"

EXPOSE 53/tcp 53/udp 67/udp 68/udp 80/tcp 443/tcp 443/udp 853/tcp\
	853/udp 3000/tcp 3000/udp 5443/tcp 5443/udp 6060/tcp

ENV TS_CERT=true
ENV TS_ACCEPT_DNS=false
ENV TS_HOSTNAME=ts-adguard

RUN curl -s -S -L https://raw.githubusercontent.com/AdguardTeam/AdGuardHome/master/scripts/install.sh | sh -s -- -v \
    && rm -rf /tmp/*

CMD [ "/opt/AdGuardHome/AdGuardHome" ]
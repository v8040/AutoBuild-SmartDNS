FROM alpine:latest

ARG TARGETARCH
ARG TARGETVARIANT

RUN apk add --no-cache ca-certificates tzdata

COPY bin/${TARGETARCH}/${TARGETVARIANT}/smartdns /usr/sbin/smartdns
COPY etc/smartdns.conf /etc/smartdns/smartdns.conf

RUN chmod +x /usr/sbin/smartdns && \
    mkdir -p /var/lib/smartdns

ENTRYPOINT ["/usr/sbin/smartdns", "-f", "-x", "-c", "/etc/smartdns/smartdns.conf"]
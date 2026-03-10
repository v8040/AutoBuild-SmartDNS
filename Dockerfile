FROM --platform=${BUILDPLATFORM} alpine:latest AS builder

RUN apk add --no-cache ca-certificates tzdata

FROM busybox:latest

ARG TARGETARCH
ARG TARGETVARIANT

COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /usr/share/zoneinfo /usr/share/zoneinfo/

COPY bin/${TARGETARCH}/${TARGETVARIANT}/smartdns /usr/sbin/smartdns
COPY etc/smartdns.conf /etc/smartdns/smartdns.conf

RUN chmod +x /usr/sbin/smartdns && \
    mkdir -p /var/lib/smartdns

ENTRYPOINT ["/usr/sbin/smartdns", "-f", "-x", "-c", "/etc/smartdns/smartdns.conf"]
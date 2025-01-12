# ARG GOVERSION=1.15

# FROM golang:${GOVERSION}-alpine AS build

# RUN apk update && apk add make git
# RUN apk add --update --no-cache iptables
# RUN apk add --update --no-cache openssh

# WORKDIR /go/src/crowdsec
# COPY . .

# RUN make release && \ 
#     tar xzvf cs-cloud-firewall-bouncer.tgz && \
#     cd cs-cloud-firewall-bouncer-v*/ && \
#     install -v -m 755 -D ./cs-cloud-firewall-bouncer "/usr/local/bin/cs-cloud-firewall-bouncer"

FROM alpine:latest
# COPY --from=build /usr/local/bin/cs-cloud-firewall-bouncer /usr/local/bin/cs-cloud-firewall-bouncer

# Script para configurar as regras do iptables
COPY --chmod=700 iptables-setup.sh /usr/local/bin/iptables-setup.sh
COPY --chmod=755 entrypoint.sh /etc/crowdsec/start.sh

ENV CONFIG_PATH="/etc/crowdsec/config.d/config.yaml"

# VOLUME /etc/crowdsec/config.d/

ENTRYPOINT /usr/local/bin/iptables-setup.sh
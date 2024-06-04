# Use a imagem base do Alpine Linux
FROM alpine:latest

# Instale iptables
RUN apk add --update --no-cache iptables
RUN apk add --update --no-cache openssh

# Script para configurar as regras do iptables
COPY iptables-setup.sh /usr/local/bin/iptables-setup.sh
RUN chmod +x /usr/local/bin/iptables-setup.sh

# Execute o script no início do container
ENTRYPOINT ["/usr/local/bin/iptables-setup.sh"]

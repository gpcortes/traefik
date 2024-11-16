#!/bin/sh

# Defina a variável para o IP de destino (substitua pelo IP correto)
DOCKER_INTERNAL_IP=$(getent hosts host.docker.internal | awk '{ print $1 }')

# Define porta de acesso ssh de entrada do container
INCOMING_SSH_PORT=${SSH_PORT:-22}

# Define porta de acesso ssh do host docker
OUTGOING_SSH_PORT=${SSH_HOST_PORT:-2222}

# Limpar regras existentes (opcional, cuidado ao usar em produção)
iptables -F
iptables -t nat -F

# Redirecionar conexões que chegam na porta 2222 para host.docker.internal:22
iptables -t nat -A PREROUTING -p tcp --dport $INCOMING_SSH_PORT -j DNAT --to-destination $DOCKER_INTERNAL_IP:$OUTGOING_SSH_PORT

# Alterar o endereço de origem dos pacotes para o IP da interface de saída
# (Para garantir que a resposta volte pelo caminho correto)
iptables -t nat -A POSTROUTING -p tcp --dport $OUTGOING_SSH_PORT -d $DOCKER_INTERNAL_IP -j MASQUERADE

# Permitir o tráfego de retorno da conexão estabelecida
iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT

# Permitir o tráfego para host.docker.internal:22
iptables -A FORWARD -p tcp -d $DOCKER_INTERNAL_IP --dport $OUTGOING_SSH_PORT -j ACCEPT

# Manter o container em execução (evitar que saia imediatamente)
tail -f /dev/null

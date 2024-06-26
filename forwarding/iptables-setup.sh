#!/bin/sh

# Defina a variável para o IP de destino (substitua pelo IP correto)
DOCKER_INTERNAL_IP=$(getent hosts host.docker.internal | awk '{ print $1 }')

# Adicione a regra de pré-rota para redirecionar a porta 22
iptables -t nat -A PREROUTING -p tcp --dport 2222 -j DNAT --to-destination $DOCKER_INTERNAL_IP:2222

# Adicione a regra para garantir que a resposta retorne pelo caminho correto
iptables -t nat -A POSTROUTING -p tcp -d $DOCKER_INTERNAL_IP --dport 2222 -j MASQUERADE

# Manter o container em execução (evitar que saia imediatamente)
tail -f /dev/null

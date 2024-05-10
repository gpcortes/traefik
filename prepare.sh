#!/bin/bash

function create_env_file() {
    if [ ! -f .env ]; then
        if [ -f example.env ]; then
            cp example.env .env
            echo "Arquivo .env criado a partir do arquivo example.env."
        else
            echo "Arquivo example.env não encontrado. Não foi possível criar o arquivo .env."
        fi
    else
        echo "Arquivo .env já existe."
    fi
}

function export_env_vars() {
    while IFS= read -r line
    do
        if [[ ! $line =~ ^# && $line = *[!\ ]* ]]; then
            export $line
        fi
    done < .env
    echo "Variáveis do arquivo .env exportadas."
}

function create_htpasswd_file() {
    if [ ! -f config/$ENVIRONMENT/.htpasswd ]; then
        touch config/$ENVIRONMENT/.htpasswd
        echo "Arquivo .htpasswd criado."
    else
        echo "Arquivo .htpasswd já existe."
    fi
}

function create_acme_json() {
    if [ ! -f config/$ENVIRONMENT/acme.json ]; then
        touch config/$ENVIRONMENT/acme.json
        chmod 600 config/$ENVIRONMENT/acme.json
        echo "Arquivo acme.json criado."
    else
        echo "Arquivo acme.json já existe."
    fi

}

function setup() {
    create_env_file
    if [ -z "${ENVIRONMENT}" ]; then
        export_env_vars
    fi
    create_htpasswd_file
    create_acme_json
}

setup
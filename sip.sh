#!/bin/bash

# Adresse IP du serveur distant
server_ip=1.2.3.4

# Vérifie si le service SIP est en cours d'exécution sur le port 5060
nc -z $server_ip 5060
if [ $? -eq 0 ]; then
    # Si le service SIP est en cours d'exécution, vérifie l'état du service FreeSWITCH
    if systemctl is-active --quiet freeswitch; then
        # Si le service FreeSWITCH est en cours d'exécution, arrête le service
        service freeswitch stop
    fi
else
    # Si le service SIP n'est pas en cours d'exécution, vérifie l'état du service FreeSWITCH
    if ! systemctl is-active --quiet freeswitch; then
        # Si le service FreeSWITCH n'est pas en cours d'exécution, démarre le service
        service freeswitch start
    fi
fi

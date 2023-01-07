#!/bin/bash

# Adresse IP du serveur distant
SERVER_IP=1.2.3.4

# Nom du service FreeSWITCH
FREESWITCH_SERVICE=freeswitch

# Vérifie si le serveur répond au ping
if ping -c 1 $SERVER_IP > /dev/null
then
    # Le serveur répond au ping, on ne fait rien
    exit 0
else
    # Le serveur ne répond pas au ping
    # Vérifie si le service FreeSWITCH est en cours d'exécution
    if systemctl is-active --quiet $FREESWITCH_SERVICE
    then
        # Le service FreeSWITCH est en cours d'exécution, on ne fait rien
        exit 0
    else
        # Le service FreeSWITCH n'est pas en cours d'exécution, on le démarre
        systemctl start $FREESWITCH_SERVICE
        exit 0
    fi
fi

#!/bin/bash
#!/bin/sh
now=$(date +%Y-%m-%d)
ssh_server=1.2.3.4
database_host=127.0.0.1
database_port=5432
export PGPASSWORD="serveur.backup"

# Chemin vers le fichier contenant le mot de passe root
PASSWORD_FILE="/home/pass.txt"

# Si le fichier de mot de passe n'existe pas, on demande à l'utilisateur de le créer
if [ ! -f $PASSWORD_FILE ]; then
    echo "Le fichier de mot de passe n'a pas été trouvé !"
    echo -n "Veuillez entrer le mot de passe root : "
    read -s ROOT_PASSWORD
    echo $ROOT_PASSWORD > $PASSWORD_FILE
    chmod 600 $PASSWORD_FILE
fi

# Lecture du mot de passe à partir du fichier
ROOT_PASSWORD=$(cat $PASSWORD_FILE)

#Exécuter la sauvegarde à distance
ssh -p 22 root@$ssh_server "nice -n -20 /etc/cron.daily/./fusionpbx-backup" --password-file=<(echo $ROOT_PASSWORD)

#Supprimer les journaux freeswitch de plus de 7 jours
find /var/log/freeswitch/freeswitch.log.* -mtime +7 -exec rm {} \;

#Synchroniser le répertoire de sauvegarde
#rsync -avz -e 'ssh -p 22' root@$ssh_server:/var/backups/fusionpbx /var/backups --password-file=<(echo $ROOT_PASSWORD)
rsync -avz -e 'ssh -p 22' root@$ssh_server:/var/backups/fusionpbx/postgresql /var/backups/fusionpbx --password-file=<(echo $ROOT_PASSWORD)
rsync -avz -e 'ssh -p 22' root@$ssh_server:/var/www/fusionpbx /var/www --password-file=<(echo $ROOT_PASSWORD)
rsync -avz -e 'ssh -p 22' root@$ssh_server:/etc/fusionpbx /etc --password-file=<(echo $ROOT_PASSWORD)
find /var/backups/fusionpbx/postgresql -mtime +2 -exec rm {} \;

rsync -avz -e 'ssh -p 22' root@$ssh_server:/etc/freeswitch/ /etc --password-file=<(echo $ROOT_PASSWORD)
rsync -avz -e 'ssh -p 22' root@$ssh_server:/var/lib/freeswitch/storage /var/lib/freeswitch --password-file=<(echo $ROOT_PASSWORD)
rsync -avz -e 'ssh -p 22' root@$ssh_server:/var/lib/freeswitch/recordings /var/lib/freeswitch --password-file=<(echo $ROOT_PASSWORD)
rsync -avz -e 'ssh -p 22' root@$ssh_server:/usr/share/freeswitch/scripts /usr/share/freeswitch --password-file=<(echo $ROOT_PASSWORD)
rsync -avz -e 'ssh -p 22' root@$ssh_server:/usr/share/freeswitch/sounds /usr/share/freeswitch --password-file=<(echo $ROOT_PASSWORD)

echo "Restauration de la sauvegarde"
#extract the backup from the tgz file
#tar -xvpzf /var/backups/fusionpbx/backup_$now.tgz -C /

#Supprimer l'ancienne base de données
psql --host=$database_host --port=$database_port  --username=fusionpbx -c 'drop schema public cascade;'
psql --host=$database_host --port=$database_port  --username=fusionpbx -c 'create schema public;'

#Restaurer la base de données
pg_restore -v -Fc --host=$database_host --port=$database_port --dbname=fusionpbx --username=fusionpbx /var/backups/fusionpbx/postgresql/fusionpbx_pgsql_$now.sql

#Redémarrer freeswitch
service freeswitch restart
echo "Restauration terminée";

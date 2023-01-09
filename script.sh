# Création du dossier /liello/ et changement des permissions pour que seul l'utilisateur root puisse y accéder
mkdir /liello/
chmod 700 /liello/

# Demande de l'adresse IP du serveur maitre et enregistrement de cette valeur dans une variable
echo "Entrez l'adresse IP du serveur maitre :"
read server_ip

# Demande du mot de passe du serveur maitre et enregistrement de ce mot de passe dans le fichier /liello/pass
echo "Entrez le mot de passe du serveur maitre :"
read -s server_password
echo $server_password > /liello/pass

# Installation de rsync et sshpass
apt-get install rsync sshpass

# Téléchargement de https://github.com/wouam31200/MyScript.git et copie des fichiers dans /liello/
git clone https://github.com/wouam31200/MyScript.git
cp MyScript/* /liello/
rm -r MyScript

# Changement des permissions pour rendre rsync.sh et sip.sh exécutables
chmod +x /liello/rsync.sh
chmod +x /liello/sip.sh

# Lecture du mot de passe de la base de données dans /etc/fusionpbx/config.conf et enregistrement de ce mot de passe dans le fichier rsync.sh
database_password=$(grep "database.0.password =" /etc/fusionpbx/config.conf | cut -d "=" -f 2 | tr -d ' ')
sed -i "s/export PGPASSWORD=.*/export PGPASSWORD=$database_password/" /liello/rsync.sh

# Mise à jour de l'adresse IP du serveur maitre dans les fichiers rsync.sh et sip.sh
sed -i "s/ssh_server=.*/ssh_server=$server_ip/" /liello/rsync.sh
sed -i "s/server_ip=.*/server_ip=$server_ip/" /liello/sip.sh

# Création des crons pour lancer rsync.sh tous les jours à 2h du matin et sip.sh toutes les 3 minutes
echo "0 2 * * * /liello/rsync.sh" >> /etc/crontab
echo "*/3 * * * * /liello/sip.sh" >> /etc/crontab

# Lancement de rsync.sh
/liello/rsync.sh

# Lecture du mot de passe de la base de données dans /etc/fusionpbx/config.conf
database_password=$(grep "database.0.password =" /etc/fusionpbx/config.conf | cut -d "=" -f 2 | tr -d ' ')

# Affichage des manipulations à réaliser à la main
#echo "Pour mettre à jour le mot
# Affichage des manipulations à réaliser à la main
echo "Pour mettre à jour le mot de passe de l'utilisateur fusionpbx et de l'utilisateur freeswitch, exécutez les commandes suivantes :"
echo "su - postgres"
echo "psql fusionpbx"
echo "ALTER USER fusionpbx WITH ENCRYPTED PASSWORD '$database_password';"
echo "\q"
echo "psql freeswitch"
echo "ALTER USER freeswitch WITH ENCRYPTED PASSWORD '$database_password';"
echo "\q"
echo "exit"


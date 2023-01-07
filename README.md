start.service.fusionpbx.sh

Ce script vérifie si le serveur distant répond au ping. Si ce n'est pas le cas, il vérifie si le service FreeSWITCH est en cours d'exécution. Si le service n'est pas en cours d'exécution, il le démarre.

Pour utiliser ce script, vous devez remplacer l'adresse IP du serveur (1.2.3.4) par l'adresse IP du serveur que vous voulez tester. Vous devez également remplacer le nom du service FreeSWITCH (freeswitch) par le nom du service tel qu'il est défini sur votre système.

Pour exécuter ce script, vous pouvez utiliser la commande suivante :

./mon_script.sh


Assurez-vous de rendre le script exécutable avec la commande :

chmod +x mon_script.sh

Ajouter l'exécution à contrab:

*/3 * * * * /chemin/vers/mon_script.sh

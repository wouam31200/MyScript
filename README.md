start.service.fusionpbx.sh

Ce script vérifie si le serveur distant répond au ping. Si c'est le cas, il vérifie si le service FreeSWITCH est en cours d'exécution et l'arrête si c'est le cas. Si le serveur ne répond pas au ping, le script vérifie si le service FreeSWITCH est en cours d'exécution et le démarre s'il n'est pas en cours d'exécution.

Pour utiliser ce script, vous devez remplacer l'adresse IP du serveur (1.2.3.4) par l'adresse IP du serveur que vous voulez tester. Vous devez également remplacer le nom du service FreeSWITCH (freeswitch) par le nom du service tel qu'il est défini sur votre système.

Pour exécuter ce script, vous pouvez utiliser la commande suivante :

./start.service.fusionpbx.sh


Assurez-vous de rendre le script exécutable avec la commande :

chmod +x start.service.fusionpbx.sh

Ajouter l'exécution à contrab:

*/3 * * * * /chemin/vers/start.service.fusionpbx.sh

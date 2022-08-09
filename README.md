# msg-info

#  **En cours de developpement**

Générateur de message d'information pour relais radioamateur SvxLink

Ce programme permet de generer automatiquement un fichier son au format Wav SvxLink depuis une saisie de texte. Il formatera aussi le nom du fichier pour gérer sa diffusion. Ensuite c'est [le script tcl](http://blog.f8asb.com/2017/09/17/svxlink-messages-dinformations-programmes/) qui est integré dans SvxLink qui lancera automatiquement les diffusions.

Le Programme utilise la synthèse vocale de Google Text to Speech. 

 
### Installation nécessaire pré-requise:

`pip install gTTS`

`apt-get install sox`

`apt-get install mplayer`

`apt-get install mpg123`


Installation du script dans SvxLink selon article du
[Blog F8ASB.com](http://blog.f8asb.com/2017/09/17/svxlink-messages-dinformations-programmes/)


### Voici des aperçus écran du programmme:

![](http://blog.f8asb.com/wp-content/uploads/2022/08/msginfo01.png)

On choisi de réaliser un message vocal

![](http://blog.f8asb.com/wp-content/uploads/2022/08/msginfo02.png)

On defini la date de début du message

![](http://blog.f8asb.com/wp-content/uploads/2022/08/msginfo03.png)

On defini l'heure de début de diffusion

![](http://blog.f8asb.com/wp-content/uploads/2022/08/msginfo04.png)

On défini la date de fin de diffusion

![](http://blog.f8asb.com/wp-content/uploads/2022/08/msginfo05.png)

On défini l'heure de fin de diffusion

![](http://blog.f8asb.com/wp-content/uploads/2022/08/msginfo06.png)

On choisi le nom du fichier

![](http://blog.f8asb.com/wp-content/uploads/2022/08/msginfo07.png)

On defini le contenu du message, le texte sera ensuite automatiquement transformer en voix. J'ai ecris "rendez-vous vendredi soir au radioclub vendredi soir venez nombreux"
La ponctuation peut changer l'intonation de la voix.

![](http://blog.f8asb.com/wp-content/uploads/2022/08/msginfo09.png)

Le programme réalise le fichier son, avec le bon format svxlink et également le nom du fichier qui precise le debut et la fin de diffusion.

Le fichier son est disponible à titre d'exemple sur Github. 

### Le format des fichiers son utilisés est le suivant:

Début----------------*--------------------Fin

AA MM JJ HH MM AA MM JJ HH MM NOM.wav

**AA** pour année

**MM** pour mois

**JJ** pour jour

**HH** pour heure

**MM** pour minute

**NOM** pour le nom du message. ( il n’est pas pris en compte par le programme vous êtes libre d’écrire ce que vous voulez)

*Voici ci-dessous un exemple de fichier:*

**17090915001709301900brocanteradioamateur.wav**

Il sera diffusé du 9 septembre 2017 à 15h00 jusqu’au 30 septembre 2017 19h00.


![](http://blog.f8asb.com/wp-content/uploads/2022/08/msginfo08.png)
On peut ensuite ecouter le message obtenu

### Il y a 3 options possibles:

* Ecouter en local sur les haut-parleurs de la machine

* Ecouter sur le relais en coupant le relais, il commutera le ptt le temps de la lecture du message.

* Ecouter en simulant un commande DTMF sur le relais

Il sera necessaire de décommenter l'option choisi dans le code **msg-info.sh**.


Option 1


*ecouter sur un pc linux avec carte son et HP*

`aplay $fichier`


Option 2


 *Coupe le relais et joue le morceau
 Le port audio doit etre bon hw:1 ou 0
 Le gpio doit correspondre au ptt du relais
 Il sera necessaire de relancer le relais après*

`pkill svxlink`

`echo 1 > /sys/class/gpio/gpio16/value`

`AUDIODEV=hw:1 play $fichier`

`sleep 3`

`echo 0 > /sys/class/gpio/gpio16/value`


`Option 3`


*Envoi le code DTMF pour ecouter le message programmer par le relais
Il est necessaire que le fichier soit dans le dossier Messages deddié
avec le bon format de nom.
cette option simulera l'envoi d'un dtmf sur le relais*

`echo "10#" > /tmp/dtmf_vhf
echo "10#" > /tmp/dtmf_uhf`

### Le script Python:

Le script txt_to_mp3.py s'occupe lui de transformer un fichier texte en son mp3.
Le fichier de sortie s'appellera `Output.mp3`
La commande d'utilsation est:
`Python3 txt_to_mp3.py <nomdufichiertexte>`

Si vous le transformer en executable la commande ./ remplacera python3.

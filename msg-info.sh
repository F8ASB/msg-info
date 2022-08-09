
#!/bin/sh
DIALOG=${DIALOG=dialog}

whiptail --title "Editeur de messages vocaux" --msgbox "Entrez les dates et heures de diffusion, votre message au format texte.                                                     Vous pourrez également écouter le rendu du message.                                                                      " 15 60

while : ; do

choix=$(whiptail --title "Choisir votre action" --radiolist \
"Que voulez vous faire ?" 15 50 4 \
"1" "Réaliser le message vocal " ON \
"2" "Tester le message sur le relais " OFF 3>&1 1>&2 2>&3)

exitstatus=$?

if [ $exitstatus = 0 ]; then
    echo "Choix:" $choix
else
    echo "Annulation"; break;
fi

Saisie_Date-Debut()
{
DateDebut=`$DIALOG --stdout --title "CALENDRIER" --calendar "Choisissez de début de diffusion..." 0 0 `

case $? in
  0)
        Saisie_Heure_Debut;;
  1)
        echo "Appuyé sur Annuler.";;
  255)
        echo "Fenêtre fermée.";;
esac
}

Saisie_Heure_Debut()
{
HeureDebut=`$DIALOG --stdout --title "HORLOGE" --timebox "Saisissez l'heure..." 0 0 00 00 00`

case $? in
  0)
    Saisie_Date_Fin;;
  
  1)
    echo "Appuyé sur Annuler.";;
  255)
    echo "Fenêtre fermée.";;
esac
}

Saisie_Date_Fin()
{
DateFin=`$DIALOG --stdout --title "CALENDRIER" --calendar "Choisissez de fin de diffusion..." 0 0 `

case $? in
  0)
        Saisie_Heure_Fin;;
  1)
        echo "Appuyé sur Annuler.";;
  255)
        echo "Fenêtre fermée.";;
esac
}

Saisie_Heure_Fin()
{
HeureFin=`$DIALOG --stdout --title "HORLOGE" --timebox "Saisissez l'heure..." 0 0 00 00 00`

case $? in
  0)
    NomFichier;;
  
  1)
    echo "Appuyé sur Annuler.";;
  255)
    echo "Fenêtre fermée.";;
esac
}


NomFichier()

{
Nomfichier=$(whiptail --inputbox "Nom du fichier wav?" 8 39 --title "Message:" 3>&1 1>&2 2>&3)

exitstatus=$?
if [ $exitstatus = 0 ]; then
    ContenuMessage

else
    echo "User selected Cancel."
fi

}

ContenuMessage()

{
Message=$(whiptail --inputbox "Message à diffuser?" 8 39 --title "Message:" 3>&1 1>&2 2>&3)

exitstatus=$?
if [ $exitstatus = 0 ]; then
    Ecriture_fichier

else
    echo "User selected Cancel."
fi

}


Ecriture_fichier()
{

d1=$(echo ${DateDebut:8:2}${DateDebut:3:2}${DateDebut:0:2});
h1=$(echo ${HeureDebut:0:5}|tr -d ':'});
d2=$(echo ${DateFin:8:2}${DateFin:3:2}${DateFin:0:2});
h2=$(echo ${HeureFin:0:5}|tr -d ':'});

#Stockage du message dans un fichier
echo  $Message>message.txt

fichier=$(echo $d1$h1$d2$h2$Nomfichier".wav");
fichiertemp=$(echo $d1$h1$d2$h2$Nomfichier"temp.wav");


#Génération du fichier Son
#pico2wave -l fr-FR -w $fichier <message.txt;
#Essai avec Googlespeech
python3 txt_to_mp3.py message.txt
#Transformation du mp3 en Wav
sleep 3
mpg123 -w $fichiertemp output.mp3
#Transformation au format SvxLink 
sleep 3
sox $fichiertemp -r16k $fichier
rm output.mp3
rm $fichiertemp
#copie du fichier dans le dossier du relais dédié
#cp $fichier /usr/share/svxlink/sounds/fr_FR/Messages/
}

Ecouter_Message()
{

#**********
#*Option 1*
#**********

#ecouter sur un pc linux avec carte son et HP

aplay $fichier

#**********
#*Option 2*
#**********

# Coupe le relais et joue le morceau
# Le port audio doit etre bon hw:1 ou 0
# Le gpio doit correspondre au ptt du relais
# Il sera necessaire de relancer le relais après

#pkill svxlink
#echo 1 > /sys/class/gpio/gpio16/value

#AUDIODEV=hw:1 play $fichier

#sleep 3
#echo 0 > /sys/class/gpio/gpio16/value

#**********
#*Option 3*
#**********

#Envoi le code DTMF pour ecouter le message programmer par le relais
# Il est necessaire que le fichier soit dans le dossier Messages deddié
# avec le bon format de nom.
# cette option simulera l'envoi d'un dtmf sur le relais

#echo "10#" > /tmp/dtmf_vhf
#echo "10#" > /tmp/dtmf_uhf

}

case $choix in

1) 
Saisie_Date-Debut
;;

2) 
Ecouter_Message
;;

esac


done
exit 0

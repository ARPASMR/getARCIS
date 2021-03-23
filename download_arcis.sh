#!/bin/bash
#--------------

# scriptino per scaricare i dataset mensili prodotti dal consorzio ARCIS

# dicembre, 2020
# MS
#----------------------------------------------------------------------
# dichiarazioni

# date
anno_inizio=$(date --date="last month" +%Y)
mese_inizio=$(date --date="last month" +%m)

echo "Chiedo i dati per: anno " $anno_inizio ", mese: " $mese_inizio

echo " ------------------------------------------------ "
echo "directory di lavoro: "$PWD
echo " ------------------------------------------------ "

echo " ------------------------------------------------ "
echo " Scarico dataset arcis: ARCIS_GG_"$anno_inizio""$mese_inizio".nc"
echo " ------------------------------------------------ "


while [ ! -f "DATASET/ARCIS_GG_"$anno_inizio""$mese_inizio".nc" ]
do 

echo " ----  ftp arpa piemonte -------"
$FTP -n -v -d $ARCIS_FTP <<FINE2 > $LOGFILE 2>&1
    quote user $ARCIS_USR
    quote pass $ARCIS_PWD
    cd $ARCIS_DIR
    lcd DATASET
    binary
    get ARCIS_GG_"$anno_inizio""$mese_inizio".nc 
    bye
FINE2

sleep 1d
done

cdo timsum DATASET/ARCIS_GG_"$anno_inizio""$mese_inizio".nc MENSILI/ARCIS_"$anno_inizio""$mese_inizio".nc

/usr/bin/smbclient //$WEBPREVIP/$WEBPREVDIR -U $WEBPREVUSR%$WEBPREVPWD <<End-of-smbclient8
prompt
cd $WEBPREVDIR2
lcd DATASET
put ARCIS_GG_"$anno_inizio""$mese_inizio".nc
lcd ../MENSILI
cd ../cumulata_mensile
put ARCIS_"$anno_inizio""$mese_inizio".nc
End-of-smbclient8

exit 0

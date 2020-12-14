#!/bin/bash
#--------------

# scriptino per scaricare i dataset mensili prodotti dal consorzio ARCIS

# dicembre, 2020
# MS
#----------------------------------------------------------------------
# dichiarazioni

# date
anno_inizio=$(date --date="last month" +%Y)
#echo $anno_inizio
mese_inizio=$(date --date="last month" +%m)
#echo $mese_inizio
giorno_inizio=$anno_inizio-$mese_inizio-01
#echo $giorno_inizio
echo "Chiedo i dati per: anno " $anno_inizio ", mese: " $mese_inizio

echo " ------------------------------------------------ "
echo "directory di lavoro: "$PWD
echo " ------------------------------------------------ "

echo " ------------------------------------------------ "
echo " Scarico dataset arcis: ARCIS_GG_"$anno_inizio""$mese_inizio".nc"
echo " ------------------------------------------------ "

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

#   inserisco chiamata syslogger
#   if [[ "$?" -ge "300" ]]; then
#      logger -i -s -p user.err "Problema nel download dataset ARCIS $mese_inizio/$anno_inizio " -t "DATI"
#    else
#      logger -i -s -p user.notice "Trasferimento dataset $mese_inizio/$anno_inizio da ftp ARCIS  completato" -t "DATI"
#    fi
#   fine chiamata syslogger

/usr/bin/smbclient //$WEBPREVIP/$WEBPREVDIR -U $WEBPREVUSR%$WEBPREVPWD <<End-of-smbclient8
prompt
cd $WEBPREVDIR2
lcd DATASET
put ARCIS_GG_"$anno_inizio""$mese_inizio".nc
End-of-smbclient8

exit 0

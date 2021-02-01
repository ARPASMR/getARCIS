#!/bin/bash
#=============================================================================
export https_proxy="http://proxy2:8080"
export http_proxy="http://proxy2:8080"

while [ 1 ]
do
  giorno=`date +%e`
  if [ $giorno = 28 ]
  then
    ./download_arcis.sh > download_arcis.log 2>&1
    sleep 1d
  else
    sleep 1d
  fi
done

FROM arpasmr/r-base
RUN apt-get install -y ftp 
RUN apt-get install -y smbclient

COPY . /usr/local/src/myscripts
WORKDIR /usr/local/src/myscripts
RUN chmod a+x launcher.sh
RUN chmod a+x download_arcis.sh
RUN mkdir /usr/local/src/myscripts/DATASET
CMD ["./launcher.sh"]

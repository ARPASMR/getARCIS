FROM arpasmr/r-base

RUN apt-get update
RUN apt-get install -y ftp 
RUN apt-get install -y smbclient
# provo ad installare cdo con pezzettino copiato da https://github.com/alexgleith/docker-cdo/blob/master/Dockerfile
# Install some core software
RUN apt-get update && apt-get install -y wget g++ make \
    && rm -rf /var/lib/apt/lists/*
# Set up the components needed for format support for cdo
RUN apt-get update && apt-get install -y \
    nco netcdf-bin libhdf5-dev zlib1g-dev libjasper-dev libnetcdf-dev libgrib-api \
    && rm -rf /var/lib/apt/lists/*
# Install cdo from source, so that we get other format support
WORKDIR /tmp
RUN wget https://code.mpimet.mpg.de/attachments/download/16435/cdo-1.9.3.tar.gz -O /tmp/cdo-1.9.3.tar.gz \
    && tar -xzvf cdo-1.9.3.tar.gz \
    && cd /tmp/cdo-1.9.3 \
    && ./configure --enable-netcdf4 --enable-zlib --with-netcdf=/usr/ --with-hdf5=/usr/ --with-grib_api=/usr/ \
    && make \
    && make install \
    && rm -rf /tmp/*

COPY . /usr/local/src/myscripts
WORKDIR /usr/local/src/myscripts
RUN chmod a+x launcher.sh
RUN chmod a+x download_arcis.sh
RUN mkdir /usr/local/src/myscripts/DATASET && chmod 777 /usr/local/src/myscripts/DATASET
CMD ["./launcher.sh"]

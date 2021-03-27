FROM ubuntu:18.04

# provo ad installare cdo con pezzettino copiato da https://github.com/alexgleith/docker-cdo/blob/master/Dockerfile
# Install some core software
RUN apt-get update && apt-get install -y wget g++ make \
    && rm -rf /var/lib/apt/lists/*

# Set up the components needed for format support for cdo
RUN apt-get update && apt-get install -y \
    nco netcdf-bin libhdf5-dev zlib1g-dev libjasper-dev libnetcdf-dev libgrib-api-dev \
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

# R    
RUN apt-get install -y r-base
RUN apt-get install -y apt-utils
RUN apt-get install -y curl
RUN apt-get install -y openssl
RUN apt-get install -y libssl-dev
RUN apt-get install -y libcurl4-openssl-dev
RUN apt-get install -y libmysqlclient-dev
RUN apt-get install -y libpq-dev
RUN apt-get install -y ncftp
RUN apt-get install -y ssh
RUN apt-get install -y libgdal-dev

RUN R -e "install.packages('lubridate', repos = 'http://cran.us.r-project.org')"
RUN R -e "install.packages('jsonlite', repos = 'http://cran.us.r-project.org')"
RUN R -e "install.packages('curl', repos = 'http://cran.us.r-project.org')"
RUN R -e "install.packages('openssl', repos = 'http://cran.us.r-project.org')"
RUN R -e "install.packages('httr', repos = 'http://cran.us.r-project.org')"
RUN R -e "install.packages('fields', repos = 'http://cran.us.r-project.org')"
RUN R -e "install.packages('maps', repos = 'http://cran.us.r-project.org')"
RUN R -e "install.packages('raster', repos = 'http://cran.us.r-project.org')"
RUN R -e "install.packages('rgdal', repos = 'http://cran.us.r-project.org')"
RUN R -e "install.packages('RMySQL', repos = 'http://cran.us.r-project.org')"
RUN R -e "install.packages('R2HTML', repos = 'http://cran.us.r-project.org')"

# ftp e smbcilient
RUN apt-get install -y ftp 
RUN apt-get install -y smbclient

WORKDIR /usr/local/src/myscripts/
COPY . /usr/local/src/myscripts

RUN chmod a+x launcher.sh
RUN chmod a+x download_arcis.sh
RUN mkdir /usr/local/src/myscripts/DATASET && chmod 777 /usr/local/src/myscripts/DATASET
CMD ["./launcher.sh"]

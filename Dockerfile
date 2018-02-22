FROM ubuntu:trusty
MAINTAINER "Vladislav Kim" vkim@embl.de

## add CRAN to the list of repositories
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 51716619E084DAB9
RUN echo "deb http://stat.ethz.ch/CRAN/bin/linux/ubuntu trusty/ #enabled-manually" \
    	 >> /etc/apt/sources.list

RUN apt-key update 
## install R
RUN apt-get update && apt-get install -y --no-install-recommends r-base r-base-dev r-recommended
CMD ["R"]


## install lpsymphony
RUN R -e "source('http://bioconductor.org/biocLite.R'); biocLite('lpsymphony')" 


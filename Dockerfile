FROM ubuntu:trusty
MAINTAINER "Vladislav Kim" vkim@embl.de

## add CRAN to the list of repositories
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
RUN echo "deb http://stat.ethz.ch/CRAN/bin/linux/ubuntu trusty/ #enabled-manually" \
    	 >> /etc/apt/sources.list
	 
## install R, ipython notebook and associated dependencies
RUN apt-get update && apt-get install -y --no-install-recommends r-base r-base-dev r-recommended \
    wget python-pip python-dev libzmq3-dev libcurl4-openssl-dev \
    libssl-dev libxml2 libxml2-dev \
    && rm -rf /tmp/downloaded_packages/ /tmp/*.rds && pip install \
    ipython==3.2.1 pyzmq jinja2 tornado jsonschema && rm -rf /tmp/pip_build_root/ \
    && apt-get clean && rm -rf /var/lib/apt/lists/
CMD ["R"]

EXPOSE 8888

## install R kernel and dependencies
RUN R -e "source('http://bioconductor.org/biocLite.R'); biocLite(c('xml2','rversions', 'devtools'))" && \
    R -e "devtools::install_github(c('armstrtw/rzmq', 'vladchimescu/repr1', 'IRkernel/IRdisplay', 'IRkernel/IRkernel'))" \
    && R -e 'IRkernel::installspec()'

## create a profile "nbserver"
RUN ipython profile create nbserver && mkdir /nbserver
WORKDIR /nbserver
CMD ipython notebook --profile=nbserver

## theme the notebook (NB: custom.css has to be provided)
RUN rm /root/.ipython/profile_nbserver/static/custom/custom.css
COPY ./custom.css /root/.ipython/profile_nbserver/static/custom/
COPY ./breakpoints.js /root/.ipython/nbextensions/
COPY ./custom.js /root/.ipython/profile_nbserver/static/custom/

FROM rocker/r-base:4.3.1

# make an app directory
RUN mkdir my_code

# Cop
COPY r-app/ . 
COPY data/ . 

#Install packages
RUN Rscript install_packages.R

CMD ["Rscript", "app.R"]
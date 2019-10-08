# FROM ubuntu:bionic
FROM python:3.6-stretch
MAINTAINER Leo "flywithlg@gmail.com"
ENV LANG C.UTF-8
ENV DEBIAN_FRONTEND noninteractive
# Install software packages 
RUN apt-get update -qq && apt-get install -y \
    git less nano curl \
    ca-certificates \
    binutils \
    build-essential \
    gettext \
    gdal-bin \
    libgdal-dev \
    libpq-dev \
    libproj-dev \
    postgresql-client \
    wget \
    nginx \
    supervisor \
    #python3-pip \ 
    && rm -rf /var/lib/apt/lists/ && rm -rf /var/cache/apt/
# App related configuration
COPY . /opt/app
COPY conf/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY conf/default  /etc/nginx/sites-available/default.conf
WORKDIR /opt/app
RUN pip install --upgrade pip
RUN pip install -r ./requirement.txt
RUN pip install uwsgi
EXPOSE 80
# CMD ["python", "manage.py" ,"runserver", "0.0.0.0:8080"]

CMD ["nginx", "-g", "daemon off;"] 

# docker run -p 8080:8080  leo524/valle-docker

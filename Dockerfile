FROM python:3.6-stretch

MAINTAINER  Leo "flywithlg@gmail.com"

# Install required packages and remove the apt packages cache when done.

RUN apt-get update && \
    apt-get install -y \
	git \
	python3 \
	python3-dev \
	python3-setuptools \
	python3-pip \
	nginx \
	supervisor \
	sqlite3  \
    less \
	nano \
	curl \
    ca-certificates \
    binutils \
    build-essential \
    gettext \
    gdal-bin \
    libgdal-dev \
    libpq-dev \
    libproj-dev \
    postgresql-client \
    wget && \
    pip3 install -U pip setuptools && \
    rm -rf /var/lib/apt/lists/*

# install uwsgi module
RUN pip3 install uwsgi

# setup all the configfiles
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
COPY nginx-app.conf /etc/nginx/sites-available/default
COPY supervisor-app.conf /etc/supervisor/conf.d/

# COPY requirements.txt and RUN pip install BEFORE adding the rest of your code, this will cause Docker's caching mechanism
# to prevent re-installing 

COPY app1/requirement.txt /home/docker/code/app/
RUN pip3 install -r /home/docker/code/app/requirements.txt

# add the application to docker container
COPY . /home/docker/code/


EXPOSE 80
CMD ["supervisord", "-n"]

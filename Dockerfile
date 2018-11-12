FROM ascdc/apache2-php72-laravel
MAINTAINER ASCDC <asdc.sinica@gmail.com>

ADD run.sh /run.sh

RUN DEBIAN_FRONTEND=noninteractive && apt-get update && \
	apt-get -y upgrade && \
	cd /opt && wget https://www.python.org/ftp/python/3.6.7/Python-3.6.7.tar.xz && tar Jxvf Python-3.6.7.tar.xz && \ 
	cd Python-3.6.7 && ./configure && make && make install && rm /usr/bin/python && ln -s /opt/Python3.6.7/python /usr/bin/python && apt-get install libssl-dev && pip install django ~=2.0.5 -y
		
EXPOSE 80
WORKDIR /var/www/html
ENTRYPOINT ["/run.sh"]
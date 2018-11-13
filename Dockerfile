FROM ascdc/apache2-php72-laravel
MAINTAINER ASCDC <asdc.sinica@gmail.com>

ADD run.sh /run.sh

RUN chmod +x /*.sh && \
	DEBIAN_FRONTEND=noninteractive && apt-get update && \
	apt-get -y upgrade && apt-get -y install libssl-dev openssl && \
	cd /opt && wget https://www.python.org/ftp/python/3.6.7/Python-3.6.7.tar.xz && tar Jxvf Python-3.6.7.tar.xz && \ 
	rm /usr/bin/python && cd Python-3.6.7 && ./configure --with-ssl && make && make install && \
	cd /usr/bin && ln -s /opt/Python-3.6.7/python /usr/bin/python && \
	cd /usr/local/bin && ln -s pip3.6 pip && \
	pip install --upgrade pip && pip install django~=2.0.5
		
EXPOSE 80
WORKDIR /var/www/html
ENTRYPOINT ["/run.sh"]
FROM ubuntu:trusty
MAINTAINER ASCDC <asdc.sinica@gmail.com>

ADD run.sh /run.sh
ADD locale.gen /etc/locale.gen
ADD locale-archive /usr/lib/locale/locale-archive

RUN chmod +x /*.sh && \
	apt-get update && \
	DEBIAN_FRONTEND=noninteractive && \
	apt-get -y install locales software-properties-common python-software-properties wget curl vim git && \
	echo "cd /var/www/html" >> /root/.profile && \
	echo "alias ll='ls -al'" >> /root/.profile && \
	echo "export LANG=zh_TW.UTF-8" >> /root/.profile && \ 
	echo "export LANGUAGE=zh_TW" >> /root/.profile && \
	echo "export LC_ALL=zh_TW.UTF-8" >> /root/.profile && \
	echo "export PATH=$PATH:/root/.composer/vendor/bin" >> /root/.profile && \
	echo "export NVM_DIR=/root/.nvm" >> /root/.profile && \
	echo "[ -s \"\$NVM_DIR/nvm.sh\" ] && . \"\$NVM_DIR/nvm.sh\"" >> /root/.profile && \
	locale-gen zh_TW.UTF-8 && \
	dpkg-reconfigure locales && \
	export LANG=zh_TW.UTF-8 && \
	add-apt-repository -y ppa:ondrej/php && \
	add-apt-repository -y ppa:ondrej/apache2
	
RUN DEBIAN_FRONTEND=noninteractive && apt-get update && \
	apt-get -y upgrade && \
	apt-get install -y ^apache2$ ^php7\.2$ ^php7\.2-common$ ^php7\.2-json$ ^php7\.2-opcache$ ^php7\.2-zip$ ^php7\.2-mysql$ ^php7\.2-phpdbg$ ^php7\.2-gd$ ^php7\.2-imap$ ^php7\.2-ldap$ ^php7\.2-pgsql$ ^php7\.2-pspell$ ^php7\.2-recode$ ^php7\.2-tidy$ ^php7\.2-intl$ ^php7\.2-curl$ ^php7\.2-xmlrpc$ ^php7\.2-imagick$ ^php7\.2-xsl$ ^php7\.2-bz2$ ^php7\.2-mbstring$ pkg-config libmagickwand-dev imagemagick build-essential libsasl2-dev libpcre3-dev && \
	ln -s ../mods-available/rewrite.load /etc/apache2/mods-enabled/rewrite.load && \
	wget -qO /usr/local/bin/composer https://getcomposer.org/composer.phar && \
	chmod 755 /usr/local/bin/composer && \
	export PATH=$PATH:/root/.composer/vendor/bin && \
	composer global require "laravel/installer" && \
	mkdir /var/www/html/public && \
	mv /var/www/html/*.html /var/www/html/public && \
	sed -i "s/DocumentRoot.*/DocumentRoot \/var\/www\/html\/public/g" /etc/apache2/sites-available/000-default.conf && \
	sed -i "s/<\/VirtualHost>/\t<Directory \"\/var\/www\/html\/public\">\n\t\tAllowOverride All\n\t<\/Directory>\n<\/VirtualHost>/g" /etc/apache2/sites-available/000-default.conf && \
	curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.32.1/install.sh | bash && \
	export NVM_DIR="/root/.nvm" && \
	[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" && \
	nvm install v6.9.2 && \
	nvm use v6.9.2 && \
	cd /opt && wget https://www.python.org/ftp/python/3.6.7/Python-3.6.7.tar.xz && tar Jxvf Python-3.6.7.tar.xz && \ 
	cd Python-3.6.7 && ./configure && make && make instal && l rm /usr/bin/python && ln -s /opt/Python3.6.7/python /usr/bin/python && apt-get install libssl-dev && pip install django ~=2.0.5 -y
	
ENV LANG zh_TW.UTF-8  
ENV LANGUAGE zh_TW
ENV LC_ALL zh_TW.UTF-8	
ENV NVM_DIR /root/.nvm
	
EXPOSE 80
WORKDIR /var/www/html
ENTRYPOINT ["/run.sh"]
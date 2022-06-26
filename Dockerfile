FROM php:7.4.30-apache

# Download installer php extentions | Thanks to https://github.com/mlocati
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

# Install php extentions
RUN chmod +x /usr/local/bin/install-php-extensions && sync && \
    install-php-extensions http bcmath bz2 calendar  \
    exif gd gettext gmp igbinary msgpack mysqli \
    pcntl pgsql redis shmop sockets sqlsrv sysvmsg \ 
    sysvsem sysvshm xsl zip pdo_mysql pdo_pgsql pdo_sqlsrv

# Config timezone server GMT+7 WIB
ENV CONTAINER_TIMEZONE="Asia/Jakarta"
RUN rm -f /etc/localtime \
&& ln -s /usr/share/zoneinfo/${CONTAINER_TIMEZONE} /etc/localtime

# Config limit file upload
RUN echo "post_max_size=20M" >> $PHP_INI_DIR/conf.d/memory-limit.ini
RUN echo "upload_max_filesize=20M" >> $PHP_INI_DIR/conf.d/memory-limit.ini

# Config timezone php GMT+7 WIB
RUN echo "date.timezone=Asia/Jakarta" > $PHP_INI_DIR/conf.d/date_timezone.ini

# Display errors in stderr
RUN echo "display_errors=stderr" > $PHP_INI_DIR/conf.d/display-errors.ini

# Disable PathInfo
RUN echo "cgi.fix_pathinfo=0" > $PHP_INI_DIR/conf.d/path-info.ini

# Disable expose PHP
RUN echo "expose_php=0" > $PHP_INI_DIR/conf.d/path-info.ini

EXPOSE 80
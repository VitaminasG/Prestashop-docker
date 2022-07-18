FROM httpd:latest

ARG PHP_VERSION

RUN apt-get update

ENV TZ="Europe/Vilnius"

## Apache ENVs
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_PID_FILE /var/run/apache2/apache2.pid
ENV APACHE_SERVER_NAME localhost

# Copy apache vhost file to proxy php requests to php-fpm container
COPY demo.apache.conf /usr/local/apache2/conf/demo.apache.conf
COPY main.apache.conf /usr/local/apache2/sites-enabled/main.apache.conf

RUN echo "Include /usr/local/apache2/conf/demo.apache.conf" \
    >> /usr/local/apache2/conf/httpd.conf

RUN sed -i '/LoadModule rewrite_module/s/^#//g' /usr/local/apache2/conf/httpd.conf && \
    sed -i 's#AllowOverride [Nn]one#AllowOverride All#' /usr/local/apache2/conf/httpd.conf

RUN mkdir -p /var/log/apache2/
RUN chmod -R 744 /var/log/apache2/

EXPOSE 80
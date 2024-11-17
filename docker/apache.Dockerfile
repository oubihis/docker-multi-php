# docker/apache.Dockerfile
FROM httpd:2.4

# Install required Apache modules and enable SSL
RUN sed -i '/LoadModule ssl_module/s/^#//g' /usr/local/apache2/conf/httpd.conf && \
    sed -i '/LoadModule socache_shmcb_module/s/^#//g' /usr/local/apache2/conf/httpd.conf && \
    sed -i '/LoadModule rewrite_module/s/^#//g' /usr/local/apache2/conf/httpd.conf && \
    sed -i '/LoadModule proxy_module/s/^#//g' /usr/local/apache2/conf/httpd.conf && \
    sed -i '/LoadModule proxy_fcgi_module/s/^#//g' /usr/local/apache2/conf/httpd.conf

# Configure SSL
RUN sed -i 's#^SSLCertificateFile.*#SSLCertificateFile "/usr/local/apache2/certs/cert.pem"#g' /usr/local/apache2/conf/extra/httpd-ssl.conf && \
    sed -i 's#^SSLCertificateKeyFile.*#SSLCertificateKeyFile "/usr/local/apache2/certs/key.pem"#g' /usr/local/apache2/conf/extra/httpd-ssl.conf

# Enable SSL configuration
RUN echo "Include conf/extra/httpd-ssl.conf" >> /usr/local/apache2/conf/httpd.conf && \
    echo "Include conf/extra/vhost.conf" >> /usr/local/apache2/conf/httpd.conf

EXPOSE 80 443
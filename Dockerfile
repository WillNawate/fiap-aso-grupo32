FROM centos/centos:8

LABEL author="Willian Nawate"
LABEL email="wnoliveira@wno.co.com"
LABEL description="A custom Apache container based on CentOS 8"

RUN yum install -y httpd && \
    yum clean all

RUN echo "Hello from Grupo32 - RM341783" > /var/www/html/index.html

EXPOSE 80

CMD ["httpd", "-D", "FOREGROUND"]
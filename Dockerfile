FROM roove/ubuntu-py3:latest

MAINTAINER Roove, contato@roove.com.br

RUN apt-get update --fix-missing
RUN apt-get install -y apt-utils libaio-dev unzip

RUN echo "deb http://us-west-2.ec2.archive.ubuntu.com/ubuntu/ trusty multiverse" >> /etc/apt/sources.list.d/multiverse.list
RUN echo "deb http://us-west-2.ec2.archive.ubuntu.com/ubuntu/ trusty-updates multiverse" >> /etc/apt/sources.list.d/multiverse.list
RUN echo "deb http://us-west-2.ec2.archive.ubuntu.com/ubuntu/ trusty-backports main restricted universe multiverse" >> /etc/apt/sources.list.d/multiverse.list
RUN apt-get update

RUN curl https://downloads.wkhtmltopdf.org/0.12/0.12.4/wkhtmltox-0.12.4_linux-generic-amd64.tar.xz --output wkhtmltox-0.12.4.tar.xz \
    && tar xf wkhtmltox-0.12.4.tar.xz \
    && cp -r wkhtmltox/* /usr/local/

RUN apt-get install libxrender1 fontconfig xvfb -y

ENV ORACLE /usr/local/oracle
ENV ORACLE_HOME $ORACLE
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:$ORACLE
ENV C_INCLUDE_PATH $C_INCLUDE_PATH:$ORACLE

RUN apt-get update \
    && mkdir $ORACLE \
    && curl -L https://github.com/thiagovarela/oracle_instantclient/raw/master/instantclient-basic-linux.x64-12.1.0.2.0.zip -o basic.zip \
    && curl -L https://github.com/thiagovarela/oracle_instantclient/raw/master/instantclient-sdk-linux.x64-12.1.0.2.0.zip -o sdk.zip

RUN unzip basic.zip -d $ORACLE && unzip sdk.zip -d $ORACLE

RUN cd $ORACLE_HOME && ln -s libclntsh.so.12.1 libclntsh.so
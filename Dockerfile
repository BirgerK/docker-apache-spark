FROM phusion/baseimage:0.9.19
MAINTAINER BirgerK <birger.kamp@gmail.com>

ENV SPARK_VERSION 2.0.0
ENV SPARK_INSTALL /usr/local
ENV SPARK_HOME $SPARK_INSTALL/spark
ENV SPARK_ROLE master
ENV HADOOP_VERSION 2.7
ENV SPARK_MASTER_PORT 7077
ENV PYSPARK_PYTHON python3
ENV DOCKERIZE_VERSION v0.2.0

RUN echo "deb http://cran.rstudio.com/bin/linux/ubuntu xenial/" | tee -a /etc/apt/sources.list && \
    gpg --keyserver keyserver.ubuntu.com --recv-key E084DAB9 && \
    gpg -a --export E084DAB9 | apt-key add - && \
    apt-get update && \
    apt-get install -y openjdk-8-jdk autossh python3-pip && \
    apt-get install -y r-base r-base-dev build-essential libssl-dev libcurl4-gnutls-dev libxml2-dev libcairo-dev libssh2-1-dev mesa-common-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# install dockerize
RUN curl -L -O https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz && \
    tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz && \
    rm -rf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

# install R packages
RUN R CMD javareconf \
    && R -e "install.packages('shiny', repos = 'http://cran.us.r-project.org', dependencies=T)" \
    && R -e "install.packages('devtools', repos = 'http://cran.us.r-project.org', dependencies=T)" \
    && R -e "install.packages('knitr', repos = 'http://cran.us.r-project.org', dependencies=T)" \
    && R -e "install.packages('ggplot2', repos = 'http://cran.us.r-project.org', dependencies=T)" \
    && R -e "install.packages(c('devtools','mplot', 'googleVis'), repos = 'http://cran.us.r-project.org', dependencies=T);" \

##### INSTALL APACHE SPARK WITH HDFS
RUN curl -s http://mirror.synyx.de/apache/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION.tgz | tar -xz -C $SPARK_INSTALL && \
    cd $SPARK_INSTALL && ln -s spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION spark

WORKDIR $SPARK_HOME

##### ADD Scripts
RUN mkdir /etc/service/spark
ADD runit/spark.sh /etc/service/spark/run
RUN chmod +x /etc/service/**/*

EXPOSE 4040 6066 7077 7078 8080 8081 8888

VOLUME ["$SPARK_HOME/logs"]

CMD ["/sbin/my_init"]

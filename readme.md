# Apache Spark as Docker-Container
In the `docker-compose.yml` you can see an example use of this image in master-slave-mode.

This image supports the usage of Java8,Python3 and R.

## Running Custom Code
There are 2 types of spark-container: master and slave.

## Running in Master-Slave-Mode
For running this docker-image in master-slave mode some customizations at the configuration and a environment-variable must be set.

### Choosing Roles
A container created by this image runs by default as master, so you don't have to tell the master-container about his might.

On the slaves you have to change the environment-variable `SPARK_ROLE` to 'slave'. A slave can be started f.e. by: `docker run --rm -it -e "SPARK_ROLE=slave" birgerk/apache-spark`

### Configuration
For getting your master and slaves talking to each other, you have only to set the environment-variable `SPARK_MASTER`.
Most Spark config-params can be set by simple environment-variables. Use it!

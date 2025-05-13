FROM drhazem95/pyspark_db_python:v1.3
LABEL maintainer="Hazem Omar"
USER root
RUN apt update && apt upgrade -y
WORKDIR /usr/local/spark/jars/
COPY mssql-jdbc-12.6.1.jre8.jar .
USER jovyan

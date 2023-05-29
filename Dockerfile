# Pull tomcat latest image from dockerhub
FROM tomcat:8.0.51-jre8-alpine
MAINTAINER kusumwakare511@gmail.com
# copy war file on to container
COPY ./target/bookStore-ms*.jar /usr/local/tomcat/webapps
EXPOSE  8080
USER bookStore
WORKDIR /usr/local/tomcat/webapps
CMD ["catalina.sh","run"]
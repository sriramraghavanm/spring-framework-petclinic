# syntax=docker/dockerfile:1.7

##############################################
# 1) Build stage
##############################################
FROM maven:3.9.9-eclipse-temurin-17 AS build
WORKDIR /app

COPY pom.xml .
COPY src ./src

RUN --mount=type=cache,target=/root/.m2 \
    mvn -DskipTests clean package

RUN ls -lah /app/target

##############################################
# 2) Runtime stage
##############################################
FROM tomcat:11.0-jdk21-temurin

RUN rm -rf /usr/local/tomcat/webapps/*

# Pre-expand the WAR so Tomcat never needs to create webapps/ROOT at runtime
COPY --from=build /app/target/petclinic.war /tmp/ROOT.war
RUN mkdir -p /usr/local/tomcat/webapps/ROOT \
 && cd /usr/local/tomcat/webapps/ROOT \
 && jar -xf /tmp/ROOT.war \
 && rm -f /tmp/ROOT.war

# Make Tomcat's runtime dirs writable by ANY uid (K8s always runs with gid 0)
RUN mkdir -p /usr/local/tomcat/conf/Catalina/localhost \
 && chgrp -R 0 /usr/local/tomcat \
 && chmod -R g=u /usr/local/tomcat

EXPOSE 8080
CMD ["catalina.sh", "run"]

# syntax=docker/dockerfile:1.7

##############################################
# 1) Build stage
##############################################
FROM maven:3.9.9-eclipse-temurin-17 AS build

WORKDIR /app

# Copy only what's needed to build
COPY pom.xml .
COPY src ./src

# Build WAR (skip tests for faster container build)
RUN --mount=type=cache,target=/root/.m2 \
    mvn -DskipTests clean package

# Optional: show generated artifacts during build logs
RUN ls -lah /app/target


##############################################
# 2) Runtime stage
##############################################
FROM tomcat:11.0-jdk21-temurin

# Remove default webapps and deploy app as ROOT
RUN rm -rf /usr/local/tomcat/webapps/*
COPY --from=build /app/target/petclinic.war /usr/local/tomcat/webapps/ROOT.war

# Ensure Tomcat runtime dirs exist and are writable
# (important when K8s enforces non-root execution)
RUN mkdir -p /usr/local/tomcat/conf/Catalina/localhost \
    /usr/local/tomcat/webapps \
    /usr/local/tomcat/work \
    /usr/local/tomcat/temp \
    /usr/local/tomcat/logs \
 && chown -R 10001:10001 /usr/local/tomcat

# Run as non-root (match your cluster security context)
USER 10001:10001

EXPOSE 8080

CMD ["catalina.sh", "run"]

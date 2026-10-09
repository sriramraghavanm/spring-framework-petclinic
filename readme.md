# Spring Framework Petclinic

Spring Petclinic is a sample veterinary clinic application built with the Spring Framework. It is a classic, deployable WAR application—not a Spring Boot application—and uses JSP for its web views.

## Features and architecture

- Spring MVC web layer with JSP and Jakarta Servlet/JSP APIs.
- Three-layer design: presentation, service, and repository.
- Spring Data JPA, Hibernate, and JDBC-based persistence implementations.
- XML-based Spring configuration, with profiles for selecting the persistence implementation.
- H2, HSQLDB, MySQL, and PostgreSQL database configurations.

## Prerequisites

- JDK 17 or newer for local Maven builds.
- Docker, if you want to build or run the container image.

The Maven Wrapper is included, so you do not need to install Maven separately. The Maven Enforcer configuration requires Maven 3.8.4 or newer if you use a system Maven installation.

## Quick start

```bash
git clone https://github.com/sriramraghavanm/spring-framework-petclinic.git
cd spring-framework-petclinic
./mvnw jetty:run-war
```

On Windows, run `mvnw.cmd jetty:run-war` (or `.\mvnw.cmd jetty:run-war` in PowerShell). Open [http://localhost:8080](http://localhost:8080).

To build and test the WAR without starting the application:

```bash
./mvnw verify
```

## Configuration

### Persistence implementation

The Spring profile defaults to `jpa`. Choose `jdbc` or `spring-data-jpa` with the `spring.profiles.active` system property:

```bash
./mvnw jetty:run-war -Dspring.profiles.active=jdbc
./mvnw jetty:run-war -Dspring.profiles.active=spring-data-jpa
```

The Maven database profile is separate from the Spring persistence profile. H2 is the default database; the available Maven profiles are `H2`, `HSQLDB`, `MySQL`, and `PostgreSQL`. For example, start the app with MySQL configuration using:

```bash
./mvnw jetty:run-war -PMySQL
```

MySQL and PostgreSQL require a running database service. Database connection and initialization settings are defined by Maven properties in `pom.xml` and consumed by `src/main/resources/spring/data-access.properties`. The key properties are `jdbc.driverClassName`, `jdbc.url`, `jdbc.username`, `jdbc.password`, `db.script`, and `jpa.database`. The JDBC URL and credentials can be overridden with JVM system properties.

## Running with Docker

The `Dockerfile` builds the WAR with Maven and JDK 17, then runs it from the `ROOT` context on Tomcat 11 with JDK 21:

```bash
docker build -t spring-framework-petclinic .
docker run --rm -p 8080:8080 spring-framework-petclinic
```

Open [http://localhost:8080](http://localhost:8080). The container uses the application's default H2 configuration.

## Development notes

- Spring application configuration is under `src/main/resources/spring/`; JSP views are under `src/main/webapp/WEB-INF/jsp/`.
- Persistence implementations are in `src/main/java/org/springframework/samples/petclinic/repository/`.
- Stylesheet source is `src/main/webapp/resources/scss/petclinic.scss`. Recompile the SCSS (including Bootstrap resources) with:

  ```bash
  ./mvnw generate-resources -Pcss
  ```

  The generated stylesheet is `src/main/webapp/resources/css/petclinic.css`.
- The packaged WAR is `target/petclinic.war`.

## Contributing

Please open an issue for bugs or suggestions, and submit pull requests against this repository. Keep changes focused and include tests when changing application behavior.

- [Issues](https://github.com/sriramraghavanm/spring-framework-petclinic/issues)
- [Pull requests](https://github.com/sriramraghavanm/spring-framework-petclinic/pulls)

FROM adoptopenjdk/openjdk11-openj9:alpine-slim
LABEL author="Sofus Albertsen"
COPY build/libs/hello-*-all.jar /app.jar
EXPOSE 8000
#hadolint ignore=DL3025
CMD java -Dcom.sun.management.jmxremote -noverify ${JAVA_OPTS} -jar app.jar

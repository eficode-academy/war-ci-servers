#! /bin/bash
echo executing from "$PWD"
docker run --rm -v "$PWD":/home/gradle/project -w /home/gradle/project gradle:6-jdk11 ls -al
docker run --rm -v "$PWD":/home/gradle/project -w /home/gradle/project gradle:6-jdk11 gradle shadowjar -p app

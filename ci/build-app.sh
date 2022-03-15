#! /bin/bash
docker run --rm -v "$PWD":/home/gradle/project -w /home/gradle/project gradle:6-jdk11 gradle shadowjar -p app

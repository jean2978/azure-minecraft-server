FROM ubuntu:latest

#Install defautl-jre
RUN apt-get update && \
    apt-get install --yes software-properties-common \
    && apt install -y default-jre

#Fetch minecraft server jar-file
RUN mkdir server &&  apt-get install -y wget && cd server \
    && wget https://launcher.mojang.com/v1/objects/c8f83c5655308435b3dcf03c06d9fe8740a77469/server.jar
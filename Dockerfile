
# deepspeech npm package does not work with newer versions of node
FROM node:14-buster

RUN npm install -g npm

ENV HOME /home/deepspeech

RUN mkdir $HOME
WORKDIR $HOME

ARG DEEPSPEECH_PACKAGE=deepspeech
ENV DEEPSPEECH_PACKAGE=$DEEPSPEECH_PACKAGE

RUN apt-get update
RUN apt-get install python3-pip -y
RUN pip3 install $DEEPSPEECH_PACKAGE
RUN npm install deepspeech

COPY *.js $HOME/
COPY *.json $HOME/
RUN npm install

CMD node deepSpeechTranscriptServer.js $HOME/model/model.pbmm $HOME/model/model.scorer

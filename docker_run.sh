source ./docker_stop.sh

sudo docker run -d \
--name deepspeech-server-js \
-v ${PWD}/audio/:/home/deepspeech/audio/ \
-v ${PWD}/config/:/home/deepspeech/config/ \
-v ${PWD}/model/:/home/deepspeech/model/ \
-p 3000:3000 \
deepspeech-server-js

# DeepSpeechJs

DeepSpeech runtime transcript NodeJs native client.
Some examples and tests. 

## What's DeepSpeech?

[DeepSpeech](https://github.com/mozilla/DeepSpeech) is an open-source Speech-To-Text engine.
Documentation for installation, usage, and training models are available on deepspeech.readthedocs.io.


## DeepSpeech run-time transcript, from Node Js

You want to access DeepSpeech speech to text runtime transcription from a well formatted WAV file, using NodeJs.
I tested two options:

1. Spawning, from your NodeJs main thread, an external DeepSpeech command line program.
   That's the simplest, dumb and slow way in terms of performances.
   In general, spawning an external process, catching his stdout is a trivial approach, 
   but applicable all times you do not have better inter process communication options. 

   Example: [deepSpeechTranscriptSpawn.js](deepSpeechTranscriptSpawn.js).

2. Using DeepSpeech native NodeJs client interface. 
   That's a more performant way.
 
   Example: [deepSpeechTranscriptNative.js](deepSpeechTranscriptNative.js).
 
   The example is very raugh, presuming the audio file is a "well formatted" WAV file. 
   The audio file is just read in memory and the deepspeech `model.stt()` API is called.
   [Official examples](https://github.com/mozilla/DeepSpeech-examples#javascript) repo
   contains audio examples that show how to validate WAV, 
   and speeech processing from streaming / in-memory buffers.

### DeepSpeech official native NodeJs API

- [Native client source code](https://github.com/mozilla/DeepSpeech/tree/v0.9.3/native_client/javascript)
- [API Documentation](https://deepspeech.readthedocs.io/en/v0.9.3/NodeJS-API.html#)
- [Usage Examples](https://github.com/mozilla/DeepSpeech-examples#javascript)

### Wat's a well formatted WAV audio file?

DeepSpeech requires a 16bit 16 KHz mono WAV input audio file.
To record such a file:
```
sudo apt install sox
sudo apt install mediainfo

rec -f S16_BE -r 16000 -c 1 my_recording.wav

mediainfo my_recording.wav
General
Complete name                            : my_recording.wav
Format                                   : Wave
File size                                : 64.0 KiB
Duration                                 : 2 s 48 ms
Overall bit rate mode                    : Constant
Overall bit rate                         : 256 kb/s

Audio
Format                                   : PCM
Format settings                          : Little / Signed
Codec ID                                 : 1
Duration                                 : 2 s 48 ms
Bit rate mode                            : Constant
Bit rate                                 : 256 kb/s
Channel(s)                               : 1 channel
Sampling rate                            : 16.0 kHz
Bit depth                                : 16 bits
Stream size                              : 64.0 KiB (100%)
```

## Install

1. Install DeepSpeech

   ```bash
   # Create and activate a virtualenv
   virtualenv -p python3 $HOME/tmp/deepspeech-venv/
   source $HOME/tmp/deepspeech-venv/bin/activate

   # Install DeepSpeech
   pip3 install deepspeech

   # Download pre-trained English model files
   curl -LO https://github.com/mozilla/DeepSpeech/releases/download/v0.9.3/deepspeech-0.9.3-models.pbmm
   curl -LO https://github.com/mozilla/DeepSpeech/releases/download/v0.9.3/deepspeech-0.9.3-models.scorer

   mkdir models
   mv *.pbmm *.scorer models/

   # Download example audio files
   curl -LO https://github.com/mozilla/DeepSpeech/releases/download/v0.9.3/audio-0.9.3.tar.gz
   tar xvf audio-0.9.3.tar.gz

   # Transcribe an audio file
   deepspeech --model models/deepspeech-0.9.3-models.pbmm --scorer models/deepspeech-0.9.3-models.scorer --audio audio/2830-3980-0043.wav
   ```

2. Install this repo
   ```bash
   git clone https://solyarisoftware/deepspeeechjs && cd deepspeeechjs
   ```

3. Install the official DeepSpeech npm package
   ```bash
   npm install deepspeech
   ```

## Run the test

The bash script `test_elapsed.sh` compares elapsed times 
of transcript of the audio file `./audio/4507-16021-0012.wav` 
(corresponding to text *why should one halt on the way*), in 3 cases:

- using a bash script running the CLI `deepspeech` official client [deepspeech_cli.sh](deepspeech_cli.sh) 
- using the nodejs "spawn" client [deepSpeechTranscriptSpawn.js](deepSpeechTranscriptSpawn.js)
- using the nodejs native client [deepSpeechTranscriptNative.js](deepSpeechTranscriptNative.js)

```
(deepspeech-venv) $ test_elapsed.sh
```
```

deepspeech_cli

Loading model from file models/deepspeech-0.9.3-models.pbmm
TensorFlow: v2.3.0-6-g23ad988
DeepSpeech: v0.9.3-0-gf2e9c85
2021-01-31 11:04:53.878150: I tensorflow/core/platform/cpu_feature_guard.cc:142] This TensorFlow binary is optimized with oneAPI Deep Neural Network Library (oneDNN)to use the following CPU instructions in performance-critical operations:  AVX2 FMA
To enable them in other operations, rebuild TensorFlow with the appropriate compiler flags.
Loaded model in 0.0121s.
Loading scorer from files models/deepspeech-0.9.3-models.scorer
Loaded scorer in 0.000152s.
Running inference.
why should one halt on the way
Inference took 1.527s for 2.735s audio file.

real	0m1,798s
user	0m2,483s
sys	0m0,495s

deepSpeechTranscriptSpawn

why should one halt on the way

real	0m1,832s
user	0m2,509s
sys	0m0,544s

deepSpeechTranscriptNative

usage: node deepSpeechTranscriptNative [<model pbmm file>] [<model scorer file>] [<audio file>]
using: node deepSpeechTranscriptNative ./models/deepspeech-0.9.3-models.pbmm ./models/deepspeech-0.9.3-models.scorer ./audio/4507-16021-0012.wav

TensorFlow: v2.3.0-6-g23ad988
DeepSpeech: v0.9.3-0-gf2e9c85
2021-01-31 11:05:01.371379: I tensorflow/core/platform/cpu_feature_guard.cc:142] This TensorFlow binary is optimized with oneAPI Deep Neural Network Library (oneDNN)to use the following CPU instructions in performance-critical operations:  AVX2 FMA
To enable them in other operations, rebuild TensorFlow with the appropriate compiler flags.

pbmm      : ./models/deepspeech-0.9.3-models.pbmm
scorer    : ./models/deepspeech-0.9.3-models.scorer
elapsed   : 11ms

audio file: ./audio/4507-16021-0012.wav
transcript: why should one halt on the way
elapsed   : 1553ms

real	0m1,669s
user	0m1,928s
sys	0m0,103s
```

As expected, the native client transcript elapsed time (1553ms), is much better than the spawn client (1832ms).

## Disclaimer 

IMPORTANT: unfortunately npm package `deepspeech` cause a crash using node version 16.0.0.
See [issue](https://github.com/mozilla/DeepSpeech/issues/3642).
To run this project you have to downgrade installed Node version. 
By example I had success with Node version 14.16.1.


## Changelog

- 0.0.9 test script testPerformances.sh improved


## To do

- The project is in a very draft stage.
- Add a better high-level API interface. E.g. including metadata as parameters
- Add a web server architectue. 
  See: [How to use DeepSpeech for a text-to-speech server (in NodeJs)](https://discourse.mozilla.org/t/how-to-use-deepspeech-for-a-text-to-speech-server-in-nodejs/79636/2) 


## License

MIT (c) Giorgio Robino 


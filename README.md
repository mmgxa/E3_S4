<div align="center">

# dlearn

</div>


## Introduction

This is a simple template based on Hydra for running deep learning projects using PyTorch Lightning.


## Installation


To install in dev mode

```
pip install -e .
```

Then, you can view help using

```
dlearn_train --help
```


## Running dlearn

To train your model, execute
```
dlearn_train
```

The template supports loading any model in the `timm` library. You can override the default `resnet34` model via e.g.

```
dlearn_train model.net.model_name=resnet50
```
For testing, you **have** to specify the latest checkpoint. The following snippet extracts the latest run and evaluates using `trainer.test`


```
best_ckpt=$(ls -td -- ./outputs/*/* | head -n 1)'/checkpoints/best.ckpt'
dlearn_eval ckpt_path=$best_ckpt
```

If you have changed the default model during training, don't forget to append it!

## Docker

We can build the docker image using 

```
docker build -t emlo:s4 .
```

To persist output data between multiple runs (training followed by evaluation), we can first create a volume that persists after a container exits.

```
docker create -v /app/outputs --name output-vol busybox /bin/true
```

Then, we can do the following

```
# for training
docker run --volumes-from output-vol --rm --shm-size=1024m emlo:s4

# note the best checkpoint path in the terminal
# for evaluation
docker run --volumes-from output-vol --rm --shm-size=1024m emlo:s4 dlearn_eval ckpt_path='...'
```

A sanity check for both the native as well as the docker version of the app is that the test metrics printed at the end of training and after evaluation are the same, which means the model's checkpoint is loaded correctly in both cases (and that it persists in the latter case)
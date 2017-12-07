
GGV notebooks
=============

## Description

* Download join.gov.tw discussions (for example [this](https://join.gov.tw/policies/detail/ce9a5e5f-85ab-4cac-9c8d-cf2e5206ea7c) and [this](https://join.gov.tw/policies/detail/f69c2804-ba8c-46b0-b24f-6ae5db845789)).
* Jieba
* [fastText](https://github.com/facebookresearch/fastText/blob/master/pretrained-vectors.md)
* Text classification

## Requirements

* Python 2.x and [pipenv](https://docs.pipenv.org/).
* [curl](https://curl.haxx.se/), [jq](https://stedolan.github.io/jq/)

## Usage

```
$ make all    # this will download ~4GB of word embedding models
```

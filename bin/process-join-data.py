#!/usr/bin/env python

import os, re, pandas as pd

path = os.path.join("nbs", "data", "join")

topic = "立法方式保障"

split_re = re.compile(r"(?:。|？|！|\.|\?|!)+")
# <https://stackoverflow.com/questions/161738/what-is-the-best-regular-expression-to-check-if-a-string-is-a-valid-url#190405>
clean_re = re.compile(r"(\b(https?|ftp|file)://)?[-A-Za-z0-9+&@#/%?=~_|!:,.;]+[-A-Za-z0-9+&@#/%=~_|]")

def get_sentences(fn):
    for message in pd.read_csv(fn, index_col=0).content:
        message = clean_re.sub("", message)
        for sentence in split_re.split(message):
            if len(sentence) > 0:
                yield sentence

sentences = [ s for s in get_sentences(os.path.join(path, topic + ".csv")) ]

df = pd.DataFrame({
    "sentence": sentences,
    "orid": "",
})

df.to_csv(os.path.join(path, topic + "-sentences.csv"))

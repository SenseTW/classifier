
.PHONY: all nb install download data download-models

all: install download download-models data nb

install:
	pipenv install
	pipenv run pip freeze > requirements.txt

nb:
	KERAS_BACKEND=theano pipenv run jupyter notebook

download:
	mkdir -p nbs/data/join
	cd nbs/data/join; \
		[ -r 眾開講.json ] || curl -o 眾開講.json https://join.gov.tw/toOpenData/ey/policy; \
		[ -r 來監督.json ] || curl -o 來監督.json -C - https://join.gov.tw/toOpenData/ey/act; \
		[ -r 提點子.json ] || curl -o 提點子.json -C - https://join.gov.tw/toOpenData/ey/idea; \

download-models:
	mkdir -p nbs/data/join/models
	cd nbs/data/join/models; \
		[ -r wiki.zh.zip ] \
			|| (curl -O -C - https://s3-us-west-1.amazonaws.com/fasttext-vectors/wiki.zh.zip \
			&& unzip wiki.zh.zip)

data:
	cd nbs/data/join; \
		jq -r 'map(select(.url=="http://join.gov.tw/policies/detail/ce9a5e5f-85ab-4cac-9c8d-cf2e5206ea7c")) | .[0].messages | to_entries | ["id", "createDate", "authorName", "content", "ORID", "comments"] as $$cols | $$cols, map([.key, .value.createDate, .value.authorName, .value.content, "", ""])[] | @csv' 眾開講.json > 立法方式保障.csv; \
		jq -r 'map(select(.url=="http://join.gov.tw/policies/detail/f69c2804-ba8c-46b0-b24f-6ae5db845789")) | .[0].messages | to_entries | ["id", "createDate", "authorName", "content", "ORID", "comments"] as $$cols | $$cols, map([.key, .value.createDate, .value.authorName, .value.content, "", ""])[] | @csv' 眾開講.json > 同性婚姻法.csv; \
		jq -r 'map(select(.url=="http://join.gov.tw/policies/detail/411bf889-b52f-417b-8acf-31830d93e9bc")) | .[0].messages | to_entries | ["id", "createDate", "authorName", "content", "ORID", "comments"] as $$cols | $$cols, map([.key, .value.createDate, .value.authorName, .value.content, "", ""])[] | @csv' 眾開講.json > 同性伴侶法.csv; \

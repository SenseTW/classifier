
.PHONY: all nb install download data download-models

all: init-project install download nb

init-project:
	pipenv --python $$(cat .python-version)

install:
	pipenv install
	pipenv run pip freeze > requirements.txt

nb:
	KERAS_BACKEND=tensorflow pipenv run jupyter notebook

download: download-fasttext

download-join:
	mkdir -p nbs/data/join
	cd nbs/data/join; \
		[ -r 眾開講.json ] || curl -o 眾開講.json https://join.gov.tw/toOpenData/ey/policy; \
		[ -r 來監督.json ] || curl -o 來監督.json -C - https://join.gov.tw/toOpenData/ey/act; \
		[ -r 提點子.json ] || curl -o 提點子.json -C - https://join.gov.tw/toOpenData/ey/idea; \

download-fasttext:
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

download-good:
	cd nbs/data/join; \
		curl -o 立法方式保障-good.csv "https://docs.google.com/spreadsheets/d/e/2PACX-1vQInEMxf8bKqvKN8YUC8JYQMHhdcC0SU4EgrJMP-A4u4Bc7065u6cthTmp7vADsGykw1e1whh6LlWmj/pub?gid=1787434008&single=true&output=csv"; \
		curl -o 同性婚姻法-good.csv "https://docs.google.com/spreadsheets/d/e/2PACX-1vTOjan1dKMF4kiVIop-GPvd7heUe_60TLnq7K11iVM3QCcAWA4IS6JbURLxEvax3bGzvFDp-EFLNRFd/pub?gid=1556811471&single=true&output=csv"; \
		curl -o 同性伴侶法-good.csv "https://docs.google.com/spreadsheets/d/e/2PACX-1vRff5KNfQUHMKDWPPNdt9xanvmshboAGzR0oIIQXDoZ_OlqhAekak5ag2_DNx3_2E3AfEXe9NpzQTyv/pub?gid=789624075&single=true&output=csv"; \

download-hotel:
	mkdir -p nbs/data/hotel
	cd nbs/data/hotel; \
		wget "https://github.com/nkfly/nlp/raw/master/207884_hotel_training.txt"; \
		wget "https://github.com/nkfly/nlp/raw/master/211047_hotel_test.txt"

download-conversation-sentiment:
	mkdir -p nbs/data/conversation_sentiment
	cd nbs/data/conversation_sentiment; \
		wget "https://github.com/z17176/Chinese_conversation_sentiment/raw/master/sentiment_XS_30k.txt"; \
		wget "https://raw.githubusercontent.com/z17176/Chinese_conversation_sentiment/master/sentiment_XS_test.txt"

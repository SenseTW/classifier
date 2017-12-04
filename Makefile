
.PHONY: all download data

all:
	@echo "Usage: make (download|data)"

download:
	mkdir -p data/join
	cd data/join; \
	curl -o 眾開講.json https://join.gov.tw/toOpenData/ey/policy; \
	curl -o 來監督.json https://join.gov.tw/toOpenData/ey/act; \
	curl -o 提點子.json https://join.gov.tw/toOpenData/ey/idea; \

data:
	cd data/join; \
	jq -r 'map(select(.url=="http://join.gov.tw/policies/detail/ce9a5e5f-85ab-4cac-9c8d-cf2e5206ea7c")) | .[0].messages | ["createDate", "authorName", "content"] as $$cols | map(. as $$row | $$cols | map($$row[.])) as $$rows | $$cols, $$rows[] | @csv' 眾開講.json > 立法方式保障.csv; \
	jq -r 'map(select(.url=="http://join.gov.tw/policies/detail/f69c2804-ba8c-46b0-b24f-6ae5db845789")) | .[0].messages | ["createDate", "authorName", "content"] as $$cols | map(. as $$row | $$cols | map($$row[.])) as $$rows | $$cols, $$rows[] | @csv' 眾開講.json > 同性婚姻法.csv; \
	jq -r 'map(select(.url=="http://join.gov.tw/policies/detail/411bf889-b52f-417b-8acf-31830d93e9bc")) | .[0].messages | ["createDate", "authorName", "content"] as $$cols | map(. as $$row | $$cols | map($$row[.])) as $$rows | $$cols, $$rows[] | @csv' 眾開講.json > 同性伴侶法.csv; \

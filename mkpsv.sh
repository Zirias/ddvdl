#!/bin/sh

# update the .psv file for downloading, needs curl

curl -v -d @/tmp/query.json \
	-H "Content-Type: text/plain" -H "User-Agent: ax mvclient 0.1.1" \
	https://mediathekviewweb.de/api/query \
	| sed -e 's:},{:\n:g' \
	| sed -e 's/.*"title":"Folge [0-9]*: Diener des Volkes (//' \
		-e 's:S01/:S01:' \
		-e 's/)",.*"url_subtitle":"/.mkv|/' \
		-e 's/",.*"url_video_hd":"/|/' \
		-e 's/",.*//' \
	| sort >ddv.psv


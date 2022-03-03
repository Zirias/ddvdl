#!/bin/sh

# requirements: curl, perl (with XML::Simple), mkvtoolnix
# perl script from https://github.com/mattfoo/ebu-tt_to_srt

# usage: sh dl.sh <output dir>

dir=$1

#Linux etc
fetch="wget -O"

#FreeBSD
#fetch="fetch -o"

curl -d @/tmp/query.json \
	-H "Content-Type: text/plain" -H "User-Agent: ax mvclient 0.1.1" \
	https://mediathekviewweb.de/api/query \
	| sed -e 's:},{:\n:g' \
	| sed -e 's/.*"title":"Folge [0-9]*: Diener des Volkes (//' \
		-e 's:S01/:S01:' \
		-e 's/)",.*"url_subtitle":"/.mkv|/' \
		-e 's/",.*"url_video_hd":"/|/' \
		-e 's/",.*//' \
	| sort >ddv.psv

for l in `cat ddv.psv`; do
	t=`echo $l | cut -d '|' -f 1`
	s=`echo $l | cut -d '|' -f 2`
	v=`echo $l | cut -d '|' -f 3`

	$fetch sub.xml $s
	perl ebu2srt.pl sub.xml >sub
	$fetch vid.mp4 $v
	mkvmerge -o "$dir/$t" --language 1:ukr vid.mp4 --language 0:ger sub
	rm sub.xml sub vid.mp4
done


#!/bin/bash
# set -o pipefail

source config.bash

##
## This file run parser on all raw output based on thier names and return one JSON file to standard output
## params: - output folder of the raw files - input file
##
if [ -z "$2" ]; then
	echo "usage: $0 outputsFolder sourceFile";
	exit 2;
fi

if [ -z "$1" ]; then
	echo "usage: $0 outputsFolder sourceFile";
	exit 1;
fi

TMP=$( cd $(dirname $1) ; pwd -P )
TMP2=$( basename $1 )
OUTPUTS="$TMP/$TMP2"

TMP=$( cd $(dirname $2) ; pwd -P )
TMP2=$( basename $2 )
SOURCE="$TMP/$TMP2"

TMP=$( cd $(dirname $3) ; pwd -P )
TMP2=$( basename $3)
OUT="$TMP/$TMP2"

TOOL=$4

SEP=","
echo "{" > $OUT

if [ -s $SOURCE.dia ]; then
	echo "\"RawDia\":"  | tee /dev/tty >> $OUT
	( ( cat "$SOURCE.dia" | ./resultsParser.main.js -t RAW -s $SOURCE ) >> $OUT || echo "[]" ) >> $OUT
	echo -n $SEP >> $OUT;
fi

echo "\"Raw\":" | tee /dev/tty >> $OUT
( cat "$SOURCE" | ./resultsParser.main.js -t RAW -s $SOURCE ) >> $OUT || echo "[]" >> $OUT
echo -n $SEP >> $OUT;

# if [ ! -s $OUTPUTS/RAWSEG ]; then
# 	java -jar $BASE/FarasaSegmenter/dist/FarasaSegmenterJar.jar -i "$SOURCE" | ./resultsParser.main.js -t RAW -s >> $OUTPUTS/RAWSEG
# fi

# echo "\"RawSeg\":" | tee /dev/tty >> $OUT
# cat $OUTPUTS/RAWSEG >> $OUT
# echo -n $SEP >> $OUT;


if [[ "$TOOL" =~ AR ]] || [ "$TOOL" == "MAN" ]; then
	if [ -s $OUTPUTS/AR.json ]; then
		echo "\"AR\":" | tee /dev/tty >> $OUT
		cat $OUTPUTS/AR.json >> $OUT;
	fi
	echo -n $SEP >> $OUT;
fi

if [[ "$TOOL" =~ MD ]] || [ "$TOOL" == "POS" ]; then
	if [ -s $OUTPUTS/MD.json ]; then
		echo "\"MD\":" | tee /dev/tty >> $OUT
		cat $OUTPUTS/MD.json >> $OUT;
	fi
	echo -n $SEP >> $OUT;
fi

if [[ "$TOOL" == "MA" ]] || [ "$TOOL" == "POS" ]; then
	if [ -s $OUTPUTS/MA.json ]; then
		echo "\"MA\":" | tee /dev/tty >> $OUT
		cat $OUTPUTS/MA.json >> $OUT;
	fi
	echo -n $SEP >> $OUT;
fi

if [[ "$TOOL" =~ MX ]] || [ "$TOOL" == "POS" ]; then
	if [ -s $OUTPUTS/MX.json ]; then
		echo "\"MX\":" | tee /dev/tty >> $OUT
		cat $OUTPUTS/MX.json >> $OUT;
	fi
	echo -n $SEP >> $OUT;
fi

if [[ "$TOOL" =~ AL ]] || [ "$TOOL" == "MAN" ]; then
	if [ -s $OUTPUTS/AL.json ]; then
		echo "\"AL\":" | tee /dev/tty >> $OUT
		cat $OUTPUTS/AL.json >> $OUT;
	fi
	echo -n $SEP >> $OUT;
fi

fi

if [[ "$TOOL" =~ XE ]] || [ "$TOOL" == "MAN" ]; then
	if [ -s $OUTPUTS/XE.json ]; then
		echo "\"XE\":" | tee /dev/tty >> $OUT
		cat $OUTPUTS/XE.json >> $OUT;
	fi
	echo -n $SEP >> $OUT;
fi

if [[ "$TOOL" =~ KH ]] || [ "$TOOL" == "MAN" ]; then
	if [ -s $OUTPUTS/KH.json ]; then
		echo "\"KH\":" | tee /dev/tty >> $OUT
		cat $OUTPUTS/KH.json >> $OUT;
	fi
	echo -n $SEP >> $OUT;
fi

if [[ "$TOOL" =~ EX ]] || [ "$TOOL" == "MAN" ]; then
	if [ -s $OUTPUTS/EX.json ]; then
		echo "\"EX\":" | tee /dev/tty >> $OUT
		cat $OUTPUTS/EX.json >> $OUT;
	fi
	echo -n $SEP >> $OUT;
fi

if [[ "$TOOL" =~ BP ]] || [ "$TOOL" == "MAN" ]; then
	S/BP |  tr -d "\r" | ./resultsParser.main.js -t BP -s $SOURCE > $OUTPUTS/BP.json || mv $OUTPUTS/BP.json $OUTPUTS/BP.error
	echo "\"BP\":" | tee /dev/tty >> $OUT
	fi
		cat $OUTPUTS/BP.json >> $OUT;
	else
		echo "[]" >> $OUT
	fi
	echo -n $SEP >> $OUT;
fi

if [[ "$TOOL" =~ BJ ]] || [ "$TOOL" == "MAN" ]; then
	if [ -s $OUTPUTS/BJ.json ]; then
		echo "\"BJ\":" | tee /dev/tty >> $OUT
		cat $OUTPUTS/BJ.json >> $OUT;
	fi
	echo -n $SEP >> $OUT;
fi

if [[ "$TOOL" =~ ST ]] || [ "$TOOL" == "POS" ]; then
	if [ -s $OUTPUTS/ST.json ]; then
		echo "\"ST\":" | tee /dev/tty >> $OUT
		cat $OUTPUTS/ST.json >> $OUT;
	fi
	echo -n $SEP >> $OUT;
fi

if [[ "$TOOL" =~ AM ]] || [ "$TOOL" == "POS" ]; then
	if [ -s $OUTPUTS/AM.json ]; then
		echo "\"AM\":" | tee /dev/tty >> $OUT
		cat $OUTPUTS/AM.json >> $OUT;
	fi
	echo -n $SEP >> $OUT;
fi

if [[ "$TOOL" =~ FA ]] || [ "$TOOL" == "POS" ]; then
	if [ -s $OUTPUTS/FA.json ]; then
		echo "\"FA\":" | tee /dev/tty >> $OUT
		cat $OUTPUTS/FA.json >> $OUT;
	fi
	echo -n $SEP >> $OUT;
fi

if [[ "$TOOL" =~ MS ]] || [ "$TOOL" == "MAN" ]; then
	if [ -s $OUTPUTS/MS.json ]; then
		echo "\"MS\":" | tee /dev/tty >> $OUT
		cat $OUTPUTS/MS.json >> $OUT;
	fi
	echo -n $SEP >> $OUT;
fi

if [[ "$TOOL" =~ MT ]] || [ "$TOOL" == "MAN" ]; then
	if [ -s $OUTPUTS/MT.json ]; then
		echo "\"MT\":" | tee /dev/tty >> $OUT
		cat $OUTPUTS/MT.json >> $OUT;
	fi
	echo -n $SEP >> $OUT;
fi

if [[ "$TOOL" =~ QT ]] || [ "$TOOL" == "MAN" ]; then
	if [ -s $OUTPUTS/QT.json ]; then
		echo "\"QT\":" | tee /dev/tty >> $OUT
		cat $OUTPUTS/QT.json >> $OUT;
	fi
	echo -n $SEP >> $OUT;
fi

if [[ "$TOOL" =~ SW ]] || [ "$TOOL" == "POS" ]; then
	if [ -s $OUTPUTS/SW.json ]; then
		echo "\"SW\":" | tee /dev/tty >> $OUT
		cat $OUTPUTS/SW.json >> $OUT;
	fi
	echo -n $SEP >> $OUT;
fi

if [[ "$TOOL" =~ MR ]] || [ "$TOOL" == "POS" ]; then
	if [ -s $OUTPUTS/MR.json ]; then
		echo "\"MR\":" | tee /dev/tty >> $OUT
		cat $OUTPUTS/MR.json >> $OUT;
	fi
	echo -n $SEP >> $OUT;
fi

if [[ "$TOOL" =~ WP ]] || [ "$TOOL" == "POS" ]; then
	if [ -s $OUTPUTS/WP.json ]; then
		echo "\"WP\":" | tee /dev/tty >> $OUT
		cat $OUTPUTS/WP.json >> $OUT;
	fi
	echo -n $SEP >> $OUT;
fi

# if [ -s $OUTPUTS/QA ] || [ -s $OUTPUTS/QA.json ]; then
if [[ "$TOOL" =~ QA ]] || [ "$TOOL" == "POS" ]; then
	if [ -s $OUTPUTS/QA.json ]; then
		echo "\"QA\":" | tee /dev/tty >> $OUT
		cat $OUTPUTS/QA.json >> $OUT;
	fi
	echo -n $SEP >> $OUT;

	# ( cat $OUTPUTS/QA.json ) ||  ( cat $OUTPUTS/QA | tr -d "\r" | ./resultsParser.main.js -t QAC -s $SOURCE | tee $OUTPUTS/QA.json ) || ( echo "[]" && mv $OUTPUTS/QA.json $OUTPUTS/QA.error )
	# cat $OUTPUTS/QA.json  || ( echo "[]" && mv $OUTPUTS/QA.json $OUTPUTS/QA.error )
fi

echo "\"Words\":" | tee /dev/tty >> $OUT
(for x in $OUTPUTS/*.json; do FILE=`basename $x | sed s/.json//`; cat $x | jq ' .[]  | .wutf8 ' | jq -s  "{$FILE:.}"; done ) | jq -s add >> $OUT

echo "}" >> $OUT

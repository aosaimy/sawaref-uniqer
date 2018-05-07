#!/bin/bash
# set -o pipefail

source config.bash
#false is when empty
REDO=

##
## This file run parser on all raw output based on thier names and return one JSON file to standard output
## params: - output folder of the raw files - input file
##
if [ -z "$2" ]; then
	echo "usage: ./searchInAll.bash outputsFolder sourceFile";
	exit 2;
fi

if [ -z "$1" ]; then
	echo "usage: ./searchInAll.bash outputsFolder sourceFile";
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
if [ -s $OUTPUTS/AR ]; then
	echo "\"AR\":" | tee /dev/tty >> $OUT
	if [ $REDO ] || [ ! -s $OUTPUTS/AR.json ]; then
		cat $OUTPUTS/AR | ./resultsParser.main.js -t AR -s $SOURCE > $OUTPUTS/AR.json || mv $OUTPUTS/AR.json $OUTPUTS/AR.error
	fi

	if [ -s $OUTPUTS/AR.json ]; then
		cat $OUTPUTS/AR.json >> $OUT;
	else
		echo "[]" >> $OUT
	fi
	echo -n $SEP >> $OUT;
fi
fi

if [[ "$TOOL" =~ MD ]] || [ "$TOOL" == "POS" ]; then
if [ -s $OUTPUTS/MD ]; then
	echo "\"MD\":" | tee /dev/tty >> $OUT
	if [ $REDO ] || [ ! -s $OUTPUTS/MD.json ]; then
		cat $OUTPUTS/MD | sed '/^_/ d' | sed '/^\^/ d' | ./resultsParser.main.js -t MD -s $SOURCE > $OUTPUTS/MD.json || mv $OUTPUTS/MD.json $OUTPUTS/MD.error
	fi

	if [ -s $OUTPUTS/MD.json ]; then
		cat $OUTPUTS/MD.json >> $OUT;
	else
		echo "[]" >> $OUT
	fi

	echo -n $SEP >> $OUT;
fi
fi

if [[ "$TOOL" == "MA" ]] || [ "$TOOL" == "POS" ]; then
if [ -s $OUTPUTS/MA ]; then
	echo "\"MA\":" | tee /dev/tty >> $OUT
	if [ $REDO ] || [ ! -s $OUTPUTS/MA.json ]; then
		cat $OUTPUTS/MA | sed '/^_/ d' | ./resultsParser.main.js -t MA -s $SOURCE > $OUTPUTS/MA.json || mv $OUTPUTS/MA.json $OUTPUTS/MA.error
	fi

	if [ -s $OUTPUTS/MA.json ]; then
		cat $OUTPUTS/MA.json >> $OUT;
	else
		echo "[]" >> $OUT
	fi


	echo -n $SEP >> $OUT;
fi
fi

if [[ "$TOOL" =~ MX ]] || [ "$TOOL" == "POS" ]; then
if [ -s $OUTPUTS/MX ]; then
	echo "\"MX\":" | tee /dev/tty >> $OUT
	if [ $REDO ] || [ ! -s $OUTPUTS/MX.json ]; then
		cat $OUTPUTS/MX | xml2json | jq 'if (.madamira_output.out_doc.out_seg.word_info.word | type) == "object" then [.madamira_output.out_doc.out_seg.word_info.word] else .madamira_output.out_doc.out_seg.word_info.word end' | ./resultsParser.main.js -t MX -s $SOURCE > $OUTPUTS/MX.json || mv $OUTPUTS/MX.json $OUTPUTS/MX.error
	fi

	if [ -s $OUTPUTS/MX.json ]; then
		cat $OUTPUTS/MX.json >> $OUT;
	else
		echo "[]" >> $OUT
	fi

	echo -n $SEP >> $OUT;
fi
fi

if [[ "$TOOL" =~ AL ]] || [ "$TOOL" == "MAN" ]; then
if [ -s $OUTPUTS/AL ]; then
	echo "\"AL\":" | tee /dev/tty >> $OUT
	if [ $REDO ] || [ ! -s $OUTPUTS/AL.json ]; then
		cat $OUTPUTS/AL | ./resultsParser.main.js -t AL -s $SOURCE > $OUTPUTS/AL.json || mv $OUTPUTS/AL.json $OUTPUTS/AL.error
	fi

	if [ -s $OUTPUTS/AL.json ]; then
		cat $OUTPUTS/AL.json >> $OUT;
	else
		echo "[]" >> $OUT
	fi


	echo -n $SEP >> $OUT;
fi

fi

if [[ "$TOOL" =~ XE ]] || [ "$TOOL" == "MAN" ]; then
if [ -s $OUTPUTS/XE ]; then
	echo "\"XE\":" | tee /dev/tty >> $OUT
	if [ $REDO ] || [ ! -s $OUTPUTS/XE.json ]; then
		cat $OUTPUTS/XE | ./resultsParser.main.js -t XE -s $SOURCE > $OUTPUTS/XE.json || mv $OUTPUTS/XE.json $OUTPUTS/XE.error
	fi

	if [ -s $OUTPUTS/XE.json ]; then
		cat $OUTPUTS/XE.json >> $OUT;
	else
		echo "[]" >> $OUT
	fi

	echo -n $SEP >> $OUT;
fi
fi

if [[ "$TOOL" =~ KH ]] || [ "$TOOL" == "MAN" ]; then
if [ -s $OUTPUTS/KH ]; then
	echo "\"KH\":" | tee /dev/tty >> $OUT
	if [ $REDO ] || [ ! -s $OUTPUTS/KH.json ]; then
		cat $OUTPUTS/KH | ./resultsParser.main.js -t KH -s $SOURCE > $OUTPUTS/KH.json || mv $OUTPUTS/KH.json $OUTPUTS/KH.error
	fi

	if [ -s $OUTPUTS/KH.json ]; then
		cat $OUTPUTS/KH.json >> $OUT;
	else
		echo "[]" >> $OUT
	fi

	echo -n $SEP >> $OUT;
fi
fi

if [[ "$TOOL" =~ EX ]] || [ "$TOOL" == "MAN" ]; then
if [ -s $OUTPUTS/EX ]; then
	echo "\"EX\":" | tee /dev/tty >> $OUT
	if [ $REDO ] || [ ! -s $OUTPUTS/EX.json ]; then
		cat $OUTPUTS/EX | ./resultsParser.main.js -t EX -s $SOURCE > $OUTPUTS/EX.json || mv $OUTPUTS/EX.json $OUTPUTS/EX.error
	fi

	if [ -s $OUTPUTS/EX.json ]; then
		cat $OUTPUTS/EX.json >> $OUT;
	else
		echo "[]" >> $OUT
	fi

	echo -n $SEP >> $OUT;
fi
fi

if [[ "$TOOL" =~ BP ]] || [ "$TOOL" == "MAN" ]; then
if [ -s $OUTPUTS/BP ]; then
	echo "\"BP\":" | tee /dev/tty >> $OUT
	if [ $REDO ] || [ ! -s $OUTPUTS/BP.json ]; then
		# cat $OUTPUTS/BP | iconv -f WINDOWS-1256 -t utf-8 |  tr -d "\r" | ./resultsParser.main.js -t BP -s $SOURCE > $OUTPUTS/BP.json || mv $OUTPUTS/BP.json $OUTPUTS/BP.error
		cat $OUTPUTS/BP |  tr -d "\r" | ./resultsParser.main.js -t BP -s $SOURCE > $OUTPUTS/BP.json || mv $OUTPUTS/BP.json $OUTPUTS/BP.error
	fi

	if [ -s $OUTPUTS/BP.json ]; then
		cat $OUTPUTS/BP.json >> $OUT;
	else
		echo "[]" >> $OUT
	fi

	echo -n $SEP >> $OUT;
fi
fi

if [[ "$TOOL" =~ BJ ]] || [ "$TOOL" == "MAN" ]; then
if [ -s $OUTPUTS/BJ ]; then
	echo "\"BJ\":" | tee /dev/tty >> $OUT
	if [ $REDO ] || [ ! -s $OUTPUTS/BJ.json ]; then
		cat $OUTPUTS/BJ | sed 's/\t/\\t/g' | ./resultsParser.main.js -t BJ -s $SOURCE > $OUTPUTS/BJ.json || mv $OUTPUTS/BJ.json $OUTPUTS/BJ.error
	fi

	if [ -s $OUTPUTS/BJ.json ]; then
		cat $OUTPUTS/BJ.json >> $OUT;
	else
		echo "[]" >> $OUT
	fi

	echo -n $SEP >> $OUT;
fi
fi

if [[ "$TOOL" =~ ST ]] || [ "$TOOL" == "POS" ]; then
if [ -s $OUTPUTS/ST ]; then
	echo "\"ST\":" | tee /dev/tty >> $OUT
	if [ $REDO ] || [ ! -s $OUTPUTS/ST.json ]; then
		cat $OUTPUTS/ST | ./resultsParser.main.js -t ST -s $SOURCE > $OUTPUTS/ST.json || mv $OUTPUTS/ST.json $OUTPUTS/ST.error
	fi

	if [ -s $OUTPUTS/ST.json ]; then
		cat $OUTPUTS/ST.json >> $OUT;
	else
		echo "[]" >> $OUT
	fi

	echo -n $SEP >> $OUT;
fi
fi

if [[ "$TOOL" =~ AM ]] || [ "$TOOL" == "POS" ]; then
if [ -s $OUTPUTS/AM ]; then
	echo "\"AM\":" | tee /dev/tty >> $OUT
	if [ $REDO ] || [ ! -s $OUTPUTS/AM.json ]; then
		cat $OUTPUTS/AM | ./resultsParser.main.js -t AM -s $SOURCE > $OUTPUTS/AM.json || mv $OUTPUTS/AM.json $OUTPUTS/AM.error
	fi

	if [ -s $OUTPUTS/AM.json ]; then
		cat $OUTPUTS/AM.json >> $OUT;
	else
		echo "[]" >> $OUT
	fi
	echo -n $SEP >> $OUT;
fi
fi

if [[ "$TOOL" =~ FA ]] || [ "$TOOL" == "POS" ]; then
if [ -s $OUTPUTS/FA ]; then
	echo "\"FA\":" | tee /dev/tty >> $OUT
	if [ $REDO ] || [ ! -s $OUTPUTS/FA.json ]; then
		cat $OUTPUTS/FA | ./resultsParser.main.js -t FA -s $SOURCE > $OUTPUTS/FA.json || mv $OUTPUTS/FA.json $OUTPUTS/FA.error
	fi

	if [ -s $OUTPUTS/FA.json ]; then
		cat $OUTPUTS/FA.json >> $OUT;
	else
		echo "[]" >> $OUT
	fi
	echo -n $SEP >> $OUT;
fi
fi

if [[ "$TOOL" =~ MS ]] || [ "$TOOL" == "MAN" ]; then
if [ -s $OUTPUTS/MS ]; then
	echo "\"MS\":" | tee /dev/tty >> $OUT
	if [ $REDO ] || [ ! -s $OUTPUTS/MS.json ]; then
		cat $OUTPUTS/MS | ./resultsParser.main.js -t MS -s $SOURCE > $OUTPUTS/MS.json || mv $OUTPUTS/MS.json $OUTPUTS/MS.error
	fi

	if [ -s $OUTPUTS/MS.json ]; then
		cat $OUTPUTS/MS.json >> $OUT;
	else
		echo "[]" >> $OUT
	fi
	echo -n $SEP >> $OUT;
fi
fi

if [[ "$TOOL" =~ MT ]] || [ "$TOOL" == "MAN" ]; then
if [ -s $OUTPUTS/MS ]; then
	echo "\"MT\":" | tee /dev/tty >> $OUT
	if [ $REDO ] || [ ! -s $OUTPUTS/MS.json ]; then
		cat $OUTPUTS/MS | ./resultsParser.main.js -t MT -s $SOURCE > $OUTPUTS/MT.json || mv $OUTPUTS/MT.json $OUTPUTS/MT.error
	fi

	if [ -s $OUTPUTS/MT.json ]; then
		cat $OUTPUTS/MT.json >> $OUT;
	else
		echo "[]" >> $OUT
	fi
	echo -n $SEP >> $OUT;
fi
fi

if [[ "$TOOL" =~ QT ]] || [ "$TOOL" == "MAN" ]; then
if [ -s $OUTPUTS/QT ]; then
	echo "\"QT\":" | tee /dev/tty >> $OUT
	if [ $REDO ] || [ ! -s $OUTPUTS/QT.json ]; then
		cat $OUTPUTS/QT | xml-json Word | ./resultsParser.main.js -t QT -s $SOURCE > $OUTPUTS/QT.json || mv $OUTPUTS/QT.json $OUTPUTS/QT.error
	fi

	if [ -s $OUTPUTS/QT.json ]; then
		cat $OUTPUTS/QT.json >> $OUT;
	else
		echo "[]" >> $OUT
	fi
	echo -n $SEP >> $OUT;
fi
fi

if [[ "$TOOL" =~ SW ]] || [ "$TOOL" == "POS" ]; then
if [ -s $OUTPUTS/SW ]; then
	echo "\"SW\":" | tee /dev/tty >> $OUT
	if [ $REDO ] || [ ! -s $OUTPUTS/SW.json ]; then
		cat $OUTPUTS/SW | ./resultsParser.main.js -t SW -s $SOURCE > $OUTPUTS/SW.json || mv $OUTPUTS/SW.json $OUTPUTS/SW.error
	fi

	if [ -s $OUTPUTS/SW.json ]; then
		cat $OUTPUTS/SW.json >> $OUT;
	else
		echo "[]" >> $OUT
	fi
	echo -n $SEP >> $OUT;
fi
fi

if [[ "$TOOL" =~ MR ]] || [ "$TOOL" == "POS" ]; then
if [ -s $OUTPUTS/MR ]; then
	echo "\"MR\":" | tee /dev/tty >> $OUT
	if [ $REDO ] || [ ! -s $OUTPUTS/MR.json ]; then
		cat $OUTPUTS/MR | ./resultsParser.main.js -t MR -s $SOURCE > $OUTPUTS/MR.json || mv $OUTPUTS/MR.json $OUTPUTS/MR.error
	fi

	if [ -s $OUTPUTS/MR.json ]; then
		cat $OUTPUTS/MR.json >> $OUT;
	else
		echo "[]" >> $OUT
	fi
	echo -n $SEP >> $OUT;
fi
fi

if [[ "$TOOL" =~ WP ]] || [ "$TOOL" == "POS" ]; then
if [ -s $OUTPUTS/WP ]; then
	echo "\"WP\":" | tee /dev/tty >> $OUT
	if [ $REDO ] || [ ! -s $OUTPUTS/WP.json ]; then
		cat $OUTPUTS/WP | ./resultsParser.main.js -t WP -s $SOURCE > $OUTPUTS/WP.json || mv $OUTPUTS/WP.json $OUTPUTS/WP.error
	fi

	if [ -s $OUTPUTS/WP.json ]; then
		cat $OUTPUTS/WP.json >> $OUT;
	else
		echo "[]" >> $OUT
	fi
	echo -n $SEP >> $OUT;
fi
fi

# if [ -s $OUTPUTS/QA ] || [ -s $OUTPUTS/QA.json ]; then
if [[ "$TOOL" =~ QA ]] || [ "$TOOL" == "POS" ]; then
if [ -s $OUTPUTS/QA ]; then
	echo "\"QA\":" | tee /dev/tty >> $OUT
	if [ $REDO ] || [ ! -s $OUTPUTS/QA.json ]; then
		cat $OUTPUTS/QA | tr -d "\r" | ./resultsParser.main.js -t QA -s $SOURCE > $OUTPUTS/QA.json
	fi

	if [ -s $OUTPUTS/QA.json ]; then
		cat $OUTPUTS/QA.json >> $OUT;
	else
		echo "[]" >> $OUT
	fi
	echo -n $SEP >> $OUT;

	# ( cat $OUTPUTS/QA.json ) ||  ( cat $OUTPUTS/QA | tr -d "\r" | ./resultsParser.main.js -t QAC -s $SOURCE | tee $OUTPUTS/QA.json ) || ( echo "[]" && mv $OUTPUTS/QA.json $OUTPUTS/QA.error )
	# cat $OUTPUTS/QA.json  || ( echo "[]" && mv $OUTPUTS/QA.json $OUTPUTS/QA.error )
fi
fi

# echo "\"Words\":" | tee /dev/tty >> $OUT
# (for x in $OUTPUTS/*.json; do FILE=`basename $x | sed s/.json//`; cat $x | jq ' .[]  | .wutf8 ' | jq -s  "{$FILE:.}"; done ) | jq -s add >> $OUT

echo "}" >> $OUT

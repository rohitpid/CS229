#!/bin/bash

#if [ $# == 0 ]
#then
#	show_help
#	exit $E_BADARGS
#fi
#while [[ $1 == -* ]]; do
#    case "$1" in
#      -h|--help|-\?) show_help; exit 0;;
#      -v|--verbose) verbose=1; shift;;
#      -i) if (($# > 1)); then
#            OUTPUTFILE=$2; shift 2
#          else
#            echo "-o requires an output tex file argument e.g. instructionsets.tex" 1>&2
#            exit $E_BADARGS
#          fi ;;
#      -l) if (($# > 1)); then
#           LATEXFILE=$2; shift 2
#          else
#            echo "-l requires a top level tex file argument e.g. documentation.tex" 1>&2
#            exit $E_BADARGS
#          fi ;;
#      -d) if (($# > 1)); then
#            OUTDIR=$2; shift 2
#          else
#            echo "-d requires a path to the directory containing all tex files e.g. ~/A2C/build/sw/docgen" 1>&2
#            exit $E_BADARGS
#          fi ;;
#      --) shift; break;;
#      -*) echo "invalid option: $1" 1>&2; show_help; exit $E_BADARGS;;
#    esac
#done

#function show_help
#{
#	echo "Usage: `basename $0` --id"
#	echo "example: `basename $0` instructionsets.tex documentation.tex ~/A2C/build/sw/docgen/"
#	exit $E_BADARGS
#}

ID="GOOG"
fromMonth=2
fromDay=16
fromYear=2010
toMonth=11
toDay=10
toYear=2012

echo "http://ichart.yahoo.com/table.csv?s=$ID&a=$fromMonth&b=$fromDay&c=$fromYear&d=$toMonth&e=$toDay&f=$toYear&g=d&ignore=.csv"
wget "http://ichart.yahoo.com/table.csv?s=$ID&a=$fromMonth&b=$fromDay&c=$fromYear&d=$toMonth&e=$toDay&f=$toYear&g=d&ignore=.csv" -O data.csv 

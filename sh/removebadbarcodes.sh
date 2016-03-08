#!/bin/bash
#removebadbarcodes in=<infile> out=<outfile>

usage(){
echo "
Written by Brian Bushnell.
Last modified March 16, 2015

Description:  Removes reads with improper barcodes.

Usage:  removebadbarcodes.sh in=<file> out=<file>

Parameters:
in=<file>           Input reads; required parameter.
out=<file>          Destination for good reads; optional.
ziplevel=2          (zl) Compression level for gzip output.
pigz=f              Spawn a pigz (parallel gzip) process for faster 
                    compression than Java.  Requires pigz to be installed.

Java Parameters:
-Xmx                This will be passed to Java to set memory usage, overriding the program's automatic memory detection.
                    -Xmx20g will specify 20 gigs of RAM, and -Xmx800m will specify 800 megs.  The max is typically 85% of physical memory.

Please contact Brian Bushnell at bbushnell@lbl.gov if you encounter any problems.
"
}

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/"
CP="$DIR""current/"
NATIVELIBDIR="$DIR""jni/"

z="-Xmx200m"
z2="-Xmx200m"
EA="-ea"
set=0

if [ -z "$1" ] || [[ $1 == -h ]] || [[ $1 == --help ]]; then
	usage
	exit
fi

calcXmx () {
	source "$DIR""/calcmem.sh"
	parseXmx "$@"
}
calcXmx "$@"


removebadbarcodes() {
	#module unload oracle-jdk
	#module load oracle-jdk/1.7_64bit
	#module load pigz
	local CMD="java $EA $z $z2 -cp $CP jgi.RemoveBadBarcodes $@"
	echo $CMD >&2
	eval $CMD
}

removebadbarcodes "$@"
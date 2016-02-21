#!/bin/bash

# compile a list of all files to check
OUT=$(find . -type f -and \( -name "*.php" \) -print0 | xargs -0  -I file gawk ' { match( $0, /echo (.*?\w)/, es); if ( length(es) > 0 ) { if ( !match(es[1], /gettext|[0-9]|\$|''</ ) ) { noni18n+=1; fail=fail es[0] } } } END{ if( noni18n > 0 ) { print FILENAME; }}' file)

# if the return code is 0 egrep found a match - this is bad
if [[ ! -z $OUT ]]
then
  echo "The following files have PHP echo without gettext (i18n translation):"
  echo $OUT
  echo -e "\033[41m\033[1;37m Failed \033[0m"
  exit 1
fi

# otherwise we output a bright green inverted "Passed"
echo -e "\033[42m\033[1;37m Passed \033[0m"
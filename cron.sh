#!/bin/bash

export LANG="en_US.UTF-8"

: ${db:=antennadb.zip}
: ${tf:=target.csv}
: ${tl:="webmon"}
: ${to:=`whoami`}
: ${fr:=`whoami`}

ulimit -Sv 128000
set -e

PATH=/bin:/usr/bin
cd `dirname $0`

diffhtml() {
  if [ -f "$postxsl" ]; then
    if ! wget -q -Oz$id.tmp "$url"
    then
      rc=$?
      logger -s -t antenna "wget $id rc=$rc"
      :
      return
    fi
    enc=`nkf -g z$id.tmp`
    : ${enc:=UTF-8}
    if ! xsltproc --stringparam base "$url" --encoding $enc --html $postxsl z$id.tmp > z$id.raw 2> z$id.log ; then
      rc=$?
      logger -s -t antenna "filter $postxsl exit $rc source $id - skip this time"
      cat z$id.log >&2
      return
    fi
    w3m -T text/html -dump z$id.raw > z$id.new
    test -s z$id.new || return
  else
    if ! w3m -no-cookie -dump "$url" > z$id.new
    then
      rc=$?
      logger -s -t antenna "w3m $id rc=$rc"
      :
      return
    fi
  fi
  if ! test -s z$id.new ; then
    logger -t antenna "empty source $id - skip this time"
    return
  fi
  if grep -q 'Request Timeout' z$id.new ; then
    logger -t antenna "timeout source $id - skip this time"
    return
  fi
  if unzip -q $db z$id 2> /dev/null
  then 
    if ! diff -u z$id z$id.new > ztmp
    then
      echo === $url ===
      sed -n 's/^+//p' ztmp
      printf '\f'
    fi
  fi
  mv -f z$id.new z$id
  zip -q $db z$id
}

target() {
  id="$2" mode="$3" url="$4"
  case $id in
  :*) return ;;
  esac
  postxsl=''
  case $mode in
  post-*.xsl) postxsl=$mode diffhtml ;;
  *) diffhtml ;;
  esac
}

dispatch() {
  test -f $tf
  rm -f z*
  sed 's/,/ /g' $tf | while read line
  do
    set $line
    target -t $* > zmail
    if [ -s zmail ]
    then
      cat > zmail.in <<HEADER
From: ${fr}
To: ${to}
Subject: ${tl} #${1}:
Content-Type: text/plain; charset=UTF-8

=== ${3} ===

HEADER
      cat zmail.in zmail | /usr/lib/sendmail -t
    fi
    rm -f zmail*
  done
  zip -q $db $tf $$
  rm -f z*
}

case $1 in
-t*) target $* ;;
*) dispatch ;;
esac

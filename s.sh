#!/usr/bin/bash

# npm install -g yaspeller
# Dependencies: wget, sed, sort, uniq, awk, grep, php

wget --spider -r $1 2>&1 | grep '^--' | awk '{ print $3 }' | sed "s/'+this.src+'//g" | grep -v '\.\(css\|js\|png\|gif\|jpg\|JPG\)$' > urls.txt
sort urls.txt | uniq > urls_u.txt 

rm -f report*

i=1
k=1
while read p; do
    yaspeller --report html $p
    echo -e '\n\n' >> report$k.html
    cat yaspeller_report.html >> report$k.html
    i=$(($i+1))
    if [ "$i" -gt 100 ]
    then
        i=1
        k=$(($k+1))
    fi
done <urls_u.txt

rm -f yaspeller_report.html

echo -e '<head>\n<title>Reports list</title>\n</head>\n<body>\n' > index.html
for (( c=1; c<=k; c++ ))
do
   echo -e "<a href='/report$c.html'>Report #$c</a><br/>\n" >> index.html
done
echo -e '</body>' >> index.html

php -S localhost:8000
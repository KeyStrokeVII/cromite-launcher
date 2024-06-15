#!/bin/bash

set -euo pipefail

MESSAGE=""
LICENSE=""

while read -r current_line; do
    if [[ $current_line =~ ^Filename:* ]]; then
        FILENAME=${current_line:9}

    elif [[ $current_line =~ ^Subject:* ]]; then
        SUBJECT=${current_line:8}

    elif [[ $current_line =~ ^Date:* ]]; then
        DATE=${current_line:5}

    elif [[ $current_line =~ ^License:* ]]; then
        LICENSE=$(echo "${current_line:9}" | cut -d ' ' -f1)

    elif [[ $current_line =~ ^"Original License:"* ]]; then
        continue

    elif [[ $current_line =~ ^From:* ]]; then
        FROM=$(echo "${current_line:5}" | cut -d ' ' -f1)

    elif [[ $current_line =~ ^---* ]]; then
        break

    elif [ -n "$current_line" ]; then
        if [ -n "$MESSAGE" ]; then
            MESSAGE+="<br>"
        fi
        MESSAGE+=$current_line

    fi
done

echo "|**$SUBJECT**" \
     "<br><sub><nobr>$DATE</nobr>" \
     "<br>File: [$FILENAME](/build/patches/$FILENAME)" \
     "<br><nobr>Author: $FROM</nobr>" \
     "<br><nobr>License: $LICENSE</nobr>" \
     "|$MESSAGE|"

#!/bin/sh
set -eu

SHARED_DIR="${SHARED_DIR:-/shared}"
FILES_DIR="$SHARED_DIR/files"
LOCK_FILE="$SHARED_DIR/.lock"

mkdir -p "$FILES_DIR"
touch "$LOCK_FILE"

CONTAINER_ID="$(od -An -N16 -tx1 /dev/urandom | tr -d ' \n')"

SEQ=0

create_file() {
    seq="$1"

    (
        flock -x 9

        i=1
        while :; do
            name=$(printf '%03d' "$i")
            path="$FILES_DIR/$name"

            if [ ! -e "$path" ]; then
                printf 'id=%s seq=%s\n' "$CONTAINER_ID" "$seq" > "$path"
                printf '%s\n' "$path"
                exit 0
            fi

            i=$((i + 1))
        done
    ) 9>"$LOCK_FILE"
}

while :; do
    SEQ=$((SEQ + 1))

    if path="$(create_file "$SEQ")"; then
        sleep 1
        rm -f -- "$path"
        sleep 1
    else
        SEQ=$((SEQ - 1))
        sleep 1
    fi
done
#!/bin/bash
#
#  Author: Mystic-Ivy
#
#

STORAGE_PATH="/tmp"

function wait_for_file () {
    local FILE="${STORAGE_PATH}/${IMAGE}"
    local SECONDS=5

    until [ $((SECONDS--)) -eq 0 ]; do
        sleep 1
        if [ -e "${STORAGE_PATH}/${IMAGE}" ]; then return 0; fi
    done

    test $SECONDS -ge 0 && return 1
}

function move_to_vm () {
    if [ -f "${STORAGE_PATH}/${IMAGE}" ]; then
        local VM=$(qvm-ls --raw-data --fields NAME,STATE --all --exclude dom0 | grep 'Running' | cut -d'|' -f1 | zenity --list --title 'Destination VM' --column 'VM Name' 2> /dev/null)
        if [ -n "${VM}" ]; then
            qvm-move-to-vm "${VM}" "${STORAGE_PATH}/${IMAGE}"
        fi
    else
        exit 1
    fi
}

flameshot gui -p "${STORAGE_PATH}" -r > /dev/null && IMAGE="$(date '+%Y-%m-%d_%H-%M').png"; wait_for_file && move_to_vm

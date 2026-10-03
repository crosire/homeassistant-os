#!/bin/sh

ROOT=/mnt/boot

case "$1" in
    get-primary)
        cat "$ROOT/rauc-slot.txt"
        ;;

    set-primary)
        rauc_slot_primary="$2"
        echo "$rauc_slot_primary" > "$ROOT/rauc-slot.txt"
        ;;

    get-state)
        rauc_slot="$2"
        cat "$ROOT/rauc-state-$rauc_slot.txt" 2>/dev/null || exit 1
        ;;

    set-state)
        rauc_slot="$2"
        rauc_state="$3"
        echo "$rauc_state" > "$ROOT/rauc-state-$rauc_slot.txt"
        ;;

    *)
        echo "Unknown operation: $1"
        exit 1
        ;;
esac

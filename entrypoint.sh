#!/bin/sh

CONVERTED_HASH_FILE=hash.22000

hcxpcapngtool /$PCAP_FILE -o $CONVERTED_HASH_FILE
hashcat -w 4 --status --status-timer 10 -m 22000 $CONVERTED_HASH_FILE /${DICT_FILE}

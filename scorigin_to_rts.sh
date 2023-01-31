#!/usr/bin/env bash

# Origin filtering
min_magnitude=2.0
min_phasecount=10

# HMB configuration
queue_name='_QUEUE_NAME_'
cfg_filename='_PATH_TO_CFGFILE_'
publish_path="_PAHT_TO_publish_hmb.py"

# DB connexion for the seiscomp db
dbstring='postgresql://USER:PASSWORD@localhost/seiscomp'

# SCXMLDUMP configuration
# -p: preferred
# -P: add picks
# -A: add amplitudes
# -M: add magnitides
# -F: add focal mechanisms
scxmldump_cmd='-p -P -A -M -F'

dump_event_qml() {
    local eventid="$1"
    scxmldump $scxmldump_cmd -f -E $eventid -d $dbstring
}

if [ $# -ne 5 ]; then
    echo "Error: no enough arguments!"
    exit 1
fi

message="$1"
flag="$2"
eventid="$3"
phasecount="$4"
magnitude="$5"
echo "* EVENT $eventid: magnitude $magnitude, phasecount $phasecount"

if [ $(echo "$magnitude < ${min_magnitude} || $phasecount < ${min_phasecount}" | bc -l) -eq 1 ]
then
    echo ' -> skip'
    exit 1
fi

dump_event_qml $eventid \
    | ${publish_path} -t ztxt -m eventid:$eventid \
        --queue ${queue_name} \
        --cfg ${cfg_filename} \
        --url http://cerf.emsc-csem.org/ExchangeEvent \
        -v

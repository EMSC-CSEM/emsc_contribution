# How to send event information using HMB?

## Data format
As a first step, we have to agree on the format used to send the event information: quakeml, sc3ml, scautoloc1, scautoloc3, gse2, isf1, isf2, ...

## Authentication
The EMSC must give you 3 information:
 1. your agency name (XXX)
 1. an user (YYY)
 2. a password (ZZZ) 
 3. and the HMB queue name dedicated to your institut (QQQ).

Although you can give the user/password to the script that send the data, we advise you to create a config file (e.g. institut.cfg) containing authentication information and to use it with that script (see use cases).

    agency = XXX
    user = YYY
    password = ZZZ

## Hmb setup
To easy the use of HMB, we provide a python library [*hmb_client*](https://github.com/EMSC-CSEM/hmb_client) as a wrapper around [HMB developped by GFZ](https://geofon.gfz-potsdam.de/software/httpmsgbus/). You have to clone the *hmb_client* repository. It uses python 3.6+ and needs the libraries *requests* and *pymongo* to be installed.

## Use case: send a file 
Here we describe how to send the event information via files. If we suppose that the current directory contains the hmb_client repository, the configuration file institut.cfg and the file containing the data to send MYFILE.txt. You can run:

    python3 hmb_client/publish_hmb.py MYFILE.txt -t file --url http://cerf.emsc-csem.org/ExchangeEvent --cfg institut.cfg --queue QQQ

## Use case: send seiscomp origins
In the case you would like to send seiscomp origins to hmb, we provide the script *scorigin_to_rts.sh* that should be executed by the scalert seiscomp plugin.

 1. Create the config file (see authentication)
 2. Setup parameters in *scorigin_to_rts.sh*
    - min_magnitude, min_phasecount
    - queue_name (QQQ)
    - path to the config file
    - path of the script *publish_hmb.py* (see HMB setup)
    - connexion to seiscomp db
 3. configure scalert to launch the script *scorigin_to_rts.sh*

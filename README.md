# ala-gbif-merge
Example of merging ALA and GBIF data for three separate species

# Requirements

* Linux
* Java-8+
* Maven-3
* Git

# Initial setup

* Run ``./initial-setup.sh`` to download and setup the programs that are used

# Acacia longifolia

Download the following source files from Dropbox:

From: https://www.dropbox.com/sh/f7bi1rl6pfxv8jj/AAAkDmCvRThZvVcv7kNDtkbHa?dl=0

## GBIF
* Download ``Acacia longifolia GBIF data.xlsx``, and open it in Excel or LibreOffice. Export it as a CSV file into ``Source-Files/Acacia longifolia filtered and sorted/Acacia longifolia GBIF data.csv``

## ALA
* Download ``Acacia longifolia ALA data sorted.xlsx``, and open it in Excel or LibreOffice. Export it as a CSV file into ``Source-Files/Acacia longifolia filtered and sorted/Acacia longifolia ALA data sorted.csv``

Run ``./reprocess-acacia-longifolia.sh`` to perform the analysis again

# Ardea ibis

Download the following source files from Dropbox:

From: https://www.dropbox.com/sh/f7bi1rl6pfxv8jj/AABNodLZyVDCvodgP_L-XUtRa/Ardea%20ibis?dl=0

## GBIF
* Download ``Bubulcus_ibis_global.csv`` into ``Source-Files/Bubulcus_ibis_global.csv``

## ALA
* Download ``records-2017-05-11.csv`` into ``Source-Files/Ardea ibis 2017-05-11/records-2017-05-11.csv``
* Download ``headings.csv`` into ``Source-Files/Ardea ibis 2017-05-11/headings.csv``

Run ``./reprocess-ardea-ibis.sh`` to perform the analysis again. Note that this script requires a fairly large amount of system memory currently.

# Vespula germanica

Download the following source files from Dropbox:

From: https://www.dropbox.com/sh/f7bi1rl6pfxv8jj/AAB6iO_HP_6v2KgjGkj6rETia/Vespula%20germanica?dl=0

## GBIF
* Download ``Vespula_germanica_global.csv`` into ``Source-Files/Vespula_germanica_global.csv``

## ALA
* Download ``Vespula germanica 2017-05-12.csv`` into ``Source-Files/Vespula germanica 2017-05-12/Vespula germanica 2017-05-12.csv``
* Download ``headings.csv`` into ``Source-Files/Vespula germanica 2017-05-12/headings.csv``

Run ``./reprocess-ardea-ibis.sh`` to perform the analysis again.

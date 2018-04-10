#!/bin/bash

set -e
set -x

#INPUT_FOLDER="/media/sf_HostDesktop/LeeBelbin_ALAGBIFMerge/FromLee/"
INPUT_FOLDER="./Source-Files/"
OUTPUT_FOLDER="./"
mkdir -p "${OUTPUT_FOLDER}"
CSVSUM_PATH="../csvsum/"
DWCA_UTILS_PATH="../dwca-utils/"

# Stage 1: Ardea ibis from ALA
ARDEA_ALA_OUTPUT_FOLDER="${OUTPUT_FOLDER}Mapped-ArdeaIbis-ALA/"
rm -r "${ARDEA_ALA_OUTPUT_FOLDER}"
mkdir -p "${ARDEA_ALA_OUTPUT_FOLDER}"

ARDEA_ALA_CORE_ID_INDEX="26"

cp "${INPUT_FOLDER}Ardea ibis 2017-05-11/records-2017-05-11.csv" "${ARDEA_ALA_OUTPUT_FOLDER}Source-ArdeaIbis-ALA.csv"
cp "${INPUT_FOLDER}Ardea ibis 2017-05-11/headings.csv" "${ARDEA_ALA_OUTPUT_FOLDER}Source-ArdeaIbis-ALA-headings.csv"

${CSVSUM_PATH}csvsum --input "${ARDEA_ALA_OUTPUT_FOLDER}Source-ArdeaIbis-ALA.csv" --output "Statistics-ArdeaIbis-ALA.csv" --show-sample-counts true --samples 1000

${DWCA_UTILS_PATH}csv2dwca --input "${ARDEA_ALA_OUTPUT_FOLDER}Source-ArdeaIbis-ALA.csv" --output "${ARDEA_ALA_OUTPUT_FOLDER}meta.xml" --core-id-index "${ARDEA_ALA_CORE_ID_INDEX}" --header-line-count 1 --show-defaults true --ala-headers-file "${ARDEA_ALA_OUTPUT_FOLDER}Source-ArdeaIbis-ALA-headings.csv"

zip -rqj "${OUTPUT_FOLDER}Mapped-ArdeaIbis-ALA-Archive.zip" "${ARDEA_ALA_OUTPUT_FOLDER}"*

mkdir -p "./dwcacheck-ArdeaIbis-ALA-analysis/"
${DWCA_UTILS_PATH}dwcacheck --input "${OUTPUT_FOLDER}Mapped-ArdeaIbis-ALA-Archive.zip" --output "./dwcacheck-ArdeaIbis-ALA-analysis/"

# Stage 2: Ardea ibis from GBIF
ARDEA_GBIF_OUTPUT_FOLDER="${OUTPUT_FOLDER}Mapped-ArdeaIbis-GBIF/"
rm -r "${ARDEA_GBIF_OUTPUT_FOLDER}"
mkdir -p "${ARDEA_GBIF_OUTPUT_FOLDER}"

ARDEA_GBIF_CORE_ID_INDEX="290"

cp "${INPUT_FOLDER}Bubulcus_ibis_global.csv" "${ARDEA_GBIF_OUTPUT_FOLDER}Source-ArdeaIbis-GBIF.csv"

# Remove the GBIF known field prefix to reduce the size of the mapping field names
sed -i 's/occurrence_hdfs\.//g' "${ARDEA_GBIF_OUTPUT_FOLDER}Source-ArdeaIbis-GBIF.csv"

${CSVSUM_PATH}csvsum --input "${ARDEA_GBIF_OUTPUT_FOLDER}Source-ArdeaIbis-GBIF.csv" --output "Statistics-ArdeaIbis-GBIF.csv" --show-sample-counts true --samples 1000 --output-mapping "${ARDEA_GBIF_OUTPUT_FOLDER}Mapping-ArdeaIbis-GBIF.csv"

${CSVSUM_PATH}csvmap --input "${ARDEA_GBIF_OUTPUT_FOLDER}Source-ArdeaIbis-GBIF.csv" --output "${ARDEA_GBIF_OUTPUT_FOLDER}Mapped-ArdeaIbis-GBIF.csv" --mapping "Mapping-ArdeaIbis-GBIF.csv"

${CSVSUM_PATH}csvsum --input "${ARDEA_GBIF_OUTPUT_FOLDER}Mapped-ArdeaIbis-GBIF.csv" --output "Statistics-Mapped-ArdeaIbis-GBIF.csv" --show-sample-counts true --samples 1000

${DWCA_UTILS_PATH}csv2dwca --input "${ARDEA_GBIF_OUTPUT_FOLDER}Mapped-ArdeaIbis-GBIF.csv" --output "${ARDEA_GBIF_OUTPUT_FOLDER}meta.xml" --core-id-index "${ARDEA_GBIF_CORE_ID_INDEX}" --header-line-count 1 --show-defaults true --match-case-insensitive true

zip -rqj "${OUTPUT_FOLDER}Mapped-ArdeaIbis-GBIF-Archive.zip" "${ARDEA_GBIF_OUTPUT_FOLDER}"*

mkdir -p "./dwcacheck-ArdeaIbis-GBIF-analysis/"
${DWCA_UTILS_PATH}dwcacheck --input "${OUTPUT_FOLDER}Mapped-ArdeaIbis-GBIF-Archive.zip" --output "./dwcacheck-ArdeaIbis-GBIF-analysis/"

# Stage 3 : Merge the ALA and GBIF copies for ArdeaIbis
ARDEA_MERGED_OUTPUT_FOLDER="${OUTPUT_FOLDER}Mapped-ArdeaIbis-Merged/"
rm -r "${ARDEA_MERGED_OUTPUT_FOLDER}"
mkdir -p "${ARDEA_MERGED_OUTPUT_FOLDER}"

${DWCA_UTILS_PATH}dwcamerge --input "${OUTPUT_FOLDER}Mapped-ArdeaIbis-ALA-Archive.zip" --other-input "${OUTPUT_FOLDER}Mapped-ArdeaIbis-GBIF-Archive.zip" --output "${ARDEA_MERGED_OUTPUT_FOLDER}"

zip -rqj "${OUTPUT_FOLDER}Mapped-ArdeaIbis-Merged-Archive.zip" "${ARDEA_MERGED_OUTPUT_FOLDER}merged-archive/"*

mkdir -p "./dwcacheck-ArdeaIbis-Merged-analysis/"
${DWCA_UTILS_PATH}dwcacheck --input "${OUTPUT_FOLDER}Mapped-ArdeaIbis-Merged-Archive.zip" --output "./dwcacheck-ArdeaIbis-Merged-analysis/"

# Stage 4 : Merge the ALA and GBIF copies for Ardea ibis leaving out non-vocabulary terms
ARDEA_MERGED_CLEAN_OUTPUT_FOLDER="${OUTPUT_FOLDER}Mapped-ArdeaIbis-Merged-Clean/"
rm -r "${ARDEA_MERGED_CLEAN_OUTPUT_FOLDER}"
mkdir -p "${ARDEA_MERGED_CLEAN_OUTPUT_FOLDER}"

${DWCA_UTILS_PATH}dwcamerge --input "${OUTPUT_FOLDER}Mapped-ArdeaIbis-ALA-Archive.zip" --other-input "${OUTPUT_FOLDER}Mapped-ArdeaIbis-GBIF-Archive.zip" --output "${ARDEA_MERGED_CLEAN_OUTPUT_FOLDER}" --remove-non-vocabulary-terms true

zip -rqj "${OUTPUT_FOLDER}Mapped-ArdeaIbis-Merged-Clean-Archive.zip" "${ARDEA_MERGED_CLEAN_OUTPUT_FOLDER}merged-archive/"*

mkdir -p "./dwcacheck-ArdeaIbis-Merged-Clean-analysis/"
${DWCA_UTILS_PATH}dwcacheck --input "${OUTPUT_FOLDER}Mapped-ArdeaIbis-Merged-Clean-Archive.zip" --output "./dwcacheck-ArdeaIbis-Merged-Clean-analysis/"


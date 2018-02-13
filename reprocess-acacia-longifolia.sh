#!/bin/bash

set -e
set -x

#INPUT_FOLDER="/media/sf_HostDesktop/LeeBelbin_ALAGBIFMerge/FromLee/"
INPUT_FOLDER="./Source-Files/"
OUTPUT_FOLDER="./"
mkdir -p "${OUTPUT_FOLDER}"
CSVSUM_PATH="../csvsum/"
DWCA_UTILS_PATH="../dwca-utils/"

# Stage 1: Acacia longifolia from ALA
ACACIA_ALA_OUTPUT_FOLDER="${OUTPUT_FOLDER}Mapped-AcaciaLongifolia-ALA/"
rm -rf "${ACACIA_ALA_OUTPUT_FOLDER}"
mkdir -p "${ACACIA_ALA_OUTPUT_FOLDER}"

# catalogNumber is in column 12 (0-based index makes that 11) in the ALA Acacia longifolia data
# It isn't technically a primary key, but close enough
# If it worries anyway, easy enough to remove the missing and duplicate catalogNumber
ACACIA_ALA_CORE_ID_INDEX="11"

cp "${INPUT_FOLDER}Acacia longifolia filtered and sorted/Acacia longifolia ALA data sorted.csv" "${ACACIA_ALA_OUTPUT_FOLDER}Source-AcaciaLongifolia-ALA.csv"

${CSVSUM_PATH}csvsum --input "${ACACIA_ALA_OUTPUT_FOLDER}Source-AcaciaLongifolia-ALA.csv" --output "Statistics-AcaciaLongifolia-ALA.csv" --show-sample-counts true --samples 1000

${DWCA_UTILS_PATH}csv2dwca --input "${ACACIA_ALA_OUTPUT_FOLDER}Source-AcaciaLongifolia-ALA.csv" --output "${ACACIA_ALA_OUTPUT_FOLDER}meta.xml" --core-id-index "${ACACIA_ALA_CORE_ID_INDEX}" --header-line-count 1 --show-defaults true

zip -rqj "${OUTPUT_FOLDER}Mapped-AcaciaLongifolia-ALA-Archive.zip" "${ACACIA_ALA_OUTPUT_FOLDER}"*

mkdir -p "./dwcacheck-AcaciaLongifolia-ALA-analysis/"
${DWCA_UTILS_PATH}dwcacheck --input "${OUTPUT_FOLDER}Mapped-AcaciaLongifolia-ALA-Archive.zip" --output "./dwcacheck-AcaciaLongifolia-ALA-analysis/"

# Stage 2: Acacia longifolia from GBIF
ACACIA_GBIF_OUTPUT_FOLDER="${OUTPUT_FOLDER}Mapped-AcaciaLongifolia-GBIF/"
rm -rf "${ACACIA_GBIF_OUTPUT_FOLDER}"
mkdir -p "${ACACIA_GBIF_OUTPUT_FOLDER}"

# catalogNumber is in column 6 (0-based index makes that 5) in the GBIF Acacia longifolia data
# It isn't technically a primary key, but close enough
# If it worries anyway, easy enough to remove the missing and duplicate catalogNumber
ACACIA_GBIF_CORE_ID_INDEX="5"

cp "${INPUT_FOLDER}Acacia longifolia filtered and sorted/Acacia longifolia GBIF data.csv" "${ACACIA_GBIF_OUTPUT_FOLDER}Source-AcaciaLongifolia-GBIF.csv"

# Remove the GBIF known field prefix to reduce the size of the mapping field names
sed -i 's/occurrence_hdfs\.//g' "${ACACIA_GBIF_OUTPUT_FOLDER}Source-AcaciaLongifolia-GBIF.csv"

${CSVSUM_PATH}csvsum --input "${ACACIA_GBIF_OUTPUT_FOLDER}Source-AcaciaLongifolia-GBIF.csv" --output "Statistics-AcaciaLongifolia-GBIF.csv" --show-sample-counts true --samples 1000 --output-mapping "${ACACIA_GBIF_OUTPUT_FOLDER}Mapping-AcaciaLongifolia-GBIF.csv"

${CSVSUM_PATH}csvmap --input "${ACACIA_GBIF_OUTPUT_FOLDER}Source-AcaciaLongifolia-GBIF.csv" --output "${ACACIA_GBIF_OUTPUT_FOLDER}Mapped-AcaciaLongifolia-GBIF.csv" --mapping "Mapping-AcaciaLongifolia-GBIF.csv"

${CSVSUM_PATH}csvsum --input "${ACACIA_GBIF_OUTPUT_FOLDER}Mapped-AcaciaLongifolia-GBIF.csv" --output "Statistics-Mapped-AcaciaLongifolia-GBIF.csv" --show-sample-counts true --samples 1000

${DWCA_UTILS_PATH}csv2dwca --input "${ACACIA_GBIF_OUTPUT_FOLDER}Mapped-AcaciaLongifolia-GBIF.csv" --output "${ACACIA_GBIF_OUTPUT_FOLDER}meta.xml" --core-id-index "${ACACIA_GBIF_CORE_ID_INDEX}" --header-line-count 1 --show-defaults true --match-case-insensitive true

zip -rqj "${OUTPUT_FOLDER}Mapped-AcaciaLongifolia-GBIF-Archive.zip" "${ACACIA_GBIF_OUTPUT_FOLDER}"*

mkdir -p "./dwcacheck-AcaciaLongifolia-GBIF-analysis/"
${DWCA_UTILS_PATH}dwcacheck --input "${OUTPUT_FOLDER}Mapped-AcaciaLongifolia-GBIF-Archive.zip" --output "./dwcacheck-AcaciaLongifolia-GBIF-analysis/"

# Stage 3 : Merge the ALA and GBIF copies for AcaciaLongifolia
ACACIA_MERGED_OUTPUT_FOLDER="${OUTPUT_FOLDER}Mapped-AcaciaLongifolia-Merged/"
rm -rf "${ACACIA_MERGED_OUTPUT_FOLDER}"
mkdir -p "${ACACIA_MERGED_OUTPUT_FOLDER}"

${DWCA_UTILS_PATH}dwcamerge --input "${OUTPUT_FOLDER}Mapped-AcaciaLongifolia-ALA-Archive.zip" --other-input "${OUTPUT_FOLDER}Mapped-AcaciaLongifolia-GBIF-Archive.zip" --output "${ACACIA_MERGED_OUTPUT_FOLDER}"

zip -rqj "${OUTPUT_FOLDER}Mapped-AcaciaLongifolia-Merged-Archive.zip" "${ACACIA_MERGED_OUTPUT_FOLDER}merged-archive/"*

mkdir -p "./dwcacheck-AcaciaLongifolia-Merged-analysis/"
${DWCA_UTILS_PATH}dwcacheck --input "${OUTPUT_FOLDER}Mapped-AcaciaLongifolia-Merged-Archive.zip" --output "./dwcacheck-AcaciaLongifolia-Merged-analysis/"

# Stage 4 : Merge the ALA and GBIF copies for AcaciaLongifolia leaving out non-vocabulary terms
ACACIA_MERGED_CLEAN_OUTPUT_FOLDER="${OUTPUT_FOLDER}Mapped-AcaciaLongifolia-Merged-Clean/"
rm -rf "${ACACIA_MERGED_CLEAN_OUTPUT_FOLDER}"
mkdir -p "${ACACIA_MERGED_CLEAN_OUTPUT_FOLDER}"

${DWCA_UTILS_PATH}dwcamerge --input "${OUTPUT_FOLDER}Mapped-AcaciaLongifolia-ALA-Archive.zip" --other-input "${OUTPUT_FOLDER}Mapped-AcaciaLongifolia-GBIF-Archive.zip" --output "${ACACIA_MERGED_CLEAN_OUTPUT_FOLDER}" --remove-non-vocabulary-terms true

zip -rqj "${OUTPUT_FOLDER}Mapped-AcaciaLongifolia-Merged-Clean-Archive.zip" "${ACACIA_MERGED_CLEAN_OUTPUT_FOLDER}merged-archive/"*

mkdir -p "./dwcacheck-AcaciaLongifolia-Merged-Clean-analysis/"
${DWCA_UTILS_PATH}dwcacheck --input "${OUTPUT_FOLDER}Mapped-AcaciaLongifolia-Merged-Clean-Archive.zip" --output "./dwcacheck-AcaciaLongifolia-Merged-Clean-analysis/"


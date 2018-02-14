#!/bin/bash

set -e
set -x

#INPUT_FOLDER="/media/sf_HostDesktop/LeeBelbin_ALAGBIFMerge/FromLee/"
INPUT_FOLDER="./Source-Files/"
OUTPUT_FOLDER="./"
mkdir -p "${OUTPUT_FOLDER}"
CSVSUM_PATH="../csvsum/"
DWCA_UTILS_PATH="../dwca-utils/"

# Stage 1: Vespula germanica from ALA
VESPULA_ALA_OUTPUT_FOLDER="${OUTPUT_FOLDER}Mapped-VespulaGermanica-ALA/"
rm -rf "${VESPULA_ALA_OUTPUT_FOLDER}"
mkdir -p "${VESPULA_ALA_OUTPUT_FOLDER}"

VESPULA_ALA_CORE_ID_INDEX="26"

cp "${INPUT_FOLDER}Vespula germanica 2017-05-12/Vespula germanica 2017-05-12.csv" "${VESPULA_ALA_OUTPUT_FOLDER}Source-VespulaGermanica-ALA.csv"
cp "${INPUT_FOLDER}Vespula germanica 2017-05-12/headings.csv" "${VESPULA_ALA_OUTPUT_FOLDER}Source-VespulaGermanica-ALA-headings.csv"

${CSVSUM_PATH}csvsum --input "${VESPULA_ALA_OUTPUT_FOLDER}Source-VespulaGermanica-ALA.csv" --output "Statistics-VespulaGermanica-ALA.csv" --show-sample-counts true --samples 1000

${DWCA_UTILS_PATH}csv2dwca --input "${VESPULA_ALA_OUTPUT_FOLDER}Source-VespulaGermanica-ALA.csv" --output "${VESPULA_ALA_OUTPUT_FOLDER}meta.xml" --core-id-index "${VESPULA_ALA_CORE_ID_INDEX}" --header-line-count 1 --show-defaults true --ala-headers-file "${VESPULA_ALA_OUTPUT_FOLDER}Source-VespulaGermanica-ALA-headings.csv"

zip -rqj "${OUTPUT_FOLDER}Mapped-VespulaGermanica-ALA-Archive.zip" "${VESPULA_ALA_OUTPUT_FOLDER}"*

mkdir -p "./dwcacheck-VespulaGermanica-ALA-analysis/"
${DWCA_UTILS_PATH}dwcacheck --input "${OUTPUT_FOLDER}Mapped-VespulaGermanica-ALA-Archive.zip" --output "./dwcacheck-VespulaGermanica-ALA-analysis/"

# Stage 2: Vespula germanica from GBIF
VESPULA_GBIF_OUTPUT_FOLDER="${OUTPUT_FOLDER}Mapped-VespulaGermanica-GBIF/"
rm -rf "${VESPULA_GBIF_OUTPUT_FOLDER}"
mkdir -p "${VESPULA_GBIF_OUTPUT_FOLDER}"

VESPULA_GBIF_CORE_ID_INDEX="0"

cp "${INPUT_FOLDER}Vespula_germanica_global.csv" "${VESPULA_GBIF_OUTPUT_FOLDER}Source-VespulaGermanica-GBIF.csv"

# Remove the GBIF known field prefix to reduce the size of the mapping field names
sed -i 's/occurrence_hdfs\.//g' "${VESPULA_GBIF_OUTPUT_FOLDER}Source-VespulaGermanica-GBIF.csv"

${CSVSUM_PATH}csvsum --input "${VESPULA_GBIF_OUTPUT_FOLDER}Source-VespulaGermanica-GBIF.csv" --output "Statistics-VespulaGermanica-GBIF.csv" --show-sample-counts true --samples 1000 --output-mapping "${VESPULA_GBIF_OUTPUT_FOLDER}Mapping-VespulaGermanica-GBIF.csv"

${CSVSUM_PATH}csvmap --input "${VESPULA_GBIF_OUTPUT_FOLDER}Source-VespulaGermanica-GBIF.csv" --output "${VESPULA_GBIF_OUTPUT_FOLDER}Mapped-VespulaGermanica-GBIF.csv" --mapping "Mapping-VespulaGermanica-GBIF.csv"

${CSVSUM_PATH}csvsum --input "${VESPULA_GBIF_OUTPUT_FOLDER}Mapped-VespulaGermanica-GBIF.csv" --output "Statistics-Mapped-VespulaGermanica-GBIF.csv" --show-sample-counts true --samples 1000

${DWCA_UTILS_PATH}csv2dwca --input "${VESPULA_GBIF_OUTPUT_FOLDER}Mapped-VespulaGermanica-GBIF.csv" --output "${VESPULA_GBIF_OUTPUT_FOLDER}meta.xml" --core-id-index "${VESPULA_GBIF_CORE_ID_INDEX}" --header-line-count 1 --show-defaults true --match-case-insensitive true

zip -rqj "${OUTPUT_FOLDER}Mapped-VespulaGermanica-GBIF-Archive.zip" "${VESPULA_GBIF_OUTPUT_FOLDER}"*

mkdir -p "./dwcacheck-VespulaGermanica-GBIF-analysis/"
${DWCA_UTILS_PATH}dwcacheck --input "${OUTPUT_FOLDER}Mapped-VespulaGermanica-GBIF-Archive.zip" --output "./dwcacheck-VespulaGermanica-GBIF-analysis/"

# Stage 3 : Merge the ALA and GBIF copies for VespulaGermanica
VESPULA_MERGED_OUTPUT_FOLDER="${OUTPUT_FOLDER}Mapped-VespulaGermanica-Merged/"
rm -rf "${VESPULA_MERGED_OUTPUT_FOLDER}"
mkdir -p "${VESPULA_MERGED_OUTPUT_FOLDER}"

${DWCA_UTILS_PATH}dwcamerge --input "${OUTPUT_FOLDER}Mapped-VespulaGermanica-ALA-Archive.zip" --other-input "${OUTPUT_FOLDER}Mapped-VespulaGermanica-GBIF-Archive.zip" --output "${VESPULA_MERGED_OUTPUT_FOLDER}"

zip -rqj "${OUTPUT_FOLDER}Mapped-VespulaGermanica-Merged-Archive.zip" "${VESPULA_MERGED_OUTPUT_FOLDER}merged-archive/"*

mkdir -p "./dwcacheck-VespulaGermanica-Merged-analysis/"
${DWCA_UTILS_PATH}dwcacheck --input "${OUTPUT_FOLDER}Mapped-VespulaGermanica-Merged-Archive.zip" --output "./dwcacheck-VespulaGermanica-Merged-analysis/"

# Stage 4 : Merge the ALA and GBIF copies for Vespula germanica leaving out non-vocabulary terms
VESPULA_MERGED_CLEAN_OUTPUT_FOLDER="${OUTPUT_FOLDER}Mapped-VespulaGermanica-Merged-Clean/"
rm -rf "${VESPULA_MERGED_CLEAN_OUTPUT_FOLDER}"
mkdir -p "${VESPULA_MERGED_CLEAN_OUTPUT_FOLDER}"

${DWCA_UTILS_PATH}dwcamerge --input "${OUTPUT_FOLDER}Mapped-VespulaGermanica-ALA-Archive.zip" --other-input "${OUTPUT_FOLDER}Mapped-VespulaGermanica-GBIF-Archive.zip" --output "${VESPULA_MERGED_CLEAN_OUTPUT_FOLDER}" --remove-non-vocabulary-terms true

zip -rqj "${OUTPUT_FOLDER}Mapped-VespulaGermanica-Merged-Clean-Archive.zip" "${VESPULA_MERGED_CLEAN_OUTPUT_FOLDER}merged-archive/"*

mkdir -p "./dwcacheck-VespulaGermanica-Merged-Clean-analysis/"
${DWCA_UTILS_PATH}dwcacheck --input "${OUTPUT_FOLDER}Mapped-VespulaGermanica-Merged-Clean-Archive.zip" --output "./dwcacheck-VespulaGermanica-Merged-Clean-analysis/"


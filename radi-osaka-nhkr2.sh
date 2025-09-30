#!/usr/bin/bash
set -euo pipefail
set -u
#######################################
# Show usage
# Arguments:
#   None
# Returns:
#   None
#######################################
show_usage() {
  cat << _EOT_
Usage: $(basename "$0") [options]
Options:
  -d MINUTE       Record minute(s)
_EOT_
}

#######################################
# Format time text
# Arguments:
#   Time minute
# Returns:
#   None
#######################################
format_time() {
  minute=$1

  hour=$((minute / 60))
  minute=$((minute % 60))

  printf "%02d:%02d:%02d" "${hour}" "${minute}" "0"
}

duration=0
output=""

while getopts d:o option; do
  case "${option}" in
    d)
      duration="${OPTARG}"
      ;;
    o)
      output="${OPTARG}"
  esac
done
#
echo "${duration}" | grep -q -E "^[0-9]+$"
ret=$?
if [ ${ret} -ne 0 ]; then
  # -d value is invalid
  echo "Invalid \"Record minute\"" >&2
  exit 1
fi
#
file_ext="m4a"
if [ -z "${output}" ]; then
  output="oska-nhkr2_$(date +%Y%m%d%H%M%S).${file_ext}"
else
  # Fix file path extension
  echo "${output}" | grep -q -E "\\.${file_ext}$"
  ret=$?
  if [ ${ret} -ne 0 ]; then
    output="${output}.${file_ext}"
  fi
fi

ffmpeg -loglevel error \
       -fflags +discardcorrupt \
       -http_persistent 0 \
       -http_multiple 1 \
       -i "https://simul.drdi.st.nhk/live/4/joined/master.m3u8" \
       -acodec copy -vn -bsf:a aac_adtstoasc \
       -y \
       -t "$(format_time "${duration}")" \
       "${output}"

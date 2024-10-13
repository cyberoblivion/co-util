#!/bin/bash

# Default to the current directory
INPUT_DIR="$(pwd)"
OUTPUT_DIR="$(pwd)"

# Check if input directory is provided as the first argument
if [ ! -z "$1" ]; then
    INPUT_DIR="$1"
fi

# Check if output directory is provided as the second argument
if [ ! -z "$2" ]; then
    OUTPUT_DIR="$2"
fi


# Call the extract_audio.sh script; needs to be in path or current dir
extract-audio-mkv.sh "$INPUT_DIR" "$OUTPUT_DIR"

# Call the speech_to_text.sh script
convert-speech-to-text.sh "$OUTPUT_DIR" "$OUTPUT_DIR"

echo "Audio extraction and speech-to-text conversion complete."

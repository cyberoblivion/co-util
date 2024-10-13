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

# Create the output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Loop through all .mkv files in the input directory
for video in "$INPUT_DIR"/*.mkv; do
    # Extract the filename without extension
    filename=$(basename "$video" .mkv)
    
    # Define the output audio file name
    output_audio="$OUTPUT_DIR/${filename}.mp3"
    
    # Extract audio using ffmpeg
    ffmpeg -i "$video" -q:a 0 -map a "$output_audio"
done

echo "Audio extraction complete."


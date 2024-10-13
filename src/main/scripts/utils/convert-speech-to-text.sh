#!/bin/bash
#
#
# install openai whisper with pip
# sudo pip install openai-whisper
#
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

# Loop through all audio files in the input directory
for audio in "$INPUT_DIR"/*.{mp3,wav}; do
    # Extract the filename without extension
    filename=$(basename "$audio" | cut -d. -f1)
    
    # Define the output text file name
    output_text="$OUTPUT_DIR/${filename}.txt"
    
    # Convert speech to text using whisper
    whisper "$audio" --output_dir "$OUTPUT_DIR" --output_format txt
    
    # Rename the generated text file
    mv "$OUTPUT_DIR/${filename}.txt" "$output_text"
done

echo "Speech-to-text conversion complete."

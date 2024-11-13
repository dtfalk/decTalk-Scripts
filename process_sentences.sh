#!/bin/bash

# Define the path to the file 
# Make sure to download as a "tab separated values" (TSV) file.
# For some annoying reason, this code doesn't read the very last line of the file, so add a new line at the end of the file with random gibberish
input_file="shannonSentences/harvardNew.tsv"

# name of the folder where you will save the files to
output_folder_name="testResults"

# Variable for skipping the first line if it's the header
header_skipped=false

# Read the file line by line
# set the "...column" variables in the "while ..." line to the names of the columns.
# Then replace those variables within the "while" loop
# The files I have been given thus far have had a structure where column one is the group number/name,
# the second column is the sentence number within the group, and the third column is the sentence we want
# to create. I have been making folders for each group and then using the the sentence number as the file
# name. If the strucutre differs (e.g. just a list of sentences, then you can get rid of the column
# variables except for the sentences and change the "output_dir" variable to just the name of each file. 
# E.G. "output_dir = results/outputFolderName/filename.wav
while IFS=$'\t' read -r irrelevant group name oldSentence sentence; do
    
    # This skips the TSV header. Comment this out (using "#" at the beginning of each line) if no headers
    if [ "$header_skipped" = false ]; then
        header_skipped=true
        continue
    fi    
    
    # Create a folder with the group number as the folder name if it doesn't exist
    output_dir="$output_folder_name/$group"
    mkdir -p "$output_dir"

    # Defines the location and name of the file that will be saved
    output_file="$output_dir/$name.wav"

    # Runs the sentence generating code (using "./say ...") and stores the output to the "output_file"
    if ./say -a "$sentence" -fo "$output_file"; then
        printf "Sentence: %s\nSaved as: %s\n\n" "$sentence" "$output_file"
    # If there is an error, then print the sentence that failed to print
    else
 	echo -e "Failed to process sentence: $sentence"
    fi

done < "$input_file"

#!/bin/bash

# Define the path to the file 
# Make sure to download as a "tab separated values" (TSV) file.
input_file="sentenceFiles/nameOfYourTSVFileHere.tsv"

# name of the folder where you will save the files to
output_folder_name="outputFolderNameHere"

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
# E.G. "output_dir = results/outputFolderName/filename.wav"
while IFS=$'\t' read -r firstColumn secondColumn thirdColumn; do
    
    # This skips the TSV header. Comment this out (using "#" at the beginning of each line) if no headers
    if [ "$header_skipped" = false ]; then
        header_skipped=true
        continue
    fi    

    # Create a folder with the group number as the folder name if it doesn't exist
    output_dir="$output_folder_name/$firstColumn"
    mkdir -p "$output_dir"

    # Defines the location and name of the file that will be saved
    output_file="$output_dir/$secondColumn.wav"

    # Runs the sentence generating code (using "./say ...") and stores the output to the "output_file"
    if ./say -a "$thirdColumn" -fo "$output_file"; then
        printf "Sentence: %s\nSaved as: %s\n\n" "$thirdColumn" "$output_file"
    # if there is an error, then print the sentence that failed to print
    else
 	echo "Failed to process sentence: '$thirdColumn'"
    fi

done < "$input_file"

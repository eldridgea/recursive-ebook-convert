#!/bin/bash
#
# This will take a parent directory as an input argument and then convert all the .mobi and .azw3 files to .epub.
# This expects one directory per book, as it checks to see if an .epub already exists in each directory and skips the ones
# where an .epub file is present.
#
# NOTE: This leverages the `docker run` command so you'll need Docker Desktop, Docker Engine or something like that
# installed.
#
# This uses the `linuxserver/calibre` container image of Calibre (calibre-ebook.com). Soi you should get the same results
# as if you'd converted using the Calibre desktop app.


# Require a starting directory as an argument

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <starting_directory>"
  exit 1
fi

# Store the starting directory
starting_directory=${@%/} # Removes any trailing slashes from input to avoid issues.

# Function to recursively process directories
function process_directory {
  for filename in "$1"/*; do
    if [[ -f "$filename" ]]; then
      # Check for .mobi or azw3 extension
      if [[ ( "$filename" == *.mobi ) || ( "$filename" == *.azw3 )  ]]; then
	src=`basename "$filename"`
	dst="${src%.*}".epub
	message="Converting to epub"
        echo -e "\t\x1B[32m $message \x1B[0m"
	docker run -v "$1":"/convert" --entrypoint ebook-convert linuxserver/calibre /convert/"$src" /convert/"$dst" > /dev/null 2>&1
	message="Conversion complete"
        echo -e "\t\x1B[32m $message \x1B[0m"
      fi
    elif [[ -d "$filename" ]]; then
      # Recursively process subdirectories
      echo "Processing $filename"
      if [[ $(find "$filename" -iname '*.epub' -print -quit) ]]; then
	message=".epub already exists, skipping"
	echo -e "\t\x1B[33m $message \x1B[0m"
      else
        process_directory "$filename"
      fi
    fi
  done
}

# Start processing from the specified starting directory
process_directory "$starting_directory"

#!/bin/bash

# Function to check if a PDF contains text and optionally perform OCR
check_pdf() {
  local file=$1
  local print_only_ocr=$2
  local output_path=$3
  local ocr_languages=$4

  # Check if the file is a valid PDF
  if ! pdfinfo "$file" >/dev/null 2>&1; then
    echo -e "\033[33m$file is not a valid PDF or is corrupted\033[0m"
    return
  fi

  # Check if the PDF is empty
  if [ "$(pdfinfo "$file" 2>/dev/null | awk '/Pages:/ {print $2}')" -eq 0 ]; then
    echo -e "\033[33m$file is an empty PDF\033[0m"
    return
  fi

  # Run pdffonts and check if it outputs any fonts
  if pdffonts "$file" 2>/dev/null | awk 'NR>2 {exit 1}'; then
    # PDF needs OCR
      echo -e "\033[31m$file needs OCR\033[0m"

    # Perform OCR if output_path is set
    if [ -n "$output_path" ]; then
      echo "Starting OCR for $file"
      local output_file="$output_path/$(basename "$file")"
      ocrmypdf -l "$ocr_languages" "$file" "$output_file"
      if [ $? -eq 0 ]; then
        echo -e "\033[34mOCR performed on $file, saved to $output_file\033[0m"
      else
        echo -e "\033[31mOCR failed for $file\033[0m"
      fi
    fi
  else
    # PDF contains text
    if [ "$print_only_ocr" = false ]; then
      echo -e "\033[32m$file contains text\033[0m"
    fi
  fi
}

# Function to recursively find and check all PDFs in a directory
scan_directory() {
  local dir=$1
  local print_only_ocr=$2
  local output_path=$3
  local ocr_languages=$4

  # Debug output to confirm directory scan
  echo "Scanning directory: $dir"

  # Find all PDF files in the directory recursively
  find "$dir" -type f -name "*.pdf" | while read -r pdf; do
    check_pdf "$pdf" "$print_only_ocr" "$output_path" "$ocr_languages"
  done
}

# Parse arguments
output_path=""
print_only_ocr=false
ocr_languages="eng"
dir=""

for arg in "$@"; do
  case $arg in
    --output-path=*)
      output_path="${arg#*=}"
      shift
      ;;
    --language=*)
      ocr_languages="${arg#*=}"
      shift
      ;;
    true|false)
      print_only_ocr=$arg
      shift
      ;;
    *)
      dir=$arg
      ;;
  esac
done

# Check if directory argument was provided
if [ -z "$dir" ]; then
  echo "Usage: $0 <directory> [true|false] [--output-path=<output_directory>] [--language=<ocr_languages>]"
  echo "Example: $0 /path/to/directory true --output-path=/path/to/output --language=eng+fra"
  exit 1
fi

# Create output directory if it does not exist and output_path is set
if [ -n "$output_path" ] && [ ! -d "$output_path" ]; then
  mkdir -p "$output_path"
fi

# Scan the provided directory
scan_directory "$dir" "$print_only_ocr" "$output_path" "$ocr_languages"

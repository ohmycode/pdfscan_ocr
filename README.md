# PDF Scanner and OCR Script

This bash script recursively scans all PDFs in a given folder, checks if they contain text, and optionally performs OCR on those that doesn't. It uses `pdffonts` to determine if a PDF contains text and `ocrmypdf` to perform the OCR. `ocrmypdf` uses [tesseract](https://github.com/tesseract-ocr/tesseract) which supports more than 100 languages.

![image](demo.gif)

## Prerequisites

Ensure you have the necessary tools installed:

-   [Poppler](https://poppler.freedesktop.org/) (for `pdffonts`)
-   [OCRmyPDF](https://github.com/ocrmypdf/OCRmyPDF) (for performing OCR)

For languages other than english, you need to install those first, check out the [OCRmyPDF documentation](https://github.com/ocrmypdf/OCRmyPDF?tab=readme-ov-file#languages) for more info.

On a mac, you can install Poppler and OCRmyPDF using Homebrew:

```sh
brew install poppler
brew install ocrmypdf
```

If you are on Linux you can find installation notes on their respective websites:

-   [poppler](https://poppler.freedesktop.org)
-   [OCRmyPDF](https://ocrmypdf.readthedocs.io/en/latest/installation.html)

## Usage

```sh
./pdfscan_ocr.sh <directory> [true|false] [--output-path=<output_directory>] [--language=<ocr_languages>]
```

-   `<directory>`: The directory to scan for PDF files.
-   `[true|false]`: Optional boolean argument to print only PDFs that need OCR. Default is `false`.
-   `--output-path=<output_directory>`: Optional argument to specify the directory where OCR-processed PDFs will be saved.
-   `--language=<ocr_languages>`: Optional argument to specify the languages for OCR. Default is `eng`.

## Examples

### Example 1: Basic Usage

Scan the directory and print both PDFs containing text and those needing OCR:

```sh
./pdfscan_ocr.sh /path/to/your/directory
```

### Example 2: Print Only PDFs Needing OCR

Scan the directory and print only PDFs that need OCR:

```sh
./pdfscan_ocr.sh /path/to/your/directory true
```

### Example 3: Perform OCR and Save to Output Directory

Scan the directory, perform OCR on PDFs that need it, and save the output to the specified directory:

```sh
./pdfscan_ocr.sh /path/to/your/directory true --output-path=/path/to/output
```

### Example 4: Specify OCR Languages

Scan the directory, perform OCR on PDFs that need it with specified languages, and save the output to the specified directory:

```sh
./pdfscan_ocr.sh /path/to/your/directory true --output-path=/path/to/output --language=eng+fra
```

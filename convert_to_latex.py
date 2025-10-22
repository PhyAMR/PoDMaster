#!/usr/bin/env python3
import os
import sys
from mpxpy.mathpix_client import MathpixClient, MathpixClientError

def convert_to_latex(input_dir):
    """
    Converts all supported files in a directory to .tex.zip files using the Mathpix API.
    """
    output_dir = os.path.join(input_dir, "latex_output")
    os.makedirs(output_dir, exist_ok=True)

    try:
        client = MathpixClient()  # Assumes MATHPIX_APP_ID and MATHPIX_APP_KEY are set as environment variables
    except MathpixClientError as e:
        print(f"Authentication failed: {e}", file=sys.stderr)
        print("Please set the MATHPIX_APP_ID and MATHPIX_APP_KEY environment variables.", file=sys.stderr)
        sys.exit(1)

    print(f"Processing files in: {input_dir}")
    print(f"Output will be saved to: {output_dir}")

    for filename in os.listdir(input_dir):
        file_path = os.path.join(input_dir, filename)
        if os.path.isfile(file_path):
            filename_no_ext, ext = os.path.splitext(filename)
            output_path = os.path.join(output_dir, f"{filename_no_ext}.tex.zip")

            print(f"Converting '{filename}'...")

            try:
                if ext.lower() == ".pdf":
                    pdf = client.pdf_new(
                        file_path=file_path,
                        convert_to_tex_zip=True
                    )
                    pdf.wait_until_complete(timeout=120)
                    pdf.to_tex_zip_file(path=output_path)
                    print(f"Successfully converted '{filename}' to '{output_path}'")
                else:
                    print(f"Skipping unsupported file type: {filename}")

            except MathpixClientError as e:
                print(f"Error converting '{filename}': {e}", file=sys.stderr)
            except Exception as e:
                print(f"An unexpected error occurred with '{filename}': {e}", file=sys.stderr)

    print(f"Conversion complete for all files in '{input_dir}'.")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print(f"Usage: {sys.argv[0]} <input_directory>", file=sys.stderr)
        print("Example: {sys.argv[0]} /path/to/your/notes", file=sys.stderr)
        sys.exit(1)

    input_directory = sys.argv[1]
    if not os.path.isdir(input_directory):
        print(f"Error: Input directory '{input_directory}' not found.", file=sys.stderr)
        sys.exit(1)

    convert_to_latex(input_directory)

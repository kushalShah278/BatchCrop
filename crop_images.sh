#!/bin/bash

# Ask the user for the input directory path
echo "Enter the path to the input directory:"
read -r input_dir

# Check if the input directory exists
if [ ! -d "$input_dir" ]; then
    echo "Error: Input directory does not exist."
    exit 1
fi

# Ask the user for the x and y coordinates of the origin point
echo "Enter the x-coordinate of the origin point:"
read -r origin_x

echo "Enter the y-coordinate of the origin point:"
read -r origin_y

# Ask the user for the width and height of the crop window
echo "Enter the width of the crop window:"
read -r crop_width

echo "Enter the height of the crop window:"
read -r crop_height

# Create an output directory for cropped images
output_dir="$input_dir/cropped_images"
mkdir -p "$output_dir"

# Iterate over all JPEG and HEIC files in the input directory
find "$input_dir" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.heic" \) | while IFS= read -r file; do
    # Check if the file is a valid JPEG or HEIC
    if [ -f "$file" ]; then
        # Get the file name without extension
        filename=$(basename -- "$file")
        filename_no_ext="${filename%.*}"

        # Determine the file extension and construct the output file path
        if [[ "$filename" == *.[Jj][Pp][Gg] || "$filename" == *.[Jj][Pp][Ee][Gg] ]]; then
            output_extension="jpeg"
        elif [[ "$filename" == *.[Hh][Ee][Ii][Cc] ]]; then
            output_extension="heic"
        else
            # Skip unsupported file types
            echo "Warning: $file has an unsupported file type - skipping"
            continue
        fi

        # Output file path
        output_file="$output_dir/cropped_$filename_no_ext.$output_extension"

        # Crop the image
        convert "$file" -crop "${crop_width}x${crop_height}+${origin_x}+${origin_y}" "$output_file"

        echo "Cropped $filename and saved to $output_file"
    else
        echo "Warning: $file not a valid file - skipping"
    fi
done

echo "Image cropping complete."


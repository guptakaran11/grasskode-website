#!/usr/bin/env bash
# Purpose: batch image resizer

FOLDER=""
DIM=1024
OUTPUT=""

while test $# -gt 0; do
  case "$1" in
    -h|--help)
      echo "$package - resize images in a folder to a max dimension"
      echo " "
      echo "options:"
      echo "-h, --help                 show brief help"
      echo "-f, --folder               specify input folder. Required."
      echo "-d, --dim                  specify maximum dimension of resized image. Defaults to 1024."
      echo "-o, --output               specify output directory. Defaults to input directory is not specified."
      exit 0
      ;;
    -f|--folder)
      shift
      FOLDER=$1
      shift
      ;;
    -d|--dim)
      shift
      DIM=$1
      shift
      ;;
    -o|--output)
      shift
      OUTPUT=$1
      shift
      ;;
    *)
      echo "Unknown parameter $1"
      exit 1
      ;;
  esac
done

echo "FOLDER        = $FOLDER"
echo "DIMENSION     = $DIM"
echo "OUTPUT FOLDER = $OUTPUT"

if [[ $FOLDER == "" ]]; then
  echo "No input folder provided."
  exit 1
fi

if [[ $OUTPUT == "" ]]; then
  read -r -p "No output folder specified. This will result in overwriting of images. Press 'Y' to continue. [Y/n] " response
  case "$response" in
      [nN])
        echo "Please specify an output directory using the --output flag."
        exit 1
        ;;
      *)
        OUTPUT=$FOLDER
        ;;
  esac
fi

#resize png or jpg to either height or width, keeps proportions using imagemagick
#find ${FOLDER} -iname '*.jpg' -o -iname '*.png' -exec convert \{} -verbose -resize $WIDTHx$HEIGHT\> \{} \;

#resize png to either height or width, keeps proportions using imagemagick
#find ${FOLDER} -iname '*.png' -exec convert \{} -verbose -resize $WIDTHx$HEIGHT\> \{} \;

#resize jpg only to either height or width, keeps proportions using imagemagick
# find ${FOLDER} -iname '*.jpg' -exec convert \{} -verbose -resize $WIDTHx$HEIGHT\> \{} \;

# alternative
#mogrify -path ${FOLDER} -resize ${WIDTH}x${HEIGHT}% *.png -verbose

for filename in ${FOLDER}/*; do
  if file "$filename" | grep -qE 'image|bitmap'; then
    echo "converting $filename..."
    xpath=${filename%/*}
    xbase=${filename##*/}
    convert $filename -verbose -resize ${DIM}x${DIM}\> "${OUTPUT}/${xbase}"
  fi
done

exit 0

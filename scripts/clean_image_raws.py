#!/usr/bin/python
import argparse
import os, sys
from send2trash import send2trash

_IMAGE_FORMATS = ["jpg", "jpeg"]
_RAW_FORMATS = ["orf"]

def clean_folder(path):
    # check if path is a directory
    if not os.path.isdir(path):
        print('{0} : Path is not a valid directory!'.format(path))
        sys.exit(1)

    # partition the files into images and raws
    images = {}
    raws =  {}
    for file in os.listdir(path):
        filepath = os.path.join(path, file)
        if os.path.isfile(filepath):
            filename = os.path.splitext(file)[0]
            extension = os.path.splitext(file)[1][1:]
            print(filename, extension)
            if extension.lower() in _IMAGE_FORMATS:
                images[filename] = filepath
            elif extension.lower() in _RAW_FORMATS:
                raws[filename] = filepath
            else:
                print('{0}.{1} : File format not supported!'.format(filename, extension))

    # find the raws that do not have corresponding image file
    for filename in raws:
        if filename not in images:
            print('{0} : Image not found for the raw. Sending {1} to trash.'.format(filename, raws[filename]))
            # move the raw to trash
            send2trash(raws[filename])

    # all done
    sys.exit(0)

parser = argparse.ArgumentParser()
parser.add_argument('path')

if __name__ == '__main__':
    args = parser.parse_args()
    clean_folder(args.path)

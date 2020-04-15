from datetime import datetime
import pytz
import os, sys
import argparse
import re

# list of timezones here : https://gist.github.com/heyalexej/8bf688fd67d7199be4a1682b3eec7568

def rename_images(folder):
    timezone = input("Enter timezone (press enter for default) (https://gist.github.com/heyalexej/8bf688fd67d7199be4a1682b3eec7568) : ")
    if timezone == "":
        timezone = 'Asia/Kolkata'

    print("Renaming files in {0} for timezone {1}".format(folder, timezone))
    allfiles = []
    # read list of files in folder
    for file in os.listdir(folder):
        fullpath = os.path.join(folder, file)
        if os.path.isfile(fullpath):
            allfiles.append(fullpath)

    for file in allfiles:
        dt = datetime.fromtimestamp(os.path.getmtime(file), tz=pytz.timezone(timezone))
        dirname = os.path.dirname(file)
        filename = os.path.basename(file)
        prefix = dt.strftime('%m%d')
        renamed_file = os.path.join(dirname, prefix+'-'+filename)
        print("%s -> %s"%(file, renamed_file))
        os.rename(file, renamed_file)

def clean_file_names(folder):
    print("Cleaning files in {0}".format(folder))
    allfiles = []
    # read list of files in folder
    for file in os.listdir(folder):
        fullpath = os.path.join(folder, file)
        if os.path.isfile(fullpath):
            allfiles.append(fullpath)

    for file in allfiles:
        dirname = os.path.dirname(file)
        filename = os.path.basename(file)
        res = re.match('(?:\d\d\d\d\-)*((?:\d\d\d\d\-).+)', filename)
        if res:
            filename = res.group(1)
            renamed_file = os.path.join(dirname, filename)
            print("%s -> %s"%(file, renamed_file))
            os.rename(file, renamed_file)

parser = argparse.ArgumentParser()
parser.add_argument('--clean', dest='clean', action='store_true')
parser.set_defaults(clean=False)

if __name__ == '__main__':
    args = parser.parse_args()

    folder = input("Enter folder name : ")
    if not (os.path.exists(folder) and os.path.isdir(folder)):
        print("Path is not a valid folder.")
        sys.exit(1)

    if not args.clean:
        rename_images(folder)
    else:
        clean_file_names(folder)

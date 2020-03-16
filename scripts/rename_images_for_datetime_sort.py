from datetime import datetime
import pytz
import os, sys
import fnmatch

# list of timezones here : https://gist.github.com/heyalexej/8bf688fd67d7199be4a1682b3eec7568

if __name__ == "__main__":
    folder = input("Enter folder name : ")
    timezone = input("Enter timezone (https://gist.github.com/heyalexej/8bf688fd67d7199be4a1682b3eec7568) : ")

    if not (os.path.exists(folder) and os.path.isdir(folder)):
        print("Path is not a valid folder.")
        sys.exit(1)

    if timezone == "":
        timezone = 'Asia/Kolkata'

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

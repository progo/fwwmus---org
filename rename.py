#py 3
import os
import re

def dofile(filename):
    with open(filename, 'r+') as f:
        firstline = f.readline().rstrip()
        print(firstline)
        matches = re.match(r'^\* (TODO|DONE) (.*)\s+(:[a-z:]+:)?', firstline)
        if not matches:
            print("Skip")
            return
        matches = matches.groups()
        title = matches[1].strip()

        # now write. Git reset first!
        f.seek(0)
        old_content = f.read()
        f.seek(0)
        f.write("#+TITLE: " + title + "\n")
        f.write("#+SETUPFILE: ~/dokumentit/blog/post-setup.org\n")
        f.write(old_content)
        
for root,dir_,files_ in os.walk('.'):
    for file_ in files_:
        if file_.endswith(".org"):
            # dofile(os.path.join(root, file_))

#!/usr/bin/python

import json
import random
import string
import sys


OUTDIR = "/tmp/sample_app/input/"

def random_hash(size, chars=string.ascii_letters + string.digits):
    return ''.join(random.choice(chars) for _ in xrange(size))

def main():
    amount = int(sys.argv[1])
    for _ in xrange(amount):
        row = {'name': random_hash(10, string.ascii_lowercase),
                'code': int(random_hash(32, string.digits))}
        filename = random_hash(16)
        f = open(OUTDIR + filename, 'w')
        f.write(json.dumps(row))
        f.close()

if __name__ == "__main__":
    main()
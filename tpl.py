#!/usr/bin/env python

import sys
import os
import json
import glob
import argparse

from jinja2 import Environment, FileSystemLoader


def listify(input):
    if not input:
        return []

    for el in input:
        if isinstance(input, (tuple, list)):
            return input
        else:
            return [input]


def render(filename):
    context = {}
    jinja = Environment(
        loader=FileSystemLoader(os.path.dirname(os.path.abspath(filename)))
    )
    jinja.filters["listify"] = listify

    for key in os.environ.keys():
        try:
            context[key] = json.loads(os.environ[key])
        except Exception as err:
            context[key] = os.environ[key]

    template = jinja.get_template(os.path.basename(filename))
    output = template.render(context)

    with open(filename.replace(".tpl", ""), "w") as file:
        file.write(output)

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("file", type=argparse.FileType("r"), nargs="+")
    args = parser.parse_args()

    for file in args.file:
        render(file.name)


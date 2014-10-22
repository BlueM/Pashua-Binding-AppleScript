#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
osacompile -o "$DIR/Pashua.scpt"  "$DIR/Pashua.applescript"
osacompile -o "$DIR/Example.scpt" "$DIR/Example.applescript"

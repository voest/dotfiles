#!/bin/bash

current_window=$(tmux list-windows -F "#F #W" | grep "^\*" | cut -d " " -f 2-)
tmux neww -n "${current_window}" -a -t +1 -c "${PWD}"

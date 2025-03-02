# get short answer from the authoritive dns server
function digs.auth() {
  command dig +short +trace $* | command grep -v "^NS .\.root-servers"
}

# jq with pager
function jq.less () {
  if [ $# -eq 0 ]; then
    command jq -C . | less
  else
    command jq -C $* | less
  fi
}
compdef jq.less=jq

# set tmux window name to ssh host
function ssht () {
  if [ ! -z ${TMUX} ]; then
    icon="🐡"
    current_name=$(tmux list-windows -F "#F #W" | grep '*' | cut -d ' ' -f 2-)
    hostname=$(command ssh -G $* | grep '^hostname' | cut -d ' ' -f 2)
    tmux rename-window "${icon}${hostname}"
    command ssh $*
    tmux setw automatic-rename on
    [[ "${current_name}" == "$(basename ${SHELL})" ]] || tmux rename-window "${current_name}"
  else
    command ssh $*
  fi
}
compdef ssht=ssh

function tmux.rename-window-git () {
  if [ ! -z ${TMUX} ]; then
		toplevel=$(git rev-parse --show-toplevel 2>/dev/null)
		[[ -n "${toplevel}" ]] && tmux rename-window "$(basename "${toplevel}")"
  fi
}

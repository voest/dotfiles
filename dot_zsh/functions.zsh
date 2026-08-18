# get short answer from the authoritive dns server
function digs.auth() {
  command dig +short +trace $* | command grep -v "^NS .\.root-servers"
}

# jq with pager
function jq.less () {
  # Do only run if jq is the last command
  if [ ! -t 1 ]; then
    command jq $*
    return
  fi
  if [ $# -eq 0 ]; then
    command jq -C . | less
  else
    command jq -C $* | less
  fi
}
compdef jq.less=jq

# get brief A and AAAA records of a host 
function q.a() {
  q -f=json A AAAA "${1}" | jq -r '.[].replies[].answer[]? | .a, .aaaa | select(. != null)' | sort
}

# get answer from the authoritive dns server
function q.auth() {
  ns=$(q.ns $1)
  echo "NS: ${ns}" >&2
  q @"${ns}" "$1"
}

# get the authoritive dns server for a host
function q.ns() {
  domain=$1
  dots=$(($(echo "${domain}" | grep -o "\." | wc -l)+1))
  last_ns=
  for i in {2..${dots}}; do
    ns_domain=$(echo "${domain}" | rev | cut -d'.' -f-${i} | rev)
    ns=$(q NS "${ns_domain}" --format=json | jq -r '.[].replies[].answer[0].ns | select(. != null)')
    [[ -z "${ns}" ]] && break
    last_ns=${ns}
  done
  if [[ ! -z "${last_ns}" ]]; then
    echo "${last_ns}"
    return
  else
    echo "No nameserver found" >&2
    return
  fi
}

# get the PTR records for A/AAAA records of a host
function q.ptr() {
  a=$(q.a "${1}")
  echo "${a}" >&2
  echo "${a}" | xargs -r -I% q -x %
}

# perfom a whois query for given host
function q.whois() {
  q.a "${1}" | xargs -r -I% grc --colour=on whois --verbose % | less
}

retry() {
  while true
  do
    echo $@ >&2
    $@ && return
    sleep 1
  done
}

d2() {
  docker run --rm -it -u "1000:1000" -v "$PWD:/home/debian/src" terrastruct/d2 $@
}

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

# echo "foo" | xtimes 5
fuction xtimes() {
  local copies input
  copies=${1:-2}
  input=$(cat)
  repeat $copies print -r -- "$input"
}

# kubectl get all for api-resources
function kgapi() {
  local IGNORE_DEFAULTS='^(cronjobs.batch|daemonsets.apps|deployments.apps|jobs.batch|pods|replicasets.apps|services|statefulsets.apps)$'
  local IGNORE_EXACT='^(bindings|endpoints|events|events.events.k8s.io|localsubjectaccessreviews.authorization.k8s.io|pods.metrics.k8s.io|secrets)$'
  local IGNORE_GROUPS='cilium.io|fluxcd.io|kong|longhorn'
  kubectl api-resources --namespaced=true --sort-by=name -o name | \
    rg -v "$IGNORE_DEFAULTS" | \
    rg -v "$IGNORE_EXACT" | \
    rg -v "$IGNORE_GROUPS" | \
    while read -r resource; do
      resources=$(kubecolor get --force-colors --no-paging --ignore-not-found=true --show-kind=true "$resource" "$@" | grep -v "helm.sh/release.v1")
      if [[ "$(echo "${resources}" | wc -l)" -ge 2 ]]; then
        echo "$(tput setaf 14)$(tput bold)${resource}$(tput sgr0)" >&2
        echo "${resources}"
        echo >&2
      fi
    done
}

kgsecd() {
  if (kubectl get secret $@ &>/dev/null); then
    kubectl get secret $@ -o json | jq ".data|map_values(@base64d)"
  else
    echo "Secret not found: $@. Did you specify the correct namespace?" >> /dev/stderr
  fi
}

function tmux.rename-window-git () {
  if [ ! -z ${TMUX} ]; then
    toplevel=$(git rev-parse --show-toplevel 2>/dev/null)
    [[ -n "${toplevel}" ]] && tmux rename-window "$(basename "${toplevel}")"
  fi
}

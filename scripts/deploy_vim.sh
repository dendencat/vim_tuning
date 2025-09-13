#!/usr/bin/env bash
set -euo pipefail

repo_root="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
[ -f "${repo_root}/.githooks.env" ] && source "${repo_root}/.githooks.env"

timestamp="$(date +%Y%m%d-%H%M%S)"

deploy_one () {
  local src="$1" dst="$2"
  [ -z "${dst}" ] && { echo "? no deploy destination for ${src}"; return 1; }

  mkdir -p "$(dirname "${dst}")"

  if [ -n "${ENABLE_BACKUP:-}" ] && [ "${ENABLE_BACKUP}" = "1" ] && [ -f "${dst}" ]; then
    local bdir="${BACKUP_DIR:-$(dirname "${dst}")}"
    mkdir -p "${bdir}"
    local bfile="${bdir}/$(basename "${dst}").${timestamp}.bak"
    cp -p "${dst}" "${bfile}"
    echo "? backup: ${bfile}"
  fi

  # install: 権限固定・タイムスタンプ更新
  install -m 0644 "${src}" "${dst}"
  echo "? deployed: ${src} -> ${dst}"
}

changed_list=("$@")  # ここにはコミットで変わった対象ファイル名が来る想定

for f in "${changed_list[@]}"; do
  case "${f}" in
    .vimrc)
      deploy_one "${repo_root}/.vimrc" "${DEPLOY_VIMRC}"
      ;;
    init.vim)
      deploy_one "${repo_root}/init.vim" "${DEPLOY_INITVIM}"
      ;;
    *)
      # 対象外はスキップ
      ;;
  esac
done


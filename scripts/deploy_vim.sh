#!/usr/bin/env bash
set -euo pipefail

repo_root="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
vimrc_path="${repo_root}"/.vimrc
vimrc_core_path="${repo_root}"/.vim/vimrc_core.vim
init_vim_path="${repo_root}"/.config/nvim/.vimrc


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
      deploy_one "${vimrc_path}" "${DEPLOY_VIMRC}"
      ;;
    vimrc_core.vim)
      deploy_one "${vimrc_core_path}" "${DEPLOY_VIMRC_CORE}"
      ;;
    init.vim)
      deploy_one "${init_vim_path}" "${DEPLOY_INITVIM}"
      ;;
    *)
      # 対象外はスキップ
      ;;
  esac
done


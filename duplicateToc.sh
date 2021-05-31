#!/usr/bin/env bash

function duplicate() {
  local file="$1"

  if [ -n "${retail}" ]; then
    if ! grep -q "## Interface-Retail:" "$file"; then
      echo "No ## Interface-Retail found in $file. Skipping."
    else
      local target="${file/.toc/-Mainline.toc}"
      echo "Creating file $target"
      cp "$file" "$target"
      sed -ri "/^## Interface:.*\$/d" "$target"
      sed -ri "/^## Interface-BCC:.*\$/d" "$target"
      sed -ri "/^## Interface-Classic:.*\$/d" "$target"

		  sed -ri "s/^(## Interface)-Retail(:.*)\$/\1\2/" "$target"

#      sed -ri "/^## Interface-Retail:.*\$/d" "$file"
# disabled until packagers support version-specific toc files
    fi
  fi

  if [ -n "${bcc}" ]; then
    if ! grep -q "## Interface-BCC:" "$file"; then
      echo "No ## Interface-BCC found in $file. Skipping."
    else
      local target="${file/.toc/-BCC.toc}"
      echo "Creating file $target"
      cp "$file" "$target"
      sed -ri "/^## Interface:.*\$/d" "$target"
      sed -ri "/^## Interface-Retail:.*\$/d" "$target"
      sed -ri "/^## Interface-Classic:.*\$/d" "$target"

		  sed -ri "s/^(## Interface)-BCC(:.*)\$/\1\2/" "$target"

#      sed -ri "/^## Interface-BCC:.*\$/d" "$file"
# disabled until packagers support version-specific toc files
    fi
  fi

  if [ -n "${classic}" ]; then
    if ! grep -q "## Interface-Classic:" "$file"; then
      echo "No ## Interface-Classic found in $file. Skipping."
    else
      local target="${file/.toc/-Classic.toc}"
      echo "Creating file $target"
      cp "$file" "$target"
      sed -ri "/^## Interface:.*\$/d" "$target"
      sed -ri "/^## Interface-Retail:.*\$/d" "$target"
      sed -ri "/^## Interface-BCC:.*\$/d" "$target"

		  sed -ri "s/^(## Interface)-Classic(:.*)\$/\1\2/" "$target"

#      sed -ri "/^## Interface-Classic:.*\$/d" "$file"
# disabled until packagers support version-specific toc files
    fi
  fi
}

if [ -n "${retail}" ]; then
  if [[ ("$retail" == "false") || ("$retail" == "0") ]]; then
    retail=
  fi
else
    retail=true
fi

if [ -n "${bcc}" ]; then
  if [[ ("$bcc" == "false") || ("$bcc" == "0") ]]; then
    bcc=
  fi
else
    bcc=true
fi

if [ -n "${classic}" ]; then
  if [[ ("$classic" == "false") || ("$classic" == "0") ]]; then
    classic=
  fi
else
    classic=true
fi

if [ $# -eq 0 ]; then
  while read -r file; do
    duplicate "$file"
  done < <(find . -maxdepth 1 -name '*.toc' ! -name '*-Mainline.toc' ! -name '*-Classic.toc' ! -name '*-BCC.toc')
else
  for var in "$@"
  do
    if [[ "$var" != *"-Mainline.toc"* &&  "$var" != *"-Classic.toc"* &&  "$var" != *"-BCC.toc"* ]]; then
      duplicate "$var"
    fi
  done
fi

#!/bin/bash
dists=stable
termux_repo_url=https://packages.termux.org/apt/termux-main/dists/${dists}/

release_context=$(mktemp /tmp/release_context.XXXXXXX)
release_file=$(mktemp /tmp/release_file.XXXXXXX)
wget -P /tmp/ -O ${release_file} ${termux_repo_url}Release 

grep -A32 -P '^MD5Sum\:$' Release | tail -n32 > $release_context

down_dists() {
	for i in `cat $release_context`;
	do	
		checksum=$( echo $i | cut -d' ' -f2 )
		filename=$( echo $i | rev | cut -d' ' -f1 | rev )
		echo "Checksum here: $checksum and filename here: $filename"
		wget -nH -nc -x --cut-dirs=3 ${termux_repo_url}$filename
	done
	mv -f stable/ ~/termux-mirror/termux-main/dists/
}
down_dists

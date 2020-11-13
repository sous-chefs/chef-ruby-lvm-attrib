#!/bin/sh
# Script to checkout LVM2 from git and make attributes for all versions that
# don't have yet.
#
# Author: Elan Ruusamäe <glen@delfi.ee>
#
# Usage:
# - update all versions: ./update-lvm.sh -a
# - update specific version "2.0.102": ./update-lvm.sh v2_02_102

# ADDING ATTRIBUTES:
# To add attributes:
# * Download and extract LVM2 source version from: https://sourceware.org/git/?p=lvm2.git;a=tags
# * Fork this repository
# * `bin/generate_field_data path/to/lvm2-source`
#   * See missing attribute type note below if there's issues, otherwise will just return "Done."
# * `mv LVM_VERSION_FULL lib/lvm/attributes/LVM_VERSION`
#   * LVM_VERSION_FULL being something like 2.02.86(2)-cvs or 2.02.98(2)-git
#   * LVM_VERSION being something like 2.02.86(2) or 2.02.98(2)
# * `git commit -am "Added LVM_VERSION attributes"`
# * `git push origin mybranch`
#

refs=refs/heads/main:refs/remotes/origin/main
pattern=v2_0[23]_*
git_dir=lvm2/.git

set -e

msg() {
	echo >&2 "$*"
}

# do initial clone or update LVM2 repository
update_lvm2_repo() {
	if [ ! -e lvm2/.git ]; then
		msg "Checkout LVM2 repository"
		git submodule update --init --recursive
	fi

	msg "Update LVM2 repository"
	GIT_DIR=$git_dir git fetch origin $refs --tags
}

process_lvm2_version() {
	local tag=$1
	msg ""
	msg "Process LVM2 $tag"

	# already present in source tree
	if [ -d lib/lvm/attributes/$tag ]; then
		msg "lib/lvm/attributes/$tag already exists, skip"
		return 1
	fi

	msg "Checkout LVM2 $tag"
	GIT_DIR=lvm2/.git git checkout $tag

	version=$(awk '{print $1}' lvm2/VERSION)
	msg "LVM2 Full Version: $version"
	# skip old "cvs" releases
	case "$version" in
	*-cvs)
		msg "$version is CVS tag, skip"
		return 1
		;;
	esac

	# remove -git suffix
	version=${version%-git}
	msg "LVM2 Sanitized Version: $version"

	attr_dir=lib/lvm/attributes/${version}
	if [ -d "$attr_dir" ]; then
		msg "$attr_dir already exists, skip"
		return 1
	fi

	git_branch=LVM-${version}

	# check that local branch isn't already created
	if git show-ref --verify --quiet refs/heads/$git_branch; then
		msg "Git branch '$git_branch' already exists; skip"
		return 1
	fi

	./bin/generate_field_data lvm2
	if [ ! -d "$attr_dir" ]; then
		msg "Failed to generate $attr_dir"
		return 1
	fi

	git add -A $attr_dir
	git checkout -b $git_branch master
	cat > .git/commit-msg <<-EOF
Added $tag attributes

$(git diff --stat HEAD $attr_dir)
EOF
	git commit -s -F .git/commit-msg $attr_dir

	return 0
}

update_lvm2_repo

if [ "$1" = "-a" ]; then
	# obtain all versions
	set -- $(GIT_DIR=lvm2/.git git tag -l $pattern)
fi

# process versions specified on commandline,
# otherwise iterate over all LVM2 tags
for tag in "$@"; do
	process_lvm2_version $tag || continue
	updated=1
done

# keep the pointer to main branch
GIT_DIR=lvm2/.git git checkout main

if [ -z "$updated" ]; then
	echo >&2 "Nothing updated"
	exit 1
fi

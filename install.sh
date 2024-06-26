#!/bin/bash

cd `dirname $0`

DATE=`date +"%Y-%m-%d-%H%M%S%Z"`
LOGDIR=./log

function list_files() {
	local DIR=$1
	find $DIR -mindepth 1 -type f | sed "s|${DIR}\/||"
}

function create_target_dir(){
	local DIR=$1
	if [ ! -d $DIR ]; then
		#echo -e "  [create]  ${DIR}"
		mkdir -p $DIR
	fi
}

function backup_exist(){
	local TARGET=$1
	if [ -f $TARGET ]; then
		echo -e "  [ warn ]  file exist"
		# backup
		echo -e "  [backup]  ${TARGET} ===> ${TARGET}.bak"
		mv ${TARGET} ${TARGET}.bak
	fi
}

function install_file(){
	local SRC=$1
	local TARGET=$2
	local FILE=$3

	#echo -e "install $FILE to $TARGET"
	create_target_dir `dirname $TARGET/$FILE`
	backup_exist $TARGET/$FILE
	echo -en "  [ link ]  "
	#echo "${SRC}/${FILE} -> ${TARGET}/${FILE}"
	ln -snbfvr ${SRC}/${FILE} ${TARGET}/${FILE}
}

function generate_env(){
	local SYSTEMD_ENV_DIR=config/environment.d
	local GEN_CONF=$SYSTEMD_ENV_DIR/gen.conf

	local LAST_DOTFILE_INSTALL=`date --rfc-3339=s`

	create_target_dir $SYSTEMD_ENV_DIR
	echo "generate env config..."
	echo "  [ gen  ] $GEN_CONF"
	cat <<EOF > $GEN_CONF
LAST_DOTFILE_INSTALL="${LAST_DOTFILE_INSTALL}"
EOF
}

function gnome_update() {
    dconf load / < gnome-settings.ini
}

function install_all(){
	echo "HOME = ${HOME}"
	echo "XDG_CONFIG_HOME = ${XDG_CONFIG_HOME}"
	echo ""

	generate_env

	export -f create_target_dir
	export -f backup_exist
	export -f install_file

	echo ""

	echo "install dot files..."
	#list_files files
	list_files files | xargs -i bash -c "install_file files $HOME '{}'"
	echo ""

	echo "install XDG config files..."
	#list_files config
	list_files config | xargs -i bash -c "install_file config $XDG_CONFIG_HOME '{}'"
	echo ""

    gnome_update
}

function main(){
	# check required environment value
	if [ -z $HOME ]; then
		echo "\$HOME does not exist" >&2
		exit 1
	fi
	if [ -z $XDG_CONFIG_HOME ]; then
		echo "warn: \$XDG_CONFIG_HOME does not exist" >&2
		XDG_CONFIG_HOME=$HOME/.config
		export XDG_CONFIG_HOME
	fi

	install_all
}

# disable execute main when source
return 1 2>/dev/null || true

create_target_dir $LOGDIR
main | tee ${LOGDIR}/${DATE}.log
check_cwd() {
    test -e publican.cfg || \
	(echo "Run it from the publican top level dir please" >&2; exit 1)
}

get_product_version() {
    sed -n -e 's|.*<productnumber>\(.*\)</productnumber>.*|\1|p' en-US/Book_Info.xml
}

get_release() {
    version=$(get_product_version)
    case "$version" in
	6.0*)
	    release="squeeze"
	;;
	7*)
	    release="wheezy"
	;;
	8*)
	    release="jessie"
	;;
	9*)
	    release="stretch"
	;;
	10*)
	    release="buster"
	;;
	11*)
	    release="bullseye"
	;;
	*)
	    echo "ERROR: unable to identify release for version $version" >&2
	    exit 1
	;;
    esac
    echo "$release"
}

get_publish_directory() {
    local lang="${1:-en-US}"
    local format="${2:-html}"
    local version=$(get_product_version)
    echo "publish/$lang/Debian/$version/$format"
}

parse_options() {
    local temp
    temp=$(getopt -o l:so:p -l lang:,skip,opts:,paperback -- "$@")
    eval set -- "$temp"
    while true; do
	case "$1" in
	    -l|--lang) OPT_lang="$2"; shift 2; ;;
	    -o|--opts) OPT_opts="$2"; shift 2; ;;
	    -s|--skip) OPT_skip="1"; shift 1; ;;
	    -p|--paperback) OPT_paperback="1"; shift 1; ;;
	    --) shift; break; ;;
	    *) echo "ERROR: Invalid command-line option: $1" >&2; exit 1; ;;
	esac
    done
}

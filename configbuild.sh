# @Author: vutang
# @Date:   2018-10-18 14:00:17
# @Last Modified by:   vutang
# @Last Modified time: 2018-10-23 14:50:03

HW_NAME="wavegen"

while [ $# -ne 0 ]; do
	case "$1" in
		--wavegen)
			HW_NAME="wavegen"
			shift
			;;
		--wifi)
			HW_NAME="wifi"
			shift
			;;
		*)
			exit 1
			;;
	esac
done

rm $(pwd)/subsystems
ln -s $(pwd)/subsystems_${HW_NAME} $(pwd)/subsystems

rm $(pwd)/components/bootloader
ln -s $(pwd)/components/bootloader_${HW_NAME} $(pwd)/components/bootloader

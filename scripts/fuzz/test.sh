# realpath ../../
realpath "$(cd -- "$(dirname -- "$1")"; pwd)/$(basename -- "$1")/../.."

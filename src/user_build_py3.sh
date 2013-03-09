#!/bin/bash

PYTHON=python

reset() {
	rm -rf pyastyle/build
}

reset

CURRENT_PATH=`pwd`

if [ $OSTYPE = "linux-gnu" ]; then
	# In Linux, Sublime Text's Python is compiled with UCS4:
	echo "Linux build!"
	if [ `uname -m` == 'x86_64' ]; then
		export CXXFLAGS="-fPIC $CFLAGS"
		export CFLAGS="-fPIC $CFLAGS"
	else
		export CXXFLAGS="-I $CFLAGS"
		export CFLAGS="-I $CFLAGS"
	fi
elif [ ${OSTYPE:0:6} = "darwin" ]; then
	echo "Mac OS X build!"
	export ARCHFLAGS="-arch x86_64 $ARCHFLAGS"
	export CXXFLAGS="arch x86_64 -I /tmp/pcre-8.21 $CFLAGS"
	export CFLAGS="-arch x86_64 -I /tmp/pcre-8.21 $CFLAGS"
	export LDFLAGS="-arch x86_64 $LDFLAGS"
fi

(echo "Building pyastyle..." && \
	cd pyastyle && \
	$PYTHON setup.py build && \
	cd "$CURRENT_PATH"
) && \

find . -type f -name "pyastyle.so" -exec cp {} ../pyastyle/python3/_local_arch \; && \

reset && \
echo "Done!" || \
echo "Build Failed!$ERR"

strip ../pyastyle/python3/_local_arch/*.so > /dev/null 2>&1

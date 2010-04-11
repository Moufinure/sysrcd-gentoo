#!/bin/bash

imagename="$1"

case ${imagename} in
	rescue64)
		KERTYPE=std
		ARCHNAME=amd64
		LIBDIR=lib64
		;;
	altker32)
		KERTYPE=alt
		ARCHNAME=i386
		LIBDIR=lib
		;;
	altker64)
		KERTYPE=alt
		ARCHNAME=amd64
		LIBDIR=lib64
		;;
	*)
		echo "$0: invalid argument"
		exit 1
		;;
esac

(cd /worksrc/sysresccd-src/mainfiles ; nice catalyst -a -f sysresccd-stage2-${imagename}.spec)
echo "RESULT: $?"
#[ $? -ne 0 ] && echo "ERROR: compilation failed" && exit 1

targetdir="/worksrc/sysresccd-bin/overlay-squashfs-x86/${LIBDIR}/modules"
rootkernel=$(ls -d /var/tmp/catalyst/builds/default/livecd-stage2-${ARCHNAME}-*-${KERTYPE}/isolinux)
rootmodule=$(ls -d /var/tmp/catalyst/tmp/default/livecd-stage2-${ARCHNAME}-*-${KERTYPE}/${LIBDIR}/modules)
kerversion=$(ls ${rootmodule})

echo "rootkernel=[${rootkernel}]"
echo "rootmodule=[${rootmodule}]"
echo "kerversion=[${rootmodule}]"

if [ -z "${rootkernel}" ] || [ -z "${rootmodule}" ] || [ -z "${rootmodule}" ]
then
	echo "ERROR: invalid variables"
	exit 1
fi

echo "cp ${rootkernel}/${imagename}* /worksrc/sysresccd-bin/kernels-x86/"
cp ${rootkernel}/${imagename}* /worksrc/sysresccd-bin/kernels-x86/

mkdir -p ${targetdir}
echo "(cd ${rootmodule} ; tar cfj ${targetdir}/${kerversion}.tar.bz2 ${kerversion})"
(cd ${rootmodule} ; tar cfj ${targetdir}/${kerversion}.tar.bz2 ${kerversion})

#!/bin/bash
if test "`whoami`" != "root"; then
	echo "Please run as root."
	exit
fi

if [ ! -e build/game.img ]
then
	mkdosfs -C build/game.img 1440 || exit
fi

nasm -O0 -w+orphan-labels -f bin -o build/boot.bin boot.asm || exit
dd status=noxfer conv=notrunc if=build/boot.bin of=build/game.img || exit

nasm -O0 -w+orphan-labels -f bin -o build/game.bin game.asm || exit

rm -rf tmp-loop
mkdir tmp-loop
mount -o loop -t vfat build/game.img tmp-loop
cp build/game.bin tmp-loop
sync
sleep 0.2
umount tmp-loop || exit
rm -rf tmp-loop

qemu-system-x86_64 -fda build/game.img

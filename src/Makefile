# Toolchain folder
SHELFPATH = /opt/toolchains/dc/sh-elf_9.3.0_raw/bin
# dc-load-ser that will be included in the custom BIOS
export DCLOADERSERIALPATH = /opt/toolchains/dc/tools/dcload-serial/target-src/1st_read/loader.bin
#Note: current size of loader.bin = +- 15k. jinGasa.s does a memcopy for 32k, so adapt jinGasa.s  when loader.bin exceeds 32k.
export DCLOADERSERIALFILESIZE = $(shell du -sb ${DCLOADERSERIALPATH} | cut -f1)
# Font that will be included in the custom BIOS
#  (in a normal dc bios 1.01d, the font is at location 0x100020 (=1048608) for 536496 bytes)
FONTSRCFILE = /opt/toolchains/dc/bin/dc_bios.bin
FONTSRCOFFSET = 1048608 
FONTSRCSIZE = 536496
# Target custom miniBIOS
TARGETBIN = jinGasa.bin
TARGETDCLOADSEROFFSET = 65536 # must be identical as DCLOADSERIAL_START_ADDR in jinGasa.s
TARGETFONTOFFSET = 1048608    # must be identical as ROMFONT_ADDR in vectors.s

all: miniBIOS

asm: miniBIOSelf
	$(SHELFPATH)/sh-elf-objdump -d -S jinGasa.elf > jinGasa.asm

miniBIOSelf:
	$(SHELFPATH)/sh-elf-gcc -fpic jinGasa.s SH4.s HOLLY.s vectors.s AICA.s -o jinGasa.elf -Wl,-Ttext=0x00000000 -nostdlib -e _jinGasa_init

miniBIOS: clean miniBIOSelf
#   Insert the core code into our custom BIOS file
	$(SHELFPATH)/sh-elf-objcopy -O binary -R .stack jinGasa.elf $(TARGETBIN)
#   Insert dc-load-ser into our custom BIOS file
	truncate -s $(TARGETDCLOADSEROFFSET) $(TARGETBIN)
	cat $(DCLOADERSERIALPATH) >> $(TARGETBIN)
#   Extract the font from the source file
	tail -c +$(FONTSRCOFFSET) $(FONTSRCFILE) >tmpfont.bin
	tail -c +2 tmpfont.bin >font.bin
	rm -f tmpfont.bin
	truncate -s $(FONTSRCSIZE) font.bin
#   Insert the font in our custom BIOS file
	truncate -s $(TARGETFONTOFFSET) $(TARGETBIN)
	cat font.bin >> $(TARGETBIN)
#   Expand our custom BIOS file to 2 MB
	truncate -s 2M $(TARGETBIN)
	rm -f jinGasa.elf font.bin

clean:
	rm -f jinGasa.elf jinGasa.asm font.bin $(TARGETBIN) 

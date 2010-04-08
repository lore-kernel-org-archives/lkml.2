Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932849Ab0DHPrt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 11:47:49 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:42710 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932763Ab0DHPrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 11:47:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        b=kZfrAAgOLvzT7E+R0q9Dm5eQDS1m7rV7Xt+FkFR/wrKavzJhQcobRFkvMmxxw9tzzs
         CmZCUd6BfJhT31Is0tL0h7F90STGjZxRts0o4BEC/xuioF/r9YbI1obt1Xvbm8Pzqeqg
         Sccf6AOtQcjUTgoytlsCRC40PpPqUcyYzxVTA=
Date: Thu, 8 Apr 2010 17:47:49 +0200
From: Martin Jansa <martin.jansa@gmail.com>
To: Zaurus PDA developers list <zaurus-devel@www.linuxtogo.org>
Cc: Eric Miao <eric.y.miao@gmail.com>, thommycheck@gmail.com, lenz@cs.wisc.edu,
       dbaryshkov@gmail.com, Cyril Hrubis <metan@ucw.cz>, arminlitzel@web.de,
       kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Marek Vasut <marek.vasut@gmail.com>,
       rpurdie@rpsys.net, linux-arm-kernel@lists.infradead.org,
       maciej.rutecki@gmail.com
Subject: Re: [Zaurus-devel] [regression] 2.6.34-rc1 to -rc3 on zaurus: no
 longer boots
Message-ID: <20100408154749.GE3269@jama>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100408110533.GA14451@atrey.karlin.mff.cuni.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 08, 2010 at 01:05:32PM +0200, Pavel Machek wrote:
> 
> > >> > > > > I tried compiling 2.6.34-rc1, and it does not boot :-(. It does not
> > >> > > > > seem to even reset the framebuffer (I'm using kexec -- so it stays
> > >> > > > > stuck on on previous screen).
> > >> > >
> > >> > > Tried again with -rc2 and -rc3, and neither boots :-(. I did not have
> > >> > > time to set up serial console, yet :-(. Any ideas?
> > >> >
> > >> > I created a Bugzilla entry at
> > >> > https://bugzilla.kernel.org/show_bug.cgi?id=15712
> > >> > for your bug report, please add your address to the CC list in there,
> > >> >  thanks!
> > >> >
> > >> Pavel, you broke it ... and here you say something about sane arm maintainers
> > >> ;-)
> > >
> > > ? You know which patch causes it ?
> > 
> > Just have some time to try this out on my corgi, and the kernel runs
> > happily.
> > 
> > Pavel,
> > 
> > Which exact model are you running your kernel?
> 
> It is Zaurus SL-C3000 (aka spitz). I'm using kexec, but that used to
> work. Should I try minimal config?
> 									Pavel

FYI:

I've just booted on my spitz 2.6.34-rc3 built with OE (config from Andrea), then kexec to 2.6.33.
http://git.openembedded.org/cgit.cgi/openembedded/commit/?id=adadb0343015894e33032b53d87e3e03a368a594

��Linux version 2.6.34-rc3 (bitbake@jama) (gcc version 4.3.3 (GCC) ) #1 Wed Apr 7 09:53:53 CEST 2010                                                
CPU: XScale-PXA270 [69054114] revision 4 (ARMv5TE), cr=0000397f                                                                                     
CPU: VIVT data cache, VIVT instruction cache                                                                                                        
Machine: SHARP Spitz                                                         
Ignoring unrecognised tag 0x00000000                                         
Memory policy: ECC disabled, Data cache writeback
Run Mode clock: 208.00MHz (*16)         
Turbo Mode clock: 416.00MHz (*2.0, active)
Memory clock: 208.00MHz (/2)            
System bus clock: 208.00MHz             
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 16256
Kernel command line: console=tty1 console=ttyS0,115200n8 fbcon=rotate:1
PID hash table entries: 256 (order: -2, 1024 bytes)
Dentry cache hash table entries: 8192 (order: 3, 32768 bytes)
Inode-cache hash table entries: 4096 (order: 2, 16384 bytes)
Memory: 64MB = 64MB total
Memory: 62256k/62256k available, 3280k reserved, 0K highmem
Virtual kernel memory layout:
    vector  : 0xffff0000 - 0xffff1000   (   4 kB)
    fixmap  : 0xfff00000 - 0xfffe0000   ( 896 kB)
    DMA     : 0xffc00000 - 0xffe00000   (   2 MB)
    vmalloc : 0xc4800000 - 0xe8000000   ( 568 MB)
    lowmem  : 0xc0000000 - 0xc4000000   (  64 MB)
    modules : 0xbf000000 - 0xc0000000   (  16 MB)
      .init : 0xc0008000 - 0xc007c000   ( 464 kB)
      .text : 0xc007c000 - 0xc027d000   (2052 kB)
      .data : 0xc027e000 - 0xc02970e0   ( 101 kB)
SLUB: Genslabs=11, HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
Hierarchical RCU implementation.
NR_IRQS:288
start_kernel(): bug: interrupts were enabled early
Console: colour dummy device 80x30
console [tty1] enabled
Calibrating delay loop... 415.33 BogoMIPS (lpj=2076672)
Mount-cache hash table entries: 512
CPU: Testing write buffer coherency: ok
devtmpfs: initialized
Sharp Scoop Device found at 0x10800000 -> 0xc4814000
Sharp Scoop Device found at 0x08800040 -> 0xc4818040
bio: create slab <bio-0> at 0
I2C: i2c-0: PXA I2C adapter
Switching to clocksource oscr0
Switched to NOHz mode on CPU #0
JFFS2 version 2.2. (NAND) (SUMMARY)  © 2001-2006 Red Hat, Inc.
msgmni has been set to 121
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
io scheduler noop registered
io scheduler deadline registered (default)
Console: switching to colour frame buffer device 80x30
pxa2xx-uart.0: ttyS0 at MMIO 0x40100000 (irq = 22) is a FFUART
console [ttyS0] enabled
pxa2xx-uart.1: ttyS1 at MMIO 0x40200000 (irq = 21) is a BTUART
pxa2xx-uart.2: ttyS2 at MMIO 0x40700000 (irq = 20) is a STUART
loop: module loaded
Uniform Multi-Platform E-IDE driver
ide-gd driver 1.18
physmap platform flash device: 00800000 at 00000000
RedBoot partition parsing not available
Using physmap partition information
Creating 1 MTD partitions on "physmap-flash":
0x000000140000-0x000000800000 : "Boot PROM Filesystem"
NAND device: Manufacturer ID: 0xec, Chip ID: 0x73 (Samsung NAND 16MiB 3,3V 8-bit)
Scanning device for bad blocks
Creating 3 MTD partitions on "sharpsl-nand":
0x000000000000-0x000000700000 : "System Area"
0x000000700000-0x000000c00000 : "Root Filesystem"
0x000000c00000-0x000001000000 : "Home Filesystem"
mice: PS/2 mouse device common for all mice
input: matrix-keypad as /devices/platform/matrix-keypad/input/input0
ads7846 spi2.0: touchscreen, irq 107
input: ADS7846 Touchscreen as /devices/platform/pxa2xx-spi.2/spi2.0/input/input1
APM Battery Driver
CAUTION: XScale iWMMXt coprocessor detected, but kernel support is missing.
Freeing init memory: 464K
mmc0: new SD card at address 0001
mmcblk0: mmc0:0001 128MB 119 MiB 
 mmcblk0: p1
pcmcia_socket pcmcia_socket0: pccard: PCMCIA card inserted into slot 0
pcmcia 0.0: pcmcia: registering new device pcmcia0.0
pcmcia_socket pcmcia_socket1: pccard: PCMCIA card inserted into slot 1
pcmcia 1.0: pcmcia: registering new device pcmcia1.0
hda: HMS360404D5CF00, CFA DISK drive
Uncompressing Linux... done, booting the kernel.
Linux version 2.6.33 (bitbake@jama) (gcc version 4.3.3 (GCC) ) #1 Thu Feb 25 09:29:39 CET 2010
CPU: XScale-PXA270 [69054114] revision 4 (ARMv5TE), cr=0000397f
CPU: VIVT data cache, VIVT instruction cache
Machine: SHARP Spitz
Memory policy: ECC disabled, Data cache writeback
On node 0 totalpages: 16384
free_area_init_node: node 0, pgdat c02fbee8, node_mem_map c0338000
  Normal zone: 128 pages used for memmap
  Normal zone: 0 pages reserved
  Normal zone: 16256 pages, LIFO batch:3
Run Mode clock: 208.00MHz (*16)
Turbo Mode clock: 416.00MHz (*2.0, active)
Memory clock: 208.00MHz (/2)
System bus clock: 208.00MHz 
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 16256
Kernel command line: root=/dev/mmcblk0p1 rootfstype=ext3 rootwait mtdparts=sharpsl-nand:7168k(smf),5120k(root),-(home) fbcon=rotate:1 console=ttyS0,115200n8 console=tty1 noinitrd  fbcon=rotate:1  debug
PID hash table entries: 256 (order: -2, 1024 bytes)
Dentry cache hash table entries: 8192 (order: 3, 32768 bytes)
Inode-cache hash table entries: 4096 (order: 2, 16384 bytes)
Memory: 64MB = 64MB total
Memory: 61620KB available (2724K code, 355K data, 88K init, 0K highmem)
Hierarchical RCU implementation.
RCU-based detection of stalled CPUs is enabled.
NR_IRQS:288
Console: colour dummy device 80x30
console [tty1] enabled
Calibrating delay loop... 415.33 BogoMIPS (lpj=2076672)
Mount-cache hash table entries: 512
CPU: Testing write buffer coherency: ok
devtmpfs: initialized
NET: Registered protocol family 16
Sharp Scoop Device found at 0x10800000 -> 0xc4814000
Sharp Scoop Device found at 0x08800040 -> 0xc4818040
bio: create slab <bio-0> at 0
I2C: i2c-0: PXA I2C adapter
Switching to clocksource oscr0
NET: Registered protocol family 2
IP route cache hash table entries: 1024 (order: 0, 4096 bytes)
TCP established hash table entries: 2048 (order: 2, 16384 bytes)
TCP bind hash table entries: 2048 (order: 1, 8192 bytes)
TCP: Hash tables configured (established 2048 bind 2048)
TCP reno registered
UDP hash table entries: 256 (order: 0, 4096 bytes)
UDP-Lite hash table entries: 256 (order: 0, 4096 bytes)
NET: Registered protocol family 1
JFFS2 version 2.2. (NAND) (SUMMARY)  �੩ 2001-2006 Red Hat, Inc.
msgmni has been set to 120
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered (default)
Console: switching to colour frame buffer device 80x30
PXA Overlay driver loaded successfully!
pxa2xx-uart.0: ttyS0 at MMIO 0x40100000 (irq = 22) is a FFUART
console [ttyS0] enabled
pxa2xx-uart.1: ttyS1 at MMIO 0x40200000 (irq = 21) is a BTUART
pxa2xx-uart.2: ttyS2 at MMIO 0x40700000 (irq = 20) is a STUART
loop: module loaded
Uniform Multi-Platform E-IDE driver
ide-gd driver 1.18
physmap platform flash device: 00800000 at 00000000
RedBoot partition parsing not available
Using physmap partition information
Creating 1 MTD partitions on "physmap-flash":
0x000000140000-0x000000800000 : "Boot PROM Filesystem"
NAND device: Manufacturer ID: 0xec, Chip ID: 0x73 (Samsung NAND 16MiB 3,3V 8-bit)
Scanning device for bad blocks
3 cmdlinepart partitions found on MTD device sharpsl-nand
Creating 3 MTD partitions on "sharpsl-nand":
0x000000000000-0x000000700000 : "smf"
0x000000700000-0x000000c00000 : "root"
0x000000c00000-0x000001000000 : "home"
mice: PS/2 mouse device common for all mice
input: gpio-keys as /devices/platform/gpio-keys/input/input0
input: matrix-keypad as /devices/platform/matrix-keypad/input/input1
ads7846 spi2.0: touchscreen, irq 107
pcmcia_socket pcmcia_socket0: pccard: PCMCIA card inserted into slot 0
pcmcia 0.0: pcmcia: registering new device pcmcia0.0
pcmcia_socket pcmcia_socket1: pccard: PCMCIA card inserted into slot 1
pcmcia 1.0: pcmcia: registering new device pcmcia1.0
input: ADS7846 Touchscreen as /devices/platform/pxa2xx-spi.2/spi2.0/input/input2
APM Battery Driver
TCP cubic registered
XScale iWMMXt coprocessor detected.
Probing IDE interface ide0...
mmc0: new SDHC card at address 8131
mmcblk0: mmc0:8131 SD08G 7.50 GiB 
 mmcblk0: p1 p2 p3
hda: HMS360404D5CF00, CFA DISK drive
ide0 at 0xc4840000-0xc4840007,0xc484000e on irq 202
hda: max request size: 128KiB
hda: 7999488 sectors (4095 MB) w/128KiB Cache, CHS=7936/16/63
hda: cache flushes supported
 hda: hda1 hda2 hda3
ide-cs: hda: Vpp = 0.0
kjournald starting.  Commit interval 5 seconds
EXT3-fs (mmcblk0p1): mounted filesystem with writeback data mode
VFS: Mounted root (ext3 filesystem) readonly on device 179:1.
devtmpfs: mounted
Freeing init memory: 88K
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
pxa27x_udc: version 2008-04-18
NET: Registered protocol family 23
usbcore: registered new device driver usb
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
ohci_hcd: block sizes: ed 64 td 64
In ohci_hcd_pxa27x_drv_probe
pxa27x-ohci pxa27x-ohci: PXA27x OHCI
drivers/usb/core/inode.c: creating file 'devices'
drivers/usb/core/inode.c: creating file '001'
pxa27x-ohci pxa27x-ohci: new USB bus registered, assigned bus number 1
pxa27x-ohci pxa27x-ohci: irq 3, io mem 0x4c000000
pxa27x-ohci pxa27x-ohci: ohci_pxa27x_start, ohci:c328cc94
pxa27x-ohci pxa27x-ohci: created debug files
pxa27x-ohci pxa27x-ohci: OHCI controller state
pxa27x-ohci pxa27x-ohci: OHCI 1.0, NO legacy support registers
pxa27x-ohci pxa27x-ohci: control 0x083 HCFS=operational CBSR=3
pxa27x-ohci pxa27x-ohci: cmdstatus 0x00000 SOC=0
pxa27x-ohci pxa27x-ohci: intrstatus 0x00000004 SF
pxa27x-ohci pxa27x-ohci: intrenable 0x8000005a MIE RHSC UE RD WDH
pxa27x-ohci pxa27x-ohci: hcca frame #0027
pxa27x-ohci pxa27x-ohci: roothub.a 04001202 POTPGT=4 NOCP NPS NDP=2(3)
pxa27x-ohci pxa27x-ohci: roothub.b 00000000 PPCM=0000 DR=0000
pxa27x-ohci pxa27x-ohci: roothub.status 00008000 DRWE
pxa27x-ohci pxa27x-ohci: roothub.portstatus [0] 0x00000100 PPS
pxa27x-ohci pxa27x-ohci: roothub.portstatus [1] 0x00000100 PPS
pxa27x-ohci pxa27x-ohci: roothub.portstatus [2] 0x00000100 PPS
usb usb1: default language 0x0409
usb usb1: udev 1, busnum 1, minor = 0
usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: PXA27x OHCI
usb usb1: Manufacturer: Linux 2.6.33 ohci_hcd
usb usb1: SerialNumber: pxa27x
usb usb1: uevent
usb usb1: usb_probe_device
usb usb1: configuration #1 chosen from 1 choice
usb usb1: adding 1-0:1.0 (config #1, interface 0)
usb 1-0:1.0: uevent
hub 1-0:1.0: usb_probe_interface
hub 1-0:1.0: usb_probe_interface - got id
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 3 ports detected
hub 1-0:1.0: standalone hub
hub 1-0:1.0: no power switching (usb 1.0)
hub 1-0:1.0: no over-current protection
hub 1-0:1.0: power on to power good time: 8ms
hub 1-0:1.0: 150mA bus power budget for each child
hub 1-0:1.0: local power source is good
hub 1-0:1.0: trying to enable port power on non-switchable hub
drivers/usb/core/inode.c: creating file '001'
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
lib80211: common routines for IEEE802.11 drivers
lib80211_crypt: registered algorithm 'NULL'
hostap_cs: setting Vcc=33 (constant)
Checking CFTABLE_ENTRY 0x01 (default 0x01)
IO window settings: cfg->io.nwin=1 dflt->io.nwin=1
io->flags = 0x0046, io.base=0x0000, len=64
hostap_cs: Registered netdevice wifi0
hostap_cs: index 0x01: , irq 201, io 0xc4820000-0xc482003f
prism2_hw_init: initialized in 870 ms
wifi0: NIC: id=0x800c v1.0.0
usb usb1: uevent
wifi0: PRI: id=0x15 v1.1.1
wifi0: STA: id=0x1f v1.8.2
wifi0: registered netdevice wlan0
kjournald starting.  Commit interval 5 seconds
EXT3-fs (mmcblk0p2): warning: mounting fs with errors, running e2fsck is recommended
EXT3-fs (mmcblk0p2): using internal journal
EXT3-fs (mmcblk0p2): mounted filesystem with writeback data mode
EXT3-fs (mmcblk0p1): warning: maximal mount count reached, running e2fsck is recommended
EXT3-fs (mmcblk0p1): using internal journal

.-------.                                           
|       |                  .-.                      
|   |   |-----.-----.-----.| |   .----..-----.-----.
|       |     | __  |  ---'| '--.|  .-'|     |     |
|   |   |  |  |     |---  ||  --'|  |  |  '  | | | |
'---'---'--'--'--.  |-----''----''--'  '-----'-'-'-'
                -'  |
                '---'

The Angstrom Distribution zjama ttyS0

Angstrom 2010.4-test-20100401 zjama ttyS0

zjama login: 


-- 
uin:136542059                jid:Martin.Jansa@gmail.com
Jansa Martin                 sip:jamasip@voip.wengo.fr 
JaMa                         

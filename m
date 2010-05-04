Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759875Ab0EDNGd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 09:06:33 -0400
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:40880 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751791Ab0EDNG3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 09:06:29 -0400
From: Linus WALLEIJ <linus.walleij@stericsson.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Dan Williams <dan.j.williams@intel.com>,
       Grant Likely <grant.likely@secretlab.ca>,
       "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
       "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
       STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 4 May 2010 15:05:51 +0200
Subject: RE: [PATCH 00/11] ARM: PrimeCell DMA Interface v5
Thread-Topic: [PATCH 00/11] ARM: PrimeCell DMA Interface v5
Thread-Index: Acrp0CL/1W5RfXinShWZyjunbGgURgBuaWAA
Message-ID: <CEE6BB42CAD6E947908279175AF8470A025A636C13@EXDCVYMBSTM006.EQ1STM.local>
References: <v2se9c3a7c21004071645u8180f4d7p3b4b1f96de11303e@mail.gmail.com>
 <CEE6BB42CAD6E947908279175AF8470A03A50F78@EXDCVYMBSTM006.EQ1STM.local>
 <t2qe9c3a7c21004141815x70ecf123p4364802681417da9@mail.gmail.com>
 <q2o63386a3d1004162158v296379fat2b376d5c4c087378@mail.gmail.com>
 <20100422110025.GC20008@n2100.arm.linux.org.uk>
 <g2qe9c3a7c21005011500l11511d43i12d971775b139c3b@mail.gmail.com>
 <20100501224429.GA17693@n2100.arm.linux.org.uk>
 <x2u63386a3d1005011604kaee33364l880e90a4e2453e0f@mail.gmail.com>
 <20100501232823.GB17693@n2100.arm.linux.org.uk>
 <r2u63386a3d1005011721v66d04172nc0e5163115006267@mail.gmail.com>
 <20100502081844.GA7061@n2100.arm.linux.org.uk>
In-Reply-To: <20100502081844.GA7061@n2100.arm.linux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latest patchset is now also tested on the ARM-RealView
PB11MPCore. My best friends over at Ericsson AB helped me
out by lending me their board for a short session.

See bootlog below...

- UART console comes up fine and is interactive
- MMCI card mounts and you can list and copy files

No DMA in use since the PL081 in this machine does not
have a driver yet, but no regressions in sight.

This should be similar to Versatile or Integrator.

Is this OK now Russell?

Yours,
Linus Walleij


Uncompressing Linux... done, booting the kernel.
Linux version 2.6.34-rc6-next-20100503-00033-gc482e92 (linus@fecusia) (gcc vers0
CPU: ARMv6-compatible processor [410fb020] revision 0 (ARMv7), cr=00c5387f
CPU: VIPT nonaliasing data cache, VIPT nonaliasing instruction cache
Machine: ARM-RealView PB11MPCore
Ignoring unrecognised tag 0x00000000
Memory policy: ECC disabled, Data cache writeback
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 32512
Kernel command line: root=/dev/nfs nfsroot=192.168.0.3:/export/rootfs/rootfs-ant
PID hash table entries: 512 (order: -1, 2048 bytes)
Dentry cache hash table entries: 16384 (order: 4, 65536 bytes)
Inode-cache hash table entries: 8192 (order: 3, 32768 bytes)
Memory: 128MB = 128MB total
Memory: 120360k/120360k available, 10712k reserved, 0K highmem
Virtual kernel memory layout:
    vector  : 0xffff0000 - 0xffff1000   (   4 kB)
    fixmap  : 0xfff00000 - 0xfffe0000   ( 896 kB)
    DMA     : 0xffc00000 - 0xffe00000   (   2 MB)
    vmalloc : 0xc8800000 - 0xf8000000   ( 760 MB)
    lowmem  : 0xc0000000 - 0xc8000000   ( 128 MB)
    modules : 0xbf000000 - 0xc0000000   (  16 MB)
      .init : 0xc0008000 - 0xc0672000   (6568 kB)
      .text : 0xc0672000 - 0xc0909000   (2652 kB)
      .data : 0xc0922000 - 0xc093d400   ( 109 kB)
Hierarchical RCU implementation.
NR_IRQS:128
Console: colour dummy device 80x30
Calibrating delay loop... 83.76 BogoMIPS (lpj=418816)
Mount-cache hash table entries: 512
CPU: Testing write buffer coherency: ok
NET: Registered protocol family 16
L2X0 cache controller enabled
Serial: AMBA PL011 UART driver
dev:uart0: ttyAMA0 at MMIO 0x10009000 (irq = 36) is a AMBA/PL011
console [ttyAMA0] enabled
dev:uart1: ttyAMA1 at MMIO 0x1000a000 (irq = 37) is a AMBA/PL011
dev:uart2: ttyAMA2 at MMIO 0x1000b000 (irq = 78) is a AMBA/PL011
fpga:uart3: ttyAMA3 at MMIO 0x1000c000 (irq = 79) is a AMBA/PL011
bio: create slab <bio-0> at 0
Advanced Linux Sound Architecture Driver Version 1.0.23.
Switching to clocksource timer3
NET: Registered protocol family 2
IP route cache hash table entries: 1024 (order: 0, 4096 bytes)
TCP established hash table entries: 4096 (order: 3, 32768 bytes)
TCP bind hash table entries: 4096 (order: 2, 16384 bytes)
TCP: Hash tables configured (established 4096 bind 4096)
TCP reno registered
UDP hash table entries: 256 (order: 0, 4096 bytes)
UDP-Lite hash table entries: 256 (order: 0, 4096 bytes)
NET: Registered protocol family 1
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
msgmni has been set to 235
io scheduler noop registered
io scheduler deadline registered (default)
CLCD: RealView hardware, XVGA display
Console: switching to colour frame buffer device 128x48
armflash.0-0: Found 2 x16 devices at 0x0 in 32-bit bank
 Intel/Sharp Extended Query Table at 0x010A
 Intel/Sharp Extended Query Table at 0x010A
 Intel/Sharp Extended Query Table at 0x010A
 Intel/Sharp Extended Query Table at 0x010A
 Intel/Sharp Extended Query Table at 0x010A
Using buffer write method
Using auto-unlock on power-up/resume
cfi_cmdset_0001: Erase suspend on write enabled
armflash.0-1: Found 2 x16 devices at 0x0 in 32-bit bank
 Intel/Sharp Extended Query Table at 0x010A
 Intel/Sharp Extended Query Table at 0x010A
 Intel/Sharp Extended Query Table at 0x010A
 Intel/Sharp Extended Query Table at 0x010A
 Intel/Sharp Extended Query Table at 0x010A
Using buffer write method
Using auto-unlock on power-up/resume
cfi_cmdset_0001: Erase suspend on write enabled
Concatenating MTD devices:
(0): "armflash.0-0"
(1): "armflash.0-1"
into device "armflash.0"
RedBoot partition parsing not available
afs partition parsing not available
smsc911x: Driver version 2008-10-21.
smsc911x-mdio: probed
eth0: attached PHY driver [SMSC LAN911x Internal PHY] (mii_bus:phy_addr=0:01, i)
net eth0: MAC Address: 00:02:f7:00:3a:80
mice: PS/2 mouse device common for all mice
mmci-pl18x fpga:mmc0: mmc0: MMCI/PL180 manf 41 rev 0 cfg 00 at 0x000000001000500
mmci-pl18x fpga:mmc0: IRQ 46, 47 (pio)
aaci-pl041 fpga:aaci: ARM AC'97 Interface at 0x0000000010004000, irq 32, fifo 52
ALSA device list:
  #0: ARM AC'97 Interface at 0x0000000010004000, irq 32
TCP cubic registered
NET: Registered protocol family 17
VFP support v0.3: implementor 41 architecture 1 part 20 variant b rev 3
mmc0: host does not support reading read-only switch. assuming write-enable.
mmc0: new SD card at address e624
mmcblk0: mmc0:e624 SU256 241 MiB
 mmcblk0: p1
net eth0: SMSC911x/921x identified at 0xc8880000, IRQ: 41
atkbd serio0: keyboard reset failed on fpga:kmi0
IP-Config: Complete:
     device=eth0, addr=192.168.0.4, mask=255.255.255.0, gw=192.168.0.1,
     host=arm11mpcore, domain=, nis-domain=(none),
     bootserver=192.168.0.3, rootserver=192.168.0.3, rootpath=
Warning: unable to open an initial console.
Freeing init memory: 6568K
input: AT Raw Set 2 keyboard as /class/input/input0

Please press Enter to activate this console.
starting pid 342, tty '/dev/ttyAMA0': '/bin/sh -sc ". /etc/profile"'
root@ME:/
root@ME:/

Yours,
Linus Walleij

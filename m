Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607Ab1AUIgL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 03:36:11 -0500
Received: from zfrontend1.aha.ru ([195.2.83.147]:52273 "EHLO aha.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753518Ab1AUIgJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 03:36:09 -0500
From: "werner" <w.landgraf@ru.ru>
Subject: 2.6.38-rc1 problems with khugepaged
To: akpm@linux-foundation.org, hannes@cmpxchg.org, aarcange@redhat.com,
        idryomov@gmail.com, rostedt@goodmis.org, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, torvalds@linux-foundation.org
X-Mailer: CommuniGate Pro WebUser Interface v.4.3.12
Date: Fri, 21 Jan 2011 04:36:04 -0400
Message-ID: <web-443943540@zbackend1.aha.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I tested it now again , including 2.6.38-rc1 -git1 , and 
the patch suggested here, and enable khugepaged in 
configure, as on the original post.

Now it's not longer hanging long time, as on my original 
report.

But now its hanging middle time.    The second half of 
booting, it becomes very, very slow,  the kde grafical 
system, what starts normally within seconds, take one 
minute, and on the text screens, after type in  >root 
  and then my password >fifi   , then it takes also about 
1 minute to log in, and everything is very very slow, so 
that I had to press the reset button to come out

so that khugepaged don't work correctly.


Howevern just now I'm recompiling the whole kernel 
including git1 but NOT the patch, and again disable 
khugepaged in configure,  first in order to check, if the 
problem isn't perhaps in anything else in -git1 but not in 
khugepaged, and second for get a working kernel. Alias, 
2.6.38-rc1 with disable khugepaged  is working normally.


Below the syslog of that failed attempt including -git1 
and enabling khugepaged, as explained above

W.Landgraf


===============================================
  Jan 21 04:07:16 werner kernel: Malformed early option 
'acpi'
Jan 21 04:07:16 werner kernel: ACPI: RSDP 000fb9f0 00024 
(v02 ACPIAM)
Jan 21 04:07:16 werner kernel: ACPI: XSDT affc0100 0004C 
(v01 A_M_I_ OEMXSDT  01000715 MSFT 00000097)
Jan 21 04:07:16 werner kernel: ACPI: FACP affc0290 000F4 
(v03 A_M_I_ OEMFACP  01000715 MSFT 00000097)
Jan 21 04:07:16 werner kernel: ACPI: DSDT affc0440 04DAE 
(v01  A0647 A0647000 00000000 INTL 02002026)
Jan 21 04:07:16 werner kernel: ACPI: FACS affce000 00040
Jan 21 04:07:16 werner kernel: ACPI: APIC affc0390 00070 
(v01 A_M_I_ OEMAPIC  01000715 MSFT 00000097)
Jan 21 04:07:16 werner kernel: ACPI: MCFG affc0400 0003C 
(v01 A_M_I_ OEMMCFG  01000715 MSFT 00000097)
Jan 21 04:07:16 werner kernel: ACPI: OEMB affce040 00060 
(v01 A_M_I_ AMI_OEM  01000715 MSFT 00000097)
Jan 21 04:07:16 werner kernel: ACPI: HPET affc51f0 00038 
(v01 A_M_I_ OEMHPET0 01000715 MSFT 00000097)
Jan 21 04:07:17 werner kernel: Zone PFN ranges:
Jan 21 04:07:17 werner kernel:   DMA      0x00000010 -> 
0x00001000
Jan 21 04:07:17 werner kernel:   Normal   0x00001000 -> 
0x000377fe
Jan 21 04:07:17 werner kernel:   HighMem  0x000377fe -> 
0x000affc0
Jan 21 04:07:17 werner kernel: Movable zone start PFN for 
each node
Jan 21 04:07:17 werner kernel: early_node_map[2] active 
PFN ranges
Jan 21 04:07:17 werner kernel:     0: 0x00000010 -> 
0x0000009f
Jan 21 04:07:17 werner kernel:     0: 0x00000100 -> 
0x000affc0
Jan 21 04:07:17 werner kernel: Built 1 zonelists in Zone 
order, mobility grouping on.  Total pages: 715087
Jan 21 04:07:17 werner kernel: Console: colour dummy 
device 80x25
Jan 21 04:07:17 werner kernel: Fast TSC calibration using 
PIT
Jan 21 04:07:17 werner kernel: Detected 2410.787 MHz 
processor.
Jan 21 04:07:17 werner kernel: Mount-cache hash table 
entries: 512
Jan 21 04:07:17 werner kernel: /proc/device-tree: can't 
find root
Jan 21 04:07:17 werner kernel: ACPI: setting ELCR to 0200 
(from 8c00)
Jan 21 04:07:17 werner kernel: AMD PMU driver.
Jan 21 04:07:17 werner kernel: bio: create slab <bio-0> at 
0
Jan 21 04:07:17 werner kernel: raid6: int32x1    613 MB/s
Jan 21 04:07:17 werner kernel: raid6: int32x2    832 MB/s
Jan 21 04:07:17 werner kernel: raid6: int32x4    710 MB/s
Jan 21 04:07:17 werner kernel: raid6: int32x8    550 MB/s
Jan 21 04:07:17 werner kernel: raid6: mmxx1     1937 MB/s
Jan 21 04:07:17 werner kernel: raid6: mmxx2     3398 MB/s
Jan 21 04:07:17 werner kernel: raid6: sse1x1    1886 MB/s
Jan 21 04:07:17 werner kernel: raid6: sse1x2    3171 MB/s
Jan 21 04:07:17 werner kernel: raid6: sse2x1    3218 MB/s
Jan 21 04:07:17 werner kernel: raid6: sse2x2    4304 MB/s
Jan 21 04:07:17 werner kernel: raid6: using algorithm 
sse2x2 (4304 MB/s)
Jan 21 04:07:17 werner kernel: ACPI: Executed 1 blocks of 
module-level executable AML code
Jan 21 04:07:17 werner kernel: mdacon: MDA with 8K of 
memory detected.
Jan 21 04:07:17 werner kernel: Console: switching consoles 
13-16 to MDA-2
Jan 21 04:07:17 werner kernel: microcode: microcode: CPU0: 
AMD CPU family 0xf not supported
Jan 21 04:07:17 werner kernel: highmem bounce pool size: 
64 pages
Jan 21 04:07:17 werner kernel: Dquot-cache hash table 
entries: 1024 (order 0, 4096 bytes)
Jan 21 04:07:17 werner kernel: DLM (built Jan 20 2011 
23:05:56) installed
Jan 21 04:07:17 werner kernel: EFS: 1.0a - 
http://aeschi.ch.eu.org/efs/
Jan 21 04:07:17 werner kernel: OCFS2 User DLM kernel 
interface loaded
Jan 21 04:07:17 werner kernel: GFS2 (built Jan 20 2011 
23:07:38) installed
Jan 21 04:07:17 werner kernel: acpiphp_ibm: 
ibm_acpiphp_init: acpi_walk_namespace failed
Jan 21 04:07:17 werner kernel: ACPI: PCI Interrupt Link 
[LMC9] enabled at IRQ 11
Jan 21 04:07:17 werner kernel: nvidiafb: CRTC0 analog 
found
Jan 21 04:07:17 werner kernel: nvidiafb: CRTC1 analog not 
found
Jan 21 04:07:17 werner kernel: i2c i2c-0: unable to read 
EDID block.
Jan 21 04:07:17 werner last message repeated 2 times
Jan 21 04:07:17 werner kernel: nvidiafb: EDID found from 
BUS2
Jan 21 04:07:17 werner kernel: nvidiafb: CRTC 0 appears to 
have a CRT attached
Jan 21 04:07:17 werner kernel: nvidiafb: Using CRT on CRTC 
0
Jan 21 04:07:17 werner kernel: Console: switching to 
colour frame buffer device 210x65
Jan 21 04:07:17 werner kernel: Could not find Carillo 
Ranch MCH device.
Jan 21 04:07:17 werner kernel: no IO addresses supplied
Jan 21 04:07:17 werner kernel: hgafb: probe of hgafb.0 
failed with error -22
Jan 21 04:07:17 werner kernel: uvesafb: failed to execute 
/sbin/v86d
Jan 21 04:07:17 werner kernel: uvesafb: make sure that the 
v86d helper is installed and executable
Jan 21 04:07:17 werner kernel: uvesafb: Getting VBE info 
block failed (eax=0x4f00, err=-2)
Jan 21 04:07:17 werner kernel: uvesafb: vbe_init() failed 
with -22
Jan 21 04:07:17 werner kernel: uvesafb: probe of uvesafb.0 
failed with error -22
Jan 21 04:07:17 werner kernel: vesafb: cannot reserve 
video memory at 0xc0000000
Jan 21 04:07:17 werner kernel: toshiba: not a supported 
Toshiba laptop
Jan 21 04:07:17 werner kernel: Compaq SMART2 Driver (v 
2.6.0)
Jan 21 04:07:17 werner kernel: i2c-core: driver [isl29003] 
using legacy suspend method
Jan 21 04:07:17 werner kernel: i2c-core: driver [isl29003] 
using legacy resume method
Jan 21 04:07:17 werner kernel: i2c-core: driver [adp5520] 
using legacy suspend method
Jan 21 04:07:17 werner kernel: i2c-core: driver [adp5520] 
using legacy resume method
Jan 21 04:07:17 werner kernel: Loading Adaptec I2O RAID: 
Version 2.4 Build 5go
Jan 21 04:07:17 werner kernel: scsi: <fdomain> Detection 
failed (no card)
Jan 21 04:07:17 werner kernel: NCR53c406a: no available 
ports found
Jan 21 04:07:17 werner kernel: Emulex LightPulse Fibre 
Channel SCSI driver 8.3.20
Jan 21 04:07:17 werner kernel: Copyright(c) 2004-2009 
Emulex.  All rights reserved.
Jan 21 04:07:17 werner kernel: Failed initialization of 
WD-7000 SCSI card!
Jan 21 04:07:17 werner kernel: GDT-HA: Storage RAID 
Controller Driver. Version: 3.05
Jan 21 04:07:17 werner kernel: 3ware Storage Controller 
device driver for Linux v1.26.02.003.
Jan 21 04:07:17 werner kernel: 3ware 9000 Storage 
Controller device driver for Linux v2.26.02.014.
Jan 21 04:07:17 werner kernel: imm: Version 2.05 (for 
Linux 2.4.0)
Jan 21 04:07:17 werner kernel: ACPI: PCI Interrupt Link 
[LSA0] enabled at IRQ 15
Jan 21 04:07:17 werner kernel: Error: Driver 
'pata_platform' is already registered, aborting...
Jan 21 04:07:17 werner kernel: mtdoops: mtd device 
(mtddev=name/number) must be supplied
Jan 21 04:07:17 werner kernel: physmap-flash.0: failed to 
claim resource 0
Jan 21 04:07:17 werner kernel: Failed to ioremap_nocache
Jan 21 04:07:17 werner last message repeated 2 times
Jan 21 04:07:17 werner kernel: SNAPGEAR: failed to 
ioremap() BOOTCS
Jan 21 04:07:17 werner kernel: Generic platform RAM MTD, 
(c) 2004 Simtec Electronics
Jan 21 04:07:17 werner kernel: [nandsim] warning: 
read_byte: unexpected data output cycle, state is 
STATE_READY return 0x0
Jan 21 04:07:17 werner last message repeated 5 times
Jan 21 04:07:17 werner kernel: flash size: 8 MiB
Jan 21 04:07:17 werner kernel: page size: 512 bytes
Jan 21 04:07:17 werner kernel: OOB area size: 16 bytes
Jan 21 04:07:17 werner kernel: sector size: 8 KiB
Jan 21 04:07:17 werner kernel: pages number: 16384
Jan 21 04:07:17 werner kernel: pages per sector: 16
Jan 21 04:07:17 werner kernel: bus width: 8
Jan 21 04:07:17 werner kernel: bits in sector size: 13
Jan 21 04:07:17 werner kernel: bits in page size: 9
Jan 21 04:07:17 werner kernel: bits in OOB size: 4
Jan 21 04:07:17 werner kernel: flash size with OOB: 8448 
KiB
Jan 21 04:07:17 werner kernel: page address bytes: 3
Jan 21 04:07:17 werner kernel: sector address bytes: 2
Jan 21 04:07:17 werner kernel: options: 0x62
Jan 21 04:07:17 werner kernel: onenand_wait: timeout! 
ctrl=0x0000 intr=0x0000
Jan 21 04:07:17 werner kernel: DE600: port 0x378 busy
Jan 21 04:07:17 werner kernel: paride: aten registered as 
protocol 0
Jan 21 04:07:17 werner kernel: paride: bpck registered as 
protocol 1
Jan 21 04:07:17 werner kernel: paride: comm registered as 
protocol 2
Jan 21 04:07:17 werner kernel: paride: dstr registered as 
protocol 3
Jan 21 04:07:17 werner kernel: paride: k951 registered as 
protocol 4
Jan 21 04:07:17 werner kernel: paride: k971 registered as 
protocol 5
Jan 21 04:07:17 werner kernel: paride: epat registered as 
protocol 6
Jan 21 04:07:17 werner kernel: paride: epia registered as 
protocol 7
Jan 21 04:07:17 werner kernel: paride: frpw registered as 
protocol 8
Jan 21 04:07:17 werner kernel: paride: friq registered as 
protocol 9
Jan 21 04:07:17 werner kernel: paride: fit2 registered as 
protocol 10
Jan 21 04:07:17 werner kernel: paride: fit3 registered as 
protocol 11
Jan 21 04:07:17 werner kernel: paride: on20 registered as 
protocol 12
Jan 21 04:07:17 werner kernel: paride: on26 registered as 
protocol 13
Jan 21 04:07:17 werner kernel: paride: ktti registered as 
protocol 14
Jan 21 04:07:17 werner kernel: paride: bpck6 registered as 
protocol 15
Jan 21 04:07:17 werner kernel: pd: pd version 1.05, major 
45, cluster 64, nice 0
Jan 21 04:07:17 werner kernel: pda: Autoprobe failed
Jan 21 04:07:17 werner kernel: pd: no valid drive found
Jan 21 04:07:17 werner kernel: pcd: pcd version 1.07, 
major 46, nice 0
Jan 21 04:07:17 werner kernel: pcd0: Autoprobe failed
Jan 21 04:07:17 werner kernel: pcd: No CD-ROM drive found
Jan 21 04:07:17 werner kernel: pf: pf version 1.04, major 
47, cluster 64, nice 0
Jan 21 04:07:17 werner kernel: pf: No ATAPI disk detected
Jan 21 04:07:17 werner kernel: pt: pt version 1.04, major 
96
Jan 21 04:07:17 werner kernel: sr0: scsi3-mmc drive: 
48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
Jan 21 04:07:17 werner kernel: pt0: Autoprobe failed
Jan 21 04:07:17 werner kernel: pt: No ATAPI tape drive 
detected
Jan 21 04:07:17 werner kernel: pg: pg version 1.02, major 
97
Jan 21 04:07:17 werner kernel: pga: Autoprobe failed
Jan 21 04:07:17 werner kernel: pg: No ATAPI device 
detected
Jan 21 04:07:17 werner kernel: ACPI: PCI Interrupt Link 
[LUB2] enabled at IRQ 10
Jan 21 04:07:17 werner kernel: ACPI: PCI Interrupt Link 
[LUB0] enabled at IRQ 11
Jan 21 04:07:17 werner kernel: i2c-core: driver [lm8323] 
using legacy suspend method
Jan 21 04:07:17 werner kernel: i2c-core: driver [lm8323] 
using legacy resume method
Jan 21 04:07:17 werner kernel: i2c-core: driver [max7359] 
using legacy suspend method
Jan 21 04:07:17 werner kernel: i2c-core: driver [max7359] 
using legacy resume method
Jan 21 04:07:17 werner kernel: i2c-core: driver 
[synaptics_i2c] using legacy suspend method
Jan 21 04:07:17 werner kernel: i2c-core: driver 
[synaptics_i2c] using legacy resume method
Jan 21 04:07:17 werner kernel: GTCO usb driver version: 
2.00.0006
Jan 21 04:07:17 werner kernel: EISA: Cannot allocate 
resource for mainboard
Jan 21 04:07:17 werner kernel: Cannot allocate resource 
for EISA slot 1
Jan 21 04:07:17 werner kernel: Cannot allocate resource 
for EISA slot 2
Jan 21 04:07:17 werner kernel: Cannot allocate resource 
for EISA slot 3
Jan 21 04:07:17 werner kernel: Cannot allocate resource 
for EISA slot 4
Jan 21 04:07:17 werner kernel: Cannot allocate resource 
for EISA slot 5
Jan 21 04:07:17 werner kernel: Cannot allocate resource 
for EISA slot 6
Jan 21 04:07:17 werner kernel: Cannot allocate resource 
for EISA slot 7
Jan 21 04:07:17 werner kernel: Cannot allocate resource 
for EISA slot 8
Jan 21 04:07:17 werner kernel: dell-wmi: No known WMI GUID 
found
Jan 21 04:07:17 werner kernel: This machine doesn't have 
MSI-hotkeys through WMI
Jan 21 04:07:17 werner kernel: [Firmware Bug]: 
powernow-k8: No PSB or ACPI _PSS objects
Jan 21 04:07:17 werner kernel: powernow-k8: Make sure that 
your BIOS is up to date and Cool'N'Quiet support is 
enabled in BIOS setup
Jan 21 04:07:17 werner kernel: usb 2-3: device descriptor 
read/64, error -62
Jan 21 04:07:17 werner last message repeated 3 times
Jan 21 04:07:17 werner kernel: VFS: Mounted root (ext3 
filesystem) readonly on device 8:1.
Jan 21 04:07:17 werner kernel: usb 2-3: device not 
accepting address 4, error -62
Jan 21 04:07:17 werner kernel: usb 2-3: device not 
accepting address 5, error -62
Jan 21 04:07:17 werner kernel: hub 2-0:1.0: unable to 
enumerate USB device on port 3
Jan 21 04:07:17 werner kernel: udevd (2446): 
/proc/2446/oom_adj is deprecated, please use 
/proc/2446/oom_score_adj instead.
Jan 21 04:07:17 werner kernel: ACPI: PCI Interrupt Link 
[LNEA] enabled at IRQ 11
Jan 21 04:07:17 werner kernel: k8temp 0000:00:18.3: 
Temperature readouts might be wrong - check erratum #141
Jan 21 04:07:17 werner kernel: ACPI: PCI Interrupt Link 
[LAZA] enabled at IRQ 11
Jan 21 04:07:17 werner kernel: ACPI: PCI Interrupt Link 
[LNKB] enabled at IRQ 11
Jan 21 04:07:17 werner kernel: usbvideo: module is from 
the staging directory, the quality is unknown, you have 
been warned.
Jan 21 04:07:17 werner kernel: rt2860sta: module is from 
the staging directory, the quality is unknown, you have 
been warned.
Jan 21 04:07:20 werner udevd[2446]: add_to_rules: unknown 
key 'MODALIAS' in /etc/udev/rules.d/80-eagle-usb.rules:1
Jan 21 04:07:20 werner udevd[2446]: add_to_rules: unknown 
key 'MODALIAS' in /etc/udev/rules.d/80-eagle-usb.rules:1
Jan 21 04:07:31 werner apcupsd[5034]: apcupsd FATAL ERROR 
in smartsetup.c at line 171 PANIC! Cannot communicate with 
UPS via serial port. Please make sure the port specified 
on the DEVICE directive is correct, and that your cable 
specification on the UPSCABLE directive is correct.
Jan 21 04:07:32 werner apcupsd[5034]: apcupsd error 
shutdown completed
Jan 21 04:08:03 werner hpijs[5331]: prnt/hpijs/hpijs.cpp 
614: unable to init hpijs server
Jan 21 04:08:06 werner udevd[2446]: add_to_rules: unknown 
key 'MODALIAS' in /etc/udev/rules.d/80-eagle-usb.rules:1
=======  here i pressed the reset buton
---
Professional hosting for everyone - http://www.host.ru

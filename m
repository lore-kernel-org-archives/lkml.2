Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932083Ab2DIARO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 20:17:14 -0400
Received: from zfrontend1.aha.ru ([195.2.83.147]:46526 "EHLO aha.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752160Ab2DIARM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 20:17:12 -0400
From: "werner" <w.landgraf@ru.ru>
Subject: 3.4-rc1 sticks-and-crashs
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
X-Mailer: CommuniGate Pro WebUser Interface v.4.3.12
Date: Sun, 08 Apr 2012 20:21:01 -0400
Message-ID: <web-722486207@zbackend1.aha.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-rc1 sticks and crashs

The problem continues also with 3.4-rc2  .   The computer 
boots and runs during hours normal, then suddenly 
everything sticks,
in a part of the cases the computer crashs.      The 
computer wasn't working hard, almost idle.

In the example below, at the end it didn't crash 
completely, but only kde3 .  However, then i rebooted 
(last line).

In 3.3 this didnt happen, thus, it's a regression.


Werner Landgraf





Apr  8 13:55:10 werner kernel: Malformed early option 
'acpi'
Apr  8 13:55:10 werner kernel: ACPI: RSDP 000f6920 00014 
(v00 GBT   )
Apr  8 13:55:10 werner kernel: ACPI: RSDT bfee3000 00038 
(v01 GBT    NVDAACPI 42302E31 NVDA 01010101)
Apr  8 13:55:10 werner kernel: ACPI: FACP bfee3040 00074 
(v01 GBT    NVDAACPI 42302E31 NVDA 01010101)
Apr  8 13:55:10 werner kernel: ACPI: DSDT bfee30c0 0469E 
(v01 GBT    NVDAACPI 00001000 MSFT 03000000)
Apr  8 13:55:10 werner kernel: ACPI: FACS bfee0000 00040
Apr  8 13:55:10 werner kernel: ACPI: SSDT bfee7880 0028A 
(v01 PTLTD  POWERNOW 00000001  LTP 00000001)
Apr  8 13:55:10 werner kernel: ACPI: HPET bfee7b40 00038 
(v01 GBT    NVDAACPI 42302E31 NVDA 00000098)
Apr  8 13:55:10 werner kernel: ACPI: MCFG bfee7b80 0003C 
(v01 GBT    NVDAACPI 42302E31 NVDA 01010101)
Apr  8 13:55:10 werner kernel: ACPI: APIC bfee7780 000D0 
(v01 GBT    NVDAACPI 42302E31 NVDA 01010101)
Apr  8 13:55:10 werner kernel: Zone PFN ranges:
Apr  8 13:55:10 werner kernel:   DMA      0x00000010 -> 
0x00001000
Apr  8 13:55:10 werner kernel:   Normal   0x00001000 -> 
0x000377fe
Apr  8 13:55:10 werner kernel:   HighMem  0x000377fe -> 
0x000bfee0
Apr  8 13:55:10 werner kernel: Movable zone start PFN for 
each node
Apr  8 13:55:10 werner kernel: Early memory PFN ranges
Apr  8 13:55:10 werner kernel:     0: 0x00000010 -> 
0x0000009f
Apr  8 13:55:10 werner kernel:     0: 0x00000100 -> 
0x000bfee0
Apr  8 13:55:13 werner udevd-event[9104]: run_program: 
exec of program '/etc/rc.d/rc.media-daemon' failed
Apr  8 13:55:13 werner kernel: Built 1 zonelists in Zone 
order, mobility grouping on.  Total pages: 779889
Apr  8 13:55:13 werner kernel: Fast TSC calibration using 
PIT
Apr  8 13:55:13 werner kernel: Detected 2511.428 MHz 
processor.
Apr  8 13:55:13 werner udevd-event[9099]: 
udev_rules_apply_format: unknown format variable 
'$modalias | grep -q eagle-usb || exit; while ! 
/sbin/eaglectrl -p 2>/dev/null | /bin/grep -q 
Post-firmware; do sleep 2; done; /sbin/eaglectrl -d''
Apr  8 13:55:13 werner kernel: ACPI: setting ELCR to 0200 
(from 0c20)
Apr  8 13:55:13 werner kernel: AMD PMU driver.
Apr  8 13:55:13 werner kernel: raid6: int32x1    945 MB/s
Apr  8 13:55:13 werner kernel: raid6: int32x2    933 MB/s
Apr  8 13:55:13 werner kernel: raid6: int32x4    933 MB/s
Apr  8 13:55:13 werner kernel: raid6: int32x8    613 MB/s
Apr  8 13:55:13 werner kernel: raid6: mmxx1     2035 MB/s
Apr  8 13:55:13 werner kernel: raid6: mmxx2     3582 MB/s
Apr  8 13:55:13 werner kernel: raid6: sse1x1    2023 MB/s
Apr  8 13:55:13 werner kernel: raid6: sse1x2    3496 MB/s
Apr  8 13:55:13 werner kernel: raid6: sse2x1    3445 MB/s
Apr  8 13:55:13 werner kernel: raid6: sse2x2    4582 MB/s
Apr  8 13:55:13 werner kernel: raid6: using algorithm 
sse2x2 (4582 MB/s)
Apr  8 13:55:13 werner kernel: Expanded resource reserved 
due to conflict with PCI Bus 0000:00
Apr  8 13:55:13 werner udevd-event[9098]: 
udev_rules_apply_format: unknown format variable 
'$modalias | grep -q eagle-usb || exit; while ! 
/sbin/eaglectrl -p 2>/dev/null | /bin/grep -q 
Post-firmware; do sleep 2; done; /sbin/eaglectrl -d''
Apr  8 13:55:13 werner kernel: mdacon: MDA with 8K of 
memory detected.
Apr  8 13:55:13 werner kernel: ACPI: PCI Interrupt Link 
[LUBA] enabled at IRQ 10
Apr  8 13:55:13 werner kernel: ACPI: PCI Interrupt Link 
[LUB2] enabled at IRQ 11
Apr  8 13:55:13 werner kernel: microcode: CPU0: family 15 
not supported
Apr  8 13:55:13 werner kernel: The force parameter has not 
been set to 1 so the Iris poweroff handler will not be 
installed.
Apr  8 13:55:13 werner kernel: highmem bounce pool size: 
64 pages
Apr  8 13:55:13 werner kernel: Dquot-cache hash table 
entries: 1024 (order 0, 4096 bytes)
Apr  8 13:55:13 werner kernel: DLM installed
Apr  8 13:55:13 werner kernel: EFS: 1.0a - 
http://aeschi.ch.eu.org/efs/
Apr  8 13:55:13 werner kernel: OCFS2 User DLM kernel 
interface loaded
Apr  8 13:55:13 werner kernel: GFS2 installed
Apr  8 13:55:13 werner kernel: acpiphp_ibm: 
ibm_acpiphp_init: acpi_walk_namespace failed
Apr  8 13:55:13 werner kernel: ACPI: PCI Interrupt Link 
[LIGP] enabled at IRQ 10
Apr  8 13:55:13 werner kernel: nvidiafb: CRTC0 analog 
found
Apr  8 13:55:13 werner kernel: nvidiafb: CRTC1 analog not 
found
Apr  8 13:55:13 werner kernel: i2c i2c-0: unable to read 
EDID block.
Apr  8 13:55:13 werner last message repeated 2 times
Apr  8 13:55:13 werner kernel: nvidiafb: EDID found from 
BUS2
Apr  8 13:55:13 werner kernel: nvidiafb: CRTC 0 appears to 
have a CRT attached
Apr  8 13:55:13 werner kernel: nvidiafb: Using CRT on CRTC 
0
Apr  8 13:55:13 werner kernel: Could not find Carillo 
Ranch MCH device.
Apr  8 13:55:13 werner kernel: no IO addresses supplied
Apr  8 13:55:13 werner kernel: hgafb: probe of hgafb.0 
failed with error -22
Apr  8 13:55:13 werner kernel: uvesafb: failed to execute 
/sbin/v86d
Apr  8 13:55:13 werner kernel: uvesafb: make sure that the 
v86d helper is installed and executable
Apr  8 13:55:13 werner kernel: uvesafb: Getting VBE info 
block failed (eax=0x4f00, err=-2)
Apr  8 13:55:13 werner kernel: uvesafb: vbe_init() failed 
with -22
Apr  8 13:55:13 werner kernel: uvesafb: probe of uvesafb.0 
failed with error -22
Apr  8 13:55:13 werner kernel: vesafb: cannot reserve 
video memory at 0xd0000000
Apr  8 13:55:13 werner kernel: toshiba: not a supported 
Toshiba laptop
Apr  8 13:55:13 werner kernel: [drm:i915_init] *ERROR* 
drm/i915 can't work without intel_agp module!
Apr  8 13:55:13 werner kernel: Compaq SMART2 Driver (v 
2.6.0)
Apr  8 13:55:13 werner kernel: i2c-core: driver [isl29003] 
using legacy suspend method
Apr  8 13:55:13 werner kernel: i2c-core: driver [isl29003] 
using legacy resume method
Apr  8 13:55:13 werner kernel: amd74xx 0000:00:06.0: BIOS 
didn't set cable bits correctly. Enabling workaround.
Apr  8 13:55:13 werner kernel: Loading Adaptec I2O RAID: 
Version 2.4 Build 5go
Apr  8 13:55:13 werner kernel: scsi: <fdomain> Detection 
failed (no card)
Apr  8 13:55:13 werner kernel: NCR53c406a: no available 
ports found
Apr  8 13:55:13 werner kernel: qla2xxx 
[0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driver: 
8.03.07.13-k.
Apr  8 13:55:13 werner kernel: Emulex LightPulse Fibre 
Channel SCSI driver 8.3.30
Apr  8 13:55:13 werner kernel: Copyright(c) 2004-2009 
Emulex.  All rights reserved.
Apr  8 13:55:13 werner kernel: Failed initialization of 
WD-7000 SCSI card!
Apr  8 13:55:13 werner kernel: GDT-HA: Storage RAID 
Controller Driver. Version: 3.05
Apr  8 13:55:13 werner kernel: 3ware Storage Controller 
device driver for Linux v1.26.02.003.
Apr  8 13:55:13 werner kernel: 3ware 9000 Storage 
Controller device driver for Linux v2.26.02.014.
Apr  8 13:55:13 werner kernel: imm: Version 2.05 (for 
Linux 2.4.0)
Apr  8 13:55:13 werner kernel: ACPI: PCI Interrupt Link 
[LSID] enabled at IRQ 11
Apr  8 13:55:13 werner kernel: ACPI: PCI Interrupt Link 
[LFID] enabled at IRQ 10
Apr  8 13:55:13 werner kernel: Error: Driver 
'pata_platform' is already registered, aborting...
Apr  8 13:55:13 werner kernel: physmap-flash.0: failed to 
claim resource 0
Apr  8 13:55:13 werner kernel: Failed to ioremap_nocache
Apr  8 13:55:13 werner last message repeated 2 times
Apr  8 13:55:13 werner kernel: SNAPGEAR: failed to 
ioremap() BOOTCS
Apr  8 13:55:13 werner kernel: Generic platform RAM MTD, 
(c) 2004 Simtec Electronics
Apr  8 13:55:13 werner kernel: [nandsim] warning: 
read_byte: unexpected data output cycle, state is 
STATE_READY return 0x0
Apr  8 13:55:13 werner last message repeated 5 times
Apr  8 13:55:13 werner kernel: flash size: 8 MiB
Apr  8 13:55:13 werner kernel: page size: 512 bytes
Apr  8 13:55:13 werner kernel: OOB area size: 16 bytes
Apr  8 13:55:13 werner kernel: sector size: 8 KiB
Apr  8 13:55:13 werner kernel: pages number: 16384
Apr  8 13:55:13 werner kernel: pages per sector: 16
Apr  8 13:55:13 werner kernel: bus width: 8
Apr  8 13:55:13 werner kernel: bits in sector size: 13
Apr  8 13:55:13 werner kernel: bits in page size: 9
Apr  8 13:55:13 werner kernel: bits in OOB size: 4
Apr  8 13:55:13 werner kernel: flash size with OOB: 8448 
KiB
Apr  8 13:55:13 werner kernel: page address bytes: 3
Apr  8 13:55:13 werner kernel: sector address bytes: 2
Apr  8 13:55:13 werner kernel: options: 0x62
Apr  8 13:55:13 werner kernel: onenand_wait: timeout! 
ctrl=0x0000 intr=0x0000
Apr  8 13:55:13 werner kernel: DE600: port 0x378 busy
Apr  8 13:55:13 werner kernel: paride: aten registered as 
protocol 0
Apr  8 13:55:13 werner kernel: paride: bpck registered as 
protocol 1
Apr  8 13:55:13 werner kernel: paride: comm registered as 
protocol 2
Apr  8 13:55:13 werner kernel: paride: dstr registered as 
protocol 3
Apr  8 13:55:13 werner kernel: paride: k951 registered as 
protocol 4
Apr  8 13:55:13 werner kernel: paride: k971 registered as 
protocol 5
Apr  8 13:55:13 werner kernel: paride: epat registered as 
protocol 6
Apr  8 13:55:13 werner kernel: paride: epia registered as 
protocol 7
Apr  8 13:55:13 werner kernel: paride: frpw registered as 
protocol 8
Apr  8 13:55:13 werner kernel: paride: friq registered as 
protocol 9
Apr  8 13:55:13 werner kernel: paride: fit2 registered as 
protocol 10
Apr  8 13:55:13 werner kernel: paride: fit3 registered as 
protocol 11
Apr  8 13:55:13 werner kernel: paride: on20 registered as 
protocol 12
Apr  8 13:55:13 werner kernel: paride: on26 registered as 
protocol 13
Apr  8 13:55:13 werner kernel: paride: ktti registered as 
protocol 14
Apr  8 13:55:13 werner kernel: paride: bpck6 registered as 
protocol 15
Apr  8 13:55:13 werner kernel: pd: pd version 1.05, major 
45, cluster 64, nice 0
Apr  8 13:55:13 werner kernel: pda: Autoprobe failed
Apr  8 13:55:13 werner kernel: pd: no valid drive found
Apr  8 13:55:13 werner kernel: pcd: pcd version 1.07, 
major 46, nice 0
Apr  8 13:55:13 werner kernel: pcd0: Autoprobe failed
Apr  8 13:55:13 werner kernel: pcd: No CD-ROM drive found
Apr  8 13:55:13 werner kernel: pf: pf version 1.04, major 
47, cluster 64, nice 0
Apr  8 13:55:13 werner kernel: pf: No ATAPI disk detected
Apr  8 13:55:13 werner kernel: pt: pt version 1.04, major 
96
Apr  8 13:55:13 werner kernel: sr0: scsi3-mmc drive: 
48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
Apr  8 13:55:13 werner kernel: pt0: Autoprobe failed
Apr  8 13:55:13 werner kernel: pt: No ATAPI tape drive 
detected
Apr  8 13:55:13 werner kernel: pg: pg version 1.02, major 
97
Apr  8 13:55:13 werner kernel: pga: Autoprobe failed
Apr  8 13:55:13 werner kernel: pg: No ATAPI device 
detected
Apr  8 13:55:13 werner kernel: mk712: device not present
Apr  8 13:55:13 werner kernel: wistron_btns: System 
unknown
Apr  8 13:55:13 werner kernel: EISA: Cannot allocate 
resource for mainboard
Apr  8 13:55:13 werner kernel: Cannot allocate resource 
for EISA slot 1
Apr  8 13:55:13 werner kernel: Cannot allocate resource 
for EISA slot 2
Apr  8 13:55:13 werner kernel: Cannot allocate resource 
for EISA slot 3
Apr  8 13:55:13 werner kernel: Cannot allocate resource 
for EISA slot 4
Apr  8 13:55:13 werner kernel: Cannot allocate resource 
for EISA slot 5
Apr  8 13:55:13 werner kernel: Cannot allocate resource 
for EISA slot 6
Apr  8 13:55:13 werner kernel: Cannot allocate resource 
for EISA slot 7
Apr  8 13:55:13 werner kernel: Cannot allocate resource 
for EISA slot 8
Apr  8 13:55:13 werner kernel: asus_wmi: Management GUID 
not found
Apr  8 13:55:13 werner kernel: asus_wmi: Management GUID 
not found
Apr  8 13:55:13 werner kernel: compal_laptop: Motherboard 
not recognized (You could try the module's 
force-parameter)
Apr  8 13:55:13 werner kernel: dell_wmi: No known WMI GUID 
found
Apr  8 13:55:13 werner kernel: dell_wmi_aio: No known WMI 
GUID found
Apr  8 13:55:13 werner kernel: acer_wmi: No or unsupported 
WMI interface, unable to load
Apr  8 13:55:13 werner kernel: acerhdf: unknown 
(unsupported) BIOS version Gigabyte Technology Co., 
Ltd./M68M-S2P/FC, please report, aborting!
Apr  8 13:55:13 werner kernel: hdaps: supported laptop not 
found!
Apr  8 13:55:13 werner kernel: hdaps: driver init failed 
(ret=-19)!
Apr  8 13:55:13 werner kernel: msi_wmi: This machine 
doesn't have MSI-hotkeys through WMI
Apr  8 13:55:13 werner kernel: intel_oaktrail: Platform 
not recognized (You could try the module's 
force-parameter)
Apr  8 13:55:13 werner kernel: OK
Apr  8 13:55:13 werner kernel: OK
Apr  8 13:55:13 werner kernel: register_blkdev: cannot get 
major 3 for hd
Apr  8 13:55:13 werner kernel: drivers/rtc/hctosys.c: 
unable to open rtc device (rtc0)
Apr  8 13:55:13 werner kernel: udevd (5372): 
/proc/5372/oom_adj is deprecated, please use 
/proc/5372/oom_score_adj instead.
Apr  8 13:55:13 werner kernel: end_request: I/O error, dev 
fd0, sector 0
Apr  8 13:55:13 werner kernel: ACPI: PCI Interrupt Link 
[LMAC] enabled at IRQ 11
Apr  8 13:55:13 werner kernel: ACPI: PCI Interrupt Link 
[LAZA] enabled at IRQ 5
Apr  8 13:55:13 werner kernel: ACPI: PCI Interrupt Link 
[LNK2] enabled at IRQ 5
Apr  8 13:55:13 werner kernel: 2:3:1: cannot get freq at 
ep 0x84
Apr  8 13:55:13 werner kernel: k8temp 0000:00:18.3: 
Temperature readouts might be wrong - check erratum #141
Apr  8 13:55:13 werner kernel: EXT3-fs (sda1): warning: 
maximal mount count reached, running e2fsck is recommended
Apr  8 13:55:22 werner apcupsd[9080]: apcupsd FATAL ERROR 
in smartsetup.c at line 171 PANIC! Cannot communicate with 
UPS via serial port. Please make sure the port specified 
on the DEVICE directive is correct, and that your cable 
specification on the UPSCABLE directive is correct.
Apr  8 13:55:22 werner apcupsd[9080]: apcupsd error 
shutdown completed
Apr  8 13:55:30 werner hpijs[9358]: prnt/hpijs/hpijs.cpp 
614: unable to init hpijs server
Apr  8 13:55:35 werner udevd[5372]: add_to_rules: unknown 
key 'MODALIAS' in /etc/udev/rules.d/80-eagle-usb.rules:1
Apr  8 13:56:03 werner kdm_greet[9504]: Can't open default 
user face
Apr  8 13:57:37 werner named[10001]: /etc/named.conf:3: 
option 'multiple-cnames' is obsolete
Apr  8 20:29:10 werner kernel: iwconfig invoked 
oom-killer: gfp_mask=0x800d0, order=0, oom_adj=0, 
oom_score_adj=0
Apr  8 20:29:11 werner kernel: Pid: 31155, comm: iwconfig 
Not tainted 3.4.0-rc2-i486-1sys #1
Apr  8 20:29:11 werner kernel: Call Trace:
Apr  8 20:29:11 werner kernel:  [<c10356ff>] ? 
printk+0x20/0x22
Apr  8 20:29:11 werner kernel:  [<c10af32b>] 
dump_header+0x6f/0x95
Apr  8 20:29:11 werner kernel:  [<c10af53f>] 
oom_kill_process+0x52/0x251
Apr  8 20:29:11 werner kernel:  [<c10af803>] ? 
select_bad_process+0xc5/0x11c
Apr  8 20:29:11 werner kernel:  [<c10af99e>] 
out_of_memory+0x144/0x1b4
Apr  8 20:29:11 werner kernel:  [<c10b269c>] 
__alloc_pages_nodemask+0x501/0x63f
Apr  8 20:29:11 werner kernel:  [<c10b27f6>] 
__get_free_pages+0x1c/0x2d
Apr  8 20:29:11 werner kernel:  [<c113197d>] 
do_proc_readlink+0x27/0x7b
Apr  8 20:29:11 werner kernel:  [<c1133367>] 
proc_pid_readlink+0x48/0x5b
Apr  8 20:29:11 werner kernel:  [<c10ee9c2>] 
sys_readlinkat+0x81/0x95
Apr  8 20:29:11 werner kernel:  [<c10eea02>] 
sys_readlink+0x2c/0x2e
Apr  8 20:29:11 werner kernel:  [<c208c05c>] 
syscall_call+0x7/0xb
Apr  8 20:29:11 werner kernel: Mem-Info:
Apr  8 20:29:11 werner kernel: DMA per-cpu:
Apr  8 20:29:11 werner kernel: CPU    0: hi:    0, btch: 
  1 usd:   0
Apr  8 20:29:11 werner kernel: Normal per-cpu:
Apr  8 20:29:11 werner kernel: CPU    0: hi:  186, btch: 
 31 usd:  89
Apr  8 20:29:11 werner kernel: HighMem per-cpu:
Apr  8 20:29:11 werner kernel: CPU    0: hi:  186, btch: 
 31 usd:  87
Apr  8 20:29:11 werner kernel: active_anon:80153 
inactive_anon:71 isolated_anon:0
Apr  8 20:29:11 werner kernel:  active_file:15189 
inactive_file:21520 isolated_file:0
Apr  8 20:29:11 werner kernel:  unevictable:0 dirty:1 
writeback:0 unstable:0
Apr  8 20:29:11 werner kernel:  free:445370 
slab_reclaimable:3273 slab_unreclaimable:37492
Apr  8 20:29:11 werner kernel:  mapped:19922 shmem:711 
pagetables:597 bounce:0
Apr  8 20:29:11 werner kernel: DMA free:4240kB min:784kB 
low:980kB high:1176kB active_anon:0kB inactive_anon:0kB 
active_file:0kB inactive_file:0kB unevictable:0kB 
isolated(anon):0kB isolated(file):0kB present:15804kB 
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB 
slab_reclaimable:24kB slab_unreclaimable:2184kB 
kernel_stack:9392kB pagetables:0kB unstable:0kB bounce:0kB 
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
Apr  8 20:29:11 werner kernel: lowmem_reserve[]: 0 865 
3031 3031
Apr  8 20:29:11 werner kernel: Normal free:44004kB 
min:44012kB low:55012kB high:66016kB active_anon:0kB 
inactive_anon:0kB active_file:132kB inactive_file:140kB 
unevictable:0kB isolated(anon):0kB isolated(file):0kB 
present:885944kB mlocked:0kB dirty:0kB writeback:0kB 
mapped:0kB shmem:0kB slab_reclaimable:13068kB 
slab_unreclaimable:147784kB kernel_stack:628952kB 
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB 
pages_scanned:1376 all_unreclaimable? yes
Apr  8 20:29:11 werner kdm[9483]: X server for display :0 
terminated unexpectedly
Apr  8 20:29:11 werner kernel: lowmem_reserve[]: 0 0 17326 
17326
Apr  8 20:29:11 werner kernel: HighMem free:1733236kB 
min:512kB low:28056kB high:55600kB active_anon:320612kB 
inactive_anon:284kB active_file:60624kB 
inactive_file:85940kB unevictable:0kB isolated(anon):0kB 
isolated(file):0kB present:2217808kB mlocked:0kB dirty:4kB 
writeback:0kB mapped:79688kB shmem:2844kB 
slab_reclaimable:0kB slab_unreclaimable:0kB 
kernel_stack:0kB pagetables:2388kB unstable:0kB bounce:0kB 
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
Apr  8 20:29:11 werner kernel: lowmem_reserve[]: 0 0 0 0
Apr  8 20:29:11 werner kernel: DMA: 116*4kB 18*8kB 1*16kB 
1*32kB 0*64kB 0*128kB 0*256kB 1*512kB 1*1024kB 1*2048kB 
0*4096kB = 4240kB
Apr  8 20:29:11 werner kernel: Normal: 1527*4kB 535*8kB 
279*16kB 177*32kB 65*64kB 23*128kB 6*256kB 3*512kB 
1*1024kB 0*2048kB 3*4096kB = 44004kB
Apr  8 20:29:11 werner kernel: HighMem: 6291*4kB 5495*8kB 
3815*16kB 2528*32kB 1406*64kB 597*128kB 228*256kB 
104*512kB 63*1024kB 18*2048kB 279*4096kB = 1733236kB
Apr  8 20:29:11 werner kernel: 37420 total pagecache pages
Apr  8 20:29:11 werner kernel: 0 pages in swap cache
Apr  8 20:29:11 werner kernel: Swap cache stats: add 0, 
delete 0, find 0/0
Apr  8 20:29:11 werner kernel: Free swap  = 0kB
Apr  8 20:29:11 werner kernel: Total swap = 0kB
Apr  8 20:29:11 werner kernel: 786128 pages RAM
Apr  8 20:29:11 werner kernel: 558818 pages HighMem
Apr  8 20:29:11 werner kernel: 13582 pages reserved
Apr  8 20:29:11 werner kernel: 109538 pages shared
Apr  8 20:29:11 werner kernel: 223297 pages non-shared
Apr  8 20:29:11 werner kernel: Out of memory: Kill process 
9499 (X) score 29 or sacrifice child
Apr  8 20:29:11 werner kernel: Killed process 9499 (X) 
total-vm:451020kB, anon-rss:178420kB, file-rss:3668kB
Apr  8 20:29:12 werner kernel: iwconfig invoked 
oom-killer: gfp_mask=0x800d0, order=0, oom_adj=0, 
oom_score_adj=0
Apr  8 20:29:12 werner kernel: Pid: 31155, comm: iwconfig 
Not tainted 3.4.0-rc2-i486-1sys #1
Apr  8 20:29:12 werner kernel: Call Trace:
Apr  8 20:29:12 werner kernel:  [<c10356ff>] ? 
printk+0x20/0x22
Apr  8 20:29:12 werner kernel:  [<c10af32b>] 
dump_header+0x6f/0x95
Apr  8 20:29:12 werner kernel:  [<c10af53f>] 
oom_kill_process+0x52/0x251
Apr  8 20:29:13 werner kernel:  [<c10af803>] ? 
select_bad_process+0xc5/0x11c
Apr  8 20:29:13 werner kernel:  [<c10af99e>] 
out_of_memory+0x144/0x1b4
Apr  8 20:29:13 werner kernel:  [<c10b269c>] 
__alloc_pages_nodemask+0x501/0x63f
Apr  8 20:29:13 werner kernel:  [<c10b27f6>] 
__get_free_pages+0x1c/0x2d
Apr  8 20:29:13 werner kernel:  [<c113197d>] 
do_proc_readlink+0x27/0x7b
Apr  8 20:29:13 werner kernel:  [<c1133367>] 
proc_pid_readlink+0x48/0x5b
Apr  8 20:29:13 werner kernel:  [<c10ee9c2>] 
sys_readlinkat+0x81/0x95
Apr  8 20:29:13 werner kernel:  [<c10eea02>] 
sys_readlink+0x2c/0x2e
Apr  8 20:29:14 werner kernel:  [<c208c05c>] 
syscall_call+0x7/0xb
Apr  8 20:29:14 werner kernel: Mem-Info:
Apr  8 20:29:14 werner kernel: DMA per-cpu:
Apr  8 20:29:14 werner kernel: CPU    0: hi:    0, btch: 
  1 usd:   0
Apr  8 20:29:14 werner kernel: Normal per-cpu:
Apr  8 20:29:14 werner kernel: CPU    0: hi:  186, btch: 
 31 usd:  95
Apr  8 20:29:14 werner kernel: HighMem per-cpu:
Apr  8 20:29:14 werner kernel: CPU    0: hi:  186, btch: 
 31 usd: 154
Apr  8 20:29:14 werner kernel: active_anon:35273 
inactive_anon:32 isolated_anon:0
Apr  8 20:29:14 werner kernel:  active_file:15228 
inactive_file:21481 isolated_file:0
Apr  8 20:29:14 werner kernel:  unevictable:0 dirty:1 
writeback:0 unstable:0
Apr  8 20:29:14 werner kernel:  free:490360 
slab_reclaimable:3273 slab_unreclaimable:37492
Apr  8 20:29:14 werner kernel:  mapped:19048 shmem:673 
pagetables:483 bounce:0
Apr  8 20:29:14 werner kernel: DMA free:4240kB min:784kB 
low:980kB high:1176kB active_anon:0kB inactive_anon:0kB 
active_file:0kB inactive_file:0kB unevictable:0kB 
isolated(anon):0kB isolated(file):0kB present:15804kB 
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB 
slab_reclaimable:24kB slab_unreclaimable:2184kB 
kernel_stack:9392kB pagetables:0kB unstable:0kB bounce:0kB 
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
Apr  8 20:29:14 werner kernel: lowmem_reserve[]: 0 865 
3031 3031
Apr  8 20:29:14 werner kernel: Normal free:44004kB 
min:44012kB low:55012kB high:66016kB active_anon:0kB 
inactive_anon:0kB active_file:132kB inactive_file:140kB 
unevictable:0kB isolated(anon):0kB isolated(file):0kB 
present:885944kB mlocked:0kB dirty:0kB writeback:0kB 
mapped:0kB shmem:0kB slab_reclaimable:13068kB 
slab_unreclaimable:147784kB kernel_stack:628952kB 
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB 
pages_scanned:13024 all_unreclaimable? yes
Apr  8 20:29:14 werner kernel: lowmem_reserve[]: 0 0 17326 
17326
Apr  8 20:29:14 werner kernel: HighMem free:1913196kB 
min:512kB low:28056kB high:55600kB active_anon:141092kB 
inactive_anon:128kB active_file:60780kB 
inactive_file:85784kB unevictable:0kB isolated(anon):0kB 
isolated(file):0kB present:2217808kB mlocked:0kB dirty:4kB 
writeback:0kB mapped:76192kB shmem:2692kB 
slab_reclaimable:0kB slab_unreclaimable:0kB 
kernel_stack:0kB pagetables:1932kB unstable:0kB bounce:0kB 
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
Apr  8 20:29:14 werner kernel: lowmem_reserve[]: 0 0 0 0
Apr  8 20:29:14 werner kernel: DMA: 116*4kB 18*8kB 1*16kB 
1*32kB 0*64kB 0*128kB 0*256kB 1*512kB 1*1024kB 1*2048kB 
0*4096kB = 4240kB
Apr  8 20:29:14 werner kernel: Normal: 1527*4kB 535*8kB 
279*16kB 177*32kB 65*64kB 23*128kB 6*256kB 3*512kB 
1*1024kB 0*2048kB 3*4096kB = 44004kB
Apr  8 20:29:14 werner kernel: HighMem: 6543*4kB 5584*8kB 
3849*16kB 2545*32kB 1418*64kB 609*128kB 235*256kB 
108*512kB 64*1024kB 21*2048kB 319*4096kB = 1913196kB
Apr  8 20:29:14 werner kernel: 37382 total pagecache pages
Apr  8 20:29:14 werner kernel: 0 pages in swap cache
Apr  8 20:29:14 werner kernel: Swap cache stats: add 0, 
delete 0, find 0/0
Apr  8 20:29:14 werner kernel: Free swap  = 0kB
Apr  8 20:29:14 werner kernel: Total swap = 0kB
Apr  8 20:29:14 werner kernel: 786128 pages RAM
Apr  8 20:29:14 werner kernel: 558818 pages HighMem
Apr  8 20:29:14 werner kernel: 13582 pages reserved
Apr  8 20:29:14 werner kernel: 104040 pages shared
Apr  8 20:29:14 werner kernel: 179138 pages non-shared
Apr  8 20:29:15 werner kernel: Out of memory: Kill process 
11073 (httpd) score 4 or sacrifice child
Apr  8 20:29:15 werner kernel: Killed process 11073 
(httpd) total-vm:56424kB, anon-rss:9136kB, file-rss:3784kB
Apr  8 20:29:15 werner kernel: iwconfig invoked 
oom-killer: gfp_mask=0x800d0, order=0, oom_adj=0, 
oom_score_adj=0
Apr  8 20:29:15 werner kernel: Pid: 31155, comm: iwconfig 
Not tainted 3.4.0-rc2-i486-1sys #1
Apr  8 20:29:15 werner kernel: Call Trace:
Apr  8 20:29:15 werner kernel:  [<c10356ff>] ? 
printk+0x20/0x22
Apr  8 20:29:15 werner kernel:  [<c10af32b>] 
dump_header+0x6f/0x95
Apr  8 20:29:15 werner kernel:  [<c10af53f>] 
oom_kill_process+0x52/0x251
Apr  8 20:29:15 werner kernel:  [<c10af803>] ? 
select_bad_process+0xc5/0x11c
Apr  8 20:29:15 werner kernel:  [<c10af99e>] 
out_of_memory+0x144/0x1b4
Apr  8 20:29:15 werner kernel:  [<c10b269c>] 
__alloc_pages_nodemask+0x501/0x63f
Apr  8 20:29:15 werner kernel:  [<c10b27f6>] 
__get_free_pages+0x1c/0x2d
Apr  8 20:29:15 werner kernel:  [<c113197d>] 
do_proc_readlink+0x27/0x7b
Apr  8 20:29:15 werner kernel:  [<c1133367>] 
proc_pid_readlink+0x48/0x5b
Apr  8 20:29:15 werner kernel:  [<c10ee9c2>] 
sys_readlinkat+0x81/0x95
Apr  8 20:29:15 werner kernel:  [<c10eea02>] 
sys_readlink+0x2c/0x2e
Apr  8 20:29:15 werner kernel:  [<c208c05c>] 
syscall_call+0x7/0xb
Apr  8 20:29:15 werner kernel: Mem-Info:
Apr  8 20:29:15 werner kernel: DMA per-cpu:
Apr  8 20:29:15 werner kernel: CPU    0: hi:    0, btch: 
  1 usd:   0
Apr  8 20:29:15 werner kernel: Normal per-cpu:
Apr  8 20:29:15 werner kernel: CPU    0: hi:  186, btch: 
 31 usd:  97
Apr  8 20:29:15 werner kernel: HighMem per-cpu:
Apr  8 20:29:15 werner kernel: CPU    0: hi:  186, btch: 
 31 usd: 169
Apr  8 20:29:15 werner kernel: active_anon:34116 
inactive_anon:32 isolated_anon:0
Apr  8 20:29:15 werner kernel:  active_file:15397 
inactive_file:21312 isolated_file:0
Apr  8 20:29:15 werner kernel:  unevictable:0 dirty:1 
writeback:0 unstable:0
Apr  8 20:29:15 werner kernel:  free:491507 
slab_reclaimable:3273 slab_unreclaimable:37492
Apr  8 20:29:15 werner kernel:  mapped:19048 shmem:673 
pagetables:464 bounce:0
Apr  8 20:29:15 werner kernel: DMA free:4240kB min:784kB 
low:980kB high:1176kB active_anon:0kB inactive_anon:0kB 
active_file:0kB inactive_file:0kB unevictable:0kB 
isolated(anon):0kB isolated(file):0kB present:15804kB 
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB 
slab_reclaimable:24kB slab_unreclaimable:2184kB 
kernel_stack:9392kB pagetables:0kB unstable:0kB bounce:0kB 
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
Apr  8 20:29:15 werner kernel: lowmem_reserve[]: 0 865 
3031 3031
Apr  8 20:29:15 werner kernel: Normal free:44004kB 
min:44012kB low:55012kB high:66016kB active_anon:0kB 
inactive_anon:0kB active_file:132kB inactive_file:140kB 
unevictable:0kB isolated(anon):0kB isolated(file):0kB 
present:885944kB mlocked:0kB dirty:0kB writeback:0kB 
mapped:0kB shmem:0kB slab_reclaimable:13068kB 
slab_unreclaimable:147784kB kernel_stack:628952kB 
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB 
pages_scanned:15584 all_unreclaimable? yes
Apr  8 20:29:15 werner kernel: lowmem_reserve[]: 0 0 17326 
17326
Apr  8 20:29:15 werner kernel: HighMem free:1917784kB 
min:512kB low:28056kB high:55600kB active_anon:136464kB 
inactive_anon:128kB active_file:61456kB 
inactive_file:85108kB unevictable:0kB isolated(anon):0kB 
isolated(file):0kB present:2217808kB mlocked:0kB dirty:4kB 
writeback:0kB mapped:76192kB shmem:2692kB 
slab_reclaimable:0kB slab_unreclaimable:0kB 
kernel_stack:0kB pagetables:1856kB unstable:0kB bounce:0kB 
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
Apr  8 20:29:15 werner kernel: lowmem_reserve[]: 0 0 0 0
Apr  8 20:29:15 werner kernel: DMA: 116*4kB 18*8kB 1*16kB 
1*32kB 0*64kB 0*128kB 0*256kB 1*512kB 1*1024kB 1*2048kB 
0*4096kB = 4240kB
Apr  8 20:29:15 werner kernel: Normal: 1527*4kB 535*8kB 
279*16kB 177*32kB 65*64kB 23*128kB 6*256kB 3*512kB 
1*1024kB 0*2048kB 3*4096kB = 44004kB
Apr  8 20:29:15 werner kernel: HighMem: 6650*4kB 5596*8kB 
3885*16kB 2556*32kB 1443*64kB 617*128kB 237*256kB 
108*512kB 64*1024kB 21*2048kB 319*4096kB = 1917784kB
Apr  8 20:29:15 werner kernel: 37382 total pagecache pages
Apr  8 20:29:15 werner kernel: 0 pages in swap cache
Apr  8 20:29:15 werner kernel: Swap cache stats: add 0, 
delete 0, find 0/0
Apr  8 20:29:15 werner kernel: Free swap  = 0kB
Apr  8 20:29:15 werner kernel: Total swap = 0kB
Apr  8 20:29:15 werner kernel: 786128 pages RAM
Apr  8 20:29:15 werner kernel: 558818 pages HighMem
Apr  8 20:29:15 werner kernel: 13582 pages reserved
Apr  8 20:29:15 werner kernel: 101963 pages shared
Apr  8 20:29:15 werner kernel: 177974 pages non-shared
Apr  8 20:29:16 werner kernel: Out of memory: Kill process 
10001 (named) score 3 or sacrifice child
Apr  8 20:29:16 werner kernel: Killed process 10001 
(named) total-vm:41360kB, anon-rss:9828kB, file-rss:2452kB
Apr  8 20:29:16 werner kernel: iwconfig invoked 
oom-killer: gfp_mask=0x800d0, order=0, oom_adj=0, 
oom_score_adj=0
Apr  8 20:29:16 werner kernel: Pid: 31155, comm: iwconfig 
Not tainted 3.4.0-rc2-i486-1sys #1
Apr  8 20:29:16 werner kernel: Call Trace:
Apr  8 20:29:16 werner kernel:  [<c10356ff>] ? 
printk+0x20/0x22
Apr  8 20:29:16 werner kernel:  [<c10af32b>] 
dump_header+0x6f/0x95
Apr  8 20:29:16 werner kernel:  [<c10af53f>] 
oom_kill_process+0x52/0x251
Apr  8 20:29:16 werner kernel:  [<c10af803>] ? 
select_bad_process+0xc5/0x11c
Apr  8 20:29:16 werner kernel:  [<c10af99e>] 
out_of_memory+0x144/0x1b4
Apr  8 20:29:16 werner kernel:  [<c10b269c>] 
__alloc_pages_nodemask+0x501/0x63f
Apr  8 20:29:16 werner kernel:  [<c10b27f6>] 
__get_free_pages+0x1c/0x2d
Apr  8 20:29:16 werner kernel:  [<c113197d>] 
do_proc_readlink+0x27/0x7b
Apr  8 20:29:16 werner kernel:  [<c1133367>] 
proc_pid_readlink+0x48/0x5b
Apr  8 20:29:16 werner kernel:  [<c10ee9c2>] 
sys_readlinkat+0x81/0x95
Apr  8 20:29:16 werner kernel:  [<c10eea02>] 
sys_readlink+0x2c/0x2e
Apr  8 20:29:16 werner kernel:  [<c208c05c>] 
syscall_call+0x7/0xb
Apr  8 20:29:16 werner kernel: Mem-Info:
Apr  8 20:29:16 werner kernel: DMA per-cpu:
Apr  8 20:29:16 werner kernel: CPU    0: hi:    0, btch: 
  1 usd:   0
Apr  8 20:29:16 werner kernel: Normal per-cpu:
Apr  8 20:29:16 werner kernel: CPU    0: hi:  186, btch: 
 31 usd:  97
Apr  8 20:29:16 werner kernel: HighMem per-cpu:
Apr  8 20:29:16 werner kernel: CPU    0: hi:  186, btch: 
 31 usd: 169
Apr  8 20:29:16 werner kernel: active_anon:34116 
inactive_anon:32 isolated_anon:0
Apr  8 20:29:16 werner kernel:  active_file:15397 
inactive_file:21312 isolated_file:0
Apr  8 20:29:16 werner kernel:  unevictable:0 dirty:1 
writeback:0 unstable:0
Apr  8 20:29:16 werner kernel:  free:491507 
slab_reclaimable:3273 slab_unreclaimable:37492
Apr  8 20:29:16 werner kernel:  mapped:19048 shmem:673 
pagetables:464 bounce:0
Apr  8 20:29:16 werner kernel: DMA free:4240kB min:784kB 
low:980kB high:1176kB active_anon:0kB inactive_anon:0kB 
active_file:0kB inactive_file:0kB unevictable:0kB 
isolated(anon):0kB isolated(file):0kB present:15804kB 
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB 
slab_reclaimable:24kB slab_unreclaimable:2184kB 
kernel_stack:9392kB pagetables:0kB unstable:0kB bounce:0kB 
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
Apr  8 20:29:16 werner kernel: lowmem_reserve[]: 0 865 
3031 3031
Apr  8 20:29:16 werner kernel: Normal free:44004kB 
min:44012kB low:55012kB high:66016kB active_anon:0kB 
inactive_anon:0kB active_file:132kB inactive_file:140kB 
unevictable:0kB isolated(anon):0kB isolated(file):0kB 
present:885944kB mlocked:0kB dirty:0kB writeback:0kB 
mapped:0kB shmem:0kB slab_reclaimable:13068kB 
slab_unreclaimable:147784kB kernel_stack:628952kB 
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB 
pages_scanned:15840 all_unreclaimable? yes
Apr  8 20:29:16 werner kernel: lowmem_reserve[]: 0 0 17326 
17326
Apr  8 20:29:16 werner kernel: HighMem free:1917784kB 
min:512kB low:28056kB high:55600kB active_anon:136464kB 
inactive_anon:128kB active_file:61456kB 
inactive_file:85108kB unevictable:0kB isolated(anon):0kB 
isolated(file):0kB present:2217808kB mlocked:0kB dirty:4kB 
writeback:0kB mapped:76192kB shmem:2692kB 
slab_reclaimable:0kB slab_unreclaimable:0kB 
kernel_stack:0kB pagetables:1856kB unstable:0kB bounce:0kB 
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
Apr  8 20:29:16 werner kernel: lowmem_reserve[]: 0 0 0 0
Apr  8 20:29:16 werner kernel: DMA: 116*4kB 18*8kB 1*16kB 
1*32kB 0*64kB 0*128kB 0*256kB 1*512kB 1*1024kB 1*2048kB 
0*4096kB = 4240kB
Apr  8 20:29:16 werner kernel: Normal: 1527*4kB 535*8kB 
279*16kB 177*32kB 65*64kB 23*128kB 6*256kB 3*512kB 
1*1024kB 0*2048kB 3*4096kB = 44004kB
Apr  8 20:29:16 werner kernel: HighMem: 6650*4kB 5596*8kB 
3885*16kB 2556*32kB 1443*64kB 617*128kB 237*256kB 
108*512kB 64*1024kB 21*2048kB 319*4096kB = 1917784kB
Apr  8 20:29:16 werner kernel: 37382 total pagecache pages
Apr  8 20:29:16 werner kernel: 0 pages in swap cache
Apr  8 20:29:16 werner kernel: Swap cache stats: add 0, 
delete 0, find 0/0
Apr  8 20:29:16 werner kernel: Free swap  = 0kB
Apr  8 20:29:16 werner kernel: Total swap = 0kB
Apr  8 20:29:16 werner kernel: 786128 pages RAM
Apr  8 20:29:16 werner kernel: 558818 pages HighMem
Apr  8 20:29:16 werner kernel: 13582 pages reserved
Apr  8 20:29:16 werner kernel: 101963 pages shared
Apr  8 20:29:16 werner kernel: 177974 pages non-shared
Apr  8 20:29:17 werner kernel: Out of memory: Kill process 
10002 (named) score 4 or sacrifice child
Apr  8 20:29:17 werner kernel: Killed process 10002 
(named) total-vm:41360kB, anon-rss:9920kB, file-rss:2540kB
Apr  8 20:29:17 werner kernel: iwconfig invoked 
oom-killer: gfp_mask=0x800d0, order=0, oom_adj=0, 
oom_score_adj=0
Apr  8 20:29:17 werner kernel: Pid: 31155, comm: iwconfig 
Not tainted 3.4.0-rc2-i486-1sys #1
Apr  8 20:29:17 werner kernel: Call Trace:
Apr  8 20:29:17 werner kernel:  [<c10356ff>] ? 
printk+0x20/0x22
Apr  8 20:29:17 werner kernel:  [<c10af32b>] 
dump_header+0x6f/0x95
Apr  8 20:29:17 werner kernel:  [<c10af53f>] 
oom_kill_process+0x52/0x251
Apr  8 20:29:17 werner kernel:  [<c10af803>] ? 
select_bad_process+0xc5/0x11c
Apr  8 20:29:17 werner kernel:  [<c10af99e>] 
out_of_memory+0x144/0x1b4
Apr  8 20:29:17 werner kernel:  [<c10b269c>] 
__alloc_pages_nodemask+0x501/0x63f
Apr  8 20:29:17 werner kernel:  [<c10b27f6>] 
__get_free_pages+0x1c/0x2d
Apr  8 20:29:17 werner kernel:  [<c113197d>] 
do_proc_readlink+0x27/0x7b
Apr  8 20:29:17 werner kernel:  [<c1133367>] 
proc_pid_readlink+0x48/0x5b
Apr  8 20:29:17 werner kernel:  [<c10ee9c2>] 
sys_readlinkat+0x81/0x95
Apr  8 20:29:17 werner kernel:  [<c10eea02>] 
sys_readlink+0x2c/0x2e
Apr  8 20:29:17 werner kernel:  [<c208c05c>] 
syscall_call+0x7/0xb
Apr  8 20:29:17 werner kernel: Mem-Info:
Apr  8 20:29:17 werner kernel: DMA per-cpu:
Apr  8 20:29:17 werner kernel: CPU    0: hi:    0, btch: 
  1 usd:   0
Apr  8 20:29:17 werner kernel: Normal per-cpu:
Apr  8 20:29:17 werner kernel: CPU    0: hi:  186, btch: 
 31 usd: 102
Apr  8 20:29:17 werner kernel: HighMem per-cpu:
Apr  8 20:29:17 werner kernel: CPU    0: hi:  186, btch: 
 31 usd: 161
Apr  8 20:29:17 werner kernel: active_anon:31596 
inactive_anon:32 isolated_anon:0
Apr  8 20:29:17 werner kernel:  active_file:15449 
inactive_file:21260 isolated_file:0
Apr  8 20:29:17 werner kernel:  unevictable:0 dirty:1 
writeback:0 unstable:0
Apr  8 20:29:17 werner kernel:  free:494050 
slab_reclaimable:3273 slab_unreclaimable:37492
Apr  8 20:29:17 werner kernel:  mapped:18630 shmem:673 
pagetables:464 bounce:0
Apr  8 20:29:17 werner kernel: DMA free:4240kB min:784kB 
low:980kB high:1176kB active_anon:0kB inactive_anon:0kB 
active_file:0kB inactive_file:0kB unevictable:0kB 
isolated(anon):0kB isolated(file):0kB present:15804kB 
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB 
slab_reclaimable:24kB slab_unreclaimable:2184kB 
kernel_stack:9392kB pagetables:0kB unstable:0kB bounce:0kB 
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
Apr  8 20:29:17 werner kernel: lowmem_reserve[]: 0 865 
3031 3031
Apr  8 20:29:17 werner kernel: Normal free:44004kB 
min:44012kB low:55012kB high:66016kB active_anon:0kB 
inactive_anon:0kB active_file:132kB inactive_file:140kB 
unevictable:0kB isolated(anon):0kB isolated(file):0kB 
present:885944kB mlocked:0kB dirty:0kB writeback:0kB 
mapped:0kB shmem:0kB slab_reclaimable:13068kB 
slab_unreclaimable:147784kB kernel_stack:628952kB 
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB 
pages_scanned:15968 all_unreclaimable? yes
Apr  8 20:29:17 werner kernel: lowmem_reserve[]: 0 0 17326 
17326
Apr  8 20:29:17 werner kernel: HighMem free:1927956kB 
min:512kB low:28056kB high:55600kB active_anon:126384kB 
inactive_anon:128kB active_file:61664kB 
inactive_file:84900kB unevictable:0kB isolated(anon):0kB 
isolated(file):0kB present:2217808kB mlocked:0kB dirty:4kB 
writeback:0kB mapped:74520kB shmem:2692kB 
slab_reclaimable:0kB slab_unreclaimable:0kB 
kernel_stack:0kB pagetables:1856kB unstable:0kB bounce:0kB 
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
Apr  8 20:29:17 werner kernel: lowmem_reserve[]: 0 0 0 0
Apr  8 20:29:17 werner kernel: DMA: 116*4kB 18*8kB 1*16kB 
1*32kB 0*64kB 0*128kB 0*256kB 1*512kB 1*1024kB 1*2048kB 
0*4096kB = 4240kB
Apr  8 20:29:17 werner kernel: Normal: 1527*4kB 535*8kB 
279*16kB 177*32kB 65*64kB 23*128kB 6*256kB 3*512kB 
1*1024kB 0*2048kB 3*4096kB = 44004kB
Apr  8 20:29:17 werner kernel: HighMem: 6715*4kB 5597*8kB 
3896*16kB 2572*32kB 1453*64kB 624*128kB 245*256kB 
111*512kB 64*1024kB 21*2048kB 320*4096kB = 1927956kB
Apr  8 20:29:17 werner kernel: 37382 total pagecache pages
Apr  8 20:29:17 werner kernel: 0 pages in swap cache
Apr  8 20:29:17 werner kernel: Swap cache stats: add 0, 
delete 0, find 0/0
Apr  8 20:29:17 werner kernel: Free swap  = 0kB
Apr  8 20:29:17 werner kernel: Total swap = 0kB
Apr  8 20:29:17 werner kernel: 786128 pages RAM
Apr  8 20:29:17 werner kernel: 558818 pages HighMem
Apr  8 20:29:17 werner kernel: 13582 pages reserved
Apr  8 20:29:17 werner kernel: 101323 pages shared
Apr  8 20:29:17 werner kernel: 175859 pages non-shared
Apr  8 20:29:17 werner kernel: Out of memory: Kill process 
11074 (httpd) score 3 or sacrifice child
Apr  8 20:29:17 werner kernel: Killed process 11074 
(httpd) total-vm:55376kB, anon-rss:8092kB, file-rss:3632kB
Apr  8 20:29:17 werner kernel: iwconfig invoked 
oom-killer: gfp_mask=0x800d0, order=0, oom_adj=0, 
oom_score_adj=0
Apr  8 20:29:17 werner kernel: Pid: 31155, comm: iwconfig 
Not tainted 3.4.0-rc2-i486-1sys #1
Apr  8 20:29:17 werner kernel: Call Trace:
Apr  8 20:29:17 werner kernel:  [<c10356ff>] ? 
printk+0x20/0x22
Apr  8 20:29:17 werner kernel:  [<c10af32b>] 
dump_header+0x6f/0x95
Apr  8 20:29:17 werner kernel:  [<c10af53f>] 
oom_kill_process+0x52/0x251
Apr  8 20:29:17 werner kernel:  [<c10af803>] ? 
select_bad_process+0xc5/0x11c
Apr  8 20:29:17 werner kernel:  [<c10af99e>] 
out_of_memory+0x144/0x1b4
Apr  8 20:29:17 werner kernel:  [<c10b269c>] 
__alloc_pages_nodemask+0x501/0x63f
Apr  8 20:29:17 werner kernel:  [<c10b27f6>] 
__get_free_pages+0x1c/0x2d
Apr  8 20:29:17 werner kernel:  [<c113197d>] 
do_proc_readlink+0x27/0x7b
Apr  8 20:29:17 werner kernel:  [<c1133367>] 
proc_pid_readlink+0x48/0x5b
Apr  8 20:29:17 werner kernel:  [<c10ee9c2>] 
sys_readlinkat+0x81/0x95
Apr  8 20:29:17 werner kernel:  [<c10eea02>] 
sys_readlink+0x2c/0x2e
Apr  8 20:29:17 werner kernel:  [<c208c05c>] 
syscall_call+0x7/0xb
Apr  8 20:29:17 werner kernel: Mem-Info:
Apr  8 20:29:17 werner kernel: DMA per-cpu:
Apr  8 20:29:17 werner kernel: CPU    0: hi:    0, btch: 
  1 usd:   0
Apr  8 20:29:17 werner kernel: Normal per-cpu:
Apr  8 20:29:17 werner kernel: CPU    0: hi:  186, btch: 
 31 usd: 104
Apr  8 20:29:17 werner kernel: HighMem per-cpu:
Apr  8 20:29:17 werner kernel: CPU    0: hi:  186, btch: 
 31 usd: 163
Apr  8 20:29:17 werner kernel: active_anon:30699 
inactive_anon:32 isolated_anon:0
Apr  8 20:29:17 werner kernel:  active_file:15553 
inactive_file:21156 isolated_file:0
Apr  8 20:29:17 werner kernel:  unevictable:0 dirty:1 
writeback:0 unstable:0
Apr  8 20:29:17 werner kernel:  free:494949 
slab_reclaimable:3273 slab_unreclaimable:37492
Apr  8 20:29:17 werner kernel:  mapped:18630 shmem:673 
pagetables:445 bounce:0
Apr  8 20:29:17 werner kernel: DMA free:4240kB min:784kB 
low:980kB high:1176kB active_anon:0kB inactive_anon:0kB 
active_file:0kB inactive_file:0kB unevictable:0kB 
isolated(anon):0kB isolated(file):0kB present:15804kB 
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB 
slab_reclaimable:24kB slab_unreclaimable:2184kB 
kernel_stack:9392kB pagetables:0kB unstable:0kB bounce:0kB 
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
Apr  8 20:29:17 werner kernel: lowmem_reserve[]: 0 865 
3031 3031
Apr  8 20:29:17 werner kernel: Normal free:44004kB 
min:44012kB low:55012kB high:66016kB active_anon:0kB 
inactive_anon:0kB active_file:132kB inactive_file:140kB 
unevictable:0kB isolated(anon):0kB isolated(file):0kB 
present:885944kB mlocked:0kB dirty:0kB writeback:0kB 
mapped:0kB shmem:0kB slab_reclaimable:13068kB 
slab_unreclaimable:147784kB kernel_stack:628952kB 
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB 
pages_scanned:16864 all_unreclaimable? yes
Apr  8 20:29:17 werner kernel: lowmem_reserve[]: 0 0 17326 
17326
Apr  8 20:29:17 werner kernel: HighMem free:1931552kB 
min:512kB low:28056kB high:55600kB active_anon:122796kB 
inactive_anon:128kB active_file:62080kB 
inactive_file:84484kB unevictable:0kB isolated(anon):0kB 
isolated(file):0kB present:2217808kB mlocked:0kB dirty:4kB 
writeback:0kB mapped:74520kB shmem:2692kB 
slab_reclaimable:0kB slab_unreclaimable:0kB 
kernel_stack:0kB pagetables:1780kB unstable:0kB bounce:0kB 
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
Apr  8 20:29:17 werner kernel: lowmem_reserve[]: 0 0 0 0
Apr  8 20:29:17 werner kernel: DMA: 116*4kB 18*8kB 1*16kB 
1*32kB 0*64kB 0*128kB 0*256kB 1*512kB 1*1024kB 1*2048kB 
0*4096kB = 4240kB
Apr  8 20:29:17 werner kernel: Normal: 1527*4kB 535*8kB 
279*16kB 177*32kB 65*64kB 23*128kB 6*256kB 3*512kB 
1*1024kB 0*2048kB 3*4096kB = 44004kB
Apr  8 20:29:17 werner kernel: HighMem: 6724*4kB 5598*8kB 
3908*16kB 2589*32kB 1469*64kB 630*128kB 249*256kB 
111*512kB 64*1024kB 21*2048kB 320*4096kB = 1931552kB
Apr  8 20:29:17 werner kernel: 37382 total pagecache pages
Apr  8 20:29:17 werner kernel: 0 pages in swap cache
Apr  8 20:29:17 werner kernel: Swap cache stats: add 0, 
delete 0, find 0/0
Apr  8 20:29:17 werner kernel: Free swap  = 0kB
Apr  8 20:29:17 werner kernel: Total swap = 0kB
Apr  8 20:29:17 werner kernel: 786128 pages RAM
Apr  8 20:29:17 werner kernel: 558818 pages HighMem
Apr  8 20:29:17 werner kernel: 13582 pages reserved
Apr  8 20:29:17 werner kernel: 99284 pages shared
Apr  8 20:29:17 werner kernel: 174956 pages non-shared
Apr  8 20:29:17 werner kernel: Out of memory: Kill process 
11075 (httpd) score 3 or sacrifice child
Apr  8 20:29:17 werner kernel: Killed process 11075 
(httpd) total-vm:55120kB, anon-rss:7832kB, file-rss:3628kB
Apr  8 20:29:17 werner kernel: iwconfig invoked 
oom-killer: gfp_mask=0x800d0, order=0, oom_adj=0, 
oom_score_adj=0
Apr  8 20:29:17 werner kernel: Pid: 31155, comm: iwconfig 
Not tainted 3.4.0-rc2-i486-1sys #1
Apr  8 20:29:17 werner kernel: Call Trace:
Apr  8 20:29:17 werner kernel:  [<c10356ff>] ? 
printk+0x20/0x22
Apr  8 20:29:17 werner kernel:  [<c10af32b>] 
dump_header+0x6f/0x95
Apr  8 20:29:17 werner kernel:  [<c10af53f>] 
oom_kill_process+0x52/0x251
Apr  8 20:29:17 werner kernel:  [<c10af803>] ? 
select_bad_process+0xc5/0x11c
Apr  8 20:29:17 werner kernel:  [<c10af99e>] 
out_of_memory+0x144/0x1b4
Apr  8 20:29:17 werner kernel:  [<c10b269c>] 
__alloc_pages_nodemask+0x501/0x63f
Apr  8 20:29:17 werner kernel:  [<c10b27f6>] 
__get_free_pages+0x1c/0x2d
Apr  8 20:29:17 werner kernel:  [<c113197d>] 
do_proc_readlink+0x27/0x7b
Apr  8 20:29:17 werner kernel:  [<c1133367>] 
proc_pid_readlink+0x48/0x5b
Apr  8 20:29:17 werner kernel:  [<c10ee9c2>] 
sys_readlinkat+0x81/0x95
Apr  8 20:29:17 werner kernel:  [<c10eea02>] 
sys_readlink+0x2c/0x2e
Apr  8 20:29:17 werner kernel:  [<c208c05c>] 
syscall_call+0x7/0xb
Apr  8 20:29:17 werner kernel: Mem-Info:
Apr  8 20:29:17 werner kernel: DMA per-cpu:
Apr  8 20:29:17 werner kernel: CPU    0: hi:    0, btch: 
  1 usd:   0
Apr  8 20:29:17 werner kernel: Normal per-cpu:
Apr  8 20:29:17 werner kernel: CPU    0: hi:  186, btch: 
 31 usd:  57
Apr  8 20:29:17 werner kernel: HighMem per-cpu:
Apr  8 20:29:17 werner kernel: CPU    0: hi:  186, btch: 
 31 usd: 121
Apr  8 20:29:17 werner kernel: active_anon:29820 
inactive_anon:29 isolated_anon:0
Apr  8 20:29:17 werner kernel:  active_file:15559 
inactive_file:21150 isolated_file:0
Apr  8 20:29:17 werner kernel:  unevictable:0 dirty:0 
writeback:0 unstable:0
Apr  8 20:29:17 werner kernel:  free:495930 
slab_reclaimable:3267 slab_unreclaimable:37486
Apr  8 20:29:17 werner kernel:  mapped:18629 shmem:671 
pagetables:434 bounce:0
Apr  8 20:29:17 werner kernel: DMA free:4240kB min:784kB 
low:980kB high:1176kB active_anon:0kB inactive_anon:0kB 
active_file:0kB inactive_file:0kB unevictable:0kB 
isolated(anon):0kB isolated(file):0kB present:15804kB 
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB 
slab_reclaimable:24kB slab_unreclaimable:2184kB 
kernel_stack:9392kB pagetables:0kB unstable:0kB bounce:0kB 
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
Apr  8 20:29:17 werner kernel: lowmem_reserve[]: 0 865 
3031 3031
Apr  8 20:29:17 werner kernel: Normal free:44184kB 
min:44012kB low:55012kB high:66016kB active_anon:0kB 
inactive_anon:0kB active_file:128kB inactive_file:144kB 
unevictable:0kB isolated(anon):0kB isolated(file):0kB 
present:885944kB mlocked:0kB dirty:0kB writeback:0kB 
mapped:0kB shmem:0kB slab_reclaimable:13044kB 
slab_unreclaimable:147760kB kernel_stack:628952kB 
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB 
pages_scanned:447 all_unreclaimable? yes
Apr  8 20:29:17 werner kernel: lowmem_reserve[]: 0 0 17326 
17326
Apr  8 20:29:17 werner kernel: HighMem free:1935296kB 
min:512kB low:28056kB high:55600kB active_anon:119280kB 
inactive_anon:116kB active_file:62108kB 
inactive_file:84456kB unevictable:0kB isolated(anon):0kB 
isolated(file):0kB present:2217808kB mlocked:0kB dirty:0kB 
writeback:0kB mapped:74516kB shmem:2684kB 
slab_reclaimable:0kB slab_unreclaimable:0kB 
kernel_stack:0kB pagetables:1736kB unstable:0kB bounce:0kB 
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
Apr  8 20:29:17 werner kernel: lowmem_reserve[]: 0 0 0 0
Apr  8 20:29:17 werner kernel: DMA: 116*4kB 18*8kB 1*16kB 
1*32kB 0*64kB 0*128kB 0*256kB 1*512kB 1*1024kB 1*2048kB 
0*4096kB = 4240kB
Apr  8 20:29:17 werner kernel: Normal: 1568*4kB 535*8kB 
280*16kB 177*32kB 65*64kB 23*128kB 6*256kB 3*512kB 
1*1024kB 0*2048kB 3*4096kB = 44184kB
Apr  8 20:29:17 werner kernel: HighMem: 6656*4kB 5630*8kB 
3937*16kB 2602*32kB 1484*64kB 637*128kB 253*256kB 
111*512kB 64*1024kB 21*2048kB 320*4096kB = 1935296kB
Apr  8 20:29:17 werner kernel: 37380 total pagecache pages
Apr  8 20:29:17 werner kernel: 0 pages in swap cache
Apr  8 20:29:17 werner kernel: Swap cache stats: add 0, 
delete 0, find 0/0
Apr  8 20:29:17 werner kernel: Free swap  = 0kB
Apr  8 20:29:17 werner kernel: Total swap = 0kB
Apr  8 20:29:17 werner kernel: 786128 pages RAM
Apr  8 20:29:17 werner kernel: 558818 pages HighMem
Apr  8 20:29:17 werner kernel: 13582 pages reserved
Apr  8 20:29:17 werner kernel: 96159 pages shared
Apr  8 20:29:17 werner kernel: 174665 pages non-shared
Apr  8 20:29:17 werner kernel: Out of memory: Kill process 
11076 (httpd) score 3 or sacrifice child
Apr  8 20:29:17 werner kernel: Killed process 11076 
(httpd) total-vm:55380kB, anon-rss:8088kB, file-rss:3632kB
Apr  8 20:29:28 werner kdm_greet[31163]: Can't open 
default user face
Apr  8 20:55:07 werner hcid[9333]: Got disconnected from 
the system message bus
---
Professional hosting for everyone - http://www.host.ru

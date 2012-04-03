Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421Ab2DCCWS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 22:22:18 -0400
Received: from zfrontend1.aha.ru ([195.2.83.147]:35951 "EHLO aha.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754395Ab2DCCWP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 22:22:15 -0400
From: "werner" <w.landgraf@ru.ru>
Subject: 3.4-rc1 sticks-and-crashs
To: linux-kernel@vger.kernel.org
X-Mailer: CommuniGate Pro WebUser Interface v.4.3.12
Date: Mon, 02 Apr 2012 22:25:58 -0400
Message-ID: <web-719682330@zbackend1.aha.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Protocol of a next hanging and quasi-crash. with 3.4-rc1

Again, after longer time work, the computer  started to 
become slow and sticked.  This time, I pressed
CNTRL-BACKSPACE and CNTR-SUPPR, as an attempt to avoid a 
crash. Really, after appr. 15 min. sticking, it rebooted.
However, the syslog is showing not many.

Then I rebooted into 3.3 , in order that I can use 
normally the computer, until that problem is resolved.

I hope the syslog, containing some traces, is useful.


wl





Apr  2 16:23:15 werner kernel: Malformed early option 
'acpi'
Apr  2 16:23:16 werner kernel: ACPI: RSDP 000f6920 00014 
(v00 GBT   )
Apr  2 16:23:16 werner kernel: ACPI: RSDT bfee3000 00038 
(v01 GBT    NVDAACPI 42302E31 NVDA 01010101)
Apr  2 16:23:16 werner kernel: ACPI: FACP bfee3040 00074 
(v01 GBT    NVDAACPI 42302E31 NVDA 01010101)
Apr  2 16:23:16 werner kernel: ACPI: DSDT bfee30c0 0469E 
(v01 GBT    NVDAACPI 00001000 MSFT 03000000)
Apr  2 16:23:16 werner kernel: ACPI: FACS bfee0000 00040
Apr  2 16:23:16 werner kernel: ACPI: SSDT bfee7880 0028A 
(v01 PTLTD  POWERNOW 00000001  LTP 00000001)
Apr  2 16:23:16 werner kernel: ACPI: HPET bfee7b40 00038 
(v01 GBT    NVDAACPI 42302E31 NVDA 00000098)
Apr  2 16:23:16 werner kernel: ACPI: MCFG bfee7b80 0003C 
(v01 GBT    NVDAACPI 42302E31 NVDA 01010101)
Apr  2 16:23:16 werner kernel: ACPI: APIC bfee7780 000D0 
(v01 GBT    NVDAACPI 42302E31 NVDA 01010101)
Apr  2 16:23:16 werner kernel: Zone PFN ranges:
Apr  2 16:23:16 werner kernel:   DMA      0x00000010 -> 
0x00001000
Apr  2 16:23:16 werner kernel:   Normal   0x00001000 -> 
0x000377fe
Apr  2 16:23:16 werner kernel:   HighMem  0x000377fe -> 
0x000bfee0
Apr  2 16:23:16 werner kernel: Movable zone start PFN for 
each node
Apr  2 16:23:16 werner kernel: Early memory PFN ranges
Apr  2 16:23:16 werner kernel:     0: 0x00000010 -> 
0x0000009f
Apr  2 16:23:16 werner kernel:     0: 0x00000100 -> 
0x000bfee0
Apr  2 16:23:16 werner kernel: Built 1 zonelists in Zone 
order, mobility grouping on.  Total pages: 779889
Apr  2 16:23:16 werner kernel: Fast TSC calibration using 
PIT
Apr  2 16:23:16 werner kernel: Detected 2511.460 MHz 
processor.
Apr  2 16:23:16 werner kernel: ACPI: setting ELCR to 0200 
(from 0c20)
Apr  2 16:23:16 werner kernel: AMD PMU driver.
Apr  2 16:23:16 werner kernel: raid6: int32x1    945 MB/s
Apr  2 16:23:16 werner kernel: raid6: int32x2    933 MB/s
Apr  2 16:23:16 werner kernel: raid6: int32x4    933 MB/s
Apr  2 16:23:16 werner kernel: raid6: int32x8    617 MB/s
Apr  2 16:23:16 werner kernel: raid6: mmxx1     2011 MB/s
Apr  2 16:23:16 werner kernel: raid6: mmxx2     3644 MB/s
Apr  2 16:23:16 werner kernel: raid6: sse1x1    2015 MB/s
Apr  2 16:23:16 werner kernel: raid6: sse1x2    3492 MB/s
Apr  2 16:23:16 werner kernel: raid6: sse2x1    3453 MB/s
Apr  2 16:23:16 werner kernel: raid6: sse2x2    4574 MB/s
Apr  2 16:23:16 werner kernel: raid6: using algorithm 
sse2x2 (4574 MB/s)
Apr  2 16:23:16 werner kernel: Expanded resource reserved 
due to conflict with PCI Bus 0000:00
Apr  2 16:23:16 werner kernel: mdacon: MDA with 8K of 
memory detected.
Apr  2 16:23:16 werner kernel: ACPI: PCI Interrupt Link 
[LUBA] enabled at IRQ 11
Apr  2 16:23:16 werner kernel: ACPI: PCI Interrupt Link 
[LUB2] enabled at IRQ 5
Apr  2 16:23:16 werner kernel: microcode: CPU0: family 15 
not supported
Apr  2 16:23:16 werner kernel: The force parameter has not 
been set to 1 so the Iris poweroff handler will not be 
installed.
Apr  2 16:23:16 werner kernel: highmem bounce pool size: 
64 pages
Apr  2 16:23:16 werner kernel: Dquot-cache hash table 
entries: 1024 (order 0, 4096 bytes)
Apr  2 16:23:16 werner kernel: DLM installed
Apr  2 16:23:16 werner kernel: EFS: 1.0a - 
http://aeschi.ch.eu.org/efs/
Apr  2 16:23:16 werner kernel: OCFS2 User DLM kernel 
interface loaded
Apr  2 16:23:16 werner kernel: GFS2 installed
Apr  2 16:23:16 werner kernel: acpiphp_ibm: 
ibm_acpiphp_init: acpi_walk_namespace failed
Apr  2 16:23:16 werner kernel: ACPI: PCI Interrupt Link 
[LIGP] enabled at IRQ 11
Apr  2 16:23:16 werner kernel: nvidiafb: CRTC0 analog 
found
Apr  2 16:23:16 werner kernel: nvidiafb: CRTC1 analog not 
found
Apr  2 16:23:16 werner kernel: i2c i2c-0: unable to read 
EDID block.
Apr  2 16:23:16 werner last message repeated 2 times
Apr  2 16:23:16 werner kernel: nvidiafb: EDID found from 
BUS2
Apr  2 16:23:16 werner kernel: nvidiafb: CRTC 0 appears to 
have a CRT attached
Apr  2 16:23:16 werner kernel: nvidiafb: Using CRT on CRTC 
0
Apr  2 16:23:16 werner kernel: Could not find Carillo 
Ranch MCH device.
Apr  2 16:23:16 werner kernel: no IO addresses supplied
Apr  2 16:23:16 werner kernel: hgafb: probe of hgafb.0 
failed with error -22
Apr  2 16:23:16 werner kernel: uvesafb: failed to execute 
/sbin/v86d
Apr  2 16:23:16 werner kernel: uvesafb: make sure that the 
v86d helper is installed and executable
Apr  2 16:23:16 werner kernel: uvesafb: Getting VBE info 
block failed (eax=0x4f00, err=-2)
Apr  2 16:23:16 werner kernel: uvesafb: vbe_init() failed 
with -22
Apr  2 16:23:16 werner kernel: uvesafb: probe of uvesafb.0 
failed with error -22
Apr  2 16:23:16 werner kernel: vesafb: cannot reserve 
video memory at 0xd0000000
Apr  2 16:23:16 werner kernel: toshiba: not a supported 
Toshiba laptop
Apr  2 16:23:16 werner kernel: [drm:i915_init] *ERROR* 
drm/i915 can't work without intel_agp module!
Apr  2 16:23:16 werner kernel: Compaq SMART2 Driver (v 
2.6.0)
Apr  2 16:23:16 werner kernel: i2c-core: driver [isl29003] 
using legacy suspend method
Apr  2 16:23:16 werner kernel: i2c-core: driver [isl29003] 
using legacy resume method
Apr  2 16:23:16 werner kernel: amd74xx 0000:00:06.0: BIOS 
didn't set cable bits correctly. Enabling workaround.
Apr  2 16:23:16 werner kernel: Loading Adaptec I2O RAID: 
Version 2.4 Build 5go
Apr  2 16:23:16 werner kernel: scsi: <fdomain> Detection 
failed (no card)
Apr  2 16:23:16 werner kernel: NCR53c406a: no available 
ports found
Apr  2 16:23:16 werner kernel: qla2xxx 
[0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driver: 
8.03.07.13-k.
Apr  2 16:23:16 werner kernel: Emulex LightPulse Fibre 
Channel SCSI driver 8.3.30
Apr  2 16:23:16 werner kernel: Copyright(c) 2004-2009 
Emulex.  All rights reserved.
Apr  2 16:23:16 werner kernel: Failed initialization of 
WD-7000 SCSI card!
Apr  2 16:23:16 werner kernel: GDT-HA: Storage RAID 
Controller Driver. Version: 3.05
Apr  2 16:23:16 werner kernel: 3ware Storage Controller 
device driver for Linux v1.26.02.003.
Apr  2 16:23:16 werner kernel: 3ware 9000 Storage 
Controller device driver for Linux v2.26.02.014.
Apr  2 16:23:16 werner kernel: imm: Version 2.05 (for 
Linux 2.4.0)
Apr  2 16:23:16 werner kernel: ACPI: PCI Interrupt Link 
[LSID] enabled at IRQ 11
Apr  2 16:23:16 werner kernel: ACPI: PCI Interrupt Link 
[LFID] enabled at IRQ 10
Apr  2 16:23:16 werner kernel: Error: Driver 
'pata_platform' is already registered, aborting...
Apr  2 16:23:16 werner kernel: physmap-flash.0: failed to 
claim resource 0
Apr  2 16:23:16 werner kernel: Failed to ioremap_nocache
Apr  2 16:23:16 werner last message repeated 2 times
Apr  2 16:23:16 werner kernel: SNAPGEAR: failed to 
ioremap() BOOTCS
Apr  2 16:23:16 werner kernel: Generic platform RAM MTD, 
(c) 2004 Simtec Electronics
Apr  2 16:23:16 werner kernel: [nandsim] warning: 
read_byte: unexpected data output cycle, state is 
STATE_READY return 0x0
Apr  2 16:23:16 werner last message repeated 5 times
Apr  2 16:23:16 werner kernel: flash size: 8 MiB
Apr  2 16:23:16 werner kernel: page size: 512 bytes
Apr  2 16:23:16 werner kernel: OOB area size: 16 bytes
Apr  2 16:23:16 werner kernel: sector size: 8 KiB
Apr  2 16:23:16 werner kernel: pages number: 16384
Apr  2 16:23:16 werner kernel: pages per sector: 16
Apr  2 16:23:16 werner kernel: bus width: 8
Apr  2 16:23:16 werner kernel: bits in sector size: 13
Apr  2 16:23:16 werner kernel: bits in page size: 9
Apr  2 16:23:16 werner kernel: bits in OOB size: 4
Apr  2 16:23:16 werner kernel: flash size with OOB: 8448 
KiB
Apr  2 16:23:16 werner kernel: page address bytes: 3
Apr  2 16:23:16 werner kernel: sector address bytes: 2
Apr  2 16:23:16 werner kernel: options: 0x62
Apr  2 16:23:16 werner kernel: onenand_wait: timeout! 
ctrl=0x0000 intr=0x0000
Apr  2 16:23:16 werner kernel: DE600: port 0x378 busy
Apr  2 16:23:16 werner kernel: paride: aten registered as 
protocol 0
Apr  2 16:23:16 werner kernel: paride: bpck registered as 
protocol 1
Apr  2 16:23:16 werner kernel: paride: comm registered as 
protocol 2
Apr  2 16:23:16 werner kernel: paride: dstr registered as 
protocol 3
Apr  2 16:23:16 werner kernel: paride: k951 registered as 
protocol 4
Apr  2 16:23:16 werner kernel: paride: k971 registered as 
protocol 5
Apr  2 16:23:16 werner kernel: paride: epat registered as 
protocol 6
Apr  2 16:23:16 werner kernel: paride: epia registered as 
protocol 7
Apr  2 16:23:16 werner kernel: paride: frpw registered as 
protocol 8
Apr  2 16:23:16 werner kernel: paride: friq registered as 
protocol 9
Apr  2 16:23:16 werner kernel: paride: fit2 registered as 
protocol 10
Apr  2 16:23:16 werner kernel: paride: fit3 registered as 
protocol 11
Apr  2 16:23:16 werner kernel: paride: on20 registered as 
protocol 12
Apr  2 16:23:16 werner kernel: paride: on26 registered as 
protocol 13
Apr  2 16:23:16 werner kernel: paride: ktti registered as 
protocol 14
Apr  2 16:23:16 werner kernel: paride: bpck6 registered as 
protocol 15
Apr  2 16:23:16 werner kernel: pd: pd version 1.05, major 
45, cluster 64, nice 0
Apr  2 16:23:16 werner kernel: pda: Autoprobe failed
Apr  2 16:23:16 werner kernel: pd: no valid drive found
Apr  2 16:23:16 werner kernel: pcd: pcd version 1.07, 
major 46, nice 0
Apr  2 16:23:16 werner kernel: pcd0: Autoprobe failed
Apr  2 16:23:16 werner kernel: pcd: No CD-ROM drive found
Apr  2 16:23:16 werner kernel: pf: pf version 1.04, major 
47, cluster 64, nice 0
Apr  2 16:23:16 werner kernel: pf: No ATAPI disk detected
Apr  2 16:23:16 werner kernel: pt: pt version 1.04, major 
96
Apr  2 16:23:16 werner kernel: sr0: scsi3-mmc drive: 
48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
Apr  2 16:23:16 werner kernel: pt0: Autoprobe failed
Apr  2 16:23:16 werner kernel: pt: No ATAPI tape drive 
detected
Apr  2 16:23:16 werner kernel: pg: pg version 1.02, major 
97
Apr  2 16:23:16 werner kernel: pga: Autoprobe failed
Apr  2 16:23:16 werner kernel: pg: No ATAPI device 
detected
Apr  2 16:23:16 werner kernel: mk712: device not present
Apr  2 16:23:16 werner kernel: wistron_btns: System 
unknown
Apr  2 16:23:16 werner kernel: EISA: Cannot allocate 
resource for mainboard
Apr  2 16:23:16 werner kernel: Cannot allocate resource 
for EISA slot 1
Apr  2 16:23:16 werner kernel: Cannot allocate resource 
for EISA slot 2
Apr  2 16:23:16 werner kernel: Cannot allocate resource 
for EISA slot 3
Apr  2 16:23:16 werner kernel: Cannot allocate resource 
for EISA slot 4
Apr  2 16:23:16 werner kernel: Cannot allocate resource 
for EISA slot 5
Apr  2 16:23:16 werner kernel: Cannot allocate resource 
for EISA slot 6
Apr  2 16:23:16 werner kernel: Cannot allocate resource 
for EISA slot 7
Apr  2 16:23:16 werner kernel: Cannot allocate resource 
for EISA slot 8
Apr  2 16:23:16 werner kernel: asus_wmi: Management GUID 
not found
Apr  2 16:23:16 werner kernel: asus_wmi: Management GUID 
not found
Apr  2 16:23:16 werner kernel: compal_laptop: Motherboard 
not recognized (You could try the module's 
force-parameter)
Apr  2 16:23:16 werner kernel: dell_wmi: No known WMI GUID 
found
Apr  2 16:23:16 werner kernel: dell_wmi_aio: No known WMI 
GUID found
Apr  2 16:23:16 werner kernel: acer_wmi: No or unsupported 
WMI interface, unable to load
Apr  2 16:23:16 werner kernel: acerhdf: unknown 
(unsupported) BIOS version Gigabyte Technology Co., 
Ltd./M68M-S2P/FC, please report, aborting!
Apr  2 16:23:16 werner kernel: hdaps: supported laptop not 
found!
Apr  2 16:23:16 werner kernel: hdaps: driver init failed 
(ret=-19)!
Apr  2 16:23:16 werner kernel: msi_wmi: This machine 
doesn't have MSI-hotkeys through WMI
Apr  2 16:23:16 werner kernel: intel_oaktrail: Platform 
not recognized (You could try the module's 
force-parameter)
Apr  2 16:23:16 werner kernel: OK
Apr  2 16:23:16 werner kernel: OK
Apr  2 16:23:16 werner kernel: register_blkdev: cannot get 
major 3 for hd
Apr  2 16:23:16 werner kernel: drivers/rtc/hctosys.c: 
unable to open rtc device (rtc0)
Apr  2 16:23:16 werner kernel: udevd (5370): 
/proc/5370/oom_adj is deprecated, please use 
/proc/5370/oom_score_adj instead.
Apr  2 16:23:16 werner kernel: end_request: I/O error, dev 
fd0, sector 0
Apr  2 16:23:16 werner kernel: ACPI: PCI Interrupt Link 
[LAZA] enabled at IRQ 10
Apr  2 16:23:16 werner kernel: 2:3:1: cannot get freq at 
ep 0x84
Apr  2 16:23:16 werner kernel: ACPI: PCI Interrupt Link 
[LMAC] enabled at IRQ 5
Apr  2 16:23:16 werner kernel: k8temp 0000:00:18.3: 
Temperature readouts might be wrong - check erratum #141
Apr  2 16:23:16 werner kernel: EXT3-fs (sda1): warning: 
maximal mount count reached, running e2fsck is recommended
Apr  2 16:23:16 werner udevd[5370]: add_to_rules: unknown 
key 'MODALIAS' in /etc/udev/rules.d/80-eagle-usb.rules:1
Apr  2 16:23:16 werner udevd[5370]: add_to_rules: unknown 
key 'MODALIAS' in /etc/udev/rules.d/80-eagle-usb.rules:1
Apr  2 16:23:17 werner udevd-event[9220]: 
udev_rules_apply_format: unknown format variable 
'$modalias | grep -q eagle-usb || exit; while ! 
/sbin/eaglectrl -p 2>/dev/null | /bin/grep -q 
Post-firmware; do sleep 2; done; /sbin/eaglectrl -d''
Apr  2 16:23:17 werner udevd-event[9221]: 
udev_rules_apply_format: unknown format variable 
'$modalias | grep -q eagle-usb || exit; while ! 
/sbin/eaglectrl -p 2>/dev/null | /bin/grep -q 
Post-firmware; do sleep 2; done; /sbin/eaglectrl -d''
Apr  2 16:23:17 werner udevd-event[9227]: run_program: 
exec of program '/etc/rc.d/rc.media-daemon' failed
Apr  2 16:23:27 werner apcupsd[9201]: apcupsd FATAL ERROR 
in smartsetup.c at line 171 PANIC! Cannot communicate with 
UPS via serial port. Please make sure the port specified 
on the DEVICE directive is correct, and that your cable 
specification on the UPSCABLE directive is correct.
Apr  2 16:23:27 werner apcupsd[9201]: apcupsd error 
shutdown completed
Apr  2 16:23:36 werner hpijs[9468]: prnt/hpijs/hpijs.cpp 
614: unable to init hpijs server
Apr  2 16:23:42 werner udevd[5370]: add_to_rules: unknown 
key 'MODALIAS' in /etc/udev/rules.d/80-eagle-usb.rules:1
Apr  2 16:24:09 werner kdm_greet[9612]: Can't open default 
user face
Apr  2 16:25:45 werner named[10121]: /etc/named.conf:3: 
option 'multiple-cnames' is obsolete
Apr  2 22:44:30 werner kernel: X invoked oom-killer: 
gfp_mask=0xd0, order=0, oom_adj=0, oom_score_adj=0
Apr  2 22:44:30 werner kernel: Pid: 9607, comm: X Not 
tainted 3.4.0-rc1-i486-1sys #1
Apr  2 22:44:30 werner kernel: Call Trace:
Apr  2 22:44:30 werner kernel:  [<c10356cf>] ? 
printk+0x20/0x22
Apr  2 22:44:30 werner kernel:  [<c10af0f7>] 
dump_header+0x6f/0x95
Apr  2 22:44:30 werner kernel:  [<c10af30b>] 
oom_kill_process+0x52/0x251
Apr  2 22:44:30 werner kernel:  [<c10af5cf>] ? 
select_bad_process+0xc5/0x11c
Apr  2 22:44:30 werner kernel:  [<c10af76a>] 
out_of_memory+0x144/0x1b4
Apr  2 22:44:30 werner kernel:  [<c10b2468>] 
__alloc_pages_nodemask+0x501/0x63f
Apr  2 22:44:30 werner kernel:  [<c1053910>] ? 
__wake_up_common+0xe/0x62
Apr  2 22:44:30 werner kernel:  [<c10b25c2>] 
__get_free_pages+0x1c/0x2d
Apr  2 22:44:30 werner kernel:  [<c10f8f19>] 
poll_get_entry+0x48/0x75
Apr  2 22:44:30 werner kernel:  [<c10f8f5e>] 
__pollwait+0x18/0x4d
Apr  2 22:44:30 werner kernel:  [<c10f8f46>] ? 
poll_get_entry+0x75/0x75
Apr  2 22:44:30 werner kernel:  [<c1f69875>] 
unix_poll+0x1e/0x9f
Apr  2 22:44:30 werner kernel:  [<c1ee2613>] 
sock_poll+0x14/0x17
Apr  2 22:44:30 werner kernel:  [<c10f972d>] 
do_select+0x229/0x44b
Apr  2 22:44:30 werner kernel:  [<c10f8f46>] ? 
poll_get_entry+0x75/0x75
Apr  2 22:44:30 werner kernel:  [<c10f8fd9>] ? 
__pollwake+0x46/0x46
Apr  2 22:44:30 werner last message repeated 17 times
Apr  2 22:44:30 werner kernel:  [<c10f9add>] 
core_sys_select+0x18e/0x255
Apr  2 22:44:30 werner kernel:  [<c10509d3>] ? 
hrtimer_try_to_cancel+0x84/0x8d
Apr  2 22:44:30 werner kernel:  [<c1038b82>] ? 
set_normalized_timespec+0x9/0x43
Apr  2 22:44:30 werner kernel:  [<c1038b82>] ? 
set_normalized_timespec+0x9/0x43
Apr  2 22:44:30 werner kernel:  [<c1038de8>] ? 
timespec_add_safe+0x2f/0x4f
Apr  2 22:44:30 werner kernel:  [<c10f9d4a>] 
sys_select+0x79/0x96
Apr  2 22:44:30 werner kernel:  [<c2088cdc>] 
syscall_call+0x7/0xb
Apr  2 22:44:30 werner kernel: Mem-Info:
Apr  2 22:44:30 werner kernel: DMA per-cpu:
Apr  2 22:44:30 werner kernel: CPU    0: hi:    0, btch: 
  1 usd:   0
Apr  2 22:44:30 werner kernel: Normal per-cpu:
Apr  2 22:44:30 werner kernel: CPU    0: hi:  186, btch: 
 31 usd:  63
Apr  2 22:44:30 werner kernel: HighMem per-cpu:
Apr  2 22:44:30 werner kernel: CPU    0: hi:  186, btch: 
 31 usd:   0
Apr  2 22:44:30 werner kernel: active_anon:105780 
inactive_anon:45 isolated_anon:0
Apr  2 22:44:30 werner kernel:  active_file:29025 
inactive_file:33292 isolated_file:0
Apr  2 22:44:30 werner kernel:  unevictable:17 dirty:0 
writeback:0 unstable:0
Apr  2 22:44:30 werner kernel:  free:394086 
slab_reclaimable:3430 slab_unreclaimable:39169
Apr  2 22:44:30 werner kernel:  mapped:27648 shmem:704 
pagetables:725 bounce:0
Apr  2 22:44:30 werner kernel: DMA free:4244kB min:784kB 
low:980kB high:1176kB active_anon:0kB inactive_anon:0kB 
active_file:0kB inactive_file:0kB unevictable:0kB 
isolated(anon):0kB isolated(file):0kB present:15804kB 
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB 
slab_reclaimable:12kB slab_unreclaimable:1552kB 
kernel_stack:10040kB pagetables:0kB unstable:0kB 
bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? yes
Apr  2 22:44:30 werner kernel: lowmem_reserve[]: 0 865 
3031 3031
Apr  2 22:44:30 werner kernel: Normal free:43908kB 
min:44012kB low:55012kB high:66016kB active_anon:0kB 
inactive_anon:0kB active_file:140kB inactive_file:144kB 
unevictable:0kB isolated(anon):0kB isolated(file):0kB 
present:885944kB mlocked:0kB dirty:0kB writeback:0kB 
mapped:12kB shmem:0kB slab_reclaimable:13708kB 
slab_unreclaimable:155124kB kernel_stack:621192kB 
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB 
pages_scanned:491 all_unreclaimable? yes
Apr  2 22:44:30 werner kernel: lowmem_reserve[]: 0 0 17326 
17326
Apr  2 22:44:30 werner kernel: HighMem free:1528192kB 
min:512kB low:28056kB high:55600kB active_anon:423120kB 
inactive_anon:180kB active_file:115960kB 
inactive_file:133024kB unevictable:68kB isolated(anon):0kB 
isolated(file):0kB present:2217808kB mlocked:68kB 
dirty:0kB writeback:0kB mapped:110580kB shmem:2816kB 
slab_reclaimable:0kB slab_unreclaimable:0kB 
kernel_stack:0kB pagetables:2900kB unstable:0kB bounce:0kB 
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
Apr  2 22:44:30 werner kernel: lowmem_reserve[]: 0 0 0 0
Apr  2 22:44:30 werner kernel: DMA: 17*4kB 28*8kB 27*16kB 
36*32kB 33*64kB 2*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 
0*4096kB = 4244kB
Apr  2 22:44:30 werner kernel: Normal: 2245*4kB 292*8kB 
145*16kB 74*32kB 26*64kB 13*128kB 6*256kB 3*512kB 1*1024kB 
0*2048kB 5*4096kB = 43908kB
Apr  2 22:44:30 werner kernel: HighMem: 1148*4kB 708*8kB 
811*16kB 1686*32kB 1272*64kB 522*128kB 213*256kB 100*512kB 
49*1024kB 24*2048kB 268*4096kB = 1528192kB
Apr  2 22:44:30 werner kernel: 63019 total pagecache pages
Apr  2 22:44:30 werner kernel: 0 pages in swap cache
Apr  2 22:44:30 werner kernel: Swap cache stats: add 0, 
delete 0, find 0/0
Apr  2 22:44:30 werner kernel: Free swap  = 0kB
Apr  2 22:44:30 werner kernel: Total swap = 0kB
Apr  2 22:44:30 werner kernel: 786128 pages RAM
Apr  2 22:44:30 werner kernel: 558818 pages HighMem
Apr  2 22:44:30 werner kernel: 13576 pages reserved
Apr  2 22:44:30 werner kernel: 145578 pages shared
Apr  2 22:44:30 werner kernel: 263131 pages non-shared
Apr  2 22:44:30 werner kernel: Out of memory: Kill process 
18282 (firefox-bin) score 46 or sacrifice child
Apr  2 22:44:30 werner kernel: Killed process 21585 
(plugin-containe) total-vm:121564kB, anon-rss:7448kB, 
file-rss:15452kB
Apr  2 22:44:31 werner kernel: X invoked oom-killer: 
gfp_mask=0xd0, order=0, oom_adj=0, oom_score_adj=0
Apr  2 22:44:31 werner kernel: Pid: 9607, comm: X Not 
tainted 3.4.0-rc1-i486-1sys #1
Apr  2 22:44:31 werner kernel: Call Trace:
Apr  2 22:44:31 werner kernel:  [<c10356cf>] ? 
printk+0x20/0x22
Apr  2 22:44:31 werner kernel:  [<c10af0f7>] 
dump_header+0x6f/0x95
Apr  2 22:44:31 werner kernel:  [<c10af30b>] 
oom_kill_process+0x52/0x251
Apr  2 22:44:31 werner kernel:  [<c10af5cf>] ? 
select_bad_process+0xc5/0x11c
Apr  2 22:44:31 werner kernel:  [<c10af76a>] 
out_of_memory+0x144/0x1b4
Apr  2 22:44:31 werner kernel:  [<c10b2468>] 
__alloc_pages_nodemask+0x501/0x63f
Apr  2 22:44:31 werner kernel:  [<c1053910>] ? 
__wake_up_common+0xe/0x62
Apr  2 22:44:31 werner kernel:  [<c10b25c2>] 
__get_free_pages+0x1c/0x2d
Apr  2 22:44:31 werner kernel:  [<c10f8f19>] 
poll_get_entry+0x48/0x75
Apr  2 22:44:31 werner kernel:  [<c10f8f5e>] 
__pollwait+0x18/0x4d
Apr  2 22:44:31 werner kernel:  [<c10f8f46>] ? 
poll_get_entry+0x75/0x75
Apr  2 22:44:31 werner kernel:  [<c1f69875>] 
unix_poll+0x1e/0x9f
Apr  2 22:44:31 werner kernel:  [<c1ee2613>] 
sock_poll+0x14/0x17
Apr  2 22:44:31 werner kernel:  [<c10f972d>] 
do_select+0x229/0x44b
Apr  2 22:44:31 werner kernel:  [<c10f8f46>] ? 
poll_get_entry+0x75/0x75
Apr  2 22:44:31 werner kernel:  [<c10f8fd9>] ? 
__pollwake+0x46/0x46
Apr  2 22:44:31 werner last message repeated 17 times
Apr  2 22:44:31 werner kernel:  [<c10f9add>] 
core_sys_select+0x18e/0x255
Apr  2 22:44:31 werner kernel:  [<c10509d3>] ? 
hrtimer_try_to_cancel+0x84/0x8d
Apr  2 22:44:31 werner kernel:  [<c1038b82>] ? 
set_normalized_timespec+0x9/0x43
Apr  2 22:44:31 werner kernel:  [<c1038b82>] ? 
set_normalized_timespec+0x9/0x43
Apr  2 22:44:31 werner kernel:  [<c1038de8>] ? 
timespec_add_safe+0x2f/0x4f
Apr  2 22:44:31 werner kernel:  [<c10f9d4a>] 
sys_select+0x79/0x96
Apr  2 22:44:31 werner kernel:  [<c2088cdc>] 
syscall_call+0x7/0xb
Apr  2 22:44:31 werner kernel: Mem-Info:
Apr  2 22:44:31 werner kernel: DMA per-cpu:
Apr  2 22:44:31 werner kernel: CPU    0: hi:    0, btch: 
  1 usd:   0
Apr  2 22:44:31 werner kernel: Normal per-cpu:
Apr  2 22:44:31 werner kernel: CPU    0: hi:  186, btch: 
 31 usd:  32
Apr  2 22:44:31 werner kernel: HighMem per-cpu:
Apr  2 22:44:31 werner kernel: CPU    0: hi:  186, btch: 
 31 usd:   0
Apr  2 22:44:31 werner kernel: active_anon:103213 
inactive_anon:45 isolated_anon:0
Apr  2 22:44:31 werner kernel:  active_file:29143 
inactive_file:33174 isolated_file:0
Apr  2 22:44:31 werner kernel:  unevictable:17 dirty:0 
writeback:0 unstable:0
Apr  2 22:44:31 werner kernel:  free:396693 
slab_reclaimable:3430 slab_unreclaimable:39169
Apr  2 22:44:31 werner kernel:  mapped:26492 shmem:704 
pagetables:705 bounce:0
Apr  2 22:44:31 werner kernel: DMA free:4244kB min:784kB 
low:980kB high:1176kB active_anon:0kB inactive_anon:0kB 
active_file:0kB inactive_file:0kB unevictable:0kB 
isolated(anon):0kB isolated(file):0kB present:15804kB 
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB 
slab_reclaimable:12kB slab_unreclaimable:1552kB 
kernel_stack:10040kB pagetables:0kB unstable:0kB 
bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? yes
Apr  2 22:44:31 werner kernel: lowmem_reserve[]: 0 865 
3031 3031
Apr  2 22:44:31 werner kernel: Normal free:44008kB 
min:44012kB low:55012kB high:66016kB active_anon:0kB 
inactive_anon:0kB active_file:164kB inactive_file:120kB 
unevictable:0kB isolated(anon):0kB isolated(file):0kB 
present:885944kB mlocked:0kB dirty:0kB writeback:0kB 
mapped:12kB shmem:0kB slab_reclaimable:13708kB 
slab_unreclaimable:155124kB kernel_stack:621216kB 
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB 
pages_scanned:438 all_unreclaimable? yes
Apr  2 22:44:31 werner kernel: lowmem_reserve[]: 0 0 17326 
17326
Apr  2 22:44:31 werner kernel: HighMem free:1538520kB 
min:512kB low:28056kB high:55600kB active_anon:412852kB 
inactive_anon:180kB active_file:116408kB 
inactive_file:132576kB unevictable:68kB isolated(anon):0kB 
isolated(file):0kB present:2217808kB mlocked:68kB 
dirty:0kB writeback:0kB mapped:105956kB shmem:2816kB 
slab_reclaimable:0kB slab_unreclaimable:0kB 
kernel_stack:0kB pagetables:2820kB unstable:0kB bounce:0kB 
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
Apr  2 22:44:31 werner kernel: lowmem_reserve[]: 0 0 0 0
Apr  2 22:44:31 werner kernel: DMA: 17*4kB 28*8kB 27*16kB 
36*32kB 33*64kB 2*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 
0*4096kB = 4244kB
Apr  2 22:44:31 werner kernel: Normal: 2246*4kB 304*8kB 
145*16kB 74*32kB 26*64kB 13*128kB 6*256kB 3*512kB 1*1024kB 
0*2048kB 5*4096kB = 44008kB
Apr  2 22:44:31 werner kernel: HighMem: 1848*4kB 1121*8kB 
1065*16kB 1689*32kB 1273*64kB 522*128kB 213*256kB 
100*512kB 49*1024kB 24*2048kB 268*4096kB = 1538520kB
Apr  2 22:44:31 werner kernel: 63021 total pagecache pages
Apr  2 22:44:31 werner kernel: 0 pages in swap cache
Apr  2 22:44:31 werner kernel: Swap cache stats: add 0, 
delete 0, find 0/0
Apr  2 22:44:31 werner kernel: Free swap  = 0kB
Apr  2 22:44:31 werner kernel: Total swap = 0kB
Apr  2 22:44:31 werner kernel: 786128 pages RAM
Apr  2 22:44:31 werner kernel: 558818 pages HighMem
Apr  2 22:44:31 werner kernel: 13576 pages reserved
Apr  2 22:44:31 werner kernel: 141708 pages shared
Apr  2 22:44:31 werner kernel: 261699 pages non-shared
Apr  2 22:44:31 werner kernel: Out of memory: Kill process 
18282 (firefox-bin) score 46 or sacrifice child
Apr  2 22:44:31 werner kernel: Killed process 27056 (kpdf) 
total-vm:63132kB, anon-rss:3252kB, file-rss:28704kB
Apr  2 22:44:31 werner kernel: X invoked oom-killer: 
gfp_mask=0xd0, order=0, oom_adj=0, oom_score_adj=0
Apr  2 22:44:31 werner kernel: Pid: 9607, comm: X Not 
tainted 3.4.0-rc1-i486-1sys #1
Apr  2 22:44:31 werner kernel: Call Trace:
Apr  2 22:44:31 werner kernel:  [<c10356cf>] ? 
printk+0x20/0x22
Apr  2 22:44:31 werner kernel:  [<c10af0f7>] 
dump_header+0x6f/0x95
Apr  2 22:44:31 werner kernel:  [<c10af30b>] 
oom_kill_process+0x52/0x251
Apr  2 22:44:31 werner kernel:  [<c10af5cf>] ? 
select_bad_process+0xc5/0x11c
Apr  2 22:44:31 werner kernel:  [<c10af76a>] 
out_of_memory+0x144/0x1b4
Apr  2 22:44:31 werner kernel:  [<c10b2468>] 
__alloc_pages_nodemask+0x501/0x63f
Apr  2 22:44:31 werner kernel:  [<c1053910>] ? 
__wake_up_common+0xe/0x62
Apr  2 22:44:31 werner kernel:  [<c10b25c2>] 
__get_free_pages+0x1c/0x2d
Apr  2 22:44:31 werner kernel:  [<c10f8f19>] 
poll_get_entry+0x48/0x75
Apr  2 22:44:31 werner kernel:  [<c10f8f5e>] 
__pollwait+0x18/0x4d
Apr  2 22:44:31 werner kernel:  [<c10f8f46>] ? 
poll_get_entry+0x75/0x75
Apr  2 22:44:31 werner kernel:  [<c1f69875>] 
unix_poll+0x1e/0x9f
Apr  2 22:44:31 werner kernel:  [<c1ee2613>] 
sock_poll+0x14/0x17
Apr  2 22:44:31 werner kernel:  [<c10f972d>] 
do_select+0x229/0x44b
Apr  2 22:44:31 werner kernel:  [<c10f8f46>] ? 
poll_get_entry+0x75/0x75
Apr  2 22:44:31 werner kernel:  [<c10f8fd9>] ? 
__pollwake+0x46/0x46
Apr  2 22:44:31 werner last message repeated 17 times
Apr  2 22:44:31 werner kernel:  [<c10f9add>] 
core_sys_select+0x18e/0x255
Apr  2 22:44:31 werner kernel:  [<c10509d3>] ? 
hrtimer_try_to_cancel+0x84/0x8d
Apr  2 22:44:31 werner kernel:  [<c1038b82>] ? 
set_normalized_timespec+0x9/0x43
Apr  2 22:44:31 werner kernel:  [<c1038b82>] ? 
set_normalized_timespec+0x9/0x43
Apr  2 22:44:31 werner kernel:  [<c1038de8>] ? 
timespec_add_safe+0x2f/0x4f
Apr  2 22:44:31 werner kernel:  [<c10f9d4a>] 
sys_select+0x79/0x96
Apr  2 22:44:31 werner kernel:  [<c2088cdc>] 
syscall_call+0x7/0xb
Apr  2 22:44:31 werner kernel: Mem-Info:
Apr  2 22:44:31 werner kernel: DMA per-cpu:
Apr  2 22:44:31 werner kernel: CPU    0: hi:    0, btch: 
  1 usd:   0
Apr  2 22:44:31 werner kernel: Normal per-cpu:
Apr  2 22:44:31 werner kernel: CPU    0: hi:  186, btch: 
 31 usd:  36
Apr  2 22:44:31 werner kernel: HighMem per-cpu:
Apr  2 22:44:31 werner kernel: CPU    0: hi:  186, btch: 
 31 usd: 178
Apr  2 22:44:31 werner kernel: active_anon:102407 
inactive_anon:45 isolated_anon:0
Apr  2 22:44:31 werner kernel:  active_file:29157 
inactive_file:33163 isolated_file:0
Apr  2 22:44:31 werner kernel:  unevictable:17 dirty:0 
writeback:0 unstable:0
Apr  2 22:44:31 werner kernel:  free:397344 
slab_reclaimable:3430 slab_unreclaimable:39169
Apr  2 22:44:31 werner kernel:  mapped:25789 shmem:704 
pagetables:686 bounce:0
Apr  2 22:44:31 werner kernel: DMA free:4244kB min:784kB 
low:980kB high:1176kB active_anon:0kB inactive_anon:0kB 
active_file:0kB inactive_file:0kB unevictable:0kB 
isolated(anon):0kB isolated(file):0kB present:15804kB 
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB 
slab_reclaimable:12kB slab_unreclaimable:1552kB 
kernel_stack:10040kB pagetables:0kB unstable:0kB 
bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? yes
Apr  2 22:44:31 werner kernel: lowmem_reserve[]: 0 865 
3031 3031
Apr  2 22:44:31 werner kernel: Normal free:44008kB 
min:44012kB low:55012kB high:66016kB active_anon:0kB 
inactive_anon:0kB active_file:168kB inactive_file:128kB 
unevictable:0kB isolated(anon):0kB isolated(file):0kB 
present:885944kB mlocked:0kB dirty:0kB writeback:0kB 
mapped:12kB shmem:0kB slab_reclaimable:13708kB 
slab_unreclaimable:155124kB kernel_stack:621216kB 
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB 
pages_scanned:627 all_unreclaimable? yes
Apr  2 22:44:31 werner kernel: lowmem_reserve[]: 0 0 17326 
17326
Apr  2 22:44:31 werner kernel: HighMem free:1541124kB 
min:512kB low:28056kB high:55600kB active_anon:409628kB 
inactive_anon:180kB active_file:116460kB 
inactive_file:132524kB unevictable:68kB isolated(anon):0kB 
isolated(file):0kB present:2217808kB mlocked:68kB 
dirty:0kB writeback:0kB mapped:103144kB shmem:2816kB 
slab_reclaimable:0kB slab_unreclaimable:0kB 
kernel_stack:0kB pagetables:2744kB unstable:0kB bounce:0kB 
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
Apr  2 22:44:31 werner kernel: lowmem_reserve[]: 0 0 0 0
Apr  2 22:44:31 werner kernel: DMA: 17*4kB 28*8kB 27*16kB 
36*32kB 33*64kB 2*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 
0*4096kB = 4244kB
Apr  2 22:44:31 werner kernel: Normal: 2246*4kB 304*8kB 
145*16kB 74*32kB 26*64kB 13*128kB 6*256kB 3*512kB 1*1024kB 
0*2048kB 5*4096kB = 44008kB
Apr  2 22:44:31 werner kernel: HighMem: 2295*4kB 1191*8kB 
1081*16kB 1689*32kB 1273*64kB 522*128kB 213*256kB 
100*512kB 49*1024kB 24*2048kB 268*4096kB = 1541124kB
Apr  2 22:44:31 werner kernel: 63021 total pagecache pages
Apr  2 22:44:31 werner kernel: 0 pages in swap cache
Apr  2 22:44:31 werner kernel: Swap cache stats: add 0, 
delete 0, find 0/0
Apr  2 22:44:31 werner kernel: Free swap  = 0kB
Apr  2 22:44:31 werner kernel: Total swap = 0kB
Apr  2 22:44:31 werner kernel: 786128 pages RAM
Apr  2 22:44:31 werner kernel: 558818 pages HighMem
Apr  2 22:44:31 werner kernel: 13576 pages reserved
Apr  2 22:44:31 werner kernel: 134532 pages shared
Apr  2 22:44:31 werner kernel: 261572 pages non-shared
Apr  2 22:44:31 werner kernel: Out of memory: Kill process 
18282 (firefox-bin) score 46 or sacrifice child
Apr  2 22:44:31 werner kernel: Killed process 18282 
(firefox-bin) total-vm:465392kB, anon-rss:190668kB, 
file-rss:46608kB
Apr  2 22:44:31 werner kernel: X invoked oom-killer: 
gfp_mask=0xd0, order=0, oom_adj=0, oom_score_adj=0
Apr  2 22:44:31 werner kernel: Pid: 9607, comm: X Not 
tainted 3.4.0-rc1-i486-1sys #1
Apr  2 22:44:31 werner kernel: Call Trace:
Apr  2 22:44:31 werner kernel:  [<c10356cf>] ? 
printk+0x20/0x22
Apr  2 22:44:31 werner kernel:  [<c10af0f7>] 
dump_header+0x6f/0x95
Apr  2 22:44:31 werner kernel:  [<c10af30b>] 
oom_kill_process+0x52/0x251
Apr  2 22:44:31 werner kernel:  [<c10af5cf>] ? 
select_bad_process+0xc5/0x11c
Apr  2 22:44:31 werner kernel:  [<c10af76a>] 
out_of_memory+0x144/0x1b4
Apr  2 22:44:31 werner kernel:  [<c10b2468>] 
__alloc_pages_nodemask+0x501/0x63f
Apr  2 22:44:31 werner kernel:  [<c1053910>] ? 
__wake_up_common+0xe/0x62
Apr  2 22:44:31 werner kernel:  [<c10b25c2>] 
__get_free_pages+0x1c/0x2d
Apr  2 22:44:31 werner kernel:  [<c10f8f19>] 
poll_get_entry+0x48/0x75
Apr  2 22:44:31 werner kernel:  [<c10f8f5e>] 
__pollwait+0x18/0x4d
Apr  2 22:44:31 werner kernel:  [<c10f8f46>] ? 
poll_get_entry+0x75/0x75
Apr  2 22:44:31 werner kernel:  [<c1f69875>] 
unix_poll+0x1e/0x9f
Apr  2 22:44:31 werner kernel:  [<c1ee2613>] 
sock_poll+0x14/0x17
Apr  2 22:44:31 werner kernel:  [<c10f972d>] 
do_select+0x229/0x44b
Apr  2 22:44:31 werner kernel:  [<c10f8f46>] ? 
poll_get_entry+0x75/0x75
Apr  2 22:44:31 werner kernel:  [<c10f8fd9>] ? 
__pollwake+0x46/0x46
Apr  2 22:44:31 werner last message repeated 17 times
Apr  2 22:44:31 werner kernel:  [<c10f9add>] 
core_sys_select+0x18e/0x255
Apr  2 22:44:31 werner kernel:  [<c10509d3>] ? 
hrtimer_try_to_cancel+0x84/0x8d
Apr  2 22:44:31 werner kernel:  [<c1038b82>] ? 
set_normalized_timespec+0x9/0x43
Apr  2 22:44:31 werner kernel:  [<c1038b82>] ? 
set_normalized_timespec+0x9/0x43
Apr  2 22:44:31 werner kernel:  [<c1038de8>] ? 
timespec_add_safe+0x2f/0x4f
Apr  2 22:44:31 werner kernel:  [<c10f9d4a>] 
sys_select+0x79/0x96
Apr  2 22:44:31 werner kernel:  [<c2088cdc>] 
syscall_call+0x7/0xb
Apr  2 22:44:31 werner kernel: Mem-Info:
Apr  2 22:44:31 werner kernel: DMA per-cpu:
Apr  2 22:44:31 werner kernel: CPU    0: hi:    0, btch: 
  1 usd:   0
Apr  2 22:44:31 werner kernel: Normal per-cpu:
Apr  2 22:44:31 werner kernel: CPU    0: hi:  186, btch: 
 31 usd:  67
Apr  2 22:44:31 werner kernel: HighMem per-cpu:
Apr  2 22:44:31 werner kernel: CPU    0: hi:  186, btch: 
 31 usd: 157
Apr  2 22:44:31 werner kernel: active_anon:52212 
inactive_anon:29 isolated_anon:0
Apr  2 22:44:31 werner kernel:  active_file:29620 
inactive_file:32671 isolated_file:0
Apr  2 22:44:31 werner kernel:  unevictable:17 dirty:7 
writeback:0 unstable:0
Apr  2 22:44:31 werner kernel:  free:447698 
slab_reclaimable:3425 slab_unreclaimable:39149
Apr  2 22:44:31 werner kernel:  mapped:19633 shmem:688 
pagetables:582 bounce:0
Apr  2 22:44:31 werner kernel: DMA free:4244kB min:784kB 
low:980kB high:1176kB active_anon:0kB inactive_anon:0kB 
active_file:0kB inactive_file:0kB unevictable:0kB 
isolated(anon):0kB isolated(file):0kB present:15804kB 
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB 
slab_reclaimable:12kB slab_unreclaimable:1552kB 
kernel_stack:10040kB pagetables:0kB unstable:0kB 
bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? yes
Apr  2 22:44:31 werner kernel: lowmem_reserve[]: 0 865 
3031 3031
Apr  2 22:44:31 werner kernel: Normal free:43972kB 
min:44012kB low:55012kB high:66016kB active_anon:0kB 
inactive_anon:0kB active_file:140kB inactive_file:144kB 
unevictable:0kB isolated(anon):0kB isolated(file):0kB 
present:885944kB mlocked:0kB dirty:0kB writeback:0kB 
mapped:12kB shmem:0kB slab_reclaimable:13688kB 
slab_unreclaimable:155044kB kernel_stack:621240kB 
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB 
pages_scanned:491 all_unreclaimable? yes
Apr  2 22:44:31 werner kernel: lowmem_reserve[]: 0 0 17326 
17326
Apr  2 22:44:31 werner kernel: HighMem free:1742576kB 
min:512kB low:28056kB high:55600kB active_anon:208848kB 
inactive_anon:116kB active_file:118340kB 
inactive_file:130540kB unevictable:68kB isolated(anon):0kB 
isolated(file):0kB present:2217808kB mlocked:68kB 
dirty:28kB writeback:0kB mapped:78520kB shmem:2752kB 
slab_reclaimable:0kB slab_unreclaimable:0kB 
kernel_stack:0kB pagetables:2328kB unstable:0kB bounce:0kB 
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
Apr  2 22:44:31 werner kernel: lowmem_reserve[]: 0 0 0 0
Apr  2 22:44:31 werner kernel: DMA: 17*4kB 28*8kB 27*16kB 
36*32kB 33*64kB 2*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 
0*4096kB = 4244kB
Apr  2 22:44:31 werner kernel: Normal: 2253*4kB 296*8kB 
145*16kB 74*32kB 26*64kB 13*128kB 6*256kB 3*512kB 1*1024kB 
0*2048kB 5*4096kB = 43972kB
Apr  2 22:44:31 werner kernel: HighMem: 6166*4kB 4831*8kB 
2170*16kB 1812*32kB 1274*64kB 524*128kB 213*256kB 
100*512kB 49*1024kB 24*2048kB 301*4096kB = 1742576kB
Apr  2 22:44:31 werner kernel: 62980 total pagecache pages
Apr  2 22:44:31 werner kernel: 0 pages in swap cache
Apr  2 22:44:31 werner kernel: Swap cache stats: add 0, 
delete 0, find 0/0
Apr  2 22:44:31 werner kernel: Free swap  = 0kB
Apr  2 22:44:31 werner kernel: Total swap = 0kB
Apr  2 22:44:31 werner kernel: 786128 pages RAM
Apr  2 22:44:31 werner kernel: 558818 pages HighMem
Apr  2 22:44:31 werner kernel: 13576 pages reserved
Apr  2 22:44:31 werner kernel: 122853 pages shared
Apr  2 22:44:31 werner kernel: 217348 pages non-shared
Apr  2 22:44:31 werner kernel: Out of memory: Kill process 
11056 (httpd) score 4 or sacrifice child
Apr  2 22:44:31 werner kernel: Killed process 11056 
(httpd) total-vm:56696kB, anon-rss:9412kB, file-rss:3668kB
Apr  2 22:44:32 werner kernel: X invoked oom-killer: 
gfp_mask=0xd0, order=0, oom_adj=0, oom_score_adj=0
Apr  2 22:44:32 werner kernel: Pid: 9607, comm: X Not 
tainted 3.4.0-rc1-i486-1sys #1
Apr  2 22:44:33 werner kernel: Call Trace:
Apr  2 22:44:33 werner kernel:  [<c10356cf>] ? 
printk+0x20/0x22
Apr  2 22:44:33 werner kernel:  [<c10af0f7>] 
dump_header+0x6f/0x95
Apr  2 22:44:33 werner kernel:  [<c10af30b>] 
oom_kill_process+0x52/0x251
Apr  2 22:44:33 werner kernel:  [<c10af5cf>] ? 
select_bad_process+0xc5/0x11c
Apr  2 22:44:33 werner kernel:  [<c10af76a>] 
out_of_memory+0x144/0x1b4
Apr  2 22:44:33 werner kernel:  [<c10b2468>] 
__alloc_pages_nodemask+0x501/0x63f
Apr  2 22:44:33 werner kernel:  [<c1053910>] ? 
__wake_up_common+0xe/0x62
Apr  2 22:44:33 werner kernel:  [<c10b25c2>] 
__get_free_pages+0x1c/0x2d
Apr  2 22:44:33 werner kernel:  [<c10f8f19>] 
poll_get_entry+0x48/0x75
Apr  2 22:44:33 werner kernel:  [<c10f8f5e>] 
__pollwait+0x18/0x4d
Apr  2 22:44:33 werner kernel:  [<c10f8f46>] ? 
poll_get_entry+0x75/0x75
Apr  2 22:44:33 werner kernel:  [<c1f69875>] 
unix_poll+0x1e/0x9f
Apr  2 22:44:33 werner kernel:  [<c1ee2613>] 
sock_poll+0x14/0x17
Apr  2 22:44:33 werner kernel:  [<c10f972d>] 
do_select+0x229/0x44b
Apr  2 22:44:33 werner kernel:  [<c10f8f46>] ? 
poll_get_entry+0x75/0x75
Apr  2 22:44:33 werner kernel:  [<c10f8fd9>] ? 
__pollwake+0x46/0x46
Apr  2 22:44:33 werner last message repeated 17 times
Apr  2 22:44:33 werner kernel:  [<c10f9add>] 
core_sys_select+0x18e/0x255
Apr  2 22:44:33 werner kernel:  [<c10509d3>] ? 
hrtimer_try_to_cancel+0x84/0x8d
Apr  2 22:44:33 werner kernel:  [<c1038b82>] ? 
set_normalized_timespec+0x9/0x43
Apr  2 22:44:33 werner kernel:  [<c1038b82>] ? 
set_normalized_timespec+0x9/0x43
Apr  2 22:44:33 werner kernel:  [<c1038de8>] ? 
timespec_add_safe+0x2f/0x4f
Apr  2 22:44:33 werner kernel:  [<c10f9d4a>] 
sys_select+0x79/0x96
Apr  2 22:44:33 werner kernel:  [<c2088cdc>] 
syscall_call+0x7/0xb
Apr  2 22:44:33 werner kernel: Mem-Info:
Apr  2 22:44:33 werner kernel: DMA per-cpu:
Apr  2 22:44:33 werner kernel: CPU    0: hi:    0, btch: 
  1 usd:   0
Apr  2 22:44:33 werner kernel: Normal per-cpu:
Apr  2 22:44:33 werner kernel: CPU    0: hi:  186, btch: 
 31 usd:  32
Apr  2 22:44:33 werner kernel: HighMem per-cpu:
Apr  2 22:44:33 werner kernel: CPU    0: hi:  186, btch: 
 31 usd:   0
Apr  2 22:44:33 werner kernel: active_anon:50994 
inactive_anon:29 isolated_anon:0
Apr  2 22:44:33 werner kernel:  active_file:29761 
inactive_file:32830 isolated_file:0
Apr  2 22:44:33 werner kernel:  unevictable:17 dirty:0 
writeback:7 unstable:0
Apr  2 22:44:33 werner kernel:  free:448796 
slab_reclaimable:3425 slab_unreclaimable:39145
Apr  2 22:44:33 werner kernel:  mapped:19632 shmem:688 
pagetables:574 bounce:0
Apr  2 22:44:33 werner kernel: DMA free:4244kB min:784kB 
low:980kB high:1176kB active_anon:0kB inactive_anon:0kB 
active_file:0kB inactive_file:0kB unevictable:0kB 
isolated(anon):0kB isolated(file):0kB present:15804kB 
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB 
slab_reclaimable:12kB slab_unreclaimable:1552kB 
kernel_stack:10040kB pagetables:0kB unstable:0kB 
bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? yes
Apr  2 22:44:33 werner kernel: lowmem_reserve[]: 0 865 
3031 3031
Apr  2 22:44:33 werner kernel: Normal free:44000kB 
min:44012kB low:55012kB high:66016kB active_anon:0kB 
inactive_anon:0kB active_file:156kB inactive_file:184kB 
unevictable:0kB isolated(anon):0kB isolated(file):0kB 
present:885944kB mlocked:0kB dirty:0kB writeback:0kB 
mapped:12kB shmem:0kB slab_reclaimable:13688kB 
slab_unreclaimable:155028kB kernel_stack:621264kB 
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB 
pages_scanned:546 all_unreclaimable? yes
Apr  2 22:44:33 werner kernel: lowmem_reserve[]: 0 0 17326 
17326
Apr  2 22:44:33 werner kernel: HighMem free:1746940kB 
min:512kB low:28056kB high:55600kB active_anon:203976kB 
inactive_anon:116kB active_file:118888kB 
inactive_file:131136kB unevictable:68kB isolated(anon):0kB 
isolated(file):0kB present:2217808kB mlocked:68kB 
dirty:0kB writeback:28kB mapped:78516kB shmem:2752kB 
slab_reclaimable:0kB slab_unreclaimable:0kB 
kernel_stack:0kB pagetables:2296kB unstable:0kB bounce:0kB 
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
Apr  2 22:44:33 werner kernel: lowmem_reserve[]: 0 0 0 0
Apr  2 22:44:33 werner kernel: DMA: 17*4kB 28*8kB 27*16kB 
36*32kB 33*64kB 2*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 
0*4096kB = 4244kB
Apr  2 22:44:33 werner kernel: Normal: 2286*4kB 283*8kB 
143*16kB 77*32kB 27*64kB 12*128kB 6*256kB 3*512kB 1*1024kB 
0*2048kB 5*4096kB = 44000kB
Apr  2 22:44:33 werner kernel: HighMem: 5983*4kB 4944*8kB 
2300*16kB 1836*32kB 1287*64kB 526*128kB 214*256kB 
100*512kB 49*1024kB 24*2048kB 301*4096kB = 1746940kB
Apr  2 22:44:33 werner kernel: 63286 total pagecache pages
Apr  2 22:44:33 werner kernel: 0 pages in swap cache
Apr  2 22:44:33 werner kernel: Swap cache stats: add 0, 
delete 0, find 0/0
Apr  2 22:44:33 werner kernel: Free swap  = 0kB
Apr  2 22:44:33 werner kernel: Total swap = 0kB
Apr  2 22:44:33 werner kernel: 786128 pages RAM
Apr  2 22:44:33 werner kernel: 558818 pages HighMem
Apr  2 22:44:33 werner kernel: 13576 pages reserved
Apr  2 22:44:33 werner kernel: 120829 pages shared
Apr  2 22:44:33 werner kernel: 216409 pages non-shared
Apr  2 22:44:33 werner kernel: Out of memory: Kill process 
11197 (httpd) score 4 or sacrifice child
Apr  2 22:44:33 werner kernel: Killed process 11197 
(httpd) total-vm:57228kB, anon-rss:9948kB, file-rss:3636kB
Apr  2 22:44:33 werner kernel: X invoked oom-killer: 
gfp_mask=0xd0, order=0, oom_adj=0, oom_score_adj=0
Apr  2 22:44:33 werner kernel: Pid: 9607, comm: X Not 
tainted 3.4.0-rc1-i486-1sys #1
Apr  2 22:44:33 werner kernel: Call Trace:
Apr  2 22:44:33 werner kernel:  [<c10356cf>] ? 
printk+0x20/0x22
Apr  2 22:44:33 werner kernel:  [<c10af0f7>] 
dump_header+0x6f/0x95
Apr  2 22:44:33 werner kernel:  [<c10af30b>] 
oom_kill_process+0x52/0x251
Apr  2 22:44:33 werner kernel:  [<c10af5cf>] ? 
select_bad_process+0xc5/0x11c
Apr  2 22:44:33 werner kernel:  [<c10af76a>] 
out_of_memory+0x144/0x1b4
Apr  2 22:44:33 werner kernel:  [<c10b2468>] 
__alloc_pages_nodemask+0x501/0x63f
Apr  2 22:44:33 werner kernel:  [<c1053910>] ? 
__wake_up_common+0xe/0x62
Apr  2 22:44:33 werner kernel:  [<c10b25c2>] 
__get_free_pages+0x1c/0x2d
Apr  2 22:44:33 werner kernel:  [<c10f8f19>] 
poll_get_entry+0x48/0x75
Apr  2 22:44:33 werner kernel:  [<c10f8f5e>] 
__pollwait+0x18/0x4d
Apr  2 22:44:33 werner kernel:  [<c10f8f46>] ? 
poll_get_entry+0x75/0x75
Apr  2 22:44:33 werner kernel:  [<c1f69875>] 
unix_poll+0x1e/0x9f
Apr  2 22:44:33 werner kernel:  [<c1ee2613>] 
sock_poll+0x14/0x17
Apr  2 22:44:33 werner kernel:  [<c10f972d>] 
do_select+0x229/0x44b
Apr  2 22:44:33 werner kernel:  [<c10f8f46>] ? 
poll_get_entry+0x75/0x75
Apr  2 22:44:33 werner kernel:  [<c10f8fd9>] ? 
__pollwake+0x46/0x46
Apr  2 22:44:33 werner last message repeated 17 times
Apr  2 22:44:33 werner kernel:  [<c10f9add>] 
core_sys_select+0x18e/0x255
Apr  2 22:44:33 werner kernel:  [<c10509d3>] ? 
hrtimer_try_to_cancel+0x84/0x8d
Apr  2 22:44:33 werner kernel:  [<c1038b82>] ? 
set_normalized_timespec+0x9/0x43
Apr  2 22:44:33 werner kernel:  [<c1038b82>] ? 
set_normalized_timespec+0x9/0x43
Apr  2 22:44:33 werner kernel:  [<c1038de8>] ? 
timespec_add_safe+0x2f/0x4f
Apr  2 22:44:33 werner kernel:  [<c10f9d4a>] 
sys_select+0x79/0x96
Apr  2 22:44:33 werner kernel:  [<c2088cdc>] 
syscall_call+0x7/0xb
Apr  2 22:44:33 werner kernel: Mem-Info:
Apr  2 22:44:33 werner kernel: DMA per-cpu:
Apr  2 22:44:33 werner kernel: CPU    0: hi:    0, btch: 
  1 usd:   0
Apr  2 22:44:33 werner kernel: Normal per-cpu:
Apr  2 22:44:33 werner kernel: CPU    0: hi:  186, btch: 
 31 usd:  35
Apr  2 22:44:33 werner kernel: HighMem per-cpu:
Apr  2 22:44:33 werner kernel: CPU    0: hi:  186, btch: 
 31 usd: 156
Apr  2 22:44:33 werner kernel: active_anon:49642 
inactive_anon:29 isolated_anon:0
Apr  2 22:44:33 werner kernel:  active_file:29840 
inactive_file:32751 isolated_file:0
Apr  2 22:44:33 werner kernel:  unevictable:17 dirty:0 
writeback:7 unstable:0
Apr  2 22:44:33 werner kernel:  free:450005 
slab_reclaimable:3425 slab_unreclaimable:39145
Apr  2 22:44:33 werner kernel:  mapped:19632 shmem:688 
pagetables:574 bounce:0
Apr  2 22:44:33 werner kernel: DMA free:4244kB min:784kB 
low:980kB high:1176kB active_anon:0kB inactive_anon:0kB 
active_file:0kB inactive_file:0kB unevictable:0kB 
isolated(anon):0kB isolated(file):0kB present:15804kB 
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB 
slab_reclaimable:12kB slab_unreclaimable:1552kB 
kernel_stack:10040kB pagetables:0kB unstable:0kB 
bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? yes
Apr  2 22:44:33 werner kernel: lowmem_reserve[]: 0 865 
3031 3031
Apr  2 22:44:33 werner kernel: Normal free:44000kB 
min:44012kB low:55012kB high:66016kB active_anon:0kB 
inactive_anon:0kB active_file:160kB inactive_file:180kB 
unevictable:0kB isolated(anon):0kB isolated(file):0kB 
present:885944kB mlocked:0kB dirty:0kB writeback:0kB 
mapped:12kB shmem:0kB slab_reclaimable:13688kB 
slab_unreclaimable:155028kB kernel_stack:621264kB 
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB 
pages_scanned:610 all_unreclaimable? yes
Apr  2 22:44:33 werner kernel: lowmem_reserve[]: 0 0 17326 
17326
Apr  2 22:44:33 werner kernel: HighMem free:1751776kB 
min:512kB low:28056kB high:55600kB active_anon:198568kB 
inactive_anon:116kB active_file:119200kB 
inactive_file:130824kB unevictable:68kB isolated(anon):0kB 
isolated(file):0kB present:2217808kB mlocked:68kB 
dirty:0kB writeback:28kB mapped:78516kB shmem:2752kB 
slab_reclaimable:0kB slab_unreclaimable:0kB 
kernel_stack:0kB pagetables:2296kB unstable:0kB bounce:0kB 
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
Apr  2 22:44:33 werner kernel: lowmem_reserve[]: 0 0 0 0
Apr  2 22:44:33 werner kernel: DMA: 17*4kB 28*8kB 27*16kB 
36*32kB 33*64kB 2*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 
0*4096kB = 4244kB
Apr  2 22:44:33 werner kernel: Normal: 2286*4kB 283*8kB 
143*16kB 77*32kB 27*64kB 12*128kB 6*256kB 3*512kB 1*1024kB 
0*2048kB 5*4096kB = 44000kB
Apr  2 22:44:33 werner kernel: HighMem: 6182*4kB 4971*8kB 
2333*16kB 1851*32kB 1323*64kB 528*128kB 215*256kB 
100*512kB 49*1024kB 24*2048kB 301*4096kB = 1751776kB
Apr  2 22:44:33 werner kernel: 63286 total pagecache pages
Apr  2 22:44:33 werner kernel: 0 pages in swap cache
Apr  2 22:44:33 werner kernel: Swap cache stats: add 0, 
delete 0, find 0/0
Apr  2 22:44:33 werner kernel: Free swap  = 0kB
Apr  2 22:44:33 werner kernel: Total swap = 0kB
Apr  2 22:44:33 werner kernel: 786128 pages RAM
Apr  2 22:44:33 werner kernel: 558818 pages HighMem
Apr  2 22:44:33 werner kernel: 13576 pages reserved
Apr  2 22:44:33 werner kernel: 118789 pages shared
Apr  2 22:44:33 werner kernel: 215041 pages non-shared
Apr  2 22:44:33 werner kernel: Out of memory: Kill process 
11211 (httpd) score 4 or sacrifice child
Apr  2 22:44:33 werner kernel: Killed process 11211 
(httpd) total-vm:56176kB, anon-rss:8900kB, file-rss:3636kB
Apr  2 22:44:33 werner kernel: X invoked oom-killer: 
gfp_mask=0xd0, order=0, oom_adj=0, oom_score_adj=0
Apr  2 22:44:33 werner kernel: Pid: 9607, comm: X Not 
tainted 3.4.0-rc1-i486-1sys #1
Apr  2 22:44:33 werner kernel: Call Trace:
Apr  2 22:44:33 werner kernel:  [<c10356cf>] ? 
printk+0x20/0x22
Apr  2 22:44:33 werner kernel:  [<c10af0f7>] 
dump_header+0x6f/0x95
Apr  2 22:44:33 werner kernel:  [<c10af30b>] 
oom_kill_process+0x52/0x251
Apr  2 22:44:33 werner kernel:  [<c10af5cf>] ? 
select_bad_process+0xc5/0x11c
Apr  2 22:44:33 werner kernel:  [<c10af76a>] 
out_of_memory+0x144/0x1b4
Apr  2 22:44:33 werner kernel:  [<c10b2468>] 
__alloc_pages_nodemask+0x501/0x63f
Apr  2 22:44:33 werner kernel:  [<c1053910>] ? 
__wake_up_common+0xe/0x62
Apr  2 22:44:33 werner kernel:  [<c10b25c2>] 
__get_free_pages+0x1c/0x2d
Apr  2 22:44:33 werner kernel:  [<c10f8f19>] 
poll_get_entry+0x48/0x75
Apr  2 22:44:33 werner kernel:  [<c10f8f5e>] 
__pollwait+0x18/0x4d
Apr  2 22:44:33 werner kernel:  [<c10f8f46>] ? 
poll_get_entry+0x75/0x75
Apr  2 22:44:33 werner kernel:  [<c1f69875>] 
unix_poll+0x1e/0x9f
Apr  2 22:44:33 werner kernel:  [<c1ee2613>] 
sock_poll+0x14/0x17
Apr  2 22:44:33 werner kernel:  [<c10f972d>] 
do_select+0x229/0x44b
Apr  2 22:44:33 werner kernel:  [<c10f8f46>] ? 
poll_get_entry+0x75/0x75
Apr  2 22:44:33 werner kernel:  [<c10f8fd9>] ? 
__pollwake+0x46/0x46
Apr  2 22:44:33 werner last message repeated 17 times
Apr  2 22:44:33 werner kernel:  [<c10f9add>] 
core_sys_select+0x18e/0x255
Apr  2 22:44:33 werner kernel:  [<c10509d3>] ? 
hrtimer_try_to_cancel+0x84/0x8d
Apr  2 22:44:33 werner kernel:  [<c1038b82>] ? 
set_normalized_timespec+0x9/0x43
Apr  2 22:44:33 werner kernel:  [<c1038b82>] ? 
set_normalized_timespec+0x9/0x43
Apr  2 22:44:33 werner kernel:  [<c1038de8>] ? 
timespec_add_safe+0x2f/0x4f
Apr  2 22:44:33 werner kernel:  [<c10f9d4a>] 
sys_select+0x79/0x96
Apr  2 22:44:33 werner kernel:  [<c2088cdc>] 
syscall_call+0x7/0xb
Apr  2 22:44:33 werner kernel: Mem-Info:
Apr  2 22:44:33 werner kernel: DMA per-cpu:
Apr  2 22:44:33 werner kernel: CPU    0: hi:    0, btch: 
  1 usd:   0
Apr  2 22:44:33 werner kernel: Normal per-cpu:
Apr  2 22:44:33 werner kernel: CPU    0: hi:  186, btch: 
 31 usd:  51
Apr  2 22:44:33 werner kernel: HighMem per-cpu:
Apr  2 22:44:33 werner kernel: CPU    0: hi:  186, btch: 
 31 usd: 174
Apr  2 22:44:33 werner kernel: active_anon:48550 
inactive_anon:29 isolated_anon:0
Apr  2 22:44:33 werner kernel:  active_file:29838 
inactive_file:32751 isolated_file:0
Apr  2 22:44:33 werner kernel:  unevictable:17 dirty:0 
writeback:7 unstable:0
Apr  2 22:44:33 werner kernel:  free:451090 
slab_reclaimable:3425 slab_unreclaimable:39136
Apr  2 22:44:33 werner kernel:  mapped:19632 shmem:688 
pagetables:555 bounce:0
Apr  2 22:44:33 werner kernel: DMA free:4244kB min:784kB 
low:980kB high:1176kB active_anon:0kB inactive_anon:0kB 
active_file:0kB inactive_file:0kB unevictable:0kB 
isolated(anon):0kB isolated(file):0kB present:15804kB 
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB 
slab_reclaimable:12kB slab_unreclaimable:1552kB 
kernel_stack:10040kB pagetables:0kB unstable:0kB 
bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? yes
Apr  2 22:44:33 werner kernel: lowmem_reserve[]: 0 865 
3031 3031
Apr  2 22:44:33 werner kernel: Normal free:44000kB 
min:44012kB low:55012kB high:66016kB active_anon:0kB 
inactive_anon:0kB active_file:152kB inactive_file:180kB 
unevictable:0kB isolated(anon):0kB isolated(file):0kB 
present:885944kB mlocked:0kB dirty:0kB writeback:0kB 
mapped:12kB shmem:0kB slab_reclaimable:13688kB 
slab_unreclaimable:154992kB kernel_stack:621264kB 
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB 
pages_scanned:674 all_unreclaimable? yes
Apr  2 22:44:33 werner kernel: lowmem_reserve[]: 0 0 17326 
17326
Apr  2 22:44:33 werner kernel: HighMem free:1756116kB 
min:512kB low:28056kB high:55600kB active_anon:194200kB 
inactive_anon:116kB active_file:119200kB 
inactive_file:130824kB unevictable:68kB isolated(anon):0kB 
isolated(file):0kB present:2217808kB mlocked:68kB 
dirty:0kB writeback:28kB mapped:78516kB shmem:2752kB 
slab_reclaimable:0kB slab_unreclaimable:0kB 
kernel_stack:0kB pagetables:2220kB unstable:0kB bounce:0kB 
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
Apr  2 22:44:33 werner kernel: lowmem_reserve[]: 0 0 0 0
Apr  2 22:44:33 werner kernel: DMA: 17*4kB 28*8kB 27*16kB 
36*32kB 33*64kB 2*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 
0*4096kB = 4244kB
Apr  2 22:44:33 werner kernel: Normal: 2286*4kB 283*8kB 
143*16kB 77*32kB 27*64kB 12*128kB 6*256kB 3*512kB 1*1024kB 
0*2048kB 5*4096kB = 44000kB
Apr  2 22:44:33 werner kernel: HighMem: 6583*4kB 5053*8kB 
2393*16kB 1872*32kB 1328*64kB 529*128kB 215*256kB 
100*512kB 49*1024kB 24*2048kB 301*4096kB = 1756116kB
Apr  2 22:44:33 werner kernel: 63286 total pagecache pages
Apr  2 22:44:33 werner kernel: 0 pages in swap cache
Apr  2 22:44:33 werner kernel: Swap cache stats: add 0, 
delete 0, find 0/0
Apr  2 22:44:33 werner kernel: Free swap  = 0kB
Apr  2 22:44:33 werner kernel: Total swap = 0kB
Apr  2 22:44:33 werner kernel: 786128 pages RAM
Apr  2 22:44:33 werner kernel: 558818 pages HighMem
Apr  2 22:44:33 werner kernel: 13576 pages reserved
Apr  2 22:44:33 werner kernel: 116748 pages shared
Apr  2 22:44:33 werner kernel: 213924 pages non-shared
Apr  2 22:44:33 werner kernel: Out of memory: Kill process 
10121 (named) score 3 or sacrifice child
Apr  2 22:44:33 werner kernel: Killed process 10121 
(named) total-vm:40788kB, anon-rss:9268kB, file-rss:2440kB
Apr  2 22:44:34 werner kernel: X invoked oom-killer: 
gfp_mask=0xd0, order=0, oom_adj=0, oom_score_adj=0
Apr  2 22:44:34 werner kernel: Pid: 9607, comm: X Not 
tainted 3.4.0-rc1-i486-1sys #1
Apr  2 22:44:34 werner kernel: Call Trace:
Apr  2 22:44:34 werner kernel:  [<c10356cf>] ? 
printk+0x20/0x22
Apr  2 22:44:34 werner kernel:  [<c10af0f7>] 
dump_header+0x6f/0x95
Apr  2 22:44:34 werner kernel:  [<c10af30b>] 
oom_kill_process+0x52/0x251
Apr  2 22:44:34 werner kernel:  [<c10af5cf>] ? 
select_bad_process+0xc5/0x11c
Apr  2 22:44:34 werner kernel:  [<c10af76a>] 
out_of_memory+0x144/0x1b4
Apr  2 22:44:34 werner kernel:  [<c10b2468>] 
__alloc_pages_nodemask+0x501/0x63f
Apr  2 22:44:34 werner kernel:  [<c1053910>] ? 
__wake_up_common+0xe/0x62
Apr  2 22:44:34 werner kernel:  [<c10b25c2>] 
__get_free_pages+0x1c/0x2d
Apr  2 22:44:34 werner kernel:  [<c10f8f19>] 
poll_get_entry+0x48/0x75
Apr  2 22:44:34 werner kernel:  [<c10f8f5e>] 
__pollwait+0x18/0x4d
Apr  2 22:44:34 werner kernel:  [<c10f8f46>] ? 
poll_get_entry+0x75/0x75
Apr  2 22:44:34 werner kernel:  [<c1f69875>] 
unix_poll+0x1e/0x9f
Apr  2 22:44:34 werner kernel:  [<c1ee2613>] 
sock_poll+0x14/0x17
Apr  2 22:44:34 werner kernel:  [<c10f972d>] 
do_select+0x229/0x44b
Apr  2 22:44:34 werner kernel:  [<c10f8f46>] ? 
poll_get_entry+0x75/0x75
Apr  2 22:44:34 werner kernel:  [<c10f8fd9>] ? 
__pollwake+0x46/0x46
Apr  2 22:44:34 werner last message repeated 17 times
Apr  2 22:44:34 werner kernel:  [<c10f9add>] 
core_sys_select+0x18e/0x255
Apr  2 22:44:34 werner kernel:  [<c10509d3>] ? 
hrtimer_try_to_cancel+0x84/0x8d
Apr  2 22:44:34 werner kernel:  [<c1038b82>] ? 
set_normalized_timespec+0x9/0x43
Apr  2 22:44:34 werner kernel:  [<c1038b82>] ? 
set_normalized_timespec+0x9/0x43
Apr  2 22:44:34 werner kernel:  [<c1038de8>] ? 
timespec_add_safe+0x2f/0x4f
Apr  2 22:44:34 werner kernel:  [<c10f9d4a>] 
sys_select+0x79/0x96
Apr  2 22:44:34 werner kernel:  [<c2088cdc>] 
syscall_call+0x7/0xb
Apr  2 22:44:34 werner kernel: Mem-Info:
Apr  2 22:44:34 werner kernel: DMA per-cpu:
Apr  2 22:44:34 werner kernel: CPU    0: hi:    0, btch: 
  1 usd:   0
Apr  2 22:44:34 werner kernel: Normal per-cpu:
Apr  2 22:44:34 werner kernel: CPU    0: hi:  186, btch: 
 31 usd:  63
Apr  2 22:44:34 werner kernel: HighMem per-cpu:
Apr  2 22:44:34 werner kernel: CPU    0: hi:  186, btch: 
 31 usd:   0
Apr  2 22:44:34 werner kernel: active_anon:46164 
inactive_anon:29 isolated_anon:0
Apr  2 22:44:34 werner kernel:  active_file:29896 
inactive_file:32690 isolated_file:0
Apr  2 22:44:34 werner kernel:  unevictable:17 dirty:9 
writeback:0 unstable:0
Apr  2 22:44:34 werner kernel:  free:453646 
slab_reclaimable:3417 slab_unreclaimable:39125
Apr  2 22:44:34 werner kernel:  mapped:19206 shmem:688 
pagetables:547 bounce:0
Apr  2 22:44:34 werner kernel: DMA free:4244kB min:784kB 
low:980kB high:1176kB active_anon:0kB inactive_anon:0kB 
active_file:0kB inactive_file:0kB unevictable:0kB 
isolated(anon):0kB isolated(file):0kB present:15804kB 
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB 
slab_reclaimable:12kB slab_unreclaimable:1552kB 
kernel_stack:10040kB pagetables:0kB unstable:0kB 
bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? yes
Apr  2 22:44:34 werner kernel: lowmem_reserve[]: 0 865 
3031 3031
Apr  2 22:44:34 werner kernel: Normal free:43992kB 
min:44012kB low:55012kB high:66016kB active_anon:0kB 
inactive_anon:0kB active_file:160kB inactive_file:132kB 
unevictable:0kB isolated(anon):0kB isolated(file):0kB 
present:885944kB mlocked:0kB dirty:0kB writeback:0kB 
mapped:12kB shmem:0kB slab_reclaimable:13656kB 
slab_unreclaimable:154948kB kernel_stack:621352kB 
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB 
pages_scanned:484 all_unreclaimable? yes
Apr  2 22:44:34 werner kernel: lowmem_reserve[]: 0 0 17326 
17326
Apr  2 22:44:34 werner kernel: HighMem free:1766348kB 
min:512kB low:28056kB high:55600kB active_anon:184656kB 
inactive_anon:116kB active_file:119424kB 
inactive_file:130628kB unevictable:68kB isolated(anon):0kB 
isolated(file):0kB present:2217808kB mlocked:68kB 
dirty:36kB writeback:0kB mapped:76812kB shmem:2752kB 
slab_reclaimable:0kB slab_unreclaimable:0kB 
kernel_stack:0kB pagetables:2188kB unstable:0kB bounce:0kB 
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
Apr  2 22:44:34 werner kernel: lowmem_reserve[]: 0 0 0 0
Apr  2 22:44:34 werner kernel: DMA: 17*4kB 28*8kB 27*16kB 
36*32kB 33*64kB 2*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 
0*4096kB = 4244kB
Apr  2 22:44:34 werner kernel: Normal: 2282*4kB 290*8kB 
144*16kB 77*32kB 26*64kB 12*128kB 6*256kB 3*512kB 1*1024kB 
0*2048kB 5*4096kB = 43992kB
Apr  2 22:44:34 werner kernel: HighMem: 6653*4kB 5101*8kB 
2429*16kB 1893*32kB 1336*64kB 536*128kB 220*256kB 
103*512kB 49*1024kB 24*2048kB 302*4096kB = 1766348kB
Apr  2 22:44:34 werner kernel: 63283 total pagecache pages
Apr  2 22:44:34 werner kernel: 0 pages in swap cache
Apr  2 22:44:34 werner kernel: Swap cache stats: add 0, 
delete 0, find 0/0
Apr  2 22:44:34 werner kernel: Free swap  = 0kB
Apr  2 22:44:34 werner kernel: Total swap = 0kB
Apr  2 22:44:34 werner kernel: 786128 pages RAM
Apr  2 22:44:34 werner kernel: 558818 pages HighMem
Apr  2 22:44:34 werner kernel: 13576 pages reserved
Apr  2 22:44:34 werner kernel: 116107 pages shared
Apr  2 22:44:34 werner kernel: 211949 pages non-shared
Apr  2 22:44:34 werner kernel: Out of memory: Kill process 
11049 (httpd) score 3 or sacrifice child
Apr  2 22:44:34 werner kernel: Killed process 11049 
(httpd) total-vm:55932kB, anon-rss:8628kB, file-rss:3632kB
Apr  2 22:44:34 werner kernel: X invoked oom-killer: 
gfp_mask=0xd0, order=0, oom_adj=0, oom_score_adj=0
Apr  2 22:44:34 werner kernel: Pid: 9607, comm: X Not 
tainted 3.4.0-rc1-i486-1sys #1
Apr  2 22:44:34 werner kernel: Call Trace:
Apr  2 22:44:34 werner kernel:  [<c10356cf>] ? 
printk+0x20/0x22
Apr  2 22:44:34 werner kernel:  [<c10af0f7>] 
dump_header+0x6f/0x95
Apr  2 22:44:34 werner kernel:  [<c10af30b>] 
oom_kill_process+0x52/0x251
Apr  2 22:44:34 werner kernel:  [<c10af5cf>] ? 
select_bad_process+0xc5/0x11c
Apr  2 22:44:34 werner kernel:  [<c10af76a>] 
out_of_memory+0x144/0x1b4
Apr  2 22:44:34 werner kernel:  [<c10b2468>] 
__alloc_pages_nodemask+0x501/0x63f
Apr  2 22:44:34 werner kernel:  [<c1053910>] ? 
__wake_up_common+0xe/0x62
Apr  2 22:44:34 werner kernel:  [<c10b25c2>] 
__get_free_pages+0x1c/0x2d
Apr  2 22:44:34 werner kernel:  [<c10f8f19>] 
poll_get_entry+0x48/0x75
Apr  2 22:44:34 werner kernel:  [<c10f8f5e>] 
__pollwait+0x18/0x4d
Apr  2 22:44:34 werner kernel:  [<c10f8f46>] ? 
poll_get_entry+0x75/0x75
Apr  2 22:44:34 werner kernel:  [<c1f69875>] 
unix_poll+0x1e/0x9f
Apr  2 22:44:34 werner kernel:  [<c1ee2613>] 
sock_poll+0x14/0x17
Apr  2 22:44:34 werner kernel:  [<c10f972d>] 
do_select+0x229/0x44b
Apr  2 22:44:34 werner kernel:  [<c10f8f46>] ? 
poll_get_entry+0x75/0x75
Apr  2 22:44:34 werner kernel:  [<c10f8fd9>] ? 
__pollwake+0x46/0x46
Apr  2 22:44:34 werner last message repeated 17 times
Apr  2 22:44:34 werner kernel:  [<c10f9add>] 
core_sys_select+0x18e/0x255
Apr  2 22:44:34 werner kernel:  [<c10509d3>] ? 
hrtimer_try_to_cancel+0x84/0x8d
Apr  2 22:44:34 werner kernel:  [<c1038b82>] ? 
set_normalized_timespec+0x9/0x43
Apr  2 22:44:34 werner kernel:  [<c1038b82>] ? 
set_normalized_timespec+0x9/0x43
Apr  2 22:44:34 werner kernel:  [<c1038de8>] ? 
timespec_add_safe+0x2f/0x4f
Apr  2 22:44:34 werner kernel:  [<c10f9d4a>] 
sys_select+0x79/0x96
Apr  2 22:44:34 werner kernel:  [<c2088cdc>] 
syscall_call+0x7/0xb
Apr  2 22:44:34 werner kernel: Mem-Info:
Apr  2 22:44:34 werner kernel: DMA per-cpu:
Apr  2 22:44:34 werner kernel: CPU    0: hi:    0, btch: 
  1 usd:   0
Apr  2 22:44:34 werner kernel: Normal per-cpu:
Apr  2 22:44:34 werner kernel: CPU    0: hi:  186, btch: 
 31 usd:  82
Apr  2 22:44:34 werner kernel: HighMem per-cpu:
Apr  2 22:44:34 werner kernel: CPU    0: hi:  186, btch: 
 31 usd: 165
Apr  2 22:44:34 werner kernel: active_anon:45137 
inactive_anon:29 isolated_anon:0
Apr  2 22:44:34 werner kernel:  active_file:29893 
inactive_file:32689 isolated_file:0
Apr  2 22:44:34 werner kernel:  unevictable:17 dirty:9 
writeback:0 unstable:0
Apr  2 22:44:34 werner kernel:  free:454514 
slab_reclaimable:3417 slab_unreclaimable:39116
Apr  2 22:44:34 werner kernel:  mapped:19206 shmem:688 
pagetables:547 bounce:0
Apr  2 22:44:34 werner kernel: DMA free:4244kB min:784kB 
low:980kB high:1176kB active_anon:0kB inactive_anon:0kB 
active_file:0kB inactive_file:0kB unevictable:0kB 
isolated(anon):0kB isolated(file):0kB present:15804kB 
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB 
slab_reclaimable:12kB slab_unreclaimable:1552kB 
kernel_stack:10040kB pagetables:0kB unstable:0kB 
bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? yes
Apr  2 22:44:34 werner kernel: lowmem_reserve[]: 0 865 
3031 3031
Apr  2 22:44:34 werner kernel: Normal free:43992kB 
min:44012kB low:55012kB high:66016kB active_anon:0kB 
inactive_anon:0kB active_file:148kB inactive_file:128kB 
unevictable:0kB isolated(anon):0kB isolated(file):0kB 
present:885944kB mlocked:0kB dirty:0kB writeback:0kB 
mapped:12kB shmem:0kB slab_reclaimable:13656kB 
slab_unreclaimable:154912kB kernel_stack:621352kB 
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB 
pages_scanned:675 all_unreclaimable? yes
Apr  2 22:44:34 werner kernel: lowmem_reserve[]: 0 0 17326 
17326
Apr  2 22:44:34 werner kernel: HighMem free:1769820kB 
min:512kB low:28056kB high:55600kB active_anon:180548kB 
inactive_anon:116kB active_file:119424kB 
inactive_file:130628kB unevictable:68kB isolated(anon):0kB 
isolated(file):0kB present:2217808kB mlocked:68kB 
dirty:36kB writeback:0kB mapped:76812kB shmem:2752kB 
slab_reclaimable:0kB slab_unreclaimable:0kB 
kernel_stack:0kB pagetables:2188kB unstable:0kB bounce:0kB 
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
Apr  2 22:44:34 werner kernel: lowmem_reserve[]: 0 0 0 0
Apr  2 22:44:34 werner kernel: DMA: 17*4kB 28*8kB 27*16kB 
36*32kB 33*64kB 2*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 
0*4096kB = 4244kB
Apr  2 22:44:34 werner kernel: Normal: 2282*4kB 290*8kB 
144*16kB 77*32kB 26*64kB 12*128kB 6*256kB 3*512kB 1*1024kB 
0*2048kB 5*4096kB = 43992kB
Apr  2 22:44:34 werner kernel: HighMem: 6841*4kB 5249*8kB 
2467*16kB 1906*32kB 1336*64kB 538*128kB 221*256kB 
103*512kB 49*1024kB 24*2048kB 302*4096kB = 1769820kB
Apr  2 22:44:34 werner kernel: 63283 total pagecache pages
Apr  2 22:44:34 werner kernel: 0 pages in swap cache
Apr  2 22:44:34 werner kernel: Swap cache stats: add 0, 
delete 0, find 0/0
Apr  2 22:44:34 werner kernel: Free swap  = 0kB
Apr  2 22:44:34 werner kernel: Total swap = 0kB
Apr  2 22:44:34 werner kernel: 786128 pages RAM
Apr  2 22:44:34 werner kernel: 558818 pages HighMem
Apr  2 22:44:34 werner kernel: 13576 pages reserved
Apr  2 22:44:34 werner kernel: 114067 pages shared
Apr  2 22:44:34 werner kernel: 210899 pages non-shared
Apr  2 22:44:34 werner kernel: Out of memory: Kill process 
11050 (httpd) score 3 or sacrifice child
Apr  2 22:44:34 werner kernel: Killed process 11050 
(httpd) total-vm:55932kB, anon-rss:8636kB, file-rss:3636kB
Apr  2 22:44:36 werner kernel: X invoked oom-killer: 
gfp_mask=0xd0, order=0, oom_adj=0, oom_score_adj=0
Apr  2 22:44:36 werner kernel: Pid: 9607, comm: X Not 
tainted 3.4.0-rc1-i486-1sys #1
Apr  2 22:44:36 werner kernel: Call Trace:
Apr  2 22:44:36 werner kernel:  [<c10356cf>] ? 
printk+0x20/0x22
Apr  2 22:44:36 werner kernel:  [<c10af0f7>] 
dump_header+0x6f/0x95
Apr  2 22:44:36 werner kernel:  [<c10af30b>] 
oom_kill_process+0x52/0x251
Apr  2 22:44:36 werner kernel:  [<c10af5cf>] ? 
select_bad_process+0xc5/0x11c
Apr  2 22:44:36 werner kernel:  [<c10af76a>] 
out_of_memory+0x144/0x1b4
Apr  2 22:44:36 werner kernel:  [<c10b2468>] 
__alloc_pages_nodemask+0x501/0x63f
Apr  2 22:44:36 werner kernel:  [<c1053910>] ? 
__wake_up_common+0xe/0x62
Apr  2 22:44:36 werner kernel:  [<c10b25c2>] 
__get_free_pages+0x1c/0x2d
Apr  2 22:44:36 werner kernel:  [<c10f8f19>] 
poll_get_entry+0x48/0x75
Apr  2 22:44:36 werner kernel:  [<c10f8f5e>] 
__pollwait+0x18/0x4d
Apr  2 22:44:36 werner kernel:  [<c10f8f46>] ? 
poll_get_entry+0x75/0x75
Apr  2 22:44:36 werner kernel:  [<c1f69875>] 
unix_poll+0x1e/0x9f
Apr  2 22:44:36 werner kernel:  [<c1ee2613>] 
sock_poll+0x14/0x17
Apr  2 22:44:36 werner kernel:  [<c10f972d>] 
do_select+0x229/0x44b
Apr  2 22:44:36 werner kernel:  [<c10f8f46>] ? 
poll_get_entry+0x75/0x75
Apr  2 22:44:36 werner kernel:  [<c10f8fd9>] ? 
__pollwake+0x46/0x46
Apr  2 22:44:36 werner last message repeated 17 times
Apr  2 22:44:36 werner kernel:  [<c10f9add>] 
core_sys_select+0x18e/0x255
Apr  2 22:44:36 werner kernel:  [<c10509d3>] ? 
hrtimer_try_to_cancel+0x84/0x8d
Apr  2 22:44:36 werner kernel:  [<c1038b82>] ? 
set_normalized_timespec+0x9/0x43
Apr  2 22:44:36 werner kernel:  [<c1038b82>] ? 
set_normalized_timespec+0x9/0x43
Apr  2 22:44:36 werner kernel:  [<c1038de8>] ? 
timespec_add_safe+0x2f/0x4f
Apr  2 22:44:36 werner kernel:  [<c10f9d4a>] 
sys_select+0x79/0x96
Apr  2 22:44:36 werner kernel:  [<c2088cdc>] 
syscall_call+0x7/0xb
Apr  2 22:44:36 werner kernel: Mem-Info:
Apr  2 22:44:36 werner kernel: DMA per-cpu:
Apr  2 22:44:36 werner kernel: CPU    0: hi:    0, btch: 
  1 usd:   0
Apr  2 22:44:36 werner kernel: Normal per-cpu:
Apr  2 22:44:36 werner kernel: CPU    0: hi:  186, btch: 
 31 usd:  61
Apr  2 22:44:36 werner kernel: HighMem per-cpu:
Apr  2 22:44:36 werner kernel: CPU    0: hi:  186, btch: 
 31 usd:  26
Apr  2 22:44:36 werner kernel: active_anon:44200 
inactive_anon:29 isolated_anon:0
Apr  2 22:44:36 werner kernel:  active_file:29902 
inactive_file:32683 isolated_file:0
Apr  2 22:44:36 werner kernel:  unevictable:17 dirty:0 
writeback:0 unstable:0
Apr  2 22:44:36 werner kernel:  free:455579 
slab_reclaimable:3416 slab_unreclaimable:39101
Apr  2 22:44:36 werner kernel:  mapped:19206 shmem:688 
pagetables:529 bounce:0
Apr  2 22:44:36 werner kernel: DMA free:4244kB min:784kB 
low:980kB high:1176kB active_anon:0kB inactive_anon:0kB 
active_file:0kB inactive_file:0kB unevictable:0kB 
isolated(anon):0kB isolated(file):0kB present:15804kB 
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB 
slab_reclaimable:12kB slab_unreclaimable:1552kB 
kernel_stack:10040kB pagetables:0kB unstable:0kB 
bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? yes
Apr  2 22:44:36 werner kernel: lowmem_reserve[]: 0 865 
3031 3031
Apr  2 22:44:36 werner kernel: Normal free:44008kB 
min:44012kB low:55012kB high:66016kB active_anon:0kB 
inactive_anon:0kB active_file:164kB inactive_file:116kB 
unevictable:0kB isolated(anon):0kB isolated(file):0kB 
present:885944kB mlocked:0kB dirty:0kB writeback:0kB 
mapped:12kB shmem:0kB slab_reclaimable:13652kB 
slab_unreclaimable:154852kB kernel_stack:621400kB 
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB 
pages_scanned:422 all_unreclaimable? yes
Apr  2 22:44:36 werner kernel: lowmem_reserve[]: 0 0 17326 
17326
Apr  2 22:44:36 werner kernel: HighMem free:1774064kB 
min:512kB low:28056kB high:55600kB active_anon:176800kB 
inactive_anon:116kB active_file:119444kB 
inactive_file:130616kB unevictable:68kB isolated(anon):0kB 
isolated(file):0kB present:2217808kB mlocked:68kB 
dirty:0kB writeback:0kB mapped:76812kB shmem:2752kB 
slab_reclaimable:0kB slab_unreclaimable:0kB 
kernel_stack:0kB pagetables:2116kB unstable:0kB bounce:0kB 
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
Apr  2 22:44:36 werner kernel: lowmem_reserve[]: 0 0 0 0
Apr  2 22:44:36 werner kernel: DMA: 17*4kB 28*8kB 27*16kB 
36*32kB 33*64kB 2*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 
0*4096kB = 4244kB
Apr  2 22:44:36 werner kernel: Normal: 2300*4kB 291*8kB 
144*16kB 77*32kB 27*64kB 13*128kB 5*256kB 3*512kB 1*1024kB 
0*2048kB 5*4096kB = 44008kB
Apr  2 22:44:36 werner kernel: HighMem: 6820*4kB 5252*8kB 
2558*16kB 1935*32kB 1346*64kB 542*128kB 224*256kB 
103*512kB 49*1024kB 24*2048kB 302*4096kB = 1774064kB
Apr  2 22:44:36 werner kernel: 63282 total pagecache pages
Apr  2 22:44:36 werner kernel: 0 pages in swap cache
Apr  2 22:44:36 werner kernel: Swap cache stats: add 0, 
delete 0, find 0/0
Apr  2 22:44:36 werner kernel: Free swap  = 0kB
Apr  2 22:44:36 werner kernel: Total swap = 0kB
Apr  2 22:44:36 werner kernel: 786128 pages RAM
Apr  2 22:44:36 werner kernel: 558818 pages HighMem
Apr  2 22:44:36 werner kernel: 13576 pages reserved
Apr  2 22:44:36 werner kernel: 112481 pages shared
Apr  2 22:44:36 werner kernel: 209915 pages non-shared
Apr  2 22:59:06 werner kernel: Malformed early option 
'acpi'
Apr  2 22:59:06 werner kernel: ACPI: RSDP 000f6920 00014 
(v00 GBT   )
Apr  2 22:59:06 werner kernel: ACPI: RSDT bfee3000 00038 
(v01 GBT    NVDAACPI 42302E31 NVDA 01010101)
Apr  2 22:59:06 werner kernel: ACPI: FACP bfee3040 00074 
(v01 GBT    NVDAACPI 42302E31 NVDA 01010101)
Apr  2 22:59:06 werner kernel: ACPI: DSDT bfee30c0 0469E 
(v01 GBT    NVDAACPI 00001000 MSFT 03000000)
Apr  2 22:59:06 werner kernel: ACPI: FACS bfee0000 00040
Apr  2 22:59:06 werner kernel: ACPI: SSDT bfee7880 0028A 
(v01 PTLTD  POWERNOW 00000001  LTP 00000001)
Apr  2 22:59:06 werner kernel: ACPI: HPET bfee7b40 00038 
(v01 GBT    NVDAACPI 42302E31 NVDA 00000098)
Apr  2 22:59:06 werner kernel: ACPI: MCFG bfee7b80 0003C 
(v01 GBT    NVDAACPI 42302E31 NVDA 01010101)
Apr  2 22:59:06 werner kernel: ACPI: APIC bfee7780 000D0 
(v01 GBT    NVDAACPI 42302E31 NVDA 01010101)
Apr  2 22:59:06 werner kernel: Zone PFN ranges:
Apr  2 22:59:06 werner kernel:   DMA      0x00000010 -> 
0x00001000
Apr  2 22:59:06 werner kernel:   Normal   0x00001000 -> 
0x000377fe
Apr  2 22:59:06 werner kernel:   HighMem  0x000377fe -> 
0x000bfee0
Apr  2 22:59:06 werner kernel: Movable zone start PFN for 
each node
Apr  2 22:59:06 werner kernel: Early memory PFN ranges
Apr  2 22:59:06 werner kernel:     0: 0x00000010 -> 
0x0000009f
Apr  2 22:59:06 werner kernel:     0: 0x00000100 -> 
0x000bfee0
Apr  2 22:59:06 werner kernel: Built 1 zonelists in Zone 
order, mobility grouping on.  Total pages: 779889
Apr  2 22:59:06 werner kernel: ram_console: buffer 
  (null), invalid size 0, datasize 4294967284
Apr  2 22:59:06 werner kernel: Fast TSC calibration using 
PIT
Apr  2 22:59:06 werner kernel: Detected 2511.229 MHz 
processor.
Apr  2 22:59:06 werner kernel: ACPI: setting ELCR to 0200 
(from 0c20)
Apr  2 22:59:06 werner kernel: AMD PMU driver.
Apr  2 22:59:06 werner kernel: raid6: int32x1    714 MB/s
Apr  2 22:59:06 werner kernel: raid6: int32x2    785 MB/s
Apr  2 22:59:06 werner kernel: raid6: int32x4    867 MB/s
Apr  2 22:59:06 werner kernel: raid6: int32x8    609 MB/s
Apr  2 22:59:06 werner kernel: raid6: mmxx1     1460 MB/s
Apr  2 22:59:06 werner kernel: raid6: mmxx2     2687 MB/s
Apr  2 22:59:06 werner kernel: raid6: sse1x1    1972 MB/s
Apr  2 22:59:06 werner kernel: raid6: sse1x2    3304 MB/s
Apr  2 22:59:06 werner kernel: raid6: sse2x1    3417 MB/s
Apr  2 22:59:06 werner kernel: raid6: sse2x2    4554 MB/s
Apr  2 22:59:06 werner kernel: raid6: using algorithm 
sse2x2 (4554 MB/s)
Apr  2 22:59:06 werner kernel: Expanded resource reserved 
due to conflict with PCI Bus 0000:00
Apr  2 22:59:06 werner kernel: mdacon: MDA with 8K of 
memory detected.
Apr  2 22:59:06 werner kernel: ACPI: PCI Interrupt Link 
[LUBA] enabled at IRQ 10
Apr  2 22:59:06 werner kernel: ACPI: PCI Interrupt Link 
[LUB2] enabled at IRQ 11
Apr  2 22:59:06 werner kernel: microcode: CPU0: family 15 
not supported
Apr  2 22:59:06 werner kernel: The force parameter has not 
been set to 1 so the Iris poweroff handler will not be 
installed.
Apr  2 22:59:06 werner kernel: highmem bounce pool size: 
64 pages
Apr  2 22:59:06 werner kernel: Dquot-cache hash table 
entries: 1024 (order 0, 4096 bytes)
Apr  2 22:59:06 werner kernel: DLM installed
Apr  2 22:59:06 werner kernel: EFS: 1.0a - 
http://aeschi.ch.eu.org/efs/
Apr  2 22:59:06 werner kernel: OCFS2 User DLM kernel 
interface loaded
Apr  2 22:59:06 werner kernel: GFS2 installed
Apr  2 22:59:06 werner kernel: acpiphp_ibm: 
ibm_acpiphp_init: acpi_walk_namespace failed
Apr  2 22:59:06 werner kernel: ACPI: PCI Interrupt Link 
[LIGP] enabled at IRQ 10
Apr  2 22:59:06 werner kernel: nvidiafb: CRTC0 analog 
found
Apr  2 22:59:06 werner kernel: nvidiafb: CRTC1 analog not 
found
Apr  2 22:59:06 werner kernel: i2c i2c-0: unable to read 
EDID block.
Apr  2 22:59:06 werner last message repeated 2 times
Apr  2 22:59:06 werner kernel: nvidiafb: EDID found from 
BUS2
Apr  2 22:59:06 werner kernel: nvidiafb: CRTC 0 appears to 
have a CRT attached
Apr  2 22:59:06 werner kernel: nvidiafb: Using CRT on CRTC 
0
Apr  2 22:59:06 werner kernel: Could not find Carillo 
Ranch MCH device.
Apr  2 22:59:06 werner kernel: no IO addresses supplied
Apr  2 22:59:06 werner kernel: hgafb: probe of hgafb.0 
failed with error -22
Apr  2 22:59:06 werner kernel: uvesafb: failed to execute 
/sbin/v86d
Apr  2 22:59:06 werner kernel: uvesafb: make sure that the 
v86d helper is installed and executable
Apr  2 22:59:06 werner kernel: uvesafb: Getting VBE info 
block failed (eax=0x4f00, err=-2)
Apr  2 22:59:06 werner kernel: uvesafb: vbe_init() failed 
with -22
Apr  2 22:59:06 werner kernel: uvesafb: probe of uvesafb.0 
failed with error -22
Apr  2 22:59:06 werner kernel: vesafb: cannot reserve 
video memory at 0xd0000000
Apr  2 22:59:06 werner kernel: toshiba: not a supported 
Toshiba laptop
Apr  2 22:59:06 werner kernel: [drm:i915_init] *ERROR* 
drm/i915 can't work without intel_agp module!
Apr  2 22:59:06 werner kernel: Compaq SMART2 Driver (v 
2.6.0)
Apr  2 22:59:06 werner kernel: i2c-core: driver [isl29003] 
using legacy suspend method
Apr  2 22:59:06 werner kernel: i2c-core: driver [isl29003] 
using legacy resume method
Apr  2 22:59:06 werner kernel: amd74xx 0000:00:06.0: BIOS 
didn't set cable bits correctly. Enabling workaround.
Apr  2 22:59:06 werner kernel: Loading Adaptec I2O RAID: 
Version 2.4 Build 5go
Apr  2 22:59:06 werner kernel: scsi: <fdomain> Detection 
failed (no card)
Apr  2 22:59:06 werner kernel: NCR53c406a: no available 
ports found
Apr  2 22:59:06 werner kernel: qla2xxx 
[0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driver: 
8.03.07.13-k.
Apr  2 22:59:06 werner kernel: Emulex LightPulse Fibre 
Channel SCSI driver 8.3.28
Apr  2 22:59:06 werner kernel: Copyright(c) 2004-2009 
Emulex.  All rights reserved.
Apr  2 22:59:06 werner kernel: Failed initialization of 
WD-7000 SCSI card!
Apr  2 22:59:06 werner kernel: GDT-HA: Storage RAID 
Controller Driver. Version: 3.05
Apr  2 22:59:06 werner kernel: 3ware Storage Controller 
device driver for Linux v1.26.02.003.
Apr  2 22:59:06 werner kernel: 3ware 9000 Storage 
Controller device driver for Linux v2.26.02.014.
Apr  2 22:59:06 werner kernel: imm: Version 2.05 (for 
Linux 2.4.0)
Apr  2 22:59:06 werner kernel: ACPI: PCI Interrupt Link 
[LSID] enabled at IRQ 11
Apr  2 22:59:06 werner kernel: ACPI: PCI Interrupt Link 
[LFID] enabled at IRQ 10
Apr  2 22:59:06 werner kernel: Error: Driver 
'pata_platform' is already registered, aborting...
Apr  2 22:59:06 werner kernel: physmap-flash.0: failed to 
claim resource 0
Apr  2 22:59:06 werner kernel: Failed to ioremap_nocache
Apr  2 22:59:06 werner last message repeated 2 times
Apr  2 22:59:06 werner kernel: SNAPGEAR: failed to 
ioremap() BOOTCS
Apr  2 22:59:06 werner kernel: Generic platform RAM MTD, 
(c) 2004 Simtec Electronics
Apr  2 22:59:06 werner kernel: [nandsim] warning: 
read_byte: unexpected data output cycle, state is 
STATE_READY return 0x0
Apr  2 22:59:06 werner last message repeated 5 times
Apr  2 22:59:06 werner kernel: flash size: 8 MiB
Apr  2 22:59:06 werner kernel: page size: 512 bytes
Apr  2 22:59:06 werner kernel: OOB area size: 16 bytes
Apr  2 22:59:06 werner kernel: sector size: 8 KiB
Apr  2 22:59:06 werner kernel: pages number: 16384
Apr  2 22:59:06 werner kernel: pages per sector: 16
Apr  2 22:59:06 werner kernel: bus width: 8
Apr  2 22:59:06 werner kernel: bits in sector size: 13
Apr  2 22:59:06 werner kernel: bits in page size: 9
Apr  2 22:59:06 werner kernel: bits in OOB size: 4
Apr  2 22:59:06 werner kernel: flash size with OOB: 8448 
KiB
Apr  2 22:59:06 werner kernel: page address bytes: 3
Apr  2 22:59:06 werner kernel: sector address bytes: 2
Apr  2 22:59:06 werner kernel: options: 0x62
Apr  2 22:59:06 werner kernel: onenand_wait: timeout! 
ctrl=0x0000 intr=0x0000
Apr  2 22:59:06 werner kernel: DE600: port 0x378 busy
Apr  2 22:59:06 werner kernel: paride: aten registered as 
protocol 0
Apr  2 22:59:06 werner kernel: paride: bpck registered as 
protocol 1
Apr  2 22:59:06 werner kernel: paride: comm registered as 
protocol 2
Apr  2 22:59:06 werner kernel: paride: dstr registered as 
protocol 3
Apr  2 22:59:06 werner kernel: paride: k951 registered as 
protocol 4
Apr  2 22:59:06 werner kernel: paride: k971 registered as 
protocol 5
Apr  2 22:59:06 werner kernel: paride: epat registered as 
protocol 6
Apr  2 22:59:06 werner kernel: paride: epia registered as 
protocol 7
Apr  2 22:59:06 werner kernel: paride: frpw registered as 
protocol 8
Apr  2 22:59:06 werner kernel: paride: friq registered as 
protocol 9
Apr  2 22:59:06 werner kernel: paride: fit2 registered as 
protocol 10
Apr  2 22:59:06 werner kernel: paride: fit3 registered as 
protocol 11
Apr  2 22:59:06 werner kernel: paride: on20 registered as 
protocol 12
Apr  2 22:59:06 werner kernel: paride: on26 registered as 
protocol 13
Apr  2 22:59:06 werner kernel: paride: ktti registered as 
protocol 14
Apr  2 22:59:06 werner kernel: paride: bpck6 registered as 
protocol 15
Apr  2 22:59:06 werner kernel: pd: pd version 1.05, major 
45, cluster 64, nice 0
Apr  2 22:59:06 werner kernel: pda: Autoprobe failed
Apr  2 22:59:06 werner kernel: pd: no valid drive found
Apr  2 22:59:06 werner kernel: pcd: pcd version 1.07, 
major 46, nice 0
Apr  2 22:59:06 werner kernel: pcd0: Autoprobe failed
Apr  2 22:59:06 werner kernel: pcd: No CD-ROM drive found
Apr  2 22:59:06 werner kernel: pf: pf version 1.04, major 
47, cluster 64, nice 0
Apr  2 22:59:06 werner kernel: pf: No ATAPI disk detected
Apr  2 22:59:06 werner kernel: pt: pt version 1.04, major 
96
Apr  2 22:59:06 werner kernel: sr0: scsi3-mmc drive: 
48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
Apr  2 22:59:06 werner kernel: pt0: Autoprobe failed
Apr  2 22:59:06 werner kernel: pt: No ATAPI tape drive 
detected
Apr  2 22:59:06 werner kernel: pg: pg version 1.02, major 
97
Apr  2 22:59:06 werner kernel: pga: Autoprobe failed
Apr  2 22:59:06 werner kernel: pg: No ATAPI device 
detected
Apr  2 22:59:06 werner kernel: mk712: device not present
Apr  2 22:59:06 werner kernel: wistron_btns: System 
unknown
Apr  2 22:59:06 werner kernel: EISA: Cannot allocate 
resource for mainboard
Apr  2 22:59:06 werner kernel: Cannot allocate resource 
for EISA slot 1
Apr  2 22:59:06 werner kernel: Cannot allocate resource 
for EISA slot 2
Apr  2 22:59:06 werner kernel: Cannot allocate resource 
for EISA slot 3
Apr  2 22:59:06 werner kernel: Cannot allocate resource 
for EISA slot 4
Apr  2 22:59:06 werner kernel: Cannot allocate resource 
for EISA slot 5
Apr  2 22:59:06 werner kernel: Cannot allocate resource 
for EISA slot 6
Apr  2 22:59:06 werner kernel: Cannot allocate resource 
for EISA slot 7
Apr  2 22:59:06 werner kernel: Cannot allocate resource 
for EISA slot 8
Apr  2 22:59:06 werner kernel: asus_wmi: Management GUID 
not found
Apr  2 22:59:06 werner kernel: asus_wmi: Management GUID 
not found
Apr  2 22:59:06 werner kernel: compal_laptop: Motherboard 
not recognized (You could try the module's 
force-parameter)
Apr  2 22:59:06 werner kernel: dell_wmi: No known WMI GUID 
found
Apr  2 22:59:06 werner kernel: dell_wmi_aio: No known WMI 
GUID found
Apr  2 22:59:06 werner kernel: acer_wmi: No or unsupported 
WMI interface, unable to load
Apr  2 22:59:06 werner kernel: acerhdf: unknown 
(unsupported) BIOS version Gigabyte Technology Co., 
Ltd./M68M-S2P/FC, please report, aborting!
Apr  2 22:59:06 werner kernel: hdaps: supported laptop not 
found!
Apr  2 22:59:06 werner kernel: hdaps: driver init failed 
(ret=-19)!
Apr  2 22:59:06 werner kernel: msi_wmi: This machine 
doesn't have MSI-hotkeys through WMI
Apr  2 22:59:06 werner kernel: intel_oaktrail: Platform 
not recognized (You could try the module's 
force-parameter)
Apr  2 22:59:06 werner kernel: register_blkdev: cannot get 
major 3 for hd
Apr  2 22:59:06 werner kernel: drivers/rtc/hctosys.c: 
unable to open rtc device (rtc0)
Apr  2 22:59:06 werner kernel: udevd (5245): 
/proc/5245/oom_adj is deprecated, please use 
/proc/5245/oom_score_adj instead.
Apr  2 22:59:06 werner kernel: end_request: I/O error, dev 
fd0, sector 0
Apr  2 22:59:06 werner kernel: ACPI: PCI Interrupt Link 
[LMAC] enabled at IRQ 11
Apr  2 22:59:06 werner kernel: ACPI: PCI Interrupt Link 
[LAZA] enabled at IRQ 5
Apr  2 22:59:06 werner kernel: ACPI: PCI Interrupt Link 
[LNK2] enabled at IRQ 5
Apr  2 22:59:06 werner kernel: 2:3:1: cannot get freq at 
ep 0x84
Apr  2 22:59:06 werner kernel: k8temp 0000:00:18.3: 
Temperature readouts might be wrong - check erratum #141
Apr  2 22:59:06 werner kernel: EXT3-fs (sda1): warning: 
maximal mount count reached, running e2fsck is recommended
Apr  2 22:59:08 werner udevd[5245]: add_to_rules: unknown 
key 'MODALIAS' in /etc/udev/rules.d/80-eagle-usb.rules:1
Apr  2 22:59:09 werner last message repeated 2 times
Apr  2 22:59:09 werner udevd-event[8961]: 
udev_rules_apply_format: unknown format variable 
'$modalias | grep -q eagle-usb || exit; while ! 
/sbin/eaglectrl -p 2>/dev/null | /bin/grep -q 
Post-firmware; do sleep 2; done; /sbin/eaglectrl -d''
Apr  2 22:59:09 werner udevd-event[8962]: 
udev_rules_apply_format: unknown format variable 
'$modalias | grep -q eagle-usb || exit; while ! 
/sbin/eaglectrl -p 2>/dev/null | /bin/grep -q 
Post-firmware; do sleep 2; done; /sbin/eaglectrl -d''
Apr  2 22:59:09 werner udevd[5245]: add_to_rules: unknown 
key 'MODALIAS' in /etc/udev/rules.d/80-eagle-usb.rules:1
Apr  2 22:59:09 werner udevd[5245]: add_to_rules: unknown 
key 'MODALIAS' in /etc/udev/rules.d/80-eagle-usb.rules:1
Apr  2 22:59:18 werner apcupsd[8942]: apcupsd FATAL ERROR 
in smartsetup.c at line 171 PANIC! Cannot communicate with 
UPS via serial port. Please make sure the port specified 
on the DEVICE directive is correct, and that your cable 
specification on the UPSCABLE directive is correct.
Apr  2 22:59:18 werner apcupsd[8942]: apcupsd error 
shutdown completed
Apr  2 22:59:28 werner hpijs[9203]: prnt/hpijs/hpijs.cpp 
614: unable to init hpijs server
Apr  2 22:59:33 werner udevd[5245]: add_to_rules: unknown 
key 'MODALIAS' in /etc/udev/rules.d/80-eagle-usb.rules:1
Apr  2 23:00:00 werner kdm_greet[9346]: Can't open default 
user face
---
Professional hosting for everyone - http://www.host.ru

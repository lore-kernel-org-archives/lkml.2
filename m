Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752441Ab2DBUfH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 16:35:07 -0400
Received: from zfrontend1.aha.ru ([195.2.83.147]:33813 "EHLO aha.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751212Ab2DBUfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 16:35:04 -0400
X-Greylist: delayed 3602 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Apr 2012 16:35:03 EDT
From: "werner" <w.landgraf@ru.ru>
Subject: 3.4-rc1 sticks-and-crashs
To: linux-kernel@vger.kernel.org
X-Mailer: CommuniGate Pro WebUser Interface v.4.3.12
Date: Mon, 02 Apr 2012 15:38:43 -0400
Message-ID: <web-719566914@zbackend1.aha.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With 3.4-rc1  several times my computer, after a few hours 
working, sticked and crashed then.
With 3.3 this didnt happen

Below some traces, perhaps it has to do something 
therewith.

W.Landgraf





Apr  2 01:14:10 werner kernel: Malformed early option 
'acpi'
Apr  2 01:14:10 werner kernel: ACPI: RSDP 000f6920 00014 
(v00 GBT   )
Apr  2 01:14:10 werner kernel: ACPI: RSDT bfee3000 00038 
(v01 GBT    NVDAACPI 42302E31 NVDA 01010101)
Apr  2 01:14:10 werner kernel: ACPI: FACP bfee3040 00074 
(v01 GBT    NVDAACPI 42302E31 NVDA 01010101)
Apr  2 01:14:10 werner kernel: ACPI: DSDT bfee30c0 0469E 
(v01 GBT    NVDAACPI 00001000 MSFT 03000000)
Apr  2 01:14:10 werner kernel: ACPI: FACS bfee0000 00040
Apr  2 01:14:10 werner kernel: ACPI: SSDT bfee7880 0028A 
(v01 PTLTD  POWERNOW 00000001  LTP 00000001)
Apr  2 01:14:10 werner kernel: ACPI: HPET bfee7b40 00038 
(v01 GBT    NVDAACPI 42302E31 NVDA 00000098)
Apr  2 01:14:10 werner kernel: ACPI: MCFG bfee7b80 0003C 
(v01 GBT    NVDAACPI 42302E31 NVDA 01010101)
Apr  2 01:14:10 werner kernel: ACPI: APIC bfee7780 000D0 
(v01 GBT    NVDAACPI 42302E31 NVDA 01010101)
Apr  2 01:14:10 werner kernel: Zone PFN ranges:
Apr  2 01:14:10 werner kernel:   DMA      0x00000010 -> 
0x00001000
Apr  2 01:14:10 werner kernel:   Normal   0x00001000 -> 
0x000377fe
Apr  2 01:14:10 werner kernel:   HighMem  0x000377fe -> 
0x000bfee0
Apr  2 01:14:10 werner kernel: Movable zone start PFN for 
each node
Apr  2 01:14:10 werner kernel: Early memory PFN ranges
Apr  2 01:14:10 werner kernel:     0: 0x00000010 -> 
0x0000009f
Apr  2 01:14:10 werner kernel:     0: 0x00000100 -> 
0x000bfee0
Apr  2 01:14:10 werner kernel: Built 1 zonelists in Zone 
order, mobility grouping on.  Total pages: 779889
Apr  2 01:14:10 werner kernel: Fast TSC calibration using 
PIT
Apr  2 01:14:10 werner kernel: Detected 2511.390 MHz 
processor.
Apr  2 01:14:10 werner kernel: ACPI: setting ELCR to 0200 
(from 0c20)
Apr  2 01:14:10 werner kernel: AMD PMU driver.
Apr  2 01:14:10 werner kernel: raid6: int32x1    945 MB/s
Apr  2 01:14:10 werner kernel: raid6: int32x2    933 MB/s
Apr  2 01:14:10 werner kernel: raid6: int32x4    933 MB/s
Apr  2 01:14:10 werner kernel: raid6: int32x8    617 MB/s
Apr  2 01:14:10 werner kernel: raid6: mmxx1     2011 MB/s
Apr  2 01:14:10 werner kernel: raid6: mmxx2     3644 MB/s
Apr  2 01:14:10 werner kernel: raid6: sse1x1    2015 MB/s
Apr  2 01:14:10 werner kernel: raid6: sse1x2    3492 MB/s
Apr  2 01:14:10 werner kernel: raid6: sse2x1    3453 MB/s
Apr  2 01:14:10 werner kernel: raid6: sse2x2    4574 MB/s
Apr  2 01:14:10 werner kernel: raid6: using algorithm 
sse2x2 (4574 MB/s)
Apr  2 01:14:10 werner kernel: Expanded resource reserved 
due to conflict with PCI Bus 0000:00
Apr  2 01:14:10 werner kernel: mdacon: MDA with 8K of 
memory detected.
Apr  2 01:14:10 werner kernel: ACPI: PCI Interrupt Link 
[LUBA] enabled at IRQ 10
Apr  2 01:14:10 werner kernel: ACPI: PCI Interrupt Link 
[LUB2] enabled at IRQ 11
Apr  2 01:14:10 werner kernel: microcode: CPU0: family 15 
not supported
Apr  2 01:14:10 werner kernel: The force parameter has not 
been set to 1 so the Iris poweroff handler will not be 
installed.
Apr  2 01:14:10 werner kernel: highmem bounce pool size: 
64 pages
Apr  2 01:14:10 werner kernel: Dquot-cache hash table 
entries: 1024 (order 0, 4096 bytes)
Apr  2 01:14:10 werner kernel: DLM installed
Apr  2 01:14:10 werner kernel: EFS: 1.0a - 
http://aeschi.ch.eu.org/efs/
Apr  2 01:14:10 werner kernel: OCFS2 User DLM kernel 
interface loaded
Apr  2 01:14:10 werner kernel: GFS2 installed
Apr  2 01:14:10 werner kernel: acpiphp_ibm: 
ibm_acpiphp_init: acpi_walk_namespace failed
Apr  2 01:14:10 werner kernel: ACPI: PCI Interrupt Link 
[LIGP] enabled at IRQ 10
Apr  2 01:14:10 werner kernel: nvidiafb: CRTC0 analog 
found
Apr  2 01:14:10 werner kernel: nvidiafb: CRTC1 analog not 
found
Apr  2 01:14:10 werner kernel: i2c i2c-0: unable to read 
EDID block.
Apr  2 01:14:10 werner last message repeated 2 times
Apr  2 01:14:10 werner kernel: nvidiafb: EDID found from 
BUS2
Apr  2 01:14:10 werner kernel: nvidiafb: CRTC 0 appears to 
have a CRT attached
Apr  2 01:14:10 werner kernel: nvidiafb: Using CRT on CRTC 
0
Apr  2 01:14:10 werner kernel: Could not find Carillo 
Ranch MCH device.
Apr  2 01:14:10 werner kernel: no IO addresses supplied
Apr  2 01:14:10 werner kernel: hgafb: probe of hgafb.0 
failed with error -22
Apr  2 01:14:10 werner kernel: uvesafb: failed to execute 
/sbin/v86d
Apr  2 01:14:10 werner kernel: uvesafb: make sure that the 
v86d helper is installed and executable
Apr  2 01:14:10 werner kernel: uvesafb: Getting VBE info 
block failed (eax=0x4f00, err=-2)
Apr  2 01:14:10 werner kernel: uvesafb: vbe_init() failed 
with -22
Apr  2 01:14:10 werner kernel: uvesafb: probe of uvesafb.0 
failed with error -22
Apr  2 01:14:10 werner kernel: vesafb: cannot reserve 
video memory at 0xd0000000
Apr  2 01:14:10 werner kernel: toshiba: not a supported 
Toshiba laptop
Apr  2 01:14:10 werner kernel: [drm:i915_init] *ERROR* 
drm/i915 can't work without intel_agp module!
Apr  2 01:14:10 werner kernel: Compaq SMART2 Driver (v 
2.6.0)
Apr  2 01:14:10 werner kernel: i2c-core: driver [isl29003] 
using legacy suspend method
Apr  2 01:14:10 werner kernel: i2c-core: driver [isl29003] 
using legacy resume method
Apr  2 01:14:10 werner kernel: amd74xx 0000:00:06.0: BIOS 
didn't set cable bits correctly. Enabling workaround.
Apr  2 01:14:10 werner kernel: Loading Adaptec I2O RAID: 
Version 2.4 Build 5go
Apr  2 01:14:10 werner kernel: scsi: <fdomain> Detection 
failed (no card)
Apr  2 01:14:10 werner kernel: NCR53c406a: no available 
ports found
Apr  2 01:14:10 werner kernel: qla2xxx 
[0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driver: 
8.03.07.13-k.
Apr  2 01:14:10 werner kernel: Emulex LightPulse Fibre 
Channel SCSI driver 8.3.30
Apr  2 01:14:10 werner kernel: Copyright(c) 2004-2009 
Emulex.  All rights reserved.
Apr  2 01:14:10 werner kernel: Failed initialization of 
WD-7000 SCSI card!
Apr  2 01:14:10 werner kernel: GDT-HA: Storage RAID 
Controller Driver. Version: 3.05
Apr  2 01:14:10 werner kernel: 3ware Storage Controller 
device driver for Linux v1.26.02.003.
Apr  2 01:14:10 werner kernel: 3ware 9000 Storage 
Controller device driver for Linux v2.26.02.014.
Apr  2 01:14:10 werner kernel: imm: Version 2.05 (for 
Linux 2.4.0)
Apr  2 01:14:10 werner kernel: ACPI: PCI Interrupt Link 
[LSID] enabled at IRQ 11
Apr  2 01:14:10 werner kernel: ACPI: PCI Interrupt Link 
[LFID] enabled at IRQ 10
Apr  2 01:14:10 werner kernel: Error: Driver 
'pata_platform' is already registered, aborting...
Apr  2 01:14:10 werner kernel: physmap-flash.0: failed to 
claim resource 0
Apr  2 01:14:10 werner kernel: Failed to ioremap_nocache
Apr  2 01:14:10 werner last message repeated 2 times
Apr  2 01:14:10 werner kernel: SNAPGEAR: failed to 
ioremap() BOOTCS
Apr  2 01:14:10 werner kernel: Generic platform RAM MTD, 
(c) 2004 Simtec Electronics
Apr  2 01:14:10 werner kernel: [nandsim] warning: 
read_byte: unexpected data output cycle, state is 
STATE_READY return 0x0
Apr  2 01:14:10 werner last message repeated 5 times
Apr  2 01:14:10 werner kernel: flash size: 8 MiB
Apr  2 01:14:10 werner kernel: page size: 512 bytes
Apr  2 01:14:10 werner kernel: OOB area size: 16 bytes
Apr  2 01:14:10 werner kernel: sector size: 8 KiB
Apr  2 01:14:10 werner kernel: pages number: 16384
Apr  2 01:14:10 werner kernel: pages per sector: 16
Apr  2 01:14:10 werner kernel: bus width: 8
Apr  2 01:14:10 werner kernel: bits in sector size: 13
Apr  2 01:14:10 werner kernel: bits in page size: 9
Apr  2 01:14:10 werner kernel: bits in OOB size: 4
Apr  2 01:14:10 werner kernel: flash size with OOB: 8448 
KiB
Apr  2 01:14:10 werner kernel: page address bytes: 3
Apr  2 01:14:10 werner kernel: sector address bytes: 2
Apr  2 01:14:10 werner kernel: options: 0x62
Apr  2 01:14:10 werner kernel: onenand_wait: timeout! 
ctrl=0x0000 intr=0x0000
Apr  2 01:14:10 werner kernel: DE600: port 0x378 busy
Apr  2 01:14:10 werner kernel: paride: aten registered as 
protocol 0
Apr  2 01:14:10 werner kernel: paride: bpck registered as 
protocol 1
Apr  2 01:14:10 werner kernel: paride: comm registered as 
protocol 2
Apr  2 01:14:10 werner kernel: paride: dstr registered as 
protocol 3
Apr  2 01:14:10 werner kernel: paride: k951 registered as 
protocol 4
Apr  2 01:14:10 werner kernel: paride: k971 registered as 
protocol 5
Apr  2 01:14:10 werner kernel: paride: epat registered as 
protocol 6
Apr  2 01:14:10 werner kernel: paride: epia registered as 
protocol 7
Apr  2 01:14:10 werner kernel: paride: frpw registered as 
protocol 8
Apr  2 01:14:10 werner kernel: paride: friq registered as 
protocol 9
Apr  2 01:14:10 werner kernel: paride: fit2 registered as 
protocol 10
Apr  2 01:14:10 werner kernel: paride: fit3 registered as 
protocol 11
Apr  2 01:14:10 werner kernel: paride: on20 registered as 
protocol 12
Apr  2 01:14:10 werner kernel: paride: on26 registered as 
protocol 13
Apr  2 01:14:10 werner kernel: paride: ktti registered as 
protocol 14
Apr  2 01:14:10 werner kernel: paride: bpck6 registered as 
protocol 15
Apr  2 01:14:10 werner kernel: pd: pd version 1.05, major 
45, cluster 64, nice 0
Apr  2 01:14:10 werner kernel: pda: Autoprobe failed
Apr  2 01:14:10 werner kernel: pd: no valid drive found
Apr  2 01:14:10 werner kernel: pcd: pcd version 1.07, 
major 46, nice 0
Apr  2 01:14:10 werner kernel: pcd0: Autoprobe failed
Apr  2 01:14:10 werner kernel: pcd: No CD-ROM drive found
Apr  2 01:14:10 werner kernel: pf: pf version 1.04, major 
47, cluster 64, nice 0
Apr  2 01:14:10 werner kernel: pf: No ATAPI disk detected
Apr  2 01:14:10 werner kernel: pt: pt version 1.04, major 
96
Apr  2 01:14:10 werner kernel: sr0: scsi3-mmc drive: 
48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
Apr  2 01:14:10 werner kernel: pt0: Autoprobe failed
Apr  2 01:14:10 werner kernel: pt: No ATAPI tape drive 
detected
Apr  2 01:14:10 werner kernel: pg: pg version 1.02, major 
97
Apr  2 01:14:10 werner kernel: pga: Autoprobe failed
Apr  2 01:14:10 werner kernel: pg: No ATAPI device 
detected
Apr  2 01:14:10 werner kernel: mk712: device not present
Apr  2 01:14:10 werner kernel: wistron_btns: System 
unknown
Apr  2 01:14:10 werner kernel: EISA: Cannot allocate 
resource for mainboard
Apr  2 01:14:10 werner kernel: Cannot allocate resource 
for EISA slot 1
Apr  2 01:14:10 werner kernel: Cannot allocate resource 
for EISA slot 2
Apr  2 01:14:10 werner kernel: Cannot allocate resource 
for EISA slot 3
Apr  2 01:14:10 werner kernel: Cannot allocate resource 
for EISA slot 4
Apr  2 01:14:10 werner kernel: Cannot allocate resource 
for EISA slot 5
Apr  2 01:14:10 werner kernel: Cannot allocate resource 
for EISA slot 6
Apr  2 01:14:10 werner kernel: Cannot allocate resource 
for EISA slot 7
Apr  2 01:14:10 werner kernel: Cannot allocate resource 
for EISA slot 8
Apr  2 01:14:10 werner kernel: asus_wmi: Management GUID 
not found
Apr  2 01:14:10 werner kernel: asus_wmi: Management GUID 
not found
Apr  2 01:14:10 werner kernel: compal_laptop: Motherboard 
not recognized (You could try the module's 
force-parameter)
Apr  2 01:14:10 werner kernel: dell_wmi: No known WMI GUID 
found
Apr  2 01:14:10 werner kernel: dell_wmi_aio: No known WMI 
GUID found
Apr  2 01:14:10 werner kernel: acer_wmi: No or unsupported 
WMI interface, unable to load
Apr  2 01:14:10 werner kernel: acerhdf: unknown 
(unsupported) BIOS version Gigabyte Technology Co., 
Ltd./M68M-S2P/FC, please report, aborting!
Apr  2 01:14:10 werner kernel: hdaps: supported laptop not 
found!
Apr  2 01:14:10 werner kernel: hdaps: driver init failed 
(ret=-19)!
Apr  2 01:14:10 werner kernel: msi_wmi: This machine 
doesn't have MSI-hotkeys through WMI
Apr  2 01:14:10 werner kernel: intel_oaktrail: Platform 
not recognized (You could try the module's 
force-parameter)
Apr  2 01:14:10 werner kernel: OK
Apr  2 01:14:10 werner kernel: OK
Apr  2 01:14:10 werner kernel: register_blkdev: cannot get 
major 3 for hd
Apr  2 01:14:10 werner kernel: drivers/rtc/hctosys.c: 
unable to open rtc device (rtc0)
Apr  2 01:14:10 werner kernel: udevd (5379): 
/proc/5379/oom_adj is deprecated, please use 
/proc/5379/oom_score_adj instead.
Apr  2 01:14:10 werner kernel: end_request: I/O error, dev 
fd0, sector 0
Apr  2 01:14:10 werner kernel: ACPI: PCI Interrupt Link 
[LMAC] enabled at IRQ 11
Apr  2 01:14:10 werner kernel: ACPI: PCI Interrupt Link 
[LAZA] enabled at IRQ 5
Apr  2 01:14:10 werner kernel: ACPI: PCI Interrupt Link 
[LNK2] enabled at IRQ 5
Apr  2 01:14:10 werner kernel: 2:3:1: cannot get freq at 
ep 0x84
Apr  2 01:14:10 werner kernel: k8temp 0000:00:18.3: 
Temperature readouts might be wrong - check erratum #141
Apr  2 01:14:10 werner kernel: EXT3-fs (sda1): warning: 
maximal mount count reached, running e2fsck is recommended
Apr  2 01:14:22 werner apcupsd[9194]: apcupsd FATAL ERROR 
in smartsetup.c at line 171 PANIC! Cannot communicate with 
UPS via serial port. Please make sure the port specified 
on the DEVICE directive is correct, and that your cable 
specification on the UPSCABLE directive is correct.
Apr  2 01:14:22 werner apcupsd[9194]: apcupsd error 
shutdown completed
Apr  2 01:14:30 werner hpijs[9497]: prnt/hpijs/hpijs.cpp 
614: unable to init hpijs server
Apr  2 01:14:36 werner udevd[5379]: add_to_rules: unknown 
key 'MODALIAS' in /etc/udev/rules.d/80-eagle-usb.rules:1
Apr  2 01:15:02 werner kdm_greet[9641]: Can't open default 
user face
Apr  2 01:57:18 werner named[3489]: /etc/named.conf:3: 
option 'multiple-cnames' is obsolete
Apr  2 05:25:37 werner kernel: kded invoked oom-killer: 
gfp_mask=0x84d0, order=0, oom_adj=0, oom_score_adj=0
Apr  2 05:25:37 werner kernel: Pid: 5467, comm: kded Not 
tainted 3.4.0-rc1-i486-1sys #1
Apr  2 05:25:37 werner kernel: Call Trace:
Apr  2 05:25:37 werner kernel:  [<c10356cf>] ? 
printk+0x20/0x22
Apr  2 05:25:37 werner kernel:  [<c10af0f7>] 
dump_header+0x6f/0x95
Apr  2 05:25:37 werner kernel:  [<c10af30b>] 
oom_kill_process+0x52/0x251
Apr  2 05:25:37 werner kernel:  [<c10af5cf>] ? 
select_bad_process+0xc5/0x11c
Apr  2 05:25:37 werner kernel:  [<c10af76a>] 
out_of_memory+0x144/0x1b4
Apr  2 05:25:37 werner kernel:  [<c10b2468>] 
__alloc_pages_nodemask+0x501/0x63f
Apr  2 05:25:37 werner kernel:  [<c10b25c2>] 
__get_free_pages+0x1c/0x2d
Apr  2 05:25:37 werner kernel:  [<c102bf07>] 
pgd_alloc+0x1e/0x79
Apr  2 05:25:37 werner kernel:  [<c103379b>] ? 
mm_alloc+0x18/0x3f
Apr  2 05:25:37 werner kernel:  [<c1032605>] 
mm_init+0xad/0xdb
Apr  2 05:25:37 werner kernel:  [<c10337bf>] 
mm_alloc+0x3c/0x3f
Apr  2 05:25:37 werner kernel:  [<c10f0863>] 
bprm_mm_init+0x17/0x6a
Apr  2 05:25:37 werner kernel:  [<c10f09b6>] 
do_execve_common+0x100/0x26d
Apr  2 05:25:37 werner kernel:  [<c10f0b3a>] 
do_execve+0x17/0x1b
Apr  2 05:25:37 werner kernel:  [<c100a16e>] 
sys_execve+0x31/0x54
Apr  2 05:25:37 werner kernel:  [<c2089e42>] 
ptregs_execve+0x12/0x20
Apr  2 05:25:37 werner kernel:  [<c2088cdc>] ? 
syscall_call+0x7/0xb
Apr  2 05:25:37 werner kernel: Mem-Info:
Apr  2 05:25:37 werner kernel: DMA per-cpu:
Apr  2 05:25:37 werner kernel: CPU    0: hi:    0, btch: 
  1 usd:   0
Apr  2 05:25:37 werner kernel: Normal per-cpu:
Apr  2 05:25:37 werner kernel: CPU    0: hi:  186, btch: 
 31 usd:  30
Apr  2 05:25:37 werner kernel: HighMem per-cpu:
Apr  2 05:25:37 werner kernel: CPU    0: hi:  186, btch: 
 31 usd:  17
Apr  2 05:25:37 werner kernel: active_anon:44267 
inactive_anon:29 isolated_anon:0
Apr  2 05:25:37 werner kernel:  active_file:18787 
inactive_file:7051 isolated_file:0
Apr  2 05:25:37 werner kernel:  unevictable:0 dirty:1 
writeback:0 unstable:0
Apr  2 05:25:37 werner kernel:  free:495128 
slab_reclaimable:3251 slab_unreclaimable:49288
Apr  2 05:25:37 werner kernel:  mapped:17826 shmem:674 
pagetables:566 bounce:0
Apr  2 05:25:37 werner kernel: DMA free:4236kB min:784kB 
low:980kB high:1176kB active_anon:0kB inactive_anon:0kB 
active_file:0kB inactive_file:12kB unevictable:0kB 
isolated(anon):0kB isolated(file):0kB present:15804kB 
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB 
slab_reclaimable:0kB slab_unreclaimable:2352kB 
kernel_stack:9248kB pagetables:0kB unstable:0kB bounce:0kB 
writeback_tmp:0kB pages_scanned:70 all_unreclaimable? yes
Apr  2 05:25:37 werner kernel: lowmem_reserve[]: 0 865 
3031 3031
Apr  2 05:25:37 werner kernel: Normal free:44008kB 
min:44012kB low:55012kB high:66016kB active_anon:11400kB 
inactive_anon:0kB active_file:132kB inactive_file:128kB 
unevictable:0kB isolated(anon):0kB isolated(file):0kB 
present:885944kB mlocked:0kB dirty:0kB writeback:0kB 
mapped:0kB shmem:0kB slab_reclaimable:13004kB 
slab_unreclaimable:194800kB kernel_stack:570784kB 
pagetables:40kB unstable:0kB bounce:0kB writeback_tmp:0kB 
pages_scanned:438 all_unreclaimable? yes
Apr  2 05:25:37 werner kernel: lowmem_reserve[]: 0 0 17326 
17326
Apr  2 05:25:37 werner kernel: HighMem free:1932268kB 
min:512kB low:28056kB high:55600kB active_anon:165668kB 
inactive_anon:116kB active_file:75016kB 
inactive_file:28064kB unevictable:0kB isolated(anon):0kB 
isolated(file):0kB present:2217808kB mlocked:0kB dirty:4kB 
writeback:0kB mapped:71304kB shmem:2696kB 
slab_reclaimable:0kB slab_unreclaimable:0kB 
kernel_stack:0kB pagetables:2224kB unstable:0kB bounce:0kB 
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
Apr  2 05:25:37 werner kernel: lowmem_reserve[]: 0 0 0 0
Apr  2 05:25:37 werner kernel: DMA: 5*4kB 3*8kB 10*16kB 
4*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 
0*4096kB = 4236kB
Apr  2 05:25:37 werner kernel: Normal: 2274*4kB 3340*8kB 
0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 
0*2048kB 2*4096kB = 44008kB
Apr  2 05:25:37 werner kernel: HighMem: 12363*4kB 
12960*8kB 10184*16kB 7462*32kB 4608*64kB 2317*128kB 
842*256kB 274*512kB 104*1024kB 62*2048kB 48*4096kB = 
1932268kB
Apr  2 05:25:37 werner kernel: 26519 total pagecache pages
Apr  2 05:25:37 werner kernel: 0 pages in swap cache
Apr  2 05:25:37 werner kernel: Swap cache stats: add 0, 
delete 0, find 0/0
Apr  2 05:25:37 werner kernel: Free swap  = 0kB
Apr  2 05:25:37 werner kernel: Total swap = 0kB
Apr  2 05:25:37 werner kernel: 786128 pages RAM
Apr  2 05:25:37 werner kernel: 558818 pages HighMem
Apr  2 05:25:37 werner kernel: 13576 pages reserved
Apr  2 05:25:37 werner kernel: 101260 pages shared
Apr  2 05:25:37 werner kernel: 182646 pages non-shared
Apr  2 05:25:37 werner kernel: Out of memory: Kill process 
4539 (httpd) score 4 or sacrifice child
Apr  2 05:25:37 werner kernel: Killed process 4539 (httpd) 
total-vm:56420kB, anon-rss:9136kB, file-rss:3632kB
Apr  2 05:27:39 werner kernel: iwconfig invoked 
oom-killer: gfp_mask=0x800d0, order=0, oom_adj=0, 
oom_score_adj=0
Apr  2 05:27:39 werner kernel: Pid: 6040, comm: iwconfig 
Not tainted 3.4.0-rc1-i486-1sys #1
Apr  2 05:27:39 werner kernel: Call Trace:
Apr  2 05:27:39 werner kernel:  [<c10356cf>] ? 
printk+0x20/0x22
Apr  2 05:27:39 werner kernel:  [<c10af0f7>] 
dump_header+0x6f/0x95
Apr  2 05:27:39 werner kernel:  [<c10af30b>] 
oom_kill_process+0x52/0x251
Apr  2 05:27:39 werner kernel:  [<c10af5cf>] ? 
select_bad_process+0xc5/0x11c
Apr  2 05:27:39 werner kernel:  [<c10af76a>] 
out_of_memory+0x144/0x1b4
Apr  2 05:27:39 werner kernel:  [<c10b2468>] 
__alloc_pages_nodemask+0x501/0x63f
Apr  2 05:27:39 werner kernel:  [<c10b25c2>] 
__get_free_pages+0x1c/0x2d
Apr  2 05:27:39 werner kernel:  [<c1131685>] 
do_proc_readlink+0x27/0x7b
Apr  2 05:27:39 werner kernel:  [<c113306f>] 
proc_pid_readlink+0x48/0x5b
Apr  2 05:27:39 werner kernel:  [<c10ee786>] 
sys_readlinkat+0x81/0x95
Apr  2 05:27:39 werner kernel:  [<c10ee7c6>] 
sys_readlink+0x2c/0x2e
Apr  2 05:27:39 werner kernel:  [<c2088cdc>] 
syscall_call+0x7/0xb
Apr  2 05:27:39 werner kernel: Mem-Info:
Apr  2 05:27:39 werner kernel: DMA per-cpu:
Apr  2 05:27:39 werner kernel: CPU    0: hi:    0, btch: 
  1 usd:   0
Apr  2 05:27:39 werner kernel: Normal per-cpu:
Apr  2 05:27:39 werner kernel: CPU    0: hi:  186, btch: 
 31 usd:  30
Apr  2 05:27:39 werner kernel: HighMem per-cpu:
Apr  2 05:27:39 werner kernel: CPU    0: hi:  186, btch: 
 31 usd:  32
Apr  2 05:27:39 werner kernel: active_anon:43261 
inactive_anon:29 isolated_anon:0
Apr  2 05:27:39 werner kernel:  active_file:19035 
inactive_file:7129 isolated_file:0
Apr  2 05:27:39 werner kernel:  unevictable:0 dirty:0 
writeback:0 unstable:0
Apr  2 05:27:39 werner kernel:  free:494972 
slab_reclaimable:3250 slab_unreclaimable:49378
Apr  2 05:27:39 werner kernel:  mapped:17826 shmem:674 
pagetables:538 bounce:0
Apr  2 05:27:39 werner kernel: DMA free:4244kB min:784kB 
low:980kB high:1176kB active_anon:0kB inactive_anon:0kB 
active_file:0kB inactive_file:4kB unevictable:0kB 
isolated(anon):0kB isolated(file):0kB present:15804kB 
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB 
slab_reclaimable:0kB slab_unreclaimable:2352kB 
kernel_stack:9248kB pagetables:0kB unstable:0kB bounce:0kB 
writeback_tmp:0kB pages_scanned:21 all_unreclaimable? yes
Apr  2 05:27:39 werner kernel: lowmem_reserve[]: 0 865 
3031 3031
Apr  2 05:27:39 werner kernel: Normal free:44004kB 
min:44012kB low:55012kB high:66016kB active_anon:8064kB 
inactive_anon:0kB active_file:164kB inactive_file:104kB 
unevictable:0kB isolated(anon):0kB isolated(file):0kB 
present:885944kB mlocked:0kB dirty:0kB writeback:0kB 
mapped:0kB shmem:0kB slab_reclaimable:13000kB 
slab_unreclaimable:195160kB kernel_stack:573776kB 
pagetables:32kB unstable:0kB bounce:0kB writeback_tmp:0kB 
pages_scanned:412 all_unreclaimable? yes
Apr  2 05:27:39 werner kernel: lowmem_reserve[]: 0 0 17326 
17326
Apr  2 05:27:39 werner kernel: HighMem free:1931640kB 
min:512kB low:28056kB high:55600kB active_anon:164980kB 
inactive_anon:116kB active_file:75976kB 
inactive_file:28408kB unevictable:0kB isolated(anon):0kB 
isolated(file):0kB present:2217808kB mlocked:0kB dirty:0kB 
writeback:0kB mapped:71304kB shmem:2696kB 
slab_reclaimable:0kB slab_unreclaimable:0kB 
kernel_stack:0kB pagetables:2120kB unstable:0kB bounce:0kB 
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
Apr  2 05:27:39 werner kernel: lowmem_reserve[]: 0 0 0 0
Apr  2 05:27:39 werner kernel: DMA: 3*4kB 5*8kB 10*16kB 
4*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 
0*4096kB = 4244kB
Apr  2 05:27:39 werner kernel: Normal: 2483*4kB 3235*8kB 
0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 
0*2048kB 2*4096kB = 44004kB
Apr  2 05:27:39 werner kernel: HighMem: 11824*4kB 
12853*8kB 10107*16kB 7437*32kB 4603*64kB 2328*128kB 
847*256kB 274*512kB 104*1024kB 61*2048kB 49*4096kB = 
1931640kB
Apr  2 05:27:39 werner kernel: 26838 total pagecache pages
Apr  2 05:27:39 werner kernel: 0 pages in swap cache
Apr  2 05:27:39 werner kernel: Swap cache stats: add 0, 
delete 0, find 0/0
Apr  2 05:27:39 werner kernel: Free swap  = 0kB
Apr  2 05:27:39 werner kernel: Total swap = 0kB
Apr  2 05:27:39 werner kernel: 786128 pages RAM
Apr  2 05:27:39 werner kernel: 558818 pages HighMem
Apr  2 05:27:39 werner kernel: 13576 pages reserved
Apr  2 05:27:39 werner kernel: 98975 pages shared
Apr  2 05:27:39 werner kernel: 182389 pages non-shared
Apr  2 05:27:39 werner kernel: Out of memory: Kill process 
4540 (httpd) score 4 or sacrifice child
Apr  2 05:27:39 werner kernel: Killed process 4540 (httpd) 
total-vm:56924kB, anon-rss:9612kB, file-rss:3628kB
Apr  2 05:27:42 werner kernel: kded invoked oom-killer: 
gfp_mask=0x84d0, order=0, oom_adj=0, oom_score_adj=0
Apr  2 05:27:42 werner kernel: Pid: 6052, comm: kded Not 
tainted 3.4.0-rc1-i486-1sys #1
Apr  2 05:27:42 werner kernel: Call Trace:
Apr  2 05:27:42 werner kernel:  [<c10356cf>] ? 
printk+0x20/0x22
Apr  2 05:27:42 werner kernel:  [<c10af0f7>] 
dump_header+0x6f/0x95
Apr  2 05:27:42 werner kernel:  [<c10af30b>] 
oom_kill_process+0x52/0x251
Apr  2 05:27:42 werner kernel:  [<c10af5cf>] ? 
select_bad_process+0xc5/0x11c
Apr  2 05:27:42 werner kernel:  [<c10af76a>] 
out_of_memory+0x144/0x1b4
Apr  2 05:27:42 werner kernel:  [<c10b2468>] 
__alloc_pages_nodemask+0x501/0x63f
Apr  2 05:27:42 werner kernel:  [<c10b25c2>] 
__get_free_pages+0x1c/0x2d
Apr  2 05:27:42 werner kernel:  [<c102bf07>] 
pgd_alloc+0x1e/0x79
Apr  2 05:27:42 werner kernel:  [<c103379b>] ? 
mm_alloc+0x18/0x3f
Apr  2 05:27:42 werner kernel:  [<c1032605>] 
mm_init+0xad/0xdb
Apr  2 05:27:42 werner kernel:  [<c10337bf>] 
mm_alloc+0x3c/0x3f
Apr  2 05:27:42 werner kernel:  [<c10f0863>] 
bprm_mm_init+0x17/0x6a
Apr  2 05:27:42 werner kernel:  [<c10f09b6>] 
do_execve_common+0x100/0x26d
Apr  2 05:27:42 werner kernel:  [<c10f0b3a>] 
do_execve+0x17/0x1b
Apr  2 05:27:42 werner kernel:  [<c100a16e>] 
sys_execve+0x31/0x54
Apr  2 05:27:42 werner kernel:  [<c2089e42>] 
ptregs_execve+0x12/0x20
Apr  2 05:27:42 werner kernel:  [<c2088cdc>] ? 
syscall_call+0x7/0xb
Apr  2 05:27:42 werner kernel: Mem-Info:
Apr  2 05:27:42 werner kernel: DMA per-cpu:
Apr  2 05:27:42 werner kernel: CPU    0: hi:    0, btch: 
  1 usd:   0
Apr  2 05:27:42 werner kernel: Normal per-cpu:
Apr  2 05:27:42 werner kernel: CPU    0: hi:  186, btch: 
 31 usd:  30
Apr  2 05:27:42 werner kernel: HighMem per-cpu:
Apr  2 05:27:42 werner kernel: CPU    0: hi:  186, btch: 
 31 usd:  22
Apr  2 05:27:42 werner kernel: active_anon:42028 
inactive_anon:29 isolated_anon:0
Apr  2 05:27:42 werner kernel:  active_file:19034 
inactive_file:7133 isolated_file:0
Apr  2 05:27:42 werner kernel:  unevictable:0 dirty:1 
writeback:0 unstable:0
Apr  2 05:27:42 werner kernel:  free:496212 
slab_reclaimable:3249 slab_unreclaimable:49376
Apr  2 05:27:42 werner kernel:  mapped:17826 shmem:674 
pagetables:548 bounce:0
Apr  2 05:27:42 werner kernel: DMA free:4236kB min:784kB 
low:980kB high:1176kB active_anon:0kB inactive_anon:0kB 
active_file:0kB inactive_file:12kB unevictable:0kB 
isolated(anon):0kB isolated(file):0kB present:15804kB 
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB 
slab_reclaimable:0kB slab_unreclaimable:2352kB 
kernel_stack:9248kB pagetables:0kB unstable:0kB bounce:0kB 
writeback_tmp:0kB pages_scanned:48 all_unreclaimable? yes
Apr  2 05:27:42 werner kernel: lowmem_reserve[]: 0 865 
3031 3031
Apr  2 05:27:42 werner kernel: Normal free:43972kB 
min:44012kB low:55012kB high:66016kB active_anon:8064kB 
inactive_anon:0kB active_file:136kB inactive_file:128kB 
unevictable:0kB isolated(anon):0kB isolated(file):0kB 
present:885944kB mlocked:0kB dirty:0kB writeback:0kB 
mapped:0kB shmem:0kB slab_reclaimable:12996kB 
slab_unreclaimable:195152kB kernel_stack:573848kB 
pagetables:32kB unstable:0kB bounce:0kB writeback_tmp:0kB 
pages_scanned:443 all_unreclaimable? yes
Apr  2 05:27:42 werner kernel: lowmem_reserve[]: 0 0 17326 
17326
Apr  2 05:27:42 werner kernel: HighMem free:1936640kB 
min:512kB low:28056kB high:55600kB active_anon:160048kB 
inactive_anon:116kB active_file:76000kB 
inactive_file:28392kB unevictable:0kB isolated(anon):0kB 
isolated(file):0kB present:2217808kB mlocked:0kB dirty:4kB 
writeback:0kB mapped:71304kB shmem:2696kB 
slab_reclaimable:0kB slab_unreclaimable:0kB 
kernel_stack:0kB pagetables:2160kB unstable:0kB bounce:0kB 
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
Apr  2 05:27:42 werner kernel: lowmem_reserve[]: 0 0 0 0
Apr  2 05:27:42 werner kernel: DMA: 5*4kB 3*8kB 10*16kB 
4*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 
0*4096kB = 4236kB
Apr  2 05:27:42 werner kernel: Normal: 2485*4kB 3230*8kB 
0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 
0*2048kB 2*4096kB = 43972kB
Apr  2 05:27:42 werner kernel: HighMem: 11818*4kB 
12809*8kB 10101*16kB 7426*32kB 4626*64kB 2344*128kB 
848*256kB 272*512kB 103*1024kB 59*2048kB 51*4096kB = 
1936640kB
Apr  2 05:27:42 werner kernel: 26841 total pagecache pages
Apr  2 05:27:42 werner kernel: 0 pages in swap cache
Apr  2 05:27:42 werner kernel: Swap cache stats: add 0, 
delete 0, find 0/0
Apr  2 05:27:42 werner kernel: Free swap  = 0kB
Apr  2 05:27:42 werner kernel: Total swap = 0kB
Apr  2 05:27:42 werner kernel: 786128 pages RAM
Apr  2 05:27:42 werner kernel: 558818 pages HighMem
Apr  2 05:27:42 werner kernel: 13576 pages reserved
Apr  2 05:27:42 werner kernel: 97196 pages shared
Apr  2 05:27:42 werner kernel: 181165 pages non-shared
Apr  2 05:27:42 werner kernel: Out of memory: Kill process 
6574 (httpd) score 4 or sacrifice child
Apr  2 05:27:42 werner kernel: Killed process 6574 (httpd) 
total-vm:56668kB, anon-rss:9388kB, file-rss:3632kB
Apr  2 05:27:42 werner kernel: kded invoked oom-killer: 
gfp_mask=0x84d0, order=0, oom_adj=0, oom_score_adj=0
Apr  2 05:27:42 werner kernel: Pid: 6052, comm: kded Not 
tainted 3.4.0-rc1-i486-1sys #1
Apr  2 05:27:42 werner kernel: Call Trace:
Apr  2 05:27:42 werner kernel:  [<c10356cf>] ? 
printk+0x20/0x22
Apr  2 05:27:42 werner kernel:  [<c10af0f7>] 
dump_header+0x6f/0x95
Apr  2 05:27:42 werner kernel:  [<c10af30b>] 
oom_kill_process+0x52/0x251
Apr  2 05:27:42 werner kernel:  [<c10af5cf>] ? 
select_bad_process+0xc5/0x11c
Apr  2 05:27:42 werner kernel:  [<c10af76a>] 
out_of_memory+0x144/0x1b4
Apr  2 05:27:42 werner kernel:  [<c10b2468>] 
__alloc_pages_nodemask+0x501/0x63f
Apr  2 05:27:42 werner kernel:  [<c10b25c2>] 
__get_free_pages+0x1c/0x2d
Apr  2 05:27:42 werner kernel:  [<c102bf07>] 
pgd_alloc+0x1e/0x79
Apr  2 05:27:42 werner kernel:  [<c103379b>] ? 
mm_alloc+0x18/0x3f
Apr  2 05:27:42 werner kernel:  [<c1032605>] 
mm_init+0xad/0xdb
Apr  2 05:27:42 werner kernel:  [<c10337bf>] 
mm_alloc+0x3c/0x3f
Apr  2 05:27:42 werner kernel:  [<c10f0863>] 
bprm_mm_init+0x17/0x6a
Apr  2 05:27:42 werner kernel:  [<c10f09b6>] 
do_execve_common+0x100/0x26d
Apr  2 05:27:42 werner kernel:  [<c10f0b3a>] 
do_execve+0x17/0x1b
Apr  2 05:27:42 werner kernel:  [<c100a16e>] 
sys_execve+0x31/0x54
Apr  2 05:27:42 werner kernel:  [<c2089e42>] 
ptregs_execve+0x12/0x20
Apr  2 05:27:42 werner kernel:  [<c2088cdc>] ? 
syscall_call+0x7/0xb
Apr  2 05:27:42 werner kernel: Mem-Info:
Apr  2 05:27:42 werner kernel: DMA per-cpu:
Apr  2 05:27:42 werner kernel: CPU    0: hi:    0, btch: 
  1 usd:   0
Apr  2 05:27:42 werner kernel: Normal per-cpu:
Apr  2 05:27:42 werner kernel: CPU    0: hi:  186, btch: 
 31 usd:  37
Apr  2 05:27:42 werner kernel: HighMem per-cpu:
Apr  2 05:27:42 werner kernel: CPU    0: hi:  186, btch: 
 31 usd: 161
Apr  2 05:27:42 werner kernel: active_anon:40819 
inactive_anon:29 isolated_anon:0
Apr  2 05:27:42 werner kernel:  active_file:19034 
inactive_file:7133 isolated_file:0
Apr  2 05:27:42 werner kernel:  unevictable:0 dirty:1 
writeback:0 unstable:0
Apr  2 05:27:42 werner kernel:  free:497297 
slab_reclaimable:3249 slab_unreclaimable:49376
Apr  2 05:27:42 werner kernel:  mapped:17826 shmem:674 
pagetables:529 bounce:0
Apr  2 05:27:42 werner kernel: DMA free:4236kB min:784kB 
low:980kB high:1176kB active_anon:0kB inactive_anon:0kB 
active_file:0kB inactive_file:12kB unevictable:0kB 
isolated(anon):0kB isolated(file):0kB present:15804kB 
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB 
slab_reclaimable:0kB slab_unreclaimable:2352kB 
kernel_stack:9248kB pagetables:0kB unstable:0kB bounce:0kB 
writeback_tmp:0kB pages_scanned:108 all_unreclaimable? yes
Apr  2 05:27:42 werner kernel: lowmem_reserve[]: 0 865 
3031 3031
Apr  2 05:27:42 werner kernel: Normal free:43972kB 
min:44012kB low:55012kB high:66016kB active_anon:8064kB 
inactive_anon:0kB active_file:136kB inactive_file:128kB 
unevictable:0kB isolated(anon):0kB isolated(file):0kB 
present:885944kB mlocked:0kB dirty:0kB writeback:0kB 
mapped:0kB shmem:0kB slab_reclaimable:12996kB 
slab_unreclaimable:195152kB kernel_stack:573848kB 
pagetables:32kB unstable:0kB bounce:0kB writeback_tmp:0kB 
pages_scanned:1083 all_unreclaimable? yes
Apr  2 05:27:42 werner kernel: lowmem_reserve[]: 0 0 17326 
17326
Apr  2 05:27:42 werner kernel: HighMem free:1940980kB 
min:512kB low:28056kB high:55600kB active_anon:155212kB 
inactive_anon:116kB active_file:76000kB 
inactive_file:28392kB unevictable:0kB isolated(anon):0kB 
isolated(file):0kB present:2217808kB mlocked:0kB dirty:4kB 
writeback:0kB mapped:71304kB shmem:2696kB 
slab_reclaimable:0kB slab_unreclaimable:0kB 
kernel_stack:0kB pagetables:2084kB unstable:0kB bounce:0kB 
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
Apr  2 05:27:42 werner kernel: lowmem_reserve[]: 0 0 0 0
Apr  2 05:27:42 werner kernel: DMA: 5*4kB 3*8kB 10*16kB 
4*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 
0*4096kB = 4236kB
Apr  2 05:27:42 werner kernel: Normal: 2485*4kB 3230*8kB 
0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 
0*2048kB 2*4096kB = 43972kB
Apr  2 05:27:42 werner kernel: HighMem: 11447*4kB 
12465*8kB 9903*16kB 7357*32kB 4620*64kB 2356*128kB 
868*256kB 281*512kB 102*1024kB 57*2048kB 53*4096kB = 
1940980kB
Apr  2 05:27:42 werner kernel: 26841 total pagecache pages
Apr  2 05:27:42 werner kernel: 0 pages in swap cache
Apr  2 05:27:42 werner kernel: Swap cache stats: add 0, 
delete 0, find 0/0
Apr  2 05:27:42 werner kernel: Free swap  = 0kB
Apr  2 05:27:42 werner kernel: Total swap = 0kB
Apr  2 05:27:42 werner kernel: 786128 pages RAM
Apr  2 05:27:42 werner kernel: 558818 pages HighMem
Apr  2 05:27:42 werner kernel: 13576 pages reserved
Apr  2 05:27:42 werner kernel: 95157 pages shared
Apr  2 05:27:42 werner kernel: 179933 pages non-shared
Apr  2 05:27:43 werner kernel: Out of memory: Kill process 
11568 (httpd) score 4 or sacrifice child
Apr  2 05:27:43 werner kernel: Killed process 11568 
(httpd) total-vm:56420kB, anon-rss:9140kB, file-rss:3588kB
Apr  2 05:27:43 werner kernel: kded invoked oom-killer: 
gfp_mask=0x84d0, order=0, oom_adj=0, oom_score_adj=0
Apr  2 05:27:43 werner kernel: Pid: 6052, comm: kded Not 
tainted 3.4.0-rc1-i486-1sys #1
Apr  2 05:27:43 werner kernel: Call Trace:
Apr  2 05:27:43 werner kernel:  [<c10356cf>] ? 
printk+0x20/0x22
Apr  2 05:27:43 werner kernel:  [<c10af0f7>] 
dump_header+0x6f/0x95
Apr  2 05:27:43 werner kernel:  [<c10af30b>] 
oom_kill_process+0x52/0x251
Apr  2 05:27:43 werner kernel:  [<c10af5cf>] ? 
select_bad_process+0xc5/0x11c
Apr  2 05:27:43 werner kernel:  [<c10af76a>] 
out_of_memory+0x144/0x1b4
Apr  2 05:27:43 werner kernel:  [<c10b2468>] 
__alloc_pages_nodemask+0x501/0x63f
Apr  2 05:27:43 werner kernel:  [<c10b25c2>] 
__get_free_pages+0x1c/0x2d
Apr  2 05:27:43 werner kernel:  [<c102bf07>] 
pgd_alloc+0x1e/0x79
Apr  2 05:27:43 werner kernel:  [<c103379b>] ? 
mm_alloc+0x18/0x3f
Apr  2 05:27:43 werner kernel:  [<c1032605>] 
mm_init+0xad/0xdb
Apr  2 05:27:43 werner kernel:  [<c10337bf>] 
mm_alloc+0x3c/0x3f
Apr  2 05:27:43 werner kernel:  [<c10f0863>] 
bprm_mm_init+0x17/0x6a
Apr  2 05:27:43 werner kernel:  [<c10f09b6>] 
do_execve_common+0x100/0x26d
Apr  2 05:27:43 werner kernel:  [<c10f0b3a>] 
do_execve+0x17/0x1b
Apr  2 05:27:43 werner kernel:  [<c100a16e>] 
sys_execve+0x31/0x54
Apr  2 05:27:43 werner kernel:  [<c2089e42>] 
ptregs_execve+0x12/0x20
Apr  2 05:27:43 werner kernel:  [<c2088cdc>] ? 
syscall_call+0x7/0xb
Apr  2 05:27:43 werner kernel: Mem-Info:
Apr  2 05:27:43 werner kernel: DMA per-cpu:
Apr  2 05:27:43 werner kernel: CPU    0: hi:    0, btch: 
  1 usd:   0
Apr  2 05:27:43 werner kernel: Normal per-cpu:
Apr  2 05:27:43 werner kernel: CPU    0: hi:  186, btch: 
 31 usd:  45
Apr  2 05:27:43 werner kernel: HighMem per-cpu:
Apr  2 05:27:43 werner kernel: CPU    0: hi:  186, btch: 
 31 usd: 177
Apr  2 05:27:43 werner kernel: active_anon:39675 
inactive_anon:29 isolated_anon:0
Apr  2 05:27:43 werner kernel:  active_file:19034 
inactive_file:7133 isolated_file:0
Apr  2 05:27:43 werner kernel:  unevictable:0 dirty:1 
writeback:0 unstable:0
Apr  2 05:27:43 werner kernel:  free:498444 
slab_reclaimable:3249 slab_unreclaimable:49367
Apr  2 05:27:43 werner kernel:  mapped:17826 shmem:674 
pagetables:529 bounce:0
Apr  2 05:27:43 werner kernel: DMA free:4236kB min:784kB 
low:980kB high:1176kB active_anon:0kB inactive_anon:0kB 
active_file:0kB inactive_file:12kB unevictable:0kB 
isolated(anon):0kB isolated(file):0kB present:15804kB 
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB 
slab_reclaimable:0kB slab_unreclaimable:2352kB 
kernel_stack:9248kB pagetables:0kB unstable:0kB bounce:0kB 
writeback_tmp:0kB pages_scanned:114 all_unreclaimable? yes
Apr  2 05:27:43 werner kernel: lowmem_reserve[]: 0 865 
3031 3031
Apr  2 05:27:43 werner kernel: Normal free:43972kB 
min:44012kB low:55012kB high:66016kB active_anon:8064kB 
inactive_anon:0kB active_file:136kB inactive_file:128kB 
unevictable:0kB isolated(anon):0kB isolated(file):0kB 
present:885944kB mlocked:0kB dirty:0kB writeback:0kB 
mapped:0kB shmem:0kB slab_reclaimable:12996kB 
slab_unreclaimable:195116kB kernel_stack:573848kB 
pagetables:32kB unstable:0kB bounce:0kB writeback_tmp:0kB 
pages_scanned:1147 all_unreclaimable? yes
Apr  2 05:27:43 werner kernel: lowmem_reserve[]: 0 0 17326 
17326
Apr  2 05:27:43 werner kernel: HighMem free:1945568kB 
min:512kB low:28056kB high:55600kB active_anon:150636kB 
inactive_anon:116kB active_file:76000kB 
inactive_file:28392kB unevictable:0kB isolated(anon):0kB 
isolated(file):0kB present:2217808kB mlocked:0kB dirty:4kB 
writeback:0kB mapped:71304kB shmem:2696kB 
slab_reclaimable:0kB slab_unreclaimable:0kB 
kernel_stack:0kB pagetables:2084kB unstable:0kB bounce:0kB 
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
Apr  2 05:27:43 werner kernel: lowmem_reserve[]: 0 0 0 0
Apr  2 05:27:43 werner kernel: DMA: 5*4kB 3*8kB 10*16kB 
4*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 
0*4096kB = 4236kB
Apr  2 05:27:43 werner kernel: Normal: 2485*4kB 3230*8kB 
0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 
0*2048kB 2*4096kB = 43972kB
Apr  2 05:27:43 werner kernel: HighMem: 11448*4kB 
12282*8kB 9751*16kB 7244*32kB 4585*64kB 2398*128kB 
885*256kB 288*512kB 103*1024kB 57*2048kB 53*4096kB = 
1945568kB
Apr  2 05:27:43 werner kernel: 26841 total pagecache pages
Apr  2 05:27:43 werner kernel: 0 pages in swap cache
Apr  2 05:27:43 werner kernel: Swap cache stats: add 0, 
delete 0, find 0/0
Apr  2 05:27:43 werner kernel: Free swap  = 0kB
Apr  2 05:27:43 werner kernel: Total swap = 0kB
Apr  2 05:27:43 werner kernel: 786128 pages RAM
Apr  2 05:27:43 werner kernel: 558818 pages HighMem
Apr  2 05:27:43 werner kernel: 13576 pages reserved
Apr  2 05:27:43 werner kernel: 93129 pages shared
Apr  2 05:27:43 werner kernel: 178763 pages non-shared
Apr  2 05:27:43 werner kernel: Out of memory: Kill process 
3489 (named) score 3 or sacrifice child
Apr  2 05:27:43 werner kernel: Killed process 3489 (named) 
total-vm:41104kB, anon-rss:9568kB, file-rss:2420kB
Apr  2 05:27:43 werner kernel: kded invoked oom-killer: 
gfp_mask=0x84d0, order=0, oom_adj=0, oom_score_adj=0
Apr  2 05:27:43 werner kernel: Pid: 6052, comm: kded Not 
tainted 3.4.0-rc1-i486-1sys #1
Apr  2 05:27:43 werner kernel: Call Trace:
Apr  2 05:27:43 werner kernel:  [<c10356cf>] ? 
printk+0x20/0x22
Apr  2 05:27:43 werner kernel:  [<c10af0f7>] 
dump_header+0x6f/0x95
Apr  2 05:27:43 werner kernel:  [<c10af30b>] 
oom_kill_process+0x52/0x251
Apr  2 05:27:43 werner kernel:  [<c10af5cf>] ? 
select_bad_process+0xc5/0x11c
Apr  2 05:27:43 werner kernel:  [<c10af76a>] 
out_of_memory+0x144/0x1b4
Apr  2 05:27:43 werner kernel:  [<c10b2468>] 
__alloc_pages_nodemask+0x501/0x63f
Apr  2 05:27:43 werner kernel:  [<c10b25c2>] 
__get_free_pages+0x1c/0x2d
Apr  2 05:27:43 werner kernel:  [<c102bf07>] 
pgd_alloc+0x1e/0x79
Apr  2 05:27:43 werner kernel:  [<c103379b>] ? 
mm_alloc+0x18/0x3f
Apr  2 05:27:43 werner kernel:  [<c1032605>] 
mm_init+0xad/0xdb
Apr  2 05:27:43 werner kernel:  [<c10337bf>] 
mm_alloc+0x3c/0x3f
Apr  2 05:27:43 werner kernel:  [<c10f0863>] 
bprm_mm_init+0x17/0x6a
Apr  2 05:27:43 werner kernel:  [<c10f09b6>] 
do_execve_common+0x100/0x26d
Apr  2 05:27:43 werner kernel:  [<c10f0b3a>] 
do_execve+0x17/0x1b
Apr  2 05:27:43 werner kernel:  [<c100a16e>] 
sys_execve+0x31/0x54
Apr  2 05:27:43 werner kernel:  [<c2089e42>] 
ptregs_execve+0x12/0x20
Apr  2 05:27:43 werner kernel:  [<c2088cdc>] ? 
syscall_call+0x7/0xb
Apr  2 05:27:43 werner kernel: Mem-Info:
Apr  2 05:27:43 werner kernel: DMA per-cpu:
Apr  2 05:27:43 werner kernel: CPU    0: hi:    0, btch: 
  1 usd:   0
Apr  2 05:27:43 werner kernel: Normal per-cpu:
Apr  2 05:27:43 werner kernel: CPU    0: hi:  186, btch: 
 31 usd:  50
Apr  2 05:27:43 werner kernel: HighMem per-cpu:
Apr  2 05:27:43 werner kernel: CPU    0: hi:  186, btch: 
 31 usd: 167
Apr  2 05:27:43 werner kernel: active_anon:37209 
inactive_anon:29 isolated_anon:0
Apr  2 05:27:43 werner kernel:  active_file:19034 
inactive_file:7133 isolated_file:0
Apr  2 05:27:43 werner kernel:  unevictable:0 dirty:1 
writeback:0 unstable:0
Apr  2 05:27:43 werner kernel:  free:500925 
slab_reclaimable:3249 slab_unreclaimable:49367
Apr  2 05:27:43 werner kernel:  mapped:17408 shmem:674 
pagetables:510 bounce:0
Apr  2 05:27:43 werner kernel: DMA free:4236kB min:784kB 
low:980kB high:1176kB active_anon:0kB inactive_anon:0kB 
active_file:0kB inactive_file:12kB unevictable:0kB 
isolated(anon):0kB isolated(file):0kB present:15804kB 
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB 
slab_reclaimable:0kB slab_unreclaimable:2352kB 
kernel_stack:9248kB pagetables:0kB unstable:0kB bounce:0kB 
writeback_tmp:0kB pages_scanned:120 all_unreclaimable? yes
Apr  2 05:27:43 werner kernel: lowmem_reserve[]: 0 865 
3031 3031
Apr  2 05:27:43 werner kernel: Normal free:43972kB 
min:44012kB low:55012kB high:66016kB active_anon:8064kB 
inactive_anon:0kB active_file:136kB inactive_file:128kB 
unevictable:0kB isolated(anon):0kB isolated(file):0kB 
present:885944kB mlocked:0kB dirty:0kB writeback:0kB 
mapped:0kB shmem:0kB slab_reclaimable:12996kB 
slab_unreclaimable:195116kB kernel_stack:573848kB 
pagetables:32kB unstable:0kB bounce:0kB writeback_tmp:0kB 
pages_scanned:1210 all_unreclaimable? yes
Apr  2 05:27:43 werner kernel: lowmem_reserve[]: 0 0 17326 
17326
Apr  2 05:27:43 werner kernel: HighMem free:1955492kB 
min:512kB low:28056kB high:55600kB active_anon:140772kB 
inactive_anon:116kB active_file:76000kB 
inactive_file:28392kB unevictable:0kB isolated(anon):0kB 
isolated(file):0kB present:2217808kB mlocked:0kB dirty:4kB 
writeback:0kB mapped:69632kB shmem:2696kB 
slab_reclaimable:0kB slab_unreclaimable:0kB 
kernel_stack:0kB pagetables:2008kB unstable:0kB bounce:0kB 
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
Apr  2 05:27:43 werner kernel: lowmem_reserve[]: 0 0 0 0
Apr  2 05:27:43 werner kernel: DMA: 5*4kB 3*8kB 10*16kB 
4*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 
0*4096kB = 4236kB
Apr  2 05:27:43 werner kernel: Normal: 2485*4kB 3230*8kB 
0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 
0*2048kB 2*4096kB = 43972kB
Apr  2 05:27:43 werner kernel: HighMem: 11307*4kB 
11987*8kB 9412*16kB 7089*32kB 4534*64kB 2475*128kB 
920*256kB 295*512kB 103*1024kB 57*2048kB 54*4096kB = 
1955492kB
Apr  2 05:27:43 werner kernel: 26841 total pagecache pages
Apr  2 05:27:43 werner kernel: 0 pages in swap cache
Apr  2 05:27:43 werner kernel: Swap cache stats: add 0, 
delete 0, find 0/0
Apr  2 05:27:43 werner kernel: Free swap  = 0kB
Apr  2 05:27:43 werner kernel: Total swap = 0kB
Apr  2 05:27:43 werner kernel: 786128 pages RAM
Apr  2 05:27:43 werner kernel: 558818 pages HighMem
Apr  2 05:27:43 werner kernel: 13576 pages reserved
Apr  2 05:27:43 werner kernel: 92497 pages shared
Apr  2 05:27:43 werner kernel: 176704 pages non-shared
Apr  2 05:27:43 werner kernel: Out of memory: Kill process 
4536 (httpd) score 3 or sacrifice child
Apr  2 05:27:43 werner kernel: Killed process 4536 (httpd) 
total-vm:55112kB, anon-rss:7828kB, file-rss:3628kB
Apr  2 05:27:43 werner kernel: kded invoked oom-killer: 
gfp_mask=0x84d0, order=0, oom_adj=0, oom_score_adj=0
Apr  2 05:27:43 werner kernel: Pid: 6052, comm: kded Not 
tainted 3.4.0-rc1-i486-1sys #1
Apr  2 05:27:43 werner kernel: Call Trace:
Apr  2 05:27:43 werner kernel:  [<c10356cf>] ? 
printk+0x20/0x22
Apr  2 05:27:43 werner kernel:  [<c10af0f7>] 
dump_header+0x6f/0x95
Apr  2 05:27:43 werner kernel:  [<c10af30b>] 
oom_kill_process+0x52/0x251
Apr  2 05:27:43 werner kernel:  [<c10af5cf>] ? 
select_bad_process+0xc5/0x11c
Apr  2 05:27:43 werner kernel:  [<c10af76a>] 
out_of_memory+0x144/0x1b4
Apr  2 05:27:43 werner kernel:  [<c10b2468>] 
__alloc_pages_nodemask+0x501/0x63f
Apr  2 05:27:43 werner kernel:  [<c10b25c2>] 
__get_free_pages+0x1c/0x2d
Apr  2 05:27:43 werner kernel:  [<c102bf07>] 
pgd_alloc+0x1e/0x79
Apr  2 05:27:43 werner kernel:  [<c103379b>] ? 
mm_alloc+0x18/0x3f
Apr  2 05:27:43 werner kernel:  [<c1032605>] 
mm_init+0xad/0xdb
Apr  2 05:27:43 werner kernel:  [<c10337bf>] 
mm_alloc+0x3c/0x3f
Apr  2 05:27:43 werner kernel:  [<c10f0863>] 
bprm_mm_init+0x17/0x6a
Apr  2 05:27:43 werner kernel:  [<c10f09b6>] 
do_execve_common+0x100/0x26d
Apr  2 05:27:43 werner kernel:  [<c10f0b3a>] 
do_execve+0x17/0x1b
Apr  2 05:27:43 werner kernel:  [<c100a16e>] 
sys_execve+0x31/0x54
Apr  2 05:27:43 werner kernel:  [<c2089e42>] 
ptregs_execve+0x12/0x20
Apr  2 05:27:43 werner kernel:  [<c2088cdc>] ? 
syscall_call+0x7/0xb
Apr  2 05:27:43 werner kernel: Mem-Info:
Apr  2 05:27:43 werner kernel: DMA per-cpu:
Apr  2 05:27:43 werner kernel: CPU    0: hi:    0, btch: 
  1 usd:   0
Apr  2 05:27:43 werner kernel: Normal per-cpu:
Apr  2 05:27:43 werner kernel: CPU    0: hi:  186, btch: 
 31 usd:  58
Apr  2 05:27:43 werner kernel: HighMem per-cpu:
Apr  2 05:27:43 werner kernel: CPU    0: hi:  186, btch: 
 31 usd: 164
Apr  2 05:27:43 werner kernel: active_anon:36390 
inactive_anon:29 isolated_anon:0
Apr  2 05:27:43 werner kernel:  active_file:19033 
inactive_file:7133 isolated_file:0
Apr  2 05:27:43 werner kernel:  unevictable:0 dirty:1 
writeback:0 unstable:0
Apr  2 05:27:43 werner kernel:  free:501762 
slab_reclaimable:3249 slab_unreclaimable:49358
Apr  2 05:27:43 werner kernel:  mapped:17408 shmem:674 
pagetables:510 bounce:0
Apr  2 05:27:43 werner kernel: DMA free:4236kB min:784kB 
low:980kB high:1176kB active_anon:0kB inactive_anon:0kB 
active_file:0kB inactive_file:12kB unevictable:0kB 
isolated(anon):0kB isolated(file):0kB present:15804kB 
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB 
slab_reclaimable:0kB slab_unreclaimable:2352kB 
kernel_stack:9248kB pagetables:0kB unstable:0kB bounce:0kB 
writeback_tmp:0kB pages_scanned:126 all_unreclaimable? yes
Apr  2 05:27:43 werner kernel: lowmem_reserve[]: 0 865 
3031 3031
Apr  2 05:27:43 werner kernel: Normal free:43972kB 
min:44012kB low:55012kB high:66016kB active_anon:8064kB 
inactive_anon:0kB active_file:132kB inactive_file:128kB 
unevictable:0kB isolated(anon):0kB isolated(file):0kB 
present:885944kB mlocked:0kB dirty:0kB writeback:0kB 
mapped:0kB shmem:0kB slab_reclaimable:12996kB 
slab_unreclaimable:195080kB kernel_stack:573848kB 
pagetables:32kB unstable:0kB bounce:0kB writeback_tmp:0kB 
pages_scanned:1274 all_unreclaimable? yes
Apr  2 05:27:43 werner kernel: lowmem_reserve[]: 0 0 17326 
17326
Apr  2 05:27:43 werner kernel: HighMem free:1958840kB 
min:512kB low:28056kB high:55600kB active_anon:137496kB 
inactive_anon:116kB active_file:76000kB 
inactive_file:28392kB unevictable:0kB isolated(anon):0kB 
isolated(file):0kB present:2217808kB mlocked:0kB dirty:4kB 
writeback:0kB mapped:69632kB shmem:2696kB 
slab_reclaimable:0kB slab_unreclaimable:0kB 
kernel_stack:0kB pagetables:2008kB unstable:0kB bounce:0kB 
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
Apr  2 05:27:43 werner kernel: lowmem_reserve[]: 0 0 0 0
Apr  2 05:27:43 werner kernel: DMA: 5*4kB 3*8kB 10*16kB 
4*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 
0*4096kB = 4236kB
Apr  2 05:27:43 werner kernel: Normal: 2485*4kB 3230*8kB 
0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 
0*2048kB 2*4096kB = 43972kB
Apr  2 05:27:43 werner kernel: HighMem: 11218*4kB 
11826*8kB 9312*16kB 7035*32kB 4518*64kB 2486*128kB 
929*256kB 294*512kB 105*1024kB 59*2048kB 54*4096kB = 
1958840kB
Apr  2 05:27:43 werner kernel: 26841 total pagecache pages
Apr  2 05:27:43 werner kernel: 0 pages in swap cache
Apr  2 05:27:43 werner kernel: Swap cache stats: add 0, 
delete 0, find 0/0
Apr  2 05:27:43 werner kernel: Free swap  = 0kB
Apr  2 05:27:43 werner kernel: Total swap = 0kB
Apr  2 05:27:43 werner kernel: 786128 pages RAM
Apr  2 05:27:43 werner kernel: 558818 pages HighMem
Apr  2 05:27:43 werner kernel: 13576 pages reserved
Apr  2 05:27:43 werner kernel: 90459 pages shared
Apr  2 05:27:43 werner kernel: 175862 pages non-shared
Apr  2 05:27:44 werner kernel: Out of memory: Kill process 
4537 (httpd) score 3 or sacrifice child
Apr  2 05:27:44 werner kernel: Killed process 4537 (httpd) 
total-vm:55152kB, anon-rss:7848kB, file-rss:3632kB
Apr  2 05:27:44 werner kernel: kded invoked oom-killer: 
gfp_mask=0x84d0, order=0, oom_adj=0, oom_score_adj=0
Apr  2 05:27:44 werner kernel: Pid: 6052, comm: kded Not 
tainted 3.4.0-rc1-i486-1sys #1
Apr  2 05:27:44 werner kernel: Call Trace:
Apr  2 05:27:44 werner kernel:  [<c10356cf>] ? 
printk+0x20/0x22
Apr  2 05:27:44 werner kernel:  [<c10af0f7>] 
dump_header+0x6f/0x95
Apr  2 05:27:44 werner kernel:  [<c10af30b>] 
oom_kill_process+0x52/0x251
Apr  2 05:27:44 werner kernel:  [<c10af5cf>] ? 
select_bad_process+0xc5/0x11c
Apr  2 05:27:44 werner kernel:  [<c10af76a>] 
out_of_memory+0x144/0x1b4
Apr  2 05:27:44 werner kernel:  [<c10b2468>] 
__alloc_pages_nodemask+0x501/0x63f
Apr  2 05:27:44 werner kernel:  [<c10b25c2>] 
__get_free_pages+0x1c/0x2d
Apr  2 05:27:44 werner kernel:  [<c102bf07>] 
pgd_alloc+0x1e/0x79
Apr  2 05:27:44 werner kernel:  [<c103379b>] ? 
mm_alloc+0x18/0x3f
Apr  2 05:27:44 werner kernel:  [<c1032605>] 
mm_init+0xad/0xdb
Apr  2 05:27:44 werner kernel:  [<c10337bf>] 
mm_alloc+0x3c/0x3f
Apr  2 05:27:44 werner kernel:  [<c10f0863>] 
bprm_mm_init+0x17/0x6a
Apr  2 05:27:44 werner kernel:  [<c10f09b6>] 
do_execve_common+0x100/0x26d
Apr  2 05:27:44 werner kernel:  [<c10f0b3a>] 
do_execve+0x17/0x1b
Apr  2 05:27:44 werner kernel:  [<c100a16e>] 
sys_execve+0x31/0x54
Apr  2 05:27:44 werner kernel:  [<c2089e42>] 
ptregs_execve+0x12/0x20
Apr  2 05:27:44 werner kernel:  [<c2088cdc>] ? 
syscall_call+0x7/0xb
Apr  2 05:27:44 werner kernel: Mem-Info:
Apr  2 05:27:44 werner kernel: DMA per-cpu:
Apr  2 05:27:44 werner kernel: CPU    0: hi:    0, btch: 
  1 usd:   0
Apr  2 05:27:44 werner kernel: Normal per-cpu:
Apr  2 05:27:44 werner kernel: CPU    0: hi:  186, btch: 
 31 usd:  61
Apr  2 05:27:44 werner kernel: HighMem per-cpu:
Apr  2 05:27:44 werner kernel: CPU    0: hi:  186, btch: 
 31 usd: 167
Apr  2 05:27:44 werner kernel: active_anon:35558 
inactive_anon:29 isolated_anon:0
Apr  2 05:27:44 werner kernel:  active_file:19033 
inactive_file:7133 isolated_file:0
Apr  2 05:27:44 werner kernel:  unevictable:0 dirty:1 
writeback:0 unstable:0
Apr  2 05:27:44 werner kernel:  free:502599 
slab_reclaimable:3249 slab_unreclaimable:49358
Apr  2 05:27:44 werner kernel:  mapped:17408 shmem:674 
pagetables:491 bounce:0
Apr  2 05:27:44 werner kernel: DMA free:4236kB min:784kB 
low:980kB high:1176kB active_anon:0kB inactive_anon:0kB 
active_file:0kB inactive_file:12kB unevictable:0kB 
isolated(anon):0kB isolated(file):0kB present:15804kB 
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB 
slab_reclaimable:0kB slab_unreclaimable:2352kB 
kernel_stack:9248kB pagetables:0kB unstable:0kB bounce:0kB 
writeback_tmp:0kB pages_scanned:132 all_unreclaimable? yes
Apr  2 05:27:44 werner kernel: lowmem_reserve[]: 0 865 
3031 3031
Apr  2 05:27:44 werner kernel: Normal free:43972kB 
min:44012kB low:55012kB high:66016kB active_anon:8064kB 
inactive_anon:0kB active_file:132kB inactive_file:128kB 
unevictable:0kB isolated(anon):0kB isolated(file):0kB 
present:885944kB mlocked:0kB dirty:0kB writeback:0kB 
mapped:0kB shmem:0kB slab_reclaimable:12996kB 
slab_unreclaimable:195080kB kernel_stack:573848kB 
pagetables:32kB unstable:0kB bounce:0kB writeback_tmp:0kB 
pages_scanned:1337 all_unreclaimable? yes
Apr  2 05:27:44 werner kernel: lowmem_reserve[]: 0 0 17326 
17326
Apr  2 05:27:44 werner kernel: HighMem free:1962188kB 
min:512kB low:28056kB high:55600kB active_anon:134168kB 
inactive_anon:116kB active_file:76000kB 
inactive_file:28392kB unevictable:0kB isolated(anon):0kB 
isolated(file):0kB present:2217808kB mlocked:0kB dirty:4kB 
writeback:0kB mapped:69632kB shmem:2696kB 
slab_reclaimable:0kB slab_unreclaimable:0kB 
kernel_stack:0kB pagetables:1932kB unstable:0kB bounce:0kB 
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
Apr  2 05:27:44 werner kernel: lowmem_reserve[]: 0 0 0 0
Apr  2 05:27:44 werner kernel: DMA: 5*4kB 3*8kB 10*16kB 
4*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 
0*4096kB = 4236kB
Apr  2 05:27:44 werner kernel: Normal: 2485*4kB 3230*8kB 
0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 
0*2048kB 2*4096kB = 43972kB
Apr  2 05:27:44 werner kernel: HighMem: 10929*4kB 
11555*8kB 9165*16kB 6995*32kB 4549*64kB 2505*128kB 
940*256kB 290*512kB 106*1024kB 59*2048kB 55*4096kB = 
1962188kB
Apr  2 05:27:44 werner kernel: 26841 total pagecache pages
Apr  2 05:27:44 werner kernel: 0 pages in swap cache
Apr  2 05:27:44 werner kernel: Swap cache stats: add 0, 
delete 0, find 0/0
Apr  2 05:27:44 werner kernel: Free swap  = 0kB
Apr  2 05:27:44 werner kernel: Total swap = 0kB
Apr  2 05:27:44 werner kernel: 786128 pages RAM
Apr  2 05:27:44 werner kernel: 558818 pages HighMem
Apr  2 05:27:44 werner kernel: 13576 pages reserved
Apr  2 05:27:44 werner kernel: 88420 pages shared
Apr  2 05:27:44 werner kernel: 175019 pages non-shared
Apr  2 05:27:44 werner kernel: Out of memory: Kill process 
4538 (httpd) score 3 or sacrifice child
Apr  2 05:27:44 werner kernel: Killed process 4538 (httpd) 
total-vm:55644kB, anon-rss:8336kB, file-rss:3632kB
Apr  2 05:27:44 werner kernel: kded invoked oom-killer: 
gfp_mask=0x84d0, order=0, oom_adj=0, oom_score_adj=0
Apr  2 05:27:44 werner kernel: Pid: 6052, comm: kded Not 
tainted 3.4.0-rc1-i486-1sys #1
Apr  2 05:27:44 werner kernel: Call Trace:
Apr  2 05:27:44 werner kernel:  [<c10356cf>] ? 
printk+0x20/0x22
Apr  2 05:27:44 werner kernel:  [<c10af0f7>] 
dump_header+0x6f/0x95
Apr  2 05:27:44 werner kernel:  [<c10af30b>] 
oom_kill_process+0x52/0x251
Apr  2 05:27:44 werner kernel:  [<c10af5cf>] ? 
select_bad_process+0xc5/0x11c
Apr  2 05:27:44 werner kernel:  [<c10af76a>] 
out_of_memory+0x144/0x1b4
Apr  2 05:27:44 werner kernel:  [<c10b2468>] 
__alloc_pages_nodemask+0x501/0x63f
Apr  2 05:27:44 werner kernel:  [<c10b25c2>] 
__get_free_pages+0x1c/0x2d
Apr  2 05:27:44 werner kernel:  [<c102bf07>] 
pgd_alloc+0x1e/0x79
Apr  2 05:27:44 werner kernel:  [<c103379b>] ? 
mm_alloc+0x18/0x3f
Apr  2 05:27:44 werner kernel:  [<c1032605>] 
mm_init+0xad/0xdb
Apr  2 05:27:44 werner kernel:  [<c10337bf>] 
mm_alloc+0x3c/0x3f
Apr  2 05:27:44 werner kernel:  [<c10f0863>] 
bprm_mm_init+0x17/0x6a
Apr  2 05:27:44 werner kernel:  [<c10f09b6>] 
do_execve_common+0x100/0x26d
Apr  2 05:27:44 werner kernel:  [<c10f0b3a>] 
do_execve+0x17/0x1b
Apr  2 05:27:44 werner kernel:  [<c100a16e>] 
sys_execve+0x31/0x54
Apr  2 05:27:44 werner kernel:  [<c2089e42>] 
ptregs_execve+0x12/0x20
Apr  2 05:27:44 werner kernel:  [<c2088cdc>] ? 
syscall_call+0x7/0xb
Apr  2 05:27:44 werner kernel: Mem-Info:
Apr  2 05:27:44 werner kernel: DMA per-cpu:
Apr  2 05:27:44 werner kernel: CPU    0: hi:    0, btch: 
  1 usd:   0
Apr  2 05:27:44 werner kernel: Normal per-cpu:
Apr  2 05:27:44 werner kernel: CPU    0: hi:  186, btch: 
 31 usd:  65
Apr  2 05:27:44 werner kernel: HighMem per-cpu:
Apr  2 05:27:44 werner kernel: CPU    0: hi:  186, btch: 
 31 usd: 168
Apr  2 05:27:44 werner kernel: active_anon:34596 
inactive_anon:29 isolated_anon:0
Apr  2 05:27:44 werner kernel:  active_file:19033 
inactive_file:7133 isolated_file:0
Apr  2 05:27:44 werner kernel:  unevictable:0 dirty:1 
writeback:0 unstable:0
Apr  2 05:27:44 werner kernel:  free:503560 
slab_reclaimable:3249 slab_unreclaimable:49358
Apr  2 05:27:44 werner kernel:  mapped:17408 shmem:674 
pagetables:491 bounce:0
Apr  2 05:27:44 werner kernel: DMA free:4236kB min:784kB 
low:980kB high:1176kB active_anon:0kB inactive_anon:0kB 
active_file:0kB inactive_file:12kB unevictable:0kB 
isolated(anon):0kB isolated(file):0kB present:15804kB 
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB 
slab_reclaimable:0kB slab_unreclaimable:2352kB 
kernel_stack:9248kB pagetables:0kB unstable:0kB bounce:0kB 
writeback_tmp:0kB pages_scanned:138 all_unreclaimable? yes
Apr  2 05:27:44 werner kernel: lowmem_reserve[]: 0 865 
3031 3031
Apr  2 05:27:44 werner kernel: Normal free:43972kB 
min:44012kB low:55012kB high:66016kB active_anon:8064kB 
inactive_anon:0kB active_file:132kB inactive_file:128kB 
unevictable:0kB isolated(anon):0kB isolated(file):0kB 
present:885944kB mlocked:0kB dirty:0kB writeback:0kB 
mapped:0kB shmem:0kB slab_reclaimable:12996kB 
slab_unreclaimable:195080kB kernel_stack:573848kB 
pagetables:32kB unstable:0kB bounce:0kB writeback_tmp:0kB 
pages_scanned:1401 all_unreclaimable? yes
Apr  2 05:27:44 werner kernel: lowmem_reserve[]: 0 0 17326 
17326
Apr  2 05:27:44 werner kernel: HighMem free:1966032kB 
min:512kB low:28056kB high:55600kB active_anon:130320kB 
inactive_anon:116kB active_file:76000kB 
inactive_file:28392kB unevictable:0kB isolated(anon):0kB 
isolated(file):0kB present:2217808kB mlocked:0kB dirty:4kB 
writeback:0kB mapped:69632kB shmem:2696kB 
slab_reclaimable:0kB slab_unreclaimable:0kB 
kernel_stack:0kB pagetables:1932kB unstable:0kB bounce:0kB 
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
Apr  2 05:27:44 werner kernel: lowmem_reserve[]: 0 0 0 0
Apr  2 05:27:44 werner kernel: DMA: 5*4kB 3*8kB 10*16kB 
4*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 
0*4096kB = 4236kB
Apr  2 05:27:44 werner kernel: Normal: 2485*4kB 3230*8kB 
0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 
0*2048kB 2*4096kB = 43972kB
Apr  2 05:27:44 werner kernel: HighMem: 10884*4kB 
11506*8kB 9143*16kB 6954*32kB 4558*64kB 2510*128kB 
953*256kB 293*512kB 106*1024kB 59*2048kB 55*4096kB = 
1966032kB
Apr  2 05:27:44 werner kernel: 26841 total pagecache pages
Apr  2 05:27:44 werner kernel: 0 pages in swap cache
Apr  2 05:27:44 werner kernel: Swap cache stats: add 0, 
delete 0, find 0/0
Apr  2 05:27:44 werner kernel: Free swap  = 0kB
Apr  2 05:27:44 werner kernel: Total swap = 0kB
Apr  2 05:27:44 werner kernel: 786128 pages RAM
Apr  2 05:27:44 werner kernel: 558818 pages HighMem
Apr  2 05:27:44 werner kernel: 13576 pages reserved
Apr  2 05:27:44 werner kernel: 86381 pages shared
Apr  2 05:27:44 werner kernel: 174053 pages non-shared
Apr  2 05:27:44 werner kernel: Out of memory: Kill process 
11566 (httpd) score 3 or sacrifice child
Apr  2 05:27:44 werner kernel: Killed process 11566 
(httpd) total-vm:55920kB, anon-rss:8616kB, file-rss:3592kB
Apr  2 05:27:44 werner kernel: kded invoked oom-killer: 
gfp_mask=0x84d0, order=0, oom_adj=0, oom_score_adj=0
Apr  2 05:27:44 werner kernel: Pid: 6052, comm: kded Not 
tainted 3.4.0-rc1-i486-1sys #1
Apr  2 05:27:44 werner kernel: Call Trace:
Apr  2 05:27:44 werner kernel:  [<c10356cf>] ? 
printk+0x20/0x22
Apr  2 05:27:44 werner kernel:  [<c10af0f7>] 
dump_header+0x6f/0x95
Apr  2 05:27:44 werner kernel:  [<c10af30b>] 
oom_kill_process+0x52/0x251
Apr  2 05:27:44 werner kernel:  [<c10af5cf>] ? 
select_bad_process+0xc5/0x11c
Apr  2 05:27:44 werner kernel:  [<c10af76a>] 
out_of_memory+0x144/0x1b4
Apr  2 05:27:44 werner kernel:  [<c10b2468>] 
__alloc_pages_nodemask+0x501/0x63f
Apr  2 05:27:44 werner kernel:  [<c10b25c2>] 
__get_free_pages+0x1c/0x2d
Apr  2 05:27:44 werner kernel:  [<c102bf07>] 
pgd_alloc+0x1e/0x79
Apr  2 05:27:44 werner kernel:  [<c103379b>] ? 
mm_alloc+0x18/0x3f
Apr  2 05:27:44 werner kernel:  [<c1032605>] 
mm_init+0xad/0xdb
Apr  2 05:27:44 werner kernel:  [<c10337bf>] 
mm_alloc+0x3c/0x3f
Apr  2 05:27:44 werner kernel:  [<c10f0863>] 
bprm_mm_init+0x17/0x6a
Apr  2 05:27:44 werner kernel:  [<c10f09b6>] 
do_execve_common+0x100/0x26d
Apr  2 05:27:44 werner kernel:  [<c10f0b3a>] 
do_execve+0x17/0x1b
Apr  2 05:27:44 werner kernel:  [<c100a16e>] 
sys_execve+0x31/0x54
Apr  2 05:27:44 werner kernel:  [<c2089e42>] 
ptregs_execve+0x12/0x20
Apr  2 05:27:44 werner kernel:  [<c2088cdc>] ? 
syscall_call+0x7/0xb
Apr  2 05:27:44 werner kernel: Mem-Info:
Apr  2 05:27:44 werner kernel: DMA per-cpu:
Apr  2 05:27:44 werner kernel: CPU    0: hi:    0, btch: 
  1 usd:   0
Apr  2 05:27:44 werner kernel: Normal per-cpu:
Apr  2 05:27:44 werner kernel: CPU    0: hi:  186, btch: 
 31 usd:  66
Apr  2 05:27:44 werner kernel: HighMem per-cpu:
Apr  2 05:27:44 werner kernel: CPU    0: hi:  186, btch: 
 31 usd: 177
Apr  2 05:27:44 werner kernel: active_anon:33582 
inactive_anon:29 isolated_anon:0
Apr  2 05:27:44 werner kernel:  active_file:19033 
inactive_file:7133 isolated_file:0
Apr  2 05:27:44 werner kernel:  unevictable:0 dirty:1 
writeback:0 unstable:0
Apr  2 05:27:44 werner kernel:  free:504583 
slab_reclaimable:3249 slab_unreclaimable:49358
Apr  2 05:27:44 werner kernel:  mapped:17408 shmem:674 
pagetables:491 bounce:0
Apr  2 05:27:44 werner kernel: DMA free:4236kB min:784kB 
low:980kB high:1176kB active_anon:0kB inactive_anon:0kB 
active_file:0kB inactive_file:12kB unevictable:0kB 
isolated(anon):0kB isolated(file):0kB present:15804kB 
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB 
slab_reclaimable:0kB slab_unreclaimable:2352kB 
kernel_stack:9248kB pagetables:0kB unstable:0kB bounce:0kB 
writeback_tmp:0kB pages_scanned:144 all_unreclaimable? yes
Apr  2 05:27:44 werner kernel: lowmem_reserve[]: 0 865 
3031 3031
Apr  2 05:27:44 werner kernel: Normal free:43972kB 
min:44012kB low:55012kB high:66016kB active_anon:8064kB 
inactive_anon:0kB active_file:132kB inactive_file:128kB 
unevictable:0kB isolated(anon):0kB isolated(file):0kB 
present:885944kB mlocked:0kB dirty:0kB writeback:0kB 
mapped:0kB shmem:0kB slab_reclaimable:12996kB 
slab_unreclaimable:195080kB kernel_stack:573848kB 
pagetables:32kB unstable:0kB bounce:0kB writeback_tmp:0kB 
pages_scanned:1464 all_unreclaimable? yes
Apr  2 05:27:44 werner kernel: lowmem_reserve[]: 0 0 17326 
17326
Apr  2 05:27:44 werner kernel: HighMem free:1970124kB 
min:512kB low:28056kB high:55600kB active_anon:126264kB 
inactive_anon:116kB active_file:76000kB 
inactive_file:28392kB unevictable:0kB isolated(anon):0kB 
isolated(file):0kB present:2217808kB mlocked:0kB dirty:4kB 
writeback:0kB mapped:69632kB shmem:2696kB 
slab_reclaimable:0kB slab_unreclaimable:0kB 
kernel_stack:0kB pagetables:1932kB unstable:0kB bounce:0kB 
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
Apr  2 05:27:44 werner kernel: lowmem_reserve[]: 0 0 0 0
Apr  2 05:27:44 werner kernel: DMA: 5*4kB 3*8kB 10*16kB 
4*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 
0*4096kB = 4236kB
Apr  2 05:27:44 werner kernel: Normal: 2485*4kB 3230*8kB 
0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 
0*2048kB 2*4096kB = 43972kB
Apr  2 05:27:44 werner kernel: HighMem: 10679*4kB 
11262*8kB 8980*16kB 6808*32kB 4527*64kB 2514*128kB 
970*256kB 311*512kB 108*1024kB 59*2048kB 55*4096kB = 
1970124kB
Apr  2 05:27:44 werner kernel: 26841 total pagecache pages
Apr  2 05:27:44 werner kernel: 0 pages in swap cache
Apr  2 05:27:44 werner kernel: Swap cache stats: add 0, 
delete 0, find 0/0
Apr  2 05:27:44 werner kernel: Free swap  = 0kB
Apr  2 05:27:44 werner kernel: Total swap = 0kB
Apr  2 05:27:44 werner kernel: 786128 pages RAM
Apr  2 05:27:44 werner kernel: 558818 pages HighMem
Apr  2 05:27:44 werner kernel: 13576 pages reserved
Apr  2 05:27:44 werner kernel: 84352 pages shared
Apr  2 05:27:44 werner kernel: 173020 pages non-shared
Apr  2 05:27:44 werner kernel: Out of memory: Kill process 
11567 (httpd) score 3 or sacrifice child
Apr  2 05:27:44 werner kernel: Killed process 11567 
(httpd) total-vm:55380kB, anon-rss:8072kB, file-rss:3604kB
Apr  2 05:27:44 werner kernel: route invoked oom-killer: 
gfp_mask=0x800d0, order=0, oom_adj=0, oom_score_adj=0
Apr  2 05:27:44 werner kernel: Pid: 6061, comm: route Not 
tainted 3.4.0-rc1-i486-1sys #1
Apr  2 05:27:44 werner kernel: Call Trace:
Apr  2 05:27:44 werner kernel:  [<c10356cf>] ? 
printk+0x20/0x22
Apr  2 05:27:44 werner kernel:  [<c10af0f7>] 
dump_header+0x6f/0x95
Apr  2 05:27:44 werner kernel:  [<c10af30b>] 
oom_kill_process+0x52/0x251
Apr  2 05:27:44 werner kernel:  [<c10af5cf>] ? 
select_bad_process+0xc5/0x11c
Apr  2 05:27:44 werner kernel:  [<c10af76a>] 
out_of_memory+0x144/0x1b4
Apr  2 05:27:44 werner kernel:  [<c10b2468>] 
__alloc_pages_nodemask+0x501/0x63f
Apr  2 05:27:44 werner kernel:  [<c10b25c2>] 
__get_free_pages+0x1c/0x2d
Apr  2 05:27:44 werner kernel:  [<c1131685>] 
do_proc_readlink+0x27/0x7b
Apr  2 05:27:44 werner kernel:  [<c113306f>] 
proc_pid_readlink+0x48/0x5b
Apr  2 05:27:44 werner kernel:  [<c10ee786>] 
sys_readlinkat+0x81/0x95
Apr  2 05:27:44 werner kernel:  [<c10ee7c6>] 
sys_readlink+0x2c/0x2e
Apr  2 05:27:44 werner kernel:  [<c2088cdc>] 
syscall_call+0x7/0xb
Apr  2 05:27:44 werner kernel: Mem-Info:
Apr  2 05:27:44 werner kernel: DMA per-cpu:
Apr  2 05:27:44 werner kernel: CPU    0: hi:    0, btch: 
  1 usd:   0
Apr  2 05:27:44 werner kernel: Normal per-cpu:
Apr  2 05:27:44 werner kernel: CPU    0: hi:  186, btch: 
 31 usd:  90
Apr  2 05:27:44 werner kernel: HighMem per-cpu:
Apr  2 05:27:44 werner kernel: CPU    0: hi:  186, btch: 
 31 usd: 103
Apr  2 05:27:44 werner kernel: active_anon:32639 
inactive_anon:29 isolated_anon:0
Apr  2 05:27:44 werner kernel:  active_file:19047 
inactive_file:7129 isolated_file:0
Apr  2 05:27:44 werner kernel:  unevictable:0 dirty:1 
writeback:0 unstable:0
Apr  2 05:27:44 werner kernel:  free:505592 
slab_reclaimable:3227 slab_unreclaimable:49336
Apr  2 05:27:44 werner kernel:  mapped:17409 shmem:674 
pagetables:456 bounce:0
Apr  2 05:27:44 werner kernel: DMA free:4240kB min:784kB 
low:980kB high:1176kB active_anon:0kB inactive_anon:0kB 
active_file:8kB inactive_file:0kB unevictable:0kB 
isolated(anon):0kB isolated(file):0kB present:15804kB 
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB 
slab_reclaimable:0kB slab_unreclaimable:2352kB 
kernel_stack:9248kB pagetables:0kB unstable:0kB bounce:0kB 
writeback_tmp:0kB pages_scanned:34 all_unreclaimable? yes
Apr  2 05:27:44 werner kernel: lowmem_reserve[]: 0 865 
3031 3031
Apr  2 05:27:44 werner kernel: Normal free:43964kB 
min:44012kB low:55012kB high:66016kB active_anon:8060kB 
inactive_anon:0kB active_file:140kB inactive_file:128kB 
unevictable:0kB isolated(anon):0kB isolated(file):0kB 
present:885944kB mlocked:0kB dirty:0kB writeback:0kB 
mapped:0kB shmem:0kB slab_reclaimable:12908kB 
slab_unreclaimable:194992kB kernel_stack:573872kB 
pagetables:32kB unstable:0kB bounce:0kB writeback_tmp:0kB 
pages_scanned:571 all_unreclaimable? yes
Apr  2 05:27:44 werner kernel: lowmem_reserve[]: 0 0 17326 
17326
Apr  2 05:27:44 werner kernel: HighMem free:1974164kB 
min:512kB low:28056kB high:55600kB active_anon:122496kB 
inactive_anon:116kB active_file:76040kB 
inactive_file:28388kB unevictable:0kB isolated(anon):0kB 
isolated(file):0kB present:2217808kB mlocked:0kB dirty:4kB 
writeback:0kB mapped:69636kB shmem:2696kB 
slab_reclaimable:0kB slab_unreclaimable:0kB 
kernel_stack:0kB pagetables:1792kB unstable:0kB bounce:0kB 
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
Apr  2 05:27:44 werner kernel: lowmem_reserve[]: 0 0 0 0
Apr  2 05:27:44 werner kernel: DMA: 4*4kB 4*8kB 10*16kB 
4*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 
0*4096kB = 4240kB
Apr  2 05:27:44 werner kernel: Normal: 2455*4kB 3244*8kB 
0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 
0*2048kB 2*4096kB = 43964kB
Apr  2 05:27:44 werner kernel: HighMem: 10667*4kB 
11015*8kB 8823*16kB 6730*32kB 4512*64kB 2540*128kB 
978*256kB 312*512kB 106*1024kB 59*2048kB 57*4096kB = 
1974164kB
Apr  2 05:27:44 werner kernel: 26849 total pagecache pages
Apr  2 05:27:44 werner kernel: 0 pages in swap cache
Apr  2 05:27:44 werner kernel: Swap cache stats: add 0, 
delete 0, find 0/0
Apr  2 05:27:44 werner kernel: Free swap  = 0kB
Apr  2 05:27:44 werner kernel: Total swap = 0kB
Apr  2 05:27:44 werner kernel: 786128 pages RAM
Apr  2 05:27:44 werner kernel: 558818 pages HighMem
Apr  2 05:27:44 werner kernel: 13576 pages reserved
Apr  2 05:27:44 werner kernel: 81346 pages shared
Apr  2 05:27:44 werner kernel: 172671 pages non-shared
Apr  2 05:27:45 werner kernel: Out of memory: Kill process 
11569 (httpd) score 3 or sacrifice child
Apr  2 05:27:45 werner kernel: Killed process 11569 
(httpd) total-vm:55920kB, anon-rss:8636kB, file-rss:3628kB
Apr  2 05:27:49 werner kernel: route invoked oom-killer: 
gfp_mask=0x800d0, order=0, oom_adj=0, oom_score_adj=0
---
Professional hosting for everyone - http://www.host.ru

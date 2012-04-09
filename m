Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823Ab2DIGsQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 02:48:16 -0400
Received: from zfrontend1.aha.ru ([195.2.83.147]:48095 "EHLO aha.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751278Ab2DIGsO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 02:48:14 -0400
From: "werner" <w.landgraf@ru.ru>
Subject: Re: v3.4-rc2 out-of-memory problems (was Re: 3.4-rc1
 sticks-and-crashs)
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, David Rientjes <rientjes@google.com>,
        Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>,
        Oleg Nesterov <oleg@redhat.com>
X-Mailer: CommuniGate Pro WebUser Interface v.4.3.12
Date: Mon, 09 Apr 2012 02:52:04 -0400
Message-ID: <web-722633065@zbackend1.aha.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It crashed again.  I watched a small pdf file with kpdf, 
the same I watch often,  without problems,
when it now crashed.

The desktop sticked, mouse / keyboard not more working, 
CTRL ALT BKSP nor CTRL ALT DEL working,
after 15 min without returning I pressed the reboot 
button.

Below  syslog   and  output of ps axl , I suppose that of 
3:15:10 is most useful.

I hope the error can be found and fixed.

wl




=================================================================================================================

Apr  8 20:57:09 werner kernel: Malformed early option 
'acpi'
Apr  8 20:57:09 werner kernel: ACPI: RSDP 000f6920 00014 
(v00 GBT   )
Apr  8 20:57:09 werner kernel: ACPI: RSDT bfee3000 00038 
(v01 GBT    NVDAACPI 42302E31 NVDA 01010101)
Apr  8 20:57:09 werner kernel: ACPI: FACP bfee3040 00074 
(v01 GBT    NVDAACPI 42302E31 NVDA 01010101)
Apr  8 20:57:09 werner kernel: ACPI: DSDT bfee30c0 0469E 
(v01 GBT    NVDAACPI 00001000 MSFT 03000000)
Apr  8 20:57:09 werner kernel: ACPI: FACS bfee0000 00040
Apr  8 20:57:09 werner kernel: ACPI: SSDT bfee7880 0028A 
(v01 PTLTD  POWERNOW 00000001  LTP 00000001)
Apr  8 20:57:09 werner kernel: ACPI: HPET bfee7b40 00038 
(v01 GBT    NVDAACPI 42302E31 NVDA 00000098)
Apr  8 20:57:09 werner kernel: ACPI: MCFG bfee7b80 0003C 
(v01 GBT    NVDAACPI 42302E31 NVDA 01010101)
Apr  8 20:57:09 werner kernel: ACPI: APIC bfee7780 000D0 
(v01 GBT    NVDAACPI 42302E31 NVDA 01010101)
Apr  8 20:57:09 werner kernel: Zone PFN ranges:
Apr  8 20:57:09 werner kernel:   DMA      0x00000010 -> 
0x00001000
Apr  8 20:57:09 werner kernel:   Normal   0x00001000 -> 
0x000377fe
Apr  8 20:57:09 werner kernel:   HighMem  0x000377fe -> 
0x000bfee0
Apr  8 20:57:09 werner kernel: Movable zone start PFN for 
each node
Apr  8 20:57:09 werner kernel: Early memory PFN ranges
Apr  8 20:57:09 werner kernel:     0: 0x00000010 -> 
0x0000009f
Apr  8 20:57:09 werner kernel:     0: 0x00000100 -> 
0x000bfee0
Apr  8 20:57:09 werner kernel: Built 1 zonelists in Zone 
order, mobility grouping on.  Total pages: 779889
Apr  8 20:57:09 werner kernel: Fast TSC calibration using 
PIT
Apr  8 20:57:09 werner kernel: Detected 2511.280 MHz 
processor.
Apr  8 20:57:09 werner kernel: ACPI: setting ELCR to 0200 
(from 0c20)
Apr  8 20:57:09 werner kernel: AMD PMU driver.
Apr  8 20:57:09 werner kernel: raid6: int32x1    945 MB/s
Apr  8 20:57:09 werner kernel: raid6: int32x2    933 MB/s
Apr  8 20:57:09 werner kernel: raid6: int32x4    933 MB/s
Apr  8 20:57:09 werner kernel: raid6: int32x8    613 MB/s
Apr  8 20:57:09 werner kernel: raid6: mmxx1     2042 MB/s
Apr  8 20:57:09 werner kernel: raid6: mmxx2     3617 MB/s
Apr  8 20:57:09 werner kernel: raid6: sse1x1    2023 MB/s
Apr  8 20:57:09 werner kernel: raid6: sse1x2    3496 MB/s
Apr  8 20:57:09 werner kernel: raid6: sse2x1    3445 MB/s
Apr  8 20:57:09 werner kernel: raid6: sse2x2    4582 MB/s
Apr  8 20:57:09 werner kernel: raid6: using algorithm 
sse2x2 (4582 MB/s)
Apr  8 20:57:10 werner kernel: Expanded resource reserved 
due to conflict with PCI Bus 0000:00
Apr  8 20:57:10 werner kernel: mdacon: MDA with 8K of 
memory detected.
Apr  8 20:57:10 werner kernel: ACPI: PCI Interrupt Link 
[LUBA] enabled at IRQ 10
Apr  8 20:57:10 werner kernel: ACPI: PCI Interrupt Link 
[LUB2] enabled at IRQ 11
Apr  8 20:57:10 werner kernel: microcode: CPU0: family 15 
not supported
Apr  8 20:57:10 werner kernel: The force parameter has not 
been set to 1 so the Iris poweroff handler will not be 
installed.
Apr  8 20:57:10 werner kernel: highmem bounce pool size: 
64 pages
Apr  8 20:57:10 werner kernel: Dquot-cache hash table 
entries: 1024 (order 0, 4096 bytes)
Apr  8 20:57:10 werner kernel: DLM installed
Apr  8 20:57:10 werner kernel: EFS: 1.0a - 
http://aeschi.ch.eu.org/efs/
Apr  8 20:57:10 werner kernel: OCFS2 User DLM kernel 
interface loaded
Apr  8 20:57:10 werner kernel: GFS2 installed
Apr  8 20:57:10 werner kernel: acpiphp_ibm: 
ibm_acpiphp_init: acpi_walk_namespace failed
Apr  8 20:57:10 werner kernel: ACPI: PCI Interrupt Link 
[LIGP] enabled at IRQ 10
Apr  8 20:57:10 werner kernel: nvidiafb: CRTC0 analog 
found
Apr  8 20:57:10 werner kernel: nvidiafb: CRTC1 analog not 
found
Apr  8 20:57:10 werner kernel: i2c i2c-0: unable to read 
EDID block.
Apr  8 20:57:10 werner last message repeated 2 times
Apr  8 20:57:10 werner kernel: nvidiafb: EDID found from 
BUS2
Apr  8 20:57:10 werner kernel: nvidiafb: CRTC 0 appears to 
have a CRT attached
Apr  8 20:57:10 werner kernel: nvidiafb: Using CRT on CRTC 
0
Apr  8 20:57:10 werner kernel: Could not find Carillo 
Ranch MCH device.
Apr  8 20:57:10 werner kernel: no IO addresses supplied
Apr  8 20:57:10 werner kernel: hgafb: probe of hgafb.0 
failed with error -22
Apr  8 20:57:10 werner kernel: uvesafb: failed to execute 
/sbin/v86d
Apr  8 20:57:10 werner kernel: uvesafb: make sure that the 
v86d helper is installed and executable
Apr  8 20:57:10 werner kernel: uvesafb: Getting VBE info 
block failed (eax=0x4f00, err=-2)
Apr  8 20:57:10 werner kernel: uvesafb: vbe_init() failed 
with -22
Apr  8 20:57:10 werner kernel: uvesafb: probe of uvesafb.0 
failed with error -22
Apr  8 20:57:10 werner kernel: vesafb: cannot reserve 
video memory at 0xd0000000
Apr  8 20:57:10 werner kernel: toshiba: not a supported 
Toshiba laptop
Apr  8 20:57:10 werner kernel: [drm:i915_init] *ERROR* 
drm/i915 can't work without intel_agp module!
Apr  8 20:57:10 werner kernel: Compaq SMART2 Driver (v 
2.6.0)
Apr  8 20:57:10 werner kernel: i2c-core: driver [isl29003] 
using legacy suspend method
Apr  8 20:57:10 werner kernel: i2c-core: driver [isl29003] 
using legacy resume method
Apr  8 20:57:10 werner kernel: amd74xx 0000:00:06.0: BIOS 
didn't set cable bits correctly. Enabling workaround.
Apr  8 20:57:10 werner kernel: Loading Adaptec I2O RAID: 
Version 2.4 Build 5go
Apr  8 20:57:10 werner kernel: scsi: <fdomain> Detection 
failed (no card)
Apr  8 20:57:10 werner kernel: NCR53c406a: no available 
ports found
Apr  8 20:57:10 werner kernel: qla2xxx 
[0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driver: 
8.03.07.13-k.
Apr  8 20:57:10 werner kernel: Emulex LightPulse Fibre 
Channel SCSI driver 8.3.30
Apr  8 20:57:10 werner kernel: Copyright(c) 2004-2009 
Emulex.  All rights reserved.
Apr  8 20:57:10 werner kernel: Failed initialization of 
WD-7000 SCSI card!
Apr  8 20:57:10 werner kernel: GDT-HA: Storage RAID 
Controller Driver. Version: 3.05
Apr  8 20:57:10 werner kernel: 3ware Storage Controller 
device driver for Linux v1.26.02.003.
Apr  8 20:57:10 werner kernel: 3ware 9000 Storage 
Controller device driver for Linux v2.26.02.014.
Apr  8 20:57:10 werner kernel: imm: Version 2.05 (for 
Linux 2.4.0)
Apr  8 20:57:10 werner kernel: ACPI: PCI Interrupt Link 
[LSID] enabled at IRQ 11
Apr  8 20:57:10 werner kernel: ACPI: PCI Interrupt Link 
[LFID] enabled at IRQ 10
Apr  8 20:57:10 werner kernel: Error: Driver 
'pata_platform' is already registered, aborting...
Apr  8 20:57:10 werner kernel: physmap-flash.0: failed to 
claim resource 0
Apr  8 20:57:10 werner kernel: Failed to ioremap_nocache
Apr  8 20:57:10 werner last message repeated 2 times
Apr  8 20:57:10 werner kernel: SNAPGEAR: failed to 
ioremap() BOOTCS
Apr  8 20:57:10 werner kernel: Generic platform RAM MTD, 
(c) 2004 Simtec Electronics
Apr  8 20:57:10 werner kernel: [nandsim] warning: 
read_byte: unexpected data output cycle, state is 
STATE_READY return 0x0
Apr  8 20:57:10 werner last message repeated 5 times
Apr  8 20:57:10 werner kernel: flash size: 8 MiB
Apr  8 20:57:10 werner kernel: page size: 512 bytes
Apr  8 20:57:10 werner kernel: OOB area size: 16 bytes
Apr  8 20:57:10 werner kernel: sector size: 8 KiB
Apr  8 20:57:10 werner kernel: pages number: 16384
Apr  8 20:57:10 werner kernel: pages per sector: 16
Apr  8 20:57:10 werner kernel: bus width: 8
Apr  8 20:57:10 werner kernel: bits in sector size: 13
Apr  8 20:57:10 werner kernel: bits in page size: 9
Apr  8 20:57:10 werner kernel: bits in OOB size: 4
Apr  8 20:57:10 werner kernel: flash size with OOB: 8448 
KiB
Apr  8 20:57:10 werner kernel: page address bytes: 3
Apr  8 20:57:10 werner kernel: sector address bytes: 2
Apr  8 20:57:10 werner kernel: options: 0x62
Apr  8 20:57:10 werner kernel: onenand_wait: timeout! 
ctrl=0x0000 intr=0x0000
Apr  8 20:57:10 werner kernel: DE600: port 0x378 busy
Apr  8 20:57:10 werner kernel: paride: aten registered as 
protocol 0
Apr  8 20:57:10 werner kernel: paride: bpck registered as 
protocol 1
Apr  8 20:57:10 werner kernel: paride: comm registered as 
protocol 2
Apr  8 20:57:10 werner kernel: paride: dstr registered as 
protocol 3
Apr  8 20:57:10 werner kernel: paride: k951 registered as 
protocol 4
Apr  8 20:57:10 werner kernel: paride: k971 registered as 
protocol 5
Apr  8 20:57:10 werner kernel: paride: epat registered as 
protocol 6
Apr  8 20:57:10 werner kernel: paride: epia registered as 
protocol 7
Apr  8 20:57:10 werner kernel: paride: frpw registered as 
protocol 8
Apr  8 20:57:10 werner kernel: paride: friq registered as 
protocol 9
Apr  8 20:57:10 werner kernel: paride: fit2 registered as 
protocol 10
Apr  8 20:57:10 werner kernel: paride: fit3 registered as 
protocol 11
Apr  8 20:57:10 werner kernel: paride: on20 registered as 
protocol 12
Apr  8 20:57:10 werner kernel: paride: on26 registered as 
protocol 13
Apr  8 20:57:10 werner kernel: paride: ktti registered as 
protocol 14
Apr  8 20:57:10 werner kernel: paride: bpck6 registered as 
protocol 15
Apr  8 20:57:10 werner kernel: pd: pd version 1.05, major 
45, cluster 64, nice 0
Apr  8 20:57:10 werner kernel: pda: Autoprobe failed
Apr  8 20:57:10 werner kernel: pd: no valid drive found
Apr  8 20:57:10 werner kernel: pcd: pcd version 1.07, 
major 46, nice 0
Apr  8 20:57:10 werner kernel: pcd0: Autoprobe failed
Apr  8 20:57:10 werner kernel: pcd: No CD-ROM drive found
Apr  8 20:57:10 werner kernel: sr0: scsi3-mmc drive: 
48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
Apr  8 20:57:10 werner kernel: pf: pf version 1.04, major 
47, cluster 64, nice 0
Apr  8 20:57:10 werner kernel: pf: No ATAPI disk detected
Apr  8 20:57:10 werner kernel: pt: pt version 1.04, major 
96
Apr  8 20:57:10 werner kernel: pt0: Autoprobe failed
Apr  8 20:57:10 werner kernel: pt: No ATAPI tape drive 
detected
Apr  8 20:57:10 werner kernel: pg: pg version 1.02, major 
97
Apr  8 20:57:10 werner kernel: pga: Autoprobe failed
Apr  8 20:57:10 werner kernel: pg: No ATAPI device 
detected
Apr  8 20:57:10 werner kernel: mk712: device not present
Apr  8 20:57:10 werner kernel: wistron_btns: System 
unknown
Apr  8 20:57:10 werner kernel: EISA: Cannot allocate 
resource for mainboard
Apr  8 20:57:10 werner kernel: Cannot allocate resource 
for EISA slot 1
Apr  8 20:57:10 werner kernel: Cannot allocate resource 
for EISA slot 2
Apr  8 20:57:10 werner kernel: Cannot allocate resource 
for EISA slot 3
Apr  8 20:57:10 werner kernel: Cannot allocate resource 
for EISA slot 4
Apr  8 20:57:10 werner kernel: Cannot allocate resource 
for EISA slot 5
Apr  8 20:57:10 werner kernel: Cannot allocate resource 
for EISA slot 6
Apr  8 20:57:10 werner kernel: Cannot allocate resource 
for EISA slot 7
Apr  8 20:57:10 werner kernel: Cannot allocate resource 
for EISA slot 8
Apr  8 20:57:10 werner kernel: asus_wmi: Management GUID 
not found
Apr  8 20:57:10 werner kernel: asus_wmi: Management GUID 
not found
Apr  8 20:57:10 werner kernel: compal_laptop: Motherboard 
not recognized (You could try the module's 
force-parameter)
Apr  8 20:57:10 werner kernel: dell_wmi: No known WMI GUID 
found
Apr  8 20:57:10 werner kernel: dell_wmi_aio: No known WMI 
GUID found
Apr  8 20:57:10 werner kernel: acer_wmi: No or unsupported 
WMI interface, unable to load
Apr  8 20:57:10 werner kernel: acerhdf: unknown 
(unsupported) BIOS version Gigabyte Technology Co., 
Ltd./M68M-S2P/FC, please report, aborting!
Apr  8 20:57:10 werner kernel: hdaps: supported laptop not 
found!
Apr  8 20:57:10 werner kernel: hdaps: driver init failed 
(ret=-19)!
Apr  8 20:57:10 werner kernel: msi_wmi: This machine 
doesn't have MSI-hotkeys through WMI
Apr  8 20:57:10 werner kernel: intel_oaktrail: Platform 
not recognized (You could try the module's 
force-parameter)
Apr  8 20:57:12 werner kernel: OK
Apr  8 20:57:12 werner udevd-event[9101]: 
udev_rules_apply_format: unknown format variable 
'$modalias | grep -q eagle-usb || exit; while ! 
/sbin/eaglectrl -p 2>/dev/null | /bin/grep -q 
Post-firmware; do sleep 2; done; /sbin/eaglectrl -d''
Apr  8 20:57:12 werner udevd-event[9104]: 
udev_rules_apply_format: unknown format variable 
'$modalias | grep -q eagle-usb || exit; while ! 
/sbin/eaglectrl -p 2>/dev/null | /bin/grep -q 
Post-firmware; do sleep 2; done; /sbin/eaglectrl -d''
Apr  8 20:57:13 werner udevd-event[9102]: 
udev_rules_apply_format: unknown format variable 
'$modalias | grep -q eagle-usb || exit; while ! 
/sbin/eaglectrl -p 2>/dev/null | /bin/grep -q 
Post-firmware; do sleep 2; done; /sbin/eaglectrl -d''
Apr  8 20:57:13 werner udevd-event[9120]: run_program: 
exec of program '/etc/rc.d/rc.media-daemon' failed
Apr  8 20:57:13 werner kernel: OK
Apr  8 20:57:13 werner kernel: register_blkdev: cannot get 
major 3 for hd
Apr  8 20:57:13 werner kernel: drivers/rtc/hctosys.c: 
unable to open rtc device (rtc0)
Apr  8 20:57:13 werner kernel: udevd (5371): 
/proc/5371/oom_adj is deprecated, please use 
/proc/5371/oom_score_adj instead.
Apr  8 20:57:13 werner kernel: end_request: I/O error, dev 
fd0, sector 0
Apr  8 20:57:13 werner kernel: ACPI: PCI Interrupt Link 
[LMAC] enabled at IRQ 11
Apr  8 20:57:13 werner kernel: ACPI: PCI Interrupt Link 
[LAZA] enabled at IRQ 5
Apr  8 20:57:13 werner kernel: ACPI: PCI Interrupt Link 
[LNK2] enabled at IRQ 5
Apr  8 20:57:13 werner kernel: 2:3:1: cannot get freq at 
ep 0x84
Apr  8 20:57:13 werner kernel: k8temp 0000:00:18.3: 
Temperature readouts might be wrong - check erratum #141
Apr  8 20:57:13 werner kernel: EXT3-fs (sda1): warning: 
maximal mount count reached, running e2fsck is recommended
Apr  8 20:57:22 werner apcupsd[9083]: apcupsd FATAL ERROR 
in smartsetup.c at line 171 PANIC! Cannot communicate with 
UPS via serial port. Please make sure the port specified 
on the DEVICE directive is correct, and that your cable 
specification on the UPSCABLE directive is correct.
Apr  8 20:57:22 werner apcupsd[9083]: apcupsd error 
shutdown completed
Apr  8 20:57:32 werner hpijs[9396]: prnt/hpijs/hpijs.cpp 
614: unable to init hpijs server
Apr  8 20:57:36 werner udevd[5371]: add_to_rules: unknown 
key 'MODALIAS' in /etc/udev/rules.d/80-eagle-usb.rules:1
Apr  8 20:58:01 werner kdm_greet[9542]: Can't open default 
user face
Apr  8 20:59:46 werner named[10074]: /etc/named.conf:3: 
option 'multiple-cnames' is obsolete
Apr  9 03:14:47 werner kernel: nepenthes invoked 
oom-killer: gfp_mask=0xd0, order=0, oom_adj=0, 
oom_score_adj=0
Apr  9 03:14:48 werner kernel: Pid: 6451, comm: nepenthes 
Not tainted 3.4.0-rc2-i486-1sys #1
Apr  9 03:14:48 werner kernel: Call Trace:
Apr  9 03:14:48 werner kernel:  [<c10356ff>] ? 
printk+0x20/0x22
Apr  9 03:14:48 werner kernel:  [<c10af32b>] 
dump_header+0x6f/0x95
Apr  9 03:14:48 werner kernel:  [<c10af53f>] 
oom_kill_process+0x52/0x251
Apr  9 03:14:48 werner kernel:  [<c10af803>] ? 
select_bad_process+0xc5/0x11c
Apr  9 03:14:48 werner kernel:  [<c10af99e>] 
out_of_memory+0x144/0x1b4
Apr  9 03:14:48 werner kernel:  [<c10b269c>] 
__alloc_pages_nodemask+0x501/0x63f
Apr  9 03:14:48 werner kernel:  [<c10b27f6>] 
__get_free_pages+0x1c/0x2d
Apr  9 03:14:48 werner kernel:  [<c10f915d>] 
poll_get_entry+0x48/0x75
Apr  9 03:14:48 werner kernel:  [<c10f91a2>] 
__pollwait+0x18/0x4d
Apr  9 03:14:48 werner kernel:  [<c10f918a>] ? 
poll_get_entry+0x75/0x75
Apr  9 03:14:48 werner kernel:  [<c1f276c6>] 
tcp_poll+0x22/0x142
Apr  9 03:14:48 werner kernel:  [<c1ee53c3>] 
sock_poll+0x14/0x17
Apr  9 03:14:48 werner kernel:  [<c10f9411>] 
do_poll+0xd9/0x1cc
Apr  9 03:14:48 werner kernel:  [<c10f9609>] 
do_sys_poll+0x105/0x16b
Apr  9 03:14:48 werner kernel:  [<c10f918a>] ? 
poll_get_entry+0x75/0x75
Apr  9 03:14:48 werner kernel:  [<c10f921d>] ? 
__pollwake+0x46/0x46
Apr  9 03:14:48 werner last message repeated 17 times
Apr  9 03:14:48 werner kernel:  [<c10f9031>] ? 
poll_select_set_timeout+0x59/0x72
Apr  9 03:14:48 werner kernel:  [<c10f96b6>] 
sys_poll+0x47/0x91
Apr  9 03:14:48 werner kernel:  [<c208c05c>] 
syscall_call+0x7/0xb
Apr  9 03:14:48 werner kernel: Mem-Info:
Apr  9 03:14:48 werner kernel: DMA per-cpu:
Apr  9 03:14:48 werner kernel: CPU    0: hi:    0, btch: 
  1 usd:   0
Apr  9 03:14:48 werner kernel: Normal per-cpu:
Apr  9 03:14:48 werner kernel: CPU    0: hi:  186, btch: 
 31 usd:  31
Apr  9 03:14:48 werner kernel: HighMem per-cpu:
Apr  9 03:14:48 werner kernel: CPU    0: hi:  186, btch: 
 31 usd:   0
Apr  9 03:14:48 werner kernel: active_anon:71443 
inactive_anon:45 isolated_anon:0
Apr  9 03:14:48 werner kernel:  active_file:20975 
inactive_file:45023 isolated_file:0
Apr  9 03:14:48 werner kernel:  unevictable:17 dirty:0 
writeback:0 unstable:0
Apr  9 03:14:48 werner kernel:  free:424791 
slab_reclaimable:3245 slab_unreclaimable:39160
Apr  9 03:14:48 werner kernel:  mapped:25537 shmem:707 
pagetables:665 bounce:0
Apr  9 03:14:48 werner kernel: DMA free:4244kB min:784kB 
low:980kB high:1176kB active_anon:0kB inactive_anon:0kB 
active_file:0kB inactive_file:4kB unevictable:0kB 
isolated(anon):0kB isolated(file):0kB present:15804kB 
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB 
slab_reclaimable:24kB slab_unreclaimable:1456kB 
kernel_stack:10120kB pagetables:0kB unstable:0kB 
bounce:0kB writeback_tmp:0kB pages_scanned:6 
all_unreclaimable? yes
Apr  9 03:14:48 werner kernel: lowmem_reserve[]: 0 865 
3031 3031
Apr  9 03:14:48 werner kernel: Normal free:43912kB 
min:44012kB low:55012kB high:66016kB active_anon:0kB 
inactive_anon:0kB active_file:164kB inactive_file:104kB 
unevictable:0kB isolated(anon):0kB isolated(file):0kB 
present:885944kB mlocked:0kB dirty:0kB writeback:0kB 
mapped:12kB shmem:0kB slab_reclaimable:12956kB 
slab_unreclaimable:155184kB kernel_stack:621944kB 
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB 
pages_scanned:404 all_unreclaimable? yes
Apr  9 03:14:48 werner kernel: lowmem_reserve[]: 0 0 17326 
17326
Apr  9 03:14:48 werner kernel: HighMem free:1651008kB 
min:512kB low:28056kB high:55600kB active_anon:285772kB 
inactive_anon:180kB active_file:83736kB 
inactive_file:179984kB unevictable:68kB isolated(anon):0kB 
isolated(file):0kB present:2217808kB mlocked:68kB 
dirty:0kB writeback:0kB mapped:102136kB shmem:2828kB 
slab_reclaimable:0kB slab_unreclaimable:0kB 
kernel_stack:0kB pagetables:2660kB unstable:0kB bounce:0kB 
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
Apr  9 03:14:48 werner kernel: lowmem_reserve[]: 0 0 0 0
Apr  9 03:14:48 werner kernel: DMA: 33*4kB 46*8kB 4*16kB 
7*32kB 8*64kB 7*128kB 6*256kB 1*512kB 0*1024kB 0*2048kB 
0*4096kB = 4244kB
Apr  9 03:14:48 werner kernel: Normal: 2198*4kB 494*8kB 
260*16kB 156*32kB 58*64kB 35*128kB 6*256kB 4*512kB 
0*1024kB 1*2048kB 2*4096kB = 43912kB
Apr  9 03:14:48 werner kernel: HighMem: 50*4kB 341*8kB 
4411*16kB 3099*32kB 1765*64kB 839*128kB 170*256kB 
110*512kB 61*1024kB 53*2048kB 241*4096kB = 1651008kB
Apr  9 03:14:48 werner kernel: 66705 total pagecache pages
Apr  9 03:14:48 werner kernel: 0 pages in swap cache
Apr  9 03:14:48 werner kernel: Swap cache stats: add 0, 
delete 0, find 0/0
Apr  9 03:14:48 werner kernel: Free swap  = 0kB
Apr  9 03:14:48 werner kernel: Total swap = 0kB
Apr  9 03:14:48 werner kernel: 786128 pages RAM
Apr  9 03:14:48 werner kernel: 558818 pages HighMem
Apr  9 03:14:48 werner kernel: 13582 pages reserved
Apr  9 03:14:48 werner kernel: 138097 pages shared
Apr  9 03:14:48 werner kernel: 237762 pages non-shared
Apr  9 03:14:48 werner kernel: Out of memory: Kill process 
10074 (named) score 3 or sacrifice child
Apr  9 03:14:48 werner kernel: Killed process 10074 
(named) total-vm:41364kB, anon-rss:9832kB, file-rss:2452kB
Apr  9 03:14:48 werner kernel: nepenthes invoked 
oom-killer: gfp_mask=0xd0, order=0, oom_adj=0, 
oom_score_adj=0
Apr  9 03:14:48 werner kernel: Pid: 6451, comm: nepenthes 
Not tainted 3.4.0-rc2-i486-1sys #1
Apr  9 03:14:48 werner kernel: Call Trace:
Apr  9 03:14:48 werner kernel:  [<c10356ff>] ? 
printk+0x20/0x22
Apr  9 03:14:48 werner kernel:  [<c10af32b>] 
dump_header+0x6f/0x95
Apr  9 03:14:48 werner kernel:  [<c10af53f>] 
oom_kill_process+0x52/0x251
Apr  9 03:14:48 werner kernel:  [<c10af803>] ? 
select_bad_process+0xc5/0x11c
Apr  9 03:14:48 werner kernel:  [<c10af99e>] 
out_of_memory+0x144/0x1b4
Apr  9 03:14:48 werner kernel:  [<c10b269c>] 
__alloc_pages_nodemask+0x501/0x63f
Apr  9 03:14:48 werner kernel:  [<c10b27f6>] 
__get_free_pages+0x1c/0x2d
Apr  9 03:14:48 werner kernel:  [<c10f915d>] 
poll_get_entry+0x48/0x75
Apr  9 03:14:48 werner kernel:  [<c10f91a2>] 
__pollwait+0x18/0x4d
Apr  9 03:14:48 werner kernel:  [<c10f918a>] ? 
poll_get_entry+0x75/0x75
Apr  9 03:14:48 werner kernel:  [<c1f276c6>] 
tcp_poll+0x22/0x142
Apr  9 03:14:48 werner kernel:  [<c1ee53c3>] 
sock_poll+0x14/0x17
Apr  9 03:14:48 werner kernel:  [<c10f9411>] 
do_poll+0xd9/0x1cc
Apr  9 03:14:48 werner kernel:  [<c10f9609>] 
do_sys_poll+0x105/0x16b
Apr  9 03:14:48 werner kernel:  [<c10f918a>] ? 
poll_get_entry+0x75/0x75
Apr  9 03:14:48 werner kernel:  [<c10f921d>] ? 
__pollwake+0x46/0x46
Apr  9 03:14:48 werner last message repeated 17 times
Apr  9 03:14:48 werner kernel:  [<c10f9031>] ? 
poll_select_set_timeout+0x59/0x72
Apr  9 03:14:48 werner kernel:  [<c10f96b6>] 
sys_poll+0x47/0x91
Apr  9 03:14:48 werner kernel:  [<c208c05c>] 
syscall_call+0x7/0xb
Apr  9 03:14:48 werner kernel: Mem-Info:
Apr  9 03:14:48 werner kernel: DMA per-cpu:
Apr  9 03:14:48 werner kernel: CPU    0: hi:    0, btch: 
  1 usd:   0
Apr  9 03:14:48 werner kernel: Normal per-cpu:
Apr  9 03:14:48 werner kernel: CPU    0: hi:  186, btch: 
 31 usd:  31
Apr  9 03:14:48 werner kernel: HighMem per-cpu:
Apr  9 03:14:48 werner kernel: CPU    0: hi:  186, btch: 
 31 usd:   0
Apr  9 03:14:48 werner kernel: active_anon:68920 
inactive_anon:45 isolated_anon:0
Apr  9 03:14:48 werner kernel:  active_file:21006 
inactive_file:44992 isolated_file:0
Apr  9 03:14:48 werner kernel:  unevictable:17 dirty:0 
writeback:0 unstable:0
Apr  9 03:14:48 werner kernel:  free:427329 
slab_reclaimable:3245 slab_unreclaimable:39160
Apr  9 03:14:48 werner kernel:  mapped:25119 shmem:707 
pagetables:665 bounce:0
Apr  9 03:14:48 werner kernel: DMA free:4244kB min:784kB 
low:980kB high:1176kB active_anon:0kB inactive_anon:0kB 
active_file:0kB inactive_file:4kB unevictable:0kB 
isolated(anon):0kB isolated(file):0kB present:15804kB 
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB 
slab_reclaimable:24kB slab_unreclaimable:1456kB 
kernel_stack:10120kB pagetables:0kB unstable:0kB 
bounce:0kB writeback_tmp:0kB pages_scanned:6 
all_unreclaimable? yes
Apr  9 03:14:48 werner kernel: lowmem_reserve[]: 0 865 
3031 3031
Apr  9 03:14:48 werner kernel: Normal free:43920kB 
min:44012kB low:55012kB high:66016kB active_anon:0kB 
inactive_anon:0kB active_file:132kB inactive_file:136kB 
unevictable:0kB isolated(anon):0kB isolated(file):0kB 
present:885944kB mlocked:0kB dirty:0kB writeback:0kB 
mapped:12kB shmem:0kB slab_reclaimable:12956kB 
slab_unreclaimable:155184kB kernel_stack:621944kB 
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB 
pages_scanned:469 all_unreclaimable? yes
Apr  9 03:14:48 werner kernel: lowmem_reserve[]: 0 0 17326 
17326
Apr  9 03:14:48 werner kernel: HighMem free:1661152kB 
min:512kB low:28056kB high:55600kB active_anon:275680kB 
inactive_anon:180kB active_file:83892kB 
inactive_file:179828kB unevictable:68kB isolated(anon):0kB 
isolated(file):0kB present:2217808kB mlocked:68kB 
dirty:0kB writeback:0kB mapped:100464kB shmem:2828kB 
slab_reclaimable:0kB slab_unreclaimable:0kB 
kernel_stack:0kB pagetables:2660kB unstable:0kB bounce:0kB 
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
Apr  9 03:14:48 werner kernel: lowmem_reserve[]: 0 0 0 0
Apr  9 03:14:48 werner kernel: DMA: 33*4kB 46*8kB 4*16kB 
7*32kB 8*64kB 7*128kB 6*256kB 1*512kB 0*1024kB 0*2048kB 
0*4096kB = 4244kB
Apr  9 03:14:48 werner kernel: Normal: 2230*4kB 479*8kB 
260*16kB 156*32kB 58*64kB 35*128kB 6*256kB 4*512kB 
0*1024kB 1*2048kB 2*4096kB = 43920kB
Apr  9 03:14:48 werner kernel: HighMem: 168*4kB 386*8kB 
4427*16kB 3112*32kB 1778*64kB 848*128kB 174*256kB 
113*512kB 61*1024kB 53*2048kB 242*4096kB = 1661152kB
Apr  9 03:14:48 werner kernel: 66705 total pagecache pages
Apr  9 03:14:48 werner kernel: 0 pages in swap cache
Apr  9 03:14:48 werner kernel: Swap cache stats: add 0, 
delete 0, find 0/0
Apr  9 03:14:48 werner kernel: Free swap  = 0kB
Apr  9 03:14:48 werner kernel: Total swap = 0kB
Apr  9 03:14:48 werner kernel: 786128 pages RAM
Apr  9 03:14:48 werner kernel: 558818 pages HighMem
Apr  9 03:14:48 werner kernel: 13582 pages reserved
Apr  9 03:14:48 werner kernel: 137458 pages shared
Apr  9 03:14:48 werner kernel: 235649 pages non-shared
Apr  9 03:14:48 werner kernel: Out of memory: Kill process 
11099 (httpd) score 3 or sacrifice child
Apr  9 03:14:48 werner kernel: Killed process 11099 
(httpd) total-vm:54328kB, anon-rss:7100kB, file-rss:3180kB
Apr  9 03:14:48 werner kernel: nepenthes invoked 
oom-killer: gfp_mask=0xd0, order=0, oom_adj=0, 
oom_score_adj=0
Apr  9 03:14:48 werner kernel: Pid: 6451, comm: nepenthes 
Not tainted 3.4.0-rc2-i486-1sys #1
Apr  9 03:14:48 werner kernel: Call Trace:
Apr  9 03:14:48 werner kernel:  [<c10356ff>] ? 
printk+0x20/0x22
Apr  9 03:14:48 werner kernel:  [<c10af32b>] 
dump_header+0x6f/0x95
Apr  9 03:14:48 werner kernel:  [<c10af53f>] 
oom_kill_process+0x52/0x251
Apr  9 03:14:48 werner kernel:  [<c10af803>] ? 
select_bad_process+0xc5/0x11c
Apr  9 03:14:48 werner kernel:  [<c10af99e>] 
out_of_memory+0x144/0x1b4
Apr  9 03:14:48 werner kernel:  [<c10b269c>] 
__alloc_pages_nodemask+0x501/0x63f
Apr  9 03:14:48 werner kernel:  [<c10b27f6>] 
__get_free_pages+0x1c/0x2d
Apr  9 03:14:48 werner kernel:  [<c10f915d>] 
poll_get_entry+0x48/0x75
Apr  9 03:14:48 werner kernel:  [<c10f91a2>] 
__pollwait+0x18/0x4d
Apr  9 03:14:48 werner kernel:  [<c10f918a>] ? 
poll_get_entry+0x75/0x75
Apr  9 03:14:48 werner kernel:  [<c1f276c6>] 
tcp_poll+0x22/0x142
Apr  9 03:14:48 werner kernel:  [<c1ee53c3>] 
sock_poll+0x14/0x17
Apr  9 03:14:48 werner kernel:  [<c10f9411>] 
do_poll+0xd9/0x1cc
Apr  9 03:14:48 werner kernel:  [<c10f9609>] 
do_sys_poll+0x105/0x16b
Apr  9 03:14:48 werner kernel:  [<c10f918a>] ? 
poll_get_entry+0x75/0x75
Apr  9 03:14:48 werner kernel:  [<c10f921d>] ? 
__pollwake+0x46/0x46
Apr  9 03:14:48 werner last message repeated 17 times
Apr  9 03:14:48 werner kernel:  [<c10f9031>] ? 
poll_select_set_timeout+0x59/0x72
Apr  9 03:14:48 werner kernel:  [<c10f96b6>] 
sys_poll+0x47/0x91
Apr  9 03:14:48 werner kernel:  [<c208c05c>] 
syscall_call+0x7/0xb
Apr  9 03:14:48 werner kernel: Mem-Info:
Apr  9 03:14:48 werner kernel: DMA per-cpu:
Apr  9 03:14:48 werner kernel: CPU    0: hi:    0, btch: 
  1 usd:   0
Apr  9 03:14:48 werner kernel: Normal per-cpu:
Apr  9 03:14:48 werner kernel: CPU    0: hi:  186, btch: 
 31 usd:  37
Apr  9 03:14:48 werner kernel: HighMem per-cpu:
Apr  9 03:14:48 werner kernel: CPU    0: hi:  186, btch: 
 31 usd: 169
Apr  9 03:14:48 werner kernel: active_anon:68335 
inactive_anon:45 isolated_anon:0
Apr  9 03:14:48 werner kernel:  active_file:21045 
inactive_file:44953 isolated_file:0
Apr  9 03:14:48 werner kernel:  unevictable:17 dirty:0 
writeback:0 unstable:0
Apr  9 03:14:48 werner kernel:  free:427763 
slab_reclaimable:3245 slab_unreclaimable:39160
Apr  9 03:14:48 werner kernel:  mapped:25119 shmem:707 
pagetables:646 bounce:0
Apr  9 03:14:48 werner kernel: DMA free:4244kB min:784kB 
low:980kB high:1176kB active_anon:0kB inactive_anon:0kB 
active_file:0kB inactive_file:4kB unevictable:0kB 
isolated(anon):0kB isolated(file):0kB present:15804kB 
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB 
slab_reclaimable:24kB slab_unreclaimable:1456kB 
kernel_stack:10120kB pagetables:0kB unstable:0kB 
bounce:0kB writeback_tmp:0kB pages_scanned:6 
all_unreclaimable? yes
Apr  9 03:14:48 werner kernel: lowmem_reserve[]: 0 865 
3031 3031
Apr  9 03:14:48 werner kernel: Normal free:43920kB 
min:44012kB low:55012kB high:66016kB active_anon:0kB 
inactive_anon:0kB active_file:132kB inactive_file:136kB 
unevictable:0kB isolated(anon):0kB isolated(file):0kB 
present:885944kB mlocked:0kB dirty:0kB writeback:0kB 
mapped:12kB shmem:0kB slab_reclaimable:12956kB 
slab_unreclaimable:155184kB kernel_stack:621944kB 
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB 
pages_scanned:533 all_unreclaimable? yes
Apr  9 03:14:48 werner kernel: lowmem_reserve[]: 0 0 17326 
17326
Apr  9 03:14:48 werner kernel: HighMem free:1662888kB 
min:512kB low:28056kB high:55600kB active_anon:273340kB 
inactive_anon:180kB active_file:84048kB 
inactive_file:179672kB unevictable:68kB isolated(anon):0kB 
isolated(file):0kB present:2217808kB mlocked:68kB 
dirty:0kB writeback:0kB mapped:100464kB shmem:2828kB 
slab_reclaimable:0kB slab_unreclaimable:0kB 
kernel_stack:0kB pagetables:2584kB unstable:0kB bounce:0kB 
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
Apr  9 03:14:48 werner kernel: lowmem_reserve[]: 0 0 0 0
Apr  9 03:14:48 werner kernel: DMA: 33*4kB 46*8kB 4*16kB 
7*32kB 8*64kB 7*128kB 6*256kB 1*512kB 0*1024kB 0*2048kB 
0*4096kB = 4244kB
Apr  9 03:14:48 werner kernel: Normal: 2230*4kB 479*8kB 
260*16kB 156*32kB 58*64kB 35*128kB 6*256kB 4*512kB 
0*1024kB 1*2048kB 2*4096kB = 43920kB
Apr  9 03:14:48 werner kernel: HighMem: 368*4kB 431*8kB 
4453*16kB 3117*32kB 1778*64kB 848*128kB 174*256kB 
113*512kB 61*1024kB 53*2048kB 242*4096kB = 1662888kB
Apr  9 03:14:48 werner kernel: 66705 total pagecache pages
Apr  9 03:14:48 werner kernel: 0 pages in swap cache
Apr  9 03:14:48 werner kernel: Swap cache stats: add 0, 
delete 0, find 0/0
Apr  9 03:14:48 werner kernel: Free swap  = 0kB
Apr  9 03:14:48 werner kernel: Total swap = 0kB
Apr  9 03:14:48 werner kernel: 786128 pages RAM
Apr  9 03:14:48 werner kernel: 558818 pages HighMem
Apr  9 03:14:48 werner kernel: 13582 pages reserved
Apr  9 03:14:48 werner kernel: 135482 pages shared
Apr  9 03:14:48 werner kernel: 235042 pages non-shared
Apr  9 03:14:48 werner kernel: Out of memory: Kill process 
11100 (httpd) score 3 or sacrifice child
Apr  9 03:14:48 werner kernel: Killed process 11100 
(httpd) total-vm:55208kB, anon-rss:8056kB, file-rss:3568kB
Apr  9 03:14:48 werner kernel: nepenthes invoked 
oom-killer: gfp_mask=0xd0, order=0, oom_adj=0, 
oom_score_adj=0
Apr  9 03:14:48 werner kernel: Pid: 6451, comm: nepenthes 
Not tainted 3.4.0-rc2-i486-1sys #1
Apr  9 03:14:48 werner kernel: Call Trace:
Apr  9 03:14:48 werner kernel:  [<c10356ff>] ? 
printk+0x20/0x22
Apr  9 03:14:48 werner kernel:  [<c10af32b>] 
dump_header+0x6f/0x95
Apr  9 03:14:48 werner kernel:  [<c10af53f>] 
oom_kill_process+0x52/0x251
Apr  9 03:14:48 werner kernel:  [<c10af803>] ? 
select_bad_process+0xc5/0x11c
Apr  9 03:14:48 werner kernel:  [<c10af99e>] 
out_of_memory+0x144/0x1b4
Apr  9 03:14:48 werner kernel:  [<c10b269c>] 
__alloc_pages_nodemask+0x501/0x63f
Apr  9 03:14:48 werner kernel:  [<c10b27f6>] 
__get_free_pages+0x1c/0x2d
Apr  9 03:14:48 werner kernel:  [<c10f915d>] 
poll_get_entry+0x48/0x75
Apr  9 03:14:48 werner kernel:  [<c10f91a2>] 
__pollwait+0x18/0x4d
Apr  9 03:14:48 werner kernel:  [<c10f918a>] ? 
poll_get_entry+0x75/0x75
Apr  9 03:14:48 werner kernel:  [<c1f276c6>] 
tcp_poll+0x22/0x142
Apr  9 03:14:48 werner kernel:  [<c1ee53c3>] 
sock_poll+0x14/0x17
Apr  9 03:14:48 werner kernel:  [<c10f9411>] 
do_poll+0xd9/0x1cc
Apr  9 03:14:48 werner kernel:  [<c10f9609>] 
do_sys_poll+0x105/0x16b
Apr  9 03:14:48 werner kernel:  [<c10f918a>] ? 
poll_get_entry+0x75/0x75
Apr  9 03:14:48 werner kernel:  [<c10f921d>] ? 
__pollwake+0x46/0x46
Apr  9 03:14:48 werner last message repeated 17 times
Apr  9 03:14:48 werner kernel:  [<c10f9031>] ? 
poll_select_set_timeout+0x59/0x72
Apr  9 03:14:48 werner kernel:  [<c10f96b6>] 
sys_poll+0x47/0x91
Apr  9 03:14:48 werner kernel:  [<c208c05c>] 
syscall_call+0x7/0xb
Apr  9 03:14:48 werner kernel: Mem-Info:
Apr  9 03:14:48 werner kernel: DMA per-cpu:
Apr  9 03:14:48 werner kernel: CPU    0: hi:    0, btch: 
  1 usd:   0
Apr  9 03:14:48 werner kernel: Normal per-cpu:
Apr  9 03:14:48 werner kernel: CPU    0: hi:  186, btch: 
 31 usd:  39
Apr  9 03:14:48 werner kernel: HighMem per-cpu:
Apr  9 03:14:48 werner kernel: CPU    0: hi:  186, btch: 
 31 usd: 157
Apr  9 03:14:48 werner kernel: active_anon:67451 
inactive_anon:45 isolated_anon:0
Apr  9 03:14:48 werner kernel:  active_file:21111 
inactive_file:44887 isolated_file:0
Apr  9 03:14:48 werner kernel:  unevictable:17 dirty:0 
writeback:0 unstable:0
Apr  9 03:14:48 werner kernel:  free:428662 
slab_reclaimable:3245 slab_unreclaimable:39160
Apr  9 03:14:48 werner kernel:  mapped:25119 shmem:707 
pagetables:646 bounce:0
Apr  9 03:14:48 werner kernel: DMA free:4244kB min:784kB 
low:980kB high:1176kB active_anon:0kB inactive_anon:0kB 
active_file:0kB inactive_file:4kB unevictable:0kB 
isolated(anon):0kB isolated(file):0kB present:15804kB 
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB 
slab_reclaimable:24kB slab_unreclaimable:1456kB 
kernel_stack:10120kB pagetables:0kB unstable:0kB 
bounce:0kB writeback_tmp:0kB pages_scanned:6 
all_unreclaimable? yes
Apr  9 03:14:48 werner kernel: lowmem_reserve[]: 0 865 
3031 3031
Apr  9 03:14:48 werner kernel: Normal free:43920kB 
min:44012kB low:55012kB high:66016kB active_anon:0kB 
inactive_anon:0kB active_file:136kB inactive_file:132kB 
unevictable:0kB isolated(anon):0kB isolated(file):0kB 
present:885944kB mlocked:0kB dirty:0kB writeback:0kB 
mapped:12kB shmem:0kB slab_reclaimable:12956kB 
slab_unreclaimable:155184kB kernel_stack:621944kB 
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB 
pages_scanned:597 all_unreclaimable? yes
Apr  9 03:14:48 werner kernel: lowmem_reserve[]: 0 0 17326 
17326
Apr  9 03:14:48 werner kernel: HighMem free:1666484kB 
min:512kB low:28056kB high:55600kB active_anon:269804kB 
inactive_anon:180kB active_file:84308kB 
inactive_file:179412kB unevictable:68kB isolated(anon):0kB 
isolated(file):0kB present:2217808kB mlocked:68kB 
dirty:0kB writeback:0kB mapped:100464kB shmem:2828kB 
slab_reclaimable:0kB slab_unreclaimable:0kB 
kernel_stack:0kB pagetables:2584kB unstable:0kB bounce:0kB 
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
Apr  9 03:14:48 werner kernel: lowmem_reserve[]: 0 0 0 0
Apr  9 03:14:48 werner kernel: DMA: 33*4kB 46*8kB 4*16kB 
7*32kB 8*64kB 7*128kB 6*256kB 1*512kB 0*1024kB 0*2048kB 
0*4096kB = 4244kB
Apr  9 03:14:48 werner kernel: Normal: 2230*4kB 479*8kB 
260*16kB 156*32kB 58*64kB 35*128kB 6*256kB 4*512kB 
0*1024kB 1*2048kB 2*4096kB = 43920kB
Apr  9 03:14:48 werner kernel: HighMem: 473*4kB 456*8kB 
4475*16kB 3133*32kB 1789*64kB 851*128kB 176*256kB 
114*512kB 61*1024kB 53*2048kB 242*4096kB = 1666484kB
Apr  9 03:14:48 werner kernel: 66705 total pagecache pages
Apr  9 03:14:48 werner kernel: 0 pages in swap cache
Apr  9 03:14:48 werner kernel: Swap cache stats: add 0, 
delete 0, find 0/0
Apr  9 03:14:48 werner kernel: Free swap  = 0kB
Apr  9 03:14:48 werner kernel: Total swap = 0kB
Apr  9 03:14:48 werner kernel: 786128 pages RAM
Apr  9 03:14:48 werner kernel: 558818 pages HighMem
Apr  9 03:14:48 werner kernel: 13582 pages reserved
Apr  9 03:14:48 werner kernel: 133440 pages shared
Apr  9 03:14:48 werner kernel: 234153 pages non-shared
Apr  9 03:14:48 werner kernel: Out of memory: Kill process 
11101 (httpd) score 3 or sacrifice child
Apr  9 03:14:48 werner kernel: Killed process 11101 
(httpd) total-vm:55208kB, anon-rss:8056kB, file-rss:3612kB
Apr  9 03:14:48 werner kernel: nepenthes invoked 
oom-killer: gfp_mask=0xd0, order=0, oom_adj=0, 
oom_score_adj=0
Apr  9 03:14:48 werner kernel: Pid: 6451, comm: nepenthes 
Not tainted 3.4.0-rc2-i486-1sys #1
Apr  9 03:14:48 werner kernel: Call Trace:
Apr  9 03:14:48 werner kernel:  [<c10356ff>] ? 
printk+0x20/0x22
Apr  9 03:14:48 werner kernel:  [<c10af32b>] 
dump_header+0x6f/0x95
Apr  9 03:14:48 werner kernel:  [<c10af53f>] 
oom_kill_process+0x52/0x251
Apr  9 03:14:48 werner kernel:  [<c10af803>] ? 
select_bad_process+0xc5/0x11c
Apr  9 03:14:48 werner kernel:  [<c10af99e>] 
out_of_memory+0x144/0x1b4
Apr  9 03:14:48 werner kernel:  [<c10b269c>] 
__alloc_pages_nodemask+0x501/0x63f
Apr  9 03:14:48 werner kernel:  [<c10b27f6>] 
__get_free_pages+0x1c/0x2d
Apr  9 03:14:48 werner kernel:  [<c10f915d>] 
poll_get_entry+0x48/0x75
Apr  9 03:14:48 werner kernel:  [<c10f91a2>] 
__pollwait+0x18/0x4d
Apr  9 03:14:48 werner kernel:  [<c10f918a>] ? 
poll_get_entry+0x75/0x75
Apr  9 03:14:48 werner kernel:  [<c1f276c6>] 
tcp_poll+0x22/0x142
Apr  9 03:14:48 werner kernel:  [<c1ee53c3>] 
sock_poll+0x14/0x17
Apr  9 03:14:48 werner kernel:  [<c10f9411>] 
do_poll+0xd9/0x1cc
Apr  9 03:14:48 werner kernel:  [<c10f9609>] 
do_sys_poll+0x105/0x16b
Apr  9 03:14:48 werner kernel:  [<c10f918a>] ? 
poll_get_entry+0x75/0x75
Apr  9 03:14:48 werner kernel:  [<c10f921d>] ? 
__pollwake+0x46/0x46
Apr  9 03:14:48 werner last message repeated 17 times
Apr  9 03:14:48 werner kernel:  [<c10f9031>] ? 
poll_select_set_timeout+0x59/0x72
Apr  9 03:14:48 werner kernel:  [<c10f96b6>] 
sys_poll+0x47/0x91
Apr  9 03:14:48 werner kernel:  [<c208c05c>] 
syscall_call+0x7/0xb
Apr  9 03:14:48 werner kernel: Mem-Info:
Apr  9 03:14:48 werner kernel: DMA per-cpu:
Apr  9 03:14:48 werner kernel: CPU    0: hi:    0, btch: 
  1 usd:   0
Apr  9 03:14:48 werner kernel: Normal per-cpu:
Apr  9 03:14:48 werner kernel: CPU    0: hi:  186, btch: 
 31 usd:  43
Apr  9 03:14:48 werner kernel: HighMem per-cpu:
Apr  9 03:14:48 werner kernel: CPU    0: hi:  186, btch: 
 31 usd: 176
Apr  9 03:14:48 werner kernel: active_anon:66567 
inactive_anon:45 isolated_anon:0
Apr  9 03:14:48 werner kernel:  active_file:21124 
inactive_file:44874 isolated_file:0
Apr  9 03:14:48 werner kernel:  unevictable:17 dirty:0 
writeback:0 unstable:0
Apr  9 03:14:48 werner kernel:  free:429530 
slab_reclaimable:3245 slab_unreclaimable:39151
Apr  9 03:14:48 werner kernel:  mapped:25119 shmem:707 
pagetables:627 bounce:0
Apr  9 03:14:48 werner kernel: DMA free:4244kB min:784kB 
low:980kB high:1176kB active_anon:0kB inactive_anon:0kB 
active_file:0kB inactive_file:4kB unevictable:0kB 
isolated(anon):0kB isolated(file):0kB present:15804kB 
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB 
slab_reclaimable:24kB slab_unreclaimable:1456kB 
kernel_stack:10120kB pagetables:0kB unstable:0kB 
bounce:0kB writeback_tmp:0kB pages_scanned:6 
all_unreclaimable? yes
Apr  9 03:14:48 werner kernel: lowmem_reserve[]: 0 865 
3031 3031
Apr  9 03:14:48 werner kernel: Normal free:43920kB 
min:44012kB low:55012kB high:66016kB active_anon:0kB 
inactive_anon:0kB active_file:136kB inactive_file:132kB 
unevictable:0kB isolated(anon):0kB isolated(file):0kB 
present:885944kB mlocked:0kB dirty:0kB writeback:0kB 
mapped:12kB shmem:0kB slab_reclaimable:12956kB 
slab_unreclaimable:155148kB kernel_stack:621944kB 
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB 
pages_scanned:661 all_unreclaimable? yes
Apr  9 03:14:48 werner kernel: lowmem_reserve[]: 0 0 17326 
17326
Apr  9 03:14:48 werner kernel: HighMem free:1669956kB 
min:512kB low:28056kB high:55600kB active_anon:266268kB 
inactive_anon:180kB active_file:84360kB 
inactive_file:179360kB unevictable:68kB isolated(anon):0kB 
isolated(file):0kB present:2217808kB mlocked:68kB 
dirty:0kB writeback:0kB mapped:100464kB shmem:2828kB 
slab_reclaimable:0kB slab_unreclaimable:0kB 
kernel_stack:0kB pagetables:2508kB unstable:0kB bounce:0kB 
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
Apr  9 03:14:48 werner kernel: lowmem_reserve[]: 0 0 0 0
Apr  9 03:14:48 werner kernel: DMA: 33*4kB 46*8kB 4*16kB 
7*32kB 8*64kB 7*128kB 6*256kB 1*512kB 0*1024kB 0*2048kB 
0*4096kB = 4244kB
Apr  9 03:14:48 werner kernel: Normal: 2230*4kB 479*8kB 
260*16kB 156*32kB 58*64kB 35*128kB 6*256kB 4*512kB 
0*1024kB 1*2048kB 2*4096kB = 43920kB
Apr  9 03:14:48 werner kernel: HighMem: 599*4kB 535*8kB 
4517*16kB 3151*32kB 1800*64kB 854*128kB 176*256kB 
114*512kB 61*1024kB 53*2048kB 242*4096kB = 1669956kB
Apr  9 03:14:48 werner kernel: 66705 total pagecache pages
Apr  9 03:14:48 werner kernel: 0 pages in swap cache
Apr  9 03:14:48 werner kernel: Swap cache stats: add 0, 
delete 0, find 0/0
Apr  9 03:14:48 werner kernel: Free swap  = 0kB
Apr  9 03:14:48 werner kernel: Total swap = 0kB
Apr  9 03:14:48 werner kernel: 786128 pages RAM
Apr  9 03:14:48 werner kernel: 558818 pages HighMem
Apr  9 03:14:48 werner kernel: 13582 pages reserved
Apr  9 03:14:48 werner kernel: 131398 pages shared
Apr  9 03:14:48 werner kernel: 233262 pages non-shared
Apr  9 03:14:48 werner kernel: Out of memory: Kill process 
11102 (httpd) score 3 or sacrifice child
Apr  9 03:14:48 werner kernel: Killed process 11102 
(httpd) total-vm:54952kB, anon-rss:7796kB, file-rss:3760kB
Apr  9 03:14:48 werner kernel: nepenthes invoked 
oom-killer: gfp_mask=0xd0, order=0, oom_adj=0, 
oom_score_adj=0
Apr  9 03:14:48 werner kernel: Pid: 6451, comm: nepenthes 
Not tainted 3.4.0-rc2-i486-1sys #1
Apr  9 03:14:48 werner kernel: Call Trace:
Apr  9 03:14:48 werner kernel:  [<c10356ff>] ? 
printk+0x20/0x22
Apr  9 03:14:48 werner kernel:  [<c10af32b>] 
dump_header+0x6f/0x95
Apr  9 03:14:48 werner kernel:  [<c10af53f>] 
oom_kill_process+0x52/0x251
Apr  9 03:14:48 werner kernel:  [<c10af803>] ? 
select_bad_process+0xc5/0x11c
Apr  9 03:14:48 werner kernel:  [<c10af99e>] 
out_of_memory+0x144/0x1b4
Apr  9 03:14:48 werner kernel:  [<c10b269c>] 
__alloc_pages_nodemask+0x501/0x63f
Apr  9 03:14:48 werner kernel:  [<c10b27f6>] 
__get_free_pages+0x1c/0x2d
Apr  9 03:14:48 werner kernel:  [<c10f915d>] 
poll_get_entry+0x48/0x75
Apr  9 03:14:48 werner kernel:  [<c10f91a2>] 
__pollwait+0x18/0x4d
Apr  9 03:14:48 werner kernel:  [<c10f918a>] ? 
poll_get_entry+0x75/0x75
Apr  9 03:14:48 werner kernel:  [<c1f276c6>] 
tcp_poll+0x22/0x142
Apr  9 03:14:48 werner kernel:  [<c1ee53c3>] 
sock_poll+0x14/0x17
Apr  9 03:14:48 werner kernel:  [<c10f9411>] 
do_poll+0xd9/0x1cc
Apr  9 03:14:48 werner kernel:  [<c10f9609>] 
do_sys_poll+0x105/0x16b
Apr  9 03:14:48 werner kernel:  [<c10f918a>] ? 
poll_get_entry+0x75/0x75
Apr  9 03:14:48 werner kernel:  [<c10f921d>] ? 
__pollwake+0x46/0x46
Apr  9 03:14:48 werner last message repeated 17 times
Apr  9 03:14:48 werner kernel:  [<c10f9031>] ? 
poll_select_set_timeout+0x59/0x72
Apr  9 03:14:48 werner kernel:  [<c10f96b6>] 
sys_poll+0x47/0x91
Apr  9 03:14:48 werner kernel:  [<c208c05c>] 
syscall_call+0x7/0xb
Apr  9 03:14:48 werner kernel: Mem-Info:
Apr  9 03:14:48 werner kernel: DMA per-cpu:
Apr  9 03:14:48 werner kernel: CPU    0: hi:    0, btch: 
  1 usd:   0
Apr  9 03:14:48 werner kernel: Normal per-cpu:
Apr  9 03:14:48 werner kernel: CPU    0: hi:  186, btch: 
 31 usd:  45
Apr  9 03:14:48 werner kernel: HighMem per-cpu:
Apr  9 03:14:48 werner kernel: CPU    0: hi:  186, btch: 
 31 usd: 162
Apr  9 03:14:48 werner kernel: active_anon:65761 
inactive_anon:45 isolated_anon:0
Apr  9 03:14:48 werner kernel:  active_file:21138 
inactive_file:44860 isolated_file:0
Apr  9 03:14:48 werner kernel:  unevictable:17 dirty:0 
writeback:0 unstable:0
Apr  9 03:14:48 werner kernel:  free:430367 
slab_reclaimable:3245 slab_unreclaimable:39151
Apr  9 03:14:48 werner kernel:  mapped:25119 shmem:707 
pagetables:627 bounce:0
Apr  9 03:14:48 werner kernel: DMA free:4244kB min:784kB 
low:980kB high:1176kB active_anon:0kB inactive_anon:0kB 
active_file:0kB inactive_file:4kB unevictable:0kB 
isolated(anon):0kB isolated(file):0kB present:15804kB 
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB 
slab_reclaimable:24kB slab_unreclaimable:1456kB 
kernel_stack:10120kB pagetables:0kB unstable:0kB 
bounce:0kB writeback_tmp:0kB pages_scanned:6 
all_unreclaimable? yes
Apr  9 03:14:48 werner kernel: lowmem_reserve[]: 0 865 
3031 3031
Apr  9 03:14:48 werner kernel: Normal free:43920kB 
min:44012kB low:55012kB high:66016kB active_anon:0kB 
inactive_anon:0kB active_file:140kB inactive_file:128kB 
unevictable:0kB isolated(anon):0kB isolated(file):0kB 
present:885944kB mlocked:0kB dirty:0kB writeback:0kB 
mapped:12kB shmem:0kB slab_reclaimable:12956kB 
slab_unreclaimable:155148kB kernel_stack:621944kB 
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB 
pages_scanned:725 all_unreclaimable? yes
Apr  9 03:14:48 werner kernel: lowmem_reserve[]: 0 0 17326 
17326
Apr  9 03:14:48 werner kernel: HighMem free:1673304kB 
min:512kB low:28056kB high:55600kB active_anon:263044kB 
inactive_anon:180kB active_file:84412kB 
inactive_file:179308kB unevictable:68kB isolated(anon):0kB 
isolated(file):0kB present:2217808kB mlocked:68kB 
dirty:0kB writeback:0kB mapped:100464kB shmem:2828kB 
slab_reclaimable:0kB slab_unreclaimable:0kB 
kernel_stack:0kB pagetables:2508kB unstable:0kB bounce:0kB 
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
Apr  9 03:14:48 werner kernel: lowmem_reserve[]: 0 0 0 0
Apr  9 03:14:48 werner kernel: DMA: 33*4kB 46*8kB 4*16kB 
7*32kB 8*64kB 7*128kB 6*256kB 1*512kB 0*1024kB 0*2048kB 
0*4096kB = 4244kB
Apr  9 03:14:48 werner kernel: Normal: 2230*4kB 479*8kB 
260*16kB 156*32kB 58*64kB 35*128kB 6*256kB 4*512kB 
0*1024kB 1*2048kB 2*4096kB = 43920kB
Apr  9 03:14:48 werner kernel: HighMem: 646*4kB 564*8kB 
4534*16kB 3164*32kB 1807*64kB 864*128kB 178*256kB 
114*512kB 61*1024kB 53*2048kB 242*4096kB = 1673304kB
Apr  9 03:14:48 werner kernel: 66705 total pagecache pages
Apr  9 03:14:48 werner kernel: 0 pages in swap cache
Apr  9 03:14:48 werner kernel: Swap cache stats: add 0, 
delete 0, find 0/0
Apr  9 03:14:48 werner kernel: Free swap  = 0kB
Apr  9 03:14:48 werner kernel: Total swap = 0kB
Apr  9 03:14:48 werner kernel: 786128 pages RAM
Apr  9 03:14:48 werner kernel: 558818 pages HighMem
Apr  9 03:14:48 werner kernel: 13582 pages reserved
Apr  9 03:14:48 werner kernel: 129322 pages shared
Apr  9 03:14:48 werner kernel: 232414 pages non-shared
Apr  9 03:14:48 werner kernel: Out of memory: Kill process 
11103 (httpd) score 3 or sacrifice child
Apr  9 03:14:48 werner kernel: Killed process 11103 
(httpd) total-vm:54960kB, anon-rss:7804kB, file-rss:3768kB
Apr  9 03:14:48 werner kernel: nepenthes invoked 
oom-killer: gfp_mask=0xd0, order=0, oom_adj=0, 
oom_score_adj=0
Apr  9 03:14:48 werner kernel: Pid: 6451, comm: nepenthes 
Not tainted 3.4.0-rc2-i486-1sys #1
Apr  9 03:14:48 werner kernel: Call Trace:
Apr  9 03:14:48 werner kernel:  [<c10356ff>] ? 
printk+0x20/0x22
Apr  9 03:14:48 werner kernel:  [<c10af32b>] 
dump_header+0x6f/0x95
Apr  9 03:14:48 werner kernel:  [<c10af53f>] 
oom_kill_process+0x52/0x251
Apr  9 03:14:48 werner kernel:  [<c10af803>] ? 
select_bad_process+0xc5/0x11c
Apr  9 03:14:48 werner kernel:  [<c10af99e>] 
out_of_memory+0x144/0x1b4
Apr  9 03:14:48 werner kernel:  [<c10b269c>] 
__alloc_pages_nodemask+0x501/0x63f
Apr  9 03:14:48 werner kernel:  [<c10b27f6>] 
__get_free_pages+0x1c/0x2d
Apr  9 03:14:48 werner kernel:  [<c10f915d>] 
poll_get_entry+0x48/0x75
Apr  9 03:14:48 werner kernel:  [<c10f91a2>] 
__pollwait+0x18/0x4d
Apr  9 03:14:48 werner kernel:  [<c10f918a>] ? 
poll_get_entry+0x75/0x75
Apr  9 03:14:48 werner kernel:  [<c1f276c6>] 
tcp_poll+0x22/0x142
Apr  9 03:14:48 werner kernel:  [<c1ee53c3>] 
sock_poll+0x14/0x17
Apr  9 03:14:48 werner kernel:  [<c10f9411>] 
do_poll+0xd9/0x1cc
Apr  9 03:14:48 werner kernel:  [<c10f9609>] 
do_sys_poll+0x105/0x16b
Apr  9 03:14:48 werner kernel:  [<c10f918a>] ? 
poll_get_entry+0x75/0x75
Apr  9 03:14:48 werner kernel:  [<c10f921d>] ? 
__pollwake+0x46/0x46
Apr  9 03:14:48 werner last message repeated 17 times
Apr  9 03:14:48 werner kernel:  [<c10f9031>] ? 
poll_select_set_timeout+0x59/0x72
Apr  9 03:14:48 werner kernel:  [<c10f96b6>] 
sys_poll+0x47/0x91
Apr  9 03:14:48 werner kernel:  [<c208c05c>] 
syscall_call+0x7/0xb
Apr  9 03:14:48 werner kernel: Mem-Info:
Apr  9 03:14:48 werner kernel: DMA per-cpu:
Apr  9 03:14:48 werner kernel: CPU    0: hi:    0, btch: 
  1 usd:   0
Apr  9 03:14:48 werner kernel: Normal per-cpu:
Apr  9 03:14:48 werner kernel: CPU    0: hi:  186, btch: 
 31 usd:  71
Apr  9 03:14:48 werner kernel: HighMem per-cpu:
Apr  9 03:14:48 werner kernel: CPU    0: hi:  186, btch: 
 31 usd: 179
Apr  9 03:14:48 werner kernel: active_anon:64942 
inactive_anon:45 isolated_anon:0
Apr  9 03:14:48 werner kernel:  active_file:21151 
inactive_file:44847 isolated_file:0
Apr  9 03:14:48 werner kernel:  unevictable:17 dirty:0 
writeback:0 unstable:0
Apr  9 03:14:48 werner kernel:  free:431173 
slab_reclaimable:3245 slab_unreclaimable:39133
Apr  9 03:14:48 werner kernel:  mapped:25119 shmem:707 
pagetables:608 bounce:0
Apr  9 03:14:48 werner kernel: DMA free:4244kB min:784kB 
low:980kB high:1176kB active_anon:0kB inactive_anon:0kB 
active_file:0kB inactive_file:4kB unevictable:0kB 
isolated(anon):0kB isolated(file):0kB present:15804kB 
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB 
slab_reclaimable:24kB slab_unreclaimable:1456kB 
kernel_stack:10120kB pagetables:0kB unstable:0kB 
bounce:0kB writeback_tmp:0kB pages_scanned:6 
all_unreclaimable? yes
Apr  9 03:14:48 werner kernel: lowmem_reserve[]: 0 865 
3031 3031
Apr  9 03:14:48 werner kernel: Normal free:43920kB 
min:44012kB low:55012kB high:66016kB active_anon:0kB 
inactive_anon:0kB active_file:140kB inactive_file:128kB 
unevictable:0kB isolated(anon):0kB isolated(file):0kB 
present:885944kB mlocked:0kB dirty:0kB writeback:0kB 
mapped:12kB shmem:0kB slab_reclaimable:12956kB 
slab_unreclaimable:155076kB kernel_stack:621944kB 
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB 
pages_scanned:789 all_unreclaimable? yes
Apr  9 03:14:48 werner kernel: lowmem_reserve[]: 0 0 17326 
17326
Apr  9 03:14:48 werner kernel: HighMem free:1676528kB 
min:512kB low:28056kB high:55600kB active_anon:259768kB 
inactive_anon:180kB active_file:84464kB 
inactive_file:179256kB unevictable:68kB isolated(anon):0kB 
isolated(file):0kB present:2217808kB mlocked:68kB 
dirty:0kB writeback:0kB mapped:100464kB shmem:2828kB 
slab_reclaimable:0kB slab_unreclaimable:0kB 
kernel_stack:0kB pagetables:2432kB unstable:0kB bounce:0kB 
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
Apr  9 03:14:48 werner kernel: lowmem_reserve[]: 0 0 0 0
Apr  9 03:14:48 werner kernel: DMA: 33*4kB 46*8kB 4*16kB 
7*32kB 8*64kB 7*128kB 6*256kB 1*512kB 0*1024kB 0*2048kB 
0*4096kB = 4244kB
Apr  9 03:14:48 werner kernel: Normal: 2230*4kB 479*8kB 
260*16kB 156*32kB 58*64kB 35*128kB 6*256kB 4*512kB 
0*1024kB 1*2048kB 2*4096kB = 43920kB
Apr  9 03:14:48 werner kernel: HighMem: 724*4kB 584*8kB 
4550*16kB 3176*32kB 1814*64kB 869*128kB 182*256kB 
114*512kB 61*1024kB 53*2048kB 242*4096kB = 1676528kB
Apr  9 03:14:48 werner kernel: 66705 total pagecache pages
Apr  9 03:14:48 werner kernel: 0 pages in swap cache
Apr  9 03:14:48 werner kernel: Swap cache stats: add 0, 
delete 0, find 0/0
Apr  9 03:14:48 werner kernel: Free swap  = 0kB
Apr  9 03:14:48 werner kernel: Total swap = 0kB
Apr  9 03:14:48 werner kernel: 786128 pages RAM
Apr  9 03:14:48 werner kernel: 558818 pages HighMem
Apr  9 03:14:48 werner kernel: 13582 pages reserved
Apr  9 03:14:48 werner kernel: 127243 pages shared
Apr  9 03:14:48 werner kernel: 231588 pages non-shared
Apr  9 03:14:48 werner kernel: Out of memory: Kill process 
13733 (httpd) score 3 or sacrifice child
Apr  9 03:14:48 werner kernel: Killed process 13733 
(httpd) total-vm:55224kB, anon-rss:8064kB, file-rss:3600kB
Apr  9 03:14:55 werner kernel: X invoked oom-killer: 
gfp_mask=0xd0, order=0, oom_adj=0, oom_score_adj=0
Apr  9 03:14:55 werner kernel: Pid: 9537, comm: X Not 
tainted 3.4.0-rc2-i486-1sys #1
Apr  9 03:14:55 werner kernel: Call Trace:
Apr  9 03:14:55 werner kernel:  [<c10356ff>] ? 
printk+0x20/0x22
Apr  9 03:14:55 werner kernel:  [<c10af32b>] 
dump_header+0x6f/0x95
Apr  9 03:14:55 werner kernel:  [<c10af53f>] 
oom_kill_process+0x52/0x251
Apr  9 03:14:55 werner kernel:  [<c10af803>] ? 
select_bad_process+0xc5/0x11c
Apr  9 03:14:55 werner kernel:  [<c10af99e>] 
out_of_memory+0x144/0x1b4
Apr  9 03:14:55 werner kernel:  [<c10b269c>] 
__alloc_pages_nodemask+0x501/0x63f
Apr  9 03:14:55 werner kernel:  [<c1053a8c>] ? 
__wake_up_common+0xe/0x62
Apr  9 03:14:55 werner kernel:  [<c10b27f6>] 
__get_free_pages+0x1c/0x2d
Apr  9 03:14:55 werner kernel:  [<c10f915d>] 
poll_get_entry+0x48/0x75
Apr  9 03:14:55 werner kernel:  [<c10f91a2>] 
__pollwait+0x18/0x4d
Apr  9 03:14:55 werner kernel:  [<c10f918a>] ? 
poll_get_entry+0x75/0x75
Apr  9 03:14:55 werner kernel:  [<c1f6c74d>] 
unix_poll+0x1e/0x9f
Apr  9 03:14:55 werner kernel:  [<c1ee53c3>] 
sock_poll+0x14/0x17
Apr  9 03:14:55 werner kernel:  [<c10f9971>] 
do_select+0x229/0x44b
Apr  9 03:14:55 werner kernel:  [<c10f918a>] ? 
poll_get_entry+0x75/0x75
Apr  9 03:14:55 werner kernel:  [<c10f921d>] ? 
__pollwake+0x46/0x46
Apr  9 03:14:55 werner last message repeated 17 times
Apr  9 03:14:55 werner kernel:  [<c10f9d21>] 
core_sys_select+0x18e/0x255
Apr  9 03:14:55 werner kernel:  [<c1050b4f>] ? 
hrtimer_try_to_cancel+0x84/0x8d
Apr  9 03:14:55 werner kernel:  [<c1038bb2>] ? 
set_normalized_timespec+0x9/0x43
Apr  9 03:14:55 werner kernel:  [<c1038bb2>] ? 
set_normalized_timespec+0x9/0x43
Apr  9 03:14:55 werner kernel:  [<c1038e18>] ? 
timespec_add_safe+0x2f/0x4f
Apr  9 03:14:55 werner kernel:  [<c10f9f8e>] 
sys_select+0x79/0x96
Apr  9 03:14:55 werner kernel:  [<c208c05c>] 
syscall_call+0x7/0xb
Apr  9 03:14:55 werner kernel: Mem-Info:
Apr  9 03:14:55 werner kernel: DMA per-cpu:
Apr  9 03:14:55 werner kernel: CPU    0: hi:    0, btch: 
  1 usd:   0
Apr  9 03:14:55 werner kernel: Normal per-cpu:
Apr  9 03:14:55 werner kernel: CPU    0: hi:  186, btch: 
 31 usd:  31
Apr  9 03:14:55 werner kernel: HighMem per-cpu:
Apr  9 03:14:55 werner kernel: CPU    0: hi:  186, btch: 
 31 usd:   0
Apr  9 03:14:55 werner kernel: active_anon:64089 
inactive_anon:45 isolated_anon:0
Apr  9 03:14:55 werner kernel:  active_file:21192 
inactive_file:44829 isolated_file:0
Apr  9 03:14:55 werner kernel:  unevictable:17 dirty:0 
writeback:0 unstable:0
Apr  9 03:14:55 werner kernel:  free:432193 
slab_reclaimable:3241 slab_unreclaimable:39096
Apr  9 03:14:55 werner kernel:  mapped:25112 shmem:707 
pagetables:610 bounce:0
Apr  9 03:14:55 werner kernel: DMA free:4244kB min:784kB 
low:980kB high:1176kB active_anon:0kB inactive_anon:0kB 
active_file:0kB inactive_file:0kB unevictable:0kB 
isolated(anon):0kB isolated(file):0kB present:15804kB 
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB 
slab_reclaimable:24kB slab_unreclaimable:1456kB 
kernel_stack:10120kB pagetables:0kB unstable:0kB 
bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? yes
Apr  9 03:14:55 werner kernel: lowmem_reserve[]: 0 865 
3031 3031
Apr  9 03:14:55 werner kernel: Normal free:43976kB 
min:44012kB low:55012kB high:66016kB active_anon:0kB 
inactive_anon:0kB active_file:164kB inactive_file:104kB 
unevictable:0kB isolated(anon):0kB isolated(file):0kB 
present:885944kB mlocked:0kB dirty:0kB writeback:0kB 
mapped:12kB shmem:0kB slab_reclaimable:12940kB 
slab_unreclaimable:154928kB kernel_stack:622168kB 
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB 
pages_scanned:409 all_unreclaimable? yes


=================================================================================================================




  ****
Mon Apr  9 03:13:39 GFT 2012
  ****
F   UID   PID  PPID PRI  NI    VSZ   RSS WCHAN  STAT TTY 
       TIME COMMAND
4     0     1     0  20   0    824   324 poll_s Ss   ? 
         0:37 init [4]
1     0     2     0  20   0      0     0 kthrea S    ? 
         0:01 [kthreadd]
1     0     3     2  20   0      0     0 run_ks S    ? 
         0:26 [ksoftirqd/0]
1     0     6     2 -100  -      0     0 cpu_st S    ? 
         0:00 [migration/0]
1     0     7     2 -100  -      0     0 watchd S    ? 
         0:00 [watchdog/0]
1     0     8     2   0 -20      0     0 rescue S<   ? 
         0:00 [khelper]
5     0     9     2  20   0      0     0 devtmp S    ? 
         0:00 [kdevtmpfs]
1     0    10     2   0 -20      0     0 rescue S<   ? 
         0:00 [netns]
1     0  1023     2  20   0      0     0 bdi_sy S    ? 
         0:00 [sync_supers]
1     0  1025     2  20   0      0     0 bdi_fo S    ? 
         0:00 [bdi-default]
1     0  1026     2   0 -20      0     0 rescue S<   ? 
         0:00 [kintegrityd]
1     0  1027     2   0 -20      0     0 rescue S<   ? 
         0:00 [kblockd]
5     0  1032     2 -51   -      0     0 irq_wa S    ? 
         0:00 [irq/9-acpi]
1     0  1159     2   0 -20      0     0 rescue S<   ? 
         0:00 [tifm]
1     0  1188     2   0 -20      0     0 rescue S<   ? 
         0:00 [ata_sff]
1     0  1200     2  20   0      0     0 hub_th S    ? 
         0:00 [khubd]
1     0  1213     2   0 -20      0     0 rescue S<   ? 
         0:00 [md]
1     0  1335     2   0 -20      0     0 rescue S<   ? 
         0:00 [rpciod]
1     0  1355     2  20   0      0     0 watchd S    ? 
         0:00 [khungtaskd]
1     0  1361     2  20   0      0     0 conges D    ? 
         0:01 [kswapd0]
1     0  1362     2  25   5      0     0 ksm_sc SN   ? 
         0:00 [ksmd]
1     0  1438     2  39  19      0     0 khugep SN   ? 
         0:00 [khugepaged]
1     0  1439     2  20   0      0     0 fsnoti S    ? 
         0:00 [fsnotify_mark]
1     0  1478     2  20   0      0     0 ecrypt S    ? 
         0:00 [ecryptfs-kthrea]
1     0  1481     2   0 -20      0     0 rescue S<   ? 
         0:00 [nfsiod]
1     0  1486     2   0 -20      0     0 rescue S<   ? 
         0:00 [cifsiod]
1     0  1511     2  20   0      0     0 jfsIOW S    ? 
         0:00 [jfsIO]
1     0  1512     2  20   0      0     0 jfs_la S    ? 
         0:00 [jfsCommit]
1     0  1513     2  20   0      0     0 jfs_sy S    ? 
         0:00 [jfsSync]
1     0  1520     2   0 -20      0     0 rescue S<   ? 
         0:00 [xfsalloc]
1     0  1521     2   0 -20      0     0 rescue S<   ? 
         0:00 [xfs_mru_cache]
1     0  1522     2   0 -20      0     0 rescue S<   ? 
         0:00 [xfslogd]
1     0  1529     2   0 -20      0     0 rescue S<   ? 
         0:00 [ocfs2_wq]
1     0  1532     2   0 -20      0     0 rescue S<   ? 
         0:00 [user_dlm]
1     0  1538     2   0 -20      0     0 rescue S<   ? 
         0:00 [glock_workqueue]
1     0  1539     2   0 -20      0     0 rescue S<   ? 
         0:00 [delete_workqueu]
1     0  1543     2   0 -20      0     0 rescue S<   ? 
         0:00 [gfs_recovery]
1     0  1547     2   0 -20      0     0 rescue S<   ? 
         0:00 [crypto]
1     0  1676     2  20   0      0     0 worker S    ? 
         0:00 [kworker/u:2]
1     0  2301     2  20   0      0     0 scan_t S    ? 
         0:00 [cciss_scan]
1     0  2430     2   0 -20      0     0 rescue S<   ? 
         0:00 [iscsi_eh]
1     0  2439     2   0 -20      0     0 rescue S<   ? 
         0:00 [kmpath_rdacd]
1     0  2440     2   0 -20      0     0 rescue S<   ? 
         0:00 [fc_exch_workque]
1     0  2441     2   0 -20      0     0 rescue S<   ? 
         0:00 [fc_rport_eq]
1     0  2442     2   0 -20      0     0 fcoe_p S<   ? 
         0:00 [fcoethread/0]
1     0  2444     2   0 -20      0     0 rescue S<   ? 
         0:00 [fnic_event_wq]
1     0  2446     2   0 -20      0     0 bnx2fc S<   ? 
         0:00 [bnx2fc_l2_threa]
1     0  2447     2   0 -20      0     0 bnx2fc S<   ? 
         0:00 [bnx2fc_thread/0]
1     0  2523     2   0 -20      0     0 bnx2i_ S<   ? 
         0:00 [bnx2i_thread/0]
1     0  2561     2  20   0      0     0 scsi_e S    ? 
         0:00 [scsi_eh_2]
1     0  2564     2  20   0      0     0 scsi_e S    ? 
         0:02 [scsi_eh_3]
1     0  2567     2  20   0      0     0 worker S    ? 
         0:00 [kworker/u:3]
1     0  2574     2  20   0      0     0 scsi_e S    ? 
         0:00 [scsi_eh_4]
1     0  2577     2  20   0      0     0 scsi_e S    ? 
         0:00 [scsi_eh_5]
1     0  2642     2   0 -20      0     0 rescue S<   ? 
         0:00 [smflush]
1     0  2657     2  20   0      0     0 mtd_bl S    ? 
         0:00 [mtdblock0]
1     0  2668     2  20   0      0     0 mtd_bl S    ? 
         0:00 [mtdblock1]
1     0  2677     2  20   0      0     0 mtd_bl S    ? 
         0:00 [mtdblock2]
1     0  2694     2   0 -20      0     0 rescue S<   ? 
         0:00 [cnic_wq]
1     0  2712     2   0 -20      0     0 rescue S<   ? 
         0:00 [exec-osm]
1     0  2719     2   0 -20      0     0 rescue S<   ? 
         0:00 [block-osm]
1     0  2727     2   0 -20      0     0 rescue S<   ? 
         0:00 [firewire]
1     0  2804     2   0 -20      0     0 rescue S<   ? 
         0:00 [wusbd]
1     0  2866     2   0 -20      0     0 rescue S<   ? 
         0:00 [kpsmoused]
1     0  2979     2   0 -20      0     0 rescue S<   ? 
         0:00 [dm_bufio_cache]
1     0  2980     2   0 -20      0     0 rescue S<   ? 
         0:00 [kmpathd]
1     0  2981     2   0 -20      0     0 rescue S<   ? 
         0:00 [kmpath_handlerd]
1     0  2984     2   0 -20      0     0 rescue S<   ? 
         0:00 [edac-poller]
1     0  2997     2   0 -20      0     0 rescue S<   ? 
         0:00 [kmemstick]
1     0  3062     2   0 -20      0     0 rescue S<   ? 
         0:00 [binder]
1     0  5328     2  30  10      0     0 kmemle SN   ? 
         4:55 [kmemleak]
1     0  5330     2   0 -20      0     0 rescue S<   ? 
         0:00 [kafs_vlupdated]
1     0  5331     2   0 -20      0     0 rescue S<   ? 
         0:00 [kafs_callbackd]
1     0  5332     2   0 -20      0     0 rescue S<   ? 
         0:00 [kafsd]
1     0  5335     2   0 -20      0     0 rescue S<   ? 
         0:00 [deferwq]
1     0  5340     2   0 -20      0     0 rescue S<   ? 
         0:00 [devfreq_wq]
1     0  5343     2  20   0      0     0 kjourn S    ? 
         0:04 [kjournald]
5     0  5371     1  16  -4   3124  1752 poll_s S<s  ? 
         0:03 /sbin/udevd --daemon
4     0  6451  9516  20   0   7292  4852 poll_s S    tty2 
      0:05 nepenthes
0     0  6743  9515  20   0   3052  1432 wait   S    tty1 
      0:00 sh psaxl.sh
0     0  6853  9515  20   0   7612  4540 poll_s S+   tty1 
      0:01 /usr/bin/mc -P /tmp/mc-root/mc.pwd.9515
4     0  6854  6853  20   0   1856   268 pipe_w Ss   ? 
         0:00 cons.saver /dev/vc/1
0     0  6855  6853  20   0   3424  1860 n_tty_ Ss+  pts/2 
     0:00 bash -rcfile .bashrc
1     0  7427     2   0 -20      0     0 rescue S<   ? 
         0:00 [hd-audio0]
1     0  9009     2  20   0      0     0 bdi_wr S    ? 
         0:07 [flush-8:0]
1     0  9073     1  20   0   1928   664 poll_s Ss   ? 
         0:00 /usr/sbin/syslogd
5     0  9077     1  20   0   1880   436 syslog Ss   ? 
         0:00 /usr/sbin/klogd -c 3 -x
5     0  9291     1  20   0   1920   568 poll_s Ss   ? 
         0:00 /usr/sbin/inetd
1     0  9298     1  20   0   1876   564 poll_s Ss   ? 
         0:00 /usr/sbin/acpid
5    81  9309     1  20   0   2664   868 poll_s Ss   ? 
         0:00 /usr/bin/dbus-daemon --system
5    82  9314     1  20   0  15432  5016 poll_s Ssl  ? 
         0:00 /usr/sbin/hald --daemon=yes
0     0  9315  9314  20   0  11872  1244 poll_s Sl   ? 
         0:00 hald-runner
0     0  9337  9315  20   0   3800  1256 poll_s S    ? 
         0:00 hald-addon-input: Listening on 
/dev/input/event4 /dev/input/event0 /dev/input/event1 
/dev/input/event10 /dev/input/event2
0     0  9344  9315  20   0   3812  1076 poll_s S    ? 
         0:00 /usr/libexec/hald-addon-cpufreq
4    82  9345  9315  20   0   2572  1100 unix_s S    ? 
         0:00 hald-addon-acpi: listening on acpid socket 
/var/run/acpid.socket
0     0  9348  9315  20   0   3800  1076 poll_s S    ? 
         0:11 hald-addon-storage: polling /dev/hda (every 
2 sec)
0     0  9356  9315  20   0   3800  1076 poll_s S    ? 
         0:05 hald-addon-storage: polling /dev/sr0 (every 
2 sec)
5     0  9373     1  20   0   2536   936 poll_s Ss   ? 
         0:00 /usr/sbin/hcid -f /etc/bluetooth/hcid.conf
5     0  9377     1  20   0   1976   388 poll_s Ss   ? 
         0:00 /usr/sbin/sdpd
1     0  9387     1  20   0   2132   392 poll_s Ss   ? 
         0:00 /usr/bin/hidd --server
5     0  9392     2  10 -10      0     0 rfcomm S<   ? 
         0:00 [krfcommd]
4     0  9407     1  20   0   5832  2572 ep_pol Ss   ? 
         0:00 /usr/sbin/cupsd -C /etc/cups/cupsd.conf
1     0  9454     1  20   0   2096   716 hrtime S    ? 
         0:00 /usr/sbin/crond -l10
1     2  9456     1  20   0   2100   332 hrtime Ss   ? 
         0:00 /usr/sbin/atd -b 15 -l 1
1     0  9506     1  20   0   1864   308 hrtime Ss   ? 
         0:00 rkdet 1451
4     0  9515     1  20   0   3448  1960 wait   Ss   tty1 
      0:00 -bash
4     0  9516     1  20   0   3448  1956 n_tty_ Ss+  tty2 
      0:00 -bash
0     0  9517     1  20   0   1880   564 n_tty_ Ss+  tty3 
      0:00 /sbin/agetty 38400 tty3 linux
0     0  9518     1  20   0   1880   568 n_tty_ Ss+  tty4 
      0:00 /sbin/agetty 38400 tty4 linux
0     0  9519     1  20   0   1880   564 n_tty_ Ss+  tty5 
      0:00 /sbin/agetty 38400 tty5 linux
0     0  9520     1  20   0   1880   572 n_tty_ Ss+  tty6 
      0:00 /sbin/agetty 38400 tty6 linux
4     0  9521     1  20   0   3408   868 poll_s Ss   ? 
         0:00 /opt/kde/bin/kdm -nodaemon
4     0  9537  9521  20   0  50756 44240 poll_s Ss+  tty7 
      5:46 /usr/bin/X -br -nolisten tcp :0 vt7 -auth 
/var/run/xauth/A:0-Jp1H0T
1     0  9541  9521  20   0   3728  1204 wait   S    ? 
         0:00 -:0
4     0  9549  9541  20   0   3060  1500 wait   Ss   ? 
         0:00 /bin/sh /usr/bin/startkde
0     0  9567  9549  20   0  12404  1640 hrtime Sl   ? 
         0:51 /usr/bin/tpb
1     0  9603     1  20   0   1856    76 pipe_w S    ? 
         0:00 start_kdeinit --new-startup +kcminit_startup
1     0  9604     1  20   0  25160  7980 poll_s Ss   ? 
         0:00 kdeinit Running...
1     0  9607     1  20   0  24352  3216 poll_s S    ? 
         0:00 dcopserver [kdeinit] --nosid
5     0  9609  9604  20   0  29032  8488 poll_s S    ? 
         0:00 klauncher [kdeinit] --new-startup
1     0  9611     1  20   0  56232 30716 poll_s S    ? 
        20:34 kded [kdeinit] --new-startup
0     0  9618  9549  20   0   1860   272 hrtime S    ? 
         0:01 kwrapper ksmserver
1     0  9620     1  20   0  38748 22156 poll_s S    ? 
         0:00 ksmserver [kdeinit]
1     0  9621  9604  20   0  41744 25564 poll_s S    ? 
         0:09 kwin [kdeinit]
1     0  9623     1  20   0  47612 31632 poll_s S    ? 
         0:15 kdesktop [kdeinit]
1     0  9625     1  20   0  57588 42456 poll_s S    ? 
         0:20 kicker [kdeinit]
1     0  9632     1  20   0  38984 22176 poll_s S    ? 
         0:00 kaccess [kdeinit]
4     0  9645  9604  20   0  75860 21724 poll_s SL   ? 
         4:36 artsd -F 9 -S 4096 -a alsa -b 8 -s 333 -m 
artsmessage -c drkonqi -l 3 -f
1     0  9649     1  20   0  26708  8828 poll_s S    ? 
         0:00 kalarmd --autostart
0     0  9650  9604  20   0  22340 10500 poll_s S    ? 
         0:00 nm-applet --sm-disable
1     0  9651     1  20   0  50312 25620 poll_s S    ? 
         0:01 knotify [kdeinit]
1     0  9671     1  20   0   3492   612 poll_s S    ? 
         0:00 dbus-launch --autolaunch 
9b9f86fbd8163bb39486a000475487ec --binary-syntax 
--close-stderr
1     0  9672     1  20   0   2520   748 poll_s Ss   ? 
         0:00 /usr/bin/dbus-daemon --fork --print-pid 5 
--print-address 7 --session
0     0  9686     1  20   0  17196  4944 poll_s S    ? 
         0:00 /usr/libexec/xfce4-notifyd
0     0  9688     1  20   0   4008  1788 poll_s S    ? 
         0:00 /usr/libexec/xfconfd
0     0  9690     1  20   0   5196  2816 poll_s S    ? 
         0:01 /usr/libexec/gconfd-2
5     0 10074     1  20   0  41364 12284 rt_sig Ssl  ? 
         0:00 named -d 5
0     0 11010     1  20   0   3072  1520 wait   S    ? 
         0:00 /bin/sh /usr/bin/mysqld_safe --user=root
4     0 11053 11010  20   0 102952 20932 poll_s Sl   ? 
         0:05 /usr/sbin/mysqld --basedir=/ --datadir=//var 
--user=root --pid-file=//var/werner.pid 
--log-error=//var/werner.err
5     0 11084     1  20   0   6904  2108 poll_s Ss   ? 
         0:01 sendmail: accepting connections
1     0 11085     1  20   0   6292  2772 poll_s S    ? 
         0:00 /usr/local/src/Unreal3.2/src/ircd
1     0 11093     1  20   0  53056  8864 poll_s Ss   ? 
         0:00 /usr/local/apache2/bin/httpd -k restart
5     2 11099 11093  20   0  54328 10280 inet_c S    ? 
         0:00 /usr/local/apache2/bin/httpd -k restart
5     2 11100 11093  20   0  55208 11624 inet_c S    ? 
         0:00 /usr/local/apache2/bin/httpd -k restart
5     2 11101 11093  20   0  55208 11668 inet_c S    ? 
         0:00 /usr/local/apache2/bin/httpd -k restart
5     2 11102 11093  20   0  54952 11556 inet_c S    ? 
         0:00 /usr/local/apache2/bin/httpd -k restart
5     2 11103 11093  20   0  54960 11572 inet_c S    ? 
         0:00 /usr/local/apache2/bin/httpd -k restart
5     0 11110     1  20   0   5900   828 poll_s Ss   ? 
         0:00 pure-ftpd (SERVER)
5     0 11124     1  20   0   3428   608 poll_s Ss   ? 
         0:00 rsync -v --daemon
1     0 11134     1  20   0   7608  5040 poll_s Ss   ? 
         0:00 /usr/local/bin/perl 
/usr/local/src/webmin/miniserv.pl 
/etc/webmin/miniserv.conf
1     0 11147     1  20   0   7196  5124 poll_s Ss   ? 
         0:00 /usr/local/bin/perl 
/usr/local/src/usermin/miniserv.pl 
/etc/usermin/miniserv.conf
1     0 11711     1  20   0  40496 25208 poll_s S    ? 
         0:00 kio_uiserver [kdeinit]
5     2 13733 11093  20   0  55224 11664 inet_c S    ? 
         0:00 /usr/local/apache2/bin/httpd -k restart
5     2 13750 11093  20   0  55092 10648 inet_c S    ? 
         0:00 /usr/local/apache2/bin/httpd -k restart
5     2 13751 11093  20   0  55844 11872 inet_c S    ? 
         0:00 /usr/local/apache2/bin/httpd -k restart
5     2 13752 11093  20   0  55912 12168 inet_c S    ? 
         0:00 /usr/local/apache2/bin/httpd -k restart
5     2 13753 11093  20   0  55372 11568 inet_c S    ? 
         0:00 /usr/local/apache2/bin/httpd -k restart
5     0 14181  9604  20   0  57952 40024 poll_s S    ? 
         0:02 konqueror [kdeinit] /
1     0 20523     2  20   0      0     0 worker S    ? 
         0:00 [kworker/0:2]
5     0 21323  9604  20   0  63344 45080 poll_s S    ? 
         0:06 konqueror [kdeinit] /
4     0 23472  9604  20   0 326076 97096 poll_s Sl   ? 
         0:04 /usr/lib/firefox/firefox-bin
1     0 26090     2  20   0      0     0 worker S    ? 
         0:00 [kworker/0:0]
1     0 26177  9604  20   0  25644  7392 poll_s S    ? 
         0:00 kio_file [kdeinit] file 
/tmp/ksocket-root/klaunchers4Ewqb.
0     0 26279  9604  20   0  78940 47272 poll_s S    ? 
         1:18 kpdf /FULA-KURS/manual-1.pdf -icon kpdf 
-caption KPDF
1     0 27679     2  20   0      0     0 worker S    ? 
         0:00 [kworker/0:1]
0     0 28012  6743  20   0   2528   584 -      R    tty1 
      0:00 ps axl
  ****
Mon Apr  9 03:14:10 GFT 2012
  ****
F   UID   PID  PPID PRI  NI    VSZ   RSS WCHAN  STAT TTY 
       TIME COMMAND
4     0     1     0  20   0    824   324 poll_s Ss   ? 
         0:37 init [4]
1     0     2     0  20   0      0     0 kthrea S    ? 
         0:01 [kthreadd]
1     0     3     2  20   0      0     0 run_ks S    ? 
         0:26 [ksoftirqd/0]
1     0     6     2 -100  -      0     0 cpu_st S    ? 
         0:00 [migration/0]
1     0     7     2 -100  -      0     0 watchd S    ? 
         0:00 [watchdog/0]
1     0     8     2   0 -20      0     0 rescue S<   ? 
         0:00 [khelper]
5     0     9     2  20   0      0     0 devtmp S    ? 
         0:00 [kdevtmpfs]
1     0    10     2   0 -20      0     0 rescue S<   ? 
         0:00 [netns]
1     0  1023     2  20   0      0     0 bdi_sy S    ? 
         0:00 [sync_supers]
1     0  1025     2  20   0      0     0 bdi_fo S    ? 
         0:00 [bdi-default]
1     0  1026     2   0 -20      0     0 rescue S<   ? 
         0:00 [kintegrityd]
1     0  1027     2   0 -20      0     0 rescue S<   ? 
         0:00 [kblockd]
5     0  1032     2 -51   -      0     0 irq_wa S    ? 
         0:00 [irq/9-acpi]
1     0  1159     2   0 -20      0     0 rescue S<   ? 
         0:00 [tifm]
1     0  1188     2   0 -20      0     0 rescue S<   ? 
         0:00 [ata_sff]
1     0  1200     2  20   0      0     0 hub_th S    ? 
         0:00 [khubd]
1     0  1213     2   0 -20      0     0 rescue S<   ? 
         0:00 [md]
1     0  1335     2   0 -20      0     0 rescue S<   ? 
         0:00 [rpciod]
1     0  1355     2  20   0      0     0 watchd S    ? 
         0:00 [khungtaskd]
1     0  1361     2  20   0      0     0 conges D    ? 
         0:01 [kswapd0]
1     0  1362     2  25   5      0     0 ksm_sc SN   ? 
         0:00 [ksmd]
1     0  1438     2  39  19      0     0 khugep SN   ? 
         0:00 [khugepaged]
1     0  1439     2  20   0      0     0 fsnoti S    ? 
         0:00 [fsnotify_mark]
1     0  1478     2  20   0      0     0 ecrypt S    ? 
         0:00 [ecryptfs-kthrea]
1     0  1481     2   0 -20      0     0 rescue S<   ? 
         0:00 [nfsiod]
1     0  1486     2   0 -20      0     0 rescue S<   ? 
         0:00 [cifsiod]
1     0  1511     2  20   0      0     0 jfsIOW S    ? 
         0:00 [jfsIO]
1     0  1512     2  20   0      0     0 jfs_la S    ? 
         0:00 [jfsCommit]
1     0  1513     2  20   0      0     0 jfs_sy S    ? 
         0:00 [jfsSync]
1     0  1520     2   0 -20      0     0 rescue S<   ? 
         0:00 [xfsalloc]
1     0  1521     2   0 -20      0     0 rescue S<   ? 
         0:00 [xfs_mru_cache]
1     0  1522     2   0 -20      0     0 rescue S<   ? 
         0:00 [xfslogd]
1     0  1529     2   0 -20      0     0 rescue S<   ? 
         0:00 [ocfs2_wq]
1     0  1532     2   0 -20      0     0 rescue S<   ? 
         0:00 [user_dlm]
1     0  1538     2   0 -20      0     0 rescue S<   ? 
         0:00 [glock_workqueue]
1     0  1539     2   0 -20      0     0 rescue S<   ? 
         0:00 [delete_workqueu]
1     0  1543     2   0 -20      0     0 rescue S<   ? 
         0:00 [gfs_recovery]
1     0  1547     2   0 -20      0     0 rescue S<   ? 
         0:00 [crypto]
1     0  1676     2  20   0      0     0 worker S    ? 
         0:00 [kworker/u:2]
1     0  2301     2  20   0      0     0 scan_t S    ? 
         0:00 [cciss_scan]
1     0  2430     2   0 -20      0     0 rescue S<   ? 
         0:00 [iscsi_eh]
1     0  2439     2   0 -20      0     0 rescue S<   ? 
         0:00 [kmpath_rdacd]
1     0  2440     2   0 -20      0     0 rescue S<   ? 
         0:00 [fc_exch_workque]
1     0  2441     2   0 -20      0     0 rescue S<   ? 
         0:00 [fc_rport_eq]
1     0  2442     2   0 -20      0     0 fcoe_p S<   ? 
         0:00 [fcoethread/0]
1     0  2444     2   0 -20      0     0 rescue S<   ? 
         0:00 [fnic_event_wq]
1     0  2446     2   0 -20      0     0 bnx2fc S<   ? 
         0:00 [bnx2fc_l2_threa]
1     0  2447     2   0 -20      0     0 bnx2fc S<   ? 
         0:00 [bnx2fc_thread/0]
1     0  2523     2   0 -20      0     0 bnx2i_ S<   ? 
         0:00 [bnx2i_thread/0]
1     0  2561     2  20   0      0     0 scsi_e S    ? 
         0:00 [scsi_eh_2]
1     0  2564     2  20   0      0     0 scsi_e S    ? 
         0:02 [scsi_eh_3]
1     0  2567     2  20   0      0     0 worker S    ? 
         0:00 [kworker/u:3]
1     0  2574     2  20   0      0     0 scsi_e S    ? 
         0:00 [scsi_eh_4]
1     0  2577     2  20   0      0     0 scsi_e S    ? 
         0:00 [scsi_eh_5]
1     0  2642     2   0 -20      0     0 rescue S<   ? 
         0:00 [smflush]
1     0  2657     2  20   0      0     0 mtd_bl S    ? 
         0:00 [mtdblock0]
1     0  2668     2  20   0      0     0 mtd_bl S    ? 
         0:00 [mtdblock1]
1     0  2677     2  20   0      0     0 mtd_bl S    ? 
         0:00 [mtdblock2]
1     0  2694     2   0 -20      0     0 rescue S<   ? 
         0:00 [cnic_wq]
1     0  2712     2   0 -20      0     0 rescue S<   ? 
         0:00 [exec-osm]
1     0  2719     2   0 -20      0     0 rescue S<   ? 
         0:00 [block-osm]
1     0  2727     2   0 -20      0     0 rescue S<   ? 
         0:00 [firewire]
1     0  2804     2   0 -20      0     0 rescue S<   ? 
         0:00 [wusbd]
1     0  2866     2   0 -20      0     0 rescue S<   ? 
         0:00 [kpsmoused]
1     0  2979     2   0 -20      0     0 rescue S<   ? 
         0:00 [dm_bufio_cache]
1     0  2980     2   0 -20      0     0 rescue S<   ? 
         0:00 [kmpathd]
1     0  2981     2   0 -20      0     0 rescue S<   ? 
         0:00 [kmpath_handlerd]
1     0  2984     2   0 -20      0     0 rescue S<   ? 
         0:00 [edac-poller]
1     0  2997     2   0 -20      0     0 rescue S<   ? 
         0:00 [kmemstick]
1     0  3062     2   0 -20      0     0 rescue S<   ? 
         0:00 [binder]
1     0  5328     2  30  10      0     0 kmemle SN   ? 
         4:59 [kmemleak]
1     0  5330     2   0 -20      0     0 rescue S<   ? 
         0:00 [kafs_vlupdated]
1     0  5331     2   0 -20      0     0 rescue S<   ? 
         0:00 [kafs_callbackd]
1     0  5332     2   0 -20      0     0 rescue S<   ? 
         0:00 [kafsd]
1     0  5335     2   0 -20      0     0 rescue S<   ? 
         0:00 [deferwq]
1     0  5340     2   0 -20      0     0 rescue S<   ? 
         0:00 [devfreq_wq]
1     0  5343     2  20   0      0     0 kjourn S    ? 
         0:04 [kjournald]
5     0  5371     1  16  -4   3124  1752 poll_s S<s  ? 
         0:03 /sbin/udevd --daemon
4     0  6451  9516  20   0   7292  4852 poll_s S    tty2 
      0:05 nepenthes
0     0  6743  9515  20   0   3056  1432 wait   S    tty1 
      0:00 sh psaxl.sh
0     0  6853  9515  20   0   7612  4540 poll_s S+   tty1 
      0:01 /usr/bin/mc -P /tmp/mc-root/mc.pwd.9515
4     0  6854  6853  20   0   1856   268 pipe_w Ss   ? 
         0:00 cons.saver /dev/vc/1
0     0  6855  6853  20   0   3424  1860 n_tty_ Ss+  pts/2 
     0:00 bash -rcfile .bashrc
1     0  7427     2   0 -20      0     0 rescue S<   ? 
         0:00 [hd-audio0]
1     0  9009     2  20   0      0     0 bdi_wr S    ? 
         0:07 [flush-8:0]
1     0  9073     1  20   0   1928   664 poll_s Ss   ? 
         0:00 /usr/sbin/syslogd
5     0  9077     1  20   0   1880   436 syslog Ss   ? 
         0:00 /usr/sbin/klogd -c 3 -x
5     0  9291     1  20   0   1920   568 poll_s Ss   ? 
         0:00 /usr/sbin/inetd
1     0  9298     1  20   0   1876   564 poll_s Ss   ? 
         0:00 /usr/sbin/acpid
5    81  9309     1  20   0   2664   868 poll_s Ss   ? 
         0:00 /usr/bin/dbus-daemon --system
5    82  9314     1  20   0  15432  5016 poll_s Ssl  ? 
         0:00 /usr/sbin/hald --daemon=yes
0     0  9315  9314  20   0  11872  1244 poll_s Sl   ? 
         0:00 hald-runner
0     0  9337  9315  20   0   3800  1256 poll_s S    ? 
         0:00 hald-addon-input: Listening on 
/dev/input/event4 /dev/input/event0 /dev/input/event1 
/dev/input/event10 /dev/input/event2
0     0  9344  9315  20   0   3812  1076 poll_s S    ? 
         0:00 /usr/libexec/hald-addon-cpufreq
4    82  9345  9315  20   0   2572  1100 unix_s S    ? 
         0:00 hald-addon-acpi: listening on acpid socket 
/var/run/acpid.socket
0     0  9348  9315  20   0   3800  1076 poll_s S    ? 
         0:11 hald-addon-storage: polling /dev/hda (every 
2 sec)
0     0  9356  9315  20   0   3800  1076 poll_s S    ? 
         0:05 hald-addon-storage: polling /dev/sr0 (every 
2 sec)
5     0  9373     1  20   0   2536   936 poll_s Ss   ? 
         0:00 /usr/sbin/hcid -f /etc/bluetooth/hcid.conf
5     0  9377     1  20   0   1976   388 poll_s Ss   ? 
         0:00 /usr/sbin/sdpd
1     0  9387     1  20   0   2132   392 poll_s Ss   ? 
         0:00 /usr/bin/hidd --server
5     0  9392     2  10 -10      0     0 rfcomm S<   ? 
         0:00 [krfcommd]
4     0  9407     1  20   0   5832  2572 ep_pol Ss   ? 
         0:00 /usr/sbin/cupsd -C /etc/cups/cupsd.conf
1     0  9454     1  20   0   2096   716 hrtime S    ? 
         0:00 /usr/sbin/crond -l10
1     2  9456     1  20   0   2100   332 hrtime Ss   ? 
         0:00 /usr/sbin/atd -b 15 -l 1
1     0  9506     1  20   0   1864   308 hrtime Ss   ? 
         0:00 rkdet 1451
4     0  9515     1  20   0   3448  1960 wait   Ss   tty1 
      0:00 -bash
4     0  9516     1  20   0   3448  1956 n_tty_ Ss+  tty2 
      0:00 -bash
0     0  9517     1  20   0   1880   564 n_tty_ Ss+  tty3 
      0:00 /sbin/agetty 38400 tty3 linux
0     0  9518     1  20   0   1880   568 n_tty_ Ss+  tty4 
      0:00 /sbin/agetty 38400 tty4 linux
0     0  9519     1  20   0   1880   564 n_tty_ Ss+  tty5 
      0:00 /sbin/agetty 38400 tty5 linux
0     0  9520     1  20   0   1880   572 n_tty_ Ss+  tty6 
      0:00 /sbin/agetty 38400 tty6 linux
4     0  9521     1  20   0   3408   868 poll_s Ss   ? 
         0:00 /opt/kde/bin/kdm -nodaemon
4     0  9537  9521  20   0  41948 35616 poll_s Ss+  tty7 
      5:47 /usr/bin/X -br -nolisten tcp :0 vt7 -auth 
/var/run/xauth/A:0-Jp1H0T
1     0  9541  9521  20   0   3728  1204 wait   S    ? 
         0:00 -:0
4     0  9549  9541  20   0   3060  1500 wait   Ss   ? 
         0:00 /bin/sh /usr/bin/startkde
0     0  9567  9549  20   0  12404  1640 hrtime Sl   ? 
         0:51 /usr/bin/tpb
1     0  9603     1  20   0   1856    76 pipe_w S    ? 
         0:00 start_kdeinit --new-startup +kcminit_startup
1     0  9604     1  20   0  25160  7980 poll_s Ss   ? 
         0:00 kdeinit Running...
1     0  9607     1  20   0  24352  3216 poll_s S    ? 
         0:00 dcopserver [kdeinit] --nosid
5     0  9609  9604  20   0  29036  8488 poll_s S    ? 
         0:00 klauncher [kdeinit] --new-startup
1     0  9611     1  20   0  56232 30716 poll_s S    ? 
        20:36 kded [kdeinit] --new-startup
0     0  9618  9549  20   0   1860   272 hrtime S    ? 
         0:01 kwrapper ksmserver
1     0  9620     1  20   0  38748 22156 poll_s S    ? 
         0:00 ksmserver [kdeinit]
1     0  9621  9604  20   0  41744 25564 poll_s S    ? 
         0:09 kwin [kdeinit]
1     0  9623     1  20   0  47612 31632 poll_s S    ? 
         0:15 kdesktop [kdeinit]
1     0  9625     1  20   0  57588 42456 poll_s S    ? 
         0:20 kicker [kdeinit]
1     0  9632     1  20   0  38984 22176 poll_s S    ? 
         0:00 kaccess [kdeinit]
4     0  9645  9604  20   0  76292 21872 poll_s SL   ? 
         4:37 artsd -F 9 -S 4096 -a alsa -b 8 -s 333 -m 
artsmessage -c drkonqi -l 3 -f
1     0  9649     1  20   0  26708  8828 poll_s S    ? 
         0:00 kalarmd --autostart
0     0  9650  9604  20   0  22340 10500 poll_s S    ? 
         0:00 nm-applet --sm-disable
1     0  9651     1  20   0  50312 25620 poll_s S    ? 
         0:01 knotify [kdeinit]
1     0  9671     1  20   0   3492   612 poll_s S    ? 
         0:00 dbus-launch --autolaunch 
9b9f86fbd8163bb39486a000475487ec --binary-syntax 
--close-stderr
1     0  9672     1  20   0   2520   748 poll_s Ss   ? 
         0:00 /usr/bin/dbus-daemon --fork --print-pid 5 
--print-address 7 --session
0     0  9686     1  20   0  17196  4944 poll_s S    ? 
         0:00 /usr/libexec/xfce4-notifyd
0     0  9688     1  20   0   4008  1788 poll_s S    ? 
         0:00 /usr/libexec/xfconfd
0     0  9690     1  20   0   5196  2816 poll_s S    ? 
         0:01 /usr/libexec/gconfd-2
5     0 10074     1  20   0  41364 12284 rt_sig Ssl  ? 
         0:00 named -d 5
0     0 11010     1  20   0   3072  1520 wait   S    ? 
         0:00 /bin/sh /usr/bin/mysqld_safe --user=root
4     0 11053 11010  20   0 102952 20932 poll_s Sl   ? 
         0:05 /usr/sbin/mysqld --basedir=/ --datadir=//var 
--user=root --pid-file=//var/werner.pid 
--log-error=//var/werner.err
5     0 11084     1  20   0   6904  2108 poll_s Ss   ? 
         0:01 sendmail: accepting connections
1     0 11085     1  20   0   6292  2772 poll_s S    ? 
         0:00 /usr/local/src/Unreal3.2/src/ircd
1     0 11093     1  20   0  53056  8864 poll_s Ss   ? 
         0:00 /usr/local/apache2/bin/httpd -k restart
5     2 11099 11093  20   0  54328 10280 inet_c S    ? 
         0:00 /usr/local/apache2/bin/httpd -k restart
5     2 11100 11093  20   0  55208 11624 inet_c S    ? 
         0:00 /usr/local/apache2/bin/httpd -k restart
5     2 11101 11093  20   0  55208 11668 inet_c S    ? 
         0:00 /usr/local/apache2/bin/httpd -k restart
5     2 11102 11093  20   0  54952 11556 inet_c S    ? 
         0:00 /usr/local/apache2/bin/httpd -k restart
5     2 11103 11093  20   0  54960 11572 inet_c S    ? 
         0:00 /usr/local/apache2/bin/httpd -k restart
5     0 11110     1  20   0   5900   828 poll_s Ss   ? 
         0:00 pure-ftpd (SERVER)
5     0 11124     1  20   0   3428   608 poll_s Ss   ? 
         0:00 rsync -v --daemon
1     0 11134     1  20   0   7608  5040 poll_s Ss   ? 
         0:00 /usr/local/bin/perl 
/usr/local/src/webmin/miniserv.pl 
/etc/webmin/miniserv.conf
1     0 11147     1  20   0   7196  5124 poll_s Ss   ? 
         0:00 /usr/local/bin/perl 
/usr/local/src/usermin/miniserv.pl 
/etc/usermin/miniserv.conf
1     0 11711     1  20   0  40496 25208 poll_s S    ? 
         0:00 kio_uiserver [kdeinit]
5     2 13733 11093  20   0  55224 11664 inet_c S    ? 
         0:00 /usr/local/apache2/bin/httpd -k restart
5     2 13750 11093  20   0  55092 10648 inet_c S    ? 
         0:00 /usr/local/apache2/bin/httpd -k restart
5     2 13751 11093  20   0  55844 11872 inet_c S    ? 
         0:00 /usr/local/apache2/bin/httpd -k restart
5     2 13752 11093  20   0  55912 12168 inet_c S    ? 
         0:00 /usr/local/apache2/bin/httpd -k restart
5     2 13753 11093  20   0  55372 11568 inet_c S    ? 
         0:00 /usr/local/apache2/bin/httpd -k restart
5     0 14181  9604  20   0  57952 40024 poll_s S    ? 
         0:02 konqueror [kdeinit] /
1     0 20523     2  20   0      0     0 worker S    ? 
         0:00 [kworker/0:2]
5     0 21323  9604  20   0  63340 45076 poll_s S    ? 
         0:06 konqueror [kdeinit] /
4     0 23472  9604  20   0 326076 97096 poll_s Sl   ? 
         0:04 /usr/lib/firefox/firefox-bin
1     0 26090     2  20   0      0     0 worker S    ? 
         0:00 [kworker/0:0]
1     0 26177  9604  20   0  25644  7412 poll_s S    ? 
         0:00 kio_file [kdeinit] file 
/tmp/ksocket-root/klaunchers4Ewqb.
0     0 26279  9604  20   0  90244 58724 poll_s S    ? 
         1:36 kpdf /FULA-KURS/manual-1.pdf -icon kpdf 
-caption KPDF
1     0 27679     2  20   0      0     0 worker S    ? 
         0:00 [kworker/0:1]
0     0 28212  6743  20   0   2528   584 -      R    tty1 
      0:00 ps axl
  ****
Mon Apr  9 03:14:40 GFT 2012
  ****
F   UID   PID  PPID PRI  NI    VSZ   RSS WCHAN  STAT TTY 
       TIME COMMAND
4     0     1     0  20   0    824   324 poll_s Ss   ? 
         0:37 init [4]
1     0     2     0  20   0      0     0 kthrea S    ? 
         0:01 [kthreadd]
1     0     3     2  20   0      0     0 run_ks S    ? 
         0:26 [ksoftirqd/0]
1     0     6     2 -100  -      0     0 cpu_st S    ? 
         0:00 [migration/0]
1     0     7     2 -100  -      0     0 watchd S    ? 
         0:00 [watchdog/0]
1     0     8     2   0 -20      0     0 rescue S<   ? 
         0:00 [khelper]
5     0     9     2  20   0      0     0 devtmp S    ? 
         0:00 [kdevtmpfs]
1     0    10     2   0 -20      0     0 rescue S<   ? 
         0:00 [netns]
1     0  1023     2  20   0      0     0 bdi_sy S    ? 
         0:00 [sync_supers]
1     0  1025     2  20   0      0     0 bdi_fo S    ? 
         0:00 [bdi-default]
1     0  1026     2   0 -20      0     0 rescue S<   ? 
         0:00 [kintegrityd]
1     0  1027     2   0 -20      0     0 rescue S<   ? 
         0:00 [kblockd]
5     0  1032     2 -51   -      0     0 irq_wa S    ? 
         0:00 [irq/9-acpi]
1     0  1159     2   0 -20      0     0 rescue S<   ? 
         0:00 [tifm]
1     0  1188     2   0 -20      0     0 rescue S<   ? 
         0:00 [ata_sff]
1     0  1200     2  20   0      0     0 hub_th S    ? 
         0:00 [khubd]
1     0  1213     2   0 -20      0     0 rescue S<   ? 
         0:00 [md]
1     0  1335     2   0 -20      0     0 rescue S<   ? 
         0:00 [rpciod]
1     0  1355     2  20   0      0     0 watchd S    ? 
         0:00 [khungtaskd]
1     0  1361     2  20   0      0     0 conges D    ? 
         0:01 [kswapd0]
1     0  1362     2  25   5      0     0 ksm_sc SN   ? 
         0:00 [ksmd]
1     0  1438     2  39  19      0     0 khugep SN   ? 
         0:00 [khugepaged]
1     0  1439     2  20   0      0     0 fsnoti S    ? 
         0:00 [fsnotify_mark]
1     0  1478     2  20   0      0     0 ecrypt S    ? 
         0:00 [ecryptfs-kthrea]
1     0  1481     2   0 -20      0     0 rescue S<   ? 
         0:00 [nfsiod]
1     0  1486     2   0 -20      0     0 rescue S<   ? 
         0:00 [cifsiod]
1     0  1511     2  20   0      0     0 jfsIOW S    ? 
         0:00 [jfsIO]
1     0  1512     2  20   0      0     0 jfs_la S    ? 
         0:00 [jfsCommit]
1     0  1513     2  20   0      0     0 jfs_sy S    ? 
         0:00 [jfsSync]
1     0  1520     2   0 -20      0     0 rescue S<   ? 
         0:00 [xfsalloc]
1     0  1521     2   0 -20      0     0 rescue S<   ? 
         0:00 [xfs_mru_cache]
1     0  1522     2   0 -20      0     0 rescue S<   ? 
         0:00 [xfslogd]
1     0  1529     2   0 -20      0     0 rescue S<   ? 
         0:00 [ocfs2_wq]
1     0  1532     2   0 -20      0     0 rescue S<   ? 
         0:00 [user_dlm]
1     0  1538     2   0 -20      0     0 rescue S<   ? 
         0:00 [glock_workqueue]
1     0  1539     2   0 -20      0     0 rescue S<   ? 
         0:00 [delete_workqueu]
1     0  1543     2   0 -20      0     0 rescue S<   ? 
         0:00 [gfs_recovery]
1     0  1547     2   0 -20      0     0 rescue S<   ? 
         0:00 [crypto]
1     0  1676     2  20   0      0     0 worker S    ? 
         0:00 [kworker/u:2]
1     0  2301     2  20   0      0     0 scan_t S    ? 
         0:00 [cciss_scan]
1     0  2430     2   0 -20      0     0 rescue S<   ? 
         0:00 [iscsi_eh]
1     0  2439     2   0 -20      0     0 rescue S<   ? 
         0:00 [kmpath_rdacd]
1     0  2440     2   0 -20      0     0 rescue S<   ? 
         0:00 [fc_exch_workque]
1     0  2441     2   0 -20      0     0 rescue S<   ? 
         0:00 [fc_rport_eq]
1     0  2442     2   0 -20      0     0 fcoe_p S<   ? 
         0:00 [fcoethread/0]
1     0  2444     2   0 -20      0     0 rescue S<   ? 
         0:00 [fnic_event_wq]
1     0  2446     2   0 -20      0     0 bnx2fc S<   ? 
         0:00 [bnx2fc_l2_threa]
1     0  2447     2   0 -20      0     0 bnx2fc S<   ? 
         0:00 [bnx2fc_thread/0]
1     0  2523     2   0 -20      0     0 bnx2i_ S<   ? 
         0:00 [bnx2i_thread/0]
1     0  2561     2  20   0      0     0 scsi_e S    ? 
         0:00 [scsi_eh_2]
1     0  2564     2  20   0      0     0 scsi_e S    ? 
         0:02 [scsi_eh_3]
1     0  2567     2  20   0      0     0 worker S    ? 
         0:00 [kworker/u:3]
1     0  2574     2  20   0      0     0 scsi_e S    ? 
         0:00 [scsi_eh_4]
1     0  2577     2  20   0      0     0 scsi_e S    ? 
         0:00 [scsi_eh_5]
1     0  2642     2   0 -20      0     0 rescue S<   ? 
         0:00 [smflush]
1     0  2657     2  20   0      0     0 mtd_bl S    ? 
         0:00 [mtdblock0]
1     0  2668     2  20   0      0     0 mtd_bl S    ? 
         0:00 [mtdblock1]
1     0  2677     2  20   0      0     0 mtd_bl S    ? 
         0:00 [mtdblock2]
1     0  2694     2   0 -20      0     0 rescue S<   ? 
         0:00 [cnic_wq]
1     0  2712     2   0 -20      0     0 rescue S<   ? 
         0:00 [exec-osm]
1     0  2719     2   0 -20      0     0 rescue S<   ? 
         0:00 [block-osm]
1     0  2727     2   0 -20      0     0 rescue S<   ? 
         0:00 [firewire]
1     0  2804     2   0 -20      0     0 rescue S<   ? 
         0:00 [wusbd]
1     0  2866     2   0 -20      0     0 rescue S<   ? 
         0:00 [kpsmoused]
1     0  2979     2   0 -20      0     0 rescue S<   ? 
         0:00 [dm_bufio_cache]
1     0  2980     2   0 -20      0     0 rescue S<   ? 
         0:00 [kmpathd]
1     0  2981     2   0 -20      0     0 rescue S<   ? 
         0:00 [kmpath_handlerd]
1     0  2984     2   0 -20      0     0 rescue S<   ? 
         0:00 [edac-poller]
1     0  2997     2   0 -20      0     0 rescue S<   ? 
         0:00 [kmemstick]
1     0  3062     2   0 -20      0     0 rescue S<   ? 
         0:00 [binder]
1     0  5328     2  30  10      0     0 kmemle SN   ? 
         4:59 [kmemleak]
1     0  5330     2   0 -20      0     0 rescue S<   ? 
         0:00 [kafs_vlupdated]
1     0  5331     2   0 -20      0     0 rescue S<   ? 
         0:00 [kafs_callbackd]
1     0  5332     2   0 -20      0     0 rescue S<   ? 
         0:00 [kafsd]
1     0  5335     2   0 -20      0     0 rescue S<   ? 
         0:00 [deferwq]
1     0  5340     2   0 -20      0     0 rescue S<   ? 
         0:00 [devfreq_wq]
1     0  5343     2  20   0      0     0 kjourn S    ? 
         0:04 [kjournald]
5     0  5371     1  16  -4   3124  1752 poll_s S<s  ? 
         0:03 /sbin/udevd --daemon
4     0  6451  9516  20   0   7292  4852 poll_s S    tty2 
      0:05 nepenthes
0     0  6743  9515  20   0   3056  1436 wait   S    tty1 
      0:00 sh psaxl.sh
0     0  6853  9515  20   0   7612  4540 poll_s S+   tty1 
      0:01 /usr/bin/mc -P /tmp/mc-root/mc.pwd.9515
4     0  6854  6853  20   0   1856   268 pipe_w Ss   ? 
         0:00 cons.saver /dev/vc/1
0     0  6855  6853  20   0   3424  1860 n_tty_ Ss+  pts/2 
     0:00 bash -rcfile .bashrc
1     0  7427     2   0 -20      0     0 rescue S<   ? 
         0:00 [hd-audio0]
1     0  9009     2  20   0      0     0 bdi_wr S    ? 
         0:07 [flush-8:0]
1     0  9073     1  20   0   1928   664 poll_s Ss   ? 
         0:00 /usr/sbin/syslogd
5     0  9077     1  20   0   1880   436 syslog Ss   ? 
         0:00 /usr/sbin/klogd -c 3 -x
5     0  9291     1  20   0   1920   568 poll_s Ss   ? 
         0:00 /usr/sbin/inetd
1     0  9298     1  20   0   1876   564 poll_s Ss   ? 
         0:00 /usr/sbin/acpid
5    81  9309     1  20   0   2664   868 poll_s Ss   ? 
         0:00 /usr/bin/dbus-daemon --system
5    82  9314     1  20   0  15432  5016 poll_s Ssl  ? 
         0:00 /usr/sbin/hald --daemon=yes
0     0  9315  9314  20   0  11872  1244 poll_s Sl   ? 
         0:00 hald-runner
0     0  9337  9315  20   0   3800  1256 poll_s S    ? 
         0:00 hald-addon-input: Listening on 
/dev/input/event4 /dev/input/event0 /dev/input/event1 
/dev/input/event10 /dev/input/event2
0     0  9344  9315  20   0   3812  1076 poll_s S    ? 
         0:00 /usr/libexec/hald-addon-cpufreq
4    82  9345  9315  20   0   2572  1100 unix_s S    ? 
         0:00 hald-addon-acpi: listening on acpid socket 
/var/run/acpid.socket
0     0  9348  9315  20   0   3800  1076 poll_s S    ? 
         0:11 hald-addon-storage: polling /dev/hda (every 
2 sec)
0     0  9356  9315  20   0   3800  1076 poll_s S    ? 
         0:05 hald-addon-storage: polling /dev/sr0 (every 
2 sec)
5     0  9373     1  20   0   2536   936 poll_s Ss   ? 
         0:00 /usr/sbin/hcid -f /etc/bluetooth/hcid.conf
5     0  9377     1  20   0   1976   388 poll_s Ss   ? 
         0:00 /usr/sbin/sdpd
1     0  9387     1  20   0   2132   392 poll_s Ss   ? 
         0:00 /usr/bin/hidd --server
5     0  9392     2  10 -10      0     0 rfcomm S<   ? 
         0:00 [krfcommd]
4     0  9407     1  20   0   5832  2572 ep_pol Ss   ? 
         0:00 /usr/sbin/cupsd -C /etc/cups/cupsd.conf
1     0  9454     1  20   0   2096   716 hrtime S    ? 
         0:00 /usr/sbin/crond -l10
1     2  9456     1  20   0   2100   332 hrtime Ss   ? 
         0:00 /usr/sbin/atd -b 15 -l 1
1     0  9506     1  20   0   1864   308 hrtime Ss   ? 
         0:00 rkdet 1451
4     0  9515     1  20   0   3448  1960 wait   Ss   tty1 
      0:00 -bash
4     0  9516     1  20   0   3448  1956 n_tty_ Ss+  tty2 
      0:00 -bash
0     0  9517     1  20   0   1880   564 n_tty_ Ss+  tty3 
      0:00 /sbin/agetty 38400 tty3 linux
0     0  9518     1  20   0   1880   568 n_tty_ Ss+  tty4 
      0:00 /sbin/agetty 38400 tty4 linux
0     0  9519     1  20   0   1880   564 n_tty_ Ss+  tty5 
      0:00 /sbin/agetty 38400 tty5 linux
0     0  9520     1  20   0   1880   572 n_tty_ Ss+  tty6 
      0:00 /sbin/agetty 38400 tty6 linux
4     0  9521     1  20   0   3408   868 poll_s Ss   ? 
         0:00 /opt/kde/bin/kdm -nodaemon
4     0  9537  9521  20   0  41948 35432 poll_s Ss+  tty7 
      5:47 /usr/bin/X -br -nolisten tcp :0 vt7 -auth 
/var/run/xauth/A:0-Jp1H0T
1     0  9541  9521  20   0   3728  1204 wait   S    ? 
         0:00 -:0
4     0  9549  9541  20   0   3060  1500 wait   Ss   ? 
         0:00 /bin/sh /usr/bin/startkde
0     0  9567  9549  20   0  12404  1640 hrtime Sl   ? 
         0:51 /usr/bin/tpb
1     0  9603     1  20   0   1856    76 pipe_w S    ? 
         0:00 start_kdeinit --new-startup +kcminit_startup
1     0  9604     1  20   0  25160  7980 poll_s Ss   ? 
         0:00 kdeinit Running...
1     0  9607     1  20   0  24352  3216 poll_s S    ? 
         0:00 dcopserver [kdeinit] --nosid
5     0  9609  9604  20   0  29036  8488 poll_s S    ? 
         0:00 klauncher [kdeinit] --new-startup
1     0  9611     1  20   0  56232 30716 poll_s S    ? 
        20:38 kded [kdeinit] --new-startup
0     0  9618  9549  20   0   1860   272 hrtime S    ? 
         0:01 kwrapper ksmserver
1     0  9620     1  20   0  38748 22156 poll_s S    ? 
         0:00 ksmserver [kdeinit]
1     0  9621  9604  20   0  41744 25564 poll_s S    ? 
         0:09 kwin [kdeinit]
1     0  9623     1  20   0  47612 31632 poll_s S    ? 
         0:15 kdesktop [kdeinit]
1     0  9625     1  20   0  57588 42456 poll_s S    ? 
         0:20 kicker [kdeinit]
1     0  9632     1  20   0  38984 22176 poll_s S    ? 
         0:00 kaccess [kdeinit]
4     0  9645  9604  20   0  76292 21872 poll_s SL   ? 
         4:38 artsd -F 9 -S 4096 -a alsa -b 8 -s 333 -m 
artsmessage -c drkonqi -l 3 -f
1     0  9649     1  20   0  26708  8828 poll_s S    ? 
         0:00 kalarmd --autostart
0     0  9650  9604  20   0  22340 10500 poll_s S    ? 
         0:00 nm-applet --sm-disable
1     0  9651     1  20   0  50312 25620 poll_s S    ? 
         0:01 knotify [kdeinit]
1     0  9671     1  20   0   3492   612 poll_s S    ? 
         0:00 dbus-launch --autolaunch 
9b9f86fbd8163bb39486a000475487ec --binary-syntax 
--close-stderr
1     0  9672     1  20   0   2520   748 poll_s Ss   ? 
         0:00 /usr/bin/dbus-daemon --fork --print-pid 5 
--print-address 7 --session
0     0  9686     1  20   0  17196  4944 poll_s S    ? 
         0:00 /usr/libexec/xfce4-notifyd
0     0  9688     1  20   0   4008  1788 poll_s S    ? 
         0:00 /usr/libexec/xfconfd
0     0  9690     1  20   0   5196  2816 poll_s S    ? 
         0:01 /usr/libexec/gconfd-2
5     0 10074     1  20   0  41364 12284 rt_sig Ssl  ? 
         0:00 named -d 5
0     0 11010     1  20   0   3072  1520 wait   S    ? 
         0:00 /bin/sh /usr/bin/mysqld_safe --user=root
4     0 11053 11010  20   0 102952 20932 poll_s Sl   ? 
         0:05 /usr/sbin/mysqld --basedir=/ --datadir=//var 
--user=root --pid-file=//var/werner.pid 
--log-error=//var/werner.err
5     0 11084     1  20   0   6904  2108 poll_s Ss   ? 
         0:01 sendmail: accepting connections
1     0 11085     1  20   0   6292  2772 poll_s S    ? 
         0:00 /usr/local/src/Unreal3.2/src/ircd
1     0 11093     1  20   0  53056  8864 poll_s Ss   ? 
         0:00 /usr/local/apache2/bin/httpd -k restart
5     2 11099 11093  20   0  54328 10280 inet_c S    ? 
         0:00 /usr/local/apache2/bin/httpd -k restart
5     2 11100 11093  20   0  55208 11624 inet_c S    ? 
         0:00 /usr/local/apache2/bin/httpd -k restart
5     2 11101 11093  20   0  55208 11668 inet_c S    ? 
         0:00 /usr/local/apache2/bin/httpd -k restart
5     2 11102 11093  20   0  54952 11556 inet_c S    ? 
         0:00 /usr/local/apache2/bin/httpd -k restart
5     2 11103 11093  20   0  54960 11572 inet_c S    ? 
         0:00 /usr/local/apache2/bin/httpd -k restart
5     0 11110     1  20   0   5900   828 poll_s Ss   ? 
         0:00 pure-ftpd (SERVER)
5     0 11124     1  20   0   3428   608 poll_s Ss   ? 
         0:00 rsync -v --daemon
1     0 11134     1  20   0   7608  5040 poll_s Ss   ? 
         0:00 /usr/local/bin/perl 
/usr/local/src/webmin/miniserv.pl 
/etc/webmin/miniserv.conf
1     0 11147     1  20   0   7196  5124 poll_s Ss   ? 
         0:00 /usr/local/bin/perl 
/usr/local/src/usermin/miniserv.pl 
/etc/usermin/miniserv.conf
1     0 11711     1  20   0  40496 25208 poll_s S    ? 
         0:00 kio_uiserver [kdeinit]
5     2 13733 11093  20   0  55224 11664 inet_c S    ? 
         0:00 /usr/local/apache2/bin/httpd -k restart
5     2 13750 11093  20   0  55092 10648 inet_c S    ? 
         0:00 /usr/local/apache2/bin/httpd -k restart
5     2 13751 11093  20   0  55844 11872 inet_c S    ? 
         0:00 /usr/local/apache2/bin/httpd -k restart
5     2 13752 11093  20   0  55912 12168 inet_c S    ? 
         0:00 /usr/local/apache2/bin/httpd -k restart
5     2 13753 11093  20   0  55372 11568 inet_c S    ? 
         0:00 /usr/local/apache2/bin/httpd -k restart
5     0 14181  9604  20   0  57952 40024 poll_s S    ? 
         0:02 konqueror [kdeinit] /
1     0 20523     2  20   0      0     0 blk_ex D    ? 
         0:00 [kworker/0:2]
5     0 21323  9604  20   0  63340 45076 poll_s S    ? 
         0:06 konqueror [kdeinit] /
4     0 23472  9604  20   0 326076 97096 poll_s Sl   ? 
         0:04 /usr/lib/firefox/firefox-bin
1     0 26090     2  20   0      0     0 worker S    ? 
         0:00 [kworker/0:0]
1     0 26177  9604  20   0  25644  7412 poll_s S    ? 
         0:00 kio_file [kdeinit] file 
/tmp/ksocket-root/klaunchers4Ewqb.
0     0 26279  9604  20   0  94652 62944 poll_s Sl   ? 
         1:45 kpdf /FULA-KURS/manual-1.pdf -icon kpdf 
-caption KPDF
1     0 27679     2  20   0      0     0 worker S    ? 
         0:00 [kworker/0:1]
0     0 28378  6743  20   0   2528   584 -      R    tty1 
      0:00 ps axl
  ****
Mon Apr  9 03:15:10 GFT 2012
  ****
F   UID   PID  PPID PRI  NI    VSZ   RSS WCHAN  STAT TTY 
       TIME COMMAND
4     0     1     0  20   0    824   324 poll_s Ss   ? 
         0:37 init [4]
1     0     2     0  20   0      0     0 kthrea S    ? 
         0:01 [kthreadd]
1     0     3     2  20   0      0     0 run_ks S    ? 
         0:26 [ksoftirqd/0]
1     0     6     2 -100  -      0     0 cpu_st S    ? 
         0:00 [migration/0]
1     0     7     2 -100  -      0     0 watchd S    ? 
         0:00 [watchdog/0]
1     0     8     2   0 -20      0     0 rescue S<   ? 
         0:00 [khelper]
5     0     9     2  20   0      0     0 devtmp S    ? 
         0:00 [kdevtmpfs]
1     0    10     2   0 -20      0     0 rescue S<   ? 
         0:00 [netns]
1     0  1023     2  20   0      0     0 bdi_sy S    ? 
         0:00 [sync_supers]
1     0  1025     2  20   0      0     0 bdi_fo S    ? 
         0:00 [bdi-default]
1     0  1026     2   0 -20      0     0 rescue S<   ? 
         0:00 [kintegrityd]
1     0  1027     2   0 -20      0     0 rescue S<   ? 
         0:00 [kblockd]
5     0  1032     2 -51   -      0     0 irq_wa S    ? 
         0:00 [irq/9-acpi]
1     0  1159     2   0 -20      0     0 rescue S<   ? 
         0:00 [tifm]
1     0  1188     2   0 -20      0     0 rescue S<   ? 
         0:00 [ata_sff]
1     0  1200     2  20   0      0     0 hub_th S    ? 
         0:00 [khubd]
1     0  1213     2   0 -20      0     0 rescue S<   ? 
         0:00 [md]
1     0  1335     2   0 -20      0     0 rescue S<   ? 
         0:00 [rpciod]
1     0  1355     2  20   0      0     0 watchd S    ? 
         0:00 [khungtaskd]
1     0  1361     2  20   0      0     0 -      R    ? 
         0:01 [kswapd0]
1     0  1362     2  25   5      0     0 ksm_sc SN   ? 
         0:00 [ksmd]
1     0  1438     2  39  19      0     0 khugep SN   ? 
         0:00 [khugepaged]
1     0  1439     2  20   0      0     0 fsnoti S    ? 
         0:00 [fsnotify_mark]
1     0  1478     2  20   0      0     0 ecrypt S    ? 
         0:00 [ecryptfs-kthrea]
1     0  1481     2   0 -20      0     0 rescue S<   ? 
         0:00 [nfsiod]
1     0  1486     2   0 -20      0     0 rescue S<   ? 
         0:00 [cifsiod]
1     0  1511     2  20   0      0     0 jfsIOW S    ? 
         0:00 [jfsIO]
1     0  1512     2  20   0      0     0 jfs_la S    ? 
         0:00 [jfsCommit]
1     0  1513     2  20   0      0     0 jfs_sy S    ? 
         0:00 [jfsSync]
1     0  1520     2   0 -20      0     0 rescue S<   ? 
         0:00 [xfsalloc]
1     0  1521     2   0 -20      0     0 rescue S<   ? 
         0:00 [xfs_mru_cache]
1     0  1522     2   0 -20      0     0 rescue S<   ? 
         0:00 [xfslogd]
1     0  1529     2   0 -20      0     0 rescue S<   ? 
         0:00 [ocfs2_wq]
1     0  1532     2   0 -20      0     0 rescue S<   ? 
         0:00 [user_dlm]
1     0  1538     2   0 -20      0     0 rescue S<   ? 
         0:00 [glock_workqueue]
1     0  1539     2   0 -20      0     0 rescue S<   ? 
         0:00 [delete_workqueu]
1     0  1543     2   0 -20      0     0 rescue S<   ? 
         0:00 [gfs_recovery]
1     0  1547     2   0 -20      0     0 rescue S<   ? 
         0:00 [crypto]
1     0  1676     2  20   0      0     0 worker S    ? 
         0:00 [kworker/u:2]
1     0  2301     2  20   0      0     0 scan_t S    ? 
         0:00 [cciss_scan]
1     0  2430     2   0 -20      0     0 rescue S<   ? 
         0:00 [iscsi_eh]
1     0  2439     2   0 -20      0     0 rescue S<   ? 
         0:00 [kmpath_rdacd]
1     0  2440     2   0 -20      0     0 rescue S<   ? 
         0:00 [fc_exch_workque]
1     0  2441     2   0 -20      0     0 rescue S<   ? 
         0:00 [fc_rport_eq]
1     0  2442     2   0 -20      0     0 fcoe_p S<   ? 
         0:00 [fcoethread/0]
1     0  2444     2   0 -20      0     0 rescue S<   ? 
         0:00 [fnic_event_wq]
1     0  2446     2   0 -20      0     0 bnx2fc S<   ? 
         0:00 [bnx2fc_l2_threa]
1     0  2447     2   0 -20      0     0 bnx2fc S<   ? 
         0:00 [bnx2fc_thread/0]
1     0  2523     2   0 -20      0     0 bnx2i_ S<   ? 
         0:00 [bnx2i_thread/0]
1     0  2561     2  20   0      0     0 scsi_e S    ? 
         0:00 [scsi_eh_2]
1     0  2564     2  20   0      0     0 scsi_e S    ? 
         0:02 [scsi_eh_3]
1     0  2567     2  20   0      0     0 worker S    ? 
         0:00 [kworker/u:3]
1     0  2574     2  20   0      0     0 scsi_e S    ? 
         0:00 [scsi_eh_4]
1     0  2577     2  20   0      0     0 scsi_e S    ? 
         0:00 [scsi_eh_5]
1     0  2642     2   0 -20      0     0 rescue S<   ? 
         0:00 [smflush]
1     0  2657     2  20   0      0     0 mtd_bl S    ? 
         0:00 [mtdblock0]
1     0  2668     2  20   0      0     0 mtd_bl S    ? 
         0:00 [mtdblock1]
1     0  2677     2  20   0      0     0 mtd_bl S    ? 
         0:00 [mtdblock2]
1     0  2694     2   0 -20      0     0 rescue S<   ? 
         0:00 [cnic_wq]
1     0  2712     2   0 -20      0     0 rescue S<   ? 
         0:00 [exec-osm]
1     0  2719     2   0 -20      0     0 rescue S<   ? 
         0:00 [block-osm]
1     0  2727     2   0 -20      0     0 rescue S<   ? 
         0:00 [firewire]
1     0  2804     2   0 -20      0     0 rescue S<   ? 
         0:00 [wusbd]
1     0  2866     2   0 -20      0     0 rescue S<   ? 
         0:00 [kpsmoused]
1     0  2979     2   0 -20      0     0 rescue S<   ? 
         0:00 [dm_bufio_cache]
1     0  2980     2   0 -20      0     0 rescue S<   ? 
         0:00 [kmpathd]
1     0  2981     2   0 -20      0     0 rescue S<   ? 
         0:00 [kmpath_handlerd]
1     0  2984     2   0 -20      0     0 rescue S<   ? 
         0:00 [edac-poller]
1     0  2997     2   0 -20      0     0 rescue S<   ? 
         0:00 [kmemstick]
1     0  3062     2   0 -20      0     0 rescue S<   ? 
         0:00 [binder]
1     0  5328     2  30  10      0     0 kmemle SN   ? 
         4:59 [kmemleak]
1     0  5330     2   0 -20      0     0 rescue S<   ? 
         0:00 [kafs_vlupdated]
1     0  5331     2   0 -20      0     0 rescue S<   ? 
         0:00 [kafs_callbackd]
1     0  5332     2   0 -20      0     0 rescue S<   ? 
         0:00 [kafsd]
1     0  5335     2   0 -20      0     0 rescue S<   ? 
         0:00 [deferwq]
1     0  5340     2   0 -20      0     0 rescue S<   ? 
         0:00 [devfreq_wq]
1     0  5343     2  20   0      0     0 kjourn S    ? 
         0:04 [kjournald]
5     0  5371     1  16  -4   3124  1752 poll_s S<s  ? 
         0:03 /sbin/udevd --daemon
4     0  6451  9516  20   0   7292  4852 -      R    tty2 
      0:05 nepenthes
0     0  6743  9515  20   0   3056  1436 wait   S    tty1 
      0:00 sh psaxl.sh
0     0  6853  9515  20   0   7612  4540 poll_s S+   tty1 
      0:01 /usr/bin/mc -P /tmp/mc-root/mc.pwd.9515
4     0  6854  6853  20   0   1856   268 pipe_w Ss   ? 
         0:00 cons.saver /dev/vc/1
0     0  6855  6853  20   0   3424  1860 n_tty_ Ss+  pts/2 
     0:00 bash -rcfile .bashrc
1     0  7427     2   0 -20      0     0 rescue S<   ? 
         0:00 [hd-audio0]
1     0  9009     2  20   0      0     0 bdi_wr S    ? 
         0:07 [flush-8:0]
5     0  9392     2  10 -10      0     0 rfcomm S<   ? 
         0:00 [krfcommd]
4     0  9407     1  20   0   5832  2572 ep_pol Ss   ? 
         0:00 /usr/sbin/cupsd -C /etc/cups/cupsd.conf
1     0  9454     1  20   0   2096   716 hrtime S    ? 
         0:00 /usr/sbin/crond -l10
1     2  9456     1  20   0   2100   332 hrtime Ss   ? 
         0:00 /usr/sbin/atd -b 15 -l 1
1     0  9506     1  20   0   1864   308 hrtime Ss   ? 
         0:00 rkdet 1451
4     0  9515     1  20   0   3448  1960 wait   Ss   tty1 
      0:00 -bash
4     0  9516     1  20   0   3448  1956 n_tty_ Ss+  tty2 
      0:00 -bash
0     0  9517     1  20   0   1880   564 n_tty_ Ss+  tty3 
      0:00 /sbin/agetty 38400 tty3 linux
0     0  9518     1  20   0   1880   568 n_tty_ Ss+  tty4 
      0:00 /sbin/agetty 38400 tty4 linux
0     0  9519     1  20   0   1880   564 n_tty_ Ss+  tty5 
      0:00 /sbin/agetty 38400 tty5 linux
0     0  9520     1  20   0   1880   572 n_tty_ Ss+  tty6 
      0:00 /sbin/agetty 38400 tty6 linux
4     0  9521     1  20   0   3408   868 poll_s Ss   ? 
         0:00 /opt/kde/bin/kdm -nodaemon
4     0  9537  9521  20   0  46352 40028 poll_s Ss+  tty7 
      5:48 /usr/bin/X -br -nolisten tcp :0 vt7 -auth 
/var/run/xauth/A:0-Jp1H0T
1     0  9541  9521  20   0   3728  1204 wait   S    ? 
         0:00 -:0
4     0  9549  9541  20   0   3060  1500 wait   Ss   ? 
         0:00 /bin/sh /usr/bin/startkde
0     0  9567  9549  20   0  12404  1640 hrtime Sl   ? 
         0:51 /usr/bin/tpb
1     0  9603     1  20   0   1856    76 pipe_w S    ? 
         0:00 start_kdeinit --new-startup +kcminit_startup
1     0  9604     1  20   0  25160  7980 poll_s Ss   ? 
         0:00 kdeinit Running...
1     0  9607     1  20   0  24352  3216 poll_s S    ? 
         0:00 dcopserver [kdeinit] --nosid
5     0  9609  9604  20   0  29036  8488 poll_s S    ? 
         0:00 klauncher [kdeinit] --new-startup
1     0  9611     1  20   0  56232 30716 -      R    ? 
        20:40 kded [kdeinit] --new-startup
0     0  9618  9549  20   0   1860   272 hrtime S    ? 
         0:01 kwrapper ksmserver
1     0  9620     1  20   0  38748 22156 poll_s S    ? 
         0:00 ksmserver [kdeinit]
1     0  9621  9604  20   0  41744 25564 poll_s S    ? 
         0:09 kwin [kdeinit]
1     0  9623     1  20   0  47612 31632 poll_s S    ? 
         0:15 kdesktop [kdeinit]
1     0  9625     1  20   0  57588 42456 poll_s S    ? 
         0:20 kicker [kdeinit]
1     0  9632     1  20   0  38984 22176 poll_s S    ? 
         0:00 kaccess [kdeinit]
4     0  9645  9604  20   0  76292 21872 poll_s SL   ? 
         4:39 artsd -F 9 -S 4096 -a alsa -b 8 -s 333 -m 
artsmessage -c drkonqi -l 3 -f
1     0  9649     1  20   0  26708  8828 poll_s S    ? 
         0:00 kalarmd --autostart
0     0  9650  9604  20   0  22340 10500 poll_s S    ? 
         0:00 nm-applet --sm-disable
1     0  9651     1  20   0  50312 25620 poll_s S    ? 
         0:01 knotify [kdeinit]
1     0  9671     1  20   0   3492   612 poll_s S    ? 
         0:00 dbus-launch --autolaunch 
9b9f86fbd8163bb39486a000475487ec --binary-syntax 
--close-stderr
1     0  9672     1  20   0   2520   748 poll_s Ss   ? 
         0:00 /usr/bin/dbus-daemon --fork --print-pid 5 
--print-address 7 --session
0     0  9686     1  20   0  17196  4944 poll_s S    ? 
         0:00 /usr/libexec/xfce4-notifyd
0     0  9688     1  20   0   4008  1788 poll_s S    ? 
         0:00 /usr/libexec/xfconfd
0     0 11010     1  20   0   3072  1520 wait   S    ? 
         0:00 /bin/sh /usr/bin/mysqld_safe --user=root
4     0 11053 11010  20   0 102952 20932 poll_s Sl   ? 
         0:05 /usr/sbin/mysqld --basedir=/ --datadir=//var 
--user=root --pid-file=//var/werner.pid 
--log-error=//var/werner.err
5     0 11084     1  20   0   6904  2108 poll_s Ss   ? 
         0:01 sendmail: accepting connections
1     0 11085     1  20   0   6292  2772 poll_s S    ? 
         0:00 /usr/local/src/Unreal3.2/src/ircd
1     0 11093     1  20   0  53056  8864 poll_s Ss   ? 
         0:00 /usr/local/apache2/bin/httpd -k restart
5     0 11110     1  20   0   5900   828 poll_s Ss   ? 
         0:00 pure-ftpd (SERVER)
5     0 11124     1  20   0   3428   608 poll_s Ss   ? 
         0:00 rsync -v --daemon
1     0 11134     1  20   0   7608  5040 poll_s Ss   ? 
         0:00 /usr/local/bin/perl 
/usr/local/src/webmin/miniserv.pl 
/etc/webmin/miniserv.conf
1     0 11147     1  20   0   7196  5124 poll_s Ss   ? 
         0:00 /usr/local/bin/perl 
/usr/local/src/usermin/miniserv.pl 
/etc/usermin/miniserv.conf
1     0 11711     1  20   0  40496 25208 poll_s S    ? 
         0:00 kio_uiserver [kdeinit]
5     0 14181  9604  20   0  57952 40024 poll_s S    ? 
         0:02 konqueror [kdeinit] /
1     0 20523     2  20   0      0     0 worker S    ? 
         0:00 [kworker/0:2]
5     0 21323  9604  20   0  63340 45076 poll_s S    ? 
         0:06 konqueror [kdeinit] /
4     0 23472  9604  20   0 326076 97096 poll_s Sl   ? 
         0:04 /usr/lib/firefox/firefox-bin
1     0 26090     2  20   0      0     0 worker S    ? 
         0:00 [kworker/0:0]
1     0 26177  9604  20   0  25644  7412 poll_s S    ? 
         0:00 kio_file [kdeinit] file 
/tmp/ksocket-root/klaunchers4Ewqb.
0     0 26279  9604  20   0  90244 58724 poll_s S    ? 
         1:50 kpdf /FULA-KURS/manual-1.pdf -icon kpdf 
-caption KPDF
1     0 27679     2  20   0      0     0 -      S    ? 
         0:00 [kworker/0:1]
5     2 28475 11093  20   0      0     0 exit   Z    ? 
         0:00 [httpd] <defunct>
5     2 28484 11093  20   0      0     0 exit   Z    ? 
         0:00 [httpd] <defunct>
5     2 28485 11093  20   0      0     0 exit   Z    ? 
         0:00 [httpd] <defunct>
5     2 28491 11093  20   0      0     0 exit   Z    ? 
         0:00 [httpd] <defunct>
5     2 28492 11093  20   0      0     0 exit   Z    ? 
         0:00 [httpd] <defunct>
5     2 28493 11093  20   0      0     0 exit   Z    ? 
         0:00 [httpd] <defunct>
5     2 28494 11093  20   0      0     0 exit   Z    ? 
         0:00 [httpd] <defunct>
0     0 28550  6743  20   0   2528   584 -      R    tty1 
      0:00 ps axl
4     0 28551  9611  20   0      0     0 exit   Z    ? 
         0:00 [ifconfig] <defunct>
---
Professional hosting for everyone - http://www.host.ru

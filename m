Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477Ab1KGU0l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 15:26:41 -0500
Received: from smtp111.iad.emailsrvr.com ([207.97.245.111]:36339 "EHLO
	smtp111.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634Ab1KGU0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 15:26:39 -0500
X-Greylist: delayed 435 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Nov 2011 15:26:39 EST
Message-ID: <4EB83D4A.4010408@iwl.com>
Date: Mon, 07 Nov 2011 12:19:22 -0800
From: Karl Auerbach <karl@iwl.com>
Reply-To: karl@iwl.com
Organization: InterWorking Labs
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110928 Fedora/3.1.15-1.fc14 Thunderbird/3.1.15
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Kernel (3.0 and later) panic
X-Enigmail-Version: 1.1.2
Content-Type: multipart/mixed;
 boundary="------------070505030904030500000309"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070505030904030500000309
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Versions 3.0 and later of the Linux kernel get a null pointer panic when
booting on a Soekris Net6501 board.

The documentation for that board is at:

  http://soekris.com/media/manuals/net6501_manual.pdf

(It's an Intel Atom based board.)

The panic does not occur with kernel 2.6.39.4, so it appears that
something added in the 2.6.39.4 ==> 3.0 transition is causing this.

Attached is a dmesg showing the panic.

This occurs 100% of the time.

Please let me know if you need the .config used to build the kernel.

	--karl--
	Karl Auerbach
	InterWorking Labs
	Scotts Valley, California

--------------070505030904030500000309
Content-Type: text/plain;
 name="a"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="a"

SYSLINUX 4.02 2010-07-21 EDD Copyright (C) 1994-2010 H. Peter Anvin et al
boot: 
Loading /linux.....
Loading /initrd.gz.....ready.
Linux version 3.0.4-NET6501 (karl@v-f10-x64.cavebear.com) (gcc version 4.3.2 20081105 (Red Hat 4.3.2-7) (GCC) ) #1 SMP Fri Oct 28 17:34:58 PDT 2011
KERNEL supported cpus:
  Intel GenuineIntel
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009e000 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 00000000000f0000 (reserved)
 BIOS-e820: 0000000000100000 - 0000000040000000 (usable)
 BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
DMI not present or invalid.
last_pfn = 0x40000 max_arch_pfn = 0x100000
found SMP MP-table at [c00fe100] fe100
init_memory_mapping: 0000000000000000-00000000377fe000
RAMDISK: 3fd05000 - 3ffff000
Allocated new RAMDISK: 37504000 - 377fdb6e
Move RAMDISK from 000000003fd05000 - 000000003fffeb6d to 37504000 - 377fdb6d
ACPI Error: A valid RSDP was not found (20110413/tbxfroot-219)
136MB HIGHMEM available.
887MB LOWMEM available.
  mapped low ram: 0 - 377fe000
  low ram: 0 - 377fe000
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  Normal   0x00001000 -> 0x000377fe
  HighMem  0x000377fe -> 0x00040000
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000010 -> 0x0000009e
    0: 0x00000100 -> 0x00040000
Using APIC driver default
Intel MultiProcessor Specification v1.4
    Virtual Wire compatibility mode.
MPTABLE: OEM ID: Soekris 
MPTABLE: Product ID: net6501     
MPTABLE: APIC at: 0xFEE00000
Processor #0 (Bootup-CPU)
Processor #1
IOAPIC[0]: apic_id 0, version 32, address 0xfec00000, GSI 0-23
Processors: 2
SMP: Allowing 2 CPUs, 0 hotplug CPUs
Allocating PCI resources starting at 40000000 (gap: 40000000:bec00000)
setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_node_ids:1
PERCPU: Embedded 11 pages/cpu @f6800000 s21952 r0 d23104 u2097152
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 259981
Kernel command line: console=ttyS0,19200 root=/dev/sda2 ramdisk_size=16384 initrd=/initrd.gz rw BOOT_IMAGE=/linux 
PID hash table entries: 4096 (order: 2, 16384 bytes)
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Initializing CPU#0
Initializing HighMem for node 0 (000377fe:00040000)
Memory: 1030808k/1048576k available (3526k kernel code, 17312k reserved, 1117k data, 284k init, 139272k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff16000 - 0xfffff000   ( 932 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
    lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
      .init : 0xc0589000 - 0xc05d0000   ( 284 kB)
      .data : 0xc047197c - 0xc0588f80   (1117 kB)
      .text : 0xc0100000 - 0xc047197c   (3526 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
Hierarchical RCU implementation.
NR_IRQS:512
Console: colour dummy device 80x25
console [ttyS0] enabled
Fast TSC calibration using PIT
Detected 1000.013 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 2000.02 BogoMIPS (lpj=1000013)
pid_max: default: 32768 minimum: 301
Mount-cache hash table entries: 512
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
using mwait in idle threads.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Genuine Intel(R) CPU        @ 1.00GHz stepping 01
Performance Events: PEBS fmt0+, generic architected perfmon, Intel PMU driver.
... version:                3
... bit width:              40
... generic registers:      2
... value mask:             000000ffffffffff
... max period:             000000007fffffff
... fixed-purpose events:   3
... event mask:             0000000700000003
Booting Node   0, Processors  #1 Ok.
Initializing CPU#1
Disabled fast string operations
Brought up 2 CPUs
Total of 2 processors activated (3999.75 BogoMIPS).
NET: Registered protocol family 16
PCI: PCI BIOS revision 2.01 entry at 0xfac61, last bus=13
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: Interpreter disabled.
vgaarb: loaded
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Probing PCI hardware
pci 0000:00:17.0: PCI bridge to [bus 01-02]
pci 0000:01:00.0: PCI bridge to [bus 02-02]
pci 0000:00:18.0: PCI bridge to [bus 03-07]
pci 0000:03:00.0: PCI bridge to [bus 04-07]
pci 0000:04:02.0: PCI bridge to [bus 05-05]
pci 0000:04:03.0: PCI bridge to [bus 06-06]
pci 0000:04:04.0: PCI bridge to [bus 07-07]
pci 0000:00:19.0: PCI bridge to [bus 08-0c]
pci 0000:08:00.0: PCI bridge to [bus 09-0c]
pci 0000:09:02.0: PCI bridge to [bus 0a-0a]
pci 0000:09:03.0: PCI bridge to [bus 0b-0b]
pci 0000:09:04.0: PCI bridge to [bus 0c-0c]
pci 0000:00:1a.0: PCI bridge to [bus 0d-0d]
pci 0000:00:1f.0: default IRQ router [8086:8186]
pnp: PnP ACPI: disabled
pci 0000:02:00.0: no compatible bridge window for [mem 0x98000000-0x9801ffff pref]
pci 0000:02:06.0: no compatible bridge window for [mem 0x98000000-0x9801ffff pref]
pci 0000:00:17.0: BAR 9: assigned [mem 0x40000000-0x401fffff pref]
pci 0000:01:00.0: BAR 9: assigned [mem 0x40000000-0x400fffff pref]
pci 0000:01:00.0: BAR 6: assigned [mem 0x40100000-0x4010ffff pref]
pci 0000:02:00.0: BAR 6: assigned [mem 0x40000000-0x4001ffff pref]
pci 0000:02:06.0: BAR 6: assigned [mem 0x40020000-0x4003ffff pref]
pci 0000:01:00.0: PCI bridge to [bus 02-02]
pci 0000:01:00.0:   bridge window [io  0x1000-0x1fff]
pci 0000:01:00.0:   bridge window [mem 0xa0000000-0xa0ffffff]
pci 0000:01:00.0:   bridge window [mem 0x40000000-0x400fffff pref]
pci 0000:00:17.0: PCI bridge to [bus 01-02]
pci 0000:00:17.0:   bridge window [io  0x1000-0x1fff]
pci 0000:00:17.0:   bridge window [mem 0xa0000000-0xa0ffffff]
pci 0000:00:17.0:   bridge window [mem 0x40000000-0x401fffff pref]
pci 0000:04:02.0: PCI bridge to [bus 05-05]
pci 0000:04:02.0:   bridge window [io  0x2000-0x2fff]
pci 0000:04:02.0:   bridge window [mem 0xa1000000-0xa1ffffff]
pci 0000:04:02.0:   bridge window [mem pref disabled]
pci 0000:04:03.0: PCI bridge to [bus 06-06]
pci 0000:04:03.0:   bridge window [io  0x3000-0x3fff]
pci 0000:04:03.0:   bridge window [mem 0xa2000000-0xa2ffffff]
pci 0000:04:03.0:   bridge window [mem pref disabled]
pci 0000:04:04.0: PCI bridge to [bus 07-07]
pci 0000:04:04.0:   bridge window [io  disabled]
pci 0000:04:04.0:   bridge window [mem disabled]
pci 0000:04:04.0:   bridge window [mem pref disabled]
pci 0000:03:00.0: PCI bridge to [bus 04-07]
pci 0000:03:00.0:   bridge window [io  0x2000-0x3fff]
pci 0000:03:00.0:   bridge window [mem 0xa1000000-0xa2ffffff]
pci 0000:03:00.0:   bridge window [mem pref disabled]
pci 0000:00:18.0: PCI bridge to [bus 03-07]
pci 0000:00:18.0:   bridge window [io  0x2000-0x3fff]
pci 0000:00:18.0:   bridge window [mem 0xa1000000-0xa2ffffff]
pci 0000:00:18.0:   bridge window [mem pref disabled]
pci 0000:09:02.0: PCI bridge to [bus 0a-0a]
pci 0000:09:02.0:   bridge window [io  0x4000-0x4fff]
pci 0000:09:02.0:   bridge window [mem 0xa3000000-0xa3ffffff]
pci 0000:09:02.0:   bridge window [mem pref disabled]
pci 0000:09:03.0: PCI bridge to [bus 0b-0b]
pci 0000:09:03.0:   bridge window [io  0x5000-0x5fff]
pci 0000:09:03.0:   bridge window [mem 0xa4000000-0xa4ffffff]
pci 0000:09:03.0:   bridge window [mem pref disabled]
pci 0000:09:04.0: PCI bridge to [bus 0c-0c]
pci 0000:09:04.0:   bridge window [io  disabled]
pci 0000:09:04.0:   bridge window [mem disabled]
pci 0000:09:04.0:   bridge window [mem pref disabled]
pci 0000:08:00.0: PCI bridge to [bus 09-0c]
pci 0000:08:00.0:   bridge window [io  0x4000-0x5fff]
pci 0000:08:00.0:   bridge window [mem 0xa3000000-0xa4ffffff]
pci 0000:08:00.0:   bridge window [mem pref disabled]
pci 0000:00:19.0: PCI bridge to [bus 08-0c]
pci 0000:00:19.0:   bridge window [io  0x4000-0x5fff]
pci 0000:00:19.0:   bridge window [mem 0xa3000000-0xa4ffffff]
pci 0000:00:19.0:   bridge window [mem pref disabled]
pci 0000:00:1a.0: PCI bridge to [bus 0d-0d]
pci 0000:00:1a.0:   bridge window [io  disabled]
pci 0000:00:1a.0:   bridge window [mem disabled]
pci 0000:00:1a.0:   bridge window [mem pref disabled]
pci 0000:00:17.0: PCI->APIC IRQ transform: INT A -> IRQ 16
pci 0000:01:00.0: using bridge 0000:00:17.0 INT A to get IRQ 16
pci 0000:01:00.0: PCI->APIC IRQ transform: INT A -> IRQ 16
pci 0000:00:18.0: PCI->APIC IRQ transform: INT A -> IRQ 17
pci 0000:00:19.0: PCI->APIC IRQ transform: INT A -> IRQ 18
pci 0000:00:1a.0: PCI->APIC IRQ transform: INT A -> IRQ 19
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
UDP hash table entries: 512 (order: 2, 16384 bytes)
UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
NET: Registered protocol family 1
RPC: Registered named UNIX socket transport module.
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
Trying to unpack rootfs image as initramfs...
rootfs image is not initramfs (no cpio magic); looks like an initrd
Freeing initrd memory: 3048k freed
platform rtc_cmos: registered platform RTC device (no PNP device found)
highmem bounce pool size: 64 pages
ROMFS MTD (C) 2007 Red Hat, Inc.
msgmni has been set to 1747
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
Serial: 8250/16550 driver, 2 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a TI16750
pci 0000:01:00.0: using bridge 0000:00:17.0 INT D to get IRQ 19
serial 0000:02:0a.1: PCI->APIC IRQ transform: INT D -> IRQ 19
BUG: unable to handle kernel NULL pointer dereference at   (null)
IP: [<  (null)>]   (null)
*pde = 00000000 
Oops: 0000 [#1] SMP 
Modules linked in:

Pid: 1, comm: swapper Not tainted 3.0.4-NET6501 #1  
EIP: 0060:[<00000000>] EFLAGS: 00010286 CPU: 1
EIP is at 0x0
EAX: f675ae80 EBX: c0584034 ECX: f643bdd0 EDX: f643bea4
ESI: 00000000 EDI: f6505800 EBP: f643bdd0 ESP: f643bdb0
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process swapper (pid: 1, ti=f643a000 task=f6439bc0 task.ti=f643a000)
Stack:
 c02ffe94 00000000 f6505800 f6505800 f675ae80 f643bea4 f6505800 00000001
 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000013
 00000000 001c2000 00000000 00000000 00000000 00000000 00000000 00000000
Call Trace:
 [<c02ffe94>] ? pciserial_init_ports+0x144/0x1d0
 [<c04630be>] ? pciserial_init_one+0x89/0x1bb
 [<c01e3f30>] ? sysfs_do_create_link+0xb0/0x1b0
 [<c02aebbb>] ? local_pci_probe+0xb/0x10
 [<c02aedb1>] ? pci_device_probe+0x61/0x80
 [<c03081b5>] ? driver_probe_device+0x75/0x190
 [<c0308351>] ? __driver_attach+0x81/0x90
 [<c02aecf0>] ? pci_dev_put+0x20/0x20
 [<c0307aa4>] ? bus_for_each_dev+0x54/0x80
 [<c02aecf0>] ? pci_dev_put+0x20/0x20
 [<c0308046>] ? driver_attach+0x16/0x20
 [<c03082d0>] ? driver_probe_device+0x190/0x190
 [<c030742f>] ? bus_add_driver+0x17f/0x240
 [<c02aecf0>] ? pci_dev_put+0x20/0x20
 [<c03086a7>] ? driver_register+0x67/0x150
 [<c02dbdd0>] ? pnp_device_detach+0x30/0x30
Switching to clocksource tsc
 [<c05a75e5>] ? serial8250_pnp_init+0xa/0xa
 [<c02aefdd>] ? __pci_register_driver+0x3d/0xb0
 [<c010102b>] ? do_one_initcall+0x2b/0x150
 [<c05891c8>] ? parse_early_options+0x24/0x24
 [<c0160337>] ? init_irq_proc+0x67/0x80
 [<c05891c8>] ? parse_early_options+0x24/0x24
 [<c0589265>] ? kernel_init+0x9d/0x135
 [<c0470db6>] ? kernel_thread_helper+0x6/0xd
Code:  Bad EIP value.
EIP: [<00000000>] 0x0 SS:ESP 0068:f643bdb0
CR2: 0000000000000000
---[ end trace 93d72a36b9146f22 ]---
Kernel panic - not syncing: Attempted to kill init!

--------------070505030904030500000309--

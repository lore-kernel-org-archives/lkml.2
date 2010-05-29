Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751147Ab0E2EaP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 00:30:15 -0400
Received: from pindarots.xs4all.nl ([80.101.128.228]:50446 "EHLO
	pindarots.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722Ab0E2EaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 00:30:08 -0400
Message-ID: <4C009845.3040404@xs4all.nl>
Date: Sat, 29 May 2010 06:29:57 +0200
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: hpet timers gone?
References: <4BFA52C3.4080006@xs4all.nl> <20100526120236.4a849b5b.randy.dunlap@oracle.com>
In-Reply-To: <20100526120236.4a849b5b.randy.dunlap@oracle.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-05-26 21:02, Randy Dunlap wrote:
> On Mon, 24 May 2010 12:19:47 +0200 Udo van den Heuvel wrote:
>> What has happened between 2.6.30.9 and 2.6.32.8 with regard to hpet timers?
>>
>> dmesg output from 2.6.30.9 does show activity but 2.6.32.8 and beyond don't.
>> Also /proc/timer_list doesn't show hpet anymore. Also on 2.6.34 no hpet
>> in timer_list.
>>
>> relevant .config:
>> CONFIG_HPET_TIMER=y
>> CONFIG_HPET_EMULATE_RTC=y
>> CONFIG_HPET=y
>> CONFIG_HPET_MMAP=y
> 
> Same here.
> 
>> And I have hpet=force on the kernel commandline for this VIA Epia
>> LT10000 board.
>>
>> Any ideas?
(...)
> 
> What does dmesg show on your machine?

Please see below.
The LT10000 replaced a VIA Epia EK8000 where hpet did work.
LT10000 has VIA CX700 chips.

Udo

Linux version 2.6.34 (root@epia) (gcc version 4.4.3 20100127 (Red Hat
4.4.3-4) (GCC) ) #6 PREEMPT Tue May 25 16:08:30 CEST 2010
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003bfb0000 (usable)
 BIOS-e820: 000000003bfb0000 - 000000003bfbe000 (ACPI data)
 BIOS-e820: 000000003bfbe000 - 000000003bff0000 (ACPI NVS)
 BIOS-e820: 000000003bff0000 - 000000003c000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ff780000 - 0000000100000000 (reserved)
Notice: NX (Execute Disable) protection missing in CPU or disabled in BIOS!
DMI 2.3 present.
AMI BIOS detected: BIOS may corrupt low RAM, working around it.
e820 update range: 0000000000000000 - 0000000000010000 (usable) ==>
(reserved)
e820 update range: 0000000000000000 - 0000000000001000 (usable) ==>
(reserved)
e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
last_pfn = 0x3bfb0 max_arch_pfn = 0x100000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-DFFFF uncachable
  E0000-EFFFF write-through
  F0000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 000000000 mask FC0000000 write-back
  1 base 03C000000 mask FFC000000 uncachable
  2 disabled
  3 disabled
  4 disabled
  5 disabled
  6 disabled
  7 disabled
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
original variable MTRRs
reg 0, base: 0GB, range: 1GB, type WB
reg 1, base: 960MB, range: 64MB, type UC
total RAM covered: 960M
Found optimal setting for mtrr clean up
 gran_size: 64K 	chunk_size: 128M 	num_reg: 2  	lose cover RAM: 0G
New variable MTRRs
reg 0, base: 0GB, range: 1GB, type WB
reg 1, base: 960MB, range: 64MB, type UC
initial memory mapped : 0 - 01c00000
found SMP MP-table at [c00ff780] ff780
init_memory_mapping: 0000000000000000-00000000377fe000
 0000000000 - 0000400000 page 4k
 0000400000 - 0037400000 page 2M
 0037400000 - 00377fe000 page 4k
kernel direct mapping tables up to 377fe000 @ 14000-19000
RAMDISK: 379be000 - 37ff0000
Allocated new RAMDISK: 00100000 - 007310d9
Move RAMDISK from 00000000379be000 - 0000000037fef0d8 to 00100000 - 007310d8
ACPI: RSDP 000f7ee0 00024 (v02 ACPIAM)
ACPI: XSDT 3bfb0100 00044 (v01 A M I  OEMXSDT  12000705 MSFT 00000097)
ACPI: FACP 3bfb0290 000F4 (v03 A M I  OEMFACP  12000705 MSFT 00000097)
ACPI: DSDT 3bfb03f0 034F7 (v01  1ADEL 1ADEL007 00000007 INTL 02002026)
ACPI: FACS 3bfbe000 00040
ACPI: APIC 3bfb0390 00054 (v01 A M I  OEMAPIC  12000705 MSFT 00000097)
ACPI: OEMB 3bfbe040 00046 (v01 A M I  AMI_OEM  12000705 MSFT 00000097)
ACPI: SSDT 3bfbe090 00175 (v01    AMI   P001PM 00000001 INTL 20051117)
ACPI: Local APIC address 0xfee00000
71MB HIGHMEM available.
887MB LOWMEM available.
  mapped low ram: 0 - 377fe000
  low ram: 0 - 377fe000
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  Normal   0x00001000 -> 0x000377fe
  HighMem  0x000377fe -> 0x0003bfb0
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000010 -> 0x0000009f
    0: 0x00000100 -> 0x0003bfb0
On node 0 totalpages: 245567
free_area_init_node: node 0, pgdat c13e6c94, node_mem_map c186f200
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 3951 pages, LIFO batch:0
  Normal zone: 1744 pages used for memmap
  Normal zone: 221486 pages, LIFO batch:31
  HighMem zone: 144 pages used for memmap
  HighMem zone: 18210 pages, LIFO batch:3
Using APIC driver default
ACPI: PM-Timer IO Port: 0x808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 3, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
nr_irqs_gsi: 24
early_res array is doubled to 64 at [15000 - 157ff]
Allocating PCI resources starting at 3c000000 (gap: 3c000000:c2c00000)
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 243647
Kernel command line: ro root=LABEL=/ hisax=36,2 selinux=0
pci=usepirqmask audit=0 hpet=force usbcore.autosuspend=1
SYSFONT=latarcyrheb-sun16 LANG=en_US.UTF-8 KEYTABLE=us
acpi_enforce_resources=lax
audit: disabled (until reboot)
PID hash table entries: 4096 (order: 2, 16384 bytes)
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
Subtract (36 early reservations)
  #1 [0001000000 - 00018651c8]   TEXT DATA BSS
  #2 [0001866000 - 000186d1c1]             BRK
  #3 [00000ff790 - 0000100000]   BIOS reserved
  #4 [00000ff780 - 00000ff790]    MP-table mpf
  #5 [000009fc00 - 00000fc6a0]   BIOS reserved
  #6 [00000fc7c8 - 00000ff780]   BIOS reserved
  #7 [00000fc6a0 - 00000fc7c8]    MP-table mpc
  #8 [0000010000 - 0000014000]     ACPI WAKEUP
  #9 [0000014000 - 0000015000]         PGTABLE
  #10 [0000100000 - 0000732000]     NEW RAMDISK
  #11 [000186e000 - 000186f000]         BOOTMEM
  #12 [000186f000 - 0001fef000]         BOOTMEM
  #13 [0001865200 - 0001865204]         BOOTMEM
  #14 [0001865240 - 0001865480]         BOOTMEM
  #15 [0001865480 - 00018654d4]         BOOTMEM
  #16 [0001fef000 - 0001ff8000]         BOOTMEM
  #17 [0001865500 - 0001865508]         BOOTMEM
  #18 [0001ff8000 - 0001ff9200]         BOOTMEM
  #19 [0001865540 - 0001865567]         BOOTMEM
  #20 [0001865580 - 00018656b4]         BOOTMEM
  #21 [00018656c0 - 0001865700]         BOOTMEM
  #22 [0001865700 - 0001865740]         BOOTMEM
  #23 [0001865740 - 0001865780]         BOOTMEM
  #24 [0001865780 - 00018657c0]         BOOTMEM
  #25 [00018657c0 - 0001865800]         BOOTMEM
  #26 [0001865800 - 0001865840]         BOOTMEM
  #27 [0001865840 - 0001865880]         BOOTMEM
  #28 [0001865880 - 00018658c0]         BOOTMEM
  #29 [00018658c0 - 0001865900]         BOOTMEM
  #30 [0001865900 - 0001865940]         BOOTMEM
  #31 [0001865940 - 00018659f0]         BOOTMEM
  #32 [0001865a00 - 0001865ab0]         BOOTMEM
  #33 [0001ff9200 - 0001ffd200]         BOOTMEM
  #34 [0001ffd200 - 000207d200]         BOOTMEM
  #35 [000207d200 - 00020bd200]         BOOTMEM
Initializing HighMem for node 0 (000377fe:0003bfb0)
Memory: 958760k/982720k available (2515k kernel code, 23508k reserved,
1495k data, 328k init, 73416k highmem)
virtual kernel memory layout:
    fixmap  : 0xfffa4000 - 0xfffff000   ( 364 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
    lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
      .init : 0xc13eb000 - 0xc143d000   ( 328 kB)
      .data : 0xc1274df7 - 0xc13eac9c   (1495 kB)
      .text : 0xc1000000 - 0xc1274df7   (2515 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
Experimental preemptable hierarchical RCU implementation.
NR_IRQS:288
Extended CMOS year: 2000
Console: colour VGA+ 80x25
console [tty0] enabled
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:  8
... MAX_LOCK_DEPTH:          48
... MAX_LOCKDEP_KEYS:        8191
... CLASSHASH_SIZE:          4096
... MAX_LOCKDEP_ENTRIES:     16384
... MAX_LOCKDEP_CHAINS:      32768
... CHAINHASH_SIZE:          16384
 memory used by lock dependency info: 3551 kB
 per task-struct memory footprint: 1152 bytes
Fast TSC calibration using PIT
Detected 997.437 MHz processor.
Calibrating delay loop (skipped), value calculated using timer
frequency.. 1994.87 BogoMIPS (lpj=3989748)
Security Framework initialized
SELinux:  Disabled at boot.
Mount-cache hash table entries: 512
Performance Events:
CPU: Centaur VIA Esther processor 1000MHz stepping 09
Checking 'hlt' instruction... OK.
ACPI: Core revision 20100121
Enabling APIC mode:  Flat.  Using 1 I/O APICs
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=3
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: EC: Look up EC in DSDT
ACPI: Executed 1 blocks of module-level executable AML code
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI Warning: Incorrect checksum in table [OEMB] - E7, should be 20
(20100121/tbutils-314)
ACPI: No dock devices found.
PCI: Ignoring host bridge windows from ACPI; if necessary, use
"pci=use_crs" and report a bug
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
(ignored)
pci_root PNP0A03:00: host bridge window [mem 0x000d0000-0x000dffff]
(ignored)
pci_root PNP0A03:00: host bridge window [mem 0x3c000000-0xffffffff]
(ignored)
pci 0000:00:00.0: reg 10: [mem 0xe0000000-0xefffffff pref]
pci 0000:00:01.0: supports D1
pci 0000:00:0f.0: reg 20: [io  0xfc00-0xfc0f]
pci 0000:00:10.0: reg 20: [io  0xec00-0xec1f]
pci 0000:00:10.0: supports D1 D2
pci 0000:00:10.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:10.0: PME# disabled
pci 0000:00:10.1: reg 20: [io  0xe880-0xe89f]
pci 0000:00:10.1: supports D1 D2
pci 0000:00:10.1: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:10.1: PME# disabled
pci 0000:00:10.2: reg 20: [io  0xe800-0xe81f]
pci 0000:00:10.2: supports D1 D2
pci 0000:00:10.2: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:10.2: PME# disabled
pci 0000:00:10.4: reg 10: [mem 0xfebffc00-0xfebffcff]
pci 0000:00:10.4: supports D1 D2
pci 0000:00:10.4: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:10.4: PME# disabled
pci 0000:01:00.0: reg 10: [mem 0xa0000000-0xbfffffff pref]
pci 0000:01:00.0: reg 14: [mem 0xfd000000-0xfdffffff]
pci 0000:01:00.0: reg 30: [mem 0xfe8f0000-0xfe8fffff pref]
pci 0000:01:00.0: supports D1 D2
pci 0000:00:01.0: PCI bridge to [bus 01-01]
pci 0000:00:01.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:01.0:   bridge window [mem 0xfc800000-0xfe8fffff]
pci 0000:00:01.0:   bridge window [mem 0x9ff00000-0xdfefffff pref]
pci 0000:02:01.0: reg 10: [mem 0xfe9fc000-0xfe9fffff 64bit]
pci 0000:02:01.0: PME# supported from D0 D3hot D3cold
pci 0000:02:01.0: PME# disabled
pci 0000:00:13.0: PCI bridge to [bus 02-02]
pci 0000:00:13.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:13.0:   bridge window [mem 0xfe900000-0xfe9fffff]
pci 0000:00:13.0:   bridge window [mem 0xfff00000-0x000fffff pref]
(disabled)
pci 0000:03:08.0: reg 10: [io  0xd800-0xd8ff]
pci 0000:03:08.0: reg 14: [mem 0xfeaffc00-0xfeaffcff]
pci 0000:03:08.0: supports D1 D2
pci 0000:03:08.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:03:08.0: PME# disabled
pci 0000:03:09.0: reg 10: [io  0xd400-0xd4ff]
pci 0000:03:09.0: reg 14: [mem 0xfeaff800-0xfeaff8ff]
pci 0000:03:09.0: supports D1 D2
pci 0000:03:09.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:03:09.0: PME# disabled
pci 0000:03:0f.0: reg 10: [mem 0xfeafe000-0xfeafefff]
pci 0000:03:0f.0: reg 14: [io  0xd000-0xd0ff]
pci 0000:00:13.1: PCI bridge to [bus 03-03] (subtractive decode)
pci 0000:00:13.1:   bridge window [io  0xd000-0xdfff]
pci 0000:00:13.1:   bridge window [mem 0xfea00000-0xfeafffff]
pci 0000:00:13.1:   bridge window [mem 0xfff00000-0x000fffff pref]
(disabled)
pci 0000:00:13.1:   bridge window [io  0x0000-0xffff] (subtractive decode)
pci 0000:00:13.1:   bridge window [mem 0x00000000-0xffffffff]
(subtractive decode)
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P3._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 *6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0,
disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *0,
disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 14 15) *0,
disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 11 12 14 15) *0,
disabled.
vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
LinuxPPS API ver. 1 registered
Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti
<giometti@linux.it>
PCI: Using ACPI for IRQ routing
PCI: pci_cache_line_size set to 64 bytes
reserve RAM buffer: 000000000009fc00 - 000000000009ffff
reserve RAM buffer: 000000003bfb0000 - 000000003bffffff
Switching to clocksource tsc
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp 00:06: IRQ 4 override to edge, high
pnp 00:07: IRQ 3 override to edge, high
pnp 00:08: IRQ 3 override to edge, high
pnp 00:09: IRQ 3 override to edge, high
pnp: PnP ACPI: found 15 devices
ACPI: ACPI bus type pnp unregistered
system 00:0b: [io  0x0a00-0x0a7f] has been reserved
system 00:0c: [io  0x03e0-0x03e7] has been reserved
system 00:0c: [io  0x04d0-0x04d1] has been reserved
system 00:0c: [io  0x0800-0x087f] has been reserved
system 00:0c: [io  0x0400-0x041f] has been reserved
system 00:0d: [mem 0xfec00000-0xfec00fff] could not be reserved
system 00:0d: [mem 0xfee00000-0xfee00fff] has been reserved
system 00:0e: [mem 0x00000000-0x0009ffff] could not be reserved
system 00:0e: [mem 0x000c0000-0x000cffff] could not be reserved
system 00:0e: [mem 0x000e0000-0x000fffff] could not be reserved
system 00:0e: [mem 0x00100000-0x3bffffff] could not be reserved
pci 0000:00:01.0: PCI bridge to [bus 01-01]
pci 0000:00:01.0:   bridge window [io  disabled]
pci 0000:00:01.0:   bridge window [mem 0xfc800000-0xfe8fffff]
pci 0000:00:01.0:   bridge window [mem 0x9ff00000-0xdfefffff pref]
pci 0000:00:13.0: PCI bridge to [bus 02-02]
pci 0000:00:13.0:   bridge window [io  disabled]
pci 0000:00:13.0:   bridge window [mem 0xfe900000-0xfe9fffff]
pci 0000:00:13.0:   bridge window [mem pref disabled]
pci 0000:00:13.1: PCI bridge to [bus 03-03]
pci 0000:00:13.1:   bridge window [io  0xd000-0xdfff]
pci 0000:00:13.1:   bridge window [mem 0xfea00000-0xfeafffff]
pci 0000:00:13.1:   bridge window [mem pref disabled]
pci 0000:00:01.0: setting latency timer to 64
pci 0000:00:13.0: setting latency timer to 64
pci 0000:00:13.1: setting latency timer to 64
pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffff]
pci_bus 0000:01: resource 1 [mem 0xfc800000-0xfe8fffff]
pci_bus 0000:01: resource 2 [mem 0x9ff00000-0xdfefffff pref]
pci_bus 0000:02: resource 1 [mem 0xfe900000-0xfe9fffff]
pci_bus 0000:03: resource 0 [io  0xd000-0xdfff]
pci_bus 0000:03: resource 1 [mem 0xfea00000-0xfeafffff]
pci_bus 0000:03: resource 4 [io  0x0000-0xffff]
pci_bus 0000:03: resource 5 [mem 0x00000000-0xffffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 9, 2097152 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
UDP hash table entries: 512 (order: 3, 40960 bytes)
UDP-Lite hash table entries: 512 (order: 3, 40960 bytes)
NET: Registered protocol family 1
pci 0000:00:01.0: disabling DAC on VIA PCI bridge
pci 0000:00:10.0: uhci_check_and_reset_hc: legsup = 0x8030
pci 0000:00:10.0: Performing full reset
pci 0000:00:10.1: uhci_check_and_reset_hc: legsup = 0x8030
pci 0000:00:10.1: Performing full reset
pci 0000:00:10.2: uhci_check_and_reset_hc: legsup = 0x8030
pci 0000:00:10.2: Performing full reset
pci 0000:01:00.0: Boot video device
PCI: CLS 32 bytes, default 64
Trying to unpack rootfs image as initramfs...
Freeing initrd memory: 6344k freed
highmem bounce pool size: 64 pages
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
msgmni has been set to 1741
alg: No test for stdrng (krng)
io scheduler noop registered
io scheduler cfq registered (default)
input: Sleep Button as
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input0
ACPI: Sleep Button [SLPB]
input: Power Button as
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input1
ACPI: Power Button [PWRB]
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
ACPI: Power Button [PWRF]
Real Time Clock Driver v1.12b
VIA RNG detected
Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:07: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:08: ttyS2 at I/O 0xa80 (irq = 3) is a 16550A
00:09: ttyS3 at I/O 0xa88 (irq = 3) is a 16550A
brd: module loaded
Uniform Multi-Platform E-IDE driver
via82cxxx 0000:00:0f.0: VIA cx700 (rev 00) IDE UDMA133
via82cxxx 0000:00:0f.0: IDE controller (0x1106:0x5324 rev 0x00)
via82cxxx 0000:00:0f.0: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0xfc00-0xfc07
    ide1: BM-DMA at 0xfc08-0xfc0f
Probing IDE interface ide0...
Probing IDE interface ide1...
hdc: WDC WD800JB-00JJA0, ATA DISK drive
hdc: host max PIO5 wanted PIO255(auto-tune) selected PIO4
hdc: UDMA/100 mode selected
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide1 at 0x170-0x177,0x376 on irq 15
ide_generic: please use "probe_mask=0x3f" module parameter for probing
all legacy ISA IDE ports
ide-gd driver 1.18
hdc: max request size: 128KiB
hdc: 156301488 sectors (80026 MB) w/8192KiB Cache, CHS=65535/16/63
hdc: cache flushes supported
 hdc: hdc1 hdc2 < hdc5 hdc6 hdc7 hdc8 hdc9 hdc10 hdc11 hdc12 hdc13 hdc14
hdc15 hdc16 >
ide-cd driver 5.00
via-rhine.c:v1.10-LK1.4.3 2007-03-06 Written by Donald Becker
via-rhine 0000:03:08.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
eth0: VIA Rhine III at 0xfeaffc00, 00:40:63:f6:02:00, IRQ 18.
eth0: MII PHY found at address 1, status 0x786d advertising 05e1 Link 41e1.
via-rhine 0000:03:09.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
eth1: VIA Rhine III at 0xfeaff800, 00:40:63:f6:02:01, IRQ 19.
eth1: MII PHY found at address 1, status 0x786d advertising 05e1 Link c5e1.
PPP generic driver version 2.4.2
PPP Deflate Compression module registered
PPP BSD Compression module registered
usbcore: registered new interface driver libusual
PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
PNP: PS/2 appears to have AUX port disabled, if this is incorrect please
boot with i8042.nopnp
serio: i8042 KBD port at 0x60,0x64 irq 1
mice: PS/2 mouse device common for all mice
input: PC Speaker as /devices/platform/pcspkr/input/input3
PPS line discipline registered
device-mapper: ioctl: 4.17.0-ioctl (2010-03-05) initialised:
dm-devel@redhat.com
cpuidle: using governor ladder
cpuidle: using governor menu
padlock: Using VIA PadLock ACE for AES algorithm.
padlock: Using VIA PadLock ACE for SHA1/SHA256 algorithms.
nf_conntrack version 0.5.0 (15079 buckets, 60316 max)
ip_tables: (C) 2000-2006 Netfilter Core Team
TCP cubic registered
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
NET: Registered protocol family 17
Using IPI Shortcut mode
Freeing unused kernel memory: 328k freed
input: AT Translated Set 2 keyboard as
/devices/platform/i8042/serio0/input/input4
dracut: dracut-005-2.fc12
udev: starting version 145
dracut: Starting plymouth daemon
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:10.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
uhci_hcd 0000:00:10.0: UHCI Host Controller
drivers/usb/core/inode.c: creating file 'devices'
drivers/usb/core/inode.c: creating file '001'
uhci_hcd 0000:00:10.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:10.0: detected 2 ports
uhci_hcd 0000:00:10.0: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:10.0: Performing full reset
uhci_hcd 0000:00:10.0: supports USB remote wakeup
uhci_hcd 0000:00:10.0: irq 20, io base 0x0000ec00
usb usb1: default language 0x0409
usb usb1: udev 1, busnum 1, minor = 0
usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: UHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.34 uhci_hcd
usb usb1: SerialNumber: 0000:00:10.0
usb usb1: usb_probe_device
usb usb1: configuration #1 chosen from 1 choice
usb usb1: adding 1-0:1.0 (config #1, interface 0)
hub 1-0:1.0: usb_probe_interface
hub 1-0:1.0: usb_probe_interface - got id
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
hub 1-0:1.0: standalone hub
hub 1-0:1.0: no power switching (usb 1.0)
hub 1-0:1.0: individual port over-current protection
hub 1-0:1.0: power on to power good time: 2ms
hub 1-0:1.0: local power source is good
hub 1-0:1.0: trying to enable port power on non-switchable hub
drivers/usb/core/inode.c: creating file '001'
uhci_hcd 0000:00:10.1: PCI INT B -> GSI 22 (level, low) -> IRQ 22
uhci_hcd 0000:00:10.1: UHCI Host Controller
drivers/usb/core/inode.c: creating file '002'
uhci_hcd 0000:00:10.1: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:10.1: detected 2 ports
uhci_hcd 0000:00:10.1: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:10.1: Performing full reset
uhci_hcd 0000:00:10.1: supports USB remote wakeup
uhci_hcd 0000:00:10.1: irq 22, io base 0x0000e880
usb usb2: default language 0x0409
usb usb2: udev 1, busnum 2, minor = 128
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: UHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.34 uhci_hcd
usb usb2: SerialNumber: 0000:00:10.1
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
Warning! ehci_hcd should always be loaded before uhci_hcd and ohci_hcd,
not after
ehci_hcd: block sizes: qh 60 qtd 96 itd 160 sitd 96
usb usb2: usb_probe_device
usb usb2: configuration #1 chosen from 1 choice
usb usb2: adding 2-0:1.0 (config #1, interface 0)
hub 2-0:1.0: usb_probe_interface
hub 2-0:1.0: usb_probe_interface - got id
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
hub 2-0:1.0: standalone hub
hub 2-0:1.0: no power switching (usb 1.0)
hub 2-0:1.0: individual port over-current protection
hub 2-0:1.0: power on to power good time: 2ms
hub 2-0:1.0: local power source is good
hub 2-0:1.0: trying to enable port power on non-switchable hub
drivers/usb/core/inode.c: creating file '001'
ehci_hcd 0000:00:10.4: PCI INT D -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:10.4: EHCI Host Controller
drivers/usb/core/inode.c: creating file '003'
ehci_hcd 0000:00:10.4: new USB bus registered, assigned bus number 3
ehci_hcd 0000:00:10.4: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2
ordered !ppc ports=6
ehci_hcd 0000:00:10.4: reset hcc_params 6872 thresh 7 uframes 256/512/1024
ehci_hcd 0000:00:10.4: debug port 1
ehci_hcd 0000:00:10.4: reset command 080002 (park)=0 ithresh=8
period=1024 Reset HALT
ehci_hcd 0000:00:10.4: MWI active
ehci_hcd 0000:00:10.4: supports USB remote wakeup
ehci_hcd 0000:00:10.4: irq 23, io mem 0xfebffc00
ehci_hcd 0000:00:10.4: reset command 080002 (park)=0 ithresh=8
period=1024 Reset HALT
ehci_hcd 0000:00:10.4: init command 010009 (park)=0 ithresh=1 period=256 RUN
ehci_hcd 0000:00:10.4: USB 2.0 started, EHCI 1.00
usb usb3: default language 0x0409
usb usb3: udev 1, busnum 3, minor = 256
usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: EHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.34 ehci_hcd
usb usb3: SerialNumber: 0000:00:10.4
usb usb3: usb_probe_device
usb usb3: configuration #1 chosen from 1 choice
usb usb3: adding 3-0:1.0 (config #1, interface 0)
uhci_hcd 0000:00:10.0: port 1 portsc 008a,00
uhci_hcd 0000:00:10.0: port 2 portsc 008a,00
uhci_hcd 0000:00:10.1: port 1 portsc 008a,00
uhci_hcd 0000:00:10.1: port 2 portsc 008a,00
hub 3-0:1.0: usb_probe_interface
hub 3-0:1.0: usb_probe_interface - got id
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 6 ports detected
hub 3-0:1.0: standalone hub
hub 3-0:1.0: no power switching (usb 1.0)
hub 3-0:1.0: individual port over-current protection
hub 3-0:1.0: power on to power good time: 20ms
hub 3-0:1.0: local power source is good
hub 3-0:1.0: trying to enable port power on non-switchable hub
drivers/usb/core/inode.c: creating file '001'
ehci_hcd 0000:00:10.4: HS companion for 0000:00:10.0
ehci_hcd 0000:00:10.4: HS companion for 0000:00:10.1
uhci_hcd 0000:00:10.2: PCI INT C -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:10.2: UHCI Host Controller
drivers/usb/core/inode.c: creating file '004'
uhci_hcd 0000:00:10.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:10.2: detected 2 ports
uhci_hcd 0000:00:10.2: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:10.2: Performing full reset
uhci_hcd 0000:00:10.2: supports USB remote wakeup
uhci_hcd 0000:00:10.2: irq 21, io base 0x0000e800
usb usb4: default language 0x0409
usb usb4: udev 1, busnum 4, minor = 384
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.34 uhci_hcd
usb usb4: SerialNumber: 0000:00:10.2
usb usb4: usb_probe_device
usb usb4: configuration #1 chosen from 1 choice
usb usb4: adding 4-0:1.0 (config #1, interface 0)
hub 4-0:1.0: usb_probe_interface
hub 4-0:1.0: usb_probe_interface - got id
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
hub 4-0:1.0: standalone hub
hub 4-0:1.0: no power switching (usb 1.0)
hub 4-0:1.0: individual port over-current protection
hub 4-0:1.0: power on to power good time: 2ms
hub 4-0:1.0: local power source is good
hub 4-0:1.0: trying to enable port power on non-switchable hub
drivers/usb/core/inode.c: creating file '001'
ehci_hcd 0000:00:10.4: HS companion for 0000:00:10.2
hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0000
hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0000
hub 3-0:1.0: state 7 ports 6 chg 0000 evt 0000
uhci_hcd 0000:00:10.2: port 1 portsc 008a,00
uhci_hcd 0000:00:10.2: port 2 portsc 008a,00
hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
EXT3-fs (hdc5): mounted filesystem with writeback data mode
kjournald starting.  Commit interval 5 seconds
dracut: Remounting /dev/disk/by-label/\x2f with -o noatime,ro
EXT3-fs (hdc5): mounted filesystem with writeback data mode
kjournald starting.  Commit interval 5 seconds
dracut: Mounted root filesystem /dev/hdc5
usb usb1: suspend_rh (auto-stop)
usb usb2: suspend_rh (auto-stop)
usb usb4: suspend_rh (auto-stop)
dracut: Loading SELinux policy
dracut: /sbin/load_policy: Can't load policy: No such device
dracut: Switching root
udev: starting version 145
Modular ISDN core version 1.1.21
NET: Registered protocol family 34
parport_pc 00:0a: reported by Plug and Play ACPI
parport0: PC-style at 0x378, irq 7 [PCSPP,EPP]
VIA Graphics Intergration Chipset framebuffer 2.4 initializing
ppdev: user-space parallel port driver
Winbond W6692 PCI driver Rev. 2.0
w6692 0000:03:0f.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
mISDN_w6692: found adapter Dynalink/AsusCom IS64PH at 0000:03:0f.0
w6692.1: Winbond W6692 version: V00
W6692 1 cards installed
viafb_init_dvi_size: DVI panel size undetected!
udev: renamed network interface eth1 to eth0
udev: renamed network interface eth0_rename to eth1
HDA Intel 0000:02:01.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
HDA Intel 0000:02:01.0: setting latency timer to 64
HDA Intel 0000:02:01.0: PCI: Disallowing DAC for device
EXT3-fs (hdc5): using internal journal
kjournald starting.  Commit interval 5 seconds
EXT3-fs (hdc1): using internal journal
EXT3-fs (hdc1): mounted filesystem with writeback data mode
kjournald starting.  Commit interval 5 seconds
EXT3-fs (hdc7): using internal journal
EXT3-fs (hdc7): mounted filesystem with writeback data mode
kjournald starting.  Commit interval 5 seconds
EXT3-fs (hdc8): using internal journal
EXT3-fs (hdc8): mounted filesystem with writeback data mode
kjournald starting.  Commit interval 5 seconds
EXT3-fs (hdc6): using internal journal
EXT3-fs (hdc6): mounted filesystem with writeback data mode
EXT4-fs (hdc10): mounted filesystem with ordered data mode
EXT4-fs (hdc11): mounted filesystem with ordered data mode
EXT4-fs (hdc12): mounted filesystem with ordered data mode
EXT4-fs (hdc13): mounted filesystem with ordered data mode
EXT4-fs (hdc14): mounted filesystem with ordered data mode
Adding 513036k swap on /dev/mapper/swap.  Priority:-1 extents:1
across:513036k
ip6_tables: (C) 2000-2006 Netfilter Core Team
eth0: link up, 100Mbps, full-duplex, lpa 0xC5E1
eth1: link up, 100Mbps, full-duplex, lpa 0x41E1

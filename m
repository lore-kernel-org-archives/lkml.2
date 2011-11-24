Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830Ab1KXPkX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 10:40:23 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45200 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752907Ab1KXPkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 10:40:19 -0500
Date: Thu, 24 Nov 2011 16:40:15 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: 3.2-rc2: regression after hibernate: lots of warnings, broken
 system 
Message-ID: <20111124154014.GA2153@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="gBBFr7Ir9EOA20Yy"
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

hibernate has some problems in 3.2-rc2... I'll try to investigate some
more, but here's dmesg in case someone else sees it, too...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg.2rc2"

Initializing cgroup subsys cpu
Linux version 3.2.0-rc2+ (pavel@amd) (gcc version 4.4.5 (Debian 4.4.5-6) ) #191 SMP Tue Nov 22 12:35:52 CET 2011
Disabled fast string operations
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
 BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000d2000 - 00000000000d4000 (reserved)
 BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007f6d0000 (usable)
 BIOS-e820: 000000007f6d0000 - 000000007f6df000 (ACPI data)
 BIOS-e820: 000000007f6df000 - 000000007f700000 (ACPI NVS)
 BIOS-e820: 000000007f700000 - 0000000080000000 (reserved)
 BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
 BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
 BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ff800000 - 0000000100000000 (reserved)
Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
DMI present.
DMI: LENOVO 17097HU/17097HU, BIOS 7BETD3WW (2.14 ) 10/04/2007
e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
last_pfn = 0x7f6d0 max_arch_pfn = 0x100000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-CFFFF write-protect
  D0000-DBFFF uncachable
  DC000-DFFFF write-back
  E0000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 000000000 mask F80000000 write-back
  1 base 07F700000 mask FFFF00000 uncachable
  2 base 07F800000 mask FFF800000 uncachable
  3 disabled
  4 disabled
  5 disabled
  6 disabled
  7 disabled
PAT not supported by CPU.
initial memory mapped : 0 - 01400000
Base memory trampoline at [c009b000] 9b000 size 16384
init_memory_mapping: 0000000000000000-00000000377fe000
 0000000000 - 00377fe000 page 4k
kernel direct mapping tables up to 377fe000 @ 131f000-1400000
ACPI: RSDP 000f67c0 00024 (v02 LENOVO)
ACPI: XSDT 7f6d191c 00084 (v01 LENOVO TP-7B    00002140  LTP 00000000)
ACPI: FACP 7f6d1a00 000F4 (v03 LENOVO TP-7B    00002140 LNVO 00000001)
ACPI Warning: 32/64X length mismatch in Gpe1Block: 0/32 (20110623/tbfadt-529)
ACPI Warning: Optional field Gpe1Block has zero address or length: 0x000000000000102C/0x0 (20110623/tbfadt-560)
ACPI: DSDT 7f6d1d90 0CFB9 (v01 LENOVO TP-7B    00002140 MSFT 0100000E)
ACPI: FACS 7f6f4000 00040
ACPI: SSDT 7f6d1bb4 001DC (v01 LENOVO TP-7B    00002140 MSFT 0100000E)
ACPI: ECDT 7f6ded49 00052 (v01 LENOVO TP-7B    00002140 LNVO 00000001)
ACPI: TCPA 7f6ded9b 00032 (v02 LENOVO TP-7B    00002140 LNVO 00000001)
ACPI: APIC 7f6dedcd 00068 (v01 LENOVO TP-7B    00002140 LNVO 00000001)
ACPI: MCFG 7f6dee35 0003C (v01 LENOVO TP-7B    00002140 LNVO 00000001)
ACPI: HPET 7f6dee71 00038 (v01 LENOVO TP-7B    00002140 LNVO 00000001)
ACPI: BOOT 7f6defd8 00028 (v01 LENOVO TP-7B    00002140  LTP 00000001)
ACPI: SSDT 7f6f2645 0025F (v01 LENOVO TP-7B    00002140 INTL 20050513)
ACPI: SSDT 7f6f28a4 000A6 (v01 LENOVO TP-7B    00002140 INTL 20050513)
ACPI: SSDT 7f6f294a 004F7 (v01 LENOVO TP-7B    00002140 INTL 20050513)
ACPI: SSDT 7f6f2e41 001D8 (v01 LENOVO TP-7B    00002140 INTL 20050513)
ACPI: Local APIC address 0xfee00000
1150MB HIGHMEM available.
887MB LOWMEM available.
  mapped low ram: 0 - 377fe000
  low ram: 0 - 377fe000
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  Normal   0x00001000 -> 0x000377fe
  HighMem  0x000377fe -> 0x0007f6d0
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000010 -> 0x0000009f
    0: 0x00000100 -> 0x0007f6d0
On node 0 totalpages: 521823
free_area_init_node: node 0, pgdat c0b52a40, node_mem_map f680d200
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 3951 pages, LIFO batch:0
  Normal zone: 1744 pages used for memmap
  Normal zone: 221486 pages, LIFO batch:31
  HighMem zone: 2302 pages used for memmap
  HighMem zone: 292308 pages, LIFO batch:31
Using APIC driver default
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a201 base: 0xfed00000
SMP: Allowing 2 CPUs, 0 hotplug CPUs
nr_irqs_gsi: 40
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000d2000
PM: Registered nosave memory: 00000000000d2000 - 00000000000d4000
PM: Registered nosave memory: 00000000000d4000 - 00000000000dc000
PM: Registered nosave memory: 00000000000dc000 - 0000000000100000
Allocating PCI resources starting at 80000000 (gap: 80000000:70000000)
setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_node_ids:1
PERCPU: Embedded 12 pages/cpu @f6000000 s25536 r0 d23616 u2097152
pcpu-alloc: s25536 r0 d23616 u2097152 alloc=1*4194304
pcpu-alloc: [0] 0 1 
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 517745
Kernel command line: BOOT_IMAGE=(hd0,2)/l/linux-good/arch/i386/boot/bzImage root=/dev/sda4 resume=/dev/sda1 psmouse.psmouse_proto=imps psmouse_proto=imps psmouse.proto=imps init=/tmp/swsusp-init acpi_sleep=s3_bios,s3_mode no_console_suspend i915.modeset=1 video=inteldrmfb:mode=1024x768 fbcon=scrollback:64k irqpoll
Misrouted IRQ fixup and polling support enabled
This may significantly impact system performance
PID hash table entries: 4096 (order: 2, 16384 bytes)
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Initializing CPU#0
Initializing HighMem for node 0 (000377fe:0007f6d0)
Memory: 2053896k/2087744k available (6562k kernel code, 33396k reserved, 3076k data, 432k init, 1178440k highmem)
virtual kernel memory layout:
    fixmap  : 0xffe6f000 - 0xfffff000   (1600 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
    lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
      .init : 0xc0b6a000 - 0xc0bd6000   ( 432 kB)
      .data : 0xc0868844 - 0xc0b69c00   (3076 kB)
      .text : 0xc0200000 - 0xc0868844   (6562 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
Hierarchical RCU implementation.
	RCU dyntick-idle grace-period acceleration is enabled.
NR_IRQS:2304 nr_irqs:512 16
CPU 0 irqstacks, hard=f5c18000 soft=f5c1a000
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
ODEBUG: 4 of 4 active objects replaced
hpet clockevent registered
Fast TSC calibration using PIT
Detected 1828.638 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 3657.27 BogoMIPS (lpj=7314552)
pid_max: default: 32768 minimum: 301
Mount-cache hash table entries: 512
Disabled fast string operations
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
using mwait in idle threads.
ACPI: Core revision 20110623
Enabling APIC mode:  Flat.  Using 1 I/O APICs
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Genuine Intel(R) CPU           T2400  @ 1.83GHz stepping 08
Performance Events: Core events, core PMU driver.
... version:                1
... bit width:              40
... generic registers:      2
... value mask:             000000ffffffffff
... max period:             000000007fffffff
... fixed-purpose events:   0
... event mask:             0000000000000003
NMI watchdog enabled, takes one hw-pmu counter.
lockdep: fixing up alternatives.
CPU 1 irqstacks, hard=f5d66000 soft=f5d68000
Booting Node   0, Processors  #1 Ok.
smpboot cpu 1: start_ip = 9b000
Initializing CPU#1
Disabled fast string operations
TSC synchronization [CPU#0 -> CPU#1]:
Measured 579821 cycles TSC warp between CPUs, turning off TSC clock.
Marking TSC unstable due to check_tsc_sync_source failed
NMI watchdog enabled, takes one hw-pmu counter.
Brought up 2 CPUs
Total of 2 processors activated (7314.84 BogoMIPS).
PM: Registering ACPI NVS region at 7f6df000 (135168 bytes)
NET: Registered protocol family 16
ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
ACPI: bus type pci registered
PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf0000000-0xf3ffffff] (base 0xf0000000)
PCI: MMCONFIG at [mem 0xf0000000-0xf3ffffff] reserved in E820
PCI: Using MMCONFIG for extended config space
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: Added _OSI(Module Device)
ACPI: Added _OSI(Processor Device)
ACPI: Added _OSI(3.0 _SCP Extensions)
ACPI: Added _OSI(Processor Aggregator Device)
ACPI: EC: EC description table is found, configuring boot EC
ACPI: SSDT 7f6f1d26 00240 (v01  PmRef  Cpu0Ist 00000100 INTL 20050513)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT   (null) 00240 (v01  PmRef  Cpu0Ist 00000100 INTL 20050513)
ACPI: SSDT 7f6f1feb 0065A (v01  PmRef  Cpu0Cst 00000100 INTL 20050513)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT   (null) 0065A (v01  PmRef  Cpu0Cst 00000100 INTL 20050513)
ACPI: SSDT 7f6f1c5e 000C8 (v01  PmRef  Cpu1Ist 00000100 INTL 20050513)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT   (null) 000C8 (v01  PmRef  Cpu1Ist 00000100 INTL 20050513)
ACPI: SSDT 7f6f1f66 00085 (v01  PmRef  Cpu1Cst 00000100 INTL 20050513)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT   (null) 00085 (v01  PmRef  Cpu1Cst 00000100 INTL 20050513)
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: Power Resource [PUBS] (on)
ACPI: EC: GPE = 0x1c, I/O: command/status = 0x66, data = 0x62
ACPI: ACPI Dock Station Driver: 3 docks/bays found
HEST: Table not found.
PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7] (ignored)
pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff] (ignored)
pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
pci_root PNP0A08:00: host bridge window [mem 0x000d4000-0x000d7fff] (ignored)
pci_root PNP0A08:00: host bridge window [mem 0x000d8000-0x000dbfff] (ignored)
pci_root PNP0A08:00: host bridge window [mem 0x80000000-0xfebfffff] (ignored)
pci_root PNP0A08:00: host bridge window [mem 0xfed40000-0xfed40fff] (ignored)
pci 0000:00:00.0: [8086:27a0] type 0 class 0x000600
pci 0000:00:02.0: [8086:27a2] type 0 class 0x000300
pci 0000:00:02.0: reg 10: [mem 0xee100000-0xee17ffff]
pci 0000:00:02.0: reg 14: [io  0x1800-0x1807]
pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff pref]
pci 0000:00:02.0: reg 1c: [mem 0xee200000-0xee23ffff]
pci 0000:00:02.1: [8086:27a6] type 0 class 0x000380
pci 0000:00:02.1: reg 10: [mem 0xee180000-0xee1fffff]
pci 0000:00:1b.0: [8086:27d8] type 0 class 0x000403
pci 0000:00:1b.0: reg 10: [mem 0xee240000-0xee243fff 64bit]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: PME# disabled
pci 0000:00:1c.0: [8086:27d0] type 1 class 0x000604
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.1: [8086:27d2] type 1 class 0x000604
pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.1: PME# disabled
pci 0000:00:1c.2: [8086:27d4] type 1 class 0x000604
pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.2: PME# disabled
pci 0000:00:1c.3: [8086:27d6] type 1 class 0x000604
pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.3: PME# disabled
pci 0000:00:1d.0: [8086:27c8] type 0 class 0x000c03
pci 0000:00:1d.0: reg 20: [io  0x1820-0x183f]
pci 0000:00:1d.1: [8086:27c9] type 0 class 0x000c03
pci 0000:00:1d.1: reg 20: [io  0x1840-0x185f]
pci 0000:00:1d.2: [8086:27ca] type 0 class 0x000c03
pci 0000:00:1d.2: reg 20: [io  0x1860-0x187f]
pci 0000:00:1d.3: [8086:27cb] type 0 class 0x000c03
pci 0000:00:1d.3: reg 20: [io  0x1880-0x189f]
pci 0000:00:1d.7: [8086:27cc] type 0 class 0x000c03
pci 0000:00:1d.7: reg 10: [mem 0xee444000-0xee4443ff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1e.0: [8086:2448] type 1 class 0x000604
pci 0000:00:1f.0: [8086:27b9] type 0 class 0x000601
pci 0000:00:1f.0: quirk: [io  0x1000-0x107f] claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: [io  0x1180-0x11bf] claimed by ICH6 GPIO
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 1600 (mask 007f)
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 15e0 (mask 000f)
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 1680 (mask 001f)
pci 0000:00:1f.1: [8086:27df] type 0 class 0x000101
pci 0000:00:1f.1: reg 10: [io  0x0000-0x0007]
pci 0000:00:1f.1: reg 14: [io  0x0000-0x0003]
pci 0000:00:1f.1: reg 18: [io  0x0000-0x0007]
pci 0000:00:1f.1: reg 1c: [io  0x0000-0x0003]
pci 0000:00:1f.1: reg 20: [io  0x1810-0x181f]
pci 0000:00:1f.2: [8086:27c5] type 0 class 0x000106
pci 0000:00:1f.2: reg 10: [io  0x18d0-0x18d7]
pci 0000:00:1f.2: reg 14: [io  0x18c4-0x18c7]
pci 0000:00:1f.2: reg 18: [io  0x18c8-0x18cf]
pci 0000:00:1f.2: reg 1c: [io  0x18c0-0x18c3]
pci 0000:00:1f.2: reg 20: [io  0x18b0-0x18bf]
pci 0000:00:1f.2: reg 24: [mem 0xee444400-0xee4447ff]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.2: PME# disabled
pci 0000:00:1f.3: [8086:27da] type 0 class 0x000c05
pci 0000:00:1f.3: reg 20: [io  0x18e0-0x18ff]
pci 0000:02:00.0: [8086:109a] type 0 class 0x000200
pci 0000:02:00.0: reg 10: [mem 0xee000000-0xee01ffff]
pci 0000:02:00.0: reg 18: [io  0x2000-0x201f]
pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
pci 0000:02:00.0: PME# disabled
pci 0000:00:1c.0: PCI bridge to [bus 02-02]
pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
pci 0000:00:1c.0:   bridge window [mem 0xee000000-0xee0fffff]
pci 0000:03:00.0: [8086:4227] type 0 class 0x000280
pci 0000:03:00.0: reg 10: [mem 0xedf00000-0xedf00fff]
pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
pci 0000:03:00.0: PME# disabled
pci 0000:00:1c.1: PCI bridge to [bus 03-03]
pci 0000:00:1c.1:   bridge window [io  0x3000-0x4fff]
pci 0000:00:1c.1:   bridge window [mem 0xec000000-0xedffffff]
pci 0000:00:1c.1:   bridge window [mem 0xe4000000-0xe40fffff 64bit pref]
pci 0000:00:1c.2: PCI bridge to [bus 04-0b]
pci 0000:00:1c.2:   bridge window [io  0x5000-0x6fff]
pci 0000:00:1c.2:   bridge window [mem 0xe8000000-0xe9ffffff]
pci 0000:00:1c.2:   bridge window [mem 0xe4100000-0xe41fffff 64bit pref]
pci 0000:00:1c.3: PCI bridge to [bus 0c-13]
pci 0000:00:1c.3:   bridge window [io  0x7000-0x8fff]
pci 0000:00:1c.3:   bridge window [mem 0xea000000-0xebffffff]
pci 0000:00:1c.3:   bridge window [mem 0xe4200000-0xe42fffff 64bit pref]
pci 0000:15:00.0: [1180:0476] type 2 class 0x000607
pci 0000:15:00.0: reg 10: [mem 0xe4300000-0xe4300fff]
pci 0000:15:00.0: supports D1 D2
pci 0000:15:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:15:00.0: PME# disabled
pci 0000:15:00.1: [1180:0552] type 0 class 0x000c00
pci 0000:15:00.1: reg 10: [mem 0xe4301000-0xe43017ff]
pci 0000:15:00.1: PME# supported from D0 D3hot D3cold
pci 0000:15:00.1: PME# disabled
pci 0000:15:00.2: [1180:0822] type 0 class 0x000805
pci 0000:15:00.2: reg 10: [mem 0xe4301800-0xe43018ff]
pci 0000:15:00.2: supports D1 D2
pci 0000:15:00.2: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:15:00.2: PME# disabled
pci 0000:00:1e.0: PCI bridge to [bus 15-18] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0x9000-0xcfff]
pci 0000:00:1e.0:   bridge window [mem 0xe4300000-0xe7ffffff]
pci 0000:00:1e.0:   bridge window [mem 0xe0000000-0xe3ffffff 64bit pref]
pci 0000:00:1e.0:   bridge window [io  0x0000-0xffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x00000000-0xffffffff] (subtractive decode)
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
 pci0000:00: Unable to request _OSC control (_OSC support mask: 0x0f)
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
vgaarb: bridge control possible 0000:00:02.0
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
Advanced Linux Sound Architecture Driver Version 1.0.24.
PCI: Using ACPI for IRQ routing
PCI: pci_cache_line_size set to 64 bytes
reserve RAM buffer: 000000000009f000 - 000000000009ffff 
reserve RAM buffer: 000000007f6d0000 - 000000007fffffff 
Bluetooth: Core ver 2.16
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: L2CAP socket layer initialized
Bluetooth: SCO socket layer initialized
cfg80211: Calling CRDA to update world regulatory domain
Switching to clocksource hpet
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp 00:00: [mem 0x00000000-0x0009ffff]
pnp 00:00: [mem 0x000c0000-0x000c3fff]
pnp 00:00: [mem 0x000c4000-0x000c7fff]
pnp 00:00: [mem 0x000c8000-0x000cbfff]
pnp 00:00: [mem 0x000cc000-0x000cffff]
pnp 00:00: [mem 0x000d0000-0x000d3fff]
pnp 00:00: [mem 0x000d4000-0x000d3fff disabled]
pnp 00:00: [mem 0x000d8000-0x000d7fff disabled]
pnp 00:00: [mem 0x000dc000-0x000dffff]
pnp 00:00: [mem 0x000e0000-0x000e3fff]
pnp 00:00: [mem 0x000e4000-0x000e7fff]
pnp 00:00: [mem 0x000e8000-0x000ebfff]
pnp 00:00: [mem 0x000ec000-0x000effff]
pnp 00:00: [mem 0x000f0000-0x000fffff]
pnp 00:00: [mem 0x00100000-0x7fffffff]
pnp 00:00: [mem 0xfec00000-0xfed3ffff]
pnp 00:00: [mem 0xfed41000-0xffffffff]
system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
system 00:00: [mem 0x000c0000-0x000c3fff] could not be reserved
system 00:00: [mem 0x000c4000-0x000c7fff] could not be reserved
system 00:00: [mem 0x000c8000-0x000cbfff] has been reserved
system 00:00: [mem 0x000cc000-0x000cffff] could not be reserved
system 00:00: [mem 0x000d0000-0x000d3fff] could not be reserved
system 00:00: [mem 0x000dc000-0x000dffff] could not be reserved
system 00:00: [mem 0x000e0000-0x000e3fff] could not be reserved
system 00:00: [mem 0x000e4000-0x000e7fff] could not be reserved
system 00:00: [mem 0x000e8000-0x000ebfff] could not be reserved
system 00:00: [mem 0x000ec000-0x000effff] could not be reserved
system 00:00: [mem 0x000f0000-0x000fffff] could not be reserved
system 00:00: [mem 0x00100000-0x7fffffff] could not be reserved
system 00:00: [mem 0xfec00000-0xfed3ffff] could not be reserved
system 00:00: [mem 0xfed41000-0xffffffff] could not be reserved
system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
pnp 00:01: [bus 00-ff]
pnp 00:01: [io  0x0cf8-0x0cff]
pnp 00:01: [io  0x0000-0x0cf7 window]
pnp 00:01: [io  0x0d00-0xffff window]
pnp 00:01: [mem 0x000a0000-0x000bffff window]
pnp 00:01: [mem 0x000c0000-0x000c3fff window]
pnp 00:01: [mem 0x000c4000-0x000c7fff window]
pnp 00:01: [mem 0x000c8000-0x000cbfff window]
pnp 00:01: [mem 0x000cc000-0x000cffff window]
pnp 00:01: [mem 0x000d0000-0x000d3fff window]
pnp 00:01: [mem 0x000d4000-0x000d7fff window]
pnp 00:01: [mem 0x000d8000-0x000dbfff window]
pnp 00:01: [mem 0x000dc000-0x000dffff window]
pnp 00:01: [mem 0x000e0000-0x000e3fff window]
pnp 00:01: [mem 0x000e4000-0x000e7fff window]
pnp 00:01: [mem 0x000e8000-0x000ebfff window]
pnp 00:01: [mem 0x000ec000-0x000effff window]
pnp 00:01: [mem 0x80000000-0xfebfffff window]
pnp 00:01: [mem 0xfed40000-0xfed40fff window]
pnp 00:01: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
pnp 00:02: [io  0x0010-0x001f]
pnp 00:02: [io  0x0090-0x009f]
pnp 00:02: [io  0x0024-0x0025]
pnp 00:02: [io  0x0028-0x0029]
pnp 00:02: [io  0x002c-0x002d]
pnp 00:02: [io  0x0030-0x0031]
pnp 00:02: [io  0x0034-0x0035]
pnp 00:02: [io  0x0038-0x0039]
pnp 00:02: [io  0x003c-0x003d]
pnp 00:02: [io  0x00a4-0x00a5]
pnp 00:02: [io  0x00a8-0x00a9]
pnp 00:02: [io  0x00ac-0x00ad]
pnp 00:02: [io  0x00b0-0x00b5]
pnp 00:02: [io  0x00b8-0x00b9]
pnp 00:02: [io  0x00bc-0x00bd]
pnp 00:02: [io  0x0050-0x0053]
pnp 00:02: [io  0x0072-0x0077]
pnp 00:02: [io  0x164e-0x164f]
pnp 00:02: [io  0x002e-0x002f]
pnp 00:02: [io  0x1000-0x107f]
pnp 00:02: [io  0x1180-0x11bf]
pnp 00:02: [io  0x0800-0x080f]
pnp 00:02: [io  0x15e0-0x15ef]
pnp 00:02: [io  0x1600-0x165f]
pnp 00:02: [mem 0xf0000000-0xf3ffffff]
pnp 00:02: [mem 0xfed1c000-0xfed1ffff]
pnp 00:02: [mem 0xfed14000-0xfed17fff]
pnp 00:02: [mem 0xfed18000-0xfed18fff]
pnp 00:02: [mem 0xfed19000-0xfed19fff]
system 00:02: [io  0x164e-0x164f] has been reserved
system 00:02: [io  0x1000-0x107f] has been reserved
system 00:02: [io  0x1180-0x11bf] has been reserved
system 00:02: [io  0x0800-0x080f] has been reserved
system 00:02: [io  0x15e0-0x15ef] has been reserved
system 00:02: [io  0x1600-0x165f] could not be reserved
system 00:02: [mem 0xf0000000-0xf3ffffff] has been reserved
system 00:02: [mem 0xfed1c000-0xfed1ffff] has been reserved
system 00:02: [mem 0xfed14000-0xfed17fff] has been reserved
system 00:02: [mem 0xfed18000-0xfed18fff] has been reserved
system 00:02: [mem 0xfed19000-0xfed19fff] has been reserved
system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:03: [mem 0xfed00000-0xfed003ff]
pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
pnp 00:04: [io  0x0000-0x000f]
pnp 00:04: [io  0x0080-0x008f]
pnp 00:04: [io  0x00c0-0x00df]
pnp 00:04: [dma 4]
pnp 00:04: Plug and Play ACPI device, IDs PNP0200 (active)
pnp 00:05: [io  0x0061]
pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
pnp 00:06: [io  0x00f0]
pnp 00:06: [irq 13]
pnp 00:06: Plug and Play ACPI device, IDs PNP0c04 (active)
pnp 00:07: [io  0x0070-0x0071]
pnp 00:07: [irq 8]
pnp 00:07: Plug and Play ACPI device, IDs PNP0b00 (active)
pnp 00:08: [io  0x0060]
pnp 00:08: [io  0x0064]
pnp 00:08: [irq 1]
pnp 00:08: Plug and Play ACPI device, IDs PNP0303 (active)
pnp 00:09: [irq 12]
pnp 00:09: Plug and Play ACPI device, IDs IBM3780 PNP0f13 (active)
pnp 00:0a: [io  0x02f8-0x02ff]
pnp 00:0a: [irq 3]
pnp 00:0a: [dma 3]
pnp 00:0a: Plug and Play ACPI device, IDs IBM0071 PNP0511 (active)
pnp 00:0b: [mem 0xfed40000-0xfed40fff]
pnp 00:0b: Plug and Play ACPI device, IDs ATM1200 PNP0c31 (active)
pnp: PnP ACPI: found 12 devices
ACPI: ACPI bus type pnp unregistered
PCI: max bus depth: 2 pci_try_num: 3
pci 0000:00:1c.0: BAR 9: assigned [mem 0x80000000-0x801fffff 64bit pref]
pci 0000:00:1c.0: PCI bridge to [bus 02-02]
pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
pci 0000:00:1c.0:   bridge window [mem 0xee000000-0xee0fffff]
pci 0000:00:1c.0:   bridge window [mem 0x80000000-0x801fffff 64bit pref]
pci 0000:00:1c.1: PCI bridge to [bus 03-03]
pci 0000:00:1c.1:   bridge window [io  0x3000-0x4fff]
pci 0000:00:1c.1:   bridge window [mem 0xec000000-0xedffffff]
pci 0000:00:1c.1:   bridge window [mem 0xe4000000-0xe40fffff 64bit pref]
pci 0000:00:1c.2: PCI bridge to [bus 04-0b]
pci 0000:00:1c.2:   bridge window [io  0x5000-0x6fff]
pci 0000:00:1c.2:   bridge window [mem 0xe8000000-0xe9ffffff]
pci 0000:00:1c.2:   bridge window [mem 0xe4100000-0xe41fffff 64bit pref]
pci 0000:00:1c.3: PCI bridge to [bus 0c-13]
pci 0000:00:1c.3:   bridge window [io  0x7000-0x8fff]
pci 0000:00:1c.3:   bridge window [mem 0xea000000-0xebffffff]
pci 0000:00:1c.3:   bridge window [mem 0xe4200000-0xe42fffff 64bit pref]
pci 0000:15:00.0: BAR 10: assigned [mem 0x84000000-0x87ffffff]
pci 0000:15:00.0: BAR 9: assigned [mem 0xe0000000-0xe3ffffff pref]
pci 0000:15:00.0: BAR 8: assigned [io  0x9000-0x90ff]
pci 0000:15:00.0: BAR 7: assigned [io  0x9400-0x94ff]
pci 0000:15:00.0: CardBus bridge to [bus 16-17]
pci 0000:15:00.0:   bridge window [io  0x9400-0x94ff]
pci 0000:15:00.0:   bridge window [io  0x9000-0x90ff]
pci 0000:15:00.0:   bridge window [mem 0xe0000000-0xe3ffffff pref]
pci 0000:15:00.0:   bridge window [mem 0x84000000-0x87ffffff]
pci 0000:00:1e.0: PCI bridge to [bus 15-18]
pci 0000:00:1e.0:   bridge window [io  0x9000-0xcfff]
pci 0000:00:1e.0:   bridge window [mem 0xe4300000-0xe7ffffff]
pci 0000:00:1e.0:   bridge window [mem 0xe0000000-0xe3ffffff 64bit pref]
pci 0000:00:1c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
pci 0000:00:1c.0: setting latency timer to 64
pci 0000:00:1c.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
pci 0000:00:1c.1: setting latency timer to 64
pci 0000:00:1c.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
pci 0000:00:1c.2: setting latency timer to 64
pci 0000:00:1c.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
pci 0000:00:1c.3: setting latency timer to 64
pci 0000:00:1e.0: enabling device (0005 -> 0007)
pci 0000:00:1e.0: setting latency timer to 64
pci 0000:15:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:15:00.0: setting latency timer to 64
pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffff]
pci_bus 0000:02: resource 0 [io  0x2000-0x2fff]
pci_bus 0000:02: resource 1 [mem 0xee000000-0xee0fffff]
pci_bus 0000:02: resource 2 [mem 0x80000000-0x801fffff 64bit pref]
pci_bus 0000:03: resource 0 [io  0x3000-0x4fff]
pci_bus 0000:03: resource 1 [mem 0xec000000-0xedffffff]
pci_bus 0000:03: resource 2 [mem 0xe4000000-0xe40fffff 64bit pref]
pci_bus 0000:04: resource 0 [io  0x5000-0x6fff]
pci_bus 0000:04: resource 1 [mem 0xe8000000-0xe9ffffff]
pci_bus 0000:04: resource 2 [mem 0xe4100000-0xe41fffff 64bit pref]
pci_bus 0000:0c: resource 0 [io  0x7000-0x8fff]
pci_bus 0000:0c: resource 1 [mem 0xea000000-0xebffffff]
pci_bus 0000:0c: resource 2 [mem 0xe4200000-0xe42fffff 64bit pref]
pci_bus 0000:15: resource 0 [io  0x9000-0xcfff]
pci_bus 0000:15: resource 1 [mem 0xe4300000-0xe7ffffff]
pci_bus 0000:15: resource 2 [mem 0xe0000000-0xe3ffffff 64bit pref]
pci_bus 0000:15: resource 4 [io  0x0000-0xffff]
pci_bus 0000:15: resource 5 [mem 0x00000000-0xffffffff]
pci_bus 0000:16: resource 0 [io  0x9400-0x94ff]
pci_bus 0000:16: resource 1 [io  0x9000-0x90ff]
pci_bus 0000:16: resource 2 [mem 0xe0000000-0xe3ffffff pref]
pci_bus 0000:16: resource 3 [mem 0x84000000-0x87ffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 9, 2359296 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
UDP hash table entries: 512 (order: 3, 40960 bytes)
UDP-Lite hash table entries: 512 (order: 3, 40960 bytes)
NET: Registered protocol family 1
RPC: Registered named UNIX socket transport module.
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
pci 0000:00:02.0: Boot video device
pci 0000:00:1d.0: uhci_check_and_reset_hc: legsup = 0x2000
pci 0000:00:1d.0: Performing full reset
pci 0000:00:1d.1: uhci_check_and_reset_hc: legsup = 0x2000
pci 0000:00:1d.1: Performing full reset
pci 0000:00:1d.2: uhci_check_and_reset_hc: legsup = 0x2000
pci 0000:00:1d.2: Performing full reset
pci 0000:00:1d.3: uhci_check_and_reset_hc: legsup = 0x2000
pci 0000:00:1d.3: Performing full reset
PCI: CLS 64 bytes, default 64
Simple Boot Flag at 0x35 set to 0x1
highmem bounce pool size: 64 pages
msgmni has been set to 1709
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
pcieport 0000:00:1c.0: setting latency timer to 64
pcieport 0000:00:1c.1: setting latency timer to 64
pcieport 0000:00:1c.2: setting latency timer to 64
pcieport 0000:00:1c.3: setting latency timer to 64
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
acpiphp: Slot [1] registered
acpiphp_ibm: ibm_acpiphp_init: acpi_walk_namespace failed
intel_idle: MWAIT substates: 0x22220
intel_idle: does not run on family 6 model 14
ACPI: Deprecated procfs I/F for AC is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
ACPI: AC Adapter [AC] (on-line)
input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
ACPI: Lid Switch [LID]
input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input1
ACPI: Sleep Button [SLPB]
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
ACPI: Power Button [PWRF]
acpi device:02: registered as cooling_device0
input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input3
ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
ACPI: acpi_idle registered with cpuidle
thermal LNXTHERM:00: registered as thermal_zone0
ACPI: Thermal Zone [THM0] (43 C)
thermal LNXTHERM:01: registered as thermal_zone1
ACPI: Thermal Zone [THM1] (43 C)
ERST: Table is not found!
ACPI: Deprecated procfs I/F for battery is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
ACPI: Battery Slot [BAT0] (battery absent)
GHES: HEST is not enabled!
ERST DBG: ERST support is disabled.
Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a NS16550A
lp: driver loaded but no devices found
Non-volatile memory driver v1.3
intel_rng: FWH not detected
Linux agpgart interface v0.103
agpgart-intel 0000:00:00.0: Intel 945GM Chipset
agpgart-intel 0000:00:00.0: detected gtt size: 262144K total, 262144K mappable
agpgart-intel 0000:00:00.0: detected 8192K stolen memory
agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[drm] Initialized drm 1.1.0 20060810
i915 0000:00:02.0: power state changed by ACPI to D0
i915 0000:00:02.0: power state changed by ACPI to D0
i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
i915 0000:00:02.0: setting latency timer to 64
[drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[drm] Driver supports precise vblank timestamp query.
vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[drm] initialized overlay support
fbcon: inteldrmfb (fb0) is primary device
[drm] Changing LVDS panel from (+hsync, +vsync) to (-hsync, -vsync)
Console: switching to colour frame buffer device 102x42
fb0: inteldrmfb frame buffer device
drm: registered panic notifier
[drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
loop: module loaded
nbd: registered device at major 43
ahci 0000:00:1f.2: version 3.0
ahci 0000:00:1f.2: PCI INT B -> GSI 16 (level, low) -> IRQ 16
ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 1.5 Gbps 0x1 impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum part 
ahci 0000:00:1f.2: setting latency timer to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
ata1: SATA max UDMA/133 abar m1024@0xee444400 port 0xee444500 irq 16
ata2: DUMMY
ata3: DUMMY
ata4: DUMMY
ata_piix 0000:00:1f.1: version 2.13
ata_piix 0000:00:1f.1: PCI INT C -> GSI 16 (level, low) -> IRQ 16
ata_piix 0000:00:1f.1: setting latency timer to 64
scsi4 : ata_piix
scsi5 : ata_piix
ata5: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x1810 irq 14
ata6: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x1818 irq 15
ata6: port disabled--ignoring
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
e1000e: Intel(R) PRO/1000 Network Driver - 1.5.1-k
e1000e: Copyright(c) 1999 - 2011 Intel Corporation.
e1000e 0000:02:00.0: Disabling ASPM L0s L1
e1000e 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
e1000e 0000:02:00.0: setting latency timer to 64
e1000e 0000:02:00.0: (unregistered net_device): Failed to initialize MSI interrupts.  Falling back to legacy interrupts.
e1000e 0000:02:00.0: eth0: (PCI Express:2.5GT/s:Width x1) 00:16:d3:25:19:04
e1000e 0000:02:00.0: eth0: Intel(R) PRO/1000 Network Connection
e1000e 0000:02:00.0: eth0: MAC: 2, PHY: 2, PBA No: 005302-003
PPP generic driver version 2.4.2
PPP BSD Compression module registered
PPP Deflate Compression module registered
SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels, max=256).
CSLIP: code copyright 1989 Regents of the University of California.
iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux, in-tree:s
iwl3945: Copyright(c) 2003-2011 Intel Corporation
iwl3945 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
iwl3945 0000:03:00.0: setting latency timer to 64
iwl3945 0000:03:00.0: Tunable channels: 11 802.11bg, 13 802.11a channels
iwl3945 0000:03:00.0: Detected Intel Wireless WiFi Link 3945ABG
Registered led device: phy0-led
ieee80211 phy0: Selected rate control algorithm 'iwl-3945-rs'
usbcore: registered new interface driver cdc_ether
usbcore: registered new interface driver net1080
usbcore: registered new interface driver cdc_subset
usbcore: registered new interface driver zaurus
cdc_ncm: 04-Aug-2011
usbcore: registered new interface driver cdc_ncm
yenta_cardbus 0000:15:00.0: CardBus bridge found [17aa:201c]
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
ata1.00: ATA-8: ST9500325AS, 0001SDM1, max UDMA/133
ata1.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
ata1.00: configured for UDMA/133
scsi 0:0:0:0: Direct-Access     ATA      ST9500325AS      0001 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
sd 0:0:0:0: Attached scsi generic sg0 type 0
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda4
sd 0:0:0:0: [sda] Attached SCSI disk
yenta_cardbus 0000:15:00.0: ISA IRQ mask 0x0cb8, PCI irq 16
yenta_cardbus 0000:15:00.0: Socket status: 30000006
yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge window: [io  0x9000-0xcfff]
yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge window: [mem 0xe4300000-0xe7ffffff]
pcmcia_socket pcmcia_socket0: cs: memory probe 0xe4300000-0xe7ffffff: excluding 0xe4300000-0xe46cffff
yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge window: [mem 0xe0000000-0xe3ffffff 64bit pref]
pcmcia_socket pcmcia_socket0: cs: memory probe 0xe0000000-0xe3ffffff: excluding 0xe0000000-0xe3ffffff
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd: block sizes: qh 64 qtd 96 itd 160 sitd 96
ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
drivers/usb/core/inode.c: creating file 'devices'
drivers/usb/core/inode.c: creating file '001'
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1d.7: reset hcs_params 0x104208 dbg=1 cc=4 pcc=2 ordered !ppc ports=8
ehci_hcd 0000:00:1d.7: reset hcc_params 6871 thresh 7 uframes 1024 64 bit addr
ehci_hcd 0000:00:1d.7: using broken periodic workaround
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: reset command 0080022 (park)=0 ithresh=8 Async period=1024 Reset HALT
ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
ehci_hcd 0000:00:1d.7: supports USB remote wakeup
ehci_hcd 0000:00:1d.7: irq 19, io mem 0xee444000
ehci_hcd 0000:00:1d.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
ehci_hcd 0000:00:1d.7: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
usb usb1: default language 0x0409
usb usb1: udev 1, busnum 1, minor = 0
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 3.2.0-rc2+ ehci_hcd
usb usb1: SerialNumber: 0000:00:1d.7
usb usb1: usb_probe_device
usb usb1: configuration #1 chosen from 1 choice
usb usb1: adding 1-0:1.0 (config #1, interface 0)
hub 1-0:1.0: usb_probe_interface
hub 1-0:1.0: usb_probe_interface - got id
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
hub 1-0:1.0: standalone hub
hub 1-0:1.0: no power switching (usb 1.0)
hub 1-0:1.0: individual port over-current protection
hub 1-0:1.0: power on to power good time: 20ms
hub 1-0:1.0: local power source is good
hub 1-0:1.0: trying to enable port power on non-switchable hub
drivers/usb/core/inode.c: creating file '001'
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
ohci_hcd: block sizes: ed 64 td 64
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
drivers/usb/core/inode.c: creating file '002'
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: detected 2 ports
uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1d.0: Performing full reset
uhci_hcd 0000:00:1d.0: supports USB remote wakeup
uhci_hcd 0000:00:1d.0: irq 16, io base 0x00001820
usb usb2: default language 0x0409
usb usb2: udev 1, busnum 2, minor = 128
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: UHCI Host Controller
usb usb2: Manufacturer: Linux 3.2.0-rc2+ uhci_hcd
usb usb2: SerialNumber: 0000:00:1d.0
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
ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.0
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
drivers/usb/core/inode.c: creating file '003'
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: detected 2 ports
uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1d.1: Performing full reset
uhci_hcd 0000:00:1d.1: supports USB remote wakeup
uhci_hcd 0000:00:1d.1: irq 17, io base 0x00001840
usb usb3: default language 0x0409
usb usb3: udev 1, busnum 3, minor = 256
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 3.2.0-rc2+ uhci_hcd
usb usb3: SerialNumber: 0000:00:1d.1
usb usb3: usb_probe_device
usb usb3: configuration #1 chosen from 1 choice
usb usb3: adding 3-0:1.0 (config #1, interface 0)
hub 3-0:1.0: usb_probe_interface
hub 3-0:1.0: usb_probe_interface - got id
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
hub 3-0:1.0: standalone hub
hub 3-0:1.0: no power switching (usb 1.0)
hub 3-0:1.0: individual port over-current protection
hub 3-0:1.0: power on to power good time: 2ms
hub 3-0:1.0: local power source is good
hub 3-0:1.0: trying to enable port power on non-switchable hub
drivers/usb/core/inode.c: creating file '001'
ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.1
uhci_hcd 0000:00:1d.2: power state changed by ACPI to D0
uhci_hcd 0000:00:1d.2: power state changed by ACPI to D0
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
drivers/usb/core/inode.c: creating file '004'
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: detected 2 ports
uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1d.2: Performing full reset
uhci_hcd 0000:00:1d.2: supports USB remote wakeup
uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001860
usb usb4: default language 0x0409
usb usb4: udev 1, busnum 4, minor = 384
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 3.2.0-rc2+ uhci_hcd
usb usb4: SerialNumber: 0000:00:1d.2
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
ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.2
uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1d.3: setting latency timer to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
drivers/usb/core/inode.c: creating file '005'
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.3: detected 2 ports
uhci_hcd 0000:00:1d.3: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1d.3: Performing full reset
uhci_hcd 0000:00:1d.3: irq 19, io base 0x00001880
usb usb5: default language 0x0409
usb usb5: udev 1, busnum 5, minor = 512
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 3.2.0-rc2+ uhci_hcd
usb usb5: SerialNumber: 0000:00:1d.3
ehci_hcd 0000:00:1d.7: GetStatus port:7 status 001803 0  ACK POWER sig=j CSC CONNECT
hub 1-0:1.0: port 7: status 0501 change 0001
ehci_hcd 0000:00:1d.7: GetStatus port:8 status 001803 0  ACK POWER sig=j CSC CONNECT
hub 1-0:1.0: port 8: status 0501 change 0001
usb usb5: usb_probe_device
usb usb5: configuration #1 chosen from 1 choice
usb usb5: adding 5-0:1.0 (config #1, interface 0)
hub 5-0:1.0: usb_probe_interface
hub 5-0:1.0: usb_probe_interface - got id
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
hub 5-0:1.0: standalone hub
hub 5-0:1.0: no power switching (usb 1.0)
hub 5-0:1.0: individual port over-current protection
hub 5-0:1.0: power on to power good time: 2ms
hub 5-0:1.0: local power source is good
hub 5-0:1.0: trying to enable port power on non-switchable hub
drivers/usb/core/inode.c: creating file '001'
ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.3
usbcore: registered new interface driver cdc_acm
cdc_acm: USB Abstract Control Model driver for USB modems and ISDN adapters
usbcore: registered new interface driver usblp
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usbcore: registered new interface driver ums-sddr09
usbcore: registered new interface driver usbserial
USB Serial support registered for generic
hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0000
usbcore: registered new interface driver usbserial_generic
usbserial: USB Serial Driver core
USB Serial support registered for FTDI USB Serial Device
usbcore: registered new interface driver ftdi_sio
ftdi_sio: v1.6.0:USB FTDI Serial Converters Driver
USB Serial support registered for GSM modem (1-port)
usbcore: registered new interface driver option
option: v0.7.2:USB Driver for GSM modems
USB Serial support registered for pl2303
usbcore: registered new interface driver pl2303
pl2303: Prolific PL2303 USB to serial adaptor driver
driver ftdi-elan
usbcore: registered new interface driver ftdi-elan
hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mousedev: PS/2 mouse device common for all mice
input: PC Speaker as /devices/platform/pcspkr/input/input4
rtc_cmos 00:07: RTC can wake from S4
hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
Linux video capture interface: v2.00
usbcore: registered new interface driver uvcvideo
USB Video Class driver (1.1.1)
md: raid0 personality registered for level 0
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input5
md: raid1 personality registered for level 1
hub 1-0:1.0: state 7 ports 8 chg 0180 evt 0000
hub 1-0:1.0: port 7, status 0501, change 0000, 480 Mb/s
device-mapper: ioctl: 4.22.0-ioctl (2011-10-19) initialised: dm-devel@redhat.com
Bluetooth: HCI UART driver ver 2.2
uhci_hcd 0000:00:1d.3: port 1 portsc 008a,00
uhci_hcd 0000:00:1d.3: port 2 portsc 008a,00
Bluetooth: HCI H4 protocol initialized
Bluetooth: HCI BCSP protocol initialized
Bluetooth: Generic Bluetooth USB driver ver 0.6
usbcore: registered new interface driver btusb
EDAC MC: Ver: 2.1.0
cpuidle: using governor ladder
cpuidle: using governor menu
sdhci: Secure Digital Host Controller Interface driver
sdhci: Copyright(c) Pierre Ossman
sdhci-pci 0000:15:00.2: SDHCI controller found [1180:0822] (rev 18)
sdhci-pci 0000:15:00.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
sdhci-pci 0000:15:00.2: setting latency timer to 64
Registered led device: mmc0::
mmc0: SDHCI controller on PCI [0000:15:00.2] using DMA
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
ehci_hcd 0000:00:1d.7: port 7 full speed --> companion
ehci_hcd 0000:00:1d.7: GetStatus port:7 status 003801 0  ACK POWER OWNER sig=j CONNECT
hub 1-0:1.0: port 7 not reset yet, waiting 50ms
thinkpad_acpi: ThinkPad ACPI Extras v0.24
thinkpad_acpi: http://ibm-acpi.sf.net/
thinkpad_acpi: ThinkPad BIOS 7BETD3WW (2.14 ), EC 7BHT40WW-1.13
thinkpad_acpi: Lenovo ThinkPad X60, model 17097HU
thinkpad_acpi: WARNING: Outdated ThinkPad BIOS/EC firmware
thinkpad_acpi: WARNING: This firmware may be missing critical bug fixes and/or important features
thinkpad_acpi: detected a 8-level brightness capable ThinkPad
thinkpad_acpi: ACPI backlight control delay disabled
thinkpad_acpi: radio switch found; radios are enabled
thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio is unblocked
Registered led device: tpacpi::thinklight
Registered led device: tpacpi::power
Registered led device: tpacpi:orange:batt
Registered led device: tpacpi:green:batt
Registered led device: tpacpi::dock_active
Registered led device: tpacpi::bay_active
Registered led device: tpacpi::dock_batt
Registered led device: tpacpi::unknown_led
Registered led device: tpacpi::standby
Registered led device: tpacpi::dock_status1
Registered led device: tpacpi::dock_status2
Registered led device: tpacpi::unknown_led2
Registered led device: tpacpi::unknown_led3
Registered led device: tpacpi::thinkvantage
thinkpad_acpi: warning: userspace override of important firmware LEDs is enabled
ehci_hcd 0000:00:1d.7: GetStatus port:7 status 003002 0  ACK POWER OWNER sig=se0 CSC
hub 1-0:1.0: port 8, status 0501, change 0000, 480 Mb/s
thinkpad_acpi: Standard ACPI backlight interface available, not loading native one
thinkpad_acpi: volume: disabled as there is no ALSA support in this kernel
input: ThinkPad Extra Buttons as /devices/platform/thinkpad_acpi/input/input6
snd_hda_intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
hda_intel: probe_mask set to 0x1 for device 17aa:2010
snd_hda_intel 0000:00:1b.0: setting latency timer to 64
ehci_hcd 0000:00:1d.7: port 8 full speed --> companion
ehci_hcd 0000:00:1d.7: GetStatus port:8 status 003801 0  ACK POWER OWNER sig=j CONNECT
hub 1-0:1.0: port 8 not reset yet, waiting 50ms
usbcore: registered new interface driver snd-usb-audio
ALSA device list:
  #0: HDA Intel at 0xee240000 irq 17
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
ip_tables: (C) 2000-2006 Netfilter Core Team
TCP cubic registered
NET: Registered protocol family 17
input: PS/2 Generic Mouse as /devices/platform/i8042/serio1/input/input7
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM ver 1.11
Bluetooth: BNEP (Ethernet Emulation) ver 1.3
Bluetooth: BNEP filters: protocol multicast
mmc0: new SD card at address 913e
Bluetooth: HIDP (Human Interface Emulation) ver 1.2
mmcblk0: mmc0:913e SU01G 968 MiB 
lib80211: common routines for IEEE802.11 drivers
lib80211_crypt: registered algorithm 'NULL'
Using IPI No-Shortcut mode
 mmcblk0: p1
ehci_hcd 0000:00:1d.7: GetStatus port:8 status 003002 0  ACK POWER OWNER sig=se0 CSC
hub 1-0:1.0: state 7 ports 8 chg 0000 evt 0100
hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0002
uhci_hcd 0000:00:1d.3: port 1 portsc 0093,00
hub 5-0:1.0: port 1, status 0101, change 0001, 12 Mb/s
PM: Checking hibernation image partition /dev/sda1
PM: Hibernation image partition 8:1 present
PM: Looking for hibernation image.
PM: Image not found (code -22)
PM: Hibernation image not present or could not be loaded.
rtc_cmos 00:07: setting system clock to 2011-11-23 09:28:21 UTC (1322040501)
md: Waiting for all devices to be available before autodetect
md: If you don't use raid, use raid=noautodetect
md: Autodetecting RAID arrays.
md: Scanned 0 and added 0 devices.
md: autorun ...
md: ... autorun DONE.
hub 5-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x101
EXT3-fs (sda4): recovery required on readonly filesystem
EXT3-fs (sda4): write access will be enabled during recovery
usb 5-1: new full-speed USB device number 2 using uhci_hcd
usb 5-1: skipped 1 descriptor after interface
usb 5-1: default language 0x0409
usb 5-1: udev 2, busnum 5, minor = 513
usb 5-1: New USB device found, idVendor=0a5c, idProduct=2110
usb 5-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 5-1: Product: BCM2045B
usb 5-1: Manufacturer: Broadcom Corp
usb 5-1: usb_probe_device
usb 5-1: configuration #1 chosen from 1 choice
usb 5-1: adding 5-1:1.0 (config #1, interface 0)
usbserial_generic 5-1:1.0: usb_probe_interface
usbserial_generic 5-1:1.0: usb_probe_interface - got id
btusb 5-1:1.0: usb_probe_interface
btusb 5-1:1.0: usb_probe_interface - got id
uhci_hcd 0000:00:1d.3: reserve dev 2 ep81-INT, period 1, phase 0, 23 us
usb 5-1: adding 5-1:1.1 (config #1, interface 1)
usb 5-1: adding 5-1:1.2 (config #1, interface 2)
usbserial_generic 5-1:1.2: usb_probe_interface
usbserial_generic 5-1:1.2: usb_probe_interface - got id
btusb 5-1:1.2: usb_probe_interface
btusb 5-1:1.2: usb_probe_interface - got id
usb 5-1: adding 5-1:1.3 (config #1, interface 3)
usbserial_generic 5-1:1.3: usb_probe_interface
usbserial_generic 5-1:1.3: usb_probe_interface - got id
btusb 5-1:1.3: usb_probe_interface
btusb 5-1:1.3: usb_probe_interface - got id
drivers/usb/core/inode.c: creating file '002'
uhci_hcd 0000:00:1d.3: port 2 portsc 0093,00
hub 5-0:1.0: port 2, status 0101, change 0001, 12 Mb/s
hub 5-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x101
usb usb2: suspend_rh (auto-stop)
usb usb3: suspend_rh (auto-stop)
usb 5-2: new full-speed USB device number 3 using uhci_hcd
usb 5-2: ep0 maxpacket = 8
usb 5-2: default language 0x0409
usb 5-2: udev 3, busnum 5, minor = 514
usb 5-2: New USB device found, idVendor=0483, idProduct=2016
usb 5-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 5-2: Product: Biometric Coprocessor
usb 5-2: Manufacturer: STMicroelectronics
usb 5-2: usb_probe_device
usb 5-2: configuration #1 chosen from 1 choice
usb 5-2: adding 5-2:1.0 (config #1, interface 0)
usbserial_generic 5-2:1.0: usb_probe_interface
usbserial_generic 5-2:1.0: usb_probe_interface - got id
drivers/usb/core/inode.c: creating file '003'
hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
usb usb4: suspend_rh (auto-stop)
hub 2-0:1.0: hub_suspend
usb usb2: bus auto-suspend, wakeup 1
usb usb2: suspend_rh
hub 3-0:1.0: hub_suspend
usb usb3: bus auto-suspend, wakeup 1
usb usb3: suspend_rh
hub 4-0:1.0: hub_suspend
usb usb4: bus auto-suspend, wakeup 1
usb usb4: suspend_rh
hub 1-0:1.0: hub_suspend
usb usb1: bus auto-suspend, wakeup 1
ehci_hcd 0000:00:1d.7: suspend root hub
uhci_hcd 0000:00:1d.3: release dev 2 ep81-INT, period 1, phase 0, 23 us
kjournald starting.  Commit interval 5 seconds
EXT3-fs (sda4): orphan cleanup on readonly fs
ext3_orphan_cleanup: deleting unreferenced inode 366253
ext3_orphan_cleanup: deleting unreferenced inode 550714
ext3_orphan_cleanup: deleting unreferenced inode 550713
ext3_orphan_cleanup: deleting unreferenced inode 550712
ext3_orphan_cleanup: deleting unreferenced inode 550711
ext3_orphan_cleanup: deleting unreferenced inode 550710
ext3_orphan_cleanup: deleting unreferenced inode 550709
ext3_orphan_cleanup: deleting unreferenced inode 550708
ext3_orphan_cleanup: deleting unreferenced inode 550707
ext3_orphan_cleanup: deleting unreferenced inode 550706
ext3_orphan_cleanup: deleting unreferenced inode 550705
ext3_orphan_cleanup: deleting unreferenced inode 550704
ext3_orphan_cleanup: deleting unreferenced inode 550703
ext3_orphan_cleanup: deleting unreferenced inode 550702
ext3_orphan_cleanup: deleting unreferenced inode 550701
ext3_orphan_cleanup: deleting unreferenced inode 550700
ext3_orphan_cleanup: deleting unreferenced inode 550699
ext3_orphan_cleanup: deleting unreferenced inode 550698
ext3_orphan_cleanup: deleting unreferenced inode 550697
ext3_orphan_cleanup: deleting unreferenced inode 550696
ext3_orphan_cleanup: deleting unreferenced inode 550695
ext3_orphan_cleanup: deleting unreferenced inode 550694
ext3_orphan_cleanup: deleting unreferenced inode 638821
ext3_orphan_cleanup: deleting unreferenced inode 550692
ext3_orphan_cleanup: deleting unreferenced inode 550691
ext3_orphan_cleanup: deleting unreferenced inode 550690
ext3_orphan_cleanup: deleting unreferenced inode 638820
ext3_orphan_cleanup: deleting unreferenced inode 369608
ext3_orphan_cleanup: deleting unreferenced inode 366786
ext3_orphan_cleanup: deleting unreferenced inode 366785
ext3_orphan_cleanup: deleting unreferenced inode 550689
ext3_orphan_cleanup: deleting unreferenced inode 550688
ext3_orphan_cleanup: deleting unreferenced inode 550687
ext3_orphan_cleanup: deleting unreferenced inode 550686
ext3_orphan_cleanup: deleting unreferenced inode 638818
ext3_orphan_cleanup: deleting unreferenced inode 638817
ext3_orphan_cleanup: deleting unreferenced inode 638816
ext3_orphan_cleanup: deleting unreferenced inode 638815
ext3_orphan_cleanup: deleting unreferenced inode 638809
ext3_orphan_cleanup: deleting unreferenced inode 638700
ext3_orphan_cleanup: deleting unreferenced inode 636601
ext3_orphan_cleanup: deleting unreferenced inode 366252
ext3_orphan_cleanup: deleting unreferenced inode 366193
ext3_orphan_cleanup: deleting unreferenced inode 580760
EXT3-fs (sda4): 44 orphan inodes deleted
EXT3-fs (sda4): recovery complete
EXT3-fs (sda4): mounted filesystem with ordered data mode
VFS: Mounted root (ext3 filesystem) readonly on device 8:4.
debug: unmapping init memory c0b6a000..c0bd6000
Write protecting the kernel text: 6564k
Write protecting the kernel read-only data: 2644k
Failed to execute /tmp/swsusp-init.  Attempting defaults...
EXT3-fs (sda4): using internal journal
Adding 779148k swap on /dev/sda1.  Priority:-1 extents:1 across:779148k 
kjournald starting.  Commit interval 5 seconds
EXT3-fs (sda2): using internal journal
EXT3-fs (sda2): mounted filesystem with ordered data mode
sshd (1840): /proc/1840/oom_adj is deprecated, please use /proc/1840/oom_score_adj instead.
coda_read_super: Bad mount data
coda_read_super: device index: 0
coda_read_super: rootfid is (01234567.ffffffff.08051b18.00000000)
coda: Unexpected interruption.
Failure of coda_cnode_make for root: error -4
iwl3945 0000:03:00.0: loaded firmware version 15.32.2.9
wlan0: authenticate with 00:11:95:05:30:d7 (try 1)
wlan0: authenticated
wlan0: associate with 00:11:95:05:30:d7 (try 1)
wlan0: RX AssocResp from 00:11:95:05:30:d7 (capab=0x401 status=0 aid=13)
wlan0: associated
CE: hpet increased min_delta_ns to 20113 nsec
mmc0: card 913e removed
PM: Marking nosave pages: 000000000009f000 - 0000000000100000
PM: Basic memory bitmaps created
PM: Syncing filesystems ... done.
Freezing user space processes ... (elapsed 0.01 seconds) done.
PM: Preallocating image memory... 
wlan0: deauthenticated from 00:11:95:05:30:d7 (Reason: 3)
cfg80211: Calling CRDA to update world regulatory domain
done (allocated 410717 pages)
PM: Allocated 1642868 kbytes in 6.83 seconds (240.53 MB/s)
Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
hub 5-0:1.0: hub_suspend
usb usb5: bus suspend, wakeup 0
usb usb5: suspend_rh
sd 0:0:0:0: [sda] Synchronizing SCSI cache
------------[ cut here ]------------
WARNING: at drivers/pci/pci-driver.c:607 pci_has_legacy_pm_support+0x2d/0x60()
Hardware name: 17097HU
Modules linked in:
Pid: 9881, comm: kworker/u:4 Not tainted 3.2.0-rc2+ #191
Call Trace:
 [<c023581d>] warn_slowpath_common+0x6d/0xa0
 [<c03edaed>] ? pci_has_legacy_pm_support+0x2d/0x60
 [<c03edaed>] ? pci_has_legacy_pm_support+0x2d/0x60
 [<c023586d>] warn_slowpath_null+0x1d/0x20
 [<c03edaed>] pci_has_legacy_pm_support+0x2d/0x60
 [<c03ee21c>] pci_pm_freeze+0x2c/0xa0
 [<c03ee1f0>] ? pci_pm_poweroff+0xa0/0xa0
 [<c04da451>] pm_op+0x151/0x1d0
 [<c04dab8d>] __device_suspend+0x22d/0x270
 [<c04dae5a>] async_suspend+0x1a/0x90
 [<c0255d5f>] async_run_entry_fn+0x5f/0x150
 [<c024b885>] process_one_work+0x185/0x3e0
 [<c024b819>] ? process_one_work+0x119/0x3e0
 [<c0255d00>] ? async_schedule+0x10/0x10
 [<c024bde8>] worker_thread+0x118/0x330
 [<c024bcd0>] ? rescuer_thread+0x1f0/0x1f0
 [<c024f6b4>] kthread+0x74/0x80
 [<c024f640>] ? __init_kthread_worker+0x60/0x60
 [<c0867b36>] kernel_thread_helper+0x6/0xd
---[ end trace d0431b5a12e598a9 ]---
e1000e 0000:02:00.0: PCI INT A disabled
e1000e 0000:02:00.0: PME# enabled
pcieport 0000:00:1c.0: wake-up capability enabled by ACPI
ACPI handle has no context!
sdhci-pci 0000:15:00.2: PCI INT C disabled
ACPI handle has no context!
ata6: port disabled--ignoring
ata_piix 0000:00:1f.1: PCI INT C disabled
ahci 0000:00:1f.2: PCI INT B disabled
snd_hda_intel 0000:00:1b.0: PCI INT B disabled
PM: freeze of devices complete after 145.622 msecs
------------[ cut here ]------------
WARNING: at drivers/pci/pci-driver.c:607 pci_has_legacy_pm_support+0x2d/0x60()
Hardware name: 17097HU
Modules linked in:
Pid: 9871, comm: hibernate Tainted: G        W    3.2.0-rc2+ #191
Call Trace:
 [<c023581d>] warn_slowpath_common+0x6d/0xa0
 [<c03edaed>] ? pci_has_legacy_pm_support+0x2d/0x60
 [<c03edaed>] ? pci_has_legacy_pm_support+0x2d/0x60
 [<c023586d>] warn_slowpath_null+0x1d/0x20
 [<c03edaed>] pci_has_legacy_pm_support+0x2d/0x60
 [<c03edc43>] pci_pm_freeze_noirq+0x23/0xb0
 [<c04da877>] pm_noirq_op+0x177/0x260
 [<c04db5ea>] dpm_suspend_noirq+0xda/0x270
 [<c026ecf6>] hibernation_snapshot+0xe6/0x310
 [<c026dcff>] ? freeze_processes+0x2f/0x60
 [<c026efe7>] hibernate+0xc7/0x1e0
 [<c026d180>] ? pm_async_store+0x40/0x40
 [<c026d26b>] state_store+0xeb/0x100
 [<c026d180>] ? pm_async_store+0x40/0x40
 [<c03ce630>] kobj_attr_store+0x20/0x30
 [<c030c1c9>] sysfs_write_file+0x99/0xf0
 [<c02bcaea>] vfs_write+0x9a/0x140
 [<c030c130>] ? sysfs_open_file+0x1e0/0x1e0
 [<c02bcc5d>] sys_write+0x3d/0x70
 [<c0867610>] sysenter_do_call+0x12/0x31
---[ end trace d0431b5a12e598aa ]---
PM: late freeze of devices complete after 106.461 msecs
ACPI: Preparing to enter system sleep state S4
PM: Saving platform NVS memory
Disabling non-boot CPUs ...
CPU 1 is now offline
lockdep: fixing up alternatives.
Extended CMOS year: 2000
PM: Creating hibernation image:
PM: Need to copy 103177 pages
PM: Normal pages needed: 31593 + 1024, available pages: 195477
PM: Restoring platform NVS memory
Extended CMOS year: 2000
Enabling non-boot CPUs ...
lockdep: fixing up alternatives.
Booting Node 0 Processor 1 APIC 0x1
smpboot cpu 1: start_ip = 9b000
Initializing CPU#1
Calibrating delay loop (skipped) already calibrated this CPU
Disabled fast string operations
NMI watchdog enabled, takes one hw-pmu counter.
CPU1 is up
ACPI: Waking up from system sleep state S4
snd_hda_intel 0000:00:1b.0: BAR 0: set to [mem 0xee240000-0xee243fff 64bit] (PCI address [0xee240000-0xee243fff])
snd_hda_intel 0000:00:1b.0: restoring config space at offset 0xf (was 0x200, writing 0x20b)
snd_hda_intel 0000:00:1b.0: restoring config space at offset 0x3 (was 0x0, writing 0x10)
snd_hda_intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100102)
uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
uhci_hcd 0000:00:1d.2: power state changed by ACPI to D0
uhci_hcd 0000:00:1d.2: power state changed by ACPI to D0
uhci_hcd 0000:00:1d.2: power state changed by ACPI to D0
uhci_hcd 0000:00:1d.2: power state changed by ACPI to D0
ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
ata_piix 0000:00:1f.1: restoring config space at offset 0x1 (was 0x2880001, writing 0x2880005)
ahci 0000:00:1f.2: restoring config space at offset 0x1 (was 0x2b00003, writing 0x2b00007)
e1000e 0000:02:00.0: BAR 0: set to [mem 0xee000000-0xee01ffff] (PCI address [0xee000000-0xee01ffff])
e1000e 0000:02:00.0: BAR 2: set to [io  0x2000-0x201f] (PCI address [0x2000-0x201f])
e1000e 0000:02:00.0: restoring config space at offset 0xf (was 0x100, writing 0x10b)
e1000e 0000:02:00.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100107)
sdhci-pci 0000:15:00.2: BAR 0: set to [mem 0xe4301800-0xe43018ff] (PCI address [0xe4301800-0xe43018ff])
sdhci-pci 0000:15:00.2: restoring config space at offset 0x3 (was 0x800000, writing 0x804000)
sdhci-pci 0000:15:00.2: restoring config space at offset 0x1 (was 0x2100000, writing 0x2100006)
------------[ cut here ]------------
WARNING: at drivers/pci/pci-driver.c:607 pci_has_legacy_pm_support+0x2d/0x60()
Hardware name: 17097HU
Modules linked in:
Pid: 9871, comm: hibernate Tainted: G        W    3.2.0-rc2+ #191
Call Trace:
 [<c023581d>] warn_slowpath_common+0x6d/0xa0
 [<c03edaed>] ? pci_has_legacy_pm_support+0x2d/0x60
 [<c03edaed>] ? pci_has_legacy_pm_support+0x2d/0x60
 [<c023586d>] warn_slowpath_null+0x1d/0x20
 [<c03edaed>] pci_has_legacy_pm_support+0x2d/0x60
 [<c03edb4a>] pci_pm_restore_noirq+0x2a/0x80
 [<c04da8a2>] pm_noirq_op+0x1a2/0x260
 [<c04db4fb>] dpm_resume_noirq+0x21b/0x230
 [<c026ed55>] hibernation_snapshot+0x145/0x310
 [<c026dcff>] ? freeze_processes+0x2f/0x60
 [<c026efe7>] hibernate+0xc7/0x1e0
 [<c026d180>] ? pm_async_store+0x40/0x40
 [<c026d26b>] state_store+0xeb/0x100
 [<c026d180>] ? pm_async_store+0x40/0x40
 [<c03ce630>] kobj_attr_store+0x20/0x30
 [<c030c1c9>] sysfs_write_file+0x99/0xf0
 [<c02bcaea>] vfs_write+0x9a/0x140
 [<c030c130>] ? sysfs_open_file+0x1e0/0x1e0
 [<c02bcc5d>] sys_write+0x3d/0x70
 [<c0867610>] sysenter_do_call+0x12/0x31
---[ end trace d0431b5a12e598ab ]---
PM: early restore of devices complete after 204.841 msecs
i915 0000:00:02.0: setting latency timer to 64
snd_hda_intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
snd_hda_intel 0000:00:1b.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: uhci_pci_resume
usb usb2: root hub lost power or was reset
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: uhci_pci_resume
usb usb3: root hub lost power or was reset
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: uhci_pci_resume
usb usb4: root hub lost power or was reset
uhci_hcd 0000:00:1d.3: setting latency timer to 64
uhci_hcd 0000:00:1d.3: uhci_pci_resume
usb usb5: root hub lost power or was reset
ehci_hcd 0000:00:1d.7: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
ata_piix 0000:00:1f.1: PCI INT C -> GSI 16 (level, low) -> IRQ 16
ata_piix 0000:00:1f.1: setting latency timer to 64
ahci 0000:00:1f.2: PCI INT B -> GSI 16 (level, low) -> IRQ 16
ahci 0000:00:1f.2: setting latency timer to 64
pcieport 0000:00:1c.0: wake-up capability disabled by ACPI
e1000e 0000:02:00.0: PME# disabled
e1000e 0000:02:00.0: Disabling ASPM L0s L1
------------[ cut here ]------------
usb usb1: root hub lost power or was reset
ehci_hcd 0000:00:1d.7: reset command 0010002 (park)=0 ithresh=1 period=1024 Reset HALT
WARNING: at drivers/pci/pci-driver.c:607 pci_has_legacy_pm_support+0x2d/0x60()
ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
sd 0:0:0:0: [sda] Starting disk
ata6: port disabled--ignoring
usb usb1: usb resume
ehci_hcd 0000:00:1d.7: resume root hub after power loss
usb usb2: usb resume
usb usb2: wakeup_rh
usb usb3: usb resume
usb usb3: wakeup_rh
usb usb4: usb resume
usb usb4: wakeup_rh
usb usb5: usb resume
usb usb5: wakeup_rh
Hardware name: 17097HU
Modules linked in:
Pid: 9882, comm: kworker/u:5 Tainted: G        W    3.2.0-rc2+ #191
Call Trace:
hub 2-0:1.0: hub_reset_resume
 [<c023581d>] warn_slowpath_common+0x6d/0xa0
hub 2-0:1.0: trying to enable port power on non-switchable hub
hub 3-0:1.0: hub_reset_resume
hub 3-0:1.0: trying to enable port power on non-switchable hub
hub 4-0:1.0: hub_reset_resume
hub 4-0:1.0: trying to enable port power on non-switchable hub
hub 5-0:1.0: hub_reset_resume
hub 5-0:1.0: trying to enable port power on non-switchable hub
 [<c03edaed>] ? pci_has_legacy_pm_support+0x2d/0x60
 [<c03edaed>] ? pci_has_legacy_pm_support+0x2d/0x60
 [<c023586d>] warn_slowpath_null+0x1d/0x20
 [<c03edaed>] pci_has_legacy_pm_support+0x2d/0x60
 [<c03edfe5>] pci_pm_restore+0x35/0x90
 [<c03edfb0>] ? pci_legacy_resume+0x60/0x60
 [<c04da4b1>] pm_op+0x1b1/0x1d0
 [<c04dc9e3>] ? pm_runtime_enable+0x43/0x70
 [<c04db04f>] device_resume+0x17f/0x1c0
 [<c04db2b9>] async_resume+0x19/0x40
 [<c0255d5f>] async_run_entry_fn+0x5f/0x150
 [<c024b885>] process_one_work+0x185/0x3e0
 [<c024b819>] ? process_one_work+0x119/0x3e0
 [<c0255d00>] ? async_schedule+0x10/0x10
 [<c024bde8>] worker_thread+0x118/0x330
 [<c024bcd0>] ? rescuer_thread+0x1f0/0x1f0
 [<c024f6b4>] kthread+0x74/0x80
 [<c024f640>] ? __init_kthread_worker+0x60/0x60
 [<c0867b36>] kernel_thread_helper+0x6/0xd
---[ end trace d0431b5a12e598ac ]---
sdhci-pci 0000:15:00.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
uhci_hcd 0000:00:1d.3: port 1 portsc 008a,00
hub 5-0:1.0: port 1: status 0100 change 0003
uhci_hcd 0000:00:1d.3: port 2 portsc 008a,00
hub 5-0:1.0: port 2: status 0100 change 0003
ehci_hcd 0000:00:1d.7: port 8 full speed --> companion
ehci_hcd 0000:00:1d.7: GetStatus port:8 status 003801 0  ACK POWER OWNER sig=j CONNECT
ehci_hcd 0000:00:1d.7: port 7 full speed --> companion
ehci_hcd 0000:00:1d.7: GetStatus port:7 status 003801 0  ACK POWER OWNER sig=j CONNECT
hub 1-0:1.0: hub_reset_resume
hub 1-0:1.0: trying to enable port power on non-switchable hub
ehci_hcd 0000:00:1d.7: GetStatus port:7 status 003002 0  ACK POWER OWNER sig=se0 CSC
ehci_hcd 0000:00:1d.7: GetStatus port:8 status 003002 0  ACK POWER OWNER sig=se0 CSC
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
uhci_hcd 0000:00:1d.3: port 1 portsc 0093,00
usb 5-1: finish reset-resume
uhci_hcd 0000:00:1d.3: port 2 portsc 0093,00
usb 5-2: finish reset-resume
ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
ata1.00: configured for UDMA/133
usb 5-1: reset full-speed USB device number 2 using uhci_hcd
Extended CMOS year: 2000
thinkpad_acpi: ACPI backlight control delay disabled
btusb 5-1:1.0: no reset_resume for driver btusb?
btusb 5-1:1.1: no reset_resume for driver btusb?
btusb 5-1:1.0: forced unbind
usb 5-2: reset full-speed USB device number 3 using uhci_hcd
usb 5-2: ep0 maxpacket = 8
PM: restore of devices complete after 905.004 msecs
usbserial_generic 5-1:1.0: usb_probe_interface
usbserial_generic 5-1:1.0: usb_probe_interface - got id
btusb 5-1:1.0: usb_probe_interface
btusb 5-1:1.0: usb_probe_interface - got id
uhci_hcd 0000:00:1d.3: reserve dev 2 ep81-INT, period 1, phase 0, 23 us
PM: Image restored successfully.
Restarting tasks ... 
hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0000
hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
hub 5-0:1.0: state 7 ports 2 chg 0006 evt 0006
hub 5-0:1.0: port 1, status 0103, change 0000, 12 Mb/s
hub 5-0:1.0: port 2, status 0103, change 0000, 12 Mb/s
hub 1-0:1.0: state 7 ports 8 chg 0000 evt 0000
done.
PM: Basic memory bitmaps freed
video LNXVIDEO:00: Restoring backlight state
mmc0: new SD card at address 913e
mmcblk0: mmc0:913e SU01G 968 MiB 
 mmcblk0: p1
usb usb2: suspend_rh (auto-stop)
usb usb3: suspend_rh (auto-stop)
usb usb4: suspend_rh (auto-stop)
uhci_hcd 0000:00:1d.3: release dev 2 ep81-INT, period 1, phase 0, 23 us
hub 2-0:1.0: hub_suspend
usb usb2: bus auto-suspend, wakeup 1
usb usb2: suspend_rh
hub 4-0:1.0: hub_suspend
usb usb4: bus auto-suspend, wakeup 1
usb usb4: suspend_rh
hub 3-0:1.0: hub_suspend
usb usb3: bus auto-suspend, wakeup 1
usb usb3: suspend_rh
hub 1-0:1.0: hub_suspend
usb usb1: bus auto-suspend, wakeup 1
ehci_hcd 0000:00:1d.7: suspend root hub

--gBBFr7Ir9EOA20Yy--

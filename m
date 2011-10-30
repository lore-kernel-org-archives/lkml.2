Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934211Ab1J3Pp0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 11:45:26 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:34865 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934160Ab1J3PpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 11:45:04 -0400
Message-ID: <4EAD70F6.1050704@gmail.com>
Date: Sun, 30 Oct 2011 12:44:54 -0300
From: "Tomas M." <tmezzadra@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20111001 Thunderbird/7.0.1
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Chris Ball <cjb@laptop.org>
Subject: [sdhci] laptop hangs at random after suspend  / resume
Content-Type: multipart/mixed;
 boundary="------------010201040008010006070706"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010201040008010006070706
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

this module has the tendency of hanging my laptop after suspend /resume. 
(random issue).

blacklisting the module makes the problem go away.

I never bothered to report this since it was an isolated issue on a 
laptop where this module was problematic in the past.. [bug 9905 from 
bugzilla]

but now ive found someone with different hardware that is likely to have 
this issue too: https://bbs.archlinux.org/viewtopic.php?pid=1010070

i would like to help debug this issue. but i would not know where to 
start. the hangs happen after several hours of usage / multimple 
suspend-resume cycles. usually takes over 12hs to happen.

attaching a dmesg + lspci -vvnn in casie it helps...

please CC me in replies since im not subscribed to the list.






--------------010201040008010006070706
Content-Type: text/plain;
 name="dmesg.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg.txt"

Linux version 3.1.0-GIT (tomas@emmet) (gcc version 4.6.1 20110819 (prerelease) (GCC) ) #72 SMP PREEMPT Tue Oct 25 10:45:46 ART 2011
Disabled fast string operations
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007f7c0000 (usable)
 BIOS-e820: 000000007f7c0000 - 000000007f7ce000 (ACPI data)
 BIOS-e820: 000000007f7ce000 - 000000007f800000 (ACPI NVS)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
DMI present.
DMI: Everex Systems, Inc. Everex StepNote Series/Everex StepNote Series, BIOS 080013  03/20/2007
e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
last_pfn = 0x7f7c0 max_arch_pfn = 0x100000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-DFFFF uncachable
  E0000-EFFFF write-through
  F0000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 000000000 mask F80000000 write-back
  1 base 07F800000 mask FFF800000 uncachable
  2 disabled
  3 disabled
  4 disabled
  5 disabled
  6 disabled
  7 disabled
PAT not supported by CPU.
found SMP MP-table at [c00ff780] ff780
initial memory mapped : 0 - 01800000
Base memory trampoline at [c009b000] 9b000 size 16384
init_memory_mapping: 0000000000000000-00000000377fe000
 0000000000 - 0000400000 page 4k
 0000400000 - 0037400000 page 2M
 0037400000 - 00377fe000 page 4k
kernel direct mapping tables up to 377fe000 @ 17fb000-1800000
RAMDISK: 7f5e3000 - 7f7b0000
Allocated new RAMDISK: 37631000 - 377fd455
Move RAMDISK from 000000007f5e3000 - 000000007f7af454 to 37631000 - 377fd454
ACPI: RSDP 000f8d30 00014 (v00 ACPIAM)
ACPI: RSDT 7f7c0000 0003C (v01 FICINC FIRST NB 03000720 MSFT 00000097)
ACPI: FACP 7f7c0200 00084 (v02 FICINC OEM-FACP 03000720 MSFT 00000097)
ACPI: DSDT 7f7c05b0 06433 (v01  H12YV H12YV000 00000000 INTL 20050930)
ACPI: FACS 7f7ce000 00040
ACPI: APIC 7f7c0390 0005C (v01 FICINC OEM-APIC 03000720 MSFT 00000097)
ACPI: MCFG 7f7c03f0 0003C (v01 FICINC OEM-MCFG 03000720 MSFT 00000097)
ACPI: SLIC 7f7c0430 00176 (v01 FICINC FIRST NB 03000720 MSFT 00000097)
ACPI: OEMB 7f7ce040 00131 (v01 FICINC AMI_OEMB 03000720 MSFT 00000097)
ACPI: HPET 7f7c69f0 00038 (v01 FICINC OEM_HPET 03000720 MSFT 00000097)
ACPI: Local APIC address 0xfee00000
1151MB HIGHMEM available.
887MB LOWMEM available.
  mapped low ram: 0 - 377fe000
  low ram: 0 - 377fe000
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  Normal   0x00001000 -> 0x000377fe
  HighMem  0x000377fe -> 0x0007f7c0
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000010 -> 0x0000009f
    0: 0x00000100 -> 0x0007f7c0
On node 0 totalpages: 522063
free_area_init_node: node 0, pgdat c143a540, node_mem_map f6640200
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 3951 pages, LIFO batch:0
  Normal zone: 1744 pages used for memmap
  Normal zone: 221486 pages, LIFO batch:31
  HighMem zone: 2304 pages used for memmap
  HighMem zone: 292546 pages, LIFO batch:31
Using APIC driver default
ACPI: PM-Timer IO Port: 0x808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 20 low level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a202 base: 0xfed00000
SMP: Allowing 2 CPUs, 0 hotplug CPUs
nr_irqs_gsi: 40
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
Allocating PCI resources starting at 7f800000 (gap: 7f800000:7f600000)
Booting paravirtualized kernel on bare hardware
setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_node_ids:1
PERCPU: Embedded 12 pages/cpu @f6000000 s25024 r0 d24128 u2097152
pcpu-alloc: s25024 r0 d24128 u2097152 alloc=1*4194304
pcpu-alloc: [0] 0 1 
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 517983
Kernel command line: root=/dev/disk/by-uuid/979e2d41-3d28-4e78-83ec-7b4ed4541dfc resume=/dev/disk/by-uuid/f83924df-3dd0-4b60-a263-54f3fcade1d2 video=VGA-1:1680x1050 reserve=0xffb00000,0x100000 ro quiet
PID hash table entries: 4096 (order: 2, 16384 bytes)
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Initializing CPU#0
Initializing HighMem for node 0 (000377fe:0007f7c0)
Memory: 2063596k/2088704k available (3128k kernel code, 24656k reserved, 1222k data, 412k init, 1179400k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff16000 - 0xfffff000   ( 932 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
    lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
      .init : 0xc1440000 - 0xc14a7000   ( 412 kB)
      .data : 0xc130e295 - 0xc143fc80   (1222 kB)
      .text : 0xc1000000 - 0xc130e295   (3128 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
Preemptible hierarchical RCU implementation.
NR_IRQS:512
CPU 0 irqstacks, hard=f5c0c000 soft=f5c0e000
Console: colour VGA+ 80x25
console [tty0] enabled
hpet clockevent registered
Fast TSC calibration using PIT
Detected 1729.086 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 3458.17 BogoMIPS (lpj=1729086)
pid_max: default: 32768 minimum: 301
Security Framework initialized
Mount-cache hash table entries: 512
Disabled fast string operations
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 6 MCE banks
CPU0: Thermal monitoring enabled (TM1)
using mwait in idle threads.
ACPI: Core revision 20110623
Enabling APIC mode:  Flat.  Using 1 I/O APICs
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Genuine Intel(R) CPU           T2080  @ 1.73GHz stepping 0c
Performance Events: Core events, core PMU driver.
... version:                1
... bit width:              40
... generic registers:      2
... value mask:             000000ffffffffff
... max period:             000000007fffffff
... fixed-purpose events:   0
... event mask:             0000000000000003
CPU 1 irqstacks, hard=f5c64000 soft=f5c66000
Booting Node   0, Processors  #1 Ok.
smpboot cpu 1: start_ip = 9b000
Initializing CPU#1
Disabled fast string operations
Brought up 2 CPUs
Total of 2 processors activated (6916.04 BogoMIPS).
devtmpfs: initialized
PM: Registering ACPI NVS region at 7f7ce000 (204800 bytes)
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
PCI: not using MMCONFIG
PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=4
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: Added _OSI(Module Device)
ACPI: Added _OSI(Processor Device)
ACPI: Added _OSI(3.0 _SCP Extensions)
ACPI: Added _OSI(Processor Aggregator Device)
ACPI: EC: Look up EC in DSDT
ACPI: Executed 1 blocks of module-level executable AML code
ACPI Warning: Incorrect checksum in table [OEMB] - 0x08, should be 0x97 (20110623/tbutils-314)
ACPI: SSDT 7f7d23e0 00661 (v01    AMI   CPU1PM 00000001 INTL 20050930)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT   (null) 00661 (v01    AMI   CPU1PM 00000001 INTL 20050930)
ACPI: SSDT 7f7d2a50 00661 (v01    AMI   CPU2PM 00000001 INTL 20050930)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT   (null) 00661 (v01    AMI   CPU2PM 00000001 INTL 20050930)
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI motherboard resources
PCI: Using MMCONFIG for extended config space
ACPI: EC: GPE = 0x1d, I/O: command/status = 0x66, data = 0x62
ACPI: No dock devices found.
PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7] (ignored)
pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff] (ignored)
pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x000dffff] (ignored)
pci_root PNP0A08:00: host bridge window [mem 0x7f800000-0xdfffffff] (ignored)
pci_root PNP0A08:00: host bridge window [mem 0xf0000000-0xfebfffff] (ignored)
pci 0000:00:00.0: [8086:27a0] type 0 class 0x000600
pci 0000:00:02.0: [8086:27a2] type 0 class 0x000300
pci 0000:00:02.0: reg 10: [mem 0xffe80000-0xffefffff]
pci 0000:00:02.0: reg 14: [io  0xec00-0xec07]
pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff pref]
pci 0000:00:02.0: reg 1c: [mem 0xffe40000-0xffe7ffff]
pci 0000:00:02.1: [8086:27a6] type 0 class 0x000380
pci 0000:00:02.1: reg 10: [mem 0xffd80000-0xffdfffff]
pci 0000:00:1b.0: [8086:27d8] type 0 class 0x000403
pci 0000:00:1b.0: reg 10: [mem 0xffe34000-0xffe37fff 64bit]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: PME# disabled
pci 0000:00:1c.0: [8086:27d0] type 1 class 0x000604
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.1: [8086:27d2] type 1 class 0x000604
pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.1: PME# disabled
pci 0000:00:1d.0: [8086:27c8] type 0 class 0x000c03
pci 0000:00:1d.0: reg 20: [io  0xe880-0xe89f]
pci 0000:00:1d.1: [8086:27c9] type 0 class 0x000c03
pci 0000:00:1d.1: reg 20: [io  0xe800-0xe81f]
pci 0000:00:1d.2: [8086:27ca] type 0 class 0x000c03
pci 0000:00:1d.2: reg 20: [io  0xe480-0xe49f]
pci 0000:00:1d.3: [8086:27cb] type 0 class 0x000c03
pci 0000:00:1d.3: reg 20: [io  0xe400-0xe41f]
pci 0000:00:1d.7: [8086:27cc] type 0 class 0x000c03
pci 0000:00:1d.7: reg 10: [mem 0xffe3b800-0xffe3bbff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1e.0: [8086:2448] type 1 class 0x000604
pci 0000:00:1f.0: [8086:27b9] type 0 class 0x000601
pci 0000:00:1f.2: [8086:27c4] type 0 class 0x000101
pci 0000:00:1f.2: reg 10: [io  0x0000-0x0007]
pci 0000:00:1f.2: reg 14: [io  0x0000-0x0003]
pci 0000:00:1f.2: reg 18: [io  0x0000-0x0007]
pci 0000:00:1f.2: reg 1c: [io  0x0000-0x0003]
pci 0000:00:1f.2: reg 20: [io  0xffa0-0xffaf]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.2: PME# disabled
pci 0000:00:1f.3: [8086:27da] type 0 class 0x000c05
pci 0000:00:1f.3: reg 20: [io  0x0400-0x041f]
pci 0000:00:1c.0: PCI bridge to [bus 01-01]
pci 0000:00:1c.1: PCI bridge to [bus 02-02]
pci 0000:00:1c.1:   bridge window [io  0xa000-0xafff]
pci 0000:00:1c.1:   bridge window [mem 0xfef00000-0xff2fffff]
pci 0000:03:04.0: [10ec:8139] type 0 class 0x000200
pci 0000:03:04.0: reg 10: [io  0xd800-0xd8ff]
pci 0000:03:04.0: reg 14: [mem 0xffbfec00-0xffbfecff]
pci 0000:03:04.0: supports D1 D2
pci 0000:03:04.0: PME# supported from D1 D2 D3hot D3cold
pci 0000:03:04.0: PME# disabled
pci 0000:03:06.0: [1217:00f7] type 0 class 0x000c00
pci 0000:03:06.0: reg 10: [mem 0x00000000-0x00000fff]
pci 0000:03:06.0: reg 14: [mem 0xffbfe000-0xffbfe7ff]
pci 0000:03:06.0: supports D1 D2
pci 0000:03:06.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:03:06.0: PME# disabled
pci 0000:03:06.2: [1217:7120] type 0 class 0x000805
pci 0000:03:06.2: reg 10: [mem 0xffbfe800-0xffbfe8ff]
pci 0000:03:06.2: supports D1 D2
pci 0000:03:06.2: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:03:06.2: PME# disabled
pci 0000:03:06.3: [1217:7130] type 0 class 0x000180
pci 0000:03:06.3: reg 10: [mem 0xffbff000-0xffbfffff]
pci 0000:03:06.3: supports D1 D2
pci 0000:03:06.3: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:03:06.3: PME# disabled
pci 0000:00:1e.0: PCI bridge to [bus 03-04] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0xc000-0xdfff]
pci 0000:00:1e.0:   bridge window [mem 0xff300000-0xffbfffff]
pci 0000:00:1e.0:   bridge window [mem 0xbdf00000-0xbfefffff 64bit pref]
pci 0000:00:1e.0:   bridge window [io  0x0000-0xffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x00000000-0xffffffff] (subtractive decode)
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2._PRT]
 pci0000:00: Requesting ACPI _OSC control (0x1d)
 pci0000:00: ACPI _OSC request failed (AE_NOT_FOUND), returned control mask: 0x1d
ACPI _OSC control for PCIe not granted, disabling ASPM
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 *7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs *3 4 5 6 7 10 11 12 14 15)
vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
vgaarb: bridge control possible 0000:00:02.0
PCI: Using ACPI for IRQ routing
PCI: pci_cache_line_size set to 64 bytes
pci 0000:00:1e.0: address space collision: [mem 0xff300000-0xffbfffff] conflicts with reserved [??? 0xffb00000-0xffbfffff flags 0x80000000]
pci 0000:03:04.0: address space collision: [mem 0xffbfec00-0xffbfecff] conflicts with reserved [??? 0xffb00000-0xffbfffff flags 0x80000000]
pci 0000:03:06.2: address space collision: [mem 0xffbfe800-0xffbfe8ff] conflicts with reserved [??? 0xffb00000-0xffbfffff flags 0x80000000]
pci 0000:03:06.3: address space collision: [mem 0xffbff000-0xffbfffff] conflicts with reserved [??? 0xffb00000-0xffbfffff flags 0x80000000]
pci 0000:03:06.0: address space collision: [mem 0xffbfe000-0xffbfe7ff] conflicts with reserved [??? 0xffb00000-0xffbfffff flags 0x80000000]
reserve RAM buffer: 000000000009fc00 - 000000000009ffff 
reserve RAM buffer: 000000007f7c0000 - 000000007fffffff 
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
HPET: 3 timers in total, 0 timers will be used for per-cpu timer
Switching to clocksource hpet
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp 00:00: [bus 00-ff]
pnp 00:00: [io  0x0cf8-0x0cff]
pnp 00:00: [io  0x0000-0x0cf7 window]
pnp 00:00: [io  0x0d00-0xffff window]
pnp 00:00: [mem 0x000a0000-0x000bffff window]
pnp 00:00: [mem 0x000d0000-0x000dffff window]
pnp 00:00: [mem 0x7f800000-0xdfffffff window]
pnp 00:00: [mem 0xf0000000-0xfebfffff window]
pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
pnp 00:01: [mem 0xfed13000-0xfed19fff]
system 00:01: [mem 0xfed13000-0xfed19fff] has been reserved
system 00:01: Plug and Play ACPI device, IDs PNP0c01 (active)
pnp 00:02: [dma 4]
pnp 00:02: [io  0x0000-0x000f]
pnp 00:02: [io  0x0081-0x0083]
pnp 00:02: [io  0x0087]
pnp 00:02: [io  0x0089-0x008b]
pnp 00:02: [io  0x008f]
pnp 00:02: [io  0x00c0-0x00df]
pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
pnp 00:03: [io  0x0070-0x0071]
pnp 00:03: [irq 8]
pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
pnp 00:04: [io  0x0060]
pnp 00:04: [io  0x0064]
pnp 00:04: [irq 1]
pnp 00:04: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
pnp 00:05: [irq 12]
pnp 00:05: Plug and Play ACPI device, IDs SYN0911 SYN0900 SYN0002 PNP0f13 (active)
pnp 00:06: [io  0x0061]
pnp 00:06: Plug and Play ACPI device, IDs PNP0800 (active)
pnp 00:07: [io  0x00f0-0x00ff]
pnp 00:07: [irq 13]
pnp 00:07: Plug and Play ACPI device, IDs PNP0c04 (active)
pnp 00:08: [mem 0xfed00000-0xfed003ff]
pnp 00:08: Plug and Play ACPI device, IDs PNP0103 (active)
pnp 00:09: [mem 0xfec00000-0xfec00fff]
pnp 00:09: [mem 0xfee00000-0xfee00fff]
Switched to NOHz mode on CPU #0
system 00:09: [mem 0xfec00000-0xfec00fff] could not be reserved
system 00:09: [mem 0xfee00000-0xfee00fff] has been reserved
system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
Switched to NOHz mode on CPU #1
pnp 00:0a: [io  0x0010-0x001f]
pnp 00:0a: [io  0x0022-0x003f]
pnp 00:0a: [io  0x0044-0x005f]
pnp 00:0a: [io  0x0063]
pnp 00:0a: [io  0x0065]
pnp 00:0a: [io  0x0067-0x006f]
pnp 00:0a: [io  0x0072-0x007f]
pnp 00:0a: [io  0x0080]
pnp 00:0a: [io  0x0084-0x0086]
pnp 00:0a: [io  0x0088]
pnp 00:0a: [io  0x008c-0x008e]
pnp 00:0a: [io  0x0090-0x009f]
pnp 00:0a: [io  0x00a2-0x00bf]
pnp 00:0a: [io  0x00e0-0x00ef]
pnp 00:0a: [io  0x04d0-0x04d1]
pnp 00:0a: [io  0x0800-0x087f]
pnp 00:0a: [io  0x0000-0xffffffff disabled]
pnp 00:0a: [io  0x0480-0x04bf]
pnp 00:0a: [mem 0xfed1c000-0xfed1ffff]
pnp 00:0a: [mem 0xfed20000-0xfed8ffff]
pnp 00:0a: [mem 0xffb00000-0xffbfffff]
pnp 00:0a: [mem 0xfff00000-0xffffffff]
system 00:0a: [io  0x04d0-0x04d1] has been reserved
system 00:0a: [io  0x0800-0x087f] has been reserved
system 00:0a: [io  0x0480-0x04bf] has been reserved
system 00:0a: [mem 0xfed1c000-0xfed1ffff] has been reserved
system 00:0a: [mem 0xfed20000-0xfed8ffff] has been reserved
system 00:0a: [mem 0xffb00000-0xffbfffff] could not be reserved
system 00:0a: [mem 0xfff00000-0xffffffff] has been reserved
system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:0b: [mem 0xe0000000-0xefffffff]
system 00:0b: [mem 0xe0000000-0xefffffff] has been reserved
system 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:0c: [mem 0x00000000-0x0009ffff]
pnp 00:0c: [mem 0x000c0000-0x000cffff]
pnp 00:0c: [mem 0x000e0000-0x000fffff]
pnp 00:0c: [mem 0x00100000-0x7f7fffff]
pnp 00:0c: [mem 0xfec00000-0xffffffff]
system 00:0c: [mem 0x00000000-0x0009ffff] could not be reserved
system 00:0c: [mem 0x000c0000-0x000cffff] could not be reserved
system 00:0c: [mem 0x000e0000-0x000fffff] could not be reserved
system 00:0c: [mem 0x00100000-0x7f7fffff] could not be reserved
system 00:0c: [mem 0xfec00000-0xffffffff] could not be reserved
system 00:0c: Plug and Play ACPI device, IDs PNP0c01 (active)
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
PCI: max bus depth: 1 pci_try_num: 2
pci 0000:00:1e.0: BAR 14: assigned [mem 0x80000000-0x800fffff]
pci 0000:00:1c.1: BAR 15: assigned [mem 0x80100000-0x802fffff 64bit pref]
pci 0000:00:1c.0: BAR 14: assigned [mem 0x80300000-0x804fffff]
pci 0000:00:1c.0: BAR 15: assigned [mem 0x80500000-0x806fffff 64bit pref]
pci 0000:00:1c.0: BAR 13: assigned [io  0x1000-0x1fff]
pci 0000:00:1c.0: PCI bridge to [bus 01-01]
pci 0000:00:1c.0:   bridge window [io  0x1000-0x1fff]
pci 0000:00:1c.0:   bridge window [mem 0x80300000-0x804fffff]
pci 0000:00:1c.0:   bridge window [mem 0x80500000-0x806fffff 64bit pref]
pci 0000:00:1c.1: PCI bridge to [bus 02-02]
pci 0000:00:1c.1:   bridge window [io  0xa000-0xafff]
pci 0000:00:1c.1:   bridge window [mem 0xfef00000-0xff2fffff]
pci 0000:00:1c.1:   bridge window [mem 0x80100000-0x802fffff 64bit pref]
pci 0000:03:06.0: BAR 0: assigned [mem 0x80000000-0x80000fff]
pci 0000:03:06.0: BAR 0: set to [mem 0x80000000-0x80000fff] (PCI address [0x80000000-0x80000fff])
pci 0000:03:06.3: BAR 0: assigned [mem 0x80001000-0x80001fff]
pci 0000:03:06.3: BAR 0: set to [mem 0x80001000-0x80001fff] (PCI address [0x80001000-0x80001fff])
pci 0000:03:06.0: BAR 1: assigned [mem 0x80002000-0x800027ff]
pci 0000:03:06.0: BAR 1: set to [mem 0x80002000-0x800027ff] (PCI address [0x80002000-0x800027ff])
pci 0000:03:04.0: BAR 1: assigned [mem 0x80002800-0x800028ff]
pci 0000:03:04.0: BAR 1: set to [mem 0x80002800-0x800028ff] (PCI address [0x80002800-0x800028ff])
pci 0000:03:06.2: BAR 0: assigned [mem 0x80002900-0x800029ff]
pci 0000:03:06.2: BAR 0: set to [mem 0x80002900-0x800029ff] (PCI address [0x80002900-0x800029ff])
pci 0000:00:1e.0: PCI bridge to [bus 03-04]
pci 0000:00:1e.0:   bridge window [io  0xc000-0xdfff]
pci 0000:00:1e.0:   bridge window [mem 0x80000000-0x800fffff]
pci 0000:00:1e.0:   bridge window [mem 0xbdf00000-0xbfefffff 64bit pref]
pci 0000:00:1c.0: enabling device (0104 -> 0107)
pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:1c.0: setting latency timer to 64
pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.1: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffff]
pci_bus 0000:01: resource 0 [io  0x1000-0x1fff]
pci_bus 0000:01: resource 1 [mem 0x80300000-0x804fffff]
pci_bus 0000:01: resource 2 [mem 0x80500000-0x806fffff 64bit pref]
pci_bus 0000:02: resource 0 [io  0xa000-0xafff]
pci_bus 0000:02: resource 1 [mem 0xfef00000-0xff2fffff]
pci_bus 0000:02: resource 2 [mem 0x80100000-0x802fffff 64bit pref]
pci_bus 0000:03: resource 0 [io  0xc000-0xdfff]
pci_bus 0000:03: resource 1 [mem 0x80000000-0x800fffff]
pci_bus 0000:03: resource 2 [mem 0xbdf00000-0xbfefffff 64bit pref]
pci_bus 0000:03: resource 4 [io  0x0000-0xffff]
pci_bus 0000:03: resource 5 [mem 0x00000000-0xffffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
UDP hash table entries: 512 (order: 2, 16384 bytes)
UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
NET: Registered protocol family 1
pci 0000:00:02.0: Boot video device
PCI: CLS 32 bytes, default 64
Unpacking initramfs...
Freeing initrd memory: 1844k freed
apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
apm: disabled - APM is not SMP safe.
audit: initializing netlink socket (disabled)
type=2000 audit(1319581312.234:1): initialized
highmem bounce pool size: 64 pages
msgmni has been set to 1730
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
pcieport 0000:00:1c.0: setting latency timer to 64
pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
pcieport 0000:00:1c.1: setting latency timer to 64
pcieport 0000:00:1c.1: irq 41 for MSI/MSI-X
input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:08/PNP0C0D:00/input/input0
ACPI: Lid Switch [LIDD]
input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input1
ACPI: Sleep Button [SLPB]
input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input2
ACPI: Power Button [PWRB]
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
ACPI: Power Button [PWRF]
acpi device:20: registered as cooling_device0
input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input4
ACPI: Video Device [IGFX] (multi-head: yes  rom: no  post: no)
Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
Linux agpgart interface v0.103
agpgart-intel 0000:00:00.0: Intel 945GM Chipset
agpgart-intel 0000:00:00.0: detected gtt size: 262144K total, 262144K mappable
agpgart-intel 0000:00:00.0: detected 8192K stolen memory
agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[drm] Initialized drm 1.1.0 20060810
i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
i915 0000:00:02.0: setting latency timer to 64
[drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[drm] Driver supports precise vblank timestamp query.
vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[drm] initialized overlay support
fbcon: inteldrmfb (fb0) is primary device
Console: switching to colour frame buffer device 160x50
fb0: inteldrmfb frame buffer device
drm: registered panic notifier
[drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
i8042: Detected active multiplexing controller, rev 1.1
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX0 port at 0x60,0x64 irq 12
serio: i8042 AUX1 port at 0x60,0x64 irq 12
serio: i8042 AUX2 port at 0x60,0x64 irq 12
serio: i8042 AUX3 port at 0x60,0x64 irq 12
mousedev: PS/2 mouse device common for all mice
cpuidle: using governor ladder
cpuidle: using governor menu
TCP cubic registered
NET: Registered protocol family 17
Using IPI No-Shortcut mode
PM: Checking hibernation image partition /dev/disk/by-uuid/f83924df-3dd0-4b60-a263-54f3fcade1d2
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input5
Refined TSC clocksource calibration: 1728.999 MHz.
Switching to clocksource tsc
PM: Hibernation image not present or could not be loaded.
registered taskstats version 1
Freeing unused kernel memory: 412k freed
udevd[32]: starting version 174
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
SCSI subsystem initialized
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1d.7: using broken periodic workaround
ehci_hcd 0000:00:1d.7: debug port 1
libata version 3.00 loaded.
ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xffe3b800
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
ata_piix 0000:00:1f.2: version 2.13
ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ata_piix 0000:00:1f.2: MAP [ P0 P2 IDE IDE ]
ata_piix 0000:00:1f.2: setting latency timer to 64
scsi0 : ata_piix
scsi1 : ata_piix
ata1: SATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000e880
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000e800
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000e480
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1d.3: setting latency timer to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.3: irq 16, io base 0x0000e400
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
ata2.00: ATAPI: Optiarc DVD RW AD-5530A, AX24, max UDMA/33
ata1.00: ATA-7: FUJITSU MHV2100BH PL, 00000029, max UDMA/100
ata1.00: 195371568 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata1.00: configured for UDMA/100
scsi 0:0:0:0: Direct-Access     ATA      FUJITSU MHV2100B 0000 PQ: 0 ANSI: 5
ata2.00: configured for UDMA/33
scsi 1:0:0:0: CD-ROM            Optiarc  DVD RW AD-5530A  AX24 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 195371568 512-byte logical blocks: (100 GB/93.1 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
cdrom: Uniform CD-ROM driver Revision: 3.20
sr 1:0:0:0: Attached scsi CD-ROM sr0
 sda: sda1 sda2 < sda5 > sda3
sd 0:0:0:0: [sda] Attached SCSI disk
usb 1-2: new high speed USB device number 2 using ehci_hcd
PM: Starting manual resume from disk
PM: Hibernation image partition 8:5 present
PM: Looking for hibernation image.
PM: Image not found (code -22)
PM: Hibernation image not present or could not be loaded.
kjournald starting.  Commit interval 5 seconds
EXT3-fs (sda3): mounted filesystem with writeback data mode
udevd[204]: starting version 174
ACPI: acpi_idle registered with cpuidle
Marking TSC unstable due to TSC halts in idle
Switching to clocksource hpet
P-state transition latency capped at 20 uS
i801_smbus 0000:00:1f.3: PCI INT B -> GSI 19 (level, low) -> IRQ 19
intel_rng: FWH not detected
ACPI: Deprecated procfs I/F for AC is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
ACPI: AC Adapter [AC] (off-line)
8139too: 8139too Fast Ethernet driver 0.9.28
8139too 0000:03:04.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
8139too 0000:03:04.0: eth0: RealTek RTL8139 at 0xf89f6800, 00:40:45:2d:b8:44, IRQ 16
iTCO_vendor_support: vendor-support=0
thermal LNXTHERM:00: registered as thermal_zone0
ACPI: Thermal Zone [THRM] (53 C)
ACPI: Deprecated procfs I/F for battery is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
ACPI: Battery Slot [BAT0] (battery present)
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.06
iTCO_wdt: Found a ICH7-M or ICH7-U TCO device (Version=2, TCOBASE=0x0860)
iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
firewire_ohci 0000:03:06.0: enabling device (0015 -> 0017)
firewire_ohci 0000:03:06.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
Synaptics Touchpad, model: 1, fw: 5.10, id: 0x258eb1, caps: 0xa04713/0x0/0x0
firewire_ohci: Added fw-ohci device 0000:03:06.0, OHCI v1.10, 8 IR + 8 IT contexts, quirks 0x10
input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio4/input/input6
snd_hda_intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
snd_hda_intel 0000:00:1b.0: irq 42 for MSI/MSI-X
snd_hda_intel 0000:00:1b.0: setting latency timer to 64
hda_codec: ALC262: BIOS auto-probing.
input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input7
input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
firewire_core: created device fw0: GUID 00012f65ab60c248, S400
cfg80211: Calling CRDA to update world regulatory domain
usb 1-2: reset high speed USB device number 2 using ehci_hcd
ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
Registered led device: rt73usb-phy0::radio
Registered led device: rt73usb-phy0::assoc
Registered led device: rt73usb-phy0::quality
usbcore: registered new interface driver rt73usb
EXT3-fs (sda3): using internal journal
kjournald starting.  Commit interval 5 seconds
EXT3-fs (sda1): using internal journal
EXT3-fs (sda1): mounted filesystem with writeback data mode
Adding 3004116k swap on /dev/sda5.  Priority:-1 extents:1 across:3004116k 
uhci_hcd 0000:00:1d.0: PCI INT A disabled
uhci_hcd 0000:00:1d.1: PCI INT B disabled
uhci_hcd 0000:00:1d.2: PCI INT C disabled
uhci_hcd 0000:00:1d.3: PCI INT D disabled
wlan0: authenticate with 00:40:10:10:00:03 (try 1)
wlan0: authenticated
wlan0: associate with 00:40:10:10:00:03 (try 1)
wlan0: RX AssocResp from 00:40:10:10:00:03 (capab=0x411 status=0 aid=1)
wlan0: associated
fuse init (API version 7.17)
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1d.3: setting latency timer to 64
uhci_hcd 0000:00:1d.2: PCI INT C disabled
uhci_hcd 0000:00:1d.1: PCI INT B disabled
uhci_hcd 0000:00:1d.0: PCI INT A disabled
uhci_hcd 0000:00:1d.3: PCI INT D disabled
PM: Marking nosave pages: 000000000009f000 - 0000000000100000
PM: Basic memory bitmaps created
PM: Syncing filesystems ... done.
Freezing user space processes ... (elapsed 0.01 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1d.3: setting latency timer to 64
PM: Preallocating image memory... done (allocated 302363 pages)
PM: Allocated 1209452 kbytes in 0.23 seconds (5258.48 MB/s)
Suspending console(s) (use no_console_suspend to debug)
sd 0:0:0:0: [sda] Synchronizing SCSI cache
ata_piix 0000:00:1f.2: PCI INT B disabled
snd_hda_intel 0000:00:1b.0: PCI INT A disabled
PM: freeze of devices complete after 19.215 msecs
PM: late freeze of devices complete after 0.615 msecs
ACPI: Preparing to enter system sleep state S4
PM: Saving platform NVS memory
Disabling non-boot CPUs ...
CPU 1 is now offline
PM: Creating hibernation image:
PM: Need to copy 204574 pages
PM: Normal pages needed: 97303 + 1024, available pages: 210183
PM: Restoring platform NVS memory
Enabling non-boot CPUs ...
Booting Node 0 Processor 1 APIC 0x1
smpboot cpu 1: start_ip = 9b000
Initializing CPU#1
Calibrating delay loop (skipped) already calibrated this CPU
Disabled fast string operations
Switched to NOHz mode on CPU #1
CPU1 is up
ACPI: Waking up from system sleep state S4
snd_hda_intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100006, writing 0x100002)
ata_piix 0000:00:1f.2: restoring config space at offset 0x1 (was 0x2b80001, writing 0x2b80005)
firewire_ohci 0000:03:06.0: restoring config space at offset 0x1 (was 0x2100015, writing 0x2180017)
PM: early restore of devices complete after 0.978 msecs
i915 0000:00:02.0: setting latency timer to 64
snd_hda_intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
snd_hda_intel 0000:00:1b.0: setting latency timer to 64
snd_hda_intel 0000:00:1b.0: irq 42 for MSI/MSI-X
uhci_hcd 0000:00:1d.0: setting latency timer to 64
usb usb2: root hub lost power or was reset
uhci_hcd 0000:00:1d.1: setting latency timer to 64
usb usb3: root hub lost power or was reset
uhci_hcd 0000:00:1d.2: setting latency timer to 64
usb usb4: root hub lost power or was reset
uhci_hcd 0000:00:1d.3: setting latency timer to 64
usb usb5: root hub lost power or was reset
ehci_hcd 0000:00:1d.7: setting latency timer to 64
usb usb1: root hub lost power or was reset
pci 0000:00:1e.0: setting latency timer to 64
ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ata_piix 0000:00:1f.2: setting latency timer to 64
ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
sd 0:0:0:0: [sda] Starting disk
firewire_core: skipped bus generations, destroying all nodes
ata1.00: ACPI cmd ef/03:45:00:00:00:a0 (SET FEATURES) filtered out
ata1.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
ata1.00: ACPI cmd c6/00:10:00:00:00:a0 (SET MULTIPLE MODE) succeeded
ata2.00: ACPI cmd ef/03:42:00:00:00:a0 (SET FEATURES) filtered out
ata2.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
ata1.00: configured for UDMA/100
ata2.00: configured for UDMA/33
usb 1-2: reset high speed USB device number 2 using ehci_hcd
rt73usb 1-2:1.0: no reset_resume for driver rt73usb?
wlan0: deauthenticating from 00:40:10:10:00:03 by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
firewire_core: rediscovered device fw0
PM: restore of devices complete after 579.890 msecs
usb 1-2: reset high speed USB device number 2 using ehci_hcd
ieee80211 phy1: Selected rate control algorithm 'minstrel_ht'
Registered led device: rt73usb-phy1::radio
Registered led device: rt73usb-phy1::assoc
Registered led device: rt73usb-phy1::quality
PM: Image restored successfully.
Restarting tasks ... done.
PM: Basic memory bitmaps freed
video LNXVIDEO:00: Restoring backlight state
usbcore: deregistering interface driver rt73usb
usb 1-2: reset high speed USB device number 2 using ehci_hcd
ieee80211 phy2: Selected rate control algorithm 'minstrel_ht'
Registered led device: rt73usb-phy2::radio
Registered led device: rt73usb-phy2::assoc
Registered led device: rt73usb-phy2::quality
usbcore: registered new interface driver rt73usb
wlan0: authenticate with 00:40:10:10:00:03 (try 1)
wlan0: authenticated
wlan0: associate with 00:40:10:10:00:03 (try 1)
wlan0: RX AssocResp from 00:40:10:10:00:03 (capab=0x411 status=0 aid=1)
wlan0: associated
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.3: setting latency timer to 64
usb 1-7: new high speed USB device number 3 using ehci_hcd
hub 1-7:1.0: USB hub found
hub 1-7:1.0: 4 ports detected
usb 1-7.1: new low speed USB device number 4 using ehci_hcd
input: KEYBOARD USB KB as /devices/pci0000:00/0000:00:1d.7/usb1/1-7/1-7.1/1-7.1:1.0/input/input9
generic-usb 0003:05D5:6782.0001: input,hidraw0: USB HID v1.10 Keyboard [KEYBOARD USB KB] on usb-0000:00:1d.7-7.1/input0
input: KEYBOARD USB KB as /devices/pci0000:00/0000:00:1d.7/usb1/1-7/1-7.1/1-7.1:1.1/input/input10
generic-usb 0003:05D5:6782.0002: input,hidraw1: USB HID v1.10 Mouse [KEYBOARD USB KB] on usb-0000:00:1d.7-7.1/input1
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
usb 3-1: new low speed USB device number 2 using uhci_hcd
input: Genius Laser Mouse as /devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1:1.0/input/input11
generic-usb 0003:0458:003A.0003: input,hidraw2: USB HID v1.10 Mouse [Genius Laser Mouse] on usb-0000:00:1d.1-1/input0
PM: Syncing filesystems ... done.
PM: Preparing system for mem sleep
Freezing user space processes ... (elapsed 0.01 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
PM: Entering mem sleep
Suspending console(s) (use no_console_suspend to debug)
sd 0:0:0:0: [sda] Synchronizing SCSI cache
sd 0:0:0:0: [sda] Stopping disk
snd_hda_intel 0000:00:1b.0: PCI INT A disabled
ata_piix 0000:00:1f.2: PCI INT B disabled
PM: suspend of devices complete after 1029.613 msecs
PM: late suspend of devices complete after 11.210 msecs
ACPI: Preparing to enter system sleep state S3
PM: Saving platform NVS memory
Disabling non-boot CPUs ...
CPU 1 is now offline
ACPI: Low-level resume complete
PM: Restoring platform NVS memory
Enabling non-boot CPUs ...
Booting Node 0 Processor 1 APIC 0x1
smpboot cpu 1: start_ip = 9b000
Initializing CPU#1
Calibrating delay loop (skipped) already calibrated this CPU
Disabled fast string operations
Switched to NOHz mode on CPU #1
CPU1 is up
ACPI: Waking up from system sleep state S3
pci 0000:00:02.1: restoring config space at offset 0x4 (was 0x0, writing 0xffd80000)
pci 0000:00:02.1: restoring config space at offset 0x1 (was 0x900000, writing 0x900007)
snd_hda_intel 0000:00:1b.0: restoring config space at offset 0x3 (was 0x0, writing 0x8)
snd_hda_intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100006, writing 0x100002)
pcieport 0000:00:1c.0: restoring config space at offset 0xf (was 0x20100, writing 0x2010a)
pcieport 0000:00:1c.0: restoring config space at offset 0x9 (was 0x1fff1, writing 0x80618051)
pcieport 0000:00:1c.0: restoring config space at offset 0x8 (was 0xfff0, writing 0x80408030)
pcieport 0000:00:1c.0: restoring config space at offset 0x7 (was 0xf0, writing 0x1010)
pcieport 0000:00:1c.0: restoring config space at offset 0x3 (was 0x810000, writing 0x810008)
pcieport 0000:00:1c.0: restoring config space at offset 0x1 (was 0x100104, writing 0x100507)
pcieport 0000:00:1c.1: restoring config space at offset 0xf (was 0x20200, writing 0x2020b)
pcieport 0000:00:1c.1: restoring config space at offset 0x9 (was 0x1fff1, writing 0x80218011)
pcieport 0000:00:1c.1: restoring config space at offset 0x3 (was 0x810000, writing 0x810008)
pcieport 0000:00:1c.1: restoring config space at offset 0x1 (was 0x100107, writing 0x100507)
pci 0000:00:1e.0: restoring config space at offset 0xf (was 0x20000, writing 0x200ff)
pci 0000:00:1e.0: restoring config space at offset 0x8 (was 0xffb0ff30, writing 0x80008000)
8139too 0000:03:04.0: restoring config space at offset 0x5 (was 0x0, writing 0x80002800)
8139too 0000:03:04.0: restoring config space at offset 0x4 (was 0x1, writing 0xd801)
8139too 0000:03:04.0: restoring config space at offset 0x3 (was 0x0, writing 0x4000)
8139too 0000:03:04.0: restoring config space at offset 0x1 (was 0x2900000, writing 0x2900007)
firewire_ohci 0000:03:06.0: restoring config space at offset 0xf (was 0x100, writing 0x105)
firewire_ohci 0000:03:06.0: restoring config space at offset 0x5 (was 0x0, writing 0x80002000)
firewire_ohci 0000:03:06.0: restoring config space at offset 0x4 (was 0x0, writing 0x80000000)
firewire_ohci 0000:03:06.0: restoring config space at offset 0x3 (was 0x800000, writing 0x804008)
firewire_ohci 0000:03:06.0: restoring config space at offset 0x1 (was 0x2100080, writing 0x2180017)
pci 0000:03:06.2: restoring config space at offset 0xf (was 0x1ff, writing 0x105)
pci 0000:03:06.2: restoring config space at offset 0x4 (was 0x0, writing 0x80002900)
pci 0000:03:06.2: restoring config space at offset 0x3 (was 0x0, writing 0x4008)
pci 0000:03:06.2: restoring config space at offset 0x1 (was 0x4100000, writing 0x4100002)
pci 0000:03:06.3: restoring config space at offset 0xf (was 0x1ff, writing 0x105)
pci 0000:03:06.3: restoring config space at offset 0x4 (was 0x0, writing 0x80001000)
pci 0000:03:06.3: restoring config space at offset 0x3 (was 0x0, writing 0x4008)
pci 0000:03:06.3: restoring config space at offset 0x1 (was 0x4100000, writing 0x84100002)
PM: early resume of devices complete after 1.107 msecs
i915 0000:00:02.0: setting latency timer to 64
snd_hda_intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
snd_hda_intel 0000:00:1b.0: setting latency timer to 64
snd_hda_intel 0000:00:1b.0: irq 42 for MSI/MSI-X
uhci_hcd 0000:00:1d.0: setting latency timer to 64
usb usb2: root hub lost power or was reset
uhci_hcd 0000:00:1d.1: setting latency timer to 64
usb usb3: root hub lost power or was reset
uhci_hcd 0000:00:1d.2: setting latency timer to 64
usb usb4: root hub lost power or was reset
uhci_hcd 0000:00:1d.3: setting latency timer to 64
usb usb5: root hub lost power or was reset
ehci_hcd 0000:00:1d.7: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ata_piix 0000:00:1f.2: setting latency timer to 64
sd 0:0:0:0: [sda] Starting disk
firewire_core: skipped bus generations, destroying all nodes
usb 1-2: reset high speed USB device number 2 using ehci_hcd
rt73usb 1-2:1.0: no reset_resume for driver rt73usb?
wlan0: deauthenticating from 00:40:10:10:00:03 by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
firewire_core: rediscovered device fw0
usb 3-1: reset low speed USB device number 2 using uhci_hcd
ata2.00: ACPI cmd ef/03:42:00:00:00:a0 (SET FEATURES) filtered out
ata2.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
ata2.00: configured for UDMA/33
ata1.00: ACPI cmd ef/03:45:00:00:00:a0 (SET FEATURES) filtered out
ata1.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
ata1.00: ACPI cmd c6/00:10:00:00:00:a0 (SET MULTIPLE MODE) succeeded
ata1.00: configured for UDMA/100
PM: resume of devices complete after 2634.311 msecs
usb 1-2: reset high speed USB device number 2 using ehci_hcd
ieee80211 phy3: Selected rate control algorithm 'minstrel_ht'
Registered led device: rt73usb-phy3::radio
Registered led device: rt73usb-phy3::assoc
Registered led device: rt73usb-phy3::quality
PM: Finishing wakeup.
Restarting tasks ... done.
video LNXVIDEO:00: Restoring backlight state
usbcore: deregistering interface driver rt73usb
usb 1-2: reset high speed USB device number 2 using ehci_hcd
ieee80211 phy4: Selected rate control algorithm 'minstrel_ht'
Registered led device: rt73usb-phy4::radio
Registered led device: rt73usb-phy4::assoc
Registered led device: rt73usb-phy4::quality
usbcore: registered new interface driver rt73usb
usb 1-7: USB disconnect, device number 3
usb 1-7.1: USB disconnect, device number 4
generic-usb 0003:05D5:6782.0002: can't reset device, 0000:00:1d.7-7.1/input1, status -71
usb 1-7: clear tt 1 (0040) error -19
usb 1-7: new high speed USB device number 6 using ehci_hcd
hub 1-7:1.0: USB hub found
hub 1-7:1.0: 4 ports detected
usb 1-7.1: new low speed USB device number 7 using ehci_hcd
input: KEYBOARD USB KB as /devices/pci0000:00/0000:00:1d.7/usb1/1-7/1-7.1/1-7.1:1.0/input/input12
generic-usb 0003:05D5:6782.0004: input,hidraw0: USB HID v1.10 Keyboard [KEYBOARD USB KB] on usb-0000:00:1d.7-7.1/input0
input: KEYBOARD USB KB as /devices/pci0000:00/0000:00:1d.7/usb1/1-7/1-7.1/1-7.1:1.1/input/input13
generic-usb 0003:05D5:6782.0005: input,hidraw1: USB HID v1.10 Mouse [KEYBOARD USB KB] on usb-0000:00:1d.7-7.1/input1
wlan0: authenticate with 00:40:10:10:00:03 (try 1)
wlan0: authenticated
wlan0: associate with 00:40:10:10:00:03 (try 1)
wlan0: RX AssocResp from 00:40:10:10:00:03 (capab=0x411 status=0 aid=1)
wlan0: associated
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.21.0-ioctl (2011-07-06) initialised: dm-devel@redhat.com
PM: Marking nosave pages: 000000000009f000 - 0000000000100000
PM: Basic memory bitmaps created
PM: Syncing filesystems ... done.
Freezing user space processes ... (elapsed 0.01 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
PM: Preallocating image memory... done (allocated 302339 pages)
PM: Allocated 1209356 kbytes in 0.81 seconds (1493.03 MB/s)
Suspending console(s) (use no_console_suspend to debug)
sd 0:0:0:0: [sda] Synchronizing SCSI cache
ata_piix 0000:00:1f.2: PCI INT B disabled
snd_hda_intel 0000:00:1b.0: PCI INT A disabled
PM: freeze of devices complete after 331.577 msecs
PM: late freeze of devices complete after 0.738 msecs
ACPI: Preparing to enter system sleep state S4
PM: Saving platform NVS memory
Disabling non-boot CPUs ...
CPU 1 is now offline
PM: Creating hibernation image:
PM: Need to copy 149676 pages
PM: Normal pages needed: 23175 + 1024, available pages: 204003
PM: Restoring platform NVS memory
Enabling non-boot CPUs ...
Booting Node 0 Processor 1 APIC 0x1
smpboot cpu 1: start_ip = 9b000
Initializing CPU#1
Calibrating delay loop (skipped) already calibrated this CPU
Disabled fast string operations
Switched to NOHz mode on CPU #1
CPU1 is up
ACPI: Waking up from system sleep state S4
snd_hda_intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100006, writing 0x100002)
ata_piix 0000:00:1f.2: restoring config space at offset 0x1 (was 0x2b80001, writing 0x2b80005)
firewire_ohci 0000:03:06.0: restoring config space at offset 0x1 (was 0x2100015, writing 0x2180017)
pci 0000:03:06.3: restoring config space at offset 0x1 (was 0x84100002, writing 0x4100002)
PM: early restore of devices complete after 1.006 msecs
i915 0000:00:02.0: setting latency timer to 64
snd_hda_intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
snd_hda_intel 0000:00:1b.0: setting latency timer to 64
snd_hda_intel 0000:00:1b.0: irq 42 for MSI/MSI-X
uhci_hcd 0000:00:1d.0: setting latency timer to 64
usb usb2: root hub lost power or was reset
uhci_hcd 0000:00:1d.1: setting latency timer to 64
usb usb3: root hub lost power or was reset
uhci_hcd 0000:00:1d.2: setting latency timer to 64
usb usb4: root hub lost power or was reset
uhci_hcd 0000:00:1d.3: setting latency timer to 64
usb usb5: root hub lost power or was reset
ehci_hcd 0000:00:1d.7: setting latency timer to 64
usb usb1: root hub lost power or was reset
pci 0000:00:1e.0: setting latency timer to 64
ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ata_piix 0000:00:1f.2: setting latency timer to 64
ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
sd 0:0:0:0: [sda] Starting disk
firewire_core: skipped bus generations, destroying all nodes
ata1.00: ACPI cmd ef/03:45:00:00:00:a0 (SET FEATURES) filtered out
ata1.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
ata1.00: ACPI cmd c6/00:10:00:00:00:a0 (SET MULTIPLE MODE) succeeded
ata2.00: ACPI cmd ef/03:42:00:00:00:a0 (SET FEATURES) filtered out
ata2.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
ata1.00: configured for UDMA/100
ata2.00: configured for UDMA/33
usb 1-7: reset high speed USB device number 6 using ehci_hcd
firewire_core: rediscovered device fw0
usb 1-2: reset high speed USB device number 2 using ehci_hcd
rt73usb 1-2:1.0: no reset_resume for driver rt73usb?
wlan0: deauthenticating from 00:40:10:10:00:03 by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
usb 3-1: reset low speed USB device number 2 using uhci_hcd
usb 1-7.1: reset low speed USB device number 7 using ehci_hcd
PM: restore of devices complete after 1861.421 msecs
usb 1-2: reset high speed USB device number 2 using ehci_hcd
ieee80211 phy5: Selected rate control algorithm 'minstrel_ht'
Registered led device: rt73usb-phy5::radio
Registered led device: rt73usb-phy5::assoc
Registered led device: rt73usb-phy5::quality
PM: Image restored successfully.
Restarting tasks ... done.
PM: Basic memory bitmaps freed
video LNXVIDEO:00: Restoring backlight state
usbcore: deregistering interface driver rt73usb
usb 1-2: reset high speed USB device number 2 using ehci_hcd
ieee80211 phy6: Selected rate control algorithm 'minstrel_ht'
Registered led device: rt73usb-phy6::radio
Registered led device: rt73usb-phy6::assoc
Registered led device: rt73usb-phy6::quality
usbcore: registered new interface driver rt73usb
wlan0: authenticate with 00:40:10:10:00:03 (try 1)
wlan0: authenticated
wlan0: associate with 00:40:10:10:00:03 (try 1)
wlan0: RX AssocResp from 00:40:10:10:00:03 (capab=0x411 status=0 aid=1)
wlan0: associated
usb 1-7: USB disconnect, device number 6
usb 1-7.1: USB disconnect, device number 7
usb 1-7: new high speed USB device number 8 using ehci_hcd
hub 1-7:1.0: USB hub found
hub 1-7:1.0: 4 ports detected
usb 1-7.1: new low speed USB device number 9 using ehci_hcd
input: KEYBOARD USB KB as /devices/pci0000:00/0000:00:1d.7/usb1/1-7/1-7.1/1-7.1:1.0/input/input14
generic-usb 0003:05D5:6782.0006: input,hidraw0: USB HID v1.10 Keyboard [KEYBOARD USB KB] on usb-0000:00:1d.7-7.1/input0
input: KEYBOARD USB KB as /devices/pci0000:00/0000:00:1d.7/usb1/1-7/1-7.1/1-7.1:1.1/input/input15
generic-usb 0003:05D5:6782.0007: input,hidraw1: USB HID v1.10 Mouse [KEYBOARD USB KB] on usb-0000:00:1d.7-7.1/input1
PM: Syncing filesystems ... done.
PM: Preparing system for mem sleep
Freezing user space processes ... (elapsed 0.01 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
PM: Entering mem sleep
Suspending console(s) (use no_console_suspend to debug)
sd 0:0:0:0: [sda] Synchronizing SCSI cache
sd 0:0:0:0: [sda] Stopping disk
snd_hda_intel 0000:00:1b.0: PCI INT A disabled
ata_piix 0000:00:1f.2: PCI INT B disabled
PM: suspend of devices complete after 1032.583 msecs
PM: late suspend of devices complete after 11.218 msecs
ACPI: Preparing to enter system sleep state S3
PM: Saving platform NVS memory
Disabling non-boot CPUs ...
CPU 1 is now offline
ACPI: Low-level resume complete
PM: Restoring platform NVS memory
Enabling non-boot CPUs ...
Booting Node 0 Processor 1 APIC 0x1
smpboot cpu 1: start_ip = 9b000
Initializing CPU#1
Calibrating delay loop (skipped) already calibrated this CPU
Disabled fast string operations
Switched to NOHz mode on CPU #1
CPU1 is up
ACPI: Waking up from system sleep state S3
pci 0000:00:02.1: restoring config space at offset 0x4 (was 0x0, writing 0xffd80000)
pci 0000:00:02.1: restoring config space at offset 0x1 (was 0x900000, writing 0x900007)
snd_hda_intel 0000:00:1b.0: restoring config space at offset 0x3 (was 0x0, writing 0x8)
snd_hda_intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100006, writing 0x100002)
pcieport 0000:00:1c.0: restoring config space at offset 0xf (was 0x20100, writing 0x2010a)
pcieport 0000:00:1c.0: restoring config space at offset 0x9 (was 0x1fff1, writing 0x80618051)
pcieport 0000:00:1c.0: restoring config space at offset 0x8 (was 0xfff0, writing 0x80408030)
pcieport 0000:00:1c.0: restoring config space at offset 0x7 (was 0xf0, writing 0x1010)
pcieport 0000:00:1c.0: restoring config space at offset 0x3 (was 0x810000, writing 0x810008)
pcieport 0000:00:1c.0: restoring config space at offset 0x1 (was 0x100104, writing 0x100507)
pcieport 0000:00:1c.1: restoring config space at offset 0xf (was 0x20200, writing 0x2020b)
pcieport 0000:00:1c.1: restoring config space at offset 0x9 (was 0x1fff1, writing 0x80218011)
pcieport 0000:00:1c.1: restoring config space at offset 0x3 (was 0x810000, writing 0x810008)
pcieport 0000:00:1c.1: restoring config space at offset 0x1 (was 0x100107, writing 0x100507)
pci 0000:00:1e.0: restoring config space at offset 0xf (was 0x20000, writing 0x200ff)
pci 0000:00:1e.0: restoring config space at offset 0x8 (was 0xffb0ff30, writing 0x80008000)
8139too 0000:03:04.0: restoring config space at offset 0x5 (was 0x0, writing 0x80002800)
8139too 0000:03:04.0: restoring config space at offset 0x4 (was 0x1, writing 0xd801)
8139too 0000:03:04.0: restoring config space at offset 0x3 (was 0x0, writing 0x4000)
8139too 0000:03:04.0: restoring config space at offset 0x1 (was 0x2900000, writing 0x2900007)
firewire_ohci 0000:03:06.0: restoring config space at offset 0xf (was 0x100, writing 0x105)
firewire_ohci 0000:03:06.0: restoring config space at offset 0x5 (was 0x0, writing 0x80002000)
firewire_ohci 0000:03:06.0: restoring config space at offset 0x4 (was 0x0, writing 0x80000000)
firewire_ohci 0000:03:06.0: restoring config space at offset 0x3 (was 0x800000, writing 0x804008)
firewire_ohci 0000:03:06.0: restoring config space at offset 0x1 (was 0x2100080, writing 0x2180017)
pci 0000:03:06.2: restoring config space at offset 0xf (was 0x1ff, writing 0x105)
pci 0000:03:06.2: restoring config space at offset 0x4 (was 0x0, writing 0x80002900)
pci 0000:03:06.2: restoring config space at offset 0x3 (was 0x0, writing 0x4008)
pci 0000:03:06.2: restoring config space at offset 0x1 (was 0x4100000, writing 0x4100002)
pci 0000:03:06.3: restoring config space at offset 0xf (was 0x1ff, writing 0x105)
pci 0000:03:06.3: restoring config space at offset 0x4 (was 0x0, writing 0x80001000)
pci 0000:03:06.3: restoring config space at offset 0x3 (was 0x0, writing 0x4008)
pci 0000:03:06.3: restoring config space at offset 0x1 (was 0x4100000, writing 0x84100002)
PM: early resume of devices complete after 1.110 msecs
i915 0000:00:02.0: setting latency timer to 64
snd_hda_intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
snd_hda_intel 0000:00:1b.0: setting latency timer to 64
snd_hda_intel 0000:00:1b.0: irq 42 for MSI/MSI-X
uhci_hcd 0000:00:1d.0: setting latency timer to 64
usb usb2: root hub lost power or was reset
uhci_hcd 0000:00:1d.1: setting latency timer to 64
usb usb3: root hub lost power or was reset
uhci_hcd 0000:00:1d.2: setting latency timer to 64
usb usb4: root hub lost power or was reset
uhci_hcd 0000:00:1d.3: setting latency timer to 64
usb usb5: root hub lost power or was reset
ehci_hcd 0000:00:1d.7: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ata_piix 0000:00:1f.2: setting latency timer to 64
sd 0:0:0:0: [sda] Starting disk
firewire_core: skipped bus generations, destroying all nodes
usb 1-2: reset high speed USB device number 2 using ehci_hcd
rt73usb 1-2:1.0: no reset_resume for driver rt73usb?
wlan0: deauthenticating from 00:40:10:10:00:03 by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
firewire_core: rediscovered device fw0
usb 3-1: reset low speed USB device number 2 using uhci_hcd
ata2.00: ACPI cmd ef/03:42:00:00:00:a0 (SET FEATURES) filtered out
ata2.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
ata2.00: configured for UDMA/33
ata1.00: ACPI cmd ef/03:45:00:00:00:a0 (SET FEATURES) filtered out
ata1.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
ata1.00: ACPI cmd c6/00:10:00:00:00:a0 (SET MULTIPLE MODE) succeeded
ata1.00: configured for UDMA/100
PM: resume of devices complete after 2634.229 msecs
usb 1-2: reset high speed USB device number 2 using ehci_hcd
ieee80211 phy7: Selected rate control algorithm 'minstrel_ht'
Registered led device: rt73usb-phy7::radio
Registered led device: rt73usb-phy7::assoc
Registered led device: rt73usb-phy7::quality
PM: Finishing wakeup.
Restarting tasks ... done.
video LNXVIDEO:00: Restoring backlight state
usbcore: deregistering interface driver rt73usb
usb 1-2: reset high speed USB device number 2 using ehci_hcd
ieee80211 phy8: Selected rate control algorithm 'minstrel_ht'
Registered led device: rt73usb-phy8::radio
Registered led device: rt73usb-phy8::assoc
Registered led device: rt73usb-phy8::quality
usbcore: registered new interface driver rt73usb
usb 1-7: USB disconnect, device number 8
usb 1-7.1: USB disconnect, device number 9
generic-usb 0003:05D5:6782.0007: can't reset device, 0000:00:1d.7-7.1/input1, status -71
usb 1-7: clear tt 1 (0090) error -19
usb 1-7: new high speed USB device number 10 using ehci_hcd
hub 1-7:1.0: USB hub found
hub 1-7:1.0: 4 ports detected
usb 1-7.1: new low speed USB device number 11 using ehci_hcd
input: KEYBOARD USB KB as /devices/pci0000:00/0000:00:1d.7/usb1/1-7/1-7.1/1-7.1:1.0/input/input16
generic-usb 0003:05D5:6782.0008: input,hidraw0: USB HID v1.10 Keyboard [KEYBOARD USB KB] on usb-0000:00:1d.7-7.1/input0
input: KEYBOARD USB KB as /devices/pci0000:00/0000:00:1d.7/usb1/1-7/1-7.1/1-7.1:1.1/input/input17
generic-usb 0003:05D5:6782.0009: input,hidraw1: USB HID v1.10 Mouse [KEYBOARD USB KB] on usb-0000:00:1d.7-7.1/input1
wlan0: authenticate with 00:40:10:10:00:03 (try 1)
wlan0: authenticated
wlan0: associate with 00:40:10:10:00:03 (try 1)
wlan0: RX AssocResp from 00:40:10:10:00:03 (capab=0x411 status=0 aid=2)
wlan0: associated
PM: Syncing filesystems ... done.
PM: Preparing system for mem sleep
Freezing user space processes ... (elapsed 0.01 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
PM: Entering mem sleep
Suspending console(s) (use no_console_suspend to debug)
sd 0:0:0:0: [sda] Synchronizing SCSI cache
sd 0:0:0:0: [sda] Stopping disk
snd_hda_intel 0000:00:1b.0: PCI INT A disabled
ata_piix 0000:00:1f.2: PCI INT B disabled
PM: suspend of devices complete after 1030.601 msecs
PM: late suspend of devices complete after 11.200 msecs
ACPI: Preparing to enter system sleep state S3
PM: Saving platform NVS memory
Disabling non-boot CPUs ...
CPU 1 is now offline
ACPI: Low-level resume complete
PM: Restoring platform NVS memory
Enabling non-boot CPUs ...
Booting Node 0 Processor 1 APIC 0x1
smpboot cpu 1: start_ip = 9b000
Initializing CPU#1
Calibrating delay loop (skipped) already calibrated this CPU
Disabled fast string operations
Switched to NOHz mode on CPU #1
CPU1 is up
ACPI: Waking up from system sleep state S3
pci 0000:00:02.1: restoring config space at offset 0x4 (was 0x0, writing 0xffd80000)
pci 0000:00:02.1: restoring config space at offset 0x1 (was 0x900000, writing 0x900007)
snd_hda_intel 0000:00:1b.0: restoring config space at offset 0x3 (was 0x0, writing 0x8)
snd_hda_intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100006, writing 0x100002)
pcieport 0000:00:1c.0: restoring config space at offset 0xf (was 0x20100, writing 0x2010a)
pcieport 0000:00:1c.0: restoring config space at offset 0x9 (was 0x1fff1, writing 0x80618051)
pcieport 0000:00:1c.0: restoring config space at offset 0x8 (was 0xfff0, writing 0x80408030)
pcieport 0000:00:1c.0: restoring config space at offset 0x7 (was 0xf0, writing 0x1010)
pcieport 0000:00:1c.0: restoring config space at offset 0x3 (was 0x810000, writing 0x810008)
pcieport 0000:00:1c.0: restoring config space at offset 0x1 (was 0x100104, writing 0x100507)
pcieport 0000:00:1c.1: restoring config space at offset 0xf (was 0x20200, writing 0x2020b)
pcieport 0000:00:1c.1: restoring config space at offset 0x9 (was 0x1fff1, writing 0x80218011)
pcieport 0000:00:1c.1: restoring config space at offset 0x3 (was 0x810000, writing 0x810008)
pcieport 0000:00:1c.1: restoring config space at offset 0x1 (was 0x100107, writing 0x100507)
pci 0000:00:1e.0: restoring config space at offset 0xf (was 0x20000, writing 0x200ff)
pci 0000:00:1e.0: restoring config space at offset 0x8 (was 0xffb0ff30, writing 0x80008000)
8139too 0000:03:04.0: restoring config space at offset 0x5 (was 0x0, writing 0x80002800)
8139too 0000:03:04.0: restoring config space at offset 0x4 (was 0x1, writing 0xd801)
8139too 0000:03:04.0: restoring config space at offset 0x3 (was 0x0, writing 0x4000)
8139too 0000:03:04.0: restoring config space at offset 0x1 (was 0x2900000, writing 0x2900007)
firewire_ohci 0000:03:06.0: restoring config space at offset 0xf (was 0x100, writing 0x105)
firewire_ohci 0000:03:06.0: restoring config space at offset 0x5 (was 0x0, writing 0x80002000)
firewire_ohci 0000:03:06.0: restoring config space at offset 0x4 (was 0x0, writing 0x80000000)
firewire_ohci 0000:03:06.0: restoring config space at offset 0x3 (was 0x800000, writing 0x804008)
firewire_ohci 0000:03:06.0: restoring config space at offset 0x1 (was 0x2100080, writing 0x2180017)
pci 0000:03:06.2: restoring config space at offset 0xf (was 0x1ff, writing 0x105)
pci 0000:03:06.2: restoring config space at offset 0x4 (was 0x0, writing 0x80002900)
pci 0000:03:06.2: restoring config space at offset 0x3 (was 0x0, writing 0x4008)
pci 0000:03:06.2: restoring config space at offset 0x1 (was 0x4100000, writing 0x4100002)
pci 0000:03:06.3: restoring config space at offset 0xf (was 0x1ff, writing 0x105)
pci 0000:03:06.3: restoring config space at offset 0x4 (was 0x0, writing 0x80001000)
pci 0000:03:06.3: restoring config space at offset 0x3 (was 0x0, writing 0x4008)
pci 0000:03:06.3: restoring config space at offset 0x1 (was 0x4100000, writing 0x4100002)
PM: early resume of devices complete after 1.108 msecs
i915 0000:00:02.0: setting latency timer to 64
snd_hda_intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
snd_hda_intel 0000:00:1b.0: setting latency timer to 64
snd_hda_intel 0000:00:1b.0: irq 42 for MSI/MSI-X
uhci_hcd 0000:00:1d.0: setting latency timer to 64
usb usb2: root hub lost power or was reset
uhci_hcd 0000:00:1d.1: setting latency timer to 64
usb usb3: root hub lost power or was reset
uhci_hcd 0000:00:1d.2: setting latency timer to 64
usb usb4: root hub lost power or was reset
uhci_hcd 0000:00:1d.3: setting latency timer to 64
usb usb5: root hub lost power or was reset
ehci_hcd 0000:00:1d.7: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ata_piix 0000:00:1f.2: setting latency timer to 64
sd 0:0:0:0: [sda] Starting disk
firewire_core: skipped bus generations, destroying all nodes
usb 1-2: reset high speed USB device number 2 using ehci_hcd
rt73usb 1-2:1.0: no reset_resume for driver rt73usb?
wlan0: deauthenticating from 00:40:10:10:00:03 by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
firewire_core: rediscovered device fw0
usb 3-1: reset low speed USB device number 2 using uhci_hcd
ata2.00: ACPI cmd ef/03:42:00:00:00:a0 (SET FEATURES) filtered out
ata2.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
ata2.00: configured for UDMA/33
ata1.00: ACPI cmd ef/03:45:00:00:00:a0 (SET FEATURES) filtered out
ata1.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
ata1.00: ACPI cmd c6/00:10:00:00:00:a0 (SET MULTIPLE MODE) succeeded
ata1.00: configured for UDMA/100
PM: resume of devices complete after 2631.991 msecs
usb 1-2: reset high speed USB device number 2 using ehci_hcd
ieee80211 phy9: Selected rate control algorithm 'minstrel_ht'
Registered led device: rt73usb-phy9::radio
Registered led device: rt73usb-phy9::assoc
Registered led device: rt73usb-phy9::quality
PM: Finishing wakeup.
Restarting tasks ... done.
video LNXVIDEO:00: Restoring backlight state
usbcore: deregistering interface driver rt73usb
usb 1-2: reset high speed USB device number 2 using ehci_hcd
usb 1-7: USB disconnect, device number 10
usb 1-7.1: USB disconnect, device number 11
ieee80211 phy10: Selected rate control algorithm 'minstrel_ht'
Registered led device: rt73usb-phy10::radio
Registered led device: rt73usb-phy10::assoc
Registered led device: rt73usb-phy10::quality
usbcore: registered new interface driver rt73usb
usb 1-7: new high speed USB device number 12 using ehci_hcd
hub 1-7:1.0: USB hub found
hub 1-7:1.0: 4 ports detected
usb 1-7.1: new low speed USB device number 13 using ehci_hcd
input: KEYBOARD USB KB as /devices/pci0000:00/0000:00:1d.7/usb1/1-7/1-7.1/1-7.1:1.0/input/input18
generic-usb 0003:05D5:6782.000A: input,hidraw0: USB HID v1.10 Keyboard [KEYBOARD USB KB] on usb-0000:00:1d.7-7.1/input0
input: KEYBOARD USB KB as /devices/pci0000:00/0000:00:1d.7/usb1/1-7/1-7.1/1-7.1:1.1/input/input19
generic-usb 0003:05D5:6782.000B: input,hidraw1: USB HID v1.10 Mouse [KEYBOARD USB KB] on usb-0000:00:1d.7-7.1/input1
wlan0: authenticate with 00:40:10:10:00:03 (try 1)
wlan0: authenticated
wlan0: associate with 00:40:10:10:00:03 (try 1)
wlan0: RX AssocResp from 00:40:10:10:00:03 (capab=0x411 status=0 aid=2)
wlan0: associated
PM: Syncing filesystems ... done.
PM: Preparing system for mem sleep
Freezing user space processes ... (elapsed 0.01 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
PM: Entering mem sleep
Suspending console(s) (use no_console_suspend to debug)
sd 0:0:0:0: [sda] Synchronizing SCSI cache
sd 0:0:0:0: [sda] Stopping disk
snd_hda_intel 0000:00:1b.0: PCI INT A disabled
ata_piix 0000:00:1f.2: PCI INT B disabled
PM: suspend of devices complete after 1042.597 msecs
PM: late suspend of devices complete after 11.207 msecs
ACPI: Preparing to enter system sleep state S3
PM: Saving platform NVS memory
Disabling non-boot CPUs ...
CPU 1 is now offline
ACPI: Low-level resume complete
PM: Restoring platform NVS memory
Enabling non-boot CPUs ...
Booting Node 0 Processor 1 APIC 0x1
smpboot cpu 1: start_ip = 9b000
Initializing CPU#1
Calibrating delay loop (skipped) already calibrated this CPU
Disabled fast string operations
Switched to NOHz mode on CPU #1
CPU1 is up
ACPI: Waking up from system sleep state S3
pci 0000:00:02.1: restoring config space at offset 0x4 (was 0x0, writing 0xffd80000)
pci 0000:00:02.1: restoring config space at offset 0x1 (was 0x900000, writing 0x900007)
snd_hda_intel 0000:00:1b.0: restoring config space at offset 0x3 (was 0x0, writing 0x8)
snd_hda_intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100006, writing 0x100002)
pcieport 0000:00:1c.0: restoring config space at offset 0xf (was 0x20100, writing 0x2010a)
pcieport 0000:00:1c.0: restoring config space at offset 0x9 (was 0x1fff1, writing 0x80618051)
pcieport 0000:00:1c.0: restoring config space at offset 0x8 (was 0xfff0, writing 0x80408030)
pcieport 0000:00:1c.0: restoring config space at offset 0x7 (was 0xf0, writing 0x1010)
pcieport 0000:00:1c.0: restoring config space at offset 0x3 (was 0x810000, writing 0x810008)
pcieport 0000:00:1c.0: restoring config space at offset 0x1 (was 0x100104, writing 0x100507)
pcieport 0000:00:1c.1: restoring config space at offset 0xf (was 0x20200, writing 0x2020b)
pcieport 0000:00:1c.1: restoring config space at offset 0x9 (was 0x1fff1, writing 0x80218011)
pcieport 0000:00:1c.1: restoring config space at offset 0x3 (was 0x810000, writing 0x810008)
pcieport 0000:00:1c.1: restoring config space at offset 0x1 (was 0x100107, writing 0x100507)
pci 0000:00:1e.0: restoring config space at offset 0xf (was 0x20000, writing 0x200ff)
pci 0000:00:1e.0: restoring config space at offset 0x8 (was 0xffb0ff30, writing 0x80008000)
8139too 0000:03:04.0: restoring config space at offset 0x5 (was 0x0, writing 0x80002800)
8139too 0000:03:04.0: restoring config space at offset 0x4 (was 0x1, writing 0xd801)
8139too 0000:03:04.0: restoring config space at offset 0x3 (was 0x0, writing 0x4000)
8139too 0000:03:04.0: restoring config space at offset 0x1 (was 0x2900000, writing 0x2900007)
firewire_ohci 0000:03:06.0: restoring config space at offset 0xf (was 0x100, writing 0x105)
firewire_ohci 0000:03:06.0: restoring config space at offset 0x5 (was 0x0, writing 0x80002000)
firewire_ohci 0000:03:06.0: restoring config space at offset 0x4 (was 0x0, writing 0x80000000)
firewire_ohci 0000:03:06.0: restoring config space at offset 0x3 (was 0x800000, writing 0x804008)
firewire_ohci 0000:03:06.0: restoring config space at offset 0x1 (was 0x2100080, writing 0x2180017)
pci 0000:03:06.2: restoring config space at offset 0xf (was 0x1ff, writing 0x105)
pci 0000:03:06.2: restoring config space at offset 0x4 (was 0x0, writing 0x80002900)
pci 0000:03:06.2: restoring config space at offset 0x3 (was 0x0, writing 0x4008)
pci 0000:03:06.2: restoring config space at offset 0x1 (was 0x4100000, writing 0x4100002)
pci 0000:03:06.3: restoring config space at offset 0xf (was 0x1ff, writing 0x105)
pci 0000:03:06.3: restoring config space at offset 0x4 (was 0x0, writing 0x80001000)
pci 0000:03:06.3: restoring config space at offset 0x3 (was 0x0, writing 0x4008)
pci 0000:03:06.3: restoring config space at offset 0x1 (was 0x4100000, writing 0x4100002)
PM: early resume of devices complete after 1.108 msecs
i915 0000:00:02.0: setting latency timer to 64
snd_hda_intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
snd_hda_intel 0000:00:1b.0: setting latency timer to 64
snd_hda_intel 0000:00:1b.0: irq 42 for MSI/MSI-X
uhci_hcd 0000:00:1d.0: setting latency timer to 64
usb usb2: root hub lost power or was reset
uhci_hcd 0000:00:1d.1: setting latency timer to 64
usb usb3: root hub lost power or was reset
uhci_hcd 0000:00:1d.2: setting latency timer to 64
usb usb4: root hub lost power or was reset
uhci_hcd 0000:00:1d.3: setting latency timer to 64
usb usb5: root hub lost power or was reset
ehci_hcd 0000:00:1d.7: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ata_piix 0000:00:1f.2: setting latency timer to 64
sd 0:0:0:0: [sda] Starting disk
firewire_core: skipped bus generations, destroying all nodes
usb 1-2: reset high speed USB device number 2 using ehci_hcd
rt73usb 1-2:1.0: no reset_resume for driver rt73usb?
wlan0: deauthenticating from 00:40:10:10:00:03 by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
firewire_core: rediscovered device fw0
usb 3-1: reset low speed USB device number 2 using uhci_hcd
ata2.00: ACPI cmd ef/03:42:00:00:00:a0 (SET FEATURES) filtered out
ata2.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
ata2.00: configured for UDMA/33
ata1.00: ACPI cmd ef/03:45:00:00:00:a0 (SET FEATURES) filtered out
ata1.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
ata1.00: ACPI cmd c6/00:10:00:00:00:a0 (SET MULTIPLE MODE) succeeded
ata1.00: configured for UDMA/100
PM: resume of devices complete after 2637.091 msecs
usb 1-2: reset high speed USB device number 2 using ehci_hcd
ieee80211 phy11: Selected rate control algorithm 'minstrel_ht'
Registered led device: rt73usb-phy11::radio
Registered led device: rt73usb-phy11::assoc
Registered led device: rt73usb-phy11::quality
PM: Finishing wakeup.
Restarting tasks ... done.
video LNXVIDEO:00: Restoring backlight state
usbcore: deregistering interface driver rt73usb
usb 1-2: reset high speed USB device number 2 using ehci_hcd
ieee80211 phy12: Selected rate control algorithm 'minstrel_ht'
Registered led device: rt73usb-phy12::radio
Registered led device: rt73usb-phy12::assoc
Registered led device: rt73usb-phy12::quality
usbcore: registered new interface driver rt73usb
wlan0: authenticate with 00:40:10:10:00:03 (try 1)
wlan0: authenticated
wlan0: associate with 00:40:10:10:00:03 (try 1)
wlan0: RX AssocResp from 00:40:10:10:00:03 (capab=0x411 status=0 aid=1)
wlan0: associated
usb 1-7: USB disconnect, device number 12
usb 1-7.1: USB disconnect, device number 13
usb 1-7: new high speed USB device number 14 using ehci_hcd
hub 1-7:1.0: USB hub found
hub 1-7:1.0: 4 ports detected
usb 1-7.1: new low speed USB device number 15 using ehci_hcd
input: KEYBOARD USB KB as /devices/pci0000:00/0000:00:1d.7/usb1/1-7/1-7.1/1-7.1:1.0/input/input20
generic-usb 0003:05D5:6782.000C: input,hidraw0: USB HID v1.10 Keyboard [KEYBOARD USB KB] on usb-0000:00:1d.7-7.1/input0
input: KEYBOARD USB KB as /devices/pci0000:00/0000:00:1d.7/usb1/1-7/1-7.1/1-7.1:1.1/input/input21
generic-usb 0003:05D5:6782.000D: input,hidraw1: USB HID v1.10 Mouse [KEYBOARD USB KB] on usb-0000:00:1d.7-7.1/input1
PM: Marking nosave pages: 000000000009f000 - 0000000000100000
PM: Basic memory bitmaps created
PM: Syncing filesystems ... done.
Freezing user space processes ... (elapsed 0.01 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
PM: Preallocating image memory... done (allocated 302355 pages)
PM: Allocated 1209420 kbytes in 0.58 seconds (2085.20 MB/s)
Suspending console(s) (use no_console_suspend to debug)
sd 0:0:0:0: [sda] Synchronizing SCSI cache
ata_piix 0000:00:1f.2: PCI INT B disabled
snd_hda_intel 0000:00:1b.0: PCI INT A disabled
PM: freeze of devices complete after 332.194 msecs
PM: late freeze of devices complete after 0.733 msecs
ACPI: Preparing to enter system sleep state S4
PM: Saving platform NVS memory
Disabling non-boot CPUs ...
CPU 1 is now offline
PM: Creating hibernation image:
PM: Need to copy 151115 pages
PM: Normal pages needed: 31259 + 1024, available pages: 195919
PM: Restoring platform NVS memory
Enabling non-boot CPUs ...
Booting Node 0 Processor 1 APIC 0x1
smpboot cpu 1: start_ip = 9b000
Initializing CPU#1
Calibrating delay loop (skipped) already calibrated this CPU
Disabled fast string operations
Switched to NOHz mode on CPU #1
CPU1 is up
ACPI: Waking up from system sleep state S4
snd_hda_intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100006, writing 0x100002)
ata_piix 0000:00:1f.2: restoring config space at offset 0x1 (was 0x2b80001, writing 0x2b80005)
firewire_ohci 0000:03:06.0: restoring config space at offset 0x1 (was 0x2100015, writing 0x2180017)
pci 0000:03:06.3: restoring config space at offset 0x1 (was 0x84100002, writing 0x4100002)
PM: early restore of devices complete after 1.003 msecs
i915 0000:00:02.0: setting latency timer to 64
snd_hda_intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
snd_hda_intel 0000:00:1b.0: setting latency timer to 64
snd_hda_intel 0000:00:1b.0: irq 42 for MSI/MSI-X
uhci_hcd 0000:00:1d.0: setting latency timer to 64
usb usb2: root hub lost power or was reset
uhci_hcd 0000:00:1d.1: setting latency timer to 64
usb usb3: root hub lost power or was reset
uhci_hcd 0000:00:1d.2: setting latency timer to 64
usb usb4: root hub lost power or was reset
uhci_hcd 0000:00:1d.3: setting latency timer to 64
usb usb5: root hub lost power or was reset
ehci_hcd 0000:00:1d.7: setting latency timer to 64
usb usb1: root hub lost power or was reset
pci 0000:00:1e.0: setting latency timer to 64
ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ata_piix 0000:00:1f.2: setting latency timer to 64
ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
sd 0:0:0:0: [sda] Starting disk
firewire_core: skipped bus generations, destroying all nodes
ata1.00: ACPI cmd ef/03:45:00:00:00:a0 (SET FEATURES) filtered out
ata1.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
ata1.00: ACPI cmd c6/00:10:00:00:00:a0 (SET MULTIPLE MODE) succeeded
ata2.00: ACPI cmd ef/03:42:00:00:00:a0 (SET FEATURES) filtered out
ata2.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
ata1.00: configured for UDMA/100
ata2.00: configured for UDMA/33
firewire_core: rediscovered device fw0
usb 3-1: reset low speed USB device number 2 using uhci_hcd
usb 1-7: reset high speed USB device number 14 using ehci_hcd
usb 1-2: reset high speed USB device number 2 using ehci_hcd
rt73usb 1-2:1.0: no reset_resume for driver rt73usb?
wlan0: deauthenticating from 00:40:10:10:00:03 by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
usb 1-7.1: reset low speed USB device number 15 using ehci_hcd
PM: restore of devices complete after 1864.099 msecs
usb 1-2: reset high speed USB device number 2 using ehci_hcd
ieee80211 phy13: Selected rate control algorithm 'minstrel_ht'
Registered led device: rt73usb-phy13::radio
Registered led device: rt73usb-phy13::assoc
Registered led device: rt73usb-phy13::quality
PM: Image restored successfully.
Restarting tasks ... done.
PM: Basic memory bitmaps freed
video LNXVIDEO:00: Restoring backlight state
usbcore: deregistering interface driver rt73usb
usb 1-2: reset high speed USB device number 2 using ehci_hcd
ieee80211 phy14: Selected rate control algorithm 'minstrel_ht'
Registered led device: rt73usb-phy14::radio
Registered led device: rt73usb-phy14::assoc
Registered led device: rt73usb-phy14::quality
usbcore: registered new interface driver rt73usb
wlan0: authenticate with 00:40:10:10:00:03 (try 1)
wlan0: authenticated
wlan0: associate with 00:40:10:10:00:03 (try 1)
wlan0: RX AssocResp from 00:40:10:10:00:03 (capab=0x411 status=0 aid=2)
wlan0: associated
usb 1-7: USB disconnect, device number 14
usb 1-7.1: USB disconnect, device number 15
usb 1-7: new high speed USB device number 16 using ehci_hcd
hub 1-7:1.0: USB hub found
hub 1-7:1.0: 4 ports detected
usb 1-7.1: new low speed USB device number 17 using ehci_hcd
input: KEYBOARD USB KB as /devices/pci0000:00/0000:00:1d.7/usb1/1-7/1-7.1/1-7.1:1.0/input/input22
generic-usb 0003:05D5:6782.000E: input,hidraw0: USB HID v1.10 Keyboard [KEYBOARD USB KB] on usb-0000:00:1d.7-7.1/input0
input: KEYBOARD USB KB as /devices/pci0000:00/0000:00:1d.7/usb1/1-7/1-7.1/1-7.1:1.1/input/input23
generic-usb 0003:05D5:6782.000F: input,hidraw1: USB HID v1.10 Mouse [KEYBOARD USB KB] on usb-0000:00:1d.7-7.1/input1
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.3: setting latency timer to 64
uhci_hcd 0000:00:1d.1: setting latency timer to 64
usb 3-1: USB disconnect, device number 2
usb 3-1: new low speed USB device number 3 using uhci_hcd
input: Genius Laser Mouse as /devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1:1.0/input/input24
generic-usb 0003:0458:003A.0010: input,hidraw2: USB HID v1.10 Mouse [Genius Laser Mouse] on usb-0000:00:1d.1-1/input0
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.3: setting latency timer to 64
PM: Marking nosave pages: 000000000009f000 - 0000000000100000
PM: Basic memory bitmaps created
PM: Syncing filesystems ... done.
Freezing user space processes ... (elapsed 0.01 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.3: setting latency timer to 64
PM: Preallocating image memory... done (allocated 302355 pages)
PM: Allocated 1209420 kbytes in 0.31 seconds (3901.35 MB/s)
Suspending console(s) (use no_console_suspend to debug)
sd 0:0:0:0: [sda] Synchronizing SCSI cache
ata_piix 0000:00:1f.2: PCI INT B disabled
snd_hda_intel 0000:00:1b.0: PCI INT A disabled
PM: freeze of devices complete after 19.946 msecs
PM: late freeze of devices complete after 0.718 msecs
ACPI: Preparing to enter system sleep state S4
PM: Saving platform NVS memory
Disabling non-boot CPUs ...
CPU 1 is now offline
PM: Creating hibernation image:
PM: Need to copy 182261 pages
PM: Normal pages needed: 37741 + 1024, available pages: 195247
PM: Restoring platform NVS memory
Enabling non-boot CPUs ...
Booting Node 0 Processor 1 APIC 0x1
smpboot cpu 1: start_ip = 9b000
Initializing CPU#1
Calibrating delay loop (skipped) already calibrated this CPU
Disabled fast string operations
Switched to NOHz mode on CPU #1
CPU1 is up
ACPI: Waking up from system sleep state S4
snd_hda_intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100006, writing 0x100002)
ata_piix 0000:00:1f.2: restoring config space at offset 0x1 (was 0x2b80001, writing 0x2b80005)
firewire_ohci 0000:03:06.0: restoring config space at offset 0x1 (was 0x2100015, writing 0x2180017)
PM: early restore of devices complete after 0.999 msecs
i915 0000:00:02.0: setting latency timer to 64
snd_hda_intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
snd_hda_intel 0000:00:1b.0: setting latency timer to 64
snd_hda_intel 0000:00:1b.0: irq 42 for MSI/MSI-X
uhci_hcd 0000:00:1d.0: setting latency timer to 64
usb usb2: root hub lost power or was reset
uhci_hcd 0000:00:1d.1: setting latency timer to 64
usb usb3: root hub lost power or was reset
uhci_hcd 0000:00:1d.2: setting latency timer to 64
usb usb4: root hub lost power or was reset
uhci_hcd 0000:00:1d.3: setting latency timer to 64
usb usb5: root hub lost power or was reset
ehci_hcd 0000:00:1d.7: setting latency timer to 64
usb usb1: root hub lost power or was reset
pci 0000:00:1e.0: setting latency timer to 64
ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ata_piix 0000:00:1f.2: setting latency timer to 64
ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
sd 0:0:0:0: [sda] Starting disk
firewire_core: skipped bus generations, destroying all nodes
ata1.00: ACPI cmd ef/03:45:00:00:00:a0 (SET FEATURES) filtered out
ata1.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
ata1.00: ACPI cmd c6/00:10:00:00:00:a0 (SET MULTIPLE MODE) succeeded
ata2.00: ACPI cmd ef/03:42:00:00:00:a0 (SET FEATURES) filtered out
ata2.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
ata1.00: configured for UDMA/100
ata2.00: configured for UDMA/33
usb 1-7: reset high speed USB device number 16 using ehci_hcd
firewire_core: rediscovered device fw0
usb 1-2: reset high speed USB device number 2 using ehci_hcd
rt73usb 1-2:1.0: no reset_resume for driver rt73usb?
wlan0: deauthenticating from 00:40:10:10:00:03 by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
usb 3-1: reset low speed USB device number 3 using uhci_hcd
usb 1-7.1: reset low speed USB device number 17 using ehci_hcd
PM: restore of devices complete after 1864.747 msecs
usb 1-2: reset high speed USB device number 2 using ehci_hcd
ieee80211 phy15: Selected rate control algorithm 'minstrel_ht'
Registered led device: rt73usb-phy15::radio
Registered led device: rt73usb-phy15::assoc
Registered led device: rt73usb-phy15::quality
PM: Image restored successfully.
Restarting tasks ... done.
PM: Basic memory bitmaps freed
video LNXVIDEO:00: Restoring backlight state
usbcore: deregistering interface driver rt73usb
usb 1-2: reset high speed USB device number 2 using ehci_hcd
ieee80211 phy16: Selected rate control algorithm 'minstrel_ht'
Registered led device: rt73usb-phy16::radio
Registered led device: rt73usb-phy16::assoc
Registered led device: rt73usb-phy16::quality
usbcore: registered new interface driver rt73usb
wlan0: authenticate with 00:40:10:10:00:03 (try 1)
wlan0: authenticated
wlan0: associate with 00:40:10:10:00:03 (try 1)
wlan0: RX AssocResp from 00:40:10:10:00:03 (capab=0x411 status=0 aid=1)
wlan0: associated
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.3: setting latency timer to 64
usb 1-7: USB disconnect, device number 16
usb 1-7.1: USB disconnect, device number 17
usb 1-7: new high speed USB device number 19 using ehci_hcd
hub 1-7:1.0: USB hub found
hub 1-7:1.0: 4 ports detected
usb 1-7.1: new low speed USB device number 20 using ehci_hcd
input: KEYBOARD USB KB as /devices/pci0000:00/0000:00:1d.7/usb1/1-7/1-7.1/1-7.1:1.0/input/input25
generic-usb 0003:05D5:6782.0011: input,hidraw0: USB HID v1.10 Keyboard [KEYBOARD USB KB] on usb-0000:00:1d.7-7.1/input0
input: KEYBOARD USB KB as /devices/pci0000:00/0000:00:1d.7/usb1/1-7/1-7.1/1-7.1:1.1/input/input26
generic-usb 0003:05D5:6782.0012: input,hidraw1: USB HID v1.10 Mouse [KEYBOARD USB KB] on usb-0000:00:1d.7-7.1/input1
PM: Syncing filesystems ... done.
PM: Preparing system for mem sleep
Freezing user space processes ... (elapsed 0.01 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
PM: Entering mem sleep
Suspending console(s) (use no_console_suspend to debug)
sd 0:0:0:0: [sda] Synchronizing SCSI cache
sd 0:0:0:0: [sda] Stopping disk
snd_hda_intel 0000:00:1b.0: PCI INT A disabled
ata_piix 0000:00:1f.2: PCI INT B disabled
PM: suspend of devices complete after 1021.590 msecs
PM: late suspend of devices complete after 11.223 msecs
ACPI: Preparing to enter system sleep state S3
PM: Saving platform NVS memory
Disabling non-boot CPUs ...
CPU 1 is now offline
ACPI: Low-level resume complete
PM: Restoring platform NVS memory
Enabling non-boot CPUs ...
Booting Node 0 Processor 1 APIC 0x1
smpboot cpu 1: start_ip = 9b000
Initializing CPU#1
Calibrating delay loop (skipped) already calibrated this CPU
Disabled fast string operations
Switched to NOHz mode on CPU #1
CPU1 is up
ACPI: Waking up from system sleep state S3
pci 0000:00:02.1: restoring config space at offset 0x4 (was 0x0, writing 0xffd80000)
pci 0000:00:02.1: restoring config space at offset 0x1 (was 0x900000, writing 0x900007)
snd_hda_intel 0000:00:1b.0: restoring config space at offset 0x3 (was 0x0, writing 0x8)
snd_hda_intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100006, writing 0x100002)
pcieport 0000:00:1c.0: restoring config space at offset 0xf (was 0x20100, writing 0x2010a)
pcieport 0000:00:1c.0: restoring config space at offset 0x9 (was 0x1fff1, writing 0x80618051)
pcieport 0000:00:1c.0: restoring config space at offset 0x8 (was 0xfff0, writing 0x80408030)
pcieport 0000:00:1c.0: restoring config space at offset 0x7 (was 0xf0, writing 0x1010)
pcieport 0000:00:1c.0: restoring config space at offset 0x3 (was 0x810000, writing 0x810008)
pcieport 0000:00:1c.0: restoring config space at offset 0x1 (was 0x100104, writing 0x100507)
pcieport 0000:00:1c.1: restoring config space at offset 0xf (was 0x20200, writing 0x2020b)
pcieport 0000:00:1c.1: restoring config space at offset 0x9 (was 0x1fff1, writing 0x80218011)
pcieport 0000:00:1c.1: restoring config space at offset 0x3 (was 0x810000, writing 0x810008)
pcieport 0000:00:1c.1: restoring config space at offset 0x1 (was 0x100107, writing 0x100507)
pci 0000:00:1e.0: restoring config space at offset 0xf (was 0x20000, writing 0x200ff)
pci 0000:00:1e.0: restoring config space at offset 0x8 (was 0xffb0ff30, writing 0x80008000)
8139too 0000:03:04.0: restoring config space at offset 0x5 (was 0x0, writing 0x80002800)
8139too 0000:03:04.0: restoring config space at offset 0x4 (was 0x1, writing 0xd801)
8139too 0000:03:04.0: restoring config space at offset 0x3 (was 0x0, writing 0x4000)
8139too 0000:03:04.0: restoring config space at offset 0x1 (was 0x2900000, writing 0x2900007)
firewire_ohci 0000:03:06.0: restoring config space at offset 0xf (was 0x100, writing 0x105)
firewire_ohci 0000:03:06.0: restoring config space at offset 0x5 (was 0x0, writing 0x80002000)
firewire_ohci 0000:03:06.0: restoring config space at offset 0x4 (was 0x0, writing 0x80000000)
firewire_ohci 0000:03:06.0: restoring config space at offset 0x3 (was 0x800000, writing 0x804008)
firewire_ohci 0000:03:06.0: restoring config space at offset 0x1 (was 0x2100080, writing 0x2180017)
pci 0000:03:06.2: restoring config space at offset 0xf (was 0x1ff, writing 0x105)
pci 0000:03:06.2: restoring config space at offset 0x4 (was 0x0, writing 0x80002900)
pci 0000:03:06.2: restoring config space at offset 0x3 (was 0x0, writing 0x4008)
pci 0000:03:06.2: restoring config space at offset 0x1 (was 0x4100000, writing 0x4100002)
pci 0000:03:06.3: restoring config space at offset 0xf (was 0x1ff, writing 0x105)
pci 0000:03:06.3: restoring config space at offset 0x4 (was 0x0, writing 0x80001000)
pci 0000:03:06.3: restoring config space at offset 0x3 (was 0x0, writing 0x4008)
pci 0000:03:06.3: restoring config space at offset 0x1 (was 0x4100000, writing 0x84100002)
PM: early resume of devices complete after 1.110 msecs
i915 0000:00:02.0: setting latency timer to 64
snd_hda_intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
snd_hda_intel 0000:00:1b.0: setting latency timer to 64
snd_hda_intel 0000:00:1b.0: irq 42 for MSI/MSI-X
uhci_hcd 0000:00:1d.0: setting latency timer to 64
usb usb2: root hub lost power or was reset
uhci_hcd 0000:00:1d.1: setting latency timer to 64
usb usb3: root hub lost power or was reset
uhci_hcd 0000:00:1d.2: setting latency timer to 64
usb usb4: root hub lost power or was reset
uhci_hcd 0000:00:1d.3: setting latency timer to 64
usb usb5: root hub lost power or was reset
ehci_hcd 0000:00:1d.7: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ata_piix 0000:00:1f.2: setting latency timer to 64
sd 0:0:0:0: [sda] Starting disk
firewire_core: skipped bus generations, destroying all nodes
usb 1-2: reset high speed USB device number 2 using ehci_hcd
rt73usb 1-2:1.0: no reset_resume for driver rt73usb?
wlan0: deauthenticating from 00:40:10:10:00:03 by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
firewire_core: rediscovered device fw0
usb 3-1: reset low speed USB device number 3 using uhci_hcd
ata2.00: ACPI cmd ef/03:42:00:00:00:a0 (SET FEATURES) filtered out
ata2.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
ata2.00: configured for UDMA/33
ata1.00: ACPI cmd ef/03:45:00:00:00:a0 (SET FEATURES) filtered out
ata1.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
ata1.00: ACPI cmd c6/00:10:00:00:00:a0 (SET MULTIPLE MODE) succeeded
ata1.00: configured for UDMA/100
PM: resume of devices complete after 2627.098 msecs
usb 1-2: reset high speed USB device number 2 using ehci_hcd
ieee80211 phy17: Selected rate control algorithm 'minstrel_ht'
Registered led device: rt73usb-phy17::radio
Registered led device: rt73usb-phy17::assoc
Registered led device: rt73usb-phy17::quality
PM: Finishing wakeup.
Restarting tasks ... done.
video LNXVIDEO:00: Restoring backlight state
usbcore: deregistering interface driver rt73usb
usb 1-2: reset high speed USB device number 2 using ehci_hcd
ieee80211 phy18: Selected rate control algorithm 'minstrel_ht'
Registered led device: rt73usb-phy18::radio
Registered led device: rt73usb-phy18::assoc
Registered led device: rt73usb-phy18::quality
usbcore: registered new interface driver rt73usb
wlan0: authenticate with 00:40:10:10:00:03 (try 1)
wlan0: authenticated
wlan0: associate with 00:40:10:10:00:03 (try 1)
wlan0: RX AssocResp from 00:40:10:10:00:03 (capab=0x411 status=0 aid=1)
wlan0: associated
usb 1-7: USB disconnect, device number 19
usb 1-7.1: USB disconnect, device number 20
generic-usb 0003:05D5:6782.0011: can't reset device, 0000:00:1d.7-7.1/input0, status -71
usb 1-7: clear tt 1 (0140) error -19
generic-usb 0003:05D5:6782.0012: can't reset device, 0000:00:1d.7-7.1/input1, status -71
usb 1-7: clear tt 1 (0140) error -19
usb 1-7: new high speed USB device number 21 using ehci_hcd
hub 1-7:1.0: USB hub found
hub 1-7:1.0: 4 ports detected
usb 1-7.1: new low speed USB device number 22 using ehci_hcd
input: KEYBOARD USB KB as /devices/pci0000:00/0000:00:1d.7/usb1/1-7/1-7.1/1-7.1:1.0/input/input27
generic-usb 0003:05D5:6782.0013: input,hidraw0: USB HID v1.10 Keyboard [KEYBOARD USB KB] on usb-0000:00:1d.7-7.1/input0
input: KEYBOARD USB KB as /devices/pci0000:00/0000:00:1d.7/usb1/1-7/1-7.1/1-7.1:1.1/input/input28
generic-usb 0003:05D5:6782.0014: input,hidraw1: USB HID v1.10 Mouse [KEYBOARD USB KB] on usb-0000:00:1d.7-7.1/input1
PM: Marking nosave pages: 000000000009f000 - 0000000000100000
PM: Basic memory bitmaps created
PM: Syncing filesystems ... done.
Freezing user space processes ... (elapsed 0.01 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
PM: Preallocating image memory... done (allocated 302355 pages)
PM: Allocated 1209420 kbytes in 0.67 seconds (1805.10 MB/s)
Suspending console(s) (use no_console_suspend to debug)
snd_hda_intel 0000:00:1b.0: PCI INT A disabled
sd 0:0:0:0: [sda] Synchronizing SCSI cache
ata_piix 0000:00:1f.2: PCI INT B disabled
PM: freeze of devices complete after 208.794 msecs
PM: late freeze of devices complete after 0.748 msecs
ACPI: Preparing to enter system sleep state S4
PM: Saving platform NVS memory
Disabling non-boot CPUs ...
CPU 1 is now offline
PM: Creating hibernation image:
PM: Need to copy 179326 pages
PM: Normal pages needed: 42339 + 1024, available pages: 184839
PM: Restoring platform NVS memory
Enabling non-boot CPUs ...
Booting Node 0 Processor 1 APIC 0x1
smpboot cpu 1: start_ip = 9b000
Initializing CPU#1
Calibrating delay loop (skipped) already calibrated this CPU
Disabled fast string operations
Switched to NOHz mode on CPU #1
CPU1 is up
ACPI: Waking up from system sleep state S4
snd_hda_intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100006, writing 0x100002)
ata_piix 0000:00:1f.2: restoring config space at offset 0x1 (was 0x2b80001, writing 0x2b80005)
firewire_ohci 0000:03:06.0: restoring config space at offset 0x1 (was 0x2100015, writing 0x2180017)
pci 0000:03:06.3: restoring config space at offset 0x1 (was 0x84100002, writing 0x4100002)
PM: early restore of devices complete after 1.009 msecs
i915 0000:00:02.0: setting latency timer to 64
snd_hda_intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
snd_hda_intel 0000:00:1b.0: setting latency timer to 64
snd_hda_intel 0000:00:1b.0: irq 42 for MSI/MSI-X
uhci_hcd 0000:00:1d.0: setting latency timer to 64
usb usb2: root hub lost power or was reset
uhci_hcd 0000:00:1d.1: setting latency timer to 64
usb usb3: root hub lost power or was reset
uhci_hcd 0000:00:1d.2: setting latency timer to 64
usb usb4: root hub lost power or was reset
uhci_hcd 0000:00:1d.3: setting latency timer to 64
usb usb5: root hub lost power or was reset
ehci_hcd 0000:00:1d.7: setting latency timer to 64
usb usb1: root hub lost power or was reset
pci 0000:00:1e.0: setting latency timer to 64
ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ata_piix 0000:00:1f.2: setting latency timer to 64
ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
sd 0:0:0:0: [sda] Starting disk
firewire_core: skipped bus generations, destroying all nodes
ata1.00: ACPI cmd ef/03:45:00:00:00:a0 (SET FEATURES) filtered out
ata1.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
ata1.00: ACPI cmd c6/00:10:00:00:00:a0 (SET MULTIPLE MODE) succeeded
ata2.00: ACPI cmd ef/03:42:00:00:00:a0 (SET FEATURES) filtered out
ata2.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
ata1.00: configured for UDMA/100
ata2.00: configured for UDMA/33
usb 1-2: reset high speed USB device number 2 using ehci_hcd
firewire_core: rediscovered device fw0
rt73usb 1-2:1.0: no reset_resume for driver rt73usb?
wlan0: deauthenticating from 00:40:10:10:00:03 by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
usb 3-1: reset low speed USB device number 3 using uhci_hcd
PM: restore of devices complete after 1145.627 msecs
usb 1-2: reset high speed USB device number 2 using ehci_hcd
ieee80211 phy19: Selected rate control algorithm 'minstrel_ht'
Registered led device: rt73usb-phy19::radio
Registered led device: rt73usb-phy19::assoc
Registered led device: rt73usb-phy19::quality
PM: Image restored successfully.
Restarting tasks ... 
usb 1-7: USB disconnect, device number 21
usb 1-7.1: USB disconnect, device number 22
done.
PM: Basic memory bitmaps freed
video LNXVIDEO:00: Restoring backlight state
usbcore: deregistering interface driver rt73usb
usb 1-2: reset high speed USB device number 2 using ehci_hcd
ieee80211 phy20: Selected rate control algorithm 'minstrel_ht'
Registered led device: rt73usb-phy20::radio
Registered led device: rt73usb-phy20::assoc
Registered led device: rt73usb-phy20::quality
usbcore: registered new interface driver rt73usb
usb 1-7: new high speed USB device number 23 using ehci_hcd
hub 1-7:1.0: USB hub found
hub 1-7:1.0: 4 ports detected
usb 1-7.1: new low speed USB device number 24 using ehci_hcd
input: KEYBOARD USB KB as /devices/pci0000:00/0000:00:1d.7/usb1/1-7/1-7.1/1-7.1:1.0/input/input29
generic-usb 0003:05D5:6782.0015: input,hidraw0: USB HID v1.10 Keyboard [KEYBOARD USB KB] on usb-0000:00:1d.7-7.1/input0
input: KEYBOARD USB KB as /devices/pci0000:00/0000:00:1d.7/usb1/1-7/1-7.1/1-7.1:1.1/input/input30
generic-usb 0003:05D5:6782.0016: input,hidraw1: USB HID v1.10 Mouse [KEYBOARD USB KB] on usb-0000:00:1d.7-7.1/input1
wlan0: authenticate with 00:40:10:10:00:03 (try 1)
wlan0: authenticated
wlan0: associate with 00:40:10:10:00:03 (try 1)
wlan0: RX AssocResp from 00:40:10:10:00:03 (capab=0x411 status=0 aid=1)
wlan0: associated
PM: Marking nosave pages: 000000000009f000 - 0000000000100000
PM: Basic memory bitmaps created
PM: Syncing filesystems ... done.
Freezing user space processes ... (elapsed 0.01 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
PM: Preallocating image memory... done (allocated 302355 pages)
PM: Allocated 1209420 kbytes in 0.46 seconds (2629.17 MB/s)
Suspending console(s) (use no_console_suspend to debug)
snd_hda_intel 0000:00:1b.0: PCI INT A disabled
sd 0:0:0:0: [sda] Synchronizing SCSI cache
ata_piix 0000:00:1f.2: PCI INT B disabled
PM: freeze of devices complete after 208.050 msecs
PM: late freeze of devices complete after 0.762 msecs
ACPI: Preparing to enter system sleep state S4
PM: Saving platform NVS memory
Disabling non-boot CPUs ...
CPU 1 is now offline
PM: Creating hibernation image:
PM: Need to copy 163178 pages
PM: Normal pages needed: 26775 + 1024, available pages: 200403
PM: Restoring platform NVS memory
Enabling non-boot CPUs ...
Booting Node 0 Processor 1 APIC 0x1
smpboot cpu 1: start_ip = 9b000
Initializing CPU#1
Calibrating delay loop (skipped) already calibrated this CPU
Disabled fast string operations
Switched to NOHz mode on CPU #1
CPU1 is up
ACPI: Waking up from system sleep state S4
snd_hda_intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100006, writing 0x100002)
ata_piix 0000:00:1f.2: restoring config space at offset 0x1 (was 0x2b80001, writing 0x2b80005)
firewire_ohci 0000:03:06.0: restoring config space at offset 0x1 (was 0x2100015, writing 0x2180017)
PM: early restore of devices complete after 1.005 msecs
i915 0000:00:02.0: setting latency timer to 64
snd_hda_intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
snd_hda_intel 0000:00:1b.0: setting latency timer to 64
snd_hda_intel 0000:00:1b.0: irq 42 for MSI/MSI-X
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.1: setting latency timer to 64
usb usb2: root hub lost power or was reset
usb usb3: root hub lost power or was reset
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.3: setting latency timer to 64
usb usb4: root hub lost power or was reset
usb usb5: root hub lost power or was reset
ehci_hcd 0000:00:1d.7: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
usb usb1: root hub lost power or was reset
ata_piix 0000:00:1f.2: setting latency timer to 64
sd 0:0:0:0: [sda] Starting disk
ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
firewire_core: skipped bus generations, destroying all nodes
ata1.00: ACPI cmd ef/03:45:00:00:00:a0 (SET FEATURES) filtered out
ata1.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
ata1.00: ACPI cmd c6/00:10:00:00:00:a0 (SET MULTIPLE MODE) succeeded
ata2.00: ACPI cmd ef/03:42:00:00:00:a0 (SET FEATURES) filtered out
ata2.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
ata1.00: configured for UDMA/100
ata2.00: configured for UDMA/33
usb 1-7: reset high speed USB device number 23 using ehci_hcd
firewire_core: rediscovered device fw0
usb 1-2: reset high speed USB device number 2 using ehci_hcd
rt73usb 1-2:1.0: no reset_resume for driver rt73usb?
wlan0: deauthenticating from 00:40:10:10:00:03 by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
usb 3-1: reset low speed USB device number 3 using uhci_hcd
usb 1-7.1: reset low speed USB device number 24 using ehci_hcd
PM: restore of devices complete after 2466.114 msecs
usb 1-2: reset high speed USB device number 2 using ehci_hcd
ieee80211 phy21: Selected rate control algorithm 'minstrel_ht'
Registered led device: rt73usb-phy21::radio
Registered led device: rt73usb-phy21::assoc
Registered led device: rt73usb-phy21::quality
PM: Image restored successfully.
Restarting tasks ... done.
PM: Basic memory bitmaps freed
video LNXVIDEO:00: Restoring backlight state
usbcore: deregistering interface driver rt73usb
usb 1-2: reset high speed USB device number 2 using ehci_hcd
ieee80211 phy22: Selected rate control algorithm 'minstrel_ht'
Registered led device: rt73usb-phy22::radio
Registered led device: rt73usb-phy22::assoc
Registered led device: rt73usb-phy22::quality
usbcore: registered new interface driver rt73usb
usb 1-7: USB disconnect, device number 23
usb 1-7.1: USB disconnect, device number 24
generic-usb 0003:05D5:6782.0015: can't reset device, 0000:00:1d.7-7.1/input0, status -71
usb 1-7: clear tt 1 (0180) error -19
wlan0: authenticate with 00:40:10:10:00:03 (try 1)
wlan0: authenticated
wlan0: associate with 00:40:10:10:00:03 (try 1)
wlan0: RX AssocResp from 00:40:10:10:00:03 (capab=0x411 status=0 aid=1)
wlan0: associated
usb 1-7: new high speed USB device number 25 using ehci_hcd
hub 1-7:1.0: USB hub found
hub 1-7:1.0: 4 ports detected
usb 1-7.1: new low speed USB device number 26 using ehci_hcd
input: KEYBOARD USB KB as /devices/pci0000:00/0000:00:1d.7/usb1/1-7/1-7.1/1-7.1:1.0/input/input31
generic-usb 0003:05D5:6782.0017: input,hidraw0: USB HID v1.10 Keyboard [KEYBOARD USB KB] on usb-0000:00:1d.7-7.1/input0
input: KEYBOARD USB KB as /devices/pci0000:00/0000:00:1d.7/usb1/1-7/1-7.1/1-7.1:1.1/input/input32
generic-usb 0003:05D5:6782.0018: input,hidraw1: USB HID v1.10 Mouse [KEYBOARD USB KB] on usb-0000:00:1d.7-7.1/input1
PM: Marking nosave pages: 000000000009f000 - 0000000000100000
PM: Basic memory bitmaps created
PM: Syncing filesystems ... done.
Freezing user space processes ... (elapsed 0.01 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
PM: Preallocating image memory... done (allocated 302343 pages)
PM: Allocated 1209372 kbytes in 0.34 seconds (3556.97 MB/s)
Suspending console(s) (use no_console_suspend to debug)
sd 0:0:0:0: [sda] Synchronizing SCSI cache
ata_piix 0000:00:1f.2: PCI INT B disabled
snd_hda_intel 0000:00:1b.0: PCI INT A disabled
PM: freeze of devices complete after 432.779 msecs
PM: late freeze of devices complete after 0.729 msecs
ACPI: Preparing to enter system sleep state S4
PM: Saving platform NVS memory
Disabling non-boot CPUs ...
CPU 1 is now offline
PM: Creating hibernation image:
PM: Need to copy 195216 pages
PM: Normal pages needed: 68343 + 1024, available pages: 199939
PM: Restoring platform NVS memory
Enabling non-boot CPUs ...
Booting Node 0 Processor 1 APIC 0x1
smpboot cpu 1: start_ip = 9b000
Initializing CPU#1
Calibrating delay loop (skipped) already calibrated this CPU
Disabled fast string operations
Switched to NOHz mode on CPU #1
CPU1 is up
ACPI: Waking up from system sleep state S4
snd_hda_intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100006, writing 0x100002)
ata_piix 0000:00:1f.2: restoring config space at offset 0x1 (was 0x2b80001, writing 0x2b80005)
firewire_ohci 0000:03:06.0: restoring config space at offset 0x1 (was 0x2100015, writing 0x2180017)
PM: early restore of devices complete after 1.002 msecs
i915 0000:00:02.0: setting latency timer to 64
snd_hda_intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
snd_hda_intel 0000:00:1b.0: setting latency timer to 64
snd_hda_intel 0000:00:1b.0: irq 42 for MSI/MSI-X
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.1: setting latency timer to 64
usb usb2: root hub lost power or was reset
usb usb3: root hub lost power or was reset
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.3: setting latency timer to 64
usb usb4: root hub lost power or was reset
usb usb5: root hub lost power or was reset
ehci_hcd 0000:00:1d.7: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
usb usb1: root hub lost power or was reset
ata_piix 0000:00:1f.2: setting latency timer to 64
sd 0:0:0:0: [sda] Starting disk
ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
firewire_core: skipped bus generations, destroying all nodes
ata2.00: ACPI cmd ef/03:42:00:00:00:a0 (SET FEATURES) filtered out
ata2.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
ata1.00: ACPI cmd ef/03:45:00:00:00:a0 (SET FEATURES) filtered out
ata1.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
ata1.00: ACPI cmd c6/00:10:00:00:00:a0 (SET MULTIPLE MODE) succeeded
ata1.00: configured for UDMA/100
ata2.00: configured for UDMA/33
usb 1-7: reset high speed USB device number 25 using ehci_hcd
firewire_core: rediscovered device fw0
usb 1-2: reset high speed USB device number 2 using ehci_hcd
rt73usb 1-2:1.0: no reset_resume for driver rt73usb?
wlan0: deauthenticating from 00:40:10:10:00:03 by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
usb 3-1: reset low speed USB device number 3 using uhci_hcd
usb 1-7.1: reset low speed USB device number 26 using ehci_hcd
PM: restore of devices complete after 1861.732 msecs
usb 1-2: reset high speed USB device number 2 using ehci_hcd
ieee80211 phy23: Selected rate control algorithm 'minstrel_ht'
Registered led device: rt73usb-phy23::radio
Registered led device: rt73usb-phy23::assoc
Registered led device: rt73usb-phy23::quality
PM: Image restored successfully.
Restarting tasks ... done.
PM: Basic memory bitmaps freed
video LNXVIDEO:00: Restoring backlight state
usbcore: deregistering interface driver rt73usb
usb 1-2: reset high speed USB device number 2 using ehci_hcd
ieee80211 phy24: Selected rate control algorithm 'minstrel_ht'
Registered led device: rt73usb-phy24::radio
Registered led device: rt73usb-phy24::assoc
Registered led device: rt73usb-phy24::quality
usbcore: registered new interface driver rt73usb
wlan0: authenticate with 00:40:10:10:00:03 (try 1)
wlan0: authenticated
wlan0: associate with 00:40:10:10:00:03 (try 1)
wlan0: RX AssocResp from 00:40:10:10:00:03 (capab=0x411 status=0 aid=1)
wlan0: associated
usb 1-7: USB disconnect, device number 25
usb 1-7.1: USB disconnect, device number 26
usb 1-7: new high speed USB device number 27 using ehci_hcd
hub 1-7:1.0: USB hub found
hub 1-7:1.0: 4 ports detected
usb 1-7.1: new low speed USB device number 28 using ehci_hcd
input: KEYBOARD USB KB as /devices/pci0000:00/0000:00:1d.7/usb1/1-7/1-7.1/1-7.1:1.0/input/input33
generic-usb 0003:05D5:6782.0019: input,hidraw0: USB HID v1.10 Keyboard [KEYBOARD USB KB] on usb-0000:00:1d.7-7.1/input0
input: KEYBOARD USB KB as /devices/pci0000:00/0000:00:1d.7/usb1/1-7/1-7.1/1-7.1:1.1/input/input34
generic-usb 0003:05D5:6782.001A: input,hidraw1: USB HID v1.10 Mouse [KEYBOARD USB KB] on usb-0000:00:1d.7-7.1/input1
PM: Marking nosave pages: 000000000009f000 - 0000000000100000
PM: Basic memory bitmaps created
PM: Syncing filesystems ... done.
Freezing user space processes ... (elapsed 0.01 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
PM: Preallocating image memory... done (allocated 302355 pages)
PM: Allocated 1209420 kbytes in 0.63 seconds (1919.71 MB/s)
Suspending console(s) (use no_console_suspend to debug)
sd 0:0:0:0: [sda] Synchronizing SCSI cache
ata_piix 0000:00:1f.2: PCI INT B disabled
snd_hda_intel 0000:00:1b.0: PCI INT A disabled
PM: freeze of devices complete after 332.169 msecs
PM: late freeze of devices complete after 0.725 msecs
ACPI: Preparing to enter system sleep state S4
PM: Saving platform NVS memory
Disabling non-boot CPUs ...
CPU 1 is now offline
PM: Creating hibernation image:
PM: Need to copy 205089 pages
PM: Normal pages needed: 80633 + 1024, available pages: 192483
PM: Restoring platform NVS memory
Enabling non-boot CPUs ...
Booting Node 0 Processor 1 APIC 0x1
smpboot cpu 1: start_ip = 9b000
Initializing CPU#1
Calibrating delay loop (skipped) already calibrated this CPU
Disabled fast string operations
Switched to NOHz mode on CPU #1
CPU1 is up
ACPI: Waking up from system sleep state S4
snd_hda_intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100006, writing 0x100002)
ata_piix 0000:00:1f.2: restoring config space at offset 0x1 (was 0x2b80001, writing 0x2b80005)
firewire_ohci 0000:03:06.0: restoring config space at offset 0x1 (was 0x2100015, writing 0x2180017)
PM: early restore of devices complete after 0.997 msecs
i915 0000:00:02.0: setting latency timer to 64
snd_hda_intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
snd_hda_intel 0000:00:1b.0: setting latency timer to 64
snd_hda_intel 0000:00:1b.0: irq 42 for MSI/MSI-X
uhci_hcd 0000:00:1d.0: setting latency timer to 64
usb usb2: root hub lost power or was reset
uhci_hcd 0000:00:1d.1: setting latency timer to 64
usb usb3: root hub lost power or was reset
uhci_hcd 0000:00:1d.2: setting latency timer to 64
usb usb4: root hub lost power or was reset
uhci_hcd 0000:00:1d.3: setting latency timer to 64
usb usb5: root hub lost power or was reset
ehci_hcd 0000:00:1d.7: setting latency timer to 64
usb usb1: root hub lost power or was reset
pci 0000:00:1e.0: setting latency timer to 64
ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ata_piix 0000:00:1f.2: setting latency timer to 64
ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
sd 0:0:0:0: [sda] Starting disk
firewire_core: skipped bus generations, destroying all nodes
ata2.00: ACPI cmd ef/03:42:00:00:00:a0 (SET FEATURES) filtered out
ata2.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
ata1.00: ACPI cmd ef/03:45:00:00:00:a0 (SET FEATURES) filtered out
ata1.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
ata1.00: ACPI cmd c6/00:10:00:00:00:a0 (SET MULTIPLE MODE) succeeded
ata1.00: configured for UDMA/100
ata2.00: configured for UDMA/33
firewire_core: rediscovered device fw0
usb 3-1: reset low speed USB device number 3 using uhci_hcd
usb 1-2: reset high speed USB device number 2 using ehci_hcd
rt73usb 1-2:1.0: no reset_resume for driver rt73usb?
wlan0: deauthenticating from 00:40:10:10:00:03 by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
usb 1-7: reset high speed USB device number 27 using ehci_hcd
usb 1-7.1: reset low speed USB device number 28 using ehci_hcd
PM: restore of devices complete after 2066.890 msecs
usb 1-2: reset high speed USB device number 2 using ehci_hcd
ieee80211 phy25: Selected rate control algorithm 'minstrel_ht'
Registered led device: rt73usb-phy25::radio
Registered led device: rt73usb-phy25::assoc
Registered led device: rt73usb-phy25::quality
PM: Image restored successfully.
Restarting tasks ... done.
PM: Basic memory bitmaps freed
video LNXVIDEO:00: Restoring backlight state
usbcore: deregistering interface driver rt73usb
usb 1-2: reset high speed USB device number 2 using ehci_hcd
ieee80211 phy26: Selected rate control algorithm 'minstrel_ht'
Registered led device: rt73usb-phy26::radio
Registered led device: rt73usb-phy26::assoc
Registered led device: rt73usb-phy26::quality
usbcore: registered new interface driver rt73usb
wlan0: authenticate with 00:40:10:10:00:03 (try 1)
wlan0: authenticated
wlan0: associate with 00:40:10:10:00:03 (try 1)
wlan0: RX AssocResp from 00:40:10:10:00:03 (capab=0x411 status=0 aid=1)
wlan0: associated
generic-usb 0003:05D5:6782.0019: can't reset device, 0000:00:1d.7-7.1/input0, status -32
PM: Syncing filesystems ... done.
PM: Preparing system for mem sleep
Freezing user space processes ... (elapsed 0.01 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
PM: Entering mem sleep
Suspending console(s) (use no_console_suspend to debug)
sd 0:0:0:0: [sda] Synchronizing SCSI cache
sd 0:0:0:0: [sda] Stopping disk
snd_hda_intel 0000:00:1b.0: PCI INT A disabled
ata_piix 0000:00:1f.2: PCI INT B disabled
PM: suspend of devices complete after 1019.605 msecs
PM: late suspend of devices complete after 11.219 msecs
ACPI: Preparing to enter system sleep state S3
PM: Saving platform NVS memory
Disabling non-boot CPUs ...
CPU 1 is now offline
ACPI: Low-level resume complete
PM: Restoring platform NVS memory
Enabling non-boot CPUs ...
Booting Node 0 Processor 1 APIC 0x1
smpboot cpu 1: start_ip = 9b000
Initializing CPU#1
Calibrating delay loop (skipped) already calibrated this CPU
Disabled fast string operations
Switched to NOHz mode on CPU #1
CPU1 is up
ACPI: Waking up from system sleep state S3
pci 0000:00:02.1: restoring config space at offset 0x4 (was 0x0, writing 0xffd80000)
pci 0000:00:02.1: restoring config space at offset 0x1 (was 0x900000, writing 0x900007)
snd_hda_intel 0000:00:1b.0: restoring config space at offset 0x3 (was 0x0, writing 0x8)
snd_hda_intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100006, writing 0x100002)
pcieport 0000:00:1c.0: restoring config space at offset 0xf (was 0x20100, writing 0x2010a)
pcieport 0000:00:1c.0: restoring config space at offset 0x9 (was 0x1fff1, writing 0x80618051)
pcieport 0000:00:1c.0: restoring config space at offset 0x8 (was 0xfff0, writing 0x80408030)
pcieport 0000:00:1c.0: restoring config space at offset 0x7 (was 0xf0, writing 0x1010)
pcieport 0000:00:1c.0: restoring config space at offset 0x3 (was 0x810000, writing 0x810008)
pcieport 0000:00:1c.0: restoring config space at offset 0x1 (was 0x100104, writing 0x100507)
pcieport 0000:00:1c.1: restoring config space at offset 0xf (was 0x20200, writing 0x2020b)
pcieport 0000:00:1c.1: restoring config space at offset 0x9 (was 0x1fff1, writing 0x80218011)
pcieport 0000:00:1c.1: restoring config space at offset 0x3 (was 0x810000, writing 0x810008)
pcieport 0000:00:1c.1: restoring config space at offset 0x1 (was 0x100107, writing 0x100507)
pci 0000:00:1e.0: restoring config space at offset 0xf (was 0x20000, writing 0x200ff)
pci 0000:00:1e.0: restoring config space at offset 0x8 (was 0xffb0ff30, writing 0x80008000)
8139too 0000:03:04.0: restoring config space at offset 0x5 (was 0x0, writing 0x80002800)
8139too 0000:03:04.0: restoring config space at offset 0x4 (was 0x1, writing 0xd801)
8139too 0000:03:04.0: restoring config space at offset 0x3 (was 0x0, writing 0x4000)
8139too 0000:03:04.0: restoring config space at offset 0x1 (was 0x2900000, writing 0x2900007)
firewire_ohci 0000:03:06.0: restoring config space at offset 0xf (was 0x100, writing 0x105)
firewire_ohci 0000:03:06.0: restoring config space at offset 0x5 (was 0x0, writing 0x80002000)
firewire_ohci 0000:03:06.0: restoring config space at offset 0x4 (was 0x0, writing 0x80000000)
firewire_ohci 0000:03:06.0: restoring config space at offset 0x3 (was 0x800000, writing 0x804008)
firewire_ohci 0000:03:06.0: restoring config space at offset 0x1 (was 0x2100080, writing 0x2180017)
pci 0000:03:06.2: restoring config space at offset 0xf (was 0x1ff, writing 0x105)
pci 0000:03:06.2: restoring config space at offset 0x4 (was 0x0, writing 0x80002900)
pci 0000:03:06.2: restoring config space at offset 0x3 (was 0x0, writing 0x4008)
pci 0000:03:06.2: restoring config space at offset 0x1 (was 0x4100000, writing 0x4100002)
pci 0000:03:06.3: restoring config space at offset 0xf (was 0x1ff, writing 0x105)
pci 0000:03:06.3: restoring config space at offset 0x4 (was 0x0, writing 0x80001000)
pci 0000:03:06.3: restoring config space at offset 0x3 (was 0x0, writing 0x4008)
pci 0000:03:06.3: restoring config space at offset 0x1 (was 0x4100000, writing 0x84100002)
PM: early resume of devices complete after 1.110 msecs
i915 0000:00:02.0: setting latency timer to 64
snd_hda_intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
snd_hda_intel 0000:00:1b.0: setting latency timer to 64
snd_hda_intel 0000:00:1b.0: irq 42 for MSI/MSI-X
uhci_hcd 0000:00:1d.0: setting latency timer to 64
usb usb2: root hub lost power or was reset
uhci_hcd 0000:00:1d.1: setting latency timer to 64
usb usb3: root hub lost power or was reset
uhci_hcd 0000:00:1d.2: setting latency timer to 64
usb usb4: root hub lost power or was reset
uhci_hcd 0000:00:1d.3: setting latency timer to 64
usb usb5: root hub lost power or was reset
ehci_hcd 0000:00:1d.7: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ata_piix 0000:00:1f.2: setting latency timer to 64
sd 0:0:0:0: [sda] Starting disk
firewire_core: skipped bus generations, destroying all nodes
usb 1-2: reset high speed USB device number 2 using ehci_hcd
rt73usb 1-2:1.0: no reset_resume for driver rt73usb?
wlan0: deauthenticating from 00:40:10:10:00:03 by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
firewire_core: rediscovered device fw0
usb 3-1: reset low speed USB device number 3 using uhci_hcd
ata2.00: ACPI cmd ef/03:42:00:00:00:a0 (SET FEATURES) filtered out
ata2.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
ata2.00: configured for UDMA/33
ata1.00: ACPI cmd ef/03:45:00:00:00:a0 (SET FEATURES) filtered out
ata1.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
ata1.00: ACPI cmd c6/00:10:00:00:00:a0 (SET MULTIPLE MODE) succeeded
ata1.00: configured for UDMA/100
PM: resume of devices complete after 2682.332 msecs
usb 1-2: reset high speed USB device number 2 using ehci_hcd
ieee80211 phy27: Selected rate control algorithm 'minstrel_ht'
Registered led device: rt73usb-phy27::radio
Registered led device: rt73usb-phy27::assoc
Registered led device: rt73usb-phy27::quality
PM: Finishing wakeup.
Restarting tasks ... done.
video LNXVIDEO:00: Restoring backlight state
usbcore: deregistering interface driver rt73usb
usb 1-2: reset high speed USB device number 2 using ehci_hcd
ieee80211 phy28: Selected rate control algorithm 'minstrel_ht'
Registered led device: rt73usb-phy28::radio
Registered led device: rt73usb-phy28::assoc
Registered led device: rt73usb-phy28::quality
usbcore: registered new interface driver rt73usb
wlan0: authenticate with 00:40:10:10:00:03 (try 1)
wlan0: authenticated
wlan0: associate with 00:40:10:10:00:03 (try 1)
wlan0: RX AssocResp from 00:40:10:10:00:03 (capab=0x411 status=0 aid=1)
wlan0: associated
PM: Marking nosave pages: 000000000009f000 - 0000000000100000
PM: Basic memory bitmaps created
PM: Syncing filesystems ... done.
Freezing user space processes ... (elapsed 0.01 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
PM: Preallocating image memory... done (allocated 302355 pages)
PM: Allocated 1209420 kbytes in 0.27 seconds (4479.33 MB/s)
Suspending console(s) (use no_console_suspend to debug)
sd 0:0:0:0: [sda] Synchronizing SCSI cache
snd_hda_intel 0000:00:1b.0: PCI INT A disabled
ata_piix 0000:00:1f.2: PCI INT B disabled
PM: freeze of devices complete after 18.629 msecs
PM: late freeze of devices complete after 0.733 msecs
ACPI: Preparing to enter system sleep state S4
PM: Saving platform NVS memory
Disabling non-boot CPUs ...
CPU 1 is now offline
PM: Creating hibernation image:
PM: Need to copy 203781 pages
PM: Normal pages needed: 79489 + 1024, available pages: 193955
PM: Restoring platform NVS memory
Enabling non-boot CPUs ...
Booting Node 0 Processor 1 APIC 0x1
smpboot cpu 1: start_ip = 9b000
Initializing CPU#1
Calibrating delay loop (skipped) already calibrated this CPU
Disabled fast string operations
Switched to NOHz mode on CPU #1
CPU1 is up
ACPI: Waking up from system sleep state S4
snd_hda_intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100006, writing 0x100002)
ata_piix 0000:00:1f.2: restoring config space at offset 0x1 (was 0x2b80001, writing 0x2b80005)
firewire_ohci 0000:03:06.0: restoring config space at offset 0x1 (was 0x2100015, writing 0x2180017)
pci 0000:03:06.3: restoring config space at offset 0x1 (was 0x84100002, writing 0x4100002)
PM: early restore of devices complete after 0.999 msecs
i915 0000:00:02.0: setting latency timer to 64
snd_hda_intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
snd_hda_intel 0000:00:1b.0: setting latency timer to 64
snd_hda_intel 0000:00:1b.0: irq 42 for MSI/MSI-X
uhci_hcd 0000:00:1d.0: setting latency timer to 64
usb usb2: root hub lost power or was reset
uhci_hcd 0000:00:1d.1: setting latency timer to 64
usb usb3: root hub lost power or was reset
uhci_hcd 0000:00:1d.2: setting latency timer to 64
usb usb4: root hub lost power or was reset
uhci_hcd 0000:00:1d.3: setting latency timer to 64
usb usb5: root hub lost power or was reset
ehci_hcd 0000:00:1d.7: setting latency timer to 64
usb usb1: root hub lost power or was reset
pci 0000:00:1e.0: setting latency timer to 64
ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ata_piix 0000:00:1f.2: setting latency timer to 64
sd 0:0:0:0: [sda] Starting disk
ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
firewire_core: skipped bus generations, destroying all nodes
ata1.00: ACPI cmd ef/03:45:00:00:00:a0 (SET FEATURES) filtered out
ata1.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
ata1.00: ACPI cmd c6/00:10:00:00:00:a0 (SET MULTIPLE MODE) succeeded
ata2.00: ACPI cmd ef/03:42:00:00:00:a0 (SET FEATURES) filtered out
ata2.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
ata1.00: configured for UDMA/100
ata2.00: configured for UDMA/33
usb 1-2: reset high speed USB device number 2 using ehci_hcd
firewire_core: rediscovered device fw0
rt73usb 1-2:1.0: no reset_resume for driver rt73usb?
wlan0: deauthenticating from 00:40:10:10:00:03 by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
PM: restore of devices complete after 690.835 msecs
usb 1-2: reset high speed USB device number 2 using ehci_hcd
ieee80211 phy29: Selected rate control algorithm 'minstrel_ht'
Registered led device: rt73usb-phy29::radio
Registered led device: rt73usb-phy29::assoc
Registered led device: rt73usb-phy29::quality
PM: Image restored successfully.
Restarting tasks ... 
usb 3-1: USB disconnect, device number 3
usb 1-7: USB disconnect, device number 27
usb 1-7.1: USB disconnect, device number 28
done.
PM: Basic memory bitmaps freed
video LNXVIDEO:00: Restoring backlight state
usbcore: deregistering interface driver rt73usb
usb 1-2: reset high speed USB device number 2 using ehci_hcd
ieee80211 phy30: Selected rate control algorithm 'minstrel_ht'
Registered led device: rt73usb-phy30::radio
Registered led device: rt73usb-phy30::assoc
Registered led device: rt73usb-phy30::quality
usbcore: registered new interface driver rt73usb
wlan0: authenticate with 00:40:10:10:00:03 (try 1)
wlan0: authenticated
wlan0: associate with 00:40:10:10:00:03 (try 1)
wlan0: RX AssocResp from 00:40:10:10:00:03 (capab=0x411 status=0 aid=1)
wlan0: associated
oosplash.bin[2255]: segfault at 4d0 ip b7776a1b sp bf898a60 error 4 in libX11.so.6.3.0[b7743000+132000]

--------------010201040008010006070706
Content-Type: text/plain;
 name="lspci.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="lspci.txt"

00:00.0 Host bridge [0600]: Intel Corporation Mobile 945GM/PM/GMS, 943/940GML and 945GT Express Memory Controller Hub [8086:27a0] (rev 03)
	Subsystem: TWINHEAD INTERNATIONAL Corp Device [14ff:a003]
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: <access denied>
	Kernel driver in use: agpgart-intel

00:02.0 VGA compatible controller [0300]: Intel Corporation Mobile 945GM/GMS, 943/940GML Express Integrated Graphics Controller [8086:27a2] (rev 03) (prog-if 00 [VGA controller])
	Subsystem: TWINHEAD INTERNATIONAL Corp Device [14ff:a003]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at ffe80000 (32-bit, non-prefetchable) [size=512K]
	Region 1: I/O ports at ec00 [size=8]
	Region 2: Memory at d0000000 (32-bit, prefetchable) [size=256M]
	Region 3: Memory at ffe40000 (32-bit, non-prefetchable) [size=256K]
	Expansion ROM at <unassigned> [disabled]
	Capabilities: <access denied>
	Kernel driver in use: i915

00:02.1 Display controller [0380]: Intel Corporation Mobile 945GM/GMS/GME, 943/940GML Express Integrated Graphics Controller [8086:27a6] (rev 03)
	Subsystem: TWINHEAD INTERNATIONAL Corp Device [14ff:a003]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Region 0: Memory at ffd80000 (32-bit, non-prefetchable) [size=512K]
	Capabilities: <access denied>

00:1b.0 Audio device [0403]: Intel Corporation N10/ICH 7 Family High Definition Audio Controller [8086:27d8] (rev 02)
	Subsystem: TWINHEAD INTERNATIONAL Corp Device [14ff:a003]
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 42
	Region 0: Memory at ffe34000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: <access denied>
	Kernel driver in use: snd_hda_intel
	Kernel modules: snd-hda-intel

00:1c.0 PCI bridge [0604]: Intel Corporation N10/ICH 7 Family PCI Express Port 1 [8086:27d0] (rev 02) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	I/O behind bridge: 00001000-00001fff
	Memory behind bridge: 80300000-804fffff
	Prefetchable memory behind bridge: 0000000080500000-00000000806fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>
	Kernel driver in use: pcieport

00:1c.1 PCI bridge [0604]: Intel Corporation N10/ICH 7 Family PCI Express Port 2 [8086:27d2] (rev 02) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	I/O behind bridge: 0000a000-0000afff
	Memory behind bridge: fef00000-ff2fffff
	Prefetchable memory behind bridge: 0000000080100000-00000000802fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>
	Kernel driver in use: pcieport

00:1d.0 USB controller [0c03]: Intel Corporation N10/ICH 7 Family USB UHCI Controller #1 [8086:27c8] (rev 02) (prog-if 00 [UHCI])
	Subsystem: TWINHEAD INTERNATIONAL Corp Device [14ff:a003]
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 23
	Region 4: I/O ports at e880 [size=32]
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:1d.1 USB controller [0c03]: Intel Corporation N10/ICH 7 Family USB UHCI Controller #2 [8086:27c9] (rev 02) (prog-if 00 [UHCI])
	Subsystem: TWINHEAD INTERNATIONAL Corp Device [14ff:a003]
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 19
	Region 4: I/O ports at e800 [size=32]
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:1d.2 USB controller [0c03]: Intel Corporation N10/ICH 7 Family USB UHCI Controller #3 [8086:27ca] (rev 02) (prog-if 00 [UHCI])
	Subsystem: TWINHEAD INTERNATIONAL Corp Device [14ff:a003]
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin C routed to IRQ 18
	Region 4: I/O ports at e480 [size=32]
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:1d.3 USB controller [0c03]: Intel Corporation N10/ICH 7 Family USB UHCI Controller #4 [8086:27cb] (rev 02) (prog-if 00 [UHCI])
	Subsystem: TWINHEAD INTERNATIONAL Corp Device [14ff:a003]
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin D routed to IRQ 16
	Region 4: I/O ports at e400 [size=32]
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:1d.7 USB controller [0c03]: Intel Corporation N10/ICH 7 Family USB2 EHCI Controller [8086:27cc] (rev 02) (prog-if 20 [EHCI])
	Subsystem: TWINHEAD INTERNATIONAL Corp Device [14ff:a003]
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 23
	Region 0: Memory at ffe3b800 (32-bit, non-prefetchable) [size=1K]
	Capabilities: <access denied>
	Kernel driver in use: ehci_hcd
	Kernel modules: ehci-hcd

00:1e.0 PCI bridge [0604]: Intel Corporation 82801 Mobile PCI Bridge [8086:2448] (rev e2) (prog-if 01 [Subtractive decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Bus: primary=00, secondary=03, subordinate=04, sec-latency=32
	I/O behind bridge: 0000c000-0000dfff
	Memory behind bridge: 80000000-800fffff
	Prefetchable memory behind bridge: 00000000bdf00000-00000000bfefffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR+
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>

00:1f.0 ISA bridge [0601]: Intel Corporation 82801GBM (ICH7-M) LPC Interface Bridge [8086:27b9] (rev 02)
	Subsystem: TWINHEAD INTERNATIONAL Corp Device [14ff:a003]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: <access denied>
	Kernel modules: iTCO_wdt, intel-rng

00:1f.2 IDE interface [0101]: Intel Corporation 82801GBM/GHM (ICH7 Family) SATA IDE Controller [8086:27c4] (rev 02) (prog-if 80 [Master])
	Subsystem: TWINHEAD INTERNATIONAL Corp Device [14ff:a003]
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 19
	Region 0: I/O ports at 01f0 [size=8]
	Region 1: I/O ports at 03f4 [size=1]
	Region 2: I/O ports at 0170 [size=8]
	Region 3: I/O ports at 0374 [size=1]
	Region 4: I/O ports at ffa0 [size=16]
	Capabilities: <access denied>
	Kernel driver in use: ata_piix
	Kernel modules: ata_piix

00:1f.3 SMBus [0c05]: Intel Corporation N10/ICH 7 Family SMBus Controller [8086:27da] (rev 02)
	Subsystem: TWINHEAD INTERNATIONAL Corp Device [14ff:a003]
	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin B routed to IRQ 19
	Region 4: I/O ports at 0400 [size=32]
	Kernel driver in use: i801_smbus
	Kernel modules: i2c-i801

03:04.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd. RTL-8139/8139C/8139C+ [10ec:8139] (rev 10)
	Subsystem: TWINHEAD INTERNATIONAL Corp Device [14ff:a003]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64 (8000ns min, 16000ns max)
	Interrupt: pin A routed to IRQ 16
	Region 0: I/O ports at d800 [size=256]
	Region 1: Memory at 80002800 (32-bit, non-prefetchable) [size=256]
	Capabilities: <access denied>
	Kernel driver in use: 8139too
	Kernel modules: 8139too, 8139cp

03:06.0 FireWire (IEEE 1394) [0c00]: O2 Micro, Inc. Firewire (IEEE 1394) [1217:00f7] (rev 02) (prog-if 10 [OHCI])
	Subsystem: TWINHEAD INTERNATIONAL Corp Device [14ff:a003]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx+
	Latency: 64, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 19
	Region 0: Memory at 80000000 (32-bit, non-prefetchable) [size=4K]
	Region 1: Memory at 80002000 (32-bit, non-prefetchable) [size=2K]
	Capabilities: <access denied>
	Kernel driver in use: firewire_ohci
	Kernel modules: firewire-ohci

03:06.2 SD Host controller [0805]: O2 Micro, Inc. Integrated MMC/SD Controller [1217:7120] (rev 01)
	Subsystem: TWINHEAD INTERNATIONAL Corp Device [14ff:a003]
	Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 5
	Region 0: Memory at 80002900 (32-bit, non-prefetchable) [size=256]
	Capabilities: <access denied>
	Kernel modules: sdhci-pci

03:06.3 Mass storage controller [0180]: O2 Micro, Inc. Integrated MS/xD Controller [1217:7130] (rev 01)
	Subsystem: TWINHEAD INTERNATIONAL Corp Device [14ff:a003]
	Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort- <TAbort- <MAbort- >SERR- <PERR+ INTx-
	Interrupt: pin A routed to IRQ 5
	Region 0: Memory at 80001000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: <access denied>


--------------010201040008010006070706--

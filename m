Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751360Ab2EZGLx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 02:11:53 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:63694 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151Ab2EZGLu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 02:11:50 -0400
MIME-Version: 1.0
In-Reply-To: <CA+fU7qfPznJpRABC4Z=xmRZW6p5Mw3dFLBySk9HuPnaCYMMnEg@mail.gmail.com>
References: <CA+fU7qen=cwc1vMY1bv21_0GuNKXPQZXsQLVszYG1WG_r1XUGA@mail.gmail.com>
 <20120524123116.GA4048@alberich.amd.com> <CA+fU7qfPznJpRABC4Z=xmRZW6p5Mw3dFLBySk9HuPnaCYMMnEg@mail.gmail.com>
From: Comrade DOS <suloevdmitry@gmail.com>
Date: Sat, 26 May 2012 13:11:08 +0700
Message-ID: <CA+fU7qcMWmmYS_pRShtNqttYeh27FY7CryLPnDbV-ofFuPb3gw@mail.gmail.com>
Subject: PROBLEM: Performance drop
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---------- Forwarded message ----------
From: Comrade DOS <suloevdmitry@gmail.com>
Date: 2012/5/24
Subject: Re: PROBLEM: Performance drop
To: Andreas Herrmann <herrmann.der.user@googlemail.com>


> What was the kernel release used before 3.4.0 was install on your
> Laptop?
I rollback to linux 3.3.5. It's work fine on this laptop.

> Please provide dmesg with apic=debug kernel option when kernel 3.4 is
> booted?
Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 3.4.0 (root@dos) (gcc version 4.6.3 (Gentoo 4.6.3 p1.0,
pie-0.5.1) ) #2 SMP PREEMPT Thu May 24 22:49:31 OMST 2012
Command line: root=/dev/sda3 acpi=debug
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000b7fb0000 (usable)
 BIOS-e820: 00000000b7fb0000 - 00000000b7fc8000 (reserved)
 BIOS-e820: 00000000b7fc8000 - 00000000b7fe7fb8 (ACPI NVS)
 BIOS-e820: 00000000b7fe7fb8 - 00000000c0000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec02000 (reserved)
 BIOS-e820: 00000000ffbc0000 - 00000000ffcc0000 (reserved)
 BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000140000000 (usable)
Malformed early option 'acpi'
NX (Execute Disable) protection: active
DMI 2.4 present.
DMI: Hewlett-Packard HP Compaq 6715b (GB833EA#ACB)/30C2, BIOS 68YTT
Ver. F.0E 11/25/2008
e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
No AGP bridge found
last_pfn = 0x140000 max_arch_pfn = 0x400000000
MTRR default type: uncachable
MTRR fixed ranges enabled:
 00000-9FFFF write-back
 A0000-BFFFF uncachable
 C0000-C0FFF write-protect
 C1000-C3FFF write-back
 C4000-C4FFF write-protect
 C5000-C7FFF write-back
 C8000-C8FFF write-protect
 C9000-CBFFF write-back
 CC000-CCFFF write-protect
 CD000-CFFFF write-back
 D0000-EFFFF uncachable
 F0000-FFFFF write-protect
MTRR variable ranges enabled:
 0 base 0000000000 mask FF80000000 write-back
 1 base 0080000000 mask FFE0000000 write-back
 2 base 00A0000000 mask FFF0000000 write-back
 3 base 00B0000000 mask FFF8000000 write-back
 4 disabled
 5 disabled
 6 disabled
 7 disabled
TOM2: 0000000140000000 aka 5120M
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
e820 update range: 00000000b8000000 - 0000000100000000 (usable) ==> (reserved)
last_pfn = 0xb7fb0 max_arch_pfn = 0x400000000
initial memory mapped : 0 - 20000000
Base memory trampoline at [ffff88000009a000] 9a000 size 20480
init_memory_mapping: 0000000000000000-00000000b7fb0000
 0000000000 - 00b7e00000 page 2M
 00b7e00000 - 00b7fb0000 page 4k
kernel direct mapping tables up to b7fb0000 @ 1fffb000-20000000
init_memory_mapping: 0000000100000000-0000000140000000
 0100000000 - 0140000000 page 2M
kernel direct mapping tables up to 140000000 @ b7faa000-b7fb0000
ACPI: RSDP 00000000000fe0b0 00024 (v02 HP    )
ACPI: XSDT 00000000b7fc81bc 00064 (v01 HPQOEM SLIC-MPC 00000001 HP   00000001)
ACPI: FACP 00000000b7fc8084 000F4 (v04 HP     0944     00000003 HP   00000001)
ACPI Error: 32/64X address mismatch in Pm2ControlBlock:
0x00008800/0x0000000000008100, using 32 (20120320/tbfadt-443)
ACPI: DSDT 00000000b7fc84a4 11A38 (v01 HP        SB400 00010000 MSFT 03000001)
ACPI: FACS 00000000b7fe7d80 00040
ACPI: SLIC 00000000b7fc8220 00176 (v01 HPQOEM SLIC-MPC 00000001 HP   00000001)
ACPI: EPTH 00000000b7fc8398 00038 (v01 HP     0944     00000001 HP   00000001)
ACPI: APIC 00000000b7fc83d0 00062 (v01 HP     0944     00000001 HP   00000001)
ACPI: MCFG 00000000b7fc8434 0003C (v01 HP     0944     00000001 HP   00000001)
ACPI: TCPA 00000000b7fc8470 00032 (v02 HP     0944     00000001 HP   00000001)
ACPI: SSDT 00000000b7fd9edc 00059 (v01 HP       HPQNLP 00000001 MSFT 03000001)
ACPI: SSDT 00000000b7fd9f35 00136 (v01 HP     PSSTBLID 00000001 HP   00000001)
ACPI: Local APIC address 0xfee00000
 [ffffea0000000000-ffffea0004ffffff] PMD ->
[ffff88013b800000-ffff88013f5fffff] on node 0
Zone PFN ranges:
 DMA      0x00000010 -> 0x00001000
 DMA32    0x00001000 -> 0x00100000
 Normal   0x00100000 -> 0x00140000
Movable zone start PFN for each node
Early memory PFN ranges
   0: 0x00000010 -> 0x0000009f
   0: 0x00000100 -> 0x000b7fb0
   0: 0x00100000 -> 0x00140000
On node 0 totalpages: 1015615
 DMA zone: 64 pages used for memmap
 DMA zone: 5 pages reserved
 DMA zone: 3914 pages, LIFO batch:0
 DMA32 zone: 16320 pages used for memmap
 DMA32 zone: 733168 pages, LIFO batch:31
 Normal zone: 4096 pages used for memmap
 Normal zone: 258048 pages, LIFO batch:31
SB600 revision 0x14
Ignoring ACPI timer override.
If you got timer trouble try acpi_use_timer_override
Detected use of extended apic ids on hypertransport bus
ACPI: PM-Timer IO Port: 0x8008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] disabled)
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 33, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: BIOS IRQ0 pin2 override ignored.
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
SMP: Allowing 2 CPUs, 1 hotplug CPUs
nr_irqs_gsi: 40
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
PM: Registered nosave memory: 00000000b7fb0000 - 00000000b7fc8000
PM: Registered nosave memory: 00000000b7fc8000 - 00000000b7fe7000
PM: Registered nosave memory: 00000000b7fe7000 - 00000000b7fe8000
PM: Registered nosave memory: 00000000b7fe8000 - 00000000c0000000
PM: Registered nosave memory: 00000000c0000000 - 00000000e0000000
PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
PM: Registered nosave memory: 00000000f0000000 - 00000000fec00000
PM: Registered nosave memory: 00000000fec00000 - 00000000fec02000
PM: Registered nosave memory: 00000000fec02000 - 00000000ffbc0000
PM: Registered nosave memory: 00000000ffbc0000 - 00000000ffcc0000
PM: Registered nosave memory: 00000000ffcc0000 - 00000000fff00000
PM: Registered nosave memory: 00000000fff00000 - 0000000100000000
Allocating PCI resources starting at c0000000 (gap: c0000000:20000000)
setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:2 nr_node_ids:1
PERCPU: Embedded 25 pages/cpu @ffff88013fc00000 s71744 r8192 d22464 u1048576
pcpu-alloc: s71744 r8192 d22464 u1048576 alloc=1*2097152
pcpu-alloc: [0] 0 1
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 995130
Kernel command line: root=/dev/sda3 acpi=debug
PID hash table entries: 4096 (order: 3, 32768 bytes)
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Checking aperture...
No AGP bridge found
Node 0: aperture @ ac000000 size 32 MB
Aperture pointing to e820 RAM. Ignoring.
Your BIOS doesn't leave a aperture memory hole
Please enable the IOMMU option in the BIOS setup
This costs you 64 MB of RAM
Mapping aperture over 65536 KB of RAM @ ac000000
PM: Registered nosave memory: 00000000ac000000 - 00000000b0000000
Memory: 3853536k/5242880k available (4382k kernel code, 1180420k
absent, 208924k reserved, 1971k data, 432k init)
SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
Preemptible hierarchical RCU implementation.
NR_IRQS:4352 nr_irqs:512 16
Extended CMOS year: 2000
Console: colour VGA+ 80x25
console [tty0] enabled
Fast TSC calibration failed
TSC: Unable to calibrate against PIT
TSC: using PMTIMER reference calibration
Detected 2194.526 MHz processor.
Marking TSC unstable due to TSCs unsynchronized
Calibrating delay loop (skipped), value calculated using timer
frequency.. 4389.05 BogoMIPS (lpj=2194526)
pid_max: default: 32768 minimum: 301
Security Framework initialized
Mount-cache hash table entries: 256
Initializing cgroup subsys cpuacct
Initializing cgroup subsys freezer
tseg: 0000000000
mce: CPU supports 5 MCE banks
LVT offset 0 assigned for vector 0xf9
using AMD E400 aware idle routine
SMP alternatives: switching to UP code
ACPI: Core revision 20120320
..TIMER: vector=0x30 apic1=0 pin1=0 apic2=-1 pin2=-1
CPU0: Mobile AMD Sempron(tm) Processor 3800+ stepping 02
Performance Events: AMD PMU driver.
... version:                0
... bit width:              48
... generic registers:      4
... value mask:             0000ffffffffffff
... max period:             00007fffffffffff
... fixed-purpose events:   0
... event mask:             000000000000000f
MCE: In-kernel MCE decoding enabled.
Brought up 1 CPUs
Total of 1 processors activated (4389.05 BogoMIPS).
devtmpfs: initialized
PM: Registering ACPI NVS region [mem 0xb7fc8000-0xb7fe7fb7] (131000 bytes)
NET: Registered protocol family 16
node 0 link 0: io port [1000, fffff]
TOM: 00000000c0000000 aka 3072M
node 0 link 0: mmio [e0000000, efffffff]
node 0 link 0: mmio [f0000000, ffffffff]
node 0 link 0: mmio [c8000000, dfffffff]
node 0 link 0: mmio [c0000000, c7ffffff]
node 0 link 0: mmio [a0000, bffff]
node 0 link 0: mmio [c0000000, bfffffff]
TOM2: 0000000140000000 aka 5120M
bus: [00, ff] on node 0 link 0
bus: 00 index 0 [io  0x0000-0xffff]
bus: 00 index 1 [mem 0xc0000000-0xffffffff]
bus: 00 index 2 [mem 0x000a0000-0x000bffff]
bus: 00 index 3 [mem 0x140000000-0xfcffffffff]
ACPI: bus type pci registered
PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem
0xe0000000-0xefffffff] (base 0xe0000000)
PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: Added _OSI(Module Device)
ACPI: Added _OSI(Processor Device)
ACPI: Added _OSI(3.0 _SCP Extensions)
ACPI: Added _OSI(Processor Aggregator Device)
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: Power Resource [C171] (off)
ACPI: Power Resource [C231] (off)
ACPI: Power Resource [C24D] (on)
ACPI: Power Resource [C397] (off)
ACPI: Power Resource [C398] (off)
ACPI: Power Resource [C399] (off)
ACPI: Power Resource [C39A] (off)
ACPI: EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
PCI: Using host bridge windows from ACPI; if necessary, use
"pci=nocrs" and report a bug
ACPI: PCI Root Bridge [C08B] (domain 0000 [bus 00-ff])
pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
pci_root PNP0A03:00: host bridge window [mem 0xc0000000-0xfedfffff]
pci_root PNP0A03:00: host bridge window [mem 0xfee01000-0xffffffff]
pci_root PNP0A03:00: host bridge window [mem 0x000d0000-0x000dffff]
PCI host bridge to bus 0000:00
pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: root bus resource [mem 0xc0000000-0xfedfffff]
pci_bus 0000:00: root bus resource [mem 0xfee01000-0xffffffff]
pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000dffff]
pci 0000:00:00.0: [1002:7910] type 00 class 0x060000
pci 0000:00:01.0: [1002:7912] type 01 class 0x060400
pci 0000:00:04.0: [1002:7914] type 01 class 0x060400
pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
pci 0000:00:05.0: [1002:7915] type 01 class 0x060400
pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
pci 0000:00:06.0: [1002:7916] type 01 class 0x060400
pci 0000:00:06.0: PME# supported from D0 D3hot D3cold
pci 0000:00:12.0: [1002:4380] type 00 class 0x01018f
pci 0000:00:12.0: reg 10: [io  0x9000-0x9007]
pci 0000:00:12.0: reg 14: [io  0x9008-0x900b]
pci 0000:00:12.0: reg 18: [io  0x9010-0x9017]
pci 0000:00:12.0: reg 1c: [io  0x5018-0x501b]
pci 0000:00:12.0: reg 20: [io  0x5020-0x502f]
pci 0000:00:12.0: reg 24: [mem 0xd0609000-0xd06093ff]
pci 0000:00:12.0: set SATA to AHCI mode
pci 0000:00:13.0: [1002:4387] type 00 class 0x0c0310
pci 0000:00:13.0: reg 10: [mem 0xd0601000-0xd0601fff]
pci 0000:00:13.1: [1002:4388] type 00 class 0x0c0310
pci 0000:00:13.1: reg 10: [mem 0xd0602000-0xd0602fff]
pci 0000:00:13.2: [1002:4389] type 00 class 0x0c0310
pci 0000:00:13.2: reg 10: [mem 0xd0603000-0xd0603fff]
pci 0000:00:13.3: [1002:438a] type 00 class 0x0c0310
pci 0000:00:13.3: reg 10: [mem 0xd0604000-0xd0604fff]
pci 0000:00:13.4: [1002:438b] type 00 class 0x0c0310
pci 0000:00:13.4: reg 10: [mem 0xd0605000-0xd0605fff]
pci 0000:00:13.5: [1002:4386] type 00 class 0x0c0320
pci 0000:00:13.5: reg 10: [mem 0xd0606000-0xd06060ff]
pci 0000:00:13.5: supports D1 D2
pci 0000:00:13.5: PME# supported from D0 D1 D2 D3hot
pci 0000:00:14.0: [1002:4385] type 00 class 0x0c0500
pci 0000:00:14.0: reg 10: [io  0x8200-0x820f]
pci 0000:00:14.1: [1002:438c] type 00 class 0x010182
pci 0000:00:14.1: reg 10: [io  0x0000-0x0007]
pci 0000:00:14.1: reg 14: [io  0x0000-0x0003]
pci 0000:00:14.1: reg 18: [io  0x0000-0x0007]
pci 0000:00:14.1: reg 1c: [io  0x0000-0x0003]
pci 0000:00:14.1: reg 20: [io  0x5040-0x504f]
pci 0000:00:14.2: [1002:4383] type 00 class 0x040300
pci 0000:00:14.2: reg 10: [mem 0xd0608000-0xd060bfff 64bit]
pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
pci 0000:00:14.3: [1002:438d] type 00 class 0x060100
pci 0000:00:14.4: [1002:4384] type 01 class 0x060401
pci 0000:00:18.0: [1022:1100] type 00 class 0x060000
pci 0000:00:18.1: [1022:1101] type 00 class 0x060000
pci 0000:00:18.2: [1022:1102] type 00 class 0x060000
pci 0000:00:18.3: [1022:1103] type 00 class 0x060000
pci 0000:01:05.0: [1002:791f] type 00 class 0x030000
pci 0000:01:05.0: reg 10: [mem 0xc0000000-0xc7ffffff 64bit pref]
pci 0000:01:05.0: reg 18: [mem 0xd0400000-0xd040ffff 64bit]
pci 0000:01:05.0: reg 20: [io  0x4000-0x40ff]
pci 0000:01:05.0: reg 24: [mem 0xd0500000-0xd05fffff]
pci 0000:01:05.0: supports D1 D2
pci 0000:00:01.0: PCI bridge to [bus 01-01]
pci 0000:00:01.0:   bridge window [io  0x4000-0x4fff]
pci 0000:00:01.0:   bridge window [mem 0xd0400000-0xd05fffff]
pci 0000:00:01.0:   bridge window [mem 0xc0000000-0xc7ffffff 64bit pref]
pci 0000:10:00.0: [14e4:1693] type 00 class 0x020000
pci 0000:10:00.0: reg 10: [mem 0xd0000000-0xd000ffff 64bit]
pci 0000:10:00.0: PME# supported from D3hot D3cold
pci 0000:00:04.0: PCI bridge to [bus 10-10]
pci 0000:00:04.0:   bridge window [mem 0xd0000000-0xd00fffff]
pci 0000:00:05.0: PCI bridge to [bus 20-20]
pci 0000:00:05.0:   bridge window [io  0x2000-0x3fff]
pci 0000:00:05.0:   bridge window [mem 0xcc000000-0xcfffffff]
pci 0000:30:00.0: [14e4:4312] type 00 class 0x028000
pci 0000:30:00.0: reg 10: [mem 0xc8000000-0xc8003fff 64bit]
pci 0000:30:00.0: supports D1 D2
pci 0000:00:06.0: PCI bridge to [bus 30-30]
pci 0000:00:06.0:   bridge window [mem 0xc8000000-0xc80fffff]
pci 0000:02:04.0: [1180:0476] type 02 class 0x060700
pci 0000:02:04.0: reg 10: [mem 0xd0100000-0xd0100fff]
pci 0000:02:04.0: supports D1 D2
pci 0000:02:04.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:02:04.1: [1180:0832] type 00 class 0x0c0010
pci 0000:02:04.1: reg 10: [mem 0xd0101000-0xd01017ff]
pci 0000:02:04.1: supports D1 D2
pci 0000:02:04.1: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:14.4: PCI bridge to [bus 02-03] (subtractive decode)
pci 0000:00:14.4:   bridge window [mem 0xd0100000-0xd03fffff]
pci 0000:00:14.4:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff] (subtractive decode)
pci 0000:00:14.4:   bridge window [mem 0x000a0000-0x000bffff]
(subtractive decode)
pci 0000:00:14.4:   bridge window [mem 0xc0000000-0xfedfffff]
(subtractive decode)
pci 0000:00:14.4:   bridge window [mem 0xfee01000-0xffffffff]
(subtractive decode)
pci 0000:00:14.4:   bridge window [mem 0x000d0000-0x000dffff]
(subtractive decode)
pci_bus 0000:03: [bus 03-06] partially hidden behind transparent
bridge 0000:02 [bus 02-03]
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.C08B._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.C08B.C08C._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.C08B.C0FC._PRT]
 pci0000:00: Requesting ACPI _OSC control (0x1d)
 pci0000:00: ACPI _OSC request failed (AE_NOT_FOUND), returned control
mask: 0x1d
ACPI _OSC control for PCIe not granted, disabling ASPM
ACPI: PCI Interrupt Link [C145] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [C146] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [C147] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [C148] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [C149] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [C14A] (IRQs 9) *0, disabled.
ACPI: PCI Interrupt Link [C14B] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [C14C] (IRQs 10 11) *0, disabled.
vgaarb: device added: PCI:0000:01:05.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
vgaarb: bridge control possible 0000:01:05.0
SCSI subsystem initialized
libata version 3.00 loaded.
PCI: Using ACPI for IRQ routing
PCI: pci_cache_line_size set to 64 bytes
pci 0000:00:14.2: address space collision: [mem 0xd0608000-0xd060bfff
64bit] conflicts with 0000:00:12.0 [mem 0xd0609000-0xd06093ff]
reserve RAM buffer: 000000000009fc00 - 000000000009ffff
reserve RAM buffer: 00000000b7fb0000 - 00000000b7ffffff
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp 00:00: [mem 0x00000000-0x0009ffff]
pnp 00:00: [mem 0x000e0000-0x000fffff]
pnp 00:00: [mem 0x00100000-0xffffffff]
system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
system 00:00: [mem 0x000e0000-0x000fffff] could not be reserved
system 00:00: [mem 0x00100000-0xffffffff] could not be reserved
system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
pnp 00:01: [bus 00-ff]
pnp 00:01: [io  0x0cf8-0x0cff]
pnp 00:01: [io  0x0000-0x0cf7 window]
pnp 00:01: [io  0x0d00-0xffff window]
pnp 00:01: [mem 0x000a0000-0x000bffff window]
pnp 00:01: [mem 0xc0000000-0xfedfffff window]
pnp 00:01: [mem 0xfee01000-0xffffffff window]
pnp 00:01: [mem 0x000d0000-0x000dffff window]
pnp 00:01: Plug and Play ACPI device, IDs PNP0a03 (active)
pnp 00:02: Plug and Play ACPI device, IDs PNP0401 (disabled)
pnp 00:03: [io  0x00f0-0x00ff]
pnp 00:03: [irq 13]
pnp 00:03: Plug and Play ACPI device, IDs PNP0c04 (active)
pnp 00:04: [io  0x0000-0x000f]
pnp 00:04: [io  0x0080-0x008f]
pnp 00:04: [io  0x00c0-0x00df]
pnp 00:04: [dma 4]
pnp 00:04: Plug and Play ACPI device, IDs PNP0200 (active)
pnp 00:05: [io  0x0061]
pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
pnp 00:06: [io  0x0070-0x0071]
pnp 00:06: [io  0x0072-0x0073]
pnp 00:06: [irq 8]
pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
pnp 00:07: [io  0x0060]
pnp 00:07: [io  0x0064]
pnp 00:07: [irq 1]
pnp 00:07: Plug and Play ACPI device, IDs PNP0303 (active)
pnp 00:08: [irq 12]
pnp 00:08: Plug and Play ACPI device, IDs SYN0131 SYN0100 SYN0002
PNP0f13 (active)
pnp 00:09: [io  0x0010-0x001f]
pnp 00:09: [io  0x0022-0x0023]
pnp 00:09: [io  0x002e-0x002f]
pnp 00:09: [io  0x004e-0x004f]
pnp 00:09: [io  0x0092]
pnp 00:09: [io  0x00b0-0x00b1]
pnp 00:09: [io  0x040b]
pnp 00:09: [io  0x04d0-0x04d1]
pnp 00:09: [io  0x04d6]
pnp 00:09: [io  0x0500-0x053f]
pnp 00:09: [io  0x0c00-0x0c01]
pnp 00:09: [io  0x0c14]
pnp 00:09: [io  0x0c50-0x0c51]
pnp 00:09: [io  0x0c52]
pnp 00:09: [io  0x0c6c]
pnp 00:09: [io  0x0c6f]
pnp 00:09: [io  0x0cd0-0x0cdf]
pnp 00:09: [mem 0xffb00000-0xffbfffff]
pnp 00:09: [mem 0xfff00000-0xffffffff]
system 00:09: [io  0x040b] has been reserved
system 00:09: [io  0x04d0-0x04d1] has been reserved
system 00:09: [io  0x04d6] has been reserved
system 00:09: [io  0x0500-0x053f] has been reserved
system 00:09: [io  0x0c00-0x0c01] has been reserved
system 00:09: [io  0x0c14] has been reserved
system 00:09: [io  0x0c50-0x0c51] has been reserved
system 00:09: [io  0x0c52] has been reserved
system 00:09: [io  0x0c6c] has been reserved
system 00:09: [io  0x0c6f] has been reserved
system 00:09: [io  0x0cd0-0x0cdf] has been reserved
system 00:09: [mem 0xffb00000-0xffbfffff] could not be reserved
system 00:09: [mem 0xfff00000-0xffffffff] has been reserved
system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:0a: [irq 22]
pnp 00:0a: Plug and Play ACPI device, IDs HPQ0004 (active)
pnp 00:0b: [io  0x8000-0x802f]
pnp 00:0b: [io  0x8100-0x811f]
pnp 00:0b: [mem 0xe0000000-0xefffffff]
pnp 00:0b: [mem 0xfec00000-0xfec000ff]
pnp 00:0b: [mem 0xfed45000-0xfed8ffff]
system 00:0b: [io  0x8000-0x802f] has been reserved
system 00:0b: [io  0x8100-0x811f] has been reserved
system 00:0b: [mem 0xe0000000-0xefffffff] has been reserved
system 00:0b: [mem 0xfec00000-0xfec000ff] could not be reserved
system 00:0b: [mem 0xfed45000-0xfed8ffff] has been reserved
system 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:0c: [mem 0x000cd400-0x000cffff]
pnp 00:0c: [mem 0x00000000-0x07ffffff]
pnp 00:0c: [mem 0xfee00000-0xfee00fff]
system 00:0c: [mem 0x000cd400-0x000cffff] has been reserved
system 00:0c: [mem 0x00000000-0x07ffffff] could not be reserved
system 00:0c: [mem 0xfee00000-0xfee00fff] has been reserved
system 00:0c: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
Switching to clocksource acpi_pm
pci 0000:02:04.0: res[13]=[io  0x0100-0x00ff] get_res_add_size add_size 100
pci 0000:02:04.0: res[14]=[io  0x0100-0x00ff] get_res_add_size add_size 100
pci 0000:00:14.4: bridge window [io  0x1000-0x0fff] to [bus 02-03] add_size 1000
pci 0000:02:04.0: res[15]=[mem 0x04000000-0x03ffffff pref]
get_res_add_size add_size 4000000
pci 0000:00:14.4: bridge window [mem 0x04000000-0x03ffffff pref] to
[bus 02-03] add_size 4000000
pci 0000:00:14.4: res[15]=[mem 0x04000000-0x03ffffff pref]
get_res_add_size add_size 4000000
pci 0000:00:14.4: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
pci 0000:00:14.4: BAR 15: assigned [mem 0xd4000000-0xd7ffffff pref]
pci 0000:00:14.2: BAR 0: assigned [mem 0xc8100000-0xc8103fff 64bit]
pci 0000:00:14.4: BAR 13: assigned [io  0x1000-0x1fff]
pci 0000:00:01.0: PCI bridge to [bus 01-01]
pci 0000:00:01.0:   bridge window [io  0x4000-0x4fff]
pci 0000:00:01.0:   bridge window [mem 0xd0400000-0xd05fffff]
pci 0000:00:01.0:   bridge window [mem 0xc0000000-0xc7ffffff 64bit pref]
pci 0000:00:04.0: PCI bridge to [bus 10-10]
pci 0000:00:04.0:   bridge window [mem 0xd0000000-0xd00fffff]
pci 0000:00:05.0: PCI bridge to [bus 20-20]
pci 0000:00:05.0:   bridge window [io  0x2000-0x3fff]
pci 0000:00:05.0:   bridge window [mem 0xcc000000-0xcfffffff]
pci 0000:00:06.0: PCI bridge to [bus 30-30]
pci 0000:00:06.0:   bridge window [mem 0xc8000000-0xc80fffff]
pci 0000:02:04.0: res[15]=[mem 0x04000000-0x03ffffff pref]
get_res_add_size add_size 4000000
pci 0000:02:04.0: res[16]=[mem 0x04000000-0x03ffffff] get_res_add_size
add_size 4000000
pci 0000:02:04.0: res[13]=[io  0x0100-0x00ff] get_res_add_size add_size 100
pci 0000:02:04.0: res[14]=[io  0x0100-0x00ff] get_res_add_size add_size 100
pci 0000:02:04.0: BAR 15: assigned [mem 0xd4000000-0xd7ffffff pref]
pci 0000:02:04.0: BAR 16: assigned [mem 0xd8000000-0xdbffffff]
pci 0000:02:04.0: BAR 13: assigned [io  0x1000-0x10ff]
pci 0000:02:04.0: BAR 14: assigned [io  0x1400-0x14ff]
pci 0000:02:04.0: CardBus bridge to [bus 03-06]
pci 0000:02:04.0:   bridge window [io  0x1000-0x10ff]
pci 0000:02:04.0:   bridge window [io  0x1400-0x14ff]
pci 0000:02:04.0:   bridge window [mem 0xd4000000-0xd7ffffff pref]
pci 0000:02:04.0:   bridge window [mem 0xd8000000-0xdbffffff]
pci 0000:00:14.4: PCI bridge to [bus 02-03]
pci 0000:00:14.4:   bridge window [io  0x1000-0x1fff]
pci 0000:00:14.4:   bridge window [mem 0xd0100000-0xd03fffff]
pci 0000:00:14.4:   bridge window [mem 0xd4000000-0xd7ffffff pref]
pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: resource 7 [mem 0xc0000000-0xfedfffff]
pci_bus 0000:00: resource 8 [mem 0xfee01000-0xffffffff]
pci_bus 0000:00: resource 9 [mem 0x000d0000-0x000dffff]
pci_bus 0000:01: resource 0 [io  0x4000-0x4fff]
pci_bus 0000:01: resource 1 [mem 0xd0400000-0xd05fffff]
pci_bus 0000:01: resource 2 [mem 0xc0000000-0xc7ffffff 64bit pref]
pci_bus 0000:10: resource 1 [mem 0xd0000000-0xd00fffff]
pci_bus 0000:20: resource 0 [io  0x2000-0x3fff]
pci_bus 0000:20: resource 1 [mem 0xcc000000-0xcfffffff]
pci_bus 0000:30: resource 1 [mem 0xc8000000-0xc80fffff]
pci_bus 0000:02: resource 0 [io  0x1000-0x1fff]
pci_bus 0000:02: resource 1 [mem 0xd0100000-0xd03fffff]
pci_bus 0000:02: resource 2 [mem 0xd4000000-0xd7ffffff pref]
pci_bus 0000:02: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:02: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:02: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:02: resource 7 [mem 0xc0000000-0xfedfffff]
pci_bus 0000:02: resource 8 [mem 0xfee01000-0xffffffff]
pci_bus 0000:02: resource 9 [mem 0x000d0000-0x000dffff]
pci_bus 0000:03: resource 0 [io  0x1000-0x10ff]
pci_bus 0000:03: resource 1 [io  0x1400-0x14ff]
pci_bus 0000:03: resource 2 [mem 0xd4000000-0xd7ffffff pref]
pci_bus 0000:03: resource 3 [mem 0xd8000000-0xdbffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP: reno registered
UDP hash table entries: 2048 (order: 4, 65536 bytes)
UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
pci 0000:01:05.0: Boot video device
PCI: CLS 64 bytes, default 64
PCI-DMA: Disabling AGP.
PCI-DMA: aperture base @ ac000000 size 65536 KB
PCI-DMA: using GART IOMMU.
PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
audit: initializing netlink socket (disabled)
type=2000 audit(1337876856.453:1): initialized
HugeTLB registered 2 MB page size, pre-allocated 0 pages
msgmni has been set to 7655
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered
io scheduler cfq registered (default)
pcieport 0000:00:04.0: irq 40 for MSI/MSI-X
pcieport 0000:00:05.0: irq 41 for MSI/MSI-X
pcieport 0000:00:06.0: irq 42 for MSI/MSI-X
ACPI: AC Adapter [C1EB] (on-line)
input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input0
ACPI: Sleep Button [C28D]
input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input1
ACPI: Lid Switch [C1F0]
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
ACPI: Power Button [PWRF]
ACPI: Fan [C39B] (off)
ACPI: Fan [C39C] (off)
ACPI: Fan [C39D] (off)
ACPI: Fan [C39E] (off)
acpi device:02: registered as cooling_device4
input: Video Bus as
/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:01/LNXVIDEO:00/input/input3
ACPI: Video Device [C08D] (multi-head: yes  rom: no  post: no)
ACPI: acpi_idle registered with cpuidle
thermal LNXTHERM:00: registered as thermal_zone0
ACPI: Thermal Zone [TZ1] (62 C)
thermal LNXTHERM:01: registered as thermal_zone1
ACPI: Thermal Zone [TZ2] (50 C)
thermal LNXTHERM:02: registered as thermal_zone2
ACPI: Thermal Zone [TZ3] (31 C)
Linux agpgart interface v0.103
[drm] Initialized drm 1.1.0 20060810
[drm] radeon defaulting to userspace modesetting.
[drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[drm] No driver support for vblank timestamp query.
[drm] Initialized radeon 1.33.0 20080528 for 0000:01:05.0 on minor 0
loop: module loaded
ahci 0000:00:12.0: version 3.0
ahci 0000:00:12.0: controller can't do 64bit DMA, forcing 32bit
ahci 0000:00:12.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0x1 impl SATA mode
ahci 0000:00:12.0: flags: ncq sntf ilck pm led clo pio slum part ccc
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
ata1: SATA max UDMA/133 abar m1024@0xd0609000 port 0xd0609100 irq 16
ata2: DUMMY
ata3: DUMMY
ata4: DUMMY
scsi4 : pata_atiixp
scsi5 : pata_atiixp
ata5: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x5040 irq 14
ata6: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x5048 irq 15
i8042: PNP: PS/2 Controller [PNP0303:C24A,PNP0f13:C24B] at 0x60,0x64 irq 1,12
i8042: Detected active multiplexing controller, rev 1.1
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX0 port at 0x60,0x64 irq 12
serio: i8042 AUX1 port at 0x60,0x64 irq 12
serio: i8042 AUX2 port at 0x60,0x64 irq 12
serio: i8042 AUX3 port at 0x60,0x64 irq 12
mousedev: PS/2 mouse device common for all mice
rtc_cmos 00:06: RTC can wake from S4
rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, y3k, 114 bytes nvram
i2c /dev entries driver
cpuidle: using governor ladder
cpuidle: using governor menu
EFI Variables Facility v0.08 2004-May-17
TCP: cubic registered
ACPI: Battery Slot [C1ED] (battery present)
ACPI: Battery Slot [C1EC] (battery absent)
ata5.00: ATAPI: MATSHITADVD-RAM UJ-860H, 1.02, max MWDMA2
ata5.00: configured for MWDMA2
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-7: ST9120822AS, 3.BHE, max UDMA/100
ata1.00: 234441648 sectors, multi 16: LBA48
ata1.00: SB600 AHCI: limiting to 255 sectors per cmd
ata1.00: SB600 AHCI: limiting to 255 sectors per cmd
ata1.00: configured for UDMA/100
scsi 0:0:0:0: Direct-Access     ATA      ST9120822AS      3.BH PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 234441648 512-byte logical blocks: (120 GB/111 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
sd 0:0:0:0: Attached scsi generic sg0 type 0
scsi 4:0:0:0: CD-ROM            MATSHITA DVD-RAM UJ-860H  1.02 PQ: 0 ANSI: 5
scsi 4:0:0:0: Attached scsi generic sg1 type 5
 sda: sda1 sda2 sda3
sd 0:0:0:0: [sda] Attached SCSI disk
psmouse serio4: synaptics: Touchpad model: 1, fw: 6.2, id: 0x2580b1,
caps: 0xa04793/0x300000/0x0
psmouse serio4: synaptics: serio: Synaptics pass-through port at
isa0060/serio4/input0
input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio4/input/input4
input: AT Translated Set 2 keyboard as
/devices/platform/i8042/serio0/input/input5
registered taskstats version 1
powernow-k8: Found 1 Mobile AMD Sempron(tm) Processor 3800+ (1 cpu
cores) (version 2.20.00)
powernow-k8: fid 0xe (2200 MHz), vid 0xd
powernow-k8: fid 0xc (2000 MHz), vid 0xf
powernow-k8: fid 0xa (1800 MHz), vid 0x11
powernow-k8: fid 0x8 (1600 MHz), vid 0x13
powernow-k8: fid 0x0 (800 MHz), vid 0x18
EXT4-fs (sda3): couldn't mount as ext3 due to feature incompatibilities
EXT4-fs (sda3): couldn't mount as ext2 due to feature incompatibilities
EXT4-fs (sda3): mounted filesystem with ordered data mode. Opts: (null)
VFS: Mounted root (ext4 filesystem) readonly on device 8:3.
Freeing unused kernel memory: 432k freed
NET: Registered protocol family 1
udevd[810]: starting version 182
hp_accel: hardware type NC6715x found
lis3lv02d: 12 bits sensor found
microcode: AMD CPU family 0xf not supported
input: ST LIS3LV02DL Accelerometer as /devices/platform/lis3lv02d/input/input6
Registered led device: hp::hddprotect
hp_accel: driver loaded
ssb: Found chip with id 0x4311, rev 0x02 and package 0x00
ssb: Core 0 found: ChipCommon (cc 0x800, rev 0x13, vendor 0x4243)
ssb: Core 1 found: IEEE 802.11 (cc 0x812, rev 0x0D, vendor 0x4243)
ssb: Core 2 found: USB 1.1 Host (cc 0x817, rev 0x04, vendor 0x4243)
ssb: Core 3 found: PCI-E (cc 0x820, rev 0x05, vendor 0x4243)
k8temp 0000:00:18.3: Temperature readouts might be wrong - check erratum #141
tg3.c:v3.123 (March 21, 2012)
ssb: Sonics Silicon Backplane found on PCI device 0000:30:00.0
cfg80211: Calling CRDA to update world regulatory domain
tg3 0000:10:00.0: vpd r/w failed.  This is likely a firmware bug on
this device.  Contact the card vendor for a firmware update.
tg3 0000:10:00.0: vpd r/w failed.  This is likely a firmware bug on
this device.  Contact the card vendor for a firmware update.
snd_hda_intel 0000:00:14.2: power state changed by ACPI to D0
snd_hda_intel 0000:00:14.2: power state changed by ACPI to D0
tg3 0000:10:00.0: vpd r/w failed.  This is likely a firmware bug on
this device.  Contact the card vendor for a firmware update.
tg3 0000:10:00.0: eth0: Tigon3 [partno(none) rev b002] (PCI Express)
MAC address 00:1a:4b:76:46:6e
tg3 0000:10:00.0: eth0: attached PHY is 5787 (10/100/1000Base-T
Ethernet) (WireSpeed[1], EEE[0])
tg3 0000:10:00.0: eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
tg3 0000:10:00.0: eth0: dma_rwctrl[76180000] dma_mask[64-bit]
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
cdrom: Uniform CD-ROM driver Revision: 3.20
sr 4:0:0:0: Attached scsi CD-ROM sr0
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
Warning! ehci_hcd should always be loaded before uhci_hcd and
ohci_hcd, not after
hda-codec: No codec parser is available
ohci_hcd 0000:00:13.0: OHCI Host Controller
ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 1
ohci_hcd 0000:00:13.0: irq 23, io mem 0xd0601000
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
ehci_hcd 0000:00:13.5: EHCI Host Controller
ehci_hcd 0000:00:13.5: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:13.5: applying AMD SB600/SB700 USB freeze workaround
ehci_hcd 0000:00:13.5: debug port 1
ehci_hcd 0000:00:13.5: irq 23, io mem 0xd0606000
ehci_hcd 0000:00:13.5: USB 2.0 started, EHCI 1.00
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 10 ports detected
ohci_hcd 0000:00:13.1: OHCI Host Controller
ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 3
ohci_hcd 0000:00:13.1: irq 17, io mem 0xd0602000
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ohci_hcd 0000:00:13.2: OHCI Host Controller
ohci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 4
ohci_hcd 0000:00:13.2: irq 17, io mem 0xd0603000
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
ohci_hcd 0000:00:13.3: OHCI Host Controller
ohci_hcd 0000:00:13.3: new USB bus registered, assigned bus number 5
ohci_hcd 0000:00:13.3: irq 17, io mem 0xd0604000
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
ohci_hcd 0000:00:13.4: OHCI Host Controller
ohci_hcd 0000:00:13.4: new USB bus registered, assigned bus number 6
ohci_hcd 0000:00:13.4: irq 17, io mem 0xd0605000
b43-phy0: Broadcom 4311 WLAN found (core revision 13)
Broadcom 43xx driver loaded [ Features: P ]
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
usb 4-1: new full-speed USB device number 2 using ohci_hcd
usb 1-2: new full-speed USB device number 2 using ohci_hcd
usb 3-1: new low-speed USB device number 2 using ohci_hcd
Bluetooth: Core ver 2.16
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: L2CAP socket layer initialized
Bluetooth: SCO socket layer initialized
usbcore: registered new interface driver btusb
input: Logitech USB Optical Mouse as
/devices/pci0000:00/0000:00:13.1/usb3/3-1/3-1:1.0/input/input7
generic-usb 0003:046D:C05B.0001: input: USB HID v1.11 Mouse [Logitech
USB Optical Mouse] on usb-0000:00:13.1-1/input0
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
EXT4-fs (sda3): re-mounted. Opts: (null)
tg3 0000:10:00.0: irq 43 for MSI/MSI-X
b43-phy0: Loading firmware version 478.104 (2008-07-01 00:50:23)
NET: Registered protocol family 17
[drm] Setting GART location based on new memory map
[drm] Loading RS690/RS740 Microcode
[drm] Num pipes: 1
[drm] writeback test succeeded in 1 usecs
wlan0: authenticate with 00:21:91:82:3c:30
wlan0: send auth to 00:21:91:82:3c:30 (try 1/3)
wlan0: authenticated
wlan0: associate with 00:21:91:82:3c:30 (try 1/3)
wlan0: RX AssocResp from 00:21:91:82:3c:30 (capab=0x411 status=0 aid=1)
wlan0: associated
EXT4-fs (sda3): re-mounted. Opts: commit=0
[drm] Num pipes: 1

> Can you please try to boot with kernel paramter
> acpi_use_timer_override in another test run and with
Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 3.4.0 (root@dos) (gcc version 4.6.3 (Gentoo 4.6.3 p1.0,
pie-0.5.1) ) #2 SMP PREEMPT Thu May 24 22:49:31 OMST 2012
Command line: root=/dev/sda3 acpi=debug acpi_use_timer_override
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000b7fb0000 (usable)
 BIOS-e820: 00000000b7fb0000 - 00000000b7fc8000 (reserved)
 BIOS-e820: 00000000b7fc8000 - 00000000b7fe7fb8 (ACPI NVS)
 BIOS-e820: 00000000b7fe7fb8 - 00000000c0000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec02000 (reserved)
 BIOS-e820: 00000000ffbc0000 - 00000000ffcc0000 (reserved)
 BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000140000000 (usable)
Malformed early option 'acpi'
NX (Execute Disable) protection: active
DMI 2.4 present.
DMI: Hewlett-Packard HP Compaq 6715b (GB833EA#ACB)/30C2, BIOS 68YTT
Ver. F.0E 11/25/2008
e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
No AGP bridge found
last_pfn = 0x140000 max_arch_pfn = 0x400000000
MTRR default type: uncachable
MTRR fixed ranges enabled:
 00000-9FFFF write-back
 A0000-BFFFF uncachable
 C0000-C0FFF write-protect
 C1000-C3FFF write-back
 C4000-C4FFF write-protect
 C5000-C7FFF write-back
 C8000-C8FFF write-protect
 C9000-CBFFF write-back
 CC000-CCFFF write-protect
 CD000-CFFFF write-back
 D0000-EFFFF uncachable
 F0000-FFFFF write-protect
MTRR variable ranges enabled:
 0 base 0000000000 mask FF80000000 write-back
 1 base 0080000000 mask FFE0000000 write-back
 2 base 00A0000000 mask FFF0000000 write-back
 3 base 00B0000000 mask FFF8000000 write-back
 4 disabled
 5 disabled
 6 disabled
 7 disabled
TOM2: 0000000140000000 aka 5120M
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
e820 update range: 00000000b8000000 - 0000000100000000 (usable) ==> (reserved)
last_pfn = 0xb7fb0 max_arch_pfn = 0x400000000
initial memory mapped : 0 - 20000000
Base memory trampoline at [ffff88000009a000] 9a000 size 20480
init_memory_mapping: 0000000000000000-00000000b7fb0000
 0000000000 - 00b7e00000 page 2M
 00b7e00000 - 00b7fb0000 page 4k
kernel direct mapping tables up to b7fb0000 @ 1fffb000-20000000
init_memory_mapping: 0000000100000000-0000000140000000
 0100000000 - 0140000000 page 2M
kernel direct mapping tables up to 140000000 @ b7faa000-b7fb0000
ACPI: RSDP 00000000000fe0b0 00024 (v02 HP    )
ACPI: XSDT 00000000b7fc81bc 00064 (v01 HPQOEM SLIC-MPC 00000001 HP   00000001)
ACPI: FACP 00000000b7fc8084 000F4 (v04 HP     0944     00000003 HP   00000001)
ACPI Error: 32/64X address mismatch in Pm2ControlBlock:
0x00008800/0x0000000000008100, using 32 (20120320/tbfadt-443)
ACPI: DSDT 00000000b7fc84a4 11A38 (v01 HP        SB400 00010000 MSFT 03000001)
ACPI: FACS 00000000b7fe7d80 00040
ACPI: SLIC 00000000b7fc8220 00176 (v01 HPQOEM SLIC-MPC 00000001 HP   00000001)
ACPI: EPTH 00000000b7fc8398 00038 (v01 HP     0944     00000001 HP   00000001)
ACPI: APIC 00000000b7fc83d0 00062 (v01 HP     0944     00000001 HP   00000001)
ACPI: MCFG 00000000b7fc8434 0003C (v01 HP     0944     00000001 HP   00000001)
ACPI: TCPA 00000000b7fc8470 00032 (v02 HP     0944     00000001 HP   00000001)
ACPI: SSDT 00000000b7fd9edc 00059 (v01 HP       HPQNLP 00000001 MSFT 03000001)
ACPI: SSDT 00000000b7fd9f35 00136 (v01 HP     PSSTBLID 00000001 HP   00000001)
ACPI: Local APIC address 0xfee00000
 [ffffea0000000000-ffffea0004ffffff] PMD ->
[ffff88013b800000-ffff88013f5fffff] on node 0
Zone PFN ranges:
 DMA      0x00000010 -> 0x00001000
 DMA32    0x00001000 -> 0x00100000
 Normal   0x00100000 -> 0x00140000
Movable zone start PFN for each node
Early memory PFN ranges
   0: 0x00000010 -> 0x0000009f
   0: 0x00000100 -> 0x000b7fb0
   0: 0x00100000 -> 0x00140000
On node 0 totalpages: 1015615
 DMA zone: 64 pages used for memmap
 DMA zone: 5 pages reserved
 DMA zone: 3914 pages, LIFO batch:0
 DMA32 zone: 16320 pages used for memmap
 DMA32 zone: 733168 pages, LIFO batch:31
 Normal zone: 4096 pages used for memmap
 Normal zone: 258048 pages, LIFO batch:31
Detected use of extended apic ids on hypertransport bus
------------[ cut here ]------------
WARNING: at arch/x86/kernel/acpi/boot.c:1346
dmi_ignore_irq0_timer_override+0x27/0x47()
Hardware name: HP Compaq 6715b (GB833EA#ACB)
ati_ixp4x0 quirk not complete.
Modules linked in:
Pid: 0, comm: swapper Not tainted 3.4.0 #2
Call Trace:
 [<ffffffff8164ee08>] ? dmi_ignore_irq0_timer_override+0x27/0x47
 [<ffffffff8102e05b>] ? warn_slowpath_common+0x7b/0xc0
 [<ffffffff8102e155>] ? warn_slowpath_fmt+0x45/0x50
 [<ffffffff8164ee08>] ? dmi_ignore_irq0_timer_override+0x27/0x47
 [<ffffffff8138f9b3>] ? dmi_check_system+0x33/0x50
 [<ffffffff8164f5d7>] ? acpi_boot_init+0x10/0x34c
 [<ffffffff81649bb5>] ? setup_arch+0x6da/0x763
 [<ffffffff81648820>] ? start_kernel+0x86/0x2e9
---[ end trace 4eaa2a86a8e2da22 ]---
HP 6715b laptop detected: Ignoring BIOS IRQ0 pin2 override
ACPI: PM-Timer IO Port: 0x8008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] disabled)
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 33, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: BIOS IRQ0 pin2 override ignored.
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
SMP: Allowing 2 CPUs, 1 hotplug CPUs
nr_irqs_gsi: 40
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
PM: Registered nosave memory: 00000000b7fb0000 - 00000000b7fc8000
PM: Registered nosave memory: 00000000b7fc8000 - 00000000b7fe7000
PM: Registered nosave memory: 00000000b7fe7000 - 00000000b7fe8000
PM: Registered nosave memory: 00000000b7fe8000 - 00000000c0000000
PM: Registered nosave memory: 00000000c0000000 - 00000000e0000000
PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
PM: Registered nosave memory: 00000000f0000000 - 00000000fec00000
PM: Registered nosave memory: 00000000fec00000 - 00000000fec02000
PM: Registered nosave memory: 00000000fec02000 - 00000000ffbc0000
PM: Registered nosave memory: 00000000ffbc0000 - 00000000ffcc0000
PM: Registered nosave memory: 00000000ffcc0000 - 00000000fff00000
PM: Registered nosave memory: 00000000fff00000 - 0000000100000000
Allocating PCI resources starting at c0000000 (gap: c0000000:20000000)
setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:2 nr_node_ids:1
PERCPU: Embedded 25 pages/cpu @ffff88013fc00000 s71744 r8192 d22464 u1048576
pcpu-alloc: s71744 r8192 d22464 u1048576 alloc=1*2097152
pcpu-alloc: [0] 0 1
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 995130
Kernel command line: root=/dev/sda3 acpi=debug acpi_use_timer_override
PID hash table entries: 4096 (order: 3, 32768 bytes)
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Checking aperture...
No AGP bridge found
Node 0: aperture @ 8000000 size 32 MB
Aperture pointing to e820 RAM. Ignoring.
Your BIOS doesn't leave a aperture memory hole
Please enable the IOMMU option in the BIOS setup
This costs you 64 MB of RAM
Mapping aperture over 65536 KB of RAM @ ac000000
PM: Registered nosave memory: 00000000ac000000 - 00000000b0000000
Memory: 3853536k/5242880k available (4382k kernel code, 1180420k
absent, 208924k reserved, 1971k data, 432k init)
SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
Preemptible hierarchical RCU implementation.
NR_IRQS:4352 nr_irqs:512 16
Extended CMOS year: 2000
Console: colour VGA+ 80x25
console [tty0] enabled
Fast TSC calibration failed
TSC: Unable to calibrate against PIT
TSC: using PMTIMER reference calibration
Detected 2193.768 MHz processor.
Marking TSC unstable due to TSCs unsynchronized
Calibrating delay loop (skipped), value calculated using timer
frequency.. 4387.53 BogoMIPS (lpj=2193768)
pid_max: default: 32768 minimum: 301
Security Framework initialized
Mount-cache hash table entries: 256
Initializing cgroup subsys cpuacct
Initializing cgroup subsys freezer
tseg: 0000000000
mce: CPU supports 5 MCE banks
LVT offset 0 assigned for vector 0xf9
using AMD E400 aware idle routine
SMP alternatives: switching to UP code
ACPI: Core revision 20120320
..TIMER: vector=0x30 apic1=0 pin1=0 apic2=-1 pin2=-1
CPU0: Mobile AMD Sempron(tm) Processor 3800+ stepping 02
Performance Events: AMD PMU driver.
... version:                0
... bit width:              48
... generic registers:      4
... value mask:             0000ffffffffffff
... max period:             00007fffffffffff
... fixed-purpose events:   0
... event mask:             000000000000000f
MCE: In-kernel MCE decoding enabled.
Brought up 1 CPUs
Total of 1 processors activated (4387.53 BogoMIPS).
devtmpfs: initialized
PM: Registering ACPI NVS region [mem 0xb7fc8000-0xb7fe7fb7] (131000 bytes)
NET: Registered protocol family 16
node 0 link 0: io port [1000, fffff]
TOM: 00000000c0000000 aka 3072M
node 0 link 0: mmio [e0000000, efffffff]
node 0 link 0: mmio [f0000000, ffffffff]
node 0 link 0: mmio [c8000000, dfffffff]
node 0 link 0: mmio [c0000000, c7ffffff]
node 0 link 0: mmio [a0000, bffff]
node 0 link 0: mmio [c0000000, bfffffff]
TOM2: 0000000140000000 aka 5120M
bus: [00, ff] on node 0 link 0
bus: 00 index 0 [io  0x0000-0xffff]
bus: 00 index 1 [mem 0xc0000000-0xffffffff]
bus: 00 index 2 [mem 0x000a0000-0x000bffff]
bus: 00 index 3 [mem 0x140000000-0xfcffffffff]
ACPI: bus type pci registered
PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem
0xe0000000-0xefffffff] (base 0xe0000000)
PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: Added _OSI(Module Device)
ACPI: Added _OSI(Processor Device)
ACPI: Added _OSI(3.0 _SCP Extensions)
ACPI: Added _OSI(Processor Aggregator Device)
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: Power Resource [C171] (off)
ACPI: Power Resource [C231] (off)
ACPI: Power Resource [C24D] (on)
ACPI: Power Resource [C397] (off)
ACPI: Power Resource [C398] (off)
ACPI: Power Resource [C399] (off)
ACPI: Power Resource [C39A] (off)
ACPI: EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
PCI: Using host bridge windows from ACPI; if necessary, use
"pci=nocrs" and report a bug
ACPI: PCI Root Bridge [C08B] (domain 0000 [bus 00-ff])
pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
pci_root PNP0A03:00: host bridge window [mem 0xc0000000-0xfedfffff]
pci_root PNP0A03:00: host bridge window [mem 0xfee01000-0xffffffff]
pci_root PNP0A03:00: host bridge window [mem 0x000d0000-0x000dffff]
PCI host bridge to bus 0000:00
pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: root bus resource [mem 0xc0000000-0xfedfffff]
pci_bus 0000:00: root bus resource [mem 0xfee01000-0xffffffff]
pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000dffff]
pci 0000:00:00.0: [1002:7910] type 00 class 0x060000
pci 0000:00:01.0: [1002:7912] type 01 class 0x060400
pci 0000:00:04.0: [1002:7914] type 01 class 0x060400
pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
pci 0000:00:05.0: [1002:7915] type 01 class 0x060400
pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
pci 0000:00:06.0: [1002:7916] type 01 class 0x060400
pci 0000:00:06.0: PME# supported from D0 D3hot D3cold
pci 0000:00:12.0: [1002:4380] type 00 class 0x01018f
pci 0000:00:12.0: reg 10: [io  0x9000-0x9007]
pci 0000:00:12.0: reg 14: [io  0x9008-0x900b]
pci 0000:00:12.0: reg 18: [io  0x9010-0x9017]
pci 0000:00:12.0: reg 1c: [io  0x5018-0x501b]
pci 0000:00:12.0: reg 20: [io  0x5020-0x502f]
pci 0000:00:12.0: reg 24: [mem 0xd0609000-0xd06093ff]
pci 0000:00:12.0: set SATA to AHCI mode
pci 0000:00:13.0: [1002:4387] type 00 class 0x0c0310
pci 0000:00:13.0: reg 10: [mem 0xd0601000-0xd0601fff]
pci 0000:00:13.1: [1002:4388] type 00 class 0x0c0310
pci 0000:00:13.1: reg 10: [mem 0xd0602000-0xd0602fff]
pci 0000:00:13.2: [1002:4389] type 00 class 0x0c0310
pci 0000:00:13.2: reg 10: [mem 0xd0603000-0xd0603fff]
pci 0000:00:13.3: [1002:438a] type 00 class 0x0c0310
pci 0000:00:13.3: reg 10: [mem 0xd0604000-0xd0604fff]
pci 0000:00:13.4: [1002:438b] type 00 class 0x0c0310
pci 0000:00:13.4: reg 10: [mem 0xd0605000-0xd0605fff]
pci 0000:00:13.5: [1002:4386] type 00 class 0x0c0320
pci 0000:00:13.5: reg 10: [mem 0xd0606000-0xd06060ff]
pci 0000:00:13.5: supports D1 D2
pci 0000:00:13.5: PME# supported from D0 D1 D2 D3hot
pci 0000:00:14.0: [1002:4385] type 00 class 0x0c0500
pci 0000:00:14.0: reg 10: [io  0x8200-0x820f]
pci 0000:00:14.1: [1002:438c] type 00 class 0x010182
pci 0000:00:14.1: reg 10: [io  0x0000-0x0007]
pci 0000:00:14.1: reg 14: [io  0x0000-0x0003]
pci 0000:00:14.1: reg 18: [io  0x0000-0x0007]
pci 0000:00:14.1: reg 1c: [io  0x0000-0x0003]
pci 0000:00:14.1: reg 20: [io  0x5040-0x504f]
pci 0000:00:14.2: [1002:4383] type 00 class 0x040300
pci 0000:00:14.2: reg 10: [mem 0xd0608000-0xd060bfff 64bit]
pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
pci 0000:00:14.3: [1002:438d] type 00 class 0x060100
pci 0000:00:14.4: [1002:4384] type 01 class 0x060401
pci 0000:00:18.0: [1022:1100] type 00 class 0x060000
pci 0000:00:18.1: [1022:1101] type 00 class 0x060000
pci 0000:00:18.2: [1022:1102] type 00 class 0x060000
pci 0000:00:18.3: [1022:1103] type 00 class 0x060000
pci 0000:01:05.0: [1002:791f] type 00 class 0x030000
pci 0000:01:05.0: reg 10: [mem 0xc0000000-0xc7ffffff 64bit pref]
pci 0000:01:05.0: reg 18: [mem 0xd0400000-0xd040ffff 64bit]
pci 0000:01:05.0: reg 20: [io  0x4000-0x40ff]
pci 0000:01:05.0: reg 24: [mem 0xd0500000-0xd05fffff]
pci 0000:01:05.0: supports D1 D2
pci 0000:00:01.0: PCI bridge to [bus 01-01]
pci 0000:00:01.0:   bridge window [io  0x4000-0x4fff]
pci 0000:00:01.0:   bridge window [mem 0xd0400000-0xd05fffff]
pci 0000:00:01.0:   bridge window [mem 0xc0000000-0xc7ffffff 64bit pref]
pci 0000:10:00.0: [14e4:1693] type 00 class 0x020000
pci 0000:10:00.0: reg 10: [mem 0xd0000000-0xd000ffff 64bit]
pci 0000:10:00.0: PME# supported from D3hot D3cold
pci 0000:00:04.0: PCI bridge to [bus 10-10]
pci 0000:00:04.0:   bridge window [mem 0xd0000000-0xd00fffff]
pci 0000:00:05.0: PCI bridge to [bus 20-20]
pci 0000:00:05.0:   bridge window [io  0x2000-0x3fff]
pci 0000:00:05.0:   bridge window [mem 0xcc000000-0xcfffffff]
pci 0000:30:00.0: [14e4:4312] type 00 class 0x028000
pci 0000:30:00.0: reg 10: [mem 0xc8000000-0xc8003fff 64bit]
pci 0000:30:00.0: supports D1 D2
pci 0000:00:06.0: PCI bridge to [bus 30-30]
pci 0000:00:06.0:   bridge window [mem 0xc8000000-0xc80fffff]
pci 0000:02:04.0: [1180:0476] type 02 class 0x060700
pci 0000:02:04.0: reg 10: [mem 0xd0100000-0xd0100fff]
pci 0000:02:04.0: supports D1 D2
pci 0000:02:04.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:02:04.1: [1180:0832] type 00 class 0x0c0010
pci 0000:02:04.1: reg 10: [mem 0xd0101000-0xd01017ff]
pci 0000:02:04.1: supports D1 D2
pci 0000:02:04.1: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:14.4: PCI bridge to [bus 02-03] (subtractive decode)
pci 0000:00:14.4:   bridge window [mem 0xd0100000-0xd03fffff]
pci 0000:00:14.4:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff] (subtractive decode)
pci 0000:00:14.4:   bridge window [mem 0x000a0000-0x000bffff]
(subtractive decode)
pci 0000:00:14.4:   bridge window [mem 0xc0000000-0xfedfffff]
(subtractive decode)
pci 0000:00:14.4:   bridge window [mem 0xfee01000-0xffffffff]
(subtractive decode)
pci 0000:00:14.4:   bridge window [mem 0x000d0000-0x000dffff]
(subtractive decode)
pci_bus 0000:03: [bus 03-06] partially hidden behind transparent
bridge 0000:02 [bus 02-03]
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.C08B._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.C08B.C08C._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.C08B.C0FC._PRT]
 pci0000:00: Requesting ACPI _OSC control (0x1d)
 pci0000:00: ACPI _OSC request failed (AE_NOT_FOUND), returned control
mask: 0x1d
ACPI _OSC control for PCIe not granted, disabling ASPM
ACPI: PCI Interrupt Link [C145] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [C146] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [C147] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [C148] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [C149] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [C14A] (IRQs 9) *0, disabled.
ACPI: PCI Interrupt Link [C14B] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [C14C] (IRQs 10 11) *0, disabled.
vgaarb: device added: PCI:0000:01:05.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
vgaarb: bridge control possible 0000:01:05.0
SCSI subsystem initialized
libata version 3.00 loaded.
PCI: Using ACPI for IRQ routing
PCI: pci_cache_line_size set to 64 bytes
pci 0000:00:14.2: address space collision: [mem 0xd0608000-0xd060bfff
64bit] conflicts with 0000:00:12.0 [mem 0xd0609000-0xd06093ff]
reserve RAM buffer: 000000000009fc00 - 000000000009ffff
reserve RAM buffer: 00000000b7fb0000 - 00000000b7ffffff
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp 00:00: [mem 0x00000000-0x0009ffff]
pnp 00:00: [mem 0x000e0000-0x000fffff]
pnp 00:00: [mem 0x00100000-0xffffffff]
system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
system 00:00: [mem 0x000e0000-0x000fffff] could not be reserved
system 00:00: [mem 0x00100000-0xffffffff] could not be reserved
system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
pnp 00:01: [bus 00-ff]
pnp 00:01: [io  0x0cf8-0x0cff]
pnp 00:01: [io  0x0000-0x0cf7 window]
pnp 00:01: [io  0x0d00-0xffff window]
pnp 00:01: [mem 0x000a0000-0x000bffff window]
pnp 00:01: [mem 0xc0000000-0xfedfffff window]
pnp 00:01: [mem 0xfee01000-0xffffffff window]
pnp 00:01: [mem 0x000d0000-0x000dffff window]
pnp 00:01: Plug and Play ACPI device, IDs PNP0a03 (active)
pnp 00:02: Plug and Play ACPI device, IDs PNP0401 (disabled)
pnp 00:03: [io  0x00f0-0x00ff]
pnp 00:03: [irq 13]
pnp 00:03: Plug and Play ACPI device, IDs PNP0c04 (active)
pnp 00:04: [io  0x0000-0x000f]
pnp 00:04: [io  0x0080-0x008f]
pnp 00:04: [io  0x00c0-0x00df]
pnp 00:04: [dma 4]
pnp 00:04: Plug and Play ACPI device, IDs PNP0200 (active)
pnp 00:05: [io  0x0061]
pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
pnp 00:06: [io  0x0070-0x0071]
pnp 00:06: [io  0x0072-0x0073]
pnp 00:06: [irq 8]
pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
pnp 00:07: [io  0x0060]
pnp 00:07: [io  0x0064]
pnp 00:07: [irq 1]
pnp 00:07: Plug and Play ACPI device, IDs PNP0303 (active)
pnp 00:08: [irq 12]
pnp 00:08: Plug and Play ACPI device, IDs SYN0131 SYN0100 SYN0002
PNP0f13 (active)
pnp 00:09: [io  0x0010-0x001f]
pnp 00:09: [io  0x0022-0x0023]
pnp 00:09: [io  0x002e-0x002f]
pnp 00:09: [io  0x004e-0x004f]
pnp 00:09: [io  0x0092]
pnp 00:09: [io  0x00b0-0x00b1]
pnp 00:09: [io  0x040b]
pnp 00:09: [io  0x04d0-0x04d1]
pnp 00:09: [io  0x04d6]
pnp 00:09: [io  0x0500-0x053f]
pnp 00:09: [io  0x0c00-0x0c01]
pnp 00:09: [io  0x0c14]
pnp 00:09: [io  0x0c50-0x0c51]
pnp 00:09: [io  0x0c52]
pnp 00:09: [io  0x0c6c]
pnp 00:09: [io  0x0c6f]
pnp 00:09: [io  0x0cd0-0x0cdf]
pnp 00:09: [mem 0xffb00000-0xffbfffff]
pnp 00:09: [mem 0xfff00000-0xffffffff]
system 00:09: [io  0x040b] has been reserved
system 00:09: [io  0x04d0-0x04d1] has been reserved
system 00:09: [io  0x04d6] has been reserved
system 00:09: [io  0x0500-0x053f] has been reserved
system 00:09: [io  0x0c00-0x0c01] has been reserved
system 00:09: [io  0x0c14] has been reserved
system 00:09: [io  0x0c50-0x0c51] has been reserved
system 00:09: [io  0x0c52] has been reserved
system 00:09: [io  0x0c6c] has been reserved
system 00:09: [io  0x0c6f] has been reserved
system 00:09: [io  0x0cd0-0x0cdf] has been reserved
system 00:09: [mem 0xffb00000-0xffbfffff] could not be reserved
system 00:09: [mem 0xfff00000-0xffffffff] has been reserved
system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:0a: [irq 22]
pnp 00:0a: Plug and Play ACPI device, IDs HPQ0004 (active)
pnp 00:0b: [io  0x8000-0x802f]
pnp 00:0b: [io  0x8100-0x811f]
pnp 00:0b: [mem 0xe0000000-0xefffffff]
pnp 00:0b: [mem 0xfec00000-0xfec000ff]
pnp 00:0b: [mem 0xfed45000-0xfed8ffff]
system 00:0b: [io  0x8000-0x802f] has been reserved
system 00:0b: [io  0x8100-0x811f] has been reserved
system 00:0b: [mem 0xe0000000-0xefffffff] has been reserved
system 00:0b: [mem 0xfec00000-0xfec000ff] could not be reserved
system 00:0b: [mem 0xfed45000-0xfed8ffff] has been reserved
system 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:0c: [mem 0x000cd400-0x000cffff]
pnp 00:0c: [mem 0x00000000-0x07ffffff]
pnp 00:0c: [mem 0xfee00000-0xfee00fff]
system 00:0c: [mem 0x000cd400-0x000cffff] has been reserved
system 00:0c: [mem 0x00000000-0x07ffffff] could not be reserved
system 00:0c: [mem 0xfee00000-0xfee00fff] has been reserved
system 00:0c: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
Switching to clocksource acpi_pm
pci 0000:02:04.0: res[13]=[io  0x0100-0x00ff] get_res_add_size add_size 100
pci 0000:02:04.0: res[14]=[io  0x0100-0x00ff] get_res_add_size add_size 100
pci 0000:00:14.4: bridge window [io  0x1000-0x0fff] to [bus 02-03] add_size 1000
pci 0000:02:04.0: res[15]=[mem 0x04000000-0x03ffffff pref]
get_res_add_size add_size 4000000
pci 0000:00:14.4: bridge window [mem 0x04000000-0x03ffffff pref] to
[bus 02-03] add_size 4000000
pci 0000:00:14.4: res[15]=[mem 0x04000000-0x03ffffff pref]
get_res_add_size add_size 4000000
pci 0000:00:14.4: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
pci 0000:00:14.4: BAR 15: assigned [mem 0xd4000000-0xd7ffffff pref]
pci 0000:00:14.2: BAR 0: assigned [mem 0xc8100000-0xc8103fff 64bit]
pci 0000:00:14.4: BAR 13: assigned [io  0x1000-0x1fff]
pci 0000:00:01.0: PCI bridge to [bus 01-01]
pci 0000:00:01.0:   bridge window [io  0x4000-0x4fff]
pci 0000:00:01.0:   bridge window [mem 0xd0400000-0xd05fffff]
pci 0000:00:01.0:   bridge window [mem 0xc0000000-0xc7ffffff 64bit pref]
pci 0000:00:04.0: PCI bridge to [bus 10-10]
pci 0000:00:04.0:   bridge window [mem 0xd0000000-0xd00fffff]
pci 0000:00:05.0: PCI bridge to [bus 20-20]
pci 0000:00:05.0:   bridge window [io  0x2000-0x3fff]
pci 0000:00:05.0:   bridge window [mem 0xcc000000-0xcfffffff]
pci 0000:00:06.0: PCI bridge to [bus 30-30]
pci 0000:00:06.0:   bridge window [mem 0xc8000000-0xc80fffff]
pci 0000:02:04.0: res[15]=[mem 0x04000000-0x03ffffff pref]
get_res_add_size add_size 4000000
pci 0000:02:04.0: res[16]=[mem 0x04000000-0x03ffffff] get_res_add_size
add_size 4000000
pci 0000:02:04.0: res[13]=[io  0x0100-0x00ff] get_res_add_size add_size 100
pci 0000:02:04.0: res[14]=[io  0x0100-0x00ff] get_res_add_size add_size 100
pci 0000:02:04.0: BAR 15: assigned [mem 0xd4000000-0xd7ffffff pref]
pci 0000:02:04.0: BAR 16: assigned [mem 0xd8000000-0xdbffffff]
pci 0000:02:04.0: BAR 13: assigned [io  0x1000-0x10ff]
pci 0000:02:04.0: BAR 14: assigned [io  0x1400-0x14ff]
pci 0000:02:04.0: CardBus bridge to [bus 03-06]
pci 0000:02:04.0:   bridge window [io  0x1000-0x10ff]
pci 0000:02:04.0:   bridge window [io  0x1400-0x14ff]
pci 0000:02:04.0:   bridge window [mem 0xd4000000-0xd7ffffff pref]
pci 0000:02:04.0:   bridge window [mem 0xd8000000-0xdbffffff]
pci 0000:00:14.4: PCI bridge to [bus 02-03]
pci 0000:00:14.4:   bridge window [io  0x1000-0x1fff]
pci 0000:00:14.4:   bridge window [mem 0xd0100000-0xd03fffff]
pci 0000:00:14.4:   bridge window [mem 0xd4000000-0xd7ffffff pref]
pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: resource 7 [mem 0xc0000000-0xfedfffff]
pci_bus 0000:00: resource 8 [mem 0xfee01000-0xffffffff]
pci_bus 0000:00: resource 9 [mem 0x000d0000-0x000dffff]
pci_bus 0000:01: resource 0 [io  0x4000-0x4fff]
pci_bus 0000:01: resource 1 [mem 0xd0400000-0xd05fffff]
pci_bus 0000:01: resource 2 [mem 0xc0000000-0xc7ffffff 64bit pref]
pci_bus 0000:10: resource 1 [mem 0xd0000000-0xd00fffff]
pci_bus 0000:20: resource 0 [io  0x2000-0x3fff]
pci_bus 0000:20: resource 1 [mem 0xcc000000-0xcfffffff]
pci_bus 0000:30: resource 1 [mem 0xc8000000-0xc80fffff]
pci_bus 0000:02: resource 0 [io  0x1000-0x1fff]
pci_bus 0000:02: resource 1 [mem 0xd0100000-0xd03fffff]
pci_bus 0000:02: resource 2 [mem 0xd4000000-0xd7ffffff pref]
pci_bus 0000:02: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:02: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:02: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:02: resource 7 [mem 0xc0000000-0xfedfffff]
pci_bus 0000:02: resource 8 [mem 0xfee01000-0xffffffff]
pci_bus 0000:02: resource 9 [mem 0x000d0000-0x000dffff]
pci_bus 0000:03: resource 0 [io  0x1000-0x10ff]
pci_bus 0000:03: resource 1 [io  0x1400-0x14ff]
pci_bus 0000:03: resource 2 [mem 0xd4000000-0xd7ffffff pref]
pci_bus 0000:03: resource 3 [mem 0xd8000000-0xdbffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP: reno registered
UDP hash table entries: 2048 (order: 4, 65536 bytes)
UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
pci 0000:01:05.0: Boot video device
PCI: CLS 64 bytes, default 64
PCI-DMA: Disabling AGP.
PCI-DMA: aperture base @ ac000000 size 65536 KB
PCI-DMA: using GART IOMMU.
PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
audit: initializing netlink socket (disabled)
type=2000 audit(1337877078.452:1): initialized
HugeTLB registered 2 MB page size, pre-allocated 0 pages
msgmni has been set to 7655
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered
io scheduler cfq registered (default)
pcieport 0000:00:04.0: irq 40 for MSI/MSI-X
pcieport 0000:00:05.0: irq 41 for MSI/MSI-X
pcieport 0000:00:06.0: irq 42 for MSI/MSI-X
ACPI: AC Adapter [C1EB] (on-line)
input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input0
ACPI: Sleep Button [C28D]
input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input1
ACPI: Lid Switch [C1F0]
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
ACPI: Power Button [PWRF]
ACPI: Fan [C39B] (off)
ACPI: Fan [C39C] (off)
ACPI: Fan [C39D] (off)
ACPI: Fan [C39E] (off)
acpi device:02: registered as cooling_device4
input: Video Bus as
/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:01/LNXVIDEO:00/input/input3
ACPI: Video Device [C08D] (multi-head: yes  rom: no  post: no)
ACPI: acpi_idle registered with cpuidle
thermal LNXTHERM:00: registered as thermal_zone0
ACPI: Thermal Zone [TZ1] (64 C)
thermal LNXTHERM:01: registered as thermal_zone1
ACPI: Thermal Zone [TZ2] (51 C)
thermal LNXTHERM:02: registered as thermal_zone2
ACPI: Thermal Zone [TZ3] (31 C)
Linux agpgart interface v0.103
[drm] Initialized drm 1.1.0 20060810
[drm] radeon defaulting to userspace modesetting.
[drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[drm] No driver support for vblank timestamp query.
[drm] Initialized radeon 1.33.0 20080528 for 0000:01:05.0 on minor 0
loop: module loaded
ahci 0000:00:12.0: version 3.0
ahci 0000:00:12.0: controller can't do 64bit DMA, forcing 32bit
ahci 0000:00:12.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0x1 impl SATA mode
ahci 0000:00:12.0: flags: ncq sntf ilck pm led clo pio slum part ccc
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
ata1: SATA max UDMA/133 abar m1024@0xd0609000 port 0xd0609100 irq 16
ata2: DUMMY
ata3: DUMMY
ata4: DUMMY
scsi4 : pata_atiixp
scsi5 : pata_atiixp
ata5: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x5040 irq 14
ata6: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x5048 irq 15
i8042: PNP: PS/2 Controller [PNP0303:C24A,PNP0f13:C24B] at 0x60,0x64 irq 1,12
i8042: Detected active multiplexing controller, rev 1.1
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX0 port at 0x60,0x64 irq 12
serio: i8042 AUX1 port at 0x60,0x64 irq 12
serio: i8042 AUX2 port at 0x60,0x64 irq 12
serio: i8042 AUX3 port at 0x60,0x64 irq 12
mousedev: PS/2 mouse device common for all mice
rtc_cmos 00:06: RTC can wake from S4
rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, y3k, 114 bytes nvram
i2c /dev entries driver
cpuidle: using governor ladder
cpuidle: using governor menu
EFI Variables Facility v0.08 2004-May-17
TCP: cubic registered
ACPI: Battery Slot [C1ED] (battery present)
ACPI: Battery Slot [C1EC] (battery absent)
ata5.00: ATAPI: MATSHITADVD-RAM UJ-860H, 1.02, max MWDMA2
ata5.00: configured for MWDMA2
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-7: ST9120822AS, 3.BHE, max UDMA/100
ata1.00: 234441648 sectors, multi 16: LBA48
ata1.00: SB600 AHCI: limiting to 255 sectors per cmd
ata1.00: SB600 AHCI: limiting to 255 sectors per cmd
ata1.00: configured for UDMA/100
scsi 0:0:0:0: Direct-Access     ATA      ST9120822AS      3.BH PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 234441648 512-byte logical blocks: (120 GB/111 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
sd 0:0:0:0: Attached scsi generic sg0 type 0
scsi 4:0:0:0: CD-ROM            MATSHITA DVD-RAM UJ-860H  1.02 PQ: 0 ANSI: 5
scsi 4:0:0:0: Attached scsi generic sg1 type 5
 sda: sda1 sda2 sda3
sd 0:0:0:0: [sda] Attached SCSI disk
psmouse serio4: synaptics: Touchpad model: 1, fw: 6.2, id: 0x2580b1,
caps: 0xa04793/0x300000/0x0
psmouse serio4: synaptics: serio: Synaptics pass-through port at
isa0060/serio4/input0
input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio4/input/input4
input: AT Translated Set 2 keyboard as
/devices/platform/i8042/serio0/input/input5
registered taskstats version 1
powernow-k8: Found 1 Mobile AMD Sempron(tm) Processor 3800+ (1 cpu
cores) (version 2.20.00)
powernow-k8: fid 0xe (2200 MHz), vid 0xd
powernow-k8: fid 0xc (2000 MHz), vid 0xf
powernow-k8: fid 0xa (1800 MHz), vid 0x11
powernow-k8: fid 0x8 (1600 MHz), vid 0x13
powernow-k8: fid 0x0 (800 MHz), vid 0x18
EXT4-fs (sda3): couldn't mount as ext3 due to feature incompatibilities
EXT4-fs (sda3): couldn't mount as ext2 due to feature incompatibilities
EXT4-fs (sda3): mounted filesystem with ordered data mode. Opts: (null)
VFS: Mounted root (ext4 filesystem) readonly on device 8:3.
Freeing unused kernel memory: 432k freed
NET: Registered protocol family 1
udevd[810]: starting version 182
hp_accel: hardware type NC6715x found
lis3lv02d: 12 bits sensor found
k8temp 0000:00:18.3: Temperature readouts might be wrong - check erratum #141
input: ST LIS3LV02DL Accelerometer as /devices/platform/lis3lv02d/input/input6
Registered led device: hp::hddprotect
hp_accel: driver loaded
tg3.c:v3.123 (March 21, 2012)
ssb: Found chip with id 0x4311, rev 0x02 and package 0x00
ssb: Core 0 found: ChipCommon (cc 0x800, rev 0x13, vendor 0x4243)
ssb: Core 1 found: IEEE 802.11 (cc 0x812, rev 0x0D, vendor 0x4243)
ssb: Core 2 found: USB 1.1 Host (cc 0x817, rev 0x04, vendor 0x4243)
ssb: Core 3 found: PCI-E (cc 0x820, rev 0x05, vendor 0x4243)
ssb: Sonics Silicon Backplane found on PCI device 0000:30:00.0
tg3 0000:10:00.0: vpd r/w failed.  This is likely a firmware bug on
this device.  Contact the card vendor for a firmware update.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
tg3 0000:10:00.0: vpd r/w failed.  This is likely a firmware bug on
this device.  Contact the card vendor for a firmware update.
usbcore: registered new device driver usb
tg3 0000:10:00.0: vpd r/w failed.  This is likely a firmware bug on
this device.  Contact the card vendor for a firmware update.
tg3 0000:10:00.0: eth0: Tigon3 [partno(none) rev b002] (PCI Express)
MAC address 00:1a:4b:76:46:6e
tg3 0000:10:00.0: eth0: attached PHY is 5787 (10/100/1000Base-T
Ethernet) (WireSpeed[1], EEE[0])
tg3 0000:10:00.0: eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
tg3 0000:10:00.0: eth0: dma_rwctrl[76180000] dma_mask[64-bit]
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
ohci_hcd 0000:00:13.0: OHCI Host Controller
ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 1
ohci_hcd 0000:00:13.0: irq 23, io mem 0xd0601000
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
Warning! ehci_hcd should always be loaded before uhci_hcd and
ohci_hcd, not after
cfg80211: Calling CRDA to update world regulatory domain
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
ehci_hcd 0000:00:13.5: EHCI Host Controller
ehci_hcd 0000:00:13.5: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:13.5: applying AMD SB600/SB700 USB freeze workaround
ehci_hcd 0000:00:13.5: debug port 1
ehci_hcd 0000:00:13.5: irq 23, io mem 0xd0606000
ehci_hcd 0000:00:13.5: USB 2.0 started, EHCI 1.00
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 10 ports detected
ohci_hcd 0000:00:13.1: OHCI Host Controller
ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 3
ohci_hcd 0000:00:13.1: irq 17, io mem 0xd0602000
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
snd_hda_intel 0000:00:14.2: power state changed by ACPI to D0
snd_hda_intel 0000:00:14.2: power state changed by ACPI to D0
sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
cdrom: Uniform CD-ROM driver Revision: 3.20
sr 4:0:0:0: Attached scsi CD-ROM sr0
hda-codec: No codec parser is available
ohci_hcd 0000:00:13.2: OHCI Host Controller
ohci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 4
ohci_hcd 0000:00:13.2: irq 17, io mem 0xd0603000
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
ohci_hcd 0000:00:13.3: OHCI Host Controller
ohci_hcd 0000:00:13.3: new USB bus registered, assigned bus number 5
ohci_hcd 0000:00:13.3: irq 17, io mem 0xd0604000
microcode: AMD CPU family 0xf not supported
b43-phy0: Broadcom 4311 WLAN found (core revision 13)
Broadcom 43xx driver loaded [ Features: P ]
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
ohci_hcd 0000:00:13.4: OHCI Host Controller
ohci_hcd 0000:00:13.4: new USB bus registered, assigned bus number 6
ohci_hcd 0000:00:13.4: irq 17, io mem 0xd0605000
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
usb 1-2: new full-speed USB device number 2 using ohci_hcd
ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
usb 3-1: new low-speed USB device number 2 using ohci_hcd
Bluetooth: Core ver 2.16
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: L2CAP socket layer initialized
Bluetooth: SCO socket layer initialized
input: Logitech USB Optical Mouse as
/devices/pci0000:00/0000:00:13.1/usb3/3-1/3-1:1.0/input/input7
generic-usb 0003:046D:C05B.0001: input: USB HID v1.11 Mouse [Logitech
USB Optical Mouse] on usb-0000:00:13.1-1/input0
usb 4-1: new full-speed USB device number 2 using ohci_hcd
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
usbcore: registered new interface driver btusb
EXT4-fs (sda3): re-mounted. Opts: (null)
tg3 0000:10:00.0: irq 43 for MSI/MSI-X
b43-phy0: Loading firmware version 478.104 (2008-07-01 00:50:23)
NET: Registered protocol family 17
[drm] Setting GART location based on new memory map
[drm] Loading RS690/RS740 Microcode
[drm] Num pipes: 1
[drm] writeback test succeeded in 1 usecs
wlan0: authenticate with 00:21:91:82:3c:30
wlan0: send auth to 00:21:91:82:3c:30 (try 1/3)
wlan0: authenticated
wlan0: associate with 00:21:91:82:3c:30 (try 1/3)
wlan0: RX AssocResp from 00:21:91:82:3c:30 (capab=0x411 status=0 aid=1)
wlan0: associated
EXT4-fs (sda3): re-mounted. Opts: commit=0
[drm] Num pipes: 1

> acpi_skip_timer_override in a 3rd test (and also using acpi=debug in
> both cases) and provide dmesg output for those testruns.
Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 3.4.0 (root@dos) (gcc version 4.6.3 (Gentoo 4.6.3 p1.0,
pie-0.5.1) ) #2 SMP PREEMPT Thu May 24 22:49:31 OMST 2012
Command line: root=/dev/sda3 acpi=debug acpi_skip_timer_override
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000b7fb0000 (usable)
 BIOS-e820: 00000000b7fb0000 - 00000000b7fc8000 (reserved)
 BIOS-e820: 00000000b7fc8000 - 00000000b7fe7fb8 (ACPI NVS)
 BIOS-e820: 00000000b7fe7fb8 - 00000000c0000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec02000 (reserved)
 BIOS-e820: 00000000ffbc0000 - 00000000ffcc0000 (reserved)
 BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000140000000 (usable)
Malformed early option 'acpi'
NX (Execute Disable) protection: active
DMI 2.4 present.
DMI: Hewlett-Packard HP Compaq 6715b (GB833EA#ACB)/30C2, BIOS 68YTT
Ver. F.0E 11/25/2008
e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
No AGP bridge found
last_pfn = 0x140000 max_arch_pfn = 0x400000000
MTRR default type: uncachable
MTRR fixed ranges enabled:
 00000-9FFFF write-back
 A0000-BFFFF uncachable
 C0000-C0FFF write-protect
 C1000-C3FFF write-back
 C4000-C4FFF write-protect
 C5000-C7FFF write-back
 C8000-C8FFF write-protect
 C9000-CBFFF write-back
 CC000-CCFFF write-protect
 CD000-CFFFF write-back
 D0000-EFFFF uncachable
 F0000-FFFFF write-protect
MTRR variable ranges enabled:
 0 base 0000000000 mask FF80000000 write-back
 1 base 0080000000 mask FFE0000000 write-back
 2 base 00A0000000 mask FFF0000000 write-back
 3 base 00B0000000 mask FFF8000000 write-back
 4 disabled
 5 disabled
 6 disabled
 7 disabled
TOM2: 0000000140000000 aka 5120M
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
e820 update range: 00000000b8000000 - 0000000100000000 (usable) ==> (reserved)
last_pfn = 0xb7fb0 max_arch_pfn = 0x400000000
initial memory mapped : 0 - 20000000
Base memory trampoline at [ffff88000009a000] 9a000 size 20480
init_memory_mapping: 0000000000000000-00000000b7fb0000
 0000000000 - 00b7e00000 page 2M
 00b7e00000 - 00b7fb0000 page 4k
kernel direct mapping tables up to b7fb0000 @ 1fffb000-20000000
init_memory_mapping: 0000000100000000-0000000140000000
 0100000000 - 0140000000 page 2M
kernel direct mapping tables up to 140000000 @ b7faa000-b7fb0000
ACPI: RSDP 00000000000fe0b0 00024 (v02 HP    )
ACPI: XSDT 00000000b7fc81bc 00064 (v01 HPQOEM SLIC-MPC 00000001 HP   00000001)
ACPI: FACP 00000000b7fc8084 000F4 (v04 HP     0944     00000003 HP   00000001)
ACPI Error: 32/64X address mismatch in Pm2ControlBlock:
0x00008800/0x0000000000008100, using 32 (20120320/tbfadt-443)
ACPI: DSDT 00000000b7fc84a4 11A38 (v01 HP        SB400 00010000 MSFT 03000001)
ACPI: FACS 00000000b7fe7d80 00040
ACPI: SLIC 00000000b7fc8220 00176 (v01 HPQOEM SLIC-MPC 00000001 HP   00000001)
ACPI: EPTH 00000000b7fc8398 00038 (v01 HP     0944     00000001 HP   00000001)
ACPI: APIC 00000000b7fc83d0 00062 (v01 HP     0944     00000001 HP   00000001)
ACPI: MCFG 00000000b7fc8434 0003C (v01 HP     0944     00000001 HP   00000001)
ACPI: TCPA 00000000b7fc8470 00032 (v02 HP     0944     00000001 HP   00000001)
ACPI: SSDT 00000000b7fd9edc 00059 (v01 HP       HPQNLP 00000001 MSFT 03000001)
ACPI: SSDT 00000000b7fd9f35 00136 (v01 HP     PSSTBLID 00000001 HP   00000001)
ACPI: Local APIC address 0xfee00000
 [ffffea0000000000-ffffea0004ffffff] PMD ->
[ffff88013b800000-ffff88013f5fffff] on node 0
Zone PFN ranges:
 DMA      0x00000010 -> 0x00001000
 DMA32    0x00001000 -> 0x00100000
 Normal   0x00100000 -> 0x00140000
Movable zone start PFN for each node
Early memory PFN ranges
   0: 0x00000010 -> 0x0000009f
   0: 0x00000100 -> 0x000b7fb0
   0: 0x00100000 -> 0x00140000
On node 0 totalpages: 1015615
 DMA zone: 64 pages used for memmap
 DMA zone: 5 pages reserved
 DMA zone: 3914 pages, LIFO batch:0
 DMA32 zone: 16320 pages used for memmap
 DMA32 zone: 733168 pages, LIFO batch:31
 Normal zone: 4096 pages used for memmap
 Normal zone: 258048 pages, LIFO batch:31
SB600 revision 0x14
Ignoring ACPI timer override.
If you got timer trouble try acpi_use_timer_override
Detected use of extended apic ids on hypertransport bus
ACPI: PM-Timer IO Port: 0x8008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] disabled)
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 33, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: BIOS IRQ0 pin2 override ignored.
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
SMP: Allowing 2 CPUs, 1 hotplug CPUs
nr_irqs_gsi: 40
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
PM: Registered nosave memory: 00000000b7fb0000 - 00000000b7fc8000
PM: Registered nosave memory: 00000000b7fc8000 - 00000000b7fe7000
PM: Registered nosave memory: 00000000b7fe7000 - 00000000b7fe8000
PM: Registered nosave memory: 00000000b7fe8000 - 00000000c0000000
PM: Registered nosave memory: 00000000c0000000 - 00000000e0000000
PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
PM: Registered nosave memory: 00000000f0000000 - 00000000fec00000
PM: Registered nosave memory: 00000000fec00000 - 00000000fec02000
PM: Registered nosave memory: 00000000fec02000 - 00000000ffbc0000
PM: Registered nosave memory: 00000000ffbc0000 - 00000000ffcc0000
PM: Registered nosave memory: 00000000ffcc0000 - 00000000fff00000
PM: Registered nosave memory: 00000000fff00000 - 0000000100000000
Allocating PCI resources starting at c0000000 (gap: c0000000:20000000)
setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:2 nr_node_ids:1
PERCPU: Embedded 25 pages/cpu @ffff88013fc00000 s71744 r8192 d22464 u1048576
pcpu-alloc: s71744 r8192 d22464 u1048576 alloc=1*2097152
pcpu-alloc: [0] 0 1
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 995130
Kernel command line: root=/dev/sda3 acpi=debug acpi_skip_timer_override
PID hash table entries: 4096 (order: 3, 32768 bytes)
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Checking aperture...
No AGP bridge found
Node 0: aperture @ 28000000 size 32 MB
Aperture pointing to e820 RAM. Ignoring.
Your BIOS doesn't leave a aperture memory hole
Please enable the IOMMU option in the BIOS setup
This costs you 64 MB of RAM
Mapping aperture over 65536 KB of RAM @ ac000000
PM: Registered nosave memory: 00000000ac000000 - 00000000b0000000
Memory: 3853536k/5242880k available (4382k kernel code, 1180420k
absent, 208924k reserved, 1971k data, 432k init)
SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
Preemptible hierarchical RCU implementation.
NR_IRQS:4352 nr_irqs:512 16
Extended CMOS year: 2000
Console: colour VGA+ 80x25
console [tty0] enabled
Fast TSC calibration failed
TSC: Unable to calibrate against PIT
TSC: using PMTIMER reference calibration
Detected 2190.698 MHz processor.
Marking TSC unstable due to TSCs unsynchronized
Calibrating delay loop (skipped), value calculated using timer
frequency.. 4381.39 BogoMIPS (lpj=2190698)
pid_max: default: 32768 minimum: 301
Security Framework initialized
Mount-cache hash table entries: 256
Initializing cgroup subsys cpuacct
Initializing cgroup subsys freezer
tseg: 0000000000
mce: CPU supports 5 MCE banks
LVT offset 0 assigned for vector 0xf9
using AMD E400 aware idle routine
SMP alternatives: switching to UP code
ACPI: Core revision 20120320
..TIMER: vector=0x30 apic1=0 pin1=0 apic2=-1 pin2=-1
CPU0: Mobile AMD Sempron(tm) Processor 3800+ stepping 02
Performance Events: AMD PMU driver.
... version:                0
... bit width:              48
... generic registers:      4
... value mask:             0000ffffffffffff
... max period:             00007fffffffffff
... fixed-purpose events:   0
... event mask:             000000000000000f
MCE: In-kernel MCE decoding enabled.
Brought up 1 CPUs
Total of 1 processors activated (4381.39 BogoMIPS).
devtmpfs: initialized
PM: Registering ACPI NVS region [mem 0xb7fc8000-0xb7fe7fb7] (131000 bytes)
NET: Registered protocol family 16
node 0 link 0: io port [1000, fffff]
TOM: 00000000c0000000 aka 3072M
node 0 link 0: mmio [e0000000, efffffff]
node 0 link 0: mmio [f0000000, ffffffff]
node 0 link 0: mmio [c8000000, dfffffff]
node 0 link 0: mmio [c0000000, c7ffffff]
node 0 link 0: mmio [a0000, bffff]
node 0 link 0: mmio [c0000000, bfffffff]
TOM2: 0000000140000000 aka 5120M
bus: [00, ff] on node 0 link 0
bus: 00 index 0 [io  0x0000-0xffff]
bus: 00 index 1 [mem 0xc0000000-0xffffffff]
bus: 00 index 2 [mem 0x000a0000-0x000bffff]
bus: 00 index 3 [mem 0x140000000-0xfcffffffff]
ACPI: bus type pci registered
PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem
0xe0000000-0xefffffff] (base 0xe0000000)
PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: Added _OSI(Module Device)
ACPI: Added _OSI(Processor Device)
ACPI: Added _OSI(3.0 _SCP Extensions)
ACPI: Added _OSI(Processor Aggregator Device)
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: Power Resource [C171] (off)
ACPI: Power Resource [C231] (off)
ACPI: Power Resource [C24D] (on)
ACPI: Power Resource [C397] (off)
ACPI: Power Resource [C398] (off)
ACPI: Power Resource [C399] (off)
ACPI: Power Resource [C39A] (off)
ACPI: EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
PCI: Using host bridge windows from ACPI; if necessary, use
"pci=nocrs" and report a bug
ACPI: PCI Root Bridge [C08B] (domain 0000 [bus 00-ff])
pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
pci_root PNP0A03:00: host bridge window [mem 0xc0000000-0xfedfffff]
pci_root PNP0A03:00: host bridge window [mem 0xfee01000-0xffffffff]
pci_root PNP0A03:00: host bridge window [mem 0x000d0000-0x000dffff]
PCI host bridge to bus 0000:00
pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: root bus resource [mem 0xc0000000-0xfedfffff]
pci_bus 0000:00: root bus resource [mem 0xfee01000-0xffffffff]
pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000dffff]
pci 0000:00:00.0: [1002:7910] type 00 class 0x060000
pci 0000:00:01.0: [1002:7912] type 01 class 0x060400
pci 0000:00:04.0: [1002:7914] type 01 class 0x060400
pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
pci 0000:00:05.0: [1002:7915] type 01 class 0x060400
pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
pci 0000:00:06.0: [1002:7916] type 01 class 0x060400
pci 0000:00:06.0: PME# supported from D0 D3hot D3cold
pci 0000:00:12.0: [1002:4380] type 00 class 0x01018f
pci 0000:00:12.0: reg 10: [io  0x9000-0x9007]
pci 0000:00:12.0: reg 14: [io  0x9008-0x900b]
pci 0000:00:12.0: reg 18: [io  0x9010-0x9017]
pci 0000:00:12.0: reg 1c: [io  0x5018-0x501b]
pci 0000:00:12.0: reg 20: [io  0x5020-0x502f]
pci 0000:00:12.0: reg 24: [mem 0xd0609000-0xd06093ff]
pci 0000:00:12.0: set SATA to AHCI mode
pci 0000:00:13.0: [1002:4387] type 00 class 0x0c0310
pci 0000:00:13.0: reg 10: [mem 0xd0601000-0xd0601fff]
pci 0000:00:13.1: [1002:4388] type 00 class 0x0c0310
pci 0000:00:13.1: reg 10: [mem 0xd0602000-0xd0602fff]
pci 0000:00:13.2: [1002:4389] type 00 class 0x0c0310
pci 0000:00:13.2: reg 10: [mem 0xd0603000-0xd0603fff]
pci 0000:00:13.3: [1002:438a] type 00 class 0x0c0310
pci 0000:00:13.3: reg 10: [mem 0xd0604000-0xd0604fff]
pci 0000:00:13.4: [1002:438b] type 00 class 0x0c0310
pci 0000:00:13.4: reg 10: [mem 0xd0605000-0xd0605fff]
pci 0000:00:13.5: [1002:4386] type 00 class 0x0c0320
pci 0000:00:13.5: reg 10: [mem 0xd0606000-0xd06060ff]
pci 0000:00:13.5: supports D1 D2
pci 0000:00:13.5: PME# supported from D0 D1 D2 D3hot
pci 0000:00:14.0: [1002:4385] type 00 class 0x0c0500
pci 0000:00:14.0: reg 10: [io  0x8200-0x820f]
pci 0000:00:14.1: [1002:438c] type 00 class 0x010182
pci 0000:00:14.1: reg 10: [io  0x0000-0x0007]
pci 0000:00:14.1: reg 14: [io  0x0000-0x0003]
pci 0000:00:14.1: reg 18: [io  0x0000-0x0007]
pci 0000:00:14.1: reg 1c: [io  0x0000-0x0003]
pci 0000:00:14.1: reg 20: [io  0x5040-0x504f]
pci 0000:00:14.2: [1002:4383] type 00 class 0x040300
pci 0000:00:14.2: reg 10: [mem 0xd0608000-0xd060bfff 64bit]
pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
pci 0000:00:14.3: [1002:438d] type 00 class 0x060100
pci 0000:00:14.4: [1002:4384] type 01 class 0x060401
pci 0000:00:18.0: [1022:1100] type 00 class 0x060000
pci 0000:00:18.1: [1022:1101] type 00 class 0x060000
pci 0000:00:18.2: [1022:1102] type 00 class 0x060000
pci 0000:00:18.3: [1022:1103] type 00 class 0x060000
pci 0000:01:05.0: [1002:791f] type 00 class 0x030000
pci 0000:01:05.0: reg 10: [mem 0xc0000000-0xc7ffffff 64bit pref]
pci 0000:01:05.0: reg 18: [mem 0xd0400000-0xd040ffff 64bit]
pci 0000:01:05.0: reg 20: [io  0x4000-0x40ff]
pci 0000:01:05.0: reg 24: [mem 0xd0500000-0xd05fffff]
pci 0000:01:05.0: supports D1 D2
pci 0000:00:01.0: PCI bridge to [bus 01-01]
pci 0000:00:01.0:   bridge window [io  0x4000-0x4fff]
pci 0000:00:01.0:   bridge window [mem 0xd0400000-0xd05fffff]
pci 0000:00:01.0:   bridge window [mem 0xc0000000-0xc7ffffff 64bit pref]
pci 0000:10:00.0: [14e4:1693] type 00 class 0x020000
pci 0000:10:00.0: reg 10: [mem 0xd0000000-0xd000ffff 64bit]
pci 0000:10:00.0: PME# supported from D3hot D3cold
pci 0000:00:04.0: PCI bridge to [bus 10-10]
pci 0000:00:04.0:   bridge window [mem 0xd0000000-0xd00fffff]
pci 0000:00:05.0: PCI bridge to [bus 20-20]
pci 0000:00:05.0:   bridge window [io  0x2000-0x3fff]
pci 0000:00:05.0:   bridge window [mem 0xcc000000-0xcfffffff]
pci 0000:30:00.0: [14e4:4312] type 00 class 0x028000
pci 0000:30:00.0: reg 10: [mem 0xc8000000-0xc8003fff 64bit]
pci 0000:30:00.0: supports D1 D2
pci 0000:00:06.0: PCI bridge to [bus 30-30]
pci 0000:00:06.0:   bridge window [mem 0xc8000000-0xc80fffff]
pci 0000:02:04.0: [1180:0476] type 02 class 0x060700
pci 0000:02:04.0: reg 10: [mem 0xd0100000-0xd0100fff]
pci 0000:02:04.0: supports D1 D2
pci 0000:02:04.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:02:04.1: [1180:0832] type 00 class 0x0c0010
pci 0000:02:04.1: reg 10: [mem 0xd0101000-0xd01017ff]
pci 0000:02:04.1: supports D1 D2
pci 0000:02:04.1: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:14.4: PCI bridge to [bus 02-03] (subtractive decode)
pci 0000:00:14.4:   bridge window [mem 0xd0100000-0xd03fffff]
pci 0000:00:14.4:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff] (subtractive decode)
pci 0000:00:14.4:   bridge window [mem 0x000a0000-0x000bffff]
(subtractive decode)
pci 0000:00:14.4:   bridge window [mem 0xc0000000-0xfedfffff]
(subtractive decode)
pci 0000:00:14.4:   bridge window [mem 0xfee01000-0xffffffff]
(subtractive decode)
pci 0000:00:14.4:   bridge window [mem 0x000d0000-0x000dffff]
(subtractive decode)
pci_bus 0000:03: [bus 03-06] partially hidden behind transparent
bridge 0000:02 [bus 02-03]
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.C08B._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.C08B.C08C._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.C08B.C0FC._PRT]
 pci0000:00: Requesting ACPI _OSC control (0x1d)
 pci0000:00: ACPI _OSC request failed (AE_NOT_FOUND), returned control
mask: 0x1d
ACPI _OSC control for PCIe not granted, disabling ASPM
ACPI: PCI Interrupt Link [C145] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [C146] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [C147] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [C148] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [C149] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [C14A] (IRQs 9) *0, disabled.
ACPI: PCI Interrupt Link [C14B] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [C14C] (IRQs 10 11) *0, disabled.
vgaarb: device added: PCI:0000:01:05.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
vgaarb: bridge control possible 0000:01:05.0
SCSI subsystem initialized
libata version 3.00 loaded.
PCI: Using ACPI for IRQ routing
PCI: pci_cache_line_size set to 64 bytes
pci 0000:00:14.2: address space collision: [mem 0xd0608000-0xd060bfff
64bit] conflicts with 0000:00:12.0 [mem 0xd0609000-0xd06093ff]
reserve RAM buffer: 000000000009fc00 - 000000000009ffff
reserve RAM buffer: 00000000b7fb0000 - 00000000b7ffffff
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp 00:00: [mem 0x00000000-0x0009ffff]
pnp 00:00: [mem 0x000e0000-0x000fffff]
pnp 00:00: [mem 0x00100000-0xffffffff]
system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
system 00:00: [mem 0x000e0000-0x000fffff] could not be reserved
system 00:00: [mem 0x00100000-0xffffffff] could not be reserved
system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
pnp 00:01: [bus 00-ff]
pnp 00:01: [io  0x0cf8-0x0cff]
pnp 00:01: [io  0x0000-0x0cf7 window]
pnp 00:01: [io  0x0d00-0xffff window]
pnp 00:01: [mem 0x000a0000-0x000bffff window]
pnp 00:01: [mem 0xc0000000-0xfedfffff window]
pnp 00:01: [mem 0xfee01000-0xffffffff window]
pnp 00:01: [mem 0x000d0000-0x000dffff window]
pnp 00:01: Plug and Play ACPI device, IDs PNP0a03 (active)
pnp 00:02: Plug and Play ACPI device, IDs PNP0401 (disabled)
pnp 00:03: [io  0x00f0-0x00ff]
pnp 00:03: [irq 13]
pnp 00:03: Plug and Play ACPI device, IDs PNP0c04 (active)
pnp 00:04: [io  0x0000-0x000f]
pnp 00:04: [io  0x0080-0x008f]
pnp 00:04: [io  0x00c0-0x00df]
pnp 00:04: [dma 4]
pnp 00:04: Plug and Play ACPI device, IDs PNP0200 (active)
pnp 00:05: [io  0x0061]
pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
pnp 00:06: [io  0x0070-0x0071]
pnp 00:06: [io  0x0072-0x0073]
pnp 00:06: [irq 8]
pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
pnp 00:07: [io  0x0060]
pnp 00:07: [io  0x0064]
pnp 00:07: [irq 1]
pnp 00:07: Plug and Play ACPI device, IDs PNP0303 (active)
pnp 00:08: [irq 12]
pnp 00:08: Plug and Play ACPI device, IDs SYN0131 SYN0100 SYN0002
PNP0f13 (active)
pnp 00:09: [io  0x0010-0x001f]
pnp 00:09: [io  0x0022-0x0023]
pnp 00:09: [io  0x002e-0x002f]
pnp 00:09: [io  0x004e-0x004f]
pnp 00:09: [io  0x0092]
pnp 00:09: [io  0x00b0-0x00b1]
pnp 00:09: [io  0x040b]
pnp 00:09: [io  0x04d0-0x04d1]
pnp 00:09: [io  0x04d6]
pnp 00:09: [io  0x0500-0x053f]
pnp 00:09: [io  0x0c00-0x0c01]
pnp 00:09: [io  0x0c14]
pnp 00:09: [io  0x0c50-0x0c51]
pnp 00:09: [io  0x0c52]
pnp 00:09: [io  0x0c6c]
pnp 00:09: [io  0x0c6f]
pnp 00:09: [io  0x0cd0-0x0cdf]
pnp 00:09: [mem 0xffb00000-0xffbfffff]
pnp 00:09: [mem 0xfff00000-0xffffffff]
system 00:09: [io  0x040b] has been reserved
system 00:09: [io  0x04d0-0x04d1] has been reserved
system 00:09: [io  0x04d6] has been reserved
system 00:09: [io  0x0500-0x053f] has been reserved
system 00:09: [io  0x0c00-0x0c01] has been reserved
system 00:09: [io  0x0c14] has been reserved
system 00:09: [io  0x0c50-0x0c51] has been reserved
system 00:09: [io  0x0c52] has been reserved
system 00:09: [io  0x0c6c] has been reserved
system 00:09: [io  0x0c6f] has been reserved
system 00:09: [io  0x0cd0-0x0cdf] has been reserved
system 00:09: [mem 0xffb00000-0xffbfffff] could not be reserved
system 00:09: [mem 0xfff00000-0xffffffff] has been reserved
system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:0a: [irq 22]
pnp 00:0a: Plug and Play ACPI device, IDs HPQ0004 (active)
pnp 00:0b: [io  0x8000-0x802f]
pnp 00:0b: [io  0x8100-0x811f]
pnp 00:0b: [mem 0xe0000000-0xefffffff]
pnp 00:0b: [mem 0xfec00000-0xfec000ff]
pnp 00:0b: [mem 0xfed45000-0xfed8ffff]
system 00:0b: [io  0x8000-0x802f] has been reserved
system 00:0b: [io  0x8100-0x811f] has been reserved
system 00:0b: [mem 0xe0000000-0xefffffff] has been reserved
system 00:0b: [mem 0xfec00000-0xfec000ff] could not be reserved
system 00:0b: [mem 0xfed45000-0xfed8ffff] has been reserved
system 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:0c: [mem 0x000cd400-0x000cffff]
pnp 00:0c: [mem 0x00000000-0x07ffffff]
pnp 00:0c: [mem 0xfee00000-0xfee00fff]
system 00:0c: [mem 0x000cd400-0x000cffff] has been reserved
system 00:0c: [mem 0x00000000-0x07ffffff] could not be reserved
system 00:0c: [mem 0xfee00000-0xfee00fff] has been reserved
system 00:0c: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
Switching to clocksource acpi_pm
pci 0000:02:04.0: res[13]=[io  0x0100-0x00ff] get_res_add_size add_size 100
pci 0000:02:04.0: res[14]=[io  0x0100-0x00ff] get_res_add_size add_size 100
pci 0000:00:14.4: bridge window [io  0x1000-0x0fff] to [bus 02-03] add_size 1000
pci 0000:02:04.0: res[15]=[mem 0x04000000-0x03ffffff pref]
get_res_add_size add_size 4000000
pci 0000:00:14.4: bridge window [mem 0x04000000-0x03ffffff pref] to
[bus 02-03] add_size 4000000
pci 0000:00:14.4: res[15]=[mem 0x04000000-0x03ffffff pref]
get_res_add_size add_size 4000000
pci 0000:00:14.4: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
pci 0000:00:14.4: BAR 15: assigned [mem 0xd4000000-0xd7ffffff pref]
pci 0000:00:14.2: BAR 0: assigned [mem 0xc8100000-0xc8103fff 64bit]
pci 0000:00:14.4: BAR 13: assigned [io  0x1000-0x1fff]
pci 0000:00:01.0: PCI bridge to [bus 01-01]
pci 0000:00:01.0:   bridge window [io  0x4000-0x4fff]
pci 0000:00:01.0:   bridge window [mem 0xd0400000-0xd05fffff]
pci 0000:00:01.0:   bridge window [mem 0xc0000000-0xc7ffffff 64bit pref]
pci 0000:00:04.0: PCI bridge to [bus 10-10]
pci 0000:00:04.0:   bridge window [mem 0xd0000000-0xd00fffff]
pci 0000:00:05.0: PCI bridge to [bus 20-20]
pci 0000:00:05.0:   bridge window [io  0x2000-0x3fff]
pci 0000:00:05.0:   bridge window [mem 0xcc000000-0xcfffffff]
pci 0000:00:06.0: PCI bridge to [bus 30-30]
pci 0000:00:06.0:   bridge window [mem 0xc8000000-0xc80fffff]
pci 0000:02:04.0: res[15]=[mem 0x04000000-0x03ffffff pref]
get_res_add_size add_size 4000000
pci 0000:02:04.0: res[16]=[mem 0x04000000-0x03ffffff] get_res_add_size
add_size 4000000
pci 0000:02:04.0: res[13]=[io  0x0100-0x00ff] get_res_add_size add_size 100
pci 0000:02:04.0: res[14]=[io  0x0100-0x00ff] get_res_add_size add_size 100
pci 0000:02:04.0: BAR 15: assigned [mem 0xd4000000-0xd7ffffff pref]
pci 0000:02:04.0: BAR 16: assigned [mem 0xd8000000-0xdbffffff]
pci 0000:02:04.0: BAR 13: assigned [io  0x1000-0x10ff]
pci 0000:02:04.0: BAR 14: assigned [io  0x1400-0x14ff]
pci 0000:02:04.0: CardBus bridge to [bus 03-06]
pci 0000:02:04.0:   bridge window [io  0x1000-0x10ff]
pci 0000:02:04.0:   bridge window [io  0x1400-0x14ff]
pci 0000:02:04.0:   bridge window [mem 0xd4000000-0xd7ffffff pref]
pci 0000:02:04.0:   bridge window [mem 0xd8000000-0xdbffffff]
pci 0000:00:14.4: PCI bridge to [bus 02-03]
pci 0000:00:14.4:   bridge window [io  0x1000-0x1fff]
pci 0000:00:14.4:   bridge window [mem 0xd0100000-0xd03fffff]
pci 0000:00:14.4:   bridge window [mem 0xd4000000-0xd7ffffff pref]
pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: resource 7 [mem 0xc0000000-0xfedfffff]
pci_bus 0000:00: resource 8 [mem 0xfee01000-0xffffffff]
pci_bus 0000:00: resource 9 [mem 0x000d0000-0x000dffff]
pci_bus 0000:01: resource 0 [io  0x4000-0x4fff]
pci_bus 0000:01: resource 1 [mem 0xd0400000-0xd05fffff]
pci_bus 0000:01: resource 2 [mem 0xc0000000-0xc7ffffff 64bit pref]
pci_bus 0000:10: resource 1 [mem 0xd0000000-0xd00fffff]
pci_bus 0000:20: resource 0 [io  0x2000-0x3fff]
pci_bus 0000:20: resource 1 [mem 0xcc000000-0xcfffffff]
pci_bus 0000:30: resource 1 [mem 0xc8000000-0xc80fffff]
pci_bus 0000:02: resource 0 [io  0x1000-0x1fff]
pci_bus 0000:02: resource 1 [mem 0xd0100000-0xd03fffff]
pci_bus 0000:02: resource 2 [mem 0xd4000000-0xd7ffffff pref]
pci_bus 0000:02: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:02: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:02: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:02: resource 7 [mem 0xc0000000-0xfedfffff]
pci_bus 0000:02: resource 8 [mem 0xfee01000-0xffffffff]
pci_bus 0000:02: resource 9 [mem 0x000d0000-0x000dffff]
pci_bus 0000:03: resource 0 [io  0x1000-0x10ff]
pci_bus 0000:03: resource 1 [io  0x1400-0x14ff]
pci_bus 0000:03: resource 2 [mem 0xd4000000-0xd7ffffff pref]
pci_bus 0000:03: resource 3 [mem 0xd8000000-0xdbffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP: reno registered
UDP hash table entries: 2048 (order: 4, 65536 bytes)
UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
pci 0000:01:05.0: Boot video device
PCI: CLS 64 bytes, default 64
PCI-DMA: Disabling AGP.
PCI-DMA: aperture base @ ac000000 size 65536 KB
PCI-DMA: using GART IOMMU.
PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
audit: initializing netlink socket (disabled)
type=2000 audit(1337877262.453:1): initialized
HugeTLB registered 2 MB page size, pre-allocated 0 pages
msgmni has been set to 7655
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered
io scheduler cfq registered (default)
pcieport 0000:00:04.0: irq 40 for MSI/MSI-X
pcieport 0000:00:05.0: irq 41 for MSI/MSI-X
pcieport 0000:00:06.0: irq 42 for MSI/MSI-X
ACPI: AC Adapter [C1EB] (on-line)
input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input0
ACPI: Sleep Button [C28D]
input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input1
ACPI: Lid Switch [C1F0]
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
ACPI: Power Button [PWRF]
ACPI: Fan [C39B] (off)
ACPI: Fan [C39C] (off)
ACPI: Fan [C39D] (off)
ACPI: Fan [C39E] (off)
acpi device:02: registered as cooling_device4
input: Video Bus as
/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:01/LNXVIDEO:00/input/input3
ACPI: Video Device [C08D] (multi-head: yes  rom: no  post: no)
ACPI: acpi_idle registered with cpuidle
thermal LNXTHERM:00: registered as thermal_zone0
ACPI: Thermal Zone [TZ1] (67 C)
thermal LNXTHERM:01: registered as thermal_zone1
ACPI: Thermal Zone [TZ2] (51 C)
thermal LNXTHERM:02: registered as thermal_zone2
ACPI: Thermal Zone [TZ3] (31 C)
Linux agpgart interface v0.103
[drm] Initialized drm 1.1.0 20060810
[drm] radeon defaulting to userspace modesetting.
[drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[drm] No driver support for vblank timestamp query.
[drm] Initialized radeon 1.33.0 20080528 for 0000:01:05.0 on minor 0
loop: module loaded
ahci 0000:00:12.0: version 3.0
ahci 0000:00:12.0: controller can't do 64bit DMA, forcing 32bit
ahci 0000:00:12.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0x1 impl SATA mode
ahci 0000:00:12.0: flags: ncq sntf ilck pm led clo pio slum part ccc
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
ata1: SATA max UDMA/133 abar m1024@0xd0609000 port 0xd0609100 irq 16
ata2: DUMMY
ata3: DUMMY
ata4: DUMMY
scsi4 : pata_atiixp
scsi5 : pata_atiixp
ata5: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x5040 irq 14
ata6: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x5048 irq 15
i8042: PNP: PS/2 Controller [PNP0303:C24A,PNP0f13:C24B] at 0x60,0x64 irq 1,12
i8042: Detected active multiplexing controller, rev 1.1
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX0 port at 0x60,0x64 irq 12
serio: i8042 AUX1 port at 0x60,0x64 irq 12
serio: i8042 AUX2 port at 0x60,0x64 irq 12
serio: i8042 AUX3 port at 0x60,0x64 irq 12
mousedev: PS/2 mouse device common for all mice
rtc_cmos 00:06: RTC can wake from S4
rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, y3k, 114 bytes nvram
i2c /dev entries driver
cpuidle: using governor ladder
cpuidle: using governor menu
EFI Variables Facility v0.08 2004-May-17
TCP: cubic registered
ACPI: Battery Slot [C1ED] (battery present)
ACPI: Battery Slot [C1EC] (battery absent)
ata5.00: ATAPI: MATSHITADVD-RAM UJ-860H, 1.02, max MWDMA2
ata5.00: configured for MWDMA2
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-7: ST9120822AS, 3.BHE, max UDMA/100
ata1.00: 234441648 sectors, multi 16: LBA48
ata1.00: SB600 AHCI: limiting to 255 sectors per cmd
ata1.00: SB600 AHCI: limiting to 255 sectors per cmd
ata1.00: configured for UDMA/100
scsi 0:0:0:0: Direct-Access     ATA      ST9120822AS      3.BH PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 234441648 512-byte logical blocks: (120 GB/111 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
sd 0:0:0:0: Attached scsi generic sg0 type 0
scsi 4:0:0:0: CD-ROM            MATSHITA DVD-RAM UJ-860H  1.02 PQ: 0 ANSI: 5
scsi 4:0:0:0: Attached scsi generic sg1 type 5
 sda: sda1 sda2 sda3
sd 0:0:0:0: [sda] Attached SCSI disk
psmouse serio4: synaptics: Touchpad model: 1, fw: 6.2, id: 0x2580b1,
caps: 0xa04793/0x300000/0x0
psmouse serio4: synaptics: serio: Synaptics pass-through port at
isa0060/serio4/input0
input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio4/input/input4
input: AT Translated Set 2 keyboard as
/devices/platform/i8042/serio0/input/input5
registered taskstats version 1
powernow-k8: Found 1 Mobile AMD Sempron(tm) Processor 3800+ (1 cpu
cores) (version 2.20.00)
powernow-k8: fid 0xe (2200 MHz), vid 0xd
powernow-k8: fid 0xc (2000 MHz), vid 0xf
powernow-k8: fid 0xa (1800 MHz), vid 0x11
powernow-k8: fid 0x8 (1600 MHz), vid 0x13
powernow-k8: fid 0x0 (800 MHz), vid 0x18
EXT4-fs (sda3): couldn't mount as ext3 due to feature incompatibilities
EXT4-fs (sda3): couldn't mount as ext2 due to feature incompatibilities
EXT4-fs (sda3): mounted filesystem with ordered data mode. Opts: (null)
VFS: Mounted root (ext4 filesystem) readonly on device 8:3.
Freeing unused kernel memory: 432k freed
NET: Registered protocol family 1
udevd[810]: starting version 182
hp_accel: hardware type NC6715x found
lis3lv02d: 12 bits sensor found
microcode: AMD CPU family 0xf not supported
input: ST LIS3LV02DL Accelerometer as /devices/platform/lis3lv02d/input/input6
Registered led device: hp::hddprotect
hp_accel: driver loaded
k8temp 0000:00:18.3: Temperature readouts might be wrong - check erratum #141
ssb: Found chip with id 0x4311, rev 0x02 and package 0x00
ssb: Core 0 found: ChipCommon (cc 0x800, rev 0x13, vendor 0x4243)
ssb: Core 1 found: IEEE 802.11 (cc 0x812, rev 0x0D, vendor 0x4243)
ssb: Core 2 found: USB 1.1 Host (cc 0x817, rev 0x04, vendor 0x4243)
ssb: Core 3 found: PCI-E (cc 0x820, rev 0x05, vendor 0x4243)
ssb: Sonics Silicon Backplane found on PCI device 0000:30:00.0
cfg80211: Calling CRDA to update world regulatory domain
b43-phy0: Broadcom 4311 WLAN found (core revision 13)
Broadcom 43xx driver loaded [ Features: P ]
tg3.c:v3.123 (March 21, 2012)
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
tg3 0000:10:00.0: vpd r/w failed.  This is likely a firmware bug on
this device.  Contact the card vendor for a firmware update.
ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
tg3 0000:10:00.0: vpd r/w failed.  This is likely a firmware bug on
this device.  Contact the card vendor for a firmware update.
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:00:13.5: EHCI Host Controller
ehci_hcd 0000:00:13.5: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:13.5: applying AMD SB600/SB700 USB freeze workaround
ehci_hcd 0000:00:13.5: debug port 1
ehci_hcd 0000:00:13.5: irq 23, io mem 0xd0606000
ehci_hcd 0000:00:13.5: USB 2.0 started, EHCI 1.00
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 10 ports detected
tg3 0000:10:00.0: vpd r/w failed.  This is likely a firmware bug on
this device.  Contact the card vendor for a firmware update.
tg3 0000:10:00.0: eth0: Tigon3 [partno(none) rev b002] (PCI Express)
MAC address 00:1a:4b:76:46:6e
tg3 0000:10:00.0: eth0: attached PHY is 5787 (10/100/1000Base-T
Ethernet) (WireSpeed[1], EEE[0])
tg3 0000:10:00.0: eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
tg3 0000:10:00.0: eth0: dma_rwctrl[76180000] dma_mask[64-bit]
sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
cdrom: Uniform CD-ROM driver Revision: 3.20
sr 4:0:0:0: Attached scsi CD-ROM sr0
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
ohci_hcd 0000:00:13.0: OHCI Host Controller
ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:13.0: irq 23, io mem 0xd0601000
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
snd_hda_intel 0000:00:14.2: power state changed by ACPI to D0
snd_hda_intel 0000:00:14.2: power state changed by ACPI to D0
hda-codec: No codec parser is available
ohci_hcd 0000:00:13.1: OHCI Host Controller
ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 3
ohci_hcd 0000:00:13.1: irq 17, io mem 0xd0602000
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ohci_hcd 0000:00:13.2: OHCI Host Controller
ohci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 4
ohci_hcd 0000:00:13.2: irq 17, io mem 0xd0603000
hub 1-0:1.0: unable to enumerate USB device on port 5
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
ohci_hcd 0000:00:13.3: OHCI Host Controller
ohci_hcd 0000:00:13.3: new USB bus registered, assigned bus number 5
ohci_hcd 0000:00:13.3: irq 17, io mem 0xd0604000
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
ohci_hcd 0000:00:13.4: OHCI Host Controller
ohci_hcd 0000:00:13.4: new USB bus registered, assigned bus number 6
ohci_hcd 0000:00:13.4: irq 17, io mem 0xd0605000
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
usb 2-2: new full-speed USB device number 2 using ohci_hcd
Bluetooth: Core ver 2.16
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: L2CAP socket layer initialized
Bluetooth: SCO socket layer initialized
usb 3-1: new low-speed USB device number 2 using ohci_hcd
usbcore: registered new interface driver btusb
input: Logitech USB Optical Mouse as
/devices/pci0000:00/0000:00:13.1/usb3/3-1/3-1:1.0/input/input7
generic-usb 0003:046D:C05B.0001: input: USB HID v1.11 Mouse [Logitech
USB Optical Mouse] on usb-0000:00:13.1-1/input0
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
usb 4-1: new full-speed USB device number 2 using ohci_hcd
EXT4-fs (sda3): re-mounted. Opts: (null)
tg3 0000:10:00.0: irq 43 for MSI/MSI-X
b43-phy0: Loading firmware version 478.104 (2008-07-01 00:50:23)
NET: Registered protocol family 17
[drm] Setting GART location based on new memory map
[drm] Loading RS690/RS740 Microcode
[drm] Num pipes: 1
[drm] writeback test succeeded in 1 usecs
wlan0: authenticate with 00:21:91:82:3c:30
wlan0: direct probe to 00:21:91:82:3c:30 (try 1/3)
wlan0: send auth to 00:21:91:82:3c:30 (try 2/3)
wlan0: authenticated
wlan0: associate with 00:21:91:82:3c:30 (try 1/3)
wlan0: RX AssocResp from 00:21:91:82:3c:30 (capab=0x411 status=0 aid=1)
wlan0: associated
EXT4-fs (sda3): re-mounted. Opts: commit=0
[drm] Num pipes: 1

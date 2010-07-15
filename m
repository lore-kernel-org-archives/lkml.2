Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933469Ab0GOPE5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 11:04:57 -0400
Received: from smtp2f.orange.fr ([80.12.242.150]:17240 "EHLO smtp2f.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933418Ab0GOPEx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 11:04:53 -0400
X-ME-UUID: 20100715150443764.12A48800072B@mwinf2f28.orange.fr
X-ME-User-Auth: eric.valette6
Message-ID: <4C3F238A.5080701@free.fr>
Date: Thu, 15 Jul 2010 17:04:42 +0200
From: Eric Valette <eric.valette@free.fr>
Reply-To: eric.valette@free.fr
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100620 Iceowl/1.0b1 Icedove/3.0.5
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: vga switcheroo not working on amilo Xi 3650
References: <4C3ED059.9050508@free.fr> <AANLkTikEWysGAk6-hxqgecjlte-ilbait_9cvbDlz9Ue@mail.gmail.com>
In-Reply-To: <AANLkTikEWysGAk6-hxqgecjlte-ilbait_9cvbDlz9Ue@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------060705070103020507050604"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060705070103020507050604
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 15/07/2010 11:16, Dave Airlie wrote:

> [drm:i915_init] *ERROR* drm/i915 can't work without intel_agp module!
>
> doesn't look good,

Its because I sent the dmesg while nvidia card was forced in the BIOS. 
Here is the dmesg in hybrid mode

> though I still haven't had a successful intel/nvidia switch as I lack
> the hardware, and nobody has worked out exactly which ACPI method is
> used to switch the MUX.

You have a bunch of DSTD.dsl for the amilo including mine here
https://bugs.launchpad.net/ubuntu/+source/xorg-server/+bug/312756

I attached it for convenience
>
> if you can get a dmesg with i915 and nouveau loaded then open a bug on
> bugs.kernel.org I can try and work with you to figure that out,

I guess I can now fill one?

-- eric

--------------060705070103020507050604
Content-Type: text/plain;
 name="dmesg"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg"

Linux version 2.6.35-rc4-git5 (valette@pink-floyd2) (gcc version 4.4.4 (Debian 4.4.4-7) ) #144 SMP PREEMPT Thu Jul 15 16:41:12 CEST 2010
Command line: BOOT_IMAGE=linux ro root=812 video=intelfb
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 0000000000098000 (usable)
 BIOS-e820: 0000000000098000 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000d6000 - 00000000000d8000 (reserved)
 BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000bbab1000 (usable)
 BIOS-e820: 00000000bbab1000 - 00000000bbab7000 (reserved)
 BIOS-e820: 00000000bbab7000 - 00000000bbbc2000 (usable)
 BIOS-e820: 00000000bbbc2000 - 00000000bbc0f000 (reserved)
 BIOS-e820: 00000000bbc0f000 - 00000000bbd08000 (usable)
 BIOS-e820: 00000000bbd08000 - 00000000bbf0f000 (reserved)
 BIOS-e820: 00000000bbf0f000 - 00000000bbf18000 (usable)
 BIOS-e820: 00000000bbf18000 - 00000000bbf1f000 (reserved)
 BIOS-e820: 00000000bbf1f000 - 00000000bbf54000 (usable)
 BIOS-e820: 00000000bbf54000 - 00000000bbf9f000 (ACPI NVS)
 BIOS-e820: 00000000bbf9f000 - 00000000bbfe3000 (usable)
 BIOS-e820: 00000000bbfe3000 - 00000000bbffd000 (ACPI data)
 BIOS-e820: 00000000bbffd000 - 00000000bc000000 (usable)
 BIOS-e820: 0000000100000000 - 0000000140000000 (usable)
NX (Execute Disable) protection: active
DMI present.
e820 update range: 0000000000000000 - 0000000000001000 (usable) ==> (reserved)
e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
No AGP bridge found
last_pfn = 0x140000 max_arch_pfn = 0x400000000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 0C0000000 mask FC0000000 uncachable
  1 base 0BE000000 mask FFE000000 uncachable
  2 base 000000000 mask F00000000 write-back
  3 base 100000000 mask FC0000000 write-back
  4 base 0BDE00000 mask FFFE00000 uncachable
  5 disabled
  6 disabled
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
e820 update range: 00000000bde00000 - 0000000100000000 (usable) ==> (reserved)
last_pfn = 0xbc000 max_arch_pfn = 0x400000000
initial memory mapped : 0 - 20000000
init_memory_mapping: 0000000000000000-00000000bc000000
 0000000000 - 00bc000000 page 2M
kernel direct mapping tables up to bc000000 @ 8000-c000
init_memory_mapping: 0000000100000000-0000000140000000
 0100000000 - 0140000000 page 2M
kernel direct mapping tables up to 140000000 @ a000-10000
ACPI: RSDP 00000000000f7560 00024 (v02 PTLTD )
ACPI: XSDT 00000000bbff4b0e 00074 (v01 FSC    PC       06040000  LTP 00000000)
ACPI: FACP 00000000bbfe7000 000F4 (v03 INTEL  CRESTLNE 06040000 ALAN 00000001)
ACPI: DSDT 00000000bbfe8000 07FF8 (v02 FIC    XY680    06040000 INTL 20050624)
ACPI: FACS 00000000bbf9efc0 00040
ACPI: HPET 00000000bbffcd86 00038 (v01 INTEL  CRESTLNE 06040000 LOHR 0000005A)
ACPI: MCFG 00000000bbffcdbe 0003C (v01 INTEL  CRESTLNE 06040000 LOHR 0000005A)
ACPI: SLIC 00000000bbffcdfa 00176 (v01 FSC    PC       06040000 LOHR 0000005A)
ACPI: APIC 00000000bbffcf70 00068 (v01 PTLTD  ? APIC   06040000  LTP 00000000)
ACPI: BOOT 00000000bbffcfd8 00028 (v01 PTLTD  $SBFTBL$ 06040000  LTP 00000001)
ACPI: SSDT 00000000bbff4baa 0007C (v01 BrtRef  DD01BRT 00001000 INTL 20050624)
ACPI: SSDT 00000000bbfe6000 00655 (v01  PmRef    CpuPm 00003000 INTL 20050624)
ACPI: SSDT 00000000bbfe5000 00259 (v01  PmRef  Cpu0Tst 00003000 INTL 20050624)
ACPI: SSDT 00000000bbfe4000 0020F (v01  PmRef    ApTst 00003000 INTL 20050624)
ACPI: Local APIC address 0xfee00000
 [ffffea0000000000-ffffea00045fffff] PMD -> [ffff880002200000-ffff8800059fffff] on node 0
Zone PFN ranges:
  DMA      0x00000001 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00140000
Movable zone start PFN for each node
early_node_map[9] active PFN ranges
    0: 0x00000001 -> 0x00000098
    0: 0x00000100 -> 0x000bbab1
    0: 0x000bbab7 -> 0x000bbbc2
    0: 0x000bbc0f -> 0x000bbd08
    0: 0x000bbf0f -> 0x000bbf18
    0: 0x000bbf1f -> 0x000bbf54
    0: 0x000bbf9f -> 0x000bbfe3
    0: 0x000bbffd -> 0x000bc000
    0: 0x00100000 -> 0x00140000
On node 0 totalpages: 1031377
  DMA zone: 56 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 3935 pages, LIFO batch:0
  DMA32 zone: 14280 pages used for memmap
  DMA32 zone: 750962 pages, LIFO batch:31
  Normal zone: 3584 pages used for memmap
  Normal zone: 258560 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x408
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a201 base: 0xfed00000
SMP: Allowing 2 CPUs, 0 hotplug CPUs
nr_irqs_gsi: 40
early_res array is doubled to 64 at [7000 - 77ff]
PM: Registered nosave memory: 0000000000098000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000d6000
PM: Registered nosave memory: 00000000000d6000 - 00000000000d8000
PM: Registered nosave memory: 00000000000d8000 - 00000000000e4000
PM: Registered nosave memory: 00000000000e4000 - 0000000000100000
PM: Registered nosave memory: 00000000bbab1000 - 00000000bbab7000
PM: Registered nosave memory: 00000000bbbc2000 - 00000000bbc0f000
PM: Registered nosave memory: 00000000bbd08000 - 00000000bbf0f000
PM: Registered nosave memory: 00000000bbf18000 - 00000000bbf1f000
PM: Registered nosave memory: 00000000bbf54000 - 00000000bbf9f000
PM: Registered nosave memory: 00000000bbfe3000 - 00000000bbffd000
PM: Registered nosave memory: 00000000bc000000 - 0000000100000000
Allocating PCI resources starting at bc000000 (gap: bc000000:44000000)
setup_percpu: NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
PERCPU: Embedded 26 pages/cpu @ffff880001a00000 s77504 r8192 d20800 u1048576
early_res array is doubled to 128 at [b000 - bfff]
pcpu-alloc: s77504 r8192 d20800 u1048576 alloc=1*2097152
pcpu-alloc: [0] 0 1 
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1013457
Kernel command line: BOOT_IMAGE=linux ro root=812 video=intelfb
PID hash table entries: 4096 (order: 3, 32768 bytes)
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Checking aperture...
No AGP bridge found
Subtract (64 early reservations)
  #1 [0001000000 - 00019197b4]   TEXT DATA BSS
  #2 [0000098000 - 0000100000]   BIOS reserved
  #3 [000191a000 - 000191a168]             BRK
  #4 [0000001000 - 0000003000]      TRAMPOLINE
  #5 [0000003000 - 0000007000]     ACPI WAKEUP
  #6 [0000008000 - 000000a000]         PGTABLE
  #7 [000000a000 - 000000b000]         PGTABLE
  #8 [000191a180 - 000191b180]         BOOTMEM
  #9 [00019197c0 - 0001919ac0]         BOOTMEM
  #10 [000211c000 - 000211d000]         BOOTMEM
  #11 [000211d000 - 000211e000]         BOOTMEM
  #12 [0002200000 - 0005a00000]        MEMMAP 0
  #13 [0001919ac0 - 0001919c40]         BOOTMEM
  #14 [000191b180 - 0001933180]         BOOTMEM
  #15 [0001933180 - 0001939180]         BOOTMEM
  #16 [000193a000 - 000193b000]         BOOTMEM
  #17 [0001919c40 - 0001919c81]         BOOTMEM
  #18 [0001919cc0 - 0001919d03]         BOOTMEM
  #19 [0001939180 - 00019395a8]         BOOTMEM
  #20 [0001919d40 - 0001919da8]         BOOTMEM
  #21 [0001919dc0 - 0001919e28]         BOOTMEM
  #22 [0001919e40 - 0001919ea8]         BOOTMEM
  #23 [0001919ec0 - 0001919f28]         BOOTMEM
  #24 [0001919f40 - 0001919fa8]         BOOTMEM
  #25 [00019395c0 - 0001939628]         BOOTMEM
  #26 [0001939640 - 00019396a8]         BOOTMEM
  #27 [00019396c0 - 0001939728]         BOOTMEM
  #28 [0001939740 - 00019397a8]         BOOTMEM
  #29 [00019397c0 - 0001939828]         BOOTMEM
  #30 [0001939840 - 00019398a8]         BOOTMEM
  #31 [00019398c0 - 0001939928]         BOOTMEM
  #32 [0001939940 - 00019399a8]         BOOTMEM
  #33 [00019399c0 - 0001939a28]         BOOTMEM
  #34 [0001939a40 - 0001939aa8]         BOOTMEM
  #35 [0001939ac0 - 0001939b28]         BOOTMEM
  #36 [0001939b40 - 0001939ba8]         BOOTMEM
  #37 [0001939bc0 - 0001939c28]         BOOTMEM
  #38 [0001919fc0 - 0001919fe0]         BOOTMEM
  #39 [0001939c40 - 0001939c60]         BOOTMEM
  #40 [0001939c80 - 0001939ca0]         BOOTMEM
  #41 [0001939cc0 - 0001939ce0]         BOOTMEM
  #42 [0001939d00 - 0001939d20]         BOOTMEM
  #43 [0001939d40 - 0001939d60]         BOOTMEM
  #44 [0001939d80 - 0001939da0]         BOOTMEM
  #45 [0001939dc0 - 0001939de0]         BOOTMEM
  #46 [0001939e00 - 0001939e2b]         BOOTMEM
  #47 [0001939e40 - 0001939e6b]         BOOTMEM
  #48 [0001a00000 - 0001a1a000]         BOOTMEM
  #49 [0001b00000 - 0001b1a000]         BOOTMEM
  #50 [0001939e80 - 0001939e88]         BOOTMEM
  #51 [0001939ec0 - 0001939ec8]         BOOTMEM
  #52 [0001939f00 - 0001939f08]         BOOTMEM
  #53 [0001939f40 - 0001939f50]         BOOTMEM
  #54 [000193d000 - 000193d140]         BOOTMEM
  #55 [0001939f80 - 0001939fe0]         BOOTMEM
  #56 [000193d140 - 000193d1a0]         BOOTMEM
  #57 [000193d1c0 - 00019451c0]         BOOTMEM
  #58 [0001b1a000 - 0001f1a000]         BOOTMEM
  #59 [0001f1a000 - 000211a000]         BOOTMEM
  #60 [0005a00000 - 0009a00000]         BOOTMEM
  #61 [00019451c0 - 00019651c0]         BOOTMEM
  #62 [00019651c0 - 00019a51c0]         BOOTMEM
  #63 [000000c000 - 0000014000]         BOOTMEM
Memory: 3986328k/5242880k available (5359k kernel code, 1117372k absent, 139180k reserved, 2931k data, 484k init)
SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
Hierarchical RCU implementation.
	RCU-based detection of stalled CPUs is disabled.
	Verbose stalled-CPUs detection is disabled.
NR_IRQS:320
Extended CMOS year: 2000
Console: colour VGA+ 80x25
console [tty0] enabled
hpet clockevent registered
Fast TSC calibration using PIT
Detected 2527.437 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 5054.87 BogoMIPS (lpj=2527437)
pid_max: default: 32768 minimum: 301
Security Framework initialized
Mount-cache hash table entries: 256
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 6 MCE banks
CPU0: Thermal monitoring handled by SMI
using mwait in idle threads.
Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
... version:                2
... bit width:              40
... generic registers:      2
... value mask:             000000ffffffffff
... max period:             000000007fffffff
... fixed-purpose events:   3
... event mask:             0000000700000003
ACPI: Core revision 20100428
Setting APIC routing to flat
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Core(TM)2 Duo CPU     T9400  @ 2.53GHz stepping 06
Booting Node   0, Processors  #1 Ok.
CPU1: Thermal monitoring handled by SMI
Brought up 2 CPUs
Total of 2 processors activated (10108.60 BogoMIPS).
Time: 16:50:44  Date: 07/15/10
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
PCI: not using MMCONFIG
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: EC: Look up EC in DSDT
ACPI: BIOS _OSI(Linux) query ignored
ACPI: SSDT 00000000bbf1ac20 0028A (v01  PmRef  Cpu0Ist 00003000 INTL 20050624)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT (null) 0028A (v01  PmRef  Cpu0Ist 00003000 INTL 20050624)
ACPI: SSDT 00000000bbf18620 0057B (v01  PmRef  Cpu0Cst 00003001 INTL 20050624)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT (null) 0057B (v01  PmRef  Cpu0Cst 00003001 INTL 20050624)
ACPI: SSDT 00000000bbf19ca0 001CF (v01  PmRef    ApIst 00003000 INTL 20050624)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT (null) 001CF (v01  PmRef    ApIst 00003000 INTL 20050624)
ACPI: SSDT 00000000bbf19f20 0008D (v01  PmRef    ApCst 00003000 INTL 20050624)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT (null) 0008D (v01  PmRef    ApCst 00003000 INTL 20050624)
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI motherboard resources
[Firmware Bug]: ACPI: ACPI brightness control misses _BQC function
ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
ACPI: No dock devices found.
PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
pci_root PNP0A08:00: host bridge window [mem 0x000e0000-0x000e3fff]
pci_root PNP0A08:00: host bridge window [mem 0xc0000000-0xfebfffff]
DMAR: Forcing write-buffer flush capability
DMAR: Disabling IOMMU for graphics on this chipset
pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
pci 0000:00:01.0: PME# disabled
pci 0000:00:02.0: reg 10: [mem 0xf3000000-0xf33fffff 64bit]
pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff 64bit pref]
pci 0000:00:02.0: reg 20: [io  0x1800-0x1807]
pci 0000:00:19.0: reg 10: [mem 0xf3800000-0xf381ffff]
pci 0000:00:19.0: reg 14: [mem 0xf3824000-0xf3824fff]
pci 0000:00:19.0: reg 18: [io  0x1820-0x183f]
pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
pci 0000:00:19.0: PME# disabled
pci 0000:00:1a.0: reg 20: [io  0x1840-0x185f]
pci 0000:00:1a.1: reg 20: [io  0x1860-0x187f]
pci 0000:00:1a.2: reg 20: [io  0x1880-0x189f]
pci 0000:00:1a.7: reg 10: [mem 0xf3825800-0xf3825bff]
pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1a.7: PME# disabled
pci 0000:00:1b.0: reg 10: [mem 0xf3820000-0xf3823fff 64bit]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: PME# disabled
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.1: PME# disabled
pci 0000:00:1d.0: reg 20: [io  0x18a0-0x18bf]
pci 0000:00:1d.1: reg 20: [io  0x18c0-0x18df]
pci 0000:00:1d.2: reg 20: [io  0x18e0-0x18ff]
pci 0000:00:1d.7: reg 10: [mem 0xf3825c00-0xf3825fff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1f.2: reg 10: [io  0x1818-0x181f]
pci 0000:00:1f.2: reg 14: [io  0x180c-0x180f]
pci 0000:00:1f.2: reg 18: [io  0x1810-0x1817]
pci 0000:00:1f.2: reg 1c: [io  0x1808-0x180b]
pci 0000:00:1f.2: reg 20: [io  0x1c00-0x1c1f]
pci 0000:00:1f.2: reg 24: [mem 0xf3825000-0xf38257ff]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.2: PME# disabled
pci 0000:00:1f.3: reg 10: [mem 0x00000000-0x000000ff 64bit]
pci 0000:00:1f.3: reg 20: [io  0x1c20-0x1c3f]
pci 0000:01:00.0: reg 10: [mem 0xf2000000-0xf2ffffff]
pci 0000:01:00.0: reg 14: [mem 0xc0000000-0xcfffffff 64bit pref]
pci 0000:01:00.0: reg 1c: [mem 0xf0000000-0xf1ffffff 64bit]
pci 0000:01:00.0: reg 24: [io  0x2000-0x207f]
pci 0000:01:00.0: reg 30: [mem 0x00000000-0x0007ffff pref]
pci 0000:00:01.0: PCI bridge to [bus 01-01]
pci 0000:00:01.0:   bridge window [io  0x2000-0x2fff]
pci 0000:00:01.0:   bridge window [mem 0xf0000000-0xf2ffffff]
pci 0000:00:01.0:   bridge window [mem 0xc0000000-0xcfffffff 64bit pref]
pci 0000:00:1c.0: PCI bridge to [bus 02-03]
pci 0000:00:1c.0:   bridge window [io  0x3000-0x3fff]
pci 0000:00:1c.0:   bridge window [mem 0xf4000000-0xf5ffffff]
pci 0000:00:1c.0:   bridge window [mem 0xf6000000-0xf7ffffff 64bit pref]
pci 0000:04:00.0: reg 10: [mem 0xf3400000-0xf3401fff 64bit]
pci 0000:04:00.0: PME# supported from D0 D3hot D3cold
pci 0000:04:00.0: PME# disabled
pci 0000:00:1c.1: PCI bridge to [bus 04-04]
pci 0000:00:1c.1:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:1c.1:   bridge window [mem 0xf3400000-0xf34fffff]
pci 0000:00:1c.1:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:05:04.0: reg 10: [mem 0xf3500000-0xf3500fff]
pci 0000:05:04.0: supports D1 D2
pci 0000:05:04.0: PME# supported from D0 D1 D2 D3hot
pci 0000:05:04.0: PME# disabled
pci 0000:00:1e.0: PCI bridge to [bus 05-05] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:1e.0:   bridge window [mem 0xf3500000-0xf35fffff]
pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x000e0000-0x000e3fff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0xc0000000-0xfebfffff] (subtractive decode)
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 *5 6 7 10 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 *10 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 *10 12 14 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 *7 11 12 14 15)
vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=none,locks=none
vgaarb: loaded
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
ACPI: WMI: Mapper loaded
Advanced Linux Sound Architecture Driver Version 1.0.23.
PCI: Using ACPI for IRQ routing
PCI: pci_cache_line_size set to 64 bytes
reserve RAM buffer: 0000000000098000 - 000000000009ffff 
reserve RAM buffer: 00000000bbab1000 - 00000000bbffffff 
reserve RAM buffer: 00000000bbbc2000 - 00000000bbffffff 
reserve RAM buffer: 00000000bbd08000 - 00000000bbffffff 
reserve RAM buffer: 00000000bbf18000 - 00000000bbffffff 
reserve RAM buffer: 00000000bbf54000 - 00000000bbffffff 
reserve RAM buffer: 00000000bbfe3000 - 00000000bbffffff 
cfg80211: Calling CRDA to update world regulatory domain
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
HPET: 4 timers in total, 0 timers will be used for per-cpu timer
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
hpet0: 4 comparators, 64-bit 14.318180 MHz counter
Switching to clocksource tsc
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 10 devices
ACPI: ACPI bus type pnp unregistered
system 00:03: [mem 0xfed00000-0xfed003ff] has been reserved
system 00:05: [io  0x0680-0x069f] has been reserved
system 00:05: [io  0x0480-0x048f] has been reserved
system 00:05: [io  0x0900-0x0903] has been reserved
system 00:05: [io  0xffff] has been reserved
system 00:05: [io  0x1000-0x107f] has been reserved
system 00:05: [io  0x1180-0x11ff] has been reserved
system 00:05: [io  0x164e-0x164f] has been reserved
system 00:05: [io  0xfe00] has been reserved
system 00:09: [mem 0xfed1c000-0xfed1ffff] has been reserved
system 00:09: [mem 0xfed10000-0xfed13fff] has been reserved
system 00:09: [mem 0xfed18000-0xfed18fff] has been reserved
system 00:09: [mem 0xfed19000-0xfed19fff] has been reserved
system 00:09: [mem 0xe0000000-0xefffffff] has been reserved
system 00:09: [mem 0xfed20000-0xfed3ffff] has been reserved
system 00:09: [mem 0xfed40000-0xfed44fff] has been reserved
system 00:09: [mem 0xfed45000-0xfed8ffff] has been reserved
pci 0000:00:1c.1: BAR 9: assigned [mem 0xf3600000-0xf37fffff 64bit pref]
pci 0000:00:1c.1: BAR 7: assigned [io  0x4000-0x4fff]
pci 0000:00:1f.3: BAR 0: assigned [mem 0xf3826000-0xf38260ff 64bit]
pci 0000:00:1f.3: BAR 0: set to [mem 0xf3826000-0xf38260ff 64bit] (PCI address [0xf3826000-0xf38260ff]
pci 0000:01:00.0: BAR 6: can't assign mem pref (size 0x80000)
pci 0000:00:01.0: PCI bridge to [bus 01-01]
pci 0000:00:01.0:   bridge window [io  0x2000-0x2fff]
pci 0000:00:01.0:   bridge window [mem 0xf0000000-0xf2ffffff]
pci 0000:00:01.0:   bridge window [mem 0xc0000000-0xcfffffff 64bit pref]
pci 0000:00:1c.0: PCI bridge to [bus 02-03]
pci 0000:00:1c.0:   bridge window [io  0x3000-0x3fff]
pci 0000:00:1c.0:   bridge window [mem 0xf4000000-0xf5ffffff]
pci 0000:00:1c.0:   bridge window [mem 0xf6000000-0xf7ffffff 64bit pref]
pci 0000:00:1c.1: PCI bridge to [bus 04-04]
pci 0000:00:1c.1:   bridge window [io  0x4000-0x4fff]
pci 0000:00:1c.1:   bridge window [mem 0xf3400000-0xf34fffff]
pci 0000:00:1c.1:   bridge window [mem 0xf3600000-0xf37fffff 64bit pref]
pci 0000:00:1e.0: PCI bridge to [bus 05-05]
pci 0000:00:1e.0:   bridge window [io  disabled]
pci 0000:00:1e.0:   bridge window [mem 0xf3500000-0xf35fffff]
pci 0000:00:1e.0:   bridge window [mem pref disabled]
pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:01.0: setting latency timer to 64
pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.0: setting latency timer to 64
pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:1c.1: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: resource 7 [mem 0x000e0000-0x000e3fff]
pci_bus 0000:00: resource 8 [mem 0xc0000000-0xfebfffff]
pci_bus 0000:01: resource 0 [io  0x2000-0x2fff]
pci_bus 0000:01: resource 1 [mem 0xf0000000-0xf2ffffff]
pci_bus 0000:01: resource 2 [mem 0xc0000000-0xcfffffff 64bit pref]
pci_bus 0000:02: resource 0 [io  0x3000-0x3fff]
pci_bus 0000:02: resource 1 [mem 0xf4000000-0xf5ffffff]
pci_bus 0000:02: resource 2 [mem 0xf6000000-0xf7ffffff 64bit pref]
pci_bus 0000:04: resource 0 [io  0x4000-0x4fff]
pci_bus 0000:04: resource 1 [mem 0xf3400000-0xf34fffff]
pci_bus 0000:04: resource 2 [mem 0xf3600000-0xf37fffff 64bit pref]
pci_bus 0000:05: resource 1 [mem 0xf3500000-0xf35fffff]
pci_bus 0000:05: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:05: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:05: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:05: resource 7 [mem 0x000e0000-0x000e3fff]
pci_bus 0000:05: resource 8 [mem 0xc0000000-0xfebfffff]
NET: Registered protocol family 2
IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
UDP hash table entries: 2048 (order: 4, 65536 bytes)
UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
NET: Registered protocol family 1
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
pci 0000:00:02.0: Boot video device
pci 0000:00:1a.0: uhci_check_and_reset_hc: legsup = 0x003b
pci 0000:00:1a.0: Performing full reset
pci 0000:00:1a.1: uhci_check_and_reset_hc: legsup = 0x0010
pci 0000:00:1a.1: Performing full reset
pci 0000:00:1a.2: uhci_check_and_reset_hc: legsup = 0x0010
pci 0000:00:1a.2: Performing full reset
pci 0000:00:1d.0: uhci_check_and_reset_hc: legsup = 0x003b
pci 0000:00:1d.0: Performing full reset
pci 0000:00:1d.1: uhci_check_and_reset_hc: legsup = 0x0010
pci 0000:00:1d.1: Performing full reset
pci 0000:00:1d.2: uhci_check_and_reset_hc: legsup = 0x0010
pci 0000:00:1d.2: Performing full reset
PCI: CLS 64 bytes, default 64
PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Placing 64MB software IO TLB between ffff880005a00000 - ffff880009a00000
software IO TLB at phys 0x5a00000 - 0x9a00000
Simple Boot Flag at 0x36 set to 0x1
microcode: CPU0 sig=0x10676, pf=0x80, revision=0x60c
microcode: CPU1 sig=0x10676, pf=0x80, revision=0x60c
microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
HugeTLB registered 2 MB page size, pre-allocated 0 pages
Slow work thread pool: Starting up
Slow work thread pool: Ready
fuse init (API version 7.14)
msgmni has been set to 7785
alg: No test for stdrng (krng)
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
pcieport 0000:00:01.0: setting latency timer to 64
pcieport 0000:00:01.0: irq 40 for MSI/MSI-X
pcieport 0000:00:1c.0: setting latency timer to 64
pcieport 0000:00:1c.0: irq 41 for MSI/MSI-X
pcieport 0000:00:1c.1: setting latency timer to 64
pcieport 0000:00:1c.1: irq 42 for MSI/MSI-X
ACPI: AC Adapter [ACAD] (off-line)
input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input0
ACPI: Lid Switch [LID]
input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input1
ACPI: Power Button [PWRB]
input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input2
ACPI: Sleep Button [SLPB]
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
ACPI: Power Button [PWRF]
ACPI: acpi_idle registered with cpuidle
Monitor-Mwait will be used to enter C-1 state
Monitor-Mwait will be used to enter C-2 state
Monitor-Mwait will be used to enter C-3 state
Marking TSC unstable due to TSC halts in idle
Switching to clocksource hpet
thermal LNXTHERM:01: registered as thermal_zone0
ACPI: Thermal Zone [TZ00] (57 C)
Non-volatile memory driver v1.3
Linux agpgart interface v0.103
agpgart-intel 0000:00:00.0: Intel GM45 Chipset
agpgart-intel 0000:00:00.0: detected 32764K stolen memory
ACPI: Battery Slot [BAT0] (battery present)
agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
ipmi message handler version 39.2
ipmi device interface
IPMI System Interface driver.
ipmi_si: Adding default-specified kcs state machine
ipmi_si: Trying default-specified kcs state machine at i/o address 0xca2, slave address 0x0, irq 0
ipmi_si: Interface detection failed
ipmi_si: Adding default-specified smic state machine
ipmi_si: Trying default-specified smic state machine at i/o address 0xca9, slave address 0x0, irq 0
ipmi_si: Interface detection failed
ipmi_si: Adding default-specified bt state machine
ipmi_si: Trying default-specified bt state machine at i/o address 0xe4, slave address 0x0, irq 0
ipmi_si: Interface detection failed
ipmi_si: Unable to find any System Interface(s)
IPMI Watchdog: driver initialized
Copyright (C) 2004 MontaVista Software - IPMI Powerdown via sys_reboot.
[drm] Initialized drm 1.1.0 20060810
i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
i915 0000:00:02.0: setting latency timer to 64
mtrr: type mismatch for d0000000,10000000 old: write-back new: write-combining
[drm] MTRR allocation failed.  Graphics performance may suffer.
i915 0000:00:02.0: irq 43 for MSI/MSI-X
[drm] set up 31M of stolen space
Console: switching to colour frame buffer device 240x67
fb0: inteldrmfb frame buffer device
drm: registered panic notifier
[Firmware Bug]: ACPI: ACPI brightness control misses _BQC function
acpi device:02: registered as cooling_device2
input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:00/LNXVIDEO:00/input/input4
ACPI: Video Device [PEGP] (multi-head: yes  rom: yes  post: no)
acpi device:05: registered as cooling_device3
input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:01/input/input5
ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
VGA switcheroo: detected DSM switching method \_SB_.PCI0.GFX0 handle
nouveau 0000:01:00.0: enabling device (0004 -> 0007)
nouveau 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
nouveau 0000:01:00.0: setting latency timer to 64
[drm] nouveau 0000:01:00.0: Detected an NV50 generation card (0x096480a1)
vga_switcheroo: enabled
[drm] nouveau 0000:01:00.0: Attempting to load BIOS image from ACPI
[drm] nouveau 0000:01:00.0: ... appears to be valid
[drm] nouveau 0000:01:00.0: BIT BIOS found
[drm] nouveau 0000:01:00.0: Bios version 62.94.66.00
[drm] nouveau 0000:01:00.0: TMDS table revision 2.0 not currently supported
[drm] nouveau 0000:01:00.0: Found Display Configuration Block version 4.0
[drm] nouveau 0000:01:00.0: Raw DCB entry 0: 01000323 00010034
[drm] nouveau 0000:01:00.0: Raw DCB entry 1: 02011300 00000028
[drm] nouveau 0000:01:00.0: Raw DCB entry 2: 02032342 00020010
[drm] nouveau 0000:01:00.0: Raw DCB entry 3: 0000000e 00000000
[drm] nouveau 0000:01:00.0: DCB connector table: VHER 0x40 5 16 4
[drm] nouveau 0000:01:00.0:   0: 0x00000040: type 0x40 idx 0 tag 0xff
[drm] nouveau 0000:01:00.0:   1: 0x00000100: type 0x00 idx 1 tag 0xff
[drm] nouveau 0000:01:00.0:   2: 0x00001261: type 0x61 idx 2 tag 0x07
[drm] nouveau 0000:01:00.0: Adaptor not initialised
[drm] nouveau 0000:01:00.0: Running VBIOS init tables
[drm] nouveau 0000:01:00.0: Parsing VBIOS init table 0 at offset 0xD463
[drm] nouveau 0000:01:00.0: Parsing VBIOS init table 1 at offset 0xD8E0
[drm] nouveau 0000:01:00.0: Parsing VBIOS init table 2 at offset 0xE8A9
[drm] nouveau 0000:01:00.0: Parsing VBIOS init table 3 at offset 0xE9CA
[drm] nouveau 0000:01:00.0: Parsing VBIOS init table 4 at offset 0xEC47
[drm] nouveau 0000:01:00.0: Parsing VBIOS init table at offset 0xECAC
[drm] nouveau 0000:01:00.0: Couldn't find matching output script table
[drm] nouveau 0000:01:00.0: 0xC108: parsing output script 0
[drm] nouveau 0000:01:00.0: Detected 512MiB VRAM
[TTM] Zone  kernel: Available graphics memory: 1993164 kiB.
[TTM] Initializing pool allocator.
[drm] nouveau 0000:01:00.0: 512 MiB GART (aperture)
mtrr: type mismatch for c0000000,10000000 old: write-back new: write-combining
[drm] nouveau 0000:01:00.0: Allocating FIFO number 1
[drm] nouveau 0000:01:00.0: nouveau_channel_alloc: initialised FIFO 1
[drm] nouveau 0000:01:00.0: Detected a LVDS output
[drm] nouveau 0000:01:00.0: Detected a DAC output
[drm] nouveau 0000:01:00.0: Detected a TMDS output
[drm] nouveau 0000:01:00.0: Detected a LVDS connector
[drm] nouveau 0000:01:00.0: LVDS present in DCB table, but couldn't determine its native mode.  Disabling.
[drm] nouveau 0000:01:00.0: Detected a VGA connector
[drm] nouveau 0000:01:00.0: Detected a HDMI connector
No connectors reported connected with modes
[drm] Cannot find any crtc or sizes - going 1024x768
[drm] nouveau 0000:01:00.0: allocated 1024x768 fb: 0x40250000, bo ffff88013e39c400
fb1: nouveaufb frame buffer device
[drm] Initialized nouveau 0.0.16 20090420 for 0000:01:00.0 on minor 1
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
brd: module loaded
loop: module loaded
ahci 0000:00:1f.2: version 3.0
ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ahci 0000:00:1f.2: irq 44 for MSI/MSI-X
ahci: SSS flag set, parallel bus scan disabled
ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 4 ports 3 Gbps 0x33 impl RAID mode
ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part ccc ems sxs 
ahci 0000:00:1f.2: setting latency timer to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
scsi4 : ahci
scsi5 : ahci
ata1: SATA max UDMA/133 abar m2048@0xf3825000 port 0xf3825100 irq 44
ata2: SATA max UDMA/133 abar m2048@0xf3825000 port 0xf3825180 irq 44
ata3: DUMMY
ata4: DUMMY
ata5: SATA max UDMA/133 abar m2048@0xf3825000 port 0xf3825300 irq 44
ata6: SATA max UDMA/133 abar m2048@0xf3825000 port 0xf3825380 irq 44
e1000e: Intel(R) PRO/1000 Network Driver - 1.0.2-k4
e1000e: Copyright (c) 1999 - 2009 Intel Corporation.
e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
e1000e 0000:00:19.0: setting latency timer to 64
e1000e 0000:00:19.0: irq 45 for MSI/MSI-X
e1000e 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:14:0b:4f:78:46
e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
e1000e 0000:00:19.0: eth0: MAC: 7, PHY: 8, PBA No: ffffff-0ff
iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:
iwlagn: Copyright(c) 2003-2010 Intel Corporation
iwlagn 0000:04:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
iwlagn 0000:04:00.0: setting latency timer to 64
iwlagn 0000:04:00.0: Detected Intel(R) WiFi Link 5100 AGN, REV=0x54
iwlagn 0000:04:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
iwlagn 0000:04:00.0: irq 46 for MSI/MSI-X
usbcore: registered new interface driver ar9170usb
console [netcon0] enabled
netconsole: network logging started
firewire_ohci 0000:05:04.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
firewire_ohci: Added fw-ohci device 0000:05:04.0, OHCI v1.0, 8 IR + 8 IT contexts, quirks 0x0
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd: block sizes: qh 104 qtd 96 itd 192 sitd 96
ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 19 (level, low) -> IRQ 19
ehci_hcd 0000:00:1a.7: setting latency timer to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
/usr/src/linux-2.6.29.1/drivers/usb/core/inode.c: creating file 'devices'
/usr/src/linux-2.6.29.1/drivers/usb/core/inode.c: creating file '001'
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1a.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
ehci_hcd 0000:00:1a.7: reset hcc_params 6871 thresh 7 uframes 1024 64 bit addr
ehci_hcd 0000:00:1a.7: debug port 1
ehci_hcd 0000:00:1a.7: reset command 080032 (park)=0 ithresh=8 Async Periodic period=1024 Reset HALT
ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
ehci_hcd 0000:00:1a.7: supports USB remote wakeup
ehci_hcd 0000:00:1a.7: irq 19, io mem 0xf3825800
ehci_hcd 0000:00:1a.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
ehci_hcd 0000:00:1a.7: init command 010001 (park)=0 ithresh=1 period=1024 RUN
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
usb usb1: default language 0x0409
usb usb1: udev 1, busnum 1, minor = 0
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.35-rc4-git5 ehci_hcd
usb usb1: SerialNumber: 0000:00:1a.7
usb usb1: usb_probe_device
usb usb1: configuration #1 chosen from 1 choice
usb usb1: adding 1-0:1.0 (config #1, interface 0)
hub 1-0:1.0: usb_probe_interface
hub 1-0:1.0: usb_probe_interface - got id
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 6 ports detected
hub 1-0:1.0: standalone hub
hub 1-0:1.0: no power switching (usb 1.0)
hub 1-0:1.0: individual port over-current protection
hub 1-0:1.0: power on to power good time: 20ms
hub 1-0:1.0: local power source is good
hub 1-0:1.0: trying to enable port power on non-switchable hub
/usr/src/linux-2.6.29.1/drivers/usb/core/inode.c: creating file '001'
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
/usr/src/linux-2.6.29.1/drivers/usb/core/inode.c: creating file '002'
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:1d.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
ehci_hcd 0000:00:1d.7: reset hcc_params 6871 thresh 7 uframes 1024 64 bit addr
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: reset command 080032 (park)=0 ithresh=8 Async Periodic period=1024 Reset HALT
ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
ehci_hcd 0000:00:1d.7: supports USB remote wakeup
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xf3825c00
ehci_hcd 0000:00:1d.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
ehci_hcd 0000:00:1d.7: init command 010001 (park)=0 ithresh=1 period=1024 RUN
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
usb usb2: default language 0x0409
usb usb2: udev 1, busnum 2, minor = 128
usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: EHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.35-rc4-git5 ehci_hcd
usb usb2: SerialNumber: 0000:00:1d.7
usb usb2: usb_probe_device
usb usb2: configuration #1 chosen from 1 choice
usb usb2: adding 2-0:1.0 (config #1, interface 0)
hub 2-0:1.0: usb_probe_interface
hub 2-0:1.0: usb_probe_interface - got id
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 6 ports detected
hub 2-0:1.0: standalone hub
hub 2-0:1.0: no power switching (usb 1.0)
hub 2-0:1.0: individual port over-current protection
hub 2-0:1.0: power on to power good time: 20ms
hub 2-0:1.0: local power source is good
hub 2-0:1.0: trying to enable port power on non-switchable hub
/usr/src/linux-2.6.29.1/drivers/usb/core/inode.c: creating file '001'
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
ohci_hcd: block sizes: ed 80 td 96
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1a.0: setting latency timer to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
/usr/src/linux-2.6.29.1/drivers/usb/core/inode.c: creating file '003'
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1a.0: detected 2 ports
uhci_hcd 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1a.0: Performing full reset
uhci_hcd 0000:00:1a.0: supports USB remote wakeup
uhci_hcd 0000:00:1a.0: irq 16, io base 0x00001840
usb usb3: default language 0x0409
usb usb3: udev 1, busnum 3, minor = 256
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.35-rc4-git5 uhci_hcd
usb usb3: SerialNumber: 0000:00:1a.0
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
/usr/src/linux-2.6.29.1/drivers/usb/core/inode.c: creating file '001'
ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.0
uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:1a.1: setting latency timer to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
/usr/src/linux-2.6.29.1/drivers/usb/core/inode.c: creating file '004'
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
ata1.00: ATA-8: FUJITSU MHZ2320BH G2, 00000009, max UDMA/100
ata1.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
uhci_hcd 0000:00:1a.1: detected 2 ports
uhci_hcd 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1a.1: Performing full reset
uhci_hcd 0000:00:1a.1: supports USB remote wakeup
ata1.00: configured for UDMA/100
uhci_hcd 0000:00:1a.1: irq 21, io base 0x00001860
usb usb4: default language 0x0409
usb usb4: udev 1, busnum 4, minor = 384
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.35-rc4-git5 uhci_hcd
usb usb4: SerialNumber: 0000:00:1a.1
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
/usr/src/linux-2.6.29.1/drivers/usb/core/inode.c: creating file '001'
ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.1
uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1a.2: setting latency timer to 64
uhci_hcd 0000:00:1a.2: UHCI Host Controller
/usr/src/linux-2.6.29.1/drivers/usb/core/inode.c: creating file '005'
uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1a.2: detected 2 ports
uhci_hcd 0000:00:1a.2: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1a.2: Performing full reset
uhci_hcd 0000:00:1a.2: supports USB remote wakeup
uhci_hcd 0000:00:1a.2: irq 19, io base 0x00001880
usb usb5: default language 0x0409
usb usb5: udev 1, busnum 5, minor = 512
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.35-rc4-git5 uhci_hcd
usb usb5: SerialNumber: 0000:00:1a.2
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
/usr/src/linux-2.6.29.1/drivers/usb/core/inode.c: creating file '001'
ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.2
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
/usr/src/linux-2.6.29.1/drivers/usb/core/inode.c: creating file '006'
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
uhci_hcd 0000:00:1d.0: detected 2 ports
scsi 0:0:0:0: Direct-Access     ATA      FUJITSU MHZ2320B 0000 PQ: 0 ANSI: 5
sd 0:0:0:0: Attached scsi generic sg0 type 0
sd 0:0:0:0: [sda] 625142448 512-byte logical blocks: (320 GB/298 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1d.0: Performing full reset
uhci_hcd 0000:00:1d.0: supports USB remote wakeup
uhci_hcd 0000:00:1d.0: irq 23, io base 0x000018a0
usb usb6: default language 0x0409
usb usb6: udev 1, busnum 6, minor = 640
usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb6: Product: UHCI Host Controller
usb usb6: Manufacturer: Linux 2.6.35-rc4-git5 uhci_hcd
usb usb6: SerialNumber: 0000:00:1d.0
ehci_hcd 0000:00:1a.7: GetStatus port 3 status 001803 POWER sig=j CSC CONNECT
hub 1-0:1.0: port 3: status 0501 change 0001
ehci_hcd 0000:00:1a.7: GetStatus port 4 status 001803 POWER sig=j CSC CONNECT
hub 1-0:1.0: port 4: status 0501 change 0001
usb usb6: usb_probe_device
usb usb6: configuration #1 chosen from 1 choice
usb usb6: adding 6-0:1.0 (config #1, interface 0)
hub 6-0:1.0: usb_probe_interface
hub 6-0:1.0: usb_probe_interface - got id
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
hub 6-0:1.0: standalone hub
hub 6-0:1.0: no power switching (usb 1.0)
hub 6-0:1.0: individual port over-current protection
hub 6-0:1.0: power on to power good time: 2ms
hub 6-0:1.0: local power source is good
hub 6-0:1.0: trying to enable port power on non-switchable hub
/usr/src/linux-2.6.29.1/drivers/usb/core/inode.c: creating file '001'
ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.0
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
/usr/src/linux-2.6.29.1/drivers/usb/core/inode.c: creating file '007'
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
uhci_hcd 0000:00:1d.1: detected 2 ports
uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1d.1: Performing full reset
uhci_hcd 0000:00:1d.1: supports USB remote wakeup
uhci_hcd 0000:00:1d.1: irq 19, io base 0x000018c0
usb usb7: default language 0x0409
usb usb7: udev 1, busnum 7, minor = 768
usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb7: Product: UHCI Host Controller
usb usb7: Manufacturer: Linux 2.6.35-rc4-git5 uhci_hcd
usb usb7: SerialNumber: 0000:00:1d.1
usb usb7: usb_probe_device
usb usb7: configuration #1 chosen from 1 choice
usb usb7: adding 7-0:1.0 (config #1, interface 0)
 sda:
hub 7-0:1.0: usb_probe_interface
hub 7-0:1.0: usb_probe_interface - got id
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 2 ports detected
hub 7-0:1.0: standalone hub
hub 7-0:1.0: no power switching (usb 1.0)
hub 7-0:1.0: individual port over-current protection
hub 7-0:1.0: power on to power good time: 2ms
hub 7-0:1.0: local power source is good
hub 7-0:1.0: trying to enable port power on non-switchable hub
/usr/src/linux-2.6.29.1/drivers/usb/core/inode.c: creating file '001'
ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.1
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
/usr/src/linux-2.6.29.1/drivers/usb/core/inode.c: creating file '008'
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
uhci_hcd 0000:00:1d.2: detected 2 ports
uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1d.2: Performing full reset
uhci_hcd 0000:00:1d.2: supports USB remote wakeup
uhci_hcd 0000:00:1d.2: irq 18, io base 0x000018e0
usb usb8: default language 0x0409
usb usb8: udev 1, busnum 8, minor = 896
usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb8: Product: UHCI Host Controller
hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0000
usb usb8: Manufacturer: Linux 2.6.35-rc4-git5 uhci_hcd
usb usb8: SerialNumber: 0000:00:1d.2
usb usb8: usb_probe_device
usb usb8: configuration #1 chosen from 1 choice
usb usb8: adding 8-0:1.0 (config #1, interface 0)
hub 8-0:1.0: usb_probe_interface
hub 8-0:1.0: usb_probe_interface - got id
hub 8-0:1.0: USB hub found
hub 8-0:1.0: 2 ports detected
hub 8-0:1.0: standalone hub
hub 8-0:1.0: no power switching (usb 1.0)
hub 8-0:1.0: individual port over-current protection
hub 8-0:1.0: power on to power good time: 2ms
hub 8-0:1.0: local power source is good
hub 8-0:1.0: trying to enable port power on non-switchable hub
/usr/src/linux-2.6.29.1/drivers/usb/core/inode.c: creating file '001'
ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.2
usbcore: registered new interface driver usblp
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usbcore: registered new interface driver libusual
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
i8042.c: Detected active multiplexing controller, rev 1.1.
hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX0 port at 0x60,0x64 irq 12
serio: i8042 AUX1 port at 0x60,0x64 irq 12
serio: i8042 AUX2 port at 0x60,0x64 irq 12
serio: i8042 AUX3 port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
rtc_cmos 00:06: RTC can wake from S4
rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
i2c /dev entries driver
i801_smbus 0000:00:1f.3: PCI INT C -> GSI 19 (level, low) -> IRQ 19
ACPI: resource 0000:00:1f.3 [io  0x1c20-0x1c3f] conflicts with ACPI region SMBI [io  0x1c20-0x1c2f disabled]
ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
uhci_hcd 0000:00:1a.1: port 1 portsc 0082,00
uhci_hcd 0000:00:1a.1: port 2 portsc 008a,00
IR NEC protocol handler initialized
IR RC5(x) protocol handler initialized
IR RC6 protocol handler initialized
IR JVC protocol handler initialized
IR Sony protocol handler initialized
Linux video capture interface: v2.00
sn9c102: V4L2 driver for SN9C1xx PC Camera Controllers v1:1.47pre49
usbcore: registered new interface driver sn9c102
gspca: main v2.9.0 registered
uhci_hcd 0000:00:1a.2: port 1 portsc 0082,00
usbcore: registered new interface driver spca508
spca508: registered
usbcore: registered new interface driver spca561
spca561: registered
usbcore: registered new interface driver uvcvideo
USB Video Class driver (v0.1.0)
md: raid0 personality registered for level 0
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input6
md: raid1 personality registered for level 1
device-mapper: ioctl: 4.17.0-ioctl (2010-03-05) initialised: dm-devel@redhat.com
cpuidle: using governor ladder
cpuidle: using governor menu
No iBFT detected.
hub 1-0:1.0: state 7 ports 6 chg 0018 evt 0000
hub 1-0:1.0: port 3, status 0501, change 0000, 480 Mb/s
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
fujitsu-laptop: driver 0.6.0 successfully loaded.
HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
HDA Intel 0000:00:1b.0: irq 47 for MSI/MSI-X
HDA Intel 0000:00:1b.0: setting latency timer to 64
hda_codec: ALC888: SKU not ready 0x598301f0
hda_codec: ALC888: BIOS auto-probing.
ALSA device list:
  #0: HDA Intel at 0xf3820000 irq 47
Netfilter messages via NETLINK v0.30.
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
ctnetlink v0.93: registering with nfnetlink.
ip_tables: (C) 2000-2006 Netfilter Core Team
TCP cubic registered
NET: Registered protocol family 17
lib80211: common routines for IEEE802.11 drivers
lib80211_crypt: registered algorithm 'NULL'
PM: Resume from disk failed.
  Magic number: 2:617:843
ehci_hcd 0000:00:1a.7: port 3 high speed
ehci_hcd 0000:00:1a.7: GetStatus port 3 status 001005 POWER sig=se0 PE CONNECT
usb 1-3: new high speed USB device using ehci_hcd and address 2
ehci_hcd 0000:00:1a.7: port 3 high speed
ehci_hcd 0000:00:1a.7: GetStatus port 3 status 001005 POWER sig=se0 PE CONNECT
usb 1-3: default language 0x0409
usb 1-3: udev 2, busnum 1, minor = 1
usb 1-3: New USB device found, idVendor=0bda, idProduct=0167
firewire_core: created device fw0: GUID 0040ca01470026ef, S400
usb 1-3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-3: Product: USB2.0-CRW
usb 1-3: Manufacturer: Generic
usb 1-3: SerialNumber: 20070818000000000
usb 1-3: usb_probe_device
usb 1-3: configuration #1 chosen from 1 choice
usb 1-3: adding 1-3:1.0 (config #1, interface 0)
usb-storage 1-3:1.0: usb_probe_interface
usb-storage 1-3:1.0: usb_probe_interface - got id
scsi6 : usb-storage 1-3:1.0
/usr/src/linux-2.6.29.1/drivers/usb/core/inode.c: creating file '002'
hub 1-0:1.0: port 4, status 0501, change 0000, 480 Mb/s
ehci_hcd 0000:00:1a.7: port 4 full speed --> companion
ehci_hcd 0000:00:1a.7: GetStatus port 4 status 003801 POWER OWNER sig=j CONNECT
hub 1-0:1.0: port 4 not reset yet, waiting 50ms
ehci_hcd 0000:00:1a.7: GetStatus port 4 status 003002 POWER OWNER sig=se0 CSC
hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0000
hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0000
hub 8-0:1.0: state 7 ports 2 chg 0000 evt 0000
hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
hub 1-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0004
uhci_hcd 0000:00:1a.1: port 2 portsc 0093,00
hub 4-0:1.0: port 2, status 0101, change 0001, 12 Mb/s
hub 4-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x101
input: PS/2 Mouse as /devices/platform/i8042/serio4/input/input7
input: AlpsPS/2 ALPS GlidePoint as /devices/platform/i8042/serio4/input/input8
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
usb 4-2: new full speed USB device using uhci_hcd and address 2
ata2.00: ATA-8: FUJITSU MHZ2320BH G2, 00000009, max UDMA/100
ata2.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
ata2.00: configured for UDMA/100
scsi 1:0:0:0: Direct-Access     ATA      FUJITSU MHZ2320B 0000 PQ: 0 ANSI: 5
sd 1:0:0:0: Attached scsi generic sg1 type 0
sd 1:0:0:0: [sdb] 625142448 512-byte logical blocks: (320 GB/298 GiB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sdb1 sdb2 sdb3 sdb4 < sdb5
usb 4-2: ep0 maxpacket = 16
 sdb6
usb 4-2: uhci_result_common: failed with status 440000
 sdb7 sdb8 sdb9 sda1 sda2 < sdb10 >
sd 1:0:0:0: [sdb] Attached SCSI disk
 sda5 sda6 >
sd 0:0:0:0: [sda] Attached SCSI disk
usb usb3: suspend_rh (auto-stop)
usb usb6: suspend_rh (auto-stop)
usb 4-2: uhci_result_common: failed with status 440000
usb 4-2: uhci_result_common: failed with status 440000
usb 4-2: default language 0x0409
usb 4-2: udev 2, busnum 4, minor = 385
usb 4-2: New USB device found, idVendor=1934, idProduct=0702
usb 4-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 4-2: Product: eHome Infrared Transceiver
usb 4-2: Manufacturer: FINTEK
usb 4-2: SerialNumber: 88636562727801
usb 4-2: usb_probe_device
usb 4-2: configuration #1 chosen from 1 choice
usb 4-2: adding 4-2:1.0 (config #1, interface 0)
/usr/src/linux-2.6.29.1/drivers/usb/core/inode.c: creating file '002'
hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0004
usb usb7: suspend_rh (auto-stop)
usb usb5: suspend_rh (auto-stop)
usb usb8: suspend_rh (auto-stop)
scsi 6:0:0:0: Direct-Access     Generic- Multi-Card       1.00 PQ: 0 ANSI: 0 CCS
sd 6:0:0:0: Attached scsi generic sg2 type 0
sd 6:0:0:0: [sdc] Attached SCSI removable disk
ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata5.00: ATAPI: HL-DT-ST BDDVDRW CT10N, WK03, max UDMA/133
ata5.00: configured for UDMA/133
scsi 4:0:0:0: CD-ROM            HL-DT-ST BDDVDRW CT10N    WK03 PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 4:0:0:0: Attached scsi CD-ROM sr0
sr 4:0:0:0: Attached scsi generic sg3 type 5
ata6: SATA link down (SStatus 0 SControl 300)
md: Waiting for all devices to be available before autodetect
md: If you don't use raid, use raid=noautodetect
md: Autodetecting RAID arrays.
md: Scanned 0 and added 0 devices.
md: autorun ...
md: ... autorun DONE.
EXT3-fs: barriers not enabled
kjournald starting.  Commit interval 5 seconds
EXT3-fs (sdb2): mounted filesystem with writeback data mode
VFS: Mounted root (ext3 filesystem) readonly on device 8:18.
Freeing unused kernel memory: 484k freed
hub 2-0:1.0: hub_suspend
usb usb2: bus auto-suspend
ehci_hcd 0000:00:1d.7: suspend root hub
hub 3-0:1.0: hub_suspend
usb usb3: bus auto-suspend
usb usb3: suspend_rh
hub 6-0:1.0: hub_suspend
usb usb6: bus auto-suspend
usb usb6: suspend_rh
hub 7-0:1.0: hub_suspend
usb usb7: bus auto-suspend
usb usb7: suspend_rh
hub 8-0:1.0: hub_suspend
usb usb8: bus auto-suspend
usb usb8: suspend_rh
hub 5-0:1.0: hub_suspend
usb usb5: bus auto-suspend
usb usb5: suspend_rh
iwlagn 0000:04:00.0: loaded firmware version 8.24.2.12
phy0: Selected rate control algorithm 'iwl-agn-rs'
Adding 1951860k swap on /dev/sdb1.  Priority:-1 extents:1 across:1951860k 
EXT3-fs (sdb2): using internal journal
EXT3-fs: barriers not enabled
kjournald starting.  Commit interval 5 seconds
EXT3-fs (sdb9): using internal journal
EXT3-fs (sdb9): mounted filesystem with writeback data mode
EXT3-fs: barriers not enabled
kjournald starting.  Commit interval 5 seconds
EXT3-fs (sdb5): using internal journal
EXT3-fs (sdb5): mounted filesystem with writeback data mode
EXT3-fs: barriers not enabled
kjournald starting.  Commit interval 5 seconds
EXT3-fs (sdb6): using internal journal
EXT3-fs (sdb6): mounted filesystem with writeback data mode
EXT3-fs: barriers not enabled
kjournald starting.  Commit interval 5 seconds
EXT3-fs (sdb7): using internal journal
EXT3-fs (sdb7): mounted filesystem with writeback data mode
EXT3-fs: barriers not enabled
kjournald starting.  Commit interval 5 seconds
EXT3-fs (sdb8): using internal journal
EXT3-fs (sdb8): mounted filesystem with writeback data mode
EXT3-fs: barriers not enabled
kjournald starting.  Commit interval 5 seconds
EXT3-fs (sdb10): using internal journal
EXT3-fs (sdb10): mounted filesystem with writeback data mode
e1000e 0000:00:19.0: irq 45 for MSI/MSI-X
e1000e 0000:00:19.0: irq 45 for MSI/MSI-X
wlan0: authenticate with 00:1d:6a:57:d3:5e (try 1)
wlan0: authenticated
wlan0: associate with 00:1d:6a:57:d3:5e (try 1)
wlan0: RX AssocResp from 00:1d:6a:57:d3:5e (capab=0x431 status=0 aid=1)
wlan0: associated
cfg80211: Calling CRDA for country: FR
vgaarb: device changed decodes: PCI:0000:01:00.0,olddecodes=io+mem,decodes=none:owns=none
vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=none:owns=io+mem
iwlagn 0000:04:00.0: Fail finding valid aggregation tid: 0
CPUFREQ: Per core ondemand sysfs interface is deprecated - up_threshold
ata1.00: configured for UDMA/100
ata1: EH complete
ata2.00: configured for UDMA/100
ata2: EH complete
iwlagn 0000:04:00.0: Fail finding valid aggregation tid: 0
iwlagn 0000:04:00.0: Fail finding valid aggregation tid: 0
iwlagn 0000:04:00.0: Fail finding valid aggregation tid: 0
iwlagn 0000:04:00.0: Fail finding valid aggregation tid: 0
iwlagn 0000:04:00.0: iwlagn_tx_agg_start on ra = 00:1d:6a:57:d3:5e tid = 0

--------------060705070103020507050604
Content-Type: text/x-dsl;
 name="DSDT.dsl"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="DSDT.dsl"

/*
 * Intel ACPI Component Architecture
 * AML Disassembler version 20061109
 *
 * Disassembly of DSDT.dat, Mon Apr 27 20:09:51 2009
 *
 *
 * Original Table Header:
 *     Signature        "DSDT"
 *     Length           0x00008083 (32899)
 *     Revision         0x02
 *     OEM ID           "FIC   "
 *     OEM Table ID     "XY680   "
 *     OEM Revision     0x06040000 (100925440)
 *     Creator ID       "INTL"
 *     Creator Revision 0x20050624 (537200164)
 */
DefinitionBlock ("DSDT.aml", "DSDT", 2, "FIC   ", "XY680   ", 0x06040000)
{
    External (PDC1)
    External (PDC0)
    External (CFGD)
    External (\_PR_.CPU0._PPC)
    External (\_SB_.PCI0.TMEM.GPEH, MethodObj)    // 0 Arguments

    Name (SP2O, 0x4E)
    Name (SP1O, 0x164E)
    Name (IO1B, 0x0600)
    Name (IO1L, 0x70)
    Name (IO2B, 0x06B0)
    Name (IO2L, 0x20)
    Name (IO3B, 0x0290)
    Name (IO3L, 0x10)
    Name (MCHB, 0xFED10000)
    Name (MCHL, 0x4000)
    Name (EGPB, 0xFED19000)
    Name (EGPL, 0x1000)
    Name (DMIB, 0xFED18000)
    Name (DMIL, 0x1000)
    Name (IFPB, 0xFED13000)
    Name (IFPL, 0x1000)
    Name (PEBS, 0xE0000000)
    Name (PELN, 0x10000000)
    Name (TTTB, 0xFED20000)
    Name (TTTL, 0x00020000)
    Name (SMBS, 0x18C0)
    Name (PBLK, 0x0410)
    Name (PMBS, 0x0400)
    Name (PMLN, 0x80)
    Name (LVL2, 0x0414)
    Name (LVL3, 0x0415)
    Name (LVL4, 0x0416)
    Name (SMIP, 0xB2)
    Name (GPBS, 0x1180)
    Name (GPLN, 0x80)
    Name (APCB, 0xFEC00000)
    Name (APCL, 0x1000)
    Name (PM30, 0x0430)
    Name (SRCB, 0xFED1C000)
    Name (SRCL, 0x4000)
    Name (SUSW, 0xFF)
    Name (ACPH, 0xDE)
    Name (ASSB, Zero)
    Name (AOTB, Zero)
    Name (AAXB, Zero)
    Name (PEHP, One)
    Name (SHPC, One)
    Name (PEPM, One)
    Name (PEER, One)
    Name (PECS, One)
    Name (ITKE, Zero)
    Name (TRTP, One)
    Name (TRTD, 0x02)
    Name (TRTI, 0x03)
    Name (GCDD, One)
    Name (DSTA, 0x0A)
    Name (DSLO, 0x0C)
    Name (DSLC, 0x0E)
    Name (PITS, 0x10)
    Name (SBCS, 0x12)
    Name (SALS, 0x13)
    Name (LSSS, 0x2A)
    Name (PSSS, 0x2B)
    Name (SOOT, 0x35)
    Name (ESCS, 0x48)
    Name (PDBR, 0x4D)
    Name (SMBL, 0x10)
    OperationRegion (GNVS, SystemMemory, 0xBDB8EDBC, 0x0100)
    Field (GNVS, AnyAcc, Lock, Preserve)
    {
        OSYS,   16, 
        SMIF,   8, 
        PRM0,   8, 
        PRM1,   8, 
        SCIF,   8, 
        PRM2,   8, 
        PRM3,   8, 
        LCKF,   8, 
        PRM4,   8, 
        PRM5,   8, 
        P80D,   32, 
        LIDS,   8, 
        PWRS,   8, 
        DBGS,   8, 
        THOF,   8, 
        ACT1,   8, 
        ACTT,   8, 
        PSVT,   8, 
        TC1V,   8, 
        TC2V,   8, 
        TSPV,   8, 
        CRTT,   8, 
        DTSE,   8, 
        DTS1,   8, 
        DTS2,   8, 
        DTSF,   8, 
                Offset (0x28), 
        APIC,   8, 
        MPEN,   8, 
        PCP0,   8, 
        PCP1,   8, 
        PPCM,   8, 
        PPMF,   32, 
                Offset (0x3C), 
        IGDS,   8, 
        TLST,   8, 
        CADL,   8, 
        PADL,   8, 
        CSTE,   16, 
        NSTE,   16, 
        SSTE,   16, 
        NDID,   8, 
        DID1,   32, 
        DID2,   32, 
        DID3,   32, 
        DID4,   32, 
        DID5,   32, 
        KSV0,   32, 
        KSV1,   8, 
        BDSP,   8, 
        PTY1,   8, 
        PTY2,   8, 
        PSCL,   8, 
        TVF1,   8, 
        TVF2,   8, 
        GETM,   8, 
        BLCS,   8, 
        BRTL,   8, 
        ALSE,   8, 
        ALAF,   8, 
        LLOW,   8, 
        LHIH,   8, 
                Offset (0x6E), 
        EMAE,   8, 
        EMAP,   16, 
        EMAL,   16, 
                Offset (0x74), 
        MEFE,   8, 
        DSTS,   8, 
                Offset (0x78), 
        TPMP,   8, 
        TPME,   8, 
                Offset (0x82), 
        GTF0,   56, 
        GTF2,   56, 
        IDEM,   8, 
        GTF1,   56, 
        BID,    8, 
                Offset (0xAA), 
        ASLB,   32, 
        IBTT,   8, 
        IPAT,   8, 
        ITVF,   8, 
        ITVM,   8, 
        IPSC,   8, 
        IBLC,   8, 
        IBIA,   8, 
        ISSC,   8, 
        I409,   8, 
        I509,   8, 
        I609,   8, 
        I709,   8, 
        IDMM,   8, 
        IDMS,   8, 
        IF1E,   8, 
        HVCO,   8, 
        NXD1,   32, 
        NXD2,   32, 
        NXD3,   32, 
        NXD4,   32, 
        NXD5,   32, 
        NXD6,   32, 
        NXD7,   32, 
        NXD8,   32, 
        GSMI,   8, 
        PAVP,   8, 
                Offset (0xEB), 
        DSEN,   8, 
        ECON,   8, 
        GPIC,   8, 
        CTYP,   8, 
        L01C,   8, 
        VFN0,   8, 
        VFN1,   8, 
                Offset (0xFE), 
        NVEN,   8, 
        HBEN,   8
    }

    Name (SPDF, Zero)
    Name (MMBE, Zero)
    Name (INIF, Zero)
    Name (DVSV, Buffer (0x44) {})
    CreateDWordField (DVSV, Zero, DB00)
    CreateDWordField (DVSV, 0x04, DB04)
    CreateDWordField (DVSV, 0x08, DB08)
    CreateDWordField (DVSV, 0x0C, DB0C)
    CreateDWordField (DVSV, 0x10, DB10)
    CreateDWordField (DVSV, 0x14, DB14)
    CreateDWordField (DVSV, 0x18, DB18)
    CreateDWordField (DVSV, 0x1C, DB1C)
    CreateDWordField (DVSV, 0x20, DB20)
    CreateDWordField (DVSV, 0x24, DB24)
    CreateDWordField (DVSV, 0x28, DB28)
    CreateDWordField (DVSV, 0x2C, DB2C)
    CreateDWordField (DVSV, 0x30, DB30)
    CreateDWordField (DVSV, 0x34, DB34)
    CreateDWordField (DVSV, 0x38, DB38)
    CreateDWordField (DVSV, 0x3C, DB3C)
    CreateDWordField (DVSV, 0x40, DB40)
    Scope (_SB)
    {
        Mutex (PSMX, 0x00)
        Device (ACAD)
        {
            Name (_HID, "ACPI0003")
            Name (_PCL, Package (0x01)
            {
                _SB
            })
            Name (ACFG, Zero)
            Method (_PSR, 0, NotSerialized)
            {
                Acquire (PSMX, 0xFFFF)
                And (One, ^^PCI0.LPCB.PMRD (0xA0), Local0)
                Store (Local0, ACFG)
                Release (PSMX)
                Return (ACFG)
            }

            Method (_STA, 0, NotSerialized)
            {
                Return (0x0F)
            }
        }

        Device (BAT0)
        {
            Name (_HID, EisaId ("PNP0C0A"))
            Name (_UID, One)
            Method (_STA, 0, NotSerialized)
            {
                Acquire (PSMX, 0xFFFF)
                And (^^PCI0.LPCB.PMRD (0xA1), One, Local0)
                Store (Local0, FSTA)
                Release (PSMX)
                If (LEqual (Local0, Zero))
                {
                    Return (0x0F)
                }
                Else
                {
                    Return (0x1F)
                }
            }

            Method (_BIF, 0, NotSerialized)
            {
                And (^^PCI0.LPCB.PMRD (0xA1), One, Local0)
                If (Local0)
                {
                    UPBI ()
                }
                Else
                {
                    IVBI ()
                    IVBS ()
                }

                Store (Zero, FBIF)
                Return (PBIF)
            }

            Method (_BST, 0, NotSerialized)
            {
                UPBS ()
                Return (PBST)
            }

            Method (IVBI, 0, NotSerialized)
            {
                Store (0xFFFFFFFF, Index (PBIF, One))
                Store (0xFFFFFFFF, Index (PBIF, 0x02))
                Store (0xFFFFFFFF, Index (PBIF, 0x04))
                Store ("Bad", Index (PBIF, 0x09))
                Store ("Bad", Index (PBIF, 0x0A))
                Store ("Bad", Index (PBIF, 0x0B))
                Store ("Bad", Index (PBIF, 0x0C))
                Store (One, FBIF)
            }

            Method (IVBS, 0, NotSerialized)
            {
                Store (Zero, Index (PBST, Zero))
                Store (0xFFFFFFFF, Index (PBST, One))
                Store (0xFFFFFFFF, Index (PBST, 0x02))
                Store (0xFFFFFFFF, Index (PBST, 0x03))
                Store (One, FSTA)
            }

            Method (UPBI, 0, NotSerialized)
            {
                Acquire (PSMX, 0xFFFF)
                Store (^^PCI0.LPCB.PMRD (Zero), Local0)
                Store (^^PCI0.LPCB.PMRD (One), Local1)
                Multiply (Local1, 0x0100, Local2)
                Or (Local0, Local2, Local3)
                Store (Local3, Index (PBIF, Zero))
                Store (^^PCI0.LPCB.PMRD (0x02), Local0)
                Store (^^PCI0.LPCB.PMRD (0x03), Local1)
                Store (^^PCI0.LPCB.PMRD (0x49), Local2)
                Multiply (Local1, 0x0100, Local3)
                Multiply (Local2, 0x00010000, Local4)
                Or (Local3, Local0, Local5)
                Or (Local4, Local5, Local6)
                Store (Local6, Index (PBIF, One))
                Store (^^PCI0.LPCB.PMRD (0x04), Local0)
                Store (^^PCI0.LPCB.PMRD (0x05), Local1)
                Store (^^PCI0.LPCB.PMRD (0x4A), Local2)
                Multiply (Local1, 0x0100, Local3)
                Multiply (Local2, 0x00010000, Local4)
                Or (Local3, Local0, Local5)
                Or (Local4, Local5, Local6)
                Store (Local6, Index (PBIF, 0x02))
                Store (^^PCI0.LPCB.PMRD (0x06), Local0)
                Store (^^PCI0.LPCB.PMRD (0x07), Local1)
                Multiply (Local1, 0x0100, Local2)
                Or (Local2, Local0, Local3)
                Store (Local3, Index (PBIF, 0x03))
                Store (^^PCI0.LPCB.PMRD (0x08), Local0)
                Store (^^PCI0.LPCB.PMRD (0x09), Local1)
                Multiply (Local1, 0x0100, Local2)
                Or (Local2, Local0, Local3)
                Store (Local3, Index (PBIF, 0x04))
                Store (^^PCI0.LPCB.PMRD (0x0A), Local0)
                Store (^^PCI0.LPCB.PMRD (0x0B), Local1)
                Multiply (Local1, 0x0100, Local2)
                Or (Local2, Local0, Local3)
                Store (Local3, Index (PBIF, 0x05))
                Store (Zero, Index (PBIF, 0x06))
                Store (^^PCI0.LPCB.PMRD (0x0E), Local0)
                Store (^^PCI0.LPCB.PMRD (0x0F), Local1)
                Multiply (Local1, 0x0100, Local2)
                Or (Local2, Local0, Local3)
                Store (Local3, Index (PBIF, 0x07))
                Store (^^PCI0.LPCB.PMRD (0x10), Local0)
                Store (^^PCI0.LPCB.PMRD (0x11), Local1)
                Multiply (Local1, 0x0100, Local2)
                Or (Local2, Local0, Local3)
                Store (Local3, Index (PBIF, 0x08))
                Store ("", Index (PBIF, 0x09))
                Store ("", Index (PBIF, 0x0A))
                Store ("Li-ion", Index (PBIF, 0x0B))
                Store (^^PCI0.LPCB.PMRD (0x18), Local0)
                If (LEqual (Local0, Zero))
                {
                    Store ("Moli", Index (PBIF, 0x0A))
                }
                Else
                {
                    If (LEqual (Local0, One))
                    {
                        Store ("Panasonic", Index (PBIF, 0x0A))
                    }
                    Else
                    {
                        If (LEqual (Local0, 0x02))
                        {
                            Store ("Sanyo", Index (PBIF, 0x0A))
                        }
                        Else
                        {
                            If (LEqual (Local0, 0x03))
                            {
                                Store ("Simplo", Index (PBIF, 0x0A))
                            }
                            Else
                            {
                                If (LEqual (Local0, 0x05))
                                {
                                    Store ("Sony", Index (PBIF, 0x0A))
                                }
                                Else
                                {
                                    If (LEqual (Local0, 0x06))
                                    {
                                        Store ("Sole", Index (PBIF, 0x0A))
                                    }
                                    Else
                                    {
                                        If (LEqual (Local0, 0x07))
                                        {
                                            Store ("Celxpert", Index (PBIF, 0x0A))
                                        }
                                        Else
                                        {
                                            If (LEqual (Local0, 0x08))
                                            {
                                                Store ("Dynapack", Index (PBIF, 0x0A))
                                            }
                                            Else
                                            {
                                                If (LEqual (Local0, 0x09))
                                                {
                                                    Store ("Gallopwire", Index (PBIF, 0x0A))
                                                }
                                                Else
                                                {
                                                    Store ("FIC ", Index (PBIF, 0x0C))
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                Release (PSMX)
                Return (PBIF)
            }

            Method (UPBS, 0, NotSerialized)
            {
                Acquire (PSMX, 0xFFFF)
                Store (^^PCI0.LPCB.PMRD (0x1A), Local0)
                Store (^^PCI0.LPCB.PMRD (0x1B), Local1)
                Multiply (Local1, 0x0100, Local2)
                Or (Local2, Local0, Local3)
                Store (Local3, Index (PBST, Zero))
                Store (^^PCI0.LPCB.PMRD (0x1C), Local0)
                Store (^^PCI0.LPCB.PMRD (0x1D), Local1)
                Multiply (Local1, 0x0100, Local2)
                Or (Local2, Local0, Local3)
                Store (Local3, Index (PBST, One))
                Store (^^PCI0.LPCB.PMRD (0x1E), Local0)
                Store (^^PCI0.LPCB.PMRD (0x1F), Local1)
                Store (^^PCI0.LPCB.PMRD (0x4B), Local2)
                Multiply (Local1, 0x0100, Local3)
                Multiply (Local2, 0x00010000, Local4)
                Or (Local3, Local0, Local5)
                Or (Local4, Local5, Local6)
                Store (Local6, Index (PBST, 0x02))
                Store (^^PCI0.LPCB.PMRD (0x20), Local0)
                Store (^^PCI0.LPCB.PMRD (0x21), Local1)
                Multiply (Local1, 0x0100, Local2)
                Or (Local2, Local0, Local3)
                Store (Local3, Index (PBST, 0x03))
                Release (PSMX)
                Return (PBST)
            }

            Method (_BTP, 1, NotSerialized)
            {
                Acquire (PSMX, 0xFFFF)
                Store (^^PCI0.LPCB.PMRD (0xB2), Local0)
                And (Local0, 0x7F, Local0)
                ^^PCI0.LPCB.PMWT (0xB2, Local0)
                Store (Arg0, Local0)
                Store (Local0, Local6)
                And (Local0, 0xFF, Local1)
                ^^PCI0.LPCB.PMWT (0x22, Local1)
                Store (Local6, Local0)
                And (Local0, 0xFF00, Local1)
                ShiftRight (Local1, 0x08, Local2)
                ^^PCI0.LPCB.PMWT (0x23, Local2)
                Store (Local6, Local0)
                And (Local0, 0x00FF0000, Local1)
                ShiftRight (Local1, 0x10, Local2)
                ^^PCI0.LPCB.PMWT (0x4C, Local2)
                Store (^^PCI0.LPCB.PMRD (0xF1), Local3)
                If (And (Local3, 0x80, Local3))
                {
                    Store (^^PCI0.LPCB.PMRD (0xA1), Local4)
                    ^^PCI0.LPCB.PMWT (0xF1, Local4)
                }

                Store (^^PCI0.LPCB.PMRD (0xB2), Local0)
                Or (Local0, 0x80, Local0)
                ^^PCI0.LPCB.PMWT (0xB2, Local0)
                Release (PSMX)
            }

            Name (_PCL, Package (0x01)
            {
                _SB
            })
            Name (FBIF, One)
            Name (FSTA, One)
            Name (GGFG, Zero)
            Name (PBIF, Package (0x0D)
            {
                One, 
                0x78, 
                0x64, 
                One, 
                0x2580, 
                0x05, 
                0x05, 
                One, 
                One, 
                "???", 
                "???", 
                "???", 
                "???"
            })
            Name (PBST, Package (0x04)
            {
                One, 
                0x78, 
                0x64, 
                0x2580
            })
            Name (PSTA, 0x1F)
        }

        Device (LID)
        {
            Name (_HID, EisaId ("PNP0C0D"))
            Name (LIDF, One)
            Method (_LID, 0, NotSerialized)
            {
                Return (LIDF)
            }

            Name (_PRW, Package (0x02)
            {
                0x08, 
                0x03
            })
        }

        Device (PWRB)
        {
            Name (_HID, EisaId ("PNP0C0C"))
        }

        Device (SLPB)
        {
            Name (_HID, EisaId ("PNP0C0E"))
        }

        Name (PR00, Package (0x1B)
        {
            Package (0x04)
            {
                0x0003FFFF, 
                Zero, 
                LNKA, 
                Zero
            }, 

            Package (0x04)
            {
                0x0003FFFF, 
                One, 
                LNKB, 
                Zero
            }, 

            Package (0x04)
            {
                0x0003FFFF, 
                0x02, 
                LNKC, 
                Zero
            }, 

            Package (0x04)
            {
                0x0003FFFF, 
                0x03, 
                LNKD, 
                Zero
            }, 

            Package (0x04)
            {
                0x0001FFFF, 
                Zero, 
                LNKA, 
                Zero
            }, 

            Package (0x04)
            {
                0x0001FFFF, 
                One, 
                LNKB, 
                Zero
            }, 

            Package (0x04)
            {
                0x0001FFFF, 
                0x02, 
                LNKC, 
                Zero
            }, 

            Package (0x04)
            {
                0x0001FFFF, 
                0x03, 
                LNKD, 
                Zero
            }, 

            Package (0x04)
            {
                0x0002FFFF, 
                Zero, 
                LNKA, 
                Zero
            }, 

            Package (0x04)
            {
                0x001FFFFF, 
                Zero, 
                LNKF, 
                Zero
            }, 

            Package (0x04)
            {
                0x001FFFFF, 
                One, 
                LNKD, 
                Zero
            }, 

            Package (0x04)
            {
                0x001FFFFF, 
                0x02, 
                LNKD, 
                Zero
            }, 

            Package (0x04)
            {
                0x001FFFFF, 
                0x03, 
                LNKA, 
                Zero
            }, 

            Package (0x04)
            {
                0x001DFFFF, 
                Zero, 
                LNKH, 
                Zero
            }, 

            Package (0x04)
            {
                0x001DFFFF, 
                One, 
                LNKD, 
                Zero
            }, 

            Package (0x04)
            {
                0x001DFFFF, 
                0x02, 
                LNKC, 
                Zero
            }, 

            Package (0x04)
            {
                0x001DFFFF, 
                0x03, 
                LNKA, 
                Zero
            }, 

            Package (0x04)
            {
                0x001AFFFF, 
                Zero, 
                LNKA, 
                Zero
            }, 

            Package (0x04)
            {
                0x001AFFFF, 
                One, 
                LNKF, 
                Zero
            }, 

            Package (0x04)
            {
                0x001AFFFF, 
                0x02, 
                LNKD, 
                Zero
            }, 

            Package (0x04)
            {
                0x001AFFFF, 
                0x03, 
                LNKC, 
                Zero
            }, 

            Package (0x04)
            {
                0x001BFFFF, 
                Zero, 
                LNKG, 
                Zero
            }, 

            Package (0x04)
            {
                0x001CFFFF, 
                Zero, 
                LNKB, 
                Zero
            }, 

            Package (0x04)
            {
                0x001CFFFF, 
                One, 
                LNKA, 
                Zero
            }, 

            Package (0x04)
            {
                0x001CFFFF, 
                0x02, 
                LNKC, 
                Zero
            }, 

            Package (0x04)
            {
                0x001CFFFF, 
                0x03, 
                LNKD, 
                Zero
            }, 

            Package (0x04)
            {
                0x0019FFFF, 
                Zero, 
                LNKE, 
                Zero
            }
        })
        Name (AR00, Package (0x1B)
        {
            Package (0x04)
            {
                0x0003FFFF, 
                Zero, 
                Zero, 
                0x10
            }, 

            Package (0x04)
            {
                0x0003FFFF, 
                One, 
                Zero, 
                0x11
            }, 

            Package (0x04)
            {
                0x0003FFFF, 
                0x02, 
                Zero, 
                0x12
            }, 

            Package (0x04)
            {
                0x0003FFFF, 
                0x03, 
                Zero, 
                0x13
            }, 

            Package (0x04)
            {
                0x0001FFFF, 
                Zero, 
                Zero, 
                0x10
            }, 

            Package (0x04)
            {
                0x0001FFFF, 
                One, 
                Zero, 
                0x11
            }, 

            Package (0x04)
            {
                0x0001FFFF, 
                0x02, 
                Zero, 
                0x12
            }, 

            Package (0x04)
            {
                0x0001FFFF, 
                0x03, 
                Zero, 
                0x13
            }, 

            Package (0x04)
            {
                0x0002FFFF, 
                Zero, 
                Zero, 
                0x10
            }, 

            Package (0x04)
            {
                0x001FFFFF, 
                Zero, 
                Zero, 
                0x15
            }, 

            Package (0x04)
            {
                0x001FFFFF, 
                One, 
                Zero, 
                0x13
            }, 

            Package (0x04)
            {
                0x001FFFFF, 
                0x02, 
                Zero, 
                0x13
            }, 

            Package (0x04)
            {
                0x001FFFFF, 
                0x03, 
                Zero, 
                0x10
            }, 

            Package (0x04)
            {
                0x001DFFFF, 
                Zero, 
                Zero, 
                0x17
            }, 

            Package (0x04)
            {
                0x001DFFFF, 
                One, 
                Zero, 
                0x13
            }, 

            Package (0x04)
            {
                0x001DFFFF, 
                0x02, 
                Zero, 
                0x12
            }, 

            Package (0x04)
            {
                0x001DFFFF, 
                0x03, 
                Zero, 
                0x10
            }, 

            Package (0x04)
            {
                0x001AFFFF, 
                Zero, 
                Zero, 
                0x10
            }, 

            Package (0x04)
            {
                0x001AFFFF, 
                One, 
                Zero, 
                0x15
            }, 

            Package (0x04)
            {
                0x001AFFFF, 
                0x02, 
                Zero, 
                0x13
            }, 

            Package (0x04)
            {
                0x001AFFFF, 
                0x03, 
                Zero, 
                0x12
            }, 

            Package (0x04)
            {
                0x001BFFFF, 
                Zero, 
                Zero, 
                0x16
            }, 

            Package (0x04)
            {
                0x001CFFFF, 
                Zero, 
                Zero, 
                0x11
            }, 

            Package (0x04)
            {
                0x001CFFFF, 
                One, 
                Zero, 
                0x10
            }, 

            Package (0x04)
            {
                0x001CFFFF, 
                0x02, 
                Zero, 
                0x12
            }, 

            Package (0x04)
            {
                0x001CFFFF, 
                0x03, 
                Zero, 
                0x13
            }, 

            Package (0x04)
            {
                0x0019FFFF, 
                Zero, 
                Zero, 
                0x14
            }
        })
        Name (PR02, Package (0x04)
        {
            Package (0x04)
            {
                0xFFFF, 
                Zero, 
                LNKA, 
                Zero
            }, 

            Package (0x04)
            {
                0xFFFF, 
                One, 
                LNKB, 
                Zero
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                LNKC, 
                Zero
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                LNKD, 
                Zero
            }
        })
        Name (AR02, Package (0x04)
        {
            Package (0x04)
            {
                0xFFFF, 
                Zero, 
                Zero, 
                0x10
            }, 

            Package (0x04)
            {
                0xFFFF, 
                One, 
                Zero, 
                0x11
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                Zero, 
                0x12
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                Zero, 
                0x13
            }
        })
        Name (PR04, Package (0x04)
        {
            Package (0x04)
            {
                0xFFFF, 
                Zero, 
                LNKA, 
                Zero
            }, 

            Package (0x04)
            {
                0xFFFF, 
                One, 
                LNKB, 
                Zero
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                LNKC, 
                Zero
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                LNKD, 
                Zero
            }
        })
        Name (AR04, Package (0x04)
        {
            Package (0x04)
            {
                0xFFFF, 
                Zero, 
                Zero, 
                0x10
            }, 

            Package (0x04)
            {
                0xFFFF, 
                One, 
                Zero, 
                0x11
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                Zero, 
                0x12
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                Zero, 
                0x13
            }
        })
        Name (PR05, Package (0x04)
        {
            Package (0x04)
            {
                0xFFFF, 
                Zero, 
                LNKB, 
                Zero
            }, 

            Package (0x04)
            {
                0xFFFF, 
                One, 
                LNKC, 
                Zero
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                LNKD, 
                Zero
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                LNKA, 
                Zero
            }
        })
        Name (AR05, Package (0x04)
        {
            Package (0x04)
            {
                0xFFFF, 
                Zero, 
                Zero, 
                0x11
            }, 

            Package (0x04)
            {
                0xFFFF, 
                One, 
                Zero, 
                0x12
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                Zero, 
                0x13
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                Zero, 
                0x10
            }
        })
        Name (PR06, Package (0x04)
        {
            Package (0x04)
            {
                0xFFFF, 
                Zero, 
                LNKD, 
                Zero
            }, 

            Package (0x04)
            {
                0xFFFF, 
                One, 
                LNKA, 
                Zero
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                LNKB, 
                Zero
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                LNKC, 
                Zero
            }
        })
        Name (AR06, Package (0x04)
        {
            Package (0x04)
            {
                0xFFFF, 
                Zero, 
                Zero, 
                0x12
            }, 

            Package (0x04)
            {
                0xFFFF, 
                One, 
                Zero, 
                0x13
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                Zero, 
                0x10
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                Zero, 
                0x11
            }
        })
        Name (PR07, Package (0x04)
        {
            Package (0x04)
            {
                0xFFFF, 
                Zero, 
                LNKA, 
                Zero
            }, 

            Package (0x04)
            {
                0xFFFF, 
                One, 
                LNKB, 
                Zero
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                LNKC, 
                Zero
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                LNKD, 
                Zero
            }
        })
        Name (AR07, Package (0x04)
        {
            Package (0x04)
            {
                0xFFFF, 
                Zero, 
                Zero, 
                0x13
            }, 

            Package (0x04)
            {
                0xFFFF, 
                One, 
                Zero, 
                0x10
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                Zero, 
                0x11
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                Zero, 
                0x12
            }
        })
        Name (PR08, Package (0x04)
        {
            Package (0x04)
            {
                0xFFFF, 
                Zero, 
                LNKB, 
                Zero
            }, 

            Package (0x04)
            {
                0xFFFF, 
                One, 
                LNKC, 
                Zero
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                LNKD, 
                Zero
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                LNKA, 
                Zero
            }
        })
        Name (AR08, Package (0x04)
        {
            Package (0x04)
            {
                0xFFFF, 
                Zero, 
                Zero, 
                0x10
            }, 

            Package (0x04)
            {
                0xFFFF, 
                One, 
                Zero, 
                0x11
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                Zero, 
                0x12
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                Zero, 
                0x13
            }
        })
        Name (PR01, Package (0x14)
        {
            Package (0x04)
            {
                0x0003FFFF, 
                Zero, 
                LNKD, 
                Zero
            }, 

            Package (0x04)
            {
                0x0003FFFF, 
                One, 
                LNKC, 
                Zero
            }, 

            Package (0x04)
            {
                0x0003FFFF, 
                0x02, 
                LNKF, 
                Zero
            }, 

            Package (0x04)
            {
                0x0003FFFF, 
                0x03, 
                LNKG, 
                Zero
            }, 

            Package (0x04)
            {
                0x0002FFFF, 
                Zero, 
                LNKC, 
                Zero
            }, 

            Package (0x04)
            {
                0x0002FFFF, 
                One, 
                LNKD, 
                Zero
            }, 

            Package (0x04)
            {
                0x0002FFFF, 
                0x02, 
                LNKB, 
                Zero
            }, 

            Package (0x04)
            {
                0x0002FFFF, 
                0x03, 
                LNKA, 
                Zero
            }, 

            Package (0x04)
            {
                0xFFFF, 
                Zero, 
                LNKF, 
                Zero
            }, 

            Package (0x04)
            {
                0xFFFF, 
                One, 
                LNKG, 
                Zero
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                LNKH, 
                Zero
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                LNKE, 
                Zero
            }, 

            Package (0x04)
            {
                0x0001FFFF, 
                Zero, 
                LNKG, 
                Zero
            }, 

            Package (0x04)
            {
                0x0001FFFF, 
                One, 
                LNKF, 
                Zero
            }, 

            Package (0x04)
            {
                0x0001FFFF, 
                0x02, 
                LNKE, 
                Zero
            }, 

            Package (0x04)
            {
                0x0001FFFF, 
                0x03, 
                LNKH, 
                Zero
            }, 

            Package (0x04)
            {
                0x0005FFFF, 
                Zero, 
                LNKB, 
                Zero
            }, 

            Package (0x04)
            {
                0x0005FFFF, 
                One, 
                LNKE, 
                Zero
            }, 

            Package (0x04)
            {
                0x0005FFFF, 
                0x02, 
                LNKG, 
                Zero
            }, 

            Package (0x04)
            {
                0x0005FFFF, 
                0x03, 
                LNKF, 
                Zero
            }
        })
        Name (AR01, Package (0x11)
        {
            Package (0x04)
            {
                0x0004FFFF, 
                Zero, 
                Zero, 
                0x10
            }, 

            Package (0x04)
            {
                0x0002FFFF, 
                Zero, 
                Zero, 
                0x12
            }, 

            Package (0x04)
            {
                0x0002FFFF, 
                One, 
                Zero, 
                0x13
            }, 

            Package (0x04)
            {
                0x0002FFFF, 
                0x02, 
                Zero, 
                0x11
            }, 

            Package (0x04)
            {
                0x0002FFFF, 
                0x03, 
                Zero, 
                0x10
            }, 

            Package (0x04)
            {
                0xFFFF, 
                Zero, 
                Zero, 
                0x15
            }, 

            Package (0x04)
            {
                0xFFFF, 
                One, 
                Zero, 
                0x16
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                Zero, 
                0x17
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                Zero, 
                0x14
            }, 

            Package (0x04)
            {
                0x0001FFFF, 
                Zero, 
                Zero, 
                0x16
            }, 

            Package (0x04)
            {
                0x0001FFFF, 
                One, 
                Zero, 
                0x15
            }, 

            Package (0x04)
            {
                0x0001FFFF, 
                0x02, 
                Zero, 
                0x14
            }, 

            Package (0x04)
            {
                0x0001FFFF, 
                0x03, 
                Zero, 
                0x17
            }, 

            Package (0x04)
            {
                0x0005FFFF, 
                Zero, 
                Zero, 
                0x11
            }, 

            Package (0x04)
            {
                0x0005FFFF, 
                One, 
                Zero, 
                0x14
            }, 

            Package (0x04)
            {
                0x0005FFFF, 
                0x02, 
                Zero, 
                0x16
            }, 

            Package (0x04)
            {
                0x0005FFFF, 
                0x03, 
                Zero, 
                0x15
            }
        })
        Name (PRSA, ResourceTemplate ()
        {
            IRQ (Level, ActiveLow, Shared, )
                {3,4,5,6,7,10,11,12,14,15}
        })
        Alias (PRSA, PRSB)
        Alias (PRSA, PRSC)
        Alias (PRSA, PRSD)
        Alias (PRSA, PRSE)
        Alias (PRSA, PRSF)
        Alias (PRSA, PRSG)
        Alias (PRSA, PRSH)
        Device (PCI0)
        {
            Name (_HID, EisaId ("PNP0A08"))
            Name (_CID, 0x030AD041)
            Name (_ADR, Zero)
            Method (^BN00, 0, NotSerialized)
            {
                Return (Zero)
            }

            Method (_BBN, 0, NotSerialized)
            {
                Return (BN00 ())
            }

            Name (_UID, Zero)
            Method (_PRT, 0, NotSerialized)
            {
                If (PICM)
                {
                    Return (AR00)
                }

                Return (PR00)
            }

            OperationRegion (ROM1, SystemMemory, 0xBDB8EFBC, 0x00010000)
            Field (ROM1, AnyAcc, Lock, Preserve)
            {
                VBF1,   262144, 
                VBF2,   262144
            }

            Method (GETB, 3, Serialized)
            {
                Multiply (Arg0, 0x08, Local0)
                Multiply (Arg1, 0x08, Local1)
                CreateField (Arg2, Local0, Local1, TBF3)
                Sleep (0xA0)
                Return (TBF3)
            }

            OperationRegion (HBUS, PCI_Config, 0x40, 0xC0)
            Field (HBUS, DWordAcc, NoLock, Preserve)
            {
                EPEN,   1, 
                    ,   11, 
                EPBR,   20, 
                        Offset (0x08), 
                MHEN,   1, 
                    ,   13, 
                MHBR,   18, 
                        Offset (0x14), 
                    ,   1, 
                D1EN,   1, 
                    ,   1, 
                D2F0,   1, 
                D2F1,   1, 
                        Offset (0x20), 
                PXEN,   1, 
                PXSZ,   2, 
                    ,   23, 
                PXBR,   6, 
                        Offset (0x28), 
                DIEN,   1, 
                    ,   11, 
                DIBR,   20, 
                        Offset (0x30), 
                IPEN,   1, 
                    ,   11, 
                IPBR,   20, 
                        Offset (0x50), 
                    ,   4, 
                PM0H,   2, 
                        Offset (0x51), 
                PM1L,   2, 
                    ,   2, 
                PM1H,   2, 
                        Offset (0x52), 
                PM2L,   2, 
                    ,   2, 
                PM2H,   2, 
                        Offset (0x53), 
                PM3L,   2, 
                    ,   2, 
                PM3H,   2, 
                        Offset (0x54), 
                PM4L,   2, 
                    ,   2, 
                PM4H,   2, 
                        Offset (0x55), 
                PM5L,   2, 
                    ,   2, 
                PM5H,   2, 
                        Offset (0x56), 
                PM6L,   2, 
                    ,   2, 
                PM6H,   2, 
                        Offset (0x57), 
                    ,   7, 
                HENA,   1, 
                        Offset (0x62), 
                TUUD,   16, 
                        Offset (0x70), 
                    ,   4, 
                TLUD,   12, 
                        Offset (0x89), 
                    ,   3, 
                GTSE,   1, 
                        Offset (0x8A)
            }

            OperationRegion (MCHC, SystemMemory, 0xFED14000, 0x4000)
            Field (MCHC, DWordAcc, Lock, Preserve)
            {
                        Offset (0xC14), 
                CLKD,   6, 
                        Offset (0xFC0), 
                    ,   25, 
                FC25,   1, 
                FC26,   1
            }

            OperationRegion (MCHT, SystemMemory, 0xFED11000, 0xFF)
            Field (MCHT, ByteAcc, NoLock, Preserve)
            {
                        Offset (0x1E), 
                T0IS,   16, 
                        Offset (0x5E), 
                T1IS,   16, 
                        Offset (0xEF), 
                ESCS,   8
            }

            Name (BUF0, ResourceTemplate ()
            {
                WordBusNumber (ResourceProducer, MinFixed, MaxFixed, PosDecode,
                    0x0000,             // Granularity
                    0x0000,             // Range Minimum
                    0x00FF,             // Range Maximum
                    0x0000,             // Translation Offset
                    0x0100,             // Length
                    ,, )
                DWordIO (ResourceProducer, MinFixed, MaxFixed, PosDecode, EntireRange,
                    0x00000000,         // Granularity
                    0x00000000,         // Range Minimum
                    0x00000CF7,         // Range Maximum
                    0x00000000,         // Translation Offset
                    0x00000CF8,         // Length
                    ,, , TypeStatic)
                IO (Decode16,
                    0x0CF8,             // Range Minimum
                    0x0CF8,             // Range Maximum
                    0x01,               // Alignment
                    0x08,               // Length
                    )
                DWordIO (ResourceProducer, MinFixed, MaxFixed, PosDecode, EntireRange,
                    0x00000000,         // Granularity
                    0x00000D00,         // Range Minimum
                    0x0000FFFF,         // Range Maximum
                    0x00000000,         // Translation Offset
                    0x0000F300,         // Length
                    ,, , TypeStatic)
                DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                    0x00000000,         // Granularity
                    0x000A0000,         // Range Minimum
                    0x000BFFFF,         // Range Maximum
                    0x00000000,         // Translation Offset
                    0x00020000,         // Length
                    ,, , AddressRangeMemory, TypeStatic)
                DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                    0x00000000,         // Granularity
                    0x000C0000,         // Range Minimum
                    0x000C3FFF,         // Range Maximum
                    0x00000000,         // Translation Offset
                    0x00004000,         // Length
                    ,, , AddressRangeMemory, TypeStatic)
                DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                    0x00000000,         // Granularity
                    0x000C4000,         // Range Minimum
                    0x000C7FFF,         // Range Maximum
                    0x00000000,         // Translation Offset
                    0x00004000,         // Length
                    ,, , AddressRangeMemory, TypeStatic)
                DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                    0x00000000,         // Granularity
                    0x000C8000,         // Range Minimum
                    0x000CBFFF,         // Range Maximum
                    0x00000000,         // Translation Offset
                    0x00004000,         // Length
                    ,, , AddressRangeMemory, TypeStatic)
                DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                    0x00000000,         // Granularity
                    0x000CC000,         // Range Minimum
                    0x000CFFFF,         // Range Maximum
                    0x00000000,         // Translation Offset
                    0x00004000,         // Length
                    ,, , AddressRangeMemory, TypeStatic)
                DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                    0x00000000,         // Granularity
                    0x000D0000,         // Range Minimum
                    0x000D3FFF,         // Range Maximum
                    0x00000000,         // Translation Offset
                    0x00004000,         // Length
                    ,, , AddressRangeMemory, TypeStatic)
                DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                    0x00000000,         // Granularity
                    0x000D4000,         // Range Minimum
                    0x000D7FFF,         // Range Maximum
                    0x00000000,         // Translation Offset
                    0x00004000,         // Length
                    ,, , AddressRangeMemory, TypeStatic)
                DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                    0x00000000,         // Granularity
                    0x000D8000,         // Range Minimum
                    0x000DBFFF,         // Range Maximum
                    0x00000000,         // Translation Offset
                    0x00004000,         // Length
                    ,, , AddressRangeMemory, TypeStatic)
                DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                    0x00000000,         // Granularity
                    0x000DC000,         // Range Minimum
                    0x000DFFFF,         // Range Maximum
                    0x00000000,         // Translation Offset
                    0x00004000,         // Length
                    ,, , AddressRangeMemory, TypeStatic)
                DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                    0x00000000,         // Granularity
                    0x000E0000,         // Range Minimum
                    0x000E3FFF,         // Range Maximum
                    0x00000000,         // Translation Offset
                    0x00004000,         // Length
                    ,, , AddressRangeMemory, TypeStatic)
                DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                    0x00000000,         // Granularity
                    0x000E4000,         // Range Minimum
                    0x000E7FFF,         // Range Maximum
                    0x00000000,         // Translation Offset
                    0x00004000,         // Length
                    ,, , AddressRangeMemory, TypeStatic)
                DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                    0x00000000,         // Granularity
                    0x000E8000,         // Range Minimum
                    0x000EBFFF,         // Range Maximum
                    0x00000000,         // Translation Offset
                    0x00004000,         // Length
                    ,, , AddressRangeMemory, TypeStatic)
                DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                    0x00000000,         // Granularity
                    0x000EC000,         // Range Minimum
                    0x000EFFFF,         // Range Maximum
                    0x00000000,         // Translation Offset
                    0x00004000,         // Length
                    ,, , AddressRangeMemory, TypeStatic)
                DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                    0x00000000,         // Granularity
                    0x000F0000,         // Range Minimum
                    0x000FFFFF,         // Range Maximum
                    0x00000000,         // Translation Offset
                    0x00010000,         // Length
                    ,, , AddressRangeMemory, TypeStatic)
                DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                    0x00000000,         // Granularity
                    0x00000000,         // Range Minimum
                    0xFEBFFFFF,         // Range Maximum
                    0x00000000,         // Translation Offset
                    0x00000000,         // Length
                    ,, , AddressRangeMemory, TypeStatic)
                DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                    0x00000000,         // Granularity
                    0xFED40000,         // Range Minimum
                    0xFED44FFF,         // Range Maximum
                    0x00000000,         // Translation Offset
                    0x00000000,         // Length
                    ,, , AddressRangeMemory, TypeStatic)
            })
            Method (_CRS, 0, Serialized)
            {
                If (PM1L)
                {
                    CreateDWordField (BUF0, 0x7C, C0LN)
                    Store (Zero, C0LN)
                }

                If (LEqual (PM1L, One))
                {
                    CreateBitField (BUF0, 0x0358, C0RW)
                    Store (Zero, C0RW)
                }

                If (PM1H)
                {
                    CreateDWordField (BUF0, 0x96, C4LN)
                    Store (Zero, C4LN)
                }

                If (LEqual (PM1H, One))
                {
                    CreateBitField (BUF0, 0x0428, C4RW)
                    Store (Zero, C4RW)
                }

                If (PM2L)
                {
                    CreateDWordField (BUF0, 0xB0, C8LN)
                    Store (Zero, C8LN)
                }

                If (LEqual (PM2L, One))
                {
                    CreateBitField (BUF0, 0x04F8, C8RW)
                    Store (Zero, C8RW)
                }

                If (PM2H)
                {
                    CreateDWordField (BUF0, 0xCA, CCLN)
                    Store (Zero, CCLN)
                }

                If (LEqual (PM2H, One))
                {
                    CreateBitField (BUF0, 0x05C8, CCRW)
                    Store (Zero, CCRW)
                }

                If (PM3L)
                {
                    CreateDWordField (BUF0, 0xE4, D0LN)
                    Store (Zero, D0LN)
                }

                If (LEqual (PM3L, One))
                {
                    CreateBitField (BUF0, 0x0698, D0RW)
                    Store (Zero, D0RW)
                }

                If (PM3H)
                {
                    CreateDWordField (BUF0, 0xFE, D4LN)
                    Store (Zero, D4LN)
                }

                If (LEqual (PM3H, One))
                {
                    CreateBitField (BUF0, 0x0768, D4RW)
                    Store (Zero, D4RW)
                }

                If (PM4L)
                {
                    CreateDWordField (BUF0, 0x0118, D8LN)
                    Store (Zero, D8LN)
                }

                If (LEqual (PM4L, One))
                {
                    CreateBitField (BUF0, 0x0838, D8RW)
                    Store (Zero, D8RW)
                }

                If (PM4H)
                {
                    CreateDWordField (BUF0, 0x0132, DCLN)
                    Store (Zero, DCLN)
                }

                If (LEqual (PM4H, One))
                {
                    CreateBitField (BUF0, 0x0908, DCRW)
                    Store (Zero, DCRW)
                }

                If (PM5L)
                {
                    CreateDWordField (BUF0, 0x014C, E0LN)
                    Store (Zero, E0LN)
                }

                If (LEqual (PM5L, One))
                {
                    CreateBitField (BUF0, 0x09D8, E0RW)
                    Store (Zero, E0RW)
                }

                If (PM5H)
                {
                    CreateDWordField (BUF0, 0x0166, E4LN)
                    Store (Zero, E4LN)
                }

                If (LEqual (PM5H, One))
                {
                    CreateBitField (BUF0, 0x0AA8, E4RW)
                    Store (Zero, E4RW)
                }

                If (PM6L)
                {
                    CreateDWordField (BUF0, 0x0180, E8LN)
                    Store (Zero, E8LN)
                }

                If (LEqual (PM6L, One))
                {
                    CreateBitField (BUF0, 0x0B78, E8RW)
                    Store (Zero, E8RW)
                }

                If (PM6H)
                {
                    CreateDWordField (BUF0, 0x019A, ECLN)
                    Store (Zero, ECLN)
                }

                If (LEqual (PM6H, One))
                {
                    CreateBitField (BUF0, 0x0C48, ECRW)
                    Store (Zero, ECRW)
                }

                If (PM0H)
                {
                    CreateDWordField (BUF0, 0x01B4, F0LN)
                    Store (Zero, F0LN)
                }

                If (LEqual (PM0H, One))
                {
                    CreateBitField (BUF0, 0x0D18, F0RW)
                    Store (Zero, F0RW)
                }

                CreateDWordField (BUF0, 0x01C2, M1MN)
                CreateDWordField (BUF0, 0x01C6, M1MX)
                CreateDWordField (BUF0, 0x01CE, M1LN)
                ShiftLeft (TLUD, 0x14, M1MN)
                Add (Subtract (M1MX, M1MN), One, M1LN)
                Return (BUF0)
            }

            Device (P0P2)
            {
                Name (_ADR, 0x00010000)
                Method (_PRT, 0, NotSerialized)
                {
                    If (PICM)
                    {
                        Return (AR02)
                    }

                    Return (PR02)
                }

                OperationRegion (PCIX, SystemMemory, 0xE0008000, 0x4000)
                Field (PCIX, DWordAcc, Lock, Preserve)
                {
                            Offset (0x3E), 
                        ,   6, 
                    SRST,   1, 
                            Offset (0xA0), 
                            Offset (0xA2), 
                            Offset (0xA3), 
                    SLIM,   1, 
                            Offset (0xB0), 
                    ASPM,   2, 
                        ,   3, 
                    RETL,   1, 
                    RCCC,   1, 
                            Offset (0xB2), 
                        ,   10, 
                    LTER,   1, 
                    LTST,   1, 
                    RSCC,   1, 
                            Offset (0xB4), 
                    SLCP,   7, 
                    SPLV,   8, 
                    SPLS,   2, 
                        ,   2, 
                    PHSN,   13, 
                    RSCL,   8, 
                    RSCH,   8, 
                        ,   1, 
                    ATBP,   1, 
                        ,   2, 
                    CMDC,   1, 
                    MRSS,   1, 
                    PRDS,   1, 
                            Offset (0xF0), 
                            Offset (0xF3), 
                    RXSD,   2, 
                            Offset (0xF4), 
                        ,   4, 
                    LCGC,   1, 
                            Offset (0xFC), 
                    LCGE,   1, 
                    CPRT,   1, 
                        ,   2, 
                    SCDL,   1, 
                            Offset (0x150), 
                    LNKV,   1, 
                            Offset (0x158), 
                    L1EA,   32, 
                            Offset (0x200), 
                        ,   13, 
                    CGEL,   2, 
                            Offset (0x214), 
                            Offset (0x216), 
                    LNKS,   4, 
                            Offset (0x224), 
                            Offset (0x225), 
                    DQDA,   1, 
                        ,   12, 
                    SDLY,   4, 
                            Offset (0x308), 
                    PRC0,   32, 
                            Offset (0x314), 
                    NRC0,   32, 
                            Offset (0xA04), 
                        ,   22, 
                    A422,   1, 
                            Offset (0xA84), 
                            Offset (0xA85), 
                    A848,   1, 
                            Offset (0xB00), 
                        ,   3, 
                    B003,   3, 
                            Offset (0xB01), 
                    B008,   2, 
                            Offset (0xB04), 
                        ,   23, 
                    B239,   9, 
                            Offset (0xB14), 
                        ,   17, 
                    B147,   1
                }

                Name (HPEJ, Zero)
                Method (_STA, 0, NotSerialized)
                {
                    If (LEqual (D1EN, Zero))
                    {
                        Return (One)
                    }
                    Else
                    {
                        If (And (HPEJ, LNot (^PEGP.HPLG)))
                        {
                            Store (Zero, HPEJ)
                        }

                        Return (0x0F)
                    }
                }

                Device (PEGP)
                {
                    Mutex (VGA0, 0x00)
                    Name (_ADR, Zero)
                    OperationRegion (XPCI, SystemMemory, 0xE0100000, 0x4000)
                    Field (XPCI, DWordAcc, Lock, Preserve)
                    {
                        R000,   32, 
                        R004,   32, 
                        R008,   32, 
                        R00C,   32, 
                        R010,   32, 
                        R014,   32, 
                        R018,   32, 
                        R01C,   32, 
                        R020,   32, 
                        R024,   32, 
                        R028,   32, 
                        R02C,   32, 
                        R030,   32, 
                        R034,   32, 
                        R038,   32, 
                        R03C,   32, 
                        R040,   32, 
                                Offset (0x78), 
                                Offset (0x88), 
                        DAPM,   2, 
                            ,   3, 
                        ERTL,   1, 
                        ECCC,   1, 
                                Offset (0x8A), 
                            ,   12, 
                        ESCC,   1, 
                                Offset (0x100), 
                                Offset (0x114), 
                        TCVC,   8
                    }

                    Name (TEMP, One)
                    Name (HPLG, Zero)
                    Method (_STA, 0, NotSerialized)
                    {
                        If (LEqual (HBEN, One))
                        {
                            If (LEqual (TEMP, One))
                            {
                                Return (0x0F)
                            }
                            Else
                            {
                                Return (One)
                            }
                        }
                        Else
                        {
                            If (LEqual (GP13, One))
                            {
                                Return (0x0F)
                            }
                            Else
                            {
                                Return (Zero)
                            }
                        }
                    }

                    Method (IPBR, 0, NotSerialized)
                    {
                        Store (One, TCVC)
                        If (LEqual (ESCC, One))
                        {
                            Store (One, ECCC)
                            Store (One, RCCC)
                        }
                    }

                    Method (_ON, 0, NotSerialized)
                    {
                        BreakPoint
                        Store (One, TEMP)
                        Store (Zero, HPLG)
                        If (LEqual (GP13, Zero))
                        {
                            Store (One, D1EN)
                            Store (Zero, GP46)
                            Sleep (0x64)
                            Store (One, GP13)
                            Sleep (0x64)
                            Sleep (0x64)
                            Store (One, GP46)
                            Sleep (0x96)
                            Store (Zero, DQDA)
                            Sleep (0x64)
                            Sleep (0x03E8)
                            P8XH (Zero, 0x55)
                            Store (0x064910DE, R000)
                            Store (0x00100006, R004)
                            Store (0x030000A1, R008)
                            Store (0x10, R00C)
                            Store (0xAE000000, R010)
                            Store (0xB000000C, R014)
                            Store (Zero, R018)
                            Store (0xAC000004, R01C)
                            Store (Zero, R020)
                            Store (0x2001, R024)
                            Store (Zero, R028)
                            Store (0x11481734, R02C)
                            Store (Zero, R030)
                            Store (0x60, R034)
                            Store (Zero, R038)
                            Store (0x0105, R03C)
                            Store (0x11481734, R040)
                            Store (0x03, DAPM)
                            IPBR ()
                            HDON ()
                            Notify (PCI0, Zero)
                        }
                    }

                    Method (_OFF, 0, NotSerialized)
                    {
                        BreakPoint
                        Store (Zero, TEMP)
                        Store (One, HPLG)
                        If (LEqual (GP13, One))
                        {
                            Or (CLKD, 0x21, CLKD)
                            Store (One, SRST)
                            Store (One, DQDA)
                            Store (Zero, SRST)
                            Store (Zero, GP46)
                            Sleep (0x32)
                            Store (One, GP46)
                            Sleep (0x32)
                            Store (Zero, GP46)
                            Sleep (0x32)
                            Store (Zero, GP13)
                            Sleep (0x64)
                            Store (Zero, D1EN)
                            Sleep (0x0177)
                            P8XH (Zero, 0x56)
                        }

                        HOFF ()
                    }

                    Method (MXDS, 1, NotSerialized)
                    {
                        P8XH (Zero, 0x79)
                        If (And (Arg0, Zero))
                        {
                            If (TEMP)
                            {
                                Return (One)
                            }
                            Else
                            {
                                Return (Zero)
                            }
                        }
                        Else
                        {
                            If (And (Arg0, One))
                            {
                                Store (Zero, GP18)
                                Store (Zero, GP21)
                                Store (Zero, GP36)
                                Store (Zero, GP37)
                                Store (Zero, GP53)
                            }
                        }
                    }

                    Method (MXMX, 1, NotSerialized)
                    {
                        Return (One)
                    }

                    Method (_ROM, 2, NotSerialized)
                    {
                        If (LGreater (Add (Arg0, Arg1), 0x00010000))
                        {
                            Subtract (Arg0, 0x00010000, Arg0)
                        }

                        If (LGreaterEqual (Arg0, 0x8000))
                        {
                            Sleep (0xA0)
                            Return (GETB (Subtract (Arg0, 0x8000), Arg1, VBF2))
                        }

                        If (LGreater (Add (Arg0, Arg1), 0x8000))
                        {
                            Subtract (0x8000, Arg0, Local0)
                            Subtract (Arg1, Local0, Local1)
                            Store (GETB (Arg0, Local0, VBF1), Local3)
                            Store (GETB (Zero, Local1, VBF2), Local4)
                            Concatenate (Local3, Local4, Local5)
                            Sleep (0xA0)
                            Return (Local5)
                        }

                        Sleep (0xA0)
                        Return (GETB (Arg0, Arg1, VBF1))
                    }

                    Method (DSQP, 0, NotSerialized)
                    {
                        Store (One, A848)
                        Store (Zero, B147)
                        Store (0x07, B003)
                        Store (0x03, B008)
                    }

                    Method (DCFG, 0, NotSerialized)
                    {
                        Store (Zero, LCGE)
                        Store (Zero, LCGC)
                        Store (0x03, CGEL)
                        Store (One, SDLY)
                        Store (0x03, RXSD)
                        Store (Zero, LCGE)
                        Store (One, LCGC)
                        Store (One, CPRT)
                        Store (One, SCDL)
                        Store (Zero, A422)
                        Store (One, A848)
                        Store (Zero, B147)
                        Store (0x07, B003)
                        Store (0x03, B008)
                        Store (Zero, PRC0)
                        Store (Zero, NRC0)
                        Store (One, A848)
                        Store (0x014E, B239)
                        Store (0xFED19000, L1EA)
                        Store (One, LNKV)
                    }

                    Method (DTCG, 0, NotSerialized)
                    {
                        Store (One, FC25)
                        Store (One, FC26)
                    }

                    Method (HDON, 0, NotSerialized)
                    {
                        ^^^LPCB.PMWT (0x72, 0x58)
                        ^^^LPCB.PMWT (0x73, 0x4D)
                        ^^^LPCB.PMWT (0x74, 0x16)
                        ^^^LPCB.PMWT (0x70, 0x06)
                    }

                    Method (HOFF, 0, NotSerialized)
                    {
                        ^^^LPCB.PMWT (0x72, 0x58)
                        ^^^LPCB.PMWT (0x73, 0x4D)
                        ^^^LPCB.PMWT (0x74, 0x05)
                        ^^^LPCB.PMWT (0x70, 0x06)
                    }

                    Method (VOUP, 0, NotSerialized)
                    {
                        ^^^LPCB.PMWT (0x72, 0x58)
                        ^^^LPCB.PMWT (0x73, 0x0E)
                        ^^^LPCB.PMWT (0x74, 0x03)
                        ^^^LPCB.PMWT (0x70, 0x06)
                    }

                    Name (CRTA, One)
                    Name (LCDA, One)
                    Name (TVAT, One)
                    Name (TOGF, Zero)
                    Method (_DOS, 1, NotSerialized)
                    {
                    }

                    Method (_DOD, 0, NotSerialized)
                    {
                        If (LEqual (HBEN, One))
                        {
                            Return (Package (0x03)
                            {
                                0x80000100, 
                                0x0110, 
                                0x80007330
                            })
                        }
                        Else
                        {
                            Return (Package (0x03)
                            {
                                0x00010100, 
                                0x00010110, 
                                0x00010121
                            })
                        }
                    }

                    Device (CRT)
                    {
                        Name (_ADR, 0x0100)
                        Method (_DCS, 0, NotSerialized)
                        {
                            If (CRTA)
                            {
                                Return (0x1F)
                            }
                            Else
                            {
                                Return (0x1D)
                            }
                        }

                        Method (_DGS, 0, NotSerialized)
                        {
                            If (CRTA)
                            {
                                Return (One)
                            }
                            Else
                            {
                                Return (Zero)
                            }
                        }

                        Method (_DSS, 1, NotSerialized)
                        {
                        }
                    }

                    Device (LCD)
                    {
                        Name (_ADR, 0x0110)
                        Method (_DCS, 0, NotSerialized)
                        {
                            If (LCDA)
                            {
                                Return (0x1F)
                            }
                            Else
                            {
                                Return (0x1D)
                            }
                        }

                        Method (_DGS, 0, NotSerialized)
                        {
                            If (LCDA)
                            {
                                Return (One)
                            }
                            Else
                            {
                                Return (Zero)
                            }
                        }

                        Method (_DSS, 1, NotSerialized)
                        {
                        }

                        Method (_BCL, 0, NotSerialized)
                        {
                            Return (Package (0x0C)
                            {
                                0x09, 
                                Zero, 
                                Zero, 
                                One, 
                                0x02, 
                                0x03, 
                                0x04, 
                                0x05, 
                                0x06, 
                                0x07, 
                                0x08, 
                                0x09
                            })
                        }

                        Name (BRTS, Package (0x0A)
                        {
                            0x28, 
                            0x48, 
                            0x5C, 
                            0x64, 
                            0x72, 
                            0x80, 
                            0x90, 
                            0xA8, 
                            0xBA, 
                            0xC8
                        })
                        Method (_BCM, 1, NotSerialized)
                        {
                            Store (Arg0, Local0)
                            Add (Local0, 0x10)
                            ^^^^LPCB.PMWT (0xDF, DerefOf (Index (BRTS, Arg0)))
                        }
                    }

                    Device (TV)
                    {
                        Method (_ADR, 0, NotSerialized)
                        {
                            If (LEqual (HBEN, One))
                            {
                                Return (0x7330)
                            }
                            Else
                            {
                                Return (0x0121)
                            }
                        }

                        Method (_DCS, 0, NotSerialized)
                        {
                            If (TVAT)
                            {
                                Return (0x1F)
                            }
                            Else
                            {
                                Return (0x1D)
                            }
                        }

                        Method (_DGS, 0, NotSerialized)
                        {
                            If (TVAT)
                            {
                                Return (One)
                            }
                            Else
                            {
                                Return (Zero)
                            }
                        }

                        Method (_DSS, 1, NotSerialized)
                        {
                        }
                    }
                }
            }

            Device (GFX0)
            {
                Name (_ADR, 0x00020000)
                Name (HGDD, Zero)
                Method (_DOS, 1, NotSerialized)
                {
                    Store (And (Arg0, 0x07), DSEN)
                    If (LEqual (HBEN, One))
                    {
                        If (LEqual (Arg0, Zero))
                        {
                            If (LEqual (HGDD, One))
                            {
                                Notify (GFX0, 0xD0)
                            }
                        }
                        Else
                        {
                            If (LEqual (Arg0, 0x02))
                            {
                                Store (Zero, HGDD)
                            }
                        }
                    }
                }

                Method (_DOD, 0, NotSerialized)
                {
                    If (LEqual (HBEN, One))
                    {
                        Return (Package (0x03)
                        {
                            0x80000100, 
                            0x0110, 
                            0x80007330
                        })
                    }
                    Else
                    {
                        If (SCIP ())
                        {
                            Store (Zero, NDID)
                            If (LNotEqual (DIDL, Zero))
                            {
                                Store (SDDL (DID1), DID1)
                            }

                            If (LNotEqual (DDL2, Zero))
                            {
                                Store (SDDL (DID2), DID2)
                            }

                            If (LNotEqual (DDL3, Zero))
                            {
                                Store (SDDL (DID3), DID3)
                            }

                            If (LNotEqual (DDL4, Zero))
                            {
                                Store (SDDL (DID4), DID4)
                            }

                            If (LNotEqual (DDL5, Zero))
                            {
                                Store (SDDL (DID5), DID5)
                            }
                        }

                        If (LEqual (NDID, One))
                        {
                            Name (TMP1, Package (0x01)
                            {
                                0xFFFFFFFF
                            })
                            Store (Or (0x00010000, DID1), Index (TMP1, Zero))
                            Return (TMP1)
                        }

                        If (LEqual (NDID, 0x02))
                        {
                            Name (TMP2, Package (0x02)
                            {
                                0xFFFFFFFF, 
                                0xFFFFFFFF
                            })
                            Store (Or (0x00010000, DID1), Index (TMP2, Zero))
                            Store (Or (0x00010000, DID2), Index (TMP2, One))
                            Return (TMP2)
                        }

                        If (LEqual (NDID, 0x03))
                        {
                            Name (TMP3, Package (0x03)
                            {
                                0xFFFFFFFF, 
                                0xFFFFFFFF, 
                                0xFFFFFFFF
                            })
                            Store (Or (0x00010000, DID1), Index (TMP3, Zero))
                            Store (Or (0x00010000, DID2), Index (TMP3, One))
                            Store (Or (0x00010000, DID3), Index (TMP3, 0x02))
                            Return (TMP3)
                        }

                        If (LEqual (NDID, 0x04))
                        {
                            Name (TMP4, Package (0x04)
                            {
                                0xFFFFFFFF, 
                                0xFFFFFFFF, 
                                0xFFFFFFFF, 
                                0xFFFFFFFF
                            })
                            Store (Or (0x00010000, DID1), Index (TMP4, Zero))
                            Store (Or (0x00010000, DID2), Index (TMP4, One))
                            Store (Or (0x00010000, DID3), Index (TMP4, 0x02))
                            Store (Or (0x00010000, DID4), Index (TMP4, 0x03))
                            Return (TMP4)
                        }

                        If (LGreater (NDID, 0x04))
                        {
                            Name (TMP5, Package (0x05)
                            {
                                0xFFFFFFFF, 
                                0xFFFFFFFF, 
                                0xFFFFFFFF, 
                                0xFFFFFFFF, 
                                0xFFFFFFFF
                            })
                            Store (Or (0x00010000, DID1), Index (TMP5, Zero))
                            Store (Or (0x00010000, DID2), Index (TMP5, One))
                            Store (Or (0x00010000, DID3), Index (TMP5, 0x02))
                            Store (Or (0x00010000, DID4), Index (TMP5, 0x03))
                            Store (Or (0x00010000, DID4), Index (TMP5, 0x04))
                            Return (TMP5)
                        }

                        Return (Package (0x01)
                        {
                            0x0400
                        })
                    }
                }

                Device (DD01)
                {
                    Method (_ADR, 0, NotSerialized)
                    {
                        If (LEqual (HBEN, One))
                        {
                            Return (0x0100)
                        }
                        Else
                        {
                            If (LEqual (DID1, Zero))
                            {
                                Return (One)
                            }
                            Else
                            {
                                Return (And (0xFFFF, DID1))
                            }
                        }
                    }

                    Method (_DCS, 0, NotSerialized)
                    {
                        If (LEqual (HBEN, One))
                        {
                            If (^^^P0P2.PEGP.CRTA)
                            {
                                Return (0x1F)
                            }
                            Else
                            {
                                Return (0x1D)
                            }
                        }
                        Else
                        {
                            If (SCIP ())
                            {
                                Return (CDDS (DID1))
                            }
                            Else
                            {
                                TRAP (TRTI, GCDD)
                                If (And (CSTE, One))
                                {
                                    Return (0x1F)
                                }

                                Return (0x1D)
                            }
                        }
                    }

                    Method (_DGS, 0, NotSerialized)
                    {
                        If (LEqual (HBEN, One))
                        {
                            If (^^^P0P2.PEGP.CRTA)
                            {
                                Return (One)
                            }
                            Else
                            {
                                Return (Zero)
                            }
                        }
                        Else
                        {
                            If (SCIP ())
                            {
                                Return (NDDS (DID1))
                            }
                            Else
                            {
                                If (And (NSTE, One))
                                {
                                    Return (One)
                                }

                                Return (Zero)
                            }
                        }
                    }

                    Method (_DSS, 1, NotSerialized)
                    {
                        If (LEqual (HBEN, Zero))
                        {
                            If (LEqual (And (Arg0, 0xC0000000), 0xC0000000))
                            {
                                Store (NSTE, CSTE)
                            }
                        }
                    }
                }

                Device (DD02)
                {
                    Method (_ADR, 0, NotSerialized)
                    {
                        If (LEqual (HBEN, One))
                        {
                            Return (0x0110)
                        }
                        Else
                        {
                            If (LEqual (DID2, Zero))
                            {
                                Return (0x02)
                            }
                            Else
                            {
                                Return (And (0xFFFF, DID2))
                            }
                        }
                    }

                    Method (_DCS, 0, NotSerialized)
                    {
                        If (LEqual (HBEN, One))
                        {
                            If (^^^P0P2.PEGP.LCDA)
                            {
                                Return (0x1F)
                            }
                            Else
                            {
                                Return (0x1D)
                            }
                        }
                        Else
                        {
                            If (SCIP ())
                            {
                                Return (CDDS (DID2))
                            }
                            Else
                            {
                                TRAP (TRTI, GCDD)
                                If (And (CSTE, 0x02))
                                {
                                    Return (0x1F)
                                }

                                Return (0x1D)
                            }
                        }
                    }

                    Method (_DGS, 0, NotSerialized)
                    {
                        If (LEqual (HBEN, One))
                        {
                            If (^^^P0P2.PEGP.LCDA)
                            {
                                Return (One)
                            }
                            Else
                            {
                                Return (Zero)
                            }
                        }
                        Else
                        {
                            If (SCIP ())
                            {
                                Return (NDDS (DID2))
                            }
                            Else
                            {
                                If (And (NSTE, 0x02))
                                {
                                    Return (One)
                                }

                                Return (Zero)
                            }
                        }
                    }

                    Method (_DSS, 1, NotSerialized)
                    {
                        If (LEqual (HBEN, Zero))
                        {
                            If (LEqual (And (Arg0, 0xC0000000), 0xC0000000))
                            {
                                Store (NSTE, CSTE)
                            }
                        }
                    }
                }

                Device (DD03)
                {
                    Method (_ADR, 0, NotSerialized)
                    {
                        If (LEqual (HBEN, One))
                        {
                            Return (0x7330)
                        }
                        Else
                        {
                            If (LEqual (DID3, Zero))
                            {
                                Return (0x03)
                            }
                            Else
                            {
                                Return (And (0xFFFF, DID3))
                            }
                        }
                    }

                    Method (_DCS, 0, NotSerialized)
                    {
                        If (LEqual (HBEN, One))
                        {
                            If (^^^P0P2.PEGP.TVAT)
                            {
                                Return (0x1F)
                            }
                            Else
                            {
                                Return (0x1D)
                            }
                        }
                        Else
                        {
                            If (LEqual (DID3, Zero))
                            {
                                Return (0x0B)
                            }
                            Else
                            {
                                If (SCIP ())
                                {
                                    Return (CDDS (DID3))
                                }
                                Else
                                {
                                    TRAP (TRTI, GCDD)
                                    If (And (CSTE, 0x04))
                                    {
                                        Return (0x1F)
                                    }

                                    Return (0x1D)
                                }
                            }
                        }
                    }

                    Method (_DGS, 0, NotSerialized)
                    {
                        If (LEqual (HBEN, One))
                        {
                            If (^^^P0P2.PEGP.TVAT)
                            {
                                Return (One)
                            }
                            Else
                            {
                                Return (Zero)
                            }
                        }
                        Else
                        {
                            If (SCIP ())
                            {
                                Return (NDDS (DID3))
                            }
                            Else
                            {
                                If (And (NSTE, 0x04))
                                {
                                    Return (One)
                                }

                                Return (Zero)
                            }
                        }
                    }

                    Method (_DSS, 1, NotSerialized)
                    {
                        If (LEqual (HBEN, One))
                        {
                            If (And (Arg0, One))
                            {
                                Store (One, HGDD)
                            }
                            Else
                            {
                                Store (Zero, HGDD)
                            }
                        }
                        Else
                        {
                            If (LEqual (And (Arg0, 0xC0000000), 0xC0000000))
                            {
                                Store (NSTE, CSTE)
                            }
                        }
                    }
                }

                Device (DD04)
                {
                    Method (_ADR, 0, Serialized)
                    {
                        If (LEqual (DID4, Zero))
                        {
                            Return (0x04)
                        }
                        Else
                        {
                            Return (And (0xFFFF, DID4))
                        }
                    }

                    Method (_DCS, 0, NotSerialized)
                    {
                        If (LEqual (HBEN, One))
                        {
                            Return (Zero)
                        }
                        Else
                        {
                            If (LEqual (DID4, Zero))
                            {
                                Return (0x0B)
                            }
                            Else
                            {
                                If (SCIP ())
                                {
                                    Return (CDDS (DID4))
                                }
                                Else
                                {
                                    TRAP (TRTI, GCDD)
                                    If (And (CSTE, 0x08))
                                    {
                                        Return (0x1F)
                                    }

                                    Return (0x1D)
                                }
                            }
                        }
                    }

                    Method (_DGS, 0, NotSerialized)
                    {
                        If (LEqual (HBEN, One))
                        {
                            Return (Zero)
                        }
                        Else
                        {
                            If (SCIP ())
                            {
                                Return (NDDS (DID4))
                            }
                            Else
                            {
                                If (And (NSTE, 0x08))
                                {
                                    Return (One)
                                }

                                Return (Zero)
                            }
                        }
                    }

                    Method (_DSS, 1, NotSerialized)
                    {
                        If (LEqual (HBEN, Zero))
                        {
                            If (LEqual (And (Arg0, 0xC0000000), 0xC0000000))
                            {
                                Store (NSTE, CSTE)
                            }
                        }
                    }
                }

                Device (DD05)
                {
                    Method (_ADR, 0, Serialized)
                    {
                        If (LEqual (DID5, Zero))
                        {
                            Return (0x05)
                        }
                        Else
                        {
                            Return (And (0xFFFF, DID5))
                        }
                    }

                    Method (_DCS, 0, NotSerialized)
                    {
                        If (LEqual (HBEN, One))
                        {
                            Return (Zero)
                        }
                        Else
                        {
                            If (LEqual (DID5, Zero))
                            {
                                Return (0x0B)
                            }
                            Else
                            {
                                If (SCIP ())
                                {
                                    Return (CDDS (DID5))
                                }
                                Else
                                {
                                    TRAP (TRTI, GCDD)
                                    If (And (CSTE, 0x10))
                                    {
                                        Return (0x1F)
                                    }

                                    Return (0x1D)
                                }
                            }
                        }
                    }

                    Method (_DGS, 0, NotSerialized)
                    {
                        If (LEqual (HBEN, One))
                        {
                            Return (Zero)
                        }
                        Else
                        {
                            If (SCIP ())
                            {
                                Return (NDDS (DID5))
                            }
                            Else
                            {
                                If (And (NSTE, 0x10))
                                {
                                    Return (One)
                                }

                                Return (Zero)
                            }
                        }
                    }

                    Method (_DSS, 1, NotSerialized)
                    {
                        If (LEqual (HBEN, Zero))
                        {
                            If (LEqual (And (Arg0, 0xC0000000), 0xC0000000))
                            {
                                Store (NSTE, CSTE)
                            }
                        }
                    }
                }

                Method (SDDL, 1, NotSerialized)
                {
                    Increment (NDID)
                    Store (And (Arg0, 0x0F0F), Local0)
                    Or (0x80000000, Local0, Local1)
                    If (LEqual (DIDL, Local0))
                    {
                        Return (Local1)
                    }

                    If (LEqual (DDL2, Local0))
                    {
                        Return (Local1)
                    }

                    If (LEqual (DDL3, Local0))
                    {
                        Return (Local1)
                    }

                    If (LEqual (DDL4, Local0))
                    {
                        Return (Local1)
                    }

                    If (LEqual (DDL5, Local0))
                    {
                        Return (Local1)
                    }

                    If (LEqual (DDL6, Local0))
                    {
                        Return (Local1)
                    }

                    If (LEqual (DDL7, Local0))
                    {
                        Return (Local1)
                    }

                    If (LEqual (DDL8, Local0))
                    {
                        Return (Local1)
                    }

                    Return (Zero)
                }

                Method (CDDS, 1, NotSerialized)
                {
                    Store (And (Arg0, 0x0F0F), Local0)
                    If (LEqual (Zero, Local0))
                    {
                        Return (0x1D)
                    }

                    If (LEqual (CADL, Local0))
                    {
                        Return (0x1F)
                    }

                    If (LEqual (CAL2, Local0))
                    {
                        Return (0x1F)
                    }

                    If (LEqual (CAL3, Local0))
                    {
                        Return (0x1F)
                    }

                    If (LEqual (CAL4, Local0))
                    {
                        Return (0x1F)
                    }

                    If (LEqual (CAL5, Local0))
                    {
                        Return (0x1F)
                    }

                    If (LEqual (CAL6, Local0))
                    {
                        Return (0x1F)
                    }

                    If (LEqual (CAL7, Local0))
                    {
                        Return (0x1F)
                    }

                    If (LEqual (CAL8, Local0))
                    {
                        Return (0x1F)
                    }

                    Return (0x1D)
                }

                Method (NDDS, 1, NotSerialized)
                {
                    Store (And (Arg0, 0x0F0F), Local0)
                    If (LEqual (Zero, Local0))
                    {
                        Return (Zero)
                    }

                    If (LEqual (NADL, Local0))
                    {
                        Return (One)
                    }

                    If (LEqual (NDL2, Local0))
                    {
                        Return (One)
                    }

                    If (LEqual (NDL3, Local0))
                    {
                        Return (One)
                    }

                    If (LEqual (NDL4, Local0))
                    {
                        Return (One)
                    }

                    If (LEqual (NDL5, Local0))
                    {
                        Return (One)
                    }

                    If (LEqual (NDL6, Local0))
                    {
                        Return (One)
                    }

                    If (LEqual (NDL7, Local0))
                    {
                        Return (One)
                    }

                    If (LEqual (NDL8, Local0))
                    {
                        Return (One)
                    }

                    Return (Zero)
                }

                Scope (^^PCI0)
                {
                    OperationRegion (MCHP, PCI_Config, 0x40, 0xC0)
                    Field (MCHP, AnyAcc, NoLock, Preserve)
                    {
                                Offset (0x60), 
                        TASM,   10, 
                                Offset (0x62)
                    }
                }

                OperationRegion (IGDP, PCI_Config, 0x40, 0xC0)
                Field (IGDP, AnyAcc, NoLock, Preserve)
                {
                            Offset (0x12), 
                        ,   1, 
                    GIVD,   1, 
                        ,   2, 
                    GUMA,   3, 
                            Offset (0x14), 
                        ,   4, 
                    GMFN,   1, 
                            Offset (0x18), 
                            Offset (0xA4), 
                    ASLE,   8, 
                            Offset (0xA8), 
                    GSSE,   1, 
                    GSSB,   14, 
                    GSES,   1, 
                            Offset (0xB0), 
                        ,   12, 
                    CDVL,   1, 
                            Offset (0xB2), 
                            Offset (0xB5), 
                    LBPC,   8, 
                            Offset (0xBC), 
                    ASLS,   32
                }

                OperationRegion (IGDM, SystemMemory, ASLB, 0x2000)
                Field (IGDM, AnyAcc, NoLock, Preserve)
                {
                    SIGN,   128, 
                    SIZE,   32, 
                    OVER,   32, 
                    SVER,   256, 
                    VVER,   128, 
                    GVER,   128, 
                    MBOX,   32, 
                    DMOD,   32, 
                            Offset (0x100), 
                    DRDY,   32, 
                    CSTS,   32, 
                    CEVT,   32, 
                            Offset (0x120), 
                    DIDL,   32, 
                    DDL2,   32, 
                    DDL3,   32, 
                    DDL4,   32, 
                    DDL5,   32, 
                    DDL6,   32, 
                    DDL7,   32, 
                    DDL8,   32, 
                    CPDL,   32, 
                    CPL2,   32, 
                    CPL3,   32, 
                    CPL4,   32, 
                    CPL5,   32, 
                    CPL6,   32, 
                    CPL7,   32, 
                    CPL8,   32, 
                    CADL,   32, 
                    CAL2,   32, 
                    CAL3,   32, 
                    CAL4,   32, 
                    CAL5,   32, 
                    CAL6,   32, 
                    CAL7,   32, 
                    CAL8,   32, 
                    NADL,   32, 
                    NDL2,   32, 
                    NDL3,   32, 
                    NDL4,   32, 
                    NDL5,   32, 
                    NDL6,   32, 
                    NDL7,   32, 
                    NDL8,   32, 
                    ASLP,   32, 
                    TIDX,   32, 
                    CHPD,   32, 
                    CLID,   32, 
                    CDCK,   32, 
                    SXSW,   32, 
                    EVTS,   32, 
                    CNOT,   32, 
                    NRDY,   32, 
                            Offset (0x200), 
                    SCIE,   1, 
                    GEFC,   4, 
                    GXFC,   3, 
                    GESF,   8, 
                            Offset (0x204), 
                    PARM,   32, 
                    DSLP,   32, 
                            Offset (0x300), 
                    ARDY,   32, 
                    ASLC,   32, 
                    TCHE,   32, 
                    ALSI,   32, 
                    BCLP,   32, 
                    PFIT,   32, 
                    CBLV,   32, 
                    BCLM,   320, 
                    CPFM,   32, 
                    EPFM,   32, 
                    PLUT,   592, 
                    PFMB,   32, 
                    CCDV,   32, 
                    PCFT,   32, 
                            Offset (0x400), 
                    GVD1,   49152, 
                    PHED,   32, 
                    BDDC,   2048
                }

                Name (DBTB, Package (0x15)
                {
                    Zero, 
                    0x07, 
                    0x38, 
                    0x01C0, 
                    0x0E00, 
                    0x3F, 
                    0x01C7, 
                    0x0E07, 
                    0x01F8, 
                    0x0E38, 
                    0x0FC0, 
                    Zero, 
                    Zero, 
                    Zero, 
                    Zero, 
                    Zero, 
                    0x7000, 
                    0x7007, 
                    0x7038, 
                    0x71C0, 
                    0x7E00
                })
                Name (CDCT, Package (0x05)
                {
                    Package (0x02)
                    {
                        0xE4, 
                        0x0140
                    }, 

                    Package (0x02)
                    {
                        0xDE, 
                        0x014D
                    }, 

                    Package (0x02)
                    {
                        0xDE, 
                        0x014D
                    }, 

                    Package (0x02)
                    {
                        Zero, 
                        Zero
                    }, 

                    Package (0x02)
                    {
                        0xDE, 
                        0x014D
                    }
                })
                Name (SUCC, One)
                Name (NVLD, 0x02)
                Name (CRIT, 0x04)
                Name (NCRT, 0x06)
                Method (GSCI, 0, Serialized)
                {
                    Method (GBDA, 0, Serialized)
                    {
                        If (LEqual (GESF, Zero))
                        {
                            Store (0x0679, PARM)
                            Store (Zero, GESF)
                            Return (SUCC)
                        }

                        If (LEqual (GESF, One))
                        {
                            Store (0x0240, PARM)
                            Store (Zero, GESF)
                            Return (SUCC)
                        }

                        If (LEqual (GESF, 0x04))
                        {
                            And (PARM, 0xEFFF0000, PARM)
                            And (PARM, ShiftLeft (DerefOf (Index (DBTB, IBTT)), 0x10), 
                                PARM)
                            Or (IBTT, PARM, PARM)
                            Store (Zero, GESF)
                            Return (SUCC)
                        }

                        If (LEqual (GESF, 0x05))
                        {
                            Store (IPSC, PARM)
                            Or (PARM, ShiftLeft (IPAT, 0x08), PARM)
                            Add (PARM, 0x0100, PARM)
                            Or (PARM, ShiftLeft (LIDS, 0x10), PARM)
                            Add (PARM, 0x00010000, PARM)
                            Or (PARM, ShiftLeft (IBIA, 0x14), PARM)
                            Store (Zero, GESF)
                            Return (SUCC)
                        }

                        If (LEqual (GESF, 0x06))
                        {
                            Store (ITVF, PARM)
                            Or (PARM, ShiftLeft (ITVM, 0x04), PARM)
                            Store (Zero, GESF)
                            Return (SUCC)
                        }

                        If (LEqual (GESF, 0x07))
                        {
                            Store (GIVD, PARM)
                            XOr (PARM, One, PARM)
                            Or (PARM, ShiftLeft (GMFN, One), PARM)
                            Or (PARM, 0x1800, PARM)
                            Or (PARM, ShiftLeft (IDMS, 0x11), PARM)
                            Or (ShiftLeft (DerefOf (Index (DerefOf (Index (CDCT, HVCO)), CDVL
                                )), 0x15), PARM, PARM)
                            Store (One, GESF)
                            Return (SUCC)
                        }

                        If (LEqual (GESF, 0x0A))
                        {
                            Store (Zero, PARM)
                            If (ISSC)
                            {
                                Or (PARM, 0x03, PARM)
                            }

                            Store (Zero, GESF)
                            Return (SUCC)
                        }

                        If (LEqual (GESF, 0x0B))
                        {
                            Store (KSV0, PARM)
                            Store (KSV1, GESF)
                            Return (SUCC)
                        }

                        Store (Zero, GESF)
                        Return (CRIT)
                    }

                    Method (SBCB, 0, Serialized)
                    {
                        If (LEqual (GESF, Zero))
                        {
                            Store (Zero, PARM)
                            Store (Zero, GESF)
                            Return (SUCC)
                        }

                        If (LEqual (GESF, One))
                        {
                            Store (Zero, GESF)
                            Store (Zero, PARM)
                            Return (SUCC)
                        }

                        If (LEqual (GESF, 0x03))
                        {
                            Store (Zero, GESF)
                            Store (Zero, PARM)
                            Return (SUCC)
                        }

                        If (LEqual (GESF, 0x04))
                        {
                            Store (Zero, GESF)
                            Store (Zero, PARM)
                            Return (SUCC)
                        }

                        If (LEqual (GESF, 0x05))
                        {
                            Store (Zero, GESF)
                            Store (Zero, PARM)
                            Return (SUCC)
                        }

                        If (LEqual (GESF, 0x06))
                        {
                            Store (And (PARM, 0x0F), ITVF)
                            Store (ShiftRight (And (PARM, 0xF0), 0x04), ITVM)
                            Store (Zero, GESF)
                            Store (Zero, PARM)
                            Return (SUCC)
                        }

                        If (LEqual (GESF, 0x07))
                        {
                            If (LEqual (PARM, Zero))
                            {
                                Store (CLID, Local0)
                                If (And (0x80000000, Local0))
                                {
                                    And (CLID, 0x0F, CLID)
                                    GLID (CLID)
                                }
                            }

                            Store (Zero, GESF)
                            Store (Zero, PARM)
                            Return (SUCC)
                        }

                        If (LEqual (GESF, 0x08))
                        {
                            Store (Zero, GESF)
                            Store (Zero, PARM)
                            Return (SUCC)
                        }

                        If (LEqual (GESF, 0x09))
                        {
                            And (PARM, 0xFF, IBTT)
                            Store (Zero, GESF)
                            Store (Zero, PARM)
                            Return (SUCC)
                        }

                        If (LEqual (GESF, 0x0A))
                        {
                            And (PARM, 0xFF, IPSC)
                            If (And (ShiftRight (PARM, 0x08), 0xFF))
                            {
                                And (ShiftRight (PARM, 0x08), 0xFF, IPAT)
                                Decrement (IPAT)
                            }

                            And (ShiftRight (PARM, 0x14), 0x07, IBIA)
                            Store (Zero, GESF)
                            Store (Zero, PARM)
                            Return (SUCC)
                        }

                        If (LEqual (GESF, 0x0B))
                        {
                            And (ShiftRight (PARM, One), One, IF1E)
                            If (And (PARM, 0x0001E000))
                            {
                                And (ShiftRight (PARM, 0x0D), 0x0F, IDMS)
                            }
                            Else
                            {
                                And (ShiftRight (PARM, 0x11), 0x0F, IDMS)
                            }

                            Store (Zero, GESF)
                            Store (Zero, PARM)
                            Return (SUCC)
                        }

                        If (LEqual (GESF, 0x10))
                        {
                            Store (Zero, GESF)
                            Store (Zero, PARM)
                            Return (SUCC)
                        }

                        If (LEqual (GESF, 0x11))
                        {
                            Store (ShiftLeft (LIDS, 0x08), PARM)
                            Add (PARM, 0x0100, PARM)
                            Store (Zero, GESF)
                            Return (SUCC)
                        }

                        If (LEqual (GESF, 0x12))
                        {
                            If (And (PARM, One))
                            {
                                If (LEqual (ShiftRight (PARM, One), One))
                                {
                                    Store (One, ISSC)
                                }
                                Else
                                {
                                    Store (Zero, GESF)
                                    Return (CRIT)
                                }
                            }
                            Else
                            {
                                Store (Zero, ISSC)
                            }

                            Store (Zero, GESF)
                            Store (Zero, PARM)
                            Return (SUCC)
                        }

                        If (LEqual (GESF, 0x13))
                        {
                            Store (Zero, GESF)
                            Store (Zero, PARM)
                            Return (SUCC)
                        }

                        If (LEqual (GESF, 0x14))
                        {
                            And (PARM, 0x0F, PAVP)
                            Store (Zero, GESF)
                            Store (Zero, PARM)
                            Return (SUCC)
                        }

                        Store (Zero, GESF)
                        Return (SUCC)
                    }

                    If (LEqual (GEFC, 0x04))
                    {
                        Store (GBDA (), GXFC)
                    }

                    If (LEqual (GEFC, 0x06))
                    {
                        Store (SBCB (), GXFC)
                    }

                    Store (Zero, GEFC)
                    Store (One, SCIS)
                    Store (Zero, GSSE)
                    Store (Zero, SCIE)
                    Return (Zero)
                }

                Method (PDRD, 0, NotSerialized)
                {
                    If (LNot (DRDY))
                    {
                        Sleep (ASLP)
                    }

                    Return (LNot (DRDY))
                }

                Method (PSTS, 0, NotSerialized)
                {
                    If (LGreater (CSTS, 0x02))
                    {
                        Sleep (ASLP)
                    }

                    Return (LEqual (CSTS, 0x03))
                }

                Method (GNOT, 2, NotSerialized)
                {
                    If (PDRD ())
                    {
                        Return (One)
                    }

                    Store (Arg0, CEVT)
                    Store (0x03, CSTS)
                    If (LAnd (LEqual (CHPD, Zero), LEqual (Arg1, Zero)))
                    {
                        If (LOr (LGreater (OSYS, 0x07D0), LLess (OSYS, 0x07D6)))
                        {
                            P8XH (Zero, 0xA0)
                            Notify (PCI0, Arg1)
                        }
                        Else
                        {
                            P8XH (Zero, 0xA1)
                            Notify (GFX0, Arg1)
                        }
                    }

                    P8XH (Zero, 0xA2)
                    Notify (GFX0, 0x80)
                    Return (Zero)
                }

                Method (GHDS, 1, NotSerialized)
                {
                    Store (Arg0, TIDX)
                    Return (GNOT (One, Zero))
                }

                Method (GLID, 1, NotSerialized)
                {
                    Store (Arg0, CLID)
                    Return (GNOT (0x02, Zero))
                }

                Method (GDCK, 1, NotSerialized)
                {
                    Store (Arg0, CDCK)
                    Return (GNOT (0x04, Zero))
                }

                Method (PARD, 0, NotSerialized)
                {
                    If (LNot (ARDY))
                    {
                        Sleep (ASLP)
                    }

                    Return (LNot (ARDY))
                }

                Method (AINT, 2, NotSerialized)
                {
                    If (LNot (And (TCHE, ShiftLeft (One, Arg0))))
                    {
                        Return (One)
                    }

                    If (PARD ())
                    {
                        Return (One)
                    }

                    If (LEqual (Arg0, 0x02))
                    {
                        If (CPFM)
                        {
                            And (CPFM, 0x0F, Local0)
                            And (EPFM, 0x0F, Local1)
                            If (LEqual (Local0, One))
                            {
                                If (And (Local1, 0x06))
                                {
                                    Store (0x06, PFIT)
                                }
                                Else
                                {
                                    If (And (Local1, 0x08))
                                    {
                                        Store (0x08, PFIT)
                                    }
                                    Else
                                    {
                                        Store (One, PFIT)
                                    }
                                }
                            }

                            If (LEqual (Local0, 0x06))
                            {
                                If (And (Local1, 0x08))
                                {
                                    Store (0x08, PFIT)
                                }
                                Else
                                {
                                    If (And (Local1, One))
                                    {
                                        Store (One, PFIT)
                                    }
                                    Else
                                    {
                                        Store (0x06, PFIT)
                                    }
                                }
                            }

                            If (LEqual (Local0, 0x08))
                            {
                                If (And (Local1, One))
                                {
                                    Store (One, PFIT)
                                }
                                Else
                                {
                                    If (And (Local1, 0x06))
                                    {
                                        Store (0x06, PFIT)
                                    }
                                    Else
                                    {
                                        Store (0x08, PFIT)
                                    }
                                }
                            }
                        }
                        Else
                        {
                            XOr (PFIT, 0x07, PFIT)
                        }

                        Or (PFIT, 0x80000000, PFIT)
                        Store (0x04, ASLC)
                    }
                    Else
                    {
                        If (LEqual (Arg0, One))
                        {
                            Store (Divide (Multiply (Arg1, 0xFF), 0x64, ), BCLP)
                            Or (BCLP, 0x80000000, BCLP)
                            Store (0x02, ASLC)
                        }
                        Else
                        {
                            If (LEqual (Arg0, Zero))
                            {
                                Store (Arg1, ALSI)
                                Store (One, ASLC)
                            }
                            Else
                            {
                                Return (One)
                            }
                        }
                    }

                    Store (Zero, LBPC)
                    Return (Zero)
                }

                Method (SCIP, 0, NotSerialized)
                {
                    If (LNotEqual (OVER, Zero))
                    {
                        Return (LNot (GSMI))
                    }

                    Return (Zero)
                }

                Method (UCMP, 2, NotSerialized)
                {
                    If (LNotEqual (0x10, SizeOf (Arg0)))
                    {
                        Return (Zero)
                    }

                    If (LNotEqual (0x10, SizeOf (Arg1)))
                    {
                        Return (Zero)
                    }

                    Store (Zero, Local0)
                    While (LLess (Local0, 0x10))
                    {
                        If (LNotEqual (DerefOf (Index (Arg0, Local0)), DerefOf (Index (
                            Arg1, Local0))))
                        {
                            Return (Zero)
                        }

                        Increment (Local0)
                    }

                    Return (One)
                }

                Method (_DSM, 4, NotSerialized)
                {
                    If (LEqual (UCMP (Arg0, Buffer (0x10)
                                {
                                    /* 0000 */    0xA0, 0xA0, 0x95, 0x9D, 0x60, 0x00, 0x48, 0x4D, 
                                    /* 0008 */    0xB3, 0x4D, 0x7E, 0x5F, 0xEA, 0x12, 0x9F, 0xD4
                                }), One))
                    {
                        Name (_T_0, Zero)
                        Store (Arg2, _T_0)
                        If (LEqual (_T_0, Zero))
                        {
                            Return (Buffer (0x04)
                            {
                                0x7F, 0x30, 0x00, 0x00
                            })
                        }
                        Else
                        {
                            If (LEqual (_T_0, One))
                            {
                                Return (Buffer (0x04)
                                {
                                    0xFF, 0x40, 0x00, 0x00
                                })
                            }
                            Else
                            {
                                If (LEqual (_T_0, 0x02))
                                {
                                    Store (And (Arg3, 0x10), Local0)
                                    If (LEqual (Local0, 0x10))
                                    {
                                        Notify (GFX0, 0xD9)
                                        If (LEqual (NVEN, One))
                                        {
                                            Return (Buffer (0x04)
                                            {
                                                0x12, 0x00, 0x00, 0x00
                                            })
                                        }
                                        Else
                                        {
                                            Return (Buffer (0x04)
                                            {
                                                0x11, 0x00, 0x00, 0x00
                                            })
                                        }
                                    }
                                    Else
                                    {
                                        If (LEqual (NVEN, One))
                                        {
                                            Return (Buffer (0x04)
                                            {
                                                0x02, 0x00, 0x00, 0x00
                                            })
                                        }
                                        Else
                                        {
                                            Return (Buffer (0x04)
                                            {
                                                0x01, 0x00, 0x00, 0x00
                                            })
                                        }
                                    }
                                }
                                Else
                                {
                                    If (LEqual (_T_0, 0x03))
                                    {
                                        P8XH (Zero, 0x77)
                                        Name (TTT1, Buffer (0x04)
                                        {
                                            0x01, 0x00, 0x00, 0x00
                                        })
                                        Name (TTT0, Buffer (0x04)
                                        {
                                            0x00, 0x00, 0x00, 0x00
                                        })
                                        Store (And (Arg3, 0x03), Local0)
                                        If (LEqual (Local0, One))
                                        {
                                            ^^P0P2.PEGP._ON ()
                                        }
                                        Else
                                        {
                                            If (LEqual (Local0, 0x02))
                                            {
                                                ^^P0P2.PEGP._OFF ()
                                            }
                                            Else
                                            {
                                                If (LEqual (^^P0P2.PEGP._STA (), 0x0F))
                                                {
                                                    Return (TTT1)
                                                }
                                                Else
                                                {
                                                    Return (TTT0)
                                                }
                                            }
                                        }
                                    }
                                    Else
                                    {
                                        If (LEqual (_T_0, 0x04))
                                        {
                                            Return (Buffer (0x04)
                                            {
                                                0x03, 0x00, 0x00, 0x00
                                            })
                                        }
                                        Else
                                        {
                                            If (LEqual (_T_0, 0x05))
                                            {
                                                If (LEqual (And (Arg3, 0x80000000), 0x80000000))
                                                {
                                                    If (LEqual (And (Arg3, 0x40000000), 0x40000000))
                                                    {
                                                        Notify (GFX0, 0xD0)
                                                    }

                                                    Store (And (Arg3, 0x0E000000), Local0)
                                                    ShiftRight (Local0, 0x19, Local0)
                                                    If (LEqual (Local0, One))
                                                    {
                                                        Store (0x0100, ^^P0P2.PEGP.TOGF)
                                                        Return (Buffer (0x04)
                                                        {
                                                            0x00, 0x01, 0x00, 0x00
                                                        })
                                                    }

                                                    If (LEqual (Local0, 0x02))
                                                    {
                                                        Store (0x0200, ^^P0P2.PEGP.TOGF)
                                                        Return (Buffer (0x04)
                                                        {
                                                            0x00, 0x02, 0x00, 0x00
                                                        })
                                                    }

                                                    If (LEqual (Local0, 0x03))
                                                    {
                                                        Store (0x0300, ^^P0P2.PEGP.TOGF)
                                                        Return (Buffer (0x04)
                                                        {
                                                            0x00, 0x03, 0x00, 0x00
                                                        })
                                                    }

                                                    If (LEqual (Local0, 0x04))
                                                    {
                                                        Store (0x0400, ^^P0P2.PEGP.TOGF)
                                                        Return (Buffer (0x04)
                                                        {
                                                            0x00, 0x04, 0x00, 0x00
                                                        })
                                                    }

                                                    If (LEqual (Local0, 0x05))
                                                    {
                                                        Store (0x0500, ^^P0P2.PEGP.TOGF)
                                                        Return (Buffer (0x04)
                                                        {
                                                            0x00, 0x05, 0x00, 0x00
                                                        })
                                                    }

                                                    If (LEqual (Local0, 0x06))
                                                    {
                                                        Store (0x0600, ^^P0P2.PEGP.TOGF)
                                                        Return (Buffer (0x04)
                                                        {
                                                            0x00, 0x06, 0x00, 0x00
                                                        })
                                                    }
                                                }
                                                Else
                                                {
                                                    If (LEqual (And (Arg3, 0x01000000), 0x01000000))
                                                    {
                                                        And (Arg3, 0x7000, Local0)
                                                        ShiftRight (Local0, 0x0C, Local0)
                                                        And (Arg3, 0x07, Local1)
                                                        If (LEqual (Local1, One))
                                                        {
                                                            Store (One, ^^P0P2.PEGP.CRTA)
                                                            Store (Zero, ^^P0P2.PEGP.LCDA)
                                                            Store (Zero, ^^P0P2.PEGP.TVAT)
                                                            Store (0x0100, ^^P0P2.PEGP.TOGF)
                                                            Return (Buffer (0x04)
                                                            {
                                                                0x01, 0x01, 0x00, 0x00
                                                            })
                                                        }

                                                        If (LEqual (Local1, 0x02))
                                                        {
                                                            Store (Zero, ^^P0P2.PEGP.CRTA)
                                                            Store (One, ^^P0P2.PEGP.LCDA)
                                                            Store (Zero, ^^P0P2.PEGP.TVAT)
                                                            Store (0x0200, ^^P0P2.PEGP.TOGF)
                                                            Return (Buffer (0x04)
                                                            {
                                                                0x01, 0x02, 0x00, 0x00
                                                            })
                                                        }

                                                        If (LEqual (Local1, 0x03))
                                                        {
                                                            If (LEqual (Local0, One))
                                                            {
                                                                Store (One, ^^P0P2.PEGP.CRTA)
                                                                Store (One, ^^P0P2.PEGP.LCDA)
                                                                Store (Zero, ^^P0P2.PEGP.TVAT)
                                                                Store (0x0401, ^^P0P2.PEGP.TOGF)
                                                                Return (Buffer (0x04)
                                                                {
                                                                    0x01, 0x04, 0x00, 0x00
                                                                })
                                                            }

                                                            If (LEqual (Local0, 0x02))
                                                            {
                                                                Store (One, ^^P0P2.PEGP.CRTA)
                                                                Store (Zero, ^^P0P2.PEGP.LCDA)
                                                                Store (Zero, ^^P0P2.PEGP.TVAT)
                                                                Store (0x0100, ^^P0P2.PEGP.TOGF)
                                                                Return (Buffer (0x04)
                                                                {
                                                                    0x01, 0x01, 0x00, 0x00
                                                                })
                                                            }

                                                            If (LEqual (Local0, 0x03))
                                                            {
                                                                Store (Zero, ^^P0P2.PEGP.CRTA)
                                                                Store (One, ^^P0P2.PEGP.LCDA)
                                                                Store (Zero, ^^P0P2.PEGP.TVAT)
                                                                Store (0x0200, ^^P0P2.PEGP.TOGF)
                                                                Return (Buffer (0x04)
                                                                {
                                                                    0x01, 0x02, 0x00, 0x00
                                                                })
                                                            }
                                                        }

                                                        If (LEqual (Local1, 0x04))
                                                        {
                                                            Store (Zero, ^^P0P2.PEGP.CRTA)
                                                            Store (Zero, ^^P0P2.PEGP.LCDA)
                                                            Store (One, ^^P0P2.PEGP.TVAT)
                                                            Store (0x0300, ^^P0P2.PEGP.TOGF)
                                                            Return (Buffer (0x04)
                                                            {
                                                                0x01, 0x03, 0x00, 0x00
                                                            })
                                                        }

                                                        If (LEqual (Local1, 0x05))
                                                        {
                                                            If (LEqual (Local0, One))
                                                            {
                                                                Store (Zero, ^^P0P2.PEGP.CRTA)
                                                                Store (Zero, ^^P0P2.PEGP.LCDA)
                                                                Store (One, ^^P0P2.PEGP.TVAT)
                                                                Store (0x0300, ^^P0P2.PEGP.TOGF)
                                                                Return (Buffer (0x04)
                                                                {
                                                                    0x01, 0x03, 0x00, 0x00
                                                                })
                                                            }

                                                            If (LEqual (Local0, 0x04))
                                                            {
                                                                Store (One, ^^P0P2.PEGP.CRTA)
                                                                Store (Zero, ^^P0P2.PEGP.LCDA)
                                                                Store (One, ^^P0P2.PEGP.TVAT)
                                                                Store (0x0600, ^^P0P2.PEGP.TOGF)
                                                                Return (Buffer (0x04)
                                                                {
                                                                    0x01, 0x06, 0x00, 0x00
                                                                })
                                                            }

                                                            If (LEqual (Local0, 0x05))
                                                            {
                                                                Store (One, ^^P0P2.PEGP.CRTA)
                                                                Store (Zero, ^^P0P2.PEGP.LCDA)
                                                                Store (Zero, ^^P0P2.PEGP.TVAT)
                                                                Store (0x0100, ^^P0P2.PEGP.TOGF)
                                                                Return (Buffer (0x04)
                                                                {
                                                                    0x01, 0x01, 0x00, 0x00
                                                                })
                                                            }
                                                        }

                                                        If (LEqual (Local1, 0x06))
                                                        {
                                                            If (LEqual (Local0, 0x02))
                                                            {
                                                                Store (Zero, ^^P0P2.PEGP.CRTA)
                                                                Store (Zero, ^^P0P2.PEGP.LCDA)
                                                                Store (One, ^^P0P2.PEGP.TVAT)
                                                                Store (0x0300, ^^P0P2.PEGP.TOGF)
                                                                Return (Buffer (0x04)
                                                                {
                                                                    0x01, 0x03, 0x00, 0x00
                                                                })
                                                            }

                                                            If (LEqual (Local0, 0x04))
                                                            {
                                                                Store (Zero, ^^P0P2.PEGP.CRTA)
                                                                Store (One, ^^P0P2.PEGP.LCDA)
                                                                Store (One, ^^P0P2.PEGP.TVAT)
                                                                Store (0x0500, ^^P0P2.PEGP.TOGF)
                                                                Return (Buffer (0x04)
                                                                {
                                                                    0x01, 0x05, 0x00, 0x00
                                                                })
                                                            }

                                                            If (LEqual (Local0, 0x06))
                                                            {
                                                                Store (Zero, ^^P0P2.PEGP.CRTA)
                                                                Store (One, ^^P0P2.PEGP.LCDA)
                                                                Store (Zero, ^^P0P2.PEGP.TVAT)
                                                                Store (0x0200, ^^P0P2.PEGP.TOGF)
                                                                Return (Buffer (0x04)
                                                                {
                                                                    0x01, 0x02, 0x00, 0x00
                                                                })
                                                            }
                                                        }

                                                        If (LEqual (Local1, 0x07))
                                                        {
                                                            If (LEqual (Local0, One))
                                                            {
                                                                Store (Zero, ^^P0P2.PEGP.CRTA)
                                                                Store (Zero, ^^P0P2.PEGP.LCDA)
                                                                Store (One, ^^P0P2.PEGP.TVAT)
                                                                Store (0x0300, ^^P0P2.PEGP.TOGF)
                                                                Return (Buffer (0x04)
                                                                {
                                                                    0x01, 0x03, 0x00, 0x00
                                                                })
                                                            }

                                                            If (LEqual (Local0, 0x02))
                                                            {
                                                                Store (One, ^^P0P2.PEGP.CRTA)
                                                                Store (Zero, ^^P0P2.PEGP.LCDA)
                                                                Store (Zero, ^^P0P2.PEGP.TVAT)
                                                                Store (0x0100, ^^P0P2.PEGP.TOGF)
                                                                Return (Buffer (0x04)
                                                                {
                                                                    0x01, 0x01, 0x00, 0x00
                                                                })
                                                            }

                                                            If (LEqual (Local0, 0x04))
                                                            {
                                                                Store (One, ^^P0P2.PEGP.CRTA)
                                                                Store (One, ^^P0P2.PEGP.LCDA)
                                                                Store (Zero, ^^P0P2.PEGP.TVAT)
                                                                Store (0x0400, ^^P0P2.PEGP.TOGF)
                                                                Return (Buffer (0x04)
                                                                {
                                                                    0x01, 0x04, 0x00, 0x00
                                                                })
                                                            }

                                                            If (LEqual (Local0, 0x03))
                                                            {
                                                                Store (Zero, ^^P0P2.PEGP.CRTA)
                                                                Store (One, ^^P0P2.PEGP.LCDA)
                                                                Store (One, ^^P0P2.PEGP.TVAT)
                                                                Store (0x0500, ^^P0P2.PEGP.TOGF)
                                                                Return (Buffer (0x04)
                                                                {
                                                                    0x01, 0x05, 0x00, 0x00
                                                                })
                                                            }

                                                            If (LEqual (Local0, 0x06))
                                                            {
                                                                Store (One, ^^P0P2.PEGP.CRTA)
                                                                Store (Zero, ^^P0P2.PEGP.LCDA)
                                                                Store (One, ^^P0P2.PEGP.TVAT)
                                                                Store (0x0600, ^^P0P2.PEGP.TOGF)
                                                                Return (Buffer (0x04)
                                                                {
                                                                    0x01, 0x06, 0x00, 0x00
                                                                })
                                                            }

                                                            If (LEqual (Local0, 0x05))
                                                            {
                                                                Store (Zero, ^^P0P2.PEGP.CRTA)
                                                                Store (One, ^^P0P2.PEGP.LCDA)
                                                                Store (Zero, ^^P0P2.PEGP.TVAT)
                                                                Store (0x0200, ^^P0P2.PEGP.TOGF)
                                                                Return (Buffer (0x04)
                                                                {
                                                                    0x01, 0x02, 0x00, 0x00
                                                                })
                                                            }
                                                        }
                                                    }
                                                    Else
                                                    {
                                                        If (LEqual (^^P0P2.PEGP.TOGF, Zero))
                                                        {
                                                            Store (0x0200, ^^P0P2.PEGP.TOGF)
                                                            Return (Buffer (0x04)
                                                            {
                                                                0x00, 0x02, 0x00, 0x00
                                                            })
                                                        }
                                                        Else
                                                        {
                                                            Return (^^P0P2.PEGP.TOGF)
                                                        }
                                                    }
                                                }
                                            }
                                            Else
                                            {
                                                If (LEqual (_T_0, 0x06))
                                                {
                                                    Return (Package (0x0F)
                                                    {
                                                        0x0100, 
                                                        0x2C, 
                                                        0x0110, 
                                                        0x2C, 
                                                        0x7330, 
                                                        0x2C, 
                                                        0x0110, 
                                                        0x0100, 
                                                        0x2C, 
                                                        0x0110, 
                                                        0x7330, 
                                                        0x2C, 
                                                        0x0100, 
                                                        0x7330, 
                                                        0x2C
                                                    })
                                                }
                                                Else
                                                {
                                                    If (LEqual (_T_0, 0x0C)) {}
                                                    Else
                                                    {
                                                        If (LEqual (_T_0, 0x0D)) {}
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        Return (Buffer (0x04)
                        {
                            0x02, 0x00, 0x00, 0x80
                        })
                    }
                }

                Method (MXDS, 1, NotSerialized)
                {
                    P8XH (Zero, 0x78)
                    If (And (Arg0, Zero))
                    {
                        If (^^P0P2.PEGP.TEMP)
                        {
                            Return (Zero)
                        }
                        Else
                        {
                            Return (One)
                        }
                    }
                    Else
                    {
                        If (And (Arg0, One))
                        {
                            Store (One, GP18)
                            Store (One, GP21)
                            Store (One, GP36)
                            Store (One, GP37)
                            Store (One, GP53)
                        }
                    }
                }

                Method (MXMX, 1, NotSerialized)
                {
                    Return (One)
                }
            }

            Device (P0P1)
            {
                Name (_ADR, 0x001E0000)
                Method (_PRT, 0, NotSerialized)
                {
                    If (PICM)
                    {
                        Return (AR01)
                    }

                    Return (PR01)
                }
            }

            Device (LPCB)
            {
                Name (_ADR, 0x001F0000)
                Scope (\_SB)
                {
                    Scope (\_SB)
                    {
                        OperationRegion (TCG1, SystemMemory, 0xBDB8EDB5, 0x00000007)
                        Field (TCG1, AnyAcc, NoLock, Preserve)
                        {
                            SSS1,   8, 
                            SSS2,   8, 
                            SSS3,   8, 
                            SSS4,   8, 
                            SSS5,   8, 
                            TPMV,   8, 
                            MOR,    8
                        }

                        Name (TCGP, Buffer (0x08)
                        {
                            /* 0000 */    0x1F, 0xE0, 0x1F, 0x01, 0x02, 0x04, 0x08, 0xF0
                        })
                        CreateByteField (TCGP, Zero, PPRQ)
                        CreateByteField (TCGP, One, PPL1)
                        CreateByteField (TCGP, 0x02, PPRP)
                        CreateByteField (TCGP, 0x03, TPRS)
                        CreateByteField (TCGP, 0x04, PPOR)
                        CreateByteField (TCGP, 0x06, TMOR)
                        OperationRegion (TCGC, SystemIO, 0x72, 0x02)
                        Field (TCGC, ByteAcc, Lock, Preserve)
                        {
                            TIDX,   8, 
                            TPDA,   8
                        }

                        IndexField (TIDX, TPDA, ByteAcc, Lock, Preserve)
                        {
                                    Offset (0x70), 
                            TPP1,   8, 
                            PPLO,   8, 
                            TPP3,   8
                        }

                        Method (PHSR, 1, Serialized)
                        {
                            Store (Arg0, BCMD)
                            Store (Zero, DID)
                            Store (Zero, SMIC)
                            If (LEqual (BCMD, Arg0)) {}
                            Store (Zero, BCMD)
                            Store (Zero, DID)
                            Return (Zero)
                        }

                        OperationRegion (SMI0, SystemIO, 0x0000FE00, 0x00000002)
                        Field (SMI0, AnyAcc, NoLock, Preserve)
                        {
                            SMIC,   8
                        }

                        OperationRegion (SMI1, SystemMemory, 0xBDB8EEBD, 0x00000090)
                        Field (SMI1, AnyAcc, NoLock, Preserve)
                        {
                            BCMD,   8, 
                            DID,    32, 
                            INFO,   1024
                        }

                        Field (SMI1, AnyAcc, NoLock, Preserve)
                        {
                                    AccessAs (ByteAcc, 0x00), 
                                    Offset (0x05), 
                            INF,    8
                        }
                    }

                    OperationRegion (PCI0.LPCB.LPC1, PCI_Config, 0x40, 0xC0)
                    Field (PCI0.LPCB.LPC1, AnyAcc, NoLock, Preserve)
                    {
                                Offset (0x20), 
                        PARC,   8, 
                        PBRC,   8, 
                        PCRC,   8, 
                        PDRC,   8, 
                                Offset (0x28), 
                        PERC,   8, 
                        PFRC,   8, 
                        PGRC,   8, 
                        PHRC,   8
                    }

                    Device (LNKA)
                    {
                        Name (_HID, EisaId ("PNP0C0F"))
                        Name (_UID, One)
                        Method (_DIS, 0, Serialized)
                        {
                            Store (0x80, PARC)
                        }

                        Name (_PRS, ResourceTemplate ()
                        {
                            IRQ (Level, ActiveLow, Shared, )
                                {1,3,4,5,6,7,10,12,14,15}
                        })
                        Method (_CRS, 0, Serialized)
                        {
                            Name (RTLA, ResourceTemplate ()
                            {
                                IRQ (Level, ActiveLow, Shared, )
                                    {}
                            })
                            CreateWordField (RTLA, One, IRQ0)
                            Store (Zero, IRQ0)
                            ShiftLeft (One, And (PARC, 0x0F), IRQ0)
                            Return (RTLA)
                        }

                        Method (_SRS, 1, Serialized)
                        {
                            CreateWordField (Arg0, One, IRQ0)
                            FindSetRightBit (IRQ0, Local0)
                            Decrement (Local0)
                            Store (Local0, PARC)
                        }

                        Method (_STA, 0, Serialized)
                        {
                            If (And (PARC, 0x80))
                            {
                                Return (0x09)
                            }
                            Else
                            {
                                Return (0x0B)
                            }
                        }
                    }

                    Device (LNKB)
                    {
                        Name (_HID, EisaId ("PNP0C0F"))
                        Name (_UID, 0x02)
                        Method (_DIS, 0, Serialized)
                        {
                            Store (0x80, PBRC)
                        }

                        Name (_PRS, ResourceTemplate ()
                        {
                            IRQ (Level, ActiveLow, Shared, )
                                {1,3,4,5,6,7,11,12,14,15}
                        })
                        Method (_CRS, 0, Serialized)
                        {
                            Name (RTLB, ResourceTemplate ()
                            {
                                IRQ (Level, ActiveLow, Shared, )
                                    {}
                            })
                            CreateWordField (RTLB, One, IRQ0)
                            Store (Zero, IRQ0)
                            ShiftLeft (One, And (PBRC, 0x0F), IRQ0)
                            Return (RTLB)
                        }

                        Method (_SRS, 1, Serialized)
                        {
                            CreateWordField (Arg0, One, IRQ0)
                            FindSetRightBit (IRQ0, Local0)
                            Decrement (Local0)
                            Store (Local0, PBRC)
                        }

                        Method (_STA, 0, Serialized)
                        {
                            If (And (PBRC, 0x80))
                            {
                                Return (0x09)
                            }
                            Else
                            {
                                Return (0x0B)
                            }
                        }
                    }

                    Device (LNKC)
                    {
                        Name (_HID, EisaId ("PNP0C0F"))
                        Name (_UID, 0x03)
                        Method (_DIS, 0, Serialized)
                        {
                            Store (0x80, PCRC)
                        }

                        Name (_PRS, ResourceTemplate ()
                        {
                            IRQ (Level, ActiveLow, Shared, )
                                {1,3,4,5,6,7,10,12,14,15}
                        })
                        Method (_CRS, 0, Serialized)
                        {
                            Name (RTLC, ResourceTemplate ()
                            {
                                IRQ (Level, ActiveLow, Shared, )
                                    {}
                            })
                            CreateWordField (RTLC, One, IRQ0)
                            Store (Zero, IRQ0)
                            ShiftLeft (One, And (PCRC, 0x0F), IRQ0)
                            Return (RTLC)
                        }

                        Method (_SRS, 1, Serialized)
                        {
                            CreateWordField (Arg0, One, IRQ0)
                            FindSetRightBit (IRQ0, Local0)
                            Decrement (Local0)
                            Store (Local0, PCRC)
                        }

                        Method (_STA, 0, Serialized)
                        {
                            If (And (PCRC, 0x80))
                            {
                                Return (0x09)
                            }
                            Else
                            {
                                Return (0x0B)
                            }
                        }
                    }

                    Device (LNKD)
                    {
                        Name (_HID, EisaId ("PNP0C0F"))
                        Name (_UID, 0x04)
                        Method (_DIS, 0, Serialized)
                        {
                            Store (0x80, PDRC)
                        }

                        Name (_PRS, ResourceTemplate ()
                        {
                            IRQ (Level, ActiveLow, Shared, )
                                {1,3,4,5,6,7,11,12,14,15}
                        })
                        Method (_CRS, 0, Serialized)
                        {
                            Name (RTLD, ResourceTemplate ()
                            {
                                IRQ (Level, ActiveLow, Shared, )
                                    {}
                            })
                            CreateWordField (RTLD, One, IRQ0)
                            Store (Zero, IRQ0)
                            ShiftLeft (One, And (PDRC, 0x0F), IRQ0)
                            Return (RTLD)
                        }

                        Method (_SRS, 1, Serialized)
                        {
                            CreateWordField (Arg0, One, IRQ0)
                            FindSetRightBit (IRQ0, Local0)
                            Decrement (Local0)
                            Store (Local0, PDRC)
                        }

                        Method (_STA, 0, Serialized)
                        {
                            If (And (PDRC, 0x80))
                            {
                                Return (0x09)
                            }
                            Else
                            {
                                Return (0x0B)
                            }
                        }
                    }

                    Device (LNKE)
                    {
                        Name (_HID, EisaId ("PNP0C0F"))
                        Name (_UID, 0x05)
                        Method (_DIS, 0, Serialized)
                        {
                            Store (0x80, PERC)
                        }

                        Name (_PRS, ResourceTemplate ()
                        {
                            IRQ (Level, ActiveLow, Shared, )
                                {1,3,4,5,6,7,10,12,14,15}
                        })
                        Method (_CRS, 0, Serialized)
                        {
                            Name (RTLE, ResourceTemplate ()
                            {
                                IRQ (Level, ActiveLow, Shared, )
                                    {}
                            })
                            CreateWordField (RTLE, One, IRQ0)
                            Store (Zero, IRQ0)
                            ShiftLeft (One, And (PERC, 0x0F), IRQ0)
                            Return (RTLE)
                        }

                        Method (_SRS, 1, Serialized)
                        {
                            CreateWordField (Arg0, One, IRQ0)
                            FindSetRightBit (IRQ0, Local0)
                            Decrement (Local0)
                            Store (Local0, PERC)
                        }

                        Method (_STA, 0, Serialized)
                        {
                            If (And (PERC, 0x80))
                            {
                                Return (0x09)
                            }
                            Else
                            {
                                Return (0x0B)
                            }
                        }
                    }

                    Device (LNKF)
                    {
                        Name (_HID, EisaId ("PNP0C0F"))
                        Name (_UID, 0x06)
                        Method (_DIS, 0, Serialized)
                        {
                            Store (0x80, PFRC)
                        }

                        Name (_PRS, ResourceTemplate ()
                        {
                            IRQ (Level, ActiveLow, Shared, )
                                {1,3,4,5,6,7,11,12,14,15}
                        })
                        Method (_CRS, 0, Serialized)
                        {
                            Name (RTLF, ResourceTemplate ()
                            {
                                IRQ (Level, ActiveLow, Shared, )
                                    {}
                            })
                            CreateWordField (RTLF, One, IRQ0)
                            Store (Zero, IRQ0)
                            ShiftLeft (One, And (PFRC, 0x0F), IRQ0)
                            Return (RTLF)
                        }

                        Method (_SRS, 1, Serialized)
                        {
                            CreateWordField (Arg0, One, IRQ0)
                            FindSetRightBit (IRQ0, Local0)
                            Decrement (Local0)
                            Store (Local0, PFRC)
                        }

                        Method (_STA, 0, Serialized)
                        {
                            If (And (PFRC, 0x80))
                            {
                                Return (0x09)
                            }
                            Else
                            {
                                Return (0x0B)
                            }
                        }
                    }

                    Device (LNKG)
                    {
                        Name (_HID, EisaId ("PNP0C0F"))
                        Name (_UID, 0x07)
                        Method (_DIS, 0, Serialized)
                        {
                            Store (0x80, PGRC)
                        }

                        Name (_PRS, ResourceTemplate ()
                        {
                            IRQ (Level, ActiveLow, Shared, )
                                {1,3,4,5,6,7,10,12,14,15}
                        })
                        Method (_CRS, 0, Serialized)
                        {
                            Name (RTLG, ResourceTemplate ()
                            {
                                IRQ (Level, ActiveLow, Shared, )
                                    {}
                            })
                            CreateWordField (RTLG, One, IRQ0)
                            Store (Zero, IRQ0)
                            ShiftLeft (One, And (PGRC, 0x0F), IRQ0)
                            Return (RTLG)
                        }

                        Method (_SRS, 1, Serialized)
                        {
                            CreateWordField (Arg0, One, IRQ0)
                            FindSetRightBit (IRQ0, Local0)
                            Decrement (Local0)
                            Store (Local0, PGRC)
                        }

                        Method (_STA, 0, Serialized)
                        {
                            If (And (PGRC, 0x80))
                            {
                                Return (0x09)
                            }
                            Else
                            {
                                Return (0x0B)
                            }
                        }
                    }

                    Device (LNKH)
                    {
                        Name (_HID, EisaId ("PNP0C0F"))
                        Name (_UID, 0x08)
                        Method (_DIS, 0, Serialized)
                        {
                            Store (0x80, PHRC)
                        }

                        Name (_PRS, ResourceTemplate ()
                        {
                            IRQ (Level, ActiveLow, Shared, )
                                {1,3,4,5,6,7,11,12,14,15}
                        })
                        Method (_CRS, 0, Serialized)
                        {
                            Name (RTLH, ResourceTemplate ()
                            {
                                IRQ (Level, ActiveLow, Shared, )
                                    {}
                            })
                            CreateWordField (RTLH, One, IRQ0)
                            Store (Zero, IRQ0)
                            ShiftLeft (One, And (PHRC, 0x0F), IRQ0)
                            Return (RTLH)
                        }

                        Method (_SRS, 1, Serialized)
                        {
                            CreateWordField (Arg0, One, IRQ0)
                            FindSetRightBit (IRQ0, Local0)
                            Decrement (Local0)
                            Store (Local0, PHRC)
                        }

                        Method (_STA, 0, Serialized)
                        {
                            If (And (PHRC, 0x80))
                            {
                                Return (0x09)
                            }
                            Else
                            {
                                Return (0x0B)
                            }
                        }
                    }
                }

                OperationRegion (LPC0, PCI_Config, 0x40, 0xC0)
                Field (LPC0, AnyAcc, NoLock, Preserve)
                {
                            Offset (0x40), 
                    IOD0,   8, 
                    IOD1,   8, 
                            Offset (0xB0), 
                    RAEN,   1, 
                        ,   13, 
                    RCBA,   18
                }

                Device (DMAC)
                {
                    Name (_HID, EisaId ("PNP0200"))
                    Name (_CRS, ResourceTemplate ()
                    {
                        IO (Decode16,
                            0x0000,             // Range Minimum
                            0x0000,             // Range Maximum
                            0x01,               // Alignment
                            0x20,               // Length
                            )
                        IO (Decode16,
                            0x0081,             // Range Minimum
                            0x0081,             // Range Maximum
                            0x01,               // Alignment
                            0x11,               // Length
                            )
                        IO (Decode16,
                            0x0093,             // Range Minimum
                            0x0093,             // Range Maximum
                            0x01,               // Alignment
                            0x0D,               // Length
                            )
                        IO (Decode16,
                            0x00C0,             // Range Minimum
                            0x00C0,             // Range Maximum
                            0x01,               // Alignment
                            0x20,               // Length
                            )
                        IO (Decode16,
                            0x0400,             // Range Minimum
                            0x0400,             // Range Maximum
                            0x01,               // Alignment
                            0x80,               // Length
                            )
                        DMA (Compatibility, NotBusMaster, Transfer8_16, )
                            {4}
                    })
                }

                Device (FWHD)
                {
                    Name (_HID, EisaId ("INT0800"))
                    Name (_CRS, ResourceTemplate ()
                    {
                        Memory32Fixed (ReadOnly,
                            0xFF000000,         // Address Base
                            0x01000000,         // Address Length
                            )
                    })
                }

                Device (HPET)
                {
                    Name (_HID, EisaId ("PNP0103"))
                    Name (_CID, 0x010CD041)
                    Name (BUF0, ResourceTemplate ()
                    {
                        Memory32Fixed (ReadOnly,
                            0xFED00000,         // Address Base
                            0x00000400,         // Address Length
                            )
                    })
                    Method (_STA, 0, NotSerialized)
                    {
                        If (LGreaterEqual (OSYS, 0x07D1))
                        {
                            If (HPAE)
                            {
                                Return (0x0F)
                            }
                        }
                        Else
                        {
                            If (HPAE)
                            {
                                Return (0x0B)
                            }
                        }

                        Return (Zero)
                    }

                    Method (_CRS, 0, Serialized)
                    {
                        If (HPAE)
                        {
                            CreateDWordField (BUF0, 0x04, HPT0)
                            If (LEqual (HPAS, One))
                            {
                                Store (0xFED01000, HPT0)
                            }

                            If (LEqual (HPAS, 0x02))
                            {
                                Store (0xFED02000, HPT0)
                            }

                            If (LEqual (HPAS, 0x03))
                            {
                                Store (0xFED03000, HPT0)
                            }
                        }

                        Return (BUF0)
                    }
                }

                Device (IPIC)
                {
                    Name (_HID, EisaId ("PNP0000"))
                    Name (_CRS, ResourceTemplate ()
                    {
                        IO (Decode16,
                            0x0020,             // Range Minimum
                            0x0020,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x0024,             // Range Minimum
                            0x0024,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x0028,             // Range Minimum
                            0x0028,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x002C,             // Range Minimum
                            0x002C,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x0030,             // Range Minimum
                            0x0030,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x0034,             // Range Minimum
                            0x0034,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x0038,             // Range Minimum
                            0x0038,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x003C,             // Range Minimum
                            0x003C,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x00A0,             // Range Minimum
                            0x00A0,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x00A4,             // Range Minimum
                            0x00A4,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x00A8,             // Range Minimum
                            0x00A8,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x00AC,             // Range Minimum
                            0x00AC,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x00B0,             // Range Minimum
                            0x00B0,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x00B4,             // Range Minimum
                            0x00B4,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x00B8,             // Range Minimum
                            0x00B8,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x00BC,             // Range Minimum
                            0x00BC,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x04D0,             // Range Minimum
                            0x04D0,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IRQNoFlags ()
                            {2}
                    })
                }

                Device (MATH)
                {
                    Name (_HID, EisaId ("PNP0C04"))
                    Name (_CRS, ResourceTemplate ()
                    {
                        IO (Decode16,
                            0x00F0,             // Range Minimum
                            0x00F0,             // Range Maximum
                            0x01,               // Alignment
                            0x01,               // Length
                            )
                        IRQNoFlags ()
                            {13}
                    })
                }

                Device (LDRC)
                {
                    Name (_HID, EisaId ("PNP0C02"))
                    Name (_UID, 0x02)
                    Name (_CRS, ResourceTemplate ()
                    {
                        IO (Decode16,
                            0x002E,             // Range Minimum
                            0x002E,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x004E,             // Range Minimum
                            0x004E,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x0061,             // Range Minimum
                            0x0061,             // Range Maximum
                            0x01,               // Alignment
                            0x01,               // Length
                            )
                        IO (Decode16,
                            0x0063,             // Range Minimum
                            0x0063,             // Range Maximum
                            0x01,               // Alignment
                            0x01,               // Length
                            )
                        IO (Decode16,
                            0x0065,             // Range Minimum
                            0x0065,             // Range Maximum
                            0x01,               // Alignment
                            0x01,               // Length
                            )
                        IO (Decode16,
                            0x0067,             // Range Minimum
                            0x0067,             // Range Maximum
                            0x01,               // Alignment
                            0x01,               // Length
                            )
                        IO (Decode16,
                            0x0070,             // Range Minimum
                            0x0070,             // Range Maximum
                            0x01,               // Alignment
                            0x01,               // Length
                            )
                        IO (Decode16,
                            0x0080,             // Range Minimum
                            0x0080,             // Range Maximum
                            0x01,               // Alignment
                            0x01,               // Length
                            )
                        IO (Decode16,
                            0x0092,             // Range Minimum
                            0x0092,             // Range Maximum
                            0x01,               // Alignment
                            0x01,               // Length
                            )
                        IO (Decode16,
                            0x00B2,             // Range Minimum
                            0x00B2,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x0680,             // Range Minimum
                            0x0680,             // Range Maximum
                            0x01,               // Alignment
                            0x20,               // Length
                            )
                        IO (Decode16,
                            0x0480,             // Range Minimum
                            0x0480,             // Range Maximum
                            0x01,               // Alignment
                            0x10,               // Length
                            )
                        IO (Decode16,
                            0x0900,             // Range Minimum
                            0x0900,             // Range Maximum
                            0x01,               // Alignment
                            0x04,               // Length
                            )
                        IO (Decode16,
                            0xFFFF,             // Range Minimum
                            0xFFFF,             // Range Maximum
                            0x01,               // Alignment
                            0x01,               // Length
                            )
                        IO (Decode16,
                            0x1000,             // Range Minimum
                            0x1000,             // Range Maximum
                            0x01,               // Alignment
                            0x80,               // Length
                            )
                        IO (Decode16,
                            0x1180,             // Range Minimum
                            0x1180,             // Range Maximum
                            0x01,               // Alignment
                            0x80,               // Length
                            )
                        IO (Decode16,
                            0x164E,             // Range Minimum
                            0x164E,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0xFE00,             // Range Minimum
                            0xFE00,             // Range Maximum
                            0x01,               // Alignment
                            0x01,               // Length
                            )
                    })
                }

                Device (RTC)
                {
                    Name (_HID, EisaId ("PNP0B00"))
                    Name (_CRS, ResourceTemplate ()
                    {
                        IO (Decode16,
                            0x0070,             // Range Minimum
                            0x0070,             // Range Maximum
                            0x01,               // Alignment
                            0x08,               // Length
                            )
                        IRQNoFlags ()
                            {8}
                    })
                }

                Device (TIMR)
                {
                    Name (_HID, EisaId ("PNP0100"))
                    Name (_CRS, ResourceTemplate ()
                    {
                        IO (Decode16,
                            0x0040,             // Range Minimum
                            0x0040,             // Range Maximum
                            0x01,               // Alignment
                            0x04,               // Length
                            )
                        IO (Decode16,
                            0x0050,             // Range Minimum
                            0x0050,             // Range Maximum
                            0x10,               // Alignment
                            0x04,               // Length
                            )
                        IRQNoFlags ()
                            {0}
                    })
                }

                OperationRegion (PMIF, SystemIO, 0x68, 0x08)
                Field (PMIF, ByteAcc, NoLock, Preserve)
                {
                    PMUD,   8, 
                            Offset (0x04), 
                    PMUC,   8, 
                            Offset (0x08)
                }

                Mutex (ELCK, 0x00)
                Method (WIBF, 0, NotSerialized)
                {
                    Store (0x0009FFFF, Local6)
                    Noop
                    Noop
                    Store (PMUC, Local2)
                    And (Local2, 0x22, Local2)
                    If (And (Local2, 0x20, Local3))
                    {
                        Return (One)
                    }

                    And (Local2, 0x02, Local2)
                    While (LAnd (LNotEqual (Local2, Zero), LNotEqual (Local6, Zero)))
                    {
                        Noop
                        Noop
                        Store (PMUC, Local2)
                        Decrement (Local6)
                        If (And (Local2, 0x20, Local3))
                        {
                            Return (One)
                        }

                        And (Local2, 0x02, Local2)
                    }

                    Return (Zero)
                }

                Method (WOBF, 0, NotSerialized)
                {
                    Store (0x009FFFFF, Local6)
                    Noop
                    Noop
                    Store (PMUC, Local3)
                    And (Local3, 0x21, Local3)
                    If (And (Local3, 0x20, Local2))
                    {
                        Return (One)
                    }

                    While (LAnd (LEqual (Local3, Zero), LNotEqual (Local6, Zero)))
                    {
                        Noop
                        Noop
                        Store (PMUC, Local3)
                        And (Local3, 0x21, Local3)
                        If (And (Local3, 0x20, Local2))
                        {
                            Return (One)
                        }

                        Decrement (Local6)
                    }

                    Return (Zero)
                }

                Method (RCMD, 2, NotSerialized)
                {
                    Store (Arg0, Local0)
                    Store (Arg1, Local1)
                    Store (Local0, PMUC)
                    If (WIBF ())
                    {
                        Return (One)
                    }

                    Store (Local1, PMUD)
                    If (WOBF ())
                    {
                        Return (One)
                    }

                    Return (Zero)
                }

                Method (WCMD, 2, NotSerialized)
                {
                    Store (Arg0, Local0)
                    Store (Arg1, Local1)
                    Store (Local0, PMUC)
                    If (WIBF ())
                    {
                        Return (One)
                    }

                    Store (Local1, PMUD)
                    If (WIBF ())
                    {
                        Return (One)
                    }

                    Return (Zero)
                }

                Method (PMRD, 1, NotSerialized)
                {
                    Acquire (ELCK, 0xFFFF)
                    Store (Zero, EDFG)
                    Store (0x14, RECT)
                    While (LAnd (LEqual (EDFG, Zero), LNotEqual (RECT, Zero)))
                    {
                        Store (Arg0, Local0)
                        Store (0x03E8, Local6)
                        Store (PMUC, Local1)
                        And (Local1, 0x13, Local1)
                        While (LAnd (LNotEqual (Local1, Zero), LNotEqual (Local6, Zero)))
                        {
                            Sleep (One)
                            Store (PMUC, Local1)
                            And (Local1, 0x13, Local1)
                            If (And (Local1, One, Local2))
                            {
                                Store (PMUD, Local3)
                            }

                            Decrement (Local6)
                        }

                        While (RCMD (0x80, Local0))
                        {
                            Noop
                            Noop
                            Store (PMUC, Local5)
                            If (And (Local5, One, Local2))
                            {
                                Store (PMUD, Local5)
                            }
                        }

                        Store (0x07D0, Local6)
                        Store (PMUC, Local1)
                        And (Local1, 0x10, Local1)
                        While (LAnd (LNotEqual (Local1, Zero), LNotEqual (Local6, Zero)))
                        {
                            Noop
                            Noop
                            Store (PMUC, Local1)
                            And (Local1, 0x10, Local1)
                            Decrement (Local6)
                        }

                        Store (PMUC, Local1)
                        And (Local1, 0x20, Local1)
                        If (LEqual (Local1, Zero))
                        {
                            Store (One, EDFG)
                        }

                        Decrement (RECT)
                    }

                    Store (PMUD, Local4)
                    Release (ELCK)
                    Return (Local4)
                }

                Method (PMWT, 2, NotSerialized)
                {
                    Acquire (ELCK, 0xFFFF)
                    Store (Zero, EDFG)
                    Store (0x14, RECT)
                    While (LAnd (LEqual (EDFG, Zero), LNotEqual (RECT, Zero)))
                    {
                        Store (Arg0, Local0)
                        Store (0x03E8, Local6)
                        Store (PMUC, Local1)
                        And (Local1, 0x13, Local1)
                        While (LAnd (LNotEqual (Local1, Zero), LNotEqual (Local6, Zero)))
                        {
                            Sleep (One)
                            Store (PMUC, Local1)
                            And (Local1, 0x13, Local1)
                            Decrement (Local6)
                        }

                        While (WCMD (0x81, Local0))
                        {
                            Noop
                            Noop
                            Store (PMUC, Local5)
                            If (And (Local5, One, Local2))
                            {
                                Store (PMUD, Local5)
                            }
                        }

                        Store (Arg1, PMUD)
                        Store (0x07D0, Local6)
                        Store (PMUC, Local1)
                        And (Local1, 0x12, Local1)
                        While (LAnd (LNotEqual (Local1, Zero), LNotEqual (Local6, Zero)))
                        {
                            Store (Zero, ED)
                            Noop
                            Noop
                            Store (Zero, ED)
                            Store (PMUC, Local1)
                            And (Local1, 0x12, Local1)
                            Decrement (Local6)
                        }

                        Store (PMUC, Local1)
                        And (Local1, 0x20, Local1)
                        If (LEqual (Local1, Zero))
                        {
                            Store (One, EDFG)
                        }

                        Decrement (RECT)
                    }

                    Release (ELCK)
                }

                Method (PMMW, 2, NotSerialized)
                {
                    Store (Arg0, Local0)
                    Store (Arg1, Local1)
                    And (Local0, 0xFF, Local2)
                    And (Local0, 0xFF00, Local3)
                    ShiftRight (Local3, 0x08, Local3)
                    Add (Local2, Local3, Local4)
                    Add (Local4, 0xC1, Local4)
                    Add (Local4, Local1, Local7)
                    And (Local7, 0xFF, Local7)
                    PMWR (0x043F, Local7)
                    PMWR (Local0, Local1)
                }

                Method (PMWR, 2, NotSerialized)
                {
                    Acquire (ELCK, 0xFFFF)
                    Store (Zero, EDFG)
                    Store (0x14, RECT)
                    While (LAnd (LEqual (EDFG, Zero), LNotEqual (RECT, Zero)))
                    {
                        Store (0x03E8, Local6)
                        Store (PMUC, Local1)
                        And (Local1, 0x13, Local1)
                        While (LAnd (LNotEqual (Local1, Zero), LNotEqual (Local6, Zero)))
                        {
                            Sleep (One)
                            Store (PMUC, Local1)
                            And (Local1, 0x13, Local1)
                            Decrement (Local6)
                        }

                        Store (Arg0, Local0)
                        While (WCM2 (0xC1, Local0))
                        {
                            Store (Zero, ED)
                            Noop
                            Noop
                            Store (Zero, ED)
                            Store (PMUC, Local5)
                            If (And (Local5, One, Local2))
                            {
                                Store (PMUD, Local5)
                            }
                        }

                        Store (Arg1, PMUD)
                        Store (0x07D0, Local6)
                        Store (PMUC, Local1)
                        And (Local1, 0x12, Local1)
                        While (LAnd (LNotEqual (Local1, Zero), LNotEqual (Local6, Zero)))
                        {
                            Store (Zero, ED)
                            Noop
                            Noop
                            Store (Zero, ED)
                            Store (PMUC, Local1)
                            And (Local1, 0x12, Local1)
                            Decrement (Local6)
                        }

                        Store (PMUC, Local1)
                        And (Local1, 0x20, Local1)
                        If (LEqual (Local1, Zero))
                        {
                            Store (One, EDFG)
                        }

                        Decrement (RECT)
                    }

                    Release (ELCK)
                }

                Method (WCM2, 2, NotSerialized)
                {
                    Store (Arg0, Local0)
                    Store (Arg1, Local1)
                    Store (Arg1, Local2)
                    And (Local1, 0xFF, Local1)
                    And (Local2, 0xFF00, Local2)
                    ShiftRight (Local2, 0x08, Local2)
                    Store (Local0, PMUC)
                    If (WIBF ())
                    {
                        Return (One)
                    }

                    Store (Local2, PMUD)
                    If (WIBF ())
                    {
                        Return (One)
                    }

                    Store (Local1, PMUD)
                    If (WIBF ())
                    {
                        Return (One)
                    }

                    Return (Zero)
                }

                Name (EDFG, Zero)
                Name (RECT, Zero)
                OperationRegion (DELY, SystemIO, 0xED, One)
                Field (DELY, ByteAcc, NoLock, Preserve)
                {
                    ED,     8
                }

                Method (SMST, 0, NotSerialized)
                {
                    Store (0x10, Local6)
                    Store (PMRD (0x70), Local0)
                    While (LAnd (LNotEqual (Local0, Zero), LNotEqual (Local6, Zero)))
                    {
                        Store (PMRD (0x70), Local0)
                        Decrement (Local6)
                    }

                    Store (0x10, Local6)
                    Store (PMRD (0x71), Local1)
                    While (LAnd (LNotEqual (Local1, 0x80), LNotEqual (Local6, Zero)))
                    {
                        Store (PMRD (0x71), Local1)
                        Decrement (Local6)
                    }
                }

                Method (SMWT, 3, NotSerialized)
                {
                    Acquire (ELCK, 0xFFFF)
                    Store (0x06, Local6)
                    Store (Arg0, Local0)
                    Store (Arg1, Local1)
                    Store (Arg2, Local2)
                    While (LNotEqual (Local6, Zero))
                    {
                        PMWT (0x71, Zero)
                        PMWT (0x72, Local0)
                        PMWT (0x73, Local1)
                        PMWT (0x74, Local2)
                        PMWT (0x70, 0x06)
                        SMST ()
                        Decrement (Local6)
                    }

                    Release (ELCK)
                }

                Method (SMWD, 4, NotSerialized)
                {
                    Acquire (ELCK, 0xFFFF)
                    Store (0x06, Local6)
                    Store (Arg0, Local0)
                    Store (Arg1, Local1)
                    Store (Arg2, Local2)
                    Store (Arg3, Local3)
                    While (LNotEqual (Local6, Zero))
                    {
                        PMWT (0x71, Zero)
                        PMWT (0x72, Local0)
                        PMWT (0x73, Local1)
                        PMWT (0x74, Local2)
                        PMWT (0x75, Local3)
                        PMWT (0x70, 0x08)
                        SMST ()
                        Decrement (Local6)
                    }

                    Release (ELCK)
                }

                Device (KBEC)
                {
                    Name (_HID, EisaId ("PNP0C09"))
                    Name (_UID, One)
                    Method (_CRS, 0, NotSerialized)
                    {
                        Name (BFFR, ResourceTemplate ()
                        {
                            IO (Decode16,
                                0x0062,             // Range Minimum
                                0x0062,             // Range Maximum
                                0x00,               // Alignment
                                0x01,               // Length
                                )
                            IO (Decode16,
                                0x0066,             // Range Minimum
                                0x0066,             // Range Maximum
                                0x00,               // Alignment
                                0x01,               // Length
                                )
                        })
                        Return (BFFR)
                    }

                    Method (_REG, 2, NotSerialized)
                    {
                    }

                    OperationRegion (ERAM, EmbeddedControl, Zero, 0x0100)
                    Field (ERAM, ByteAcc, NoLock, Preserve)
                    {
                        ECTM,   8, 
                        SCIC,   8, 
                        SCIP,   8, 
                                Offset (0x04), 
                        CMCM,   8, 
                        CMD1,   8, 
                        CMD2,   8, 
                        CMD3,   8, 
                                Offset (0x18), 
                        SMPR,   8, 
                        SMST,   8, 
                        SMAD,   8, 
                        SMCM,   8, 
                        SMD0,   264, 
                        SMAA,   8, 
                                Offset (0x49), 
                        P55S,   8, 
                                Offset (0x4E), 
                            ,   5, 
                        P55,    1, 
                                Offset (0x50), 
                        P60S,   8, 
                        P61S,   8, 
                        P62S,   8, 
                        P63S,   8, 
                        P64S,   8, 
                        P65S,   8, 
                        P66S,   8, 
                        P67S,   8, 
                                Offset (0x78), 
                        P60,    1, 
                        P61,    1, 
                        P62,    1, 
                        P63,    1, 
                        P64,    1, 
                        P65,    1, 
                        P66,    1, 
                        P67,    1, 
                                Offset (0x80), 
                        TMST,   8, 
                                Offset (0x83), 
                        TMVL,   8, 
                        TMLW,   8, 
                        TMHG,   8, 
                        TMTK,   8, 
                        TMCT,   8, 
                        T1ST,   8, 
                                Offset (0x8B), 
                        T1VL,   8, 
                        T1LW,   8, 
                        T1HG,   8, 
                        T1TK,   8, 
                        T1CT,   8, 
                        T2ST,   8, 
                                Offset (0x93), 
                        T2VL,   8, 
                        T2LW,   8, 
                        T2HG,   8, 
                        T2TK,   8, 
                        T2CT,   8
                    }

                    Method (RAMR, 1, NotSerialized)
                    {
                        If (LGreater (Arg0, 0x7F))
                        {
                            Store (0x04, CMD3)
                        }

                        Store (Arg0, CMD2)
                        Store (0xBA, CMCM)
                        Return (CMD1)
                    }

                    Method (RAMW, 2, NotSerialized)
                    {
                        If (LGreater (Arg0, 0x7F))
                        {
                            Store (0x04, CMD3)
                        }

                        Store (Arg0, CMD2)
                        Store (Arg1, CMD1)
                        Store (0xBB, CMCM)
                    }

                    Name (_GPE, 0x17)
                    Method (_Q0A, 0, NotSerialized)
                    {
                        P8XH (Zero, 0xF1)
                        Store (0x61, SSMP)
                    }

                    Method (_Q0B, 0, NotSerialized)
                    {
                        P8XH (Zero, 0xF2)
                        Store (0x63, SSMP)
                    }

                    Method (_Q0C, 0, NotSerialized)
                    {
                        P8XH (Zero, 0xF3)
                    }

                    Method (_Q0D, 0, NotSerialized)
                    {
                        P8XH (Zero, 0xF4)
                    }

                    Method (_Q0E, 0, NotSerialized)
                    {
                        P8XH (Zero, 0xF5)
                    }

                    Method (_Q0F, 0, NotSerialized)
                    {
                        P8XH (Zero, 0xF6)
                    }

                    Method (_Q10, 0, NotSerialized)
                    {
                        P8XH (Zero, 0xF7)
                        Store (0x62, SSMP)
                    }

                    Method (_Q11, 0, NotSerialized)
                    {
                        P8XH (Zero, 0xF8)
                        If (_OSI ("Windows 2006"))
                        {
                            BRTN (0x87)
                            Notify (^^^P0P2.PEGP.LCD, 0x87)
                        }
                        Else
                        {
                            PHSR (0x81)
                        }
                    }

                    Method (_Q12, 0, NotSerialized)
                    {
                        P8XH (Zero, 0xF9)
                        If (_OSI ("Windows 2006"))
                        {
                            BRTN (0x86)
                            Notify (^^^P0P2.PEGP.LCD, 0x86)
                        }
                        Else
                        {
                            PHSR (0x82)
                        }
                    }

                    Method (_Q13, 0, NotSerialized)
                    {
                        P8XH (Zero, 0xFA)
                        If (LEqual (GP13, Zero))
                        {
                            If (LEqual (HBEN, One))
                            {
                                Notify (GFX0, Zero)
                            }

                            ^^^GFX0.GHDS (One)
                        }
                        Else
                        {
                            If (LEqual (HBEN, One))
                            {
                                Notify (GFX0, 0x80)
                            }
                            Else
                            {
                                PHSR (0x80)
                                Store (INF, Local0)
                                And (Local0, 0x0F, Local0)
                                Store (INF, Local1)
                                And (Local1, 0xF0, Local1)
                                ShiftRight (Local1, 0x04, Local1)
                                If (LEqual (Local0, One))
                                {
                                    Store (Zero, ^^^P0P2.PEGP.CRTA)
                                    Store (One, ^^^P0P2.PEGP.LCDA)
                                    Store (Zero, ^^^P0P2.PEGP.TVAT)
                                }

                                If (LEqual (Local0, 0x02))
                                {
                                    Store (One, ^^^P0P2.PEGP.CRTA)
                                    Store (Zero, ^^^P0P2.PEGP.LCDA)
                                    Store (Zero, ^^^P0P2.PEGP.TVAT)
                                }

                                If (LEqual (Local0, 0x03))
                                {
                                    If (LEqual (Local1, One))
                                    {
                                        Store (One, ^^^P0P2.PEGP.CRTA)
                                        Store (Zero, ^^^P0P2.PEGP.LCDA)
                                        Store (Zero, ^^^P0P2.PEGP.TVAT)
                                    }

                                    If (LEqual (Local1, 0x02))
                                    {
                                        Store (One, ^^^P0P2.PEGP.CRTA)
                                        Store (One, ^^^P0P2.PEGP.LCDA)
                                        Store (Zero, ^^^P0P2.PEGP.TVAT)
                                    }

                                    If (LEqual (Local1, 0x03))
                                    {
                                        Store (Zero, ^^^P0P2.PEGP.CRTA)
                                        Store (One, ^^^P0P2.PEGP.LCDA)
                                        Store (Zero, ^^^P0P2.PEGP.TVAT)
                                    }
                                }

                                If (LEqual (Local0, 0x04))
                                {
                                    Store (Zero, ^^^P0P2.PEGP.CRTA)
                                    Store (Zero, ^^^P0P2.PEGP.LCDA)
                                    Store (One, ^^^P0P2.PEGP.TVAT)
                                }

                                If (LEqual (Local0, 0x05))
                                {
                                    If (LEqual (Local1, One))
                                    {
                                        Store (Zero, ^^^P0P2.PEGP.CRTA)
                                        Store (Zero, ^^^P0P2.PEGP.LCDA)
                                        Store (One, ^^^P0P2.PEGP.TVAT)
                                    }

                                    If (LEqual (Local1, 0x04))
                                    {
                                        Store (Zero, ^^^P0P2.PEGP.CRTA)
                                        Store (One, ^^^P0P2.PEGP.LCDA)
                                        Store (One, ^^^P0P2.PEGP.TVAT)
                                    }

                                    If (LEqual (Local1, 0x05))
                                    {
                                        Store (Zero, ^^^P0P2.PEGP.CRTA)
                                        Store (One, ^^^P0P2.PEGP.LCDA)
                                        Store (Zero, ^^^P0P2.PEGP.TVAT)
                                    }
                                }

                                If (LEqual (Local0, 0x06))
                                {
                                    If (LEqual (Local1, 0x02))
                                    {
                                        Store (Zero, ^^^P0P2.PEGP.CRTA)
                                        Store (Zero, ^^^P0P2.PEGP.LCDA)
                                        Store (One, ^^^P0P2.PEGP.TVAT)
                                    }

                                    If (LEqual (Local1, 0x04))
                                    {
                                        Store (One, ^^^P0P2.PEGP.CRTA)
                                        Store (Zero, ^^^P0P2.PEGP.LCDA)
                                        Store (One, ^^^P0P2.PEGP.TVAT)
                                    }

                                    If (LEqual (Local1, 0x06))
                                    {
                                        Store (One, ^^^P0P2.PEGP.CRTA)
                                        Store (Zero, ^^^P0P2.PEGP.LCDA)
                                        Store (Zero, ^^^P0P2.PEGP.TVAT)
                                    }
                                }

                                If (LEqual (Local0, 0x07))
                                {
                                    If (LEqual (Local1, One))
                                    {
                                        Store (One, ^^^P0P2.PEGP.CRTA)
                                        Store (Zero, ^^^P0P2.PEGP.LCDA)
                                        Store (Zero, ^^^P0P2.PEGP.TVAT)
                                    }

                                    If (LEqual (Local1, 0x02))
                                    {
                                        Store (Zero, ^^^P0P2.PEGP.CRTA)
                                        Store (Zero, ^^^P0P2.PEGP.LCDA)
                                        Store (One, ^^^P0P2.PEGP.TVAT)
                                    }

                                    If (LEqual (Local1, 0x03))
                                    {
                                        Store (Zero, ^^^P0P2.PEGP.CRTA)
                                        Store (One, ^^^P0P2.PEGP.LCDA)
                                        Store (One, ^^^P0P2.PEGP.TVAT)
                                    }

                                    If (LEqual (Local1, 0x04))
                                    {
                                        Store (One, ^^^P0P2.PEGP.CRTA)
                                        Store (One, ^^^P0P2.PEGP.LCDA)
                                        Store (Zero, ^^^P0P2.PEGP.TVAT)
                                    }

                                    If (LEqual (Local1, 0x05))
                                    {
                                        Store (One, ^^^P0P2.PEGP.CRTA)
                                        Store (Zero, ^^^P0P2.PEGP.LCDA)
                                        Store (One, ^^^P0P2.PEGP.TVAT)
                                    }

                                    If (LEqual (Local1, 0x06))
                                    {
                                        Store (Zero, ^^^P0P2.PEGP.CRTA)
                                        Store (One, ^^^P0P2.PEGP.LCDA)
                                        Store (Zero, ^^^P0P2.PEGP.TVAT)
                                    }
                                }

                                Notify (^^^P0P2.PEGP, 0x80)
                            }
                        }
                    }

                    Method (_Q14, 0, NotSerialized)
                    {
                        P8XH (Zero, 0xFB)
                    }

                    Method (_Q15, 0, NotSerialized)
                    {
                        P8XH (Zero, 0xFC)
                        Notify (SLPB, 0x80)
                    }
                }

                Device (PS2K)
                {
                    Name (_HID, EisaId ("PNP0303"))
                    Name (_CRS, ResourceTemplate ()
                    {
                        IO (Decode16,
                            0x0060,             // Range Minimum
                            0x0060,             // Range Maximum
                            0x01,               // Alignment
                            0x01,               // Length
                            )
                        IO (Decode16,
                            0x0064,             // Range Minimum
                            0x0064,             // Range Maximum
                            0x01,               // Alignment
                            0x01,               // Length
                            )
                        IRQ (Edge, ActiveHigh, Exclusive, )
                            {1}
                    })
                    Name (_PRS, ResourceTemplate ()
                    {
                        StartDependentFn (0x00, 0x00)
                        {
                            FixedIO (
                                0x0060,             // Address
                                0x01,               // Length
                                )
                            FixedIO (
                                0x0064,             // Address
                                0x01,               // Length
                                )
                            IRQNoFlags ()
                                {1}
                        }
                        EndDependentFn ()
                    })
                }

                Device (PS2M)
                {
                    Name (_HID, EisaId ("PNP0F13"))
                    Name (_CRS, ResourceTemplate ()
                    {
                        IRQ (Edge, ActiveHigh, Exclusive, )
                            {12}
                    })
                    Name (_PRS, ResourceTemplate ()
                    {
                        StartDependentFn (0x00, 0x00)
                        {
                            IRQNoFlags ()
                                {12}
                        }
                        EndDependentFn ()
                    })
                }
            }

            Device (USB0)
            {
                Name (_ADR, 0x001D0000)
                OperationRegion (U1CS, PCI_Config, 0xC4, 0x04)
                Field (U1CS, DWordAcc, NoLock, Preserve)
                {
                    U1EN,   2
                }

                Method (_PSW, 1, NotSerialized)
                {
                    If (Arg0)
                    {
                        Store (0x03, U1EN)
                    }
                    Else
                    {
                        Store (Zero, U1EN)
                    }
                }

                Method (_S3D, 0, NotSerialized)
                {
                    Return (0x02)
                }

                Method (_S4D, 0, NotSerialized)
                {
                    Return (0x02)
                }

                Name (_PRW, Package (0x02)
                {
                    0x03, 
                    0x03
                })
            }

            Device (USB1)
            {
                Name (_ADR, 0x001D0001)
                OperationRegion (U1CS, PCI_Config, 0xC4, 0x04)
                Field (U1CS, DWordAcc, NoLock, Preserve)
                {
                    U1EN,   2
                }

                Method (_PSW, 1, NotSerialized)
                {
                    If (Arg0)
                    {
                        Store (0x03, U1EN)
                    }
                    Else
                    {
                        Store (Zero, U1EN)
                    }
                }

                Method (_S3D, 0, NotSerialized)
                {
                    Return (0x02)
                }

                Method (_S4D, 0, NotSerialized)
                {
                    Return (0x02)
                }

                Name (_PRW, Package (0x02)
                {
                    0x04, 
                    0x03
                })
            }

            Device (USB2)
            {
                Name (_ADR, 0x001D0002)
                OperationRegion (U1CS, PCI_Config, 0xC4, 0x04)
                Field (U1CS, DWordAcc, NoLock, Preserve)
                {
                    U1EN,   2
                }

                Method (_PSW, 1, NotSerialized)
                {
                    If (Arg0)
                    {
                        Store (0x03, U1EN)
                    }
                    Else
                    {
                        Store (Zero, U1EN)
                    }
                }

                Method (_S3D, 0, NotSerialized)
                {
                    Return (0x02)
                }

                Method (_S4D, 0, NotSerialized)
                {
                    Return (0x02)
                }

                Name (_PRW, Package (0x02)
                {
                    0x0C, 
                    0x03
                })
            }

            Device (USBR)
            {
                Name (_ADR, 0x001D0003)
                OperationRegion (U1CS, PCI_Config, 0xC4, 0x04)
                Field (U1CS, DWordAcc, NoLock, Preserve)
                {
                    U1EN,   2
                }

                Method (_PSW, 1, NotSerialized)
                {
                    If (Arg0)
                    {
                        Store (0x03, U1EN)
                    }
                    Else
                    {
                        Store (Zero, U1EN)
                    }
                }

                Method (_S3D, 0, NotSerialized)
                {
                    Return (0x02)
                }

                Method (_S4D, 0, NotSerialized)
                {
                    Return (0x02)
                }

                Name (_PRW, Package (0x02)
                {
                    0x20, 
                    0x03
                })
            }

            Device (EHC1)
            {
                Name (_ADR, 0x001D0007)
                Name (_PRW, Package (0x02)
                {
                    0x0D, 
                    0x03
                })
            }

            Device (USB3)
            {
                Name (_ADR, 0x001A0000)
                OperationRegion (U1CS, PCI_Config, 0xC4, 0x04)
                Field (U1CS, DWordAcc, NoLock, Preserve)
                {
                    U1EN,   2
                }

                Method (_PSW, 1, NotSerialized)
                {
                    If (Arg0)
                    {
                        Store (0x03, U1EN)
                    }
                    Else
                    {
                        Store (Zero, U1EN)
                    }
                }

                Method (_S3D, 0, NotSerialized)
                {
                    Return (0x02)
                }

                Method (_S4D, 0, NotSerialized)
                {
                    Return (0x02)
                }

                Name (_PRW, Package (0x02)
                {
                    0x0E, 
                    0x03
                })
            }

            Device (USB4)
            {
                Name (_ADR, 0x001A0001)
                OperationRegion (U1CS, PCI_Config, 0xC4, 0x04)
                Field (U1CS, DWordAcc, NoLock, Preserve)
                {
                    U1EN,   2
                }

                Method (_PSW, 1, NotSerialized)
                {
                    If (Arg0)
                    {
                        Store (0x03, U1EN)
                    }
                    Else
                    {
                        Store (Zero, U1EN)
                    }
                }

                Method (_S3D, 0, NotSerialized)
                {
                    Return (0x02)
                }

                Method (_S4D, 0, NotSerialized)
                {
                    Return (0x02)
                }

                Name (_PRW, Package (0x02)
                {
                    0x05, 
                    0x03
                })
            }

            Device (USB5)
            {
                Name (_ADR, 0x001A0002)
                OperationRegion (U1CS, PCI_Config, 0xC4, 0x04)
                Field (U1CS, DWordAcc, NoLock, Preserve)
                {
                    U1EN,   2
                }

                Method (_PSW, 1, NotSerialized)
                {
                    If (Arg0)
                    {
                        Store (0x03, U1EN)
                    }
                    Else
                    {
                        Store (Zero, U1EN)
                    }
                }

                Method (_S3D, 0, NotSerialized)
                {
                    Return (0x02)
                }

                Method (_S4D, 0, NotSerialized)
                {
                    Return (0x02)
                }

                Name (_PRW, Package (0x02)
                {
                    0x20, 
                    0x03
                })
            }

            Device (EHC2)
            {
                Name (_ADR, 0x001A0007)
                Name (_PRW, Package (0x02)
                {
                    0x0D, 
                    0x03
                })
            }

            Device (HDEF)
            {
                Name (_ADR, 0x001B0000)
                OperationRegion (HDAR, PCI_Config, 0x4C, 0x10)
                Field (HDAR, WordAcc, NoLock, Preserve)
                {
                    DCKA,   1, 
                            Offset (0x01), 
                    DCKM,   1, 
                        ,   6, 
                    DCKS,   1, 
                            Offset (0x08), 
                        ,   15, 
                    PMES,   1
                }
            }

            Device (RP01)
            {
                Name (_ADR, 0x001C0000)
                OperationRegion (PXCS, PCI_Config, 0x40, 0xC0)
                Field (PXCS, AnyAcc, NoLock, WriteAsZeros)
                {
                            Offset (0x12), 
                        ,   13, 
                    LASX,   1, 
                            Offset (0x1A), 
                    ABPX,   1, 
                        ,   2, 
                    PDCX,   1, 
                        ,   2, 
                    PDSX,   1, 
                            Offset (0x1B), 
                    LSCX,   1, 
                            Offset (0x20), 
                            Offset (0x22), 
                    PSPX,   1, 
                            Offset (0x9C), 
                        ,   30, 
                    HPSX,   1, 
                    PMSX,   1
                }

                Device (PXSX)
                {
                    Name (_ADR, Zero)
                    Name (_PRW, Package (0x02)
                    {
                        0x09, 
                        0x03
                    })
                    OperationRegion (RPE0, PCI_Config, Zero, 0x0100)
                    Field (RPE0, ByteAcc, NoLock, Preserve)
                    {
                                Offset (0x02), 
                        DID,    16
                    }

                    Method (_RMV, 0, NotSerialized)
                    {
                        Return (One)
                    }

                    Method (_STA, 0, NotSerialized)
                    {
                        If (LEqual (DID, 0xFFFF))
                        {
                            Return (Zero)
                        }

                        Return (0x0F)
                    }
                }

                Method (_PRT, 0, NotSerialized)
                {
                    If (PICM)
                    {
                        Return (AR04)
                    }

                    Return (PR04)
                }

                Device (PSL1)
                {
                    Name (_ADR, 0xFFFF)
                }
            }

            Device (RP02)
            {
                Name (_ADR, 0x001C0001)
                OperationRegion (PXCS, PCI_Config, 0x40, 0xC0)
                Field (PXCS, AnyAcc, NoLock, WriteAsZeros)
                {
                            Offset (0x12), 
                        ,   13, 
                    LASX,   1, 
                            Offset (0x1A), 
                    ABPX,   1, 
                        ,   2, 
                    PDCX,   1, 
                        ,   2, 
                    PDSX,   1, 
                            Offset (0x1B), 
                    LSCX,   1, 
                            Offset (0x20), 
                            Offset (0x22), 
                    PSPX,   1, 
                            Offset (0x9C), 
                        ,   30, 
                    HPSX,   1, 
                    PMSX,   1
                }

                Device (PXSX)
                {
                    Name (_ADR, Zero)
                    Name (_PRW, Package (0x02)
                    {
                        0x09, 
                        0x04
                    })
                }

                Method (_PRT, 0, NotSerialized)
                {
                    If (PICM)
                    {
                        Return (AR05)
                    }

                    Return (PR05)
                }
            }

            Device (RP03)
            {
                Name (_ADR, 0x001C0002)
                OperationRegion (PXCS, PCI_Config, 0x40, 0xC0)
                Field (PXCS, AnyAcc, NoLock, WriteAsZeros)
                {
                            Offset (0x12), 
                        ,   13, 
                    LASX,   1, 
                            Offset (0x1A), 
                    ABPX,   1, 
                        ,   2, 
                    PDCX,   1, 
                        ,   2, 
                    PDSX,   1, 
                            Offset (0x1B), 
                    LSCX,   1, 
                            Offset (0x20), 
                            Offset (0x22), 
                    PSPX,   1, 
                            Offset (0x9C), 
                        ,   30, 
                    HPSX,   1, 
                    PMSX,   1
                }

                Device (PXSX)
                {
                    Name (_ADR, Zero)
                    Name (_PRW, Package (0x02)
                    {
                        0x09, 
                        0x04
                    })
                }

                Method (_PRT, 0, NotSerialized)
                {
                    If (PICM)
                    {
                        Return (AR06)
                    }

                    Return (PR06)
                }
            }

            Device (RP04)
            {
                Name (_ADR, 0x001C0003)
                OperationRegion (PXCS, PCI_Config, 0x40, 0xC0)
                Field (PXCS, AnyAcc, NoLock, WriteAsZeros)
                {
                            Offset (0x12), 
                        ,   13, 
                    LASX,   1, 
                            Offset (0x1A), 
                    ABPX,   1, 
                        ,   2, 
                    PDCX,   1, 
                        ,   2, 
                    PDSX,   1, 
                            Offset (0x1B), 
                    LSCX,   1, 
                            Offset (0x20), 
                            Offset (0x22), 
                    PSPX,   1, 
                            Offset (0x9C), 
                        ,   30, 
                    HPSX,   1, 
                    PMSX,   1
                }

                Device (PXSX)
                {
                    Name (_ADR, Zero)
                    Name (_PRW, Package (0x02)
                    {
                        0x09, 
                        0x04
                    })
                }

                Method (_PRT, 0, NotSerialized)
                {
                    If (PICM)
                    {
                        Return (AR07)
                    }

                    Return (PR07)
                }
            }

            Device (RP05)
            {
                Name (_ADR, 0x001C0004)
                OperationRegion (PXCS, PCI_Config, 0x40, 0xC0)
                Field (PXCS, AnyAcc, NoLock, WriteAsZeros)
                {
                            Offset (0x12), 
                        ,   13, 
                    LASX,   1, 
                            Offset (0x1A), 
                    ABPX,   1, 
                        ,   2, 
                    PDCX,   1, 
                        ,   2, 
                    PDSX,   1, 
                            Offset (0x1B), 
                    LSCX,   1, 
                            Offset (0x20), 
                            Offset (0x22), 
                    PSPX,   1, 
                            Offset (0x9C), 
                        ,   30, 
                    HPSX,   1, 
                    PMSX,   1
                }

                Device (PXSX)
                {
                    Name (_ADR, Zero)
                    Name (_PRW, Package (0x02)
                    {
                        0x09, 
                        0x04
                    })
                }

                Method (_PRT, 0, NotSerialized)
                {
                    If (PICM)
                    {
                        Return (AR08)
                    }

                    Return (PR08)
                }
            }

            Device (RP06)
            {
                Name (_ADR, 0x001C0005)
                OperationRegion (PXCS, PCI_Config, 0x40, 0xC0)
                Field (PXCS, AnyAcc, NoLock, WriteAsZeros)
                {
                            Offset (0x12), 
                        ,   13, 
                    LASX,   1, 
                            Offset (0x1A), 
                    ABPX,   1, 
                        ,   2, 
                    PDCX,   1, 
                        ,   2, 
                    PDSX,   1, 
                            Offset (0x1B), 
                    LSCX,   1, 
                            Offset (0x20), 
                            Offset (0x22), 
                    PSPX,   1, 
                            Offset (0x9C), 
                        ,   30, 
                    HPSX,   1, 
                    PMSX,   1
                }

                Device (PXSX)
                {
                    Name (_ADR, Zero)
                    Name (_PRW, Package (0x02)
                    {
                        0x09, 
                        0x04
                    })
                }
            }

            Device (GLAN)
            {
                Name (_ADR, 0x00190000)
                Name (_PRW, Package (0x02)
                {
                    0x0D, 
                    0x04
                })
            }
        }
    }

    Scope (_PR)
    {
        Processor (CPU0, 0x00, 0x00000410, 0x06) {}
        Processor (CPU1, 0x01, 0x00000410, 0x06) {}
        Processor (CPU2, 0x02, 0x00000410, 0x06) {}
        Processor (CPU3, 0x03, 0x00000410, 0x06) {}
    }

    Mutex (MUTX, 0x00)
    OperationRegion (PRT0, SystemIO, 0x80, 0x04)
    Field (PRT0, DWordAcc, Lock, Preserve)
    {
        P80H,   32
    }

    OperationRegion (THRO, SystemIO, 0x0410, One)
    Field (THRO, ByteAcc, NoLock, Preserve)
    {
        THRG,   8
    }

    Method (P8XH, 2, Serialized)
    {
        If (LEqual (Arg0, Zero))
        {
            Store (Or (And (P80D, 0xFFFFFF00), Arg1), P80D)
        }

        If (LEqual (Arg0, One))
        {
            Store (Or (And (P80D, 0xFFFF00FF), ShiftLeft (Arg1, 0x08)
                ), P80D)
        }

        If (LEqual (Arg0, 0x02))
        {
            Store (Or (And (P80D, 0xFF00FFFF), ShiftLeft (Arg1, 0x10)
                ), P80D)
        }

        If (LEqual (Arg0, 0x03))
        {
            Store (Or (And (P80D, 0x00FFFFFF), ShiftLeft (Arg1, 0x18)
                ), P80D)
        }

        Store (P80D, P80H)
    }

    OperationRegion (SPRT, SystemIO, 0xB2, 0x02)
    Field (SPRT, ByteAcc, Lock, Preserve)
    {
        SSMP,   8
    }

    Method (_PIC, 1, NotSerialized)
    {
        Store (Arg0, GPIC)
        Store (Arg0, PICM)
    }

    Method (_PTS, 1, NotSerialized)
    {
        Store (Zero, P80D)
        P8XH (Zero, Arg0)
        Store (0x6D, SSMP)
        If (LEqual (Arg0, 0x03))
        {
            If (LAnd (DTSE, MPEN))
            {
                TRAP (TRTD, 0x1E)
            }

            And (\_SB.PCI0.LPCB.PMRD (0xF2), One, Local3)
            If (Local3) {}
            Else
            {
                And (\_SB.PCI0.LPCB.PMRD (0xB8), 0xFE, Local1)
                \_SB.PCI0.LPCB.PMWT (0xB8, Local1)
            }
        }

        If (LEqual (Arg0, 0x05))
        {
            Name (TTMP, Buffer (One)
            {
                0x00
            })
            CreateByteField (TTMP, Zero, TMPV)
            Not (\_SB.TMOR, TMPV)
            And (TMPV, \_SB.TPP3, TMPV)
            Store (TMPV, \_SB.TPP3)
        }
    }

    Method (_WAK, 1, NotSerialized)
    {
        P8XH (One, 0xAB)
        Store (One, \_SB.LID.LIDF)
        Store (0x6F, SSMP)
        If (LEqual (Arg0, 0x03))
        {
            Store (0x6C, SSMP)
            And (\_SB.PCI0.LPCB.PMRD (0xF2), One, Local3)
            If (Local3)
            {
                \_SB.PCI0.LPCB.PMWT (0xF2, Zero)
            }
            Else
            {
                Or (\_SB.PCI0.LPCB.PMRD (0xB8), One, Local1)
                \_SB.PCI0.LPCB.PMWT (0xB8, Local1)
                \_SB.PCI0.LPCB.PMWT (0xF2, Zero)
            }
        }

        If (LOr (LEqual (Arg0, 0x03), LEqual (Arg0, 0x04)))
        {
            If (LAnd (DTSE, MPEN))
            {
                TRAP (TRTD, 0x14)
            }

            If (And (CFGD, 0x01000000))
            {
                If (LAnd (And (CFGD, 0xF0), LAnd (LEqual (OSYS, 0x07D1), 
                    LNot (And (PDC0, 0x10)))))
                {
                    TRAP (TRTP, ESCS)
                }
            }

            If (LEqual (OSYS, 0x07D2))
            {
                If (And (CFGD, One))
                {
                    If (LGreater (\_PR.CPU0._PPC, Zero))
                    {
                        Subtract (\_PR.CPU0._PPC, One, \_PR.CPU0._PPC)
                        PNOT ()
                        Add (\_PR.CPU0._PPC, One, \_PR.CPU0._PPC)
                        PNOT ()
                    }
                    Else
                    {
                        Add (\_PR.CPU0._PPC, One, \_PR.CPU0._PPC)
                        PNOT ()
                        Subtract (\_PR.CPU0._PPC, One, \_PR.CPU0._PPC)
                        PNOT ()
                    }
                }
            }
        }

        If (LEqual (Arg0, 0x04))
        {
            Notify (\_SB.PWRB, 0x02)
        }

        Return (Package (0x02)
        {
            Zero, 
            Zero
        })
    }

    Method (GETB, 3, Serialized)
    {
        Multiply (Arg0, 0x08, Local0)
        Multiply (Arg1, 0x08, Local1)
        CreateField (Arg2, Local0, Local1, TBF3)
        Return (TBF3)
    }

    Method (PNOT, 0, Serialized)
    {
        If (MPEN)
        {
            If (And (PDC0, 0x08))
            {
                Notify (\_PR.CPU0, 0x80)
                If (And (PDC0, 0x10))
                {
                    Sleep (0x64)
                    Notify (\_PR.CPU0, 0x81)
                }
            }

            If (And (PDC1, 0x08))
            {
                Notify (\_PR.CPU1, 0x80)
                If (And (PDC1, 0x10))
                {
                    Sleep (0x64)
                    Notify (\_PR.CPU1, 0x81)
                }
            }
        }
        Else
        {
            Notify (\_PR.CPU0, 0x80)
            Sleep (0x64)
            Notify (\_PR.CPU0, 0x81)
        }
    }

    Method (TRAP, 2, Serialized)
    {
        Store (Arg1, SMIF)
        If (LEqual (Arg0, TRTP))
        {
            Store (Zero, TRPI)
        }

        If (LEqual (Arg0, TRTD))
        {
            Store (Arg1, DTSF)
            Store (Zero, TRPD)
            Return (DTSF)
        }

        If (LEqual (Arg0, TRTI))
        {
            Store (Zero, TRP0)
        }

        Return (SMIF)
    }

    Scope (_SB.PCI0)
    {
        Method (_INI, 0, NotSerialized)
        {
            Store (0x07D0, OSYS)
            If (CondRefOf (_OSI, Local0))
            {
                If (_OSI ("Linux"))
                {
                    Store (0x03E8, OSYS)
                }

                If (_OSI ("Windows 2001"))
                {
                    Store (0x07D1, OSYS)
                }

                If (_OSI ("Windows 2001 SP1"))
                {
                    Store (0x07D1, OSYS)
                }

                If (_OSI ("Windows 2001 SP2"))
                {
                    Store (0x07D2, OSYS)
                }

                If (_OSI ("Windows 2006"))
                {
                    Store (0x07D6, OSYS)
                }

                If (LAnd (MPEN, LEqual (OSYS, 0x07D1)))
                {
                    TRAP (TRTP, \ESCS)
                }

                TRAP (TRTI, SOOT)
            }

            ^GFX0.GLID (One)
            Store (^P0P2.PEGP.R000, DB00)
            Store (^P0P2.PEGP.R004, DB04)
            Store (^P0P2.PEGP.R008, DB08)
            Store (^P0P2.PEGP.R00C, DB0C)
            Store (^P0P2.PEGP.R010, DB10)
            Store (^P0P2.PEGP.R014, DB14)
            Store (^P0P2.PEGP.R018, DB18)
            Store (^P0P2.PEGP.R01C, DB1C)
            Store (^P0P2.PEGP.R020, DB20)
            Store (^P0P2.PEGP.R024, DB24)
            Store (^P0P2.PEGP.R028, DB28)
            Store (^P0P2.PEGP.R02C, DB2C)
            Store (^P0P2.PEGP.R030, DB30)
            Store (^P0P2.PEGP.R034, DB34)
            Store (^P0P2.PEGP.R038, DB38)
            Store (^P0P2.PEGP.R03C, DB3C)
            Store (^P0P2.PEGP.R040, DB40)
            ^P0P2.PEGP.VOUP ()
            Sleep (0x01F4)
            Store (0x6E, SSMP)
        }
    }

    Scope (\)
    {
        Name (PICM, Zero)
    }

    Scope (_TZ)
    {
        Mutex (TZ0, 0x00)
        ThermalZone (TZ00)
        {
            Name (THIN, One)
            Name (CNTR, Zero)
            Name (TERR, Zero)
            Method (_CRT, 0, Serialized)
            {
                Store (\_SB.PCI0.LPCB.PMRD (0xE8), Local0)
                Add (Local0, 0x0112, Local0)
                Multiply (Local0, 0x0A, Local0)
                Return (Local0)
            }

            Method (_TMP, 0, NotSerialized)
            {
                If (THIN)
                {
                    TCHK ()
                }

                If (TERR)
                {
                    Store (Zero, TERR)
                    Store (\_SB.PCI0.LPCB.PMRD (0xF3), Local0)
                    Add (Local0, 0x0112, Local0)
                    Multiply (Local0, 0x0A, Local0)
                    Return (Local0)
                }
                Else
                {
                    Store (\_SB.PCI0.LPCB.PMRD (0xE7), Local0)
                    If (LLess (Local0, 0x03))
                    {
                        \_SB.PCI0.LPCB.PMMW (0x043F, 0xAA)
                        \_SB.PCI0.LPCB.PMMW (0x01E8, Zero)
                        Return (0x0B72)
                    }

                    If (LGreater (Local0, 0x6D))
                    {
                        Add (CNTR, One, CNTR)
                        If (LNotEqual (CNTR, 0x03))
                        {
                            Return (0x0E2E)
                        }
                    }

                    Store (Zero, CNTR)
                    Multiply (Local0, 0x0A, Local0)
                    Add (Local0, 0x0AAA, Local0)
                    If (LGreater (Local0, 0x127A))
                    {
                        Return (0x0E2E)
                    }

                    Return (Local0)
                }
            }

            Name (SKEY, Zero)
            Method (TCHK, 0, NotSerialized)
            {
                Acquire (TZ0, 0xFFFF)
                Store (THRG, Local0)
                And (Local0, 0x04, SPDF)
                If (THIN)
                {
                    Store (Zero, THIN)
                }

                Store (\_SB.PCI0.LPCB.PMRD (0xAF), Local7)
                And (Local7, 0x04, Local7)
                If (LNotEqual (Local7, Zero))
                {
                    \_SB.PCI0.LPCB.PMMW (0x043F, 0xAA)
                    \_SB.PCI0.LPCB.PMMW (0x01E8, Zero)
                    Store (One, TERR)
                }
                Else
                {
                    Store (0x6B, SSMP)
                    Notify (TZ00, 0x81)
                }

                Notify (TZ00, 0x80)
                Notify (\_PR.CPU0, 0x80)
                Release (TZ0)
            }

            Method (_PSL, 0, Serialized)
            {
                Return (Package (0x02)
                {
                    \_PR.CPU0, 
                    \_PR.CPU1
                })
                If (MPEN)
                {
                    Return (Package (0x02)
                    {
                        \_PR.CPU0, 
                        \_PR.CPU1
                    })
                }

                Return (Package (0x01)
                {
                    \_PR.CPU0
                })
            }

            Method (_PSV, 0, Serialized)
            {
                Store (\_SB.PCI0.LPCB.PMRD (0xF4), Local0)
                Add (Local0, 0x0112, Local0)
                Multiply (Local0, 0x0A, Local0)
                Return (Local0)
            }

            Method (_TC1, 0, Serialized)
            {
                Return (Zero)
            }

            Method (_TC2, 0, Serialized)
            {
                Return (0x0A)
            }

            Method (_TSP, 0, Serialized)
            {
                Return (0x32)
            }
        }
    }

    Scope (_SB.PCI0)
    {
        Device (PDRC)
        {
            Name (_HID, EisaId ("PNP0C02"))
            Name (_UID, One)
            Name (BUF0, ResourceTemplate ()
            {
                Memory32Fixed (ReadWrite,
                    0x00000000,         // Address Base
                    0x00004000,         // Address Length
                    )
                Memory32Fixed (ReadWrite,
                    0x00000000,         // Address Base
                    0x00004000,         // Address Length
                    )
                Memory32Fixed (ReadWrite,
                    0x00000000,         // Address Base
                    0x00001000,         // Address Length
                    )
                Memory32Fixed (ReadWrite,
                    0x00000000,         // Address Base
                    0x00001000,         // Address Length
                    )
                Memory32Fixed (ReadWrite,
                    0x00000000,         // Address Base
                    0x00000000,         // Address Length
                    )
                Memory32Fixed (ReadWrite,
                    0xFED20000,         // Address Base
                    0x00020000,         // Address Length
                    )
                Memory32Fixed (ReadWrite,
                    0xFED40000,         // Address Base
                    0x00005000,         // Address Length
                    )
                Memory32Fixed (ReadWrite,
                    0xFED45000,         // Address Base
                    0x0004B000,         // Address Length
                    )
            })
            Method (_CRS, 0, Serialized)
            {
                CreateDWordField (BUF0, 0x04, RBR0)
                ShiftLeft (^^LPCB.RCBA, 0x0E, RBR0)
                CreateDWordField (BUF0, 0x10, MBR0)
                ShiftLeft (MHBR, 0x0E, MBR0)
                CreateDWordField (BUF0, 0x1C, DBR0)
                ShiftLeft (DIBR, 0x0C, DBR0)
                CreateDWordField (BUF0, 0x28, EBR0)
                ShiftLeft (EPBR, 0x0C, EBR0)
                CreateDWordField (BUF0, 0x34, XBR0)
                ShiftLeft (PXBR, 0x1A, XBR0)
                CreateDWordField (BUF0, 0x38, XSZ0)
                ShiftRight (0x10000000, PXSZ, XSZ0)
                Return (BUF0)
            }
        }
    }

    Name (BRTS, Package (0x0A)
    {
        0x28, 
        0x48, 
        0x5C, 
        0x64, 
        0x72, 
        0x80, 
        0x90, 
        0xA8, 
        0xBA, 
        0xC8
    })
    Method (BRTW, 1, Serialized)
    {
        \_SB.PCI0.LPCB.PMWT (0xDF, DerefOf (Index (BRTS, Arg0)))
        Store (Arg0, BRTL)
    }

    Method (HKDS, 1, Serialized)
    {
    }

    Method (LSDS, 1, Serialized)
    {
    }

    Method (BRTN, 1, Serialized)
    {
        Notify (\_SB.PCI0.GFX0.DD02, Arg0)
    }

    Scope (\)
    {
        OperationRegion (IO_T, SystemIO, 0x0480, 0x10)
        Field (IO_T, ByteAcc, NoLock, Preserve)
        {
            TRPI,   16, 
                    Offset (0x04), 
                    Offset (0x06), 
                    Offset (0x08), 
            TRP0,   8, 
                    Offset (0x0A), 
                    Offset (0x0B), 
                    Offset (0x0C), 
                    Offset (0x0D), 
                    Offset (0x0E), 
                    Offset (0x0F), 
                    Offset (0x10)
        }

        OperationRegion (IO_D, SystemIO, 0x0900, 0x04)
        Field (IO_D, ByteAcc, NoLock, Preserve)
        {
            TRPD,   8
        }

        OperationRegion (IO_H, SystemIO, 0x0400, 0x04)
        Field (IO_H, ByteAcc, NoLock, Preserve)
        {
            TRPH,   8
        }

        OperationRegion (PMIO, SystemIO, PMBS, 0x80)
        Field (PMIO, ByteAcc, NoLock, Preserve)
        {
                    Offset (0x28), 
                ,   2, 
            SPST,   1, 
                    Offset (0x42), 
                ,   1, 
            GPEC,   1, 
                    Offset (0x64), 
                ,   9, 
            SCIS,   1, 
                    Offset (0x66)
        }

        OperationRegion (GPIO, SystemIO, GPBS, 0x3C)
        Field (GPIO, ByteAcc, NoLock, Preserve)
        {
            GU00,   8, 
            GU01,   8, 
            GU02,   8, 
            GU03,   8, 
            GIO0,   8, 
            GIO1,   8, 
            GIO2,   8, 
            GIO3,   8, 
                    Offset (0x0C), 
            GL00,   8, 
                ,   5, 
            GP13,   1, 
                    Offset (0x0E), 
                ,   2, 
            GP18,   1, 
            GP19,   1, 
                ,   1, 
            GP21,   1, 
                ,   1, 
            GP23,   1, 
                ,   3, 
            GP27,   1, 
            GP28,   1, 
                    Offset (0x10), 
                    Offset (0x18), 
            GB00,   8, 
            GB01,   8, 
            GB02,   8, 
            GB03,   8, 
                    Offset (0x2C), 
            GIV0,   8, 
            GIV1,   8, 
            GIV2,   8, 
            GIV3,   8, 
            GU04,   8, 
            GU05,   8, 
            GU06,   8, 
            GU07,   8, 
            GIO4,   8, 
            GIO5,   8, 
            GIO6,   8, 
            GIO7,   8, 
                ,   4, 
            GP36,   1, 
            GP37,   1, 
                    Offset (0x39), 
                ,   6, 
            GP46,   1, 
                    Offset (0x3A), 
                ,   5, 
            GP53,   1, 
                    Offset (0x3B), 
            GL07,   8
        }

        OperationRegion (RCRB, SystemMemory, 0xFED1C000, 0x4000)
        Field (RCRB, DWordAcc, Lock, Preserve)
        {
                    Offset (0x1000), 
                    Offset (0x3000), 
                    Offset (0x3404), 
            HPAS,   2, 
                ,   5, 
            HPAE,   1, 
                    Offset (0x3418), 
                ,   1, 
                ,   1, 
            SATD,   1, 
            SMBD,   1, 
            HDAD,   1, 
                    Offset (0x341A), 
            RP1D,   1, 
            RP2D,   1, 
            RP3D,   1, 
            RP4D,   1, 
            RP5D,   1, 
            RP6D,   1
        }

        Method (GETP, 1, Serialized)
        {
            If (LEqual (And (Arg0, 0x09), Zero))
            {
                Return (0xFFFFFFFF)
            }

            If (LEqual (And (Arg0, 0x09), 0x08))
            {
                Return (0x0384)
            }

            ShiftRight (And (Arg0, 0x0300), 0x08, Local0)
            ShiftRight (And (Arg0, 0x3000), 0x0C, Local1)
            Return (Multiply (0x1E, Subtract (0x09, Add (Local0, Local1))
                ))
        }

        Method (GDMA, 5, Serialized)
        {
            If (Arg0)
            {
                If (LAnd (Arg1, Arg4))
                {
                    Return (0x14)
                }

                If (LAnd (Arg2, Arg4))
                {
                    Return (Multiply (Subtract (0x04, Arg3), 0x0F))
                }

                Return (Multiply (Subtract (0x04, Arg3), 0x1E))
            }

            Return (0xFFFFFFFF)
        }

        Method (GETT, 1, Serialized)
        {
            Return (Multiply (0x1E, Subtract (0x09, Add (And (ShiftRight (Arg0, 0x02
                ), 0x03), And (Arg0, 0x03)))))
        }

        Method (GETF, 3, Serialized)
        {
            Name (TMPF, Zero)
            If (Arg0)
            {
                Or (TMPF, One, TMPF)
            }

            If (And (Arg2, 0x02))
            {
                Or (TMPF, 0x02, TMPF)
            }

            If (Arg1)
            {
                Or (TMPF, 0x04, TMPF)
            }

            If (And (Arg2, 0x20))
            {
                Or (TMPF, 0x08, TMPF)
            }

            If (And (Arg2, 0x4000))
            {
                Or (TMPF, 0x10, TMPF)
            }

            Return (TMPF)
        }

        Method (SETP, 3, Serialized)
        {
            If (LGreater (Arg0, 0xF0))
            {
                Return (0x08)
            }
            Else
            {
                If (And (Arg1, 0x02))
                {
                    If (LAnd (LLessEqual (Arg0, 0x78), And (Arg2, 0x02)))
                    {
                        Return (0x2301)
                    }

                    If (LAnd (LLessEqual (Arg0, 0xB4), And (Arg2, One)))
                    {
                        Return (0x2101)
                    }
                }

                Return (0x1001)
            }
        }

        Method (SDMA, 1, Serialized)
        {
            If (LLessEqual (Arg0, 0x14))
            {
                Return (One)
            }

            If (LLessEqual (Arg0, 0x1E))
            {
                Return (0x02)
            }

            If (LLessEqual (Arg0, 0x2D))
            {
                Return (One)
            }

            If (LLessEqual (Arg0, 0x3C))
            {
                Return (0x02)
            }

            If (LLessEqual (Arg0, 0x5A))
            {
                Return (One)
            }

            Return (Zero)
        }

        Method (SETT, 3, Serialized)
        {
            If (And (Arg1, 0x02))
            {
                If (LAnd (LLessEqual (Arg0, 0x78), And (Arg2, 0x02)))
                {
                    Return (0x0B)
                }

                If (LAnd (LLessEqual (Arg0, 0xB4), And (Arg2, One)))
                {
                    Return (0x09)
                }
            }

            Return (0x04)
        }
    }

    Scope (_SB.PCI0)
    {
        Device (SAT0)
        {
            Name (_ADR, 0x001F0002)
            OperationRegion (SACS, PCI_Config, 0x40, 0xC0)
            Field (SACS, DWordAcc, NoLock, Preserve)
            {
                PRIT,   16, 
                SECT,   16, 
                PSIT,   4, 
                SSIT,   4, 
                        Offset (0x08), 
                SYNC,   4, 
                        Offset (0x0A), 
                SDT0,   2, 
                    ,   2, 
                SDT1,   2, 
                        Offset (0x0B), 
                SDT2,   2, 
                    ,   2, 
                SDT3,   2, 
                        Offset (0x14), 
                ICR0,   4, 
                ICR1,   4, 
                ICR2,   4, 
                ICR3,   4, 
                ICR4,   4, 
                ICR5,   4, 
                        Offset (0x50), 
                MAPV,   2
            }

            Device (CHL5)
            {
                Name (_ADR, 0x05)
                Device (PRT0)
                {
                    Name (_ADR, Zero)
                    Method (_RMV, 0, NotSerialized)
                    {
                        Return (One)
                    }
                }
            }
        }

        Device (SAT1)
        {
            Name (_ADR, 0x001F0005)
            OperationRegion (SACS, PCI_Config, 0x40, 0xC0)
            Field (SACS, DWordAcc, NoLock, Preserve)
            {
                PRIT,   16, 
                SECT,   16, 
                PSIT,   4, 
                SSIT,   4, 
                        Offset (0x08), 
                SYNC,   4, 
                        Offset (0x0A), 
                SDT0,   2, 
                    ,   2, 
                SDT1,   2, 
                        Offset (0x0B), 
                SDT2,   2, 
                    ,   2, 
                SDT3,   2, 
                        Offset (0x14), 
                ICR0,   4, 
                ICR1,   4, 
                ICR2,   4, 
                ICR3,   4, 
                ICR4,   4, 
                ICR5,   4, 
                        Offset (0x50), 
                MAPV,   2
            }
        }

        Device (SBUS)
        {
            Name (_ADR, 0x001F0003)
            OperationRegion (SMBP, PCI_Config, 0x40, 0xC0)
            Field (SMBP, DWordAcc, NoLock, Preserve)
            {
                    ,   2, 
                I2CE,   1
            }

            OperationRegion (SMBI, SystemIO, 0x1C20, 0x10)
            Field (SMBI, ByteAcc, NoLock, Preserve)
            {
                HSTS,   8, 
                        Offset (0x02), 
                HCON,   8, 
                HCOM,   8, 
                TXSA,   8, 
                DAT0,   8, 
                DAT1,   8, 
                HBDR,   8, 
                PECR,   8, 
                RXSA,   8, 
                SDAT,   16
            }

            Method (SSXB, 2, Serialized)
            {
                If (STRT ())
                {
                    Return (Zero)
                }

                Store (Zero, I2CE)
                Store (0xBF, HSTS)
                Store (Arg0, TXSA)
                Store (Arg1, HCOM)
                Store (0x48, HCON)
                If (COMP ())
                {
                    Or (HSTS, 0xFF, HSTS)
                    Return (One)
                }

                Return (Zero)
            }

            Method (SRXB, 1, Serialized)
            {
                If (STRT ())
                {
                    Return (0xFFFF)
                }

                Store (Zero, I2CE)
                Store (0xBF, HSTS)
                Store (Or (Arg0, One), TXSA)
                Store (0x44, HCON)
                If (COMP ())
                {
                    Or (HSTS, 0xFF, HSTS)
                    Return (DAT0)
                }

                Return (0xFFFF)
            }

            Method (SWRB, 3, Serialized)
            {
                If (STRT ())
                {
                    Return (Zero)
                }

                Store (Zero, I2CE)
                Store (0xBF, HSTS)
                Store (Arg0, TXSA)
                Store (Arg1, HCOM)
                Store (Arg2, DAT0)
                Store (0x48, HCON)
                If (COMP ())
                {
                    Or (HSTS, 0xFF, HSTS)
                    Return (One)
                }

                Return (Zero)
            }

            Method (SRDB, 2, Serialized)
            {
                If (STRT ())
                {
                    Return (0xFFFF)
                }

                Store (Zero, I2CE)
                Store (0xBF, HSTS)
                Store (Or (Arg0, One), TXSA)
                Store (Arg1, HCOM)
                Store (0x48, HCON)
                If (COMP ())
                {
                    Or (HSTS, 0xFF, HSTS)
                    Return (DAT0)
                }

                Return (0xFFFF)
            }

            Method (SWRW, 3, Serialized)
            {
                If (STRT ())
                {
                    Return (Zero)
                }

                Store (Zero, I2CE)
                Store (0xBF, HSTS)
                Store (Arg0, TXSA)
                Store (Arg1, HCOM)
                And (Arg2, 0xFF, DAT0)
                And (ShiftRight (Arg2, 0x08), 0xFF, DAT1)
                Store (0x4C, HCON)
                If (COMP ())
                {
                    Or (HSTS, 0xFF, HSTS)
                    Return (One)
                }

                Return (Zero)
            }

            Method (SRDW, 2, Serialized)
            {
                If (STRT ())
                {
                    Return (0xFFFF)
                }

                Store (Zero, I2CE)
                Store (0xBF, HSTS)
                Store (Or (Arg0, One), TXSA)
                Store (Arg1, HCOM)
                Store (0x4C, HCON)
                If (COMP ())
                {
                    Or (HSTS, 0xFF, HSTS)
                    Return (Or (ShiftLeft (DAT1, 0x08), DAT0))
                }

                Return (0xFFFFFFFF)
            }

            Method (SBLW, 4, Serialized)
            {
                If (STRT ())
                {
                    Return (Zero)
                }

                Store (Arg3, I2CE)
                Store (0xBF, HSTS)
                Store (Arg0, TXSA)
                Store (Arg1, HCOM)
                Store (SizeOf (Arg2), DAT0)
                Store (Zero, Local1)
                Store (DerefOf (Index (Arg2, Zero)), HBDR)
                Store (0x54, HCON)
                While (LGreater (SizeOf (Arg2), Local1))
                {
                    Store (0x0FA0, Local0)
                    While (LAnd (LNot (And (HSTS, 0x80)), Local0))
                    {
                        Decrement (Local0)
                        Stall (0x32)
                    }

                    If (LNot (Local0))
                    {
                        KILL ()
                        Return (Zero)
                    }

                    Store (0x80, HSTS)
                    Increment (Local1)
                    If (LGreater (SizeOf (Arg2), Local1))
                    {
                        Store (DerefOf (Index (Arg2, Local1)), HBDR)
                    }
                }

                If (COMP ())
                {
                    Or (HSTS, 0xFF, HSTS)
                    Return (One)
                }

                Return (Zero)
            }

            Method (SBLR, 3, Serialized)
            {
                Name (TBUF, Buffer (0x0100) {})
                If (STRT ())
                {
                    Return (Zero)
                }

                Store (Arg2, I2CE)
                Store (0xBF, HSTS)
                Store (Or (Arg0, One), TXSA)
                Store (Arg1, HCOM)
                Store (0x54, HCON)
                Store (0x0FA0, Local0)
                While (LAnd (LNot (And (HSTS, 0x80)), Local0))
                {
                    Decrement (Local0)
                    Stall (0x32)
                }

                If (LNot (Local0))
                {
                    KILL ()
                    Return (Zero)
                }

                Store (DAT0, Index (TBUF, Zero))
                Store (0x80, HSTS)
                Store (One, Local1)
                While (LLess (Local1, DerefOf (Index (TBUF, Zero))))
                {
                    Store (0x0FA0, Local0)
                    While (LAnd (LNot (And (HSTS, 0x80)), Local0))
                    {
                        Decrement (Local0)
                        Stall (0x32)
                    }

                    If (LNot (Local0))
                    {
                        KILL ()
                        Return (Zero)
                    }

                    Store (HBDR, Index (TBUF, Local1))
                    Store (0x80, HSTS)
                    Increment (Local1)
                }

                If (COMP ())
                {
                    Or (HSTS, 0xFF, HSTS)
                    Return (TBUF)
                }

                Return (Zero)
            }

            Method (STRT, 0, Serialized)
            {
                Store (0xC8, Local0)
                While (Local0)
                {
                    If (And (HSTS, 0x40))
                    {
                        Decrement (Local0)
                        Sleep (One)
                        If (LEqual (Local0, Zero))
                        {
                            Return (One)
                        }
                    }
                    Else
                    {
                        Store (Zero, Local0)
                    }
                }

                Store (0x0FA0, Local0)
                While (Local0)
                {
                    If (And (HSTS, One))
                    {
                        Decrement (Local0)
                        Stall (0x32)
                        If (LEqual (Local0, Zero))
                        {
                            KILL ()
                        }
                    }
                    Else
                    {
                        Return (Zero)
                    }
                }

                Return (One)
            }

            Method (COMP, 0, Serialized)
            {
                Store (0x0FA0, Local0)
                While (Local0)
                {
                    If (And (HSTS, 0x02))
                    {
                        Return (One)
                    }
                    Else
                    {
                        Decrement (Local0)
                        Stall (0x32)
                        If (LEqual (Local0, Zero))
                        {
                            KILL ()
                        }
                    }
                }

                Return (Zero)
            }

            Method (KILL, 0, Serialized)
            {
                Or (HCON, 0x02, HCON)
                Or (HSTS, 0xFF, HSTS)
            }
        }
    }

    Scope (_GPE)
    {
        Mutex (GLCK, 0x00)
        Method (_L01, 0, NotSerialized)
        {
            Add (L01C, One, L01C)
            P8XH (Zero, One)
            P8XH (One, L01C)
            If (LAnd (LEqual (RP1D, Zero), \_SB.PCI0.RP01.HPSX))
            {
                Sleep (0x64)
                If (\_SB.PCI0.RP01.PDCX)
                {
                    Store (One, \_SB.PCI0.RP01.PDCX)
                    Store (One, \_SB.PCI0.RP01.HPSX)
                    Notify (\_SB.PCI0.RP01, Zero)
                }
                Else
                {
                    Store (One, \_SB.PCI0.RP01.HPSX)
                }
            }

            If (LAnd (LEqual (RP2D, Zero), \_SB.PCI0.RP02.HPSX))
            {
                Sleep (0x64)
                If (\_SB.PCI0.RP02.PDCX)
                {
                    Store (One, \_SB.PCI0.RP02.PDCX)
                    Store (One, \_SB.PCI0.RP02.HPSX)
                    Notify (\_SB.PCI0.RP02, Zero)
                }
                Else
                {
                    Store (One, \_SB.PCI0.RP02.HPSX)
                }
            }

            If (LAnd (LEqual (RP3D, Zero), \_SB.PCI0.RP03.HPSX))
            {
                Sleep (0x64)
                If (\_SB.PCI0.RP03.PDCX)
                {
                    Store (One, \_SB.PCI0.RP03.PDCX)
                    Store (One, \_SB.PCI0.RP03.HPSX)
                    Notify (\_SB.PCI0.RP03, Zero)
                }
                Else
                {
                    Store (One, \_SB.PCI0.RP03.HPSX)
                }
            }

            If (LAnd (LEqual (RP4D, Zero), \_SB.PCI0.RP04.HPSX))
            {
                Sleep (0x64)
                If (\_SB.PCI0.RP04.PDCX)
                {
                    Store (One, \_SB.PCI0.RP04.PDCX)
                    Store (One, \_SB.PCI0.RP04.HPSX)
                    Notify (\_SB.PCI0.RP04, Zero)
                }
                Else
                {
                    Store (One, \_SB.PCI0.RP04.HPSX)
                }
            }

            If (LAnd (LEqual (RP5D, Zero), \_SB.PCI0.RP05.HPSX))
            {
                Sleep (0x64)
                If (\_SB.PCI0.RP05.PDCX)
                {
                    Store (One, \_SB.PCI0.RP05.PDCX)
                    Store (One, \_SB.PCI0.RP05.HPSX)
                    Notify (\_SB.PCI0.RP05, Zero)
                }
                Else
                {
                    Store (One, \_SB.PCI0.RP05.HPSX)
                }
            }

            If (LAnd (LEqual (RP6D, Zero), \_SB.PCI0.RP06.HPSX))
            {
                Sleep (0x64)
                If (\_SB.PCI0.RP06.PDCX)
                {
                    Store (One, \_SB.PCI0.RP06.PDCX)
                    Store (One, \_SB.PCI0.RP06.HPSX)
                    Notify (\_SB.PCI0.RP06, Zero)
                }
                Else
                {
                    Store (One, \_SB.PCI0.RP06.HPSX)
                }
            }
        }

        Method (_L06, 0, NotSerialized)
        {
            If (LAnd (\_SB.PCI0.GFX0.GSSE, LNot (GSMI)))
            {
                \_SB.PCI0.GFX0.GSCI ()
            }
            Else
            {
                If (LEqual (And (\_SB.PCI0.ESCS, 0x08), 0x08))
                {
                    Store (One, Local0)
                    Store (\_SB.PCI0.T0IS, \_SB.PCI0.T0IS)
                    Store (\_SB.PCI0.T0IS, Local0)
                    Store (\_SB.PCI0.T1IS, \_SB.PCI0.T1IS)
                    Store (\_SB.PCI0.T1IS, Local0)
                    Store (One, SCIS)
                    Store (One, \_SB.PCI0.GTSE)
                    If (CondRefOf (\_SB.PCI0.TMEM.GPEH))
                    {
                        \_SB.PCI0.TMEM.GPEH ()
                    }
                }
                Else
                {
                    Store (One, SCIS)
                }
            }
        }

        Method (_L07, 0, NotSerialized)
        {
            Store (0x20, \_SB.PCI0.SBUS.HSTS)
        }

        Method (_L08, 0, NotSerialized)
        {
            P8XH (Zero, 0xAD)
            Acquire (GLCK, 0xFFFF)
            Store (\_SB.PCI0.LPCB.PMRD (0xA8), Local0)
            Store (\_SB.PCI0.LPCB.PMRD (0xA9), Local1)
            Store (\_SB.PCI0.LPCB.PMRD (0xAA), Local2)
            If (And (Local0, 0x10, Local3))
            {
                P8XH (Zero, 0xAE)
            }

            If (And (Local0, One, Local3))
            {
                Store (One, \_SB.LID.LIDF)
                Notify (\_SB.LID, 0x80)
                Store (\_SB.PCI0.LPCB.PMRD (0xB8), Local4)
                Store (\_SB.PCI0.LPCB.PMRD (0xB7), Local5)
                And (Local4, 0xFE, Local4)
                \_SB.PCI0.LPCB.PMWT (0xB8, Local4)
                If (And (\_SB.PCI0.LPCB.PMRD (0xB5), One))
                {
                    Store (\_SB.PCI0.LPCB.PMRD (0xB7), Local7)
                    And (Local7, 0xFE, Local7)
                    \_SB.PCI0.LPCB.PMWT (0xB7, Local7)
                    \_SB.PCI0.LPCB.PMWT (0xF2, One)
                    Store (One, \_SB.LID.LIDF)
                }
                Else
                {
                    Store (\_SB.PCI0.LPCB.PMRD (0xB7), Local7)
                    Or (Local7, One, Local7)
                    \_SB.PCI0.LPCB.PMWT (0xB7, Local7)
                    \_SB.PCI0.LPCB.PMWT (0xF2, One)
                    Store (Zero, \_SB.LID.LIDF)
                }

                Store (\_SB.PCI0.LPCB.PMRD (0xA8), Local6)
                And (Local6, 0xFE, Local6)
                \_SB.PCI0.LPCB.PMWT (0xA8, Local6)
                Or (Local4, One, Local4)
                \_SB.PCI0.LPCB.PMWT (0xB8, Local4)
                Notify (\_SB.LID, 0x80)
            }

            And (\_SB.PCI0.LPCB.PMRD (0xAC), 0xEF, Local7)
            \_SB.PCI0.LPCB.PMWT (0xAC, Local7)
            Release (GLCK)
        }

        Method (_L18, 0, NotSerialized)
        {
            P8XH (Zero, 0x18)
            Acquire (GLCK, 0xFFFF)
            Store (\_SB.PCI0.LPCB.PMRD (0xAB), Local0)
            Store (\_SB.PCI0.LPCB.PMRD (0xAF), Local4)
            And (Local4, 0x04, Local7)
            If (LNotEqual (Local7, Zero))
            {
                \_SB.PCI0.LPCB.PMMW (0x043F, 0xAA)
                \_SB.PCI0.LPCB.PMMW (0x01E8, Zero)
            }

            If (LGreaterEqual (Local4, One))
            {
                P8XH (Zero, 0xBB)
                \_TZ.TZ00.TCHK ()
            }

            If (And (Local0, One, Local3))
            {
                And (\_SB.PCI0.LPCB.PMRD (0xAB), 0xFE, Local2)
                \_SB.PCI0.LPCB.PMWT (0xAB, Local2)
                And (\_SB.PCI0.LPCB.PMRD (0xA0), One, PWRS)
                Notify (\_SB.ACAD, 0x80)
                PNOT ()
            }

            If (And (Local0, 0x02, Local3))
            {
                Notify (\_SB.ACAD, 0x80)
                Store (\_SB.PCI0.LPCB.PMRD (0xA1), Local1)
                Store (\_SB.PCI0.LPCB.PMRD (0xF1), Local4)
                If (LNotEqual (And (Local1, One, Local3), And (Local4, One, 
                    Local5)))
                {
                    Store (\_SB.PCI0.LPCB.PMRD (0xA1), Local6)
                    \_SB.PCI0.LPCB.PMWT (0xF1, Local6)
                    Notify (\_SB.BAT0, 0x81)
                }

                If (LNotEqual (And (Local1, 0x02, Local3), And (Local4, 0x02, 
                    Local5)))
                {
                    Store (\_SB.PCI0.LPCB.PMRD (0xA1), Local6)
                    \_SB.PCI0.LPCB.PMWT (0xF1, Local6)
                    Notify (\_SB.BAT0, 0x80)
                }

                If (LNotEqual (And (Local1, 0x04, Local3), And (Local4, 0x04, 
                    Local5)))
                {
                    Store (\_SB.PCI0.LPCB.PMRD (0xA1), Local6)
                    \_SB.PCI0.LPCB.PMWT (0xF1, Local6)
                    Notify (\_SB.BAT0, 0x80)
                }

                If (LNotEqual (And (Local1, 0x08, Local3), And (Local4, 0x08, 
                    Local5)))
                {
                    Store (\_SB.PCI0.LPCB.PMRD (0xA1), Local6)
                    \_SB.PCI0.LPCB.PMWT (0xF1, Local6)
                    Notify (\_SB.BAT0, 0x80)
                }

                If (LNotEqual (And (Local1, 0x10, Local3), And (Local4, 0x10, 
                    Local5)))
                {
                    Store (\_SB.PCI0.LPCB.PMRD (0xA1), Local6)
                    \_SB.PCI0.LPCB.PMWT (0xF1, Local6)
                    Notify (\_SB.BAT0, 0x80)
                }

                If (LNotEqual (And (Local1, 0x20, Local3), And (Local4, 0x20, 
                    Local5)))
                {
                    Store (\_SB.PCI0.LPCB.PMRD (0xA1), Local6)
                    \_SB.PCI0.LPCB.PMWT (0xF1, Local6)
                    Notify (\_SB.BAT0, 0x80)
                }

                If (LNotEqual (And (Local1, 0x40, Local3), And (Local4, 0x40, 
                    Local5)))
                {
                    Store (\_SB.PCI0.LPCB.PMRD (0xA1), Local6)
                    \_SB.PCI0.LPCB.PMWT (0xF1, Local6)
                    Notify (\_SB.BAT0, 0x80)
                }

                If (LNotEqual (And (Local1, 0x80, Local3), And (Local4, 0x80, 
                    Local5)))
                {
                    Store (\_SB.PCI0.LPCB.PMRD (0xA1), Local6)
                    \_SB.PCI0.LPCB.PMWT (0xF1, Local6)
                    Notify (\_SB.BAT0, 0x80)
                }

                And (\_SB.PCI0.LPCB.PMRD (0xAB), 0xFD, Local2)
                \_SB.PCI0.LPCB.PMWT (0xAB, Local2)
            }

            If (And (Local0, 0x08, Local3))
            {
                P8XH (Zero, 0x19)
                Store (One, MMBE)
                And (\_SB.PCI0.LPCB.PMRD (0xAB), 0xF7, Local2)
                \_SB.PCI0.LPCB.PMWT (0xAB, Local2)
                If (LEqual (NVEN, One))
                {
                    Store (Zero, NVEN)
                }
                Else
                {
                    Store (One, NVEN)
                }

                Notify (\_SB.PCI0.GFX0, 0xD0)
            }

            Release (GLCK)
        }

        Method (_L09, 0, NotSerialized)
        {
            Notify (\_SB.PCI0.P0P2, 0x02)
            Notify (\_SB.PCI0.P0P2.PEGP, 0x02)
            Notify (\_SB.PCI0.RP01, 0x02)
            Notify (\_SB.PCI0.RP01.PSL1, 0x02)
            Notify (\_SB.PCI0.RP02, 0x02)
            Notify (\_SB.PCI0.RP03, 0x02)
            Notify (\_SB.PCI0.RP04, 0x02)
            Notify (\_SB.PCI0.RP05, 0x02)
            Notify (\_SB.PCI0.RP06, 0x02)
        }

        Method (_L0B, 0, NotSerialized)
        {
            Notify (\_SB.PCI0.P0P1, 0x02)
        }

        Method (_L03, 0, NotSerialized)
        {
            Notify (\_SB.PCI0.USB0, 0x02)
        }

        Method (_L04, 0, NotSerialized)
        {
            Notify (\_SB.PCI0.USB1, 0x02)
        }

        Method (_L0C, 0, NotSerialized)
        {
            Notify (\_SB.PCI0.USB2, 0x02)
        }

        Method (_L20, 0, NotSerialized)
        {
            Notify (\_SB.PCI0.USBR, 0x02)
            Notify (\_SB.PCI0.USB5, 0x02)
        }

        Method (_L0D, 0, NotSerialized)
        {
            Notify (\_SB.PCI0.EHC1, 0x02)
            Notify (\_SB.PCI0.EHC2, 0x02)
            Notify (\_SB.PCI0.HDEF, 0x02)
            Notify (\_SB.PCI0.GLAN, 0x02)
        }

        Method (_L0E, 0, NotSerialized)
        {
            Notify (\_SB.PCI0.USB3, 0x02)
        }

        Method (_L05, 0, NotSerialized)
        {
            Notify (\_SB.PCI0.USB4, 0x02)
        }
    }

    Name (_S0, Package (0x04)
    {
        Zero, 
        Zero, 
        Zero, 
        Zero
    })
    Name (_S3, Package (0x04)
    {
        0x05, 
        Zero, 
        Zero, 
        Zero
    })
    Name (_S4, Package (0x04)
    {
        0x06, 
        Zero, 
        Zero, 
        Zero
    })
    Name (_S5, Package (0x04)
    {
        0x07, 
        Zero, 
        Zero, 
        Zero
    })
}


--------------060705070103020507050604--



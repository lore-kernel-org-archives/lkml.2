Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072Ab1EALNY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 07:13:24 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:57083 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753206Ab1EALNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 07:13:18 -0400
X-Authenticated: #19862253
X-Provags-ID: V01U2FsdGVkX1+oedIC5rCofb210pVip5t7d6WIHjytqzfRnJv15z
	g3WndBYw+Pq38Z
Date: Sun, 1 May 2011 13:13:03 +0200
From: Cedric Sodhi <manday@gmx.net>
To: linux-kernel@vger.kernel.org
Subject: Re: Status of vgaswitcheroo - Devastating!
Message-ID: <20110501111303.GA2139@fly>
References: <20110430210930.268900@gmx.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="WIyZ46R2i8wDzkSu"
Content-Disposition: inline
In-Reply-To: <20110430210930.268900@gmx.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

With ATI (<M>, +kms) and Intel i915 (<M>, +kms) I manage to boot into console, but ONLY if I blacklist the Intel 
drivers. If I probe the intel driver *WITH* modeset at *ANY* time (on boot by not blacklisting them or later), my screen 
turns black.

Besides, on dmesg I get confirmation, that

VGA switcheroo: detected switching method \_.SB_.PCI0.GFX0.ATPX handle

but I do not get a vgaswitcheroo interface in debugfs of the kernel.

I attached dmesg, so maybe someone spots something.

--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg.log"

Linux version 2.6.39-rc5 (root@fly) (gcc version 4.4.5 (Gentoo 4.4.5 p1.2, pie-0.4.5) ) #2 SMP PREEMPT Sun May 1 09:19:10 CEST 2011
Command line: auto BOOT_IMAGE=Gentoo-39 ro root=801
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009d000 (usable)
 BIOS-e820: 000000000009d000 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000009b63f000 (usable)
 BIOS-e820: 000000009b63f000 - 000000009b6bf000 (reserved)
 BIOS-e820: 000000009b6bf000 - 000000009b7bf000 (ACPI NVS)
 BIOS-e820: 000000009b7bf000 - 000000009b7ff000 (ACPI data)
 BIOS-e820: 000000009b7ff000 - 000000009b800000 (usable)
 BIOS-e820: 000000009b800000 - 00000000a0000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000feb00000 - 00000000feb04000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
 BIOS-e820: 00000000fed10000 - 00000000fed14000 (reserved)
 BIOS-e820: 00000000fed18000 - 00000000fed1a000 (reserved)
 BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000158000000 (usable)
NX (Execute Disable) protection: active
DMI 2.6 present.
DMI: Hewlett-Packard HP TouchSmart tm2 Notebook PC   /1486, BIOS F.23 10/28/2010
e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
No AGP bridge found
last_pfn = 0x158000 max_arch_pfn = 0x400000000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-EFFFF write-through
  F0000-FFFFF write-combining
MTRR variable ranges enabled:
  0 base 000000000 mask F80000000 write-back
  1 base 0FFE00000 mask FFFE00000 write-protect
  2 base 080000000 mask FE0000000 write-back
  3 base 09C000000 mask FFC000000 uncachable
  4 base 09B800000 mask FFF800000 uncachable
  5 base 100000000 mask F80000000 write-back
  6 base 158000000 mask FF8000000 uncachable
  7 base 160000000 mask FE0000000 uncachable
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
last_pfn = 0x9b800 max_arch_pfn = 0x400000000
initial memory mapped : 0 - 20000000
Base memory trampoline at [ffff880000098000] 98000 size 20480
init_memory_mapping: 0000000000000000-000000009b800000
 0000000000 - 009b800000 page 2M
kernel direct mapping tables up to 9b800000 @ 9b63b000-9b63f000
init_memory_mapping: 0000000100000000-0000000158000000
 0100000000 - 0158000000 page 2M
kernel direct mapping tables up to 158000000 @ 157ff9000-158000000
ACPI: RSDP 00000000000fe020 00024 (v02 HP    )
ACPI: XSDT 000000009b7fe120 00094 (v01 HPQOEM SLIC-MPC 00000001      01000013)
ACPI: FACP 000000009b7fc000 000F4 (v04 HP     SLIC-MPC 00000001 MSFT 01000013)
ACPI: DSDT 000000009b7e9000 0FCE7 (v02 HP     SLIC-MPC 00000001 MSFT 01000013)
ACPI: FACS 000000009b75e000 00040
ACPI: ASF! 000000009b7fd000 000A5 (v32 HP     SLIC-MPC 00000001 MSFT 01000013)
ACPI: HPET 000000009b7fb000 00038 (v01 HP     SLIC-MPC 00000001 MSFT 01000013)
ACPI: APIC 000000009b7fa000 0008C (v02 HP     SLIC-MPC 00000001 MSFT 01000013)
ACPI: MCFG 000000009b7f9000 0003C (v01 HP     SLIC-MPC 00000001 MSFT 01000013)
ACPI: SLIC 000000009b7e8000 00176 (v01 HPQOEM SLIC-MPC 00000001 MSFT 01000013)
ACPI: SSDT 000000009b7e6000 01152 (v01 TrmRef PtidDevc 00001000 INTL 20051117)
ACPI: SSDT 000000009b7e5000 00172 (v01  VaRef  Va_Acpi 00003000 INTL 20051117)
ACPI: BOOT 000000009b7e4000 00028 (v01 HP     SLIC-MPC 00000001 MSFT 01000013)
ACPI: SSDT 000000009b7e3000 00C39 (v01 INTEL   SataPri 00001000 INTL 20051117)
ACPI: SSDT 000000009b7e2000 006C5 (v01 INTEL   SataSec 00001000 INTL 20051117)
ACPI: ASPT 000000009b7e1000 00034 (v04 HP     SLIC-MPC 00000001 MSFT 01000013)
ACPI: SSDT 000000009b7e0000 009F1 (v01  PmRef    CpuPm 00003000 INTL 20051117)
ACPI: SSDT 000000009b7de000 01A8F (v01 AmdRef  AmdTabl 00001000 INTL 20051117)
ACPI: Local APIC address 0xfee00000
 [ffffea0000000000-ffffea0004bfffff] PMD -> [ffff880148200000-ffff88014b9fffff] on node 0
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00158000
Movable zone start PFN for each node
early_node_map[4] active PFN ranges
    0: 0x00000010 -> 0x0000009d
    0: 0x00000100 -> 0x0009b63f
    0: 0x0009b7ff -> 0x0009b800
    0: 0x00100000 -> 0x00158000
On node 0 totalpages: 996813
  DMA zone: 56 pages used for memmap
  DMA zone: 5 pages reserved
  DMA zone: 3920 pages, LIFO batch:0
  DMA32 zone: 14280 pages used for memmap
  DMA32 zone: 618104 pages, LIFO batch:31
  Normal zone: 4928 pages used for memmap
  Normal zone: 355520 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x408
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x05] enabled)
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x00] disabled)
ACPI: LAPIC (acpi_id[0x06] lapic_id[0x00] disabled)
ACPI: LAPIC (acpi_id[0x07] lapic_id[0x00] disabled)
ACPI: LAPIC (acpi_id[0x08] lapic_id[0x00] disabled)
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a201 base: 0xfed00000
8 Processors exceeds NR_CPUS limit of 4
SMP: Allowing 4 CPUs, 0 hotplug CPUs
nr_irqs_gsi: 40
PM: Registered nosave memory: 000000000009d000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
PM: Registered nosave memory: 000000009b63f000 - 000000009b6bf000
PM: Registered nosave memory: 000000009b6bf000 - 000000009b7bf000
PM: Registered nosave memory: 000000009b7bf000 - 000000009b7ff000
PM: Registered nosave memory: 000000009b800000 - 00000000a0000000
PM: Registered nosave memory: 00000000a0000000 - 00000000e0000000
PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
PM: Registered nosave memory: 00000000f0000000 - 00000000feb00000
PM: Registered nosave memory: 00000000feb00000 - 00000000feb04000
PM: Registered nosave memory: 00000000feb04000 - 00000000fec00000
PM: Registered nosave memory: 00000000fec00000 - 00000000fec01000
PM: Registered nosave memory: 00000000fec01000 - 00000000fed10000
PM: Registered nosave memory: 00000000fed10000 - 00000000fed14000
PM: Registered nosave memory: 00000000fed14000 - 00000000fed18000
PM: Registered nosave memory: 00000000fed18000 - 00000000fed1a000
PM: Registered nosave memory: 00000000fed1a000 - 00000000fed1c000
PM: Registered nosave memory: 00000000fed1c000 - 00000000fed20000
PM: Registered nosave memory: 00000000fed20000 - 00000000fee00000
PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
PM: Registered nosave memory: 00000000fee01000 - 00000000ffe00000
PM: Registered nosave memory: 00000000ffe00000 - 0000000100000000
Allocating PCI resources starting at a0000000 (gap: a0000000:40000000)
setup_percpu: NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
PERCPU: Embedded 26 pages/cpu @ffff880157c00000 s73856 r8192 d24448 u524288
pcpu-alloc: s73856 r8192 d24448 u524288 alloc=1*2097152
pcpu-alloc: [0] 0 1 2 3 
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 977544
Kernel command line: auto BOOT_IMAGE=Gentoo-39 ro root=801
PID hash table entries: 4096 (order: 3, 32768 bytes)
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Checking aperture...
No AGP bridge found
Memory: 3850396k/5636096k available (3735k kernel code, 1648844k absent, 136856k reserved, 2108k data, 432k init)
SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
Preemptable hierarchical RCU implementation.
	CONFIG_RCU_FANOUT set to non-default value of 32
	RCU-based detection of stalled CPUs is disabled.
	Verbose stalled-CPUs detection is disabled.
NR_IRQS:384
Extended CMOS year: 2000
Console: colour dummy device 80x25
console [tty0] enabled
hpet clockevent registered
Fast TSC calibration using PIT
Detected 1197.111 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 2394.22 BogoMIPS (lpj=4788444)
pid_max: default: 32768 minimum: 301
Mount-cache hash table entries: 256
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 9 MCE banks
CPU0: Thermal monitoring handled by SMI
using mwait in idle threads.
ACPI: Core revision 20110316
Setting APIC routing to flat
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Core(TM) i5 CPU       U 430  @ 1.20GHz stepping 05
Performance Events: PEBS fmt1+, Westmere events, Intel PMU driver.
... version:                3
... bit width:              48
... generic registers:      4
... value mask:             0000ffffffffffff
... max period:             000000007fffffff
... fixed-purpose events:   3
... event mask:             000000070000000f
Booting Node   0, Processors  #1
smpboot cpu 1: start_ip = 98000
CPU1: Thermal monitoring handled by SMI
 #2
smpboot cpu 2: start_ip = 98000
CPU2: Thermal monitoring handled by SMI
 #3 Ok.
smpboot cpu 3: start_ip = 98000
CPU3: Thermal monitoring handled by SMI
Brought up 4 CPUs
Total of 4 processors activated (9576.07 BogoMIPS).
PM: Adding info for No Bus:platform
PM: Registering ACPI NVS region at 9b6bf000 (1048576 bytes)
NET: Registered protocol family 16
PM: Adding info for No Bus:vtcon0
ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
ACPI: bus type pci registered
PM: Adding info for No Bus:id
PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
PCI: Using configuration type 1 for base access
PM: Adding info for No Bus:default
bio: create slab <bio-0> at 0
ACPI: EC: Look up EC in DSDT
ACPI: Executed 1 blocks of module-level executable AML code
[Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
ACPI: SSDT 000000009b691a98 00334 (v01  PmRef  Cpu0Ist 00003000 INTL 20051117)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT           (null) 00334 (v01  PmRef  Cpu0Ist 00003000 INTL 20051117)
ACPI: SSDT 000000009b690018 00891 (v01  PmRef  Cpu0Cst 00003001 INTL 20051117)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT           (null) 00891 (v01  PmRef  Cpu0Cst 00003001 INTL 20051117)
ACPI: SSDT 000000009b691718 00303 (v01  PmRef    ApIst 00003000 INTL 20051117)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT           (null) 00303 (v01  PmRef    ApIst 00003000 INTL 20051117)
ACPI: SSDT 000000009b68fd98 00119 (v01  PmRef    ApCst 00003000 INTL 20051117)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst 00003000 INTL 20051117)
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
PM: Adding info for acpi:LNXSYSTM:00
PM: Adding info for acpi:LNXCPU:00
PM: Adding info for acpi:LNXCPU:01
PM: Adding info for acpi:LNXCPU:02
PM: Adding info for acpi:LNXCPU:03
PM: Adding info for acpi:LNXCPU:04
PM: Adding info for acpi:LNXCPU:05
PM: Adding info for acpi:LNXCPU:06
PM: Adding info for acpi:LNXCPU:07
PM: Adding info for acpi:device:00
PM: Adding info for acpi:PNP0A08:00
PM: Adding info for acpi:LNXVIDEO:00
PM: Adding info for acpi:device:01
PM: Adding info for acpi:device:02
PM: Adding info for acpi:device:03
PM: Adding info for acpi:device:04
PM: Adding info for acpi:device:05
PM: Adding info for acpi:device:06
PM: Adding info for acpi:device:07
PM: Adding info for acpi:device:08
PM: Adding info for acpi:device:09
[Firmware Bug]: ACPI: No _BQC method, cannot determine initial brightness
PM: Adding info for acpi:LNXVIDEO:01
PM: Adding info for acpi:device:0a
PM: Adding info for acpi:device:0b
PM: Adding info for acpi:device:0c
PM: Adding info for acpi:device:0d
PM: Adding info for acpi:device:0e
PM: Adding info for acpi:device:0f
PM: Adding info for acpi:device:10
PM: Adding info for acpi:device:11
PM: Adding info for acpi:device:12
PM: Adding info for acpi:device:13
PM: Adding info for acpi:PNP0C09:00
PM: Adding info for acpi:PNP0200:00
PM: Adding info for acpi:INT0800:00
PM: Adding info for acpi:PNP0103:00
PM: Adding info for acpi:PNP0000:00
PM: Adding info for acpi:PNP0C04:00
PM: Adding info for acpi:PNP0C02:00
PM: Adding info for acpi:PNP0B00:00
PM: Adding info for acpi:PNP0100:00
PM: Adding info for acpi:PNP0303:00
PM: Adding info for acpi:SYN1E2D:00
PM: Adding info for acpi:device:14
PM: Adding info for acpi:device:15
PM: Adding info for acpi:device:16
PM: Adding info for acpi:device:17
PM: Adding info for acpi:device:18
PM: Adding info for acpi:device:19
PM: Adding info for acpi:device:1a
PM: Adding info for acpi:device:1b
PM: Adding info for acpi:device:1c
PM: Adding info for acpi:device:1d
PM: Adding info for acpi:device:1e
PM: Adding info for acpi:device:1f
PM: Adding info for acpi:device:20
PM: Adding info for acpi:device:21
PM: Adding info for acpi:device:22
PM: Adding info for acpi:device:23
PM: Adding info for acpi:device:24
PM: Adding info for acpi:device:25
PM: Adding info for acpi:device:26
PM: Adding info for acpi:device:27
PM: Adding info for acpi:device:28
PM: Adding info for acpi:device:29
PM: Adding info for acpi:device:2a
PM: Adding info for acpi:device:2b
PM: Adding info for acpi:device:2c
PM: Adding info for acpi:device:2d
PM: Adding info for acpi:device:2e
PM: Adding info for acpi:device:2f
PM: Adding info for acpi:device:30
PM: Adding info for acpi:device:31
PM: Adding info for acpi:device:32
PM: Adding info for acpi:device:33
PM: Adding info for acpi:device:34
PM: Adding info for acpi:device:35
PM: Adding info for acpi:device:36
PM: Adding info for acpi:device:37
PM: Adding info for acpi:device:38
PM: Adding info for acpi:device:39
PM: Adding info for acpi:device:3a
PM: Adding info for acpi:device:3b
PM: Adding info for acpi:device:3c
PM: Adding info for acpi:device:3d
PM: Adding info for acpi:device:3e
PM: Adding info for acpi:device:3f
PM: Adding info for acpi:device:40
PM: Adding info for acpi:device:41
PM: Adding info for acpi:device:42
PM: Adding info for acpi:device:43
PM: Adding info for acpi:device:44
PM: Adding info for acpi:device:45
PM: Adding info for acpi:device:46
PM: Adding info for acpi:device:47
PM: Adding info for acpi:device:48
PM: Adding info for acpi:device:49
PM: Adding info for acpi:device:4a
PM: Adding info for acpi:device:4b
PM: Adding info for acpi:device:4c
PM: Adding info for acpi:device:4d
PM: Adding info for acpi:device:4e
PM: Adding info for acpi:device:4f
PM: Adding info for acpi:device:50
PM: Adding info for acpi:device:51
PM: Adding info for acpi:device:52
PM: Adding info for acpi:device:53
PM: Adding info for acpi:device:54
PM: Adding info for acpi:device:55
PM: Adding info for acpi:device:56
PM: Adding info for acpi:device:57
PM: Adding info for acpi:device:58
[Firmware Bug]: ACPI: No _BQC method, cannot determine initial brightness
PM: Adding info for acpi:LNXVIDEO:02
PM: Adding info for acpi:device:59
PM: Adding info for acpi:device:5a
PM: Adding info for acpi:device:5b
PM: Adding info for acpi:device:5c
PM: Adding info for acpi:device:5d
PM: Adding info for acpi:HPQ0004:00
PM: Adding info for acpi:PNP0C02:01
PM: Adding info for acpi:device:5e
PM: Adding info for acpi:INT5400:00
PM: Adding info for acpi:device:5f
PM: Adding info for acpi:device:60
PM: Adding info for acpi:device:61
PM: Adding info for acpi:device:62
PM: Adding info for acpi:device:63
PM: Adding info for acpi:device:64
PM: Adding info for acpi:device:65
PM: Adding info for acpi:device:66
PM: Adding info for acpi:device:67
PM: Adding info for acpi:device:68
PM: Adding info for acpi:device:69
PM: Adding info for acpi:PNP0C0F:00
PM: Adding info for acpi:PNP0C0F:01
PM: Adding info for acpi:PNP0C0F:02
PM: Adding info for acpi:PNP0C0F:03
PM: Adding info for acpi:PNP0C0F:04
PM: Adding info for acpi:PNP0C0F:05
PM: Adding info for acpi:PNP0C0F:06
PM: Adding info for acpi:PNP0C0F:07
PM: Adding info for acpi:PNP0C0D:00
PM: Adding info for acpi:PNP0C0C:00
PM: Adding info for acpi:PNP0C0A:00
PM: Adding info for acpi:ACPI0003:00
PM: Adding info for acpi:PNP0C14:00
PM: Adding info for acpi:PNP0A03:00
PM: Adding info for acpi:device:6a
PM: Adding info for acpi:INT340E:00
PM: Adding info for acpi:device:6b
PM: Adding info for acpi:LNXPOWER:00
ACPI: Power Resource [FN00] (on)
PM: Adding info for acpi:PNP0C0B:00
PM: Adding info for acpi:LNXTHERM:00
PM: Adding info for acpi:LNXTHERM:01
PM: Adding info for acpi:LNXTHERM:02
PM: Adding info for acpi:LNXPWRBN:00
ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
\_SB_.PCI0:_OSC invalid UUID
_OSC request data:1 8 1f 
ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-fe])
PM: Adding info for No Bus:pci0000:00
PM: Adding info for No Bus:0000:00
pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
pci_root PNP0A08:00: host bridge window [mem 0xa0000000-0xfeafffff]
pci 0000:00:00.0: [8086:0044] type 0 class 0x000600
pci 0000:00:00.0: rpm_resume flags 0x0
pci 0000:00:00.0: rpm_resume returns -11
pci 0000:00:01.0: [8086:0045] type 1 class 0x000604
pci 0000:00:01.0: rpm_resume flags 0x0
pci 0000:00:01.0: rpm_resume returns -11
pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
pci 0000:00:01.0: PME# disabled
pci 0000:00:02.0: [8086:0046] type 0 class 0x000300
pci 0000:00:02.0: reg 10: [mem 0xc0000000-0xc03fffff 64bit]
pci 0000:00:02.0: reg 18: [mem 0xb0000000-0xbfffffff 64bit pref]
pci 0000:00:02.0: reg 20: [io  0x4050-0x4057]
pci 0000:00:02.0: rpm_resume flags 0x0
pci 0000:00:02.0: rpm_resume returns -11
pci 0000:00:16.0: [8086:3b64] type 0 class 0x000780
pci 0000:00:16.0: reg 10: [mem 0xc4506100-0xc450610f 64bit]
pci 0000:00:16.0: rpm_resume flags 0x0
pci 0000:00:16.0: rpm_resume returns -11
pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
pci 0000:00:16.0: PME# disabled
pci 0000:00:1a.0: [8086:3b3c] type 0 class 0x000c03
pci 0000:00:1a.0: reg 10: [mem 0xc4505c00-0xc4505fff]
pci 0000:00:1a.0: rpm_resume flags 0x0
pci 0000:00:1a.0: rpm_resume returns -11
pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1a.0: PME# disabled
pci 0000:00:1b.0: [8086:3b56] type 0 class 0x000403
pci 0000:00:1b.0: reg 10: [mem 0xc4500000-0xc4503fff 64bit]
pci 0000:00:1b.0: rpm_resume flags 0x0
pci 0000:00:1b.0: rpm_resume returns -11
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: PME# disabled
pci 0000:00:1c.0: [8086:3b42] type 1 class 0x000604
pci 0000:00:1c.0: rpm_resume flags 0x0
pci 0000:00:1c.0: rpm_resume returns -11
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.1: [8086:3b44] type 1 class 0x000604
pci 0000:00:1c.1: rpm_resume flags 0x0
pci 0000:00:1c.1: rpm_resume returns -11
pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.1: PME# disabled
pci 0000:00:1d.0: [8086:3b34] type 0 class 0x000c03
pci 0000:00:1d.0: reg 10: [mem 0xc4505800-0xc4505bff]
pci 0000:00:1d.0: rpm_resume flags 0x0
pci 0000:00:1d.0: rpm_resume returns -11
pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.0: PME# disabled
pci 0000:00:1e.0: [8086:2448] type 1 class 0x000604
pci 0000:00:1e.0: rpm_resume flags 0x0
pci 0000:00:1e.0: rpm_resume returns -11
pci 0000:00:1f.0: [8086:3b09] type 0 class 0x000601
pci 0000:00:1f.0: rpm_resume flags 0x0
pci 0000:00:1f.0: rpm_resume returns -11
pci 0000:00:1f.2: [8086:3b29] type 0 class 0x000106
pci 0000:00:1f.2: reg 10: [io  0x4048-0x404f]
pci 0000:00:1f.2: reg 14: [io  0x405c-0x405f]
pci 0000:00:1f.2: reg 18: [io  0x4040-0x4047]
pci 0000:00:1f.2: reg 1c: [io  0x4058-0x405b]
pci 0000:00:1f.2: reg 20: [io  0x4020-0x403f]
pci 0000:00:1f.2: reg 24: [mem 0xc4505000-0xc45057ff]
pci 0000:00:1f.2: rpm_resume flags 0x0
pci 0000:00:1f.2: rpm_resume returns -11
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.2: PME# disabled
pci 0000:00:1f.3: [8086:3b30] type 0 class 0x000c05
pci 0000:00:1f.3: reg 10: [mem 0xc4506000-0xc45060ff 64bit]
pci 0000:00:1f.3: reg 20: [io  0x4000-0x401f]
pci 0000:00:1f.3: rpm_resume flags 0x0
pci 0000:00:1f.3: rpm_resume returns -11
pci 0000:00:1f.6: [8086:3b32] type 0 class 0x001180
pci 0000:00:1f.6: reg 10: [mem 0xc4504000-0xc4504fff 64bit]
pci 0000:00:1f.6: rpm_resume flags 0x0
pci 0000:00:1f.6: rpm_resume returns -11
pci 0000:01:00.0: [1002:68e0] type 0 class 0x000300
pci 0000:01:00.0: reg 10: [mem 0xa0000000-0xafffffff 64bit pref]
pci 0000:01:00.0: reg 18: [mem 0xc4400000-0xc441ffff 64bit]
pci 0000:01:00.0: reg 20: [io  0x3000-0x30ff]
pci 0000:01:00.0: reg 30: [mem 0xfffe0000-0xffffffff pref]
pci 0000:01:00.0: rpm_resume flags 0x0
pci 0000:01:00.0: rpm_resume returns -11
pci 0000:01:00.0: supports D1 D2
pci 0000:01:00.1: [1002:aa68] type 0 class 0x000403
pci 0000:01:00.1: reg 10: [mem 0xc4420000-0xc4423fff 64bit]
pci 0000:01:00.1: rpm_resume flags 0x0
pci 0000:01:00.1: rpm_resume returns -11
pci 0000:01:00.1: supports D1 D2
pci 0000:00:01.0: PCI bridge to [bus 01-01]
pci 0000:00:01.0:   bridge window [io  0x3000-0x3fff]
pci 0000:00:01.0:   bridge window [mem 0xc4400000-0xc44fffff]
pci 0000:00:01.0:   bridge window [mem 0xa0000000-0xafffffff 64bit pref]
pci 0000:02:00.0: [10ec:8168] type 0 class 0x000200
pci 0000:02:00.0: reg 10: [io  0x2000-0x20ff]
pci 0000:02:00.0: reg 18: [mem 0xc0404000-0xc0404fff 64bit pref]
pci 0000:02:00.0: reg 20: [mem 0xc0400000-0xc0403fff 64bit pref]
pci 0000:02:00.0: rpm_resume flags 0x0
pci 0000:02:00.0: rpm_resume returns -11
pci 0000:02:00.0: supports D1 D2
pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:02:00.0: PME# disabled
pci 0000:00:1c.0: PCI bridge to [bus 02-02]
pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
pci 0000:00:1c.0:   bridge window [mem 0xc3400000-0xc43fffff]
pci 0000:00:1c.0:   bridge window [mem 0xc0400000-0xc13fffff 64bit pref]
pci 0000:03:00.0: [14e4:4727] type 0 class 0x000280
pci 0000:03:00.0: reg 10: [mem 0xc2400000-0xc2403fff 64bit]
pci 0000:03:00.0: rpm_resume flags 0x0
pci 0000:03:00.0: rpm_resume returns -11
pci 0000:03:00.0: supports D1 D2
pci 0000:00:1c.1: PCI bridge to [bus 03-03]
pci 0000:00:1c.1:   bridge window [io  0x1000-0x1fff]
pci 0000:00:1c.1:   bridge window [mem 0xc2400000-0xc33fffff]
pci 0000:00:1c.1:   bridge window [mem 0xc1400000-0xc23fffff 64bit pref]
pci 0000:00:1e.0: PCI bridge to [bus 04-04] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0xa0000000-0xfeafffff] (subtractive decode)
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
\_SB_.PCI0:_OSC invalid UUID
_OSC request data:1 9 1f 
PM: Adding info for pci:0000:00:00.0
PM: Adding info for pci:0000:00:01.0
PM: Adding info for pci:0000:00:02.0
PM: Adding info for pci:0000:00:16.0
PM: Adding info for pci:0000:00:1a.0
PM: Adding info for pci:0000:00:1b.0
PM: Adding info for pci:0000:00:1c.0
PM: Adding info for pci:0000:00:1c.1
PM: Adding info for pci:0000:00:1d.0
PM: Adding info for pci:0000:00:1e.0
PM: Adding info for pci:0000:00:1f.0
PM: Adding info for pci:0000:00:1f.2
PM: Adding info for pci:0000:00:1f.3
PM: Adding info for pci:0000:00:1f.6
PM: Adding info for pci:0000:01:00.0
PM: Adding info for pci:0000:01:00.1
PM: Adding info for No Bus:0000:01
PM: Adding info for pci:0000:02:00.0
PM: Adding info for No Bus:0000:02
PM: Adding info for pci:0000:03:00.0
PM: Adding info for No Bus:0000:03
PM: Adding info for No Bus:0000:04
ACPI: PCI Root Bridge [CPBG] (domain 0000 [bus ff])
PM: Adding info for No Bus:pci0000:ff
PM: Adding info for No Bus:0000:ff
pci 0000:ff:00.0: [8086:2c62] type 0 class 0x000600
pci 0000:ff:00.0: rpm_resume flags 0x0
pci 0000:ff:00.0: rpm_resume returns -11
pci 0000:ff:00.1: [8086:2d01] type 0 class 0x000600
pci 0000:ff:00.1: rpm_resume flags 0x0
pci 0000:ff:00.1: rpm_resume returns -11
pci 0000:ff:02.0: [8086:2d10] type 0 class 0x000600
pci 0000:ff:02.0: rpm_resume flags 0x0
pci 0000:ff:02.0: rpm_resume returns -11
pci 0000:ff:02.1: [8086:2d11] type 0 class 0x000600
pci 0000:ff:02.1: rpm_resume flags 0x0
pci 0000:ff:02.1: rpm_resume returns -11
pci 0000:ff:02.2: [8086:2d12] type 0 class 0x000600
pci 0000:ff:02.2: rpm_resume flags 0x0
pci 0000:ff:02.2: rpm_resume returns -11
pci 0000:ff:02.3: [8086:2d13] type 0 class 0x000600
pci 0000:ff:02.3: rpm_resume flags 0x0
pci 0000:ff:02.3: rpm_resume returns -11
pci_bus 0000:ff: on NUMA node 0
PM: Adding info for pci:0000:ff:00.0
PM: Adding info for pci:0000:ff:00.1
PM: Adding info for pci:0000:ff:02.0
PM: Adding info for pci:0000:ff:02.1
PM: Adding info for pci:0000:ff:02.2
PM: Adding info for pci:0000:ff:02.3
ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 *5 6 7 10 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 *10 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 *5 6 7 11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
PM: Adding info for No Bus:vga_arbiter
vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=none,locks=none
vgaarb: loaded
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
Advanced Linux Sound Architecture Driver Version 1.0.24.
PCI: Using ACPI for IRQ routing
PCI: pci_cache_line_size set to 64 bytes
reserve RAM buffer: 000000000009d000 - 000000000009ffff 
reserve RAM buffer: 000000009b63f000 - 000000009bffffff 
reserve RAM buffer: 000000009b800000 - 000000009bffffff 
PM: Adding info for No Bus:lo
PM: Adding info for platform:regulatory.0
cfg80211: Calling CRDA to update world regulatory domain
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
hpet0: 8 comparators, 64-bit 14.318180 MHz counter
Switching to clocksource hpet
pnp: PnP ACPI init
PM: Adding info for No Bus:pnp0
ACPI: bus type pnp registered
pnp 00:00: [bus 00-fe]
pnp 00:00: [io  0x0000-0x0cf7 window]
pnp 00:00: [io  0x0cf8-0x0cff]
pnp 00:00: [io  0x0d00-0xffff window]
pnp 00:00: [mem 0x000a0000-0x000bffff window]
pnp 00:00: [mem 0x000c0000-0x000c3fff window]
pnp 00:00: [mem 0x000c4000-0x000c7fff window]
pnp 00:00: [mem 0x000c8000-0x000cbfff window]
pnp 00:00: [mem 0x000cc000-0x000cffff window]
pnp 00:00: [mem 0x000d0000-0x000d3fff window]
pnp 00:00: [mem 0x000d4000-0x000d7fff window]
pnp 00:00: [mem 0x000d8000-0x000dbfff window]
pnp 00:00: [mem 0x000dc000-0x000dffff window]
pnp 00:00: [mem 0x000e0000-0x000e3fff window]
pnp 00:00: [mem 0x000e4000-0x000e7fff window]
pnp 00:00: [mem 0x000e8000-0x000ebfff window]
pnp 00:00: [mem 0x000ec000-0x000effff window]
pnp 00:00: [mem 0x000f0000-0x000fffff window]
pnp 00:00: [mem 0xa0000000-0xfeafffff window]
pnp 00:00: [mem 0xfed40000-0xfed44fff window]
PM: Adding info for pnp:00:00
pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
pnp 00:01: [io  0x0000-0x001f]
pnp 00:01: [io  0x0081-0x0091]
pnp 00:01: [io  0x0093-0x009f]
pnp 00:01: [io  0x00c0-0x00df]
pnp 00:01: [dma 4]
PM: Adding info for pnp:00:01
pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
pnp 00:02: [mem 0xff000000-0xffffffff]
PM: Adding info for pnp:00:02
pnp 00:02: Plug and Play ACPI device, IDs INT0800 (active)
pnp 00:03: [mem 0xfed00000-0xfed003ff]
PM: Adding info for pnp:00:03
pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
pnp 00:04: [io  0x00f0]
pnp 00:04: [irq 13]
PM: Adding info for pnp:00:04
Switched to NOHz mode on CPU #0
pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
pnp 00:05: [io  0x002e-0x002f]
pnp 00:05: [io  0x004e-0x004f]
pnp 00:05: [io  0x0061]
pnp 00:05: [io  0x0063]
pnp 00:05: [io  0x0065]
pnp 00:05: [io  0x0067]
pnp 00:05: [io  0x0070]
pnp 00:05: [io  0x0080]
pnp 00:05: [io  0x0092]
pnp 00:05: [io  0x00b2-0x00b3]
pnp 00:05: [io  0x0680-0x069f]
pnp 00:05: [io  0x0800-0x080f]
pnp 00:05: [io  0x0810-0x0813]
pnp 00:05: [io  0xffff]
pnp 00:05: [io  0x0400-0x047f]
pnp 00:05: [io  0x0500-0x0501]
pnp 00:05: [io  0x0700-0x077f]
pnp 00:05: [io  0x164e-0x164f]
Switched to NOHz mode on CPU #1
Switched to NOHz mode on CPU #2
pnp 00:05: disabling [io  0x164e-0x164f] because it overlaps 0000:00:1c.1 BAR 7 [io  0x1000-0x1fff]
Switched to NOHz mode on CPU #3
PM: Adding info for pnp:00:05
system 00:05: [io  0x0680-0x069f] has been reserved
system 00:05: [io  0x0800-0x080f] has been reserved
system 00:05: [io  0x0810-0x0813] has been reserved
system 00:05: [io  0xffff] has been reserved
system 00:05: [io  0x0400-0x047f] has been reserved
system 00:05: [io  0x0500-0x0501] has been reserved
system 00:05: [io  0x0700-0x077f] has been reserved
system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:06: [io  0x0070-0x0077]
pnp 00:06: [irq 8]
PM: Adding info for pnp:00:06
pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
pnp 00:07: [io  0x0060]
pnp 00:07: [io  0x0064]
pnp 00:07: [irq 1]
PM: Adding info for pnp:00:07
pnp 00:07: Plug and Play ACPI device, IDs PNP0303 (active)
pnp 00:08: [irq 12]
PM: Adding info for pnp:00:08
pnp 00:08: Plug and Play ACPI device, IDs SYN1e2d SYN1e00 SYN0002 PNP0f13 (active)
pnp 00:09: [irq 23]
PM: Adding info for pnp:00:09
pnp 00:09: Plug and Play ACPI device, IDs HPQ0004 (active)
pnp 00:0a: [mem 0xfed1c000-0xfed1ffff]
pnp 00:0a: [mem 0xfed10000-0xfed13fff]
pnp 00:0a: [mem 0xfed18000-0xfed18fff]
pnp 00:0a: [mem 0xfed19000-0xfed19fff]
pnp 00:0a: [mem 0xe0000000-0xefffffff]
pnp 00:0a: [mem 0xfed20000-0xfed3ffff]
pnp 00:0a: [mem 0xfed90000-0xfed8ffff disabled]
pnp 00:0a: [mem 0xfed45000-0xfed8ffff]
pnp 00:0a: [mem 0xff000000-0xffffffff]
pnp 00:0a: [mem 0xfee00000-0xfeefffff]
pnp 00:0a: [mem 0xc4600000-0xc4600fff]
PM: Adding info for pnp:00:0a
system 00:0a: [mem 0xfed1c000-0xfed1ffff] has been reserved
system 00:0a: [mem 0xfed10000-0xfed13fff] has been reserved
system 00:0a: [mem 0xfed18000-0xfed18fff] has been reserved
system 00:0a: [mem 0xfed19000-0xfed19fff] has been reserved
system 00:0a: [mem 0xe0000000-0xefffffff] has been reserved
system 00:0a: [mem 0xfed20000-0xfed3ffff] has been reserved
system 00:0a: [mem 0xfed45000-0xfed8ffff] has been reserved
system 00:0a: [mem 0xff000000-0xffffffff] could not be reserved
system 00:0a: [mem 0xfee00000-0xfeefffff] could not be reserved
system 00:0a: [mem 0xc4600000-0xc4600fff] has been reserved
system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:0b: [bus ff]
PM: Adding info for pnp:00:0b
pnp 00:0b: Plug and Play ACPI device, IDs PNP0a03 (active)
pnp: PnP ACPI: found 12 devices
ACPI: ACPI bus type pnp unregistered
PM: Adding info for No Bus:mem
PM: Adding info for No Bus:null
PM: Adding info for No Bus:port
PM: Adding info for No Bus:zero
PM: Adding info for No Bus:full
PM: Adding info for No Bus:random
PM: Adding info for No Bus:urandom
PM: Adding info for No Bus:kmsg
PM: Adding info for No Bus:tty
PM: Adding info for No Bus:console
PM: Adding info for No Bus:tty0
PM: Adding info for No Bus:vcs
PM: Adding info for No Bus:vcsa
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
PM: Adding info for No Bus:tty1
PM: Adding info for No Bus:tty2
PM: Adding info for No Bus:tty3
PM: Adding info for No Bus:tty4
PM: Adding info for No Bus:tty5
PM: Adding info for No Bus:tty6
PM: Adding info for No Bus:tty7
PM: Adding info for No Bus:tty8
PM: Adding info for No Bus:tty9
PM: Adding info for No Bus:tty10
PM: Adding info for No Bus:tty11
PM: Adding info for No Bus:tty12
PM: Adding info for No Bus:tty13
PM: Adding info for No Bus:tty14
PM: Adding info for No Bus:tty15
PM: Adding info for No Bus:tty16
PM: Adding info for No Bus:tty17
PM: Adding info for No Bus:tty18
PM: Adding info for No Bus:tty19
PM: Adding info for No Bus:tty20
PM: Adding info for No Bus:tty21
PM: Adding info for No Bus:tty22
PM: Adding info for No Bus:tty23
PM: Adding info for No Bus:tty24
PM: Adding info for No Bus:tty25
PM: Adding info for No Bus:tty26
PM: Adding info for No Bus:tty27
PM: Adding info for No Bus:tty28
PM: Adding info for No Bus:tty29
PM: Adding info for No Bus:tty30
PM: Adding info for No Bus:tty31
PM: Adding info for No Bus:tty32
PM: Adding info for No Bus:tty33
PM: Adding info for No Bus:tty34
PM: Adding info for No Bus:tty35
PM: Adding info for No Bus:tty36
PM: Adding info for No Bus:tty37
PM: Adding info for No Bus:tty38
PM: Adding info for No Bus:tty39
PM: Adding info for No Bus:tty40
PM: Adding info for No Bus:tty41
PM: Adding info for No Bus:tty42
PM: Adding info for No Bus:tty43
PM: Adding info for No Bus:tty44
PM: Adding info for No Bus:tty45
PM: Adding info for No Bus:tty46
PM: Adding info for No Bus:tty47
PM: Adding info for No Bus:tty48
PM: Adding info for No Bus:tty49
PM: Adding info for No Bus:tty50
PM: Adding info for No Bus:tty51
PM: Adding info for No Bus:tty52
PM: Adding info for No Bus:tty53
PM: Adding info for No Bus:tty54
PM: Adding info for No Bus:tty55
PM: Adding info for No Bus:tty56
PM: Adding info for No Bus:tty57
PM: Adding info for No Bus:tty58
PM: Adding info for No Bus:tty59
PM: Adding info for No Bus:tty60
PM: Adding info for No Bus:tty61
PM: Adding info for No Bus:tty62
PM: Adding info for No Bus:tty63
pci 0000:01:00.0: no compatible bridge window for [mem 0xfffe0000-0xffffffff pref]
pci 0000:01:00.0: BAR 6: assigned [mem 0xc4440000-0xc445ffff pref]
pci 0000:00:01.0: PCI bridge to [bus 01-01]
pci 0000:00:01.0:   bridge window [io  0x3000-0x3fff]
pci 0000:00:01.0:   bridge window [mem 0xc4400000-0xc44fffff]
pci 0000:00:01.0:   bridge window [mem 0xa0000000-0xafffffff 64bit pref]
pci 0000:00:1c.0: PCI bridge to [bus 02-02]
pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
pci 0000:00:1c.0:   bridge window [mem 0xc3400000-0xc43fffff]
pci 0000:00:1c.0:   bridge window [mem 0xc0400000-0xc13fffff 64bit pref]
pci 0000:00:1c.1: PCI bridge to [bus 03-03]
pci 0000:00:1c.1:   bridge window [io  0x1000-0x1fff]
pci 0000:00:1c.1:   bridge window [mem 0xc2400000-0xc33fffff]
pci 0000:00:1c.1:   bridge window [mem 0xc1400000-0xc23fffff 64bit pref]
pci 0000:00:1e.0: PCI bridge to [bus 04-04]
pci 0000:00:1e.0:   bridge window [io  disabled]
pci 0000:00:1e.0:   bridge window [mem disabled]
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
pci_bus 0000:00: resource 7 [mem 0xa0000000-0xfeafffff]
pci_bus 0000:01: resource 0 [io  0x3000-0x3fff]
pci_bus 0000:01: resource 1 [mem 0xc4400000-0xc44fffff]
pci_bus 0000:01: resource 2 [mem 0xa0000000-0xafffffff 64bit pref]
pci_bus 0000:02: resource 0 [io  0x2000-0x2fff]
pci_bus 0000:02: resource 1 [mem 0xc3400000-0xc43fffff]
pci_bus 0000:02: resource 2 [mem 0xc0400000-0xc13fffff 64bit pref]
pci_bus 0000:03: resource 0 [io  0x1000-0x1fff]
pci_bus 0000:03: resource 1 [mem 0xc2400000-0xc33fffff]
pci_bus 0000:03: resource 2 [mem 0xc1400000-0xc23fffff 64bit pref]
pci_bus 0000:04: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:04: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:04: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:04: resource 7 [mem 0xa0000000-0xfeafffff]
NET: Registered protocol family 2
IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
IPv4 FIB: Using LC-trie version 0.409
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
pci 0000:00:1a.0: EHCI: BIOS handoff
pci 0000:00:1d.0: EHCI: BIOS handoff
PCI: CLS 64 bytes, default 64
PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Placing 64MB software IO TLB between ffff88009763b000 - ffff88009b63b000
software IO TLB at phys 0x9763b000 - 0x9b63b000
Simple Boot Flag at 0x44 set to 0x1
PM: Adding info for No Bus:mcelog
PM: Adding info for No Bus:cpu0
PM: Adding info for No Bus:cpu1
PM: Adding info for No Bus:cpu2
PM: Adding info for No Bus:cpu3
PM: Adding info for platform:pcspkr
PM: Adding info for No Bus:snapshot
PM: Adding info for event_source:cpu
PM: Adding info for event_source:breakpoint
PM: Adding info for event_source:software
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
msgmni has been set to 7520
alg: No test for stdrng (krng)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
PM: Adding info for No Bus:fbcon
PM: Adding info for platform:vesafb.0
vesafb: mode is 1024x768x32, linelength=4096, pages=9
vesafb: scrolling: redraw
vesafb: Truecolor: size=8:8:8:8, shift=24:16:8:0
vesafb: framebuffer at 0xb0000000, mapped to 0xffffc90010180000, using 6144k, total 32704k
PM: Adding info for No Bus:fb0
PM: Adding info for No Bus:vtcon1
Console: switching to colour frame buffer device 128x48
fb0: VESA VGA frame buffer device
intel_idle: MWAIT substates: 0x1120
intel_idle: v0.4 model 0x25
intel_idle: lapic_timer_reliable_states 0xffffffff
PM: Adding info for No Bus:AC
ACPI: AC Adapter [AC] (on-line)
PM: Adding info for No Bus:input0
input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
ACPI: Lid Switch [LID0]
PM: Adding info for No Bus:input1
input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
ACPI: Power Button [PWRB]
PM: Adding info for No Bus:input2
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
ACPI: Power Button [PWRF]
PM: Adding info for No Bus:cooling_device0
ACPI: Fan [FAN0] (on)
ACPI: acpi_idle yielding to intel_idle
PM: Adding info for No Bus:cooling_device1
PM: Adding info for No Bus:cooling_device2
PM: Adding info for No Bus:cooling_device3
PM: Adding info for No Bus:cooling_device4
PM: Adding info for No Bus:thermal_zone0
thermal LNXTHERM:00: registered as thermal_zone0
ACPI: Thermal Zone [TZ00] (59 C)
PM: Adding info for No Bus:thermal_zone1
thermal LNXTHERM:01: registered as thermal_zone1
ACPI: Thermal Zone [TZ01] (42 C)
PM: Adding info for No Bus:thermal_zone2
thermal LNXTHERM:02: registered as thermal_zone2
ACPI: Thermal Zone [TZ02] (66 C)
PM: Adding info for No Bus:ptmx
PM: Adding info for No Bus:hpet
Linux agpgart interface v0.103
agpgart-intel 0000:00:00.0: Intel HD Graphics Chipset
agpgart-intel 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
agpgart-intel 0000:00:00.0: detected 32768K stolen memory
PM: Adding info for No Bus:agpgart
agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xb0000000
PM: Adding info for No Bus:1:0
PM: Adding info for No Bus:ram0
PM: Adding info for No Bus:1:1
PM: Adding info for No Bus:ram1
PM: Adding info for No Bus:1:2
PM: Adding info for No Bus:ram2
PM: Adding info for No Bus:1:3
PM: Adding info for No Bus:ram3
PM: Adding info for No Bus:1:4
PM: Adding info for No Bus:ram4
PM: Adding info for No Bus:1:5
PM: Adding info for No Bus:ram5
PM: Adding info for No Bus:1:6
PM: Adding info for No Bus:ram6
PM: Adding info for No Bus:1:7
PM: Adding info for No Bus:ram7
PM: Adding info for No Bus:1:8
PM: Adding info for No Bus:ram8
PM: Adding info for No Bus:1:9
PM: Adding info for No Bus:ram9
PM: Adding info for No Bus:1:10
PM: Adding info for No Bus:ram10
PM: Adding info for No Bus:1:11
PM: Adding info for No Bus:ram11
PM: Adding info for No Bus:1:12
PM: Adding info for No Bus:ram12
PM: Adding info for No Bus:1:13
PM: Adding info for No Bus:ram13
PM: Adding info for No Bus:BAT0
PM: Adding info for No Bus:1:14
PM: Adding info for No Bus:ram14
PM: Adding info for No Bus:1:15
PM: Adding info for No Bus:ram15
brd: module loaded
PM: Adding info for No Bus:7:0
PM: Adding info for No Bus:loop0
PM: Adding info for No Bus:7:1
PM: Adding info for No Bus:loop1
PM: Adding info for No Bus:7:2
PM: Adding info for No Bus:loop2
PM: Adding info for No Bus:7:3
PM: Adding info for No Bus:loop3
PM: Adding info for No Bus:7:4
PM: Adding info for No Bus:loop4
PM: Adding info for No Bus:7:5
PM: Adding info for No Bus:loop5
PM: Adding info for No Bus:7:6
PM: Adding info for No Bus:loop6
PM: Adding info for No Bus:7:7
PM: Adding info for No Bus:loop7
loop: module loaded
ahci 0000:00:1f.2: version 3.0
ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ACPI: Battery Slot [BAT0] (battery present)
ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 4 ports 3 Gbps 0x1 impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq sntf ilck pm led clo pio slum part ems apst 
ahci 0000:00:1f.2: setting latency timer to 64
PM: Adding info for No Bus:ata1
PM: Adding info for No Bus:ata1
PM: Adding info for No Bus:link1
PM: Adding info for No Bus:link1
PM: Adding info for No Bus:dev1.0
PM: Adding info for No Bus:dev1.0
PM: Adding info for No Bus:ata2
PM: Adding info for No Bus:ata2
PM: Adding info for No Bus:link2
PM: Adding info for No Bus:link2
PM: Adding info for No Bus:dev2.0
PM: Adding info for No Bus:dev2.0
PM: Adding info for No Bus:ata3
PM: Adding info for No Bus:ata3
PM: Adding info for No Bus:link3
PM: Adding info for No Bus:link3
PM: Adding info for No Bus:dev3.0
PM: Adding info for No Bus:dev3.0
PM: Adding info for No Bus:ata4
PM: Adding info for No Bus:ata4
PM: Adding info for No Bus:link4
PM: Adding info for No Bus:link4
PM: Adding info for No Bus:dev4.0
PM: Adding info for No Bus:dev4.0
scsi0 : ahci
PM: Adding info for scsi:host0
PM: Adding info for No Bus:host0
scsi1 : ahci
PM: Adding info for scsi:host1
PM: Adding info for No Bus:host1
scsi2 : ahci
PM: Adding info for scsi:host2
PM: Adding info for No Bus:host2
scsi3 : ahci
PM: Adding info for scsi:host3
PM: Adding info for No Bus:host3
ata1: SATA max UDMA/133 abar m2048@0xc4505000 port 0xc4505100 irq 19
ata2: DUMMY
Refined TSC clocksource calibration: 1196.998 MHz.
Switching to clocksource tsc
ata3: DUMMY
ata4: DUMMY
scsi host0: rpm_resume flags 0x4
scsi host1: rpm_resume flags 0x4
scsi host0: rpm_resume returns 1
scsi host1: rpm_resume returns 1
scsi host1: rpm_suspend flags 0x0
scsi host1: rpm_suspend returns 0
scsi host2: rpm_resume flags 0x4
scsi host2: rpm_resume returns 1
scsi host2: rpm_suspend flags 0x0
scsi host2: rpm_suspend returns 0
scsi host3: rpm_resume flags 0x4
scsi host3: rpm_resume returns 1
scsi host3: rpm_suspend flags 0x0
scsi host3: rpm_suspend returns 0
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd: block sizes: qh 104 qtd 96 itd 192 sitd 96
ehci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
ehci_hcd 0000:00:1a.0: setting latency timer to 64
ehci_hcd 0000:00:1a.0: EHCI Host Controller
ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1a.0: reset hcs_params 0x200003 dbg=2 cc=0 pcc=0 ordered !ppc ports=3
ehci_hcd 0000:00:1a.0: reset hcc_params 36881 caching frame 1024 64 bit addr
ehci_hcd 0000:00:1a.0: support lpm
ehci_hcd 0000:00:1a.0: debug port 2
ehci_hcd 0000:00:1a.0: reset command 0080012 (park)=0 ithresh=8 Periodic period=1024 Reset HALT
ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
ehci_hcd 0000:00:1a.0: supports USB remote wakeup
ehci_hcd 0000:00:1a.0: irq 16, io mem 0xc4505c00
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: ATA-8: Hitachi HTS725050A9A364, PC4OC72E, max UDMA/100
ata1.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
ehci_hcd 0000:00:1a.0: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
ehci_hcd 0000:00:1a.0: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
ata1.00: configured for UDMA/100
ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
usb usb1: rpm_resume flags 0x0
usb usb1: rpm_resume returns 1
usb usb1: default language 0x0409
usb usb1: udev 1, busnum 1, minor = 0
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.39-rc5 ehci_hcd
usb usb1: SerialNumber: 0000:00:1a.0
PM: Adding info for usb:usb1
usb usb1: usb_probe_device
usb usb1: configuration #1 chosen from 1 choice
usb usb1: rpm_resume flags 0x4
usb usb1: rpm_resume returns 1
usb usb1: adding 1-0:1.0 (config #1, interface 0)
PM: Adding info for usb:1-0:1.0
hub 1-0:1.0: usb_probe_interface
hub 1-0:1.0: usb_probe_interface - got id
usb usb1: rpm_resume flags 0x4
usb usb1: rpm_resume returns 1
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 3 ports detected
hub 1-0:1.0: standalone hub
hub 1-0:1.0: no power switching (usb 1.0)
hub 1-0:1.0: individual port over-current protection
hub 1-0:1.0: power on to power good time: 20ms
hub 1-0:1.0: local power source is good
hub 1-0:1.0: trying to enable port power on non-switchable hub
PM: Adding info for No Bus:ep_81
PM: Adding info for No Bus:ep_00
usb usb1: rpm_suspend flags 0xc
usb usb1: rpm_suspend returns -16
ehci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
ehci_hcd 0000:00:1d.0: setting latency timer to 64
ehci_hcd 0000:00:1d.0: EHCI Host Controller
ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:1a.0: GetStatus port:1 status 001803 0  ACK POWER sig=j CSC CONNECT
hub 1-0:1.0: port 1: status 0501 change 0001
hub 1-0:1.0: state 7 ports 3 chg 0002 evt 0000
hub 1-0:1.0: rpm_resume flags 0x4
hub 1-0:1.0: rpm_resume returns 1
hub 1-0:1.0: port 1, status 0501, change 0000, 480 Mb/s
ehci_hcd 0000:00:1a.0: port 1 high speed
ehci_hcd 0000:00:1a.0: GetStatus port:1 status 001005 0  ACK POWER sig=se0 PE CONNECT
usb 1-1: new high speed USB device number 2 using ehci_hcd
ehci_hcd 0000:00:1a.0: port 1 high speed
ehci_hcd 0000:00:1a.0: GetStatus port:1 status 001005 0  ACK POWER sig=se0 PE CONNECT
ehci_hcd 0000:00:1a.0: set dev address 2 for port 1
ehci_hcd 0000:00:1a.0: LPM: no device attached
usb 1-1: rpm_resume flags 0x0
usb 1-1: rpm_resume returns 1
scsi host0: rpm_suspend flags 0x0
scsi host0: rpm_suspend returns 0
scsi target0:0:0: rpm_resume flags 0x4
scsi target0:0:0: rpm_resume returns -11
scsi host0: rpm_resume flags 0x4
ahci 0000:00:1f.2: rpm_resume flags 0x0
ahci 0000:00:1f.2: rpm_resume returns 1
scsi host0: rpm_resume returns 0
scsi 0:0:0:0: Direct-Access     ATA      Hitachi HTS72505 PC4O PQ: 0 ANSI: 5
usb 1-1: udev 2, busnum 1, minor = 1
usb 1-1: New USB device found, idVendor=8087, idProduct=0020
usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
PM: Adding info for usb:1-1
usb 1-1: usb_probe_device
usb 1-1: configuration #1 chosen from 1 choice
usb 1-1: rpm_resume flags 0x4
usb 1-1: rpm_resume returns 1
usb 1-1: adding 1-1:1.0 (config #1, interface 0)
PM: Adding info for usb:1-1:1.0
hub 1-1:1.0: usb_probe_interface
hub 1-1:1.0: usb_probe_interface - got id
usb 1-1: rpm_resume flags 0x4
usb 1-1: rpm_resume returns 1
hub 1-1:1.0: USB hub found
hub 1-1:1.0: 6 ports detected
PM: Adding info for scsi:target0:0:0
scsi target0:0:0: rpm_resume flags 0x4
scsi target0:0:0: rpm_resume returns 1
scsi 0:0:0:0: rpm_resume flags 0x0
scsi 0:0:0:0: rpm_resume returns -11
scsi 0:0:0:0: rpm_resume flags 0x4
scsi 0:0:0:0: rpm_resume returns 1
PM: Adding info for scsi:0:0:0:0
PM: Adding info for No Bus:0:0:0:0
PM: Adding info for No Bus:0:0:0:0
sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
PM: Adding info for No Bus:0:0:0:0
PM: Adding info for No Bus:8:0
PM: Adding info for No Bus:sda
sd 0:0:0:0: rpm_resume flags 0x4
sd 0:0:0:0: rpm_resume returns 1
 sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
PM: Adding info for No Bus:sda1
PM: Adding info for No Bus:sda2
PM: Adding info for No Bus:sda3
PM: Adding info for No Bus:sda4
PM: Adding info for No Bus:sda5
PM: Adding info for No Bus:sda6
ehci_hcd 0000:00:1d.0: reset hcs_params 0x200003 dbg=2 cc=0 pcc=0 ordered !ppc ports=3
hub 1-1:1.0: standalone hub
ehci_hcd 0000:00:1d.0: reset hcc_params 36881 caching frame 1024 64 bit addr
hub 1-1:1.0: individual port power switching
hub 1-1:1.0: individual port over-current protection
hub 1-1:1.0: Single TT
hub 1-1:1.0: TT requires at most 8 FS bit times (666 ns)
hub 1-1:1.0: Port indicators are supported
hub 1-1:1.0: power on to power good time: 100ms
ehci_hcd 0000:00:1d.0: support lpm
ehci_hcd 0000:00:1d.0: debug port 2
hub 1-1:1.0: local power source is good
hub 1-1:1.0: enabling power on all ports
ehci_hcd 0000:00:1d.0: reset command 0080012 (park)=0 ithresh=8 Periodic period=1024 Reset HALT
ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
ehci_hcd 0000:00:1d.0: supports USB remote wakeup
ehci_hcd 0000:00:1d.0: irq 20, io mem 0xc4505800
sd 0:0:0:0: [sda] Attached SCSI disk
ehci_hcd 0000:00:1d.0: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
ehci_hcd 0000:00:1d.0: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
PM: Adding info for No Bus:ep_81
PM: Adding info for No Bus:ep_00
usb 1-1: rpm_suspend flags 0xc
usb 1-1: rpm_suspend returns -16
hub 1-0:1.0: rpm_suspend flags 0x4
hub 1-0:1.0: rpm_suspend returns 0
ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
usb usb2: rpm_resume flags 0x0
usb usb2: rpm_resume returns 1
usb usb2: default language 0x0409
usb usb2: udev 1, busnum 2, minor = 128
usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
hub 1-1:1.0: port 3: status 0101 change 0001
hub 1-1:1.0: port 4: status 0101 change 0001
usb usb2: Product: EHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.39-rc5 ehci_hcd
usb 1-1: link qh256-0001/ffff8801574f1100 start 1 [1/0 us]
hub 1-1:1.0: state 7 ports 6 chg 0018 evt 0000
hub 1-1:1.0: rpm_resume flags 0x4
hub 1-1:1.0: rpm_resume returns 1
usb usb2: SerialNumber: 0000:00:1d.0
hub 1-1:1.0: port 3, status 0101, change 0000, 12 Mb/s
PM: Adding info for usb:usb2
usb usb2: usb_probe_device
usb usb2: configuration #1 chosen from 1 choice
usb usb2: rpm_resume flags 0x4
usb usb2: rpm_resume returns 1
usb usb2: adding 2-0:1.0 (config #1, interface 0)
PM: Adding info for usb:2-0:1.0
hub 2-0:1.0: usb_probe_interface
hub 2-0:1.0: usb_probe_interface - got id
usb usb2: rpm_resume flags 0x4
usb usb2: rpm_resume returns 1
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 3 ports detected
hub 2-0:1.0: standalone hub
hub 2-0:1.0: no power switching (usb 1.0)
hub 2-0:1.0: individual port over-current protection
hub 2-0:1.0: power on to power good time: 20ms
hub 2-0:1.0: local power source is good
hub 2-0:1.0: trying to enable port power on non-switchable hub
PM: Adding info for No Bus:ep_81
PM: Adding info for No Bus:ep_00
usb usb2: rpm_suspend flags 0xc
usb usb2: rpm_suspend returns -16
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
ohci_hcd: block sizes: ed 80 td 96
uhci_hcd: USB Universal Host Controller Interface driver
usbcore: registered new interface driver usblp
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usbcore: registered new interface driver libusual
i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
PM: Adding info for platform:i8042
i8042: Detected active multiplexing controller, rev 1.1
serio: i8042 KBD port at 0x60,0x64 irq 1
PM: Adding info for serio:serio0
serio: i8042 AUX0 port at 0x60,0x64 irq 12
serio: i8042 AUX1 port at 0x60,0x64 irq 12
serio: i8042 AUX2 port at 0x60,0x64 irq 12
serio: i8042 AUX3 port at 0x60,0x64 irq 12
PM: Adding info for serio:serio1
PM: Adding info for serio:serio2
PM: Adding info for No Bus:mice
PM: Adding info for serio:serio3
PM: Adding info for serio:serio4
PM: Adding info for No Bus:psaux
mousedev: PS/2 mouse device common for all mice
PM: Adding info for No Bus:event0
PM: Adding info for No Bus:event1
PM: Adding info for No Bus:event2
rtc_cmos 00:06: RTC can wake from S4
ehci_hcd 0000:00:1d.0: GetStatus port:1 status 001803 0  ACK POWER sig=j CSC CONNECT
hub 2-0:1.0: port 1: status 0501 change 0001
usb 1-1.3: new full speed USB device number 3 using ehci_hcd
atkbd serio0: Failed to enable keyboard on isa0060/serio0
PM: Adding info for No Bus:input3
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
PM: Adding info for No Bus:event3
atkbd serio0: Spurious ACK on isa0060/serio0. Some program might be trying access hardware directly.
PM: Adding info for No Bus:rtc0
rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one year, y3k, 242 bytes nvram, hpet irqs
i801_smbus 0000:00:1f.3: PCI INT C -> GSI 19 (level, low) -> IRQ 19
usb 1-1.3: rpm_resume flags 0x0
usb 1-1.3: rpm_resume returns 1
PM: Adding info for i2c:i2c-0
lirc_dev: IR Remote Control driver registered, major 252 
usb 1-1.3: skipped 1 descriptor after interface
usb 1-1.3: default language 0x0409
IR NEC protocol handler initialized
IR RC5(x) protocol handler initialized
IR RC6 protocol handler initialized
IR JVC protocol handler initialized
IR Sony protocol handler initialized
IR RC5 (streamzap) protocol handler initialized
IR LIRC bridge handler initialized
Linux video capture interface: v2.00
gspca: v2.12.0 registered
PM: Adding info for platform:coretemp.0
coretemp coretemp.0: TjMax is 105 C.
PM: Adding info for No Bus:hwmon0
usb 1-1.3: udev 3, busnum 1, minor = 2
usb 1-1.3: New USB device found, idVendor=03f0, idProduct=231d
usb 1-1.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 1-1.3: Product: HP Integrated Module
usb 1-1.3: Manufacturer: Broadcom Corp
PM: Adding info for platform:coretemp.2
PM: Adding info for usb:1-1.3
coretemp coretemp.2: TjMax is 105 C.
PM: Adding info for No Bus:hwmon1
usb 1-1.3: usb_probe_device
usb 1-1.3: configuration #1 chosen from 1 choice
usb 1-1.3: rpm_resume flags 0x4
usb 1-1.3: rpm_resume returns 1
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.06
PM: Adding info for platform:iTCO_wdt
usb 1-1.3: adding 1-1.3:1.0 (config #1, interface 0)
PM: Adding info for usb:1-1.3:1.0
iTCO_wdt: Found a HM55 TCO device (Version=2, TCOBASE=0x0460)
PM: Adding info for No Bus:watchdog
PM: Adding info for No Bus:ep_81
iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
iTCO_vendor_support: vendor-support=0
PM: Adding info for No Bus:ep_82
PM: Adding info for No Bus:ep_02
usb 1-1.3: adding 1-1.3:1.1 (config #1, interface 1)
PM: Adding info for usb:1-1.3:1.1
PM: Adding info for No Bus:ep_83
PM: Adding info for No Bus:ep_03
usb 1-1.3: adding 1-1.3:1.2 (config #1, interface 2)
PM: Adding info for usb:1-1.3:1.2
PM: Adding info for No Bus:ep_84
PM: Adding info for No Bus:ep_04
usb 1-1.3: adding 1-1.3:1.3 (config #1, interface 3)
PM: Adding info for usb:1-1.3:1.3
PM: Adding info for No Bus:ep_00
cpuidle: using governor ladder
hub 1-1:1.0: port 4, status 0101, change 0000, 12 Mb/s
cpuidle: using governor menu
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
PM: Adding info for No Bus:timer
HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
HDA Intel 0000:00:1b.0: setting latency timer to 64
usb 1-1.4: new full speed USB device number 4 using ehci_hcd
usb 1-1.4: ep0 maxpacket = 8
usb 1-1.4: rpm_resume flags 0x0
usb 1-1.4: rpm_resume returns 1
usb 1-1.4: default language 0x0409
usb 1-1.4: udev 4, busnum 1, minor = 3
usb 1-1.4: New USB device found, idVendor=138a, idProduct=0005
usb 1-1.4: New USB device strings: Mfr=0, Product=0, SerialNumber=1
usb 1-1.4: SerialNumber: 0510f9f55000
PM: Adding info for usb:1-1.4
usb 1-1.4: usb_probe_device
usb 1-1.4: configuration #1 chosen from 1 choice
usb 1-1.4: rpm_resume flags 0x4
usb 1-1.4: rpm_resume returns 1
usb 1-1.4: adding 1-1.4:1.0 (config #1, interface 0)
PM: Adding info for usb:1-1.4:1.0
PM: Adding info for No Bus:ep_01
PM: Adding info for No Bus:ep_81
PM: Adding info for No Bus:ep_82
PM: Adding info for No Bus:ep_00
hub 1-1:1.0: state 7 ports 6 chg 0000 evt 0010
hub 1-1:1.0: rpm_resume flags 0x4
hub 1-1:1.0: rpm_resume returns 1
hub 1-1:1.0: rpm_suspend flags 0x4
hub 1-1:1.0: rpm_suspend returns 0
hub 2-0:1.0: state 7 ports 3 chg 0002 evt 0000
hub 2-0:1.0: rpm_resume flags 0x4
hub 2-0:1.0: rpm_resume returns 1
hub 2-0:1.0: port 1, status 0501, change 0000, 480 Mb/s
ehci_hcd 0000:00:1d.0: port 1 high speed
ehci_hcd 0000:00:1d.0: GetStatus port:1 status 001005 0  ACK POWER sig=se0 PE CONNECT
usb 2-1: new high speed USB device number 2 using ehci_hcd
ehci_hcd 0000:00:1d.0: port 1 high speed
ehci_hcd 0000:00:1d.0: GetStatus port:1 status 001005 0  ACK POWER sig=se0 PE CONNECT
ehci_hcd 0000:00:1d.0: set dev address 2 for port 1
ehci_hcd 0000:00:1d.0: LPM: no device attached
usb 2-1: rpm_resume flags 0x0
usb 2-1: rpm_resume returns 1
usb 2-1: udev 2, busnum 2, minor = 129
usb 2-1: New USB device found, idVendor=8087, idProduct=0020
usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
PM: Adding info for usb:2-1
usb 2-1: usb_probe_device
usb 2-1: configuration #1 chosen from 1 choice
usb 2-1: rpm_resume flags 0x4
usb 2-1: rpm_resume returns 1
usb 2-1: adding 2-1:1.0 (config #1, interface 0)
PM: Adding info for usb:2-1:1.0
hub 2-1:1.0: usb_probe_interface
hub 2-1:1.0: usb_probe_interface - got id
usb 2-1: rpm_resume flags 0x4
usb 2-1: rpm_resume returns 1
hub 2-1:1.0: USB hub found
hub 2-1:1.0: 8 ports detected
hub 2-1:1.0: standalone hub
hub 2-1:1.0: individual port power switching
hub 2-1:1.0: individual port over-current protection
hub 2-1:1.0: Single TT
hub 2-1:1.0: TT requires at most 8 FS bit times (666 ns)
hub 2-1:1.0: Port indicators are supported
hub 2-1:1.0: power on to power good time: 100ms
hub 2-1:1.0: local power source is good
hub 2-1:1.0: enabling power on all ports
PM: Adding info for No Bus:ep_81
PM: Adding info for No Bus:ep_00
usb 2-1: rpm_suspend flags 0xc
usb 2-1: rpm_suspend returns -16
hub 2-0:1.0: rpm_suspend flags 0x4
hub 2-0:1.0: rpm_suspend returns 0
PM: Adding info for No Bus:input4
input: PS/2 Generic Mouse as /devices/platform/i8042/serio4/input/input4
PM: Adding info for No Bus:mouse0
PM: Adding info for No Bus:event4
hub 2-1:1.0: port 5: status 0101 change 0001
hub 2-1:1.0: port 6: status 0101 change 0001
PM: Adding info for No Bus:card0
PM: Adding info for No Bus:pcmC0D0p
PM: Adding info for No Bus:pcmC0D0c
PM: Adding info for No Bus:dsp
PM: Adding info for No Bus:audio
PM: Adding info for No Bus:controlC0
PM: Adding info for No Bus:mixer
HDA Intel 0000:01:00.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
usb 2-1: link qh256-0001/ffff880156c07800 start 1 [1/0 us]
hub 2-1:1.0: state 7 ports 8 chg 0060 evt 0000
hub 2-1:1.0: rpm_resume flags 0x4
hub 2-1:1.0: rpm_resume returns 1
HDA Intel 0000:01:00.1: setting latency timer to 64
hub 2-1:1.0: port 5, status 0101, change 0000, 12 Mb/s
PM: Adding info for No Bus:card1
PM: Adding info for No Bus:pcmC1D3p
PM: Adding info for No Bus:controlC1
PM: Adding info for No Bus:mixer1
usbcore: registered new interface driver snd-usb-audio
ALSA device list:
usb 2-1.5: new full speed USB device number 3 using ehci_hcd
  #0: HDA Intel at 0xc4500000 irq 22
  #1: HD-Audio Generic at 0xc4420000 irq 17
IPv4 over IPv4 tunneling driver
PM: Adding info for No Bus:tunl0
TCP cubic registered
NET: Registered protocol family 17
lib80211: common routines for IEEE802.11 drivers
lib80211_crypt: registered algorithm 'NULL'
PM: Adding info for No Bus:cpu_dma_latency
PM: Adding info for No Bus:network_latency
PM: Adding info for No Bus:network_throughput
PM: Hibernation image not present or could not be loaded.
rtc_cmos 00:06: setting system clock to 2011-05-01 10:50:35 UTC (1304247035)
usb 2-1.5: ep0 maxpacket = 8
usb 2-1.5: rpm_resume flags 0x0
usb 2-1.5: rpm_resume returns 1
sd 0:0:0:0: rpm_resume flags 0x4
sd 0:0:0:0: rpm_resume returns 1
usb 2-1.5: skipped 1 descriptor after interface
usb 2-1.5: skipped 1 descriptor after interface
usb 2-1.5: default language 0x0409
usb 2-1.5: udev 3, busnum 2, minor = 130
usb 2-1.5: New USB device found, idVendor=056a, idProduct=00e3
usb 2-1.5: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 2-1.5: Product: ISD-V4
usb 2-1.5: Manufacturer: Tablet
PM: Adding info for usb:2-1.5
usb 2-1.5: usb_probe_device
usb 2-1.5: configuration #1 chosen from 1 choice
usb 2-1.5: rpm_resume flags 0x4
usb 2-1.5: rpm_resume returns 1
usb 2-1.5: adding 2-1.5:1.0 (config #1, interface 0)
PM: Adding info for usb:2-1.5:1.0
usbhid 2-1.5:1.0: usb_probe_interface
usbhid 2-1.5:1.0: usb_probe_interface - got id
usb 2-1.5: rpm_resume flags 0x4
usb 2-1.5: rpm_resume returns 1
PM: Adding info for No Bus:ep_81
usb 2-1.5: adding 2-1.5:1.1 (config #1, interface 1)
PM: Adding info for usb:2-1.5:1.1
usbhid 2-1.5:1.1: usb_probe_interface
usbhid 2-1.5:1.1: usb_probe_interface - got id
usb 2-1.5: rpm_resume flags 0x4
usb 2-1.5: rpm_resume returns 1
PM: Adding info for No Bus:ep_82
PM: Adding info for No Bus:ep_00
hub 2-1:1.0: port 6, status 0101, change 0000, 12 Mb/s
usb 2-1.6: new high speed USB device number 4 using ehci_hcd
usb 2-1.6: rpm_resume flags 0x0
usb 2-1.6: rpm_resume returns 1
usb 2-1.6: skipped 1 descriptor after configuration
usb 2-1.6: skipped 6 descriptors after interface
usb 2-1.6: skipped 1 descriptor after endpoint
usb 2-1.6: skipped 6 descriptors after interface
usb 2-1.6: default language 0x0409
usb 2-1.6: udev 4, busnum 2, minor = 131
usb 2-1.6: New USB device found, idVendor=10f1, idProduct=1a16
usb 2-1.6: New USB device strings: Mfr=2, Product=1, SerialNumber=0
EXT3-fs: barriers not enabled
kjournald starting.  Commit interval 5 seconds
EXT3-fs (sda1): mounted filesystem with ordered data mode
VFS: Mounted root (ext3 filesystem) readonly on device 8:1.
usb 2-1.6: Product: HP Webcam
usb 2-1.6: Manufacturer: Importek
PM: Adding info for usb:2-1.6
usb 2-1.6: usb_probe_device
usb 2-1.6: configuration #1 chosen from 1 choice
usb 2-1.6: rpm_resume flags 0x4
usb 2-1.6: rpm_resume returns 1
usb 2-1.6: adding 2-1.6:1.0 (config #1, interface 0)
PM: Adding info for usb:2-1.6:1.0
Freeing unused kernel memory: 432k freed
PM: Adding info for No Bus:ep_83
usb 2-1.6: adding 2-1.6:1.1 (config #1, interface 1)
PM: Adding info for usb:2-1.6:1.1
PM: Adding info for No Bus:ep_00
hub 2-1:1.0: state 7 ports 8 chg 0000 evt 0020
hub 2-1:1.0: rpm_resume flags 0x4
hub 2-1:1.0: rpm_resume returns 1
hub 2-1:1.0: rpm_suspend flags 0x4
hub 2-1:1.0: rpm_suspend returns 0
udev: starting version 151
udevd (1096): /proc/1096/oom_adj is deprecated, please use /proc/1096/oom_score_adj instead.
brcmsmac: module is from the staging directory, the quality is unknown, you have been warned.
brcmsmac 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
brcmsmac 0000:03:00.0: setting latency timer to 64
PM: Adding info for No Bus:0000:03:00.0
sd 0:0:0:0: rpm_resume flags 0x4
sd 0:0:0:0: rpm_resume returns 1
wacom 2-1.5:1.0: usb_probe_interface
wacom 2-1.5:1.0: usb_probe_interface - got id
usb 2-1.5: rpm_resume flags 0x4
usb 2-1.5: rpm_resume returns 1
PM: Adding info for No Bus:input5
input: Wacom ISDv4 E3 Finger as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.5/2-1.5:1.0/input/input5
PM: Adding info for No Bus:mouse1
PM: Adding info for No Bus:event5
wacom 2-1.5:1.0: rpm_suspend flags 0x4
wacom 2-1.5:1.0: rpm_suspend returns 0
wacom 2-1.5:1.1: usb_probe_interface
wacom 2-1.5:1.1: usb_probe_interface - got id
usb 2-1.5: rpm_resume flags 0x4
usb 2-1.5: rpm_resume returns 1
PM: Adding info for No Bus:input6
input: Wacom ISDv4 E3 Pen as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.5/2-1.5:1.1/input/input6
PM: Adding info for No Bus:mouse2
PM: Adding info for No Bus:event6
wacom 2-1.5:1.1: rpm_suspend flags 0x4
wacom 2-1.5:1.1: rpm_suspend returns 0
usbcore: registered new interface driver wacom
wacom: v1.52:USB Wacom tablet driver
[drm] Initialized drm 1.1.0 20060810
r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
r8169 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
r8169 0000:02:00.0: setting latency timer to 64
r8169 0000:02:00.0: no MSI. Back to INTx.
PM: Adding info for No Bus:eth0
r8169 0000:02:00.0: eth0: RTL8168d/8111d at 0xffffc900100ba000, d8:d3:85:39:89:fb, XID 083000c0 IRQ 16
PM: Removing info for No Bus:0000:03:00.0
PM: Adding info for No Bus:0000:03:00.0
sd 0:0:0:0: rpm_resume flags 0x4
sd 0:0:0:0: rpm_resume returns 1
sd 0:0:0:0: rpm_resume flags 0x4
sd 0:0:0:0: rpm_resume returns 1
sd 0:0:0:0: rpm_resume flags 0x4
sd 0:0:0:0: rpm_resume returns 1
PM: Removing info for No Bus:0000:03:00.0
PM: Adding info for No Bus:phy0
ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
PM: Adding info for No Bus:wlan0
PM: Adding info for No Bus:ttm
sd 0:0:0:0: rpm_resume flags 0x4
sd 0:0:0:0: rpm_resume returns 1
sd 0:0:0:0: rpm_resume flags 0x4
sd 0:0:0:0: rpm_resume returns 1
sd 0:0:0:0: rpm_resume flags 0x4
sd 0:0:0:0: rpm_resume returns 1
sd 0:0:0:0: rpm_resume flags 0x4
sd 0:0:0:0: rpm_resume returns 1
sd 0:0:0:0: rpm_resume flags 0x4
sd 0:0:0:0: rpm_resume returns 1
[drm] radeon defaulting to kernel modesetting.
[drm] radeon kernel modesetting enabled.
VGA switcheroo: detected switching method \_SB_.PCI0.GFX0.ATPX handle
checking generic (b0000000 1ff0000) vs hw (a0000000 10000000)
radeon 0000:01:00.0: enabling device (0000 -> 0003)
radeon 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
radeon 0000:01:00.0: setting latency timer to 64
PM: Adding info for No Bus:controlD64
PM: Adding info for No Bus:card0
[drm] initializing kernel modesetting (CEDAR 0x1002:0x68E0).
[drm] register mmio base: 0xC4400000
[drm] register mmio size: 131072
sd 0:0:0:0: rpm_resume flags 0x4
sd 0:0:0:0: rpm_resume returns 1
sd 0:0:0:0: rpm_resume flags 0x4
sd 0:0:0:0: rpm_resume returns 1
sd 0:0:0:0: rpm_resume flags 0x4
sd 0:0:0:0: rpm_resume returns 1
sd 0:0:0:0: rpm_resume flags 0x4
sd 0:0:0:0: rpm_resume returns 1
sd 0:0:0:0: rpm_resume flags 0x4
sd 0:0:0:0: rpm_resume returns 1
sd 0:0:0:0: rpm_resume flags 0x4
sd 0:0:0:0: rpm_resume returns 1
ATOM BIOS: HP
radeon 0000:01:00.0: VRAM: 512M 0x0000000000000000 - 0x000000001FFFFFFF (512M used)
radeon 0000:01:00.0: GTT: 512M 0x0000000020000000 - 0x000000003FFFFFFF
mtrr: no more MTRRs available
[drm] Detected VRAM RAM=512M, BAR=256M
[drm] RAM width 64bits DDR
[TTM] Zone  kernel: Available graphics memory: 1925414 kiB.
[TTM] Initializing pool allocator.
[drm] radeon: 512M of VRAM memory ready
[drm] radeon: 512M of GTT memory ready.
[drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[drm] Driver supports precise vblank timestamp query.
[drm] radeon: irq initialized.
[drm] GART: num cpu pages 131072, num gpu pages 131072
PM: Adding info for platform:radeon_cp.0
[drm] Loading CEDAR Microcode
PM: Adding info for No Bus:radeon_cp.0
PM: Removing info for No Bus:radeon_cp.0
PM: Removing info for platform:radeon_cp.0
r600_cp: Failed to load firmware "radeon/CEDAR_pfp.bin"
[drm:evergreen_startup] *ERROR* Failed to load firmware!
radeon 0000:01:00.0: disabling GPU acceleration
radeon 0000:01:00.0: ffff8801559e4000 unpin not necessary
radeon 0000:01:00.0: ffff8801559e4000 unpin not necessary
PM: Adding info for i2c:i2c-1
PM: Adding info for i2c:i2c-2
PM: Adding info for i2c:i2c-3
PM: Adding info for i2c:i2c-4
PM: Adding info for i2c:i2c-5
PM: Adding info for i2c:i2c-6
PM: Adding info for i2c:i2c-7
PM: Adding info for i2c:i2c-8
PM: Adding info for No Bus:card0-LVDS-1
PM: Adding info for No Bus:card0-HDMI-A-1
PM: Adding info for No Bus:card0-VGA-1
[drm] Radeon Display Connectors
[drm] Connector 0:
[drm]   LVDS
[drm]   DDC: 0x6560 0x6560 0x6564 0x6564 0x6568 0x6568 0x656c 0x656c
[drm]   Encoders:
[drm]     LCD1: INTERNAL_UNIPHY
[drm] Connector 1:
[drm]   HDMI-A
[drm]   HPD1
[drm]   DDC: 0x6430 0x6430 0x6434 0x6434 0x6438 0x6438 0x643c 0x643c
[drm]   Encoders:
[drm]     DFP1: INTERNAL_UNIPHY1
[drm] Connector 2:
[drm]   VGA
[drm]   DDC: 0x64d8 0x64d8 0x64dc 0x64dc 0x64e0 0x64e0 0x64e4 0x64e4
[drm]   Encoders:
[drm]     CRT1: INTERNAL_KLDSCP_DAC1
[drm] Internal thermal controller with fan control
PM: Adding info for No Bus:hwmon2
[drm] radeon: power management initialized
[drm] fb mappable at 0xA0040000
[drm] vram apper at 0xA0000000
[drm] size 4096000
[drm] fb depth is 24
[drm]    pitch is 5120
checking generic (b0000000 1ff0000) vs hw (a0000000 10000000)
PM: Adding info for No Bus:fb1
fb1: radeondrmfb frame buffer device
drm: registered panic notifier
[drm] Initialized radeon 2.9.0 20080528 for 0000:01:00.0 on minor 0
sd 0:0:0:0: rpm_resume flags 0x4
sd 0:0:0:0: rpm_resume returns 1
EXT3-fs (sda1): using internal journal
sd 0:0:0:0: rpm_resume flags 0x4
sd 0:0:0:0: rpm_resume returns 1
EXT3-fs: barriers not enabled
kjournald starting.  Commit interval 5 seconds
EXT3-fs (sda3): using internal journal
EXT3-fs (sda3): mounted filesystem with ordered data mode
sd 0:0:0:0: rpm_resume flags 0x4
sd 0:0:0:0: rpm_resume returns 1
EXT3-fs: barriers not enabled
kjournald starting.  Commit interval 5 seconds
EXT3-fs (sda5): using internal journal
EXT3-fs (sda5): mounted filesystem with ordered data mode
sd 0:0:0:0: rpm_resume flags 0x4
sd 0:0:0:0: rpm_resume returns 1
EXT2-fs (sda6): warning: mounting unchecked fs, running e2fsck is recommended
PM: Adding info for No Bus:vcs2
PM: Adding info for No Bus:vcsa2
PM: Adding info for No Bus:vcs3
PM: Adding info for No Bus:vcsa3
PM: Adding info for No Bus:vcs4
PM: Adding info for No Bus:vcsa4
PM: Adding info for No Bus:vcs5
PM: Adding info for No Bus:vcsa5
PM: Adding info for No Bus:vcs6
PM: Adding info for No Bus:vcsa6
PM: Adding info for No Bus:vcs7
PM: Adding info for No Bus:vcsa7
PM: Adding info for No Bus:vcs8
PM: Adding info for No Bus:vcsa8
PM: Adding info for No Bus:vcs9
PM: Adding info for No Bus:vcsa9
PM: Adding info for No Bus:vcs10
PM: Adding info for No Bus:vcsa10
PM: Adding info for No Bus:vcs11
PM: Adding info for No Bus:vcsa11
PM: Adding info for No Bus:vcs12
PM: Adding info for No Bus:vcsa12
r8169 0000:02:00.0: rpm_resume flags 0x4
r8169 0000:02:00.0: rpm_resume returns 1
PM: Adding info for No Bus:0000:02:00.0
PM: Removing info for No Bus:0000:02:00.0
r8169 0000:02:00.0: eth0: unable to apply firmware patch
r8169 0000:02:00.0: eth0: link down
sd 0:0:0:0: rpm_resume flags 0x4
sd 0:0:0:0: rpm_resume returns 1
sd 0:0:0:0: rpm_resume flags 0x4
sd 0:0:0:0: rpm_resume returns 1
Adding 4000180k swap on /dev/sda2.  Priority:-1 extents:1 across:4000180k 
wlan0: authenticate with 00:1c:4a:07:7f:76 (try 1)
wlan0: authenticated
wlan0: associate with 00:1c:4a:07:7f:76 (try 1)
wlan0: RX AssocResp from 00:1c:4a:07:7f:76 (capab=0x431 status=0 aid=1)
wlan0: associated
atkbd serio0: Unknown key pressed (translated set 2, code 0x81 on isa0060/serio0).
atkbd serio0: Use 'setkeycodes e001 <keycode>' to make it known.
pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:02.0: setting latency timer to 64
PM: Adding info for No Bus:card1
mtrr: no more MTRRs available
[drm] MTRR allocation failed.  Graphics performance may suffer.
PM: Adding info for i2c:i2c-9
PM: Adding info for i2c:i2c-10
PM: Adding info for i2c:i2c-11
PM: Adding info for i2c:i2c-12
PM: Adding info for i2c:i2c-13
PM: Adding info for i2c:i2c-14
PM: Adding info for i2c:i2c-15
PM: Adding info for i2c:i2c-16
[drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[drm] No driver support for vblank timestamp query.
[Firmware Bug]: ACPI: No _BQC method, cannot determine initial brightness
PM: Adding info for No Bus:acpi_video0
PM: Adding info for No Bus:cooling_device5
acpi device:02: registered as cooling_device5
PM: Adding info for No Bus:input7
input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input7
PM: Adding info for No Bus:event7
ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[Firmware Bug]: ACPI(PEGP) defines _DOD but not _DOS
PM: Adding info for No Bus:acpi_video1
PM: Adding info for No Bus:cooling_device6
acpi device:0b: registered as cooling_device6
PM: Adding info for No Bus:input8
input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:09/LNXVIDEO:01/input/input8
PM: Adding info for No Bus:event8
ACPI: Video Device [PEGP] (multi-head: yes  rom: no  post: no)
[drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 1
atkbd serio0: Unknown key pressed (translated set 2, code 0x81 on isa0060/serio0).
atkbd serio0: Use 'setkeycodes e001 <keycode>' to make it known.
atkbd serio0: Unknown key pressed (translated set 2, code 0x81 on isa0060/serio0).
atkbd serio0: Use 'setkeycodes e001 <keycode>' to make it known.
atkbd serio0: Unknown key pressed (translated set 2, code 0x81 on isa0060/serio0).
atkbd serio0: Use 'setkeycodes e001 <keycode>' to make it known.
atkbd serio0: Unknown key pressed (translated set 2, code 0x81 on isa0060/serio0).
atkbd serio0: Use 'setkeycodes e001 <keycode>' to make it known.

--WIyZ46R2i8wDzkSu--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757233Ab0KPS6A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 13:58:00 -0500
Received: from eazy.amigager.de ([213.239.192.238]:34540 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756185Ab0KPS5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 13:57:54 -0500
X-Greylist: delayed 530 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Nov 2010 13:57:54 EST
Date: Tue, 16 Nov 2010 19:49:14 +0100
From: Tino Keitel <tino.keitel@tikei.de>
To: linux-kernel@vger.kernel.org
Subject: DVI/EDID broken with Intel i945 graphics and 2.6.37-rc2
Message-ID: <20101116184914.GA15794@mac.home>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="NzB8fVQJ5HfG6fxh"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

2.6.37-rc2 doesn't seem to detect the LCD connected via DVI on my Mac
mini Core2 Duo with i945 graphics:

[drm] initialized overlay support
No connectors reported connected with modes
[drm] Cannot find any crtc or sizes - going 1024x768

The text console is just black, and X uses a bogus resolution
(1152x864). The native resolution of the LCD is 1680x1050.

It works with 2.6.36.

Note that the Mac mini reports the EDID data via the analog GPIO port
IIRC (if that matters).

Regards,
Tino

--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg

Linux version 2.6.37-rc2-00001-g9984b1f (scorpion@mac) (gcc version 4.4.5 (Debian 4.4.5-8) ) #5 SMP Tue Nov 16 09:27:33 CET 2010
Command line: BOOT_IMAGE=/boot/vmlinuz-2.6.37-rc2-00001-g9984b1f root=/dev/sda4 ro i915.modeset=1 gpt
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000008f000 (usable)
 BIOS-e820: 000000000008f000 - 0000000000090000 (ACPI NVS)
 BIOS-e820: 0000000000090000 - 00000000000a0000 (usable)
 BIOS-e820: 0000000000100000 - 00000000be0c5000 (usable)
 BIOS-e820: 00000000be0c5000 - 00000000be2c6000 (ACPI NVS)
 BIOS-e820: 00000000be2c6000 - 00000000bee4b000 (usable)
 BIOS-e820: 00000000bee4b000 - 00000000bee71000 (unusable)
 BIOS-e820: 00000000bee71000 - 00000000bee80000 (usable)
 BIOS-e820: 00000000bee80000 - 00000000beeab000 (reserved)
 BIOS-e820: 00000000beeab000 - 00000000beeb7000 (usable)
 BIOS-e820: 00000000beeb7000 - 00000000beebc000 (ACPI data)
 BIOS-e820: 00000000beebc000 - 00000000beebe000 (usable)
 BIOS-e820: 00000000beebe000 - 00000000beeef000 (ACPI NVS)
 BIOS-e820: 00000000beeef000 - 00000000beeff000 (ACPI data)
 BIOS-e820: 00000000beeff000 - 00000000bef00000 (reserved)
 BIOS-e820: 00000000e00f8000 - 00000000e00f9000 (reserved)
 BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
 BIOS-e820: 00000000fffb0000 - 00000000fffe0000 (reserved)
NX (Execute Disable) protection: active
DMI 2.4 present.
DMI: Mac-F4208EAA/Macmini2,1, BIOS     MM21.88Z.009A.B00.0706281359 06/28/07
e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
No AGP bridge found
last_pfn = 0xbeebe max_arch_pfn = 0x400000000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-CFFFF write-protect
  D0000-DFFFF uncachable
  E0000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 0FFE00000 mask FFFE00000 write-protect
  1 base 000000000 mask F80000000 write-back
  2 base 080000000 mask FC0000000 write-back
  3 base 0BF000000 mask FFF000000 uncachable
  4 base 000000000 mask F80000000 write-back
  5 base 080000000 mask FC0000000 write-back
  6 base 0BEF00000 mask FFFF00000 uncachable
  7 disabled
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
initial memory mapped : 0 - 20000000
init_memory_mapping: 0000000000000000-00000000beebe000
 0000000000 - 00bee00000 page 2M
 00bee00000 - 00beebe000 page 4k
kernel direct mapping tables up to beebe000 @ 1fffb000-20000000
ACPI: RSDP 000000000009fc10 00024 (v02 APPLE )
ACPI: XSDT 00000000beefd1c0 00074 (v01 APPLE   Apple00 0000009A      01000013)
ACPI: FACP 00000000beefb000 000F4 (v03 APPLE   Apple00 0000009A Loki 0000005F)
ACPI: DSDT 00000000beef0000 0384E (v01 APPLE   Macmini 00020001 INTL 20050309)
ACPI: FACS 00000000beec0000 00040
ACPI: HPET 00000000beefa000 00038 (v01 APPLE   Apple00 00000001 Loki 0000005F)
ACPI: APIC 00000000beef9000 00068 (v01 APPLE   Apple00 00000001 Loki 0000005F)
ACPI: MCFG 00000000beef8000 0003C (v01 APPLE   Apple00 00000001 Loki 0000005F)
ACPI: ASF! 00000000beef7000 000A0 (v32 APPLE   Apple00 00000001 Loki 0000005F)
ACPI: SBST 00000000beef5000 00030 (v01 APPLE   Apple00 00000001 Loki 0000005F)
ACPI: ECDT 00000000beef4000 00053 (v01 APPLE   Apple00 00000001 Loki 0000005F)
ACPI: SSDT 00000000beebb000 0064F (v01 APPLE   SataPri 00001000 INTL 20050309)
ACPI: SSDT 00000000beeba000 0069C (v01 APPLE   SataSec 00001000 INTL 20050309)
ACPI: SSDT 00000000beeef000 004DC (v01 APPLE     CpuPm 00003000 INTL 20050309)
ACPI: Local APIC address 0xfee00000
 [ffffea0000000000-ffffea00029fffff] PMD -> [ffff8800ba800000-ffff8800bd1fffff] on node 0
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   empty
Movable zone start PFN for each node
early_node_map[7] active PFN ranges
    0: 0x00000010 -> 0x0000008f
    0: 0x00000090 -> 0x000000a0
    0: 0x00000100 -> 0x000be0c5
    0: 0x000be2c6 -> 0x000bee4b
    0: 0x000bee71 -> 0x000bee80
    0: 0x000beeab -> 0x000beeb7
    0: 0x000beebc -> 0x000beebe
On node 0 totalpages: 781302
  DMA zone: 56 pages used for memmap
  DMA zone: 7 pages reserved
  DMA zone: 3920 pages, LIFO batch:0
  DMA32 zone: 10636 pages used for memmap
  DMA32 zone: 766683 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x408
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
Allocating PCI resources starting at bef00000 (gap: bef00000:211f8000)
setup_percpu: NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
PERCPU: Embedded 25 pages/cpu @ffff8800bde00000 s73472 r8192 d20736 u1048576
pcpu-alloc: s73472 r8192 d20736 u1048576 alloc=1*2097152
pcpu-alloc: [0] 0 1 
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 770603
Kernel command line: BOOT_IMAGE=/boot/vmlinuz-2.6.37-rc2-00001-g9984b1f root=/dev/sda4 ro i915.modeset=1 gpt
PID hash table entries: 4096 (order: 3, 32768 bytes)
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Checking aperture...
No AGP bridge found
Memory: 3068304k/3128056k available (4583k kernel code, 2848k absent, 56904k reserved, 1819k data, 432k init)
Hierarchical RCU implementation.
	RCU-based detection of stalled CPUs is disabled.
NR_IRQS:320
Extended CMOS year: 2000
Console: colour dummy device 80x25
console [tty0] enabled
hpet clockevent registered
Fast TSC calibration using PIT
Detected 1999.575 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 4000.78 BogoMIPS (lpj=6665250)
pid_max: default: 32768 minimum: 301
Mount-cache hash table entries: 256
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
using mwait in idle threads.
Performance Events: PEBS fmt0-, Core2 events, Intel PMU driver.
PEBS disabled due to CPU errata.
... version:                2
... bit width:              40
... generic registers:      2
... value mask:             000000ffffffffff
... max period:             000000007fffffff
... fixed-purpose events:   3
... event mask:             0000000700000003
ACPI: Core revision 20101013
Setting APIC routing to flat
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Core(TM)2 CPU         T7200  @ 2.00GHz stepping 06
Booting Node   0, Processors  #1 Ok.
Brought up 2 CPUs
Total of 2 processors activated (8002.37 BogoMIPS).
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
PCI: not using MMCONFIG
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: EC: EC description table is found, configuring boot EC
[Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
ACPI: SSDT 00000000beeb8c10 0026C (v01 APPLE   Cpu0Ist 00003000 INTL 20050309)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT           (null) 0026C (v01 APPLE   Cpu0Ist 00003000 INTL 20050309)
ACPI: SSDT 00000000beeb7c90 00232 (v01 APPLE   Cpu0Cst 00003001 INTL 20050309)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT           (null) 00232 (v01 APPLE   Cpu0Cst 00003001 INTL 20050309)
ACPI: SSDT 00000000beeb8f10 00087 (v01 APPLE   Cpu1Ist 00003000 INTL 20050309)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT           (null) 00087 (v01 APPLE   Cpu1Ist 00003000 INTL 20050309)
ACPI: SSDT 00000000beeb7f10 00085 (v01 APPLE   Cpu1Cst 00003000 INTL 20050309)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT           (null) 00085 (v01 APPLE   Cpu1Cst 00003000 INTL 20050309)
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S5)
ACPI: Using IOAPIC for interrupt routing
PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI motherboard resources
ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
ACPI: No dock devices found.
PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7] (ignored)
pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff] (ignored)
pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
pci_root PNP0A08:00: host bridge window [mem 0xc0000000-0xfebfffff] (ignored)
pci 0000:00:00.0: [8086:27a0] type 0 class 0x000600
pci 0000:00:02.0: [8086:27a2] type 0 class 0x000300
pci 0000:00:02.0: reg 10: [mem 0xd0380000-0xd03fffff]
pci 0000:00:02.0: reg 14: [io  0x20f0-0x20f7]
pci 0000:00:02.0: reg 18: [mem 0xc0000000-0xcfffffff pref]
pci 0000:00:02.0: reg 1c: [mem 0xd0400000-0xd043ffff]
pci 0000:00:02.1: [8086:27a6] type 0 class 0x000380
pci 0000:00:02.1: reg 10: [mem 0xd0300000-0xd037ffff]
pci 0000:00:07.0: [8086:27a3] type 0 class 0x001101
pci 0000:00:07.0: reg 10: [mem 0xd0444000-0xd0444fff]
pci 0000:00:1b.0: [8086:27d8] type 0 class 0x000403
pci 0000:00:1b.0: reg 10: [mem 0xd0440000-0xd0443fff 64bit]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: PME# disabled
pci 0000:00:1c.0: [8086:27d0] type 1 class 0x000604
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.1: [8086:27d2] type 1 class 0x000604
pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.1: PME# disabled
pci 0000:00:1d.0: [8086:27c8] type 0 class 0x000c03
pci 0000:00:1d.0: reg 20: [io  0x20a0-0x20bf]
pci 0000:00:1d.1: [8086:27c9] type 0 class 0x000c03
pci 0000:00:1d.1: reg 20: [io  0x2080-0x209f]
pci 0000:00:1d.2: [8086:27ca] type 0 class 0x000c03
pci 0000:00:1d.2: reg 20: [io  0x2060-0x207f]
pci 0000:00:1d.3: [8086:27cb] type 0 class 0x000c03
pci 0000:00:1d.3: reg 20: [io  0x2040-0x205f]
pci 0000:00:1d.7: [8086:27cc] type 0 class 0x000c03
pci 0000:00:1d.7: reg 10: [mem 0xd0445400-0xd04457ff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1e.0: [8086:2448] type 1 class 0x000604
pci 0000:00:1f.0: [8086:27b9] type 0 class 0x000601
pci 0000:00:1f.0: quirk: [io  0x0400-0x047f] claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: [io  0x0500-0x053f] claimed by ICH6 GPIO
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0680 (mask 000f)
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 1640 (mask 000f)
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 4 PIO at 0300 (mask 001f)
pci 0000:00:1f.1: [8086:27df] type 0 class 0x000101
pci 0000:00:1f.1: reg 10: [io  0x20e8-0x20ef]
pci 0000:00:1f.1: reg 14: [io  0x2104-0x2107]
pci 0000:00:1f.1: reg 18: [io  0x20e0-0x20e7]
pci 0000:00:1f.1: reg 1c: [io  0x2100-0x2103]
pci 0000:00:1f.1: reg 20: [io  0x20c0-0x20cf]
pci 0000:00:1f.2: [8086:27c5] type 0 class 0x000106
pci 0000:00:1f.2: reg 10: [io  0x20d8-0x20df]
pci 0000:00:1f.2: reg 14: [io  0x20fc-0x20ff]
pci 0000:00:1f.2: reg 18: [io  0x20d0-0x20d7]
pci 0000:00:1f.2: reg 1c: [io  0x20f8-0x20fb]
pci 0000:00:1f.2: reg 20: [io  0x2020-0x202f]
pci 0000:00:1f.2: reg 24: [mem 0xd0445000-0xd04453ff]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.2: PME# disabled
pci 0000:00:1f.3: [8086:27da] type 0 class 0x000c05
pci 0000:00:1f.3: reg 20: [io  0xefa0-0xefbf]
pci 0000:01:00.0: [11ab:4362] type 0 class 0x000200
pci 0000:01:00.0: reg 10: [mem 0xd0200000-0xd0203fff 64bit]
pci 0000:01:00.0: reg 18: [io  0x1000-0x10ff]
pci 0000:01:00.0: reg 30: [mem 0xfffe0000-0xffffffff pref]
pci 0000:01:00.0: supports D1 D2
pci 0000:01:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:01:00.0: PME# disabled
pci 0000:01:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
pci 0000:00:1c.0: PCI bridge to [bus 01-01]
pci 0000:00:1c.0:   bridge window [io  0x1000-0x1fff]
pci 0000:00:1c.0:   bridge window [mem 0xd0200000-0xd02fffff]
pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:02:00.0: [168c:001c] type 0 class 0x000200
pci 0000:02:00.0: reg 10: [mem 0xd0100000-0xd010ffff 64bit]
pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
pci 0000:00:1c.1: PCI bridge to [bus 02-02]
pci 0000:00:1c.1:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:1c.1:   bridge window [mem 0xd0100000-0xd01fffff]
pci 0000:00:1c.1:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:03:03.0: [11c1:5811] type 0 class 0x000c00
pci 0000:03:03.0: reg 10: [mem 0xd0000000-0xd0000fff]
pci 0000:03:03.0: supports D1 D2
pci 0000:03:03.0: PME# supported from D0 D1 D2 D3hot
pci 0000:03:03.0: PME# disabled
pci 0000:00:1e.0: PCI bridge to [bus 03-03] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:1e.0:   bridge window [mem 0xd0000000-0xd00fffff]
pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:00:1e.0:   bridge window [io  0x0000-0xffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x00000000-0xfffffffff] (subtractive decode)
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 11 12 14 15) *0, disabled.
vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
Advanced Linux Sound Architecture Driver Version 1.0.23.
PCI: Using ACPI for IRQ routing
PCI: pci_cache_line_size set to 64 bytes
reserve RAM buffer: 000000000008f000 - 000000000008ffff 
reserve RAM buffer: 00000000be0c5000 - 00000000bfffffff 
reserve RAM buffer: 00000000bee4b000 - 00000000bfffffff 
reserve RAM buffer: 00000000bee80000 - 00000000bfffffff 
reserve RAM buffer: 00000000beeb7000 - 00000000bfffffff 
reserve RAM buffer: 00000000beebe000 - 00000000bfffffff 
HPET: 3 timers in total, 0 timers will be used for per-cpu timer
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 comparators, 64-bit 14.318180 MHz counter
Switching to clocksource tsc
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp 00:00: [bus 00-ff]
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
pnp 00:00: [mem 0xc0000000-0xfebfffff window]
pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
pnp 00:01: [mem 0xe0000000-0xefffffff]
pnp 00:01: [mem 0xfed14000-0xfed17fff]
pnp 00:01: [mem 0xfed18000-0xfed18fff]
pnp 00:01: [mem 0xfed19000-0xfed19fff]
pnp 00:01: [mem 0xfed1c000-0xfed1ffff]
pnp 00:01: [mem 0xfed20000-0xfed8ffff]
pnp 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:02: [io  0x0300-0x031f]
pnp 00:02: [irq 6]
pnp 00:02: Plug and Play ACPI device, IDs APP0001 (active)
pnp 00:03: [io  0x0000-0x001f]
pnp 00:03: [io  0x0081-0x0091]
pnp 00:03: [io  0x0093-0x009f]
pnp 00:03: [io  0x00c0-0x00df]
pnp 00:03: [dma 4]
pnp 00:03: Plug and Play ACPI device, IDs PNP0200 (active)
pnp 00:04: [mem 0xff000000-0xffffffff]
pnp 00:04: Plug and Play ACPI device, IDs INT0800 (active)
pnp 00:05: [irq 0 disabled]
pnp 00:05: [irq 8]
pnp 00:05: [mem 0xfed00000-0xfed003ff]
pnp 00:05: Plug and Play ACPI device, IDs PNP0103 PNP0c01 (active)
pnp 00:06: [io  0x00f0]
pnp 00:06: [irq 13]
pnp 00:06: Plug and Play ACPI device, IDs PNP0c04 (active)
pnp 00:07: [io  0x002e-0x002f]
pnp 00:07: [io  0x004e-0x004f]
pnp 00:07: [io  0x0061]
pnp 00:07: [io  0x0063]
pnp 00:07: [io  0x0065]
pnp 00:07: [io  0x0067]
pnp 00:07: [io  0x0070]
pnp 00:07: [io  0x0080]
pnp 00:07: [io  0x0092]
pnp 00:07: [io  0x00b2-0x00b3]
pnp 00:07: [io  0x0680-0x06ef]
pnp 00:07: [io  0x0800-0x080f]
pnp 00:07: [io  0x0810-0x0817]
pnp 00:07: [io  0x0400-0x047f]
pnp 00:07: [io  0x0500-0x053f]
pnp 00:07: [io  0x1640-0x164f]
pnp 00:07: disabling [io  0x1640-0x164f] because it overlaps 0000:00:1c.0 BAR 7 [io  0x1000-0x1fff]
pnp 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:08: [io  0x0070-0x0077]
pnp 00:08: Plug and Play ACPI device, IDs PNP0b00 (active)
pnp: PnP ACPI: found 9 devices
ACPI: ACPI bus type pnp unregistered
system 00:01: [mem 0xe0000000-0xefffffff] could not be reserved
system 00:01: [mem 0xfed14000-0xfed17fff] has been reserved
system 00:01: [mem 0xfed18000-0xfed18fff] has been reserved
system 00:01: [mem 0xfed19000-0xfed19fff] has been reserved
system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
system 00:01: [mem 0xfed20000-0xfed8ffff] has been reserved
system 00:05: [mem 0xfed00000-0xfed003ff] has been reserved
system 00:07: [io  0x0680-0x06ef] has been reserved
system 00:07: [io  0x0800-0x080f] has been reserved
system 00:07: [io  0x0810-0x0817] has been reserved
system 00:07: [io  0x0400-0x047f] has been reserved
system 00:07: [io  0x0500-0x053f] has been reserved
pci 0000:01:00.0: no compatible bridge window for [mem 0xfffe0000-0xffffffff pref]
pci 0000:00:1c.0: BAR 9: assigned [mem 0xffd00000-0xffefffff pref]
pci 0000:00:1c.1: BAR 9: assigned [mem 0xfffe00000-0xfffffffff 64bit pref]
pci 0000:00:1c.1: BAR 7: assigned [io  0xf000-0xffff]
pci 0000:01:00.0: BAR 6: assigned [mem 0xffee0000-0xffefffff pref]
pci 0000:00:1c.0: PCI bridge to [bus 01-01]
pci 0000:00:1c.0:   bridge window [io  0x1000-0x1fff]
pci 0000:00:1c.0:   bridge window [mem 0xd0200000-0xd02fffff]
pci 0000:00:1c.0:   bridge window [mem 0xffd00000-0xffefffff pref]
pci 0000:00:1c.1: PCI bridge to [bus 02-02]
pci 0000:00:1c.1:   bridge window [io  0xf000-0xffff]
pci 0000:00:1c.1:   bridge window [mem 0xd0100000-0xd01fffff]
pci 0000:00:1c.1:   bridge window [mem 0xfffe00000-0xfffffffff 64bit pref]
pci 0000:00:1e.0: PCI bridge to [bus 03-03]
pci 0000:00:1e.0:   bridge window [io  disabled]
pci 0000:00:1e.0:   bridge window [mem 0xd0000000-0xd00fffff]
pci 0000:00:1e.0:   bridge window [mem pref disabled]
pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.0: setting latency timer to 64
pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:1c.1: setting latency timer to 64
pci 0000:00:1e.0: power state changed by ACPI to D0
pci 0000:00:1e.0: power state changed by ACPI to D0
pci 0000:00:1e.0: setting latency timer to 64
pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
pci_bus 0000:00: resource 1 [mem 0x00000000-0xfffffffff]
pci_bus 0000:01: resource 0 [io  0x1000-0x1fff]
pci_bus 0000:01: resource 1 [mem 0xd0200000-0xd02fffff]
pci_bus 0000:01: resource 2 [mem 0xffd00000-0xffefffff pref]
pci_bus 0000:02: resource 0 [io  0xf000-0xffff]
pci_bus 0000:02: resource 1 [mem 0xd0100000-0xd01fffff]
pci_bus 0000:02: resource 2 [mem 0xfffe00000-0xfffffffff 64bit pref]
pci_bus 0000:03: resource 1 [mem 0xd0000000-0xd00fffff]
pci_bus 0000:03: resource 4 [io  0x0000-0xffff]
pci_bus 0000:03: resource 5 [mem 0x00000000-0xfffffffff]
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
PCI: CLS mismatch (256 != 64), using 64 bytes
microcode: CPU0 sig=0x6f6, pf=0x20, revision=0xc7
microcode: CPU1 sig=0x6f6, pf=0x20, revision=0xc7
microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
SGI XFS with security attributes, large block/inode numbers, no debug enabled
msgmni has been set to 5992
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
pcieport 0000:00:1c.0: ACPI _OSC control granted for 0x1d
pcieport 0000:00:1c.0: setting latency timer to 64
pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
pcieport 0000:00:1c.1: ACPI _OSC control granted for 0x1d
pcieport 0000:00:1c.1: setting latency timer to 64
pcieport 0000:00:1c.1: irq 41 for MSI/MSI-X
pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
pci 0000:01:00.0: Signaling PME through PCIe PME interrupt
pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
pcieport 0000:00:1c.1: Signaling PME through PCIe PME interrupt
pci 0000:02:00.0: Signaling PME through PCIe PME interrupt
pcie_pme 0000:00:1c.1:pcie01: service driver pcie_pme loaded
intel_idle: MWAIT substates: 0x22220
intel_idle: does not run on family 6 model 15
input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
ACPI: Power Button [PWRB]
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
ACPI: Power Button [PWRF]
input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input2
ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
ACPI: acpi_idle registered with cpuidle
Monitor-Mwait will be used to enter C-1 state
Monitor-Mwait will be used to enter C-2 state
Marking TSC unstable due to TSC halts in idle
Switching to clocksource hpet
Linux agpgart interface v0.103
agpgart-intel 0000:00:00.0: Intel 945GM Chipset
agpgart-intel 0000:00:00.0: detected gtt size: 262144K total, 262144K mappable
agpgart-intel 0000:00:00.0: detected 16384K stolen memory
agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xc0000000
[drm] Initialized drm 1.1.0 20060810
i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
i915 0000:00:02.0: setting latency timer to 64
vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[drm] initialized overlay support
No connectors reported connected with modes
[drm] Cannot find any crtc or sizes - going 1024x768
Console: switching to colour frame buffer device 128x48
fb0: inteldrmfb frame buffer device
drm: registered panic notifier
[drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
ahci 0000:00:1f.2: version 3.0
ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ahci 0000:00:1f.2: irq 42 for MSI/MSI-X
ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 1.5 Gbps 0x4 impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq ilck pm led clo pio slum part 
ahci 0000:00:1f.2: setting latency timer to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
ata1: DUMMY
ata2: DUMMY
ata3: SATA max UDMA/133 irq_stat 0x00000040, connection status changed irq 42
ata4: DUMMY
firewire_ohci 0000:03:03.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
firewire_ohci: Added fw-ohci device 0000:03:03.0, OHCI v1.0, 8 IR + 8 IT contexts, quirks 0x0
usbcore: registered new interface driver uas
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
PNP: No PS/2 controller found. Probing ports directly.
i8042.c: No controller found.
mice: PS/2 mouse device common for all mice
rtc_cmos 00:08: RTC can wake from S4
rtc_cmos 00:08: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
applesmc: Apple Macmini detected:
applesmc:  - Model without accelerometer
applesmc:  - Model without light sensors and backlight
applesmc:  - Model with 2 temperature sensors
applesmc: device successfully initialized.
applesmc: 1 fans found.
applesmc: driver successfully loaded.
coretemp coretemp.0: TjMax is assumed as 100 C!
coretemp coretemp.1: TjMax is assumed as 100 C!
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.18.0-ioctl (2010-06-29) initialised: dm-devel@redhat.com
cpuidle: using governor ladder
cpuidle: using governor menu
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
ALSA device list:
  No soundcards found.
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
ip_tables: (C) 2000-2006 Netfilter Core Team
TCP cubic registered
NET: Registered protocol family 17
Registering the dns_resolver key type
rtc_cmos 00:08: setting system clock to 2010-11-16 08:39:06 UTC (1289896746)
firewire_core: created device fw0: GUID 002332fffe153c0e, S400
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata3.00: ATA-8: Hitachi HTS725050A9A364, PC4OC70E, max UDMA/133
ata3.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
ata3.00: configured for UDMA/133
scsi 2:0:0:0: Direct-Access     ATA      Hitachi HTS72505 PC4O PQ: 0 ANSI: 5
sd 2:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: Attached scsi generic sg0 type 0
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 sda4 sda5
sd 2:0:0:0: [sda] Attached SCSI disk
EXT3-fs: barriers not enabled
kjournald starting.  Commit interval 5 seconds
EXT3-fs (sda4): mounted filesystem with writeback data mode
VFS: Mounted root (ext3 filesystem) readonly on device 8:4.
Freeing unused kernel memory: 432k freed
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:00:1d.7: enabling device (0000 -> 0002)
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 21 (level, low) -> IRQ 21
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
sky2: driver version 1.28
sky2 0000:01:00.0: enabling device (0000 -> 0003)
sky2 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
sky2 0000:01:00.0: setting latency timer to 64
sky2 0000:01:00.0: Yukon-2 EC chip revision 2
sky2 0000:01:00.0: irq 43 for MSI/MSI-X
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
sky2 0000:01:00.0: eth0: addr 00:1f:f3:44:83:6c
ehci_hcd 0000:00:1d.7: using broken periodic workaround
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
ehci_hcd 0000:00:1d.7: irq 21, io mem 0xd0445400
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.37-rc2-00001-g9984b1f ehci_hcd
usb usb1: SerialNumber: 0000:00:1d.7
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
ata_piix 0000:00:1f.1: version 2.13
ata_piix 0000:00:1f.1: power state changed by ACPI to D0
ata_piix 0000:00:1f.1: power state changed by ACPI to D0
ata_piix 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
ata_piix 0000:00:1f.1: setting latency timer to 64
uhci_hcd: USB Universal Host Controller Interface driver
scsi4 : ata_piix
scsi5 : ata_piix
ata5: PATA max UDMA/100 cmd 0x20e8 ctl 0x2104 bmdma 0x20c0 irq 18
ata6: PATA max UDMA/100 cmd 0x20e0 ctl 0x2100 bmdma 0x20c8 irq 18
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
cfg80211: Calling CRDA to update world regulatory domain
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: irq 21, io base 0x000020a0
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: UHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.37-rc2-00001-g9984b1f uhci_hcd
usb usb2: SerialNumber: 0000:00:1d.0
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: irq 19, io base 0x00002080
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.37-rc2-00001-g9984b1f uhci_hcd
usb usb3: SerialNumber: 0000:00:1d.1
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: irq 18, io base 0x00002060
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.37-rc2-00001-g9984b1f uhci_hcd
usb usb4: SerialNumber: 0000:00:1d.2
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1d.3: setting latency timer to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.3: irq 16, io base 0x00002040
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.37-rc2-00001-g9984b1f uhci_hcd
usb usb5: SerialNumber: 0000:00:1d.3
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
ata5.00: ATAPI: PIONEER DVD-RW  DVR-K06, Q617, max UDMA/33
ata5.00: configured for UDMA/33
scsi 4:0:0:0: CD-ROM            PIONEER  DVD-RW  DVR-K06  Q617 PQ: 0 ANSI: 5
usb 1-1: new high speed USB device using ehci_hcd and address 2
sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda caddy
cdrom: Uniform CD-ROM driver Revision: 3.20
sr 4:0:0:0: Attached scsi CD-ROM sr0
sr 4:0:0:0: Attached scsi generic sg1 type 5
HDA Intel 0000:00:1b.0: enabling device (0000 -> 0002)
HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
HDA Intel 0000:00:1b.0: irq 44 for MSI/MSI-X
HDA Intel 0000:00:1b.0: setting latency timer to 64
ath5k 0000:02:00.0: enabling device (0000 -> 0002)
ath5k 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
ath5k 0000:02:00.0: setting latency timer to 64
ath5k 0000:02:00.0: registered as 'phy0'
usb 1-1: New USB device found, idVendor=056d, idProduct=0000
usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 1-1: Product: USB HUB
usb 1-1: Manufacturer: EIZO
hub 1-1:1.0: USB hub found
hub 1-1:1.0: 3 ports detected
usb 1-5: new high speed USB device using ehci_hcd and address 4
usb 1-5: New USB device found, idVendor=05e3, idProduct=0608
usb 1-5: New USB device strings: Mfr=0, Product=1, SerialNumber=0
usb 1-5: Product: USB2.0 Hub
hub 1-5:1.0: USB hub found
hub 1-5:1.0: 4 ports detected
usb 1-6: new high speed USB device using ehci_hcd and address 5
ath: EEPROM regdomain: 0x6a
ath: EEPROM indicates we should expect a direct regpair map
ath: Country alpha2 being used: 00
ath: Regpair used: 0x6a
usb 1-6: New USB device found, idVendor=13d3, idProduct=3206
usb 1-6: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 1-6: Product: VP-7045
usb 1-6: Manufacturer: TWINHAN
hda_codec: STAC922x, Apple subsys_id=106b0800
ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
ath5k phy0: Atheros AR5414 chip found (MAC: 0xa3, PHY: 0x61)
dvb-usb: found a 'Twinhan USB2.0 DVB-T receiver (TwinhanDTV Alpha/MagicBox II)' in warm state.
usb 3-1: new low speed USB device using uhci_hcd and address 2
dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
DVB: registering new adapter (Twinhan USB2.0 DVB-T receiver (TwinhanDTV Alpha/MagicBox II))
dvb-usb: MAC address: 08:ca:00:00:00:ff
DVB: registering adapter 0 frontend 0 (Twinhan VP7045/46 USB DVB-T)...
usb 3-1: New USB device found, idVendor=04d9, idProduct=1400
usb 3-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
input: HID 04d9:1400 as /devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1:1.0/input/input3
generic-usb 0003:04D9:1400.0001: input: USB HID v1.10 Keyboard [HID 04d9:1400] on usb-0000:00:1d.1-1/input0
input: HID 04d9:1400 as /devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1:1.1/input/input4
generic-usb 0003:04D9:1400.0002: input: USB HID v1.10 Mouse [HID 04d9:1400] on usb-0000:00:1d.1-1/input1
dvb-usb: Twinhan USB2.0 DVB-T receiver (TwinhanDTV Alpha/MagicBox II) successfully initialized and connected.
usbcore: registered new interface driver dvb_usb_vp7045
usb 5-1: new full speed USB device using uhci_hcd and address 2
EXT3-fs (sda4): using internal journal
usb 5-1: New USB device found, idVendor=05ac, idProduct=1000
usb 5-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
input: HID 05ac:1000 as /devices/pci0000:00/0000:00:1d.3/usb5/5-1/5-1:1.0/input/input5
generic-usb 0003:05AC:1000.0003: input: USB HID v1.11 Keyboard [HID 05ac:1000] on usb-0000:00:1d.3-1/input0
input: HID 05ac:1000 as /devices/pci0000:00/0000:00:1d.3/usb5/5-1/5-1:1.1/input/input6
generic-usb 0003:05AC:1000.0004: input: USB HID v1.11 Mouse [HID 05ac:1000] on usb-0000:00:1d.3-1/input1
loop: module loaded
Bluetooth: Core ver 2.15
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: Generic Bluetooth USB driver ver 0.6
usbcore: registered new interface driver btusb
usb 5-2: new full speed USB device using uhci_hcd and address 3
usb 5-2: New USB device found, idVendor=05ac, idProduct=8240
usb 5-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 5-2: Product: IR Receiver
usb 5-2: Manufacturer: Apple Computer, Inc.
generic-usb 0003:05AC:8240.0005: hiddev0: USB HID v1.11 Device [Apple Computer, Inc. IR Receiver] on usb-0000:00:1d.3-2/input0
usb 1-1.2: new low speed USB device using ehci_hcd and address 8
usb 1-1.2: New USB device found, idVendor=046d, idProduct=c03d
usb 1-1.2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 1-1.2: Product: USB-PS/2 Optical Mouse
usb 1-1.2: Manufacturer: Logitech
input: Logitech USB-PS/2 Optical Mouse as /devices/pci0000:00/0000:00:1d.7/usb1/1-1/1-1.2/1-1.2:1.0/input/input7
generic-usb 0003:046D:C03D.0006: input: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:1d.7-1.2/input0
usb 1-1.3: new full speed USB device using ehci_hcd and address 9
usb 1-1.3: New USB device found, idVendor=056d, idProduct=0002
usb 1-1.3: New USB device strings: Mfr=4, Product=14, SerialNumber=0
usb 1-1.3: Product: EIZO USB HID Monitor
usb 1-1.3: Manufacturer: EIZO
generic-usb 0003:056D:0002.0007: hiddev0: USB HID v1.10 Device [EIZO EIZO USB HID Monitor] on usb-0000:00:1d.7-1.3/input0
usb 5-1: usbfs: USBDEVFS_CONTROL failed cmd hid2hci rqt 64 rq 0 len 0 ret -84
usb 1-5.3: new high speed USB device using ehci_hcd and address 10
usb 1-5.3: New USB device found, idVendor=05e3, idProduct=0608
usb 1-5.3: New USB device strings: Mfr=0, Product=1, SerialNumber=0
usb 1-5.3: Product: USB2.0 Hub
hub 1-5.3:1.0: USB hub found
hub 1-5.3:1.0: 4 ports detected
usb 1-5.4: new high speed USB device using ehci_hcd and address 11
usb 1-5.4: New USB device found, idVendor=04fc, idProduct=0c15
usb 1-5.4: New USB device strings: Mfr=2, Product=3, SerialNumber=1
usb 1-5.4: Product: USB to Serial-ATA bridge
usb 1-5.4: Manufacturer: Sunplus Technology Inc.
usb 1-5.4: SerialNumber: WDC WD10EA     WD-WCAU41668315
usb 1-5.4: selecting invalid altsetting 1
scsi6 : usb-storage 1-5.4:1.0
usb 5-1: USB disconnect, address 2
usb 1-5.3.1: new high speed USB device using ehci_hcd and address 13
usb 1-5.3.1: New USB device found, idVendor=13fd, idProduct=0841
usb 1-5.3.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-5.3.1: Product: USB Mass Storage Device 
usb 1-5.3.1: Manufacturer: TSSTcorp
usb 1-5.3.1: SerialNumber: SATASLIM00000003737
scsi7 : usb-storage 1-5.3.1:1.0
usb 1-5.3.2: new high speed USB device using ehci_hcd and address 14
usb 1-5.3.2: New USB device found, idVendor=11b0, idProduct=6148
usb 1-5.3.2: New USB device strings: Mfr=3, Product=4, SerialNumber=5
usb 1-5.3.2: Product: FCR-HS219/1 Mobile Reader
usb 1-5.3.2: Manufacturer: Kingston
usb 1-5.3.2: SerialNumber: 092101011022
usb 1-5.3.2: selecting invalid altsetting 1
scsi8 : usb-storage 1-5.3.2:1.0
usb 1-5.3.4: new full speed USB device using ehci_hcd and address 15
usb 1-5.3.4: New USB device found, idVendor=03f0, idProduct=6004
usb 1-5.3.4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-5.3.4: Product: deskjet 5550
usb 1-5.3.4: Manufacturer: hp
usb 1-5.3.4: SerialNumber: MY3181K2NN2L
usblp0: USB Bidirectional printer dev 15 if 0 alt 0 proto 2 vid 0x03F0 pid 0x6004
usbcore: registered new interface driver usblp
scsi 6:0:0:0: Direct-Access     WDC WD10 EACS-00D6B0           PQ: 0 ANSI: 2
sd 6:0:0:0: Attached scsi generic sg2 type 0
sd 6:0:0:0: [sdb] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
sd 6:0:0:0: [sdb] Write Protect is off
sd 6:0:0:0: [sdb] Mode Sense: 38 00 00 00
sd 6:0:0:0: [sdb] Assuming drive cache: write through
sd 6:0:0:0: [sdb] Assuming drive cache: write through
 sdb: sdb1
sd 6:0:0:0: [sdb] Assuming drive cache: write through
sd 6:0:0:0: [sdb] Attached SCSI disk
usb 5-1: new full speed USB device using uhci_hcd and address 4
usb 5-1: New USB device found, idVendor=05ac, idProduct=8205
usb 5-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
scsi 7:0:0:0: CD-ROM            TSSTcorp CDDVDW SE-T084M  TD01 PQ: 0 ANSI: 0
sr1: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
sr 7:0:0:0: Attached scsi CD-ROM sr1
sr 7:0:0:0: Attached scsi generic sg3 type 5
scsi 8:0:0:0: Direct-Access     Kingston FCR-HS219/1      9722 PQ: 0 ANSI: 0
sd 8:0:0:0: Attached scsi generic sg4 type 0
scsi 8:0:0:1: Direct-Access     Kingston FCR-HS219/1      9722 PQ: 0 ANSI: 0
sd 8:0:0:1: Attached scsi generic sg5 type 0
sd 8:0:0:0: [sdc] Attached SCSI removable disk
scsi 8:0:0:2: Direct-Access     Kingston FCR-HS219/1      9722 PQ: 0 ANSI: 0
sd 8:0:0:1: [sdd] Attached SCSI removable disk
sd 8:0:0:2: Attached scsi generic sg6 type 0
scsi 8:0:0:3: Direct-Access     Kingston FCR-HS219/1      9722 PQ: 0 ANSI: 0
sd 8:0:0:3: Attached scsi generic sg7 type 0
sd 8:0:0:2: [sde] Attached SCSI removable disk
sd 8:0:0:3: [sdf] Attached SCSI removable disk
Adding 524284k swap on /dev/mapper/mac-swap.  Priority:-1 extents:1 across:524284k 
EXT4-fs (dm-8): mounted filesystem with ordered data mode. Opts: (null)
EXT4-fs (dm-4): mounted filesystem with ordered data mode. Opts: (null)
EXT4-fs (dm-5): mounted filesystem with ordered data mode. Opts: (null)
EXT4-fs (dm-7): mounted filesystem with ordered data mode. Opts: (null)
XFS mounting filesystem dm-1
Ending clean XFS mount for filesystem: dm-1
XFS mounting filesystem dm-2
Ending clean XFS mount for filesystem: dm-2
XFS mounting filesystem dm-3
Ending clean XFS mount for filesystem: dm-3
NET: Registered protocol family 10
sshd (1909): /proc/1909/oom_adj is deprecated, please use /proc/1909/oom_score_adj instead.
sky2 0000:01:00.0: eth0: enabling interface
ADDRCONF(NETDEV_UP): eth0: link is not ready
sky2 0000:01:00.0: eth0: Link is up at 1000 Mbps, full duplex, flow control both
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
svc: failed to register lockdv1 RPC service (errno 97).
NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
NFSD: starting 90-second grace period
eth0: no IPv6 routers present

--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="Xorg.0.log"


X.Org X Server 1.7.7
Release Date: 2010-05-04
X Protocol Version 11, Revision 0
Build Operating System: Linux 2.6.32-5-amd64 x86_64 Debian
Current Operating System: Linux mac 2.6.37-rc2-00001-g9984b1f #5 SMP Tue Nov 16 09:27:33 CET 2010 x86_64
Kernel command line: BOOT_IMAGE=/boot/vmlinuz-2.6.37-rc2-00001-g9984b1f root=/dev/sda4 ro i915.modeset=1 gpt
Build Date: 11 November 2010  11:44:20PM
xorg-server 2:1.7.7-9 (Julien Cristau <jcristau@debian.org>) 
Current version of pixman: 0.18.2
	Before reporting problems, check http://wiki.x.org
	to make sure that you have the latest version.
Markers: (--) probed, (**) from config file, (==) default setting,
	(++) from command line, (!!) notice, (II) informational,
	(WW) warning, (EE) error, (NI) not implemented, (??) unknown.
(==) Log file: "/var/log/Xorg.0.log", Time: Tue Nov 16 09:39:23 2010
(==) Using config file: "/etc/X11/xorg.conf"
(==) Using system config directory "/usr/share/X11/xorg.conf.d"
(==) No Layout section.  Using the first Screen section.
(**) |-->Screen "Default Screen" (0)
(**) |   |-->Monitor "Configured Monitor"
(==) No device specified for screen "Default Screen".
	Using the first device section listed.
(**) |   |-->Device "Configured Video Device"
(==) Automatically adding devices
(==) Automatically enabling devices
(WW) The directory "/usr/share/fonts/X11/cyrillic" does not exist.
	Entry deleted from font path.
(WW) The directory "/usr/share/fonts/X11/75dpi/" does not exist.
	Entry deleted from font path.
(WW) The directory "/usr/share/fonts/X11/75dpi" does not exist.
	Entry deleted from font path.
(==) FontPath set to:
	/usr/share/fonts/X11/misc,
	/usr/share/fonts/X11/100dpi/:unscaled,
	/usr/share/fonts/X11/Type1,
	/usr/share/fonts/X11/100dpi,
	/var/lib/defoma/x-ttcidfont-conf.d/dirs/TrueType,
	built-ins
(==) ModulePath set to "/usr/lib/xorg/modules"
(II) The server relies on udev to provide the list of input devices.
	If no devices become available, reconfigure udev or disable AutoAddDevices.
(II) Loader magic: 0x7c8a40
(II) Module ABI versions:
	X.Org ANSI C Emulation: 0.4
	X.Org Video Driver: 6.0
	X.Org XInput driver : 7.0
	X.Org Server Extension : 2.0
(++) using VT number 7

(--) PCI:*(0:0:2:0) 8086:27a2:8086:7270 Intel Corporation Mobile 945GM/GMS, 943/940GML Express Integrated Graphics Controller rev 3, Mem @ 0xd0380000/524288, 0xc0000000/268435456, 0xd0400000/262144, I/O @ 0x000020f0/8
(--) PCI: (0:0:2:1) 8086:27a6:8086:7270 Intel Corporation Mobile 945GM/GMS/GME, 943/940GML Express Integrated Graphics Controller rev 3, Mem @ 0xd0300000/524288
(II) Open ACPI successful (/var/run/acpid.socket)
(II) LoadModule: "extmod"
(II) Loading /usr/lib/xorg/modules/extensions/libextmod.so
(II) Module extmod: vendor="X.Org Foundation"
	compiled for 1.7.7, module version = 1.0.0
	Module class: X.Org Server Extension
	ABI class: X.Org Server Extension, version 2.0
(II) Loading extension SELinux
(II) Loading extension MIT-SCREEN-SAVER
(II) Loading extension XFree86-VidModeExtension
(II) Loading extension XFree86-DGA
(II) Loading extension DPMS
(II) Loading extension XVideo
(II) Loading extension XVideo-MotionCompensation
(II) Loading extension X-Resource
(II) LoadModule: "dbe"
(II) Loading /usr/lib/xorg/modules/extensions/libdbe.so
(II) Module dbe: vendor="X.Org Foundation"
	compiled for 1.7.7, module version = 1.0.0
	Module class: X.Org Server Extension
	ABI class: X.Org Server Extension, version 2.0
(II) Loading extension DOUBLE-BUFFER
(II) LoadModule: "glx"
(II) Loading /usr/lib/xorg/modules/extensions/libglx.so
(II) Module glx: vendor="X.Org Foundation"
	compiled for 1.7.7, module version = 1.0.0
	ABI class: X.Org Server Extension, version 2.0
(==) AIGLX enabled
(II) Loading extension GLX
(II) LoadModule: "record"
(II) Loading /usr/lib/xorg/modules/extensions/librecord.so
(II) Module record: vendor="X.Org Foundation"
	compiled for 1.7.7, module version = 1.13.0
	Module class: X.Org Server Extension
	ABI class: X.Org Server Extension, version 2.0
(II) Loading extension RECORD
(II) LoadModule: "dri"
(II) Loading /usr/lib/xorg/modules/extensions/libdri.so
(II) Module dri: vendor="X.Org Foundation"
	compiled for 1.7.7, module version = 1.0.0
	ABI class: X.Org Server Extension, version 2.0
(II) Loading extension XFree86-DRI
(II) LoadModule: "dri2"
(II) Loading /usr/lib/xorg/modules/extensions/libdri2.so
(II) Module dri2: vendor="X.Org Foundation"
	compiled for 1.7.7, module version = 1.1.0
	ABI class: X.Org Server Extension, version 2.0
(II) Loading extension DRI2
(==) Matched intel as autoconfigured driver 0
(==) Matched vesa as autoconfigured driver 1
(==) Matched fbdev as autoconfigured driver 2
(==) Assigned the driver to the xf86ConfigLayout
(II) LoadModule: "intel"
(II) Loading /usr/lib/xorg/modules/drivers/intel_drv.so
(II) Module intel: vendor="X.Org Foundation"
	compiled for 1.7.7, module version = 2.13.0
	Module class: X.Org Video Driver
	ABI class: X.Org Video Driver, version 6.0
(II) LoadModule: "vesa"
(WW) Warning, couldn't open module vesa
(II) UnloadModule: "vesa"
(EE) Failed to load module "vesa" (module does not exist, 0)
(II) LoadModule: "fbdev"
(WW) Warning, couldn't open module fbdev
(II) UnloadModule: "fbdev"
(EE) Failed to load module "fbdev" (module does not exist, 0)
(II) intel: Driver for Intel Integrated Graphics Chipsets: i810,
	i810-dc100, i810e, i815, i830M, 845G, 854, 852GM/855GM, 865G, 915G,
	E7221 (i915), 915GM, 945G, 945GM, 945GME, Pineview GM, Pineview G,
	965G, G35, 965Q, 946GZ, 965GM, 965GME/GLE, G33, Q35, Q33, GM45,
	4 Series, G45/G43, Q45/Q43, G41, B43, B43, Clarkdale, Arrandale,
	Sandybridge, Sandybridge, Sandybridge, Sandybridge, Sandybridge,
	Sandybridge, Sandybridge
(II) Primary Device is: PCI 00@00:02:0
drmOpenDevice: node name is /dev/dri/card0
drmOpenDevice: open result is 11, (OK)
drmOpenByBusid: Searching for BusID pci:0000:00:02.0
drmOpenDevice: node name is /dev/dri/card0
drmOpenDevice: open result is 11, (OK)
drmOpenByBusid: drmOpenMinor returns 11
drmOpenByBusid: drmGetBusid reports pci:0000:00:02.0
(II) intel(0): Creating default Display subsection in Screen section
	"Default Screen" for depth/fbbpp 24/32
(==) intel(0): Depth 24, (--) framebuffer bpp 32
(==) intel(0): RGB weight 888
(==) intel(0): Default visual is TrueColor
(II) intel(0): Integrated Graphics Chipset: Intel(R) 945GM
(--) intel(0): Chipset: "945GM"
(**) intel(0): Tiling enabled
(**) intel(0): SwapBuffers wait enabled
(==) intel(0): video overlay key set to 0x101fe
(II) intel(0): Output VGA1 using monitor section Configured Monitor
(II) intel(0): Output DVI1 using monitor section Configured Monitor
(II) intel(0): Output TV1 has no monitor section
(II) intel(0): EDID for output VGA1
(II) intel(0): EDID for output DVI1
(II) intel(0): Not using default mode "640x350" (vrefresh out of range)
(II) intel(0): Not using default mode "320x175" (doublescan mode not supported)
(II) intel(0): Not using default mode "640x400" (vrefresh out of range)
(II) intel(0): Not using default mode "320x200" (doublescan mode not supported)
(II) intel(0): Not using default mode "720x400" (vrefresh out of range)
(II) intel(0): Not using default mode "360x200" (doublescan mode not supported)
(II) intel(0): Not using default mode "320x240" (doublescan mode not supported)
(II) intel(0): Not using default mode "640x480" (vrefresh out of range)
(II) intel(0): Not using default mode "320x240" (doublescan mode not supported)
(II) intel(0): Not using default mode "640x480" (vrefresh out of range)
(II) intel(0): Not using default mode "320x240" (doublescan mode not supported)
(II) intel(0): Not using default mode "640x480" (vrefresh out of range)
(II) intel(0): Not using default mode "320x240" (doublescan mode not supported)
(II) intel(0): Not using default mode "800x600" (vrefresh out of range)
(II) intel(0): Not using default mode "400x300" (doublescan mode not supported)
(II) intel(0): Not using default mode "400x300" (doublescan mode not supported)
(II) intel(0): Not using default mode "800x600" (vrefresh out of range)
(II) intel(0): Not using default mode "400x300" (doublescan mode not supported)
(II) intel(0): Not using default mode "800x600" (vrefresh out of range)
(II) intel(0): Not using default mode "400x300" (doublescan mode not supported)
(II) intel(0): Not using default mode "800x600" (vrefresh out of range)
(II) intel(0): Not using default mode "400x300" (doublescan mode not supported)
(II) intel(0): Not using default mode "1024x768" (vrefresh out of range)
(II) intel(0): Not using default mode "512x384" (doublescan mode not supported)
(II) intel(0): Not using default mode "512x384" (doublescan mode not supported)
(II) intel(0): Not using default mode "1024x768" (vrefresh out of range)
(II) intel(0): Not using default mode "512x384" (doublescan mode not supported)
(II) intel(0): Not using default mode "1024x768" (vrefresh out of range)
(II) intel(0): Not using default mode "512x384" (doublescan mode not supported)
(II) intel(0): Not using default mode "1024x768" (vrefresh out of range)
(II) intel(0): Not using default mode "512x384" (doublescan mode not supported)
(II) intel(0): Not using default mode "1152x864" (vrefresh out of range)
(II) intel(0): Not using default mode "576x432" (doublescan mode not supported)
(II) intel(0): Not using default mode "1280x960" (hsync out of range)
(II) intel(0): Not using default mode "640x480" (doublescan mode not supported)
(II) intel(0): Not using default mode "1280x960" (vrefresh out of range)
(II) intel(0): Not using default mode "640x480" (doublescan mode not supported)
(II) intel(0): Not using default mode "1280x1024" (hsync out of range)
(II) intel(0): Not using default mode "640x512" (doublescan mode not supported)
(II) intel(0): Not using default mode "1280x1024" (vrefresh out of range)
(II) intel(0): Not using default mode "640x512" (doublescan mode not supported)
(II) intel(0): Not using default mode "1280x1024" (vrefresh out of range)
(II) intel(0): Not using default mode "640x512" (doublescan mode not supported)
(II) intel(0): Not using default mode "1600x1200" (hsync out of range)
(II) intel(0): Not using default mode "800x600" (doublescan mode not supported)
(II) intel(0): Not using default mode "1600x1200" (vrefresh out of range)
(II) intel(0): Not using default mode "800x600" (doublescan mode not supported)
(II) intel(0): Not using default mode "1600x1200" (vrefresh out of range)
(II) intel(0): Not using default mode "800x600" (doublescan mode not supported)
(II) intel(0): Not using default mode "1600x1200" (vrefresh out of range)
(II) intel(0): Not using default mode "800x600" (doublescan mode not supported)
(II) intel(0): Not using default mode "1600x1200" (vrefresh out of range)
(II) intel(0): Not using default mode "800x600" (doublescan mode not supported)
(II) intel(0): Not using default mode "1792x1344" (hsync out of range)
(II) intel(0): Not using default mode "896x672" (doublescan mode not supported)
(II) intel(0): Not using default mode "1792x1344" (vrefresh out of range)
(II) intel(0): Not using default mode "896x672" (doublescan mode not supported)
(II) intel(0): Not using default mode "1856x1392" (hsync out of range)
(II) intel(0): Not using default mode "928x696" (doublescan mode not supported)
(II) intel(0): Not using default mode "1856x1392" (vrefresh out of range)
(II) intel(0): Not using default mode "928x696" (doublescan mode not supported)
(II) intel(0): Not using default mode "1920x1440" (hsync out of range)
(II) intel(0): Not using default mode "960x720" (doublescan mode not supported)
(II) intel(0): Not using default mode "1920x1440" (vrefresh out of range)
(II) intel(0): Not using default mode "960x720" (doublescan mode not supported)
(II) intel(0): Not using default mode "832x624" (vrefresh out of range)
(II) intel(0): Not using default mode "416x312" (doublescan mode not supported)
(II) intel(0): Not using default mode "576x432" (doublescan mode not supported)
(II) intel(0): Not using default mode "1152x864" (vrefresh out of range)
(II) intel(0): Not using default mode "576x432" (doublescan mode not supported)
(II) intel(0): Not using default mode "1152x864" (vrefresh out of range)
(II) intel(0): Not using default mode "576x432" (doublescan mode not supported)
(II) intel(0): Not using default mode "1152x864" (vrefresh out of range)
(II) intel(0): Not using default mode "576x432" (doublescan mode not supported)
(II) intel(0): Not using default mode "1152x864" (vrefresh out of range)
(II) intel(0): Not using default mode "576x432" (doublescan mode not supported)
(II) intel(0): Not using default mode "1152x864" (vrefresh out of range)
(II) intel(0): Not using default mode "576x432" (doublescan mode not supported)
(II) intel(0): Not using default mode "1360x768" (monitor doesn't support reduced blanking)
(II) intel(0): Not using default mode "680x384" (doublescan mode not supported)
(II) intel(0): Not using default mode "680x384" (doublescan mode not supported)
(II) intel(0): Not using default mode "1400x1050" (hsync out of range)
(II) intel(0): Not using default mode "700x525" (doublescan mode not supported)
(II) intel(0): Not using default mode "1400x1050" (vrefresh out of range)
(II) intel(0): Not using default mode "700x525" (doublescan mode not supported)
(II) intel(0): Not using default mode "1400x1050" (vrefresh out of range)
(II) intel(0): Not using default mode "700x525" (doublescan mode not supported)
(II) intel(0): Not using default mode "1400x1050" (vrefresh out of range)
(II) intel(0): Not using default mode "700x525" (doublescan mode not supported)
(II) intel(0): Not using default mode "1440x900" (hsync out of range)
(II) intel(0): Not using default mode "720x450" (doublescan mode not supported)
(II) intel(0): Not using default mode "1600x1024" (hsync out of range)
(II) intel(0): Not using default mode "800x512" (doublescan mode not supported)
(II) intel(0): Not using default mode "1680x1050" (hsync out of range)
(II) intel(0): Not using default mode "840x525" (doublescan mode not supported)
(II) intel(0): Not using default mode "1680x1050" (hsync out of range)
(II) intel(0): Not using default mode "840x525" (doublescan mode not supported)
(II) intel(0): Not using default mode "1680x1050" (vrefresh out of range)
(II) intel(0): Not using default mode "840x525" (doublescan mode not supported)
(II) intel(0): Not using default mode "1680x1050" (vrefresh out of range)
(II) intel(0): Not using default mode "840x525" (doublescan mode not supported)
(II) intel(0): Not using default mode "1680x1050" (vrefresh out of range)
(II) intel(0): Not using default mode "840x525" (doublescan mode not supported)
(II) intel(0): Not using default mode "1920x1080" (hsync out of range)
(II) intel(0): Not using default mode "960x540" (doublescan mode not supported)
(II) intel(0): Not using default mode "1920x1200" (hsync out of range)
(II) intel(0): Not using default mode "960x600" (doublescan mode not supported)
(II) intel(0): Not using default mode "1920x1440" (vrefresh out of range)
(II) intel(0): Not using default mode "960x720" (doublescan mode not supported)
(II) intel(0): Not using default mode "2048x1536" (hsync out of range)
(II) intel(0): Not using default mode "1024x768" (doublescan mode not supported)
(II) intel(0): Not using default mode "2048x1536" (vrefresh out of range)
(II) intel(0): Not using default mode "1024x768" (doublescan mode not supported)
(II) intel(0): Not using default mode "2048x1536" (vrefresh out of range)
(II) intel(0): Not using default mode "1024x768" (doublescan mode not supported)
(II) intel(0): Printing probed modes for output DVI1
(II) intel(0): Modeline "1360x768"x59.8   84.75  1360 1432 1568 1776  768 771 781 798 -hsync +vsync (47.7 kHz)
(II) intel(0): Modeline "1152x864"x60.0   81.62  1152 1216 1336 1520  864 865 868 895 -hsync +vsync (53.7 kHz)
(II) intel(0): Modeline "1024x768"x60.0   65.00  1024 1048 1184 1344  768 771 777 806 -hsync -vsync (48.4 kHz)
(II) intel(0): Modeline "800x600"x60.3   40.00  800 840 968 1056  600 601 605 628 +hsync +vsync (37.9 kHz)
(II) intel(0): Modeline "640x480"x59.9   25.18  640 656 752 800  480 490 492 525 -hsync -vsync (31.5 kHz)
(II) intel(0): EDID for output TV1
(II) intel(0): Output VGA1 disconnected
(II) intel(0): Output DVI1 disconnected
(II) intel(0): Output TV1 disconnected
(WW) intel(0): No outputs definitely connected, trying again...
(II) intel(0): Output VGA1 disconnected
(II) intel(0): Output DVI1 connected
(II) intel(0): Output TV1 disconnected
(II) intel(0): Using fuzzy aspect match for initial modes
(II) intel(0): Output DVI1 using initial mode 1152x864
(II) intel(0): Using default gamma of (1.0, 1.0, 1.0) unless otherwise stated.
(II) intel(0): Kernel page flipping support detected, enabling
(==) intel(0): DPI set to (96, 96)
(II) Loading sub module "fb"
(II) LoadModule: "fb"
(II) Loading /usr/lib/xorg/modules/libfb.so
(II) Module fb: vendor="X.Org Foundation"
	compiled for 1.7.7, module version = 1.0.0
	ABI class: X.Org ANSI C Emulation, version 0.4
(==) Depth 24 pixmap format is 32 bpp
(==) intel(0): VideoRam: 262144 KB
(II) intel(0): [DRI2] Setup complete
(II) intel(0): Allocated new frame buffer 1152x864 stride 8192, tiled
(II) UXA(0): Driver registered support for the following operations:
(II)         solid
(II)         copy
(II)         composite (RENDER acceleration)
(II)         put_image
(II)         get_image
(==) intel(0): Backing store disabled
(==) intel(0): Silken mouse enabled
(II) intel(0): Initializing HW Cursor
(II) intel(0): RandR 1.2 enabled, ignore the following RandR disabled message.
(==) intel(0): DPMS enabled
(==) intel(0): Intel XvMC decoder disabled
(II) intel(0): Set up textured video
(II) intel(0): Set up overlay video
(II) intel(0): direct rendering: DRI2 Enabled
(--) RandR disabled
(II) Initializing built-in extension Generic Event Extension
(II) Initializing built-in extension SHAPE
(II) Initializing built-in extension MIT-SHM
(II) Initializing built-in extension XInputExtension
(II) Initializing built-in extension XTEST
(II) Initializing built-in extension BIG-REQUESTS
(II) Initializing built-in extension SYNC
(II) Initializing built-in extension XKEYBOARD
(II) Initializing built-in extension XC-MISC
(II) Initializing built-in extension SECURITY
(II) Initializing built-in extension XINERAMA
(II) Initializing built-in extension XFIXES
(II) Initializing built-in extension RENDER
(II) Initializing built-in extension RANDR
(II) Initializing built-in extension COMPOSITE
(II) Initializing built-in extension DAMAGE
SELinux: Disabled on system, not enabling in X server
(II) AIGLX: enabled GLX_MESA_copy_sub_buffer
(II) AIGLX: enabled GLX_SGI_make_current_read
(II) AIGLX: enabled GLX_SGI_swap_control and GLX_MESA_swap_control
(II) AIGLX: GLX_EXT_texture_from_pixmap backed by buffer objects
(II) AIGLX: Loaded and initialized /usr/lib/dri/i915_dri.so
(II) GLX: Initialized DRI2 GL provider for screen 0
(II) intel(0): Setting screen physical size to 304 x 228
[dix] Could not init font path element /usr/share/fonts/X11/100dpi/:unscaled, removing from list!
[dix] Could not init font path element /usr/share/fonts/X11/100dpi, removing from list!
(II) config/udev: Adding input device Power Button (/dev/input/event1)
(**) Power Button: Applying InputClass "evdev keyboard catchall"
(II) LoadModule: "evdev"
(II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
(II) Module evdev: vendor="X.Org Foundation"
	compiled for 1.7.6.901, module version = 2.3.2
	Module class: X.Org XInput Driver
	ABI class: X.Org XInput driver, version 7.0
(**) Power Button: always reports core events
(**) Power Button: Device: "/dev/input/event1"
(II) Power Button: Found keys
(II) Power Button: Configuring as keyboard
(II) XINPUT: Adding extended input device "Power Button" (type: KEYBOARD)
(**) Option "xkb_rules" "evdev"
(**) Option "xkb_model" "pc105"
(**) Option "xkb_layout" "de"
(**) Option "xkb_variant" "nodeadkeys"
(**) Option "xkb_options" "lv3:ralt_switch"
(II) config/udev: Adding input device Video Bus (/dev/input/event2)
(**) Video Bus: Applying InputClass "evdev keyboard catchall"
(**) Video Bus: always reports core events
(**) Video Bus: Device: "/dev/input/event2"
(II) Video Bus: Found keys
(II) Video Bus: Configuring as keyboard
(II) XINPUT: Adding extended input device "Video Bus" (type: KEYBOARD)
(**) Option "xkb_rules" "evdev"
(**) Option "xkb_model" "pc105"
(**) Option "xkb_layout" "de"
(**) Option "xkb_variant" "nodeadkeys"
(**) Option "xkb_options" "lv3:ralt_switch"
(II) config/udev: Adding input device Power Button (/dev/input/event0)
(**) Power Button: Applying InputClass "evdev keyboard catchall"
(**) Power Button: always reports core events
(**) Power Button: Device: "/dev/input/event0"
(II) Power Button: Found keys
(II) Power Button: Configuring as keyboard
(II) XINPUT: Adding extended input device "Power Button" (type: KEYBOARD)
(**) Option "xkb_rules" "evdev"
(**) Option "xkb_model" "pc105"
(**) Option "xkb_layout" "de"
(**) Option "xkb_variant" "nodeadkeys"
(**) Option "xkb_options" "lv3:ralt_switch"
(II) config/udev: Adding input device HID 04d9:1400 (/dev/input/event3)
(**) HID 04d9:1400: Applying InputClass "evdev keyboard catchall"
(**) HID 04d9:1400: always reports core events
(**) HID 04d9:1400: Device: "/dev/input/event3"
(II) HID 04d9:1400: Found keys
(II) HID 04d9:1400: Configuring as keyboard
(II) XINPUT: Adding extended input device "HID 04d9:1400" (type: KEYBOARD)
(**) Option "xkb_rules" "evdev"
(**) Option "xkb_model" "pc105"
(**) Option "xkb_layout" "de"
(**) Option "xkb_variant" "nodeadkeys"
(**) Option "xkb_options" "lv3:ralt_switch"
(II) config/udev: Adding input device HID 04d9:1400 (/dev/input/event4)
(**) HID 04d9:1400: Applying InputClass "evdev pointer catchall"
(**) HID 04d9:1400: Applying InputClass "evdev keyboard catchall"
(**) HID 04d9:1400: always reports core events
(**) HID 04d9:1400: Device: "/dev/input/event4"
(II) HID 04d9:1400: Found 9 mouse buttons
(II) HID 04d9:1400: Found scroll wheel(s)
(II) HID 04d9:1400: Found relative axes
(II) HID 04d9:1400: Found x and y relative axes
(II) HID 04d9:1400: Found keys
(II) HID 04d9:1400: Configuring as mouse
(II) HID 04d9:1400: Configuring as keyboard
(**) HID 04d9:1400: YAxisMapping: buttons 4 and 5
(**) HID 04d9:1400: EmulateWheelButton: 4, EmulateWheelInertia: 10, EmulateWheelTimeout: 200
(II) XINPUT: Adding extended input device "HID 04d9:1400" (type: KEYBOARD)
(**) Option "xkb_rules" "evdev"
(**) Option "xkb_model" "pc105"
(**) Option "xkb_layout" "de"
(**) Option "xkb_variant" "nodeadkeys"
(**) Option "xkb_options" "lv3:ralt_switch"
(II) HID 04d9:1400: initialized for relative axes.
(II) config/udev: Adding input device HID 04d9:1400 (/dev/input/mouse0)
(II) No input driver/identifier specified (ignoring)
(II) config/udev: Adding input device Logitech USB-PS/2 Optical Mouse (/dev/input/event7)
(**) Logitech USB-PS/2 Optical Mouse: Applying InputClass "evdev pointer catchall"
(**) Logitech USB-PS/2 Optical Mouse: always reports core events
(**) Logitech USB-PS/2 Optical Mouse: Device: "/dev/input/event7"
(II) Logitech USB-PS/2 Optical Mouse: Found 3 mouse buttons
(II) Logitech USB-PS/2 Optical Mouse: Found scroll wheel(s)
(II) Logitech USB-PS/2 Optical Mouse: Found relative axes
(II) Logitech USB-PS/2 Optical Mouse: Found x and y relative axes
(II) Logitech USB-PS/2 Optical Mouse: Configuring as mouse
(**) Logitech USB-PS/2 Optical Mouse: YAxisMapping: buttons 4 and 5
(**) Logitech USB-PS/2 Optical Mouse: EmulateWheelButton: 4, EmulateWheelInertia: 10, EmulateWheelTimeout: 200
(II) XINPUT: Adding extended input device "Logitech USB-PS/2 Optical Mouse" (type: MOUSE)
(II) Logitech USB-PS/2 Optical Mouse: initialized for relative axes.
(II) config/udev: Adding input device Logitech USB-PS/2 Optical Mouse (/dev/input/mouse2)
(II) No input driver/identifier specified (ignoring)
(II) AIGLX: Suspending AIGLX clients for VT switch
(II) Open ACPI successful (/var/run/acpid.socket)
(II) AIGLX: Resuming AIGLX clients after VT switch
(II) Power Button: Device reopened after 1 attempts.
(II) Video Bus: Device reopened after 1 attempts.
(II) Power Button: Device reopened after 1 attempts.
(II) HID 04d9:1400: Device reopened after 1 attempts.
(II) HID 04d9:1400: Device reopened after 1 attempts.
(II) Logitech USB-PS/2 Optical Mouse: Device reopened after 1 attempts.

--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=xrandr

Screen 0: minimum 320 x 200, current 1152 x 864, maximum 4096 x 4096
VGA1 disconnected (normal left inverted right x axis y axis)
DVI1 unknown connection 1152x864+0+0 (normal left inverted right x axis y axis) 0mm x 0mm
   1360x768       59.8  
   1152x864       60.0* 
   1024x768       60.0  
   800x600        60.3  
   640x480        59.9  
TV1 disconnected (normal left inverted right x axis y axis)

--NzB8fVQJ5HfG6fxh--

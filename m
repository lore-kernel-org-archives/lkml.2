Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143Ab0KUTG5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 14:06:57 -0500
Received: from mx0.vr-web.de ([195.200.35.198]:37864 "EHLO mx0.vr-web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751578Ab0KUTG4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 14:06:56 -0500
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Sun, 21 Nov 2010 14:06:55 EST
From: Andreas Hartmann <andihartmann@01019freenet.de>
X-Newsgroups: linux.kernel
Subject: missing 700 MB of RAM
Date: Sun, 21 Nov 2010 20:02:53 +0100
Organization: privat
Message-ID: <icbqak$32o$1@ID-44327.news.uni-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.15) Gecko/20101026 SUSE/2.0.10-1.1 SeaMonkey/2.0.10
To: linux-kernel@vger.kernel.org
X-BitDefender-Scanner: Clean, Agent: BitDefender Courier 3.0.2 on
 vrwf203, sigver: 7.28621
X-BitDefender-CF-Stamp: none
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I've got 8 GB RAM installed, but linux reports 7,3 GB. Where is the
missing RAM (700 MB)?

free
             total       used       free     shared    buffers     cached
Mem:       7706580    5271096    2435484          0      79232    3049120
-/+ buffers/cache:    2142744    5563836
Swap:      8393956          0    8393956

The motherboard is a GA-MA78GM-S2H (64bit, AMD) with a on board Radeon
HD 3200 VGA card. The card uses 256 MB of RAM - so 444 MB of RAM are
missing. Where are they gone?


kernel: 2.6.34.7-33-desktop (OpenSuSE 11.3)

dmesg
Linux version 2.6.34.7-33-desktop (geeko@buildhost) (gcc version 4.4.1
[gcc-4_4-branch revision 150839] (SUSE Linux) ) #1 SMP PREEMPT
2010-11-09 20:08:44 +0100
Command line:
root=/dev/disk/by-id/scsi-SATA_WDC_WD5000AACS-_WD-WCAUF1158341-part1
splash=silent quiet nmi_watchdog=0 iommu=noagp,memaper=0 agp=off vga=0x376
BIOS-provided physical RAM map:
BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
BIOS-e820: 0000000000100000 - 00000000afde0000 (usable)
BIOS-e820: 00000000afde0000 - 00000000afde3000 (ACPI NVS)
BIOS-e820: 00000000afde3000 - 00000000afdf0000 (ACPI data)
BIOS-e820: 00000000afdf0000 - 00000000afe00000 (reserved)
BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
BIOS-e820: 0000000100000000 - 0000000230000000 (usable)
NX (Execute Disable) protection: active
DMI 2.4 present.
e820 update range: 0000000000000000 - 0000000000001000 (usable) ==>
(reserved)
e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
No AGP bridge found
last_pfn = 0x230000 max_arch_pfn = 0x400000000
MTRR default type: uncachable
MTRR fixed ranges enabled:
00000-9FFFF write-back
A0000-BFFFF uncachable
C0000-C7FFF write-protect
C8000-FFFFF uncachable
MTRR variable ranges enabled:
0 base 0000000000 mask FF80000000 write-back
1 base 0080000000 mask FFE0000000 write-back
2 base 00A0000000 mask FFF0000000 write-back
3 base 00AFE00000 mask FFFFE00000 uncachable
4 base 0100000000 mask FF00000000 write-back
5 base 0200000000 mask FFE0000000 write-back
6 base 0220000000 mask FFF0000000 write-back
7 disabled
TOM2: 0000000230000000 aka 8960M
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
e820 update range: 00000000afe00000 - 0000000100000000 (usable) ==>
(reserved)
last_pfn = 0xafde0 max_arch_pfn = 0x400000000
e820 update range: 0000000000001000 - 0000000000010000 (usable) ==>
(reserved)
Scanning 1 areas for low memory corruption
modified physical RAM map:
modified: 0000000000000000 - 0000000000010000 (reserved)
modified: 0000000000010000 - 000000000009f800 (usable)
modified: 000000000009f800 - 00000000000a0000 (reserved)
modified: 00000000000f0000 - 0000000000100000 (reserved)
modified: 0000000000100000 - 00000000afde0000 (usable)
modified: 00000000afde0000 - 00000000afde3000 (ACPI NVS)
modified: 00000000afde3000 - 00000000afdf0000 (ACPI data)
modified: 00000000afdf0000 - 00000000afe00000 (reserved)
modified: 00000000e0000000 - 00000000f0000000 (reserved)
modified: 00000000fec00000 - 0000000100000000 (reserved)
modified: 0000000100000000 - 0000000230000000 (usable)
initial memory mapped : 0 - 20000000
found SMP MP-table at [ffff8800000f5570] f5570
init_memory_mapping: 0000000000000000-00000000afde0000
0000000000 - 00afc00000 page 2M
00afc00000 - 00afde0000 page 4k
kernel direct mapping tables up to afde0000 @ 16000-1b000
init_memory_mapping: 0000000100000000-0000000230000000
0100000000 - 0230000000 page 2M
kernel direct mapping tables up to 230000000 @ 19000-23000
RAMDISK: 37968000 - 37ff0000
ACPI: RSDP 00000000000f6ef0 00014 (v00 GBT   )
ACPI: RSDT 00000000afde3000 00038 (v01 GBT    GBTUACPI 42302E31 GBTU
01010101)
ACPI: FACP 00000000afde3040 00074 (v01 GBT    GBTUACPI 42302E31 GBTU
01010101)
ACPI: DSDT 00000000afde30c0 069CD (v01 GBT    GBTUACPI 00001000 MSFT
03000000)
ACPI: FACS 00000000afde0000 00040
ACPI: SSDT 00000000afde9b80 0028A (v01 PTLTD  POWERNOW 00000001  LTP
00000001)
ACPI: HPET 00000000afde9e40 00038 (v01 GBT    GBTUACPI 42302E31 GBTU
00000098)
ACPI: MCFG 00000000afde9e80 0003C (v01 GBT    GBTUACPI 42302E31 GBTU
01010101)
ACPI: APIC 00000000afde9ac0 00084 (v01 GBT    GBTUACPI 42302E31 GBTU
01010101)
ACPI: Local APIC address 0xfee00000
Scanning NUMA topology in Northbridge 24
No NUMA configuration found
Faking a node at 0000000000000000-0000000230000000
Initmem setup node 0 0000000000000000-0000000230000000
NODE_DATA [0000000100000000 - 0000000100013fff]
[ffffea0000000000-ffffea0007bfffff] PMD ->
[ffff880100200000-ffff880106dfffff] on node 0
Zone PFN ranges:
DMA      0x00000010 -> 0x00001000
DMA32    0x00001000 -> 0x00100000
Normal   0x00100000 -> 0x00230000
Movable zone start PFN for each node
early_node_map[3] active PFN ranges
  0: 0x00000010 -> 0x0000009f
  0: 0x00000100 -> 0x000afde0
  0: 0x00100000 -> 0x00230000
On node 0 totalpages: 1965423
DMA zone: 56 pages used for memmap
DMA zone: 0 pages reserved
DMA zone: 3927 pages, LIFO batch:0
DMA32 zone: 14280 pages used for memmap
DMA32 zone: 701976 pages, LIFO batch:31
Normal zone: 17024 pages used for memmap
Normal zone: 1228160 pages, LIFO batch:31
Detected use of extended apic ids on hypertransport bus
ACPI: PM-Timer IO Port: 0x4008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 33, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x10b9a201 base: 0xfed00000
SMP: Allowing 4 CPUs, 2 hotplug CPUs
nr_irqs_gsi: 24
early_res array is doubled to 64 at [1e000 - 1e7ff]
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
PM: Registered nosave memory: 00000000afde0000 - 00000000afde3000
PM: Registered nosave memory: 00000000afde3000 - 00000000afdf0000
PM: Registered nosave memory: 00000000afdf0000 - 00000000afe00000
PM: Registered nosave memory: 00000000afe00000 - 00000000e0000000
PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
PM: Registered nosave memory: 00000000f0000000 - 00000000fec00000
PM: Registered nosave memory: 00000000fec00000 - 0000000100000000
Allocating PCI resources starting at afe00000 (gap: afe00000:30200000)
Booting paravirtualized kernel on bare hardware
setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:4 nr_node_ids:1
PERCPU: Embedded 28 pages/cpu @ffff880001e00000 s84136 r8192 d22360 u524288
pcpu-alloc: s84136 r8192 d22360 u524288 alloc=1*2097152
pcpu-alloc: [0] 0 1 2 3
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1934063
Policy zone: Normal
Kernel command line:
root=/dev/disk/by-id/scsi-SATA_WDC_WD5000AACS-_WD-WCAUF1158341-part1
splash=silent quiet nmi_watchdog=0 iommu=noagp,memaper=0 agp=off vga=0x376
bootsplash: silent mode.
PID hash table entries: 4096 (order: 3, 32768 bytes)
Checking aperture...
Node 0: aperture @ 3fe000000 size 32 MB
Aperture beyond 4GB. Ignoring.
Your BIOS doesn't leave a aperture memory hole
Please enable the IOMMU option in the BIOS setup
This costs you 32 MB of RAM
Mapping aperture over 32768 KB of RAM @ 20000000
PM: Registered nosave memory: 0000000020000000 - 0000000022000000
early_res array is doubled to 128 at [1e800 - 1f7ff]
Subtract (58 early reservations)
#1 [0001000000 - 0001d98ad8]   TEXT DATA BSS
#2 [0037968000 - 0037ff0000]         RAMDISK
#3 [0001d99000 - 0001d990fe]             BRK
#4 [00000f5580 - 0000100000]   BIOS reserved
#5 [00000f5570 - 00000f5580]    MP-table mpf
#6 [000009f800 - 00000f0f00]   BIOS reserved
#7 [00000f105c - 00000f5570]   BIOS reserved
#8 [00000f0f00 - 00000f105c]    MP-table mpc
#9 [0000010000 - 0000012000]      TRAMPOLINE
#10 [0000012000 - 0000016000]     ACPI WAKEUP
#11 [0000016000 - 0000019000]         PGTABLE
#12 [0000019000 - 000001e000]         PGTABLE
#13 [0100000000 - 0100014000]       NODE_DATA
#14 [0001d99100 - 0001d9a100]         BOOTMEM
#15 [0100014000 - 01000145a0]         BOOTMEM
#16 [0100015000 - 0100016000]         BOOTMEM
#17 [0100016000 - 0100017000]         BOOTMEM
#18 [0100200000 - 0106e00000]        MEMMAP 0
#19 [0001d9a100 - 0001db2100]         BOOTMEM
#20 [0001db2100 - 0001dca100]         BOOTMEM
#21 [0001dca100 - 0001de2100]         BOOTMEM
#22 [0001de3000 - 0001de4000]         BOOTMEM
#23 [0001d98b00 - 0001d98b41]         BOOTMEM
#24 [0001d98b80 - 0001d98bc3]         BOOTMEM
#25 [0001d98c00 - 0001d98e68]         BOOTMEM
#26 [0001d98e80 - 0001d98ee8]         BOOTMEM
#27 [0001d98f00 - 0001d98f68]         BOOTMEM
#28 [0001d98f80 - 0001d98fe8]         BOOTMEM
#29 [0001de2100 - 0001de2168]         BOOTMEM
#30 [0001de2180 - 0001de21e8]         BOOTMEM
#31 [0001de2200 - 0001de2268]         BOOTMEM
#32 [0001de2280 - 0001de22e8]         BOOTMEM
#33 [0001de2300 - 0001de2368]         BOOTMEM
#34 [0001de2380 - 0001de23e8]         BOOTMEM
#35 [0001de2400 - 0001de2468]         BOOTMEM
#36 [0001de2480 - 0001de24a0]         BOOTMEM
#37 [0001de24c0 - 0001de24e0]         BOOTMEM
#38 [0001de2500 - 0001de2590]         BOOTMEM
#39 [0001de25c0 - 0001de2650]         BOOTMEM
#40 [0001e00000 - 0001e1c000]         BOOTMEM
#41 [0001e80000 - 0001e9c000]         BOOTMEM
#42 [0001f00000 - 0001f1c000]         BOOTMEM
#43 [0001f80000 - 0001f9c000]         BOOTMEM
#44 [0001de2680 - 0001de2688]         BOOTMEM
#45 [0001de26c0 - 0001de26c8]         BOOTMEM
#46 [0001de2700 - 0001de2710]         BOOTMEM
#47 [0001de2740 - 0001de2760]         BOOTMEM
#48 [0001de2780 - 0001de28b0]         BOOTMEM
#49 [0001de28c0 - 0001de2910]         BOOTMEM
#50 [0001de2940 - 0001de2990]         BOOTMEM
#51 [0001de4000 - 0001dec000]         BOOTMEM
#52 [0020000000 - 0022000000]         BOOTMEM
#53 [0001de29c0 - 0001de29e0]         BOOTMEM
#54 [0001f9c000 - 0005f9c000]         BOOTMEM
#55 [0001e1c000 - 0001e3c000]         BOOTMEM
#56 [0001e3c000 - 0001e7c000]         BOOTMEM
#57 [000001f800 - 0000027800]         BOOTMEM
Memory: 7630836k/9175040k available (4763k kernel code, 1313348k absent,
230856k reserved, 6620k data, 900k init)



01:05.0 VGA compatible controller: ATI Technologies Inc Radeon HD 3200
Graphics (prog-if 00 [VGA controller])
        Subsystem: Giga-byte Technology GA-MA78GM-S2H Motherboard
        Flags: bus master, fast devsel, latency 0, IRQ 18
        Memory at d0000000 (32-bit, prefetchable) [size=256M]
        I/O ports at ee00 [size=256]
        Memory at fdfe0000 (32-bit, non-prefetchable) [size=64K]
        Memory at fde00000 (32-bit, non-prefetchable) [size=1M]
        Expansion ROM at <unassigned> [disabled]
        Capabilities: [50] Power Management version 3
        Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit+
        Kernel driver in use: fglrx_pci



Thanks for any hints,
kind regards,
Andreas


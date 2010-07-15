Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932831Ab0GOJKE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 05:10:04 -0400
Received: from smtp19.orange.fr ([80.12.242.17]:4207 "EHLO smtp19.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932766Ab0GOJJy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 05:09:54 -0400
X-ME-UUID: 20100715090948126.1EF872000216@mwinf1907.orange.fr
X-ME-User-Auth: eric.valette6
Message-ID: <4C3ED059.9050508@free.fr>
Date: Thu, 15 Jul 2010 11:09:45 +0200
From: Eric Valette <eric.valette@free.fr>
Reply-To: eric.valette@free.fr
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100620 Iceowl/1.0b1 Icedove/3.0.5
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: vga switcheroo not working on amilo Xi 3650
Content-Type: multipart/mixed;
 boundary="------------030504000908020301050403"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030504000908020301050403
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hi david,

As I saw some changes in the .35, I tried again on amilo xi 3650. As you 
will see its a Intel/Nvidia hybrid graphic laptop.

When I use the delayed switch option, and restart X via the kdm restart 
X server option, I see the message of the switch and then it hangs rock 
solid. I'm forced to push on the power button for 5 s.

vga_switcheroo: client 0 refused switch <== exiting the kdm session
vga_switcheroo: setting delayed switch to client 1
vga_switcheroo: processing delayed switch to 1 <== restarting X server


If I use the bios, to force the cards, both settings works correctly, 
hybrid mode also works correctly as long as I use the Intel card but I 
cannot activate dynamically the nvidia one via vga switcheroo.

Problem is that to have the hdmi output on this laptop I'm forced to use 
the nvidia driver and my kid like to see their film on TV...

uname -a
Linux pink-floyd2 2.6.35-rc4-git5 #142 SMP PREEMPT Mon Jul 12 22:54:13 
CEST 2010 x86_64 GNU/Linux

lscpi and dmesg attached. Is there anything I can try to make it work or 
debug? Actually the drivers are in kernel.

--eric

--------------030504000908020301050403
Content-Type: text/plain;
 name="dmesg"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg"

Linux version 2.6.35-rc4-git5 (valette@pink-floyd2) (gcc version 4.4.4 (Debian 4.4.4-6) ) #142 SMP PREEMPT Mon Jul 12 22:54:13 CEST 2010
Command line: auto BOOT_IMAGE=linux ro root=812 video=intelfb
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 0000000000098000 (usable)
 BIOS-e820: 0000000000098000 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000d4000 - 00000000000d8000 (reserved)
 BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000bdab1000 (usable)
 BIOS-e820: 00000000bdab1000 - 00000000bdab7000 (reserved)
 BIOS-e820: 00000000bdab7000 - 00000000bdbc2000 (usable)
 BIOS-e820: 00000000bdbc2000 - 00000000bdc0f000 (reserved)
 BIOS-e820: 00000000bdc0f000 - 00000000bdd08000 (usable)
 BIOS-e820: 00000000bdd08000 - 00000000bdf0f000 (reserved)
 BIOS-e820: 00000000bdf0f000 - 00000000bdf18000 (usable)
 BIOS-e820: 00000000bdf18000 - 00000000bdf1f000 (reserved)
 BIOS-e820: 00000000bdf1f000 - 00000000bdf54000 (usable)
 BIOS-e820: 00000000bdf54000 - 00000000bdf9f000 (ACPI NVS)
 BIOS-e820: 00000000bdf9f000 - 00000000bdfe3000 (usable)
 BIOS-e820: 00000000bdfe3000 - 00000000bdffd000 (ACPI data)
 BIOS-e820: 00000000bdffd000 - 00000000be000000 (usable)
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
  1 base 000000000 mask F00000000 write-back
  2 base 100000000 mask FC0000000 write-back
  3 disabled
  4 disabled
  5 disabled
  6 disabled
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
e820 update range: 00000000c0000000 - 0000000100000000 (usable) ==> (reserved)
last_pfn = 0xbe000 max_arch_pfn = 0x400000000
initial memory mapped : 0 - 20000000
init_memory_mapping: 0000000000000000-00000000be000000
 0000000000 - 00be000000 page 2M
kernel direct mapping tables up to be000000 @ 8000-c000
init_memory_mapping: 0000000100000000-0000000140000000
 0100000000 - 0140000000 page 2M
kernel direct mapping tables up to 140000000 @ a000-10000
ACPI: RSDP 00000000000f7560 00024 (v02 PTLTD )
ACPI: XSDT 00000000bdff4b92 0006C (v01 FSC    PC       06040000  LTP 00000000)
ACPI: FACP 00000000bdfe7000 000F4 (v03 INTEL  CRESTLNE 06040000 ALAN 00000001)
ACPI: DSDT 00000000bdfe8000 07FF8 (v02 FIC    XY680    06040000 INTL 20050624)
ACPI: FACS 00000000bdf9efc0 00040
ACPI: HPET 00000000bdffcd86 00038 (v01 INTEL  CRESTLNE 06040000 LOHR 0000005A)
ACPI: MCFG 00000000bdffcdbe 0003C (v01 INTEL  CRESTLNE 06040000 LOHR 0000005A)
ACPI: SLIC 00000000bdffcdfa 00176 (v01 FSC    PC       06040000 LOHR 0000005A)
ACPI: APIC 00000000bdffcf70 00068 (v01 PTLTD  ? APIC   06040000  LTP 00000000)
ACPI: BOOT 00000000bdffcfd8 00028 (v01 PTLTD  $SBFTBL$ 06040000  LTP 00000001)
ACPI: SSDT 00000000bdfe6000 00655 (v01  PmRef    CpuPm 00003000 INTL 20050624)
ACPI: SSDT 00000000bdfe5000 00259 (v01  PmRef  Cpu0Tst 00003000 INTL 20050624)
ACPI: SSDT 00000000bdfe4000 0020F (v01  PmRef    ApTst 00003000 INTL 20050624)
ACPI: Local APIC address 0xfee00000
 [ffffea0000000000-ffffea00045fffff] PMD -> [ffff880002200000-ffff8800059fffff] on node 0
Zone PFN ranges:
  DMA      0x00000001 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00140000
Movable zone start PFN for each node
early_node_map[9] active PFN ranges
    0: 0x00000001 -> 0x00000098
    0: 0x00000100 -> 0x000bdab1
    0: 0x000bdab7 -> 0x000bdbc2
    0: 0x000bdc0f -> 0x000bdd08
    0: 0x000bdf0f -> 0x000bdf18
    0: 0x000bdf1f -> 0x000bdf54
    0: 0x000bdf9f -> 0x000bdfe3
    0: 0x000bdffd -> 0x000be000
    0: 0x00100000 -> 0x00140000
On node 0 totalpages: 1039569
  DMA zone: 56 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 3935 pages, LIFO batch:0
  DMA32 zone: 14280 pages used for memmap
  DMA32 zone: 759154 pages, LIFO batch:31
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
PM: Registered nosave memory: 00000000000a0000 - 00000000000d4000
PM: Registered nosave memory: 00000000000d4000 - 00000000000d8000
PM: Registered nosave memory: 00000000000d8000 - 00000000000e4000
PM: Registered nosave memory: 00000000000e4000 - 0000000000100000
PM: Registered nosave memory: 00000000bdab1000 - 00000000bdab7000
PM: Registered nosave memory: 00000000bdbc2000 - 00000000bdc0f000
PM: Registered nosave memory: 00000000bdd08000 - 00000000bdf0f000
PM: Registered nosave memory: 00000000bdf18000 - 00000000bdf1f000
PM: Registered nosave memory: 00000000bdf54000 - 00000000bdf9f000
PM: Registered nosave memory: 00000000bdfe3000 - 00000000bdffd000
PM: Registered nosave memory: 00000000be000000 - 0000000100000000
Allocating PCI resources starting at be000000 (gap: be000000:42000000)
setup_percpu: NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
PERCPU: Embedded 26 pages/cpu @ffff880001a00000 s77504 r8192 d20800 u1048576
early_res array is doubled to 128 at [b000 - bfff]
pcpu-alloc: s77504 r8192 d20800 u1048576 alloc=1*2097152
pcpu-alloc: [0] 0 1 
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1021649
Kernel command line: auto BOOT_IMAGE=linux ro root=812 video=intelfb
PID hash table entries: 4096 (order: 3, 32768 bytes)
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Checking aperture...
No AGP bridge found
Subtract (64 early reservations)
  #1 [0001000000 - 00019196b4]   TEXT DATA BSS
  #2 [0000098000 - 0000100000]   BIOS reserved
  #3 [000191a000 - 000191a168]             BRK
  #4 [0000001000 - 0000003000]      TRAMPOLINE
  #5 [0000003000 - 0000007000]     ACPI WAKEUP
  #6 [0000008000 - 000000a000]         PGTABLE
  #7 [000000a000 - 000000b000]         PGTABLE
  #8 [000191a180 - 000191b180]         BOOTMEM
  #9 [00019196c0 - 00019199c0]         BOOTMEM
  #10 [000211c000 - 000211d000]         BOOTMEM
  #11 [000211d000 - 000211e000]         BOOTMEM
  #12 [0002200000 - 0005a00000]        MEMMAP 0
  #13 [00019199c0 - 0001919b40]         BOOTMEM
  #14 [000191b180 - 0001933180]         BOOTMEM
  #15 [0001933180 - 0001939180]         BOOTMEM
  #16 [000193a000 - 000193b000]         BOOTMEM
  #17 [0001919b40 - 0001919b81]         BOOTMEM
  #18 [0001919bc0 - 0001919c03]         BOOTMEM
  #19 [0001939180 - 00019395a8]         BOOTMEM
  #20 [0001919c40 - 0001919ca8]         BOOTMEM
  #21 [0001919cc0 - 0001919d28]         BOOTMEM
  #22 [0001919d40 - 0001919da8]         BOOTMEM
  #23 [0001919dc0 - 0001919e28]         BOOTMEM
  #24 [0001919e40 - 0001919ea8]         BOOTMEM
  #25 [0001919ec0 - 0001919f28]         BOOTMEM
  #26 [0001919f40 - 0001919fa8]         BOOTMEM
  #27 [00019395c0 - 0001939628]         BOOTMEM
  #28 [0001939640 - 00019396a8]         BOOTMEM
  #29 [00019396c0 - 0001939728]         BOOTMEM
  #30 [0001939740 - 00019397a8]         BOOTMEM
  #31 [00019397c0 - 0001939828]         BOOTMEM
  #32 [0001939840 - 00019398a8]         BOOTMEM
  #33 [00019398c0 - 0001939928]         BOOTMEM
  #34 [0001939940 - 00019399a8]         BOOTMEM
  #35 [00019399c0 - 0001939a28]         BOOTMEM
  #36 [0001939a40 - 0001939aa8]         BOOTMEM
  #37 [0001939ac0 - 0001939b28]         BOOTMEM
  #38 [0001919fc0 - 0001919fe0]         BOOTMEM
  #39 [0001939b40 - 0001939b60]         BOOTMEM
  #40 [0001939b80 - 0001939ba0]         BOOTMEM
  #41 [0001939bc0 - 0001939be0]         BOOTMEM
  #42 [0001939c00 - 0001939c20]         BOOTMEM
  #43 [0001939c40 - 0001939c60]         BOOTMEM
  #44 [0001939c80 - 0001939ca0]         BOOTMEM
  #45 [0001939cc0 - 0001939ce0]         BOOTMEM
  #46 [0001939d00 - 0001939d30]         BOOTMEM
  #47 [0001939d40 - 0001939d70]         BOOTMEM
  #48 [0001a00000 - 0001a1a000]         BOOTMEM
  #49 [0001b00000 - 0001b1a000]         BOOTMEM
  #50 [0001939d80 - 0001939d88]         BOOTMEM
  #51 [0001939dc0 - 0001939dc8]         BOOTMEM
  #52 [0001939e00 - 0001939e08]         BOOTMEM
  #53 [0001939e40 - 0001939e50]         BOOTMEM
  #54 [0001939e80 - 0001939fc0]         BOOTMEM
  #55 [000193d000 - 000193d060]         BOOTMEM
  #56 [000193d080 - 000193d0e0]         BOOTMEM
  #57 [000193d100 - 0001945100]         BOOTMEM
  #58 [0001b1a000 - 0001f1a000]         BOOTMEM
  #59 [0001f1a000 - 000211a000]         BOOTMEM
  #60 [0005a00000 - 0009a00000]         BOOTMEM
  #61 [0001945100 - 0001965100]         BOOTMEM
  #62 [0001965100 - 00019a5100]         BOOTMEM
  #63 [000000c000 - 0000014000]         BOOTMEM
Memory: 4019096k/5242880k available (5358k kernel code, 1084604k absent, 139180k reserved, 2932k data, 484k init)
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
Detected 2527.117 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 5054.23 BogoMIPS (lpj=2527117)
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
Total of 2 processors activated (10107.96 BogoMIPS).
Time: 10:31:12  Date: 07/15/10
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
PCI: not using MMCONFIG
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: EC: Look up EC in DSDT
ACPI: BIOS _OSI(Linux) query ignored
ACPI: SSDT 00000000bdf1ac20 0028A (v01  PmRef  Cpu0Ist 00003000 INTL 20050624)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT (null) 0028A (v01  PmRef  Cpu0Ist 00003000 INTL 20050624)
ACPI: SSDT 00000000bdf18620 0057B (v01  PmRef  Cpu0Cst 00003001 INTL 20050624)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT (null) 0057B (v01  PmRef  Cpu0Cst 00003001 INTL 20050624)
ACPI: SSDT 00000000bdf19ca0 001CF (v01  PmRef    ApIst 00003000 INTL 20050624)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT (null) 001CF (v01  PmRef    ApIst 00003000 INTL 20050624)
ACPI: SSDT 00000000bdf19f20 0008D (v01  PmRef    ApCst 00003000 INTL 20050624)
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
pci 0000:00:19.0: reg 10: [mem 0xf3400000-0xf341ffff]
pci 0000:00:19.0: reg 14: [mem 0xf3424000-0xf3424fff]
pci 0000:00:19.0: reg 18: [io  0x1800-0x181f]
pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
pci 0000:00:19.0: PME# disabled
pci 0000:00:1a.0: reg 20: [io  0x1820-0x183f]
pci 0000:00:1a.1: reg 20: [io  0x1840-0x185f]
pci 0000:00:1a.2: reg 20: [io  0x1860-0x187f]
pci 0000:00:1a.7: reg 10: [mem 0xf3425800-0xf3425bff]
pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1a.7: PME# disabled
pci 0000:00:1b.0: reg 10: [mem 0xf3420000-0xf3423fff 64bit]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: PME# disabled
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.1: PME# disabled
pci 0000:00:1d.0: reg 20: [io  0x1880-0x189f]
pci 0000:00:1d.1: reg 20: [io  0x18a0-0x18bf]
pci 0000:00:1d.2: reg 20: [io  0x18c0-0x18df]
pci 0000:00:1d.7: reg 10: [mem 0xf3425c00-0xf3425fff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1f.2: reg 10: [io  0x1c10-0x1c17]
pci 0000:00:1f.2: reg 14: [io  0x1c04-0x1c07]
pci 0000:00:1f.2: reg 18: [io  0x1c08-0x1c0f]
pci 0000:00:1f.2: reg 1c: [io  0x1c00-0x1c03]
pci 0000:00:1f.2: reg 20: [io  0x18e0-0x18ff]
pci 0000:00:1f.2: reg 24: [mem 0xf3425000-0xf34257ff]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.2: PME# disabled
pci 0000:00:1f.3: reg 10: [mem 0x00000000-0x000000ff 64bit]
pci 0000:00:1f.3: reg 20: [io  0x1c20-0x1c3f]
pci 0000:01:00.0: reg 10: [mem 0xf2000000-0xf2ffffff]
pci 0000:01:00.0: reg 14: [mem 0xd0000000-0xdfffffff 64bit pref]
pci 0000:01:00.0: reg 1c: [mem 0xf0000000-0xf1ffffff 64bit]
pci 0000:01:00.0: reg 24: [io  0x2000-0x207f]
pci 0000:01:00.0: reg 30: [mem 0x00000000-0x0007ffff pref]
pci 0000:00:01.0: PCI bridge to [bus 01-01]
pci 0000:00:01.0:   bridge window [io  0x2000-0x2fff]
pci 0000:00:01.0:   bridge window [mem 0xf0000000-0xf2ffffff]
pci 0000:00:01.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
pci 0000:00:1c.0: PCI bridge to [bus 02-03]
pci 0000:00:1c.0:   bridge window [io  0x3000-0x3fff]
pci 0000:00:1c.0:   bridge window [mem 0xf4000000-0xf5ffffff]
pci 0000:00:1c.0:   bridge window [mem 0xf6000000-0xf7ffffff 64bit pref]
pci 0000:04:00.0: reg 10: [mem 0xf3000000-0xf3001fff 64bit]
pci 0000:04:00.0: PME# supported from D0 D3hot D3cold
pci 0000:04:00.0: PME# disabled
pci 0000:00:1c.1: PCI bridge to [bus 04-04]
pci 0000:00:1c.1:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:1c.1:   bridge window [mem 0xf3000000-0xf30fffff]
pci 0000:00:1c.1:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:05:04.0: reg 10: [mem 0xf3100000-0xf3100fff]
pci 0000:05:04.0: supports D1 D2
pci 0000:05:04.0: PME# supported from D0 D1 D2 D3hot
pci 0000:05:04.0: PME# disabled
pci 0000:00:1e.0: PCI bridge to [bus 05-05] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:1e.0:   bridge window [mem 0xf3100000-0xf31fffff]
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
vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
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
reserve RAM buffer: 00000000bdab1000 - 00000000bfffffff 
reserve RAM buffer: 00000000bdbc2000 - 00000000bfffffff 
reserve RAM buffer: 00000000bdd08000 - 00000000bfffffff 
reserve RAM buffer: 00000000bdf18000 - 00000000bfffffff 
reserve RAM buffer: 00000000bdf54000 - 00000000bfffffff 
reserve RAM buffer: 00000000bdfe3000 - 00000000bfffffff 
reserve RAM buffer: 00000000be000000 - 00000000bfffffff 
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
pci 0000:00:1c.1: BAR 9: assigned [mem 0xc0000000-0xc01fffff 64bit pref]
pci 0000:00:1c.1: BAR 7: assigned [io  0x4000-0x4fff]
pci 0000:00:1f.3: BAR 0: assigned [mem 0xc0200000-0xc02000ff 64bit]
pci 0000:00:1f.3: BAR 0: set to [mem 0xc0200000-0xc02000ff 64bit] (PCI address [0xc0200000-0xc02000ff]
pci 0000:01:00.0: BAR 6: can't assign mem pref (size 0x80000)
pci 0000:00:01.0: PCI bridge to [bus 01-01]
pci 0000:00:01.0:   bridge window [io  0x2000-0x2fff]
pci 0000:00:01.0:   bridge window [mem 0xf0000000-0xf2ffffff]
pci 0000:00:01.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
pci 0000:00:1c.0: PCI bridge to [bus 02-03]
pci 0000:00:1c.0:   bridge window [io  0x3000-0x3fff]
pci 0000:00:1c.0:   bridge window [mem 0xf4000000-0xf5ffffff]
pci 0000:00:1c.0:   bridge window [mem 0xf6000000-0xf7ffffff 64bit pref]
pci 0000:00:1c.1: PCI bridge to [bus 04-04]
pci 0000:00:1c.1:   bridge window [io  0x4000-0x4fff]
pci 0000:00:1c.1:   bridge window [mem 0xf3000000-0xf30fffff]
pci 0000:00:1c.1:   bridge window [mem 0xc0000000-0xc01fffff 64bit pref]
pci 0000:00:1e.0: PCI bridge to [bus 05-05]
pci 0000:00:1e.0:   bridge window [io  disabled]
pci 0000:00:1e.0:   bridge window [mem 0xf3100000-0xf31fffff]
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
pci_bus 0000:01: resource 2 [mem 0xd0000000-0xdfffffff 64bit pref]
pci_bus 0000:02: resource 0 [io  0x3000-0x3fff]
pci_bus 0000:02: resource 1 [mem 0xf4000000-0xf5ffffff]
pci_bus 0000:02: resource 2 [mem 0xf6000000-0xf7ffffff 64bit pref]
pci_bus 0000:04: resource 0 [io  0x4000-0x4fff]
pci_bus 0000:04: resource 1 [mem 0xf3000000-0xf30fffff]
pci_bus 0000:04: resource 2 [mem 0xc0000000-0xc01fffff 64bit pref]
pci_bus 0000:05: resource 1 [mem 0xf3100000-0xf31fffff]
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
pci 0000:01:00.0: Boot video device
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
msgmni has been set to 7849
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
[Firmware Bug]: ACPI: ACPI brightness control misses _BQC function
acpi device:02: registered as cooling_device0
input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:00/LNXVIDEO:00/input/input4
ACPI: Video Device [PEGP] (multi-head: yes  rom: yes  post: no)
ACPI: acpi_idle registered with cpuidle
Monitor-Mwait will be used to enter C-1 state
Monitor-Mwait will be used to enter C-2 state
Monitor-Mwait will be used to enter C-3 state
Marking TSC unstable due to TSC halts in idle
Switching to clocksource hpet
thermal LNXTHERM:01: registered as thermal_zone0
ACPI: Thermal Zone [TZ00] (35 C)
Non-volatile memory driver v1.3
Linux agpgart interface v0.103
ipmi message handler version 39.2
ipmi device interface
IPMI System Interface driver.
ipmi_si: Adding default-specified kcs state machine
ipmi_si: Trying default-specified kcs state machine at i/o address 0xca2, slave address 0x0, irq 0
ipmi_si: Interface detection failed
ACPI: Battery Slot [BAT0] (battery present)
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
[drm:i915_init] *ERROR* drm/i915 can't work without intel_agp module!
nouveau 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
nouveau 0000:01:00.0: setting latency timer to 64
[drm] nouveau 0000:01:00.0: Detected an NV50 generation card (0x096480a1)
[drm] nouveau 0000:01:00.0: Attempting to load BIOS image from ACPI
[drm] nouveau 0000:01:00.0: ... BIOS signature not found
[drm] nouveau 0000:01:00.0: Attempting to load BIOS image from PRAMIN
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
[drm] nouveau 0000:01:00.0: Parsing VBIOS init table 0 at offset 0xD463
[drm] nouveau 0000:01:00.0: Parsing VBIOS init table 1 at offset 0xD8E0
[drm] nouveau 0000:01:00.0: Parsing VBIOS init table 2 at offset 0xE8A9
[drm] nouveau 0000:01:00.0: Parsing VBIOS init table 3 at offset 0xE9CA
[drm] nouveau 0000:01:00.0: Parsing VBIOS init table 4 at offset 0xEC47
[drm] nouveau 0000:01:00.0: Parsing VBIOS init table at offset 0xECAC
[drm] nouveau 0000:01:00.0: 0xECAC: Condition still not met after 20ms, skipping following opcodes
[drm] nouveau 0000:01:00.0: Couldn't find matching output script table
[drm] nouveau 0000:01:00.0: 0xC108: parsing output script 0
[drm] nouveau 0000:01:00.0: Detected 512MiB VRAM
[TTM] Zone  kernel: Available graphics memory: 2009548 kiB.
[TTM] Initializing pool allocator.
[drm] nouveau 0000:01:00.0: 512 MiB GART (aperture)
mtrr: type mismatch for d0000000,10000000 old: write-back new: write-combining
[drm] nouveau 0000:01:00.0: Allocating FIFO number 1
[drm] nouveau 0000:01:00.0: nouveau_channel_alloc: initialised FIFO 1
[drm] nouveau 0000:01:00.0: Detected a LVDS output
[drm] nouveau 0000:01:00.0: Detected a DAC output
[drm] nouveau 0000:01:00.0: Detected a TMDS output
[drm] nouveau 0000:01:00.0: Detected a LVDS connector
[drm] nouveau 0000:01:00.0: Detected a VGA connector
[drm] nouveau 0000:01:00.0: Detected a HDMI connector
[drm] nouveau 0000:01:00.0: allocated 1920x1080 fb: 0x40250000, bo ffff88013fe1a000
Console: switching to colour frame buffer device 240x67
fb0: nouveaufb frame buffer device
drm: registered panic notifier
[drm] Initialized nouveau 0.0.16 20090420 for 0000:01:00.0 on minor 0
[drm] nouveau 0000:01:00.0: Couldn't find matching output script table
[drm] nouveau 0000:01:00.0: Couldn't find matching output script table
[drm] nouveau 0000:01:00.0: Couldn't find matching output script table
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
brd: module loaded
loop: module loaded
ahci 0000:00:1f.2: version 3.0
ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ahci 0000:00:1f.2: irq 43 for MSI/MSI-X
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
ata1: SATA max UDMA/133 abar m2048@0xf3425000 port 0xf3425100 irq 43
ata2: SATA max UDMA/133 abar m2048@0xf3425000 port 0xf3425180 irq 43
ata3: DUMMY
ata4: DUMMY
ata5: SATA max UDMA/133 abar m2048@0xf3425000 port 0xf3425300 irq 43
ata6: SATA max UDMA/133 abar m2048@0xf3425000 port 0xf3425380 irq 43
e1000e: Intel(R) PRO/1000 Network Driver - 1.0.2-k4
e1000e: Copyright (c) 1999 - 2009 Intel Corporation.
e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
e1000e 0000:00:19.0: setting latency timer to 64
e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
e1000e 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:14:0b:4f:78:46
e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
e1000e 0000:00:19.0: eth0: MAC: 7, PHY: 8, PBA No: ffffff-0ff
iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:
iwlagn: Copyright(c) 2003-2010 Intel Corporation
iwlagn 0000:04:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
iwlagn 0000:04:00.0: setting latency timer to 64
iwlagn 0000:04:00.0: Detected Intel(R) WiFi Link 5100 AGN, REV=0x54
iwlagn 0000:04:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
iwlagn 0000:04:00.0: irq 45 for MSI/MSI-X
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
ehci_hcd 0000:00:1a.7: irq 19, io mem 0xf3425800
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
[drm] nouveau 0000:01:00.0: Couldn't find matching output script table
/usr/src/linux-2.6.29.1/drivers/usb/core/inode.c: creating file '002'
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:1d.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
ehci_hcd 0000:00:1d.7: reset hcc_params 6871 thresh 7 uframes 1024 64 bit addr
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: reset command 080032 (park)=0 ithresh=8 Async Periodic period=1024 Reset HALT
ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
ehci_hcd 0000:00:1d.7: supports USB remote wakeup
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xf3425c00
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
uhci_hcd 0000:00:1a.0: irq 16, io base 0x00001820
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
/usr/src/linux-2.6.29.1/drivers/usb/core/inode.c: creating file '004'
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1a.1: detected 2 ports
uhci_hcd 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1a.1: Performing full reset
uhci_hcd 0000:00:1a.1: supports USB remote wakeup
uhci_hcd 0000:00:1a.1: irq 21, io base 0x00001840
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
uhci_hcd 0000:00:1a.2: irq 19, io base 0x00001860
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
uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1d.0: Performing full reset
uhci_hcd 0000:00:1d.0: supports USB remote wakeup
uhci_hcd 0000:00:1d.0: irq 23, io base 0x00001880
usb usb6: default language 0x0409
usb usb6: udev 1, busnum 6, minor = 640
usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb6: Product: UHCI Host Controller
usb usb6: Manufacturer: Linux 2.6.35-rc4-git5 uhci_hcd
usb usb6: SerialNumber: 0000:00:1d.0
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
uhci_hcd 0000:00:1d.1: irq 19, io base 0x000018a0
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
uhci_hcd 0000:00:1d.2: irq 18, io base 0x000018c0
usb usb8: default language 0x0409
usb usb8: udev 1, busnum 8, minor = 896
usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb8: Product: UHCI Host Controller
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
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: ATA-8: FUJITSU MHZ2320BH G2, 00000009, max UDMA/100
ata1.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
i8042.c: Detected active multiplexing controller, rev 1.1.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX0 port at 0x60,0x64 irq 12
ata1.00: configured for UDMA/100
serio: i8042 AUX1 port at 0x60,0x64 irq 12
serio: i8042 AUX2 port at 0x60,0x64 irq 12
serio: i8042 AUX3 port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
rtc_cmos 00:06: RTC can wake from S4
rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
i2c /dev entries driver
i801_smbus 0000:00:1f.3: PCI INT C -> GSI 19 (level, low) -> IRQ 19
ACPI: resource 0000:00:1f.3 [io  0x1c20-0x1c3f] conflicts with ACPI region SMBI [mem 0x00001c20-0x00001c2f pref window disabled]
ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
IR NEC protocol handler initialized
IR RC5(x) protocol handler initialized
IR RC6 protocol handler initialized
IR JVC protocol handler initialized
IR Sony protocol handler initialized
scsi 0:0:0:0: Direct-Access     ATA      FUJITSU MHZ2320B 0000 PQ: 0 ANSI: 5
sd 0:0:0:0: Attached scsi generic sg0 type 0
sd 0:0:0:0: [sda] 625142448 512-byte logical blocks: (320 GB/298 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Linux video capture interface: v2.00
sn9c102: V4L2 driver for SN9C1xx PC Camera Controllers v1:1.47pre49
usbcore: registered new interface driver sn9c102
gspca: main v2.9.0 registered
ehci_hcd 0000:00:1a.7: GetStatus port 3 status 001803 POWER sig=j CSC CONNECT
hub 1-0:1.0: port 3: status 0501 change 0001
ehci_hcd 0000:00:1a.7: GetStatus port 4 status 001803 POWER sig=j CSC CONNECT
hub 1-0:1.0: port 4: status 0501 change 0001
 sda:
usbcore: registered new interface driver spca508
spca508: registered
usbcore: registered new interface driver spca561
spca561: registered
usbcore: registered new interface driver uvcvideo
USB Video Class driver (v0.1.0)
md: raid0 personality registered for level 0
md: raid1 personality registered for level 1
device-mapper: ioctl: 4.17.0-ioctl (2010-03-05) initialised: dm-devel@redhat.com
cpuidle: using governor ladder
cpuidle: using governor menu
No iBFT detected.
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
fujitsu-laptop: driver 0.6.0 successfully loaded.
HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
HDA Intel 0000:00:1b.0: irq 46 for MSI/MSI-X
HDA Intel 0000:00:1b.0: setting latency timer to 64
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input5
hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0000
hda_codec: ALC888: SKU not ready 0x598301f0
hda_codec: ALC888: BIOS auto-probing.
hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
ALSA device list:
  #0: HDA Intel at 0xf3420000 irq 46
Netfilter messages via NETLINK v0.30.
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
ctnetlink v0.93: registering with nfnetlink.
ip_tables: (C) 2000-2006 Netfilter Core Team
TCP cubic registered
NET: Registered protocol family 17
uhci_hcd 0000:00:1a.1: port 1 portsc 0082,00
uhci_hcd 0000:00:1a.1: port 2 portsc 008a,00
lib80211: common routines for IEEE802.11 drivers
lib80211_crypt: registered algorithm 'NULL'
PM: Resume from disk failed.
  Magic number: 2:669:527
uhci_hcd 0000:00:1a.2: port 1 portsc 0082,00
hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0000
hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0000
hub 8-0:1.0: state 7 ports 2 chg 0000 evt 0000
hub 1-0:1.0: state 7 ports 6 chg 0018 evt 0000
hub 1-0:1.0: port 3, status 0501, change 0000, 480 Mb/s
ehci_hcd 0000:00:1a.7: port 3 high speed
ehci_hcd 0000:00:1a.7: GetStatus port 3 status 001005 POWER sig=se0 PE CONNECT
usb 1-3: new high speed USB device using ehci_hcd and address 2
ehci_hcd 0000:00:1a.7: port 3 high speed
ehci_hcd 0000:00:1a.7: GetStatus port 3 status 001005 POWER sig=se0 PE CONNECT
usb 1-3: default language 0x0409
 sda1 sda2 <
usb 1-3: udev 2, busnum 1, minor = 1
usb 1-3: New USB device found, idVendor=0bda, idProduct=0167
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
firewire_core: created device fw0: GUID 0040ca01470026ef, S400
 sda5 sda6 >
sd 0:0:0:0: [sda] Attached SCSI disk
ehci_hcd 0000:00:1a.7: port 4 full speed --> companion
ehci_hcd 0000:00:1a.7: GetStatus port 4 status 003801 POWER OWNER sig=j CONNECT
hub 1-0:1.0: port 4 not reset yet, waiting 50ms
ehci_hcd 0000:00:1a.7: GetStatus port 4 status 003002 POWER OWNER sig=se0 CSC
hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
hub 1-0:1.0: state 7 ports 6 chg 0000 evt 0010
input: PS/2 Mouse as /devices/platform/i8042/serio4/input/input6
input: AlpsPS/2 ALPS GlidePoint as /devices/platform/i8042/serio4/input/input7
hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0004
uhci_hcd 0000:00:1a.1: port 2 portsc 0093,00
hub 4-0:1.0: port 2, status 0101, change 0001, 12 Mb/s
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata2.00: ATA-8: FUJITSU MHZ2320BH G2, 00000009, max UDMA/100
ata2.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
ata2.00: configured for UDMA/100
scsi 1:0:0:0: Direct-Access     ATA      FUJITSU MHZ2320B 0000 PQ: 0 ANSI: 5
sd 1:0:0:0: [sdb] 625142448 512-byte logical blocks: (320 GB/298 GiB)
sd 1:0:0:0: Attached scsi generic sg1 type 0
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb:
hub 4-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x101
 sdb1 sdb2 sdb3 sdb4 < sdb5 sdb6 sdb7 sdb8 sdb9
usb 4-2: new full speed USB device using uhci_hcd and address 2
 sdb10 >
sd 1:0:0:0: [sdb] Attached SCSI disk
usb 4-2: ep0 maxpacket = 16
usb 4-2: uhci_result_common: failed with status 440000
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
usb usb3: suspend_rh (auto-stop)
usb usb6: suspend_rh (auto-stop)
usb usb7: suspend_rh (auto-stop)
usb usb8: suspend_rh (auto-stop)
usb usb5: suspend_rh (auto-stop)
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
hub 5-0:1.0: hub_suspend
usb usb5: bus auto-suspend
usb usb5: suspend_rh
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
e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
wlan0: authenticate with 00:1d:6a:57:d3:5e (try 1)
wlan0: authenticated
wlan0: associate with 00:1d:6a:57:d3:5e (try 1)
wlan0: RX AssocResp from 00:1d:6a:57:d3:5e (capab=0x431 status=0 aid=1)
wlan0: associated
cfg80211: Calling CRDA for country: FR
[drm] nouveau 0000:01:00.0: Allocating FIFO number 2
[drm] nouveau 0000:01:00.0: nouveau_channel_alloc: initialised FIFO 2
[drm] nouveau 0000:01:00.0: Allocating FIFO number 3
[drm] nouveau 0000:01:00.0: nouveau_channel_alloc: initialised FIFO 3
iwlagn 0000:04:00.0: Fail finding valid aggregation tid: 0
CE: hpet increased min_delta_ns to 7500 nsec
CE: hpet increased min_delta_ns to 11250 nsec
iwlagn 0000:04:00.0: iwlagn_tx_agg_start on ra = 00:1d:6a:57:d3:5e tid = 0
CPUFREQ: Per core ondemand sysfs interface is deprecated - up_threshold
ata1.00: configured for UDMA/100
ata1: EH complete
sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
ata2.00: configured for UDMA/100
ata2: EH complete
sd 1:0:0:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
iwlagn 0000:04:00.0: Fail finding valid aggregation tid: 6
iwlagn 0000:04:00.0: iwlagn_tx_agg_start on ra = 00:1d:6a:57:d3:5e tid = 6

--------------030504000908020301050403
Content-Type: text/plain;
 name="lspci"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="lspci"

00:00.0 Host bridge: Intel Corporation Mobile 4 Series Chipset Memory Controller Hub (rev 07)
00:01.0 PCI bridge: Intel Corporation Mobile 4 Series Chipset PCI Express Graphics Port (rev 07)
00:19.0 Ethernet controller: Intel Corporation 82567LF Gigabit Network Connection (rev 03)
00:1a.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #4 (rev 03)
00:1a.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #5 (rev 03)
00:1a.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #6 (rev 03)
00:1a.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #2 (rev 03)
00:1b.0 Audio device: Intel Corporation 82801I (ICH9 Family) HD Audio Controller (rev 03)
00:1c.0 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 1 (rev 03)
00:1c.1 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 2 (rev 03)
00:1d.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #1 (rev 03)
00:1d.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #2 (rev 03)
00:1d.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #3 (rev 03)
00:1d.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #1 (rev 03)
00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev 93)
00:1f.0 ISA bridge: Intel Corporation ICH9M-E LPC Interface Controller (rev 03)
00:1f.2 RAID bus controller: Intel Corporation Mobile 82801 SATA RAID Controller (rev 03)
00:1f.3 SMBus: Intel Corporation 82801I (ICH9 Family) SMBus Controller (rev 03)
01:00.0 VGA compatible controller: nVidia Corporation G96 [GeForce 9600M GT] (rev a1)
04:00.0 Network controller: Intel Corporation WiFi Link 5100
05:04.0 FireWire (IEEE 1394): Agere Systems FW322/323 (rev 70)

--------------030504000908020301050403--



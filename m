Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731Ab0GGLdj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 07:33:39 -0400
Received: from queueout02-winn.ispmail.ntl.com ([81.103.221.56]:47028 "EHLO
	queueout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753386Ab0GGLdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 07:33:35 -0400
Message-ID: <4C346579.3060706@ntlworld.com>
Date: Wed, 07 Jul 2010 12:31:05 +0100
From: Stuart <smf.forum1@ntlworld.com>
Organization: Linux user
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: ERROR: Unable to locate IOAPIC for GSI xx
Content-Type: multipart/mixed;
 boundary="------------060309080209060504070804"
X-Cloudmark-Analysis: v=1.1 cv=DhNl2YeytwJssBBGe49HJX82LNDFEEVkpVB34RXKaPo= c=1 sm=0 a=CPvMLYde28cA:10 a=0qYQvVkOOIcA:10 a=ORa4HqFjfvEA:10 a=lPodW9k3uK6-FsBIdkoA:9 a=tEvYMhjHQDVRwEbVXeIGsYwFA14A:4 a=wPNLvfGTeEIA:10 a=2z1OXlWFAAAA:8 a=FP58Ms26AAAA:8 a=pSDxxfrZAAAA:8 a=WDxyHrnoUM-aukedNsUA:9 a=CovhspTnWEPuejlFvLQA:7 a=ZPMolPbwHbmOljTPgnasA96Zkc0A:4 a=hW-O4At9umGNhLbh:21 a=g7F-XgqHOEiGi3bD:21 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060309080209060504070804
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

  Noticed the following errors on 2.6.35-rc4 (IBM Thinkpad R51 2889SG1) 
(full details attached).

ERROR: Unable to locate IOAPIC for GSI 13
ERROR: Unable to locate IOAPIC for GSI 8
ERROR: Unable to locate IOAPIC for GSI 1
ERROR: Unable to locate IOAPIC for GSI 12
ERROR: Unable to locate IOAPIC for GSI 6

I saw a similar reported in June on 2.6.35-rc1 but I have not been able 
to find any follow ups.

Is anyone currently investigating this ?

thanks

--------------060309080209060504070804
Content-Type: text/plain;
 name="GSIError1"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="GSIError1"

Linux version 2.6.35-rc4 (root@Mars) (gcc version 4.5.0 (GCC) ) #1 Mon Jul 5 10:34:25 BST 2010
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
 BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000005f6e0000 (usable)
 BIOS-e820: 000000005f6e0000 - 000000005f6f7000 (ACPI data)
 BIOS-e820: 000000005f6f7000 - 000000005f6f9000 (ACPI NVS)
 BIOS-e820: 000000005f700000 - 0000000060000000 (reserved)
 BIOS-e820: 00000000ff800000 - 0000000100000000 (reserved)
Notice: NX (Execute Disable) protection missing in CPU or disabled in BIOS!
DMI present.
e820 update range: 0000000000000000 - 0000000000001000 (usable) ==> (reserved)
e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
last_pfn = 0x5f6e0 max_arch_pfn = 0x100000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-CFFFF write-protect
  D0000-DBFFF uncachable
  DC000-DFFFF write-back
  E0000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 000000000 mask FC0000000 write-back
  1 base 040000000 mask FE0000000 write-back
  2 base 05FF00000 mask FFFF00000 uncachable
  3 disabled
  4 disabled
  5 disabled
  6 disabled
  7 disabled
PAT not supported by CPU.
e820 update range: 0000000000001000 - 0000000000010000 (usable) ==> (reserved)
Scanning 1 areas for low memory corruption
modified physical RAM map:
 modified: 0000000000000000 - 0000000000010000 (reserved)
 modified: 0000000000010000 - 000000000009f000 (usable)
 modified: 000000000009f000 - 00000000000a0000 (reserved)
 modified: 00000000000dc000 - 0000000000100000 (reserved)
 modified: 0000000000100000 - 000000005f6e0000 (usable)
 modified: 000000005f6e0000 - 000000005f6f7000 (ACPI data)
 modified: 000000005f6f7000 - 000000005f6f9000 (ACPI NVS)
 modified: 000000005f700000 - 0000000060000000 (reserved)
 modified: 00000000ff800000 - 0000000100000000 (reserved)
initial memory mapped : 0 - 01800000
init_memory_mapping: 0000000000000000-00000000377fe000
 0000000000 - 0000400000 page 4k
 0000400000 - 0037400000 page 2M
 0037400000 - 00377fe000 page 4k
kernel direct mapping tables up to 377fe000 @ 10000-15000
ACPI: RSDP 000f6da0 00024 (v02 IBM   )
ACPI: XSDT 5f6eb16b 0004C (v01 IBM    TP-1V    00001290  LTP 00000000)
ACPI: FACP 5f6eb200 000F4 (v03 IBM    TP-1V    00001290 IBM  00000001)
ACPI Warning: 32/64X length mismatch in Gpe1Block: 0/32 (20100428/tbfadt-526)
ACPI Warning: Optional field Gpe1Block has zero address or length: 0x000000000000102C/0x0 (20100428/tbfadt-557)
ACPI: DSDT 5f6eb3e7 0BA37 (v01 IBM    TP-1V    00001290 MSFT 0100000E)
ACPI: FACS 5f6f8000 00040
ACPI: SSDT 5f6eb3b4 00033 (v01 IBM    TP-1V    00001290 MSFT 0100000E)
ACPI: ECDT 5f6f6e1e 00052 (v01 IBM    TP-1V    00001290 IBM  00000001)
ACPI: TCPA 5f6f6e70 00032 (v01 IBM    TP-1V    00001290 PTL  00000001)
ACPI: BOOT 5f6f6fd8 00028 (v01 IBM    TP-1V    00001290  LTP 00000001)
638MB HIGHMEM available.
887MB LOWMEM available.
  mapped low ram: 0 - 377fe000
  low ram: 0 - 377fe000
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  Normal   0x00001000 -> 0x000377fe
  HighMem  0x000377fe -> 0x0005f6e0
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000010 -> 0x0000009f
    0: 0x00000100 -> 0x0005f6e0
On node 0 totalpages: 390767
free_area_init_node: node 0, pgdat c1381e40, node_mem_map c1413200
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 3951 pages, LIFO batch:0
  Normal zone: 1744 pages used for memmap
  Normal zone: 221486 pages, LIFO batch:31
  HighMem zone: 1278 pages used for memmap
  HighMem zone: 162276 pages, LIFO batch:31
Using APIC driver default
ACPI: PM-Timer IO Port: 0x1008
Local APIC disabled by BIOS -- reenabling.
Found and enabled local APIC!
nr_irqs_gsi: 16
Allocating PCI resources starting at 60000000 (gap: 60000000:9f800000)
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 387713
Kernel command line: BOOT_IMAGE=Linux_2.6.35T ro root=307 userpte=nohigh i915.modeset=1 lapic pci=use_crs
PID hash table entries: 4096 (order: 2, 16384 bytes)
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
Subtract (26 early reservations)
  #0 [0001000000 - 000140a260]   TEXT DATA BSS
  #1 [000009f000 - 0000100000]   BIOS reserved
  #2 [000140b000 - 0001411128]             BRK
  #3 [0000010000 - 0000011000]         PGTABLE
  #4 [0001412000 - 0001413000]         BOOTMEM
  #5 [0001413000 - 0002003000]         BOOTMEM
  #6 [000140a280 - 000140a284]         BOOTMEM
  #7 [000140a2c0 - 000140a340]         BOOTMEM
  #8 [000140a340 - 000140a394]         BOOTMEM
  #9 [0002003000 - 0002005000]         BOOTMEM
  #10 [000140a3c0 - 000140a3fc]         BOOTMEM
  #11 [0002005000 - 0002007000]         BOOTMEM
  #12 [000140a400 - 000140a4fc]         BOOTMEM
  #13 [000140a500 - 000140a540]         BOOTMEM
  #14 [000140a540 - 000140a580]         BOOTMEM
  #15 [000140a580 - 000140a5c0]         BOOTMEM
  #16 [000140a5c0 - 000140a600]         BOOTMEM
  #17 [000140a600 - 000140a640]         BOOTMEM
  #18 [000140a640 - 000140a680]         BOOTMEM
  #19 [000140a680 - 000140a6c0]         BOOTMEM
  #20 [000140a6c0 - 000140a700]         BOOTMEM
  #21 [000140a700 - 000140a755]         BOOTMEM
  #22 [000140a780 - 000140a7d5]         BOOTMEM
  #23 [0002007000 - 000200b000]         BOOTMEM
  #24 [000200b000 - 000208b000]         BOOTMEM
  #25 [000208b000 - 00020cb000]         BOOTMEM
Initializing HighMem for node 0 (000377fe:0005f6e0)
Memory: 1545868k/1563520k available (2629k kernel code, 17200k reserved, 970k data, 276k init, 654216k highmem)
virtual kernel memory layout:
    fixmap  : 0xfffa3000 - 0xfffff000   ( 368 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
    lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
      .init : 0xc1385000 - 0xc13ca000   ( 276 kB)
      .data : 0xc129159d - 0xc1383ff8   ( 970 kB)
      .text : 0xc1000000 - 0xc129159d   (2629 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
Hierarchical RCU implementation.
	RCU-based detection of stalled CPUs is disabled.
	Verbose stalled-CPUs detection is disabled.
NR_IRQS:288
Extended CMOS year: 2000
Console: colour VGA+ 80x25
console [tty0] enabled
Fast TSC calibration using PIT
Detected 1698.291 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 3397.10 BogoMIPS (lpj=5660970)
pid_max: default: 32768 minimum: 301
Mount-cache hash table entries: 512
mce: CPU supports 5 MCE banks
CPU0: Thermal monitoring enabled (TM2)
Performance Events: p6 PMU driver.
... version:                0
... bit width:              32
... generic registers:      2
... value mask:             00000000ffffffff
... max period:             000000007fffffff
... fixed-purpose events:   0
... event mask:             0000000000000003
CPU: Intel(R) Pentium(R) M processor 1.70GHz stepping 06
ACPI: Core revision 20100428
ACPI: setting ELCR to 0200 (from 0800)
Enabling APIC mode:  Flat.  Using 0 I/O APICs
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfd8e6, last bus=5
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: EC: EC description table is found, configuring boot EC
ACPI: Interpreter enabled
ACPI: (supports S0 S5)
ACPI: Using PIC for interrupt routing
ACPI: EC: GPE = 0x1c, I/O: command/status = 0x66, data = 0x62
ACPI: Power Resource [PUBS] (on)
ACPI: ACPI Dock Station Driver: 3 docks/bays found
PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
pci_root PNP0A03:00: host bridge window [mem 0x000d0000-0x000d3fff]
pci_root PNP0A03:00: host bridge window [mem 0x000d4000-0x000d7fff]
pci_root PNP0A03:00: host bridge window [mem 0x000d8000-0x000dbfff]
pci_root PNP0A03:00: host bridge window [mem 0x60000000-0xfebfffff]
pci 0000:00:02.0: reg 10: [mem 0xe0000000-0xe7ffffff pref]
pci 0000:00:02.0: reg 14: [mem 0xd0000000-0xd007ffff]
pci 0000:00:02.0: reg 18: [io  0x1800-0x1807]
pci 0000:00:02.0: supports D1
pci 0000:00:02.1: reg 10: [mem 0xe8000000-0xefffffff pref]
pci 0000:00:02.1: reg 14: [mem 0xd0080000-0xd00fffff]
pci 0000:00:02.1: supports D1
pci 0000:00:1d.0: reg 20: [io  0x1820-0x183f]
pci 0000:00:1d.1: reg 20: [io  0x1840-0x185f]
pci 0000:00:1d.2: reg 20: [io  0x1860-0x187f]
pci 0000:00:1d.7: reg 10: [mem 0xd0100000-0xd01003ff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1f.0: quirk: [io  0x1000-0x107f] claimed by ICH4 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: [io  0x1180-0x11bf] claimed by ICH4 GPIO
pci 0000:00:1f.1: reg 10: [io  0x0000-0x0007]
pci 0000:00:1f.1: reg 14: [io  0x0000-0x0003]
pci 0000:00:1f.1: reg 18: [io  0x0000-0x0007]
pci 0000:00:1f.1: reg 1c: [io  0x0000-0x0003]
pci 0000:00:1f.1: reg 20: [io  0x1810-0x181f]
pci 0000:00:1f.1: reg 24: [mem 0x00000000-0x000003ff]
pci 0000:00:1f.3: reg 20: [io  0x1880-0x189f]
pci 0000:00:1f.5: reg 10: [io  0x1c00-0x1cff]
pci 0000:00:1f.5: reg 14: [io  0x18c0-0x18ff]
pci 0000:00:1f.5: reg 18: [mem 0xd0100c00-0xd0100dff]
pci 0000:00:1f.5: reg 1c: [mem 0xd0100800-0xd01008ff]
pci 0000:00:1f.5: PME# supported from D0 D3hot D3cold
pci 0000:00:1f.5: PME# disabled
pci 0000:00:1f.6: reg 10: [io  0x2400-0x24ff]
pci 0000:00:1f.6: reg 14: [io  0x2000-0x207f]
pci 0000:00:1f.6: PME# supported from D0 D3hot D3cold
pci 0000:00:1f.6: PME# disabled
pci 0000:02:00.0: reg 10: [mem 0xb0000000-0xb0000fff]
pci 0000:02:00.0: supports D1 D2
pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:02:00.0: PME# disabled
pci 0000:02:08.0: reg 10: [mem 0xd0200000-0xd0200fff]
pci 0000:02:08.0: reg 14: [io  0x7000-0x703f]
pci 0000:02:08.0: supports D1 D2
pci 0000:02:08.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:02:08.0: PME# disabled
pci 0000:00:1e.0: PCI bridge to [bus 02-05] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0x3000-0x7fff]
pci 0000:00:1e.0:   bridge window [mem 0xd0200000-0xdfffffff]
pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xf7ffffff pref]
pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x000d0000-0x000d3fff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x60000000-0xfebfffff] (subtractive decode)
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
SCSI subsystem initialized
PCI: Using ACPI for IRQ routing
PCI: pci_cache_line_size set to 64 bytes
reserve RAM buffer: 000000000009f000 - 000000000009ffff 
reserve RAM buffer: 000000005f6e0000 - 000000005fffffff 
Switching to clocksource tsc
pnp: PnP ACPI init
ACPI: bus type pnp registered
ERROR: Unable to locate IOAPIC for GSI 13
ERROR: Unable to locate IOAPIC for GSI 8
ERROR: Unable to locate IOAPIC for GSI 1
ERROR: Unable to locate IOAPIC for GSI 12
ERROR: Unable to locate IOAPIC for GSI 6
pnp: PnP ACPI: found 12 devices
ACPI: ACPI bus type pnp unregistered
PnPBIOS: Disabled by ACPI PNP
system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
system 00:00: [mem 0x000c0000-0x000c3fff] could not be reserved
system 00:00: [mem 0x000c4000-0x000c7fff] could not be reserved
system 00:00: [mem 0x000c8000-0x000cbfff] has been reserved
system 00:00: [mem 0x000cc000-0x000cffff] could not be reserved
system 00:00: [mem 0x000dc000-0x000dffff] could not be reserved
system 00:00: [mem 0x000e0000-0x000e3fff] could not be reserved
system 00:00: [mem 0x000e4000-0x000e7fff] could not be reserved
system 00:00: [mem 0x000e8000-0x000ebfff] could not be reserved
system 00:00: [mem 0x000ec000-0x000effff] could not be reserved
system 00:00: [mem 0x000f0000-0x000fffff] could not be reserved
system 00:00: [mem 0x00100000-0x5fffffff] could not be reserved
system 00:00: [mem 0xfec00000-0xffffffff] could not be reserved
system 00:02: [io  0x1000-0x107f] has been reserved
system 00:02: [io  0x1180-0x11bf] has been reserved
system 00:02: [io  0x15e0-0x15ef] has been reserved
system 00:02: [io  0x1600-0x167f] has been reserved
pci 0000:00:1f.1: BAR 5: assigned [mem 0x60000000-0x600003ff]
pci 0000:00:1f.1: BAR 5: set to [mem 0x60000000-0x600003ff] (PCI address [0x60000000-0x600003ff]
pci 0000:02:00.0: BAR 9: assigned [mem 0xf0000000-0xf3ffffff pref]
pci 0000:02:00.0: BAR 10: assigned [mem 0xd4000000-0xd7ffffff]
pci 0000:02:00.0: BAR 7: assigned [io  0x3000-0x30ff]
pci 0000:02:00.0: BAR 8: assigned [io  0x3400-0x34ff]
pci 0000:02:00.0: CardBus bridge to [bus 03-04]
pci 0000:02:00.0:   bridge window [io  0x3000-0x30ff]
pci 0000:02:00.0:   bridge window [io  0x3400-0x34ff]
pci 0000:02:00.0:   bridge window [mem 0xf0000000-0xf3ffffff pref]
pci 0000:02:00.0:   bridge window [mem 0xd4000000-0xd7ffffff]
pci 0000:00:1e.0: PCI bridge to [bus 02-05]
pci 0000:00:1e.0:   bridge window [io  0x3000-0x7fff]
pci 0000:00:1e.0:   bridge window [mem 0xd0200000-0xdfffffff]
pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xf7ffffff pref]
pci 0000:00:1e.0: setting latency timer to 64
ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
PCI: setting IRQ 11 as level-triggered
pci 0000:02:00.0: PCI INT A -> Link[LNKA] -> GSI 11 (level, low) -> IRQ 11
pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000d3fff]
pci_bus 0000:00: resource 8 [mem 0x000d4000-0x000d7fff]
pci_bus 0000:00: resource 9 [mem 0x000d8000-0x000dbfff]
pci_bus 0000:00: resource 10 [mem 0x60000000-0xfebfffff]
pci_bus 0000:02: resource 0 [io  0x3000-0x7fff]
pci_bus 0000:02: resource 1 [mem 0xd0200000-0xdfffffff]
pci_bus 0000:02: resource 2 [mem 0xf0000000-0xf7ffffff pref]
pci_bus 0000:02: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:02: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:02: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:02: resource 7 [mem 0x000d0000-0x000d3fff]
pci_bus 0000:02: resource 8 [mem 0x000d4000-0x000d7fff]
pci_bus 0000:02: resource 9 [mem 0x000d8000-0x000dbfff]
pci_bus 0000:02: resource 10 [mem 0x60000000-0xfebfffff]
pci_bus 0000:03: resource 0 [io  0x3000-0x30ff]
pci_bus 0000:03: resource 1 [io  0x3400-0x34ff]
pci_bus 0000:03: resource 2 [mem 0xf0000000-0xf3ffffff pref]
pci_bus 0000:03: resource 3 [mem 0xd4000000-0xd7ffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 6, 262144 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
UDP hash table entries: 512 (order: 1, 8192 bytes)
UDP-Lite hash table entries: 512 (order: 1, 8192 bytes)
pci 0000:00:02.0: Boot video device
pci 0000:02:08.0: Firmware left e100 interrupts enabled; disabling
PCI: CLS 32 bytes, default 64
Simple Boot Flag at 0x35 set to 0x1
Scanning for low memory corruption every 60 seconds
highmem bounce pool size: 64 pages
msgmni has been set to 1741
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
io scheduler noop registered
io scheduler cfq registered (default)
input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input0
ACPI: Lid Switch [LID]
input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input1
ACPI: Sleep Button [SLPB]
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
ACPI: Power Button [PWRF]
input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A03:00/LNXVIDEO:00/input/input3
ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Linux agpgart interface v0.103
agpgart-intel 0000:00:00.0: Intel 855GM Chipset
agpgart-intel 0000:00:00.0: detected 8060K stolen memory
agpgart-intel 0000:00:00.0: AGP aperture is 128M @ 0xe0000000
[drm] Initialized drm 1.1.0 20060810
i915 0000:00:02.0: power state changed by ACPI to D0
i915 0000:00:02.0: power state changed by ACPI to D0
i915 0000:00:02.0: PCI INT A -> Link[LNKA] -> GSI 11 (level, low) -> IRQ 11
i915 0000:00:02.0: setting latency timer to 64
[drm] set up 7M of stolen space
[drm] initialized overlay support
fbcon: inteldrmfb (fb0) is primary device
Console: switching to colour frame buffer device 128x48
fb0: inteldrmfb frame buffer device
drm: registered panic notifier
Slow work thread pool: Starting up
Slow work thread pool: Ready
[drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
brd: module loaded
Uniform Multi-Platform E-IDE driver
piix 0000:00:1f.1: IDE controller (0x8086:0x24ca rev 0x01)
PIIX_IDE 0000:00:1f.1: enabling device (0005 -> 0007)
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
PIIX_IDE 0000:00:1f.1: PCI INT A -> Link[LNKC] -> GSI 11 (level, low) -> IRQ 11
piix 0000:00:1f.1: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0x1810-0x1817
    ide1: BM-DMA at 0x1818-0x181f
Probing IDE interface ide0...
hda: ST9160821A, ATA DISK drive
hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hda: UDMA/100 mode selected
Probing IDE interface ide1...
hdc: DW-225, ATAPI CD/DVD-ROM drive
hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hdc: UDMA/33 mode selected
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide1 at 0x170-0x177,0x376 on irq 15
ide-gd driver 1.18
hda: max request size: 512KiB
hda: 312581808 sectors (160041 MB) w/8192KiB Cache, CHS=19457/255/63
hda: cache flushes supported
 hda: hda1 hda2 hda3 < hda5 hda6 hda7 hda8 hda9 hda10 >
PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
cpuidle: using governor ladder
cpuidle: using governor menu
TCP cubic registered
Using IPI Shortcut mode
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
EXT4-fs (hda7): mounted filesystem with ordered data mode. Opts: (null)
VFS: Mounted root (ext4 filesystem) readonly on device 3:7.
Freeing unused kernel memory: 276k freed
NET: Registered protocol family 1
ACPI: acpi_idle registered with cpuidle
Marking TSC unstable due to TSC halts in idle
Switching to clocksource acpi_pm
udev: starting version 142
ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 11
i801_smbus 0000:00:1f.3: PCI INT B -> Link[LNKB] -> GSI 11 (level, low) -> IRQ 11
intel_rng: FWH not detected
thermal LNXTHERM:01: registered as thermal_zone0
ACPI: Thermal Zone [THM0] (39 C)
e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
ACPI: PCI Interrupt Link [LNKE] enabled at IRQ 11
e100 0000:02:08.0: PCI INT A -> Link[LNKE] -> GSI 11 (level, low) -> IRQ 11
e100 0000:02:08.0: PME# disabled
Non-volatile memory driver v1.3
Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
Floppy drive(s): fd0 is 1.44M
ACPI: AC Adapter [AC] (on-line)
ide-cd driver 5.00
FDC 0 is a National Semiconductor PC87306
ide-cd: hdc: ATAPI 24X DVD-ROM CD-R/RW drive, 1654kB Cache
Uniform CD-ROM driver Revision: 3.20
serial 00:0a: activated
00:0a: ttyS0 at I/O 0x3f8 (irq = 4) is a NS16550A
ACPI: Battery Slot [BAT0] (battery present)
rtc_cmos 00:06: RTC can wake from S4
rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, y3k, 114 bytes nvram
Intel ICH 0000:00:1f.5: PCI INT B -> Link[LNKB] -> GSI 11 (level, low) -> IRQ 11
Intel ICH 0000:00:1f.5: setting latency timer to 64
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
thinkpad_acpi: ThinkPad ACPI Extras v0.24
thinkpad_acpi: http://ibm-acpi.sf.net/
thinkpad_acpi: ThinkPad BIOS 1VET71WW (1.29 ), EC 1VHT28WW-1.04
thinkpad_acpi: IBM ThinkPad R51, model 2889SG1
usbcore: registered new device driver usb
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
thinkpad_acpi: detected a 8-level brightness capable ThinkPad
Registered led device: tpacpi::thinklight
Registered led device: tpacpi::power
Registered led device: tpacpi::standby
e100 0000:02:08.0: eth0: addr 0xd0200000, irq 11, MAC addr 00:11:25:ae:9d:9e
yenta_cardbus 0000:02:00.0: CardBus bridge found [1014:0512]
yenta_cardbus 0000:02:00.0: Using INTVAL to route CSC interrupts to PCI
yenta_cardbus 0000:02:00.0: Routing CardBus interrupts to PCI
yenta_cardbus 0000:02:00.0: TI: mfunc 0x01d21022, devctl 0x64
thinkpad_acpi: brightness: will use unverified default: brightness_mode=3
thinkpad_acpi: brightness: please report to ibm-acpi-devel@lists.sourceforge.net whether it works well or not on your ThinkPad
thinkpad_acpi: Console audio control enabled, mode: monitor (read only)
input: ThinkPad Extra Buttons as /devices/platform/thinkpad_acpi/input/input5
Synaptics Touchpad, model: 1, fw: 5.9, id: 0x2c6ab1, caps: 0x884793/0x0/0x0
serio: Synaptics pass-through port at isa0060/serio1/input0
yenta_cardbus 0000:02:00.0: ISA IRQ mask 0x04b8, PCI irq 11
yenta_cardbus 0000:02:00.0: Socket status: 30000020
yenta_cardbus 0000:02:00.0: pcmcia: parent PCI bridge window: [io  0x3000-0x7fff]
pcmcia_socket pcmcia_socket0: cs: IO port probe 0x3000-0x7fff: excluding 0x3000-0x30ff 0x3400-0x34ff
input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input6
 0x7000-0x703f
yenta_cardbus 0000:02:00.0: pcmcia: parent PCI bridge window: [mem 0xd0200000-0xdfffffff]
pcmcia_socket pcmcia_socket0: cs: memory probe 0xd0200000-0xdfffffff: excluding 0xd0200000-0xd09fffff 0xd3a00000-0xd81fffff 0xdfa00000-0xe01fffff
yenta_cardbus 0000:02:00.0: pcmcia: parent PCI bridge window: [mem 0xf0000000-0xf7ffffff pref]
pcmcia_socket pcmcia_socket0: cs: memory probe 0xf0000000-0xf7ffffff: excluding 0xf0000000-0xf7ffffff
intel8x0_measure_ac97_clock: measured 52741 usecs (2541 samples)
intel8x0: clocking to 48000
serial 0000:00:1f.6: PCI INT B -> Link[LNKB] -> GSI 11 (level, low) -> IRQ 11
serial 0000:00:1f.6: PCI INT B disabled
ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
ACPI: PCI Interrupt Link [LNKH] enabled at IRQ 11
ehci_hcd 0000:00:1d.7: PCI INT D -> Link[LNKH] -> GSI 11 (level, low) -> IRQ 11
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1d.7: irq 11, io mem 0xd0100000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.35-rc4 ehci_hcd
usb usb1: SerialNumber: 0000:00:1d.7
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 6 ports detected
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
uhci_hcd 0000:00:1d.0: PCI INT A -> Link[LNKA] -> GSI 11 (level, low) -> IRQ 11
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: irq 11, io base 0x00001820
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: UHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.35-rc4 uhci_hcd
usb usb2: SerialNumber: 0000:00:1d.0
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.1: power state changed by ACPI to D0
uhci_hcd 0000:00:1d.1: power state changed by ACPI to D0
ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
uhci_hcd 0000:00:1d.1: PCI INT B -> Link[LNKD] -> GSI 11 (level, low) -> IRQ 11
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: irq 11, io base 0x00001840
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.35-rc4 uhci_hcd
usb usb3: SerialNumber: 0000:00:1d.1
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.2: PCI INT C -> Link[LNKC] -> GSI 11 (level, low) -> IRQ 11
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: irq 11, io base 0x00001860
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.35-rc4 uhci_hcd
usb usb4: SerialNumber: 0000:00:1d.2
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
Adding 2097144k swap on /dev/hda6.  Priority:1 extents:1 across:2097144k 
EXT4-fs (hda7): re-mounted. Opts: (null)
usb 1-1: new high speed USB device using ehci_hcd and address 2
usb 1-1: New USB device found, idVendor=04b3, idProduct=4482
usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
hub 1-1:1.0: USB hub found
hub 1-1:1.0: 4 ports detected
pcmcia_socket pcmcia_socket0: pccard: CardBus card inserted into slot 0
pci 0000:03:00.0: reg 10: [mem 0xd0000000-0xd000ffff]
pci 0000:03:00.0: reg 14: [mem 0xc0000000-0xc000ffff]
pci 0000:03:00.0: BAR 0: assigned [mem 0xd4000000-0xd400ffff]
pci 0000:03:00.0: BAR 0: set to [mem 0xd4000000-0xd400ffff] (PCI address [0xd4000000-0xd400ffff]
pci 0000:03:00.0: BAR 1: assigned [mem 0xd4010000-0xd401ffff]
pci 0000:03:00.0: BAR 1: set to [mem 0xd4010000-0xd401ffff] (PCI address [0xd4010000-0xd401ffff]
usb 1-1.4: new high speed USB device using ehci_hcd and address 3
EXT4-fs (hda7): re-mounted. Opts: (null)
usb 1-1.4: New USB device found, idVendor=05e3, idProduct=0608
usb 1-1.4: New USB device strings: Mfr=0, Product=1, SerialNumber=0
usb 1-1.4: Product: USB2.0 Hub
hub 1-1.4:1.0: USB hub found
hub 1-1.4:1.0: 4 ports detected
EXT4-fs (hda1): mounted filesystem with ordered data mode. Opts: (null)
EXT4-fs (hda8): mounted filesystem with ordered data mode. Opts: (null)
EXT4-fs (hda9): mounted filesystem with ordered data mode. Opts: (null)
EXT4-fs (hda10): mounted filesystem with ordered data mode. Opts: (null)
usb 1-1.4.2: new low speed USB device using ehci_hcd and address 4
usb 1-1.4.2: New USB device found, idVendor=046d, idProduct=c018
usb 1-1.4.2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 1-1.4.2: Product: Logitech USB Optical Mouse
usb 1-1.4.2: Manufacturer: Logitech
input: Logitech Logitech USB Optical Mouse as /devices/pci0000:00/0000:00:1d.7/usb1/1-1/1-1.4/1-1.4.2/1-1.4.2:1.0/input/input7
generic-usb 0003:046D:C018.0001: input: USB HID v1.11 Mouse [Logitech Logitech USB Optical Mouse] on usb-0000:00:1d.7-1.4.2/input0
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
usb 1-1.4.3: new low speed USB device using ehci_hcd and address 5
usb 1-1.4.3: New USB device found, idVendor=06f2, idProduct=0011
usb 1-1.4.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 1-1.4.3: Product: USB KVM Switch
usb 1-1.4.3: Manufacturer: Justcom Technology
input: Justcom Technology USB KVM Switch as /devices/pci0000:00/0000:00:1d.7/usb1/1-1/1-1.4/1-1.4.3/1-1.4.3:1.0/input/input8
generic-usb 0003:06F2:0011.0002: input: USB HID v1.10 Keyboard [Justcom Technology USB KVM Switch] on usb-0000:00:1d.7-1.4.3/input0
input: Justcom Technology USB KVM Switch as /devices/pci0000:00/0000:00:1d.7/usb1/1-1/1-1.4/1-1.4.3/1-1.4.3:1.1/input/input9
generic-usb 0003:06F2:0011.0003: input: USB HID v1.10 Mouse [Justcom Technology USB KVM Switch] on usb-0000:00:1d.7-1.4.3/input1
usb 1-1.4.4: new high speed USB device using ehci_hcd and address 6
usb 1-1.4.4: New USB device found, idVendor=05e3, idProduct=0608
usb 1-1.4.4: New USB device strings: Mfr=0, Product=1, SerialNumber=0
usb 1-1.4.4: Product: USB2.0 Hub
hub 1-1.4.4:1.0: USB hub found
hub 1-1.4.4:1.0: 4 ports detected
usb 1-1.4.4.4: new high speed USB device using ehci_hcd and address 7
usb 1-1.4.4.4: New USB device found, idVendor=0424, idProduct=2504
usb 1-1.4.4.4: New USB device strings: Mfr=0, Product=0, SerialNumber=0
hub 1-1.4.4.4:1.0: USB hub found
hub 1-1.4.4.4:1.0: 4 ports detected
microcode: CPU0 sig=0x6d6, pf=0x20, revision=0x18
microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
IBM TrackPoint firmware: 0x0e, buttons: 3/3
input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/serio2/input/input10
e100 0000:02:08.0: eth0: NIC Link is Up 100 Mbps Full Duplex
Disabling lock debugging due to kernel taint
ndiswrapper version 1.56 loaded (smp=no, preempt=no)
ndiswrapper: driver wg511v2 (NETGEAR,02/22/2005,3.1.1.7) loaded
ndiswrapper 0000:03:00.0: enabling device (0000 -> 0002)
ndiswrapper 0000:03:00.0: PCI INT A -> Link[LNKA] -> GSI 11 (level, low) -> IRQ 11
ndiswrapper 0000:03:00.0: setting latency timer to 64
ndiswrapper: using IRQ 11
wlan0: ethernet device 00:1e:2a:b4:00:dd using NDIS driver: wg511v2, version: 0x3000036, NDIS version: 0x501, vendor: 'NDIS Network Adapter', 11AB:1FAA.5.conf
wlan0: encryption modes supported: WEP; TKIP with WPA, WPA2, WPA2PSK; AES/CCMP with WPA, WPA2, WPA2PSK
usbcore: registered new interface driver ndiswrapper
NET: Registered protocol family 17
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
usb 1-1.4.4: USB disconnect, address 6
usb 1-1.4.4.4: USB disconnect, address 7
usb 1-1.4.2: USB disconnect, address 4
usb 1-1.4.2: new low speed USB device using ehci_hcd and address 8
usb 1-1.4.2: New USB device found, idVendor=046d, idProduct=c018
usb 1-1.4.2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 1-1.4.2: Product: Logitech USB Optical Mouse
usb 1-1.4.2: Manufacturer: Logitech
input: Logitech Logitech USB Optical Mouse as /devices/pci0000:00/0000:00:1d.7/usb1/1-1/1-1.4/1-1.4.2/1-1.4.2:1.0/input/input11
generic-usb 0003:046D:C018.0004: input: USB HID v1.11 Mouse [Logitech Logitech USB Optical Mouse] on usb-0000:00:1d.7-1.4.2/input0
usb 1-1.4.4: new high speed USB device using ehci_hcd and address 9
usb 1-1.4.4: New USB device found, idVendor=05e3, idProduct=0608
usb 1-1.4.4: New USB device strings: Mfr=0, Product=1, SerialNumber=0
usb 1-1.4.4: Product: USB2.0 Hub
hub 1-1.4.4:1.0: USB hub found
hub 1-1.4.4:1.0: 4 ports detected
usb 1-1.4.4.4: new high speed USB device using ehci_hcd and address 10
usb 1-1.4.4.4: New USB device found, idVendor=0424, idProduct=2504
usb 1-1.4.4.4: New USB device strings: Mfr=0, Product=0, SerialNumber=0
hub 1-1.4.4.4:1.0: USB hub found
hub 1-1.4.4.4:1.0: 4 ports detected
usb 1-1.4.4: USB disconnect, address 9
usb 1-1.4.4.4: USB disconnect, address 10
usb 1-1.4.2: USB disconnect, address 8
usb 1-1.4.2: new low speed USB device using ehci_hcd and address 11
usb 1-1.4.2: New USB device found, idVendor=046d, idProduct=c018
usb 1-1.4.2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 1-1.4.2: Product: Logitech USB Optical Mouse
usb 1-1.4.2: Manufacturer: Logitech
input: Logitech Logitech USB Optical Mouse as /devices/pci0000:00/0000:00:1d.7/usb1/1-1/1-1.4/1-1.4.2/1-1.4.2:1.0/input/input12
generic-usb 0003:046D:C018.0005: input: USB HID v1.11 Mouse [Logitech Logitech USB Optical Mouse] on usb-0000:00:1d.7-1.4.2/input0
usb 1-1.4.4: new high speed USB device using ehci_hcd and address 12
usb 1-1.4.4: New USB device found, idVendor=05e3, idProduct=0608
usb 1-1.4.4: New USB device strings: Mfr=0, Product=1, SerialNumber=0
usb 1-1.4.4: Product: USB2.0 Hub
hub 1-1.4.4:1.0: USB hub found
hub 1-1.4.4:1.0: 4 ports detected
usb 1-1.4.4.4: new high speed USB device using ehci_hcd and address 13
usb 1-1.4.4.4: New USB device found, idVendor=0424, idProduct=2504
usb 1-1.4.4.4: New USB device strings: Mfr=0, Product=0, SerialNumber=0
hub 1-1.4.4.4:1.0: USB hub found
hub 1-1.4.4.4:1.0: 4 ports detected

--------------060309080209060504070804--

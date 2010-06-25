Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932224Ab0FYSBG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 14:01:06 -0400
Received: from fep18.mx.upcmail.net ([62.179.121.38]:33449 "EHLO
	fep18.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124Ab0FYSBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 14:01:01 -0400
X-SourceIP: 77.57.188.152
Message-ID: <4C24EED2.4020300@odi.ch>
Date: Fri, 25 Jun 2010 20:00:50 +0200
From: =?ISO-8859-1?Q?Ortwin_Gl=FCck?= <odi@odi.ch>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: ata link not reset properly
References: <4C223F8A.9030306@odi.ch> <4C224429.6010705@kernel.org> <4C224502.2040206@kernel.org> <4C2305A8.4070708@odi.ch> <4C24C903.1070705@kernel.org>
In-Reply-To: <4C24C903.1070705@kernel.org>
X-Enigmail-Version: 1.1.1
Content-Type: multipart/mixed;
 boundary="------------060206010001020708030708"
X-Cloudmark-Analysis: v=1.1 cv=K3uBg944YaUT+Qsu6bWO0a0V3uPy4DQNslbdoMCD4tw= c=1 sm=0 a=mI6YO6ZdSLUA:10 a=HrRr-ctSOON7R7BZ2zkA:9 a=mAHUl_L5W6c8nLBhwG0A:7 a=s8fwVIWBnj-gR52q38mgGeusBn0A:4 a=wPNLvfGTeEIA:10 a=20KFwNOVAAAA:8 a=mpL0Cdj5O3gC8B4sBOgA:9 a=fkH3GJj3JwRieStynEIA:7 a=77axS_TqaEAAP90l3hwV5uVv4hUA:4 a=jEp0ucaQiEUA:10 a=Ze6ms1oJD0sKpCZt:21 a=YYrEhmExSVVjGCp4:21 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060206010001020708030708
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit



On 25.06.2010 17:19, Tejun Heo wrote:
> Patch attached, but please see below.

Cheers, I will give it a try and provide feedback if "it" happens again.

> Is it PATA?  

Yes. This chipset doesn't have SATA, only PATA.

CONFIG_ATA=y
CONFIG_ATA_SFF=y
CONFIG_SATA_NV=y
CONFIG_PATA_AMD=y

> Why do you have 2.01?

for the DVD drive?

> Can you please attach full boot
> log?

attached.

Thanks.
 Ortwin

--------------060206010001020708030708
Content-Type: text/plain;
 name="bootlog.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="bootlog.txt"

Linux version 2.6.32-gentoo-r7 (root@gollum.odi.ch) (gcc version 4.3.4 (Gentoo 4.3.4 p1.0, pie-10.1.5) ) #3 PREEMPT Tue May 11 09:11:24 CEST 2010
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  NSC Geode by NSC
  Cyrix CyrixInstead
  Centaur CentaurHauls
  Transmeta GenuineTMx86
  Transmeta TransmetaCPU
  UMC UMC UMC UMC
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 00000000000a0000 (usable)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000001fff0000 (usable)
 BIOS-e820: 000000001fff0000 - 000000001fff3000 (ACPI NVS)
 BIOS-e820: 000000001fff3000 - 0000000020000000 (ACPI data)
 BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
DMI 2.2 present.
last_pfn = 0x1fff0 max_arch_pfn = 0x100000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-C7FFF write-protect
  C8000-FFFFF uncachable
MTRR variable ranges enabled:
  0 base 000000000 mask FE0000000 write-back
  1 base 0E8000000 mask FFE000000 write-combining
  2 disabled
  3 disabled
  4 disabled
  5 disabled
  6 disabled
  7 disabled
initial memory mapped : 0 - 01c00000
init_memory_mapping: 0000000000000000-000000001fff0000
 0000000000 - 0000400000 page 4k
 0000400000 - 001fc00000 page 2M
 001fc00000 - 001fff0000 page 4k
kernel direct mapping tables up to 1fff0000 @ 7000-c000
ACPI: RSDP 000f6d80 00014 (v00 XPC   )
ACPI: RSDT 1fff3000 0002C (v01 XPC    AWRDACPI 42302E31 AWRD 00000000)
ACPI: FACP 1fff3040 00074 (v01 XPC    AWRDACPI 42302E31 AWRD 00000000)
ACPI: DSDT 1fff30c0 04137 (v01 XPC        SN45 00001000 MSFT 0100000E)
ACPI: FACS 1fff0000 00040
ACPI: APIC 1fff7200 0006E (v01 XPC    AWRDACPI 42302E31 AWRD 00000000)
ACPI: Local APIC address 0xfee00000
511MB LOWMEM available.
  mapped low ram: 0 - 1fff0000
  low ram: 0 - 1fff0000
  node 0 low ram: 00000000 - 1fff0000
  node 0 bootmap 00001000 - 00005000
(6 early reservations) ==> bootmem [0000000000 - 001fff0000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0001000000 - 0001699160]    TEXT DATA BSS ==> [0001000000 - 0001699160]
  #2 [000009f000 - 0000100000]    BIOS reserved ==> [000009f000 - 0000100000]
  #3 [000169a000 - 00016a109a]              BRK ==> [000169a000 - 00016a109a]
  #4 [0000007000 - 0000008000]          PGTABLE ==> [0000007000 - 0000008000]
  #5 [0000001000 - 0000005000]          BOOTMAP ==> [0000001000 - 0000005000]
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  Normal   0x00001000 -> 0x0001fff0
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000000 -> 0x000000a0
    0: 0x00000100 -> 0x0001fff0
On node 0 totalpages: 130960
free_area_init_node: node 0, pgdat c15e55a0, node_mem_map c16a2000
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 3968 pages, LIFO batch:0
  Normal zone: 992 pages used for memmap
  Normal zone: 125968 pages, LIFO batch:31
Using APIC driver default
Nvidia board detected. Ignoring ACPI timer override.
If you got timer trouble try acpi_use_timer_override
ACPI: PM-Timer IO Port: 0x4008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: BIOS IRQ0 pin2 override ignored.
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
ACPI: IRQ9 used by override.
ACPI: IRQ14 used by override.
ACPI: IRQ15 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Using ACPI (MADT) for SMP configuration information
nr_irqs_gsi: 24
Allocating PCI resources starting at 20000000 (gap: 20000000:dec00000)
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 129936
Kernel command line: root=/dev/md1 vga=3840
PID hash table entries: 2048 (order: 1, 8192 bytes)
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Enabling fast FPU save and restore... done.
Initializing CPU#0
Memory: 512372k/524224k available (4344k kernel code, 11296k reserved, 1727k data, 344k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xfffa4000 - 0xfffff000   ( 364 kB)
    vmalloc : 0xe07f0000 - 0xfffa2000   ( 503 MB)
    lowmem  : 0xc0000000 - 0xdfff0000   ( 511 MB)
      .init : 0xc15ef000 - 0xc1645000   ( 344 kB)
      .data : 0xc143e2b2 - 0xc15ee074   (1727 kB)
      .text : 0xc1000000 - 0xc143e2b2   (4344 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
SLUB: Genslabs=13, HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
Experimental preemptable hierarchical RCU implementation.
NR_IRQS:288
Console: colour VGA+ 80x25
console [tty0] enabled
Fast TSC calibration using PIT
Detected 1202.776 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 2405.55 BogoMIPS (lpj=12027760)
Mount-cache hash table entries: 512
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 256K (64 bytes/line)
mce: CPU supports 4 MCE banks
Performance Events: AMD PMU driver.
... version:                0
... bit width:              48
... generic registers:      4
... value mask:             0000ffffffffffff
... max period:             00007fffffffffff
... fixed-purpose events:   0
... event mask:             000000000000000f
CPU: AMD Athlon(tm) processor stepping 04
Checking 'hlt' instruction... OK.
ACPI: Core revision 20090903
..TIMER: vector=0x30 apic1=0 pin1=0 apic2=-1 pin2=-1
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfb790, last bus=3
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: No dock devices found.
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:00.0: reg 10 32bit mmio pref: [0xe8000000-0xe9ffffff]
pci 0000:00:01.1: reg 10 io port: [0xc000-0xc01f]
pci 0000:00:01.1: PME# supported from D3hot D3cold
pci 0000:00:01.1: PME# disabled
pci 0000:00:02.0: reg 10 32bit mmio: [0xef087000-0xef087fff]
pci 0000:00:02.0: supports D1 D2
pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:02.0: PME# disabled
pci 0000:00:02.1: reg 10 32bit mmio: [0xef082000-0xef082fff]
pci 0000:00:02.1: supports D1 D2
pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:02.1: PME# disabled
pci 0000:00:02.2: reg 10 32bit mmio: [0xef083000-0xef0830ff]
pci 0000:00:02.2: supports D1 D2
pci 0000:00:02.2: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:02.2: PME# disabled
pci 0000:00:04.0: reg 10 32bit mmio: [0xef086000-0xef086fff]
pci 0000:00:04.0: reg 14 io port: [0xc400-0xc407]
pci 0000:00:04.0: supports D1 D2
pci 0000:00:04.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:04.0: PME# disabled
pci 0000:00:05.0: reg 10 32bit mmio: [0xef000000-0xef07ffff]
pci 0000:00:05.0: supports D1 D2
pci 0000:00:06.0: reg 10 io port: [0xb000-0xb0ff]
pci 0000:00:06.0: reg 14 io port: [0xb400-0xb47f]
pci 0000:00:06.0: reg 18 32bit mmio: [0xef080000-0xef080fff]
pci 0000:00:06.0: supports D1 D2
pci 0000:00:09.0: reg 20 io port: [0xf000-0xf00f]
pci 0000:00:0d.0: reg 10 32bit mmio: [0xef084000-0xef0847ff]
pci 0000:00:0d.0: reg 14 32bit mmio: [0xef085000-0xef08503f]
pci 0000:00:0d.0: supports D1 D2
pci 0000:00:0d.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0d.0: PME# disabled
pci 0000:01:06.0: reg 10 io port: [0x9000-0x90ff]
pci 0000:01:06.0: reg 14 32bit mmio: [0xee000000-0xee0000ff]
pci 0000:01:06.0: supports D1 D2
pci 0000:01:06.0: PME# supported from D1 D2 D3hot
pci 0000:01:06.0: PME# disabled
pci 0000:00:08.0: bridge io port: [0x9000-0x9fff]
pci 0000:00:08.0: bridge 32bit mmio: [0xee000000-0xeeffffff]
pci 0000:03:00.0: reg 10 32bit mmio: [0xec000000-0xecffffff]
pci 0000:03:00.0: reg 14 32bit mmio pref: [0xe0000000-0xe7ffffff]
pci 0000:03:00.0: reg 30 32bit mmio pref: [0x000000-0x00ffff]
pci 0000:00:1e.0: bridge 32bit mmio: [0xec000000-0xedffffff]
pci 0000:00:1e.0: bridge 32bit mmio pref: [0xe0000000-0xe7ffffff]
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGPB._PRT]
ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK2] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK3] (IRQs 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNK4] (IRQs 3 4 5 6 7 10 11 *12 14 15)
ACPI: PCI Interrupt Link [LNK5] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LUBA] (IRQs 3 4 *5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LUBB] (IRQs 3 4 5 6 7 10 11 *12 14 15)
ACPI: PCI Interrupt Link [LMAC] (IRQs 3 4 5 6 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LAPU] (IRQs *3 4 5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LACI] (IRQs 3 4 *5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LMCI] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LSMB] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LUB2] (IRQs 3 4 5 6 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LFIR] (IRQs 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [L3CM] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LIDE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [APC1] (IRQs *16), disabled.
ACPI: PCI Interrupt Link [APC2] (IRQs *17), disabled.
ACPI: PCI Interrupt Link [APC3] (IRQs *18)
ACPI: PCI Interrupt Link [APC4] (IRQs *19)
ACPI: PCI Interrupt Link [APC5] (IRQs *16), disabled.
ACPI: PCI Interrupt Link [APCF] (IRQs 20 21 22) *0
ACPI: PCI Interrupt Link [APCG] (IRQs 20 21 22) *0
ACPI: PCI Interrupt Link [APCH] (IRQs 20 21 22) *0
ACPI: PCI Interrupt Link [APCI] (IRQs 20 21 22) *0
ACPI: PCI Interrupt Link [APCJ] (IRQs 20 21 22) *0
ACPI: PCI Interrupt Link [APCK] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [APCS] (IRQs *23), disabled.
ACPI: PCI Interrupt Link [APCL] (IRQs 20 21 22) *0
ACPI: PCI Interrupt Link [APCM] (IRQs 20 21 22) *0
ACPI: PCI Interrupt Link [AP3C] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [APCZ] (IRQs 20 21 22) *0, disabled.
vgaarb: device added: PCI:0000:03:00.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
Switching to clocksource tsc
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 11 devices
ACPI: ACPI bus type pnp unregistered
system 00:00: ioport range 0x4000-0x407f has been reserved
system 00:00: ioport range 0x4080-0x40ff has been reserved
system 00:00: ioport range 0x4400-0x447f has been reserved
system 00:00: ioport range 0x4480-0x44ff has been reserved
system 00:00: ioport range 0x4200-0x427f has been reserved
system 00:00: ioport range 0x4280-0x42ff has been reserved
system 00:01: ioport range 0x5000-0x503f has been reserved
system 00:01: ioport range 0x5100-0x513f has been reserved
system 00:02: iomem range 0xd1800-0xd3fff has been reserved
system 00:02: iomem range 0xf0000-0xf7fff could not be reserved
system 00:02: iomem range 0xf8000-0xfbfff could not be reserved
system 00:02: iomem range 0xfc000-0xfffff could not be reserved
system 00:02: iomem range 0x1fff0000-0x1fffffff could not be reserved
system 00:02: iomem range 0xffff0000-0xffffffff has been reserved
system 00:02: iomem range 0x0-0x9ffff could not be reserved
system 00:02: iomem range 0x100000-0x1ffeffff could not be reserved
system 00:02: iomem range 0xfec00000-0xfec00fff could not be reserved
system 00:02: iomem range 0xfee00000-0xfee00fff has been reserved
system 00:04: ioport range 0x4d0-0x4d1 has been reserved
system 00:04: ioport range 0x800-0x805 has been reserved
system 00:04: ioport range 0x290-0x297 has been reserved
pci 0000:00:08.0: PCI bridge, secondary bus 0000:01
pci 0000:00:08.0:   IO window: 0x9000-0x9fff
pci 0000:00:08.0:   MEM window: 0xee000000-0xeeffffff
pci 0000:00:08.0:   PREFETCH window: disabled
pci 0000:00:1e.0: PCI bridge, secondary bus 0000:03
pci 0000:00:1e.0:   IO window: disabled
pci 0000:00:1e.0:   MEM window: 0xec000000-0xedffffff
pci 0000:00:1e.0:   PREFETCH window: 0xe0000000-0xe7ffffff
pci 0000:00:08.0: setting latency timer to 64
pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
pci_bus 0000:01: resource 0 io:  [0x9000-0x9fff]
pci_bus 0000:01: resource 1 mem: [0xee000000-0xeeffffff]
pci_bus 0000:03: resource 1 mem: [0xec000000-0xedffffff]
pci_bus 0000:03: resource 2 pref mem [0xe0000000-0xe7ffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
TCP established hash table entries: 16384 (order: 5, 131072 bytes)
TCP bind hash table entries: 16384 (order: 4, 65536 bytes)
TCP: Hash tables configured (established 16384 bind 16384)
TCP reno registered
NET: Registered protocol family 1
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
pci 0000:03:00.0: Boot video device
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
Slow work thread pool: Starting up
Slow work thread pool: Ready
fuse init (API version 7.13)
msgmni has been set to 1001
alg: No test for stdrng (krng)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
lp: driver loaded but no devices found
Non-volatile memory driver v1.3
Linux agpgart interface v0.103
agpgart: Detected NVIDIA nForce2 chipset
agpgart-nvidia 0000:00:00.0: AGP aperture is 32M @ 0xe8000000
ACPI: PCI Interrupt Link [APC4] enabled at IRQ 19
nvidiafb 0000:03:00.0: PCI INT A -> Link[APC4] -> GSI 19 (level, high) -> IRQ 19
nvidiafb: Device ID: 10de0110 
i2c i2c-0: unable to read EDID block.
i2c i2c-0: unable to read EDID block.
i2c i2c-0: unable to read EDID block.
i2c i2c-1: unable to read EDID block.
i2c i2c-1: unable to read EDID block.
i2c i2c-1: unable to read EDID block.
nvidiafb: Unable to detect display type...
...Using default of CRT
nvidiafb: Unable to detect which CRTCNumber...
...Defaulting to CRTCNumber 0
nvidiafb: Using CRT on CRTC 0
nvidiafb: MTRR set to ON
Console: switching to colour frame buffer device 80x30
nvidiafb: PCI nVidia NV11 framebuffer (64MB @ 0xE0000000)
input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
ACPI: Power Button [PWRB]
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
ACPI: Power Button [PWRF]
fan PNP0C0B:00: registered as cooling_device0
ACPI: Fan [FAN] (on)
processor LNXCPU:00: registered as cooling_device1
thermal LNXTHERM:01: registered as thermal_zone0
ACPI: Thermal Zone [THRM] (39 C)
Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
parport_pc 00:0a: reported by Plug and Play ACPI
parport0: PC-style at 0x378 (0x778), irq 7 [PCSPP,TRISTATE]
parport0: Printer, Hewlett-Packard HP LaserJet 1100
lp0: using parport0 (interrupt-driven).
brd: module loaded
loop: module loaded
pata_amd 0000:00:09.0: version 0.4.1
pata_amd 0000:00:09.0: setting latency timer to 64
scsi0 : pata_amd
scsi1 : pata_amd
ata1: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xf000 irq 14
ata2: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xf008 irq 15
forcedeth: Reverse Engineered nForce ethernet driver. Version 0.64.
ACPI: PCI Interrupt Link [APCH] enabled at IRQ 22
forcedeth 0000:00:04.0: PCI INT A -> Link[APCH] -> GSI 22 (level, high) -> IRQ 22
forcedeth 0000:00:04.0: setting latency timer to 64
nv_probe: set workaround bit for reversed mac addr
ata1.00: ATA-5: MAXTOR 6L020J1, A93.0500, max UDMA/133
ata1.00: 40132503 sectors, multi 16: LBA 
ata1: nv_mode_filter: 0x7f39f&0x7f39f->0x7f39f, BIOS=0x7f000 (0xc700c6c0) ACPI=0x7f01f (15:600:0x13)
ata1.00: configured for UDMA/133
scsi 0:0:0:0: Direct-Access     ATA      MAXTOR 6L020J1   A93. PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 40132503 512-byte logical blocks: (20.5 GB/19.1 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: Attached scsi generic sg0 type 0
 sda: sda1 sda2 sda3
sd 0:0:0:0: [sda] Attached SCSI disk
ata2.00: ATA-5: IC25N030ATCS04-0, CA3OA71A, max UDMA/100
ata2.00: 58605120 sectors, multi 16: LBA 
ata2.01: ATAPI: Pioneer DVD-ROM ATAPIModel DVD-115  0127, E1.27, max UDMA/33
ata2: nv_mode_filter: 0x3f39f&0x3f39f->0x3f39f, BIOS=0x3f000 (0xc700c6c0) ACPI=0x3f01f (20:60:0x1f)
ata2: nv_mode_filter: 0x739f&0x739f->0x739f, BIOS=0x7000 (0xc700c6c0) ACPI=0x701f (20:60:0x1f)
ata2.00: configured for UDMA/100
ata2.01: configured for UDMA/33
scsi 1:0:0:0: Direct-Access     ATA      IC25N030ATCS04-0 CA3O PQ: 0 ANSI: 5
sd 1:0:0:0: [sdb] 58605120 512-byte logical blocks: (30.0 GB/27.9 GiB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb:
sd 1:0:0:0: Attached scsi generic sg1 type 0
forcedeth 0000:00:04.0: ifname eth0, PHY OUI 0x732 @ 1, addr 00:30:1b:b3:da:f5
forcedeth 0000:00:04.0: timirq lnktim desc-v1
8139too Fast Ethernet driver 0.9.28
ACPI: PCI Interrupt Link [APC3] enabled at IRQ 18
8139too 0000:01:06.0: PCI INT A -> Link[APC3] -> GSI 18 (level, high) -> IRQ 18
eth1: RealTek RTL8139 at 0xe0864000, 00:30:4f:19:09:35, IRQ 18
ACPI: PCI Interrupt Link [APCM] enabled at IRQ 21
ohci1394 0000:00:0d.0: PCI INT A -> Link[APCM] -> GSI 21 (level, high) -> IRQ 21
ohci1394 0000:00:0d.0: setting latency timer to 64
ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[21]  MMIO=[ef084000-ef0847ff]  Max Packet=[2048]  IR/IT contexts=[4/4]
ieee1394: raw1394: /dev/raw1394 device initialized
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ACPI: PCI Interrupt Link [APCL] enabled at IRQ 20
ehci_hcd 0000:00:02.2: PCI INT C -> Link[APCL] -> GSI 20 (level, high) -> IRQ 20
ehci_hcd 0000:00:02.2: setting latency timer to 64
ehci_hcd 0000:00:02.2: EHCI Host Controller
ehci_hcd 0000:00:02.2: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:02.2: debug port 1
ehci_hcd 0000:00:02.2: cache line size of 64 is not supported
ehci_hcd 0000:00:02.2: irq 20, io mem 0xef083000
ehci_hcd 0000:00:02.2: USB 2.0 started, EHCI 1.00
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.32-gentoo-r7 ehci_hcd
usb usb1: SerialNumber: 0000:00:02.2
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 6 ports detected
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt Link [APCF] enabled at IRQ 22
ohci_hcd 0000:00:02.0: PCI INT A -> Link[APCF] -> GSI 22 (level, high) -> IRQ 22
ohci_hcd 0000:00:02.0: setting latency timer to 64
ohci_hcd 0000:00:02.0: OHCI Host Controller
ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:02.0: irq 22, io mem 0xef087000
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: OHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.32-gentoo-r7 ohci_hcd
usb usb2: SerialNumber: 0000:00:02.0
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 3 ports detected
ACPI: PCI Interrupt Link [APCG] enabled at IRQ 21
ohci_hcd 0000:00:02.1: PCI INT B -> Link[APCG] -> GSI 21 (level, high) -> IRQ 21
ohci_hcd 0000:00:02.1: setting latency timer to 64
ohci_hcd 0000:00:02.1: OHCI Host Controller
ohci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 3
ohci_hcd 0000:00:02.1: irq 21, io mem 0xef082000
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: OHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.32-gentoo-r7 ohci_hcd
usb usb3: SerialNumber: 0000:00:02.1
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 3 ports detected
usbcore: registered new interface driver usblp
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
PNP: No PS/2 controller found. Probing ports directly.
 sdb1 sdb2 sdb3
scsi 1:0:1:0: CD-ROM            PIONEER  DVD-ROM DVD-115F 1.27 PQ: 0 ANSI: 5
sd 1:0:0:0: [sdb] Attached SCSI disk
sr0: scsi3-mmc drive: 16x/40x cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 1:0:1:0: Attached scsi CD-ROM sr0
sr 1:0:1:0: Attached scsi generic sg2 type 5
serio: i8042 KBD port at 0x60,0x64 irq 1
mice: PS/2 mouse device common for all mice
rtc_cmos 00:06: RTC can wake from S4
rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one year, y3k, 242 bytes nvram
i2c /dev entries driver
i2c i2c-3: nForce2 SMBus adapter at 0x5000
i2c i2c-4: nForce2 SMBus adapter at 0x5100
it87: Found IT8712F chip at 0x290, revision 5
ACPI: I/O resource it87 [0x295-0x296] conflicts with ACPI region SPIO [0x295-0x296]
ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
md: raid1 personality registered for level 1
md: multipath personality registered for level -4
device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: dm-devel@redhat.com
cpuidle: using governor ladder
cpuidle: using governor menu
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
GACT probability NOT on
u32 classifier
    Actions configured 
Netfilter messages via NETLINK v0.30.
nf_conntrack version 0.5.0 (8008 buckets, 32032 max)
ctnetlink v0.93: registering with nfnetlink.
xt_time: kernel timezone is -0000
IPv4 over IPv4 tunneling driver
ip_tables: (C) 2000-2006 Netfilter Core Team
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 10
ip6_tables: (C) 2000-2006 Netfilter Core Team
IPv6 over IPv4 tunneling driver
NET: Registered protocol family 17
NET: Registered protocol family 15
Using IPI Shortcut mode
registered taskstats version 1
rtc_cmos 00:06: setting system clock to 2010-06-23 16:46:12 UTC (1277311572)
md: Waiting for all devices to be available before autodetect
md: If you don't use raid, use raid=noautodetect
md: Autodetecting RAID arrays.
md: Scanned 4 and added 4 devices.
md: autorun ...
md: considering sdb3 ...
md:  adding sdb3 ...
md: sdb1 has different UUID to sdb3
md:  adding sda3 ...
md: sda1 has different UUID to sdb3
md: created md1
md: bind<sda3>
md: bind<sdb3>
md: running: <sdb3><sda3>
md: kicking non-fresh sdb3 from array!
md: unbind<sdb3>
md: export_rdev(sdb3)
raid1: raid set md1 active with 1 out of 2 mirrors
md1: detected capacity change from 0 to 20267008000
md: considering sdb1 ...
md:  adding sdb1 ...
md:  adding sda1 ...
md: created md0
md: bind<sda1>
md: bind<sdb1>
md: running: <sdb1><sda1>
md: kicking non-fresh sdb1 from array!
md: unbind<sdb1>
md: export_rdev(sdb1)
raid1: raid set md0 active with 1 out of 2 mirrors
md0: detected capacity change from 0 to 16318464
md: ... autorun DONE.
 md1: unknown partition table
EXT3-fs: mounted filesystem with writeback data mode.
VFS: Mounted root (ext3 filesystem) readonly on device 9:1.
Freeing unused kernel memory: 344k freed
Write protecting the kernel text: 4348k
Write protecting the kernel read-only data: 1428k
kjournald starting.  Commit interval 5 seconds
ohci1394: fw-host0: SelfID received outside of bus reset sequence
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[00301b301bb3db59]
udev: starting version 149
 md0: unknown partition table
EXT3 FS on md1, internal journal
Adding 257032k swap on /dev/sda2.  Priority:-1 extents:1 across:257032k 
Adding 257032k swap on /dev/sdb2.  Priority:-2 extents:1 across:257032k 
eth1: link up, 100Mbps, full-duplex, lpa 0x45E1
eth1: no IPv6 routers present
eth0: no IPv6 routers present

--------------060206010001020708030708--

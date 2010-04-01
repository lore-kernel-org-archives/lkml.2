Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758170Ab0DAWDs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 18:03:48 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:42655 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756168Ab0DAWDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 18:03:44 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.31 regression: programs crashing after a couple of days of uptime with hibernation
Date: Fri, 2 Apr 2010 00:03:34 +0200
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org
References: <201004012332.49454.linux@rainbow-software.org> <201004012345.33124.rjw@sisk.pl>
In-Reply-To: <201004012345.33124.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201004020003.37305.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 April 2010 23:45:33 you wrote:
> On Thursday 01 April 2010, Ondrej Zary wrote:
> > Hello,
> > with kernel 2.6.30, I can have uptime of more than a month on my desktop
> > PC (with hibernation). It's impossible with 2.6.31. After 1 to 3 days,
> > processes that were running during hibernation (e.g. konsole, kwin,
> > kicker, xorg) start to crash randomly in very weird ways. The kernel
> > itself does not seem to crash. When I run the crashed program again, it
> > seems to work. Looks like some memory corruption.
> >
> > This bug is also present in 2.6.32 and 2.6.33.
>
> Is the kernel 32-bit or 64-bit?  What kind of CPU is there in the box?

It's old 32-bit i686 CPU - Cyrix MII.

Linux version 2.6.31-pentium (rainbow@pentium) (gcc version 4.3.3 (GCC) ) #5 PREEMPT Fri Oct 2 19:10:10 CEST 2009
KERNEL supported cpus:
  NSC Geode by NSC
  Cyrix CyrixInstead
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000000fff0000 (usable)
 BIOS-e820: 000000000fff0000 - 000000000fff3000 (ACPI NVS)
 BIOS-e820: 000000000fff3000 - 0000000010000000 (ACPI data)
 BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
DMI 2.0 present.
last_pfn = 0xfff0 max_arch_pfn = 0x100000
initial memory mapped : 0 - 00800000
init_memory_mapping: 0000000000000000-000000000fff0000
 0000000000 - 000fff0000 page 4k
kernel direct mapping tables up to fff0000 @ 7000-4a000
ACPI: RSDP 000f6c40 00014 (v00 123456)
ACPI: RSDT 0fff3000 00028 (v01 123456 AWRDACPI 00000000      00000000)
ACPI: FACP 0fff3040 00074 (v01 123456 AWRDACPI 00000000      00000000)
ACPI: DSDT 0fff30c0 02313 (v01 123456 AWRDACPI 00001000 MSFT 01000007)
ACPI: FACS 0fff0000 00040
255MB LOWMEM available.
  mapped low ram: 0 - 0fff0000
  low ram: 0 - 0fff0000
  node 0 low ram: 00000000 - 0fff0000
  node 0 bootmap 00001000 - 00003000
(6 early reservations) ==> bootmem [0000000000 - 000fff0000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000100000 - 00004573a0]    TEXT DATA BSS ==> [0000100000 - 00004573a0]
  #2 [000009f800 - 0000100000]    BIOS reserved ==> [000009f800 - 0000100000]
  #3 [0000458000 - 000045a0a2]              BRK ==> [0000458000 - 000045a0a2]
  #4 [0000007000 - 0000045000]          PGTABLE ==> [0000007000 - 0000045000]
  #5 [0000001000 - 0000003000]          BOOTMAP ==> [0000001000 - 0000003000]
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  Normal   0x00001000 -> 0x0000fff0
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000000 -> 0x0000009f
    0: 0x00000100 -> 0x0000fff0
On node 0 totalpages: 65423
free_area_init_node: node 0, pgdat c03decd4, node_mem_map c1000000
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 3967 pages, LIFO batch:0
  Normal zone: 480 pages used for memmap
  Normal zone: 60944 pages, LIFO batch:15
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
Allocating PCI resources starting at 10000000 (gap: 10000000:efff0000)
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 64911
Kernel command line: BOOT_IMAGE=Linux2631 ro root=812 video=matroxfb:vesa:0x105,fv:85,left:192 resume=/dev/sdb3 pnp.debug=1 acpi_irq_isa=10
PID hash table entries: 1024 (order: 10, 4096 bytes)
Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
Initializing CPU#0
Memory: 255620k/262080k available (2100k kernel code, 5948k reserved, 848k data, 236k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xfffe5000 - 0xfffff000   ( 104 kB)
    vmalloc : 0xd07f0000 - 0xfffe3000   ( 759 MB)
    lowmem  : 0xc0000000 - 0xcfff0000   ( 255 MB)
      .init : 0xc03e2000 - 0xc041d000   ( 236 kB)
      .data : 0xc030d0a7 - 0xc03e11f8   ( 848 kB)
      .text : 0xc0100000 - 0xc030d0a7   (2100 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
NR_IRQS:16
CPU 0 irqstacks, hard=c03c0000 soft=c03c1000
Fast TSC calibration using PIT
Detected 224.982 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Calibrating delay loop (skipped), value calculated using timer frequency.. 449.96 BogoMIPS (lpj=2249820)
Mount-cache hash table entries: 512
CPU: Cyrix M II 3x Core/Bus Clock stepping 04
Checking 'hlt' instruction... OK.
ACPI: Core revision 20090521
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: EC: Look up EC in DSDT
ACPI Warning: \_SB_.PCI0.ISA_.UAR1._PRW: Return type mismatch - found Integer, expected Package 20090521 nspredef-940
ACPI Error (uteval-0313): Return object type is incorrect [\_SB_.PCI0.ISA_.UAR1._PRW] (Node cf81f34c), AE_TYPE
ACPI Error: Type returned from _PRW was incorrect: Integer, expected Btypes: 8 20090521 uteval-319
ACPI Warning: \_SB_.PCI0.ISA_.UAR2._PRW: Return type mismatch - found Integer, expected Package 20090521 nspredef-940
ACPI Error (uteval-0313): Return object type is incorrect [\_SB_.PCI0.ISA_.UAR2._PRW] (Node cf81fbf8), AE_TYPE
ACPI Error: Type returned from _PRW was incorrect: Integer, expected Btypes: 8 20090521 uteval-319
ACPI Warning: \_SB_.PCI0.ISA_.LPT_._PRW: Return type mismatch - found Integer, expected Package 20090521 nspredef-940
ACPI Error (uteval-0313): Return object type is incorrect [\_SB_.PCI0.ISA_.LPT_._PRW] (Node cf81facc), AE_TYPE
ACPI Error: Type returned from _PRW was incorrect: Integer, expected Btypes: 8 20090521 uteval-319
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S4 S5)
ACPI: Using PIC for interrupt routing
ACPI Exception: AE_BAD_PARAMETER, Extracting _PRW package 20090521 scan-777
ACPI Exception: AE_BAD_PARAMETER, Extracting _PRW package 20090521 scan-777
ACPI: Power Resource [PFAN] (on)
ACPI: No dock devices found.
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:07.1: reg 20 io port: [0xf000-0xf00f]
pci 0000:00:07.2: reg 20 io port: [0x6400-0x641f]
pci 0000:00:07.3: quirk: region 4000-403f claimed by PIIX4 ACPI
pci 0000:00:07.3: quirk: region 5000-500f claimed by PIIX4 SMB
pci 0000:00:12.0: reg 10 io port: [0x6800-0x6807]
pci 0000:00:12.0: reg 14 io port: [0x6c00-0x6c03]
pci 0000:00:12.0: reg 18 io port: [0x7000-0x7007]
pci 0000:00:12.0: reg 1c io port: [0x7400-0x7403]
pci 0000:00:12.0: reg 20 io port: [0x7800-0x780f]
pci 0000:00:12.0: reg 30 32bit mmio: [0x000000-0x01ffff]
pci 0000:00:13.0: reg 10 32bit mmio: [0xe0000000-0xe0003fff]
pci 0000:00:13.0: reg 14 32bit mmio: [0xe1000000-0xe17fffff]
pci 0000:00:13.0: reg 18 32bit mmio: [0xe2000000-0xe27fffff]
pci 0000:00:13.0: reg 30 32bit mmio: [0x000000-0x00ffff]
pci 0000:00:14.0: reg 10 32bit mmio: [0xe3000000-0xe3ffffff]
pci 0000:00:14.0: reg 14 32bit mmio: [0xe4000000-0xe4003fff]
pci 0000:00:14.0: reg 18 32bit mmio: [0xe5000000-0xe57fffff]
pci 0000:00:14.0: reg 30 32bit mmio: [0x000000-0x00ffff]
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 11 12 14 15) *9
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 11 12 14 15) *9
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11 12 14 15) *9
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11 12 14 15) *9
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp 00:00: parse allocated resources
pnp 00:00:   add io  0xcf8-0xcff flags 0x1
pnp 00:00:   add io  0x4000-0x4041 flags 0x1
pnp 00:00:   add io  0x5000-0x500f flags 0x1
pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
pnp 00:01: parse allocated resources
pnp 00:01:   add mem 0x0-0x9ffff flags 0x1
pnp 00:01:   add mem 0xf0000-0xf3fff flags 0x0
pnp 00:01:   add mem 0xf4000-0xf7fff flags 0x0
pnp 00:01:   add mem 0xf8000-0xfffff flags 0x0
pnp 00:01:   add mem 0xc9c00-0xcbfff flags 0x0
pnp 00:01:   add mem 0x100000-0xffeffff flags 0x1
pnp 00:01:   add mem 0xfff0000-0xfffffff flags 0x0
pnp 00:01:   add mem 0xffff0000-0xffffffff flags 0x0
pnp 00:01: PNP0c01: calling quirk_system_pci_resources+0x0/0x175
pnp 00:01: Plug and Play ACPI device, IDs PNP0c01 (active)
pnp 00:02: parse allocated resources
pnp 00:02:   add io  0x10-0x1f flags 0x1
pnp 00:02:   add io  0x22-0x3f flags 0x1
pnp 00:02:   add io  0x44-0x5f flags 0x1
pnp 00:02:   add io  0x62-0x63 flags 0x1
pnp 00:02:   add io  0x65-0x6f flags 0x1
pnp 00:02:   add io  0x74-0x7f flags 0x1
pnp 00:02:   add io  0x91-0x93 flags 0x1
pnp 00:02:   add io  0xa2-0xbf flags 0x1
pnp 00:02:   add io  0xe0-0xef flags 0x1
pnp 00:02:   add io  0x3f0-0x3f1 flags 0x1
pnp 00:02:   add io  0x4d0-0x4d1 flags 0x1
pnp 00:02: PNP0c02: calling quirk_system_pci_resources+0x0/0x175
pnp 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:03: parse allocated resources
pnp 00:03:   add dma 4 flags 0x4
pnp 00:03:   add io  0x0-0xf flags 0x1
pnp 00:03:   add io  0x80-0x90 flags 0x1
pnp 00:03:   add io  0x94-0x9f flags 0x1
pnp 00:03:   add io  0xc0-0xdf flags 0x1
pnp 00:03: Plug and Play ACPI device, IDs PNP0200 (active)
pnp 00:04: parse allocated resources
pnp 00:04:   add io  0x70-0x73 flags 0x1
pnp 00:04:   add irq 8 flags 0x1
pnp 00:04: Plug and Play ACPI device, IDs PNP0b00 (active)
pnp 00:05: parse allocated resources
pnp 00:05:   add io  0x61-0x61 flags 0x1
pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
pnp 00:06: parse allocated resources
pnp 00:06:   add io  0xf0-0xff flags 0x1
pnp 00:06:   add irq 13 flags 0x1
pnp 00:06: Plug and Play ACPI device, IDs PNP0c04 (active)
pnp 00:07: parse allocated resources
pnp 00:07:   add io  0x3f2-0x3f5 flags 0x1
pnp 00:07:   add io  0x3f7-0x3f7 flags 0x1
pnp 00:07:   add irq 6 flags 0x1
pnp 00:07:   add dma 2 flags 0x0
pnp 00:07: parse resource options
pnp 00:07:   dependent set 0 (acceptable) io  min 0x3f2 max 0x3f2 align 0 size 4 flags 0x1
pnp 00:07:   dependent set 0 (acceptable) io  min 0x3f7 max 0x3f7 align 0 size 1 flags 0x1
pnp 00:07:   dependent set 0 (acceptable) irq 6 flags 0x1
pnp 00:07:   dependent set 0 (acceptable) dma 2 (bitmask 0x4) flags 0x0
pnp 00:07: Plug and Play ACPI device, IDs PNP0700 (active)
pnp 00:08: parse allocated resources
pnp 00:08:   add io  0x3f8-0x3ff flags 0x1
pnp 00:08:   add irq 4 flags 0x1
pnp 00:08: parse resource options
pnp 00:08:   dependent set 0 (acceptable) io  min 0x3f8 max 0x3f8 align 0 size 8 flags 0x1
pnp 00:08:   dependent set 0 (acceptable) irq 4 flags 0x1
pnp 00:08:   dependent set 1 (acceptable) io  min 0x2f8 max 0x2f8 align 0 size 8 flags 0x1
pnp 00:08:   dependent set 1 (acceptable) irq 3 flags 0x1
pnp 00:08:   dependent set 2 (acceptable) io  min 0x3e8 max 0x3e8 align 0 size 8 flags 0x1
pnp 00:08:   dependent set 2 (acceptable) irq 4 flags 0x1
pnp 00:08:   dependent set 3 (acceptable) io  min 0x2e8 max 0x2e8 align 0 size 8 flags 0x1
pnp 00:08:   dependent set 3 (acceptable) irq 3 flags 0x1
pnp 00:08: Plug and Play ACPI device, IDs PNP0501 (active)
pnp 00:09: parse allocated resources
pnp 00:09:   add io  0x2f8-0x2ff flags 0x1
pnp 00:09:   add irq 3 flags 0x1
pnp 00:09: parse resource options
pnp 00:09:   dependent set 0 (acceptable) io  min 0x3f8 max 0x3f8 align 0 size 8 flags 0x1
pnp 00:09:   dependent set 0 (acceptable) irq 4 flags 0x1
pnp 00:09:   dependent set 1 (acceptable) io  min 0x2f8 max 0x2f8 align 0 size 8 flags 0x1
pnp 00:09:   dependent set 1 (acceptable) irq 3 flags 0x1
pnp 00:09:   dependent set 2 (acceptable) io  min 0x3e8 max 0x3e8 align 0 size 8 flags 0x1
pnp 00:09:   dependent set 2 (acceptable) irq 4 flags 0x1
pnp 00:09:   dependent set 3 (acceptable) io  min 0x2e8 max 0x2e8 align 0 size 8 flags 0x1
pnp 00:09:   dependent set 3 (acceptable) irq 3 flags 0x1
pnp 00:09: Plug and Play ACPI device, IDs PNP0501 (active)
pnp 00:0a: parse allocated resources
pnp 00:0a:   add io  0x378-0x37f flags 0x1
pnp 00:0a:   add io  0x778-0x77b flags 0x1
pnp 00:0a:   add irq 7 flags 0x1
pnp 00:0a:   add dma 3 flags 0x0
pnp 00:0a: parse resource options
pnp 00:0a:   dependent set 0 (acceptable) io  min 0x378 max 0x378 align 0 size 8 flags 0x1
pnp 00:0a:   dependent set 0 (acceptable) io  min 0x778 max 0x778 align 0 size 4 flags 0x1
pnp 00:0a:   dependent set 0 (acceptable) irq 5 7 flags 0x1
pnp 00:0a:   dependent set 0 (acceptable) dma 1 3 (bitmask 0xa) flags 0x0
pnp 00:0a:   dependent set 1 (acceptable) io  min 0x278 max 0x278 align 0 size 8 flags 0x1
pnp 00:0a:   dependent set 1 (acceptable) io  min 0x678 max 0x678 align 0 size 4 flags 0x1
pnp 00:0a:   dependent set 1 (acceptable) irq 5 7 flags 0x1
pnp 00:0a:   dependent set 1 (acceptable) dma 1 3 (bitmask 0xa) flags 0x0
pnp 00:0a:   dependent set 2 (acceptable) io  min 0x3bc max 0x3bc align 0 size 4 flags 0x1
pnp 00:0a:   dependent set 2 (acceptable) io  min 0x7bc max 0x7bc align 0 size 4 flags 0x1
pnp 00:0a:   dependent set 2 (acceptable) irq 5 7 flags 0x1
pnp 00:0a:   dependent set 2 (acceptable) dma 1 3 (bitmask 0xa) flags 0x0
pnp 00:0a: Plug and Play ACPI device, IDs PNP0401 (active)
pnp 00:0b: parse allocated resources
pnp 00:0b:   add irq 12 flags 0x1
pnp 00:0b: Plug and Play ACPI device, IDs PNP0f13 (active)
pnp 00:0c: parse allocated resources
pnp 00:0c:   add io  0x60-0x60 flags 0x1
pnp 00:0c:   add io  0x64-0x64 flags 0x1
pnp 00:0c:   add irq 1 flags 0x1
pnp 00:0c: Plug and Play ACPI device, IDs PNP0303 (active)
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
PnPBIOS: Disabled by ACPI PNP
system 00:01: iomem range 0x0-0x9ffff could not be reserved
system 00:01: iomem range 0xf0000-0xf3fff could not be reserved
system 00:01: iomem range 0xf4000-0xf7fff could not be reserved
system 00:01: iomem range 0xf8000-0xfffff could not be reserved
system 00:01: iomem range 0xc9c00-0xcbfff has been reserved
system 00:01: iomem range 0x100000-0xffeffff could not be reserved
system 00:01: iomem range 0xfff0000-0xfffffff could not be reserved
system 00:01: iomem range 0xffff0000-0xffffffff has been reserved
system 00:02: ioport range 0x3f0-0x3f1 has been reserved
system 00:02: ioport range 0x4d0-0x4d1 has been reserved
pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 2048 (order: 1, 8192 bytes)
TCP established hash table entries: 8192 (order: 4, 65536 bytes)
TCP bind hash table entries: 8192 (order: 3, 32768 bytes)
TCP: Hash tables configured (established 8192 bind 8192)
TCP reno registered
NET: Registered protocol family 1
fuse init (API version 7.12)
msgmni has been set to 499
io scheduler noop registered
io scheduler anticipatory registered (default)
io scheduler deadline registered
io scheduler cfq registered
pci 0000:00:00.0: Limiting direct PCI/PCI transfers
pci 0000:00:13.0: Boot video device
ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 11
PCI: setting IRQ 11 as level-triggered
matroxfb 0000:00:13.0: PCI INT A -> Link[LNKB] -> GSI 11 (level, low) -> IRQ 11
matroxfb: Matrox Mystique (PCI) detected
PInS memtype = 0
matroxfb: MTRR's turned on
matroxfb: 1024x768x8bpp (virtual: 1024x4096)
matroxfb: framebuffer at 0xE1000000, mapped to 0xd0880000, size 4194304
Console: switching to colour frame buffer device 128x48
fb0: MATROX frame buffer device
matroxfb 0000:00:14.0: enabling device (0000 -> 0002)
ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
matroxfb 0000:00:14.0: PCI INT A -> Link[LNKA] -> GSI 11 (level, low) -> IRQ 11
matroxfb: Matrox Millennium II (PCI) detected
PInS memtype = 0
matroxfb: MTRR's turned on
matroxfb: 1024x768x8bpp (virtual: 1024x4096)
matroxfb: framebuffer at 0xE3000000, mapped to 0xd1100000, size 4194304
fb1: MATROX frame buffer device
fb1: initializing hardware
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
ACPI: Power Button [PWRF]
input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
ACPI: Power Button [PWRB]
fan PNP0C0B:00: registered as cooling_device0
ACPI: Fan [FAN] (on)
Marking TSC unstable due to TSC halts in idle
ACPI: CPU0 (power states: C1[C1] C2[C2])
processor LNXCPU:00: registered as cooling_device1
thermal LNXTHERM:01: registered as thermal_zone0
ACPI: Thermal Zone [THRM] (22 C)
isapnp: Scanning for PnP cards...
pnp 01:01.00:   dependent set 0 (preferred) io  min 0x220 max 0x220 align 0 size 16 flags 0x2
pnp 01:01.00:   dependent set 0 (preferred) irq 5 flags 0x1
pnp 01:01.00:   dependent set 0 (preferred) dma 1 (bitmask 0x2) flags 0x8
pnp 01:01.00:   dependent set 0 (preferred) dma 5 (bitmask 0x20) flags 0x12
pnp 01:01.00:   dependent set 1 (acceptable) io  min 0x220 max 0x240 align 32 size 16 flags 0x0
pnp 01:01.00:   dependent set 1 (acceptable) irq 5 7 9 10 flags 0x1
pnp 01:01.00:   dependent set 1 (acceptable) dma 0 1 3 (bitmask 0xb) flags 0x8
pnp 01:01.00:   dependent set 1 (acceptable) dma 5 7 (bitmask 0xa0) flags 0x12
pnp 01:01.00:   dependent set 2 (acceptable) io  min 0x220 max 0x240 align 32 size 16 flags 0x0
pnp 01:01.00:   dependent set 2 (acceptable) irq 5 7 9 10 11 12 flags 0x1
pnp 01:01.00:   dependent set 2 (acceptable) dma 0 1 3 (bitmask 0xb) flags 0x8
pnp 01:01.00:   dependent set 2 (acceptable) dma 5 7 (bitmask 0xa0) flags 0x12
pnp 01:01.01:   dependent set 0 (preferred) io  min 0x330 max 0x330 align 0 size 2 flags 0x2
pnp 01:01.01:   dependent set 0 (preferred) irq <none> flags 0x1
pnp 01:01.01:   dependent set 1 (acceptable) io  min 0x300 max 0x330 align 16 size 2 flags 0x0
pnp 01:01.01:   dependent set 1 (acceptable) irq 5 7 9 10 11 12 flags 0x1
pnp 01:01.02:   dependent set 0 (preferred) io  min 0x200 max 0x200 align 0 size 8 flags 0x2
pnp 01:01.02:   dependent set 1 (acceptable) io  min 0x200 max 0xfe0 align 16 size 8 flags 0x0
pnp 01:01.03:   dependent set 0 (preferred) io  min 0x530 max 0x530 align 0 size 8 flags 0x1
pnp 01:01.03:   dependent set 0 (preferred) irq 11 flags 0x1
pnp 01:01.03:   dependent set 0 (preferred) dma 0 (bitmask 0x1) flags 0x8
pnp 01:01.03:   dependent set 1 (acceptable) io  min 0x530 max 0x530 align 0 size 8 flags 0x1
pnp 01:01.03:   dependent set 1 (acceptable) irq 7 9 10 11 flags 0x1
pnp 01:01.03:   dependent set 1 (acceptable) dma 0 1 3 (bitmask 0xb) flags 0x8
pnp 01:01.03:   dependent set 2 (acceptable) io  min 0x530 max 0x530 align 0 size 8 flags 0x1
pnp 01:01.03:   dependent set 2 (acceptable) irq 5 7 9 10 11 12 flags 0x1
pnp 01:01.03:   dependent set 2 (acceptable) dma 0 1 3 (bitmask 0xb) flags 0x8
pnp 01:01.03:   dependent set 3 (acceptable) io  min 0xe80 max 0xe80 align 0 size 8 flags 0x1
pnp 01:01.03:   dependent set 3 (acceptable) irq 7 9 10 11 flags 0x1
pnp 01:01.03:   dependent set 3 (acceptable) dma 0 1 3 (bitmask 0xb) flags 0x8
pnp 01:01.03:   dependent set 4 (acceptable) io  min 0xf40 max 0xf40 align 0 size 8 flags 0x1
pnp 01:01.03:   dependent set 4 (acceptable) irq 7 9 10 11 flags 0x1
pnp 01:01.03:   dependent set 4 (acceptable) dma 0 1 3 (bitmask 0xb) flags 0x8
pnp 01:01.04:   dependent set 0 (preferred) io  min 0x100 max 0x3f8 align 8 size 8 flags 0x0
pnp 01:01.03: @X@0001: calling quirk_cmi8330_resources+0x0/0xde
pnp 01:01.03: set possible IRQs in option set 0 to 5, 7, 10
pnp 01:01.03: changing possible DMA channel mask in option set 0 from 0x1 to 0x0A (1, 3)
pnp 01:01.03: set possible IRQs in option set 1 to 5, 7, 10
pnp 01:01.03: changing possible DMA channel mask in option set 1 from 0xb to 0x0A (1, 3)
pnp 01:01.03: set possible IRQs in option set 2 to 5, 7, 10
pnp 01:01.03: changing possible DMA channel mask in option set 2 from 0xb to 0x0A (1, 3)
pnp 01:01.03: set possible IRQs in option set 3 to 5, 7, 10
pnp 01:01.03: changing possible DMA channel mask in option set 3 from 0xb to 0x0A (1, 3)
pnp 01:01.03: set possible IRQs in option set 4 to 5, 7, 10
pnp 01:01.03: changing possible DMA channel mask in option set 4 from 0xb to 0x0A (1, 3)
pnp 01:02.00:   independent irq 3 5 7 9 10 11 12 15 flags 0x1
pnp 01:02.00:   independent io  min 0x210 max 0x3e0 align 16 size 16 flags 0x1
 01:01: card 'AD-CHIPS Audio Adapter'
 01:02: card '3Com 3C509B EtherLink III'
isapnp: 2 Plug & Play cards detected total
lp: driver loaded but no devices found
Real Time Clock Driver v1.12b
Non-volatile memory driver v1.3
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:09: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
parport_pc 00:0a: reported by Plug and Play ACPI
parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,ECP,DMA]
lp0: using parport0 (interrupt-driven).
loop: module loaded
ata_piix 0000:00:07.1: version 2.13
scsi0 : ata_piix
scsi1 : ata_piix
ata1: PATA max UDMA/33 cmd 0x1f0 ctl 0x3f6 bmdma 0xf000 irq 14
ata2: PATA max UDMA/33 cmd 0x170 ctl 0x376 bmdma 0xf008 irq 15
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
pata_it821x 0000:00:12.0: PCI INT A -> Link[LNKC] -> GSI 11 (level, low) -> IRQ 11
pata_it821x: controller in smart mode.
pata_it821x 0000:00:12.0: setting latency timer to 64
pata_it821x: Firmware 02/09/3030
0: MWDMA2 RAID1RAID 0+1 Volume: 0 SAMSUNG HD400LD 
1: MWDMA2 RAID1RAID 0+1 Volume: 0 SAMSUNG HD400LD 
scsi2 : pata_it821x
scsi3 : pata_it821x
ata3: PATA max UDMA/133 cmd 0x6800 ctl 0x6c00 bmdma 0x7800 irq 11
ata4: PATA max UDMA/133 cmd 0x7000 ctl 0x7400 bmdma 0x7808 irq 11
uhci_hcd: USB Universal Host Controller Interface driver
ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
uhci_hcd 0000:00:07.2: PCI INT D -> Link[LNKD] -> GSI 11 (level, low) -> IRQ 11
uhci_hcd 0000:00:07.2: UHCI Host Controller
uhci_hcd 0000:00:07.2: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:07.2: irq 11, io base 0x00006400
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usbcore: registered new interface driver ums-cypress
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
ns558 01:01.02: pnp_assign_resources, try dependent set 0
ns558 01:01.02:   add io  0x200-0x207 flags 0x40000002
ns558 01:01.02: pnp_assign_resources succeeded: current resources:
ns558 01:01.02:   io  0x200-0x207 flags 0x40000102
ns558 01:01.02: pnp_start_dev: current resources:
ns558 01:01.02:   io  0x200-0x207 flags 0x40000102
ns558 01:01.02: set resources
ns558 01:01.02:   set io  0 to 0x200
ns558 01:01.02: activated
gameport: NS558 PnP Gameport is pnp01:01.02/gameport0, io 0x200, speed 903kHz
mice: PS/2 mouse device common for all mice
i2c /dev entries driver
ACPI: I/O resource piix4_smbus [0x5000-0x5007] conflicts with ACPI region SM06 [0x5006-0x5006]
ACPI: Device needs an ACPI driver
piix4_smbus: probe of 0000:00:07.3 failed with error -16
cpuidle: using governor ladder
cpuidle: using governor menu
Advanced Linux Sound Architecture Driver Version 1.0.20.
ALSA device list:
  No soundcards found.
TCP cubic registered
NET: Registered protocol family 17
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
ata2.00: ATAPI: LS-120 CSMO   05              UHD Floppy, 0512C105, max PIO2
ata2.01: ATAPI: MSI      CD-RW MS-8340S, 120D, max UDMA/33
ata2.00: configured for PIO2
ata2.01: configured for UDMA/33
scsi 1:0:0:0: Direct-Access     MITBISHI LS-120 COSM   05 0512 PQ: 0 ANSI: 5
sd 1:0:0:0: Attached scsi generic sg0 type 0
sd 1:0:0:0: [sda] Attached SCSI removable disk
usb 1-2: new full speed USB device using uhci_hcd and address 2
scsi 1:0:1:0: CD-ROM            MSI      CD-RW MS-8340S   120D PQ: 0 ANSI: 5
scsi 1:0:1:0: Attached scsi generic sg1 type 5
usb 1-2: configuration #1 chosen from 1 choice
scsi4 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 2
usb-storage: waiting for device to settle before scanning
input: ImPS/2 Generic Wheel Mouse as /devices/platform/i8042/serio1/input/input3
ata3.00: ATA-4: Integrated Technology Express Inc, , max MWDMA2
ata3.00: 781422766 sectors, multi 0: LBA48 
ata3.00: RAID1 volume.
ata3.00: configured for DMA
scsi 2:0:0:0: Direct-Access     ATA      Integrated Techn n/a  PQ: 0 ANSI: 5
sd 2:0:0:0: [sdb] 781422766 512-byte logical blocks: (400 GB/372 GiB)
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdb:
sd 2:0:0:0: Attached scsi generic sg2 type 0
 sdb1 sdb2 sdb3 sdb4 < sdb5 >
sd 2:0:0:0: [sdb] Attached SCSI disk
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly on device 8:18.
Freeing unused kernel memory: 236k freed
scsi 4:0:0:0: Direct-Access     SigmaTel MSCN             0100 PQ: 0 ANSI: 4
sd 4:0:0:0: Attached scsi generic sg3 type 0
sd 4:0:0:0: [sdc] 496256 2048-byte logical blocks: (1.01 GB/969 MiB)
sd 4:0:0:0: [sdc] Write Protect is off
sd 4:0:0:0: [sdc] Mode Sense: 3e 00 00 00
sd 4:0:0:0: [sdc] Assuming drive cache: write through
sd 4:0:0:0: [sdc] 496256 2048-byte logical blocks: (1.01 GB/969 MiB)
sd 4:0:0:0: [sdc] Assuming drive cache: write through
 sdc:
usb-storage: device scan complete
 sdc1
sd 4:0:0:0: [sdc] 496256 2048-byte logical blocks: (1.01 GB/969 MiB)
sd 4:0:0:0: [sdc] Assuming drive cache: write through
sd 4:0:0:0: [sdc] Attached SCSI removable disk
sr0: scsi3-mmc drive: 32x/48x writer cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 1:0:1:0: Attached scsi CD-ROM sr0
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
Adding 257032k swap on /dev/sdb3.  Priority:-1 extents:1 across:257032k 
EXT3 FS on sdb2, internal journal
ppdev: user-space parallel port driver
eth0: 3c5x9 found at 0x300, BNC port, address 00:20:af:49:ed:b0, IRQ 3.
3c509.c:1.20 04Feb2008 becker@scyld.com
irda_init()
NET: Registered protocol family 23
IrCOMM protocol (Dag Brattli)
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdb5, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
matroxfb 0000:00:14.0: Invalid ROM contents


-- 
Ondrej Zary

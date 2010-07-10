Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449Ab0GJCLw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 22:11:52 -0400
Received: from client-adsl-93-121-138-180.mediaserv.net ([93.121.138.180]:55955
	"EHLO werner.loopback" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751975Ab0GJCLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 22:11:48 -0400
From: werner@guyane.yi.org
Subject: 2.6.35-rc2,3 -- Problem with PS2 keyboard and mouse driver
To: dmitry.torokhov@gmail.com, linux-kernel@vger.kernel.org
X-Originating-IP: 127.0.0.1
X-Mailer: Usermin 1.360
Message-Id: <1278727932.27193@guyane.yi.org>
Date: Fri, 09 Jul 2010 23:12:12 -0300 (GFT)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="bound1278727932"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--bound1278727932
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

Yes with switching that off as dmitry said, it returns to work.

On the other hand,  I make a distro, SYS, and for distros it's necessary to enable EVERYTHING,
for compiling the kernel,
because you never know what computer people have.   Thus, generally, modules have to be programmed
in a manner that a kernel also works if you don't have certain hardware.  

This should be corrected in that module -- so that the kernel runs also on my computer
(and on other people computer) when the kernel is compiled with the option enabled.

At meast, for me at the moment it works with disable the hardware.

The bin package, Slackware-compatible, for my SYS distro, I put here: ftp://ftp.uni-siegen.de/pub/sys-linux  under linux-2.6.35-rc4-git4 ...


W.Landgraf  


=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
0
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 3951 pages, LIFO batch:0
  Normal zone: 1744 pages used for memmap
  Normal zone: 221486 pages, LIFO batch:31
  HighMem zone: 3856 pages used for memmap
  HighMem zone: 489650 pages, LIFO batch:31
Using APIC driver default
Detected use of extended apic ids on hypertransport bus
ACPI: PM-Timer IO Port: 0x508
ACPI: HPET id: 0x10de8201 base: 0xfed00000
Intel MultiProcessor Specification v1.4
    Virtual Wire compatibility mode.
MPTABLE: OEM ID: TEMPLATE
MPTABLE: Product ID: 
MPTABLE: APIC at: 0xFEE00000
Processor #0 (Bootup-CPU)
Processor #1
I/O APIC #2 Version 17 at 0xFEC00000.
IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
Processors: 2
SMP: Allowing 2 CPUs, 0 hotplug CPUs
nr_irqs_gsi: 40
early_res array is doubled to 64 at [16000 - 167ff]
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
Allocating PCI resources starting at b0000000 (gap: b0000000:4ec00000)
Booting paravirtualized kernel on bare hardware
setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:2 nr_node_ids:1
early_res array is doubled to 128 at [16800 - 177ff]
PERCPU: 16 4K pages/cpu @f7ffe000 s34848 r0 d2016
pcpu-alloc: s34848 r0 d2016 u65536 alloc=3D16*4096
pcpu-alloc: [0] 0 [0] 1 
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 715087
Kernel command line: auto BOOT_IMAGE=3D2635rc4git4 ro root=3D801 4 root=3D/dev/sda1 devfs=3Dnomount noapic nolapic acpi=3Dht rootwait percpu_alloc=3Dpage
PID hash table entries: 4096 (order: 2, 16384 bytes)
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
Subtract (80 early reservations)
  #1 [0000001000 - 0000002000]   EX TRAMPOLINE
  #2 [0001000000 - 000257a4a8]   TEXT DATA BSS
  #3 [000257b000 - 000258522c]             BRK
  #4 [00000ff790 - 0000100000]   BIOS reserved
  #5 [00000ff780 - 00000ff790]    MP-table mpf
  #6 [000009fc00 - 00000f1340]   BIOS reserved
  #7 [00000f1484 - 00000ff780]   BIOS reserved
  #8 [00000f1340 - 00000f1484]    MP-table mpc
  #9 [0000010000 - 0000011000]      TRAMPOLINE
  #10 [0000011000 - 0000015000]     ACPI WAKEUP
  #11 [0000015000 - 0000016000]         PGTABLE
  #12 [0002586000 - 0002587000]         BOOTMEM
  #13 [0002587000 - 0003b87000]         BOOTMEM
  #14 [000257a4b0 - 000257a4b4]         BOOTMEM
  #15 [000257a4c0 - 000257a580]         BOOTMEM
  #16 [000257a580 - 000257a5d4]         BOOTMEM
  #17 [0003b87000 - 0003b8a000]         BOOTMEM
  #18 [000257a5e0 - 000257a698]         BOOTMEM
  #19 [0003b8a000 - 0003b90000]         BOOTMEM
  #20 [000257a6a0 - 000257a6c5]         BOOTMEM
  #21 [000257a6d0 - 000257a6f7]         BOOTMEM
  #22 [000257a700 - 000257a850]         BOOTMEM
  #23 [000257a850 - 000257a890]         BOOTMEM
  #24 [000257a890 - 000257a8d0]         BOOTMEM
  #25 [000257a8d0 - 000257a910]         BOOTMEM
  #26 [000257a910 - 000257a950]         BOOTMEM
  #27 [000257a950 - 000257a990]         BOOTMEM
  #28 [000257a990 - 000257a9d0]         BOOTMEM
  #29 [000257a9d0 - 000257aa10]         BOOTMEM
  #30 [000257aa10 - 000257aa50]         BOOTMEM
  #31 [000257aa50 - 000257aa90]         BOOTMEM
  #32 [000257aa90 - 000257aad0]         BOOTMEM
  #33 [000257aad0 - 000257ab10]         BOOTMEM
  #34 [000257ab10 - 000257ab20]         BOOTMEM
  #35 [000257ab20 - 000257ab99]         BOOTMEM
  #36 [000257aba0 - 000257ac19]         BOOTMEM
  #37 [0003b92000 - 0003b93000]         BOOTMEM
  #38 [0003b93000 - 0003b94000]         BOOTMEM
  #39 [0003b94000 - 0003b95000]         BOOTMEM
  #40 [0003b95000 - 0003b96000]         BOOTMEM
  #41 [0003b96000 - 0003b97000]         BOOTMEM
  #42 [0003b97000 - 0003b98000]         BOOTMEM
  #43 [0003b98000 - 0003b99000]         BOOTMEM
  #44 [0003b99000 - 0003b9a000]         BOOTMEM
  #45 [0003b9a000 - 0003b9b000]         BOOTMEM
  #46 [0003b9b000 - 0003b9c000]         BOOTMEM
  #47 [0003b9c000 - 0003b9d000]         BOOTMEM
  #48 [0003b9d000 - 0003b9e000]         BOOTMEM
  #49 [0003b9e000 - 0003b9f000]         BOOTMEM
  #50 [0003b9f000 - 0003ba0000]         BOOTMEM
  #51 [0003ba0000 - 0003ba1000]         BOOTMEM
  #52 [0003ba1000 - 0003ba2000]         BOOTMEM
  #53 [0003ba2000 - 0003ba3000]         BOOTMEM
  #54 [0003ba3000 - 0003ba4000]         BOOTMEM
  #55 [0003ba4000 - 0003ba5000]         BOOTMEM
  #56 [0003ba5000 - 0003ba6000]         BOOTMEM
  #57 [0003ba6000 - 0003ba7000]         BOOTMEM
  #58 [0003ba7000 - 0003ba8000]         BOOTMEM
  #59 [0003ba8000 - 0003ba9000]         BOOTMEM
  #60 [0003ba9000 - 0003baa000]         BOOTMEM
  #61 [0003baa000 - 0003bab000]         BOOTMEM
  #62 [0003bab000 - 0003bac000]         BOOTMEM
  #63 [0003bac000 - 0003bad000]         BOOTMEM
  #64 [0003bad000 - 0003bae000]         BOOTMEM
  #65 [0003bae000 - 0003baf000]         BOOTMEM
  #66 [0003baf000 - 0003bb0000]         BOOTMEM
  #67 [0003bb0000 - 0003bb1000]         BOOTMEM
  #68 [0003bb1000 - 0003bb2000]         BOOTMEM
  #69 [0003bb2000 - 0003bb3000]         BOOTMEM
  #70 [0003bb3000 - 0003bb4000]         BOOTMEM
  #71 [000257ac20 - 000257ac24]         BOOTMEM
  #72 [000257ac30 - 000257ac34]         BOOTMEM
  #73 [000257ac40 - 000257ac48]         BOOTMEM
  #74 [000257ac50 - 000257ac58]         BOOTMEM
  #75 [000257ac60 - 000257ace0]         BOOTMEM
  #76 [000257ace0 - 000257ad0c]         BOOTMEM
  #77 [0003bb4000 - 0003bb8000]         BOOTMEM
  #78 [0003bb8000 - 0003c38000]         BOOTMEM
  #79 [0003c38000 - 0003c78000]         BOOTMEM
Initializing HighMem for node 0 (000377fe:000affc0)
Memory: 2837324k/2883328k available (13080k kernel code, 45552k reserved, 4957k data, 856k init, 1974024k highmem)
virtual kernel memory layout:
    fixmap  : 0xffd36000 - 0xfffff000   (2852 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
    lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
      .init : 0xc219e000 - 0xc2274000   ( 856 kB)
      .data : 0xc1cc6057 - 0xc219d7e0   (4957 kB)
      .text : 0xc1000000 - 0xc1cc6057   (13080 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
SLUB: Genslabs=3D13, HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D2, Nodes=3D1
Hierarchical RCU implementation.
	RCU-based detection of stalled CPUs is disabled.
	Verbose stalled-CPUs detection is disabled.
NR_IRQS:1280
Extended CMOS year: 2000
spurious 8259A interrupt: IRQ7.
Console: colour dummy device 80x25
console [tty0] enabled
hpet clockevent registered
Fast TSC calibration using PIT
Detected 2411.084 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 4822.16 BogoMIPS (lpj=3D2411084)
pid_max: default: 32768 minimum: 301
Security Framework initialized
Mount-cache hash table entries: 512
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 5 MCE banks
using C1E aware idle routine
Performance Events: 
no APIC, boot with the "lapic" boot parameter to force-enable it.
no hardware sampling interrupt available.
AMD PMU driver.
.. version:                0
.. bit width:              48
.. generic registers:      4
.. value mask:             0000ffffffffffff
.. max period:             00007fffffffffff
.. fixed-purpose events:   0
.. event mask:             000000000000000f
ACPI: Core revision 20100428
ACPI: setting ELCR to 0200 (from 8c00)
Enabling APIC mode:  Flat.  Using 1 I/O APICs
SMP disabled
Brought up 1 CPUs
Total of 1 processors activated (4822.16 BogoMIPS).
devtmpfs: initialized
xor: automatically using best checksumming function: pIII_sse
   pIII_sse  :  6836.000 MB/sec
xor: using function: pIII_sse (6836.000 MB/sec)
regulator: core version 0.5
regulator: dummy: 
NET: Registered protocol family 16
EISA bus registered
node 0 link 0: io port [1000, ffffff]
TOM: 00000000c0000000 aka 3072M
node 0 link 0: mmio [e0000000, efffffff]
node 0 link 0: mmio [a0000, bffff]
node 0 link 0: mmio [c0000000, fe0bffff]
TOM2: 0000000240000000 aka 9216M
bus: [00, ff] on node 0 link 0
bus: 00 index 0 [io  0x0000-0xffff]
bus: 00 index 1 [mem 0xc0000000-0xffffffff]
bus: 00 index 2 [mem 0x000a0000-0x000bffff]
ACPI: bus type pci registered
PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
PCI: not using MMCONFIG
PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=3D4
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: EC: Look up EC in DSDT
ACPI: Executed 1 blocks of module-level executable AML code
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S4 S5)
ACPI: Using PIC for interrupt routing
PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI motherboard resources
PCI: Using MMCONFIG for extended config space
ACPI Warning: Incorrect checksum in table [OEMB] - 0xF8, should be 0xEB (20100428/tbutils-314)
ACPI: No dock devices found.
PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=3Duse_crs" and report a bug
ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
pci_root PNP0A03:00: host bridge window [mem 0x000d0000-0x000dffff] (ignored)
pci_root PNP0A03:00: host bridge window [mem 0xb0000000-0xff77ffff] (ignored)
pci 0000:00:01.1: reg 10: [io  0xdc00-0xdc3f]
pci 0000:00:01.1: reg 20: [io  0x0600-0x063f]
pci 0000:00:01.1: reg 24: [io  0x0700-0x073f]
pci 0000:00:01.1: PME# supported from D3hot D3cold
pci 0000:00:01.1: PME# disabled
pci 0000:00:02.0: reg 10: [mem 0xdfdff000-0xdfdfffff]
pci 0000:00:02.0: supports D1 D2
pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:02.0: PME# disabled
pci 0000:00:02.1: reg 10: [mem 0xdfdfec00-0xdfdfecff]
pci 0000:00:02.1: supports D1 D2
pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:02.1: PME# disabled
pci 0000:00:05.0: reg 10: [mem 0xdfdf8000-0xdfdfbfff]
pci 0000:00:05.0: PME# supported from D3hot D3cold
pci 0000:00:05.0: PME# disabled
pci 0000:00:06.0: reg 20: [io  0xffa0-0xffaf]
pci 0000:00:08.0: reg 10: [io  0xd480-0xd487]
pci 0000:00:08.0: reg 14: [io  0xd400-0xd403]
pci 0000:00:08.0: reg 18: [io  0xd080-0xd087]
pci 0000:00:08.0: reg 1c: [io  0xd000-0xd003]
pci 0000:00:08.0: reg 20: [io  0xcc00-0xcc0f]
pci 0000:00:08.0: reg 24: [mem 0xdfdfd000-0xdfdfdfff]
pci 0000:00:09.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:09.0: PME# disabled
pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0b.0: PME# disabled
pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0c.0: PME# disabled
pci 0000:00:0d.0: reg 10: [mem 0xde000000-0xdeffffff]
pci 0000:00:0d.0: reg 14: [mem 0xc0000000-0xcfffffff 64bit pref]
pci 0000:00:0d.0: reg 1c: [mem 0xdd000000-0xddffffff 64bit]
pci 0000:00:0d.0: reg 30: [mem 0xdfdc0000-0xdfddffff pref]
PCI: peer root bus 00 res updated from pci conf
pci 0000:01:07.0: reg 10: [io  0xe800-0xe8ff]
pci 0000:01:07.0: reg 14: [mem 0xdfeffc00-0xdfeffcff]
pci 0000:01:07.0: supports D1 D2
pci 0000:01:07.0: PME# supported from D1 D2 D3hot
pci 0000:01:07.0: PME# disabled
pci 0000:00:04.0: PCI bridge to [bus 01-01] (subtractive decode)
pci 0000:00:04.0:   bridge window [io  0xe000-0xefff]
pci 0000:00:04.0:   bridge window [mem 0xdfe00000-0xdfefffff]
pci 0000:00:04.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:00:04.0:   bridge window [io  0x0000-0xffff] (subtractive decode)
pci 0000:00:04.0:   bridge window [mem 0xc0000000-0xffffffff] (subtractive decode)
pci 0000:00:04.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
pci 0000:00:09.0: PCI bridge to [bus 02-02]
pci 0000:00:09.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:09.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
pci 0000:00:09.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:00:0b.0: PCI bridge to [bus 03-03]
pci 0000:00:0b.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:0b.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
pci 0000:00:0b.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:04:00.0: reg 10: [mem 0xdffc0000-0xdfffffff 64bit]
pci 0000:04:00.0: reg 30: [mem 0xdffa0000-0xdffbffff pref]
pci 0000:04:00.0: PME# supported from D3hot D3cold
pci 0000:04:00.0: PME# disabled
pci 0000:04:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=3Dforce'
pci 0000:00:0c.0: PCI bridge to [bus 04-04]
pci 0000:00:0c.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:0c.0:   bridge window [mem 0xdff00000-0xdfffffff]
pci 0000:00:0c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR11._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR12._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 7 10 11 14) *0, disabled.
ACPI: PCI Interrupt Link [LNKB] (IRQs 7 10 *11 14)
ACPI: PCI Interrupt Link [LNKC] (IRQs 7 10 11 14) *0, disabled.
ACPI: PCI Interrupt Link [LNKD] (IRQs 7 10 11 14) *0, disabled.
ACPI: PCI Interrupt Link [LNEA] (IRQs 7 10 *11 14)
ACPI: PCI Interrupt Link [LNEB] (IRQs 7 10 11 14) *0, disabled.
ACPI: PCI Interrupt Link [LNEC] (IRQs 7 10 11 14) *0, disabled.
ACPI: PCI Interrupt Link [LNED] (IRQs 7 10 11 14) *0, disabled.
ACPI: PCI Interrupt Link [LUB0] (IRQs 7 10 *11 14)
ACPI: PCI Interrupt Link [LUB2] (IRQs 7 *10 11 14)
ACPI: PCI Interrupt Link [LMAC] (IRQs 7 10 11 14) *0, disabled.
ACPI: PCI Interrupt Link [LAZA] (IRQs 7 10 *11 14)
ACPI: PCI Interrupt Link [LACI] (IRQs 7 10 11 14) *0, disabled.
ACPI: PCI Interrupt Link [LMC9] (IRQs 7 10 *11 14)
ACPI: PCI Interrupt Link [LSMB] (IRQs 7 *10 11 14)
ACPI: PCI Interrupt Link [LPMU] (IRQs 7 10 11 14) *0, disabled.
ACPI: PCI Interrupt Link [LSA0] (IRQs *15)
ACPI: PCI Interrupt Link [LSA1] (IRQs 5) *0, disabled.
ACPI: PCI Interrupt Link [LATA] (IRQs 7 10 11 14) *0, disabled.
HEST: Table is not found!
vgaarb: device added: PCI:0000:00:0d.0,decodes=3Dio+mem,owns=3Dio+mem,locks=3Dnone
vgaarb: loaded
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
raid6: int32x1    617 MB/s
raid6: int32x2    832 MB/s
raid6: int32x4    675 MB/s
raid6: int32x8    507 MB/s
raid6: mmxx1     1937 MB/s
raid6: mmxx2     3566 MB/s
raid6: sse1x1    1867 MB/s
raid6: sse1x2    3140 MB/s
raid6: sse2x1    3210 MB/s
raid6: sse2x2    4273 MB/s
raid6: using algorithm sse2x2 (4273 MB/s)
ACPI: WMI: Mapper loaded
PCI: Using ACPI for IRQ routing
PCI: pci_cache_line_size set to 64 bytes
reserve RAM buffer: 000000000009fc00 - 000000000009ffff 
reserve RAM buffer: 00000000affc0000 - 00000000afffffff 
NetLabel: Initializing
NetLabel:  domain hash size =3D 128
NetLabel:  protocols =3D UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
hpet0: 3 comparators, 32-bit 25.000000 MHz counter
Switching to clocksource hpet
Slow work thread pool: Starting up
Slow work thread pool: Ready
FS-Cache: Loaded
CacheFiles: Loaded
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 16 devices
ACPI: ACPI bus type pnp unregistered
PnPBIOS: Disabled by ACPI PNP
system 00:07: [io  0x04d0-0x04d1] has been reserved
system 00:07: [io  0x0800-0x080f] has been reserved
system 00:07: [io  0x0500-0x057f] has been reserved
system 00:07: [io  0x0580-0x05ff] has been reserved
system 00:07: [io  0x0800-0x087f] could not be reserved
system 00:07: [io  0x0880-0x08ff] has been reserved
system 00:07: [io  0x0d00-0x0d7f] has been reserved
system 00:07: [io  0x0d80-0x0dff] has been reserved
system 00:07: [io  0x2000-0x207f] has been reserved
system 00:07: [io  0x2080-0x20ff] has been reserved
system 00:07: [mem 0x000d0000-0x000d3fff window] has been reserved
system 00:07: [mem 0x000d4000-0x000d7fff window] has been reserved
system 00:07: [mem 0x000de000-0x000dffff window] has been reserved
system 00:07: [mem 0xfefe0000-0xfefe01ff] has been reserved
system 00:07: [mem 0xfefe1000-0xfefe1fff] has been reserved
system 00:07: [mem 0xfee01000-0xfeefffff] has been reserved
system 00:07: [mem 0xffb80000-0xffffffff] has been reserved
system 00:07: [mem 0xff300000-0xff3fffff] has been reserved
system 00:09: [mem 0xfec00000-0xfec00fff] has been reserved
system 00:09: [mem 0xfee00000-0xfee00fff] has been reserved
system 00:09: [mem 0xb0000000-0xbfffffff] has been reserved
system 00:0c: [io  0x0230-0x023f] has been reserved
system 00:0c: [io  0x0290-0x029f] has been reserved
system 00:0c: [io  0x0a00-0x0a0f] has been reserved
system 00:0c: [io  0x0a10-0x0a1f] has been reserved
system 00:0e: [mem 0xe0000000-0xefffffff] has been reserved
system 00:0f: [mem 0x00000000-0x0009ffff] could not be reserved
system 00:0f: [mem 0x000c0000-0x000cffff] could not be reserved
system 00:0f: [mem 0x000e0000-0x000fffff] could not be reserved
system 00:0f: [mem 0x00100000-0xafffffff] could not be reserved
system 00:0f: [mem 0xff780000-0xffffffff] could not be reserved
pci 0000:00:04.0: PCI bridge to [bus 01-01]
pci 0000:00:04.0:   bridge window [io  0xe000-0xefff]
pci 0000:00:04.0:   bridge window [mem 0xdfe00000-0xdfefffff]
pci 0000:00:04.0:   bridge window [mem pref disabled]
pci 0000:00:09.0: PCI bridge to [bus 02-02]
pci 0000:00:09.0:   bridge window [io  disabled]
pci 0000:00:09.0:   bridge window [mem disabled]
pci 0000:00:09.0:   bridge window [mem pref disabled]
pci 0000:00:0b.0: PCI bridge to [bus 03-03]
pci 0000:00:0b.0:   bridge window [io  disabled]
pci 0000:00:0b.0:   bridge window [mem disabled]
pci 0000:00:0b.0:   bridge window [mem pref disabled]
pci 0000:00:0c.0: PCI bridge to [bus 04-04]
pci 0000:00:0c.0:   bridge window [io  disabled]
pci 0000:00:0c.0:   bridge window [mem 0xdff00000-0xdfffffff]
pci 0000:00:0c.0:   bridge window [mem pref disabled]
pci 0000:00:04.0: setting latency timer to 64
pci 0000:00:09.0: setting latency timer to 64
pci 0000:00:0b.0: setting latency timer to 64
pci 0000:00:0c.0: setting latency timer to 64
pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
pci_bus 0000:00: resource 5 [mem 0xc0000000-0xffffffff]
pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:01: resource 0 [io  0xe000-0xefff]
pci_bus 0000:01: resource 1 [mem 0xdfe00000-0xdfefffff]
pci_bus 0000:01: resource 4 [io  0x0000-0xffff]
pci_bus 0000:01: resource 5 [mem 0xc0000000-0xffffffff]
pci_bus 0000:01: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:04: resource 1 [mem 0xdff00000-0xdfffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
UDP hash table entries: 512 (order: 2, 16384 bytes)
UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
NET: Registered protocol family 1
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
pci 0000:00:0d.0: Boot video device
PCI: CLS 64 bytes, default 64
Machine check injector initialized
elanfreq: error: no Elan processor found!
cpufreq-nforce2: No nForce2 chipset.
apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
apm: overridden by ACPI.
scx200: NatSemi SCx200 Driver
microcode: microcode: CPU0: AMD CPU family 0xf not supported
microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
Scanning for low memory corruption every 60 seconds
audit: initializing netlink socket (disabled)
type=3D2000 audit(1278671167.715:1): initialized
highmem bounce pool size: 64 pages
HugeTLB registered 4 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
DLM (built Jul  8 2010 21:51:02) installed
squashfs: version 4.0 (2009/01/31) Phillip Lougher
FS-Cache: Netfs 'nfs' registered for caching
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
NTFS driver 2.1.29 [Flags: R/W].
EFS: 1.0a - http://aeschi.ch.eu.org/efs/
JFFS2 version 2.2. (NAND) (SUMMARY)  =C2=A9 2001-2006 Red Hat, Inc.
ROMFS MTD (C) 2007 Red Hat, Inc.
QNX4 filesystem 0.2.3 registered.
fuse init (API version 7.14)
JFS: nTxBlock =3D 8192, nTxLock =3D 65536
SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, no debug enabled
SGI XFS Quota Management subsystem
NILFS version 2 loaded
BeFS version: 0.9.3
OCFS2 1.5.0
ocfs2: Registered cluster interface o2cb
ocfs2: Registered cluster interface user
OCFS2 DLMFS 1.5.0
OCFS2 User DLM kernel interface loaded
OCFS2 Node Manager 1.5.0
OCFS2 DLM 1.5.0
Btrfs loaded
GFS2 (built Jul  8 2010 21:52:21) installed
msgmni has been set to 1686
alg: No test for cipher_null (cipher_null-generic)
alg: No test for ecb(cipher_null) (ecb-cipher_null)
alg: No test for digest_null (digest_null-generic)
alg: No test for compress_null (compress_null-generic)
alg: No test for fcrypt (fcrypt-generic)
alg: No test for stdrng (krng)
async_tx: api initialized (async)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
pcieport 0000:00:09.0: setting latency timer to 64
pcieport 0000:00:0b.0: setting latency timer to 64
pcieport 0000:00:0c.0: setting latency timer to 64
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
cpqphp: Compaq Hot Plug PCI Controller Driver version: 0.9.8
ibmphpd: IBM Hot Plug PCI Controller Driver version: 0.6
pciehp: PCI Express Hot Plug Controller Driver version: 0.4
cpcihp_zt5550: ZT5550 CompactPCI Hot Plug Driver version: 0.2
cpcihp_generic: Generic port I/O CompactPCI Hot Plug Driver version: 0.1
cpcihp_generic: not configured, disabling.
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
acpiphp_ibm: ibm_acpiphp_init: acpi_walk_namespace failed
mdacon: MDA with 8K of memory detected.
Console: switching consoles 13-16 to MDA-2
ACPI: PCI Interrupt Link [LMC9] enabled at IRQ 11
PCI: setting IRQ 11 as level-triggered
nvidiafb 0000:00:0d.0: PCI INT A -> Link[LMC9] -> GSI 11 (level, low) -> IRQ 11
nvidiafb: Device ID: 10de03d1 
nvidiafb: CRTC0 analog found
nvidiafb: CRTC1 analog not found
i2c i2c-0: unable to read EDID block.
i2c i2c-0: unable to read EDID block.
i2c i2c-0: unable to read EDID block.
nvidiafb: EDID found from BUS2
nvidiafb: CRTC 0 appears to have a CRT attached
nvidiafb: Using CRT on CRTC 0
nvidiafb: MTRR set to ON
fbcon: NV3d (fb0) is primary device
Console: switching to colour frame buffer device 210x65
nvidiafb: PCI nVidia NV3d framebuffer (64MB @ 0xC0000000)
VIA Graphics Intergration Chipset framebuffer 2.4 initializing
vmlfb: initializing
Could not find Carillo Ranch MCH device.
no IO addresses supplied
hgafb: HGA card not detected.
hgafb: probe of hgafb.0 failed with error -22
uvesafb: failed to execute /sbin/v86d
uvesafb: make sure that the v86d helper is installed and executable
uvesafb: Getting VBE info block failed (eax=3D0x4f00, err=3D-2)
uvesafb: vbe_init() failed with -22
uvesafb: probe of uvesafb.0 failed with error -22
vesafb: cannot reserve video memory at 0xc0000000
vesafb: framebuffer at 0xc0000000, mapped to 0xfd700000, using 3072k, total 262144k
vesafb: mode is 1024x768x16, linelength=3D2048, pages=3D1
vesafb: protected mode interface info at c000:d2a0
vesafb: pmi: set display start =3D c00cd2d6, set palette =3D c00cd340
vesafb: pmi: ports =3D b4c3 b503 ba03 c003 c103 c403 c503 c603 c703 c803 c903 cc03 ce03 cf03 d003 d103 d203 d303 d403 d503 da03 ff03 
vesafb: scrolling: redraw
vesafb: Truecolor: size=3D0:5:6:5, shift=3D0:11:5:0
fb1: VESA VGA frame buffer device
vga16fb: initializing
vga16fb: mapped to 0xc00a0000
checking generic (c0000000 10000000) vs hw (a0000 10000)
fb2: VGA16 VGA frame buffer device
input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
ACPI: Power Button [PWRB]
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
ACPI: Power Button [PWRF]
ACPI: acpi_idle registered with cpuidle
ERST: Table is not found!
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Non-volatile memory driver v1.3
toshiba: not a supported Toshiba laptop
Linux agpgart interface v0.103
[drm] Initialized drm 1.1.0 20060810
[drm] radeon defaulting to userspace modesetting.
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
00:0d: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
IT8712 SuperIO detected.
parport_pc 00:06: reported by Plug and Play ACPI
parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,ECP,DMA]
FDC 0 is a post-1991 82077
brd: module loaded
loop: module loaded
Compaq SMART2 Driver (v 2.6.0)
HP CISS Driver (v 3.6.20)
MM: desc_per_page =3D 128
nbd: registered device at major 43
usbcore: registered new interface driver ub
ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
Phantom Linux Driver, version n0.9.8, init OK
Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Giometti
c2port c2port0: C2 port uc added
c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 bytes total)
Driver for timberdale has been successfully registered.
Uniform Multi-Platform E-IDE driver
amd74xx 0000:00:06.0: UDMA133 controller
amd74xx 0000:00:06.0: IDE controller (0x10de:0x03ec rev 0xa2)
amd74xx 0000:00:06.0: IDE port disabled
amd74xx 0000:00:06.0: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0xffa0-0xffa7
Probing IDE interface ide0...
hda: Hitachi HDT725050VLAT80, ATA DISK drive
hda: host max PIO5 wanted PIO255(auto-tune) selected PIO4
hda: UDMA/133 mode selected
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide_generic: please use "probe_mask=3D0x3f" module parameter for probing all legacy ISA IDE ports
ide-gd driver 1.18
hda: max request size: 512KiB
hda: 976773168 sectors (500107 MB) w/7372KiB Cache, CHS=3D60801/255/63
hda: cache flushes supported
 hda: hda1 hda2 hda3
 hda3: <minix: hda5 hda6 hda7 >
ide-cd driver 5.00
Loading iSCSI transport class v2.0-870.
rdac: device handler registered
hp_sw: device handler registered
emc: device handler registered
alua: device handler registered
fnic: Cisco FCoE HBA Driver, ver 1.4.0.145
iscsi: registered transport (tcp)
Loading Adaptec I2O RAID: Version 2.4 Build 5go
Detecting Adaptec I2O RAID controllers...
Adaptec aacraid driver 1.1-5[26400]-ms
aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
scsi: <fdomain> Detection failed (no card)
NCR53c406a: no available ports found
sym53c416.c: Version 1.0.0-ac
qlogicfas: no cards were found, please specify I/O address and IRQ using iobase=3D and irq=3D options
QLogic Fibre Channel HBA Driver: 8.03.02-k2
iscsi: registered transport (qla4xxx)
QLogic iSCSI HBA Driver
Emulex LightPulse Fibre Channel SCSI driver 8.3.12
Copyright(c) 2004-2009 Emulex.  All rights reserved.
Brocade BFA FC/FCOE SCSI driver - version: 2.1.2.1
Failed initialization of WD-7000 SCSI card!
DC390: clustering now enabled by default. If you get problems load
       with "disable_clustering=3D1" and report to maintainers
megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
megasas: 00.00.04.17.1-rc1 Thu. Oct. 29, 11:41:51 PST 2009
mpt2sas version 05.100.00.02 loaded
GDT-HA: Storage RAID Controller Driver. Version: 3.05
3ware Storage Controller device driver for Linux v1.26.02.003.
3ware 9000 Storage Controller device driver for Linux v2.26.02.014.
ppa: Version 2.07 (for Linux 2.4.x)
imm: Version 2.05 (for Linux 2.4.0)
nsp32: loading...
ipr: IBM Power RAID SCSI Device Driver version: 2.5.0 (February 11, 2010)
RocketRAID 3xxx/4xxx Controller driver v1.6 (090910)
stex: Promise SuperTrak EX Driver version: 4.6.0000.4
cxgb3i: tag itt 0x1fff, 13 bits, age 0xf, 4 bits.
iscsi: registered transport (cxgb3i)
Broadcom NetXtreme II iSCSI Driver bnx2i v2.1.1 (Mar 24, 2010)
iscsi: registered transport (bnx2i)
iscsi: registered transport (be2iscsi)
st: Version 20081215, fixed bufsize 32768, s/g segs 256
osst :I: Tape driver with OnStream support version 0.99.4
osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
SCSI Media Changer driver v0.25 
osd: LOADED open-osd 0.2.0
sata_nv 0000:00:08.0: version 3.5
ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 15
PCI: setting IRQ 15 as level-triggered
sata_nv 0000:00:08.0: PCI INT A -> Link[LSA0] -> GSI 15 (level, low) -> IRQ 15
sata_nv 0000:00:08.0: setting latency timer to 64
scsi2 : sata_nv
scsi3 : sata_nv
ata1: SATA max UDMA/133 cmd 0xd480 ctl 0xd400 bmdma 0xcc00 irq 15
ata2: SATA max UDMA/133 cmd 0xd080 ctl 0xd000 bmdma 0xcc08 irq 15
Error: Driver 'pata_platform' is already registered, aborting...
SSFDC read-only Flash Translation layer
mtdoops: mtd device (mtddev=3Dname/number) must be supplied
L440GX flash mapping: failed to find PIIX4 ISA bridge, cannot continue
device id =3D 2440
device id =3D 2480
device id =3D 24c0
device id =3D 24d0
device id =3D 25a1
device id =3D 2670
physmap-flash.0: failed to claim resource 0
SBC-GXx flash: IO:0x258-0x259 MEM:0xdc000-0xdffff
Could not find PAR responsible for SC520CDP Flash Bank #0
Trying default address 0x8400000
Could not find PAR responsible for SC520CDP Flash Bank #1
Trying default address 0x8c00000
Could not find PAR responsible for SC520CDP DIL Flash
Trying default address 0x9400000
SC520 CDP flash device: 0x800000 at 0x8400000
Failed to ioremap_nocache
NetSc520 flash device: 0x100000 at 0x200000
Failed to ioremap_nocache
Failed to ioremap_nocache
scx200_docflash: NatSemi SCx200 DOCCS Flash Driver
SNAPGEAR: failed to ioremap() BOOTCS
Generic platform RAM MTD, (c) 2004 Simtec Electronics
No recognised DiskOnChip devices found
slram: not enough parameters.
Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Nortel Networks.
pmc551: not detected
ftl_cs: FTL header not found.
No valid DiskOnChip devices found
[nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
NAND device: Manufacturer ID: 0x98, Chip ID: 0x39 (Toshiba NAND 8MiB 1,8V 8-bit)
flash size: 8 MiB
page size: 512 bytes
OOB area size: 16 bytes
sector size: 8 KiB
pages number: 16384
pages per sector: 16
bus width: 8
bits in sector size: 13
bits in page size: 9
bits in OOB size: 4
flash size with OOB: 8448 KiB
page address bytes: 3
sector address bytes: 2
options: 0x62
Scanning device for bad blocks
Creating 1 MTD partitions on "NAND 8MiB 1,8V 8-bit":
0x000000000000-0x000000800000 : "NAND simulator partition 0"
ftl_cs: FTL header not found.
usbcore: registered new interface driver alauda
onenand_wait: timeout! ctrl=3D0x0000 intr=3D0x0000
OneNAND Manufacturer: Samsung (0xec)
OneNAND 16MB 1.8V 16-bit (0x04)
OneNAND version =3D 0x001e
Lock scheme is Continuous Lock
Scanning device for bad blocks
Creating 1 MTD partitions on "OneNAND simulator":
0x000000000000-0x000001000000 : "OneNAND simulator partition"
ftl_cs: FTL header not found.
Fixed MDIO Bus: probed
Atheros(R) L2 Ethernet Driver - version 2.2.3
Copyright (c) 2007 Atheros Corporation.
e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
cnic: Broadcom NetXtreme II CNIC Driver cnic v2.1.2 (May 26, 2010)
D-Link DE-620 pocket adapter io 0x378, which is busy.
PPP generic driver version 2.4.2
PPP Deflate Compression module registered
PPP BSD Compression module registered
PPP MPPE Compression module registered
NET: Registered protocol family 24
SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels, max=3D256) (6 bit encapsulation enabled).
CSLIP: code copyright 1989 Regents of the University of California.
SLIP linefill/keepalive option.
DE600: port 0x378 busy
atp.c:v1.09=3Dac 2002/10/01 Donald Becker <becker@scyld.com>
I2O subsystem v1.325
i2o: max drivers =3D 8
I2O Configuration OSM v1.323
I2O Bus Adapter OSM v1.317
I2O Block Device OSM v1.325
I2O SCSI Peripheral OSM v1.316
I2O ProcFS OSM v1.316
Fusion MPT base driver 3.04.15
Copyright (c) 1999-2008 LSI Corporation
Fusion MPT SPI Host driver 3.04.15
Fusion MPT FC Host driver 3.04.15
Fusion MPT SAS Host driver 3.04.15
Fusion MPT misc device (ioctl) driver 3.04.15
mptctl: Registered with Fusion MPT base driver
mptctl: /dev/mptctl @ (major,minor=3D10,220)
Fusion MPT LAN driver 3.04.15
video1394: Installed video1394 module
ieee1394: raw1394: /dev/raw1394 device initialized
Intel ISA PCIC probe: not found.
Databook TCIC-2 PCMCIA probe: not found.
aoe: AoE v47 initialised.
paride: aten registered as protocol 0
paride: bpck registered as protocol 1
paride: comm registered as protocol 2
paride: dstr registered as protocol 3
paride: k951 registered as protocol 4
paride: k971 registered as protocol 5
paride: epat registered as protocol 6
paride: epia registered as protocol 7
paride: frpw registered as protocol 8
paride: friq registered as protocol 9
paride: fit2 registered as protocol 10
paride: fit3 registered as protocol 11
paride: on20 registered as protocol 12
paride: on26 registered as protocol 13
paride: ktti registered as protocol 14
bpck6: BACKPACK Protocol Driver V2.0.2
bpck6: Copyright 2001 by Micro Solutions, Inc., DeKalb IL. USA
paride: bpck6 registered as protocol 15
pd: pd version 1.05, major 45, cluster 64, nice 0
pda: Autoprobe failed
pd: no valid drive found
pcd: pcd version 1.07, major 46, nice 0
pcd0: Autoprobe failed
pcd: No CD-ROM drive found
pf: pf version 1.04, major 47, cluster 64, nice 0
pf: No ATAPI disk detected
pt: pt version 1.04, major 96
pt0: Autoprobe failed
pt: No ATAPI tape drive detected
pg: pg version 1.02, major 97
pga: Autoprobe failed
pg: No ATAPI device detected
usbcore: registered new interface driver hwa-rc
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ACPI: PCI Interrupt Link [LUB2] enabled at IRQ 10
PCI: setting IRQ 10 as level-triggered
ehci_hcd 0000:00:02.1: PCI INT B -> Link[LUB2] -> GSI 10 (level, low) -> IRQ 10
ehci_hcd 0000:00:02.1: setting latency timer to 64
ehci_hcd 0000:00:02.1: EHCI Host Controller
ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:02.1: debug port 1
ehci_hcd 0000:00:02.1: cache line size of 64 is not supported
ehci_hcd 0000:00:02.1: irq 10, io mem 0xdfdfec00
ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00
usb usb1: New USB device found, idVendor=3D1d6b, idProduct=3D0002
usb usb1: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.35-rc4-git4 ehci_hcd
usb usb1: SerialNumber: 0000:00:02.1
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
116x: driver isp116x-hcd, 03 Nov 2005
driver isp1362-hcd, 2005-04-04
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt Link [LUB0] enabled at IRQ 11
ohci_hcd 0000:00:02.0: PCI INT A -> Link[LUB0] -> GSI 11 (level, low) -> IRQ 11
ohci_hcd 0000:00:02.0: setting latency timer to 64
ohci_hcd 0000:00:02.0: OHCI Host Controller
ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:02.0: irq 11, io mem 0xdfdff000
usb usb2: New USB device found, idVendor=3D1d6b, idProduct=3D0001
usb usb2: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb2: Product: OHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.35-rc4-git4 ohci_hcd
usb usb2: SerialNumber: 0000:00:02.0
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 8 ports detected
uhci_hcd: USB Universal Host Controller Interface driver
sl811: driver sl811-hcd, 19 May 2005
r8a66597_hcd: driver r8a66597_hcd, 2009-05-26
usbcore: registered new interface driver hwa-hc
usbcore: registered new interface driver wusb-cbaf
usbcore: registered new interface driver cdc_acm
cdc_acm: v0.26:USB Abstract Control Model driver for USB modems and ISDN adapters
usbcore: registered new interface driver usblp
usbcore: registered new interface driver cdc_wdm
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usbcore: registered new interface driver ums-alauda
usbcore: registered new interface driver ums-cypress
usbcore: registered new interface driver ums-datafab
usbcore: registered new interface driver ums-freecom
usbcore: registered new interface driver ums-isd200
usbcore: registered new interface driver ums-jumpshot
usbcore: registered new interface driver ums-karma
usbcore: registered new interface driver ums-onetouch
usbcore: registered new interface driver ums-sddr09
usbcore: registered new interface driver ums-sddr55
usbcore: registered new interface driver ums-usbat
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
serio: PARKBD AT adapter on parport0
mice: PS/2 mouse device common for all mice
usbcore: registered new interface driver appletouch
usbcore: registered new interface driver bcm5974
inport.c: Didn't find InPort mouse at 0x23c
logibm.c: Didn't find Logitech busmouse at 0x23c
usbcore: registered new interface driver usb_acecad
acecad: v3.2:USB Acecad Flair tablet driver
usbcore: registered new interface driver aiptek
aiptek: v2.3 (May 2, 2007):Aiptek HyperPen USB Tablet Driver (Linux 2.6.x)
aiptek: Bryan W. Headley/Chris Atenasio/Cedric Brun/Rene van Paassen
usbcore: registered new interface driver gtco
GTCO usb driver version: 2.00.0006
usbcore: registered new interface driver kbtab
kbtab: v0.0.2:USB KB Gear JamStudio Tablet driver
usbcore: registered new interface driver wacom
wacom: v1.52:USB Wacom tablet driver
input: PC Speaker as /devices/platform/pcspkr/input/input2
i2c /dev entries driver
IR NEC protocol handler initialized
IR RC5(x) protocol handler initialized
IR RC6 protocol handler initialized
IR JVC protocol handler initialized
IR Sony protocol handler initialized
Linux video capture interface: v2.00
usbcore: registered new interface driver dabusb
dabusb: v1.54:DAB-USB Interface Driver for Linux (c)1999
md: linear personality registered for level -1
md: raid0 personality registered for level 0
md: raid1 personality registered for level 1
md: raid10 personality registered for level 10
md: raid6 personality registered for level 6
md: raid5 personality registered for level 5
md: raid4 personality registered for level 4
md: multipath personality registered for level -4
md: faulty personality registered for level -5
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.17.0-ioctl (2010-03-05) initialised: dm-devel@redhat.com
device-mapper: multipath: version 1.1.1 loaded
device-mapper: multipath round-robin: version 1.0.0 loaded
EDAC MC: Ver: 2.1.0 Jul  8 2010
EISA: Probing bus 0 at eisa.0
EISA: Cannot allocate resource for mainboard
Cannot allocate resource for EISA slot 1
Cannot allocate resource for EISA slot 2
Cannot allocate resource for EISA slot 3
Cannot allocate resource for EISA slot 4
Cannot allocate resource for EISA slot 5
Cannot allocate resource for EISA slot 6
Cannot allocate resource for EISA slot 7
Cannot allocate resource for EISA slot 8
EISA: Detected 0 cards.
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
cpuidle: using governor ladder
sdhci: Secure Digital Host Controller Interface driver
sdhci: Copyright(c) Pierre Ossman
wbsd: Winbond W83L51xD SD/MMC card interface driver
wbsd: Copyright(c) Pierre Ossman
via_sdmmc: VIA SD/MMC Card Reader driver (C) 2008 VIA Technologies, Inc.
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
dell-wmi: No known WMI GUID found
This machine doesn't have MSI-hotkeys through WMI
Topstar Laptop ACPI extras driver loaded
oprofile: using timer interrupt.
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 17
NET: Registered protocol family 33
lib80211: common routines for IEEE802.11 drivers
lib80211_crypt: registered algorithm 'NULL'
lib80211_crypt: registered algorithm 'WEP'
lib80211_crypt: registered algorithm 'CCMP'
lib80211_crypt: registered algorithm 'TKIP'
powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processor 4800+ (1 cpu cores) (version 2.20.00)
[Firmware Bug]: powernow-k8: No PSB or ACPI _PSS objects
Using IPI No-Shortcut mode
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: ATA-7: SAMSUNG HD753LJ, 1AA01104, max UDMA7
ata1.00: 1465149168 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata1.00: configured for UDMA/133
scsi 2:0:0:0: Direct-Access     ATA      SAMSUNG HD753LJ  1AA0 PQ: 0 ANSI: 5
sd 2:0:0:0: [sda] 1465149168 512-byte logical blocks: (750 GB/698 GiB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:0:0: Attached scsi generic sg0 type 0
 sda: sda1 sda2 sda3
sd 2:0:0:0: [sda] Attached SCSI disk
psmouse serio1: ID: 10 00 64
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: ATAPI: HL-DT-ST DVDRAM GSA-H66N, CB00, max UDMA/100
ata2.00: configured for UDMA/100
scsi 3:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-H66N  CB00 PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 3:0:0:0: Attached scsi CD-ROM sr0
sr 3:0:0:0: Attached scsi generic sg1 type 5
input: ImPS/2 Generic Wheel Mouse as /devices/platform/i8042/serio1/input/input4
kAFS: Red Hat AFS client v0.1 registering.
raid6test: testing the 4-disk case...
raid6test: test_disks(0, 1): faila=3D  0(D)  failb=3D  1(D)  OK
raid6test: test_disks(0, 2): faila=3D  0(D)  failb=3D  2(P)  OK
raid6test: test_disks(0, 3): faila=3D  0(D)  failb=3D  3(Q)  OK
raid6test: test_disks(1, 2): faila=3D  1(D)  failb=3D  2(P)  OK
raid6test: test_disks(1, 3): faila=3D  1(D)  failb=3D  3(Q)  OK
raid6test: test_disks(2, 3): faila=3D  2(P)  failb=3D  3(Q)  OK
raid6test: testing the 5-disk case...
raid6test: test_disks(0, 1): faila=3D  0(D)  failb=3D  1(D)  OK
raid6test: test_disks(0, 2): faila=3D  0(D)  failb=3D  2(D)  OK
raid6test: test_disks(0, 3): faila=3D  0(D)  failb=3D  3(P)  OK
raid6test: test_disks(0, 4): faila=3D  0(D)  failb=3D  4(Q)  OK
raid6test: test_disks(1, 2): faila=3D  1(D)  failb=3D  2(D)  OK
raid6test: test_disks(1, 3): faila=3D  1(D)  failb=3D  3(P)  OK
raid6test: test_disks(1, 4): faila=3D  1(D)  failb=3D  4(Q)  OK
raid6test: test_disks(2, 3): faila=3D  2(D)  failb=3D  3(P)  OK
raid6test: test_disks(2, 4): faila=3D  2(D)  failb=3D  4(Q)  OK
raid6test: test_disks(3, 4): faila=3D  3(P)  failb=3D  4(Q)  OK
raid6test: testing the 11-disk case...
raid6test: test_disks(0, 1): faila=3D  0(D)  failb=3D  1(D)  OK
raid6test: test_disks(0, 2): faila=3D  0(D)  failb=3D  2(D)  OK
raid6test: test_disks(0, 3): faila=3D  0(D)  failb=3D  3(D)  OK
raid6test: test_disks(0, 4): faila=3D  0(D)  failb=3D  4(D)  OK
raid6test: test_disks(0, 5): faila=3D  0(D)  failb=3D  5(D)  OK
raid6test: test_disks(0, 6): faila=3D  0(D)  failb=3D  6(D)  OK
raid6test: test_disks(0, 7): faila=3D  0(D)  failb=3D  7(D)  OK
raid6test: test_disks(0, 8): faila=3D  0(D)  failb=3D  8(D)  OK
raid6test: test_disks(0, 9): faila=3D  0(D)  failb=3D  9(P)  OK
raid6test: test_disks(0, 10): faila=3D  0(D)  failb=3D 10(Q)  OK
raid6test: test_disks(1, 2): faila=3D  1(D)  failb=3D  2(D)  OK
raid6test: test_disks(1, 3): faila=3D  1(D)  failb=3D  3(D)  OK
raid6test: test_disks(1, 4): faila=3D  1(D)  failb=3D  4(D)  OK
raid6test: test_disks(1, 5): faila=3D  1(D)  failb=3D  5(D)  OK
raid6test: test_disks(1, 6): faila=3D  1(D)  failb=3D  6(D)  OK
raid6test: test_disks(1, 7): faila=3D  1(D)  failb=3D  7(D)  OK
raid6test: test_disks(1, 8): faila=3D  1(D)  failb=3D  8(D)  OK
raid6test: test_disks(1, 9): faila=3D  1(D)  failb=3D  9(P)  OK
raid6test: test_disks(1, 10): faila=3D  1(D)  failb=3D 10(Q)  OK
raid6test: test_disks(2, 3): faila=3D  2(D)  failb=3D  3(D)  OK
raid6test: test_disks(2, 4): faila=3D  2(D)  failb=3D  4(D)  OK
raid6test: test_disks(2, 5): faila=3D  2(D)  failb=3D  5(D)  OK
raid6test: test_disks(2, 6): faila=3D  2(D)  failb=3D  6(D)  OK
raid6test: test_disks(2, 7): faila=3D  2(D)  failb=3D  7(D)  OK
raid6test: test_disks(2, 8): faila=3D  2(D)  failb=3D  8(D)  OK
raid6test: test_disks(2, 9): faila=3D  2(D)  failb=3D  9(P)  OK
raid6test: test_disks(2, 10): faila=3D  2(D)  failb=3D 10(Q)  OK
raid6test: test_disks(3, 4): faila=3D  3(D)  failb=3D  4(D)  OK
raid6test: test_disks(3, 5): faila=3D  3(D)  failb=3D  5(D)  OK
raid6test: test_disks(3, 6): faila=3D  3(D)  failb=3D  6(D)  OK
raid6test: test_disks(3, 7): faila=3D  3(D)  failb=3D  7(D)  OK
raid6test: test_disks(3, 8): faila=3D  3(D)  failb=3D  8(D)  OK
raid6test: test_disks(3, 9): faila=3D  3(D)  failb=3D  9(P)  OK
raid6test: test_disks(3, 10): faila=3D  3(D)  failb=3D 10(Q)  OK
raid6test: test_disks(4, 5): faila=3D  4(D)  failb=3D  5(D)  OK
raid6test: test_disks(4, 6): faila=3D  4(D)  failb=3D  6(D)  OK
raid6test: test_disks(4, 7): faila=3D  4(D)  failb=3D  7(D)  OK
raid6test: test_disks(4, 8): faila=3D  4(D)  failb=3D  8(D)  OK
raid6test: test_disks(4, 9): faila=3D  4(D)  failb=3D  9(P)  OK
raid6test: test_disks(4, 10): faila=3D  4(D)  failb=3D 10(Q)  OK
raid6test: test_disks(5, 6): faila=3D  5(D)  failb=3D  6(D)  OK
raid6test: test_disks(5, 7): faila=3D  5(D)  failb=3D  7(D)  OK
raid6test: test_disks(5, 8): faila=3D  5(D)  failb=3D  8(D)  OK
raid6test: test_disks(5, 9): faila=3D  5(D)  failb=3D  9(P)  OK
raid6test: test_disks(5, 10): faila=3D  5(D)  failb=3D 10(Q)  OK
raid6test: test_disks(6, 7): faila=3D  6(D)  failb=3D  7(D)  OK
raid6test: test_disks(6, 8): faila=3D  6(D)  failb=3D  8(D)  OK
raid6test: test_disks(6, 9): faila=3D  6(D)  failb=3D  9(P)  OK
raid6test: test_disks(6, 10): faila=3D  6(D)  failb=3D 10(Q)  OK
raid6test: test_disks(7, 8): faila=3D  7(D)  failb=3D  8(D)  OK
raid6test: test_disks(7, 9): faila=3D  7(D)  failb=3D  9(P)  OK
raid6test: test_disks(7, 10): faila=3D  7(D)  failb=3D 10(Q)  OK
raid6test: test_disks(8, 9): faila=3D  8(D)  failb=3D  9(P)  OK
raid6test: test_disks(8, 10): faila=3D  8(D)  failb=3D 10(Q)  OK
raid6test: test_disks(9, 10): faila=3D  9(P)  failb=3D 10(Q)  OK
raid6test: testing the 12-disk case...
raid6test: test_disks(0, 1): faila=3D  0(D)  failb=3D  1(D)  OK
raid6test: test_disks(0, 2): faila=3D  0(D)  failb=3D  2(D)  OK
raid6test: test_disks(0, 3): faila=3D  0(D)  failb=3D  3(D)  OK
raid6test: test_disks(0, 4): faila=3D  0(D)  failb=3D  4(D)  OK
raid6test: test_disks(0, 5): faila=3D  0(D)  failb=3D  5(D)  OK
raid6test: test_disks(0, 6): faila=3D  0(D)  failb=3D  6(D)  OK
raid6test: test_disks(0, 7): faila=3D  0(D)  failb=3D  7(D)  OK
raid6test: test_disks(0, 8): faila=3D  0(D)  failb=3D  8(D)  OK
raid6test: test_disks(0, 9): faila=3D  0(D)  failb=3D  9(D)  OK
raid6test: test_disks(0, 10): faila=3D  0(D)  failb=3D 10(P)  OK
raid6test: test_disks(0, 11): faila=3D  0(D)  failb=3D 11(Q)  OK
raid6test: test_disks(1, 2): faila=3D  1(D)  failb=3D  2(D)  OK
raid6test: test_disks(1, 3): faila=3D  1(D)  failb=3D  3(D)  OK
raid6test: test_disks(1, 4): faila=3D  1(D)  failb=3D  4(D)  OK
raid6test: test_disks(1, 5): faila=3D  1(D)  failb=3D  5(D)  OK
raid6test: test_disks(1, 6): faila=3D  1(D)  failb=3D  6(D)  OK
raid6test: test_disks(1, 7): faila=3D  1(D)  failb=3D  7(D)  OK
raid6test: test_disks(1, 8): faila=3D  1(D)  failb=3D  8(D)  OK
raid6test: test_disks(1, 9): faila=3D  1(D)  failb=3D  9(D)  OK
raid6test: test_disks(1, 10): faila=3D  1(D)  failb=3D 10(P)  OK
raid6test: test_disks(1, 11): faila=3D  1(D)  failb=3D 11(Q)  OK
raid6test: test_disks(2, 3): faila=3D  2(D)  failb=3D  3(D)  OK
raid6test: test_disks(2, 4): faila=3D  2(D)  failb=3D  4(D)  OK
raid6test: test_disks(2, 5): faila=3D  2(D)  failb=3D  5(D)  OK
raid6test: test_disks(2, 6): faila=3D  2(D)  failb=3D  6(D)  OK
raid6test: test_disks(2, 7): faila=3D  2(D)  failb=3D  7(D)  OK
raid6test: test_disks(2, 8): faila=3D  2(D)  failb=3D  8(D)  OK
raid6test: test_disks(2, 9): faila=3D  2(D)  failb=3D  9(D)  OK
raid6test: test_disks(2, 10): faila=3D  2(D)  failb=3D 10(P)  OK
raid6test: test_disks(2, 11): faila=3D  2(D)  failb=3D 11(Q)  OK
raid6test: test_disks(3, 4): faila=3D  3(D)  failb=3D  4(D)  OK
raid6test: test_disks(3, 5): faila=3D  3(D)  failb=3D  5(D)  OK
raid6test: test_disks(3, 6): faila=3D  3(D)  failb=3D  6(D)  OK
raid6test: test_disks(3, 7): faila=3D  3(D)  failb=3D  7(D)  OK
raid6test: test_disks(3, 8): faila=3D  3(D)  failb=3D  8(D)  OK
raid6test: test_disks(3, 9): faila=3D  3(D)  failb=3D  9(D)  OK
raid6test: test_disks(3, 10): faila=3D  3(D)  failb=3D 10(P)  OK
raid6test: test_disks(3, 11): faila=3D  3(D)  failb=3D 11(Q)  OK
raid6test: test_disks(4, 5): faila=3D  4(D)  failb=3D  5(D)  OK
raid6test: test_disks(4, 6): faila=3D  4(D)  failb=3D  6(D)  OK
raid6test: test_disks(4, 7): faila=3D  4(D)  failb=3D  7(D)  OK
raid6test: test_disks(4, 8): faila=3D  4(D)  failb=3D  8(D)  OK
raid6test: test_disks(4, 9): faila=3D  4(D)  failb=3D  9(D)  OK
raid6test: test_disks(4, 10): faila=3D  4(D)  failb=3D 10(P)  OK
raid6test: test_disks(4, 11): faila=3D  4(D)  failb=3D 11(Q)  OK
raid6test: test_disks(5, 6): faila=3D  5(D)  failb=3D  6(D)  OK
raid6test: test_disks(5, 7): faila=3D  5(D)  failb=3D  7(D)  OK
raid6test: test_disks(5, 8): faila=3D  5(D)  failb=3D  8(D)  OK
raid6test: test_disks(5, 9): faila=3D  5(D)  failb=3D  9(D)  OK
raid6test: test_disks(5, 10): faila=3D  5(D)  failb=3D 10(P)  OK
raid6test: test_disks(5, 11): faila=3D  5(D)  failb=3D 11(Q)  OK
raid6test: test_disks(6, 7): faila=3D  6(D)  failb=3D  7(D)  OK
raid6test: test_disks(6, 8): faila=3D  6(D)  failb=3D  8(D)  OK
raid6test: test_disks(6, 9): faila=3D  6(D)  failb=3D  9(D)  OK
raid6test: test_disks(6, 10): faila=3D  6(D)  failb=3D 10(P)  OK
raid6test: test_disks(6, 11): faila=3D  6(D)  failb=3D 11(Q)  OK
raid6test: test_disks(7, 8): faila=3D  7(D)  failb=3D  8(D)  OK
raid6test: test_disks(7, 9): faila=3D  7(D)  failb=3D  9(D)  OK
raid6test: test_disks(7, 10): faila=3D  7(D)  failb=3D 10(P)  OK
raid6test: test_disks(7, 11): faila=3D  7(D)  failb=3D 11(Q)  OK
raid6test: test_disks(8, 9): faila=3D  8(D)  failb=3D  9(D)  OK
raid6test: test_disks(8, 10): faila=3D  8(D)  failb=3D 10(P)  OK
raid6test: test_disks(8, 11): faila=3D  8(D)  failb=3D 11(Q)  OK
raid6test: test_disks(9, 10): faila=3D  9(D)  failb=3D 10(P)  OK
raid6test: test_disks(9, 11): faila=3D  9(D)  failb=3D 11(Q)  OK
raid6test: test_disks(10, 11): faila=3D 10(P)  failb=3D 11(Q)  OK
raid6test: testing the 16-disk case...
raid6test: test_disks(0, 1): faila=3D  0(D)  failb=3D  1(D)  OK
raid6test: test_disks(0, 2): faila=3D  0(D)  failb=3D  2(D)  OK
raid6test: test_disks(0, 3): faila=3D  0(D)  failb=3D  3(D)  OK
raid6test: test_disks(0, 4): faila=3D  0(D)  failb=3D  4(D)  OK
raid6test: test_disks(0, 5): faila=3D  0(D)  failb=3D  5(D)  OK
raid6test: test_disks(0, 6): faila=3D  0(D)  failb=3D  6(D)  OK
raid6test: test_disks(0, 7): faila=3D  0(D)  failb=3D  7(D)  OK
raid6test: test_disks(0, 8): faila=3D  0(D)  failb=3D  8(D)  OK
raid6test: test_disks(0, 9): faila=3D  0(D)  failb=3D  9(D)  OK
raid6test: test_disks(0, 10): faila=3D  0(D)  failb=3D 10(D)  OK
raid6test: test_disks(0, 11): faila=3D  0(D)  failb=3D 11(D)  OK
raid6test: test_disks(0, 12): faila=3D  0(D)  failb=3D 12(D)  OK
raid6test: test_disks(0, 13): faila=3D  0(D)  failb=3D 13(D)  OK
raid6test: test_disks(0, 14): faila=3D  0(D)  failb=3D 14(P)  OK
raid6test: test_disks(0, 15): faila=3D  0(D)  failb=3D 15(Q)  OK
raid6test: test_disks(1, 2): faila=3D  1(D)  failb=3D  2(D)  OK
raid6test: test_disks(1, 3): faila=3D  1(D)  failb=3D  3(D)  OK
raid6test: test_disks(1, 4): faila=3D  1(D)  failb=3D  4(D)  OK
raid6test: test_disks(1, 5): faila=3D  1(D)  failb=3D  5(D)  OK
raid6test: test_disks(1, 6): faila=3D  1(D)  failb=3D  6(D)  OK
raid6test: test_disks(1, 7): faila=3D  1(D)  failb=3D  7(D)  OK
raid6test: test_disks(1, 8): faila=3D  1(D)  failb=3D  8(D)  OK
raid6test: test_disks(1, 9): faila=3D  1(D)  failb=3D  9(D)  OK
raid6test: test_disks(1, 10): faila=3D  1(D)  failb=3D 10(D)  OK
raid6test: test_disks(1, 11): faila=3D  1(D)  failb=3D 11(D)  OK
raid6test: test_disks(1, 12): faila=3D  1(D)  failb=3D 12(D)  OK
raid6test: test_disks(1, 13): faila=3D  1(D)  failb=3D 13(D)  OK
raid6test: test_disks(1, 14): faila=3D  1(D)  failb=3D 14(P)  OK
raid6test: test_disks(1, 15): faila=3D  1(D)  failb=3D 15(Q)  OK
raid6test: test_disks(2, 3): faila=3D  2(D)  failb=3D  3(D)  OK
raid6test: test_disks(2, 4): faila=3D  2(D)  failb=3D  4(D)  OK
raid6test: test_disks(2, 5): faila=3D  2(D)  failb=3D  5(D)  OK
raid6test: test_disks(2, 6): faila=3D  2(D)  failb=3D  6(D)  OK
raid6test: test_disks(2, 7): faila=3D  2(D)  failb=3D  7(D)  OK
raid6test: test_disks(2, 8): faila=3D  2(D)  failb=3D  8(D)  OK
raid6test: test_disks(2, 9): faila=3D  2(D)  failb=3D  9(D)  OK
raid6test: test_disks(2, 10): faila=3D  2(D)  failb=3D 10(D)  OK
raid6test: test_disks(2, 11): faila=3D  2(D)  failb=3D 11(D)  OK
raid6test: test_disks(2, 12): faila=3D  2(D)  failb=3D 12(D)  OK
raid6test: test_disks(2, 13): faila=3D  2(D)  failb=3D 13(D)  OK
raid6test: test_disks(2, 14): faila=3D  2(D)  failb=3D 14(P)  OK
raid6test: test_disks(2, 15): faila=3D  2(D)  failb=3D 15(Q)  OK
raid6test: test_disks(3, 4): faila=3D  3(D)  failb=3D  4(D)  OK
raid6test: test_disks(3, 5): faila=3D  3(D)  failb=3D  5(D)  OK
raid6test: test_disks(3, 6): faila=3D  3(D)  failb=3D  6(D)  OK
raid6test: test_disks(3, 7): faila=3D  3(D)  failb=3D  7(D)  OK
raid6test: test_disks(3, 8): faila=3D  3(D)  failb=3D  8(D)  OK
raid6test: test_disks(3, 9): faila=3D  3(D)  failb=3D  9(D)  OK
raid6test: test_disks(3, 10): faila=3D  3(D)  failb=3D 10(D)  OK
raid6test: test_disks(3, 11): faila=3D  3(D)  failb=3D 11(D)  OK
raid6test: test_disks(3, 12): faila=3D  3(D)  failb=3D 12(D)  OK
raid6test: test_disks(3, 13): faila=3D  3(D)  failb=3D 13(D)  OK
raid6test: test_disks(3, 14): faila=3D  3(D)  failb=3D 14(P)  OK
raid6test: test_disks(3, 15): faila=3D  3(D)  failb=3D 15(Q)  OK
raid6test: test_disks(4, 5): faila=3D  4(D)  failb=3D  5(D)  OK
raid6test: test_disks(4, 6): faila=3D  4(D)  failb=3D  6(D)  OK
raid6test: test_disks(4, 7): faila=3D  4(D)  failb=3D  7(D)  OK
raid6test: test_disks(4, 8): faila=3D  4(D)  failb=3D  8(D)  OK
raid6test: test_disks(4, 9): faila=3D  4(D)  failb=3D  9(D)  OK
raid6test: test_disks(4, 10): faila=3D  4(D)  failb=3D 10(D)  OK
raid6test: test_disks(4, 11): faila=3D  4(D)  failb=3D 11(D)  OK
raid6test: test_disks(4, 12): faila=3D  4(D)  failb=3D 12(D)  OK
raid6test: test_disks(4, 13): faila=3D  4(D)  failb=3D 13(D)  OK
raid6test: test_disks(4, 14): faila=3D  4(D)  failb=3D 14(P)  OK
raid6test: test_disks(4, 15): faila=3D  4(D)  failb=3D 15(Q)  OK
raid6test: test_disks(5, 6): faila=3D  5(D)  failb=3D  6(D)  OK
raid6test: test_disks(5, 7): faila=3D  5(D)  failb=3D  7(D)  OK
raid6test: test_disks(5, 8): faila=3D  5(D)  failb=3D  8(D)  OK
raid6test: test_disks(5, 9): faila=3D  5(D)  failb=3D  9(D)  OK
raid6test: test_disks(5, 10): faila=3D  5(D)  failb=3D 10(D)  OK
raid6test: test_disks(5, 11): faila=3D  5(D)  failb=3D 11(D)  OK
raid6test: test_disks(5, 12): faila=3D  5(D)  failb=3D 12(D)  OK
raid6test: test_disks(5, 13): faila=3D  5(D)  failb=3D 13(D)  OK
raid6test: test_disks(5, 14): faila=3D  5(D)  failb=3D 14(P)  OK
raid6test: test_disks(5, 15): faila=3D  5(D)  failb=3D 15(Q)  OK
raid6test: test_disks(6, 7): faila=3D  6(D)  failb=3D  7(D)  OK
raid6test: test_disks(6, 8): faila=3D  6(D)  failb=3D  8(D)  OK
raid6test: test_disks(6, 9): faila=3D  6(D)  failb=3D  9(D)  OK
raid6test: test_disks(6, 10): faila=3D  6(D)  failb=3D 10(D)  OK
raid6test: test_disks(6, 11): faila=3D  6(D)  failb=3D 11(D)  OK
raid6test: test_disks(6, 12): faila=3D  6(D)  failb=3D 12(D)  OK
raid6test: test_disks(6, 13): faila=3D  6(D)  failb=3D 13(D)  OK
raid6test: test_disks(6, 14): faila=3D  6(D)  failb=3D 14(P)  OK
raid6test: test_disks(6, 15): faila=3D  6(D)  failb=3D 15(Q)  OK
raid6test: test_disks(7, 8): faila=3D  7(D)  failb=3D  8(D)  OK
raid6test: test_disks(7, 9): faila=3D  7(D)  failb=3D  9(D)  OK
raid6test: test_disks(7, 10): faila=3D  7(D)  failb=3D 10(D)  OK
raid6test: test_disks(7, 11): faila=3D  7(D)  failb=3D 11(D)  OK
raid6test: test_disks(7, 12): faila=3D  7(D)  failb=3D 12(D)  OK
raid6test: test_disks(7, 13): faila=3D  7(D)  failb=3D 13(D)  OK
raid6test: test_disks(7, 14): faila=3D  7(D)  failb=3D 14(P)  OK
raid6test: test_disks(7, 15): faila=3D  7(D)  failb=3D 15(Q)  OK
raid6test: test_disks(8, 9): faila=3D  8(D)  failb=3D  9(D)  OK
raid6test: test_disks(8, 10): faila=3D  8(D)  failb=3D 10(D)  OK
raid6test: test_disks(8, 11): faila=3D  8(D)  failb=3D 11(D)  OK
raid6test: test_disks(8, 12): faila=3D  8(D)  failb=3D 12(D)  OK
raid6test: test_disks(8, 13): faila=3D  8(D)  failb=3D 13(D)  OK
raid6test: test_disks(8, 14): faila=3D  8(D)  failb=3D 14(P)  OK
raid6test: test_disks(8, 15): faila=3D  8(D)  failb=3D 15(Q)  OK
raid6test: test_disks(9, 10): faila=3D  9(D)  failb=3D 10(D)  OK
raid6test: test_disks(9, 11): faila=3D  9(D)  failb=3D 11(D)  OK
raid6test: test_disks(9, 12): faila=3D  9(D)  failb=3D 12(D)  OK
raid6test: test_disks(9, 13): faila=3D  9(D)  failb=3D 13(D)  OK
raid6test: test_disks(9, 14): faila=3D  9(D)  failb=3D 14(P)  OK
raid6test: test_disks(9, 15): faila=3D  9(D)  failb=3D 15(Q)  OK
raid6test: test_disks(10, 11): faila=3D 10(D)  failb=3D 11(D)  OK
raid6test: test_disks(10, 12): faila=3D 10(D)  failb=3D 12(D)  OK
raid6test: test_disks(10, 13): faila=3D 10(D)  failb=3D 13(D)  OK
raid6test: test_disks(10, 14): faila=3D 10(D)  failb=3D 14(P)  OK
raid6test: test_disks(10, 15): faila=3D 10(D)  failb=3D 15(Q)  OK
raid6test: test_disks(11, 12): faila=3D 11(D)  failb=3D 12(D)  OK
raid6test: test_disks(11, 13): faila=3D 11(D)  failb=3D 13(D)  OK
raid6test: test_disks(11, 14): faila=3D 11(D)  failb=3D 14(P)  OK
raid6test: test_disks(11, 15): faila=3D 11(D)  failb=3D 15(Q)  OK
raid6test: test_disks(12, 13): faila=3D 12(D)  failb=3D 13(D)  OK
raid6test: test_disks(12, 14): faila=3D 12(D)  failb=3D 14(P)  OK
raid6test: test_disks(12, 15): faila=3D 12(D)  failb=3D 15(Q)  OK
raid6test: test_disks(13, 14): faila=3D 13(D)  failb=3D 14(P)  OK
raid6test: test_disks(13, 15): faila=3D 13(D)  failb=3D 15(Q)  OK
raid6test: test_disks(14, 15): faila=3D 14(P)  failb=3D 15(Q)  OK
raid6test: 
raid6test: complete (257 tests, 0 failures)
BIOS EDD facility v0.16 2004-Jun-25, 2 devices found
md: Waiting for all devices to be available before autodetect
md: If you don't use raid, use raid=3Dnoautodetect
md: Autodetecting RAID arrays.
md: Scanned 0 and added 0 devices.
md: autorun ...
md: ... autorun DONE.
EXT3-fs (sda1): recovery required on readonly filesystem
EXT3-fs (sda1): write access will be enabled during recovery
EXT3-fs: barriers not enabled
EXT3-fs (sda1): orphan cleanup on readonly fs
kjournald starting.  Commit interval 5 seconds
ext3_orphan_cleanup: deleting unreferenced inode 4981107
ext3_orphan_cleanup: deleting unreferenced inode 4981096
ext3_orphan_cleanup: deleting unreferenced inode 4981091
ext3_orphan_cleanup: deleting unreferenced inode 4972822
ext3_orphan_cleanup: deleting unreferenced inode 4972815
ext3_orphan_cleanup: deleting unreferenced inode 4972813
ext3_orphan_cleanup: deleting unreferenced inode 4972778
ext3_orphan_cleanup: deleting unreferenced inode 4972776
EXT3-fs (sda1): 8 orphan inodes deleted
EXT3-fs (sda1): recovery complete
EXT3-fs (sda1): mounted filesystem with ordered data mode
VFS: Mounted root (ext3 filesystem) readonly on device 8:1.
devtmpfs: mounted
Freeing unused kernel memory: 856k freed
i2c i2c-3: nForce2 SMBus adapter at 0x600
i2c i2c-4: nForce2 SMBus adapter at 0x700
ACPI: PCI Interrupt Link [LNEA] enabled at IRQ 11
atl1 0000:04:00.0: PCI INT A -> Link[LNEA] -> GSI 11 (level, low) -> IRQ 11
atl1 0000:04:00.0: setting latency timer to 64
atl1 0000:04:00.0: version 2.1.3
8139too: 8139too Fast Ethernet driver 0.9.28
ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 11
8139too 0000:01:07.0: PCI INT A -> Link[LNKB] -> GSI 11 (level, low) -> IRQ 11
8139too 0000:01:07.0: eth1: RealTek RTL8139 at 0xe800, 00:08:a1:6d:38:47, IRQ 11
k8temp 0000:00:18.3: Temperature readouts might be wrong - check erratum #141
ACPI: PCI Interrupt Link [LAZA] enabled at IRQ 11
HDA Intel 0000:00:05.0: PCI INT B -> Link[LAZA] -> GSI 11 (level, low) -> IRQ 11
hda_intel: Disable MSI for Nvidia chipset
HDA Intel 0000:00:05.0: setting latency timer to 64
rtc_cmos 00:02: RTC can wake from S4
rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one year, y3k, 114 bytes nvram, hpet irqs
input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:05.0/input/input5
EXT3-fs (sda1): using internal journal
parport0: no more devices allowed
lp: driver loaded but no devices found
usbcore: registered new interface driver uvcvideo
USB Video Class driver (v0.1.0)
rt2860sta: module is from the staging directory, the quality is unknown, you have been warned.
usbcore: registered new interface driver snd-usb-audio
EXT3-fs: barriers not enabled
EXT3-fs (sda2): warning: maximal mount count reached, running e2fsck is recommended
kjournald starting.  Commit interval 5 seconds
EXT3-fs (sda2): using internal journal
EXT3-fs (sda2): recovery complete
EXT3-fs (sda2): mounted filesystem with ordered data mode
EXT3-fs: barriers not enabled
EXT3-fs (hda1): warning: maximal mount count reached, running e2fsck is recommended
kjournald starting.  Commit interval 5 seconds
EXT3-fs (hda1): using internal journal
EXT3-fs (hda1): recovery complete
EXT3-fs (hda1): mounted filesystem with ordered data mode
EXT3-fs: barriers not enabled
EXT3-fs (sda3): warning: maximal mount count reached, running e2fsck is recommended
kjournald starting.  Commit interval 5 seconds
EXT3-fs (sda3): using internal journal
EXT3-fs (sda3): recovery complete
EXT3-fs (sda3): mounted filesystem with ordered data mode

--bound1278727932--


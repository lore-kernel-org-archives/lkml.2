Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966232Ab0GPV3M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 17:29:12 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:39626 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966209Ab0GPV3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 17:29:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=vzPL9w8IX45ohVDUjdHevjLvr4NFmrf1YF4mUKc1NXO6ceiFLVs1R1N/2rKKaM0fjs
         sQ700XF32m2NK8YxMxQh0fxnL9VWRmOustO7GZn4vkb91xIrPN4UheNjGmPk9Qi2/ASA
         dD6FlbB4QXHrTA9x83tEOPgY+cXbijYTksA8I=
MIME-Version: 1.0
In-Reply-To: <4C3E9F6E.1030508@intel.com>
References: <AANLkTinMqI7hmBYt4eN2oTLZt9_FkoNDHb-9ZF3Z7vls@mail.gmail.com>
	<4C2AC55E.3040303@intel.com>
	<AANLkTimzQHwVYZU73hoV4S3w9Ez43xNUrvdMkEDWCrvF@mail.gmail.com>
	<1277923422.16256.8.camel@localhost>
	<4C2B9DAC.1030806@intel.com>
	<1277928125.18854.0.camel@localhost>
	<4C2BBACF.3080405@intel.com>
	<1277965264.18854.16.camel@localhost>
	<4C2C3B07.7050200@intel.com>
	<1277968336.4945.3.camel@localhost>
	<4C2C4319.6090906@intel.com>
	<1277972137.12558.2.camel@localhost>
	<4C2CCE67.6070600@intel.com>
	<AANLkTimeNp4mMI-6IEl-zlv1DcFF5SyAD4k5O3ZLuCwM@mail.gmail.com>
	<AANLkTimNPP00pJewLtlk0SJQYjGUCyBWoxzGbTYltGsM@mail.gmail.com>
	<1278324973.16975.68.camel@localhost>
	<AANLkTimToKAxKLyONyk7KP4WXCS_FpjRjr1yWB3GCaQk@mail.gmail.com>
	<1278463901.20082.34.camel@dwillia2-linux>
	<1278474039.31393.8.camel@localhost>
	<4C34BDCD.9080607@intel.com>
	<AANLkTild7PCKygpPAJRo2G237CY8wJyveM9_Glx8qmoK@mail.gmail.com>
	<4C379462.1020704@intel.com>
	<1278720554.9522.18.camel@localhost>
	<4C3E9F6E.1030508@intel.com>
Date: Fri, 16 Jul 2010 14:29:06 -0700
X-Google-Sender-Auth: YRClZzBlLVw771Cel2uEdlA8k1I
Message-ID: <AANLkTimdPsDg4MgEI8apCM5L93f-tS3Dm75SQKcaa49-@mail.gmail.com>
Subject: Re: BUG in drivers/dma/ioat/dma_v2.c:314
From: Chris Li <lkml@chrisli.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 14, 2010 at 10:41 PM, Dan Williams <dan.j.williams@intel.com> wrote:
>
> Ok, here is a patch that takes this approach.
>
> David, will you sign off on this?
>
> Chris, I'll add a tested-by line if you can give this a shot.

The module ioatdma load and failed (correctly). But I still don't see
the line that
complain the BIOS has wrong vt-d setup.

See the dmesg follows.

Chris

Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 2.6.35-rc3+ () (gcc version 4.4.4 20100503 (Red Hat
4.4.4-2) (GCC) ) #47 SMP Fri Jul 16 11:50:27 PDT 2010
Command line: root=UUID=e953c66f-e484-4e5b-8b21-93fe8a024879 ro
nomodeset noiswmd LANG=en_US.UTF-8 SYSFONT=latarcyrheb-sun16
KEYBOARDTYPE=pc KEYTABLE=us
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007f67e000 (usable)
 BIOS-e820: 000000007f67e000 - 000000007f6ec000 (ACPI NVS)
 BIOS-e820: 000000007f6ec000 - 000000007f6ed000 (ACPI data)
 BIOS-e820: 000000007f6ed000 - 000000007f6f5000 (ACPI NVS)
 BIOS-e820: 000000007f6f5000 - 000000007f991000 (ACPI data)
 BIOS-e820: 000000007f991000 - 000000007f995000 (reserved)
 BIOS-e820: 000000007f995000 - 000000007fc00000 (ACPI data)
 BIOS-e820: 000000007fc00000 - 0000000080000000 (reserved)
 BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000280000000 (usable)
NX (Execute Disable) protection: active
DMI 2.4 present.
e820 update range: 0000000000000000 - 0000000000001000 (usable) ==> (reserved)
e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
No AGP bridge found
last_pfn = 0x280000 max_arch_pfn = 0x400000000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-FFFFF uncachable
MTRR variable ranges enabled:
  0 base 0080000000 mask 3F80000000 uncachable
  1 base 007FC00000 mask 3FFFC00000 uncachable
  2 base 0000000000 mask 3000000000 write-back
  3 disabled
  4 disabled
  5 disabled
  6 disabled
  7 disabled
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
original variable MTRRs
reg 0, base: 2GB, range: 2GB, type UC
reg 1, base: 2044MB, range: 4MB, type UC
reg 2, base: 0GB, range: 64GB, type WB
total RAM covered: 63484M
Found optimal setting for mtrr clean up
 gran_size: 64K 	chunk_size: 8M 	num_reg: 6  	lose cover RAM: 0G
New variable MTRRs
reg 0, base: 0GB, range: 2GB, type WB
reg 1, base: 2044MB, range: 4MB, type UC
reg 2, base: 4GB, range: 4GB, type WB
reg 3, base: 8GB, range: 8GB, type WB
reg 4, base: 16GB, range: 16GB, type WB
reg 5, base: 32GB, range: 32GB, type WB
e820 update range: 000000007fc00000 - 0000000100000000 (usable) ==> (reserved)
last_pfn = 0x7f67e max_arch_pfn = 0x400000000
initial memory mapped : 0 - 20000000
found SMP MP-table at [ffff8800000fec60] fec60
init_memory_mapping: 0000000000000000-000000007f67e000
 0000000000 - 007f600000 page 2M
 007f600000 - 007f67e000 page 4k
kernel direct mapping tables up to 7f67e000 @ 8000-c000
init_memory_mapping: 0000000100000000-0000000280000000
 0100000000 - 0280000000 page 2M
kernel direct mapping tables up to 280000000 @ a000-15000
RAMDISK: 3736a000 - 37ff0000
ACPI: RSDP 00000000000fe020 00024 (v02 APPLE )
ACPI: XSDT 000000007f7441c0 000F4 (v01 APPLE   Apple00 0000006C      01000013)
ACPI: FACP 000000007f740000 000F4 (v04 APPLE   Apple00 0000006C Loki 0000005F)
ACPI: DSDT 000000007f737000 049CC (v01 APPLE   Apple00 00010001 Loki 0000005F)
ACPI: FACS 000000007f68b000 00040
ACPI: ECDT 000000007f742000 00053 (v01 APPLE   Apple00 00000001 Loki 0000005F)
ACPI: HPET 000000007f73f000 00038 (v01 APPLE   Apple00 00000001 Loki 0000005F)
ACPI: APIC 000000007f73d000 000BC (v02 APPLE   Apple00 00000000 Loki 0000005F)
ACPI: MCFG 000000007f73c000 0003C (v01 APPLE   Apple00 00000001 Loki 0000005F)
ACPI: SSDT 000000007f736000 00146 (v01  PmRef  Cpu0Cst 00003001 INTL 20061109)
ACPI: SSDT 000000007f735000 0034B (v01 CPUPST  Cpu0Ist 00000012 INTL 20061109)
ACPI: SSDT 000000007f734000 00047 (v01  PmRef  Cpu1Cst 00003000 INTL 20061109)
ACPI: SSDT 000000007f733000 00337 (v01 CPUPST  Cpu1Ist 00000012 INTL 20061109)
ACPI: SSDT 000000007f732000 00047 (v01  PmRef  Cpu2Cst 00003000 INTL 20061109)
ACPI: SSDT 000000007f731000 00337 (v01 CPUPST  Cpu2Ist 00000012 INTL 20061109)
ACPI: SSDT 000000007f730000 00047 (v01  PmRef  Cpu3Cst 00003000 INTL 20061109)
ACPI: SSDT 000000007f72f000 00337 (v01 CPUPST  Cpu3Ist 00000012 INTL 20061109)
ACPI: SSDT 000000007f72e000 00047 (v01  PmRef  Cpu4Cst 00003000 INTL 20061109)
ACPI: SSDT 000000007f72d000 00337 (v01 CPUPST  Cpu4Ist 00000012 INTL 20061109)
ACPI: SSDT 000000007f72c000 00047 (v01  PmRef  Cpu5Cst 00003000 INTL 20061109)
ACPI: SSDT 000000007f72b000 00337 (v01 CPUPST  Cpu5Ist 00000012 INTL 20061109)
ACPI: SSDT 000000007f72a000 00047 (v01  PmRef  Cpu6Cst 00003000 INTL 20061109)
ACPI: SSDT 000000007f729000 00337 (v01 CPUPST  Cpu6Ist 00000012 INTL 20061109)
ACPI: SSDT 000000007f728000 00047 (v01  PmRef  Cpu7Cst 00003000 INTL 20061109)
ACPI: SSDT 000000007f727000 00337 (v01 CPUPST  Cpu7Ist 00000012 INTL 20061109)
ACPI: SSDT 000000007f726000 0003D (v01  PmRef    CpuPm 00003000 INTL 20061109)
ACPI: SSDT 000000007f71d000 004BE (v01 PCIRef  Pci8844 00001000 INTL 20061109)
ACPI: DMAR 000000007f71a000 00088 (v01 APPLE   Apple00 00000001 Loki 0000005F)
ACPI: SSDT 000000007f724000 00892 (v01 SataRe  SataPri 00001000 INTL 20061109)
ACPI: SSDT 000000007f723000 005F4 (v01 SataRe  SataSec 00001000 INTL 20061109)
ACPI: Local APIC address 0xfee00000
No NUMA configuration found
Faking a node at 0000000000000000-0000000280000000
Initmem setup node 0 0000000000000000-0000000280000000
  NODE_DATA [0000000100000000 - 0000000100013fff]
 [ffffea0000000000-ffffea0008bfffff] PMD ->
[ffff880100200000-ffff8801071fffff] on node 0
Zone PFN ranges:
  DMA      0x00000001 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00280000
Movable zone start PFN for each node
early_node_map[3] active PFN ranges
    0: 0x00000001 -> 0x0000009f
    0: 0x00000100 -> 0x0007f67e
    0: 0x00100000 -> 0x00280000
On node 0 totalpages: 2094620
  DMA zone: 56 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 3942 pages, LIFO batch:0
  DMA32 zone: 14280 pages used for memmap
  DMA32 zone: 503478 pages, LIFO batch:31
  Normal zone: 21504 pages used for memmap
  Normal zone: 1551360 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x408
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x07] enabled)
ACPI: LAPIC (acpi_id[0x06] lapic_id[0x04] enabled)
ACPI: LAPIC (acpi_id[0x07] lapic_id[0x05] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x04] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x05] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x06] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x07] high level lint[0x1])
ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a201 base: 0xfed00000
SMP: Allowing 8 CPUs, 0 hotplug CPUs
nr_irqs_gsi: 40
early_res array is doubled to 64 at [7000 - 77ff]
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
PM: Registered nosave memory: 000000007f67e000 - 000000007f6ec000
PM: Registered nosave memory: 000000007f6ec000 - 000000007f6ed000
PM: Registered nosave memory: 000000007f6ed000 - 000000007f6f5000
PM: Registered nosave memory: 000000007f6f5000 - 000000007f991000
PM: Registered nosave memory: 000000007f991000 - 000000007f995000
PM: Registered nosave memory: 000000007f995000 - 000000007fc00000
PM: Registered nosave memory: 000000007fc00000 - 0000000080000000
PM: Registered nosave memory: 0000000080000000 - 00000000ffe00000
PM: Registered nosave memory: 00000000ffe00000 - 0000000100000000
Allocating PCI resources starting at 80000000 (gap: 80000000:7fe00000)
Booting paravirtualized kernel on bare hardware
setup_percpu: NR_CPUS:256 nr_cpumask_bits:256 nr_cpu_ids:8 nr_node_ids:1
PERCPU: Embedded 30 pages/cpu @ffff880002200000 s90304 r8192 d24384 u262144
pcpu-alloc: s90304 r8192 d24384 u262144 alloc=1*2097152
pcpu-alloc: [0] 0 1 2 3 4 5 6 7
early_res array is doubled to 128 at [10000 - 10fff]
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2058780
Policy zone: Normal
Kernel command line: root=UUID=e953c66f-e484-4e5b-8b21-93fe8a024879 ro
nomodeset noiswmd LANG=en_US.UTF-8 SYSFONT=latarcyrheb-sun16
KEYBOARDTYPE=pc KEYTABLE=us
PID hash table entries: 4096 (order: 3, 32768 bytes)
Checking aperture...
No AGP bridge found
Calgary: detecting Calgary via BIOS EBDA area
Calgary: Unable to locate Rio Grande table in EBDA - bailing!
Subtract (62 early reservations)
  #1 [0001000000 - 0001deed10]   TEXT DATA BSS
  #2 [003736a000 - 0037ff0000]         RAMDISK
  #3 [0001def000 - 0001def1f1]             BRK
  #4 [000009fc00 - 00000fec60]   BIOS reserved
  #5 [00000fec60 - 00000fec70]    MP-table mpf
  #6 [00000feea4 - 0000100000]   BIOS reserved
  #7 [00000fec70 - 00000feea4]    MP-table mpc
  #8 [0000001000 - 0000003000]      TRAMPOLINE
  #9 [0000003000 - 0000007000]     ACPI WAKEUP
  #10 [0000008000 - 000000a000]         PGTABLE
  #11 [000000a000 - 0000010000]         PGTABLE
  #12 [0100000000 - 0100014000]       NODE_DATA
  #13 [0001def200 - 0001df0200]         BOOTMEM
  #14 [00021f0200 - 00021f0800]         BOOTMEM
  #15 [0100014000 - 0100015000]         BOOTMEM
  #16 [0100015000 - 0100016000]         BOOTMEM
  #17 [0100200000 - 0107200000]        MEMMAP 0
  #18 [0001deed40 - 0001deeec0]         BOOTMEM
  #19 [0001df0200 - 0001e08200]         BOOTMEM
  #20 [0001e08200 - 0001e20200]         BOOTMEM
  #21 [0001e21000 - 0001e22000]         BOOTMEM
  #22 [0001deeec0 - 0001deef01]         BOOTMEM
  #23 [0001deef40 - 0001deef83]         BOOTMEM
  #24 [0001e20200 - 0001e20510]         BOOTMEM
  #25 [0001e20540 - 0001e205a8]         BOOTMEM
  #26 [0001e205c0 - 0001e20628]         BOOTMEM
  #27 [0001e20640 - 0001e206a8]         BOOTMEM
  #28 [0001e206c0 - 0001e20728]         BOOTMEM
  #29 [0001e20740 - 0001e207a8]         BOOTMEM
  #30 [0001e207c0 - 0001e20828]         BOOTMEM
  #31 [0001e20840 - 0001e208a8]         BOOTMEM
  #32 [0001e208c0 - 0001e20928]         BOOTMEM
  #33 [0001e20940 - 0001e209a8]         BOOTMEM
  #34 [0001e209c0 - 0001e20a28]         BOOTMEM
  #35 [0001e20a40 - 0001e20aa8]         BOOTMEM
  #36 [0001e20ac0 - 0001e20b28]         BOOTMEM
  #37 [0001e20b40 - 0001e20ba8]         BOOTMEM
  #38 [0001deefc0 - 0001deefe0]         BOOTMEM
  #39 [0001e20bc0 - 0001e20be0]         BOOTMEM
  #40 [0001e20c00 - 0001e20c8b]         BOOTMEM
  #41 [0001e20cc0 - 0001e20d4b]         BOOTMEM
  #42 [0002200000 - 000221e000]         BOOTMEM
  #43 [0002240000 - 000225e000]         BOOTMEM
  #44 [0002280000 - 000229e000]         BOOTMEM
  #45 [00022c0000 - 00022de000]         BOOTMEM
  #46 [0002300000 - 000231e000]         BOOTMEM
  #47 [0002340000 - 000235e000]         BOOTMEM
  #48 [0002380000 - 000239e000]         BOOTMEM
  #49 [00023c0000 - 00023de000]         BOOTMEM
  #50 [0001e20d80 - 0001e20d88]         BOOTMEM
  #51 [0001e20dc0 - 0001e20dc8]         BOOTMEM
  #52 [0001e20e00 - 0001e20e20]         BOOTMEM
  #53 [0001e20e40 - 0001e20e80]         BOOTMEM
  #54 [0001e20e80 - 0001e20fa0]         BOOTMEM
  #55 [0001e24000 - 0001e24048]         BOOTMEM
  #56 [0001e24080 - 0001e240c8]         BOOTMEM
  #57 [0001e24100 - 0001e2c100]         BOOTMEM
  #58 [00023de000 - 00063de000]         BOOTMEM
  #59 [0001e2c100 - 0001e4c100]         BOOTMEM
  #60 [0001e4c100 - 0001e8c100]         BOOTMEM
  #61 [0000011000 - 0000019000]         BOOTMEM
Memory: 8169400k/10485760k available (4310k kernel code, 2107280k
absent, 209080k reserved, 6880k data, 1508k init)
SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
Hierarchical RCU implementation.
	RCU-based detection of stalled CPUs is disabled.
	Verbose stalled-CPUs detection is disabled.
NR_IRQS:16640 nr_irqs:744
Extended CMOS year: 2000
Console: colour VGA+ 80x25
console [tty0] enabled
allocated 83886080 bytes of page_cgroup
please try 'cgroup_disable=memory' option if you don't want memory cgroups
hpet clockevent registered
Fast TSC calibration using PIT
Detected 2793.017 MHz processor.
Calibrating delay loop (skipped), value calculated using timer
frequency.. 5586.03 BogoMIPS (lpj=2793017)
pid_max: default: 32768 minimum: 301
Security Framework initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
Mount-cache hash table entries: 256
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
Initializing cgroup subsys memory
Initializing cgroup subsys devices
Initializing cgroup subsys freezer
Initializing cgroup subsys net_cls
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 6 MCE banks
CPU0: Thermal monitoring enabled (TM2)
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
ftrace: converting mcount calls to 0f 1f 44 00 00
ftrace: allocating 20113 entries in 79 pages
DMAR: Host address width 38
DMAR: DRHD base: 0x000000fe710000 flags: 0x0
IOMMU 0: reg_base_addr fe710000 ver 1:0 cap 900000c2f0462 ecap e01
DMAR: DRHD base: 0x000000fe714000 flags: 0x0
IOMMU 1: reg_base_addr fe714000 ver 1:0 cap 900000c2f0462 ecap e01
DMAR: DRHD base: 0x000000fe719000 flags: 0x0
IOMMU 2: reg_base_addr fe719000 ver 1:0 cap 900000c2f0462 ecap e01
DMAR: DRHD base: 0x000000fe718000 flags: 0x1
IOMMU 3: reg_base_addr fe718000 ver 1:0 cap 900000c2f0462 ecap e01
DMAR: No RMRR found
DMAR: No ATSR found
Setting APIC routing to flat
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Xeon(R) CPU           E5462  @ 2.80GHz stepping 06
Booting Node   0, Processors  #1 #2 #3 #4 #5 #6 #7 Ok.
Brought up 8 CPUs
Total of 8 processors activated (44687.71 BogoMIPS).
regulator: core version 0.5
Time: 13:57:43  Date: 07/16/10
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem
0xe0000000-0xefffffff] (base 0xe0000000)
PCI: not using MMCONFIG
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: EC: EC description table is found, configuring boot EC
ACPI: BIOS _OSI(Linux) query ignored
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S4 S5)
ACPI: BIOS offers _GTS
ACPI: If "acpi.gts=1" improves suspend, please notify linux-acpi@vger.kernel.org
ACPI: Using IOAPIC for interrupt routing
PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem
0xe0000000-0xefffffff] (base 0xe0000000)
PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI
motherboard resources
ACPI: EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
ACPI: No dock devices found.
PCI: Using host bridge windows from ACPI; if necessary, use
"pci=nocrs" and report a bug
ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
pci_root PNP0A08:00: host bridge window [mem 0x000d8000-0x000dbfff]
pci_root PNP0A08:00: host bridge window [mem 0x80000000-0xfe000000]
pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
pci 0000:00:00.0: PME# disabled
pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
pci 0000:00:01.0: PME# disabled
pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
pci 0000:00:05.0: PME# disabled
pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
pci 0000:00:09.0: PME# disabled
pci 0000:00:0f.0: reg 10: [mem 0x90b00000-0x90b03fff 64bit]
pci 0000:00:1b.0: reg 10: [mem 0x90b04000-0x90b07fff 64bit]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: PME# disabled
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.1: PME# disabled
pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.2: PME# disabled
pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.3: PME# disabled
pci 0000:00:1d.0: reg 20: [io  0x30a0-0x30bf]
pci 0000:00:1d.1: reg 20: [io  0x3080-0x309f]
pci 0000:00:1d.2: reg 20: [io  0x3060-0x307f]
pci 0000:00:1d.3: reg 20: [io  0x3040-0x305f]
pci 0000:00:1d.7: reg 10: [mem 0x90b08400-0x90b087ff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1f.1: reg 10: [io  0x30e8-0x30ef]
pci 0000:00:1f.1: reg 14: [io  0x30fc-0x30ff]
pci 0000:00:1f.1: reg 18: [io  0x30e0-0x30e7]
pci 0000:00:1f.1: reg 1c: [io  0x30f8-0x30fb]
pci 0000:00:1f.1: reg 20: [io  0x30c0-0x30cf]
pci 0000:00:1f.2: reg 10: [io  0x30d8-0x30df]
pci 0000:00:1f.2: reg 14: [io  0x30f4-0x30f7]
pci 0000:00:1f.2: reg 18: [io  0x30d0-0x30d7]
pci 0000:00:1f.2: reg 1c: [io  0x30f0-0x30f3]
pci 0000:00:1f.2: reg 20: [io  0x3020-0x302f]
pci 0000:00:1f.2: reg 24: [mem 0x90b08000-0x90b083ff]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.2: PME# disabled
pci 0000:00:1f.3: reg 20: [io  0x3000-0x301f]
pci 0000:00:01.0: PCI bridge to [bus 01-01]
pci 0000:00:01.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:01.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
pci 0000:00:01.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:02:00.0: reg 10: [mem 0x80000000-0x8fffffff 64bit pref]
pci 0000:02:00.0: reg 18: [mem 0x90a20000-0x90a2ffff 64bit]
pci 0000:02:00.0: reg 20: [io  0x2000-0x20ff]
pci 0000:02:00.0: reg 30: [mem 0x90a00000-0x90a1ffff pref]
pci 0000:02:00.0: supports D1 D2
pci 0000:00:05.0: PCI bridge to [bus 02-02]
pci 0000:00:05.0:   bridge window [io  0x2000-0x2fff]
pci 0000:00:05.0:   bridge window [mem 0x90a00000-0x90afffff]
pci 0000:00:05.0:   bridge window [mem 0x80000000-0x8fffffff 64bit pref]
pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
pci 0000:03:00.0: PME# disabled
pci 0000:03:00.3: PME# supported from D0 D3hot D3cold
pci 0000:03:00.3: PME# disabled
pci 0000:03:00.0: disabling ASPM on pre-1.1 PCIe device.  You can
enable it with 'pcie_aspm=force'
pci 0000:00:09.0: PCI bridge to [bus 03-08]
pci 0000:00:09.0:   bridge window [io  0x1000-0x1fff]
pci 0000:00:09.0:   bridge window [mem 0x90000000-0x908fffff]
pci 0000:00:09.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:04:00.0: PME# supported from D0 D3hot D3cold
pci 0000:04:00.0: PME# disabled
pci 0000:04:00.0: disabling ASPM on pre-1.1 PCIe device.  You can
enable it with 'pcie_aspm=force'
pci 0000:04:01.0: PME# supported from D0 D3hot D3cold
pci 0000:04:01.0: PME# disabled
pci 0000:04:00.0: disabling ASPM on pre-1.1 PCIe device.  You can
enable it with 'pcie_aspm=force'
pci 0000:04:02.0: PME# supported from D0 D3hot D3cold
pci 0000:04:02.0: PME# disabled
pci 0000:04:00.0: disabling ASPM on pre-1.1 PCIe device.  You can
enable it with 'pcie_aspm=force'
pci 0000:03:00.0: PCI bridge to [bus 04-07]
pci 0000:03:00.0:   bridge window [io  0x1000-0x1fff]
pci 0000:03:00.0:   bridge window [mem 0x90000000-0x908fffff]
pci 0000:03:00.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:04:00.0: PCI bridge to [bus 05-05]
pci 0000:04:00.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:04:00.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
pci 0000:04:00.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:04:01.0: PCI bridge to [bus 06-06]
pci 0000:04:01.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:04:01.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
pci 0000:04:01.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:07:00.0: reg 10: [mem 0x90820000-0x9083ffff]
pci 0000:07:00.0: reg 14: [mem 0x90400000-0x907fffff]
pci 0000:07:00.0: reg 18: [io  0x1020-0x103f]
pci 0000:07:00.0: PME# supported from D0 D3hot D3cold
pci 0000:07:00.0: PME# disabled
pci 0000:07:00.1: reg 10: [mem 0x90800000-0x9081ffff]
pci 0000:07:00.1: reg 14: [mem 0x90000000-0x903fffff]
pci 0000:07:00.1: reg 18: [io  0x1000-0x101f]
pci 0000:07:00.1: PME# supported from D0 D3hot D3cold
pci 0000:07:00.1: PME# disabled
pci 0000:07:00.0: disabling ASPM on pre-1.1 PCIe device.  You can
enable it with 'pcie_aspm=force'
pci 0000:04:02.0: PCI bridge to [bus 07-07]
pci 0000:04:02.0:   bridge window [io  0x1000-0x1fff]
pci 0000:04:02.0:   bridge window [mem 0x90000000-0x908fffff]
pci 0000:04:02.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:03:00.3: PCI bridge to [bus 08-08]
pci 0000:03:00.3:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:03:00.3:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
pci 0000:03:00.3:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:00:1c.0: PCI bridge to [bus 09-09]
pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:00:1c.1: PCI bridge to [bus 0a-0a]
pci 0000:00:1c.1:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:1c.1:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
pci 0000:00:1c.1:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:0b:00.0: supports D1 D2
pci 0000:00:1c.2: PCI bridge to [bus 0b-0c]
pci 0000:00:1c.2:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:1c.2:   bridge window [mem 0x90900000-0x909fffff]
pci 0000:00:1c.2:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:0c:00.0: reg 10: [mem 0x90904000-0x909047ff]
pci 0000:0c:00.0: reg 14: [mem 0x90900000-0x90903fff]
pci 0000:0c:00.0: supports D1 D2
pci 0000:0c:00.0: PME# supported from D0 D1 D2 D3hot
pci 0000:0c:00.0: PME# disabled
pci 0000:0b:00.0: PCI bridge to [bus 0c-0c]
pci 0000:0b:00.0:   bridge window [io  0xfffffffffffff000-0x0000] (disabled)
pci 0000:0b:00.0:   bridge window [mem 0x90900000-0x909fffff]
pci 0000:0b:00.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:00:1c.3: PCI bridge to [bus 0d-0d]
pci 0000:00:1c.3:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:1c.3:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
pci 0000:00:1c.3:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:00:1e.0: PCI bridge to [bus 0e-0e] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff]
(subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff]
(subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x80000000-0xfe000000]
(subtractive decode)
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9.P9P2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9.P9P2.P2P5._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9.P9P2.P2P3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9.P9P2.P2P4._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP04._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NRP5._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NRP1._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 5 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKB] (IRQs 5 7 9 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKC] (IRQs 5 7 9 *10 11)
ACPI: PCI Interrupt Link [LNKD] (IRQs 5 7 *9 10 11)
ACPI: PCI Interrupt Link [LNKE] (IRQs 5 7 9 10 11) *3
ACPI: PCI Interrupt Link [LNKF] (IRQs *5 7 9 10 11)
ACPI: PCI Interrupt Link [LNKG] (IRQs 5 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKH] (IRQs 5 7 9 *10 11)
vgaarb: device added: PCI:0000:02:00.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: pci_cache_line_size set to 64 bytes
reserve RAM buffer: 000000000009fc00 - 000000000009ffff
reserve RAM buffer: 000000007f67e000 - 000000007fffffff
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
HPET: 3 timers in total, 0 timers will be used for per-cpu timer
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 comparators, 64-bit 14.318180 MHz counter
Switching to clocksource tsc
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 10 devices
ACPI: ACPI bus type pnp unregistered
system 00:01: [mem 0xe0000000-0xefffffff] has been reserved
system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
system 00:01: [mem 0xffc00000-0xffffffff] could not be reserved
system 00:01: [mem 0xfec00000-0xfecfffff] could not be reserved
system 00:01: [mem 0xfee00000-0xfeefffff] has been reserved
system 00:01: [mem 0xfe700000-0xfe7003ff] has been reserved
system 00:01: [mem 0xfe600000-0xfe6fffff] has been reserved
system 00:01: [mem 0xfe000000-0xfe01ffff] could not be reserved
system 00:08: [io  0x0320-0x037f] has been reserved
system 00:08: [io  0x0400-0x047f] has been reserved
system 00:08: [io  0x0500-0x053f] has been reserved
system 00:08: [io  0x0872-0x0875] has been reserved
pci 0000:00:1c.0: BAR 14: assigned [mem 0x90c00000-0x90dfffff]
pci 0000:00:1c.0: BAR 15: assigned [mem 0x90e00000-0x90ffffff 64bit pref]
pci 0000:00:1c.1: BAR 14: assigned [mem 0x91000000-0x911fffff]
pci 0000:00:1c.1: BAR 15: assigned [mem 0x91200000-0x913fffff 64bit pref]
pci 0000:00:1c.2: BAR 15: assigned [mem 0x91400000-0x915fffff 64bit pref]
pci 0000:00:1c.3: BAR 14: assigned [mem 0x91600000-0x917fffff]
pci 0000:00:1c.3: BAR 15: assigned [mem 0x91800000-0x919fffff 64bit pref]
pci 0000:00:1c.0: BAR 13: assigned [io  0x4000-0x4fff]
pci 0000:00:1c.1: BAR 13: assigned [io  0x5000-0x5fff]
pci 0000:00:1c.2: BAR 13: assigned [io  0x6000-0x6fff]
pci 0000:00:1c.3: BAR 13: assigned [io  0x7000-0x7fff]
pci 0000:00:01.0: PCI bridge to [bus 01-01]
pci 0000:00:01.0:   bridge window [io  disabled]
pci 0000:00:01.0:   bridge window [mem disabled]
pci 0000:00:01.0:   bridge window [mem pref disabled]
pci 0000:00:05.0: PCI bridge to [bus 02-02]
pci 0000:00:05.0:   bridge window [io  0x2000-0x2fff]
pci 0000:00:05.0:   bridge window [mem 0x90a00000-0x90afffff]
pci 0000:00:05.0:   bridge window [mem 0x80000000-0x8fffffff 64bit pref]
pci 0000:04:00.0: PCI bridge to [bus 05-05]
pci 0000:04:00.0:   bridge window [io  disabled]
pci 0000:04:00.0:   bridge window [mem disabled]
pci 0000:04:00.0:   bridge window [mem pref disabled]
pci 0000:04:01.0: PCI bridge to [bus 06-06]
pci 0000:04:01.0:   bridge window [io  disabled]
pci 0000:04:01.0:   bridge window [mem disabled]
pci 0000:04:01.0:   bridge window [mem pref disabled]
pci 0000:04:02.0: PCI bridge to [bus 07-07]
pci 0000:04:02.0:   bridge window [io  0x1000-0x1fff]
pci 0000:04:02.0:   bridge window [mem 0x90000000-0x908fffff]
pci 0000:04:02.0:   bridge window [mem pref disabled]
pci 0000:03:00.0: PCI bridge to [bus 04-07]
pci 0000:03:00.0:   bridge window [io  0x1000-0x1fff]
pci 0000:03:00.0:   bridge window [mem 0x90000000-0x908fffff]
pci 0000:03:00.0:   bridge window [mem pref disabled]
pci 0000:03:00.3: PCI bridge to [bus 08-08]
pci 0000:03:00.3:   bridge window [io  disabled]
pci 0000:03:00.3:   bridge window [mem disabled]
pci 0000:03:00.3:   bridge window [mem pref disabled]
pci 0000:00:09.0: PCI bridge to [bus 03-08]
pci 0000:00:09.0:   bridge window [io  0x1000-0x1fff]
pci 0000:00:09.0:   bridge window [mem 0x90000000-0x908fffff]
pci 0000:00:09.0:   bridge window [mem pref disabled]
pci 0000:00:1c.0: PCI bridge to [bus 09-09]
pci 0000:00:1c.0:   bridge window [io  0x4000-0x4fff]
pci 0000:00:1c.0:   bridge window [mem 0x90c00000-0x90dfffff]
pci 0000:00:1c.0:   bridge window [mem 0x90e00000-0x90ffffff 64bit pref]
pci 0000:00:1c.1: PCI bridge to [bus 0a-0a]
pci 0000:00:1c.1:   bridge window [io  0x5000-0x5fff]
pci 0000:00:1c.1:   bridge window [mem 0x91000000-0x911fffff]
pci 0000:00:1c.1:   bridge window [mem 0x91200000-0x913fffff 64bit pref]
pci 0000:0b:00.0: PCI bridge to [bus 0c-0c]
pci 0000:0b:00.0:   bridge window [io  disabled]
pci 0000:0b:00.0:   bridge window [mem 0x90900000-0x909fffff]
pci 0000:0b:00.0:   bridge window [mem pref disabled]
pci 0000:00:1c.2: PCI bridge to [bus 0b-0c]
pci 0000:00:1c.2:   bridge window [io  0x6000-0x6fff]
pci 0000:00:1c.2:   bridge window [mem 0x90900000-0x909fffff]
pci 0000:00:1c.2:   bridge window [mem 0x91400000-0x915fffff 64bit pref]
pci 0000:00:1c.3: PCI bridge to [bus 0d-0d]
pci 0000:00:1c.3:   bridge window [io  0x7000-0x7fff]
pci 0000:00:1c.3:   bridge window [mem 0x91600000-0x917fffff]
pci 0000:00:1c.3:   bridge window [mem 0x91800000-0x919fffff 64bit pref]
pci 0000:00:1e.0: PCI bridge to [bus 0e-0e]
pci 0000:00:1e.0:   bridge window [io  disabled]
pci 0000:00:1e.0:   bridge window [mem disabled]
pci 0000:00:1e.0:   bridge window [mem pref disabled]
  alloc irq_desc for 16 on node -1
  alloc kstat_irqs on node -1
pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:01.0: setting latency timer to 64
pci 0000:00:05.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:05.0: setting latency timer to 64
pci 0000:00:09.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:09.0: setting latency timer to 64
pci 0000:03:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:03:00.0: setting latency timer to 64
pci 0000:04:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:04:00.0: setting latency timer to 64
  alloc irq_desc for 17 on node -1
  alloc kstat_irqs on node -1
pci 0000:04:01.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
pci 0000:04:01.0: setting latency timer to 64
  alloc irq_desc for 18 on node -1
  alloc kstat_irqs on node -1
pci 0000:04:02.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
pci 0000:04:02.0: setting latency timer to 64
pci 0000:03:00.3: setting latency timer to 64
pci 0000:00:1c.0: enabling device (0000 -> 0003)
pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.0: setting latency timer to 64
pci 0000:00:1c.1: enabling device (0000 -> 0003)
pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:1c.1: setting latency timer to 64
pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
pci 0000:00:1c.2: setting latency timer to 64
pci 0000:0b:00.0: setting latency timer to 64
pci 0000:00:1c.3: enabling device (0000 -> 0003)
  alloc irq_desc for 19 on node -1
  alloc kstat_irqs on node -1
pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
pci 0000:00:1c.3: setting latency timer to 64
pci 0000:00:1e.0: power state changed by ACPI to D0
pci 0000:00:1e.0: power state changed by ACPI to D0
pci 0000:00:1e.0: setting latency timer to 64
pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: resource 7 [mem 0x000d8000-0x000dbfff]
pci_bus 0000:00: resource 8 [mem 0x80000000-0xfe000000]
pci_bus 0000:02: resource 0 [io  0x2000-0x2fff]
pci_bus 0000:02: resource 1 [mem 0x90a00000-0x90afffff]
pci_bus 0000:02: resource 2 [mem 0x80000000-0x8fffffff 64bit pref]
pci_bus 0000:03: resource 0 [io  0x1000-0x1fff]
pci_bus 0000:03: resource 1 [mem 0x90000000-0x908fffff]
pci_bus 0000:04: resource 0 [io  0x1000-0x1fff]
pci_bus 0000:04: resource 1 [mem 0x90000000-0x908fffff]
pci_bus 0000:07: resource 0 [io  0x1000-0x1fff]
pci_bus 0000:07: resource 1 [mem 0x90000000-0x908fffff]
pci_bus 0000:09: resource 0 [io  0x4000-0x4fff]
pci_bus 0000:09: resource 1 [mem 0x90c00000-0x90dfffff]
pci_bus 0000:09: resource 2 [mem 0x90e00000-0x90ffffff 64bit pref]
pci_bus 0000:0a: resource 0 [io  0x5000-0x5fff]
pci_bus 0000:0a: resource 1 [mem 0x91000000-0x911fffff]
pci_bus 0000:0a: resource 2 [mem 0x91200000-0x913fffff 64bit pref]
pci_bus 0000:0b: resource 0 [io  0x6000-0x6fff]
pci_bus 0000:0b: resource 1 [mem 0x90900000-0x909fffff]
pci_bus 0000:0b: resource 2 [mem 0x91400000-0x915fffff 64bit pref]
pci_bus 0000:0c: resource 1 [mem 0x90900000-0x909fffff]
pci_bus 0000:0d: resource 0 [io  0x7000-0x7fff]
pci_bus 0000:0d: resource 1 [mem 0x91600000-0x917fffff]
pci_bus 0000:0d: resource 2 [mem 0x91800000-0x919fffff 64bit pref]
pci_bus 0000:0e: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:0e: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:0e: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:0e: resource 7 [mem 0x000d8000-0x000dbfff]
pci_bus 0000:0e: resource 8 [mem 0x80000000-0xfe000000]
NET: Registered protocol family 2
IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 524288 bind 65536)
TCP reno registered
UDP hash table entries: 4096 (order: 5, 131072 bytes)
UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
NET: Registered protocol family 1
pci 0000:00:1f.0: rerouting interrupts for [8086:2670]
pci 0000:02:00.0: Boot video device
PCI: CLS mismatch (256 != 64), using 64 bytes
Trying to unpack rootfs image as initramfs...
Freeing initrd memory: 12824k freed
IOMMU 2 0xfe719000: using Register based invalidation
IOMMU 1 0xfe714000: using Register based invalidation
IOMMU 0 0xfe710000: using Register based invalidation
IOMMU 3 0xfe718000: using Register based invalidation
IOMMU: Setting RMRR:
IOMMU: Prepare 0-16MiB unity mapping for LPC
IOMMU: Setting identity map for device 0000:00:1f.0 [0x0 - 0x1000000]
  alloc irq_desc for 40 on node 0
  alloc kstat_irqs on node 0
  alloc irq_desc for 41 on node 0
  alloc kstat_irqs on node 0
  alloc irq_desc for 42 on node 0
  alloc kstat_irqs on node 0
  alloc irq_desc for 43 on node 0
  alloc kstat_irqs on node 0
PCI-DMA: Intel(R) Virtualization Technology for Directed I/O
audit: initializing netlink socket (disabled)
type=2000 audit(1279288663.009:1): initialized
HugeTLB registered 2 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
msgmni has been set to 16109
SELinux:  Registering netfilter hooks
alg: No test for stdrng (krng)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
pcieport 0000:00:01.0: setting latency timer to 64
  alloc irq_desc for 44 on node -1
  alloc kstat_irqs on node -1
pcieport 0000:00:01.0: irq 44 for MSI/MSI-X
pcieport 0000:00:05.0: setting latency timer to 64
  alloc irq_desc for 45 on node -1
  alloc kstat_irqs on node -1
pcieport 0000:00:05.0: irq 45 for MSI/MSI-X
pcieport 0000:00:09.0: setting latency timer to 64
  alloc irq_desc for 46 on node -1
  alloc kstat_irqs on node -1
pcieport 0000:00:09.0: irq 46 for MSI/MSI-X
pcieport 0000:00:1c.0: setting latency timer to 64
  alloc irq_desc for 47 on node -1
  alloc kstat_irqs on node -1
pcieport 0000:00:1c.0: irq 47 for MSI/MSI-X
pcieport 0000:00:1c.1: setting latency timer to 64
  alloc irq_desc for 48 on node -1
  alloc kstat_irqs on node -1
pcieport 0000:00:1c.1: irq 48 for MSI/MSI-X
pcieport 0000:00:1c.2: setting latency timer to 64
  alloc irq_desc for 49 on node -1
  alloc kstat_irqs on node -1
pcieport 0000:00:1c.2: irq 49 for MSI/MSI-X
pcieport 0000:00:1c.3: setting latency timer to 64
  alloc irq_desc for 50 on node -1
  alloc kstat_irqs on node -1
pcieport 0000:00:1c.3: irq 50 for MSI/MSI-X
pcieport 0000:03:00.0: setting latency timer to 64
pcieport 0000:04:00.0: setting latency timer to 64
  alloc irq_desc for 51 on node -1
  alloc kstat_irqs on node -1
pcieport 0000:04:00.0: irq 51 for MSI/MSI-X
pcieport 0000:04:01.0: setting latency timer to 64
  alloc irq_desc for 52 on node -1
  alloc kstat_irqs on node -1
pcieport 0000:04:01.0: irq 52 for MSI/MSI-X
pcieport 0000:04:02.0: setting latency timer to 64
  alloc irq_desc for 53 on node -1
  alloc kstat_irqs on node -1
pcieport 0000:04:02.0: irq 53 for MSI/MSI-X
aer 0000:00:01.0:pcie02: service driver aer loaded
aer 0000:00:05.0:pcie02: service driver aer loaded
aer 0000:00:09.0:pcie02: service driver aer loaded
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
Firmware did not grant requested _OSC control
Firmware did not grant requested _OSC control
Firmware did not grant requested _OSC control
Firmware did not grant requested _OSC control
Firmware did not grant requested _OSC control
Firmware did not grant requested _OSC control
Firmware did not grant requested _OSC control
Firmware did not grant requested _OSC control
pciehp: PCI Express Hot Plug Controller Driver version: 0.4
acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
pci-stub: invalid id string ""
input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
ACPI: Power Button [PWRB]
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
ACPI: Power Button [PWRF]
ACPI: acpi_idle registered with cpuidle
Monitor-Mwait will be used to enter C-1 state
Non-volatile memory driver v1.3
Linux agpgart interface v0.103
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
brd: module loaded
loop: module loaded
ata_piix 0000:00:1f.1: version 2.13
  alloc irq_desc for 20 on node -1
  alloc kstat_irqs on node -1
ata_piix 0000:00:1f.1: PCI INT A -> GSI 20 (level, low) -> IRQ 20
ata_piix 0000:00:1f.1: setting latency timer to 64
scsi0 : ata_piix
scsi1 : ata_piix
ata1: PATA max UDMA/100 cmd 0x30e8 ctl 0x30fc bmdma 0x30c0 irq 20
ata2: PATA max UDMA/100 cmd 0x30e0 ctl 0x30f8 bmdma 0x30c8 irq 20
  alloc irq_desc for 21 on node -1
  alloc kstat_irqs on node -1
ata_piix 0000:00:1f.2: PCI INT B -> GSI 21 (level, low) -> IRQ 21
ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
ata_piix 0000:00:1f.2: setting latency timer to 64
scsi2 : ata_piix
scsi3 : ata_piix
ata3: SATA max UDMA/133 cmd 0x30d8 ctl 0x30f4 bmdma 0x3020 irq 21
ata4: SATA max UDMA/133 cmd 0x30d0 ctl 0x30f0 bmdma 0x3028 irq 21
Fixed MDIO Bus: probed
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 19 (level, low) -> IRQ 19
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
ehci_hcd 0000:00:1d.7: irq 19, io mem 0x90b08400
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.35-rc3+ ehci_hcd
usb usb1: SerialNumber: 0000:00:1d.7
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: irq 19, io base 0x000030a0
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: UHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.35-rc3+ uhci_hcd
usb usb2: SerialNumber: 0000:00:1d.0
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 20 (level, low) -> IRQ 20
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: irq 20, io base 0x00003080
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.35-rc3+ uhci_hcd
usb usb3: SerialNumber: 0000:00:1d.1
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: irq 21, io base 0x00003060
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.35-rc3+ uhci_hcd
usb usb4: SerialNumber: 0000:00:1d.2
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
  alloc irq_desc for 22 on node -1
  alloc kstat_irqs on node -1
uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 22 (level, low) -> IRQ 22
uhci_hcd 0000:00:1d.3: setting latency timer to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.3: irq 22, io base 0x00003040
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.35-rc3+ uhci_hcd
usb usb5: SerialNumber: 0000:00:1d.3
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
PNP: No PS/2 controller found. Probing ports directly.
i8042.c: No controller found.
mice: PS/2 mouse device common for all mice
rtc_cmos 00:07: RTC can wake from S4
rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.17.0-ioctl (2010-03-05) initialised: dm-devel@redhat.com
cpuidle: using governor ladder
cpuidle: using governor menu
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
nf_conntrack.acct=1 kernel parameter, acct=1 nf_conntrack module option or
sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
ip_tables: (C) 2000-2006 Netfilter Core Team
TCP cubic registered
NET: Registered protocol family 17
PM: Resume from disk failed.
registered taskstats version 1
IMA: No TPM chip found, activating TPM-bypass!
  Magic number: 2:30:989
rtc_cmos 00:07: setting system clock to 2010-07-16 13:57:44 UTC (1279288664)
Initalizing network drop monitor service
ata1.00: ATAPI: PIONEER DVD-RW  DVR-112D, BC14, max UDMA/66
ata3.00: ATA-8: ST3750330AS, SD15, max UDMA/133
ata3.00: 1465149168 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata1.00: configured for UDMA/66
scsi 0:0:0:0: CD-ROM            PIONEER  DVD-RW  DVR-112D BC14 PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 32x/32x writer cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 0:0:0:0: Attached scsi CD-ROM sr0
sr 0:0:0:0: Attached scsi generic sg0 type 5
ata3.01: ATA-7: ST3320820AS_P, 3.BQE, max UDMA/133
ata3.01: 625142448 sectors, multi 0: LBA48 NCQ (depth 0/32)
ata4.00: ATA-7: ST3400620AS, 3.AAK, max UDMA/133
ata4.00: 781422768 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata3.00: configured for UDMA/133
ata3.01: configured for UDMA/133
scsi 2:0:0:0: Direct-Access     ATA      ST3750330AS      SD15 PQ: 0 ANSI: 5
sd 2:0:0:0: Attached scsi generic sg1 type 0
sd 2:0:0:0: [sda] 1465149168 512-byte logical blocks: (750 GB/698 GiB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sda: sda1
scsi 2:0:1:0: Direct-Access     ATA      ST3320820AS_P    3.BQ PQ: 0 ANSI: 5
sd 2:0:1:0: Attached scsi generic sg2 type 0
sd 2:0:1:0: [sdb] 625142448 512-byte logical blocks: (320 GB/298 GiB)
sd 2:0:1:0: [sdb] Write Protect is off
sd 2:0:1:0: [sdb] Mode Sense: 00 3a 00 00
sd 2:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA

 sdb:
sd 2:0:0:0: [sda] Attached SCSI disk
ata4.00: configured for UDMA/133
scsi 3:0:0:0: Direct-Access     ATA      ST3400620AS      3.AA PQ: 0 ANSI: 5
sd 3:0:0:0: [sdc] 781422768 512-byte logical blocks: (400 GB/372 GiB)
sd 3:0:0:0: Attached scsi generic sg3 type 0
sd 3:0:0:0: [sdc] Write Protect is off
sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sdc: sdb1 sdb2
sd 2:0:1:0: [sdb] Attached SCSI disk
 sdc1 sdc2 sdc3 sdc4 sdc5
sd 3:0:0:0: [sdc] Attached SCSI disk
Freeing unused kernel memory: 1508k freed
Write protecting the kernel read-only data: 10240k
Freeing unused kernel memory: 1816k freed
Freeing unused kernel memory: 1968k freed
dracut: dracut-005-3.fc13
udev: starting version 151
[drm] Initialized drm 1.1.0 20060810
[drm] VGACON disable radeon kernel modesetting.
pci 0000:02:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
pci 0000:02:00.0: setting latency timer to 64
[drm] Initialized radeon 1.33.0 20080528 for 0000:02:00.0 on minor 0
dracut: Starting plymouth daemon
firewire_ohci 0000:0c:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
usb 2-1: new full speed USB device using uhci_hcd and address 2
firewire_ohci: Added fw-ohci device 0000:0c:00.0, OHCI v1.10, 8 IR + 8
IT contexts, quirks 0x2
usb 2-1: New USB device found, idVendor=05a4, idProduct=9835
usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 2-1: Product: USB Keyboard Hub
usb 2-1: Manufacturer: ORTEK
hub 2-1:1.0: USB hub found
hub 2-1:1.0: 3 ports detected
usb 4-2: new full speed USB device using uhci_hcd and address 2
EXT4-fs (sdc2): mounted filesystem with ordered data mode. Opts: (null)
dracut: Mounted root filesystem /dev/sdc2
firewire_core: created device fw0: GUID 001ff3fffe8908b0, S800
firewire_core: phy config: card 0, new root=ffc1, gap_count=5
usb 4-2: New USB device found, idVendor=05ac, idProduct=1000
usb 4-2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
dracut: Loading SELinux policy
input: HID 05ac:1000 as
/devices/pci0000:00/0000:00:1d.2/usb4/4-2/4-2:1.0/input/input2
generic-usb 0003:05AC:1000.0001: input,hidraw0: USB HID v1.11 Keyboard
[HID 05ac:1000] on usb-0000:00:1d.2-2/input0
input: HID 05ac:1000 as
/devices/pci0000:00/0000:00:1d.2/usb4/4-2/4-2:1.1/input/input3
generic-usb 0003:05AC:1000.0002: input,hidraw1: USB HID v1.11 Mouse
[HID 05ac:1000] on usb-0000:00:1d.2-2/input1
usb 2-1.3: new full speed USB device using uhci_hcd and address 3
usb 2-1.3: New USB device found, idVendor=05a4, idProduct=9860
usb 2-1.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 2-1.3: Product: USB Keyboard Hub
usb 2-1.3: Manufacturer: ORTEK
input: ORTEK USB Keyboard Hub as
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.3/2-1.3:1.0/input/input4
generic-usb 0003:05A4:9860.0003: input,hidraw2: USB HID v1.10 Keyboard
[ORTEK USB Keyboard Hub] on usb-0000:00:1d.0-1.3/input0
input: ORTEK USB Keyboard Hub as
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.3/2-1.3:1.1/input/input5
generic-usb 0003:05A4:9860.0004: input,hidraw3: USB HID v1.10 Device
[ORTEK USB Keyboard Hub] on usb-0000:00:1d.0-1.3/input1
SELinux: 2048 avtab hash slots, 196346 rules.
SELinux: 2048 avtab hash slots, 196346 rules.
SELinux:  9 users, 13 roles, 3270 types, 159 bools, 1 sens, 1024 cats
SELinux:  77 classes, 196346 rules
SELinux:  Completing initialization.
SELinux:  Setting up existing superblocks.
SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
SELinux: initialized (dev proc, type proc), uses genfs_contexts
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
SELinux: initialized (dev debugfs, type debugfs), uses genfs_contexts
SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
SELinux: initialized (dev anon_inodefs, type anon_inodefs), uses genfs_contexts
SELinux: initialized (dev devpts, type devpts), uses transition SIDs
SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses transition SIDs
SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
SELinux: initialized (dev selinuxfs, type selinuxfs), uses genfs_contexts
SELinux: initialized (dev usbfs, type usbfs), uses genfs_contexts
SELinux: initialized (dev securityfs, type securityfs), uses genfs_contexts
SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
SELinux: initialized (dev sdc2, type ext4), uses xattr
type=1403 audit(1279288666.234:2): policy loaded auid=4294967295 ses=4294967295
dracut: Switching root
readahead-collector: starting
udev: starting version 151
usb 4-2: usbfs: USBDEVFS_CONTROL failed cmd hid2hci rqt 64 rq 0 len 0 ret -75
usb 4-2: USB disconnect, address 2
usb 4-2: new full speed USB device using uhci_hcd and address 3
usb 4-2: New USB device found, idVendor=05ac, idProduct=8206
usb 4-2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
iTCO_vendor_support: vendor-support=0
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.06
iTCO_wdt: unable to reset NO_REBOOT flag, platform may have disabled it
i801_smbus 0000:00:1f.3: PCI INT B -> GSI 21 (level, low) -> IRQ 21
ACPI: resource 0000:00:1f.3 [io  0x3000-0x301f] conflicts with ACPI
region SMBI [mem 0x00003000-0x0000300f window]
ACPI: If an ACPI driver is available for this device, you should use
it instead of the native driver
applesmc: Apple MacPro3 detected:
applesmc:  - Model without accelerometer
applesmc:  - Model without light sensors and backlight
applesmc:  - Model with 40 temperature sensors
applesmc: device successfully initialized.
applesmc: 4 fans found.
applesmc: driver successfully loaded.
i5k_amb: probe of i5k_amb.0 failed with error -16
Bluetooth: Core ver 2.15
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
Bluetooth: Generic Bluetooth USB driver ver 0.6
usbcore: registered new interface driver btusb
e1000e: Intel(R) PRO/1000 Network Driver - 1.0.2-k4
e1000e: Copyright (c) 1999 - 2009 Intel Corporation.
e1000e 0000:07:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
e1000e 0000:07:00.0: setting latency timer to 64
  alloc irq_desc for 54 on node -1
  alloc kstat_irqs on node -1
e1000e 0000:07:00.0: irq 54 for MSI/MSI-X
e1000e 0000:07:00.0: eth0: (PCI Express:2.5GB/s:Width x4) 00:1f:5b:39:85:28
e1000e 0000:07:00.0: eth0: Intel(R) PRO/1000 Network Connection
e1000e 0000:07:00.0: eth0: MAC: 5, PHY: 5, PBA No: 3070ff-0ff
e1000e 0000:07:00.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
e1000e 0000:07:00.1: setting latency timer to 64
  alloc irq_desc for 55 on node -1
  alloc kstat_irqs on node -1
e1000e 0000:07:00.1: irq 55 for MSI/MSI-X
e1000e 0000:07:00.1: eth1: (PCI Express:2.5GB/s:Width x4) 00:1f:5b:39:85:29
e1000e 0000:07:00.1: eth1: Intel(R) PRO/1000 Network Connection
e1000e 0000:07:00.1: eth1: MAC: 5, PHY: 5, PBA No: 3070ff-0ff
EDAC MC: Ver: 2.1.0 Jun 29 2010
EDAC MC0: Giving out device to 'i5400_edac.c' 'I5400': DEV 0000:00:10.0
EDAC PCI0: Giving out device to module 'i5400_edac' controller 'EDAC
PCI controller': DEV '0000:00:10.0' (POLLED)
  alloc irq_desc for 23 on node -1
  alloc kstat_irqs on node -1
HDA Intel 0000:00:1b.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
  alloc irq_desc for 56 on node -1
  alloc kstat_irqs on node -1
HDA Intel 0000:00:1b.0: irq 56 for MSI/MSI-X
HDA Intel 0000:00:1b.0: setting latency timer to 64
hda_codec: ALC889A: SKU not ready 0x400000f0
input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input6
EXT4-fs (sdc2): re-mounted. Opts: (null)
EXT4-fs (sdc1): mounted filesystem with ordered data mode. Opts: (null)
SELinux: initialized (dev sdc1, type ext4), uses xattr
EXT3-fs: barriers not enabled
kjournald starting.  Commit interval 5 seconds
EXT3-fs (sdc5): using internal journal
EXT3-fs (sdc5): mounted filesystem with ordered data mode
SELinux: initialized (dev sdc5, type ext3), uses xattr
Adding 9215996k swap on /dev/sdc4.  Priority:-1 extents:1 across:9215996k
SELinux: initialized (dev binfmt_misc, type binfmt_misc), uses genfs_contexts
readahead-disable-service: delaying service auditd
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
ip6_tables: (C) 2000-2006 Netfilter Core Team
e1000e 0000:07:00.0: irq 54 for MSI/MSI-X
e1000e 0000:07:00.0: irq 54 for MSI/MSI-X
ADDRCONF(NETDEV_UP): eth0: link is not ready
e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
SELinux: initialized (dev rpc_pipefs, type rpc_pipefs), uses genfs_contexts
SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
Bluetooth: L2CAP ver 2.14
Bluetooth: L2CAP socket layer initialized
Bluetooth: BNEP (Ethernet Emulation) ver 1.3
Bluetooth: BNEP filters: protocol multicast
Bridge firewalling registered
Bluetooth: SCO (Voice Link) ver 0.6
Bluetooth: SCO socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM ver 1.11
readahead-collector: starting delayed service auditd
readahead-collector: sorting
readahead-collector: finished
fuse init (API version 7.14)
SELinux: initialized (dev fuse, type fuse), uses genfs_contexts
dca service started, version 1.12.1
ioatdma: Intel(R) QuickData Technology Driver 4.00
ioatdma 0000:00:0f.0: can't derive routing for PCI INT A
ioatdma 0000:00:0f.0: PCI INT A: no GSI
ioatdma 0000:00:0f.0: setting latency timer to 64
  alloc irq_desc for 57 on node -1
  alloc kstat_irqs on node -1
ioatdma 0000:00:0f.0: irq 57 for MSI/MSI-X
  alloc irq_desc for 58 on node -1
  alloc kstat_irqs on node -1
ioatdma 0000:00:0f.0: irq 58 for MSI/MSI-X
  alloc irq_desc for 59 on node -1
  alloc kstat_irqs on node -1
ioatdma 0000:00:0f.0: irq 59 for MSI/MSI-X
  alloc irq_desc for 60 on node -1
  alloc kstat_irqs on node -1
ioatdma 0000:00:0f.0: irq 60 for MSI/MSI-X
ioatdma 0000:00:0f.0: failed to start channel chanerr: 0x10
ioatdma 0000:00:0f.0: Freeing 1 in use descriptors!
ioatdma 0000:00:0f.0: selftest cannot allocate chan resource
ioatdma 0000:00:0f.0: Intel(R) I/OAT DMA Engine init failed
ioatdma 0000:00:0f.0: can't derive routing for PCI INT A

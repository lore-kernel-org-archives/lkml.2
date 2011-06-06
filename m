Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595Ab1FFLGg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 07:06:36 -0400
Received: from mail.bbaw.de ([194.95.188.6]:52109 "EHLO mail.bbaw.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754444Ab1FFLGd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 07:06:33 -0400
Date: Mon, 6 Jun 2011 13:06:28 +0200
From: Lars =?UTF-8?B?VMOkdWJlcg==?= <taeuber@bbaw.de>
To: linux-kernel@vger.kernel.org
Subject: Re: [PROBLEM] reproduceable storage errors on high IO load
Message-Id: <20110606130628.e86f0c67.taeuber@bbaw.de>
In-Reply-To: <201106060559.03131.gene.heskett@gmail.com>
References: <20110606095127.21d23a70.taeuber@bbaw.de>
	<201106060559.03131.gene.heskett@gmail.com>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="Multipart=_Mon__6_Jun_2011_13_06_28_+0200_9J0voi1iz7J4tLM4"
X-AntiVirus: checked by Avira MailGate (version: 2.1.4-7; AVE: 7.9.5.12; VDF: 7.11.9.33; host: mailhub); id=24338-mpCPZP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--Multipart=_Mon__6_Jun_2011_13_06_28_+0200_9J0voi1iz7J4tLM4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Gene,

thanks for your fast reply.

Am Mon, 6 Jun 2011 05:59:02 -0400
Gene Heskett <gene.heskett@gmail.com> schrieb:

> On Monday, June 06, 2011, Lars T=C3=A4uber wrote:
[...]
> >
> >Is there something I do wrong? Could someone help me to debug this?
> >Thanks
> >Lars
>=20
> Looking at your dmesg, I get the impression you have a bunch of disks t=
hat=20
> are in need of a firmware update.  Unforch, the dmesg snippet does not=20
> include the drive discovery and identification data.

Attached is the whole dmesg from a fresh boot up. (I hope I'm allowed to =
send this to the ML!?)
=20
> However, I would back that data up to another medium before I did that =
as I=20
> had the seagate firmware update scramble the blkid's and partition name=
s of=20
> one of two 1Tb drives I have.  Neither drive errors now, but the read/w=
rite=20
> speeds for the 2nd identical drive are about 1/3rd the rate of the firs=
t.

There is no partition table nor any data on the disks, because I never co=
uld use the array.

> Firmware updates are in the form of a bootable cd .iso, and you can=20
> download the cd image from the makers site.

I didn't find any firmware updates from WD. How do they manage to have al=
l the drivers possibly needed to talk to the disks?

Thanks again
Lars


> Cheers, gene
> --=20

--Multipart=_Mon__6_Jun_2011_13_06_28_+0200_9J0voi1iz7J4tLM4
Content-Type: text/plain;
 name="20110606.dmesg.txt"
Content-Disposition: attachment;
 filename="20110606.dmesg.txt"
Content-Transfer-Encoding: 7bit

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.39 (root@pvh3) (gcc version 4.4.3 (Ubuntu 4.4.3-4ubuntu5) ) #1 SMP Tue May 24 12:52:05 CEST 2011
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-2.6.39 root=LABEL=WURZEL ro quiet
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 0000000000095c00 (usable)
[    0.000000]  BIOS-e820: 0000000000095c00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e6000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000dfea0000 (usable)
[    0.000000]  BIOS-e820: 00000000dfea0000 - 00000000dfeb2000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000dfeb2000 - 00000000dfee0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000dfee0000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000120000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] DMI: Supermicro H8SCM/H8SCM, BIOS 1.1a       03/23/11  
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x120000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000000 mask FFFF80000000 write-back
[    0.000000]   1 base 000080000000 mask FFFFC0000000 write-back
[    0.000000]   2 base 0000C0000000 mask FFFFE0000000 write-back
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 0000000120000000 aka 4608M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000e0000000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xdfea0 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [ffff8800000ff780] ff780
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff880000090000] 90000 size 20480
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: 0000000000000000-00000000dfea0000
[    0.000000]  0000000000 - 00c0000000 page 1G
[    0.000000]  00c0000000 - 00dfe00000 page 2M
[    0.000000]  00dfe00000 - 00dfea0000 page 4k
[    0.000000] kernel direct mapping tables up to dfea0000 @ dfe9d000-dfea0000
[    0.000000] init_memory_mapping: 0000000100000000-0000000120000000
[    0.000000]  0100000000 - 0120000000 page 2M
[    0.000000] kernel direct mapping tables up to 120000000 @ 11fffe000-120000000
[    0.000000] RAMDISK: 3476c000 - 37ff0000
[    0.000000] ACPI: RSDP 00000000000f9f70 00024 (v02 ACPIAM)
[    0.000000] ACPI: XSDT 00000000dfea0100 0005C (v01 SMCI            20110323 MSFT 00000097)
[    0.000000] ACPI: FACP 00000000dfea0290 000F4 (v03 032311 FACP1656 20110323 MSFT 00000097)
[    0.000000] ACPI: DSDT 00000000dfea05e0 0590B (v01  1BA11 1BA11000 00000000 INTL 20051117)
[    0.000000] ACPI: FACS 00000000dfeb2000 00040
[    0.000000] ACPI: APIC 00000000dfea0390 00088 (v01 032311 APIC1656 20110323 MSFT 00000097)
[    0.000000] ACPI: MCFG 00000000dfea0420 0003C (v01 032311 OEMMCFG  20110323 MSFT 00000097)
[    0.000000] ACPI: OEMB 00000000dfeb2040 00075 (v01 032311 OEMB1656 20110323 MSFT 00000097)
[    0.000000] ACPI: HPET 00000000dfeaa5e0 00038 (v01 032311 OEMHPET  20110323 MSFT 00000097)
[    0.000000] ACPI: SRAT 00000000dfeaa620 00108 (v02 AMD    F10      00000001 AMD  00000001)
[    0.000000] ACPI: SSDT 00000000dfeaa730 00F36 (v01 A M I  POWERNOW 00000001 AMD  00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] SRAT: PXM 0 -> APIC 0x00 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x01 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x02 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x03 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x04 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x05 -> Node 0
[    0.000000] SRAT: Node 0 PXM 0 0-a0000
[    0.000000] SRAT: Node 0 PXM 0 100000-e0000000
[    0.000000] SRAT: Node 0 PXM 0 100000000-120000000
[    0.000000] NUMA: Node 0 [0,a0000) + [100000,e0000000) -> [0,e0000000)
[    0.000000] NUMA: Node 0 [0,e0000000) + [100000000,120000000) -> [0,120000000)
[    0.000000] NUMA: Using 63 for the hash shift.
[    0.000000] Initmem setup node 0 0000000000000000-0000000120000000
[    0.000000]   NODE_DATA [000000011fff9000 - 000000011fffdfff]
[    0.000000]  [ffffea0000000000-ffffea0003ffffff] PMD -> [ffff88011b600000-ffff88011effffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00120000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x00000095
[    0.000000]     0: 0x00000100 -> 0x000dfea0
[    0.000000]     0: 0x00100000 -> 0x00120000
[    0.000000] On node 0 totalpages: 1048101
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 5 pages reserved
[    0.000000]   DMA zone: 3912 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 898776 pages, LIFO batch:31
[    0.000000]   Normal zone: 1792 pages used for memmap
[    0.000000]   Normal zone: 129280 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 33, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8300 base: 0xfed00000
[    0.000000] SMP: Allowing 6 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 0000000000095000 - 0000000000096000
[    0.000000] PM: Registered nosave memory: 0000000000096000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e6000
[    0.000000] PM: Registered nosave memory: 00000000000e6000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000dfea0000 - 00000000dfeb2000
[    0.000000] PM: Registered nosave memory: 00000000dfeb2000 - 00000000dfee0000
[    0.000000] PM: Registered nosave memory: 00000000dfee0000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000ffe00000
[    0.000000] PM: Registered nosave memory: 00000000ffe00000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at f0000000 (gap: f0000000:fe00000)
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:6 nr_node_ids:1
[    0.000000] PERCPU: Embedded 26 pages/cpu @ffff88011fc00000 s76544 r8192 d21760 u262144
[    0.000000] pcpu-alloc: s76544 r8192 d21760 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 - - 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1031968
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-2.6.39 root=LABEL=WURZEL ro quiet
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Node 0: aperture @ cc0a000000 size 32 MB
[    0.000000] Aperture beyond 4GB. Ignoring.
[    0.000000] Your BIOS doesn't leave a aperture memory hole
[    0.000000] Please enable the IOMMU option in the BIOS setup
[    0.000000] This costs you 64 MB of RAM
[    0.000000] Mapping aperture over 65536 KB of RAM @ c0000000
[    0.000000] PM: Registered nosave memory: 00000000c0000000 - 00000000c4000000
[    0.000000] Memory: 3929568k/4718592k available (5481k kernel code, 526188k absent, 262836k reserved, 5506k data, 740k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=6, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU-based detection of stalled CPUs is disabled.
[    0.000000] NR_IRQS:4352 nr_irqs:728 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 33554432 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2095.498 MHz processor.
[    0.010003] Calibrating delay loop (skipped), value calculated using timer frequency.. 4190.99 BogoMIPS (lpj=20954980)
[    0.010008] pid_max: default: 32768 minimum: 301
[    0.010030] Security Framework initialized
[    0.010034] Smack:  Initializing.
[    0.010444] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.011617] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.012119] Mount-cache hash table entries: 256
[    0.012233] Initializing cgroup subsys ns
[    0.012236] ns_cgroup deprecated: consider using the 'clone_children' flag without the ns_cgroup.
[    0.012239] Initializing cgroup subsys cpuacct
[    0.012244] Initializing cgroup subsys memory
[    0.012252] Initializing cgroup subsys devices
[    0.012254] Initializing cgroup subsys freezer
[    0.012257] Initializing cgroup subsys net_cls
[    0.012280] tseg: 00dff00000
[    0.012283] CPU: Physical Processor ID: 0
[    0.012284] CPU: Processor Core ID: 0
[    0.012287] mce: CPU supports 6 MCE banks
[    0.012337] ACPI: Core revision 20110316
[    0.015716] ftrace: allocating 20651 entries in 81 pages
[    0.020063] Setting APIC routing to flat
[    0.020350] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.122294] CPU0: AMD Opteron(tm) Processor 4170 HE stepping 01
[    0.130000] Performance Events: AMD PMU driver.
[    0.130000] ... version:                0
[    0.130000] ... bit width:              48
[    0.130000] ... generic registers:      4
[    0.130000] ... value mask:             0000ffffffffffff
[    0.130000] ... max period:             00007fffffffffff
[    0.130000] ... fixed-purpose events:   0
[    0.130000] ... event mask:             000000000000000f
[    0.130000] Booting Node   0, Processors  #1
[    0.130000] smpboot cpu 1: start_ip = 90000
[    0.290056]  #2
[    0.290057] smpboot cpu 2: start_ip = 90000
[    0.460062]  #3
[    0.460064] smpboot cpu 3: start_ip = 90000
[    0.630062]  #4
[    0.630063] smpboot cpu 4: start_ip = 90000
[    0.800068]  #5 Ok.
[    0.800070] smpboot cpu 5: start_ip = 90000
[    0.970005] Brought up 6 CPUs
[    0.970018] Total of 6 processors activated (25148.47 BogoMIPS).
[    0.973704] devtmpfs: initialized
[    0.973704] PM: Registering ACPI NVS region at dfeb2000 (188416 bytes)
[    0.973704] print_constraints: dummy: 
[    0.973704] Time: 12:36:31  Date: 06/06/11
[    0.973704] NET: Registered protocol family 16
[    0.973704] node 0 link 0: io port [1000, ffffff]
[    0.973704] TOM: 00000000e0000000 aka 3584M
[    0.973704] Fam 10h mmconf [e0000000, efffffff]
[    0.973704] node 0 link 0: mmio [e0000000, efffffff] ==> none
[    0.973704] node 0 link 0: mmio [f0000000, ffffffff]
[    0.973704] node 0 link 0: mmio [a0000, bffff]
[    0.973704] TOM2: 0000000120000000 aka 4608M
[    0.973704] bus: [00, 1f] on node 0 link 0
[    0.973704] bus: 00 index 0 [io  0x0000-0xffff]
[    0.973704] bus: 00 index 1 [mem 0xf0000000-0xffffffff]
[    0.973704] bus: 00 index 2 [mem 0x000a0000-0x000bffff]
[    0.973704] bus: 00 index 3 [mem 0x120000000-0xfcffffffff]
[    0.973704] Extended Config Space enabled on 1 nodes
[    0.973704] ACPI: bus type pci registered
[    0.973704] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.973704] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    1.002355] PCI: Using configuration type 1 for base access
[    1.002936] bio: create slab <bio-0> at 0
[    1.002936] ACPI: EC: Look up EC in DSDT
[    1.002936] \_SB_:_OSC evaluation returned wrong type
[    1.002936] _OSC request data:1 7 
[    1.002936] ACPI: Executed 2 blocks of module-level executable AML code
[    1.030393] ACPI: Interpreter enabled
[    1.030397] ACPI: (supports S0 S1 S4 S5)
[    1.030414] ACPI: Using IOAPIC for interrupt routing
[    1.034218] ACPI: No dock devices found.
[    1.034220] HEST: Table not found.
[    1.034223] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    1.034302] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    1.034452] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    1.034455] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    1.034458] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    1.034460] pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x000dffff]
[    1.034463] pci_root PNP0A08:00: host bridge window [mem 0xf0000000-0xfebfffff]
[    1.034476] pci 0000:00:00.0: [1002:5a13] type 0 class 0x000600
[    1.034530] pci 0000:00:04.0: [1002:5a18] type 1 class 0x000604
[    1.034553] pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
[    1.034557] pci 0000:00:04.0: PME# disabled
[    1.034573] pci 0000:00:09.0: [1002:5a1c] type 1 class 0x000604
[    1.034596] pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
[    1.034598] pci 0000:00:09.0: PME# disabled
[    1.034610] pci 0000:00:0a.0: [1002:5a1d] type 1 class 0x000604
[    1.034632] pci 0000:00:0a.0: PME# supported from D0 D3hot D3cold
[    1.034635] pci 0000:00:0a.0: PME# disabled
[    1.034663] pci 0000:00:11.0: [1002:4391] type 0 class 0x000106
[    1.034682] pci 0000:00:11.0: reg 10: [io  0xb000-0xb007]
[    1.034691] pci 0000:00:11.0: reg 14: [io  0xa000-0xa003]
[    1.034701] pci 0000:00:11.0: reg 18: [io  0x9000-0x9007]
[    1.034710] pci 0000:00:11.0: reg 1c: [io  0x8000-0x8003]
[    1.034720] pci 0000:00:11.0: reg 20: [io  0x7000-0x700f]
[    1.034729] pci 0000:00:11.0: reg 24: [mem 0xfebfbc00-0xfebfbfff]
[    1.034771] pci 0000:00:12.0: [1002:4397] type 0 class 0x000c03
[    1.034784] pci 0000:00:12.0: reg 10: [mem 0xfebf9000-0xfebf9fff]
[    1.034843] pci 0000:00:12.1: [1002:4398] type 0 class 0x000c03
[    1.034856] pci 0000:00:12.1: reg 10: [mem 0xfebfa000-0xfebfafff]
[    1.034920] pci 0000:00:12.2: [1002:4396] type 0 class 0x000c03
[    1.034939] pci 0000:00:12.2: reg 10: [mem 0xfebfb800-0xfebfb8ff]
[    1.035004] pci 0000:00:12.2: supports D1 D2
[    1.035006] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    1.035010] pci 0000:00:12.2: PME# disabled
[    1.035031] pci 0000:00:13.0: [1002:4397] type 0 class 0x000c03
[    1.035044] pci 0000:00:13.0: reg 10: [mem 0xfebf7000-0xfebf7fff]
[    1.035103] pci 0000:00:13.1: [1002:4398] type 0 class 0x000c03
[    1.035116] pci 0000:00:13.1: reg 10: [mem 0xfebf8000-0xfebf8fff]
[    1.035180] pci 0000:00:13.2: [1002:4396] type 0 class 0x000c03
[    1.035199] pci 0000:00:13.2: reg 10: [mem 0xfebfb400-0xfebfb4ff]
[    1.035264] pci 0000:00:13.2: supports D1 D2
[    1.035266] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    1.035270] pci 0000:00:13.2: PME# disabled
[    1.035293] pci 0000:00:14.0: [1002:4385] type 0 class 0x000c05
[    1.035377] pci 0000:00:14.3: [1002:439d] type 0 class 0x000601
[    1.035447] pci 0000:00:14.4: [1002:4384] type 1 class 0x000604
[    1.035485] pci 0000:00:14.5: [1002:4399] type 0 class 0x000c03
[    1.035498] pci 0000:00:14.5: reg 10: [mem 0xfebf6000-0xfebf6fff]
[    1.035560] pci 0000:00:18.0: [1022:1200] type 0 class 0x000600
[    1.035580] pci 0000:00:18.1: [1022:1201] type 0 class 0x000600
[    1.035593] pci 0000:00:18.2: [1022:1202] type 0 class 0x000600
[    1.035607] pci 0000:00:18.3: [1022:1203] type 0 class 0x000600
[    1.035622] pci 0000:00:18.4: [1022:1204] type 0 class 0x000600
[    1.035673] pci 0000:01:00.0: [17d3:1300] type 0 class 0x000100
[    1.035695] pci 0000:01:00.0: reg 18: [io  0xc800-0xc87f]
[    1.035711] pci 0000:01:00.0: reg 20: [mem 0xfe8bf000-0xfe8bffff 64bit]
[    1.035719] pci 0000:01:00.0: reg 30: [mem 0xfe8c0000-0xfe8fffff pref]
[    1.035739] pci 0000:01:00.0: supports D1
[    1.035741] pci 0000:01:00.0: PME# supported from D0 D1 D3hot
[    1.035744] pci 0000:01:00.0: PME# disabled
[    1.035755] pci 0000:01:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    1.035763] pci 0000:00:04.0: PCI bridge to [bus 01-01]
[    1.035766] pci 0000:00:04.0:   bridge window [io  0xc000-0xcfff]
[    1.035769] pci 0000:00:04.0:   bridge window [mem 0xfe800000-0xfe8fffff]
[    1.035774] pci 0000:00:04.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.035814] pci 0000:02:00.0: [8086:10d3] type 0 class 0x000200
[    1.035834] pci 0000:02:00.0: reg 10: [mem 0xfe9e0000-0xfe9fffff]
[    1.035860] pci 0000:02:00.0: reg 18: [io  0xd800-0xd81f]
[    1.035874] pci 0000:02:00.0: reg 1c: [mem 0xfe9dc000-0xfe9dffff]
[    1.035951] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    1.035957] pci 0000:02:00.0: PME# disabled
[    1.050046] pci 0000:00:09.0: PCI bridge to [bus 02-02]
[    1.050051] pci 0000:00:09.0:   bridge window [io  0xd000-0xdfff]
[    1.050055] pci 0000:00:09.0:   bridge window [mem 0xfe900000-0xfe9fffff]
[    1.050059] pci 0000:00:09.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.050102] pci 0000:03:00.0: [8086:10d3] type 0 class 0x000200
[    1.050123] pci 0000:03:00.0: reg 10: [mem 0xfeae0000-0xfeafffff]
[    1.050148] pci 0000:03:00.0: reg 18: [io  0xe800-0xe81f]
[    1.050162] pci 0000:03:00.0: reg 1c: [mem 0xfeadc000-0xfeadffff]
[    1.050241] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    1.050247] pci 0000:03:00.0: PME# disabled
[    1.070022] pci 0000:00:0a.0: PCI bridge to [bus 03-03]
[    1.070027] pci 0000:00:0a.0:   bridge window [io  0xe000-0xefff]
[    1.070029] pci 0000:00:0a.0:   bridge window [mem 0xfea00000-0xfeafffff]
[    1.070033] pci 0000:00:0a.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.070087] pci 0000:04:04.0: [102b:0532] type 0 class 0x000300
[    1.070108] pci 0000:04:04.0: reg 10: [mem 0xfc000000-0xfcffffff pref]
[    1.070120] pci 0000:04:04.0: reg 14: [mem 0xfdffc000-0xfdffffff]
[    1.070131] pci 0000:04:04.0: reg 18: [mem 0xfe000000-0xfe7fffff]
[    1.070238] pci 0000:00:14.4: PCI bridge to [bus 04-04] (subtractive decode)
[    1.070243] pci 0000:00:14.4:   bridge window [io  0xf000-0x0000] (disabled)
[    1.070247] pci 0000:00:14.4:   bridge window [mem 0xfdf00000-0xfe7fffff]
[    1.070251] pci 0000:00:14.4:   bridge window [mem 0xfc000000-0xfcffffff pref]
[    1.070254] pci 0000:00:14.4:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    1.070256] pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    1.070259] pci 0000:00:14.4:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    1.070261] pci 0000:00:14.4:   bridge window [mem 0x000d0000-0x000dffff] (subtractive decode)
[    1.070264] pci 0000:00:14.4:   bridge window [mem 0xf0000000-0xfebfffff] (subtractive decode)
[    1.070278] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    1.070457] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PC04._PRT]
[    1.070488] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PC09._PRT]
[    1.070512] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PC0A._PRT]
[    1.070546] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0PC._PRT]
[    1.070586]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    1.070588] Unable to assume _OSC PCIe control. Disabling ASPM
[    1.074366] ACPI: PCI Interrupt Link [LNKA] (IRQs 4 7 *10 11 12 14 15)
[    1.074403] ACPI: PCI Interrupt Link [LNKB] (IRQs 4 7 10 *11 12 14 15)
[    1.074438] ACPI: PCI Interrupt Link [LNKC] (IRQs 4 7 10 11 12 14 *15)
[    1.074470] ACPI: PCI Interrupt Link [LNKD] (IRQs 4 7 *10 11 12 14 15)
[    1.074503] ACPI: PCI Interrupt Link [LNKE] (IRQs 4 7 10 11 12 *14 15)
[    1.074535] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 7 10 11 12 14 15) *0, disabled.
[    1.074568] ACPI: PCI Interrupt Link [LNKG] (IRQs 4 *7 10 11 12 14 15)
[    1.074599] ACPI: PCI Interrupt Link [LNKH] (IRQs 4 7 10 11 12 14 15) *0, disabled.
[    1.074679] vgaarb: device added: PCI:0000:04:04.0,decodes=io+mem,owns=io+mem,locks=none
[    1.074681] vgaarb: loaded
[    1.074778] SCSI subsystem initialized
[    1.074794] libata version 3.00 loaded.
[    1.074794] usbcore: registered new interface driver usbfs
[    1.074794] usbcore: registered new interface driver hub
[    1.074794] usbcore: registered new device driver usb
[    1.074794] PCI: Using ACPI for IRQ routing
[    1.074794] PCI: pci_cache_line_size set to 64 bytes
[    1.074794] reserve RAM buffer: 0000000000095c00 - 000000000009ffff 
[    1.074794] reserve RAM buffer: 00000000dfea0000 - 00000000dfffffff 
[    1.074794] NetLabel: Initializing
[    1.074794] NetLabel:  domain hash size = 128
[    1.074794] NetLabel:  protocols = UNLABELED CIPSOv4
[    1.074794] NetLabel:  unlabeled traffic allowed by default
[    1.074794] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    1.074794] hpet0: 4 comparators, 32-bit 14.318180 MHz counter
[    1.074794] Switching to clocksource hpet
[    1.074794] Switched to NOHz mode on CPU #0
[    1.074794] Switched to NOHz mode on CPU #2
[    1.074794] Switched to NOHz mode on CPU #1
[    1.074794] Switched to NOHz mode on CPU #3
[    1.074794] Switched to NOHz mode on CPU #5
[    1.074794] Switched to NOHz mode on CPU #4
[    1.075722] pnp: PnP ACPI init
[    1.075732] ACPI: bus type pnp registered
[    1.075828] pnp 00:00: [bus 00-ff]
[    1.075831] pnp 00:00: [io  0x0cf8-0x0cff]
[    1.075834] pnp 00:00: [io  0x0000-0x0cf7 window]
[    1.075836] pnp 00:00: [io  0x0d00-0xffff window]
[    1.075839] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    1.075841] pnp 00:00: [mem 0x000d0000-0x000dffff window]
[    1.075844] pnp 00:00: [mem 0xe0000000-0xdfffffff window disabled]
[    1.075846] pnp 00:00: [mem 0xf0000000-0xfebfffff window]
[    1.075884] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    1.075953] pnp 00:01: [mem 0x00000000-0xffffffffffffffff disabled]
[    1.075956] pnp 00:01: [mem 0x00000000-0xffffffffffffffff disabled]
[    1.075995] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.076039] pnp 00:02: [mem 0x00000000-0xffffffffffffffff disabled]
[    1.076071] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.076239] pnp 00:03: [dma 4]
[    1.076241] pnp 00:03: [io  0x0000-0x000f]
[    1.076244] pnp 00:03: [io  0x0081-0x0083]
[    1.076246] pnp 00:03: [io  0x0087]
[    1.076248] pnp 00:03: [io  0x0089-0x008b]
[    1.076250] pnp 00:03: [io  0x008f]
[    1.076252] pnp 00:03: [io  0x00c0-0x00df]
[    1.076273] pnp 00:03: Plug and Play ACPI device, IDs PNP0200 (active)
[    1.076282] pnp 00:04: [io  0x0070-0x0071]
[    1.076294] pnp 00:04: [irq 8]
[    1.076314] pnp 00:04: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.076338] pnp 00:05: [io  0x0060]
[    1.076340] pnp 00:05: [io  0x0064]
[    1.076344] pnp 00:05: [irq 1]
[    1.076368] pnp 00:05: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
[    1.076391] pnp 00:06: [io  0x0061]
[    1.076412] pnp 00:06: Plug and Play ACPI device, IDs PNP0800 (active)
[    1.076419] pnp 00:07: [io  0x00f0-0x00ff]
[    1.076427] pnp 00:07: [irq 13]
[    1.076447] pnp 00:07: Plug and Play ACPI device, IDs PNP0c04 (active)
[    1.076499] pnp 00:08: [io  0x0000-0xffffffffffffffff disabled]
[    1.076502] pnp 00:08: [io  0x0000-0xffffffffffffffff disabled]
[    1.076504] pnp 00:08: [io  0x0a10-0x0a1f]
[    1.076543] system 00:08: [io  0x0a10-0x0a1f] has been reserved
[    1.076546] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.076572] pnp 00:09: [mem 0xfed00000-0xfed003ff]
[    1.076594] pnp 00:09: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.076657] pnp 00:0a: [mem 0xfec00000-0xfec00fff]
[    1.076659] pnp 00:0a: [mem 0xfee00000-0xfee00fff]
[    1.076698] system 00:0a: [mem 0xfec00000-0xfec00fff] could not be reserved
[    1.076701] system 00:0a: [mem 0xfee00000-0xfee00fff] has been reserved
[    1.076705] system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.076819] pnp 00:0b: [io  0x0010-0x001f]
[    1.076821] pnp 00:0b: [io  0x0022-0x003f]
[    1.076823] pnp 00:0b: [io  0x0062-0x0063]
[    1.076825] pnp 00:0b: [io  0x0065-0x006f]
[    1.076827] pnp 00:0b: [io  0x0072-0x007f]
[    1.076829] pnp 00:0b: [io  0x0080]
[    1.076831] pnp 00:0b: [io  0x0084-0x0086]
[    1.076833] pnp 00:0b: [io  0x0088]
[    1.076837] pnp 00:0b: [io  0x008c-0x008e]
[    1.076839] pnp 00:0b: [io  0x0090-0x009f]
[    1.076841] pnp 00:0b: [io  0x00a2-0x00bf]
[    1.076843] pnp 00:0b: [io  0x00b1]
[    1.076845] pnp 00:0b: [io  0x00e0-0x00ef]
[    1.076847] pnp 00:0b: [io  0x0ca2-0x0ca3]
[    1.076849] pnp 00:0b: [io  0x0550-0x0551]
[    1.076851] pnp 00:0b: [io  0x04d0-0x04d1]
[    1.076853] pnp 00:0b: [io  0x040b]
[    1.076855] pnp 00:0b: [io  0x04d6]
[    1.076856] pnp 00:0b: [io  0x0c00-0x0c01]
[    1.076858] pnp 00:0b: [io  0x0c14]
[    1.076860] pnp 00:0b: [io  0x0c50-0x0c51]
[    1.076862] pnp 00:0b: [io  0x0c52]
[    1.076864] pnp 00:0b: [io  0x0c6c]
[    1.076866] pnp 00:0b: [io  0x0c6f]
[    1.076868] pnp 00:0b: [io  0x0cd0-0x0cd1]
[    1.076870] pnp 00:0b: [io  0x0cd2-0x0cd3]
[    1.076872] pnp 00:0b: [io  0x0cd4-0x0cd5]
[    1.076874] pnp 00:0b: [io  0x0cd6-0x0cd7]
[    1.076876] pnp 00:0b: [io  0x0cd8-0x0cdf]
[    1.076878] pnp 00:0b: [io  0x0800-0x089f]
[    1.076880] pnp 00:0b: [io  0x0000-0xffffffffffffffff disabled]
[    1.076882] pnp 00:0b: [io  0x0b00-0x0b0f]
[    1.076884] pnp 00:0b: [io  0x0b20-0x0b3f]
[    1.076886] pnp 00:0b: [io  0x0900-0x090f]
[    1.076888] pnp 00:0b: [io  0x0910-0x091f]
[    1.076890] pnp 00:0b: [io  0xfe00-0xfefe]
[    1.076892] pnp 00:0b: [io  0x0060-0x005f disabled]
[    1.076895] pnp 00:0b: [io  0x0064-0x0063 disabled]
[    1.076897] pnp 00:0b: [mem 0xffb80000-0xffbfffff]
[    1.076899] pnp 00:0b: [mem 0xfec10000-0xfec1001f]
[    1.076972] system 00:0b: [io  0x0ca2-0x0ca3] has been reserved
[    1.076975] system 00:0b: [io  0x0550-0x0551] has been reserved
[    1.076978] system 00:0b: [io  0x04d0-0x04d1] has been reserved
[    1.076981] system 00:0b: [io  0x040b] has been reserved
[    1.076984] system 00:0b: [io  0x04d6] has been reserved
[    1.076986] system 00:0b: [io  0x0c00-0x0c01] has been reserved
[    1.076989] system 00:0b: [io  0x0c14] has been reserved
[    1.076992] system 00:0b: [io  0x0c50-0x0c51] has been reserved
[    1.076995] system 00:0b: [io  0x0c52] has been reserved
[    1.076997] system 00:0b: [io  0x0c6c] has been reserved
[    1.077000] system 00:0b: [io  0x0c6f] has been reserved
[    1.077003] system 00:0b: [io  0x0cd0-0x0cd1] has been reserved
[    1.077006] system 00:0b: [io  0x0cd2-0x0cd3] has been reserved
[    1.077008] system 00:0b: [io  0x0cd4-0x0cd5] has been reserved
[    1.077011] system 00:0b: [io  0x0cd6-0x0cd7] has been reserved
[    1.077014] system 00:0b: [io  0x0cd8-0x0cdf] has been reserved
[    1.077019] system 00:0b: [io  0x0800-0x089f] has been reserved
[    1.077022] system 00:0b: [io  0x0b00-0x0b0f] has been reserved
[    1.077025] system 00:0b: [io  0x0b20-0x0b3f] has been reserved
[    1.077028] system 00:0b: [io  0x0900-0x090f] has been reserved
[    1.077030] system 00:0b: [io  0x0910-0x091f] has been reserved
[    1.077034] system 00:0b: [io  0xfe00-0xfefe] has been reserved
[    1.077037] system 00:0b: [mem 0xffb80000-0xffbfffff] has been reserved
[    1.077040] system 00:0b: [mem 0xfec10000-0xfec1001f] has been reserved
[    1.077044] system 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.077222] pnp 00:0c: [io  0x03f8-0x03ff]
[    1.077226] pnp 00:0c: [irq 4]
[    1.077228] pnp 00:0c: [dma 0 disabled]
[    1.077285] pnp 00:0c: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.077391] pnp 00:0d: [mem 0xe0000000-0xefffffff]
[    1.077437] system 00:0d: [mem 0xe0000000-0xefffffff] has been reserved
[    1.077440] system 00:0d: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.077651] pnp 00:0e: [mem 0x00000000-0x0009ffff]
[    1.077653] pnp 00:0e: [mem 0x000c0000-0x000cffff]
[    1.077656] pnp 00:0e: [mem 0x000e0000-0x000fffff]
[    1.077658] pnp 00:0e: [mem 0x00100000-0xdfffffff]
[    1.077660] pnp 00:0e: [mem 0xfec00000-0xffffffff]
[    1.077705] system 00:0e: [mem 0x00000000-0x0009ffff] could not be reserved
[    1.077708] system 00:0e: [mem 0x000c0000-0x000cffff] has been reserved
[    1.077711] system 00:0e: [mem 0x000e0000-0x000fffff] could not be reserved
[    1.077714] system 00:0e: [mem 0x00100000-0xdfffffff] could not be reserved
[    1.077717] system 00:0e: [mem 0xfec00000-0xffffffff] could not be reserved
[    1.077720] system 00:0e: Plug and Play ACPI device, IDs PNP0c01 (active)
[    1.077812] pnp: PnP ACPI: found 15 devices
[    1.077814] ACPI: ACPI bus type pnp unregistered
[    1.083627] pci 0000:00:04.0: PCI bridge to [bus 01-01]
[    1.083630] pci 0000:00:04.0:   bridge window [io  0xc000-0xcfff]
[    1.083633] pci 0000:00:04.0:   bridge window [mem 0xfe800000-0xfe8fffff]
[    1.083636] pci 0000:00:04.0:   bridge window [mem pref disabled]
[    1.083640] pci 0000:00:09.0: PCI bridge to [bus 02-02]
[    1.083643] pci 0000:00:09.0:   bridge window [io  0xd000-0xdfff]
[    1.083646] pci 0000:00:09.0:   bridge window [mem 0xfe900000-0xfe9fffff]
[    1.083649] pci 0000:00:09.0:   bridge window [mem pref disabled]
[    1.083652] pci 0000:00:0a.0: PCI bridge to [bus 03-03]
[    1.083655] pci 0000:00:0a.0:   bridge window [io  0xe000-0xefff]
[    1.083658] pci 0000:00:0a.0:   bridge window [mem 0xfea00000-0xfeafffff]
[    1.083661] pci 0000:00:0a.0:   bridge window [mem pref disabled]
[    1.083664] pci 0000:00:14.4: PCI bridge to [bus 04-04]
[    1.083666] pci 0000:00:14.4:   bridge window [io  disabled]
[    1.083678] pci 0000:00:14.4:   bridge window [mem 0xfdf00000-0xfe7fffff]
[    1.083682] pci 0000:00:14.4:   bridge window [mem 0xfc000000-0xfcffffff pref]
[    1.083699] pci 0000:00:04.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.083702] pci 0000:00:04.0: setting latency timer to 64
[    1.083711] pci 0000:00:09.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    1.083714] pci 0000:00:09.0: setting latency timer to 64
[    1.083722] pci 0000:00:0a.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    1.083726] pci 0000:00:0a.0: setting latency timer to 64
[    1.083733] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.083735] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.083738] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.083740] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000dffff]
[    1.083743] pci_bus 0000:00: resource 8 [mem 0xf0000000-0xfebfffff]
[    1.083745] pci_bus 0000:01: resource 0 [io  0xc000-0xcfff]
[    1.083748] pci_bus 0000:01: resource 1 [mem 0xfe800000-0xfe8fffff]
[    1.083750] pci_bus 0000:02: resource 0 [io  0xd000-0xdfff]
[    1.083753] pci_bus 0000:02: resource 1 [mem 0xfe900000-0xfe9fffff]
[    1.083755] pci_bus 0000:03: resource 0 [io  0xe000-0xefff]
[    1.083758] pci_bus 0000:03: resource 1 [mem 0xfea00000-0xfeafffff]
[    1.083760] pci_bus 0000:04: resource 1 [mem 0xfdf00000-0xfe7fffff]
[    1.083763] pci_bus 0000:04: resource 2 [mem 0xfc000000-0xfcffffff pref]
[    1.083765] pci_bus 0000:04: resource 4 [io  0x0000-0x0cf7]
[    1.083768] pci_bus 0000:04: resource 5 [io  0x0d00-0xffff]
[    1.083770] pci_bus 0000:04: resource 6 [mem 0x000a0000-0x000bffff]
[    1.083772] pci_bus 0000:04: resource 7 [mem 0x000d0000-0x000dffff]
[    1.083775] pci_bus 0000:04: resource 8 [mem 0xf0000000-0xfebfffff]
[    1.083804] NET: Registered protocol family 2
[    1.083948] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    1.085012] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    1.087292] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    1.087574] TCP: Hash tables configured (established 524288 bind 65536)
[    1.087576] TCP reno registered
[    1.087587] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    1.087619] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    1.087730] NET: Registered protocol family 1
[    1.860122] pci 0000:04:04.0: Boot video device
[    1.860128] PCI: CLS 64 bytes, default 64
[    1.860177] Trying to unpack rootfs image as initramfs...
[    3.182915] Freeing initrd memory: 57872k freed
[    3.198177] PCI-DMA: Disabling AGP.
[    3.198285] PCI-DMA: aperture base @ c0000000 size 65536 KB
[    3.198287] PCI-DMA: using GART IOMMU.
[    3.198290] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    3.202739] audit: initializing netlink socket (disabled)
[    3.202756] type=2000 audit(1307363793.200:1): initialized
[    3.221657] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    3.223270] VFS: Disk quotas dquot_6.5.2
[    3.223319] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    3.223707] fuse init (API version 7.16)
[    3.223788] msgmni has been set to 7916
[    3.224058] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    3.224061] io scheduler noop registered
[    3.224063] io scheduler deadline registered (default)
[    3.224099] io scheduler cfq registered
[    3.224523] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[    3.224527] ACPI: Power Button [PWRB]
[    3.224563] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    3.224566] ACPI: Power Button [PWRF]
[    3.224703] ACPI: acpi_idle registered with cpuidle
[    3.440470] ERST: Table is not found!
[    3.440549] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    3.461146] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    3.490969] 00:0c: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    3.491223] Linux agpgart interface v0.103
[    3.492019] brd: module loaded
[    3.492395] loop: module loaded
[    3.492835] Fixed MDIO Bus: probed
[    3.492860] PPP generic driver version 2.4.2
[    3.492889] tun: Universal TUN/TAP device driver, 1.6
[    3.492891] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    3.492950] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    3.493037] ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    3.493076] ehci_hcd 0000:00:12.2: EHCI Host Controller
[    3.493111] ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus number 1
[    3.493143] ehci_hcd 0000:00:12.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    3.493169] ehci_hcd 0000:00:12.2: debug port 1
[    3.493190] ehci_hcd 0000:00:12.2: irq 17, io mem 0xfebfb800
[    3.510079] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00
[    3.510200] hub 1-0:1.0: USB hub found
[    3.510204] hub 1-0:1.0: 6 ports detected
[    3.510366] ehci_hcd 0000:00:13.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    3.510380] ehci_hcd 0000:00:13.2: EHCI Host Controller
[    3.510415] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 2
[    3.510455] ehci_hcd 0000:00:13.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    3.510476] ehci_hcd 0000:00:13.2: debug port 1
[    3.510495] ehci_hcd 0000:00:13.2: irq 19, io mem 0xfebfb400
[    3.530076] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
[    3.530182] hub 2-0:1.0: USB hub found
[    3.530188] hub 2-0:1.0: 6 ports detected
[    3.530279] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    3.530359] ohci_hcd 0000:00:12.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.530372] ohci_hcd 0000:00:12.0: OHCI Host Controller
[    3.530402] ohci_hcd 0000:00:12.0: new USB bus registered, assigned bus number 3
[    3.530448] ohci_hcd 0000:00:12.0: irq 16, io mem 0xfebf9000
[    3.594184] hub 3-0:1.0: USB hub found
[    3.594194] hub 3-0:1.0: 3 ports detected
[    3.594338] ohci_hcd 0000:00:12.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.594350] ohci_hcd 0000:00:12.1: OHCI Host Controller
[    3.594386] ohci_hcd 0000:00:12.1: new USB bus registered, assigned bus number 4
[    3.594433] ohci_hcd 0000:00:12.1: irq 16, io mem 0xfebfa000
[    3.654184] hub 4-0:1.0: USB hub found
[    3.654193] hub 4-0:1.0: 3 ports detected
[    3.654306] ohci_hcd 0000:00:13.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    3.654319] ohci_hcd 0000:00:13.0: OHCI Host Controller
[    3.654355] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 5
[    3.660112] ohci_hcd 0000:00:13.0: irq 18, io mem 0xfebf7000
[    3.724184] hub 5-0:1.0: USB hub found
[    3.724193] hub 5-0:1.0: 3 ports detected
[    3.724303] ohci_hcd 0000:00:13.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    3.724316] ohci_hcd 0000:00:13.1: OHCI Host Controller
[    3.724350] ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 6
[    3.724398] ohci_hcd 0000:00:13.1: irq 18, io mem 0xfebf8000
[    3.784183] hub 6-0:1.0: USB hub found
[    3.784193] hub 6-0:1.0: 3 ports detected
[    3.784303] ohci_hcd 0000:00:14.5: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    3.784316] ohci_hcd 0000:00:14.5: OHCI Host Controller
[    3.784348] ohci_hcd 0000:00:14.5: new USB bus registered, assigned bus number 7
[    3.784383] ohci_hcd 0000:00:14.5: irq 18, io mem 0xfebf6000
[    3.844190] hub 7-0:1.0: USB hub found
[    3.844200] hub 7-0:1.0: 2 ports detected
[    3.844279] uhci_hcd: USB Universal Host Controller Interface driver
[    3.844347] i8042: PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    3.844349] i8042: PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[    3.845022] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.845088] mousedev: PS/2 mouse device common for all mice
[    3.845171] rtc_cmos 00:04: RTC can wake from S4
[    3.864051] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
[    3.890165] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
[    3.890196] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    3.890262] device-mapper: uevent: version 1.0.3
[    3.890328] device-mapper: ioctl: 4.20.0-ioctl (2011-02-02) initialised: dm-devel@redhat.com
[    3.890417] device-mapper: multipath: version 1.3.0 loaded
[    3.890421] device-mapper: multipath round-robin: version 1.0.0 loaded
[    3.890494] cpuidle: using governor ladder
[    3.890496] cpuidle: using governor menu
[    3.890498] EFI Variables Facility v0.08 2004-May-17
[    3.890713] TCP cubic registered
[    3.890818] NET: Registered protocol family 10
[    3.891253] NET: Registered protocol family 17
[    3.891268] Registering the dns_resolver key type
[    3.891343] powernow-k8: Found 1 AMD Opteron(tm) Processor 4170 HE (6 cpu cores) (version 2.20.00)
[    3.891377] powernow-k8:    0 : pstate 0 (2100 MHz)
[    3.891379] powernow-k8:    1 : pstate 1 (1800 MHz)
[    3.891381] powernow-k8:    2 : pstate 2 (1400 MHz)
[    3.891383] powernow-k8:    3 : pstate 3 (1100 MHz)
[    3.891385] powernow-k8:    4 : pstate 4 (800 MHz)
[    3.892992] PM: Hibernation image not present or could not be loaded.
[    3.893003] registered taskstats version 1
[    3.893267]   Magic number: 15:302:632
[    3.893372] rtc_cmos 00:04: setting system clock to 2011-06-06 12:36:34 UTC (1307363794)
[    3.893375] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    3.893377] EDD information not available.
[    3.894687] Freeing unused kernel memory: 740k freed
[    3.894837] Write protecting the kernel read-only data: 10240k
[    3.897290] Freeing unused kernel memory: 644k freed
[    3.903542] Freeing unused kernel memory: 1728k freed
[    3.931124] udev: starting version 151
[    3.931223] udevd (99): /proc/99/oom_adj is deprecated, please use /proc/99/oom_score_adj instead.
[    3.939936] md: linear personality registered for level -1
[    3.949847] md: multipath personality registered for level -4
[    3.955949] md: raid0 personality registered for level 0
[    3.991858] e1000e: Intel(R) PRO/1000 Network Driver - 1.3.10-k2
[    3.991862] e1000e: Copyright(c) 1999 - 2011 Intel Corporation.
[    3.991998] e1000e 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    3.992029] e1000e 0000:02:00.0: setting latency timer to 64
[    3.992301] e1000e 0000:02:00.0: irq 40 for MSI/MSI-X
[    3.992314] e1000e 0000:02:00.0: irq 41 for MSI/MSI-X
[    3.992328] e1000e 0000:02:00.0: irq 42 for MSI/MSI-X
[    3.992470] md: raid1 personality registered for level 1
[    3.992503] e1000e 0000:02:00.0: Disabling ASPM L0s 
[    3.996334] async_tx: api initialized (async)
[    4.130105] usb 6-2: new full speed USB device number 2 using ohci_hcd
[    4.170107] raid6: int64x1    685 MB/s
[    4.220078] Refined TSC clocksource calibration: 2095.521 MHz.
[    4.220090] Switching to clocksource tsc
[    4.340029] raid6: int64x2    948 MB/s
[    4.510106] raid6: int64x4    717 MB/s
[    4.680058] raid6: int64x8    632 MB/s
[    4.850062] raid6: sse2x1    1226 MB/s
[    5.020039] raid6: sse2x2    2058 MB/s
[    5.190035] raid6: sse2x4    2478 MB/s
[    5.190040] raid6: using algorithm sse2x4 (2478 MB/s)
[    5.190112] mvsas 0000:01:00.0: mvsas: driver version 0.8.2
[    5.190134] mvsas 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    5.190143] mvsas 0000:01:00.0: setting latency timer to 64
[    5.190190] ahci 0000:00:11.0: version 3.0
[    5.190222] ahci 0000:00:11.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    5.190427] ahci 0000:00:11.0: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[    5.190432] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part ccc 
[    5.191854] xor: automatically using best checksumming function: generic_sse
[    5.192356] mvsas 0000:01:00.0: mvsas: PCI-E x4, Bandwidth Usage: 2.5 Gbps
[    5.192373] scsi1 : ahci
[    5.192502] scsi2 : ahci
[    5.192557] scsi3 : ahci
[    5.192610] scsi4 : ahci
[    5.192664] scsi5 : ahci
[    5.192716] scsi6 : ahci
[    5.193002] ata1: SATA max UDMA/133 abar m1024@0xfebfbc00 port 0xfebfbd00 irq 22
[    5.193006] ata2: SATA max UDMA/133 abar m1024@0xfebfbc00 port 0xfebfbd80 irq 22
[    5.193009] ata3: SATA max UDMA/133 abar m1024@0xfebfbc00 port 0xfebfbe00 irq 22
[    5.193013] ata4: SATA max UDMA/133 abar m1024@0xfebfbc00 port 0xfebfbe80 irq 22
[    5.193016] ata5: SATA max UDMA/133 abar m1024@0xfebfbc00 port 0xfebfbf00 irq 22
[    5.193020] ata6: SATA max UDMA/133 abar m1024@0xfebfbc00 port 0xfebfbf80 irq 22
[    5.240019]    generic_sse:  8534.800 MB/sec
[    5.240022] xor: using function: generic_sse (8534.800 MB/sec)
[    5.324463] input: Winbond Electronics Corp Hermon USB hidmouse Device as /devices/pci0000:00/0000:00:13.1/usb6/6-2/6-2:1.0/input/input3
[    5.324665] generic-usb 0003:0557:2221.0001: input,hidraw0: USB HID v1.00 Mouse [Winbond Electronics Corp Hermon USB hidmouse Device] on usb-0000:00:13.1-2/input0
[    5.403974] e1000e 0000:02:00.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:30:48:fe:60:6a
[    5.403985] e1000e 0000:02:00.0: eth0: Intel(R) PRO/1000 Network Connection
[    5.404074] e1000e 0000:02:00.0: eth0: MAC: 3, PHY: 8, PBA No: 0101FF-0FF
[    5.404225] e1000e 0000:03:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    5.404251] e1000e 0000:03:00.0: setting latency timer to 64
[    5.404524] e1000e 0000:03:00.0: irq 43 for MSI/MSI-X
[    5.404537] e1000e 0000:03:00.0: irq 44 for MSI/MSI-X
[    5.404550] e1000e 0000:03:00.0: irq 45 for MSI/MSI-X
[    5.405039] e1000e 0000:03:00.0: Disabling ASPM L0s 
[    5.430254] input: Winbond Electronics Corp Hermon USB hidmouse Device as /devices/pci0000:00/0000:00:13.1/usb6/6-2/6-2:1.1/input/input4
[    5.430413] generic-usb 0003:0557:2221.0002: input,hidraw1: USB HID v1.00 Keyboard [Winbond Electronics Corp Hermon USB hidmouse Device] on usb-0000:00:13.1-2/input1
[    5.430446] usbcore: registered new interface driver usbhid
[    5.430451] usbhid: USB HID core driver
[    5.540130] ata4: SATA link down (SStatus 0 SControl 300)
[    5.540178] ata6: SATA link down (SStatus 0 SControl 300)
[    5.540229] ata5: SATA link down (SStatus 0 SControl 300)
[    5.565784] e1000e 0000:03:00.0: eth1: (PCI Express:2.5GB/s:Width x1) 00:30:48:fe:60:6b
[    5.565794] e1000e 0000:03:00.0: eth1: Intel(R) PRO/1000 Network Connection
[    5.565883] e1000e 0000:03:00.0: eth1: MAC: 3, PHY: 8, PBA No: 0101FF-0FF
[    5.740112] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    5.740157] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    5.744221] ata3.00: ATAPI: HL-DT-ST DVDRAM GT20N, CQ02, max UDMA/133
[    5.748222] ata1.00: ATA-8: WDC WD3202ABYS-02B7A0, 02.03B03, max UDMA/133
[    5.748232] ata1.00: 625142448 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
[    5.749068] ata3.00: configured for UDMA/133
[    5.749279] ata1.00: configured for UDMA/133
[    5.749543] scsi 1:0:0:0: Direct-Access     ATA      WDC WD3202ABYS-0 02.0 PQ: 0 ANSI: 5
[    5.749849] sd 1:0:0:0: Attached scsi generic sg0 type 0
[    5.749946] sd 1:0:0:0: [sda] 625142448 512-byte logical blocks: (320 GB/298 GiB)
[    5.750049] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    5.750109] sd 1:0:0:0: [sda] Write Protect is off
[    5.750116] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    5.750192] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.750628] sda: detected capacity change from 0 to 320072933376
[    5.763706] ata2.00: ATA-8: WDC WD3202ABYS-02B7A0, 02.03B03, max UDMA/133
[    5.763714] ata2.00: 625142448 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
[    5.764843] ata2.00: configured for UDMA/133
[    5.765106] scsi 2:0:0:0: Direct-Access     ATA      WDC WD3202ABYS-0 02.0 PQ: 0 ANSI: 5
[    5.765398] sd 2:0:0:0: [sdb] 625142448 512-byte logical blocks: (320 GB/298 GiB)
[    5.765407] sd 2:0:0:0: Attached scsi generic sg1 type 0
[    5.765651] sd 2:0:0:0: [sdb] Write Protect is off
[    5.765659] sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    5.765745] sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.766144] sdb: detected capacity change from 0 to 320072933376
[    5.768655] scsi 3:0:0:0: CD-ROM            HL-DT-ST DVDRAM GT20N     CQ02 PQ: 0 ANSI: 5
[    5.773746] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    5.773755] cdrom: Uniform CD-ROM driver Revision: 3.20
[    5.773971] sr 3:0:0:0: Attached scsi CD-ROM sr0
[    5.774087] sr 3:0:0:0: Attached scsi generic sg2 type 5
[    5.775203]  sda: sda1 sda2 sda3 sda4
[    5.776048] sd 1:0:0:0: [sda] Attached SCSI disk
[    5.786024]  sdb: sdb1 sdb2 sdb3 sdb4
[    5.786847] sd 2:0:0:0: [sdb] Attached SCSI disk
[    5.800792] md: raid6 personality registered for level 6
[    5.800799] md: raid5 personality registered for level 5
[    5.800805] md: raid4 personality registered for level 4
[    5.815666] md: raid10 personality registered for level 10
[    5.900406] md: bind<sdb2>
[    5.922630] md: bind<sda3>
[    5.933178] md: bind<sdb3>
[    5.936460] bio: create slab <bio-1> at 1
[    5.936599] md/raid1:md2: active with 2 out of 2 mirrors
[    5.936645] md2: detected capacity change from 0 to 19999424512
[    5.938981]  md2: unknown partition table
[    5.957904] md: bind<sda2>
[    5.959270] md: bind<sdb1>
[    5.961801] md/raid1:md1: active with 2 out of 2 mirrors
[    5.961852] md1: detected capacity change from 0 to 20003815424
[    5.964218]  md1: unknown partition table
[    5.993774] md: bind<sda1>
[    5.997182] md/raid1:md0: active with 2 out of 2 mirrors
[    5.997228] md0: detected capacity change from 0 to 20003749888
[    5.999568]  md0: unknown partition table
[    7.500124] drivers/scsi/mvsas/mv_sas.c 1224:port 0 attach dev info is c040002
[    7.500134] drivers/scsi/mvsas/mv_sas.c 1226:port 0 attach sas addr is 3f60f402d5b40150
[    7.670129] drivers/scsi/mvsas/mv_sas.c 1224:port 1 attach dev info is d040002
[    7.670138] drivers/scsi/mvsas/mv_sas.c 1226:port 1 attach sas addr is 3f60f402d5b40150
[    7.840121] drivers/scsi/mvsas/mv_sas.c 1224:port 2 attach dev info is e040002
[    7.840130] drivers/scsi/mvsas/mv_sas.c 1226:port 2 attach sas addr is 3f60f402d5b40150
[    8.010129] drivers/scsi/mvsas/mv_sas.c 1224:port 3 attach dev info is f040002
[    8.010138] drivers/scsi/mvsas/mv_sas.c 1226:port 3 attach sas addr is 3f60f402d5b40150
[    8.010148] scsi0 : mvsas
[    8.011122] drivers/scsi/mvsas/mv_sas.c 378:phy 0 byte dmaded.
[    8.011140] drivers/scsi/mvsas/mv_sas.c 378:phy 1 byte dmaded.
[    8.011154] drivers/scsi/mvsas/mv_sas.c 378:phy 2 byte dmaded.
[    8.011167] drivers/scsi/mvsas/mv_sas.c 378:phy 3 byte dmaded.
[    8.011232] sas: phy-0:0 added to port-0:0, phy_mask:0x1 (5001b4d502f4603f)
[    8.011242] drivers/scsi/mvsas/mv_sas.c 1260:set wide port phy map 1
[    8.021285] sas: phy1 matched wide port0
[    8.021294] sas: phy-0:1 added to port-0:0, phy_mask:0x3 (5001b4d502f4603f)
[    8.021300] drivers/scsi/mvsas/mv_sas.c 1260:set wide port phy map 3
[    8.041320] sas: phy2 matched wide port0
[    8.041328] sas: phy-0:2 added to port-0:0, phy_mask:0x7 (5001b4d502f4603f)
[    8.041333] drivers/scsi/mvsas/mv_sas.c 1260:set wide port phy map 7
[    8.071353] sas: phy3 matched wide port0
[    8.071361] sas: phy-0:3 added to port-0:0, phy_mask:0xf (5001b4d502f4603f)
[    8.071366] drivers/scsi/mvsas/mv_sas.c 1260:set wide port phy map f
[    8.111406] sas: DOING DISCOVERY on port 0, pid:5
[    8.113221] sas: ex 5001b4d502f4603f phy00:D attached: 0000000000000000
[    8.113893] sas: ex 5001b4d502f4603f phy01:D attached: 0000000000000000
[    8.114531] sas: ex 5001b4d502f4603f phy02:D attached: 0000000000000000
[    8.115124] sas: ex 5001b4d502f4603f phy03:D attached: 0000000000000000
[    8.115805] sas: ex 5001b4d502f4603f phy04:D attached: 0000000000000000
[    8.116443] sas: ex 5001b4d502f4603f phy05:D attached: 0000000000000000
[    8.117083] sas: ex 5001b4d502f4603f phy06:D attached: 0000000000000000
[    8.117715] sas: ex 5001b4d502f4603f phy07:D attached: 0000000000000000
[    8.118363] sas: ex 5001b4d502f4603f phy08:D attached: 5001b4d502f46008
[    8.119003] sas: ex 5001b4d502f4603f phy09:D attached: 5001b4d502f46009
[    8.119643] sas: ex 5001b4d502f4603f phy10:D attached: 5001b4d502f4600a
[    8.120197] sas: ex 5001b4d502f4603f phy11:D attached: 5001b4d502f4600b
[    8.120922] sas: ex 5001b4d502f4603f phy12:S attached: 5005043011ab0000
[    8.121561] sas: ex 5001b4d502f4603f phy13:S attached: 5005043011ab0000
[    8.122118] sas: ex 5001b4d502f4603f phy14:S attached: 5005043011ab0000
[    8.122841] sas: ex 5001b4d502f4603f phy15:S attached: 5005043011ab0000
[    8.123480] sas: ex 5001b4d502f4603f phy16:T attached: 0000000000000000
[    8.124113] sas: ex 5001b4d502f4603f phy17:T attached: 0000000000000000
[    8.124763] sas: ex 5001b4d502f4603f phy18:T attached: 0000000000000000
[    8.125400] sas: ex 5001b4d502f4603f phy19:T attached: 0000000000000000
[    8.126040] sas: ex 5001b4d502f4603f phy20:T attached: 0000000000000000
[    8.126679] sas: ex 5001b4d502f4603f phy21:T attached: 0000000000000000
[    8.127276] sas: ex 5001b4d502f4603f phy22:T attached: 0000000000000000
[    8.127958] sas: ex 5001b4d502f4603f phy23:T attached: 0000000000000000
[    8.128598] sas: ex 5001b4d502f4603f phy24:T attached: 5001b4d502f46018
[    8.129231] sas: ex 5001b4d502f4603f phy25:T attached: 5001b4d502f46019
[    8.129881] sas: ex 5001b4d502f4603f phy26:T attached: 5001b4d502f4601a
[    8.130525] sas: ex 5001b4d502f4603f phy27:T attached: 5001b4d502f4601b
[    8.131153] sas: ex 5001b4d502f4603f phy28:D attached: 5001b4d502f4603d
[    8.131792] sas: ex 5001b4d502f4603f phy29:D attached: 5001b4d502f4603e
[    8.136324] drivers/scsi/mvsas/mv_sas.c 1388:found dev[1:5] is gone.
[    8.136635] sas: Enter sas_scsi_recover_host
[    8.136647] ata7: sas eh calling libata port error handler
[    8.136666] sas: sas_ata_hard_reset: Found ATA device.
[    8.147853] ata7.00: ATA-8: WDC WD2003FYYS-02W0B0, 01.01D01, max UDMA/133
[    8.147862] ata7.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    8.153053] ata7.00: configured for UDMA/133
[    8.153076] sas: --- Exit sas_scsi_recover_host
[    8.170229] scsi 0:0:0:0: Direct-Access     ATA      WDC WD2003FYYS-0 01.0 PQ: 0 ANSI: 5
[    8.174057] drivers/scsi/mvsas/mv_sas.c 1388:found dev[2:5] is gone.
[    8.174354] sas: Enter sas_scsi_recover_host
[    8.174365] ata7: sas eh calling libata port error handler
[    8.174387] ata8: sas eh calling libata port error handler
[    8.174401] sas: sas_ata_hard_reset: Found ATA device.
[    8.189090] ata8.00: ATA-8: WDC WD2003FYYS-02W0B0, 01.01D01, max UDMA/133
[    8.189099] ata8.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    8.192828] ata8.00: configured for UDMA/133
[    8.192851] sas: --- Exit sas_scsi_recover_host
[    8.210232] scsi 0:0:1:0: Direct-Access     ATA      WDC WD2003FYYS-0 01.0 PQ: 0 ANSI: 5
[    8.213329] drivers/scsi/mvsas/mv_sas.c 1388:found dev[3:5] is gone.
[    8.213626] sas: Enter sas_scsi_recover_host
[    8.213636] ata7: sas eh calling libata port error handler
[    8.213655] ata8: sas eh calling libata port error handler
[    8.213665] ata9: sas eh calling libata port error handler
[    8.213678] sas: sas_ata_hard_reset: Found ATA device.
[    8.629551] ata9.00: ATA-8: WDC WD2002FYPS-02W3B0, 04.01G01, max UDMA/133
[    8.629559] ata9.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    8.632762] ata9.00: configured for UDMA/133
[    8.632783] sas: --- Exit sas_scsi_recover_host
[    8.632949] scsi 0:0:2:0: Direct-Access     ATA      WDC WD2002FYPS-0 04.0 PQ: 0 ANSI: 5
[    8.636689] drivers/scsi/mvsas/mv_sas.c 1388:found dev[4:5] is gone.
[    8.636996] sas: Enter sas_scsi_recover_host
[    8.637003] ata7: sas eh calling libata port error handler
[    8.637022] ata8: sas eh calling libata port error handler
[    8.637033] ata9: sas eh calling libata port error handler
[    8.637043] ata10: sas eh calling libata port error handler
[    8.637054] sas: sas_ata_hard_reset: Found ATA device.
[    8.653547] ata10.00: ATA-8: WDC WD2003FYYS-02W0B0, 01.01D01, max UDMA/133
[    8.653555] ata10.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    8.657192] ata10.00: configured for UDMA/133
[    8.657213] sas: --- Exit sas_scsi_recover_host
[    8.670237] scsi 0:0:3:0: Direct-Access     ATA      WDC WD2003FYYS-0 01.0 PQ: 0 ANSI: 5
[    8.673419] drivers/scsi/mvsas/mv_sas.c 1388:found dev[5:5] is gone.
[    8.673730] sas: Enter sas_scsi_recover_host
[    8.673736] ata7: sas eh calling libata port error handler
[    8.673754] ata8: sas eh calling libata port error handler
[    8.673762] ata9: sas eh calling libata port error handler
[    8.673771] ata10: sas eh calling libata port error handler
[    8.673780] ata11: sas eh calling libata port error handler
[    8.673790] sas: sas_ata_hard_reset: Found ATA device.
[    9.067506] ata11.00: ATA-8: WDC WD2002FYPS-01U1B1, 04.05G05, max UDMA/133
[    9.067514] ata11.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    9.070650] ata11.00: configured for UDMA/133
[    9.070671] sas: --- Exit sas_scsi_recover_host
[    9.070835] scsi 0:0:4:0: Direct-Access     ATA      WDC WD2002FYPS-0 04.0 PQ: 0 ANSI: 5
[    9.075004] drivers/scsi/mvsas/mv_sas.c 1388:found dev[6:5] is gone.
[    9.075316] sas: Enter sas_scsi_recover_host
[    9.075326] ata7: sas eh calling libata port error handler
[    9.075346] ata8: sas eh calling libata port error handler
[    9.075357] ata9: sas eh calling libata port error handler
[    9.075367] ata10: sas eh calling libata port error handler
[    9.075377] ata11: sas eh calling libata port error handler
[    9.075386] ata12: sas eh calling libata port error handler
[    9.075399] sas: sas_ata_hard_reset: Found ATA device.
[    9.485970] ata12.00: ATA-8: WDC WD2002FYPS-02W3B0, 04.01G01, max UDMA/133
[    9.485978] ata12.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    9.490072] ata12.00: configured for UDMA/133
[    9.490091] sas: --- Exit sas_scsi_recover_host
[    9.510273] scsi 0:0:5:0: Direct-Access     ATA      WDC WD2002FYPS-0 04.0 PQ: 0 ANSI: 5
[    9.514379] drivers/scsi/mvsas/mv_sas.c 1388:found dev[7:5] is gone.
[    9.514694] sas: Enter sas_scsi_recover_host
[    9.514704] ata7: sas eh calling libata port error handler
[    9.514723] ata8: sas eh calling libata port error handler
[    9.514733] ata9: sas eh calling libata port error handler
[    9.514743] ata10: sas eh calling libata port error handler
[    9.514752] ata11: sas eh calling libata port error handler
[    9.514761] ata12: sas eh calling libata port error handler
[    9.514770] ata13: sas eh calling libata port error handler
[    9.514783] sas: sas_ata_hard_reset: Found ATA device.
[    9.911076] ata13.00: ATA-8: WDC WD2002FYPS-02W3B0, 04.01G01, max UDMA/133
[    9.911084] ata13.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    9.915112] ata13.00: configured for UDMA/133
[    9.915133] sas: --- Exit sas_scsi_recover_host
[    9.930245] scsi 0:0:6:0: Direct-Access     ATA      WDC WD2002FYPS-0 04.0 PQ: 0 ANSI: 5
[    9.933544] drivers/scsi/mvsas/mv_sas.c 1388:found dev[8:5] is gone.
[    9.933870] sas: Enter sas_scsi_recover_host
[    9.933876] ata7: sas eh calling libata port error handler
[    9.933894] ata8: sas eh calling libata port error handler
[    9.933903] ata9: sas eh calling libata port error handler
[    9.933912] ata10: sas eh calling libata port error handler
[    9.933922] ata11: sas eh calling libata port error handler
[    9.933931] ata12: sas eh calling libata port error handler
[    9.933940] ata13: sas eh calling libata port error handler
[    9.933948] ata14: sas eh calling libata port error handler
[    9.933958] sas: sas_ata_hard_reset: Found ATA device.
[   10.344406] ata14.00: ATA-8: WDC WD2002FYPS-02W3B0, 04.01G01, max UDMA/133
[   10.344414] ata14.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[   10.347649] ata14.00: configured for UDMA/133
[   10.347670] sas: --- Exit sas_scsi_recover_host
[   10.360249] scsi 0:0:7:0: Direct-Access     ATA      WDC WD2002FYPS-0 04.0 PQ: 0 ANSI: 5
[   10.363345] scsi 0:0:8:0: Enclosure         Areca    x28-05.63.1.32   000  PQ: 0 ANSI: 3
[   10.374636] sas: DONE DISCOVERY on port 0, pid:5, result:0
[   10.375005] sd 0:0:0:0: [sdc] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[   10.375014] sd 0:0:0:0: Attached scsi generic sg3 type 0
[   10.375386] sd 0:0:1:0: Attached scsi generic sg4 type 0
[   10.375620] sd 0:0:0:0: [sdc] Write Protect is off
[   10.375629] sd 0:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[   10.375688] sd 0:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   10.376013] sd 0:0:1:0: [sdd] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[   10.376117] sd 0:0:2:0: [sde] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[   10.376183] sd 0:0:1:0: [sdd] Write Protect is off
[   10.376194] sd 0:0:1:0: [sdd] Mode Sense: 00 3a 00 00
[   10.376255] sd 0:0:1:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   10.376266] sd 0:0:2:0: [sde] Write Protect is off
[   10.376274] sd 0:0:2:0: [sde] Mode Sense: 00 3a 00 00
[   10.376296] sd 0:0:2:0: Attached scsi generic sg5 type 0
[   10.376329] sd 0:0:2:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   10.376350] sdc: detected capacity change from 0 to 2000398934016
[   10.376531]  sdc: unknown partition table
[   10.376731] sdd: detected capacity change from 0 to 2000398934016
[   10.376936]  sdd: unknown partition table
[   10.377103] sde: detected capacity change from 0 to 2000398934016
[   10.377213] sd 0:0:0:0: [sdc] Attached SCSI disk
[   10.377261]  sde: unknown partition table
[   10.377288] sd 0:0:3:0: [sdf] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[   10.377437] sd 0:0:3:0: [sdf] Write Protect is off
[   10.377445] sd 0:0:3:0: [sdf] Mode Sense: 00 3a 00 00
[   10.377624] sd 0:0:3:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   10.377682] sd 0:0:2:0: [sde] Attached SCSI disk
[   10.378114] sdf: detected capacity change from 0 to 2000398934016
[   10.379615]  sdf: unknown partition table
[   10.380337] sd 0:0:1:0: [sdd] Attached SCSI disk
[   10.380618] sd 0:0:3:0: Attached scsi generic sg6 type 0
[   10.381851] sd 0:0:4:0: [sdg] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[   10.381918] sd 0:0:4:0: Attached scsi generic sg7 type 0
[   10.382011] sd 0:0:4:0: [sdg] Write Protect is off
[   10.382022] sd 0:0:4:0: [sdg] Mode Sense: 00 3a 00 00
[   10.382088] sd 0:0:4:0: [sdg] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   10.382505] sd 0:0:5:0: [sdh] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[   10.382575] sd 0:0:5:0: Attached scsi generic sg8 type 0
[   10.382673] sd 0:0:5:0: [sdh] Write Protect is off
[   10.382681] sd 0:0:5:0: [sdh] Mode Sense: 00 3a 00 00
[   10.382756] sd 0:0:5:0: [sdh] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   10.383111] sd 0:0:6:0: [sdi] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[   10.383229] sdg: detected capacity change from 0 to 2000398934016
[   10.383234] sd 0:0:6:0: Attached scsi generic sg9 type 0
[   10.383254] sd 0:0:6:0: [sdi] Write Protect is off
[   10.383262] sd 0:0:6:0: [sdi] Mode Sense: 00 3a 00 00
[   10.383317] sd 0:0:6:0: [sdi] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   10.383371] sdh: detected capacity change from 0 to 2000398934016
[   10.383412]  sdg: unknown partition table
[   10.383543]  sdh: unknown partition table
[   10.383760] sd 0:0:7:0: [sdj] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[   10.383848] sdi: detected capacity change from 0 to 2000398934016
[   10.383887] sd 0:0:7:0: [sdj] Write Protect is off
[   10.383895] sd 0:0:7:0: [sdj] Mode Sense: 00 3a 00 00
[   10.383900] sd 0:0:7:0: Attached scsi generic sg10 type 0
[   10.383953] sd 0:0:7:0: [sdj] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   10.384031] sd 0:0:5:0: [sdh] Attached SCSI disk
[   10.384044]  sdi: unknown partition table
[   10.384195] ses 0:0:8:0: Attached Enclosure device
[   10.384333] ses 0:0:8:0: Attached scsi generic sg11 type 13
[   10.384434] sdj: detected capacity change from 0 to 2000398934016
[   10.384638] sd 0:0:3:0: [sdf] Attached SCSI disk
[   10.384998]  sdj: unknown partition table
[   10.385074] sd 0:0:4:0: [sdg] Attached SCSI disk
[   10.385306] sd 0:0:6:0: [sdi] Attached SCSI disk
[   10.385408] sd 0:0:7:0: [sdj] Attached SCSI disk
[   10.406981] md: bind<sdf>
[   10.409912] md: bind<sdg>
[   10.411899] md: bind<sdh>
[   10.610952] md: bind<sde>
[   10.813383] md: bind<sdi>
[   11.014155] md: bind<sdj>
[   11.126868] EXT3-fs: barriers not enabled
[   11.135052] kjournald starting.  Commit interval 5 seconds
[   11.135095] EXT3-fs (md0): mounted filesystem with ordered data mode
[   12.477328] udev: starting version 151
[   12.862059] piix4_smbus 0000:00:14.0: SMBus Host Controller at 0xb00, revision 0
[   12.883731] MCE: In-kernel MCE decoding enabled.
[   12.907431] EDAC MC: Ver: 2.1.0 May 24 2011
[   13.000843] AMD64 EDAC driver v3.4.0
[   13.001004] EDAC amd64: DRAM ECC enabled.
[   13.001031] EDAC amd64: F10h detected (node 0).
[   13.001076] EDAC MC: DCT0 chip selects:
[   13.001082] EDAC amd64: MC: 0:     0MB 1:     0MB
[   13.001088] EDAC amd64: MC: 2:  1024MB 3:  1024MB
[   13.001094] EDAC amd64: MC: 4:     0MB 5:     0MB
[   13.001098] EDAC amd64: MC: 6:     0MB 7:     0MB
[   13.001103] EDAC MC: DCT1 chip selects:
[   13.001107] EDAC amd64: MC: 0:     0MB 1:     0MB
[   13.001112] EDAC amd64: MC: 2:  1024MB 3:  1024MB
[   13.001117] EDAC amd64: MC: 4:     0MB 5:     0MB
[   13.001122] EDAC amd64: MC: 6:     0MB 7:     0MB
[   13.001126] EDAC amd64: using x8 syndromes.
[   13.001131] EDAC amd64: MCT channel count: 2
[   13.001185] EDAC amd64: CS2: Unbuffered DDR3 RAM
[   13.001190] EDAC amd64: CS3: Unbuffered DDR3 RAM
[   13.001257] EDAC MC0: Giving out device to 'amd64_edac' 'F10h': DEV 0000:00:18.2
[   13.001355] EDAC PCI0: Giving out device to module 'amd64_edac' controller 'EDAC PCI controller': DEV '0000:00:18.2' (POLLED)
[   13.316107] EXT3-fs (md0): using internal journal
[   13.621885] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   13.852015] EXT3-fs: barriers not enabled
[   13.861602] kjournald starting.  Commit interval 5 seconds
[   13.861991] EXT3-fs (md1): using internal journal
[   13.862003] EXT3-fs (md1): mounted filesystem with ordered data mode
[   16.771103] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: None
[   16.772512] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   26.940088] eth0: no IPv6 routers present

--Multipart=_Mon__6_Jun_2011_13_06_28_+0200_9J0voi1iz7J4tLM4
Content-Type: text/plain;
 name="proc.scsi.scsi.txt"
Content-Disposition: attachment;
 filename="proc.scsi.scsi.txt"
Content-Transfer-Encoding: 7bit

Attached devices:
Host: scsi1 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: WDC WD3202ABYS-0 Rev: 02.0
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi2 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: WDC WD3202ABYS-0 Rev: 02.0
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi3 Channel: 00 Id: 00 Lun: 00
  Vendor: HL-DT-ST Model: DVDRAM GT20N     Rev: CQ02
  Type:   CD-ROM                           ANSI  SCSI revision: 05
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: WDC WD2003FYYS-0 Rev: 01.0
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi0 Channel: 00 Id: 01 Lun: 00
  Vendor: ATA      Model: WDC WD2003FYYS-0 Rev: 01.0
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi0 Channel: 00 Id: 02 Lun: 00
  Vendor: ATA      Model: WDC WD2002FYPS-0 Rev: 04.0
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi0 Channel: 00 Id: 03 Lun: 00
  Vendor: ATA      Model: WDC WD2003FYYS-0 Rev: 01.0
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi0 Channel: 00 Id: 04 Lun: 00
  Vendor: ATA      Model: WDC WD2002FYPS-0 Rev: 04.0
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi0 Channel: 00 Id: 05 Lun: 00
  Vendor: ATA      Model: WDC WD2002FYPS-0 Rev: 04.0
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi0 Channel: 00 Id: 06 Lun: 00
  Vendor: ATA      Model: WDC WD2002FYPS-0 Rev: 04.0
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi0 Channel: 00 Id: 07 Lun: 00
  Vendor: ATA      Model: WDC WD2002FYPS-0 Rev: 04.0
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi0 Channel: 00 Id: 08 Lun: 00
  Vendor: Areca    Model: x28-05.63.1.32   Rev: 000 
  Type:   Enclosure                        ANSI  SCSI revision: 03

--Multipart=_Mon__6_Jun_2011_13_06_28_+0200_9J0voi1iz7J4tLM4--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995Ab1AZSE2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 13:04:28 -0500
Received: from www17.your-server.de ([213.133.104.17]:36022 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584Ab1AZSEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 13:04:23 -0500
Subject: Re: 2.6.38-rc2: acpi backlight control missing
From: Thomas Meyer <thomas@m3y3r.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Mailing List <linux-acpi@gver.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>
In-Reply-To: <201101222043.07703.rjw@sisk.pl>
References: <1295693349.2120.3.camel@localhost.localdomain>
	 <201101222043.07703.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 Jan 2011 19:01:24 +0100
Message-ID: <1296064885.2006.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, den 22.01.2011, 20:43 +0100 schrieb Rafael J. Wysocki:
> On Saturday, January 22, 2011, Thomas Meyer wrote:
> > with 2.6.38-rc2 the acpi backlight is gone:
> > 
> > any ideas?
> 
> Not really, but Matthew may have some (CCed).

with 2.6.38-rc2-00175-g6fb1b30 the i915 driver tells me: "No ACPI video
bus found".

For some reasons the ACPI video device is gone.

I tried some acpi debug options but I can't see the problem. Maybe
someone else can?

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.38-rc2-00175-g6fb1b30 (thomas@localhost.localdomain) (gcc version 4.5.1 20100924 (Red Hat 4.5.1-4) (GCC) ) #245 Wed Jan 26 17:49:59 CET 2011
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009e000 (usable)
[    0.000000]  BIOS-e820: 000000000009e000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007ba63000 (usable)
[    0.000000]  BIOS-e820: 000000007ba63000 - 000000007babf000 (reserved)
[    0.000000]  BIOS-e820: 000000007babf000 - 000000007bb80000 (usable)
[    0.000000]  BIOS-e820: 000000007bb80000 - 000000007bbbf000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007bbbf000 - 000000007bbe0000 (usable)
[    0.000000]  BIOS-e820: 000000007bbe0000 - 000000007bbf7000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007bbf7000 - 000000007bc00000 (usable)
[    0.000000]  BIOS-e820: 000000007bc00000 - 0000000080000000 (reserved)
[    0.000000]  BIOS-e820: 00000000f8000000 - 00000000fc000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed10000 - 00000000fed14000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed18000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
[    0.000000] DMI 2.6 present.
[    0.000000] DMI: JM11-MS/Aspire 1810T, BIOS v1.3310 03/25/2010
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] last_pfn = 0x7bc00 max_arch_pfn = 0x100000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-through
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask FC0000000 write-back
[    0.000000]   1 base 0FFE00000 mask FFFE00000 write-protect
[    0.000000]   2 base 040000000 mask FC0000000 write-back
[    0.000000]   3 base 07C000000 mask FFC000000 uncachable
[    0.000000]   4 base 07BC00000 mask FFFC00000 uncachable
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] initial memory mapped : 0 - 01000000
[    0.000000] init_memory_mapping: 0000000000000000-00000000377fe000
[    0.000000]  0000000000 - 0000400000 page 4k
[    0.000000]  0000400000 - 0037400000 page 2M
[    0.000000]  0037400000 - 00377fe000 page 4k
[    0.000000] kernel direct mapping tables up to 377fe000 @ ffb000-1000000
[    0.000000] RAMDISK: 378a5000 - 37ff0000
[    0.000000] Allocated new RAMDISK: 370b3000 - 377fd8eb
[    0.000000] Move RAMDISK from 00000000378a5000 - 0000000037fef8ea to 370b3000 - 377fd8ea
[    0.000000] ACPI: RSDP 000fe020 00024 (v02 ACRSYS)
[    0.000000] ACPI: XSDT 7bbf6120 0007C (v01 ACRSYS ACRPRDCT 00000001      01000013)
[    0.000000] ACPI: FACP 7bbf4000 000F4 (v04 ACRSYS ACRPRDCT 00000001 1025 01000013)
[    0.000000] ACPI: DSDT 7bbe8000 073EA (v01 ACRSYS ACRPRDCT 00000001 1025 01000013)
[    0.000000] ACPI: FACS 7bb8d000 00040
[    0.000000] ACPI: DMAR 7bbf5000 00068 (v01               ? 00000001      00000000)
[    0.000000] ACPI: HPET 7bbf3000 00038 (v01 ACRSYS ACRPRDCT 00000001 1025 01000013)
[    0.000000] ACPI: APIC 7bbf2000 0006C (v02 ACRSYS ACRPRDCT 00000001 1025 01000013)
[    0.000000] ACPI: MCFG 7bbf1000 0003C (v01 ACRSYS ACRPRDCT 00000001 1025 01000013)
[    0.000000] ACPI: ASF! 7bbf0000 000A5 (v32 ACRSYS ACRPRDCT 00000001 1025 01000013)
[    0.000000] ACPI: SLIC 7bbe7000 00176 (v01 ACRSYS ACRPRDCT 00000001 1025 01000013)
[    0.000000] ACPI: BOOT 7bbe6000 00028 (v01 ACRSYS ACRPRDCT 00000001 1025 01000013)
[    0.000000] ACPI: SSDT 7bbe2000 00223 (v01  PmRef  Cpu0Ist 00003000 INTL 20051117)
[    0.000000] ACPI: SSDT 7bbe1000 00537 (v01  PmRef  Cpu0Cst 00003001 INTL 20051117)
[    0.000000] ACPI: SSDT 7bbe0000 00655 (v01  PmRef    CpuPm 00003000 INTL 20051117)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 1092MB HIGHMEM available.
[    0.000000] 887MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 377fe000
[    0.000000]   low ram: 0 - 377fe000
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000377fe
[    0.000000]   HighMem  0x000377fe -> 0x0007bc00
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[5] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009e
[    0.000000]     0: 0x00000100 -> 0x0007ba63
[    0.000000]     0: 0x0007babf -> 0x0007bb80
[    0.000000]     0: 0x0007bbbf -> 0x0007bbe0
[    0.000000]     0: 0x0007bbf7 -> 0x0007bc00
[    0.000000] On node 0 totalpages: 506588
[    0.000000] free_area_init_node: node 0, pgdat c0a98220, node_mem_map f613a200
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3950 pages, LIFO batch:0
[    0.000000]   Normal zone: 1744 pages used for memmap
[    0.000000]   Normal zone: 221486 pages, LIFO batch:31
[    0.000000]   HighMem zone: 2185 pages used for memmap
[    0.000000]   HighMem zone: 277191 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x00] disabled)
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 80000000 (gap: 80000000:78000000)
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
[    0.000000] pcpu-alloc: [0] 0 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 502627
[    0.000000] Kernel command line: root=UUID=5764c1f2-f119-4f97-b8e2-d827b8655edb LANG=de_DE.UTF-8 SYSFONT=latarcyrheb-sun16 KEYBOARDTYPE=pc KEYTABLE=de-latin1-nodeadkeys kgdboc=kms,kbd resume=/dev/mapper/luks-swap rhgb quiet init=/bin/systemd acpi.debug_layer=0x10010000 acpi.debug_level=0xffffffff
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] xsave/xrstor: enabled xstate_bv 0x3, cntxt size 0x240
[    0.000000] allocated 10137280 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: at drivers/pci/dmar.c:634 warn_invalid_dmar+0x96/0xa0()
[    0.000000] Hardware name: Aspire 1810T
[    0.000000] Your BIOS is broken; DMAR reported at address 0!
[    0.000000] BIOS vendor: INSYDE; Ver: v1.3310; Product Version: v1.3310
[    0.000000] Modules linked in:
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.38-rc2-00175-g6fb1b30 #245
[    0.000000] Call Trace:
[    0.000000]  [<c04327f2>] ? warn_slowpath_common+0x72/0xa0
[    0.000000]  [<c060f4c6>] ? warn_invalid_dmar+0x96/0xa0
[    0.000000]  [<c060f4c6>] ? warn_invalid_dmar+0x96/0xa0
[    0.000000]  [<c0432882>] ? warn_slowpath_fmt_taint+0x32/0x40
[    0.000000]  [<c060f4c6>] ? warn_invalid_dmar+0x96/0xa0
[    0.000000]  [<c0ad5c14>] ? check_zero_address+0x53/0x123
[    0.000000]  [<c0653593>] ? acpi_tb_verify_table+0x4b/0x4e
[    0.000000]  [<c06534d7>] ? acpi_get_table_with_size+0x59/0xae
[    0.000000]  [<c0ad5cf6>] ? detect_intel_iommu+0x12/0x78
[    0.000000]  [<c0ab756d>] ? pci_iommu_alloc+0x35/0x5a
[    0.000000]  [<c0ac11a5>] ? mem_init+0xe/0x265
[    0.000000]  [<c0ac8ea2>] ? __alloc_bootmem_node_nopanic+0x72/0x93
[    0.000000]  [<c08752e3>] ? printk+0x2d/0x32
[    0.000000]  [<c0accbfc>] ? page_cgroup_init_flatmem+0xab/0xd9
[    0.000000]  [<c0ab25c5>] ? start_kernel+0x187/0x31d
[    0.000000]  [<c0ab21c2>] ? unknown_bootoption+0x0/0x1a3
[    0.000000]  [<c0ab20bd>] ? i386_start_kernel+0xbd/0xc5
[    0.000000] ---[ end trace a7919e7f17c0a725 ]---
[    0.000000] Disabling lock debugging due to kernel taint
[    0.000000] Initializing HighMem for node 0 (000377fe:0007bc00)
[    0.000000] Memory: 1984040k/2027520k available (4599k kernel code, 42312k reserved, 2253k data, 488k init, 1117504k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffa3000 - 0xfffff000   ( 368 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
[    0.000000]       .init : 0xc0ab2000 - 0xc0b2c000   ( 488 kB)
[    0.000000]       .data : 0xc087de36 - 0xc0ab1280   (2253 kB)
[    0.000000]       .text : 0xc0400000 - 0xc087de36   (4599 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.000000] NR_IRQS:288
[    0.000000] CPU 0 irqstacks, hard=f500c000 soft=f500e000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 1396.413 MHz processor.
[    0.003336] Calibrating delay loop (skipped), value calculated using timer frequency.. 2793.19 BogoMIPS (lpj=4654710)
[    0.003341] pid_max: default: 32768 minimum: 301
[    0.003381] Security Framework initialized
[    0.003386] SELinux:  Initializing.
[    0.003399] SELinux:  Starting in permissive mode
[    0.003475] Mount-cache hash table entries: 512
[    0.003606] Initializing cgroup subsys ns
[    0.003611] ns_cgroup deprecated: consider using the 'clone_children' flag without the ns_cgroup.
[    0.003615] Initializing cgroup subsys cpuacct
[    0.003620] Initializing cgroup subsys memory
[    0.003630] Initializing cgroup subsys devices
[    0.003633] Initializing cgroup subsys freezer
[    0.003636] Initializing cgroup subsys net_cls
[    0.003639] Initializing cgroup subsys blkio
[    0.003682] mce: CPU supports 6 MCE banks
[    0.003692] CPU0: Thermal monitoring enabled (TM2)
[    0.003696] using mwait in idle threads.
[    0.003704] CPU: Intel(R) Core(TM)2 Solo CPU    U3500  @ 1.40GHz stepping 0a
[    0.004350] ACPI: Core revision 20110112
[    0.023346] ftrace: allocating 19563 entries in 39 pages
[    0.026705] Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
[    0.026716] ... version:                2
[    0.026718] ... bit width:              40
[    0.026720] ... generic registers:      2
[    0.026723] ... value mask:             000000ffffffffff
[    0.026725] ... max period:             000000007fffffff
[    0.026727] ... fixed-purpose events:   3
[    0.026729] ... event mask:             0000000700000003
[    0.028078] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.028427] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.063329] print_constraints: dummy: 
[    0.063329] NET: Registered protocol family 16
[    0.063329] ACPI: bus type pci registered
[    0.063329] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.063329] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.063329] PCI: Using MMCONFIG for extended config space
[    0.063329] PCI: Using configuration type 1 for base access
[    0.063329] bio: create slab <bio-0> at 0
[    0.066729] ACPI: EC: Look up EC in DSDT
[    0.066959] 
[    0.066960] **** Context Switch from TID 0 to TID 4110443520 ****
[    0.066961] 
[    0.066964]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [24]
[    0.066974]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.LPC_.EC0_._GLK]: AE_NOT_FOUND
[    0.069916] Initializing Region       \MBOX
[    0.069975] ACPI: Executed 1 blocks of module-level executable AML code
[    0.070263] Initializing Region       \_SB_.PCI0.HBUS
[    0.070295] Initializing Region       \_SB_.PCI0.MCHT
[    0.070343] Initializing Region       \_SB_.PCI0.OVGA.IGDP
[    0.070366] Initializing Region       \_SB_.PCI0.OVGA.IGDM
[    0.070396] Initializing Region       \NVST
[    0.070575] Initializing Region       \_SB_.PCI0.MCHP
[    0.070595] Initializing Region       \_SB_.PCI0.LPC_.PMIO
[    0.070613] Initializing Region       \_SB_.PCI0.LPC_.GPIO
[    0.070659] Initializing Region       \_SB_.PCI0.LPC_.PRR0
[    0.070678] Initializing Region       \_SB_.PCI0.LPC_.PRR1
[    0.070697] Initializing Region       \_SB_.PCI0.LPC_.PRR2
[    0.070956] Initializing Region       \_SB_.PCI0.LPC_.EC0_.ERAM
[    0.071033] Initializing BufferField  \_SB_.PCI0.LPC_.EC0_.BF00
[    0.071058] Initializing BufferField  \_SB_.PCI0.LPC_.EC0_.BF01
[    0.071095] Initializing Region       \_SB_.PCI0.UHC0.USBR
[    0.071168] Initializing Region       \_SB_.PCI0.UHC1.USBR
[    0.071241] Initializing Region       \_SB_.PCI0.UHC2.USBR
[    0.071313] Initializing Region       \_SB_.PCI0.UHCR.USBR
[    0.071425] Initializing Region       \_SB_.PCI0.EHC1.USBR
[    0.071479] Initializing Region       \_SB_.PCI0.UHC3.USBR
[    0.071551] Initializing Region       \_SB_.PCI0.UHC4.USBR
[    0.071623] Initializing Region       \_SB_.PCI0.UHC5.USBR
[    0.071750] Initializing Region       \_SB_.PCI0.EHC2.USBR
[    0.071770] Initializing Region       \_SB_.PCI0.EXP1.PXCS
[    0.071820] Initializing Region       \_SB_.PCI0.EXP2.PXCS
[    0.071870] Initializing Region       \_SB_.PCI0.EXP3.PXCS
[    0.071920] Initializing Region       \_SB_.PCI0.EXP4.PXCS
[    0.071970] Initializing Region       \_SB_.PCI0.EXP5.PXCS
[    0.072021] Initializing Region       \_SB_.PCI0.EXP6.PXCS
[    0.072453] Initializing BufferField  \_SB_.PCI0.WMID.BF00
[    0.072475] Initializing BufferField  \_SB_.PCI0.WMID.BF01
[    0.072496] Initializing BufferField  \_SB_.PCI0.WMID.BF02
[    0.072517] Initializing BufferField  \_SB_.PCI0.WMID.BF03
[    0.072537] Initializing BufferField  \_SB_.PCI0.WMID.BFW0
[    0.072558] Initializing BufferField  \_SB_.PCI0.WMID.BFW1
[    0.072579] Initializing BufferField  \_SB_.PCI0.WMID.AS00
[    0.072603] Initializing BufferField  \_SB_.PCI0.WMID.AS04
[    0.072626] Initializing BufferField  \_SB_.PCI0.WMID.AS05
[    0.072649] Initializing BufferField  \_SB_.PCI0.WMID.AS06
[    0.072672] Initializing BufferField  \_SB_.PCI0.WMID.AS07
[    0.072695] Initializing BufferField  \_SB_.PCI0.WMID.AS08
[    0.072718] Initializing BufferField  \_SB_.PCI0.WMID.AS0X
[    0.072741] Initializing BufferField  \_SB_.PCI0.WMID.BBD0
[    0.072765] Initializing BufferField  \_SB_.PCI0.WMID.BBD1
[    0.072789] Initializing BufferField  \_SB_.PCI0.WMID.BDD0
[    0.072812] Initializing BufferField  \_SB_.PCI0.WMID.BDD1
[    0.072836] Initializing BufferField  \_SB_.PCI0.WMID.DY00
[    0.072860] Initializing BufferField  \_SB_.PCI0.WMID.DY01
[    0.072883] Initializing BufferField  \_SB_.PCI0.WMID.DY02
[    0.072907] Initializing BufferField  \_SB_.PCI0.WMID.DY03
[    0.072931] Initializing BufferField  \_SB_.PCI0.WMID.DY04
[    0.072954] Initializing BufferField  \_SB_.PCI0.WMID.DY10
[    0.072978] Initializing BufferField  \_SB_.PCI0.WMID.DY11
[    0.073001] Initializing BufferField  \_SB_.PCI0.WMID.DY12
[    0.073025] Initializing BufferField  \_SB_.PCI0.WMID.DY20
[    0.073049] Initializing BufferField  \_SB_.PCI0.WMID.DY21
[    0.073072] Initializing BufferField  \_SB_.PCI0.WMID.DY22
[    0.073096] Initializing BufferField  \_SB_.PCI0.WMID.DSX4
[    0.073119] Initializing BufferField  \_SB_.PCI0.WMID.DY60
[    0.073143] Initializing BufferField  \_SB_.PCI0.WMID.DY61
[    0.073167] Initializing BufferField  \_SB_.PCI0.WMID.DY62
[    0.073191] Initializing BufferField  \_SB_.PCI0.WMID.DY63
[    0.073214] Initializing BufferField  \_SB_.PCI0.WMID.DY64
[    0.073238] Initializing BufferField  \_SB_.PCI0.WMID.WWD0
[    0.073261] Initializing BufferField  \_SB_.PCI0.WMID.WWD1
[    0.073285] Initializing BufferField  \_SB_.PCI0.WMID.WWD2
[    0.073309] Initializing BufferField  \_SB_.PCI0.WMID.WWD3
[    0.073337] Initializing BufferField  \_SB_.PCI0.WMID.WWD4
[    0.073361] Initializing BufferField  \_SB_.PCI0.WMID.WWD5
[    0.073385] Initializing BufferField  \_SB_.PCI0.WMID.WPIR
[    0.073408] Initializing BufferField  \_SB_.PCI0.WMID.WPIF
[    0.073432] Initializing BufferField  \_SB_.PCI0.WMID.WPID
[    0.073456] Initializing BufferField  \_SB_.PCI0.WMID.WPIB
[    0.073479] Initializing BufferField  \_SB_.PCI0.WMID.BO10
[    0.073503] Initializing BufferField  \_SB_.PCI0.WMID.BO11
[    0.073527] Initializing BufferField  \_SB_.PCI0.WMID.BO12
[    0.073551] Initializing BufferField  \_SB_.PCI0.WMID.BO13
[    0.073574] Initializing BufferField  \_SB_.PCI0.WMID.BO14
[    0.073598] Initializing BufferField  \_SB_.PCI0.WMID.BO20
[    0.073622] Initializing BufferField  \_SB_.PCI0.WMID.BO30
[    0.073645] Initializing BufferField  \_SB_.PCI0.WMID.BO40
[    0.073669] Initializing BufferField  \_SB_.PCI0.WMID.PN01
[    0.073692] Initializing BufferField  \_SB_.PCI0.WMID.PN02
[    0.073716] Initializing BufferField  \_SB_.PCI0.WMID.PN03
[    0.073740] Initializing BufferField  \_SB_.PCI0.WMID.PN04
[    0.073764] Initializing BufferField  \_SB_.PCI0.WMID.PN05
[    0.073788] Initializing BufferField  \_SB_.PCI0.WMID.PN06
[    0.073811] Initializing BufferField  \_SB_.PCI0.WMID.PN07
[    0.073835] Initializing BufferField  \_SB_.PCI0.WMID.PN08
[    0.073859] Initializing BufferField  \_SB_.PCI0.WMID.PN09
[    0.073882] Initializing BufferField  \_SB_.PCI0.WMID.PN10
[    0.073906] Initializing BufferField  \_SB_.PCI0.WMID.PN11
[    0.073930] Initializing BufferField  \_SB_.PCI0.WMID.PN12
[    0.073954] Initializing BufferField  \_SB_.PCI0.WMID.PN13
[    0.073978] Initializing BufferField  \_SB_.PCI0.WMID.PN14
[    0.074002] Initializing BufferField  \_SB_.PCI0.WMID.PN15
[    0.074025] Initializing BufferField  \_SB_.PCI0.WMID.PN16
[    0.074049] Initializing BufferField  \_SB_.PCI0.WMID.PN17
[    0.074073] Initializing BufferField  \_SB_.PCI0.WMID.PN18
[    0.074127] Initializing Region       \GPIO
[    0.074147] Initializing Region       \PMBA
[    0.074166] Initializing Region       \RCRB
[    0.074375] Initializing Region       \IO_T
[    0.074393] Initializing Region       \IO_D
[    0.074410] Initializing Region       \IO_H
[    0.074480] Initializing Region       \PRT0
[    0.074498] Initializing Region       \SPRT
[    0.074516] Initializing Region       \CMS1
[    0.074535] Initializing Region       \SMIO
[    0.074705] Executing  Method       \_SB_._STA
[    0.074712] Executing  Method       \_SB_._INI
[    0.074718] Executing  Method       \_SB_.PCI0._STA
[    0.074725] Executing  Method       \_SB_.PCI0._INI
[    0.074779] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.076098] ACPI Error: Could not map memory at 0x0000000079DD2018, size 463 (20110112/exregion-178)
[    0.076106] ACPI Exception: AE_NO_MEMORY, Returned by Handler for [SystemMemory] (20110112/evregion-474)
[    0.076113] ACPI Error: Method parse/execution failed [\_PR_.CPU1.APPT] (Node f5058108), AE_NO_MEMORY (20110112/psparse-536)
[    0.076125] ACPI Error: Method parse/execution failed [\_PR_.CPU1.GCAP] (Node f50580d8), AE_NO_MEMORY (20110112/psparse-536)
[    0.076135] ACPI Error: Method parse/execution failed [\_PR_.CPU1._PDC] (Node f50580a8), AE_NO_MEMORY (20110112/psparse-536)
[    0.076781] ACPI Error: Could not map memory at 0x0000000079DCC918, size 141 (20110112/exregion-178)
[    0.076788] ACPI Exception: AE_NO_MEMORY, Returned by Handler for [SystemMemory] (20110112/evregion-474)
[    0.076796] ACPI Error: Method parse/execution failed [\_PR_.CPU1.APCT] (Node f50580f0), AE_NO_MEMORY (20110112/psparse-536)
[    0.076806] ACPI Error: Method parse/execution failed [\_PR_.CPU2.GCAP] (Node f5058150), AE_NO_MEMORY (20110112/psparse-536)
[    0.076816] ACPI Error: Method parse/execution failed [\_PR_.CPU2._PDC] (Node f5058120), AE_NO_MEMORY (20110112/psparse-536)
[    0.077743] Executing  Method       \_SB_.PCI0.LPC_.EC0_._REG
[    0.077844] ACPI: Interpreter enabled
[    0.077850] ACPI: (supports S0 S3 S4 S5)
[    0.077895] ACPI: Using IOAPIC for interrupt routing
[    0.077952]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\._STA]: AE_NOT_FOUND
[    0.077960]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [ffffffff]
[    0.078024]     scan-1312 [4110443520] [00] add_single_object     : Adding LNXSYSTM:00 [\] parent (null)
[    0.078043]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_PR_.CPU0._STA]: AE_NOT_FOUND
[    0.078051]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f5040d80]
[    0.078058]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f5037018]
[    0.078101]     scan-1312 [4110443520] [00] add_single_object     : Adding LNXCPU:00 [\_PR_.CPU0] parent LNXSYSTM:00
[    0.078120]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_PR_.CPU1._STA]: AE_NOT_FOUND
[    0.078127]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f5040d98]
[    0.078134]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f5037018]
[    0.078175]     scan-1312 [4110443520] [00] add_single_object     : Adding LNXCPU:01 [\_PR_.CPU1] parent LNXSYSTM:00
[    0.078190]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_PR_.CPU2._STA]: AE_NOT_FOUND
[    0.078197]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f5040db0]
[    0.078204]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f5037018]
[    0.078245]     scan-1312 [4110443520] [00] add_single_object     : Adding LNXCPU:02 [\_PR_.CPU2] parent LNXSYSTM:00
[    0.078257]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_PR_.CPU3._STA]: AE_NOT_FOUND
[    0.078263]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f5040dc8]
[    0.078272]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f5037018]
[    0.078315]     scan-1312 [4110443520] [00] add_single_object     : Adding LNXCPU:03 [\_PR_.CPU3] parent LNXSYSTM:00
[    0.078328]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_._STA]: AE_NOT_FOUND
[    0.078335]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f5037030]
[    0.078406]     scan-1312 [4110443520] [00] add_single_object     : Adding device:00 [\_SB_] parent LNXSYSTM:00
[    0.078415]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PWRB._STA]: AE_NOT_FOUND
[    0.078422]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f503c108]
[    0.078499]     scan-1312 [4110443520] [00] add_single_object     : Adding PNP0C0C:00 [\_SB_.PWRB] parent device:00
[    0.078509]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.LID0._STA]: AE_NOT_FOUND
[    0.078516]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f503c138]
[    0.078592]     scan-1312 [4110443520] [00] add_single_object     : Adding PNP0C0D:00 [\_SB_.LID0] parent device:00
[    0.078603]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.SLPB._STA]: AE_NOT_FOUND
[    0.078610]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f503c180]
[    0.078690]     scan-1312 [4110443520] [00] add_single_object     : Adding PNP0C0E:00 [\_SB_.SLPB] parent device:00
[    0.078722]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [15]
[    0.078729]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f503c1b0]
[    0.078829]     scan-1312 [4110443520] [00] add_single_object     : Adding PNP0C0A:00 [\_SB_.BAT1] parent device:00
[    0.078854]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.ACAD._STA]: AE_NOT_FOUND
[    0.078861]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f503c3f0]
[    0.078937]     scan-1312 [4110443520] [00] add_single_object     : Adding ACPI0003:00 [\_SB_.ACAD] parent device:00
[    0.078950]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0._STA]: AE_NOT_FOUND
[    0.078958]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f503c468]
[    0.079045]     scan-1312 [4110443520] [00] add_single_object     : Adding PNP0A08:00 [\_SB_.PCI0] parent device:00
[    0.079082]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.OVGA._STA]: AE_NOT_FOUND
[    0.079089]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f503c858]
[    0.079173]     scan-1312 [4110443520] [00] add_single_object     : Adding device:01 [\_SB_.PCI0.OVGA] parent PNP0A08:00
[    0.079185]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.OVGA.DD01._STA]: AE_NOT_FOUND
[    0.079192]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f503c8b8]
[    0.079333]     scan-1312 [4110443520] [00] add_single_object     : Adding device:02 [\_SB_.PCI0.OVGA.DD01] parent device:01
[    0.079346]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.OVGA.DD02._STA]: AE_NOT_FOUND
[    0.079354]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f503c930]
[    0.079482]     scan-1312 [4110443520] [00] add_single_object     : Adding device:03 [\_SB_.PCI0.OVGA.DD02] parent device:01
[    0.079495]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.OVGA.DD03._STA]: AE_NOT_FOUND
[    0.079502]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f503c9a8]
[    0.079632]     scan-1312 [4110443520] [00] add_single_object     : Adding device:04 [\_SB_.PCI0.OVGA.DD03] parent device:01
[    0.079647]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.OVGA.DD04._STA]: AE_NOT_FOUND
[    0.079654]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f503ca68]
[    0.079782]     scan-1312 [4110443520] [00] add_single_object     : Adding device:05 [\_SB_.PCI0.OVGA.DD04] parent device:01
[    0.079795]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.OVGA.DD05._STA]: AE_NOT_FOUND
[    0.079802]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f503cae0]
[    0.079929]     scan-1312 [4110443520] [00] add_single_object     : Adding device:06 [\_SB_.PCI0.OVGA.DD05] parent device:01
[    0.080016]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.LPC_._STA]: AE_NOT_FOUND
[    0.080024]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f503a588]
[    0.080107]     scan-1312 [4110443520] [00] add_single_object     : Adding device:07 [\_SB_.PCI0.LPC_] parent PNP0A08:00
[    0.081066]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [11]
[    0.081073]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f503ad50]
[    0.081188]     scan-1312 [4110443520] [00] add_single_object     : Adding PNP0C0F:00 [\_SB_.PCI0.LPC_.LNKA] parent device:07
[    0.081232]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [11]
[    0.081238]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f503ae10]
[    0.081353]     scan-1312 [4110443520] [00] add_single_object     : Adding PNP0C0F:01 [\_SB_.PCI0.LPC_.LNKB] parent device:07
[    0.081396]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [11]
[    0.081402]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f503aed0]
[    0.081514]     scan-1312 [4110443520] [00] add_single_object     : Adding PNP0C0F:02 [\_SB_.PCI0.LPC_.LNKC] parent device:07
[    0.081557]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [11]
[    0.081564]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f503af90]
[    0.081674]     scan-1312 [4110443520] [00] add_single_object     : Adding PNP0C0F:03 [\_SB_.PCI0.LPC_.LNKD] parent device:07
[    0.081731]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [9]
[    0.081738]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f5039060]
[    0.081851]     scan-1312 [4110443520] [00] add_single_object     : Adding PNP0C0F:04 [\_SB_.PCI0.LPC_.LNKE] parent device:07
[    0.081893]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [9]
[    0.081900]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f5039120]
[    0.082010]     scan-1312 [4110443520] [00] add_single_object     : Adding PNP0C0F:05 [\_SB_.PCI0.LPC_.LNKF] parent device:07
[    0.082054]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [11]
[    0.082060]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f50391e0]
[    0.082171]     scan-1312 [4110443520] [00] add_single_object     : Adding PNP0C0F:06 [\_SB_.PCI0.LPC_.LNKG] parent device:07
[    0.082214]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [11]
[    0.082221]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f50392a0]
[    0.082333]     scan-1312 [4110443520] [00] add_single_object     : Adding PNP0C0F:07 [\_SB_.PCI0.LPC_.LNKH] parent device:07
[    0.082347]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.LPC_.SYSR._STA]: AE_NOT_FOUND
[    0.082354]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f5039360]
[    0.082440]     scan-1312 [4110443520] [00] add_single_object     : Adding PNP0C02:00 [\_SB_.PCI0.LPC_.SYSR] parent device:07
[    0.082452]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.LPC_.DMAC._STA]: AE_NOT_FOUND
[    0.082459]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f50393c0]
[    0.082540]     scan-1312 [4110443520] [00] add_single_object     : Adding PNP0200:00 [\_SB_.PCI0.LPC_.DMAC] parent device:07
[    0.082551]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.LPC_.RTC_._STA]: AE_NOT_FOUND
[    0.082558]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f5039408]
[    0.082638]     scan-1312 [4110443520] [00] add_single_object     : Adding PNP0B00:00 [\_SB_.PCI0.LPC_.RTC_] parent device:07
[    0.082710]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [15]
[    0.082717]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f5039480]
[    0.082848]     scan-1312 [4110443520] [00] add_single_object     : Adding PNP0103:00 [\_SB_.PCI0.LPC_.HPET] parent device:07
[    0.082861]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.LPC_.PIC_._STA]: AE_NOT_FOUND
[    0.082868]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f50394f8]
[    0.082951]     scan-1312 [4110443520] [00] add_single_object     : Adding PNP0000:00 [\_SB_.PCI0.LPC_.PIC_] parent device:07
[    0.082963]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.LPC_.FPU_._STA]: AE_NOT_FOUND
[    0.082970]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f5039540]
[    0.083051]     scan-1312 [4110443520] [00] add_single_object     : Adding PNP0C04:00 [\_SB_.PCI0.LPC_.FPU_] parent device:07
[    0.083062]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.LPC_.TIMR._STA]: AE_NOT_FOUND
[    0.083070]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f5039588]
[    0.083150]     scan-1312 [4110443520] [00] add_single_object     : Adding PNP0100:00 [\_SB_.PCI0.LPC_.TIMR] parent device:07
[    0.083163]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.LPC_.FWHD._STA]: AE_NOT_FOUND
[    0.083170]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f5039600]
[    0.083249]     scan-1312 [4110443520] [00] add_single_object     : Adding INT0800:00 [\_SB_.PCI0.LPC_.FWHD] parent device:07
[    0.083272]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [15]
[    0.083278]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f5039648]
[    0.083381]     scan-1312 [4110443520] [00] add_single_object     : Adding PNP0303:00 [\_SB_.PCI0.LPC_.KBC_] parent device:07
[    0.083404]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [15]
[    0.083411]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f50396a8]
[    0.083505]     scan-1312 [4110443520] [00] add_single_object     : Adding SYN1B20:00 [\_SB_.PCI0.LPC_.MOUE] parent device:07
[    0.083519]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.LPC_.EC0_._STA]: AE_NOT_FOUND
[    0.083526]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f5039720]
[    0.083617]     scan-1312 [4110443520] [00] add_single_object     : Adding PNP0C09:00 [\_SB_.PCI0.LPC_.EC0_] parent device:07
[    0.083704]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.UHC0._STA]: AE_NOT_FOUND
[    0.083712]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f5042258]
[    0.083862]     scan-1312 [4110443520] [00] add_single_object     : Adding device:08 [\_SB_.PCI0.UHC0] parent PNP0A08:00
[    0.083877]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.UHC1._STA]: AE_NOT_FOUND
[    0.083885]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f5042318]
[    0.084037]     scan-1312 [4110443520] [00] add_single_object     : Adding device:09 [\_SB_.PCI0.UHC1] parent PNP0A08:00
[    0.084049]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.UHC1.UHUB._STA]: AE_NOT_FOUND
[    0.084056]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f5042360]
[    0.084133]     scan-1312 [4110443520] [00] add_single_object     : Adding device:0a [\_SB_.PCI0.UHC1.UHUB] parent device:09
[    0.084143]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.UHC1.UHUB.POR1._STA]: AE_NOT_FOUND
[    0.084151]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f5042390]
[    0.084228]     scan-1312 [4110443520] [00] add_single_object     : Adding device:0b [\_SB_.PCI0.UHC1.UHUB.POR1] parent device:0a
[    0.084240]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.UHC1.UHUB.POR2._STA]: AE_NOT_FOUND
[    0.084247]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f50423f0]
[    0.084328]     scan-1312 [4110443520] [00] add_single_object     : Adding device:0c [\_SB_.PCI0.UHC1.UHUB.POR2] parent device:0a
[    0.084344]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.UHC2._STA]: AE_NOT_FOUND
[    0.084352]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f50424c8]
[    0.084504]     scan-1312 [4110443520] [00] add_single_object     : Adding device:0d [\_SB_.PCI0.UHC2] parent PNP0A08:00
[    0.084516]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.UHC2.UHUB._STA]: AE_NOT_FOUND
[    0.084523]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f5042510]
[    0.084600]     scan-1312 [4110443520] [00] add_single_object     : Adding device:0e [\_SB_.PCI0.UHC2.UHUB] parent device:0d
[    0.084611]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.UHC2.UHUB.POR1._STA]: AE_NOT_FOUND
[    0.084618]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f5042540]
[    0.084696]     scan-1312 [4110443520] [00] add_single_object     : Adding device:0f [\_SB_.PCI0.UHC2.UHUB.POR1] parent device:0e
[    0.084708]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.UHC2.UHUB.POR2._STA]: AE_NOT_FOUND
[    0.084715]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f50425a0]
[    0.084792]     scan-1312 [4110443520] [00] add_single_object     : Adding device:10 [\_SB_.PCI0.UHC2.UHUB.POR2] parent device:0e
[    0.084808]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.UHCR._STA]: AE_NOT_FOUND
[    0.084816]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f5042678]
[    0.084966]     scan-1312 [4110443520] [00] add_single_object     : Adding device:11 [\_SB_.PCI0.UHCR] parent PNP0A08:00
[    0.084978]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.UHCR.UHUB._STA]: AE_NOT_FOUND
[    0.084986]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f50426c0]
[    0.085063]     scan-1312 [4110443520] [00] add_single_object     : Adding device:12 [\_SB_.PCI0.UHCR.UHUB] parent device:11
[    0.085074]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.UHCR.UHUB.POR1._STA]: AE_NOT_FOUND
[    0.085081]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f50426f0]
[    0.085158]     scan-1312 [4110443520] [00] add_single_object     : Adding device:13 [\_SB_.PCI0.UHCR.UHUB.POR1] parent device:12
[    0.085170]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.UHCR.UHUB.POR2._STA]: AE_NOT_FOUND
[    0.085178]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f5042750]
[    0.085255]     scan-1312 [4110443520] [00] add_single_object     : Adding device:14 [\_SB_.PCI0.UHCR.UHUB.POR2] parent device:12
[    0.085271]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.EHC1._STA]: AE_NOT_FOUND
[    0.085279]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f5042828]
[    0.085428]     scan-1312 [4110443520] [00] add_single_object     : Adding device:15 [\_SB_.PCI0.EHC1] parent PNP0A08:00
[    0.085439]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.EHC1.EHB1._STA]: AE_NOT_FOUND
[    0.085447]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f5042870]
[    0.085527]     scan-1312 [4110443520] [00] add_single_object     : Adding device:16 [\_SB_.PCI0.EHC1.EHB1] parent device:15
[    0.085537]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.EHC1.EHB1.POR3._STA]: AE_NOT_FOUND
[    0.085545]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f50428a0]
[    0.085623]     scan-1312 [4110443520] [00] add_single_object     : Adding device:17 [\_SB_.PCI0.EHC1.EHB1.POR3] parent device:16
[    0.085635]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.EHC1.EHB1.POR4._STA]: AE_NOT_FOUND
[    0.085642]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f5042900]
[    0.085720]     scan-1312 [4110443520] [00] add_single_object     : Adding device:18 [\_SB_.PCI0.EHC1.EHB1.POR4] parent device:16
[    0.085732]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.EHC1.EHB1.POR5._STA]: AE_NOT_FOUND
[    0.085739]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f5042960]
[    0.085816]     scan-1312 [4110443520] [00] add_single_object     : Adding device:19 [\_SB_.PCI0.EHC1.EHB1.POR5] parent device:16
[    0.085828]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.EHC1.EHB1.POR6._STA]: AE_NOT_FOUND
[    0.085836]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f50429c0]
[    0.085916]     scan-1312 [4110443520] [00] add_single_object     : Adding device:1a [\_SB_.PCI0.EHC1.EHB1.POR6] parent device:16
[    0.085932]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.UHC3._STA]: AE_NOT_FOUND
[    0.085939]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f5042a98]
[    0.086089]     scan-1312 [4110443520] [00] add_single_object     : Adding device:1b [\_SB_.PCI0.UHC3] parent PNP0A08:00
[    0.086101]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.UHC3.UHUB._STA]: AE_NOT_FOUND
[    0.086108]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f5042ae0]
[    0.086186]     scan-1312 [4110443520] [00] add_single_object     : Adding device:1c [\_SB_.PCI0.UHC3.UHUB] parent device:1b
[    0.086196]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.UHC3.UHUB.POR2._STA]: AE_NOT_FOUND
[    0.086204]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f5042b10]
[    0.086281]     scan-1312 [4110443520] [00] add_single_object     : Adding device:1d [\_SB_.PCI0.UHC3.UHUB.POR2] parent device:1c
[    0.086297]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.UHC4._STA]: AE_NOT_FOUND
[    0.086304]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f5042be8]
[    0.086456]     scan-1312 [4110443520] [00] add_single_object     : Adding device:1e [\_SB_.PCI0.UHC4] parent PNP0A08:00
[    0.086467]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.UHC4.UHUB._STA]: AE_NOT_FOUND
[    0.086475]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f5042c30]
[    0.086553]     scan-1312 [4110443520] [00] add_single_object     : Adding device:1f [\_SB_.PCI0.UHC4.UHUB] parent device:1e
[    0.086563]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.UHC4.UHUB.POR1._STA]: AE_NOT_FOUND
[    0.086571]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f5042c60]
[    0.086649]     scan-1312 [4110443520] [00] add_single_object     : Adding device:20 [\_SB_.PCI0.UHC4.UHUB.POR1] parent device:1f
[    0.086665]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.UHC4.UHUB.POR2._STA]: AE_NOT_FOUND
[    0.086673]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f5042cc0]
[    0.086752]     scan-1312 [4110443520] [00] add_single_object     : Adding device:21 [\_SB_.PCI0.UHC4.UHUB.POR2] parent device:1f
[    0.086768]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.UHC5._STA]: AE_NOT_FOUND
[    0.086775]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f5042d98]
[    0.086926]     scan-1312 [4110443520] [00] add_single_object     : Adding device:22 [\_SB_.PCI0.UHC5] parent PNP0A08:00
[    0.086938]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.UHC5.UHUB._STA]: AE_NOT_FOUND
[    0.086945]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f5042de0]
[    0.087023]     scan-1312 [4110443520] [00] add_single_object     : Adding device:23 [\_SB_.PCI0.UHC5.UHUB] parent device:22
[    0.087034]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.UHC5.UHUB.POR1._STA]: AE_NOT_FOUND
[    0.087041]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f5042e10]
[    0.087120]     scan-1312 [4110443520] [00] add_single_object     : Adding device:24 [\_SB_.PCI0.UHC5.UHUB.POR1] parent device:23
[    0.087132]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.UHC5.UHUB.POR2._STA]: AE_NOT_FOUND
[    0.087139]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f5042e70]
[    0.087218]     scan-1312 [4110443520] [00] add_single_object     : Adding device:25 [\_SB_.PCI0.UHC5.UHUB.POR2] parent device:23
[    0.087234]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.EHC2._STA]: AE_NOT_FOUND
[    0.087241]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f5042f48]
[    0.087392]     scan-1312 [4110443520] [00] add_single_object     : Adding device:26 [\_SB_.PCI0.EHC2] parent PNP0A08:00
[    0.087404]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.EHC2.EHB1._STA]: AE_NOT_FOUND
[    0.087411]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f5042f90]
[    0.087492]     scan-1312 [4110443520] [00] add_single_object     : Adding device:27 [\_SB_.PCI0.EHC2.EHB1] parent device:26
[    0.087503]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.EHC2.EHB1.POR2._STA]: AE_NOT_FOUND
[    0.087510]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f5042fc0]
[    0.087590]     scan-1312 [4110443520] [00] add_single_object     : Adding device:28 [\_SB_.PCI0.EHC2.EHB1.POR2] parent device:27
[    0.087602]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.EHC2.EHB1.POR3._STA]: AE_NOT_FOUND
[    0.087609]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f5043030]
[    0.087692]     scan-1312 [4110443520] [00] add_single_object     : Adding device:29 [\_SB_.PCI0.EHC2.EHB1.POR3] parent device:27
[    0.087705]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.EHC2.EHB1.POR4._STA]: AE_NOT_FOUND
[    0.087712]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f5043090]
[    0.087790]     scan-1312 [4110443520] [00] add_single_object     : Adding device:2a [\_SB_.PCI0.EHC2.EHB1.POR4] parent device:27
[    0.087802]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.EHC2.EHB1.POR5._STA]: AE_NOT_FOUND
[    0.087810]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f50430f0]
[    0.087891]     scan-1312 [4110443520] [00] add_single_object     : Adding device:2b [\_SB_.PCI0.EHC2.EHB1.POR5] parent device:27
[    0.087903]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.EHC2.EHB1.POR6._STA]: AE_NOT_FOUND
[    0.087910]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f5043150]
[    0.087988]     scan-1312 [4110443520] [00] add_single_object     : Adding device:2c [\_SB_.PCI0.EHC2.EHB1.POR6] parent device:27
[    0.088004]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.EXP1._STA]: AE_NOT_FOUND
[    0.088011]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f5043228]
[    0.088104]     scan-1312 [4110443520] [00] add_single_object     : Adding device:2d [\_SB_.PCI0.EXP1] parent PNP0A08:00
[    0.088121]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.EXP1.PXSX._STA]: AE_NOT_FOUND
[    0.088128]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f5043348]
[    0.088222]     scan-1312 [4110443520] [00] add_single_object     : Adding device:2e [\_SB_.PCI0.EXP1.PXSX] parent device:2d
[    0.088235]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.EXP2._STA]: AE_NOT_FOUND
[    0.088242]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f50433c0]
[    0.088340]     scan-1312 [4110443520] [00] add_single_object     : Adding device:2f [\_SB_.PCI0.EXP2] parent PNP0A08:00
[    0.088356]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.EXP2.PXSX._STA]: AE_NOT_FOUND
[    0.088364]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f50434e0]
[    0.088456]     scan-1312 [4110443520] [00] add_single_object     : Adding device:30 [\_SB_.PCI0.EXP2.PXSX] parent device:2f
[    0.088469]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.EXP3._STA]: AE_NOT_FOUND
[    0.088476]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f5043558]
[    0.088569]     scan-1312 [4110443520] [00] add_single_object     : Adding device:31 [\_SB_.PCI0.EXP3] parent PNP0A08:00
[    0.088586]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.EXP3.PXSX._STA]: AE_NOT_FOUND
[    0.088593]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f5043678]
[    0.088685]     scan-1312 [4110443520] [00] add_single_object     : Adding device:32 [\_SB_.PCI0.EXP3.PXSX] parent device:31
[    0.088698]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.EXP4._STA]: AE_NOT_FOUND
[    0.088705]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f50436f0]
[    0.088801]     scan-1312 [4110443520] [00] add_single_object     : Adding device:33 [\_SB_.PCI0.EXP4] parent PNP0A08:00
[    0.088818]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.EXP4.PXSX._STA]: AE_NOT_FOUND
[    0.088825]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f5043810]
[    0.088917]     scan-1312 [4110443520] [00] add_single_object     : Adding device:34 [\_SB_.PCI0.EXP4.PXSX] parent device:33
[    0.088930]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.EXP5._STA]: AE_NOT_FOUND
[    0.088938]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f5043888]
[    0.089031]     scan-1312 [4110443520] [00] add_single_object     : Adding device:35 [\_SB_.PCI0.EXP5] parent PNP0A08:00
[    0.089048]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.EXP5.PXSX._STA]: AE_NOT_FOUND
[    0.089055]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f50439a8]
[    0.089149]     scan-1312 [4110443520] [00] add_single_object     : Adding device:36 [\_SB_.PCI0.EXP5.PXSX] parent device:35
[    0.089162]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.EXP6._STA]: AE_NOT_FOUND
[    0.089170]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f5043a20]
[    0.089263]     scan-1312 [4110443520] [00] add_single_object     : Adding device:37 [\_SB_.PCI0.EXP6] parent PNP0A08:00
[    0.089280]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.EXP6.PXSX._STA]: AE_NOT_FOUND
[    0.089287]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f5043b40]
[    0.089382]     scan-1312 [4110443520] [00] add_single_object     : Adding device:38 [\_SB_.PCI0.EXP6.PXSX] parent device:37
[    0.089399]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.WMID._STA]: AE_NOT_FOUND
[    0.089407]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f5043c30]
[    0.089506]     scan-1312 [4110443520] [00] add_single_object     : Adding PNP0C14:00 [\_SB_.PCI0.WMID] parent PNP0A08:00
[    0.089640]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_TZ_._STA]: AE_NOT_FOUND
[    0.089647]      bus-0103 [4110443520] [00] bus_get_device        : No context for object [f5037060]
[    0.089722]     scan-1312 [4110443520] [00] add_single_object     : Adding device:39 [\_TZ_] parent LNXSYSTM:00
[    0.090197]     scan-1312 [4110443520] [00] add_single_object     : Adding LNXPWRBN:00 [\] parent LNXSYSTM:00
[    0.090245]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [24]
[    0.090254]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.LPC_.EC0_._GLK]: AE_NOT_FOUND
[    0.090282] ACPI: EC: GPE = 0x18, I/O: command/status = 0x66, data = 0x62
[    0.090285]     scan-0580 [4110443520] [00] bus_driver_init       : Driver successfully bound to device
[    0.090291]     scan-0418 [4110443520] [00] device_probe          : Found driver [ec] for device [EC0]
[    0.090676] ACPI: No dock devices found.
[    0.090679] HEST: Table not found.
[    0.090684] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.090697]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0._SEG]: AE_NOT_FOUND
[    0.091464] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.092988] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.092993] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.092997] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.093002] pci_root PNP0A08:00: host bridge window [mem 0x80000000-0xfebfffff]
[    0.093019] pci 0000:00:00.0: [8086:2a40] type 0 class 0x000600
[    0.093045] DMAR: Forcing write-buffer flush capability
[    0.093047] DMAR: Disabling IOMMU for graphics on this chipset
[    0.093071] pci 0000:00:02.0: [8086:2a42] type 0 class 0x000300
[    0.093088] pci 0000:00:02.0: reg 10: [mem 0x90000000-0x903fffff 64bit]
[    0.093098] pci 0000:00:02.0: reg 18: [mem 0x80000000-0x8fffffff 64bit pref]
[    0.093105] pci 0000:00:02.0: reg 20: [io  0x30d0-0x30d7]
[    0.093142] pci 0000:00:02.1: [8086:2a43] type 0 class 0x000380
[    0.093155] pci 0000:00:02.1: reg 10: [mem 0x92400000-0x924fffff 64bit]
[    0.093248] pci 0000:00:1a.0: [8086:2937] type 0 class 0x000c03
[    0.093331] pci 0000:00:1a.0: reg 20: [io  0x30a0-0x30bf]
[    0.093425] pci 0000:00:1a.7: [8086:293c] type 0 class 0x000c03
[    0.096663] pci 0000:00:1a.7: reg 10: [mem 0x94504c00-0x94504fff]
[    0.120027] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.120033] pci 0000:00:1a.7: PME# disabled
[    0.120067] pci 0000:00:1b.0: [8086:293e] type 0 class 0x000403
[    0.120091] pci 0000:00:1b.0: reg 10: [mem 0x94500000-0x94503fff 64bit]
[    0.120172] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.120178] pci 0000:00:1b.0: PME# disabled
[    0.120206] pci 0000:00:1c.0: [8086:2940] type 1 class 0x000604
[    0.120290] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.120296] pci 0000:00:1c.0: PME# disabled
[    0.120330] pci 0000:00:1c.3: [8086:2946] type 1 class 0x000604
[    0.120415] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.120420] pci 0000:00:1c.3: PME# disabled
[    0.120460] pci 0000:00:1d.0: [8086:2934] type 0 class 0x000c03
[    0.120537] pci 0000:00:1d.0: reg 20: [io  0x3080-0x309f]
[    0.120615] pci 0000:00:1d.1: [8086:2935] type 0 class 0x000c03
[    0.120695] pci 0000:00:1d.1: reg 20: [io  0x3060-0x307f]
[    0.120775] pci 0000:00:1d.2: [8086:2936] type 0 class 0x000c03
[    0.120852] pci 0000:00:1d.2: reg 20: [io  0x3040-0x305f]
[    0.120932] pci 0000:00:1d.7: [8086:293a] type 0 class 0x000c03
[    0.125294] pci 0000:00:1d.7: reg 10: [mem 0x94504800-0x94504bff]
[    0.148655] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.148661] pci 0000:00:1d.7: PME# disabled
[    0.148689] pci 0000:00:1e.0: [8086:2448] type 1 class 0x000604
[    0.148773] pci 0000:00:1f.0: [8086:2917] type 0 class 0x000601
[    0.148931] pci 0000:00:1f.2: [8086:2929] type 0 class 0x000106
[    0.148961] pci 0000:00:1f.2: reg 10: [io  0x30c8-0x30cf]
[    0.148973] pci 0000:00:1f.2: reg 14: [io  0x30dc-0x30df]
[    0.148986] pci 0000:00:1f.2: reg 18: [io  0x30c0-0x30c7]
[    0.148999] pci 0000:00:1f.2: reg 1c: [io  0x30d8-0x30db]
[    0.149011] pci 0000:00:1f.2: reg 20: [io  0x3020-0x303f]
[    0.149023] pci 0000:00:1f.2: reg 24: [mem 0x94504000-0x945047ff]
[    0.149074] pci 0000:00:1f.2: PME# supported from D3hot
[    0.149079] pci 0000:00:1f.2: PME# disabled
[    0.150013] pci 0000:00:1f.3: [8086:2930] type 0 class 0x000c05
[    0.150037] pci 0000:00:1f.3: reg 10: [mem 0x94505000-0x945050ff 64bit]
[    0.150069] pci 0000:00:1f.3: reg 20: [io  0x3000-0x301f]
[    0.150186] pci 0000:01:00.0: [1969:1063] type 0 class 0x000200
[    0.150216] pci 0000:01:00.0: reg 10: [mem 0x93500000-0x9353ffff 64bit]
[    0.150233] pci 0000:01:00.0: reg 18: [io  0x2000-0x207f]
[    0.150335] pci 0000:01:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.150342] pci 0000:01:00.0: PME# disabled
[    0.156676] pci 0000:00:1c.0: PCI bridge to [bus 01-01]
[    0.156682] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.156688] pci 0000:00:1c.0:   bridge window [mem 0x93500000-0x944fffff]
[    0.156697] pci 0000:00:1c.0:   bridge window [mem 0x90400000-0x913fffff 64bit pref]
[    0.156818] pci 0000:02:00.0: [8086:4232] type 0 class 0x000280
[    0.156884] pci 0000:02:00.0: reg 10: [mem 0x92500000-0x92501fff 64bit]
[    0.157081] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    0.157108] pci 0000:02:00.0: PME# disabled
[    0.157235] pci 0000:00:1c.3: PCI bridge to [bus 02-02]
[    0.157241] pci 0000:00:1c.3:   bridge window [io  0x1000-0x1fff]
[    0.157247] pci 0000:00:1c.3:   bridge window [mem 0x92500000-0x934fffff]
[    0.157256] pci 0000:00:1c.3:   bridge window [mem 0x91400000-0x923fffff 64bit pref]
[    0.157343] pci 0000:00:1e.0: PCI bridge to [bus 03-03] (subtractive decode)
[    0.157350] pci 0000:00:1e.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.157356] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.157365] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.157370] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.157373] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.157377] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.157381] pci 0000:00:1e.0:   bridge window [mem 0x80000000-0xfebfffff] (subtractive decode)
[    0.157403] pci_bus 0000:00: on NUMA node 0
[    0.157409] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.157813]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [131072]
[    0.157830]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [2031616]
[    0.157844]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [1900544]
[    0.157857]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [1900545]
[    0.159995]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [1900546]
[    0.160008]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [1900547]
[    0.160019]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [1900551]
[    0.160031]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [1703936]
[    0.160044]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [1703937]
[    0.160054]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [1703938]
[    0.160065]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [1703943]
[    0.160077]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [1835008]
[    0.160086] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
[    0.160185]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [1835008]
[    0.160195]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [0]
[    0.160208]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [1835009]
[    0.160219]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [1835010]
[    0.160229]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [1835011]
[    0.160238] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP4._PRT]
[    0.160335]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [1835011]
[    0.160344]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [0]
[    0.160357]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [1835012]
[    0.160368]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [1835013]
[    0.160377]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.160382]     scan-0580 [4110443520] [00] bus_driver_init       : Driver successfully bound to device
[    0.170600]     scan-0418 [4110443520] [00] device_probe          : Found driver [pci_root] for device [PCI0]
[    0.170727] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 9 10 *11 12)
[    0.170766]     scan-0580 [4110443520] [00] bus_driver_init       : Driver successfully bound to device
[    0.170772]     scan-0418 [4110443520] [00] device_probe          : Found driver [pci_link] for device [LNKA]
[    0.170868] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 9 10 *11 12)
[    0.170906]     scan-0580 [4110443520] [00] bus_driver_init       : Driver successfully bound to device
[    0.170912]     scan-0418 [4110443520] [00] device_probe          : Found driver [pci_link] for device [LNKB]
[    0.171005] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 9 10 *11 12)
[    0.171042]     scan-0580 [4110443520] [00] bus_driver_init       : Driver successfully bound to device
[    0.171049]     scan-0418 [4110443520] [00] device_probe          : Found driver [pci_link] for device [LNKC]
[    0.171143] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 9 *10 11 12)
[    0.171179]     scan-0580 [4110443520] [00] bus_driver_init       : Driver successfully bound to device
[    0.171186]     scan-0418 [4110443520] [00] device_probe          : Found driver [pci_link] for device [LNKD]
[    0.171281] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 9 10 11 12) *0, disabled.
[    0.171319]     scan-0580 [4110443520] [00] bus_driver_init       : Driver successfully bound to device
[    0.171325]     scan-0418 [4110443520] [00] device_probe          : Found driver [pci_link] for device [LNKE]
[    0.171419] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 9 10 11 12) *0, disabled.
[    0.171457]     scan-0580 [4110443520] [00] bus_driver_init       : Driver successfully bound to device
[    0.171464]     scan-0418 [4110443520] [00] device_probe          : Found driver [pci_link] for device [LNKF]
[    0.171558] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 9 10 *11 12)
[    0.171595]     scan-0580 [4110443520] [00] bus_driver_init       : Driver successfully bound to device
[    0.171601]     scan-0418 [4110443520] [00] device_probe          : Found driver [pci_link] for device [LNKG]
[    0.171695] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 9 10 *11 12)
[    0.171732]     scan-0580 [4110443520] [00] bus_driver_init       : Driver successfully bound to device
[    0.171738]     scan-0418 [4110443520] [00] device_probe          : Found driver [pci_link] for device [LNKH]
[    0.171816] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.171826] vgaarb: loaded
[    0.171944] SCSI subsystem initialized
[    0.171984] libata version 3.00 loaded.
[    0.172045] usbcore: registered new interface driver usbfs
[    0.172063] usbcore: registered new interface driver hub
[    0.172091] usbcore: registered new device driver usb
[    0.172141] PCI: Using ACPI for IRQ routing
[    0.172144] PCI: pci_cache_line_size set to 64 bytes
[    0.172272] reserve RAM buffer: 000000000009e000 - 000000000009ffff 
[    0.172275] reserve RAM buffer: 000000007ba63000 - 000000007bffffff 
[    0.172280] reserve RAM buffer: 000000007bb80000 - 000000007bffffff 
[    0.172284] reserve RAM buffer: 000000007bbe0000 - 000000007bffffff 
[    0.172288] reserve RAM buffer: 000000007bc00000 - 000000007bffffff 
[    0.172395] NetLabel: Initializing
[    0.172398] NetLabel:  domain hash size = 128
[    0.172400] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.172413] NetLabel:  unlabeled traffic allowed by default
[    0.172420] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    0.172427] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.172434] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.176686] Switching to clocksource hpet
[    0.179963] Switched to NOHz mode on CPU #0
[    0.186582] pnp: PnP ACPI init
[    0.186603] ACPI: bus type pnp registered
[    0.187455] pnp 00:00: [bus 00-ff]
[    0.187459] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.187463] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.187466] pnp 00:00: [io  0x0d00-0xffff window]
[    0.187470] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.187473] pnp 00:00: [mem 0x000c0000-0x000c3fff window]
[    0.187477] pnp 00:00: [mem 0x000c4000-0x000c7fff window]
[    0.187480] pnp 00:00: [mem 0x000c8000-0x000cbfff window]
[    0.187484] pnp 00:00: [mem 0x000cc000-0x000cffff window]
[    0.187487] pnp 00:00: [mem 0x000d0000-0x000d3fff window]
[    0.187490] pnp 00:00: [mem 0x000d4000-0x000d7fff window]
[    0.187493] pnp 00:00: [mem 0x000d8000-0x000dbfff window]
[    0.187497] pnp 00:00: [mem 0x000dc000-0x000dffff window]
[    0.187500] pnp 00:00: [mem 0x000e0000-0x000e3fff window]
[    0.187503] pnp 00:00: [mem 0x000e4000-0x000e7fff window]
[    0.187509] pnp 00:00: [mem 0x000e8000-0x000ebfff window]
[    0.187513] pnp 00:00: [mem 0x000ec000-0x000effff window]
[    0.187516] pnp 00:00: [mem 0x000f0000-0x000fffff window]
[    0.187520] pnp 00:00: [mem 0x80000000-0xfebfffff window]
[    0.187524] pnp 00:00: [mem 0xfed40000-0xfed44fff window]
[    0.187615] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    0.187923] pnp 00:01: [io  0x002e-0x002f]
[    0.187927] pnp 00:01: [io  0x004e-0x004f]
[    0.187930] pnp 00:01: [io  0x164e-0x164f]
[    0.187933] pnp 00:01: [io  0x0061]
[    0.187935] pnp 00:01: [io  0x0070]
[    0.187938] pnp 00:01: [io  0x0080]
[    0.187941] pnp 00:01: [io  0x0092]
[    0.187944] pnp 00:01: [io  0x00b2-0x00b3]
[    0.187946] pnp 00:01: [io  0x0063]
[    0.187949] pnp 00:01: [io  0x0065]
[    0.187952] pnp 00:01: [io  0x0067]
[    0.187955] pnp 00:01: [io  0x0600-0x060f]
[    0.187957] pnp 00:01: [io  0x0610]
[    0.187960] pnp 00:01: [io  0x0800-0x080f]
[    0.187963] pnp 00:01: [io  0x0810-0x0817]
[    0.187966] pnp 00:01: [io  0x0820-0x0823]
[    0.187969] pnp 00:01: [io  0x0400-0x047f]
[    0.187971] pnp 00:01: [io  0x0500-0x053f]
[    0.187975] pnp 00:01: [mem 0xf8000000-0xfbffffff]
[    0.187978] pnp 00:01: [mem 0xfed1c000-0xfed1ffff]
[    0.187981] pnp 00:01: [mem 0xfed10000-0xfed13fff]
[    0.187984] pnp 00:01: [mem 0xfed18000-0xfed18fff]
[    0.187987] pnp 00:01: [mem 0xfed19000-0xfed19fff]
[    0.187991] pnp 00:01: [mem 0xfec00000-0xfec00fff]
[    0.187994] pnp 00:01: [mem 0xfed20000-0xfed3ffff]
[    0.187997] pnp 00:01: [mem 0xfed40000-0xfed44fff]
[    0.188000] pnp 00:01: [mem 0xfed45000-0xfed8ffff]
[    0.188003] pnp 00:01: [mem 0xfee00000-0xfee00fff]
[    0.188037] pnp 00:01: disabling [io  0x164e-0x164f] because it overlaps 0000:00:1c.3 BAR 13 [io  0x1000-0x1fff]
[    0.188121] system 00:01: [io  0x0600-0x060f] has been reserved
[    0.188125] system 00:01: [io  0x0610] has been reserved
[    0.188129] system 00:01: [io  0x0800-0x080f] has been reserved
[    0.188132] system 00:01: [io  0x0810-0x0817] has been reserved
[    0.188136] system 00:01: [io  0x0820-0x0823] has been reserved
[    0.188140] system 00:01: [io  0x0400-0x047f] has been reserved
[    0.188144] system 00:01: [io  0x0500-0x053f] has been reserved
[    0.188149] system 00:01: [mem 0xf8000000-0xfbffffff] has been reserved
[    0.188153] system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.188158] system 00:01: [mem 0xfed10000-0xfed13fff] has been reserved
[    0.188162] system 00:01: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.188166] system 00:01: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.188170] system 00:01: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.188174] system 00:01: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.188179] system 00:01: [mem 0xfed40000-0xfed44fff] has been reserved
[    0.188183] system 00:01: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.188187] system 00:01: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.188192] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.188212] pnp 00:02: [io  0x0000-0x001f]
[    0.188215] pnp 00:02: [io  0x0081-0x0091]
[    0.188218] pnp 00:02: [io  0x0093-0x009f]
[    0.188221] pnp 00:02: [io  0x00c0-0x00df]
[    0.188225] pnp 00:02: [dma 4]
[    0.188269] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.188320] pnp 00:03: [io  0x0070-0x0077]
[    0.188367] pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.188529] pnp 00:04: [irq 0 disabled]
[    0.188542] pnp 00:04: [irq 8]
[    0.188545] pnp 00:04: [mem 0xfed00000-0xfed003ff]
[    0.188592] pnp 00:04: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.188615] pnp 00:05: [io  0x00f0]
[    0.188621] pnp 00:05: [irq 13]
[    0.188669] pnp 00:05: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.188691] pnp 00:06: [mem 0xff800000-0xffffffff]
[    0.188738] pnp 00:06: Plug and Play ACPI device, IDs INT0800 (active)
[    0.188768] pnp 00:07: [io  0x0060]
[    0.188771] pnp 00:07: [io  0x0064]
[    0.188777] pnp 00:07: [irq 1]
[    0.188825] pnp 00:07: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.188860] pnp 00:08: [irq 12]
[    0.188910] pnp 00:08: Plug and Play ACPI device, IDs SYN1b20 PNP0f13 (active)
[    0.189137] pnp: PnP ACPI: found 9 devices
[    0.189140] ACPI: ACPI bus type pnp unregistered
[    0.225848] pci 0000:00:1c.0: PCI bridge to [bus 01-01]
[    0.225853] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.225861] pci 0000:00:1c.0:   bridge window [mem 0x93500000-0x944fffff]
[    0.225867] pci 0000:00:1c.0:   bridge window [mem 0x90400000-0x913fffff 64bit pref]
[    0.225876] pci 0000:00:1c.3: PCI bridge to [bus 02-02]
[    0.225881] pci 0000:00:1c.3:   bridge window [io  0x1000-0x1fff]
[    0.225888] pci 0000:00:1c.3:   bridge window [mem 0x92500000-0x934fffff]
[    0.225894] pci 0000:00:1c.3:   bridge window [mem 0x91400000-0x923fffff 64bit pref]
[    0.225903] pci 0000:00:1e.0: PCI bridge to [bus 03-03]
[    0.225906] pci 0000:00:1e.0:   bridge window [io  disabled]
[    0.225913] pci 0000:00:1e.0:   bridge window [mem disabled]
[    0.225918] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    0.225938] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.225945] pci 0000:00:1c.0: setting latency timer to 64
[    0.225956] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    0.225962] pci 0000:00:1c.3: setting latency timer to 64
[    0.225970] pci 0000:00:1e.0: setting latency timer to 64
[    0.225976] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.225979] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.225983] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.225987] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.225990] pci_bus 0000:01: resource 0 [io  0x2000-0x2fff]
[    0.225994] pci_bus 0000:01: resource 1 [mem 0x93500000-0x944fffff]
[    0.225998] pci_bus 0000:01: resource 2 [mem 0x90400000-0x913fffff 64bit pref]
[    0.226002] pci_bus 0000:02: resource 0 [io  0x1000-0x1fff]
[    0.226005] pci_bus 0000:02: resource 1 [mem 0x92500000-0x934fffff]
[    0.226009] pci_bus 0000:02: resource 2 [mem 0x91400000-0x923fffff 64bit pref]
[    0.226013] pci_bus 0000:03: resource 4 [io  0x0000-0x0cf7]
[    0.226016] pci_bus 0000:03: resource 5 [io  0x0d00-0xffff]
[    0.226020] pci_bus 0000:03: resource 6 [mem 0x000a0000-0x000bffff]
[    0.226024] pci_bus 0000:03: resource 7 [mem 0x80000000-0xfebfffff]
[    0.226059] NET: Registered protocol family 2
[    0.226099] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.226248] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.226939] TCP bind hash table entries: 65536 (order: 6, 262144 bytes)
[    0.227101] TCP: Hash tables configured (established 131072 bind 65536)
[    0.227104] TCP reno registered
[    0.227107] UDP hash table entries: 512 (order: 1, 8192 bytes)
[    0.227115] UDP-Lite hash table entries: 512 (order: 1, 8192 bytes)
[    0.227198] NET: Registered protocol family 1
[    0.227212] pci 0000:00:02.0: Boot video device
[    0.253401] PCI: CLS 64 bytes, default 64
[    0.253466] Trying to unpack rootfs image as initramfs...
[    0.510330] Freeing initrd memory: 7468k freed
[    0.514523] Simple Boot Flag value 0x5 read from CMOS RAM was invalid
[    0.514526] Simple Boot Flag at 0x44 set to 0x1
[    0.515103] microcode: CPU0 sig=0x1067a, pf=0x80, revision=0xa07
[    0.515133] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.515269] audit: initializing netlink socket (disabled)
[    0.515291] type=2000 audit(1296067072.513:1): initialized
[    0.526238] highmem bounce pool size: 64 pages
[    0.526245] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    0.528962] VFS: Disk quotas dquot_6.5.2
[    0.529018] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.529670] msgmni has been set to 1707
[    0.529735] SELinux:  Registering netfilter hooks
[    0.530044] alg: No test for stdrng (krng)
[    0.530111] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.530115] io scheduler noop registered
[    0.530118] io scheduler deadline registered
[    0.530138] io scheduler cfq registered (default)
[    0.530231] pcieport 0000:00:1c.0: setting latency timer to 64
[    0.530292] pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
[    0.530384] pcieport 0000:00:1c.3: setting latency timer to 64
[    0.530438] pcieport 0000:00:1c.3: irq 41 for MSI/MSI-X
[    0.530560] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.530588] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.530591] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.530725]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.OVGA._RMV]: AE_NOT_FOUND
[    0.530739]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.LPC_._RMV]: AE_NOT_FOUND
[    0.530752]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.UHC0._RMV]: AE_NOT_FOUND
[    0.530763]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.UHC1._RMV]: AE_NOT_FOUND
[    0.530774]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.UHC2._RMV]: AE_NOT_FOUND
[    0.530786]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.UHCR._RMV]: AE_NOT_FOUND
[    0.530797]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.EHC1._RMV]: AE_NOT_FOUND
[    0.530808]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.UHC3._RMV]: AE_NOT_FOUND
[    0.530820]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.UHC4._RMV]: AE_NOT_FOUND
[    0.530831]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.UHC5._RMV]: AE_NOT_FOUND
[    0.530843]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.EHC2._RMV]: AE_NOT_FOUND
[    0.530854]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.EXP1._RMV]: AE_NOT_FOUND
[    0.530865]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.EXP2._RMV]: AE_NOT_FOUND
[    0.530877]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.EXP3._RMV]: AE_NOT_FOUND
[    0.530888]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.EXP4._RMV]: AE_NOT_FOUND
[    0.530900]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.EXP5._RMV]: AE_NOT_FOUND
[    0.530911]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.EXP6._RMV]: AE_NOT_FOUND
[    0.530942]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [131072]
[    0.530955]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [2031616]
[    0.530966]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [1900544]
[    0.530977]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [1900545]
[    0.530988]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [1900546]
[    0.530998]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [1900547]
[    0.531009]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [1900551]
[    0.531020]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [1703936]
[    0.531031]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [1703937]
[    0.531041]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [1703938]
[    0.531052]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [1703943]
[    0.531063]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [1835008]
[    0.531074]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.EXP1.PXSX._RMV]: AE_NOT_FOUND
[    0.531088]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [1835008]
[    0.531098]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [0]
[    0.531109]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [1835009]
[    0.531120]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [1835010]
[    0.531131]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [1835011]
[    0.531142]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.EXP4.PXSX._RMV]: AE_NOT_FOUND
[    0.531156]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [1835011]
[    0.531165]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [0]
[    0.531177]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [1835012]
[    0.531187]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [1835013]
[    0.531198]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.WMID._ADR]: AE_NOT_FOUND
[    0.531341] intel_idle: MWAIT substates: 0x3122220
[    0.531344] intel_idle: does not run on family 6 model 23
[    0.531714]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [0]
[    0.531720] ACPI: Deprecated procfs I/F for AC is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    0.531979]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [0]
[    0.531995] ACPI: AC Adapter [ACAD] (off-line)
[    0.531998]     scan-0580 [4110443520] [00] bus_driver_init       : Driver successfully bound to device
[    0.532012]     scan-0418 [4110443520] [00] device_probe          : Found driver [ac] for device [ACAD]
[    0.532140] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[    0.532146] ACPI: Power Button [PWRB]
[    0.532149]     scan-0580 [4110443520] [00] bus_driver_init       : Driver successfully bound to device
[    0.532157]     scan-0418 [4110443520] [00] device_probe          : Found driver [button] for device [PWRB]
[    0.532220] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input1
[    0.532583] 
[    0.532584] **** Context Switch from TID 4110443520 to TID 4111808512 ****
[    0.532585] 
[    0.532588]    utils-0286 [4111808512] [00] evaluate_integer      : Return value [0]
[    0.532835]    utils-0286 [4111808512] [00] evaluate_integer      : Return value [0]
[    0.533403] 
[    0.533405] **** Context Switch from TID 4111808512 to TID 4110443520 ****
[    0.533406] 
[    0.533409]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [1]
[    0.533417] ACPI: Lid Switch [LID0]
[    0.533419]     scan-0580 [4110443520] [00] bus_driver_init       : Driver successfully bound to device
[    0.533427]     scan-0418 [4110443520] [00] device_probe          : Found driver [button] for device [LID0]
[    0.533496] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input2
[    0.533501] ACPI: Sleep Button [SLPB]
[    0.533504]     scan-0580 [4110443520] [00] bus_driver_init       : Driver successfully bound to device
[    0.533512]     scan-0418 [4110443520] [00] device_probe          : Found driver [button] for device [SLPB]
[    0.533585] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    0.533589] ACPI: Power Button [PWRF]
[    0.533592]     scan-0580 [4110443520] [00] bus_driver_init       : Driver successfully bound to device
[    0.533607]     scan-0418 [4110443520] [00] device_probe          : Found driver [button] for device [PWRF]
[    0.533650]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0._SEG]: AE_NOT_FOUND
[    0.533661]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [0]
[    0.533672]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [131072]
[    0.533681]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.OVGA._SUN]: AE_NOT_FOUND
[    0.533692]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [2031616]
[    0.533700]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.LPC_._SUN]: AE_NOT_FOUND
[    0.533710]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [1900544]
[    0.533718]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.UHC0._SUN]: AE_NOT_FOUND
[    0.533728]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [1900545]
[    0.533736]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.UHC1._SUN]: AE_NOT_FOUND
[    0.533746]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [1900546]
[    0.533754]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.UHC2._SUN]: AE_NOT_FOUND
[    0.533764]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [1900547]
[    0.533772]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.UHCR._SUN]: AE_NOT_FOUND
[    0.533782]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [1900551]
[    0.533790]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.EHC1._SUN]: AE_NOT_FOUND
[    0.533800]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [1703936]
[    0.533808]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.UHC3._SUN]: AE_NOT_FOUND
[    0.533818]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [1703937]
[    0.533826]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.UHC4._SUN]: AE_NOT_FOUND
[    0.533836]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [1703938]
[    0.533844]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.UHC5._SUN]: AE_NOT_FOUND
[    0.533854]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [1703943]
[    0.533862]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.EHC2._SUN]: AE_NOT_FOUND
[    0.533872]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [1835008]
[    0.533880]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.EXP1._SUN]: AE_NOT_FOUND
[    0.533890]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [1835009]
[    0.533898]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.EXP2._SUN]: AE_NOT_FOUND
[    0.533908]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [1835010]
[    0.533916]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.EXP3._SUN]: AE_NOT_FOUND
[    0.533926]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [1835011]
[    0.533934]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.EXP4._SUN]: AE_NOT_FOUND
[    0.533944]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [1835012]
[    0.533951]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.EXP5._SUN]: AE_NOT_FOUND
[    0.533962]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [1835013]
[    0.533969]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.EXP6._SUN]: AE_NOT_FOUND
[    0.533980]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.WMID._ADR]: AE_NOT_FOUND
[    0.533993]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [131072]
[    0.534004]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [2031616]
[    0.534015]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [1900544]
[    0.534026]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [1900545]
[    0.534037]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [1900546]
[    0.534047]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [1900547]
[    0.534058]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [1900551]
[    0.534069]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [1703936]
[    0.534079]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [1703937]
[    0.534090]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [1703938]
[    0.534100]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [1703943]
[    0.534111]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [1835008]
[    0.534121]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [0]
[    0.534128]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.EXP1.PXSX._SUN]: AE_NOT_FOUND
[    0.534141]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [0]
[    0.534152]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [1835009]
[    0.534162]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [1835010]
[    0.534173]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [1835011]
[    0.534183]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [0]
[    0.534190]    utils-0050 [4110443520] [00] util_eval_error       : Evaluate [\_SB_.PCI0.EXP4.PXSX._SUN]: AE_NOT_FOUND
[    0.534203]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [0]
[    0.534214]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [1835012]
[    0.534225]    utils-0286 [4110443520] [00] evaluate_integer      : Return value [1835013]
[    0.534235] ACPI: acpi_idle registered with cpuidle
[    0.534430] Monitor-Mwait will be used to enter C-1 state
[    0.534434] Monitor-Mwait will be used to enter C-2 state
[    0.534437] Monitor-Mwait will be used to enter C-3 state
[    0.534441] Marking TSC unstable due to TSC halts in idle
[    0.534494]     scan-0580 [4110443520] [00] bus_driver_init       : Driver successfully bound to device
[    0.534502]     scan-0418 [4110443520] [00] device_probe          : Found driver [processor] for device [CPU0]
[    0.534517]     scan-0580 [4110443520] [00] bus_driver_init       : Driver successfully bound to device
[    0.534523]     scan-0418 [4110443520] [00] device_probe          : Found driver [processor] for device [CPU1]
[    0.534536]     scan-0580 [4110443520] [00] bus_driver_init       : Driver successfully bound to device
[    0.534542]     scan-0418 [4110443520] [00] device_probe          : Found driver [processor] for device [CPU2]
[    0.534555]     scan-0580 [4110443520] [00] bus_driver_init       : Driver successfully bound to device
[    0.534562]     scan-0418 [4110443520] [00] device_probe          : Found driver [processor] for device [CPU3]
[    0.537419] ERST: Table is not found!
[    0.537474] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    0.538241] Non-volatile memory driver v1.3
[    0.538244] Linux agpgart interface v0.103
[    0.538288] agpgart-intel 0000:00:00.0: Intel GM45 Chipset
[    0.538432] agpgart-intel 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
[    0.539551] agpgart-intel 0000:00:00.0: detected 65536K stolen memory
[    0.539653] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0x80000000
[    0.539712] [drm] Initialized drm 1.1.0 20060810
[    0.539746] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.539752] i915 0000:00:02.0: setting latency timer to 64
[    0.540937] 
[    0.540938] **** Context Switch from TID 4110443520 to TID 4110447616 ****
[    0.540940] 
[    0.540942]    utils-0286 [4110447616] [00] evaluate_integer      : Return value [15]
[    0.540949]      bus-0149 [4110447616] [00] bus_get_status        : Device [BAT1] status [0000000f]
[    0.540957] ACPI: Deprecated procfs I/F for battery is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    0.540964] ACPI: Battery Slot [BAT1] (battery absent)
[    0.540967]     scan-0580 [4110447616] [00] bus_driver_init       : Driver successfully bound to device
[    0.540976]     scan-0418 [4110447616] [00] device_probe          : Found driver [battery] for device [BAT1]
[    0.573973] i915 0000:00:02.0: irq 42 for MSI/MSI-X
[    0.573980] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    0.573982] [drm] Driver supports precise vblank timestamp query.
[    0.663102] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    1.109027] fbcon: inteldrmfb (fb0) is primary device
[    1.128201] Console: switching to colour frame buffer device 170x48
[    1.133911] fb0: inteldrmfb frame buffer device
[    1.133913] drm: registered panic notifier
[    1.133943] No ACPI video bus found
[    1.134103] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    1.135493] brd: module loaded
[    1.135584] ahci 0000:00:1f.2: version 3.0
[    1.135598] ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    1.135646] ahci 0000:00:1f.2: irq 43 for MSI/MSI-X
[    1.135694] ahci: SSS flag set, parallel bus scan disabled
[    1.135740] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 4 ports 3 Gbps 0x33 impl SATA mode
[    1.135745] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led pmp pio slum part ccc ems 
[    1.135752] ahci 0000:00:1f.2: setting latency timer to 64
[    1.154122] scsi0 : ahci
[    1.154231] scsi1 : ahci
[    1.154312] scsi2 : ahci
[    1.154393] scsi3 : ahci
[    1.154473] scsi4 : ahci
[    1.154552] scsi5 : ahci
[    1.154622] ata1: SATA max UDMA/133 abar m2048@0x94504000 port 0x94504100 irq 43
[    1.154627] ata2: SATA max UDMA/133 abar m2048@0x94504000 port 0x94504180 irq 43
[    1.154630] ata3: DUMMY
[    1.154632] ata4: DUMMY
[    1.154635] ata5: SATA max UDMA/133 abar m2048@0x94504000 port 0x94504300 irq 43
[    1.154640] ata6: SATA max UDMA/133 abar m2048@0x94504000 port 0x94504380 irq 43
[    1.154719] atl1c 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.154728] atl1c 0000:01:00.0: setting latency timer to 64
[    1.240267] atl1c 0000:01:00.0: version 1.0.1.0-NAPI
[    1.240306] console [netcon0] enabled
[    1.240308] netconsole: network logging started
[    1.240364] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.240381] ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    1.240396] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    1.240400] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    1.240457] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    1.240492] ehci_hcd 0000:00:1a.7: debug port 1
[    1.244383] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
[    1.244395] ehci_hcd 0000:00:1a.7: irq 19, io mem 0x94504c00
[    1.256688] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    1.256709] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    1.256713] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.256717] usb usb1: Product: EHCI Host Controller
[    1.256720] usb usb1: Manufacturer: Linux 2.6.38-rc2-00175-g6fb1b30 ehci_hcd
[    1.256723] usb usb1: SerialNumber: 0000:00:1a.7
[    1.256835] hub 1-0:1.0: USB hub found
[    1.256842] hub 1-0:1.0: 2 ports detected
[    1.256928] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    1.256943] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    1.256947] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    1.256995] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    1.257028] ehci_hcd 0000:00:1d.7: debug port 1
[    1.260922] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    1.260934] ehci_hcd 0000:00:1d.7: irq 23, io mem 0x94504800
[    1.273355] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    1.273391] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    1.273395] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.273398] usb usb2: Product: EHCI Host Controller
[    1.273401] usb usb2: Manufacturer: Linux 2.6.38-rc2-00175-g6fb1b30 ehci_hcd
[    1.273404] usb usb2: SerialNumber: 0000:00:1d.7
[    1.273511] hub 2-0:1.0: USB hub found
[    1.273516] hub 2-0:1.0: 6 ports detected
[    1.273614] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.273630] uhci_hcd: USB Universal Host Controller Interface driver
[    1.273655] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.273663] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    1.273668] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    1.273715] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    1.273752] uhci_hcd 0000:00:1a.0: irq 16, io base 0x000030a0
[    1.273790] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    1.273794] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.273798] usb usb3: Product: UHCI Host Controller
[    1.273801] usb usb3: Manufacturer: Linux 2.6.38-rc2-00175-g6fb1b30 uhci_hcd
[    1.273804] usb usb3: SerialNumber: 0000:00:1a.0
[    1.273907] hub 3-0:1.0: USB hub found
[    1.273912] hub 3-0:1.0: 2 ports detected
[    1.273993] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    1.274001] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    1.274006] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    1.274050] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 4
[    1.274080] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00003080
[    1.274118] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    1.274122] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.274126] usb usb4: Product: UHCI Host Controller
[    1.274129] usb usb4: Manufacturer: Linux 2.6.38-rc2-00175-g6fb1b30 uhci_hcd
[    1.274132] usb usb4: SerialNumber: 0000:00:1d.0
[    1.274241] hub 4-0:1.0: USB hub found
[    1.274246] hub 4-0:1.0: 2 ports detected
[    1.274326] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    1.274334] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    1.274338] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    1.274385] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 5
[    1.274415] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00003060
[    1.274453] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    1.274457] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.274460] usb usb5: Product: UHCI Host Controller
[    1.274463] usb usb5: Manufacturer: Linux 2.6.38-rc2-00175-g6fb1b30 uhci_hcd
[    1.274466] usb usb5: SerialNumber: 0000:00:1d.1
[    1.274569] hub 5-0:1.0: USB hub found
[    1.274573] hub 5-0:1.0: 2 ports detected
[    1.274653] uhci_hcd 0000:00:1d.2: PCI INT D -> GSI 16 (level, low) -> IRQ 16
[    1.274661] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    1.274665] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    1.274711] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 6
[    1.274744] uhci_hcd 0000:00:1d.2: irq 16, io base 0x00003040
[    1.274781] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    1.274784] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.274788] usb usb6: Product: UHCI Host Controller
[    1.274791] usb usb6: Manufacturer: Linux 2.6.38-rc2-00175-g6fb1b30 uhci_hcd
[    1.274794] usb usb6: SerialNumber: 0000:00:1d.2
[    1.274897] hub 6-0:1.0: USB hub found
[    1.274901] hub 6-0:1.0: 2 ports detected
[    1.275064] i8042: PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:MOUE] at 0x60,0x64 irq 1,12
[    1.282708] i8042: Detected active multiplexing controller, rev 1.1
[    1.286133] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.286140] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[    1.286180] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[    1.286214] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[    1.286250] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[    1.286353] mousedev: PS/2 mouse device common for all mice
[    1.286594] rtc_cmos 00:03: RTC can wake from S4
[    1.286642] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    1.286682] rtc0: alarms up to one month, 242 bytes nvram, hpet irqs
[    1.286850] i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    1.286986] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.06
[    1.287055] iTCO_wdt: Found a ICH9M-E TCO device (Version=2, TCOBASE=0x0460)
[    1.287111] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    1.287114] iTCO_vendor_support: vendor-support=0
[    1.287206] device-mapper: uevent: version 1.0.3
[    1.287298] device-mapper: ioctl: 4.19.1-ioctl (2011-01-07) initialised: dm-devel@redhat.com
[    1.287360] device-mapper: multipath: version 1.2.0 loaded
[    1.287363] device-mapper: multipath round-robin: version 1.0.0 loaded
[    1.287366] device-mapper: multipath queue-length: version 0.1.0 loaded
[    1.287369] device-mapper: multipath service-time: version 0.2.0 loaded
[    1.287501] cpuidle: using governor ladder
[    1.287568] cpuidle: using governor menu
[    1.287888] usbcore: registered new interface driver usbhid
[    1.287891] usbhid: USB HID core driver
[    1.287953] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    1.288175] ip_tables: (C) 2000-2006 Netfilter Core Team
[    1.288192] TCP cubic registered
[    1.288194] Initializing XFRM netlink socket
[    1.288205] NET: Registered protocol family 17
[    1.288219] Using IPI Shortcut mode
[    1.307840] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
[    1.492495] 
[    1.492497] **** Context Switch from TID 4110447616 to TID 4110446592 ****
[    1.492498] 
[    1.492502]    utils-0286 [4110446592] [00] evaluate_integer      : Return value [0]
[    1.493072]    utils-0286 [4110446592] [00] evaluate_integer      : Return value [0]
[    1.580096] usb 2-5: new high speed USB device using ehci_hcd and address 2
[    1.640054] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.692125] ata1.00: ATA-8: TOSHIBA MK2555GSX, FG001J, max UDMA/100
[    1.692129] ata1.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    1.692961] ata1.00: configured for UDMA/100
[    1.693083] scsi 0:0:0:0: Direct-Access     ATA      TOSHIBA MK2555GS FG00 PQ: 0 ANSI: 5
[    1.693255] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.693373] sd 0:0:0:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 GiB)
[    1.693427] sd 0:0:0:0: [sda] Write Protect is off
[    1.693431] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.693455] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.744260] usb 2-5: New USB device found, idVendor=064e, idProduct=a102
[    1.744264] usb 2-5: New USB device strings: Mfr=2, Product=1, SerialNumber=3
[    1.744268] usb 2-5: Product: WebCam
[    1.744270] usb 2-5: Manufacturer: SuYin
[    1.744273] usb 2-5: SerialNumber: CN0316-S30C-OV061-VA-R02.02.02
[    1.746193]  sda: sda1 sda2 sda3 sda4
[    1.746488] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.990177]    utils-0286 [4110446592] [00] evaluate_integer      : Return value [31]
[    1.990188]      bus-0149 [4110446592] [00] bus_get_status        : Device [BAT1] status [0000001f]
[    2.013373] ata2: SATA link down (SStatus 0 SControl 300)
[    2.040156]    utils-0286 [4110446592] [00] evaluate_integer      : Return value [31]
[    2.040163]      bus-0149 [4110446592] [00] bus_get_status        : Device [BAT1] status [0000001f]
[    2.112261] Synaptics Touchpad, model: 1, fw: 7.2, id: 0x1c0b1, caps: 0xd04733/0xa40000/0xa0000
[    2.157260] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio2/input/input5
[    2.333436] ata5: SATA link down (SStatus 0 SControl 300)
[    2.653435] ata6: SATA link down (SStatus 0 SControl 300)
[    2.653464] registered taskstats version 1
[    2.653895] rtc_cmos 00:03: setting system clock to 2011-01-26 18:37:55 UTC (1296067075)
[    2.654020] Freeing unused kernel memory: 488k freed
[    2.654217] Write protecting the kernel text: 4600k
[    2.654254] Write protecting the kernel read-only data: 1844k
[    2.680641] dracut: dracut-006-6.fc14
[    2.700241] udev[82]: starting version 161
[    2.804587] dracut: Starting plymouth daemon
[    2.990471] 
[    2.990473] **** Context Switch from TID 4110446592 to TID 4104763392 ****
[    2.990475] 
[    2.990478]    utils-0286 [4104763392] [00] evaluate_integer      : Return value [0]
[    2.994246] 
[    2.994248] **** Context Switch from TID 4104763392 to TID 4103507968 ****
[    2.994249] 
[    2.994252]    utils-0286 [4103507968] [00] evaluate_integer      : Return value [0]
[    2.996728] 
[    2.996730] **** Context Switch from TID 4103507968 to TID 4103511040 ****
[    2.996731] 
[    2.996734]    utils-0286 [4103511040] [00] evaluate_integer      : Return value [0]
[    3.481454] dracut: luksOpen /dev/sda3 luks-home
[   66.918370] Intel AES-NI instructions are not detected.
[   67.271277] dracut: luksOpen /dev/sda4 luks-swap
[   67.979094] PM: Starting manual resume from disk
[   68.057793] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null)
[   68.098583] dracut: Remounting /dev/disk/by-uuid/5764c1f2-f119-4f97-b8e2-d827b8655edb with -o noatime,data=writeback,ro
[   68.135538] EXT4-fs (sda2): mounted filesystem with writeback data mode. Opts: data=writeback
[   68.150137] dracut: Mounted root filesystem /dev/sda2
[   68.334588] dracut: Loading SELinux policy
[   68.712453] type=1404 audit(1296067141.556:2): enforcing=1 old_enforcing=0 auid=4294967295 ses=4294967295
[   68.843180] SELinux: 2048 avtab hash slots, 211082 rules.
[   68.953321] SELinux: 2048 avtab hash slots, 211082 rules.
[   69.222249] SELinux:  9 users, 14 roles, 3471 types, 181 bools, 1 sens, 1024 cats
[   69.222255] SELinux:  77 classes, 211082 rules
[   69.229447] SELinux:  Permission read_policy in class security not defined in policy.
[   69.229686] SELinux:  Permission syslog in class capability2 not defined in policy.
[   69.229696] SELinux: the above unknown classes and permissions will be allowed
[   69.229706] SELinux:  Completing initialization.
[   69.229708] SELinux:  Setting up existing superblocks.
[   69.229716] SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
[   69.229724] SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
[   69.229871] SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
[   69.229879] SELinux: initialized (dev proc, type proc), uses genfs_contexts
[   69.229894] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[   69.229921] SELinux: initialized (dev debugfs, type debugfs), uses genfs_contexts
[   69.230546] SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
[   69.230551] SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
[   69.230557] SELinux: initialized (dev anon_inodefs, type anon_inodefs), uses genfs_contexts
[   69.230563] SELinux: initialized (dev devpts, type devpts), uses transition SIDs
[   69.230585] SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses transition SIDs
[   69.230598] SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
[   69.230607] SELinux: initialized (dev selinuxfs, type selinuxfs), uses genfs_contexts
[   69.230620] SELinux: initialized (dev configfs, type configfs), uses genfs_contexts
[   69.230627] SELinux: initialized (dev usbfs, type usbfs), uses genfs_contexts
[   69.230633] SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
[   69.230911] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[   69.231595] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[   69.231608] SELinux: initialized (dev sda2, type ext4), uses xattr
[   69.237501] type=1403 audit(1296067142.079:3): policy loaded auid=4294967295 ses=4294967295
[   69.824117] dracut: Switching root
[   70.412997] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[   70.413749] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[   70.414383] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[   70.414678] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[   70.414974] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[   70.415270] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[   70.415582] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[   70.415878] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[   70.416169] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[   70.416460] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[   70.416823] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[   70.489416] systemd[1]: systemd 10 running in system mode. (+PAM +LIBWRAP +AUDIT +SELINUX; fedora)
[   70.796629] NET: Registered protocol family 10
[   70.815184] systemd[1]: Set hostname to <localhost.localdomain>.
[   72.739235] SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
[   72.740353] SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
[   72.740851] SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
[   72.741781] SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
[   72.742500] SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
[   74.553362] udev[390]: starting version 161
[   74.614786] SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses transition SIDs
[   74.645831] 
[   74.645833] **** Context Switch from TID 4103511040 to TID 4104764416 ****
[   74.645835] 
[   74.645838]    utils-0286 [4104764416] [00] evaluate_integer      : Return value [0]
[   74.863132] type=1400 audit(1296067147.702:4): avc:  denied  { mmap_zero } for  pid=443 comm="vbetool" scontext=system_u:system_r:vbetool_t:s0-s0:c0.c1023 tcontext=system_u:system_r:vbetool_t:s0-s0:c0.c1023 tclass=memprotect
[   74.955382] 
[   74.955384] **** Context Switch from TID 4104764416 to TID 4103510016 ****
[   74.955386] 
[   74.955389]    utils-0286 [4103510016] [00] evaluate_integer      : Return value [0]
[   74.956251] 
[   74.956253] **** Context Switch from TID 4103510016 to TID 4090493952 ****
[   74.956254] 
[   74.956257]    utils-0286 [4090493952] [00] evaluate_integer      : Return value [0]
[   75.280312] input: PC Speaker as /devices/platform/pcspkr/input/input6
[   75.285356] 
[   75.285357] **** Context Switch from TID 4090493952 to TID 4092660736 ****
[   75.285359] 
[   75.285362]     scan-0580 [4092660736] [00] bus_driver_init       : Driver successfully bound to device
[   75.285373]     scan-0418 [4092660736] [00] device_probe          : Found driver [wmi] for device [WMID]
[   75.285392] wmi: Mapper loaded
[   75.589752] Linux video capture interface: v2.00
[   75.705940] uvcvideo: Found UVC 1.00 device WebCam (064e:a102)
[   75.722728] input: WebCam as /devices/pci0000:00/0000:00:1d.7/usb2/2-5/2-5:1.0/input/input7
[   75.723077] usbcore: registered new interface driver uvcvideo
[   75.723080] USB Video Class driver (v1.0.0)
[   75.785263] cfg80211: Calling CRDA to update world regulatory domain
[   76.139998] microcode: CPU0 updated to revision 0xa0b, date = 2010-09-28
[   76.449242] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:d
[   76.449246] iwlagn: Copyright(c) 2003-2010 Intel Corporation
[   76.449362] iwlagn 0000:02:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[   76.449372] iwlagn 0000:02:00.0: setting latency timer to 64
[   76.449406] iwlagn 0000:02:00.0: Detected Intel(R) WiFi Link 5100 AGN, REV=0x54
[   76.471433] iwlagn 0000:02:00.0: device EEPROM VER=0x11f, CALIB=0x4
[   76.471436] iwlagn 0000:02:00.0: Device SKU: 0Xb
[   76.471703] iwlagn 0000:02:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
[   76.471784] iwlagn 0000:02:00.0: irq 44 for MSI/MSI-X
[   76.790708] cfg80211: World regulatory domain updated:
[   76.790713] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   76.790717] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   76.790721] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   76.790725] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   76.790729] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   76.790733] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   76.880503] iwlagn 0000:02:00.0: loaded firmware version 8.24.2.12
[   76.939311] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[   76.939379] HDA Intel 0000:00:1b.0: irq 45 for MSI/MSI-X
[   76.939402] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   77.367485] ALSA sound/pci/hda/patch_realtek.c:1530: SKU: Nid=0x1d sku_cfg=0x4015812d
[   77.367491] ALSA sound/pci/hda/patch_realtek.c:1532: SKU: port_connectivity=0x1
[   77.367495] ALSA sound/pci/hda/patch_realtek.c:1533: SKU: enable_pcbeep=0x1
[   77.367498] ALSA sound/pci/hda/patch_realtek.c:1534: SKU: check_sum=0x00000005
[   77.367502] ALSA sound/pci/hda/patch_realtek.c:1535: SKU: customization=0x00000081
[   77.367506] ALSA sound/pci/hda/patch_realtek.c:1536: SKU: external_amp=0x5
[   77.367509] ALSA sound/pci/hda/patch_realtek.c:1537: SKU: platform_type=0x1
[   77.367513] ALSA sound/pci/hda/patch_realtek.c:1538: SKU: swap=0x0
[   77.367516] ALSA sound/pci/hda/patch_realtek.c:1539: SKU: override=0x1
[   77.368009] hda_codec: ALC269: BIOS auto-probing.
[   77.368015] ALSA sound/pci/hda/hda_codec.c:4633: autoconfig: line_outs=1 (0x14/0x0/0x0/0x0/0x0)
[   77.368020] ALSA sound/pci/hda/hda_codec.c:4637:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[   77.368024] ALSA sound/pci/hda/hda_codec.c:4641:    hp_outs=1 (0x15/0x0/0x0/0x0/0x0)
[   77.368029] ALSA sound/pci/hda/hda_codec.c:4642:    mono: mono_out=0x0
[   77.368032] ALSA sound/pci/hda/hda_codec.c:4645:    dig-out=0x1e/0x0
[   77.368035] ALSA sound/pci/hda/hda_codec.c:4646:    inputs:
[   77.368038] ALSA sound/pci/hda/hda_codec.c:4652: 
[   77.368468] ALSA sound/pci/hda/patch_realtek.c:1587: realtek: No valid SSID, checking pincfg 0x4015812d for NID 0x1d
[   77.368473] ALSA sound/pci/hda/patch_realtek.c:1603: realtek: Enabling init ASM_ID=0x812d CODEC_ID=10ec0269
[   77.369327] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input8
[   77.410458] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
[   77.456718] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
[   77.456882] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
[   77.550283] cfg80211: Calling CRDA for country: DE
[   77.555887] cfg80211: Regulatory domain changed to country: DE
[   77.555890] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   77.555894] cfg80211:     (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   77.555898] cfg80211:     (5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   77.555901] cfg80211:     (5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   77.555905] cfg80211:     (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
[   82.085382] 
[   82.085383] **** Context Switch from TID 4092660736 to TID 4092052480 ****
[   82.085385] 
[   82.085388]    utils-0286 [4092052480] [00] evaluate_integer      : Return value [0]
[   82.143890] 
[   82.143892] **** Context Switch from TID 4092052480 to TID 4090489856 ****
[   82.143894] 
[   82.143897]    utils-0286 [4090489856] [00] evaluate_integer      : Return value [0]
[   82.192197] 
[   82.192198] **** Context Switch from TID 4090489856 to TID 4073014272 ****
[   82.192200] 
[   82.192203]    utils-0286 [4073014272] [00] evaluate_integer      : Return value [0]
[   82.416907] EXT4-fs (sda2): re-mounted. Opts: data=writeback
[   83.015282] EXT4-fs (sda1): mounted filesystem without journal. Opts: (null)
[   83.015399] SELinux: initialized (dev sda1, type ext2), uses xattr
[   83.073464] EXT4-fs (dm-0): mounted filesystem with ordered data mode. Opts: (null)
[   83.073471] SELinux: initialized (dev dm-0, type ext4), uses xattr
[   84.816338] Adding 2007604k swap on /dev/mapper/luks-swap.  Priority:-1 extents:1 across:2007604k 
[   84.834847] SELinux: initialized (dev binfmt_misc, type binfmt_misc), uses genfs_contexts
[   85.495838] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   85.810056] auditd (939): /proc/939/oom_adj is deprecated, please use /proc/939/oom_score_adj instead.
[   86.542802] 
[   86.542804] **** Context Switch from TID 4073014272 to TID 4074788864 ****
[   86.542806] 
[   86.542809]    utils-0286 [4074788864] [00] evaluate_integer      : Return value [0]
[   91.098670] atl1c 0000:01:00.0: irq 46 for MSI/MSI-X
[   91.154307] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   91.296153] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   91.784946] 
[   91.784948] **** Context Switch from TID 4074788864 to TID 4091162624 ****
[   91.784950] 
[   91.784953]    utils-0286 [4091162624] [00] evaluate_integer      : Return value [0]
[   92.068270] 
[   92.068272] **** Context Switch from TID 4091162624 to TID 4074589184 ****
[   92.068274] 
[   92.068277]    utils-0286 [4074589184] [00] evaluate_integer      : Return value [0]
[   92.670988] Bluetooth: Core ver 2.15
[   92.671178] NET: Registered protocol family 31
[   92.671180] Bluetooth: HCI device and connection manager initialized
[   92.671183] Bluetooth: HCI socket layer initialized
[   92.729344] Bluetooth: L2CAP ver 2.15
[   92.729348] Bluetooth: L2CAP socket layer initialized
[   92.802325] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   92.802329] Bluetooth: BNEP filters: protocol multicast
[   92.915564] Bluetooth: SCO (Voice Link) ver 0.6
[   92.915568] Bluetooth: SCO socket layer initialized
[  103.781218] 
[  103.781219] **** Context Switch from TID 4074589184 to TID 4054175744 ****
[  103.781221] 
[  103.781225]    utils-0286 [4054175744] [00] evaluate_integer      : Return value [0]
[  103.781929]    utils-0286 [4054175744] [00] evaluate_integer      : Return value [0]
[  174.246988] fuse init (API version 7.16)
[  174.282594] SELinux: initialized (dev fuse, type fuse), uses genfs_contexts
[  174.296397] SELinux: initialized (dev fusectl, type fusectl), uses genfs_contexts
[  192.860426] wlan0: deauthenticating from 00:23:08:1d:f2:bb by local choice (reason=3)
[  192.936978] wlan0: authenticate with 00:23:08:1d:f2:bb (try 1)
[  193.136681] wlan0: authenticate with 00:23:08:1d:f2:bb (try 2)
[  193.145438] wlan0: authenticated
[  193.148673] wlan0: associate with 00:23:08:1d:f2:bb (try 1)
[  193.346687] wlan0: associate with 00:23:08:1d:f2:bb (try 2)
[  193.361926] wlan0: RX AssocResp from 00:23:08:1d:f2:bb (capab=0x431 status=0 aid=2)
[  193.361934] wlan0: associated
[  193.364644] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[  203.696736] wlan0: no IPv6 routers present




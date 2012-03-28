Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751075Ab2C1FWy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 01:22:54 -0400
Received: from mta103.odn.ne.jp ([143.90.14.143]:34632 "EHLO cmta103.odn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750808Ab2C1FWt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 01:22:49 -0400
Message-ID: <4F72A027.7040907@yahoo.co.jp>
Date: Wed, 28 Mar 2012 14:22:47 +0900
From: "ANEZAKI, Akira" <fireblade1230@yahoo.co.jp>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120316 Thunderbird/11.0
MIME-Version: 1.0
To: Gwendal Grignou <gwendal@google.com>
CC: IDE/ATA development list <linux-ide@vger.kernel.org>,
        Mark Lord <kernel@teksavvy.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Jeff Garzik <jgarzik@pobox.com>
Subject: Re: Fwd: libata-pmp patch for 3.2.x and later for eSATA Port Multiplier
 Sil3726
References: <4F5ECD06.3000608@yahoo.co.jp> <4F5F7C4C.7080800@teksavvy.com> <4F662AFB.9050106@yahoo.co.jp> <CAMHSBOWg+rxxrVjf05r1tYDpW1S75XzdrLQ+U8TrjC9okRYtuA@mail.gmail.com> <4F6AAC37.7040907@yahoo.co.jp> <4F6B30D9.2070805@yahoo.co.jp> <CAMHSBOVD4wAtwAravVkDjyWV+Nwtuybt=yae=26PcGxxirw=Lg@mail.gmail.com> <4F6B679C.60004@yahoo.co.jp> <CAMHSBOWDYyLRREZNGqhBtvF_gSrvB-b=PVx3qULCqpc7yeJCcQ@mail.gmail.com> <4F6C1AE5.5060405@yahoo.co.jp> <CAMHSBOXuX1U8uPyN136AQ_LRW85Ex8EUu1-_hdBqnSMtdmg+0Q@mail.gmail.com> <4F6C4967.80309@yahoo.co.jp> <4F6E728A.3090203@yahoo.co.jp> <CAMHSBOVtj8pXVtSK7qUmzSzXTCJWTK6-m7ZY6TB3gj-dT70ptw@mail.gmail.com> <4F6FBB3E.8060409@yahoo.co.jp> <4F6FD4CD.5040608@yahoo.co.jp> <4F703BEB.1040309@yahoo.co.jp> <4F70527A.4000005@world.odn.ne.jp> <CAMHSBOWOLj0igQYK16qQ+BznzmS2KV89dw4ahRz0h5tUw+YOdQ@mail.gmail.com>
In-Reply-To: <CAMHSBOWOLj0igQYK16qQ+BznzmS2KV89dw4ahRz0h5tUw+YOdQ@mail.gmail.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Gwendal,

(2012/03/27 20:17), Gwendal Grignou wrote:
> Regarding the machine with 10 disks, I see that all the drives have
> been found; I don't see any other error from the /var/log/messages
> snippet that could explain md not finding the volumes.

I have attached 11 disks log. (I'm sorry for my mistake!) RAID1 is
assembled only with 1  partition. The RAID1s are md1 and md2.

Best Regards,
Akira

--- 3.2.10 2pmp power cycle error on raid ---
> [    0.000000] Initializing cgroup subsys cpuset
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Linux version 3.2.10-3.fc16.i686.PAE (mockbuild@x86-02.phx2.fedoraproject.org) (gcc version 4.6.2 20111027 (Red Hat 4.6.2-1) (GCC) ) #1 SMP Thu Mar 15 20:37:01 UTC 2012
> [    0.000000] BIOS-provided physical RAM map:
> [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009b800 (usable)
> [    0.000000]  BIOS-e820: 000000000009b800 - 00000000000a0000 (reserved)
> [    0.000000]  BIOS-e820: 00000000000e3000 - 0000000000100000 (reserved)
> [    0.000000]  BIOS-e820: 0000000000100000 - 00000000bffb0000 (usable)
> [    0.000000]  BIOS-e820: 00000000bffb0000 - 00000000bffbe000 (ACPI data)
> [    0.000000]  BIOS-e820: 00000000bffbe000 - 00000000bfff0000 (ACPI NVS)
> [    0.000000]  BIOS-e820: 00000000bfff0000 - 00000000c0000000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
> [    0.000000]  BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
> [    0.000000] NX (Execute Disable) protection: active
> [    0.000000] DMI present.
> [    0.000000] DMI: MICRO-STAR INTERNATIONAL CO.,LTD MS-7360/MS-7360, BIOS V1.AB2 05/28/2007
> [    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
> [    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
> [    0.000000] last_pfn = 0xbffb0 max_arch_pfn = 0x1000000
> [    0.000000] MTRR default type: uncachable
> [    0.000000] MTRR fixed ranges enabled:
> [    0.000000]   00000-9FFFF write-back
> [    0.000000]   A0000-BFFFF uncachable
> [    0.000000]   C0000-CFFFF write-protect
> [    0.000000]   D0000-DFFFF uncachable
> [    0.000000]   E0000-EFFFF write-through
> [    0.000000]   F0000-FFFFF write-protect
> [    0.000000] MTRR variable ranges enabled:
> [    0.000000]   0 base 000000000 mask F80000000 write-back
> [    0.000000]   1 base 080000000 mask FC0000000 write-back
> [    0.000000]   2 disabled
> [    0.000000]   3 disabled
> [    0.000000]   4 disabled
> [    0.000000]   5 disabled
> [    0.000000]   6 disabled
> [    0.000000]   7 disabled
> [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> [    0.000000] found SMP MP-table at [c00ff780] ff780
> [    0.000000] initial memory mapped : 0 - 01200000
> [    0.000000] Base memory trampoline at [c0097000] 97000 size 16384
> [    0.000000] init_memory_mapping: 0000000000000000-00000000375fe000
> [    0.000000]  0000000000 - 0000200000 page 4k
> [    0.000000]  0000200000 - 0037400000 page 2M
> [    0.000000]  0037400000 - 00375fe000 page 4k
> [    0.000000] kernel direct mapping tables up to 375fe000 @ 11f8000-1200000
> [    0.000000] RAMDISK: 37081000 - 37ff0000
> [    0.000000] Allocated new RAMDISK: 36112000 - 37080e5b
> [    0.000000] Move RAMDISK from 0000000037081000 - 0000000037fefe5a to 36112000 - 37080e5a
> [    0.000000] ACPI: RSDP 000f95c0 00014 (v00 ACPIAM)
> [    0.000000] ACPI: RSDT bffb0000 00044 (v01 Mouse  Computer 20070528 MSFT 00000097)
> [    0.000000] ACPI: FACP bffb0200 00084 (v01 052807 FACP1414 20070528 MSFT 00000097)
> [    0.000000] ACPI: DSDT bffb05c0 05564 (v01  0AAAA 0AAAA000 00000000 INTL 20051117)
> [    0.000000] ACPI: FACS bffbe000 00040
> [    0.000000] ACPI: APIC bffb0390 0006C (v01 052807 APIC1414 20070528 MSFT 00000097)
> [    0.000000] ACPI: MCFG bffb0400 0003C (v01 052807 OEMMCFG  20070528 MSFT 00000097)
> [    0.000000] ACPI: SLIC bffb0440 00176 (v01 Mouse  Computer 20070528 MSFT 00000097)
> [    0.000000] ACPI: SLIC bffb0440 00176 (v01 Mouse  Computer 20070528 MSFT 00000097)
> [    0.000000] ACPI: OEMB bffbe040 00071 (v01 052807 OEMB1414 20070528 MSFT 00000097)
> [    0.000000] ACPI: GSCI bffbe0c0 02024 (v01 052807 GMCHSCI  20070528 MSFT 00000097)
> [    0.000000] ACPI: SSDT bffc1330 0082F (v01 DpgPmm    CpuPm 00000012 INTL 20051117)
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] 2185MB HIGHMEM available.
> [    0.000000] 885MB LOWMEM available.
> [    0.000000]   mapped low ram: 0 - 375fe000
> [    0.000000]   low ram: 0 - 375fe000
> [    0.000000] Zone PFN ranges:
> [    0.000000]   DMA      0x00000010 -> 0x00001000
> [    0.000000]   Normal   0x00001000 -> 0x000375fe
> [    0.000000]   HighMem  0x000375fe -> 0x000bffb0
> [    0.000000] Movable zone start PFN for each node
> [    0.000000] early_node_map[2] active PFN ranges
> [    0.000000]     0: 0x00000010 -> 0x0000009b
> [    0.000000]     0: 0x00000100 -> 0x000bffb0
> [    0.000000] On node 0 totalpages: 786235
> [    0.000000] free_area_init_node: node 0, pgdat c0bb3bc0, node_mem_map f4912200
> [    0.000000]   DMA zone: 32 pages used for memmap
> [    0.000000]   DMA zone: 0 pages reserved
> [    0.000000]   DMA zone: 3947 pages, LIFO batch:0
> [    0.000000]   Normal zone: 1740 pages used for memmap
> [    0.000000]   Normal zone: 220978 pages, LIFO batch:31
> [    0.000000]   HighMem zone: 4372 pages used for memmap
> [    0.000000]   HighMem zone: 555166 pages, LIFO batch:31
> [    0.000000] Using APIC driver default
> [    0.000000] ACPI: PM-Timer IO Port: 0x808
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
> [    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 4, version 32, address 0xfec00000, GSI 0-23
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> [    0.000000] ACPI: IRQ0 used by override.
> [    0.000000] ACPI: IRQ2 used by override.
> [    0.000000] ACPI: IRQ9 used by override.
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
> [    0.000000] nr_irqs_gsi: 40
> [    0.000000] PM: Registered nosave memory: 000000000009b000 - 000000000009c000
> [    0.000000] PM: Registered nosave memory: 000000000009c000 - 00000000000a0000
> [    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e3000
> [    0.000000] PM: Registered nosave memory: 00000000000e3000 - 0000000000100000
> [    0.000000] Allocating PCI resources starting at c0000000 (gap: c0000000:3ee00000)
> [    0.000000] Booting paravirtualized kernel on bare hardware
> [    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:4 nr_node_ids:1
> [    0.000000] PERCPU: Embedded 14 pages/cpu @f7200000 s34240 r0 d23104 u524288
> [    0.000000] pcpu-alloc: s34240 r0 d23104 u524288 alloc=1*2097152
> [    0.000000] pcpu-alloc: [0] 0 1 2 3 
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 780091
> [    0.000000] Kernel command line: ro root=UUID=773cb4b3-4bb0-4705-b494-08cb9c2b5d73 LANG=ja_JP.UTF-8 KEYBOARDTYPE=pc KEYTABLE=jp106 rhgb quiet nomodeset
> [    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
> [    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
> [    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
> [    0.000000] Initializing CPU#0
> [    0.000000] allocated 12581376 bytes of page_cgroup
> [    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
> [    0.000000] Initializing HighMem for node 0 (000375fe:000bffb0)
> [    0.000000] Memory: 3081612k/3145408k available (5404k kernel code, 63328k reserved, 2569k data, 644k init, 2238152k highmem)
> [    0.000000] virtual kernel memory layout:
> [    0.000000]     fixmap  : 0xffa95000 - 0xfffff000   (5544 kB)
> [    0.000000]     pkmap   : 0xff600000 - 0xff800000   (2048 kB)
> [    0.000000]     vmalloc : 0xf7dfe000 - 0xff5fe000   ( 120 MB)
> [    0.000000]     lowmem  : 0xc0000000 - 0xf75fe000   ( 885 MB)
> [    0.000000]       .init : 0xc0bca000 - 0xc0c6b000   ( 644 kB)
> [    0.000000]       .data : 0xc094723f - 0xc0bc9980   (2569 kB)
> [    0.000000]       .text : 0xc0400000 - 0xc094723f   (5404 kB)
> [    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
> [    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
> [    0.000000] Hierarchical RCU implementation.
> [    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
> [    0.000000] NR_IRQS:2304 nr_irqs:712 16
> [    0.000000] CPU 0 irqstacks, hard=f380a000 soft=f380c000
> [    0.000000] Console: colour VGA+ 80x25
> [    0.000000] console [tty0] enabled
> [    0.000000] Fast TSC calibration using PIT
> [    0.000000] Detected 2402.216 MHz processor.
> [    0.001001] Calibrating delay loop (skipped), value calculated using timer frequency.. 4804.43 BogoMIPS (lpj=2402216)
> [    0.001005] pid_max: default: 32768 minimum: 301
> [    0.001024] Security Framework initialized
> [    0.001032] SELinux:  Initializing.
> [    0.001039] SELinux:  Starting in permissive mode
> [    0.001086] Mount-cache hash table entries: 512
> [    0.002117] Initializing cgroup subsys cpuacct
> [    0.002122] Initializing cgroup subsys memory
> [    0.002129] Initializing cgroup subsys devices
> [    0.002131] Initializing cgroup subsys freezer
> [    0.002133] Initializing cgroup subsys net_cls
> [    0.002135] Initializing cgroup subsys blkio
> [    0.002139] Initializing cgroup subsys perf_event
> [    0.002162] CPU: Physical Processor ID: 0
> [    0.002163] CPU: Processor Core ID: 0
> [    0.002166] mce: CPU supports 6 MCE banks
> [    0.002173] CPU0: Thermal monitoring enabled (TM2)
> [    0.002175] using mwait in idle threads.
> [    0.003140] ACPI: Core revision 20110623
> [    0.006009] ftrace: allocating 22484 entries in 45 pages
> [    0.007043] Enabling APIC mode:  Flat.  Using 1 I/O APICs
> [    0.007393] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> [    0.018127] CPU0: Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz stepping 0b
> [    0.018998] Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
> [    0.018998] PEBS disabled due to CPU errata.
> [    0.018998] ... version:                2
> [    0.018998] ... bit width:              40
> [    0.018998] ... generic registers:      2
> [    0.018998] ... value mask:             000000ffffffffff
> [    0.018998] ... max period:             000000007fffffff
> [    0.018998] ... fixed-purpose events:   3
> [    0.018998] ... event mask:             0000000700000003
> [    0.018998] NMI watchdog enabled, takes one hw-pmu counter.
> [    0.018998] CPU 1 irqstacks, hard=f3902000 soft=f3904000
> [    0.018998] Booting Node   0, Processors  #1
> [    0.018998] smpboot cpu 1: start_ip = 97000
> [    0.001999] Initializing CPU#1
> [    0.090019] NMI watchdog enabled, takes one hw-pmu counter.
> [    0.090116] CPU 2 irqstacks, hard=f3930000 soft=f3932000
> [    0.090118]  #2
> [    0.090119] smpboot cpu 2: start_ip = 97000
> [    0.001999] Initializing CPU#2
> [    0.162002] NMI watchdog enabled, takes one hw-pmu counter.
> [    0.162084] CPU 3 irqstacks, hard=f393e000 soft=f3948000
> [    0.162086]  #3 Ok.
> [    0.162088] smpboot cpu 3: start_ip = 97000
> [    0.001999] Initializing CPU#3
> [    0.233992] NMI watchdog enabled, takes one hw-pmu counter.
> [    0.234017] Brought up 4 CPUs
> [    0.234020] Total of 4 processors activated (19216.12 BogoMIPS).
> [    0.235093] devtmpfs: initialized
> [    0.235212] PM: Registering ACPI NVS region at bffbe000 (204800 bytes)
> [    0.236839] atomic64 test passed for i586+ platform with CX8 and with SSE
> [    0.236864] RTC time: 19:04:40, date: 03/26/12
> [    0.236897] NET: Registered protocol family 16
> [    0.237074] ACPI: bus type pci registered
> [    0.237134] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
> [    0.237137] PCI: not using MMCONFIG
> [    0.237236] PCI : PCI BIOS aera is rw and x. Use pci=nobios if you want it NX.
> [    0.237293] PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=7
> [    0.237295] PCI: Using configuration type 1 for base access
> [    0.238395] bio: create slab <bio-0> at 0
> [    0.238395] ACPI: Added _OSI(Module Device)
> [    0.238395] ACPI: Added _OSI(Processor Device)
> [    0.238395] ACPI: Added _OSI(3.0 _SCP Extensions)
> [    0.238395] ACPI: Added _OSI(Processor Aggregator Device)
> [    0.239495] ACPI: EC: Detected MSI hardware, enabling workarounds.
> [    0.239500] ACPI: EC: Look up EC in DSDT
> [    0.240590] ACPI: Executed 1 blocks of module-level executable AML code
> [    0.243103] ACPI: SSDT bffc00f0 00277 (v01 DpgPmm  P001Ist 00000011 INTL 20051117)
> [    0.243325] ACPI: Dynamic OEM Table Load:
> [    0.243328] ACPI: SSDT   (null) 00277 (v01 DpgPmm  P001Ist 00000011 INTL 20051117)
> [    0.243565] ACPI: SSDT bffc0580 00277 (v01 DpgPmm  P002Ist 00000012 INTL 20051117)
> [    0.243786] ACPI: Dynamic OEM Table Load:
> [    0.243789] ACPI: SSDT   (null) 00277 (v01 DpgPmm  P002Ist 00000012 INTL 20051117)
> [    0.244029] ACPI: SSDT bffc0a10 00277 (v01 DpgPmm  P003Ist 00000012 INTL 20051117)
> [    0.244253] ACPI: Dynamic OEM Table Load:
> [    0.244255] ACPI: SSDT   (null) 00277 (v01 DpgPmm  P003Ist 00000012 INTL 20051117)
> [    0.244489] ACPI: SSDT bffc0ea0 00277 (v01 DpgPmm  P004Ist 00000012 INTL 20051117)
> [    0.244715] ACPI: Dynamic OEM Table Load:
> [    0.244718] ACPI: SSDT   (null) 00277 (v01 DpgPmm  P004Ist 00000012 INTL 20051117)
> [    0.244937] ACPI: Interpreter enabled
> [    0.244956] ACPI: (supports S0 S3 S4 S5)
> [    0.244978] ACPI: Using IOAPIC for interrupt routing
> [    0.244997] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
> [    0.246009] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI motherboard resources
> [    0.246011] PCI: Using MMCONFIG for extended config space
> [    0.251297] ACPI: No dock devices found.
> [    0.251299] HEST: Table not found.
> [    0.251304] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
> [    0.251465] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
> [    0.251630] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7] (ignored)
> [    0.251633] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff] (ignored)
> [    0.251635] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
> [    0.251638] pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x000dffff] (ignored)
> [    0.251640] pci_root PNP0A08:00: host bridge window [mem 0xc0000000-0xdfffffff] (ignored)
> [    0.251642] pci_root PNP0A08:00: host bridge window [mem 0xf0000000-0xffffffff] (ignored)
> [    0.251652] pci 0000:00:00.0: [8086:29c0] type 0 class 0x000600
> [    0.251693] pci 0000:00:01.0: [8086:29c1] type 1 class 0x000604
> [    0.251732] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
> [    0.251735] pci 0000:00:01.0: PME# disabled
> [    0.251770] pci 0000:00:1a.0: [8086:2937] type 0 class 0x000c03
> [    0.251810] pci 0000:00:1a.0: reg 20: [io  0x9c00-0x9c1f]
> [    0.251857] pci 0000:00:1a.1: [8086:2938] type 0 class 0x000c03
> [    0.251897] pci 0000:00:1a.1: reg 20: [io  0x9880-0x989f]
> [    0.251953] pci 0000:00:1a.7: [8086:293c] type 0 class 0x000c03
> [    0.251977] pci 0000:00:1a.7: reg 10: [mem 0xf9fffc00-0xf9ffffff]
> [    0.252061] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
> [    0.252066] pci 0000:00:1a.7: PME# disabled
> [    0.252088] pci 0000:00:1b.0: [8086:293e] type 0 class 0x000403
> [    0.252102] pci 0000:00:1b.0: reg 10: [mem 0xf9ff8000-0xf9ffbfff 64bit]
> [    0.252164] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
> [    0.252168] pci 0000:00:1b.0: PME# disabled
> [    0.252186] pci 0000:00:1c.0: [8086:2940] type 1 class 0x000604
> [    0.252250] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
> [    0.252254] pci 0000:00:1c.0: PME# disabled
> [    0.252273] pci 0000:00:1c.1: [8086:2942] type 1 class 0x000604
> [    0.252337] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
> [    0.252341] pci 0000:00:1c.1: PME# disabled
> [    0.252360] pci 0000:00:1c.2: [8086:2944] type 1 class 0x000604
> [    0.252424] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
> [    0.252428] pci 0000:00:1c.2: PME# disabled
> [    0.252448] pci 0000:00:1c.4: [8086:2948] type 1 class 0x000604
> [    0.252512] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
> [    0.252515] pci 0000:00:1c.4: PME# disabled
> [    0.252535] pci 0000:00:1c.5: [8086:294a] type 1 class 0x000604
> [    0.252599] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
> [    0.252602] pci 0000:00:1c.5: PME# disabled
> [    0.252623] pci 0000:00:1d.0: [8086:2934] type 0 class 0x000c03
> [    0.252663] pci 0000:00:1d.0: reg 20: [io  0x9800-0x981f]
> [    0.252710] pci 0000:00:1d.1: [8086:2935] type 0 class 0x000c03
> [    0.252750] pci 0000:00:1d.1: reg 20: [io  0x9480-0x949f]
> [    0.252798] pci 0000:00:1d.2: [8086:2936] type 0 class 0x000c03
> [    0.252838] pci 0000:00:1d.2: reg 20: [io  0x9400-0x941f]
> [    0.252885] pci 0000:00:1d.3: [8086:2939] type 0 class 0x000c03
> [    0.252924] pci 0000:00:1d.3: reg 20: [io  0x9080-0x909f]
> [    0.252983] pci 0000:00:1d.7: [8086:293a] type 0 class 0x000c03
> [    0.253003] pci 0000:00:1d.7: reg 10: [mem 0xf9fff800-0xf9fffbff]
> [    0.253087] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
> [    0.253091] pci 0000:00:1d.7: PME# disabled
> [    0.253109] pci 0000:00:1e.0: [8086:244e] type 1 class 0x000604
> [    0.253166] pci 0000:00:1f.0: [8086:2918] type 0 class 0x000601
> [    0.253242] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0a00 (mask 00ff)
> [    0.253287] pci 0000:00:1f.2: [8086:2921] type 0 class 0x000101
> [    0.253301] pci 0000:00:1f.2: reg 10: [io  0x9000-0x9007]
> [    0.253309] pci 0000:00:1f.2: reg 14: [io  0x8c00-0x8c03]
> [    0.253316] pci 0000:00:1f.2: reg 18: [io  0x8880-0x8887]
> [    0.253323] pci 0000:00:1f.2: reg 1c: [io  0x8800-0x8803]
> [    0.253331] pci 0000:00:1f.2: reg 20: [io  0x8480-0x848f]
> [    0.253338] pci 0000:00:1f.2: reg 24: [io  0x8400-0x840f]
> [    0.253381] pci 0000:00:1f.3: [8086:2930] type 0 class 0x000c05
> [    0.253395] pci 0000:00:1f.3: reg 10: [mem 0xf9fff400-0xf9fff4ff 64bit]
> [    0.253414] pci 0000:00:1f.3: reg 20: [io  0x0400-0x041f]
> [    0.253445] pci 0000:00:1f.5: [8086:2926] type 0 class 0x000101
> [    0.253459] pci 0000:00:1f.5: reg 10: [io  0x8000-0x8007]
> [    0.253466] pci 0000:00:1f.5: reg 14: [io  0x7c00-0x7c03]
> [    0.253474] pci 0000:00:1f.5: reg 18: [io  0x7880-0x7887]
> [    0.253481] pci 0000:00:1f.5: reg 1c: [io  0x7800-0x7803]
> [    0.253489] pci 0000:00:1f.5: reg 20: [io  0x7480-0x748f]
> [    0.253496] pci 0000:00:1f.5: reg 24: [io  0x7400-0x740f]
> [    0.253568] pci 0000:01:00.0: [10de:0615] type 0 class 0x000300
> [    0.253578] pci 0000:01:00.0: reg 10: [mem 0xfd000000-0xfdffffff]
> [    0.253589] pci 0000:01:00.0: reg 14: [mem 0xd0000000-0xdfffffff 64bit pref]
> [    0.253599] pci 0000:01:00.0: reg 1c: [mem 0xfa000000-0xfbffffff 64bit]
> [    0.253606] pci 0000:01:00.0: reg 24: [io  0xac00-0xac7f]
> [    0.253614] pci 0000:01:00.0: reg 30: [mem 0xfe7e0000-0xfe7fffff pref]
> [    0.253665] pci 0000:00:01.0: PCI bridge to [bus 01-01]
> [    0.253668] pci 0000:00:01.0:   bridge window [io  0xa000-0xafff]
> [    0.253671] pci 0000:00:01.0:   bridge window [mem 0xfa000000-0xfe7fffff]
> [    0.253675] pci 0000:00:01.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
> [    0.253711] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
> [    0.253774] pci 0000:03:00.0: [1095:3132] type 0 class 0x000180
> [    0.253800] pci 0000:03:00.0: reg 10: [mem 0xfe8ffc00-0xfe8ffc7f 64bit]
> [    0.253820] pci 0000:03:00.0: reg 18: [mem 0xfe8f8000-0xfe8fbfff 64bit]
> [    0.253834] pci 0000:03:00.0: reg 20: [io  0xbc00-0xbc7f]
> [    0.253859] pci 0000:03:00.0: reg 30: [mem 0xfe800000-0xfe87ffff pref]
> [    0.253923] pci 0000:03:00.0: supports D1 D2
> [    0.253944] pci 0000:03:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
> [    0.253949] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
> [    0.253952] pci 0000:00:1c.1:   bridge window [io  0xb000-0xbfff]
> [    0.253956] pci 0000:00:1c.1:   bridge window [mem 0xfe800000-0xfe8fffff]
> [    0.254021] pci 0000:04:00.0: [1095:3132] type 0 class 0x000180
> [    0.254047] pci 0000:04:00.0: reg 10: [mem 0xfe9ffc00-0xfe9ffc7f 64bit]
> [    0.254067] pci 0000:04:00.0: reg 18: [mem 0xfe9f8000-0xfe9fbfff 64bit]
> [    0.254081] pci 0000:04:00.0: reg 20: [io  0xcc00-0xcc7f]
> [    0.254106] pci 0000:04:00.0: reg 30: [mem 0xfe900000-0xfe97ffff pref]
> [    0.254170] pci 0000:04:00.0: supports D1 D2
> [    0.254190] pci 0000:04:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
> [    0.254195] pci 0000:00:1c.2: PCI bridge to [bus 04-04]
> [    0.254198] pci 0000:00:1c.2:   bridge window [io  0xc000-0xcfff]
> [    0.254202] pci 0000:00:1c.2:   bridge window [mem 0xfe900000-0xfe9fffff]
> [    0.254258] pci 0000:05:00.0: [11ab:6121] type 0 class 0x000101
> [    0.254274] pci 0000:05:00.0: reg 10: [io  0xdc00-0xdc07]
> [    0.254285] pci 0000:05:00.0: reg 14: [io  0xd880-0xd883]
> [    0.254296] pci 0000:05:00.0: reg 18: [io  0xd800-0xd807]
> [    0.254308] pci 0000:05:00.0: reg 1c: [io  0xd480-0xd483]
> [    0.254319] pci 0000:05:00.0: reg 20: [io  0xd400-0xd40f]
> [    0.254330] pci 0000:05:00.0: reg 24: [mem 0xfeaffc00-0xfeafffff]
> [    0.254392] pci 0000:05:00.0: supports D1
> [    0.254394] pci 0000:05:00.0: PME# supported from D0 D1 D3hot
> [    0.254398] pci 0000:05:00.0: PME# disabled
> [    0.254414] pci 0000:05:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
> [    0.254418] pci 0000:00:1c.4: PCI bridge to [bus 05-05]
> [    0.254422] pci 0000:00:1c.4:   bridge window [io  0xd000-0xdfff]
> [    0.254426] pci 0000:00:1c.4:   bridge window [mem 0xfea00000-0xfeafffff]
> [    0.254487] pci 0000:06:00.0: [10ec:8168] type 0 class 0x000200
> [    0.254505] pci 0000:06:00.0: reg 10: [io  0xe800-0xe8ff]
> [    0.254535] pci 0000:06:00.0: reg 18: [mem 0xfebff000-0xfebfffff 64bit]
> [    0.254570] pci 0000:06:00.0: reg 30: [mem 0xfebc0000-0xfebdffff pref]
> [    0.254647] pci 0000:06:00.0: supports D1 D2
> [    0.254649] pci 0000:06:00.0: PME# supported from D1 D2 D3hot D3cold
> [    0.254654] pci 0000:06:00.0: PME# disabled
> [    0.254676] pci 0000:06:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
> [    0.254680] pci 0000:00:1c.5: PCI bridge to [bus 06-06]
> [    0.254684] pci 0000:00:1c.5:   bridge window [io  0xe000-0xefff]
> [    0.254688] pci 0000:00:1c.5:   bridge window [mem 0xfeb00000-0xfebfffff]
> [    0.254747] pci 0000:00:1e.0: PCI bridge to [bus 07-07] (subtractive decode)
> [    0.254756] pci 0000:00:1e.0:   bridge window [io  0x0000-0xffff] (subtractive decode)
> [    0.254759] pci 0000:00:1e.0:   bridge window [mem 0x00000000-0xfffffffff] (subtractive decode)
> [    0.254784] pci_bus 0000:00: on NUMA node 0
> [    0.254787] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
> [    0.254932] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
> [    0.255040] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
> [    0.255081] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P5._PRT]
> [    0.255122] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P6._PRT]
> [    0.255165] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P8._PRT]
> [    0.255205] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9._PRT]
> [    0.255334]  pci0000:00: Requesting ACPI _OSC control (0x1d)
> [    0.255490]  pci0000:00: ACPI _OSC control (0x1d) granted
> [    0.264136] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 6 7 *10 11 12 14 15)
> [    0.264180] ACPI: PCI Interrupt Link [LNKB] (IRQs *5)
> [    0.264220] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 6 7 10 *11 12 14 15)
> [    0.264262] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 6 7 10 11 12 14 *15)
> [    0.264304] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 6 7 10 11 12 14 15) *0, disabled.
> [    0.264349] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 6 7 10 11 12 *14 15)
> [    0.264391] ACPI: PCI Interrupt Link [LNKG] (IRQs *3 4 6 7 10 11 12 14 15)
> [    0.264433] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 6 7 *10 11 12 14 15)
> [    0.264512] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
> [    0.264512] vgaarb: loaded
> [    0.264512] vgaarb: bridge control possible 0000:01:00.0
> [    0.264512] SCSI subsystem initialized
> [    0.264530] libata version 3.00 loaded.
> [    0.264530] usbcore: registered new interface driver usbfs
> [    0.264530] usbcore: registered new interface driver hub
> [    0.264530] usbcore: registered new device driver usb
> [    0.264530] PCI: Using ACPI for IRQ routing
> [    0.264530] PCI: pci_cache_line_size set to 64 bytes
> [    0.264530] reserve RAM buffer: 000000000009b800 - 000000000009ffff 
> [    0.264530] reserve RAM buffer: 00000000bffb0000 - 00000000bfffffff 
> [    0.265003] NetLabel: Initializing
> [    0.265005] NetLabel:  domain hash size = 128
> [    0.265006] NetLabel:  protocols = UNLABELED CIPSOv4
> [    0.265016] NetLabel:  unlabeled traffic allowed by default
> [    0.272845] pnp: PnP ACPI init
> [    0.272860] ACPI: bus type pnp registered
> [    0.272959] pnp 00:00: [bus 00-ff]
> [    0.272961] pnp 00:00: [io  0x0cf8-0x0cff]
> [    0.272964] pnp 00:00: [io  0x0000-0x0cf7 window]
> [    0.272971] pnp 00:00: [io  0x0d00-0xffff window]
> [    0.272973] pnp 00:00: [mem 0x000a0000-0x000bffff window]
> [    0.272975] pnp 00:00: [mem 0x000d0000-0x000dffff window]
> [    0.272980] pnp 00:00: [mem 0xc0000000-0xdfffffff window]
> [    0.272982] pnp 00:00: [mem 0xf0000000-0xffffffff window]
> [    0.273030] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
> [    0.273039] pnp 00:01: [mem 0xfed14000-0xfed19fff]
> [    0.273093] system 00:01: [mem 0xfed14000-0xfed19fff] has been reserved
> [    0.273096] system 00:01: Plug and Play ACPI device, IDs PNP0c01 (active)
> [    0.273126] pnp 00:02: [dma 4]
> [    0.273128] pnp 00:02: [io  0x0000-0x000f]
> [    0.273130] pnp 00:02: [io  0x0081-0x0083]
> [    0.273131] pnp 00:02: [io  0x0087]
> [    0.273133] pnp 00:02: [io  0x0089-0x008b]
> [    0.273135] pnp 00:02: [io  0x008f]
> [    0.273136] pnp 00:02: [io  0x00c0-0x00df]
> [    0.273161] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
> [    0.273171] pnp 00:03: [io  0x0070-0x0071]
> [    0.273181] pnp 00:03: [irq 8]
> [    0.273207] pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
> [    0.273215] pnp 00:04: [io  0x0061]
> [    0.273240] pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
> [    0.273248] pnp 00:05: [io  0x00f0-0x00ff]
> [    0.273252] pnp 00:05: [irq 13]
> [    0.273277] pnp 00:05: Plug and Play ACPI device, IDs PNP0c04 (active)
> [    0.273510] pnp 00:06: [io  0x03f8-0x03ff]
> [    0.273515] pnp 00:06: [irq 4]
> [    0.273517] pnp 00:06: [dma 0 disabled]
> [    0.273582] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
> [    0.273983] pnp 00:07: [io  0x0378-0x037f]
> [    0.273988] pnp 00:07: [irq 7]
> [    0.273991] pnp 00:07: [dma 0 disabled]
> [    0.274116] pnp 00:07: Plug and Play ACPI device, IDs PNP0400 (active)
> [    0.274142] pnp 00:08: [io  0x0060]
> [    0.274144] pnp 00:08: [io  0x0064]
> [    0.274149] pnp 00:08: [irq 1]
> [    0.274184] pnp 00:08: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
> [    0.274225] pnp 00:09: [irq 12]
> [    0.274258] pnp 00:09: Plug and Play ACPI device, IDs PNP0f03 PNP0f13 (active)
> [    0.274337] pnp 00:0a: [io  0x0000-0xffffffffffffffff disabled]
> [    0.274339] pnp 00:0a: [io  0x0a00-0x0adf]
> [    0.274341] pnp 00:0a: [io  0x0ae0-0x0aef]
> [    0.274392] system 00:0a: [io  0x0a00-0x0adf] has been reserved
> [    0.274395] system 00:0a: [io  0x0ae0-0x0aef] has been reserved
> [    0.274398] system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    0.274466] pnp 00:0b: [io  0x0010-0x001f]
> [    0.274469] pnp 00:0b: [io  0x0022-0x003f]
> [    0.274470] pnp 00:0b: [io  0x0044-0x005f]
> [    0.274472] pnp 00:0b: [io  0x0062-0x0063]
> [    0.274474] pnp 00:0b: [io  0x0065-0x006f]
> [    0.274476] pnp 00:0b: [io  0x0072-0x007f]
> [    0.274477] pnp 00:0b: [io  0x0080]
> [    0.274479] pnp 00:0b: [io  0x0084-0x0086]
> [    0.274481] pnp 00:0b: [io  0x0088]
> [    0.274485] pnp 00:0b: [io  0x008c-0x008e]
> [    0.274486] pnp 00:0b: [io  0x0090-0x009f]
> [    0.274488] pnp 00:0b: [io  0x00a2-0x00bf]
> [    0.274490] pnp 00:0b: [io  0x00e0-0x00ef]
> [    0.274492] pnp 00:0b: [io  0x04d0-0x04d1]
> [    0.274494] pnp 00:0b: [io  0x0800-0x087f]
> [    0.274496] pnp 00:0b: [io  0x0000-0xffffffffffffffff disabled]
> [    0.274498] pnp 00:0b: [io  0x0480-0x04bf]
> [    0.274500] pnp 00:0b: [mem 0xfed1c000-0xfed1ffff]
> [    0.274502] pnp 00:0b: [mem 0xfed20000-0xfed8ffff]
> [    0.274571] system 00:0b: [io  0x04d0-0x04d1] has been reserved
> [    0.274573] system 00:0b: [io  0x0800-0x087f] has been reserved
> [    0.274576] system 00:0b: [io  0x0480-0x04bf] has been reserved
> [    0.274578] system 00:0b: [mem 0xfed1c000-0xfed1ffff] has been reserved
> [    0.274581] system 00:0b: [mem 0xfed20000-0xfed8ffff] has been reserved
> [    0.274584] system 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    0.274654] pnp 00:0c: [mem 0xffb00000-0xffbfffff]
> [    0.274657] pnp 00:0c: [mem 0xfff00000-0xffffffff]
> [    0.274685] pnp 00:0c: Plug and Play ACPI device, IDs INT0800 (active)
> [    0.274724] pnp 00:0d: [mem 0xffc00000-0xffefffff]
> [    0.274774] system 00:0d: [mem 0xffc00000-0xffefffff] has been reserved
> [    0.274777] system 00:0d: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    0.274850] pnp 00:0e: [mem 0xfec00000-0xfec00fff]
> [    0.274852] pnp 00:0e: [mem 0xfee00000-0xfee00fff]
> [    0.274900] system 00:0e: [mem 0xfec00000-0xfec00fff] could not be reserved
> [    0.274903] system 00:0e: [mem 0xfee00000-0xfee00fff] has been reserved
> [    0.274906] system 00:0e: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    0.274936] pnp 00:0f: [mem 0xe0000000-0xefffffff]
> [    0.274991] system 00:0f: [mem 0xe0000000-0xefffffff] has been reserved
> [    0.274994] system 00:0f: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    0.275143] pnp 00:10: [mem 0x00000000-0x0009ffff]
> [    0.275145] pnp 00:10: [mem 0x000c0000-0x000cffff]
> [    0.275147] pnp 00:10: [mem 0x000e0000-0x000fffff]
> [    0.275149] pnp 00:10: [mem 0x00100000-0xbfffffff]
> [    0.275151] pnp 00:10: [mem 0x00000000-0xffffffffffffffff disabled]
> [    0.275210] system 00:10: [mem 0x00000000-0x0009ffff] could not be reserved
> [    0.275212] system 00:10: [mem 0x000c0000-0x000cffff] could not be reserved
> [    0.275215] system 00:10: [mem 0x000e0000-0x000fffff] could not be reserved
> [    0.275218] system 00:10: [mem 0x00100000-0xbfffffff] could not be reserved
> [    0.275221] system 00:10: Plug and Play ACPI device, IDs PNP0c01 (active)
> [    0.275337] pnp: PnP ACPI: found 17 devices
> [    0.275339] ACPI: ACPI bus type pnp unregistered
> [    0.312130] Switching to clocksource acpi_pm
> [    0.312164] PCI: max bus depth: 1 pci_try_num: 2
> [    0.312210] pci 0000:00:1c.5: BAR 15: assigned [mem 0xc0000000-0xc01fffff 64bit pref]
> [    0.312213] pci 0000:00:1c.4: BAR 15: assigned [mem 0xc0200000-0xc03fffff 64bit pref]
> [    0.312216] pci 0000:00:1c.2: BAR 15: assigned [mem 0xc0400000-0xc05fffff 64bit pref]
> [    0.312220] pci 0000:00:1c.1: BAR 15: assigned [mem 0xc0600000-0xc07fffff 64bit pref]
> [    0.312223] pci 0000:00:1c.0: BAR 14: assigned [mem 0xc0800000-0xc09fffff]
> [    0.312226] pci 0000:00:1c.0: BAR 15: assigned [mem 0xc0a00000-0xc0bfffff 64bit pref]
> [    0.312229] pci 0000:00:1c.0: BAR 13: assigned [io  0x1000-0x1fff]
> [    0.312232] pci 0000:00:01.0: PCI bridge to [bus 01-01]
> [    0.312234] pci 0000:00:01.0:   bridge window [io  0xa000-0xafff]
> [    0.312238] pci 0000:00:01.0:   bridge window [mem 0xfa000000-0xfe7fffff]
> [    0.312241] pci 0000:00:01.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
> [    0.312245] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
> [    0.312248] pci 0000:00:1c.0:   bridge window [io  0x1000-0x1fff]
> [    0.312253] pci 0000:00:1c.0:   bridge window [mem 0xc0800000-0xc09fffff]
> [    0.312256] pci 0000:00:1c.0:   bridge window [mem 0xc0a00000-0xc0bfffff 64bit pref]
> [    0.312262] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
> [    0.312264] pci 0000:00:1c.1:   bridge window [io  0xb000-0xbfff]
> [    0.312269] pci 0000:00:1c.1:   bridge window [mem 0xfe800000-0xfe8fffff]
> [    0.312273] pci 0000:00:1c.1:   bridge window [mem 0xc0600000-0xc07fffff 64bit pref]
> [    0.312278] pci 0000:00:1c.2: PCI bridge to [bus 04-04]
> [    0.312281] pci 0000:00:1c.2:   bridge window [io  0xc000-0xcfff]
> [    0.312285] pci 0000:00:1c.2:   bridge window [mem 0xfe900000-0xfe9fffff]
> [    0.312289] pci 0000:00:1c.2:   bridge window [mem 0xc0400000-0xc05fffff 64bit pref]
> [    0.312294] pci 0000:00:1c.4: PCI bridge to [bus 05-05]
> [    0.312297] pci 0000:00:1c.4:   bridge window [io  0xd000-0xdfff]
> [    0.312301] pci 0000:00:1c.4:   bridge window [mem 0xfea00000-0xfeafffff]
> [    0.312305] pci 0000:00:1c.4:   bridge window [mem 0xc0200000-0xc03fffff 64bit pref]
> [    0.312311] pci 0000:00:1c.5: PCI bridge to [bus 06-06]
> [    0.312313] pci 0000:00:1c.5:   bridge window [io  0xe000-0xefff]
> [    0.312318] pci 0000:00:1c.5:   bridge window [mem 0xfeb00000-0xfebfffff]
> [    0.312321] pci 0000:00:1c.5:   bridge window [mem 0xc0000000-0xc01fffff 64bit pref]
> [    0.312327] pci 0000:00:1e.0: PCI bridge to [bus 07-07]
> [    0.312346] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [    0.312349] pci 0000:00:01.0: setting latency timer to 64
> [    0.312354] pci 0000:00:1c.0: enabling device (0104 -> 0107)
> [    0.312361] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> [    0.312365] pci 0000:00:1c.0: setting latency timer to 64
> [    0.312370] pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
> [    0.312374] pci 0000:00:1c.1: setting latency timer to 64
> [    0.312382] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
> [    0.312385] pci 0000:00:1c.2: setting latency timer to 64
> [    0.312390] pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> [    0.312394] pci 0000:00:1c.4: setting latency timer to 64
> [    0.312399] pci 0000:00:1c.5: PCI INT B -> GSI 16 (level, low) -> IRQ 16
> [    0.312403] pci 0000:00:1c.5: setting latency timer to 64
> [    0.312408] pci 0000:00:1e.0: setting latency timer to 64
> [    0.312411] pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
> [    0.312414] pci_bus 0000:00: resource 1 [mem 0x00000000-0xfffffffff]
> [    0.312416] pci_bus 0000:01: resource 0 [io  0xa000-0xafff]
> [    0.312418] pci_bus 0000:01: resource 1 [mem 0xfa000000-0xfe7fffff]
> [    0.312420] pci_bus 0000:01: resource 2 [mem 0xd0000000-0xdfffffff 64bit pref]
> [    0.312423] pci_bus 0000:02: resource 0 [io  0x1000-0x1fff]
> [    0.312425] pci_bus 0000:02: resource 1 [mem 0xc0800000-0xc09fffff]
> [    0.312427] pci_bus 0000:02: resource 2 [mem 0xc0a00000-0xc0bfffff 64bit pref]
> [    0.312429] pci_bus 0000:03: resource 0 [io  0xb000-0xbfff]
> [    0.312431] pci_bus 0000:03: resource 1 [mem 0xfe800000-0xfe8fffff]
> [    0.312433] pci_bus 0000:03: resource 2 [mem 0xc0600000-0xc07fffff 64bit pref]
> [    0.312435] pci_bus 0000:04: resource 0 [io  0xc000-0xcfff]
> [    0.312437] pci_bus 0000:04: resource 1 [mem 0xfe900000-0xfe9fffff]
> [    0.312440] pci_bus 0000:04: resource 2 [mem 0xc0400000-0xc05fffff 64bit pref]
> [    0.312442] pci_bus 0000:05: resource 0 [io  0xd000-0xdfff]
> [    0.312444] pci_bus 0000:05: resource 1 [mem 0xfea00000-0xfeafffff]
> [    0.312446] pci_bus 0000:05: resource 2 [mem 0xc0200000-0xc03fffff 64bit pref]
> [    0.312448] pci_bus 0000:06: resource 0 [io  0xe000-0xefff]
> [    0.312450] pci_bus 0000:06: resource 1 [mem 0xfeb00000-0xfebfffff]
> [    0.312452] pci_bus 0000:06: resource 2 [mem 0xc0000000-0xc01fffff 64bit pref]
> [    0.312455] pci_bus 0000:07: resource 4 [io  0x0000-0xffff]
> [    0.312457] pci_bus 0000:07: resource 5 [mem 0x00000000-0xfffffffff]
> [    0.312481] NET: Registered protocol family 2
> [    0.312518] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
> [    0.312616] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
> [    0.312960] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
> [    0.313071] TCP: Hash tables configured (established 131072 bind 65536)
> [    0.313073] TCP reno registered
> [    0.313076] UDP hash table entries: 512 (order: 2, 16384 bytes)
> [    0.313084] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
> [    0.313141] NET: Registered protocol family 1
> [    0.313158] pci 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [    0.313174] pci 0000:00:1a.0: PCI INT A disabled
> [    0.313186] pci 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
> [    0.313201] pci 0000:00:1a.1: PCI INT B disabled
> [    0.313208] pci 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
> [    0.313229] pci 0000:00:1a.7: PCI INT C disabled
> [    0.313248] pci 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
> [    0.313263] pci 0000:00:1d.0: PCI INT A disabled
> [    0.313272] pci 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
> [    0.313286] pci 0000:00:1d.1: PCI INT B disabled
> [    0.313292] pci 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
> [    0.313307] pci 0000:00:1d.2: PCI INT C disabled
> [    0.313313] pci 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
> [    0.313327] pci 0000:00:1d.3: PCI INT D disabled
> [    0.313335] pci 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
> [    0.313347] pci 0000:00:1d.7: PCI INT A disabled
> [    0.313369] pci 0000:01:00.0: Boot video device
> [    0.313382] PCI: CLS 32 bytes, default 64
> [    0.313436] Unpacking initramfs...
> [    0.654154] Freeing initrd memory: 15804k freed
> [    0.661058] apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
> [    0.661061] apm: disabled - APM is not SMP safe.
> [    0.661195] Intel AES-NI instructions are not detected.
> [    0.661331] audit: initializing netlink socket (disabled)
> [    0.661346] type=2000 audit(1332788680.661:1): initialized
> [    0.684746] highmem bounce pool size: 64 pages
> [    0.684750] HugeTLB registered 2 MB page size, pre-allocated 0 pages
> [    0.696126] VFS: Disk quotas dquot_6.5.2
> [    0.696180] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
> [    0.696691] msgmni has been set to 1678
> [    0.696750] SELinux:  Registering netfilter hooks
> [    0.697186] alg: No test for stdrng (krng)
> [    0.697200] NET: Registered protocol family 38
> [    0.697242] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
> [    0.697279] io scheduler noop registered
> [    0.697281] io scheduler deadline registered
> [    0.697287] io scheduler cfq registered (default)
> [    0.697505] pcieport 0000:00:01.0: setting latency timer to 64
> [    0.697535] pcieport 0000:00:01.0: irq 40 for MSI/MSI-X
> [    0.697599] pcieport 0000:00:1c.0: setting latency timer to 64
> [    0.697633] pcieport 0000:00:1c.0: irq 41 for MSI/MSI-X
> [    0.697721] pcieport 0000:00:1c.1: setting latency timer to 64
> [    0.697755] pcieport 0000:00:1c.1: irq 42 for MSI/MSI-X
> [    0.697842] pcieport 0000:00:1c.2: setting latency timer to 64
> [    0.697875] pcieport 0000:00:1c.2: irq 43 for MSI/MSI-X
> [    0.697964] pcieport 0000:00:1c.4: setting latency timer to 64
> [    0.697996] pcieport 0000:00:1c.4: irq 44 for MSI/MSI-X
> [    0.698103] pcieport 0000:00:1c.5: setting latency timer to 64
> [    0.698136] pcieport 0000:00:1c.5: irq 45 for MSI/MSI-X
> [    0.698254] pcieport 0000:00:01.0: Signaling PME through PCIe PME interrupt
> [    0.698257] pci 0000:01:00.0: Signaling PME through PCIe PME interrupt
> [    0.698260] pcie_pme 0000:00:01.0:pcie01: service driver pcie_pme loaded
> [    0.698276] pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
> [    0.698280] pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
> [    0.698296] pcieport 0000:00:1c.1: Signaling PME through PCIe PME interrupt
> [    0.698298] pci 0000:03:00.0: Signaling PME through PCIe PME interrupt
> [    0.698301] pcie_pme 0000:00:1c.1:pcie01: service driver pcie_pme loaded
> [    0.698317] pcieport 0000:00:1c.2: Signaling PME through PCIe PME interrupt
> [    0.698319] pci 0000:04:00.0: Signaling PME through PCIe PME interrupt
> [    0.698323] pcie_pme 0000:00:1c.2:pcie01: service driver pcie_pme loaded
> [    0.698338] pcieport 0000:00:1c.4: Signaling PME through PCIe PME interrupt
> [    0.698340] pci 0000:05:00.0: Signaling PME through PCIe PME interrupt
> [    0.698344] pcie_pme 0000:00:1c.4:pcie01: service driver pcie_pme loaded
> [    0.698360] pcieport 0000:00:1c.5: Signaling PME through PCIe PME interrupt
> [    0.698362] pci 0000:06:00.0: Signaling PME through PCIe PME interrupt
> [    0.698366] pcie_pme 0000:00:1c.5:pcie01: service driver pcie_pme loaded
> [    0.698385] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
> [    0.698435] pciehp 0000:00:1c.0:pcie04: HPC vendor_id 8086 device_id 2940 ss_vid 1462 ss_did 7360
> [    0.698453] pciehp 0000:00:1c.0:pcie04: service driver pciehp loaded
> [    0.698462] pciehp 0000:00:1c.1:pcie04: HPC vendor_id 8086 device_id 2942 ss_vid 1462 ss_did 7360
> [    0.698479] pciehp 0000:00:1c.1:pcie04: service driver pciehp loaded
> [    0.698488] pciehp 0000:00:1c.2:pcie04: HPC vendor_id 8086 device_id 2944 ss_vid 1462 ss_did 7360
> [    0.698505] pciehp 0000:00:1c.2:pcie04: service driver pciehp loaded
> [    0.698514] pciehp 0000:00:1c.4:pcie04: HPC vendor_id 8086 device_id 2948 ss_vid 1462 ss_did 7360
> [    0.698531] pciehp 0000:00:1c.4:pcie04: service driver pciehp loaded
> [    0.698541] pciehp 0000:00:1c.5:pcie04: HPC vendor_id 8086 device_id 294a ss_vid 1462 ss_did 7360
> [    0.698557] pciehp 0000:00:1c.5:pcie04: service driver pciehp loaded
> [    0.698566] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
> [    0.698568] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
> [    0.698871] intel_idle: MWAIT substates: 0x20
> [    0.698873] intel_idle: does not run on family 6 model 15
> [    0.698943] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
> [    0.698947] ACPI: Power Button [PWRB]
> [    0.698992] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
> [    0.698995] ACPI: Power Button [PWRF]
> [    0.700685] ERST: Table is not found!
> [    0.700687] GHES: HEST is not enabled!
> [    0.700700] isapnp: Scanning for PnP cards...
> [    1.056514] isapnp: No Plug & Play device found
> [    1.056602] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> [    1.077088] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> [    1.098724] 00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> [    1.107360] Non-volatile memory driver v1.3
> [    1.107362] Linux agpgart interface v0.103
> [    1.108483] loop: module loaded
> [    1.108543] ahci 0000:05:00.0: version 3.0
> [    1.108566] ata_piix 0000:00:1f.2: version 2.13
> [    1.108578] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
> [    1.108582] ata_piix 0000:00:1f.2: MAP [ P0 -- P1 -- ]
> [    1.108614] ata_piix 0000:00:1f.2: setting latency timer to 64
> [    1.108848] scsi0 : ata_piix
> [    1.108930] scsi1 : ata_piix
> [    1.110108] ata1: SATA max UDMA/133 cmd 0x9000 ctl 0x8c00 bmdma 0x8480 irq 19
> [    1.110112] ata2: SATA max UDMA/133 cmd 0x8880 ctl 0x8800 bmdma 0x8488 irq 19
> [    1.110129] ata_piix 0000:00:1f.5: PCI INT B -> GSI 19 (level, low) -> IRQ 19
> [    1.110136] ata_piix 0000:00:1f.5: MAP [ P0 -- P1 -- ]
> [    1.110179] ata_piix 0000:00:1f.5: setting latency timer to 64
> [    1.110404] scsi2 : ata_piix
> [    1.110484] scsi3 : ata_piix
> [    1.111539] ata3: SATA max UDMA/133 cmd 0x8000 ctl 0x7c00 bmdma 0x7480 irq 19
> [    1.111543] ata4: SATA max UDMA/133 cmd 0x7880 ctl 0x7800 bmdma 0x7488 irq 19
> [    1.111601] Fixed MDIO Bus: probed
> [    1.111668] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> [    1.111682] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
> [    1.111697] ehci_hcd 0000:00:1a.7: setting latency timer to 64
> [    1.111700] ehci_hcd 0000:00:1a.7: EHCI Host Controller
> [    1.111771] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
> [    1.111792] ehci_hcd 0000:00:1a.7: debug port 1
> [    1.115672] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
> [    1.115686] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xf9fffc00
> [    1.125019] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
> [    1.125038] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
> [    1.125040] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    1.125043] usb usb1: Product: EHCI Host Controller
> [    1.125044] usb usb1: Manufacturer: Linux 3.2.10-3.fc16.i686.PAE ehci_hcd
> [    1.125046] usb usb1: SerialNumber: 0000:00:1a.7
> [    1.125163] hub 1-0:1.0: USB hub found
> [    1.125167] hub 1-0:1.0: 4 ports detected
> [    1.125238] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
> [    1.125248] ehci_hcd 0000:00:1d.7: setting latency timer to 64
> [    1.125250] ehci_hcd 0000:00:1d.7: EHCI Host Controller
> [    1.125303] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
> [    1.125323] ehci_hcd 0000:00:1d.7: debug port 1
> [    1.129222] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
> [    1.129235] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xf9fff800
> [    1.139019] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
> [    1.139032] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
> [    1.139034] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    1.139036] usb usb2: Product: EHCI Host Controller
> [    1.139038] usb usb2: Manufacturer: Linux 3.2.10-3.fc16.i686.PAE ehci_hcd
> [    1.139040] usb usb2: SerialNumber: 0000:00:1d.7
> [    1.139148] hub 2-0:1.0: USB hub found
> [    1.139151] hub 2-0:1.0: 8 ports detected
> [    1.139230] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
> [    1.139243] uhci_hcd: USB Universal Host Controller Interface driver
> [    1.139258] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [    1.139265] uhci_hcd 0000:00:1a.0: setting latency timer to 64
> [    1.139267] uhci_hcd 0000:00:1a.0: UHCI Host Controller
> [    1.139321] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
> [    1.139350] uhci_hcd 0000:00:1a.0: irq 16, io base 0x00009c00
> [    1.139376] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
> [    1.139378] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    1.139380] usb usb3: Product: UHCI Host Controller
> [    1.139382] usb usb3: Manufacturer: Linux 3.2.10-3.fc16.i686.PAE uhci_hcd
> [    1.139384] usb usb3: SerialNumber: 0000:00:1a.0
> [    1.139491] hub 3-0:1.0: USB hub found
> [    1.139494] hub 3-0:1.0: 2 ports detected
> [    1.139560] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
> [    1.139566] uhci_hcd 0000:00:1a.1: setting latency timer to 64
> [    1.139569] uhci_hcd 0000:00:1a.1: UHCI Host Controller
> [    1.139622] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
> [    1.139650] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00009880
> [    1.139675] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
> [    1.139678] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    1.139680] usb usb4: Product: UHCI Host Controller
> [    1.139682] usb usb4: Manufacturer: Linux 3.2.10-3.fc16.i686.PAE uhci_hcd
> [    1.139684] usb usb4: SerialNumber: 0000:00:1a.1
> [    1.139788] hub 4-0:1.0: USB hub found
> [    1.139792] hub 4-0:1.0: 2 ports detected
> [    1.139858] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
> [    1.139864] uhci_hcd 0000:00:1d.0: setting latency timer to 64
> [    1.139867] uhci_hcd 0000:00:1d.0: UHCI Host Controller
> [    1.139918] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
> [    1.139938] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00009800
> [    1.139963] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
> [    1.139966] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    1.139968] usb usb5: Product: UHCI Host Controller
> [    1.139970] usb usb5: Manufacturer: Linux 3.2.10-3.fc16.i686.PAE uhci_hcd
> [    1.139972] usb usb5: SerialNumber: 0000:00:1d.0
> [    1.140081] hub 5-0:1.0: USB hub found
> [    1.140085] hub 5-0:1.0: 2 ports detected
> [    1.140154] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
> [    1.140160] uhci_hcd 0000:00:1d.1: setting latency timer to 64
> [    1.140163] uhci_hcd 0000:00:1d.1: UHCI Host Controller
> [    1.140224] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
> [    1.140246] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00009480
> [    1.140271] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
> [    1.140273] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    1.140275] usb usb6: Product: UHCI Host Controller
> [    1.140277] usb usb6: Manufacturer: Linux 3.2.10-3.fc16.i686.PAE uhci_hcd
> [    1.140279] usb usb6: SerialNumber: 0000:00:1d.1
> [    1.140380] hub 6-0:1.0: USB hub found
> [    1.140384] hub 6-0:1.0: 2 ports detected
> [    1.140447] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
> [    1.140453] uhci_hcd 0000:00:1d.2: setting latency timer to 64
> [    1.140456] uhci_hcd 0000:00:1d.2: UHCI Host Controller
> [    1.140509] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
> [    1.140529] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00009400
> [    1.140554] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
> [    1.140556] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    1.140558] usb usb7: Product: UHCI Host Controller
> [    1.140560] usb usb7: Manufacturer: Linux 3.2.10-3.fc16.i686.PAE uhci_hcd
> [    1.140562] usb usb7: SerialNumber: 0000:00:1d.2
> [    1.140661] hub 7-0:1.0: USB hub found
> [    1.140664] hub 7-0:1.0: 2 ports detected
> [    1.140728] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
> [    1.140734] uhci_hcd 0000:00:1d.3: setting latency timer to 64
> [    1.140737] uhci_hcd 0000:00:1d.3: UHCI Host Controller
> [    1.140788] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 8
> [    1.140808] uhci_hcd 0000:00:1d.3: irq 16, io base 0x00009080
> [    1.140833] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
> [    1.140835] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    1.140837] usb usb8: Product: UHCI Host Controller
> [    1.140839] usb usb8: Manufacturer: Linux 3.2.10-3.fc16.i686.PAE uhci_hcd
> [    1.140841] usb usb8: SerialNumber: 0000:00:1d.3
> [    1.140940] hub 8-0:1.0: USB hub found
> [    1.140943] hub 8-0:1.0: 2 ports detected
> [    1.141062] usbcore: registered new interface driver usbserial
> [    1.141070] USB Serial support registered for generic
> [    1.141083] usbcore: registered new interface driver usbserial_generic
> [    1.141085] usbserial: USB Serial Driver core
> [    1.141144] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
> [    1.143637] serio: i8042 KBD port at 0x60,0x64 irq 1
> [    1.143645] serio: i8042 AUX port at 0x60,0x64 irq 12
> [    1.143751] mousedev: PS/2 mouse device common for all mice
> [    1.143950] rtc_cmos 00:03: RTC can wake from S4
> [    1.144078] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
> [    1.144099] rtc0: alarms up to one month, y3k, 114 bytes nvram
> [    1.144161] device-mapper: uevent: version 1.0.3
> [    1.144236] device-mapper: ioctl: 4.22.0-ioctl (2011-10-19) initialised: dm-devel@redhat.com
> [    1.144281] cpuidle: using governor ladder
> [    1.144282] cpuidle: using governor menu
> [    1.144415] EFI Variables Facility v0.08 2004-May-17
> [    1.144571] usbcore: registered new interface driver usbhid
> [    1.144572] usbhid: USB HID core driver
> [    1.144620] ip_tables: (C) 2000-2006 Netfilter Core Team
> [    1.144632] TCP cubic registered
> [    1.144633] Initializing XFRM netlink socket
> [    1.144751] NET: Registered protocol family 10
> [    1.144865] Mobile IPv6
> [    1.144867] NET: Registered protocol family 17
> [    1.144881] Registering the dns_resolver key type
> [    1.144896] Using IPI No-Shortcut mode
> [    1.144998] PM: Hibernation image not present or could not be loaded.
> [    1.145019] registered taskstats version 1
> [    1.150403]   Magic number: 4:464:92
> [    1.150483] rtc_cmos 00:03: setting system clock to 2012-03-26 19:04:41 UTC (1332788681)
> [    1.151350] Initializing network drop monitor service
> [    1.162401] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
> [    1.426760] ata3: SATA link down (SStatus 0 SControl 300)
> [    1.516915] input: PS2++ Logitech Wheel Mouse as /devices/platform/i8042/serio1/input/input3
> [    1.566064] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [    1.566167] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [    1.577063] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    1.581172] ata4.00: ATA-7: Maxtor 7V250F0, VA111630, max UDMA/133
> [    1.581175] ata4.00: 490234752 sectors, multi 16: LBA48 NCQ (depth 0/32)
> [    1.582025] usb 4-1: new low-speed USB device number 2 using uhci_hcd
> [    1.588394] ata4.00: configured for UDMA/133
> [    1.609231] ata1.00: ATA-7: ST3320620AS, 3.AAJ, max UDMA/133
> [    1.609235] ata1.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 0/32)
> [    1.614032] ata2.00: ATA-7: ST3320620AS, 3.AAJ, max UDMA/133
> [    1.614037] ata2.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 0/32)
> [    1.662025] Refined TSC clocksource calibration: 2402.378 MHz.
> [    1.662030] Switching to clocksource tsc
> [    1.684197] ata1.00: configured for UDMA/133
> [    1.684353] scsi 0:0:0:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI: 5
> [    1.684564] sd 0:0:0:0: Attached scsi generic sg0 type 0
> [    1.684646] sd 0:0:0:0: [sda] 625142448 512-byte logical blocks: (320 GB/298 GiB)
> [    1.684744] sd 0:0:0:0: [sda] Write Protect is off
> [    1.684748] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [    1.684786] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    1.688994] ata2.00: configured for UDMA/133
> [    1.700155] scsi 1:0:0:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI: 5
> [    1.700331] sd 1:0:0:0: [sdb] 625142448 512-byte logical blocks: (320 GB/298 GiB)
> [    1.700361] sd 1:0:0:0: Attached scsi generic sg1 type 0
> [    1.700425] sd 1:0:0:0: [sdb] Write Protect is off
> [    1.700430] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
> [    1.700466] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    1.700545] scsi 3:0:0:0: Direct-Access     ATA      Maxtor 7V250F0   VA11 PQ: 0 ANSI: 5
> [    1.700723] sd 3:0:0:0: [sdc] 490234752 512-byte logical blocks: (251 GB/233 GiB)
> [    1.700788] sd 3:0:0:0: Attached scsi generic sg2 type 0
> [    1.700821] sd 3:0:0:0: [sdc] Write Protect is off
> [    1.700825] sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
> [    1.700857] sd 3:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    1.723901]  sda: sda1 sda2 sda3
> [    1.724349] sd 0:0:0:0: [sda] Attached SCSI disk
> [    1.727281]  sdc: sdc1
> [    1.727584] sd 3:0:0:0: [sdc] Attached SCSI disk
> [    1.728689]  sdb: sdb1 sdb2 sdb3
> [    1.729140] sd 1:0:0:0: [sdb] Attached SCSI disk
> [    1.729227] Freeing unused kernel memory: 644k freed
> [    1.729453] Write protecting the kernel text: 5408k
> [    1.729508] Write protecting the kernel read-only data: 2096k
> [    1.729512] NX-protecting the kernel data: 4832k
> [    1.769680] usb 4-1: New USB device found, idVendor=051d, idProduct=0002
> [    1.769685] usb 4-1: New USB device strings: Mfr=3, Product=1, SerialNumber=2
> [    1.769688] usb 4-1: Product: APC ES 725 FW:821.y2 .A USB FW:y2 
> [    1.769691] usb 4-1: Manufacturer: APC
> [    1.769694] usb 4-1: SerialNumber: 3B0628X18842  
> [    1.866691] dracut: dracut-013-20.fc16
> [    1.891672] udevd[123]: starting version 173
> [    1.969644] dracut: Starting plymouth daemon
> [    2.062877] sata_sil24 0000:03:00.0: version 1.1
> [    2.062903] sata_sil24 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> [    2.062960] sata_sil24 0000:03:00.0: setting latency timer to 64
> [    2.063039] pata_marvell 0000:05:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [    2.063072] pata_marvell 0000:05:00.0: setting latency timer to 64
> [    2.064056] scsi5 : pata_marvell
> [    2.064097] scsi4 : sata_sil24
> [    2.064155] scsi6 : pata_marvell
> [    2.064237] ata5: PATA max UDMA/100 cmd 0xdc00 ctl 0xd880 bmdma 0xd400 irq 16
> [    2.064240] ata6: PATA max UDMA/133 cmd 0xd800 ctl 0xd480 bmdma 0xd408 irq 16
> [    2.065350] scsi7 : sata_sil24
> [    2.065434] ata7: SATA max UDMA/100 host m128@0xfe8ffc00 port 0xfe8f8000 irq 17
> [    2.065438] ata8: SATA max UDMA/100 host m128@0xfe8ffc00 port 0xfe8fa000 irq 17
> [    2.065482] sata_sil24 0000:04:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
> [    2.065537] sata_sil24 0000:04:00.0: setting latency timer to 64
> [    2.066342] scsi8 : sata_sil24
> [    2.069138] scsi9 : sata_sil24
> [    2.069205] ata9: SATA max UDMA/100 host m128@0xfe9ffc00 port 0xfe9f8000 irq 18
> [    2.069210] ata10: SATA max UDMA/100 host m128@0xfe9ffc00 port 0xfe9fa000 irq 18
> [    2.218490] ata5.00: ATAPI: HL-DT-STDVD-RAM GSA-H58N, 1.03, max UDMA/66
> [    2.224448] ata5.00: configured for UDMA/66
> [    2.227062] scsi 5:0:0:0: CD-ROM            HL-DT-ST DVD-RAM GSA-H58N 1.03 PQ: 0 ANSI: 5
> [    2.229737] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
> [    2.229740] cdrom: Uniform CD-ROM driver Revision: 3.20
> [    2.229887] sr 5:0:0:0: Attached scsi CD-ROM sr0
> [    2.230037] sr 5:0:0:0: Attached scsi generic sg3 type 5
> [    2.240105] mdadm: sending ioctl 800c0910 to a partition!
> [    2.240109] mdadm: sending ioctl 800c0910 to a partition!
> [    2.240196] mdadm: sending ioctl 1261 to a partition!
> [    2.240198] mdadm: sending ioctl 1261 to a partition!
> [    2.243796] generic-usb 0003:051D:0002.0001: hiddev0,hidraw0: USB HID v1.10 Device [APC APC ES 725 FW:821.y2 .A USB FW:y2 ] on usb-0000:00:1a.1-1/input0
> [    2.260889] mdadm: sending ioctl 800c0910 to a partition!
> [    2.260892] mdadm: sending ioctl 800c0910 to a partition!
> [    2.260976] mdadm: sending ioctl 1261 to a partition!
> [    2.260978] mdadm: sending ioctl 1261 to a partition!
> [    2.269999] mdadm: sending ioctl 800c0910 to a partition!
> [    2.270020] mdadm: sending ioctl 800c0910 to a partition!
> [    2.294168] md: bind<sdb1>
> [    2.309289] md: bind<sdb2>
> [    2.311936] md: bind<sdb3>
> [    2.333658] md: bind<sda1>
> [    2.335596] md: raid1 personality registered for level 1
> [    4.085035] ata7: SATA link down (SStatus 0 SControl 0)
> [    4.201038] ata9: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [    4.201371] ata9.15: Port Multiplier 1.1, 0x1095:0x3726 r23, 6 ports, feat 0x1/0x9
> [    4.204304] ata9.00: hard resetting link
> [    4.542250] ata9.00: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
> [    4.542289] ata9.01: hard resetting link
> [    4.968018] ata9.01: softreset failed (SRST command error)
> [    4.968036] ata9.01: failed to read SCR 0 (Emask=0x40)
> [    4.968039] ata9.01: reset failed (errno=-85), retrying in 10 secs
> [    6.105031] ata8: SATA link down (SStatus 0 SControl 0)
> [   14.542045] ata9.01: reset failed, giving up
> [   14.542050] ata9.15: hard resetting link
> [   14.542053] ata9: controller in dubious state, performing PORT_RST
> [   16.696039] ata9.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [   16.696373] ata9.00: hard resetting link
> [   17.034255] ata9.00: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
> [   17.034291] ata9.01: hard resetting link
> [   17.372252] ata9.01: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [   17.372288] ata9.02: hard resetting link
> [   17.798016] ata9.02: softreset failed (SRST command error)
> [   17.908018] ata9.02: failed to read SCR 0 (Emask=0x1)
> [   17.908022] ata9.02: reset failed (errno=-85), retrying in 10 secs
> [   27.372093] ata9.02: reset failed, giving up
> [   27.372097] ata9.15: hard resetting link
> [   27.372100] ata9: controller in dubious state, performing PORT_RST
> [   29.526040] ata9.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [   29.526371] ata9.00: hard resetting link
> [   29.864252] ata9.00: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
> [   29.864289] ata9.01: hard resetting link
> [   30.202250] ata9.01: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [   30.202287] ata9.02: hard resetting link
> [   30.540251] ata9.02: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [   30.540289] ata9.03: hard resetting link
> [   30.966013] ata9.03: softreset failed (SRST command error)
> [   31.076018] ata9.03: failed to read SCR 0 (Emask=0x1)
> [   31.076022] ata9.03: reset failed (errno=-85), retrying in 10 secs
> [   40.540022] ata9.03: reset failed, giving up
> [   40.540027] ata9.15: hard resetting link
> [   40.540029] ata9: controller in dubious state, performing PORT_RST
> [   42.694040] ata9.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [   42.694389] ata9.00: hard resetting link
> [   43.032252] ata9.00: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
> [   43.032287] ata9.01: hard resetting link
> [   43.370251] ata9.01: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [   43.370286] ata9.02: hard resetting link
> [   43.708250] ata9.02: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [   43.708286] ata9.03: hard resetting link
> [   44.046253] ata9.03: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [   44.046289] ata9.04: hard resetting link
> [   44.351390] ata9.04: SATA link down (SStatus 0 SControl 320)
> [   44.351457] ata9.05: hard resetting link
> [   44.656361] ata9.05: SATA link up 1.5 Gbps (SStatus 113 SControl 320)
> [   44.685158] ata9.00: ATA-8: ST31500341AS, CC1H, max UDMA/133
> [   44.685163] ata9.00: 2930277168 sectors, multi 16: LBA48 NCQ (depth 31/32)
> [   44.727185] ata9.00: configured for UDMA/100
> [   44.755818] ata9.01: ATA-8: ST31500341AS, CC1H, max UDMA/133
> [   44.755822] ata9.01: 2930277168 sectors, multi 0: LBA48 NCQ (depth 31/32)
> [   44.797689] ata9.01: configured for UDMA/100
> [   44.826404] ata9.02: ATA-8: ST31500341AS, CC1H, max UDMA/133
> [   44.826409] ata9.02: 2930277168 sectors, multi 0: LBA48 NCQ (depth 31/32)
> [   44.868366] ata9.02: configured for UDMA/100
> [   44.897084] ata9.03: ATA-8: ST31500341AS, CC1H, max UDMA/133
> [   44.897089] ata9.03: 2930277168 sectors, multi 0: LBA48 NCQ (depth 31/32)
> [   44.939073] ata9.03: configured for UDMA/100
> [   44.939152] ata9: EH complete
> [   44.939284] scsi 8:0:0:0: Direct-Access     ATA      ST31500341AS     CC1H PQ: 0 ANSI: 5
> [   44.939460] sd 8:0:0:0: [sdd] 2930277168 512-byte logical blocks: (1.50 TB/1.36 TiB)
> [   44.939520] sd 8:0:0:0: Attached scsi generic sg4 type 0
> [   44.939531] sd 8:0:0:0: [sdd] Write Protect is off
> [   44.939535] sd 8:0:0:0: [sdd] Mode Sense: 00 3a 00 00
> [   44.939566] sd 8:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [   44.939691] scsi 8:1:0:0: Direct-Access     ATA      ST31500341AS     CC1H PQ: 0 ANSI: 5
> [   44.939917] sd 8:1:0:0: [sde] 2930277168 512-byte logical blocks: (1.50 TB/1.36 TiB)
> [   44.939957] sd 8:1:0:0: Attached scsi generic sg5 type 0
> [   44.939993] sd 8:1:0:0: [sde] Write Protect is off
> [   44.939997] sd 8:1:0:0: [sde] Mode Sense: 00 3a 00 00
> [   44.940049] sd 8:1:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [   44.940143] scsi 8:2:0:0: Direct-Access     ATA      ST31500341AS     CC1H PQ: 0 ANSI: 5
> [   44.940342] sd 8:2:0:0: [sdf] 2930277168 512-byte logical blocks: (1.50 TB/1.36 TiB)
> [   44.940426] sd 8:2:0:0: Attached scsi generic sg6 type 0
> [   44.940432] sd 8:2:0:0: [sdf] Write Protect is off
> [   44.940436] sd 8:2:0:0: [sdf] Mode Sense: 00 3a 00 00
> [   44.940479] sd 8:2:0:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [   44.940601] scsi 8:3:0:0: Direct-Access     ATA      ST31500341AS     CC1H PQ: 0 ANSI: 5
> [   44.940788] sd 8:3:0:0: [sdg] 2930277168 512-byte logical blocks: (1.50 TB/1.36 TiB)
> [   44.940843] sd 8:3:0:0: Attached scsi generic sg7 type 0
> [   44.940865] sd 8:3:0:0: [sdg] Write Protect is off
> [   44.940869] sd 8:3:0:0: [sdg] Mode Sense: 00 3a 00 00
> [   44.940899] sd 8:3:0:0: [sdg] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [   44.948903]  sdd: unknown partition table
> [   44.949128] sd 8:0:0:0: [sdd] Attached SCSI disk
> [   44.971385]  sdg: unknown partition table
> [   44.971540] sd 8:3:0:0: [sdg] Attached SCSI disk
> [   44.971596]  sde: unknown partition table
> [   44.971630]  sdf: unknown partition table
> [   44.971840] sd 8:2:0:0: [sdf] Attached SCSI disk
> [   44.971894] sd 8:1:0:0: [sde] Attached SCSI disk
> [   47.072046] ata10: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [   47.072428] ata10.15: Port Multiplier 1.1, 0x1095:0x3726 r23, 6 ports, feat 0x1/0x9
> [   47.075710] ata10.00: hard resetting link
> [   47.479256] ata10.00: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
> [   47.479296] ata10.01: hard resetting link
> [   47.905017] ata10.01: softreset failed (SRST command error)
> [   47.905035] ata10.01: failed to read SCR 0 (Emask=0x40)
> [   47.905039] ata10.01: reset failed (errno=-85), retrying in 10 secs
> [   57.479018] ata10.01: reset failed, giving up
> [   57.479023] ata10.15: hard resetting link
> [   57.479026] ata10: controller in dubious state, performing PORT_RST
> [   59.633039] ata10.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [   59.633480] ata10.00: hard resetting link
> [   60.037260] ata10.00: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
> [   60.037296] ata10.01: hard resetting link
> [   60.441258] ata10.01: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [   60.441293] ata10.02: hard resetting link
> [   60.867016] ata10.02: softreset failed (SRST command error)
> [   60.977018] ata10.02: failed to read SCR 0 (Emask=0x1)
> [   60.977022] ata10.02: reset failed (errno=-85), retrying in 10 secs
> [   70.441017] ata10.02: reset failed, giving up
> [   70.441023] ata10.15: hard resetting link
> [   70.441026] ata10: controller in dubious state, performing PORT_RST
> [   72.595047] ata10.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [   72.595436] ata10.00: hard resetting link
> [   72.999257] ata10.00: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
> [   72.999295] ata10.01: hard resetting link
> [   73.403258] ata10.01: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [   73.403296] ata10.02: hard resetting link
> [   73.807256] ata10.02: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [   73.807293] ata10.03: hard resetting link
> [   74.233017] ata10.03: softreset failed (SRST command error)
> [   74.343014] ata10.03: failed to read SCR 0 (Emask=0x1)
> [   74.343018] ata10.03: reset failed (errno=-85), retrying in 10 secs
> [   83.807022] ata10.03: reset failed, giving up
> [   83.807027] ata10.15: hard resetting link
> [   83.807030] ata10: controller in dubious state, performing PORT_RST
> [   85.961042] ata10.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [   85.961498] ata10.00: hard resetting link
> [   86.365267] ata10.00: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
> [   86.365303] ata10.01: hard resetting link
> [   86.769251] ata10.01: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [   86.769288] ata10.02: hard resetting link
> [   87.173252] ata10.02: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [   87.173287] ata10.03: hard resetting link
> [   87.577251] ata10.03: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [   87.577286] ata10.04: hard resetting link
> [   87.882390] ata10.04: SATA link down (SStatus 0 SControl 320)
> [   87.882457] ata10.05: hard resetting link
> [   88.187364] ata10.05: SATA link up 1.5 Gbps (SStatus 113 SControl 320)
> [   88.188237] ata10.00: ATA-8: Hitachi HDP725050GLA360, GM4OA50E, max UDMA/133
> [   88.188241] ata10.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
> [   88.189269] ata10.00: configured for UDMA/100
> [   88.210802] ata10.01: ATA-8: Hitachi HDP725050GLA360, GM4OA50E, max UDMA/133
> [   88.210807] ata10.01: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
> [   88.211684] ata10.01: configured for UDMA/100
> [   88.231774] ata10.02: ATA-8: Hitachi HDP725050GLA360, GM4OA50E, max UDMA/133
> [   88.231779] ata10.02: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
> [   88.232656] ata10.02: configured for UDMA/100
> [   88.242663] ata10.03: ATA-8: Hitachi HDP725050GLA360, GM4OA50E, max UDMA/133
> [   88.242668] ata10.03: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
> [   88.243540] ata10.03: configured for UDMA/100
> [   88.243611] ata10: EH complete
> [   88.243743] scsi 9:0:0:0: Direct-Access     ATA      Hitachi HDP72505 GM4O PQ: 0 ANSI: 5
> [   88.243940] sd 9:0:0:0: [sdh] 976773168 512-byte logical blocks: (500 GB/465 GiB)
> [   88.243985] sd 9:0:0:0: Attached scsi generic sg8 type 0
> [   88.244033] sd 9:0:0:0: [sdh] Write Protect is off
> [   88.244037] sd 9:0:0:0: [sdh] Mode Sense: 00 3a 00 00
> [   88.244071] sd 9:0:0:0: [sdh] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [   88.244166] scsi 9:1:0:0: Direct-Access     ATA      Hitachi HDP72505 GM4O PQ: 0 ANSI: 5
> [   88.244348] sd 9:1:0:0: [sdi] 976773168 512-byte logical blocks: (500 GB/465 GiB)
> [   88.244429] sd 9:1:0:0: Attached scsi generic sg9 type 0
> [   88.244435] sd 9:1:0:0: [sdi] Write Protect is off
> [   88.244440] sd 9:1:0:0: [sdi] Mode Sense: 00 3a 00 00
> [   88.244471] sd 9:1:0:0: [sdi] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [   88.244619] scsi 9:2:0:0: Direct-Access     ATA      Hitachi HDP72505 GM4O PQ: 0 ANSI: 5
> [   88.244876] sd 9:2:0:0: [sdj] 976773168 512-byte logical blocks: (500 GB/465 GiB)
> [   88.244926] sd 9:2:0:0: Attached scsi generic sg10 type 0
> [   88.244942] sd 9:2:0:0: [sdj] Write Protect is off
> [   88.244946] sd 9:2:0:0: [sdj] Mode Sense: 00 3a 00 00
> [   88.244976] sd 9:2:0:0: [sdj] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [   88.245109] scsi 9:3:0:0: Direct-Access     ATA      Hitachi HDP72505 GM4O PQ: 0 ANSI: 5
> [   88.245299] sd 9:3:0:0: [sdk] 976773168 512-byte logical blocks: (500 GB/465 GiB)
> [   88.245347] sd 9:3:0:0: Attached scsi generic sg11 type 0
> [   88.245388] sd 9:3:0:0: [sdk] Write Protect is off
> [   88.245392] sd 9:3:0:0: [sdk] Mode Sense: 00 3a 00 00
> [   88.245422] sd 9:3:0:0: [sdk] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [   88.253550]  sdh: unknown partition table
> [   88.253774] sd 9:0:0:0: [sdh] Attached SCSI disk
> [   88.278785]  sdi: unknown partition table
> [   88.278793]  sdj: unknown partition table
> [   88.278994] sd 9:1:0:0: [sdi] Attached SCSI disk
> [   88.279011] sd 9:2:0:0: [sdj] Attached SCSI disk
> [   88.279047]  sdk: unknown partition table
> [   88.279188] sd 9:3:0:0: [sdk] Attached SCSI disk
> [   88.279481] bio: create slab <bio-1> at 1
> [   88.279749] md/raid1:md0: active with 2 out of 2 mirrors
> [   88.279779] md0: detected capacity change from 0 to 314507264
> [   88.298379]  md0:
> [   88.299814] scsi_verify_blk_ioctl: 126 callbacks suppressed
> [   88.299816] mdadm: sending ioctl 1261 to a partition!
> [   88.299818] mdadm: sending ioctl 1261 to a partition!
> [   88.314219] md: bind<sdd>
> [   88.358298] mdadm: sending ioctl 1261 to a partition!
> [   88.358302] mdadm: sending ioctl 1261 to a partition!
> [   88.364485] md: bind<sdg>
> [   88.368526] md: bind<sde>
> [   88.372132] md: bind<sdf>
> [   88.375045] async_tx: api initialized (async)
> [   88.375392] xor: automatically using best checksumming function: pIII_sse
> [   88.380003]    pIII_sse  :  8512.000 MB/sec
> [   88.380006] xor: using function: pIII_sse (8512.000 MB/sec)
> [   88.385342] mdadm: sending ioctl 1261 to a partition!
> [   88.385345] mdadm: sending ioctl 1261 to a partition!
> [   88.397062] raid6: int32x1    902 MB/s
> [   88.414047] raid6: int32x2    714 MB/s
> [   88.431056] raid6: int32x4    628 MB/s
> [   88.448080] raid6: int32x8    710 MB/s
> [   88.465008] raid6: mmxx1     2808 MB/s
> [   88.482020] raid6: mmxx2     3097 MB/s
> [   88.499006] raid6: sse1x1    1847 MB/s
> [   88.516015] raid6: sse1x2    2453 MB/s
> [   88.533010] raid6: sse2x1    3453 MB/s
> [   88.550004] raid6: sse2x2    4429 MB/s
> [   88.550006] raid6: using algorithm sse2x2 (4429 MB/s)
> [   88.550830] md: raid6 personality registered for level 6
> [   88.550832] md: raid5 personality registered for level 5
> [   88.550834] md: raid4 personality registered for level 4
> [   88.550967] md/raid:md6: device sdf operational as raid disk 2
> [   88.550969] md/raid:md6: device sde operational as raid disk 1
> [   88.550971] md/raid:md6: device sdg operational as raid disk 3
> [   88.550972] md/raid:md6: device sdd operational as raid disk 0
> [   88.551326] md/raid:md6: allocated 4216kB
> [   88.551359] md/raid:md6: raid level 5 active with 4 out of 4 devices, algorithm 2
> [   88.551360] RAID conf printout:
> [   88.551362]  --- level:5 rd:4 wd:4
> [   88.551363]  disk 0, o:1, dev:sdd
> [   88.551365]  disk 1, o:1, dev:sde
> [   88.551366]  disk 2, o:1, dev:sdf
> [   88.551368]  disk 3, o:1, dev:sdg
> [   88.551395] md6: detected capacity change from 0 to 4500897595392
> [   88.553042]  md6: unknown partition table
> [   88.553991] md: bind<sdi>
> [   88.557237] md: bind<sdh>
> [   88.560872] md: bind<sdk>
> [   88.564958] md: bind<sdj>
> [   88.567708] md/raid:md7: device sdj operational as raid disk 2
> [   88.567712] md/raid:md7: device sdk operational as raid disk 3
> [   88.567715] md/raid:md7: device sdh operational as raid disk 1
> [   88.567718] md/raid:md7: device sdi operational as raid disk 0
> [   88.568182] md/raid:md7: allocated 4216kB
> [   88.568216] md/raid:md7: raid level 5 active with 4 out of 4 devices, algorithm 2
> [   88.568218] RAID conf printout:
> [   88.568221]  --- level:5 rd:4 wd:4
> [   88.568223]  disk 0, o:1, dev:sdi
> [   88.568226]  disk 1, o:1, dev:sdh
> [   88.568228]  disk 2, o:1, dev:sdj
> [   88.568230]  disk 3, o:1, dev:sdk
> [   88.568263] md7: detected capacity change from 0 to 1500315451392
> [   88.569634]  md7: unknown partition table
> [   88.593009] mdadm: sending ioctl 1261 to a partition!
> [   88.593012] mdadm: sending ioctl 1261 to a partition!
> [  100.905944] md/raid1:md1: active with 1 out of 2 mirrors
> [  100.905973] md1: detected capacity change from 0 to 311163576320
> [  100.908115] dracut: mdadm: started /dev/md1
> [  100.912649]  md1: unknown partition table
> [  100.915000] mdadm: sending ioctl 1261 to a partition!
> [  100.915014] mdadm: sending ioctl 1261 to a partition!
> [  100.922165] md/raid1:md2: active with 1 out of 2 mirrors
> [  100.922198] md2: detected capacity change from 0 to 8589869056
> [  100.924335] dracut: mdadm: started /dev/md2
> [  100.945689]  md2: unknown partition table
> [  100.947251] mdadm: sending ioctl 1261 to a partition!
> [  100.947254] mdadm: sending ioctl 1261 to a partition!
> [  101.059473] mdadm: sending ioctl 1261 to a partition!
> [  101.059476] mdadm: sending ioctl 1261 to a partition!
> [  101.116097] mdadm: sending ioctl 1261 to a partition!
> [  101.116101] mdadm: sending ioctl 1261 to a partition!
> [  101.295531] EXT4-fs (md1): mounted filesystem with ordered data mode. Opts: (null)
> [  101.409863] dracut: Checking ext4: /dev/disk/by-uuid/773cb4b3-4bb0-4705-b494-08cb9c2b5d73
> [  101.409938] dracut: issuing e2fsck -a   /dev/disk/by-uuid/773cb4b3-4bb0-4705-b494-08cb9c2b5d73
> [  101.513095] dracut: /dev/disk/by-uuid/773cb4b3-4bb0-4705-b494-08cb9c2b5d73: clean, 325251/18997248 files, 4803664/75967670 blocks
> [  101.513374] dracut: Remounting /dev/disk/by-uuid/773cb4b3-4bb0-4705-b494-08cb9c2b5d73 with -o ro
> [  101.515482] mdadm: sending ioctl 1261 to a partition!
> [  101.515485] mdadm: sending ioctl 1261 to a partition!
> [  101.628453] EXT4-fs (md1): mounted filesystem with ordered data mode. Opts: (null)
> [  101.648720] dracut: Mounted root filesystem /dev/md1
> [  101.898107] dracut: Switching root
> [  102.366666] SELinux:  Disabled at runtime.
> [  102.366691] SELinux:  Unregistering netfilter hooks
> [  102.369100] type=1404 audit(1332788782.717:2): selinux=0 auid=4294967295 ses=4294967295
> [  102.427531] systemd[1]: RTC configured in localtime, applying delta of 540 minutes to system time.
> [  102.496195] systemd[1]: systemd 37 running in system mode. (+PAM +LIBWRAP +AUDIT +SELINUX +SYSVINIT +LIBCRYPTSETUP; fedora)
> [  102.520096] systemd[1]: Set hostname to <server3>.
> [  104.012246] EXT4-fs (md1): re-mounted. Opts: (null)
> [  104.582180] RPC: Registered named UNIX socket transport module.
> [  104.582182] RPC: Registered udp transport module.
> [  104.582184] RPC: Registered tcp transport module.
> [  104.582185] RPC: Registered tcp NFSv4.1 backchannel transport module.
> [  104.720818] udevd[797]: starting version 173
> [  104.841392] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
> [  105.677974] iTCO_vendor_support: vendor-support=0
> [  105.878333] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.07
> [  105.878413] iTCO_wdt: Found a ICH9 TCO device (Version=2, TCOBASE=0x0860)
> [  105.878477] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
> [  105.896657] microcode: CPU0 sig=0x6fb, pf=0x10, revision=0x0
> [  105.987632] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
> [  105.987656] r8169 0000:06:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> [  105.987682] r8169 0000:06:00.0: setting latency timer to 64
> [  105.987750] r8169 0000:06:00.0: irq 46 for MSI/MSI-X
> [  105.987895] r8169 0000:06:00.0: eth0: RTL8168b/8111b at 0xf7e3c000, 00:1d:92:70:a3:96, XID 18000000 IRQ 46
> [  105.987898] r8169 0000:06:00.0: eth0: jumbo features [frames: 4080 bytes, tx checksumming: ko]
> [  106.102002] microcode: CPU0 updated to revision 0xba, date = 2010-10-03
> [  106.107091] microcode: CPU1 sig=0x6fb, pf=0x10, revision=0x0
> [  106.109515] microcode: CPU1 updated to revision 0xba, date = 2010-10-03
> [  106.114164] microcode: CPU2 sig=0x6fb, pf=0x10, revision=0x0
> [  106.116003] microcode: CPU2 updated to revision 0xba, date = 2010-10-03
> [  106.121407] microcode: CPU3 sig=0x6fb, pf=0x10, revision=0x0
> [  106.123880] microcode: CPU3 updated to revision 0xba, date = 2010-10-03
> [  106.128492] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
> [  106.136321] i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level, low) -> IRQ 18
> [  106.377968] parport_pc 00:07: reported by Plug and Play ACPI
> [  106.378026] parport0: PC-style at 0x378, irq 7 [PCSPP]
> [  106.413605] mtp-probe[971]: checking bus 4, device 2: "/sys/devices/pci0000:00/0000:00:1a.1/usb4/4-1"
> [  106.529978] ppdev: user-space parallel port driver
> [  106.535851] snd_hda_intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
> [  106.535895] snd_hda_intel 0000:00:1b.0: irq 47 for MSI/MSI-X
> [  106.535921] snd_hda_intel 0000:00:1b.0: setting latency timer to 64
> [  106.593022] hda_codec: ALC888: BIOS auto-probing.
> [  106.593027] ALSA sound/pci/hda/patch_realtek.c:1275 SKU: Nid=0x1d sku_cfg=0x4007f603
> [  106.593029] ALSA sound/pci/hda/patch_realtek.c:1277 SKU: port_connectivity=0x1
> [  106.593031] ALSA sound/pci/hda/patch_realtek.c:1278 SKU: enable_pcbeep=0x0
> [  106.593034] ALSA sound/pci/hda/patch_realtek.c:1279 SKU: check_sum=0x00000007
> [  106.593036] ALSA sound/pci/hda/patch_realtek.c:1280 SKU: customization=0x000000f6
> [  106.593038] ALSA sound/pci/hda/patch_realtek.c:1281 SKU: external_amp=0x0
> [  106.593040] ALSA sound/pci/hda/patch_realtek.c:1282 SKU: platform_type=0x0
> [  106.593042] ALSA sound/pci/hda/patch_realtek.c:1283 SKU: swap=0x1
> [  106.593043] ALSA sound/pci/hda/patch_realtek.c:1284 SKU: override=0x1
> [  106.593049] ALSA sound/pci/hda/hda_codec.c:4955 autoconfig: line_outs=4 (0x14/0x15/0x16/0x17/0x0) type:line
> [  106.593051] ALSA sound/pci/hda/hda_codec.c:4959    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
> [  106.593054] ALSA sound/pci/hda/hda_codec.c:4963    hp_outs=1 (0x1b/0x0/0x0/0x0/0x0)
> [  106.593056] ALSA sound/pci/hda/hda_codec.c:4964    mono: mono_out=0x0
> [  106.593058] ALSA sound/pci/hda/hda_codec.c:4967    dig-out=0x1e/0x0
> [  106.593060] ALSA sound/pci/hda/hda_codec.c:4968    inputs:
> [  106.593062] ALSA sound/pci/hda/hda_codec.c:4972  Rear Mic=0x18
> [  106.593065] ALSA sound/pci/hda/hda_codec.c:4972  Front Mic=0x19
> [  106.593067] ALSA sound/pci/hda/hda_codec.c:4972  Line=0x1a
> [  106.593069] ALSA sound/pci/hda/hda_codec.c:4974 
> [  106.595394] ALSA sound/pci/hda/patch_realtek.c:1338 realtek: No valid SSID, checking pincfg 0x4007f603 for NID 0x1d
> [  106.595397] ALSA sound/pci/hda/patch_realtek.c:1354 realtek: Enabling init ASM_ID=0xf603 CODEC_ID=10ec0888
> [  106.606845] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input4
> [  106.635154] mtp-probe[971]: bus: 4, device: 2 was not an MTP device
> [  106.903881] scsi_verify_blk_ioctl: 2 callbacks suppressed
> [  106.903884] mdadm: sending ioctl 1261 to a partition!
> [  106.903886] mdadm: sending ioctl 1261 to a partition!
> [  106.904814] mdadm: sending ioctl 1261 to a partition!
> [  106.904816] mdadm: sending ioctl 1261 to a partition!
> [  106.905233] mdadm: sending ioctl 1261 to a partition!
> [  106.905236] mdadm: sending ioctl 1261 to a partition!
> [  107.192862] mdadm: sending ioctl 800c0910 to a partition!
> [  107.192865] mdadm: sending ioctl 800c0910 to a partition!
> [  107.192871] mdadm: sending ioctl 1261 to a partition!
> [  107.192873] mdadm: sending ioctl 1261 to a partition!
> [  107.575565] nvidia: module license 'NVIDIA' taints kernel.
> [  107.575568] Disabling lock debugging due to kernel taint
> [  107.878753] nvidia 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [  107.878765] nvidia 0000:01:00.0: setting latency timer to 64
> [  107.878770] vgaarb: device changed decodes: PCI:0000:01:00.0,olddecodes=io+mem,decodes=none:owns=io+mem
> [  107.878950] NVRM: loading NVIDIA UNIX x86 Kernel Module  290.10  Wed Nov 16 19:27:25 PST 2011
> [  107.981636] Adding 8388540k swap on /dev/md2.  Priority:0 extents:1 across:8388540k 
> [  108.641751] systemd-fsck[1208]: /dev/md0: clean, 263/76304 files, 154648/307136 blocks
> [  108.683700] systemd-fsck[1158]: RAID5_0: clean, 1971/274718720 files, 825477773/1098851952 blocks
> [  108.850706] systemd-fsck[1191]: /dev/sdc1: clean, 103/15327232 files, 25440488/61277926 blocks (check in 3 mounts)
> [  108.868638] EXT4-fs (md0): mounting ext3 file system using the ext4 subsystem
> [  108.878625] EXT4-fs (md0): mounted filesystem with ordered data mode. Opts: (null)
> [  108.949111] systemd-fsck[1162]: EXCHANGE: clean, 151350/183156736 files, 228850362/366287952 blocks
> [  108.982476] EXT4-fs (sdc1): mounted filesystem with ordered data mode. Opts: (null)
> [  109.157712] EXT4-fs (md7): mounted filesystem with ordered data mode. Opts: (null)
> [  109.278467] EXT4-fs (md6): mounted filesystem with ordered data mode. Opts: (null)
> [  109.826668] fedora-storage-init[1224]: \xffffffe8\xffffffab\xffffff96\xffffffab\xffffff96\xffffffe7\xffffff90\xffffff86\xffffff90\xffffff86\xffffffe3\xffffff83\xffffff9c\xffffff83\xffffff9c\xffffffe3\xffffff83\xffffffaa\xffffff83\xffffffaa\xffffffe3\xffffff83\xffffffa5\xffffff83\xffffffa5\xffffffe3\xffffff83\xffffffbc\xffffff83\xffffffbc\xffffffe3\xffffff83\xffffffa0\xffffff83\xffffffa0\xffffffe7\xffffffae\xffffffa1\xffffffae\xffffffa1\xffffffe7\xffffff90\xffffff86\xffffff90\xffffff86\xffffffe3\xffffff82\xffffff92\xffffff82\xffffff92\xffffffe8\xffffffa8\xffffffad\xffffffa8\xffffffad\xffffffe5\xffffffae\xffffff9a\xffffffae\xffffff9a\xffffffe4\xffffffb8\xffffffad\xffffffb8\xffffffad:   No volume groups found
> [  109.827119] fedora-storage-init[1224]: [  OK  ]
> [  110.047199] fedora-storage-init[1267]: \xffffffe8\xffffffab\xffffff96\xffffffab\xffffff96\xffffffe7\xffffff90\xffffff86\xffffff90\xffffff86\xffffffe3\xffffff83\xffffff9c\xffffff83\xffffff9c\xffffffe3\xffffff83\xffffffaa\xffffff83\xffffffaa\xffffffe3\xffffff83\xffffffa5\xffffff83\xffffffa5\xffffffe3\xffffff83\xffffffbc\xffffff83\xffffffbc\xffffffe3\xffffff83\xffffffa0\xffffff83\xffffffa0\xffffffe7\xffffffae\xffffffa1\xffffffae\xffffffa1\xffffffe7\xffffff90\xffffff86\xffffff90\xffffff86\xffffffe3\xffffff82\xffffff92\xffffff82\xffffff92\xffffffe8\xffffffa8\xffffffad\xffffffa8\xffffffad\xffffffe5\xffffffae\xffffff9a\xffffffae\xffffff9a\xffffffe4\xffffffb8\xffffffad\xffffffb8\xffffffad:   No volume groups found
> [  110.047820] fedora-storage-init[1267]: [  OK  ]
> [  110.246400] lvm[1274]: No volume groups found
> [  112.320113] ntpd[1320]: ntpd 4.2.6p4@1.2324-o Thu Oct  6 15:37:56 UTC 2011 (1)
> [  112.344874] ntpd[1320]: proto: precision = 0.393 usec
> [  112.344880] ntpd[1320]: 0.0.0.0 c01d 0d kern kernel time sync enabled
> [  113.173142] systemd[1]: nscd.service: Supervising process 1378 which is not our child. We'll most likely not notice when it exits.
> [  117.556889] r8169 0000:06:00.0: eth0: link down
> [  117.556895] r8169 0000:06:00.0: eth0: link down
> [  117.557053] ADDRCONF(NETDEV_UP): eth0: link is not ready
> [  119.924279] r8169 0000:06:00.0: eth0: link up
> [  119.924424] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
> [  123.802802] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
> [  123.821298] NFSD: starting 90-second grace period
> [  147.021977] hda-intel: IRQ timing workaround is activated for card #0. Suggest a bigger bdl_pos_adj.
> [  162.662480] fuse init (API version 7.17)
> [  164.794923] Bluetooth: Core ver 2.16
> [  164.794947] NET: Registered protocol family 31
> [  164.794949] Bluetooth: HCI device and connection manager initialized
> [  164.794951] Bluetooth: HCI socket layer initialized
> [  164.794953] Bluetooth: L2CAP socket layer initialized
> [  164.794957] Bluetooth: SCO socket layer initialized
> [  164.834501] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
> [  164.834504] Bluetooth: BNEP filters: protocol multicast
> [  169.671853] FS-Cache: Loaded
> [  169.696998] FS-Cache: Netfs 'nfs' registered for caching
------

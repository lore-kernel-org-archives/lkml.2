Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327Ab2C2GJj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 02:09:39 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56113 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513Ab2C2GI7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 02:08:59 -0400
MIME-Version: 1.0
In-Reply-To: <4F72A1C5.8070704@yahoo.co.jp>
References: <4F5ECD06.3000608@yahoo.co.jp>
	<4F5F7C4C.7080800@teksavvy.com>
	<4F662AFB.9050106@yahoo.co.jp>
	<CAMHSBOWg+rxxrVjf05r1tYDpW1S75XzdrLQ+U8TrjC9okRYtuA@mail.gmail.com>
	<4F6AAC37.7040907@yahoo.co.jp>
	<4F6B30D9.2070805@yahoo.co.jp>
	<CAMHSBOVD4wAtwAravVkDjyWV+Nwtuybt=yae=26PcGxxirw=Lg@mail.gmail.com>
	<4F6B679C.60004@yahoo.co.jp>
	<CAMHSBOWDYyLRREZNGqhBtvF_gSrvB-b=PVx3qULCqpc7yeJCcQ@mail.gmail.com>
	<4F6C1AE5.5060405@yahoo.co.jp>
	<CAMHSBOXuX1U8uPyN136AQ_LRW85Ex8EUu1-_hdBqnSMtdmg+0Q@mail.gmail.com>
	<4F6C4967.80309@yahoo.co.jp>
	<4F6E728A.3090203@yahoo.co.jp>
	<CAMHSBOVtj8pXVtSK7qUmzSzXTCJWTK6-m7ZY6TB3gj-dT70ptw@mail.gmail.com>
	<4F6FBB3E.8060409@yahoo.co.jp>
	<4F6FD4CD.5040608@yahoo.co.jp>
	<4F703BEB.1040309@yahoo.co.jp>
	<4F70527A.4000005@world.odn.ne.jp>
	<CAMHSBOWOLj0igQYK16qQ+BznzmS2KV89dw4ahRz0h5tUw+YOdQ@mail.gmail.com>
	<4F72A1C5.8070704@yahoo.co.jp>
Date: Thu, 29 Mar 2012 14:08:57 +0800
Message-ID: <CAMHSBOVaswiCg4WisCLMWkqndixM54wzN6Gwn1bTaKKLsCk1Yg@mail.gmail.com>
Subject: Re: Fwd: libata-pmp patch for 3.2.x and later for eSATA Port
 Multiplier Sil3726
From: Gwendal Grignou <gwendal@google.com>
To: "ANEZAKI, Akira" <fireblade1230@yahoo.co.jp>
Cc: "IDE/ATA development list" <linux-ide@vger.kernel.org>,
        Mark Lord <kernel@teksavvy.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Jeff Garzik <jgarzik@pobox.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2012 at 1:29 PM, ANEZAKI, Akira
<fireblade1230@yahoo.co.jp> wrote:
> Hello Gwendal,
>
> (2012/03/27 20:17), Gwendal Grignou wrote:
>> Regarding the machine with 10 disks, I see that all the drives have
>> been found; I don't see any other error from the /var/log/messages
>> snippet that could explain md not finding the volumes.
>
> I have attached 11 disks log. RAID1 is not assembled. Both of md1 and
> md2 were not assembled. md1 is root partition.
>From your original post md1 is composed of sda2 and sdb2. Both disks
are not behind a PMP, so it is different problem.

Gwendal.
>
> Best Regards,
> Akira
>
> --- 3.2.10 2pmp power cycle error on root ---
>> [    0.000000] Initializing cgroup subsys cpuset
>> [    0.000000] Initializing cgroup subsys cpu
>> [    0.000000] Linux version 3.2.10-3.fc16.i686.PAE (mockbuild@x86-02.phx2.fedoraproject.org) (gcc version 4.6.2 20111027 (Red Hat 4.6.2-1) (GCC) ) #1 SMP Thu Mar 15 20:37:01 UTC 2012
>> [    0.000000] BIOS-provided physical RAM map:
>> [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009b800 (usable)
>> [    0.000000]  BIOS-e820: 000000000009b800 - 00000000000a0000 (reserved)
>> [    0.000000]  BIOS-e820: 00000000000e3000 - 0000000000100000 (reserved)
>> [    0.000000]  BIOS-e820: 0000000000100000 - 00000000bffb0000 (usable)
>> [    0.000000]  BIOS-e820: 00000000bffb0000 - 00000000bffbe000 (ACPI data)
>> [    0.000000]  BIOS-e820: 00000000bffbe000 - 00000000bfff0000 (ACPI NVS)
>> [    0.000000]  BIOS-e820: 00000000bfff0000 - 00000000c0000000 (reserved)
>> [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
>> [    0.000000]  BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
>> [    0.000000] NX (Execute Disable) protection: active
>> [    0.000000] DMI present.
>> [    0.000000] DMI: MICRO-STAR INTERNATIONAL CO.,LTD MS-7360/MS-7360, BIOS V1.AB2 05/28/2007
>> [    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
>> [    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
>> [    0.000000] last_pfn = 0xbffb0 max_arch_pfn = 0x1000000
>> [    0.000000] MTRR default type: uncachable
>> [    0.000000] MTRR fixed ranges enabled:
>> [    0.000000]   00000-9FFFF write-back
>> [    0.000000]   A0000-BFFFF uncachable
>> [    0.000000]   C0000-CFFFF write-protect
>> [    0.000000]   D0000-DFFFF uncachable
>> [    0.000000]   E0000-EFFFF write-through
>> [    0.000000]   F0000-FFFFF write-protect
>> [    0.000000] MTRR variable ranges enabled:
>> [    0.000000]   0 base 000000000 mask F80000000 write-back
>> [    0.000000]   1 base 080000000 mask FC0000000 write-back
>> [    0.000000]   2 disabled
>> [    0.000000]   3 disabled
>> [    0.000000]   4 disabled
>> [    0.000000]   5 disabled
>> [    0.000000]   6 disabled
>> [    0.000000]   7 disabled
>> [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
>> [    0.000000] found SMP MP-table at [c00ff780] ff780
>> [    0.000000] initial memory mapped : 0 - 01200000
>> [    0.000000] Base memory trampoline at [c0097000] 97000 size 16384
>> [    0.000000] init_memory_mapping: 0000000000000000-00000000375fe000
>> [    0.000000]  0000000000 - 0000200000 page 4k
>> [    0.000000]  0000200000 - 0037400000 page 2M
>> [    0.000000]  0037400000 - 00375fe000 page 4k
>> [    0.000000] kernel direct mapping tables up to 375fe000 @ 11f8000-1200000
>> [    0.000000] RAMDISK: 37081000 - 37ff0000
>> [    0.000000] Allocated new RAMDISK: 36112000 - 37080e5b
>> [    0.000000] Move RAMDISK from 0000000037081000 - 0000000037fefe5a to 36112000 - 37080e5a
>> [    0.000000] ACPI: RSDP 000f95c0 00014 (v00 ACPIAM)
>> [    0.000000] ACPI: RSDT bffb0000 00044 (v01 Mouse  Computer 20070528 MSFT 00000097)
>> [    0.000000] ACPI: FACP bffb0200 00084 (v01 052807 FACP1414 20070528 MSFT 00000097)
>> [    0.000000] ACPI: DSDT bffb05c0 05564 (v01  0AAAA 0AAAA000 00000000 INTL 20051117)
>> [    0.000000] ACPI: FACS bffbe000 00040
>> [    0.000000] ACPI: APIC bffb0390 0006C (v01 052807 APIC1414 20070528 MSFT 00000097)
>> [    0.000000] ACPI: MCFG bffb0400 0003C (v01 052807 OEMMCFG  20070528 MSFT 00000097)
>> [    0.000000] ACPI: SLIC bffb0440 00176 (v01 Mouse  Computer 20070528 MSFT 00000097)
>> [    0.000000] ACPI: SLIC bffb0440 00176 (v01 Mouse  Computer 20070528 MSFT 00000097)
>> [    0.000000] ACPI: OEMB bffbe040 00071 (v01 052807 OEMB1414 20070528 MSFT 00000097)
>> [    0.000000] ACPI: GSCI bffbe0c0 02024 (v01 052807 GMCHSCI  20070528 MSFT 00000097)
>> [    0.000000] ACPI: SSDT bffc1330 0082F (v01 DpgPmm    CpuPm 00000012 INTL 20051117)
>> [    0.000000] ACPI: Local APIC address 0xfee00000
>> [    0.000000] 2185MB HIGHMEM available.
>> [    0.000000] 885MB LOWMEM available.
>> [    0.000000]   mapped low ram: 0 - 375fe000
>> [    0.000000]   low ram: 0 - 375fe000
>> [    0.000000] Zone PFN ranges:
>> [    0.000000]   DMA      0x00000010 -> 0x00001000
>> [    0.000000]   Normal   0x00001000 -> 0x000375fe
>> [    0.000000]   HighMem  0x000375fe -> 0x000bffb0
>> [    0.000000] Movable zone start PFN for each node
>> [    0.000000] early_node_map[2] active PFN ranges
>> [    0.000000]     0: 0x00000010 -> 0x0000009b
>> [    0.000000]     0: 0x00000100 -> 0x000bffb0
>> [    0.000000] On node 0 totalpages: 786235
>> [    0.000000] free_area_init_node: node 0, pgdat c0bb3bc0, node_mem_map f4912200
>> [    0.000000]   DMA zone: 32 pages used for memmap
>> [    0.000000]   DMA zone: 0 pages reserved
>> [    0.000000]   DMA zone: 3947 pages, LIFO batch:0
>> [    0.000000]   Normal zone: 1740 pages used for memmap
>> [    0.000000]   Normal zone: 220978 pages, LIFO batch:31
>> [    0.000000]   HighMem zone: 4372 pages used for memmap
>> [    0.000000]   HighMem zone: 555166 pages, LIFO batch:31
>> [    0.000000] Using APIC driver default
>> [    0.000000] ACPI: PM-Timer IO Port: 0x808
>> [    0.000000] ACPI: Local APIC address 0xfee00000
>> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
>> [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
>> [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
>> [    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
>> [    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
>> [    0.000000] IOAPIC[0]: apic_id 4, version 32, address 0xfec00000, GSI 0-23
>> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
>> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
>> [    0.000000] ACPI: IRQ0 used by override.
>> [    0.000000] ACPI: IRQ2 used by override.
>> [    0.000000] ACPI: IRQ9 used by override.
>> [    0.000000] Using ACPI (MADT) for SMP configuration information
>> [    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
>> [    0.000000] nr_irqs_gsi: 40
>> [    0.000000] PM: Registered nosave memory: 000000000009b000 - 000000000009c000
>> [    0.000000] PM: Registered nosave memory: 000000000009c000 - 00000000000a0000
>> [    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e3000
>> [    0.000000] PM: Registered nosave memory: 00000000000e3000 - 0000000000100000
>> [    0.000000] Allocating PCI resources starting at c0000000 (gap: c0000000:3ee00000)
>> [    0.000000] Booting paravirtualized kernel on bare hardware
>> [    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:4 nr_node_ids:1
>> [    0.000000] PERCPU: Embedded 14 pages/cpu @f7200000 s34240 r0 d23104 u524288
>> [    0.000000] pcpu-alloc: s34240 r0 d23104 u524288 alloc=1*2097152
>> [    0.000000] pcpu-alloc: [0] 0 1 2 3
>> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 780091
>> [    0.000000] Kernel command line: ro root=UUID=773cb4b3-4bb0-4705-b494-08cb9c2b5d73 LANG=ja_JP.UTF-8 KEYBOARDTYPE=pc KEYTABLE=jp106 rhgb quiet nomodeset
>> [    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
>> [    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
>> [    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
>> [    0.000000] Initializing CPU#0
>> [    0.000000] allocated 12581376 bytes of page_cgroup
>> [    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
>> [    0.000000] Initializing HighMem for node 0 (000375fe:000bffb0)
>> [    0.000000] Memory: 3081612k/3145408k available (5404k kernel code, 63328k reserved, 2569k data, 644k init, 2238152k highmem)
>> [    0.000000] virtual kernel memory layout:
>> [    0.000000]     fixmap  : 0xffa95000 - 0xfffff000   (5544 kB)
>> [    0.000000]     pkmap   : 0xff600000 - 0xff800000   (2048 kB)
>> [    0.000000]     vmalloc : 0xf7dfe000 - 0xff5fe000   ( 120 MB)
>> [    0.000000]     lowmem  : 0xc0000000 - 0xf75fe000   ( 885 MB)
>> [    0.000000]       .init : 0xc0bca000 - 0xc0c6b000   ( 644 kB)
>> [    0.000000]       .data : 0xc094723f - 0xc0bc9980   (2569 kB)
>> [    0.000000]       .text : 0xc0400000 - 0xc094723f   (5404 kB)
>> [    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
>> [    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
>> [    0.000000] Hierarchical RCU implementation.
>> [    0.000000]        RCU dyntick-idle grace-period acceleration is enabled.
>> [    0.000000] NR_IRQS:2304 nr_irqs:712 16
>> [    0.000000] CPU 0 irqstacks, hard=f380a000 soft=f380c000
>> [    0.000000] Console: colour VGA+ 80x25
>> [    0.000000] console [tty0] enabled
>> [    0.000000] Fast TSC calibration failed
>> [    0.000000] TSC: PIT calibration matches PMTIMER. 1 loops
>> [    0.000000] Detected 2402.370 MHz processor.
>> [    0.002001] Calibrating delay loop (skipped), value calculated using timer frequency.. 4804.74 BogoMIPS (lpj=2402370)
>> [    0.002005] pid_max: default: 32768 minimum: 301
>> [    0.002025] Security Framework initialized
>> [    0.002032] SELinux:  Initializing.
>> [    0.002040] SELinux:  Starting in permissive mode
>> [    0.002087] Mount-cache hash table entries: 512
>> [    0.002210] Initializing cgroup subsys cpuacct
>> [    0.002215] Initializing cgroup subsys memory
>> [    0.002222] Initializing cgroup subsys devices
>> [    0.002224] Initializing cgroup subsys freezer
>> [    0.002226] Initializing cgroup subsys net_cls
>> [    0.002228] Initializing cgroup subsys blkio
>> [    0.002233] Initializing cgroup subsys perf_event
>> [    0.002255] CPU: Physical Processor ID: 0
>> [    0.002256] CPU: Processor Core ID: 0
>> [    0.002259] mce: CPU supports 6 MCE banks
>> [    0.002266] CPU0: Thermal monitoring enabled (TM2)
>> [    0.002268] using mwait in idle threads.
>> [    0.003853] ACPI: Core revision 20110623
>> [    0.007009] ftrace: allocating 22484 entries in 45 pages
>> [    0.008042] Enabling APIC mode:  Flat.  Using 1 I/O APICs
>> [    0.008385] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
>> [    0.018812] CPU0: Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz stepping 0b
>> [    0.018998] Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
>> [    0.018998] PEBS disabled due to CPU errata.
>> [    0.018998] ... version:                2
>> [    0.018998] ... bit width:              40
>> [    0.018998] ... generic registers:      2
>> [    0.018998] ... value mask:             000000ffffffffff
>> [    0.018998] ... max period:             000000007fffffff
>> [    0.018998] ... fixed-purpose events:   3
>> [    0.018998] ... event mask:             0000000700000003
>> [    0.018998] NMI watchdog enabled, takes one hw-pmu counter.
>> [    0.018998] CPU 1 irqstacks, hard=f3902000 soft=f3904000
>> [    0.018998] Booting Node   0, Processors  #1
>> [    0.018998] smpboot cpu 1: start_ip = 97000
>> [    0.002999] Initializing CPU#1
>> [    0.090020] NMI watchdog enabled, takes one hw-pmu counter.
>> [    0.090116] CPU 2 irqstacks, hard=f3930000 soft=f3932000
>> [    0.090118]  #2
>> [    0.090119] smpboot cpu 2: start_ip = 97000
>> [    0.002999] Initializing CPU#2
>> [    0.162002] NMI watchdog enabled, takes one hw-pmu counter.
>> [    0.162084] CPU 3 irqstacks, hard=f393e000 soft=f3948000
>> [    0.162086]  #3 Ok.
>> [    0.162087] smpboot cpu 3: start_ip = 97000
>> [    0.002999] Initializing CPU#3
>> [    0.233992] NMI watchdog enabled, takes one hw-pmu counter.
>> [    0.234016] Brought up 4 CPUs
>> [    0.234019] Total of 4 processors activated (19216.44 BogoMIPS).
>> [    0.235092] devtmpfs: initialized
>> [    0.235211] PM: Registering ACPI NVS region at bffbe000 (204800 bytes)
>> [    0.236847] atomic64 test passed for i586+ platform with CX8 and with SSE
>> [    0.236872] RTC time: 18:51:35, date: 03/26/12
>> [    0.236905] NET: Registered protocol family 16
>> [    0.237081] ACPI: bus type pci registered
>> [    0.237141] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
>> [    0.237144] PCI: not using MMCONFIG
>> [    0.237231] PCI : PCI BIOS aera is rw and x. Use pci=nobios if you want it NX.
>> [    0.237289] PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=7
>> [    0.237290] PCI: Using configuration type 1 for base access
>> [    0.238391] bio: create slab <bio-0> at 0
>> [    0.238391] ACPI: Added _OSI(Module Device)
>> [    0.238391] ACPI: Added _OSI(Processor Device)
>> [    0.238391] ACPI: Added _OSI(3.0 _SCP Extensions)
>> [    0.238391] ACPI: Added _OSI(Processor Aggregator Device)
>> [    0.239491] ACPI: EC: Detected MSI hardware, enabling workarounds.
>> [    0.239497] ACPI: EC: Look up EC in DSDT
>> [    0.240586] ACPI: Executed 1 blocks of module-level executable AML code
>> [    0.243093] ACPI: SSDT bffc00f0 00277 (v01 DpgPmm  P001Ist 00000011 INTL 20051117)
>> [    0.243315] ACPI: Dynamic OEM Table Load:
>> [    0.243318] ACPI: SSDT   (null) 00277 (v01 DpgPmm  P001Ist 00000011 INTL 20051117)
>> [    0.243555] ACPI: SSDT bffc0580 00277 (v01 DpgPmm  P002Ist 00000012 INTL 20051117)
>> [    0.243776] ACPI: Dynamic OEM Table Load:
>> [    0.243779] ACPI: SSDT   (null) 00277 (v01 DpgPmm  P002Ist 00000012 INTL 20051117)
>> [    0.244019] ACPI: SSDT bffc0a10 00277 (v01 DpgPmm  P003Ist 00000012 INTL 20051117)
>> [    0.244242] ACPI: Dynamic OEM Table Load:
>> [    0.244245] ACPI: SSDT   (null) 00277 (v01 DpgPmm  P003Ist 00000012 INTL 20051117)
>> [    0.244478] ACPI: SSDT bffc0ea0 00277 (v01 DpgPmm  P004Ist 00000012 INTL 20051117)
>> [    0.244704] ACPI: Dynamic OEM Table Load:
>> [    0.244707] ACPI: SSDT   (null) 00277 (v01 DpgPmm  P004Ist 00000012 INTL 20051117)
>> [    0.244925] ACPI: Interpreter enabled
>> [    0.244945] ACPI: (supports S0 S3 S4 S5)
>> [    0.244962] ACPI: Using IOAPIC for interrupt routing
>> [    0.244986] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
>> [    0.245998] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI motherboard resources
>> [    0.246000] PCI: Using MMCONFIG for extended config space
>> [    0.251283] ACPI: No dock devices found.
>> [    0.251285] HEST: Table not found.
>> [    0.251290] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
>> [    0.251452] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
>> [    0.251617] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7] (ignored)
>> [    0.251620] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff] (ignored)
>> [    0.251623] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
>> [    0.251625] pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x000dffff] (ignored)
>> [    0.251627] pci_root PNP0A08:00: host bridge window [mem 0xc0000000-0xdfffffff] (ignored)
>> [    0.251629] pci_root PNP0A08:00: host bridge window [mem 0xf0000000-0xffffffff] (ignored)
>> [    0.251639] pci 0000:00:00.0: [8086:29c0] type 0 class 0x000600
>> [    0.251680] pci 0000:00:01.0: [8086:29c1] type 1 class 0x000604
>> [    0.251719] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
>> [    0.251722] pci 0000:00:01.0: PME# disabled
>> [    0.251757] pci 0000:00:1a.0: [8086:2937] type 0 class 0x000c03
>> [    0.251797] pci 0000:00:1a.0: reg 20: [io  0x9c00-0x9c1f]
>> [    0.251844] pci 0000:00:1a.1: [8086:2938] type 0 class 0x000c03
>> [    0.251884] pci 0000:00:1a.1: reg 20: [io  0x9880-0x989f]
>> [    0.251940] pci 0000:00:1a.7: [8086:293c] type 0 class 0x000c03
>> [    0.251960] pci 0000:00:1a.7: reg 10: [mem 0xf9fffc00-0xf9ffffff]
>> [    0.252049] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
>> [    0.252054] pci 0000:00:1a.7: PME# disabled
>> [    0.252076] pci 0000:00:1b.0: [8086:293e] type 0 class 0x000403
>> [    0.252090] pci 0000:00:1b.0: reg 10: [mem 0xf9ff8000-0xf9ffbfff 64bit]
>> [    0.252152] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
>> [    0.252156] pci 0000:00:1b.0: PME# disabled
>> [    0.252174] pci 0000:00:1c.0: [8086:2940] type 1 class 0x000604
>> [    0.252238] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
>> [    0.252241] pci 0000:00:1c.0: PME# disabled
>> [    0.252261] pci 0000:00:1c.1: [8086:2942] type 1 class 0x000604
>> [    0.252325] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
>> [    0.252328] pci 0000:00:1c.1: PME# disabled
>> [    0.252348] pci 0000:00:1c.2: [8086:2944] type 1 class 0x000604
>> [    0.252412] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
>> [    0.252416] pci 0000:00:1c.2: PME# disabled
>> [    0.252436] pci 0000:00:1c.4: [8086:2948] type 1 class 0x000604
>> [    0.252500] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
>> [    0.252503] pci 0000:00:1c.4: PME# disabled
>> [    0.252523] pci 0000:00:1c.5: [8086:294a] type 1 class 0x000604
>> [    0.252587] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
>> [    0.252590] pci 0000:00:1c.5: PME# disabled
>> [    0.252611] pci 0000:00:1d.0: [8086:2934] type 0 class 0x000c03
>> [    0.252651] pci 0000:00:1d.0: reg 20: [io  0x9800-0x981f]
>> [    0.252698] pci 0000:00:1d.1: [8086:2935] type 0 class 0x000c03
>> [    0.252737] pci 0000:00:1d.1: reg 20: [io  0x9480-0x949f]
>> [    0.252786] pci 0000:00:1d.2: [8086:2936] type 0 class 0x000c03
>> [    0.252826] pci 0000:00:1d.2: reg 20: [io  0x9400-0x941f]
>> [    0.252873] pci 0000:00:1d.3: [8086:2939] type 0 class 0x000c03
>> [    0.252912] pci 0000:00:1d.3: reg 20: [io  0x9080-0x909f]
>> [    0.252967] pci 0000:00:1d.7: [8086:293a] type 0 class 0x000c03
>> [    0.252991] pci 0000:00:1d.7: reg 10: [mem 0xf9fff800-0xf9fffbff]
>> [    0.253075] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
>> [    0.253079] pci 0000:00:1d.7: PME# disabled
>> [    0.253096] pci 0000:00:1e.0: [8086:244e] type 1 class 0x000604
>> [    0.253154] pci 0000:00:1f.0: [8086:2918] type 0 class 0x000601
>> [    0.253230] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0a00 (mask 00ff)
>> [    0.253275] pci 0000:00:1f.2: [8086:2921] type 0 class 0x000101
>> [    0.253289] pci 0000:00:1f.2: reg 10: [io  0x9000-0x9007]
>> [    0.253296] pci 0000:00:1f.2: reg 14: [io  0x8c00-0x8c03]
>> [    0.253304] pci 0000:00:1f.2: reg 18: [io  0x8880-0x8887]
>> [    0.253311] pci 0000:00:1f.2: reg 1c: [io  0x8800-0x8803]
>> [    0.253318] pci 0000:00:1f.2: reg 20: [io  0x8480-0x848f]
>> [    0.253325] pci 0000:00:1f.2: reg 24: [io  0x8400-0x840f]
>> [    0.253368] pci 0000:00:1f.3: [8086:2930] type 0 class 0x000c05
>> [    0.253382] pci 0000:00:1f.3: reg 10: [mem 0xf9fff400-0xf9fff4ff 64bit]
>> [    0.253402] pci 0000:00:1f.3: reg 20: [io  0x0400-0x041f]
>> [    0.253432] pci 0000:00:1f.5: [8086:2926] type 0 class 0x000101
>> [    0.253446] pci 0000:00:1f.5: reg 10: [io  0x8000-0x8007]
>> [    0.253454] pci 0000:00:1f.5: reg 14: [io  0x7c00-0x7c03]
>> [    0.253461] pci 0000:00:1f.5: reg 18: [io  0x7880-0x7887]
>> [    0.253469] pci 0000:00:1f.5: reg 1c: [io  0x7800-0x7803]
>> [    0.253476] pci 0000:00:1f.5: reg 20: [io  0x7480-0x748f]
>> [    0.253483] pci 0000:00:1f.5: reg 24: [io  0x7400-0x740f]
>> [    0.253556] pci 0000:01:00.0: [10de:0615] type 0 class 0x000300
>> [    0.253566] pci 0000:01:00.0: reg 10: [mem 0xfd000000-0xfdffffff]
>> [    0.253576] pci 0000:01:00.0: reg 14: [mem 0xd0000000-0xdfffffff 64bit pref]
>> [    0.253587] pci 0000:01:00.0: reg 1c: [mem 0xfa000000-0xfbffffff 64bit]
>> [    0.253594] pci 0000:01:00.0: reg 24: [io  0xac00-0xac7f]
>> [    0.253601] pci 0000:01:00.0: reg 30: [mem 0xfe7e0000-0xfe7fffff pref]
>> [    0.253652] pci 0000:00:01.0: PCI bridge to [bus 01-01]
>> [    0.253655] pci 0000:00:01.0:   bridge window [io  0xa000-0xafff]
>> [    0.253658] pci 0000:00:01.0:   bridge window [mem 0xfa000000-0xfe7fffff]
>> [    0.253662] pci 0000:00:01.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
>> [    0.253698] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
>> [    0.253762] pci 0000:03:00.0: [1095:3132] type 0 class 0x000180
>> [    0.253787] pci 0000:03:00.0: reg 10: [mem 0xfe8ffc00-0xfe8ffc7f 64bit]
>> [    0.253807] pci 0000:03:00.0: reg 18: [mem 0xfe8f8000-0xfe8fbfff 64bit]
>> [    0.253821] pci 0000:03:00.0: reg 20: [io  0xbc00-0xbc7f]
>> [    0.253846] pci 0000:03:00.0: reg 30: [mem 0xfe800000-0xfe87ffff pref]
>> [    0.253910] pci 0000:03:00.0: supports D1 D2
>> [    0.253931] pci 0000:03:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
>> [    0.253935] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
>> [    0.253939] pci 0000:00:1c.1:   bridge window [io  0xb000-0xbfff]
>> [    0.253942] pci 0000:00:1c.1:   bridge window [mem 0xfe800000-0xfe8fffff]
>> [    0.254007] pci 0000:04:00.0: [1095:3132] type 0 class 0x000180
>> [    0.254033] pci 0000:04:00.0: reg 10: [mem 0xfe9ffc00-0xfe9ffc7f 64bit]
>> [    0.254054] pci 0000:04:00.0: reg 18: [mem 0xfe9f8000-0xfe9fbfff 64bit]
>> [    0.254067] pci 0000:04:00.0: reg 20: [io  0xcc00-0xcc7f]
>> [    0.254093] pci 0000:04:00.0: reg 30: [mem 0xfe900000-0xfe97ffff pref]
>> [    0.254157] pci 0000:04:00.0: supports D1 D2
>> [    0.254177] pci 0000:04:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
>> [    0.254182] pci 0000:00:1c.2: PCI bridge to [bus 04-04]
>> [    0.254185] pci 0000:00:1c.2:   bridge window [io  0xc000-0xcfff]
>> [    0.254189] pci 0000:00:1c.2:   bridge window [mem 0xfe900000-0xfe9fffff]
>> [    0.254245] pci 0000:05:00.0: [11ab:6121] type 0 class 0x000101
>> [    0.254260] pci 0000:05:00.0: reg 10: [io  0xdc00-0xdc07]
>> [    0.254272] pci 0000:05:00.0: reg 14: [io  0xd880-0xd883]
>> [    0.254283] pci 0000:05:00.0: reg 18: [io  0xd800-0xd807]
>> [    0.254295] pci 0000:05:00.0: reg 1c: [io  0xd480-0xd483]
>> [    0.254306] pci 0000:05:00.0: reg 20: [io  0xd400-0xd40f]
>> [    0.254317] pci 0000:05:00.0: reg 24: [mem 0xfeaffc00-0xfeafffff]
>> [    0.254379] pci 0000:05:00.0: supports D1
>> [    0.254381] pci 0000:05:00.0: PME# supported from D0 D1 D3hot
>> [    0.254386] pci 0000:05:00.0: PME# disabled
>> [    0.254402] pci 0000:05:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
>> [    0.254406] pci 0000:00:1c.4: PCI bridge to [bus 05-05]
>> [    0.254410] pci 0000:00:1c.4:   bridge window [io  0xd000-0xdfff]
>> [    0.254414] pci 0000:00:1c.4:   bridge window [mem 0xfea00000-0xfeafffff]
>> [    0.254475] pci 0000:06:00.0: [10ec:8168] type 0 class 0x000200
>> [    0.254493] pci 0000:06:00.0: reg 10: [io  0xe800-0xe8ff]
>> [    0.254523] pci 0000:06:00.0: reg 18: [mem 0xfebff000-0xfebfffff 64bit]
>> [    0.254558] pci 0000:06:00.0: reg 30: [mem 0xfebc0000-0xfebdffff pref]
>> [    0.254635] pci 0000:06:00.0: supports D1 D2
>> [    0.254637] pci 0000:06:00.0: PME# supported from D1 D2 D3hot D3cold
>> [    0.254642] pci 0000:06:00.0: PME# disabled
>> [    0.254664] pci 0000:06:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
>> [    0.254668] pci 0000:00:1c.5: PCI bridge to [bus 06-06]
>> [    0.254672] pci 0000:00:1c.5:   bridge window [io  0xe000-0xefff]
>> [    0.254676] pci 0000:00:1c.5:   bridge window [mem 0xfeb00000-0xfebfffff]
>> [    0.254735] pci 0000:00:1e.0: PCI bridge to [bus 07-07] (subtractive decode)
>> [    0.254744] pci 0000:00:1e.0:   bridge window [io  0x0000-0xffff] (subtractive decode)
>> [    0.254747] pci 0000:00:1e.0:   bridge window [mem 0x00000000-0xfffffffff] (subtractive decode)
>> [    0.254772] pci_bus 0000:00: on NUMA node 0
>> [    0.254775] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
>> [    0.254920] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
>> [    0.255028] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
>> [    0.255069] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P5._PRT]
>> [    0.255110] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P6._PRT]
>> [    0.255153] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P8._PRT]
>> [    0.255193] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9._PRT]
>> [    0.255323]  pci0000:00: Requesting ACPI _OSC control (0x1d)
>> [    0.255478]  pci0000:00: ACPI _OSC control (0x1d) granted
>> [    0.264124] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 6 7 *10 11 12 14 15)
>> [    0.264168] ACPI: PCI Interrupt Link [LNKB] (IRQs *5)
>> [    0.264208] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 6 7 10 *11 12 14 15)
>> [    0.264250] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 6 7 10 11 12 14 *15)
>> [    0.264292] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 6 7 10 11 12 14 15) *0, disabled.
>> [    0.264337] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 6 7 10 11 12 *14 15)
>> [    0.264379] ACPI: PCI Interrupt Link [LNKG] (IRQs *3 4 6 7 10 11 12 14 15)
>> [    0.264421] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 6 7 *10 11 12 14 15)
>> [    0.264500] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
>> [    0.264500] vgaarb: loaded
>> [    0.264500] vgaarb: bridge control possible 0000:01:00.0
>> [    0.264500] SCSI subsystem initialized
>> [    0.264517] libata version 3.00 loaded.
>> [    0.264517] usbcore: registered new interface driver usbfs
>> [    0.264517] usbcore: registered new interface driver hub
>> [    0.264517] usbcore: registered new device driver usb
>> [    0.264517] PCI: Using ACPI for IRQ routing
>> [    0.264517] PCI: pci_cache_line_size set to 64 bytes
>> [    0.264517] reserve RAM buffer: 000000000009b800 - 000000000009ffff
>> [    0.264517] reserve RAM buffer: 00000000bffb0000 - 00000000bfffffff
>> [    0.264991] NetLabel: Initializing
>> [    0.264992] NetLabel:  domain hash size = 128
>> [    0.264994] NetLabel:  protocols = UNLABELED CIPSOv4
>> [    0.265003] NetLabel:  unlabeled traffic allowed by default
>> [    0.272818] pnp: PnP ACPI init
>> [    0.272833] ACPI: bus type pnp registered
>> [    0.272930] pnp 00:00: [bus 00-ff]
>> [    0.272933] pnp 00:00: [io  0x0cf8-0x0cff]
>> [    0.272935] pnp 00:00: [io  0x0000-0x0cf7 window]
>> [    0.272938] pnp 00:00: [io  0x0d00-0xffff window]
>> [    0.272940] pnp 00:00: [mem 0x000a0000-0x000bffff window]
>> [    0.272942] pnp 00:00: [mem 0x000d0000-0x000dffff window]
>> [    0.272946] pnp 00:00: [mem 0xc0000000-0xdfffffff window]
>> [    0.272948] pnp 00:00: [mem 0xf0000000-0xffffffff window]
>> [    0.273001] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
>> [    0.273011] pnp 00:01: [mem 0xfed14000-0xfed19fff]
>> [    0.273064] system 00:01: [mem 0xfed14000-0xfed19fff] has been reserved
>> [    0.273067] system 00:01: Plug and Play ACPI device, IDs PNP0c01 (active)
>> [    0.273096] pnp 00:02: [dma 4]
>> [    0.273098] pnp 00:02: [io  0x0000-0x000f]
>> [    0.273100] pnp 00:02: [io  0x0081-0x0083]
>> [    0.273102] pnp 00:02: [io  0x0087]
>> [    0.273104] pnp 00:02: [io  0x0089-0x008b]
>> [    0.273105] pnp 00:02: [io  0x008f]
>> [    0.273107] pnp 00:02: [io  0x00c0-0x00df]
>> [    0.273132] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
>> [    0.273142] pnp 00:03: [io  0x0070-0x0071]
>> [    0.273151] pnp 00:03: [irq 8]
>> [    0.273178] pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
>> [    0.273186] pnp 00:04: [io  0x0061]
>> [    0.273210] pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
>> [    0.273218] pnp 00:05: [io  0x00f0-0x00ff]
>> [    0.273223] pnp 00:05: [irq 13]
>> [    0.273248] pnp 00:05: Plug and Play ACPI device, IDs PNP0c04 (active)
>> [    0.273481] pnp 00:06: [io  0x03f8-0x03ff]
>> [    0.273486] pnp 00:06: [irq 4]
>> [    0.273488] pnp 00:06: [dma 0 disabled]
>> [    0.273553] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
>> [    0.273948] pnp 00:07: [io  0x0378-0x037f]
>> [    0.273953] pnp 00:07: [irq 7]
>> [    0.273955] pnp 00:07: [dma 0 disabled]
>> [    0.274087] pnp 00:07: Plug and Play ACPI device, IDs PNP0400 (active)
>> [    0.274113] pnp 00:08: [io  0x0060]
>> [    0.274115] pnp 00:08: [io  0x0064]
>> [    0.274119] pnp 00:08: [irq 1]
>> [    0.274155] pnp 00:08: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
>> [    0.274196] pnp 00:09: [irq 12]
>> [    0.274229] pnp 00:09: Plug and Play ACPI device, IDs PNP0f03 PNP0f13 (active)
>> [    0.274307] pnp 00:0a: [io  0x0000-0xffffffffffffffff disabled]
>> [    0.274310] pnp 00:0a: [io  0x0a00-0x0adf]
>> [    0.274312] pnp 00:0a: [io  0x0ae0-0x0aef]
>> [    0.274363] system 00:0a: [io  0x0a00-0x0adf] has been reserved
>> [    0.274366] system 00:0a: [io  0x0ae0-0x0aef] has been reserved
>> [    0.274369] system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
>> [    0.274437] pnp 00:0b: [io  0x0010-0x001f]
>> [    0.274440] pnp 00:0b: [io  0x0022-0x003f]
>> [    0.274441] pnp 00:0b: [io  0x0044-0x005f]
>> [    0.274443] pnp 00:0b: [io  0x0062-0x0063]
>> [    0.274445] pnp 00:0b: [io  0x0065-0x006f]
>> [    0.274447] pnp 00:0b: [io  0x0072-0x007f]
>> [    0.274448] pnp 00:0b: [io  0x0080]
>> [    0.274450] pnp 00:0b: [io  0x0084-0x0086]
>> [    0.274452] pnp 00:0b: [io  0x0088]
>> [    0.274455] pnp 00:0b: [io  0x008c-0x008e]
>> [    0.274457] pnp 00:0b: [io  0x0090-0x009f]
>> [    0.274459] pnp 00:0b: [io  0x00a2-0x00bf]
>> [    0.274461] pnp 00:0b: [io  0x00e0-0x00ef]
>> [    0.274463] pnp 00:0b: [io  0x04d0-0x04d1]
>> [    0.274464] pnp 00:0b: [io  0x0800-0x087f]
>> [    0.274466] pnp 00:0b: [io  0x0000-0xffffffffffffffff disabled]
>> [    0.274468] pnp 00:0b: [io  0x0480-0x04bf]
>> [    0.274470] pnp 00:0b: [mem 0xfed1c000-0xfed1ffff]
>> [    0.274472] pnp 00:0b: [mem 0xfed20000-0xfed8ffff]
>> [    0.274541] system 00:0b: [io  0x04d0-0x04d1] has been reserved
>> [    0.274544] system 00:0b: [io  0x0800-0x087f] has been reserved
>> [    0.274546] system 00:0b: [io  0x0480-0x04bf] has been reserved
>> [    0.274549] system 00:0b: [mem 0xfed1c000-0xfed1ffff] has been reserved
>> [    0.274551] system 00:0b: [mem 0xfed20000-0xfed8ffff] has been reserved
>> [    0.274554] system 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
>> [    0.274625] pnp 00:0c: [mem 0xffb00000-0xffbfffff]
>> [    0.274627] pnp 00:0c: [mem 0xfff00000-0xffffffff]
>> [    0.274655] pnp 00:0c: Plug and Play ACPI device, IDs INT0800 (active)
>> [    0.274694] pnp 00:0d: [mem 0xffc00000-0xffefffff]
>> [    0.274744] system 00:0d: [mem 0xffc00000-0xffefffff] has been reserved
>> [    0.274747] system 00:0d: Plug and Play ACPI device, IDs PNP0c02 (active)
>> [    0.274820] pnp 00:0e: [mem 0xfec00000-0xfec00fff]
>> [    0.274822] pnp 00:0e: [mem 0xfee00000-0xfee00fff]
>> [    0.274870] system 00:0e: [mem 0xfec00000-0xfec00fff] could not be reserved
>> [    0.274873] system 00:0e: [mem 0xfee00000-0xfee00fff] has been reserved
>> [    0.274876] system 00:0e: Plug and Play ACPI device, IDs PNP0c02 (active)
>> [    0.274906] pnp 00:0f: [mem 0xe0000000-0xefffffff]
>> [    0.274956] system 00:0f: [mem 0xe0000000-0xefffffff] has been reserved
>> [    0.274959] system 00:0f: Plug and Play ACPI device, IDs PNP0c02 (active)
>> [    0.275113] pnp 00:10: [mem 0x00000000-0x0009ffff]
>> [    0.275115] pnp 00:10: [mem 0x000c0000-0x000cffff]
>> [    0.275117] pnp 00:10: [mem 0x000e0000-0x000fffff]
>> [    0.275119] pnp 00:10: [mem 0x00100000-0xbfffffff]
>> [    0.275121] pnp 00:10: [mem 0x00000000-0xffffffffffffffff disabled]
>> [    0.275180] system 00:10: [mem 0x00000000-0x0009ffff] could not be reserved
>> [    0.275183] system 00:10: [mem 0x000c0000-0x000cffff] could not be reserved
>> [    0.275186] system 00:10: [mem 0x000e0000-0x000fffff] could not be reserved
>> [    0.275188] system 00:10: [mem 0x00100000-0xbfffffff] could not be reserved
>> [    0.275191] system 00:10: Plug and Play ACPI device, IDs PNP0c01 (active)
>> [    0.275308] pnp: PnP ACPI: found 17 devices
>> [    0.275309] ACPI: ACPI bus type pnp unregistered
>> [    0.312103] Switching to clocksource acpi_pm
>> [    0.312137] PCI: max bus depth: 1 pci_try_num: 2
>> [    0.312182] pci 0000:00:1c.5: BAR 15: assigned [mem 0xc0000000-0xc01fffff 64bit pref]
>> [    0.312186] pci 0000:00:1c.4: BAR 15: assigned [mem 0xc0200000-0xc03fffff 64bit pref]
>> [    0.312189] pci 0000:00:1c.2: BAR 15: assigned [mem 0xc0400000-0xc05fffff 64bit pref]
>> [    0.312192] pci 0000:00:1c.1: BAR 15: assigned [mem 0xc0600000-0xc07fffff 64bit pref]
>> [    0.312195] pci 0000:00:1c.0: BAR 14: assigned [mem 0xc0800000-0xc09fffff]
>> [    0.312198] pci 0000:00:1c.0: BAR 15: assigned [mem 0xc0a00000-0xc0bfffff 64bit pref]
>> [    0.312201] pci 0000:00:1c.0: BAR 13: assigned [io  0x1000-0x1fff]
>> [    0.312204] pci 0000:00:01.0: PCI bridge to [bus 01-01]
>> [    0.312207] pci 0000:00:01.0:   bridge window [io  0xa000-0xafff]
>> [    0.312210] pci 0000:00:01.0:   bridge window [mem 0xfa000000-0xfe7fffff]
>> [    0.312214] pci 0000:00:01.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
>> [    0.312218] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
>> [    0.312221] pci 0000:00:1c.0:   bridge window [io  0x1000-0x1fff]
>> [    0.312225] pci 0000:00:1c.0:   bridge window [mem 0xc0800000-0xc09fffff]
>> [    0.312229] pci 0000:00:1c.0:   bridge window [mem 0xc0a00000-0xc0bfffff 64bit pref]
>> [    0.312234] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
>> [    0.312237] pci 0000:00:1c.1:   bridge window [io  0xb000-0xbfff]
>> [    0.312241] pci 0000:00:1c.1:   bridge window [mem 0xfe800000-0xfe8fffff]
>> [    0.312245] pci 0000:00:1c.1:   bridge window [mem 0xc0600000-0xc07fffff 64bit pref]
>> [    0.312250] pci 0000:00:1c.2: PCI bridge to [bus 04-04]
>> [    0.312253] pci 0000:00:1c.2:   bridge window [io  0xc000-0xcfff]
>> [    0.312257] pci 0000:00:1c.2:   bridge window [mem 0xfe900000-0xfe9fffff]
>> [    0.312261] pci 0000:00:1c.2:   bridge window [mem 0xc0400000-0xc05fffff 64bit pref]
>> [    0.312267] pci 0000:00:1c.4: PCI bridge to [bus 05-05]
>> [    0.312269] pci 0000:00:1c.4:   bridge window [io  0xd000-0xdfff]
>> [    0.312274] pci 0000:00:1c.4:   bridge window [mem 0xfea00000-0xfeafffff]
>> [    0.312277] pci 0000:00:1c.4:   bridge window [mem 0xc0200000-0xc03fffff 64bit pref]
>> [    0.312283] pci 0000:00:1c.5: PCI bridge to [bus 06-06]
>> [    0.312285] pci 0000:00:1c.5:   bridge window [io  0xe000-0xefff]
>> [    0.312290] pci 0000:00:1c.5:   bridge window [mem 0xfeb00000-0xfebfffff]
>> [    0.312293] pci 0000:00:1c.5:   bridge window [mem 0xc0000000-0xc01fffff 64bit pref]
>> [    0.312299] pci 0000:00:1e.0: PCI bridge to [bus 07-07]
>> [    0.312318] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
>> [    0.312321] pci 0000:00:01.0: setting latency timer to 64
>> [    0.312326] pci 0000:00:1c.0: enabling device (0104 -> 0107)
>> [    0.312333] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
>> [    0.312337] pci 0000:00:1c.0: setting latency timer to 64
>> [    0.312342] pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
>> [    0.312346] pci 0000:00:1c.1: setting latency timer to 64
>> [    0.312354] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
>> [    0.312357] pci 0000:00:1c.2: setting latency timer to 64
>> [    0.312363] pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
>> [    0.312366] pci 0000:00:1c.4: setting latency timer to 64
>> [    0.312371] pci 0000:00:1c.5: PCI INT B -> GSI 16 (level, low) -> IRQ 16
>> [    0.312375] pci 0000:00:1c.5: setting latency timer to 64
>> [    0.312380] pci 0000:00:1e.0: setting latency timer to 64
>> [    0.312384] pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
>> [    0.312386] pci_bus 0000:00: resource 1 [mem 0x00000000-0xfffffffff]
>> [    0.312388] pci_bus 0000:01: resource 0 [io  0xa000-0xafff]
>> [    0.312390] pci_bus 0000:01: resource 1 [mem 0xfa000000-0xfe7fffff]
>> [    0.312393] pci_bus 0000:01: resource 2 [mem 0xd0000000-0xdfffffff 64bit pref]
>> [    0.312395] pci_bus 0000:02: resource 0 [io  0x1000-0x1fff]
>> [    0.312397] pci_bus 0000:02: resource 1 [mem 0xc0800000-0xc09fffff]
>> [    0.312399] pci_bus 0000:02: resource 2 [mem 0xc0a00000-0xc0bfffff 64bit pref]
>> [    0.312401] pci_bus 0000:03: resource 0 [io  0xb000-0xbfff]
>> [    0.312403] pci_bus 0000:03: resource 1 [mem 0xfe800000-0xfe8fffff]
>> [    0.312405] pci_bus 0000:03: resource 2 [mem 0xc0600000-0xc07fffff 64bit pref]
>> [    0.312408] pci_bus 0000:04: resource 0 [io  0xc000-0xcfff]
>> [    0.312409] pci_bus 0000:04: resource 1 [mem 0xfe900000-0xfe9fffff]
>> [    0.312412] pci_bus 0000:04: resource 2 [mem 0xc0400000-0xc05fffff 64bit pref]
>> [    0.312414] pci_bus 0000:05: resource 0 [io  0xd000-0xdfff]
>> [    0.312416] pci_bus 0000:05: resource 1 [mem 0xfea00000-0xfeafffff]
>> [    0.312418] pci_bus 0000:05: resource 2 [mem 0xc0200000-0xc03fffff 64bit pref]
>> [    0.312420] pci_bus 0000:06: resource 0 [io  0xe000-0xefff]
>> [    0.312422] pci_bus 0000:06: resource 1 [mem 0xfeb00000-0xfebfffff]
>> [    0.312425] pci_bus 0000:06: resource 2 [mem 0xc0000000-0xc01fffff 64bit pref]
>> [    0.312427] pci_bus 0000:07: resource 4 [io  0x0000-0xffff]
>> [    0.312429] pci_bus 0000:07: resource 5 [mem 0x00000000-0xfffffffff]
>> [    0.312453] NET: Registered protocol family 2
>> [    0.312491] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
>> [    0.312587] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
>> [    0.312959] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
>> [    0.313062] TCP: Hash tables configured (established 131072 bind 65536)
>> [    0.313064] TCP reno registered
>> [    0.313066] UDP hash table entries: 512 (order: 2, 16384 bytes)
>> [    0.313075] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
>> [    0.313132] NET: Registered protocol family 1
>> [    0.313150] pci 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
>> [    0.313165] pci 0000:00:1a.0: PCI INT A disabled
>> [    0.313177] pci 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
>> [    0.313191] pci 0000:00:1a.1: PCI INT B disabled
>> [    0.313199] pci 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
>> [    0.313219] pci 0000:00:1a.7: PCI INT C disabled
>> [    0.313239] pci 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
>> [    0.313254] pci 0000:00:1d.0: PCI INT A disabled
>> [    0.313263] pci 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
>> [    0.313277] pci 0000:00:1d.1: PCI INT B disabled
>> [    0.313284] pci 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
>> [    0.313298] pci 0000:00:1d.2: PCI INT C disabled
>> [    0.313304] pci 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
>> [    0.313319] pci 0000:00:1d.3: PCI INT D disabled
>> [    0.313326] pci 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
>> [    0.313339] pci 0000:00:1d.7: PCI INT A disabled
>> [    0.313360] pci 0000:01:00.0: Boot video device
>> [    0.313373] PCI: CLS 32 bytes, default 64
>> [    0.313428] Unpacking initramfs...
>> [    0.653964] Freeing initrd memory: 15804k freed
>> [    0.660788] apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
>> [    0.660791] apm: disabled - APM is not SMP safe.
>> [    0.660926] Intel AES-NI instructions are not detected.
>> [    0.661079] audit: initializing netlink socket (disabled)
>> [    0.661095] type=2000 audit(1332787894.661:1): initialized
>> [    0.684390] highmem bounce pool size: 64 pages
>> [    0.684395] HugeTLB registered 2 MB page size, pre-allocated 0 pages
>> [    0.695503] VFS: Disk quotas dquot_6.5.2
>> [    0.695557] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
>> [    0.696083] msgmni has been set to 1678
>> [    0.696142] SELinux:  Registering netfilter hooks
>> [    0.696558] alg: No test for stdrng (krng)
>> [    0.696571] NET: Registered protocol family 38
>> [    0.696613] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
>> [    0.696650] io scheduler noop registered
>> [    0.696652] io scheduler deadline registered
>> [    0.696658] io scheduler cfq registered (default)
>> [    0.696876] pcieport 0000:00:01.0: setting latency timer to 64
>> [    0.696905] pcieport 0000:00:01.0: irq 40 for MSI/MSI-X
>> [    0.696970] pcieport 0000:00:1c.0: setting latency timer to 64
>> [    0.697023] pcieport 0000:00:1c.0: irq 41 for MSI/MSI-X
>> [    0.697112] pcieport 0000:00:1c.1: setting latency timer to 64
>> [    0.697146] pcieport 0000:00:1c.1: irq 42 for MSI/MSI-X
>> [    0.697234] pcieport 0000:00:1c.2: setting latency timer to 64
>> [    0.697267] pcieport 0000:00:1c.2: irq 43 for MSI/MSI-X
>> [    0.697355] pcieport 0000:00:1c.4: setting latency timer to 64
>> [    0.697388] pcieport 0000:00:1c.4: irq 44 for MSI/MSI-X
>> [    0.697476] pcieport 0000:00:1c.5: setting latency timer to 64
>> [    0.697509] pcieport 0000:00:1c.5: irq 45 for MSI/MSI-X
>> [    0.697627] pcieport 0000:00:01.0: Signaling PME through PCIe PME interrupt
>> [    0.697629] pci 0000:01:00.0: Signaling PME through PCIe PME interrupt
>> [    0.697632] pcie_pme 0000:00:01.0:pcie01: service driver pcie_pme loaded
>> [    0.697648] pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
>> [    0.697652] pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
>> [    0.697668] pcieport 0000:00:1c.1: Signaling PME through PCIe PME interrupt
>> [    0.697670] pci 0000:03:00.0: Signaling PME through PCIe PME interrupt
>> [    0.697674] pcie_pme 0000:00:1c.1:pcie01: service driver pcie_pme loaded
>> [    0.697689] pcieport 0000:00:1c.2: Signaling PME through PCIe PME interrupt
>> [    0.697691] pci 0000:04:00.0: Signaling PME through PCIe PME interrupt
>> [    0.697695] pcie_pme 0000:00:1c.2:pcie01: service driver pcie_pme loaded
>> [    0.697710] pcieport 0000:00:1c.4: Signaling PME through PCIe PME interrupt
>> [    0.697712] pci 0000:05:00.0: Signaling PME through PCIe PME interrupt
>> [    0.697716] pcie_pme 0000:00:1c.4:pcie01: service driver pcie_pme loaded
>> [    0.697732] pcieport 0000:00:1c.5: Signaling PME through PCIe PME interrupt
>> [    0.697734] pci 0000:06:00.0: Signaling PME through PCIe PME interrupt
>> [    0.697738] pcie_pme 0000:00:1c.5:pcie01: service driver pcie_pme loaded
>> [    0.697757] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
>> [    0.697807] pciehp 0000:00:1c.0:pcie04: HPC vendor_id 8086 device_id 2940 ss_vid 1462 ss_did 7360
>> [    0.697825] pciehp 0000:00:1c.0:pcie04: service driver pciehp loaded
>> [    0.697834] pciehp 0000:00:1c.1:pcie04: HPC vendor_id 8086 device_id 2942 ss_vid 1462 ss_did 7360
>> [    0.697850] pciehp 0000:00:1c.1:pcie04: service driver pciehp loaded
>> [    0.697860] pciehp 0000:00:1c.2:pcie04: HPC vendor_id 8086 device_id 2944 ss_vid 1462 ss_did 7360
>> [    0.697876] pciehp 0000:00:1c.2:pcie04: service driver pciehp loaded
>> [    0.697886] pciehp 0000:00:1c.4:pcie04: HPC vendor_id 8086 device_id 2948 ss_vid 1462 ss_did 7360
>> [    0.697902] pciehp 0000:00:1c.4:pcie04: service driver pciehp loaded
>> [    0.697912] pciehp 0000:00:1c.5:pcie04: HPC vendor_id 8086 device_id 294a ss_vid 1462 ss_did 7360
>> [    0.697929] pciehp 0000:00:1c.5:pcie04: service driver pciehp loaded
>> [    0.697937] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
>> [    0.697939] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
>> [    0.698253] intel_idle: MWAIT substates: 0x20
>> [    0.698255] intel_idle: does not run on family 6 model 15
>> [    0.698326] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
>> [    0.698330] ACPI: Power Button [PWRB]
>> [    0.698375] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
>> [    0.698378] ACPI: Power Button [PWRF]
>> [    0.700070] ERST: Table is not found!
>> [    0.700072] GHES: HEST is not enabled!
>> [    0.700085] isapnp: Scanning for PnP cards...
>> [    1.055917] isapnp: No Plug & Play device found
>> [    1.056011] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
>> [    1.076497] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
>> [    1.097724] 00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
>> [    1.106358] Non-volatile memory driver v1.3
>> [    1.106360] Linux agpgart interface v0.103
>> [    1.107481] loop: module loaded
>> [    1.107541] ahci 0000:05:00.0: version 3.0
>> [    1.107565] ata_piix 0000:00:1f.2: version 2.13
>> [    1.107577] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
>> [    1.107581] ata_piix 0000:00:1f.2: MAP [ P0 -- P1 -- ]
>> [    1.107613] ata_piix 0000:00:1f.2: setting latency timer to 64
>> [    1.107848] scsi0 : ata_piix
>> [    1.107929] scsi1 : ata_piix
>> [    1.109107] ata1: SATA max UDMA/133 cmd 0x9000 ctl 0x8c00 bmdma 0x8480 irq 19
>> [    1.109111] ata2: SATA max UDMA/133 cmd 0x8880 ctl 0x8800 bmdma 0x8488 irq 19
>> [    1.109128] ata_piix 0000:00:1f.5: PCI INT B -> GSI 19 (level, low) -> IRQ 19
>> [    1.109134] ata_piix 0000:00:1f.5: MAP [ P0 -- P1 -- ]
>> [    1.109177] ata_piix 0000:00:1f.5: setting latency timer to 64
>> [    1.109401] scsi2 : ata_piix
>> [    1.109481] scsi3 : ata_piix
>> [    1.110534] ata3: SATA max UDMA/133 cmd 0x8000 ctl 0x7c00 bmdma 0x7480 irq 19
>> [    1.110538] ata4: SATA max UDMA/133 cmd 0x7880 ctl 0x7800 bmdma 0x7488 irq 19
>> [    1.110597] Fixed MDIO Bus: probed
>> [    1.110664] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
>> [    1.110677] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
>> [    1.110692] ehci_hcd 0000:00:1a.7: setting latency timer to 64
>> [    1.110695] ehci_hcd 0000:00:1a.7: EHCI Host Controller
>> [    1.110765] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
>> [    1.110787] ehci_hcd 0000:00:1a.7: debug port 1
>> [    1.114672] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
>> [    1.114686] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xf9fffc00
>> [    1.124019] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
>> [    1.124038] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
>> [    1.124041] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
>> [    1.124043] usb usb1: Product: EHCI Host Controller
>> [    1.124045] usb usb1: Manufacturer: Linux 3.2.10-3.fc16.i686.PAE ehci_hcd
>> [    1.124047] usb usb1: SerialNumber: 0000:00:1a.7
>> [    1.124164] hub 1-0:1.0: USB hub found
>> [    1.124168] hub 1-0:1.0: 4 ports detected
>> [    1.124239] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
>> [    1.124249] ehci_hcd 0000:00:1d.7: setting latency timer to 64
>> [    1.124252] ehci_hcd 0000:00:1d.7: EHCI Host Controller
>> [    1.124305] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
>> [    1.124325] ehci_hcd 0000:00:1d.7: debug port 1
>> [    1.128222] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
>> [    1.128235] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xf9fff800
>> [    1.138019] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
>> [    1.138032] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
>> [    1.138034] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
>> [    1.138036] usb usb2: Product: EHCI Host Controller
>> [    1.138038] usb usb2: Manufacturer: Linux 3.2.10-3.fc16.i686.PAE ehci_hcd
>> [    1.138040] usb usb2: SerialNumber: 0000:00:1d.7
>> [    1.138147] hub 2-0:1.0: USB hub found
>> [    1.138151] hub 2-0:1.0: 8 ports detected
>> [    1.138230] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
>> [    1.138243] uhci_hcd: USB Universal Host Controller Interface driver
>> [    1.138258] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
>> [    1.138265] uhci_hcd 0000:00:1a.0: setting latency timer to 64
>> [    1.138268] uhci_hcd 0000:00:1a.0: UHCI Host Controller
>> [    1.138322] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
>> [    1.138350] uhci_hcd 0000:00:1a.0: irq 16, io base 0x00009c00
>> [    1.138376] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
>> [    1.138378] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
>> [    1.138380] usb usb3: Product: UHCI Host Controller
>> [    1.138382] usb usb3: Manufacturer: Linux 3.2.10-3.fc16.i686.PAE uhci_hcd
>> [    1.138384] usb usb3: SerialNumber: 0000:00:1a.0
>> [    1.138490] hub 3-0:1.0: USB hub found
>> [    1.138493] hub 3-0:1.0: 2 ports detected
>> [    1.138559] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
>> [    1.138565] uhci_hcd 0000:00:1a.1: setting latency timer to 64
>> [    1.138568] uhci_hcd 0000:00:1a.1: UHCI Host Controller
>> [    1.138621] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
>> [    1.138649] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00009880
>> [    1.138674] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
>> [    1.138676] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
>> [    1.138679] usb usb4: Product: UHCI Host Controller
>> [    1.138680] usb usb4: Manufacturer: Linux 3.2.10-3.fc16.i686.PAE uhci_hcd
>> [    1.138682] usb usb4: SerialNumber: 0000:00:1a.1
>> [    1.138787] hub 4-0:1.0: USB hub found
>> [    1.138791] hub 4-0:1.0: 2 ports detected
>> [    1.138857] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
>> [    1.138864] uhci_hcd 0000:00:1d.0: setting latency timer to 64
>> [    1.138866] uhci_hcd 0000:00:1d.0: UHCI Host Controller
>> [    1.138918] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
>> [    1.138938] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00009800
>> [    1.138963] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
>> [    1.138965] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
>> [    1.138968] usb usb5: Product: UHCI Host Controller
>> [    1.138969] usb usb5: Manufacturer: Linux 3.2.10-3.fc16.i686.PAE uhci_hcd
>> [    1.138971] usb usb5: SerialNumber: 0000:00:1d.0
>> [    1.139081] hub 5-0:1.0: USB hub found
>> [    1.139085] hub 5-0:1.0: 2 ports detected
>> [    1.139154] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
>> [    1.139160] uhci_hcd 0000:00:1d.1: setting latency timer to 64
>> [    1.139163] uhci_hcd 0000:00:1d.1: UHCI Host Controller
>> [    1.139223] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
>> [    1.139245] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00009480
>> [    1.139270] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
>> [    1.139272] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
>> [    1.139274] usb usb6: Product: UHCI Host Controller
>> [    1.139276] usb usb6: Manufacturer: Linux 3.2.10-3.fc16.i686.PAE uhci_hcd
>> [    1.139278] usb usb6: SerialNumber: 0000:00:1d.1
>> [    1.139379] hub 6-0:1.0: USB hub found
>> [    1.139383] hub 6-0:1.0: 2 ports detected
>> [    1.139446] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
>> [    1.139453] uhci_hcd 0000:00:1d.2: setting latency timer to 64
>> [    1.139456] uhci_hcd 0000:00:1d.2: UHCI Host Controller
>> [    1.139508] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
>> [    1.139529] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00009400
>> [    1.139553] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
>> [    1.139556] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
>> [    1.139558] usb usb7: Product: UHCI Host Controller
>> [    1.139559] usb usb7: Manufacturer: Linux 3.2.10-3.fc16.i686.PAE uhci_hcd
>> [    1.139561] usb usb7: SerialNumber: 0000:00:1d.2
>> [    1.139660] hub 7-0:1.0: USB hub found
>> [    1.139663] hub 7-0:1.0: 2 ports detected
>> [    1.139727] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
>> [    1.139733] uhci_hcd 0000:00:1d.3: setting latency timer to 64
>> [    1.139736] uhci_hcd 0000:00:1d.3: UHCI Host Controller
>> [    1.139787] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 8
>> [    1.139808] uhci_hcd 0000:00:1d.3: irq 16, io base 0x00009080
>> [    1.139832] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
>> [    1.139835] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
>> [    1.139837] usb usb8: Product: UHCI Host Controller
>> [    1.139839] usb usb8: Manufacturer: Linux 3.2.10-3.fc16.i686.PAE uhci_hcd
>> [    1.139841] usb usb8: SerialNumber: 0000:00:1d.3
>> [    1.139939] hub 8-0:1.0: USB hub found
>> [    1.139943] hub 8-0:1.0: 2 ports detected
>> [    1.140061] usbcore: registered new interface driver usbserial
>> [    1.140070] USB Serial support registered for generic
>> [    1.140083] usbcore: registered new interface driver usbserial_generic
>> [    1.140085] usbserial: USB Serial Driver core
>> [    1.140144] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
>> [    1.142542] serio: i8042 KBD port at 0x60,0x64 irq 1
>> [    1.142548] serio: i8042 AUX port at 0x60,0x64 irq 12
>> [    1.142650] mousedev: PS/2 mouse device common for all mice
>> [    1.142850] rtc_cmos 00:03: RTC can wake from S4
>> [    1.142965] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
>> [    1.142985] rtc0: alarms up to one month, y3k, 114 bytes nvram
>> [    1.143049] device-mapper: uevent: version 1.0.3
>> [    1.143129] device-mapper: ioctl: 4.22.0-ioctl (2011-10-19) initialised: dm-devel@redhat.com
>> [    1.143173] cpuidle: using governor ladder
>> [    1.143175] cpuidle: using governor menu
>> [    1.143310] EFI Variables Facility v0.08 2004-May-17
>> [    1.143451] usbcore: registered new interface driver usbhid
>> [    1.143453] usbhid: USB HID core driver
>> [    1.143499] ip_tables: (C) 2000-2006 Netfilter Core Team
>> [    1.143510] TCP cubic registered
>> [    1.143512] Initializing XFRM netlink socket
>> [    1.143626] NET: Registered protocol family 10
>> [    1.143745] Mobile IPv6
>> [    1.143748] NET: Registered protocol family 17
>> [    1.143759] Registering the dns_resolver key type
>> [    1.143773] Using IPI No-Shortcut mode
>> [    1.143895] PM: Hibernation image not present or could not be loaded.
>> [    1.143909] registered taskstats version 1
>> [    1.149523]   Magic number: 4:185:899
>> [    1.149603] rtc_cmos 00:03: setting system clock to 2012-03-26 18:51:35 UTC (1332787895)
>> [    1.150476] Initializing network drop monitor service
>> [    1.161406] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
>> [    1.425771] ata3: SATA link down (SStatus 0 SControl 300)
>> [    1.512378] input: PS2++ Logitech Wheel Mouse as /devices/platform/i8042/serio1/input/input3
>> [    1.565064] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [    1.565168] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [    1.576064] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> [    1.580317] ata4.00: ATA-7: Maxtor 7V250F0, VA111630, max UDMA/133
>> [    1.580321] ata4.00: 490234752 sectors, multi 16: LBA48 NCQ (depth 0/32)
>> [    1.581021] usb 4-1: new low-speed USB device number 2 using uhci_hcd
>> [    1.587163] ata4.00: configured for UDMA/133
>> [    1.608220] ata2.00: ATA-7: ST3320620AS, 3.AAJ, max UDMA/133
>> [    1.608223] ata2.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 0/32)
>> [    1.616082] ata1.00: ATA-7: ST3320620AS, 3.AAJ, max UDMA/133
>> [    1.616086] ata1.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 0/32)
>> [    1.662033] Refined TSC clocksource calibration: 2402.378 MHz.
>> [    1.662038] Switching to clocksource tsc
>> [    1.683190] ata2.00: configured for UDMA/133
>> [    1.691047] ata1.00: configured for UDMA/133
>> [    1.691200] scsi 0:0:0:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI: 5
>> [    1.691402] sd 0:0:0:0: [sda] 625142448 512-byte logical blocks: (320 GB/298 GiB)
>> [    1.691414] sd 0:0:0:0: Attached scsi generic sg0 type 0
>> [    1.691473] sd 0:0:0:0: [sda] Write Protect is off
>> [    1.691477] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
>> [    1.691511] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>> [    1.691657] scsi 1:0:0:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI: 5
>> [    1.691878] sd 1:0:0:0: [sdb] 625142448 512-byte logical blocks: (320 GB/298 GiB)
>> [    1.691889] sd 1:0:0:0: Attached scsi generic sg1 type 0
>> [    1.691988] sd 1:0:0:0: [sdb] Write Protect is off
>> [    1.691992] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
>> [    1.692032] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>> [    1.692091] scsi 3:0:0:0: Direct-Access     ATA      Maxtor 7V250F0   VA11 PQ: 0 ANSI: 5
>> [    1.692268] sd 3:0:0:0: [sdc] 490234752 512-byte logical blocks: (251 GB/233 GiB)
>> [    1.692310] sd 3:0:0:0: Attached scsi generic sg2 type 0
>> [    1.692360] sd 3:0:0:0: [sdc] Write Protect is off
>> [    1.692364] sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
>> [    1.692393] sd 3:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>> [    1.715627]  sdc: sdc1
>> [    1.715885] sd 3:0:0:0: [sdc] Attached SCSI disk
>> [    1.722872]  sdb: sdb1 sdb2 sdb3
>> [    1.723190] sd 1:0:0:0: [sdb] Attached SCSI disk
>> [    1.730721]  sda: sda1 sda2 sda3
>> [    1.730990] sd 0:0:0:0: [sda] Attached SCSI disk
>> [    1.731061] Freeing unused kernel memory: 644k freed
>> [    1.731261] Write protecting the kernel text: 5408k
>> [    1.731315] Write protecting the kernel read-only data: 2096k
>> [    1.731319] NX-protecting the kernel data: 4832k
>> [    1.768691] usb 4-1: New USB device found, idVendor=051d, idProduct=0002
>> [    1.768696] usb 4-1: New USB device strings: Mfr=3, Product=1, SerialNumber=2
>> [    1.768700] usb 4-1: Product: APC ES 725 FW:821.y2 .A USB FW:y2
>> [    1.768703] usb 4-1: Manufacturer: APC
>> [    1.768706] usb 4-1: SerialNumber: 3B0628X18842
>> [    1.867527] dracut: dracut-013-20.fc16
>> [    1.892049] udevd[122]: starting version 173
>> [    1.960670] dracut: Starting plymouth daemon
>> [    2.056749] sata_sil24 0000:03:00.0: version 1.1
>> [    2.056771] sata_sil24 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
>> [    2.056826] sata_sil24 0000:03:00.0: setting latency timer to 64
>> [    2.059272] pata_marvell 0000:05:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
>> [    2.059303] pata_marvell 0000:05:00.0: setting latency timer to 64
>> [    2.061729] scsi5 : pata_marvell
>> [    2.062173] scsi4 : sata_sil24
>> [    2.062765] scsi7 : sata_sil24
>> [    2.062830] ata5: SATA max UDMA/100 host m128@0xfe8ffc00 port 0xfe8f8000 irq 17
>> [    2.062835] ata6: SATA max UDMA/100 host m128@0xfe8ffc00 port 0xfe8fa000 irq 17
>> [    2.062874] sata_sil24 0000:04:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
>> [    2.062881] scsi6 : pata_marvell
>> [    2.062942] sata_sil24 0000:04:00.0: setting latency timer to 64
>> [    2.062948] ata7: PATA max UDMA/100 cmd 0xdc00 ctl 0xd880 bmdma 0xd400 irq 16
>> [    2.062952] ata8: PATA max UDMA/133 cmd 0xd800 ctl 0xd480 bmdma 0xd408 irq 16
>> [    2.065053] scsi8 : sata_sil24
>> [    2.065207] scsi9 : sata_sil24
>> [    2.065259] ata9: SATA max UDMA/100 host m128@0xfe9ffc00 port 0xfe9f8000 irq 18
>> [    2.065263] ata10: SATA max UDMA/100 host m128@0xfe9ffc00 port 0xfe9fa000 irq 18
>> [    2.217434] ata7.00: ATAPI: HL-DT-STDVD-RAM GSA-H58N, 1.03, max UDMA/66
>> [    2.221802] mdadm: sending ioctl 800c0910 to a partition!
>> [    2.221806] mdadm: sending ioctl 800c0910 to a partition!
>> [    2.221889] mdadm: sending ioctl 1261 to a partition!
>> [    2.221891] mdadm: sending ioctl 1261 to a partition!
>> [    2.223422] ata7.00: configured for UDMA/66
>> [    2.235804] generic-usb 0003:051D:0002.0001: hiddev0,hidraw0: USB HID v1.10 Device [APC APC ES 725 FW:821.y2 .A USB FW:y2 ] on usb-0000:00:1a.1-1/input0
>> [    2.243045] mdadm: sending ioctl 800c0910 to a partition!
>> [    2.243048] mdadm: sending ioctl 800c0910 to a partition!
>> [    2.243137] mdadm: sending ioctl 1261 to a partition!
>> [    2.243139] mdadm: sending ioctl 1261 to a partition!
>> [    2.255680] mdadm: sending ioctl 800c0910 to a partition!
>> [    2.255684] mdadm: sending ioctl 800c0910 to a partition!
>> [    2.278604] md: bind<sdb1>
>> [    2.280946] md: bind<sda1>
>> [    2.283163] md: raid1 personality registered for level 1
>> [    4.082034] ata5: SATA link down (SStatus 0 SControl 0)
>> [    4.197035] ata9: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [    4.197372] ata9.15: Port Multiplier 1.1, 0x1095:0x3726 r23, 6 ports, feat 0x1/0x9
>> [    4.199141] ata9.00: hard resetting link
>> [    4.537254] ata9.00: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
>> [    4.537290] ata9.01: hard resetting link
>> [    4.963015] ata9.01: softreset failed (SRST command error)
>> [    5.073014] ata9.01: failed to read SCR 0 (Emask=0x1)
>> [    5.073019] ata9.01: reset failed (errno=-85), retrying in 10 secs
>> [    6.102041] ata6: SATA link down (SStatus 0 SControl 0)
>> [    6.103522] scsi 5:0:0:0: CD-ROM            HL-DT-ST DVD-RAM GSA-H58N 1.03 PQ: 0 ANSI: 5
>> [    6.106341] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
>> [    6.106345] cdrom: Uniform CD-ROM driver Revision: 3.20
>> [    6.106541] sr 5:0:0:0: Attached scsi CD-ROM sr0
>> [    6.106728] sr 5:0:0:0: Attached scsi generic sg3 type 5
>> [   14.537112] ata9.01: reset failed, giving up
>> [   14.537117] ata9.15: hard resetting link
>> [   14.537120] ata9: controller in dubious state, performing PORT_RST
>> [   16.691040] ata9.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [   16.691389] ata9.00: hard resetting link
>> [   17.029255] ata9.00: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
>> [   17.029290] ata9.01: hard resetting link
>> [   17.367252] ata9.01: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> [   17.367287] ata9.02: hard resetting link
>> [   17.683040] ata9.02: softreset failed (SRST command error)
>> [   17.683099] ata9.02: failed to read SCR 0 (Emask=0x1)
>> [   17.683103] ata9.02: reset failed (errno=-85), retrying in 10 secs
>> [   27.367023] ata9.02: reset failed, giving up
>> [   27.367028] ata9.15: hard resetting link
>> [   29.488078] ata9.15: softreset failed (SRST command error)
>> [   29.488082] ata9.15: reset failed (errno=-5), retrying in 8 secs
>> [   37.367018] ata9.15: hard resetting link
>> [   39.488071] ata9.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [   39.488077] ata9.15: PMP revalidation failed (errno=-19)
>> [   44.488012] ata9.15: hard resetting link
>> [   46.620040] ata9.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [   46.620470] ata9.00: hard resetting link
>> [   46.958247] ata9.00: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
>> [   46.958285] ata9.01: hard resetting link
>> [   47.296247] ata9.01: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> [   47.296284] ata9.02: hard resetting link
>> [   47.634249] ata9.02: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> [   47.634286] ata9.03: hard resetting link
>> [   48.060017] ata9.03: softreset failed (SRST command error)
>> [   48.060035] ata9.03: failed to read SCR 0 (Emask=0x40)
>> [   48.060038] ata9.03: reset failed (errno=-85), retrying in 10 secs
>> [   57.634037] ata9.03: reset failed, giving up
>> [   57.634041] ata9.15: hard resetting link
>> [   57.634043] ata9: controller in dubious state, performing PORT_RST
>> [   59.788039] ata9.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [   59.788377] ata9.00: hard resetting link
>> [   60.126253] ata9.00: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
>> [   60.126289] ata9.01: hard resetting link
>> [   60.464250] ata9.01: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> [   60.464285] ata9.02: hard resetting link
>> [   60.802251] ata9.02: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> [   60.802286] ata9.03: hard resetting link
>> [   61.140252] ata9.03: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> [   61.140287] ata9.04: hard resetting link
>> [   61.445390] ata9.04: SATA link down (SStatus 0 SControl 320)
>> [   61.445457] ata9.05: hard resetting link
>> [   61.750359] ata9.05: SATA link up 1.5 Gbps (SStatus 113 SControl 320)
>> [   61.779136] ata9.00: ATA-8: ST31500341AS, CC1H, max UDMA/133
>> [   61.779141] ata9.00: 2930277168 sectors, multi 16: LBA48 NCQ (depth 31/32)
>> [   61.821129] ata9.00: configured for UDMA/100
>> [   61.849775] ata9.01: ATA-8: ST31500341AS, CC1H, max UDMA/133
>> [   61.849779] ata9.01: 2930277168 sectors, multi 0: LBA48 NCQ (depth 31/32)
>> [   61.891640] ata9.01: configured for UDMA/100
>> [   61.920328] ata9.02: ATA-8: ST31500341AS, CC1H, max UDMA/133
>> [   61.920333] ata9.02: 2930277168 sectors, multi 0: LBA48 NCQ (depth 31/32)
>> [   61.962282] ata9.02: configured for UDMA/100
>> [   61.990999] ata9.03: ATA-8: ST31500341AS, CC1H, max UDMA/133
>> [   61.991009] ata9.03: 2930277168 sectors, multi 0: LBA48 NCQ (depth 31/32)
>> [   62.032997] ata9.03: configured for UDMA/100
>> [   62.033088] ata9: EH complete
>> [   62.033219] scsi 8:0:0:0: Direct-Access     ATA      ST31500341AS     CC1H PQ: 0 ANSI: 5
>> [   62.033413] sd 8:0:0:0: [sdd] 2930277168 512-byte logical blocks: (1.50 TB/1.36 TiB)
>> [   62.033453] sd 8:0:0:0: Attached scsi generic sg4 type 0
>> [   62.033511] sd 8:0:0:0: [sdd] Write Protect is off
>> [   62.033516] sd 8:0:0:0: [sdd] Mode Sense: 00 3a 00 00
>> [   62.033557] sd 8:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>> [   62.033638] scsi 8:1:0:0: Direct-Access     ATA      ST31500341AS     CC1H PQ: 0 ANSI: 5
>> [   62.033810] sd 8:1:0:0: [sde] 2930277168 512-byte logical blocks: (1.50 TB/1.36 TiB)
>> [   62.033898] sd 8:1:0:0: [sde] Write Protect is off
>> [   62.033902] sd 8:1:0:0: [sde] Mode Sense: 00 3a 00 00
>> [   62.033939] sd 8:1:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>> [   62.033977] sd 8:1:0:0: Attached scsi generic sg5 type 0
>> [   62.034257] scsi 8:2:0:0: Direct-Access     ATA      ST31500341AS     CC1H PQ: 0 ANSI: 5
>> [   62.034426] sd 8:2:0:0: [sdf] 2930277168 512-byte logical blocks: (1.50 TB/1.36 TiB)
>> [   62.034514] sd 8:2:0:0: [sdf] Write Protect is off
>> [   62.034518] sd 8:2:0:0: [sdf] Mode Sense: 00 3a 00 00
>> [   62.034554] sd 8:2:0:0: Attached scsi generic sg6 type 0
>> [   62.034563] sd 8:2:0:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>> [   62.034743] scsi 8:3:0:0: Direct-Access     ATA      ST31500341AS     CC1H PQ: 0 ANSI: 5
>> [   62.034910] sd 8:3:0:0: [sdg] 2930277168 512-byte logical blocks: (1.50 TB/1.36 TiB)
>> [   62.034954] sd 8:3:0:0: Attached scsi generic sg7 type 0
>> [   62.035000] sd 8:3:0:0: [sdg] Write Protect is off
>> [   62.035011] sd 8:3:0:0: [sdg] Mode Sense: 00 3a 00 00
>> [   62.035063] sd 8:3:0:0: [sdg] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>> [   62.041037]  sdd: unknown partition table
>> [   62.041278] sd 8:0:0:0: [sdd] Attached SCSI disk
>> [   62.055364]  sde: unknown partition table
>> [   62.055517] sd 8:1:0:0: [sde] Attached SCSI disk
>> [   62.059238]  sdf: unknown partition table
>> [   62.059395] sd 8:2:0:0: [sdf] Attached SCSI disk
>> [   62.060249]  sdg: unknown partition table
>> [   62.060399] sd 8:3:0:0: [sdg] Attached SCSI disk
>> [   64.167041] ata10: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [   64.167363] ata10.15: Port Multiplier 1.1, 0x1095:0x3726 r23, 6 ports, feat 0x1/0x9
>> [   64.169254] ata10.00: hard resetting link
>> [   64.573260] ata10.00: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
>> [   64.573299] ata10.01: hard resetting link
>> [   64.999017] ata10.01: softreset failed (SRST command error)
>> [   64.999034] ata10.01: failed to read SCR 0 (Emask=0x40)
>> [   64.999038] ata10.01: reset failed (errno=-85), retrying in 10 secs
>> [   74.573049] ata10.01: reset failed, giving up
>> [   74.573058] ata10.15: hard resetting link
>> [   74.573061] ata10: controller in dubious state, performing PORT_RST
>> [   76.727039] ata10.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [   76.727371] ata10.00: hard resetting link
>> [   77.131252] ata10.00: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
>> [   77.131287] ata10.01: hard resetting link
>> [   77.535261] ata10.01: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> [   77.535297] ata10.02: hard resetting link
>> [   77.851041] ata10.02: softreset failed (SRST command error)
>> [   77.961014] ata10.02: failed to read SCR 0 (Emask=0x1)
>> [   77.961018] ata10.02: reset failed (errno=-85), retrying in 10 secs
>> [   87.535028] ata10.02: reset failed, giving up
>> [   87.535033] ata10.15: hard resetting link
>> [   87.535035] ata10: controller in dubious state, performing PORT_RST
>> [   89.689041] ata10.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [   89.689414] ata10.00: hard resetting link
>> [   90.093265] ata10.00: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
>> [   90.093303] ata10.01: hard resetting link
>> [   90.497259] ata10.01: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> [   90.497296] ata10.02: hard resetting link
>> [   90.901259] ata10.02: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> [   90.901296] ata10.03: hard resetting link
>> [   91.327009] ata10.03: softreset failed (SRST command error)
>> [   91.327024] ata10.03: failed to read SCR 0 (Emask=0x40)
>> [   91.327026] ata10.03: reset failed (errno=-85), retrying in 10 secs
>> [  100.901043] ata10.03: reset failed, giving up
>> [  100.901048] ata10.15: hard resetting link
>> [  100.901051] ata10: controller in dubious state, performing PORT_RST
>> [  103.055046] ata10.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [  103.055433] ata10.00: hard resetting link
>> [  103.459260] ata10.00: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
>> [  103.459296] ata10.01: hard resetting link
>> [  103.863260] ata10.01: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> [  103.863296] ata10.02: hard resetting link
>> [  104.267287] ata10.02: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> [  104.267332] ata10.03: hard resetting link
>> [  104.671261] ata10.03: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> [  104.671297] ata10.04: hard resetting link
>> [  104.976391] ata10.04: SATA link down (SStatus 0 SControl 320)
>> [  104.976458] ata10.05: hard resetting link
>> [  105.281363] ata10.05: SATA link up 1.5 Gbps (SStatus 113 SControl 320)
>> [  105.282235] ata10.00: ATA-8: Hitachi HDP725050GLA360, GM4OA50E, max UDMA/133
>> [  105.282240] ata10.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
>> [  105.283269] ata10.00: configured for UDMA/100
>> [  105.303836] ata10.01: ATA-8: Hitachi HDP725050GLA360, GM4OA50E, max UDMA/133
>> [  105.303840] ata10.01: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
>> [  105.304715] ata10.01: configured for UDMA/100
>> [  105.319063] ata10.02: ATA-8: Hitachi HDP725050GLA360, GM4OA50E, max UDMA/133
>> [  105.319067] ata10.02: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
>> [  105.319948] ata10.02: configured for UDMA/100
>> [  105.333306] ata10.03: ATA-8: Hitachi HDP725050GLA360, GM4OA50E, max UDMA/133
>> [  105.333310] ata10.03: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
>> [  105.334189] ata10.03: configured for UDMA/100
>> [  105.334259] ata10: EH complete
>> [  105.334390] scsi 9:0:0:0: Direct-Access     ATA      Hitachi HDP72505 GM4O PQ: 0 ANSI: 5
>> [  105.334575] sd 9:0:0:0: [sdh] 976773168 512-byte logical blocks: (500 GB/465 GiB)
>> [  105.334617] sd 9:0:0:0: Attached scsi generic sg8 type 0
>> [  105.334672] sd 9:0:0:0: [sdh] Write Protect is off
>> [  105.334676] sd 9:0:0:0: [sdh] Mode Sense: 00 3a 00 00
>> [  105.334717] sd 9:0:0:0: [sdh] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>> [  105.334785] scsi 9:1:0:0: Direct-Access     ATA      Hitachi HDP72505 GM4O PQ: 0 ANSI: 5
>> [  105.334954] sd 9:1:0:0: [sdi] 976773168 512-byte logical blocks: (500 GB/465 GiB)
>> [  105.335040] sd 9:1:0:0: [sdi] Write Protect is off
>> [  105.335044] sd 9:1:0:0: [sdi] Mode Sense: 00 3a 00 00
>> [  105.335076] sd 9:1:0:0: [sdi] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>> [  105.335274] sd 9:1:0:0: Attached scsi generic sg9 type 0
>> [  105.335459] scsi 9:2:0:0: Direct-Access     ATA      Hitachi HDP72505 GM4O PQ: 0 ANSI: 5
>> [  105.335626] sd 9:2:0:0: [sdj] 976773168 512-byte logical blocks: (500 GB/465 GiB)
>> [  105.335714] sd 9:2:0:0: [sdj] Write Protect is off
>> [  105.335718] sd 9:2:0:0: [sdj] Mode Sense: 00 3a 00 00
>> [  105.335757] sd 9:2:0:0: [sdj] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>> [  105.335766] sd 9:2:0:0: Attached scsi generic sg10 type 0
>> [  105.335938] scsi 9:3:0:0: Direct-Access     ATA      Hitachi HDP72505 GM4O PQ: 0 ANSI: 5
>> [  105.336111] sd 9:3:0:0: [sdk] 976773168 512-byte logical blocks: (500 GB/465 GiB)
>> [  105.336161] sd 9:3:0:0: Attached scsi generic sg11 type 0
>> [  105.336202] sd 9:3:0:0: [sdk] Write Protect is off
>> [  105.336206] sd 9:3:0:0: [sdk] Mode Sense: 00 3a 00 00
>> [  105.336260] sd 9:3:0:0: [sdk] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>> [  105.346322]  sdh: unknown partition table
>> [  105.346554] sd 9:0:0:0: [sdh] Attached SCSI disk
>> [  105.360434]  sdj: unknown partition table
>> [  105.360598] sd 9:2:0:0: [sdj] Attached SCSI disk
>> [  105.361877]  sdi: unknown partition table
>> [  105.362042] sd 9:1:0:0: [sdi] Attached SCSI disk
>> [  105.366343]  sdk: unknown partition table
>> [  105.366502] sd 9:3:0:0: [sdk] Attached SCSI disk
>> [  105.366688] bio: create slab <bio-1> at 1
>> [  105.366782] md/raid1:md0: active with 2 out of 2 mirrors
>> [  105.366819] md0: detected capacity change from 0 to 314507264
>> [  105.385841]  md0:
>> [  105.387349] scsi_verify_blk_ioctl: 122 callbacks suppressed
>> [  105.387352] mdadm: sending ioctl 1261 to a partition!
>> [  105.387355] mdadm: sending ioctl 1261 to a partition!
>> [  105.445648] mdadm: sending ioctl 1261 to a partition!
>> [  105.445651] mdadm: sending ioctl 1261 to a partition!
>> [  105.475825] mdadm: sending ioctl 1261 to a partition!
>> [  105.475828] mdadm: sending ioctl 1261 to a partition!
>> [  105.482162] md: bind<sdg>
>> [  105.485146] md: bind<sdf>
>> [  105.488262] md: bind<sde>
>> [  105.491687] md: bind<sdd>
>> [  105.494574] async_tx: api initialized (async)
>> [  105.494927] xor: automatically using best checksumming function: pIII_sse
>> [  105.499004]    pIII_sse  :  8432.000 MB/sec
>> [  105.499006] xor: using function: pIII_sse (8432.000 MB/sec)
>> [  105.508257] mdadm: sending ioctl 1261 to a partition!
>> [  105.508260] mdadm: sending ioctl 1261 to a partition!
>> [  105.516064] raid6: int32x1    902 MB/s
>> [  105.533042] raid6: int32x2    773 MB/s
>> [  105.550091] raid6: int32x4    714 MB/s
>> [  105.567020] raid6: int32x8    796 MB/s
>> [  105.584015] raid6: mmxx1     3160 MB/s
>> [  105.601018] raid6: mmxx2     3523 MB/s
>> [  105.618010] raid6: sse1x1    2062 MB/s
>> [  105.635022] raid6: sse1x2    2734 MB/s
>> [  105.652017] raid6: sse2x1    3707 MB/s
>> [  105.669017] raid6: sse2x2    4906 MB/s
>> [  105.669018] raid6: using algorithm sse2x2 (4906 MB/s)
>> [  105.669800] md: raid6 personality registered for level 6
>> [  105.669802] md: raid5 personality registered for level 5
>> [  105.669804] md: raid4 personality registered for level 4
>> [  105.669950] md/raid:md6: device sdd operational as raid disk 0
>> [  105.669952] md/raid:md6: device sde operational as raid disk 1
>> [  105.669954] md/raid:md6: device sdf operational as raid disk 2
>> [  105.669956] md/raid:md6: device sdg operational as raid disk 3
>> [  105.670311] md/raid:md6: allocated 4216kB
>> [  105.670342] md/raid:md6: raid level 5 active with 4 out of 4 devices, algorithm 2
>> [  105.670344] RAID conf printout:
>> [  105.670345]  --- level:5 rd:4 wd:4
>> [  105.670347]  disk 0, o:1, dev:sdd
>> [  105.670349]  disk 1, o:1, dev:sde
>> [  105.670350]  disk 2, o:1, dev:sdf
>> [  105.670352]  disk 3, o:1, dev:sdg
>> [  105.670377] md6: detected capacity change from 0 to 4500897595392
>> [  105.672274] md: bind<sdk>
>> [  105.673419]  md6: unknown partition table
>> [  105.675966] md: bind<sdj>
>> [  105.679622] md: bind<sdi>
>> [  105.683718] md: bind<sdh>
>> [  105.687032] md/raid:md7: device sdh operational as raid disk 1
>> [  105.687035] md/raid:md7: device sdi operational as raid disk 0
>> [  105.687037] md/raid:md7: device sdj operational as raid disk 2
>> [  105.687038] md/raid:md7: device sdk operational as raid disk 3
>> [  105.687363] md/raid:md7: allocated 4216kB
>> [  105.687395] md/raid:md7: raid level 5 active with 4 out of 4 devices, algorithm 2
>> [  105.687397] RAID conf printout:
>> [  105.687398]  --- level:5 rd:4 wd:4
>> [  105.687400]  disk 0, o:1, dev:sdi
>> [  105.687401]  disk 1, o:1, dev:sdh
>> [  105.687403]  disk 2, o:1, dev:sdj
>> [  105.687404]  disk 3, o:1, dev:sdk
>> [  105.687428] md7: detected capacity change from 0 to 1500315451392
>> [  105.689250]  md7: unknown partition table
>> [  140.072536] dracut Warning: No root device "block:/dev/disk/by-uuid/773cb4b3-4bb0-4705-b494-08cb9c2b5d73" found
> ------

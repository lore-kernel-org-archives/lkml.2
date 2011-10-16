Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922Ab1JPBAG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 21:00:06 -0400
Received: from amber.ccs.neu.edu ([129.10.116.51]:46012 "EHLO
	amber.ccs.neu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793Ab1JPBAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 21:00:04 -0400
Date: Sat, 15 Oct 2011 21:00:00 -0400
From: Jim Faulkner <jfaulkne@ccs.neu.edu>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: Bug: Dell Latitude E6400: reboot hangs when system has been
	suspended
Message-ID: <20111016010000.GA14979@alumni-linux.ccs.neu.edu>
References: <20111015234748.GA12232@alumni-linux.ccs.neu.edu> <4E9A2A1C.5010903@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="3MwIy2ne0vdjdPXF"
Content-Disposition: inline
In-Reply-To: <4E9A2A1C.5010903@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Sun, Oct 16, 2011 at 06:19:32AM +0530, Srivatsa S. Bhat wrote:
> 
> On 10/16/2011 05:17 AM, Jim Faulkner wrote:
> > Hi, rebooting hangs on my Dell Latitude E6400 after the system has been
> > suspended.  The system prints "Restarting system" but freezes, and I
> > have to hold the power button to shut down the system.
> 
> Can you also provide the log of suspend/resume? And did you face any
> problems while resuming the system after suspending it?

I've attached my dmesg after suspending and resuming the system.  Please
let me know if you need any other logs.

I have not seen any other problems related to suspend/resume.


--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="dmesg-after-suspend-resume.txt"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.0.6 (root@sandbox) (gcc version 4.5.3 (Gentoo 4.5.3-r1 p1.0, pie-0.4.5) ) #1 SMP PREEMPT Sat Oct 8 19:08:03 EDT 2011
[    0.000000] Command line: root=/dev/sda4 rootfstype=ext4 processor.ignore_ppc=1 processor.ignore_tpc=1 reboot=force resume=/dev/sda3
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
[    0.000000]  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000df44d400 (usable)
[    0.000000]  BIOS-e820: 00000000df44f400 - 00000000e0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000f8000000 - 00000000fc000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed18000 - 00000000fed1c000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed20000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000feda0000 - 00000000feda6000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffe60000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100002000 - 0000000120000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] DMI: Dell Inc. Latitude E6400                  /0G868N, BIOS A29 04/13/2011
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x120000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask 800000000 write-back
[    0.000000]   1 base 0E0000000 mask FE0000000 uncachable
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] original variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 32GB, type WB
[    0.000000] reg 1, base: 3584MB, range: 512MB, type UC
[    0.000000] total RAM covered: 32256M
[    0.000000] Found optimal setting for mtrr clean up
[    0.000000]  gran_size: 64K 	chunk_size: 1G 	num_reg: 5  	lose cover RAM: 0G
[    0.000000] New variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 4GB, type WB
[    0.000000] reg 1, base: 3584MB, range: 512MB, type UC
[    0.000000] reg 2, base: 4GB, range: 4GB, type WB
[    0.000000] reg 3, base: 8GB, range: 8GB, type WB
[    0.000000] reg 4, base: 16GB, range: 16GB, type WB
[    0.000000] e820 update range: 00000000e0000000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xdf44d max_arch_pfn = 0x400000000
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff88000009a000] 9a000 size 20480
[    0.000000] init_memory_mapping: 0000000000000000-00000000df44d000
[    0.000000]  0000000000 - 00df400000 page 2M
[    0.000000]  00df400000 - 00df44d000 page 4k
[    0.000000] kernel direct mapping tables up to df44d000 @ df447000-df44d000
[    0.000000] init_memory_mapping: 0000000100000000-0000000120000000
[    0.000000]  0100000000 - 0120000000 page 2M
[    0.000000] kernel direct mapping tables up to 120000000 @ 11fffa000-120000000
[    0.000000] ACPI: RSDP 00000000000fb9c0 00024 (v02 DELL  )
[    0.000000] ACPI: XSDT 00000000df451e00 0006C (v01 DELL    M09     27DB040D ASL  00000061)
[    0.000000] ACPI: FACP 00000000df451c9c 000F4 (v04 DELL    M09     27DB040D ASL  00000061)
[    0.000000] ACPI: DSDT 00000000df452400 06E14 (v02 INT430 SYSFexxx 00001001 INTL 20050624)
[    0.000000] ACPI: FACS 00000000df460c00 00040
[    0.000000] ACPI: HPET 00000000df451f00 00038 (v01 DELL    M09     00000001 ASL  00000061)
[    0.000000] ACPI: DMAR 00000000df460400 000B0 (v01 DELL    M09     27DB040D ASL  00000061)
[    0.000000] ACPI: APIC 00000000df452000 00068 (v01 DELL    M09     27DB040D ASL  00000047)
[    0.000000] ACPI: ASF! 00000000df451c00 0006A (v32 DELL    M09     27DB040D ASL  00000061)
[    0.000000] ACPI: MCFG 00000000df451fc0 0003C (v16 DELL    M09     27DB040D ASL  00000061)
[    0.000000] ACPI: TCPA 00000000df452300 00032 (v01                 00000000 ASL  00000000)
[    0.000000] ACPI: SLIC 00000000df45209c 00176 (v01 DELL    M09     27DB040D ASL  00000061)
[    0.000000] ACPI: SSDT 00000000df45032d 0066C (v01  PmRef    CpuPm 00003000 INTL 20050624)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000]  [ffffea0000000000-ffffea0003ffffff] PMD -> [ffff88011b600000-ffff88011effffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00120000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000df44d
[    0.000000]     0: 0x00100002 -> 0x00120000
[    0.000000] On node 0 totalpages: 1045466
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 5 pages reserved
[    0.000000]   DMA zone: 3922 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 896133 pages, LIFO batch:31
[    0.000000]   Normal zone: 1792 pages used for memmap
[    0.000000]   Normal zone: 129278 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000df44d000 - 00000000df450000
[    0.000000] PM: Registered nosave memory: 00000000df450000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f8000000
[    0.000000] PM: Registered nosave memory: 00000000f8000000 - 00000000fc000000
[    0.000000] PM: Registered nosave memory: 00000000fc000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec10000
[    0.000000] PM: Registered nosave memory: 00000000fec10000 - 00000000fed18000
[    0.000000] PM: Registered nosave memory: 00000000fed18000 - 00000000fed1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed20000
[    0.000000] PM: Registered nosave memory: 00000000fed20000 - 00000000fed90000
[    0.000000] PM: Registered nosave memory: 00000000fed90000 - 00000000feda0000
[    0.000000] PM: Registered nosave memory: 00000000feda0000 - 00000000feda6000
[    0.000000] PM: Registered nosave memory: 00000000feda6000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee10000
[    0.000000] PM: Registered nosave memory: 00000000fee10000 - 00000000ffe60000
[    0.000000] PM: Registered nosave memory: 00000000ffe60000 - 0000000100000000
[    0.000000] PM: Registered nosave memory: 0000000100000000 - 0000000100002000
[    0.000000] Allocating PCI resources starting at e0000000 (gap: e0000000:18000000)
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 25 pages/cpu @ffff88011fc00000 s70144 r8192 d24064 u1048576
[    0.000000] pcpu-alloc: s70144 r8192 d24064 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1029333
[    0.000000] Kernel command line: root=/dev/sda4 rootfstype=ext4 processor.ignore_ppc=1 processor.ignore_tpc=1 reboot=force resume=/dev/sda3
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.000000] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.000000] xsave/xrstor: enabled xstate_bv 0x3, cntxt size 0x240
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 4037944k/4718592k available (5687k kernel code, 536728k absent, 143920k reserved, 5059k data, 472k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	Verbose stalled-CPUs detection is disabled.
[    0.000000] NR_IRQS:512
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 33554432 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2526.677 MHz processor.
[    0.002003] Calibrating delay loop (skipped), value calculated using timer frequency.. 5053.35 BogoMIPS (lpj=2526677)
[    0.002302] pid_max: default: 32768 minimum: 301
[    0.002497] Security Framework initialized
[    0.002669] Mount-cache hash table entries: 256
[    0.002981] Initializing cgroup subsys cpuacct
[    0.003009] Initializing cgroup subsys memory
[    0.003169] Initializing cgroup subsys freezer
[    0.003323] Initializing cgroup subsys blkio
[    0.003499] CPU: Physical Processor ID: 0
[    0.003653] CPU: Processor Core ID: 0
[    0.003795] mce: CPU supports 6 MCE banks
[    0.004007] CPU0: Thermal monitoring enabled (TM2)
[    0.004164] using mwait in idle threads.
[    0.004357] ACPI: Core revision 20110413
[    0.007052] DMAR: Host address width 36
[    0.007210] DMAR: DRHD base: 0x000000fed10000 flags: 0x0
[    0.008008] IOMMU 0: reg_base_addr fed10000 ver 1:0 cap c9008020e30260 ecap 1000
[    0.008235] DMAR: DRHD base: 0x000000fed13000 flags: 0x1
[    0.008394] IOMMU 1: reg_base_addr fed13000 ver 1:0 cap c9008020630260 ecap 1000
[    0.008617] DMAR: RMRR base: 0x000000dfbe7000 end: 0x000000dfbfffff
[    0.009342] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.019508] CPU0: Intel(R) Core(TM)2 Duo CPU     P8700  @ 2.53GHz stepping 0a
[    0.019998] Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
[    0.019998] ... version:                2
[    0.019998] ... bit width:              40
[    0.019998] ... generic registers:      2
[    0.019998] ... value mask:             000000ffffffffff
[    0.019998] ... max period:             000000007fffffff
[    0.020000] ... fixed-purpose events:   3
[    0.020156] ... event mask:             0000000700000003
[    0.032009] Booting Node   0, Processors  #1 Ok.
[    0.032235] smpboot cpu 1: start_ip = 9a000
[    0.104005] Brought up 2 CPUs
[    0.104157] Total of 2 processors activated (10107.08 BogoMIPS).
[    0.105056] devtmpfs: initialized
[    0.105316] xor: automatically using best checksumming function: generic_sse
[    0.109992]    generic_sse:  9088.000 MB/sec
[    0.110148] xor: using function: generic_sse (9088.000 MB/sec)
[    0.110337] NET: Registered protocol family 16
[    0.110560] ACPI: bus type pci registered
[    0.110782] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.110992] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.118174] PCI: Using configuration type 1 for base access
[    0.118336] dmi type 0xB1 record - unknown flag
[    0.119233] bio: create slab <bio-0> at 0
[    0.136017] raid6: int64x1   1898 MB/s
[    0.153006] raid6: int64x2   2398 MB/s
[    0.170004] raid6: int64x4   1898 MB/s
[    0.187004] raid6: int64x8   1609 MB/s
[    0.203992] raid6: sse2x1    3957 MB/s
[    0.220982] raid6: sse2x2    4175 MB/s
[    0.237982] raid6: sse2x4    7058 MB/s
[    0.238132] raid6: using algorithm sse2x4 (7058 MB/s)
[    0.239265] ACPI: EC: Look up EC in DSDT
[    0.244051] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.247557] ACPI: SSDT 00000000df450999 00281 (v01  PmRef   BspIst 00003000 INTL 20050624)
[    0.248326] ACPI: Dynamic OEM Table Load:
[    0.248624] ACPI: SSDT           (null) 00281 (v01  PmRef   BspIst 00003000 INTL 20050624)
[    0.249199] ACPI: SSDT 00000000df450df1 005C6 (v01  PmRef   BspCst 00003001 INTL 20050624)
[    0.249779] ACPI: Dynamic OEM Table Load:
[    0.249972] ACPI: SSDT           (null) 005C6 (v01  PmRef   BspCst 00003001 INTL 20050624)
[    0.251139] ACPI: SSDT 00000000df450c1a 001D7 (v01  PmRef    ApIst 00003000 INTL 20050624)
[    0.252490] ACPI: Dynamic OEM Table Load:
[    0.252788] ACPI: SSDT           (null) 001D7 (v01  PmRef    ApIst 00003000 INTL 20050624)
[    0.253168] ACPI: SSDT 00000000df4513b7 0008D (v01  PmRef    ApCst 00003000 INTL 20050624)
[    0.253758] ACPI: Dynamic OEM Table Load:
[    0.254192] ACPI: SSDT           (null) 0008D (v01  PmRef    ApCst 00003000 INTL 20050624)
[    0.256034] ACPI: Interpreter enabled
[    0.256186] ACPI: (supports S0 S3 S4 S5)
[    0.256659] ACPI: Using IOAPIC for interrupt routing
[    0.352546] ACPI: EC: GPE = 0x11, I/O: command/status = 0x934, data = 0x930
[    0.360012] ACPI: No dock devices found.
[    0.361956] HEST: Table not found.
[    0.362106] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.374083] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.397469] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
[    0.397630] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
[    0.397789] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.397950] pci_root PNP0A03:00: host bridge window [mem 0x000d0000-0x000dffff]
[    0.398174] pci_root PNP0A03:00: host bridge window [mem 0xe0000000-0xf7ffffff]
[    0.398398] pci_root PNP0A03:00: host bridge window [mem 0xfc000000-0xfebfffff]
[    0.398623] pci_root PNP0A03:00: host bridge window [mem 0xfec10000-0xfecfffff]
[    0.398847] pci_root PNP0A03:00: host bridge window [mem 0xfed1c000-0xfed1ffff]
[    0.398950] pci_root PNP0A03:00: host bridge window [mem 0xfed90000-0xfed9ffff]
[    0.399174] pci_root PNP0A03:00: host bridge window [mem 0xfed40000-0xfed44fff]
[    0.399398] pci_root PNP0A03:00: host bridge window [mem 0xfeda7000-0xfedfffff]
[    0.399622] pci_root PNP0A03:00: host bridge window [mem 0xfee10000-0xff9fffff]
[    0.399950] pci_root PNP0A03:00: host bridge window [mem 0xffc00000-0xffdfffff]
[    0.400184] pci 0000:00:00.0: [8086:2a40] type 0 class 0x000600
[    0.400220] pci 0000:00:01.0: [8086:2a41] type 1 class 0x000604
[    0.400248] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.400251] pci 0000:00:01.0: PME# disabled
[    0.400305] pci 0000:00:19.0: [8086:10f5] type 0 class 0x000200
[    0.400330] pci 0000:00:19.0: reg 10: [mem 0xf6fe0000-0xf6ffffff]
[    0.400341] pci 0000:00:19.0: reg 14: [mem 0xf6fdb000-0xf6fdbfff]
[    0.400351] pci 0000:00:19.0: reg 18: [io  0xefe0-0xefff]
[    0.400418] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.400423] pci 0000:00:19.0: PME# disabled
[    0.400446] pci 0000:00:1a.0: [8086:2937] type 0 class 0x000c03
[    0.400500] pci 0000:00:1a.0: reg 20: [io  0x6f60-0x6f7f]
[    0.400555] pci 0000:00:1a.1: [8086:2938] type 0 class 0x000c03
[    0.400609] pci 0000:00:1a.1: reg 20: [io  0x6f80-0x6f9f]
[    0.400664] pci 0000:00:1a.2: [8086:2939] type 0 class 0x000c03
[    0.400719] pci 0000:00:1a.2: reg 20: [io  0x6fa0-0x6fbf]
[    0.400786] pci 0000:00:1a.7: [8086:293c] type 0 class 0x000c03
[    0.400810] pci 0000:00:1a.7: reg 10: [mem 0xfed1c400-0xfed1c7ff]
[    0.400983] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.400989] pci 0000:00:1a.7: PME# disabled
[    0.401017] pci 0000:00:1b.0: [8086:293e] type 0 class 0x000403
[    0.401038] pci 0000:00:1b.0: reg 10: [mem 0xf6fdc000-0xf6fdffff 64bit]
[    0.401112] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.401116] pci 0000:00:1b.0: PME# disabled
[    0.401141] pci 0000:00:1c.0: [8086:2940] type 1 class 0x000604
[    0.401218] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.401223] pci 0000:00:1c.0: PME# disabled
[    0.401250] pci 0000:00:1c.1: [8086:2942] type 1 class 0x000604
[    0.401327] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.401332] pci 0000:00:1c.1: PME# disabled
[    0.401359] pci 0000:00:1c.2: [8086:2944] type 1 class 0x000604
[    0.401436] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.401441] pci 0000:00:1c.2: PME# disabled
[    0.401468] pci 0000:00:1c.3: [8086:2946] type 1 class 0x000604
[    0.401544] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.401549] pci 0000:00:1c.3: PME# disabled
[    0.401582] pci 0000:00:1d.0: [8086:2934] type 0 class 0x000c03
[    0.401637] pci 0000:00:1d.0: reg 20: [io  0x6f00-0x6f1f]
[    0.401691] pci 0000:00:1d.1: [8086:2935] type 0 class 0x000c03
[    0.401746] pci 0000:00:1d.1: reg 20: [io  0x6f20-0x6f3f]
[    0.401802] pci 0000:00:1d.2: [8086:2936] type 0 class 0x000c03
[    0.401856] pci 0000:00:1d.2: reg 20: [io  0x6f40-0x6f5f]
[    0.401922] pci 0000:00:1d.7: [8086:293a] type 0 class 0x000c03
[    0.401950] pci 0000:00:1d.7: reg 10: [mem 0xfed1c000-0xfed1c3ff]
[    0.402035] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.402040] pci 0000:00:1d.7: PME# disabled
[    0.402064] pci 0000:00:1e.0: [8086:2448] type 1 class 0x000604
[    0.402142] pci 0000:00:1f.0: [8086:2917] type 0 class 0x000601
[    0.402290] pci 0000:00:1f.2: [8086:2929] type 0 class 0x000106
[    0.402317] pci 0000:00:1f.2: reg 10: [io  0x6e70-0x6e77]
[    0.402327] pci 0000:00:1f.2: reg 14: [io  0x6e78-0x6e7b]
[    0.402338] pci 0000:00:1f.2: reg 18: [io  0x6e80-0x6e87]
[    0.402349] pci 0000:00:1f.2: reg 1c: [io  0x6e88-0x6e8b]
[    0.402360] pci 0000:00:1f.2: reg 20: [io  0x6ea0-0x6ebf]
[    0.402370] pci 0000:00:1f.2: reg 24: [mem 0xfed1c800-0xfed1cfff]
[    0.402418] pci 0000:00:1f.2: PME# supported from D3hot
[    0.402422] pci 0000:00:1f.2: PME# disabled
[    0.402444] pci 0000:00:1f.3: [8086:2930] type 0 class 0x000c05
[    0.402465] pci 0000:00:1f.3: reg 10: [mem 0xf6fdaf00-0xf6fdafff 64bit]
[    0.402494] pci 0000:00:1f.3: reg 20: [io  0x1100-0x111f]
[    0.402576] pci 0000:01:00.0: [10de:06eb] type 0 class 0x000300
[    0.402594] pci 0000:01:00.0: reg 10: [mem 0xf5000000-0xf5ffffff]
[    0.402612] pci 0000:01:00.0: reg 14: [mem 0xe0000000-0xefffffff 64bit pref]
[    0.402631] pci 0000:01:00.0: reg 1c: [mem 0xf2000000-0xf3ffffff 64bit]
[    0.402643] pci 0000:01:00.0: reg 24: [io  0xdf00-0xdf7f]
[    0.402656] pci 0000:01:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    0.403967] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.404119] pci 0000:00:01.0:   bridge window [io  0xd000-0xdfff]
[    0.404122] pci 0000:00:01.0:   bridge window [mem 0xf2000000-0xf6efffff]
[    0.404126] pci 0000:00:01.0:   bridge window [mem 0xe0000000-0xefffffff 64bit pref]
[    0.404180] pci 0000:00:1c.0: PCI bridge to [bus 0b-0b]
[    0.404341] pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.404346] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.404353] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.404472] pci 0000:0c:00.0: [8086:4235] type 0 class 0x000280
[    0.404515] pci 0000:0c:00.0: reg 10: [mem 0xf1ffe000-0xf1ffffff 64bit]
[    0.404677] pci 0000:0c:00.0: PME# supported from D0 D3hot D3cold
[    0.404688] pci 0000:0c:00.0: PME# disabled
[    0.405989] pci 0000:00:1c.1: PCI bridge to [bus 0c-0c]
[    0.406149] pci 0000:00:1c.1:   bridge window [io  0xf000-0x0000] (disabled)
[    0.406154] pci 0000:00:1c.1:   bridge window [mem 0xf1f00000-0xf1ffffff]
[    0.406161] pci 0000:00:1c.1:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.406216] pci 0000:00:1c.2: PCI bridge to [bus 0d-0d]
[    0.406376] pci 0000:00:1c.2:   bridge window [io  0xf000-0x0000] (disabled)
[    0.406381] pci 0000:00:1c.2:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.406388] pci 0000:00:1c.2:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.406443] pci 0000:00:1c.3: PCI bridge to [bus 0e-0f]
[    0.406603] pci 0000:00:1c.3:   bridge window [io  0xc000-0xcfff]
[    0.406608] pci 0000:00:1c.3:   bridge window [mem 0xf1c00000-0xf1efffff]
[    0.406615] pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf01fffff 64bit pref]
[    0.406660] pci 0000:03:01.0: [1180:0832] type 0 class 0x000c00
[    0.406675] pci 0000:03:01.0: proprietary Ricoh MMC controller disabled (via firewire function)
[    0.406900] pci 0000:03:01.0: MMC cards are now supported by standard SDHCI controller
[    0.406961] pci 0000:03:01.0: reg 10: [mem 0xf1bff800-0xf1bfffff]
[    0.407042] pci 0000:03:01.0: supports D1 D2
[    0.407043] pci 0000:03:01.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.407048] pci 0000:03:01.0: PME# disabled
[    0.407067] pci 0000:03:01.1: [1180:0822] type 0 class 0x000805
[    0.407087] pci 0000:03:01.1: reg 10: [mem 0xf1bff600-0xf1bff6ff]
[    0.407165] pci 0000:03:01.1: supports D1 D2
[    0.407166] pci 0000:03:01.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.407171] pci 0000:03:01.1: PME# disabled
[    0.407190] pci 0000:03:01.2: [1180:0843] type 0 class 0x000880
[    0.407210] pci 0000:03:01.2: reg 10: [mem 0xf1bff700-0xf1bff7ff]
[    0.407290] pci 0000:03:01.2: supports D1 D2
[    0.407291] pci 0000:03:01.2: PME# supported from D0 D1 D2 D3hot D3cold
[    0.407296] pci 0000:03:01.2: PME# disabled
[    0.407363] pci 0000:00:1e.0: PCI bridge to [bus 03-03] (subtractive decode)
[    0.407524] pci 0000:00:1e.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.407529] pci 0000:00:1e.0:   bridge window [mem 0xf1b00000-0xf1bfffff]
[    0.407536] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.407538] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.407540] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.407543] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.407545] pci 0000:00:1e.0:   bridge window [mem 0x000d0000-0x000dffff] (subtractive decode)
[    0.407547] pci 0000:00:1e.0:   bridge window [mem 0xe0000000-0xf7ffffff] (subtractive decode)
[    0.407549] pci 0000:00:1e.0:   bridge window [mem 0xfc000000-0xfebfffff] (subtractive decode)
[    0.407551] pci 0000:00:1e.0:   bridge window [mem 0xfec10000-0xfecfffff] (subtractive decode)
[    0.407554] pci 0000:00:1e.0:   bridge window [mem 0xfed1c000-0xfed1ffff] (subtractive decode)
[    0.407556] pci 0000:00:1e.0:   bridge window [mem 0xfed90000-0xfed9ffff] (subtractive decode)
[    0.407558] pci 0000:00:1e.0:   bridge window [mem 0xfed40000-0xfed44fff] (subtractive decode)
[    0.407560] pci 0000:00:1e.0:   bridge window [mem 0xfeda7000-0xfedfffff] (subtractive decode)
[    0.407562] pci 0000:00:1e.0:   bridge window [mem 0xfee10000-0xff9fffff] (subtractive decode)
[    0.407565] pci 0000:00:1e.0:   bridge window [mem 0xffc00000-0xffdfffff] (subtractive decode)
[    0.407596] pci_bus 0000:00: on NUMA node 0
[    0.407599] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.407952] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIE._PRT]
[    0.408017] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]
[    0.408044] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.408074] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    0.408104] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
[    0.408132] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP04._PRT]
[    0.408162]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.408321]  pci0000:00: ACPI _OSC request failed (AE_NOT_FOUND), returned control mask: 0x1d
[    0.408546] ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.415181] ACPI: PCI Interrupt Link [LNKA] (IRQs 10 11) *3
[    0.415748] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 7) *4
[    0.416283] ACPI: PCI Interrupt Link [LNKC] (IRQs 10 11) *3
[    0.416847] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 7 *10 11)
[    0.417504] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.418576] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 *7 10 11 12 14 15)
[    0.419651] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    0.420793] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.422018] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.422240] vgaarb: loaded
[    0.422388] vgaarb: bridge control possible 0000:01:00.0
[    0.422597] SCSI subsystem initialized
[    0.422961] libata version 3.00 loaded.
[    0.422978] usbcore: registered new interface driver usbfs
[    0.423142] usbcore: registered new interface driver hub
[    0.423301] usbcore: registered new device driver usb
[    0.423301] wmi: Mapper loaded
[    0.423301] PCI: Using ACPI for IRQ routing
[    0.426215] PCI: pci_cache_line_size set to 64 bytes
[    0.426370] reserve RAM buffer: 000000000009f000 - 000000000009ffff 
[    0.426373] reserve RAM buffer: 00000000df44d400 - 00000000dfffffff 
[    0.426446] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    0.426610] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.427090] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.431957] Switching to clocksource hpet
[    0.432149] pnp: PnP ACPI init
[    0.432302] ACPI: bus type pnp registered
[    0.432659] Switched to NOHz mode on CPU #0
[    0.432771] Switched to NOHz mode on CPU #1
[    0.443931] pnp 00:00: [bus 00-ff]
[    0.443934] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.443935] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.443937] pnp 00:00: [io  0x0d00-0xffff window]
[    0.443939] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.443941] pnp 00:00: [mem 0x000d0000-0x000dffff window]
[    0.443943] pnp 00:00: [mem 0xe0000000-0xf7ffffff window]
[    0.443944] pnp 00:00: [mem 0xfc000000-0xfebfffff window]
[    0.443946] pnp 00:00: [mem 0xfec10000-0xfecfffff window]
[    0.443948] pnp 00:00: [mem 0xfed1c000-0xfed1ffff window]
[    0.443950] pnp 00:00: [mem 0xfed90000-0xfed9ffff window]
[    0.443952] pnp 00:00: [mem 0xfed40000-0xfed44fff window]
[    0.443954] pnp 00:00: [mem 0xfeda7000-0xfedfffff window]
[    0.443955] pnp 00:00: [mem 0xfee10000-0xff9fffff window]
[    0.443957] pnp 00:00: [mem 0xffc00000-0xffdfffff window]
[    0.444009] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.444028] pnp 00:01: [irq 12]
[    0.444044] pnp 00:01: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.444056] pnp 00:02: [io  0x0060]
[    0.444058] pnp 00:02: [io  0x0064]
[    0.444059] pnp 00:02: [io  0x0062]
[    0.444060] pnp 00:02: [io  0x0066]
[    0.444065] pnp 00:02: [irq 1]
[    0.444080] pnp 00:02: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.444092] pnp 00:03: [io  0x0070-0x0071]
[    0.444096] pnp 00:03: [irq 8]
[    0.444097] pnp 00:03: [io  0x0072-0x0077]
[    0.444113] pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.444127] pnp 00:04: [io  0x0061]
[    0.444129] pnp 00:04: [io  0x0063]
[    0.444130] pnp 00:04: [io  0x0065]
[    0.444133] pnp 00:04: [io  0x0067]
[    0.444149] pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.444160] pnp 00:05: [io  0x002e-0x002f]
[    0.444162] pnp 00:05: [io  0x0c80-0x0caf]
[    0.444163] pnp 00:05: [io  0x0cc0-0x0cff]
[    0.444196] system 00:05: [io  0x0c80-0x0caf] has been reserved
[    0.444357] system 00:05: [io  0x0cc0-0x0cff] could not be reserved
[    0.444516] system 00:05: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.444530] pnp 00:06: [dma 4]
[    0.444531] pnp 00:06: [io  0x0000-0x000f]
[    0.444533] pnp 00:06: [io  0x0080-0x0085]
[    0.444534] pnp 00:06: [io  0x0087-0x008f]
[    0.444536] pnp 00:06: [io  0x00c0-0x00df]
[    0.444537] pnp 00:06: [io  0x0010-0x001f]
[    0.444539] pnp 00:06: [io  0x0090-0x0091]
[    0.444540] pnp 00:06: [io  0x0093-0x009f]
[    0.444557] pnp 00:06: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.444570] pnp 00:07: [io  0x00f0-0x00ff]
[    0.444575] pnp 00:07: [irq 13]
[    0.444593] pnp 00:07: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.444620] pnp 00:08: [mem 0xfed00000-0xfed003ff]
[    0.444653] system 00:08: [mem 0xfed00000-0xfed003ff] has been reserved
[    0.444813] system 00:08: Plug and Play ACPI device, IDs PNP0103 PNP0c01 (active)
[    0.457678] pnp 00:09: [irq 3]
[    0.457680] pnp 00:09: [io  0x02f8-0x02ff]
[    0.457726] pnp 00:09: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.471303] pnp 00:0a: [mem 0xfed40000-0xfed44fff]
[    0.471306] pnp 00:0a: [io  0x0cb0-0x0cbb]
[    0.471341] system 00:0a: [io  0x0cb0-0x0cbb] has been reserved
[    0.471501] system 00:0a: [mem 0xfed40000-0xfed44fff] has been reserved
[    0.471660] system 00:0a: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.474208] pnp 00:0b: [io  0x0900-0x092f]
[    0.474210] pnp 00:0b: [io  0x0931-0x0933]
[    0.474211] pnp 00:0b: [io  0x0935-0x097f]
[    0.474213] pnp 00:0b: [io  0x0092]
[    0.474214] pnp 00:0b: [io  0x00b2-0x00b3]
[    0.474216] pnp 00:0b: [io  0x0020-0x0021]
[    0.474217] pnp 00:0b: [io  0x00a0-0x00a1]
[    0.474219] pnp 00:0b: [irq 0 disabled]
[    0.474221] pnp 00:0b: [io  0x04d0-0x04d1]
[    0.474222] pnp 00:0b: [io  0x1000-0x1005]
[    0.474224] pnp 00:0b: [io  0x1008-0x100f]
[    0.474277] system 00:0b: [io  0x0900-0x092f] has been reserved
[    0.474436] system 00:0b: [io  0x0931-0x0933] has been reserved
[    0.474594] system 00:0b: [io  0x0935-0x097f] has been reserved
[    0.474753] system 00:0b: [io  0x04d0-0x04d1] has been reserved
[    0.474912] system 00:0b: [io  0x1000-0x1005] has been reserved
[    0.475080] system 00:0b: [io  0x1008-0x100f] has been reserved
[    0.475240] system 00:0b: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.475252] pnp 00:0c: [io  0xf400-0xf4fe]
[    0.475254] pnp 00:0c: [io  0x0086]
[    0.475256] pnp 00:0c: [io  0x1006-0x1007]
[    0.475257] pnp 00:0c: [io  0x100a-0x1059]
[    0.475259] pnp 00:0c: [io  0x1060-0x107f]
[    0.475262] pnp 00:0c: [io  0x1080-0x10bf]
[    0.475263] pnp 00:0c: [io  0x1100-0x111f]
[    0.475265] pnp 00:0c: [io  0x1010-0x102f]
[    0.475266] pnp 00:0c: [io  0x0809]
[    0.475317] system 00:0c: [io  0xf400-0xf4fe] has been reserved
[    0.475476] system 00:0c: [io  0x1006-0x1007] has been reserved
[    0.475635] system 00:0c: [io  0x100a-0x1059] could not be reserved
[    0.475794] system 00:0c: [io  0x1060-0x107f] has been reserved
[    0.475954] system 00:0c: [io  0x1080-0x10bf] has been reserved
[    0.476121] system 00:0c: [io  0x1100-0x111f] has been reserved
[    0.476279] system 00:0c: [io  0x1010-0x102f] has been reserved
[    0.476438] system 00:0c: [io  0x0809] has been reserved
[    0.476597] system 00:0c: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.491271] pnp 00:0d: [mem 0x00000000-0x0009efff]
[    0.491274] pnp 00:0d: [mem 0x0009f000-0x0009ffff]
[    0.491276] pnp 00:0d: [mem 0x000c0000-0x000cffff]
[    0.491277] pnp 00:0d: [mem 0x000e0000-0x000fffff]
[    0.491279] pnp 00:0d: [mem 0x00100000-0xdf44d3ff]
[    0.491281] pnp 00:0d: [mem 0xdf44d400-0xdfefffff]
[    0.491282] pnp 00:0d: [mem 0xdff00000-0xdfffffff]
[    0.491284] pnp 00:0d: [mem 0xffe00000-0xffffffff]
[    0.491285] pnp 00:0d: [mem 0xffa00000-0xffbfffff]
[    0.491287] pnp 00:0d: [mem 0xfec00000-0xfec0ffff]
[    0.491288] pnp 00:0d: [mem 0xfee00000-0xfee0ffff]
[    0.491290] pnp 00:0d: [mem 0xfed20000-0xfed3ffff]
[    0.491291] pnp 00:0d: [mem 0xfed45000-0xfed8ffff]
[    0.491293] pnp 00:0d: [mem 0xfeda0000-0xfeda3fff]
[    0.491295] pnp 00:0d: [mem 0xfeda4000-0xfeda4fff]
[    0.491296] pnp 00:0d: [mem 0xfeda5000-0xfeda5fff]
[    0.491298] pnp 00:0d: [mem 0xfeda6000-0xfeda6fff]
[    0.491299] pnp 00:0d: [mem 0xfed1c800-0xfed1cfff]
[    0.491301] pnp 00:0d: [mem 0xfed18000-0xfed1bfff]
[    0.491302] pnp 00:0d: [mem 0xf8000000-0xfbffffff]
[    0.491372] system 00:0d: [mem 0x00000000-0x0009efff] could not be reserved
[    0.491533] system 00:0d: [mem 0x0009f000-0x0009ffff] could not be reserved
[    0.491692] system 00:0d: [mem 0x000c0000-0x000cffff] could not be reserved
[    0.491852] system 00:0d: [mem 0x000e0000-0x000fffff] could not be reserved
[    0.492019] system 00:0d: [mem 0x00100000-0xdf44d3ff] could not be reserved
[    0.492178] system 00:0d: [mem 0xdf44d400-0xdfefffff] could not be reserved
[    0.492338] system 00:0d: [mem 0xdff00000-0xdfffffff] has been reserved
[    0.492497] system 00:0d: [mem 0xffe00000-0xffffffff] could not be reserved
[    0.492656] system 00:0d: [mem 0xffa00000-0xffbfffff] has been reserved
[    0.492816] system 00:0d: [mem 0xfec00000-0xfec0ffff] could not be reserved
[    0.492975] system 00:0d: [mem 0xfee00000-0xfee0ffff] has been reserved
[    0.493141] system 00:0d: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.493300] system 00:0d: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.493459] system 00:0d: [mem 0xfeda0000-0xfeda3fff] has been reserved
[    0.493618] system 00:0d: [mem 0xfeda4000-0xfeda4fff] has been reserved
[    0.493777] system 00:0d: [mem 0xfeda5000-0xfeda5fff] has been reserved
[    0.493936] system 00:0d: [mem 0xfeda6000-0xfeda6fff] has been reserved
[    0.494102] system 00:0d: [mem 0xfed1c800-0xfed1cfff] has been reserved
[    0.494261] system 00:0d: [mem 0xfed18000-0xfed1bfff] has been reserved
[    0.494421] system 00:0d: [mem 0xf8000000-0xfbffffff] has been reserved
[    0.494581] system 00:0d: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.496658] pnp: PnP ACPI: found 14 devices
[    0.496815] ACPI: ACPI bus type pnp unregistered
[    0.502535] PCI: max bus depth: 1 pci_try_num: 2
[    0.502588] pci 0000:00:1c.2: BAR 14: assigned [mem 0xf0200000-0xf03fffff]
[    0.502749] pci 0000:00:1c.2: BAR 15: assigned [mem 0xf0400000-0xf05fffff 64bit pref]
[    0.502975] pci 0000:00:1c.2: BAR 13: assigned [io  0x2000-0x2fff]
[    0.503142] pci 0000:00:1c.1: BAR 15: assigned [mem 0xf0600000-0xf07fffff 64bit pref]
[    0.503366] pci 0000:00:1c.1: BAR 13: assigned [io  0x3000-0x3fff]
[    0.503525] pci 0000:00:1c.0: BAR 14: assigned [mem 0xf0800000-0xf09fffff]
[    0.503685] pci 0000:00:1c.0: BAR 15: assigned [mem 0xf0a00000-0xf0bfffff 64bit pref]
[    0.503910] pci 0000:00:1c.0: BAR 13: assigned [io  0x4000-0x4fff]
[    0.504077] pci 0000:01:00.0: BAR 6: assigned [mem 0xf4000000-0xf401ffff pref]
[    0.504301] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.504458] pci 0000:00:01.0:   bridge window [io  0xd000-0xdfff]
[    0.504617] pci 0000:00:01.0:   bridge window [mem 0xf2000000-0xf6efffff]
[    0.504777] pci 0000:00:01.0:   bridge window [mem 0xe0000000-0xefffffff 64bit pref]
[    0.505009] pci 0000:00:1c.0: PCI bridge to [bus 0b-0b]
[    0.505168] pci 0000:00:1c.0:   bridge window [io  0x4000-0x4fff]
[    0.505329] pci 0000:00:1c.0:   bridge window [mem 0xf0800000-0xf09fffff]
[    0.505490] pci 0000:00:1c.0:   bridge window [mem 0xf0a00000-0xf0bfffff 64bit pref]
[    0.505720] pci 0000:00:1c.1: PCI bridge to [bus 0c-0c]
[    0.505878] pci 0000:00:1c.1:   bridge window [io  0x3000-0x3fff]
[    0.506046] pci 0000:00:1c.1:   bridge window [mem 0xf1f00000-0xf1ffffff]
[    0.506207] pci 0000:00:1c.1:   bridge window [mem 0xf0600000-0xf07fffff 64bit pref]
[    0.506436] pci 0000:00:1c.2: PCI bridge to [bus 0d-0d]
[    0.506594] pci 0000:00:1c.2:   bridge window [io  0x2000-0x2fff]
[    0.506756] pci 0000:00:1c.2:   bridge window [mem 0xf0200000-0xf03fffff]
[    0.506916] pci 0000:00:1c.2:   bridge window [mem 0xf0400000-0xf05fffff 64bit pref]
[    0.507152] pci 0000:00:1c.3: PCI bridge to [bus 0e-0f]
[    0.507310] pci 0000:00:1c.3:   bridge window [io  0xc000-0xcfff]
[    0.507472] pci 0000:00:1c.3:   bridge window [mem 0xf1c00000-0xf1efffff]
[    0.507633] pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf01fffff 64bit pref]
[    0.507862] pci 0000:00:1e.0: PCI bridge to [bus 03-03]
[    0.508025] pci 0000:00:1e.0:   bridge window [io  disabled]
[    0.508186] pci 0000:00:1e.0:   bridge window [mem 0xf1b00000-0xf1bfffff]
[    0.508346] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    0.508515] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.508674] pci 0000:00:01.0: setting latency timer to 64
[    0.508681] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.508842] pci 0000:00:1c.0: setting latency timer to 64
[    0.508849] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.509018] pci 0000:00:1c.1: setting latency timer to 64
[    0.509026] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.509187] pci 0000:00:1c.2: setting latency timer to 64
[    0.509194] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    0.509355] pci 0000:00:1c.3: setting latency timer to 64
[    0.509363] pci 0000:00:1e.0: setting latency timer to 64
[    0.509366] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.509368] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.509370] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.509372] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000dffff]
[    0.509374] pci_bus 0000:00: resource 8 [mem 0xe0000000-0xf7ffffff]
[    0.509376] pci_bus 0000:00: resource 9 [mem 0xfc000000-0xfebfffff]
[    0.509378] pci_bus 0000:00: resource 10 [mem 0xfec10000-0xfecfffff]
[    0.509380] pci_bus 0000:00: resource 11 [mem 0xfed1c000-0xfed1ffff]
[    0.509382] pci_bus 0000:00: resource 12 [mem 0xfed90000-0xfed9ffff]
[    0.509384] pci_bus 0000:00: resource 13 [mem 0xfed40000-0xfed44fff]
[    0.509385] pci_bus 0000:00: resource 14 [mem 0xfeda7000-0xfedfffff]
[    0.509387] pci_bus 0000:00: resource 15 [mem 0xfee10000-0xff9fffff]
[    0.509390] pci_bus 0000:00: resource 16 [mem 0xffc00000-0xffdfffff]
[    0.509392] pci_bus 0000:01: resource 0 [io  0xd000-0xdfff]
[    0.509393] pci_bus 0000:01: resource 1 [mem 0xf2000000-0xf6efffff]
[    0.509395] pci_bus 0000:01: resource 2 [mem 0xe0000000-0xefffffff 64bit pref]
[    0.509398] pci_bus 0000:0b: resource 0 [io  0x4000-0x4fff]
[    0.509399] pci_bus 0000:0b: resource 1 [mem 0xf0800000-0xf09fffff]
[    0.509402] pci_bus 0000:0b: resource 2 [mem 0xf0a00000-0xf0bfffff 64bit pref]
[    0.509404] pci_bus 0000:0c: resource 0 [io  0x3000-0x3fff]
[    0.509405] pci_bus 0000:0c: resource 1 [mem 0xf1f00000-0xf1ffffff]
[    0.509407] pci_bus 0000:0c: resource 2 [mem 0xf0600000-0xf07fffff 64bit pref]
[    0.509409] pci_bus 0000:0d: resource 0 [io  0x2000-0x2fff]
[    0.509411] pci_bus 0000:0d: resource 1 [mem 0xf0200000-0xf03fffff]
[    0.509413] pci_bus 0000:0d: resource 2 [mem 0xf0400000-0xf05fffff 64bit pref]
[    0.509415] pci_bus 0000:0e: resource 0 [io  0xc000-0xcfff]
[    0.509417] pci_bus 0000:0e: resource 1 [mem 0xf1c00000-0xf1efffff]
[    0.509419] pci_bus 0000:0e: resource 2 [mem 0xf0000000-0xf01fffff 64bit pref]
[    0.509421] pci_bus 0000:03: resource 1 [mem 0xf1b00000-0xf1bfffff]
[    0.509423] pci_bus 0000:03: resource 4 [io  0x0000-0x0cf7]
[    0.509425] pci_bus 0000:03: resource 5 [io  0x0d00-0xffff]
[    0.509427] pci_bus 0000:03: resource 6 [mem 0x000a0000-0x000bffff]
[    0.509429] pci_bus 0000:03: resource 7 [mem 0x000d0000-0x000dffff]
[    0.509431] pci_bus 0000:03: resource 8 [mem 0xe0000000-0xf7ffffff]
[    0.509433] pci_bus 0000:03: resource 9 [mem 0xfc000000-0xfebfffff]
[    0.509434] pci_bus 0000:03: resource 10 [mem 0xfec10000-0xfecfffff]
[    0.509436] pci_bus 0000:03: resource 11 [mem 0xfed1c000-0xfed1ffff]
[    0.509438] pci_bus 0000:03: resource 12 [mem 0xfed90000-0xfed9ffff]
[    0.509440] pci_bus 0000:03: resource 13 [mem 0xfed40000-0xfed44fff]
[    0.509442] pci_bus 0000:03: resource 14 [mem 0xfeda7000-0xfedfffff]
[    0.509444] pci_bus 0000:03: resource 15 [mem 0xfee10000-0xff9fffff]
[    0.509446] pci_bus 0000:03: resource 16 [mem 0xffc00000-0xffdfffff]
[    0.509477] NET: Registered protocol family 2
[    0.509680] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.510271] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.512120] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.512754] TCP: Hash tables configured (established 262144 bind 65536)
[    0.512913] TCP reno registered
[    0.514393] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.514582] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.515107] pci 0000:01:00.0: Boot video device
[    0.515149] PCI: CLS 64 bytes, default 64
[    0.515196] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.515357] Placing 64MB software IO TLB between ffff8800db447000 - ffff8800df447000
[    0.515582] software IO TLB at phys 0xdb447000 - 0xdf447000
[    0.516020] microcode: CPU0 sig=0x1067a, pf=0x80, revision=0xa07
[    0.516182] microcode: CPU1 sig=0x1067a, pf=0x80, revision=0xa07
[    0.516355] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.516851] audit: initializing netlink socket (disabled)
[    0.517028] type=2000 audit(1318707484.516:1): initialized
[    0.529159] msgmni has been set to 7886
[    0.529792] alg: No test for stdrng (krng)
[    0.529953] async_tx: api initialized (async)
[    0.530163] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.530411] io scheduler noop registered
[    0.530600] io scheduler cfq registered (default)
[    0.530822] pcieport 0000:00:01.0: setting latency timer to 64
[    0.530849] pcieport 0000:00:01.0: irq 40 for MSI/MSI-X
[    0.530890] pcieport 0000:00:1c.0: setting latency timer to 64
[    0.530937] pcieport 0000:00:1c.0: irq 41 for MSI/MSI-X
[    0.531012] pcieport 0000:00:1c.1: setting latency timer to 64
[    0.531060] pcieport 0000:00:1c.1: irq 42 for MSI/MSI-X
[    0.531125] pcieport 0000:00:1c.2: setting latency timer to 64
[    0.531172] pcieport 0000:00:1c.2: irq 43 for MSI/MSI-X
[    0.531237] pcieport 0000:00:1c.3: setting latency timer to 64
[    0.531283] pcieport 0000:00:1c.3: irq 44 for MSI/MSI-X
[    0.531408] intel_idle: MWAIT substates: 0x3122220
[    0.531410] intel_idle: does not run on family 6 model 23
[    0.531478] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
[    0.533446] ACPI: Lid Switch [LID]
[    0.533625] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[    0.533851] ACPI: Power Button [PBTN]
[    0.534050] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input2
[    0.534305] ACPI: Sleep Button [SBTN]
[    0.560062] acpi device:38: registered as cooling_device0
[    0.560722] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A03:00/device:36/LNXVIDEO:00/input/input3
[    0.560952] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[    0.561144] [Firmware Bug]: Duplicate ACPI video bus devices for the same VGA controller, please try module parameter "video.allow_duplicates=1"if the current driver doesn't work.
[    0.561457] ACPI: acpi_idle registered with cpuidle
[    0.561560] Monitor-Mwait will be used to enter C-1 state
[    0.561588] Monitor-Mwait will be used to enter C-2 state
[    0.561616] Monitor-Mwait will be used to enter C-3 state
[    0.561624] Marking TSC unstable due to TSC halts in idle
[    0.591786] thermal LNXTHERM:00: registered as thermal_zone0
[    0.591946] ACPI: Thermal Zone [THM] (55 C)
[    0.592116] ERST: Table is not found!
[    0.592394] Linux agpgart interface v0.103
[    0.592674] [drm] Initialized drm 1.1.0 20060810
[    0.592842] [drm] radeon defaulting to kernel modesetting.
[    0.592998] [drm] radeon kernel modesetting enabled.
[    0.593188] [drm:i915_init] *ERROR* drm/i915 can't work without intel_agp module!
[    0.593438] nouveau 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.593601] nouveau 0000:01:00.0: setting latency timer to 64
[    0.594872] [drm] nouveau 0000:01:00.0: Detected an NV50 generation card (0x298580a2)
[    0.599369] [drm] nouveau 0000:01:00.0: Attempting to load BIOS image from PRAMIN
[    0.703484] [drm] nouveau 0000:01:00.0: ... appears to be valid
[    0.703643] [drm] nouveau 0000:01:00.0: BIT BIOS found
[    0.703801] [drm] nouveau 0000:01:00.0: Bios version 62.98.3c.00
[    0.703960] [drm] nouveau 0000:01:00.0: TMDS table version 2.0
[    0.704125] [drm] nouveau 0000:01:00.0: Found Display Configuration Block version 4.0
[    0.704349] [drm] nouveau 0000:01:00.0: Raw DCB entry 0: 01000323 00010034
[    0.704508] [drm] nouveau 0000:01:00.0: Raw DCB entry 1: 02011300 00000028
[    0.704667] [drm] nouveau 0000:01:00.0: Raw DCB entry 2: 02022386 0f200010
[    0.704827] [drm] nouveau 0000:01:00.0: Raw DCB entry 3: 02022332 00020010
[    0.704986] [drm] nouveau 0000:01:00.0: Raw DCB entry 4: 040333a6 0f200010
[    0.705151] [drm] nouveau 0000:01:00.0: Raw DCB entry 5: 04033312 00020010
[    0.705309] [drm] nouveau 0000:01:00.0: Raw DCB entry 6: 0000000e 00000000
[    0.705468] [drm] nouveau 0000:01:00.0: DCB connector table: VHER 0x40 5 16 4
[    0.705627] [drm] nouveau 0000:01:00.0:   0: 0x00000041: type 0x41 idx 0 tag 0xff
[    0.705851] [drm] nouveau 0000:01:00.0:   1: 0x00000100: type 0x00 idx 1 tag 0xff
[    0.706081] [drm] nouveau 0000:01:00.0:   2: 0x00005246: type 0x46 idx 2 tag 0x07
[    0.706305] [drm] nouveau 0000:01:00.0:   3: 0x0000a346: type 0x46 idx 3 tag 0x08
[    0.706532] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 0 at offset 0xD601
[    0.732192] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 1 at offset 0xD9B3
[    0.738793] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 2 at offset 0xE259
[    0.739039] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 3 at offset 0xE34B
[    0.740363] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 4 at offset 0xE557
[    0.740585] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table at offset 0xE5BC
[    0.760811] [drm] nouveau 0000:01:00.0: 0xE5BC: Condition still not met after 20ms, skipping following opcodes
[    0.782849] [drm] nouveau 0000:01:00.0: 4 available performance level(s)
[    0.783016] [drm] nouveau 0000:01:00.0: 0: memory 100MHz core 169MHz shader 338MHz voltage 900mV fanspeed 100% timing 0
[    0.783246] [drm] nouveau 0000:01:00.0: 1: memory 250MHz core 275MHz shader 550MHz voltage 900mV fanspeed 100% timing 1
[    0.783477] [drm] nouveau 0000:01:00.0: 2: memory 400MHz core 500MHz shader 1000MHz voltage 1090mV fanspeed 100% timing 2
[    0.783713] [drm] nouveau 0000:01:00.0: 3: memory 400MHz core 580MHz shader 1450MHz voltage 1170mV fanspeed 100% timing 3
[    0.783967] [drm] nouveau 0000:01:00.0: Register 0x00004030 not found in PLL limits table
[    0.784138] [drm] nouveau 0000:01:00.0: c: memory 249MHz core 275MHz shader 550MHz voltage 900mV
[    0.784546] [TTM] Zone  kernel: Available graphics memory: 2018972 kiB.
[    0.784706] [TTM] Initializing pool allocator.
[    0.784878] [drm] nouveau 0000:01:00.0: Detected 256MiB VRAM
[    0.785045] mtrr: type mismatch for e0000000,10000000 old: write-back new: write-combining
[    0.787550] [drm] nouveau 0000:01:00.0: 512 MiB GART (aperture)
[    0.814153] [drm] nouveau 0000:01:00.0: ACPI backlight interface available, not registering our own
[    0.815703] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    0.815872] [drm] No driver support for vblank timestamp query.
[    1.083505] [drm] nouveau 0000:01:00.0: allocated 1920x1200 fb: 0x40000000, bo ffff880118d47c00
[    1.083760] fbcon: nouveaufb (fb0) is primary device
[    1.131728] Console: switching to colour frame buffer device 240x75
[    1.136735] fb0: nouveaufb frame buffer device
[    1.136755] drm: registered panic notifier
[    1.136775] [drm] Initialized nouveau 0.0.16 20090420 for 0000:01:00.0 on minor 0
[    1.137647] brd: module loaded
[    1.138061] loop: module loaded
[    1.138087] megasas: 00.00.05.38-rc1 Wed. May. 11 17:00:00 PDT 2011
[    1.138164] ahci 0000:00:1f.2: version 3.0
[    1.138175] ahci 0000:00:1f.2: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    1.138220] ahci 0000:00:1f.2: irq 45 for MSI/MSI-X
[    1.138260] ahci: SSS flag set, parallel bus scan disabled
[    1.138300] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 4 ports 3 Gbps 0x33 impl SATA mode
[    1.138309] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pmp pio slum part ccc ems sxs 
[    1.138321] ahci 0000:00:1f.2: setting latency timer to 64
[    1.144345] scsi0 : ahci
[    1.144422] scsi1 : ahci
[    1.144480] scsi2 : ahci
[    1.144537] scsi3 : ahci
[    1.144606] scsi4 : ahci
[    1.144664] scsi5 : ahci
[    1.144809] ata1: SATA max UDMA/133 abar m2048@0xfed1c800 port 0xfed1c900 irq 45
[    1.144818] ata2: SATA max UDMA/133 abar m2048@0xfed1c800 port 0xfed1c980 irq 45
[    1.144826] ata3: DUMMY
[    1.144830] ata4: DUMMY
[    1.144835] ata5: SATA max UDMA/133 abar m2048@0xfed1c800 port 0xfed1cb00 irq 45
[    1.144844] ata6: SATA max UDMA/133 abar m2048@0xfed1c800 port 0xfed1cb80 irq 45
[    1.144914] Fusion MPT base driver 3.04.19
[    1.144920] Copyright (c) 1999-2008 LSI Corporation
[    1.144932] Fusion MPT SAS Host driver 3.04.19
[    1.144952] Fusion MPT misc device (ioctl) driver 3.04.19
[    1.144981] mptctl: Registered with Fusion MPT base driver
[    1.144988] mptctl: /dev/mptctl @ (major,minor=10,220)
[    1.144995] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.145027] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    1.145047] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    1.145050] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    1.145061] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    1.145094] ehci_hcd 0000:00:1a.7: debug port 1
[    1.148987] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
[    1.148999] ehci_hcd 0000:00:1a.7: irq 22, io mem 0xfed1c400
[    1.158015] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    1.158122] hub 1-0:1.0: USB hub found
[    1.158130] hub 1-0:1.0: 6 ports detected
[    1.158194] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    1.158209] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    1.158213] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    1.158221] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    1.158256] ehci_hcd 0000:00:1d.7: debug port 1
[    1.162140] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    1.162154] ehci_hcd 0000:00:1d.7: irq 20, io mem 0xfed1c000
[    1.172015] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    1.172110] hub 2-0:1.0: USB hub found
[    1.172117] hub 2-0:1.0: 6 ports detected
[    1.172177] uhci_hcd: USB Universal Host Controller Interface driver
[    1.172199] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    1.172212] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    1.172215] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    1.172224] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    1.172256] uhci_hcd 0000:00:1a.0: irq 20, io base 0x00006f60
[    1.172949] hub 3-0:1.0: USB hub found
[    1.173924] hub 3-0:1.0: 2 ports detected
[    1.175022] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    1.176017] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    1.176020] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    1.177049] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    1.178110] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00006f80
[    1.179187] hub 4-0:1.0: USB hub found
[    1.180111] hub 4-0:1.0: 2 ports detected
[    1.181161] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    1.182134] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    1.182137] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    1.183135] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
[    1.184164] uhci_hcd 0000:00:1a.2: irq 22, io base 0x00006fa0
[    1.185221] hub 5-0:1.0: USB hub found
[    1.186104] hub 5-0:1.0: 2 ports detected
[    1.187096] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    1.188012] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    1.188015] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    1.188942] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
[    1.189919] uhci_hcd 0000:00:1d.0: irq 20, io base 0x00006f00
[    1.190907] hub 6-0:1.0: USB hub found
[    1.191723] hub 6-0:1.0: 2 ports detected
[    1.192647] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    1.193505] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    1.193508] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    1.194390] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
[    1.195297] uhci_hcd 0000:00:1d.1: irq 21, io base 0x00006f20
[    1.196251] hub 7-0:1.0: USB hub found
[    1.197046] hub 7-0:1.0: 2 ports detected
[    1.197950] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    1.198793] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    1.198796] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    1.199659] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
[    1.200551] uhci_hcd 0000:00:1d.2: irq 22, io base 0x00006f40
[    1.201470] hub 8-0:1.0: USB hub found
[    1.202244] hub 8-0:1.0: 2 ports detected
[    1.203197] i8042: PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    1.204626] i8042: Warning: Keylock active
[    1.208303] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.208774] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.209710] mousedev: PS/2 mouse device common for all mice
[    1.210603] md: raid0 personality registered for level 0
[    1.211500] md: raid1 personality registered for level 1
[    1.212423] md: raid6 personality registered for level 6
[    1.213317] md: raid5 personality registered for level 5
[    1.214221] md: raid4 personality registered for level 4
[    1.215146] cpuidle: using governor ladder
[    1.216054] cpuidle: using governor menu
[    1.216877] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
[    1.217977] TCP cubic registered
[    1.218619] Registering the dns_resolver key type
[    1.604124] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.606287] ata1.00: ATA-8: WDC WD2500BJKT-75F4T0, 11.01A11, max UDMA/133
[    1.606696] ata1.00: 488397168 sectors, multi 8: LBA48 NCQ (depth 31/32), AA
[    1.609368] ata1.00: configured for UDMA/133
[    1.609908] scsi 0:0:0:0: Direct-Access     ATA      WDC WD2500BJKT-7 11.0 PQ: 0 ANSI: 5
[    1.610795] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.610821] sd 0:0:0:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 GiB)
[    1.610856] sd 0:0:0:0: [sda] Write Protect is off
[    1.610858] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.610873] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.640924]  sda: sda1 sda2 sda3 sda4
[    1.641638] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.871115] usb 3-1: new full speed USB device number 2 using uhci_hcd
[    2.033963] hub 3-1:1.0: USB hub found
[    2.035920] hub 3-1:1.0: 3 ports detected
[    2.074136] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.078321] ata2.00: ATAPI: PLDS DVD+/-RW DU-8A2S, 4D12, max UDMA/100
[    2.083056] ata2.00: configured for UDMA/100
[    2.089432] scsi 1:0:0:0: CD-ROM            PLDS     DVD+-RW DU-8A2S  4D12 PQ: 0 ANSI: 5
[    2.089977] scsi 1:0:0:0: Attached scsi generic sg1 type 5
[    2.246178] usb 5-1: new full speed USB device number 2 using uhci_hcd
[    2.396168] ata5: SATA link down (SStatus 0 SControl 300)
[    2.412254] usb 5-1: config 0 descriptor??
[    2.628170] usb 7-1: new full speed USB device number 2 using uhci_hcd
[    2.701176] ata6: SATA link down (SStatus 0 SControl 300)
[    2.716482] md: Waiting for all devices to be available before autodetect
[    2.716971] md: If you don't use raid, use raid=noautodetect
[    2.718074] md: Autodetecting RAID arrays.
[    2.718994] md: Scanned 0 and added 0 devices.
[    2.720014] md: autorun ...
[    2.721011] md: ... autorun DONE.
[    2.764157] EXT4-fs (sda4): mounted filesystem with ordered data mode. Opts: (null)
[    2.764681] VFS: Mounted root (ext4 filesystem) readonly on device 8:4.
[    2.768260] hub 7-1:1.0: USB hub found
[    2.770225] hub 7-1:1.0: 4 ports detected
[    2.814678] devtmpfs: mounted
[    2.816433] Freeing unused kernel memory: 472k freed
[    2.817027] Write protecting the kernel read-only data: 10240k
[    2.819120] Freeing unused kernel memory: 436k freed
[    2.824304] Freeing unused kernel memory: 1936k freed
[    2.842933] usb 3-1.1: new full speed USB device number 3 using uhci_hcd
[    3.022924] usb 3-1.2: new full speed USB device number 4 using uhci_hcd
[    3.203233] usb 7-1.3: new low speed USB device number 3 using uhci_hcd
[    3.465239] usb 7-1.4: new low speed USB device number 4 using uhci_hcd
[    4.493859] NET: Registered protocol family 1
[    4.892849] udev[146]: starting version 164
[    5.304670] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    5.328646] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    5.493053] 00:09: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    5.495330] cfg80211: Calling CRDA to update world regulatory domain
[    5.550669] rtc_cmos 00:03: RTC can wake from S4
[    5.550804] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    5.550836] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    5.554489] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[    5.554549] HDA Intel 0000:00:1b.0: irq 46 for MSI/MSI-X
[    5.554577] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    5.555427] ACPI: AC Adapter [AC] (on-line)
[    5.558153] input: HID 413c:8157 as /devices/pci0000:00/0000:00:1a.0/usb3/3-1/3-1.1/3-1.1:1.0/input/input5
[    5.558164] generic-usb 0003:413C:8157.0001: input: USB HID v1.11 Keyboard [HID 413c:8157] on usb-0000:00:1a.0-1.1/input0
[    5.562272] input: HID 413c:8158 as /devices/pci0000:00/0000:00:1a.0/usb3/3-1/3-1.2/3-1.2:1.0/input/input6
[    5.562335] generic-usb 0003:413C:8158.0002: input: USB HID v1.11 Mouse [HID 413c:8158] on usb-0000:00:1a.0-1.2/input0
[    5.567791] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[    5.594432] input: Dell Dell USB Keyboard as /devices/pci0000:00/0000:00:1d.1/usb7/7-1/7-1.3/7-1.3:1.0/input/input7
[    5.594443] generic-usb 0003:413C:2105.0003: input: USB HID v1.10 Keyboard [Dell Dell USB Keyboard] on usb-0000:00:1d.1-1.3/input0
[    5.608445] input: Microsoft Microsoft 3-Button Mouse with IntelliEye(TM) as /devices/pci0000:00/0000:00:1d.1/usb7/7-1/7-1.4/7-1.4:1.0/input/input8
[    5.608485] generic-usb 0003:045E:0040.0004: input: USB HID v1.10 Mouse [Microsoft Microsoft 3-Button Mouse with IntelliEye(TM)] on usb-0000:00:1d.1-1.4/input0
[    5.608498] usbcore: registered new interface driver usbhid
[    5.608500] usbhid: USB HID core driver
[    5.761370] input: HDA Intel Mic at Sep Left Jack as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
[    5.761478] input: HDA Intel Mic at Ext Right Jack as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
[    5.761565] input: HDA Intel Line Out at Sep Left Jack as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
[    5.761651] input: HDA Intel HP Out at Ext Right Jack as /devices/pci0000:00/0000:00:1b.0/sound/card0/input12
[    5.766910] usb 3-1.3: new full speed USB device number 5 using uhci_hcd
[    5.975911] Bluetooth: Core ver 2.16
[    5.975928] NET: Registered protocol family 31
[    5.975930] Bluetooth: HCI device and connection manager initialized
[    5.975932] Bluetooth: HCI socket layer initialized
[    5.975934] Bluetooth: L2CAP socket layer initialized
[    5.975971] Bluetooth: SCO socket layer initialized
[    6.002275] e1000e: Intel(R) PRO/1000 Network Driver - 1.3.10-k2
[    6.002278] e1000e: Copyright(c) 1999 - 2011 Intel Corporation.
[    6.002306] e1000e 0000:00:19.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    6.002317] e1000e 0000:00:19.0: setting latency timer to 64
[    6.002434] e1000e 0000:00:19.0: irq 47 for MSI/MSI-X
[    6.048244] input: Dell WMI hotkeys as /devices/virtual/input/input13
[    6.065795] firewire_ohci 0000:03:01.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    6.118130] firewire_ohci: Added fw-ohci device 0000:03:01.0, OHCI v1.10, 4 IR + 4 IT contexts, quirks 0x1
[    6.119477] Bluetooth: Generic Bluetooth USB driver ver 0.6
[    6.119624] usbcore: registered new interface driver btusb
[    6.120174] sdhci: Secure Digital Host Controller Interface driver
[    6.120176] sdhci: Copyright(c) Pierre Ossman
[    6.162858] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:
[    6.162861] iwlagn: Copyright(c) 2003-2011 Intel Corporation
[    6.162971] iwlagn 0000:0c:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    6.163011] iwlagn 0000:0c:00.0: setting latency timer to 64
[    6.163081] iwlagn 0000:0c:00.0: Detected Intel(R) Ultimate N WiFi Link 5300 AGN, REV=0x24
[    6.174917] ACPI: Battery Slot [BAT0] (battery present)
[    6.174942] ACPI: Battery Slot [BAT1] (battery absent)
[    6.176075] sdhci-pci 0000:03:01.1: SDHCI controller found [1180:0822] (rev 21)
[    6.176088] sdhci-pci 0000:03:01.1: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    6.178183] Registered led device: mmc0::
[    6.179269] mmc0: SDHCI controller on PCI [0000:03:01.1] using DMA
[    6.179277] sdhci-pci 0000:03:01.2: SDHCI controller found [1180:0843] (rev 11)
[    6.179292] sdhci-pci 0000:03:01.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    6.179351] Registered led device: mmc1::
[    6.179391] mmc1: SDHCI controller on PCI [0000:03:01.2] using DMA
[    6.187496] iwlagn 0000:0c:00.0: device EEPROM VER=0x120, CALIB=0x4
[    6.187499] iwlagn 0000:0c:00.0: Device SKU: 0Xb
[    6.187508] iwlagn 0000:0c:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
[    6.187622] iwlagn 0000:0c:00.0: irq 48 for MSI/MSI-X
[    6.189263] input: DualPoint Stick as /devices/platform/i8042/serio1/input/input14
[    6.199150] e1000e 0000:00:19.0: eth0: (PCI Express:2.5GT/s:Width x1) 00:24:e8:ab:66:48
[    6.199153] e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    6.199175] e1000e 0000:00:19.0: eth0: MAC: 7, PHY: 8, PBA No: 1004FF-0FF
[    6.199204] i801_smbus 0000:00:1f.3: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    6.207390] input: AlpsPS/2 ALPS DualPoint TouchPad as /devices/platform/i8042/serio1/input/input15
[    6.237905] sr0: scsi3-mmc drive: 24x/6x writer dvd-ram cd/rw xa/form2 cdda pop-up
[    6.237910] cdrom: Uniform CD-ROM driver Revision: 3.20
[    6.238019] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    6.344283] iwlagn 0000:0c:00.0: loaded firmware version 8.83.5.1 build 33692
[    6.344447] Registered led device: phy0-led
[    6.374022] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
[    6.619135] firewire_core: created device fw0: GUID 434fc00034439621, S400
[    7.363558] device-mapper: uevent: version 1.0.3
[    7.363663] device-mapper: ioctl: 4.20.0-ioctl (2011-02-02) initialised: dm-devel@redhat.com
[    7.809756] EXT4-fs (sda4): re-mounted. Opts: errors=remount-ro
[    9.002250] Adding 8388604k swap on /dev/sda3.  Priority:-1 extents:1 across:8388604k 
[   11.129912] e1000e 0000:00:19.0: irq 47 for MSI/MSI-X
[   11.180077] e1000e 0000:00:19.0: irq 47 for MSI/MSI-X
[   11.514514] NET: Registered protocol family 17
[   12.695643] NET: Registered protocol family 10
[   12.696421] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   12.696618] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   13.089996] RPC: Registered named UNIX socket transport module.
[   13.089998] RPC: Registered udp transport module.
[   13.090011] RPC: Registered tcp transport module.
[   13.090013] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   13.251122] FS-Cache: Loaded
[   13.273337] FS-Cache: Netfs 'nfs' registered for caching
[   13.820004] microcode: CPU0 updated to revision 0xa0b, date = 2010-09-28
[   13.826413] microcode: CPU1 updated to revision 0xa0b, date = 2010-09-28
[   14.010982] ip_tables: (C) 2000-2006 Netfilter Core Team
[   14.025019] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   14.083909] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx
[   14.084351] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[  193.559950] chrome_sandbox (1967): /proc/1965/oom_adj is deprecated, please use /proc/1965/oom_score_adj instead.
[ 2835.519067] CE: hpet increased min_delta_ns to 20113 nsec
[ 3290.954335] usb 7-1: USB disconnect, device number 2
[ 3290.954344] usb 7-1.3: USB disconnect, device number 3
[ 3290.972204] usb 7-1.4: USB disconnect, device number 4
[ 3696.306155] usb 7-1: new full speed USB device number 5 using uhci_hcd
[ 3696.447427] hub 7-1:1.0: USB hub found
[ 3696.449312] hub 7-1:1.0: 4 ports detected
[ 3696.730524] usb 7-1.3: new low speed USB device number 6 using uhci_hcd
[ 3696.956125] input: Dell Dell USB Keyboard as /devices/pci0000:00/0000:00:1d.1/usb7/7-1/7-1.3/7-1.3:1.0/input/input16
[ 3696.956272] generic-usb 0003:413C:2105.0005: input: USB HID v1.10 Keyboard [Dell Dell USB Keyboard] on usb-0000:00:1d.1-1.3/input0
[ 3697.022296] usb 7-1.4: new low speed USB device number 7 using uhci_hcd
[ 3697.172085] input: Microsoft Microsoft 3-Button Mouse with IntelliEye(TM) as /devices/pci0000:00/0000:00:1d.1/usb7/7-1/7-1.4/7-1.4:1.0/input/input17
[ 3697.172289] generic-usb 0003:045E:0040.0006: input: USB HID v1.10 Mouse [Microsoft Microsoft 3-Button Mouse with IntelliEye(TM)] on usb-0000:00:1d.1-1.4/input0
[ 4335.371225] CE: hpet increased min_delta_ns to 30169 nsec
[ 4530.776323] PM: Syncing filesystems ... done.
[ 4531.159157] Freezing user space processes ... (elapsed 0.01 seconds) done.
[ 4531.170228] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[ 4531.181059] Suspending console(s) (use no_console_suspend to debug)
[ 4531.181804] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[ 4531.181931] sd 0:0:0:0: [sda] Stopping disk
[ 4531.199313] serial 00:09: disabled
[ 4531.199393] ACPI handle has no context!
[ 4531.199401] sdhci-pci 0000:03:01.2: PCI INT C disabled
[ 4531.199406] ACPI handle has no context!
[ 4531.199512] [drm] nouveau 0000:01:00.0: Disabling fbcon acceleration...
[ 4531.199514] [drm] nouveau 0000:01:00.0: Unpinning framebuffer(s)...
[ 4531.199568] [drm] nouveau 0000:01:00.0: Evicting buffers...
[ 4531.200485] ACPI handle has no context!
[ 4531.200491] sdhci-pci 0000:03:01.1: PCI INT C disabled
[ 4531.200497] ACPI handle has no context!
[ 4531.200615] ehci_hcd 0000:00:1d.7: PCI INT A disabled
[ 4531.200624] uhci_hcd 0000:00:1d.2: PCI INT C disabled
[ 4531.200649] uhci_hcd 0000:00:1d.0: PCI INT A disabled
[ 4531.200675] HDA Intel 0000:00:1b.0: PCI INT A disabled
[ 4531.200750] ehci_hcd 0000:00:1a.7: PCI INT C disabled
[ 4531.200758] uhci_hcd 0000:00:1a.2: PCI INT C disabled
[ 4531.200765] uhci_hcd 0000:00:1a.1: PCI INT B disabled
[ 4531.200950] e1000e 0000:00:19.0: PCI INT A disabled
[ 4531.200955] e1000e 0000:00:19.0: PME# enabled
[ 4531.200961]  pci0000:00: wake-up capability enabled by ACPI
[ 4531.208066] uhci_hcd 0000:00:1a.0: PCI INT A disabled
[ 4531.210069] uhci_hcd 0000:00:1d.1: PCI INT B disabled
[ 4531.511078] [drm] nouveau 0000:01:00.0: Idling channels...
[ 4531.511385] [drm] nouveau 0000:01:00.0: Suspending GPU objects...
[ 4533.779177] [drm] nouveau 0000:01:00.0: And we're gone!
[ 4533.779250] nouveau 0000:01:00.0: PCI INT A disabled
[ 4533.790074] PM: suspend of devices complete after 2608.555 msecs
[ 4533.823160] PM: late suspend of devices complete after 33.081 msecs
[ 4533.823718] ACPI: Preparing to enter system sleep state S3
[ 4533.834565] PM: Saving platform NVS memory
[ 4533.834568] Disabling non-boot CPUs ...
[ 4533.835828] CPU 1 is now offline
[ 4533.836200] Extended CMOS year: 2000
[ 4533.836200] ACPI: Low-level resume complete
[ 4533.836200] PM: Restoring platform NVS memory
[ 4533.836200] microcode: CPU0 updated to revision 0xa0b, date = 2010-09-28
[ 4533.836200] Extended CMOS year: 2000
[ 4533.836200] Enabling non-boot CPUs ...
[ 4533.838339] Booting Node 0 Processor 1 APIC 0x1
[ 4533.838341] smpboot cpu 1: start_ip = 9a000
[ 4533.910295] microcode: CPU1 updated to revision 0xa0b, date = 2010-09-28
[ 4533.914523] Switched to NOHz mode on CPU #1
[ 4533.916062] CPU1 is up
[ 4533.916924] ACPI: Waking up from system sleep state S3
[ 4533.953199] pcieport 0000:00:01.0: restoring config space at offset 0xf (was 0x80100, writing 0x1a0100)
[ 4533.953204] pcieport 0000:00:01.0: restoring config space at offset 0xa (was 0xf, writing 0x0)
[ 4533.953207] pcieport 0000:00:01.0: restoring config space at offset 0x9 (was 0x1fff1, writing 0xeff1e001)
[ 4533.953210] pcieport 0000:00:01.0: restoring config space at offset 0x8 (was 0xfff0, writing 0xf6e0f200)
[ 4533.953213] pcieport 0000:00:01.0: restoring config space at offset 0x7 (was 0x200000f0, writing 0xd0d0)
[ 4533.953216] pcieport 0000:00:01.0: restoring config space at offset 0x6 (was 0x0, writing 0x10100)
[ 4533.953220] pcieport 0000:00:01.0: restoring config space at offset 0x3 (was 0x10000, writing 0x10010)
[ 4533.953223] pcieport 0000:00:01.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100507)
[ 4533.953251] e1000e 0000:00:19.0: restoring config space at offset 0xf (was 0x100, writing 0x10b)
[ 4533.953266] e1000e 0000:00:19.0: restoring config space at offset 0x6 (was 0x1, writing 0xefe1)
[ 4533.953270] e1000e 0000:00:19.0: restoring config space at offset 0x5 (was 0x0, writing 0xf6fdb000)
[ 4533.953275] e1000e 0000:00:19.0: restoring config space at offset 0x4 (was 0x0, writing 0xf6fe0000)
[ 4533.953282] e1000e 0000:00:19.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100107)
[ 4533.953305] uhci_hcd 0000:00:1a.0: restoring config space at offset 0xf (was 0x100, writing 0x10a)
[ 4533.953317] uhci_hcd 0000:00:1a.0: restoring config space at offset 0x8 (was 0x1, writing 0x6f61)
[ 4533.953329] uhci_hcd 0000:00:1a.0: restoring config space at offset 0x1 (was 0x2900000, writing 0x2900001)
[ 4533.953348] uhci_hcd 0000:00:1a.1: restoring config space at offset 0xf (was 0x200, writing 0x207)
[ 4533.953360] uhci_hcd 0000:00:1a.1: restoring config space at offset 0x8 (was 0x1, writing 0x6f81)
[ 4533.953372] uhci_hcd 0000:00:1a.1: restoring config space at offset 0x1 (was 0x2900000, writing 0x2900001)
[ 4533.953390] uhci_hcd 0000:00:1a.2: restoring config space at offset 0xf (was 0x300, writing 0x30b)
[ 4533.953402] uhci_hcd 0000:00:1a.2: restoring config space at offset 0x8 (was 0x1, writing 0x6fa1)
[ 4533.953414] uhci_hcd 0000:00:1a.2: restoring config space at offset 0x1 (was 0x2900000, writing 0x2900001)
[ 4533.953457] ehci_hcd 0000:00:1a.7: restoring config space at offset 0x1 (was 0x2900106, writing 0x2900102)
[ 4533.953488] HDA Intel 0000:00:1b.0: restoring config space at offset 0xf (was 0x100, writing 0x107)
[ 4533.953505] HDA Intel 0000:00:1b.0: restoring config space at offset 0x4 (was 0xfebfc004, writing 0xf6fdc004)
[ 4533.953510] HDA Intel 0000:00:1b.0: restoring config space at offset 0x3 (was 0x0, writing 0x10)
[ 4533.953516] HDA Intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100102)
[ 4533.953544] pcieport 0000:00:1c.0: restoring config space at offset 0xf (was 0x100, writing 0x20100)
[ 4533.953555] pcieport 0000:00:1c.0: restoring config space at offset 0x9 (was 0x10001, writing 0xf0b1f0a1)
[ 4533.953560] pcieport 0000:00:1c.0: restoring config space at offset 0x8 (was 0x0, writing 0xf090f080)
[ 4533.953564] pcieport 0000:00:1c.0: restoring config space at offset 0x7 (was 0x20000000, writing 0x4040)
[ 4533.953569] pcieport 0000:00:1c.0: restoring config space at offset 0x6 (was 0x0, writing 0xb0b00)
[ 4533.953576] pcieport 0000:00:1c.0: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
[ 4533.953582] pcieport 0000:00:1c.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100507)
[ 4533.953627] pcieport 0000:00:1c.1: restoring config space at offset 0xf (was 0x200, writing 0x20200)
[ 4533.953638] pcieport 0000:00:1c.1: restoring config space at offset 0x9 (was 0x10001, writing 0xf071f061)
[ 4533.953643] pcieport 0000:00:1c.1: restoring config space at offset 0x8 (was 0x0, writing 0xf1f0f1f0)
[ 4533.953648] pcieport 0000:00:1c.1: restoring config space at offset 0x7 (was 0x20000000, writing 0x3030)
[ 4533.953652] pcieport 0000:00:1c.1: restoring config space at offset 0x6 (was 0x0, writing 0xc0c00)
[ 4533.953659] pcieport 0000:00:1c.1: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
[ 4533.953665] pcieport 0000:00:1c.1: restoring config space at offset 0x1 (was 0x100000, writing 0x100507)
[ 4533.953710] pcieport 0000:00:1c.2: restoring config space at offset 0xf (was 0x300, writing 0x20300)
[ 4533.953721] pcieport 0000:00:1c.2: restoring config space at offset 0x9 (was 0x10001, writing 0xf051f041)
[ 4533.953726] pcieport 0000:00:1c.2: restoring config space at offset 0x8 (was 0x0, writing 0xf030f020)
[ 4533.953730] pcieport 0000:00:1c.2: restoring config space at offset 0x7 (was 0x20000000, writing 0x2020)
[ 4533.953735] pcieport 0000:00:1c.2: restoring config space at offset 0x6 (was 0x0, writing 0xd0d00)
[ 4533.953742] pcieport 0000:00:1c.2: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
[ 4533.953748] pcieport 0000:00:1c.2: restoring config space at offset 0x1 (was 0x100000, writing 0x100507)
[ 4533.953793] pcieport 0000:00:1c.3: restoring config space at offset 0xf (was 0x400, writing 0x20400)
[ 4533.953805] pcieport 0000:00:1c.3: restoring config space at offset 0x9 (was 0x10001, writing 0xf011f001)
[ 4533.953809] pcieport 0000:00:1c.3: restoring config space at offset 0x8 (was 0x0, writing 0xf1e0f1c0)
[ 4533.953814] pcieport 0000:00:1c.3: restoring config space at offset 0x7 (was 0x20000000, writing 0xc0c0)
[ 4533.953818] pcieport 0000:00:1c.3: restoring config space at offset 0x6 (was 0x0, writing 0xf0e00)
[ 4533.953825] pcieport 0000:00:1c.3: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
[ 4533.953831] pcieport 0000:00:1c.3: restoring config space at offset 0x1 (was 0x100000, writing 0x100407)
[ 4533.953888] uhci_hcd 0000:00:1d.0: restoring config space at offset 0x1 (was 0x2900005, writing 0x2900001)
[ 4533.953906] uhci_hcd 0000:00:1d.1: restoring config space at offset 0xf (was 0x200, writing 0x207)
[ 4533.953919] uhci_hcd 0000:00:1d.1: restoring config space at offset 0x8 (was 0x1, writing 0x6f21)
[ 4533.953931] uhci_hcd 0000:00:1d.1: restoring config space at offset 0x1 (was 0x2900000, writing 0x2900001)
[ 4533.953949] uhci_hcd 0000:00:1d.2: restoring config space at offset 0xf (was 0x300, writing 0x30b)
[ 4533.953961] uhci_hcd 0000:00:1d.2: restoring config space at offset 0x8 (was 0x1, writing 0x6f41)
[ 4533.953973] uhci_hcd 0000:00:1d.2: restoring config space at offset 0x1 (was 0x2900000, writing 0x2900001)
[ 4533.954025] ehci_hcd 0000:00:1d.7: restoring config space at offset 0x1 (was 0x2900106, writing 0x2900102)
[ 4533.954058] pci 0000:00:1e.0: restoring config space at offset 0x7 (was 0x2280e0f0, writing 0x228000f0)
[ 4533.954110] pci 0000:00:1f.0: restoring config space at offset 0x1 (was 0x2100007, writing 0x2100107)
[ 4533.954139] ahci 0000:00:1f.2: restoring config space at offset 0xf (was 0x400, writing 0x40a)
[ 4533.954160] ahci 0000:00:1f.2: restoring config space at offset 0x1 (was 0x2b00007, writing 0x2b00407)
[ 4533.954193] i801_smbus 0000:00:1f.3: restoring config space at offset 0xf (was 0x200, writing 0x204)
[ 4533.954210] i801_smbus 0000:00:1f.3: restoring config space at offset 0x4 (was 0x4, writing 0xf6fdaf04)
[ 4533.954218] i801_smbus 0000:00:1f.3: restoring config space at offset 0x1 (was 0x2800001, writing 0x2800103)
[ 4533.954253] nouveau 0000:01:00.0: restoring config space at offset 0xf (was 0x100, writing 0x103)
[ 4533.954268] nouveau 0000:01:00.0: restoring config space at offset 0x9 (was 0x1, writing 0xdf01)
[ 4533.954279] nouveau 0000:01:00.0: restoring config space at offset 0x7 (was 0x4, writing 0xf2000004)
[ 4533.954290] nouveau 0000:01:00.0: restoring config space at offset 0x5 (was 0xc, writing 0xe000000c)
[ 4533.954299] nouveau 0000:01:00.0: restoring config space at offset 0x4 (was 0x0, writing 0xf5000000)
[ 4533.954309] nouveau 0000:01:00.0: restoring config space at offset 0x3 (was 0x0, writing 0x10)
[ 4533.954320] nouveau 0000:01:00.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100007)
[ 4533.954415] iwlagn 0000:0c:00.0: restoring config space at offset 0xf (was 0x100, writing 0x104)
[ 4533.954452] iwlagn 0000:0c:00.0: restoring config space at offset 0x4 (was 0x4, writing 0xf1ffe004)
[ 4533.954463] iwlagn 0000:0c:00.0: restoring config space at offset 0x3 (was 0x0, writing 0x10)
[ 4533.954477] iwlagn 0000:0c:00.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100106)
[ 4533.954551] firewire_ohci 0000:03:01.0: restoring config space at offset 0xf (was 0x4020200, writing 0x4020204)
[ 4533.954572] firewire_ohci 0000:03:01.0: restoring config space at offset 0x3 (was 0x800000, writing 0x804010)
[ 4533.954578] firewire_ohci 0000:03:01.0: restoring config space at offset 0x1 (was 0x2100000, writing 0x2100106)
[ 4533.954595] firewire_ohci 0000:03:01.0: proprietary Ricoh MMC controller disabled (via firewire function)
[ 4533.954597] firewire_ohci 0000:03:01.0: MMC cards are now supported by standard SDHCI controller
[ 4533.954609] sdhci-pci 0000:03:01.1: restoring config space at offset 0xf (was 0x300, writing 0x303)
[ 4533.954628] sdhci-pci 0000:03:01.1: restoring config space at offset 0x4 (was 0x0, writing 0xf1bff600)
[ 4533.954633] sdhci-pci 0000:03:01.1: restoring config space at offset 0x3 (was 0x800000, writing 0x804010)
[ 4533.954639] sdhci-pci 0000:03:01.1: restoring config space at offset 0x1 (was 0x2100000, writing 0x2100106)
[ 4533.954659] sdhci-pci 0000:03:01.2: restoring config space at offset 0xf (was 0x300, writing 0x303)
[ 4533.954678] sdhci-pci 0000:03:01.2: restoring config space at offset 0x4 (was 0x0, writing 0xf1bff700)
[ 4533.954683] sdhci-pci 0000:03:01.2: restoring config space at offset 0x3 (was 0x800000, writing 0x804010)
[ 4533.954689] sdhci-pci 0000:03:01.2: restoring config space at offset 0x1 (was 0x2100000, writing 0x2100106)
[ 4533.954864] PM: early resume of devices complete after 1.733 msecs
[ 4533.954972]  pci0000:00: wake-up capability disabled by ACPI
[ 4533.954975] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[ 4533.954978] e1000e 0000:00:19.0: PME# disabled
[ 4533.954983] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[ 4533.955007] usb usb3: root hub lost power or was reset
[ 4533.955039] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[ 4533.955047] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[ 4533.955081] usb usb4: root hub lost power or was reset
[ 4533.955095] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[ 4533.955097] e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
[ 4533.955102] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[ 4533.955129] usb usb5: root hub lost power or was reset
[ 4533.955142] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[ 4533.955148] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[ 4533.955193] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[ 4533.955201] HDA Intel 0000:00:1b.0: setting latency timer to 64
[ 4533.955247] HDA Intel 0000:00:1b.0: irq 47 for MSI/MSI-X
[ 4533.955286] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[ 4533.955291] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[ 4533.955316] usb usb6: root hub lost power or was reset
[ 4533.955327] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[ 4533.955333] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[ 4533.955358] usb usb7: root hub lost power or was reset
[ 4533.955369] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[ 4533.955374] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[ 4533.955397] usb usb8: root hub lost power or was reset
[ 4533.955411] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[ 4533.955417] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[ 4533.955456] pci 0000:00:1e.0: setting latency timer to 64
[ 4533.955471] ahci 0000:00:1f.2: setting latency timer to 64
[ 4533.955552] [drm] nouveau 0000:01:00.0: We're back, enabling device...
[ 4533.955571] nouveau 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[ 4533.955582] nouveau 0000:01:00.0: setting latency timer to 64
[ 4533.955591] [drm] nouveau 0000:01:00.0: POSTing device...
[ 4533.955593] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 0 at offset 0xD601
[ 4533.957339] sdhci-pci 0000:03:01.1: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[ 4533.958369] sdhci-pci 0000:03:01.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[ 4533.958779] sd 0:0:0:0: [sda] Starting disk
[ 4533.980721] [drm] nouveau 0000:01:00.0: 0xD7E0: i2c wr fail: -6
[ 4533.986081] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 1 at offset 0xD9B3
[ 4533.992482] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 2 at offset 0xE259
[ 4533.992531] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 3 at offset 0xE34B
[ 4533.993658] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 4 at offset 0xE557
[ 4533.993663] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table at offset 0xE5BC
[ 4534.010131] firewire_core: skipped bus generations, destroying all nodes
[ 4534.013798] [drm] nouveau 0000:01:00.0: Restoring GPU objects...
[ 4534.069493] serial 00:09: activated
[ 4534.136639] [drm] nouveau 0000:01:00.0: Reinitialising engines...
[ 4534.136680] [drm] nouveau 0000:01:00.0: Restoring mode...
[ 4534.264049] ata6: SATA link down (SStatus 0 SControl 300)
[ 4534.266047] ata5: SATA link down (SStatus 0 SControl 300)
[ 4534.273050] usb 7-1: reset full speed USB device number 5 using uhci_hcd
[ 4534.417042] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[ 4534.423071] ata2.00: configured for UDMA/100
[ 4534.500238] usb 3-1: reset full speed USB device number 2 using uhci_hcd
[ 4534.511037] firewire_core: rediscovered device fw0
[ 4534.600919] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input18
[ 4534.879730] usb 7-1.4: reset low speed USB device number 7 using uhci_hcd
[ 4535.417733] usb 7-1.3: reset low speed USB device number 6 using uhci_hcd
[ 4535.775500] usb 3-1.2: reset full speed USB device number 4 using uhci_hcd
[ 4535.929502] usb 3-1.1: reset full speed USB device number 3 using uhci_hcd
[ 4537.427035] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[ 4537.441302] ata1.00: configured for UDMA/133
[ 4537.471694] PM: resume of devices complete after 3516.739 msecs
[ 4537.471914] Restarting tasks ... 
[ 4537.472891] usb 5-1: USB disconnect, device number 2
[ 4537.489193] done.
[ 4537.489200] video LNXVIDEO:00: Restoring backlight state
[ 4537.685499] usb 3-1.3: USB disconnect, device number 5
[ 4537.851390] e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
[ 4537.895029] usb 5-1: new full speed USB device number 3 using uhci_hcd
[ 4537.902074] e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
[ 4537.902534] ADDRCONF(NETDEV_UP): eth0: link is not ready
[ 4537.955858] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[ 4538.062403] usb 5-1: config 0 descriptor??
[ 4538.340517] usb 3-1.3: new full speed USB device number 6 using uhci_hcd
[ 4538.546608] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[ 4538.546611] Bluetooth: BNEP filters: protocol multicast
[ 4540.745979] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx
[ 4540.747121] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready

--3MwIy2ne0vdjdPXF--

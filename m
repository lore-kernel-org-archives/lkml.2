Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932505Ab1COTFv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 15:05:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:53979 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932488Ab1COTFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 15:05:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,189,1299484800"; 
   d="txt'?scan'208";a="613333526"
Date: Tue, 15 Mar 2011 12:05:45 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pci@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Len Brown <lenb@kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [RFT][PATCH] PCI / ACPI: Do not require MSI support for PCIe
 native features
Message-ID: <20110315190545.GA4165@xanatos>
References: <201103052254.48515.rjw@sisk.pl>
 <201103142137.41607.rjw@sisk.pl>
 <20110314234725.GA4145@xanatos>
 <201103150100.17501.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Q68bSM7Ycu6FN28Q"
Content-Disposition: inline
In-Reply-To: <201103150100.17501.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 15, 2011 at 01:00:17AM +0100, Rafael J. Wysocki wrote:
> Well, I must admit I have no idea what the problem is.  OK, in addition to the
> above changes, please replace the "pci_ext_cfg_avail(root->bus->self)" in the
> same file with "true" and see if _that_ helps.

Yay, that worked!  dmesg is attached.

Sarah Sharp

--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg.txt"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.38-rc8+ (sarah@xanatos) (gcc version 4.4.5 (Ubuntu/Linaro 4.4.4-14ubuntu5) ) #780 SMP PREEMPT Tue Mar 15 11:39:57 PDT 2011
[    0.000000] Command line: root=UUID=7b14f772-a799-415f-a4c9-931ef81f6f0d ro  
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009ec00 (usable)
[    0.000000]  BIOS-e820: 000000000009ec00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bd6a1000 (usable)
[    0.000000]  BIOS-e820: 00000000bd6a1000 - 00000000bd6a7000 (reserved)
[    0.000000]  BIOS-e820: 00000000bd6a7000 - 00000000bd7b7000 (usable)
[    0.000000]  BIOS-e820: 00000000bd7b7000 - 00000000bd80f000 (reserved)
[    0.000000]  BIOS-e820: 00000000bd80f000 - 00000000bd8c7000 (usable)
[    0.000000]  BIOS-e820: 00000000bd8c7000 - 00000000bd8d2000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bd8d2000 - 00000000bd8d5000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bd8d5000 - 00000000bd8d9000 (reserved)
[    0.000000]  BIOS-e820: 00000000bd8d9000 - 00000000bd8dd000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bd8dd000 - 00000000bd8e0000 (reserved)
[    0.000000]  BIOS-e820: 00000000bd8e0000 - 00000000bd907000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bd907000 - 00000000bd908000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bd908000 - 00000000bdb0f000 (reserved)
[    0.000000]  BIOS-e820: 00000000bdb0f000 - 00000000bdb9f000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bdb9f000 - 00000000bdbff000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bdbff000 - 00000000bdc00000 (usable)
[    0.000000]  BIOS-e820: 00000000bdc00000 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
[    0.000000]  BIOS-e820: 00000000fed10000 - 00000000fed14000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed18000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff800000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000013c000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] DMI: LENOVO 74663HU/74663HU, BIOS 6DET44WW (2.08 ) 04/22/2009
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x13c000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-D3FFF write-protect
[    0.000000]   D4000-DBFFF uncachable
[    0.000000]   DC000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 13C000000 mask FFC000000 uncachable
[    0.000000]   1 base 0BE000000 mask FFE000000 uncachable
[    0.000000]   2 base 000000000 mask F80000000 write-back
[    0.000000]   3 base 080000000 mask FC0000000 write-back
[    0.000000]   4 base 100000000 mask FC0000000 write-back
[    0.000000]   5 base 0BDE00000 mask FFFE00000 uncachable
[    0.000000]   6 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000bde00000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xbdc00 max_arch_pfn = 0x400000000
[    0.000000] Scanning 0 areas for low memory corruption
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-00000000bdc00000
[    0.000000]  0000000000 - 00bdc00000 page 2M
[    0.000000] kernel direct mapping tables up to bdc00000 @ 1fffc000-20000000
[    0.000000] init_memory_mapping: 0000000100000000-000000013c000000
[    0.000000]  0100000000 - 013c000000 page 2M
[    0.000000] kernel direct mapping tables up to 13c000000 @ bd8c1000-bd8c7000
[    0.000000] RAMDISK: 3600d000 - 37ff0000
[    0.000000] ACPI: RSDP 00000000000f7380 00024 (v02 LENOVO)
[    0.000000] ACPI: XSDT 00000000bdb7bdd4 00094 (v01 LENOVO TP-6D    00002080  LTP 00000000)
[    0.000000] ACPI: FACP 00000000bdb7bf00 000F4 (v03 LENOVO TP-6D    00002080 LNVO 00000001)
[    0.000000] ACPI: DSDT 00000000bdb7c2f4 0D881 (v01 LENOVO TP-6D    00002080 MSFT 03000000)
[    0.000000] ACPI: FACS 00000000bdb8e000 00040
[    0.000000] ACPI: SSDT 00000000bdb7c0b4 00240 (v01 LENOVO TP-6D    00002080 MSFT 03000000)
[    0.000000] ACPI: ECDT 00000000bdb89b75 00052 (v01 LENOVO TP-6D    00002080 LNVO 00000001)
[    0.000000] ACPI: APIC 00000000bdb89bc7 00078 (v01 LENOVO TP-6D    00002080 LNVO 00000001)
[    0.000000] ACPI: MCFG 00000000bdb89c3f 0003C (v01 LENOVO TP-6D    00002080 LNVO 00000001)
[    0.000000] ACPI: HPET 00000000bdb89c7b 00038 (v01 LENOVO TP-6D    00002080 LNVO 00000001)
[    0.000000] ACPI: SLIC 00000000bdb89dc2 00176 (v01 LENOVO TP-6D    00002080  LTP 00000000)
[    0.000000] ACPI: BOOT 00000000bdb89f38 00028 (v01 LENOVO TP-6D    00002080  LTP 00000001)
[    0.000000] ACPI: ASF! 00000000bdb89f60 000A0 (v16 LENOVO TP-6D    00002080 PTL  00000001)
[    0.000000] ACPI: SSDT 00000000bdb8d203 0055F (v01 LENOVO TP-6D    00002080 INTL 20050513)
[    0.000000] ACPI: TCPA 00000000bd907000 00032 (v00                 00000000      00000000)
[    0.000000] ACPI: SSDT 00000000bd8d4000 00655 (v01  PmRef    CpuPm 00003000 INTL 20050624)
[    0.000000] ACPI: SSDT 00000000bd8d3000 00274 (v01  PmRef  Cpu0Tst 00003000 INTL 20050624)
[    0.000000] ACPI: SSDT 00000000bd8d2000 00242 (v01  PmRef    ApTst 00003000 INTL 20050624)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000]  [ffffea0000000000-ffffea00045fffff] PMD -> [ffff8800b0000000-ffff8800b37fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x0013c000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[6] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009e
[    0.000000]     0: 0x00000100 -> 0x000bd6a1
[    0.000000]     0: 0x000bd6a7 -> 0x000bd7b7
[    0.000000]     0: 0x000bd80f -> 0x000bd8c7
[    0.000000]     0: 0x000bdbff -> 0x000bdc00
[    0.000000]     0: 0x00100000 -> 0x0013c000
[    0.000000] On node 0 totalpages: 1021944
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 3920 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 757922 pages, LIFO batch:31
[    0.000000]   Normal zone: 3360 pages used for memmap
[    0.000000]   Normal zone: 242400 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] 4 Processors exceeds NR_CPUS limit of 2
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 000000000009f000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000dc000
[    0.000000] PM: Registered nosave memory: 00000000000dc000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000bd6a1000 - 00000000bd6a7000
[    0.000000] PM: Registered nosave memory: 00000000bd7b7000 - 00000000bd80f000
[    0.000000] PM: Registered nosave memory: 00000000bd8c7000 - 00000000bd8d2000
[    0.000000] PM: Registered nosave memory: 00000000bd8d2000 - 00000000bd8d5000
[    0.000000] PM: Registered nosave memory: 00000000bd8d5000 - 00000000bd8d9000
[    0.000000] PM: Registered nosave memory: 00000000bd8d9000 - 00000000bd8dd000
[    0.000000] PM: Registered nosave memory: 00000000bd8dd000 - 00000000bd8e0000
[    0.000000] PM: Registered nosave memory: 00000000bd8e0000 - 00000000bd907000
[    0.000000] PM: Registered nosave memory: 00000000bd907000 - 00000000bd908000
[    0.000000] PM: Registered nosave memory: 00000000bd908000 - 00000000bdb0f000
[    0.000000] PM: Registered nosave memory: 00000000bdb0f000 - 00000000bdb9f000
[    0.000000] PM: Registered nosave memory: 00000000bdb9f000 - 00000000bdbff000
[    0.000000] PM: Registered nosave memory: 00000000bdc00000 - 00000000c0000000
[    0.000000] PM: Registered nosave memory: 00000000c0000000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec10000
[    0.000000] PM: Registered nosave memory: 00000000fec10000 - 00000000fed00000
[    0.000000] PM: Registered nosave memory: 00000000fed00000 - 00000000fed10000
[    0.000000] PM: Registered nosave memory: 00000000fed10000 - 00000000fed14000
[    0.000000] PM: Registered nosave memory: 00000000fed14000 - 00000000fed18000
[    0.000000] PM: Registered nosave memory: 00000000fed18000 - 00000000fed1a000
[    0.000000] PM: Registered nosave memory: 00000000fed1a000 - 00000000fed1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed90000
[    0.000000] PM: Registered nosave memory: 00000000fed90000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ff800000
[    0.000000] PM: Registered nosave memory: 00000000ff800000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at c0000000 (gap: c0000000:20000000)
[    0.000000] setup_percpu: NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 26 pages/cpu @ffff8800bd400000 s75840 r8192 d22464 u1048576
[    0.000000] pcpu-alloc: s75840 r8192 d22464 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1004242
[    0.000000] Kernel command line: root=UUID=7b14f772-a799-415f-a4c9-931ef81f6f0d ro  
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.000000] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.000000] xsave/xrstor: enabled xstate_bv 0x3, cntxt size 0x240
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 3908248k/5177344k available (4768k kernel code, 1089568k absent, 179528k reserved, 3936k data, 524k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Preemptable hierarchical RCU implementation.
[    0.000000] 	RCU-based detection of stalled CPUs is disabled.
[    0.000000] 	Verbose stalled-CPUs detection is disabled.
[    0.000000] NR_IRQS:320
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 5823 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] allocated 41943040 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 1862.059 MHz processor.
[    0.004004] Calibrating delay loop (skipped), value calculated using timer frequency.. 3724.11 BogoMIPS (lpj=7448236)
[    0.004099] pid_max: default: 32768 minimum: 301
[    0.004467] Mount-cache hash table entries: 256
[    0.005750] Initializing cgroup subsys ns
[    0.005798] ns_cgroup deprecated: consider using the 'clone_children' flag without the ns_cgroup.
[    0.005865] Initializing cgroup subsys cpuacct
[    0.005925] Initializing cgroup subsys memory
[    0.006074] Initializing cgroup subsys freezer
[    0.006290] CPU: Physical Processor ID: 0
[    0.006336] CPU: Processor Core ID: 0
[    0.006381] using mwait in idle threads.
[    0.006479] ACPI: Core revision 20110112
[    0.156287] Setting APIC routing to flat
[    0.156801] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.199275] CPU0: Intel(R) Core(TM)2 Duo CPU     L9400  @ 1.86GHz stepping 0a
[    0.200011] Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
[    0.200011] ... version:                2
[    0.200011] ... bit width:              40
[    0.200011] ... generic registers:      2
[    0.200011] ... value mask:             000000ffffffffff
[    0.200011] ... max period:             000000007fffffff
[    0.200011] ... fixed-purpose events:   3
[    0.200011] ... event mask:             0000000700000003
[    0.208175] NMI watchdog enabled, takes one hw-pmu counter.
[    0.220029] lockdep: fixing up alternatives.
[    0.224110] Booting Node   0, Processors  #1 Ok.
[    0.316089] NMI watchdog enabled, takes one hw-pmu counter.
[    0.320029] Brought up 2 CPUs
[    0.320078] Total of 2 processors activated (7448.03 BogoMIPS).
[    0.324866] NET: Registered protocol family 16
[    0.327151] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.327221] ACPI: bus type pci registered
[    0.327904] PCI: Using configuration type 1 for base access
[    0.341239] bio: create slab <bio-0> at 0
[    0.350352] ACPI: EC: EC description table is found, configuring boot EC
[    0.497261] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.540872] ACPI: SSDT 00000000bd8d7c20 002C8 (v01  PmRef  Cpu0Ist 00003000 INTL 20050624)
[    0.543790] ACPI: Dynamic OEM Table Load:
[    0.543903] ACPI: SSDT           (null) 002C8 (v01  PmRef  Cpu0Ist 00003000 INTL 20050624)
[    0.548081] ACPI: SSDT 00000000bd8d5020 0087A (v01  PmRef  Cpu0Cst 00003001 INTL 20050624)
[    0.553236] ACPI: Dynamic OEM Table Load:
[    0.553349] ACPI: SSDT           (null) 0087A (v01  PmRef  Cpu0Cst 00003001 INTL 20050624)
[    0.589334] ACPI: SSDT 00000000bd8d6ca0 001CF (v01  PmRef    ApIst 00003000 INTL 20050624)
[    0.593379] ACPI: Dynamic OEM Table Load:
[    0.593492] ACPI: SSDT           (null) 001CF (v01  PmRef    ApIst 00003000 INTL 20050624)
[    0.611664] ACPI: SSDT 00000000bd8d6f20 0008D (v01  PmRef    ApCst 00003000 INTL 20050624)
[    0.614300] ACPI: Dynamic OEM Table Load:
[    0.614413] ACPI: SSDT           (null) 0008D (v01  PmRef    ApCst 00003000 INTL 20050624)
[    0.634446] ACPI: Interpreter enabled
[    0.634496] ACPI: (supports S0 S3 S4 S5)
[    0.635055] ACPI: Using IOAPIC for interrupt routing
[    0.713013] ACPI: Power Resource [PUBS] (on)
[    0.775513] ACPI: EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
[    0.813509] ACPI: ACPI Dock Station Driver: 3 docks/bays found
[    0.813562] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.820547] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.821381] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.821435] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.821487] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.821550] pci_root PNP0A08:00: host bridge window [mem 0x000d4000-0x000d7fff]
[    0.821613] pci_root PNP0A08:00: host bridge window [mem 0x000d8000-0x000dbfff]
[    0.821676] pci_root PNP0A08:00: host bridge window [mem 0xc0000000-0xfebfffff]
[    0.821822] pci 0000:00:00.0: [8086:2a40] type 0 class 0x000600
[    0.821914] pci 0000:00:02.0: [8086:2a42] type 0 class 0x000300
[    0.821935] pci 0000:00:02.0: reg 10: [mem 0xf2000000-0xf23fffff 64bit]
[    0.821948] pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.821957] pci 0000:00:02.0: reg 20: [io  0x1800-0x1807]
[    0.822024] pci 0000:00:02.1: [8086:2a43] type 0 class 0x000380
[    0.822041] pci 0000:00:02.1: reg 10: [mem 0xf2400000-0xf24fffff 64bit]
[    0.822135] pci 0000:00:03.0: [8086:2a44] type 0 class 0x000780
[    0.822159] pci 0000:00:03.0: reg 10: [mem 0xf2826800-0xf282680f 64bit]
[    0.822224] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.822229] pci 0000:00:03.0: PME# disabled
[    0.822273] pci 0000:00:03.2: [8086:2a46] type 0 class 0x000101
[    0.822293] pci 0000:00:03.2: reg 10: [io  0x1828-0x182f]
[    0.822304] pci 0000:00:03.2: reg 14: [io  0x180c-0x180f]
[    0.822315] pci 0000:00:03.2: reg 18: [io  0x1820-0x1827]
[    0.822326] pci 0000:00:03.2: reg 1c: [io  0x1808-0x180b]
[    0.822336] pci 0000:00:03.2: reg 20: [io  0x1810-0x181f]
[    0.822416] pci 0000:00:03.3: [8086:2a47] type 0 class 0x000700
[    0.822436] pci 0000:00:03.3: reg 10: [io  0x1830-0x1837]
[    0.822447] pci 0000:00:03.3: reg 14: [mem 0xf2624000-0xf2624fff]
[    0.822607] pci 0000:00:19.0: [8086:10f5] type 0 class 0x000200
[    0.822640] pci 0000:00:19.0: reg 10: [mem 0xf2600000-0xf261ffff]
[    0.822655] pci 0000:00:19.0: reg 14: [mem 0xf2625000-0xf2625fff]
[    0.822671] pci 0000:00:19.0: reg 18: [io  0x1840-0x185f]
[    0.822762] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.822769] pci 0000:00:19.0: PME# disabled
[    0.822817] pci 0000:00:1a.0: [8086:2937] type 0 class 0x000c03
[    0.822892] pci 0000:00:1a.0: reg 20: [io  0x1860-0x187f]
[    0.822984] pci 0000:00:1a.1: [8086:2938] type 0 class 0x000c03
[    0.823059] pci 0000:00:1a.1: reg 20: [io  0x1880-0x189f]
[    0.823151] pci 0000:00:1a.2: [8086:2939] type 0 class 0x000c03
[    0.823225] pci 0000:00:1a.2: reg 20: [io  0x18a0-0x18bf]
[    0.823333] pci 0000:00:1a.7: [8086:293c] type 0 class 0x000c03
[    0.823367] pci 0000:00:1a.7: reg 10: [mem 0xf2826c00-0xf2826fff]
[    0.823483] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.823491] pci 0000:00:1a.7: PME# disabled
[    0.823546] pci 0000:00:1b.0: [8086:293e] type 0 class 0x000403
[    0.823573] pci 0000:00:1b.0: reg 10: [mem 0xf2620000-0xf2623fff 64bit]
[    0.823683] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.823689] pci 0000:00:1b.0: PME# disabled
[    0.823739] pci 0000:00:1c.0: [8086:2940] type 1 class 0x000604
[    0.823852] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.823859] pci 0000:00:1c.0: PME# disabled
[    0.823910] pci 0000:00:1c.1: [8086:2942] type 1 class 0x000604
[    0.824023] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.824029] pci 0000:00:1c.1: PME# disabled
[    0.824221] pci 0000:00:1c.3: [8086:2946] type 1 class 0x000604
[    0.824334] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.824341] pci 0000:00:1c.3: PME# disabled
[    0.824401] pci 0000:00:1d.0: [8086:2934] type 0 class 0x000c03
[    0.824476] pci 0000:00:1d.0: reg 20: [io  0x18c0-0x18df]
[    0.824568] pci 0000:00:1d.1: [8086:2935] type 0 class 0x000c03
[    0.824643] pci 0000:00:1d.1: reg 20: [io  0x18e0-0x18ff]
[    0.824735] pci 0000:00:1d.2: [8086:2936] type 0 class 0x000c03
[    0.824810] pci 0000:00:1d.2: reg 20: [io  0x1c00-0x1c1f]
[    0.824917] pci 0000:00:1d.7: [8086:293a] type 0 class 0x000c03
[    0.824950] pci 0000:00:1d.7: reg 10: [mem 0xf2827000-0xf28273ff]
[    0.825067] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.825074] pci 0000:00:1d.7: PME# disabled
[    0.825122] pci 0000:00:1e.0: [8086:2448] type 1 class 0x000604
[    0.825246] pci 0000:00:1f.0: [8086:2917] type 0 class 0x000601
[    0.825453] pci 0000:00:1f.2: [8086:2929] type 0 class 0x000106
[    0.825489] pci 0000:00:1f.2: reg 10: [io  0x1c48-0x1c4f]
[    0.825505] pci 0000:00:1f.2: reg 14: [io  0x183c-0x183f]
[    0.825520] pci 0000:00:1f.2: reg 18: [io  0x1c40-0x1c47]
[    0.825535] pci 0000:00:1f.2: reg 1c: [io  0x1838-0x183b]
[    0.825550] pci 0000:00:1f.2: reg 20: [io  0x1c20-0x1c3f]
[    0.825565] pci 0000:00:1f.2: reg 24: [mem 0xf2826000-0xf28267ff]
[    0.825630] pci 0000:00:1f.2: PME# supported from D3hot
[    0.825637] pci 0000:00:1f.2: PME# disabled
[    0.825683] pci 0000:00:1f.3: [8086:2930] type 0 class 0x000c05
[    0.825711] pci 0000:00:1f.3: reg 10: [mem 0xf2827400-0xf28274ff 64bit]
[    0.825750] pci 0000:00:1f.3: reg 20: [io  0x1c60-0x1c7f]
[    0.825888] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.825943] pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.825950] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.825960] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.826168] pci 0000:03:00.0: [8086:4237] type 0 class 0x000280
[    0.826244] pci 0000:03:00.0: reg 10: [mem 0xf2500000-0xf2501fff 64bit]
[    0.826483] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.826512] pci 0000:03:00.0: PME# disabled
[    0.826632] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.826687] pci 0000:00:1c.1:   bridge window [io  0xf000-0x0000] (disabled)
[    0.826693] pci 0000:00:1c.1:   bridge window [mem 0xf2500000-0xf25fffff]
[    0.826704] pci 0000:00:1c.1:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.826796] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    0.826850] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    0.826856] pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf1ffffff]
[    0.826866] pci 0000:00:1c.3:   bridge window [mem 0xf2900000-0xf29fffff 64bit pref]
[    0.827002] pci 0000:00:1e.0: PCI bridge to [bus 0d-0d] (subtractive decode)
[    0.827059] pci 0000:00:1e.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.827066] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.827076] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.827088] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.827100] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.827112] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.827123] pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive decode)
[    0.827135] pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
[    0.827147] pci 0000:00:1e.0:   bridge window [mem 0xc0000000-0xfebfffff] (subtractive decode)
[    0.827181] pci_bus 0000:00: on NUMA node 0
[    0.827203] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.833922] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP0._PRT]
[    0.835359] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
[    0.836864] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP3._PRT]
[    0.845610]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.858286]  pci0000:00: ACPI _OSC control (0x1d) granted
[    1.059966] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
[    1.062209] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
[    1.064614] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
[    1.066855] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
[    1.069121] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
[    1.071362] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
[    1.073716] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
[    1.075959] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
[    1.077214] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    1.077456] vgaarb: loaded
[    1.078918] SCSI subsystem initialized
[    1.078993] libata version 3.00 loaded.
[    1.078993] PCI: Using ACPI for IRQ routing
[    1.078993] PCI: pci_cache_line_size set to 64 bytes
[    1.080670] reserve RAM buffer: 000000000009ec00 - 000000000009ffff 
[    1.080681] reserve RAM buffer: 00000000bd6a1000 - 00000000bfffffff 
[    1.080831] reserve RAM buffer: 00000000bd7b7000 - 00000000bfffffff 
[    1.080958] reserve RAM buffer: 00000000bd8c7000 - 00000000bfffffff 
[    1.081065] reserve RAM buffer: 00000000bdc00000 - 00000000bfffffff 
[    1.082235] Bluetooth: Core ver 2.15
[    1.082384] NET: Registered protocol family 31
[    1.082433] Bluetooth: HCI device and connection manager initialized
[    1.082497] Bluetooth: HCI socket layer initialized
[    1.082889] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    1.088274] Switching to clocksource hpet
[    1.088395] pnp: PnP ACPI init
[    1.088598] ACPI: bus type pnp registered
[    1.091654] Switched to NOHz mode on CPU #0
[    1.091687] Switched to NOHz mode on CPU #1
[    1.122142] pnp 00:00: [mem 0x00000000-0x0009ffff]
[    1.122152] pnp 00:00: [mem 0x000c0000-0x000c3fff]
[    1.122162] pnp 00:00: [mem 0x000c4000-0x000c7fff]
[    1.122172] pnp 00:00: [mem 0x000c8000-0x000cbfff]
[    1.122182] pnp 00:00: [mem 0x000cc000-0x000cffff]
[    1.122191] pnp 00:00: [mem 0x000d0000-0x000d3fff]
[    1.122201] pnp 00:00: [mem 0x000d4000-0x000d3fff disabled]
[    1.122211] pnp 00:00: [mem 0x000d8000-0x000d7fff disabled]
[    1.122221] pnp 00:00: [mem 0x000dc000-0x000dffff]
[    1.122230] pnp 00:00: [mem 0x000e0000-0x000e3fff]
[    1.122240] pnp 00:00: [mem 0x000e4000-0x000e7fff]
[    1.122249] pnp 00:00: [mem 0x000e8000-0x000ebfff]
[    1.122259] pnp 00:00: [mem 0x000ec000-0x000effff]
[    1.122268] pnp 00:00: [mem 0x000f0000-0x000fffff]
[    1.122278] pnp 00:00: [mem 0x00100000-0xbfffffff]
[    1.122288] pnp 00:00: [mem 0xfec00000-0xfed3ffff]
[    1.122298] pnp 00:00: [mem 0xfed4c000-0xffffffff]
[    1.122997] system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
[    1.123070] system 00:00: [mem 0x000c0000-0x000c3fff] has been reserved
[    1.123140] system 00:00: [mem 0x000c4000-0x000c7fff] has been reserved
[    1.123211] system 00:00: [mem 0x000c8000-0x000cbfff] has been reserved
[    1.123281] system 00:00: [mem 0x000cc000-0x000cffff] has been reserved
[    1.123352] system 00:00: [mem 0x000d0000-0x000d3fff] has been reserved
[    1.123428] system 00:00: [mem 0x000dc000-0x000dffff] could not be reserved
[    1.123504] system 00:00: [mem 0x000e0000-0x000e3fff] could not be reserved
[    1.123579] system 00:00: [mem 0x000e4000-0x000e7fff] could not be reserved
[    1.123655] system 00:00: [mem 0x000e8000-0x000ebfff] could not be reserved
[    1.123731] system 00:00: [mem 0x000ec000-0x000effff] could not be reserved
[    1.123806] system 00:00: [mem 0x000f0000-0x000fffff] could not be reserved
[    1.123882] system 00:00: [mem 0x00100000-0xbfffffff] could not be reserved
[    1.123959] system 00:00: [mem 0xfec00000-0xfed3ffff] could not be reserved
[    1.124052] system 00:00: [mem 0xfed4c000-0xffffffff] could not be reserved
[    1.124108] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    1.124310] pnp 00:01: [bus 00-ff]
[    1.124320] pnp 00:01: [io  0x0cf8-0x0cff]
[    1.124330] pnp 00:01: [io  0x0000-0x0cf7 window]
[    1.124340] pnp 00:01: [io  0x0d00-0xffff window]
[    1.124349] pnp 00:01: [mem 0x000a0000-0x000bffff window]
[    1.124359] pnp 00:01: [mem 0x000c0000-0x000c3fff window]
[    1.124369] pnp 00:01: [mem 0x000c4000-0x000c7fff window]
[    1.124381] pnp 00:01: [mem 0x000c8000-0x000cbfff window]
[    1.124390] pnp 00:01: [mem 0x000cc000-0x000cffff window]
[    1.124400] pnp 00:01: [mem 0x000d0000-0x000d3fff window]
[    1.124410] pnp 00:01: [mem 0x000d4000-0x000d7fff window]
[    1.124419] pnp 00:01: [mem 0x000d8000-0x000dbfff window]
[    1.124428] pnp 00:01: [mem 0x000dc000-0x000dffff window]
[    1.124438] pnp 00:01: [mem 0x000e0000-0x000e3fff window]
[    1.124447] pnp 00:01: [mem 0x000e4000-0x000e7fff window]
[    1.124457] pnp 00:01: [mem 0x000e8000-0x000ebfff window]
[    1.124466] pnp 00:01: [mem 0x000ec000-0x000effff window]
[    1.124476] pnp 00:01: [mem 0xc0000000-0xfebfffff window]
[    1.124486] pnp 00:01: [mem 0xfed40000-0xfed4bfff window]
[    1.124857] pnp 00:01: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    1.146951] pnp 00:02: [io  0x0010-0x001f]
[    1.146961] pnp 00:02: [io  0x0090-0x009f]
[    1.146971] pnp 00:02: [io  0x0024-0x0025]
[    1.146980] pnp 00:02: [io  0x0028-0x0029]
[    1.146990] pnp 00:02: [io  0x002c-0x002d]
[    1.146999] pnp 00:02: [io  0x0030-0x0031]
[    1.147008] pnp 00:02: [io  0x0034-0x0035]
[    1.147017] pnp 00:02: [io  0x0038-0x0039]
[    1.147027] pnp 00:02: [io  0x003c-0x003d]
[    1.147036] pnp 00:02: [io  0x00a4-0x00a5]
[    1.147046] pnp 00:02: [io  0x00a8-0x00a9]
[    1.147055] pnp 00:02: [io  0x00ac-0x00ad]
[    1.147064] pnp 00:02: [io  0x00b0-0x00b5]
[    1.147073] pnp 00:02: [io  0x00b8-0x00b9]
[    1.147083] pnp 00:02: [io  0x00bc-0x00bd]
[    1.147092] pnp 00:02: [io  0x0050-0x0053]
[    1.147101] pnp 00:02: [io  0x0072-0x0077]
[    1.147111] pnp 00:02: [io  0x002e-0x002f]
[    1.147120] pnp 00:02: [io  0x1000-0x107f]
[    1.147129] pnp 00:02: [io  0x1180-0x11ff]
[    1.147139] pnp 00:02: [io  0x0800-0x080f]
[    1.147148] pnp 00:02: [io  0x15e0-0x15ef]
[    1.147158] pnp 00:02: [io  0x1600-0x167f]
[    1.147167] pnp 00:02: [io  0x1680-0x169f]
[    1.147176] pnp 00:02: [mem 0xe0000000-0xefffffff]
[    1.147186] pnp 00:02: [mem 0xfed1c000-0xfed1ffff]
[    1.147196] pnp 00:02: [mem 0xfed10000-0xfed13fff]
[    1.147205] pnp 00:02: [mem 0xfed18000-0xfed18fff]
[    1.147215] pnp 00:02: [mem 0xfed19000-0xfed19fff]
[    1.147224] pnp 00:02: [mem 0xfed45000-0xfed4bfff]
[    1.147953] system 00:02: [io  0x1000-0x107f] has been reserved
[    1.148040] system 00:02: [io  0x1180-0x11ff] has been reserved
[    1.148110] system 00:02: [io  0x0800-0x080f] has been reserved
[    1.148179] system 00:02: [io  0x15e0-0x15ef] has been reserved
[    1.148249] system 00:02: [io  0x1600-0x167f] has been reserved
[    1.148319] system 00:02: [io  0x1680-0x169f] has been reserved
[    1.148390] system 00:02: [mem 0xe0000000-0xefffffff] has been reserved
[    1.148461] system 00:02: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    1.148532] system 00:02: [mem 0xfed10000-0xfed13fff] has been reserved
[    1.148604] system 00:02: [mem 0xfed18000-0xfed18fff] has been reserved
[    1.148675] system 00:02: [mem 0xfed19000-0xfed19fff] has been reserved
[    1.148746] system 00:02: [mem 0xfed45000-0xfed4bfff] has been reserved
[    1.148801] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.149424] pnp 00:03: [mem 0xfed00000-0xfed003ff]
[    1.149787] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.149920] pnp 00:04: [io  0x0000-0x000f]
[    1.149930] pnp 00:04: [io  0x0080-0x008f]
[    1.149939] pnp 00:04: [io  0x00c0-0x00df]
[    1.149949] pnp 00:04: [dma 4]
[    1.150309] pnp 00:04: Plug and Play ACPI device, IDs PNP0200 (active)
[    1.150441] pnp 00:05: [io  0x0061]
[    1.150805] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
[    1.150937] pnp 00:06: [io  0x00f0]
[    1.150955] pnp 00:06: [irq 13]
[    1.151321] pnp 00:06: Plug and Play ACPI device, IDs PNP0c04 (active)
[    1.151455] pnp 00:07: [io  0x0070-0x0071]
[    1.151470] pnp 00:07: [irq 8]
[    1.151837] pnp 00:07: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.151971] pnp 00:08: [io  0x0060]
[    1.151981] pnp 00:08: [io  0x0064]
[    1.152015] pnp 00:08: [irq 1]
[    1.152379] pnp 00:08: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.152517] pnp 00:09: [irq 12]
[    1.152891] pnp 00:09: Plug and Play ACPI device, IDs IBM3780 PNP0f13 (active)
[    1.174751] pnp 00:0a: [mem 0xfed40000-0xfed44fff]
[    1.175118] pnp 00:0a: Plug and Play ACPI device, IDs PNP0c31 (active)
[    1.179106] pnp: PnP ACPI: found 11 devices
[    1.179156] ACPI: ACPI bus type pnp unregistered
[    1.206974] pci 0000:00:1c.0: BAR 8: assigned [mem 0xc0000000-0xc01fffff]
[    1.207033] pci 0000:00:1c.0: BAR 9: assigned [mem 0xc0200000-0xc03fffff 64bit pref]
[    1.207101] pci 0000:00:1c.1: BAR 9: assigned [mem 0xc0400000-0xc05fffff 64bit pref]
[    1.207169] pci 0000:00:1c.0: BAR 7: assigned [io  0x3000-0x3fff]
[    1.207225] pci 0000:00:1c.1: BAR 7: assigned [io  0x4000-0x4fff]
[    1.207279] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    1.207331] pci 0000:00:1c.0:   bridge window [io  0x3000-0x3fff]
[    1.207388] pci 0000:00:1c.0:   bridge window [mem 0xc0000000-0xc01fffff]
[    1.207443] pci 0000:00:1c.0:   bridge window [mem 0xc0200000-0xc03fffff 64bit pref]
[    1.207513] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    1.207565] pci 0000:00:1c.1:   bridge window [io  0x4000-0x4fff]
[    1.207621] pci 0000:00:1c.1:   bridge window [mem 0xf2500000-0xf25fffff]
[    1.207677] pci 0000:00:1c.1:   bridge window [mem 0xc0400000-0xc05fffff 64bit pref]
[    1.207747] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    1.207799] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    1.207856] pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf1ffffff]
[    1.207911] pci 0000:00:1c.3:   bridge window [mem 0xf2900000-0xf29fffff 64bit pref]
[    1.207982] pci 0000:00:1e.0: PCI bridge to [bus 0d-0d]
[    1.208050] pci 0000:00:1e.0:   bridge window [io  disabled]
[    1.208105] pci 0000:00:1e.0:   bridge window [mem disabled]
[    1.208159] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    1.208238] pci 0000:00:1c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    1.208295] pci 0000:00:1c.0: setting latency timer to 64
[    1.208316] pci 0000:00:1c.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    1.208372] pci 0000:00:1c.1: setting latency timer to 64
[    1.208393] pci 0000:00:1c.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    1.208449] pci 0000:00:1c.3: setting latency timer to 64
[    1.208459] pci 0000:00:1e.0: setting latency timer to 64
[    1.208465] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.208468] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.208471] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.208474] pci_bus 0000:00: resource 7 [mem 0x000d4000-0x000d7fff]
[    1.208476] pci_bus 0000:00: resource 8 [mem 0x000d8000-0x000dbfff]
[    1.208480] pci_bus 0000:00: resource 9 [mem 0xc0000000-0xfebfffff]
[    1.208483] pci_bus 0000:02: resource 0 [io  0x3000-0x3fff]
[    1.208486] pci_bus 0000:02: resource 1 [mem 0xc0000000-0xc01fffff]
[    1.208489] pci_bus 0000:02: resource 2 [mem 0xc0200000-0xc03fffff 64bit pref]
[    1.208492] pci_bus 0000:03: resource 0 [io  0x4000-0x4fff]
[    1.208495] pci_bus 0000:03: resource 1 [mem 0xf2500000-0xf25fffff]
[    1.208498] pci_bus 0000:03: resource 2 [mem 0xc0400000-0xc05fffff 64bit pref]
[    1.208501] pci_bus 0000:05: resource 0 [io  0x2000-0x2fff]
[    1.208504] pci_bus 0000:05: resource 1 [mem 0xf0000000-0xf1ffffff]
[    1.208507] pci_bus 0000:05: resource 2 [mem 0xf2900000-0xf29fffff 64bit pref]
[    1.208510] pci_bus 0000:0d: resource 4 [io  0x0000-0x0cf7]
[    1.208513] pci_bus 0000:0d: resource 5 [io  0x0d00-0xffff]
[    1.208516] pci_bus 0000:0d: resource 6 [mem 0x000a0000-0x000bffff]
[    1.208519] pci_bus 0000:0d: resource 7 [mem 0x000d4000-0x000d7fff]
[    1.208522] pci_bus 0000:0d: resource 8 [mem 0x000d8000-0x000dbfff]
[    1.208525] pci_bus 0000:0d: resource 9 [mem 0xc0000000-0xfebfffff]
[    1.208660] NET: Registered protocol family 2
[    1.208961] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    1.210496] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    1.212222] TCP bind hash table entries: 65536 (order: 10, 4194304 bytes)
[    1.215644] TCP: Hash tables configured (established 262144 bind 65536)
[    1.215732] TCP reno registered
[    1.215801] UDP hash table entries: 2048 (order: 6, 327680 bytes)
[    1.216121] UDP-Lite hash table entries: 2048 (order: 6, 327680 bytes)
[    1.216839] NET: Registered protocol family 1
[    1.216955] pci 0000:00:02.0: Boot video device
[    1.217027] pci 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x00c0
[    1.217030] pci 0000:00:1a.0: Performing full reset
[    1.217062] pci 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x00c0
[    1.217065] pci 0000:00:1a.1: Performing full reset
[    1.217096] pci 0000:00:1a.2: uhci_check_and_reset_hc: cmd = 0x00c0
[    1.217099] pci 0000:00:1a.2: Performing full reset
[    1.217254] pci 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x00c0
[    1.217257] pci 0000:00:1d.0: Performing full reset
[    1.217288] pci 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x00c0
[    1.217291] pci 0000:00:1d.1: Performing full reset
[    1.217321] pci 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x00c0
[    1.217323] pci 0000:00:1d.2: Performing full reset
[    1.217463] PCI: CLS 64 bytes, default 64
[    1.217836] Trying to unpack rootfs image as initramfs...
[    2.136665] Freeing initrd memory: 32652k freed
[    2.293760] DMA-API: preallocated 32768 debug entries
[    2.293816] DMA-API: debugging enabled by kernel config
[    2.293875] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    2.293928] Placing 64MB software IO TLB between ffff8800b8c9d000 - ffff8800bcc9d000
[    2.293991] software IO TLB at phys 0xb8c9d000 - 0xbcc9d000
[    2.294219] Simple Boot Flag at 0x35 set to 0x1
[    2.295698] Scanning for low memory corruption every 60 seconds
[    2.296592] audit: initializing netlink socket (disabled)
[    2.296720] type=2000 audit(1300215811.292:1): initialized
[    2.313835] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    2.339042] fuse init (API version 7.16)
[    2.340102] msgmni has been set to 7697
[    2.341377] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    2.341448] io scheduler noop registered
[    2.341497] io scheduler deadline registered
[    2.341861] io scheduler cfq registered (default)
[    2.342826] pcieport 0000:00:1c.0: setting latency timer to 64
[    2.342906] pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
[    2.343614] pcieport 0000:00:1c.1: setting latency timer to 64
[    2.343688] pcieport 0000:00:1c.1: irq 41 for MSI/MSI-X
[    2.344413] pcieport 0000:00:1c.3: setting latency timer to 64
[    2.344487] pcieport 0000:00:1c.3: irq 42 for MSI/MSI-X
[    2.345521] pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
[    2.345579] pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
[    2.345761] pcieport 0000:00:1c.1: Signaling PME through PCIe PME interrupt
[    2.345815] pci 0000:03:00.0: Signaling PME through PCIe PME interrupt
[    2.345870] pcie_pme 0000:00:1c.1:pcie01: service driver pcie_pme loaded
[    2.346053] pcieport 0000:00:1c.3: Signaling PME through PCIe PME interrupt
[    2.346653] pcie_pme 0000:00:1c.3:pcie01: service driver pcie_pme loaded
[    2.346826] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    2.347652] pciehp 0000:00:1c.0:pcie04: HPC vendor_id 8086 device_id 2940 ss_vid 17aa ss_did 20f3
[    2.347947] pciehp 0000:00:1c.0:pcie04: service driver pciehp loaded
[    2.348072] pciehp 0000:00:1c.1:pcie04: HPC vendor_id 8086 device_id 2942 ss_vid 17aa ss_did 20f3
[    2.348356] pciehp 0000:00:1c.1:pcie04: service driver pciehp loaded
[    2.348414] pciehp 0000:00:1c.3:pcie04: HPC vendor_id 8086 device_id 2946 ss_vid 17aa ss_did 20f3
[    2.348698] pciehp 0000:00:1c.3:pcie04: service driver pciehp loaded
[    2.348761] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    2.349586] ACPI: Deprecated procfs I/F for AC is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    2.350795] ACPI: AC Adapter [AC] (on-line)
[    2.352284] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
[    2.392028] ACPI: Lid Switch [LID]
[    2.392740] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input1
[    2.456022] ACPI: Sleep Button [SLPB]
[    2.456743] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    2.456819] ACPI: Power Button [PWRF]
[    2.457050] ACPI: acpi_idle registered with cpuidle
[    2.575963] Monitor-Mwait will be used to enter C-1 state
[    2.576053] Monitor-Mwait will be used to enter C-2 state
[    2.576129] Monitor-Mwait will be used to enter C-3 state
[    2.576141] Marking TSC unstable due to TSC halts in idle
[    2.673321] thermal LNXTHERM:00: registered as thermal_zone0
[    2.673373] ACPI: Thermal Zone [THM0] (58 C)
[    2.683037] thermal LNXTHERM:01: registered as thermal_zone1
[    2.683089] ACPI: Thermal Zone [THM1] (59 C)
[    2.683861] Linux agpgart interface v0.103
[    2.700227] brd: module loaded
[    2.708493] loop: module loaded
[    2.709950] ahci 0000:00:1f.2: version 3.0
[    2.709990] ahci 0000:00:1f.2: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    2.710382] ahci 0000:00:1f.2: irq 43 for MSI/MSI-X
[    2.710609] ahci: SSS flag set, parallel bus scan disabled
[    2.710712] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 4 ports 3 Gbps 0x3 impl SATA mode
[    2.710778] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part ccc sxs 
[    2.710846] ahci 0000:00:1f.2: setting latency timer to 64
[    2.720802] scsi0 : ahci
[    2.724998] scsi1 : ahci
[    2.726171] scsi2 : ahci
[    2.727393] scsi3 : ahci
[    2.738846] ata1: SATA max UDMA/133 abar m2048@0xf2826000 port 0xf2826100 irq 43
[    2.738912] ata2: SATA max UDMA/133 abar m2048@0xf2826000 port 0xf2826180 irq 43
[    2.738975] ata3: DUMMY
[    2.739020] ata4: DUMMY
[    2.739177] ACPI: Deprecated procfs I/F for battery is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    2.739329] ACPI: Battery Slot [BAT0] (battery present)
[    2.739556] ata_generic 0000:00:03.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    2.739744] ata_generic 0000:00:03.2: setting latency timer to 64
[    2.745912] scsi4 : ata_generic
[    2.746933] scsi5 : ata_generic
[    2.747849] ata5: PATA max UDMA/100 cmd 0x1828 ctl 0x180c bmdma 0x1810 irq 18
[    2.747903] ata6: PATA max UDMA/100 cmd 0x1820 ctl 0x1808 bmdma 0x1818 irq 18
[    2.748238] e1000e: Intel(R) PRO/1000 Network Driver - 1.2.20-k2
[    2.748290] e1000e: Copyright(c) 1999 - 2011 Intel Corporation.
[    2.748418] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    2.748493] e1000e 0000:00:19.0: setting latency timer to 64
[    2.748767] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[    3.056031] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    3.059450] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    3.059455] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    3.059520] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    3.059822] ata1.00: ATA-7: INTEL SSDSA2M160G2GC, 2CV102M3, max UDMA/133
[    3.059875] ata1.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    3.063390] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    3.063395] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    3.063460] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    3.063762] ata1.00: configured for UDMA/133
[    3.064687] scsi 0:0:0:0: Direct-Access     ATA      INTEL SSDSA2M160 2CV1 PQ: 0 ANSI: 5
[    3.067423] e1000e 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:1f:16:1d:fb:eb
[    3.067489] e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    3.067563] e1000e 0000:00:19.0: eth0: MAC: 7, PHY: 8, PBA No: 1008FF-0FF
[    3.067645] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    3.067775] PPP generic driver version 2.4.2
[    3.068665] sd 0:0:0:0: [sda] 312581808 512-byte logical blocks: (160 GB/149 GiB)
[    3.068668] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    3.069697] sd 0:0:0:0: [sda] Write Protect is off
[    3.069750] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.070013] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.074238]  sda: sda1 sda2
[    3.078490] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.080672] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.081116] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.082102] mousedev: PS/2 mouse device common for all mice
[    3.083566] rtc_cmos 00:07: RTC can wake from S4
[    3.089038] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
[    3.096760] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
[    3.096878] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    3.096995] Linux video capture interface: v2.00
[    3.097511] device-mapper: uevent: version 1.0.3
[    3.098181] device-mapper: ioctl: 4.19.1-ioctl (2011-01-07) initialised: dm-devel@redhat.com
[    3.098432] device-mapper: multipath: version 1.2.0 loaded
[    3.098502] device-mapper: multipath round-robin: version 1.0.0 loaded
[    3.100031] cpuidle: using governor ladder
[    3.101562] cpuidle: using governor menu
[    3.102525] TCP cubic registered
[    3.103746] NET: Registered protocol family 10
[    3.106214] NET: Registered protocol family 17
[    3.106455] Bluetooth: L2CAP ver 2.15
[    3.106503] Bluetooth: L2CAP socket layer initialized
[    3.106569] Bluetooth: SCO (Voice Link) ver 0.6
[    3.106618] Bluetooth: SCO socket layer initialized
[    3.106847] Bluetooth: RFCOMM TTY layer initialized
[    3.106916] Bluetooth: RFCOMM socket layer initialized
[    3.106966] Bluetooth: RFCOMM ver 1.11
[    3.107013] Registering the dns_resolver key type
[    3.107957] registered taskstats version 1
[    3.108200] kmemleak: Kernel memory leak detector initialized
[    3.108225] kmemleak: Automatic memory scanning thread started
[    3.109740] rtc_cmos 00:07: setting system clock to 2011-03-15 19:03:33 UTC (1300215813)
[    3.109806] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    3.109856] EDD information not available.
[    3.388103] ata2: SATA link down (SStatus 0 SControl 300)
[    3.556253] Freeing unused kernel memory: 524k freed
[    3.556512] Write protecting the kernel read-only data: 8192k
[    3.561798] Freeing unused kernel memory: 1356k freed
[    3.562560] Freeing unused kernel memory: 16k freed
[    3.607889] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[    3.626537] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/input/input4
[    4.032464] usbcore: registered new interface driver usbfs
[    4.033481] usbcore: registered new interface driver hub
[    4.044899] usbcore: registered new device driver usb
[    4.047648] uhci_hcd: USB Universal Host Controller Interface driver
[    4.048198] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[    4.048266] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[    4.048326] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    4.048404] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    4.048409] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    4.048563] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    4.057651] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    4.057705] Warning! ehci_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
[    4.057772] ehci_hcd: block sizes: qh 104 qtd 96 itd 192 sitd 96
[    4.060151] uhci_hcd 0000:00:1a.0: detected 2 ports
[    4.060212] uhci_hcd 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x0000
[    4.060215] uhci_hcd 0000:00:1a.0: Performing full reset
[    4.060231] uhci_hcd 0000:00:1a.0: supports USB remote wakeup
[    4.060377] uhci_hcd 0000:00:1a.0: irq 20, io base 0x00001860
[    4.060813] usb usb1: default language 0x0409
[    4.060952] usb usb1: udev 1, busnum 1, minor = 0
[    4.060955] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[    4.061006] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.061068] usb usb1: Product: UHCI Host Controller
[    4.061116] usb usb1: Manufacturer: Linux 2.6.38-rc8+ uhci_hcd
[    4.061166] usb usb1: SerialNumber: 0000:00:1a.0
[    4.061909] usb usb1: usb_probe_device
[    4.061913] usb usb1: configuration #1 chosen from 1 choice
[    4.062027] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    4.062513] hub 1-0:1.0: usb_probe_interface
[    4.062516] hub 1-0:1.0: usb_probe_interface - got id
[    4.062520] hub 1-0:1.0: USB hub found
[    4.062663] hub 1-0:1.0: 2 ports detected
[    4.062730] hub 1-0:1.0: standalone hub
[    4.062732] hub 1-0:1.0: no power switching (usb 1.0)
[    4.062735] hub 1-0:1.0: individual port over-current protection
[    4.062737] hub 1-0:1.0: power on to power good time: 2ms
[    4.062844] hub 1-0:1.0: local power source is good
[    4.062860] hub 1-0:1.0: trying to enable port power on non-switchable hub
[    4.064744] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    4.064821] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    4.064826] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    4.064924] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 2
[    4.080110] uhci_hcd 0000:00:1a.1: detected 2 ports
[    4.080178] uhci_hcd 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x0000
[    4.080181] uhci_hcd 0000:00:1a.1: Performing full reset
[    4.080355] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00001880
[    4.080698] usb usb2: default language 0x0409
[    4.080835] usb usb2: udev 1, busnum 2, minor = 128
[    4.080838] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    4.080890] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.080952] usb usb2: Product: UHCI Host Controller
[    4.081000] usb usb2: Manufacturer: Linux 2.6.38-rc8+ uhci_hcd
[    4.081050] usb usb2: SerialNumber: 0000:00:1a.1
[    4.081775] usb usb2: usb_probe_device
[    4.081779] usb usb2: configuration #1 chosen from 1 choice
[    4.081855] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[    4.082320] hub 2-0:1.0: usb_probe_interface
[    4.082323] hub 2-0:1.0: usb_probe_interface - got id
[    4.082328] hub 2-0:1.0: USB hub found
[    4.082467] hub 2-0:1.0: 2 ports detected
[    4.082536] hub 2-0:1.0: standalone hub
[    4.082538] hub 2-0:1.0: no power switching (usb 1.0)
[    4.082540] hub 2-0:1.0: individual port over-current protection
[    4.082543] hub 2-0:1.0: power on to power good time: 2ms
[    4.082625] hub 2-0:1.0: local power source is good
[    4.082641] hub 2-0:1.0: trying to enable port power on non-switchable hub
[    4.084474] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[    4.084541] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[    4.084612] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    4.084687] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    4.084692] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    4.084789] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 3
[    4.108088] uhci_hcd 0000:00:1a.2: detected 2 ports
[    4.108146] uhci_hcd 0000:00:1a.2: uhci_check_and_reset_hc: cmd = 0x0000
[    4.108149] uhci_hcd 0000:00:1a.2: Performing full reset
[    4.108165] uhci_hcd 0000:00:1a.2: supports USB remote wakeup
[    4.108303] uhci_hcd 0000:00:1a.2: irq 22, io base 0x000018a0
[    4.108628] usb usb3: default language 0x0409
[    4.108765] usb usb3: udev 1, busnum 3, minor = 256
[    4.108767] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    4.109360] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.109422] usb usb3: Product: UHCI Host Controller
[    4.109471] usb usb3: Manufacturer: Linux 2.6.38-rc8+ uhci_hcd
[    4.109520] usb usb3: SerialNumber: 0000:00:1a.2
[    4.110235] usb usb3: usb_probe_device
[    4.110238] usb usb3: configuration #1 chosen from 1 choice
[    4.110314] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[    4.110856] hub 3-0:1.0: usb_probe_interface
[    4.110860] hub 3-0:1.0: usb_probe_interface - got id
[    4.110865] hub 3-0:1.0: USB hub found
[    4.111008] hub 3-0:1.0: 2 ports detected
[    4.111072] hub 3-0:1.0: standalone hub
[    4.111074] hub 3-0:1.0: no power switching (usb 1.0)
[    4.111077] hub 3-0:1.0: individual port over-current protection
[    4.111080] hub 3-0:1.0: power on to power good time: 2ms
[    4.111176] hub 3-0:1.0: local power source is good
[    4.111193] hub 3-0:1.0: trying to enable port power on non-switchable hub
[    4.112942] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[    4.113012] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[    4.113074] ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    4.113222] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    4.113227] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    4.113325] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 4
[    4.124274] ehci_hcd 0000:00:1a.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[    4.124281] ehci_hcd 0000:00:1a.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr hw prefetch
[    4.124450] ehci_hcd 0000:00:1a.7: debug port 1
[    4.124503] ehci_hcd 0000:00:1a.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    4.128387] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
[    4.128390] ehci_hcd 0000:00:1a.7: supports USB remote wakeup
[    4.128527] ehci_hcd 0000:00:1a.7: irq 23, io mem 0xf2826c00
[    4.128580] ehci_hcd 0000:00:1a.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    4.132471] ehci_hcd 0000:00:1a.7: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
[    4.148063] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    4.148462] usb usb4: default language 0x0409
[    4.148596] usb usb4: udev 1, busnum 4, minor = 384
[    4.148599] usb usb4: New USB device found, idVendor=1d6b, idProduct=0002
[    4.148651] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.148712] usb usb4: Product: EHCI Host Controller
[    4.148761] usb usb4: Manufacturer: Linux 2.6.38-rc8+ ehci_hcd
[    4.148810] usb usb4: SerialNumber: 0000:00:1a.7
[    4.149515] usb usb4: usb_probe_device
[    4.149519] usb usb4: configuration #1 chosen from 1 choice
[    4.149595] usb usb4: adding 4-0:1.0 (config #1, interface 0)
[    4.150166] hub 4-0:1.0: usb_probe_interface
[    4.150169] hub 4-0:1.0: usb_probe_interface - got id
[    4.150173] hub 4-0:1.0: USB hub found
[    4.150333] hub 4-0:1.0: 6 ports detected
[    4.150396] hub 4-0:1.0: standalone hub
[    4.150398] hub 4-0:1.0: no power switching (usb 1.0)
[    4.150401] hub 4-0:1.0: individual port over-current protection
[    4.150404] hub 4-0:1.0: power on to power good time: 20ms
[    4.150498] hub 4-0:1.0: local power source is good
[    4.150515] hub 4-0:1.0: trying to enable port power on non-switchable hub
[    4.152077] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.0
[    4.152092] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.1
[    4.152107] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.2
[    4.152345] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    4.152413] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    4.152469] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    4.152544] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    4.152549] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    4.152647] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
[    4.160128] uhci_hcd 0000:00:1a.0: port 1 portsc 0082,00
[    4.160166] uhci_hcd 0000:00:1d.0: detected 2 ports
[    4.160225] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
[    4.160228] uhci_hcd 0000:00:1d.0: Performing full reset
[    4.160246] uhci_hcd 0000:00:1d.0: supports USB remote wakeup
[    4.160402] uhci_hcd 0000:00:1d.0: irq 16, io base 0x000018c0
[    4.160726] usb usb5: default language 0x0409
[    4.160863] usb usb5: udev 1, busnum 5, minor = 512
[    4.160866] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    4.160918] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.160979] usb usb5: Product: UHCI Host Controller
[    4.161028] usb usb5: Manufacturer: Linux 2.6.38-rc8+ uhci_hcd
[    4.161077] usb usb5: SerialNumber: 0000:00:1d.0
[    4.161796] usb usb5: usb_probe_device
[    4.161799] usb usb5: configuration #1 chosen from 1 choice
[    4.161875] usb usb5: adding 5-0:1.0 (config #1, interface 0)
[    4.162342] hub 5-0:1.0: usb_probe_interface
[    4.162345] hub 5-0:1.0: usb_probe_interface - got id
[    4.162349] hub 5-0:1.0: USB hub found
[    4.162489] hub 5-0:1.0: 2 ports detected
[    4.162559] hub 5-0:1.0: standalone hub
[    4.162561] hub 5-0:1.0: no power switching (usb 1.0)
[    4.162563] hub 5-0:1.0: individual port over-current protection
[    4.162566] hub 5-0:1.0: power on to power good time: 2ms
[    4.162648] hub 5-0:1.0: local power source is good
[    4.162663] hub 5-0:1.0: trying to enable port power on non-switchable hub
[    4.164296] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    4.164367] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    4.164372] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    4.164463] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
[    4.184107] uhci_hcd 0000:00:1d.1: detected 2 ports
[    4.184119] uhci_hcd 0000:00:1a.1: port 1 portsc 0082,00
[    4.184166] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
[    4.184169] uhci_hcd 0000:00:1d.1: Performing full reset
[    4.184175] uhci_hcd 0000:00:1a.1: port 2 portsc 0082,00
[    4.184343] uhci_hcd 0000:00:1d.1: irq 17, io base 0x000018e0
[    4.184673] usb usb6: default language 0x0409
[    4.184808] usb usb6: udev 1, busnum 6, minor = 640
[    4.184811] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    4.184862] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.184924] usb usb6: Product: UHCI Host Controller
[    4.184972] usb usb6: Manufacturer: Linux 2.6.38-rc8+ uhci_hcd
[    4.185022] usb usb6: SerialNumber: 0000:00:1d.1
[    4.185734] usb usb6: usb_probe_device
[    4.185737] usb usb6: configuration #1 chosen from 1 choice
[    4.185812] usb usb6: adding 6-0:1.0 (config #1, interface 0)
[    4.186279] hub 6-0:1.0: usb_probe_interface
[    4.186282] hub 6-0:1.0: usb_probe_interface - got id
[    4.186286] hub 6-0:1.0: USB hub found
[    4.186425] hub 6-0:1.0: 2 ports detected
[    4.186494] hub 6-0:1.0: standalone hub
[    4.186496] hub 6-0:1.0: no power switching (usb 1.0)
[    4.186499] hub 6-0:1.0: individual port over-current protection
[    4.186501] hub 6-0:1.0: power on to power good time: 2ms
[    4.186583] hub 6-0:1.0: local power source is good
[    4.186598] hub 6-0:1.0: trying to enable port power on non-switchable hub
[    4.188190] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    4.188268] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    4.188273] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    4.188369] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
[    4.208116] uhci_hcd 0000:00:1d.2: detected 2 ports
[    4.208134] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    4.208171] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
[    4.208174] uhci_hcd 0000:00:1d.2: Performing full reset
[    4.208227] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001c00
[    4.208564] usb usb7: default language 0x0409
[    4.208702] usb usb7: udev 1, busnum 7, minor = 768
[    4.208705] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    4.208757] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.208818] usb usb7: Product: UHCI Host Controller
[    4.208867] usb usb7: Manufacturer: Linux 2.6.38-rc8+ uhci_hcd
[    4.208917] usb usb7: SerialNumber: 0000:00:1d.2
[    4.209629] usb usb7: usb_probe_device
[    4.209632] usb usb7: configuration #1 chosen from 1 choice
[    4.209708] usb usb7: adding 7-0:1.0 (config #1, interface 0)
[    4.210175] hub 7-0:1.0: usb_probe_interface
[    4.210178] hub 7-0:1.0: usb_probe_interface - got id
[    4.210182] hub 7-0:1.0: USB hub found
[    4.210322] hub 7-0:1.0: 2 ports detected
[    4.210390] hub 7-0:1.0: standalone hub
[    4.210393] hub 7-0:1.0: no power switching (usb 1.0)
[    4.210395] hub 7-0:1.0: individual port over-current protection
[    4.210397] hub 7-0:1.0: power on to power good time: 2ms
[    4.210478] hub 7-0:1.0: local power source is good
[    4.210492] hub 7-0:1.0: trying to enable port power on non-switchable hub
[    4.212106] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[    4.212176] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[    4.212249] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    4.212598] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    4.212603] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    4.212703] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 8
[    4.228094] ehci_hcd 0000:00:1d.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[    4.228100] ehci_hcd 0000:00:1d.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr hw prefetch
[    4.228266] ehci_hcd 0000:00:1d.7: debug port 1
[    4.228325] ehci_hcd 0000:00:1d.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    4.232207] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    4.232210] ehci_hcd 0000:00:1d.7: supports USB remote wakeup
[    4.232360] ehci_hcd 0000:00:1d.7: irq 19, io mem 0xf2827000
[    4.232413] ehci_hcd 0000:00:1d.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    4.236297] ehci_hcd 0000:00:1d.7: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
[    4.248029] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    4.248418] usb usb8: default language 0x0409
[    4.248573] usb usb8: udev 1, busnum 8, minor = 896
[    4.248577] usb usb8: New USB device found, idVendor=1d6b, idProduct=0002
[    4.248630] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.248693] usb usb8: Product: EHCI Host Controller
[    4.248742] usb usb8: Manufacturer: Linux 2.6.38-rc8+ ehci_hcd
[    4.248792] usb usb8: SerialNumber: 0000:00:1d.7
[    4.249585] usb usb8: usb_probe_device
[    4.249589] usb usb8: configuration #1 chosen from 1 choice
[    4.249664] usb usb8: adding 8-0:1.0 (config #1, interface 0)
[    4.250359] hub 8-0:1.0: usb_probe_interface
[    4.250362] hub 8-0:1.0: usb_probe_interface - got id
[    4.250367] hub 8-0:1.0: USB hub found
[    4.250526] hub 8-0:1.0: 6 ports detected
[    4.250588] hub 8-0:1.0: standalone hub
[    4.250591] hub 8-0:1.0: no power switching (usb 1.0)
[    4.250593] hub 8-0:1.0: individual port over-current protection
[    4.250596] hub 8-0:1.0: power on to power good time: 20ms
[    4.250689] hub 8-0:1.0: local power source is good
[    4.250706] hub 8-0:1.0: trying to enable port power on non-switchable hub
[    4.251331] ehci_hcd 0000:00:1a.7: GetStatus port:1 status 001403 0  ACK POWER sig=k CSC CONNECT
[    4.251343] hub 4-0:1.0: port 1: status 0501 change 0001
[    4.251415] ehci_hcd 0000:00:1a.7: GetStatus port:3 status 001803 0  ACK POWER sig=j CSC CONNECT
[    4.251426] hub 4-0:1.0: port 3: status 0501 change 0001
[    4.251473] ehci_hcd 0000:00:1a.7: GetStatus port:4 status 001803 0  ACK POWER sig=j CSC CONNECT
[    4.251484] hub 4-0:1.0: port 4: status 0501 change 0001
[    4.252732] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.0
[    4.252747] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.1
[    4.252763] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.2
[    4.259622] Monitor-Mwait will be used to enter C-3 state
[    4.260265] uhci_hcd 0000:00:1d.0: port 1 portsc 0082,00
[    4.260455] hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    4.284190] hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    4.284310] hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    4.308199] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    4.348136] ehci_hcd 0000:00:1d.7: GetStatus port:1 status 001403 0  ACK POWER sig=k CSC CONNECT
[    4.348150] hub 8-0:1.0: port 1: status 0501 change 0001
[    4.348347] hub 4-0:1.0: state 7 ports 6 chg 001a evt 0000
[    4.348377] hub 4-0:1.0: port 1, status 0501, change 0000, 480 Mb/s
[    4.348452] ehci_hcd 0000:00:1a.7: port 1 low speed --> companion
[    4.404123] ehci_hcd 0000:00:1a.7: GetStatus port:1 status 003002 0  ACK POWER OWNER sig=se0 CSC
[    4.404234] hub 4-0:1.0: port 3, status 0501, change 0000, 480 Mb/s
[    4.460247] ehci_hcd 0000:00:1a.7: port 3 full speed --> companion
[    4.460252] ehci_hcd 0000:00:1a.7: GetStatus port:3 status 003801 0  ACK POWER OWNER sig=j CONNECT
[    4.460262] hub 4-0:1.0: port 3 not reset yet, waiting 50ms
[    4.516120] ehci_hcd 0000:00:1a.7: GetStatus port:3 status 003002 0  ACK POWER OWNER sig=se0 CSC
[    4.516238] hub 4-0:1.0: port 4, status 0501, change 0000, 480 Mb/s
[    4.572374] ehci_hcd 0000:00:1a.7: port 4 full speed --> companion
[    4.572379] ehci_hcd 0000:00:1a.7: GetStatus port:4 status 003801 0  ACK POWER OWNER sig=j CONNECT
[    4.572388] hub 4-0:1.0: port 4 not reset yet, waiting 50ms
[    4.628118] ehci_hcd 0000:00:1a.7: GetStatus port:4 status 003002 0  ACK POWER OWNER sig=se0 CSC
[    4.628213] hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
[    4.628246] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    4.628253] hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0002
[    4.628277] uhci_hcd 0000:00:1a.0: port 1 portsc 01a3,00
[    4.628315] hub 1-0:1.0: port 1, status 0301, change 0001, 1.5 Mb/s
[    4.756115] hub 1-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x301
[    4.868113] usb 1-1: new low speed USB device using uhci_hcd and address 2
[    5.022641] usb 1-1: skipped 1 descriptor after interface
[    5.027633] usb 1-1: default language 0x0409
[    5.043645] usb 1-1: udev 2, busnum 1, minor = 1
[    5.043649] usb 1-1: New USB device found, idVendor=046d, idProduct=c018
[    5.043702] usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    5.043755] usb 1-1: Product: USB Optical Mouse
[    5.043803] usb 1-1: Manufacturer: Logitech
[    5.044493] usb 1-1: usb_probe_device
[    5.044497] usb 1-1: configuration #1 chosen from 1 choice
[    5.046642] usb 1-1: adding 1-1:1.0 (config #1, interface 0)
[    5.048229] hub 8-0:1.0: state 7 ports 6 chg 0002 evt 0000
[    5.048259] hub 8-0:1.0: port 1, status 0501, change 0000, 480 Mb/s
[    5.048298] ehci_hcd 0000:00:1d.7: port 1 low speed --> companion
[    5.058967] usbhid 1-1:1.0: usb_probe_interface
[    5.058972] usbhid 1-1:1.0: usb_probe_interface - got id
[    5.072743] input: Logitech USB Optical Mouse as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1:1.0/input/input5
[    5.074357] generic-usb 0003:046D:C018.0001: input,hidraw0: USB HID v1.11 Mouse [Logitech USB Optical Mouse] on usb-0000:00:1a.0-1/input0
[    5.074549] usbcore: registered new interface driver usbhid
[    5.074609] usbhid: USB HID core driver
[    5.104116] ehci_hcd 0000:00:1d.7: GetStatus port:1 status 003002 0  ACK POWER OWNER sig=se0 CSC
[    5.104222] hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0006
[    5.104246] uhci_hcd 0000:00:1a.1: port 1 portsc 0093,00
[    5.104276] hub 2-0:1.0: port 1, status 0101, change 0001, 12 Mb/s
[    5.116072] usb usb3: suspend_rh (auto-stop)
[    5.232123] hub 2-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x101
[    5.344124] usb 2-1: new full speed USB device using uhci_hcd and address 2
[    5.360066] usb usb6: suspend_rh (auto-stop)
[    5.360097] usb usb7: suspend_rh (auto-stop)
[    5.476064] usb 2-1: ep0 maxpacket = 8
[    5.502569] usb 2-1: default language 0x0409
[    5.511581] usb 2-1: udev 2, busnum 2, minor = 129
[    5.511584] usb 2-1: New USB device found, idVendor=08ff, idProduct=2810
[    5.511637] usb 2-1: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[    5.511690] usb 2-1: Product: Fingerprint Sensor
[    5.512379] usb 2-1: usb_probe_device
[    5.512383] usb 2-1: configuration #1 chosen from 1 choice
[    5.513599] usb 2-1: adding 2-1:1.0 (config #1, interface 0)
[    5.515720] uhci_hcd 0000:00:1a.1: port 2 portsc 0093,00
[    5.515756] hub 2-0:1.0: port 2, status 0101, change 0001, 12 Mb/s
[    5.640116] hub 2-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x101
[    5.752124] usb 2-2: new full speed USB device using uhci_hcd and address 3
[    5.904657] usb 2-2: skipped 1 descriptor after interface
[    5.907570] usb 2-2: default language 0x0409
[    5.918585] usb 2-2: udev 3, busnum 2, minor = 130
[    5.918589] usb 2-2: New USB device found, idVendor=0a5c, idProduct=2145
[    5.918641] usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    5.918694] usb 2-2: Product: ThinkPad Bluetooth with Enhanced Data Rate II
[    5.918752] usb 2-2: Manufacturer: Lenovo Computer Corp
[    5.919383] usb 2-2: usb_probe_device
[    5.919386] usb 2-2: configuration #1 chosen from 1 choice
[    5.920636] usb 2-2: adding 2-2:1.0 (config #1, interface 0)
[    5.922276] usb 2-2: adding 2-2:1.1 (config #1, interface 1)
[    5.923380] usb 2-2: adding 2-2:1.2 (config #1, interface 2)
[    5.924631] usb 2-2: adding 2-2:1.3 (config #1, interface 3)
[    5.925780] hub 8-0:1.0: state 7 ports 6 chg 0000 evt 0002
[    5.925823] hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0002
[    5.925857] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0002
[    5.925882] uhci_hcd 0000:00:1d.0: port 1 portsc 01a3,00
[    5.925918] hub 5-0:1.0: port 1, status 0301, change 0001, 1.5 Mb/s
[    6.052124] hub 5-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x301
[    6.164116] usb 5-1: new low speed USB device using uhci_hcd and address 2
[    6.321637] usb 5-1: skipped 1 descriptor after interface
[    6.321650] usb 5-1: skipped 1 descriptor after interface
[    6.326604] usb 5-1: default language 0x0409
[    6.343615] usb 5-1: udev 2, busnum 5, minor = 513
[    6.343618] usb 5-1: New USB device found, idVendor=046d, idProduct=c30a
[    6.343671] usb 5-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    6.343729] usb 5-1: Product: Logitech USB Keyboard
[    6.343777] usb 5-1: Manufacturer: Logitech
[    6.344594] usb 5-1: usb_probe_device
[    6.344598] usb 5-1: configuration #1 chosen from 1 choice
[    6.347638] usb 5-1: adding 5-1:1.0 (config #1, interface 0)
[    6.348082] usbhid 5-1:1.0: usb_probe_interface
[    6.348085] usbhid 5-1:1.0: usb_probe_interface - got id
[    6.349023] usb 5-1: adding 5-1:1.1 (config #1, interface 1)
[    6.349418] usbhid 5-1:1.1: usb_probe_interface
[    6.349421] usbhid 5-1:1.1: usb_probe_interface - got id
[    6.392727] input: Logitech Logitech USB Keyboard as /devices/pci0000:00/0000:00:1d.0/usb5/5-1/5-1:1.0/input/input6
[    6.392853] uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 8, phase 4, 118 us
[    6.393891] logitech 0003:046D:C30A.0002: input,hidraw1: USB HID v1.10 Keyboard [Logitech Logitech USB Keyboard] on usb-0000:00:1d.0-1/input0
[    6.432374] input: Logitech Logitech USB Keyboard as /devices/pci0000:00/0000:00:1d.0/usb5/5-1/5-1:1.1/input/input7
[    6.432475] uhci_hcd 0000:00:1d.0: reserve dev 2 ep82-INT, period 32, phase 16, 118 us
[    6.433960] logitech 0003:046D:C30A.0003: input,hidraw2: USB HID v1.10 Mouse [Logitech Logitech USB Keyboard] on usb-0000:00:1d.0-1/input1
[    6.808115] hub 6-0:1.0: hub_suspend
[    6.808157] usb usb6: bus auto-suspend
[    6.808161] usb usb6: suspend_rh
[    6.808182] hub 4-0:1.0: hub_suspend
[    6.808189] usb usb4: bus auto-suspend
[    6.808192] ehci_hcd 0000:00:1a.7: suspend root hub
[    6.824074] hub 3-0:1.0: hub_suspend
[    6.824082] usb usb3: bus auto-suspend
[    6.824086] usb usb3: suspend_rh
[    6.824107] hub 7-0:1.0: hub_suspend
[    6.824112] usb usb7: bus auto-suspend
[    6.824115] usb usb7: suspend_rh
[    7.924087] hub 8-0:1.0: hub_suspend
[    7.924094] usb usb8: bus auto-suspend
[    7.924097] ehci_hcd 0000:00:1d.7: suspend root hub
[    8.908437] EXT3-fs: barriers not enabled
[    8.908960] kjournald starting.  Commit interval 5 seconds
[    8.909131] EXT3-fs (sda1): mounted filesystem with writeback data mode
[   14.075622] Adding 1871568k swap on /dev/sda2.  Priority:-1 extents:1 across:1871568k SS
[   14.102604] EXT3-fs (sda1): using internal journal
[   14.149156] udev[2723]: starting version 163
[   14.651503] agpgart-intel 0000:00:00.0: Intel GM45 Chipset
[   14.651884] agpgart-intel 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
[   14.654895] agpgart-intel 0000:00:00.0: detected 32768K stolen memory
[   14.760274] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[   15.008948] cfg80211: Calling CRDA to update world regulatory domain
[   15.242375] sshd (2882): /proc/2882/oom_adj is deprecated, please use /proc/2882/oom_score_adj instead.
[   15.309036] cfg80211: World regulatory domain updated:
[   15.309041] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   15.309045] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   15.309048] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   15.309052] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   15.309055] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   15.309058] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   15.456925] [drm] Initialized drm 1.1.0 20060810
[   15.689635] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[   15.702272] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:
[   15.702276] iwlagn: Copyright(c) 2003-2010 Intel Corporation
[   15.702471] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   15.702482] iwlagn 0000:03:00.0: setting latency timer to 64
[   15.702567] iwlagn 0000:03:00.0: Detected Intel(R) WiFi Link 5100 AGN, REV=0x54
[   15.733604] i915 0000:00:02.0: power state changed by ACPI to D0
[   15.733626] i915 0000:00:02.0: power state changed by ACPI to D0
[   15.733636] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   15.733642] i915 0000:00:02.0: setting latency timer to 64
[   15.740117] iwlagn 0000:03:00.0: device EEPROM VER=0x11f, CALIB=0x4
[   15.740122] iwlagn 0000:03:00.0: Device SKU: 0Xb
[   15.740168] iwlagn 0000:03:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
[   15.740295] iwlagn 0000:03:00.0: irq 45 for MSI/MSI-X
[   15.744114] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[   15.744864] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   15.773178] iwlagn 0000:03:00.0: request for firmware file 'iwlwifi-5000-5.ucode' failed.
[   15.791590] iwlagn 0000:03:00.0: request for firmware file 'iwlwifi-5000-4.ucode' failed.
[   15.812705] iwlagn 0000:03:00.0: request for firmware file 'iwlwifi-5000-3.ucode' failed.
[   15.838060] iwlagn 0000:03:00.0: Firmware has old API version. Expected v5, got v2. New firmware can be obtained from http://www.intellinuxwireless.org.
[   15.838137] iwlagn 0000:03:00.0: loaded firmware version 8.24.2.12
[   15.905941] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
[   16.075986] i915 0000:00:02.0: irq 46 for MSI/MSI-X
[   16.076238] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[   16.076241] [drm] Driver supports precise vblank timestamp query.
[   16.204946] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   16.362529] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[   16.727890] fb0: inteldrmfb frame buffer device
[   16.727894] drm: registered panic notifier
[   16.863383] acpi device:02: registered as cooling_device2
[   16.868713] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input8
[   16.869595] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[   16.871316] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[   16.871459] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[   16.871604] HDA Intel 0000:00:1b.0: irq 47 for MSI/MSI-X
[   16.871787] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   16.944753] Console: switching to colour frame buffer device 180x56
[   17.420952] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Control: None
[   17.420958] e1000e 0000:00:19.0: eth0: 10/100 speed: disabling TSO
[   17.421467] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   17.880125] uhci_hcd 0000:00:1a.0: reserve dev 2 ep81-INT, period 8, phase 4, 99 us
[   27.824085] eth0: no IPv6 routers present
[   39.289093] wlan0: authenticate with ac:a0:16:ba:ff:52 (try 1)
[   39.290441] wlan0: authenticated
[   39.296538] wlan0: waiting for beacon from ac:a0:16:ba:ff:52
[   39.393884] wlan0: beacon received
[   39.400083] wlan0: associate with ac:a0:16:ba:ff:52 (try 1)
[   39.403314] wlan0: RX AssocResp from ac:a0:16:ba:ff:52 (capab=0x421 status=0 aid=4)
[   39.403319] wlan0: associated
[   39.409423] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   39.409772] cfg80211: Calling CRDA for country: US
[   39.438631] cfg80211: Regulatory domain changed to country: US
[   39.438634] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   39.438639] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
[   39.438642] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
[   39.438646] cfg80211:     (5250000 KHz - 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   39.438649] cfg80211:     (5490000 KHz - 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   39.438652] cfg80211:     (5650000 KHz - 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   39.438656] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
[   49.712049] wlan0: no IPv6 routers present
[   61.063648] pciehp 0000:00:1c.3:pcie04: Card present on Slot(3)
[   61.184141] pci 0000:05:00.0: [1033:0194] type 0 class 0x000c03
[   61.184182] pci 0000:05:00.0: reg 10: [mem 0x00000000-0x00001fff 64bit]
[   61.184359] pci 0000:05:00.0: PME# supported from D0 D3hot
[   61.184369] pci 0000:05:00.0: PME# disabled
[   61.184457] pci 0000:05:00.0: BAR 0: assigned [mem 0xf0000000-0xf0001fff 64bit]
[   61.184471] pci 0000:05:00.0: BAR 0: set to [mem 0xf0000000-0xf0001fff 64bit] (PCI address [0xf0000000-0xf0001fff])
[   61.184478] pcieport 0000:00:1c.3: PCI bridge to [bus 05-0c]
[   61.184482] pcieport 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[   61.184490] pcieport 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf1ffffff]
[   61.184496] pcieport 0000:00:1c.3:   bridge window [mem 0xf2900000-0xf29fffff 64bit pref]
[   61.184515] pcieport 0000:00:1c.3: setting latency timer to 64
[   61.184610] pci 0000:05:00.0: no hotplug settings from platform
[   61.204928] xhci_hcd 0000:05:00.0: enabling device (0000 -> 0002)
[   61.204941] xhci_hcd 0000:05:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[   61.205043] xhci_hcd 0000:05:00.0: setting latency timer to 64
[   61.205049] xhci_hcd 0000:05:00.0: xHCI Host Controller
[   61.205112] xhci_hcd 0000:05:00.0: new USB bus registered, assigned bus number 9
[   61.220270] xhci_hcd 0000:05:00.0: xHCI capability registers at ffffc9000029c000:
[   61.220276] xhci_hcd 0000:05:00.0: CAPLENGTH AND HCIVERSION 0x960020:
[   61.220279] xhci_hcd 0000:05:00.0: CAPLENGTH: 0x20
[   61.220282] xhci_hcd 0000:05:00.0: HCIVERSION: 0x96
[   61.220286] xhci_hcd 0000:05:00.0: HCSPARAMS 1: 0x4000820
[   61.220289] xhci_hcd 0000:05:00.0:   Max device slots: 32
[   61.220292] xhci_hcd 0000:05:00.0:   Max interrupters: 8
[   61.220294] xhci_hcd 0000:05:00.0:   Max ports: 4
[   61.220299] xhci_hcd 0000:05:00.0: HCSPARAMS 2: 0x11
[   61.220301] xhci_hcd 0000:05:00.0:   Isoc scheduling threshold: 1
[   61.220304] xhci_hcd 0000:05:00.0:   Maximum allowed segments in event ring: 1
[   61.220309] xhci_hcd 0000:05:00.0: HCSPARAMS 3 0x0:
[   61.220312] xhci_hcd 0000:05:00.0:   Worst case U1 device exit latency: 0
[   61.220314] xhci_hcd 0000:05:00.0:   Worst case U2 device exit latency: 0
[   61.220325] xhci_hcd 0000:05:00.0: HCC PARAMS 0x14042cb:
[   61.220327] xhci_hcd 0000:05:00.0:   HC generates 64 bit addresses
[   61.220335] xhci_hcd 0000:05:00.0:   FIXME: more HCCPARAMS debugging
[   61.220340] xhci_hcd 0000:05:00.0: RTSOFF 0x600:
[   61.220343] xhci_hcd 0000:05:00.0: xHCI operational registers at ffffc9000029c020:
[   61.220347] xhci_hcd 0000:05:00.0: USBCMD 0x0:
[   61.220350] xhci_hcd 0000:05:00.0:   HC is being stopped
[   61.220352] xhci_hcd 0000:05:00.0:   HC has finished hard reset
[   61.220355] xhci_hcd 0000:05:00.0:   Event Interrupts disabled
[   61.220358] xhci_hcd 0000:05:00.0:   Host System Error Interrupts disabled
[   61.220360] xhci_hcd 0000:05:00.0:   HC has finished light reset
[   61.220365] xhci_hcd 0000:05:00.0: USBSTS 0x1:
[   61.220368] xhci_hcd 0000:05:00.0:   Event ring is empty
[   61.220370] xhci_hcd 0000:05:00.0:   No Host System Error
[   61.220373] xhci_hcd 0000:05:00.0:   HC is halted
[   61.220378] xhci_hcd 0000:05:00.0: ffffc9000029c420 port status reg = 0x2a0
[   61.220383] xhci_hcd 0000:05:00.0: ffffc9000029c424 port power reg = 0x0
[   61.220388] xhci_hcd 0000:05:00.0: ffffc9000029c428 port link reg = 0x0
[   61.220393] xhci_hcd 0000:05:00.0: ffffc9000029c42c port reserved reg = 0x0
[   61.220399] xhci_hcd 0000:05:00.0: ffffc9000029c430 port status reg = 0x2a0
[   61.220404] xhci_hcd 0000:05:00.0: ffffc9000029c434 port power reg = 0x0
[   61.220409] xhci_hcd 0000:05:00.0: ffffc9000029c438 port link reg = 0x0
[   61.220414] xhci_hcd 0000:05:00.0: ffffc9000029c43c port reserved reg = 0x0
[   61.220419] xhci_hcd 0000:05:00.0: ffffc9000029c440 port status reg = 0x2a0
[   61.220424] xhci_hcd 0000:05:00.0: ffffc9000029c444 port power reg = 0x0
[   61.220429] xhci_hcd 0000:05:00.0: ffffc9000029c448 port link reg = 0x0
[   61.220435] xhci_hcd 0000:05:00.0: ffffc9000029c44c port reserved reg = 0x0
[   61.220440] xhci_hcd 0000:05:00.0: ffffc9000029c450 port status reg = 0x2a0
[   61.220445] xhci_hcd 0000:05:00.0: ffffc9000029c454 port power reg = 0x0
[   61.220450] xhci_hcd 0000:05:00.0: ffffc9000029c458 port link reg = 0x0
[   61.220455] xhci_hcd 0000:05:00.0: ffffc9000029c45c port reserved reg = 0x0
[   61.220458] xhci_hcd 0000:05:00.0: // Halt the HC
[   61.220465] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc9000029c020, 32'h0, 4'hf);
[   61.220470] xhci_hcd 0000:05:00.0: Resetting HCD
[   61.220474] xhci_hcd 0000:05:00.0: // Reset the HC
[   61.220479] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc9000029c020, 32'h2, 4'hf);
[   61.220526] xhci_hcd 0000:05:00.0: Wait for controller to be ready for doorbell rings
[   61.220531] xhci_hcd 0000:05:00.0: Reset complete
[   61.220536] xhci_hcd 0000:05:00.0: Enabling 64-bit DMA addresses.
[   61.220538] xhci_hcd 0000:05:00.0: Calling HCD init
[   61.220541] xhci_hcd 0000:05:00.0: xhci_init
[   61.220543] xhci_hcd 0000:05:00.0: xHCI doesn't need link TRB QUIRK
[   61.220548] xhci_hcd 0000:05:00.0: Supported page size register = 0x1
[   61.220551] xhci_hcd 0000:05:00.0: Supported page size of 4K
[   61.220554] xhci_hcd 0000:05:00.0: HCD page size set to 4K
[   61.220558] xhci_hcd 0000:05:00.0: // xHC can handle at most 32 device slots.
[   61.220563] xhci_hcd 0000:05:00.0: // Setting Max device slots reg = 0x20.
[   61.220566] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc9000029c058, 32'h20, 4'hf);
[   61.220585] xhci_hcd 0000:05:00.0: // Device context base array address = 0x3780c000 (DMA), ffff88003780c000 (virt)
[   61.220588] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 64'hffffc9000029c050, 64'h3780c000, 4'hf);
[   61.220657] xhci_hcd 0000:05:00.0: Allocating ring at ffff88012bd0f2a0
[   61.220673] xhci_hcd 0000:05:00.0: Allocating priv segment structure at ffff880131b8e240
[   61.220706] xhci_hcd 0000:05:00.0: // Allocating segment at ffff88003780d000 (virtual) 0x3780d000 (DMA)
[   61.220712] xhci_hcd 0000:05:00.0: Linking segment 0x3780d000 to segment 0x3780d000 (DMA)
[   61.220715] xhci_hcd 0000:05:00.0: Wrote link toggle flag to segment ffff880131b8e240 (virtual), 0x3780d000 (DMA)
[   61.220718] xhci_hcd 0000:05:00.0: Allocated command ring at ffff88012bd0f2a0
[   61.220721] xhci_hcd 0000:05:00.0: First segment DMA is 0x3780d000
[   61.220728] xhci_hcd 0000:05:00.0: // Setting command ring address to 0x20
[   61.220731] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 64'hffffc9000029c038, 64'h3780d001, 4'hf);
[   61.220739] xhci_hcd 0000:05:00.0: // xHC command ring deq ptr low bits + flags = @00000000
[   61.220741] xhci_hcd 0000:05:00.0: // xHC command ring deq ptr high bits = @00000000
[   61.220746] xhci_hcd 0000:05:00.0: // Doorbell array is located at offset 0x800 from cap regs base addr
[   61.220750] xhci_hcd 0000:05:00.0: // xHCI capability registers at ffffc9000029c000:
[   61.220755] xhci_hcd 0000:05:00.0: // @ffffc9000029c000 = 0x960020 (CAPLENGTH AND HCIVERSION)
[   61.220758] xhci_hcd 0000:05:00.0: //   CAPLENGTH: 0x20
[   61.220760] xhci_hcd 0000:05:00.0: // xHCI operational registers at ffffc9000029c020:
[   61.220765] xhci_hcd 0000:05:00.0: // @ffffc9000029c018 = 0x600 RTSOFF
[   61.220768] xhci_hcd 0000:05:00.0: // xHCI runtime registers at ffffc9000029c600:
[   61.220773] xhci_hcd 0000:05:00.0: // @ffffc9000029c014 = 0x800 DBOFF
[   61.220776] xhci_hcd 0000:05:00.0: // Doorbell array at ffffc9000029c800:
[   61.220779] xhci_hcd 0000:05:00.0: xHCI runtime registers at ffffc9000029c600:
[   61.220784] xhci_hcd 0000:05:00.0:   ffffc9000029c600: Microframe index = 0x0
[   61.220799] xhci_hcd 0000:05:00.0: // Allocating event ring
[   61.220814] xhci_hcd 0000:05:00.0: Allocating ring at ffff88012bd0f360
[   61.220830] xhci_hcd 0000:05:00.0: Allocating priv segment structure at ffff880131b8eb20
[   61.220834] xhci_hcd 0000:05:00.0: // Allocating segment at ffff88003780d400 (virtual) 0x3780d400 (DMA)
[   61.220838] xhci_hcd 0000:05:00.0: Linking segment 0x3780d400 to segment 0x3780d400 (DMA)
[   61.220842] xhci_hcd 0000:05:00.0: TRB math tests passed.
[   61.220856] xhci_hcd 0000:05:00.0: // Allocated event ring segment table at 0x3780e000
[   61.220860] xhci_hcd 0000:05:00.0: Set ERST to 0; private num segs = 1, virt addr = ffff88003780e000, dma addr = 0x3780e000
[   61.220865] xhci_hcd 0000:05:00.0: // Write ERST size = 1 to ir_set 0 (some bits preserved)
[   61.220869] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc9000029c628, 32'h1, 4'hf);
[   61.220872] xhci_hcd 0000:05:00.0: // Set ERST entries to point to event ring.
[   61.220874] xhci_hcd 0000:05:00.0: // Set ERST base address for ir_set 0 = 0x3780e000
[   61.220882] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 64'hffffc9000029c630, 64'h3780e000, 4'hf);
[   61.220889] xhci_hcd 0000:05:00.0: // Write event ring dequeue pointer, preserving EHB bit
[   61.220892] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 64'hffffc9000029c638, 64'h3780d400, 4'hf);
[   61.220895] xhci_hcd 0000:05:00.0: Wrote ERST address to ir_set 0.
[   61.220901] xhci_hcd 0000:05:00.0: Allocating 0 scratchpad buffers
[   61.220924] xhci_hcd 0000:05:00.0: Ext Cap ffffc9000029c510, port offset = 1, count = 2, revision = 0x3
[   61.220932] xhci_hcd 0000:05:00.0: Ext Cap ffffc9000029c520, port offset = 3, count = 2, revision = 0x2
[   61.220935] xhci_hcd 0000:05:00.0: Found 2 USB 2.0 ports and 2 USB 3.0 ports.
[   61.220950] xhci_hcd 0000:05:00.0: USB 2.0 port at index 2, addr = ffffc9000029c440
[   61.220953] xhci_hcd 0000:05:00.0: USB 2.0 port at index 3, addr = ffffc9000029c450
[   61.220968] xhci_hcd 0000:05:00.0: USB 3.0 port at index 0, addr = ffffc9000029c420
[   61.220972] xhci_hcd 0000:05:00.0: USB 3.0 port at index 1, addr = ffffc9000029c430
[   61.220974] xhci_hcd 0000:05:00.0: Finished xhci_init
[   61.220977] xhci_hcd 0000:05:00.0: Called HCD init
[   61.220982] xhci_hcd 0000:05:00.0: Got SBRN 48
[   61.220999] xhci_hcd 0000:05:00.0: MWI active
[   61.221001] xhci_hcd 0000:05:00.0: Finished xhci_pci_reinit
[   61.221004] xhci_hcd 0000:05:00.0: supports USB remote wakeup
[   61.221060] xhci_hcd 0000:05:00.0: irq 19, io mem 0xf0000000
[   61.221063] xhci_hcd 0000:05:00.0: xhci_run
[   61.221248] xhci_hcd 0000:05:00.0: irq 48 for MSI/MSI-X
[   61.221254] xhci_hcd 0000:05:00.0: irq 49 for MSI/MSI-X
[   61.221260] xhci_hcd 0000:05:00.0: irq 50 for MSI/MSI-X
[   61.221889] xhci_hcd 0000:05:00.0: Setting event ring polling timer
[   61.221893] xhci_hcd 0000:05:00.0: Command ring memory map follows:
[   61.221896] xhci_hcd 0000:05:00.0: @3780d000 00000000 00000000 00000000 00000000
[   61.221899] xhci_hcd 0000:05:00.0: @3780d010 00000000 00000000 00000000 00000000
[   61.221903] xhci_hcd 0000:05:00.0: @3780d020 00000000 00000000 00000000 00000000
[   61.221906] xhci_hcd 0000:05:00.0: @3780d030 00000000 00000000 00000000 00000000
[   61.221909] xhci_hcd 0000:05:00.0: @3780d040 00000000 00000000 00000000 00000000
[   61.221912] xhci_hcd 0000:05:00.0: @3780d050 00000000 00000000 00000000 00000000
[   61.221915] xhci_hcd 0000:05:00.0: @3780d060 00000000 00000000 00000000 00000000
[   61.221919] xhci_hcd 0000:05:00.0: @3780d070 00000000 00000000 00000000 00000000
[   61.221922] xhci_hcd 0000:05:00.0: @3780d080 00000000 00000000 00000000 00000000
[   61.221925] xhci_hcd 0000:05:00.0: @3780d090 00000000 00000000 00000000 00000000
[   61.221928] xhci_hcd 0000:05:00.0: @3780d0a0 00000000 00000000 00000000 00000000
[   61.221931] xhci_hcd 0000:05:00.0: @3780d0b0 00000000 00000000 00000000 00000000
[   61.221935] xhci_hcd 0000:05:00.0: @3780d0c0 00000000 00000000 00000000 00000000
[   61.221938] xhci_hcd 0000:05:00.0: @3780d0d0 00000000 00000000 00000000 00000000
[   61.221941] xhci_hcd 0000:05:00.0: @3780d0e0 00000000 00000000 00000000 00000000
[   61.221944] xhci_hcd 0000:05:00.0: @3780d0f0 00000000 00000000 00000000 00000000
[   61.221947] xhci_hcd 0000:05:00.0: @3780d100 00000000 00000000 00000000 00000000
[   61.221951] xhci_hcd 0000:05:00.0: @3780d110 00000000 00000000 00000000 00000000
[   61.221954] xhci_hcd 0000:05:00.0: @3780d120 00000000 00000000 00000000 00000000
[   61.221957] xhci_hcd 0000:05:00.0: @3780d130 00000000 00000000 00000000 00000000
[   61.221960] xhci_hcd 0000:05:00.0: @3780d140 00000000 00000000 00000000 00000000
[   61.221963] xhci_hcd 0000:05:00.0: @3780d150 00000000 00000000 00000000 00000000
[   61.221966] xhci_hcd 0000:05:00.0: @3780d160 00000000 00000000 00000000 00000000
[   61.221970] xhci_hcd 0000:05:00.0: @3780d170 00000000 00000000 00000000 00000000
[   61.221973] xhci_hcd 0000:05:00.0: @3780d180 00000000 00000000 00000000 00000000
[   61.221976] xhci_hcd 0000:05:00.0: @3780d190 00000000 00000000 00000000 00000000
[   61.221979] xhci_hcd 0000:05:00.0: @3780d1a0 00000000 00000000 00000000 00000000
[   61.221982] xhci_hcd 0000:05:00.0: @3780d1b0 00000000 00000000 00000000 00000000
[   61.221986] xhci_hcd 0000:05:00.0: @3780d1c0 00000000 00000000 00000000 00000000
[   61.221989] xhci_hcd 0000:05:00.0: @3780d1d0 00000000 00000000 00000000 00000000
[   61.221992] xhci_hcd 0000:05:00.0: @3780d1e0 00000000 00000000 00000000 00000000
[   61.221995] xhci_hcd 0000:05:00.0: @3780d1f0 00000000 00000000 00000000 00000000
[   61.221998] xhci_hcd 0000:05:00.0: @3780d200 00000000 00000000 00000000 00000000
[   61.222001] xhci_hcd 0000:05:00.0: @3780d210 00000000 00000000 00000000 00000000
[   61.222005] xhci_hcd 0000:05:00.0: @3780d220 00000000 00000000 00000000 00000000
[   61.222008] xhci_hcd 0000:05:00.0: @3780d230 00000000 00000000 00000000 00000000
[   61.222011] xhci_hcd 0000:05:00.0: @3780d240 00000000 00000000 00000000 00000000
[   61.222014] xhci_hcd 0000:05:00.0: @3780d250 00000000 00000000 00000000 00000000
[   61.222017] xhci_hcd 0000:05:00.0: @3780d260 00000000 00000000 00000000 00000000
[   61.222021] xhci_hcd 0000:05:00.0: @3780d270 00000000 00000000 00000000 00000000
[   61.222024] xhci_hcd 0000:05:00.0: @3780d280 00000000 00000000 00000000 00000000
[   61.222027] xhci_hcd 0000:05:00.0: @3780d290 00000000 00000000 00000000 00000000
[   61.222030] xhci_hcd 0000:05:00.0: @3780d2a0 00000000 00000000 00000000 00000000
[   61.222033] xhci_hcd 0000:05:00.0: @3780d2b0 00000000 00000000 00000000 00000000
[   61.222037] xhci_hcd 0000:05:00.0: @3780d2c0 00000000 00000000 00000000 00000000
[   61.222040] xhci_hcd 0000:05:00.0: @3780d2d0 00000000 00000000 00000000 00000000
[   61.222043] xhci_hcd 0000:05:00.0: @3780d2e0 00000000 00000000 00000000 00000000
[   61.222046] xhci_hcd 0000:05:00.0: @3780d2f0 00000000 00000000 00000000 00000000
[   61.222049] xhci_hcd 0000:05:00.0: @3780d300 00000000 00000000 00000000 00000000
[   61.222053] xhci_hcd 0000:05:00.0: @3780d310 00000000 00000000 00000000 00000000
[   61.222056] xhci_hcd 0000:05:00.0: @3780d320 00000000 00000000 00000000 00000000
[   61.222059] xhci_hcd 0000:05:00.0: @3780d330 00000000 00000000 00000000 00000000
[   61.222062] xhci_hcd 0000:05:00.0: @3780d340 00000000 00000000 00000000 00000000
[   61.222065] xhci_hcd 0000:05:00.0: @3780d350 00000000 00000000 00000000 00000000
[   61.222069] xhci_hcd 0000:05:00.0: @3780d360 00000000 00000000 00000000 00000000
[   61.222072] xhci_hcd 0000:05:00.0: @3780d370 00000000 00000000 00000000 00000000
[   61.222075] xhci_hcd 0000:05:00.0: @3780d380 00000000 00000000 00000000 00000000
[   61.222078] xhci_hcd 0000:05:00.0: @3780d390 00000000 00000000 00000000 00000000
[   61.222081] xhci_hcd 0000:05:00.0: @3780d3a0 00000000 00000000 00000000 00000000
[   61.222085] xhci_hcd 0000:05:00.0: @3780d3b0 00000000 00000000 00000000 00000000
[   61.222088] xhci_hcd 0000:05:00.0: @3780d3c0 00000000 00000000 00000000 00000000
[   61.222091] xhci_hcd 0000:05:00.0: @3780d3d0 00000000 00000000 00000000 00000000
[   61.222094] xhci_hcd 0000:05:00.0: @3780d3e0 00000000 00000000 00000000 00000000
[   61.222097] xhci_hcd 0000:05:00.0: @3780d3f0 3780d000 00000000 00000000 00001802
[   61.222100] xhci_hcd 0000:05:00.0:   Ring has not been updated
[   61.222103] xhci_hcd 0000:05:00.0: Ring deq = ffff88003780d000 (virt), 0x3780d000 (dma)
[   61.222106] xhci_hcd 0000:05:00.0: Ring deq updated 0 times
[   61.222109] xhci_hcd 0000:05:00.0: Ring enq = ffff88003780d000 (virt), 0x3780d000 (dma)
[   61.222112] xhci_hcd 0000:05:00.0: Ring enq updated 0 times
[   61.222118] xhci_hcd 0000:05:00.0: // xHC command ring deq ptr low bits + flags = @00000000
[   61.222121] xhci_hcd 0000:05:00.0: // xHC command ring deq ptr high bits = @00000000
[   61.222124] xhci_hcd 0000:05:00.0: ERST memory map follows:
[   61.222127] xhci_hcd 0000:05:00.0: @3780e000 3780d400 00000000 00000040 00000000
[   61.222130] xhci_hcd 0000:05:00.0: Event ring:
[   61.222133] xhci_hcd 0000:05:00.0: @3780d400 00000000 00000000 00000000 00000000
[   61.222136] xhci_hcd 0000:05:00.0: @3780d410 00000000 00000000 00000000 00000000
[   61.222139] xhci_hcd 0000:05:00.0: @3780d420 00000000 00000000 00000000 00000000
[   61.222143] xhci_hcd 0000:05:00.0: @3780d430 00000000 00000000 00000000 00000000
[   61.222146] xhci_hcd 0000:05:00.0: @3780d440 00000000 00000000 00000000 00000000
[   61.222149] xhci_hcd 0000:05:00.0: @3780d450 00000000 00000000 00000000 00000000
[   61.222152] xhci_hcd 0000:05:00.0: @3780d460 00000000 00000000 00000000 00000000
[   61.222155] xhci_hcd 0000:05:00.0: @3780d470 00000000 00000000 00000000 00000000
[   61.222159] xhci_hcd 0000:05:00.0: @3780d480 00000000 00000000 00000000 00000000
[   61.222162] xhci_hcd 0000:05:00.0: @3780d490 00000000 00000000 00000000 00000000
[   61.222165] xhci_hcd 0000:05:00.0: @3780d4a0 00000000 00000000 00000000 00000000
[   61.222168] xhci_hcd 0000:05:00.0: @3780d4b0 00000000 00000000 00000000 00000000
[   61.222171] xhci_hcd 0000:05:00.0: @3780d4c0 00000000 00000000 00000000 00000000
[   61.222175] xhci_hcd 0000:05:00.0: @3780d4d0 00000000 00000000 00000000 00000000
[   61.222178] xhci_hcd 0000:05:00.0: @3780d4e0 00000000 00000000 00000000 00000000
[   61.222181] xhci_hcd 0000:05:00.0: @3780d4f0 00000000 00000000 00000000 00000000
[   61.222184] xhci_hcd 0000:05:00.0: @3780d500 00000000 00000000 00000000 00000000
[   61.222188] xhci_hcd 0000:05:00.0: @3780d510 00000000 00000000 00000000 00000000
[   61.222191] xhci_hcd 0000:05:00.0: @3780d520 00000000 00000000 00000000 00000000
[   61.222194] xhci_hcd 0000:05:00.0: @3780d530 00000000 00000000 00000000 00000000
[   61.222197] xhci_hcd 0000:05:00.0: @3780d540 00000000 00000000 00000000 00000000
[   61.222201] xhci_hcd 0000:05:00.0: @3780d550 00000000 00000000 00000000 00000000
[   61.222204] xhci_hcd 0000:05:00.0: @3780d560 00000000 00000000 00000000 00000000
[   61.222207] xhci_hcd 0000:05:00.0: @3780d570 00000000 00000000 00000000 00000000
[   61.222210] xhci_hcd 0000:05:00.0: @3780d580 00000000 00000000 00000000 00000000
[   61.222213] xhci_hcd 0000:05:00.0: @3780d590 00000000 00000000 00000000 00000000
[   61.222216] xhci_hcd 0000:05:00.0: @3780d5a0 00000000 00000000 00000000 00000000
[   61.222220] xhci_hcd 0000:05:00.0: @3780d5b0 00000000 00000000 00000000 00000000
[   61.222223] xhci_hcd 0000:05:00.0: @3780d5c0 00000000 00000000 00000000 00000000
[   61.222226] xhci_hcd 0000:05:00.0: @3780d5d0 00000000 00000000 00000000 00000000
[   61.222229] xhci_hcd 0000:05:00.0: @3780d5e0 00000000 00000000 00000000 00000000
[   61.222232] xhci_hcd 0000:05:00.0: @3780d5f0 00000000 00000000 00000000 00000000
[   61.222236] xhci_hcd 0000:05:00.0: @3780d600 00000000 00000000 00000000 00000000
[   61.222239] xhci_hcd 0000:05:00.0: @3780d610 00000000 00000000 00000000 00000000
[   61.222242] xhci_hcd 0000:05:00.0: @3780d620 00000000 00000000 00000000 00000000
[   61.222245] xhci_hcd 0000:05:00.0: @3780d630 00000000 00000000 00000000 00000000
[   61.222248] xhci_hcd 0000:05:00.0: @3780d640 00000000 00000000 00000000 00000000
[   61.222251] xhci_hcd 0000:05:00.0: @3780d650 00000000 00000000 00000000 00000000
[   61.222254] xhci_hcd 0000:05:00.0: @3780d660 00000000 00000000 00000000 00000000
[   61.222258] xhci_hcd 0000:05:00.0: @3780d670 00000000 00000000 00000000 00000000
[   61.222261] xhci_hcd 0000:05:00.0: @3780d680 00000000 00000000 00000000 00000000
[   61.222264] xhci_hcd 0000:05:00.0: @3780d690 00000000 00000000 00000000 00000000
[   61.222267] xhci_hcd 0000:05:00.0: @3780d6a0 00000000 00000000 00000000 00000000
[   61.222270] xhci_hcd 0000:05:00.0: @3780d6b0 00000000 00000000 00000000 00000000
[   61.222274] xhci_hcd 0000:05:00.0: @3780d6c0 00000000 00000000 00000000 00000000
[   61.222277] xhci_hcd 0000:05:00.0: @3780d6d0 00000000 00000000 00000000 00000000
[   61.222280] xhci_hcd 0000:05:00.0: @3780d6e0 00000000 00000000 00000000 00000000
[   61.222283] xhci_hcd 0000:05:00.0: @3780d6f0 00000000 00000000 00000000 00000000
[   61.222286] xhci_hcd 0000:05:00.0: @3780d700 00000000 00000000 00000000 00000000
[   61.222290] xhci_hcd 0000:05:00.0: @3780d710 00000000 00000000 00000000 00000000
[   61.222293] xhci_hcd 0000:05:00.0: @3780d720 00000000 00000000 00000000 00000000
[   61.222296] xhci_hcd 0000:05:00.0: @3780d730 00000000 00000000 00000000 00000000
[   61.222299] xhci_hcd 0000:05:00.0: @3780d740 00000000 00000000 00000000 00000000
[   61.222302] xhci_hcd 0000:05:00.0: @3780d750 00000000 00000000 00000000 00000000
[   61.222305] xhci_hcd 0000:05:00.0: @3780d760 00000000 00000000 00000000 00000000
[   61.222309] xhci_hcd 0000:05:00.0: @3780d770 00000000 00000000 00000000 00000000
[   61.222312] xhci_hcd 0000:05:00.0: @3780d780 00000000 00000000 00000000 00000000
[   61.222315] xhci_hcd 0000:05:00.0: @3780d790 00000000 00000000 00000000 00000000
[   61.222318] xhci_hcd 0000:05:00.0: @3780d7a0 00000000 00000000 00000000 00000000
[   61.222321] xhci_hcd 0000:05:00.0: @3780d7b0 00000000 00000000 00000000 00000000
[   61.222325] xhci_hcd 0000:05:00.0: @3780d7c0 00000000 00000000 00000000 00000000
[   61.222328] xhci_hcd 0000:05:00.0: @3780d7d0 00000000 00000000 00000000 00000000
[   61.222331] xhci_hcd 0000:05:00.0: @3780d7e0 00000000 00000000 00000000 00000000
[   61.222334] xhci_hcd 0000:05:00.0: @3780d7f0 00000000 00000000 00000000 00000000
[   61.222337] xhci_hcd 0000:05:00.0:   Ring has not been updated
[   61.222340] xhci_hcd 0000:05:00.0: Ring deq = ffff88003780d400 (virt), 0x3780d400 (dma)
[   61.222343] xhci_hcd 0000:05:00.0: Ring deq updated 0 times
[   61.222346] xhci_hcd 0000:05:00.0: Ring enq = ffff88003780d400 (virt), 0x3780d400 (dma)
[   61.222349] xhci_hcd 0000:05:00.0: Ring enq updated 0 times
[   61.222356] xhci_hcd 0000:05:00.0: ERST deq = 64'h3780d400
[   61.222358] xhci_hcd 0000:05:00.0: // Set the interrupt modulation register
[   61.222364] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc9000029c624, 32'ha0, 4'hf);
[   61.222369] xhci_hcd 0000:05:00.0: // Enable interrupts, cmd = 0x4.
[   61.222372] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc9000029c020, 32'h4, 4'hf);
[   61.222378] xhci_hcd 0000:05:00.0: // Enabling event ring interrupter ffffc9000029c620 by writing 0x2 to irq_pending
[   61.222381] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc9000029c620, 32'h2, 4'hf);
[   61.222387] xhci_hcd 0000:05:00.0:   ffffc9000029c620: ir_set[0]
[   61.222390] xhci_hcd 0000:05:00.0:   ffffc9000029c620: ir_set.pending = 0x2
[   61.222395] xhci_hcd 0000:05:00.0:   ffffc9000029c624: ir_set.control = 0xa0
[   61.222400] xhci_hcd 0000:05:00.0:   ffffc9000029c628: ir_set.erst_size = 0x1
[   61.222409] xhci_hcd 0000:05:00.0:   ffffc9000029c630: ir_set.erst_base = @3780e000
[   61.222416] xhci_hcd 0000:05:00.0:   ffffc9000029c638: ir_set.erst_dequeue = @3780d400
[   61.222419] xhci_hcd 0000:05:00.0: Endpoint state = 0x1
[   61.222422] xhci_hcd 0000:05:00.0: Command ring enq = 0x3780d010 (DMA)
[   61.222427] xhci_hcd 0000:05:00.0: // Turn on HC, cmd = 0x5.
[   61.222430] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc9000029c020, 32'h5, 4'hf);
[   61.223926] xhci_hcd 0000:05:00.0: // Ding dong!
[   61.223930] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc9000029c800, 32'h0, 4'hf);
[   61.223935] xhci_hcd 0000:05:00.0: Finished xhci_run
[   61.224083] xhci_hcd 0000:05:00.0: op reg status = 00000008
[   61.224083] xhci_hcd 0000:05:00.0: Event ring dequeue ptr:
[   61.224083] xhci_hcd 0000:05:00.0: @3780d400 3780d000 00000000 01003021 0000c001
[   61.224083] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc9000029c024, 32'h8, 4'hf);
[   61.224083] xhci_hcd 0000:05:00.0: In xhci_handle_event
[   61.224083] xhci_hcd 0000:05:00.0: xhci_handle_event - OS owns TRB
[   61.224083] xhci_hcd 0000:05:00.0: Vendor specific event TRB type = 48
[   61.224083] xhci_hcd 0000:05:00.0: NEC firmware version 30.21
[   61.224083] xhci_hcd 0000:05:00.0: Command ring deq = 0x3780d010 (DMA)
[   61.224083] xhci_hcd 0000:05:00.0: Event ring deq = 0x3780d410 (DMA)
[   61.224083] xhci_hcd 0000:05:00.0: In xhci_handle_event
[   61.224083] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 64'hffffc9000029c638, 64'h3780d418, 4'hf);
[   61.231068] usb usb9: No SuperSpeed endpoint companion for config 1  interface 0 altsetting 0 ep 129: using minimum values
[   61.231145] usb usb9: default language 0x0409
[   61.231381] usb usb9: udev 1, busnum 9, minor = 1024
[   61.231384] usb usb9: New USB device found, idVendor=1d6b, idProduct=0003
[   61.231388] usb usb9: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   61.231391] usb usb9: Product: xHCI Host Controller
[   61.231393] usb usb9: Manufacturer: Linux 2.6.38-rc8+ xhci_hcd
[   61.231396] usb usb9: SerialNumber: 0000:05:00.0
[   61.234965] usb usb9: usb_probe_device
[   61.234970] usb usb9: configuration #1 chosen from 1 choice
[   61.235012] xHCI xhci_add_endpoint called for root hub
[   61.235015] xHCI xhci_check_bandwidth called for root hub
[   61.235090] usb usb9: adding 9-0:1.0 (config #1, interface 0)
[   61.235873] hub 9-0:1.0: usb_probe_interface
[   61.235877] hub 9-0:1.0: usb_probe_interface - got id
[   61.235881] hub 9-0:1.0: USB hub found
[   61.236280] hub 9-0:1.0: 4 ports detected
[   61.236307] hub 9-0:1.0: standalone hub
[   61.236310] hub 9-0:1.0: individual port power switching
[   61.236313] hub 9-0:1.0: individual port over-current protection
[   61.236317] hub 9-0:1.0: TT requires at most 8 FS bit times (666 ns)
[   61.236320] hub 9-0:1.0: power on to power good time: 20ms
[   61.236470] hub 9-0:1.0: local power source is good
[   61.236497] hub 9-0:1.0: enabling power on all ports
[   61.236559] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc9000029c420, 32'h2a0, 4'hf);
[   61.236567] xhci_hcd 0000:05:00.0: set port power, actual port 0 status  = 0x2a0
[   61.236640] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc9000029c430, 32'h2a0, 4'hf);
[   61.236648] xhci_hcd 0000:05:00.0: set port power, actual port 1 status  = 0x2a0
[   61.236719] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc9000029c440, 32'h2a0, 4'hf);
[   61.236726] xhci_hcd 0000:05:00.0: set port power, actual port 2 status  = 0x2a0
[   61.236795] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc9000029c450, 32'h2a0, 4'hf);
[   61.236802] xhci_hcd 0000:05:00.0: set port power, actual port 3 status  = 0x2a0
[   61.336106] xhci_hcd 0000:05:00.0: get port status, actual port 0 status  = 0x2a0
[   61.336111] xhci_hcd 0000:05:00.0: Get port status returned 0x100
[   61.336153] xhci_hcd 0000:05:00.0: get port status, actual port 1 status  = 0x2a0
[   61.336157] xhci_hcd 0000:05:00.0: Get port status returned 0x100
[   61.336194] xhci_hcd 0000:05:00.0: get port status, actual port 2 status  = 0x2a0
[   61.336197] xhci_hcd 0000:05:00.0: Get port status returned 0x100
[   61.336235] xhci_hcd 0000:05:00.0: get port status, actual port 3 status  = 0x2a0
[   61.336238] xhci_hcd 0000:05:00.0: Get port status returned 0x100
[   61.336266] hub 9-0:1.0: state 7 ports 4 chg 0000 evt 0000
[   63.808026] hub 9-0:1.0: hub_suspend
[   63.808039] usb usb9: bus auto-suspend
[   63.808042] xhci_hcd 0000:05:00.0: suspend root hub
[   63.808049] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc9000029c450, 32'ha0002a0, 4'hf);
[   63.808056] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc9000029c440, 32'ha0002a0, 4'hf);
[   63.808064] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc9000029c430, 32'ha0002a0, 4'hf);
[   63.808072] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc9000029c420, 32'ha0002a0, 4'hf);
[   72.295365] wlan0: deauthenticating from ac:a0:16:ba:ff:52 by local choice (reason=3)
[   72.317458] wlan0: authenticate with ac:a0:16:53:96:62 (try 1)
[   72.320267] wlan0: authenticated
[   72.334124] wlan0: waiting for beacon from ac:a0:16:53:96:62
[   80.094099] kmemleak: 2 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
[   84.736771] wlan0: authenticate with 1c:17:d3:cb:d3:12 (try 1)
[   84.739242] wlan0: authenticated
[   84.739325] wlan0: waiting for beacon from 1c:17:d3:cb:d3:12
[   84.752273] wlan0: beacon received
[   84.764091] wlan0: associate with 1c:17:d3:cb:d3:12 (try 1)
[   84.766021] wlan0: RX AssocResp from 1c:17:d3:cb:d3:12 (capab=0x421 status=0 aid=4)
[   84.766024] wlan0: associated
[  121.312127] xhci_hcd 0000:05:00.0: Poll event ring: 4294922624
[  121.312139] xhci_hcd 0000:05:00.0: op reg status = 0x0
[  121.312145] xhci_hcd 0000:05:00.0: ir_set 0 pending = 0x2
[  121.312147] xhci_hcd 0000:05:00.0: No-op commands handled = 0
[  121.312150] xhci_hcd 0000:05:00.0: HC error bitmask = 0x4
[  121.312152] xhci_hcd 0000:05:00.0: Event ring:
[  121.312155] xhci_hcd 0000:05:00.0: @3780d400 3780d000 00000000 01003021 0000c001
[  121.312158] xhci_hcd 0000:05:00.0: @3780d410 00000000 00000000 00000000 00000000
[  121.312161] xhci_hcd 0000:05:00.0: @3780d420 00000000 00000000 00000000 00000000
[  121.312164] xhci_hcd 0000:05:00.0: @3780d430 00000000 00000000 00000000 00000000
[  121.312167] xhci_hcd 0000:05:00.0: @3780d440 00000000 00000000 00000000 00000000
[  121.312170] xhci_hcd 0000:05:00.0: @3780d450 00000000 00000000 00000000 00000000
[  121.312172] xhci_hcd 0000:05:00.0: @3780d460 00000000 00000000 00000000 00000000
[  121.312175] xhci_hcd 0000:05:00.0: @3780d470 00000000 00000000 00000000 00000000
[  121.312178] xhci_hcd 0000:05:00.0: @3780d480 00000000 00000000 00000000 00000000
[  121.312181] xhci_hcd 0000:05:00.0: @3780d490 00000000 00000000 00000000 00000000
[  121.312183] xhci_hcd 0000:05:00.0: @3780d4a0 00000000 00000000 00000000 00000000
[  121.312186] xhci_hcd 0000:05:00.0: @3780d4b0 00000000 00000000 00000000 00000000
[  121.312189] xhci_hcd 0000:05:00.0: @3780d4c0 00000000 00000000 00000000 00000000
[  121.312192] xhci_hcd 0000:05:00.0: @3780d4d0 00000000 00000000 00000000 00000000
[  121.312194] xhci_hcd 0000:05:00.0: @3780d4e0 00000000 00000000 00000000 00000000
[  121.312197] xhci_hcd 0000:05:00.0: @3780d4f0 00000000 00000000 00000000 00000000
[  121.312200] xhci_hcd 0000:05:00.0: @3780d500 00000000 00000000 00000000 00000000
[  121.312203] xhci_hcd 0000:05:00.0: @3780d510 00000000 00000000 00000000 00000000
[  121.312205] xhci_hcd 0000:05:00.0: @3780d520 00000000 00000000 00000000 00000000
[  121.312208] xhci_hcd 0000:05:00.0: @3780d530 00000000 00000000 00000000 00000000
[  121.312211] xhci_hcd 0000:05:00.0: @3780d540 00000000 00000000 00000000 00000000
[  121.312214] xhci_hcd 0000:05:00.0: @3780d550 00000000 00000000 00000000 00000000
[  121.312216] xhci_hcd 0000:05:00.0: @3780d560 00000000 00000000 00000000 00000000
[  121.312219] xhci_hcd 0000:05:00.0: @3780d570 00000000 00000000 00000000 00000000
[  121.312222] xhci_hcd 0000:05:00.0: @3780d580 00000000 00000000 00000000 00000000
[  121.312225] xhci_hcd 0000:05:00.0: @3780d590 00000000 00000000 00000000 00000000
[  121.312227] xhci_hcd 0000:05:00.0: @3780d5a0 00000000 00000000 00000000 00000000
[  121.312230] xhci_hcd 0000:05:00.0: @3780d5b0 00000000 00000000 00000000 00000000
[  121.312233] xhci_hcd 0000:05:00.0: @3780d5c0 00000000 00000000 00000000 00000000
[  121.312235] xhci_hcd 0000:05:00.0: @3780d5d0 00000000 00000000 00000000 00000000
[  121.312238] xhci_hcd 0000:05:00.0: @3780d5e0 00000000 00000000 00000000 00000000
[  121.312241] xhci_hcd 0000:05:00.0: @3780d5f0 00000000 00000000 00000000 00000000
[  121.312244] xhci_hcd 0000:05:00.0: @3780d600 00000000 00000000 00000000 00000000
[  121.312246] xhci_hcd 0000:05:00.0: @3780d610 00000000 00000000 00000000 00000000
[  121.312249] xhci_hcd 0000:05:00.0: @3780d620 00000000 00000000 00000000 00000000
[  121.312252] xhci_hcd 0000:05:00.0: @3780d630 00000000 00000000 00000000 00000000
[  121.312255] xhci_hcd 0000:05:00.0: @3780d640 00000000 00000000 00000000 00000000
[  121.312258] xhci_hcd 0000:05:00.0: @3780d650 00000000 00000000 00000000 00000000
[  121.312260] xhci_hcd 0000:05:00.0: @3780d660 00000000 00000000 00000000 00000000
[  121.312263] xhci_hcd 0000:05:00.0: @3780d670 00000000 00000000 00000000 00000000
[  121.312266] xhci_hcd 0000:05:00.0: @3780d680 00000000 00000000 00000000 00000000
[  121.312269] xhci_hcd 0000:05:00.0: @3780d690 00000000 00000000 00000000 00000000
[  121.312271] xhci_hcd 0000:05:00.0: @3780d6a0 00000000 00000000 00000000 00000000
[  121.312274] xhci_hcd 0000:05:00.0: @3780d6b0 00000000 00000000 00000000 00000000
[  121.312277] xhci_hcd 0000:05:00.0: @3780d6c0 00000000 00000000 00000000 00000000
[  121.312280] xhci_hcd 0000:05:00.0: @3780d6d0 00000000 00000000 00000000 00000000
[  121.312282] xhci_hcd 0000:05:00.0: @3780d6e0 00000000 00000000 00000000 00000000
[  121.312285] xhci_hcd 0000:05:00.0: @3780d6f0 00000000 00000000 00000000 00000000
[  121.312288] xhci_hcd 0000:05:00.0: @3780d700 00000000 00000000 00000000 00000000
[  121.312291] xhci_hcd 0000:05:00.0: @3780d710 00000000 00000000 00000000 00000000
[  121.312294] xhci_hcd 0000:05:00.0: @3780d720 00000000 00000000 00000000 00000000
[  121.312296] xhci_hcd 0000:05:00.0: @3780d730 00000000 00000000 00000000 00000000
[  121.312299] xhci_hcd 0000:05:00.0: @3780d740 00000000 00000000 00000000 00000000
[  121.312302] xhci_hcd 0000:05:00.0: @3780d750 00000000 00000000 00000000 00000000
[  121.312305] xhci_hcd 0000:05:00.0: @3780d760 00000000 00000000 00000000 00000000
[  121.312307] xhci_hcd 0000:05:00.0: @3780d770 00000000 00000000 00000000 00000000
[  121.312310] xhci_hcd 0000:05:00.0: @3780d780 00000000 00000000 00000000 00000000
[  121.312313] xhci_hcd 0000:05:00.0: @3780d790 00000000 00000000 00000000 00000000
[  121.312316] xhci_hcd 0000:05:00.0: @3780d7a0 00000000 00000000 00000000 00000000
[  121.312319] xhci_hcd 0000:05:00.0: @3780d7b0 00000000 00000000 00000000 00000000
[  121.312321] xhci_hcd 0000:05:00.0: @3780d7c0 00000000 00000000 00000000 00000000
[  121.312324] xhci_hcd 0000:05:00.0: @3780d7d0 00000000 00000000 00000000 00000000
[  121.312327] xhci_hcd 0000:05:00.0: @3780d7e0 00000000 00000000 00000000 00000000
[  121.312330] xhci_hcd 0000:05:00.0: @3780d7f0 00000000 00000000 00000000 00000000
[  121.312333] xhci_hcd 0000:05:00.0: Ring deq = ffff88003780d410 (virt), 0x3780d410 (dma)
[  121.312335] xhci_hcd 0000:05:00.0: Ring deq updated 1 times
[  121.312338] xhci_hcd 0000:05:00.0: Ring enq = ffff88003780d400 (virt), 0x3780d400 (dma)
[  121.312341] xhci_hcd 0000:05:00.0: Ring enq updated 0 times
[  121.312349] xhci_hcd 0000:05:00.0: ERST deq = 64'h3780d410
[  121.312351] xhci_hcd 0000:05:00.0: Command ring:
[  121.312354] xhci_hcd 0000:05:00.0: @3780d000 00000000 00000000 00000000 0000c401
[  121.312357] xhci_hcd 0000:05:00.0: @3780d010 00000000 00000000 00000000 00000000
[  121.312360] xhci_hcd 0000:05:00.0: @3780d020 00000000 00000000 00000000 00000000
[  121.312362] xhci_hcd 0000:05:00.0: @3780d030 00000000 00000000 00000000 00000000
[  121.312365] xhci_hcd 0000:05:00.0: @3780d040 00000000 00000000 00000000 00000000
[  121.312368] xhci_hcd 0000:05:00.0: @3780d050 00000000 00000000 00000000 00000000
[  121.312371] xhci_hcd 0000:05:00.0: @3780d060 00000000 00000000 00000000 00000000
[  121.312373] xhci_hcd 0000:05:00.0: @3780d070 00000000 00000000 00000000 00000000
[  121.312376] xhci_hcd 0000:05:00.0: @3780d080 00000000 00000000 00000000 00000000
[  121.312379] xhci_hcd 0000:05:00.0: @3780d090 00000000 00000000 00000000 00000000
[  121.312382] xhci_hcd 0000:05:00.0: @3780d0a0 00000000 00000000 00000000 00000000
[  121.312385] xhci_hcd 0000:05:00.0: @3780d0b0 00000000 00000000 00000000 00000000
[  121.312387] xhci_hcd 0000:05:00.0: @3780d0c0 00000000 00000000 00000000 00000000
[  121.312390] xhci_hcd 0000:05:00.0: @3780d0d0 00000000 00000000 00000000 00000000
[  121.312393] xhci_hcd 0000:05:00.0: @3780d0e0 00000000 00000000 00000000 00000000
[  121.312396] xhci_hcd 0000:05:00.0: @3780d0f0 00000000 00000000 00000000 00000000
[  121.312398] xhci_hcd 0000:05:00.0: @3780d100 00000000 00000000 00000000 00000000
[  121.312401] xhci_hcd 0000:05:00.0: @3780d110 00000000 00000000 00000000 00000000
[  121.312404] xhci_hcd 0000:05:00.0: @3780d120 00000000 00000000 00000000 00000000
[  121.312407] xhci_hcd 0000:05:00.0: @3780d130 00000000 00000000 00000000 00000000
[  121.312410] xhci_hcd 0000:05:00.0: @3780d140 00000000 00000000 00000000 00000000
[  121.312412] xhci_hcd 0000:05:00.0: @3780d150 00000000 00000000 00000000 00000000
[  121.312415] xhci_hcd 0000:05:00.0: @3780d160 00000000 00000000 00000000 00000000
[  121.312418] xhci_hcd 0000:05:00.0: @3780d170 00000000 00000000 00000000 00000000
[  121.312421] xhci_hcd 0000:05:00.0: @3780d180 00000000 00000000 00000000 00000000
[  121.312423] xhci_hcd 0000:05:00.0: @3780d190 00000000 00000000 00000000 00000000
[  121.312426] xhci_hcd 0000:05:00.0: @3780d1a0 00000000 00000000 00000000 00000000
[  121.312429] xhci_hcd 0000:05:00.0: @3780d1b0 00000000 00000000 00000000 00000000
[  121.312432] xhci_hcd 0000:05:00.0: @3780d1c0 00000000 00000000 00000000 00000000
[  121.312435] xhci_hcd 0000:05:00.0: @3780d1d0 00000000 00000000 00000000 00000000
[  121.312437] xhci_hcd 0000:05:00.0: @3780d1e0 00000000 00000000 00000000 00000000
[  121.312440] xhci_hcd 0000:05:00.0: @3780d1f0 00000000 00000000 00000000 00000000
[  121.312443] xhci_hcd 0000:05:00.0: @3780d200 00000000 00000000 00000000 00000000
[  121.312446] xhci_hcd 0000:05:00.0: @3780d210 00000000 00000000 00000000 00000000
[  121.312449] xhci_hcd 0000:05:00.0: @3780d220 00000000 00000000 00000000 00000000
[  121.312451] xhci_hcd 0000:05:00.0: @3780d230 00000000 00000000 00000000 00000000
[  121.312454] xhci_hcd 0000:05:00.0: @3780d240 00000000 00000000 00000000 00000000
[  121.312457] xhci_hcd 0000:05:00.0: @3780d250 00000000 00000000 00000000 00000000
[  121.312460] xhci_hcd 0000:05:00.0: @3780d260 00000000 00000000 00000000 00000000
[  121.312462] xhci_hcd 0000:05:00.0: @3780d270 00000000 00000000 00000000 00000000
[  121.312465] xhci_hcd 0000:05:00.0: @3780d280 00000000 00000000 00000000 00000000
[  121.312468] xhci_hcd 0000:05:00.0: @3780d290 00000000 00000000 00000000 00000000
[  121.312471] xhci_hcd 0000:05:00.0: @3780d2a0 00000000 00000000 00000000 00000000
[  121.312474] xhci_hcd 0000:05:00.0: @3780d2b0 00000000 00000000 00000000 00000000
[  121.312476] xhci_hcd 0000:05:00.0: @3780d2c0 00000000 00000000 00000000 00000000
[  121.312479] xhci_hcd 0000:05:00.0: @3780d2d0 00000000 00000000 00000000 00000000
[  121.312482] xhci_hcd 0000:05:00.0: @3780d2e0 00000000 00000000 00000000 00000000
[  121.312485] xhci_hcd 0000:05:00.0: @3780d2f0 00000000 00000000 00000000 00000000
[  121.312487] xhci_hcd 0000:05:00.0: @3780d300 00000000 00000000 00000000 00000000
[  121.312490] xhci_hcd 0000:05:00.0: @3780d310 00000000 00000000 00000000 00000000
[  121.312493] xhci_hcd 0000:05:00.0: @3780d320 00000000 00000000 00000000 00000000
[  121.312496] xhci_hcd 0000:05:00.0: @3780d330 00000000 00000000 00000000 00000000
[  121.312498] xhci_hcd 0000:05:00.0: @3780d340 00000000 00000000 00000000 00000000
[  121.312501] xhci_hcd 0000:05:00.0: @3780d350 00000000 00000000 00000000 00000000
[  121.312504] xhci_hcd 0000:05:00.0: @3780d360 00000000 00000000 00000000 00000000
[  121.312507] xhci_hcd 0000:05:00.0: @3780d370 00000000 00000000 00000000 00000000
[  121.312509] xhci_hcd 0000:05:00.0: @3780d380 00000000 00000000 00000000 00000000
[  121.312512] xhci_hcd 0000:05:00.0: @3780d390 00000000 00000000 00000000 00000000
[  121.312515] xhci_hcd 0000:05:00.0: @3780d3a0 00000000 00000000 00000000 00000000
[  121.312518] xhci_hcd 0000:05:00.0: @3780d3b0 00000000 00000000 00000000 00000000
[  121.312520] xhci_hcd 0000:05:00.0: @3780d3c0 00000000 00000000 00000000 00000000
[  121.312523] xhci_hcd 0000:05:00.0: @3780d3d0 00000000 00000000 00000000 00000000
[  121.312526] xhci_hcd 0000:05:00.0: @3780d3e0 00000000 00000000 00000000 00000000
[  121.312529] xhci_hcd 0000:05:00.0: @3780d3f0 3780d000 00000000 00000000 00001802
[  121.312532] xhci_hcd 0000:05:00.0: Ring deq = ffff88003780d010 (virt), 0x3780d010 (dma)
[  121.312534] xhci_hcd 0000:05:00.0: Ring deq updated 1 times
[  121.312537] xhci_hcd 0000:05:00.0: Ring enq = ffff88003780d010 (virt), 0x3780d010 (dma)
[  121.312539] xhci_hcd 0000:05:00.0: Ring enq updated 1 times
[  121.312547] xhci_hcd 0000:05:00.0: // xHC command ring deq ptr low bits + flags = @00000008
[  121.312550] xhci_hcd 0000:05:00.0: // xHC command ring deq ptr high bits = @00000000

--Q68bSM7Ycu6FN28Q--

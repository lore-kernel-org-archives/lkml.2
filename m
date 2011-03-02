Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757216Ab1CBAEv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 19:04:51 -0500
Received: from mga02.intel.com ([134.134.136.20]:8288 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751396Ab1CBAEt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 19:04:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,250,1297065600"; 
   d="txt'?scan'208";a="714932032"
Date: Tue, 1 Mar 2011 16:04:45 -0800
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-usb@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Ozan Caglayan <ozan@pardus.org.tr>
Subject: Re: 2.6.38 regression caused by commit 415e12b
Message-ID: <20110302000445.GA2621@xanatos>
References: <20110228014218.GA11083@xanatos>
 <201103012155.34182.rjw@sisk.pl>
 <20110301225058.GA2294@xanatos>
 <201103020030.16494.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="1yeeQ81UyVL57Vl7"
Content-Disposition: inline
In-Reply-To: <201103020030.16494.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1yeeQ81UyVL57Vl7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 02, 2011 at 12:30:16AM +0100, Rafael J. Wysocki wrote:
> On Tuesday, March 01, 2011, Sarah Sharp wrote:
> > On Tue, Mar 01, 2011 at 09:55:33PM +0100, Rafael J. Wysocki wrote:
> > > Please check if the appended patch (on top of the Linus' current) helps.
> > 
> > Sorry, it doesn't help.  Same message as before.
> 
> Can you send dmesg with the patch applied, please?

Attached.

Sarah

--1yeeQ81UyVL57Vl7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-patch-applied.txt"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.38-rc6+ (sarah@xanatos) (gcc version 4.4.1 (Ubuntu 4.4.1-4ubuntu9) ) #765 SMP PREEMPT Tue Mar 1 14:29:34 PST 2011
[    0.000000] Command line: root=UUID=17b05cc8-db3c-4770-8c5e-8702f049f6d1 ro  
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
[    0.000000] RAMDISK: 35dce000 - 37ff0000
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
[    0.000000] Kernel command line: root=UUID=17b05cc8-db3c-4770-8c5e-8702f049f6d1 ro  
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.000000] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.000000] xsave/xrstor: enabled xstate_bv 0x3, cntxt size 0x240
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 3905952k/5177344k available (4764k kernel code, 1089568k absent, 181824k reserved, 3941k data, 524k init)
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
[    0.000000] Detected 1862.018 MHz processor.
[    0.004004] Calibrating delay loop (skipped), value calculated using timer frequency.. 3724.03 BogoMIPS (lpj=7448072)
[    0.008054] pid_max: default: 32768 minimum: 301
[    0.008425] Mount-cache hash table entries: 256
[    0.009713] Initializing cgroup subsys ns
[    0.009761] ns_cgroup deprecated: consider using the 'clone_children' flag without the ns_cgroup.
[    0.009831] Initializing cgroup subsys cpuacct
[    0.009891] Initializing cgroup subsys memory
[    0.010042] Initializing cgroup subsys freezer
[    0.010260] CPU: Physical Processor ID: 0
[    0.010307] CPU: Processor Core ID: 0
[    0.010352] using mwait in idle threads.
[    0.010451] ACPI: Core revision 20110112
[    0.164046] Setting APIC routing to flat
[    0.164559] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.204308] CPU0: Intel(R) Core(TM)2 Duo CPU     L9400  @ 1.86GHz stepping 0a
[    0.208012] Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
[    0.208012] ... version:                2
[    0.208012] ... bit width:              40
[    0.208012] ... generic registers:      2
[    0.208012] ... value mask:             000000ffffffffff
[    0.208012] ... max period:             000000007fffffff
[    0.208012] ... fixed-purpose events:   3
[    0.208012] ... event mask:             0000000700000003
[    0.208012] NMI watchdog enabled, takes one hw-pmu counter.
[    0.208012] lockdep: fixing up alternatives.
[    0.208120] Booting Node   0, Processors  #1 Ok.
[    0.300089] NMI watchdog enabled, takes one hw-pmu counter.
[    0.304029] Brought up 2 CPUs
[    0.304077] Total of 2 processors activated (7448.03 BogoMIPS).
[    0.308862] NET: Registered protocol family 16
[    0.311159] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.311229] ACPI: bus type pci registered
[    0.311911] PCI: Using configuration type 1 for base access
[    0.325246] bio: create slab <bio-0> at 0
[    0.334400] ACPI: EC: EC description table is found, configuring boot EC
[    0.448182] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.504852] ACPI: SSDT 00000000bd8d7c20 002C8 (v01  PmRef  Cpu0Ist 00003000 INTL 20050624)
[    0.507822] ACPI: Dynamic OEM Table Load:
[    0.507935] ACPI: SSDT           (null) 002C8 (v01  PmRef  Cpu0Ist 00003000 INTL 20050624)
[    0.512089] ACPI: SSDT 00000000bd8d5020 0087A (v01  PmRef  Cpu0Cst 00003001 INTL 20050624)
[    0.517225] ACPI: Dynamic OEM Table Load:
[    0.517337] ACPI: SSDT           (null) 0087A (v01  PmRef  Cpu0Cst 00003001 INTL 20050624)
[    0.553346] ACPI: SSDT 00000000bd8d6ca0 001CF (v01  PmRef    ApIst 00003000 INTL 20050624)
[    0.557412] ACPI: Dynamic OEM Table Load:
[    0.557525] ACPI: SSDT           (null) 001CF (v01  PmRef    ApIst 00003000 INTL 20050624)
[    0.575642] ACPI: SSDT 00000000bd8d6f20 0008D (v01  PmRef    ApCst 00003000 INTL 20050624)
[    0.578332] ACPI: Dynamic OEM Table Load:
[    0.578445] ACPI: SSDT           (null) 0008D (v01  PmRef    ApCst 00003000 INTL 20050624)
[    0.598712] ACPI: Interpreter enabled
[    0.598762] ACPI: (supports S0 S3 S4 S5)
[    0.599324] ACPI: Using IOAPIC for interrupt routing
[    0.676934] ACPI: Power Resource [PUBS] (on)
[    0.739335] ACPI: EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
[    0.777563] ACPI: ACPI Dock Station Driver: 3 docks/bays found
[    0.777616] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.784663] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.785507] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.785560] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.785613] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.785676] pci_root PNP0A08:00: host bridge window [mem 0x000d4000-0x000d7fff]
[    0.785739] pci_root PNP0A08:00: host bridge window [mem 0x000d8000-0x000dbfff]
[    0.785802] pci_root PNP0A08:00: host bridge window [mem 0xc0000000-0xfebfffff]
[    0.785949] pci 0000:00:00.0: [8086:2a40] type 0 class 0x000600
[    0.786041] pci 0000:00:02.0: [8086:2a42] type 0 class 0x000300
[    0.786062] pci 0000:00:02.0: reg 10: [mem 0xf2000000-0xf23fffff 64bit]
[    0.786075] pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.786085] pci 0000:00:02.0: reg 20: [io  0x1800-0x1807]
[    0.786152] pci 0000:00:02.1: [8086:2a43] type 0 class 0x000380
[    0.786170] pci 0000:00:02.1: reg 10: [mem 0xf2400000-0xf24fffff 64bit]
[    0.786264] pci 0000:00:03.0: [8086:2a44] type 0 class 0x000780
[    0.786288] pci 0000:00:03.0: reg 10: [mem 0xf2826800-0xf282680f 64bit]
[    0.786352] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.786357] pci 0000:00:03.0: PME# disabled
[    0.786401] pci 0000:00:03.2: [8086:2a46] type 0 class 0x000101
[    0.786421] pci 0000:00:03.2: reg 10: [io  0x1828-0x182f]
[    0.786432] pci 0000:00:03.2: reg 14: [io  0x180c-0x180f]
[    0.786442] pci 0000:00:03.2: reg 18: [io  0x1820-0x1827]
[    0.786453] pci 0000:00:03.2: reg 1c: [io  0x1808-0x180b]
[    0.786463] pci 0000:00:03.2: reg 20: [io  0x1810-0x181f]
[    0.786543] pci 0000:00:03.3: [8086:2a47] type 0 class 0x000700
[    0.786563] pci 0000:00:03.3: reg 10: [io  0x1830-0x1837]
[    0.786574] pci 0000:00:03.3: reg 14: [mem 0xf2624000-0xf2624fff]
[    0.786734] pci 0000:00:19.0: [8086:10f5] type 0 class 0x000200
[    0.786767] pci 0000:00:19.0: reg 10: [mem 0xf2600000-0xf261ffff]
[    0.786782] pci 0000:00:19.0: reg 14: [mem 0xf2625000-0xf2625fff]
[    0.786798] pci 0000:00:19.0: reg 18: [io  0x1840-0x185f]
[    0.786890] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.786896] pci 0000:00:19.0: PME# disabled
[    0.786945] pci 0000:00:1a.0: [8086:2937] type 0 class 0x000c03
[    0.787020] pci 0000:00:1a.0: reg 20: [io  0x1860-0x187f]
[    0.787114] pci 0000:00:1a.1: [8086:2938] type 0 class 0x000c03
[    0.787188] pci 0000:00:1a.1: reg 20: [io  0x1880-0x189f]
[    0.787281] pci 0000:00:1a.2: [8086:2939] type 0 class 0x000c03
[    0.787355] pci 0000:00:1a.2: reg 20: [io  0x18a0-0x18bf]
[    0.787464] pci 0000:00:1a.7: [8086:293c] type 0 class 0x000c03
[    0.787497] pci 0000:00:1a.7: reg 10: [mem 0xf2826c00-0xf2826fff]
[    0.787615] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.787622] pci 0000:00:1a.7: PME# disabled
[    0.787678] pci 0000:00:1b.0: [8086:293e] type 0 class 0x000403
[    0.787705] pci 0000:00:1b.0: reg 10: [mem 0xf2620000-0xf2623fff 64bit]
[    0.787816] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.787822] pci 0000:00:1b.0: PME# disabled
[    0.787872] pci 0000:00:1c.0: [8086:2940] type 1 class 0x000604
[    0.787986] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.787992] pci 0000:00:1c.0: PME# disabled
[    0.788178] pci 0000:00:1c.1: [8086:2942] type 1 class 0x000604
[    0.788292] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.788298] pci 0000:00:1c.1: PME# disabled
[    0.788353] pci 0000:00:1c.3: [8086:2946] type 1 class 0x000604
[    0.788466] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.788472] pci 0000:00:1c.3: PME# disabled
[    0.788534] pci 0000:00:1d.0: [8086:2934] type 0 class 0x000c03
[    0.788608] pci 0000:00:1d.0: reg 20: [io  0x18c0-0x18df]
[    0.788701] pci 0000:00:1d.1: [8086:2935] type 0 class 0x000c03
[    0.788775] pci 0000:00:1d.1: reg 20: [io  0x18e0-0x18ff]
[    0.788868] pci 0000:00:1d.2: [8086:2936] type 0 class 0x000c03
[    0.788942] pci 0000:00:1d.2: reg 20: [io  0x1c00-0x1c1f]
[    0.789051] pci 0000:00:1d.7: [8086:293a] type 0 class 0x000c03
[    0.789084] pci 0000:00:1d.7: reg 10: [mem 0xf2827000-0xf28273ff]
[    0.789202] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.789209] pci 0000:00:1d.7: PME# disabled
[    0.789259] pci 0000:00:1e.0: [8086:2448] type 1 class 0x000604
[    0.789381] pci 0000:00:1f.0: [8086:2917] type 0 class 0x000601
[    0.789589] pci 0000:00:1f.2: [8086:2929] type 0 class 0x000106
[    0.789625] pci 0000:00:1f.2: reg 10: [io  0x1c48-0x1c4f]
[    0.789640] pci 0000:00:1f.2: reg 14: [io  0x183c-0x183f]
[    0.789655] pci 0000:00:1f.2: reg 18: [io  0x1c40-0x1c47]
[    0.789670] pci 0000:00:1f.2: reg 1c: [io  0x1838-0x183b]
[    0.789685] pci 0000:00:1f.2: reg 20: [io  0x1c20-0x1c3f]
[    0.789700] pci 0000:00:1f.2: reg 24: [mem 0xf2826000-0xf28267ff]
[    0.789766] pci 0000:00:1f.2: PME# supported from D3hot
[    0.789772] pci 0000:00:1f.2: PME# disabled
[    0.789819] pci 0000:00:1f.3: [8086:2930] type 0 class 0x000c05
[    0.789846] pci 0000:00:1f.3: reg 10: [mem 0xf2827400-0xf28274ff 64bit]
[    0.789886] pci 0000:00:1f.3: reg 20: [io  0x1c60-0x1c7f]
[    0.790025] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.790079] pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.790086] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.790096] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.790241] pci 0000:03:00.0: [8086:4237] type 0 class 0x000280
[    0.790286] pci 0000:03:00.0: reg 10: [mem 0xf2500000-0xf2501fff 64bit]
[    0.790475] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.790484] pci 0000:03:00.0: PME# disabled
[    0.790557] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.790612] pci 0000:00:1c.1:   bridge window [io  0xf000-0x0000] (disabled)
[    0.790618] pci 0000:00:1c.1:   bridge window [mem 0xf2500000-0xf25fffff]
[    0.790628] pci 0000:00:1c.1:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.790722] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    0.790775] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    0.790782] pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf1ffffff]
[    0.790792] pci 0000:00:1c.3:   bridge window [mem 0xf2900000-0xf29fffff 64bit pref]
[    0.790928] pci 0000:00:1e.0: PCI bridge to [bus 0d-0d] (subtractive decode)
[    0.790985] pci 0000:00:1e.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.790992] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.791002] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.791014] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.791026] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.791037] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.791049] pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive decode)
[    0.791061] pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
[    0.791073] pci 0000:00:1e.0:   bridge window [mem 0xc0000000-0xfebfffff] (subtractive decode)
[    0.791107] pci_bus 0000:00: on NUMA node 0
[    0.791129] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.797854] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP0._PRT]
[    0.799297] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
[    0.800813] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP3._PRT]
[    1.014092] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
[    1.016370] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
[    1.018624] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
[    1.021001] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
[    1.023260] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
[    1.025532] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
[    1.027803] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
[    1.030179] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
[    1.031439] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    1.031690] vgaarb: loaded
[    1.033150] SCSI subsystem initialized
[    1.033226] libata version 3.00 loaded.
[    1.033226] PCI: Using ACPI for IRQ routing
[    1.033226] PCI: pci_cache_line_size set to 64 bytes
[    1.033226] reserve RAM buffer: 000000000009ec00 - 000000000009ffff 
[    1.033226] reserve RAM buffer: 00000000bd6a1000 - 00000000bfffffff 
[    1.033226] reserve RAM buffer: 00000000bd7b7000 - 00000000bfffffff 
[    1.033226] reserve RAM buffer: 00000000bd8c7000 - 00000000bfffffff 
[    1.033226] reserve RAM buffer: 00000000bdc00000 - 00000000bfffffff 
[    1.036491] Bluetooth: Core ver 2.15
[    1.036638] NET: Registered protocol family 31
[    1.036687] Bluetooth: HCI device and connection manager initialized
[    1.036752] Bluetooth: HCI socket layer initialized
[    1.037142] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    1.044274] Switching to clocksource hpet
[    1.044395] pnp: PnP ACPI init
[    1.044596] ACPI: bus type pnp registered
[    1.047639] Switched to NOHz mode on CPU #0
[    1.047764] Switched to NOHz mode on CPU #1
[    1.078159] pnp 00:00: [mem 0x00000000-0x0009ffff]
[    1.078170] pnp 00:00: [mem 0x000c0000-0x000c3fff]
[    1.078180] pnp 00:00: [mem 0x000c4000-0x000c7fff]
[    1.078189] pnp 00:00: [mem 0x000c8000-0x000cbfff]
[    1.078199] pnp 00:00: [mem 0x000cc000-0x000cffff]
[    1.078208] pnp 00:00: [mem 0x000d0000-0x000d3fff]
[    1.078218] pnp 00:00: [mem 0x000d4000-0x000d3fff disabled]
[    1.078227] pnp 00:00: [mem 0x000d8000-0x000d7fff disabled]
[    1.078237] pnp 00:00: [mem 0x000dc000-0x000dffff]
[    1.078246] pnp 00:00: [mem 0x000e0000-0x000e3fff]
[    1.078255] pnp 00:00: [mem 0x000e4000-0x000e7fff]
[    1.078265] pnp 00:00: [mem 0x000e8000-0x000ebfff]
[    1.078274] pnp 00:00: [mem 0x000ec000-0x000effff]
[    1.078284] pnp 00:00: [mem 0x000f0000-0x000fffff]
[    1.078293] pnp 00:00: [mem 0x00100000-0xbfffffff]
[    1.078302] pnp 00:00: [mem 0xfec00000-0xfed3ffff]
[    1.078312] pnp 00:00: [mem 0xfed4c000-0xffffffff]
[    1.079018] system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
[    1.079091] system 00:00: [mem 0x000c0000-0x000c3fff] has been reserved
[    1.079163] system 00:00: [mem 0x000c4000-0x000c7fff] has been reserved
[    1.079233] system 00:00: [mem 0x000c8000-0x000cbfff] has been reserved
[    1.079303] system 00:00: [mem 0x000cc000-0x000cffff] has been reserved
[    1.079374] system 00:00: [mem 0x000d0000-0x000d3fff] has been reserved
[    1.079449] system 00:00: [mem 0x000dc000-0x000dffff] could not be reserved
[    1.079526] system 00:00: [mem 0x000e0000-0x000e3fff] could not be reserved
[    1.079602] system 00:00: [mem 0x000e4000-0x000e7fff] could not be reserved
[    1.079679] system 00:00: [mem 0x000e8000-0x000ebfff] could not be reserved
[    1.080214] system 00:00: [mem 0x000ec000-0x000effff] could not be reserved
[    1.080292] system 00:00: [mem 0x000f0000-0x000fffff] could not be reserved
[    1.080369] system 00:00: [mem 0x00100000-0xbfffffff] could not be reserved
[    1.080445] system 00:00: [mem 0xfec00000-0xfed3ffff] could not be reserved
[    1.080522] system 00:00: [mem 0xfed4c000-0xffffffff] could not be reserved
[    1.080577] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    1.080784] pnp 00:01: [bus 00-ff]
[    1.080795] pnp 00:01: [io  0x0cf8-0x0cff]
[    1.080805] pnp 00:01: [io  0x0000-0x0cf7 window]
[    1.080815] pnp 00:01: [io  0x0d00-0xffff window]
[    1.080825] pnp 00:01: [mem 0x000a0000-0x000bffff window]
[    1.080835] pnp 00:01: [mem 0x000c0000-0x000c3fff window]
[    1.080844] pnp 00:01: [mem 0x000c4000-0x000c7fff window]
[    1.080855] pnp 00:01: [mem 0x000c8000-0x000cbfff window]
[    1.080865] pnp 00:01: [mem 0x000cc000-0x000cffff window]
[    1.080874] pnp 00:01: [mem 0x000d0000-0x000d3fff window]
[    1.080883] pnp 00:01: [mem 0x000d4000-0x000d7fff window]
[    1.080893] pnp 00:01: [mem 0x000d8000-0x000dbfff window]
[    1.080902] pnp 00:01: [mem 0x000dc000-0x000dffff window]
[    1.080912] pnp 00:01: [mem 0x000e0000-0x000e3fff window]
[    1.080922] pnp 00:01: [mem 0x000e4000-0x000e7fff window]
[    1.080932] pnp 00:01: [mem 0x000e8000-0x000ebfff window]
[    1.080941] pnp 00:01: [mem 0x000ec000-0x000effff window]
[    1.080951] pnp 00:01: [mem 0xc0000000-0xfebfffff window]
[    1.080961] pnp 00:01: [mem 0xfed40000-0xfed4bfff window]
[    1.081331] pnp 00:01: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    1.103629] pnp 00:02: [io  0x0010-0x001f]
[    1.103640] pnp 00:02: [io  0x0090-0x009f]
[    1.103649] pnp 00:02: [io  0x0024-0x0025]
[    1.103658] pnp 00:02: [io  0x0028-0x0029]
[    1.103668] pnp 00:02: [io  0x002c-0x002d]
[    1.103677] pnp 00:02: [io  0x0030-0x0031]
[    1.103686] pnp 00:02: [io  0x0034-0x0035]
[    1.103695] pnp 00:02: [io  0x0038-0x0039]
[    1.103704] pnp 00:02: [io  0x003c-0x003d]
[    1.103714] pnp 00:02: [io  0x00a4-0x00a5]
[    1.103723] pnp 00:02: [io  0x00a8-0x00a9]
[    1.103732] pnp 00:02: [io  0x00ac-0x00ad]
[    1.103741] pnp 00:02: [io  0x00b0-0x00b5]
[    1.103751] pnp 00:02: [io  0x00b8-0x00b9]
[    1.103760] pnp 00:02: [io  0x00bc-0x00bd]
[    1.103769] pnp 00:02: [io  0x0050-0x0053]
[    1.103779] pnp 00:02: [io  0x0072-0x0077]
[    1.103788] pnp 00:02: [io  0x002e-0x002f]
[    1.103797] pnp 00:02: [io  0x1000-0x107f]
[    1.103806] pnp 00:02: [io  0x1180-0x11ff]
[    1.103816] pnp 00:02: [io  0x0800-0x080f]
[    1.103825] pnp 00:02: [io  0x15e0-0x15ef]
[    1.103835] pnp 00:02: [io  0x1600-0x167f]
[    1.103844] pnp 00:02: [io  0x1680-0x169f]
[    1.103854] pnp 00:02: [mem 0xe0000000-0xefffffff]
[    1.103863] pnp 00:02: [mem 0xfed1c000-0xfed1ffff]
[    1.103873] pnp 00:02: [mem 0xfed10000-0xfed13fff]
[    1.103882] pnp 00:02: [mem 0xfed18000-0xfed18fff]
[    1.103891] pnp 00:02: [mem 0xfed19000-0xfed19fff]
[    1.103901] pnp 00:02: [mem 0xfed45000-0xfed4bfff]
[    1.104651] system 00:02: [io  0x1000-0x107f] has been reserved
[    1.104722] system 00:02: [io  0x1180-0x11ff] has been reserved
[    1.104792] system 00:02: [io  0x0800-0x080f] has been reserved
[    1.104862] system 00:02: [io  0x15e0-0x15ef] has been reserved
[    1.104931] system 00:02: [io  0x1600-0x167f] has been reserved
[    1.105001] system 00:02: [io  0x1680-0x169f] has been reserved
[    1.105071] system 00:02: [mem 0xe0000000-0xefffffff] has been reserved
[    1.105142] system 00:02: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    1.105213] system 00:02: [mem 0xfed10000-0xfed13fff] has been reserved
[    1.105283] system 00:02: [mem 0xfed18000-0xfed18fff] has been reserved
[    1.105354] system 00:02: [mem 0xfed19000-0xfed19fff] has been reserved
[    1.105425] system 00:02: [mem 0xfed45000-0xfed4bfff] has been reserved
[    1.105480] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.106110] pnp 00:03: [mem 0xfed00000-0xfed003ff]
[    1.106467] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.106601] pnp 00:04: [io  0x0000-0x000f]
[    1.106611] pnp 00:04: [io  0x0080-0x008f]
[    1.106620] pnp 00:04: [io  0x00c0-0x00df]
[    1.106630] pnp 00:04: [dma 4]
[    1.106988] pnp 00:04: Plug and Play ACPI device, IDs PNP0200 (active)
[    1.107122] pnp 00:05: [io  0x0061]
[    1.107483] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
[    1.107616] pnp 00:06: [io  0x00f0]
[    1.107635] pnp 00:06: [irq 13]
[    1.108016] pnp 00:06: Plug and Play ACPI device, IDs PNP0c04 (active)
[    1.108149] pnp 00:07: [io  0x0070-0x0071]
[    1.108165] pnp 00:07: [irq 8]
[    1.108529] pnp 00:07: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.108663] pnp 00:08: [io  0x0060]
[    1.108672] pnp 00:08: [io  0x0064]
[    1.108687] pnp 00:08: [irq 1]
[    1.109050] pnp 00:08: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.109190] pnp 00:09: [irq 12]
[    1.109560] pnp 00:09: Plug and Play ACPI device, IDs IBM3780 PNP0f13 (active)
[    1.131476] pnp 00:0a: [mem 0xfed40000-0xfed44fff]
[    1.131843] pnp 00:0a: Plug and Play ACPI device, IDs PNP0c31 (active)
[    1.135876] pnp: PnP ACPI: found 11 devices
[    1.135925] ACPI: ACPI bus type pnp unregistered
[    1.163586] pci 0000:00:1c.0: BAR 8: assigned [mem 0xc0000000-0xc01fffff]
[    1.163645] pci 0000:00:1c.0: BAR 9: assigned [mem 0xc0200000-0xc03fffff 64bit pref]
[    1.163713] pci 0000:00:1c.1: BAR 9: assigned [mem 0xc0400000-0xc05fffff 64bit pref]
[    1.163781] pci 0000:00:1c.0: BAR 7: assigned [io  0x3000-0x3fff]
[    1.163837] pci 0000:00:1c.1: BAR 7: assigned [io  0x4000-0x4fff]
[    1.163891] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    1.163943] pci 0000:00:1c.0:   bridge window [io  0x3000-0x3fff]
[    1.164018] pci 0000:00:1c.0:   bridge window [mem 0xc0000000-0xc01fffff]
[    1.164074] pci 0000:00:1c.0:   bridge window [mem 0xc0200000-0xc03fffff 64bit pref]
[    1.164144] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    1.164196] pci 0000:00:1c.1:   bridge window [io  0x4000-0x4fff]
[    1.164252] pci 0000:00:1c.1:   bridge window [mem 0xf2500000-0xf25fffff]
[    1.164307] pci 0000:00:1c.1:   bridge window [mem 0xc0400000-0xc05fffff 64bit pref]
[    1.164377] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    1.164429] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    1.164485] pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf1ffffff]
[    1.164541] pci 0000:00:1c.3:   bridge window [mem 0xf2900000-0xf29fffff 64bit pref]
[    1.164611] pci 0000:00:1e.0: PCI bridge to [bus 0d-0d]
[    1.164661] pci 0000:00:1e.0:   bridge window [io  disabled]
[    1.164716] pci 0000:00:1e.0:   bridge window [mem disabled]
[    1.164770] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    1.164848] pci 0000:00:1c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    1.164905] pci 0000:00:1c.0: setting latency timer to 64
[    1.164925] pci 0000:00:1c.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    1.164981] pci 0000:00:1c.1: setting latency timer to 64
[    1.165001] pci 0000:00:1c.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    1.165057] pci 0000:00:1c.3: setting latency timer to 64
[    1.165067] pci 0000:00:1e.0: setting latency timer to 64
[    1.165072] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.165075] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.165078] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.165081] pci_bus 0000:00: resource 7 [mem 0x000d4000-0x000d7fff]
[    1.165084] pci_bus 0000:00: resource 8 [mem 0x000d8000-0x000dbfff]
[    1.165088] pci_bus 0000:00: resource 9 [mem 0xc0000000-0xfebfffff]
[    1.165091] pci_bus 0000:02: resource 0 [io  0x3000-0x3fff]
[    1.165094] pci_bus 0000:02: resource 1 [mem 0xc0000000-0xc01fffff]
[    1.165097] pci_bus 0000:02: resource 2 [mem 0xc0200000-0xc03fffff 64bit pref]
[    1.165100] pci_bus 0000:03: resource 0 [io  0x4000-0x4fff]
[    1.165103] pci_bus 0000:03: resource 1 [mem 0xf2500000-0xf25fffff]
[    1.165106] pci_bus 0000:03: resource 2 [mem 0xc0400000-0xc05fffff 64bit pref]
[    1.165109] pci_bus 0000:05: resource 0 [io  0x2000-0x2fff]
[    1.165112] pci_bus 0000:05: resource 1 [mem 0xf0000000-0xf1ffffff]
[    1.165115] pci_bus 0000:05: resource 2 [mem 0xf2900000-0xf29fffff 64bit pref]
[    1.165119] pci_bus 0000:0d: resource 4 [io  0x0000-0x0cf7]
[    1.165121] pci_bus 0000:0d: resource 5 [io  0x0d00-0xffff]
[    1.165124] pci_bus 0000:0d: resource 6 [mem 0x000a0000-0x000bffff]
[    1.165127] pci_bus 0000:0d: resource 7 [mem 0x000d4000-0x000d7fff]
[    1.165130] pci_bus 0000:0d: resource 8 [mem 0x000d8000-0x000dbfff]
[    1.165134] pci_bus 0000:0d: resource 9 [mem 0xc0000000-0xfebfffff]
[    1.165268] NET: Registered protocol family 2
[    1.165567] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    1.167107] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    1.168923] TCP bind hash table entries: 65536 (order: 10, 4194304 bytes)
[    1.172279] TCP: Hash tables configured (established 262144 bind 65536)
[    1.172368] TCP reno registered
[    1.172440] UDP hash table entries: 2048 (order: 6, 327680 bytes)
[    1.172734] UDP-Lite hash table entries: 2048 (order: 6, 327680 bytes)
[    1.173451] NET: Registered protocol family 1
[    1.173570] pci 0000:00:02.0: Boot video device
[    1.173642] pci 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x00c0
[    1.173645] pci 0000:00:1a.0: Performing full reset
[    1.173676] pci 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x00c0
[    1.173679] pci 0000:00:1a.1: Performing full reset
[    1.173710] pci 0000:00:1a.2: uhci_check_and_reset_hc: cmd = 0x00c0
[    1.173713] pci 0000:00:1a.2: Performing full reset
[    1.173872] pci 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x00c0
[    1.173875] pci 0000:00:1d.0: Performing full reset
[    1.173905] pci 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x00c0
[    1.173908] pci 0000:00:1d.1: Performing full reset
[    1.173938] pci 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x00c0
[    1.173941] pci 0000:00:1d.2: Performing full reset
[    1.174081] PCI: CLS 64 bytes, default 64
[    1.174464] Trying to unpack rootfs image as initramfs...
[    2.153298] Freeing initrd memory: 34952k freed
[    2.313222] DMA-API: preallocated 32768 debug entries
[    2.313278] DMA-API: debugging enabled by kernel config
[    2.313335] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    2.313387] Placing 64MB software IO TLB between ffff8800b8c9d000 - ffff8800bcc9d000
[    2.313450] software IO TLB at phys 0xb8c9d000 - 0xbcc9d000
[    2.313682] Simple Boot Flag at 0x35 set to 0x1
[    2.315150] Scanning for low memory corruption every 60 seconds
[    2.316042] audit: initializing netlink socket (disabled)
[    2.316173] type=2000 audit(1299019295.312:1): initialized
[    2.333347] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    2.358481] fuse init (API version 7.16)
[    2.359444] msgmni has been set to 7697
[    2.360810] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    2.360881] io scheduler noop registered
[    2.360930] io scheduler deadline registered
[    2.361294] io scheduler cfq registered (default)
[    2.362846] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    2.363262] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    2.364109] ACPI: Deprecated procfs I/F for AC is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    2.365323] ACPI: AC Adapter [AC] (on-line)
[    2.366801] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
[    2.404023] ACPI: Lid Switch [LID]
[    2.404734] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input1
[    2.468021] ACPI: Sleep Button [SLPB]
[    2.468754] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    2.468829] ACPI: Power Button [PWRF]
[    2.469060] ACPI: acpi_idle registered with cpuidle
[    2.589222] Monitor-Mwait will be used to enter C-1 state
[    2.589301] Monitor-Mwait will be used to enter C-2 state
[    2.589376] Monitor-Mwait will be used to enter C-3 state
[    2.589389] Marking TSC unstable due to TSC halts in idle
[    2.687258] thermal LNXTHERM:00: registered as thermal_zone0
[    2.687310] ACPI: Thermal Zone [THM0] (58 C)
[    2.696882] thermal LNXTHERM:01: registered as thermal_zone1
[    2.696933] ACPI: Thermal Zone [THM1] (62 C)
[    2.697519] Linux agpgart interface v0.103
[    2.714161] brd: module loaded
[    2.722341] loop: module loaded
[    2.723790] ahci 0000:00:1f.2: version 3.0
[    2.723845] ahci 0000:00:1f.2: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    2.724192] ahci 0000:00:1f.2: irq 40 for MSI/MSI-X
[    2.724414] ahci: SSS flag set, parallel bus scan disabled
[    2.724573] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 4 ports 3 Gbps 0x3 impl SATA mode
[    2.724716] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part ccc sxs 
[    2.724820] ahci 0000:00:1f.2: setting latency timer to 64
[    2.735465] scsi0 : ahci
[    2.739546] scsi1 : ahci
[    2.740752] scsi2 : ahci
[    2.741894] scsi3 : ahci
[    2.748805] ACPI: Deprecated procfs I/F for battery is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    2.748961] ACPI: Battery Slot [BAT0] (battery present)
[    2.753136] ata1: SATA max UDMA/133 abar m2048@0xf2826000 port 0xf2826100 irq 40
[    2.753201] ata2: SATA max UDMA/133 abar m2048@0xf2826000 port 0xf2826180 irq 40
[    2.753263] ata3: DUMMY
[    2.753309] ata4: DUMMY
[    2.754017] ata_generic 0000:00:03.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    2.754214] ata_generic 0000:00:03.2: setting latency timer to 64
[    2.760444] scsi4 : ata_generic
[    2.761471] scsi5 : ata_generic
[    2.762385] ata5: PATA max UDMA/100 cmd 0x1828 ctl 0x180c bmdma 0x1810 irq 18
[    2.762438] ata6: PATA max UDMA/100 cmd 0x1820 ctl 0x1808 bmdma 0x1818 irq 18
[    2.762723] e1000e: Intel(R) PRO/1000 Network Driver - 1.2.20-k2
[    2.762775] e1000e: Copyright(c) 1999 - 2011 Intel Corporation.
[    2.762905] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    2.762980] e1000e 0000:00:19.0: setting latency timer to 64
[    2.763251] e1000e 0000:00:19.0: irq 41 for MSI/MSI-X
[    3.072031] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    3.076122] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    3.076127] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    3.076192] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    3.083404] e1000e 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:1f:16:1d:fb:eb
[    3.083469] e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    3.083544] e1000e 0000:00:19.0: eth0: MAC: 7, PHY: 8, PBA No: 1008FF-0FF
[    3.083753] PPP generic driver version 2.4.2
[    3.084615] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    3.095372] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.095809] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.096812] mousedev: PS/2 mouse device common for all mice
[    3.098284] rtc_cmos 00:07: RTC can wake from S4
[    3.104619] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
[    3.112628] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
[    3.112746] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    3.112859] Linux video capture interface: v2.00
[    3.113382] device-mapper: uevent: version 1.0.3
[    3.114055] device-mapper: ioctl: 4.19.1-ioctl (2011-01-07) initialised: dm-devel@redhat.com
[    3.114311] device-mapper: multipath: version 1.2.0 loaded
[    3.114380] device-mapper: multipath round-robin: version 1.0.0 loaded
[    3.115894] cpuidle: using governor ladder
[    3.117451] cpuidle: using governor menu
[    3.118422] TCP cubic registered
[    3.119643] NET: Registered protocol family 10
[    3.119784] ata1.00: ATA-8: ST9250410AS, 0002SDM1, max UDMA/133
[    3.119837] ata1.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    3.122193] NET: Registered protocol family 17
[    3.122374] Bluetooth: L2CAP ver 2.15
[    3.122422] Bluetooth: L2CAP socket layer initialized
[    3.122488] Bluetooth: SCO (Voice Link) ver 0.6
[    3.122537] Bluetooth: SCO socket layer initialized
[    3.122704] Bluetooth: RFCOMM TTY layer initialized
[    3.122782] Bluetooth: RFCOMM socket layer initialized
[    3.122832] Bluetooth: RFCOMM ver 1.11
[    3.122879] Registering the dns_resolver key type
[    3.125373] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    3.125378] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    3.125444] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    3.127473] ata1.00: configured for UDMA/133
[    3.128245] scsi 0:0:0:0: Direct-Access     ATA      ST9250410AS      0002 PQ: 0 ANSI: 5
[    3.130504] sd 0:0:0:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 GiB)
[    3.131201] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    3.131211] sd 0:0:0:0: [sda] Write Protect is off
[    3.131214] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.131485] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.171496]  sda: sda1 sda2 < sda5 >
[    3.174918] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.452103] ata2: SATA link down (SStatus 0 SControl 300)
[    3.618744] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[    3.638757] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/input/input4
[    3.643796] registered taskstats version 1
[    3.644026] kmemleak: Kernel memory leak detector initialized
[    3.644034] kmemleak: Automatic memory scanning thread started
[    3.645294] rtc_cmos 00:07: setting system clock to 2011-03-01 22:41:37 UTC (1299019297)
[    3.645359] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    3.645409] EDD information not available.
[    3.647937] Freeing unused kernel memory: 524k freed
[    3.648214] Write protecting the kernel read-only data: 8192k
[    3.653476] Freeing unused kernel memory: 1360k freed
[    3.654205] Freeing unused kernel memory: 8k freed
[    3.778768] udevd (118): /proc/118/oom_adj is deprecated, please use /proc/118/oom_score_adj instead.
[    3.946941] agpgart-intel 0000:00:00.0: Intel GM45 Chipset
[    3.947380] agpgart-intel 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
[    3.988032] agpgart-intel 0000:00:00.0: detected 32768K stolen memory
[    4.005081] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    4.134980] usbcore: registered new interface driver usbfs
[    4.135314] usbcore: registered new interface driver hub
[    4.145708] usbcore: registered new device driver usb
[    4.161271] uhci_hcd: USB Universal Host Controller Interface driver
[    4.165775] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[    4.165847] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[    4.165909] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    4.165991] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    4.165997] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    4.166150] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    4.169731] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    4.169784] Warning! ehci_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
[    4.169848] ehci_hcd: block sizes: qh 104 qtd 96 itd 192 sitd 96
[    4.174834] [drm] Initialized drm 1.1.0 20060810
[    4.180573] uhci_hcd 0000:00:1a.0: detected 2 ports
[    4.180630] uhci_hcd 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x0000
[    4.180633] uhci_hcd 0000:00:1a.0: Performing full reset
[    4.180652] uhci_hcd 0000:00:1a.0: supports USB remote wakeup
[    4.180825] uhci_hcd 0000:00:1a.0: irq 20, io base 0x00001860
[    4.181334] usb usb1: default language 0x0409
[    4.181497] usb usb1: udev 1, busnum 1, minor = 0
[    4.181501] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[    4.181554] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.181618] usb usb1: Product: UHCI Host Controller
[    4.181668] usb usb1: Manufacturer: Linux 2.6.38-rc6+ uhci_hcd
[    4.181721] usb usb1: SerialNumber: 0000:00:1a.0
[    4.183401] usb usb1: usb_probe_device
[    4.183406] usb usb1: configuration #1 chosen from 1 choice
[    4.183532] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    4.184129] hub 1-0:1.0: usb_probe_interface
[    4.184133] hub 1-0:1.0: usb_probe_interface - got id
[    4.184138] hub 1-0:1.0: USB hub found
[    4.184282] hub 1-0:1.0: 2 ports detected
[    4.184347] hub 1-0:1.0: standalone hub
[    4.184350] hub 1-0:1.0: no power switching (usb 1.0)
[    4.184352] hub 1-0:1.0: individual port over-current protection
[    4.184356] hub 1-0:1.0: power on to power good time: 2ms
[    4.184476] hub 1-0:1.0: local power source is good
[    4.184495] hub 1-0:1.0: trying to enable port power on non-switchable hub
[    4.186988] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[    4.187102] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[    4.187163] ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    4.187296] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    4.187301] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    4.187401] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 2
[    4.196485] ehci_hcd 0000:00:1a.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[    4.196492] ehci_hcd 0000:00:1a.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr hw prefetch
[    4.196669] ehci_hcd 0000:00:1a.7: debug port 1
[    4.196723] ehci_hcd 0000:00:1a.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    4.200601] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
[    4.200604] ehci_hcd 0000:00:1a.7: supports USB remote wakeup
[    4.200773] ehci_hcd 0000:00:1a.7: irq 23, io mem 0xf2826c00
[    4.200830] ehci_hcd 0000:00:1a.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    4.204720] ehci_hcd 0000:00:1a.7: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
[    4.216169] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    4.216779] usb usb2: default language 0x0409
[    4.216943] usb usb2: udev 1, busnum 2, minor = 128
[    4.216946] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    4.217000] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.217067] usb usb2: Product: EHCI Host Controller
[    4.217121] usb usb2: Manufacturer: Linux 2.6.38-rc6+ ehci_hcd
[    4.217174] usb usb2: SerialNumber: 0000:00:1a.7
[    4.219198] usb usb2: usb_probe_device
[    4.219203] usb usb2: configuration #1 chosen from 1 choice
[    4.219285] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[    4.219829] hub 2-0:1.0: usb_probe_interface
[    4.219832] hub 2-0:1.0: usb_probe_interface - got id
[    4.219837] hub 2-0:1.0: USB hub found
[    4.220028] hub 2-0:1.0: 6 ports detected
[    4.220093] hub 2-0:1.0: standalone hub
[    4.220096] hub 2-0:1.0: no power switching (usb 1.0)
[    4.220098] hub 2-0:1.0: individual port over-current protection
[    4.220102] hub 2-0:1.0: power on to power good time: 20ms
[    4.220199] hub 2-0:1.0: local power source is good
[    4.220219] hub 2-0:1.0: trying to enable port power on non-switchable hub
[    4.221962] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.0
[    4.222227] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    4.222306] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    4.222311] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    4.222411] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 3
[    4.232077] uhci_hcd 0000:00:1a.1: detected 2 ports
[    4.232133] uhci_hcd 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x0000
[    4.232136] uhci_hcd 0000:00:1a.1: Performing full reset
[    4.232320] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00001880
[    4.232715] usb usb3: default language 0x0409
[    4.232879] usb usb3: udev 1, busnum 3, minor = 256
[    4.232882] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    4.232935] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.232998] usb usb3: Product: UHCI Host Controller
[    4.233047] usb usb3: Manufacturer: Linux 2.6.38-rc6+ uhci_hcd
[    4.233098] usb usb3: SerialNumber: 0000:00:1a.1
[    4.234048] usb usb3: usb_probe_device
[    4.234051] usb usb3: configuration #1 chosen from 1 choice
[    4.234135] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[    4.234781] hub 3-0:1.0: usb_probe_interface
[    4.234784] hub 3-0:1.0: usb_probe_interface - got id
[    4.234788] hub 3-0:1.0: USB hub found
[    4.234939] hub 3-0:1.0: 2 ports detected
[    4.235006] hub 3-0:1.0: standalone hub
[    4.235008] hub 3-0:1.0: no power switching (usb 1.0)
[    4.235011] hub 3-0:1.0: individual port over-current protection
[    4.235014] hub 3-0:1.0: power on to power good time: 2ms
[    4.235117] hub 3-0:1.0: local power source is good
[    4.235136] hub 3-0:1.0: trying to enable port power on non-switchable hub
[    4.236850] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.1
[    4.237095] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[    4.237166] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[    4.237792] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    4.237919] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    4.237924] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    4.238026] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 4
[    4.252162] ehci_hcd 0000:00:1d.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[    4.252167] ehci_hcd 0000:00:1d.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr hw prefetch
[    4.252325] ehci_hcd 0000:00:1d.7: debug port 1
[    4.252376] ehci_hcd 0000:00:1d.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    4.256264] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    4.256267] ehci_hcd 0000:00:1d.7: supports USB remote wakeup
[    4.256415] ehci_hcd 0000:00:1d.7: irq 19, io mem 0xf2827000
[    4.256468] ehci_hcd 0000:00:1d.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    4.260346] ehci_hcd 0000:00:1d.7: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
[    4.272022] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    4.272426] usb usb4: default language 0x0409
[    4.272591] usb usb4: udev 1, busnum 4, minor = 384
[    4.272594] usb usb4: New USB device found, idVendor=1d6b, idProduct=0002
[    4.272647] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.272709] usb usb4: Product: EHCI Host Controller
[    4.272759] usb usb4: Manufacturer: Linux 2.6.38-rc6+ ehci_hcd
[    4.272809] usb usb4: SerialNumber: 0000:00:1d.7
[    4.273642] usb usb4: usb_probe_device
[    4.273645] usb usb4: configuration #1 chosen from 1 choice
[    4.273725] usb usb4: adding 4-0:1.0 (config #1, interface 0)
[    4.274243] hub 4-0:1.0: usb_probe_interface
[    4.274246] hub 4-0:1.0: usb_probe_interface - got id
[    4.274251] hub 4-0:1.0: USB hub found
[    4.274414] hub 4-0:1.0: 6 ports detected
[    4.274477] hub 4-0:1.0: standalone hub
[    4.274479] hub 4-0:1.0: no power switching (usb 1.0)
[    4.274482] hub 4-0:1.0: individual port over-current protection
[    4.274485] hub 4-0:1.0: power on to power good time: 20ms
[    4.274583] hub 4-0:1.0: local power source is good
[    4.274600] hub 4-0:1.0: trying to enable port power on non-switchable hub
[    4.276779] i915 0000:00:02.0: power state changed by ACPI to D0
[    4.276852] i915 0000:00:02.0: power state changed by ACPI to D0
[    4.276909] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    4.276964] i915 0000:00:02.0: setting latency timer to 64
[    4.280875] Monitor-Mwait will be used to enter C-3 state
[    4.284135] hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    4.320123] ehci_hcd 0000:00:1a.7: GetStatus port:3 status 001803 0  ACK POWER sig=j CSC CONNECT
[    4.320135] hub 2-0:1.0: port 3: status 0501 change 0001
[    4.332068] uhci_hcd 0000:00:1a.1: port 1 portsc 0082,00
[    4.372047] ehci_hcd 0000:00:1d.7: GetStatus port:1 status 001403 0  ACK POWER sig=k CSC CONNECT
[    4.372059] hub 4-0:1.0: port 1: status 0501 change 0001
[    4.372107] ehci_hcd 0000:00:1d.7: GetStatus port:2 status 001803 0  ACK POWER sig=j CSC CONNECT
[    4.372118] hub 4-0:1.0: port 2: status 0501 change 0001
[    4.420052] hub 2-0:1.0: state 7 ports 6 chg 0008 evt 0000
[    4.420087] hub 2-0:1.0: port 3, status 0501, change 0000, 480 Mb/s
[    4.439529] i915 0000:00:02.0: irq 42 for MSI/MSI-X
[    4.439616] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    4.439676] [drm] Driver supports precise vblank timestamp query.
[    4.476245] ehci_hcd 0000:00:1a.7: port 3 full speed --> companion
[    4.476252] ehci_hcd 0000:00:1a.7: GetStatus port:3 status 003801 0  ACK POWER OWNER sig=j CONNECT
[    4.476264] hub 2-0:1.0: port 3 not reset yet, waiting 50ms
[    4.532077] ehci_hcd 0000:00:1a.7: GetStatus port:3 status 003002 0  ACK POWER OWNER sig=se0 CSC
[    4.532183] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    4.532195] hub 4-0:1.0: state 7 ports 6 chg 0006 evt 0000
[    4.532225] hub 4-0:1.0: port 1, status 0501, change 0000, 480 Mb/s
[    4.532267] ehci_hcd 0000:00:1d.7: port 1 low speed --> companion
[    4.585278] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    4.588106] ehci_hcd 0000:00:1d.7: GetStatus port:1 status 003002 0  ACK POWER OWNER sig=se0 CSC
[    4.588233] hub 4-0:1.0: port 2, status 0501, change 0000, 480 Mb/s
[    4.644250] ehci_hcd 0000:00:1d.7: port 2 full speed --> companion
[    4.644676] ehci_hcd 0000:00:1d.7: GetStatus port:2 status 003801 0  ACK POWER OWNER sig=j CONNECT
[    4.644688] hub 4-0:1.0: port 2 not reset yet, waiting 50ms
[    4.700075] ehci_hcd 0000:00:1d.7: GetStatus port:2 status 003002 0  ACK POWER OWNER sig=se0 CSC
[    4.700175] hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0008
[    4.700209] hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0004
[    4.700242] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0002
[    4.700268] uhci_hcd 0000:00:1a.1: port 1 portsc 0093,00
[    4.700307] hub 3-0:1.0: port 1, status 0101, change 0001, 12 Mb/s
[    4.828083] hub 3-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x101
[    4.940075] usb 3-1: new full speed USB device using uhci_hcd and address 2
[    4.957025] fb0: inteldrmfb frame buffer device
[    4.957082] drm: registered panic notifier
[    5.054555] acpi device:02: registered as cooling_device2
[    5.057945] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input5
[    5.058667] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[    5.059560] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    5.059685] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[    5.059753] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[    5.059829] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    5.059908] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    5.059913] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    5.060072] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
[    5.068067] uhci_hcd 0000:00:1a.2: detected 2 ports
[    5.068125] uhci_hcd 0000:00:1a.2: uhci_check_and_reset_hc: cmd = 0x0000
[    5.068127] uhci_hcd 0000:00:1a.2: Performing full reset
[    5.068145] uhci_hcd 0000:00:1a.2: supports USB remote wakeup
[    5.068321] uhci_hcd 0000:00:1a.2: irq 22, io base 0x000018a0
[    5.068725] usb usb5: default language 0x0409
[    5.068899] usb usb5: udev 1, busnum 5, minor = 512
[    5.068902] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    5.068955] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.069017] usb usb5: Product: UHCI Host Controller
[    5.069067] usb usb5: Manufacturer: Linux 2.6.38-rc6+ uhci_hcd
[    5.069118] usb usb5: SerialNumber: 0000:00:1a.2
[    5.069942] usb usb5: usb_probe_device
[    5.069946] usb usb5: configuration #1 chosen from 1 choice
[    5.070030] usb usb5: adding 5-0:1.0 (config #1, interface 0)
[    5.070566] hub 5-0:1.0: usb_probe_interface
[    5.070569] hub 5-0:1.0: usb_probe_interface - got id
[    5.070573] hub 5-0:1.0: USB hub found
[    5.070725] hub 5-0:1.0: 2 ports detected
[    5.070791] hub 5-0:1.0: standalone hub
[    5.070794] hub 5-0:1.0: no power switching (usb 1.0)
[    5.070796] hub 5-0:1.0: individual port over-current protection
[    5.070799] hub 5-0:1.0: power on to power good time: 2ms
[    5.070908] hub 5-0:1.0: local power source is good
[    5.070927] hub 5-0:1.0: trying to enable port power on non-switchable hub
[    5.072051] usb 3-1: ep0 maxpacket = 8
[    5.072615] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.2
[    5.072855] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    5.072924] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    5.072981] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    5.073061] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    5.073065] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    5.073169] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
[    5.084120] uhci_hcd 0000:00:1d.0: detected 2 ports
[    5.084127] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
[    5.084130] uhci_hcd 0000:00:1d.0: Performing full reset
[    5.084147] uhci_hcd 0000:00:1d.0: supports USB remote wakeup
[    5.084326] uhci_hcd 0000:00:1d.0: irq 16, io base 0x000018c0
[    5.084690] usb usb6: default language 0x0409
[    5.084863] usb usb6: udev 1, busnum 6, minor = 640
[    5.084865] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    5.084868] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.084870] usb usb6: Product: UHCI Host Controller
[    5.084871] usb usb6: Manufacturer: Linux 2.6.38-rc6+ uhci_hcd
[    5.084873] usb usb6: SerialNumber: 0000:00:1d.0
[    5.085675] usb usb6: usb_probe_device
[    5.085678] usb usb6: configuration #1 chosen from 1 choice
[    5.085765] usb usb6: adding 6-0:1.0 (config #1, interface 0)
[    5.086408] hub 6-0:1.0: usb_probe_interface
[    5.086410] hub 6-0:1.0: usb_probe_interface - got id
[    5.086415] hub 6-0:1.0: USB hub found
[    5.086528] hub 6-0:1.0: 2 ports detected
[    5.086549] hub 6-0:1.0: standalone hub
[    5.086551] hub 6-0:1.0: no power switching (usb 1.0)
[    5.086553] hub 6-0:1.0: individual port over-current protection
[    5.086556] hub 6-0:1.0: power on to power good time: 2ms
[    5.086664] hub 6-0:1.0: local power source is good
[    5.086684] hub 6-0:1.0: trying to enable port power on non-switchable hub
[    5.088612] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.0
[    5.088764] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    5.088793] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    5.088797] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    5.088866] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
[    5.093387] Console: switching to colour frame buffer device 180x56
[    5.099557] usb 3-1: default language 0x0409
[    5.100082] uhci_hcd 0000:00:1d.1: detected 2 ports
[    5.100122] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
[    5.100126] uhci_hcd 0000:00:1d.1: Performing full reset
[    5.100313] uhci_hcd 0000:00:1d.1: irq 17, io base 0x000018e0
[    5.100665] usb usb7: default language 0x0409
[    5.100823] usb usb7: udev 1, busnum 7, minor = 768
[    5.100826] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    5.100861] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.100898] usb usb7: Product: UHCI Host Controller
[    5.100923] usb usb7: Manufacturer: Linux 2.6.38-rc6+ uhci_hcd
[    5.100954] usb usb7: SerialNumber: 0000:00:1d.1
[    5.101781] usb usb7: usb_probe_device
[    5.101791] usb usb7: configuration #1 chosen from 1 choice
[    5.101882] usb usb7: adding 7-0:1.0 (config #1, interface 0)
[    5.102420] hub 7-0:1.0: usb_probe_interface
[    5.102423] hub 7-0:1.0: usb_probe_interface - got id
[    5.102427] hub 7-0:1.0: USB hub found
[    5.102560] hub 7-0:1.0: 2 ports detected
[    5.102604] hub 7-0:1.0: standalone hub
[    5.102607] hub 7-0:1.0: no power switching (usb 1.0)
[    5.102609] hub 7-0:1.0: individual port over-current protection
[    5.102612] hub 7-0:1.0: power on to power good time: 2ms
[    5.102712] hub 7-0:1.0: local power source is good
[    5.102730] hub 7-0:1.0: trying to enable port power on non-switchable hub
[    5.104627] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.1
[    5.104741] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    5.104801] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    5.104805] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    5.104880] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
[    5.108567] usb 3-1: udev 2, busnum 3, minor = 257
[    5.108570] usb 3-1: New USB device found, idVendor=08ff, idProduct=2810
[    5.108611] usb 3-1: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[    5.108653] usb 3-1: Product: Fingerprint Sensor
[    5.109274] usb 3-1: usb_probe_device
[    5.109278] usb 3-1: configuration #1 chosen from 1 choice
[    5.111577] usb 3-1: adding 3-1:1.0 (config #1, interface 0)
[    5.112091] uhci_hcd 0000:00:1d.2: detected 2 ports
[    5.112126] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
[    5.112129] uhci_hcd 0000:00:1d.2: Performing full reset
[    5.112187] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001c00
[    5.112567] usb usb8: default language 0x0409
[    5.112725] usb usb8: udev 1, busnum 8, minor = 896
[    5.112727] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
[    5.112762] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.114006] usb usb8: Product: UHCI Host Controller
[    5.115263] usb usb8: Manufacturer: Linux 2.6.38-rc6+ uhci_hcd
[    5.116494] usb usb8: SerialNumber: 0000:00:1d.2
[    5.118744] usb usb8: usb_probe_device
[    5.118747] usb usb8: configuration #1 chosen from 1 choice
[    5.118834] usb usb8: adding 8-0:1.0 (config #1, interface 0)
[    5.119526] hub 8-0:1.0: usb_probe_interface
[    5.119529] hub 8-0:1.0: usb_probe_interface - got id
[    5.119534] hub 8-0:1.0: USB hub found
[    5.121022] hub 8-0:1.0: 2 ports detected
[    5.122366] hub 8-0:1.0: standalone hub
[    5.122369] hub 8-0:1.0: no power switching (usb 1.0)
[    5.122371] hub 8-0:1.0: individual port over-current protection
[    5.122374] hub 8-0:1.0: power on to power good time: 2ms
[    5.122483] hub 8-0:1.0: local power source is good
[    5.122504] hub 8-0:1.0: trying to enable port power on non-switchable hub
[    5.124398] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.2
[    5.168345] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    5.184109] uhci_hcd 0000:00:1d.0: port 1 portsc 01a3,00
[    5.184121] hub 6-0:1.0: port 1: status 0301 change 0001
[    5.184176] uhci_hcd 0000:00:1d.0: port 2 portsc 0093,00
[    5.184187] hub 6-0:1.0: port 2: status 0101 change 0001
[    5.204127] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    5.220105] hub 8-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    5.288143] hub 6-0:1.0: state 7 ports 2 chg 0006 evt 0000
[    5.288184] hub 6-0:1.0: port 1, status 0301, change 0000, 1.5 Mb/s
[    5.364061] usb usb1: suspend_rh (auto-stop)
[    5.400085] usb 6-1: new low speed USB device using uhci_hcd and address 2
[    5.557529] usb 6-1: skipped 1 descriptor after interface
[    5.557543] usb 6-1: skipped 1 descriptor after interface
[    5.562513] usb 6-1: default language 0x0409
[    5.577520] usb 6-1: udev 2, busnum 6, minor = 641
[    5.577524] usb 6-1: New USB device found, idVendor=046d, idProduct=c521
[    5.578761] usb 6-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    5.580057] usb 6-1: Product: USB Receiver
[    5.581347] usb 6-1: Manufacturer: Logitech
[    5.583200] usb 6-1: usb_probe_device
[    5.583204] usb 6-1: configuration #1 chosen from 1 choice
[    5.593527] usb 6-1: adding 6-1:1.0 (config #1, interface 0)
[    5.594321] usb 6-1: adding 6-1:1.1 (config #1, interface 1)
[    5.595935] hub 6-0:1.0: port 2, status 0101, change 0000, 12 Mb/s
[    5.611620] usbhid 6-1:1.0: usb_probe_interface
[    5.611625] usbhid 6-1:1.0: usb_probe_interface - got id
[    5.627624] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:1d.0/usb6/6-1/6-1:1.0/input/input6
[    5.631443] generic-usb 0003:046D:C521.0001: input,hidraw0: USB HID v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:1d.0-1/input0
[    5.633036] usbhid 6-1:1.1: usb_probe_interface
[    5.633039] usbhid 6-1:1.1: usb_probe_interface - got id
[    5.664574] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:1d.0/usb6/6-1/6-1:1.1/input/input7
[    5.666128] uhci_hcd 0000:00:1d.0: reserve dev 2 ep82-INT, period 8, phase 4, 118 us
[    5.666842] usbhid 6-1:1.1: looking for a minor, starting at 96
[    5.668220] generic-usb 0003:046D:C521.0002: input,hiddev0,hidraw1: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:1d.0-1/input1
[    5.669788] usbcore: registered new interface driver usbhid
[    5.671225] usbhid: USB HID core driver
[    5.704105] usb 6-2: new full speed USB device using uhci_hcd and address 3
[    5.777642] PM: Starting manual resume from disk
[    5.822619] EXT3-fs: barriers not enabled
[    5.840101] usb 6-2: ep0 maxpacket = 8
[    5.849274] kjournald starting.  Commit interval 5 seconds
[    5.849446] EXT3-fs (sda1): mounted filesystem with writeback data mode
[    5.863511] usb 6-2: default language 0x0409
[    5.886530] usb 6-2: udev 3, busnum 6, minor = 642
[    5.886535] usb 6-2: New USB device found, idVendor=04b3, idProduct=301a
[    5.888141] usb 6-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    5.888144] usb 6-2: Product: USB 1.1 2port downstream low power hub
[    5.888146] usb 6-2: Manufacturer: Lite-On Technology
[    5.888981] usb 6-2: usb_probe_device
[    5.888985] usb 6-2: configuration #1 chosen from 1 choice
[    5.895534] usb 6-2: adding 6-2:1.0 (config #1, interface 0)
[    5.897685] hub 6-2:1.0: usb_probe_interface
[    5.897688] hub 6-2:1.0: usb_probe_interface - got id
[    5.897693] hub 6-2:1.0: USB hub found
[    5.898512] hub 6-2:1.0: 3 ports detected
[    5.898530] hub 6-2:1.0: compound device; port removable status: FRR
[    5.898532] hub 6-2:1.0: individual port power switching
[    5.898534] hub 6-2:1.0: individual port over-current protection
[    5.898537] hub 6-2:1.0: power on to power good time: 44ms
[    5.899516] hub 6-2:1.0: hub controller current requirement: 100mA
[    5.899518] hub 6-2:1.0: 100mA bus power budget for each child
[    5.900534] hub 6-2:1.0: enabling power on all ports
[    6.001538] hub 6-2:1.0: port 1: status 0101 change 0001
[    6.104088] usb usb5: suspend_rh (auto-stop)
[    6.104119] usb usb7: suspend_rh (auto-stop)
[    6.104134] uhci_hcd 0000:00:1d.0: reserve dev 3 ep81-INT, period 128, phase 0, 12 us
[    6.104296] hub 6-2:1.0: state 7 ports 3 chg 0002 evt 0000
[    6.105519] hub 6-2:1.0: port 1, status 0101, change 0000, 12 Mb/s
[    6.181526] usb 6-2.1: new full speed USB device using uhci_hcd and address 4
[    6.276089] usb 6-2.1: ep0 maxpacket = 8
[    6.297509] usb 6-2.1: skipped 1 descriptor after interface
[    6.297522] usb 6-2.1: skipped 1 descriptor after interface
[    6.301509] usb 6-2.1: default language 0x0409
[    6.328524] usb 6-2.1: udev 4, busnum 6, minor = 643
[    6.328528] usb 6-2.1: New USB device found, idVendor=04b3, idProduct=301b
[    6.330023] usb 6-2.1: New USB device strings: Mfr=1, Product=3, SerialNumber=0
[    6.331467] usb 6-2.1: Product: USB Productivity Option Keyboard( has the hub in # 1 )
[    6.332986] usb 6-2.1: Manufacturer: Lite-On Technology
[    6.335085] usb 6-2.1: usb_probe_device
[    6.335089] usb 6-2.1: configuration #1 chosen from 1 choice
[    6.340540] usb 6-2.1: adding 6-2.1:1.0 (config #1, interface 0)
[    6.342692] usbhid 6-2.1:1.0: usb_probe_interface
[    6.342696] usbhid 6-2.1:1.0: usb_probe_interface - got id
[    6.352091] usb usb8: suspend_rh (auto-stop)
[    6.353192] input: Lite-On Technology USB Productivity Option Keyboard( has the hub in # 1 ) as /devices/pci0000:00/0000:00:1d.0/usb6/6-2/6-2.1/6-2.1:1.0/input/input8
[    6.354841] uhci_hcd 0000:00:1d.0: reserve dev 4 ep81-INT, period 8, phase 4, 17 us
[    6.356281] generic-usb 0003:04B3:301B.0003: input,hidraw2: USB HID v1.10 Keyboard [Lite-On Technology USB Productivity Option Keyboard( has the hub in # 1 )] on usb-0000:00:1d.0-2.1/input0
[    6.359939] usb 6-2.1: adding 6-2.1:1.1 (config #1, interface 1)
[    6.362683] usbhid 6-2.1:1.1: usb_probe_interface
[    6.362686] usbhid 6-2.1:1.1: usb_probe_interface - got id
[    6.367912] input: Lite-On Technology USB Productivity Option Keyboard( has the hub in # 1 ) as /devices/pci0000:00/0000:00:1d.0/usb6/6-2/6-2.1/6-2.1:1.1/input/input9
[    6.369691] uhci_hcd 0000:00:1d.0: reserve dev 4 ep82-INT, period 128, phase 0, 14 us
[    6.370951] generic-usb 0003:04B3:301B.0004: input,hidraw3: USB HID v1.10 Device [Lite-On Technology USB Productivity Option Keyboard( has the hub in # 1 )] on usb-0000:00:1d.0-2.1/input1
[    6.375641] hub 6-2:1.0: 356mA power budget left
[    6.375646] hub 6-2:1.0: state 7 ports 3 chg 0000 evt 0002
[    6.808114] hub 1-0:1.0: hub_suspend
[    6.808159] usb usb1: bus auto-suspend
[    6.808162] usb usb1: suspend_rh
[    6.824074] hub 2-0:1.0: hub_suspend
[    6.824082] usb usb2: bus auto-suspend
[    6.824086] ehci_hcd 0000:00:1a.7: suspend root hub
[    6.824154] hub 4-0:1.0: hub_suspend
[    6.824161] usb usb4: bus auto-suspend
[    6.824164] ehci_hcd 0000:00:1d.7: suspend root hub
[    7.808054] hub 5-0:1.0: hub_suspend
[    7.808068] usb usb5: bus auto-suspend
[    7.808072] usb usb5: suspend_rh
[    7.824095] hub 7-0:1.0: hub_suspend
[    7.824103] usb usb7: bus auto-suspend
[    7.824107] usb usb7: suspend_rh
[    7.824127] hub 8-0:1.0: hub_suspend
[    7.824139] usb usb8: bus auto-suspend
[    7.824141] usb usb8: suspend_rh
[    8.048000] Adding 5791396k swap on /dev/sda5.  Priority:-1 extents:1 across:5791396k 
[    8.664575] EXT3-fs (sda1): using internal journal
[    8.722041] udev: starting version 147
[   10.933512] cfg80211: Calling CRDA to update world regulatory domain
[   12.162963] ip_tables: (C) 2000-2006 Netfilter Core Team
[   12.705584] cfg80211: World regulatory domain updated:
[   12.705587] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   12.705591] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   12.705594] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   12.705597] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   12.705600] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   12.705602] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   15.179333] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[   15.179480] HDA Intel 0000:00:1b.0: irq 43 for MSI/MSI-X
[   15.179788] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   17.325302] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:
[   17.325306] iwlagn: Copyright(c) 2003-2010 Intel Corporation
[   17.325505] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   17.325515] iwlagn 0000:03:00.0: setting latency timer to 64
[   17.325618] iwlagn 0000:03:00.0: Detected Intel(R) WiFi Link 5100 AGN, REV=0x54
[   17.345034] iwlagn 0000:03:00.0: device EEPROM VER=0x11f, CALIB=0x4
[   17.345037] iwlagn 0000:03:00.0: Device SKU: 0Xb
[   17.345075] iwlagn 0000:03:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
[   17.345187] iwlagn 0000:03:00.0: irq 44 for MSI/MSI-X
[   19.864114] iwlagn 0000:03:00.0: loaded firmware version 8.24.2.12
[   20.426369] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
[   20.849828] e1000e 0000:00:19.0: irq 41 for MSI/MSI-X
[   20.904237] e1000e 0000:00:19.0: irq 41 for MSI/MSI-X
[   20.904986] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   23.833009] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx
[   23.833523] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   26.312116] uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 8, phase 4, 118 us
[   32.965634] usb usb8: usb auto-resume
[   32.965640] usb usb8: wakeup_rh
[   33.004088] hub 8-0:1.0: hub_resume
[   33.004447] usb usb7: usb auto-resume
[   33.004451] usb usb7: wakeup_rh
[   33.004652] hub 8-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   33.044099] hub 7-0:1.0: hub_resume
[   33.044820] usb usb5: usb auto-resume
[   33.044824] usb usb5: wakeup_rh
[   33.045004] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   33.084114] hub 5-0:1.0: hub_resume
[   33.084406] usb usb4: usb auto-resume
[   33.084412] ehci_hcd 0000:00:1d.7: resume root hub
[   33.084513] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   33.136060] hub 4-0:1.0: hub_resume
[   33.136430] hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0000
[   33.136737] usb usb2: usb auto-resume
[   33.136743] ehci_hcd 0000:00:1a.7: resume root hub
[   33.196067] hub 2-0:1.0: hub_resume
[   33.196354] hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0000
[   33.196522] usb usb1: usb auto-resume
[   33.196526] usb usb1: wakeup_rh
[   33.240049] hub 1-0:1.0: hub_resume
[   33.240204] hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   34.128078] usb usb8: suspend_rh (auto-stop)
[   34.128109] usb usb7: suspend_rh (auto-stop)
[   34.128136] usb usb5: suspend_rh (auto-stop)
[   34.376105] usb usb1: suspend_rh (auto-stop)
[   34.816013] eth0: no IPv6 routers present
[   35.804109] hub 8-0:1.0: hub_suspend
[   35.804122] usb usb8: bus auto-suspend
[   35.804126] usb usb8: suspend_rh
[   35.804148] hub 7-0:1.0: hub_suspend
[   35.804154] usb usb7: bus auto-suspend
[   35.804157] usb usb7: suspend_rh
[   35.808161] hub 5-0:1.0: hub_suspend
[   35.808169] usb usb5: bus auto-suspend
[   35.808172] usb usb5: suspend_rh
[   35.808192] hub 1-0:1.0: hub_suspend
[   35.808198] usb usb1: bus auto-suspend
[   35.808201] usb usb1: suspend_rh
[   35.808220] hub 4-0:1.0: hub_suspend
[   35.808226] usb usb4: bus auto-suspend
[   35.808229] ehci_hcd 0000:00:1d.7: suspend root hub
[   35.808258] hub 2-0:1.0: hub_suspend
[   35.808264] usb usb2: bus auto-suspend
[   35.808267] ehci_hcd 0000:00:1a.7: suspend root hub
[  457.764983] irq 23: nobody cared (try booting with the "irqpoll" option)
[  457.764989] Pid: 0, comm: kworker/0:0 Not tainted 2.6.38-rc6+ #765
[  457.764992] Call Trace:
[  457.764995]  <IRQ>  [<ffffffff8109a2a6>] ? __report_bad_irq+0x26/0xa0
[  457.765006]  [<ffffffff8109a4ac>] ? note_interrupt+0x18c/0x1d0
[  457.765011]  [<ffffffff8109ae2d>] ? handle_fasteoi_irq+0xcd/0x100
[  457.765016]  [<ffffffff8100543d>] ? handle_irq+0x1d/0x30
[  457.765019]  [<ffffffff81004bb8>] ? do_IRQ+0x58/0xd0
[  457.765024]  [<ffffffff8149fa93>] ? ret_from_intr+0x0/0xe
[  457.765027]  <EOI>  [<ffffffff8126f590>] ? acpi_idle_enter_c1+0x7e/0x99
[  457.765035]  [<ffffffff8126f572>] ? acpi_idle_enter_c1+0x60/0x99
[  457.765040]  [<ffffffff8138b082>] ? cpuidle_idle_call+0x82/0xf0
[  457.765045]  [<ffffffff81001906>] ? cpu_idle+0x56/0xb0
[  457.765049]  [<ffffffff81498b0a>] ? start_secondary+0x1c1/0x1c8
[  457.765054]  [<ffffffff81265882>] ? acpi_ps_parse_loop+0x2cb/0x95d
[  457.765058]  [<ffffffff812635fb>] ? acpi_ns_one_complete_parse+0x103/0x120
[  457.765061] handlers:
[  457.765063] [<ffffffffa00df4c0>] (usb_hcd_irq+0x0/0x70 [usbcore])
[  457.765080] Disabling IRQ #23
[  569.008523] tun: Universal TUN/TAP device driver, 1.6
[  569.008527] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[ 1272.640078] CE: hpet increased min_delta_ns to 20113 nsec

--1yeeQ81UyVL57Vl7--

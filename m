Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932616Ab0JEJ0R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 05:26:17 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:35977 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932424Ab0JEJ0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 05:26:10 -0400
To: tiwai@suse.de
CC: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: [REGRESSION] no sound on T60 laptop (HDA Intel)
Message-Id: <E1P33mT-0003qa-Fv@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 05 Oct 2010 11:25:53 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In 2.6.36-rc* sound stopped working on my T60 (HDA Intel).  Everything
appears normal except there's no sound.

Dmesg attached.

...

Hmm, it appears sound is back after a suspend/resume.   Strange.

Thanks,
Miklos



[    0.000000] Linux version 2.6.36-rc6-00084-gc6ea21e-dirty (mszeredi@tucsk) (gcc version 4.4.1 [gcc-4_4-branch revision 150839] (SUSE Linux) ) #99 SMP PREEMPT Mon Oct 4 15:37:55 CEST 2010
[    0.000000] Command line: root=/dev/sda5 vga=0x365
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
[    0.000000]  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000d2000 - 00000000000d4000 (reserved)
[    0.000000]  BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bfed0000 (usable)
[    0.000000]  BIOS-e820: 00000000bfed0000 - 00000000bfedf000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bfedf000 - 00000000bff00000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bff00000 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
[    0.000000]  BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff800000 - 0000000100000000 (reserved)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] e820 update range: 0000000000000000 - 0000000000001000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0xbfed0 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-DBFFF uncachable
[    0.000000]   DC000-DFFFF write-back
[    0.000000]   E0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 080000000 mask FC0000000 write-back
[    0.000000]   2 base 0BFF00000 mask FFFF00000 uncachable
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] found SMP MP-table at [ffff8800000f6810] f6810
[    0.000000] init_memory_mapping: 0000000000000000-00000000bfed0000
[    0.000000]  0000000000 - 00bfe00000 page 2M
[    0.000000]  00bfe00000 - 00bfed0000 page 4k
[    0.000000] kernel direct mapping tables up to bfed0000 @ 8000-d000
[    0.000000] ACPI: RSDP 00000000000f67e0 00024 (v02 LENOVO)
[    0.000000] ACPI: XSDT 00000000bfed13c7 0008C (v01 LENOVO TP-79    00002190  LTP 00000000)
[    0.000000] ACPI: FACP 00000000bfed1500 000F4 (v03 LENOVO TP-79    00002190 LNVO 00000001)
[    0.000000] ACPI Warning: 32/64X length mismatch in Gpe1Block: 0/32 (20100702/tbfadt-526)
[    0.000000] ACPI Warning: Optional field Gpe1Block has zero address or length: 0x000000000000102C/0x0 (20100702/tbfadt-557)
[    0.000000] ACPI: DSDT 00000000bfed185e 0D3C2 (v01 LENOVO TP-79    00002190 MSFT 0100000E)
[    0.000000] ACPI: FACS 00000000bfef4000 00040
[    0.000000] ACPI: SSDT 00000000bfed16b4 001AA (v01 LENOVO TP-79    00002190 MSFT 0100000E)
[    0.000000] ACPI: ECDT 00000000bfedec20 00052 (v01 LENOVO TP-79    00002190 LNVO 00000001)
[    0.000000] ACPI: TCPA 00000000bfedec72 00032 (v02 LENOVO TP-79    00002190 LNVO 00000001)
[    0.000000] ACPI: APIC 00000000bfedeca4 00068 (v01 LENOVO TP-79    00002190 LNVO 00000001)
[    0.000000] ACPI: MCFG 00000000bfeded0c 0003C (v01 LENOVO TP-79    00002190 LNVO 00000001)
[    0.000000] ACPI: HPET 00000000bfeded48 00038 (v01 LENOVO TP-79    00002190 LNVO 00000001)
[    0.000000] ACPI: SLIC 00000000bfedee62 00176 (v01 LENOVO TP-79    00002190  LTP 00000000)
[    0.000000] ACPI: BOOT 00000000bfedefd8 00028 (v01 LENOVO TP-79    00002190  LTP 00000001)
[    0.000000] ACPI: SSDT 00000000bfef2655 0025F (v01 LENOVO TP-79    00002190 INTL 20050513)
[    0.000000] ACPI: SSDT 00000000bfef28b4 000A6 (v01 LENOVO TP-79    00002190 INTL 20050513)
[    0.000000] ACPI: SSDT 00000000bfef295a 004F7 (v01 LENOVO TP-79    00002190 INTL 20050513)
[    0.000000] ACPI: SSDT 00000000bfef2e51 001D8 (v01 LENOVO TP-79    00002190 INTL 20050513)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000001 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   empty
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000001 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000bfed0
[    0.000000] On node 0 totalpages: 786030
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3942 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 10692 pages used for memmap
[    0.000000]   DMA32 zone: 771340 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
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
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] early_res array is doubled to 64 at [7000 - 77ff]
[    0.000000] Allocating PCI resources starting at c0000000 (gap: c0000000:30000000)
[    0.000000] setup_percpu: NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff880002600000 s79424 r8192 d22976 u1048576
[    0.000000] pcpu-alloc: s79424 r8192 d22976 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 775282
[    0.000000] Kernel command line: root=/dev/sda5 vga=0x365
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.000000] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Subtract (49 early reservations)
[    0.000000]   #1 [0001000000 - 0002487c98]   TEXT DATA BSS
[    0.000000]   #2 [0002488000 - 000248814c]             BRK
[    0.000000]   #3 [00000f6820 - 0000100000]   BIOS reserved
[    0.000000]   #4 [00000f6810 - 00000f6820]    MP-table mpf
[    0.000000]   #5 [000009f000 - 000009f5a1]   BIOS reserved
[    0.000000]   #6 [000009f6bd - 00000f6810]   BIOS reserved
[    0.000000]   #7 [000009f5a1 - 000009f6bd]    MP-table mpc
[    0.000000]   #8 [0000001000 - 0000003000]      TRAMPOLINE
[    0.000000]   #9 [0000003000 - 0000007000]     ACPI WAKEUP
[    0.000000]   #10 [0000008000 - 000000b000]         PGTABLE
[    0.000000]   #11 [0002488180 - 0002489180]         BOOTMEM
[    0.000000]   #12 [0002487cc0 - 0002487f00]         BOOTMEM
[    0.000000]   #13 [0002c8a000 - 000568a000]         BOOTMEM
[    0.000000]   #14 [0002489180 - 0002489580]         BOOTMEM
[    0.000000]   #15 [0002489580 - 00024c9580]         BOOTMEM
[    0.000000]   #16 [00024ca000 - 00024cb000]         BOOTMEM
[    0.000000]   #17 [0002487f00 - 0002487f41]         BOOTMEM
[    0.000000]   #18 [0002487f80 - 0002487fc3]         BOOTMEM
[    0.000000]   #19 [00024c9580 - 00024c9900]         BOOTMEM
[    0.000000]   #20 [00024c9900 - 00024c9968]         BOOTMEM
[    0.000000]   #21 [00024c9980 - 00024c99e8]         BOOTMEM
[    0.000000]   #22 [00024c9a00 - 00024c9a68]         BOOTMEM
[    0.000000]   #23 [00024c9a80 - 00024c9ae8]         BOOTMEM
[    0.000000]   #24 [00024c9b00 - 00024c9b68]         BOOTMEM
[    0.000000]   #25 [00024c9b80 - 00024c9be8]         BOOTMEM
[    0.000000]   #26 [00024c9c00 - 00024c9c68]         BOOTMEM
[    0.000000]   #27 [00024c9c80 - 00024c9ce8]         BOOTMEM
[    0.000000]   #28 [00024c9d00 - 00024c9d68]         BOOTMEM
[    0.000000]   #29 [00024c9d80 - 00024c9de8]         BOOTMEM
[    0.000000]   #30 [00024c9e00 - 00024c9e68]         BOOTMEM
[    0.000000]   #31 [00024c9e80 - 00024c9ee8]         BOOTMEM
[    0.000000]   #32 [00024c9f00 - 00024c9f68]         BOOTMEM
[    0.000000]   #33 [00024c9f80 - 00024c9fe8]         BOOTMEM
[    0.000000]   #34 [00024cb000 - 00024cb068]         BOOTMEM
[    0.000000]   #35 [00024cb080 - 00024cb099]         BOOTMEM
[    0.000000]   #36 [00024cb0c0 - 00024cb0d9]         BOOTMEM
[    0.000000]   #37 [0002600000 - 000261b000]         BOOTMEM
[    0.000000]   #38 [0002700000 - 000271b000]         BOOTMEM
[    0.000000]   #39 [00024cd100 - 00024cd108]         BOOTMEM
[    0.000000]   #40 [00024cd140 - 00024cd148]         BOOTMEM
[    0.000000]   #41 [00024cd180 - 00024cd188]         BOOTMEM
[    0.000000]   #42 [00024cd1c0 - 00024cd1d0]         BOOTMEM
[    0.000000]   #43 [00024cd200 - 00024cd340]         BOOTMEM
[    0.000000]   #44 [00024cd340 - 00024cd3a0]         BOOTMEM
[    0.000000]   #45 [00024cd3c0 - 00024cd420]         BOOTMEM
[    0.000000]   #46 [00024cd440 - 00024d5440]         BOOTMEM
[    0.000000]   #47 [000271b000 - 0002b1b000]         BOOTMEM
[    0.000000]   #48 [000568a000 - 000588a000]         BOOTMEM
[    0.000000] Memory: 3073384k/3144512k available (4414k kernel code, 392k absent, 70736k reserved, 6410k data, 416k init)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU-based detection of stalled CPUs is disabled.
[    0.000000] 	Verbose stalled-CPUs detection is disabled.
[    0.000000] NR_IRQS:320
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 5855 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 1828.655 MHz processor.
[    0.004016] Calibrating delay loop (skipped), value calculated using timer frequency.. 3657.31 BogoMIPS (lpj=7314620)
[    0.004030] pid_max: default: 32768 minimum: 301
[    0.004207] Mount-cache hash table entries: 256
[    0.008071] CPU: Physical Processor ID: 0
[    0.008077] CPU: Processor Core ID: 0
[    0.008084] mce: CPU supports 6 MCE banks
[    0.008097] CPU0: Thermal monitoring enabled (TM2)
[    0.008105] using mwait in idle threads.
[    0.008111] Performance Events: PEBS fmt0-, Core2 events, Intel PMU driver.
[    0.008125] PEBS disabled due to CPU errata.
[    0.008140] ... version:                2
[    0.008146] ... bit width:              40
[    0.008151] ... generic registers:      2
[    0.008157] ... value mask:             000000ffffffffff
[    0.008163] ... max period:             000000007fffffff
[    0.008170] ... fixed-purpose events:   3
[    0.008175] ... event mask:             0000000700000003
[    0.008294] ACPI: Core revision 20100702
[    0.040194] Setting APIC routing to flat
[    0.040618] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.082618] CPU0: Intel(R) Core(TM)2 CPU         T5600  @ 1.83GHz stepping 06
[    0.092044] lockdep: fixing up alternatives.
[    0.096167] Booting Node   0, Processors  #1 Ok.
[    0.188000] TSC synchronization [CPU#0 -> CPU#1]:
[    0.188000] Measured 566005 cycles TSC warp between CPUs, turning off TSC clock.
[    0.188000] Marking TSC unstable due to check_tsc_sync_source failed
[    0.188067] Brought up 2 CPUs
[    0.188075] Total of 2 processors activated (7314.85 BogoMIPS).
[    0.188685] NET: Registered protocol family 16
[    0.188685] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.188685] ACPI: bus type pci registered
[    0.192021] PCI: Using configuration type 1 for base access
[    0.204511] bio: create slab <bio-0> at 0
[    0.215676] ACPI: EC: EC description table is found, configuring boot EC
[    0.244526] ACPI: SSDT 00000000bfef1d36 00240 (v01  PmRef  Cpu0Ist 00000100 INTL 20050513)
[    0.246996] ACPI: Dynamic OEM Table Load:
[    0.247005] ACPI: SSDT (null) 00240 (v01  PmRef  Cpu0Ist 00000100 INTL 20050513)
[    0.247441] ACPI: SSDT 00000000bfef1ffb 0065A (v01  PmRef  Cpu0Cst 00000100 INTL 20050513)
[    0.249988] ACPI: Dynamic OEM Table Load:
[    0.249997] ACPI: SSDT (null) 0065A (v01  PmRef  Cpu0Cst 00000100 INTL 20050513)
[    0.250553] ACPI: SSDT 00000000bfef1c6e 000C8 (v01  PmRef  Cpu1Ist 00000100 INTL 20050513)
[    0.253061] ACPI: Dynamic OEM Table Load:
[    0.253070] ACPI: SSDT (null) 000C8 (v01  PmRef  Cpu1Ist 00000100 INTL 20050513)
[    0.253291] ACPI: SSDT 00000000bfef1f76 00085 (v01  PmRef  Cpu1Cst 00000100 INTL 20050513)
[    0.255719] ACPI: Dynamic OEM Table Load:
[    0.255727] ACPI: SSDT (null) 00085 (v01  PmRef  Cpu1Cst 00000100 INTL 20050513)
[    0.255798] ACPI: Interpreter enabled
[    0.255805] ACPI: (supports S0 S3 S5)
[    0.255861] ACPI: Using IOAPIC for interrupt routing
[    0.276490] ACPI: EC: GPE = 0x1c, I/O: command/status = 0x66, data = 0x62
[    0.276579] ACPI: Power Resource [PUBS] (on)
[    0.280875] ACPI: ACPI Dock Station Driver: 3 docks/bays found
[    0.280886] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    0.281720] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.281966] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    0.281966] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    0.281966] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    0.281966] pci_root PNP0A08:00: host bridge window [mem 0x000d4000-0x000d7fff] (ignored)
[    0.281966] pci_root PNP0A08:00: host bridge window [mem 0x000d8000-0x000dbfff] (ignored)
[    0.281966] pci_root PNP0A08:00: host bridge window [mem 0xc0000000-0xfebfffff] (ignored)
[    0.281966] pci_root PNP0A08:00: host bridge window [mem 0xfed40000-0xfed40fff] (ignored)
[    0.281966] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.281966] pci 0000:00:01.0: PME# disabled
[    0.281966] pci 0000:00:1b.0: reg 10: [mem 0xee400000-0xee403fff 64bit]
[    0.281966] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.281966] pci 0000:00:1b.0: PME# disabled
[    0.281966] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.281966] pci 0000:00:1c.0: PME# disabled
[    0.281966] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.281966] pci 0000:00:1c.1: PME# disabled
[    0.281966] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.281966] pci 0000:00:1c.2: PME# disabled
[    0.281966] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.281966] pci 0000:00:1c.3: PME# disabled
[    0.281966] pci 0000:00:1d.0: reg 20: [io  0x1800-0x181f]
[    0.281966] pci 0000:00:1d.1: reg 20: [io  0x1820-0x183f]
[    0.281966] pci 0000:00:1d.2: reg 20: [io  0x1840-0x185f]
[    0.281966] pci 0000:00:1d.3: reg 20: [io  0x1860-0x187f]
[    0.281998] pci 0000:00:1d.7: reg 10: [mem 0xee404000-0xee4043ff]
[    0.284116] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.284124] pci 0000:00:1d.7: PME# disabled
[    0.284435] pci 0000:00:1f.0: quirk: [io  0x1000-0x107f] claimed by ICH6 ACPI/GPIO/TCO
[    0.284449] pci 0000:00:1f.0: quirk: [io  0x1180-0x11bf] claimed by ICH6 GPIO
[    0.284461] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 1600 (mask 007f)
[    0.284473] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 15e0 (mask 000f)
[    0.284486] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 1680 (mask 001f)
[    0.284576] pci 0000:00:1f.1: reg 10: [io  0x0000-0x0007]
[    0.284593] pci 0000:00:1f.1: reg 14: [io  0x0000-0x0003]
[    0.284611] pci 0000:00:1f.1: reg 18: [io  0x0000-0x0007]
[    0.284628] pci 0000:00:1f.1: reg 1c: [io  0x0000-0x0003]
[    0.284646] pci 0000:00:1f.1: reg 20: [io  0x1880-0x188f]
[    0.284764] pci 0000:00:1f.2: reg 10: [io  0x18c8-0x18cf]
[    0.284782] pci 0000:00:1f.2: reg 14: [io  0x18ac-0x18af]
[    0.284799] pci 0000:00:1f.2: reg 18: [io  0x18c0-0x18c7]
[    0.284817] pci 0000:00:1f.2: reg 1c: [io  0x18a8-0x18ab]
[    0.284834] pci 0000:00:1f.2: reg 20: [io  0x18b0-0x18bf]
[    0.284852] pci 0000:00:1f.2: reg 24: [mem 0xee404400-0xee4047ff]
[    0.284914] pci 0000:00:1f.2: PME# supported from D3hot
[    0.284921] pci 0000:00:1f.2: PME# disabled
[    0.285052] pci 0000:00:1f.3: reg 20: [io  0x18e0-0x18ff]
[    0.285287] pci 0000:01:00.0: reg 10: [mem 0xd8000000-0xdfffffff pref]
[    0.285330] pci 0000:01:00.0: reg 14: [io  0x2000-0x20ff]
[    0.285372] pci 0000:01:00.0: reg 18: [mem 0xee100000-0xee10ffff]
[    0.285537] pci 0000:01:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    0.285650] pci 0000:01:00.0: supports D1 D2
[    0.285704] pci 0000:01:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.285717] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.285727] pci 0000:00:01.0:   bridge window [io  0x2000-0x2fff]
[    0.285733] pci 0000:00:01.0:   bridge window [mem 0xee100000-0xee1fffff]
[    0.285741] pci 0000:00:01.0:   bridge window [mem 0xd8000000-0xdfffffff 64bit pref]
[    0.285966] pci 0000:02:00.0: reg 10: [mem 0xee000000-0xee01ffff]
[    0.286017] pci 0000:02:00.0: reg 18: [io  0x3000-0x301f]
[    0.286194] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    0.286204] pci 0000:02:00.0: PME# disabled
[    0.286239] pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.286251] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.286263] pci 0000:00:1c.0:   bridge window [io  0x3000-0x3fff]
[    0.286270] pci 0000:00:1c.0:   bridge window [mem 0xee000000-0xee0fffff]
[    0.286282] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.286535] pci 0000:03:00.0: reg 10: [mem 0xedf00000-0xedf00fff]
[    0.286918] pci 0000:03:00.0: PME# supported from D0 D3hot
[    0.286933] pci 0000:03:00.0: PME# disabled
[    0.286990] pci 0000:03:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.287003] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.287014] pci 0000:00:1c.1:   bridge window [io  0x4000-0x5fff]
[    0.287021] pci 0000:00:1c.1:   bridge window [mem 0xec000000-0xedffffff]
[    0.287033] pci 0000:00:1c.1:   bridge window [mem 0xe4000000-0xe40fffff 64bit pref]
[    0.287123] pci 0000:00:1c.2: PCI bridge to [bus 04-0b]
[    0.287135] pci 0000:00:1c.2:   bridge window [io  0x6000-0x7fff]
[    0.287143] pci 0000:00:1c.2:   bridge window [mem 0xe8000000-0xe9ffffff]
[    0.287154] pci 0000:00:1c.2:   bridge window [mem 0xe4100000-0xe41fffff 64bit pref]
[    0.287243] pci 0000:00:1c.3: PCI bridge to [bus 0c-13]
[    0.287255] pci 0000:00:1c.3:   bridge window [io  0x8000-0x9fff]
[    0.287262] pci 0000:00:1c.3:   bridge window [mem 0xea000000-0xebffffff]
[    0.287274] pci 0000:00:1c.3:   bridge window [mem 0xe4200000-0xe42fffff 64bit pref]
[    0.287382] pci 0000:15:00.0: reg 10: [mem 0xe4300000-0xe4300fff]
[    0.287425] pci 0000:15:00.0: supports D1 D2
[    0.287428] pci 0000:15:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.287437] pci 0000:15:00.0: PME# disabled
[    0.287541] pci 0000:00:1e.0: PCI bridge to [bus 15-18] (subtractive decode)
[    0.287554] pci 0000:00:1e.0:   bridge window [io  0xa000-0xdfff]
[    0.287562] pci 0000:00:1e.0:   bridge window [mem 0xe4300000-0xe7ffffff]
[    0.287573] pci 0000:00:1e.0:   bridge window [mem 0xe0000000-0xe3ffffff 64bit pref]
[    0.287578] pci 0000:00:1e.0:   bridge window [io  0x0000-0xffff] (subtractive decode)
[    0.287581] pci 0000:00:1e.0:   bridge window [mem 0x00000000-0xffffffffffffffff] (subtractive decode)
[    0.287711] pci_bus 0000:00: on NUMA node 0
[    0.287717] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.288235] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]
[    0.288329] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP0._PRT]
[    0.288424] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
[    0.288514] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP2._PRT]
[    0.288621] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP3._PRT]
[    0.288727] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
[    0.304239] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
[    0.304457] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
[    0.304668] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
[    0.304878] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
[    0.305087] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
[    0.305297] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
[    0.305506] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
[    0.305716] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
[    0.305827] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.305827] vgaarb: loaded
[    0.305827] SCSI subsystem initialized
[    0.305827] libata version 3.00 loaded.
[    0.305827] usbcore: registered new interface driver usbfs
[    0.305827] usbcore: registered new interface driver hub
[    0.305827] usbcore: registered new device driver usb
[    0.305827] Advanced Linux Sound Architecture Driver Version 1.0.23.
[    0.305827] PCI: Using ACPI for IRQ routing
[    0.305827] PCI: pci_cache_line_size set to 64 bytes
[    0.308219] reserve RAM buffer: 000000000009f000 - 000000000009ffff 
[    0.308233] reserve RAM buffer: 00000000bfed0000 - 00000000bfffffff 
[    0.308310] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.308310] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.308310] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.320055] Switching to clocksource hpet
[    0.328359] pnp: PnP ACPI init
[    0.328420] ACPI: bus type pnp registered
[    0.333541] pnp: PnP ACPI: found 12 devices
[    0.333549] ACPI: ACPI bus type pnp unregistered
[    0.333585] system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.333596] system 00:00: [mem 0x000c0000-0x000c3fff] has been reserved
[    0.333606] system 00:00: [mem 0x000c4000-0x000c7fff] has been reserved
[    0.333615] system 00:00: [mem 0x000c8000-0x000cbfff] has been reserved
[    0.333624] system 00:00: [mem 0x000cc000-0x000cffff] has been reserved
[    0.333635] system 00:00: [mem 0x000d0000-0x000d3fff] could not be reserved
[    0.333645] system 00:00: [mem 0x000dc000-0x000dffff] could not be reserved
[    0.333655] system 00:00: [mem 0x000e0000-0x000e3fff] could not be reserved
[    0.333666] system 00:00: [mem 0x000e4000-0x000e7fff] could not be reserved
[    0.333676] system 00:00: [mem 0x000e8000-0x000ebfff] could not be reserved
[    0.333686] system 00:00: [mem 0x000ec000-0x000effff] could not be reserved
[    0.333696] system 00:00: [mem 0x000f0000-0x000fffff] could not be reserved
[    0.333706] system 00:00: [mem 0x00100000-0xbfffffff] could not be reserved
[    0.333717] system 00:00: [mem 0xfec00000-0xfed3ffff] could not be reserved
[    0.333727] system 00:00: [mem 0xfed41000-0xffffffff] could not be reserved
[    0.333750] system 00:02: [io  0x164e-0x164f] has been reserved
[    0.333760] system 00:02: [io  0x1000-0x107f] has been reserved
[    0.333768] system 00:02: [io  0x1180-0x11bf] has been reserved
[    0.333777] system 00:02: [io  0x0800-0x080f] has been reserved
[    0.333786] system 00:02: [io  0x15e0-0x15ef] has been reserved
[    0.333795] system 00:02: [io  0x1600-0x165f] could not be reserved
[    0.333805] system 00:02: [mem 0xf0000000-0xf3ffffff] has been reserved
[    0.333814] system 00:02: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.333824] system 00:02: [mem 0xfed14000-0xfed17fff] has been reserved
[    0.333833] system 00:02: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.333843] system 00:02: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.347759] pci 0000:00:1c.0: BAR 9: assigned [mem 0xc0000000-0xc01fffff 64bit pref]
[    0.347774] pci 0000:01:00.0: BAR 6: assigned [mem 0xee120000-0xee13ffff pref]
[    0.347784] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.347793] pci 0000:00:01.0:   bridge window [io  0x2000-0x2fff]
[    0.347805] pci 0000:00:01.0:   bridge window [mem 0xee100000-0xee1fffff]
[    0.347816] pci 0000:00:01.0:   bridge window [mem 0xd8000000-0xdfffffff 64bit pref]
[    0.347830] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.347839] pci 0000:00:1c.0:   bridge window [io  0x3000-0x3fff]
[    0.347853] pci 0000:00:1c.0:   bridge window [mem 0xee000000-0xee0fffff]
[    0.347865] pci 0000:00:1c.0:   bridge window [mem 0xc0000000-0xc01fffff 64bit pref]
[    0.347883] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.347892] pci 0000:00:1c.1:   bridge window [io  0x4000-0x5fff]
[    0.347906] pci 0000:00:1c.1:   bridge window [mem 0xec000000-0xedffffff]
[    0.347918] pci 0000:00:1c.1:   bridge window [mem 0xe4000000-0xe40fffff 64bit pref]
[    0.347935] pci 0000:00:1c.2: PCI bridge to [bus 04-0b]
[    0.347944] pci 0000:00:1c.2:   bridge window [io  0x6000-0x7fff]
[    0.347958] pci 0000:00:1c.2:   bridge window [mem 0xe8000000-0xe9ffffff]
[    0.347970] pci 0000:00:1c.2:   bridge window [mem 0xe4100000-0xe41fffff 64bit pref]
[    0.347987] pci 0000:00:1c.3: PCI bridge to [bus 0c-13]
[    0.348015] pci 0000:00:1c.3:   bridge window [io  0x8000-0x9fff]
[    0.348029] pci 0000:00:1c.3:   bridge window [mem 0xea000000-0xebffffff]
[    0.348041] pci 0000:00:1c.3:   bridge window [mem 0xe4200000-0xe42fffff 64bit pref]
[    0.348060] pci 0000:15:00.0: BAR 9: assigned [mem 0xe0000000-0xe3ffffff pref]
[    0.348071] pci 0000:15:00.0: BAR 10: assigned [mem 0xc4000000-0xc7ffffff]
[    0.348080] pci 0000:15:00.0: BAR 7: assigned [io  0xa000-0xa0ff]
[    0.348089] pci 0000:15:00.0: BAR 8: assigned [io  0xa400-0xa4ff]
[    0.348097] pci 0000:15:00.0: CardBus bridge to [bus 16-17]
[    0.348104] pci 0000:15:00.0:   bridge window [io  0xa000-0xa0ff]
[    0.348116] pci 0000:15:00.0:   bridge window [io  0xa400-0xa4ff]
[    0.348129] pci 0000:15:00.0:   bridge window [mem 0xe0000000-0xe3ffffff pref]
[    0.348143] pci 0000:15:00.0:   bridge window [mem 0xc4000000-0xc7ffffff]
[    0.348156] pci 0000:00:1e.0: PCI bridge to [bus 15-18]
[    0.348165] pci 0000:00:1e.0:   bridge window [io  0xa000-0xdfff]
[    0.348179] pci 0000:00:1e.0:   bridge window [mem 0xe4300000-0xe7ffffff]
[    0.348191] pci 0000:00:1e.0:   bridge window [mem 0xe0000000-0xe3ffffff 64bit pref]
[    0.348230] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.348242] pci 0000:00:01.0: setting latency timer to 64
[    0.348261] pci 0000:00:1c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    0.348273] pci 0000:00:1c.0: setting latency timer to 64
[    0.348291] pci 0000:00:1c.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    0.348304] pci 0000:00:1c.1: setting latency timer to 64
[    0.348322] pci 0000:00:1c.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    0.348334] pci 0000:00:1c.2: setting latency timer to 64
[    0.348354] pci 0000:00:1c.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    0.348365] pci 0000:00:1c.3: setting latency timer to 64
[    0.348375] pci 0000:00:1e.0: enabling device (0005 -> 0007)
[    0.348389] pci 0000:00:1e.0: setting latency timer to 64
[    0.348409] pci 0000:15:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.348424] pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
[    0.348427] pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffffffffffff]
[    0.348431] pci_bus 0000:01: resource 0 [io  0x2000-0x2fff]
[    0.348434] pci_bus 0000:01: resource 1 [mem 0xee100000-0xee1fffff]
[    0.348437] pci_bus 0000:01: resource 2 [mem 0xd8000000-0xdfffffff 64bit pref]
[    0.348441] pci_bus 0000:02: resource 0 [io  0x3000-0x3fff]
[    0.348444] pci_bus 0000:02: resource 1 [mem 0xee000000-0xee0fffff]
[    0.348447] pci_bus 0000:02: resource 2 [mem 0xc0000000-0xc01fffff 64bit pref]
[    0.348450] pci_bus 0000:03: resource 0 [io  0x4000-0x5fff]
[    0.348453] pci_bus 0000:03: resource 1 [mem 0xec000000-0xedffffff]
[    0.348457] pci_bus 0000:03: resource 2 [mem 0xe4000000-0xe40fffff 64bit pref]
[    0.348460] pci_bus 0000:04: resource 0 [io  0x6000-0x7fff]
[    0.348463] pci_bus 0000:04: resource 1 [mem 0xe8000000-0xe9ffffff]
[    0.348466] pci_bus 0000:04: resource 2 [mem 0xe4100000-0xe41fffff 64bit pref]
[    0.348470] pci_bus 0000:0c: resource 0 [io  0x8000-0x9fff]
[    0.348473] pci_bus 0000:0c: resource 1 [mem 0xea000000-0xebffffff]
[    0.348476] pci_bus 0000:0c: resource 2 [mem 0xe4200000-0xe42fffff 64bit pref]
[    0.348479] pci_bus 0000:15: resource 0 [io  0xa000-0xdfff]
[    0.348482] pci_bus 0000:15: resource 1 [mem 0xe4300000-0xe7ffffff]
[    0.348486] pci_bus 0000:15: resource 2 [mem 0xe0000000-0xe3ffffff 64bit pref]
[    0.348489] pci_bus 0000:15: resource 4 [io  0x0000-0xffff]
[    0.348492] pci_bus 0000:15: resource 5 [mem 0x00000000-0xffffffffffffffff]
[    0.348495] pci_bus 0000:16: resource 0 [io  0xa000-0xa0ff]
[    0.348498] pci_bus 0000:16: resource 1 [io  0xa400-0xa4ff]
[    0.348501] pci_bus 0000:16: resource 2 [mem 0xe0000000-0xe3ffffff pref]
[    0.348505] pci_bus 0000:16: resource 3 [mem 0xc4000000-0xc7ffffff]
[    0.348654] NET: Registered protocol family 2
[    0.348929] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.350072] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.353332] TCP bind hash table entries: 65536 (order: 9, 3670016 bytes)
[    0.360158] TCP: Hash tables configured (established 262144 bind 65536)
[    0.360239] TCP reno registered
[    0.360256] UDP hash table entries: 2048 (order: 6, 262144 bytes)
[    0.360679] UDP-Lite hash table entries: 2048 (order: 6, 262144 bytes)
[    0.361328] NET: Registered protocol family 1
[    0.361415] pci 0000:00:1d.0: uhci_check_and_reset_hc: legsup = 0x2000
[    0.361418] pci 0000:00:1d.0: Performing full reset
[    0.361444] pci 0000:00:1d.1: uhci_check_and_reset_hc: legsup = 0x2000
[    0.361447] pci 0000:00:1d.1: Performing full reset
[    0.361471] pci 0000:00:1d.2: uhci_check_and_reset_hc: legsup = 0x2000
[    0.361473] pci 0000:00:1d.2: Performing full reset
[    0.361499] pci 0000:00:1d.3: uhci_check_and_reset_hc: legsup = 0x2000
[    0.361501] pci 0000:00:1d.3: Performing full reset
[    0.361599] pci 0000:01:00.0: Boot video device
[    0.361731] PCI: CLS mismatch (64 != 32), using 64 bytes
[    0.362103] Simple Boot Flag at 0x35 set to 0x1
[    0.364937] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.365847] msgmni has been set to 6002
[    0.366403] io scheduler noop registered
[    0.366443] io scheduler cfq registered (default)
[    0.368272] pcieport 0000:00:01.0: ACPI _OSC control granted for 0x1d
[    0.368292] pcieport 0000:00:01.0: setting latency timer to 64
[    0.368374] pcieport 0000:00:01.0: irq 40 for MSI/MSI-X
[    0.368575] pcieport 0000:00:1c.0: ACPI _OSC control granted for 0x1d
[    0.368601] pcieport 0000:00:1c.0: setting latency timer to 64
[    0.368679] pcieport 0000:00:1c.0: irq 41 for MSI/MSI-X
[    0.369001] pcieport 0000:00:1c.1: ACPI _OSC control granted for 0x1d
[    0.369026] pcieport 0000:00:1c.1: setting latency timer to 64
[    0.369104] pcieport 0000:00:1c.1: irq 42 for MSI/MSI-X
[    0.369420] pcieport 0000:00:1c.2: ACPI _OSC control granted for 0x1d
[    0.369446] pcieport 0000:00:1c.2: setting latency timer to 64
[    0.369523] pcieport 0000:00:1c.2: irq 43 for MSI/MSI-X
[    0.369842] pcieport 0000:00:1c.3: ACPI _OSC control granted for 0x1d
[    0.369868] pcieport 0000:00:1c.3: setting latency timer to 64
[    0.369945] pcieport 0000:00:1c.3: irq 44 for MSI/MSI-X
[    0.370530] pcieport 0000:00:01.0: Signaling PME through PCIe PME interrupt
[    0.370541] pci 0000:01:00.0: Signaling PME through PCIe PME interrupt
[    0.370552] pcie_pme 0000:00:01.0:pcie01: service driver pcie_pme loaded
[    0.370605] pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
[    0.370614] pci 0000:02:00.0: Signaling PME through PCIe PME interrupt
[    0.370627] pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
[    0.370682] pcieport 0000:00:1c.1: Signaling PME through PCIe PME interrupt
[    0.370691] pci 0000:03:00.0: Signaling PME through PCIe PME interrupt
[    0.370704] pcie_pme 0000:00:1c.1:pcie01: service driver pcie_pme loaded
[    0.370756] pcieport 0000:00:1c.2: Signaling PME through PCIe PME interrupt
[    0.370769] pcie_pme 0000:00:1c.2:pcie01: service driver pcie_pme loaded
[    0.370821] pcieport 0000:00:1c.3: Signaling PME through PCIe PME interrupt
[    0.370835] pcie_pme 0000:00:1c.3:pcie01: service driver pcie_pme loaded
[    0.372874] vesafb: framebuffer at 0xd8000000, mapped to 0xffffc90000080000, using 5120k, total 16384k
[    0.372886] vesafb: mode is 1280x1024x16, linelength=2560, pages=5
[    0.372894] vesafb: scrolling: redraw
[    0.372900] vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
[    0.413823] Console: switching to colour frame buffer device 160x64
[    0.454307] fb0: VESA VGA frame buffer device
[    0.454607] intel_idle: MWAIT substates: 0x22220
[    0.454610] intel_idle: does not run on family 6 model 15
[    0.455057] input: Lid Switch as /class/input/input0
[    0.455547] ACPI: Lid Switch [LID]
[    0.455918] input: Sleep Button as /class/input/input1
[    0.456231] ACPI: Sleep Button [SLPB]
[    0.456634] input: Power Button as /class/input/input2
[    0.456879] ACPI: Power Button [PWRF]
[    0.461405] acpi device:05: registered as cooling_device0
[    0.462190] input: Video Bus as /class/input/input3
[    0.462426] ACPI: Video Device [VID1] (multi-head: yes  rom: no  post: no)
[    0.525617] Real Time Clock Driver v1.12b
[    0.526298] Non-volatile memory driver v1.3
[    0.526497] Linux agpgart interface v0.103
[    0.527387] [drm] Initialized drm 1.1.0 20060810
[    0.527764] [drm] radeon defaulting to userspace modesetting.
[    0.529949] pci 0000:01:00.0: power state changed by ACPI to D0
[    0.530248] pci 0000:01:00.0: power state changed by ACPI to D0
[    0.530542] pci 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.530871] pci 0000:01:00.0: setting latency timer to 64
[    0.531580] [drm] Initialized radeon 1.33.0 20080528 for 0000:01:00.0 on minor 0
[    0.533992] [drm:i915_init] *ERROR* drm/i915 can't work without intel_agp module!
[    0.534340] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    0.538756] loop: module loaded
[    0.538913] Uniform Multi-Platform E-IDE driver
[    0.539371] piix 0000:00:1f.1: IDE controller (0x8086:0x27df rev 0x02)
[    0.539689] pci 0000:00:1f.1: PCI INT C -> GSI 16 (level, low) -> IRQ 16
[    0.540028] piix 0000:00:1f.1: IDE port disabled
[    0.540294] piix 0000:00:1f.1: not 100% native mode: will probe irqs later
[    0.540618]     ide0: BM-DMA at 0x1880-0x1887
[    0.540829] Probing IDE interface ide0...
[    1.276360] hda: MATSHITADVD-RAM UJ-842, ATAPI CD/DVD-ROM drive
[    1.612208] hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
[    1.612522] hda: UDMA/33 mode selected
[    1.613035] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    1.616430] ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
[    1.616881] ide-gd driver 1.18
[    1.617134] ide-cd driver 5.00
[    1.618479] ide-cd: hda: ATAPI 24X DVD-ROM DVD-R/RAM CD-R/RW drive, 2048kB Cache
[    1.618904] cdrom: Uniform CD-ROM driver Revision: 3.20
[    1.629496] ahci 0000:00:1f.2: version 3.0
[    1.629519] ahci 0000:00:1f.2: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    1.629910] ahci 0000:00:1f.2: irq 45 for MSI/MSI-X
[    1.630026] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 1.5 Gbps 0x1 impl SATA mode
[    1.630411] ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum part 
[    1.643039] ahci 0000:00:1f.2: setting latency timer to 64
[    1.643289] scsi0 : ahci
[    1.656271] scsi1 : ahci
[    1.668834] scsi2 : ahci
[    1.681187] scsi3 : ahci
[    1.693565] ata1: SATA max UDMA/133 abar m1024@0xee404400 port 0xee404500 irq 45
[    1.705958] ata2: DUMMY
[    1.718134] ata3: DUMMY
[    1.730318] ata4: DUMMY
[    1.742932] tun: Universal TUN/TAP device driver, 1.6
[    1.755402] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    1.768621] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.781398] ehci_hcd: block sizes: qh 104 qtd 96 itd 192 sitd 96
[    1.781639] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[    1.794562] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[    1.807150] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    1.819748] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    1.819754] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    1.832707] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
[    1.845177] ehci_hcd 0000:00:1d.7: reset hcs_params 0x104208 dbg=1 cc=4 pcc=2 ordered !ppc ports=8
[    1.845183] ehci_hcd 0000:00:1d.7: reset hcc_params 6871 thresh 7 uframes 1024 64 bit addr
[    1.845237] ehci_hcd 0000:00:1d.7: using broken periodic workaround
[    1.857613] ehci_hcd 0000:00:1d.7: debug port 1
[    1.870022] ehci_hcd 0000:00:1d.7: reset command 0080022 (park)=0 ithresh=8 Async period=1024 Reset HALT
[    1.873906] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    1.873908] ehci_hcd 0000:00:1d.7: supports USB remote wakeup
[    1.873952] ehci_hcd 0000:00:1d.7: irq 19, io mem 0xee404000
[    1.886269] ehci_hcd 0000:00:1d.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    1.890165] ehci_hcd 0000:00:1d.7: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
[    1.900040] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    1.912441] usb usb1: default language 0x0409
[    1.912462] usb usb1: udev 1, busnum 1, minor = 0
[    1.912466] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    1.924646] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.936838] usb usb1: Product: EHCI Host Controller
[    1.949005] usb usb1: Manufacturer: Linux 2.6.36-rc6-00084-gc6ea21e-dirty ehci_hcd
[    1.961312] usb usb1: SerialNumber: 0000:00:1d.7
[    1.973878] usb usb1: usb_probe_device
[    1.973882] usb usb1: configuration #1 chosen from 1 choice
[    1.974023] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    1.974284] hub 1-0:1.0: usb_probe_interface
[    1.974287] hub 1-0:1.0: usb_probe_interface - got id
[    1.974295] hub 1-0:1.0: USB hub found
[    1.986464] hub 1-0:1.0: 8 ports detected
[    1.998516] hub 1-0:1.0: standalone hub
[    1.998519] hub 1-0:1.0: no power switching (usb 1.0)
[    1.998521] hub 1-0:1.0: individual port over-current protection
[    1.998525] hub 1-0:1.0: power on to power good time: 20ms
[    1.998636] hub 1-0:1.0: local power source is good
[    1.998640] hub 1-0:1.0: trying to enable port power on non-switchable hub
[    1.999251] uhci_hcd: USB Universal Host Controller Interface driver
[    2.011721] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    2.024172] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    2.036276] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.048405] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    2.048411] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    2.060620] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    2.064041] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.084887] uhci_hcd 0000:00:1d.0: detected 2 ports
[    2.096951] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    2.096956] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    2.097065] ehci_hcd 0000:00:1d.7: GetStatus port:2 status 001403 0  ACK POWER sig=k CSC CONNECT
[    2.097073] hub 1-0:1.0: port 2: status 0501 change 0001
[    2.097141] ehci_hcd 0000:00:1d.7: GetStatus port:7 status 001803 0  ACK POWER sig=j CSC CONNECT
[    2.097148] hub 1-0:1.0: port 7: status 0501 change 0001
[    2.097163] ehci_hcd 0000:00:1d.7: GetStatus port:8 status 001803 0  ACK POWER sig=j CSC CONNECT
[    2.097169] hub 1-0:1.0: port 8: status 0501 change 0001
[    2.097195] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
[    2.097197] uhci_hcd 0000:00:1d.0: Performing full reset
[    2.097215] uhci_hcd 0000:00:1d.0: supports USB remote wakeup
[    2.097252] uhci_hcd 0000:00:1d.0: irq 16, io base 0x00001800
[    2.097359] usb usb2: default language 0x0409
[    2.097379] usb usb2: udev 1, busnum 2, minor = 128
[    2.097381] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    2.097384] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.097387] usb usb2: Product: UHCI Host Controller
[    2.097389] usb usb2: Manufacturer: Linux 2.6.36-rc6-00084-gc6ea21e-dirty uhci_hcd
[    2.097391] usb usb2: SerialNumber: 0000:00:1d.0
[    2.184327] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    2.197132] usb usb2: usb_probe_device
[    2.197137] usb usb2: configuration #1 chosen from 1 choice
[    2.197155] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[    2.197315] hub 2-0:1.0: usb_probe_interface
[    2.197318] hub 2-0:1.0: usb_probe_interface - got id
[    2.197325] hub 2-0:1.0: USB hub found
[    2.209950] ata1.00: ATA-7: INTEL SSDSA2M080G2GN, 2CV102HA, max UDMA/133
[    2.210013] hub 2-0:1.0: 2 ports detected
[    2.210016] hub 2-0:1.0: standalone hub
[    2.210018] hub 2-0:1.0: no power switching (usb 1.0)
[    2.210020] hub 2-0:1.0: individual port over-current protection
[    2.210022] hub 2-0:1.0: power on to power good time: 2ms
[    2.210052] hub 2-0:1.0: local power source is good
[    2.210055] hub 2-0:1.0: trying to enable port power on non-switchable hub
[    2.210333] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.0
[    2.210389] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    2.210407] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    2.210411] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    2.210593] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[    2.210604] uhci_hcd 0000:00:1d.1: detected 2 ports
[    2.210611] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
[    2.210613] uhci_hcd 0000:00:1d.1: Performing full reset
[    2.210630] uhci_hcd 0000:00:1d.1: supports USB remote wakeup
[    2.210663] uhci_hcd 0000:00:1d.1: irq 17, io base 0x00001820
[    2.210739] usb usb3: default language 0x0409
[    2.210758] usb usb3: udev 1, busnum 3, minor = 256
[    2.210761] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    2.210764] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.210766] usb usb3: Product: UHCI Host Controller
[    2.210768] usb usb3: Manufacturer: Linux 2.6.36-rc6-00084-gc6ea21e-dirty uhci_hcd
[    2.210771] usb usb3: SerialNumber: 0000:00:1d.1
[    2.210974] usb usb3: usb_probe_device
[    2.210977] usb usb3: configuration #1 chosen from 1 choice
[    2.210994] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[    2.211132] hub 3-0:1.0: usb_probe_interface
[    2.211135] hub 3-0:1.0: usb_probe_interface - got id
[    2.211140] hub 3-0:1.0: USB hub found
[    2.211158] hub 3-0:1.0: 2 ports detected
[    2.211161] hub 3-0:1.0: standalone hub
[    2.211163] hub 3-0:1.0: no power switching (usb 1.0)
[    2.211165] hub 3-0:1.0: individual port over-current protection
[    2.211167] hub 3-0:1.0: power on to power good time: 2ms
[    2.211183] hub 3-0:1.0: local power source is good
[    2.211185] hub 3-0:1.0: trying to enable port power on non-switchable hub
[    2.211453] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.1
[    2.211597] hub 1-0:1.0: state 7 ports 8 chg 0184 evt 0000
[    2.211652] hub 1-0:1.0: port 2, status 0501, change 0000, 480 Mb/s
[    2.211753] ehci_hcd 0000:00:1d.7: port 2 low speed --> companion
[    2.211886] uhci_hcd 0000:00:1d.2: power state changed by ACPI to D0
[    2.212079] uhci_hcd 0000:00:1d.2: power state changed by ACPI to D0
[    2.212091] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    2.212102] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    2.212106] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    2.212284] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[    2.212298] uhci_hcd 0000:00:1d.2: detected 2 ports
[    2.212305] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
[    2.212307] uhci_hcd 0000:00:1d.2: Performing full reset
[    2.212325] uhci_hcd 0000:00:1d.2: supports USB remote wakeup
[    2.212359] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001840
[    2.212434] usb usb4: default language 0x0409
[    2.212454] usb usb4: udev 1, busnum 4, minor = 384
[    2.212457] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    2.212460] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.212462] usb usb4: Product: UHCI Host Controller
[    2.212464] usb usb4: Manufacturer: Linux 2.6.36-rc6-00084-gc6ea21e-dirty uhci_hcd
[    2.212467] usb usb4: SerialNumber: 0000:00:1d.2
[    2.212680] usb usb4: usb_probe_device
[    2.212684] usb usb4: configuration #1 chosen from 1 choice
[    2.212701] usb usb4: adding 4-0:1.0 (config #1, interface 0)
[    2.212845] hub 4-0:1.0: usb_probe_interface
[    2.212847] hub 4-0:1.0: usb_probe_interface - got id
[    2.212852] hub 4-0:1.0: USB hub found
[    2.212864] hub 4-0:1.0: 2 ports detected
[    2.212866] hub 4-0:1.0: standalone hub
[    2.212868] hub 4-0:1.0: no power switching (usb 1.0)
[    2.212870] hub 4-0:1.0: individual port over-current protection
[    2.212872] hub 4-0:1.0: power on to power good time: 2ms
[    2.212887] hub 4-0:1.0: local power source is good
[    2.212890] hub 4-0:1.0: trying to enable port power on non-switchable hub
[    2.213166] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.2
[    2.213216] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    2.213227] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[    2.213231] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    2.213419] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
[    2.213433] uhci_hcd 0000:00:1d.3: detected 2 ports
[    2.213440] uhci_hcd 0000:00:1d.3: uhci_check_and_reset_hc: cmd = 0x0000
[    2.213442] uhci_hcd 0000:00:1d.3: Performing full reset
[    2.213467] uhci_hcd 0000:00:1d.3: irq 19, io base 0x00001860
[    2.213544] usb usb5: default language 0x0409
[    2.213564] usb usb5: udev 1, busnum 5, minor = 512
[    2.213567] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    2.213569] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.213572] usb usb5: Product: UHCI Host Controller
[    2.213574] usb usb5: Manufacturer: Linux 2.6.36-rc6-00084-gc6ea21e-dirty uhci_hcd
[    2.213576] usb usb5: SerialNumber: 0000:00:1d.3
[    2.213791] usb usb5: usb_probe_device
[    2.213794] usb usb5: configuration #1 chosen from 1 choice
[    2.213811] usb usb5: adding 5-0:1.0 (config #1, interface 0)
[    2.213950] hub 5-0:1.0: usb_probe_interface
[    2.213953] hub 5-0:1.0: usb_probe_interface - got id
[    2.213958] hub 5-0:1.0: USB hub found
[    2.213969] hub 5-0:1.0: 2 ports detected
[    2.213972] hub 5-0:1.0: standalone hub
[    2.213973] hub 5-0:1.0: no power switching (usb 1.0)
[    2.213975] hub 5-0:1.0: individual port over-current protection
[    2.213978] hub 5-0:1.0: power on to power good time: 2ms
[    2.213992] hub 5-0:1.0: local power source is good
[    2.213995] hub 5-0:1.0: trying to enable port power on non-switchable hub
[    2.214276] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.3
[    2.214644] PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    2.222775] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.223011] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.223411] mice: PS/2 mouse device common for all mice
[    2.225003] coretemp coretemp.0: TjMax is assumed as 100 C!
[    2.771584] coretemp coretemp.1: TjMax is assumed as 100 C!
[    2.771855] cpuidle: using governor ladder
[    2.771858] cpuidle: using governor menu
[    2.772246] ehci_hcd 0000:00:1d.7: GetStatus port:2 status 003002 0  ACK POWER OWNER sig=se0 CSC
[    2.772348] hub 1-0:1.0: port 7, status 0501, change 0000, 480 Mb/s
[    2.772392] uhci_hcd 0000:00:1d.0: port 2 portsc 01ab,00
[    2.772399] hub 2-0:1.0: port 2: status 0301 change 0003
[    2.772482] uhci_hcd 0000:00:1d.3: port 1 portsc 008a,00
[    2.772509] uhci_hcd 0000:00:1d.3: port 2 portsc 008a,00
[    2.775109] input: AT Translated Set 2 keyboard as /class/input/input4
[    2.776017] usbcore: registered new interface driver usbhid
[    2.776019] usbhid: USB HID core driver
[    2.776551] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    2.776558] hda_intel: probe_mask set to 0x1 for device 17aa:2010
[    2.776647] HDA Intel 0000:00:1b.0: irq 46 for MSI/MSI-X
[    2.776710] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    2.776767] ata1.00: 156301488 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    2.777270] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    2.777274] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    2.777278] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    2.777510] ata1.00: configured for UDMA/133
[    2.788627] ata1.00: configured for UDMA/133
[    2.788632] ata1: EH complete
[    2.789162] scsi 0:0:0:0: Direct-Access     ATA      INTEL SSDSA2M080 2CV1 PQ: 0 ANSI: 5
[    2.790257] sd 0:0:0:0: [sda] 156301488 512-byte logical blocks: (80.0 GB/74.5 GiB)
[    2.790392] sd 0:0:0:0: [sda] Write Protect is off
[    2.790395] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.790451] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.791974] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.792071]  sda: sda1 sda2 sda3 < sda5 >
[    2.923690] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.924317] ehci_hcd 0000:00:1d.7: port 7 full speed --> companion
[    2.924324] ehci_hcd 0000:00:1d.7: GetStatus port:7 status 003801 0  ACK POWER OWNER sig=j CONNECT
[    2.924332] hub 1-0:1.0: port 7 not reset yet, waiting 50ms
[    3.024146] ehci_hcd 0000:00:1d.7: GetStatus port:7 status 003002 0  ACK POWER OWNER sig=se0 CSC
[    3.024195] hub 1-0:1.0: port 8, status 0501, change 0000, 480 Mb/s
[    3.041754] ALSA device list:
[    3.053626]   #0: HDA Intel at 0xee400000 irq 46
[    3.065542] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    3.076189] ehci_hcd 0000:00:1d.7: port 8 full speed --> companion
[    3.076195] ehci_hcd 0000:00:1d.7: GetStatus port:8 status 003801 0  ACK POWER OWNER sig=j CONNECT
[    3.076202] hub 1-0:1.0: port 8 not reset yet, waiting 50ms
[    3.079218] ip_tables: (C) 2000-2006 Netfilter Core Team
[    3.091458] TCP cubic registered
[    3.103388] NET: Registered protocol family 17
[    3.132035] ehci_hcd 0000:00:1d.7: GetStatus port:8 status 003002 0  ACK POWER OWNER sig=se0 CSC
[    3.132079] hub 1-0:1.0: state 7 ports 8 chg 0000 evt 0100
[    3.132127] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    3.132140] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    3.132151] hub 2-0:1.0: state 7 ports 2 chg 0004 evt 0000
[    3.132172] hub 2-0:1.0: port 2, status 0301, change 0000, 1.5 Mb/s
[    3.244029] usb 2-2: new low speed USB device using uhci_hcd and address 2
[    3.376023] usb usb3: suspend_rh (auto-stop)
[    3.376050] usb usb4: suspend_rh (auto-stop)
[    3.410352] usb 2-2: skipped 1 descriptor after interface
[    3.415344] usb 2-2: default language 0x0409
[    3.432348] usb 2-2: udev 2, busnum 2, minor = 129
[    3.432351] usb 2-2: New USB device found, idVendor=045e, idProduct=0084
[    3.444420] usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    3.456484] usb 2-2: Product: Basic Optical Mouse
[    3.468498] usb 2-2: Manufacturer: Microsoft
[    3.480835] usb 2-2: usb_probe_device
[    3.480840] usb 2-2: configuration #1 chosen from 1 choice
[    3.483359] usb 2-2: adding 2-2:1.0 (config #1, interface 0)
[    3.483512] usbhid 2-2:1.0: usb_probe_interface
[    3.483516] usbhid 2-2:1.0: usb_probe_interface - got id
[    3.496818] input: Microsoft Basic Optical Mouse as /class/input/input5
[    3.509928] generic-usb 0003:045E:0084.0001: input,hidraw0: USB HID v1.10 Mouse [Microsoft Basic Optical Mouse] on usb-0000:00:1d.0-2/input0
[    3.523142] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0006
[    3.523156] uhci_hcd 0000:00:1d.3: port 1 portsc 0093,00
[    3.523171] hub 5-0:1.0: port 1, status 0101, change 0001, 12 Mb/s
[    3.632729] Synaptics Touchpad, model: 1, fw: 6.2, id: 0x81a0b1, caps: 0xa04793/0x300000/0x0
[    3.645810] serio: Synaptics pass-through port at isa0060/serio1/input0
[    3.658990] hub 5-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x101
[    3.700760] input: SynPS/2 Synaptics TouchPad as /class/input/input6
[    3.718334] EXT3-fs (sda5): error: couldn't mount because of unsupported optional features (240)
[    3.735286] EXT4-fs (sda5): mounted filesystem with ordered data mode. Opts: (null)
[    3.749065] VFS: Mounted root (ext4 filesystem) readonly on device 8:5.
[    3.763242] Freeing unused kernel memory: 416k freed
[    3.768038] usb 5-1: new full speed USB device using uhci_hcd and address 2
[    3.790652] Write protecting the kernel read-only data: 10240k
[    3.805307] Freeing unused kernel memory: 1708k freed
[    3.820378] Freeing unused kernel memory: 1944k freed
[    3.943551] usb 5-1: skipped 1 descriptor after interface
[    3.948534] usb 5-1: default language 0x0409
[    3.958546] usb 5-1: udev 2, busnum 5, minor = 513
[    3.958550] usb 5-1: New USB device found, idVendor=0a5c, idProduct=2110
[    3.972456] usb 5-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    3.986517] usb 5-1: Product: BCM2045B
[    4.000587] usb 5-1: Manufacturer: Broadcom Corp
[    4.015103] usb 5-1: usb_probe_device
[    4.015109] usb 5-1: configuration #1 chosen from 1 choice
[    4.017566] usb 5-1: adding 5-1:1.0 (config #1, interface 0)
[    4.017909] usb 5-1: adding 5-1:1.1 (config #1, interface 1)
[    4.018153] usb 5-1: adding 5-1:1.2 (config #1, interface 2)
[    4.018363] usb 5-1: adding 5-1:1.3 (config #1, interface 3)
[    4.018755] uhci_hcd 0000:00:1d.3: port 2 portsc 0093,00
[    4.018771] hub 5-0:1.0: port 2, status 0101, change 0001, 12 Mb/s
[    4.144046] hub 5-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x101
[    4.256042] usb 5-2: new full speed USB device using uhci_hcd and address 3
[    4.388040] usb 5-2: ep0 maxpacket = 8
[    4.411530] usb 5-2: default language 0x0409
[    4.430536] usb 5-2: udev 3, busnum 5, minor = 514
[    4.430540] usb 5-2: New USB device found, idVendor=0483, idProduct=2016
[    4.445937] usb 5-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    4.460979] usb 5-2: Product: Biometric Coprocessor
[    4.476073] usb 5-2: Manufacturer: STMicroelectronics
[    4.491456] usb 5-2: usb_probe_device
[    4.491460] usb 5-2: configuration #1 chosen from 1 choice
[    4.493540] usb 5-2: adding 5-2:1.0 (config #1, interface 0)
[    4.494230] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    5.808208] hub 1-0:1.0: hub_suspend
[    5.808297] usb usb1: bus auto-suspend
[    5.808301] ehci_hcd 0000:00:1d.7: suspend root hub
[    5.808417] hub 3-0:1.0: hub_suspend
[    5.808425] usb usb3: bus auto-suspend
[    5.808437] usb usb3: suspend_rh
[    5.808461] hub 4-0:1.0: hub_suspend
[    5.808469] usb usb4: bus auto-suspend
[    5.808472] usb usb4: suspend_rh
[    9.426310] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[    9.679115] input: TPPS/2 IBM TrackPoint as /class/input/input7
[   20.584555] udev: starting version 146
[   20.584557] <3>udev: missing sysfs features; please update the kernel or disable the kernel's CONFIG_SYSFS_DEPRECATED option; udev may fail to work correctly
[   20.616606] udevd (1267): /proc/1267/oom_adj is deprecated, please use /proc/1267/oom_score_adj instead.
[   21.179313] ACPI: acpi_idle registered with cpuidle
[   21.252765] e1000e: Intel(R) PRO/1000 Network Driver - 1.2.7-k2
[   21.277359] ACPI: AC Adapter [AC] (on-line)
[   21.277756] e1000e: Copyright (c) 1999 - 2010 Intel Corporation.
[   21.277816] e1000e 0000:02:00.0: Disabling ASPM  L1
[   21.277844] e1000e 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   21.277862] e1000e 0000:02:00.0: setting latency timer to 64
[   21.278131] e1000e 0000:02:00.0: irq 47 for MSI/MSI-X
[   21.278523] e1000e 0000:02:00.0: Disabling ASPM L0s 
[   21.368477] Monitor-Mwait will be used to enter C-1 state
[   21.372121] Monitor-Mwait will be used to enter C-2 state
[   21.376132] Monitor-Mwait will be used to enter C-3 state
[   21.392885] ACPI: Battery Slot [BAT0] (battery present)
[   21.394781] e1000e 0000:02:00.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:16:41:e3:2c:76
[   21.394785] e1000e 0000:02:00.0: eth0: Intel(R) PRO/1000 Network Connection
[   21.394924] e1000e 0000:02:00.0: eth0: MAC: 2, PHY: 2, PBA No: 005301-003
[   21.463448] thermal LNXTHERM:01: registered as thermal_zone0
[   21.481781] cfg80211: Calling CRDA to update world regulatory domain
[   21.505004] thinkpad_acpi: ThinkPad ACPI Extras v0.24
[   21.506107] ACPI: Thermal Zone [THM0] (59 C)
[   21.507768] thermal LNXTHERM:02: registered as thermal_zone1
[   21.507792] ACPI: Thermal Zone [THM1] (66 C)
[   21.511001] irda_init()
[   21.511111] NET: Registered protocol family 23
[   21.593724] thinkpad_acpi: http://ibm-acpi.sf.net/
[   21.613694] thinkpad_acpi: ThinkPad BIOS 79ETD9WW (2.19 ), EC 79HT50WW-1.07
[   21.634604] Bluetooth: Core ver 2.15
[   21.635518] thinkpad_acpi: Lenovo ThinkPad T60, model 2007FUG
[   21.635521] thinkpad_acpi: WARNING: Outdated ThinkPad BIOS/EC firmware
[   21.635523] thinkpad_acpi: WARNING: This firmware may be missing critical bug fixes and/or important features
[   21.638617] thinkpad_acpi: detected a 8-level brightness capable ThinkPad
[   21.638845] thinkpad_acpi: radio switch found; radios are enabled
[   21.646954] thinkpad_acpi: setting the hotkey mask to 0x00ffffff is likely not the best way to go about it
[   21.646957] thinkpad_acpi: please consider using the driver defaults, and refer to up-to-date thinkpad-acpi documentation
[   21.657172] thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio is unblocked
[   21.659680] Registered led device: tpacpi::thinklight
[   21.660203] Registered led device: tpacpi::power
[   21.660883] Registered led device: tpacpi::standby
[   21.661265] Registered led device: tpacpi::thinkvantage
[   21.664102] thinkpad_acpi: Standard ACPI backlight interface available, not loading native one.
[   21.665786] thinkpad_acpi: Console audio control enabled, mode: monitor (read only)
[   21.672486] input: ThinkPad Extra Buttons as /class/input/input8
[   21.772560] iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux, in-tree:s
[   21.772563] iwl3945: Copyright(c) 2003-2010 Intel Corporation
[   21.772782] iwl3945 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   21.772799] iwl3945 0000:03:00.0: setting latency timer to 64
[   21.826605] iwl3945 0000:03:00.0: Tunable channels: 13 802.11bg, 23 802.11a channels
[   21.826609] iwl3945 0000:03:00.0: Detected Intel Wireless WiFi Link 3945ABG
[   21.826804] iwl3945 0000:03:00.0: irq 48 for MSI/MSI-X
[   21.833238] phy0: Selected rate control algorithm 'iwl-3945-rs'
[   21.847961] nsc-ircc 00:0a: activated
[   21.847966] nsc_ircc_pnp_probe() : From PnP, found firbase 0x2F8 ; irq 3 ; dma 1.
[   21.848339] nsc-ircc, chip->init
[   21.848354] nsc-ircc, Found chip at base=0x164e
[   21.848396] nsc-ircc, driver loaded (Dag Brattli)
[   21.850065] IrDA: Registered device irda0
[   21.850069] nsc-ircc, Using dongle: IBM31T1100 or Temic TFDS6000/TFDS6500
[   22.065402] NET: Registered protocol family 31
[   22.065405] Bluetooth: HCI device and connection manager initialized
[   22.065487] Bluetooth: HCI socket layer initialized
[   22.141593] Bluetooth: Generic Bluetooth USB driver ver 0.6
[   22.141636] btusb 5-1:1.0: usb_probe_interface
[   22.141639] btusb 5-1:1.0: usb_probe_interface - got id
[   22.142165] btusb 5-1:1.2: usb_probe_interface
[   22.142168] btusb 5-1:1.2: usb_probe_interface - got id
[   22.142230] btusb 5-1:1.3: usb_probe_interface
[   22.142232] btusb 5-1:1.3: usb_probe_interface - got id
[   22.142276] usbcore: registered new interface driver btusb
[   22.338837] Adding 1542200k swap on /dev/sda1.  Priority:-1 extents:1 across:1542200k SS
[   22.397499] EXT4-fs (sda5): re-mounted. Opts: acl,user_xattr
[   22.497332] EXT4-fs (sda5): re-mounted. Opts: acl,user_xattr
[   23.289790] EXT3-fs: barriers not enabled
[   23.304152] kjournald starting.  Commit interval 5 seconds
[   23.318151] EXT3-fs (sda2): using internal journal
[   23.332248] EXT3-fs (sda2): mounted filesystem with writeback data mode
[   23.523596] fuse init (API version 7.15)
[   25.220782] [drm] Setting GART location based on new memory map
[   25.221561] [drm] Loading R500 Microcode
[   25.222163] [drm] Num pipes: 1
[   25.222179] [drm] writeback test succeeded in 2 usecs
[   25.604249] uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 8, phase 4, 93 us
[   26.094649] Bluetooth: L2CAP ver 2.15
[   26.094655] Bluetooth: L2CAP socket layer initialized
[   26.147809] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   26.147814] Bluetooth: BNEP filters: protocol multicast
[   26.181860] Bluetooth: SCO (Voice Link) ver 0.6
[   26.181864] Bluetooth: SCO socket layer initialized
[   26.190291] uhci_hcd 0000:00:1d.3: reserve dev 2 ep81-INT, period 1, phase 0, 23 us
[   26.348060] Bluetooth: RFCOMM TTY layer initialized
[   26.348074] Bluetooth: RFCOMM socket layer initialized
[   26.348077] Bluetooth: RFCOMM ver 1.11
[   30.080907] e1000e 0000:02:00.0: irq 47 for MSI/MSI-X
[   30.136263] e1000e 0000:02:00.0: irq 47 for MSI/MSI-X
[   30.153545] iwl3945 0000:03:00.0: loaded firmware version 15.32.2.9
[   32.298941] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Control: RX/TX
[   32.298949] e1000e 0000:02:00.0: eth0: 10/100 speed: disabling TSO
[   33.628610] CPUFREQ: Per core ondemand sysfs interface is deprecated - up_threshold
[   35.234095] RPC: Registered udp transport module.
[   35.234101] RPC: Registered tcp transport module.
[   35.234104] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   41.384898] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=00:16:41:e3:2c:76:00:27:19:16:04:fa:08:00 SRC=213.151.88.130 DST=192.168.28.100 LEN=81 TOS=0x00 PREC=0x00 TTL=54 ID=0 DF PROTO=UDP SPT=1194 DPT=52372 LEN=61 
[   51.614500] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=00:16:41:e3:2c:76:00:27:19:16:04:fa:08:00 SRC=213.151.88.130 DST=192.168.28.100 LEN=81 TOS=0x00 PREC=0x00 TTL=54 ID=0 DF PROTO=UDP SPT=1194 DPT=52372 LEN=61 
[   61.226257] wlan0: deauthenticating from 00:27:19:16:04:fa by local choice (reason=3)
[   61.229462] wlan0: authenticate with 00:27:19:16:04:fa (try 1)
[   61.232450] wlan0: authenticated
[   61.234072] wlan0: associate with 00:27:19:16:04:fa (try 1)
[   61.236955] wlan0: RX AssocResp from 00:27:19:16:04:fa (capab=0x431 status=0 aid=3)
[   61.236962] wlan0: associated
[   61.244315] wlan0: deauthenticated from 00:27:19:16:04:fa (Reason: 7)
[   61.256989] cfg80211: Calling CRDA to update world regulatory domain
[   61.761554] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=00:16:41:e3:2c:76:00:27:19:16:04:fa:08:00 SRC=213.151.88.130 DST=192.168.28.100 LEN=81 TOS=0x00 PREC=0x00 TTL=54 ID=0 DF PROTO=UDP SPT=1194 DPT=52372 LEN=61 
[   63.946342] wlan0: authenticate with 00:27:19:16:04:fa (try 1)
[   63.948231] wlan0: authenticated
[   63.948391] wlan0: associate with 00:27:19:16:04:fa (try 1)
[   63.950846] wlan0: RX AssocResp from 00:27:19:16:04:fa (capab=0x431 status=0 aid=5)
[   63.950853] wlan0: associated
[   71.774631] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=00:16:41:e3:2c:76:00:27:19:16:04:fa:08:00 SRC=213.151.88.130 DST=192.168.28.100 LEN=81 TOS=0x00 PREC=0x00 TTL=54 ID=0 DF PROTO=UDP SPT=1194 DPT=52372 LEN=61 
[   81.854673] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=00:16:41:e3:2c:76:00:27:19:16:04:fa:08:00 SRC=213.151.88.130 DST=192.168.28.100 LEN=81 TOS=0x00 PREC=0x00 TTL=54 ID=0 DF PROTO=UDP SPT=1194 DPT=52372 LEN=61 
[   91.917681] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=00:16:41:e3:2c:76:00:27:19:16:04:fa:08:00 SRC=213.151.88.130 DST=192.168.28.100 LEN=81 TOS=0x00 PREC=0x00 TTL=54 ID=0 DF PROTO=UDP SPT=1194 DPT=52372 LEN=61 
[  101.997769] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=00:16:41:e3:2c:76:00:27:19:16:04:fa:08:00 SRC=213.151.88.130 DST=192.168.28.100 LEN=81 TOS=0x00 PREC=0x00 TTL=54 ID=0 DF PROTO=UDP SPT=1194 DPT=52372 LEN=61 
[  112.027842] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=00:16:41:e3:2c:76:00:27:19:16:04:fa:08:00 SRC=213.151.88.130 DST=192.168.28.100 LEN=81 TOS=0x00 PREC=0x00 TTL=54 ID=0 DF PROTO=UDP SPT=1194 DPT=52372 LEN=61 
[  122.257803] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=00:16:41:e3:2c:76:00:27:19:16:04:fa:08:00 SRC=213.151.88.130 DST=192.168.28.100 LEN=81 TOS=0x00 PREC=0x00 TTL=54 ID=0 DF PROTO=UDP SPT=1194 DPT=52372 LEN=61 
[  132.287885] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=00:16:41:e3:2c:76:00:27:19:16:04:fa:08:00 SRC=213.151.88.130 DST=192.168.28.100 LEN=81 TOS=0x00 PREC=0x00 TTL=54 ID=0 DF PROTO=UDP SPT=1194 DPT=52372 LEN=61 
[  142.400870] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=00:16:41:e3:2c:76:00:27:19:16:04:fa:08:00 SRC=213.151.88.130 DST=192.168.28.100 LEN=81 TOS=0x00 PREC=0x00 TTL=54 ID=0 DF PROTO=UDP SPT=1194 DPT=52372 LEN=61 
[  152.480920] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=00:16:41:e3:2c:76:00:27:19:16:04:fa:08:00 SRC=213.151.88.130 DST=192.168.28.100 LEN=81 TOS=0x00 PREC=0x00 TTL=54 ID=0 DF PROTO=UDP SPT=1194 DPT=52372 LEN=61 
[  173.023815] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=00:16:41:e3:2c:76:00:27:19:16:04:fa:08:00 SRC=213.151.88.130 DST=192.168.28.100 LEN=81 TOS=0x00 PREC=0x00 TTL=54 ID=0 DF PROTO=UDP SPT=1194 DPT=52372 LEN=61 
[  193.566699] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=00:16:41:e3:2c:76:00:27:19:16:04:fa:08:00 SRC=213.151.88.130 DST=192.168.28.100 LEN=81 TOS=0x00 PREC=0x00 TTL=54 ID=0 DF PROTO=UDP SPT=1194 DPT=52372 LEN=61 
[  214.093578] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=00:16:41:e3:2c:76:00:27:19:16:04:fa:08:00 SRC=213.151.88.130 DST=192.168.28.100 LEN=81 TOS=0x00 PREC=0x00 TTL=54 ID=0 DF PROTO=UDP SPT=1194 DPT=52372 LEN=61 
[  234.369630] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=00:16:41:e3:2c:76:00:27:19:16:04:fa:08:00 SRC=213.151.88.130 DST=192.168.28.100 LEN=81 TOS=0x00 PREC=0x00 TTL=54 ID=0 DF PROTO=UDP SPT=1194 DPT=52372 LEN=61 
[  254.713618] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=00:16:41:e3:2c:76:00:27:19:16:04:fa:08:00 SRC=213.151.88.130 DST=192.168.28.100 LEN=81 TOS=0x00 PREC=0x00 TTL=54 ID=0 DF PROTO=UDP SPT=1194 DPT=52372 LEN=61 
[  274.972647] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=00:16:41:e3:2c:76:00:27:19:16:04:fa:08:00 SRC=213.151.88.130 DST=192.168.28.100 LEN=81 TOS=0x00 PREC=0x00 TTL=54 ID=0 DF PROTO=UDP SPT=1194 DPT=52372 LEN=61 
[  294.183288] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=00:16:41:e3:2c:76:00:27:19:16:04:fa:08:00 SRC=213.151.88.130 DST=192.168.28.100 LEN=81 TOS=0x00 PREC=0x00 TTL=54 ID=0 DF PROTO=UDP SPT=1194 DPT=52372 LEN=61 
[  304.096138] EXT4-fs (sda5): error count: 239
[  304.096151] EXT4-fs (sda5): initial error at 1282834433: ext4_readdir:157: inode 212849
[  304.096161] EXT4-fs (sda5): last error at 1282835128: ext4_readdir:157: inode 212907
[  314.443344] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=00:16:41:e3:2c:76:00:27:19:16:04:fa:08:00 SRC=213.151.88.130 DST=192.168.28.100 LEN=81 TOS=0x00 PREC=0x00 TTL=54 ID=0 DF PROTO=UDP SPT=1194 DPT=52372 LEN=61 
[  334.769353] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=00:16:41:e3:2c:76:00:27:19:16:04:fa:08:00 SRC=213.151.88.130 DST=192.168.28.100 LEN=81 TOS=0x00 PREC=0x00 TTL=54 ID=0 DF PROTO=UDP SPT=1194 DPT=52372 LEN=61 
[  355.162305] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=00:16:41:e3:2c:76:00:27:19:16:04:fa:08:00 SRC=213.151.88.130 DST=192.168.28.100 LEN=81 TOS=0x00 PREC=0x00 TTL=54 ID=0 DF PROTO=UDP SPT=1194 DPT=52372 LEN=61 
[  375.280446] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=00:16:41:e3:2c:76:00:27:19:16:04:fa:08:00 SRC=213.151.88.130 DST=192.168.28.100 LEN=81 TOS=0x00 PREC=0x00 TTL=54 ID=0 DF PROTO=UDP SPT=1194 DPT=52372 LEN=61 
[  395.615428] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=00:16:41:e3:2c:76:00:27:19:16:04:fa:08:00 SRC=213.151.88.130 DST=192.168.28.100 LEN=81 TOS=0x00 PREC=0x00 TTL=54 ID=0 DF PROTO=UDP SPT=1194 DPT=52372 LEN=61 
[  415.825477] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=00:16:41:e3:2c:76:00:27:19:16:04:fa:08:00 SRC=213.151.88.130 DST=192.168.28.100 LEN=81 TOS=0x00 PREC=0x00 TTL=54 ID=0 DF PROTO=UDP SPT=1194 DPT=52372 LEN=61 
[  435.202031] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=00:16:41:e3:2c:76:00:27:19:16:04:fa:08:00 SRC=213.151.88.130 DST=192.168.28.100 LEN=81 TOS=0x00 PREC=0x00 TTL=54 ID=0 DF PROTO=UDP SPT=1194 DPT=52372 LEN=61 
[  455.678940] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=00:16:41:e3:2c:76:00:27:19:16:04:fa:08:00 SRC=213.151.88.130 DST=192.168.28.100 LEN=81 TOS=0x00 PREC=0x00 TTL=54 ID=0 DF PROTO=UDP SPT=1194 DPT=52372 LEN=61 
[ 1651.552107] SFW2-OUT-ERROR IN= OUT=eth0 SRC=192.168.28.100 DST=66.220.147.26 LEN=52 TOS=0x00 PREC=0x00 TTL=64 ID=29298 DF PROTO=TCP SPT=56001 DPT=80 WINDOW=63 RES=0x00 ACK FIN URGP=0 OPT (0101080A000527E077965DC1) 
[ 1657.568086] SFW2-OUT-ERROR IN= OUT=eth0 SRC=192.168.28.100 DST=80.249.165.33 LEN=52 TOS=0x00 PREC=0x00 TTL=64 ID=62180 DF PROTO=TCP SPT=40163 DPT=80 WINDOW=91 RES=0x00 ACK FIN URGP=0 OPT (0101080A00052DC0D809F3AE) 
[ 1657.696093] SFW2-OUT-ERROR IN= OUT=eth0 SRC=192.168.28.100 DST=69.63.181.49 LEN=52 TOS=0x00 PREC=0x00 TTL=64 ID=39253 DF PROTO=TCP SPT=37212 DPT=80 WINDOW=137 RES=0x00 ACK FIN URGP=0 OPT (0101080A00052DE0778F2045) 
[ 1666.912123] SFW2-OUT-ERROR IN= OUT=eth0 SRC=192.168.28.100 DST=92.123.68.89 LEN=52 TOS=0x00 PREC=0x00 TTL=64 ID=53492 DF PROTO=TCP SPT=36635 DPT=80 WINDOW=501 RES=0x00 ACK FIN URGP=0 OPT (0101080A000536E010646B5B) 
[ 1666.913253] SFW2-OUT-ERROR IN= OUT=eth0 SRC=192.168.28.100 DST=92.123.68.89 LEN=52 TOS=0x00 PREC=0x00 TTL=64 ID=16011 DF PROTO=TCP SPT=36638 DPT=80 WINDOW=272 RES=0x00 ACK FIN URGP=0 OPT (0101080A000536E010646BAC) 
[ 1674.976060] SFW2-OUT-ERROR IN= OUT=eth0 SRC=192.168.28.100 DST=92.122.217.40 LEN=52 TOS=0x00 PREC=0x00 TTL=64 ID=22867 DF PROTO=TCP SPT=56201 DPT=80 WINDOW=182 RES=0x00 ACK FIN URGP=0 OPT (0101080A00053EC0163B52F3) 
[ 1702.240076] SFW2-OUT-ERROR IN= OUT=eth0 SRC=192.168.28.100 DST=80.249.165.33 LEN=52 TOS=0x00 PREC=0x00 TTL=64 ID=30937 DF PROTO=TCP SPT=40186 DPT=80 WINDOW=137 RES=0x00 ACK FIN URGP=0 OPT (0101080A00055960D80A20BA) 
[ 1716.448080] SFW2-OUT-ERROR IN= OUT=eth0 SRC=192.168.28.100 DST=92.123.68.89 LEN=52 TOS=0x00 PREC=0x00 TTL=64 ID=20694 DF PROTO=TCP SPT=36664 DPT=80 WINDOW=137 RES=0x00 ACK FIN URGP=0 OPT (0101080A00056740106489F9) 
[ 2471.392095] SFW2-OUT-ERROR IN= OUT=eth0 SRC=192.168.28.100 DST=78.46.16.178 LEN=52 TOS=0x00 PREC=0x00 TTL=64 ID=16717 DF PROTO=TCP SPT=35311 DPT=80 WINDOW=182 RES=0x00 ACK FIN URGP=0 OPT (0101080A00084880210467DF) 
[ 2531.424110] SFW2-OUT-ERROR IN= OUT=eth0 SRC=192.168.28.100 DST=78.46.16.178 LEN=52 TOS=0x00 PREC=0x00 TTL=64 ID=58622 DF PROTO=TCP SPT=55494 DPT=80 WINDOW=182 RES=0x00 ACK FIN URGP=0 OPT (0101080A0008832021047F4F) 
[ 4187.104136] SFW2-OUT-ERROR IN= OUT=eth0 SRC=192.168.28.100 DST=78.46.16.178 LEN=52 TOS=0x00 PREC=0x00 TTL=64 ID=20383 DF PROTO=TCP SPT=44196 DPT=80 WINDOW=182 RES=0x00 ACK FIN URGP=0 OPT (0101080A000ED4002106FDD7) 
[ 5321.184104] SFW2-OUT-ERROR IN= OUT=eth0 SRC=192.168.28.100 DST=78.46.16.178 LEN=52 TOS=0x00 PREC=0x00 TTL=64 ID=37211 DF PROTO=TCP SPT=43457 DPT=80 WINDOW=182 RES=0x00 ACK FIN URGP=0 OPT (0101080A001327802108B309) 
[ 9325.664086] SFW2-OUT-ERROR IN= OUT=eth0 SRC=192.168.28.100 DST=91.189.94.12 LEN=52 TOS=0x00 PREC=0x00 TTL=64 ID=31410 DF PROTO=TCP SPT=44621 DPT=80 WINDOW=63 RES=0x00 ACK FIN URGP=0 OPT (0101080A00226E20145E8A5A) 
[ 9325.664153] SFW2-OUT-ERROR IN= OUT=eth0 SRC=192.168.28.100 DST=91.189.94.12 LEN=52 TOS=0x00 PREC=0x00 TTL=64 ID=42686 DF PROTO=TCP SPT=44619 DPT=80 WINDOW=63 RES=0x00 ACK FIN URGP=0 OPT (0101080A00226E20145E8A5A) 
[ 9325.664199] SFW2-OUT-ERROR IN= OUT=eth0 SRC=192.168.28.100 DST=91.189.94.12 LEN=52 TOS=0x00 PREC=0x00 TTL=64 ID=51599 DF PROTO=TCP SPT=44620 DPT=80 WINDOW=145 RES=0x00 ACK FIN URGP=0 OPT (0101080A00226E20145E8A5A) 
[ 9782.752110] SFW2-OUT-ERROR IN= OUT=eth0 SRC=192.168.28.100 DST=76.13.18.79 LEN=40 TOS=0x00 PREC=0x00 TTL=64 ID=19184 DF PROTO=TCP SPT=42559 DPT=80 WINDOW=565 RES=0x00 ACK FIN URGP=0 
[ 9786.848144] SFW2-OUT-ERROR IN= OUT=eth0 SRC=192.168.28.100 DST=76.13.18.79 LEN=40 TOS=0x00 PREC=0x00 TTL=64 ID=23185 DF PROTO=TCP SPT=42560 DPT=80 WINDOW=565 RES=0x00 ACK FIN URGP=0 
[ 9796.064101] SFW2-OUT-ERROR IN= OUT=eth0 SRC=192.168.28.100 DST=76.13.18.78 LEN=40 TOS=0x00 PREC=0x00 TTL=64 ID=62371 DF PROTO=TCP SPT=45784 DPT=80 WINDOW=525 RES=0x00 ACK FIN URGP=0 
[ 9805.280113] SFW2-OUT-ERROR IN= OUT=eth0 SRC=192.168.28.100 DST=76.13.18.77 LEN=40 TOS=0x00 PREC=0x00 TTL=64 ID=28595 DF PROTO=TCP SPT=47167 DPT=80 WINDOW=206 RES=0x00 ACK FIN URGP=0 
[ 9816.800073] SFW2-OUT-ERROR IN= OUT=eth0 SRC=192.168.28.100 DST=76.13.18.79 LEN=40 TOS=0x00 PREC=0x00 TTL=64 ID=12081 DF PROTO=TCP SPT=42581 DPT=80 WINDOW=434 RES=0x00 ACK FIN URGP=0 
[ 9865.568103] SFW2-OUT-ERROR IN= OUT=eth0 SRC=192.168.28.100 DST=66.196.65.174 LEN=52 TOS=0x00 PREC=0x00 TTL=64 ID=44200 DF PROTO=TCP SPT=59036 DPT=80 WINDOW=101 RES=0x00 ACK FIN URGP=0 OPT (0101080A00247D608DB3593F) 
[ 9874.656107] SFW2-OUT-ERROR IN= OUT=eth0 SRC=192.168.28.100 DST=66.196.65.174 LEN=52 TOS=0x00 PREC=0x00 TTL=64 ID=21578 DF PROTO=TCP SPT=59035 DPT=80 WINDOW=565 RES=0x00 ACK FIN URGP=0 OPT (0101080A00248640724BF549) 
[ 9891.168152] SFW2-OUT-ERROR IN= OUT=eth0 SRC=192.168.28.100 DST=76.13.18.79 LEN=40 TOS=0x00 PREC=0x00 TTL=64 ID=12598 DF PROTO=TCP SPT=42630 DPT=80 WINDOW=565 RES=0x00 ACK FIN URGP=0 
[ 9902.816121] SFW2-OUT-ERROR IN= OUT=eth0 SRC=192.168.28.100 DST=69.147.123.63 LEN=40 TOS=0x00 PREC=0x00 TTL=64 ID=44708 DF PROTO=TCP SPT=53299 DPT=80 WINDOW=365 RES=0x00 ACK FIN URGP=0 
[ 9904.864101] SFW2-OUT-ERROR IN= OUT=eth0 SRC=192.168.28.100 DST=76.13.18.77 LEN=40 TOS=0x00 PREC=0x00 TTL=64 ID=51208 DF PROTO=TCP SPT=47246 DPT=80 WINDOW=183 RES=0x00 ACK FIN URGP=0 
[ 9905.888098] SFW2-OUT-ERROR IN= OUT=eth0 SRC=192.168.28.100 DST=76.13.18.79 LEN=40 TOS=0x00 PREC=0x00 TTL=64 ID=48629 DF PROTO=TCP SPT=42658 DPT=80 WINDOW=565 RES=0x00 ACK FIN URGP=0 
[ 9944.544109] SFW2-OUT-ERROR IN= OUT=eth0 SRC=192.168.28.100 DST=69.147.123.63 LEN=40 TOS=0x00 PREC=0x00 TTL=64 ID=32562 DF PROTO=TCP SPT=53355 DPT=80 WINDOW=160 RES=0x00 ACK FIN URGP=0 
[ 9944.544201] SFW2-OUT-ERROR IN= OUT=eth0 SRC=192.168.28.100 DST=69.147.123.63 LEN=40 TOS=0x00 PREC=0x00 TTL=64 ID=31064 DF PROTO=TCP SPT=53357 DPT=80 WINDOW=137 RES=0x00 ACK FIN URGP=0 
[14076.512085] SFW2-OUT-ERROR IN= OUT=eth0 SRC=192.168.28.100 DST=195.111.192.12 LEN=52 TOS=0x00 PREC=0x00 TTL=64 ID=37133 DF PROTO=TCP SPT=43055 DPT=80 WINDOW=54 RES=0x00 ACK FIN URGP=0 OPT (0101080A00348DA01B812E86) 
[24556.438376] 
[24556.438378] =======================================================
[24556.438384] [ INFO: possible circular locking dependency detected ]
[24556.438387] 2.6.36-rc6-00084-gc6ea21e-dirty #99
[24556.438390] -------------------------------------------------------
[24556.438393] sh/19063 is trying to acquire lock:
[24556.438395]  (s_active#121){++++.+}, at: [<ffffffff8111f29a>] sysfs_addrm_finish+0x31/0x5a
[24556.438407] 
[24556.438408] but task is already holding lock:
[24556.438410]  (dbs_mutex){+.+.+.}, at: [<ffffffff8138642d>] cpufreq_governor_dbs+0x37c/0x427
[24556.438420] 
[24556.438421] which lock already depends on the new lock.
[24556.438422] 
[24556.438424] 
[24556.438425] the existing dependency chain (in reverse order) is:
[24556.438427] 
[24556.438428] -> #2 (dbs_mutex){+.+.+.}:
[24556.438433]        [<ffffffff81068d6b>] __lock_acquire+0x889/0x8fa
[24556.438440]        [<ffffffff81068ecb>] lock_acquire+0xef/0x115
[24556.438445]        [<ffffffff8144a677>] mutex_lock_nested+0x4b/0x2e6
[24556.438451]        [<ffffffff81386127>] cpufreq_governor_dbs+0x76/0x427
[24556.438456]        [<ffffffff81382e16>] __cpufreq_governor+0x10b/0x14c
[24556.438461]        [<ffffffff81382f5b>] __cpufreq_set_policy+0x104/0x142
[24556.438465]        [<ffffffff81384a51>] store_scaling_governor+0x190/0x1ca
[24556.438470]        [<ffffffff81383f4f>] store+0x56/0x79
[24556.438474]        [<ffffffff8111dc22>] sysfs_write_file+0x103/0x13f
[24556.438480]        [<ffffffff810ccfe6>] vfs_write+0xae/0x136
[24556.438487]        [<ffffffff810cd127>] sys_write+0x45/0x6c
[24556.438491]        [<ffffffff8100202b>] system_call_fastpath+0x16/0x1b
[24556.438497] 
[24556.438498] -> #1 (&per_cpu(cpu_policy_rwsem, cpu)){+++++.}:
[24556.438503]        [<ffffffff81068d6b>] __lock_acquire+0x889/0x8fa
[24556.438508]        [<ffffffff81068ecb>] lock_acquire+0xef/0x115
[24556.438512]        [<ffffffff8144ab7f>] down_write+0x2c/0x4f
[24556.438517]        [<ffffffff81382c80>] lock_policy_rwsem_write+0x4a/0x7a
[24556.438522]        [<ffffffff81383f32>] store+0x39/0x79
[24556.438526]        [<ffffffff8111dc22>] sysfs_write_file+0x103/0x13f
[24556.438531]        [<ffffffff810ccfe6>] vfs_write+0xae/0x136
[24556.438536]        [<ffffffff810cd127>] sys_write+0x45/0x6c
[24556.438540]        [<ffffffff8100202b>] system_call_fastpath+0x16/0x1b
[24556.438545] 
[24556.438546] -> #0 (s_active#121){++++.+}:
[24556.438552]        [<ffffffff81067ee6>] validate_chain+0x727/0xd23
[24556.438557]        [<ffffffff81068d6b>] __lock_acquire+0x889/0x8fa
[24556.438561]        [<ffffffff81068ecb>] lock_acquire+0xef/0x115
[24556.438566]        [<ffffffff8111e87e>] sysfs_deactivate+0x8e/0xcb
[24556.438571]        [<ffffffff8111f29a>] sysfs_addrm_finish+0x31/0x5a
[24556.438575]        [<ffffffff8111d236>] sysfs_hash_and_remove+0x54/0x78
[24556.438580]        [<ffffffff8112074c>] sysfs_remove_group+0x90/0xc9
[24556.438584]        [<ffffffff81386441>] cpufreq_governor_dbs+0x390/0x427
[24556.438589]        [<ffffffff81382e16>] __cpufreq_governor+0x10b/0x14c
[24556.438594]        [<ffffffff81382f45>] __cpufreq_set_policy+0xee/0x142
[24556.438599]        [<ffffffff81384a51>] store_scaling_governor+0x190/0x1ca
[24556.438604]        [<ffffffff81383f4f>] store+0x56/0x79
[24556.438608]        [<ffffffff8111dc22>] sysfs_write_file+0x103/0x13f
[24556.438613]        [<ffffffff810ccfe6>] vfs_write+0xae/0x136
[24556.438617]        [<ffffffff810cd127>] sys_write+0x45/0x6c
[24556.438622]        [<ffffffff8100202b>] system_call_fastpath+0x16/0x1b
[24556.438627] 
[24556.438628] other info that might help us debug this:
[24556.438629] 
[24556.438632] 4 locks held by sh/19063:
[24556.438634]  #0:  (&buffer->mutex){+.+.+.}, at: [<ffffffff8111db56>] sysfs_write_file+0x37/0x13f
[24556.438642]  #1:  (s_active#120){.+.+.+}, at: [<ffffffff8111dc01>] sysfs_write_file+0xe2/0x13f
[24556.438651]  #2:  (&per_cpu(cpu_policy_rwsem, cpu)){+++++.}, at: [<ffffffff81382c80>] lock_policy_rwsem_write+0x4a/0x7a
[24556.438659]  #3:  (dbs_mutex){+.+.+.}, at: [<ffffffff8138642d>] cpufreq_governor_dbs+0x37c/0x427
[24556.438667] 
[24556.438667] stack backtrace:
[24556.438671] Pid: 19063, comm: sh Not tainted 2.6.36-rc6-00084-gc6ea21e-dirty #99
[24556.438674] Call Trace:
[24556.438679]  [<ffffffff810670c3>] print_circular_bug+0xae/0xbd
[24556.438684]  [<ffffffff81067ee6>] validate_chain+0x727/0xd23
[24556.438689]  [<ffffffff81068d6b>] __lock_acquire+0x889/0x8fa
[24556.438694]  [<ffffffff81066798>] ? mark_held_locks+0x52/0x70
[24556.438699]  [<ffffffff81065450>] ? lockdep_init_map+0x9b/0x4fb
[24556.438703]  [<ffffffff8111f29a>] ? sysfs_addrm_finish+0x31/0x5a
[24556.438707]  [<ffffffff81068ecb>] lock_acquire+0xef/0x115
[24556.438711]  [<ffffffff8111f29a>] ? sysfs_addrm_finish+0x31/0x5a
[24556.438716]  [<ffffffff8111e87e>] sysfs_deactivate+0x8e/0xcb
[24556.438720]  [<ffffffff8111f29a>] ? sysfs_addrm_finish+0x31/0x5a
[24556.438725]  [<ffffffff8111f29a>] sysfs_addrm_finish+0x31/0x5a
[24556.438730]  [<ffffffff8111d236>] sysfs_hash_and_remove+0x54/0x78
[24556.438734]  [<ffffffff8112074c>] sysfs_remove_group+0x90/0xc9
[24556.438739]  [<ffffffff81386441>] cpufreq_governor_dbs+0x390/0x427
[24556.438744]  [<ffffffff81382e16>] __cpufreq_governor+0x10b/0x14c
[24556.438749]  [<ffffffff81382f45>] __cpufreq_set_policy+0xee/0x142
[24556.438754]  [<ffffffff81384a51>] store_scaling_governor+0x190/0x1ca
[24556.438758]  [<ffffffff81384874>] ? handle_update+0x0/0xe
[24556.438763]  [<ffffffff81383f4f>] store+0x56/0x79
[24556.438768]  [<ffffffff8111dc22>] sysfs_write_file+0x103/0x13f
[24556.438773]  [<ffffffff810ccfe6>] vfs_write+0xae/0x136
[24556.438777]  [<ffffffff810cd127>] sys_write+0x45/0x6c
[24556.438782]  [<ffffffff8100202b>] system_call_fastpath+0x16/0x1b
[24556.659027] [drm] Num pipes: 1
[24556.699853] wlan0: deauthenticating from 00:27:19:16:04:fa by local choice (reason=3)
[24556.712097] cfg80211: Calling CRDA to update world regulatory domain
[24556.749422] uhci_hcd 0000:00:1d.0: release dev 2 ep81-INT, period 8, phase 4, 93 us
[24556.803392] PM: Syncing filesystems ... done.
[24556.858170] Freezing user space processes ... (elapsed 0.01 seconds) done.
[24556.872115] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[24556.888111] Suspending console(s) (use no_console_suspend to debug)
[24556.928402] usb 5-2: usb suspend
[24556.929620] btusb_intr_complete: hci0 urb ffff8800b8f0ce00 failed to resubmit (1)
[24556.929626] uhci_hcd 0000:00:1d.3: release dev 2 ep81-INT, period 1, phase 0, 23 us
[24556.930622] btusb_bulk_complete: hci0 urb ffff8800b8f0ca40 failed to resubmit (1)
[24556.931621] btusb_bulk_complete: hci0 urb ffff8800b8f0c980 failed to resubmit (1)
[24556.931641] usb 5-1: usb suspend
[24557.083914] usb 2-2: usb suspend
[24557.083954] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[24557.084103] sd 0:0:0:0: [sda] Stopping disk
[24557.130236] hub 5-0:1.0: hub_suspend
[24557.130242] usb usb5: bus suspend
[24557.130245] usb usb5: suspend_rh
[24557.130289] hub 2-0:1.0: hub_suspend
[24557.130294] usb usb2: bus suspend
[24557.130296] usb usb2: suspend_rh
[24557.131578] nsc-ircc 00:0a: disabled
[24557.132114] pci 0000:01:00.0: PCI INT A disabled
[24557.132208] PIIX_IDE 0000:00:1f.1: PCI INT C disabled
[24557.132277] ehci_hcd 0000:00:1d.7: PCI INT D disabled
[24557.132283] uhci_hcd 0000:00:1d.3: uhci_pci_suspend
[24557.132297] uhci_hcd 0000:00:1d.3: PCI INT D disabled
[24557.132303] uhci_hcd 0000:00:1d.2: uhci_pci_suspend
[24557.132319] uhci_hcd 0000:00:1d.2: PCI INT C disabled
[24557.132326] uhci_hcd 0000:00:1d.1: uhci_pci_suspend
[24557.132341] uhci_hcd 0000:00:1d.1: PCI INT B disabled
[24557.132346] uhci_hcd 0000:00:1d.0: uhci_pci_suspend
[24557.132363] uhci_hcd 0000:00:1d.0: PCI INT A disabled
[24557.132374] e1000e 0000:02:00.0: PCI INT A disabled
[24557.132386] e1000e 0000:02:00.0: PME# enabled
[24557.132398] pcieport 0000:00:1c.0: wake-up capability enabled by ACPI
[24557.236106] HDA Intel 0000:00:1b.0: PCI INT B disabled
[24557.392044] PM: suspend of devices complete after 502.423 msecs
[24557.392520] ehci_hcd 0000:00:1d.7: wakeup: 0
[24557.436028] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D3
[24557.436033] ehci_hcd 0000:00:1d.7: --> PCI D3hot
[24557.436065] uhci_hcd 0000:00:1d.3: wakeup: 0
[24557.436069] uhci_hcd 0000:00:1d.3: --> PCI D0
[24557.436101] uhci_hcd 0000:00:1d.2: wakeup: 0
[24557.460040] uhci_hcd 0000:00:1d.2: power state changed by ACPI to D3
[24557.460042] uhci_hcd 0000:00:1d.2: --> PCI D3hot
[24557.460074] uhci_hcd 0000:00:1d.1: wakeup: 0
[24557.460078] uhci_hcd 0000:00:1d.1: --> PCI D0
[24557.460109] uhci_hcd 0000:00:1d.0: wakeup: 0
[24557.484039] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D3
[24557.484042] uhci_hcd 0000:00:1d.0: --> PCI D3hot
[24557.484070] PM: late suspend of devices complete after 92.021 msecs
[24557.484321] ACPI: Preparing to enter system sleep state S3
[24557.644056] PM: Saving platform NVS memory
[24557.644059] Disabling non-boot CPUs ...
[24557.796032] CPU 1 is now offline
[24557.796034] lockdep: fixing up alternatives.
[24557.796038] SMP alternatives: switching to UP code
[24557.802701] Extended CMOS year: 2000
[24557.802701] Back to C!
[24557.802701] PM: Restoring platform NVS memory
[24557.802701] Extended CMOS year: 2000
[24557.802701] Enabling non-boot CPUs ...
[24557.804046] lockdep: fixing up alternatives.
[24557.804049] SMP alternatives: switching to SMP code
[24557.809957] Booting Node 0 Processor 1 APIC 0x1
[24557.972035] CPU1 is up
[24557.972393] ACPI: Waking up from system sleep state S3
[24558.324115] pcieport 0000:00:01.0: restoring config space at offset 0x1 (was 0x100107, writing 0x100507)
[24558.324183] HDA Intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100106, writing 0x100102)
[24558.324232] pcieport 0000:00:1c.0: restoring config space at offset 0x9 (was 0x1fff1, writing 0xc011c001)
[24558.324251] pcieport 0000:00:1c.0: restoring config space at offset 0x1 (was 0x100107, writing 0x100507)
[24558.324331] pcieport 0000:00:1c.1: restoring config space at offset 0x1 (was 0x100107, writing 0x100507)
[24558.324402] pcieport 0000:00:1c.2: restoring config space at offset 0x7 (was 0x20007060, writing 0x7060)
[24558.324417] pcieport 0000:00:1c.2: restoring config space at offset 0x1 (was 0x100107, writing 0x100507)
[24558.324473] pcieport 0000:00:1c.3: restoring config space at offset 0xf (was 0x40400, writing 0x4040b)
[24558.324489] pcieport 0000:00:1c.3: restoring config space at offset 0x9 (was 0x10001, writing 0xe421e421)
[24558.324495] pcieport 0000:00:1c.3: restoring config space at offset 0x8 (was 0x0, writing 0xebf0ea00)
[24558.324502] pcieport 0000:00:1c.3: restoring config space at offset 0x7 (was 0x20000000, writing 0x9080)
[24558.324513] pcieport 0000:00:1c.3: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
[24558.324522] pcieport 0000:00:1c.3: restoring config space at offset 0x1 (was 0x100000, writing 0x100507)
[24558.368027] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[24558.376039] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[24558.376071] uhci_hcd 0000:00:1d.0: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
[24558.384038] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[24558.392038] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[24558.392071] uhci_hcd 0000:00:1d.1: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
[24558.400038] uhci_hcd 0000:00:1d.2: power state changed by ACPI to D0
[24558.408038] uhci_hcd 0000:00:1d.2: power state changed by ACPI to D0
[24558.408069] uhci_hcd 0000:00:1d.2: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
[24558.416038] uhci_hcd 0000:00:1d.2: power state changed by ACPI to D0
[24558.424038] uhci_hcd 0000:00:1d.2: power state changed by ACPI to D0
[24558.424072] uhci_hcd 0000:00:1d.3: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
[24558.424120] ehci_hcd 0000:00:1d.7: restoring config space at offset 0x1 (was 0x2900106, writing 0x2900102)
[24558.432038] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[24558.440038] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[24558.440079] pci 0000:00:1e.0: restoring config space at offset 0x1 (was 0x100005, writing 0x100007)
[24558.440218] ahci 0000:00:1f.2: restoring config space at offset 0x1 (was 0x2b00007, writing 0x2b00407)
[24558.440832] iwl3945 0000:03:00.0: restoring config space at offset 0x1 (was 0x100106, writing 0x100506)
[24558.440963] pci 0000:15:00.0: restoring config space at offset 0xf (was 0x34001ff, writing 0x3c0010b)
[24558.440971] pci 0000:15:00.0: restoring config space at offset 0xe (was 0x0, writing 0xa4fc)
[24558.440978] pci 0000:15:00.0: restoring config space at offset 0xd (was 0x0, writing 0xa400)
[24558.440986] pci 0000:15:00.0: restoring config space at offset 0xc (was 0x0, writing 0xa0fc)
[24558.440993] pci 0000:15:00.0: restoring config space at offset 0xb (was 0x0, writing 0xa000)
[24558.441001] pci 0000:15:00.0: restoring config space at offset 0xa (was 0x0, writing 0xc7fff000)
[24558.441009] pci 0000:15:00.0: restoring config space at offset 0x9 (was 0x0, writing 0xc4000000)
[24558.441016] pci 0000:15:00.0: restoring config space at offset 0x8 (was 0x0, writing 0xe3fff000)
[24558.441024] pci 0000:15:00.0: restoring config space at offset 0x7 (was 0x0, writing 0xe0000000)
[24558.441031] pci 0000:15:00.0: restoring config space at offset 0x6 (was 0x0, writing 0xb0171615)
[24558.441041] pci 0000:15:00.0: restoring config space at offset 0x4 (was 0x0, writing 0xe4300000)
[24558.441049] pci 0000:15:00.0: restoring config space at offset 0x3 (was 0x20000, writing 0x2a808)
[24558.441059] pci 0000:15:00.0: restoring config space at offset 0x1 (was 0x2100000, writing 0x2100007)
[24558.441170] PM: early resume of devices complete after 117.123 msecs
[24558.441273] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[24558.441286] HDA Intel 0000:00:1b.0: setting latency timer to 64
[24558.441357] HDA Intel 0000:00:1b.0: irq 46 for MSI/MSI-X
[24558.441458] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[24558.441466] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[24558.441471] uhci_hcd 0000:00:1d.1: uhci_pci_resume
[24558.441476] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: legsup = 0x2f00
[24558.441479] uhci_hcd 0000:00:1d.1: Performing full reset
[24558.441485] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[24558.441504] usb usb3: root hub lost power or was reset
[24558.441534] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[24558.441548] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[24558.441554] uhci_hcd 0000:00:1d.3: uhci_pci_resume
[24558.441559] uhci_hcd 0000:00:1d.3: uhci_check_and_reset_hc: legsup = 0x2000
[24558.441562] uhci_hcd 0000:00:1d.3: Performing full reset
[24558.441597] usb usb5: root hub lost power or was reset
[24558.441634] pci 0000:00:1e.0: setting latency timer to 64
[24558.441651] PIIX_IDE 0000:00:1f.1: PCI INT C -> GSI 16 (level, low) -> IRQ 16
[24558.441657] PIIX_IDE 0000:00:1f.1: setting latency timer to 64
[24558.441696] ahci 0000:00:1f.2: setting latency timer to 64
[24558.441733] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[24558.441739] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[24558.441751] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[24558.441755] uhci_hcd 0000:00:1d.0: uhci_pci_resume
[24558.441760] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: legsup = 0x2000
[24558.441762] uhci_hcd 0000:00:1d.0: Performing full reset
[24558.441778] pcieport 0000:00:1c.0: wake-up capability disabled by ACPI
[24558.441791] e1000e 0000:02:00.0: PME# disabled
[24558.441792] usb usb2: root hub lost power or was reset
[24558.442002] e1000e 0000:02:00.0: Disabling ASPM  L1
[24558.442004] pci 0000:15:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[24558.442067] pci 0000:01:00.0: power state changed by ACPI to D0
[24558.442085] pci 0000:01:00.0: power state changed by ACPI to D0
[24558.442092] e1000e 0000:02:00.0: irq 47 for MSI/MSI-X
[24558.442111] pci 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[24558.442132] pci 0000:01:00.0: setting latency timer to 64
[24558.442215] usb usb2: usb resume
[24558.442218] usb usb2: wakeup_rh
[24558.442234] usb usb3: usb resume
[24558.442236] usb usb3: wakeup_rh
[24558.442310] usb usb5: usb resume
[24558.442312] usb usb5: wakeup_rh
[24558.442375] sd 0:0:0:0: [sda] Starting disk
[24558.443020] uhci_hcd 0000:00:1d.2: power state changed by ACPI to D0
[24558.443184] uhci_hcd 0000:00:1d.2: power state changed by ACPI to D0
[24558.443191] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[24558.443199] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[24558.443204] uhci_hcd 0000:00:1d.2: uhci_pci_resume
[24558.443208] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: legsup = 0x2000
[24558.443211] uhci_hcd 0000:00:1d.2: Performing full reset
[24558.443248] usb usb4: root hub lost power or was reset
[24558.443264] usb usb4: usb resume
[24558.443266] usb usb4: wakeup_rh
[24558.445408] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[24558.445674] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[24558.445688] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[24558.445745] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[24558.445836] usb usb1: usb resume
[24558.445847] ehci_hcd 0000:00:1d.7: resume root hub
[24558.456076] hub 2-0:1.0: hub_reset_resume
[24558.456082] hub 2-0:1.0: trying to enable port power on non-switchable hub
[24558.456105] hub 3-0:1.0: hub_reset_resume
[24558.456110] hub 3-0:1.0: trying to enable port power on non-switchable hub
[24558.456126] hub 5-0:1.0: hub_reset_resume
[24558.456131] hub 5-0:1.0: trying to enable port power on non-switchable hub
[24558.456148] hub 4-0:1.0: hub_reset_resume
[24558.456152] hub 4-0:1.0: trying to enable port power on non-switchable hub
[24558.463541] nsc-ircc 00:0a: activated
[24558.467693] hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
[24558.467943] hda: UDMA/33 mode selected
[24558.480120] ehci_hcd 0000:00:1d.7: port 2 low speed --> companion
[24558.560113] uhci_hcd 0000:00:1d.3: port 1 portsc 008a,00
[24558.560119] hub 5-0:1.0: port 1: status 0100 change 0003
[24558.560137] uhci_hcd 0000:00:1d.3: port 2 portsc 008a,00
[24558.560142] hub 5-0:1.0: port 2: status 0100 change 0003
[24558.560174] uhci_hcd 0000:00:1d.0: port 2 portsc 01ab,00
[24558.560179] hub 2-0:1.0: port 2: status 0301 change 0003
[24558.576255] ehci_hcd 0000:00:1d.7: port 8 full speed --> companion
[24558.576261] ehci_hcd 0000:00:1d.7: GetStatus port:8 status 003801 0  ACK POWER OWNER sig=j CONNECT
[24558.576504] ehci_hcd 0000:00:1d.7: port 7 full speed --> companion
[24558.576508] ehci_hcd 0000:00:1d.7: GetStatus port:7 status 003801 0  ACK POWER OWNER sig=j CONNECT
[24558.576517] ehci_hcd 0000:00:1d.7: GetStatus port:2 status 003002 0  ACK POWER OWNER sig=se0 CSC
[24558.592081] hub 1-0:1.0: hub_resume
[24558.592114] ehci_hcd 0000:00:1d.7: GetStatus port:7 status 003002 0  ACK POWER OWNER sig=se0 CSC
[24558.592128] ehci_hcd 0000:00:1d.7: GetStatus port:8 status 003002 0  ACK POWER OWNER sig=se0 CSC
[24558.696101] uhci_hcd 0000:00:1d.3: port 1 portsc 0093,00
[24558.696111] usb 2-2: finish reset-resume
[24558.696115] usb 5-1: finish reset-resume
[24558.696128] uhci_hcd 0000:00:1d.3: port 2 portsc 0093,00
[24558.696137] usb 5-2: finish reset-resume
[24558.760086] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[24558.760599] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[24558.760603] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[24558.760607] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[24558.762131] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[24558.762135] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[24558.762139] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[24558.762498] ata1.00: configured for UDMA/133
[24558.776974] ata1.00: configured for UDMA/133
[24558.776978] ata1: EH complete
[24558.956062] usb 2-2: reset low speed USB device using uhci_hcd and address 2
[24559.356087] usb 5-1: reset full speed USB device using uhci_hcd and address 2
[24559.502349] btusb 5-1:1.0: no reset_resume for driver btusb?
[24559.502353] btusb 5-1:1.1: no reset_resume for driver btusb?
[24559.502356] btusb 5-1:1.0: forced unbind
[24559.592086] usb usb3: suspend_rh (auto-stop)
[24559.592111] usb usb4: suspend_rh (auto-stop)
[24559.600086] usb 5-2: reset full speed USB device using uhci_hcd and address 3
[24559.732050] usb 5-2: ep0 maxpacket = 8
[24559.754571] PM: resume of devices complete after 1313.353 msecs
[24559.754659] btusb 5-1:1.0: usb_probe_interface
[24559.754662] btusb 5-1:1.0: usb_probe_interface - got id
[24559.757895] Restarting tasks ... 
[24559.757938] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
[24559.757956] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
[24559.757969] hub 2-0:1.0: state 7 ports 2 chg 0004 evt 0000
[24559.757990] hub 2-0:1.0: port 2, status 0303, change 0000, 1.5 Mb/s
[24559.758001] hub 5-0:1.0: state 7 ports 2 chg 0006 evt 0006
[24559.758017] hub 5-0:1.0: port 1, status 0103, change 0000, 12 Mb/s
[24559.758033] hub 5-0:1.0: port 2, status 0103, change 0000, 12 Mb/s
[24559.758043] hub 1-0:1.0: state 7 ports 8 chg 0000 evt 0000
[24559.784334] uhci_hcd 0000:00:1d.3: reserve dev 2 ep81-INT, period 1, phase 0, 23 us
[24559.787809] done.
[24559.787823] video LNXVIDEO:01: Restoring backlight state
[24559.862350] [drm] Num pipes: 1
[24560.085624] uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 8, phase 4, 93 us
[24560.496478] e1000e 0000:02:00.0: irq 47 for MSI/MSI-X
[24560.552211] e1000e 0000:02:00.0: irq 47 for MSI/MSI-X
[24561.824104] hub 4-0:1.0: hub_suspend
[24561.824121] usb usb4: bus auto-suspend
[24561.824127] usb usb4: suspend_rh
[24561.824155] hub 3-0:1.0: hub_suspend
[24561.824165] usb usb3: bus auto-suspend
[24561.824170] usb usb3: suspend_rh
[24561.824194] hub 1-0:1.0: hub_suspend
[24561.824204] usb usb1: bus auto-suspend
[24561.824209] ehci_hcd 0000:00:1d.7: suspend root hub
[24562.158720] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Control: RX/TX
[24562.158732] e1000e 0000:02:00.0: eth0: 10/100 speed: disabling TSO
[24570.870068] wlan0: deauthenticating from 00:27:19:16:04:fa by local choice (reason=3)
[24570.883288] wlan0: authenticate with 00:27:19:16:04:fa (try 1)
[24570.885197] wlan0: authenticated
[24570.885266] wlan0: associate with 00:27:19:16:04:fa (try 1)
[24570.887675] wlan0: RX AssocResp from 00:27:19:16:04:fa (capab=0x431 status=0 aid=4)
[24570.887682] wlan0: associated
[24633.952084] SFW2-OUT-ERROR IN= OUT=eth0 SRC=192.168.28.100 DST=88.209.222.127 LEN=196 TOS=0x10 PREC=0x00 TTL=64 ID=23342 DF PROTO=TCP SPT=52499 DPT=22 WINDOW=501 RES=0x00 ACK PSH FIN URGP=0 OPT (0101080A005CD3A0017F775F) 
[24636.640084] SFW2-OUT-ERROR IN= OUT=eth0 SRC=192.168.28.100 DST=74.125.43.105 LEN=52 TOS=0x00 PREC=0x00 TTL=64 ID=64533 DF PROTO=TCP SPT=54502 DPT=80 WINDOW=203 RES=0x00 ACK PSH FIN URGP=0 OPT (0101080A005CD640A326EB96) 
[24636.768080] SFW2-OUT-ERROR IN= OUT=eth0 SRC=192.168.28.100 DST=195.135.221.39 LEN=89 TOS=0x00 PREC=0x00 TTL=64 ID=20778 DF PROTO=TCP SPT=36890 DPT=993 WINDOW=4560 RES=0x00 ACK PSH FIN URGP=0 OPT (0101080A005CD66012B71780) 
[24637.856087] SFW2-OUT-ERROR IN= OUT=eth0 SRC=192.168.28.100 DST=74.125.43.138 LEN=52 TOS=0x00 PREC=0x00 TTL=64 ID=60716 DF PROTO=TCP SPT=58428 DPT=80 WINDOW=54 RES=0x00 ACK PSH FIN URGP=0 OPT (0101080A005CD770F2904CF1) 
[24637.856175] SFW2-OUT-ERROR IN= OUT=eth0 SRC=192.168.28.100 DST=92.122.212.24 LEN=52 TOS=0x00 PREC=0x00 TTL=64 ID=49726 DF PROTO=TCP SPT=46810 DPT=80 WINDOW=54 RES=0x00 ACK PSH FIN URGP=0 OPT (0101080A005CD7701CC60B9A) 
[24671.584087] SFW2-OUT-ERROR IN= OUT=eth0 SRC=192.168.28.100 DST=216.34.181.45 LEN=52 TOS=0x00 PREC=0x00 TTL=64 ID=47646 DF PROTO=TCP SPT=41016 DPT=80 WINDOW=524 RES=0x00 ACK PSH FIN URGP=0 OPT (0101080A005CF86078EF0CB3) 
[30470.008057] CE: hpet increased min_delta_ns to 7500 nsec
[31534.592070] CE: hpet increased min_delta_ns to 11250 nsec
[32085.088181] SFW2-OUT-ERROR IN= OUT=eth0 SRC=192.168.28.100 DST=199.6.1.166 LEN=52 TOS=0x00 PREC=0x00 TTL=64 ID=17838 DF PROTO=TCP SPT=49116 DPT=80 WINDOW=54 RES=0x00 ACK FIN URGP=0 OPT (0101080A00794020AAD173F9) 
[32086.112141] SFW2-OUT-ERROR IN= OUT=eth0 SRC=192.168.28.100 DST=199.6.1.166 LEN=52 TOS=0x00 PREC=0x00 TTL=64 ID=41980 DF PROTO=TCP SPT=49115 DPT=80 WINDOW=501 RES=0x00 ACK FIN URGP=0 OPT (0101080A00794120AAD173F1) 

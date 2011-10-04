Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933765Ab1JDW46 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 18:56:58 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38788 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933158Ab1JDW4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 18:56:54 -0400
From: Julie Sullivan <kernelmail.jms@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: BUG: scheduling while atomic: swapper/0/0x10000002 - spew of 44-odd in all 3.1-rc*
Date: Tue, 4 Oct 2011 23:43:11 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc8; KDE/4.6.2; x86_64; ; )
References: <201110042337.39611.kernelmail.jms@gmail.com>
In-Reply-To: <201110042337.39611.kernelmail.jms@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201110042343.11950.kernelmail.jms@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.1.0-rc8 (julie@julie-MXG071) (gcc version 4.5.2 (Ubuntu/Linaro 4.5.2-8ubuntu4) ) #99 SMP Wed Sep 28 20:32:04 BST 2011
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-3.1.0-rc8 root=/dev/sda3 ro quiet splash vt.handoff=7
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
[    0.000000]  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bfe72000 (usable)
[    0.000000]  BIOS-e820: 00000000bfe72000 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000f8000000 - 00000000fc000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed18000 - 00000000fed1c000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed20000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000feda0000 - 00000000feda6000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000140000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] DMI: Dell Inc. MXG071                          /0KX412, BIOS A10 12/16/2008
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x140000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 080000000 mask FC0000000 write-back
[    0.000000]   2 base 100000000 mask FC0000000 write-back
[    0.000000]   3 base 0BFF00000 mask FFFF00000 uncachable
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled                                                                                                                                                
[    0.000000]   7 disabled                                                                                                                                                
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106                                                                                            
[    0.000000] e820 update range: 00000000bff00000 - 0000000100000000 (usable) ==> (reserved)                                                                              
[    0.000000] last_pfn = 0xbfe72 max_arch_pfn = 0x400000000                                                                                                               
[    0.000000] initial memory mapped : 0 - 20000000                                                                                                                        
[    0.000000] Base memory trampoline at [ffff88000009a000] 9a000 size 20480                                                                                               
[    0.000000] init_memory_mapping: 0000000000000000-00000000bfe72000
[    0.000000]  0000000000 - 00bfe00000 page 2M
[    0.000000]  00bfe00000 - 00bfe72000 page 4k
[    0.000000] kernel direct mapping tables up to bfe72000 @ bfe6d000-bfe72000
[    0.000000] init_memory_mapping: 0000000100000000-0000000140000000
[    0.000000]  0100000000 - 0140000000 page 2M
[    0.000000] kernel direct mapping tables up to 140000000 @ 13fffa000-140000000
[    0.000000] ACPI: RSDP 00000000000fb8d0 00024 (v02 DELL  )
[    0.000000] ACPI: XSDT 00000000bfe73a00 00064 (v01 DELL    M08     27D80C10 ASL  00000061)
[    0.000000] ACPI: FACP 00000000bfe7389c 000F4 (v04 DELL    M08     27D80C10 ASL  00000061)
[    0.000000] ACPI: DSDT 00000000bfe74000 04BD0 (v02 INT430 SYSFexxx 00001001 INTL 20050624)
[    0.000000] ACPI: FACS 00000000bfe82800 00040
[    0.000000] ACPI: HPET 00000000bfe73b00 00038 (v01 DELL    M08     00000001 ASL  00000061)
[    0.000000] ACPI: APIC 00000000bfe73c00 00068 (v01 DELL    M08     27D80C10 ASL  00000047)
[    0.000000] ACPI: MCFG 00000000bfe73bc0 0003E (v16 DELL    M08     27D80C10 ASL  00000061)
[    0.000000] ACPI: OSFR 00000000bfe73200 0002C (v01 DELL    M08     27D80C10 ASL  00000061)
[    0.000000] ACPI: SLIC 00000000bfe73c9c 00176 (v01 DELL    M08     27D80C10 ASL  00000061)
[    0.000000] ACPI: BOOT 00000000bfe737c0 00028 (v01 DELL    M08     27D80C10 ASL  00000061)
[    0.000000] ACPI: SSDT 00000000bfe7217e 004CC (v01  PmRef    CpuPm 00003000 INTL 20050624)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-0000000140000000
[    0.000000] Initmem setup node 0 0000000000000000-0000000140000000
[    0.000000]   NODE_DATA [000000013fffb000 - 000000013fffffff]
[    0.000000]  [ffffea0000000000-ffffea0004ffffff] PMD -> [ffff88013b600000-ffff88013f5fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00140000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000bfe72
[    0.000000]     0: 0x00100000 -> 0x00140000
[    0.000000] On node 0 totalpages: 1048065
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 5 pages reserved
[    0.000000]   DMA zone: 3914 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 16320 pages used for memmap
[    0.000000]   DMA32 zone: 765618 pages, LIFO batch:31
[    0.000000]   Normal zone: 4096 pages used for memmap
[    0.000000]   Normal zone: 258048 pages, LIFO batch:31
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
[    0.000000] PM: Registered nosave memory: 00000000bfe72000 - 00000000c0000000
[    0.000000] PM: Registered nosave memory: 00000000c0000000 - 00000000f8000000
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
[    0.000000] PM: Registered nosave memory: 00000000fee10000 - 00000000ffe00000
[    0.000000] PM: Registered nosave memory: 00000000ffe00000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at c0000000 (gap: c0000000:38000000)
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 474 pages/cpu @ffff88013b200000 s1911488 r8192 d21824 u2097152
[    0.000000] pcpu-alloc: s1911488 r8192 d21824 u2097152 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1027580
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-3.1.0-rc8 root=/dev/sda3 ro quiet splash vt.handoff=7
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 4031124k/5242880k available (5976k kernel code, 1050620k absent, 161136k reserved, 5124k data, 3048k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:512 16
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
[    0.000000]  memory used by lock dependency info: 6367 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] ----------------------------------------------------------------------------
[    0.000000]                                  | spin |wlock |rlock |mutex | wsem | rsem |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]               recursive read-lock:             |  ok  |             |  ok  |
[    0.000000]            recursive read-lock #2:             |  ok  |             |  ok  |
[    0.000000]             mixed read-write-lock:             |  ok  |             |  ok  |
[    0.000000]             mixed write-read-lock:             |  ok  |             |  ok  |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq read-recursion/123:  ok  |
[    0.000000]       soft-irq read-recursion/123:  ok  |
[    0.000000]       hard-irq read-recursion/132:  ok  |
[    0.000000]       soft-irq read-recursion/132:  ok  |
[    0.000000]       hard-irq read-recursion/213:  ok  |
[    0.000000]       soft-irq read-recursion/213:  ok  |
[    0.000000]       hard-irq read-recursion/231:  ok  |
[    0.000000]       soft-irq read-recursion/231:  ok  |
[    0.000000]       hard-irq read-recursion/312:  ok  |
[    0.000000]       soft-irq read-recursion/312:  ok  |
[    0.000000]       hard-irq read-recursion/321:  ok  |
[    0.000000]       soft-irq read-recursion/321:  ok  |
[    0.000000] -------------------------------------------------------
[    0.000000] Good, all 218 testcases passed! |
[    0.000000] ---------------------------------
[    0.000000] ODEBUG: 0 of 0 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2392.911 MHz processor.
[    0.001004] Calibrating delay loop (skipped), value calculated using timer frequency.. 4785.82 BogoMIPS (lpj=2392911)
[    0.001009] pid_max: default: 32768 minimum: 301
[    0.001012] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.001020] no locks held by swapper/0.
[    0.001022] Modules linked in:
[    0.001026] Pid: 0, comm: swapper Not tainted 3.1.0-rc8 #99
[    0.001028] Call Trace:
[    0.001036]  [<ffffffff8103234e>] __schedule_bug+0x75/0x7a
[    0.001041]  [<ffffffff815c7d3a>] __schedule+0x95/0x686
[    0.001047]  [<ffffffff810595f1>] ? kzalloc.clone.0+0x29/0x2b
[    0.001051]  [<ffffffff8103aac0>] __cond_resched+0x2a/0x36
[    0.001054]  [<ffffffff815c8388>] _cond_resched+0x1b/0x22
[    0.001060]  [<ffffffff8110058c>] slab_pre_alloc_hook.clone.28+0x3a/0x40
[    0.001064]  [<ffffffff81101f50>] kmem_cache_alloc_trace+0x2c/0xec
[    0.001067]  [<ffffffff810595f1>] kzalloc.clone.0+0x29/0x2b
[    0.001073]  [<ffffffff81cc1b1b>] pidmap_init+0x6a/0xab
[    0.001078]  [<ffffffff81caca8f>] start_kernel+0x2ef/0x37f
[    0.001082]  [<ffffffff81cac2a6>] x86_64_start_reservations+0xb6/0xba
[    0.001085]  [<ffffffff81cac39c>] x86_64_start_kernel+0xf2/0xf9
[    0.002039] Security Framework initialized
[    0.002049] SELinux:  Initializing.
[    0.002135] SELinux:  Starting in permissive mode
[    0.002723] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.005165] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.005176] no locks held by swapper/0.
[    0.005178] Modules linked in:
[    0.005183] Pid: 0, comm: swapper Not tainted 3.1.0-rc8 #99
[    0.005185] Call Trace:
[    0.005194]  [<ffffffff8103234e>] __schedule_bug+0x75/0x7a
[    0.005199]  [<ffffffff815c7d3a>] __schedule+0x95/0x686
[    0.005205]  [<ffffffff810debbe>] ? zone_page_state_add+0x2f/0x34
[    0.005209]  [<ffffffff810ceb5d>] ? get_page_from_freelist+0x4fe/0x6ba
[    0.005214]  [<ffffffff8103aac0>] __cond_resched+0x2a/0x36
[    0.005217]  [<ffffffff815c8388>] _cond_resched+0x1b/0x22
[    0.005220]  [<ffffffff810cef53>] __alloc_pages_nodemask+0xa9/0x737
[    0.005225]  [<ffffffff810784e4>] ? __module_text_address+0x12/0x5f
[    0.005232]  [<ffffffff810f9e07>] alloc_page_interleave+0x34/0x7f
[    0.005235]  [<ffffffff810f9c20>] ? interleave_nodes+0x3f/0x57
[    0.005239]  [<ffffffff810f9f1e>] alloc_pages_current+0x7f/0xca
[    0.005244]  [<ffffffff810cbd67>] __get_free_pages+0xe/0x3d
[    0.005249]  [<ffffffff81027747>] pte_alloc_one_kernel+0x15/0x17
[    0.005253]  [<ffffffff810e49db>] __pte_alloc_kernel+0x1b/0x85
[    0.005258]  [<ffffffff810efc8f>] vmap_page_range_noflush+0x186/0x277
[    0.005262]  [<ffffffff810efdb2>] map_vm_area+0x32/0x46
[    0.005265]  [<ffffffff810f1899>] __vmalloc_node_range+0x197/0x1f1
[    0.005270]  [<ffffffff81cc69dc>] ? alloc_large_system_hash+0x13c/0x209
[    0.005274]  [<ffffffff810f1928>] __vmalloc_node+0x35/0x37
[    0.005277]  [<ffffffff81cc69dc>] ? alloc_large_system_hash+0x13c/0x209
[    0.005281]  [<ffffffff810f1aa3>] __vmalloc+0x20/0x22
[    0.005284]  [<ffffffff81cc69dc>] alloc_large_system_hash+0x13c/0x209
[    0.005289]  [<ffffffff81061408>] ? up+0x39/0x41
[    0.005294]  [<ffffffff81ccb27c>] inode_init+0x6f/0x9c
[    0.005297]  [<ffffffff81ccb14a>] vfs_caches_init+0xef/0x10d
[    0.005303]  [<ffffffff81cacadd>] start_kernel+0x33d/0x37f
[    0.005307]  [<ffffffff81cac2a6>] x86_64_start_reservations+0xb6/0xba
[    0.005310]  [<ffffffff81cac39c>] x86_64_start_kernel+0xf2/0xf9
[    0.005333] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.006563] Mount-cache hash table entries: 256
[    0.009342] Initializing cgroup subsys cpuacct
[    0.009363] Initializing cgroup subsys freezer
[    0.009639] CPU: Physical Processor ID: 0
[    0.009641] CPU: Processor Core ID: 0
[    0.009643] mce: CPU supports 6 MCE banks
[    0.009657] CPU0: Thermal monitoring enabled (TM2)
[    0.009664] using mwait in idle threads.
[    0.009765] ACPI: Core revision 20110623
[    0.010012] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.010019] no locks held by swapper/0.
[    0.010021] Modules linked in:
[    0.010025] Pid: 0, comm: swapper Not tainted 3.1.0-rc8 #99
[    0.010027] Call Trace:
[    0.010034]  [<ffffffff8103234e>] __schedule_bug+0x75/0x7a
[    0.010039]  [<ffffffff815c7d3a>] __schedule+0x95/0x686
[    0.010045]  [<ffffffff81297a1b>] ? acpi_ut_allocate_object_desc_dbg+0x3b/0x73
[    0.010050]  [<ffffffff8103aac0>] __cond_resched+0x2a/0x36
[    0.010053]  [<ffffffff815c8388>] _cond_resched+0x1b/0x22
[    0.010058]  [<ffffffff8110058c>] slab_pre_alloc_hook.clone.28+0x3a/0x40
[    0.010062]  [<ffffffff81102fe5>] kmem_cache_alloc+0x29/0x12b
[    0.010066]  [<ffffffff81297a1b>] acpi_ut_allocate_object_desc_dbg+0x3b/0x73
[    0.010070]  [<ffffffff81297acb>] acpi_ut_create_internal_object_dbg+0x27/0x8f
[    0.010076]  [<ffffffff8128cc6e>] acpi_ns_root_initialize+0x12f/0x2ad
[    0.010080]  [<ffffffff812983d1>] ? acpi_ut_create_rw_lock+0x41/0x45
[    0.010084]  [<ffffffff81cd7857>] acpi_initialize_subsystem+0x69/0xac
[    0.010089]  [<ffffffff81cd665e>] acpi_early_init+0x5c/0xde
[    0.010094]  [<ffffffff81cacb0a>] start_kernel+0x36a/0x37f
[    0.010098]  [<ffffffff81cac2a6>] x86_64_start_reservations+0xb6/0xba
[    0.010101]  [<ffffffff81cac39c>] x86_64_start_kernel+0xf2/0xf9
[    0.014047] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.014053] no locks held by swapper/0.
[    0.014055] Modules linked in:
[    0.014058] Pid: 0, comm: swapper Not tainted 3.1.0-rc8 #99
[    0.014060] Call Trace:
[    0.014064]  [<ffffffff8103234e>] __schedule_bug+0x75/0x7a
[    0.014067]  [<ffffffff815c7d3a>] __schedule+0x95/0x686
[    0.014071]  [<ffffffff81100e6a>] ? kmem_cache_free+0x30/0xc4
[    0.014075]  [<ffffffff812925a6>] ? acpi_ps_free_op+0x27/0x29
[    0.014079]  [<ffffffff8103aac0>] __cond_resched+0x2a/0x36
[    0.014082]  [<ffffffff815c8388>] _cond_resched+0x1b/0x22
[    0.014085]  [<ffffffff812917fd>] acpi_ps_complete_op+0x26d/0x284
[    0.014089]  [<ffffffff81291fff>] acpi_ps_parse_loop+0x7eb/0x94c
[    0.014093]  [<ffffffff812913ae>] acpi_ps_parse_aml+0x98/0x27a
[    0.014096]  [<ffffffff8128f7bf>] acpi_ns_one_complete_parse+0xf7/0x114
[    0.014100]  [<ffffffff8128f7fc>] acpi_ns_parse_table+0x20/0x38
[    0.014104]  [<ffffffff8128ce3b>] acpi_ns_load_table+0x4f/0x94
[    0.014107]  [<ffffffff8129401e>] acpi_load_tables+0xa6/0x167
[    0.014111]  [<ffffffff81cd666e>] acpi_early_init+0x6c/0xde
[    0.014115]  [<ffffffff81cacb0a>] start_kernel+0x36a/0x37f
[    0.014119]  [<ffffffff81cac2a6>] x86_64_start_reservations+0xb6/0xba
[    0.014122]  [<ffffffff81cac39c>] x86_64_start_kernel+0xf2/0xf9
[    0.018016] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.018022] no locks held by swapper/0.
[    0.018023] Modules linked in:
[    0.018026] Pid: 0, comm: swapper Not tainted 3.1.0-rc8 #99
[    0.018028] Call Trace:
[    0.018032]  [<ffffffff8103234e>] __schedule_bug+0x75/0x7a
[    0.018035]  [<ffffffff815c7d3a>] __schedule+0x95/0x686
[    0.018039]  [<ffffffff81100e6a>] ? kmem_cache_free+0x30/0xc4
[    0.018043]  [<ffffffff812925a6>] ? acpi_ps_free_op+0x27/0x29
[    0.018046]  [<ffffffff8103aac0>] __cond_resched+0x2a/0x36
[    0.018050]  [<ffffffff815c8388>] _cond_resched+0x1b/0x22
[    0.018053]  [<ffffffff812917fd>] acpi_ps_complete_op+0x26d/0x284
[    0.018056]  [<ffffffff81291fff>] acpi_ps_parse_loop+0x7eb/0x94c
[    0.018060]  [<ffffffff812913ae>] acpi_ps_parse_aml+0x98/0x27a
[    0.018064]  [<ffffffff8128f7bf>] acpi_ns_one_complete_parse+0xf7/0x114
[    0.018068]  [<ffffffff8128f7fc>] acpi_ns_parse_table+0x20/0x38
[    0.018071]  [<ffffffff8128ce3b>] acpi_ns_load_table+0x4f/0x94
[    0.018075]  [<ffffffff8129401e>] acpi_load_tables+0xa6/0x167
[    0.018079]  [<ffffffff81cd666e>] acpi_early_init+0x6c/0xde
[    0.018082]  [<ffffffff81cacb0a>] start_kernel+0x36a/0x37f
[    0.018086]  [<ffffffff81cac2a6>] x86_64_start_reservations+0xb6/0xba
[    0.018090]  [<ffffffff81cac39c>] x86_64_start_kernel+0xf2/0xf9
[    0.022096] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.022102] no locks held by swapper/0.
[    0.022104] Modules linked in:
[    0.022107] Pid: 0, comm: swapper Not tainted 3.1.0-rc8 #99
[    0.022109] Call Trace:
[    0.022112]  [<ffffffff8103234e>] __schedule_bug+0x75/0x7a
[    0.022116]  [<ffffffff815c7d3a>] __schedule+0x95/0x686
[    0.022120]  [<ffffffff810ffbc8>] ? slab_free_hook+0x6c/0x74
[    0.022124]  [<ffffffff8103aac0>] __cond_resched+0x2a/0x36
[    0.022127]  [<ffffffff815c8388>] _cond_resched+0x1b/0x22
[    0.022130]  [<ffffffff812917fd>] acpi_ps_complete_op+0x26d/0x284
[    0.022134]  [<ffffffff81291fff>] acpi_ps_parse_loop+0x7eb/0x94c
[    0.022138]  [<ffffffff812913ae>] acpi_ps_parse_aml+0x98/0x27a
[    0.022141]  [<ffffffff8128f7bf>] acpi_ns_one_complete_parse+0xf7/0x114
[    0.022145]  [<ffffffff8128f7fc>] acpi_ns_parse_table+0x20/0x38
[    0.022149]  [<ffffffff8128ce3b>] acpi_ns_load_table+0x4f/0x94
[    0.022153]  [<ffffffff8129401e>] acpi_load_tables+0xa6/0x167
[    0.022156]  [<ffffffff81cd666e>] acpi_early_init+0x6c/0xde
[    0.022160]  [<ffffffff81cacb0a>] start_kernel+0x36a/0x37f
[    0.022164]  [<ffffffff81cac2a6>] x86_64_start_reservations+0xb6/0xba
[    0.022168]  [<ffffffff81cac39c>] x86_64_start_kernel+0xf2/0xf9
[    0.026024] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.026030] no locks held by swapper/0.
[    0.026032] Modules linked in:
[    0.026035] Pid: 0, comm: swapper Not tainted 3.1.0-rc8 #99
[    0.026037] Call Trace:
[    0.026040]  [<ffffffff8103234e>] __schedule_bug+0x75/0x7a
[    0.026044]  [<ffffffff815c7d3a>] __schedule+0x95/0x686
[    0.026048]  [<ffffffff81297d8b>] ? acpi_ut_create_generic_state+0x32/0x4f
[    0.026052]  [<ffffffff8103aac0>] __cond_resched+0x2a/0x36
[    0.026055]  [<ffffffff815c8388>] _cond_resched+0x1b/0x22
[    0.026059]  [<ffffffff8110058c>] slab_pre_alloc_hook.clone.28+0x3a/0x40
[    0.026062]  [<ffffffff81102fe5>] kmem_cache_alloc+0x29/0x12b
[    0.026067]  [<ffffffff812738ff>] ? acpi_os_release_object+0xe/0x12
[    0.026071]  [<ffffffff81297d8b>] acpi_ut_create_generic_state+0x32/0x4f
[    0.026074]  [<ffffffff812923ba>] acpi_ps_push_scope+0x27/0x7e
[    0.026078]  [<ffffffff81291f20>] acpi_ps_parse_loop+0x70c/0x94c
[    0.026082]  [<ffffffff812913ae>] acpi_ps_parse_aml+0x98/0x27a
[    0.026085]  [<ffffffff8128f7bf>] acpi_ns_one_complete_parse+0xf7/0x114
[    0.026089]  [<ffffffff8128f7fc>] acpi_ns_parse_table+0x20/0x38
[    0.026093]  [<ffffffff8128ce3b>] acpi_ns_load_table+0x4f/0x94
[    0.026096]  [<ffffffff8129401e>] acpi_load_tables+0xa6/0x167
[    0.026100]  [<ffffffff81cd666e>] acpi_early_init+0x6c/0xde
[    0.026103]  [<ffffffff81cacb0a>] start_kernel+0x36a/0x37f
[    0.026107]  [<ffffffff81cac2a6>] x86_64_start_reservations+0xb6/0xba
[    0.026111]  [<ffffffff81cac39c>] x86_64_start_kernel+0xf2/0xf9
[    0.030075] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.030081] no locks held by swapper/0.
[    0.030082] Modules linked in:
[    0.030085] Pid: 0, comm: swapper Not tainted 3.1.0-rc8 #99
[    0.030087] Call Trace:
[    0.030091]  [<ffffffff8103234e>] __schedule_bug+0x75/0x7a
[    0.030094]  [<ffffffff815c7d3a>] __schedule+0x95/0x686
[    0.030098]  [<ffffffff810ffbc8>] ? slab_free_hook+0x6c/0x74
[    0.030102]  [<ffffffff8103aac0>] __cond_resched+0x2a/0x36
[    0.030105]  [<ffffffff815c8388>] _cond_resched+0x1b/0x22
[    0.030108]  [<ffffffff812917fd>] acpi_ps_complete_op+0x26d/0x284
[    0.030112]  [<ffffffff81291fff>] acpi_ps_parse_loop+0x7eb/0x94c
[    0.030116]  [<ffffffff812913ae>] acpi_ps_parse_aml+0x98/0x27a
[    0.030120]  [<ffffffff8128f7bf>] acpi_ns_one_complete_parse+0xf7/0x114
[    0.030124]  [<ffffffff8128f7fc>] acpi_ns_parse_table+0x20/0x38
[    0.030127]  [<ffffffff8128ce3b>] acpi_ns_load_table+0x4f/0x94
[    0.030131]  [<ffffffff8129401e>] acpi_load_tables+0xa6/0x167
[    0.030135]  [<ffffffff81cd666e>] acpi_early_init+0x6c/0xde
[    0.030138]  [<ffffffff81cacb0a>] start_kernel+0x36a/0x37f
[    0.030142]  [<ffffffff81cac2a6>] x86_64_start_reservations+0xb6/0xba
[    0.030146]  [<ffffffff81cac39c>] x86_64_start_kernel+0xf2/0xf9
[    0.034007] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.034013] no locks held by swapper/0.
[    0.034015] Modules linked in:
[    0.034018] Pid: 0, comm: swapper Not tainted 3.1.0-rc8 #99
[    0.034020] Call Trace:
[    0.034023]  [<ffffffff8103234e>] __schedule_bug+0x75/0x7a
[    0.034027]  [<ffffffff815c7d3a>] __schedule+0x95/0x686
[    0.034031]  [<ffffffff8128d79d>] ? acpi_ns_create_node+0x39/0x49
[    0.034035]  [<ffffffff812924e7>] ? acpi_os_acquire_object+0x2b/0x2d
[    0.034039]  [<ffffffff8103aac0>] __cond_resched+0x2a/0x36
[    0.034042]  [<ffffffff815c8388>] _cond_resched+0x1b/0x22
[    0.034046]  [<ffffffff8110058c>] slab_pre_alloc_hook.clone.28+0x3a/0x40
[    0.034049]  [<ffffffff81102fe5>] kmem_cache_alloc+0x29/0x12b
[    0.034053]  [<ffffffff812924e7>] ? acpi_os_acquire_object+0x2b/0x2d
[    0.034056]  [<ffffffff812924e7>] acpi_os_acquire_object+0x2b/0x2d
[    0.034060]  [<ffffffff81292538>] acpi_ps_alloc_op+0x3c/0x62
[    0.034065]  [<ffffffff812805a2>] acpi_ds_load1_begin_op+0x212/0x25e
[    0.034069]  [<ffffffff81291af1>] acpi_ps_parse_loop+0x2dd/0x94c
[    0.034073]  [<ffffffff812913ae>] acpi_ps_parse_aml+0x98/0x27a
[    0.034076]  [<ffffffff8128f7bf>] acpi_ns_one_complete_parse+0xf7/0x114
[    0.034080]  [<ffffffff8128f7fc>] acpi_ns_parse_table+0x20/0x38
[    0.034084]  [<ffffffff8128ce3b>] acpi_ns_load_table+0x4f/0x94
[    0.034087]  [<ffffffff8129401e>] acpi_load_tables+0xa6/0x167
[    0.034091]  [<ffffffff81cd666e>] acpi_early_init+0x6c/0xde
[    0.034095]  [<ffffffff81cacb0a>] start_kernel+0x36a/0x37f
[    0.034099]  [<ffffffff81cac2a6>] x86_64_start_reservations+0xb6/0xba
[    0.034102]  [<ffffffff81cac39c>] x86_64_start_kernel+0xf2/0xf9
[    0.038004] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.038009] no locks held by swapper/0.
[    0.038011] Modules linked in:
[    0.038014] Pid: 0, comm: swapper Not tainted 3.1.0-rc8 #99
[    0.038016] Call Trace:
[    0.038020]  [<ffffffff8103234e>] __schedule_bug+0x75/0x7a
[    0.038023]  [<ffffffff815c7d3a>] __schedule+0x95/0x686
[    0.038028]  [<ffffffff81297d8b>] ? acpi_ut_create_generic_state+0x32/0x4f
[    0.038031]  [<ffffffff812924e7>] ? acpi_os_acquire_object+0x2b/0x2d
[    0.038035]  [<ffffffff8103aac0>] __cond_resched+0x2a/0x36
[    0.038038]  [<ffffffff815c8388>] _cond_resched+0x1b/0x22
[    0.038042]  [<ffffffff8110058c>] slab_pre_alloc_hook.clone.28+0x3a/0x40
[    0.038045]  [<ffffffff812738ff>] ? acpi_os_release_object+0xe/0x12
[    0.038049]  [<ffffffff81102fe5>] kmem_cache_alloc+0x29/0x12b
[    0.038053]  [<ffffffff812924e7>] acpi_os_acquire_object+0x2b/0x2d
[    0.038056]  [<ffffffff8129255c>] acpi_ps_alloc_op+0x60/0x62
[    0.038059]  [<ffffffff81291a47>] acpi_ps_parse_loop+0x233/0x94c
[    0.038063]  [<ffffffff812913ae>] acpi_ps_parse_aml+0x98/0x27a
[    0.038066]  [<ffffffff8128f7bf>] acpi_ns_one_complete_parse+0xf7/0x114
[    0.038070]  [<ffffffff8128f7fc>] acpi_ns_parse_table+0x20/0x38
[    0.038074]  [<ffffffff8128ce3b>] acpi_ns_load_table+0x4f/0x94
[    0.038077]  [<ffffffff8129401e>] acpi_load_tables+0xa6/0x167
[    0.038081]  [<ffffffff81cd666e>] acpi_early_init+0x6c/0xde
[    0.038085]  [<ffffffff81cacb0a>] start_kernel+0x36a/0x37f
[    0.038089]  [<ffffffff81cac2a6>] x86_64_start_reservations+0xb6/0xba
[    0.038092]  [<ffffffff81cac39c>] x86_64_start_kernel+0xf2/0xf9
[    0.042040] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.042046] no locks held by swapper/0.
[    0.042047] Modules linked in:
[    0.042050] Pid: 0, comm: swapper Not tainted 3.1.0-rc8 #99
[    0.042052] Call Trace:
[    0.042056]  [<ffffffff8103234e>] __schedule_bug+0x75/0x7a
[    0.042059]  [<ffffffff815c7d3a>] __schedule+0x95/0x686
[    0.042063]  [<ffffffff810ffbc8>] ? slab_free_hook+0x6c/0x74
[    0.042067]  [<ffffffff8103aac0>] __cond_resched+0x2a/0x36
[    0.042070]  [<ffffffff815c8388>] _cond_resched+0x1b/0x22
[    0.042074]  [<ffffffff812917fd>] acpi_ps_complete_op+0x26d/0x284
[    0.042077]  [<ffffffff81291fff>] acpi_ps_parse_loop+0x7eb/0x94c
[    0.042081]  [<ffffffff812913ae>] acpi_ps_parse_aml+0x98/0x27a
[    0.042085]  [<ffffffff8128f7bf>] acpi_ns_one_complete_parse+0xf7/0x114
[    0.042089]  [<ffffffff8128f7fc>] acpi_ns_parse_table+0x20/0x38
[    0.042092]  [<ffffffff8128ce3b>] acpi_ns_load_table+0x4f/0x94
[    0.042096]  [<ffffffff8129401e>] acpi_load_tables+0xa6/0x167
[    0.042100]  [<ffffffff81cd666e>] acpi_early_init+0x6c/0xde
[    0.042103]  [<ffffffff81cacb0a>] start_kernel+0x36a/0x37f
[    0.042107]  [<ffffffff81cac2a6>] x86_64_start_reservations+0xb6/0xba
[    0.042111]  [<ffffffff81cac39c>] x86_64_start_kernel+0xf2/0xf9
[    0.046014] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.046020] no locks held by swapper/0.
[    0.046021] Modules linked in:
[    0.046024] Pid: 0, comm: swapper Not tainted 3.1.0-rc8 #99
[    0.046026] Call Trace:
[    0.046030]  [<ffffffff8103234e>] __schedule_bug+0x75/0x7a
[    0.046033]  [<ffffffff815c7d3a>] __schedule+0x95/0x686
[    0.046037]  [<ffffffff810ffbc8>] ? slab_free_hook+0x6c/0x74
[    0.046041]  [<ffffffff8103aac0>] __cond_resched+0x2a/0x36
[    0.046044]  [<ffffffff815c8388>] _cond_resched+0x1b/0x22
[    0.046048]  [<ffffffff812917fd>] acpi_ps_complete_op+0x26d/0x284
[    0.046051]  [<ffffffff81291fff>] acpi_ps_parse_loop+0x7eb/0x94c
[    0.046055]  [<ffffffff812913ae>] acpi_ps_parse_aml+0x98/0x27a
[    0.046059]  [<ffffffff8128f7bf>] acpi_ns_one_complete_parse+0xf7/0x114
[    0.046063]  [<ffffffff8128f7fc>] acpi_ns_parse_table+0x20/0x38
[    0.046066]  [<ffffffff8128ce3b>] acpi_ns_load_table+0x4f/0x94
[    0.046070]  [<ffffffff8129401e>] acpi_load_tables+0xa6/0x167
[    0.046074]  [<ffffffff81cd666e>] acpi_early_init+0x6c/0xde
[    0.046077]  [<ffffffff81cacb0a>] start_kernel+0x36a/0x37f
[    0.046081]  [<ffffffff81cac2a6>] x86_64_start_reservations+0xb6/0xba
[    0.046085]  [<ffffffff81cac39c>] x86_64_start_kernel+0xf2/0xf9
[    0.050529] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.050535] no locks held by swapper/0.
[    0.050536] Modules linked in:
[    0.050539] Pid: 0, comm: swapper Not tainted 3.1.0-rc8 #99
[    0.050541] Call Trace:
[    0.050545]  [<ffffffff8103234e>] __schedule_bug+0x75/0x7a
[    0.050548]  [<ffffffff815c7d3a>] __schedule+0x95/0x686
[    0.050552]  [<ffffffff81100e6a>] ? kmem_cache_free+0x30/0xc4
[    0.050555]  [<ffffffff812925a6>] ? acpi_ps_free_op+0x27/0x29
[    0.050559]  [<ffffffff8103aac0>] __cond_resched+0x2a/0x36
[    0.050562]  [<ffffffff815c8388>] _cond_resched+0x1b/0x22
[    0.050566]  [<ffffffff812917fd>] acpi_ps_complete_op+0x26d/0x284
[    0.050569]  [<ffffffff81291fff>] acpi_ps_parse_loop+0x7eb/0x94c
[    0.050573]  [<ffffffff812913ae>] acpi_ps_parse_aml+0x98/0x27a
[    0.050577]  [<ffffffff8128f7bf>] acpi_ns_one_complete_parse+0xf7/0x114
[    0.050581]  [<ffffffff8128f7fc>] acpi_ns_parse_table+0x20/0x38
[    0.050584]  [<ffffffff8128ce3b>] acpi_ns_load_table+0x4f/0x94
[    0.050588]  [<ffffffff8129401e>] acpi_load_tables+0xa6/0x167
[    0.050592]  [<ffffffff81cd666e>] acpi_early_init+0x6c/0xde
[    0.050595]  [<ffffffff81cacb0a>] start_kernel+0x36a/0x37f
[    0.050599]  [<ffffffff81cac2a6>] x86_64_start_reservations+0xb6/0xba
[    0.050603]  [<ffffffff81cac39c>] x86_64_start_kernel+0xf2/0xf9
[    0.054030] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.054036] no locks held by swapper/0.
[    0.054038] Modules linked in:
[    0.054041] Pid: 0, comm: swapper Not tainted 3.1.0-rc8 #99
[    0.054043] Call Trace:
[    0.054046]  [<ffffffff8103234e>] __schedule_bug+0x75/0x7a
[    0.054050]  [<ffffffff815c7d3a>] __schedule+0x95/0x686
[    0.054053]  [<ffffffff81100e6a>] ? kmem_cache_free+0x30/0xc4
[    0.054057]  [<ffffffff812925a6>] ? acpi_ps_free_op+0x27/0x29
[    0.054061]  [<ffffffff8103aac0>] __cond_resched+0x2a/0x36
[    0.054064]  [<ffffffff815c8388>] _cond_resched+0x1b/0x22
[    0.054067]  [<ffffffff812917fd>] acpi_ps_complete_op+0x26d/0x284
[    0.054071]  [<ffffffff81291fff>] acpi_ps_parse_loop+0x7eb/0x94c
[    0.054075]  [<ffffffff812913ae>] acpi_ps_parse_aml+0x98/0x27a
[    0.054079]  [<ffffffff8128f7bf>] acpi_ns_one_complete_parse+0xf7/0x114
[    0.054082]  [<ffffffff8128f7fc>] acpi_ns_parse_table+0x20/0x38
[    0.054086]  [<ffffffff8128ce3b>] acpi_ns_load_table+0x4f/0x94
[    0.054090]  [<ffffffff8129401e>] acpi_load_tables+0xa6/0x167
[    0.054093]  [<ffffffff81cd666e>] acpi_early_init+0x6c/0xde
[    0.054097]  [<ffffffff81cacb0a>] start_kernel+0x36a/0x37f
[    0.054101]  [<ffffffff81cac2a6>] x86_64_start_reservations+0xb6/0xba
[    0.054105]  [<ffffffff81cac39c>] x86_64_start_kernel+0xf2/0xf9
[    0.058012] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.058018] no locks held by swapper/0.
[    0.058020] Modules linked in:
[    0.058022] Pid: 0, comm: swapper Not tainted 3.1.0-rc8 #99
[    0.058024] Call Trace:
[    0.058028]  [<ffffffff8103234e>] __schedule_bug+0x75/0x7a
[    0.058031]  [<ffffffff815c7d3a>] __schedule+0x95/0x686
[    0.058035]  [<ffffffff810ffbc8>] ? slab_free_hook+0x6c/0x74
[    0.058039]  [<ffffffff8103aac0>] __cond_resched+0x2a/0x36
[    0.058042]  [<ffffffff815c8388>] _cond_resched+0x1b/0x22
[    0.058046]  [<ffffffff812917fd>] acpi_ps_complete_op+0x26d/0x284
[    0.058049]  [<ffffffff81291fff>] acpi_ps_parse_loop+0x7eb/0x94c
[    0.058053]  [<ffffffff812913ae>] acpi_ps_parse_aml+0x98/0x27a
[    0.058057]  [<ffffffff8128f7bf>] acpi_ns_one_complete_parse+0xf7/0x114
[    0.058061]  [<ffffffff8128f7fc>] acpi_ns_parse_table+0x20/0x38
[    0.058064]  [<ffffffff8128ce3b>] acpi_ns_load_table+0x4f/0x94
[    0.058068]  [<ffffffff8129401e>] acpi_load_tables+0xa6/0x167
[    0.058072]  [<ffffffff81cd666e>] acpi_early_init+0x6c/0xde
[    0.058075]  [<ffffffff81cacb0a>] start_kernel+0x36a/0x37f
[    0.058079]  [<ffffffff81cac2a6>] x86_64_start_reservations+0xb6/0xba
[    0.058083]  [<ffffffff81cac39c>] x86_64_start_kernel+0xf2/0xf9
[    0.062007] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.062013] no locks held by swapper/0.
[    0.062015] Modules linked in:
[    0.062018] Pid: 0, comm: swapper Not tainted 3.1.0-rc8 #99
[    0.062019] Call Trace:
[    0.062023]  [<ffffffff8103234e>] __schedule_bug+0x75/0x7a
[    0.062027]  [<ffffffff815c7d3a>] __schedule+0x95/0x686
[    0.062030]  [<ffffffff81100e6a>] ? kmem_cache_free+0x30/0xc4
[    0.062034]  [<ffffffff812925a6>] ? acpi_ps_free_op+0x27/0x29
[    0.062038]  [<ffffffff8103aac0>] __cond_resched+0x2a/0x36
[    0.062041]  [<ffffffff815c8388>] _cond_resched+0x1b/0x22
[    0.062044]  [<ffffffff812917fd>] acpi_ps_complete_op+0x26d/0x284
[    0.062048]  [<ffffffff81291fff>] acpi_ps_parse_loop+0x7eb/0x94c
[    0.062052]  [<ffffffff812913ae>] acpi_ps_parse_aml+0x98/0x27a
[    0.062055]  [<ffffffff8128f7bf>] acpi_ns_one_complete_parse+0xf7/0x114
[    0.062059]  [<ffffffff8128f7fc>] acpi_ns_parse_table+0x20/0x38
[    0.062063]  [<ffffffff8128ce3b>] acpi_ns_load_table+0x4f/0x94
[    0.062066]  [<ffffffff8129401e>] acpi_load_tables+0xa6/0x167
[    0.062070]  [<ffffffff81cd666e>] acpi_early_init+0x6c/0xde
[    0.062074]  [<ffffffff81cacb0a>] start_kernel+0x36a/0x37f
[    0.062078]  [<ffffffff81cac2a6>] x86_64_start_reservations+0xb6/0xba
[    0.062082]  [<ffffffff81cac39c>] x86_64_start_kernel+0xf2/0xf9
[    0.066004] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.066010] no locks held by swapper/0.
[    0.066012] Modules linked in:
[    0.066015] Pid: 0, comm: swapper Not tainted 3.1.0-rc8 #99
[    0.066016] Call Trace:
[    0.066020]  [<ffffffff8103234e>] __schedule_bug+0x75/0x7a
[    0.066024]  [<ffffffff815c7d3a>] __schedule+0x95/0x686
[    0.066028]  [<ffffffff81071765>] ? trace_hardirqs_on+0xd/0xf
[    0.066032]  [<ffffffff81297d8b>] ? acpi_ut_create_generic_state+0x32/0x4f
[    0.066036]  [<ffffffff812924e7>] ? acpi_os_acquire_object+0x2b/0x2d
[    0.066040]  [<ffffffff8103aac0>] __cond_resched+0x2a/0x36
[    0.066043]  [<ffffffff815c8388>] _cond_resched+0x1b/0x22
[    0.066046]  [<ffffffff8110058c>] slab_pre_alloc_hook.clone.28+0x3a/0x40
[    0.066050]  [<ffffffff812738ff>] ? acpi_os_release_object+0xe/0x12
[    0.066054]  [<ffffffff81102fe5>] kmem_cache_alloc+0x29/0x12b
[    0.066058]  [<ffffffff812924e7>] acpi_os_acquire_object+0x2b/0x2d
[    0.066061]  [<ffffffff81292538>] acpi_ps_alloc_op+0x3c/0x62
[    0.066064]  [<ffffffff81291a47>] acpi_ps_parse_loop+0x233/0x94c
[    0.066068]  [<ffffffff812913ae>] acpi_ps_parse_aml+0x98/0x27a
[    0.066071]  [<ffffffff8128f7bf>] acpi_ns_one_complete_parse+0xf7/0x114
[    0.066075]  [<ffffffff8128f7fc>] acpi_ns_parse_table+0x20/0x38
[    0.066079]  [<ffffffff8128ce3b>] acpi_ns_load_table+0x4f/0x94
[    0.066082]  [<ffffffff8129401e>] acpi_load_tables+0xa6/0x167
[    0.066086]  [<ffffffff81cd666e>] acpi_early_init+0x6c/0xde
[    0.066090]  [<ffffffff81cacb0a>] start_kernel+0x36a/0x37f
[    0.066094]  [<ffffffff81cac2a6>] x86_64_start_reservations+0xb6/0xba
[    0.066097]  [<ffffffff81cac39c>] x86_64_start_kernel+0xf2/0xf9
[    0.070448] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.070454] no locks held by swapper/0.
[    0.070455] Modules linked in:
[    0.070458] Pid: 0, comm: swapper Not tainted 3.1.0-rc8 #99
[    0.070460] Call Trace:
[    0.070464]  [<ffffffff8103234e>] __schedule_bug+0x75/0x7a
[    0.070467]  [<ffffffff815c7d3a>] __schedule+0x95/0x686
[    0.070471]  [<ffffffff81100e6a>] ? kmem_cache_free+0x30/0xc4
[    0.070475]  [<ffffffff812925a6>] ? acpi_ps_free_op+0x27/0x29
[    0.070478]  [<ffffffff8103aac0>] __cond_resched+0x2a/0x36
[    0.070481]  [<ffffffff815c8388>] _cond_resched+0x1b/0x22
[    0.070485]  [<ffffffff812917fd>] acpi_ps_complete_op+0x26d/0x284
[    0.070488]  [<ffffffff81291fff>] acpi_ps_parse_loop+0x7eb/0x94c
[    0.070492]  [<ffffffff812913ae>] acpi_ps_parse_aml+0x98/0x27a
[    0.070496]  [<ffffffff8128f7bf>] acpi_ns_one_complete_parse+0xf7/0x114
[    0.070500]  [<ffffffff8128f7fc>] acpi_ns_parse_table+0x20/0x38
[    0.070503]  [<ffffffff8128ce3b>] acpi_ns_load_table+0x4f/0x94
[    0.070507]  [<ffffffff8129401e>] acpi_load_tables+0xa6/0x167
[    0.070511]  [<ffffffff81cd666e>] acpi_early_init+0x6c/0xde
[    0.070514]  [<ffffffff81cacb0a>] start_kernel+0x36a/0x37f
[    0.070518]  [<ffffffff81cac2a6>] x86_64_start_reservations+0xb6/0xba
[    0.070522]  [<ffffffff81cac39c>] x86_64_start_kernel+0xf2/0xf9
[    0.074032] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.074038] no locks held by swapper/0.
[    0.074039] Modules linked in:
[    0.074042] Pid: 0, comm: swapper Not tainted 3.1.0-rc8 #99
[    0.074044] Call Trace:
[    0.074048]  [<ffffffff8103234e>] __schedule_bug+0x75/0x7a
[    0.074052]  [<ffffffff815c7d3a>] __schedule+0x95/0x686
[    0.074055]  [<ffffffff810ffbc8>] ? slab_free_hook+0x6c/0x74
[    0.074059]  [<ffffffff8103aac0>] __cond_resched+0x2a/0x36
[    0.074062]  [<ffffffff815c8388>] _cond_resched+0x1b/0x22
[    0.074066]  [<ffffffff812917fd>] acpi_ps_complete_op+0x26d/0x284
[    0.074070]  [<ffffffff81291fff>] acpi_ps_parse_loop+0x7eb/0x94c
[    0.074074]  [<ffffffff812913ae>] acpi_ps_parse_aml+0x98/0x27a
[    0.074077]  [<ffffffff8128f7bf>] acpi_ns_one_complete_parse+0xf7/0x114
[    0.074081]  [<ffffffff8128f7fc>] acpi_ns_parse_table+0x20/0x38
[    0.074085]  [<ffffffff8128ce3b>] acpi_ns_load_table+0x4f/0x94
[    0.074088]  [<ffffffff8129401e>] acpi_load_tables+0xa6/0x167
[    0.074092]  [<ffffffff81cd666e>] acpi_early_init+0x6c/0xde
[    0.074096]  [<ffffffff81cacb0a>] start_kernel+0x36a/0x37f
[    0.074100]  [<ffffffff81cac2a6>] x86_64_start_reservations+0xb6/0xba
[    0.074103]  [<ffffffff81cac39c>] x86_64_start_kernel+0xf2/0xf9
[    0.078000] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.078006] no locks held by swapper/0.
[    0.078007] Modules linked in:
[    0.078010] Pid: 0, comm: swapper Not tainted 3.1.0-rc8 #99
[    0.078012] Call Trace:
[    0.078016]  [<ffffffff8103234e>] __schedule_bug+0x75/0x7a
[    0.078020]  [<ffffffff815c7d3a>] __schedule+0x95/0x686
[    0.078023]  [<ffffffff810ffbc8>] ? slab_free_hook+0x6c/0x74
[    0.078027]  [<ffffffff8103aac0>] __cond_resched+0x2a/0x36
[    0.078030]  [<ffffffff815c8388>] _cond_resched+0x1b/0x22
[    0.078034]  [<ffffffff812917fd>] acpi_ps_complete_op+0x26d/0x284
[    0.078038]  [<ffffffff81291fff>] acpi_ps_parse_loop+0x7eb/0x94c
[    0.078041]  [<ffffffff812913ae>] acpi_ps_parse_aml+0x98/0x27a
[    0.078045]  [<ffffffff8128f7bf>] acpi_ns_one_complete_parse+0xf7/0x114
[    0.078049]  [<ffffffff8128f7fc>] acpi_ns_parse_table+0x20/0x38
[    0.078052]  [<ffffffff8128ce3b>] acpi_ns_load_table+0x4f/0x94
[    0.078056]  [<ffffffff8129401e>] acpi_load_tables+0xa6/0x167
[    0.078060]  [<ffffffff81cd666e>] acpi_early_init+0x6c/0xde
[    0.078064]  [<ffffffff81cacb0a>] start_kernel+0x36a/0x37f
[    0.078067]  [<ffffffff81cac2a6>] x86_64_start_reservations+0xb6/0xba
[    0.078071]  [<ffffffff81cac39c>] x86_64_start_kernel+0xf2/0xf9
[    0.082010] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.082016] no locks held by swapper/0.
[    0.082017] Modules linked in:
[    0.082020] Pid: 0, comm: swapper Not tainted 3.1.0-rc8 #99
[    0.082022] Call Trace:
[    0.082026]  [<ffffffff8103234e>] __schedule_bug+0x75/0x7a
[    0.082029]  [<ffffffff815c7d3a>] __schedule+0x95/0x686
[    0.082034]  [<ffffffff812924e7>] ? acpi_os_acquire_object+0x2b/0x2d
[    0.082037]  [<ffffffff8103aac0>] __cond_resched+0x2a/0x36
[    0.082040]  [<ffffffff815c8388>] _cond_resched+0x1b/0x22
[    0.082044]  [<ffffffff8110058c>] slab_pre_alloc_hook.clone.28+0x3a/0x40
[    0.082048]  [<ffffffff81102fe5>] kmem_cache_alloc+0x29/0x12b
[    0.082052]  [<ffffffff812924e7>] acpi_os_acquire_object+0x2b/0x2d
[    0.082055]  [<ffffffff8129255c>] acpi_ps_alloc_op+0x60/0x62
[    0.082058]  [<ffffffff81290de6>] acpi_ps_get_next_arg+0x42/0x2bc
[    0.082062]  [<ffffffff81100e6a>] ? kmem_cache_free+0x30/0xc4
[    0.082065]  [<ffffffff81291d0e>] acpi_ps_parse_loop+0x4fa/0x94c
[    0.082069]  [<ffffffff812913ae>] acpi_ps_parse_aml+0x98/0x27a
[    0.082073]  [<ffffffff8128f7bf>] acpi_ns_one_complete_parse+0xf7/0x114
[    0.082077]  [<ffffffff8128f7fc>] acpi_ns_parse_table+0x20/0x38
[    0.082080]  [<ffffffff8128ce3b>] acpi_ns_load_table+0x4f/0x94
[    0.082084]  [<ffffffff8129401e>] acpi_load_tables+0xa6/0x167
[    0.082088]  [<ffffffff81cd666e>] acpi_early_init+0x6c/0xde
[    0.082092]  [<ffffffff81cacb0a>] start_kernel+0x36a/0x37f
[    0.082095]  [<ffffffff81cac2a6>] x86_64_start_reservations+0xb6/0xba
[    0.082099]  [<ffffffff81cac39c>] x86_64_start_kernel+0xf2/0xf9
[    0.086031] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.086037] no locks held by swapper/0.
[    0.086039] Modules linked in:
[    0.086042] Pid: 0, comm: swapper Not tainted 3.1.0-rc8 #99
[    0.086043] Call Trace:
[    0.086047]  [<ffffffff8103234e>] __schedule_bug+0x75/0x7a
[    0.086051]  [<ffffffff815c7d3a>] __schedule+0x95/0x686
[    0.086054]  [<ffffffff81100e6a>] ? kmem_cache_free+0x30/0xc4
[    0.086058]  [<ffffffff812925a6>] ? acpi_ps_free_op+0x27/0x29
[    0.086062]  [<ffffffff8103aac0>] __cond_resched+0x2a/0x36
[    0.086065]  [<ffffffff815c8388>] _cond_resched+0x1b/0x22
[    0.086068]  [<ffffffff812917fd>] acpi_ps_complete_op+0x26d/0x284
[    0.086072]  [<ffffffff81291fff>] acpi_ps_parse_loop+0x7eb/0x94c
[    0.086076]  [<ffffffff812913ae>] acpi_ps_parse_aml+0x98/0x27a
[    0.086079]  [<ffffffff8128f7bf>] acpi_ns_one_complete_parse+0xf7/0x114
[    0.086083]  [<ffffffff8128f7fc>] acpi_ns_parse_table+0x20/0x38
[    0.086087]  [<ffffffff8128ce3b>] acpi_ns_load_table+0x4f/0x94
[    0.086090]  [<ffffffff8129401e>] acpi_load_tables+0xa6/0x167
[    0.086094]  [<ffffffff81cd666e>] acpi_early_init+0x6c/0xde
[    0.086098]  [<ffffffff81cacb0a>] start_kernel+0x36a/0x37f
[    0.086102]  [<ffffffff81cac2a6>] x86_64_start_reservations+0xb6/0xba
[    0.086105]  [<ffffffff81cac39c>] x86_64_start_kernel+0xf2/0xf9
[    0.090036] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.090042] no locks held by swapper/0.
[    0.090043] Modules linked in:
[    0.090046] Pid: 0, comm: swapper Not tainted 3.1.0-rc8 #99
[    0.090048] Call Trace:
[    0.090052]  [<ffffffff8103234e>] __schedule_bug+0x75/0x7a
[    0.090056]  [<ffffffff815c7d3a>] __schedule+0x95/0x686
[    0.090059]  [<ffffffff81100e6a>] ? kmem_cache_free+0x30/0xc4
[    0.090063]  [<ffffffff812925a6>] ? acpi_ps_free_op+0x27/0x29
[    0.090067]  [<ffffffff8103aac0>] __cond_resched+0x2a/0x36
[    0.090070]  [<ffffffff815c8388>] _cond_resched+0x1b/0x22
[    0.090073]  [<ffffffff812917fd>] acpi_ps_complete_op+0x26d/0x284
[    0.090077]  [<ffffffff81291fff>] acpi_ps_parse_loop+0x7eb/0x94c
[    0.090081]  [<ffffffff812913ae>] acpi_ps_parse_aml+0x98/0x27a
[    0.090084]  [<ffffffff8128f7bf>] acpi_ns_one_complete_parse+0xf7/0x114
[    0.090088]  [<ffffffff8128f7fc>] acpi_ns_parse_table+0x20/0x38
[    0.090092]  [<ffffffff8128ce3b>] acpi_ns_load_table+0x4f/0x94
[    0.090095]  [<ffffffff8129401e>] acpi_load_tables+0xa6/0x167
[    0.090099]  [<ffffffff81cd666e>] acpi_early_init+0x6c/0xde
[    0.090103]  [<ffffffff81cacb0a>] start_kernel+0x36a/0x37f
[    0.090107]  [<ffffffff81cac2a6>] x86_64_start_reservations+0xb6/0xba
[    0.090110]  [<ffffffff81cac39c>] x86_64_start_kernel+0xf2/0xf9
[    0.094003] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.094009] no locks held by swapper/0.
[    0.094011] Modules linked in:
[    0.094014] Pid: 0, comm: swapper Not tainted 3.1.0-rc8 #99
[    0.094016] Call Trace:
[    0.094020]  [<ffffffff8103234e>] __schedule_bug+0x75/0x7a
[    0.094023]  [<ffffffff815c7d3a>] __schedule+0x95/0x686
[    0.094027]  [<ffffffff81071721>] ? trace_hardirqs_on_caller+0x121/0x158
[    0.094032]  [<ffffffff81297a1b>] ? acpi_ut_allocate_object_desc_dbg+0x3b/0x73
[    0.094036]  [<ffffffff8103aac0>] __cond_resched+0x2a/0x36
[    0.094039]  [<ffffffff815c8388>] _cond_resched+0x1b/0x22
[    0.094042]  [<ffffffff8110058c>] slab_pre_alloc_hook.clone.28+0x3a/0x40
[    0.094046]  [<ffffffff81102fe5>] kmem_cache_alloc+0x29/0x12b
[    0.094050]  [<ffffffff81297a1b>] acpi_ut_allocate_object_desc_dbg+0x3b/0x73
[    0.094054]  [<ffffffff81297acb>] acpi_ut_create_internal_object_dbg+0x27/0x8f
[    0.094058]  [<ffffffff812881f9>] acpi_ex_prep_field_value+0x9d/0x230
[    0.094063]  [<ffffffff8127d66d>] acpi_ds_get_field_names+0x125/0x1b0
[    0.094067]  [<ffffffff8127d8e0>] acpi_ds_create_field+0x9a/0xa3
[    0.094071]  [<ffffffff8129914b>] ? acpi_ut_valid_object_type+0x9/0x12
[    0.094075]  [<ffffffff81281732>] acpi_ds_load2_end_op+0x10a/0x360
[    0.094078]  [<ffffffff81292299>] ? acpi_ps_get_opcode_info+0x9/0x49
[    0.094082]  [<ffffffff81291fd1>] acpi_ps_parse_loop+0x7bd/0x94c
[    0.094085]  [<ffffffff812913ae>] acpi_ps_parse_aml+0x98/0x27a
[    0.094089]  [<ffffffff8128f7bf>] acpi_ns_one_complete_parse+0xf7/0x114
[    0.094093]  [<ffffffff8128f80f>] acpi_ns_parse_table+0x33/0x38
[    0.094097]  [<ffffffff8128ce3b>] acpi_ns_load_table+0x4f/0x94
[    0.094100]  [<ffffffff8129401e>] acpi_load_tables+0xa6/0x167
[    0.094104]  [<ffffffff81cd666e>] acpi_early_init+0x6c/0xde
[    0.094108]  [<ffffffff81cacb0a>] start_kernel+0x36a/0x37f
[    0.094111]  [<ffffffff81cac2a6>] x86_64_start_reservations+0xb6/0xba
[    0.094115]  [<ffffffff81cac39c>] x86_64_start_kernel+0xf2/0xf9
[    0.098002] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.098010] no locks held by swapper/0.
[    0.098012] Modules linked in:
[    0.098015] Pid: 0, comm: swapper Not tainted 3.1.0-rc8 #99
[    0.098017] Call Trace:
[    0.098020]  [<ffffffff8103234e>] __schedule_bug+0x75/0x7a
[    0.098024]  [<ffffffff815c7d3a>] __schedule+0x95/0x686
[    0.098030]  [<ffffffff81008205>] ? native_sched_clock+0x3b/0x3d
[    0.098034]  [<ffffffff81297d8b>] ? acpi_ut_create_generic_state+0x32/0x4f
[    0.098038]  [<ffffffff8103aac0>] __cond_resched+0x2a/0x36
[    0.098041]  [<ffffffff815c8388>] _cond_resched+0x1b/0x22
[    0.098045]  [<ffffffff8110058c>] slab_pre_alloc_hook.clone.28+0x3a/0x40
[    0.098049]  [<ffffffff81102fe5>] kmem_cache_alloc+0x29/0x12b
[    0.098053]  [<ffffffff8128cea2>] ? acpi_ns_search_one_scope+0x22/0x45
[    0.098058]  [<ffffffff81297d8b>] acpi_ut_create_generic_state+0x32/0x4f
[    0.098062]  [<ffffffff8127ee6e>] acpi_ds_scope_stack_push+0x6c/0x9f
[    0.098066]  [<ffffffff8128cb18>] acpi_ns_lookup+0x314/0x33b
[    0.098071]  [<ffffffff812815bf>] acpi_ds_load2_begin_op+0x2ab/0x314
[    0.098075]  [<ffffffff81291af1>] acpi_ps_parse_loop+0x2dd/0x94c
[    0.098079]  [<ffffffff812913ae>] acpi_ps_parse_aml+0x98/0x27a
[    0.098082]  [<ffffffff8128f7bf>] acpi_ns_one_complete_parse+0xf7/0x114
[    0.098086]  [<ffffffff8128f80f>] acpi_ns_parse_table+0x33/0x38
[    0.098090]  [<ffffffff8128ce3b>] acpi_ns_load_table+0x4f/0x94
[    0.098094]  [<ffffffff8129401e>] acpi_load_tables+0xa6/0x167
[    0.098098]  [<ffffffff81cd666e>] acpi_early_init+0x6c/0xde
[    0.098102]  [<ffffffff81cacb0a>] start_kernel+0x36a/0x37f
[    0.098106]  [<ffffffff81cac2a6>] x86_64_start_reservations+0xb6/0xba
[    0.098110]  [<ffffffff81cac39c>] x86_64_start_kernel+0xf2/0xf9
[    0.102013] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.102020] no locks held by swapper/0.
[    0.102021] Modules linked in:
[    0.102024] Pid: 0, comm: swapper Not tainted 3.1.0-rc8 #99
[    0.102026] Call Trace:
[    0.102030]  [<ffffffff8103234e>] __schedule_bug+0x75/0x7a
[    0.102033]  [<ffffffff815c7d3a>] __schedule+0x95/0x686
[    0.102037]  [<ffffffff81100e6a>] ? kmem_cache_free+0x30/0xc4
[    0.102041]  [<ffffffff812925a6>] ? acpi_ps_free_op+0x27/0x29
[    0.102044]  [<ffffffff8103aac0>] __cond_resched+0x2a/0x36
[    0.102048]  [<ffffffff815c8388>] _cond_resched+0x1b/0x22
[    0.102051]  [<ffffffff812917fd>] acpi_ps_complete_op+0x26d/0x284
[    0.102055]  [<ffffffff81291fff>] acpi_ps_parse_loop+0x7eb/0x94c
[    0.102058]  [<ffffffff812913ae>] acpi_ps_parse_aml+0x98/0x27a
[    0.102062]  [<ffffffff8128f7bf>] acpi_ns_one_complete_parse+0xf7/0x114
[    0.102066]  [<ffffffff8128f80f>] acpi_ns_parse_table+0x33/0x38
[    0.102069]  [<ffffffff8128ce3b>] acpi_ns_load_table+0x4f/0x94
[    0.102073]  [<ffffffff8129401e>] acpi_load_tables+0xa6/0x167
[    0.102077]  [<ffffffff81cd666e>] acpi_early_init+0x6c/0xde
[    0.102081]  [<ffffffff81cacb0a>] start_kernel+0x36a/0x37f
[    0.102084]  [<ffffffff81cac2a6>] x86_64_start_reservations+0xb6/0xba
[    0.102088]  [<ffffffff81cac39c>] x86_64_start_kernel+0xf2/0xf9
[    0.106046] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.106052] no locks held by swapper/0.
[    0.106054] Modules linked in:
[    0.106057] Pid: 0, comm: swapper Not tainted 3.1.0-rc8 #99
[    0.106059] Call Trace:
[    0.106062]  [<ffffffff8103234e>] __schedule_bug+0x75/0x7a
[    0.106066]  [<ffffffff815c7d3a>] __schedule+0x95/0x686
[    0.106070]  [<ffffffff810ffbc8>] ? slab_free_hook+0x6c/0x74
[    0.106074]  [<ffffffff8103aac0>] __cond_resched+0x2a/0x36
[    0.106077]  [<ffffffff815c8388>] _cond_resched+0x1b/0x22
[    0.106080]  [<ffffffff812917fd>] acpi_ps_complete_op+0x26d/0x284
[    0.106084]  [<ffffffff81291fff>] acpi_ps_parse_loop+0x7eb/0x94c
[    0.106088]  [<ffffffff812913ae>] acpi_ps_parse_aml+0x98/0x27a
[    0.106091]  [<ffffffff8128f7bf>] acpi_ns_one_complete_parse+0xf7/0x114
[    0.106095]  [<ffffffff8128f80f>] acpi_ns_parse_table+0x33/0x38
[    0.106099]  [<ffffffff8128ce3b>] acpi_ns_load_table+0x4f/0x94
[    0.106103]  [<ffffffff8129401e>] acpi_load_tables+0xa6/0x167
[    0.106106]  [<ffffffff81cd666e>] acpi_early_init+0x6c/0xde
[    0.106110]  [<ffffffff81cacb0a>] start_kernel+0x36a/0x37f
[    0.106114]  [<ffffffff81cac2a6>] x86_64_start_reservations+0xb6/0xba
[    0.106118]  [<ffffffff81cac39c>] x86_64_start_kernel+0xf2/0xf9
[    0.110003] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.110010] no locks held by swapper/0.
[    0.110011] Modules linked in:
[    0.110014] Pid: 0, comm: swapper Not tainted 3.1.0-rc8 #99
[    0.110016] Call Trace:
[    0.110020]  [<ffffffff8103234e>] __schedule_bug+0x75/0x7a
[    0.110023]  [<ffffffff815c7d3a>] __schedule+0x95/0x686
[    0.110027]  [<ffffffff81100eb7>] ? kmem_cache_free+0x7d/0xc4
[    0.110031]  [<ffffffff812925a6>] ? acpi_ps_free_op+0x27/0x29
[    0.110034]  [<ffffffff8103aac0>] __cond_resched+0x2a/0x36
[    0.110038]  [<ffffffff815c8388>] _cond_resched+0x1b/0x22
[    0.110041]  [<ffffffff812917fd>] acpi_ps_complete_op+0x26d/0x284
[    0.110045]  [<ffffffff81291fff>] acpi_ps_parse_loop+0x7eb/0x94c
[    0.110048]  [<ffffffff812913ae>] acpi_ps_parse_aml+0x98/0x27a
[    0.110052]  [<ffffffff8128f7bf>] acpi_ns_one_complete_parse+0xf7/0x114
[    0.110056]  [<ffffffff8128f80f>] acpi_ns_parse_table+0x33/0x38
[    0.110060]  [<ffffffff8128ce3b>] acpi_ns_load_table+0x4f/0x94
[    0.110063]  [<ffffffff8129401e>] acpi_load_tables+0xa6/0x167
[    0.110067]  [<ffffffff81cd666e>] acpi_early_init+0x6c/0xde
[    0.110071]  [<ffffffff81cacb0a>] start_kernel+0x36a/0x37f
[    0.110074]  [<ffffffff81cac2a6>] x86_64_start_reservations+0xb6/0xba
[    0.110078]  [<ffffffff81cac39c>] x86_64_start_kernel+0xf2/0xf9
[    0.114028] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.114035] no locks held by swapper/0.
[    0.114036] Modules linked in:
[    0.114039] Pid: 0, comm: swapper Not tainted 3.1.0-rc8 #99
[    0.114041] Call Trace:
[    0.114045]  [<ffffffff8103234e>] __schedule_bug+0x75/0x7a
[    0.114048]  [<ffffffff815c7d3a>] __schedule+0x95/0x686
[    0.114052]  [<ffffffff81100e6a>] ? kmem_cache_free+0x30/0xc4
[    0.114056]  [<ffffffff812925a6>] ? acpi_ps_free_op+0x27/0x29
[    0.114060]  [<ffffffff8103aac0>] __cond_resched+0x2a/0x36
[    0.114063]  [<ffffffff815c8388>] _cond_resched+0x1b/0x22
[    0.114066]  [<ffffffff812917fd>] acpi_ps_complete_op+0x26d/0x284
[    0.114069]  [<ffffffff812924f2>] ? acpi_ps_init_op+0x9/0x13
[    0.114073]  [<ffffffff81291fff>] acpi_ps_parse_loop+0x7eb/0x94c
[    0.114077]  [<ffffffff812913ae>] acpi_ps_parse_aml+0x98/0x27a
[    0.114080]  [<ffffffff8128f7bf>] acpi_ns_one_complete_parse+0xf7/0x114
[    0.114084]  [<ffffffff8128f80f>] acpi_ns_parse_table+0x33/0x38
[    0.114088]  [<ffffffff8128ce3b>] acpi_ns_load_table+0x4f/0x94
[    0.114092]  [<ffffffff8129401e>] acpi_load_tables+0xa6/0x167
[    0.114095]  [<ffffffff81cd666e>] acpi_early_init+0x6c/0xde
[    0.114099]  [<ffffffff81cacb0a>] start_kernel+0x36a/0x37f
[    0.114103]  [<ffffffff81cac2a6>] x86_64_start_reservations+0xb6/0xba
[    0.114107]  [<ffffffff81cac39c>] x86_64_start_kernel+0xf2/0xf9
[    0.118004] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.118011] no locks held by swapper/0.
[    0.118012] Modules linked in:
[    0.118015] Pid: 0, comm: swapper Not tainted 3.1.0-rc8 #99
[    0.118017] Call Trace:
[    0.118021]  [<ffffffff8103234e>] __schedule_bug+0x75/0x7a
[    0.118024]  [<ffffffff815c7d3a>] __schedule+0x95/0x686
[    0.118029]  [<ffffffff81297d8b>] ? acpi_ut_create_generic_state+0x32/0x4f
[    0.118033]  [<ffffffff8103aac0>] __cond_resched+0x2a/0x36
[    0.118036]  [<ffffffff815c8388>] _cond_resched+0x1b/0x22
[    0.118039]  [<ffffffff8110058c>] slab_pre_alloc_hook.clone.28+0x3a/0x40
[    0.118043]  [<ffffffff81102fe5>] kmem_cache_alloc+0x29/0x12b
[    0.118047]  [<ffffffff812738ff>] ? acpi_os_release_object+0xe/0x12
[    0.118051]  [<ffffffff81297d8b>] acpi_ut_create_generic_state+0x32/0x4f
[    0.118055]  [<ffffffff812923ba>] acpi_ps_push_scope+0x27/0x7e
[    0.118058]  [<ffffffff81291f20>] acpi_ps_parse_loop+0x70c/0x94c
[    0.118062]  [<ffffffff812913ae>] acpi_ps_parse_aml+0x98/0x27a
[    0.118066]  [<ffffffff8128f7bf>] acpi_ns_one_complete_parse+0xf7/0x114
[    0.118069]  [<ffffffff8128f80f>] acpi_ns_parse_table+0x33/0x38
[    0.118073]  [<ffffffff8128ce3b>] acpi_ns_load_table+0x4f/0x94
[    0.118077]  [<ffffffff8129401e>] acpi_load_tables+0xa6/0x167
[    0.118080]  [<ffffffff81cd666e>] acpi_early_init+0x6c/0xde
[    0.118084]  [<ffffffff81cacb0a>] start_kernel+0x36a/0x37f
[    0.118088]  [<ffffffff81cac2a6>] x86_64_start_reservations+0xb6/0xba
[    0.118092]  [<ffffffff81cac39c>] x86_64_start_kernel+0xf2/0xf9
[    0.122019] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.122026] no locks held by swapper/0.
[    0.122027] Modules linked in:
[    0.122030] Pid: 0, comm: swapper Not tainted 3.1.0-rc8 #99
[    0.122032] Call Trace:
[    0.122036]  [<ffffffff8103234e>] __schedule_bug+0x75/0x7a
[    0.122039]  [<ffffffff815c7d3a>] __schedule+0x95/0x686
[    0.122044]  [<ffffffff81297d8b>] ? acpi_ut_create_generic_state+0x32/0x4f
[    0.122047]  [<ffffffff8103aac0>] __cond_resched+0x2a/0x36
[    0.122051]  [<ffffffff815c8388>] _cond_resched+0x1b/0x22
[    0.122054]  [<ffffffff8110058c>] slab_pre_alloc_hook.clone.28+0x3a/0x40
[    0.122058]  [<ffffffff81102fe5>] kmem_cache_alloc+0x29/0x12b
[    0.122062]  [<ffffffff812738ff>] ? acpi_os_release_object+0xe/0x12
[    0.122066]  [<ffffffff81297d8b>] acpi_ut_create_generic_state+0x32/0x4f
[    0.122069]  [<ffffffff812923ba>] acpi_ps_push_scope+0x27/0x7e
[    0.122072]  [<ffffffff81291f20>] acpi_ps_parse_loop+0x70c/0x94c
[    0.122076]  [<ffffffff812913ae>] acpi_ps_parse_aml+0x98/0x27a
[    0.122080]  [<ffffffff8128f7bf>] acpi_ns_one_complete_parse+0xf7/0x114
[    0.122084]  [<ffffffff8128f80f>] acpi_ns_parse_table+0x33/0x38
[    0.122087]  [<ffffffff8128ce3b>] acpi_ns_load_table+0x4f/0x94
[    0.122091]  [<ffffffff8129401e>] acpi_load_tables+0xa6/0x167
[    0.122095]  [<ffffffff81cd666e>] acpi_early_init+0x6c/0xde
[    0.122098]  [<ffffffff81cacb0a>] start_kernel+0x36a/0x37f
[    0.122102]  [<ffffffff81cac2a6>] x86_64_start_reservations+0xb6/0xba
[    0.122106]  [<ffffffff81cac39c>] x86_64_start_kernel+0xf2/0xf9
[    0.125997] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.126004] no locks held by swapper/0.
[    0.126005] Modules linked in:
[    0.126008] Pid: 0, comm: swapper Not tainted 3.1.0-rc8 #99
[    0.126010] Call Trace:
[    0.126014]  [<ffffffff8103234e>] __schedule_bug+0x75/0x7a
[    0.126018]  [<ffffffff815c7d3a>] __schedule+0x95/0x686
[    0.126022]  [<ffffffff81297a1b>] ? acpi_ut_allocate_object_desc_dbg+0x3b/0x73
[    0.126026]  [<ffffffff8103aac0>] __cond_resched+0x2a/0x36
[    0.126029]  [<ffffffff815c8388>] _cond_resched+0x1b/0x22
[    0.126033]  [<ffffffff8110058c>] slab_pre_alloc_hook.clone.28+0x3a/0x40
[    0.126036]  [<ffffffff81102fe5>] kmem_cache_alloc+0x29/0x12b
[    0.126040]  [<ffffffff81297a1b>] acpi_ut_allocate_object_desc_dbg+0x3b/0x73
[    0.126044]  [<ffffffff81297acb>] acpi_ut_create_internal_object_dbg+0x27/0x8f
[    0.126049]  [<ffffffff8127d7fc>] acpi_ds_create_buffer_field+0x104/0x14e
[    0.126053]  [<ffffffff812816be>] acpi_ds_load2_end_op+0x96/0x360
[    0.126056]  [<ffffffff812917fd>] ? acpi_ps_complete_op+0x26d/0x284
[    0.126059]  [<ffffffff812924f2>] ? acpi_ps_init_op+0x9/0x13
[    0.126063]  [<ffffffff81292299>] ? acpi_ps_get_opcode_info+0x9/0x49
[    0.126066]  [<ffffffff81291fd1>] acpi_ps_parse_loop+0x7bd/0x94c
[    0.126070]  [<ffffffff812913ae>] acpi_ps_parse_aml+0x98/0x27a
[    0.126074]  [<ffffffff8128f7bf>] acpi_ns_one_complete_parse+0xf7/0x114
[    0.126077]  [<ffffffff8128f80f>] acpi_ns_parse_table+0x33/0x38
[    0.126081]  [<ffffffff8128ce3b>] acpi_ns_load_table+0x4f/0x94
[    0.126085]  [<ffffffff8129401e>] acpi_load_tables+0xa6/0x167
[    0.126088]  [<ffffffff81cd666e>] acpi_early_init+0x6c/0xde
[    0.126092]  [<ffffffff81cacb0a>] start_kernel+0x36a/0x37f
[    0.126096]  [<ffffffff81cac2a6>] x86_64_start_reservations+0xb6/0xba
[    0.126100]  [<ffffffff81cac39c>] x86_64_start_kernel+0xf2/0xf9
[    0.130013] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.130020] no locks held by swapper/0.
[    0.130021] Modules linked in:
[    0.130024] Pid: 0, comm: swapper Not tainted 3.1.0-rc8 #99
[    0.130026] Call Trace:
[    0.130030]  [<ffffffff8103234e>] __schedule_bug+0x75/0x7a
[    0.130034]  [<ffffffff815c7d3a>] __schedule+0x95/0x686
[    0.130037]  [<ffffffff810ffbc8>] ? slab_free_hook+0x6c/0x74
[    0.130041]  [<ffffffff8103aac0>] __cond_resched+0x2a/0x36
[    0.130044]  [<ffffffff815c8388>] _cond_resched+0x1b/0x22
[    0.130048]  [<ffffffff812917fd>] acpi_ps_complete_op+0x26d/0x284
[    0.130051]  [<ffffffff81291fff>] acpi_ps_parse_loop+0x7eb/0x94c
[    0.130055]  [<ffffffff812913ae>] acpi_ps_parse_aml+0x98/0x27a
[    0.130058]  [<ffffffff8128f7bf>] acpi_ns_one_complete_parse+0xf7/0x114
[    0.130062]  [<ffffffff8128f80f>] acpi_ns_parse_table+0x33/0x38
[    0.130066]  [<ffffffff8128ce3b>] acpi_ns_load_table+0x4f/0x94
[    0.130069]  [<ffffffff8129401e>] acpi_load_tables+0xa6/0x167
[    0.130073]  [<ffffffff81cd666e>] acpi_early_init+0x6c/0xde
[    0.130077]  [<ffffffff81cacb0a>] start_kernel+0x36a/0x37f
[    0.130081]  [<ffffffff81cac2a6>] x86_64_start_reservations+0xb6/0xba
[    0.130084]  [<ffffffff81cac39c>] x86_64_start_kernel+0xf2/0xf9
[    0.134025] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.134032] no locks held by swapper/0.
[    0.134034] Modules linked in:
[    0.134037] Pid: 0, comm: swapper Not tainted 3.1.0-rc8 #99
[    0.134039] Call Trace:
[    0.134043]  [<ffffffff8103234e>] __schedule_bug+0x75/0x7a
[    0.134046]  [<ffffffff815c7d3a>] __schedule+0x95/0x686
[    0.134050]  [<ffffffff810ffbc8>] ? slab_free_hook+0x6c/0x74
[    0.134054]  [<ffffffff8103aac0>] __cond_resched+0x2a/0x36
[    0.134057]  [<ffffffff815c8388>] _cond_resched+0x1b/0x22
[    0.134060]  [<ffffffff812917fd>] acpi_ps_complete_op+0x26d/0x284
[    0.134064]  [<ffffffff81291fff>] acpi_ps_parse_loop+0x7eb/0x94c
[    0.134068]  [<ffffffff812913ae>] acpi_ps_parse_aml+0x98/0x27a
[    0.134072]  [<ffffffff8128f7bf>] acpi_ns_one_complete_parse+0xf7/0x114
[    0.134075]  [<ffffffff8128f80f>] acpi_ns_parse_table+0x33/0x38
[    0.134079]  [<ffffffff8128ce3b>] acpi_ns_load_table+0x4f/0x94
[    0.134083]  [<ffffffff8129401e>] acpi_load_tables+0xa6/0x167
[    0.134087]  [<ffffffff81cd666e>] acpi_early_init+0x6c/0xde
[    0.134090]  [<ffffffff81cacb0a>] start_kernel+0x36a/0x37f
[    0.134094]  [<ffffffff81cac2a6>] x86_64_start_reservations+0xb6/0xba
[    0.134098]  [<ffffffff81cac39c>] x86_64_start_kernel+0xf2/0xf9
[    0.137997] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.138003] no locks held by swapper/0.
[    0.138005] Modules linked in:
[    0.138008] Pid: 0, comm: swapper Not tainted 3.1.0-rc8 #99
[    0.138010] Call Trace:
[    0.138014]  [<ffffffff8103234e>] __schedule_bug+0x75/0x7a
[    0.138017]  [<ffffffff815c7d3a>] __schedule+0x95/0x686
[    0.138021]  [<ffffffff810ffbc8>] ? slab_free_hook+0x6c/0x74
[    0.138025]  [<ffffffff8103aac0>] __cond_resched+0x2a/0x36
[    0.138028]  [<ffffffff815c8388>] _cond_resched+0x1b/0x22
[    0.138032]  [<ffffffff812917fd>] acpi_ps_complete_op+0x26d/0x284
[    0.138035]  [<ffffffff81291fff>] acpi_ps_parse_loop+0x7eb/0x94c
[    0.138039]  [<ffffffff812913ae>] acpi_ps_parse_aml+0x98/0x27a
[    0.138043]  [<ffffffff8128f7bf>] acpi_ns_one_complete_parse+0xf7/0x114
[    0.138046]  [<ffffffff8128f80f>] acpi_ns_parse_table+0x33/0x38
[    0.138050]  [<ffffffff8128ce3b>] acpi_ns_load_table+0x4f/0x94
[    0.138054]  [<ffffffff8129401e>] acpi_load_tables+0xa6/0x167
[    0.138058]  [<ffffffff81cd666e>] acpi_early_init+0x6c/0xde
[    0.138061]  [<ffffffff81cacb0a>] start_kernel+0x36a/0x37f
[    0.138065]  [<ffffffff81cac2a6>] x86_64_start_reservations+0xb6/0xba
[    0.138069]  [<ffffffff81cac39c>] x86_64_start_kernel+0xf2/0xf9
[    0.141999] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.142005] no locks held by swapper/0.
[    0.142007] Modules linked in:
[    0.142010] Pid: 0, comm: swapper Not tainted 3.1.0-rc8 #99
[    0.142012] Call Trace:
[    0.142015]  [<ffffffff8103234e>] __schedule_bug+0x75/0x7a
[    0.142019]  [<ffffffff815c7d3a>] __schedule+0x95/0x686
[    0.142023]  [<ffffffff81071765>] ? trace_hardirqs_on+0xd/0xf
[    0.142027]  [<ffffffff81297d8b>] ? acpi_ut_create_generic_state+0x32/0x4f
[    0.142030]  [<ffffffff812924e7>] ? acpi_os_acquire_object+0x2b/0x2d
[    0.142034]  [<ffffffff8103aac0>] __cond_resched+0x2a/0x36
[    0.142037]  [<ffffffff815c8388>] _cond_resched+0x1b/0x22
[    0.142041]  [<ffffffff8110058c>] slab_pre_alloc_hook.clone.28+0x3a/0x40
[    0.142045]  [<ffffffff812738ff>] ? acpi_os_release_object+0xe/0x12
[    0.142048]  [<ffffffff81102fe5>] kmem_cache_alloc+0x29/0x12b
[    0.142052]  [<ffffffff812924e7>] acpi_os_acquire_object+0x2b/0x2d
[    0.142055]  [<ffffffff8129255c>] acpi_ps_alloc_op+0x60/0x62
[    0.142058]  [<ffffffff81291a47>] acpi_ps_parse_loop+0x233/0x94c
[    0.142062]  [<ffffffff812913ae>] acpi_ps_parse_aml+0x98/0x27a
[    0.142066]  [<ffffffff8128f7bf>] acpi_ns_one_complete_parse+0xf7/0x114
[    0.142070]  [<ffffffff8128f80f>] acpi_ns_parse_table+0x33/0x38
[    0.142073]  [<ffffffff8128ce3b>] acpi_ns_load_table+0x4f/0x94
[    0.142077]  [<ffffffff8129401e>] acpi_load_tables+0xa6/0x167
[    0.142081]  [<ffffffff81cd666e>] acpi_early_init+0x6c/0xde
[    0.142084]  [<ffffffff81cacb0a>] start_kernel+0x36a/0x37f
[    0.142088]  [<ffffffff81cac2a6>] x86_64_start_reservations+0xb6/0xba
[    0.142092]  [<ffffffff81cac39c>] x86_64_start_kernel+0xf2/0xf9
[    0.146217] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.146224] no locks held by swapper/0.
[    0.146226] Modules linked in:
[    0.146229] Pid: 0, comm: swapper Not tainted 3.1.0-rc8 #99
[    0.146231] Call Trace:
[    0.146234]  [<ffffffff8103234e>] __schedule_bug+0x75/0x7a
[    0.146238]  [<ffffffff815c7d3a>] __schedule+0x95/0x686
[    0.146241]  [<ffffffff81100e6a>] ? kmem_cache_free+0x30/0xc4
[    0.146245]  [<ffffffff812925a6>] ? acpi_ps_free_op+0x27/0x29
[    0.146249]  [<ffffffff8103aac0>] __cond_resched+0x2a/0x36
[    0.146252]  [<ffffffff815c8388>] _cond_resched+0x1b/0x22
[    0.146255]  [<ffffffff812917fd>] acpi_ps_complete_op+0x26d/0x284
[    0.146259]  [<ffffffff81291fff>] acpi_ps_parse_loop+0x7eb/0x94c
[    0.146263]  [<ffffffff812913ae>] acpi_ps_parse_aml+0x98/0x27a
[    0.146266]  [<ffffffff8128f7bf>] acpi_ns_one_complete_parse+0xf7/0x114
[    0.146270]  [<ffffffff8128f80f>] acpi_ns_parse_table+0x33/0x38
[    0.146274]  [<ffffffff8128ce3b>] acpi_ns_load_table+0x4f/0x94
[    0.146278]  [<ffffffff8129401e>] acpi_load_tables+0xa6/0x167
[    0.146281]  [<ffffffff81cd666e>] acpi_early_init+0x6c/0xde
[    0.146285]  [<ffffffff81cacb0a>] start_kernel+0x36a/0x37f
[    0.146289]  [<ffffffff81cac2a6>] x86_64_start_reservations+0xb6/0xba
[    0.146293]  [<ffffffff81cac39c>] x86_64_start_kernel+0xf2/0xf9
[    0.149998] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.150004] no locks held by swapper/0.
[    0.150006] Modules linked in:
[    0.150009] Pid: 0, comm: swapper Not tainted 3.1.0-rc8 #99
[    0.150011] Call Trace:
[    0.150014]  [<ffffffff8103234e>] __schedule_bug+0x75/0x7a
[    0.150018]  [<ffffffff815c7d3a>] __schedule+0x95/0x686
[    0.150022]  [<ffffffff810ffbc8>] ? slab_free_hook+0x6c/0x74
[    0.150026]  [<ffffffff8103aac0>] __cond_resched+0x2a/0x36
[    0.150029]  [<ffffffff815c8388>] _cond_resched+0x1b/0x22
[    0.150032]  [<ffffffff812917fd>] acpi_ps_complete_op+0x26d/0x284
[    0.150036]  [<ffffffff81291fff>] acpi_ps_parse_loop+0x7eb/0x94c
[    0.150040]  [<ffffffff812913ae>] acpi_ps_parse_aml+0x98/0x27a
[    0.150043]  [<ffffffff8128f7bf>] acpi_ns_one_complete_parse+0xf7/0x114
[    0.150047]  [<ffffffff8128f80f>] acpi_ns_parse_table+0x33/0x38
[    0.150051]  [<ffffffff8128ce3b>] acpi_ns_load_table+0x4f/0x94
[    0.150055]  [<ffffffff8129401e>] acpi_load_tables+0xa6/0x167
[    0.150058]  [<ffffffff81cd666e>] acpi_early_init+0x6c/0xde
[    0.150062]  [<ffffffff81cacb0a>] start_kernel+0x36a/0x37f
[    0.150066]  [<ffffffff81cac2a6>] x86_64_start_reservations+0xb6/0xba
[    0.150070]  [<ffffffff81cac39c>] x86_64_start_kernel+0xf2/0xf9
[    0.154038] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.154044] no locks held by swapper/0.
[    0.154046] Modules linked in:
[    0.154049] Pid: 0, comm: swapper Not tainted 3.1.0-rc8 #99
[    0.154051] Call Trace:
[    0.154055]  [<ffffffff8103234e>] __schedule_bug+0x75/0x7a
[    0.154058]  [<ffffffff815c7d3a>] __schedule+0x95/0x686
[    0.154062]  [<ffffffff81100e6a>] ? kmem_cache_free+0x30/0xc4
[    0.154065]  [<ffffffff812925a6>] ? acpi_ps_free_op+0x27/0x29
[    0.154069]  [<ffffffff8103aac0>] __cond_resched+0x2a/0x36
[    0.154073]  [<ffffffff815c8388>] _cond_resched+0x1b/0x22
[    0.154076]  [<ffffffff812917fd>] acpi_ps_complete_op+0x26d/0x284
[    0.154079]  [<ffffffff81291fff>] acpi_ps_parse_loop+0x7eb/0x94c
[    0.154083]  [<ffffffff812913ae>] acpi_ps_parse_aml+0x98/0x27a
[    0.154087]  [<ffffffff8128f7bf>] acpi_ns_one_complete_parse+0xf7/0x114
[    0.154091]  [<ffffffff8128f80f>] acpi_ns_parse_table+0x33/0x38
[    0.154094]  [<ffffffff8128ce3b>] acpi_ns_load_table+0x4f/0x94
[    0.154098]  [<ffffffff8129401e>] acpi_load_tables+0xa6/0x167
[    0.154102]  [<ffffffff81cd666e>] acpi_early_init+0x6c/0xde
[    0.154105]  [<ffffffff81cacb0a>] start_kernel+0x36a/0x37f
[    0.154109]  [<ffffffff81cac2a6>] x86_64_start_reservations+0xb6/0xba
[    0.154113]  [<ffffffff81cac39c>] x86_64_start_kernel+0xf2/0xf9
[    0.158034] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.158040] no locks held by swapper/0.
[    0.158042] Modules linked in:
[    0.158045] Pid: 0, comm: swapper Not tainted 3.1.0-rc8 #99
[    0.158046] Call Trace:
[    0.158050]  [<ffffffff8103234e>] __schedule_bug+0x75/0x7a
[    0.158054]  [<ffffffff815c7d3a>] __schedule+0x95/0x686
[    0.158057]  [<ffffffff81100e6a>] ? kmem_cache_free+0x30/0xc4
[    0.158061]  [<ffffffff812925a6>] ? acpi_ps_free_op+0x27/0x29
[    0.158065]  [<ffffffff8103aac0>] __cond_resched+0x2a/0x36
[    0.158068]  [<ffffffff815c8388>] _cond_resched+0x1b/0x22
[    0.158071]  [<ffffffff812917fd>] acpi_ps_complete_op+0x26d/0x284
[    0.158075]  [<ffffffff812924f2>] ? acpi_ps_init_op+0x9/0x13
[    0.158078]  [<ffffffff81291fff>] acpi_ps_parse_loop+0x7eb/0x94c
[    0.158082]  [<ffffffff812913ae>] acpi_ps_parse_aml+0x98/0x27a
[    0.158086]  [<ffffffff8128f7bf>] acpi_ns_one_complete_parse+0xf7/0x114
[    0.158089]  [<ffffffff8128f80f>] acpi_ns_parse_table+0x33/0x38
[    0.158093]  [<ffffffff8128ce3b>] acpi_ns_load_table+0x4f/0x94
[    0.158097]  [<ffffffff8129401e>] acpi_load_tables+0xa6/0x167
[    0.158100]  [<ffffffff81cd666e>] acpi_early_init+0x6c/0xde
[    0.158104]  [<ffffffff81cacb0a>] start_kernel+0x36a/0x37f
[    0.158108]  [<ffffffff81cac2a6>] x86_64_start_reservations+0xb6/0xba
[    0.158112]  [<ffffffff81cac39c>] x86_64_start_kernel+0xf2/0xf9
[    0.162040] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.162047] no locks held by swapper/0.
[    0.162049] Modules linked in:
[    0.162052] Pid: 0, comm: swapper Not tainted 3.1.0-rc8 #99
[    0.162053] Call Trace:
[    0.162057]  [<ffffffff8103234e>] __schedule_bug+0x75/0x7a
[    0.162061]  [<ffffffff815c7d3a>] __schedule+0x95/0x686
[    0.162064]  [<ffffffff810ffbc8>] ? slab_free_hook+0x6c/0x74
[    0.162068]  [<ffffffff8103aac0>] __cond_resched+0x2a/0x36
[    0.162072]  [<ffffffff815c8388>] _cond_resched+0x1b/0x22
[    0.162075]  [<ffffffff812917fd>] acpi_ps_complete_op+0x26d/0x284
[    0.162079]  [<ffffffff812924f2>] ? acpi_ps_init_op+0x9/0x13
[    0.162082]  [<ffffffff81291fff>] acpi_ps_parse_loop+0x7eb/0x94c
[    0.162086]  [<ffffffff812913ae>] acpi_ps_parse_aml+0x98/0x27a
[    0.162090]  [<ffffffff8128f7bf>] acpi_ns_one_complete_parse+0xf7/0x114
[    0.162093]  [<ffffffff8128f80f>] acpi_ns_parse_table+0x33/0x38
[    0.162097]  [<ffffffff8128ce3b>] acpi_ns_load_table+0x4f/0x94
[    0.162101]  [<ffffffff8129401e>] acpi_load_tables+0xa6/0x167
[    0.162104]  [<ffffffff81cd666e>] acpi_early_init+0x6c/0xde
[    0.162108]  [<ffffffff81cacb0a>] start_kernel+0x36a/0x37f
[    0.162112]  [<ffffffff81cac2a6>] x86_64_start_reservations+0xb6/0xba
[    0.162116]  [<ffffffff81cac39c>] x86_64_start_kernel+0xf2/0xf9
[    0.165993] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.165999] no locks held by swapper/0.
[    0.166001] Modules linked in:
[    0.166004] Pid: 0, comm: swapper Not tainted 3.1.0-rc8 #99
[    0.166006] Call Trace:
[    0.166009]  [<ffffffff8103234e>] __schedule_bug+0x75/0x7a
[    0.166013]  [<ffffffff815c7d3a>] __schedule+0x95/0x686
[    0.166017]  [<ffffffff812924e7>] ? acpi_os_acquire_object+0x2b/0x2d
[    0.166021]  [<ffffffff8103aac0>] __cond_resched+0x2a/0x36
[    0.166024]  [<ffffffff815c8388>] _cond_resched+0x1b/0x22
[    0.166028]  [<ffffffff8110058c>] slab_pre_alloc_hook.clone.28+0x3a/0x40
[    0.166031]  [<ffffffff81102fe5>] kmem_cache_alloc+0x29/0x12b
[    0.166035]  [<ffffffff812924e7>] acpi_os_acquire_object+0x2b/0x2d
[    0.166038]  [<ffffffff8129255c>] acpi_ps_alloc_op+0x60/0x62
[    0.166042]  [<ffffffff81290de6>] acpi_ps_get_next_arg+0x42/0x2bc
[    0.166045]  [<ffffffff81100e6a>] ? kmem_cache_free+0x30/0xc4
[    0.166049]  [<ffffffff81291d0e>] acpi_ps_parse_loop+0x4fa/0x94c
[    0.166053]  [<ffffffff812913ae>] acpi_ps_parse_aml+0x98/0x27a
[    0.166056]  [<ffffffff8128f7bf>] acpi_ns_one_complete_parse+0xf7/0x114
[    0.166060]  [<ffffffff8128f80f>] acpi_ns_parse_table+0x33/0x38
[    0.166064]  [<ffffffff8128ce3b>] acpi_ns_load_table+0x4f/0x94
[    0.166067]  [<ffffffff8129401e>] acpi_load_tables+0xa6/0x167
[    0.166071]  [<ffffffff81cd666e>] acpi_early_init+0x6c/0xde
[    0.166075]  [<ffffffff81cacb0a>] start_kernel+0x36a/0x37f
[    0.166079]  [<ffffffff81cac2a6>] x86_64_start_reservations+0xb6/0xba
[    0.166082]  [<ffffffff81cac39c>] x86_64_start_kernel+0xf2/0xf9
[    0.170002] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.170009] no locks held by swapper/0.
[    0.170010] Modules linked in:
[    0.170013] Pid: 0, comm: swapper Not tainted 3.1.0-rc8 #99
[    0.170015] Call Trace:
[    0.170019]  [<ffffffff8103234e>] __schedule_bug+0x75/0x7a
[    0.170023]  [<ffffffff815c7d3a>] __schedule+0x95/0x686
[    0.170026]  [<ffffffff810ffbc8>] ? slab_free_hook+0x6c/0x74
[    0.170030]  [<ffffffff8103aac0>] __cond_resched+0x2a/0x36
[    0.170033]  [<ffffffff815c8388>] _cond_resched+0x1b/0x22
[    0.170037]  [<ffffffff812917fd>] acpi_ps_complete_op+0x26d/0x284
[    0.170041]  [<ffffffff81291fff>] acpi_ps_parse_loop+0x7eb/0x94c
[    0.170044]  [<ffffffff812913ae>] acpi_ps_parse_aml+0x98/0x27a
[    0.170048]  [<ffffffff8128f7bf>] acpi_ns_one_complete_parse+0xf7/0x114
[    0.170052]  [<ffffffff8128f7fc>] acpi_ns_parse_table+0x20/0x38
[    0.170056]  [<ffffffff8128ce3b>] acpi_ns_load_table+0x4f/0x94
[    0.170059]  [<ffffffff81294091>] acpi_load_tables+0x119/0x167
[    0.170063]  [<ffffffff81cd666e>] acpi_early_init+0x6c/0xde
[    0.170067]  [<ffffffff81cacb0a>] start_kernel+0x36a/0x37f
[    0.170071]  [<ffffffff81cac2a6>] x86_64_start_reservations+0xb6/0xba
[    0.170074]  [<ffffffff81cac39c>] x86_64_start_kernel+0xf2/0xf9
[    0.173991] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.173998] no locks held by swapper/0.
[    0.173999] Modules linked in:
[    0.174002] Pid: 0, comm: swapper Not tainted 3.1.0-rc8 #99
[    0.174004] Call Trace:
[    0.174008]  [<ffffffff8103234e>] __schedule_bug+0x75/0x7a
[    0.174012]  [<ffffffff815c7d3a>] __schedule+0x95/0x686
[    0.174016]  [<ffffffff8106e002>] ? lock_release_holdtime+0x59/0x60
[    0.174020]  [<ffffffff81071721>] ? trace_hardirqs_on_caller+0x121/0x158
[    0.174024]  [<ffffffff8103aac0>] __cond_resched+0x2a/0x36
[    0.174027]  [<ffffffff815c8388>] _cond_resched+0x1b/0x22
[    0.174030]  [<ffffffff815c9115>] mutex_lock_nested+0x2a/0x45
[    0.174034]  [<ffffffff815adc75>] acpi_os_map_memory+0x37/0x10e
[    0.174038]  [<ffffffff812943fa>] acpi_tb_verify_table+0x2e/0x5b
[    0.174041]  [<ffffffff81293f3d>] acpi_get_table_by_index+0x50/0x8b
[    0.174045]  [<ffffffff81294ac1>] acpi_tb_initialize_facs+0x1a/0x1c
[    0.174049]  [<ffffffff8129693f>] acpi_enable_subsystem+0x3c/0x91
[    0.174053]  [<ffffffff81cd66c7>] acpi_early_init+0xc5/0xde
[    0.174056]  [<ffffffff81cacb0a>] start_kernel+0x36a/0x37f
[    0.174060]  [<ffffffff81cac2a6>] x86_64_start_reservations+0xb6/0xba
[    0.174064]  [<ffffffff81cac39c>] x86_64_start_kernel+0xf2/0xf9
[    0.174111] ftrace: allocating 30073 entries in 118 pages
[    0.176878] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.186918] CPU0: Intel(R) Core(TM)2 Duo CPU     T8300  @ 2.40GHz stepping 06
[    0.186980] Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
[    0.186980] ... version:                2
[    0.186980] ... bit width:              40
[    0.186980] ... generic registers:      2
[    0.186980] ... value mask:             000000ffffffffff
[    0.186980] ... max period:             000000007fffffff
[    0.186980] ... fixed-purpose events:   3
[    0.186980] ... event mask:             0000000700000003
[    0.187382] NMI watchdog enabled, takes one hw-pmu counter.
[    0.210316] lockdep: fixing up alternatives.
[    0.237239] Booting Node   0, Processors  #1 Ok.
[    0.237243] smpboot cpu 1: start_ip = 9a000
[    0.309100] NMI watchdog enabled, takes one hw-pmu counter.
[    0.309239] Brought up 2 CPUs
[    0.309242] Total of 2 processors activated (9571.93 BogoMIPS).
[    0.312313] devtmpfs: initialized
[    0.313242] kworker/u:0 used greatest stack depth: 5272 bytes left
[    0.313345] kworker/u:0 used greatest stack depth: 5208 bytes left
[    0.317712] RTC time: 21:05:43, date: 10/04/11
[    0.318291] NET: Registered protocol family 16
[    0.325906] ACPI: bus type pci registered
[    0.327438] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.327442] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.355256] PCI: Using configuration type 1 for base access
[    0.355265] dmi type 0xB1 record - unknown flag
[    0.507190] bio: create slab <bio-0> at 0
[    0.509264] ACPI: Added _OSI(Module Device)
[    0.509264] ACPI: Added _OSI(Processor Device)
[    0.509264] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.509264] ACPI: Added _OSI(Processor Aggregator Device)
[    0.516655] ACPI: EC: Look up EC in DSDT
[    0.601197] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.650373] ACPI: SSDT 00000000bfe82880 00043 (v01  LMPWR  DELLLOM 00001001 INTL 20050624)
[    0.652635] ACPI: Dynamic OEM Table Load:
[    0.652639] ACPI: SSDT           (null) 00043 (v01  LMPWR  DELLLOM 00001001 INTL 20050624)
[    0.665633] ACPI: SSDT 00000000bfe72cb4 002C8 (v01  PmRef  Cpu0Ist 00003000 INTL 20050624)
[    0.668564] ACPI: Dynamic OEM Table Load:
[    0.668568] ACPI: SSDT           (null) 002C8 (v01  PmRef  Cpu0Ist 00003000 INTL 20050624)
[    0.674256] ACPI: SSDT 00000000bfe7264a 005E5 (v01  PmRef  Cpu0Cst 00003001 INTL 20050624)
[    0.676530] ACPI: Dynamic OEM Table Load:
[    0.676534] ACPI: SSDT           (null) 005E5 (v01  PmRef  Cpu0Cst 00003001 INTL 20050624)
[    0.689350] ACPI: SSDT 00000000bfe72f7c 000C4 (v01  PmRef  Cpu1Ist 00003000 INTL 20050624)
[    0.691863] ACPI: Dynamic OEM Table Load:
[    0.691867] ACPI: SSDT           (null) 000C4 (v01  PmRef  Cpu1Ist 00003000 INTL 20050624)
[    0.697578] ACPI: SSDT 00000000bfe72c2f 00085 (v01  PmRef  Cpu1Cst 00003000 INTL 20050624)
[    0.699835] ACPI: Dynamic OEM Table Load:
[    0.699839] ACPI: SSDT           (null) 00085 (v01  PmRef  Cpu1Cst 00003000 INTL 20050624)
[    0.706634] ACPI: Interpreter enabled
[    0.706639] ACPI: (supports S0 S3 S4 S5)
[    0.707743] ACPI: Using IOAPIC for interrupt routing
[    1.327089] ACPI: No dock devices found.
[    1.327094] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    1.593477] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    2.101038] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
[    2.101042] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
[    2.101045] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
[    2.101047] pci_root PNP0A03:00: host bridge window [mem 0x000d0000-0x000dffff]
[    2.101050] pci_root PNP0A03:00: host bridge window [mem 0xc0000000-0xf7ffffff]
[    2.101053] pci_root PNP0A03:00: host bridge window [mem 0xfc000000-0xfebfffff]
[    2.101055] pci_root PNP0A03:00: host bridge window [mem 0xfec10000-0xfecfffff]
[    2.101058] pci_root PNP0A03:00: host bridge window [mem 0xfed1c000-0xfed1ffff]
[    2.101060] pci_root PNP0A03:00: host bridge window [mem 0xfed90000-0xfed9ffff]
[    2.101063] pci_root PNP0A03:00: host bridge window [mem 0xfeda7000-0xfedfffff]
[    2.101066] pci_root PNP0A03:00: host bridge window [mem 0xfee10000-0xff9fffff]
[    2.101068] pci_root PNP0A03:00: host bridge window [mem 0xffc00000-0xffdfffff]
[    2.101071] pci_root PNP0A03:00: host bridge window [mem 0x140000000-0x337ffffff]
[    2.101257] pci 0000:00:00.0: [8086:2a00] type 0 class 0x000600
[    2.101407] pci 0000:00:01.0: [8086:2a01] type 1 class 0x000604
[    2.101502] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    2.101508] pci 0000:00:01.0: PME# disabled
[    2.101621] pci 0000:00:1a.0: [8086:2834] type 0 class 0x000c03
[    2.101987] pci 0000:00:1a.0: reg 20: [io  0x6f20-0x6f3f]
[    2.102203] pci 0000:00:1a.1: [8086:2835] type 0 class 0x000c03
[    2.102295] pci 0000:00:1a.1: reg 20: [io  0x6f00-0x6f1f]
[    2.102402] pci 0000:00:1a.7: [8086:283a] type 0 class 0x000c03
[    2.102440] pci 0000:00:1a.7: reg 10: [mem 0xfed1c400-0xfed1c7ff]
[    2.102586] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    2.102594] pci 0000:00:1a.7: PME# disabled
[    2.102657] pci 0000:00:1b.0: [8086:284b] type 0 class 0x000403
[    2.102700] pci 0000:00:1b.0: reg 10: [mem 0xf7ffc000-0xf7ffffff 64bit]
[    2.102844] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    2.102851] pci 0000:00:1b.0: PME# disabled
[    2.102914] pci 0000:00:1c.0: [8086:283f] type 1 class 0x000604
[    2.103062] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    2.103069] pci 0000:00:1c.0: PME# disabled
[    2.103154] pci 0000:00:1c.1: [8086:2841] type 1 class 0x000604
[    2.103301] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    2.103308] pci 0000:00:1c.1: PME# disabled
[    2.103378] pci 0000:00:1c.3: [8086:2845] type 1 class 0x000604
[    2.103525] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    2.103532] pci 0000:00:1c.3: PME# disabled
[    2.103598] pci 0000:00:1c.4: [8086:2847] type 1 class 0x000604
[    2.104186] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    2.104193] pci 0000:00:1c.4: PME# disabled
[    2.104260] pci 0000:00:1c.5: [8086:2849] type 1 class 0x000604
[    2.104407] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    2.104414] pci 0000:00:1c.5: PME# disabled
[    2.104477] pci 0000:00:1d.0: [8086:2830] type 0 class 0x000c03
[    2.104569] pci 0000:00:1d.0: reg 20: [io  0x6f80-0x6f9f]
[    2.104650] pci 0000:00:1d.1: [8086:2831] type 0 class 0x000c03
[    2.104750] pci 0000:00:1d.1: reg 20: [io  0x6f60-0x6f7f]
[    2.104830] pci 0000:00:1d.2: [8086:2832] type 0 class 0x000c03
[    2.104921] pci 0000:00:1d.2: reg 20: [io  0x6f40-0x6f5f]
[    2.105025] pci 0000:00:1d.7: [8086:2836] type 0 class 0x000c03
[    2.105063] pci 0000:00:1d.7: reg 10: [mem 0xfed1c000-0xfed1c3ff]
[    2.105209] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    2.105217] pci 0000:00:1d.7: PME# disabled
[    2.105271] pci 0000:00:1e.0: [8086:2448] type 1 class 0x000604
[    2.105425] pci 0000:00:1f.0: [8086:2811] type 0 class 0x000601
[    2.105594] pci 0000:00:1f.0: quirk: [io  0x1000-0x107f] claimed by ICH6 ACPI/GPIO/TCO
[    2.105603] pci 0000:00:1f.0: quirk: [io  0x1080-0x10bf] claimed by ICH6 GPIO
[    2.105609] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0900 (mask 007f)
[    2.105617] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 0c80 (mask 003f)
[    2.105802] pci 0000:00:1f.1: [8086:2850] type 0 class 0x000101
[    2.105829] pci 0000:00:1f.1: reg 10: [io  0x01f0-0x01f7]
[    2.105848] pci 0000:00:1f.1: reg 14: [io  0x03f4-0x03f7]
[    2.105866] pci 0000:00:1f.1: reg 18: [io  0x0170-0x0177]
[    2.105885] pci 0000:00:1f.1: reg 1c: [io  0x0374-0x0377]
[    2.105904] pci 0000:00:1f.1: reg 20: [io  0x6fa0-0x6faf]
[    2.106002] pci 0000:00:1f.2: [8086:2829] type 0 class 0x000106
[    2.106045] pci 0000:00:1f.2: reg 10: [io  0x6eb0-0x6eb7]
[    2.106063] pci 0000:00:1f.2: reg 14: [io  0x6eb8-0x6ebb]
[    2.106082] pci 0000:00:1f.2: reg 18: [io  0x6ec0-0x6ec7]
[    2.106101] pci 0000:00:1f.2: reg 1c: [io  0x6ec8-0x6ecb]
[    2.106119] pci 0000:00:1f.2: reg 20: [io  0x6ee0-0x6eff]
[    2.106138] pci 0000:00:1f.2: reg 24: [mem 0xfed1c800-0xfed1cfff]
[    2.106216] pci 0000:00:1f.2: PME# supported from D3hot
[    2.106223] pci 0000:00:1f.2: PME# disabled
[    2.106272] pci 0000:00:1f.3: [8086:283e] type 0 class 0x000c05
[    2.106298] pci 0000:00:1f.3: reg 10: [mem 0xf7ffbf00-0xf7ffbfff]
[    2.106366] pci 0000:00:1f.3: reg 20: [io  0x10c0-0x10df]
[    2.106553] pci 0000:01:00.0: [10de:01b3] type 1 class 0x000604
[    2.106575] pci 0000:01:00.0: reg 10: [mem 0xf7efc000-0xf7efffff]
[    2.106665] pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
[    2.106672] pci 0000:01:00.0: PME# disabled
[    2.106701] pci 0000:01:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    2.106790] pci 0000:00:01.0: PCI bridge to [bus 01-04]
[    2.106796] pci 0000:00:01.0:   bridge window [io  0xd000-0xefff]
[    2.106802] pci 0000:00:01.0:   bridge window [mem 0xf0f00000-0xf7efffff]
[    2.106810] pci 0000:00:01.0:   bridge window [mem 0xc0000000-0xdfffffff 64bit pref]
[    2.106919] pci 0000:02:00.0: [10de:01b3] type 1 class 0x000604
[    2.107012] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    2.107018] pci 0000:02:00.0: PME# disabled
[    2.107035] pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    2.107076] pci 0000:02:01.0: [10de:01b3] type 1 class 0x000604
[    2.107168] pci 0000:02:01.0: PME# supported from D0 D3hot D3cold
[    2.107173] pci 0000:02:01.0: PME# disabled
[    2.107190] pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    2.107257] pci 0000:01:00.0: PCI bridge to [bus 02-04]
[    2.107267] pci 0000:01:00.0:   bridge window [io  0xd000-0xefff]
[    2.107273] pci 0000:01:00.0:   bridge window [mem 0xf0f00000-0xf7dfffff]
[    2.107282] pci 0000:01:00.0:   bridge window [mem 0xc0000000-0xdfffffff 64bit pref]
[    2.107408] pci 0000:03:00.0: [10de:060c] type 0 class 0x000300
[    2.107434] pci 0000:03:00.0: reg 10: [mem 0xf6000000-0xf6ffffff]
[    2.107463] pci 0000:03:00.0: reg 14: [mem 0xc0000000-0xcfffffff 64bit pref]
[    2.107491] pci 0000:03:00.0: reg 1c: [mem 0xf4000000-0xf5ffffff 64bit]
[    2.107510] pci 0000:03:00.0: reg 24: [io  0xef00-0xef7f]
[    2.107529] pci 0000:03:00.0: reg 30: [mem 0xf7d00000-0xf7d1ffff pref]
[    2.109807] pci 0000:02:00.0: PCI bridge to [bus 03-03]
[    2.109817] pci 0000:02:00.0:   bridge window [io  0xe000-0xefff]
[    2.109824] pci 0000:02:00.0:   bridge window [mem 0xf4000000-0xf7dfffff]
[    2.109833] pci 0000:02:00.0:   bridge window [mem 0xc0000000-0xcfffffff 64bit pref]
[    2.109955] pci 0000:04:00.0: [10de:060c] type 0 class 0x000302
[    2.109978] pci 0000:04:00.0: reg 10: [mem 0xf1000000-0xf1ffffff]
[    2.110003] pci 0000:04:00.0: reg 14: [mem 0xd0000000-0xdfffffff 64bit pref]
[    2.110027] pci 0000:04:00.0: reg 1c: [mem 0xf2000000-0xf3ffffff 64bit]
[    2.110044] pci 0000:04:00.0: reg 24: [io  0xdf00-0xdf7f]
[    2.110060] pci 0000:04:00.0: reg 30: [mem 0xf0f00000-0xf0f1ffff pref]
[    2.111827] pci 0000:02:01.0: PCI bridge to [bus 04-04]
[    2.111837] pci 0000:02:01.0:   bridge window [io  0xd000-0xdfff]
[    2.111843] pci 0000:02:01.0:   bridge window [mem 0xf0f00000-0xf3ffffff]
[    2.111852] pci 0000:02:01.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    2.111993] pci 0000:00:1c.0: PCI bridge to [bus 0b-0b]
[    2.112293] pci 0000:0c:00.0: [8086:4229] type 0 class 0x000280
[    2.112420] pci 0000:0c:00.0: reg 10: [mem 0xf0efe000-0xf0efffff 64bit]
[    2.112967] pci 0000:0c:00.0: PME# supported from D0 D3hot D3cold
[    2.112986] pci 0000:0c:00.0: PME# disabled
[    2.113227] pci 0000:00:1c.1: PCI bridge to [bus 0c-0c]
[    2.113239] pci 0000:00:1c.1:   bridge window [mem 0xf0e00000-0xf0efffff]
[    2.113363] pci 0000:00:1c.3: PCI bridge to [bus 0d-0e]
[    2.113370] pci 0000:00:1c.3:   bridge window [io  0xc000-0xcfff]
[    2.113377] pci 0000:00:1c.3:   bridge window [mem 0xf0c00000-0xf0dfffff]
[    2.113389] pci 0000:00:1c.3:   bridge window [mem 0xe0000000-0xe01fffff 64bit pref]
[    2.113561] pci 0000:0f:00.0: [1971:0000] type 0 class 0x00ff00
[    2.113594] pci 0000:0f:00.0: reg 10: [mem 0xef000000-0xefffffff]
[    2.113876] pci 0000:0f:00.0: PME# supported from D0 D1 D2 D3hot
[    2.113885] pci 0000:0f:00.0: PME# disabled
[    2.113934] pci 0000:0f:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    2.113962] pci 0000:00:1c.4: PCI bridge to [bus 0f-0f]
[    2.113974] pci 0000:00:1c.4:   bridge window [mem 0xef000000-0xf0bfffff]
[    2.114199] pci 0000:09:00.0: [14e4:1672] type 0 class 0x000200
[    2.114244] pci 0000:09:00.0: reg 10: [mem 0xeeff0000-0xeeffffff 64bit]
[    2.114447] pci 0000:09:00.0: PME# supported from D3hot D3cold
[    2.114456] pci 0000:09:00.0: PME# disabled
[    2.115824] pci 0000:00:1c.5: PCI bridge to [bus 09-09]
[    2.115836] pci 0000:00:1c.5:   bridge window [mem 0xeef00000-0xeeffffff]
[    2.115955] pci 0000:05:01.0: [1180:0832] type 0 class 0x000c00
[    2.115992] pci 0000:05:01.0: reg 10: [mem 0xeeeff800-0xeeefffff]
[    2.116131] pci 0000:05:01.0: supports D1 D2
[    2.116133] pci 0000:05:01.0: PME# supported from D0 D1 D2 D3hot D3cold
[    2.116175] pci 0000:05:01.0: PME# disabled
[    2.116226] pci 0000:05:01.1: [1180:0822] type 0 class 0x000805
[    2.116260] pci 0000:05:01.1: reg 10: [mem 0xeeeff500-0xeeeff5ff]
[    2.116400] pci 0000:05:01.1: supports D1 D2
[    2.116402] pci 0000:05:01.1: PME# supported from D0 D1 D2 D3hot D3cold
[    2.116410] pci 0000:05:01.1: PME# disabled
[    2.116460] pci 0000:05:01.2: [1180:0592] type 0 class 0x000880
[    2.116495] pci 0000:05:01.2: reg 10: [mem 0xeeeff600-0xeeeff6ff]
[    2.116634] pci 0000:05:01.2: supports D1 D2
[    2.116636] pci 0000:05:01.2: PME# supported from D0 D1 D2 D3hot D3cold
[    2.116644] pci 0000:05:01.2: PME# disabled
[    2.116707] pci 0000:05:01.3: [1180:0852] type 0 class 0x000880
[    2.116742] pci 0000:05:01.3: reg 10: [mem 0xeeeff700-0xeeeff7ff]
[    2.116879] pci 0000:05:01.3: supports D1 D2
[    2.116882] pci 0000:05:01.3: PME# supported from D0 D1 D2 D3hot D3cold
[    2.116890] pci 0000:05:01.3: PME# disabled
[    2.117008] pci 0000:00:1e.0: PCI bridge to [bus 05-05] (subtractive decode)
[    2.117020] pci 0000:00:1e.0:   bridge window [mem 0xeee00000-0xeeefffff]
[    2.117040] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    2.117050] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    2.117061] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    2.117072] pci 0000:00:1e.0:   bridge window [mem 0x000d0000-0x000dffff] (subtractive decode)
[    2.117082] pci 0000:00:1e.0:   bridge window [mem 0xc0000000-0xf7ffffff] (subtractive decode)
[    2.117093] pci 0000:00:1e.0:   bridge window [mem 0xfc000000-0xfebfffff] (subtractive decode)
[    2.117103] pci 0000:00:1e.0:   bridge window [mem 0xfec10000-0xfecfffff] (subtractive decode)
[    2.117113] pci 0000:00:1e.0:   bridge window [mem 0xfed1c000-0xfed1ffff] (subtractive decode)
[    2.117123] pci 0000:00:1e.0:   bridge window [mem 0xfed90000-0xfed9ffff] (subtractive decode)
[    2.117133] pci 0000:00:1e.0:   bridge window [mem 0xfeda7000-0xfedfffff] (subtractive decode)
[    2.117144] pci 0000:00:1e.0:   bridge window [mem 0xfee10000-0xff9fffff] (subtractive decode)
[    2.117154] pci 0000:00:1e.0:   bridge window [mem 0xffc00000-0xffdfffff] (subtractive decode)
[    2.117166] pci 0000:00:1e.0:   bridge window [mem 0x140000000-0x337ffffff] (subtractive decode)
[    2.117376] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    2.140371] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIE._PRT]
[    2.145881] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]
[    2.148118] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_.SLI_.SLI0._PRT]
[    2.150837] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_.SLI_.SLI1._PRT]
[    2.153123] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    2.155965] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    2.158965] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP04._PRT]
[    2.163089] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP05._PRT]
[    2.166782] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP06._PRT]
[    2.170040]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    2.170060]  pci0000:00: ACPI _OSC request failed (AE_NOT_FOUND), returned control mask: 0x1d
[    2.170063] ACPI _OSC control for PCIe not granted, disabling ASPM
[    2.787649] ACPI: PCI Interrupt Link [LNKA] (IRQs 9 10 11) *7
[    2.790346] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 7) *10
[    2.794501] ACPI: PCI Interrupt Link [LNKC] (IRQs 9 10 11) *4
[    2.798028] ACPI: PCI Interrupt Link [LNKD] (IRQs *5 7 9 10 11)
[    2.800886] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
[    2.804148] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
[    2.808749] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
[    2.810708] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    2.815343] vgaarb: device added: PCI:0000:03:00.0,decodes=io+mem,owns=io+mem,locks=none
[    2.815467] vgaarb: loaded
[    2.815469] vgaarb: bridge control possible 0000:03:00.0
[    2.817940] SCSI subsystem initialized
[    2.818921] libata version 3.00 loaded.
[    2.821985] usbcore: registered new interface driver usbfs
[    2.823268] usbcore: registered new interface driver hub
[    2.823652] usbcore: registered new device driver usb
[    2.830962] wmi: Mapper loaded
[    2.831659] Advanced Linux Sound Architecture Driver Version 1.0.24.
[    2.831662] PCI: Using ACPI for IRQ routing
[    2.835241] PCI: pci_cache_line_size set to 64 bytes
[    2.836508] reserve RAM buffer: 000000000009f000 - 000000000009ffff 
[    2.836548] reserve RAM buffer: 00000000bfe72000 - 00000000bfffffff 
[    2.840010] Bluetooth: Core ver 2.16
[    2.840230] NET: Registered protocol family 31
[    2.840230] Bluetooth: HCI device and connection manager initialized
[    2.840230] Bluetooth: HCI socket layer initialized
[    2.841735] cfg80211: Calling CRDA to update world regulatory domain
[    2.842040] NetLabel: Initializing
[    2.842043] NetLabel:  domain hash size = 128
[    2.842044] NetLabel:  protocols = UNLABELED CIPSOv4
[    2.842220] NetLabel:  unlabeled traffic allowed by default
[    2.844109] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    2.844109] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    2.844109] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    2.848053] Switching to clocksource hpet
[    2.848246] Switched to NOHz mode on CPU #0
[    2.848082] Switched to NOHz mode on CPU #1
[    2.996519] pnp: PnP ACPI init
[    2.996596] ACPI: bus type pnp registered
[    3.264126] pnp 00:00: [bus 00-ff]
[    3.264136] pnp 00:00: [io  0x0000-0x0cf7 window]
[    3.264145] pnp 00:00: [io  0x0cf8-0x0cff]
[    3.264153] pnp 00:00: [io  0x0d00-0xffff window]
[    3.264161] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    3.264170] pnp 00:00: [mem 0x000d0000-0x000dffff window]
[    3.264178] pnp 00:00: [mem 0xc0000000-0xf7ffffff window]
[    3.264186] pnp 00:00: [mem 0xfc000000-0xfebfffff window]
[    3.264194] pnp 00:00: [mem 0xfec10000-0xfecfffff window]
[    3.264202] pnp 00:00: [mem 0xfed1c000-0xfed1ffff window]
[    3.264210] pnp 00:00: [mem 0xfed90000-0xfed9ffff window]
[    3.264219] pnp 00:00: [mem 0xfeda7000-0xfedfffff window]
[    3.264228] pnp 00:00: [mem 0xfee10000-0xff9fffff window]
[    3.264236] pnp 00:00: [mem 0xffc00000-0xffdfffff window]
[    3.264245] pnp 00:00: [mem 0x140000000-0x337ffffff window]
[    3.265090] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    3.265679] pnp 00:01: [irq 12]
[    3.266330] pnp 00:01: Plug and Play ACPI device, IDs PNP0f13 (active)
[    3.266652] pnp 00:02: [io  0x0060]
[    3.266661] pnp 00:02: [io  0x0064]
[    3.266669] pnp 00:02: [io  0x0062]
[    3.266676] pnp 00:02: [io  0x0066]
[    3.266694] pnp 00:02: [irq 1]
[    3.267235] pnp 00:02: Plug and Play ACPI device, IDs PNP0303 (active)
[    3.267562] pnp 00:03: [io  0x0070-0x0071]
[    3.267580] pnp 00:03: [irq 8]
[    3.267588] pnp 00:03: [io  0x0072-0x0077]
[    3.268122] pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
[    3.268490] pnp 00:04: [io  0x0061]
[    3.268503] pnp 00:04: [io  0x0063]
[    3.268512] pnp 00:04: [io  0x0065]
[    3.268520] pnp 00:04: [io  0x0067]
[    3.269310] pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
[    3.269634] pnp 00:05: [io  0x0c80-0x0cff]
[    3.271348] system 00:05: [io  0x0c80-0x0cff] could not be reserved
[    3.271357] system 00:05: Plug and Play ACPI device, IDs PNP0c01 (active)
[    3.271746] pnp 00:06: [dma 4]
[    3.271755] pnp 00:06: [io  0x0000-0x000f]
[    3.271764] pnp 00:06: [io  0x0080-0x0085]
[    3.271772] pnp 00:06: [io  0x0087-0x008f]
[    3.271780] pnp 00:06: [io  0x00c0-0x00df]
[    3.271788] pnp 00:06: [io  0x0010-0x001f]
[    3.271796] pnp 00:06: [io  0x0090-0x0091]
[    3.271804] pnp 00:06: [io  0x0093-0x009f]
[    3.272358] pnp 00:06: Plug and Play ACPI device, IDs PNP0200 (active)
[    3.272686] pnp 00:07: [io  0x00f0-0x00ff]
[    3.272706] pnp 00:07: [irq 13]
[    3.273700] pnp 00:07: Plug and Play ACPI device, IDs PNP0c04 (active)
[    3.275276] pnp 00:08: [mem 0xfed00000-0xfed003ff]
[    3.276456] system 00:08: [mem 0xfed00000-0xfed003ff] has been reserved
[    3.276463] system 00:08: Plug and Play ACPI device, IDs PNP0103 PNP0c01 (active)
[    3.280390] pnp 00:09: [io  0x0900-0x097f]
[    3.280398] pnp 00:09: [io  0x0092]
[    3.280406] pnp 00:09: [io  0x00b2-0x00b3]
[    3.280415] pnp 00:09: [io  0x0020-0x0021]
[    3.280424] pnp 00:09: [io  0x00a0-0x00a1]
[    3.280433] pnp 00:09: [irq 0 disabled]
[    3.280441] pnp 00:09: [io  0x04d0-0x04d1]
[    3.280450] pnp 00:09: [io  0x1000-0x1005]
[    3.280459] pnp 00:09: [io  0x1008-0x100f]
[    3.280743] pnp 00:09: disabling [io  0x1000-0x1005] because it overlaps 0000:00:1f.0 BAR 13 [io  0x1000-0x107f]
[    3.280747] pnp 00:09: disabling [io  0x1008-0x100f] because it overlaps 0000:00:1f.0 BAR 13 [io  0x1000-0x107f]
[    3.281778] system 00:09: [io  0x0900-0x097f] has been reserved
[    3.281801] system 00:09: [io  0x04d0-0x04d1] has been reserved
[    3.281807] system 00:09: Plug and Play ACPI device, IDs PNP0c01 (active)
[    3.282480] pnp 00:0a: [io  0xf400-0xf4fe]
[    3.282489] pnp 00:0a: [io  0x0086]
[    3.282497] pnp 00:0a: [io  0x1006-0x1007]
[    3.282505] pnp 00:0a: [io  0x100a-0x1059]
[    3.282513] pnp 00:0a: [io  0x1080-0x10bf]
[    3.282521] pnp 00:0a: [io  0x10c0-0x10df]
[    3.282529] pnp 00:0a: [io  0x1010-0x102f]
[    3.282537] pnp 00:0a: [io  0x0809]
[    3.282814] pnp 00:0a: disabling [io  0x1006-0x1007] because it overlaps 0000:00:1f.0 BAR 13 [io  0x1000-0x107f]
[    3.282818] pnp 00:0a: disabling [io  0x100a-0x1059] because it overlaps 0000:00:1f.0 BAR 13 [io  0x1000-0x107f]
[    3.282821] pnp 00:0a: disabling [io  0x1010-0x102f] because it overlaps 0000:00:1f.0 BAR 13 [io  0x1000-0x107f]
[    3.284378] system 00:0a: [io  0xf400-0xf4fe] has been reserved
[    3.284397] system 00:0a: [io  0x1080-0x10bf] has been reserved
[    3.284417] system 00:0a: [io  0x10c0-0x10df] has been reserved
[    3.284435] system 00:0a: [io  0x0809] has been reserved
[    3.284441] system 00:0a: Plug and Play ACPI device, IDs PNP0c01 (active)
[    3.652308] pnp 00:0b: [mem 0x00000000-0x0009efff]
[    3.652318] pnp 00:0b: [mem 0x0009f000-0x0009ffff]
[    3.652327] pnp 00:0b: [mem 0x000c0000-0x000cffff]
[    3.652335] pnp 00:0b: [mem 0x000e0000-0x000fffff]
[    3.652344] pnp 00:0b: [mem 0x00100000-0xbfe71fff]
[    3.652352] pnp 00:0b: [mem 0xbfe72000-0xbfefffff]
[    3.652360] pnp 00:0b: [mem 0xbff00000-0xbfffffff]
[    3.652368] pnp 00:0b: [mem 0xffe00000-0xffffffff]
[    3.652376] pnp 00:0b: [mem 0xffa00000-0xffbfffff]
[    3.652384] pnp 00:0b: [mem 0xfec00000-0xfec0ffff]
[    3.652392] pnp 00:0b: [mem 0xfee00000-0xfee0ffff]
[    3.652400] pnp 00:0b: [mem 0xfed20000-0xfed8ffff]
[    3.652409] pnp 00:0b: [mem 0xfeda0000-0xfeda3fff]
[    3.652417] pnp 00:0b: [mem 0xfeda4000-0xfeda4fff]
[    3.652425] pnp 00:0b: [mem 0xfeda5000-0xfeda5fff]
[    3.652433] pnp 00:0b: [mem 0xfeda6000-0xfeda6fff]
[    3.652441] pnp 00:0b: [mem 0xfed1c800-0xfed1cfff]
[    3.652449] pnp 00:0b: [mem 0xfed18000-0xfed1bfff]
[    3.652458] pnp 00:0b: [mem 0xf8000000-0xfbffffff]
[    3.653803] system 00:0b: [mem 0x00000000-0x0009efff] could not be reserved
[    3.653840] system 00:0b: [mem 0x0009f000-0x0009ffff] could not be reserved
[    3.653876] system 00:0b: [mem 0x000c0000-0x000cffff] could not be reserved
[    3.653911] system 00:0b: [mem 0x000e0000-0x000fffff] could not be reserved
[    3.653946] system 00:0b: [mem 0x00100000-0xbfe71fff] could not be reserved
[    3.653965] system 00:0b: [mem 0xbfe72000-0xbfefffff] has been reserved
[    3.653983] system 00:0b: [mem 0xbff00000-0xbfffffff] has been reserved
[    3.654192] system 00:0b: [mem 0xffe00000-0xffffffff] has been reserved
[    3.654211] system 00:0b: [mem 0xffa00000-0xffbfffff] has been reserved
[    3.654246] system 00:0b: [mem 0xfec00000-0xfec0ffff] could not be reserved
[    3.654265] system 00:0b: [mem 0xfee00000-0xfee0ffff] has been reserved
[    3.654284] system 00:0b: [mem 0xfed20000-0xfed8ffff] has been reserved
[    3.654303] system 00:0b: [mem 0xfeda0000-0xfeda3fff] has been reserved
[    3.654324] system 00:0b: [mem 0xfeda4000-0xfeda4fff] has been reserved
[    3.654344] system 00:0b: [mem 0xfeda5000-0xfeda5fff] has been reserved
[    3.654368] system 00:0b: [mem 0xfeda6000-0xfeda6fff] has been reserved
[    3.654387] system 00:0b: [mem 0xfed1c800-0xfed1cfff] has been reserved
[    3.654406] system 00:0b: [mem 0xfed18000-0xfed1bfff] has been reserved
[    3.654425] system 00:0b: [mem 0xf8000000-0xfbffffff] has been reserved
[    3.654432] system 00:0b: Plug and Play ACPI device, IDs PNP0c01 (active)
[    3.656120] pnp: PnP ACPI: found 12 devices
[    3.656123] ACPI: ACPI bus type pnp unregistered
[    3.688645] kworker/u:0 used greatest stack depth: 4664 bytes left
[    3.717570] PCI: max bus depth: 3 pci_try_num: 4
[    3.717828] pci 0000:00:1c.5: BAR 15: assigned [mem 0xe0200000-0xe03fffff 64bit pref]
[    3.717841] pci 0000:00:1c.5: BAR 13: assigned [io  0x2000-0x2fff]
[    3.717854] pci 0000:00:1c.4: BAR 15: assigned [mem 0xe0400000-0xe05fffff 64bit pref]
[    3.717866] pci 0000:00:1c.4: BAR 13: assigned [io  0x3000-0x3fff]
[    3.717879] pci 0000:00:1c.1: BAR 15: assigned [mem 0xe0600000-0xe07fffff 64bit pref]
[    3.717890] pci 0000:00:1c.1: BAR 13: assigned [io  0x4000-0x4fff]
[    3.717903] pci 0000:00:1c.0: BAR 14: assigned [mem 0xe0800000-0xe09fffff]
[    3.717915] pci 0000:00:1c.0: BAR 15: assigned [mem 0xe0a00000-0xe0bfffff 64bit pref]
[    3.717927] pci 0000:00:1c.0: BAR 13: assigned [io  0x5000-0x5fff]
[    3.717997] pci 0000:02:00.0: PCI bridge to [bus 03-03]
[    3.718670] pci 0000:02:00.0:   bridge window [io  0xe000-0xefff]
[    3.718678] pci 0000:02:00.0:   bridge window [mem 0xf4000000-0xf7dfffff]
[    3.718685] pci 0000:02:00.0:   bridge window [mem 0xc0000000-0xcfffffff 64bit pref]
[    3.718695] pci 0000:02:01.0: PCI bridge to [bus 04-04]
[    3.718699] pci 0000:02:01.0:   bridge window [io  0xd000-0xdfff]
[    3.718707] pci 0000:02:01.0:   bridge window [mem 0xf0f00000-0xf3ffffff]
[    3.718713] pci 0000:02:01.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    3.718723] pci 0000:01:00.0: PCI bridge to [bus 02-04]
[    3.718727] pci 0000:01:00.0:   bridge window [io  0xd000-0xefff]
[    3.718734] pci 0000:01:00.0:   bridge window [mem 0xf0f00000-0xf7dfffff]
[    3.718740] pci 0000:01:00.0:   bridge window [mem 0xc0000000-0xdfffffff 64bit pref]
[    3.718750] pci 0000:00:01.0: PCI bridge to [bus 01-04]
[    3.718754] pci 0000:00:01.0:   bridge window [io  0xd000-0xefff]
[    3.718761] pci 0000:00:01.0:   bridge window [mem 0xf0f00000-0xf7efffff]
[    3.718766] pci 0000:00:01.0:   bridge window [mem 0xc0000000-0xdfffffff 64bit pref]
[    3.718774] pci 0000:00:1c.0: PCI bridge to [bus 0b-0b]
[    3.718779] pci 0000:00:1c.0:   bridge window [io  0x5000-0x5fff]
[    3.718788] pci 0000:00:1c.0:   bridge window [mem 0xe0800000-0xe09fffff]
[    3.718795] pci 0000:00:1c.0:   bridge window [mem 0xe0a00000-0xe0bfffff 64bit pref]
[    3.718807] pci 0000:00:1c.1: PCI bridge to [bus 0c-0c]
[    3.718812] pci 0000:00:1c.1:   bridge window [io  0x4000-0x4fff]
[    3.718821] pci 0000:00:1c.1:   bridge window [mem 0xf0e00000-0xf0efffff]
[    3.718828] pci 0000:00:1c.1:   bridge window [mem 0xe0600000-0xe07fffff 64bit pref]
[    3.718840] pci 0000:00:1c.3: PCI bridge to [bus 0d-0e]
[    3.718844] pci 0000:00:1c.3:   bridge window [io  0xc000-0xcfff]
[    3.718853] pci 0000:00:1c.3:   bridge window [mem 0xf0c00000-0xf0dfffff]
[    3.718861] pci 0000:00:1c.3:   bridge window [mem 0xe0000000-0xe01fffff 64bit pref]
[    3.718872] pci 0000:00:1c.4: PCI bridge to [bus 0f-0f]
[    3.718877] pci 0000:00:1c.4:   bridge window [io  0x3000-0x3fff]
[    3.718886] pci 0000:00:1c.4:   bridge window [mem 0xef000000-0xf0bfffff]
[    3.718893] pci 0000:00:1c.4:   bridge window [mem 0xe0400000-0xe05fffff 64bit pref]
[    3.718905] pci 0000:00:1c.5: PCI bridge to [bus 09-09]
[    3.718910] pci 0000:00:1c.5:   bridge window [io  0x2000-0x2fff]
[    3.718919] pci 0000:00:1c.5:   bridge window [mem 0xeef00000-0xeeffffff]
[    3.718926] pci 0000:00:1c.5:   bridge window [mem 0xe0200000-0xe03fffff 64bit pref]
[    3.718938] pci 0000:00:1e.0: PCI bridge to [bus 05-05]
[    3.718947] pci 0000:00:1e.0:   bridge window [mem 0xeee00000-0xeeefffff]
[    3.719203] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.719210] pci 0000:00:01.0: setting latency timer to 64
[    3.719224] pci 0000:01:00.0: setting latency timer to 64
[    3.719238] pci 0000:02:00.0: setting latency timer to 64
[    3.719251] pci 0000:02:01.0: setting latency timer to 64
[    3.719264] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.719271] pci 0000:00:1c.0: setting latency timer to 64
[    3.719316] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    3.719324] pci 0000:00:1c.1: setting latency timer to 64
[    3.719368] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    3.719376] pci 0000:00:1c.3: setting latency timer to 64
[    3.719389] pci 0000:00:1c.4: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.719396] pci 0000:00:1c.4: setting latency timer to 64
[    3.719409] pci 0000:00:1c.5: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    3.719416] pci 0000:00:1c.5: setting latency timer to 64
[    3.719430] pci 0000:00:1e.0: setting latency timer to 64
[    3.719436] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    3.719438] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    3.719441] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    3.719443] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000dffff]
[    3.719446] pci_bus 0000:00: resource 8 [mem 0xc0000000-0xf7ffffff]
[    3.719448] pci_bus 0000:00: resource 9 [mem 0xfc000000-0xfebfffff]
[    3.719451] pci_bus 0000:00: resource 10 [mem 0xfec10000-0xfecfffff]
[    3.719453] pci_bus 0000:00: resource 11 [mem 0xfed1c000-0xfed1ffff]
[    3.719456] pci_bus 0000:00: resource 12 [mem 0xfed90000-0xfed9ffff]
[    3.719458] pci_bus 0000:00: resource 13 [mem 0xfeda7000-0xfedfffff]
[    3.719460] pci_bus 0000:00: resource 14 [mem 0xfee10000-0xff9fffff]
[    3.719463] pci_bus 0000:00: resource 15 [mem 0xffc00000-0xffdfffff]
[    3.719465] pci_bus 0000:00: resource 16 [mem 0x140000000-0x337ffffff]
[    3.719468] pci_bus 0000:01: resource 0 [io  0xd000-0xefff]
[    3.719471] pci_bus 0000:01: resource 1 [mem 0xf0f00000-0xf7efffff]
[    3.719473] pci_bus 0000:01: resource 2 [mem 0xc0000000-0xdfffffff 64bit pref]
[    3.719476] pci_bus 0000:02: resource 0 [io  0xd000-0xefff]
[    3.719478] pci_bus 0000:02: resource 1 [mem 0xf0f00000-0xf7dfffff]
[    3.719481] pci_bus 0000:02: resource 2 [mem 0xc0000000-0xdfffffff 64bit pref]
[    3.719483] pci_bus 0000:03: resource 0 [io  0xe000-0xefff]
[    3.719486] pci_bus 0000:03: resource 1 [mem 0xf4000000-0xf7dfffff]
[    3.719488] pci_bus 0000:03: resource 2 [mem 0xc0000000-0xcfffffff 64bit pref]
[    3.719491] pci_bus 0000:04: resource 0 [io  0xd000-0xdfff]
[    3.719493] pci_bus 0000:04: resource 1 [mem 0xf0f00000-0xf3ffffff]
[    3.719496] pci_bus 0000:04: resource 2 [mem 0xd0000000-0xdfffffff 64bit pref]
[    3.719499] pci_bus 0000:0b: resource 0 [io  0x5000-0x5fff]
[    3.719501] pci_bus 0000:0b: resource 1 [mem 0xe0800000-0xe09fffff]
[    3.719503] pci_bus 0000:0b: resource 2 [mem 0xe0a00000-0xe0bfffff 64bit pref]
[    3.719506] pci_bus 0000:0c: resource 0 [io  0x4000-0x4fff]
[    3.719508] pci_bus 0000:0c: resource 1 [mem 0xf0e00000-0xf0efffff]
[    3.719511] pci_bus 0000:0c: resource 2 [mem 0xe0600000-0xe07fffff 64bit pref]
[    3.719514] pci_bus 0000:0d: resource 0 [io  0xc000-0xcfff]
[    3.719516] pci_bus 0000:0d: resource 1 [mem 0xf0c00000-0xf0dfffff]
[    3.719519] pci_bus 0000:0d: resource 2 [mem 0xe0000000-0xe01fffff 64bit pref]
[    3.719521] pci_bus 0000:0f: resource 0 [io  0x3000-0x3fff]
[    3.719524] pci_bus 0000:0f: resource 1 [mem 0xef000000-0xf0bfffff]
[    3.719526] pci_bus 0000:0f: resource 2 [mem 0xe0400000-0xe05fffff 64bit pref]
[    3.719529] pci_bus 0000:09: resource 0 [io  0x2000-0x2fff]
[    3.719531] pci_bus 0000:09: resource 1 [mem 0xeef00000-0xeeffffff]
[    3.719534] pci_bus 0000:09: resource 2 [mem 0xe0200000-0xe03fffff 64bit pref]
[    3.719536] pci_bus 0000:05: resource 1 [mem 0xeee00000-0xeeefffff]
[    3.719539] pci_bus 0000:05: resource 4 [io  0x0000-0x0cf7]
[    3.719541] pci_bus 0000:05: resource 5 [io  0x0d00-0xffff]
[    3.719544] pci_bus 0000:05: resource 6 [mem 0x000a0000-0x000bffff]
[    3.719546] pci_bus 0000:05: resource 7 [mem 0x000d0000-0x000dffff]
[    3.719548] pci_bus 0000:05: resource 8 [mem 0xc0000000-0xf7ffffff]
[    3.719551] pci_bus 0000:05: resource 9 [mem 0xfc000000-0xfebfffff]
[    3.719553] pci_bus 0000:05: resource 10 [mem 0xfec10000-0xfecfffff]
[    3.719556] pci_bus 0000:05: resource 11 [mem 0xfed1c000-0xfed1ffff]
[    3.719558] pci_bus 0000:05: resource 12 [mem 0xfed90000-0xfed9ffff]
[    3.719561] pci_bus 0000:05: resource 13 [mem 0xfeda7000-0xfedfffff]
[    3.719563] pci_bus 0000:05: resource 14 [mem 0xfee10000-0xff9fffff]
[    3.719565] pci_bus 0000:05: resource 15 [mem 0xffc00000-0xffdfffff]
[    3.719568] pci_bus 0000:05: resource 16 [mem 0x140000000-0x337ffffff]
[    3.719779] NET: Registered protocol family 2
[    3.720299] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    3.724514] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    3.730073] TCP bind hash table entries: 65536 (order: 10, 5242880 bytes)
[    3.736256] TCP: Hash tables configured (established 524288 bind 65536)
[    3.736324] TCP reno registered
[    3.736438] UDP hash table entries: 2048 (order: 6, 393216 bytes)
[    3.736906] UDP-Lite hash table entries: 2048 (order: 6, 393216 bytes)
[    3.737919] NET: Registered protocol family 1
[    3.739092] RPC: Registered named UNIX socket transport module.
[    3.739095] RPC: Registered udp transport module.
[    3.739098] RPC: Registered tcp transport module.
[    3.739100] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    3.739176] pci 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x0080
[    3.739178] pci 0000:00:1a.0: Performing full reset
[    3.739220] pci 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x0080
[    3.739222] pci 0000:00:1a.1: Performing full reset
[    3.739466] pci 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0080
[    3.739469] pci 0000:00:1d.0: Performing full reset
[    3.739507] pci 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0080
[    3.739509] pci 0000:00:1d.1: Performing full reset
[    3.739549] pci 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0080
[    3.739551] pci 0000:00:1d.2: Performing full reset
[    3.739897] pci 0000:03:00.0: Boot video device
[    3.740175] PCI: CLS 64 bytes, default 64
[    3.740826] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    3.740829] Placing 64MB software IO TLB between ffff8800bbe6d000 - ffff8800bfe6d000
[    3.740832] software IO TLB at phys 0xbbe6d000 - 0xbfe6d000
[    3.740849] Simple Boot Flag at 0x79 set to 0x1
[    3.751848] microcode: CPU0 sig=0x10676, pf=0x80, revision=0x60c
[    3.751887] microcode: CPU1 sig=0x10676, pf=0x80, revision=0x60c
[    3.752504] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    3.758406] audit: initializing netlink socket (disabled)
[    3.758504] type=2000 audit(1317762345.757:1): initialized
[    3.779601] Kprobe smoke test started
[    3.819133] Kprobe smoke test passed successfully
[    3.835548] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    3.920587] VFS: Disk quotas dquot_6.5.2
[    3.921377] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    3.934670] msgmni has been set to 7873
[    3.936255] SELinux:  Registering netfilter hooks
[    3.940666] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    3.940688] io scheduler noop registered
[    3.940690] io scheduler deadline registered
[    3.941468] io scheduler cfq registered (default)
[    3.941471] start plist test
[    3.942795] end plist test
[    3.944825] pcieport 0000:00:01.0: setting latency timer to 64
[    3.944958] pcieport 0000:00:01.0: irq 40 for MSI/MSI-X
[    3.945949] pcieport 0000:00:1c.0: setting latency timer to 64
[    3.946082] pcieport 0000:00:1c.0: irq 41 for MSI/MSI-X
[    3.946665] pcieport 0000:00:1c.1: setting latency timer to 64
[    3.946781] pcieport 0000:00:1c.1: irq 42 for MSI/MSI-X
[    3.947997] pcieport 0000:00:1c.3: setting latency timer to 64
[    3.948137] pcieport 0000:00:1c.3: irq 43 for MSI/MSI-X
[    3.948723] pcieport 0000:00:1c.4: setting latency timer to 64
[    3.948840] pcieport 0000:00:1c.4: irq 44 for MSI/MSI-X
[    3.949538] pcieport 0000:00:1c.5: setting latency timer to 64
[    3.949706] pcieport 0000:00:1c.5: irq 45 for MSI/MSI-X
[    3.952290] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    3.954956] ACPI: AC Adapter [AC] (on-line)
[    3.957240] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
[    3.959586] ACPI: Lid Switch [LID]
[    3.960360] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[    3.960425] ACPI: Power Button [PBTN]
[    3.961434] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input2
[    3.961455] ACPI: Sleep Button [SBTN]
[    4.146576] acpi device:33: registered as cooling_device0
[    4.156484] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A03:00/device:2e/device:2f/device:30/LNXVIDEO:00/input/input3
[    4.156509] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[    4.157264] ACPI Warning: For \_SB_.PCI0.AGP_.SLI_.SLI1.VID1._DOD: Return Package has no elements (empty) (20110623/nspredef-463)
[    4.158905] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A03:00/device:2e/device:2f/device:35/LNXVIDEO:01/input/input4
[    4.158930] ACPI: Video Device [VID1] (multi-head: yes  rom: no  post: no)
[    4.159398] ACPI: acpi_idle registered with cpuidle
[    4.164575] Monitor-Mwait will be used to enter C-1 state
[    4.164690] Monitor-Mwait will be used to enter C-2 state
[    4.164811] Monitor-Mwait will be used to enter C-3 state
[    4.164832] Marking TSC unstable due to TSC halts in idle
[    4.309571] thermal LNXTHERM:00: registered as thermal_zone0
[    4.309574] ACPI: Thermal Zone [THM] (49 C)
[    4.312076] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    4.710848] Non-volatile memory driver v1.3
[    4.710852] Linux agpgart interface v0.103
[    4.711382] [drm] Initialized drm 1.1.0 20060810
[    4.727422] kworker/u:1 used greatest stack depth: 4536 bytes left
[    4.743798] brd: module loaded
[    4.764249] loop: module loaded
[    4.768906] ahci 0000:00:1f.2: version 3.0
[    4.768936] ahci 0000:00:1f.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    4.769176] ahci 0000:00:1f.2: irq 46 for MSI/MSI-X
[    4.769334] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 3 ports 3 Gbps 0x5 impl SATA mode
[    4.769338] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ccc ems 
[    4.769346] ahci 0000:00:1f.2: setting latency timer to 64
[    4.780570] scsi0 : ahci
[    4.784864] scsi1 : ahci
[    4.786345] scsi2 : ahci
[    4.807192] ACPI: Battery Slot [BAT0] (battery present)
[    4.811288] ata1: SATA max UDMA/133 abar m2048@0xfed1c800 port 0xfed1c900 irq 46
[    4.811291] ata2: DUMMY
[    4.811294] ata3: SATA max UDMA/133 abar m2048@0xfed1c800 port 0xfed1ca00 irq 46
[    4.812771] ata_piix 0000:00:1f.1: version 2.13
[    4.812797] ata_piix 0000:00:1f.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    4.812994] ata_piix 0000:00:1f.1: setting latency timer to 64
[    4.820545] scsi3 : ata_piix
[    4.821807] scsi4 : ata_piix
[    4.839886] ata4: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x6fa0 irq 14
[    4.839889] ata5: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x6fa8 irq 15
[    4.840198] ata5: port disabled--ignoring
[    4.843186] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
[    4.843188] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    4.843670] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    4.843673] e100: Copyright(c) 1999-2006 Intel Corporation
[    4.844272] tg3.c:v3.119 (May 18, 2011)
[    4.844328] tg3 0000:09:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    4.844347] tg3 0000:09:00.0: setting latency timer to 64
[    4.862753] tg3 0000:09:00.0: eth0: Tigon3 [partno(BCM95754m) rev b002] (PCI Express) MAC address 00:21:9b:f9:25:cc
[    4.862758] tg3 0000:09:00.0: eth0: attached PHY is 5787 (10/100/1000Base-T Ethernet) (WireSpeed[1], EEE[0])
[    4.862761] tg3 0000:09:00.0: eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
[    4.862764] tg3 0000:09:00.0: eth0: dma_rwctrl[76180000] dma_mask[64-bit]
[    4.863360] sky2: driver version 1.29
[    4.866735] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    4.866738] ehci_hcd: block sizes: qh 112 qtd 96 itd 192 sitd 96
[    4.866909] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    4.866977] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    4.866983] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    4.869846] drivers/usb/core/inode.c: creating file 'devices'
[    4.869980] drivers/usb/core/inode.c: creating file '001'
[    4.871290] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    4.871337] ehci_hcd 0000:00:1a.7: reset hcs_params 0x102204 dbg=1 cc=2 pcc=2 ordered !ppc ports=4
[    4.871342] ehci_hcd 0000:00:1a.7: reset hcc_params 6871 thresh 7 uframes 1024 64 bit addr
[    4.871471] ehci_hcd 0000:00:1a.7: debug port 1
[    4.871477] ehci_hcd 0000:00:1a.7: reset command 0000002 (park)=0 ithresh=0 period=1024 Reset HALT
[    4.875375] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
[    4.875378] ehci_hcd 0000:00:1a.7: supports USB remote wakeup
[    4.875594] ehci_hcd 0000:00:1a.7: irq 22, io mem 0xfed1c400
[    4.875599] ehci_hcd 0000:00:1a.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    4.879488] ehci_hcd 0000:00:1a.7: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
[    4.885060] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    4.885663] usb usb1: default language 0x0409
[    4.885875] usb usb1: udev 1, busnum 1, minor = 0
[    4.885877] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    4.885880] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.885883] usb usb1: Product: EHCI Host Controller
[    4.885885] usb usb1: Manufacturer: Linux 3.1.0-rc8 ehci_hcd
[    4.885887] usb usb1: SerialNumber: 0000:00:1a.7
[    4.887299] usb usb1: usb_probe_device
[    4.887303] usb usb1: configuration #1 chosen from 1 choice
[    4.887554] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    4.888296] hub 1-0:1.0: usb_probe_interface
[    4.888299] hub 1-0:1.0: usb_probe_interface - got id
[    4.888302] hub 1-0:1.0: USB hub found
[    4.888435] hub 1-0:1.0: 4 ports detected
[    4.888448] hub 1-0:1.0: standalone hub
[    4.888450] hub 1-0:1.0: no power switching (usb 1.0)
[    4.888452] hub 1-0:1.0: individual port over-current protection
[    4.888455] hub 1-0:1.0: power on to power good time: 20ms
[    4.888706] hub 1-0:1.0: local power source is good
[    4.888720] hub 1-0:1.0: trying to enable port power on non-switchable hub
[    4.889125] drivers/usb/core/inode.c: creating file '001'
[    4.890165] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    4.890233] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    4.890238] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    4.890288] drivers/usb/core/inode.c: creating file '002'
[    4.891189] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    4.891232] ehci_hcd 0000:00:1d.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[    4.891237] ehci_hcd 0000:00:1d.7: reset hcc_params 6871 thresh 7 uframes 1024 64 bit addr
[    4.891351] ehci_hcd 0000:00:1d.7: debug port 1
[    4.891356] ehci_hcd 0000:00:1d.7: reset command 0000002 (park)=0 ithresh=0 period=1024 Reset HALT
[    4.895244] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    4.895246] ehci_hcd 0000:00:1d.7: supports USB remote wakeup
[    4.895457] ehci_hcd 0000:00:1d.7: irq 20, io mem 0xfed1c000
[    4.895463] ehci_hcd 0000:00:1d.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    4.899355] ehci_hcd 0000:00:1d.7: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
[    4.905030] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    4.905495] usb usb2: default language 0x0409
[    4.905703] usb usb2: udev 1, busnum 2, minor = 128
[    4.905705] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    4.905708] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.905710] usb usb2: Product: EHCI Host Controller
[    4.905712] usb usb2: Manufacturer: Linux 3.1.0-rc8 ehci_hcd
[    4.905714] usb usb2: SerialNumber: 0000:00:1d.7
[    4.906801] usb usb2: usb_probe_device
[    4.906804] usb usb2: configuration #1 chosen from 1 choice
[    4.906900] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[    4.907544] hub 2-0:1.0: usb_probe_interface
[    4.907547] hub 2-0:1.0: usb_probe_interface - got id
[    4.907549] hub 2-0:1.0: USB hub found
[    4.907638] hub 2-0:1.0: 6 ports detected
[    4.907650] hub 2-0:1.0: standalone hub
[    4.907652] hub 2-0:1.0: no power switching (usb 1.0)
[    4.907654] hub 2-0:1.0: individual port over-current protection
[    4.907656] hub 2-0:1.0: power on to power good time: 20ms
[    4.907763] hub 2-0:1.0: local power source is good
[    4.907775] hub 2-0:1.0: trying to enable port power on non-switchable hub
[    4.908267] drivers/usb/core/inode.c: creating file '001'
[    4.909541] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    4.909544] ohci_hcd: block sizes: ed 80 td 96
[    4.909991] uhci_hcd: USB Universal Host Controller Interface driver
[    4.910505] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    4.910536] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    4.910541] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    4.910591] drivers/usb/core/inode.c: creating file '003'
[    4.911414] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    4.911453] uhci_hcd 0000:00:1a.0: detected 2 ports
[    4.911460] uhci_hcd 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x0000
[    4.911463] uhci_hcd 0000:00:1a.0: Performing full reset
[    4.911480] uhci_hcd 0000:00:1a.0: supports USB remote wakeup
[    4.911520] uhci_hcd 0000:00:1a.0: irq 20, io base 0x00006f20
[    4.911905] usb usb3: default language 0x0409
[    4.912455] usb usb3: udev 1, busnum 3, minor = 256
[    4.912458] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    4.912460] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.912463] usb usb3: Product: UHCI Host Controller
[    4.912465] usb usb3: Manufacturer: Linux 3.1.0-rc8 uhci_hcd
[    4.912467] usb usb3: SerialNumber: 0000:00:1a.0
[    4.913698] usb usb3: usb_probe_device
[    4.913701] usb usb3: configuration #1 chosen from 1 choice
[    4.913783] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[    4.914405] hub 3-0:1.0: usb_probe_interface
[    4.914408] hub 3-0:1.0: usb_probe_interface - got id
[    4.914410] hub 3-0:1.0: USB hub found
[    4.914498] hub 3-0:1.0: 2 ports detected
[    4.914510] hub 3-0:1.0: standalone hub
[    4.914512] hub 3-0:1.0: no power switching (usb 1.0)
[    4.914514] hub 3-0:1.0: individual port over-current protection
[    4.914516] hub 3-0:1.0: power on to power good time: 2ms
[    4.914635] hub 3-0:1.0: local power source is good
[    4.914650] hub 3-0:1.0: trying to enable port power on non-switchable hub
[    4.914932] drivers/usb/core/inode.c: creating file '001'
[    4.915541] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.0
[    4.916124] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    4.916154] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    4.916159] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    4.916205] drivers/usb/core/inode.c: creating file '004'
[    4.917195] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    4.917234] uhci_hcd 0000:00:1a.1: detected 2 ports
[    4.917241] uhci_hcd 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x0000
[    4.917243] uhci_hcd 0000:00:1a.1: Performing full reset
[    4.917260] uhci_hcd 0000:00:1a.1: supports USB remote wakeup
[    4.917465] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00006f00
[    4.917807] usb usb4: default language 0x0409
[    4.918029] usb usb4: udev 1, busnum 4, minor = 384
[    4.918032] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    4.918035] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.918037] usb usb4: Product: UHCI Host Controller
[    4.918039] usb usb4: Manufacturer: Linux 3.1.0-rc8 uhci_hcd
[    4.918041] usb usb4: SerialNumber: 0000:00:1a.1
[    4.919131] usb usb4: usb_probe_device
[    4.919134] usb usb4: configuration #1 chosen from 1 choice
[    4.919233] usb usb4: adding 4-0:1.0 (config #1, interface 0)
[    4.919844] hub 4-0:1.0: usb_probe_interface
[    4.919846] hub 4-0:1.0: usb_probe_interface - got id
[    4.919849] hub 4-0:1.0: USB hub found
[    4.919936] hub 4-0:1.0: 2 ports detected
[    4.919948] hub 4-0:1.0: standalone hub
[    4.919950] hub 4-0:1.0: no power switching (usb 1.0)
[    4.919952] hub 4-0:1.0: individual port over-current protection
[    4.919955] hub 4-0:1.0: power on to power good time: 2ms
[    4.920500] hub 4-0:1.0: local power source is good
[    4.920512] hub 4-0:1.0: trying to enable port power on non-switchable hub
[    4.920795] drivers/usb/core/inode.c: creating file '001'
[    4.921127] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.1
[    4.921658] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    4.921688] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    4.921693] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    4.921754] drivers/usb/core/inode.c: creating file '005'
[    4.922585] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
[    4.922625] uhci_hcd 0000:00:1d.0: detected 2 ports
[    4.922632] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
[    4.922634] uhci_hcd 0000:00:1d.0: Performing full reset
[    4.922652] uhci_hcd 0000:00:1d.0: supports USB remote wakeup
[    4.922691] uhci_hcd 0000:00:1d.0: irq 20, io base 0x00006f80
[    4.923230] usb usb5: default language 0x0409
[    4.923437] usb usb5: udev 1, busnum 5, minor = 512
[    4.923440] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    4.923442] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.923445] usb usb5: Product: UHCI Host Controller
[    4.923447] usb usb5: Manufacturer: Linux 3.1.0-rc8 uhci_hcd
[    4.923449] usb usb5: SerialNumber: 0000:00:1d.0
[    4.924816] usb usb5: usb_probe_device
[    4.924819] usb usb5: configuration #1 chosen from 1 choice
[    4.924906] usb usb5: adding 5-0:1.0 (config #1, interface 0)
[    4.925531] hub 5-0:1.0: usb_probe_interface
[    4.925534] hub 5-0:1.0: usb_probe_interface - got id
[    4.925536] hub 5-0:1.0: USB hub found
[    4.925624] hub 5-0:1.0: 2 ports detected
[    4.925637] hub 5-0:1.0: standalone hub
[    4.925638] hub 5-0:1.0: no power switching (usb 1.0)
[    4.925640] hub 5-0:1.0: individual port over-current protection
[    4.925643] hub 5-0:1.0: power on to power good time: 2ms
[    4.925748] hub 5-0:1.0: local power source is good
[    4.925761] hub 5-0:1.0: trying to enable port power on non-switchable hub
[    4.926505] drivers/usb/core/inode.c: creating file '001'
[    4.926991] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.0
[    4.927478] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    4.927507] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    4.927512] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    4.927558] drivers/usb/core/inode.c: creating file '006'
[    4.928517] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
[    4.928557] uhci_hcd 0000:00:1d.1: detected 2 ports
[    4.928564] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
[    4.928566] uhci_hcd 0000:00:1d.1: Performing full reset
[    4.928583] uhci_hcd 0000:00:1d.1: supports USB remote wakeup
[    4.928623] uhci_hcd 0000:00:1d.1: irq 21, io base 0x00006f60
[    4.928966] usb usb6: default language 0x0409
[    4.929190] usb usb6: udev 1, busnum 6, minor = 640
[    4.929193] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    4.929195] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.929198] usb usb6: Product: UHCI Host Controller
[    4.929200] usb usb6: Manufacturer: Linux 3.1.0-rc8 uhci_hcd
[    4.929202] usb usb6: SerialNumber: 0000:00:1d.1
[    4.930879] usb usb6: usb_probe_device
[    4.930882] usb usb6: configuration #1 chosen from 1 choice
[    4.930967] usb usb6: adding 6-0:1.0 (config #1, interface 0)
[    4.931688] hub 6-0:1.0: usb_probe_interface
[    4.931691] hub 6-0:1.0: usb_probe_interface - got id
[    4.931693] hub 6-0:1.0: USB hub found
[    4.931780] hub 6-0:1.0: 2 ports detected
[    4.931792] hub 6-0:1.0: standalone hub
[    4.931794] hub 6-0:1.0: no power switching (usb 1.0)
[    4.931796] hub 6-0:1.0: individual port over-current protection
[    4.931798] hub 6-0:1.0: power on to power good time: 2ms
[    4.931904] hub 6-0:1.0: local power source is good
[    4.931916] hub 6-0:1.0: trying to enable port power on non-switchable hub
[    4.932232] drivers/usb/core/inode.c: creating file '001'
[    4.932733] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.1
[    4.933111] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    4.933141] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    4.933146] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    4.933197] drivers/usb/core/inode.c: creating file '007'
[    4.934218] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
[    4.934263] uhci_hcd 0000:00:1d.2: detected 2 ports
[    4.934270] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
[    4.934272] uhci_hcd 0000:00:1d.2: Performing full reset
[    4.934289] uhci_hcd 0000:00:1d.2: supports USB remote wakeup
[    4.934332] uhci_hcd 0000:00:1d.2: irq 22, io base 0x00006f40
[    4.934678] usb usb7: default language 0x0409
[    4.934885] usb usb7: udev 1, busnum 7, minor = 768
[    4.934888] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    4.934891] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.934893] usb usb7: Product: UHCI Host Controller
[    4.934895] usb usb7: Manufacturer: Linux 3.1.0-rc8 uhci_hcd
[    4.934897] usb usb7: SerialNumber: 0000:00:1d.2
[    4.936151] usb usb7: usb_probe_device
[    4.936155] usb usb7: configuration #1 chosen from 1 choice
[    4.936236] usb usb7: adding 7-0:1.0 (config #1, interface 0)
[    4.936851] hub 7-0:1.0: usb_probe_interface
[    4.936854] hub 7-0:1.0: usb_probe_interface - got id
[    4.936856] hub 7-0:1.0: USB hub found
[    4.936942] hub 7-0:1.0: 2 ports detected
[    4.936954] hub 7-0:1.0: standalone hub
[    4.936956] hub 7-0:1.0: no power switching (usb 1.0)
[    4.936958] hub 7-0:1.0: individual port over-current protection
[    4.936960] hub 7-0:1.0: power on to power good time: 2ms
[    4.937084] hub 7-0:1.0: local power source is good
[    4.937097] hub 7-0:1.0: trying to enable port power on non-switchable hub
[    4.937382] drivers/usb/core/inode.c: creating file '001'
[    4.937873] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.2
[    4.939370] usbcore: registered new interface driver usblp
[    4.939373] Initializing USB Mass Storage driver...
[    4.939863] usbcore: registered new interface driver usb-storage
[    4.939866] USB Mass Storage support registered.
[    4.940583] usbcore: registered new interface driver libusual
[    4.941465] i8042: PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    4.945450] serio: i8042 KBD port at 0x60,0x64 irq 1
[    4.945527] serio: i8042 AUX port at 0x60,0x64 irq 12
[    4.947841] mousedev: PS/2 mouse device common for all mice
[    4.953502] rtc_cmos 00:03: RTC can wake from S4
[    4.954742] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    4.954829] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    4.955333] i801_smbus 0000:00:1f.3: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    4.959759] device-mapper: ioctl: 4.21.0-ioctl (2011-07-06) initialised: dm-devel@redhat.com
[    4.960223] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input5
[    4.960787] Bluetooth: Generic Bluetooth USB driver ver 0.6
[    4.961517] usbcore: registered new interface driver btusb
[    4.967813] cpuidle: using governor ladder
[    4.976952] cpuidle: using governor menu
[    4.976955] EFI Variables Facility v0.08 2004-May-17
[    4.978730] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[    4.989060] ehci_hcd 0000:00:1a.7: GetStatus port:2 status 001803 0  ACK POWER sig=j CSC CONNECT
[    4.989088] hub 1-0:1.0: port 2: status 0501 change 0001
[    4.989206] ehci_hcd 0000:00:1a.7: GetStatus port:3 status 001803 0  ACK POWER sig=j CSC CONNECT
[    4.989229] hub 1-0:1.0: port 3: status 0501 change 0001
[    4.994540] usbcore: registered new interface driver usbhid
[    4.994542] usbhid: USB HID core driver
[    5.004960] snd_hda_intel 0000:00:1b.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[    5.005153] snd_hda_intel 0000:00:1b.0: irq 47 for MSI/MSI-X
[    5.005398] snd_hda_intel 0000:00:1b.0: setting latency timer to 64
[    5.008810] ehci_hcd 0000:00:1d.7: GetStatus port:6 status 001803 0  ACK POWER sig=j CSC CONNECT
[    5.008834] hub 2-0:1.0: port 6: status 0501 change 0001
[    5.010773] ata4.00: ATAPI: TSSTcorp DVD+/-RW TS-L632H, D400, max UDMA/33
[    5.014340] uhci_hcd 0000:00:1a.0: port 2 portsc 008a,00
[    5.020054] uhci_hcd 0000:00:1a.1: port 1 portsc 008a,00
[    5.025228] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    5.032227] hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    5.032614] ata4.00: configured for UDMA/33
[    5.038351] uhci_hcd 0000:00:1d.2: port 2 portsc 0082,00
[    5.089325] hub 1-0:1.0: state 7 ports 4 chg 000c evt 0000
[    5.089471] hub 1-0:1.0: port 2, status 0501, change 0000, 480 Mb/s
[    5.117273] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    5.117328] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    5.121929] ALSA device list:
[    5.121932]   #0: HDA Intel at 0xf7ffc000 irq 47
[    5.122127] Netfilter messages via NETLINK v0.30.
[    5.122263] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    5.124264] ctnetlink v0.93: registering with nfnetlink.
[    5.127717] ip_tables: (C) 2000-2006 Netfilter Core Team
[    5.128054] TCP cubic registered
[    5.128057] Initializing XFRM netlink socket
[    5.131689] NET: Registered protocol family 10
[    5.139491] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    5.139821] IPv6 over IPv4 tunneling driver
[    5.140276] ehci_hcd 0000:00:1a.7: port 2 full speed --> companion
[    5.140282] ehci_hcd 0000:00:1a.7: GetStatus port:2 status 003801 0  ACK POWER OWNER sig=j CONNECT
[    5.140339] hub 1-0:1.0: port 2 not reset yet, waiting 50ms
[    5.144847] NET: Registered protocol family 17
[    5.145061] Registering the dns_resolver key type
[    5.147475] PM: Hibernation image not present or could not be loaded.
[    5.147604] registered taskstats version 1
[    5.148772] ata3.00: ATA-8: ST9160411ASG, DE17, max UDMA/133
[    5.148777] ata3.00: 312581808 sectors, multi 8: LBA48 NCQ (depth 31/32)
[    5.157745] ata1.00: ATA-8: ST9160411ASG, DE17, max UDMA/133
[    5.157749] ata1.00: 312581808 sectors, multi 8: LBA48 NCQ (depth 31/32)
[    5.161568] kmemleak: Kernel memory leak detector initialized
[    5.161578] kmemleak: Automatic memory scanning thread started
[    5.168132]   Magic number: 15:66:95
[    5.168286] console [netcon0] enabled
[    5.168288] netconsole: network logging started
[    5.192332] ehci_hcd 0000:00:1a.7: GetStatus port:2 status 003002 0  ACK POWER OWNER sig=se0 CSC
[    5.192644] hub 1-0:1.0: port 3, status 0501, change 0000, 480 Mb/s
[    5.192917] ata3.00: configured for UDMA/133
[    5.203261] ata1.00: configured for UDMA/133
[    5.204980] scsi 0:0:0:0: Direct-Access     ATA      ST9160411ASG     DE17 PQ: 0 ANSI: 5
[    5.208639] sd 0:0:0:0: [sda] 312581808 512-byte logical blocks: (160 GB/149 GiB)
[    5.209501] sd 0:0:0:0: [sda] Write Protect is off
[    5.209504] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    5.209856] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.216526] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    5.218750] scsi 2:0:0:0: Direct-Access     ATA      ST9160411ASG     DE17 PQ: 0 ANSI: 5
[    5.221988] sd 2:0:0:0: [sdb] 312581808 512-byte logical blocks: (160 GB/149 GiB)
[    5.223183] sd 2:0:0:0: [sdb] Write Protect is off
[    5.223186] sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    5.223537] sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.229677] sd 2:0:0:0: Attached scsi generic sg1 type 0
[    5.234582] scsi 3:0:0:0: CD-ROM            TSSTcorp DVD+-RW TS-L632H D400 PQ: 0 ANSI: 5
[    5.237498]  sda: sda1 sda2 sda3
[    5.243776] ehci_hcd 0000:00:1a.7: port 3 full speed --> companion
[    5.243782] ehci_hcd 0000:00:1a.7: GetStatus port:3 status 003801 0  ACK POWER OWNER sig=j CONNECT
[    5.243809] hub 1-0:1.0: port 3 not reset yet, waiting 50ms
[    5.244760] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    5.244772] cdrom: Uniform CD-ROM driver Revision: 3.20
[    5.245969] sd 0:0:0:0: [sda] Attached SCSI disk
[    5.248567] sr 3:0:0:0: Attached scsi CD-ROM sr0
[    5.250505] sr 3:0:0:0: Attached scsi generic sg2 type 5
[    5.254956]  sdb: sdb1
[    5.259377] sd 2:0:0:0: [sdb] Attached SCSI disk
[    5.294072] ehci_hcd 0000:00:1a.7: GetStatus port:3 status 003002 0  ACK POWER OWNER sig=se0 CSC
[    5.294363] hub 2-0:1.0: state 7 ports 6 chg 0040 evt 0000
[    5.294439] hub 2-0:1.0: port 6, status 0501, change 0000, 480 Mb/s
[    5.345272] ehci_hcd 0000:00:1d.7: port 6 high speed
[    5.345277] ehci_hcd 0000:00:1d.7: GetStatus port:6 status 001005 0  ACK POWER sig=se0 PE CONNECT
[    5.396089] usb 2-6: new high speed USB device number 2 using ehci_hcd
[    5.447400] ehci_hcd 0000:00:1d.7: port 6 high speed
[    5.447405] ehci_hcd 0000:00:1d.7: GetStatus port:6 status 001005 0  ACK POWER sig=se0 PE CONNECT
[    5.514404] usb 2-6: skipped 1 descriptor after configuration
[    5.514417] usb 2-6: skipped 7 descriptors after interface
[    5.514426] usb 2-6: skipped 1 descriptor after endpoint
[    5.514429] usb 2-6: skipped 19 descriptors after interface
[    5.514437] usb 2-6: skipped 1 descriptor after endpoint
[    5.514743] usb 2-6: default language 0x0409
[    5.516057] usb 2-6: udev 2, busnum 2, minor = 129
[    5.516060] usb 2-6: New USB device found, idVendor=05a9, idProduct=2640
[    5.516062] usb 2-6: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    5.516065] usb 2-6: Product: Laptop Integrated Webcam
[    5.516067] usb 2-6: Manufacturer: OmniVision Technologies, Inc. -2640-07.07.20.3
[    5.517127] usb 2-6: usb_probe_device
[    5.517131] usb 2-6: configuration #1 chosen from 1 choice
[    5.517532] usb 2-6: adding 2-6:1.0 (config #1, interface 0)
[    5.518894] usb 2-6: adding 2-6:1.1 (config #1, interface 1)
[    5.519556] drivers/usb/core/inode.c: creating file '002'
[    5.519758] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0004
[    5.519799] uhci_hcd 0000:00:1a.0: port 2 portsc 0093,00
[    5.519860] hub 3-0:1.0: port 2, status 0101, change 0001, 12 Mb/s
[    5.594193] Synaptics Touchpad, model: 1, fw: 6.3, id: 0x1a0b1, caps: 0xa04793/0x300000/0x0
[    5.594240] serio: Synaptics pass-through port at isa0060/serio1/input0
[    5.623318] hub 3-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x101
[    5.632944] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input6
[    5.637699] md: Waiting for all devices to be available before autodetect
[    5.637701] md: If you don't use raid, use raid=noautodetect
[    5.640994] md: Autodetecting RAID arrays.
[    5.640997] md: Scanned 0 and added 0 devices.
[    5.641014] md: autorun ...
[    5.641016] md: ... autorun DONE.
[    5.694684] kjournald starting.  Commit interval 5 seconds
[    5.695029] EXT3-fs (sda3): mounted filesystem with writeback data mode
[    5.695107] VFS: Mounted root (ext3 filesystem) readonly on device 8:3.
[    5.725151] usb 3-2: new full speed USB device number 2 using uhci_hcd
[    5.752276] devtmpfs: mounted
[    5.761248] Freeing unused kernel memory: 3048k freed
[    5.762930] Write protecting the kernel read-only data: 10240k
[    5.763873] Freeing unused kernel memory: 148k freed
[    5.768158] Freeing unused kernel memory: 940k freed
[    5.845100] usb 3-2: ep0 maxpacket = 8
[    5.871817] usb 3-2: default language 0x0409
[    5.885854] usb 3-2: udev 2, busnum 3, minor = 257
[    5.885857] usb 3-2: New USB device found, idVendor=0a5c, idProduct=4500
[    5.885860] usb 3-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    5.885863] usb 3-2: Product: BCM2045B2
[    5.885865] usb 3-2: Manufacturer: Broadcom
[    5.886905] usb 3-2: usb_probe_device
[    5.886910] usb 3-2: configuration #1 chosen from 1 choice
[    5.888949] usb 3-2: adding 3-2:1.0 (config #1, interface 0)
[    5.889597] hub 3-2:1.0: usb_probe_interface
[    5.889600] hub 3-2:1.0: usb_probe_interface - got id
[    5.889603] hub 3-2:1.0: USB hub found
[    5.890877] hub 3-2:1.0: 3 ports detected
[    5.890889] hub 3-2:1.0: compound device; port removable status: FFF
[    5.890891] hub 3-2:1.0: ganged power switching
[    5.890893] hub 3-2:1.0: global over-current protection
[    5.890895] hub 3-2:1.0: power on to power good time: 100ms
[    5.891826] hub 3-2:1.0: hub controller current requirement: 100mA
[    5.891832] hub 3-2:1.0: 100mA bus power budget for each child
[    5.892876] hub 3-2:1.0: local power source is good
[    5.892879] hub 3-2:1.0: no over-current condition exists
[    5.892890] hub 3-2:1.0: enabling power on all ports
[    5.896047] drivers/usb/core/inode.c: creating file '002'
[    5.896254] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0002
[    5.896279] uhci_hcd 0000:00:1a.1: port 1 portsc 0093,00
[    5.896341] hub 4-0:1.0: port 1, status 0101, change 0001, 12 Mb/s
[    5.954055] usb usb6: suspend_rh (auto-stop)
[    5.954061] usb usb5: suspend_rh (auto-stop)
[    5.996848] hub 3-2:1.0: port 1: status 0101 change 0001
[    5.998831] hub 3-2:1.0: port 2: status 0101 change 0001
[    6.000830] hub 3-2:1.0: port 3: status 0101 change 0001
[    6.001135] hub 4-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x101
[    6.101095] uhci_hcd 0000:00:1a.0: reserve dev 2 ep81-INT, period 128, phase 0, 12 us
[    6.103142] usb 4-1: new full speed USB device number 2 using uhci_hcd
[    6.204052] usb usb7: suspend_rh (auto-stop)
[    6.223070] usb 4-1: ep0 maxpacket = 8
[    6.248756] usb 4-1: skipped 1 descriptor after interface
[    6.253737] usb 4-1: default language 0x0409
[    6.261771] usb 4-1: udev 2, busnum 4, minor = 385
[    6.261774] usb 4-1: New USB device found, idVendor=046d, idProduct=c251
[    6.261777] usb 4-1: New USB device strings: Mfr=0, Product=2, SerialNumber=0
[    6.261779] usb 4-1: Product: GamePanel LCD
[    6.262731] usb 4-1: usb_probe_device
[    6.262735] usb 4-1: configuration #1 chosen from 1 choice
[    6.264771] usb 4-1: adding 4-1:1.0 (config #1, interface 0)
[    6.265393] usbhid 4-1:1.0: usb_probe_interface
[    6.265396] usbhid 4-1:1.0: usb_probe_interface - got id
[    6.284687] usbhid 4-1:1.0: looking for a minor, starting at 96
[    6.287105] generic-usb 0003:046D:C251.0001: hiddev0,hidraw0: USB HID v1.11 Device [GamePanel LCD] on usb-0000:00:1a.1-1/input0
[    6.287537] drivers/usb/core/inode.c: creating file '002'
[    6.287742] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    6.287747] hub 1-0:1.0: state 7 ports 4 chg 0000 evt 0008
[    6.287792] hub 3-2:1.0: state 7 ports 3 chg 000e evt 0000
[    6.289854] hub 3-2:1.0: port 1, status 0101, change 0000, 12 Mb/s
[    6.354840] usb 3-2.1: new full speed USB device number 3 using uhci_hcd
[    6.458941] usb 3-2.1: skipped 1 descriptor after interface
[    6.463842] usb 3-2.1: default language 0x0409
[    6.473871] usb 3-2.1: udev 3, busnum 3, minor = 258
[    6.473874] usb 3-2.1: New USB device found, idVendor=413c, idProduct=8126
[    6.473877] usb 3-2.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    6.473880] usb 3-2.1: Product: BCM2045
[    6.473882] usb 3-2.1: Manufacturer: Broadcom Corp
[    6.474867] usb 3-2.1: usb_probe_device
[    6.474872] usb 3-2.1: configuration #1 chosen from 1 choice
[    6.476981] usb 3-2.1: adding 3-2.1:1.0 (config #1, interface 0)
[    6.477647] btusb 3-2.1:1.0: usb_probe_interface
[    6.477650] btusb 3-2.1:1.0: usb_probe_interface - got id
[    6.596214] hostname used greatest stack depth: 4080 bytes left
[    6.599577] hwclock used greatest stack depth: 3456 bytes left
[    6.717700] plymouthd used greatest stack depth: 3024 bytes left
[    7.085197] uhci_hcd 0000:00:1a.0: reserve dev 3 ep81-INT, period 1, phase 0, 23 us
[    7.085983] usb 3-2.1: adding 3-2.1:1.1 (config #1, interface 1)
[    7.087084] usb 3-2.1: adding 3-2.1:1.2 (config #1, interface 2)
[    7.087692] btusb 3-2.1:1.2: usb_probe_interface
[    7.087696] btusb 3-2.1:1.2: usb_probe_interface - got id
[    7.088225] usb 3-2.1: adding 3-2.1:1.3 (config #1, interface 3)
[    7.088825] btusb 3-2.1:1.3: usb_probe_interface
[    7.088828] btusb 3-2.1:1.3: usb_probe_interface - got id
[    7.088876] drivers/usb/core/inode.c: creating file '003'
[    7.089350] hub 3-2:1.0: 400mA power budget left
[    7.090082] hub 3-2:1.0: port 2, status 0101, change 0000, 12 Mb/s
[    7.153987] usb 3-2.2: new full speed USB device number 4 using uhci_hcd
[    7.233077] usb 3-2.2: ep0 maxpacket = 8
[    7.257886] usb 3-2.2: skipped 1 descriptor after interface
[    7.262857] usb 3-2.2: default language 0x0409
[    7.270896] usb 3-2.2: udev 4, busnum 3, minor = 259
[    7.270899] usb 3-2.2: New USB device found, idVendor=0a5c, idProduct=4502
[    7.270902] usb 3-2.2: New USB device strings: Mfr=1, Product=0, SerialNumber=0
[    7.270904] usb 3-2.2: Manufacturer: Broadcom Corp
[    7.271877] usb 3-2.2: usb_probe_device
[    7.271881] usb 3-2.2: configuration #1 chosen from 1 choice
[    7.274983] usb 3-2.2: adding 3-2.2:1.0 (config #1, interface 0)
[    7.275640] usbhid 3-2.2:1.0: usb_probe_interface
[    7.275643] usbhid 3-2.2:1.0: usb_probe_interface - got id
[    7.280574] input: Broadcom Corp as /devices/pci0000:00/0000:00:1a.0/usb3/3-2/3-2.2/3-2.2:1.0/input/input7
[    7.280735] uhci_hcd 0000:00:1a.0: reserve dev 4 ep81-INT, period 8, phase 4, 17 us
[    7.282790] generic-usb 0003:0A5C:4502.0002: input,hidraw1: USB HID v1.11 Keyboard [Broadcom Corp] on usb-0000:00:1a.0-2.2/input0
[    7.282975] drivers/usb/core/inode.c: creating file '004'
[    7.283183] hub 3-2:1.0: 400mA power budget left
[    7.283860] hub 3-2:1.0: port 3, status 0101, change 0000, 12 Mb/s
[    7.346878] usb 3-2.3: new full speed USB device number 5 using uhci_hcd
[    7.391223] mountall used greatest stack depth: 2656 bytes left
[    7.429095] usb 3-2.3: ep0 maxpacket = 8
[    7.453895] usb 3-2.3: skipped 1 descriptor after interface
[    7.458869] usb 3-2.3: default language 0x0409
[    7.466903] usb 3-2.3: udev 5, busnum 3, minor = 260
[    7.466906] usb 3-2.3: New USB device found, idVendor=0a5c, idProduct=4503
[    7.466908] usb 3-2.3: New USB device strings: Mfr=1, Product=0, SerialNumber=0
[    7.466911] usb 3-2.3: Manufacturer: Broadcom Corp
[    7.467927] usb 3-2.3: usb_probe_device
[    7.467931] usb 3-2.3: configuration #1 chosen from 1 choice
[    7.470948] usb 3-2.3: adding 3-2.3:1.0 (config #1, interface 0)
[    7.471583] usbhid 3-2.3:1.0: usb_probe_interface
[    7.471586] usbhid 3-2.3:1.0: usb_probe_interface - got id
[    7.477755] input: Broadcom Corp as /devices/pci0000:00/0000:00:1a.0/usb3/3-2/3-2.3/3-2.3:1.0/input/input8
[    7.480433] generic-usb 0003:0A5C:4503.0003: input,hidraw2: USB HID v1.11 Mouse [Broadcom Corp] on usb-0000:00:1a.0-2.3/input0
[    7.480621] drivers/usb/core/inode.c: creating file '005'
[    7.480817] hub 3-2:1.0: 400mA power budget left
[    7.480821] hub 3-2:1.0: state 7 ports 3 chg 0000 evt 0008
[    9.168964] uhci_hcd 0000:00:1a.0: release dev 3 ep81-INT, period 1, phase 0, 23 us
[    9.478029] udev[1206]: starting version 167
[   11.124335] firewire_ohci 0000:05:01.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[   11.178754] firewire_ohci: Added fw-ohci device 0000:05:01.0, OHCI v1.10, 4 IR + 4 IT contexts, quirks 0x1
[   11.684409] firewire_core: created device fw0: GUID 364fc00033661c90, S400
[   11.709358] Linux video capture interface: v2.00
[   12.073205] sdhci: Secure Digital Host Controller Interface driver
[   12.073208] sdhci: Copyright(c) Pierre Ossman
[   12.119380] sdhci-pci 0000:05:01.1: SDHCI controller found [1180:0822] (rev 22)
[   12.119448] sdhci-pci 0000:05:01.1: PCI INT B -> GSI 18 (level, low) -> IRQ 18
[   12.123457] Registered led device: mmc0::
[   12.125456] mmc0: SDHCI controller on PCI [0000:05:01.1] using DMA
[   12.176710] uvcvideo 2-6:1.0: usb_probe_interface
[   12.176715] uvcvideo 2-6:1.0: usb_probe_interface - got id
[   12.176859] uvcvideo: Found UVC 1.00 device Laptop Integrated Webcam (05a9:2640)
[   12.178056] uvcvideo: UVC non compliance - GET_DEF(PROBE) not supported. Enabling workaround.
[   12.182835] input: Laptop Integrated Webcam as /devices/pci0000:00/0000:00:1d.7/usb2/2-6/2-6:1.0/input/input9
[   12.186411] usbcore: registered new interface driver uvcvideo
[   12.186414] USB Video Class driver (1.1.1)
[   12.239548] r852 0000:05:01.3: PCI INT B -> GSI 18 (level, low) -> IRQ 18
[   12.240023] r852: driver loaded successfully
[   12.798316] usb 2-6: link qh1024-0001/ffff880135e67480 start 1 [1/0 us]
[   12.798409] usb 2-6: unlink qh1024-0001/ffff880135e67480 start 1 [1/0 us]
[   13.119373] input: Dell WMI hotkeys as /devices/virtual/input/input10
[   13.804312] sed used greatest stack depth: 2592 bytes left
[   14.233693] iwl4965: Intel(R) Wireless WiFi 4965 driver for Linux, in-tree:d
[   14.233697] iwl4965: Copyright(c) 2003-2011 Intel Corporation
[   14.233986] iwl4965 0000:0c:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   14.234065] iwl4965 0000:0c:00.0: setting latency timer to 64
[   14.234194] iwl4965 0000:0c:00.0: Detected Intel(R) Wireless WiFi Link 4965AGN, REV=0x4
[   14.277252] iwl4965 0000:0c:00.0: device EEPROM VER=0x36, CALIB=0x5
[   14.277348] iwl4965 0000:0c:00.0: Tunable channels: 13 802.11bg, 19 802.11a channels
[   14.277670] iwl4965 0000:0c:00.0: irq 48 for MSI/MSI-X
[   14.803173] iwl4965 0000:0c:00.0: loaded firmware version 228.61.2.24
[   14.805253] Registered led device: phy0-led
[   14.810438] ieee80211 phy0: Selected rate control algorithm 'iwl-4965-rs'
[   15.058227] hdparm used greatest stack depth: 2432 bytes left
[   15.647803] Adding 506040k swap on /dev/sda2.  Priority:-1 extents:1 across:506040k 
[   16.297709] EXT3-fs (sda3): using internal journal
[   16.316499] nouveau 0000:03:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   16.316508] nouveau 0000:03:00.0: setting latency timer to 64
[   16.327629] [drm] nouveau 0000:03:00.0: Detected an NV50 generation card (0x092600a2)
[   16.344210] [drm] nouveau 0000:03:00.0: Attempting to load BIOS image from PRAMIN
[   16.457295] [drm] nouveau 0000:03:00.0: ... appears to be valid
[   16.457301] [drm] nouveau 0000:03:00.0: BIT BIOS found
[   16.457304] [drm] nouveau 0000:03:00.0: Bios version 62.92.2c.00
[   16.457308] [drm] nouveau 0000:03:00.0: TMDS table version 2.0
[   16.457311] [drm] nouveau 0000:03:00.0: Found Display Configuration Block version 4.0
[   16.457315] [drm] nouveau 0000:03:00.0: Raw DCB entry 0: 01000323 00010034
[   16.457318] [drm] nouveau 0000:03:00.0: Raw DCB entry 1: 04011310 00000028
[   16.457321] [drm] nouveau 0000:03:00.0: Raw DCB entry 2: 02021312 00000030
[   16.457323] [drm] nouveau 0000:03:00.0: Raw DCB entry 3: 010323f1 00c0c080
[   16.457325] [drm] nouveau 0000:03:00.0: Raw DCB entry 4: 0000000e 00000000
[   16.457329] [drm] nouveau 0000:03:00.0: DCB connector table: VHER 0x40 5 16 4
[   16.457332] [drm] nouveau 0000:03:00.0:   0: 0x00000041: type 0x41 idx 0 tag 0xff
[   16.457335] [drm] nouveau 0000:03:00.0:   1: 0x00001130: type 0x30 idx 1 tag 0x07
[   16.457338] [drm] nouveau 0000:03:00.0:   2: 0x00000210: type 0x10 idx 2 tag 0xff
[   16.457340] [drm] nouveau 0000:03:00.0:   3: 0x00000211: type 0x11 idx 3 tag 0xff
[   16.457343] [drm] nouveau 0000:03:00.0:   4: 0x00000213: type 0x13 idx 4 tag 0xff
[   16.457348] [drm] nouveau 0000:03:00.0: Parsing VBIOS init table 0 at offset 0xC582
[   16.485999] [drm] nouveau 0000:03:00.0: Parsing VBIOS init table 1 at offset 0xC933
[   16.488876] [drm] nouveau 0000:03:00.0: Parsing VBIOS init table 2 at offset 0xD6AE
[   16.488887] [drm] nouveau 0000:03:00.0: Parsing VBIOS init table 3 at offset 0xD7D0
[   16.489979] [drm] nouveau 0000:03:00.0: Parsing VBIOS init table 4 at offset 0xDA00
[   16.489982] [drm] nouveau 0000:03:00.0: Parsing VBIOS init table at offset 0xDA65
[   16.509989] [drm] nouveau 0000:03:00.0: 0xDA65: Condition still not met after 20ms, skipping following opcodes
[   16.553467] [drm] nouveau 0000:03:00.0: 4 available performance level(s)
[   16.553473] [drm] nouveau 0000:03:00.0: 0: memory 100MHz core 200MHz shader 400MHz voltage 850mV fanspeed 100% timing 0
[   16.553477] [drm] nouveau 0000:03:00.0: 1: memory 301MHz core 275MHz shader 550MHz voltage 850mV fanspeed 100% timing 1
[   16.553482] [drm] nouveau 0000:03:00.0: 2: memory 301MHz core 383MHz shader 767MHz voltage 850mV fanspeed 100% timing 1
[   16.553487] [drm] nouveau 0000:03:00.0: 3: memory 799MHz core 500MHz shader 1250MHz voltage 1000mV fanspeed 100% timing 3
[   16.553520] [drm] nouveau 0000:03:00.0: c: memory 300MHz core 275MHz shader 550MHz voltage 850mV
[   16.576352] [TTM] Zone  kernel: Available graphics memory: 2017630 kiB.
[   16.576355] [TTM] Initializing pool allocator.
[   16.576623] [drm] nouveau 0000:03:00.0: Detected 512MiB VRAM
[   16.581044] [drm] nouveau 0000:03:00.0: 512 MiB GART (aperture)
[   16.619484] [drm] nouveau 0000:03:00.0: ACPI backlight interface available, not registering our own
[   16.643919] [drm] nouveau 0000:03:00.0: DCB encoder 1 unknown
[   16.643924] [drm] nouveau 0000:03:00.0: TV-1 has no encoders, removing
[   16.651047] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[   16.651050] [drm] No driver support for vblank timestamp query.
[   16.775133] kjournald starting.  Commit interval 5 seconds
[   16.776128] EXT3-fs (sdb1): using internal journal
[   16.776140] EXT3-fs (sdb1): mounted filesystem with writeback data mode
[   16.914827] [drm] nouveau 0000:03:00.0: allocated 1920x1200 fb: 0x330000, bo ffff880136e2d800
[   16.917533] fbcon: nouveaufb (fb0) is primary device
[   18.205540] Console: switching to colour frame buffer device 240x75
[   18.209478] fb0: nouveaufb frame buffer device
[   18.209479] drm: registered panic notifier
[   18.209556] [drm] Initialized nouveau 0.0.16 20090420 for 0000:03:00.0 on minor 0
[   18.211712] nouveau 0000:04:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   18.211721] nouveau 0000:04:00.0: setting latency timer to 64
[   18.219947] [drm] nouveau 0000:04:00.0: Detected an NV50 generation card (0x092600a2)
[   18.247512] [drm] nouveau 0000:04:00.0: Attempting to load BIOS image from PRAMIN
[   18.247523] [drm] nouveau 0000:04:00.0: ... BIOS signature not found
[   18.247525] [drm] nouveau 0000:04:00.0: Attempting to load BIOS image from PROM
[   18.434784] [drm] nouveau 0000:04:00.0: ... appears to be valid
[   18.434789] [drm] nouveau 0000:04:00.0: BIT BIOS found
[   18.434792] [drm] nouveau 0000:04:00.0: Bios version 62.92.2c.00
[   18.434795] [drm] nouveau 0000:04:00.0: TMDS table version 2.0
[   18.434798] [drm] nouveau 0000:04:00.0: Found Display Configuration Block version 4.0
[   18.434802] [drm] nouveau 0000:04:00.0: Raw DCB entry 0: 01000323 00010034
[   18.434805] [drm] nouveau 0000:04:00.0: Raw DCB entry 1: 0000000e 00000000
[   18.434808] [drm] nouveau 0000:04:00.0: DCB connector table: VHER 0x40 5 16 4
[   18.434811] [drm] nouveau 0000:04:00.0:   0: 0x00000041: type 0x41 idx 0 tag 0xff
[   18.434819] [drm] nouveau 0000:04:00.0: Adaptor not initialised, running VBIOS init tables.
[   18.434822] [drm] nouveau 0000:04:00.0: Parsing VBIOS init table 0 at offset 0xC582
[   18.462255] [drm] nouveau 0000:04:00.0: Parsing VBIOS init table 1 at offset 0xC933
[   18.465139] [drm] nouveau 0000:04:00.0: Parsing VBIOS init table 2 at offset 0xD6AE
[   18.465184] [drm] nouveau 0000:04:00.0: Parsing VBIOS init table 3 at offset 0xD7D0
[   18.466304] [drm] nouveau 0000:04:00.0: Parsing VBIOS init table 4 at offset 0xDA00
[   18.472142] [drm] nouveau 0000:04:00.0: Parsing VBIOS init table at offset 0xDA65
[   18.511772] [drm] nouveau 0000:04:00.0: 4 available performance level(s)
[   18.511778] [drm] nouveau 0000:04:00.0: 0: memory 100MHz core 200MHz shader 400MHz voltage 850mV fanspeed 100% timing 0
[   18.511783] [drm] nouveau 0000:04:00.0: 1: memory 301MHz core 275MHz shader 550MHz voltage 850mV fanspeed 100% timing 1
[   18.511787] [drm] nouveau 0000:04:00.0: 2: memory 301MHz core 383MHz shader 767MHz voltage 850mV fanspeed 100% timing 1
[   18.511792] [drm] nouveau 0000:04:00.0: 3: memory 799MHz core 500MHz shader 1250MHz voltage 1000mV fanspeed 100% timing 3
[   18.511822] [drm] nouveau 0000:04:00.0: c: memory 300MHz core 275MHz shader 550MHz voltage 850mV
[   18.529899] [drm] nouveau 0000:04:00.0: Detected 512MiB VRAM
[   18.530801] [drm] nouveau 0000:04:00.0: 512 MiB GART (aperture)
[   18.556763] [drm] nouveau 0000:04:00.0: ACPI backlight interface available, not registering our own
[   18.559485] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[   18.559487] [drm] No driver support for vblank timestamp query.
[   18.595658] No connectors reported connected with modes
[   18.595719] [drm] Cannot find any crtc or sizes - going 1024x768
[   18.599436] [drm] nouveau 0000:04:00.0: allocated 1024x768 fb: 0x330000, bo ffff880133aa1400
[   18.600552] fb1: nouveaufb frame buffer device
[   18.600565] [drm] Initialized nouveau 0.0.16 20090420 for 0000:04:00.0 on minor 1
[   26.151571] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   26.166871] tg3 0000:09:00.0: irq 49 for MSI/MSI-X
[   26.231626] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   26.381699] uhci_hcd 0000:00:1a.0: reserve dev 3 ep81-INT, period 1, phase 0, 23 us
[   27.994966] uhci_hcd 0000:00:1a.0: reserve dev 5 ep81-INT, period 8, phase 4, 14 us
[  142.054557] hda-intel: Invalid position buffer, using LPIB read method instead.
[  151.669597] ehci_hcd 0000:00:1d.7: reused qh ffff880135e67480 schedule
[  151.669606] usb 2-6: link qh1024-0001/ffff880135e67480 start 1 [1/0 us]
[  151.686776] usb 2-6: unlink qh1024-0001/ffff880135e67480 start 1 [1/0 us]
[  157.092476] wlan0: authenticate with 00:18:f6:aa:6e:25 (try 1)
[  157.098780] wlan0: authenticated
[  157.100252] wlan0: associate with 00:18:f6:aa:6e:25 (try 1)
[  157.102874] wlan0: RX AssocResp from 00:18:f6:aa:6e:25 (capab=0x411 status=0 aid=3)
[  157.102878] wlan0: associated
[  157.132969] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[  167.370027] wlan0: no IPv6 routers present
[  729.689986] kmemleak: 41 new suspected memory leaks (see /sys/kernel/debug/kmemleak)

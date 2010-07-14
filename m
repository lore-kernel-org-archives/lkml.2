Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705Ab0GNGzN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 02:55:13 -0400
Received: from fep15.mx.upcmail.net ([62.179.121.35]:51049 "EHLO
	fep15.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834Ab0GNGzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 02:55:07 -0400
X-SourceIP: 77.57.188.152
Message-ID: <4C3D5F3F.7070901@odi.ch>
Date: Wed, 14 Jul 2010 08:54:55 +0200
From: =?ISO-8859-1?Q?Ortwin_Gl=FCck?= <odi@odi.ch>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100703 Thunderbird/3.0.5
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: BUG at arch/x86/mm/physaddr.c:5
X-Enigmail-Version: 1.0.1
Content-Type: multipart/mixed;
 boundary="------------090708000208020402030405"
X-Cloudmark-Analysis: v=1.1 cv=O+FWVpunvrlG1gSnSO6WiIQ7o0MJ4laHqrEcUJ8XjIg= c=1 sm=0 a=guI_D4wa_nYA:10 a=mI6YO6ZdSLUA:10 a=j3SzZLbzG3Ax9x5HqwMA:9 a=gEd0DRTaAG-m-U3lY4TO_sCEC_YA:4 a=wPNLvfGTeEIA:10 a=pSDxxfrZAAAA:8 a=EUspDBNiAAAA:8 a=FzLSmBR4IO5aHi5V03oA:9 a=txjgxQ2z9No2_Xztzh8A:7 a=Kihbkckrg_bN7Bwqn0sgCwu53rwA:4 a=IG2fH9E8heMA:10 a=ZT4YM8-qQhkuoBXA:21 a=SqrtxoYww5-0u3s8:21 a=15CefqGMg632WhFtWfAA:9 a=kmOaEjstSIETd9V_MD4A:7 a=iwqkpHw2iw_VAVdSk5D9QqEAuaoA:4 a=0vq1PPO-8eWNDuVG:21 a=zWg_0E25_dg55OSt:21 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090708000208020402030405
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

There is also a DMA warning later on.

--------------090708000208020402030405
Content-Type: text/plain;
 name="boot.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="boot.log"

Jul 14 08:25:50 mithril syslog-ng[3044]: syslog-ng starting up; version='3.1.1'
Jul 14 08:25:51 mithril kernel: Linux version 2.6.35-rc5 (root@mithril) (gcc version 4.3.4 (Gentoo 4.3.4 p1.0, pie-10.1.5) ) #10 SMP PREEMPT Tue Jul 13 19:04:00 CEST 2010
Jul 14 08:25:51 mithril kernel: BIOS-provided physical RAM map:
Jul 14 08:25:51 mithril kernel: BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
Jul 14 08:25:51 mithril kernel: BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
Jul 14 08:25:51 mithril kernel: BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
Jul 14 08:25:51 mithril kernel: BIOS-e820: 0000000000100000 - 000000007f0e7000 (usable)
Jul 14 08:25:51 mithril kernel: BIOS-e820: 000000007f0e7000 - 000000007f2e8000 (ACPI NVS)
Jul 14 08:25:51 mithril kernel: BIOS-e820: 000000007f2e8000 - 000000007febe000 (ACPI data)
Jul 14 08:25:51 mithril kernel: BIOS-e820: 000000007febe000 - 000000007feef000 (ACPI NVS)
Jul 14 08:25:51 mithril kernel: BIOS-e820: 000000007feef000 - 000000007ff00000 (ACPI data)
Jul 14 08:25:51 mithril kernel: BIOS-e820: 000000007ff00000 - 0000000080000000 (reserved)
Jul 14 08:25:51 mithril kernel: BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
Jul 14 08:25:51 mithril kernel: BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
Jul 14 08:25:51 mithril kernel: BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
Jul 14 08:25:51 mithril kernel: BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
Jul 14 08:25:51 mithril kernel: BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
Jul 14 08:25:51 mithril kernel: BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
Jul 14 08:25:51 mithril kernel: Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
Jul 14 08:25:51 mithril kernel: DMI 2.4 present.
Jul 14 08:25:51 mithril kernel: e820 update range: 0000000000000000 - 0000000000001000 (usable) ==> (reserved)
Jul 14 08:25:51 mithril kernel: e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
Jul 14 08:25:51 mithril kernel: last_pfn = 0x7f0e7 max_arch_pfn = 0x100000
Jul 14 08:25:51 mithril kernel: MTRR default type: uncachable
Jul 14 08:25:51 mithril kernel: MTRR fixed ranges enabled:
Jul 14 08:25:51 mithril kernel: 00000-9FFFF write-back
Jul 14 08:25:51 mithril kernel: A0000-BFFFF uncachable
Jul 14 08:25:51 mithril kernel: C0000-CFFFF write-protect
Jul 14 08:25:51 mithril kernel: D0000-DFFFF uncachable
Jul 14 08:25:51 mithril kernel: E0000-FFFFF write-protect
Jul 14 08:25:51 mithril kernel: MTRR variable ranges enabled:
Jul 14 08:25:51 mithril smartd[3032]: Device: /dev/sda, found in smartd database.
Jul 14 08:25:51 mithril kernel: 0 base 0FFE00000 mask FFFE00000 write-protect
Jul 14 08:25:51 mithril kernel: 1 base 000000000 mask F80000000 write-back
Jul 14 08:25:51 mithril kernel: 2 base 07FF00000 mask FFFF00000 uncachable
Jul 14 08:25:51 mithril kernel: 3 disabled
Jul 14 08:25:51 mithril kernel: 4 disabled
Jul 14 08:25:51 mithril kernel: 5 disabled
Jul 14 08:25:51 mithril kernel: 6 disabled
Jul 14 08:25:51 mithril kernel: 7 disabled
Jul 14 08:25:51 mithril kernel: x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
Jul 14 08:25:51 mithril kernel: initial memory mapped : 0 - 02000000
Jul 14 08:25:51 mithril kernel: init_memory_mapping: 0000000000000000-00000000377fe000
Jul 14 08:25:51 mithril kernel: 0000000000 - 0000400000 page 4k
Jul 14 08:25:51 mithril kernel: 0000400000 - 0037400000 page 2M
Jul 14 08:25:51 mithril kernel: 0037400000 - 00377fe000 page 4k
Jul 14 08:25:51 mithril kernel: kernel direct mapping tables up to 377fe000 @ 7000-c000
Jul 14 08:25:51 mithril kernel: ACPI: RSDP 000fe020 00024 (v02 APPLE )
Jul 14 08:25:51 mithril kernel: ACPI: XSDT 7fefd1c0 00074 (v01 APPLE   Apple00 000000A5      01000013)
Jul 14 08:25:51 mithril kernel: ACPI: FACP 7fefb000 000F4 (v03 APPLE   Apple00 000000A5 Loki 0000005F)
Jul 14 08:25:51 mithril kernel: ACPI: DSDT 7fef0000 048BD (v01 APPLE  MacBookP 00020001 INTL 20050309)
Jul 14 08:25:51 mithril kernel: ACPI: FACS 7fec0000 00040
Jul 14 08:25:51 mithril kernel: ACPI: HPET 7fefa000 00038 (v01 APPLE   Apple00 00000001 Loki 0000005F)
Jul 14 08:25:51 mithril kernel: ACPI: APIC 7fef9000 00068 (v01 APPLE   Apple00 00000001 Loki 0000005F)
Jul 14 08:25:51 mithril kernel: ACPI: MCFG 7fef8000 0003C (v01 APPLE   Apple00 00000001 Loki 0000005F)
Jul 14 08:25:51 mithril kernel: ACPI: ASF! 7fef7000 000A0 (v32 APPLE   Apple00 00000001 Loki 0000005F)
Jul 14 08:25:51 mithril kernel: ACPI: SBST 7fef6000 00030 (v01 APPLE   Apple00 00000001 Loki 0000005F)
Jul 14 08:25:51 mithril kernel: ACPI: ECDT 7fef5000 00053 (v01 APPLE   Apple00 00000001 Loki 0000005F)
Jul 14 08:25:51 mithril kernel: ACPI: SSDT 7feef000 004DC (v01 APPLE     CpuPm 00003000 INTL 20050309)
Jul 14 08:25:51 mithril kernel: ACPI: SSDT 7febd000 0064F (v01 SataRe  SataPri 00001000 INTL 20050309)
Jul 14 08:25:51 mithril kernel: ACPI: SSDT 7febc000 0069C (v01 SataRe  SataSec 00001000 INTL 20050309)
Jul 14 08:25:51 mithril kernel: ACPI: Local APIC address 0xfee00000
Jul 14 08:25:51 mithril kernel: 1144MB HIGHMEM available.
Jul 14 08:25:51 mithril kernel: 887MB LOWMEM available.
Jul 14 08:25:51 mithril kernel: mapped low ram: 0 - 377fe000
Jul 14 08:25:51 mithril kernel: low ram: 0 - 377fe000
Jul 14 08:25:51 mithril kernel: Zone PFN ranges:
Jul 14 08:25:51 mithril kernel: DMA      0x00000001 -> 0x00001000
Jul 14 08:25:51 mithril kernel: Normal   0x00001000 -> 0x000377fe
Jul 14 08:25:51 mithril kernel: HighMem  0x000377fe -> 0x0007f0e7
Jul 14 08:25:51 mithril kernel: Movable zone start PFN for each node
Jul 14 08:25:51 mithril kernel: early_node_map[2] active PFN ranges
Jul 14 08:25:51 mithril kernel: 0: 0x00000001 -> 0x0000009f
Jul 14 08:25:51 mithril kernel: 0: 0x00000100 -> 0x0007f0e7
Jul 14 08:25:51 mithril kernel: On node 0 totalpages: 520325
Jul 14 08:25:51 mithril kernel: free_area_init_node: node 0, pgdat c17f8300, node_mem_map c1ccd020
Jul 14 08:25:51 mithril kernel: DMA zone: 32 pages used for memmap
Jul 14 08:25:51 mithril kernel: DMA zone: 0 pages reserved
Jul 14 08:25:51 mithril kernel: DMA zone: 3966 pages, LIFO batch:0
Jul 14 08:25:51 mithril kernel: Normal zone: 1744 pages used for memmap
Jul 14 08:25:51 mithril kernel: Normal zone: 221486 pages, LIFO batch:31
Jul 14 08:25:51 mithril kernel: HighMem zone: 2290 pages used for memmap
Jul 14 08:25:51 mithril kernel: HighMem zone: 290807 pages, LIFO batch:31
Jul 14 08:25:51 mithril kernel: Using APIC driver default
Jul 14 08:25:51 mithril kernel: ACPI: PM-Timer IO Port: 0x408
Jul 14 08:25:51 mithril kernel: ACPI: Local APIC address 0xfee00000
Jul 14 08:25:51 mithril kernel: ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Jul 14 08:25:51 mithril kernel: ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Jul 14 08:25:51 mithril kernel: ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
Jul 14 08:25:51 mithril kernel: ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
Jul 14 08:25:51 mithril kernel: ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
Jul 14 08:25:51 mithril kernel: IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
Jul 14 08:25:51 mithril kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
Jul 14 08:25:51 mithril kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
Jul 14 08:25:51 mithril kernel: ACPI: IRQ0 used by override.
Jul 14 08:25:51 mithril kernel: ACPI: IRQ2 used by override.
Jul 14 08:25:51 mithril kernel: ACPI: IRQ9 used by override.
Jul 14 08:25:51 mithril kernel: Using ACPI (MADT) for SMP configuration information
Jul 14 08:25:51 mithril kernel: ACPI: HPET id: 0x8086a201 base: 0xfed00000
Jul 14 08:25:51 mithril kernel: SMP: Allowing 2 CPUs, 0 hotplug CPUs
Jul 14 08:25:51 mithril kernel: nr_irqs_gsi: 40
Jul 14 08:25:51 mithril kernel: early_res array is doubled to 64 at [8000 - 87ff]
Jul 14 08:25:51 mithril kernel: PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
Jul 14 08:25:51 mithril kernel: PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
Jul 14 08:25:51 mithril kernel: PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
Jul 14 08:25:51 mithril kernel: Allocating PCI resources starting at 80000000 (gap: 80000000:70000000)
Jul 14 08:25:51 mithril kernel: setup_percpu: NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
Jul 14 08:25:51 mithril kernel: PERCPU: Embedded 13 pages/cpu @c3000000 s31360 r0 d21888 u2097152
Jul 14 08:25:51 mithril kernel: pcpu-alloc: s31360 r0 d21888 u2097152 alloc=1*4194304
Jul 14 08:25:51 mithril kernel: pcpu-alloc: [0] 0 1 
Jul 14 08:25:51 mithril kernel: Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 516259
Jul 14 08:25:51 mithril kernel: Kernel command line: rootfstype=ext4 resume=/dev/sda4
Jul 14 08:25:51 mithril kernel: PID hash table entries: 4096 (order: 2, 16384 bytes)
Jul 14 08:25:51 mithril kernel: Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Jul 14 08:25:51 mithril kernel: Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Jul 14 08:25:51 mithril kernel: Enabling fast FPU save and restore... done.
Jul 14 08:25:51 mithril kernel: Enabling unmasked SIMD FPU exception support... done.
Jul 14 08:25:51 mithril kernel: Initializing CPU#0
Jul 14 08:25:51 mithril kernel: Subtract (48 early reservations)
Jul 14 08:25:51 mithril kernel: #1 [0000001000 - 0000002000]   EX TRAMPOLINE
Jul 14 08:25:51 mithril kernel: #2 [0001000000 - 0001cc2edc]   TEXT DATA BSS
Jul 14 08:25:51 mithril kernel: #3 [000009fc00 - 0000100000]   BIOS reserved
Jul 14 08:25:51 mithril kernel: #4 [0001cc3000 - 0001ccb1f9]             BRK
Jul 14 08:25:51 mithril kernel: #5 [0000002000 - 0000003000]      TRAMPOLINE
Jul 14 08:25:51 mithril kernel: #6 [0000003000 - 0000007000]     ACPI WAKEUP
Jul 14 08:25:51 mithril kernel: #7 [0000007000 - 0000008000]         PGTABLE
Jul 14 08:25:51 mithril kernel: #8 [0001ccc000 - 0001ccd000]         BOOTMEM
Jul 14 08:25:51 mithril kernel: #9 [0001ccd000 - 0002cb5000]         BOOTMEM
Jul 14 08:25:51 mithril kernel: #10 [0001cc2f00 - 0001cc2f04]         BOOTMEM
Jul 14 08:25:51 mithril kernel: #11 [0001ccb200 - 0001ccb440]         BOOTMEM
Jul 14 08:25:51 mithril kernel: #12 [0001cc2f40 - 0001cc2f94]         BOOTMEM
Jul 14 08:25:51 mithril kernel: #13 [0002cb5000 - 0002cbe000]         BOOTMEM
Jul 14 08:25:51 mithril kernel: #14 [0001ccb440 - 0001ccb4ac]         BOOTMEM
Jul 14 08:25:51 mithril kernel: #15 [0002cbe000 - 0002cd0000]         BOOTMEM
Jul 14 08:25:51 mithril kernel: #16 [0001cc2fc0 - 0001cc2fe5]         BOOTMEM
Jul 14 08:25:51 mithril kernel: #17 [0001ccb4c0 - 0001ccb4e7]         BOOTMEM
Jul 14 08:25:51 mithril kernel: #18 [0001ccb500 - 0001ccb6c0]         BOOTMEM
Jul 14 08:25:51 mithril kernel: #19 [0001ccb6c0 - 0001ccb700]         BOOTMEM
Jul 14 08:25:51 mithril kernel: #20 [0001ccb700 - 0001ccb740]         BOOTMEM
Jul 14 08:25:51 mithril kernel: #21 [0001ccb740 - 0001ccb780]         BOOTMEM
Jul 14 08:25:51 mithril kernel: #22 [0001ccb780 - 0001ccb7c0]         BOOTMEM
Jul 14 08:25:51 mithril kernel: #23 [0001ccb7c0 - 0001ccb800]         BOOTMEM
Jul 14 08:25:51 mithril kernel: #24 [0001ccb800 - 0001ccb840]         BOOTMEM
Jul 14 08:25:51 mithril kernel: #25 [0001ccb840 - 0001ccb880]         BOOTMEM
Jul 14 08:25:51 mithril kernel: #26 [0001ccb880 - 0001ccb8c0]         BOOTMEM
Jul 14 08:25:51 mithril kernel: #27 [0001ccb8c0 - 0001ccb900]         BOOTMEM
Jul 14 08:25:51 mithril kernel: #28 [0001ccb900 - 0001ccb940]         BOOTMEM
Jul 14 08:25:51 mithril kernel: #29 [0001ccb940 - 0001ccb980]         BOOTMEM
Jul 14 08:25:51 mithril kernel: #30 [0001ccb980 - 0001ccb9c0]         BOOTMEM
Jul 14 08:25:51 mithril kernel: #31 [0001ccb9c0 - 0001ccba00]         BOOTMEM
Jul 14 08:25:51 mithril kernel: #32 [0001ccba00 - 0001ccba40]         BOOTMEM
Jul 14 08:25:51 mithril kernel: #33 [0001ccba40 - 0001ccba80]         BOOTMEM
Jul 14 08:25:51 mithril kernel: #34 [0001ccba80 - 0001ccba90]         BOOTMEM
Jul 14 08:25:51 mithril kernel: #35 [0001ccbac0 - 0001ccbae1]         BOOTMEM
Jul 14 08:25:51 mithril kernel: #36 [0001ccbb00 - 0001ccbb21]         BOOTMEM
Jul 14 08:25:51 mithril kernel: #37 [0003000000 - 000300d000]         BOOTMEM
Jul 14 08:25:51 mithril kernel: #38 [0003200000 - 000320d000]         BOOTMEM
Jul 14 08:25:51 mithril kernel: #39 [0001ccbb40 - 0001ccbb44]         BOOTMEM
Jul 14 08:25:51 mithril kernel: #40 [0001ccbb80 - 0001ccbb84]         BOOTMEM
Jul 14 08:25:51 mithril kernel: #41 [0001ccbbc0 - 0001ccbbc8]         BOOTMEM
Jul 14 08:25:51 mithril kernel: #42 [0001ccbc00 - 0001ccbc08]         BOOTMEM
Jul 14 08:25:51 mithril kernel: #43 [0001ccbc40 - 0001ccbce8]         BOOTMEM
Jul 14 08:25:51 mithril kernel: #44 [0001ccbd00 - 0001ccbd68]         BOOTMEM
Jul 14 08:25:51 mithril kernel: #45 [0002cd0000 - 0002cd4000]         BOOTMEM
Jul 14 08:25:51 mithril kernel: #46 [0002cd4000 - 0002d54000]         BOOTMEM
Jul 14 08:25:51 mithril kernel: #47 [0002d54000 - 0002d94000]         BOOTMEM
Jul 14 08:25:51 mithril kernel: Initializing HighMem for node 0 (000377fe:0007f0e7)
Jul 14 08:25:51 mithril kernel: Memory: 2050880k/2081692k available (5677k kernel code, 30420k reserved, 2513k data, 416k init, 1172388k highmem)
Jul 14 08:25:51 mithril kernel: virtual kernel memory layout:
Jul 14 08:25:51 mithril kernel: fixmap  : 0xfff65000 - 0xfffff000   ( 616 kB)
Jul 14 08:25:51 mithril kernel: pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
Jul 14 08:25:51 mithril kernel: vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
Jul 14 08:25:51 mithril kernel: lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
Jul 14 08:25:51 mithril kernel: .init : 0xc1800000 - 0xc1868000   ( 416 kB)
Jul 14 08:25:51 mithril kernel: .data : 0xc158b776 - 0xc17ffc78   (2513 kB)
Jul 14 08:25:51 mithril kernel: .text : 0xc1000000 - 0xc158b776   (5677 kB)
Jul 14 08:25:51 mithril kernel: Checking if this processor honours the WP bit even in supervisor mode...Ok.
Jul 14 08:25:51 mithril kernel: SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
Jul 14 08:25:51 mithril kernel: Preemptable hierarchical RCU implementation.
Jul 14 08:25:51 mithril kernel: 	RCU-based detection of stalled CPUs is disabled.
Jul 14 08:25:51 mithril kernel: 	Verbose stalled-CPUs detection is disabled.
Jul 14 08:25:51 mithril kernel: NR_IRQS:320
Jul 14 08:25:51 mithril kernel: Extended CMOS year: 2000
Jul 14 08:25:51 mithril kernel: Console: colour VGA+ 80x25
Jul 14 08:25:51 mithril kernel: console [tty0] enabled
Jul 14 08:25:51 mithril kernel: Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
Jul 14 08:25:51 mithril kernel: ... MAX_LOCKDEP_SUBCLASSES:  8
Jul 14 08:25:51 mithril kernel: ... MAX_LOCK_DEPTH:          48
Jul 14 08:25:51 mithril kernel: ... MAX_LOCKDEP_KEYS:        8191
Jul 14 08:25:51 mithril kernel: ... CLASSHASH_SIZE:          4096
Jul 14 08:25:51 mithril kernel: ... MAX_LOCKDEP_ENTRIES:     16384
Jul 14 08:25:51 mithril kernel: ... MAX_LOCKDEP_CHAINS:      32768
Jul 14 08:25:51 mithril kernel: ... CHAINHASH_SIZE:          16384
Jul 14 08:25:51 mithril kernel: memory used by lock dependency info: 3551 kB
Jul 14 08:25:51 mithril kernel: per task-struct memory footprint: 1152 bytes
Jul 14 08:25:51 mithril kernel: hpet clockevent registered
Jul 14 08:25:51 mithril kernel: Fast TSC calibration using PIT
Jul 14 08:25:51 mithril kernel: Detected 2327.617 MHz processor.
Jul 14 08:25:51 mithril kernel: Calibrating delay loop (skipped), value calculated using timer frequency.. 4655.23 BogoMIPS (lpj=9310468)
Jul 14 08:25:51 mithril kernel: pid_max: default: 32768 minimum: 301
Jul 14 08:25:51 mithril kernel: Mount-cache hash table entries: 512
Jul 14 08:25:51 mithril kernel: CPU: Physical Processor ID: 0
Jul 14 08:25:51 mithril kernel: CPU: Processor Core ID: 0
Jul 14 08:25:51 mithril kernel: mce: CPU supports 6 MCE banks
Jul 14 08:25:51 mithril kernel: CPU0: Thermal monitoring enabled (TM2)
Jul 14 08:25:51 mithril kernel: using mwait in idle threads.
Jul 14 08:25:51 mithril kernel: Performance Events: PEBS fmt0-, Core2 events, Intel PMU driver.
Jul 14 08:25:51 mithril kernel: PEBS disabled due to CPU errata.
Jul 14 08:25:51 mithril kernel: ... version:                2
Jul 14 08:25:51 mithril kernel: ... bit width:              40
Jul 14 08:25:51 mithril kernel: ... generic registers:      2
Jul 14 08:25:51 mithril kernel: ... value mask:             000000ffffffffff
Jul 14 08:25:51 mithril kernel: ... max period:             000000007fffffff
Jul 14 08:25:51 mithril kernel: ... fixed-purpose events:   3
Jul 14 08:25:51 mithril kernel: ... event mask:             0000000700000003
Jul 14 08:25:51 mithril kernel: ACPI: Core revision 20100428
Jul 14 08:25:51 mithril kernel: Enabling APIC mode:  Flat.  Using 1 I/O APICs
Jul 14 08:25:51 mithril kernel: ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
Jul 14 08:25:51 mithril kernel: CPU0: Intel(R) Core(TM)2 CPU         T7600  @ 2.33GHz stepping 06
Jul 14 08:25:51 mithril kernel: lockdep: fixing up alternatives.
Jul 14 08:25:51 mithril kernel: Booting Node   0, Processors  #1 Ok.
Jul 14 08:25:51 mithril kernel: Initializing CPU#1
Jul 14 08:25:51 mithril kernel: Brought up 2 CPUs
Jul 14 08:25:51 mithril kernel: Total of 2 processors activated (9310.27 BogoMIPS).
Jul 14 08:25:51 mithril kernel: NET: Registered protocol family 16
Jul 14 08:25:51 mithril kernel: ACPI: bus type pci registered
Jul 14 08:25:51 mithril kernel: dca service started, version 1.12.1
Jul 14 08:25:51 mithril kernel: PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xf0000000-0xffffffff] (base 0xf0000000)
Jul 14 08:25:51 mithril kernel: PCI: MMCONFIG at [mem 0xf0000000-0xffffffff] reserved in E820
Jul 14 08:25:51 mithril kernel: PCI: MMCONFIG for 0000 [bus00-3f] at [mem 0xf0000000-0xf3ffffff] (base 0xf0000000) (size reduced!)
Jul 14 08:25:51 mithril kernel: PCI: Using MMCONFIG for extended config space
Jul 14 08:25:51 mithril kernel: PCI: Using configuration type 1 for base access
Jul 14 08:25:51 mithril kernel: bio: create slab <bio-0> at 0
Jul 14 08:25:51 mithril kernel: ACPI: EC: EC description table is found, configuring boot EC
Jul 14 08:25:51 mithril kernel: ACPI: BIOS _OSI(Linux) query ignored
Jul 14 08:25:51 mithril kernel: ACPI: SSDT 7feb8a90 002F0 (v01 APPLE   Cpu0Ist 00003000 INTL 20050309)
Jul 14 08:25:51 mithril kernel: ACPI: Dynamic OEM Table Load:
Jul 14 08:25:51 mithril kernel: ACPI: SSDT (null) 002F0 (v01 APPLE   Cpu0Ist 00003000 INTL 20050309)
Jul 14 08:25:51 mithril kernel: ACPI: SSDT 7feb6c10 002A0 (v01 APPLE   Cpu0Cst 00003001 INTL 20050309)
Jul 14 08:25:51 mithril kernel: ACPI: Dynamic OEM Table Load:
Jul 14 08:25:51 mithril kernel: ACPI: SSDT (null) 002A0 (v01 APPLE   Cpu0Cst 00003001 INTL 20050309)
Jul 14 08:25:51 mithril kernel: ACPI: SSDT 7feb7f10 00087 (v01 APPLE   Cpu1Ist 00003000 INTL 20050309)
Jul 14 08:25:51 mithril kernel: ACPI: Dynamic OEM Table Load:
Jul 14 08:25:51 mithril kernel: ACPI: SSDT (null) 00087 (v01 APPLE   Cpu1Ist 00003000 INTL 20050309)
Jul 14 08:25:51 mithril kernel: ACPI: SSDT 7feb6f10 00085 (v01 APPLE   Cpu1Cst 00003000 INTL 20050309)
Jul 14 08:25:51 mithril kernel: ACPI: Dynamic OEM Table Load:
Jul 14 08:25:51 mithril kernel: ACPI: SSDT (null) 00085 (v01 APPLE   Cpu1Cst 00003000 INTL 20050309)
Jul 14 08:25:51 mithril kernel: ACPI: Interpreter enabled
Jul 14 08:25:51 mithril kernel: ACPI: (supports S0 S3 S4 S5)
Jul 14 08:25:51 mithril kernel: ACPI: Using IOAPIC for interrupt routing
Jul 14 08:25:51 mithril kernel: ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
Jul 14 08:25:51 mithril kernel: PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
Jul 14 08:25:51 mithril kernel: ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
Jul 14 08:25:51 mithril kernel: pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7] (ignored)
Jul 14 08:25:51 mithril kernel: pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff] (ignored)
Jul 14 08:25:51 mithril kernel: pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
Jul 14 08:25:51 mithril kernel: pci_root PNP0A08:00: host bridge window [mem 0x80000000-0xfebfffff] (ignored)
Jul 14 08:25:51 mithril kernel: pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
Jul 14 08:25:51 mithril kernel: pci 0000:00:01.0: PME# disabled
Jul 14 08:25:51 mithril kernel: pci 0000:00:07.0: reg 10: [mem 0x98404000-0x98404fff]
Jul 14 08:25:51 mithril kernel: pci 0000:00:1b.0: reg 10: [mem 0x98400000-0x98403fff 64bit]
Jul 14 08:25:51 mithril kernel: pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
Jul 14 08:25:51 mithril kernel: pci 0000:00:1b.0: PME# disabled
Jul 14 08:25:51 mithril kernel: pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
Jul 14 08:25:51 mithril kernel: pci 0000:00:1c.0: PME# disabled
Jul 14 08:25:51 mithril kernel: pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
Jul 14 08:25:51 mithril kernel: pci 0000:00:1c.1: PME# disabled
Jul 14 08:25:51 mithril kernel: pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
Jul 14 08:25:51 mithril kernel: pci 0000:00:1c.2: PME# disabled
Jul 14 08:25:51 mithril kernel: pci 0000:00:1d.0: reg 20: [io  0x4080-0x409f]
Jul 14 08:25:51 mithril kernel: pci 0000:00:1d.1: reg 20: [io  0x4060-0x407f]
Jul 14 08:25:51 mithril kernel: pci 0000:00:1d.2: reg 20: [io  0x4040-0x405f]
Jul 14 08:25:51 mithril kernel: pci 0000:00:1d.3: reg 20: [io  0x4020-0x403f]
Jul 14 08:25:51 mithril kernel: pci 0000:00:1d.7: reg 10: [mem 0x98405400-0x984057ff]
Jul 14 08:25:51 mithril kernel: pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
Jul 14 08:25:51 mithril kernel: pci 0000:00:1d.7: PME# disabled
Jul 14 08:25:51 mithril kernel: pci 0000:00:1f.0: quirk: [io  0x0400-0x047f] claimed by ICH6 ACPI/GPIO/TCO
Jul 14 08:25:51 mithril kernel: pci 0000:00:1f.0: quirk: [io  0x0500-0x053f] claimed by ICH6 GPIO
Jul 14 08:25:51 mithril kernel: pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0680 (mask 000f)
Jul 14 08:25:51 mithril kernel: pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 1640 (mask 000f)
Jul 14 08:25:51 mithril kernel: pci 0000:00:1f.0: ICH7 LPC Generic IO decode 4 PIO at 0300 (mask 001f)
Jul 14 08:25:51 mithril kernel: pci 0000:00:1f.1: reg 10: [io  0x40d8-0x40df]
Jul 14 08:25:51 mithril kernel: pci 0000:00:1f.1: reg 14: [io  0x40ec-0x40ef]
Jul 14 08:25:51 mithril kernel: pci 0000:00:1f.1: reg 18: [io  0x40d0-0x40d7]
Jul 14 08:25:51 mithril kernel: pci 0000:00:1f.1: reg 1c: [io  0x40e8-0x40eb]
Jul 14 08:25:51 mithril kernel: pci 0000:00:1f.1: reg 20: [io  0x40b0-0x40bf]
Jul 14 08:25:51 mithril kernel: pci 0000:00:1f.2: reg 10: [io  0x40c8-0x40cf]
Jul 14 08:25:51 mithril kernel: pci 0000:00:1f.2: reg 14: [io  0x40e4-0x40e7]
Jul 14 08:25:51 mithril kernel: pci 0000:00:1f.2: reg 18: [io  0x40c0-0x40c7]
Jul 14 08:25:51 mithril kernel: pci 0000:00:1f.2: reg 1c: [io  0x40e0-0x40e3]
Jul 14 08:25:51 mithril kernel: pci 0000:00:1f.2: reg 20: [io  0x40a0-0x40af]
Jul 14 08:25:51 mithril kernel: pci 0000:00:1f.2: reg 24: [mem 0x98405000-0x984053ff]
Jul 14 08:25:51 mithril kernel: pci 0000:00:1f.2: PME# supported from D3hot
Jul 14 08:25:51 mithril kernel: pci 0000:00:1f.2: PME# disabled
Jul 14 08:25:51 mithril kernel: pci 0000:00:1f.3: reg 20: [io  0xefa0-0xefbf]
Jul 14 08:25:51 mithril kernel: pci 0000:01:00.0: reg 10: [mem 0x80000000-0x8fffffff pref]
Jul 14 08:25:51 mithril kernel: pci 0000:01:00.0: reg 14: [io  0x3000-0x30ff]
Jul 14 08:25:51 mithril kernel: pci 0000:01:00.0: reg 18: [mem 0x98300000-0x9830ffff]
Jul 14 08:25:51 mithril kernel: pci 0000:01:00.0: reg 30: [mem 0xfffe0000-0xffffffff pref]
Jul 14 08:25:51 mithril kernel: pci 0000:01:00.0: supports D1 D2
Jul 14 08:25:51 mithril kernel: pci 0000:00:01.0: PCI bridge to [bus 01-01]
Jul 14 08:25:51 mithril kernel: pci 0000:00:01.0:   bridge window [io  0x3000-0x3fff]
Jul 14 08:25:51 mithril kernel: pci 0000:00:01.0:   bridge window [mem 0x98300000-0x983fffff]
Jul 14 08:25:51 mithril kernel: pci 0000:00:01.0:   bridge window [mem 0x80000000-0x8fffffff 64bit pref]
Jul 14 08:25:51 mithril kernel: pci 0000:02:00.0: reg 10: [mem 0x98200000-0x98203fff 64bit]
Jul 14 08:25:51 mithril kernel: pci 0000:02:00.0: reg 18: [io  0x2000-0x20ff]
Jul 14 08:25:51 mithril kernel: pci 0000:02:00.0: reg 30: [mem 0xfffe0000-0xffffffff pref]
Jul 14 08:25:51 mithril kernel: pci 0000:02:00.0: supports D1 D2
Jul 14 08:25:51 mithril kernel: pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
Jul 14 08:25:51 mithril kernel: pci 0000:02:00.0: PME# disabled
Jul 14 08:25:51 mithril kernel: pci 0000:00:1c.0: PCI bridge to [bus 02-02]
Jul 14 08:25:51 mithril kernel: pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
Jul 14 08:25:51 mithril kernel: pci 0000:00:1c.0:   bridge window [mem 0x98200000-0x982fffff]
Jul 14 08:25:51 mithril kernel: pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
Jul 14 08:25:51 mithril kernel: pci 0000:03:00.0: reg 10: [mem 0x98100000-0x9810ffff 64bit]
Jul 14 08:25:51 mithril kernel: pci 0000:03:00.0: supports D1
Jul 14 08:25:51 mithril kernel: pci 0000:03:00.0: PME# supported from D0 D1 D3hot
Jul 14 08:25:51 mithril kernel: pci 0000:03:00.0: PME# disabled
Jul 14 08:25:51 mithril kernel: pci 0000:00:1c.1: PCI bridge to [bus 03-03]
Jul 14 08:25:51 mithril kernel: pci 0000:00:1c.1:   bridge window [io  0xf000-0x0000] (disabled)
Jul 14 08:25:51 mithril kernel: pci 0000:00:1c.1:   bridge window [mem 0x98100000-0x981fffff]
Jul 14 08:25:51 mithril kernel: pci 0000:00:1c.1:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
Jul 14 08:25:51 mithril kernel: pci 0000:00:1c.2: PCI bridge to [bus 04-0b]
Jul 14 08:25:51 mithril kernel: pci 0000:00:1c.2:   bridge window [io  0x1000-0x1fff]
Jul 14 08:25:51 mithril kernel: pci 0000:00:1c.2:   bridge window [mem 0x94100000-0x980fffff]
Jul 14 08:25:51 mithril kernel: pci 0000:00:1c.2:   bridge window [mem 0x90000000-0x93ffffff 64bit pref]
Jul 14 08:25:51 mithril kernel: pci 0000:0c:03.0: reg 10: [mem 0x94004000-0x940047ff]
Jul 14 08:25:51 mithril kernel: pci 0000:0c:03.0: reg 14: [mem 0x94000000-0x94003fff]
Jul 14 08:25:51 mithril kernel: pci 0000:0c:03.0: supports D1 D2
Jul 14 08:25:51 mithril kernel: pci 0000:0c:03.0: PME# supported from D0 D1 D2 D3hot
Jul 14 08:25:51 mithril kernel: pci 0000:0c:03.0: PME# disabled
Jul 14 08:25:51 mithril kernel: pci 0000:00:1e.0: PCI bridge to [bus 0c-0c] (subtractive decode)
Jul 14 08:25:51 mithril kernel: pci 0000:00:1e.0:   bridge window [io  0xf000-0x0000] (disabled)
Jul 14 08:25:51 mithril kernel: pci 0000:00:1e.0:   bridge window [mem 0x94000000-0x940fffff]
Jul 14 08:25:51 mithril kernel: pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
Jul 14 08:25:51 mithril kernel: pci 0000:00:1e.0:   bridge window [io  0x0000-0xffff] (subtractive decode)
Jul 14 08:25:51 mithril kernel: pci 0000:00:1e.0:   bridge window [mem 0x00000000-0xffffffff] (subtractive decode)
Jul 14 08:25:51 mithril kernel: pci_bus 0000:00: on NUMA node 0
Jul 14 08:25:51 mithril kernel: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
Jul 14 08:25:51 mithril kernel: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEGP._PRT]
Jul 14 08:25:51 mithril kernel: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
Jul 14 08:25:51 mithril kernel: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
Jul 14 08:25:51 mithril kernel: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
Jul 14 08:25:51 mithril kernel: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
Jul 14 08:25:51 mithril kernel: ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
Jul 14 08:25:51 mithril kernel: ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 *11 12 14 15)
Jul 14 08:25:51 mithril kernel: ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
Jul 14 08:25:51 mithril kernel: ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 *11 12 14 15)
Jul 14 08:25:51 mithril kernel: ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
Jul 14 08:25:51 mithril kernel: ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
Jul 14 08:25:51 mithril kernel: ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 *10 12 14 15)
Jul 14 08:25:51 mithril kernel: ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *11 12 14 15)
Jul 14 08:25:51 mithril kernel: vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
Jul 14 08:25:51 mithril kernel: vgaarb: loaded
Jul 14 08:25:51 mithril kernel: SCSI subsystem initialized
Jul 14 08:25:51 mithril kernel: libata version 3.00 loaded.
Jul 14 08:25:51 mithril kernel: usbcore: registered new interface driver usbfs
Jul 14 08:25:51 mithril kernel: usbcore: registered new interface driver hub
Jul 14 08:25:51 mithril kernel: usbcore: registered new device driver usb
Jul 14 08:25:51 mithril kernel: Advanced Linux Sound Architecture Driver Version 1.0.23.
Jul 14 08:25:51 mithril kernel: PCI: Using ACPI for IRQ routing
Jul 14 08:25:51 mithril kernel: PCI: pci_cache_line_size set to 64 bytes
Jul 14 08:25:51 mithril kernel: reserve RAM buffer: 000000000009fc00 - 000000000009ffff 
Jul 14 08:25:51 mithril kernel: reserve RAM buffer: 000000007f0e7000 - 000000007fffffff 
Jul 14 08:25:51 mithril kernel: Bluetooth: Core ver 2.15
Jul 14 08:25:51 mithril kernel: NET: Registered protocol family 31
Jul 14 08:25:51 mithril kernel: Bluetooth: HCI device and connection manager initialized
Jul 14 08:25:51 mithril kernel: Bluetooth: HCI socket layer initialized
Jul 14 08:25:51 mithril kernel: cfg80211: Calling CRDA to update world regulatory domain
Jul 14 08:25:51 mithril kernel: HPET: 3 timers in total, 0 timers will be used for per-cpu timer
Jul 14 08:25:51 mithril kernel: hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
Jul 14 08:25:51 mithril kernel: hpet0: 3 comparators, 64-bit 14.318180 MHz counter
Jul 14 08:25:51 mithril kernel: Switching to clocksource tsc
Jul 14 08:25:51 mithril kernel: pnp: PnP ACPI init
Jul 14 08:25:51 mithril kernel: ACPI: bus type pnp registered
Jul 14 08:25:51 mithril kernel: pnp 00:07: disabling [io  0x1640-0x164f] because it overlaps 0000:00:1c.2 BAR 7 [io  0x1000-0x1fff]
Jul 14 08:25:51 mithril kernel: pnp: PnP ACPI: found 9 devices
Jul 14 08:25:51 mithril kernel: ACPI: ACPI bus type pnp unregistered
Jul 14 08:25:51 mithril kernel: system 00:01: [mem 0xf0000000-0xf3ffffff] has been reserved
Jul 14 08:25:51 mithril kernel: system 00:01: [mem 0xfed14000-0xfed17fff] has been reserved
Jul 14 08:25:51 mithril kernel: system 00:01: [mem 0xfed18000-0xfed18fff] has been reserved
Jul 14 08:25:51 mithril kernel: system 00:01: [mem 0xfed19000-0xfed19fff] has been reserved
Jul 14 08:25:51 mithril kernel: system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
Jul 14 08:25:51 mithril kernel: system 00:01: [mem 0xfed20000-0xfed8ffff] has been reserved
Jul 14 08:25:51 mithril kernel: system 00:05: [mem 0xfed00000-0xfed003ff] has been reserved
Jul 14 08:25:51 mithril kernel: system 00:07: [io  0x0680-0x06ef] has been reserved
Jul 14 08:25:51 mithril kernel: system 00:07: [io  0x0800-0x080f] has been reserved
Jul 14 08:25:51 mithril kernel: system 00:07: [io  0x0810-0x0817] has been reserved
Jul 14 08:25:51 mithril kernel: system 00:07: [io  0x0400-0x047f] has been reserved
Jul 14 08:25:51 mithril kernel: system 00:07: [io  0x0500-0x053f] has been reserved
Jul 14 08:25:51 mithril kernel: pci 0000:01:00.0: no compatible bridge window for [mem 0xfffe0000-0xffffffff pref]
Jul 14 08:25:51 mithril kernel: pci 0000:02:00.0: no compatible bridge window for [mem 0xfffe0000-0xffffffff pref]
Jul 14 08:25:51 mithril kernel: pci 0000:00:1c.0: BAR 9: assigned [mem 0x98500000-0x986fffff pref]
Jul 14 08:25:51 mithril kernel: pci 0000:00:1c.1: BAR 9: assigned [mem 0x98700000-0x988fffff 64bit pref]
Jul 14 08:25:51 mithril kernel: pci 0000:00:1c.1: BAR 7: assigned [io  0x5000-0x5fff]
Jul 14 08:25:51 mithril kernel: pci 0000:01:00.0: BAR 6: assigned [mem 0x98320000-0x9833ffff pref]
Jul 14 08:25:51 mithril kernel: pci 0000:00:01.0: PCI bridge to [bus 01-01]
Jul 14 08:25:51 mithril kernel: pci 0000:00:01.0:   bridge window [io  0x3000-0x3fff]
Jul 14 08:25:51 mithril kernel: pci 0000:00:01.0:   bridge window [mem 0x98300000-0x983fffff]
Jul 14 08:25:51 mithril kernel: pci 0000:00:01.0:   bridge window [mem 0x80000000-0x8fffffff 64bit pref]
Jul 14 08:25:51 mithril kernel: pci 0000:02:00.0: BAR 6: assigned [mem 0x98500000-0x9851ffff pref]
Jul 14 08:25:51 mithril kernel: pci 0000:00:1c.0: PCI bridge to [bus 02-02]
Jul 14 08:25:51 mithril kernel: pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
Jul 14 08:25:51 mithril kernel: pci 0000:00:1c.0:   bridge window [mem 0x98200000-0x982fffff]
Jul 14 08:25:51 mithril kernel: pci 0000:00:1c.0:   bridge window [mem 0x98500000-0x986fffff pref]
Jul 14 08:25:51 mithril kernel: pci 0000:00:1c.1: PCI bridge to [bus 03-03]
Jul 14 08:25:51 mithril kernel: pci 0000:00:1c.1:   bridge window [io  0x5000-0x5fff]
Jul 14 08:25:51 mithril kernel: pci 0000:00:1c.1:   bridge window [mem 0x98100000-0x981fffff]
Jul 14 08:25:51 mithril kernel: pci 0000:00:1c.1:   bridge window [mem 0x98700000-0x988fffff 64bit pref]
Jul 14 08:25:51 mithril kernel: pci 0000:00:1c.2: PCI bridge to [bus 04-0b]
Jul 14 08:25:51 mithril kernel: pci 0000:00:1c.2:   bridge window [io  0x1000-0x1fff]
Jul 14 08:25:51 mithril kernel: pci 0000:00:1c.2:   bridge window [mem 0x94100000-0x980fffff]
Jul 14 08:25:51 mithril kernel: pci 0000:00:1c.2:   bridge window [mem 0x90000000-0x93ffffff 64bit pref]
Jul 14 08:25:51 mithril kernel: pci 0000:00:1e.0: PCI bridge to [bus 0c-0c]
Jul 14 08:25:51 mithril kernel: pci 0000:00:1e.0:   bridge window [io  disabled]
Jul 14 08:25:51 mithril kernel: pci 0000:00:1e.0:   bridge window [mem 0x94000000-0x940fffff]
Jul 14 08:25:51 mithril kernel: pci 0000:00:1e.0:   bridge window [mem pref disabled]
Jul 14 08:25:51 mithril kernel: pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Jul 14 08:25:51 mithril kernel: pci 0000:00:01.0: setting latency timer to 64
Jul 14 08:25:51 mithril kernel: pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
Jul 14 08:25:51 mithril kernel: pci 0000:00:1c.0: setting latency timer to 64
Jul 14 08:25:51 mithril kernel: pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
Jul 14 08:25:51 mithril kernel: pci 0000:00:1c.1: setting latency timer to 64
Jul 14 08:25:51 mithril kernel: pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
Jul 14 08:25:51 mithril kernel: pci 0000:00:1c.2: setting latency timer to 64
Jul 14 08:25:51 mithril kernel: pci 0000:00:1e.0: power state changed by ACPI to D0
Jul 14 08:25:51 mithril kernel: pci 0000:00:1e.0: power state changed by ACPI to D0
Jul 14 08:25:51 mithril kernel: pci 0000:00:1e.0: setting latency timer to 64
Jul 14 08:25:51 mithril kernel: pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
Jul 14 08:25:51 mithril kernel: pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffff]
Jul 14 08:25:51 mithril kernel: pci_bus 0000:01: resource 0 [io  0x3000-0x3fff]
Jul 14 08:25:51 mithril kernel: pci_bus 0000:01: resource 1 [mem 0x98300000-0x983fffff]
Jul 14 08:25:51 mithril kernel: pci_bus 0000:01: resource 2 [mem 0x80000000-0x8fffffff 64bit pref]
Jul 14 08:25:51 mithril kernel: pci_bus 0000:02: resource 0 [io  0x2000-0x2fff]
Jul 14 08:25:51 mithril kernel: pci_bus 0000:02: resource 1 [mem 0x98200000-0x982fffff]
Jul 14 08:25:51 mithril kernel: pci_bus 0000:02: resource 2 [mem 0x98500000-0x986fffff pref]
Jul 14 08:25:51 mithril kernel: pci_bus 0000:03: resource 0 [io  0x5000-0x5fff]
Jul 14 08:25:51 mithril kernel: pci_bus 0000:03: resource 1 [mem 0x98100000-0x981fffff]
Jul 14 08:25:51 mithril kernel: pci_bus 0000:03: resource 2 [mem 0x98700000-0x988fffff 64bit pref]
Jul 14 08:25:51 mithril kernel: pci_bus 0000:04: resource 0 [io  0x1000-0x1fff]
Jul 14 08:25:51 mithril kernel: pci_bus 0000:04: resource 1 [mem 0x94100000-0x980fffff]
Jul 14 08:25:51 mithril kernel: pci_bus 0000:04: resource 2 [mem 0x90000000-0x93ffffff 64bit pref]
Jul 14 08:25:51 mithril kernel: pci_bus 0000:0c: resource 1 [mem 0x94000000-0x940fffff]
Jul 14 08:25:51 mithril kernel: pci_bus 0000:0c: resource 4 [io  0x0000-0xffff]
Jul 14 08:25:51 mithril kernel: pci_bus 0000:0c: resource 5 [mem 0x00000000-0xffffffff]
Jul 14 08:25:51 mithril kernel: NET: Registered protocol family 2
Jul 14 08:25:51 mithril kernel: IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
Jul 14 08:25:51 mithril kernel: TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
Jul 14 08:25:51 mithril kernel: TCP bind hash table entries: 65536 (order: 9, 2097152 bytes)
Jul 14 08:25:51 mithril kernel: TCP: Hash tables configured (established 131072 bind 65536)
Jul 14 08:25:51 mithril kernel: TCP reno registered
Jul 14 08:25:51 mithril kernel: UDP hash table entries: 512 (order: 3, 40960 bytes)
Jul 14 08:25:51 mithril kernel: UDP-Lite hash table entries: 512 (order: 3, 40960 bytes)
Jul 14 08:25:51 mithril kernel: NET: Registered protocol family 1
Jul 14 08:25:51 mithril kernel: pci 0000:01:00.0: Boot video device
Jul 14 08:25:51 mithril kernel: PCI: CLS mismatch (256 != 64), using 64 bytes
Jul 14 08:25:51 mithril kernel: DMA-API: preallocated 32768 debug entries
Jul 14 08:25:51 mithril kernel: DMA-API: debugging enabled by kernel config
Jul 14 08:25:51 mithril kernel: microcode: CPU0 sig=0x6f6, pf=0x20, revision=0xc7
Jul 14 08:25:51 mithril kernel: microcode: CPU1 sig=0x6f6, pf=0x20, revision=0xc7
Jul 14 08:25:51 mithril kernel: microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
Jul 14 08:25:51 mithril kernel: highmem bounce pool size: 64 pages
Jul 14 08:25:51 mithril kernel: HugeTLB registered 4 MB page size, pre-allocated 0 pages
Jul 14 08:25:51 mithril kernel: squashfs: version 4.0 (2009/01/31) Phillip Lougher
Jul 14 08:25:51 mithril kernel: msgmni has been set to 1715
Jul 14 08:25:51 mithril kernel: alg: No test for stdrng (krng)
Jul 14 08:25:51 mithril kernel: io scheduler noop registered
Jul 14 08:25:51 mithril kernel: io scheduler deadline registered
Jul 14 08:25:51 mithril kernel: io scheduler cfq registered (default)
Jul 14 08:25:51 mithril kernel: pcieport 0000:00:01.0: setting latency timer to 64
Jul 14 08:25:51 mithril kernel: pcieport 0000:00:01.0: irq 40 for MSI/MSI-X
Jul 14 08:25:51 mithril kernel: pcieport 0000:00:1c.0: setting latency timer to 64
Jul 14 08:25:51 mithril kernel: pcieport 0000:00:1c.0: irq 41 for MSI/MSI-X
Jul 14 08:25:51 mithril kernel: pcieport 0000:00:1c.1: setting latency timer to 64
Jul 14 08:25:51 mithril kernel: pcieport 0000:00:1c.1: irq 42 for MSI/MSI-X
Jul 14 08:25:51 mithril kernel: pcieport 0000:00:1c.2: setting latency timer to 64
Jul 14 08:25:51 mithril kernel: pcieport 0000:00:1c.2: irq 43 for MSI/MSI-X
Jul 14 08:25:51 mithril kernel: intel_idle: MWAIT substates: 0x22220
Jul 14 08:25:51 mithril kernel: intel_idle: does not run on family 6 model 15
Jul 14 08:25:51 mithril kernel: ACPI: AC Adapter [ADP1] (on-line)
Jul 14 08:25:51 mithril kernel: input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input0
Jul 14 08:25:51 mithril kernel: ACPI: Lid Switch [LID0]
Jul 14 08:25:51 mithril kernel: input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input1
Jul 14 08:25:51 mithril kernel: ACPI: Power Button [PWRB]
Jul 14 08:25:51 mithril kernel: input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input2
Jul 14 08:25:51 mithril kernel: ACPI: Sleep Button [SLPB]
Jul 14 08:25:51 mithril kernel: input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
Jul 14 08:25:51 mithril kernel: ACPI: Power Button [PWRF]
Jul 14 08:25:51 mithril kernel: ACPI: acpi_idle registered with cpuidle
Jul 14 08:25:51 mithril kernel: Monitor-Mwait will be used to enter C-1 state
Jul 14 08:25:51 mithril kernel: Monitor-Mwait will be used to enter C-2 state
Jul 14 08:25:51 mithril kernel: Monitor-Mwait will be used to enter C-3 state
Jul 14 08:25:51 mithril kernel: Marking TSC unstable due to TSC halts in idle
Jul 14 08:25:51 mithril kernel: Switching to clocksource hpet
Jul 14 08:25:51 mithril kernel: ACPI: Battery Slot [BAT0] (battery present)
Jul 14 08:25:51 mithril kernel: Non-volatile memory driver v1.3
Jul 14 08:25:51 mithril kernel: intel_rng: FWH not detected
Jul 14 08:25:51 mithril kernel: [drm] Initialized drm 1.1.0 20060810
Jul 14 08:25:51 mithril kernel: [drm] radeon defaulting to kernel modesetting.
Jul 14 08:25:51 mithril kernel: [drm] radeon kernel modesetting enabled.
Jul 14 08:25:51 mithril kernel: radeon 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Jul 14 08:25:51 mithril kernel: radeon 0000:01:00.0: setting latency timer to 64
Jul 14 08:25:51 mithril kernel: [drm] initializing kernel modesetting (RV530 0x1002:0x71C5).
Jul 14 08:25:51 mithril kernel: [drm] register mmio base: 0x98300000
Jul 14 08:25:51 mithril kernel: [drm] register mmio size: 65536
Jul 14 08:25:51 mithril kernel: ATOM BIOS: M56P
Jul 14 08:25:51 mithril kernel: [drm] Generation 2 PCI interface, using max accessible memory
Jul 14 08:25:51 mithril kernel: radeon 0000:01:00.0: VRAM: 256M 0x00000000 - 0x0FFFFFFF (256M used)
Jul 14 08:25:51 mithril kernel: radeon 0000:01:00.0: GTT: 512M 0x10000000 - 0x2FFFFFFF
Jul 14 08:25:51 mithril kernel: radeon 0000:01:00.0: irq 44 for MSI/MSI-X
Jul 14 08:25:51 mithril kernel: [drm] radeon: using MSI.
Jul 14 08:25:51 mithril kernel: [drm] radeon: irq initialized.
Jul 14 08:25:51 mithril kernel: [drm] Detected VRAM RAM=256M, BAR=256M
Jul 14 08:25:51 mithril kernel: [drm] RAM width 128bits DDR
Jul 14 08:25:51 mithril kernel: [TTM] Zone  kernel: Available graphics memory: 439246 kiB.
Jul 14 08:25:51 mithril kernel: [TTM] Zone highmem: Available graphics memory: 1025440 kiB.
Jul 14 08:25:51 mithril kernel: [TTM] Initializing pool allocator.
Jul 14 08:25:51 mithril kernel: [drm] radeon: 256M of VRAM memory ready
Jul 14 08:25:51 mithril kernel: [drm] radeon: 512M of GTT memory ready.
Jul 14 08:25:51 mithril kernel: [drm] GART: num cpu pages 131072, num gpu pages 131072
Jul 14 08:25:51 mithril kernel: [drm] radeon: 1 quad pipes, 2 z pipes initialized.
Jul 14 08:25:51 mithril kernel: [drm] PCIE GART of 512M enabled (table at 0x00040000).
Jul 14 08:25:51 mithril kernel: [drm] Loading R500 Microcode
Jul 14 08:25:51 mithril kernel: [drm] radeon: ring at 0x0000000010000000
Jul 14 08:25:51 mithril kernel: [drm] ring test succeeded in 7 usecs
Jul 14 08:25:51 mithril kernel: [drm] radeon: ib pool ready.
Jul 14 08:25:51 mithril kernel: [drm] ib test succeeded in 0 usecs
Jul 14 08:25:51 mithril kernel: [drm] Default TV standard: NTSC
Jul 14 08:25:51 mithril kernel: [drm] Default TV standard: NTSC
Jul 14 08:25:51 mithril kernel: [drm] Radeon Display Connectors
Jul 14 08:25:51 mithril kernel: [drm] Connector 0:
Jul 14 08:25:51 mithril kernel: [drm]   LVDS
Jul 14 08:25:51 mithril kernel: [drm]   DDC: 0x7e60 0x7e60 0x7e64 0x7e64 0x7e68 0x7e68 0x7e6c 0x7e6c
Jul 14 08:25:51 mithril kernel: [drm]   Encoders:
Jul 14 08:25:51 mithril kernel: [drm]     LCD1: INTERNAL_LVTM1
Jul 14 08:25:51 mithril kernel: [drm] Connector 1:
Jul 14 08:25:51 mithril kernel: [drm]   S-video
Jul 14 08:25:51 mithril kernel: [drm]   Encoders:
Jul 14 08:25:51 mithril kernel: [drm]     TV1: INTERNAL_KLDSCP_DAC2
Jul 14 08:25:51 mithril kernel: [drm] Connector 2:
Jul 14 08:25:51 mithril kernel: [drm]   DVI-I
Jul 14 08:25:51 mithril kernel: [drm]   HPD1
Jul 14 08:25:51 mithril kernel: [drm]   DDC: 0x7e40 0x7e40 0x7e44 0x7e44 0x7e48 0x7e48 0x7e4c 0x7e4c
Jul 14 08:25:51 mithril kernel: [drm]   Encoders:
Jul 14 08:25:51 mithril kernel: [drm]     CRT2: INTERNAL_KLDSCP_DAC2
Jul 14 08:25:51 mithril kernel: [drm]     DFP1: INTERNAL_KLDSCP_TMDS1
Jul 14 08:25:51 mithril kernel: [drm] fb mappable at 0x800C0000
Jul 14 08:25:51 mithril kernel: [drm] vram apper at 0x80000000
Jul 14 08:25:51 mithril kernel: [drm] size 7258112
Jul 14 08:25:51 mithril kernel: [drm] fb depth is 24
Jul 14 08:25:51 mithril kernel: [drm]    pitch is 6912
Jul 14 08:25:51 mithril kernel: Console: switching to colour frame buffer device 210x65
Jul 14 08:25:51 mithril kernel: fb0: radeondrmfb frame buffer device
Jul 14 08:25:51 mithril kernel: drm: registered panic notifier
Jul 14 08:25:51 mithril kernel: Slow work thread pool: Starting up
Jul 14 08:25:51 mithril kernel: Slow work thread pool: Ready
Jul 14 08:25:51 mithril kernel: [drm] Initialized radeon 2.5.0 20080528 for 0000:01:00.0 on minor 0
Jul 14 08:25:51 mithril kernel: loop: module loaded
Jul 14 08:25:51 mithril kernel: ata_piix 0000:00:1f.1: version 2.13
Jul 14 08:25:51 mithril kernel: ata_piix 0000:00:1f.1: power state changed by ACPI to D0
Jul 14 08:25:51 mithril kernel: ata_piix 0000:00:1f.1: power state changed by ACPI to D0
Jul 14 08:25:51 mithril kernel: ata_piix 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
Jul 14 08:25:51 mithril kernel: ata_piix 0000:00:1f.1: setting latency timer to 64
Jul 14 08:25:51 mithril kernel: scsi0 : ata_piix
Jul 14 08:25:51 mithril kernel: scsi1 : ata_piix
Jul 14 08:25:51 mithril kernel: ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x40b0 irq 14
Jul 14 08:25:51 mithril kernel: ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x40b8 irq 15
Jul 14 08:25:51 mithril kernel: ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
Jul 14 08:25:51 mithril kernel: ata_piix 0000:00:1f.2: MAP [ P0 P2 -- -- ]
Jul 14 08:25:51 mithril kernel: ata_piix 0000:00:1f.2: setting latency timer to 64
Jul 14 08:25:51 mithril kernel: scsi2 : ata_piix
Jul 14 08:25:51 mithril kernel: scsi3 : ata_piix
Jul 14 08:25:51 mithril kernel: ata3: SATA max UDMA/133 cmd 0x40c8 ctl 0x40e4 bmdma 0x40a0 irq 19
Jul 14 08:25:51 mithril kernel: ata4: SATA max UDMA/133 cmd 0x40c0 ctl 0x40e0 bmdma 0x40a8 irq 19
Jul 14 08:25:51 mithril kernel: sky2: driver version 1.28
Jul 14 08:25:51 mithril kernel: sky2 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Jul 14 08:25:51 mithril kernel: sky2 0000:02:00.0: setting latency timer to 64
Jul 14 08:25:51 mithril kernel: sky2 0000:02:00.0: Yukon-2 EC chip revision 2
Jul 14 08:25:51 mithril kernel: sky2 0000:02:00.0: irq 45 for MSI/MSI-X
Jul 14 08:25:51 mithril kernel: sky2 0000:02:00.0: eth0: addr 00:17:f2:c7:5f:06
Jul 14 08:25:51 mithril kernel: tun: Universal TUN/TAP device driver, 1.6
Jul 14 08:25:51 mithril kernel: tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
Jul 14 08:25:51 mithril kernel: usbcore: registered new interface driver cdc_ether
Jul 14 08:25:51 mithril kernel: usbcore: registered new interface driver rndis_host
Jul 14 08:25:51 mithril kernel: ath9k 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
Jul 14 08:25:51 mithril kernel: ath9k 0000:03:00.0: setting latency timer to 64
Jul 14 08:25:51 mithril kernel: ata1.00: ATAPI: MATSHITADVD-R   UJ-85J, FAV1, max UDMA/66
Jul 14 08:25:51 mithril kernel: ata1.00: configured for UDMA/66
Jul 14 08:25:51 mithril kernel: scsi 0:0:0:0: CD-ROM            MATSHITA DVD-R   UJ-85J   FAV1 PQ: 0 ANSI: 5
Jul 14 08:25:51 mithril kernel: sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
Jul 14 08:25:51 mithril kernel: Uniform CD-ROM driver Revision: 3.20
Jul 14 08:25:51 mithril kernel: sr 0:0:0:0: Attached scsi CD-ROM sr0
Jul 14 08:25:51 mithril kernel: sr 0:0:0:0: Attached scsi generic sg0 type 5
Jul 14 08:25:51 mithril kernel: ath: EEPROM regdomain: 0x37
Jul 14 08:25:51 mithril kernel: ath: EEPROM indicates we should expect a direct regpair map
Jul 14 08:25:51 mithril kernel: ath: Country alpha2 being used: AW
Jul 14 08:25:51 mithril kernel: ath: Regpair used: 0x37
Jul 14 08:25:51 mithril kernel: phy0: Selected rate control algorithm 'ath9k_rate_control'
Jul 14 08:25:51 mithril kernel: cfg80211: Calling CRDA for country: AW
Jul 14 08:25:51 mithril kernel: Registered led device: ath9k-phy0::radio
Jul 14 08:25:51 mithril kernel: Registered led device: ath9k-phy0::assoc
Jul 14 08:25:51 mithril kernel: Registered led device: ath9k-phy0::tx
Jul 14 08:25:51 mithril kernel: Registered led device: ath9k-phy0::rx
Jul 14 08:25:51 mithril kernel: phy0: Atheros AR5418 MAC/BB Rev:2 AR5133 RF Rev:81 mem=0xf82a0000, irq=17
Jul 14 08:25:51 mithril kernel: firewire_ohci 0000:0c:03.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
Jul 14 08:25:51 mithril kernel: ata3.01: ATA-7: Hitachi HTS721010G9SA00, MCZAC13W, max UDMA/133
Jul 14 08:25:51 mithril kernel: ata3.01: 195371568 sectors, multi 16: LBA48 NCQ (depth 0/32)
Jul 14 08:25:51 mithril kernel: ata3.01: configured for UDMA/133
Jul 14 08:25:51 mithril kernel: scsi 2:0:1:0: Direct-Access     ATA      Hitachi HTS72101 MCZA PQ: 0 ANSI: 5
Jul 14 08:25:51 mithril kernel: sd 2:0:1:0: [sda] 195371568 512-byte logical blocks: (100 GB/93.1 GiB)
Jul 14 08:25:51 mithril kernel: sd 2:0:1:0: Attached scsi generic sg1 type 0
Jul 14 08:25:51 mithril kernel: sd 2:0:1:0: [sda] Write Protect is off
Jul 14 08:25:51 mithril kernel: sd 2:0:1:0: [sda] Mode Sense: 00 3a 00 00
Jul 14 08:25:51 mithril kernel: sd 2:0:1:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Jul 14 08:25:51 mithril kernel: sda:
Jul 14 08:25:51 mithril kernel: firewire_ohci: Added fw-ohci device 0000:0c:03.0, OHCI v1.10, 4 IR + 8 IT contexts, quirks 0x2
Jul 14 08:25:51 mithril kernel: ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
Jul 14 08:25:51 mithril kernel: ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
Jul 14 08:25:51 mithril kernel: ehci_hcd 0000:00:1d.7: setting latency timer to 64
Jul 14 08:25:51 mithril kernel: ehci_hcd 0000:00:1d.7: EHCI Host Controller
Jul 14 08:25:51 mithril kernel: ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
Jul 14 08:25:51 mithril kernel: ehci_hcd 0000:00:1d.7: using broken periodic workaround
Jul 14 08:25:51 mithril kernel: ehci_hcd 0000:00:1d.7: debug port 1
Jul 14 08:25:51 mithril kernel: ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
Jul 14 08:25:51 mithril kernel: ehci_hcd 0000:00:1d.7: irq 23, io mem 0x98405400
Jul 14 08:25:51 mithril kernel: ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
Jul 14 08:25:51 mithril kernel: hub 1-0:1.0: USB hub found
Jul 14 08:25:51 mithril kernel: hub 1-0:1.0: 8 ports detected
Jul 14 08:25:51 mithril kernel: sda1 sda2 sda3 sda4
Jul 14 08:25:51 mithril kernel: uhci_hcd: USB Universal Host Controller Interface driver
Jul 14 08:25:51 mithril kernel: sd 2:0:1:0: [sda] Attached SCSI disk
Jul 14 08:25:51 mithril kernel: uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
Jul 14 08:25:51 mithril kernel: uhci_hcd 0000:00:1d.0: setting latency timer to 64
Jul 14 08:25:51 mithril kernel: uhci_hcd 0000:00:1d.0: UHCI Host Controller
Jul 14 08:25:51 mithril kernel: uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
Jul 14 08:25:51 mithril kernel: uhci_hcd 0000:00:1d.0: irq 23, io base 0x00004080
Jul 14 08:25:51 mithril kernel: hub 2-0:1.0: USB hub found
Jul 14 08:25:51 mithril kernel: hub 2-0:1.0: 2 ports detected
Jul 14 08:25:51 mithril kernel: uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
Jul 14 08:25:51 mithril kernel: uhci_hcd 0000:00:1d.1: setting latency timer to 64
Jul 14 08:25:51 mithril kernel: uhci_hcd 0000:00:1d.1: UHCI Host Controller
Jul 14 08:25:51 mithril kernel: uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
Jul 14 08:25:51 mithril kernel: uhci_hcd 0000:00:1d.1: irq 19, io base 0x00004060
Jul 14 08:25:51 mithril kernel: hub 3-0:1.0: USB hub found
Jul 14 08:25:51 mithril kernel: hub 3-0:1.0: 2 ports detected
Jul 14 08:25:51 mithril kernel: uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
Jul 14 08:25:51 mithril kernel: uhci_hcd 0000:00:1d.2: setting latency timer to 64
Jul 14 08:25:51 mithril kernel: uhci_hcd 0000:00:1d.2: UHCI Host Controller
Jul 14 08:25:51 mithril kernel: uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
Jul 14 08:25:51 mithril kernel: uhci_hcd 0000:00:1d.2: irq 18, io base 0x00004040
Jul 14 08:25:51 mithril kernel: hub 4-0:1.0: USB hub found
Jul 14 08:25:51 mithril kernel: hub 4-0:1.0: 2 ports detected
Jul 14 08:25:51 mithril kernel: uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
Jul 14 08:25:51 mithril kernel: uhci_hcd 0000:00:1d.3: setting latency timer to 64
Jul 14 08:25:51 mithril kernel: uhci_hcd 0000:00:1d.3: UHCI Host Controller
Jul 14 08:25:51 mithril kernel: uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
Jul 14 08:25:51 mithril kernel: uhci_hcd 0000:00:1d.3: irq 16, io base 0x00004020
Jul 14 08:25:51 mithril kernel: hub 5-0:1.0: USB hub found
Jul 14 08:25:51 mithril kernel: hub 5-0:1.0: 2 ports detected
Jul 14 08:25:51 mithril kernel: usbcore: registered new interface driver usblp
Jul 14 08:25:51 mithril kernel: Initializing USB Mass Storage driver...
Jul 14 08:25:51 mithril kernel: usbcore: registered new interface driver usb-storage
Jul 14 08:25:51 mithril kernel: USB Mass Storage support registered.
Jul 14 08:25:51 mithril kernel: PNP: No PS/2 controller found. Probing ports directly.
Jul 14 08:25:51 mithril kernel: i8042.c: No controller found.
Jul 14 08:25:51 mithril kernel: mice: PS/2 mouse device common for all mice
Jul 14 08:25:51 mithril kernel: rtc_cmos 00:08: RTC can wake from S4
Jul 14 08:25:51 mithril kernel: rtc_cmos 00:08: rtc core: registered rtc_cmos as rtc0
Jul 14 08:25:51 mithril kernel: rtc0: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
Jul 14 08:25:51 mithril kernel: i2c /dev entries driver
Jul 14 08:25:51 mithril kernel: i801_smbus 0000:00:1f.3: PCI INT B -> GSI 19 (level, low) -> IRQ 19
Jul 14 08:25:51 mithril kernel: ACPI: resource 0000:00:1f.3 [io  0xefa0-0xefbf] conflicts with ACPI region SMBI [??? 0x0000efa0-0x0000efaf flags 0x49]
Jul 14 08:25:51 mithril kernel: ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
Jul 14 08:25:51 mithril kernel: applesmc: Apple MacBook Pro detected:
Jul 14 08:25:51 mithril kernel: applesmc:  - Model with accelerometer
Jul 14 08:25:51 mithril kernel: applesmc:  - Model with light sensors and backlight
Jul 14 08:25:51 mithril kernel: applesmc:  - Model with 12 temperature sensors
Jul 14 08:25:51 mithril kernel: applesmc: device successfully initialized (0xe0, 0x00).
Jul 14 08:25:51 mithril kernel: applesmc: device successfully initialized.
Jul 14 08:25:51 mithril kernel: applesmc: 2 fans found.
Jul 14 08:25:51 mithril kernel: input: applesmc as /devices/platform/applesmc.768/input/input4
Jul 14 08:25:51 mithril kernel: Registered led device: smc::kbd_backlight
Jul 14 08:25:51 mithril kernel: applesmc: driver successfully loaded.
Jul 14 08:25:51 mithril kernel: coretemp coretemp.0: TjMax is assumed as 100 C!
Jul 14 08:25:51 mithril kernel: coretemp coretemp.1: TjMax is assumed as 100 C!
Jul 14 08:25:51 mithril kernel: Bluetooth: Generic Bluetooth USB driver ver 0.6
Jul 14 08:25:51 mithril kernel: usbcore: registered new interface driver btusb
Jul 14 08:25:51 mithril kernel: cpuidle: using governor ladder
Jul 14 08:25:51 mithril kernel: cpuidle: using governor menu
Jul 14 08:25:51 mithril kernel: ioatdma: Intel(R) QuickData Technology Driver 4.00
Jul 14 08:25:51 mithril kernel: usbcore: registered new interface driver hiddev
Jul 14 08:25:51 mithril kernel: usbcore: registered new interface driver usbhid
Jul 14 08:25:51 mithril kernel: usbhid: USB HID core driver
Jul 14 08:25:51 mithril kernel: HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
Jul 14 08:25:51 mithril kernel: HDA Intel 0000:00:1b.0: irq 46 for MSI/MSI-X
Jul 14 08:25:51 mithril kernel: HDA Intel 0000:00:1b.0: setting latency timer to 64
Jul 14 08:25:51 mithril kernel: hda_codec: STAC922x, Apple subsys_id=106b1a00
Jul 14 08:25:51 mithril kernel: ALSA device list:
Jul 14 08:25:51 mithril kernel: #0: HDA Intel at 0x98400000 irq 46
Jul 14 08:25:51 mithril kernel: Netfilter messages via NETLINK v0.30.
Jul 14 08:25:51 mithril kernel: nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
Jul 14 08:25:51 mithril kernel: CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
Jul 14 08:25:51 mithril kernel: nf_conntrack.acct=1 kernel parameter, acct=1 nf_conntrack module option or
Jul 14 08:25:51 mithril kernel: sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
Jul 14 08:25:51 mithril kernel: ctnetlink v0.93: registering with nfnetlink.
Jul 14 08:25:51 mithril kernel: xt_time: kernel timezone is -0000
Jul 14 08:25:51 mithril kernel: ip_tables: (C) 2000-2006 Netfilter Core Team
Jul 14 08:25:51 mithril kernel: TCP cubic registered
Jul 14 08:25:51 mithril kernel: NET: Registered protocol family 10
Jul 14 08:25:51 mithril kernel: ip6_tables: (C) 2000-2006 Netfilter Core Team
Jul 14 08:25:51 mithril kernel: NET: Registered protocol family 17
Jul 14 08:25:51 mithril kernel: Bluetooth: L2CAP ver 2.14
Jul 14 08:25:51 mithril kernel: Bluetooth: L2CAP socket layer initialized
Jul 14 08:25:51 mithril kernel: Bluetooth: HIDP (Human Interface Emulation) ver 1.2
Jul 14 08:25:51 mithril kernel: Using IPI No-Shortcut mode
Jul 14 08:25:51 mithril kernel: registered taskstats version 1
Jul 14 08:25:51 mithril kernel: rtc_cmos 00:08: setting system clock to 2010-07-14 06:24:37 UTC (1279088677)
Jul 14 08:25:51 mithril kernel: EXT4-fs (sda3): mounted filesystem with ordered data mode. Opts: (null)
Jul 14 08:25:51 mithril kernel: VFS: Mounted root (ext4 filesystem) readonly on device 8:3.
Jul 14 08:25:51 mithril kernel: Freeing unused kernel memory: 416k freed
Jul 14 08:25:51 mithril kernel: Write protecting the kernel text: 5680k
Jul 14 08:25:51 mithril kernel: Write protecting the kernel read-only data: 2100k
Jul 14 08:25:51 mithril kernel: usb 1-4: new high speed USB device using ehci_hcd and address 3
Jul 14 08:25:51 mithril kernel: firewire_core: created device fw0: GUID 0017f2fffe8db89e, S800
Jul 14 08:25:51 mithril kernel: usb 2-2: new full speed USB device using uhci_hcd and address 2
Jul 14 08:25:51 mithril kernel: input: Apple Computer Apple Internal Keyboard / Trackpad as /devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.0/input/input5
Jul 14 08:25:51 mithril kernel: apple 0003:05AC:021B.0001: input: USB HID v1.11 Keyboard [Apple Computer Apple Internal Keyboard / Trackpad] on usb-0000:00:1d.0-2/input0
Jul 14 08:25:51 mithril kernel: input: Apple Computer Apple Internal Keyboard / Trackpad as /devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.2/input/input6
Jul 14 08:25:51 mithril kernel: apple 0003:05AC:021B.0002: input: USB HID v1.11 Device [Apple Computer Apple Internal Keyboard / Trackpad] on usb-0000:00:1d.0-2/input2
Jul 14 08:25:51 mithril kernel: usb 4-2: new full speed USB device using uhci_hcd and address 2
Jul 14 08:25:51 mithril kernel: generic-usb 0003:05AC:8240.0003: hiddev96: USB HID v1.11 Device [Apple Computer, Inc. IR Receiver] on usb-0000:00:1d.2-2/input0
Jul 14 08:25:51 mithril kernel: usb 5-1: new full speed USB device using uhci_hcd and address 2
Jul 14 08:25:51 mithril kernel: input: HID 05ac:1000 as /devices/pci0000:00/0000:00:1d.3/usb5/5-1/5-1:1.0/input/input7
Jul 14 08:25:51 mithril kernel: generic-usb 0003:05AC:1000.0004: input: USB HID v1.11 Keyboard [HID 05ac:1000] on usb-0000:00:1d.3-1/input0
Jul 14 08:25:51 mithril kernel: input: HID 05ac:1000 as /devices/pci0000:00/0000:00:1d.3/usb5/5-1/5-1:1.1/input/input8
Jul 14 08:25:51 mithril kernel: generic-usb 0003:05AC:1000.0005: input: USB HID v1.11 Mouse [HID 05ac:1000] on usb-0000:00:1d.3-1/input1
Jul 14 08:25:51 mithril kernel: appletouch: Geyser mode initialized.
Jul 14 08:25:51 mithril kernel: input: appletouch as /devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.1/input/input9
Jul 14 08:25:51 mithril kernel: usbcore: registered new interface driver appletouch
Jul 14 08:25:51 mithril kernel: udev: starting version 149
Jul 14 08:25:51 mithril kernel: ------------[ cut here ]------------
Jul 14 08:25:51 mithril kernel: kernel BUG at arch/x86/mm/physaddr.c:52!
Jul 14 08:25:51 mithril kernel: invalid opcode: 0000 [#1] PREEMPT SMP 
Jul 14 08:25:51 mithril kernel: last sysfs file: /sys/devices/pci0000:00/0000:00:1d.7/usb1/1-4/firmware/1-4/loading
Jul 14 08:25:51 mithril kernel: Modules linked in: isight_firmware(+) appletouch
Jul 14 08:25:51 mithril kernel: 
Jul 14 08:25:51 mithril kernel: Pid: 1804, comm: modprobe Not tainted 2.6.35-rc5 #10 Mac-F42189C8/MacBookPro2,1
Jul 14 08:25:51 mithril kernel: EIP: 0060:[<c104cf3e>] EFLAGS: 00010287 CPU: 0
Jul 14 08:25:51 mithril kernel: EIP is at __phys_addr+0x4e/0x60
Jul 14 08:25:51 mithril kernel: EAX: ff7fe000 EBX: f80462f6 ECX: 000002f6 EDX: f80462f6
Jul 14 08:25:51 mithril kernel: ESI: f712585c EDI: c102dc90 EBP: f5f79c58 ESP: f5f79c58
Jul 14 08:25:51 mithril kernel: DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Jul 14 08:25:51 mithril kernel: Process modprobe (pid: 1804, ti=f5f78000 task=f730a320 task.ti=f5f78000)
Jul 14 08:25:51 mithril kernel: Stack:
Jul 14 08:25:51 mithril kernel: f5f79d64 c13bed30 00000008 00000001 366a5950 00000001 c1075d05 00000000
Jul 14 08:25:51 mithril kernel: <0> f5f79d00 00000000 f5f79cf8 00000010 f5f0d000 fffffff5 f64aac00 f5f0d008
Jul 14 08:25:51 mithril kernel: <0> f5f79d00 00000046 00000000 00000060 ffffffff 00000000 c1ccd000 000002f6
Jul 14 08:25:51 mithril kernel: Call Trace:
Jul 14 08:25:51 mithril kernel: [<c13bed30>] ? usb_hcd_submit_urb+0xa80/0xe30
Jul 14 08:25:51 mithril kernel: [<c1075d05>] ? __init_waitqueue_head+0x35/0x50
Jul 14 08:25:51 mithril kernel: [<c1085ce0>] ? lockdep_init_map+0x40/0x4e0
Jul 14 08:25:51 mithril kernel: [<c1085ce0>] ? lockdep_init_map+0x40/0x4e0
Jul 14 08:25:51 mithril kernel: [<c13bf455>] ? usb_submit_urb+0xf5/0x290
Jul 14 08:25:51 mithril kernel: [<c13c06f3>] ? usb_start_wait_urb+0x43/0xc0
Jul 14 08:25:51 mithril kernel: [<c13c097a>] ? usb_control_msg+0xba/0xe0
Jul 14 08:25:51 mithril kernel: [<f80460b0>] ? isight_firmware_load+0xa0/0x2a8 [isight_firmware]
Jul 14 08:25:51 mithril kernel: [<c1336352>] ? __pm_runtime_set_status+0x102/0x1b0
Jul 14 08:25:51 mithril kernel: [<c13c2730>] ? usb_probe_interface+0xb0/0x1b0
Jul 14 08:25:51 mithril kernel: [<c112b092>] ? sysfs_create_link+0x12/0x20
Jul 14 08:25:51 mithril kernel: [<c133009b>] ? driver_probe_device+0x7b/0x1b0
Jul 14 08:25:51 mithril kernel: [<c1330269>] ? __driver_attach+0x99/0xa0
Jul 14 08:25:51 mithril kernel: [<c132f933>] ? bus_for_each_dev+0x53/0x80
Jul 14 08:25:51 mithril kernel: [<c132ff29>] ? driver_attach+0x19/0x20
Jul 14 08:25:51 mithril kernel: [<c13301d0>] ? __driver_attach+0x0/0xa0
Jul 14 08:25:51 mithril kernel: [<c132f1e2>] ? bus_add_driver+0xb2/0x250
Jul 14 08:25:51 mithril kernel: [<c1330515>] ? driver_register+0x75/0x170
Jul 14 08:25:51 mithril kernel: [<c13c249a>] ? usb_register_driver+0x8a/0x150
Jul 14 08:25:51 mithril kernel: [<f8049000>] ? isight_firmware_init+0x0/0x19 [isight_firmware]
Jul 14 08:25:51 mithril kernel: [<f8049017>] ? isight_firmware_init+0x17/0x19 [isight_firmware]
Jul 14 08:25:51 mithril kernel: [<c1001123>] ? do_one_initcall+0x23/0x180
Jul 14 08:25:51 mithril kernel: [<c107ad5a>] ? blocking_notifier_call_chain+0x1a/0x20
Jul 14 08:25:51 mithril kernel: [<c1091481>] ? sys_init_module+0x91/0x1d0
Jul 14 08:25:51 mithril kernel: [<c10ded4d>] ? sys_read+0x3d/0x70
Jul 14 08:25:51 mithril kernel: [<c1028210>] ? sysenter_do_call+0x12/0x31
Jul 14 08:25:51 mithril kernel: Code: 26 00 00 00 00 a1 0c ad c9 c1 05 00 00 80 00 39 c2 72 df a1 20 5e 7b c1 2d 00 c0 59 00 25 00 00 c0 ff 2d 00 20 00 00 39 c2 73 c7 <0f> 0b eb fe 8d b4 26 00 00 00 00 8d bc 27 00 00 00 00 55 89 c2 
Jul 14 08:25:51 mithril kernel: EIP: [<c104cf3e>] __phys_addr+0x4e/0x60 SS:ESP 0068:f5f79c58
Jul 14 08:25:51 mithril kernel: ---[ end trace 6336ba0fbf1dce3e ]---
Jul 14 08:25:51 mithril kernel: EXT4-fs (sda3): re-mounted. Opts: barrier=0
Jul 14 08:25:51 mithril kernel: Adding 4912324k swap on /dev/sda4.  Priority:-1 extents:1 across:4912324k 
Jul 14 08:25:51 mithril kernel: microcode: CPU0 updated to revision 0xcc, date = 2007-09-16
Jul 14 08:25:51 mithril kernel: microcode: CPU1 updated to revision 0xcc, date = 2007-09-16
Jul 14 08:25:51 mithril kernel: sky2 0000:02:00.0: eth0: enabling interface
Jul 14 08:25:51 mithril kernel: ADDRCONF(NETDEV_UP): eth0: link is not ready
Jul 14 08:25:51 mithril kernel: ADDRCONF(NETDEV_UP): wlan0: link is not ready
Jul 14 08:25:51 mithril kernel: ADDRCONF(NETDEV_UP): wlan0: link is not ready
Jul 14 08:25:51 mithril kernel: ------------[ cut here ]------------
Jul 14 08:25:51 mithril kernel: WARNING: at lib/dma-debug.c:852 check_unmap+0x370/0x7f0()
Jul 14 08:25:51 mithril kernel: Hardware name: MacBookPro2,1
Jul 14 08:25:51 mithril kernel: ath9k 0000:03:00.0: DMA-API: device driver frees DMA memory with different direction [device address=0x0000000036514100] [size=3904 bytes] [mapped with DMA_FROM_DEVICE] [unmapped with DMA_BIDIRECTIONAL]
Jul 14 08:25:51 mithril kernel: Modules linked in: isight_firmware(+) appletouch
Jul 14 08:25:51 mithril kernel: Pid: 0, comm: swapper Tainted: G      D     2.6.35-rc5 #10
Jul 14 08:25:51 mithril kernel: Call Trace:
Jul 14 08:25:51 mithril kernel: [<c11e5e70>] ? check_unmap+0x370/0x7f0
Jul 14 08:25:51 mithril kernel: [<c11e5e70>] ? check_unmap+0x370/0x7f0
Jul 14 08:25:51 mithril kernel: [<c105f50c>] warn_slowpath_common+0x6c/0xc0
Jul 14 08:25:51 mithril kernel: [<c11e5e70>] ? check_unmap+0x370/0x7f0
Jul 14 08:25:51 mithril kernel: [<c105f5de>] warn_slowpath_fmt+0x2e/0x30
Jul 14 08:25:51 mithril kernel: [<c11e5e70>] check_unmap+0x370/0x7f0
Jul 14 08:25:51 mithril kernel: [<c105c5db>] ? default_wake_function+0xb/0x10
Jul 14 08:25:51 mithril kernel: [<c107599b>] ? autoremove_wake_function+0x1b/0x40
Jul 14 08:25:51 mithril kernel: [<c1075a0f>] ? wake_bit_function+0x4f/0x60
Jul 14 08:25:51 mithril kernel: [<c11e6467>] debug_dma_unmap_page+0x67/0x80
Jul 14 08:25:51 mithril kernel: [<c137e6d6>] ath_rx_tasklet+0x686/0xac0
Jul 14 08:25:51 mithril kernel: [<c10d699c>] ? add_partial+0x1c/0x70
Jul 14 08:25:51 mithril kernel: [<c137d3cb>] ath9k_tasklet+0x11b/0x160
Jul 14 08:25:51 mithril kernel: [<c1064620>] tasklet_action+0x50/0xc0
Jul 14 08:25:51 mithril kernel: [<c1064dac>] __do_softirq+0x8c/0x110
Jul 14 08:25:51 mithril kernel: [<c1064e65>] do_softirq+0x35/0x40
Jul 14 08:25:51 mithril kernel: [<c1065085>] irq_exit+0x65/0x80
Jul 14 08:25:51 mithril kernel: [<c1029c8f>] do_IRQ+0x4f/0xc0
Jul 14 08:25:51 mithril kernel: [<c107b76a>] ? sched_clock_local+0xda/0x180
Jul 14 08:25:51 mithril kernel: [<c1028729>] common_interrupt+0x29/0x30
Jul 14 08:25:51 mithril kernel: [<c107007b>] ? sys_setfsgid+0x1b/0xc0
Jul 14 08:25:51 mithril kernel: [<c1246bbe>] ? acpi_idle_enter_bm+0x266/0x292
Jul 14 08:25:51 mithril kernel: [<c13fef6d>] cpuidle_idle_call+0x7d/0xc0
Jul 14 08:25:51 mithril kernel: [<c10272a5>] cpu_idle+0x55/0x90
Jul 14 08:25:51 mithril kernel: [<c156dd23>] rest_init+0xd3/0xe0
Jul 14 08:25:51 mithril kernel: [<c156dc50>] ? rest_init+0x0/0xe0
Jul 14 08:25:51 mithril kernel: [<c18008cf>] start_kernel+0x2a0/0x2db
Jul 14 08:25:51 mithril kernel: [<c1800409>] ? unknown_bootoption+0x0/0x1d5
Jul 14 08:25:51 mithril kernel: [<c180008b>] i386_start_kernel+0x8b/0x91
Jul 14 08:25:51 mithril kernel: ---[ end trace 6336ba0fbf1dce3f ]---
Jul 14 08:25:51 mithril kernel: Mapped at:
Jul 14 08:25:51 mithril kernel: [<c11e67b8>] debug_dma_map_page+0x48/0x120
Jul 14 08:25:51 mithril kernel: [<c137f2f3>] ath_rx_init+0x1e3/0x510
Jul 14 08:25:51 mithril kernel: [<c137b04c>] ath9k_init_device+0x4fc/0x750
Jul 14 08:25:51 mithril kernel: [<c1385fdf>] ath_pci_probe+0x1df/0x3c0
Jul 14 08:25:51 mithril kernel: [<c11ed17e>] local_pci_probe+0xe/0x10
Jul 14 08:25:51 mithril kernel: wlan0: deauthenticating from 00:22:6b:ea:c0:85 by local choice (reason=3)
Jul 14 08:25:51 mithril kernel: wlan0: authenticate with 00:22:6b:ea:c0:85 (try 1)
Jul 14 08:25:51 mithril kernel: wlan0: authenticated
Jul 14 08:25:51 mithril kernel: wlan0: associate with 00:22:6b:ea:c0:85 (try 1)
Jul 14 08:25:51 mithril kernel: wlan0: RX AssocResp from 00:22:6b:ea:c0:85 (capab=0x431 status=0 aid=2)
Jul 14 08:25:51 mithril kernel: wlan0: associated
Jul 14 08:25:51 mithril kernel: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready

--------------090708000208020402030405
Content-Type: text/plain;
 name="config.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="config.txt"

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.35-rc5
# Tue Jul 13 18:27:34 2010
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
# CONFIG_X86_64 is not set
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf32-i386"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
# CONFIG_GENERIC_TIME_VSYSCALL is not set
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
# CONFIG_HAVE_CPUMASK_OF_CPU_MAP is not set
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
# CONFIG_ZONE_DMA32 is not set
CONFIG_ARCH_POPULATES_NODE_MAP=y
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_HAVE_EARLY_RES=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_X86_32_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_TRAMPOLINE=y
CONFIG_X86_32_LAZY_GS=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
CONFIG_KTIME_SCALAR=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y
# CONFIG_AUDIT is not set

#
# RCU Subsystem
#
# CONFIG_TREE_RCU is not set
CONFIG_TREE_PREEMPT_RCU=y
# CONFIG_TINY_RCU is not set
# CONFIG_RCU_TRACE is not set
CONFIG_RCU_FANOUT=32
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
# CONFIG_CGROUPS is not set
# CONFIG_SYSFS_DEPRECATED_V2 is not set
CONFIG_RELAY=y
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_IPC_NS is not set
# CONFIG_USER_NS is not set
# CONFIG_PID_NS is not set
# CONFIG_NET_NS is not set
# CONFIG_BLK_DEV_INITRD is not set
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
# CONFIG_EMBEDDED is not set
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_PERF_COUNTERS is not set
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
CONFIG_HAVE_OPROFILE=y
# CONFIG_KPROBES is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
CONFIG_SLOW_WORK=y
# CONFIG_SLOW_WORK_DEBUG is not set
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_LBDAF=y
# CONFIG_BLK_DEV_BSG is not set
# CONFIG_BLK_DEV_INTEGRITY is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_PREEMPT_NOTIFIERS=y
# CONFIG_INLINE_SPIN_TRYLOCK is not set
# CONFIG_INLINE_SPIN_TRYLOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK is not set
# CONFIG_INLINE_SPIN_LOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK_IRQ is not set
# CONFIG_INLINE_SPIN_LOCK_IRQSAVE is not set
# CONFIG_INLINE_SPIN_UNLOCK is not set
# CONFIG_INLINE_SPIN_UNLOCK_BH is not set
# CONFIG_INLINE_SPIN_UNLOCK_IRQ is not set
# CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_READ_TRYLOCK is not set
# CONFIG_INLINE_READ_LOCK is not set
# CONFIG_INLINE_READ_LOCK_BH is not set
# CONFIG_INLINE_READ_LOCK_IRQ is not set
# CONFIG_INLINE_READ_LOCK_IRQSAVE is not set
# CONFIG_INLINE_READ_UNLOCK is not set
# CONFIG_INLINE_READ_UNLOCK_BH is not set
# CONFIG_INLINE_READ_UNLOCK_IRQ is not set
# CONFIG_INLINE_READ_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_WRITE_TRYLOCK is not set
# CONFIG_INLINE_WRITE_LOCK is not set
# CONFIG_INLINE_WRITE_LOCK_BH is not set
# CONFIG_INLINE_WRITE_LOCK_IRQ is not set
# CONFIG_INLINE_WRITE_LOCK_IRQSAVE is not set
# CONFIG_INLINE_WRITE_UNLOCK is not set
# CONFIG_INLINE_WRITE_UNLOCK_BH is not set
# CONFIG_INLINE_WRITE_UNLOCK_IRQ is not set
# CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE is not set
# CONFIG_MUTEX_SPIN_ON_OWNER is not set
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP=y
# CONFIG_SPARSE_IRQ is not set
# CONFIG_X86_MPPARSE is not set
# CONFIG_X86_BIGSMP is not set
# CONFIG_X86_EXTENDED_PLATFORM is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
CONFIG_SCHED_OMIT_FRAME_POINTER=y
# CONFIG_PARAVIRT_GUEST is not set
CONFIG_NO_BOOTMEM=y
# CONFIG_MEMTEST is not set
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MPSC is not set
CONFIG_MCORE2=y
# CONFIG_MATOM is not set
# CONFIG_GENERIC_CPU is not set
# CONFIG_X86_GENERIC is not set
CONFIG_X86_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_XADD=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=5
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_CYRIX_32=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_CPU_SUP_UMC_32=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
# CONFIG_IOMMU_HELPER is not set
# CONFIG_IOMMU_API is not set
CONFIG_NR_CPUS=2
# CONFIG_SCHED_SMT is not set
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
# CONFIG_X86_MCE_AMD is not set
# CONFIG_X86_ANCIENT_MCE is not set
CONFIG_X86_MCE_THRESHOLD=y
# CONFIG_X86_MCE_INJECT is not set
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_VM86=y
# CONFIG_TOSHIBA is not set
# CONFIG_I8K is not set
CONFIG_X86_REBOOTFIXUPS=y
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
# CONFIG_ARCH_PHYS_ADDR_T_64BIT is not set
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_DISCONTIGMEM_MANUAL is not set
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
# CONFIG_COMPACTION is not set
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_MEMORY_FAILURE is not set
# CONFIG_HIGHPTE is not set
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
# CONFIG_X86_RESERVE_LOW_64K is not set
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_EFI=y
CONFIG_SECCOMP=y
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
# CONFIG_CRASH_DUMP is not set
# CONFIG_KEXEC_JUMP is not set
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x100000
CONFIG_HOTPLUG_CPU=y
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_SLEEP=y
CONFIG_SUSPEND_NVS=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION="/dev/sda4"
CONFIG_PM_RUNTIME=y
CONFIG_PM_OPS=y
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_PROCFS_POWER=y
# CONFIG_ACPI_POWER_METER is not set
CONFIG_ACPI_SYSFS_POWER=y
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_APEI is not set
# CONFIG_SFI is not set
# CONFIG_APM is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
# CONFIG_CPU_FREQ_DEBUG is not set
# CONFIG_CPU_FREQ_STAT is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=m
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# CPUFreq processor drivers
#
# CONFIG_X86_PCC_CPUFREQ is not set
CONFIG_X86_ACPI_CPUFREQ=y
# CONFIG_X86_POWERNOW_K6 is not set
# CONFIG_X86_POWERNOW_K7 is not set
# CONFIG_X86_POWERNOW_K8 is not set
# CONFIG_X86_GX_SUSPMOD is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_SPEEDSTEP_ICH is not set
# CONFIG_X86_SPEEDSTEP_SMI is not set
# CONFIG_X86_P4_CLOCKMOD is not set
# CONFIG_X86_CPUFREQ_NFORCE2 is not set
# CONFIG_X86_LONGRUN is not set
# CONFIG_X86_LONGHAUL is not set
# CONFIG_X86_E_POWERSAVER is not set

#
# shared options
#
# CONFIG_X86_SPEEDSTEP_LIB is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
CONFIG_INTEL_IDLE=y

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
# CONFIG_PCI_GOOLPC is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
# CONFIG_DMAR is not set
CONFIG_PCIEPORTBUS=y
CONFIG_PCIEAER=y
# CONFIG_PCIE_ECRC is not set
# CONFIG_PCIEAER_INJECT is not set
# CONFIG_PCIEASPM is not set
CONFIG_PCIE_PME=y
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=y
# CONFIG_PCI_IOV is not set
CONFIG_PCI_IOAPIC=y
CONFIG_ISA_DMA_API=y
CONFIG_ISA=y
# CONFIG_EISA is not set
# CONFIG_MCA is not set
# CONFIG_SCx200 is not set
# CONFIG_OLPC is not set
CONFIG_K8_NB=y
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
CONFIG_HAVE_AOUT=y
# CONFIG_BINFMT_AOUT is not set
CONFIG_BINFMT_MISC=m
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_UNIX=y
CONFIG_XFRM=y
CONFIG_XFRM_USER=m
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
# CONFIG_XFRM_STATISTICS is not set
CONFIG_XFRM_IPCOMP=m
CONFIG_NET_KEY=m
# CONFIG_NET_KEY_MIGRATE is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_FIB_HASH=y
# CONFIG_IP_PNP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE is not set
# CONFIG_IP_MROUTE is not set
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=y
CONFIG_INET_AH=m
CONFIG_INET_ESP=m
CONFIG_INET_IPCOMP=m
CONFIG_INET_XFRM_TUNNEL=m
CONFIG_INET_TUNNEL=m
CONFIG_INET_XFRM_MODE_TRANSPORT=y
CONFIG_INET_XFRM_MODE_TUNNEL=y
CONFIG_INET_XFRM_MODE_BEET=y
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
CONFIG_IPV6=y
# CONFIG_IPV6_PRIVACY is not set
# CONFIG_IPV6_ROUTER_PREF is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
CONFIG_INET6_AH=m
CONFIG_INET6_ESP=m
CONFIG_INET6_IPCOMP=m
# CONFIG_IPV6_MIP6 is not set
CONFIG_INET6_XFRM_TUNNEL=m
CONFIG_INET6_TUNNEL=m
CONFIG_INET6_XFRM_MODE_TRANSPORT=m
CONFIG_INET6_XFRM_MODE_TUNNEL=m
CONFIG_INET6_XFRM_MODE_BEET=m
# CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
CONFIG_IPV6_SIT=m
# CONFIG_IPV6_SIT_6RD is not set
CONFIG_IPV6_NDISC_NODETYPE=y
# CONFIG_IPV6_TUNNEL is not set
# CONFIG_IPV6_MULTIPLE_TABLES is not set
# CONFIG_IPV6_MROUTE is not set
# CONFIG_NETWORK_SECMARK is not set
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=y
CONFIG_NETFILTER_NETLINK_QUEUE=y
CONFIG_NETFILTER_NETLINK_LOG=y
CONFIG_NF_CONNTRACK=y
CONFIG_NF_CT_ACCT=y
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_EVENTS=y
# CONFIG_NF_CT_PROTO_DCCP is not set
# CONFIG_NF_CT_PROTO_SCTP is not set
# CONFIG_NF_CT_PROTO_UDPLITE is not set
# CONFIG_NF_CONNTRACK_AMANDA is not set
CONFIG_NF_CONNTRACK_FTP=y
# CONFIG_NF_CONNTRACK_H323 is not set
CONFIG_NF_CONNTRACK_IRC=y
CONFIG_NF_CONNTRACK_NETBIOS_NS=m
# CONFIG_NF_CONNTRACK_PPTP is not set
CONFIG_NF_CONNTRACK_SANE=y
# CONFIG_NF_CONNTRACK_SIP is not set
# CONFIG_NF_CONNTRACK_TFTP is not set
CONFIG_NF_CT_NETLINK=y
CONFIG_NETFILTER_XTABLES=y

#
# Xtables combined modules
#
CONFIG_NETFILTER_XT_MARK=y
CONFIG_NETFILTER_XT_CONNMARK=y

#
# Xtables targets
#
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=y
CONFIG_NETFILTER_XT_TARGET_CONNMARK=y
# CONFIG_NETFILTER_XT_TARGET_LED is not set
CONFIG_NETFILTER_XT_TARGET_MARK=y
CONFIG_NETFILTER_XT_TARGET_NFLOG=y
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=y
CONFIG_NETFILTER_XT_TARGET_RATEEST=y
# CONFIG_NETFILTER_XT_TARGET_TEE is not set
CONFIG_NETFILTER_XT_TARGET_TCPMSS=y

#
# Xtables matches
#
# CONFIG_NETFILTER_XT_MATCH_CLUSTER is not set
CONFIG_NETFILTER_XT_MATCH_COMMENT=y
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=y
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=y
CONFIG_NETFILTER_XT_MATCH_CONNMARK=y
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=y
CONFIG_NETFILTER_XT_MATCH_DCCP=y
# CONFIG_NETFILTER_XT_MATCH_DSCP is not set
CONFIG_NETFILTER_XT_MATCH_ESP=y
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m
CONFIG_NETFILTER_XT_MATCH_HELPER=y
CONFIG_NETFILTER_XT_MATCH_HL=m
CONFIG_NETFILTER_XT_MATCH_IPRANGE=y
CONFIG_NETFILTER_XT_MATCH_LENGTH=y
CONFIG_NETFILTER_XT_MATCH_LIMIT=y
CONFIG_NETFILTER_XT_MATCH_MAC=y
CONFIG_NETFILTER_XT_MATCH_MARK=y
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=y
# CONFIG_NETFILTER_XT_MATCH_OSF is not set
CONFIG_NETFILTER_XT_MATCH_OWNER=y
CONFIG_NETFILTER_XT_MATCH_POLICY=y
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=y
CONFIG_NETFILTER_XT_MATCH_QUOTA=y
CONFIG_NETFILTER_XT_MATCH_RATEEST=y
CONFIG_NETFILTER_XT_MATCH_REALM=y
CONFIG_NETFILTER_XT_MATCH_RECENT=y
# CONFIG_NETFILTER_XT_MATCH_SCTP is not set
CONFIG_NETFILTER_XT_MATCH_STATE=y
CONFIG_NETFILTER_XT_MATCH_STATISTIC=y
CONFIG_NETFILTER_XT_MATCH_STRING=y
CONFIG_NETFILTER_XT_MATCH_TCPMSS=y
CONFIG_NETFILTER_XT_MATCH_TIME=y
CONFIG_NETFILTER_XT_MATCH_U32=y
# CONFIG_IP_VS is not set

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=y
CONFIG_NF_CONNTRACK_IPV4=y
CONFIG_NF_CONNTRACK_PROC_COMPAT=y
CONFIG_IP_NF_QUEUE=m
CONFIG_IP_NF_IPTABLES=y
CONFIG_IP_NF_MATCH_ADDRTYPE=m
CONFIG_IP_NF_MATCH_AH=m
CONFIG_IP_NF_MATCH_ECN=m
CONFIG_IP_NF_MATCH_TTL=m
CONFIG_IP_NF_FILTER=y
CONFIG_IP_NF_TARGET_REJECT=y
CONFIG_IP_NF_TARGET_LOG=y
CONFIG_IP_NF_TARGET_ULOG=m
# CONFIG_NF_NAT is not set
# CONFIG_IP_NF_MANGLE is not set
# CONFIG_IP_NF_TARGET_TTL is not set
# CONFIG_IP_NF_RAW is not set
# CONFIG_IP_NF_ARPTABLES is not set

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_CONNTRACK_IPV6=y
# CONFIG_IP6_NF_QUEUE is not set
CONFIG_IP6_NF_IPTABLES=y
CONFIG_IP6_NF_MATCH_AH=m
CONFIG_IP6_NF_MATCH_EUI64=m
CONFIG_IP6_NF_MATCH_FRAG=m
CONFIG_IP6_NF_MATCH_OPTS=m
CONFIG_IP6_NF_MATCH_HL=m
CONFIG_IP6_NF_MATCH_IPV6HEADER=m
# CONFIG_IP6_NF_MATCH_MH is not set
CONFIG_IP6_NF_MATCH_RT=m
# CONFIG_IP6_NF_TARGET_HL is not set
CONFIG_IP6_NF_TARGET_LOG=y
CONFIG_IP6_NF_FILTER=y
CONFIG_IP6_NF_TARGET_REJECT=y
# CONFIG_IP6_NF_MANGLE is not set
# CONFIG_IP6_NF_RAW is not set
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_RDS is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_L2TP is not set
# CONFIG_BRIDGE is not set
# CONFIG_NET_DSA is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
# CONFIG_NET_SCHED is not set
CONFIG_NET_CLS_ROUTE=y
# CONFIG_DCB is not set
CONFIG_RPS=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
CONFIG_IRDA=m

#
# IrDA protocols
#
CONFIG_IRLAN=m
CONFIG_IRCOMM=m
CONFIG_IRDA_ULTRA=y

#
# IrDA options
#
CONFIG_IRDA_CACHE_LAST_LSAP=y
CONFIG_IRDA_FAST_RR=y
# CONFIG_IRDA_DEBUG is not set

#
# Infrared-port device drivers
#

#
# SIR device drivers
#
# CONFIG_IRTTY_SIR is not set

#
# Dongle support
#
# CONFIG_KINGSUN_DONGLE is not set
# CONFIG_KSDAZZLE_DONGLE is not set
# CONFIG_KS959_DONGLE is not set

#
# FIR device drivers
#
# CONFIG_USB_IRDA is not set
# CONFIG_SIGMATEL_FIR is not set
# CONFIG_NSC_FIR is not set
# CONFIG_WINBOND_FIR is not set
# CONFIG_TOSHIBA_FIR is not set
# CONFIG_SMC_IRCC_FIR is not set
# CONFIG_ALI_FIR is not set
# CONFIG_VLSI_FIR is not set
# CONFIG_VIA_FIR is not set
# CONFIG_MCS_FIR is not set
CONFIG_BT=y
CONFIG_BT_L2CAP=y
# CONFIG_BT_L2CAP_EXT_FEATURES is not set
CONFIG_BT_SCO=m
CONFIG_BT_RFCOMM=m
CONFIG_BT_RFCOMM_TTY=y
# CONFIG_BT_BNEP is not set
CONFIG_BT_HIDP=y

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTUSB=y
CONFIG_BT_HCIUART=m
CONFIG_BT_HCIUART_H4=y
CONFIG_BT_HCIUART_BCSP=y
# CONFIG_BT_HCIUART_LL is not set
# CONFIG_BT_HCIBCM203X is not set
# CONFIG_BT_HCIBPA10X is not set
# CONFIG_BT_HCIBFUSB is not set
CONFIG_BT_HCIVHCI=m
# CONFIG_BT_MRVL is not set
# CONFIG_BT_ATH3K is not set
# CONFIG_AF_RXRPC is not set
CONFIG_WIRELESS=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_CFG80211=y
# CONFIG_NL80211_TESTMODE is not set
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
# CONFIG_CFG80211_REG_DEBUG is not set
CONFIG_CFG80211_DEFAULT_PS=y
CONFIG_CFG80211_DEBUGFS=y
# CONFIG_CFG80211_INTERNAL_REGDB is not set
CONFIG_CFG80211_WEXT=y
CONFIG_WIRELESS_EXT_SYSFS=y
# CONFIG_LIB80211 is not set
CONFIG_MAC80211=y
CONFIG_MAC80211_HAS_RC=y
CONFIG_MAC80211_RC_MINSTREL=y
# CONFIG_MAC80211_RC_DEFAULT_PID is not set
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel"
# CONFIG_MAC80211_MESH is not set
CONFIG_MAC80211_LEDS=y
# CONFIG_MAC80211_DEBUGFS is not set
# CONFIG_MAC80211_DEBUG_MENU is not set
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
# CONFIG_DEVTMPFS is not set
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
# CONFIG_ISAPNP is not set
# CONFIG_PNPBIOS is not set
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_DEV_XD is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_CRYPTOLOOP=m
# CONFIG_BLK_DEV_DRBD is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
CONFIG_BLK_DEV_RAM=m
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=65536
# CONFIG_BLK_DEV_XIP is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_VIRTIO_BLK is not set
# CONFIG_BLK_DEV_HD is not set
CONFIG_MISC_DEVICES=y
# CONFIG_AD525X_DPOT is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_ICS932S401 is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_CS5535_MFGPT is not set
# CONFIG_HP_ILO is not set
# CONFIG_ISL29003 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_DS1682 is not set
# CONFIG_TI_DAC7512 is not set
# CONFIG_VMWARE_BALLOON is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_AT25 is not set
# CONFIG_EEPROM_LEGACY is not set
# CONFIG_EEPROM_MAX6875 is not set
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_CB710_CORE is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
# CONFIG_SCSI_NETLINK is not set
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=y
# CONFIG_BLK_DEV_SR_VENDOR is not set
CONFIG_CHR_DEV_SG=y
# CONFIG_CHR_DEV_SCH is not set
# CONFIG_SCSI_MULTI_LUN is not set
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SCAN_ASYNC is not set
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
# CONFIG_SCSI_SPI_ATTRS is not set
# CONFIG_SCSI_FC_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
CONFIG_SCSI_LOWLEVEL=y
# CONFIG_ISCSI_TCP is not set
# CONFIG_SCSI_BNX2_ISCSI is not set
# CONFIG_BE2ISCSI is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_HPSA is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_3W_SAS is not set
# CONFIG_SCSI_7000FASST is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AHA152X is not set
# CONFIG_SCSI_AHA1542 is not set
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC7XXX_OLD is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_IN2000 is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
# CONFIG_SCSI_MPT2SAS is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_VMWARE_PVSCSI is not set
# CONFIG_LIBFC is not set
# CONFIG_LIBFCOE is not set
# CONFIG_FCOE is not set
# CONFIG_FCOE_FNIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_DTC3280 is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_GENERIC_NCR5380 is not set
# CONFIG_SCSI_GENERIC_NCR5380_MMIO is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_NCR53C406A is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_PAS16 is not set
# CONFIG_SCSI_QLOGIC_FAS is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_SYM53C416 is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_T128 is not set
# CONFIG_SCSI_U14_34F is not set
# CONFIG_SCSI_ULTRASTOR is not set
# CONFIG_SCSI_NSP32 is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_PMCRAID is not set
# CONFIG_SCSI_PM8001 is not set
# CONFIG_SCSI_SRP is not set
# CONFIG_SCSI_BFA_FC is not set
# CONFIG_SCSI_DH is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
# CONFIG_SATA_PMP is not set

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=y
CONFIG_SATA_AHCI_PLATFORM=y
# CONFIG_SATA_INIC162X is not set
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_SX4 is not set
CONFIG_ATA_BMDMA=y

#
# SATA SFF controllers with BMDMA
#
CONFIG_ATA_PIIX=y
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_SVW is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set

#
# PATA SFF controllers with BMDMA
#
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_ATP867X is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CS5535 is not set
# CONFIG_PATA_CS5536 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RDC is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SCH is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_TOSHIBA is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set

#
# PIO-only SFF controllers
#
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_QDI is not set
# CONFIG_PATA_RZ1000 is not set
# CONFIG_PATA_WINBOND_VLB is not set

#
# Generic fallback / legacy drivers
#
# CONFIG_PATA_ACPI is not set
# CONFIG_ATA_GENERIC is not set
# CONFIG_PATA_LEGACY is not set
# CONFIG_MD is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#

#
# You can enable one or both FireWire driver stacks.
#

#
# The newer stack is recommended.
#
CONFIG_FIREWIRE=y
CONFIG_FIREWIRE_OHCI=y
CONFIG_FIREWIRE_OHCI_DEBUG=y
CONFIG_FIREWIRE_SBP2=y
# CONFIG_FIREWIRE_NET is not set
# CONFIG_IEEE1394 is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
# CONFIG_DUMMY is not set
# CONFIG_BONDING is not set
# CONFIG_MACVLAN is not set
# CONFIG_EQUALIZER is not set
CONFIG_TUN=y
# CONFIG_VETH is not set
# CONFIG_NET_SB1000 is not set
# CONFIG_ARCNET is not set
# CONFIG_NET_ETHERNET is not set
CONFIG_MII=y
CONFIG_NETDEV_1000=y
# CONFIG_ACENIC is not set
# CONFIG_DL2K is not set
# CONFIG_E1000 is not set
# CONFIG_E1000E is not set
# CONFIG_IP1000 is not set
# CONFIG_IGB is not set
# CONFIG_IGBVF is not set
# CONFIG_NS83820 is not set
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
# CONFIG_R8169 is not set
# CONFIG_SIS190 is not set
# CONFIG_SKGE is not set
CONFIG_SKY2=y
# CONFIG_SKY2_DEBUG is not set
# CONFIG_VIA_VELOCITY is not set
# CONFIG_TIGON3 is not set
# CONFIG_BNX2 is not set
# CONFIG_CNIC is not set
# CONFIG_QLA3XXX is not set
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_ATL1C is not set
# CONFIG_JME is not set
# CONFIG_NETDEV_10000 is not set
# CONFIG_TR is not set
CONFIG_WLAN=y
# CONFIG_LIBERTAS_THINFIRM is not set
# CONFIG_AIRO is not set
# CONFIG_ATMEL is not set
# CONFIG_AT76C50X_USB is not set
# CONFIG_PRISM54 is not set
# CONFIG_USB_ZD1201 is not set
# CONFIG_USB_NET_RNDIS_WLAN is not set
# CONFIG_RTL8180 is not set
# CONFIG_RTL8187 is not set
# CONFIG_ADM8211 is not set
# CONFIG_MAC80211_HWSIM is not set
# CONFIG_MWL8K is not set
CONFIG_ATH_COMMON=y
# CONFIG_ATH_DEBUG is not set
# CONFIG_ATH5K is not set
CONFIG_ATH9K_HW=y
CONFIG_ATH9K_COMMON=y
CONFIG_ATH9K=y
# CONFIG_ATH9K_DEBUGFS is not set
# CONFIG_ATH9K_HTC is not set
# CONFIG_AR9170_USB is not set
# CONFIG_B43 is not set
# CONFIG_B43LEGACY is not set
# CONFIG_HOSTAP is not set
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
# CONFIG_IWLWIFI is not set
# CONFIG_LIBERTAS is not set
# CONFIG_HERMES is not set
# CONFIG_P54_COMMON is not set
# CONFIG_RT2X00 is not set
# CONFIG_WL12XX is not set
# CONFIG_ZD1211RW is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
CONFIG_USB_USBNET=y
# CONFIG_USB_NET_AX8817X is not set
CONFIG_USB_NET_CDCETHER=y
# CONFIG_USB_NET_CDC_EEM is not set
# CONFIG_USB_NET_DM9601 is not set
# CONFIG_USB_NET_SMSC75XX is not set
# CONFIG_USB_NET_SMSC95XX is not set
# CONFIG_USB_NET_GL620A is not set
# CONFIG_USB_NET_NET1080 is not set
# CONFIG_USB_NET_PLUSB is not set
# CONFIG_USB_NET_MCS7830 is not set
CONFIG_USB_NET_RNDIS_HOST=y
# CONFIG_USB_NET_CDC_SUBSET is not set
# CONFIG_USB_NET_ZAURUS is not set
# CONFIG_USB_NET_INT51X1 is not set
# CONFIG_USB_IPHETH is not set
# CONFIG_USB_SIERRA_NET is not set
# CONFIG_WAN is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
# CONFIG_NET_FC is not set
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
# CONFIG_VIRTIO_NET is not set
# CONFIG_VMXNET3 is not set
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
CONFIG_INPUT_POLLDEV=y
# CONFIG_INPUT_SPARSEKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1680
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=1050
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_QT2160 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
# CONFIG_MOUSE_PS2 is not set
# CONFIG_MOUSE_SERIAL is not set
CONFIG_MOUSE_APPLETOUCH=m
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_INPORT is not set
# CONFIG_MOUSE_LOGIBM is not set
# CONFIG_MOUSE_PC110PAD is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_AD714X is not set
# CONFIG_INPUT_PCSPKR is not set
# CONFIG_INPUT_APANEL is not set
# CONFIG_INPUT_WISTRON_BTNS is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
CONFIG_INPUT_UINPUT=y
# CONFIG_INPUT_WINBOND_CIR is not set
# CONFIG_INPUT_PCF8574 is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
# CONFIG_SERIO_SERPORT is not set
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
# CONFIG_DEVKMEM is not set
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_N_GSM is not set
# CONFIG_NOZOMI is not set

#
# Serial drivers
#
# CONFIG_SERIAL_8250 is not set
CONFIG_FIX_EARLYCON_MEM=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_VIRTIO_CONSOLE is not set
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=y
CONFIG_HW_RANDOM_INTEL=y
# CONFIG_HW_RANDOM_AMD is not set
# CONFIG_HW_RANDOM_GEODE is not set
# CONFIG_HW_RANDOM_VIA is not set
# CONFIG_HW_RANDOM_VIRTIO is not set
CONFIG_NVRAM=y
# CONFIG_DTLK is not set
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_NSC_GPIO is not set
# CONFIG_CS5535_GPIO is not set
# CONFIG_RAW_DRIVER is not set
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
# CONFIG_RAMOOPS is not set
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=y
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_ALGOBIT=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
CONFIG_I2C_I801=y
# CONFIG_I2C_ISCH is not set
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
CONFIG_I2C_SCMI=y

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_SIMTEC is not set
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_PCA_ISA is not set
# CONFIG_I2C_STUB is not set
# CONFIG_SCx200_ACB is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
# CONFIG_SPI_BITBANG is not set
# CONFIG_SPI_XILINX is not set
# CONFIG_SPI_DESIGNWARE is not set

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
# CONFIG_SPI_TLE62X0 is not set

#
# PPS support
#
# CONFIG_PPS is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
# CONFIG_GPIOLIB is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_DS2760 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_MAX17040 is not set
CONFIG_HWMON=y
# CONFIG_HWMON_VID is not set
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7414 is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADCXX is not set
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_ADT7411 is not set
# CONFIG_SENSORS_ADT7462 is not set
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7475 is not set
# CONFIG_SENSORS_ASC7621 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_G760A is not set
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
CONFIG_SENSORS_CORETEMP=y
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM70 is not set
# CONFIG_SENSORS_LM73 is not set
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_LTC4215 is not set
# CONFIG_SENSORS_LTC4245 is not set
# CONFIG_SENSORS_LM95241 is not set
# CONFIG_SENSORS_MAX1111 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_EMC1403 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_ADS7871 is not set
# CONFIG_SENSORS_AMC6821 is not set
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_TMP102 is not set
# CONFIG_SENSORS_TMP401 is not set
# CONFIG_SENSORS_TMP421 is not set
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83L786NG is not set
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_SENSORS_LIS3_I2C is not set
CONFIG_SENSORS_APPLESMC=y

#
# ACPI drivers
#
# CONFIG_SENSORS_ATK0110 is not set
# CONFIG_SENSORS_LIS3LV02D is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set
CONFIG_MFD_SUPPORT=y
# CONFIG_MFD_CORE is not set
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_TPS6507X is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_MFD_TC35892 is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_MFD_MC13783 is not set
# CONFIG_ABX500_CORE is not set
# CONFIG_EZX_PCAP is not set
# CONFIG_AB8500_CORE is not set
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_REGULATOR is not set
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
CONFIG_VIDEO_DEV=m
CONFIG_VIDEO_V4L2_COMMON=m
CONFIG_VIDEO_ALLOW_V4L1=y
CONFIG_VIDEO_V4L1_COMPAT=y
# CONFIG_DVB_CORE is not set
CONFIG_VIDEO_MEDIA=m

#
# Multimedia drivers
#
CONFIG_IR_CORE=y
CONFIG_VIDEO_IR=y
# CONFIG_RC_MAP is not set
# CONFIG_IR_NEC_DECODER is not set
# CONFIG_IR_RC5_DECODER is not set
# CONFIG_IR_RC6_DECODER is not set
# CONFIG_IR_JVC_DECODER is not set
# CONFIG_IR_SONY_DECODER is not set
# CONFIG_IR_IMON is not set
# CONFIG_MEDIA_ATTACH is not set
CONFIG_MEDIA_TUNER=m
# CONFIG_MEDIA_TUNER_CUSTOMISE is not set
CONFIG_MEDIA_TUNER_SIMPLE=m
CONFIG_MEDIA_TUNER_TDA8290=m
CONFIG_MEDIA_TUNER_TDA9887=m
CONFIG_MEDIA_TUNER_TEA5761=m
CONFIG_MEDIA_TUNER_TEA5767=m
CONFIG_MEDIA_TUNER_MT20XX=m
CONFIG_MEDIA_TUNER_XC2028=m
CONFIG_MEDIA_TUNER_XC5000=m
CONFIG_MEDIA_TUNER_MC44S803=m
CONFIG_VIDEO_V4L2=m
CONFIG_VIDEO_V4L1=m
CONFIG_VIDEO_CAPTURE_DRIVERS=y
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_VIDEO_HELPER_CHIPS_AUTO=y
CONFIG_VIDEO_IR_I2C=m
# CONFIG_VIDEO_BT848 is not set
# CONFIG_VIDEO_PMS is not set
# CONFIG_VIDEO_CPIA is not set
# CONFIG_VIDEO_CPIA2 is not set
# CONFIG_VIDEO_SAA5246A is not set
# CONFIG_VIDEO_SAA5249 is not set
# CONFIG_VIDEO_STRADIS is not set
# CONFIG_VIDEO_ZORAN is not set
# CONFIG_VIDEO_SAA7134 is not set
# CONFIG_VIDEO_MXB is not set
# CONFIG_VIDEO_HEXIUM_ORION is not set
# CONFIG_VIDEO_HEXIUM_GEMINI is not set
# CONFIG_VIDEO_CX88 is not set
# CONFIG_VIDEO_IVTV is not set
# CONFIG_VIDEO_CAFE_CCIC is not set
# CONFIG_SOC_CAMERA is not set
CONFIG_V4L_USB_DRIVERS=y
CONFIG_USB_VIDEO_CLASS=m
# CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV is not set
# CONFIG_USB_GSPCA is not set
# CONFIG_VIDEO_PVRUSB2 is not set
# CONFIG_VIDEO_HDPVR is not set
# CONFIG_VIDEO_EM28XX is not set
# CONFIG_VIDEO_CX231XX is not set
# CONFIG_VIDEO_USBVISION is not set
CONFIG_VIDEO_USBVIDEO=m
# CONFIG_USB_VICAM is not set
# CONFIG_USB_IBMCAM is not set
# CONFIG_USB_KONICAWC is not set
CONFIG_USB_QUICKCAM_MESSENGER=m
# CONFIG_USB_ET61X251 is not set
# CONFIG_VIDEO_OVCAMCHIP is not set
# CONFIG_USB_OV511 is not set
# CONFIG_USB_SE401 is not set
# CONFIG_USB_SN9C102 is not set
# CONFIG_USB_STV680 is not set
# CONFIG_USB_ZC0301 is not set
# CONFIG_USB_PWC is not set
# CONFIG_USB_ZR364XX is not set
# CONFIG_USB_STKWEBCAM is not set
# CONFIG_USB_S2255 is not set
# CONFIG_V4L_MEM2MEM_DRIVERS is not set
# CONFIG_RADIO_ADAPTERS is not set
# CONFIG_DAB is not set

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=2
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=y
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_TTM=y
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
CONFIG_DRM_RADEON=y
CONFIG_DRM_RADEON_KMS=y
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
CONFIG_FB_DDC=y
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
# CONFIG_FB_SYS_FILLRECT is not set
# CONFIG_FB_SYS_COPYAREA is not set
# CONFIG_FB_SYS_IMAGEBLIT is not set
# CONFIG_FB_FOREIGN_ENDIAN is not set
# CONFIG_FB_SYS_FOPS is not set
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
# CONFIG_FB_TILEBLITTING is not set

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
# CONFIG_FB_VESA is not set
CONFIG_FB_EFI=y
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_MATROX is not set
CONFIG_FB_RADEON=y
CONFIG_FB_RADEON_I2C=y
CONFIG_FB_RADEON_BACKLIGHT=y
# CONFIG_FB_RADEON_DEBUG is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
# CONFIG_LCD_LTV350QV is not set
# CONFIG_LCD_TDO24M is not set
# CONFIG_LCD_VGG2432A4 is not set
CONFIG_LCD_PLATFORM=y
# CONFIG_LCD_S6E63M0 is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_GENERIC is not set
# CONFIG_BACKLIGHT_PROGEAR is not set
# CONFIG_BACKLIGHT_MBP_NVIDIA is not set
# CONFIG_BACKLIGHT_SAHARA is not set
# CONFIG_BACKLIGHT_ADP8860 is not set

#
# Display device support
#
CONFIG_DISPLAY_SUPPORT=y

#
# Display hardware drivers
#

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
# CONFIG_MDA_CONSOLE is not set
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
# CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY is not set
# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_SEQUENCER=y
# CONFIG_SND_SEQ_DUMMY is not set
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=y
CONFIG_SND_PCM_OSS=y
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_SEQUENCER_OSS=y
CONFIG_SND_HRTIMER=y
CONFIG_SND_SEQ_HRTIMER_DEFAULT=y
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_SUPPORT_OLD_API=y
# CONFIG_SND_VERBOSE_PROCFS is not set
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_DMA_SGBUF=y
# CONFIG_SND_RAWMIDI_SEQ is not set
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
# CONFIG_SND_DRIVERS is not set
CONFIG_SND_ISA=y
# CONFIG_SND_ADLIB is not set
# CONFIG_SND_AD1816A is not set
# CONFIG_SND_AD1848 is not set
# CONFIG_SND_ALS100 is not set
# CONFIG_SND_AZT2320 is not set
# CONFIG_SND_CMI8330 is not set
# CONFIG_SND_CS4231 is not set
# CONFIG_SND_CS4236 is not set
# CONFIG_SND_ES1688 is not set
# CONFIG_SND_ES18XX is not set
# CONFIG_SND_SC6000 is not set
# CONFIG_SND_GUSCLASSIC is not set
# CONFIG_SND_GUSEXTREME is not set
# CONFIG_SND_GUSMAX is not set
# CONFIG_SND_INTERWAVE is not set
# CONFIG_SND_INTERWAVE_STB is not set
# CONFIG_SND_JAZZ16 is not set
# CONFIG_SND_OPL3SA2 is not set
# CONFIG_SND_OPTI92X_AD1848 is not set
# CONFIG_SND_OPTI92X_CS4231 is not set
# CONFIG_SND_OPTI93X is not set
# CONFIG_SND_MIRO is not set
# CONFIG_SND_SB8 is not set
# CONFIG_SND_SB16 is not set
# CONFIG_SND_SBAWE is not set
# CONFIG_SND_SGALAXY is not set
# CONFIG_SND_SSCAPE is not set
# CONFIG_SND_WAVEFRONT is not set
# CONFIG_SND_MSND_PINNACLE is not set
# CONFIG_SND_MSND_CLASSIC is not set
CONFIG_SND_PCI=y
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
# CONFIG_SND_ALI5451 is not set
# CONFIG_SND_ASIHPI is not set
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AW2 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_OXYGEN is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_CS5530 is not set
# CONFIG_SND_CS5535AUDIO is not set
# CONFIG_SND_CTXFI is not set
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
# CONFIG_SND_INDIGOIOX is not set
# CONFIG_SND_INDIGODJX is not set
# CONFIG_SND_EMU10K1 is not set
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
CONFIG_SND_HDA_INTEL=y
# CONFIG_SND_HDA_HWDEP is not set
# CONFIG_SND_HDA_INPUT_BEEP is not set
# CONFIG_SND_HDA_INPUT_JACK is not set
# CONFIG_SND_HDA_PATCH_LOADER is not set
# CONFIG_SND_HDA_CODEC_REALTEK is not set
# CONFIG_SND_HDA_CODEC_ANALOG is not set
CONFIG_SND_HDA_CODEC_SIGMATEL=y
# CONFIG_SND_HDA_CODEC_VIA is not set
# CONFIG_SND_HDA_CODEC_ATIHDMI is not set
# CONFIG_SND_HDA_CODEC_NVHDMI is not set
CONFIG_SND_HDA_CODEC_INTELHDMI=y
CONFIG_SND_HDA_ELD=y
# CONFIG_SND_HDA_CODEC_CIRRUS is not set
# CONFIG_SND_HDA_CODEC_CONEXANT is not set
# CONFIG_SND_HDA_CODEC_CA0110 is not set
# CONFIG_SND_HDA_CODEC_CMEDIA is not set
# CONFIG_SND_HDA_CODEC_SI3054 is not set
CONFIG_SND_HDA_GENERIC=y
CONFIG_SND_HDA_POWER_SAVE=y
CONFIG_SND_HDA_POWER_SAVE_DEFAULT=15
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_HIFIER is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
# CONFIG_SND_INTEL8X0 is not set
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_LX6464ES is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SIS7019 is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set
CONFIG_SND_SPI=y
# CONFIG_SND_USB is not set
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
# CONFIG_HIDRAW is not set

#
# USB Input Devices
#
CONFIG_USB_HID=y
# CONFIG_HID_PID is not set
CONFIG_USB_HIDDEV=y

#
# Special HID drivers
#
# CONFIG_HID_3M_PCT is not set
CONFIG_HID_A4TECH=y
CONFIG_HID_APPLE=y
CONFIG_HID_BELKIN=y
# CONFIG_HID_CANDO is not set
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
# CONFIG_HID_PRODIKEYS is not set
CONFIG_HID_CYPRESS=y
CONFIG_HID_DRAGONRISE=y
# CONFIG_DRAGONRISE_FF is not set
# CONFIG_HID_EGALAX is not set
CONFIG_HID_EZKEY=y
CONFIG_HID_KYE=y
CONFIG_HID_GYRATION=y
CONFIG_HID_TWINHAN=y
CONFIG_HID_KENSINGTON=y
CONFIG_HID_LOGITECH=y
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
# CONFIG_LOGIG940_FF is not set
# CONFIG_HID_MAGICMOUSE is not set
CONFIG_HID_MICROSOFT=y
# CONFIG_HID_MOSART is not set
CONFIG_HID_MONTEREY=y
CONFIG_HID_NTRIG=y
CONFIG_HID_ORTEK=y
CONFIG_HID_PANTHERLORD=y
# CONFIG_PANTHERLORD_FF is not set
CONFIG_HID_PETALYNX=y
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_QUANTA is not set
# CONFIG_HID_ROCCAT is not set
# CONFIG_HID_ROCCAT_KONE is not set
CONFIG_HID_SAMSUNG=y
CONFIG_HID_SONY=y
# CONFIG_HID_STANTUM is not set
CONFIG_HID_SUNPLUS=y
CONFIG_HID_GREENASIA=y
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_SMARTJOYPLUS=y
# CONFIG_SMARTJOYPLUS_FF is not set
CONFIG_HID_TOPSEED=y
CONFIG_HID_THRUSTMASTER=y
# CONFIG_THRUSTMASTER_FF is not set
CONFIG_HID_WACOM=y
# CONFIG_HID_WACOM_POWER_SUPPLY is not set
CONFIG_HID_ZEROPLUS=y
# CONFIG_ZEROPLUS_FF is not set
# CONFIG_HID_ZYDACRON is not set
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
# CONFIG_USB_DEVICEFS is not set
CONFIG_USB_DEVICE_CLASS=y
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_SUSPEND is not set
CONFIG_USB_MON=y
# CONFIG_USB_WUSB is not set
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
# CONFIG_USB_XHCI_HCD is not set
CONFIG_USB_EHCI_HCD=y
# CONFIG_USB_EHCI_ROOT_HUB_TT is not set
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
# CONFIG_USB_ISP1362_HCD is not set
# CONFIG_USB_OHCI_HCD is not set
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_WHCI_HCD is not set
# CONFIG_USB_HWA_HCD is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
CONFIG_USB_PRINTER=y
# CONFIG_USB_WDM is not set
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=y
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_DATAFAB is not set
# CONFIG_USB_STORAGE_FREECOM is not set
# CONFIG_USB_STORAGE_ISD200 is not set
# CONFIG_USB_STORAGE_USBAT is not set
# CONFIG_USB_STORAGE_SDDR09 is not set
# CONFIG_USB_STORAGE_SDDR55 is not set
# CONFIG_USB_STORAGE_JUMPSHOT is not set
# CONFIG_USB_STORAGE_ALAUDA is not set
# CONFIG_USB_STORAGE_ONETOUCH is not set
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set

#
# USB port drivers
#
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
CONFIG_USB_APPLEDISPLAY=m
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
CONFIG_USB_ISIGHTFW=m
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_UWB is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_ALIX2 is not set
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_LP3944 is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_DAC124S085 is not set
# CONFIG_LEDS_BD2802 is not set
# CONFIG_LEDS_INTEL_SS4200 is not set
CONFIG_LEDS_TRIGGERS=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGER_TIMER=y
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_DS1307 is not set
# CONFIG_RTC_DRV_DS1374 is not set
# CONFIG_RTC_DRV_DS1672 is not set
# CONFIG_RTC_DRV_MAX6900 is not set
# CONFIG_RTC_DRV_RS5C372 is not set
# CONFIG_RTC_DRV_ISL1208 is not set
# CONFIG_RTC_DRV_X1205 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
# CONFIG_RTC_DRV_PCF8583 is not set
# CONFIG_RTC_DRV_M41T80 is not set
# CONFIG_RTC_DRV_BQ32K is not set
# CONFIG_RTC_DRV_S35390A is not set
# CONFIG_RTC_DRV_FM3130 is not set
# CONFIG_RTC_DRV_RX8581 is not set
# CONFIG_RTC_DRV_RX8025 is not set

#
# SPI RTC drivers
#
# CONFIG_RTC_DRV_M41T94 is not set
# CONFIG_RTC_DRV_DS1305 is not set
# CONFIG_RTC_DRV_DS1390 is not set
# CONFIG_RTC_DRV_MAX6902 is not set
# CONFIG_RTC_DRV_R9701 is not set
# CONFIG_RTC_DRV_RS5C348 is not set
# CONFIG_RTC_DRV_DS3234 is not set
# CONFIG_RTC_DRV_PCF2123 is not set

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
# CONFIG_RTC_DRV_DS1286 is not set
# CONFIG_RTC_DRV_DS1511 is not set
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_DS1742 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T35 is not set
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_MSM6242 is not set
# CONFIG_RTC_DRV_BQ4802 is not set
# CONFIG_RTC_DRV_RP5C01 is not set
# CONFIG_RTC_DRV_V3020 is not set

#
# on-CPU RTC drivers
#
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
CONFIG_ASYNC_TX_DISABLE_CHANNEL_SWITCH=y
CONFIG_INTEL_IOATDMA=y
# CONFIG_TIMB_DMA is not set
CONFIG_DMA_ENGINE=y

#
# DMA Clients
#
CONFIG_NET_DMA=y
CONFIG_ASYNC_TX_DMA=y
# CONFIG_DMATEST is not set
CONFIG_DCA=y
# CONFIG_AUXDISPLAY is not set
# CONFIG_UIO is not set
# CONFIG_STAGING is not set
# CONFIG_X86_PLATFORM_DEVICES is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_EFI_VARS=y
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y
# CONFIG_ISCSI_IBFT_FIND is not set

#
# File systems
#
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
# CONFIG_EXT2_FS_POSIX_ACL is not set
# CONFIG_EXT2_FS_SECURITY is not set
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=y
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
CONFIG_EXT3_FS_XATTR=y
# CONFIG_EXT3_FS_POSIX_ACL is not set
# CONFIG_EXT3_FS_SECURITY is not set
CONFIG_EXT4_FS=y
CONFIG_EXT4_FS_XATTR=y
# CONFIG_EXT4_FS_POSIX_ACL is not set
# CONFIG_EXT4_FS_SECURITY is not set
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_FS_POSIX_ACL=y
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_BTRFS_FS is not set
# CONFIG_NILFS2_FS is not set
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_QUOTA is not set
# CONFIG_AUTOFS_FS is not set
# CONFIG_AUTOFS4_FS is not set
CONFIG_FUSE_FS=m
# CONFIG_CUSE is not set

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-15"
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
# CONFIG_CONFIGFS_FS is not set
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_HFS_FS is not set
CONFIG_HFSPLUS_FS=m
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_LOGFS is not set
# CONFIG_CRAMFS is not set
CONFIG_SQUASHFS=y
# CONFIG_SQUASHFS_XATTRS is not set
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_ROMFS_FS is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=m
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
# CONFIG_NFS_V4 is not set
CONFIG_NFSD=m
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_V3_ACL=y
# CONFIG_NFSD_V4 is not set
CONFIG_LOCKD=m
CONFIG_LOCKD_V4=y
CONFIG_EXPORTFS=m
CONFIG_NFS_ACL_SUPPORT=m
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=m
# CONFIG_RPCSEC_GSS_KRB5 is not set
# CONFIG_RPCSEC_GSS_SPKM3 is not set
CONFIG_SMB_FS=m
# CONFIG_SMB_NLS_DEFAULT is not set
# CONFIG_CEPH_FS is not set
CONFIG_CIFS=m
# CONFIG_CIFS_STATS is not set
# CONFIG_CIFS_WEAK_PW_HASH is not set
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_EXPERIMENTAL is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_OSF_PARTITION is not set
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
# CONFIG_MINIX_SUBPARTITION is not set
# CONFIG_SOLARIS_X86_PARTITION is not set
# CONFIG_UNIXWARE_DISKLABEL is not set
# CONFIG_LDM_PARTITION is not set
# CONFIG_SGI_PARTITION is not set
# CONFIG_ULTRIX_PARTITION is not set
# CONFIG_SUN_PARTITION is not set
# CONFIG_KARMA_PARTITION is not set
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_CODEPAGE_437=m
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
CONFIG_NLS_CODEPAGE_850=m
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
CONFIG_NLS_CODEPAGE_1250=m
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=y
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_UTF8=y
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
# CONFIG_PRINTK_TIME is not set
# CONFIG_ENABLE_WARN_DEPRECATED is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=0
CONFIG_MAGIC_SYSRQ=y
# CONFIG_STRIP_ASM_SYMS is not set
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
CONFIG_DETECT_SOFTLOCKUP=y
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_DETECT_HUNG_TASK=y
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_PREEMPT is not set
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
# CONFIG_PROVE_LOCKING is not set
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_LOCKDEP is not set
# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_HIGHMEM=y
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_INFO is not set
CONFIG_DEBUG_VM=y
CONFIG_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_RCU_CPU_STALL_DETECTOR is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# CONFIG_LKDTM is not set
# CONFIG_CPU_NOTIFIER_ERROR_INJECT is not set
# CONFIG_FAULT_INJECTION is not set
CONFIG_LATENCYTOP=y
# CONFIG_SYSCTL_SYSCALL_CHECK is not set
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_FIREWIRE_OHCI_REMOTE_DMA is not set
# CONFIG_DYNAMIC_DEBUG is not set
CONFIG_DMA_API_DEBUG=y
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_KMEMCHECK is not set
CONFIG_STRICT_DEVMEM=y
# CONFIG_X86_VERBOSE_BOOTUP is not set
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
# CONFIG_DEBUG_RODATA_TEST is not set
# CONFIG_DEBUG_NX_TEST is not set
# CONFIG_4KSTACKS is not set
CONFIG_DOUBLEFAULT=y
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
CONFIG_IO_DELAY_NONE=y
CONFIG_DEFAULT_IO_DELAY_TYPE=3
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set

#
# Security options
#
# CONFIG_KEYS is not set
# CONFIG_SECURITY is not set
CONFIG_SECURITYFS=y
# CONFIG_DEFAULT_SECURITY_SELINUX is not set
# CONFIG_DEFAULT_SECURITY_SMACK is not set
# CONFIG_DEFAULT_SECURITY_TOMOYO is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_ASYNC_TX_DISABLE_PQ_VAL_DMA=y
CONFIG_ASYNC_TX_DISABLE_XOR_VAL_DMA=y
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=m
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_GF128MUL is not set
# CONFIG_CRYPTO_NULL is not set
# CONFIG_CRYPTO_PCRYPT is not set
CONFIG_CRYPTO_WORKQUEUE=y
# CONFIG_CRYPTO_CRYPTD is not set
CONFIG_CRYPTO_AUTHENC=m
# CONFIG_CRYPTO_TEST is not set

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
# CONFIG_CRYPTO_GCM is not set
# CONFIG_CRYPTO_SEQIV is not set

#
# Block modes
#
CONFIG_CRYPTO_CBC=m
# CONFIG_CRYPTO_CTR is not set
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=y
# CONFIG_CRYPTO_LRW is not set
# CONFIG_CRYPTO_PCBC is not set
# CONFIG_CRYPTO_XTS is not set

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y
# CONFIG_CRYPTO_XCBC is not set
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
# CONFIG_CRYPTO_CRC32C_INTEL is not set
# CONFIG_CRYPTO_GHASH is not set
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=m
CONFIG_CRYPTO_MICHAEL_MIC=m
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=m
CONFIG_CRYPTO_SHA256=m
CONFIG_CRYPTO_SHA512=m
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_WP512 is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_586 is not set
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=m
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAST5=m
# CONFIG_CRYPTO_CAST6 is not set
CONFIG_CRYPTO_DES=m
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_586 is not set
# CONFIG_CRYPTO_SEED is not set
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_TEA is not set
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
# CONFIG_CRYPTO_TWOFISH_586 is not set

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=m
# CONFIG_CRYPTO_ZLIB is not set
# CONFIG_CRYPTO_LZO is not set

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
# CONFIG_CRYPTO_HW is not set
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_APIC_ARCHITECTURE=y
CONFIG_KVM_MMIO=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=y
CONFIG_KVM_INTEL=y
# CONFIG_KVM_AMD is not set
CONFIG_VHOST_NET=y
# CONFIG_LGUEST is not set
CONFIG_VIRTIO=y
CONFIG_VIRTIO_RING=y
CONFIG_VIRTIO_PCI=y
CONFIG_VIRTIO_BALLOON=y
# CONFIG_BINARY_PRINTF is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_GENERIC_FIND_LAST_BIT=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=m
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=y
CONFIG_TEXTSEARCH_BM=y
CONFIG_TEXTSEARCH_FSM=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_NLATTR=y

--------------090708000208020402030405--

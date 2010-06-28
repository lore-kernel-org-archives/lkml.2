Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075Ab0F1Avu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jun 2010 20:51:50 -0400
Received: from smtp107.rog.mail.re2.yahoo.com ([68.142.225.205]:23148 "HELO
	smtp107.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751854Ab0F1Avr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jun 2010 20:51:47 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Sun, 27 Jun 2010 20:51:47 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=rogers.com;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:Organization:To:Subject:Date:User-Agent:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=UpIaFkyRyjeXRJ4YMiXEgLTzJIEksddGhPaqMmAE++6q0SS7kM1Jc5uWBC/LVESyBQwsnHCS1CoY9WyK3h7beFZLS1hMx5z+FlgyvlHAt+LeB27/u0QAn1TdGLHM2DxnTA8cvq0d7ObvDfA5nUt6Q/KNQp7J+68oql3gnToVFOI=  ;
X-Yahoo-SMTP: rZzhDImswBA_40COIyZI42.8nAz5YXic.zo1v550XQVtX7k-
X-YMail-OSG: yJZRKOYVM1knb5n5zv3HNgHOuGDQzTjfSQpYY2ZIjIP2BtVGMRCCFIPTiT5zUKgpxKpkS2x5EV0DV7_0WYkFXS47_9E7MT8J2DmtFyFVI6FE.f3B5eUDzaV0Eh0EZWwOLfMcOvvGQyLNvFs1lX1tErPrRVx9IOvPvFPCAGbhelz9F4gviUVTpQXaoj_yse6Hk34YlXhYAFwAmD52IUqg6_FUlyaIiCP3SqG1ZdHHteRJJS45x9X3adqagNURS68e3QxcWII7vyxXrxwgXfGVHx8fQQIUIQrle2hVH2g84FZMOqB0Fxrfvg4FvLdPsV93aHq3VA8PSG3ZHtkt_QBHvZK3JpRe6pIgShJFDOm5MD_B5hCDfTuQfnsk2m4SS8KXgaTc68YffgzPsAbisvjcZUTo3volHkyRQR8ZqJM0YIgTeFSdCWN46Ts.jup14K7L8he3pJzIEZjMzhKupVU-
X-Yahoo-Newman-Property: ymail-3
From: Shawn Starr <shawn.starr@rogers.com>
Organization: sh0n.net
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [REGRESSION][SUSPEND] 2.6.35-rcX won't suspend Lenovo W500 laptop
Date: Sun, 27 Jun 2010 20:45:16 -0400
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc3; KDE/4.4.90; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201006272045.17004.shawn.starr@rogers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Works fine with Fedora kernels 2.6.34-xx but seems broken on git snapshot kernels.


When suspending the moon icon on laptop flashes off/on, never actually suspends laptop. 


Will provide more info if requested.


I am using a Intel i965 (HD4500) w/ KMS mode enabled.


Thanks
Shawn.


dmesg Info:
===========


[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.35-rc3 (root@panic.sh0n.net) (gcc version 4.4.4 20100525 (Red Hat 4.4.4-6) (GCC) ) #1 SMP Fri Jun 25 22:47:07 EDT 2010
[    0.000000] Command line: ro root=/dev/mapper/vg_segfault-lv_root  LANG=en_US.UTF-8 SYSFONT=latarcyrheb-sun16 KEYBOARDTYPE=pc KEYTABLE=us rhgb quiet slub_debug=- prink.time=1 cgroup_disable=memory intel_iommu=off
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009ec00 (usable)
[    0.000000]  BIOS-e820: 000000000009ec00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bd4a1000 (usable)
[    0.000000]  BIOS-e820: 00000000bd4a1000 - 00000000bd4a7000 (reserved)
[    0.000000]  BIOS-e820: 00000000bd4a7000 - 00000000bd5b7000 (usable)
[    0.000000]  BIOS-e820: 00000000bd5b7000 - 00000000bd60f000 (reserved)
[    0.000000]  BIOS-e820: 00000000bd60f000 - 00000000bd6c6000 (usable)
[    0.000000]  BIOS-e820: 00000000bd6c6000 - 00000000bd6d1000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bd6d1000 - 00000000bd6d4000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bd6d4000 - 00000000bd6d8000 (reserved)
[    0.000000]  BIOS-e820: 00000000bd6d8000 - 00000000bd6dc000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bd6dc000 - 00000000bd6df000 (reserved)
[    0.000000]  BIOS-e820: 00000000bd6df000 - 00000000bd706000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bd706000 - 00000000bd708000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bd708000 - 00000000bd90f000 (reserved)
[    0.000000]  BIOS-e820: 00000000bd90f000 - 00000000bd99f000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bd99f000 - 00000000bd9ff000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bd9ff000 - 00000000bda00000 (usable)
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
[    0.000000] e820 update range: 0000000000000000 - 0000000000001000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x13c000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 13C000000 mask FFC000000 uncachable
[    0.000000]   1 base 0BE000000 mask FFE000000 uncachable
[    0.000000]   2 base 000000000 mask F80000000 write-back
[    0.000000]   3 base 080000000 mask FC0000000 write-back
[    0.000000]   4 base 100000000 mask FC0000000 write-back
[    0.000000]   5 base 0BDE00000 mask FFFE00000 uncachable
[    0.000000]   6 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] original variable MTRRs
[    0.000000] reg 0, base: 5056MB, range: 64MB, type UC
[    0.000000] reg 1, base: 3040MB, range: 32MB, type UC
[    0.000000] reg 2, base: 0GB, range: 2GB, type WB
[    0.000000] reg 3, base: 2GB, range: 1GB, type WB
[    0.000000] reg 4, base: 4GB, range: 1GB, type WB
[    0.000000] reg 5, base: 3038MB, range: 2MB, type UC
[    0.000000] total RAM covered: 3998M
[    0.000000] Found optimal setting for mtrr clean up
[    0.000000]  gran_size: 64K  chunk_size: 128M        num_reg: 6      lose cover RAM: 0G
[    0.000000] New variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 2GB, type WB
[    0.000000] reg 1, base: 2GB, range: 1GB, type WB
[    0.000000] reg 2, base: 3038MB, range: 2MB, type UC
[    0.000000] reg 3, base: 3040MB, range: 32MB, type UC
[    0.000000] reg 4, base: 4GB, range: 1GB, type WB
[    0.000000] reg 5, base: 5056MB, range: 64MB, type UC
[    0.000000] e820 update range: 00000000bde00000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xbda00 max_arch_pfn = 0x400000000
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] found SMP MP-table at [ffff8800000f6480] f6480
[    0.000000] init_memory_mapping: 0000000000000000-00000000bda00000
[    0.000000]  0000000000 - 00bda00000 page 2M
[    0.000000] kernel direct mapping tables up to bda00000 @ 8000-c000
[    0.000000] init_memory_mapping: 0000000100000000-000000013c000000
[    0.000000]  0100000000 - 013c000000 page 2M
[    0.000000] kernel direct mapping tables up to 13c000000 @ a000-10000
[    0.000000] RAMDISK: 37a5b000 - 37ff0000
[    0.000000] ACPI: RSDP 00000000000f6440 00024 (v02 LENOVO)
[    0.000000] ACPI: XSDT 00000000bd949b7a 0009C (v01 LENOVO TP-6F    00003130  LTP 00000000)
[    0.000000] ACPI: FACP 00000000bd949d00 000F4 (v03 LENOVO TP-6F    00003130 LNVO 00000001)
[    0.000000] ACPI: DSDT 00000000bd94a10e 0FAC1 (v01 LENOVO TP-6F    00003130 MSFT 03000000)
[    0.000000] ACPI: FACS 00000000bd98e000 00040
[    0.000000] ACPI: SSDT 00000000bd949eb4 0025A (v01 LENOVO TP-6F    00003130 MSFT 03000000)
[    0.000000] ACPI: ECDT 00000000bd959bcf 00052 (v01 LENOVO TP-6F    00003130 LNVO 00000001)
[    0.000000] ACPI: APIC 00000000bd959c21 00078 (v01 LENOVO TP-6F    00003130 LNVO 00000001)
[    0.000000] ACPI: MCFG 00000000bd959c99 0003C (v01 LENOVO TP-6F    00003130 LNVO 00000001)
[    0.000000] ACPI: HPET 00000000bd959cd5 00038 (v01 LENOVO TP-6F    00003130 LNVO 00000001)
[    0.000000] ACPI: SLIC 00000000bd959dc2 00176 (v01 LENOVO TP-6F    00003130  LTP 00000000)
[    0.000000] ACPI: BOOT 00000000bd959f38 00028 (v01 LENOVO TP-6F    00003130  LTP 00000001)
[    0.000000] ACPI: ASF! 00000000bd959f60 000A0 (v16 LENOVO TP-6F    00003130 PTL  00000001)
[    0.000000] ACPI: SSDT 00000000bd98d1fa 00568 (v01 LENOVO TP-6F    00003130 INTL 20050513)
[    0.000000] ACPI: TCPA 00000000bd707000 00032 (v00                 00000000      00000000)
[    0.000000] ACPI: DMAR 00000000bd706000 00120 (v01               ? 00000001      00000000)
[    0.000000] ACPI: SSDT 00000000bd6d3000 00655 (v01  PmRef    CpuPm 00003000 INTL 20050624)
[    0.000000] ACPI: SSDT 00000000bd6d2000 00274 (v01  PmRef  Cpu0Tst 00003000 INTL 20050624)
[    0.000000] ACPI: SSDT 00000000bd6d1000 00242 (v01  PmRef    ApTst 00003000 INTL 20050624)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000013c000000
[    0.000000] Initmem setup node 0 0000000000000000-000000013c000000
[    0.000000]   NODE_DATA [0000000100000000 - 0000000100013fff]
[    0.000000]  [ffffea0000000000-ffffea00045fffff] PMD -> [ffff880100200000-ffff8801039fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000001 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x0013c000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[6] active PFN ranges
[    0.000000]     0: 0x00000001 -> 0x0000009e
[    0.000000]     0: 0x00000100 -> 0x000bd4a1
[    0.000000]     0: 0x000bd4a7 -> 0x000bd5b7
[    0.000000]     0: 0x000bd60f -> 0x000bd6c6
[    0.000000]     0: 0x000bd9ff -> 0x000bda00
[    0.000000]     0: 0x00100000 -> 0x0013c000
[    0.000000] On node 0 totalpages: 1021446
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3941 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 757409 pages, LIFO batch:31
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
[    0.000000] SMP: Allowing 4 CPUs, 2 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] early_res array is doubled to 64 at [7000 - 77ff]
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 000000000009f000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000dc000
[    0.000000] PM: Registered nosave memory: 00000000000dc000 - 0000000000100000
[    0.000000] early_res array is doubled to 128 at [b000 - bfff]
[    0.000000] PM: Registered nosave memory: 00000000bd4a1000 - 00000000bd4a7000
[    0.000000] PM: Registered nosave memory: 00000000bd5b7000 - 00000000bd60f000
[    0.000000] PM: Registered nosave memory: 00000000bd6c6000 - 00000000bd6d1000
[    0.000000] PM: Registered nosave memory: 00000000bd6d1000 - 00000000bd6d4000
[    0.000000] PM: Registered nosave memory: 00000000bd6d4000 - 00000000bd6d8000
[    0.000000] PM: Registered nosave memory: 00000000bd6d8000 - 00000000bd6dc000
[    0.000000] PM: Registered nosave memory: 00000000bd6dc000 - 00000000bd6df000
[    0.000000] PM: Registered nosave memory: 00000000bd6df000 - 00000000bd706000
[    0.000000] PM: Registered nosave memory: 00000000bd706000 - 00000000bd708000
[    0.000000] PM: Registered nosave memory: 00000000bd708000 - 00000000bd90f000
[    0.000000] PM: Registered nosave memory: 00000000bd90f000 - 00000000bd99f000
[    0.000000] PM: Registered nosave memory: 00000000bd99f000 - 00000000bd9ff000
[    0.000000] PM: Registered nosave memory: 00000000bda00000 - 00000000bdc00000
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
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff880001a00000 s83776 r8192 d22720 u524288
[    0.000000] pcpu-alloc: s83776 r8192 d22720 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1003750
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: ro root=/dev/mapper/vg_segfault-lv_root  LANG=en_US.UTF-8 SYSFONT=latarcyrheb-sun16 KEYBOARDTYPE=pc KEYTABLE=us rhgb quiet slub_debug=- prink.time=1 cgroup_disable=memory intel_iommu=off
[    0.000000] Disabling memory control group subsystem
[    0.000000] Intel-IOMMU: disabled
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave/xrstor: enabled xstate_bv 0x3, cntxt size 0x240
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Subtract (79 early reservations)
[    0.000000]   #1 [0001000000 - 00018ed828]   TEXT DATA BSS
[    0.000000]   #2 [0037a5b000 - 0037ff0000]         RAMDISK
[    0.000000]   #3 [00018ee000 - 00018ee14c]             BRK
[    0.000000]   #4 [00000f6490 - 0000100000]   BIOS reserved
[    0.000000]   #5 [00000f6480 - 00000f6490]    MP-table mpf
[    0.000000]   #6 [000009ec00 - 000009f171]   BIOS reserved
[    0.000000]   #7 [000009f27d - 00000f6480]   BIOS reserved
[    0.000000]   #8 [000009f171 - 000009f27d]    MP-table mpc
[    0.000000]   #9 [0000001000 - 0000003000]      TRAMPOLINE
[    0.000000]   #10 [0000003000 - 0000007000]     ACPI WAKEUP
[    0.000000]   #11 [0000008000 - 000000a000]         PGTABLE
[    0.000000]   #12 [000000a000 - 000000b000]         PGTABLE
[    0.000000]   #13 [0100000000 - 0100014000]       NODE_DATA
[    0.000000]   #14 [00018ee180 - 00018ef180]         BOOTMEM
[    0.000000]   #15 [0100014000 - 0100014300]         BOOTMEM
[    0.000000]   #16 [0100015000 - 0100016000]         BOOTMEM
[    0.000000]   #17 [0100016000 - 0100017000]         BOOTMEM
[    0.000000]   #18 [0100200000 - 0103a00000]        MEMMAP 0
[    0.000000]   #19 [00018ef180 - 0001907180]         BOOTMEM
[    0.000000]   #20 [0001907180 - 000191f180]         BOOTMEM
[    0.000000]   #21 [000191f180 - 0001937180]         BOOTMEM
[    0.000000]   #22 [0001938000 - 0001939000]         BOOTMEM
[    0.000000]   #23 [00018ed840 - 00018ed881]         BOOTMEM
[    0.000000]   #24 [00018ed8c0 - 00018ed903]         BOOTMEM
[    0.000000]   #25 [00018ed940 - 00018edfd0]         BOOTMEM
[    0.000000]   #26 [0001937180 - 00019371e8]         BOOTMEM
[    0.000000]   #27 [0001937200 - 0001937268]         BOOTMEM
[    0.000000]   #28 [0001937280 - 00019372e8]         BOOTMEM
[    0.000000]   #29 [0001937300 - 0001937368]         BOOTMEM
[    0.000000]   #30 [0001937380 - 00019373e8]         BOOTMEM
[    0.000000]   #31 [0001937400 - 0001937468]         BOOTMEM
[    0.000000]   #32 [0001937480 - 00019374e8]         BOOTMEM
[    0.000000]   #33 [0001937500 - 0001937568]         BOOTMEM
[    0.000000]   #34 [0001937580 - 00019375e8]         BOOTMEM
[    0.000000]   #35 [0001937600 - 0001937668]         BOOTMEM
[    0.000000]   #36 [0001937680 - 00019376e8]         BOOTMEM
[    0.000000]   #37 [0001937700 - 0001937768]         BOOTMEM
[    0.000000]   #38 [0001937780 - 00019377e8]         BOOTMEM
[    0.000000]   #39 [0001937800 - 0001937868]         BOOTMEM
[    0.000000]   #40 [0001937880 - 00019378e8]         BOOTMEM
[    0.000000]   #41 [0001937900 - 0001937968]         BOOTMEM
[    0.000000]   #42 [0001937980 - 00019379e8]         BOOTMEM
[    0.000000]   #43 [0001937a00 - 0001937a68]         BOOTMEM
[    0.000000]   #44 [0001937a80 - 0001937ae8]         BOOTMEM
[    0.000000]   #45 [0001937b00 - 0001937b68]         BOOTMEM
[    0.000000]   #46 [0001937b80 - 0001937be8]         BOOTMEM
[    0.000000]   #47 [0001937c00 - 0001937c68]         BOOTMEM
[    0.000000]   #48 [0001937c80 - 0001937ce8]         BOOTMEM
[    0.000000]   #49 [0001937d00 - 0001937d68]         BOOTMEM
[    0.000000]   #50 [0001937d80 - 0001937de8]         BOOTMEM
[    0.000000]   #51 [0001937e00 - 0001937e68]         BOOTMEM
[    0.000000]   #52 [0001937e80 - 0001937ee8]         BOOTMEM
[    0.000000]   #53 [0001937f00 - 0001937f68]         BOOTMEM
[    0.000000]   #54 [0001937f80 - 0001937fe8]         BOOTMEM
[    0.000000]   #55 [0001939000 - 0001939020]         BOOTMEM
[    0.000000]   #56 [0001939040 - 0001939060]         BOOTMEM
[    0.000000]   #57 [0001939080 - 00019390a0]         BOOTMEM
[    0.000000]   #58 [00019390c0 - 00019390e0]         BOOTMEM
[    0.000000]   #59 [0001939100 - 0001939120]         BOOTMEM
[    0.000000]   #60 [0001939140 - 00019391fb]         BOOTMEM
[    0.000000]   #61 [0001939200 - 00019392bb]         BOOTMEM
[    0.000000]   #62 [0001a00000 - 0001a1c000]         BOOTMEM
[    0.000000]   #63 [0001a80000 - 0001a9c000]         BOOTMEM
[    0.000000]   #64 [0001b00000 - 0001b1c000]         BOOTMEM
[    0.000000]   #65 [0001b80000 - 0001b9c000]         BOOTMEM
[    0.000000]   #66 [000193b2c0 - 000193b2c8]         BOOTMEM
[    0.000000]   #67 [000193b300 - 000193b308]         BOOTMEM
[    0.000000]   #68 [000193b340 - 000193b350]         BOOTMEM
[    0.000000]   #69 [000193b380 - 000193b3a0]         BOOTMEM
[    0.000000]   #70 [000193b3c0 - 000193b4f0]         BOOTMEM
[    0.000000]   #71 [000193b500 - 000193b550]         BOOTMEM
[    0.000000]   #72 [000193b580 - 000193b5d0]         BOOTMEM
[    0.000000]   #73 [000193b600 - 0001943600]         BOOTMEM
[    0.000000]   #74 [00019392c0 - 0001939500]         BOOTMEM
[    0.000000]   #75 [0001b9c000 - 0005b9c000]         BOOTMEM
[    0.000000]   #76 [0001943600 - 0001963600]         BOOTMEM
[    0.000000]   #77 [0001963600 - 00019a3600]         BOOTMEM
[    0.000000]   #78 [000000c000 - 0000014000]         BOOTMEM
[    0.000000] Memory: 3946712k/5177344k available (3976k kernel code, 1091560k absent, 139072k reserved, 3539k data, 692k init)
[    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000]  RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000]  RCU-based detection of stalled CPUs is disabled.
[    0.000000]  Verbose stalled-CPUs detection is disabled.
[    0.000000] NR_IRQS:4352 nr_irqs:712
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2527.231 MHz processor.
[    0.001007] Calibrating delay loop (skipped), value calculated using timer frequency.. 5054.46 BogoMIPS (lpj=2527231)
[    0.001010] pid_max: default: 32768 minimum: 301
[    0.001031] Security Framework initialized
[    0.001040] SELinux:  Initializing.
[    0.001048] SELinux:  Starting in permissive mode
[    0.001348] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.003617] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.004573] Mount-cache hash table entries: 256
[    0.004732] Initializing cgroup subsys ns
[    0.004736] Initializing cgroup subsys cpuacct
[    0.004740] Initializing cgroup subsys memory
[    0.004751] Initializing cgroup subsys devices
[    0.004753] Initializing cgroup subsys freezer
[    0.004755] Initializing cgroup subsys net_cls
[    0.004757] Initializing cgroup subsys blkio
[    0.004788] CPU: Physical Processor ID: 0
[    0.004789] CPU: Processor Core ID: 0
[    0.004791] mce: CPU supports 6 MCE banks
[    0.004798] CPU0: Thermal monitoring enabled (TM2)
[    0.004801] using mwait in idle threads.
[    0.004802] Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
[    0.004809] ... version:                2
[    0.004810] ... bit width:              40
[    0.004811] ... generic registers:      2
[    0.004813] ... value mask:             000000ffffffffff
[    0.004814] ... max period:             000000007fffffff
[    0.004815] ... fixed-purpose events:   3
[    0.004817] ... event mask:             0000000700000003
[    0.005718] ACPI: Core revision 20100428
[    0.024084] DMAR: Host address width 36
[    0.024086] DMAR: DRHD base: 0x000000feb03000 flags: 0x0
[    0.024092] IOMMU 0: reg_base_addr feb03000 ver 1:0 cap c9008020e30260 ecap 1000
[    0.024095] DMAR: DRHD base: 0x000000feb01000 flags: 0x0
[    0.024100] IOMMU 1: reg_base_addr feb01000 ver 1:0 cap c0000020630260 ecap 1000
[    0.024102] DMAR: DRHD base: 0x000000feb00000 flags: 0x0
[    0.024106] IOMMU 2: reg_base_addr feb00000 ver 1:0 cap c0000020630270 ecap 1000
[    0.024109] DMAR: DRHD base: 0x000000feb02000 flags: 0x1
[    0.024115] IOMMU 3: reg_base_addr feb02000 ver 1:0 cap c9008020630260 ecap 1000
[    0.024118] DMAR: RMRR base: 0x000000fc226c00 end: 0x000000fc2273ff
[    0.024120] DMAR: RMRR base: 0x000000bdc00000 end: 0x000000bfffffff
[    0.024122] DMAR: No ATSR found
[    0.025059] Setting APIC routing to flat
[    0.025403] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.035412] CPU0: Intel(R) Core(TM)2 Duo CPU     T9400  @ 2.53GHz stepping 0a
[    0.035999] Booting Node   0, Processors  #1
[    0.107012] Brought up 2 CPUs
[    0.107015] Total of 2 processors activated (10108.19 BogoMIPS).
[    0.108050] devtmpfs: initialized
[    0.110673] regulator: core version 0.5
[    0.110673] Time: 19:37:06  Date: 06/27/10
[    0.110673] NET: Registered protocol family 16
[    0.110673] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.110673] ACPI: bus type pci registered
[    0.110673] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xe0000000-0xe3ffffff] (base 0xe0000000)
[    0.110673] PCI: MMCONFIG at [mem 0xe0000000-0xe3ffffff] reserved in E820
[    0.120041] PCI: Using configuration type 1 for base access
[    0.121087] bio: create slab <bio-0> at 0
[    0.123578] ACPI: EC: EC description table is found, configuring boot EC
[    0.133954] ACPI: BIOS _OSI(Linux) query ignored
[    0.142605] ACPI: SSDT 00000000bd6d6c20 002C8 (v01  PmRef  Cpu0Ist 00003000 INTL 20050624)
[    0.143355] ACPI: Dynamic OEM Table Load:
[    0.143358] ACPI: SSDT (null) 002C8 (v01  PmRef  Cpu0Ist 00003000 INTL 20050624)
[    0.143751] ACPI: SSDT 00000000bd6d4020 0087A (v01  PmRef  Cpu0Cst 00003001 INTL 20050624)
[    0.144433] ACPI: Dynamic OEM Table Load:
[    0.144435] ACPI: SSDT (null) 0087A (v01  PmRef  Cpu0Cst 00003001 INTL 20050624)
[    0.144987] ACPI: SSDT 00000000bd6d5ca0 001CF (v01  PmRef    ApIst 00003000 INTL 20050624)
[    0.145654] ACPI: Dynamic OEM Table Load:
[    0.145657] ACPI: SSDT (null) 001CF (v01  PmRef    ApIst 00003000 INTL 20050624)
[    0.145832] ACPI: SSDT 00000000bd6d5f20 0008D (v01  PmRef    ApCst 00003000 INTL 20050624)
[    0.146476] ACPI: Dynamic OEM Table Load:
[    0.146478] ACPI: SSDT (null) 0008D (v01  PmRef    ApCst 00003000 INTL 20050624)
[    0.146610] ACPI: Interpreter enabled
[    0.146612] ACPI: (supports S0 S3 S4 S5)
[    0.146634] ACPI: Using IOAPIC for interrupt routing
[    0.156637] ACPI: EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
[    0.156684] ACPI: Power Resource [PUBS] (on)
[    0.159105] ACPI: ACPI Dock Station Driver: 3 docks/bays found
[    0.159108] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.159551] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.159602] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.159605] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.159607] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.159609] pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x000d3fff]
[    0.159611] pci_root PNP0A08:00: host bridge window [mem 0x000d4000-0x000d7fff]
[    0.159613] pci_root PNP0A08:00: host bridge window [mem 0x000d8000-0x000dbfff]
[    0.159616] pci_root PNP0A08:00: host bridge window [mem 0xc0000000-0xfebfffff]
[    0.159642] DMAR: Forcing write-buffer flush capability
[    0.159668] pci 0000:00:02.0: reg 10: [mem 0xf4400000-0xf47fffff 64bit]
[    0.159674] pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.159678] pci 0000:00:02.0: reg 20: [io  0x1800-0x1807]
[    0.159707] pci 0000:00:02.1: reg 10: [mem 0xf4200000-0xf42fffff 64bit]
[    0.159753] pci 0000:00:03.0: reg 10: [mem 0xfc226800-0xfc22680f 64bit]
[    0.159782] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.159785] pci 0000:00:03.0: PME# disabled
[    0.159865] pci 0000:00:19.0: reg 10: [mem 0xfc000000-0xfc01ffff]
[    0.159872] pci 0000:00:19.0: reg 14: [mem 0xfc025000-0xfc025fff]
[    0.159879] pci 0000:00:19.0: reg 18: [io  0x1840-0x185f]
[    0.159930] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.159934] pci 0000:00:19.0: PME# disabled
[    0.159992] pci 0000:00:1a.0: reg 20: [io  0x1860-0x187f]
[    0.160076] pci 0000:00:1a.1: reg 20: [io  0x1880-0x189f]
[    0.160157] pci 0000:00:1a.2: reg 20: [io  0x18a0-0x18bf]
[    0.160234] pci 0000:00:1a.7: reg 10: [mem 0xfc226c00-0xfc226fff]
[    0.160295] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.160300] pci 0000:00:1a.7: PME# disabled
[    0.160343] pci 0000:00:1b.0: reg 10: [mem 0xfc020000-0xfc023fff 64bit]
[    0.160399] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.160403] pci 0000:00:1b.0: PME# disabled
[    0.160492] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.160496] pci 0000:00:1c.0: PME# disabled
[    0.160588] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.160592] pci 0000:00:1c.1: PME# disabled
[    0.160687] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.160691] pci 0000:00:1c.3: PME# disabled
[    0.160783] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.160787] pci 0000:00:1c.4: PME# disabled
[    0.160853] pci 0000:00:1d.0: reg 20: [io  0x18c0-0x18df]
[    0.160935] pci 0000:00:1d.1: reg 20: [io  0x18e0-0x18ff]
[    0.161019] pci 0000:00:1d.2: reg 20: [io  0x1c00-0x1c1f]
[    0.161096] pci 0000:00:1d.7: reg 10: [mem 0xfc227000-0xfc2273ff]
[    0.161158] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.161163] pci 0000:00:1d.7: PME# disabled
[    0.161384] pci 0000:00:1f.2: reg 10: [io  0x1c48-0x1c4f]
[    0.161390] pci 0000:00:1f.2: reg 14: [io  0x183c-0x183f]
[    0.161397] pci 0000:00:1f.2: reg 18: [io  0x1c40-0x1c47]
[    0.161404] pci 0000:00:1f.2: reg 1c: [io  0x1838-0x183b]
[    0.161411] pci 0000:00:1f.2: reg 20: [io  0x1c20-0x1c3f]
[    0.161418] pci 0000:00:1f.2: reg 24: [mem 0xfc226000-0xfc2267ff]
[    0.161461] pci 0000:00:1f.2: PME# supported from D3hot
[    0.161465] pci 0000:00:1f.2: PME# disabled
[    0.161503] pci 0000:00:1f.3: reg 10: [mem 0xfc227400-0xfc2274ff 64bit]
[    0.161519] pci 0000:00:1f.3: reg 20: [io  0x1c60-0x1c7f]
[    0.161599] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.161604] pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.161609] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.161616] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.161732] pci 0000:03:00.0: reg 10: [mem 0xf4300000-0xf4301fff 64bit]
[    0.161843] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.161850] pci 0000:03:00.0: PME# disabled
[    0.161885] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.161889] pci 0000:00:1c.1:   bridge window [io  0xf000-0x0000] (disabled)
[    0.161894] pci 0000:00:1c.1:   bridge window [mem 0xf4300000-0xf43fffff]
[    0.161901] pci 0000:00:1c.1:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.161955] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    0.161960] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    0.161964] pci 0000:00:1c.3:   bridge window [mem 0xf8000000-0xf9ffffff]
[    0.161971] pci 0000:00:1c.3:   bridge window [mem 0xf4000000-0xf40fffff 64bit pref]
[    0.162028] pci 0000:00:1c.4: PCI bridge to [bus 0d-14]
[    0.162032] pci 0000:00:1c.4:   bridge window [io  0x3000-0x3fff]
[    0.162037] pci 0000:00:1c.4:   bridge window [mem 0xfa000000-0xfbffffff]
[    0.162044] pci 0000:00:1c.4:   bridge window [mem 0xf4100000-0xf41fffff 64bit pref]
[    0.162108] pci 0000:15:00.0: proprietary Ricoh MMC controller disabled (via cardbus function)
[    0.162110] pci 0000:15:00.0: MMC cards are now supported by standard SDHCI controller
[    0.162120] pci 0000:15:00.0: reg 10: [mem 0xf4800000-0xf4800fff]
[    0.162141] pci 0000:15:00.0: supports D1 D2
[    0.162143] pci 0000:15:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.162147] pci 0000:15:00.0: PME# disabled
[    0.162181] pci 0000:15:00.1: reg 10: [mem 0xf4801000-0xf48017ff]
[    0.162233] pci 0000:15:00.1: supports D1 D2
[    0.162235] pci 0000:15:00.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.162239] pci 0000:15:00.1: PME# disabled
[    0.162272] pci 0000:15:00.2: reg 10: [mem 0xf4801800-0xf48018ff]
[    0.162324] pci 0000:15:00.2: supports D1 D2
[    0.162326] pci 0000:15:00.2: PME# supported from D0 D1 D2 D3hot D3cold
[    0.162330] pci 0000:15:00.2: PME# disabled
[    0.162364] pci 0000:15:00.4: reg 10: [mem 0xf4802000-0xf48020ff]
[    0.162418] pci 0000:15:00.4: supports D1 D2
[    0.162419] pci 0000:15:00.4: PME# supported from D0 D1 D2 D3hot D3cold
[    0.162423] pci 0000:15:00.4: PME# disabled
[    0.162457] pci 0000:15:00.5: reg 10: [mem 0xf4802400-0xf48024ff]
[    0.162510] pci 0000:15:00.5: supports D1 D2
[    0.162511] pci 0000:15:00.5: PME# supported from D0 D1 D2 D3hot D3cold
[    0.162516] pci 0000:15:00.5: PME# disabled
[    0.162575] pci 0000:00:1e.0: PCI bridge to [bus 15-18] (subtractive decode)
[    0.162580] pci 0000:00:1e.0:   bridge window [io  0x4000-0x7fff]
[    0.162584] pci 0000:00:1e.0:   bridge window [mem 0xf4800000-0xf7ffffff]
[    0.162591] pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xf3ffffff 64bit pref]
[    0.162594] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.162596] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.162598] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.162600] pci 0000:00:1e.0:   bridge window [mem 0x000d0000-0x000d3fff] (subtractive decode)
[    0.162602] pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive decode)
[    0.162604] pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
[    0.162606] pci 0000:00:1e.0:   bridge window [mem 0xc0000000-0xfebfffff] (subtractive decode)
[    0.162678] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.162849] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP0._PRT]
[    0.162915] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
[    0.162985] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP3._PRT]
[    0.163061] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP4._PRT]
[    0.163134] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
[    0.170677] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
[    0.170854] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
[    0.171033] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
[    0.171208] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
[    0.171384] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
[    0.171558] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
[    0.171733] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
[    0.171909] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
[    0.172027] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.172039] vgaarb: loaded
[    0.172116] SCSI subsystem initialized
[    0.172121] libata version 3.00 loaded.
[    0.172121] usbcore: registered new interface driver usbfs
[    0.172121] usbcore: registered new interface driver hub
[    0.172121] usbcore: registered new device driver usb
[    0.172121] PCI: Using ACPI for IRQ routing
[    0.172121] PCI: pci_cache_line_size set to 64 bytes
[    0.172151] reserve RAM buffer: 000000000009ec00 - 000000000009ffff 
[    0.172153] reserve RAM buffer: 00000000bd4a1000 - 00000000bfffffff 
[    0.172157] reserve RAM buffer: 00000000bd5b7000 - 00000000bfffffff 
[    0.172161] reserve RAM buffer: 00000000bd6c6000 - 00000000bfffffff 
[    0.172165] reserve RAM buffer: 00000000bda00000 - 00000000bfffffff 
[    0.172241] NetLabel: Initializing
[    0.172242] NetLabel:  domain hash size = 128
[    0.172243] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.172255] NetLabel:  unlabeled traffic allowed by default
[    0.172261] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    0.172267] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.172270] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.175014] Switching to clocksource tsc
[    0.175041] pnp: PnP ACPI init
[    0.175047] ACPI: bus type pnp registered
[    0.237403] pnp: PnP ACPI: found 10 devices
[    0.237405] ACPI: ACPI bus type pnp unregistered
[    0.237412] system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.237414] system 00:00: [mem 0x000c0000-0x000c3fff] has been reserved
[    0.237417] system 00:00: [mem 0x000c4000-0x000c7fff] has been reserved
[    0.237419] system 00:00: [mem 0x000c8000-0x000cbfff] has been reserved
[    0.237421] system 00:00: [mem 0x000cc000-0x000cffff] has been reserved
[    0.237423] system 00:00: [mem 0x000dc000-0x000dffff] could not be reserved
[    0.237426] system 00:00: [mem 0x000e0000-0x000e3fff] could not be reserved
[    0.237428] system 00:00: [mem 0x000e4000-0x000e7fff] could not be reserved
[    0.237430] system 00:00: [mem 0x000e8000-0x000ebfff] could not be reserved
[    0.237432] system 00:00: [mem 0x000ec000-0x000effff] could not be reserved
[    0.237435] system 00:00: [mem 0x000f0000-0x000fffff] could not be reserved
[    0.237437] system 00:00: [mem 0x00100000-0xbfffffff] could not be reserved
[    0.237439] system 00:00: [mem 0xfec00000-0xffffffff] could not be reserved
[    0.237449] system 00:02: [io  0x1000-0x107f] has been reserved
[    0.237451] system 00:02: [io  0x1180-0x11ff] has been reserved
[    0.237453] system 00:02: [io  0x0800-0x080f] has been reserved
[    0.237455] system 00:02: [io  0x15e0-0x15ef] has been reserved
[    0.237457] system 00:02: [io  0x1600-0x167f] has been reserved
[    0.237460] system 00:02: [io  0x1680-0x169f] has been reserved
[    0.237462] system 00:02: [mem 0xe0000000-0xefffffff] has been reserved
[    0.237465] system 00:02: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.237467] system 00:02: [mem 0xfed10000-0xfed13fff] has been reserved
[    0.237469] system 00:02: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.237473] system 00:02: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.237476] system 00:02: [mem 0xfed45000-0xfed4bfff] has been reserved
[    0.237478] system 00:02: [mem 0xfed40000-0xfed44fff] has been reserved
[    0.242238] pci 0000:00:1c.0: BAR 14: assigned [mem 0xc0000000-0xc01fffff]
[    0.242241] pci 0000:00:1c.0: BAR 15: assigned [mem 0xc0200000-0xc03fffff 64bit pref]
[    0.242244] pci 0000:00:1c.1: BAR 15: assigned [mem 0xc0400000-0xc05fffff 64bit pref]
[    0.242247] pci 0000:00:1c.0: BAR 13: assigned [io  0x8000-0x8fff]
[    0.242249] pci 0000:00:1c.1: BAR 13: assigned [io  0x9000-0x9fff]
[    0.242251] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.242254] pci 0000:00:1c.0:   bridge window [io  0x8000-0x8fff]
[    0.242260] pci 0000:00:1c.0:   bridge window [mem 0xc0000000-0xc01fffff]
[    0.242264] pci 0000:00:1c.0:   bridge window [mem 0xc0200000-0xc03fffff 64bit pref]
[    0.242271] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.242274] pci 0000:00:1c.1:   bridge window [io  0x9000-0x9fff]
[    0.242280] pci 0000:00:1c.1:   bridge window [mem 0xf4300000-0xf43fffff]
[    0.242284] pci 0000:00:1c.1:   bridge window [mem 0xc0400000-0xc05fffff 64bit pref]
[    0.242291] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    0.242294] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    0.242300] pci 0000:00:1c.3:   bridge window [mem 0xf8000000-0xf9ffffff]
[    0.242304] pci 0000:00:1c.3:   bridge window [mem 0xf4000000-0xf40fffff 64bit pref]
[    0.242311] pci 0000:00:1c.4: PCI bridge to [bus 0d-14]
[    0.242314] pci 0000:00:1c.4:   bridge window [io  0x3000-0x3fff]
[    0.242319] pci 0000:00:1c.4:   bridge window [mem 0xfa000000-0xfbffffff]
[    0.242324] pci 0000:00:1c.4:   bridge window [mem 0xf4100000-0xf41fffff 64bit pref]
[    0.242332] pci 0000:15:00.0: BAR 15: assigned [mem 0xf0000000-0xf3ffffff pref]
[    0.242335] pci 0000:15:00.0: BAR 16: assigned [mem 0xc4000000-0xc7ffffff]
[    0.242337] pci 0000:15:00.0: BAR 13: assigned [io  0x4000-0x40ff]
[    0.242338] pci 0000:15:00.0: BAR 14: assigned [io  0x4400-0x44ff]
[    0.242340] pci 0000:15:00.0: CardBus bridge to [bus 16-17]
[    0.242342] pci 0000:15:00.0:   bridge window [io  0x4000-0x40ff]
[    0.242346] pci 0000:15:00.0:   bridge window [io  0x4400-0x44ff]
[    0.242350] pci 0000:15:00.0:   bridge window [mem 0xf0000000-0xf3ffffff pref]
[    0.242355] pci 0000:15:00.0:   bridge window [mem 0xc4000000-0xc7ffffff]
[    0.242359] pci 0000:00:1e.0: PCI bridge to [bus 15-18]
[    0.242362] pci 0000:00:1e.0:   bridge window [io  0x4000-0x7fff]
[    0.242367] pci 0000:00:1e.0:   bridge window [mem 0xf4800000-0xf7ffffff]
[    0.242372] pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xf3ffffff 64bit pref]
[    0.242387]   alloc irq_desc for 20 on node -1
[    0.242388]   alloc kstat_irqs on node -1
[    0.242392] pci 0000:00:1c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    0.242397] pci 0000:00:1c.0: setting latency timer to 64
[    0.242406]   alloc irq_desc for 21 on node -1
[    0.242407]   alloc kstat_irqs on node -1
[    0.242410] pci 0000:00:1c.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    0.242414] pci 0000:00:1c.1: setting latency timer to 64
[    0.242423]   alloc irq_desc for 23 on node -1
[    0.242424]   alloc kstat_irqs on node -1
[    0.242427] pci 0000:00:1c.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    0.242431] pci 0000:00:1c.3: setting latency timer to 64
[    0.242441] pci 0000:00:1c.4: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    0.242445] pci 0000:00:1c.4: setting latency timer to 64
[    0.242452] pci 0000:00:1e.0: setting latency timer to 64
[    0.242461]   alloc irq_desc for 16 on node -1
[    0.242463]   alloc kstat_irqs on node -1
[    0.242465] pci 0000:15:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.242470] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.242472] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.242474] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.242476] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000d3fff]
[    0.242477] pci_bus 0000:00: resource 8 [mem 0x000d4000-0x000d7fff]
[    0.242479] pci_bus 0000:00: resource 9 [mem 0x000d8000-0x000dbfff]
[    0.242481] pci_bus 0000:00: resource 10 [mem 0xc0000000-0xfebfffff]
[    0.242483] pci_bus 0000:02: resource 0 [io  0x8000-0x8fff]
[    0.242485] pci_bus 0000:02: resource 1 [mem 0xc0000000-0xc01fffff]
[    0.242487] pci_bus 0000:02: resource 2 [mem 0xc0200000-0xc03fffff 64bit pref]
[    0.242488] pci_bus 0000:03: resource 0 [io  0x9000-0x9fff]
[    0.242490] pci_bus 0000:03: resource 1 [mem 0xf4300000-0xf43fffff]
[    0.242492] pci_bus 0000:03: resource 2 [mem 0xc0400000-0xc05fffff 64bit pref]
[    0.242494] pci_bus 0000:05: resource 0 [io  0x2000-0x2fff]
[    0.242496] pci_bus 0000:05: resource 1 [mem 0xf8000000-0xf9ffffff]
[    0.242497] pci_bus 0000:05: resource 2 [mem 0xf4000000-0xf40fffff 64bit pref]
[    0.242499] pci_bus 0000:0d: resource 0 [io  0x3000-0x3fff]
[    0.242501] pci_bus 0000:0d: resource 1 [mem 0xfa000000-0xfbffffff]
[    0.242503] pci_bus 0000:0d: resource 2 [mem 0xf4100000-0xf41fffff 64bit pref]
[    0.242505] pci_bus 0000:15: resource 0 [io  0x4000-0x7fff]
[    0.242506] pci_bus 0000:15: resource 1 [mem 0xf4800000-0xf7ffffff]
[    0.242508] pci_bus 0000:15: resource 2 [mem 0xf0000000-0xf3ffffff 64bit pref]
[    0.242510] pci_bus 0000:15: resource 4 [io  0x0000-0x0cf7]
[    0.242512] pci_bus 0000:15: resource 5 [io  0x0d00-0xffff]
[    0.242513] pci_bus 0000:15: resource 6 [mem 0x000a0000-0x000bffff]
[    0.242515] pci_bus 0000:15: resource 7 [mem 0x000d0000-0x000d3fff]
[    0.242517] pci_bus 0000:15: resource 8 [mem 0x000d4000-0x000d7fff]
[    0.242519] pci_bus 0000:15: resource 9 [mem 0x000d8000-0x000dbfff]
[    0.242520] pci_bus 0000:15: resource 10 [mem 0xc0000000-0xfebfffff]
[    0.242522] pci_bus 0000:16: resource 0 [io  0x4000-0x40ff]
[    0.242524] pci_bus 0000:16: resource 1 [io  0x4400-0x44ff]
[    0.242526] pci_bus 0000:16: resource 2 [mem 0xf0000000-0xf3ffffff pref]
[    0.242528] pci_bus 0000:16: resource 3 [mem 0xc4000000-0xc7ffffff]
[    0.242548] NET: Registered protocol family 2
[    0.242648] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.243765] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.246727] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.247216] TCP: Hash tables configured (established 524288 bind 65536)
[    0.247219] TCP reno registered
[    0.247229] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.247265] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.247413] NET: Registered protocol family 1
[    0.247429] pci 0000:00:02.0: Boot video device
[    0.247633] PCI: CLS 64 bytes, default 64
[    0.247697] Trying to unpack rootfs image as initramfs...
[    0.364475] Freeing initrd memory: 5716k freed
[    0.366776] DMAR: Device scope device [0000:00:03.02] not found
[    0.366779] DMAR: Device scope device [0000:00:03.02] not found
[    0.366781] DMAR: Device scope device [0000:00:03.03] not found
[    0.366783] DMAR: Device scope device [0000:00:03.03] not found
[    0.366799] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.366801] Placing 64MB software IO TLB between ffff880001b9c000 - ffff880005b9c000
[    0.366803] software IO TLB at phys 0x1b9c000 - 0x5b9c000
[    0.366842] Simple Boot Flag at 0x35 set to 0x1
[    0.367152] Intel PCLMULQDQ-NI instructions are not detected.
[    0.367276] audit: initializing netlink socket (disabled)
[    0.367290] type=2000 audit(1277667426.365:1): initialized
[    0.367637] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.368992] VFS: Disk quotas dquot_6.5.2
[    0.369032] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.369412] msgmni has been set to 7719
[    0.369477] SELinux:  Registering netfilter hooks
[    0.369736] alg: No test for stdrng (krng)
[    0.369777] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.369781] io scheduler noop registered
[    0.369782] io scheduler deadline registered
[    0.369815] io scheduler cfq registered (default)
[    0.369964] pcieport 0000:00:1c.0: setting latency timer to 64
[    0.370007]   alloc irq_desc for 40 on node -1
[    0.370009]   alloc kstat_irqs on node -1
[    0.370021] pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
[    0.370113] pcieport 0000:00:1c.1: setting latency timer to 64
[    0.370153]   alloc irq_desc for 41 on node -1
[    0.370155]   alloc kstat_irqs on node -1
[    0.370162] pcieport 0000:00:1c.1: irq 41 for MSI/MSI-X
[    0.370251] pcieport 0000:00:1c.3: setting latency timer to 64
[    0.370292]   alloc irq_desc for 42 on node -1
[    0.370293]   alloc kstat_irqs on node -1
[    0.370301] pcieport 0000:00:1c.3: irq 42 for MSI/MSI-X
[    0.370388] pcieport 0000:00:1c.4: setting latency timer to 64
[    0.370429]   alloc irq_desc for 43 on node -1
[    0.370430]   alloc kstat_irqs on node -1
[    0.370438] pcieport 0000:00:1c.4: irq 43 for MSI/MSI-X
[    0.370540] pcieport 0000:00:1c.0: Requesting control of PCIe PME from ACPI BIOS
[    0.370912] pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
[    0.370917] pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
[    0.370921] pcieport 0000:00:1c.1: Requesting control of PCIe PME from ACPI BIOS
[    0.370942] pcieport 0000:00:1c.1: Signaling PME through PCIe PME interrupt
[    0.370944] pci 0000:03:00.0: Signaling PME through PCIe PME interrupt
[    0.370951] pcie_pme 0000:00:1c.1:pcie01: service driver pcie_pme loaded
[    0.370955] pcieport 0000:00:1c.3: Requesting control of PCIe PME from ACPI BIOS
[    0.370977] pcieport 0000:00:1c.3: Signaling PME through PCIe PME interrupt
[    0.370982] pcie_pme 0000:00:1c.3:pcie01: service driver pcie_pme loaded
[    0.370985] pcieport 0000:00:1c.4: Requesting control of PCIe PME from ACPI BIOS
[    0.371006] pcieport 0000:00:1c.4: Signaling PME through PCIe PME interrupt
[    0.371010] pcie_pme 0000:00:1c.4:pcie01: service driver pcie_pme loaded
[    0.371029] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.371523] pciehp 0000:00:1c.0:pcie04: HPC vendor_id 8086 device_id 2940 ss_vid 17aa ss_did 20f3
[    0.371546] pciehp 0000:00:1c.0:pcie04: service driver pciehp loaded
[    0.371562] pciehp 0000:00:1c.1:pcie04: HPC vendor_id 8086 device_id 2942 ss_vid 17aa ss_did 20f3
[    0.371583] pciehp 0000:00:1c.1:pcie04: service driver pciehp loaded
[    0.371598] pciehp 0000:00:1c.3:pcie04: HPC vendor_id 8086 device_id 2946 ss_vid 17aa ss_did 20f3
[    0.371616] pciehp 0000:00:1c.3:pcie04: service driver pciehp loaded
[    0.371631] pciehp 0000:00:1c.4:pcie04: HPC vendor_id 8086 device_id 2948 ss_vid 17aa ss_did 20f3
[    0.371649] pciehp 0000:00:1c.4:pcie04: service driver pciehp loaded
[    0.371656] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.371658] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.371979] acpiphp_glue: Slot 1 already registered by another hotplug driver
[    0.372017] acpiphp_glue: Slot 1 already registered by another hotplug driver
[    0.372174] pci-stub: invalid id string ""
[    0.372474] ACPI: AC Adapter [AC] (on-line)
[    0.372552] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input0
[    0.372725] ACPI: Lid Switch [LID]
[    0.372765] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input1
[    0.372767] ACPI: Sleep Button [SLPB]
[    0.372817] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    0.372819] ACPI: Power Button [PWRF]
[    0.373125] ACPI: acpi_idle registered with cpuidle
[    0.375777] Monitor-Mwait will be used to enter C-1 state
[    0.375792] Monitor-Mwait will be used to enter C-2 state
[    0.375805] Monitor-Mwait will be used to enter C-3 state
[    0.375809] Marking TSC unstable due to TSC halts in idle
[    0.375844] Switching to clocksource hpet
[    0.421099] thermal LNXTHERM:01: registered as thermal_zone0
[    0.421106] ACPI: Thermal Zone [THM0] (50 C)
[    0.422580] thermal LNXTHERM:02: registered as thermal_zone1
[    0.422589] ACPI: Thermal Zone [THM1] (52 C)
[    0.424336] Non-volatile memory driver v1.3
[    0.424340] Linux agpgart interface v0.103
[    0.424470] agpgart-intel 0000:00:00.0: Intel GM45 Chipset
[    0.426765] agpgart-intel 0000:00:00.0: detected 32764K stolen memory
[    0.439110] ACPI: Battery Slot [BAT0] (battery present)
[    0.450631] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    0.450700] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.451882] brd: module loaded
[    0.452347] loop: module loaded
[    0.452429] ahci 0000:00:1f.2: version 3.0
[    0.452444] ahci 0000:00:1f.2: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.452475]   alloc irq_desc for 44 on node -1
[    0.452477]   alloc kstat_irqs on node -1
[    0.452487] ahci 0000:00:1f.2: irq 44 for MSI/MSI-X
[    0.452519] ahci: SSS flag set, parallel bus scan disabled
[    0.452545] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 4 ports 3 Gbps 0x3 impl SATA mode
[    0.452548] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part ccc sxs 
[    0.452553] ahci 0000:00:1f.2: setting latency timer to 64
[    0.452761] scsi0 : ahci
[    0.452828] scsi1 : ahci
[    0.452887] scsi2 : ahci
[    0.452940] scsi3 : ahci
[    0.453633] ata1: SATA max UDMA/133 abar m2048@0xfc226000 port 0xfc226100 irq 44
[    0.453636] ata2: SATA max UDMA/133 abar m2048@0xfc226000 port 0xfc226180 irq 44
[    0.453638] ata3: DUMMY
[    0.453639] ata4: DUMMY
[    0.453709] Fixed MDIO Bus: probed
[    0.453749] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.453934] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[    0.454097] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[    0.454103] ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    0.454114] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    0.454118] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    0.454162] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    0.454191] ehci_hcd 0000:00:1a.7: debug port 1
[    0.458083] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
[    0.458096] ehci_hcd 0000:00:1a.7: irq 23, io mem 0xfc226c00
[    0.468017] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    0.468033] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    0.468035] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.468037] usb usb1: Product: EHCI Host Controller
[    0.468039] usb usb1: Manufacturer: Linux 2.6.35-rc3 ehci_hcd
[    0.468040] usb usb1: SerialNumber: 0000:00:1a.7
[    0.468120] hub 1-0:1.0: USB hub found
[    0.468123] hub 1-0:1.0: 6 ports detected
[    0.468380] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[    0.468549] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[    0.468555]   alloc irq_desc for 19 on node -1
[    0.468556]   alloc kstat_irqs on node -1
[    0.468560] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    0.468571] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    0.468574] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    0.468610] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    0.468636] ehci_hcd 0000:00:1d.7: debug port 1
[    0.472516] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    0.472531] ehci_hcd 0000:00:1d.7: irq 19, io mem 0xfc227000
[    0.477441] Monitor-Mwait will be used to enter C-3 state
[    0.482014] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    0.482036] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    0.482038] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.482040] usb usb2: Product: EHCI Host Controller
[    0.482041] usb usb2: Manufacturer: Linux 2.6.35-rc3 ehci_hcd
[    0.482043] usb usb2: SerialNumber: 0000:00:1d.7
[    0.482115] hub 2-0:1.0: USB hub found
[    0.482118] hub 2-0:1.0: 6 ports detected
[    0.482181] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.482193] uhci_hcd: USB Universal Host Controller Interface driver
[    0.482403] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[    0.482570] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[    0.482574] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    0.482580] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    0.482583] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    0.482622] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    0.482655] uhci_hcd 0000:00:1a.0: irq 20, io base 0x00001860
[    0.482687] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    0.482689] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.482690] usb usb3: Product: UHCI Host Controller
[    0.482692] usb usb3: Manufacturer: Linux 2.6.35-rc3 uhci_hcd
[    0.482693] usb usb3: SerialNumber: 0000:00:1a.0
[    0.482761] hub 3-0:1.0: USB hub found
[    0.482765] hub 3-0:1.0: 2 ports detected
[    0.482818] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    0.482824] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    0.482827] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    0.482857] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    0.482890] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00001880
[    0.482920] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    0.482922] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.482923] usb usb4: Product: UHCI Host Controller
[    0.482925] usb usb4: Manufacturer: Linux 2.6.35-rc3 uhci_hcd
[    0.482926] usb usb4: SerialNumber: 0000:00:1a.1
[    0.482995] hub 4-0:1.0: USB hub found
[    0.482998] hub 4-0:1.0: 2 ports detected
[    0.483217] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[    0.483384] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[    0.483388]   alloc irq_desc for 22 on node -1
[    0.483389]   alloc kstat_irqs on node -1
[    0.483393] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    0.483399] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    0.483402] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    0.483445] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
[    0.483478] uhci_hcd 0000:00:1a.2: irq 22, io base 0x000018a0
[    0.483508] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    0.483510] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.483512] usb usb5: Product: UHCI Host Controller
[    0.483514] usb usb5: Manufacturer: Linux 2.6.35-rc3 uhci_hcd
[    0.483515] usb usb5: SerialNumber: 0000:00:1a.2
[    0.483589] hub 5-0:1.0: USB hub found
[    0.483592] hub 5-0:1.0: 2 ports detected
[    0.483841] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    0.484012] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    0.484016] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.484022] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    0.484025] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    0.484055] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
[    0.484088] uhci_hcd 0000:00:1d.0: irq 16, io base 0x000018c0
[    0.484118] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    0.484120] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.484122] usb usb6: Product: UHCI Host Controller
[    0.484123] usb usb6: Manufacturer: Linux 2.6.35-rc3 uhci_hcd
[    0.484125] usb usb6: SerialNumber: 0000:00:1d.0
[    0.484192] hub 6-0:1.0: USB hub found
[    0.484195] hub 6-0:1.0: 2 ports detected
[    0.484248]   alloc irq_desc for 17 on node -1
[    0.484250]   alloc kstat_irqs on node -1
[    0.484253] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.484260] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    0.484263] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    0.484292] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
[    0.484328] uhci_hcd 0000:00:1d.1: irq 17, io base 0x000018e0
[    0.484360] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    0.484362] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.484364] usb usb7: Product: UHCI Host Controller
[    0.484365] usb usb7: Manufacturer: Linux 2.6.35-rc3 uhci_hcd
[    0.484367] usb usb7: SerialNumber: 0000:00:1d.1
[    0.484434] hub 7-0:1.0: USB hub found
[    0.484437] hub 7-0:1.0: 2 ports detected
[    0.484487]   alloc irq_desc for 18 on node -1
[    0.484489]   alloc kstat_irqs on node -1
[    0.484492] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.484498] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    0.484501] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    0.484535] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
[    0.484567] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001c00
[    0.484598] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
[    0.484600] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.484602] usb usb8: Product: UHCI Host Controller
[    0.484603] usb usb8: Manufacturer: Linux 2.6.35-rc3 uhci_hcd
[    0.484604] usb usb8: SerialNumber: 0000:00:1d.2
[    0.484671] hub 8-0:1.0: USB hub found
[    0.484674] hub 8-0:1.0: 2 ports detected
[    0.484774] PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    0.492705] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.492710] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.492751] mice: PS/2 mouse device common for all mice
[    0.492883] rtc_cmos 00:07: RTC can wake from S4
[    0.492926] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
[    0.492954] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    0.493006] device-mapper: uevent: version 1.0.3
[    0.493101] device-mapper: ioctl: 4.17.0-ioctl (2010-03-05) initialised: dm-devel@redhat.com
[    0.493237] cpuidle: using governor ladder
[    0.493343] cpuidle: using governor menu
[    0.493618] usbcore: registered new interface driver hiddev
[    0.493630] usbcore: registered new interface driver usbhid
[    0.493631] usbhid: USB HID core driver
[    0.493650] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    0.493762] CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
[    0.493764] nf_conntrack.acct=1 kernel parameter, acct=1 nf_conntrack module option or
[    0.493765] sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
[    0.493819] ip_tables: (C) 2000-2006 Netfilter Core Team
[    0.493831] TCP cubic registered
[    0.493832] Initializing XFRM netlink socket
[    0.493840] NET: Registered protocol family 17
[    0.493926] PM: Resume from disk failed.
[    0.493931] registered taskstats version 1
[    0.493933] IMA: No TPM chip found, activating TPM-bypass!
[    0.494325]   Magic number: 14:625:648
[    0.494330] scsi_host host2: hash matches
[    0.494331] scsi host2: hash matches
[    0.494379] processor LNXCPU:01: hash matches
[    0.494437] rtc_cmos 00:07: setting system clock to 2010-06-27 19:37:06 UTC (1277667426)
[    0.497520] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
[    0.758137] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    0.759218] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    0.759221] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    0.759306] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES) succeeded
[    0.759311] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    0.784101] usb 2-1: new high speed USB device using ehci_hcd and address 2
[    0.805172] ata1.00: ATA-8: WDC WD1600BEVS-08VAT2, 14.01A14, max UDMA/133
[    0.805175] ata1.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    0.806635] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    0.806639] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    0.806742] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES) succeeded
[    0.806746] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    0.808070] ata1.00: configured for UDMA/133
[    0.822434] ata1.00: configured for UDMA/133
[    0.822437] ata1: EH complete
[    0.822594] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1600BEVS-0 14.0 PQ: 0 ANSI: 5
[    0.822748] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    0.822751] sd 0:0:0:0: [sda] 312581808 512-byte logical blocks: (160 GB/149 GiB)
[    0.822788] sd 0:0:0:0: [sda] Write Protect is off
[    0.822791] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    0.822809] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    0.822909]  sda: sda1 sda2 sda3
[    0.835864] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.031612] usb 2-1: New USB device found, idVendor=046d, idProduct=0990
[    1.031616] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=2
[    1.031619] usb 2-1: SerialNumber: B4261720
[    1.127064] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.129880] ata2.00: ACPI cmd e3/00:79:00:00:00:a0 (IDLE) succeeded
[    1.130700] ata2.00: ACPI cmd e3/00:01:00:00:00:a0 (IDLE) succeeded
[    1.132593] ata2.00: ATAPI: MATSHITADVD-RAM UJ862AC, SB01, max UDMA/33
[    1.135722] ata2.00: ACPI cmd e3/00:79:00:00:00:a0 (IDLE) succeeded
[    1.136560] ata2.00: ACPI cmd e3/00:01:00:00:00:a0 (IDLE) succeeded
[    1.138406] ata2.00: configured for UDMA/33
[    1.151845] scsi 1:0:0:0: CD-ROM            MATSHITA DVD-RAM UJ862AC  SB01 PQ: 0 ANSI: 5
[    1.155559] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    1.155561] Uniform CD-ROM driver Revision: 3.20
[    1.155622] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    1.155661] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    1.155818] Freeing unused kernel memory: 692k freed
[    1.156021] Write protecting the kernel read-only data: 6144k
[    1.156154] Freeing unused kernel memory: 100k freed
[    1.156261] Freeing unused kernel memory: 504k freed
[    1.165353] dracut: dracut-006-1.fc14
[    1.171824] udev: starting version 156
[    1.212418] [drm] Initialized drm 1.1.0 20060810
[    1.218036] Synaptics Touchpad, model: 1, fw: 7.0, id: 0x1c0b1, caps: 0xd04791/0xb00000/0x20000
[    1.218040] serio: Synaptics pass-through port at isa0060/serio1/input0
[    1.224171] i915 0000:00:02.0: power state changed by ACPI to D0
[    1.224209] i915 0000:00:02.0: power state changed by ACPI to D0
[    1.224215] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.224219] i915 0000:00:02.0: setting latency timer to 64
[    1.259952] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input4
[    1.281193]   alloc irq_desc for 45 on node -1
[    1.281197]   alloc kstat_irqs on node -1
[    1.281204] i915 0000:00:02.0: irq 45 for MSI/MSI-X
[    1.281216] [drm] set up 31M of stolen space
[    1.411037] usb 6-2: new low speed USB device using uhci_hcd and address 2
[    1.580149] usb 6-2: New USB device found, idVendor=045e, idProduct=00cb
[    1.580152] usb 6-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    1.580154] usb 6-2: Product: Microsoft Basic Optical Mouse v2.0 
[    1.580156] usb 6-2: Manufacturer: Microsoft 
[    1.607342] input: Microsoft  Microsoft Basic Optical Mouse v2.0  as /devices/pci0000:00/0000:00:1d.0/usb6/6-2/6-2:1.0/input/input5
[    1.607418] generic-usb 0003:045E:00CB.0001: input,hidraw0: USB HID v1.11 Mouse [Microsoft  Microsoft Basic Optical Mouse v2.0 ] on usb-0000:00:1d.0-2/input0
[    1.859401] fbcon: inteldrmfb (fb0) is primary device
[    1.991939] Console: switching to colour frame buffer device 240x75
[    1.997657] fb0: inteldrmfb frame buffer device
[    1.997658] drm: registered panic notifier
[    1.997660] Slow work thread pool: Starting up
[    1.997805] Slow work thread pool: Ready
[    2.001400] acpi device:01: registered as cooling_device2
[    2.001600] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input6
[    2.001631] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[    2.001676] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    2.042397] dracut: Starting plymouth daemon
[    2.408120] yenta_cardbus 0000:15:00.0: CardBus bridge found [17aa:20c6]
[    2.439924] sdhci: Secure Digital Host Controller Interface driver
[    2.439926] sdhci: Copyright(c) Pierre Ossman
[    2.530829] yenta_cardbus 0000:15:00.0: ISA IRQ mask 0x0cb8, PCI irq 16
[    2.530833] yenta_cardbus 0000:15:00.0: Socket status: 30000006
[    2.530838] yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge window: [io  0x4000-0x7fff]
[    2.530840] yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge window: [mem 0xf4800000-0xf7ffffff]
[    2.530843] pcmcia_socket pcmcia_socket0: cs: memory probe 0xf4800000-0xf7ffffff: excluding 0xf4800000-0xf4b7ffff
[    2.530857] yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge window: [mem 0xf0000000-0xf3ffffff 64bit pref]
[    2.530859] pcmcia_socket pcmcia_socket0: cs: memory probe 0xf0000000-0xf3ffffff: excluding 0xf0000000-0xf3ffffff
[    2.531144] firewire_ohci 0000:15:00.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    2.592050] firewire_ohci: Added fw-ohci device 0000:15:00.1, OHCI v1.10, 4 IR + 4 IT contexts, quirks 0x0
[    2.592072] sdhci-pci 0000:15:00.2: SDHCI controller found [1180:0822] (rev 21)
[    2.592090] sdhci-pci 0000:15:00.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    2.593133] sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
[    2.594163] Registered led device: mmc0::
[    2.595210] mmc0: SDHCI controller on PCI [0000:15:00.2] using DMA
[    3.091118] firewire_core: created device fw0: GUID 00016c2000a7ebc0, S400
[    7.219649] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[    7.457454] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/serio2/input/input7
[    7.547664] dracut: Scanning devices sda3  for LVM volume groups 
[    7.556616] dracut: Reading all physical volumes. This may take a while...
[    7.556660] dracut: Found volume group "vg_segfault" using metadata type lvm2
[    7.785677] dracut: 2 logical volume(s) in volume group "vg_segfault" now active
[    7.803226] EXT4-fs (dm-0): INFO: recovery required on readonly filesystem
[    7.803229] EXT4-fs (dm-0): write access will be enabled during recovery
[    8.301453] EXT4-fs (dm-0): orphan cleanup on readonly fs
[    8.301459] EXT4-fs (dm-0): ext4_orphan_cleanup: deleting unreferenced inode 1138
[    8.301530] EXT4-fs (dm-0): ext4_orphan_cleanup: deleting unreferenced inode 709
[    8.301539] EXT4-fs (dm-0): ext4_orphan_cleanup: deleting unreferenced inode 624
[    8.301546] EXT4-fs (dm-0): ext4_orphan_cleanup: deleting unreferenced inode 591
[    8.301554] EXT4-fs (dm-0): ext4_orphan_cleanup: deleting unreferenced inode 543
[    8.301561] EXT4-fs (dm-0): ext4_orphan_cleanup: deleting unreferenced inode 521
[    8.301568] EXT4-fs (dm-0): ext4_orphan_cleanup: deleting unreferenced inode 419
[    8.301575] EXT4-fs (dm-0): ext4_orphan_cleanup: deleting unreferenced inode 362
[    8.301583] EXT4-fs (dm-0): ext4_orphan_cleanup: deleting unreferenced inode 410
[    8.301589] EXT4-fs (dm-0): 9 orphan inodes deleted
[    8.301591] EXT4-fs (dm-0): recovery complete
[    8.810316] EXT4-fs (dm-0): mounted filesystem with ordered data mode. Opts: (null)
[    8.865439] dracut: Remounting /dev/mapper/vg_segfault-lv_root with -o noatime,nodiratime,ro
[    8.936379] EXT4-fs (dm-0): mounted filesystem with ordered data mode. Opts: (null)
[    8.945829] dracut: Mounted root filesystem /dev/mapper/vg_segfault-lv_root
[    9.079833] dracut: Loading SELinux policy
[    9.513091] SELinux:  Disabled at runtime.
[    9.513110] SELinux:  Unregistering netfilter hooks
[    9.525053] type=1404 audit(1277667435.530:2): selinux=0 auid=4294967295 ses=4294967295
[    9.678546] dracut: /sbin/load_policy: Can't load policy: No such file or directory
[    9.758001] dracut: Switching root
[   11.782429] udev: starting version 158
[   12.598330] microcode: CPU0 sig=0x1067a, pf=0x80, revision=0xa07
[   12.782850] ACPI: WMI: Mapper loaded
[   12.834239] microcode: CPU1 sig=0x1067a, pf=0x80, revision=0xa07
[   12.835034] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[   13.269180] e1000e: Intel(R) PRO/1000 Network Driver - 1.0.2-k4
[   13.269182] e1000e: Copyright (c) 1999 - 2009 Intel Corporation.
[   13.269213] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[   13.269224] e1000e 0000:00:19.0: setting latency timer to 64
[   13.269387]   alloc irq_desc for 46 on node -1
[   13.269389]   alloc kstat_irqs on node -1
[   13.269401] e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
[   13.372864] iTCO_vendor_support: vendor-support=0
[   13.390956] pcmcia_socket pcmcia_socket0: cs: memory probe 0x0c0000-0x0fffff: excluding 0xc0000-0xcffff 0xdc000-0xfffff
[   13.391012] pcmcia_socket pcmcia_socket0: cs: memory probe 0xa0000000-0xa0ffffff: excluding 0xa0000000-0xa0ffffff
[   13.391059] pcmcia_socket pcmcia_socket0: cs: memory probe 0x60000000-0x60ffffff: excluding 0x60000000-0x60ffffff
[   13.400292] e1000e 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:22:68:0c:96:e3
[   13.400295] e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[   13.400321] e1000e 0000:00:19.0: eth0: MAC: 7, PHY: 8, PBA No: 1008ff-0ff
[   13.400353] i801_smbus 0000:00:1f.3: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[   13.432023] thinkpad_acpi: ThinkPad ACPI Extras v0.24
[   13.432025] thinkpad_acpi: http://ibm-acpi.sf.net/
[   13.432027] thinkpad_acpi: ThinkPad BIOS 6FET83WW (3.13 ), EC 7VHT16WW-1.06
[   13.432029] thinkpad_acpi: Lenovo ThinkPad W500, model 4058CTO
[   13.432717] thinkpad_acpi: detected a 16-level brightness capable ThinkPad
[   13.433053] thinkpad_acpi: radio switch found; radios are enabled
[   13.433072] thinkpad_acpi: This ThinkPad has standard ACPI backlight brightness control, supported by the ACPI video driver
[   13.433075] thinkpad_acpi: Disabling thinkpad-acpi brightness events by default...
[   13.436190] Registered led device: tpacpi::thinklight
[   13.436262] Registered led device: tpacpi::power
[   13.436318] Registered led device: tpacpi::standby
[   13.436385] Registered led device: tpacpi::thinkvantage
[   13.438477] thinkpad_acpi: Standard ACPI backlight interface available, not loading native one.
[   13.438553] thinkpad_acpi: Console audio control enabled, mode: monitor (read only)
[   13.441062] input: ThinkPad Extra Buttons as /devices/platform/thinkpad_acpi/input/input8
[   13.455451] cfg80211: Calling CRDA to update world regulatory domain
[   13.548564] Linux video capture interface: v2.00
[   13.616015] uvcvideo: Found UVC 1.00 device <unnamed> (046d:0990)
[   13.628315] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.06
[   13.628427] iTCO_wdt: Found a ICH9M-E TCO device (Version=2, TCOBASE=0x1060)
[   13.628484] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[   13.632363] input: UVC Camera (046d:0990) as /devices/pci0000:00/0000:00:1d.7/usb2/2-1/2-1:1.0/input/input9
[   13.632551] usbcore: registered new interface driver uvcvideo
[   13.632553] USB Video Class driver (v0.1.0)
[   13.688771] usbcore: registered new interface driver snd-usb-audio
[   14.010249] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[   14.010316]   alloc irq_desc for 47 on node -1
[   14.010318]   alloc kstat_irqs on node -1
[   14.010330] HDA Intel 0000:00:1b.0: irq 47 for MSI/MSI-X
[   14.010364] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   14.093202] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:d
[   14.093205] iwlagn: Copyright(c) 2003-2010 Intel Corporation
[   14.093274] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   14.093282] iwlagn 0000:03:00.0: setting latency timer to 64
[   14.093318] iwlagn 0000:03:00.0: Detected Intel(R) WiFi Link 5100 AGN, REV=0x54
[   14.112774] iwlagn 0000:03:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
[   14.112852]   alloc irq_desc for 48 on node -1
[   14.112854]   alloc kstat_irqs on node -1
[   14.112893] iwlagn 0000:03:00.0: irq 48 for MSI/MSI-X
[   14.215621] iwlagn 0000:03:00.0: loaded firmware version 8.24.2.12
[   14.454496] cfg80211: World regulatory domain updated:
[   14.454499]     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   14.454501]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   14.454503]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   14.454505]     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   14.454507]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   14.454509]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   14.532067] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card1/input10
[   14.532142] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card1/input11
[   14.532195] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card1/input12
[   14.532246] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card1/input13
[   14.682874] phy0: Selected rate control algorithm 'iwl-agn-rs'
[   15.230788] cfg80211: Calling CRDA for country: US
[   15.232348] cfg80211: Regulatory domain changed to country: US
[   15.232350]     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   15.232353]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
[   15.232355]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
[   15.232357]     (5250000 KHz - 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   15.232359]     (5490000 KHz - 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   15.232361]     (5650000 KHz - 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   15.232363]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
[   16.927134] EXT4-fs (dm-0): re-mounted. Opts: (null)
[   17.092228] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null)
[   17.699687] Adding 6160380k swap on /dev/mapper/vg_segfault-lv_swap.  Priority:-1 extents:1 across:6160380k 
[   20.751442] e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
[   20.802169] e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
[   22.787749] NET: Registered protocol family 10
[   22.787991] lo: Disabled Privacy Extensions
[   22.788110] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   22.788162] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   82.483419] wlan0: deauthenticating from aa:bb:cc:dd:ee:ff by local choice (reason=3)
[   82.524580] wlan0: authenticate with aa:bb:cc:dd:ee:ff (try 1)
[   82.530253] wlan0: authenticated
[   82.535637] wlan0: associate with aa:bb:cc:dd:ee:ff (try 1)
[   82.539055] wlan0: RX AssocResp from aa:bb:cc:dd:ee:ff (capab=0x431 status=0 aid=2)
[   82.539058] wlan0: associated
[   82.542982] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   82.681795] Intel AES-NI instructions are not detected.
[   82.736361] padlock: VIA PadLock not detected.
[   92.722100] wlan0: no IPv6 routers present

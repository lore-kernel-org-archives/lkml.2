Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752058Ab1LRV5P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 16:57:15 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:42717 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222Ab1LRV5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 16:57:10 -0500
MIME-Version: 1.0
From: Kyle Moffett <kyle@moffetthome.net>
Date: Sun, 18 Dec 2011 16:56:47 -0500
Message-ID: <CAGZ=bqKqO328BQa7+0S-GNfmvgKurcB1Z66qbCMT7Fu3G=7Leg@mail.gmail.com>
Subject: HP Envy 17 3D BIOS reports "Thermal Shutdown" on every reboot despite
 no thermal problems
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a shiny new HP Envy 17 3D laptop which seems to have some ACPI
firmware bugs, and I'm looking for some help debugging and either
working around them or fixing the kernel to do what Windows 7 does.

Every time I reboot or shut down from Linux, on the following boot the
BIOS complains that the system was shut down due to overheating.  If I
reboot from within the BIOS it is fine.

I've included my dmesg at the end of this email.

Any advice on what I can do to try to debug this?

Thanks!

Cheers,
Kyle Moffett

-- 
Curious about my work on the Debian powerpcspe port?
I'm keeping a blog here: http://pureperl.blogspot.com/

--
dmesg.log:
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.2.0-rc6 (kyle@artemis) (gcc version
4.6.2 (Debian 4.6.2-5) ) #3 SMP PREEMPT Sat Dec 17 22:59:25 EST 2011
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-3.2.0-rc6
root=/dev/mapper/artemis-root ro quiet
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 0000000000094400 (usable)
[    0.000000]  BIOS-e820: 0000000000094400 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000009ce3f000 (usable)
[    0.000000]  BIOS-e820: 000000009ce3f000 - 000000009cebf000 (reserved)
[    0.000000]  BIOS-e820: 000000009cebf000 - 000000009cfbf000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000009cfbf000 - 000000009cfff000 (ACPI data)
[    0.000000]  BIOS-e820: 000000009cfff000 - 000000009d000000 (usable)
[    0.000000]  BIOS-e820: 000000009d000000 - 000000009fa00000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000feb00000 - 00000000feb04000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed10000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffd80000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000045fe00000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.7 present.
[    0.000000] DMI: Hewlett-Packard HP ENVY 17 Notebook PC /159B, BIOS
F.15 05/20/2011
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000
(usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x45fe00 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 080000000 mask FE0000000 write-back
[    0.000000]   2 base 09D000000 mask FFF000000 uncachable
[    0.000000]   3 base 09E000000 mask FFE000000 uncachable
[    0.000000]   4 base 0FFC00000 mask FFFC00000 write-protect
[    0.000000]   5 base 100000000 mask F00000000 write-back
[    0.000000]   6 base 200000000 mask E00000000 write-back
[    0.000000]   7 base 400000000 mask FC0000000 write-back
[    0.000000]   8 base 440000000 mask FF0000000 write-back
[    0.000000]   9 base 450000000 mask FF0000000 write-back
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] last_pfn = 0x9d000 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [ffff8800000fe1b0] fe1b0
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff88000008f000] 8f000 size 20480
[    0.000000] init_memory_mapping: 0000000000000000-000000009d000000
[    0.000000]  0000000000 - 009d000000 page 2M
[    0.000000] kernel direct mapping tables up to 9d000000 @ 1fffc000-20000000
[    0.000000] init_memory_mapping: 0000000100000000-000000045fe00000
[    0.000000]  0100000000 - 045fe00000 page 2M
[    0.000000] kernel direct mapping tables up to 45fe00000 @ 9ce2c000-9ce3f000
[    0.000000] RAMDISK: 285ce000 - 302df000
[    0.000000] ACPI: RSDP 00000000000fe020 00024 (v02 HPQOEM)
[    0.000000] ACPI: XSDT 000000009cffe120 0009C (v01 HPQOEM SLIC-MPC
00000001      01000013)
[    0.000000] ACPI: FACP 000000009cffc000 000F4 (v04 HPQOEM SLIC-MPC
00000001 MSFT 01000013)
[    0.000000] ACPI: DSDT 000000009cfec000 0C013 (v02 HP     159B
00000000 MSFT 01000013)
[    0.000000] ACPI: FACS 000000009cf6c000 00040
[    0.000000] ACPI: ASF! 000000009cffd000 000A5 (v32 HP     159B
00000001 MSFT 01000013)
[    0.000000] ACPI: HPET 000000009cffb000 00038 (v01 HP     159B
00000001 MSFT 01000013)
[    0.000000] ACPI: APIC 000000009cffa000 0008C (v02 HP     159B
00000001 MSFT 01000013)
[    0.000000] ACPI: MCFG 000000009cff9000 0003C (v01 HP     159B
00000001 MSFT 01000013)
[    0.000000] ACPI: SLIC 000000009cfeb000 00176 (v01 HPQOEM SLIC-MPC
00000001 MSFT 01000013)
[    0.000000] ACPI: MSDM 000000009cfea000 00055 (v03 HP     159B
00000001 MSFT 01000013)
[    0.000000] ACPI: WDAT 000000009cfe9000 00224 (v01 HP     159B
00000001 MSFT 01000013)
[    0.000000] ACPI: SSDT 000000009cfe8000 00D52 (v01 HP     159B
00001000 MSFT 01000013)
[    0.000000] ACPI: BOOT 000000009cfe6000 00028 (v01 HP     159B
00000001 MSFT 01000013)
[    0.000000] ACPI: ASPT 000000009cfe3000 00034 (v07 HP     159B
00000001 MSFT 01000013)
[    0.000000] ACPI: SSDT 000000009cfe2000 00780 (v01 HP     159B
00003000 INTL 20100121)
[    0.000000] ACPI: SSDT 000000009cfe1000 00996 (v01 HP     159B
00003000 INTL 20100121)
[    0.000000] ACPI: DMAR 000000009cfe0000 000E8 (v01 HP     159B
00000001 INTL 00000001)
[    0.000000] ACPI: SSDT 000000009cfde000 01713 (v01 HP     159B
00001000 INTL 20100121)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000045fe00000
[    0.000000] Initmem setup node 0 0000000000000000-000000045fe00000
[    0.000000]   NODE_DATA [000000045fdfb000 - 000000045fdfffff]
[    0.000000]  [ffffea0000000000-ffffea000f5fffff] PMD ->
[ffff88044f400000-ffff88045d5fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x0045fe00
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[4] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x00000094
[    0.000000]     0: 0x00000100 -> 0x0009ce3f
[    0.000000]     0: 0x0009cfff -> 0x0009d000
[    0.000000]     0: 0x00100000 -> 0x0045fe00
[    0.000000] On node 0 totalpages: 4180932
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 5 pages reserved
[    0.000000]   DMA zone: 3911 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 624248 pages, LIFO batch:31
[    0.000000]   Normal zone: 48377 pages used for memmap
[    0.000000]   Normal zone: 3490055 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] enabled)
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 8 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 0000000000094000 - 0000000000095000
[    0.000000] PM: Registered nosave memory: 0000000000095000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 000000009ce3f000 - 000000009cebf000
[    0.000000] PM: Registered nosave memory: 000000009cebf000 - 000000009cfbf000
[    0.000000] PM: Registered nosave memory: 000000009cfbf000 - 000000009cfff000
[    0.000000] PM: Registered nosave memory: 000000009d000000 - 000000009fa00000
[    0.000000] PM: Registered nosave memory: 000000009fa00000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000feb00000
[    0.000000] PM: Registered nosave memory: 00000000feb00000 - 00000000feb04000
[    0.000000] PM: Registered nosave memory: 00000000feb04000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec01000
[    0.000000] PM: Registered nosave memory: 00000000fec01000 - 00000000fed10000
[    0.000000] PM: Registered nosave memory: 00000000fed10000 - 00000000fed1a000
[    0.000000] PM: Registered nosave memory: 00000000fed1a000 - 00000000fed1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed20000
[    0.000000] PM: Registered nosave memory: 00000000fed20000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ffd80000
[    0.000000] PM: Registered nosave memory: 00000000ffd80000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at 9fa00000 (gap:
9fa00000:40600000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:16 nr_cpumask_bits:16
nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 476 pages/cpu @ffff88045e400000
s1919552 r8192 d21952 u2097152
[    0.000000] pcpu-alloc: s1919552 r8192 d21952 u2097152 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 [0] 4 [0] 5 [0] 6 [0] 7
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.
Total pages: 4118214
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-3.2.0-rc6
root=/dev/mapper/artemis-root ro quiet
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave/xrstor: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 16260524k/18348032k available (3904k kernel
code, 1624304k absent, 463204k reserved, 5092k data, 2556k init)
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	RCU lockdep checking is enabled.
[    0.000000] NR_IRQS:4352 nr_irqs:744 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat,
Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 6367 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] allocated 134217728 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't
want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.004000] Detected 2294.889 MHz processor.
[    0.000009] Calibrating delay loop (skipped), value calculated
using timer frequency.. 4589.77 BogoMIPS (lpj=9179556)
[    0.000023] pid_max: default: 32768 minimum: 301
[    0.000531] Security Framework initialized
[    0.006523] Dentry cache hash table entries: 2097152 (order: 12,
16777216 bytes)
[    0.017708] Inode-cache hash table entries: 1048576 (order: 11,
8388608 bytes)
[    0.021957] Mount-cache hash table entries: 256
[    0.025805] Initializing cgroup subsys cpuacct
[    0.025839] Initializing cgroup subsys memory
[    0.026048] Initializing cgroup subsys devices
[    0.026058] Initializing cgroup subsys freezer
[    0.026066] Initializing cgroup subsys net_cls
[    0.026074] Initializing cgroup subsys blkio
[    0.026420] CPU: Physical Processor ID: 0
[    0.026425] CPU: Processor Core ID: 0
[    0.026440] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.026443] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.026453] mce: CPU supports 9 MCE banks
[    0.026495] CPU0: Thermal monitoring handled by SMI
[    0.026550] using mwait in idle threads.
[    0.028271] ACPI: Core revision 20110623
[    0.113295] ftrace: allocating 20394 entries in 80 pages
[    0.137897] DMAR: Host address width 36
[    0.137906] DMAR: DRHD base: 0x000000fed90000 flags: 0x0
[    0.137959] IOMMU 0: reg_base_addr fed90000 ver 1:0 cap
c0000020e60262 ecap f0101a
[    0.137966] DMAR: DRHD base: 0x000000fed91000 flags: 0x1
[    0.138014] IOMMU 1: reg_base_addr fed91000 ver 1:0 cap
c9008020660262 ecap f0105a
[    0.138021] DMAR: RMRR base: 0x0000009ce9c000 end: 0x0000009cebbfff
[    0.138029] DMAR: RMRR base: 0x0000009d800000 end: 0x0000009f9fffff
[    0.138159] IOAPIC id 0 under DRHD base  0xfed91000 IOMMU 1
[    0.138165] HPET id 0 under DRHD base 0xfed91000
[    0.138170] HPET id 0 under DRHD base 0xfed91000
[    0.138175] HPET id 0 under DRHD base 0xfed91000
[    0.138180] HPET id 0 under DRHD base 0xfed91000
[    0.138185] HPET id 0 under DRHD base 0xfed91000
[    0.138190] HPET id 0 under DRHD base 0xfed91000
[    0.138195] HPET id 0 under DRHD base 0xfed91000
[    0.138200] HPET id 0 under DRHD base 0xfed91000
[    0.138738] Enabled IRQ remapping in x2apic mode
[    0.138744] Enabling x2apic
[    0.138749] Enabled x2apic
[    0.138763] Switched APIC routing to cluster x2apic.
[    0.139949] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.179639] CPU0: Intel(R) Core(TM) i7-2820QM CPU @ 2.30GHz stepping 07
[    0.285794] Performance Events: PEBS fmt1+, SandyBridge events,
Intel PMU driver.
[    0.285812] PEBS disabled due to CPU errata.
[    0.285842] ... version:                3
[    0.285846] ... bit width:              48
[    0.285851] ... generic registers:      4
[    0.285857] ... value mask:             0000ffffffffffff
[    0.285862] ... max period:             000000007fffffff
[    0.285867] ... fixed-purpose events:   3
[    0.285872] ... event mask:             000000070000000f
[    0.298513] NMI watchdog enabled, takes one hw-pmu counter.
[    0.309920] lockdep: fixing up alternatives.
[    0.314314] Booting Node   0, Processors  #1
[    0.314323] smpboot cpu 1: start_ip = 8f000
[    0.841484] calibrate_delay_direct() dropping max bogoMips estimate
1 = 509415862
[    0.841559] CPU1: Thermal monitoring handled by SMI
[    0.862193] NMI watchdog enabled, takes one hw-pmu counter.
[    0.873563] lockdep: fixing up alternatives.
[    0.873716]  #2
[    0.873722] smpboot cpu 2: start_ip = 8f000
[    0.961473] CPU2: Thermal monitoring handled by SMI
[    0.981754] NMI watchdog enabled, takes one hw-pmu counter.
[    0.993460] lockdep: fixing up alternatives.
[    0.993595]  #3
[    0.993600] smpboot cpu 3: start_ip = 8f000
[    1.081403] CPU3: Thermal monitoring handled by SMI
[    1.101672] NMI watchdog enabled, takes one hw-pmu counter.
[    1.113396] lockdep: fixing up alternatives.
[    1.113532]  #4
[    1.113537] smpboot cpu 4: start_ip = 8f000
[    1.201338] CPU4: Thermal monitoring handled by SMI
[    1.221588] NMI watchdog enabled, takes one hw-pmu counter.
[    1.233320] lockdep: fixing up alternatives.
[    1.233474]  #5
[    1.233479] smpboot cpu 5: start_ip = 8f000
[    1.321266] CPU5: Thermal monitoring handled by SMI
[    1.341608] NMI watchdog enabled, takes one hw-pmu counter.
[    1.353257] lockdep: fixing up alternatives.
[    1.353393]  #6
[    1.353398] smpboot cpu 6: start_ip = 8f000
[    1.441203] CPU6: Thermal monitoring handled by SMI
[    1.461455] NMI watchdog enabled, takes one hw-pmu counter.
[    1.473183] lockdep: fixing up alternatives.
[    1.473325]  #7 Ok.
[    1.473330] smpboot cpu 7: start_ip = 8f000
[    1.561132] CPU7: Thermal monitoring handled by SMI
[    1.581402] NMI watchdog enabled, takes one hw-pmu counter.
[    1.585101] Brought up 8 CPUs
[    1.585109] Total of 8 processors activated (36714.73 BogoMIPS).
[    1.614767] devtmpfs: initialized
[    1.634385] PM: Registering ACPI NVS region at 9cebf000 (1048576 bytes)
[    1.639557] print_constraints: dummy:
[    1.640675] NET: Registered protocol family 16
[    1.642487] ACPI FADT declares the system doesn't support PCIe
ASPM, so disable it
[    1.642538] ACPI: bus type pci registered
[    1.643218] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem
0xe0000000-0xefffffff] (base 0xe0000000)
[    1.643228] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    1.944768] PCI: Using configuration type 1 for base access
[    1.953478] bio: create slab <bio-0> at 0
[    1.954544] ACPI: Added _OSI(Module Device)
[    1.954556] ACPI: Added _OSI(Processor Device)
[    1.954566] ACPI: Added _OSI(3.0 _SCP Extensions)
[    1.954577] ACPI: Added _OSI(Processor Aggregator Device)
[    1.992655] ACPI: EC: Look up EC in DSDT
[    2.030772] ACPI: Executed 1 blocks of module-level executable AML code
[    2.096978] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    2.100411] ACPI: SSDT 000000009ce70798 00727 (v01  PmRef  Cpu0Cst
00003001 INTL 20100121)
[    2.110385] ACPI: Dynamic OEM Table Load:
[    2.110397] ACPI: SSDT           (null) 00727 (v01  PmRef  Cpu0Cst
00003001 INTL 20100121)
[    2.122541] ACPI: SSDT 000000009ce71a98 00303 (v01  PmRef    ApIst
00003000 INTL 20100121)
[    2.132818] ACPI: Dynamic OEM Table Load:
[    2.132829] ACPI: SSDT           (null) 00303 (v01  PmRef    ApIst
00003000 INTL 20100121)
[    2.145497] ACPI: SSDT 000000009ce6fd98 00119 (v01  PmRef    ApCst
00003000 INTL 20100121)
[    2.155305] ACPI: Dynamic OEM Table Load:
[    2.155315] ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst
00003000 INTL 20100121)
[    2.306644] ACPI: Interpreter enabled
[    2.306658] ACPI: (supports S0 S3 S4 S5)
[    2.306878] ACPI: Using IOAPIC for interrupt routing
[    2.355715] ACPI: EC: GPE = 0x16, I/O: command/status = 0x66, data = 0x62
[    2.357437] ACPI: No dock devices found.
[    2.357444] HEST: Table not found.
[    2.357454] PCI: Using host bridge windows from ACPI; if necessary,
use "pci=nocrs" and report a bug
[    2.360350] \_SB_.PCI0:_OSC invalid UUID
[    2.360357] _OSC request data:1 8 1f
[    2.360376] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-fe])
[    2.365479] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    2.365489] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    2.365496] pci_root PNP0A08:00: host bridge window [mem
0x000a0000-0x000bffff]
[    2.365506] pci_root PNP0A08:00: host bridge window [mem
0x9fa00000-0xfeafffff]
[    2.365651] pci 0000:00:00.0: [8086:0104] type 0 class 0x000600
[    2.366034] pci 0000:00:01.0: [8086:0101] type 1 class 0x000604
[    2.366255] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    2.366381] pci 0000:00:01.0: PME# disabled
[    2.366534] pci 0000:00:02.0: [8086:0126] type 0 class 0x000300
[    2.366619] pci 0000:00:02.0: reg 10: [mem 0xc0000000-0xc03fffff 64bit]
[    2.366666] pci 0000:00:02.0: reg 18: [mem 0xb0000000-0xbfffffff 64bit pref]
[    2.366698] pci 0000:00:02.0: reg 20: [io  0x4000-0x403f]
[    2.367064] pci 0000:00:16.0: [8086:1c3a] type 0 class 0x000780
[    2.367165] pci 0000:00:16.0: reg 10: [mem 0xc1704000-0xc170400f 64bit]
[    2.367442] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    2.367461] pci 0000:00:16.0: PME# disabled
[    2.367632] pci 0000:00:1a.0: [8086:1c2d] type 0 class 0x000c03
[    2.368209] pci 0000:00:1a.0: reg 10: [mem 0xc1709000-0xc17093ff]
[    2.371293] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    2.371312] pci 0000:00:1a.0: PME# disabled
[    2.371437] pci 0000:00:1b.0: [8086:1c20] type 0 class 0x000403
[    2.371513] pci 0000:00:1b.0: reg 10: [mem 0xc1700000-0xc1703fff 64bit]
[    2.371806] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    2.371824] pci 0000:00:1b.0: PME# disabled
[    2.371939] pci 0000:00:1c.0: [8086:1c10] type 1 class 0x000604
[    2.372240] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    2.372259] pci 0000:00:1c.0: PME# disabled
[    2.372377] pci 0000:00:1c.1: [8086:1c12] type 1 class 0x000604
[    2.372703] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    2.372722] pci 0000:00:1c.1: PME# disabled
[    2.372841] pci 0000:00:1c.2: [8086:1c14] type 1 class 0x000604
[    2.373158] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    2.373177] pci 0000:00:1c.2: PME# disabled
[    2.373345] pci 0000:00:1d.0: [8086:1c26] type 0 class 0x000c03
[    2.373895] pci 0000:00:1d.0: reg 10: [mem 0xc1708000-0xc17083ff]
[    2.376973] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    2.376992] pci 0000:00:1d.0: PME# disabled
[    2.377101] pci 0000:00:1f.0: [8086:1c4b] type 0 class 0x000601
[    2.377574] pci 0000:00:1f.2: [8086:282a] type 0 class 0x000104
[    2.377676] pci 0000:00:1f.2: reg 10: [io  0x4088-0x408f]
[    2.377717] pci 0000:00:1f.2: reg 14: [io  0x4094-0x4097]
[    2.377758] pci 0000:00:1f.2: reg 18: [io  0x4080-0x4087]
[    2.377799] pci 0000:00:1f.2: reg 1c: [io  0x4090-0x4093]
[    2.377839] pci 0000:00:1f.2: reg 20: [io  0x4060-0x407f]
[    2.377880] pci 0000:00:1f.2: reg 24: [mem 0xc1707000-0xc17077ff]
[    2.378069] pci 0000:00:1f.2: PME# supported from D3hot
[    2.378087] pci 0000:00:1f.2: PME# disabled
[    2.378180] pci 0000:00:1f.3: [8086:1c22] type 0 class 0x000c05
[    2.378258] pci 0000:00:1f.3: reg 10: [mem 0xc1705000-0xc17050ff 64bit]
[    2.378367] pci 0000:00:1f.3: reg 20: [io  0x4040-0x405f]
[    2.378751] pci 0000:01:00.0: [1002:68a8] type 0 class 0x000300
[    2.378820] pci 0000:01:00.0: reg 10: [mem 0xa0000000-0xafffffff 64bit pref]
[    2.378877] pci 0000:01:00.0: reg 18: [mem 0xc0700000-0xc071ffff 64bit]
[    2.378916] pci 0000:01:00.0: reg 20: [io  0x3000-0x30ff]
[    2.378986] pci 0000:01:00.0: reg 30: [mem 0xfffe0000-0xffffffff pref]
[    2.379090] pci 0000:01:00.0: supports D1 D2
[    2.379211] pci 0000:01:00.1: [1002:aa58] type 0 class 0x000403
[    2.379280] pci 0000:01:00.1: reg 10: [mem 0xc0720000-0xc0723fff 64bit]
[    2.379540] pci 0000:01:00.1: supports D1 D2
[    2.379867] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    2.379882] pci 0000:00:01.0:   bridge window [io  0x3000-0x3fff]
[    2.379895] pci 0000:00:01.0:   bridge window [mem 0xc0700000-0xc16fffff]
[    2.379917] pci 0000:00:01.0:   bridge window [mem
0xa0000000-0xafffffff 64bit pref]
[    2.380403] pci 0000:02:00.0: [8086:4239] type 0 class 0x000280
[    2.380718] pci 0000:02:00.0: reg 10: [mem 0xc0600000-0xc0601fff 64bit]
[    2.381961] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    2.382029] pci 0000:02:00.0: PME# disabled
[    2.382435] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    2.382462] pci 0000:00:1c.0:   bridge window [mem 0xc0600000-0xc06fffff]
[    2.382842] pci 0000:03:00.0: [10ec:8168] type 0 class 0x000200
[    2.382951] pci 0000:03:00.0: reg 10: [io  0x2000-0x20ff]
[    2.383145] pci 0000:03:00.0: reg 18: [mem 0xc0404000-0xc0404fff 64bit pref]
[    2.383265] pci 0000:03:00.0: reg 20: [mem 0xc0400000-0xc0403fff 64bit pref]
[    2.383613] pci 0000:03:00.0: supports D1 D2
[    2.383619] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    2.383648] pci 0000:03:00.0: PME# disabled
[    2.383924] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    2.383941] pci 0000:00:1c.1:   bridge window [io  0x2000-0x2fff]
[    2.383978] pci 0000:00:1c.1:   bridge window [mem
0xc0400000-0xc04fffff 64bit pref]
[    2.384329] pci 0000:04:00.0: [1033:0194] type 0 class 0x000c03
[    2.384413] pci 0000:04:00.0: reg 10: [mem 0xc0500000-0xc0501fff 64bit]
[    2.384880] pci 0000:04:00.0: PME# supported from D0 D3hot D3cold
[    2.384901] pci 0000:04:00.0: PME# disabled
[    2.385063] pci 0000:00:1c.2: PCI bridge to [bus 04-04]
[    2.385090] pci 0000:00:1c.2:   bridge window [mem 0xc0500000-0xc05fffff]
[    2.385209] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    2.386974] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    2.387268] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    2.387626] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
[    2.387958] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEG0._PRT]
[    2.388729] \_SB_.PCI0:_OSC invalid UUID
[    2.388735] _OSC request data:1 1f 1f
[    2.388754]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    2.389086] \_SB_.PCI0:_OSC invalid UUID
[    2.389092] _OSC request data:1 0 1d
[    2.389109]  pci0000:00: ACPI _OSC request failed (AE_ERROR),
returned control mask: 0x1d
[    2.389115] ACPI _OSC control for PCIe not granted, disabling ASPM
[    2.421246] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 10 *11 12 14 15)
[    2.421693] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 10 *11 12 14 15)
[    2.422128] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 10 *11 12 14 15)
[    2.422560] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 *10 11 12 14 15)
[    2.422991] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 10 11
12 14 15) *0, disabled.
[    2.423425] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 10 11
12 14 15) *0, disabled.
[    2.423857] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 10 *11 12 14 15)
[    2.424287] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 10 11
12 14 15) *0, disabled.
[    2.425943] vgaarb: device added:
PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    2.426042] vgaarb: device added:
PCI:0000:01:00.0,decodes=io+mem,owns=none,locks=none
[    2.426083] vgaarb: loaded
[    2.426088] vgaarb: bridge control possible 0000:01:00.0
[    2.426093] vgaarb: no bridge control possible 0000:00:02.0
[    2.426586] PCI: Using ACPI for IRQ routing
[    2.455342] PCI: pci_cache_line_size set to 64 bytes
[    2.455867] reserve RAM buffer: 0000000000094400 - 000000000009ffff
[    2.455878] reserve RAM buffer: 000000009ce3f000 - 000000009fffffff
[    2.455895] reserve RAM buffer: 000000009d000000 - 000000009fffffff
[    2.455905] reserve RAM buffer: 000000045fe00000 - 000000045fffffff
[    2.457608] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    2.457637] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    2.459799] Switching to clocksource hpet
[    2.584175] pnp: PnP ACPI init
[    2.584335] ACPI: bus type pnp registered
[    2.586793] pnp 00:00: [bus 00-fe]
[    2.586803] pnp 00:00: [io  0x0000-0x0cf7 window]
[    2.586811] pnp 00:00: [io  0x0cf8-0x0cff]
[    2.586818] pnp 00:00: [io  0x0d00-0xffff window]
[    2.586826] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    2.586833] pnp 00:00: [mem 0x000c0000-0x000c3fff window]
[    2.586840] pnp 00:00: [mem 0x000c4000-0x000c7fff window]
[    2.586847] pnp 00:00: [mem 0x000c8000-0x000cbfff window]
[    2.586855] pnp 00:00: [mem 0x000cc000-0x000cffff window]
[    2.586862] pnp 00:00: [mem 0x000d0000-0x000d3fff window]
[    2.586869] pnp 00:00: [mem 0x000d4000-0x000d7fff window]
[    2.586876] pnp 00:00: [mem 0x000d8000-0x000dbfff window]
[    2.586883] pnp 00:00: [mem 0x000dc000-0x000dffff window]
[    2.586890] pnp 00:00: [mem 0x000e0000-0x000e3fff window]
[    2.586897] pnp 00:00: [mem 0x000e4000-0x000e7fff window]
[    2.586904] pnp 00:00: [mem 0x000e8000-0x000ebfff window]
[    2.586911] pnp 00:00: [mem 0x000ec000-0x000effff window]
[    2.586918] pnp 00:00: [mem 0x000f0000-0x000fffff window]
[    2.586926] pnp 00:00: [mem 0x9fa00000-0xfeafffff window]
[    2.587476] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08
PNP0a03 (active)
[    2.587667] pnp 00:01: [io  0x0000-0x001f]
[    2.587674] pnp 00:01: [io  0x0081-0x0091]
[    2.587681] pnp 00:01: [io  0x0093-0x009f]
[    2.587687] pnp 00:01: [io  0x00c0-0x00df]
[    2.587694] pnp 00:01: [dma 4]
[    2.588029] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    2.588094] pnp 00:02: [mem 0xff000000-0xffffffff]
[    2.588378] pnp 00:02: Plug and Play ACPI device, IDs INT0800 (active)
[    2.588812] pnp 00:03: [mem 0xfed00000-0xfed003ff]
[    2.589104] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
[    2.589199] pnp 00:04: [io  0x00f0]
[    2.589249] pnp 00:04: [irq 13]
[    2.589545] pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
[    2.589624] pnp 00:05: [io  0x002e-0x002f]
[    2.589631] pnp 00:05: [io  0x004e-0x004f]
[    2.589637] pnp 00:05: [io  0x0061]
[    2.589643] pnp 00:05: [io  0x0063]
[    2.589650] pnp 00:05: [io  0x0065]
[    2.589656] pnp 00:05: [io  0x0067]
[    2.589661] pnp 00:05: [io  0x0070]
[    2.589667] pnp 00:05: [io  0x0080]
[    2.589673] pnp 00:05: [io  0x0092]
[    2.589679] pnp 00:05: [io  0x00b2-0x00b3]
[    2.589685] pnp 00:05: [io  0x0680-0x069f]
[    2.589691] pnp 00:05: [io  0x1000-0x100f]
[    2.589698] pnp 00:05: [io  0x1010-0x1013]
[    2.589704] pnp 00:05: [io  0xffff]
[    2.589710] pnp 00:05: [io  0x0400-0x0453]
[    2.589716] pnp 00:05: [io  0x0458-0x047f]
[    2.589722] pnp 00:05: [io  0x0500-0x057f]
[    2.589728] pnp 00:05: [io  0x164e-0x164f]
[    2.589734] pnp 00:05: [io  0x0380-0x0387]
[    2.589740] pnp 00:05: [io  0x0068-0x006f]
[    2.590275] system 00:05: [io  0x0680-0x069f] has been reserved
[    2.590287] system 00:05: [io  0x1000-0x100f] has been reserved
[    2.590297] system 00:05: [io  0x1010-0x1013] has been reserved
[    2.590307] system 00:05: [io  0xffff] has been reserved
[    2.590318] system 00:05: [io  0x0400-0x0453] has been reserved
[    2.590328] system 00:05: [io  0x0458-0x047f] has been reserved
[    2.590338] system 00:05: [io  0x0500-0x057f] has been reserved
[    2.590348] system 00:05: [io  0x164e-0x164f] has been reserved
[    2.590358] system 00:05: [io  0x0380-0x0387] has been reserved
[    2.590378] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    2.590442] pnp 00:06: [io  0x0070-0x0077]
[    2.590482] pnp 00:06: [irq 8]
[    2.590851] pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
[    2.590999] pnp 00:07: [io  0x0060]
[    2.591006] pnp 00:07: [io  0x0064]
[    2.591044] pnp 00:07: [irq 1]
[    2.591408] pnp 00:07: Plug and Play ACPI device, IDs PNP0303 (active)
[    2.591545] pnp 00:08: [irq 12]
[    2.591967] pnp 00:08: Plug and Play ACPI device, IDs SYN1e34
SYN1e00 SYN0002 PNP0f13 (active)
[    2.592201] pnp 00:09: [irq 23]
[    2.592528] pnp 00:09: Plug and Play ACPI device, IDs HPQ0004 (active)
[    2.593224] pnp 00:0a: [mem 0xfed1c000-0xfed1ffff]
[    2.593232] pnp 00:0a: [mem 0xfed10000-0xfed17fff]
[    2.593239] pnp 00:0a: [mem 0xfed18000-0xfed18fff]
[    2.593246] pnp 00:0a: [mem 0xfed19000-0xfed19fff]
[    2.593253] pnp 00:0a: [mem 0xe0000000-0xefffffff]
[    2.593259] pnp 00:0a: [mem 0xfed20000-0xfed3ffff]
[    2.593266] pnp 00:0a: [mem 0xfed90000-0xfed93fff]
[    2.593273] pnp 00:0a: [mem 0xff000000-0xffffffff]
[    2.593279] pnp 00:0a: [mem 0xfee00000-0xfeefffff]
[    2.593286] pnp 00:0a: [mem 0x9fa00000-0x9fa00fff]
[    2.593805] system 00:0a: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    2.593817] system 00:0a: [mem 0xfed10000-0xfed17fff] has been reserved
[    2.593827] system 00:0a: [mem 0xfed18000-0xfed18fff] has been reserved
[    2.593838] system 00:0a: [mem 0xfed19000-0xfed19fff] has been reserved
[    2.593849] system 00:0a: [mem 0xe0000000-0xefffffff] has been reserved
[    2.593859] system 00:0a: [mem 0xfed20000-0xfed3ffff] has been reserved
[    2.593870] system 00:0a: [mem 0xfed90000-0xfed93fff] has been reserved
[    2.593882] system 00:0a: [mem 0xff000000-0xffffffff] could not be reserved
[    2.593895] system 00:0a: [mem 0xfee00000-0xfeefffff] could not be reserved
[    2.593905] system 00:0a: [mem 0x9fa00000-0x9fa00fff] has been reserved
[    2.593923] system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
[    2.595816] pnp 00:0b: [mem 0x20000000-0x201fffff]
[    2.595824] pnp 00:0b: [mem 0x40000000-0x401fffff]
[    2.596512] system 00:0b: [mem 0x20000000-0x201fffff] could not be reserved
[    2.596524] system 00:0b: [mem 0x40000000-0x401fffff] could not be reserved
[    2.596542] system 00:0b: Plug and Play ACPI device, IDs PNP0c01 (active)
[    2.596668] pnp: PnP ACPI: found 12 devices
[    2.596675] ACPI: ACPI bus type pnp unregistered
[    2.622128] pci 0000:01:00.0: no compatible bridge window for [mem
0xfffe0000-0xffffffff pref]
[    2.622174] PCI: max bus depth: 1 pci_try_num: 2
[    2.622313] pci 0000:01:00.0: BAR 6: assigned [mem
0xc0740000-0xc075ffff pref]
[    2.622322] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    2.622333] pci 0000:00:01.0:   bridge window [io  0x3000-0x3fff]
[    2.622350] pci 0000:00:01.0:   bridge window [mem 0xc0700000-0xc16fffff]
[    2.622365] pci 0000:00:01.0:   bridge window [mem
0xa0000000-0xafffffff 64bit pref]
[    2.622387] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    2.622408] pci 0000:00:1c.0:   bridge window [mem 0xc0600000-0xc06fffff]
[    2.622443] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    2.622454] pci 0000:00:1c.1:   bridge window [io  0x2000-0x2fff]
[    2.622485] pci 0000:00:1c.1:   bridge window [mem
0xc0400000-0xc04fffff 64bit pref]
[    2.622512] pci 0000:00:1c.2: PCI bridge to [bus 04-04]
[    2.622532] pci 0000:00:1c.2:   bridge window [mem 0xc0500000-0xc05fffff]
[    2.622640] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.622656] pci 0000:00:01.0: setting latency timer to 64
[    2.622724] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    2.622740] pci 0000:00:1c.0: setting latency timer to 64
[    2.622771] pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    2.622788] pci 0000:00:1c.1: setting latency timer to 64
[    2.622856] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    2.622872] pci 0000:00:1c.2: setting latency timer to 64
[    2.622885] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    2.622892] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    2.622898] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    2.622905] pci_bus 0000:00: resource 7 [mem 0x9fa00000-0xfeafffff]
[    2.622912] pci_bus 0000:01: resource 0 [io  0x3000-0x3fff]
[    2.622918] pci_bus 0000:01: resource 1 [mem 0xc0700000-0xc16fffff]
[    2.622925] pci_bus 0000:01: resource 2 [mem 0xa0000000-0xafffffff
64bit pref]
[    2.622932] pci_bus 0000:02: resource 1 [mem 0xc0600000-0xc06fffff]
[    2.622939] pci_bus 0000:03: resource 0 [io  0x2000-0x2fff]
[    2.622946] pci_bus 0000:03: resource 2 [mem 0xc0400000-0xc04fffff
64bit pref]
[    2.622953] pci_bus 0000:04: resource 1 [mem 0xc0500000-0xc05fffff]
[    2.623595] NET: Registered protocol family 2
[    2.625766] IP route cache hash table entries: 524288 (order: 10,
4194304 bytes)
[    2.632321] TCP established hash table entries: 524288 (order: 11,
8388608 bytes)
[    2.637525] TCP bind hash table entries: 65536 (order: 10, 5242880 bytes)
[    2.652334] TCP: Hash tables configured (established 524288 bind 65536)
[    2.652401] TCP reno registered
[    2.652925] UDP hash table entries: 8192 (order: 8, 1572864 bytes)
[    2.657183] UDP-Lite hash table entries: 8192 (order: 8, 1572864 bytes)
[    2.661816] NET: Registered protocol family 1
[    2.661924] pci 0000:00:02.0: Boot video device
[    2.707778] PCI: CLS 64 bytes, default 64
[    2.708461] Unpacking initramfs...
[   11.042642] Freeing initrd memory: 128068k freed
[   11.096002] DMAR: No ATSR found
[   11.096371] IOMMU 0 0xfed90000: using Queued invalidation
[   11.096378] IOMMU 1 0xfed91000: using Queued invalidation
[   11.096416] IOMMU: Setting RMRR:
[   11.096581] IOMMU: Setting identity map for device 0000:00:02.0
[0x9d800000 - 0x9f9fffff]
[   11.097299] IOMMU: Setting identity map for device 0000:00:1d.0
[0x9ce9c000 - 0x9cebbfff]
[   11.097400] IOMMU: Setting identity map for device 0000:00:1a.0
[0x9ce9c000 - 0x9cebbfff]
[   11.097459] IOMMU: Prepare 0-16MiB unity mapping for LPC
[   11.097556] IOMMU: Setting identity map for device 0000:00:1f.0
[0x0 - 0xffffff]
[   11.098074] PCI-DMA: Intel(R) Virtualization Technology for Directed I/O
[   11.110097] Simple Boot Flag at 0x44 set to 0x1
[   11.116357] audit: initializing netlink socket (disabled)
[   11.116495] type=2000 audit(1324190379.416:1): initialized
[   11.199058] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[   11.280933] VFS: Disk quotas dquot_6.5.2
[   11.281378] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[   11.282711] msgmni has been set to 32137
[   11.284707] alg: No test for stdrng (krng)
[   11.284933] Block layer SCSI generic (bsg) driver version 0.4
loaded (major 253)
[   11.284993] io scheduler noop registered
[   11.285000] io scheduler deadline registered
[   11.285206] io scheduler cfq registered (default)
[   11.286275] pcieport 0000:00:01.0: setting latency timer to 64
[   11.286631] pcieport 0000:00:01.0: irq 42 for MSI/MSI-X
[   11.289658] intel_idle: MWAIT substates: 0x21120
[   11.289665] intel_idle: v0.4 model 0x2A
[   11.289670] intel_idle: lapic_timer_reliable_states 0xffffffff
[   11.290354] ERST: Table is not found!
[   11.290359] GHES: HEST is not enabled!
[   11.290783] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[   11.545084] Linux agpgart interface v0.103
[   11.546943] agpgart-intel 0000:00:00.0: Intel Sandybridge Chipset
[   11.547708] agpgart-intel 0000:00:00.0: detected gtt size: 2097152K
total, 262144K mappable
[   11.553672] agpgart-intel 0000:00:00.0: detected 32768K stolen memory
[   11.554427] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xb0000000
[   11.555346] arcnet loaded.
[   11.555674] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M]
at 0x60,0x64 irq 1,12
[   11.565610] serio: i8042 KBD port at 0x60,0x64 irq 1
[   11.566518] serio: i8042 AUX port at 0x60,0x64 irq 12
[   11.567668] mousedev: PS/2 mouse device common for all mice
[   11.568615] rtc_cmos 00:06: RTC can wake from S4
[   11.569636] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
[   11.569738] rtc0: alarms up to one month, 242 bytes nvram, hpet irqs
[   11.573151] cpuidle: using governor ladder
[   11.578980] cpuidle: using governor menu
[   11.581011] input: AT Translated Set 2 keyboard as
/devices/platform/i8042/serio0/input/input0
[   11.584080] TCP cubic registered
[   11.584895] NET: Registered protocol family 10
[   11.596127] Mobile IPv6
[   11.596144] NET: Registered protocol family 17
[   11.596174] Registering the dns_resolver key type
[   11.598232] PM: Hibernation image not present or could not be loaded.
[   11.598363] registered taskstats version 1
[   11.640115] rtc_cmos 00:06: setting system clock to 2011-12-18
06:39:40 UTC (1324190380)
[   11.641288] Initializing network drop monitor service
[   11.660212] Freeing unused kernel memory: 2556k freed
[   11.661278] Write protecting the kernel read-only data: 8192k
[   11.664158] Freeing unused kernel memory: 176k freed
[   11.688506] Freeing unused kernel memory: 2028k freed
[   11.976190] udevd[82]: starting version 175
[   12.098195] [Firmware Bug]: Invalid critical threshold (0)
[   12.107450] Refined TSC clocksource calibration: 2294.786 MHz.
[   12.107550] Switching to clocksource tsc
[   12.119599] thermal LNXTHERM:00: registered as thermal_zone0
[   12.119614] ACPI: Thermal Zone [TZ01] (71 C)
[   12.209522] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[   12.209608] r8169 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   12.209734] r8169 0000:03:00.0: setting latency timer to 64
[   12.209958] r8169 0000:03:00.0: irq 43 for MSI/MSI-X
[   12.229439] usbcore: registered new interface driver usbfs
[   12.229804] usbcore: registered new interface driver hub
[   12.230108] usbcore: registered new device driver usb
[   12.232894] r8169 0000:03:00.0: eth0: RTL8168e/8111e at
0xffffc90001870000, 10:1f:74:c5:c8:9d, XID 0c200000 IRQ 43
[   12.232915] r8169 0000:03:00.0: eth0: jumbo features [frames: 9200
bytes, tx checksumming: ko]
[   12.237653] SCSI subsystem initialized
[   12.242707] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   12.242930] ehci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   12.243036] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[   12.243050] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[   12.244806] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned
bus number 1
[   12.245117] ehci_hcd 0000:00:1a.0: debug port 2
[   12.249034] ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
[   12.249255] ehci_hcd 0000:00:1a.0: irq 16, io mem 0xc1709000
[   12.259383] libata version 3.00 loaded.
[   12.262983] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[   12.264080] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[   12.264098] usb usb1: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[   12.264120] usb usb1: Product: EHCI Host Controller
[   12.264131] usb usb1: Manufacturer: Linux 3.2.0-rc6 ehci_hcd
[   12.264141] usb usb1: SerialNumber: 0000:00:1a.0
[   12.272378] hub 1-0:1.0: USB hub found
[   12.272538] hub 1-0:1.0: 2 ports detected
[   12.280105] ehci_hcd 0000:00:1d.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[   12.280306] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[   12.280328] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[   12.280772] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned
bus number 2
[   12.281027] ehci_hcd 0000:00:1d.0: debug port 2
[   12.284961] ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
[   12.285158] ehci_hcd 0000:00:1d.0: irq 21, io mem 0xc1708000
[   12.292143] xhci_hcd 0000:04:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[   12.292260] xhci_hcd 0000:04:00.0: setting latency timer to 64
[   12.292275] xhci_hcd 0000:04:00.0: xHCI Host Controller
[   12.292435] xhci_hcd 0000:04:00.0: new USB bus registered, assigned
bus number 3
[   12.293064] xhci_hcd 0000:04:00.0: irq 18, io mem 0xc0500000
[   12.293385] xhci_hcd 0000:04:00.0: irq 44 for MSI/MSI-X
[   12.293437] xhci_hcd 0000:04:00.0: irq 45 for MSI/MSI-X
[   12.293489] xhci_hcd 0000:04:00.0: irq 46 for MSI/MSI-X
[   12.293540] xhci_hcd 0000:04:00.0: irq 47 for MSI/MSI-X
[   12.293592] xhci_hcd 0000:04:00.0: irq 48 for MSI/MSI-X
[   12.293641] xhci_hcd 0000:04:00.0: irq 49 for MSI/MSI-X
[   12.293693] xhci_hcd 0000:04:00.0: irq 50 for MSI/MSI-X
[   12.293743] xhci_hcd 0000:04:00.0: irq 51 for MSI/MSI-X
[   12.294782] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
[   12.294790] usb usb3: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[   12.294797] usb usb3: Product: xHCI Host Controller
[   12.294848] usb usb3: Manufacturer: Linux 3.2.0-rc6 xhci_hcd
[   12.294859] usb usb3: SerialNumber: 0000:04:00.0
[   12.297748] xHCI xhci_add_endpoint called for root hub
[   12.297759] xHCI xhci_check_bandwidth called for root hub
[   12.298317] hub 3-0:1.0: USB hub found
[   12.298519] hub 3-0:1.0: 2 ports detected
[   12.298885] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[   12.301023] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[   12.301041] usb usb2: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[   12.301055] usb usb2: Product: EHCI Host Controller
[   12.301067] xhci_hcd 0000:04:00.0: xHCI Host Controller
[   12.301082] usb usb2: Manufacturer: Linux 3.2.0-rc6 ehci_hcd
[   12.301095] usb usb2: SerialNumber: 0000:00:1d.0
[   12.304881] hub 2-0:1.0: USB hub found
[   12.304982] hub 2-0:1.0: 2 ports detected
[   12.307499] xhci_hcd 0000:04:00.0: new USB bus registered, assigned
bus number 4
[   12.307689] ahci 0000:00:1f.2: version 3.0
[   12.307794] ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[   12.307845] usb usb4: New USB device found, idVendor=1d6b, idProduct=0003
[   12.307861] usb usb4: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[   12.307873] usb usb4: Product: xHCI Host Controller
[   12.307884] usb usb4: Manufacturer: Linux 3.2.0-rc6 xhci_hcd
[   12.307895] usb usb4: SerialNumber: 0000:04:00.0
[   12.308100] ahci 0000:00:1f.2: irq 52 for MSI/MSI-X
[   12.308400] ahci: SSS flag set, parallel bus scan disabled
[   12.312297] xHCI xhci_add_endpoint called for root hub
[   12.312306] xHCI xhci_check_bandwidth called for root hub
[   12.313231] hub 4-0:1.0: USB hub found
[   12.313287] hub 4-0:1.0: 2 ports detected
[   12.323014] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6
Gbps 0x33 impl RAID mode
[   12.323029] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led
clo pio slum part ems sxs apst
[   12.323049] ahci 0000:00:1f.2: setting latency timer to 64
[   12.357026] scsi0 : ahci
[   12.358467] scsi1 : ahci
[   12.359425] scsi2 : ahci
[   12.360612] scsi3 : ahci
[   12.361528] scsi4 : ahci
[   12.363043] scsi5 : ahci
[   12.364107] ata1: SATA max UDMA/133 abar m2048@0xc1707000 port
0xc1707100 irq 52
[   12.364118] ata2: SATA max UDMA/133 abar m2048@0xc1707000 port
0xc1707180 irq 52
[   12.364126] ata3: DUMMY
[   12.364131] ata4: DUMMY
[   12.364139] ata5: SATA max UDMA/133 abar m2048@0xc1707000 port
0xc1707300 irq 52
[   12.364148] ata6: SATA max UDMA/133 abar m2048@0xc1707000 port
0xc1707380 irq 52
[   12.582899] usb 1-1: new high-speed USB device number 2 using ehci_hcd
[   12.682791] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[   12.683739] ata1.00: ATA-8: INTEL SSDSC2MH250A2, PWG4, max UDMA/133
[   12.683750] ata1.00: 488397168 sectors, multi 1: LBA48 NCQ (depth 31/32), AA
[   12.684396] ata1.00: configured for UDMA/133
[   12.687240] scsi 0:0:0:0: Direct-Access     ATA      INTEL
SSDSC2MH25 PWG4 PQ: 0 ANSI: 5
[   12.715842] usb 1-1: New USB device found, idVendor=8087, idProduct=0024
[   12.715855] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[   12.717900] hub 1-1:1.0: USB hub found
[   12.718128] hub 1-1:1.0: 6 ports detected
[   12.830833] usb 2-1: new high-speed USB device number 2 using ehci_hcd
[   12.963529] usb 2-1: New USB device found, idVendor=8087, idProduct=0024
[   12.963541] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[   12.965072] hub 2-1:1.0: USB hub found
[   12.965251] hub 2-1:1.0: 8 ports detected
[   13.006630] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   13.007301] ata2.00: ATA-8: TOSHIBA MK1059GSM, GL002C, max UDMA/100
[   13.007314] ata2.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth
31/32), AA
[   13.007968] ata2.00: configured for UDMA/100
[   13.008684] scsi 1:0:0:0: Direct-Access     ATA      TOSHIBA
MK1059GS GL00 PQ: 0 ANSI: 5
[   13.038942] usb 1-1.6: new full-speed USB device number 3 using ehci_hcd
[   13.136149] usb 1-1.6: New USB device found, idVendor=03f0, idProduct=231d
[   13.136162] usb 1-1.6: New USB device strings: Mfr=1, Product=2,
SerialNumber=0
[   13.136170] usb 1-1.6: Product: HP Integrated Module
[   13.136176] usb 1-1.6: Manufacturer: Broadcom Corp
[   13.238843] usb 2-1.5: new high-speed USB device number 3 using ehci_hcd
[   13.330487] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   13.341754] ata5.00: ATAPI: hp       BDDVDRW CA30N, EC03, max UDMA/100
[   13.345738] ata5.00: configured for UDMA/100
[   13.349031] scsi 4:0:0:0: CD-ROM            hp       BDDVDRW CA30N
  EC03 PQ: 0 ANSI: 5
[   13.444024] usb 2-1.5: New USB device found, idVendor=064e, idProduct=c210
[   13.444037] usb 2-1.5: New USB device strings: Mfr=1, Product=2,
SerialNumber=3
[   13.444045] usb 2-1.5: Product: HP ENVY HD Webcam
[   13.444051] usb 2-1.5: Manufacturer: SuYin
[   13.444057] usb 2-1.5: SerialNumber: HF1014-P80A-OV05-VH-R01.01.01
[   13.670276] ata6: SATA link down (SStatus 0 SControl 300)
[   13.715616] sd 0:0:0:0: [sda] 488397168 512-byte logical blocks:
(250 GB/232 GiB)
[   13.716039] sd 1:0:0:0: [sdb] 1953525168 512-byte logical blocks:
(1.00 TB/931 GiB)
[   13.716065] sd 1:0:0:0: [sdb] 4096-byte physical blocks
[   13.716527] sd 0:0:0:0: [sda] Write Protect is off
[   13.716540] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   13.716677] sd 1:0:0:0: [sdb] Write Protect is off
[   13.716690] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   13.716757] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[   13.716899] sd 1:0:0:0: [sdb] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[   13.732946] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw
xa/form2 cdda tray
[   13.732960] cdrom: Uniform CD-ROM driver Revision: 3.20
[   13.733434]  sda: sda1 sda2 sda3 sda4
[   13.737214] sr 4:0:0:0: Attached scsi CD-ROM sr0
[   13.740355] sd 0:0:0:0: [sda] Attached SCSI disk
[   14.140419]  sdb: sdb1 sdb2 sdb3 sdb4
[   14.145419] sd 1:0:0:0: [sdb] Attached SCSI disk
[   15.604438] device-mapper: uevent: version 1.0.3
[   15.605103] device-mapper: ioctl: 4.22.0-ioctl (2011-10-19)
initialised: dm-devel@redhat.com
[   21.752829] alg: No test for __gcm-aes-aesni (__driver-gcm-aes-aesni)
[   23.474698] PM: Starting manual resume from disk
[   23.474709] PM: Hibernation image partition 254:1 present
[   23.474711] PM: Looking for hibernation image.
[   23.475171] PM: Image not found (code -22)
[   23.475175] PM: Hibernation image not present or could not be loaded.
[   23.509110] EXT4-fs (dm-2): INFO: recovery required on readonly filesystem
[   23.509114] EXT4-fs (dm-2): write access will be enabled during recovery
[   23.722349] EXT4-fs (dm-2): orphan cleanup on readonly fs
[   23.722376] EXT4-fs (dm-2): ext4_orphan_cleanup: deleting
unreferenced inode 799666
[   23.723138] EXT4-fs (dm-2): ext4_orphan_cleanup: deleting
unreferenced inode 800880
[   23.723239] EXT4-fs (dm-2): ext4_orphan_cleanup: deleting
unreferenced inode 800879
[   23.723307] EXT4-fs (dm-2): ext4_orphan_cleanup: deleting
unreferenced inode 2490555
[   23.723376] EXT4-fs (dm-2): ext4_orphan_cleanup: deleting
unreferenced inode 3409321
[   23.723420] EXT4-fs (dm-2): ext4_orphan_cleanup: deleting
unreferenced inode 3409319
[   23.723462] EXT4-fs (dm-2): ext4_orphan_cleanup: deleting
unreferenced inode 3409314
[   23.723501] EXT4-fs (dm-2): ext4_orphan_cleanup: deleting
unreferenced inode 3409260
[   23.723548] EXT4-fs (dm-2): ext4_orphan_cleanup: deleting
unreferenced inode 3408996
[   23.723588] EXT4-fs (dm-2): ext4_orphan_cleanup: deleting
unreferenced inode 3408930
[   23.723635] EXT4-fs (dm-2): ext4_orphan_cleanup: deleting
unreferenced inode 3408723
[   23.723684] EXT4-fs (dm-2): ext4_orphan_cleanup: deleting
unreferenced inode 3408564
[   23.723730] EXT4-fs (dm-2): ext4_orphan_cleanup: deleting
unreferenced inode 3408219
[   23.723768] EXT4-fs (dm-2): ext4_orphan_cleanup: deleting
unreferenced inode 3408214
[   23.723812] EXT4-fs (dm-2): ext4_orphan_cleanup: deleting
unreferenced inode 3408115
[   23.723852] EXT4-fs (dm-2): ext4_orphan_cleanup: deleting
unreferenced inode 3408088
[   23.723899] EXT4-fs (dm-2): ext4_orphan_cleanup: deleting
unreferenced inode 3407990
[   23.723938] EXT4-fs (dm-2): ext4_orphan_cleanup: deleting
unreferenced inode 3407958
[   23.723986] EXT4-fs (dm-2): ext4_orphan_cleanup: deleting
unreferenced inode 799762
[   23.724026] EXT4-fs (dm-2): ext4_orphan_cleanup: deleting
unreferenced inode 799807
[   23.724059] EXT4-fs (dm-2): 20 orphan inodes deleted
[   23.724062] EXT4-fs (dm-2): recovery complete
[   23.738609] EXT4-fs (dm-2): mounted filesystem with ordered data
mode. Opts: (null)
[   24.541359] udevd[389]: starting version 175
[   24.650565] input: Lid Switch as
/devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input1
[   24.650941] ACPI: Lid Switch [LID0]
[   24.651219] input: Power Button as
/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input2
[   24.651237] ACPI: Power Button [PWRB]
[   24.654310] input: Power Button as
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[   24.654323] ACPI: Power Button [PWRF]
[   24.670529] iTCO_vendor_support: vendor-support=0
[   24.680666] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.07
[   24.688153] iTCO_wdt: Found a Cougar Point TCO device (Version=2,
TCOBASE=0x0460)
[   24.690441] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[   24.723315] i801_smbus 0000:00:1f.3: PCI INT B -> GSI 19 (level,
low) -> IRQ 19
[   24.750857] ACPI: Battery Slot [BAT0] (battery present)
[   24.757203] ACPI: AC Adapter [ACAD] (on-line)
[   24.762422] cfg80211: Calling CRDA to update world regulatory domain
[   24.767481] wmi: Mapper loaded
[   24.779196] hp_accel: laptop model unknown, using default axes configuration
[   24.784929] lis3lv02d: 8 bits 3DC sensor found
[   24.824506] input: PC Speaker as /devices/platform/pcspkr/input/input4
[   24.834296] input: ST LIS3LV02DL Accelerometer as
/devices/platform/lis3lv02d/input/input5
[   24.835294] Registered led device: hp::hddprotect
[   24.835391] hp_accel: driver loaded
[   24.874392] [drm] Initialized drm 1.1.0 20060810
[   25.090840] ACPI Error: Field [D128] at 1040 exceeds Buffer [NULL]
size 160 (bits) (20110623/dsopcode-236)
[   25.090856] ACPI Error: Method parse/execution failed
[\_SB_.WMID.HWMC] (Node ffff880446091f88), AE_AML_BUFFER_LIMIT
(20110623/psparse-536)
[   25.090879] ACPI Error: Method parse/execution failed
[\_SB_.WMID.WMAD] (Node ffff880446091c18), AE_AML_BUFFER_LIMIT
(20110623/psparse-536)
[   25.091021] ACPI Error: Field [D128] at 1040 exceeds Buffer [NULL]
size 160 (bits) (20110623/dsopcode-236)
[   25.091033] ACPI Error: Method parse/execution failed
[\_SB_.WMID.HWMC] (Node ffff880446091f88), AE_AML_BUFFER_LIMIT
(20110623/psparse-536)
[   25.091059] ACPI Error: Method parse/execution failed
[\_SB_.WMID.WMAD] (Node ffff880446091c18), AE_AML_BUFFER_LIMIT
(20110623/psparse-536)
[   25.092560] input: HP WMI hotkeys as /devices/virtual/input/input6
[   25.095856] ACPI Error: Field [D128] at 1040 exceeds Buffer [NULL]
size 160 (bits) (20110623/dsopcode-236)
[   25.095876] ACPI Error: Method parse/execution failed
[\_SB_.WMID.HWMC] (Node ffff880446091f88), AE_AML_BUFFER_LIMIT
(20110623/psparse-536)
[   25.095903] ACPI Error: Method parse/execution failed
[\_SB_.WMID.WMAD] (Node ffff880446091c18), AE_AML_BUFFER_LIMIT
(20110623/psparse-536)
[   25.096050] ACPI Error: Field [D128] at 1040 exceeds Buffer [NULL]
size 160 (bits) (20110623/dsopcode-236)
[   25.096063] ACPI Error: Method parse/execution failed
[\_SB_.WMID.HWMC] (Node ffff880446091f88), AE_AML_BUFFER_LIMIT
(20110623/psparse-536)
[   25.096090] ACPI Error: Method parse/execution failed
[\_SB_.WMID.WMAD] (Node ffff880446091c18), AE_AML_BUFFER_LIMIT
(20110623/psparse-536)
[   25.152785] Bluetooth: Core ver 2.16
[   25.152832] NET: Registered protocol family 31
[   25.152835] Bluetooth: HCI device and connection manager initialized
[   25.152904] Bluetooth: HCI socket layer initialized
[   25.152908] Bluetooth: L2CAP socket layer initialized
[   25.152958] Bluetooth: SCO socket layer initialized
[   25.159739] Linux media interface: v0.10
[   25.185727] Bluetooth: Generic Bluetooth USB driver ver 0.6
[   25.187506] usbcore: registered new interface driver btusb
[   25.217178] Linux video capture interface: v2.00
[   25.226554] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   25.226562] i915 0000:00:02.0: setting latency timer to 64
[   25.274282] uvcvideo: Found UVC 1.00 device HP ENVY HD Webcam (064e:c210)
[   25.276059] Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:
[   25.276065] Copyright(c) 2003-2011 Intel Corporation
[   25.276215] iwlwifi 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   25.276227] iwlwifi 0000:02:00.0: setting latency timer to 64
[   25.276270] iwlwifi 0000:02:00.0: pci_resource_len = 0x00002000
[   25.276273] iwlwifi 0000:02:00.0: pci_resource_base = ffffc90012ca4000
[   25.276276] iwlwifi 0000:02:00.0: HW Revision ID = 0x3E
[   25.276394] iwlwifi 0000:02:00.0: irq 53 for MSI/MSI-X
[   25.276555] iwlwifi 0000:02:00.0: Detected Intel(R) Centrino(R)
Advanced-N 6200 AGN, REV=0x74
[   25.276784] iwlwifi 0000:02:00.0: L1 Disabled; Enabling L0S
[   25.292235] iwlwifi 0000:02:00.0: device EEPROM VER=0x43a, CALIB=0x6
[   25.292241] iwlwifi 0000:02:00.0: Device SKU: 0X1f0
[   25.292273] iwlwifi 0000:02:00.0: Tunable channels: 13 802.11bg, 24
802.11a channels
[   25.319468] iwlwifi 0000:02:00.0: loaded firmware version 9.221.4.1
build 25532
[   25.319862] Registered led device: phy0-led
[   25.338964] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
[   25.375471] [drm] radeon kernel modesetting enabled.
[   25.375504] VGA switcheroo: detected switching method
\_SB_.PCI0.GFX0.ATPX handle
[   25.375704] radeon 0000:01:00.0: enabling device (0000 -> 0003)
[   25.375714] radeon 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   25.375723] radeon 0000:01:00.0: setting latency timer to 64
[   25.401905] mtrr: no more MTRRs available
[   25.401910] [drm] MTRR allocation failed.  Graphics performance may suffer.
[   25.403603] i915 0000:00:02.0: irq 54 for MSI/MSI-X
[   25.403622] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[   25.403624] [drm] Driver supports precise vblank timestamp query.
[   25.404368] vgaarb: device changed decodes:
PCI:0000:00:02.0,olddecodes=io+mem,decodes=none:owns=io+mem
[   25.404371] vgaarb: transferring owner from PCI:0000:00:02.0 to
PCI:0000:01:00.0
[   25.421327] input: HP ENVY HD Webcam as
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.5/2-1.5:1.0/input/input7
[   25.421756] usbcore: registered new interface driver uvcvideo
[   25.421760] USB Video Class driver (1.1.1)
[   25.754306] psmouse serio1: synaptics: Touchpad model: 1, fw: 7.4,
id: 0x1e0b1, caps: 0xd04773/0xe40000/0x5a0400
[   25.805254] input: SynPS/2 Synaptics TouchPad as
/devices/platform/i8042/serio1/input/input8
[   27.493644] fbcon: inteldrmfb (fb0) is primary device
[   28.875556] Console: switching to colour frame buffer device 240x67
[   28.884104] fb0: inteldrmfb frame buffer device
[   28.884106] drm: registered panic notifier
[   28.888411] acpi device:15: registered as cooling_device8
[   28.888927] input: Video Bus as
/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:13/LNXVIDEO:00/input/input9
[   28.889372] ACPI: Video Device [VGA] (multi-head: yes  rom: no  post: no)
[   28.893200] acpi device:1a: registered as cooling_device9
[   28.893956] input: Video Bus as
/devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:01/input/input10
[   28.894262] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[   28.894500] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[   28.894792] snd_hda_intel 0000:00:1b.0: PCI INT A -> GSI 22 (level,
low) -> IRQ 22
[   28.894944] snd_hda_intel 0000:00:1b.0: irq 55 for MSI/MSI-X
[   28.895005] snd_hda_intel 0000:00:1b.0: setting latency timer to 64
[   28.896293] [drm] initializing kernel modesetting (JUNIPER
0x1002:0x68A8 0x103C:0x159B).
[   28.896400] [drm] register mmio base: 0xC0700000
[   28.896402] [drm] register mmio size: 131072
[   28.896407] vga_switcheroo: enabled
[   28.896660] radeon atpx: version is 1
[   29.456715] input: HDA Digital PCBeep as
/devices/pci0000:00/0000:00:1b.0/input/input11
[   29.482636] HDMI status: Codec=3 Pin=5 Presence_Detect=0 ELD_Valid=0
[   29.482995] HDMI status: Codec=3 Pin=6 Presence_Detect=0 ELD_Valid=0
[   29.483324] input: HDA Intel PCH HDMI/DP,pcm=7 as
/devices/pci0000:00/0000:00:1b.0/sound/card0/input12
[   29.483624] input: HDA Intel PCH HDMI/DP,pcm=3 as
/devices/pci0000:00/0000:00:1b.0/sound/card0/input13
[   29.483886] input: HDA Intel PCH Mic as
/devices/pci0000:00/0000:00:1b.0/sound/card0/input14
[   29.484158] input: HDA Intel PCH Headphone as
/devices/pci0000:00/0000:00:1b.0/sound/card0/input15
[   39.184005] ATOM BIOS: HP
[   39.184102] radeon 0000:01:00.0: VRAM: 1024M 0x0000000000000000 -
0x000000003FFFFFFF (1024M used)
[   39.184106] radeon 0000:01:00.0: GTT: 512M 0x0000000040000000 -
0x000000005FFFFFFF
[   39.184120] mtrr: no more MTRRs available
[   39.184124] [drm] Detected VRAM RAM=1024M, BAR=256M
[   39.184126] [drm] RAM width 128bits DDR
[   39.184629] [TTM] Zone  kernel: Available graphics memory: 8229652 kiB.
[   39.184632] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB.
[   39.184634] [TTM] Initializing pool allocator.
[   39.185291] [drm] radeon: 1024M of VRAM memory ready
[   39.185299] [drm] radeon: 512M of GTT memory ready.
[   39.185390] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[   39.185392] [drm] Driver supports precise vblank timestamp query.
[   39.185490] radeon 0000:01:00.0: irq 56 for MSI/MSI-X
[   39.185500] radeon 0000:01:00.0: radeon: using MSI.
[   39.185564] [drm] radeon: irq initialized.
[   39.185687] [drm] GART: num cpu pages 131072, num gpu pages 131072
[   39.186116] [drm] Loading JUNIPER Microcode
[   39.222506] [drm] PCIE GART of 512M enabled (table at 0x0000000000040000).
[   39.222731] radeon 0000:01:00.0: WB enabled
[   39.238920] [drm] ring test succeeded in 0 usecs
[   39.239673] [drm] radeon: ib pool ready.
[   39.240217] [drm] ib test succeeded in 0 usecs
[   39.243816] [drm] Radeon Display Connectors
[   39.243820] [drm] Connector 0:
[   39.243822] [drm]   eDP
[   39.243824] [drm]   HPD3
[   39.243826] [drm]   DDC: 0x6450 0x6450 0x6454 0x6454 0x6458 0x6458
0x645c 0x645c
[   39.243829] [drm]   Encoders:
[   39.243831] [drm]     LCD1: INTERNAL_UNIPHY2
[   39.243832] [drm] Connector 1:
[   39.243834] [drm]   DisplayPort
[   39.243836] [drm]   HPD2
[   39.243838] [drm]   DDC: 0x6440 0x6440 0x6444 0x6444 0x6448 0x6448
0x644c 0x644c
[   39.243840] [drm]   Encoders:
[   39.243841] [drm]     DFP1: INTERNAL_UNIPHY2
[   39.243843] [drm] Connector 2:
[   39.243845] [drm]   HDMI-A
[   39.243846] [drm]   HPD1
[   39.243848] [drm]   DDC: 0x6430 0x6430 0x6434 0x6434 0x6438 0x6438
0x643c 0x643c
[   39.243850] [drm]   Encoders:
[   39.243852] [drm]     DFP2: INTERNAL_UNIPHY1
[   39.243854] [drm] Connector 3:
[   39.243855] [drm]   VGA
[   39.243858] [drm]   DDC: 0x64d8 0x64d8 0x64dc 0x64dc 0x64e0 0x64e0
0x64e4 0x64e4
[   39.243859] [drm]   Encoders:
[   39.243861] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
[   39.243908] [drm] Internal thermal controller with fan control
[   39.244095] [drm] radeon: power management initialized
[   41.591456] [drm] fb mappable at 0xA0142000
[   41.591459] [drm] vram apper at 0xA0000000
[   41.591461] [drm] size 8294400
[   41.591462] [drm] fb depth is 24
[   41.591464] [drm]    pitch is 7680
[   41.591748] fb1: radeondrmfb frame buffer device
[   41.591759] [drm] Initialized radeon 2.12.0 20080528 for
0000:01:00.0 on minor 1
[   41.591889] snd_hda_intel 0000:01:00.1: PCI INT B -> GSI 17 (level,
low) -> IRQ 17
[   41.592027] snd_hda_intel 0000:01:00.1: irq 57 for MSI/MSI-X
[   41.592085] snd_hda_intel 0000:01:00.1: setting latency timer to 64
[   41.612608] HDMI status: Codec=0 Pin=3 Presence_Detect=0 ELD_Valid=0
[   41.612857] input: HD-Audio Generic HDMI/DP,pcm=3 as
/devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input16
[   42.017177] EXT4-fs (dm-2): re-mounted. Opts: (null)
[   42.062053] EXT4-fs (dm-2): re-mounted. Opts: errors=remount-ro
[   42.140210] loop: module loaded
[   42.803184] Adding 2097148k swap on /dev/mapper/artemis-swap.
Priority:-1 extents:1 across:2097148k SS
[   42.948953] kjournald starting.  Commit interval 5 seconds
[   42.949197] EXT3-fs (sda3): using internal journal
[   42.949349] EXT3-fs (sda3): mounted filesystem with ordered data mode
[   43.109599] ip_tables: (C) 2000-2006 Netfilter Core Team
[   43.228917] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   43.341390] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   43.809980] RPC: Registered named UNIX socket transport module.
[   43.809985] RPC: Registered udp transport module.
[   43.809987] RPC: Registered tcp transport module.
[   43.809990] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   43.843339] FS-Cache: Loaded
[   43.962535] FS-Cache: Netfs 'nfs' registered for caching
[   44.006296] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   44.271521] fuse init (API version 7.17)
[   44.882321] Netfilter messages via NETLINK v0.30.
[   45.071696] NF_TPROXY: Transparent proxy support initialized, version 4.1.0
[   45.071700] NF_TPROXY: Copyright (c) 2006-2007 BalaBit IT Ltd.
[   45.128782] ctnetlink v0.93: registering with nfnetlink.
[   45.288007] ip_set: protocol 6
[   45.311921] ipt_CLUSTERIP: ClusterIP Version 0.8 loaded successfully
[   45.713233] xt_time: kernel timezone is -0000
[   45.842918] Bridge firewalling registered
[   46.002590] u32 classifier
[   46.002593]     Performance counters on
[   46.002595]     input device check on
[   46.002596]     Actions configured
[   46.509021] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   46.509024] Bluetooth: BNEP filters: protocol multicast
[   46.512031] Bluetooth: RFCOMM TTY layer initialized
[   46.512073] Bluetooth: RFCOMM socket layer initialized
[   46.512075] Bluetooth: RFCOMM ver 1.11
[   46.565574] lp: driver loaded but no devices found
[   46.581572] ppdev: user-space parallel port driver
[   46.683865] iwlwifi 0000:02:00.0: L1 Disabled; Enabling L0S
[   46.691144] iwlwifi 0000:02:00.0: Radio type=0x1-0x3-0x1
[   46.924759] iwlwifi 0000:02:00.0: L1 Disabled; Enabling L0S
[   46.931148] iwlwifi 0000:02:00.0: Radio type=0x1-0x3-0x1
[   47.046511] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   47.187774] input: ACPI Virtual Keyboard Device as
/devices/virtual/input/input17
[   47.212979] r8169 0000:03:00.0: eth0: link down
[   47.216128] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   48.255789] ehci_hcd 0000:00:1d.0: PCI INT A disabled
[   48.255872] ehci_hcd 0000:00:1d.0: PME# enabled
[   48.283633] xhci_hcd 0000:04:00.0: PME# enabled
[   48.464409] ehci_hcd 0000:00:1d.0: BAR 0: set to [mem
0xc1708000-0xc17083ff] (PCI address [0xc1708000-0xc17083ff])
[   48.464478] ehci_hcd 0000:00:1d.0: restoring config space at offset
0xf (was 0x100, writing 0x10a)
[   48.464559] ehci_hcd 0000:00:1d.0: restoring config space at offset
0x1 (was 0x2900000, writing 0x2900002)
[   48.465301] ehci_hcd 0000:00:1d.0: PME# disabled
[   48.465340] ehci_hcd 0000:00:1d.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[   48.465363] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[   48.676600] xhci_hcd 0000:04:00.0: PME# disabled
[   48.676643] xhci_hcd 0000:04:00.0: setting latency timer to 64
[   52.459898] EXT4-fs (dm-2): re-mounted. Opts: errors=remount-ro,commit=0
[   68.314328] wlan0: authenticate with 00:26:62:a6:ee:fe (try 1)
[   68.317022] wlan0: authenticated
[   68.333822] wlan0: associate with 00:26:62:a6:ee:fe (try 1)
[   68.338710] wlan0: RX AssocResp from 00:26:62:a6:ee:fe (capab=0x431
status=0 aid=1)
[   68.338716] wlan0: associated
[   68.367312] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   71.195190] martian source 192.168.1.2 from 72.14.204.102, on dev wlan0
[   71.195195] ll header: 18:3d:a2:9e:1e:4c:00:26:62:a6:ee:f9:08:00
[   72.059450] martian source 192.168.1.2 from 72.14.204.132, on dev wlan0
[   72.059453] ll header: 18:3d:a2:9e:1e:4c:00:26:62:a6:ee:f9:08:00
[   72.065199] martian source 192.168.1.2 from 72.14.204.132, on dev wlan0
[   72.065203] ll header: 18:3d:a2:9e:1e:4c:00:26:62:a6:ee:f9:08:00
[   72.065288] martian source 192.168.1.2 from 72.14.204.132, on dev wlan0
[   72.065291] ll header: 18:3d:a2:9e:1e:4c:00:26:62:a6:ee:f9:08:00
[   78.052509] iwlwifi 0000:02:00.0: Tx aggregation enabled on ra =
00:26:62:a6:ee:fe tid = 0
[   78.545961] exe (4191): /proc/4191/oom_adj is deprecated, please
use /proc/4191/oom_score_adj instead.
[   79.028564] wlan0: no IPv6 routers present
[ 2343.089732] hp_wmi: Unknown event_id - 10 - 0x1
[ 2343.089877] hp_wmi: Unknown event_id - 10 - 0x1
[ 2344.293165] hp_wmi: Unknown event_id - 10 - 0x1
[ 2488.873318] hp_wmi: Unknown event_id - 10 - 0x0
[ 8681.324734] hp_wmi: Unknown event_id - 10 - 0x1
[ 8825.695478] hp_wmi: Unknown event_id - 10 - 0x0
[42911.630432] hp_wmi: Unknown event_id - 10 - 0x1
[42914.035547] hp_wmi: Unknown event_id - 10 - 0x1
[47157.616202] hp_wmi: Unknown event_id - 10 - 0x0
[47381.524615] hp_wmi: Unknown event_id - 10 - 0x1
[47382.752851] hp_wmi: Unknown event_id - 10 - 0x1
[48361.980848] usb 2-1.2: new low-speed USB device number 4 using ehci_hcd
[48362.078830] usb 2-1.2: New USB device found, idVendor=045e, idProduct=0084
[48362.078835] usb 2-1.2: New USB device strings: Mfr=1, Product=2,
SerialNumber=0
[48362.078839] usb 2-1.2: Product: Basic Optical Mouse
[48362.078841] usb 2-1.2: Manufacturer: Microsoft
[48362.143587] input: Microsoft Basic Optical Mouse as
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.2/2-1.2:1.0/input/input18
[48362.146155] generic-usb 0003:045E:0084.0001: input,hidraw0: USB HID
v1.10 Mouse [Microsoft Basic Optical Mouse] on
usb-0000:00:1d.0-1.2/input0
[48362.146248] usbcore: registered new interface driver usbhid
[48362.146251] usbhid: USB HID core driver
[48498.178300] hp_wmi: Unknown event_id - 10 - 0x0
[50481.465667] hp_wmi: Unknown event_id - 10 - 0x1
[50625.903209] hp_wmi: Unknown event_id - 10 - 0x0
[51486.428494] hub 2-1:1.0: port 2 disabled by hub (EMI?), re-enabling...
[51486.428507] usb 2-1.2: USB disconnect, device number 4
[51486.719929] usb 2-1.2: new low-speed USB device number 5 using ehci_hcd
[51486.819234] usb 2-1.2: New USB device found, idVendor=045e, idProduct=0084
[51486.819243] usb 2-1.2: New USB device strings: Mfr=1, Product=2,
SerialNumber=0
[51486.819249] usb 2-1.2: Product: Basic Optical Mouse
[51486.819254] usb 2-1.2: Manufacturer: Microsoft
[51486.825387] input: Microsoft Basic Optical Mouse as
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.2/2-1.2:1.0/input/input19
[51486.826692] generic-usb 0003:045E:0084.0002: input,hidraw0: USB HID
v1.10 Mouse [Microsoft Basic Optical Mouse] on
usb-0000:00:1d.0-1.2/input0
[51586.728305] usb 2-1.2: USB disconnect, device number 5
[51756.935647] EXT4-fs (dm-2): re-mounted. Opts: errors=remount-ro,commit=0
[51776.068226] hp_wmi: Unknown event_id - 10 - 0x1
[51777.271912] hp_wmi: Unknown event_id - 10 - 0x1
[51921.709876] hp_wmi: Unknown event_id - 10 - 0x0
[53819.716382] hp_wmi: Unknown event_id - 10 - 0x1
[53829.352219] hp_wmi: Unknown event_id - 10 - 0x1
[54146.472763] hp_wmi: Unknown event_id - 10 - 0x0
[54319.002005] hp_wmi: Unknown event_id - 10 - 0x1
[54463.745202] hp_wmi: Unknown event_id - 10 - 0x0
[54822.458709] atkbd serio0: Unknown key pressed (translated set 2,
code 0xab on isa0060/serio0).
[54822.458715] atkbd serio0: Use 'setkeycodes e02b <keycode>' to make it known.
[54822.602528] atkbd serio0: Unknown key released (translated set 2,
code 0xab on isa0060/serio0).
[54822.602534] atkbd serio0: Use 'setkeycodes e02b <keycode>' to make it known.
[54823.189235] atkbd serio0: Unknown key pressed (translated set 2,
code 0xab on isa0060/serio0).
[54823.189243] atkbd serio0: Use 'setkeycodes e02b <keycode>' to make it known.
[54823.295194] atkbd serio0: Unknown key released (translated set 2,
code 0xab on isa0060/serio0).
[54823.295200] atkbd serio0: Use 'setkeycodes e02b <keycode>' to make it known.
[54823.511453] atkbd serio0: Unknown key pressed (translated set 2,
code 0xab on isa0060/serio0).
[54823.511459] atkbd serio0: Use 'setkeycodes e02b <keycode>' to make it known.
[54823.621823] atkbd serio0: Unknown key released (translated set 2,
code 0xab on isa0060/serio0).
[54823.621829] atkbd serio0: Use 'setkeycodes e02b <keycode>' to make it known.
[54824.127324] atkbd serio0: Unknown key pressed (translated set 2,
code 0xab on isa0060/serio0).
[54824.127330] atkbd serio0: Use 'setkeycodes e02b <keycode>' to make it known.
[54824.233753] atkbd serio0: Unknown key released (translated set 2,
code 0xab on isa0060/serio0).
[54824.233759] atkbd serio0: Use 'setkeycodes e02b <keycode>' to make it known.
[54828.874191] atkbd serio0: Unknown key pressed (translated set 2,
code 0xab on isa0060/serio0).
[54828.874197] atkbd serio0: Use 'setkeycodes e02b <keycode>' to make it known.
[54829.015718] atkbd serio0: Unknown key released (translated set 2,
code 0xab on isa0060/serio0).
[54829.015725] atkbd serio0: Use 'setkeycodes e02b <keycode>' to make it known.
[54829.422427] atkbd serio0: Unknown key pressed (translated set 2,
code 0xab on isa0060/serio0).
[54829.422433] atkbd serio0: Use 'setkeycodes e02b <keycode>' to make it known.
[54829.565712] atkbd serio0: Unknown key released (translated set 2,
code 0xab on isa0060/serio0).
[54829.565718] atkbd serio0: Use 'setkeycodes e02b <keycode>' to make it known.
[54829.699549] atkbd serio0: Unknown key pressed (translated set 2,
code 0xab on isa0060/serio0).
[54829.699555] atkbd serio0: Use 'setkeycodes e02b <keycode>' to make it known.
[54829.805958] atkbd serio0: Unknown key released (translated set 2,
code 0xab on isa0060/serio0).
[54829.805965] atkbd serio0: Use 'setkeycodes e02b <keycode>' to make it known.
[54830.821257] atkbd serio0: Unknown key pressed (translated set 2,
code 0xab on isa0060/serio0).
[54830.821264] atkbd serio0: Use 'setkeycodes e02b <keycode>' to make it known.
[54830.927716] atkbd serio0: Unknown key released (translated set 2,
code 0xab on isa0060/serio0).
[54830.927722] atkbd serio0: Use 'setkeycodes e02b <keycode>' to make it known.
[54831.389665] atkbd serio0: Unknown key pressed (translated set 2,
code 0xab on isa0060/serio0).
[54831.389672] atkbd serio0: Use 'setkeycodes e02b <keycode>' to make it known.
[54831.530561] atkbd serio0: Unknown key released (translated set 2,
code 0xab on isa0060/serio0).
[54831.530568] atkbd serio0: Use 'setkeycodes e02b <keycode>' to make it known.
[54831.842636] atkbd serio0: Unknown key pressed (translated set 2,
code 0xab on isa0060/serio0).
[54831.842642] atkbd serio0: Use 'setkeycodes e02b <keycode>' to make it known.
[54831.949825] atkbd serio0: Unknown key released (translated set 2,
code 0xab on isa0060/serio0).
[54831.949832] atkbd serio0: Use 'setkeycodes e02b <keycode>' to make it known.
[54832.299595] atkbd serio0: Unknown key pressed (translated set 2,
code 0xab on isa0060/serio0).
[54832.299601] atkbd serio0: Use 'setkeycodes e02b <keycode>' to make it known.
[54832.440480] atkbd serio0: Unknown key released (translated set 2,
code 0xab on isa0060/serio0).
[54832.440486] atkbd serio0: Use 'setkeycodes e02b <keycode>' to make it known.
[54832.824130] atkbd serio0: Unknown key pressed (translated set 2,
code 0xab on isa0060/serio0).
[54832.824137] atkbd serio0: Use 'setkeycodes e02b <keycode>' to make it known.
[54832.967768] atkbd serio0: Unknown key released (translated set 2,
code 0xab on isa0060/serio0).
[54832.967774] atkbd serio0: Use 'setkeycodes e02b <keycode>' to make it known.
[54833.301093] atkbd serio0: Unknown key pressed (translated set 2,
code 0xab on isa0060/serio0).
[54833.301100] atkbd serio0: Use 'setkeycodes e02b <keycode>' to make it known.
[54833.545857] atkbd serio0: Unknown key pressed (translated set 2,
code 0xab on isa0060/serio0).
[54833.545864] atkbd serio0: Use 'setkeycodes e02b <keycode>' to make it known.
[54833.577448] atkbd serio0: Unknown key pressed (translated set 2,
code 0xab on isa0060/serio0).
[54833.577454] atkbd serio0: Use 'setkeycodes e02b <keycode>' to make it known.
[54833.608794] atkbd serio0: Unknown key pressed (translated set 2,
code 0xab on isa0060/serio0).
[54833.608800] atkbd serio0: Use 'setkeycodes e02b <keycode>' to make it known.
[54833.641127] atkbd serio0: Unknown key pressed (translated set 2,
code 0xab on isa0060/serio0).
[54833.641136] atkbd serio0: Use 'setkeycodes e02b <keycode>' to make it known.
[54833.672896] atkbd serio0: Unknown key pressed (translated set 2,
code 0xab on isa0060/serio0).
[54833.672903] atkbd serio0: Use 'setkeycodes e02b <keycode>' to make it known.
[54833.704522] atkbd serio0: Unknown key pressed (translated set 2,
code 0xab on isa0060/serio0).
[54833.704529] atkbd serio0: Use 'setkeycodes e02b <keycode>' to make it known.
[54833.737071] atkbd serio0: Unknown key pressed (translated set 2,
code 0xab on isa0060/serio0).
[54833.737078] atkbd serio0: Use 'setkeycodes e02b <keycode>' to make it known.
[54833.768514] atkbd serio0: Unknown key pressed (translated set 2,
code 0xab on isa0060/serio0).
[54833.768521] atkbd serio0: Use 'setkeycodes e02b <keycode>' to make it known.
[54833.800852] atkbd serio0: Unknown key pressed (translated set 2,
code 0xab on isa0060/serio0).
[54833.800860] atkbd serio0: Use 'setkeycodes e02b <keycode>' to make it known.
[54833.832627] atkbd serio0: Unknown key pressed (translated set 2,
code 0xab on isa0060/serio0).
[54833.832632] atkbd serio0: Use 'setkeycodes e02b <keycode>' to make it known.
[54833.864824] atkbd serio0: Unknown key pressed (translated set 2,
code 0xab on isa0060/serio0).
[54833.864832] atkbd serio0: Use 'setkeycodes e02b <keycode>' to make it known.
[54833.896492] atkbd serio0: Unknown key pressed (translated set 2,
code 0xab on isa0060/serio0).
[54833.896498] atkbd serio0: Use 'setkeycodes e02b <keycode>' to make it known.
[54833.929092] atkbd serio0: Unknown key pressed (translated set 2,
code 0xab on isa0060/serio0).
[54833.929098] atkbd serio0: Use 'setkeycodes e02b <keycode>' to make it known.
[54833.960199] atkbd serio0: Unknown key pressed (translated set 2,
code 0xab on isa0060/serio0).
[54833.960206] atkbd serio0: Use 'setkeycodes e02b <keycode>' to make it known.
[54833.981590] atkbd serio0: Unknown key released (translated set 2,
code 0xab on isa0060/serio0).
[54833.981596] atkbd serio0: Use 'setkeycodes e02b <keycode>' to make it known.
[54834.321524] atkbd serio0: Unknown key pressed (translated set 2,
code 0xab on isa0060/serio0).
[54834.321530] atkbd serio0: Use 'setkeycodes e02b <keycode>' to make it known.
[54834.464479] atkbd serio0: Unknown key released (translated set 2,
code 0xab on isa0060/serio0).
[54834.464486] atkbd serio0: Use 'setkeycodes e02b <keycode>' to make it known.
[54834.883676] atkbd serio0: Unknown key pressed (translated set 2,
code 0xab on isa0060/serio0).
[54834.883685] atkbd serio0: Use 'setkeycodes e02b <keycode>' to make it known.
[54835.027355] atkbd serio0: Unknown key released (translated set 2,
code 0xab on isa0060/serio0).
[54835.027360] atkbd serio0: Use 'setkeycodes e02b <keycode>' to make it known.
[54842.569990] iwlwifi 0000:02:00.0: RF_KILL bit toggled to disable radio.
[54842.572360] iwlwifi 0000:02:00.0: Not sending command - RF KILL
[54842.572367] iwlwifi 0000:02:00.0: Error sending
REPLY_TX_LINK_QUALITY_CMD: enqueue_hcmd failed: -5
[54842.572380] iwlwifi 0000:02:00.0: Not sending command - RF KILL
[54842.572384] iwlwifi 0000:02:00.0: Error sending REPLY_ADD_STA:
enqueue_hcmd failed: -5
[54842.572389] HW problem - can not stop rx aggregation for tid 0
[54842.572914] iwlwifi 0000:02:00.0: Not sending command - RF KILL
[54842.572918] iwlwifi 0000:02:00.0: Error sending REPLY_ADD_STA:
enqueue_hcmd failed: -5
[54842.572922] HW problem - can not stop rx aggregation for tid 1
[54842.572949] iwlwifi 0000:02:00.0: Not sending command - RF KILL
[54842.572952] iwlwifi 0000:02:00.0: Error sending REPLY_ADD_STA:
enqueue_hcmd failed: -5
[54842.572957] HW problem - can not stop rx aggregation for tid 2
[54842.572981] iwlwifi 0000:02:00.0: Not sending command - RF KILL
[54842.572984] iwlwifi 0000:02:00.0: Error sending REPLY_ADD_STA:
enqueue_hcmd failed: -5
[54842.572988] HW problem - can not stop rx aggregation for tid 3
[54842.573028] iwlwifi 0000:02:00.0: Not sending command - RF KILL
[54842.573031] iwlwifi 0000:02:00.0: Error sending REPLY_ADD_STA:
enqueue_hcmd failed: -5
[54842.573035] HW problem - can not stop rx aggregation for tid 7
[54842.573153] iwlwifi 0000:02:00.0: Not sending command - RF KILL
[54842.573159] iwlwifi 0000:02:00.0: Error sending REPLY_QOS_PARAM:
enqueue_hcmd failed: -5
[54842.573163] iwlwifi 0000:02:00.0: Failed to update QoS
[54842.573172] iwlwifi 0000:02:00.0: Not sending command - RF KILL
[54842.573176] iwlwifi 0000:02:00.0: Error sending REPLY_RXON:
enqueue_hcmd failed: -5
[54842.573181] iwlwifi 0000:02:00.0: Error clearing ASSOC_MSK on BSS (-5)
[54842.574227] iwlwifi 0000:02:00.0: Not sending command - RF KILL
[54842.574237] iwlwifi 0000:02:00.0: Error sending REPLY_RXON:
enqueue_hcmd failed: -5
[54842.574247] iwlwifi 0000:02:00.0: Error clearing ASSOC_MSK on BSS (-5)
[54842.574261] iwlwifi 0000:02:00.0: Not sending command - RF KILL
[54842.574269] iwlwifi 0000:02:00.0: Error sending REPLY_RXON:
enqueue_hcmd failed: -5
[54842.574278] iwlwifi 0000:02:00.0: Error clearing ASSOC_MSK on BSS (-5)
[54842.574779] wlan0: deauthenticating from 00:26:62:a6:ee:fe by local
choice (reason=3)
[54842.657199] iwlwifi 0000:02:00.0: Not sending command - RF KILL
[54842.657207] iwlwifi 0000:02:00.0: Error sending REPLY_ADD_STA:
enqueue_hcmd failed: -5
[54842.657215] ieee80211 phy0: failed to remove key (1,
ff:ff:ff:ff:ff:ff) from hardware (-5)
[54842.723760] iwlwifi 0000:02:00.0: Not sending command - RF KILL
[54842.723767] iwlwifi 0000:02:00.0: Error sending REPLY_ADD_STA:
enqueue_hcmd failed: -5
[54842.723775] ieee80211 phy0: failed to remove key (2,
ff:ff:ff:ff:ff:ff) from hardware (-5)
[54842.754934] usb 1-1.6: USB disconnect, device number 3
[54842.756080] Bluetooth: hci0 urb ffff88043461b8c0 submission failed
[54842.781042] iwlwifi 0000:02:00.0: Not sending command - RF KILL
[54842.781049] iwlwifi 0000:02:00.0: Error sending REPLY_ADD_STA:
enqueue_hcmd failed: -5
[54842.781057] ieee80211 phy0: failed to remove key (0,
00:26:62:a6:ee:fe) from hardware (-5)
[54842.781097] iwlwifi 0000:02:00.0: Not sending command - RF KILL
[54842.781101] iwlwifi 0000:02:00.0: Error sending REPLY_REMOVE_STA:
enqueue_hcmd failed: -5
[54842.781105] iwlwifi 0000:02:00.0: Error removing station 00:26:62:a6:ee:fe
[54842.865292] iwlwifi 0000:02:00.0: Not sending command - RF KILL
[54842.865298] iwlwifi 0000:02:00.0: Error sending REPLY_RXON:
enqueue_hcmd failed: -5
[54842.865302] iwlwifi 0000:02:00.0: Error clearing ASSOC_MSK on BSS (-5)
[54842.865375] iwlwifi 0000:02:00.0: Not sending command - RF KILL
[54842.865378] iwlwifi 0000:02:00.0: Error sending REPLY_LEDS_CMD:
enqueue_hcmd failed: -5
[54842.865391] iwlwifi 0000:02:00.0: Not sending command - RF KILL
[54842.865393] iwlwifi 0000:02:00.0: Error sending REPLY_RXON:
enqueue_hcmd failed: -5
[54842.865396] iwlwifi 0000:02:00.0: Error clearing ASSOC_MSK on BSS (-5)
[54842.866327] cfg80211: Calling CRDA for country: US
[54842.929084] iwlwifi 0000:02:00.0: Not sending command - RF KILL
[54842.929089] iwlwifi 0000:02:00.0: Error sending REPLY_RXON:
enqueue_hcmd failed: -5
[54842.929093] iwlwifi 0000:02:00.0: Error clearing ASSOC_MSK on BSS (-5)
[54846.933716] iwlwifi 0000:02:00.0: RF_KILL bit toggled to enable radio.
[54846.936639] iwlwifi 0000:02:00.0: L1 Disabled; Enabling L0S
[54846.942989] iwlwifi 0000:02:00.0: Radio type=0x1-0x3-0x1
[54847.072055] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[54852.956018] usb 1-1.6: new full-speed USB device number 4 using ehci_hcd
[54853.051956] usb 1-1.6: New USB device found, idVendor=03f0, idProduct=231d
[54853.051962] usb 1-1.6: New USB device strings: Mfr=1, Product=2,
SerialNumber=0
[54853.051966] usb 1-1.6: Product: HP Integrated Module
[54853.051969] usb 1-1.6: Manufacturer: Broadcom Corp
[54854.898777] wlan0: authenticate with 00:26:62:a6:ee:fe (try 1)
[54854.901390] wlan0: authenticated
[54854.912063] wlan0: associate with 00:26:62:a6:ee:fe (try 1)
[54854.915041] wlan0: RX AssocResp from 00:26:62:a6:ee:fe (capab=0x431
status=0 aid=1)
[54854.915045] wlan0: associated
[54854.930836] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[54856.506982] martian source 192.168.1.2 from 72.14.204.83, on dev wlan0
[54856.506987] ll header: 18:3d:a2:9e:1e:4c:00:26:62:a6:ee:f9:08:00
[54865.737204] wlan0: no IPv6 routers present
[54890.096376] iwlwifi 0000:02:00.0: Tx aggregation enabled on ra =
00:26:62:a6:ee:fe tid = 0

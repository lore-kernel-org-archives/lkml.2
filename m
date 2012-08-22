Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756419Ab2HVOLv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 10:11:51 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:3840 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972Ab2HVOLm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 10:11:42 -0400
X-Server-Uuid: 4500596E-606A-40F9-852D-14843D8201B2
Message-ID: <5034E895.4050105@broadcom.com>
Date: Wed, 22 Aug 2012 16:11:33 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714
 Thunderbird/14.0
MIME-Version: 1.0
To: linux-mmc@vger.kernel.org
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: v3.6-rc1: modprobe hangs with sdhci failure on dell e6410
X-WSS-ID: 7C2A37C03NK18330022-01-01
Content-Type: multipart/mixed;
 boundary=------------040805040602060308030202
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--------------040805040602060308030202
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit

A quick search using google did not provide clues. Regardless if there 
is anything inserted the hang occurs.

Gr. AvS

--------------040805040602060308030202
Content-Type: text/plain;
 charset=utf-8;
 name=dmesg.txt
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename=dmesg.txt

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.6.0-rc1-wl-testing-00002-gaf0ca5d (root@lb-bun-10) (gcc version 4.4.5 (Ubuntu/Linaro 4.4.4-14ubuntu5.1) ) #1 SMP Fri Aug 3 21:23:46 CEST 2012
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009abff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009ac00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000cf65efff] usable
[    0.000000] BIOS-e820: [mem 0x00000000cf65f000-0x00000000cf67efff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000cf67f000-0x00000000cf76efff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000cf76f000-0x00000000cfffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed10000-0x00000000fed13fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed18000-0x00000000fed19fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff800000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000012bffffff] usable
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
[    0.000000] DMI 2.6 present.
[    0.000000] DMI: Dell Inc. Latitude E6410/07XJP9, BIOS A07 02/15/2011
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0xcf65f max_arch_pfn = 0x100000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 080000000 mask FC0000000 write-back
[    0.000000]   2 base 0C0000000 mask FF0000000 write-back
[    0.000000]   3 base 100000000 mask FE0000000 write-back
[    0.000000]   4 base 120000000 mask FF0000000 write-back
[    0.000000]   5 base 12C000000 mask FFC000000 uncachable
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: update [mem 0xd0000000-0xffffffff] usable ==> reserved
[    0.000000] found SMP MP-table at [mem 0x000f2200-0x000f220f] mapped at [c00f2200]
[    0.000000] initial memory mapped: [mem 0x00000000-0x01bfffff]
[    0.000000] Base memory trampoline at [c0096000] 96000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x377fdfff]
[    0.000000]  [mem 0x00000000-0x003fffff] page 4k
[    0.000000]  [mem 0x00400000-0x373fffff] page 2M
[    0.000000]  [mem 0x37400000-0x377fdfff] page 4k
[    0.000000] kernel direct mapping tables up to 0x377fdfff @ [mem 0x01bfa000-0x01bfffff]
[    0.000000] RAMDISK: [mem 0x37c14000-0x37feffff]
[    0.000000] Allocated new RAMDISK: [mem 0x37422000-0x377fd6fe]
[    0.000000] Move RAMDISK from [mem 0x37c14000-0x37fef6fe] to [mem 0x37422000-0x377fd6fe]
[    0.000000] ACPI: RSDP 000fe300 00024 (v02 DELL  )
[    0.000000] ACPI: XSDT cf67de18 00064 (v01 DELL    E2      06222004 MSFT 00010013)
[    0.000000] ACPI: FACP cf75fc18 000F4 (v04 DELL    E2      06222004 MSFT 00010013)
[    0.000000] ACPI Warning: 32/64 FACS address mismatch in FADT - two FACS tables! (20120711/tbfadt-394)
[    0.000000] ACPI BIOS Bug: Warning: 32/64X FACS address mismatch in FADT - 0xCF76BF40/0x00000000CF76ED40, using 32 (20120711/tbfadt-521)
[    0.000000] ACPI: DSDT cf73e018 0A24E (v01 DELL    E2      00001001 INTL 20080729)
[    0.000000] ACPI: FACS cf76bf40 00040
[    0.000000] ACPI: APIC cf67cf18 0008C (v02 DELL    E2      06222004 MSFT 00010013)
[    0.000000] ACPI: TCPA cf76dd18 00032 (v02                 00000000      00000000)
[    0.000000] ACPI: MCFG cf76dc98 0003C (v01 A M I  GMCH945. 06222004 MSFT 00000097)
[    0.000000] ACPI: HPET cf76dc18 00038 (v01 DELL    E2      00000001 ASL  00000061)
[    0.000000] ACPI: BOOT cf76db98 00028 (v01 DELL   E2       06222004 AMI  00010013)
[    0.000000] ACPI: SLIC cf766818 00176 (v03 DELL    E2      06222004 MSFT 00010013)
[    0.000000] ACPI: SSDT cf74d018 009F1 (v01  PmRef    CpuPm 00003000 INTL 20080729)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 2430MB HIGHMEM available.
[    0.000000] 887MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 377fe000
[    0.000000]   low ram: 0 - 377fe000
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x377fdfff]
[    0.000000]   HighMem  [mem 0x377fe000-0xcf65efff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x00099fff]
[    0.000000]   node   0: [mem 0x00100000-0xcf65efff]
[    0.000000] On node 0 totalpages: 849385
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3946 pages, LIFO batch:0
[    0.000000]   Normal zone: 1744 pages used for memmap
[    0.000000]   Normal zone: 221486 pages, LIFO batch:31
[    0.000000]   HighMem zone: 4861 pages used for memmap
[    0.000000]   HighMem zone: 617316 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x04] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x05] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x06] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] disabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] smpboot: Allowing 8 CPUs, 4 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009a000 - 000000000009b000
[    0.000000] PM: Registered nosave memory: 000000000009b000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] e820: [mem 0xd0000000-0xf7ffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 13 pages/cpu @f59a7000 s31328 r0 d21920 u53248
[    0.000000] pcpu-alloc: s31328 r0 d21920 u53248 alloc=13*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 [0] 4 [0] 5 [0] 6 [0] 7 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 842748
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-3.6.0-rc1-wl-testing-00002-gaf0ca5d root=UUID=839f64b3-96df-431c-9499-2d2ebcf0180e ro quiet splash
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (000377fe:000cf65f)
[    0.000000] Memory: 3356908k/3398012k available (4938k kernel code, 40632k reserved, 2363k data, 572k init, 2488708k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff16000 - 0xfffff000   ( 932 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
[    0.000000]       .init : 0xc1722000 - 0xc17b1000   ( 572 kB)
[    0.000000]       .data : 0xc14d2a93 - 0xc1721720   (2363 kB)
[    0.000000]       .text : 0xc1000000 - 0xc14d2a93   (4938 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] NR_IRQS:2304 nr_irqs:744 16
[    0.000000] CPU 0 irqstacks, hard=f540a000 soft=f540c000
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.004000] tsc: Detected 2792.966 MHz processor
[    0.000001] Calibrating delay loop (skipped), value calculated using timer frequency.. 5585.93 BogoMIPS (lpj=11171864)
[    0.000003] pid_max: default: 32768 minimum: 301
[    0.000021] Security Framework initialized
[    0.000031] AppArmor: AppArmor initialized
[    0.000062] Mount-cache hash table entries: 512
[    0.000232] Initializing cgroup subsys cpuacct
[    0.000234] Initializing cgroup subsys devices
[    0.000235] Initializing cgroup subsys freezer
[    0.000236] Initializing cgroup subsys net_cls
[    0.000255] CPU: Physical Processor ID: 0
[    0.000256] CPU: Processor Core ID: 0
[    0.000260] mce: CPU supports 9 MCE banks
[    0.000267] CPU0: Thermal monitoring handled by SMI
[    0.000273] process: using mwait in idle threads
[    0.000279] Last level iTLB entries: 4KB 512, 2MB 7, 4MB 7
[    0.000279] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32
[    0.000279] tlb_flushall_shift is 0x6
[    0.001713] ACPI: Core revision 20120711
[    0.006518] ftrace: allocating 20233 entries in 40 pages
[    0.013604] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.013952] ..TIMER: vector=0x51 apic1=0 pin1=2 apic2=0 pin2=0
[    0.053566] smpboot: CPU0: Intel(R) Core(TM) i7 CPU       M 640  @ 2.80GHz stepping 05
[    0.159935] Performance Events: PEBS fmt1+, 16-deep LBR, Westmere events, Intel PMU driver.
[    0.159940] perf_event_intel: CPUID marked event: 'bus cycles' unavailable
[    0.159941] ... version:                3
[    0.159942] ... bit width:              48
[    0.159943] ... generic registers:      4
[    0.159944] ... value mask:             0000ffffffffffff
[    0.159944] ... max period:             000000007fffffff
[    0.159945] ... fixed-purpose events:   3
[    0.159946] ... event mask:             000000070000000f
[    0.160105] CPU 1 irqstacks, hard=f54d8000 soft=f54da000
[    0.170374] Initializing CPU#1
[    0.171127] CPU1: Thermal monitoring handled by SMI
[    0.160106] smpboot: Booting Node   0, Processors  #1
[    0.173312] CPU 2 irqstacks, hard=f550c000 soft=f550e000
[    0.183457] Initializing CPU#2
[    0.184337] CPU2: Thermal monitoring handled by SMI
[    0.173315]  #2
[    0.186507] CPU 3 irqstacks, hard=f5524000 soft=f5526000
[    0.196652] Initializing CPU#3
[    0.197532] CPU3: Thermal monitoring handled by SMI
[    0.186512]  #3
[    0.199643] Brought up 4 CPUs
[    0.199647] smpboot: Total of 4 processors activated (22343.72 BogoMIPS)
[    0.202250] devtmpfs: initialized
[    0.202406] PM: Registering ACPI NVS region [mem 0xcf67f000-0xcf76efff] (983040 bytes)
[    0.203085] dummy: 
[    0.203115] RTC time: 15:27:40, date: 08/22/12
[    0.203150] NET: Registered protocol family 16
[    0.203252] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.203254] ACPI: bus type pci registered
[    0.203302] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.203305] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.203306] PCI: Using MMCONFIG for extended config space
[    0.203307] PCI: Using configuration type 1 for base access
[    0.203314] dmi type 0xB1 record - unknown flag
[    0.203851] bio: create slab <bio-0> at 0
[    0.203897] ACPI: Added _OSI(Module Device)
[    0.203899] ACPI: Added _OSI(Processor Device)
[    0.203900] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.203901] ACPI: Added _OSI(Processor Aggregator Device)
[    0.204997] ACPI: EC: Look up EC in DSDT
[    0.209174] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.231394] ACPI: SSDT cf7eaa18 004B6 (v01  PmRef  Cpu0Ist 00003000 INTL 20080729)
[    0.231658] ACPI: Dynamic OEM Table Load:
[    0.231660] ACPI: SSDT   (null) 004B6 (v01  PmRef  Cpu0Ist 00003000 INTL 20080729)
[    0.231772] ACPI: SSDT cf7e8018 00891 (v01  PmRef  Cpu0Cst 00003001 INTL 20080729)
[    0.232020] ACPI: Dynamic OEM Table Load:
[    0.232022] ACPI: SSDT   (null) 00891 (v01  PmRef  Cpu0Cst 00003001 INTL 20080729)
[    0.232221] ACPI: SSDT cf7e9a98 00303 (v01  PmRef    ApIst 00003000 INTL 20080729)
[    0.232521] ACPI: Dynamic OEM Table Load:
[    0.232522] ACPI: SSDT   (null) 00303 (v01  PmRef    ApIst 00003000 INTL 20080729)
[    0.232603] ACPI: SSDT cf7e7d98 00119 (v01  PmRef    ApCst 00003000 INTL 20080729)
[    0.232874] ACPI: Dynamic OEM Table Load:
[    0.232876] ACPI: SSDT   (null) 00119 (v01  PmRef    ApCst 00003000 INTL 20080729)
[    0.234267] ACPI: Interpreter enabled
[    0.234273] ACPI: (supports S0 S3 S4 S5)
[    0.234289] ACPI: Using IOAPIC for interrupt routing
[    0.245197] ACPI: EC: GPE = 0x10, I/O: command/status = 0x934, data = 0x930
[    0.245739] ACPI: No dock devices found.
[    0.245744] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.246023] \_SB_.PCI0:_OSC invalid UUID
[    0.246024] _OSC request data:1 8 1f 
[    0.246028] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
[    0.246478] PCI host bridge to bus 0000:00
[    0.246481] pci_bus 0000:00: busn_res: [bus 00-3e] is inserted under domain [bus 00-ff]
[    0.246483] pci_bus 0000:00: root bus resource [bus 00-3e]
[    0.246484] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.246486] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.246487] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.246488] pci_bus 0000:00: root bus resource [mem 0xd0000000-0xfeafffff]
[    0.246496] pci 0000:00:00.0: [8086:0044] type 00 class 0x060000
[    0.246529] pci 0000:00:01.0: [8086:0045] type 01 class 0x060400
[    0.246556] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.246607] pci 0000:00:19.0: [8086:10ea] type 00 class 0x020000
[    0.246629] pci 0000:00:19.0: reg 10: [mem 0xe9600000-0xe961ffff]
[    0.246640] pci 0000:00:19.0: reg 14: [mem 0xe9680000-0xe9680fff]
[    0.246651] pci 0000:00:19.0: reg 18: [io  0x8040-0x805f]
[    0.246738] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.246768] pci 0000:00:1a.0: [8086:3b3c] type 00 class 0x0c0320
[    0.246792] pci 0000:00:1a.0: reg 10: [mem 0xe9670000-0xe96703ff]
[    0.246898] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.246929] pci 0000:00:1b.0: [8086:3b56] type 00 class 0x040300
[    0.246948] pci 0000:00:1b.0: reg 10: [mem 0xe9660000-0xe9663fff 64bit]
[    0.247043] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.247071] pci 0000:00:1c.0: [8086:3b42] type 01 class 0x060400
[    0.247169] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.247199] pci 0000:00:1c.1: [8086:3b44] type 01 class 0x060400
[    0.247296] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.247325] pci 0000:00:1c.2: [8086:3b46] type 01 class 0x060400
[    0.247423] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.247453] pci 0000:00:1c.3: [8086:3b48] type 01 class 0x060400
[    0.247550] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.247589] pci 0000:00:1d.0: [8086:3b34] type 00 class 0x0c0320
[    0.247612] pci 0000:00:1d.0: reg 10: [mem 0xe9650000-0xe96503ff]
[    0.247719] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.247744] pci 0000:00:1e.0: [8086:2448] type 01 class 0x060401
[    0.247830] pci 0000:00:1f.0: [8086:3b07] type 00 class 0x060100
[    0.247956] pci 0000:00:1f.2: [8086:3b2f] type 00 class 0x010601
[    0.247981] pci 0000:00:1f.2: reg 10: [io  0x8090-0x8097]
[    0.247991] pci 0000:00:1f.2: reg 14: [io  0x8080-0x8083]
[    0.248001] pci 0000:00:1f.2: reg 18: [io  0x8070-0x8077]
[    0.248011] pci 0000:00:1f.2: reg 1c: [io  0x8060-0x8063]
[    0.248022] pci 0000:00:1f.2: reg 20: [io  0x8020-0x803f]
[    0.248032] pci 0000:00:1f.2: reg 24: [mem 0xe9640000-0xe96407ff]
[    0.248099] pci 0000:00:1f.2: PME# supported from D3hot
[    0.248122] pci 0000:00:1f.3: [8086:3b30] type 00 class 0x0c0500
[    0.248141] pci 0000:00:1f.3: reg 10: [mem 0xe9630000-0xe96300ff 64bit]
[    0.248170] pci 0000:00:1f.3: reg 20: [io  0x8000-0x801f]
[    0.248218] pci 0000:00:1f.6: [8086:3b32] type 00 class 0x118000
[    0.248242] pci 0000:00:1f.6: reg 10: [mem 0xe9620000-0xe9620fff 64bit]
[    0.248357] pci_bus 0000:01: busn_res: [bus 01] is inserted under [bus 00-3e]
[    0.248370] pci 0000:01:00.0: [10de:0a6c] type 00 class 0x030000
[    0.248378] pci 0000:01:00.0: reg 10: [mem 0xe2000000-0xe2ffffff]
[    0.248386] pci 0000:01:00.0: reg 14: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.248395] pci 0000:01:00.0: reg 1c: [mem 0xe0000000-0xe1ffffff 64bit pref]
[    0.248400] pci 0000:01:00.0: reg 24: [io  0x7000-0x707f]
[    0.248406] pci 0000:01:00.0: reg 30: [mem 0xe3000000-0xe307ffff pref]
[    0.248452] pci 0000:01:00.1: [10de:0be3] type 00 class 0x040300
[    0.248459] pci 0000:01:00.1: reg 10: [mem 0xe3080000-0xe3083fff]
[    0.248535] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.248537] pci 0000:00:01.0:   bridge window [io  0x7000-0x7fff]
[    0.248539] pci 0000:00:01.0:   bridge window [mem 0xd0000000-0xe30fffff]
[    0.248592] pci_bus 0000:02: busn_res: [bus 02] is inserted under [bus 00-3e]
[    0.248596] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.248600] pci 0000:00:1c.0:   bridge window [io  0x6000-0x6fff]
[    0.248604] pci 0000:00:1c.0:   bridge window [mem 0xe8200000-0xe95fffff]
[    0.248661] pci_bus 0000:03: busn_res: [bus 03] is inserted under [bus 00-3e]
[    0.248737] pci 0000:03:00.0: [14e4:4727] type 00 class 0x028000
[    0.248777] pci 0000:03:00.0: reg 10: [mem 0xe6e00000-0xe6e03fff 64bit]
[    0.249015] pci 0000:03:00.0: supports D1 D2
[    0.249017] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.255830] pci 0000:00:1c.1: PCI bridge to [bus 03]
[    0.255839] pci 0000:00:1c.1:   bridge window [io  0x5000-0x5fff]
[    0.255846] pci 0000:00:1c.1:   bridge window [mem 0xe6e00000-0xe81fffff]
[    0.255916] pci_bus 0000:04: busn_res: [bus 04-05] is inserted under [bus 00-3e]
[    0.255989] pci 0000:04:00.0: [1180:e476] type 02 class 0x060700
[    0.256009] pci 0000:04:00.0: reg 10: [mem 0xe5940000-0xe5940fff]
[    0.256086] pci 0000:04:00.0: supports D1 D2
[    0.256088] pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.256139] pci 0000:04:00.1: [1180:e822] type 00 class 0x080501
[    0.256159] pci 0000:04:00.1: reg 10: [mem 0xe5930000-0xe59300ff]
[    0.256320] pci 0000:04:00.1: supports D1 D2
[    0.256321] pci 0000:04:00.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.256375] pci 0000:04:00.4: [1180:e832] type 00 class 0x0c0010
[    0.256394] pci 0000:04:00.4: reg 10: [mem 0xe5900000-0xe59007ff]
[    0.256554] pci 0000:04:00.4: supports D1 D2
[    0.256556] pci 0000:04:00.4: PME# supported from D0 D1 D2 D3hot D3cold
[    0.263856] pci 0000:00:1c.2: PCI bridge to [bus 04-05]
[    0.263866] pci 0000:00:1c.2:   bridge window [io  0x2000-0x3fff]
[    0.263870] pci 0000:00:1c.2:   bridge window [mem 0xe3100000-0xe59fffff]
[    0.263961] pci_bus 0000:05: busn_res: can not insert [bus 05-ff] under [bus 04-05] (conflicts with (null) [bus 04-05])
[    0.263965] pci_bus 0000:05: busn_res: [bus 05-ff] end is updated to 08
[    0.263967] pci_bus 0000:05: busn_res: can not insert [bus 05-08] under [bus 04-05] (conflicts with (null) [bus 04-05])
[    0.263971] pci_bus 0000:05: [bus 05-08] partially hidden behind bridge 0000:04 [bus 04-05]
[    0.264026] pci_bus 0000:06: busn_res: [bus 06-0b] is inserted under [bus 00-3e]
[    0.264029] pci 0000:00:1c.3: PCI bridge to [bus 06-0b]
[    0.264033] pci 0000:00:1c.3:   bridge window [io  0x4000-0x4fff]
[    0.264038] pci 0000:00:1c.3:   bridge window [mem 0xe5a00000-0xe6dfffff]
[    0.264071] pci_bus 0000:0c: busn_res: [bus 0c] is inserted under [bus 00-3e]
[    0.264114] pci 0000:00:1e.0: PCI bridge to [bus 0c] (subtractive decode)
[    0.264126] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.264127] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.264129] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.264130] pci 0000:00:1e.0:   bridge window [mem 0xd0000000-0xfeafffff] (subtractive decode)
[    0.264161] pci_bus 0000:00: on NUMA node 0
[    0.264163] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.264287] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]
[    0.264327] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.264405] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.264442] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    0.264480] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
[    0.264517] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP04._PRT]
[    0.264601] \_SB_.PCI0:_OSC invalid UUID
[    0.264602] _OSC request data:1 1f 1f 
[    0.264606]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.264629] \_SB_.PCI0:_OSC invalid UUID
[    0.264630] _OSC request data:1 0 1d 
[    0.264633]  pci0000:00: ACPI _OSC request failed (AE_ERROR), returned control mask: 0x1d
[    0.264633] ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.267163] ACPI: PCI Root Bridge [CPBG] (domain 0000 [bus 3f])
[    0.267199] PCI host bridge to bus 0000:3f
[    0.267201] pci_bus 0000:3f: busn_res: [bus 3f] is inserted under domain [bus 00-ff]
[    0.267202] pci_bus 0000:3f: root bus resource [bus 3f]
[    0.267206] pci 0000:3f:00.0: [8086:2c62] type 00 class 0x060000
[    0.267221] pci 0000:3f:00.1: [8086:2d01] type 00 class 0x060000
[    0.267237] pci 0000:3f:02.0: [8086:2d10] type 00 class 0x060000
[    0.267251] pci 0000:3f:02.1: [8086:2d11] type 00 class 0x060000
[    0.267264] pci 0000:3f:02.2: [8086:2d12] type 00 class 0x060000
[    0.267277] pci 0000:3f:02.3: [8086:2d13] type 00 class 0x060000
[    0.267298] pci_bus 0000:3f: on NUMA node 0
[    0.267302]  pci0000:3f: Requesting ACPI _OSC control (0x1d)
[    0.267304]  pci0000:3f: ACPI _OSC request failed (AE_NOT_FOUND), returned control mask: 0x1d
[    0.267305] ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.267443] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
[    0.267478] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
[    0.267511] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 *5 6 7 10 12 14 15)
[    0.267543] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
[    0.267576] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 *3 4 5 6 7 10 12 14 15)
[    0.267609] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
[    0.267642] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
[    0.267675] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
[    0.267733] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.267737] vgaarb: loaded
[    0.267738] vgaarb: bridge control possible 0000:01:00.0
[    0.267792] SCSI subsystem initialized
[    0.267794] ACPI: bus type scsi registered
[    0.267819] libata version 3.00 loaded.
[    0.267832] ACPI: bus type usb registered
[    0.267846] usbcore: registered new interface driver usbfs
[    0.267852] usbcore: registered new interface driver hub
[    0.267865] usbcore: registered new device driver usb
[    0.267953] wmi: Mapper loaded
[    0.267954] PCI: Using ACPI for IRQ routing
[    0.270089] PCI: pci_cache_line_size set to 64 bytes
[    0.270204] e820: reserve RAM buffer [mem 0x0009ac00-0x0009ffff]
[    0.270205] e820: reserve RAM buffer [mem 0xcf65f000-0xcfffffff]
[    0.270269] NetLabel: Initializing
[    0.270270] NetLabel:  domain hash size = 128
[    0.270271] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.270278] NetLabel:  unlabeled traffic allowed by default
[    0.270335] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.270339] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.272355] Switching to clocksource hpet
[    0.276951] AppArmor: AppArmor Filesystem Enabled
[    0.276972] pnp: PnP ACPI init
[    0.276984] ACPI: bus type pnp registered
[    0.277237] pnp 00:00: [bus 00-3e]
[    0.277239] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.277241] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.277242] pnp 00:00: [io  0x0d00-0xffff window]
[    0.277244] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.277245] pnp 00:00: [mem 0x000c0000-0x000c3fff window]
[    0.277246] pnp 00:00: [mem 0x000c4000-0x000c7fff window]
[    0.277248] pnp 00:00: [mem 0x000c8000-0x000cbfff window]
[    0.277249] pnp 00:00: [mem 0x000cc000-0x000cffff window]
[    0.277250] pnp 00:00: [mem 0x000d0000-0x000d3fff window]
[    0.277252] pnp 00:00: [mem 0x000d4000-0x000d7fff window]
[    0.277253] pnp 00:00: [mem 0x000d8000-0x000dbfff window]
[    0.277254] pnp 00:00: [mem 0x000dc000-0x000dffff window]
[    0.277255] pnp 00:00: [mem 0x000e0000-0x000e3fff window]
[    0.277257] pnp 00:00: [mem 0x000e4000-0x000e7fff window]
[    0.277258] pnp 00:00: [mem 0x000e8000-0x000ebfff window]
[    0.277259] pnp 00:00: [mem 0x000ec000-0x000effff window]
[    0.277261] pnp 00:00: [mem 0x000f0000-0x000fffff window]
[    0.277262] pnp 00:00: [mem 0xd0000000-0xfeafffff window]
[    0.277263] pnp 00:00: [mem 0xfed40000-0xfed44fff window]
[    0.277311] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    0.277328] pnp 00:01: [io  0x0000-0x001f]
[    0.277330] pnp 00:01: [io  0x0081-0x0091]
[    0.277331] pnp 00:01: [io  0x0093-0x009f]
[    0.277332] pnp 00:01: [io  0x00c0-0x00df]
[    0.277334] pnp 00:01: [dma 4]
[    0.277347] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.277353] pnp 00:02: [mem 0xff000000-0xffffffff]
[    0.277368] pnp 00:02: Plug and Play ACPI device, IDs INT0800 (active)
[    0.277419] pnp 00:03: [mem 0xfed00000-0xfed003ff]
[    0.277433] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.277440] pnp 00:04: [io  0x00f0]
[    0.277445] pnp 00:04: [irq 13]
[    0.277459] pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.277467] pnp 00:05: [io  0x002e-0x002f]
[    0.277468] pnp 00:05: [io  0x004e-0x004f]
[    0.277470] pnp 00:05: [io  0x0061]
[    0.277471] pnp 00:05: [io  0x0063]
[    0.277472] pnp 00:05: [io  0x0065]
[    0.277473] pnp 00:05: [io  0x0067]
[    0.277474] pnp 00:05: [io  0x0070]
[    0.277475] pnp 00:05: [io  0x0080]
[    0.277477] pnp 00:05: [io  0x0092]
[    0.277478] pnp 00:05: [io  0x00b2-0x00b3]
[    0.277479] pnp 00:05: [io  0x0680-0x069f]
[    0.277480] pnp 00:05: [io  0x1000-0x1003]
[    0.277482] pnp 00:05: [io  0x1004-0x1013]
[    0.277483] pnp 00:05: [io  0xffff]
[    0.277484] pnp 00:05: [io  0x0400-0x047f]
[    0.277485] pnp 00:05: [io  0x0500-0x057f]
[    0.277487] pnp 00:05: [io  0x164e-0x164f]
[    0.277524] system 00:05: [io  0x0680-0x069f] has been reserved
[    0.277525] system 00:05: [io  0x1000-0x1003] has been reserved
[    0.277527] system 00:05: [io  0x1004-0x1013] has been reserved
[    0.277528] system 00:05: [io  0xffff] has been reserved
[    0.277530] system 00:05: [io  0x0400-0x047f] has been reserved
[    0.277532] system 00:05: [io  0x0500-0x057f] has been reserved
[    0.277533] system 00:05: [io  0x164e-0x164f] has been reserved
[    0.277535] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.277541] pnp 00:06: [io  0x0070-0x0077]
[    0.277544] pnp 00:06: [irq 8]
[    0.277558] pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.277564] pnp 00:07: [io  0x0060]
[    0.277565] pnp 00:07: [io  0x0064]
[    0.277567] pnp 00:07: [irq 1]
[    0.277582] pnp 00:07: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.278990] pnp 00:08: Plug and Play ACPI device, IDs PNP0401 (disabled)
[    0.278998] pnp 00:09: [irq 12]
[    0.279015] pnp 00:09: Plug and Play ACPI device, IDs DLL040a PNP0f13 (active)
[    0.279176] pnp 00:0a: [mem 0xfed1c000-0xfed1ffff]
[    0.279178] pnp 00:0a: [mem 0xfed10000-0xfed13fff]
[    0.279179] pnp 00:0a: [mem 0xfed18000-0xfed18fff]
[    0.279180] pnp 00:0a: [mem 0xfed19000-0xfed19fff]
[    0.279182] pnp 00:0a: [mem 0xf8000000-0xfbffffff]
[    0.279183] pnp 00:0a: [mem 0xfed20000-0xfed3ffff]
[    0.279184] pnp 00:0a: [mem 0xfed90000-0xfed8ffff disabled]
[    0.279185] pnp 00:0a: [mem 0xfed45000-0xfed8ffff]
[    0.279187] pnp 00:0a: [mem 0xff000000-0xffffffff]
[    0.279188] pnp 00:0a: [mem 0xfee00000-0xfeefffff]
[    0.279189] pnp 00:0a: [mem 0xe96c0000-0xe96c0fff]
[    0.279226] system 00:0a: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.279228] system 00:0a: [mem 0xfed10000-0xfed13fff] has been reserved
[    0.279229] system 00:0a: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.279231] system 00:0a: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.279233] system 00:0a: [mem 0xf8000000-0xfbffffff] has been reserved
[    0.279234] system 00:0a: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.279236] system 00:0a: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.279237] system 00:0a: [mem 0xff000000-0xffffffff] could not be reserved
[    0.279239] system 00:0a: [mem 0xfee00000-0xfeefffff] could not be reserved
[    0.279241] system 00:0a: [mem 0xe96c0000-0xe96c0fff] has been reserved
[    0.279243] system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.279297] pnp 00:0b: [irq 23]
[    0.279318] pnp 00:0b: Plug and Play ACPI device, IDs SMO8800 (active)
[    0.280410] pnp 00:0c: [bus 3f]
[    0.280443] pnp 00:0c: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.281532] pnp: PnP ACPI: found 13 devices
[    0.281533] ACPI: ACPI bus type pnp unregistered
[    0.317912] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 02] add_size 200000
[    0.317923] pci 0000:00:1c.1: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 03] add_size 200000
[    0.317942] pci 0000:04:00.0: res[15]=[mem 0x04000000-0x03ffffff pref] get_res_add_size add_size 4000000
[    0.317944] pci 0000:00:1c.2: bridge window [mem 0x04000000-0x03ffffff pref] to [bus 04-05] add_size 4000000
[    0.317954] pci 0000:00:1c.3: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 06-0b] add_size 200000
[    0.317967] pci 0000:00:1c.2: res[15]=[mem 0x04000000-0x03ffffff pref] get_res_add_size add_size 4000000
[    0.317969] pci 0000:00:1c.0: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.317970] pci 0000:00:1c.1: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.317972] pci 0000:00:1c.3: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.317976] pci 0000:00:1c.2: BAR 15: assigned [mem 0xec000000-0xefffffff pref]
[    0.317978] pci 0000:00:1c.0: BAR 15: assigned [mem 0xe9700000-0xe98fffff 64bit pref]
[    0.317980] pci 0000:00:1c.1: BAR 15: assigned [mem 0xe9900000-0xe9afffff 64bit pref]
[    0.317982] pci 0000:00:1c.3: BAR 15: assigned [mem 0xe9b00000-0xe9cfffff 64bit pref]
[    0.317984] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.317986] pci 0000:00:01.0:   bridge window [io  0x7000-0x7fff]
[    0.317989] pci 0000:00:01.0:   bridge window [mem 0xd0000000-0xe30fffff]
[    0.317992] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.317995] pci 0000:00:1c.0:   bridge window [io  0x6000-0x6fff]
[    0.318001] pci 0000:00:1c.0:   bridge window [mem 0xe8200000-0xe95fffff]
[    0.318005] pci 0000:00:1c.0:   bridge window [mem 0xe9700000-0xe98fffff 64bit pref]
[    0.318012] pci 0000:00:1c.1: PCI bridge to [bus 03]
[    0.318015] pci 0000:00:1c.1:   bridge window [io  0x5000-0x5fff]
[    0.318020] pci 0000:00:1c.1:   bridge window [mem 0xe6e00000-0xe81fffff]
[    0.318025] pci 0000:00:1c.1:   bridge window [mem 0xe9900000-0xe9afffff 64bit pref]
[    0.318032] pci 0000:04:00.0: res[15]=[mem 0x04000000-0x03ffffff pref] get_res_add_size add_size 4000000
[    0.318034] pci 0000:04:00.0: res[16]=[mem 0x04000000-0x03ffffff] get_res_add_size add_size 4000000
[    0.318036] pci 0000:04:00.0: res[13]=[io  0x0100-0x00ff] get_res_add_size add_size 100
[    0.318037] pci 0000:04:00.0: res[14]=[io  0x0100-0x00ff] get_res_add_size add_size 100
[    0.318039] pci 0000:04:00.0: BAR 15: assigned [mem 0xec000000-0xefffffff pref]
[    0.318041] pci 0000:04:00.0: BAR 16: can't assign mem (size 0x4000000)
[    0.318043] pci 0000:04:00.0: BAR 13: assigned [io  0x2000-0x20ff]
[    0.318044] pci 0000:04:00.0: BAR 14: assigned [io  0x2400-0x24ff]
[    0.318046] pci 0000:04:00.0: BAR 16: can't assign mem (size 0x4000000)
[    0.318048] pci 0000:04:00.0: BAR 15: assigned [mem 0xec000000-0xefffffff pref]
[    0.318049] pci 0000:04:00.0: BAR 14: assigned [io  0x2000-0x20ff]
[    0.318051] pci 0000:04:00.0: BAR 13: assigned [io  0x2400-0x24ff]
[    0.318052] pci 0000:04:00.0: CardBus bridge to [bus 05-08]
[    0.318054] pci 0000:04:00.0:   bridge window [io  0x2400-0x24ff]
[    0.318059] pci 0000:04:00.0:   bridge window [io  0x2000-0x20ff]
[    0.318065] pci 0000:04:00.0:   bridge window [mem 0xec000000-0xefffffff pref]
[    0.318071] pci 0000:00:1c.2: PCI bridge to [bus 04-05]
[    0.318074] pci 0000:00:1c.2:   bridge window [io  0x2000-0x3fff]
[    0.318080] pci 0000:00:1c.2:   bridge window [mem 0xe3100000-0xe59fffff]
[    0.318084] pci 0000:00:1c.2:   bridge window [mem 0xec000000-0xefffffff pref]
[    0.318090] pci 0000:00:1c.3: PCI bridge to [bus 06-0b]
[    0.318093] pci 0000:00:1c.3:   bridge window [io  0x4000-0x4fff]
[    0.318099] pci 0000:00:1c.3:   bridge window [mem 0xe5a00000-0xe6dfffff]
[    0.318103] pci 0000:00:1c.3:   bridge window [mem 0xe9b00000-0xe9cfffff 64bit pref]
[    0.318110] pci 0000:00:1e.0: PCI bridge to [bus 0c]
[    0.318172] pci 0000:00:1e.0: setting latency timer to 64
[    0.318176] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.318177] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.318179] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.318180] pci_bus 0000:00: resource 7 [mem 0xd0000000-0xfeafffff]
[    0.318182] pci_bus 0000:01: resource 0 [io  0x7000-0x7fff]
[    0.318183] pci_bus 0000:01: resource 1 [mem 0xd0000000-0xe30fffff]
[    0.318184] pci_bus 0000:02: resource 0 [io  0x6000-0x6fff]
[    0.318186] pci_bus 0000:02: resource 1 [mem 0xe8200000-0xe95fffff]
[    0.318187] pci_bus 0000:02: resource 2 [mem 0xe9700000-0xe98fffff 64bit pref]
[    0.318189] pci_bus 0000:03: resource 0 [io  0x5000-0x5fff]
[    0.318190] pci_bus 0000:03: resource 1 [mem 0xe6e00000-0xe81fffff]
[    0.318191] pci_bus 0000:03: resource 2 [mem 0xe9900000-0xe9afffff 64bit pref]
[    0.318193] pci_bus 0000:04: resource 0 [io  0x2000-0x3fff]
[    0.318194] pci_bus 0000:04: resource 1 [mem 0xe3100000-0xe59fffff]
[    0.318196] pci_bus 0000:04: resource 2 [mem 0xec000000-0xefffffff pref]
[    0.318197] pci_bus 0000:05: resource 0 [io  0x2400-0x24ff]
[    0.318198] pci_bus 0000:05: resource 1 [io  0x2000-0x20ff]
[    0.318200] pci_bus 0000:05: resource 2 [mem 0xec000000-0xefffffff pref]
[    0.318201] pci_bus 0000:06: resource 0 [io  0x4000-0x4fff]
[    0.318203] pci_bus 0000:06: resource 1 [mem 0xe5a00000-0xe6dfffff]
[    0.318204] pci_bus 0000:06: resource 2 [mem 0xe9b00000-0xe9cfffff 64bit pref]
[    0.318206] pci_bus 0000:0c: resource 4 [io  0x0000-0x0cf7]
[    0.318207] pci_bus 0000:0c: resource 5 [io  0x0d00-0xffff]
[    0.318208] pci_bus 0000:0c: resource 6 [mem 0x000a0000-0x000bffff]
[    0.318210] pci_bus 0000:0c: resource 7 [mem 0xd0000000-0xfeafffff]
[    0.318231] NET: Registered protocol family 2
[    0.318336] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.318555] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.318665] TCP: Hash tables configured (established 131072 bind 65536)
[    0.318680] TCP: reno registered
[    0.318682] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    0.318686] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    0.318732] NET: Registered protocol family 1
[    0.318821] pci 0000:01:00.0: Boot video device
[    0.318879] PCI: CLS 64 bytes, default 64
[    0.318910] Trying to unpack rootfs image as initramfs...
[    0.383681] Freeing initrd memory: 3952k freed
[    0.384437] Simple Boot Flag at 0xf1 set to 0x1
[    0.384733] audit: initializing netlink socket (disabled)
[    0.384748] type=2000 audit(1345649260.264:1): initialized
[    0.401049] bounce pool size: 64 pages
[    0.401053] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    0.401919] VFS: Disk quotas dquot_6.5.2
[    0.401951] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.402212] fuse init (API version 7.19)
[    0.402272] msgmni has been set to 1703
[    0.402495] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.402497] io scheduler noop registered
[    0.402498] io scheduler deadline registered
[    0.402502] io scheduler cfq registered (default)
[    0.402592] pcieport 0000:00:01.0: irq 40 for MSI/MSI-X
[    0.402836] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.402849] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.402887] intel_idle: MWAIT substates: 0x1120
[    0.402889] intel_idle: v0.4 model 0x25
[    0.402889] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.403193] ACPI: Deprecated procfs I/F for AC is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    0.403523] ACPI: AC Adapter [AC] (on-line)
[    0.403873] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
[    0.404313] ACPI: Lid Switch [LID]
[    0.404340] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[    0.404343] ACPI: Power Button [PBTN]
[    0.404365] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input2
[    0.404367] ACPI: Sleep Button [SBTN]
[    0.404389] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    0.404391] ACPI: Power Button [PWRF]
[    0.404557] ACPI: Requesting acpi_cpufreq
[    0.421175] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.421364] ACPI: Deprecated procfs I/F for battery is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    0.421368] ACPI: Battery Slot [BAT0] (battery absent)
[    0.437115] brd: module loaded
[    0.437580] loop: module loaded
[    0.437791] libphy: Fixed MDIO Bus: probed
[    0.437803] tun: Universal TUN/TAP device driver, 1.6
[    0.437804] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    0.437832] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.437855] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[    0.437858] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[    0.437862] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    0.441771] ehci_hcd 0000:00:1a.0: debug port 2
[    0.441783] ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
[    0.441797] ehci_hcd 0000:00:1a.0: irq 16, io mem 0xe9670000
[    0.442408] ACPI: Deprecated procfs I/F for battery is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    0.442412] ACPI: Battery Slot [BAT1] (battery absent)
[    0.452077] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    0.452221] hub 1-0:1.0: USB hub found
[    0.452225] hub 1-0:1.0: 3 ports detected
[    0.452275] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[    0.452278] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[    0.452281] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    0.456172] ehci_hcd 0000:00:1d.0: debug port 2
[    0.456178] ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
[    0.456190] ehci_hcd 0000:00:1d.0: irq 17, io mem 0xe9650000
[    0.468045] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    0.468165] hub 2-0:1.0: USB hub found
[    0.468167] hub 2-0:1.0: 3 ports detected
[    0.468207] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.468214] uhci_hcd: USB Universal Host Controller Interface driver
[    0.468258] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    0.468460] i8042: Warning: Keylock active
[    0.469646] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.469650] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.469728] mousedev: PS/2 mouse device common for all mice
[    0.469851] rtc_cmos 00:06: RTC can wake from S4
[    0.469999] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
[    0.470026] rtc0: alarms up to one year, y3k, 242 bytes nvram, hpet irqs
[    0.470087] cpuidle: using governor ladder
[    0.470148] cpuidle: using governor menu
[    0.470150] EFI Variables Facility v0.08 2004-May-17
[    0.470234] TCP: cubic registered
[    0.470306] NET: Registered protocol family 10
[    0.470502] NET: Registered protocol family 17
[    0.470525] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
[    0.470548] Key type dns_resolver registered
[    0.470987] Using IPI No-Shortcut mode
[    0.471489] PM: Hibernation image not present or could not be loaded.
[    0.471503] registered taskstats version 1
[    0.472482]   Magic number: 8:183:488
[    0.472537] regulator regulator.0: hash matches
[    0.472663] rtc_cmos 00:06: setting system clock to 2012-08-22 15:27:40 UTC (1345649260)
[    0.473691] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    0.473692] EDD information not available.
[    0.473891] Freeing unused kernel memory: 572k freed
[    0.474064] Write protecting the kernel text: 4940k
[    0.474116] Write protecting the kernel read-only data: 1972k
[    0.489510] udev[67]: starting version 163
[    0.503204] sdhci: Secure Digital Host Controller Interface driver
[    0.503207] sdhci: Copyright(c) Pierre Ossman
[    0.503425] sdhci-pci 0000:04:00.1: SDHCI controller found [1180:e822] (rev 3)
[    0.503476] mmc0: no vmmc regulator found
[    0.503529] Registered led device: mmc0::
[    0.504231] e1000e: Intel(R) PRO/1000 Network Driver - 2.0.0-k
[    0.504232] e1000e: Copyright(c) 1999 - 2012 Intel Corporation.
[    0.504263] e1000e 0000:00:19.0: setting latency timer to 64
[    0.504324] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[    0.504367] e1000e 0000:00:19.0: irq 41 for MSI/MSI-X
[    1.207964] e1000e 0000:00:19.0: eth0: (PCI Express:2.5GT/s:Width x1) 5c:26:0a:4b:41:d9
[    1.207968] e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    1.208019] e1000e 0000:00:19.0: eth0: MAC: 9, PHY: 10, PBA No: 3041FF-0FF
[    1.208042] ahci 0000:00:1f.2: version 3.0
[    1.208112] ahci 0000:00:1f.2: irq 42 for MSI/MSI-X
[    1.208216] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 3 Gbps 0x33 impl SATA mode
[    1.208220] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ems sxs apst 
[    1.208225] ahci 0000:00:1f.2: setting latency timer to 64
[    1.231172] scsi0 : ahci
[    1.231355] scsi1 : ahci
[    1.231540] scsi2 : ahci
[    1.231755] scsi3 : ahci
[    1.231938] scsi4 : ahci
[    1.232140] scsi5 : ahci
[    1.232218] ata1: SATA max UDMA/133 abar m2048@0xe9640000 port 0xe9640100 irq 42
[    1.232224] ata2: SATA max UDMA/133 abar m2048@0xe9640000 port 0xe9640180 irq 42
[    1.232226] ata3: DUMMY
[    1.232227] ata4: DUMMY
[    1.232231] ata5: SATA max UDMA/133 abar m2048@0xe9640000 port 0xe9640300 irq 42
[    1.232238] ata6: SATA max UDMA/133 abar m2048@0xe9640000 port 0xe9640380 irq 42
[    1.262711] usb 1-1: new high-speed USB device number 2 using ehci_hcd
[    1.395413] hub 1-1:1.0: USB hub found
[    1.395610] hub 1-1:1.0: 6 ports detected
[    1.506337] usb 2-1: new high-speed USB device number 2 using ehci_hcd
[    1.550280] ata5: SATA link down (SStatus 0 SControl 300)
[    1.550316] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.550355] ata6: SATA link down (SStatus 0 SControl 300)
[    1.550398] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.552011] ata1.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by device (Stat=0x51 Err=0x04)
[    1.554209] ata2.00: ATAPI: HL-DT-ST DVD-ROM DU30N, A100, max UDMA/133
[    1.558080] ata2.00: configured for UDMA/133
[    1.592704] ata1.00: ATA-8: ST9250410AS, D005SDM1, max UDMA/133
[    1.592709] ata1.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    1.595215] ata1.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by device (Stat=0x51 Err=0x04)
[    1.595598] ata1.00: configured for UDMA/133
[    1.595931] scsi 0:0:0:0: Direct-Access     ATA      ST9250410AS      D005 PQ: 0 ANSI: 5
[    1.596149] sd 0:0:0:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 GiB)
[    1.596156] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.596186] sd 0:0:0:0: [sda] Write Protect is off
[    1.596189] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.596206] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.598865] scsi 1:0:0:0: CD-ROM            HL-DT-ST DVD-ROM DU30N    A100 PQ: 0 ANSI: 5
[    1.602776] sr0: scsi3-mmc drive: 24x/24x cd/rw xa/form2 cdda tray
[    1.602781] cdrom: Uniform CD-ROM driver Revision: 3.20
[    1.602931] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    1.602999] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    1.638878] hub 2-1:1.0: USB hub found
[    1.639050] hub 2-1:1.0: 8 ports detected
[    1.657899]  sda: sda1 sda2 < sda5 sda6 sda7 >
[    1.659129] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.710138] usb 1-1.4: new high-speed USB device number 3 using ehci_hcd
[    1.881676] tsc: Refined TSC clocksource calibration: 2792.980 MHz
[    1.881682] Switching to clocksource tsc
[    1.909735] usb 2-1.7: new full-speed USB device number 3 using ehci_hcd
[    2.077475] usb 2-1.8: new full-speed USB device number 4 using ehci_hcd
[    2.191980] usb 2-1.8: config 0 descriptor??
[    2.274088] EXT4-fs (sda5): mounted filesystem with ordered data mode. Opts: (null)
[    4.840349] Adding 4939772k swap on /dev/sda7.  Priority:-1 extents:1 across:4939772k 
[    6.003587] udev[313]: starting version 163
[    6.946948] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[    6.952530] input: Dell WMI hotkeys as /devices/virtual/input/input5
[    7.093385] microcode: CPU0 sig=0x20655, pf=0x10, revision=0x2
[    1.596306] ACPI: Invalid Power Resource to register!
[    7.114446] ACPI Warning: 0x00000460-0x0000047f SystemIO conflicts with Region \PMIO 1 (20120711/utaddress-251)
[    7.114453] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    7.114455] lpc_ich: Resource conflict(s) found affecting iTCO_wdt
[    7.114458] ACPI Warning: 0x00000428-0x0000042f SystemIO conflicts with Region \PMIO 1 (20120711/utaddress-251)
[    7.114461] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    7.114464] ACPI Warning: 0x00000500-0x0000057f SystemIO conflicts with Region \GPIO 1 (20120711/utaddress-251)
[    7.114466] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    7.114467] lpc_ich: Resource conflict(s) found affecting gpio_ich
[    7.132063] intel ips 0000:00:1f.6: CPU TDP doesn't match expected value (found 25, expected 29)
[    7.132103] intel ips 0000:00:1f.6: failed to get i915 symbols, graphics turbo disabled until i915 loads
[    7.132255] intel ips 0000:00:1f.6: IPS driver initialized, MCP temp limit 90
[    7.148957] Linux agpgart interface v0.103
[    7.182279] acpi device:03: registered as cooling_device4
[    7.183060] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[    7.183100] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:01/LNXVIDEO:00/input/input6
[    7.599503] microcode: CPU1 sig=0x20655, pf=0x10, revision=0x2
[    7.600166] microcode: CPU2 sig=0x20655, pf=0x10, revision=0x2
[    7.600814] microcode: CPU3 sig=0x20655, pf=0x10, revision=0x2
[    7.601438] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    7.630207] [drm] Initialized drm 1.1.0 20060810
[    8.033230] [drm] nouveau 0000:01:00.0: Detected an NV50 generation card (0x0a8600b1)
[    8.034214] [drm] nouveau 0000:01:00.0: Checking PRAMIN for VBIOS
[    8.107226] [drm] nouveau 0000:01:00.0: ... appears to be valid
[    8.107229] [drm] nouveau 0000:01:00.0: Using VBIOS from PRAMIN
[    8.107231] [drm] nouveau 0000:01:00.0: BIT BIOS found
[    8.107233] [drm] nouveau 0000:01:00.0: Bios version 70.18.53.00
[    8.107235] [drm] nouveau 0000:01:00.0: TMDS table version 2.0
[    8.107654] [drm] nouveau 0000:01:00.0: MXM: no VBIOS data, nothing to do
[    8.107656] [drm] nouveau 0000:01:00.0: DCB version 4.0
[    8.107658] [drm] nouveau 0000:01:00.0: DCB outp 00: 048003b6 0f200014
[    8.107660] [drm] nouveau 0000:01:00.0: DCB outp 01: 02033300 00000000
[    8.107661] [drm] nouveau 0000:01:00.0: DCB outp 02: 088223a6 0f220010
[    8.107662] [drm] nouveau 0000:01:00.0: DCB outp 03: 08022362 00020010
[    8.107663] [drm] nouveau 0000:01:00.0: DCB outp 04: 028113c6 0f220010
[    8.107664] [drm] nouveau 0000:01:00.0: DCB outp 05: 02011382 00020010
[    8.107665] [drm] nouveau 0000:01:00.0: DCB conn 00: 00002047
[    8.107667] [drm] nouveau 0000:01:00.0: DCB conn 01: 00101146
[    8.107668] [drm] nouveau 0000:01:00.0: DCB conn 02: 00410246
[    8.107669] [drm] nouveau 0000:01:00.0: DCB conn 03: 00000300
[    8.107676] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 0 at offset 0x6F74
[    8.168137] [drm] nouveau 0000:01:00.0: 0x7241: Condition still not met after 20ms, skipping following opcodes
[    8.187952] [drm] nouveau 0000:01:00.0: 0x7245: Condition still not met after 20ms, skipping following opcodes
[    8.192259] type=1400 audit(1345642066.908:2): apparmor="STATUS" operation="profile_load" name="/sbin/dhclient3" pid=464 comm="apparmor_parser"
[    8.192311] type=1400 audit(1345642066.908:3): apparmor="STATUS" operation="profile_load" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=464 comm="apparmor_parser"
[    8.192356] type=1400 audit(1345642066.908:4): apparmor="STATUS" operation="profile_load" name="/usr/lib/connman/scripts/dhclient-script" pid=464 comm="apparmor_parser"
[    8.196327] type=1400 audit(1345642066.912:5): apparmor="STATUS" operation="profile_replace" name="/sbin/dhclient3" pid=502 comm="apparmor_parser"
[    8.196362] type=1400 audit(1345642066.912:6): apparmor="STATUS" operation="profile_replace" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=502 comm="apparmor_parser"
[    8.196392] type=1400 audit(1345642066.912:7): apparmor="STATUS" operation="profile_replace" name="/usr/lib/connman/scripts/dhclient-script" pid=502 comm="apparmor_parser"
[    8.207791] [drm] nouveau 0000:01:00.0: 0x73F2: Condition still not met after 20ms, skipping following opcodes
[    8.207797] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 1 at offset 0x741F
[    8.215505] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 2 at offset 0x7FCB
[    8.215515] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 3 at offset 0x7FE4
[    8.258008] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 4 at offset 0x80CB
[    8.258009] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table at offset 0x8130
[    8.277859] [drm] nouveau 0000:01:00.0: 0x6DE8: Condition still not met after 20ms, skipping following opcodes
[    8.282841] [TTM] Zone  kernel: Available graphics memory: 436362 kiB
[    8.282843] [TTM] Zone highmem: Available graphics memory: 1680716 kiB
[    8.282844] [TTM] Initializing pool allocator
[    8.282861] [drm] nouveau 0000:01:00.0: Detected 512MiB VRAM (DDR3)
[    8.284407] [drm] nouveau 0000:01:00.0: 512 MiB GART (aperture)
[    8.336396] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    8.336399] [drm] No driver support for vblank timestamp query.
[    8.336401] [drm] nouveau 0000:01:00.0: ACPI backlight interface available, not registering our own
[    8.341544] [drm] nouveau 0000:01:00.0: 3 available performance level(s)
[    8.341547] [drm] nouveau 0000:01:00.0: 0: core 135MHz shader 270MHz memory 135MHz voltage 850mV
[    8.341548] [drm] nouveau 0000:01:00.0: 1: core 405MHz shader 810MHz memory 405MHz voltage 850mV
[    8.341550] [drm] nouveau 0000:01:00.0: 3: core 606MHz shader 1468MHz memory 790MHz voltage 1000mV
[    8.341552] [drm] nouveau 0000:01:00.0: c: core 405MHz shader 810MHz memory 405MHz voltage 1000mV
[    8.372566] [drm] nouveau 0000:01:00.0: MM: using COPY for buffer copies
[    8.572513] input: DualPoint Stick as /devices/platform/i8042/serio1/input/input7
[    8.585144] input: AlpsPS/2 ALPS DualPoint TouchPad as /devices/platform/i8042/serio1/input/input8
[    8.787069] [drm] nouveau 0000:01:00.0: allocated 1440x900 fb: 0x2c0000, bo f48b7800
[    8.787198] fbcon: nouveaufb (fb0) is primary device
[    8.808970] dell_wmi: Received unknown WMI event (0x11)
[    8.838044] snd_hda_intel 0000:00:1b.0: irq 43 for MSI/MSI-X
[    8.928153] Console: switching to colour frame buffer device 180x56
[    8.929466] input: HDA Intel Dock Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
[    8.929574] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
[    8.929674] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
[    8.929771] input: HDA Intel Dock Line Out as /devices/pci0000:00/0000:00:1b.0/sound/card0/input12
[    9.061071] fb0: nouveaufb frame buffer device
[    9.061073] drm: registered panic notifier
[    9.061077] [drm] Initialized nouveau 1.0.0 20120316 for 0000:01:00.0 on minor 0
[    9.061110] hda_intel: Disabling MSI
[    9.061122] hda-intel: 0000:01:00.1: Handle VGA-switcheroo audio client
[    9.216417] dell_wmi: Received unknown WMI event (0x11)
[   10.237489] hda_codec: rates == 0 (nid=0x1, val=0x0, ovrd=0)
[   10.237517] hda_codec: cannot attach PCM stream 3 for codec #0
[   10.245500] hda_codec: rates == 0 (nid=0x1, val=0x0, ovrd=0)
[   10.245515] hda_codec: cannot attach PCM stream 7 for codec #1
[   10.253482] hda_codec: rates == 0 (nid=0x1, val=0x0, ovrd=0)
[   10.253496] hda_codec: cannot attach PCM stream 8 for codec #2
[   10.261440] hda_codec: rates == 0 (nid=0x1, val=0x0, ovrd=0)
[   10.261465] hda_codec: cannot attach PCM stream 9 for codec #3
[   10.357446] input: HDA NVidia HDMI/DP,pcm=9 as /devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input13
[   10.357559] input: HDA NVidia HDMI/DP,pcm=8 as /devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input14
[   10.357624] input: HDA NVidia HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input15
[   10.357727] input: HDA NVidia HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input16
[   11.859461] EXT4-fs (sda5): re-mounted. Opts: errors=remount-ro
[   12.566497] EXT4-fs (sda6): mounted filesystem with ordered data mode. Opts: (null)
[   13.297005] sshd (836): /proc/836/oom_adj is deprecated, please use /proc/836/oom_score_adj instead.
[   13.822543] type=1400 audit(1345642072.548:8): apparmor="STATUS" operation="profile_load" name="/usr/share/gdm/guest-session/Xsession" pid=865 comm="apparmor_parser"
[   13.872379] type=1400 audit(1345642072.600:9): apparmor="STATUS" operation="profile_replace" name="/sbin/dhclient3" pid=866 comm="apparmor_parser"
[   13.872447] type=1400 audit(1345642072.600:10): apparmor="STATUS" operation="profile_replace" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=866 comm="apparmor_parser"
[   13.872502] type=1400 audit(1345642072.600:11): apparmor="STATUS" operation="profile_replace" name="/usr/lib/connman/scripts/dhclient-script" pid=866 comm="apparmor_parser"
[   13.908572] type=1400 audit(1345642072.636:12): apparmor="STATUS" operation="profile_load" name="/usr/sbin/tcpdump" pid=872 comm="apparmor_parser"
[   13.971981] type=1400 audit(1345642072.700:13): apparmor="STATUS" operation="profile_load" name="/usr/lib/cups/backend/cups-pdf" pid=869 comm="apparmor_parser"
[   13.972085] type=1400 audit(1345642072.700:14): apparmor="STATUS" operation="profile_load" name="/usr/sbin/cupsd" pid=869 comm="apparmor_parser"
[   15.055988] e1000e 0000:00:19.0: irq 41 for MSI/MSI-X
[   15.157097] e1000e 0000:00:19.0: irq 41 for MSI/MSI-X
[   15.157213] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   15.888510] dell_wmi: Received unknown WMI event (0x11)
[   16.488278] dell_wmi: Received unknown WMI event (0x11)
[   16.488932] type=1400 audit(1345642075.220:15): apparmor="STATUS" operation="profile_load" name="/usr/bin/evince" pid=867 comm="apparmor_parser"
[   16.489258] type=1400 audit(1345642075.220:16): apparmor="STATUS" operation="profile_load" name="/usr/bin/evince-previewer" pid=867 comm="apparmor_parser"
[   16.489543] type=1400 audit(1345642075.220:17): apparmor="STATUS" operation="profile_load" name="/usr/bin/evince-thumbnailer" pid=867 comm="apparmor_parser"
[   18.254077] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx
[   18.254128] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   21.267036] EXT4-fs (sda5): re-mounted. Opts: errors=remount-ro,commit=0
[   21.342477] EXT4-fs (sda6): re-mounted. Opts: commit=0
[   24.788077] EXT4-fs (sda5): re-mounted. Opts: errors=remount-ro,commit=0
[   24.790103] EXT4-fs (sda6): re-mounted. Opts: commit=0
[  186.557920] type=1400 audit(1345642247.668:18): apparmor="STATUS" operation="profile_replace" name="/usr/lib/cups/backend/cups-pdf" pid=1365 comm="apparmor_parser"
[  186.557999] type=1400 audit(1345642247.668:19): apparmor="STATUS" operation="profile_replace" name="/usr/sbin/cupsd" pid=1365 comm="apparmor_parser"
[  241.908294] INFO: task modprobe:134 blocked for more than 120 seconds.
[  241.908298] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  241.908301] modprobe        D f48abbcc     0   134     98 0x00000000
[  241.908307]  f48abc3c 00000082 f59d0ebc f48abbcc c1289228 00000000 f4f3e480 c17b0380
[  241.908313]  c17b0380 c17b0380 1de51926 00000000 c17b0380 f59d5380 f4f3e480 f4853ed0
[  241.908319]  00000000 00000001 f48abc28 00000000 f59d0eb0 f4df3131 c17abe80 00000003
[  241.908326] Call Trace:
[  241.908337]  [<c1289228>] ? timerqueue_add+0x58/0xb0
[  241.908345]  [<c14ca103>] schedule+0x23/0x60
[  241.908349]  [<c14c8f5f>] schedule_hrtimeout_range_clock+0xaf/0x130
[  241.908354]  [<c105b4f0>] ? update_rmtp+0x80/0x80
[  241.908359]  [<c105c796>] ? hrtimer_start_range_ns+0x26/0x30
[  241.908362]  [<c14c8ff7>] schedule_hrtimeout_range+0x17/0x20
[  241.908369]  [<c10462c9>] usleep_range+0x39/0x40
[  241.908384]  [<f8030b39>] sdhci_do_start_signal_voltage_switch+0x59/0x150 [sdhci]
[  241.908390]  [<f8030c71>] sdhci_start_signal_voltage_switch+0x41/0x80 [sdhci]
[  241.908401]  [<f805ded8>] mmc_set_signal_voltage+0x58/0xb0 [mmc_core]
[  241.908411]  [<f805e105>] mmc_power_up+0x85/0xf0 [mmc_core]
[  241.908420]  [<f805e1a8>] mmc_start_host+0x38/0x50 [mmc_core]
[  241.908430]  [<f805f4b0>] mmc_add_host+0x50/0x90 [mmc_core]
[  241.908436]  [<f8031b37>] sdhci_add_host+0x837/0xbc0 [sdhci]
[  241.908444]  [<f807f10a>] sdhci_pci_probe+0x3fc/0x5f0 [sdhci_pci]
[  241.908449]  [<c14cac5f>] ? _raw_spin_lock_irqsave+0x2f/0x50
[  241.908455]  [<c12a5407>] local_pci_probe+0x47/0xb0
[  241.908460]  [<c12a6458>] pci_device_probe+0x68/0x90
[  241.908467]  [<c1337c48>] driver_probe_device+0x78/0x1f0
[  241.908471]  [<c12a5393>] ? pci_match_device+0xb3/0xc0
[  241.908476]  [<c1337e41>] __driver_attach+0x81/0x90
[  241.908480]  [<c1336613>] bus_for_each_dev+0x53/0x80
[  241.908484]  [<c1337abe>] driver_attach+0x1e/0x20
[  241.908488]  [<c1337dc0>] ? driver_probe_device+0x1f0/0x1f0
[  241.908491]  [<c1337512>] bus_add_driver+0xb2/0x230
[  241.908495]  [<c12a62d0>] ? pci_dev_put+0x20/0x20
[  241.908499]  [<c12a62d0>] ? pci_dev_put+0x20/0x20
[  241.908502]  [<c133841a>] driver_register+0x6a/0x140
[  241.908509]  [<c10be41b>] ? tracepoint_module_notify+0x12b/0x190
[  241.908514]  [<c12a6694>] __pci_register_driver+0x44/0xb0
[  241.908522]  [<f8086017>] sdhci_drv_init+0x17/0x19 [sdhci_pci]
[  241.908526]  [<c1001114>] do_one_initcall+0x34/0x170
[  241.908532]  [<f8086000>] ? 0xf8085fff
[  241.908539]  [<c1090c3e>] sys_init_module+0xee/0x1460
[  241.908542]  [<c108f620>] ? free_notes_attrs+0x50/0x50
[  241.908549]  [<f8073000>] ? 0xf8072fff
[  241.908556]  [<c14d175f>] sysenter_do_call+0x12/0x28
[  241.908560] INFO: task modprobe:136 blocked for more than 120 seconds.
[  241.908561] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  241.908563] modprobe        D f54feb40     0   136    101 0x00000000
[  241.908567]  f48afdf8 00000086 f494f740 f54feb40 f48afde8 f48afdb0 f4f3f110 c17b0380
[  241.908573]  c17b0380 c17b0380 1ed81e72 00000000 c17b0380 f59c8380 f4f3f110 f48a4b60
[  241.908579]  f494f740 f48afde8 f48afdd8 f48afdd8 c11843da 41edfde8 f48afdd0 c14c8bd9
[  241.908585] Call Trace:
[  241.908592]  [<c11843da>] ? sysfs_addrm_finish+0x1a/0xa0
[  241.908595]  [<c14c8bd9>] ? mutex_lock+0x19/0x40
[  241.908599]  [<c1184d1c>] ? create_dir+0x6c/0xa0
[  241.908602]  [<c14ca103>] schedule+0x23/0x60
[  241.908606]  [<c14ca39d>] schedule_preempt_disabled+0xd/0x10
[  241.908609]  [<c14c8cc6>] __mutex_lock_slowpath+0xc6/0x120
[  241.908613]  [<c14c8be5>] mutex_lock+0x25/0x40
[  241.908618]  [<c1337e0e>] __driver_attach+0x4e/0x90
[  241.908621]  [<c1336613>] bus_for_each_dev+0x53/0x80
[  241.908625]  [<c1337abe>] driver_attach+0x1e/0x20
[  241.908629]  [<c1337dc0>] ? driver_probe_device+0x1f0/0x1f0
[  241.908632]  [<c1337512>] bus_add_driver+0xb2/0x230
[  241.908636]  [<c12a62d0>] ? pci_dev_put+0x20/0x20
[  241.908640]  [<c12a62d0>] ? pci_dev_put+0x20/0x20
[  241.908643]  [<c133841a>] driver_register+0x6a/0x140
[  241.908647]  [<c10be41b>] ? tracepoint_module_notify+0x12b/0x190
[  241.908653]  [<c12a6694>] __pci_register_driver+0x44/0xb0
[  241.908660]  [<f817d017>] fw_ohci_pci_driver_init+0x17/0x19 [firewire_ohci]
[  241.908664]  [<c1001114>] do_one_initcall+0x34/0x170
[  241.908669]  [<f817d000>] ? 0xf817cfff
[  241.908673]  [<c1090c3e>] sys_init_module+0xee/0x1460
[  241.908677]  [<c108f620>] ? free_notes_attrs+0x50/0x50
[  241.908686]  [<c14d175f>] sysenter_do_call+0x12/0x28
[  361.700943] INFO: task modprobe:134 blocked for more than 120 seconds.
[  361.700948] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  361.700950] modprobe        D f48abbcc     0   134     98 0x00000000
[  361.700956]  f48abc3c 00000082 f59d0ebc f48abbcc c1289228 00000000 f4f3e480 c17b0380
[  361.700962]  c17b0380 c17b0380 1de51926 00000000 c17b0380 f59d5380 f4f3e480 f4853ed0
[  361.700968]  00000000 00000001 f48abc28 00000000 f59d0eb0 f4df3131 c17abe80 00000003
[  361.700975] Call Trace:
[  361.700986]  [<c1289228>] ? timerqueue_add+0x58/0xb0
[  361.700993]  [<c14ca103>] schedule+0x23/0x60
[  361.700997]  [<c14c8f5f>] schedule_hrtimeout_range_clock+0xaf/0x130
[  361.701002]  [<c105b4f0>] ? update_rmtp+0x80/0x80
[  361.701006]  [<c105c796>] ? hrtimer_start_range_ns+0x26/0x30
[  361.701010]  [<c14c8ff7>] schedule_hrtimeout_range+0x17/0x20
[  361.701016]  [<c10462c9>] usleep_range+0x39/0x40
[  361.701030]  [<f8030b39>] sdhci_do_start_signal_voltage_switch+0x59/0x150 [sdhci]
[  361.701036]  [<f8030c71>] sdhci_start_signal_voltage_switch+0x41/0x80 [sdhci]
[  361.701046]  [<f805ded8>] mmc_set_signal_voltage+0x58/0xb0 [mmc_core]
[  361.701056]  [<f805e105>] mmc_power_up+0x85/0xf0 [mmc_core]
[  361.701065]  [<f805e1a8>] mmc_start_host+0x38/0x50 [mmc_core]
[  361.701075]  [<f805f4b0>] mmc_add_host+0x50/0x90 [mmc_core]
[  361.701081]  [<f8031b37>] sdhci_add_host+0x837/0xbc0 [sdhci]
[  361.701088]  [<f807f10a>] sdhci_pci_probe+0x3fc/0x5f0 [sdhci_pci]
[  361.701094]  [<c14cac5f>] ? _raw_spin_lock_irqsave+0x2f/0x50
[  361.701099]  [<c12a5407>] local_pci_probe+0x47/0xb0
[  361.701105]  [<c12a6458>] pci_device_probe+0x68/0x90
[  361.701112]  [<c1337c48>] driver_probe_device+0x78/0x1f0
[  361.701116]  [<c12a5393>] ? pci_match_device+0xb3/0xc0
[  361.701120]  [<c1337e41>] __driver_attach+0x81/0x90
[  361.701125]  [<c1336613>] bus_for_each_dev+0x53/0x80
[  361.701129]  [<c1337abe>] driver_attach+0x1e/0x20
[  361.701132]  [<c1337dc0>] ? driver_probe_device+0x1f0/0x1f0
[  361.701136]  [<c1337512>] bus_add_driver+0xb2/0x230
[  361.701140]  [<c12a62d0>] ? pci_dev_put+0x20/0x20
[  361.701144]  [<c12a62d0>] ? pci_dev_put+0x20/0x20
[  361.701147]  [<c133841a>] driver_register+0x6a/0x140
[  361.701153]  [<c10be41b>] ? tracepoint_module_notify+0x12b/0x190
[  361.701158]  [<c12a6694>] __pci_register_driver+0x44/0xb0
[  361.701166]  [<f8086017>] sdhci_drv_init+0x17/0x19 [sdhci_pci]
[  361.701170]  [<c1001114>] do_one_initcall+0x34/0x170
[  361.701176]  [<f8086000>] ? 0xf8085fff
[  361.701182]  [<c1090c3e>] sys_init_module+0xee/0x1460
[  361.701186]  [<c108f620>] ? free_notes_attrs+0x50/0x50
[  361.701193]  [<f8073000>] ? 0xf8072fff
[  361.701200]  [<c14d175f>] sysenter_do_call+0x12/0x28
[  361.701204] INFO: task modprobe:136 blocked for more than 120 seconds.
[  361.701205] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  361.701207] modprobe        D f54feb40     0   136    101 0x00000000
[  361.701211]  f48afdf8 00000086 f494f740 f54feb40 f48afde8 f48afdb0 f4f3f110 c17b0380
[  361.701217]  c17b0380 c17b0380 1ed81e72 00000000 c17b0380 f59c8380 f4f3f110 f48a4b60
[  361.701223]  f494f740 f48afde8 f48afdd8 f48afdd8 c11843da 41edfde8 f48afdd0 c14c8bd9
[  361.701229] Call Trace:
[  361.701236]  [<c11843da>] ? sysfs_addrm_finish+0x1a/0xa0
[  361.701239]  [<c14c8bd9>] ? mutex_lock+0x19/0x40
[  361.701243]  [<c1184d1c>] ? create_dir+0x6c/0xa0
[  361.701246]  [<c14ca103>] schedule+0x23/0x60
[  361.701250]  [<c14ca39d>] schedule_preempt_disabled+0xd/0x10
[  361.701253]  [<c14c8cc6>] __mutex_lock_slowpath+0xc6/0x120
[  361.701257]  [<c14c8be5>] mutex_lock+0x25/0x40
[  361.701261]  [<c1337e0e>] __driver_attach+0x4e/0x90
[  361.701265]  [<c1336613>] bus_for_each_dev+0x53/0x80
[  361.701269]  [<c1337abe>] driver_attach+0x1e/0x20
[  361.701273]  [<c1337dc0>] ? driver_probe_device+0x1f0/0x1f0
[  361.701276]  [<c1337512>] bus_add_driver+0xb2/0x230
[  361.701280]  [<c12a62d0>] ? pci_dev_put+0x20/0x20
[  361.701284]  [<c12a62d0>] ? pci_dev_put+0x20/0x20
[  361.701287]  [<c133841a>] driver_register+0x6a/0x140
[  361.701291]  [<c10be41b>] ? tracepoint_module_notify+0x12b/0x190
[  361.701296]  [<c12a6694>] __pci_register_driver+0x44/0xb0
[  361.701304]  [<f817d017>] fw_ohci_pci_driver_init+0x17/0x19 [firewire_ohci]
[  361.701307]  [<c1001114>] do_one_initcall+0x34/0x170
[  361.701312]  [<f817d000>] ? 0xf817cfff
[  361.701317]  [<c1090c3e>] sys_init_module+0xee/0x1460
[  361.701321]  [<c108f620>] ? free_notes_attrs+0x50/0x50
[  361.701330]  [<c14d175f>] sysenter_do_call+0x12/0x28
[  481.493601] INFO: task modprobe:134 blocked for more than 120 seconds.
[  481.493605] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  481.493608] modprobe        D f48abbcc     0   134     98 0x00000000
[  481.493613]  f48abc3c 00000082 f59d0ebc f48abbcc c1289228 00000000 f4f3e480 c17b0380
[  481.493619]  c17b0380 c17b0380 1de51926 00000000 c17b0380 f59d5380 f4f3e480 f4853ed0
[  481.493625]  00000000 00000001 f48abc28 00000000 f59d0eb0 f4df3131 c17abe80 00000003
[  481.493632] Call Trace:
[  481.493640]  [<c1289228>] ? timerqueue_add+0x58/0xb0
[  481.493646]  [<c14ca103>] schedule+0x23/0x60
[  481.493650]  [<c14c8f5f>] schedule_hrtimeout_range_clock+0xaf/0x130
[  481.493654]  [<c105b4f0>] ? update_rmtp+0x80/0x80
[  481.493658]  [<c105c796>] ? hrtimer_start_range_ns+0x26/0x30
[  481.493662]  [<c14c8ff7>] schedule_hrtimeout_range+0x17/0x20
[  481.493667]  [<c10462c9>] usleep_range+0x39/0x40
[  481.493678]  [<f8030b39>] sdhci_do_start_signal_voltage_switch+0x59/0x150 [sdhci]
[  481.493684]  [<f8030c71>] sdhci_start_signal_voltage_switch+0x41/0x80 [sdhci]
[  481.493694]  [<f805ded8>] mmc_set_signal_voltage+0x58/0xb0 [mmc_core]
[  481.493703]  [<f805e105>] mmc_power_up+0x85/0xf0 [mmc_core]
[  481.493712]  [<f805e1a8>] mmc_start_host+0x38/0x50 [mmc_core]
[  481.493722]  [<f805f4b0>] mmc_add_host+0x50/0x90 [mmc_core]
[  481.493728]  [<f8031b37>] sdhci_add_host+0x837/0xbc0 [sdhci]
[  481.493736]  [<f807f10a>] sdhci_pci_probe+0x3fc/0x5f0 [sdhci_pci]
[  481.493741]  [<c14cac5f>] ? _raw_spin_lock_irqsave+0x2f/0x50
[  481.493746]  [<c12a5407>] local_pci_probe+0x47/0xb0
[  481.493751]  [<c12a6458>] pci_device_probe+0x68/0x90
[  481.493758]  [<c1337c48>] driver_probe_device+0x78/0x1f0
[  481.493761]  [<c12a5393>] ? pci_match_device+0xb3/0xc0
[  481.493766]  [<c1337e41>] __driver_attach+0x81/0x90
[  481.493771]  [<c1336613>] bus_for_each_dev+0x53/0x80
[  481.493775]  [<c1337abe>] driver_attach+0x1e/0x20
[  481.493778]  [<c1337dc0>] ? driver_probe_device+0x1f0/0x1f0
[  481.493781]  [<c1337512>] bus_add_driver+0xb2/0x230
[  481.493786]  [<c12a62d0>] ? pci_dev_put+0x20/0x20
[  481.493789]  [<c12a62d0>] ? pci_dev_put+0x20/0x20
[  481.493793]  [<c133841a>] driver_register+0x6a/0x140
[  481.493798]  [<c10be41b>] ? tracepoint_module_notify+0x12b/0x190
[  481.493804]  [<c12a6694>] __pci_register_driver+0x44/0xb0
[  481.493811]  [<f8086017>] sdhci_drv_init+0x17/0x19 [sdhci_pci]
[  481.493815]  [<c1001114>] do_one_initcall+0x34/0x170
[  481.493821]  [<f8086000>] ? 0xf8085fff
[  481.493826]  [<c1090c3e>] sys_init_module+0xee/0x1460
[  481.493830]  [<c108f620>] ? free_notes_attrs+0x50/0x50
[  481.493837]  [<f8073000>] ? 0xf8072fff
[  481.493843]  [<c14d175f>] sysenter_do_call+0x12/0x28
[  481.493847] INFO: task modprobe:136 blocked for more than 120 seconds.
[  481.493849] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  481.493850] modprobe        D f54feb40     0   136    101 0x00000000
[  481.493854]  f48afdf8 00000086 f494f740 f54feb40 f48afde8 f48afdb0 f4f3f110 c17b0380
[  481.493860]  c17b0380 c17b0380 1ed81e72 00000000 c17b0380 f59c8380 f4f3f110 f48a4b60
[  481.493866]  f494f740 f48afde8 f48afdd8 f48afdd8 c11843da 41edfde8 f48afdd0 c14c8bd9
[  481.493872] Call Trace:
[  481.493878]  [<c11843da>] ? sysfs_addrm_finish+0x1a/0xa0
[  481.493881]  [<c14c8bd9>] ? mutex_lock+0x19/0x40
[  481.493885]  [<c1184d1c>] ? create_dir+0x6c/0xa0
[  481.493889]  [<c14ca103>] schedule+0x23/0x60
[  481.493892]  [<c14ca39d>] schedule_preempt_disabled+0xd/0x10
[  481.493896]  [<c14c8cc6>] __mutex_lock_slowpath+0xc6/0x120
[  481.493900]  [<c14c8be5>] mutex_lock+0x25/0x40
[  481.493904]  [<c1337e0e>] __driver_attach+0x4e/0x90
[  481.493908]  [<c1336613>] bus_for_each_dev+0x53/0x80
[  481.493912]  [<c1337abe>] driver_attach+0x1e/0x20
[  481.493915]  [<c1337dc0>] ? driver_probe_device+0x1f0/0x1f0
[  481.493918]  [<c1337512>] bus_add_driver+0xb2/0x230
[  481.493922]  [<c12a62d0>] ? pci_dev_put+0x20/0x20
[  481.493926]  [<c12a62d0>] ? pci_dev_put+0x20/0x20
[  481.493930]  [<c133841a>] driver_register+0x6a/0x140
[  481.493934]  [<c10be41b>] ? tracepoint_module_notify+0x12b/0x190
[  481.493939]  [<c12a6694>] __pci_register_driver+0x44/0xb0
[  481.493946]  [<f817d017>] fw_ohci_pci_driver_init+0x17/0x19 [firewire_ohci]
[  481.493949]  [<c1001114>] do_one_initcall+0x34/0x170
[  481.493954]  [<f817d000>] ? 0xf817cfff
[  481.493959]  [<c1090c3e>] sys_init_module+0xee/0x1460
[  481.493963]  [<c108f620>] ? free_notes_attrs+0x50/0x50
[  481.493972]  [<c14d175f>] sysenter_do_call+0x12/0x28
[  601.286268] INFO: task modprobe:134 blocked for more than 120 seconds.
[  601.286273] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  601.286275] modprobe        D f48abbcc     0   134     98 0x00000000
[  601.286281]  f48abc3c 00000082 f59d0ebc f48abbcc c1289228 00000000 f4f3e480 c17b0380
[  601.286287]  c17b0380 c17b0380 1de51926 00000000 c17b0380 f59d5380 f4f3e480 f4853ed0
[  601.286293]  00000000 00000001 f48abc28 00000000 f59d0eb0 f4df3131 c17abe80 00000003
[  601.286300] Call Trace:
[  601.286311]  [<c1289228>] ? timerqueue_add+0x58/0xb0
[  601.286319]  [<c14ca103>] schedule+0x23/0x60
[  601.286323]  [<c14c8f5f>] schedule_hrtimeout_range_clock+0xaf/0x130
[  601.286329]  [<c105b4f0>] ? update_rmtp+0x80/0x80
[  601.286333]  [<c105c796>] ? hrtimer_start_range_ns+0x26/0x30
[  601.286336]  [<c14c8ff7>] schedule_hrtimeout_range+0x17/0x20
[  601.286343]  [<c10462c9>] usleep_range+0x39/0x40
[  601.286356]  [<f8030b39>] sdhci_do_start_signal_voltage_switch+0x59/0x150 [sdhci]
[  601.286362]  [<f8030c71>] sdhci_start_signal_voltage_switch+0x41/0x80 [sdhci]
[  601.286373]  [<f805ded8>] mmc_set_signal_voltage+0x58/0xb0 [mmc_core]
[  601.286383]  [<f805e105>] mmc_power_up+0x85/0xf0 [mmc_core]
[  601.286392]  [<f805e1a8>] mmc_start_host+0x38/0x50 [mmc_core]
[  601.286402]  [<f805f4b0>] mmc_add_host+0x50/0x90 [mmc_core]
[  601.286408]  [<f8031b37>] sdhci_add_host+0x837/0xbc0 [sdhci]
[  601.286415]  [<f807f10a>] sdhci_pci_probe+0x3fc/0x5f0 [sdhci_pci]
[  601.286421]  [<c14cac5f>] ? _raw_spin_lock_irqsave+0x2f/0x50
[  601.286427]  [<c12a5407>] local_pci_probe+0x47/0xb0
[  601.286432]  [<c12a6458>] pci_device_probe+0x68/0x90
[  601.286439]  [<c1337c48>] driver_probe_device+0x78/0x1f0
[  601.286443]  [<c12a5393>] ? pci_match_device+0xb3/0xc0
[  601.286448]  [<c1337e41>] __driver_attach+0x81/0x90
[  601.286452]  [<c1336613>] bus_for_each_dev+0x53/0x80
[  601.286456]  [<c1337abe>] driver_attach+0x1e/0x20
[  601.286460]  [<c1337dc0>] ? driver_probe_device+0x1f0/0x1f0
[  601.286463]  [<c1337512>] bus_add_driver+0xb2/0x230
[  601.286467]  [<c12a62d0>] ? pci_dev_put+0x20/0x20
[  601.286471]  [<c12a62d0>] ? pci_dev_put+0x20/0x20
[  601.286475]  [<c133841a>] driver_register+0x6a/0x140
[  601.286481]  [<c10be41b>] ? tracepoint_module_notify+0x12b/0x190
[  601.286486]  [<c12a6694>] __pci_register_driver+0x44/0xb0
[  601.286494]  [<f8086017>] sdhci_drv_init+0x17/0x19 [sdhci_pci]
[  601.286499]  [<c1001114>] do_one_initcall+0x34/0x170
[  601.286504]  [<f8086000>] ? 0xf8085fff
[  601.286511]  [<c1090c3e>] sys_init_module+0xee/0x1460
[  601.286515]  [<c108f620>] ? free_notes_attrs+0x50/0x50
[  601.286522]  [<f8073000>] ? 0xf8072fff
[  601.286529]  [<c14d175f>] sysenter_do_call+0x12/0x28
[  601.286532] INFO: task modprobe:136 blocked for more than 120 seconds.
[  601.286534] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  601.286536] modprobe        D f54feb40     0   136    101 0x00000000
[  601.286540]  f48afdf8 00000086 f494f740 f54feb40 f48afde8 f48afdb0 f4f3f110 c17b0380
[  601.286546]  c17b0380 c17b0380 1ed81e72 00000000 c17b0380 f59c8380 f4f3f110 f48a4b60
[  601.286552]  f494f740 f48afde8 f48afdd8 f48afdd8 c11843da 41edfde8 f48afdd0 c14c8bd9
[  601.286558] Call Trace:
[  601.286564]  [<c11843da>] ? sysfs_addrm_finish+0x1a/0xa0
[  601.286568]  [<c14c8bd9>] ? mutex_lock+0x19/0x40
[  601.286571]  [<c1184d1c>] ? create_dir+0x6c/0xa0
[  601.286575]  [<c14ca103>] schedule+0x23/0x60
[  601.286579]  [<c14ca39d>] schedule_preempt_disabled+0xd/0x10
[  601.286582]  [<c14c8cc6>] __mutex_lock_slowpath+0xc6/0x120
[  601.286586]  [<c14c8be5>] mutex_lock+0x25/0x40
[  601.286590]  [<c1337e0e>] __driver_attach+0x4e/0x90
[  601.286594]  [<c1336613>] bus_for_each_dev+0x53/0x80
[  601.286598]  [<c1337abe>] driver_attach+0x1e/0x20
[  601.286601]  [<c1337dc0>] ? driver_probe_device+0x1f0/0x1f0
[  601.286604]  [<c1337512>] bus_add_driver+0xb2/0x230
[  601.286609]  [<c12a62d0>] ? pci_dev_put+0x20/0x20
[  601.286612]  [<c12a62d0>] ? pci_dev_put+0x20/0x20
[  601.286616]  [<c133841a>] driver_register+0x6a/0x140
[  601.286620]  [<c10be41b>] ? tracepoint_module_notify+0x12b/0x190
[  601.286625]  [<c12a6694>] __pci_register_driver+0x44/0xb0
[  601.286632]  [<f817d017>] fw_ohci_pci_driver_init+0x17/0x19 [firewire_ohci]
[  601.286636]  [<c1001114>] do_one_initcall+0x34/0x170
[  601.286641]  [<f817d000>] ? 0xf817cfff
[  601.286646]  [<c1090c3e>] sys_init_module+0xee/0x1460
[  601.286649]  [<c108f620>] ? free_notes_attrs+0x50/0x50
[  601.286659]  [<c14d175f>] sysenter_do_call+0x12/0x28
[  624.066743] dell_wmi: Received unknown WMI event (0x11)

--------------040805040602060308030202
Content-Type: text/plain;
 charset=utf-8;
 name=lspci.txt
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename=lspci.txt

$ sudo lspci -vvs 04:00.1
04:00.1 SD Host controller: Ricoh Co Ltd Device e822 (rev 03) (prog-if 01)
	Subsystem: Dell Device 040a
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin B routed to IRQ 19
	Region 0: Memory at e5930000 (32-bit, non-prefetchable) [size=256]
	Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [78] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=2 PME-
	Capabilities: [80] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
			ExtTag- AttnBtn+ AttnInd+ PwrInd+ RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <4us, L1 <64us
			ClockPM+ Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Kernel driver in use: sdhci-pci
	Kernel modules: sdhci-pci


--------------040805040602060308030202--


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934050Ab2JLNIb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 09:08:31 -0400
Received: from mx2.compro.net ([12.186.155.4]:41599 "EHLO mx2.compro.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933185Ab2JLNI0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 09:08:26 -0400
X-Greylist: delayed 864 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Oct 2012 09:08:25 EDT
X-IronPort-AV: E=Sophos;i="4.80,577,1344225600"; 
   d="scan'208";a="8771282"
Message-ID: <507812E8.3060607@compro.net>
Date: Fri, 12 Oct 2012 08:54:00 -0400
From: Mark Hounschell <markh@compro.net>
Reply-To: markh@compro.net
Organization: Compro Computer Svcs.
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Mark Hounschell <dmarkh@cfl.rr.com>
Subject: Intel graphics drm issue?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not sure this is the correct place to ask about a possible drm issue. I 
have an intel based PC with an HDMI port that I'm trying to connect to 
an LG TV. I have successfully used this HDMI port connected to an Optima 
projector. Using that projector, everything from the BIOS post, BIOS 
configuration, and all the way up to a graphical login worked just fine. 
The same HDMI port and cable connected to this TV gives me the below 
messages during boot. I also get no BIOS post or BIOS configuration 
output while in the BIOS. I have a monitor connected to the DVI port so 
I can see what I should see on the TV there, just as when I was 
connected to the Optima projector. That alone makes me pretty sure it's 
not a kernel issue but here are the messages anyway. Maybe they will 
give someone a hint as to what the problem may be, in the case they 
might be willing to give me any pointers.

TV - LG 42lb9df
PC - intel DH77DF motherboard

geexbox:/home/mplayer # dmesg
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.4.10-lcrs (root@geexbox) (gcc version 
4.7.1 20120723 [gcc-4_7-branch revision 189773] (SUSE Linux) ) #1 SMP 
PREEMPT Wed Oct 10 16:16:16 EDT 2012
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   NSC Geode by NSC
[    0.000000]   Cyrix CyrixInstead
[    0.000000]   Centaur CentaurHauls
[    0.000000]   Transmeta GenuineTMx86
[    0.000000]   Transmeta TransmetaCPU
[    0.000000]   UMC UMC UMC UMC
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009d800 (usable)
[    0.000000]  BIOS-e820: 000000000009d800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 0000000020000000 (usable)
[    0.000000]  BIOS-e820: 0000000020000000 - 0000000020200000 (reserved)
[    0.000000]  BIOS-e820: 0000000020200000 - 0000000040004000 (usable)
[    0.000000]  BIOS-e820: 0000000040004000 - 0000000040005000 (reserved)
[    0.000000]  BIOS-e820: 0000000040005000 - 00000000d9e5f000 (usable)
[    0.000000]  BIOS-e820: 00000000d9e5f000 - 00000000da25b000 (reserved)
[    0.000000]  BIOS-e820: 00000000da25b000 - 00000000da267000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000da267000 - 00000000da2f3000 (reserved)
[    0.000000]  BIOS-e820: 00000000da2f3000 - 00000000da2f9000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000da2f9000 - 00000000da37b000 (usable)
[    0.000000]  BIOS-e820: 00000000da37b000 - 00000000da40d000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000da40d000 - 00000000da6a3000 (reserved)
[    0.000000]  BIOS-e820: 00000000da6a3000 - 00000000da6a4000 (usable)
[    0.000000]  BIOS-e820: 00000000da6a4000 - 00000000da6e7000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000da6e7000 - 00000000db000000 (usable)
[    0.000000]  BIOS-e820: 00000000db800000 - 00000000dfa00000 (reserved)
[    0.000000]  BIOS-e820: 00000000f8000000 - 00000000fc000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed04000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000021f600000 (usable)
[    0.000000] Notice: NX (Execute Disable) protection missing in CPU!
[    0.000000] DMI 2.7 present.
[    0.000000] DMI:                  /DH77DF, BIOS 
KCH7710H.86A.0095.2012.0608.1754 06/08/2012
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 
(usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 
(usable)
[    0.000000] last_pfn = 0xdb000 max_arch_pfn = 0x100000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-E7FFF uncachable
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask E00000000 write-back
[    0.000000]   1 base 200000000 mask FE0000000 write-back
[    0.000000]   2 base 0E0000000 mask FE0000000 uncachable
[    0.000000]   3 base 0DC000000 mask FFC000000 uncachable
[    0.000000]   4 base 0DB800000 mask FFF800000 uncachable
[    0.000000]   5 base 21F800000 mask FFF800000 uncachable
[    0.000000]   6 base 21F600000 mask FFFE00000 uncachable
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 
0x7010600070106
[    0.000000] e820 update range: 00000000db800000 - 0000000100000000 
(usable) ==> (reserved)
[    0.000000] found SMP MP-table at [c00fd770] fd770
[    0.000000] initial memory mapped : 0 - 00c00000
[    0.000000] Base memory trampoline at [c0099000] 99000 size 16384
[    0.000000] init_memory_mapping: 0000000000000000-00000000377fe000
[    0.000000]  0000000000 - 0000400000 page 4k
[    0.000000]  0000400000 - 0037400000 page 2M
[    0.000000]  0037400000 - 00377fe000 page 4k
[    0.000000] kernel direct mapping tables up to 377fe000 @ bfb000-c00000
[    0.000000] RAMDISK: 1e795000 - 1fff0000
[    0.000000] ACPI: RSDP 000f0490 00024 (v02  INTEL)
[    0.000000] ACPI: XSDT da25b070 00064 (v01 INTEL  DH77DF 0000005F 
AMI  00010013)
[    0.000000] ACPI: FACP da264db8 000F4 (v04 INTEL  DH77DF 0000005F 
AMI  00010013)
[    0.000000] ACPI: DSDT da25b168 09C49 (v02 INTEL  DH77DF 0000005F 
INTL 20051117)
[    0.000000] ACPI: FACS da40bf80 00040
[    0.000000] ACPI: APIC da264eb0 00072 (v03 INTEL  DH77DF 0000005F 
AMI  00010013)
[    0.000000] ACPI: FPDT da264f28 00044 (v01 INTEL  DH77DF 0000005F 
AMI  00010013)
[    0.000000] ACPI: MCFG da264f70 0003C (v01 INTEL  DH77DF 0000005F 
MSFT 00000097)
[    0.000000] ACPI: HPET da264fb0 00038 (v01 INTEL  DH77DF 0000005F 
AMI. 00000005)
[    0.000000] ACPI: SSDT da264fe8 0036D (v01 INTEL  DH77DF 0000005F 
INTL 20091112)
[    0.000000] ACPI: SSDT da265358 009AA (v01 INTEL  DH77DF 0000005F 
INTL 20051117)
[    0.000000] ACPI: SSDT da265d08 00A92 (v01 INTEL  DH77DF 0000005F 
INTL 20051117)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 2616MB HIGHMEM available.
[    0.000000] 887MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 377fe000
[    0.000000]   low ram: 0 - 377fe000
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000377fe
[    0.000000]   HighMem  0x000377fe -> 0x000db000
[    0.000000] Movable zone start PFN for each node
[    0.000000] Early memory PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009d
[    0.000000]     0: 0x00000100 -> 0x00020000
[    0.000000]     0: 0x00020200 -> 0x00040004
[    0.000000]     0: 0x00040005 -> 0x000d9e5f
[    0.000000]     0: 0x000da2f9 -> 0x000da37b
[    0.000000]     0: 0x000da6a3 -> 0x000da6a4
[    0.000000]     0: 0x000da6e7 -> 0x000db000
[    0.000000] On node 0 totalpages: 894343
[    0.000000] free_area_init_node: node 0, pgdat c0874a00, node_mem_map 
f5c9d200
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3949 pages, LIFO batch:0
[    0.000000]   Normal zone: 1744 pages used for memmap
[    0.000000]   Normal zone: 220974 pages, LIFO batch:31
[    0.000000]   HighMem zone: 5233 pages used for memmap
[    0.000000]   HighMem zone: 662411 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 
0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009d000 - 
000000000009e000
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 
00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 
00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 
0000000000100000
[    0.000000] PM: Registered nosave memory: 0000000020000000 - 
0000000020200000
[    0.000000] Allocating PCI resources starting at dfa00000 (gap: 
dfa00000:18600000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:4 
nr_node_ids:1
[    0.000000] PERCPU: Embedded 12 pages/cpu @f5c5b000 s26240 r0 d22912 
u49152
[    0.000000] pcpu-alloc: s26240 r0 d22912 u49152 alloc=12*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  
Total pages: 887334
[    0.000000] Kernel command line: 
root=/dev/disk/by-id/ata-INTEL_SSDSC2CW060A3_CVCV205106EB060AGN-part4 
video=1024x768 noresume splash=silent quiet apm=off vga=0x37e
[    0.000000] bootsplash: silent mode.
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 
bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 
bytes)
[    0.000000] Initializing CPU#0
[    0.000000] xsave/xrstor: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Initializing HighMem for node 0 (000377fe:000db000)
[    0.000000] Memory: 3515616k/3588096k available (4519k kernel code, 
61756k reserved, 2150k data, 448k init, 2670576k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff16000 - 0xfffff000   ( 932 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
[    0.000000]       .init : 0xc0884000 - 0xc08f4000   ( 448 kB)
[    0.000000]       .data : 0xc0669ce0 - 0xc08836c0   (2150 kB)
[    0.000000]       .text : 0xc0200000 - 0xc0669ce0   (4519 kB)
[    0.000000] Checking if this processor honours the WP bit even in 
supervisor mode...Ok.
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, 
CPUs=4, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000]  Dump stacks of tasks blocking RCU-preempt GP.
[    0.000000] NR_IRQS:2304 nr_irqs:712 16
[    0.000000] CPU 0 irqstacks, hard=f5408000 soft=f540a000
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.003333] Detected 3392.173 MHz processor.
[    0.000000] Calibrating delay loop (skipped), value calculated using 
timer frequency.. 6787.02 BogoMIPS (lpj=11307243)
[    0.000003] pid_max: default: 32768 minimum: 301
[    0.000016] Security Framework initialized
[    0.000024] AppArmor: AppArmor initialized
[    0.000030] Mount-cache hash table entries: 512
[    0.000131] Initializing cgroup subsys net_cls
[    0.000133] Initializing cgroup subsys blkio
[    0.000151] CPU: Physical Processor ID: 0
[    0.000152] CPU: Processor Core ID: 0
[    0.000155] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.000155] ENERGY_PERF_BIAS: View and update with 
x86_energy_perf_policy(8)
[    0.000682] mce: CPU supports 9 MCE banks
[    0.000692] CPU0: Thermal monitoring enabled (TM1)
[    0.000696] using mwait in idle threads.
[    0.001238] ACPI: Core revision 20120320
[    0.007281] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.007705] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.040612] CPU0: Intel(R) Core(TM) i5-3570K CPU @ 3.40GHz stepping 09
[    0.146597] Performance Events: PEBS fmt1+, generic architected 
perfmon, Intel PMU driver.
[    0.146602] ... version:                3
[    0.146603] ... bit width:              48
[    0.146603] ... generic registers:      8
[    0.146604] ... value mask:             0000ffffffffffff
[    0.146605] ... max period:             000000007fffffff
[    0.146606] ... fixed-purpose events:   3
[    0.146606] ... event mask:             00000007000000ff
[    0.193143] CPU 1 irqstacks, hard=f5498000 soft=f549a000
[    0.193145] Booting Node   0, Processors  #1
[    0.203381] Initializing CPU#1
[    0.219738] CPU 2 irqstacks, hard=f54a6000 soft=f54a8000
[    0.219740]  #2
[    0.230006] Initializing CPU#2
[    0.246327] CPU 3 irqstacks, hard=f54bc000 soft=f54be000
[    0.246329]  #3 Ok.
[    0.256595] Initializing CPU#3
[    0.260019] Brought up 4 CPUs
[    0.260021] Total of 4 processors activated (27148.10 BogoMIPS).
[    0.262481] devtmpfs: initialized
[    0.262625] PM: Registering ACPI NVS region [mem 
0xda37b000-0xda40cfff] (598016 bytes)
[    0.262631] PM: Registering ACPI NVS region [mem 
0xda6a4000-0xda6e6fff] (274432 bytes)
[    0.262680] dummy:
[    0.262709] RTC time:  7:31:38, date: 10/12/12
[    0.262729] NET: Registered protocol family 16
[    0.299616] ACPI: bus type pci registered
[    0.299655] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 
0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.299658] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.299659] PCI: Using MMCONFIG for extended config space
[    0.299660] PCI: Using configuration type 1 for base access
[    0.300118] bio: create slab <bio-0> at 0
[    0.300153] ACPI: Added _OSI(Module Device)
[    0.300155] ACPI: Added _OSI(Processor Device)
[    0.300156] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.300157] ACPI: Added _OSI(Processor Aggregator Device)
[    0.301481] ACPI: EC: Look up EC in DSDT
[    0.302997] ACPI: Executed 1 blocks of module-level executable AML code
[    0.316439] ACPI: SSDT da293018 0083B (v01  PmRef  Cpu0Cst 00003001 
INTL 20051117)
[    0.316774] ACPI: Dynamic OEM Table Load:
[    0.316776] ACPI: SSDT   (null) 0083B (v01  PmRef  Cpu0Cst 00003001 
INTL 20051117)
[    0.326301] ACPI: SSDT da294a98 00303 (v01  PmRef    ApIst 00003000 
INTL 20051117)
[    0.326665] ACPI: Dynamic OEM Table Load:
[    0.326667] ACPI: SSDT   (null) 00303 (v01  PmRef    ApIst 00003000 
INTL 20051117)
[    0.336468] ACPI: SSDT da299c18 00119 (v01  PmRef    ApCst 00003000 
INTL 20051117)
[    0.336804] ACPI: Dynamic OEM Table Load:
[    0.336805] ACPI: SSDT   (null) 00119 (v01  PmRef    ApCst 00003000 
INTL 20051117)
[    0.346969] ACPI: Interpreter enabled
[    0.346975] ACPI: (supports S0 S3 S4 S5)
[    0.346988] ACPI: Using IOAPIC for interrupt routing
[    0.350953] ACPI: Power Resource [FN00] (off)
[    0.351002] ACPI: Power Resource [FN01] (off)
[    0.351051] ACPI: Power Resource [FN02] (off)
[    0.351099] ACPI: Power Resource [FN03] (off)
[    0.351147] ACPI: Power Resource [FN04] (off)
[    0.351501] ACPI: No dock devices found.
[    0.351505] PCI: Using host bridge windows from ACPI; if necessary, 
use "pci=nocrs" and report a bug
[    0.351737] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
[    0.352052] pci_root PNP0A08:00: host bridge window [io 0x0000-0x0cf7]
[    0.352053] pci_root PNP0A08:00: host bridge window [io 0x0d00-0xffff]
[    0.352055] pci_root PNP0A08:00: host bridge window [mem 
0x000a0000-0x000bffff]
[    0.352056] pci_root PNP0A08:00: host bridge window [mem 
0x000d0000-0x000d3fff]
[    0.352057] pci_root PNP0A08:00: host bridge window [mem 
0x000d4000-0x000d7fff]
[    0.352059] pci_root PNP0A08:00: host bridge window [mem 
0x000d8000-0x000dbfff]
[    0.352060] pci_root PNP0A08:00: host bridge window [mem 
0x000dc000-0x000dffff]
[    0.352061] pci_root PNP0A08:00: host bridge window [mem 
0x000e0000-0x000e3fff]
[    0.352062] pci_root PNP0A08:00: host bridge window [mem 
0x000e4000-0x000e7fff]
[    0.352064] pci_root PNP0A08:00: host bridge window [mem 
0xdfa00000-0xfeafffff]
[    0.352081] PCI host bridge to bus 0000:00
[    0.352082] pci_bus 0000:00: root bus resource [io 0x0000-0x0cf7]
[    0.352083] pci_bus 0000:00: root bus resource [io 0x0d00-0xffff]
[    0.352084] pci_bus 0000:00: root bus resource [mem 
0x000a0000-0x000bffff]
[    0.352086] pci_bus 0000:00: root bus resource [mem 
0x000d0000-0x000d3fff]
[    0.352087] pci_bus 0000:00: root bus resource [mem 
0x000d4000-0x000d7fff]
[    0.352088] pci_bus 0000:00: root bus resource [mem 
0x000d8000-0x000dbfff]
[    0.352089] pci_bus 0000:00: root bus resource [mem 
0x000dc000-0x000dffff]
[    0.352090] pci_bus 0000:00: root bus resource [mem 
0x000e0000-0x000e3fff]
[    0.352092] pci_bus 0000:00: root bus resource [mem 
0x000e4000-0x000e7fff]
[    0.352093] pci_bus 0000:00: root bus resource [mem 
0xdfa00000-0xfeafffff]
[    0.352099] pci 0000:00:00.0: [8086:0150] type 00 class 0x060000
[    0.352128] pci 0000:00:01.0: [8086:0151] type 01 class 0x060400
[    0.352151] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.352169] pci 0000:00:02.0: [8086:0162] type 00 class 0x030000
[    0.352176] pci 0000:00:02.0: reg 10: [mem 0xf7800000-0xf7bfffff 64bit]
[    0.352181] pci 0000:00:02.0: reg 18: [mem 0xe0000000-0xefffffff 
64bit pref]
[    0.352184] pci 0000:00:02.0: reg 20: [io  0xf000-0xf03f]
[    0.352225] pci 0000:00:14.0: [8086:1e31] type 00 class 0x0c0330
[    0.352245] pci 0000:00:14.0: reg 10: [mem 0xf7d20000-0xf7d2ffff 64bit]
[    0.352310] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    0.352330] pci 0000:00:16.0: [8086:1e3a] type 00 class 0x078000
[    0.352351] pci 0000:00:16.0: reg 10: [mem 0xf7d37000-0xf7d3700f 64bit]
[    0.352421] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.352447] pci 0000:00:19.0: [8086:1503] type 00 class 0x020000
[    0.352464] pci 0000:00:19.0: reg 10: [mem 0xf7d00000-0xf7d1ffff]
[    0.352472] pci 0000:00:19.0: reg 14: [mem 0xf7d35000-0xf7d35fff]
[    0.352479] pci 0000:00:19.0: reg 18: [io  0xf080-0xf09f]
[    0.352537] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.352559] pci 0000:00:1a.0: [8086:1e2d] type 00 class 0x0c0320
[    0.352578] pci 0000:00:1a.0: reg 10: [mem 0xf7d34000-0xf7d343ff]
[    0.352660] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.352688] pci 0000:00:1c.0: [8086:1e10] type 01 class 0x060400
[    0.352817] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.352852] pci 0000:00:1c.7: [8086:1e1e] type 01 class 0x060400
[    0.352924] pci 0000:00:1c.7: PME# supported from D0 D3hot D3cold
[    0.352949] pci 0000:00:1d.0: [8086:1e26] type 00 class 0x0c0320
[    0.352968] pci 0000:00:1d.0: reg 10: [mem 0xf7d33000-0xf7d333ff]
[    0.353052] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.353076] pci 0000:00:1f.0: [8086:1e4a] type 00 class 0x060100
[    0.353190] pci 0000:00:1f.2: [8086:1e02] type 00 class 0x010601
[    0.353206] pci 0000:00:1f.2: reg 10: [io  0xf0d0-0xf0d7]
[    0.353213] pci 0000:00:1f.2: reg 14: [io  0xf0c0-0xf0c3]
[    0.353220] pci 0000:00:1f.2: reg 18: [io  0xf0b0-0xf0b7]
[    0.353227] pci 0000:00:1f.2: reg 1c: [io  0xf0a0-0xf0a3]
[    0.353235] pci 0000:00:1f.2: reg 20: [io  0xf060-0xf07f]
[    0.353242] pci 0000:00:1f.2: reg 24: [mem 0xf7d32000-0xf7d327ff]
[    0.353282] pci 0000:00:1f.2: PME# supported from D3hot
[    0.353298] pci 0000:00:1f.3: [8086:1e22] type 00 class 0x0c0500
[    0.353311] pci 0000:00:1f.3: reg 10: [mem 0xf7d31000-0xf7d310ff 64bit]
[    0.353330] pci 0000:00:1f.3: reg 20: [io  0xf040-0xf05f]
[    0.353384] pci 0000:01:00.0: [10b5:8112] type 01 class 0x060400
[    0.353490] pci 0000:01:00.0: disabling ASPM on pre-1.1 PCIe device.  
You can enable it with 'pcie_aspm=force'
[    0.353497] pci 0000:00:01.0: PCI bridge to [bus 01-02]
[    0.353499] pci 0000:00:01.0:   bridge window [io 0xe000-0xefff]
[    0.353564] pci 0000:02:04.0: [13f6:8788] type 00 class 0x040100
[    0.353587] pci 0000:02:04.0: reg 10: [io  0xe000-0xe0ff]
[    0.353698] pci 0000:02:04.0: supports D1 D2
[    0.353749] pci 0000:01:00.0: PCI bridge to [bus 02-02]
[    0.353753] pci 0000:01:00.0:   bridge window [io 0xe000-0xefff]
[    0.353835] pci 0000:00:1c.0: PCI bridge to [bus 03-03]
[    0.353888] pci 0000:00:1c.7: PCI bridge to [bus 04-04]
[    0.353891] pci 0000:00:1c.7:   bridge window [io 0xd000-0xdfff]
[    0.353895] pci 0000:00:1c.7:   bridge window [mem 0xf7c00000-0xf7cfffff]
[    0.353913] pci_bus 0000:00: on NUMA node 0
[    0.353915] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.354002] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.354030] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP08._PRT]
[    0.354052] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEG0._PRT]
[    0.354144]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.354282]  pci0000:00: ACPI _OSC control (0x18) granted
[    0.357166] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 
14 15)
[    0.357206] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 10 11 12 14 
15) *0, disabled.
[    0.357244] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 *4 5 6 10 11 12 
14 15)
[    0.357281] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 *10 11 12 
14 15)
[    0.357316] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 10 11 12 
14 15)
[    0.357353] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12 14 
15) *0, disabled.
[    0.357391] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 10 11 12 14 
15) *0, disabled.
[    0.357425] ACPI: PCI Interrupt Link [LNKH] (IRQs *3 4 5 6 10 11 12 
14 15)
[    0.357465] vgaarb: device added: 
PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.357468] vgaarb: loaded
[    0.357469] vgaarb: bridge control possible 0000:00:02.0
[    0.357526] SCSI subsystem initialized
[    0.357544] libata version 3.00 loaded.
[    0.357561] usbcore: registered new interface driver usbfs
[    0.357567] usbcore: registered new interface driver hub
[    0.357578] usbcore: registered new device driver usb
[    0.357604] PCI: Using ACPI for IRQ routing
[    0.358972] PCI: pci_cache_line_size set to 64 bytes
[    0.359021] reserve RAM buffer: 000000000009d800 - 000000000009ffff
[    0.359023] reserve RAM buffer: 0000000040004000 - 0000000043ffffff
[    0.359024] reserve RAM buffer: 00000000d9e5f000 - 00000000dbffffff
[    0.359026] reserve RAM buffer: 00000000da37b000 - 00000000dbffffff
[    0.359028] reserve RAM buffer: 00000000da6a4000 - 00000000dbffffff
[    0.359029] reserve RAM buffer: 00000000db000000 - 00000000dbffffff
[    0.359077] NetLabel: Initializing
[    0.359078] NetLabel:  domain hash size = 128
[    0.359079] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.359085] NetLabel:  unlabeled traffic allowed by default
[    0.359126] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.359130] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.361137] Switching to clocksource hpet
[    0.361168] AppArmor: AppArmor Filesystem Enabled
[    0.361175] pnp: PnP ACPI init
[    0.361180] ACPI: bus type pnp registered
[    0.361362] pnp 00:00: [bus 00-3e]
[    0.361364] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.361365] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.361366] pnp 00:00: [io  0x0d00-0xffff window]
[    0.361367] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.361368] pnp 00:00: [mem 0x000c0000-0x000c3fff window]
[    0.361370] pnp 00:00: [mem 0x000c4000-0x000c7fff window]
[    0.361371] pnp 00:00: [mem 0x000c8000-0x000cbfff window]
[    0.361372] pnp 00:00: [mem 0x000cc000-0x000cffff window]
[    0.361373] pnp 00:00: [mem 0x000d0000-0x000d3fff window]
[    0.361374] pnp 00:00: [mem 0x000d4000-0x000d7fff window]
[    0.361375] pnp 00:00: [mem 0x000d8000-0x000dbfff window]
[    0.361376] pnp 00:00: [mem 0x000dc000-0x000dffff window]
[    0.361377] pnp 00:00: [mem 0x000e0000-0x000e3fff window]
[    0.361378] pnp 00:00: [mem 0x000e4000-0x000e7fff window]
[    0.361379] pnp 00:00: [mem 0x000e8000-0x000ebfff window]
[    0.361381] pnp 00:00: [mem 0x000ec000-0x000effff window]
[    0.361382] pnp 00:00: [mem 0x000f0000-0x000fffff window]
[    0.361383] pnp 00:00: [mem 0xdfa00000-0xfeafffff window]
[    0.361384] pnp 00:00: [mem 0x00010000-0x0001ffff window]
[    0.361416] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 
(active)
[    0.361432] pnp 00:01: [mem 0xfed40000-0xfed44fff]
[    0.361448] system 00:01: [mem 0xfed40000-0xfed44fff] has been reserved
[    0.361450] system 00:01: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.361459] pnp 00:02: [io  0x0000-0x001f]
[    0.361460] pnp 00:02: [io  0x0081-0x0091]
[    0.361461] pnp 00:02: [io  0x0093-0x009f]
[    0.361462] pnp 00:02: [io  0x00c0-0x00df]
[    0.361463] pnp 00:02: [dma 4]
[    0.361473] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.361478] pnp 00:03: [mem 0xff000000-0xffffffff]
[    0.361489] pnp 00:03: Plug and Play ACPI device, IDs INT0800 (active)
[    0.361546] pnp 00:04: [mem 0xfed00000-0xfed003ff]
[    0.361557] pnp 00:04: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.361565] pnp 00:05: [io  0x002e-0x002f]
[    0.361566] pnp 00:05: [io  0x004e-0x004f]
[    0.361567] pnp 00:05: [io  0x0061]
[    0.361568] pnp 00:05: [io  0x0063]
[    0.361569] pnp 00:05: [io  0x0065]
[    0.361570] pnp 00:05: [io  0x0067]
[    0.361571] pnp 00:05: [io  0x0070]
[    0.361571] pnp 00:05: [io  0x0080]
[    0.361572] pnp 00:05: [io  0x0092]
[    0.361573] pnp 00:05: [io  0x00b2-0x00b3]
[    0.361574] pnp 00:05: [io  0x0680-0x069f]
[    0.361575] pnp 00:05: [io  0x1000-0x100f]
[    0.361576] pnp 00:05: [io  0xffff]
[    0.361577] pnp 00:05: [io  0xffff]
[    0.361578] pnp 00:05: [io  0x0400-0x0453]
[    0.361579] pnp 00:05: [io  0x0458-0x047f]
[    0.361580] pnp 00:05: [io  0x0500-0x057f]
[    0.361581] pnp 00:05: [io  0x164e-0x164f]
[    0.361601] system 00:05: [io  0x0680-0x069f] has been reserved
[    0.361602] system 00:05: [io  0x1000-0x100f] has been reserved
[    0.361604] system 00:05: [io  0xffff] has been reserved
[    0.361605] system 00:05: [io  0xffff] has been reserved
[    0.361606] system 00:05: [io  0x0400-0x0453] has been reserved
[    0.361607] system 00:05: [io  0x0458-0x047f] has been reserved
[    0.361609] system 00:05: [io  0x0500-0x057f] has been reserved
[    0.361610] system 00:05: [io  0x164e-0x164f] has been reserved
[    0.361612] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.361617] pnp 00:06: [io  0x0070-0x0077]
[    0.361625] pnp 00:06: [irq 8]
[    0.361636] pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.361652] pnp 00:07: [io  0x0454-0x0457]
[    0.361669] system 00:07: [io  0x0454-0x0457] has been reserved
[    0.361670] system 00:07: Plug and Play ACPI device, IDs INT3f0d 
PNP0c02 (active)
[    0.361725] pnp 00:08: [io  0x0000-0xffffffff disabled]
[    0.361726] pnp 00:08: [io  0x0a30-0x0a3f]
[    0.361727] pnp 00:08: [io  0x0000-0xffffffff disabled]
[    0.361728] pnp 00:08: [io  0x0250-0x025f]
[    0.361745] system 00:08: [io  0x0a30-0x0a3f] has been reserved
[    0.361747] system 00:08: [io  0x0250-0x025f] has been reserved
[    0.361748] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.361784] pnp 00:09: [io  0x0010-0x001f]
[    0.361785] pnp 00:09: [io  0x0022-0x003f]
[    0.361786] pnp 00:09: [io  0x0044-0x005f]
[    0.361787] pnp 00:09: [io  0x0062-0x0063]
[    0.361788] pnp 00:09: [io  0x0065-0x006f]
[    0.361789] pnp 00:09: [io  0x0072-0x007f]
[    0.361790] pnp 00:09: [io  0x0080]
[    0.361791] pnp 00:09: [io  0x0084-0x0086]
[    0.361792] pnp 00:09: [io  0x0088]
[    0.361793] pnp 00:09: [io  0x008c-0x008e]
[    0.361793] pnp 00:09: [io  0x0090-0x009f]
[    0.361794] pnp 00:09: [io  0x00a2-0x00bf]
[    0.361795] pnp 00:09: [io  0x00e0-0x00ef]
[    0.361796] pnp 00:09: [io  0x04d0-0x04d1]
[    0.361815] system 00:09: [io  0x04d0-0x04d1] has been reserved
[    0.361817] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.361822] pnp 00:0a: [io  0x00f0-0x00ff]
[    0.361828] pnp 00:0a: [irq 13]
[    0.361841] pnp 00:0a: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.362020] pnp 00:0b: [mem 0xfed1c000-0xfed1ffff]
[    0.362021] pnp 00:0b: [mem 0xfed10000-0xfed17fff]
[    0.362022] pnp 00:0b: [mem 0xfed18000-0xfed18fff]
[    0.362023] pnp 00:0b: [mem 0xfed19000-0xfed19fff]
[    0.362024] pnp 00:0b: [mem 0xf8000000-0xfbffffff]
[    0.362025] pnp 00:0b: [mem 0xfed20000-0xfed3ffff]
[    0.362026] pnp 00:0b: [mem 0xfed90000-0xfed93fff]
[    0.362027] pnp 00:0b: [mem 0xfed45000-0xfed8ffff]
[    0.362028] pnp 00:0b: [mem 0xff000000-0xffffffff]
[    0.362029] pnp 00:0b: [mem 0xfee00000-0xfeefffff]
[    0.362030] pnp 00:0b: [mem 0xdfa00000-0xdfa00fff]
[    0.362061] system 00:0b: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.362063] system 00:0b: [mem 0xfed10000-0xfed17fff] has been reserved
[    0.362064] system 00:0b: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.362066] system 00:0b: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.362067] system 00:0b: [mem 0xf8000000-0xfbffffff] has been reserved
[    0.362068] system 00:0b: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.362070] system 00:0b: [mem 0xfed90000-0xfed93fff] has been reserved
[    0.362071] system 00:0b: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.362073] system 00:0b: [mem 0xff000000-0xffffffff] has been reserved
[    0.362074] system 00:0b: [mem 0xfee00000-0xfeefffff] could not be 
reserved
[    0.362075] system 00:0b: [mem 0xdfa00000-0xdfa00fff] has been reserved
[    0.362077] system 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.362189] pnp 00:0c: [mem 0x20000000-0x201fffff]
[    0.362190] pnp 00:0c: [mem 0x40004000-0x40004fff]
[    0.362221] system 00:0c: [mem 0x20000000-0x201fffff] has been reserved
[    0.362222] system 00:0c: [mem 0x40004000-0x40004fff] has been reserved
[    0.362224] system 00:0c: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.362239] pnp: PnP ACPI: found 13 devices
[    0.362240] ACPI: ACPI bus type pnp unregistered
[    0.397562] pci 0000:01:00.0: PCI bridge to [bus 02-02]
[    0.397565] pci 0000:01:00.0:   bridge window [io 0xe000-0xefff]
[    0.397580] pci 0000:00:01.0: PCI bridge to [bus 01-02]
[    0.397581] pci 0000:00:01.0:   bridge window [io 0xe000-0xefff]
[    0.397585] pci 0000:00:1c.0: PCI bridge to [bus 03-03]
[    0.397605] pci 0000:00:1c.7: PCI bridge to [bus 04-04]
[    0.397607] pci 0000:00:1c.7:   bridge window [io 0xd000-0xdfff]
[    0.397612] pci 0000:00:1c.7:   bridge window [mem 0xf7c00000-0xf7cfffff]
[    0.397641] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.397643] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.397644] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.397645] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000d3fff]
[    0.397646] pci_bus 0000:00: resource 8 [mem 0x000d4000-0x000d7fff]
[    0.397647] pci_bus 0000:00: resource 9 [mem 0x000d8000-0x000dbfff]
[    0.397649] pci_bus 0000:00: resource 10 [mem 0x000dc000-0x000dffff]
[    0.397650] pci_bus 0000:00: resource 11 [mem 0x000e0000-0x000e3fff]
[    0.397651] pci_bus 0000:00: resource 12 [mem 0x000e4000-0x000e7fff]
[    0.397652] pci_bus 0000:00: resource 13 [mem 0xdfa00000-0xfeafffff]
[    0.397653] pci_bus 0000:01: resource 0 [io  0xe000-0xefff]
[    0.397655] pci_bus 0000:02: resource 0 [io  0xe000-0xefff]
[    0.397656] pci_bus 0000:04: resource 0 [io  0xd000-0xdfff]
[    0.397657] pci_bus 0000:04: resource 1 [mem 0xf7c00000-0xf7cfffff]
[    0.397681] NET: Registered protocol family 2
[    0.397710] IP route cache hash table entries: 32768 (order: 5, 
131072 bytes)
[    0.397782] TCP established hash table entries: 131072 (order: 8, 
1048576 bytes)
[    0.397903] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.397957] TCP: Hash tables configured (established 131072 bind 65536)
[    0.397958] TCP: reno registered
[    0.397960] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    0.397963] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    0.397991] NET: Registered protocol family 1
[    0.397998] pci 0000:00:02.0: Boot video device
[    0.431001] PCI: CLS 64 bytes, default 64
[    0.431040] Unpacking initramfs...
[    0.708811] Freeing initrd memory: 24940k freed
[    0.711272] audit: initializing netlink socket (disabled)
[    0.711280] type=2000 audit(1350027098.609:1): initialized
[    0.721181] highmem bounce pool size: 64 pages
[    0.721183] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    0.722008] VFS: Disk quotas dquot_6.5.2
[    0.722032] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.722159] msgmni has been set to 1699
[    0.722284] Block layer SCSI generic (bsg) driver version 0.4 loaded 
(major 253)
[    0.722301] io scheduler noop registered
[    0.722302] io scheduler deadline registered
[    0.722305] io scheduler cfq registered (default)
[    0.722369] pcieport 0000:00:01.0: irq 40 for MSI/MSI-X
[    0.722531] vesafb: mode is 1024x768x16, linelength=2048, pages=41
[    0.722532] vesafb: scrolling: redraw
[    0.722534] vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
[    0.722782] vesafb: framebuffer at 0xe0000000, mapped to 0xf8080000, 
using 3072k, total 65472k
[    0.743774] Console: switching to colour frame buffer device 128x48
[    0.764714] fb0: VESA VGA frame buffer device
[    0.764727] intel_idle: does not run on family 6 model 58
[    0.783511] Monitor-Mwait will be used to enter C-1 state
[    0.783526] Monitor-Mwait will be used to enter C-2 state
[    0.783532] ACPI: acpi_idle registered with cpuidle
[    0.786599] Serial: 8250/16550 driver, 8 ports, IRQ sharing disabled
[    0.786978] Non-volatile memory driver v1.3
[    0.786979] Linux agpgart interface v0.103
[    0.787029] agpgart-intel 0000:00:00.0: Intel Ivybridge Chipset
[    0.787078] agpgart-intel 0000:00:00.0: detected gtt size: 2097152K 
total, 262144K mappable
[    0.787748] agpgart-intel 0000:00:00.0: detected 65536K stolen memory
[    0.787819] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xe0000000
[    0.787878] ahci 0000:00:1f.2: version 3.0
[    0.787926] ahci 0000:00:1f.2: irq 41 for MSI/MSI-X
[    0.787949] ahci: SSS flag set, parallel bus scan disabled
[    0.799952] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 
0x23 impl SATA mode
[    0.799956] ahci 0000:00:1f.2: flags: 64bit ncq stag pm led clo pio 
slum part ems sxs apst
[    0.799966] ahci 0000:00:1f.2: setting latency timer to 64
[    0.813466] scsi0 : ahci
[    0.813502] scsi1 : ahci
[    0.813532] scsi2 : ahci
[    0.813562] scsi3 : ahci
[    0.813591] scsi4 : ahci
[    0.813623] scsi5 : ahci
[    0.813828] ata1: SATA max UDMA/133 abar m2048@0xf7d32000 port 
0xf7d32100 irq 41
[    0.813831] ata2: SATA max UDMA/133 abar m2048@0xf7d32000 port 
0xf7d32180 irq 41
[    0.813832] ata3: DUMMY
[    0.813833] ata4: DUMMY
[    0.813833] ata5: DUMMY
[    0.813836] ata6: SATA max UDMA/133 abar m2048@0xf7d32000 port 
0xf7d32380 irq 41
[    0.813875] Fixed MDIO Bus: probed
[    0.813877] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.813895] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[    0.813898] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[    0.813911] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned 
bus number 1
[    0.813929] ehci_hcd 0000:00:1a.0: debug port 2
[    0.817796] ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
[    0.817807] ehci_hcd 0000:00:1a.0: irq 16, io mem 0xf7d34000
[    0.826514] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    0.826532] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    0.826534] usb usb1: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    0.826537] usb usb1: Product: EHCI Host Controller
[    0.826539] usb usb1: Manufacturer: Linux 3.4.10-lcrs ehci_hcd
[    0.826541] usb usb1: SerialNumber: 0000:00:1a.0
[    0.826610] hub 1-0:1.0: USB hub found
[    0.826614] hub 1-0:1.0: 2 ports detected
[    0.826662] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[    0.826665] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[    0.826668] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned 
bus number 2
[    0.826686] ehci_hcd 0000:00:1d.0: debug port 2
[    0.830545] ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
[    0.830556] ehci_hcd 0000:00:1d.0: irq 23, io mem 0xf7d33000
[    0.839810] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    0.839822] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    0.839825] usb usb2: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    0.839827] usb usb2: Product: EHCI Host Controller
[    0.839829] usb usb2: Manufacturer: Linux 3.4.10-lcrs ehci_hcd
[    0.839832] usb usb2: SerialNumber: 0000:00:1d.0
[    0.839890] hub 2-0:1.0: USB hub found
[    0.839891] hub 2-0:1.0: 2 ports detected
[    0.839922] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.839927] uhci_hcd: USB Universal Host Controller Interface driver
[    0.839934] Initializing USB Mass Storage driver...
[    0.839944] usbcore: registered new interface driver usb-storage
[    0.839945] USB Mass Storage support registered.
[    0.839948] usbcore: registered new interface driver ums-alauda
[    0.839951] usbcore: registered new interface driver ums-cypress
[    0.839954] usbcore: registered new interface driver ums-datafab
[    0.839957] usbcore: registered new interface driver ums-freecom
[    0.839961] usbcore: registered new interface driver ums-isd200
[    0.839964] usbcore: registered new interface driver ums-jumpshot
[    0.839967] usbcore: registered new interface driver ums-karma
[    0.839971] usbcore: registered new interface driver ums-onetouch
[    0.839974] usbcore: registered new interface driver ums-sddr09
[    0.839977] usbcore: registered new interface driver ums-sddr55
[    0.839981] usbcore: registered new interface driver ums-usbat
[    0.840005] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    0.842500] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.842514] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.842550] mousedev: PS/2 mouse device common for all mice
[    0.842613] rtc_cmos 00:06: RTC can wake from S4
[    0.842711] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
[    0.842740] rtc0: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    0.842771] cpuidle: using governor ladder
[    0.842857] usbcore: registered new interface driver usbhid
[    0.842858] usbhid: USB HID core driver
[    0.842941] ashmem: initialized
[    0.842957] using rtc device, rtc_cmos, for alarms
[    0.843034] TCP: cubic registered
[    0.843080] NET: Registered protocol family 10
[    0.843200] lib80211: common routines for IEEE802.11 drivers
[    0.843201] lib80211_crypt: registered algorithm 'NULL'
[    0.843203] Registering the dns_resolver key type
[    0.843211] libceph: loaded (mon/osd proto 15/24, osdmap 5/6 5/6)
[    0.843252] Using IPI No-Shortcut mode
[    0.843429] registered taskstats version 1
[    0.843754]   Magic number: 0:145:521
[    0.843824] rtc_cmos 00:06: setting system clock to 2012-10-12 
07:31:39 UTC (1350027099)
[    1.132324] usb 1-1: new high-speed USB device number 2 using ehci_hcd
[    1.132331] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.141544] ata1.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) 
succeeded
[    1.141549] ata1.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE 
LOCK) filtered out
[    1.141552] ata1.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE 
CONFIGURATION OVERLAY) filtered out
[    1.144312] ata1.00: ATAPI: HL-DT-ST BDDVDRW UH12LS29, 1.00, max UDMA/133
[    1.149359] ata1.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) 
succeeded
[    1.149363] ata1.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE 
LOCK) filtered out
[    1.149367] ata1.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE 
CONFIGURATION OVERLAY) filtered out
[    1.152102] ata1.00: configured for UDMA/133
[    1.170907] scsi 0:0:0:0: CD-ROM            HL-DT-ST BDDVDRW UH12LS29 
1.00 PQ: 0 ANSI: 5
[    1.255595] usb 1-1: New USB device found, idVendor=8087, idProduct=0024
[    1.255598] usb 1-1: New USB device strings: Mfr=0, Product=0, 
SerialNumber=0
[    1.255744] hub 1-1:1.0: USB hub found
[    1.255841] hub 1-1:1.0: 6 ports detected
[    1.361661] usb 2-1: new high-speed USB device number 2 using ehci_hcd
[    1.485062] usb 2-1: New USB device found, idVendor=8087, idProduct=0024
[    1.485065] usb 2-1: New USB device strings: Mfr=0, Product=0, 
SerialNumber=0
[    1.485209] hub 2-1:1.0: USB hub found
[    1.485310] hub 2-1:1.0: 8 ports detected
[    1.487973] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.489384] ata2.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) 
succeeded
[    1.489388] ata2.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE 
LOCK) filtered out
[    1.489392] ata2.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE 
CONFIGURATION OVERLAY) filtered out
[    1.499276] ata2.00: ATA-9: INTEL SSDSC2CW060A3, 400i, max UDMA/133
[    1.499279] ata2.00: 117231408 sectors, multi 16: LBA48 NCQ (depth 
31/32), AA
[    1.509240] ata2.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) 
succeeded
[    1.509243] ata2.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE 
LOCK) filtered out
[    1.509247] ata2.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE 
CONFIGURATION OVERLAY) filtered out
[    1.519689] ata2.00: configured for UDMA/133
[    1.519772] scsi 1:0:0:0: Direct-Access     ATA      INTEL SSDSC2CW06 
400i PQ: 0 ANSI: 5
[    1.519850] sd 1:0:0:0: [sda] 117231408 512-byte logical blocks: 
(60.0 GB/55.8 GiB)
[    1.519883] sd 1:0:0:0: [sda] Write Protect is off
[    1.519884] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.519896] sd 1:0:0:0: [sda] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[    1.520399]  sda: sda1 sda2 sda3 sda4
[    1.520735] sd 1:0:0:0: [sda] Attached SCSI disk
[    1.551276] usb 1-1.2: new high-speed USB device number 3 using ehci_hcd
[    1.637651] usb 1-1.2: New USB device found, idVendor=0846, 
idProduct=9011
[    1.637653] usb 1-1.2: New USB device strings: Mfr=1, Product=2, 
SerialNumber=3
[    1.637656] usb 1-1.2: Product: BCMUSB 802.11 Wireless Adapter
[    1.637658] usb 1-1.2: Manufacturer: Broadcom
[    1.637660] usb 1-1.2: SerialNumber: 26475
[    1.710666] Refined TSC clocksource calibration: 3392.302 MHz.
[    1.710670] Switching to clocksource tsc
[    1.750733] usb 2-1.6: new full-speed USB device number 3 using ehci_hcd
[    1.836972] ata6: SATA link down (SStatus 0 SControl 300)
[    1.836976] usb 2-1.6: New USB device found, idVendor=19ff, 
idProduct=0231
[    1.836980] usb 2-1.6: New USB device strings: Mfr=0, Product=2, 
SerialNumber=0
[    1.836983] usb 2-1.6: Product: Dynex wireless combo
[    1.837067] Freeing unused kernel memory: 448k freed
[    1.838361] input: Dynex wireless combo as 
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.6/2-1.6:1.0/input/input0
[    1.838401] generic-usb 0003:19FF:0231.0001: input,hidraw0: USB HID 
v1.11 Keyboard [Dynex wireless combo] on usb-0000:00:1d.0-1.6/input0
[    1.840411] input: Dynex wireless combo as 
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.6/2-1.6:1.1/input/input1
[    1.840527] generic-usb 0003:19FF:0231.0002: input,hidraw1: USB HID 
v1.11 Mouse [Dynex wireless combo] on usb-0000:00:1d.0-1.6/input1
[    1.856941] emc: device handler registered
[    1.857800] rdac: device handler registered
[    1.858707] alua: device handler registered
[    1.859537] hp_sw: device handler registered
[    1.862027] udevd[115]: starting version 182
[    1.866804] input: Power Button as 
/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input2
[    1.866905] ACPI: Power Button [PWRB]
[    1.867286] input: Power Button as 
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    1.867309] ACPI: Power Button [PWRF]
[    1.873306] xhci_hcd 0000:00:14.0: setting latency timer to 64
[    1.873309] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    1.873315] xhci_hcd 0000:00:14.0: new USB bus registered, assigned 
bus number 3
[    1.873394] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
[    1.873399] xhci_hcd 0000:00:14.0: irq 16, io mem 0xf7d20000
[    1.873440] xhci_hcd 0000:00:14.0: irq 42 for MSI/MSI-X
[    1.873480] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
[    1.873481] usb usb3: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    1.873483] usb usb3: Product: xHCI Host Controller
[    1.873484] usb usb3: Manufacturer: Linux 3.4.10-lcrs xhci_hcd
[    1.873485] usb usb3: SerialNumber: 0000:00:14.0
[    1.873611] xHCI xhci_add_endpoint called for root hub
[    1.873613] xHCI xhci_check_bandwidth called for root hub
[    1.873630] hub 3-0:1.0: USB hub found
[    1.873636] hub 3-0:1.0: 4 ports detected
[    1.873681] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    1.873685] xhci_hcd 0000:00:14.0: new USB bus registered, assigned 
bus number 4
[    1.873695] usb usb4: New USB device found, idVendor=1d6b, idProduct=0003
[    1.873696] usb usb4: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    1.873697] usb usb4: Product: xHCI Host Controller
[    1.873698] usb usb4: Manufacturer: Linux 3.4.10-lcrs xhci_hcd
[    1.873699] usb usb4: SerialNumber: 0000:00:14.0
[    1.873797] xHCI xhci_add_endpoint called for root hub
[    1.873798] xHCI xhci_check_bandwidth called for root hub
[    1.873814] hub 4-0:1.0: USB hub found
[    1.873820] hub 4-0:1.0: 4 ports detected
[    1.877290] [drm] Initialized drm 1.1.0 20060810
[    1.887009] thermal LNXTHERM:00: registered as thermal_zone0
[    1.887011] ACPI: Thermal Zone [TZ00] (28 C)
[    1.887022] i915 0000:00:02.0: setting latency timer to 64
[    1.887135] thermal LNXTHERM:01: registered as thermal_zone1
[    1.887136] ACPI: Thermal Zone [TZ01] (30 C)
[    1.887240] ACPI: Fan [FAN0] (off)
[    1.887264] ACPI: Fan [FAN1] (off)
[    1.887287] ACPI: Fan [FAN2] (off)
[    1.887307] ACPI: Fan [FAN3] (off)
[    1.887327] ACPI: Fan [FAN4] (off)
[    1.897953] mtrr: type mismatch for e0000000,10000000 old: write-back 
new: write-combining
[    1.897955] [drm] MTRR allocation failed.  Graphics performance may 
suffer.
[    1.898045] i915 0000:00:02.0: irq 43 for MSI/MSI-X
[    1.898050] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    1.898051] [drm] Driver supports precise vblank timestamp query.
[    1.898084] [drm:intel_dsm_platform_mux_info] *ERROR* MUX INFO call 
failed
[    1.898737] vgaarb: device changed decodes: 
PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    1.995523] [drm] Enabling RC6 states: RC6 on, RC6p on, RC6pp off
[    2.299535] [drm:drm_edid_block_valid] *ERROR* EDID checksum is 
invalid, remainder is 128
[    2.299865] Raw EDID:
[    2.299957]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.300188]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.300418]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.300648]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.300879]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.301109]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.301339]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.301569]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.343856] [drm:drm_edid_block_valid] *ERROR* EDID checksum is 
invalid, remainder is 128
[    2.344177] Raw EDID:
[    2.344267]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.344494]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.344720]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.344946]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.345172]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.345398]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.345625]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.345851]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.387993] [drm:drm_edid_block_valid] *ERROR* EDID checksum is 
invalid, remainder is 128
[    2.388314] Raw EDID:
[    2.388404]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.388630]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.388857]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.389083]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.389309]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.389536]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.389762]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.389988]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.432156] [drm:drm_edid_block_valid] *ERROR* EDID checksum is 
invalid, remainder is 128
[    2.432478] Raw EDID:
[    2.432568]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.432794]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.433020]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.433246]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.433472]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.433699]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.433925]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.434151]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.434378] i915 0000:00:02.0: HDMI-A-3: EDID block 0 invalid.
[    2.477539] checking generic (e0000000 3ff0000) vs hw (e0000000 10000000)
[    2.477541] fb: conflicting fb hw usage inteldrmfb vs VESA VGA - 
removing generic driver
[    2.477549] Console: switching to colour dummy device 80x25
[    2.477831] fbcon: inteldrmfb (fb0) is primary device
[    2.637915] Console: switching to colour frame buffer device 128x48
[    2.679625] fb0: inteldrmfb frame buffer device
[    2.679626] drm: registered panic notifier
[    2.691536] acpi device:4b: registered as cooling_device9
[    2.691660] input: Video Bus as 
/devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input4
[    2.691698] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  
post: no)
[    2.691709] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on 
minor 0
[    2.956404] [drm:drm_edid_block_valid] *ERROR* EDID checksum is 
invalid, remainder is 128
[    2.957037] Raw EDID:
[    2.957215]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.957659]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.958103]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.958546]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.958990]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.959434]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.959878]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.960322]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.001115] [drm:drm_edid_block_valid] *ERROR* EDID checksum is 
invalid, remainder is 128
[    3.001746] Raw EDID:
[    3.001923]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.002366]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.002809]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.003253]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.003698]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.004142]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.004586]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.005030]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.045802] [drm:drm_edid_block_valid] *ERROR* EDID checksum is 
invalid, remainder is 128
[    3.046432] Raw EDID:
[    3.046608]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.047053]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.054977]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.062515]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.069833]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.077156]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.077157]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.077158]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.117430] [drm:drm_edid_block_valid] *ERROR* EDID checksum is 
invalid, remainder is 128
[    3.125412] Raw EDID:
[    3.133406]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.141914]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.150003]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.157713]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.165189]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.172677]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.180173]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.187674]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.195176] i915 0000:00:02.0: HDMI-A-3: EDID block 0 invalid.
[    3.236898] [drm:drm_edid_block_valid] *ERROR* EDID checksum is 
invalid, remainder is 128
[    3.245089] Raw EDID:
[    3.253295]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.262015]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.270475]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.278967]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.278967]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.278968]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.278969]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.278970]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.319226] [drm:drm_edid_block_valid] *ERROR* EDID checksum is 
invalid, remainder is 128
[    3.319227] Raw EDID:
[    3.319227]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.319228]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.319229]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.319230]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.319230]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.319231]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.319232]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.319233]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.359511] [drm:drm_edid_block_valid] *ERROR* EDID checksum is 
invalid, remainder is 128
[    3.359512] Raw EDID:
[    3.359513]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.359513]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.359514]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.359515]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.359516]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.359516]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.359517]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.359518]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.399798] [drm:drm_edid_block_valid] *ERROR* EDID checksum is 
invalid, remainder is 128
[    3.399799] Raw EDID:
[    3.399800]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.399800]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.399801]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.399802]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.399803]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.399803]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.399804]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.399805]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.399806] i915 0000:00:02.0: HDMI-A-3: EDID block 0 invalid.
[    4.245397] EXT4-fs (sda4): mounted filesystem with ordered data 
mode. Opts: acl,user_xattr
[    4.258312] EXT4-fs (sda4): re-mounted. Opts: acl,user_xattr
[    4.657779] systemd-readahead-replay[266]: Bumped block_nr parameter 
of 8:0 to 16384. This is a temporary hack and should be removed one day.
[    5.137184] udevd[299]: starting version 182
[    5.205326] microcode: CPU0 sig=0x306a9, pf=0x2, revision=0x12
[    5.205787] microcode: CPU1 sig=0x306a9, pf=0x2, revision=0x12
[    5.206056] microcode: CPU2 sig=0x306a9, pf=0x2, revision=0x12
[    5.206276] microcode: CPU3 sig=0x306a9, pf=0x2, revision=0x12
[    5.206480] microcode: Microcode Update Driver: v2.00 
<tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    5.207898] Disabling lock debugging due to kernel taint
[    5.208251] ndiswrapper version 1.58rc1 loaded (smp=yes, preempt=yes)
[    5.277205] usb 1-1.2: reset high-speed USB device number 3 using 
ehci_hcd
[    5.289718] BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
[    5.301869] EXT4-fs (sda4): re-mounted. Opts: acl,user_xattr
[    5.365775] ndiswrapper: driver bcmwlhigh5 (Netgear,05/05/2009, 
5.10.79.30) loaded
[    5.620462] wlan0: ethernet device 00:8e:f2:7d:67:6b using NDIS 
driver: bcmwlhigh5, version: 0x50a4f1e, NDIS version: 0x501, vendor: 
'NDIS Network Adapter', 0846:9011.F.conf
[    5.622768] wlan0: encryption modes supported: WEP; TKIP with WPA, 
WPA2, WPA2-PSK; AES/CCMP with WPA, WPA2, WPA2-PSK
[    5.623406] usbcore: registered new interface driver ndiswrapper
[    5.742972] e1000e: Intel(R) PRO/1000 Network Driver - 1.9.5-k
[    5.742974] e1000e: Copyright(c) 1999 - 2012 Intel Corporation.
[    5.743003] e1000e 0000:00:19.0: setting latency timer to 64
[    5.743052] e1000e 0000:00:19.0: (unregistered net_device): Interrupt 
Throttling Rate (ints/sec) set to dynamic conservative mode
[    5.743079] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[    5.743827] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    5.757421] scsi 0:0:0:0: Attached scsi generic sg0 type 5
[    5.757445] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    5.758586] input: PC Speaker as /devices/platform/pcspkr/input/input5
[    5.772084] sr0: scsi3-mmc drive: 40x/40x writer dvd-ram cd/rw 
xa/form2 cdda tray
[    5.772087] cdrom: Uniform CD-ROM driver Revision: 3.20
[    5.772155] sr 0:0:0:0: Attached scsi CD-ROM sr0
[    6.049161] e1000e 0000:00:19.0: eth0: (PCI Express:2.5GT/s:Width x1) 
e8:40:f2:05:f1:85
[    6.049164] e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network 
Connection
[    6.049212] e1000e 0000:00:19.0: eth0: MAC: 10, PHY: 11, PBA No: 
FFFFFF-0FF
[    6.049274] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    6.049387] ACPI Warning: 0x0000f040-0x0000f05f SystemIO conflicts 
with Region \_SB_.PCI0.SBUS.SMBI 1 (20120320/utaddress-251)
[    6.049391] ACPI: If an ACPI driver is available for this device, you 
should use it instead of the native driver
[    6.183780] Adding 4193276k swap on /dev/sda3.  Priority:-1 extents:1 
across:4193276k SS
[    6.322683] EXT4-fs (sda2): mounted filesystem with ordered data 
mode. Opts: acl,user_xattr
[    7.599909] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[    7.632050] NET: Registered protocol family 17
[    7.666693] [drm:drm_edid_block_valid] *ERROR* EDID checksum is 
invalid, remainder is 128
[    7.666695] Raw EDID:
[    7.666696]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.666697]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.666698]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.666699]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.666700]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.666701]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.666702]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.666703]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.701257] [drm:drm_edid_block_valid] *ERROR* EDID checksum is 
invalid, remainder is 128
[    7.701258] Raw EDID:
[    7.701259]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.701260]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.701261]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.701262]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.701263]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.701264]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.701265]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.701265]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.736060] [drm:drm_edid_block_valid] *ERROR* EDID checksum is 
invalid, remainder is 128
[    7.736061] Raw EDID:
[    7.736062]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.736063]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.736064]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.736065]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.736066]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.736067]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.736067]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.736068]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.770929] [drm:drm_edid_block_valid] *ERROR* EDID checksum is 
invalid, remainder is 128
[    7.770930] Raw EDID:
[    7.770931]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.770932]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.770932]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.770933]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.770934]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.770935]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.770936]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.770937]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.770939] i915 0000:00:02.0: HDMI-A-3: EDID block 0 invalid.
[    7.806950] [drm:drm_edid_block_valid] *ERROR* EDID checksum is 
invalid, remainder is 128
[    7.806951] Raw EDID:
[    7.806951]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.806952]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.806953]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.806954]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.806955]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.806956]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.806957]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.806958]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.841320] [drm:drm_edid_block_valid] *ERROR* EDID checksum is 
invalid, remainder is 128
[    7.841321] Raw EDID:
[    7.841322]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.841323]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.841324]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.841325]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.841326]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.841326]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.841327]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.841328]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.876212] [drm:drm_edid_block_valid] *ERROR* EDID checksum is 
invalid, remainder is 128
[    7.876212] Raw EDID:
[    7.876213]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.876214]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.876215]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.876216]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.876217]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.876218]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.876219]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.876220]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.910987] [drm:drm_edid_block_valid] *ERROR* EDID checksum is 
invalid, remainder is 128
[    7.910988] Raw EDID:
[    7.910989]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.910990]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.910991]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.910992]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.910992]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.910993]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.910994]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.910995]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.910997] i915 0000:00:02.0: HDMI-A-3: EDID block 0 invalid.
[    8.152314] [drm:drm_edid_block_valid] *ERROR* EDID checksum is 
invalid, remainder is 128
[    8.152316] Raw EDID:
[    8.152317]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.152318]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.152319]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.152320]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.152321]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.152322]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.152323]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.152324]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.187129] [drm:drm_edid_block_valid] *ERROR* EDID checksum is 
invalid, remainder is 128
[    8.187131] Raw EDID:
[    8.187132]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.187133]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.187134]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.187134]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.187135]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.187136]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.187137]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.187138]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.221928] [drm:drm_edid_block_valid] *ERROR* EDID checksum is 
invalid, remainder is 128
[    8.221929] Raw EDID:
[    8.221931]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.221932]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.221932]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.221933]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.221934]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.221935]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.221936]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.221937]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.256428] [drm:drm_edid_block_valid] *ERROR* EDID checksum is 
invalid, remainder is 128
[    8.256429] Raw EDID:
[    8.256430]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.256431]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.256432]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.256433]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.256434]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.256435]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.256436]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.256437]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.256439] i915 0000:00:02.0: HDMI-A-3: EDID block 0 invalid.
[    8.292319] [drm:drm_edid_block_valid] *ERROR* EDID checksum is 
invalid, remainder is 128
[    8.292320] Raw EDID:
[    8.292321]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.292322]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.292323]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.292324]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.292325]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.292326]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.292327]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.292327]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.326939] [drm:drm_edid_block_valid] *ERROR* EDID checksum is 
invalid, remainder is 128
[    8.326940] Raw EDID:
[    8.326941]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.326942]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.326943]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.326943]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.326944]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.326945]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.326946]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.326947]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.361727] [drm:drm_edid_block_valid] *ERROR* EDID checksum is 
invalid, remainder is 128
[    8.361728] Raw EDID:
[    8.361729]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.361730]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.361731]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.361732]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.361733]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.361734]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.361735]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.361735]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.396397] [drm:drm_edid_block_valid] *ERROR* EDID checksum is 
invalid, remainder is 128
[    8.396398] Raw EDID:
[    8.396399]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.396400]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.396401]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.396401]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.396402]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.396403]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.396404]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.396405]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.396407] i915 0000:00:02.0: HDMI-A-3: EDID block 0 invalid.
[    9.836475] [drm:drm_edid_block_valid] *ERROR* EDID checksum is 
invalid, remainder is 128
[    9.836477] Raw EDID:
[    9.836478]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.836479]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.836480]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.836481]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.836482]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.836483]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.836484]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.836484]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.872809] [drm:drm_edid_block_valid] *ERROR* EDID checksum is 
invalid, remainder is 128
[    9.872811] Raw EDID:
[    9.872812]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.872813]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.872814]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.872815]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.872816]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.872816]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.872817]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.872818]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.909170] [drm:drm_edid_block_valid] *ERROR* EDID checksum is 
invalid, remainder is 128
[    9.909171] Raw EDID:
[    9.909172]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.909173]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.909173]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.909174]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.909175]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.909176]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.909177]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.909178]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.945475] [drm:drm_edid_block_valid] *ERROR* EDID checksum is 
invalid, remainder is 128
[    9.945476] Raw EDID:
[    9.945476]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.945477]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.945478]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.945479]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.945480]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.945481]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.945482]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.945483]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.945485] i915 0000:00:02.0: HDMI-A-3: EDID block 0 invalid.
[    9.998810] EXT4-fs (sda4): re-mounted. Opts: acl,user_xattr,commit=0
[   10.001570] EXT4-fs (sda2): re-mounted. Opts: acl,user_xattr,commit=0
[   10.135003] [drm:drm_edid_block_valid] *ERROR* EDID checksum is 
invalid, remainder is 128
[   10.135005] Raw EDID:
[   10.135006]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.135007]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.135008]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.135009]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.135010]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.135011]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.135012]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.135013]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.171278] [drm:drm_edid_block_valid] *ERROR* EDID checksum is 
invalid, remainder is 128
[   10.171280] Raw EDID:
[   10.171281]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.171282]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.171283]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.171284]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.171284]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.171285]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.171286]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.171287]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.207553] [drm:drm_edid_block_valid] *ERROR* EDID checksum is 
invalid, remainder is 128
[   10.207555] Raw EDID:
[   10.207556]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.207557]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.207557]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.207558]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.207559]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.207560]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.207561]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.207562]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.243902] [drm:drm_edid_block_valid] *ERROR* EDID checksum is 
invalid, remainder is 128
[   10.243904] Raw EDID:
[   10.243905]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.243906]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.243907]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.243907]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.243908]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.243909]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.243910]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.243911]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.243913] i915 0000:00:02.0: HDMI-A-3: EDID block 0 invalid.
[   10.281446] [drm:drm_edid_block_valid] *ERROR* EDID checksum is 
invalid, remainder is 128
[   10.281447] Raw EDID:
[   10.281448]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.281449]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.281450]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.281451]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.281452]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.281453]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.281453]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.281454]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.317756] [drm:drm_edid_block_valid] *ERROR* EDID checksum is 
invalid, remainder is 128
[   10.317757] Raw EDID:
[   10.317758]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.317759]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.317759]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.317760]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.317761]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.317762]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.317763]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.317764]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.354038] [drm:drm_edid_block_valid] *ERROR* EDID checksum is 
invalid, remainder is 128
[   10.354039] Raw EDID:
[   10.354040]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.354041]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.354041]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.354042]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.354043]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.354044]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.354045]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.354046]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.390323] [drm:drm_edid_block_valid] *ERROR* EDID checksum is 
invalid, remainder is 128
[   10.390324] Raw EDID:
[   10.390324]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.390325]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.390326]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.390327]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.390328]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.390329]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.390330]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.390331]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.390332] i915 0000:00:02.0: HDMI-A-3: EDID block 0 invalid.
[   11.776999] [drm:drm_edid_block_valid] *ERROR* EDID checksum is 
invalid, remainder is 128
[   11.777001] Raw EDID:
[   11.777002]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.777003]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.777004]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.777005]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.777006]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.777007]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.777008]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.777009]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.813308] [drm:drm_edid_block_valid] *ERROR* EDID checksum is 
invalid, remainder is 128
[   11.813309] Raw EDID:
[   11.813310]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.813311]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.813312]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.813313]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.813313]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.813314]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.813315]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.813316]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.849630] [drm:drm_edid_block_valid] *ERROR* EDID checksum is 
invalid, remainder is 128
[   11.849630] Raw EDID:
[   11.849631]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.849632]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.849633]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.849634]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.849635]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.849636]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.849637]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.849638]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.885937] [drm:drm_edid_block_valid] *ERROR* EDID checksum is 
invalid, remainder is 128
[   11.885938] Raw EDID:
[   11.885938]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.885939]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.885940]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.885941]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.885942]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.885943]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.885944]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.885945]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.885947] i915 0000:00:02.0: HDMI-A-3: EDID block 0 invalid.
[   11.923426] [drm:drm_edid_block_valid] *ERROR* EDID checksum is 
invalid, remainder is 128
[   11.923427] Raw EDID:
[   11.923427]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.923428]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.923429]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.923430]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.923431]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.923432]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.923433]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.923434]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.959689] [drm:drm_edid_block_valid] *ERROR* EDID checksum is 
invalid, remainder is 128
[   11.959690] Raw EDID:
[   11.959690]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.959691]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.959692]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.959693]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.959694]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.959695]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.959696]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.959697]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.996107] [drm:drm_edid_block_valid] *ERROR* EDID checksum is 
invalid, remainder is 128
[   11.996108] Raw EDID:
[   11.996109]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.996109]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.996110]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.996111]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.996112]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.996113]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.996114]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.996115]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.032470] [drm:drm_edid_block_valid] *ERROR* EDID checksum is 
invalid, remainder is 128
[   12.032471] Raw EDID:
[   12.032472]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.032473]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.032473]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.032474]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.032475]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.032476]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.032477]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.032478]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.032479] i915 0000:00:02.0: HDMI-A-3: EDID block 0 invalid.
[   12.750536] [drm:drm_edid_block_valid] *ERROR* EDID checksum is 
invalid, remainder is 128
[   12.750538] Raw EDID:
[   12.750539]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.750540]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.750541]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.750542]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.750543]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.750544]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.750545]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.750545]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.786830] [drm:drm_edid_block_valid] *ERROR* EDID checksum is 
invalid, remainder is 128
[   12.786831] Raw EDID:
[   12.786832]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.786833]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.786834]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.786835]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.786836]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.786837]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.786838]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.786838]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.823160] [drm:drm_edid_block_valid] *ERROR* EDID checksum is 
invalid, remainder is 128
[   12.823161] Raw EDID:
[   12.823162]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.823163]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.823164]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.823165]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.823166]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.823166]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.823167]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.823168]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.859431] [drm:drm_edid_block_valid] *ERROR* EDID checksum is 
invalid, remainder is 128
[   12.859432] Raw EDID:
[   12.859432]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.859433]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.859434]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.859435]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.859436]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.859437]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.859438]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.859439]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.859441] i915 0000:00:02.0: HDMI-A-3: EDID block 0 invalid.
[   18.274243] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   28.504099] wlan0: no IPv6 routers present

geexbox:/home/mplayer # lspci
00:00.0 Host bridge: Intel Corporation Xeon E3-1200 v2/3rd Gen Core 
processor DRAM Controller (rev 09)
00:01.0 PCI bridge: Intel Corporation Xeon E3-1200 v2/3rd Gen Core 
processor PCI Express Root Port (rev 09)
00:02.0 VGA compatible controller: Intel Corporation Xeon E3-1200 v2/3rd 
Gen Core processor Graphics Controller (rev 09)
00:14.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset 
Family USB xHCI Host Controller (rev 04)
00:16.0 Communication controller: Intel Corporation 7 Series/C210 Series 
Chipset Family MEI Controller #1 (rev 04)
00:19.0 Ethernet controller: Intel Corporation 82579V Gigabit Network 
Connection (rev 04)
00:1a.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset 
Family USB Enhanced Host Controller #2 (rev 04)
00:1c.0 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset 
Family PCI Express Root Port 1 (rev c4)
00:1c.7 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset 
Family PCI Express Root Port 8 (rev c4)
00:1d.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset 
Family USB Enhanced Host Controller #1 (rev 04)
00:1f.0 ISA bridge: Intel Corporation H77 Express Chipset LPC Controller 
(rev 04)
00:1f.2 SATA controller: Intel Corporation 7 Series/C210 Series Chipset 
Family 6-port SATA Controller [AHCI mode] (rev 04)
00:1f.3 SMBus: Intel Corporation 7 Series/C210 Series Chipset Family 
SMBus Controller (rev 04)
01:00.0 PCI bridge: PLX Technology, Inc. PEX8112 x1 Lane PCI 
Express-to-PCI Bridge (rev aa)
02:04.0 Multimedia audio controller: C-Media Electronics Inc CMI8788 
[Oxygen HD Audio]


Thanks in advance
Mark

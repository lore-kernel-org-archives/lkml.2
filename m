Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751445Ab2LaPZn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2012 10:25:43 -0500
Received: from mail-ia0-f172.google.com ([209.85.210.172]:40065 "EHLO
	mail-ia0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257Ab2LaPZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2012 10:25:39 -0500
MIME-Version: 1.0
In-Reply-To: <20121231102300.GA1701@x1.alien8.de>
References: <CAHfmSg2akcYUwDW38g520Fwyr17E5dFDpuUMKejQCfLpQ4pnhQ@mail.gmail.com>
	<CAHfmSg3ug=64vXtsA4EA6xdKaqWRtT7qZW9AG8n92Q+pbDgQEQ@mail.gmail.com>
	<20121230094008.GA28308@x1.alien8.de>
	<CAHfmSg0O90nC3rnkZHAjO_MNjOoU1v8h-LN+jxx=0U+pz7NasQ@mail.gmail.com>
	<20121231102300.GA1701@x1.alien8.de>
Date: Mon, 31 Dec 2012 23:25:38 +0800
Message-ID: <CAHfmSg1qPGaMw2TPrRi0SK63_LkX4ceDEeWderKoydn8bN7=YA@mail.gmail.com>
Subject: Re: Fwd: PROBLEM: Random kernel panic & system freeze when watching video
From: Du Jiulun <dujiulun@gmail.com>
To: Borislav Petkov <bp@alien8.de>, Du Jiulun <dujiulun@gmail.com>,
        linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Boris

> I had to build the latest mcelog from kernel.org and it tells you a
> little bit more: it is an internal parity error.

Sorry I didn't know. I just used the one in Arch's repo.
BTW, do you think it's related to the SSD interface I used, the one to
replace DVD's position? Since I've decided to root the problem, I'm
going to take it off and put the DVD back, to see if it's related.
Because I don't think it's easy for CPU or memories to go bad.

> Question: is this easily reproducible or only sporadic and has happened
> only twice up 'til now?

It has happened like one or two hundred times since the last year
(when I switched from windows to linux), but since it's completely
random: the first time to watch a video, the problem arises; after
rebooting, it's fine to play the same part, but after several minutes
it freezes again; but sometimes, it doesn't freeze at all.
I can't find a certain pattern to trigger it, but the only thing is
that all these panics / freezes / reboots happen during watching
videos. (on/off line, mostly h264 ones since it's dominating somehow)

> Yep, more BIOS f*ckup.

ASUS's fault. They knew it's a buggy BIOS but didn't release fixes for
this old poor guy any more.

> By the way, can you boot vanilla 3.7 and send the _whole_ dmesg?

I downloaded the latest release 3.7.1 and verified with the signal,
then compiled with Arch's default config (but turning on HIGHMEM64G)
and no patches at all. Here's the dmesg (also available at
pastebin.com/4BD45GxM ):

(I'm also keeping using it to see if the panic problem is still there.)

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.7.1-ARCH (xiaodu@xiaodupc) (gcc version
4.7.2 (GCC) ) #1 SMP PREEMPT Mon Dec 31 22:55:21 CST 2012
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009bbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009bc00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000aace2fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000aace3000-0x00000000aad32fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000aad33000-0x00000000aad43fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000aad44000-0x00000000aad57fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000aad58000-0x00000000aad60fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000aad61000-0x00000000aad68fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000aad69000-0x00000000aad80fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000aad81000-0x00000000aad81fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000aad82000-0x00000000aad90fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000aad91000-0x00000000aad95fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000aad96000-0x00000000aad99fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000aad9a000-0x00000000aad9cfff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000aad9d000-0x00000000aad9efff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000aad9f000-0x00000000aad9ffff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000aada0000-0x00000000aada3fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000aada4000-0x00000000aada6fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000aada7000-0x00000000aadabfff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000aadac000-0x00000000aadb9fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000aadba000-0x00000000aadcffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000aadd0000-0x00000000aadd1fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000aadd2000-0x00000000abffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000adc00000-0x00000000afffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed10000-0x00000000fed13fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed18000-0x00000000fed19fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ffa00000-0x00000000ffbfffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ffe00000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x0000000147ffffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.6 present.
[    0.000000] DMI: ASUSTeK Computer Inc.         K42Jv/K42Jv, BIOS
K42Jv.212 01/25/2011
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0x148000 max_arch_pfn = 0x1000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-DFFFF uncachable
[    0.000000]   E0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 080000000 mask FE0000000 write-back
[    0.000000]   2 base 0A0000000 mask FF8000000 write-back
[    0.000000]   3 base 0A8000000 mask FFC000000 write-back
[    0.000000]   4 base 100000000 mask FC0000000 write-back
[    0.000000]   5 base 140000000 mask FF8000000 write-back
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: update [mem 0xac000000-0xffffffff] usable ==> reserved
[    0.000000] found SMP MP-table at [mem 0x000fcae0-0x000fcaef]
mapped at [c00fcae0]
[    0.000000] initial memory mapped: [mem 0x00000000-0x01bfffff]
[    0.000000] Base memory trampoline at [c0097000] 97000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x37bfdfff]
[    0.000000]  [mem 0x00000000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x379fffff] page 2M
[    0.000000]  [mem 0x37a00000-0x37bfdfff] page 4k
[    0.000000] kernel direct mapping tables up to 0x37bfdfff @ [mem
0x01bfa000-0x01bfffff]
[    0.000000] RAMDISK: [mem 0x37a56000-0x37d22fff]
[    0.000000] Allocated new RAMDISK: [mem 0x37789000-0x37a55f33]
[    0.000000] Move RAMDISK from [mem 0x37a56000-0x37d22f33] to [mem
0x37789000-0x37a55f33]
[    0.000000] ACPI: RSDP 000f0410 00024 (v02 _ASUS_)
[    0.000000] ACPI: XSDT aada5e18 0006C (v01 _ASUS_ Notebook 06222004
MSFT 00010013)
[    0.000000] ACPI: FACP aad81c18 000F4 (v04 _ASUS_ Notebook 06222004
MSFT 00010013)
[    0.000000] ACPI Warning: 32/64 FACS address mismatch in FADT - two
FACS tables! (20120913/tbfadt-394)
[    0.000000] ACPI BIOS Bug: Warning: 32/64X FACS address mismatch in
FADT - 0xAADB7F40/0x00000000AADD1D40, using 32 (20120913/tbfadt-521)
[    0.000000] ACPI: DSDT aad44018 13C72 (v01 _ASUS_ Notebook 00000000
INTL 20051117)
[    0.000000] ACPI: FACS aadb7f40 00040
[    0.000000] ACPI: APIC aada4f18 0008C (v02 _ASUS_ Notebook 06222004
MSFT 00010013)
[    0.000000] ACPI: DBGP aada6f18 00034 (v01 _ASUS_ Notebook 06222004
MSFT 00010013)
[    0.000000] ACPI: ECDT aadd1b18 000C1 (v01 _ASUS_ Notebook 06222004
AMI. 00000003)
[    0.000000] ACPI: SLIC aadb2c18 00176 (v01 _ASUS_ Notebook 06222004
ASUS 00000001)
[    0.000000] ACPI: MCFG aadd0d18 0003C (v01 _ASUS_ Notebook 06222004
MSFT 00000097)
[    0.000000] ACPI: HPET aadd0c98 00038 (v01 _ASUS_ Notebook 06222004
AMI. 00000003)
[    0.000000] ACPI: SSDT aad9f018 009F1 (v01  PmRef    CpuPm 00003000
INTL 20051117)
[    0.000000] ACPI: DMAR aad81f18 000B8 (v01 INTEL  CP_DALE  00000001
INTL 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 4356MB HIGHMEM available.
[    0.000000] 891MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 37bfe000
[    0.000000]   low ram: 0 - 37bfe000
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x37bfdfff]
[    0.000000]   HighMem  [mem 0x37bfe000-0x47ffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x0009afff]
[    0.000000]   node   0: [mem 0x00100000-0xaace2fff]
[    0.000000]   node   0: [mem 0x00000000-0x47ffffff]
[    0.000000] On node 0 totalpages: 994414
[    0.000000] free_area_init_node: node 0, pgdat c156a280,
node_mem_map f4e89200
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3947 pages, LIFO batch:0
[    0.000000]   Normal zone: 1752 pages used for memmap
[    0.000000]   Normal zone: 222502 pages, LIFO batch:31
[    0.000000]   HighMem zone: 8713 pages used for memmap
[    0.000000]   HighMem zone: 757468 pages, LIFO batch:31
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
[    0.000000] PM: Registered nosave memory: 000000000009b000 - 000000000009c000
[    0.000000] PM: Registered nosave memory: 000000000009c000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] e820: [mem 0xb0000000-0xdfffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:8
nr_node_ids:1
[    0.000000] PERCPU: Embedded 13 pages/cpu @f7b82000 s32384 r0 d20864 u53248
[    0.000000] pcpu-alloc: s32384 r0 d20864 u53248 alloc=13*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 [0] 4 [0] 5 [0] 6 [0] 7
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.
Total pages: 983917
[    0.000000] Kernel command line:
BOOT_IMAGE=/boot/vmlinuz-linux-3.7.1
root=UUID=774a149e-1f8a-474d-83d0-56f6a06c6c25 ro quiet
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Initializing CPU#0
[    0.000000] allocated 10747776 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't
want memory cgroups
[    0.000000] Initializing HighMem for node 0 (00037bfe:00148000)
[    0.000000] Memory: 3913904k/5373952k available (4026k kernel code,
63752k reserved, 1554k data, 544k init, 3064724k highmem)
[    0.000000] virtual kernel memory layout:
    fixmap  : 0xfff16000 - 0xfffff000   ( 932 kB)
    pkmap   : 0xffc00000 - 0xffe00000   (2048 kB)
    vmalloc : 0xf83fe000 - 0xffbfe000   ( 120 MB)
    lowmem  : 0xc0000000 - 0xf7bfe000   ( 891 MB)
      .init : 0xc1574000 - 0xc15fc000   ( 544 kB)
      .data : 0xc13eebe0 - 0xc15736c0   (1554 kB)
      .text : 0xc1000000 - 0xc13eebe0   (4026 kB)
[    0.000000] Checking if this processor honours the WP bit even in
supervisor mode...Ok.
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0,
CPUs=8, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] Dump stacks of tasks blocking RCU-preempt GP.
[    0.000000] NR_IRQS:2304 nr_irqs:744 16
[    0.000000] CPU 0 irqstacks, hard=f400a000 soft=f400c000
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.003333] tsc: Detected 2393.981 MHz processor
[    0.000001] Calibrating delay loop (skipped), value calculated
using timer frequency.. 4789.46 BogoMIPS (lpj=7979936)
[    0.000004] pid_max: default: 32768 minimum: 301
[    0.000036] Security Framework initialized
[    0.000039] AppArmor: AppArmor disabled by boot time parameter
[    0.000048] Mount-cache hash table entries: 512
[    0.000226] Initializing cgroup subsys cpuacct
[    0.000228] Initializing cgroup subsys memory
[    0.000260] Initializing cgroup subsys devices
[    0.000261] Initializing cgroup subsys freezer
[    0.000263] Initializing cgroup subsys net_cls
[    0.000264] Initializing cgroup subsys blkio
[    0.000291] CPU: Physical Processor ID: 0
[    0.000292] CPU: Processor Core ID: 0
[    0.000296] mce: CPU supports 9 MCE banks
[    0.000305] CPU0: Thermal monitoring enabled (TM1)
[    0.000311] process: using mwait in idle threads
[    0.000317] Last level iTLB entries: 4KB 512, 2MB 7, 4MB 7
Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32
tlb_flushall_shift: 6
[    0.000420] Freeing SMP alternatives: 16k freed
[    0.001027] ACPI: Core revision 20120913
[    0.032683] ftrace: allocating 17446 entries in 35 pages
[    0.039953] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.040392] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=0 pin2=0
[    0.073338] smpboot: CPU0: Intel(R) Core(TM) i5 CPU       M 520  @
2.40GHz (fam: 06, model: 25, stepping: 02)
[    0.176637] Performance Events: PEBS fmt1+, 16-deep LBR, Westmere
events, Intel PMU driver.
[    0.176643] perf_event_intel: CPUID marked event: 'bus cycles' unavailable
[    0.176644] ... version:                3
[    0.176645] ... bit width:              48
[    0.176645] ... generic registers:      4
[    0.176646] ... value mask:             0000ffffffffffff
[    0.176647] ... max period:             000000007fffffff
[    0.176648] ... fixed-purpose events:   3
[    0.176649] ... event mask:             000000070000000f
[    0.203319] CPU 1 irqstacks, hard=f40ec000 soft=f40ee000
[    0.213620] Initializing CPU#1
[    0.216640] NMI watchdog: enabled on all CPUs, permanently consumes
one hw-PMU counter.
[    0.203322] smpboot: Booting Node   0, Processors  #1
[    0.223285] CPU 2 irqstacks, hard=f41cc000 soft=f41ce000
[    0.233540] Initializing CPU#2
[    0.223288]  #2
[    0.243255] CPU 3 irqstacks, hard=f4228000 soft=f422a000
[    0.253463] Initializing CPU#3
[    0.243262]  #3
[    0.256485] Brought up 4 CPUs
[    0.256488] smpboot: Total of 4 processors activated (19159.84 BogoMIPS)
[    0.259100] devtmpfs: initialized
[    0.259269] PM: Registering ACPI NVS region [mem
0xaace3000-0xaad32fff] (327680 bytes)
[    0.259277] PM: Registering ACPI NVS region [mem
0xaad44000-0xaad57fff] (81920 bytes)
[    0.259279] PM: Registering ACPI NVS region [mem
0xaad61000-0xaad68fff] (32768 bytes)
[    0.259281] PM: Registering ACPI NVS region [mem
0xaad81000-0xaad81fff] (4096 bytes)
[    0.259282] PM: Registering ACPI NVS region [mem
0xaad91000-0xaad95fff] (20480 bytes)
[    0.259283] PM: Registering ACPI NVS region [mem
0xaad9a000-0xaad9cfff] (12288 bytes)
[    0.259285] PM: Registering ACPI NVS region [mem
0xaad9f000-0xaad9ffff] (4096 bytes)
[    0.259286] PM: Registering ACPI NVS region [mem
0xaadac000-0xaadb9fff] (57344 bytes)
[    0.259288] PM: Registering ACPI NVS region [mem
0xaadd0000-0xaadd1fff] (8192 bytes)
[    0.260102] NET: Registered protocol family 16
[    0.260228] ACPI FADT declares the system doesn't support PCIe
ASPM, so disable it
[    0.260230] ACPI: bus type pci registered
[    0.260291] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem
0xe0000000-0xefffffff] (base 0xe0000000)
[    0.260294] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.260295] PCI: Using MMCONFIG for extended config space
[    0.260296] PCI: Using configuration type 1 for base access
[    0.260399] mtrr: your CPUs had inconsistent variable MTRR settings
[    0.260400] mtrr: probably your BIOS does not setup all CPUs.
[    0.260400] mtrr: corrected configuration.
[    0.260782] bio: create slab <bio-0> at 0
[    0.260836] ACPI: Added _OSI(Module Device)
[    0.260838] ACPI: Added _OSI(Processor Device)
[    0.260839] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.260840] ACPI: Added _OSI(Processor Aggregator Device)
[    0.263045] ACPI: EC: EC description table is found, configuring boot EC
[    0.263050] ACPI: EC: Look up EC in DSDT
[    0.265377] ACPI: Executed 2 blocks of module-level executable AML code
[    0.280533] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.373267] ACPI: SSDT aada3918 003F7 (v01  PmRef  Cpu0Ist 00003000
INTL 20051117)
[    0.373795] ACPI: Dynamic OEM Table Load:
[    0.373797] ACPI: SSDT   (null) 003F7 (v01  PmRef  Cpu0Ist 00003000
INTL 20051117)
[    0.373930] ACPI: SSDT aada1018 008A9 (v01  PmRef  Cpu0Cst 00003001
INTL 20051117)
[    0.374432] ACPI: Dynamic OEM Table Load:
[    0.374434] ACPI: SSDT   (null) 008A9 (v01  PmRef  Cpu0Cst 00003001
INTL 20051117)
[    0.413130] ACPI: SSDT aada2a98 00303 (v01  PmRef    ApIst 00003000
INTL 20051117)
[    0.413698] ACPI: Dynamic OEM Table Load:
[    0.413699] ACPI: SSDT   (null) 00303 (v01  PmRef    ApIst 00003000
INTL 20051117)
[    0.432967] ACPI: SSDT aada0d98 00119 (v01  PmRef    ApCst 00003000
INTL 20051117)
[    0.433494] ACPI: Dynamic OEM Table Load:
[    0.433496] ACPI: SSDT   (null) 00119 (v01  PmRef    ApCst 00003000
INTL 20051117)
[    0.453365] ACPI: Interpreter enabled
[    0.453377] ACPI: (supports S0 S3 S4 S5)
[    0.453394] ACPI: Using IOAPIC for interrupt routing
[    0.567356] ACPI: EC: GPE = 0x1b, I/O: command/status = 0x66, data = 0x62
[    0.567602] ACPI: No dock devices found.
[    0.567608] PCI: Using host bridge windows from ACPI; if necessary,
use "pci=nocrs" and report a bug
[    0.568026] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-fe])
[    0.568495] PCI host bridge to bus 0000:00
[    0.568498] pci_bus 0000:00: root bus resource [bus 00-fe]
[    0.568500] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.568502] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.568503] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.568505] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3fff]
[    0.568506] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
[    0.568508] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
[    0.568509] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff]
[    0.568511] pci_bus 0000:00: root bus resource [mem 0xb0000000-0xfeafffff]
[    0.568519] pci 0000:00:00.0: [8086:0044] type 00 class 0x060000
[    0.568536] DMAR: Disabling batched IOTLB flush on Ironlake
[    0.568556] pci 0000:00:01.0: [8086:0045] type 01 class 0x060400
[    0.568586] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.568598] pci 0000:00:02.0: [8086:0046] type 00 class 0x030000
[    0.568608] pci 0000:00:02.0: reg 10: [mem 0xd3400000-0xd37fffff 64bit]
[    0.568614] pci 0000:00:02.0: reg 18: [mem 0xb0000000-0xbfffffff 64bit pref]
[    0.568618] pci 0000:00:02.0: reg 20: [io  0xe080-0xe087]
[    0.568681] pci 0000:00:16.0: [8086:3b64] type 00 class 0x078000
[    0.568709] pci 0000:00:16.0: reg 10: [mem 0xd880a000-0xd880a00f 64bit]
[    0.568804] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.568846] pci 0000:00:1a.0: [8086:3b3c] type 00 class 0x0c0320
[    0.568869] pci 0000:00:1a.0: reg 10: [mem 0xd8808000-0xd88083ff]
[    0.568976] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.569009] pci 0000:00:1b.0: [8086:3b56] type 00 class 0x040300
[    0.569029] pci 0000:00:1b.0: reg 10: [mem 0xd8800000-0xd8803fff 64bit]
[    0.569124] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.569154] pci 0000:00:1c.0: [8086:3b42] type 01 class 0x060400
[    0.569251] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.569283] pci 0000:00:1c.1: [8086:3b44] type 01 class 0x060400
[    0.569383] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.569414] pci 0000:00:1c.2: [8086:3b46] type 01 class 0x060400
[    0.569512] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.569545] pci 0000:00:1c.5: [8086:3b4c] type 01 class 0x060400
[    0.569642] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    0.569679] pci 0000:00:1d.0: [8086:3b34] type 00 class 0x0c0320
[    0.569704] pci 0000:00:1d.0: reg 10: [mem 0xd8807000-0xd88073ff]
[    0.569811] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.569837] pci 0000:00:1e.0: [8086:2448] type 01 class 0x060401
[    0.569923] pci 0000:00:1f.0: [8086:3b09] type 00 class 0x060100
[    0.570050] pci 0000:00:1f.2: [8086:3b29] type 00 class 0x010601
[    0.570076] pci 0000:00:1f.2: reg 10: [io  0xe070-0xe077]
[    0.570087] pci 0000:00:1f.2: reg 14: [io  0xe060-0xe063]
[    0.570098] pci 0000:00:1f.2: reg 18: [io  0xe050-0xe057]
[    0.570107] pci 0000:00:1f.2: reg 1c: [io  0xe040-0xe043]
[    0.570118] pci 0000:00:1f.2: reg 20: [io  0xe020-0xe03f]
[    0.570129] pci 0000:00:1f.2: reg 24: [mem 0xd8806000-0xd88067ff]
[    0.570194] pci 0000:00:1f.2: PME# supported from D3hot
[    0.570228] pci 0000:00:1f.6: [8086:3b32] type 00 class 0x118000
[    0.570255] pci 0000:00:1f.6: reg 10: [mem 0xd8804000-0xd8804fff 64bit]
[    0.570390] pci 0000:01:00.0: [10de:0caf] type 00 class 0x030000
[    0.570408] pci 0000:01:00.0: reg 10: [mem 0xd2000000-0xd2ffffff]
[    0.570424] pci 0000:01:00.0: reg 14: [mem 0xc0000000-0xcfffffff 64bit pref]
[    0.570439] pci 0000:01:00.0: reg 1c: [mem 0xd0000000-0xd1ffffff 64bit pref]
[    0.570450] pci 0000:01:00.0: reg 24: [io  0xd000-0xd07f]
[    0.570462] pci 0000:01:00.0: reg 30: [mem 0xd3000000-0xd307ffff pref]
[    0.570554] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.570557] pci 0000:00:01.0:   bridge window [io  0xd000-0xdfff]
[    0.570559] pci 0000:00:01.0:   bridge window [mem 0xc0000000-0xd30fffff]
[    0.570614] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.570618] pci 0000:00:1c.0:   bridge window [io  0xc000-0xcfff]
[    0.570623] pci 0000:00:1c.0:   bridge window [mem 0xd7400000-0xd87fffff]
[    0.570700] pci 0000:03:00.0: [168c:002b] type 00 class 0x028000
[    0.570722] pci 0000:03:00.0: reg 10: [mem 0xd6000000-0xd600ffff 64bit]
[    0.570823] pci 0000:03:00.0: supports D1
[    0.570824] pci 0000:03:00.0: PME# supported from D0 D1 D3hot D3cold
[    0.575967] pci 0000:00:1c.1: PCI bridge to [bus 03]
[    0.575974] pci 0000:00:1c.1:   bridge window [io  0xb000-0xbfff]
[    0.575982] pci 0000:00:1c.1:   bridge window [mem 0xd6000000-0xd73fffff]
[    0.576055] pci 0000:00:1c.2: PCI bridge to [bus 04-06]
[    0.576060] pci 0000:00:1c.2:   bridge window [io  0xa000-0xafff]
[    0.576064] pci 0000:00:1c.2:   bridge window [mem 0xd4c00000-0xd5ffffff]
[    0.576145] pci 0000:07:00.0: [197b:2382] type 00 class 0x088000
[    0.576168] pci 0000:07:00.0: reg 10: [mem 0xd3805000-0xd38050ff]
[    0.576381] pci 0000:07:00.2: [197b:2381] type 00 class 0x080501
[    0.576404] pci 0000:07:00.2: reg 10: [mem 0xd3804000-0xd38040ff]
[    0.576617] pci 0000:07:00.5: [197b:0250] type 00 class 0x020000
[    0.576640] pci 0000:07:00.5: reg 10: [mem 0xd3800000-0xd3803fff]
[    0.576672] pci 0000:07:00.5: reg 18: [io  0x9100-0x917f]
[    0.576689] pci 0000:07:00.5: reg 1c: [io  0x9000-0x90ff]
[    0.576823] pci 0000:07:00.5: PME# supported from D0 D3hot D3cold
[    0.582629] pci 0000:00:1c.5: PCI bridge to [bus 07]
[    0.582636] pci 0000:00:1c.5:   bridge window [io  0x9000-0x9fff]
[    0.582643] pci 0000:00:1c.5:   bridge window [mem 0xd3800000-0xd4bfffff]
[    0.582733] pci 0000:00:1e.0: PCI bridge to [bus 08] (subtractive decode)
[    0.582746] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7]
(subtractive decode)
[    0.582747] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff]
(subtractive decode)
[    0.582749] pci 0000:00:1e.0:   bridge window [mem
0x000a0000-0x000bffff] (subtractive decode)
[    0.582751] pci 0000:00:1e.0:   bridge window [mem
0x000d0000-0x000d3fff] (subtractive decode)
[    0.582752] pci 0000:00:1e.0:   bridge window [mem
0x000d4000-0x000d7fff] (subtractive decode)
[    0.582754] pci 0000:00:1e.0:   bridge window [mem
0x000d8000-0x000dbfff] (subtractive decode)
[    0.582755] pci 0000:00:1e.0:   bridge window [mem
0x000dc000-0x000dffff] (subtractive decode)
[    0.582757] pci 0000:00:1e.0:   bridge window [mem
0xb0000000-0xfeafffff] (subtractive decode)
[    0.582788] pci_bus 0000:00: on NUMA node 0
[    0.582791] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.583001] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEG1._PRT]
[    0.583068] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.583144] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.583194] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    0.583250] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP06._PRT]
[    0.583302] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
[    0.583478]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.583683]  pci0000:00: ACPI _OSC control (0x1d) granted
[    1.333027] ACPI: PCI Root Bridge [CPBG] (domain 0000 [bus ff])
[    1.333075] PCI host bridge to bus 0000:ff
[    1.333078] pci_bus 0000:ff: root bus resource [bus ff]
[    1.333083] pci 0000:ff:00.0: [8086:2c62] type 00 class 0x060000
[    1.333100] pci 0000:ff:00.1: [8086:2d01] type 00 class 0x060000
[    1.333118] pci 0000:ff:02.0: [8086:2d10] type 00 class 0x060000
[    1.333134] pci 0000:ff:02.1: [8086:2d11] type 00 class 0x060000
[    1.333149] pci 0000:ff:02.2: [8086:2d12] type 00 class 0x060000
[    1.333165] pci 0000:ff:02.3: [8086:2d13] type 00 class 0x060000
[    1.333188] pci_bus 0000:ff: on NUMA node 0
[    1.333194]  pci0000:ff: ACPI _OSC support notification failed,
disabling PCIe ASPM
[    1.333196]  pci0000:ff: Unable to request _OSC control (_OSC
support mask: 0x08)
[    1.333387] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12
14 15) *11
[    1.333428] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 11 12
14 15) *10
[    1.333467] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 *4 5 6 7 10 12 14 15)
[    1.333506] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 *5 6 7 11 12 14 15)
[    1.333544] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12
14 15) *0, disabled.
[    1.333583] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12
14 15) *0, disabled.
[    1.333622] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 *3 4 5 6 7 10 12 14 15)
[    1.333660] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 11 12
14 15) *10
[    1.333725] vgaarb: device added:
PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    1.333729] vgaarb: device added:
PCI:0000:01:00.0,decodes=io+mem,owns=none,locks=none
[    1.333731] vgaarb: loaded
[    1.333732] vgaarb: bridge control possible 0000:01:00.0
[    1.333733] vgaarb: no bridge control possible 0000:00:02.0
[    1.333766] PCI: Using ACPI for IRQ routing
[    1.343445] PCI: pci_cache_line_size set to 64 bytes
[    1.343520] e820: reserve RAM buffer [mem 0x0009bc00-0x0009ffff]
[    1.343522] e820: reserve RAM buffer [mem 0xaace3000-0xabffffff]
[    1.343611] NetLabel: Initializing
[    1.343613] NetLabel:  domain hash size = 128
[    1.343613] NetLabel:  protocols = UNLABELED CIPSOv4
[    1.343624] NetLabel:  unlabeled traffic allowed by default
[    1.343653] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    1.343657] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    1.345670] Switching to clocksource hpet
[    1.350024] pnp: PnP ACPI init
[    1.350041] ACPI: bus type pnp registered
[    1.350316] pnp 00:00: [bus 00-fe]
[    1.350319] pnp 00:00: [io  0x0000-0x0cf7 window]
[    1.350321] pnp 00:00: [io  0x0cf8-0x0cff]
[    1.350322] pnp 00:00: [io  0x0d00-0xffff window]
[    1.350326] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    1.350327] pnp 00:00: [mem 0x000c0000-0x000c3fff window]
[    1.350329] pnp 00:00: [mem 0x000c4000-0x000c7fff window]
[    1.350330] pnp 00:00: [mem 0x000c8000-0x000cbfff window]
[    1.350332] pnp 00:00: [mem 0x000cc000-0x000cffff window]
[    1.350333] pnp 00:00: [mem 0x000d0000-0x000d3fff window]
[    1.350335] pnp 00:00: [mem 0x000d4000-0x000d7fff window]
[    1.350336] pnp 00:00: [mem 0x000d8000-0x000dbfff window]
[    1.350338] pnp 00:00: [mem 0x000dc000-0x000dffff window]
[    1.350340] pnp 00:00: [mem 0x000e0000-0x000e3fff window]
[    1.350341] pnp 00:00: [mem 0x000e4000-0x000e7fff window]
[    1.350343] pnp 00:00: [mem 0x000e8000-0x000ebfff window]
[    1.350344] pnp 00:00: [mem 0x000ec000-0x000effff window]
[    1.350346] pnp 00:00: [mem 0x000f0000-0x000fffff window]
[    1.350347] pnp 00:00: [mem 0xb0000000-0xfeafffff window]
[    1.350384] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08
PNP0a03 (active)
[    1.399030] pnp 00:01: [io  0x0000-0x001f]
[    1.399035] pnp 00:01: [io  0x0081-0x0091]
[    1.399037] pnp 00:01: [io  0x0093-0x009f]
[    1.399038] pnp 00:01: [io  0x00c0-0x00df]
[    1.399040] pnp 00:01: [dma 4]
[    1.399059] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    1.399066] pnp 00:02: [mem 0xff000000-0xffffffff]
[    1.399083] pnp 00:02: Plug and Play ACPI device, IDs INT0800 (active)
[    1.399147] pnp 00:03: [mem 0xfed00000-0xfed003ff]
[    1.399165] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.399173] pnp 00:04: [io  0x00f0]
[    1.399183] pnp 00:04: [irq 13]
[    1.399200] pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
[    1.399209] pnp 00:05: [io  0x002e-0x002f]
[    1.399210] pnp 00:05: [io  0x004e-0x004f]
[    1.399212] pnp 00:05: [io  0x0061]
[    1.399213] pnp 00:05: [io  0x0063]
[    1.399214] pnp 00:05: [io  0x0065]
[    1.399216] pnp 00:05: [io  0x0067]
[    1.399217] pnp 00:05: [io  0x0070]
[    1.399218] pnp 00:05: [io  0x0092]
[    1.399220] pnp 00:05: [io  0x00b2-0x00b3]
[    1.399221] pnp 00:05: [io  0x0680-0x069f]
[    1.399223] pnp 00:05: [io  0xff00-0xff0f]
[    1.399226] pnp 00:05: [io  0xffff]
[    1.399227] pnp 00:05: [io  0xffff]
[    1.399228] pnp 00:05: [io  0x0400-0x047f]
[    1.399230] pnp 00:05: [io  0x0500-0x057f]
[    1.399231] pnp 00:05: [io  0x164e-0x164f]
[    1.399270] system 00:05: [io  0x0680-0x069f] has been reserved
[    1.399272] system 00:05: [io  0xff00-0xff0f] has been reserved
[    1.399274] system 00:05: [io  0xffff] has been reserved
[    1.399276] system 00:05: [io  0xffff] has been reserved
[    1.399278] system 00:05: [io  0x0400-0x047f] has been reserved
[    1.399280] system 00:05: [io  0x0500-0x057f] has been reserved
[    1.399282] system 00:05: [io  0x164e-0x164f] has been reserved
[    1.399284] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.399291] pnp 00:06: [io  0x0070-0x0077]
[    1.399297] pnp 00:06: [irq 8]
[    1.399313] pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.399326] pnp 00:07: [io  0x0240-0x0259]
[    1.399352] system 00:07: [io  0x0240-0x0259] has been reserved
[    1.399354] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.399392] pnp 00:08: [irq 12]
[    1.399411] pnp 00:08: Plug and Play ACPI device, IDs ETD0001
SYN0a00 SYN0002 PNP0f03 PNP0f13 PNP0f12 (active)
[    1.399429] pnp 00:09: [io  0x0060]
[    1.399431] pnp 00:09: [io  0x0064]
[    1.399436] pnp 00:09: [irq 1]
[    1.399453] pnp 00:09: Plug and Play ACPI device, IDs PNP0303
PNP030b (active)
[    1.399911] pnp 00:0a: [mem 0xfed1c000-0xfed1ffff]
[    1.399914] pnp 00:0a: [mem 0xfed10000-0xfed13fff]
[    1.399915] pnp 00:0a: [mem 0xfed18000-0xfed18fff]
[    1.399917] pnp 00:0a: [mem 0xfed19000-0xfed19fff]
[    1.399918] pnp 00:0a: [mem 0xe0000000-0xefffffff]
[    1.399920] pnp 00:0a: [mem 0xfed20000-0xfed3ffff]
[    1.399921] pnp 00:0a: [mem 0xfed90000-0xfed93fff]
[    1.399922] pnp 00:0a: [mem 0xfed45000-0xfed8ffff]
[    1.399924] pnp 00:0a: [mem 0xff000000-0xffffffff]
[    1.399925] pnp 00:0a: [mem 0xfee00000-0xfeefffff]
[    1.399927] pnp 00:0a: [mem 0xd8805000-0xd8805fff]
[    1.399928] pnp 00:0a: [mem 0xdffff000-0xdfffffff]
[    1.399971] system 00:0a: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    1.399973] system 00:0a: [mem 0xfed10000-0xfed13fff] has been reserved
[    1.399975] system 00:0a: [mem 0xfed18000-0xfed18fff] has been reserved
[    1.399977] system 00:0a: [mem 0xfed19000-0xfed19fff] has been reserved
[    1.399979] system 00:0a: [mem 0xe0000000-0xefffffff] has been reserved
[    1.399981] system 00:0a: [mem 0xfed20000-0xfed3ffff] has been reserved
[    1.399983] system 00:0a: [mem 0xfed90000-0xfed93fff] has been reserved
[    1.399985] system 00:0a: [mem 0xfed45000-0xfed8ffff] has been reserved
[    1.399988] system 00:0a: [mem 0xff000000-0xffffffff] could not be reserved
[    1.399990] system 00:0a: [mem 0xfee00000-0xfeefffff] could not be reserved
[    1.399992] system 00:0a: [mem 0xd8805000-0xd8805fff] has been reserved
[    1.399994] system 00:0a: [mem 0xdffff000-0xdfffffff] has been reserved
[    1.399996] system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.400136] pnp 00:0b: [bus ff]
[    1.400161] pnp 00:0b: Plug and Play ACPI device, IDs PNP0a03 (active)
[    1.400178] pnp: PnP ACPI: found 12 devices
[    1.400179] ACPI: ACPI bus type pnp unregistered
[    1.436650] pci 0000:00:1c.0: bridge window [mem
0x00100000-0x000fffff 64bit pref] to [bus 02] add_size 200000
[    1.436661] pci 0000:00:1c.1: bridge window [mem
0x00100000-0x000fffff 64bit pref] to [bus 03] add_size 200000
[    1.436671] pci 0000:00:1c.2: bridge window [mem
0x00100000-0x000fffff 64bit pref] to [bus 04-06] add_size 200000
[    1.436682] pci 0000:00:1c.5: bridge window [mem
0x00100000-0x000fffff 64bit pref] to [bus 07] add_size 200000
[    1.436696] pci 0000:00:1c.0: res[15]=[mem 0x00100000-0x000fffff
64bit pref] get_res_add_size add_size 200000
[    1.436697] pci 0000:00:1c.1: res[15]=[mem 0x00100000-0x000fffff
64bit pref] get_res_add_size add_size 200000
[    1.436699] pci 0000:00:1c.2: res[15]=[mem 0x00100000-0x000fffff
64bit pref] get_res_add_size add_size 200000
[    1.436701] pci 0000:00:1c.5: res[15]=[mem 0x00100000-0x000fffff
64bit pref] get_res_add_size add_size 200000
[    1.436707] pci 0000:00:1c.0: BAR 15: assigned [mem
0xd3100000-0xd32fffff 64bit pref]
[    1.436711] pci 0000:00:1c.1: BAR 15: assigned [mem
0xd8900000-0xd8afffff 64bit pref]
[    1.436716] pci 0000:00:1c.2: BAR 15: assigned [mem
0xd8b00000-0xd8cfffff 64bit pref]
[    1.436720] pci 0000:00:1c.5: BAR 15: assigned [mem
0xd8d00000-0xd8efffff 64bit pref]
[    1.436722] pci 0000:00:01.0: PCI bridge to [bus 01]
[    1.436725] pci 0000:00:01.0:   bridge window [io  0xd000-0xdfff]
[    1.436728] pci 0000:00:01.0:   bridge window [mem 0xc0000000-0xd30fffff]
[    1.436732] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    1.436735] pci 0000:00:1c.0:   bridge window [io  0xc000-0xcfff]
[    1.436741] pci 0000:00:1c.0:   bridge window [mem 0xd7400000-0xd87fffff]
[    1.436746] pci 0000:00:1c.0:   bridge window [mem
0xd3100000-0xd32fffff 64bit pref]
[    1.436753] pci 0000:00:1c.1: PCI bridge to [bus 03]
[    1.436756] pci 0000:00:1c.1:   bridge window [io  0xb000-0xbfff]
[    1.436761] pci 0000:00:1c.1:   bridge window [mem 0xd6000000-0xd73fffff]
[    1.436766] pci 0000:00:1c.1:   bridge window [mem
0xd8900000-0xd8afffff 64bit pref]
[    1.436773] pci 0000:00:1c.2: PCI bridge to [bus 04-06]
[    1.436776] pci 0000:00:1c.2:   bridge window [io  0xa000-0xafff]
[    1.436782] pci 0000:00:1c.2:   bridge window [mem 0xd4c00000-0xd5ffffff]
[    1.436786] pci 0000:00:1c.2:   bridge window [mem
0xd8b00000-0xd8cfffff 64bit pref]
[    1.436793] pci 0000:00:1c.5: PCI bridge to [bus 07]
[    1.436797] pci 0000:00:1c.5:   bridge window [io  0x9000-0x9fff]
[    1.436802] pci 0000:00:1c.5:   bridge window [mem 0xd3800000-0xd4bfffff]
[    1.436807] pci 0000:00:1c.5:   bridge window [mem
0xd8d00000-0xd8efffff 64bit pref]
[    1.436814] pci 0000:00:1e.0: PCI bridge to [bus 08]
[    1.436868] pci 0000:00:1e.0: setting latency timer to 64
[    1.436872] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.436874] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.436875] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.436877] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000d3fff]
[    1.436878] pci_bus 0000:00: resource 8 [mem 0x000d4000-0x000d7fff]
[    1.436880] pci_bus 0000:00: resource 9 [mem 0x000d8000-0x000dbfff]
[    1.436881] pci_bus 0000:00: resource 10 [mem 0x000dc000-0x000dffff]
[    1.436883] pci_bus 0000:00: resource 11 [mem 0xb0000000-0xfeafffff]
[    1.436885] pci_bus 0000:01: resource 0 [io  0xd000-0xdfff]
[    1.436886] pci_bus 0000:01: resource 1 [mem 0xc0000000-0xd30fffff]
[    1.436888] pci_bus 0000:02: resource 0 [io  0xc000-0xcfff]
[    1.436890] pci_bus 0000:02: resource 1 [mem 0xd7400000-0xd87fffff]
[    1.436892] pci_bus 0000:02: resource 2 [mem 0xd3100000-0xd32fffff
64bit pref]
[    1.436893] pci_bus 0000:03: resource 0 [io  0xb000-0xbfff]
[    1.436895] pci_bus 0000:03: resource 1 [mem 0xd6000000-0xd73fffff]
[    1.436896] pci_bus 0000:03: resource 2 [mem 0xd8900000-0xd8afffff
64bit pref]
[    1.436898] pci_bus 0000:04: resource 0 [io  0xa000-0xafff]
[    1.436900] pci_bus 0000:04: resource 1 [mem 0xd4c00000-0xd5ffffff]
[    1.436901] pci_bus 0000:04: resource 2 [mem 0xd8b00000-0xd8cfffff
64bit pref]
[    1.436903] pci_bus 0000:07: resource 0 [io  0x9000-0x9fff]
[    1.436904] pci_bus 0000:07: resource 1 [mem 0xd3800000-0xd4bfffff]
[    1.436906] pci_bus 0000:07: resource 2 [mem 0xd8d00000-0xd8efffff
64bit pref]
[    1.436908] pci_bus 0000:08: resource 4 [io  0x0000-0x0cf7]
[    1.436909] pci_bus 0000:08: resource 5 [io  0x0d00-0xffff]
[    1.436911] pci_bus 0000:08: resource 6 [mem 0x000a0000-0x000bffff]
[    1.436912] pci_bus 0000:08: resource 7 [mem 0x000d0000-0x000d3fff]
[    1.436914] pci_bus 0000:08: resource 8 [mem 0x000d4000-0x000d7fff]
[    1.436915] pci_bus 0000:08: resource 9 [mem 0x000d8000-0x000dbfff]
[    1.436917] pci_bus 0000:08: resource 10 [mem 0x000dc000-0x000dffff]
[    1.436918] pci_bus 0000:08: resource 11 [mem 0xb0000000-0xfeafffff]
[    1.436953] NET: Registered protocol family 2
[    1.437087] TCP established hash table entries: 131072 (order: 8,
1048576 bytes)
[    1.437642] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    1.437918] TCP: Hash tables configured (established 131072 bind 65536)
[    1.437937] TCP: reno registered
[    1.437940] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    1.437948] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    1.438003] NET: Registered protocol family 1
[    1.438014] pci 0000:00:02.0: Boot video device
[    1.765047] PCI: CLS 64 bytes, default 64
[    1.765105] Unpacking initramfs...
[    1.822134] Freeing initrd memory: 2868k freed
[    1.822672] dmar: Host address width 36
[    1.822677] dmar: DRHD base: 0x000000fed90000 flags: 0x0
[    1.822695] dmar: IOMMU 0: reg_base_addr fed90000 ver 1:0 cap
c9008020e30272 ecap 1000
[    1.822696] dmar: DRHD base: 0x000000fed91000 flags: 0x0
[    1.822701] dmar: IOMMU 1: reg_base_addr fed91000 ver 1:0 cap
c0000020230272 ecap 1000
[    1.822702] dmar: DRHD base: 0x000000fed93000 flags: 0x1
[    1.822707] dmar: IOMMU 2: reg_base_addr fed93000 ver 1:0 cap
c9008020630272 ecap 1000
[    1.822708] dmar: RMRR base: 0x000000aad69000 end: 0x000000aad7cfff
[    1.822709] dmar: RMRR base: 0x000000adc00000 end: 0x000000afffffff
[    1.822920] apm: BIOS not found.
[    1.823110] audit: initializing netlink socket (disabled)
[    1.823123] type=2000 audit(1356966591.703:1): initialized
[    1.833310] bounce pool size: 64 pages
[    1.833319] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.834823] VFS: Disk quotas dquot_6.5.2
[    1.834878] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    1.835011] msgmni has been set to 1664
[    1.835286] Block layer SCSI generic (bsg) driver version 0.4
loaded (major 252)
[    1.835331] io scheduler noop registered
[    1.835332] io scheduler deadline registered
[    1.835339] io scheduler cfq registered (default)
[    1.835432] pcieport 0000:00:01.0: irq 40 for MSI/MSI-X
[    1.835535] pcieport 0000:00:1c.0: irq 41 for MSI/MSI-X
[    1.835665] pcieport 0000:00:1c.1: irq 42 for MSI/MSI-X
[    1.835795] pcieport 0000:00:1c.2: irq 43 for MSI/MSI-X
[    1.835924] pcieport 0000:00:1c.5: irq 44 for MSI/MSI-X
[    1.836022] pcieport 0000:00:01.0: Signaling PME through PCIe PME interrupt
[    1.836024] pci 0000:01:00.0: Signaling PME through PCIe PME interrupt
[    1.836027] pcie_pme 0000:00:01.0:pcie01: service driver pcie_pme loaded
[    1.836045] pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
[    1.836050] pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
[    1.836067] pcieport 0000:00:1c.1: Signaling PME through PCIe PME interrupt
[    1.836069] pci 0000:03:00.0: Signaling PME through PCIe PME interrupt
[    1.836073] pcie_pme 0000:00:1c.1:pcie01: service driver pcie_pme loaded
[    1.836091] pcieport 0000:00:1c.2: Signaling PME through PCIe PME interrupt
[    1.836096] pcie_pme 0000:00:1c.2:pcie01: service driver pcie_pme loaded
[    1.836114] pcieport 0000:00:1c.5: Signaling PME through PCIe PME interrupt
[    1.836115] pci 0000:07:00.0: Signaling PME through PCIe PME interrupt
[    1.836117] pci 0000:07:00.2: Signaling PME through PCIe PME interrupt
[    1.836118] pci 0000:07:00.5: Signaling PME through PCIe PME interrupt
[    1.836123] pcie_pme 0000:00:1c.5:pcie01: service driver pcie_pme loaded
[    1.836172] vesafb: mode is 1024x768x32, linelength=4096, pages=0
[    1.836174] vesafb: scrolling: redraw
[    1.836175] vesafb: Truecolor: size=8:8:8:8, shift=24:16:8:0
[    1.836365] vesafb: framebuffer at 0xb0000000, mapped to
0xf8480000, using 3072k, total 3072k
[    1.947250] Console: switching to colour frame buffer device 128x48
[    2.058066] fb0: VESA VGA frame buffer device
[    2.058090] intel_idle: MWAIT substates: 0x1120
[    2.058092] intel_idle: v0.4 model 0x25
[    2.058093] intel_idle: lapic_timer_reliable_states 0xffffffff
[    2.058145] GHES: HEST is not enabled!
[    2.058155] isapnp: Scanning for PnP cards...
[    2.371041] isapnp: No Plug & Play device found
[    2.371091] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    2.371694] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M]
at 0x60,0x64 irq 1,12
[    2.373220] i8042: Detected active multiplexing controller, rev 1.1
[    2.374069] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.374092] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[    2.374110] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[    2.374128] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[    2.374144] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[    2.374262] mousedev: PS/2 mouse device common for all mice
[    2.374342] rtc_cmos 00:06: RTC can wake from S4
[    2.374476] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
[    2.374506] rtc0: alarms up to one year, y3k, 242 bytes nvram, hpet irqs
[    2.374570] cpuidle: using governor ladder
[    2.374652] cpuidle: using governor menu
[    2.374721] drop_monitor: Initializing network drop monitor service
[    2.374794] TCP: cubic registered
[    2.374877] NET: Registered protocol family 10
[    2.375020] NET: Registered protocol family 17
[    2.375027] Key type dns_resolver registered
[    2.375161] Using IPI No-Shortcut mode
[    2.375330] PM: Hibernation image not present or could not be loaded.
[    2.375342] registered taskstats version 1
[    2.376190] rtc_cmos 00:06: setting system clock to 2012-12-31
15:09:53 UTC (1356966593)
[    2.376403] Freeing unused kernel memory: 544k freed
[    2.376627] Write protecting the kernel text: 4028k
[    2.376693] Write protecting the kernel read-only data: 1188k
[    2.376694] NX-protecting the kernel data: 2116k
[    2.389119] systemd-udevd[58]: starting version 196
[    2.408249] input: AT Translated Set 2 keyboard as
/devices/platform/i8042/serio0/input/input0
[    2.425782] ACPI: bus type usb registered
[    2.425813] usbcore: registered new interface driver usbfs
[    2.425838] usbcore: registered new interface driver hub
[    2.426558] usbcore: registered new device driver usb
[    2.427377] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.427429] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[    2.427434] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[    2.427444] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned
bus number 1
[    2.431418] ehci_hcd 0000:00:1a.0: debug port 2
[    2.431428] ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
[    2.431452] ehci_hcd 0000:00:1a.0: irq 16, io mem 0xd8808000
[    2.431817] sdhci: Secure Digital Host Controller Interface driver
[    2.431819] sdhci: Copyright(c) Pierre Ossman
[    2.432952] sdhci-pci 0000:07:00.0: SDHCI controller found
[197b:2382] (rev 80)
[    2.433052] Registered led device: mmc0::
[    2.434382] SCSI subsystem initialized
[    2.435864] ACPI: bus type scsi registered
[    2.436054] libata version 3.00 loaded.
[    2.440498] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    2.441730] hub 1-0:1.0: USB hub found
[    2.441736] hub 1-0:1.0: 2 ports detected
[    2.441991] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[    2.442000] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[    2.442016] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned
bus number 2
[    2.446038] ehci_hcd 0000:00:1d.0: debug port 2
[    2.446048] ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
[    2.446070] ehci_hcd 0000:00:1d.0: irq 23, io mem 0xd8807000
[    2.453830] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    2.454118] hub 2-0:1.0: USB hub found
[    2.454125] hub 2-0:1.0: 2 ports detected
[    2.454314] ahci 0000:00:1f.2: version 3.0
[    2.454430] ahci 0000:00:1f.2: irq 45 for MSI/MSI-X
[    2.454575] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 4 ports 3
Gbps 0x23 impl SATA mode
[    2.454585] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio
slum part ems sxs apst
[    2.454595] ahci 0000:00:1f.2: setting latency timer to 64
[    2.457204] mmc0: SDHCI controller on PCI [0000:07:00.0] using ADMA
[    2.457243] sdhci-pci 0000:07:00.2: SDHCI controller found
[197b:2381] (rev 80)
[    2.457275] sdhci-pci 0000:07:00.2: Refusing to bind to secondary interface.
[    2.467997] scsi0 : ahci
[    2.468096] scsi1 : ahci
[    2.468183] scsi2 : ahci
[    2.468274] scsi3 : ahci
[    2.468361] scsi4 : ahci
[    2.468452] scsi5 : ahci
[    2.468504] ata1: SATA max UDMA/133 abar m2048@0xd8806000 port
0xd8806100 irq 45
[    2.468508] ata2: SATA max UDMA/133 abar m2048@0xd8806000 port
0xd8806180 irq 45
[    2.468509] ata3: DUMMY
[    2.468510] ata4: DUMMY
[    2.468511] ata5: DUMMY
[    2.468513] ata6: SATA max UDMA/133 abar m2048@0xd8806000 port
0xd8806380 irq 45
[    2.746711] usb 1-1: new high-speed USB device number 2 using ehci_hcd
[    2.786655] ata6: SATA link down (SStatus 0 SControl 300)
[    2.786753] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.786806] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.788149] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE
LOCK) filtered out
[    2.788416] ata1.00: ACPI cmd ef/10:06:00:00:00:a0 (SET FEATURES) succeeded
[    2.788422] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES)
filtered out
[    2.798239] ata2.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE
LOCK) filtered out
[    2.798343] ata2.00: ACPI cmd ef/10:06:00:00:00:a0 (SET FEATURES) succeeded
[    2.798348] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES)
filtered out
[    2.808528] ata2.00: ATA-8: OCZ-AGILITY3, 2.15, max UDMA/133
[    2.808533] ata2.00: 117231408 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    2.808982] ata2.00: failed to get Identify Device Data, Emask 0x1
[    2.818204] ata2.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE
LOCK) filtered out
[    2.818292] ata2.00: ACPI cmd ef/10:06:00:00:00:a0 (SET FEATURES) succeeded
[    2.818297] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES)
filtered out
[    2.823263] tsc: Refined TSC clocksource calibration: 2393.999 MHz
[    2.823270] Switching to clocksource tsc
[    2.824050] ata1.00: ATA-8: ST9500420AS, 0003SDM1, max UDMA/133
[    2.824055] ata1.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    2.824399] ata1.00: failed to get Identify Device Data, Emask 0x1
[    2.826751] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE
LOCK) filtered out
[    2.827108] ata1.00: ACPI cmd ef/10:06:00:00:00:a0 (SET FEATURES) succeeded
[    2.827114] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES)
filtered out
[    2.828962] ata2.00: failed to get Identify Device Data, Emask 0x1
[    2.828971] ata2.00: configured for UDMA/133
[    2.829348] ata1.00: failed to get Identify Device Data, Emask 0x1
[    2.829355] ata1.00: configured for UDMA/133
[    2.829643] scsi 0:0:0:0: Direct-Access     ATA      ST9500420AS
  0003 PQ: 0 ANSI: 5
[    2.830237] scsi 1:0:0:0: Direct-Access     ATA      OCZ-AGILITY3
  2.15 PQ: 0 ANSI: 5
[    2.830054] ACPI: Invalid Power Resource to register!
[    2.830603] ACPI: Invalid Power Resource to register!
[    2.836059] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks:
(500 GB/465 GiB)
[    2.836089] sd 0:0:0:0: [sda] Write Protect is off
[    2.836091] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.836102] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    2.836253] sd 1:0:0:0: [sdb] 117231408 512-byte logical blocks:
(60.0 GB/55.8 GiB)
[    2.836294] sd 1:0:0:0: [sdb] Write Protect is off
[    2.836296] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    2.836308] sd 1:0:0:0: [sdb] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    2.836701]  sdb: sdb1
[    2.837093] sd 1:0:0:0: [sdb] Attached SCSI disk
[    2.870479] hub 1-1:1.0: USB hub found
[    2.870678] hub 1-1:1.0: 6 ports detected
[    2.905664]  sda: sda1 sda2 < sda5 sda6 sda7 >
[    2.906460] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.979586] usb 2-1: new high-speed USB device number 2 using ehci_hcd
[    3.103453] hub 2-1:1.0: USB hub found
[    3.103653] hub 2-1:1.0: 8 ports detected
[    3.172776] usb 1-1.2: new high-speed USB device number 3 using ehci_hcd
[    3.372432] usb 2-1.2: new full-speed USB device number 3 using ehci_hcd
[    3.543990] EXT4-fs (sdb1): mounted filesystem with ordered data
mode. Opts: (null)
[    3.618830] systemd[1]: systemd 196 running in system mode. (+PAM
-LIBWRAP -AUDIT -SELINUX -IMA -SYSVINIT +LIBCRYPTSETUP +GCRYPT +ACL
+XZ; arch)
[    3.619459] systemd[1]: Set hostname to <xiaodupc>.
[    3.674881] systemd[1]: Starting Forward Password Requests to Wall
Directory Watch.
[    3.674923] systemd[1]: Started Forward Password Requests to Wall
Directory Watch.
[    3.674934] systemd[1]: Starting Login Prompts.
[    3.674943] systemd[1]: Reached target Login Prompts.
[    3.674950] systemd[1]: Starting Remote File Systems.
[    3.674957] systemd[1]: Reached target Remote File Systems.
[    3.674965] systemd[1]: Starting /dev/initctl Compatibility Named Pipe.
[    3.674984] systemd[1]: Listening on /dev/initctl Compatibility Named Pipe.
[    3.674991] systemd[1]: Starting Delayed Shutdown Socket.
[    3.675041] systemd[1]: Listening on Delayed Shutdown Socket.
[    3.675070] systemd[1]: Starting Arbitrary Executable File Formats
File System Automount Point.
[    3.675157] systemd[1]: Set up automount Arbitrary Executable File
Formats File System Automount Point.
[    3.675212] systemd[1]: Starting udev Kernel Socket.
[    3.675232] systemd[1]: Listening on udev Kernel Socket.
[    3.675274] systemd[1]: Starting udev Control Socket.
[    3.675295] systemd[1]: Listening on udev Control Socket.
[    3.675304] systemd[1]: Starting Encrypted Volumes.
[    3.675312] systemd[1]: Reached target Encrypted Volumes.
[    3.675322] systemd[1]: Starting Dispatch Password Requests to
Console Directory Watch.
[    3.675352] systemd[1]: Started Dispatch Password Requests to
Console Directory Watch.
[    3.675361] systemd[1]: Expecting device
dev-disk-by\x2duuid-09c447b5\x2d6328\x2d483d\x2daa02\x2d218e0b440d49.device...
[    3.675370] systemd[1]: Expecting device
dev-disk-by\x2duuid-a1d27b0f\x2d365d\x2d4200\x2da162\x2dbaa67b00dfca.device...
[    3.675380] systemd[1]: Expecting device
dev-disk-by\x2duuid-73e875cf\x2d1d2c\x2d4bd4\x2d80ae\x2dbc8e261d28d3.device...
[    3.675389] systemd[1]: Starting Journal Socket.
[    3.675425] systemd[1]: Listening on Journal Socket.
[    3.675441] systemd[1]: Started File System Check on Root Device.
[    3.675449] systemd[1]: Starting Remount Root and Kernel File Systems...
[    3.689076] systemd[1]: Starting Apply Kernel Variables...
[    3.695203] systemd[1]: Mounting Huge Pages File System...
[    3.698014] EXT4-fs (sdb1): re-mounted. Opts: data=ordered,discard
[    3.708539] systemd[1]: Mounting Debug File System...
[    3.712566] systemd[1]: Starting Load Kernel Modules...
[    3.741874] systemd[1]: Starting udev Kernel Device Manager...
[    3.745459] systemd[1]: Starting udev Coldplug all Devices...
[    3.758456] systemd[1]: Starting Setup Virtual Console...
[    3.758510] systemd-udevd[137]: starting version 196
[    3.768405] systemd[1]: Mounting POSIX Message Queue File System...
[    3.775559] systemd[1]: Started Set Up Additional Binary Formats.
[    3.775604] systemd[1]: Starting Journal Service...
[    3.788426] systemd[1]: Started Journal Service.
[    3.788972] systemd[1]: Started udev Kernel Device Manager.
[    3.794931] systemd[1]: Started Remount Root and Kernel File Systems.
[    3.795451] systemd[1]: Started Apply Kernel Variables.
[    3.795621] systemd[1]: Mounted Huge Pages File System.
[    3.795811] systemd[1]: Mounted Debug File System.
[    3.795999] systemd[1]: systemd-modules-load.service: main process
exited, code=exited, status=1/FAILURE
[    3.818151] systemd[1]: Failed to start Load Kernel Modules.
[    3.819348] systemd[1]: Unit systemd-modules-load.service entered
failed state
[    3.837744] systemd[1]: Started Setup Virtual Console.
[    3.837865] systemd[1]: Mounted POSIX Message Queue File System.
[    3.837903] systemd[1]: Mounted Configuration File System.
[    3.837923] systemd[1]: Mounted FUSE Control File System.
[    3.837937] systemd[1]: Starting Local File Systems (Pre).
[    3.837946] systemd[1]: Reached target Local File Systems (Pre).
[    3.837957] systemd[1]: Mounting /tmp...
[    3.851606] input: Lid Switch as
/devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input1
[    3.852494] ACPI: Lid Switch [LID]
[    3.852556] input: Sleep Button as
/devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input2
[    3.852561] ACPI: Sleep Button [SLPB]
[    3.852601] input: Power Button as
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    3.852604] ACPI: Power Button [PWRF]
[    3.853784] ACPI: Requesting acpi_cpufreq
[    3.864109] mei 0000:00:16.0: setting latency timer to 64
[    3.864187] mei 0000:00:16.0: irq 46 for MSI/MSI-X
[    3.864921] thermal LNXTHERM:00: registered as thermal_zone0
[    3.864925] ACPI: Thermal Zone [THRM] (54 C)
[    3.865648] Linux agpgart interface v0.103
[    3.871202] mei 0000:00:16.0: wd: failed to find the client
[    3.872420] ACPI Warning: 0x00000428-0x0000042f SystemIO conflicts
with Region \GPIS 1 (20120913/utaddress-251)
[    3.872427] ACPI Warning: 0x00000428-0x0000042f SystemIO conflicts
with Region \PMIO 2 (20120913/utaddress-251)
[    3.872431] ACPI: If an ACPI driver is available for this device,
you should use it instead of the native driver
[    3.872435] ACPI Warning: 0x00000540-0x0000054f SystemIO conflicts
with Region \GPIO 1 (20120913/utaddress-251)
[    3.872438] ACPI: If an ACPI driver is available for this device,
you should use it instead of the native driver
[    3.872440] ACPI Warning: 0x00000530-0x0000053f SystemIO conflicts
with Region \GPIO 1 (20120913/utaddress-251)
[    3.872443] ACPI: If an ACPI driver is available for this device,
you should use it instead of the native driver
[    3.872445] ACPI Warning: 0x00000500-0x0000052f SystemIO conflicts
with Region \GPIO 1 (20120913/utaddress-251)
[    3.872448] ACPI: If an ACPI driver is available for this device,
you should use it instead of the native driver
[    3.872449] lpc_ich: Resource conflict(s) found affecting gpio_ich
[    3.872545] agpgart-intel 0000:00:00.0: Intel HD Graphics Chipset
[    3.872626] agpgart-intel 0000:00:00.0: detected gtt size: 2097152K
total, 262144K mappable
[    3.873228] agpgart-intel 0000:00:00.0: detected 32768K stolen memory
[    3.873421] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xb0000000
[    3.879794] jme: JMicron JMC2XX ethernet driver version 1.0.8
[    3.883090] jme 0000:07:00.5 eth0: JMC250 Gigabit Ethernet
chiprev:23 pcirev:3 macaddr:48:5b:39:65:b4:cf
[    3.885981] [drm] Initialized drm 1.1.0 20060810
[    3.899963] ACPI: Battery Slot [BAT0] (battery present)
[    3.900072] ACPI: AC Adapter [AC0] (on-line)
[    3.902204] wmi: Mapper loaded
[    3.902779] asus_laptop: Asus Laptop Support version 0.42
[    3.902915] asus_laptop: BSTS called, 0xb400 returned
[    3.903009] asus_laptop:   HWRS returned 80
[    3.903345] asus_laptop: Backlight controlled by ACPI video driver
[    3.903391] input: Asus Laptop extra buttons as
/devices/platform/asus_laptop/input/input4
[    3.911900] cfg80211: Calling CRDA to update world regulatory domain
[    3.918458] checking generic (b0000000 300000) vs hw (b0000000 10000000)
[    3.918465] fb: conflicting fb hw usage inteldrmfb vs VESA VGA -
removing generic driver
[    3.918494] Console: switching to colour dummy device 80x25
[    3.918821] i915 0000:00:02.0: setting latency timer to 64
[    3.926105] i915 0000:00:02.0: irq 47 for MSI/MSI-X
[    3.926115] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    3.926116] [drm] Driver supports precise vblank timestamp query.
[    3.928530] vgaarb: device changed decodes:
PCI:0000:00:02.0,olddecodes=io+mem,decodes=none:owns=io+mem
[    3.928533] vgaarb: transferring owner from PCI:0000:00:02.0 to
PCI:0000:01:00.0
[    3.966920] input: PC Speaker as /devices/platform/pcspkr/input/input5
[    3.969675] microcode: CPU0 sig=0x20652, pf=0x10, revision=0xc
[    3.990134] iTCO_vendor_support: vendor-support=0
[    3.990881] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
[    3.990922] iTCO_wdt: Found a HM55 TCO device (Version=2, TCOBASE=0x0460)
[    3.992815] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    3.992827] ath: EEPROM regdomain: 0x60
[    3.992829] ath: EEPROM indicates we should expect a direct regpair map
[    3.992832] ath: Country alpha2 being used: 00
[    3.992833] ath: Regpair used: 0x60
[    3.998053] ieee80211 phy0: Selected rate control algorithm
'ath9k_rate_control'
[    4.000375] Registered led device: ath9k-phy0
[    4.000386] ieee80211 phy0: Atheros AR9285 Rev:2 mem=0xf8de0000, irq=17
[    4.003019] microcode: CPU1 sig=0x20652, pf=0x10, revision=0xc
[    4.011017] microcode: CPU2 sig=0x20652, pf=0x10, revision=0xc
[    4.011744] microcode: CPU3 sig=0x20652, pf=0x10, revision=0xc
[    4.012278] microcode: Microcode Update Driver: v2.00
<tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    4.014759] Bluetooth: Core ver 2.16
[    4.014772] NET: Registered protocol family 31
[    4.014773] Bluetooth: HCI device and connection manager initialized
[    4.014780] Bluetooth: HCI socket layer initialized
[    4.014782] Bluetooth: L2CAP socket layer initialized
[    4.014786] Bluetooth: SCO socket layer initialized
[    4.017124] usbcore: registered new interface driver btusb
[    4.024887] kvm: VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL does not work
properly. Using workaround
[    4.119088] fbcon: inteldrmfb (fb0) is primary device
[    4.593822] EXT4-fs (sda6): mounted filesystem with ordered data
mode. Opts: data=ordered
[    4.599406] psmouse serio4: elantech: assuming hardware version 2
(with firmware version 0x040101)
[    4.627646] psmouse serio4: elantech: Synaptics capabilities query
result 0x7e, 0x13, 0x0d.
[    4.735259] input: ETPS/2 Elantech Touchpad as
/devices/platform/i8042/serio4/input/input6
[    4.823154] Console: switching to colour frame buffer device 170x48
[    4.830373] fb0: inteldrmfb frame buffer device
[    4.830374] drm: registered panic notifier
[    4.831289] ACPI Warning: _BQC returned an invalid level (20120913/video-486)
[    4.831581] acpi device:04: registered as cooling_device4
[    4.831612] ACPI: Video Device [GFX0] (multi-head: yes  rom: yes  post: no)
[    4.831713] input: Video Bus as
/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:01/LNXVIDEO:00/input/input7
[    4.833761] ACPI Warning: _BQC returned an invalid level (20120913/video-486)
[    4.834127] acpi device:4f: registered as cooling_device5
[    4.834354] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[    4.834389] input: Video Bus as
/devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:02/input/input8
[    4.834531] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    4.834637] snd_hda_intel 0000:00:1b.0: irq 48 for MSI/MSI-X
[    4.871004] input: HDA Digital PCBeep as
/devices/pci0000:00/0000:00:1b.0/input/input9
[    4.879509] input: HDA Intel MID HDMI/DP,pcm=3 as
/devices/pci0000:00/0000:00:1b.0/sound/card0/input10
[    4.879645] input: HDA Intel MID Mic as
/devices/pci0000:00/0000:00:1b.0/sound/card0/input11
[    4.879728] input: HDA Intel MID Headphone as
/devices/pci0000:00/0000:00:1b.0/sound/card0/input12
[    4.880046] intel ips 0000:00:1f.6: CPU TDP doesn't match expected
value (found 25, expected 29)
[    4.880351] intel ips 0000:00:1f.6: IPS driver initialized, MCP temp limit 90
[    5.532300] Adding 6264828k swap on /dev/sda7.  Priority:-1
extents:1 across:6264828k
[    5.670703] EXT4-fs (sda5): mounted filesystem with ordered data
mode. Opts: data=ordered
[    5.688571] systemd-journald[144]: Received SIGUSR1
[    6.013483] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    6.013497] Bluetooth: BNEP socket layer initialized
[    6.017732] Bluetooth: RFCOMM TTY layer initialized
[    6.017750] Bluetooth: RFCOMM socket layer initialized
[    6.017751] Bluetooth: RFCOMM ver 1.11
[    6.169476] systemd-logind[334]: Watching system buttons on
/dev/input/event3 (Power Button)
[    6.169577] systemd-logind[334]: Watching system buttons on
/dev/input/event8 (Video Bus)
[    6.169674] systemd-logind[334]: Watching system buttons on
/dev/input/event7 (Video Bus)
[    6.169765] systemd-logind[334]: Watching system buttons on
/dev/input/event1 (Lid Switch)
[    6.169856] systemd-logind[334]: Watching system buttons on
/dev/input/event2 (Sleep Button)
[    6.411377] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[    6.417797] jme 0000:07:00.5: irq 49 for MSI/MSI-X
[    6.440793] jme 0000:07:00.5 eth0: Link is down
[    6.440816] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[    6.572926] EXT4-fs (sdb1): re-mounted. Opts: data=ordered,discard,commit=0
[    7.924280] EXT4-fs (sda6): re-mounted. Opts: data=ordered,commit=0
[    8.115096] EXT4-fs (sda5): re-mounted. Opts: data=ordered,commit=0
[    8.577305] wlan0: authenticate with 08:10:74:98:9f:ca
[    8.590952] wlan0: send auth to 08:10:74:98:9f:ca (try 1/3)
[    8.592456] wlan0: authenticated
[    8.593252] wlan0: associate with 08:10:74:98:9f:ca (try 1/3)
[    8.595640] wlan0: RX AssocResp from 08:10:74:98:9f:ca (capab=0x411
status=0 aid=1)
[    8.595714] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[    8.595772] wlan0: associated
[   20.273496] fuse init (API version 7.20)
[   21.360350] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[   21.360363] Bluetooth: HIDP socket layer initialized
[   21.362069] hid-generic 0005:046D:B008.0001: unknown main item tag 0x0
[   21.362195] input: Bluetooth Laser Travel Mouse as
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.2/2-1.2:1.0/bluetooth/hci0/hci0:42/input13
[   21.362522] hid-generic 0005:046D:B008.0001: input,hidraw0:
BLUETOOTH HID v3.18 Mouse [Bluetooth Laser Travel Mouse] on
00:15:83:3D:0A:57
[   22.322584] bbswitch: version 0.5
[   22.322592] bbswitch: Found integrated VGA device 0000:00:02.0:
\_SB_.PCI0.GFX0
[   22.322598] bbswitch: Found discrete VGA device 0000:01:00.0:
\_SB_.PCI0.PEG1.GFX0
[   22.322705] bbswitch: detected an Optimus _DSM function
[   22.322712] bbswitch: disabling discrete graphics
[   22.332951] pci 0000:01:00.0: Refused to change power state, currently in D0
[   22.526009] pci 0000:01:00.0: power state changed by ACPI to D3cold
[   22.526018] bbswitch: Succesfully loaded. Discrete card 0000:01:00.0 is off

2012/12/31 Borislav Petkov <bp@alien8.de>:
> On Mon, Dec 31, 2012 at 02:42:07AM +0800, Du Jiulun wrote:
>> CPU 2: Machine Check Exception: 4 Bank 2: b200000000000005
>> TSC 6568f53a1cee
>> HARDWARE ERROR. This is *NOT* a software problem!
>> Please contact your hardware vendor
>> CPU 2 BANK 2 TSC 6568f53a1cee
>> TIME 1356717945 Sat Dec 29 02:05:45 2012
>> STATUS b200000000000005 MCGSTATUS 4
>> PROCESSOR 0:20652 TIME 1356717945 SOCKET 0 APIC 1 microcode c
>> Run the above through 'mcelog --ascii'
>> CPU 0: Machine Check Exception: 4 Bank 2: b200000000000005
>> TSC 6568f53a1cfc
>> HARDWARE ERROR. This is *NOT* a software problem!
>> Please contact your hardware vendor
>> CPU 0 BANK 2 TSC 6568f53a1cfc
>> TIME 1356717945 Sat Dec 29 02:05:45 2012
>> STATUS b200000000000005 MCGSTATUS 4
>> PROCESSOR 0:20652 TIME 1356717945 SOCKET 0 APIC 0 microcode c
>> Run the above through 'mcelog --ascii'
>> Machine check: Processor context corrupt
>>
>> It seems that nothing much has come up except those already there.
>
> I had to build the latest mcelog from kernel.org and it tells you a
> little bit more: it is an internal parity error. I don't know, though,
> what errors reported in bank 2 pertain to on this cpu model - Intel
> should know :).
>
> CPU 2 BANK 2 TSC 6568f53a1cee
> TIME 1356717945 Fri Dec 28 19:05:45 2012
> MCG status:MCIP
> MCi status:
> Uncorrected error
> Error enabled
> Processor context corrupt
> MCA: Internal parity error
> STATUS b200000000000005 MCGSTATUS 4
> CPUID Vendor Intel Family 6 Model 37
> SOCKET 0 APIC 1 microcode c
> Run the above through 'mcelog --ascii'
> CPU 0 BANK 2 TSC 6568f53a1cfc
> TIME 1356717945 Fri Dec 28 19:05:45 2012
> MCG status:MCIP
> MCi status:
> Uncorrected error
> Error enabled
> Processor context corrupt
> MCA: Internal parity error
> STATUS b200000000000005 MCGSTATUS 4
> CPUID Vendor Intel Family 6 Model 37
> SOCKET 0 APIC 0 microcode c
> Run the above through 'mcelog --ascii'
> Machine check: Processor context corrupt
>
> Question: is this easily reproducible or only sporadic and has happened
> only twice up 'til now?
>
>> Since there's something about hardware error, I've got these message
>> in *bold* in my booting log: (from "sudo journalctl --line=5000",
>> don't know if relevant, sorry if not)
>
> Nah, those are your ACPI tables.
>
>> ACPI: RSDP 000f0410 00024 (v02 _ASUS_)
>> ACPI: XSDT aada5e18 0006C (v01 _ASUS_ Notebook 06222004 MSFT 00010013)
>> ACPI: FACP aad81c18 000F4 (v04 _ASUS_ Notebook 06222004 MSFT 00010013)
>> ACPI Warning: 32/64 FACS address mismatch in FADT - two FACS tables!
>> (20120711/tbfadt-394)
>> ACPI BIOS Bug: Warning: 32/64X FACS address mismatch in FADT -
>> 0xAADB7F40/0x00000000AADD1D40, using 32 (20120711/tbfadt-521)
>
> Yet another BIOS f*ckup. Oh well, it should be unrelated.
>
>> ACPI: DSDT aad44018 13C72 (v01 _ASUS_ Notebook 00000000 INTL 20051117)
>> ACPI: FACS aadb7f40 00040
>> ACPI: APIC aada4f18 0008C (v02 _ASUS_ Notebook 06222004 MSFT 00010013)
>> ACPI: DBGP aada6f18 00034 (v01 _ASUS_ Notebook 06222004 MSFT 00010013)
>> ACPI: ECDT aadd1b18 000C1 (v01 _ASUS_ Notebook 06222004 AMI. 00000003)
>> ACPI: SLIC aadb2c18 00176 (v01 _ASUS_ Notebook 06222004 ASUS 00000001)
>> ACPI: MCFG aadd0d18 0003C (v01 _ASUS_ Notebook 06222004 MSFT 00000097)
>> ACPI: HPET aadd0c98 00038 (v01 _ASUS_ Notebook 06222004 AMI. 00000003)
>> ACPI: SSDT aad9f018 009F1 (v01  PmRef    CpuPm 00003000 INTL 20051117)
>> ACPI: DMAR aad81f18 000B8 (v01 INTEL  CP_DALE  00000001 INTL 00000001)
>>
>> perf_event_intel: CPUID marked event: 'bus cycles' unavailable
>>
>> mtrr: your CPUs had inconsistent variable MTRR settings
>
> Yep, more BIOS f*ckup. By the look of it, I wouldn't wonder if BIOS is
> misprogramming something and causing those MCEs.
>
> By the way, can you boot vanilla 3.7 and send the _whole_ dmesg?
>
> Thanks.
>
> --
> Regards/Gruss,
> Boris.

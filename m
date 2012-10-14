Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752349Ab2JNKUe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 06:20:34 -0400
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:5795 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634Ab2JNKU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 06:20:29 -0400
X-Authority-Analysis: v=2.0 cv=Dp3UCRD+ c=1 sm=0 a=YPDeGStqRoQnMAluW+pq4Q==:17 a=65KWcu232dMA:10 a=h9GbcFHyNoYA:10 a=g7R6esmICIkA:10 a=05ChyHeVI94A:10 a=ayC55rCoAAAA:8 a=HjRi3UqH30YA:10 a=qSDvMwW7-tzSFnADCOQA:9 a=wPNLvfGTeEIA:10 a=pSDxxfrZAAAA:8 a=dfuNlseZDH8ydF-uIl4A:9 a=QEXdDO2ut3YA:10 a=KMhn6qg2jGauWO7H:21 a=xrqcru0uKEZe1oxy:21 a=wJA3Mb_CUL-XE5Se:21 a=YPDeGStqRoQnMAluW+pq4Q==:117
X-Cloudmark-Score: 0
X-Originating-IP: 50.89.247.146
Message-ID: <507A91EA.2030205@cfl.rr.com>
Date: Sun, 14 Oct 2012 06:20:26 -0400
From: Mark Hounschell <dmarkh@cfl.rr.com>
Reply-To: dmarkh@cfl.rr.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: Daniel Vetter <daniel@ffwll.ch>
CC: markh@compro.net,
        =?ISO-8859-1?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [Intel-gfx] Intel graphics drm issue?
References: <507812E8.3060607@compro.net> <20121012231459.166e29fd@neptune.home> <5079B97C.7020401@cfl.rr.com> <5079BE5C.8020401@cfl.rr.com> <CAKMK7uGXb5=fHXZa8m_0xNLGFqyf_b37g9W32eshaPFcf8i=7A@mail.gmail.com>
In-Reply-To: <CAKMK7uGXb5=fHXZa8m_0xNLGFqyf_b37g9W32eshaPFcf8i=7A@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------080801040306040503040104"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080801040306040503040104
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 10/14/2012 04:58 AM, Daniel Vetter wrote:
> On Sat, Oct 13, 2012 at 9:17 PM, Mark Hounschell <dmarkh@cfl.rr.com> wrote:
>> One other thing I failed to mention. If i connect the TV HDMI to the Intel
>> boards DVI port using the adapter, at power up I get all the BIOS messages
>> and can enter the BIOS and all is fine. But when I let it boot all the way
>> up like this, I get nothing but "no signal" after leaving BIOS mode. Turning
>> the tv on/off, cable plug/unplug does not help.
>
> Can you please boot in that configuration on latest kernel with
> drm.debug=0xe added to your kernel cmdline and then attach the
> complete dmesg?

Hi Daniel,

cat /proc/cmdline
root=/dev/disk/by-id/ata-INTEL_SSDSC2CW060A3_CVCV205106EB060AGN-part4 
video=1024x768 noresume splash=silent quiet apm=off nomodeset vga=normal 
drm.debug=0xe

dmesg is attached

Mark

--------------080801040306040503040104
Content-Type: text/plain; charset=UTF-8;
 name="dmesg-intel-dvi2hdmi-3.6.2"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg-intel-dvi2hdmi-3.6.2"

[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.6.2 (root@geexbox) (gcc version 4.7.1 20120723 [gcc-4_7-branch revision 189773] (SUSE Linux) ) #1 SMP PREEMPT Sun Oct 14 02:03:31 EDT 2012
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   NSC Geode by NSC
[    0.000000]   Cyrix CyrixInstead
[    0.000000]   Centaur CentaurHauls
[    0.000000]   Transmeta GenuineTMx86
[    0.000000]   Transmeta TransmetaCPU
[    0.000000]   UMC UMC UMC UMC
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009d7ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009d800-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001fffffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000020000000-0x00000000201fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000020200000-0x0000000040003fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000040004000-0x0000000040004fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000040005000-0x00000000d9e5efff] usable
[    0.000000] BIOS-e820: [mem 0x00000000d9e5f000-0x00000000da25afff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000da25b000-0x00000000da266fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000da267000-0x00000000da2f2fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000da2f3000-0x00000000da2f8fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000da2f9000-0x00000000da37afff] usable
[    0.000000] BIOS-e820: [mem 0x00000000da37b000-0x00000000da40cfff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000da40d000-0x00000000da6a2fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000da6a3000-0x00000000da6a3fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000da6a4000-0x00000000da6e6fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000da6e7000-0x00000000daffffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000db800000-0x00000000df9fffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed03fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000021f5fffff] usable
[    0.000000] Notice: NX (Execute Disable) protection missing in CPU!
[    0.000000] DMI 2.7 present.
[    0.000000] DMI:                  /DH77DF, BIOS KCH7710H.86A.0095.2012.0608.1754 06/08/2012
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0xdb000 max_arch_pfn = 0x100000
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
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: update [mem 0xdb800000-0xffffffff] usable ==> reserved
[    0.000000] found SMP MP-table at [mem 0x000fd770-0x000fd77f] mapped at [c00fd770]
[    0.000000] initial memory mapped: [mem 0x00000000-0x00bfffff]
[    0.000000] Base memory trampoline at [c0099000] 99000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x377fdfff]
[    0.000000]  [mem 0x00000000-0x003fffff] page 4k
[    0.000000]  [mem 0x00400000-0x373fffff] page 2M
[    0.000000]  [mem 0x37400000-0x377fdfff] page 4k
[    0.000000] kernel direct mapping tables up to 0x377fdfff @ [mem 0x00bfa000-0x00bfffff]
[    0.000000] RAMDISK: [mem 0x1e6bb000-0x1ffeffff]
[    0.000000] ACPI: RSDP 000f0490 00024 (v02  INTEL)
[    0.000000] ACPI: XSDT da25b070 00064 (v01 INTEL  DH77DF   0000005F AMI  00010013)
[    0.000000] ACPI: FACP da264db8 000F4 (v04 INTEL  DH77DF   0000005F AMI  00010013)
[    0.000000] ACPI: DSDT da25b168 09C49 (v02 INTEL  DH77DF   0000005F INTL 20051117)
[    0.000000] ACPI: FACS da40bf80 00040
[    0.000000] ACPI: APIC da264eb0 00072 (v03 INTEL  DH77DF   0000005F AMI  00010013)
[    0.000000] ACPI: FPDT da264f28 00044 (v01 INTEL  DH77DF   0000005F AMI  00010013)
[    0.000000] ACPI: MCFG da264f70 0003C (v01 INTEL  DH77DF   0000005F MSFT 00000097)
[    0.000000] ACPI: HPET da264fb0 00038 (v01 INTEL  DH77DF   0000005F AMI. 00000005)
[    0.000000] ACPI: SSDT da264fe8 0036D (v01 INTEL  DH77DF   0000005F INTL 20091112)
[    0.000000] ACPI: SSDT da265358 009AA (v01 INTEL  DH77DF   0000005F INTL 20051117)
[    0.000000] ACPI: SSDT da265d08 00A92 (v01 INTEL  DH77DF   0000005F INTL 20051117)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 2616MB HIGHMEM available.
[    0.000000] 887MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 377fe000
[    0.000000]   low ram: 0 - 377fe000
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x377fdfff]
[    0.000000]   HighMem  [mem 0x377fe000-0xdaffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x0009cfff]
[    0.000000]   node   0: [mem 0x00100000-0x1fffffff]
[    0.000000]   node   0: [mem 0x20200000-0x40003fff]
[    0.000000]   node   0: [mem 0x40005000-0xd9e5efff]
[    0.000000]   node   0: [mem 0xda2f9000-0xda37afff]
[    0.000000]   node   0: [mem 0xda6a3000-0xda6a3fff]
[    0.000000]   node   0: [mem 0xda6e7000-0xdaffffff]
[    0.000000] On node 0 totalpages: 894343
[    0.000000] free_area_init_node: node 0, pgdat c0894340, node_mem_map f5c9d200
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
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009d000 - 000000000009e000
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 0000000020000000 - 0000000020200000
[    0.000000] e820: [mem 0xdfa00000-0xf7ffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 12 pages/cpu @f5c5b000 s26944 r0 d22208 u49152
[    0.000000] pcpu-alloc: s26944 r0 d22208 u49152 alloc=12*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 887334
[    0.000000] Kernel command line: root=/dev/disk/by-id/ata-INTEL_SSDSC2CW060A3_CVCV205106EB060AGN-part4 video=1024x768 noresume splash=silent quiet apm=off nomodeset vga=normal drm.debug=0xe
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Initializing CPU#0
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Initializing HighMem for node 0 (000377fe:000db000)
[    0.000000] Memory: 3514632k/3588096k available (4577k kernel code, 62740k reserved, 2220k data, 452k init, 2670576k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff16000 - 0xfffff000   ( 932 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
[    0.000000]       .init : 0xc08a4000 - 0xc0915000   ( 452 kB)
[    0.000000]       .data : 0xc0678452 - 0xc08a3800   (2220 kB)
[    0.000000]       .text : 0xc0200000 - 0xc0678452   (4577 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	Dump stacks of tasks blocking RCU-preempt GP.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=8 to nr_cpu_ids=4.
[    0.000000] NR_IRQS:2304 nr_irqs:712 16
[    0.000000] CPU 0 irqstacks, hard=f5408000 soft=f540a000
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.003333] tsc: Detected 3392.341 MHz processor
[    0.000000] Calibrating delay loop (skipped), value calculated using timer frequency.. 6787.37 BogoMIPS (lpj=11307803)
[    0.000002] pid_max: default: 32768 minimum: 301
[    0.000015] Security Framework initialized
[    0.000024] AppArmor: AppArmor initialized
[    0.000029] Mount-cache hash table entries: 512
[    0.000135] Initializing cgroup subsys net_cls
[    0.000136] Initializing cgroup subsys blkio
[    0.000153] CPU: Physical Processor ID: 0
[    0.000153] CPU: Processor Core ID: 0
[    0.000156] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.000156] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.000678] mce: CPU supports 9 MCE banks
[    0.000688] CPU0: Thermal monitoring enabled (TM1)
[    0.000694] process: using mwait in idle threads
[    0.000698] Last level iTLB entries: 4KB 512, 2MB 0, 4MB 0
[    0.000698] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32
[    0.000698] tlb_flushall_shift is 0x1
[    0.001269] ACPI: Core revision 20120711
[    0.007300] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.007721] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.040630] smpboot: CPU0: Intel(R) Core(TM) i5-3570K CPU @ 3.40GHz stepping 09
[    0.143703] Performance Events: PEBS fmt1+, 16-deep LBR, IvyBridge events, Intel PMU driver.
[    0.143707] ... version:                3
[    0.143708] ... bit width:              48
[    0.143708] ... generic registers:      8
[    0.143709] ... value mask:             0000ffffffffffff
[    0.143710] ... max period:             000000007fffffff
[    0.143710] ... fixed-purpose events:   3
[    0.143711] ... event mask:             00000007000000ff
[    0.190242] CPU 1 irqstacks, hard=f54b0000 soft=f54b2000
[    0.200466] Initializing CPU#1
[    0.190244] smpboot: Booting Node   0, Processors  #1
[    0.216831] CPU 2 irqstacks, hard=f54c6000 soft=f54c8000
[    0.227102] Initializing CPU#2
[    0.216835]  #2
[    0.243420] CPU 3 irqstacks, hard=f54e0000 soft=f54e2000
[    0.243424]  #3 OK
[    0.253691] Initializing CPU#3
[    0.257128] Brought up 4 CPUs
[    0.257130] smpboot: Total of 4 processors activated (27149.50 BogoMIPS)
[    0.259607] devtmpfs: initialized
[    0.259771] PM: Registering ACPI NVS region [mem 0xda37b000-0xda40cfff] (598016 bytes)
[    0.259776] PM: Registering ACPI NVS region [mem 0xda6a4000-0xda6e6fff] (274432 bytes)
[    0.259829] dummy: 
[    0.259858] RTC time:  6:13:57, date: 10/14/12
[    0.259882] NET: Registered protocol family 16
[    0.296711] ACPI: bus type pci registered
[    0.296756] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.296758] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.296758] PCI: Using MMCONFIG for extended config space
[    0.296759] PCI: Using configuration type 1 for base access
[    0.297209] bio: create slab <bio-0> at 0
[    0.297245] ACPI: Added _OSI(Module Device)
[    0.297246] ACPI: Added _OSI(Processor Device)
[    0.297247] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.297248] ACPI: Added _OSI(Processor Aggregator Device)
[    0.298575] ACPI: EC: Look up EC in DSDT
[    0.300091] ACPI: Executed 1 blocks of module-level executable AML code
[    0.310621] ACPI: SSDT da293018 0083B (v01  PmRef  Cpu0Cst 00003001 INTL 20051117)
[    0.310957] ACPI: Dynamic OEM Table Load:
[    0.310959] ACPI: SSDT   (null) 0083B (v01  PmRef  Cpu0Cst 00003001 INTL 20051117)
[    0.320084] ACPI: SSDT da294a98 00303 (v01  PmRef    ApIst 00003000 INTL 20051117)
[    0.320451] ACPI: Dynamic OEM Table Load:
[    0.320452] ACPI: SSDT   (null) 00303 (v01  PmRef    ApIst 00003000 INTL 20051117)
[    0.330241] ACPI: SSDT da299c18 00119 (v01  PmRef    ApCst 00003000 INTL 20051117)
[    0.330579] ACPI: Dynamic OEM Table Load:
[    0.330580] ACPI: SSDT   (null) 00119 (v01  PmRef    ApCst 00003000 INTL 20051117)
[    0.340737] ACPI: Interpreter enabled
[    0.340743] ACPI: (supports S0 S3 S4 S5)
[    0.340754] ACPI: Using IOAPIC for interrupt routing
[    0.344718] ACPI: Power Resource [FN00] (off)
[    0.344768] ACPI: Power Resource [FN01] (off)
[    0.344815] ACPI: Power Resource [FN02] (off)
[    0.344863] ACPI: Power Resource [FN03] (off)
[    0.344910] ACPI: Power Resource [FN04] (off)
[    0.345269] ACPI: No dock devices found.
[    0.345272] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.345505] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
[    0.345835] PCI host bridge to bus 0000:00
[    0.345837] pci_bus 0000:00: busn_res: [bus 00-3e] is inserted under domain [bus 00-ff]
[    0.345838] pci_bus 0000:00: root bus resource [bus 00-3e]
[    0.345840] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.345841] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.345842] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.345843] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3fff]
[    0.345844] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
[    0.345845] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
[    0.345846] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff]
[    0.345847] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000e3fff]
[    0.345848] pci_bus 0000:00: root bus resource [mem 0x000e4000-0x000e7fff]
[    0.345849] pci_bus 0000:00: root bus resource [mem 0xdfa00000-0xfeafffff]
[    0.345855] pci 0000:00:00.0: [8086:0150] type 00 class 0x060000
[    0.345885] pci 0000:00:01.0: [8086:0151] type 01 class 0x060400
[    0.345907] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.345924] pci 0000:00:02.0: [8086:0162] type 00 class 0x030000
[    0.345932] pci 0000:00:02.0: reg 10: [mem 0xf7800000-0xf7bfffff 64bit]
[    0.345936] pci 0000:00:02.0: reg 18: [mem 0xe0000000-0xefffffff 64bit pref]
[    0.345939] pci 0000:00:02.0: reg 20: [io  0xf000-0xf03f]
[    0.345983] pci 0000:00:14.0: [8086:1e31] type 00 class 0x0c0330
[    0.346003] pci 0000:00:14.0: reg 10: [mem 0xf7d20000-0xf7d2ffff 64bit]
[    0.346067] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    0.346088] pci 0000:00:16.0: [8086:1e3a] type 00 class 0x078000
[    0.346109] pci 0000:00:16.0: reg 10: [mem 0xf7d37000-0xf7d3700f 64bit]
[    0.346180] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.346207] pci 0000:00:19.0: [8086:1503] type 00 class 0x020000
[    0.346223] pci 0000:00:19.0: reg 10: [mem 0xf7d00000-0xf7d1ffff]
[    0.346231] pci 0000:00:19.0: reg 14: [mem 0xf7d35000-0xf7d35fff]
[    0.346239] pci 0000:00:19.0: reg 18: [io  0xf080-0xf09f]
[    0.346296] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.346317] pci 0000:00:1a.0: [8086:1e2d] type 00 class 0x0c0320
[    0.346336] pci 0000:00:1a.0: reg 10: [mem 0xf7d34000-0xf7d343ff]
[    0.346418] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.346445] pci 0000:00:1c.0: [8086:1e10] type 01 class 0x060400
[    0.346575] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.346612] pci 0000:00:1c.7: [8086:1e1e] type 01 class 0x060400
[    0.346683] pci 0000:00:1c.7: PME# supported from D0 D3hot D3cold
[    0.346708] pci 0000:00:1d.0: [8086:1e26] type 00 class 0x0c0320
[    0.346727] pci 0000:00:1d.0: reg 10: [mem 0xf7d33000-0xf7d333ff]
[    0.346810] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.346832] pci 0000:00:1f.0: [8086:1e4a] type 00 class 0x060100
[    0.346948] pci 0000:00:1f.2: [8086:1e02] type 00 class 0x010601
[    0.346964] pci 0000:00:1f.2: reg 10: [io  0xf0d0-0xf0d7]
[    0.346972] pci 0000:00:1f.2: reg 14: [io  0xf0c0-0xf0c3]
[    0.346979] pci 0000:00:1f.2: reg 18: [io  0xf0b0-0xf0b7]
[    0.346986] pci 0000:00:1f.2: reg 1c: [io  0xf0a0-0xf0a3]
[    0.346993] pci 0000:00:1f.2: reg 20: [io  0xf060-0xf07f]
[    0.347001] pci 0000:00:1f.2: reg 24: [mem 0xf7d32000-0xf7d327ff]
[    0.347041] pci 0000:00:1f.2: PME# supported from D3hot
[    0.347056] pci 0000:00:1f.3: [8086:1e22] type 00 class 0x0c0500
[    0.347069] pci 0000:00:1f.3: reg 10: [mem 0xf7d31000-0xf7d310ff 64bit]
[    0.347088] pci 0000:00:1f.3: reg 20: [io  0xf040-0xf05f]
[    0.347126] pci_bus 0000:01: busn_res: [bus 01-02] is inserted under [bus 00-3e]
[    0.347143] pci 0000:01:00.0: [10b5:8112] type 01 class 0x060400
[    0.347248] pci 0000:01:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.347256] pci 0000:00:01.0: PCI bridge to [bus 01-02]
[    0.347258] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    0.347304] pci_bus 0000:02: busn_res: [bus 02] is inserted under [bus 01-02]
[    0.347324] pci 0000:02:04.0: [13f6:8788] type 00 class 0x040100
[    0.347347] pci 0000:02:04.0: reg 10: [io  0xe000-0xe0ff]
[    0.347457] pci 0000:02:04.0: supports D1 D2
[    0.347509] pci 0000:01:00.0: PCI bridge to [bus 02]
[    0.347513] pci 0000:01:00.0:   bridge window [io  0xe000-0xefff]
[    0.347595] pci_bus 0000:03: busn_res: [bus 03] is inserted under [bus 00-3e]
[    0.347598] pci 0000:00:1c.0: PCI bridge to [bus 03]
[    0.347650] pci_bus 0000:04: busn_res: [bus 04] is inserted under [bus 00-3e]
[    0.347653] pci 0000:00:1c.7: PCI bridge to [bus 04]
[    0.347657] pci 0000:00:1c.7:   bridge window [io  0xd000-0xdfff]
[    0.347660] pci 0000:00:1c.7:   bridge window [mem 0xf7c00000-0xf7cfffff]
[    0.347679] pci_bus 0000:00: on NUMA node 0
[    0.347680] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.347768] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.347796] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP08._PRT]
[    0.347818] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEG0._PRT]
[    0.347909]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.348047]  pci0000:00: ACPI _OSC control (0x18) granted
[    0.350903] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.350940] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.350978] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 *4 5 6 10 11 12 14 15)
[    0.351015] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 *10 11 12 14 15)
[    0.351049] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 10 11 12 14 15)
[    0.351086] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.351122] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.351156] ACPI: PCI Interrupt Link [LNKH] (IRQs *3 4 5 6 10 11 12 14 15)
[    0.351195] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.351198] vgaarb: loaded
[    0.351198] vgaarb: bridge control possible 0000:00:02.0
[    0.351256] SCSI subsystem initialized
[    0.351258] ACPI: bus type scsi registered
[    0.351274] libata version 3.00 loaded.
[    0.351284] ACPI: bus type usb registered
[    0.351293] usbcore: registered new interface driver usbfs
[    0.351298] usbcore: registered new interface driver hub
[    0.351309] usbcore: registered new device driver usb
[    0.351335] PCI: Using ACPI for IRQ routing
[    0.352703] PCI: pci_cache_line_size set to 64 bytes
[    0.352751] e820: reserve RAM buffer [mem 0x0009d800-0x0009ffff]
[    0.352753] e820: reserve RAM buffer [mem 0x40004000-0x43ffffff]
[    0.352754] e820: reserve RAM buffer [mem 0xd9e5f000-0xdbffffff]
[    0.352755] e820: reserve RAM buffer [mem 0xda37b000-0xdbffffff]
[    0.352757] e820: reserve RAM buffer [mem 0xda6a4000-0xdbffffff]
[    0.352758] e820: reserve RAM buffer [mem 0xdb000000-0xdbffffff]
[    0.352808] NetLabel: Initializing
[    0.352809] NetLabel:  domain hash size = 128
[    0.352810] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.352815] NetLabel:  unlabeled traffic allowed by default
[    0.352864] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.352868] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.354876] Switching to clocksource hpet
[    0.354917] AppArmor: AppArmor Filesystem Enabled
[    0.354924] pnp: PnP ACPI init
[    0.354929] ACPI: bus type pnp registered
[    0.355110] pnp 00:00: [bus 00-3e]
[    0.355112] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.355113] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.355114] pnp 00:00: [io  0x0d00-0xffff window]
[    0.355115] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.355116] pnp 00:00: [mem 0x000c0000-0x000c3fff window]
[    0.355118] pnp 00:00: [mem 0x000c4000-0x000c7fff window]
[    0.355119] pnp 00:00: [mem 0x000c8000-0x000cbfff window]
[    0.355120] pnp 00:00: [mem 0x000cc000-0x000cffff window]
[    0.355121] pnp 00:00: [mem 0x000d0000-0x000d3fff window]
[    0.355122] pnp 00:00: [mem 0x000d4000-0x000d7fff window]
[    0.355124] pnp 00:00: [mem 0x000d8000-0x000dbfff window]
[    0.355125] pnp 00:00: [mem 0x000dc000-0x000dffff window]
[    0.355126] pnp 00:00: [mem 0x000e0000-0x000e3fff window]
[    0.355127] pnp 00:00: [mem 0x000e4000-0x000e7fff window]
[    0.355128] pnp 00:00: [mem 0x000e8000-0x000ebfff window]
[    0.355129] pnp 00:00: [mem 0x000ec000-0x000effff window]
[    0.355130] pnp 00:00: [mem 0x000f0000-0x000fffff window]
[    0.355131] pnp 00:00: [mem 0xdfa00000-0xfeafffff window]
[    0.355132] pnp 00:00: [mem 0x00010000-0x0001ffff window]
[    0.355163] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    0.355179] pnp 00:01: [mem 0xfed40000-0xfed44fff]
[    0.355196] system 00:01: [mem 0xfed40000-0xfed44fff] has been reserved
[    0.355198] system 00:01: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.355205] pnp 00:02: [io  0x0000-0x001f]
[    0.355206] pnp 00:02: [io  0x0081-0x0091]
[    0.355207] pnp 00:02: [io  0x0093-0x009f]
[    0.355208] pnp 00:02: [io  0x00c0-0x00df]
[    0.355209] pnp 00:02: [dma 4]
[    0.355220] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.355225] pnp 00:03: [mem 0xff000000-0xffffffff]
[    0.355235] pnp 00:03: Plug and Play ACPI device, IDs INT0800 (active)
[    0.355289] pnp 00:04: [mem 0xfed00000-0xfed003ff]
[    0.355301] pnp 00:04: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.355308] pnp 00:05: [io  0x002e-0x002f]
[    0.355309] pnp 00:05: [io  0x004e-0x004f]
[    0.355310] pnp 00:05: [io  0x0061]
[    0.355311] pnp 00:05: [io  0x0063]
[    0.355312] pnp 00:05: [io  0x0065]
[    0.355313] pnp 00:05: [io  0x0067]
[    0.355314] pnp 00:05: [io  0x0070]
[    0.355315] pnp 00:05: [io  0x0080]
[    0.355316] pnp 00:05: [io  0x0092]
[    0.355317] pnp 00:05: [io  0x00b2-0x00b3]
[    0.355318] pnp 00:05: [io  0x0680-0x069f]
[    0.355319] pnp 00:05: [io  0x1000-0x100f]
[    0.355320] pnp 00:05: [io  0xffff]
[    0.355321] pnp 00:05: [io  0xffff]
[    0.355322] pnp 00:05: [io  0x0400-0x0453]
[    0.355323] pnp 00:05: [io  0x0458-0x047f]
[    0.355324] pnp 00:05: [io  0x0500-0x057f]
[    0.355325] pnp 00:05: [io  0x164e-0x164f]
[    0.355345] system 00:05: [io  0x0680-0x069f] has been reserved
[    0.355346] system 00:05: [io  0x1000-0x100f] has been reserved
[    0.355347] system 00:05: [io  0xffff] has been reserved
[    0.355348] system 00:05: [io  0xffff] has been reserved
[    0.355350] system 00:05: [io  0x0400-0x0453] has been reserved
[    0.355351] system 00:05: [io  0x0458-0x047f] has been reserved
[    0.355352] system 00:05: [io  0x0500-0x057f] has been reserved
[    0.355353] system 00:05: [io  0x164e-0x164f] has been reserved
[    0.355355] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.355359] pnp 00:06: [io  0x0070-0x0077]
[    0.355367] pnp 00:06: [irq 8]
[    0.355378] pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.355395] pnp 00:07: [io  0x0454-0x0457]
[    0.355412] system 00:07: [io  0x0454-0x0457] has been reserved
[    0.355414] system 00:07: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
[    0.355468] pnp 00:08: [io  0x0000-0xffffffff disabled]
[    0.355469] pnp 00:08: [io  0x0a30-0x0a3f]
[    0.355471] pnp 00:08: [io  0x0000-0xffffffff disabled]
[    0.355472] pnp 00:08: [io  0x0250-0x025f]
[    0.355489] system 00:08: [io  0x0a30-0x0a3f] has been reserved
[    0.355490] system 00:08: [io  0x0250-0x025f] has been reserved
[    0.355491] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.355527] pnp 00:09: [io  0x0010-0x001f]
[    0.355529] pnp 00:09: [io  0x0022-0x003f]
[    0.355529] pnp 00:09: [io  0x0044-0x005f]
[    0.355530] pnp 00:09: [io  0x0062-0x0063]
[    0.355531] pnp 00:09: [io  0x0065-0x006f]
[    0.355532] pnp 00:09: [io  0x0072-0x007f]
[    0.355533] pnp 00:09: [io  0x0080]
[    0.355534] pnp 00:09: [io  0x0084-0x0086]
[    0.355535] pnp 00:09: [io  0x0088]
[    0.355536] pnp 00:09: [io  0x008c-0x008e]
[    0.355537] pnp 00:09: [io  0x0090-0x009f]
[    0.355538] pnp 00:09: [io  0x00a2-0x00bf]
[    0.355539] pnp 00:09: [io  0x00e0-0x00ef]
[    0.355540] pnp 00:09: [io  0x04d0-0x04d1]
[    0.355560] system 00:09: [io  0x04d0-0x04d1] has been reserved
[    0.355562] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.355567] pnp 00:0a: [io  0x00f0-0x00ff]
[    0.355574] pnp 00:0a: [irq 13]
[    0.355586] pnp 00:0a: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.355762] pnp 00:0b: [mem 0xfed1c000-0xfed1ffff]
[    0.355763] pnp 00:0b: [mem 0xfed10000-0xfed17fff]
[    0.355764] pnp 00:0b: [mem 0xfed18000-0xfed18fff]
[    0.355765] pnp 00:0b: [mem 0xfed19000-0xfed19fff]
[    0.355766] pnp 00:0b: [mem 0xf8000000-0xfbffffff]
[    0.355767] pnp 00:0b: [mem 0xfed20000-0xfed3ffff]
[    0.355768] pnp 00:0b: [mem 0xfed90000-0xfed93fff]
[    0.355769] pnp 00:0b: [mem 0xfed45000-0xfed8ffff]
[    0.355770] pnp 00:0b: [mem 0xff000000-0xffffffff]
[    0.355771] pnp 00:0b: [mem 0xfee00000-0xfeefffff]
[    0.355772] pnp 00:0b: [mem 0xdfa00000-0xdfa00fff]
[    0.355804] system 00:0b: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.355805] system 00:0b: [mem 0xfed10000-0xfed17fff] has been reserved
[    0.355806] system 00:0b: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.355808] system 00:0b: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.355809] system 00:0b: [mem 0xf8000000-0xfbffffff] has been reserved
[    0.355810] system 00:0b: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.355811] system 00:0b: [mem 0xfed90000-0xfed93fff] has been reserved
[    0.355813] system 00:0b: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.355814] system 00:0b: [mem 0xff000000-0xffffffff] has been reserved
[    0.355815] system 00:0b: [mem 0xfee00000-0xfeefffff] could not be reserved
[    0.355817] system 00:0b: [mem 0xdfa00000-0xdfa00fff] has been reserved
[    0.355818] system 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.355926] pnp 00:0c: [mem 0x20000000-0x201fffff]
[    0.355927] pnp 00:0c: [mem 0x40004000-0x40004fff]
[    0.355960] system 00:0c: [mem 0x20000000-0x201fffff] has been reserved
[    0.355961] system 00:0c: [mem 0x40004000-0x40004fff] has been reserved
[    0.355962] system 00:0c: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.355977] pnp: PnP ACPI: found 13 devices
[    0.355978] ACPI: ACPI bus type pnp unregistered
[    0.391292] pci 0000:01:00.0: PCI bridge to [bus 02]
[    0.391296] pci 0000:01:00.0:   bridge window [io  0xe000-0xefff]
[    0.391311] pci 0000:00:01.0: PCI bridge to [bus 01-02]
[    0.391312] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    0.391316] pci 0000:00:1c.0: PCI bridge to [bus 03]
[    0.391336] pci 0000:00:1c.7: PCI bridge to [bus 04]
[    0.391339] pci 0000:00:1c.7:   bridge window [io  0xd000-0xdfff]
[    0.391343] pci 0000:00:1c.7:   bridge window [mem 0xf7c00000-0xf7cfffff]
[    0.391375] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.391377] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.391378] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.391379] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000d3fff]
[    0.391380] pci_bus 0000:00: resource 8 [mem 0x000d4000-0x000d7fff]
[    0.391381] pci_bus 0000:00: resource 9 [mem 0x000d8000-0x000dbfff]
[    0.391382] pci_bus 0000:00: resource 10 [mem 0x000dc000-0x000dffff]
[    0.391383] pci_bus 0000:00: resource 11 [mem 0x000e0000-0x000e3fff]
[    0.391385] pci_bus 0000:00: resource 12 [mem 0x000e4000-0x000e7fff]
[    0.391386] pci_bus 0000:00: resource 13 [mem 0xdfa00000-0xfeafffff]
[    0.391387] pci_bus 0000:01: resource 0 [io  0xe000-0xefff]
[    0.391388] pci_bus 0000:02: resource 0 [io  0xe000-0xefff]
[    0.391389] pci_bus 0000:04: resource 0 [io  0xd000-0xdfff]
[    0.391390] pci_bus 0000:04: resource 1 [mem 0xf7c00000-0xf7cfffff]
[    0.391406] NET: Registered protocol family 2
[    0.391489] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.391613] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.391667] TCP: Hash tables configured (established 131072 bind 65536)
[    0.391673] TCP: reno registered
[    0.391674] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    0.391676] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    0.391704] NET: Registered protocol family 1
[    0.391710] pci 0000:00:02.0: Boot video device
[    0.424745] PCI: CLS 64 bytes, default 64
[    0.424785] Unpacking initramfs...
[    0.724567] Freeing initrd memory: 25812k freed
[    0.727033] audit: initializing netlink socket (disabled)
[    0.727041] type=2000 audit(1350195237.623:1): initialized
[    0.737799] bounce pool size: 64 pages
[    0.737802] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    0.738617] VFS: Disk quotas dquot_6.5.2
[    0.738643] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.738774] msgmni has been set to 1698
[    0.738901] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.738917] io scheduler noop registered
[    0.738918] io scheduler deadline registered
[    0.738922] io scheduler cfq registered (default)
[    0.738984] pcieport 0000:00:01.0: irq 40 for MSI/MSI-X
[    0.739170] intel_idle: MWAIT substates: 0x1120
[    0.739171] intel_idle: v0.4 model 0x3A
[    0.739172] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.741909] Serial: 8250/16550 driver, 8 ports, IRQ sharing disabled
[    0.742281] Non-volatile memory driver v1.3
[    0.742282] Linux agpgart interface v0.103
[    0.742356] ahci 0000:00:1f.2: version 3.0
[    0.742392] ahci 0000:00:1f.2: irq 41 for MSI/MSI-X
[    0.742415] ahci: SSS flag set, parallel bus scan disabled
[    0.753796] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x23 impl SATA mode
[    0.753800] ahci 0000:00:1f.2: flags: 64bit ncq stag pm led clo pio slum part ems sxs apst 
[    0.753809] ahci 0000:00:1f.2: setting latency timer to 64
[    0.767317] scsi0 : ahci
[    0.767352] scsi1 : ahci
[    0.767384] scsi2 : ahci
[    0.767413] scsi3 : ahci
[    0.767442] scsi4 : ahci
[    0.767470] scsi5 : ahci
[    0.767491] ata1: SATA max UDMA/133 abar m2048@0xf7d32000 port 0xf7d32100 irq 41
[    0.767493] ata2: SATA max UDMA/133 abar m2048@0xf7d32000 port 0xf7d32180 irq 41
[    0.767494] ata3: DUMMY
[    0.767495] ata4: DUMMY
[    0.767495] ata5: DUMMY
[    0.767498] ata6: SATA max UDMA/133 abar m2048@0xf7d32000 port 0xf7d32380 irq 41
[    0.767535] libphy: Fixed MDIO Bus: probed
[    0.767537] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.767559] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[    0.767562] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[    0.767566] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    0.771447] ehci_hcd 0000:00:1a.0: debug port 2
[    0.771454] ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
[    0.771464] ehci_hcd 0000:00:1a.0: irq 16, io mem 0xf7d34000
[    0.780370] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    0.780389] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    0.780391] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.780394] usb usb1: Product: EHCI Host Controller
[    0.780396] usb usb1: Manufacturer: Linux 3.6.2 ehci_hcd
[    0.780398] usb usb1: SerialNumber: 0000:00:1a.0
[    0.780476] hub 1-0:1.0: USB hub found
[    0.780478] hub 1-0:1.0: 2 ports detected
[    0.780521] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[    0.780524] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[    0.780526] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    0.784410] ehci_hcd 0000:00:1d.0: debug port 2
[    0.784415] ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
[    0.784425] ehci_hcd 0000:00:1d.0: irq 23, io mem 0xf7d33000
[    0.793665] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    0.793678] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    0.793680] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.793682] usb usb2: Product: EHCI Host Controller
[    0.793684] usb usb2: Manufacturer: Linux 3.6.2 ehci_hcd
[    0.793687] usb usb2: SerialNumber: 0000:00:1d.0
[    0.793754] hub 2-0:1.0: USB hub found
[    0.793756] hub 2-0:1.0: 2 ports detected
[    0.793788] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.793795] uhci_hcd: USB Universal Host Controller Interface driver
[    0.793802] Initializing USB Mass Storage driver...
[    0.793811] usbcore: registered new interface driver usb-storage
[    0.793811] USB Mass Storage support registered.
[    0.793814] usbcore: registered new interface driver ums-alauda
[    0.793817] usbcore: registered new interface driver ums-cypress
[    0.793820] usbcore: registered new interface driver ums-datafab
[    0.793824] usbcore: registered new interface driver ums-freecom
[    0.793827] usbcore: registered new interface driver ums-isd200
[    0.793830] usbcore: registered new interface driver ums-jumpshot
[    0.793833] usbcore: registered new interface driver ums-karma
[    0.793836] usbcore: registered new interface driver ums-onetouch
[    0.793839] usbcore: registered new interface driver ums-sddr09
[    0.793841] usbcore: registered new interface driver ums-sddr55
[    0.793844] usbcore: registered new interface driver ums-usbat
[    0.793867] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    0.796359] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.796364] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.796406] mousedev: PS/2 mouse device common for all mice
[    0.796452] rtc_cmos 00:06: RTC can wake from S4
[    0.796549] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
[    0.796577] rtc0: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    0.796613] cpuidle: using governor ladder
[    0.796693] usbcore: registered new interface driver usbhid
[    0.796694] usbhid: USB HID core driver
[    0.796769] ashmem: initialized
[    0.796852] TCP: cubic registered
[    0.796902] NET: Registered protocol family 10
[    0.797008] lib80211: common routines for IEEE802.11 drivers
[    0.797009] lib80211_crypt: registered algorithm 'NULL'
[    0.797013] Key type dns_resolver registered
[    0.797015] Key type ceph registered
[    0.797019] libceph: loaded (mon/osd proto 15/24, osdmap 5/6 5/6)
[    0.797163] Using IPI No-Shortcut mode
[    0.797258] registered taskstats version 1
[    0.797560]   Magic number: 0:877:215
[    0.797565] event_source software: hash matches
[    0.797649] rtc_cmos 00:06: setting system clock to 2012-10-14 06:13:58 UTC (1350195238)
[    1.086194] usb 1-1: new high-speed USB device number 2 using ehci_hcd
[    1.086201] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.095436] ata1.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
[    1.095441] ata1.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
[    1.095445] ata1.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION OVERLAY) filtered out
[    1.098202] ata1.00: ATAPI: HL-DT-ST BDDVDRW UH12LS29, 1.00, max UDMA/133
[    1.103241] ata1.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
[    1.103247] ata1.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
[    1.103250] ata1.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION OVERLAY) filtered out
[    1.105994] ata1.00: configured for UDMA/133
[    1.124818] scsi 0:0:0:0: CD-ROM            HL-DT-ST BDDVDRW UH12LS29 1.00 PQ: 0 ANSI: 5
[    1.209501] usb 1-1: New USB device found, idVendor=8087, idProduct=0024
[    1.209505] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.209779] hub 1-1:1.0: USB hub found
[    1.209906] hub 1-1:1.0: 6 ports detected
[    1.315515] usb 2-1: new high-speed USB device number 2 using ehci_hcd
[    1.438844] usb 2-1: New USB device found, idVendor=8087, idProduct=0024
[    1.438849] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.439123] hub 2-1:1.0: USB hub found
[    1.439250] hub 2-1:1.0: 8 ports detected
[    1.441833] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.443213] ata2.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
[    1.443217] ata2.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
[    1.443220] ata2.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION OVERLAY) filtered out
[    1.453643] ata2.00: ATA-9: INTEL SSDSC2CW060A3, 400i, max UDMA/133
[    1.453647] ata2.00: 117231408 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    1.463182] ata2.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
[    1.463187] ata2.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
[    1.463190] ata2.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION OVERLAY) filtered out
[    1.473588] ata2.00: configured for UDMA/133
[    1.473735] scsi 1:0:0:0: Direct-Access     ATA      INTEL SSDSC2CW06 400i PQ: 0 ANSI: 5
[    1.125041] ACPI: Invalid Power Resource to register!
[    1.473911] sd 1:0:0:0: [sda] 117231408 512-byte logical blocks: (60.0 GB/55.8 GiB)
[    1.474088] sd 1:0:0:0: [sda] Write Protect is off
[    1.474090] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.474152] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.474709]  sda: sda1 sda2 sda3 sda4
[    1.475131] sd 1:0:0:0: [sda] Attached SCSI disk
[    1.518422] usb 1-1.2: new high-speed USB device number 3 using ehci_hcd
[    1.604771] usb 1-1.2: New USB device found, idVendor=0846, idProduct=9011
[    1.604775] usb 1-1.2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    1.604778] usb 1-1.2: Product: Remote Download Wireless Adapter
[    1.604780] usb 1-1.2: Manufacturer: Broadcom
[    1.604782] usb 1-1.2: SerialNumber: 0
[    1.704489] usb 2-1.6: new full-speed USB device number 3 using ehci_hcd
[    1.724345] tsc: Refined TSC clocksource calibration: 3392.303 MHz
[    1.724351] Switching to clocksource tsc
[    1.790828] ata6: SATA link down (SStatus 0 SControl 300)
[    1.790974] Freeing unused kernel memory: 452k freed
[    1.791100] usb 2-1.6: New USB device found, idVendor=19ff, idProduct=0231
[    1.791103] usb 2-1.6: New USB device strings: Mfr=0, Product=2, SerialNumber=0
[    1.791104] usb 2-1.6: Product: Dynex wireless combo
[    1.813099] emc: device handler registered
[    1.814004] rdac: device handler registered
[    1.814973] alua: device handler registered
[    1.815839] hp_sw: device handler registered
[    1.818371] udevd[116]: starting version 182
[    1.823917] ACPI: Fan [FAN0] (off)
[    1.823942] ACPI: Fan [FAN1] (off)
[    1.823960] ACPI: Fan [FAN2] (off)
[    1.823977] ACPI: Fan [FAN3] (off)
[    1.823993] ACPI: Fan [FAN4] (off)
[    1.824545] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[    1.824572] ACPI: Power Button [PWRB]
[    1.824594] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    1.824611] ACPI: Power Button [PWRF]
[    1.827804] [drm] Initialized drm 1.1.0 20060810
[    1.832818] xhci_hcd 0000:00:14.0: setting latency timer to 64
[    1.832824] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    1.832828] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 3
[    1.832909] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
[    1.832915] xhci_hcd 0000:00:14.0: irq 16, io mem 0xf7d20000
[    1.832955] xhci_hcd 0000:00:14.0: irq 42 for MSI/MSI-X
[    1.832996] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
[    1.832997] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.832999] usb usb3: Product: xHCI Host Controller
[    1.833000] usb usb3: Manufacturer: Linux 3.6.2 xhci_hcd
[    1.833001] usb usb3: SerialNumber: 0000:00:14.0
[    1.833195] [drm:drm_pci_agp_init] *ERROR* Cannot initialize the agpgart module.
[    1.833255] DRM: Fill_in_dev failed.
[    1.834141] input: Dynex wireless combo as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.6/2-1.6:1.0/input/input2
[    1.834200] hid-generic 0003:19FF:0231.0001: input,hidraw0: USB HID v1.11 Keyboard [Dynex wireless combo] on usb-0000:00:1d.0-1.6/input0
[    1.834312] input: Dynex wireless combo as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.6/2-1.6:1.1/input/input3
[    1.835090] hid-generic 0003:19FF:0231.0002: input,hidraw1: USB HID v1.11 Mouse [Dynex wireless combo] on usb-0000:00:1d.0-1.6/input1
[    1.847549] thermal LNXTHERM:00: registered as thermal_zone0
[    1.847551] ACPI: Thermal Zone [TZ00] (28 C)
[    1.847676] thermal LNXTHERM:01: registered as thermal_zone1
[    1.847677] ACPI: Thermal Zone [TZ01] (30 C)
[    1.847813] xHCI xhci_add_endpoint called for root hub
[    1.847815] xHCI xhci_check_bandwidth called for root hub
[    1.847927] hub 3-0:1.0: USB hub found
[    1.847936] hub 3-0:1.0: 4 ports detected
[    1.847993] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    1.847995] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 4
[    1.848014] usb usb4: New USB device found, idVendor=1d6b, idProduct=0003
[    1.848015] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.848016] usb usb4: Product: xHCI Host Controller
[    1.848017] usb usb4: Manufacturer: Linux 3.6.2 xhci_hcd
[    1.848018] usb usb4: SerialNumber: 0000:00:14.0
[    1.848082] xHCI xhci_add_endpoint called for root hub
[    1.848083] xHCI xhci_check_bandwidth called for root hub
[    1.848098] hub 4-0:1.0: USB hub found
[    1.848105] hub 4-0:1.0: 4 ports detected
[    1.919168] EXT4-fs (sda4): mounted filesystem with ordered data mode. Opts: acl,user_xattr
[    1.933621] EXT4-fs (sda4): re-mounted. Opts: acl,user_xattr
[    2.232015] systemd-readahead-replay[291]: Bumped block_nr parameter of 8:0 to 16384. This is a temporary hack and should be removed one day.
[    2.695579] udevd[322]: starting version 182
[    2.759396] microcode: CPU0 sig=0x306a9, pf=0x2, revision=0x12
[    2.762847] microcode: CPU1 sig=0x306a9, pf=0x2, revision=0x12
[    2.763102] microcode: CPU2 sig=0x306a9, pf=0x2, revision=0x12
[    2.763406] microcode: CPU3 sig=0x306a9, pf=0x2, revision=0x12
[    2.763692] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    2.843219] BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
[    2.856919] EXT4-fs (sda4): re-mounted. Opts: acl,user_xattr
[    3.089646] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    3.090091] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    3.090813] e1000e: Intel(R) PRO/1000 Network Driver - 2.0.0-k
[    3.090814] e1000e: Copyright(c) 1999 - 2012 Intel Corporation.
[    3.090837] e1000e 0000:00:19.0: setting latency timer to 64
[    3.090911] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[    3.090936] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[    3.100642] input: PC Speaker as /devices/platform/pcspkr/input/input4
[    3.104413] scsi 0:0:0:0: Attached scsi generic sg0 type 5
[    3.104440] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    3.112762] kvm: disabled by bios
[    3.118958] sr0: scsi3-mmc drive: 40x/40x writer dvd-ram cd/rw xa/form2 cdda tray
[    3.118960] cdrom: Uniform CD-ROM driver Revision: 3.20
[    3.119030] sr 0:0:0:0: Attached scsi CD-ROM sr0
[    3.266753] Adding 4193276k swap on /dev/sda3.  Priority:-1 extents:1 across:4193276k SS
[    3.344288] e1000e 0000:00:19.0: eth0: (PCI Express:2.5GT/s:Width x1) e8:40:f2:05:f1:85
[    3.344291] e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    3.344340] e1000e 0000:00:19.0: eth0: MAC: 10, PHY: 11, PBA No: FFFFFF-0FF
[    1.473943] ACPI: Invalid Power Resource to register!
[    3.344418] ACPI Warning: 0x00000428-0x0000042f SystemIO conflicts with Region \PMIO 1 (20120711/utaddress-251)
[    3.344423] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    3.344425] ACPI Warning: 0x00000500-0x0000053f SystemIO conflicts with Region \GPIO 1 (20120711/utaddress-251)
[    3.344427] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    3.344428] lpc_ich: Resource conflict(s) found affecting gpio_ich
[    3.344453] ACPI Warning: 0x0000f040-0x0000f05f SystemIO conflicts with Region \_SB_.PCI0.SBUS.SMBI 1 (20120711/utaddress-251)
[    3.344457] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    3.361826] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: acl,user_xattr
[    4.430067] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[    4.533062] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[    4.533147] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[    4.789014] RPC: Registered named UNIX socket transport module.
[    4.789016] RPC: Registered udp transport module.
[    4.789016] RPC: Registered tcp transport module.
[    4.789017] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    4.791233] FS-Cache: Loaded
[    4.793950] FS-Cache: Netfs 'nfs' registered for caching
[    5.356822] EXT4-fs (sda4): re-mounted. Opts: acl,user_xattr,commit=0
[    5.359365] EXT4-fs (sda2): re-mounted. Opts: acl,user_xattr,commit=0
[    6.029089] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Control: Rx/Tx
[    6.029093] e1000e 0000:00:19.0: eth0: 10/100 speed: disabling TSO
[    6.029127] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready

--------------080801040306040503040104--

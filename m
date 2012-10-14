Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932202Ab2JNQNN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 12:13:13 -0400
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:7300 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754332Ab2JNQNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 12:13:12 -0400
X-Authority-Analysis: v=2.0 cv=Dp3UCRD+ c=1 sm=0 a=YPDeGStqRoQnMAluW+pq4Q==:17 a=65KWcu232dMA:10 a=h9GbcFHyNoYA:10 a=g7R6esmICIkA:10 a=05ChyHeVI94A:10 a=ayC55rCoAAAA:8 a=HjRi3UqH30YA:10 a=DHX7pLrX_xFXckkf0GQA:9 a=wPNLvfGTeEIA:10 a=pSDxxfrZAAAA:8 a=m0SDKHOHWI68O4_la28A:9 a=QEXdDO2ut3YA:10 a=Sf_gFPzhefAA:10 a=-0qkl0XTG-IA:10 a=444ixQ_M-kYcBLPI:21 a=6or0PgrwXC7VdhUm:21 a=S4Yire2jXoupEBX7:21 a=YPDeGStqRoQnMAluW+pq4Q==:117
X-Cloudmark-Score: 0
X-Originating-IP: 50.89.247.146
Message-ID: <507AE495.8000400@cfl.rr.com>
Date: Sun, 14 Oct 2012 12:13:09 -0400
From: Mark Hounschell <dmarkh@cfl.rr.com>
Reply-To: dmarkh@cfl.rr.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: dmarkh@cfl.rr.com
CC: =?ISO-8859-1?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>,
        Daniel Vetter <daniel@ffwll.ch>, markh@compro.net,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [Intel-gfx] Intel graphics drm issue?
References: <507812E8.3060607@compro.net> <20121012231459.166e29fd@neptune.home> <5079B97C.7020401@cfl.rr.com> <5079BE5C.8020401@cfl.rr.com> <CAKMK7uGXb5=fHXZa8m_0xNLGFqyf_b37g9W32eshaPFcf8i=7A@mail.gmail.com> <507A91EA.2030205@cfl.rr.com> <CAKMK7uEw8D1r4hf_mE1q6kBwZzE+qmSeTui9adX4agj=5MDbWw@mail.gmail.com> <507AC9DC.4030701@cfl.rr.com> <CAKMK7uERj4+QtxMzzHsbxbqvUYNGWxmieZeebS3+CjAbj6Kq1g@mail.gmail.com> <507ADD14.7050503@cfl.rr.com> <CAKMK7uGCyHaXko102_VDus3RCarDobeiRcNKnzjqX3YFK2ouBw@mail.gmail.com> <20121014175538.3bdd7cb8@neptune.home> <507AE39D.5020708@cfl.rr.com>
In-Reply-To: <507AE39D.5020708@cfl.rr.com>
Content-Type: multipart/mixed;
 boundary="------------030404000001010103020706"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030404000001010103020706
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

On 10/14/2012 12:09 PM, Mark Hounschell wrote:
> On 10/14/2012 11:55 AM, Bruno Pr=E9mont wrote:
>> On Sun, 14 October 2012 Daniel Vetter <daniel@ffwll.ch> wrote:
>>> On Sun, Oct 14, 2012 at 5:41 PM, Mark Hounschell <dmarkh@cfl.rr.com> =
wrote:
>>>> There is something amiss. Here is my  i915_pci_probe routine. I Adde=
d a
>>>> couple more printks. NONE of these show up in dmesg. Not even the
>>>> "Entered"
>>>> printk. ????
>>>
>>> That's rather strange indeed. Is there another driver bound by
>>> accident to the intel graphics? You can check that with lspci -k
>>> -Daniel
>>
>> A few mails ago in a kernel cmd I saw a nomodeset, could it be that
>> it's still around?
>
> Yes, that is still around. I'll get rid of it and try again.
>
> Mark
>
>

That was it. Sorry. Attached is the dmesg now. This is what I see though

[    1.875354] [drm] Initialized drm 1.1.0 20060810
[    1.891216] i915_pci_probe: Entered
[    1.891218] dropping agp requirement
[    1.891219] force-disabling agp on gen 7, is_ivybridge 1

Mark

--------------030404000001010103020706
Content-Type: text/plain; charset=UTF-8;
 name="dmesg-dvi2hdmi-3.6.2-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg-dvi2hdmi-3.6.2-2"

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
[    0.000000] Kernel command line: root=/dev/disk/by-id/ata-INTEL_SSDSC2CW060A3_CVCV205106EB060AGN-part4 video=1024x768 noresume splash=silent quiet apm=off drm.debug=0xe irqpoll
[    0.000000] Misrouted IRQ fixup and polling support enabled
[    0.000000] This may significantly impact system performance
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
[    0.003333] tsc: Detected 3392.407 MHz processor
[    0.000000] Calibrating delay loop (skipped), value calculated using timer frequency.. 6787.51 BogoMIPS (lpj=11308023)
[    0.000002] pid_max: default: 32768 minimum: 301
[    0.000015] Security Framework initialized
[    0.000024] AppArmor: AppArmor initialized
[    0.000029] Mount-cache hash table entries: 512
[    0.000136] Initializing cgroup subsys net_cls
[    0.000137] Initializing cgroup subsys blkio
[    0.000154] CPU: Physical Processor ID: 0
[    0.000154] CPU: Processor Core ID: 0
[    0.000157] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.000157] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.000694] mce: CPU supports 9 MCE banks
[    0.000704] CPU0: Thermal monitoring enabled (TM1)
[    0.000708] process: using mwait in idle threads
[    0.000712] Last level iTLB entries: 4KB 512, 2MB 0, 4MB 0
[    0.000712] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32
[    0.000712] tlb_flushall_shift is 0x1
[    0.001277] ACPI: Core revision 20120711
[    0.007332] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.007753] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.040662] smpboot: CPU0: Intel(R) Core(TM) i5-3570K CPU @ 3.40GHz stepping 09
[    0.146600] Performance Events: PEBS fmt1+, 16-deep LBR, IvyBridge events, Intel PMU driver.
[    0.146604] ... version:                3
[    0.146605] ... bit width:              48
[    0.146606] ... generic registers:      8
[    0.146606] ... value mask:             0000ffffffffffff
[    0.146607] ... max period:             000000007fffffff
[    0.146608] ... fixed-purpose events:   3
[    0.146608] ... event mask:             00000007000000ff
[    0.193139] CPU 1 irqstacks, hard=f54b0000 soft=f54b2000
[    0.203368] Initializing CPU#1
[    0.193141] smpboot: Booting Node   0, Processors  #1
[    0.219729] CPU 2 irqstacks, hard=f54c6000 soft=f54c8000
[    0.229999] Initializing CPU#2
[    0.219732]  #2
[    0.246318] CPU 3 irqstacks, hard=f54e0000 soft=f54e2000
[    0.246321]  #3 OK
[    0.256587] Initializing CPU#3
[    0.260024] Brought up 4 CPUs
[    0.260026] smpboot: Total of 4 processors activated (27150.05 BogoMIPS)
[    0.262498] devtmpfs: initialized
[    0.262651] PM: Registering ACPI NVS region [mem 0xda37b000-0xda40cfff] (598016 bytes)
[    0.262656] PM: Registering ACPI NVS region [mem 0xda6a4000-0xda6e6fff] (274432 bytes)
[    0.262709] dummy: 
[    0.262738] RTC time: 12:09:14, date: 10/14/12
[    0.262762] NET: Registered protocol family 16
[    0.312898] ACPI: bus type pci registered
[    0.312943] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.312944] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.312945] PCI: Using MMCONFIG for extended config space
[    0.312946] PCI: Using configuration type 1 for base access
[    0.313393] bio: create slab <bio-0> at 0
[    0.313429] ACPI: Added _OSI(Module Device)
[    0.313430] ACPI: Added _OSI(Processor Device)
[    0.313431] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.313432] ACPI: Added _OSI(Processor Aggregator Device)
[    0.314760] ACPI: EC: Look up EC in DSDT
[    0.316276] ACPI: Executed 1 blocks of module-level executable AML code
[    0.336784] ACPI: SSDT da293018 0083B (v01  PmRef  Cpu0Cst 00003001 INTL 20051117)
[    0.337119] ACPI: Dynamic OEM Table Load:
[    0.337121] ACPI: SSDT   (null) 0083B (v01  PmRef  Cpu0Cst 00003001 INTL 20051117)
[    0.346245] ACPI: SSDT da294a98 00303 (v01  PmRef    ApIst 00003000 INTL 20051117)
[    0.346612] ACPI: Dynamic OEM Table Load:
[    0.346614] ACPI: SSDT   (null) 00303 (v01  PmRef    ApIst 00003000 INTL 20051117)
[    0.363053] ACPI: SSDT da299c18 00119 (v01  PmRef    ApCst 00003000 INTL 20051117)
[    0.363390] ACPI: Dynamic OEM Table Load:
[    0.363392] ACPI: SSDT   (null) 00119 (v01  PmRef    ApCst 00003000 INTL 20051117)
[    0.380196] ACPI: Interpreter enabled
[    0.380201] ACPI: (supports S0 S3 S4 S5)
[    0.380213] ACPI: Using IOAPIC for interrupt routing
[    0.384188] ACPI: Power Resource [FN00] (off)
[    0.384238] ACPI: Power Resource [FN01] (off)
[    0.384285] ACPI: Power Resource [FN02] (off)
[    0.384333] ACPI: Power Resource [FN03] (off)
[    0.384380] ACPI: Power Resource [FN04] (off)
[    0.384738] ACPI: No dock devices found.
[    0.384741] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.384972] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
[    0.385303] PCI host bridge to bus 0000:00
[    0.385305] pci_bus 0000:00: busn_res: [bus 00-3e] is inserted under domain [bus 00-ff]
[    0.385306] pci_bus 0000:00: root bus resource [bus 00-3e]
[    0.385308] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.385309] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.385310] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.385311] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3fff]
[    0.385312] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
[    0.385313] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
[    0.385315] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff]
[    0.385316] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000e3fff]
[    0.385317] pci_bus 0000:00: root bus resource [mem 0x000e4000-0x000e7fff]
[    0.385318] pci_bus 0000:00: root bus resource [mem 0xdfa00000-0xfeafffff]
[    0.385324] pci 0000:00:00.0: [8086:0150] type 00 class 0x060000
[    0.385354] pci 0000:00:01.0: [8086:0151] type 01 class 0x060400
[    0.385376] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.385393] pci 0000:00:02.0: [8086:0162] type 00 class 0x030000
[    0.385400] pci 0000:00:02.0: reg 10: [mem 0xf7800000-0xf7bfffff 64bit]
[    0.385405] pci 0000:00:02.0: reg 18: [mem 0xe0000000-0xefffffff 64bit pref]
[    0.385408] pci 0000:00:02.0: reg 20: [io  0xf000-0xf03f]
[    0.385452] pci 0000:00:14.0: [8086:1e31] type 00 class 0x0c0330
[    0.385471] pci 0000:00:14.0: reg 10: [mem 0xf7d20000-0xf7d2ffff 64bit]
[    0.385536] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    0.385557] pci 0000:00:16.0: [8086:1e3a] type 00 class 0x078000
[    0.385578] pci 0000:00:16.0: reg 10: [mem 0xf7d37000-0xf7d3700f 64bit]
[    0.385649] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.385676] pci 0000:00:19.0: [8086:1503] type 00 class 0x020000
[    0.385692] pci 0000:00:19.0: reg 10: [mem 0xf7d00000-0xf7d1ffff]
[    0.385700] pci 0000:00:19.0: reg 14: [mem 0xf7d35000-0xf7d35fff]
[    0.385708] pci 0000:00:19.0: reg 18: [io  0xf080-0xf09f]
[    0.385765] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.385787] pci 0000:00:1a.0: [8086:1e2d] type 00 class 0x0c0320
[    0.385806] pci 0000:00:1a.0: reg 10: [mem 0xf7d34000-0xf7d343ff]
[    0.385889] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.385914] pci 0000:00:1c.0: [8086:1e10] type 01 class 0x060400
[    0.386043] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.386080] pci 0000:00:1c.7: [8086:1e1e] type 01 class 0x060400
[    0.386152] pci 0000:00:1c.7: PME# supported from D0 D3hot D3cold
[    0.386177] pci 0000:00:1d.0: [8086:1e26] type 00 class 0x0c0320
[    0.386196] pci 0000:00:1d.0: reg 10: [mem 0xf7d33000-0xf7d333ff]
[    0.386279] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.386303] pci 0000:00:1f.0: [8086:1e4a] type 00 class 0x060100
[    0.386418] pci 0000:00:1f.2: [8086:1e02] type 00 class 0x010601
[    0.386434] pci 0000:00:1f.2: reg 10: [io  0xf0d0-0xf0d7]
[    0.386441] pci 0000:00:1f.2: reg 14: [io  0xf0c0-0xf0c3]
[    0.386448] pci 0000:00:1f.2: reg 18: [io  0xf0b0-0xf0b7]
[    0.386456] pci 0000:00:1f.2: reg 1c: [io  0xf0a0-0xf0a3]
[    0.386463] pci 0000:00:1f.2: reg 20: [io  0xf060-0xf07f]
[    0.386470] pci 0000:00:1f.2: reg 24: [mem 0xf7d32000-0xf7d327ff]
[    0.386510] pci 0000:00:1f.2: PME# supported from D3hot
[    0.386525] pci 0000:00:1f.3: [8086:1e22] type 00 class 0x0c0500
[    0.386539] pci 0000:00:1f.3: reg 10: [mem 0xf7d31000-0xf7d310ff 64bit]
[    0.386557] pci 0000:00:1f.3: reg 20: [io  0xf040-0xf05f]
[    0.386595] pci_bus 0000:01: busn_res: [bus 01-02] is inserted under [bus 00-3e]
[    0.386612] pci 0000:01:00.0: [10b5:8112] type 01 class 0x060400
[    0.386718] pci 0000:01:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.386725] pci 0000:00:01.0: PCI bridge to [bus 01-02]
[    0.386727] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    0.386773] pci_bus 0000:02: busn_res: [bus 02] is inserted under [bus 01-02]
[    0.386793] pci 0000:02:04.0: [13f6:8788] type 00 class 0x040100
[    0.386816] pci 0000:02:04.0: reg 10: [io  0xe000-0xe0ff]
[    0.386927] pci 0000:02:04.0: supports D1 D2
[    0.386978] pci 0000:01:00.0: PCI bridge to [bus 02]
[    0.386982] pci 0000:01:00.0:   bridge window [io  0xe000-0xefff]
[    0.387067] pci_bus 0000:03: busn_res: [bus 03] is inserted under [bus 00-3e]
[    0.387069] pci 0000:00:1c.0: PCI bridge to [bus 03]
[    0.387122] pci_bus 0000:04: busn_res: [bus 04] is inserted under [bus 00-3e]
[    0.387125] pci 0000:00:1c.7: PCI bridge to [bus 04]
[    0.387129] pci 0000:00:1c.7:   bridge window [io  0xd000-0xdfff]
[    0.387132] pci 0000:00:1c.7:   bridge window [mem 0xf7c00000-0xf7cfffff]
[    0.387151] pci_bus 0000:00: on NUMA node 0
[    0.387153] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.387240] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.387268] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP08._PRT]
[    0.387290] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEG0._PRT]
[    0.387381]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.387520]  pci0000:00: ACPI _OSC control (0x18) granted
[    0.390373] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.390406] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.390444] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 *4 5 6 10 11 12 14 15)
[    0.390480] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 *10 11 12 14 15)
[    0.390511] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 10 11 12 14 15)
[    0.390548] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.390585] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.390622] ACPI: PCI Interrupt Link [LNKH] (IRQs *3 4 5 6 10 11 12 14 15)
[    0.390661] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.390664] vgaarb: loaded
[    0.390665] vgaarb: bridge control possible 0000:00:02.0
[    0.390723] SCSI subsystem initialized
[    0.390724] ACPI: bus type scsi registered
[    0.390741] libata version 3.00 loaded.
[    0.390751] ACPI: bus type usb registered
[    0.390760] usbcore: registered new interface driver usbfs
[    0.390764] usbcore: registered new interface driver hub
[    0.390776] usbcore: registered new device driver usb
[    0.390801] PCI: Using ACPI for IRQ routing
[    0.392169] PCI: pci_cache_line_size set to 64 bytes
[    0.392218] e820: reserve RAM buffer [mem 0x0009d800-0x0009ffff]
[    0.392219] e820: reserve RAM buffer [mem 0x40004000-0x43ffffff]
[    0.392220] e820: reserve RAM buffer [mem 0xd9e5f000-0xdbffffff]
[    0.392222] e820: reserve RAM buffer [mem 0xda37b000-0xdbffffff]
[    0.392223] e820: reserve RAM buffer [mem 0xda6a4000-0xdbffffff]
[    0.392224] e820: reserve RAM buffer [mem 0xdb000000-0xdbffffff]
[    0.392275] NetLabel: Initializing
[    0.392276] NetLabel:  domain hash size = 128
[    0.392277] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.392282] NetLabel:  unlabeled traffic allowed by default
[    0.392328] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.392331] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.395338] Switching to clocksource hpet
[    0.395378] AppArmor: AppArmor Filesystem Enabled
[    0.395386] pnp: PnP ACPI init
[    0.395391] ACPI: bus type pnp registered
[    0.395571] pnp 00:00: [bus 00-3e]
[    0.395573] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.395574] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.395575] pnp 00:00: [io  0x0d00-0xffff window]
[    0.395576] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.395578] pnp 00:00: [mem 0x000c0000-0x000c3fff window]
[    0.395579] pnp 00:00: [mem 0x000c4000-0x000c7fff window]
[    0.395580] pnp 00:00: [mem 0x000c8000-0x000cbfff window]
[    0.395581] pnp 00:00: [mem 0x000cc000-0x000cffff window]
[    0.395582] pnp 00:00: [mem 0x000d0000-0x000d3fff window]
[    0.395584] pnp 00:00: [mem 0x000d4000-0x000d7fff window]
[    0.395585] pnp 00:00: [mem 0x000d8000-0x000dbfff window]
[    0.395586] pnp 00:00: [mem 0x000dc000-0x000dffff window]
[    0.395587] pnp 00:00: [mem 0x000e0000-0x000e3fff window]
[    0.395588] pnp 00:00: [mem 0x000e4000-0x000e7fff window]
[    0.395589] pnp 00:00: [mem 0x000e8000-0x000ebfff window]
[    0.395590] pnp 00:00: [mem 0x000ec000-0x000effff window]
[    0.395591] pnp 00:00: [mem 0x000f0000-0x000fffff window]
[    0.395592] pnp 00:00: [mem 0xdfa00000-0xfeafffff window]
[    0.395593] pnp 00:00: [mem 0x00010000-0x0001ffff window]
[    0.395624] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    0.395640] pnp 00:01: [mem 0xfed40000-0xfed44fff]
[    0.395657] system 00:01: [mem 0xfed40000-0xfed44fff] has been reserved
[    0.395659] system 00:01: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.395666] pnp 00:02: [io  0x0000-0x001f]
[    0.395667] pnp 00:02: [io  0x0081-0x0091]
[    0.395668] pnp 00:02: [io  0x0093-0x009f]
[    0.395669] pnp 00:02: [io  0x00c0-0x00df]
[    0.395670] pnp 00:02: [dma 4]
[    0.395682] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.395686] pnp 00:03: [mem 0xff000000-0xffffffff]
[    0.395696] pnp 00:03: Plug and Play ACPI device, IDs INT0800 (active)
[    0.395752] pnp 00:04: [mem 0xfed00000-0xfed003ff]
[    0.395763] pnp 00:04: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.395771] pnp 00:05: [io  0x002e-0x002f]
[    0.395772] pnp 00:05: [io  0x004e-0x004f]
[    0.395773] pnp 00:05: [io  0x0061]
[    0.395774] pnp 00:05: [io  0x0063]
[    0.395775] pnp 00:05: [io  0x0065]
[    0.395776] pnp 00:05: [io  0x0067]
[    0.395777] pnp 00:05: [io  0x0070]
[    0.395777] pnp 00:05: [io  0x0080]
[    0.395778] pnp 00:05: [io  0x0092]
[    0.395779] pnp 00:05: [io  0x00b2-0x00b3]
[    0.395780] pnp 00:05: [io  0x0680-0x069f]
[    0.395781] pnp 00:05: [io  0x1000-0x100f]
[    0.395782] pnp 00:05: [io  0xffff]
[    0.395783] pnp 00:05: [io  0xffff]
[    0.395784] pnp 00:05: [io  0x0400-0x0453]
[    0.395786] pnp 00:05: [io  0x0458-0x047f]
[    0.395787] pnp 00:05: [io  0x0500-0x057f]
[    0.395788] pnp 00:05: [io  0x164e-0x164f]
[    0.395807] system 00:05: [io  0x0680-0x069f] has been reserved
[    0.395809] system 00:05: [io  0x1000-0x100f] has been reserved
[    0.395810] system 00:05: [io  0xffff] has been reserved
[    0.395811] system 00:05: [io  0xffff] has been reserved
[    0.395812] system 00:05: [io  0x0400-0x0453] has been reserved
[    0.395814] system 00:05: [io  0x0458-0x047f] has been reserved
[    0.395815] system 00:05: [io  0x0500-0x057f] has been reserved
[    0.395816] system 00:05: [io  0x164e-0x164f] has been reserved
[    0.395817] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.395822] pnp 00:06: [io  0x0070-0x0077]
[    0.395831] pnp 00:06: [irq 8]
[    0.395842] pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.395858] pnp 00:07: [io  0x0454-0x0457]
[    0.395876] system 00:07: [io  0x0454-0x0457] has been reserved
[    0.395878] system 00:07: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
[    0.395932] pnp 00:08: [io  0x0000-0xffffffff disabled]
[    0.395934] pnp 00:08: [io  0x0a30-0x0a3f]
[    0.395935] pnp 00:08: [io  0x0000-0xffffffff disabled]
[    0.395936] pnp 00:08: [io  0x0250-0x025f]
[    0.395953] system 00:08: [io  0x0a30-0x0a3f] has been reserved
[    0.395954] system 00:08: [io  0x0250-0x025f] has been reserved
[    0.395955] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.395992] pnp 00:09: [io  0x0010-0x001f]
[    0.395993] pnp 00:09: [io  0x0022-0x003f]
[    0.395994] pnp 00:09: [io  0x0044-0x005f]
[    0.395995] pnp 00:09: [io  0x0062-0x0063]
[    0.395996] pnp 00:09: [io  0x0065-0x006f]
[    0.395997] pnp 00:09: [io  0x0072-0x007f]
[    0.395998] pnp 00:09: [io  0x0080]
[    0.395998] pnp 00:09: [io  0x0084-0x0086]
[    0.395999] pnp 00:09: [io  0x0088]
[    0.396000] pnp 00:09: [io  0x008c-0x008e]
[    0.396001] pnp 00:09: [io  0x0090-0x009f]
[    0.396002] pnp 00:09: [io  0x00a2-0x00bf]
[    0.396003] pnp 00:09: [io  0x00e0-0x00ef]
[    0.396004] pnp 00:09: [io  0x04d0-0x04d1]
[    0.396025] system 00:09: [io  0x04d0-0x04d1] has been reserved
[    0.396026] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.396032] pnp 00:0a: [io  0x00f0-0x00ff]
[    0.396039] pnp 00:0a: [irq 13]
[    0.396050] pnp 00:0a: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.396227] pnp 00:0b: [mem 0xfed1c000-0xfed1ffff]
[    0.396228] pnp 00:0b: [mem 0xfed10000-0xfed17fff]
[    0.396229] pnp 00:0b: [mem 0xfed18000-0xfed18fff]
[    0.396230] pnp 00:0b: [mem 0xfed19000-0xfed19fff]
[    0.396232] pnp 00:0b: [mem 0xf8000000-0xfbffffff]
[    0.396233] pnp 00:0b: [mem 0xfed20000-0xfed3ffff]
[    0.396234] pnp 00:0b: [mem 0xfed90000-0xfed93fff]
[    0.396234] pnp 00:0b: [mem 0xfed45000-0xfed8ffff]
[    0.396236] pnp 00:0b: [mem 0xff000000-0xffffffff]
[    0.396236] pnp 00:0b: [mem 0xfee00000-0xfeefffff]
[    0.396237] pnp 00:0b: [mem 0xdfa00000-0xdfa00fff]
[    0.396269] system 00:0b: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.396270] system 00:0b: [mem 0xfed10000-0xfed17fff] has been reserved
[    0.396272] system 00:0b: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.396283] system 00:0b: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.396284] system 00:0b: [mem 0xf8000000-0xfbffffff] has been reserved
[    0.396285] system 00:0b: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.396286] system 00:0b: [mem 0xfed90000-0xfed93fff] has been reserved
[    0.396288] system 00:0b: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.396289] system 00:0b: [mem 0xff000000-0xffffffff] has been reserved
[    0.396290] system 00:0b: [mem 0xfee00000-0xfeefffff] could not be reserved
[    0.396292] system 00:0b: [mem 0xdfa00000-0xdfa00fff] has been reserved
[    0.396293] system 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.396403] pnp 00:0c: [mem 0x20000000-0x201fffff]
[    0.396404] pnp 00:0c: [mem 0x40004000-0x40004fff]
[    0.396437] system 00:0c: [mem 0x20000000-0x201fffff] has been reserved
[    0.396438] system 00:0c: [mem 0x40004000-0x40004fff] has been reserved
[    0.396439] system 00:0c: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.396454] pnp: PnP ACPI: found 13 devices
[    0.396455] ACPI: ACPI bus type pnp unregistered
[    0.431763] pci 0000:01:00.0: PCI bridge to [bus 02]
[    0.431767] pci 0000:01:00.0:   bridge window [io  0xe000-0xefff]
[    0.431782] pci 0000:00:01.0: PCI bridge to [bus 01-02]
[    0.431783] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    0.431787] pci 0000:00:1c.0: PCI bridge to [bus 03]
[    0.431807] pci 0000:00:1c.7: PCI bridge to [bus 04]
[    0.431810] pci 0000:00:1c.7:   bridge window [io  0xd000-0xdfff]
[    0.431815] pci 0000:00:1c.7:   bridge window [mem 0xf7c00000-0xf7cfffff]
[    0.431844] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.431845] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.431846] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.431847] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000d3fff]
[    0.431848] pci_bus 0000:00: resource 8 [mem 0x000d4000-0x000d7fff]
[    0.431849] pci_bus 0000:00: resource 9 [mem 0x000d8000-0x000dbfff]
[    0.431851] pci_bus 0000:00: resource 10 [mem 0x000dc000-0x000dffff]
[    0.431852] pci_bus 0000:00: resource 11 [mem 0x000e0000-0x000e3fff]
[    0.431853] pci_bus 0000:00: resource 12 [mem 0x000e4000-0x000e7fff]
[    0.431854] pci_bus 0000:00: resource 13 [mem 0xdfa00000-0xfeafffff]
[    0.431855] pci_bus 0000:01: resource 0 [io  0xe000-0xefff]
[    0.431856] pci_bus 0000:02: resource 0 [io  0xe000-0xefff]
[    0.431858] pci_bus 0000:04: resource 0 [io  0xd000-0xdfff]
[    0.431859] pci_bus 0000:04: resource 1 [mem 0xf7c00000-0xf7cfffff]
[    0.431874] NET: Registered protocol family 2
[    0.431956] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.432078] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.432132] TCP: Hash tables configured (established 131072 bind 65536)
[    0.432137] TCP: reno registered
[    0.432138] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    0.432141] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    0.432169] NET: Registered protocol family 1
[    0.432175] pci 0000:00:02.0: Boot video device
[    0.465207] PCI: CLS 64 bytes, default 64
[    0.465249] Unpacking initramfs...
[    0.764950] Freeing initrd memory: 25812k freed
[    0.767400] audit: initializing netlink socket (disabled)
[    0.767408] type=2000 audit(1350216554.663:1): initialized
[    0.778156] bounce pool size: 64 pages
[    0.778159] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    0.778975] VFS: Disk quotas dquot_6.5.2
[    0.779001] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.779133] msgmni has been set to 1698
[    0.779252] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.779267] io scheduler noop registered
[    0.779268] io scheduler deadline registered
[    0.779271] io scheduler cfq registered (default)
[    0.779332] pcieport 0000:00:01.0: irq 40 for MSI/MSI-X
[    0.779518] intel_idle: MWAIT substates: 0x1120
[    0.779519] intel_idle: v0.4 model 0x3A
[    0.779520] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.782251] Serial: 8250/16550 driver, 8 ports, IRQ sharing disabled
[    0.782625] Non-volatile memory driver v1.3
[    0.782626] Linux agpgart interface v0.103
[    0.782698] ahci 0000:00:1f.2: version 3.0
[    0.782730] ahci 0000:00:1f.2: irq 41 for MSI/MSI-X
[    0.782753] ahci: SSS flag set, parallel bus scan disabled
[    0.794262] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x23 impl SATA mode
[    0.794266] ahci 0000:00:1f.2: flags: 64bit ncq stag pm led clo pio slum part ems sxs apst 
[    0.794274] ahci 0000:00:1f.2: setting latency timer to 64
[    0.807779] scsi0 : ahci
[    0.807815] scsi1 : ahci
[    0.807844] scsi2 : ahci
[    0.807873] scsi3 : ahci
[    0.807902] scsi4 : ahci
[    0.807931] scsi5 : ahci
[    0.807953] ata1: SATA max UDMA/133 abar m2048@0xf7d32000 port 0xf7d32100 irq 41
[    0.807956] ata2: SATA max UDMA/133 abar m2048@0xf7d32000 port 0xf7d32180 irq 41
[    0.807956] ata3: DUMMY
[    0.807957] ata4: DUMMY
[    0.807958] ata5: DUMMY
[    0.807960] ata6: SATA max UDMA/133 abar m2048@0xf7d32000 port 0xf7d32380 irq 41
[    0.807998] libphy: Fixed MDIO Bus: probed
[    0.807999] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.808016] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[    0.808018] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[    0.808022] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    0.811901] ehci_hcd 0000:00:1a.0: debug port 2
[    0.811908] ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
[    0.811918] ehci_hcd 0000:00:1a.0: irq 16, io mem 0xf7d34000
[    0.820836] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    0.820857] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    0.820859] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.820862] usb usb1: Product: EHCI Host Controller
[    0.820864] usb usb1: Manufacturer: Linux 3.6.2 ehci_hcd
[    0.820866] usb usb1: SerialNumber: 0000:00:1a.0
[    0.820941] hub 1-0:1.0: USB hub found
[    0.820943] hub 1-0:1.0: 2 ports detected
[    0.820988] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[    0.820990] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[    0.820993] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    0.824864] ehci_hcd 0000:00:1d.0: debug port 2
[    0.824870] ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
[    0.824879] ehci_hcd 0000:00:1d.0: irq 23, io mem 0xf7d33000
[    0.834130] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    0.834143] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    0.834146] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.834148] usb usb2: Product: EHCI Host Controller
[    0.834150] usb usb2: Manufacturer: Linux 3.6.2 ehci_hcd
[    0.834152] usb usb2: SerialNumber: 0000:00:1d.0
[    0.834219] hub 2-0:1.0: USB hub found
[    0.834220] hub 2-0:1.0: 2 ports detected
[    0.834256] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.834263] uhci_hcd: USB Universal Host Controller Interface driver
[    0.834270] Initializing USB Mass Storage driver...
[    0.834279] usbcore: registered new interface driver usb-storage
[    0.834280] USB Mass Storage support registered.
[    0.834284] usbcore: registered new interface driver ums-alauda
[    0.834287] usbcore: registered new interface driver ums-cypress
[    0.834290] usbcore: registered new interface driver ums-datafab
[    0.834294] usbcore: registered new interface driver ums-freecom
[    0.834297] usbcore: registered new interface driver ums-isd200
[    0.834300] usbcore: registered new interface driver ums-jumpshot
[    0.834302] usbcore: registered new interface driver ums-karma
[    0.834305] usbcore: registered new interface driver ums-onetouch
[    0.834308] usbcore: registered new interface driver ums-sddr09
[    0.834311] usbcore: registered new interface driver ums-sddr55
[    0.834314] usbcore: registered new interface driver ums-usbat
[    0.834336] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    0.836901] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.836908] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.836962] mousedev: PS/2 mouse device common for all mice
[    0.837018] rtc_cmos 00:06: RTC can wake from S4
[    0.837121] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
[    0.837149] rtc0: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    0.837186] cpuidle: using governor ladder
[    0.837272] usbcore: registered new interface driver usbhid
[    0.837273] usbhid: USB HID core driver
[    0.837353] ashmem: initialized
[    0.837451] TCP: cubic registered
[    0.837501] NET: Registered protocol family 10
[    0.837593] lib80211: common routines for IEEE802.11 drivers
[    0.837594] lib80211_crypt: registered algorithm 'NULL'
[    0.837601] Key type dns_resolver registered
[    0.837604] Key type ceph registered
[    0.837607] libceph: loaded (mon/osd proto 15/24, osdmap 5/6 5/6)
[    0.837717] Using IPI No-Shortcut mode
[    0.837825] registered taskstats version 1
[    0.838137]   Magic number: 0:963:177
[    0.838155] acpi device:0d: hash matches
[    0.838205] rtc_cmos 00:06: setting system clock to 2012-10-14 12:09:15 UTC (1350216555)
[    1.126652] usb 1-1: new high-speed USB device number 2 using ehci_hcd
[    1.126656] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.135882] ata1.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
[    1.135888] ata1.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
[    1.135891] ata1.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION OVERLAY) filtered out
[    1.138650] ata1.00: ATAPI: HL-DT-ST BDDVDRW UH12LS29, 1.00, max UDMA/133
[    1.143686] ata1.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
[    1.143691] ata1.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
[    1.143694] ata1.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION OVERLAY) filtered out
[    1.146445] ata1.00: configured for UDMA/133
[    1.165274] scsi 0:0:0:0: CD-ROM            HL-DT-ST BDDVDRW UH12LS29 1.00 PQ: 0 ANSI: 5
[    1.249957] usb 1-1: New USB device found, idVendor=8087, idProduct=0024
[    1.249961] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.250233] hub 1-1:1.0: USB hub found
[    1.250362] hub 1-1:1.0: 6 ports detected
[    1.355983] usb 2-1: new high-speed USB device number 2 using ehci_hcd
[    1.479299] usb 2-1: New USB device found, idVendor=8087, idProduct=0024
[    1.479304] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.479577] hub 2-1:1.0: USB hub found
[    1.479703] hub 2-1:1.0: 8 ports detected
[    1.482293] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.483673] ata2.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
[    1.483677] ata2.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
[    1.483680] ata2.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION OVERLAY) filtered out
[    1.494095] ata2.00: ATA-9: INTEL SSDSC2CW060A3, 400i, max UDMA/133
[    1.494100] ata2.00: 117231408 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    1.503634] ata2.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
[    1.503639] ata2.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
[    1.503643] ata2.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION OVERLAY) filtered out
[    1.514040] ata2.00: configured for UDMA/133
[    1.514217] scsi 1:0:0:0: Direct-Access     ATA      INTEL SSDSC2CW06 400i PQ: 0 ANSI: 5
[    1.165523] ACPI: Invalid Power Resource to register!
[    1.514391] sd 1:0:0:0: [sda] 117231408 512-byte logical blocks: (60.0 GB/55.8 GiB)
[    1.514632] sd 1:0:0:0: [sda] Write Protect is off
[    1.514635] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.514703] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.515263]  sda: sda1 sda2 sda3 sda4
[    1.515726] sd 1:0:0:0: [sda] Attached SCSI disk
[    1.545527] usb 1-1.2: new high-speed USB device number 3 using ehci_hcd
[    1.632026] usb 1-1.2: New USB device found, idVendor=0846, idProduct=9011
[    1.632030] usb 1-1.2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    1.632033] usb 1-1.2: Product: Remote Download Wireless Adapter
[    1.632035] usb 1-1.2: Manufacturer: Broadcom
[    1.632037] usb 1-1.2: SerialNumber: 0
[    1.744949] usb 2-1.6: new full-speed USB device number 3 using ehci_hcd
[    1.764810] tsc: Refined TSC clocksource calibration: 3392.304 MHz
[    1.764815] Switching to clocksource tsc
[    1.831210] usb 2-1.6: New USB device found, idVendor=19ff, idProduct=0231
[    1.831214] usb 2-1.6: New USB device strings: Mfr=0, Product=2, SerialNumber=0
[    1.831217] usb 2-1.6: Product: Dynex wireless combo
[    1.831297] ata6: SATA link down (SStatus 0 SControl 300)
[    1.831426] Freeing unused kernel memory: 452k freed
[    1.853098] emc: device handler registered
[    1.854003] rdac: device handler registered
[    1.854999] alua: device handler registered
[    1.855855] hp_sw: device handler registered
[    1.858373] udevd[113]: starting version 182
[    1.863357] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[    1.863390] ACPI: Power Button [PWRB]
[    1.863423] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    1.863458] ACPI: Power Button [PWRF]
[    1.866467] ACPI: Fan [FAN0] (off)
[    1.866812] ACPI: Fan [FAN1] (off)
[    1.866836] ACPI: Fan [FAN2] (off)
[    1.866856] ACPI: Fan [FAN3] (off)
[    1.866876] ACPI: Fan [FAN4] (off)
[    1.867588] xhci_hcd 0000:00:14.0: setting latency timer to 64
[    1.867591] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    1.867595] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 3
[    1.867677] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
[    1.867682] xhci_hcd 0000:00:14.0: irq 16, io mem 0xf7d20000
[    1.867720] xhci_hcd 0000:00:14.0: irq 42 for MSI/MSI-X
[    1.867764] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
[    1.867766] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.867767] usb usb3: Product: xHCI Host Controller
[    1.867768] usb usb3: Manufacturer: Linux 3.6.2 xhci_hcd
[    1.867769] usb usb3: SerialNumber: 0000:00:14.0
[    1.867881] xHCI xhci_add_endpoint called for root hub
[    1.867882] xHCI xhci_check_bandwidth called for root hub
[    1.867902] hub 3-0:1.0: USB hub found
[    1.867910] hub 3-0:1.0: 4 ports detected
[    1.867956] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    1.867958] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 4
[    1.867976] usb usb4: New USB device found, idVendor=1d6b, idProduct=0003
[    1.867977] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.867978] usb usb4: Product: xHCI Host Controller
[    1.867979] usb usb4: Manufacturer: Linux 3.6.2 xhci_hcd
[    1.867980] usb usb4: SerialNumber: 0000:00:14.0
[    1.868119] xHCI xhci_add_endpoint called for root hub
[    1.868120] xHCI xhci_check_bandwidth called for root hub
[    1.868137] hub 4-0:1.0: USB hub found
[    1.868145] hub 4-0:1.0: 4 ports detected
[    1.872960] input: Dynex wireless combo as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.6/2-1.6:1.0/input/input2
[    1.873302] hid-generic 0003:19FF:0231.0001: input,hidraw0: USB HID v1.11 Keyboard [Dynex wireless combo] on usb-0000:00:1d.0-1.6/input0
[    1.873427] input: Dynex wireless combo as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.6/2-1.6:1.1/input/input3
[    1.873555] hid-generic 0003:19FF:0231.0002: input,hidraw1: USB HID v1.11 Mouse [Dynex wireless combo] on usb-0000:00:1d.0-1.6/input1
[    1.875354] [drm] Initialized drm 1.1.0 20060810
[    1.891216] i915_pci_probe: Entered
[    1.891218] dropping agp requirement
[    1.891219] force-disabling agp on gen 7, is_ivybridge 1
[    1.891352] thermal LNXTHERM:00: registered as thermal_zone0
[    1.891354] ACPI: Thermal Zone [TZ00] (28 C)
[    1.891355] pci 0000:00:00.0: Intel Ivybridge Chipset
[    1.891386] pci 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
[    1.891480] thermal LNXTHERM:01: registered as thermal_zone1
[    1.891481] ACPI: Thermal Zone [TZ01] (30 C)
[    1.891945] pci 0000:00:00.0: detected 65536K stolen memory
[    1.892050] i915 0000:00:02.0: setting latency timer to 64
[    1.514436] ACPI: Invalid Power Resource to register!
[    1.892254] [drm:intel_detect_pch], Found PatherPoint PCH
[    1.892609] [drm:intel_gt_init], Using MT version of forcewake
[    1.892675] [drm:intel_opregion_setup], graphic opregion physical addr: 0xda407018
[    1.892679] [drm:intel_opregion_setup], SWSCI supported
[    1.892696] i915 0000:00:02.0: irq 43 for MSI/MSI-X
[    1.892701] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    1.892702] [drm] Driver supports precise vblank timestamp query.
[    1.892703] [drm:init_vbt_defaults], Set default to SSC at 100MHz
[    1.892705] [drm:intel_parse_bios], Using VBT from OpRegion: $VBT SNB/IVB-DESKTOPd
[    1.892706] [drm:parse_general_features], BDB_GENERAL_FEATURES int_tv_support 0 int_crt_support 1 lvds_use_ssc 0 lvds_ssc_freq 120 display_clock_mode 0
[    1.892707] [drm:parse_general_definitions], crt_ddc_bus_pin: 5
[    1.892709] [drm:parse_lfp_panel_data], Found panel mode in BIOS VBT tables:
[    1.892711] [drm:drm_mode_debug_printmodeline], Modeline 0:"1024x768" 0 65000 1024 1048 1184 1344 768 771 777 806 0x8 0xa
[    1.892713] [drm:parse_lfp_panel_data], VBT initial LVDS value 300
[    1.892714] [drm:parse_sdvo_panel_data], Found SDVO panel mode in BIOS VBT tables:
[    1.892715] [drm:drm_mode_debug_printmodeline], Modeline 0:"1600x1200" 0 162000 1600 1664 1856 2160 1200 1201 1204 1250 0x8 0xa
[    1.892717] [drm:parse_sdvo_device_mapping], No SDVO device info is found in VBT
[    1.892761] [drm:intel_modeset_init], 3 display pipes available.
[    1.892771] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    1.893078] [drm:intel_lvds_init], LVDS is not present in VBT
[    1.893103] [drm:intel_crt_init], pch crt adpa set to 0x80f40010
[    1.893527] [drm:intel_sdvo_read_byte], i2c transfer returned -6
[    1.893528] [drm:intel_sdvo_init], No SDVO device found on SDVOB
[    1.893566] [drm:intel_dp_i2c_init], i2c_init DPDDC-B
[    1.896150] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    1.896151] [drm:intel_dp_i2c_aux_ch], aux_ch failed -110
[    1.898712] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    1.898712] [drm:intel_dp_i2c_aux_ch], aux_ch failed -110
[    1.898761] [drm:intel_dp_i2c_init], i2c_init DPDDC-C
[    1.901323] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    1.901324] [drm:intel_dp_i2c_aux_ch], aux_ch failed -110
[    1.903895] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    1.903895] [drm:intel_dp_i2c_aux_ch], aux_ch failed -110
[    1.903920] [drm:intel_dp_i2c_init], i2c_init DPDDC-D
[    1.906492] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    1.906493] [drm:intel_dp_i2c_aux_ch], aux_ch failed -110
[    1.909088] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    1.909089] [drm:intel_dp_i2c_aux_ch], aux_ch failed -110
[    1.909120] [drm:ironlake_crtc_dpms], crtc 0/0 dpms off
[    1.909122] [drm:i915_get_vblank_timestamp], crtc 0 is disabled
[    1.941183] [drm:ironlake_crtc_dpms], crtc 1/1 dpms off
[    1.941186] [drm:gm45_get_vblank_counter], trying to get vblank count for disabled pipe B
[    1.941187] [drm:i915_get_vblank_timestamp], crtc 1 is disabled
[    1.941188] [drm:gm45_get_vblank_counter], trying to get vblank count for disabled pipe B
[    1.941629] [drm:ironlake_crtc_dpms], crtc 2/2 dpms off
[    1.941630] [drm:gm45_get_vblank_counter], trying to get vblank count for disabled pipe C
[    1.941631] [drm:i915_get_vblank_timestamp], crtc 2 is disabled
[    1.941632] [drm:gm45_get_vblank_counter], trying to get vblank count for disabled pipe C
[    1.942068] [drm:ironlake_init_pch_refclk], has_panel 0 has_lvds 0 has_pch_edp 0 has_cpu_edp 0 has_ck505 0
[    1.942073] [drm:ironlake_init_pch_refclk], Disabling SSC entirely
[    1.966061] [drm:init_status_page], render ring hws offset: 0x00000000
[    1.966410] [drm:init_status_page], bsd ring hws offset: 0x00022000
[    1.966451] [drm:init_status_page], blitter ring hws offset: 0x00043000
[    1.966497] [drm:create_default_context], Default HW context loaded
[    1.966498] [drm:i915_gem_context_init], HW context support initialized
[    1.966554] [drm:intel_enable_rc6], RC6 and deep RC6 enabled
[    1.966555] [drm] Enabling RC6 states: RC6 on, RC6p on, RC6pp off
[    2.083959] [drm:drm_fb_helper_parse_command_line], cmdline mode for connector VGA-1 1024x768@60Hz
[    2.083962] [drm:drm_fb_helper_parse_command_line], cmdline mode for connector HDMI-A-1 1024x768@60Hz
[    2.083964] [drm:drm_fb_helper_parse_command_line], cmdline mode for connector DP-1 1024x768@60Hz
[    2.083966] [drm:drm_fb_helper_parse_command_line], cmdline mode for connector HDMI-A-2 1024x768@60Hz
[    2.083967] [drm:drm_fb_helper_parse_command_line], cmdline mode for connector HDMI-A-3 1024x768@60Hz
[    2.083968] [drm:drm_fb_helper_parse_command_line], cmdline mode for connector DP-2 1024x768@60Hz
[    2.083970] [drm:drm_fb_helper_parse_command_line], cmdline mode for connector DP-3 1024x768@60Hz
[    2.083971] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1]
[    2.083976] [drm:intel_ironlake_crt_detect_hotplug], trigger hotplug detect cycle: adpa=0xf40010
[    2.097200] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40010, result 0
[    2.097204] [drm:intel_crt_detect], CRT not detected via hotplug
[    2.140459] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    2.140515] Raw EDID:
[    2.140560]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    2.140612]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.140661]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.140713]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.140764]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.140815]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.140867]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.140919]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.182832] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    2.182884] Raw EDID:
[    2.182954]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    2.183025]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.183099]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.183171]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.183245]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.183319]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.183392]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.183466]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.225456] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    2.225556] Raw EDID:
[    2.225625]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    2.225699]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.225771]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.225845]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.225917]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.225991]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.226064]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.226138]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.268113] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    2.268213] Raw EDID:
[    2.268282]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    2.268356]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.268427]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.268501]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.268575]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.268648]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.268722]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.268794]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.268869] i915 0000:00:02.0: VGA-1: EDID block 0 invalid.
[    2.268870] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[    2.268871] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1] disconnected
[    2.268873] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:HDMI-A-1]
[    2.312132] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    2.312231] Raw EDID:
[    2.312297]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    2.312372]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.312446]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.312520]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.312594]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.312668]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.312741]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.312815]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.354804] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    2.354903] Raw EDID:
[    2.354973]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    2.355046]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.355120]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.355194]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.355268]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.355341]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.355414]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.355488]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.397488] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    2.397587] Raw EDID:
[    2.397655]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    2.397729]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.397800]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.397874]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.397948]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.398023]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.398096]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.398168]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.440118] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    2.440218] Raw EDID:
[    2.440286]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    2.440360]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.440431]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.440506]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.440579]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.440653]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.440726]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.440801]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.440876] i915 0000:00:02.0: HDMI-A-1: EDID block 0 invalid.
[    2.440877] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:HDMI-A-1] disconnected
[    2.440878] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:DP-1]
[    2.443481] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    2.452123] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    2.458770] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    2.462813] [drm:intel_dp_detect], DPCD: 0000000000000000
[    2.462819] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:DP-1] disconnected
[    2.462823] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:HDMI-A-2]
[    2.469467] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
[    2.469473] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[    2.469476] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:HDMI-A-2] disconnected
[    2.469479] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:HDMI-A-3]
[    2.476114] [drm:gmbus_xfer], GMBUS [i915 gmbus dpd] NAK for addr: 0050 r(1)
[    2.476119] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpd
[    2.476122] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:HDMI-A-3] disconnected
[    2.476125] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-2]
[    2.478726] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    2.485359] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    2.492005] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    2.496050] [drm:intel_dp_detect], DPCD: 0000000000000000
[    2.496056] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-2] disconnected
[    2.496060] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-3]
[    2.498657] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    2.505303] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    2.511950] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    2.515994] [drm:intel_dp_detect], DPCD: 0000000000000000
[    2.515999] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-3] disconnected
[    2.516002] No connectors reported connected with modes
[    2.516004] [drm:drm_setup_crtcs], 
[    2.516007] [drm:drm_enable_connectors], connector 9 enabled? no
[    2.516009] [drm:drm_enable_connectors], connector 12 enabled? no
[    2.516011] [drm:drm_enable_connectors], connector 15 enabled? no
[    2.516013] [drm:drm_enable_connectors], connector 18 enabled? no
[    2.516015] [drm:drm_enable_connectors], connector 20 enabled? no
[    2.516017] [drm:drm_enable_connectors], connector 21 enabled? no
[    2.516018] [drm:drm_enable_connectors], connector 23 enabled? no
[    2.516020] [drm:drm_setup_crtcs], picking CRTCs for 8192x8192 config
[    2.516031] [drm] Cannot find any crtc or sizes - going 1024x768
[    2.518288] [drm:intelfb_create], allocated 1024x768 fb: 0x00073000, bo f4e12e00
[    2.518402] fbcon: inteldrmfb (fb0) is primary device
[    2.518774] [drm:drm_crtc_helper_set_config], 
[    2.518775] [drm:drm_crtc_helper_set_config], [CRTC:3] [NOFB]
[    2.518797] [drm:drm_crtc_helper_set_config], 
[    2.518797] [drm:drm_crtc_helper_set_config], [CRTC:5] [NOFB]
[    2.518817] [drm:drm_crtc_helper_set_config], 
[    2.518817] [drm:drm_crtc_helper_set_config], [CRTC:7] [NOFB]
[    2.520404] Console: switching to colour frame buffer device 128x48
[    2.521971] fb0: inteldrmfb frame buffer device
[    2.521972] drm: registered panic notifier
[    2.546204] acpi device:4b: registered as cooling_device9
[    2.546302] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[    2.546333] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input4
[    2.546413] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    2.565958] [drm:i915_driver_open], 
[    2.565968] [drm:drm_crtc_helper_set_config], 
[    2.565969] [drm:drm_crtc_helper_set_config], [CRTC:3] [NOFB]
[    2.565992] [drm:drm_crtc_helper_set_config], 
[    2.565993] [drm:drm_crtc_helper_set_config], [CRTC:5] [NOFB]
[    2.566013] [drm:drm_crtc_helper_set_config], 
[    2.566014] [drm:drm_crtc_helper_set_config], [CRTC:7] [NOFB]
[    2.566040] [drm:i915_driver_open], 
[    2.566044] [drm:drm_crtc_helper_set_config], 
[    2.566045] [drm:drm_crtc_helper_set_config], [CRTC:3] [NOFB]
[    2.566065] [drm:drm_crtc_helper_set_config], 
[    2.566066] [drm:drm_crtc_helper_set_config], [CRTC:5] [NOFB]
[    2.566085] [drm:drm_crtc_helper_set_config], 
[    2.566086] [drm:drm_crtc_helper_set_config], [CRTC:7] [NOFB]
[    2.566110] [drm:i915_driver_open], 
[    2.566136] [drm:drm_mode_getresources], CRTC[3] CONNECTORS[7] ENCODERS[7]
[    2.566139] [drm:drm_mode_getresources], CRTC[3] CONNECTORS[7] ENCODERS[7]
[    2.566144] [drm:drm_mode_getconnector], [CONNECTOR:9:?]
[    2.566145] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1]
[    2.566150] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40010, result 0
[    2.566151] [drm:intel_crt_detect], CRT not detected via hotplug
[    2.609469] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    2.609500] Raw EDID:
[    2.609510]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    2.609531]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.609551]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.609572]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.609592]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.609612]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.609633]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.609653]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.651510] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    2.651537] Raw EDID:
[    2.651547]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    2.651567]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.651588]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.651608]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.651628]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.651648]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.651668]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.651689]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.693715] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    2.693742] Raw EDID:
[    2.693752]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    2.693772]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.694203]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.694636]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.695051]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.695449]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.695842]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.696220]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.738456] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    2.738863] Raw EDID:
[    2.739266]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    2.739700]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.740135]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.740568]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.741001]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.741420]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.741818]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.742213]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.742593] i915 0000:00:02.0: VGA-1: EDID block 0 invalid.
[    2.742594] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[    2.742595] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1] disconnected
[    2.742598] [drm:drm_mode_getconnector], [CONNECTOR:9:?]
[    2.742599] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1]
[    2.742603] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40010, result 0
[    2.742604] [drm:intel_crt_detect], CRT not detected via hotplug
[    2.785860] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    2.786264] Raw EDID:
[    2.786672]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    2.787107]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.787542]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.787979]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.788414]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.788851]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.789267]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.789665]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.831922] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    2.832329] Raw EDID:
[    2.832739]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    2.833173]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.833611]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.834048]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.834485]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.834922]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.835341]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.835741]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.877936] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    2.878347] Raw EDID:
[    2.878756]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    2.879192]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.879629]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.880067]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.880504]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.880941]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.881360]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.881760]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.924045] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    2.924455] Raw EDID:
[    2.924861]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    2.925293]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.925730]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.926167]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.926604]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.927038]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.927452]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.927849]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.928230] i915 0000:00:02.0: VGA-1: EDID block 0 invalid.
[    2.928230] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[    2.928231] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1] disconnected
[    2.928234] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[    2.928236] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:HDMI-A-1]
[    2.971514] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    2.971917] Raw EDID:
[    2.972322]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    2.972755]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.973188]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.973622]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.974056]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.974491]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.974907]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.975300]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.017625] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    3.018029] Raw EDID:
[    3.018437]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    3.018872]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.019309]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.019745]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.020181]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.020617]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.021033]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.021428]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.063638] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    3.064042] Raw EDID:
[    3.064447]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    3.064878]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.065310]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.065746]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.066180]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.066614]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.067029]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.067429]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.109741] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    3.110146] Raw EDID:
[    3.110552]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    3.110985]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.111420]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.111855]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.112290]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.112728]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.113144]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.113544]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.113927] i915 0000:00:02.0: HDMI-A-1: EDID block 0 invalid.
[    3.113928] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:HDMI-A-1] disconnected
[    3.113930] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[    3.113931] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:HDMI-A-1]
[    3.157208] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    3.157616] Raw EDID:
[    3.158024]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    3.158459]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.158895]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.159330]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.159766]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.160202]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.160621]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.161019]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.203270] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    3.203676] Raw EDID:
[    3.204084]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    3.204519]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.204956]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.205391]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.205827]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.206262]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.206677]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.207069]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.249336] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    3.249737] Raw EDID:
[    3.250139]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    3.250572]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.251006]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.251440]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.251872]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.252305]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.252721]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.253117]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.295398] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    3.295801] Raw EDID:
[    3.296208]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    3.296640]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.297075]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.297510]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.297944]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.298380]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.298796]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.299190]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.299571] i915 0000:00:02.0: HDMI-A-1: EDID block 0 invalid.
[    3.299572] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:HDMI-A-1] disconnected
[    3.299575] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
[    3.299576] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:DP-1]
[    3.302182] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    3.309668] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    3.316315] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    3.320364] [drm:intel_dp_detect], DPCD: 0000000000000000
[    3.320371] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:DP-1] disconnected
[    3.320379] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
[    3.320382] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:DP-1]
[    3.322981] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    3.329610] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    3.336257] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    3.340308] [drm:intel_dp_detect], DPCD: 0000000000000000
[    3.340314] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:DP-1] disconnected
[    3.340325] [drm:drm_mode_getconnector], [CONNECTOR:18:?]
[    3.340328] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:HDMI-A-2]
[    3.346962] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
[    3.346967] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[    3.346971] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:HDMI-A-2] disconnected
[    3.346978] [drm:drm_mode_getconnector], [CONNECTOR:18:?]
[    3.346989] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:HDMI-A-2]
[    3.353611] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
[    3.353617] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[    3.353621] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:HDMI-A-2] disconnected
[    3.353637] [drm:drm_mode_getconnector], [CONNECTOR:20:?]
[    3.353639] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:HDMI-A-3]
[    3.360259] [drm:gmbus_xfer], GMBUS [i915 gmbus dpd] NAK for addr: 0050 r(1)
[    3.360265] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpd
[    3.360268] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:HDMI-A-3] disconnected
[    3.360284] [drm:drm_mode_getconnector], [CONNECTOR:20:?]
[    3.360285] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:HDMI-A-3]
[    3.366905] [drm:gmbus_xfer], GMBUS [i915 gmbus dpd] NAK for addr: 0050 r(1)
[    3.366910] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpd
[    3.366914] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:HDMI-A-3] disconnected
[    3.366932] [drm:drm_mode_getconnector], [CONNECTOR:21:?]
[    3.366933] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-2]
[    3.369537] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    3.376143] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    3.382791] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    3.386842] [drm:intel_dp_detect], DPCD: 0000000000000000
[    3.386848] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-2] disconnected
[    3.386856] [drm:drm_mode_getconnector], [CONNECTOR:21:?]
[    3.386859] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-2]
[    3.389475] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    3.396086] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    3.402733] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    3.406786] [drm:intel_dp_detect], DPCD: 0000000000000000
[    3.406792] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-2] disconnected
[    3.406803] [drm:drm_mode_getconnector], [CONNECTOR:23:?]
[    3.406806] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-3]
[    3.409423] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    3.416029] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    3.422677] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    3.426729] [drm:intel_dp_detect], DPCD: 0000000000000000
[    3.426735] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-3] disconnected
[    3.426743] [drm:drm_mode_getconnector], [CONNECTOR:23:?]
[    3.426746] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-3]
[    3.429366] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    3.435972] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    3.442620] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    3.446670] [drm:intel_dp_detect], DPCD: 0000000000000000
[    3.446676] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-3] disconnected
[    3.446714] [drm:drm_crtc_helper_set_config], 
[    3.446715] [drm:drm_crtc_helper_set_config], [CRTC:3] [NOFB]
[    3.446738] [drm:drm_crtc_helper_set_config], 
[    3.446739] [drm:drm_crtc_helper_set_config], [CRTC:5] [NOFB]
[    3.446758] [drm:drm_crtc_helper_set_config], 
[    3.446759] [drm:drm_crtc_helper_set_config], [CRTC:7] [NOFB]
[    3.987748] EXT4-fs (sda4): mounted filesystem with ordered data mode. Opts: acl,user_xattr
[    4.002047] EXT4-fs (sda4): re-mounted. Opts: acl,user_xattr
[    4.280032] systemd-readahead-replay[281]: Bumped block_nr parameter of 8:0 to 16384. This is a temporary hack and should be removed one day.
[    4.679364] udevd[313]: starting version 182
[    4.747528] microcode: CPU0 sig=0x306a9, pf=0x2, revision=0x12
[    4.748803] microcode: CPU1 sig=0x306a9, pf=0x2, revision=0x12
[    4.749093] microcode: CPU2 sig=0x306a9, pf=0x2, revision=0x12
[    4.749266] microcode: CPU3 sig=0x306a9, pf=0x2, revision=0x12
[    4.749521] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    4.845766] EXT4-fs (sda4): re-mounted. Opts: acl,user_xattr
[    4.882785] BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
[    5.125780] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    5.126203] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    5.127169] e1000e: Intel(R) PRO/1000 Network Driver - 2.0.0-k
[    5.127170] e1000e: Copyright(c) 1999 - 2012 Intel Corporation.
[    5.127198] e1000e 0000:00:19.0: setting latency timer to 64
[    5.127240] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[    5.127289] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[    5.136898] scsi 0:0:0:0: Attached scsi generic sg0 type 5
[    5.136921] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    5.139567] input: PC Speaker as /devices/platform/pcspkr/input/input5
[    5.147374] kvm: disabled by bios
[    5.151397] sr0: scsi3-mmc drive: 40x/40x writer dvd-ram cd/rw xa/form2 cdda tray
[    5.151398] cdrom: Uniform CD-ROM driver Revision: 3.20
[    5.151496] sr 0:0:0:0: Attached scsi CD-ROM sr0
[    5.165752] kvm: disabled by bios
[    5.306607] Adding 4193276k swap on /dev/sda3.  Priority:-1 extents:1 across:4193276k SS
[    5.382370] e1000e 0000:00:19.0: eth0: (PCI Express:2.5GT/s:Width x1) e8:40:f2:05:f1:85
[    5.382373] e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    5.382418] e1000e 0000:00:19.0: eth0: MAC: 10, PHY: 11, PBA No: FFFFFF-0FF
[    5.382491] ACPI Warning: 0x00000428-0x0000042f SystemIO conflicts with Region \PMIO 1 (20120711/utaddress-251)
[    5.382495] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    5.382497] ACPI Warning: 0x00000500-0x0000053f SystemIO conflicts with Region \GPIO 1 (20120711/utaddress-251)
[    5.382500] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    5.382500] lpc_ich: Resource conflict(s) found affecting gpio_ich
[    5.382525] ACPI Warning: 0x0000f040-0x0000f05f SystemIO conflicts with Region \_SB_.PCI0.SBUS.SMBI 1 (20120711/utaddress-251)
[    5.382528] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    5.427121] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: acl,user_xattr
[    6.306683] [drm:i915_driver_open], 
[    6.306704] [drm:drm_crtc_helper_set_config], 
[    6.306706] [drm:drm_crtc_helper_set_config], [CRTC:3] [NOFB]
[    6.306730] [drm:drm_crtc_helper_set_config], 
[    6.306731] [drm:drm_crtc_helper_set_config], [CRTC:5] [NOFB]
[    6.306750] [drm:drm_crtc_helper_set_config], 
[    6.306750] [drm:drm_crtc_helper_set_config], [CRTC:7] [NOFB]
[    6.306787] [drm:i915_driver_open], 
[    6.307219] [drm:drm_mode_getresources], CRTC[3] CONNECTORS[7] ENCODERS[7]
[    6.307223] [drm:drm_mode_getresources], CRTC[3] CONNECTORS[7] ENCODERS[7]
[    6.307254] [drm:drm_mode_getconnector], [CONNECTOR:9:?]
[    6.307256] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1]
[    6.307261] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40010, result 0
[    6.307262] [drm:intel_crt_detect], CRT not detected via hotplug
[    6.350644] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    6.350646] Raw EDID:
[    6.350647]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    6.350648]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.350648]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.350649]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.350650]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.350650]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.350651]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.350652]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.392587] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    6.392588] Raw EDID:
[    6.392588]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    6.392589]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.392590]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.392590]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.392591]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.392592]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.392592]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.392593]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.434353] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    6.434353] Raw EDID:
[    6.434354]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    6.434354]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.434355]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.434356]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.434356]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.434357]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.434358]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.434358]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.476073] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    6.476073] Raw EDID:
[    6.476074]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    6.476075]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.476075]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.476076]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.476077]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.476077]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.476078]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.476079]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.476081] i915 0000:00:02.0: VGA-1: EDID block 0 invalid.
[    6.476082] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[    6.476084] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1] disconnected
[    6.476089] [drm:drm_mode_getconnector], [CONNECTOR:9:?]
[    6.476091] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1]
[    6.476093] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40010, result 0
[    6.476094] [drm:intel_crt_detect], CRT not detected via hotplug
[    6.491392] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[    6.519396] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    6.519397] Raw EDID:
[    6.519398]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    6.519398]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.519399]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.519400]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.519400]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.519401]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.519402]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.519402]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.561289] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    6.561289] Raw EDID:
[    6.561290]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    6.561291]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.561291]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.561292]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.561293]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.561293]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.561294]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.561295]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.594367] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[    6.594443] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[    6.603647] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    6.603647] Raw EDID:
[    6.603648]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    6.603649]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.603650]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.603650]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.603651]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.603652]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.603652]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.603653]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.645588] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    6.645589] Raw EDID:
[    6.645590]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    6.645590]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.645591]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.645592]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.645592]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.645593]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.645594]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.645594]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.645596] i915 0000:00:02.0: VGA-1: EDID block 0 invalid.
[    6.645597] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[    6.645599] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1] disconnected
[    6.645637] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[    6.645639] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:HDMI-A-1]
[    6.688944] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    6.688945] Raw EDID:
[    6.688946]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    6.688947]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.688947]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.688948]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.688949]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.688949]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.688950]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.688951]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.730879] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    6.730879] Raw EDID:
[    6.730880]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    6.730881]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.730881]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.730882]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.730883]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.730883]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.730884]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.730885]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.772771] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    6.772772] Raw EDID:
[    6.772773]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    6.772774]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.772774]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.772775]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.772776]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.772776]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.772777]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.772778]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.808793] RPC: Registered named UNIX socket transport module.
[    6.808796] RPC: Registered udp transport module.
[    6.808796] RPC: Registered tcp transport module.
[    6.808797] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    6.810967] FS-Cache: Loaded
[    6.813670] FS-Cache: Netfs 'nfs' registered for caching
[    6.814709] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    6.814710] Raw EDID:
[    6.814711]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    6.814711]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.814712]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.814713]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.814713]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.814714]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.814715]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.814715]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.814717] i915 0000:00:02.0: HDMI-A-1: EDID block 0 invalid.
[    6.814719] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:HDMI-A-1] disconnected
[    6.814725] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[    6.814727] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:HDMI-A-1]
[    6.858081] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    6.858081] Raw EDID:
[    6.858082]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    6.858083]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.858084]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.858084]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.858085]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.858086]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.858086]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.858087]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.899941] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    6.899942] Raw EDID:
[    6.899943]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    6.899943]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.899944]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.899945]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.899945]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.899946]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.899947]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.899947]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.941826] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    6.941827] Raw EDID:
[    6.941827]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    6.941828]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.941829]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.941829]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.941830]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.941831]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.941831]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.941832]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.983795] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    6.983796] Raw EDID:
[    6.983797]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    6.983798]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.983798]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.983799]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.983800]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.983800]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.983801]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.983802]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.983804] i915 0000:00:02.0: HDMI-A-1: EDID block 0 invalid.
[    6.983805] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:HDMI-A-1] disconnected
[    6.983832] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
[    6.983834] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:DP-1]
[    6.986442] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    6.992465] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    6.999116] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    7.003163] [drm:intel_dp_detect], DPCD: 0000000000000000
[    7.003168] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:DP-1] disconnected
[    7.003176] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
[    7.003178] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:DP-1]
[    7.005781] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    7.012408] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    7.019077] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    7.023121] [drm:intel_dp_detect], DPCD: 0000000000000000
[    7.023128] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:DP-1] disconnected
[    7.023173] [drm:drm_mode_getconnector], [CONNECTOR:18:?]
[    7.023175] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:HDMI-A-2]
[    7.029783] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
[    7.029789] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[    7.029792] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:HDMI-A-2] disconnected
[    7.029809] [drm:drm_mode_getconnector], [CONNECTOR:18:?]
[    7.029810] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:HDMI-A-2]
[    7.036413] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
[    7.036415] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[    7.036418] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:HDMI-A-2] disconnected
[    7.036449] [drm:drm_mode_getconnector], [CONNECTOR:20:?]
[    7.036451] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:HDMI-A-3]
[    7.043048] [drm:gmbus_xfer], GMBUS [i915 gmbus dpd] NAK for addr: 0050 r(1)
[    7.043051] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpd
[    7.043053] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:HDMI-A-3] disconnected
[    7.043057] [drm:drm_mode_getconnector], [CONNECTOR:20:?]
[    7.043059] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:HDMI-A-3]
[    7.049696] [drm:gmbus_xfer], GMBUS [i915 gmbus dpd] NAK for addr: 0050 r(1)
[    7.049699] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpd
[    7.049701] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:HDMI-A-3] disconnected
[    7.049726] [drm:drm_mode_getconnector], [CONNECTOR:21:?]
[    7.049728] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-2]
[    7.052337] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    7.058954] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    7.065589] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    7.069656] [drm:intel_dp_detect], DPCD: 0000000000000000
[    7.069660] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-2] disconnected
[    7.069667] [drm:drm_mode_getconnector], [CONNECTOR:21:?]
[    7.069668] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-2]
[    7.072280] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    7.078883] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    7.085550] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    7.089591] [drm:intel_dp_detect], DPCD: 0000000000000000
[    7.089595] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-2] disconnected
[    7.089631] [drm:drm_mode_getconnector], [CONNECTOR:23:?]
[    7.089633] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-3]
[    7.092242] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    7.098849] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    7.105471] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    7.109533] [drm:intel_dp_detect], DPCD: 0000000000000000
[    7.109536] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-3] disconnected
[    7.109543] [drm:drm_mode_getconnector], [CONNECTOR:23:?]
[    7.109544] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-3]
[    7.112143] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    7.118773] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    7.125417] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    7.129478] [drm:intel_dp_detect], DPCD: 0000000000000000
[    7.129482] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-3] disconnected
[    7.129526] [drm:drm_mode_getconnector], [CONNECTOR:9:?]
[    7.129528] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1]
[    7.129533] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40010, result 0
[    7.129534] [drm:intel_crt_detect], CRT not detected via hotplug
[    7.173621] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    7.173623] Raw EDID:
[    7.173625]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    7.173625]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.173626]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.173627]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.173627]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.173628]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.173629]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.173629]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.215435] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    7.215437] Raw EDID:
[    7.215438]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    7.215438]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.215439]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.215440]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.215440]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.215441]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.215442]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.215442]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.257283] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    7.257284] Raw EDID:
[    7.257285]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    7.257285]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.257286]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.257287]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.257287]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.257288]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.257289]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.257289]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.299121] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    7.299121] Raw EDID:
[    7.299122]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    7.299123]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.299123]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.299124]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.299125]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.299125]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.299126]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.299127]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.299129] i915 0000:00:02.0: VGA-1: EDID block 0 invalid.
[    7.299131] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[    7.299133] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1] disconnected
[    7.299140] [drm:drm_mode_getconnector], [CONNECTOR:9:?]
[    7.299142] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1]
[    7.299147] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40010, result 0
[    7.299148] [drm:intel_crt_detect], CRT not detected via hotplug
[    7.342406] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    7.342407] Raw EDID:
[    7.342407]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    7.342408]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.342409]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.342409]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.342410]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.342411]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.342411]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.342412]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.384275] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    7.384276] Raw EDID:
[    7.384276]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    7.384277]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.384278]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.384278]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.384279]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.384280]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.384280]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.384281]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.426203] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    7.426204] Raw EDID:
[    7.426205]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    7.426205]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.426206]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.426207]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.426207]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.426208]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.426209]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.426209]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.468085] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    7.468086] Raw EDID:
[    7.468086]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    7.468087]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.468088]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.468088]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.468089]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.468090]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.468090]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.468091]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.468092] i915 0000:00:02.0: VGA-1: EDID block 0 invalid.
[    7.468093] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[    7.468094] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1] disconnected
[    7.468126] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[    7.468128] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:HDMI-A-1]
[    7.511433] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    7.511433] Raw EDID:
[    7.511434]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    7.511435]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.511435]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.511436]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.511437]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.511437]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.511438]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.511439]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.553339] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    7.553340] Raw EDID:
[    7.553341]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    7.553341]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.553342]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.553342]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.553343]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.553344]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.553344]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.553345]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.595233] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    7.595234] Raw EDID:
[    7.595234]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    7.595235]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.595236]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.595236]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.595237]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.595238]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.595238]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.595239]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.637116] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    7.637116] Raw EDID:
[    7.637117]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    7.637117]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.637118]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.637119]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.637119]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.637120]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.637121]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.637121]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.637123] i915 0000:00:02.0: HDMI-A-1: EDID block 0 invalid.
[    7.637124] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:HDMI-A-1] disconnected
[    7.637125] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[    7.637126] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:HDMI-A-1]
[    7.680481] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    7.680481] Raw EDID:
[    7.680482]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    7.680483]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.680483]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.680484]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.680485]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.680486]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.680486]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.680487]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.722337] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    7.722338] Raw EDID:
[    7.722338]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    7.722339]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.722340]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.722340]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.722341]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.722342]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.722342]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.722343]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.764238] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    7.764239] Raw EDID:
[    7.764239]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    7.764240]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.764241]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.764241]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.764242]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.764243]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.764243]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.764244]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.806111] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    7.806112] Raw EDID:
[    7.806112]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    7.806113]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.806114]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.806114]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.806115]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.806116]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.806116]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.806117]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.806118] i915 0000:00:02.0: HDMI-A-1: EDID block 0 invalid.
[    7.806119] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:HDMI-A-1] disconnected
[    7.806132] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
[    7.806133] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:DP-1]
[    7.808734] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    7.820098] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    7.830086] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    7.834137] [drm:intel_dp_detect], DPCD: 0000000000000000
[    7.834143] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:DP-1] disconnected
[    7.834151] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
[    7.834154] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:DP-1]
[    7.836775] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    7.843383] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    7.850030] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    7.854079] [drm:intel_dp_detect], DPCD: 0000000000000000
[    7.854086] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:DP-1] disconnected
[    7.854125] [drm:drm_mode_getconnector], [CONNECTOR:18:?]
[    7.854127] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:HDMI-A-2]
[    7.860735] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
[    7.860741] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[    7.860745] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:HDMI-A-2] disconnected
[    7.860761] [drm:drm_mode_getconnector], [CONNECTOR:18:?]
[    7.860763] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:HDMI-A-2]
[    7.867383] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
[    7.867389] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[    7.867393] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:HDMI-A-2] disconnected
[    7.867426] [drm:drm_mode_getconnector], [CONNECTOR:20:?]
[    7.867428] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:HDMI-A-3]
[    7.874030] [drm:gmbus_xfer], GMBUS [i915 gmbus dpd] NAK for addr: 0050 r(1)
[    7.874036] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpd
[    7.874040] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:HDMI-A-3] disconnected
[    7.874048] [drm:drm_mode_getconnector], [CONNECTOR:20:?]
[    7.874058] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:HDMI-A-3]
[    7.880680] [drm:gmbus_xfer], GMBUS [i915 gmbus dpd] NAK for addr: 0050 r(1)
[    7.880685] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpd
[    7.880689] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:HDMI-A-3] disconnected
[    7.880723] [drm:drm_mode_getconnector], [CONNECTOR:21:?]
[    7.880724] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-2]
[    7.883330] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    7.889915] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    7.896567] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    7.900613] [drm:intel_dp_detect], DPCD: 0000000000000000
[    7.900619] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-2] disconnected
[    7.900627] [drm:drm_mode_getconnector], [CONNECTOR:21:?]
[    7.900630] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-2]
[    7.903230] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    7.909858] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    7.916506] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    7.920556] [drm:intel_dp_detect], DPCD: 0000000000000000
[    7.920562] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-2] disconnected
[    7.920601] [drm:drm_mode_getconnector], [CONNECTOR:23:?]
[    7.920603] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-3]
[    7.923214] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    7.929800] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    7.936448] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    7.940499] [drm:intel_dp_detect], DPCD: 0000000000000000
[    7.940505] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-3] disconnected
[    7.940513] [drm:drm_mode_getconnector], [CONNECTOR:23:?]
[    7.940516] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-3]
[    7.943116] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    7.949744] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    7.956391] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    7.960459] [drm:intel_dp_detect], DPCD: 0000000000000000
[    7.960465] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-3] disconnected
[    7.981951] [drm:drm_mode_setcrtc], [CRTC:3]
[    7.981954] [drm:drm_crtc_helper_set_config], 
[    7.981955] [drm:drm_crtc_helper_set_config], [CRTC:3] [NOFB]
[    7.981980] [drm:drm_mode_setcrtc], [CRTC:5]
[    7.981981] [drm:drm_crtc_helper_set_config], 
[    7.981982] [drm:drm_crtc_helper_set_config], [CRTC:5] [NOFB]
[    7.982003] [drm:drm_mode_setcrtc], [CRTC:7]
[    7.982004] [drm:drm_crtc_helper_set_config], 
[    7.982005] [drm:drm_crtc_helper_set_config], [CRTC:7] [NOFB]
[    8.093811] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Control: Rx/Tx
[    8.093815] e1000e 0000:00:19.0: eth0: 10/100 speed: disabling TSO
[    8.093848] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[    8.295421] [drm:drm_mode_getconnector], [CONNECTOR:9:?]
[    8.295425] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1]
[    8.295431] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40010, result 0
[    8.295432] [drm:intel_crt_detect], CRT not detected via hotplug
[    8.338769] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    8.338770] Raw EDID:
[    8.338772]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    8.338772]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.338773]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.338774]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.338774]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.338775]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.338776]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.338776]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.380685] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    8.380685] Raw EDID:
[    8.380686]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    8.380687]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.380687]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.380688]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.380689]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.380689]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.380690]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.380691]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.422558] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    8.422558] Raw EDID:
[    8.422559]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    8.422559]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.422560]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.422561]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.422561]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.422562]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.422563]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.422563]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.464493] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    8.464494] Raw EDID:
[    8.464494]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    8.464495]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.464496]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.464496]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.464497]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.464498]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.464498]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.464499]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.464501] i915 0000:00:02.0: VGA-1: EDID block 0 invalid.
[    8.464502] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[    8.464504] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1] disconnected
[    8.464509] [drm:drm_mode_getconnector], [CONNECTOR:9:?]
[    8.464510] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1]
[    8.464515] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40010, result 0
[    8.464516] [drm:intel_crt_detect], CRT not detected via hotplug
[    8.507802] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    8.507802] Raw EDID:
[    8.507803]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    8.507804]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.507804]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.507805]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.507806]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.507806]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.507807]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.507808]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.549680] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    8.549680] Raw EDID:
[    8.549681]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    8.549682]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.549682]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.549683]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.549684]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.549684]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.549685]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.549686]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.591578] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    8.591578] Raw EDID:
[    8.591579]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    8.591580]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.591580]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.591581]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.591582]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.591582]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.591583]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.591584]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.633518] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    8.633518] Raw EDID:
[    8.633519]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    8.633520]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.633520]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.633521]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.633522]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.633522]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.633523]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.633524]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.633525] i915 0000:00:02.0: VGA-1: EDID block 0 invalid.
[    8.633525] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[    8.633526] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1] disconnected
[    8.633535] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[    8.633536] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:HDMI-A-1]
[    8.676866] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    8.676866] Raw EDID:
[    8.676867]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    8.676868]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.676868]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.676869]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.676870]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.676870]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.676871]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.676872]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.718751] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    8.718751] Raw EDID:
[    8.718752]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    8.718753]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.718753]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.718754]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.718755]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.718755]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.718756]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.718757]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.760556] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    8.760556] Raw EDID:
[    8.760557]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    8.760558]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.760558]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.760559]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.760560]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.760560]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.760561]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.760562]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.802508] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    8.802509] Raw EDID:
[    8.802509]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    8.802510]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.802511]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.802511]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.802512]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.802513]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.802513]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.802514]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.802515] i915 0000:00:02.0: HDMI-A-1: EDID block 0 invalid.
[    8.802516] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:HDMI-A-1] disconnected
[    8.802520] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[    8.802521] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:HDMI-A-1]
[    8.845936] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    8.845936] Raw EDID:
[    8.845937]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    8.845938]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.845938]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.845939]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.845940]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.845940]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.845941]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.845942]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.887868] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    8.887869] Raw EDID:
[    8.887869]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    8.887870]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.887871]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.887871]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.887872]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.887873]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.887873]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.887874]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.929670] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    8.929671] Raw EDID:
[    8.929671]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    8.929672]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.929673]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.929673]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.929674]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.929675]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.929675]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.929676]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.971592] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    8.971592] Raw EDID:
[    8.971593]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    8.971594]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.971594]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.971595]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.971596]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.971596]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.971597]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.971598]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.971599] i915 0000:00:02.0: HDMI-A-1: EDID block 0 invalid.
[    8.971600] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:HDMI-A-1] disconnected
[    8.971605] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
[    8.971606] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:DP-1]
[    8.974206] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    8.983445] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    8.990115] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    8.994156] [drm:intel_dp_detect], DPCD: 0000000000000000
[    8.994163] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:DP-1] disconnected
[    8.994178] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
[    8.994181] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:DP-1]
[    8.996792] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    9.003406] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    9.010058] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    9.014099] [drm:intel_dp_detect], DPCD: 0000000000000000
[    9.014106] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:DP-1] disconnected
[    9.014134] [drm:drm_mode_getconnector], [CONNECTOR:18:?]
[    9.014136] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:HDMI-A-2]
[    9.020753] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
[    9.020759] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[    9.020763] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:HDMI-A-2] disconnected
[    9.020771] [drm:drm_mode_getconnector], [CONNECTOR:18:?]
[    9.020782] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:HDMI-A-2]
[    9.027408] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
[    9.027414] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[    9.027418] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:HDMI-A-2] disconnected
[    9.027441] [drm:drm_mode_getconnector], [CONNECTOR:20:?]
[    9.027443] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:HDMI-A-3]
[    9.034051] [drm:gmbus_xfer], GMBUS [i915 gmbus dpd] NAK for addr: 0050 r(1)
[    9.034057] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpd
[    9.034060] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:HDMI-A-3] disconnected
[    9.034080] [drm:drm_mode_getconnector], [CONNECTOR:20:?]
[    9.034081] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:HDMI-A-3]
[    9.040697] [drm:gmbus_xfer], GMBUS [i915 gmbus dpd] NAK for addr: 0050 r(1)
[    9.040702] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpd
[    9.040706] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:HDMI-A-3] disconnected
[    9.040726] [drm:drm_mode_getconnector], [CONNECTOR:21:?]
[    9.040728] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-2]
[    9.043337] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    9.049943] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    9.056590] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    9.060634] [drm:intel_dp_detect], DPCD: 0000000000000000
[    9.060640] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-2] disconnected
[    9.060655] [drm:drm_mode_getconnector], [CONNECTOR:21:?]
[    9.060658] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-2]
[    9.063275] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    9.069887] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    9.076533] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    9.080577] [drm:intel_dp_detect], DPCD: 0000000000000000
[    9.080583] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-2] disconnected
[    9.080611] [drm:drm_mode_getconnector], [CONNECTOR:23:?]
[    9.080613] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-3]
[    9.083217] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    9.089829] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    9.096476] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    9.100519] [drm:intel_dp_detect], DPCD: 0000000000000000
[    9.100525] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-3] disconnected
[    9.100540] [drm:drm_mode_getconnector], [CONNECTOR:23:?]
[    9.100543] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-3]
[    9.103156] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    9.109772] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    9.116418] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    9.120454] [drm:intel_dp_detect], DPCD: 0000000000000000
[    9.120460] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-3] disconnected
[    9.121533] [drm:drm_mode_addfb], [FB:26]
[    9.123697] [drm:drm_mode_getconnector], [CONNECTOR:9:?]
[    9.123699] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1]
[    9.123704] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40010, result 0
[    9.123705] [drm:intel_crt_detect], CRT not detected via hotplug
[    9.167019] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    9.167020] Raw EDID:
[    9.167021]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    9.167022]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.167023]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.167023]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.167024]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.167025]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.167025]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.167026]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.208860] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    9.208860] Raw EDID:
[    9.208861]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    9.208862]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.208862]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.208863]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.208864]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.208864]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.208865]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.208866]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.250778] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    9.250778] Raw EDID:
[    9.250779]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    9.250780]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.250780]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.250781]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.250782]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.250782]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.250783]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.250784]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.292727] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    9.292728] Raw EDID:
[    9.292728]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    9.292729]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.292730]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.292730]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.292731]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.292732]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.292732]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.292733]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.292735] i915 0000:00:02.0: VGA-1: EDID block 0 invalid.
[    9.292735] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[    9.292737] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1] disconnected
[    9.292742] [drm:drm_mode_getconnector], [CONNECTOR:9:?]
[    9.292743] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1]
[    9.292748] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40010, result 0
[    9.292749] [drm:intel_crt_detect], CRT not detected via hotplug
[    9.336102] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    9.336103] Raw EDID:
[    9.336103]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    9.336104]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.336105]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.336105]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.336106]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.336107]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.336107]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.336108]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.377989] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    9.377990] Raw EDID:
[    9.377991]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    9.377991]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.377992]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.377993]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.377993]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.377994]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.377995]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.377995]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.419806] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    9.419806] Raw EDID:
[    9.419807]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    9.419807]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.419808]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.419809]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.419809]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.419810]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.419811]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.419811]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.461702] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    9.461703] Raw EDID:
[    9.461703]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    9.461704]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.461705]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.461705]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.461706]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.461707]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.461707]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.461708]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.461709] i915 0000:00:02.0: VGA-1: EDID block 0 invalid.
[    9.461710] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[    9.461711] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1] disconnected
[    9.461717] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[    9.461718] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:HDMI-A-1]
[    9.505018] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    9.505018] Raw EDID:
[    9.505019]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    9.505020]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.505020]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.505021]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.505022]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.505022]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.505023]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.505024]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.546963] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    9.546964] Raw EDID:
[    9.546965]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    9.546965]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.546966]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.546967]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.546967]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.546968]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.546969]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.546969]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.588878] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    9.588879] Raw EDID:
[    9.588879]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    9.588880]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.588881]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.588881]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.588882]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.588883]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.588883]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.588884]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.630689] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    9.630690] Raw EDID:
[    9.630691]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    9.630691]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.630692]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.630693]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.630693]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.630694]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.630695]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.630695]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.630697] i915 0000:00:02.0: HDMI-A-1: EDID block 0 invalid.
[    9.630697] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:HDMI-A-1] disconnected
[    9.630701] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[    9.630702] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:HDMI-A-1]
[    9.674030] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    9.674030] Raw EDID:
[    9.674031]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    9.674032]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.674032]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.674033]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.674034]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.674034]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.674035]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.674036]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.715922] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    9.715922] Raw EDID:
[    9.715923]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    9.715924]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.715924]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.715925]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.715926]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.715926]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.715927]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.715928]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.757842] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    9.757843] Raw EDID:
[    9.757844]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    9.757844]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.757845]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.757846]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.757846]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.757847]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.757848]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.757848]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.799791] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    9.799792] Raw EDID:
[    9.799792]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    9.799793]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.799793]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.799794]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.799795]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.799795]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.799796]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.799797]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.799798] i915 0000:00:02.0: HDMI-A-1: EDID block 0 invalid.
[    9.799799] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:HDMI-A-1] disconnected
[    9.799804] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
[    9.799805] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:DP-1]
[    9.802410] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    9.811616] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    9.817743] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    9.821792] [drm:intel_dp_detect], DPCD: 0000000000000000
[    9.821798] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:DP-1] disconnected
[    9.821818] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
[    9.821829] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:DP-1]
[    9.824431] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    9.831038] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    9.837685] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    9.841734] [drm:intel_dp_detect], DPCD: 0000000000000000
[    9.841741] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:DP-1] disconnected
[    9.841762] [drm:drm_mode_getconnector], [CONNECTOR:18:?]
[    9.841774] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:HDMI-A-2]
[    9.848390] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
[    9.848396] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[    9.848399] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:HDMI-A-2] disconnected
[    9.848407] [drm:drm_mode_getconnector], [CONNECTOR:18:?]
[    9.848418] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:HDMI-A-2]
[    9.855035] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
[    9.855041] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[    9.855045] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:HDMI-A-2] disconnected
[    9.855066] [drm:drm_mode_getconnector], [CONNECTOR:20:?]
[    9.855067] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:HDMI-A-3]
[    9.861681] [drm:gmbus_xfer], GMBUS [i915 gmbus dpd] NAK for addr: 0050 r(1)
[    9.861687] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpd
[    9.861691] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:HDMI-A-3] disconnected
[    9.861708] [drm:drm_mode_getconnector], [CONNECTOR:20:?]
[    9.861709] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:HDMI-A-3]
[    9.868333] [drm:gmbus_xfer], GMBUS [i915 gmbus dpd] NAK for addr: 0050 r(1)
[    9.868339] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpd
[    9.868342] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:HDMI-A-3] disconnected
[    9.868363] [drm:drm_mode_getconnector], [CONNECTOR:21:?]
[    9.868364] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-2]
[    9.870965] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    9.877572] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    9.884216] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    9.888269] [drm:intel_dp_detect], DPCD: 0000000000000000
[    9.888275] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-2] disconnected
[    9.888290] [drm:drm_mode_getconnector], [CONNECTOR:21:?]
[    9.888293] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-2]
[    9.890908] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    9.897514] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    9.904155] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    9.908214] [drm:intel_dp_detect], DPCD: 0000000000000000
[    9.908220] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-2] disconnected
[    9.908241] [drm:drm_mode_getconnector], [CONNECTOR:23:?]
[    9.908252] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-3]
[    9.910850] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    9.917458] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    9.924100] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    9.928156] [drm:intel_dp_detect], DPCD: 0000000000000000
[    9.928162] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-3] disconnected
[    9.928177] [drm:drm_mode_getconnector], [CONNECTOR:23:?]
[    9.928180] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-3]
[    9.930793] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    9.937399] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    9.944049] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    9.948101] [drm:intel_dp_detect], DPCD: 0000000000000000
[    9.948108] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-3] disconnected
[   10.000090] ksplashx[1665]: segfault at ffffff50 ip 08056cec sp bf8124e0 error 4 in ksplashx[8048000+1c000]
[   10.532029] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   10.539003] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   10.545653] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   10.553013] [drm:intel_dp_detect], DPCD: 0000000000000000
[   10.555646] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   10.562256] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   10.568921] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   10.572968] [drm:intel_dp_detect], DPCD: 0000000000000000
[   10.575611] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   10.582220] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   10.588866] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   10.592915] [drm:intel_dp_detect], DPCD: 0000000000000000
[   10.636309] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   10.636311] Raw EDID:
[   10.636313]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   10.636313]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.636314]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.636315]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.636315]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.636316]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.636317]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.636317]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.665766] [drm:i915_driver_open], 
[   10.678223] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   10.678224] Raw EDID:
[   10.678225]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   10.678226]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.678227]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.678227]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.678228]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.678229]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.678229]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.678230]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.720189] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   10.720189] Raw EDID:
[   10.720190]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   10.720190]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.720191]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.720192]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.720192]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.720193]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.720194]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.720194]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.762143] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   10.762144] Raw EDID:
[   10.762144]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   10.762145]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.762146]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.762146]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.762147]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.762148]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.762148]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.762149]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.762152] i915 0000:00:02.0: HDMI-A-1: EDID block 0 invalid.
[   10.764741] [drm:i915_driver_open], 
[   10.765757] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
[   10.765759] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[   10.772404] [drm:gmbus_xfer], GMBUS [i915 gmbus dpd] NAK for addr: 0050 r(1)
[   10.772407] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpd
[   10.772442] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40010, result 0
[   10.772444] [drm:intel_crt_detect], CRT not detected via hotplug
[   10.774256] [drm:drm_mode_getconnector], [CONNECTOR:9:?]
[   10.815812] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   10.815813] Raw EDID:
[   10.815815]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   10.815815]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.815816]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.815817]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.815817]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.815818]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.815819]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.815819]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.857757] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   10.857758] Raw EDID:
[   10.857759]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   10.857759]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.857760]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.857761]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.857761]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.857762]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.857763]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.857763]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.899606] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   10.899607] Raw EDID:
[   10.899608]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   10.899608]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.899609]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.899610]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.899610]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.899611]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.899612]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.899612]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.941521] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   10.941522] Raw EDID:
[   10.941522]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   10.941523]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.941524]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.941524]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.941525]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.941526]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.941526]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.941527]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.941529] i915 0000:00:02.0: VGA-1: EDID block 0 invalid.
[   10.941530] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[   10.941556] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1]
[   10.941562] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40010, result 0
[   10.941563] [drm:intel_crt_detect], CRT not detected via hotplug
[   10.984944] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   10.984946] Raw EDID:
[   10.984947]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   10.984948]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.984949]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.984949]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.984950]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.984951]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.984951]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.984952]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.995892] EXT4-fs (sda4): re-mounted. Opts: acl,user_xattr,commit=0
[   10.998392] EXT4-fs (sda2): re-mounted. Opts: acl,user_xattr,commit=0
[   11.026064] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   11.026065] Raw EDID:
[   11.026066]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   11.026067]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.026068]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.026068]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.026069]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.026070]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.026070]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.026071]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.067910] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   11.067910] Raw EDID:
[   11.067911]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   11.067912]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.067912]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.067913]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.067914]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.067914]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.067915]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.067916]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.109784] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   11.109784] Raw EDID:
[   11.109785]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   11.109786]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.109787]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.109787]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.109788]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.109789]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.109789]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.109790]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.109792] i915 0000:00:02.0: VGA-1: EDID block 0 invalid.
[   11.109794] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[   11.109797] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1] disconnected
[   11.109808] [drm:drm_mode_getconnector], [CONNECTOR:9:?]
[   11.109810] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1]
[   11.109811] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40010, result 0
[   11.109812] [drm:intel_crt_detect], CRT not detected via hotplug
[   11.153115] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   11.153116] Raw EDID:
[   11.153117]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   11.153117]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.153118]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.153119]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.153119]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.153120]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.153121]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.153121]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.195042] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   11.195043] Raw EDID:
[   11.195044]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   11.195044]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.195045]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.195046]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.195046]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.195047]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.195048]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.195048]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.236894] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   11.236894] Raw EDID:
[   11.236895]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   11.236896]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.236896]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.236897]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.236898]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.236898]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.236899]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.236900]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.278720] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   11.278720] Raw EDID:
[   11.278721]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   11.278721]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.278722]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.278723]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.278723]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.278724]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.278725]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.278725]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.278727] i915 0000:00:02.0: VGA-1: EDID block 0 invalid.
[   11.278727] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[   11.278729] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1] disconnected
[   11.278739] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[   11.278740] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:HDMI-A-1]
[   11.322087] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   11.322088] Raw EDID:
[   11.322088]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   11.322089]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.322090]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.322090]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.322091]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.322092]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.322092]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.322093]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.364055] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   11.364055] Raw EDID:
[   11.364056]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   11.364056]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.364057]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.364058]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.364058]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.364059]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.364060]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.364060]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.406010] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   11.406011] Raw EDID:
[   11.406011]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   11.406012]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.406013]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.406013]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.406014]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.406015]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.406015]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.406016]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.447955] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   11.447955] Raw EDID:
[   11.447956]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   11.447957]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.447957]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.447958]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.447959]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.447959]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.447960]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.447961]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.447962] i915 0000:00:02.0: HDMI-A-1: EDID block 0 invalid.
[   11.447963] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:HDMI-A-1] disconnected
[   11.447966] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[   11.447967] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:HDMI-A-1]
[   11.491316] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   11.491316] Raw EDID:
[   11.491317]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   11.491318]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.491318]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.491319]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.491320]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.491320]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.491321]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.491322]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.533127] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   11.533127] Raw EDID:
[   11.533128]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   11.533129]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.533129]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.533130]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.533131]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.533131]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.533132]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.533133]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.574938] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   11.574938] Raw EDID:
[   11.574939]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   11.574940]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.574940]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.574941]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.574942]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.574942]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.574943]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.574944]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.616801] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   11.616801] Raw EDID:
[   11.616802]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   11.616803]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.616803]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.616804]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.616805]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.616805]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.616806]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.616807]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.616808] i915 0000:00:02.0: HDMI-A-1: EDID block 0 invalid.
[   11.616809] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:HDMI-A-1] disconnected
[   11.616814] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
[   11.616815] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:DP-1]
[   11.619412] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   11.625914] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   11.632561] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   11.636607] [drm:intel_dp_detect], DPCD: 0000000000000000
[   11.636614] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:DP-1] disconnected
[   11.636629] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
[   11.636632] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:DP-1]
[   11.639248] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   11.645879] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   11.652504] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   11.656551] [drm:intel_dp_detect], DPCD: 0000000000000000
[   11.656557] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:DP-1] disconnected
[   11.656585] [drm:drm_mode_getconnector], [CONNECTOR:18:?]
[   11.656587] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:HDMI-A-2]
[   11.663204] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
[   11.663210] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[   11.663214] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:HDMI-A-2] disconnected
[   11.663221] [drm:drm_mode_getconnector], [CONNECTOR:18:?]
[   11.663224] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:HDMI-A-2]
[   11.669854] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
[   11.669860] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[   11.669863] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:HDMI-A-2] disconnected
[   11.669883] [drm:drm_mode_getconnector], [CONNECTOR:20:?]
[   11.669884] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:HDMI-A-3]
[   11.676500] [drm:gmbus_xfer], GMBUS [i915 gmbus dpd] NAK for addr: 0050 r(1)
[   11.676506] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpd
[   11.676510] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:HDMI-A-3] disconnected
[   11.676531] [drm:drm_mode_getconnector], [CONNECTOR:20:?]
[   11.676533] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:HDMI-A-3]
[   11.683148] [drm:gmbus_xfer], GMBUS [i915 gmbus dpd] NAK for addr: 0050 r(1)
[   11.683154] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpd
[   11.683157] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:HDMI-A-3] disconnected
[   11.683177] [drm:drm_mode_getconnector], [CONNECTOR:21:?]
[   11.683179] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-2]
[   11.685784] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   11.692391] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   11.699037] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   11.703090] [drm:intel_dp_detect], DPCD: 0000000000000000
[   11.703096] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-2] disconnected
[   11.703120] [drm:drm_mode_getconnector], [CONNECTOR:21:?]
[   11.703121] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-2]
[   11.705727] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   11.712334] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   11.718981] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   11.723030] [drm:intel_dp_detect], DPCD: 0000000000000000
[   11.723037] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-2] disconnected
[   11.723063] [drm:drm_mode_getconnector], [CONNECTOR:23:?]
[   11.723065] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-3]
[   11.725669] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   11.732276] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   11.738925] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   11.742975] [drm:intel_dp_detect], DPCD: 0000000000000000
[   11.742981] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-3] disconnected
[   11.742996] [drm:drm_mode_getconnector], [CONNECTOR:23:?]
[   11.743006] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-3]
[   11.745610] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   11.752219] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   11.758866] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   11.762917] [drm:intel_dp_detect], DPCD: 0000000000000000
[   11.762923] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-3] disconnected
[   12.494143] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40010, result 0
[   12.494147] [drm:intel_crt_detect], CRT not detected via hotplug
[   12.537526] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   12.537529] Raw EDID:
[   12.537530]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   12.537531]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.537531]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.537532]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.537533]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.537533]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.537534]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.537535]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.579364] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   12.579366] Raw EDID:
[   12.579367]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   12.579367]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.579368]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.579369]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.579369]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.579370]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.579371]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.579371]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.621114] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   12.621116] Raw EDID:
[   12.621117]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   12.621117]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.621118]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.621119]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.621119]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.621120]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.621121]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.621121]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.663027] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   12.663029] Raw EDID:
[   12.663030]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   12.663031]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.663031]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.663032]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.663033]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.663033]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.663034]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.663035]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.663038] i915 0000:00:02.0: VGA-1: EDID block 0 invalid.
[   12.663039] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[   12.663040] [drm:output_poll_execute], [CONNECTOR:9:VGA-1] status updated from 2 to 2
[   12.706407] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   12.706408] Raw EDID:
[   12.706409]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   12.706410]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.706411]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.706411]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.706412]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.706413]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.706413]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.706414]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.749073] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   12.749074] Raw EDID:
[   12.749075]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   12.749076]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.749076]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.749077]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.749078]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.749078]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.749079]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.749080]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.791760] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   12.791761] Raw EDID:
[   12.791762]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   12.791763]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.791764]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.791764]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.791765]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.791766]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.791766]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.791767]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.833190] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   12.833192] Raw EDID:
[   12.833193]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   12.833193]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.833194]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.833195]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.833195]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.833196]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.833197]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.833198]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.833200] i915 0000:00:02.0: HDMI-A-1: EDID block 0 invalid.
[   12.833201] [drm:output_poll_execute], [CONNECTOR:12:HDMI-A-1] status updated from 2 to 2
[   12.835800] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   12.843382] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   12.852400] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   12.856438] [drm:intel_dp_detect], DPCD: 0000000000000000
[   12.856442] [drm:output_poll_execute], [CONNECTOR:15:DP-1] status updated from 2 to 2
[   12.863092] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
[   12.863096] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[   12.863098] [drm:output_poll_execute], [CONNECTOR:18:HDMI-A-2] status updated from 2 to 2
[   12.869741] [drm:gmbus_xfer], GMBUS [i915 gmbus dpd] NAK for addr: 0050 r(1)
[   12.869745] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpd
[   12.869747] [drm:output_poll_execute], [CONNECTOR:20:HDMI-A-3] status updated from 2 to 2
[   12.872358] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   12.878991] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   12.885637] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   12.889678] [drm:intel_dp_detect], DPCD: 0000000000000000
[   12.889681] [drm:output_poll_execute], [CONNECTOR:21:DP-2] status updated from 2 to 2
[   12.892285] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   12.898932] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   12.908905] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   12.912943] [drm:intel_dp_detect], DPCD: 0000000000000000
[   12.912947] [drm:output_poll_execute], [CONNECTOR:23:DP-3] status updated from 2 to 2
[   13.009563] [drm:drm_mode_getconnector], [CONNECTOR:9:?]
[   13.009567] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1]
[   13.009573] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40010, result 0
[   13.009575] [drm:intel_crt_detect], CRT not detected via hotplug
[   13.052968] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   13.052970] Raw EDID:
[   13.052972]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   13.052973]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.052973]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.052974]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.052975]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.052975]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.052976]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.052977]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.094889] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   13.094890] Raw EDID:
[   13.094891]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   13.094892]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.094893]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.094894]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.094894]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.094895]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.094896]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.094896]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.136737] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   13.136739] Raw EDID:
[   13.136740]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   13.136741]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.136741]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.136742]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.136743]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.136743]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.136744]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.136745]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.178648] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   13.178649] Raw EDID:
[   13.178650]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   13.178651]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.178651]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.178652]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.178653]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.178653]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.178654]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.178655]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.178657] i915 0000:00:02.0: VGA-1: EDID block 0 invalid.
[   13.178658] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[   13.178661] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1] disconnected
[   13.178673] [drm:drm_mode_getconnector], [CONNECTOR:9:?]
[   13.178675] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1]
[   13.178680] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40010, result 0
[   13.178681] [drm:intel_crt_detect], CRT not detected via hotplug
[   13.221927] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   13.221929] Raw EDID:
[   13.221930]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   13.221930]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.221931]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.221932]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.221932]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.221933]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.221934]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.221934]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.263781] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   13.263782] Raw EDID:
[   13.263783]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   13.263784]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.263785]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.263785]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.263786]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.263787]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.263787]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.263788]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.305708] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   13.305709] Raw EDID:
[   13.305710]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   13.305710]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.305711]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.305712]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.305712]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.305713]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.305714]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.305714]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.347626] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   13.347626] Raw EDID:
[   13.347627]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   13.347628]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.347628]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.347629]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.347630]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.347630]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.347631]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.347632]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.347634] i915 0000:00:02.0: VGA-1: EDID block 0 invalid.
[   13.347635] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[   13.347637] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1] disconnected
[   13.347653] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[   13.347655] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:HDMI-A-1]
[   13.391016] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   13.391017] Raw EDID:
[   13.391017]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   13.391018]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.391019]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.391019]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.391020]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.391021]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.391021]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.391022]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.432911] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   13.432911] Raw EDID:
[   13.432912]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   13.432913]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.432913]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.432914]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.432915]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.432915]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.432916]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.432917]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.474833] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   13.474833] Raw EDID:
[   13.474834]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   13.474835]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.474835]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.474836]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.474837]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.474837]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.474838]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.474839]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.516668] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   13.516669] Raw EDID:
[   13.516670]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   13.516670]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.516671]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.516672]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.516672]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.516673]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.516674]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.516674]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.516675] i915 0000:00:02.0: HDMI-A-1: EDID block 0 invalid.
[   13.516676] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:HDMI-A-1] disconnected
[   13.516680] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[   13.516681] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:HDMI-A-1]
[   13.560022] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   13.560022] Raw EDID:
[   13.560023]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   13.560024]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.560024]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.560025]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.560026]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.560026]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.560027]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.560028]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.602020] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   13.602020] Raw EDID:
[   13.602021]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   13.602022]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.602022]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.602023]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.602024]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.602024]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.602025]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.602026]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.643882] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   13.643883] Raw EDID:
[   13.643883]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   13.643884]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.643885]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.643885]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.643886]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.643887]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.643887]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.643888]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.685802] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   13.685802] Raw EDID:
[   13.685803]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   13.685803]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.685804]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.685805]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.685805]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.685806]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.685807]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.685807]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.685809] i915 0000:00:02.0: HDMI-A-1: EDID block 0 invalid.
[   13.685809] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:HDMI-A-1] disconnected
[   13.685814] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
[   13.685816] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:DP-1]
[   13.688419] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   13.696667] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   13.703313] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   13.707359] [drm:intel_dp_detect], DPCD: 0000000000000000
[   13.707365] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:DP-1] disconnected
[   13.707381] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
[   13.707392] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:DP-1]
[   13.710001] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   13.716611] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   13.723256] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   13.727304] [drm:intel_dp_detect], DPCD: 0000000000000000
[   13.727310] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:DP-1] disconnected
[   13.727338] [drm:drm_mode_getconnector], [CONNECTOR:18:?]
[   13.727340] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:HDMI-A-2]
[   13.737263] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
[   13.737268] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[   13.737272] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:HDMI-A-2] disconnected
[   13.737286] [drm:drm_mode_getconnector], [CONNECTOR:18:?]
[   13.737289] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:HDMI-A-2]
[   13.743927] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
[   13.743933] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[   13.743936] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:HDMI-A-2] disconnected
[   13.743956] [drm:drm_mode_getconnector], [CONNECTOR:20:?]
[   13.743958] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:HDMI-A-3]
[   13.753885] [drm:gmbus_xfer], GMBUS [i915 gmbus dpd] NAK for addr: 0050 r(1)
[   13.753890] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpd
[   13.753894] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:HDMI-A-3] disconnected
[   13.753908] [drm:drm_mode_getconnector], [CONNECTOR:20:?]
[   13.753911] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:HDMI-A-3]
[   13.763870] [drm:gmbus_xfer], GMBUS [i915 gmbus dpd] NAK for addr: 0050 r(1)
[   13.763876] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpd
[   13.763879] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:HDMI-A-3] disconnected
[   13.763900] [drm:drm_mode_getconnector], [CONNECTOR:21:?]
[   13.763901] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-2]
[   13.766507] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   13.776417] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   13.783086] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   13.787131] [drm:intel_dp_detect], DPCD: 0000000000000000
[   13.787137] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-2] disconnected
[   13.787152] [drm:drm_mode_getconnector], [CONNECTOR:21:?]
[   13.787155] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-2]
[   13.789771] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   13.796383] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   13.803027] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   13.807073] [drm:intel_dp_detect], DPCD: 0000000000000000
[   13.807079] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-2] disconnected
[   13.807108] [drm:drm_mode_getconnector], [CONNECTOR:23:?]
[   13.807109] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-3]
[   13.809717] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   13.816322] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   13.822972] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   13.827016] [drm:intel_dp_detect], DPCD: 0000000000000000
[   13.827022] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-3] disconnected
[   13.827037] [drm:drm_mode_getconnector], [CONNECTOR:23:?]
[   13.827040] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-3]
[   13.829656] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   13.836266] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   13.842914] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   13.846960] [drm:intel_dp_detect], DPCD: 0000000000000000
[   13.846966] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-3] disconnected
[   23.183626] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40010, result 0
[   23.183632] [drm:intel_crt_detect], CRT not detected via hotplug
[   23.226947] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   23.226948] Raw EDID:
[   23.226949]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   23.226950]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   23.226951]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   23.226951]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   23.226952]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   23.226953]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   23.226953]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   23.226954]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   23.268868] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   23.268868] Raw EDID:
[   23.268869]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   23.268870]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   23.268870]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   23.268871]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   23.268872]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   23.268872]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   23.268873]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   23.268874]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   23.310724] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   23.310724] Raw EDID:
[   23.310725]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   23.310725]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   23.310726]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   23.310727]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   23.310727]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   23.310728]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   23.310729]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   23.310729]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   23.352589] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   23.352589] Raw EDID:
[   23.352590]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   23.352591]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   23.352591]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   23.352592]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   23.352593]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   23.352593]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   23.352594]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   23.352595]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   23.352597] i915 0000:00:02.0: VGA-1: EDID block 0 invalid.
[   23.352598] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[   23.352599] [drm:output_poll_execute], [CONNECTOR:9:VGA-1] status updated from 2 to 2
[   23.395890] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   23.395891] Raw EDID:
[   23.395892]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   23.395892]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   23.395893]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   23.395894]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   23.395894]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   23.395895]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   23.395896]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   23.395896]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   23.437773] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   23.437774] Raw EDID:
[   23.437775]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   23.437776]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   23.437777]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   23.437777]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   23.437778]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   23.437779]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   23.437779]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   23.437780]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   23.479648] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   23.479649] Raw EDID:
[   23.479650]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   23.479650]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   23.479651]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   23.479652]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   23.479652]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   23.479653]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   23.479654]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   23.479654]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   23.521591] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   23.521592] Raw EDID:
[   23.521592]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   23.521593]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   23.521594]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   23.521594]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   23.521595]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   23.521596]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   23.521596]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   23.521597]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   23.521599] i915 0000:00:02.0: HDMI-A-1: EDID block 0 invalid.
[   23.521600] [drm:output_poll_execute], [CONNECTOR:12:HDMI-A-1] status updated from 2 to 2
[   23.524206] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   23.531892] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   23.538539] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   23.542591] [drm:intel_dp_detect], DPCD: 0000000000000000
[   23.542597] [drm:output_poll_execute], [CONNECTOR:15:DP-1] status updated from 2 to 2
[   23.549247] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
[   23.549252] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[   23.549255] [drm:output_poll_execute], [CONNECTOR:18:HDMI-A-2] status updated from 2 to 2
[   23.555890] [drm:gmbus_xfer], GMBUS [i915 gmbus dpd] NAK for addr: 0050 r(1)
[   23.555896] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpd
[   23.555899] [drm:output_poll_execute], [CONNECTOR:20:HDMI-A-3] status updated from 2 to 2
[   23.558503] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   23.565130] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   23.571778] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   23.575829] [drm:intel_dp_detect], DPCD: 0000000000000000
[   23.575835] [drm:output_poll_execute], [CONNECTOR:21:DP-2] status updated from 2 to 2
[   23.578445] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   23.585076] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   23.591722] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   23.595784] [drm:intel_dp_detect], DPCD: 0000000000000000
[   23.595789] [drm:output_poll_execute], [CONNECTOR:23:DP-3] status updated from 2 to 2

--------------030404000001010103020706--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610Ab1LLXVo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 18:21:44 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59402 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753379Ab1LLXVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 18:21:40 -0500
Message-ID: <4EE68C80.7000408@gmail.com>
Date: Mon, 12 Dec 2011 16:21:36 -0700
From: "Berck E. Nash" <flyboy@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111114 Icedove/3.1.16
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: x2apic boot failure on recent sandy bridge system
References: <4EE2BC33.80902@gmail.com>	<CAE9FiQXH6d0eAjbQ0Dz3Q8NR6ktP_x6UKtzDtuq8253Qv4KS7w@mail.gmail.com>	<20111211075713.GA20790@elte.hu>	<CAE9FiQXk7y_oafNZG-QF5h3kDUQ3J6SP3A=ezHBT2W4Njo=uxQ@mail.gmail.com>	<4EE5291C.1030302@gmail.com> <CAE9FiQXf2GzR2Uuw23CK7YVN4djtCd+aOFTRrf=96u9NTXRn=A@mail.gmail.com>
In-Reply-To: <CAE9FiQXf2GzR2Uuw23CK7YVN4djtCd+aOFTRrf=96u9NTXRn=A@mail.gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: multipart/mixed;
 boundary="------------050807050609090302090303"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050807050609090302090303
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 12/11/2011 08:40 PM, Yinghai Lu wrote:
> x2apic pre-enabled skip the mapping for lapic address. so need map it
> after fall back.
> 
> please check attached -v5..

It appears to work correctly as far as I can tell.

Berck Nash

--------------050807050609090302090303
Content-Type: text/plain;
 name="x2apic-v5.log"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment;
 filename="x2apic-v5.log"

[    0.000000] Linux version 3.2.0-rc5+ (berck@luna) (gcc version 4.6.2 (Debian 4.6.2-6) ) #4 SMP Mon Dec 12 16:03:52 MST 2011
[    0.000000] Command line: BOOT_IMAGE=(hd0,1)/vmlinuz root=/dev/sdb1 ro video=efifb console=ttyS0,115200n8 console=tty0
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009d400 (usable)
[    0.000000]  BIOS-e820: 000000000009d400 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000beee2000 (usable)
[    0.000000]  BIOS-e820: 00000000beee2000 - 00000000bef3a000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bef3a000 - 00000000bf607000 (reserved)
[    0.000000]  BIOS-e820: 00000000bf607000 - 00000000bf608000 (usable)
[    0.000000]  BIOS-e820: 00000000bf608000 - 00000000bf609000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bf609000 - 00000000bf613000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bf613000 - 00000000bf638000 (reserved)
[    0.000000]  BIOS-e820: 00000000bf638000 - 00000000bf67b000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bf67b000 - 00000000bf800000 (usable)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed40000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000023f800000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.6 present.
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x23f800 max_arch_pfn = 0x400000000
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] x2apic enabled by BIOS, switching to x2apic ops
[    0.000000] last_pfn = 0xbf800 max_arch_pfn = 0x400000000
[    0.000000] init_memory_mapping: 0000000000000000-00000000bf800000
[    0.000000] init_memory_mapping: 0000000100000000-000000023f800000
[    0.000000] ACPI: RSDP 00000000000f0450 00024 (v02 ALASKA)
[    0.000000] ACPI: XSDT 00000000bef32068 00054 (v01 ALASKA    A M I 01072009 AMI  00010013)
[    0.000000] ACPI: FACP 00000000bef398f8 000F4 (v04 ALASKA    A M I 01072009 AMI  00010013)
[    0.000000] ACPI: DSDT 00000000bef32150 077A6 (v02 ALASKA    A M I 00000000 INTL 20051117)
[    0.000000] ACPI: FACS 00000000bf60af80 00040
[    0.000000] ACPI: APIC 00000000bef399f0 000D8 (v03 ALASKA    A M I 01072009 AMI  00010013)
[    0.000000] ACPI: SSDT 00000000bef39ac8 001DE (v01 AMICPU     PROC 00000001 MSFT 03000001)
[    0.000000] ACPI: MCFG 00000000bef39ca8 0003C (v01 ALASKA    A M I 01072009 MSFT 00000097)
[    0.000000] ACPI: AAFT 00000000bef39ce8 0006F (v01 ALASKA OEMAAFT  01072009 MSFT 00000097)
[    0.000000] ACPI: HPET 00000000bef39d58 00038 (v01 ALASKA    A M I 01072009 AMI. 00000004)
[    0.000000] Setting APIC routing to cluster x2apic.
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000023f800000
[    0.000000] Initmem setup node 0 0000000000000000-000000023f800000
[    0.000000]   NODE_DATA [000000023f7fb000 - 000000023f7fffff]
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x0023f800
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[5] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009d
[    0.000000]     0: 0x00000100 -> 0x000beee2
[    0.000000]     0: 0x000bf607 -> 0x000bf608
[    0.000000]     0: 0x000bf67b -> 0x000bf800
[    0.000000]     0: 0x00100000 -> 0x0023f800
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: X2APIC (apic_id[0x00] uid[0x01] enabled)
[    0.000000] ACPI: X2APIC (apic_id[0x02] uid[0x02] enabled)
[    0.000000] ACPI: X2APIC (apic_id[0x04] uid[0x03] enabled)
[    0.000000] ACPI: X2APIC (apic_id[0x06] uid[0x04] enabled)
[    0.000000] ACPI: X2APIC (apic_id[0x01] uid[0x05] enabled)
[    0.000000] ACPI: X2APIC (apic_id[0x03] uid[0x06] enabled)
[    0.000000] ACPI: X2APIC (apic_id[0x05] uid[0x07] enabled)
[    0.000000] ACPI: X2APIC (apic_id[0x07] uid[0x08] enabled)
[    0.000000] ACPI: X2APIC_NMI (uid[0xffffffff] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] SMP: Allowing 8 CPUs, 0 hotplug CPUs
[    0.000000] Allocating PCI resources starting at bf800000 (gap: bf800000:3f51c000)
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 25 pages/cpu @ffff88023f400000 s70976 r8192 d23232 u262144
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2058767
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=(hd0,1)/vmlinuz root=/dev/sdb1 ro video=efifb console=ttyS0,115200n8 console=tty0
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave/xrstor: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 8175908k/9428992k available (3610k kernel code, 1065004k absent, 188080k reserved, 1567k data, 672k init)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:744 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] Fast TSC calibration using PIT
[    0.001000] Detected 3391.832 MHz processor.
[    0.000001] Calibrating delay loop (skipped), value calculated using timer frequency.. 6783.66 BogoMIPS (lpj=3391832)
[    0.010595] pid_max: default: 32768 minimum: 301
[    0.015473] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.023750] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.031306] Mount-cache hash table entries: 256
[    0.035901] CPU: Physical Processor ID: 0
[    0.039900] CPU: Processor Core ID: 0
[    0.043558] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.043558] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.056562] mce: CPU supports 9 MCE banks
[    0.060571] CPU0: Thermal monitoring enabled (TM1)
[    0.065354] using mwait in idle threads.
[    0.069332] Freeing SMP alternatives: 20k freed
[    0.073857] ACPI: Core revision 20110623
[    0.085677] Disabling x2apic
[    0.088578] Switched APIC routing to flat.
[    0.093036] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=0 pin2=0
[    0.108819] CPU0: Intel(R) Core(TM) i7-2600 CPU @ 3.40GHz stepping 07
[    0.216400] Performance Events: PEBS fmt1+, SandyBridge events, Intel PMU driver.
[    0.223907] PEBS disabled due to CPU errata.
[    0.228168] ... version:                3
[    0.232168] ... bit width:              48
[    0.236255] ... generic registers:      4
[    0.240247] ... value mask:             0000ffffffffffff
[    0.245537] ... max period:             000000007fffffff
[    0.250834] ... fixed-purpose events:   3
[    0.254828] ... event mask:             000000070000000f
[    0.260194] Booting Node   0, Processors  #1
[    0.274900] Disabling x2apic
[    0.357120]  #2
[    0.369179] Disabling x2apic
[    0.451829]  #3
[    0.463901] Disabling x2apic
[    0.546545]  #4
[    0.558655] Disabling x2apic
[    0.641286]  #5
[    0.653348] Disabling x2apic
[    0.735919]  #6
[    0.747976] Disabling x2apic
[    0.830722]  #7 Ok.
[    0.843117] Disabling x2apic
[    0.925323] Brought up 8 CPUs
[    0.928281] Total of 8 processors activated (54269.62 BogoMIPS).
[    0.939081] devtmpfs: initialized
[    0.942490] NET: Registered protocol family 16
[    0.946971] ACPI: bus type pci registered
[    0.950974] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.960248] PCI: not using MMCONFIG
[    0.963730] PCI: Using configuration type 1 for base access
[    0.969631] bio: create slab <bio-0> at 0
[    0.973668] ACPI: Added _OSI(Module Device)
[    0.977841] ACPI: Added _OSI(Processor Device)
[    0.982267] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.986951] ACPI: Added _OSI(Processor Aggregator Device)
[    0.993486] ACPI: Executed 1 blocks of module-level executable AML code
[    1.002505] ACPI: Interpreter enabled
[    1.006154] ACPI: (supports S0 S5)
[    1.009593] ACPI: Using IOAPIC for interrupt routing
[    1.014556] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    1.023868] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI motherboard resources
[    1.046241] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    1.055070] HEST: Table not found.
[    1.058464] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    1.067676] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    1.073965] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    1.080553] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    1.087145] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    1.094431] pci_root PNP0A08:00: host bridge window [mem 0x000c8000-0x000dffff]
[    1.101715] pci_root PNP0A08:00: host bridge window [mem 0xc0000000-0xffffffff]
[    1.108994] pci_root PNP0A08:00: ignoring host bridge window [mem 0x000c8000-0x000dffff] (conflicts with Video ROM [mem 0x000c0000-0x000ccdff])
[    1.124701] pci 0000:00:1c.0: PCI bridge to [bus 01-01]
[    1.131678] pci 0000:00:1c.4: PCI bridge to [bus 02-02]
[    1.138660] pci 0000:00:1c.6: PCI bridge to [bus 03-03]
[    1.145633] pci 0000:00:1c.7: PCI bridge to [bus 04-0d]
[    1.152241] pci 0000:04:00.0: PCI bridge to [bus 05-0d]
[    1.157843] pci 0000:05:01.0: PCI bridge to [bus 06-06]
[    1.164581] pci 0000:05:04.0: PCI bridge to [bus 07-08]
[    1.170495] pci 0000:07:00.0: PCI bridge to [bus 08-08]
[    1.176116] pci 0000:05:05.0: PCI bridge to [bus 09-09]
[    1.183529] pci 0000:05:06.0: PCI bridge to [bus 0a-0a]
[    1.189113] pci 0000:05:07.0: PCI bridge to [bus 0b-0b]
[    1.194433] pci 0000:05:08.0: PCI bridge to [bus 0c-0c]
[    1.199748] pci 0000:05:09.0: PCI bridge to [bus 0d-0d]
[    1.205480]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    1.211250]  pci0000:00: ACPI _OSC control (0x1c) granted
[    1.219050] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    1.226311] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[    1.233562] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 10 11 12 14 15)
[    1.240622] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 10 11 12 14 15)
[    1.247683] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0
[    1.255131] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *0
[    1.262573] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    1.269823] ACPI: PCI Interrupt Link [LNKH] (IRQs *3 4 5 6 7 10 11 12 14 15)
[    1.277093] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    1.285153] vgaarb: loaded
[    1.287854] vgaarb: bridge control possible 0000:01:00.0
[    1.293207] SCSI subsystem initialized
[    1.296983] PCI: Using ACPI for IRQ routing
[    1.311026] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    1.317338] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    1.325154] Switching to clocksource hpet
[    1.329219] pnp: PnP ACPI init
[    1.332272] ACPI: bus type pnp registered
[    1.336442] system 00:01: [mem 0xfed10000-0xfed19fff] has been reserved
[    1.343036] system 00:01: [mem 0xe0000000-0xefffffff] has been reserved
[    1.349629] system 00:01: [mem 0xfed90000-0xfed93fff] has been reserved
[    1.356224] system 00:01: [mem 0xfed20000-0xfed3ffff] has been reserved
[    1.362817] system 00:01: [mem 0xfee00000-0xfee0ffff] has been reserved
[    1.369465] system 00:02: [io  0x0290-0x029f] has been reserved
[    1.375755] system 00:07: [io  0x04d0-0x04d1] has been reserved
[    1.382008] system 00:0a: [io  0x0400-0x0453] has been reserved
[    1.387913] system 00:0a: [io  0x0458-0x047f] has been reserved
[    1.393817] system 00:0a: [io  0x1180-0x119f] has been reserved
[    1.399717] system 00:0a: [io  0x0500-0x057f] has been reserved
[    1.405619] system 00:0a: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    1.412213] system 00:0a: [mem 0xfec00000-0xfecfffff] could not be reserved
[    1.419153] system 00:0a: [mem 0xfed08000-0xfed08fff] has been reserved
[    1.425746] system 00:0a: [mem 0xff000000-0xffffffff] has been reserved
[    1.432383] system 00:0b: [io  0x0454-0x0457] has been reserved
[    1.438459] pnp: PnP ACPI: found 13 devices
[    1.442633] ACPI: ACPI bus type pnp unregistered
[    1.453068] pci 0000:00:1c.0: PCI bridge to [bus 01-01]
[    1.458277] pci 0000:00:1c.0:   bridge window [io  0xe000-0xefff]
[    1.464354] pci 0000:00:1c.0:   bridge window [mem 0xf8000000-0xfb0fffff]
[    1.471120] pci 0000:00:1c.0:   bridge window [mem 0xc0000000-0xcfffffff 64bit pref]
[    1.478840] pci 0000:00:1c.4: PCI bridge to [bus 02-02]
[    1.484056] pci 0000:00:1c.4:   bridge window [io  0xd000-0xdfff]
[    1.490133] pci 0000:00:1c.4:   bridge window [mem 0xfb700000-0xfb7fffff]
[    1.496905] pci 0000:00:1c.6: PCI bridge to [bus 03-03]
[    1.502121] pci 0000:00:1c.6:   bridge window [mem 0xfb600000-0xfb6fffff]
[    1.508900] pci 0000:05:01.0: PCI bridge to [bus 06-06]
[    1.514117] pci 0000:05:01.0:   bridge window [mem 0xfb400000-0xfb4fffff]
[    1.520899] pci 0000:07:00.0: PCI bridge to [bus 08-08]
[    1.526109] pci 0000:07:00.0:   bridge window [io  0xc000-0xcfff]
[    1.532189] pci 0000:07:00.0:   bridge window [mem 0xfb300000-0xfb3fffff]
[    1.538963] pci 0000:07:00.0:   bridge window [mem 0xd0000000-0xd3ffffff 64bit pref]
[    1.546693] pci 0000:05:04.0: PCI bridge to [bus 07-08]
[    1.551903] pci 0000:05:04.0:   bridge window [io  0xc000-0xcfff]
[    1.557983] pci 0000:05:04.0:   bridge window [mem 0xfb300000-0xfb3fffff]
[    1.564756] pci 0000:05:04.0:   bridge window [mem 0xd0000000-0xd3ffffff 64bit pref]
[    1.572477] pci 0000:05:05.0: PCI bridge to [bus 09-09]
[    1.577696] pci 0000:05:05.0:   bridge window [mem 0xfb200000-0xfb2fffff]
[    1.584475] pci 0000:05:06.0: PCI bridge to [bus 0a-0a]
[    1.589684] pci 0000:05:06.0:   bridge window [io  0xb000-0xbfff]
[    1.595768] pci 0000:05:06.0:   bridge window [mem 0xd4000000-0xd40fffff 64bit pref]
[    1.603494] pci 0000:05:07.0: PCI bridge to [bus 0b-0b]
[    1.608706] pci 0000:05:07.0:   bridge window [io  0xa000-0xafff]
[    1.614786] pci 0000:05:07.0:   bridge window [mem 0xfb100000-0xfb1fffff]
[    1.621567] pci 0000:05:08.0: PCI bridge to [bus 0c-0c]
[    1.626793] pci 0000:05:09.0: PCI bridge to [bus 0d-0d]
[    1.632022] pci 0000:04:00.0: PCI bridge to [bus 05-0d]
[    1.637234] pci 0000:04:00.0:   bridge window [io  0xa000-0xcfff]
[    1.643312] pci 0000:04:00.0:   bridge window [mem 0xfb100000-0xfb4fffff]
[    1.650085] pci 0000:04:00.0:   bridge window [mem 0xd0000000-0xd40fffff 64bit pref]
[    1.657806] pci 0000:00:1c.7: PCI bridge to [bus 04-0d]
[    1.663020] pci 0000:00:1c.7:   bridge window [io  0xa000-0xcfff]
[    1.669097] pci 0000:00:1c.7:   bridge window [mem 0xfb100000-0xfb5fffff]
[    1.675862] pci 0000:00:1c.7:   bridge window [mem 0xd0000000-0xd40fffff 64bit pref]
[    1.683592] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    1.690284] pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    1.696974] pci 0000:00:1c.6: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    1.703663] pci 0000:00:1c.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    1.710351] pci 0000:04:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    1.717044] pci 0000:05:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.723732] pci 0000:05:04.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    1.730420] pci 0000:07:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    1.737111] pci 0000:05:05.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.743807] pci 0000:05:06.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    1.750493] pci 0000:05:07.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    1.757184] pci 0000:05:08.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    1.763874] pci 0000:05:09.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.770651] NET: Registered protocol family 2
[    1.775098] IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    1.782782] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    1.791062] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    1.797859] TCP: Hash tables configured (established 524288 bind 65536)
[    1.804454] TCP reno registered
[    1.807596] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    1.813694] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    1.820270] NET: Registered protocol family 1
[    2.070372] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    2.076794] Placing 64MB software IO TLB between ffff8800baee2000 - ffff8800beee2000
[    2.084510] software IO TLB at phys 0xbaee2000 - 0xbeee2000
[    2.090867] audit: initializing netlink socket (disabled)
[    2.096258] type=2000 audit(1323706554.485:1): initialized
[    2.120413] Btrfs loaded
[    2.122951] msgmni has been set to 15968
[    2.127217] NET: Registered protocol family 38
[    2.131667] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    2.139040] io scheduler noop registered
[    2.142975] io scheduler cfq registered (default)
[    2.149778] pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
[    2.156724] pci 0000:01:00.0: Signaling PME through PCIe PME interrupt
[    2.163247] pcieport 0000:00:1c.4: Signaling PME through PCIe PME interrupt
[    2.170185] pci 0000:02:00.0: Signaling PME through PCIe PME interrupt
[    2.176711] pcieport 0000:00:1c.6: Signaling PME through PCIe PME interrupt
[    2.183650] pci 0000:03:00.0: Signaling PME through PCIe PME interrupt
[    2.190177] pcieport 0000:00:1c.7: Signaling PME through PCIe PME interrupt
[    2.197114] pcieport 0000:04:00.0: Signaling PME through PCIe PME interrupt
[    2.204054] pcieport 0000:05:01.0: Signaling PME through PCIe PME interrupt
[    2.210994] pci 0000:06:00.0: Signaling PME through PCIe PME interrupt
[    2.217501] pcieport 0000:05:04.0: Signaling PME through PCIe PME interrupt
[    2.224440] pci 0000:07:00.0: Signaling PME through PCIe PME interrupt
[    2.230947] pci 0000:08:00.0: Signaling PME through PCIe PME interrupt
[    2.237455] pci 0000:08:01.0: Signaling PME through PCIe PME interrupt
[    2.243962] pcieport 0000:05:05.0: Signaling PME through PCIe PME interrupt
[    2.250900] pci 0000:09:00.0: Signaling PME through PCIe PME interrupt
[    2.257409] pcieport 0000:05:06.0: Signaling PME through PCIe PME interrupt
[    2.264348] pci 0000:0a:00.0: Signaling PME through PCIe PME interrupt
[    2.270854] pcieport 0000:05:07.0: Signaling PME through PCIe PME interrupt
[    2.277795] pci 0000:0b:00.0: Signaling PME through PCIe PME interrupt
[    2.284301] pcieport 0000:05:08.0: Signaling PME through PCIe PME interrupt
[    2.291242] pcieport 0000:05:09.0: Signaling PME through PCIe PME interrupt
[    2.298216] vesafb: mode is 1920x1200x32, linelength=7680, pages=0
[    2.304378] vesafb: scrolling: redraw
[    2.308035] vesafb: Truecolor: size=8:8:8:8, shift=24:16:8:0
[    2.314192] vesafb: framebuffer at 0xf9000000, mapped to 0xffffc90011800000, using 9024k, total 9024k
[    2.406602] Console: switching to colour frame buffer device 240x75
[    2.492666] fb0: VESA VGA frame buffer device
[    2.497302] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[    2.505891] ACPI: Power Button [PWRB]
[    2.509769] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    2.517530] ACPI: Power Button [PWRF]
[    2.521514] ERST: Table is not found!
[    2.525398] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    2.552551] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.579481] 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.585481] Linux agpgart interface v0.103
[    2.589903] aic7xxx 0000:08:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.806691] scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 7.0
[    2.806692]         <Adaptec 2940 Ultra2 SCSI adapter>
[    2.806692]         aic7890/91: Ultra2 Wide Channel A, SCSI Id=7, 32/253 SCBs
[    2.806693] 
[    2.828395] ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    2.845968] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x3f impl SATA mode
[    2.854582] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ems apst 
[    2.873121] scsi1 : ahci
[    2.875823] scsi2 : ahci
[    2.878518] scsi3 : ahci
[    2.881213] scsi4 : ahci
[    2.883911] scsi5 : ahci
[    2.886606] scsi6 : ahci
[    2.889348] ata1: SATA max UDMA/133 abar m2048@0xfb805000 port 0xfb805100 irq 52
[    2.897109] ata2: SATA max UDMA/133 abar m2048@0xfb805000 port 0xfb805180 irq 52
[    2.904868] ata3: SATA max UDMA/133 abar m2048@0xfb805000 port 0xfb805200 irq 52
[    2.912629] ata4: SATA max UDMA/133 abar m2048@0xfb805000 port 0xfb805280 irq 52
[    2.920391] ata5: SATA max UDMA/133 abar m2048@0xfb805000 port 0xfb805300 irq 52
[    2.928162] ata6: SATA max UDMA/133 abar m2048@0xfb805000 port 0xfb805380 irq 52
[    2.928176] ahci 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.928292] ahci 0000:02:00.0: AHCI 0001.0000 32 slots 2 ports 6 Gbps 0x3 impl SATA mode
[    2.928294] ahci 0000:02:00.0: flags: 64bit ncq sntf led only pmp fbs pio slum part sxs 
[    2.928475] scsi7 : ahci
[    2.928517] scsi8 : ahci
[    2.928546] ata7: SATA max UDMA/133 abar m2048@0xfb710000 port 0xfb710100 irq 53
[    2.928548] ata8: SATA max UDMA/133 abar m2048@0xfb710000 port 0xfb710180 irq 53
[    2.928563] ahci 0000:0b:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    2.928715] ahci 0000:0b:00.0: AHCI 0001.0000 32 slots 2 ports 6 Gbps 0x3 impl SATA mode
[    2.928717] ahci 0000:0b:00.0: flags: 64bit ncq sntf led only pmp fbs pio slum part sxs 
[    2.928973] scsi9 : ahci
[    2.929032] scsi10 : ahci
[    2.929076] ata9: SATA max UDMA/133 abar m2048@0xfb110000 port 0xfb110100 irq 54
[    2.929080] ata10: SATA max UDMA/133 abar m2048@0xfb110000 port 0xfb110180 irq 54
[    2.929172] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    2.931854] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.931857] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.931922] mousedev: PS/2 mouse device common for all mice
[    2.931991] rtc_cmos 00:05: RTC can wake from S4
[    2.932121] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[    2.932161] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    2.936054] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.07
[    2.936081] iTCO_wdt: Found a Cougar Point TCO device (Version=2, TCOBASE=0x0460)
[    2.936110] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    3.088660] scsi 0:0:1:0: Direct-Access     IBM-PCCO ST39102LC     !# B219 PQ: 0 ANSI: 2
[    3.088663] scsi0:A:1:0: Tagged Queuing enabled.  Depth 8
[    3.088666] scsi target0:0:1: Beginning Domain Validation
[    3.095482] scsi target0:0:1: wide asynchronous
[    3.100454] scsi target0:0:1: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, offset 15)
[    3.104744] scsi target0:0:1: Domain Validation skipping write tests
[    3.104745] scsi target0:0:1: Ending Domain Validation
[    3.231842] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    3.231858] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    3.231871] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    3.231883] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    3.231892] ata4: SATA link down (SStatus 0 SControl 300)
[    3.231908] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    3.232121] ata1.00: ATA-9: C300-CTFDDAC064MAG, 0006, max UDMA/100
[    3.232122] ata1.00: 125045424 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    3.232339] ata5.00: ATAPI: TSSTcorp CDDVDW SH-222AB, SB00, max UDMA/100
[    3.232361] ata1.00: configured for UDMA/100
[    3.232367] scsi: waiting for bus probes to complete ...
[    3.232840] ata10: SATA link down (SStatus 0 SControl 330)
[    3.232869] ata9: SATA link down (SStatus 0 SControl 330)
[    3.233124] ata5.00: configured for UDMA/100
[    3.233235] ata3.00: ATA-8: Hitachi HDS722020ALA330, JKAOA3MA, max UDMA/133
[    3.233236] ata3.00: 3907029168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    3.233831] ata6.00: ATA-8: SAMSUNG HD403LJ, CT100-10, max UDMA7
[    3.233832] ata6.00: 781422768 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    3.234742] ata3.00: configured for UDMA/133
[    3.235209] ata2.00: ATA-6: WDC WD360GD-00FLA2, 31.08F31, max UDMA/133
[    3.235210] ata2.00: 72303840 sectors, multi 16: LBA48 
[    3.235790] ata6.00: configured for UDMA/133
[    3.239581] ata2.00: configured for UDMA/133
[    3.863825] Refined TSC clocksource calibration: 3392.293 MHz.
[    3.883785] Switching to clocksource tsc
[    3.883808] device-mapper: ioctl: 4.22.0-ioctl (2011-10-19) initialised: dm-devel@redhat.com
[    3.924596] cpuidle: using governor ladder
[    3.942713] cpuidle: using governor menu
[    3.960537] TCP cubic registered
[    3.977230] Initializing XFRM netlink socket
[    3.995231] NET: Registered protocol family 10
[    4.013725] IPv6 over IPv4 tunneling driver
[    4.031740] NET: Registered protocol family 17
[    4.049685] NET: Registered protocol family 15
[    4.067631] Registering the dns_resolver key type
[    4.067692] registered taskstats version 1
[    4.074089] scsi: waiting for bus probes to complete ...
[    4.127317] ata7: SATA link up 1.5 Gbps (SStatus 113 SControl 330)
[    4.148438] ata7.00: ATAPI: LITE-ON LTR-48246S, SS0E, max UDMA/33
[    4.169640] ata7.00: configured for UDMA/33
[    4.269892] ata8: SATA link up 3.0 Gbps (SStatus 123 SControl 330)
[    4.317621] ata8.00: ATA-8: WDC WD15EARS-00Z5B1, 80.00A80, max UDMA/133
[    4.338454] ata8.00: 2930277168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
[    4.364135] ata8.00: configured for UDMA/133
[    6.450325] sd 0:0:1:0: Attached scsi generic sg0 type 0
[    6.470550] rtc_cmos 00:05: setting system clock to 2011-12-12 16:16:00 UTC (1323706560)
[    6.470616] scsi 1:0:0:0: Direct-Access     ATA      C300-CTFDDAC064M 0006 PQ: 0 ANSI: 5
[    6.470735] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    6.470786] sd 1:0:0:0: [sdb] 125045424 512-byte logical blocks: (64.0 GB/59.6 GiB)
[    6.470819] sd 0:0:1:0: [sda] 17774160 512-byte logical blocks: (9.10 GB/8.47 GiB)
[    6.470821] sd 1:0:0:0: [sdb] Write Protect is off
[    6.470829] scsi 2:0:0:0: Direct-Access     ATA      WDC WD360GD-00FL 31.0 PQ: 0 ANSI: 5
[    6.470838] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    6.470923] sd 2:0:0:0: Attached scsi generic sg2 type 0
[    6.470933] sd 2:0:0:0: [sdc] 72303840 512-byte logical blocks: (37.0 GB/34.4 GiB)
[    6.470966] sd 2:0:0:0: [sdc] Write Protect is off
[    6.470984] sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    6.471041] scsi 3:0:0:0: Direct-Access     ATA      Hitachi HDS72202 JKAO PQ: 0 ANSI: 5
[    6.471171] sd 3:0:0:0: Attached scsi generic sg3 type 0
[    6.471182] sd 3:0:0:0: [sdd] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[    6.471276] sd 3:0:0:0: [sdd] Write Protect is off
[    6.471308] sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    6.471757] scsi 5:0:0:0: CD-ROM            TSSTcorp CDDVDW SH-222AB  SB00 PQ: 0 ANSI: 5
[    6.471886]  sdb: sdb1
[    6.472817] sd 0:0:1:0: [sda] Write Protect is off
[    6.474148] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[    6.474149] cdrom: Uniform CD-ROM driver Revision: 3.20
[    6.474246] sr 5:0:0:0: Attached scsi generic sg4 type 5
[    6.474333] scsi 6:0:0:0: Direct-Access     ATA      SAMSUNG HD403LJ  CT10 PQ: 0 ANSI: 5
[    6.474394] sd 6:0:0:0: [sde] 781422768 512-byte logical blocks: (400 GB/372 GiB)
[    6.474396] sd 6:0:0:0: Attached scsi generic sg5 type 0
[    6.474403] sd 0:0:1:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    6.474433] sd 6:0:0:0: [sde] Write Protect is off
[    6.474446] sd 6:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    6.487776]  sda: sda1 sda2
[    6.518245]  sdd: sdd1
[    6.519296]  sdc: sdc1 sdc2
[    6.523418]  sde: sde1
[    6.671006] scsi 7:0:0:0: CD-ROM            LITE-ON  LTR-48246S       SS0E PQ: 0 ANSI: 5
[    7.149013] sr1: scsi3-mmc drive: 50x/48x writer cd/rw xa/form2 cdda tray
[    7.262652] sd 1:0:0:0: [sdb] Attached SCSI disk
[    7.262676] sr 7:0:0:0: Attached scsi generic sg6 type 5
[    7.262678] sd 2:0:0:0: [sdc] Attached SCSI disk
[    7.262706] sd 3:0:0:0: [sdd] Attached SCSI disk
[    7.262707] sd 6:0:0:0: [sde] Attached SCSI disk
[    7.262730] scsi 8:0:0:0: Direct-Access     ATA      WDC WD15EARS-00Z 80.0 PQ: 0 ANSI: 5
[    7.262780] sd 8:0:0:0: [sdf] 2930277168 512-byte logical blocks: (1.50 TB/1.36 TiB)
[    7.262791] sd 8:0:0:0: Attached scsi generic sg7 type 0
[    7.262808] sd 8:0:0:0: [sdf] Write Protect is off
[    7.262819] sd 8:0:0:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    7.493477] sd 0:0:1:0: [sda] Attached SCSI disk
[    7.522216]  sdf: sdf1
[    7.541237] sd 8:0:0:0: [sdf] Attached SCSI disk
[    7.577353] EXT4-fs (sdb1): mounted filesystem with ordered data mode. Opts: (null)
[    7.601524] VFS: Mounted root (ext4 filesystem) readonly on device 8:17.
[    7.625428] devtmpfs: mounted
[    7.644587] Freeing unused kernel memory: 672k freed
[    7.785833] udevd[154]: starting version 175
[    7.845758] usbcore: registered new interface driver usbfs
[    7.845766] usbcore: registered new interface driver hub
[    7.846050] wmi: Mapper loaded
[    7.846198] usbcore: registered new device driver usb
[    7.847013] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    7.847029] ehci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    7.847052] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[    7.847057] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    7.847078] ehci_hcd 0000:00:1a.0: debug port 2
[    7.850785] xhci_hcd 0000:03:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    7.850809] xhci_hcd 0000:03:00.0: xHCI Host Controller
[    7.850813] xhci_hcd 0000:03:00.0: new USB bus registered, assigned bus number 2
[    7.850950] ehci_hcd 0000:00:1a.0: irq 16, io mem 0xfb807000
[    7.850958] xhci_hcd 0000:03:00.0: irq 18, io mem 0xfb600000
[    7.850983] xhci_hcd 0000:03:00.0: Failed to enable MSI-X
[    7.851182] hub 2-0:1.0: USB hub found
[    7.851189] hub 2-0:1.0: 2 ports detected
[    7.851227] xhci_hcd 0000:03:00.0: xHCI Host Controller
[    7.851230] xhci_hcd 0000:03:00.0: new USB bus registered, assigned bus number 3
[    7.851290] hub 3-0:1.0: USB hub found
[    7.851296] hub 3-0:1.0: 2 ports detected
[    7.851334] xhci_hcd 0000:06:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    7.851351] xhci_hcd 0000:06:00.0: xHCI Host Controller
[    7.851355] xhci_hcd 0000:06:00.0: new USB bus registered, assigned bus number 4
[    7.851519] xhci_hcd 0000:06:00.0: irq 16, io mem 0xfb400000
[    7.851543] xhci_hcd 0000:06:00.0: Failed to enable MSI-X
[    7.851766] hub 4-0:1.0: USB hub found
[    7.851773] hub 4-0:1.0: 2 ports detected
[    7.851807] xhci_hcd 0000:06:00.0: xHCI Host Controller
[    7.851809] xhci_hcd 0000:06:00.0: new USB bus registered, assigned bus number 5
[    7.851874] hub 5-0:1.0: USB hub found
[    7.851882] hub 5-0:1.0: 2 ports detected
[    7.851929] xhci_hcd 0000:09:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    7.851947] xhci_hcd 0000:09:00.0: xHCI Host Controller
[    7.851950] xhci_hcd 0000:09:00.0: new USB bus registered, assigned bus number 6
[    7.852114] xhci_hcd 0000:09:00.0: irq 16, io mem 0xfb200000
[    7.852136] xhci_hcd 0000:09:00.0: Failed to enable MSI-X
[    7.852338] hub 6-0:1.0: USB hub found
[    7.852345] hub 6-0:1.0: 2 ports detected
[    7.852381] xhci_hcd 0000:09:00.0: xHCI Host Controller
[    7.852383] xhci_hcd 0000:09:00.0: new USB bus registered, assigned bus number 7
[    7.852450] hub 7-0:1.0: USB hub found
[    7.852457] hub 7-0:1.0: 2 ports detected
[    7.854577] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    7.854591] r8169 0000:0a:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    7.860623] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    7.860794] hub 1-0:1.0: USB hub found
[    7.860797] hub 1-0:1.0: 2 ports detected
[    7.860844] ehci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    8.780620] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[    8.780636] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 8
[    8.780673] ehci_hcd 0000:00:1d.0: debug port 2
[    8.780842] r8169 0000:0a:00.0: eth0: RTL8168e/8111e at 0xffffc90000c7c000, 00:25:22:9f:75:32, XID 0c200000 IRQ 58
[    8.780844] r8169 0000:0a:00.0: eth0: jumbo features [frames: 9200 bytes, tx checksumming: ko]
[    8.781150] FDC 0 is a post-1991 82077
[    8.784578] ehci_hcd 0000:00:1d.0: irq 23, io mem 0xfb806000
[    8.793916] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    8.794027] hub 8-0:1.0: USB hub found
[    8.794030] hub 8-0:1.0: 2 ports detected
[    8.794071] i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    8.794183] snd_hda_intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    9.002324] usb 1-1: new high-speed USB device number 2 using ehci_hcd
[    9.158894] hub 1-1:1.0: USB hub found
[    9.159127] hub 1-1:1.0: 6 ports detected
[    9.261605] usb 8-1: new high-speed USB device number 2 using ehci_hcd
[    9.396840] hub 8-1:1.0: USB hub found
[    9.416019] hub 8-1:1.0: 8 ports detected
[    9.708458] usb 8-1.1: new low-speed USB device number 3 using ehci_hcd
[    9.874980] usb 8-1.2: new high-speed USB device number 4 using ehci_hcd
[    9.961398] Adding 4194300k swap on /dev/sdc1.  Priority:-1 extents:1 across:4194300k 
[    9.989762] hub 8-1.2:1.0: USB hub found
[    9.989893] hub 8-1.2:1.0: 3 ports detected
[   10.040985] EXT4-fs (sdb1): re-mounted. Opts: (null)
[   10.063474] usb 8-1.7: new high-speed USB device number 5 using ehci_hcd
[   10.152833] EXT4-fs (sdb1): re-mounted. Opts: discard
[   10.250898] usb 8-1.8: new low-speed USB device number 6 using ehci_hcd
[   10.374521] input: Microsoft Microsoft IntelliMouse® Explorer as /devices/pci0000:00/0000:00:1d.0/usb8/8-1/8-1.1/8-1.1:1.0/input/input2
[   10.404124] generic-usb 0003:045E:001E.0001: input,hidraw0: USB HID v1.00 Mouse [Microsoft Microsoft IntelliMouse® Explorer] on usb-0000:00:1d.0-1.1/input0
[   10.438346] input: USBPS2 as /devices/pci0000:00/0000:00:1d.0/usb8/8-1/8-1.8/8-1.8:1.0/input/input3
[   10.465450] generic-usb 0003:0D3D:0001.0002: input,hidraw1: USB HID v1.00 Keyboard [USBPS2] on usb-0000:00:1d.0-1.8/input0
[   10.494849] usb 8-1.2.2: new low-speed USB device number 7 using ehci_hcd
[   10.498767] input: USBPS2 as /devices/pci0000:00/0000:00:1d.0/usb8/8-1/8-1.8/8-1.8:1.1/input/input4
[   10.498848] generic-usb 0003:0D3D:0001.0003: input,hidraw2: USB HID v1.00 Mouse [USBPS2] on usb-0000:00:1d.0-1.8/input1
[   10.498874] usbcore: registered new interface driver usbhid
[   10.498875] usbhid: USB HID core driver
[   10.587522] input: Apple, Inc Apple Keyboard as /devices/pci0000:00/0000:00:1d.0/usb8/8-1/8-1.2/8-1.2.2/8-1.2.2:1.0/input/input5
[   10.587601] apple 0003:05AC:0220.0004: input,hidraw3: USB HID v1.11 Keyboard [Apple, Inc Apple Keyboard] on usb-0000:00:1d.0-1.2.2/input0
[   10.590424] input: Apple, Inc Apple Keyboard as /devices/pci0000:00/0000:00:1d.0/usb8/8-1/8-1.2/8-1.2.2/8-1.2.2:1.1/input/input6
[   10.590494] apple 0003:05AC:0220.0005: input,hidraw4: USB HID v1.11 Device [Apple, Inc Apple Keyboard] on usb-0000:00:1d.0-1.2.2/input1
[   10.827130] w83627ehf: Found NCT6776F chip at 0x290
[   10.830908] fuse init (API version 7.17)
[   10.838360] i2c /dev entries driver
[   10.841633] uhci_hcd: USB Universal Host Controller Interface driver
[   10.843321] ipmi message handler version 39.2
[   11.801833] EXT4-fs (sdc2): mounted filesystem with ordered data mode. Opts: (null)
[   11.884535] EXT4-fs (sdd1): mounted filesystem with ordered data mode. Opts: (null)
[   11.923124] REISERFS (device sda1): found reiserfs format "3.6" with standard journal
[   11.948425] REISERFS (device sda1): using ordered data mode
[   11.971028] reiserfs: using flush barriers
[   11.996849] REISERFS (device sda1): journal params: device sda1, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
[   12.029721] REISERFS (device sda1): checking transaction log (sda1)
[   12.086397] REISERFS (device sda1): Using r5 hash to sort names
[   12.176635] EXT4-fs (sdf1): mounted filesystem with ordered data mode. Opts: (null)
[   12.387833] r8169 0000:0a:00.0: eth0: unable to load firmware patch rtl_nic/rtl8168e-2.fw (-2)
[   12.421246] r8169 0000:0a:00.0: eth0: link down
[   12.421582] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   14.802259] r8169 0000:0a:00.0: eth0: link up
[   14.820869] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   17.168658] RPC: Registered named UNIX socket transport module.
[   17.168659] RPC: Registered udp transport module.
[   17.168660] RPC: Registered tcp transport module.
[   17.168661] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   17.258509] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   17.344335] tun: Universal TUN/TAP device driver, 1.6
[   17.365785] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   17.366927] ADDRCONF(NETDEV_UP): tap0: link is not ready
[   17.391764] device eth0 entered promiscuous mode
[   17.392979] device tap0 entered promiscuous mode
[   17.393708] br0: port 1(eth0) entering forwarding state
[   17.393711] br0: port 1(eth0) entering forwarding state
[   23.531880] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
[   23.532342] NFSD: starting 90-second grace period
[   23.723041] [drm] Initialized drm 1.1.0 20060810
[   23.732738] MXM: GUID detected in BIOS
[   23.736495] nouveau 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   23.744123] [drm] nouveau 0000:01:00.0: Detected an NV50 generation card (0x084200a2)
[   23.751930] fb: conflicting fb hw usage nouveaufb vs VESA VGA - removing generic driver
[   23.759941] Console: switching to colour dummy device 80x25
[   23.767661] [drm] nouveau 0000:01:00.0: Attempting to load BIOS image from PRAMIN
[   23.880210] [drm] nouveau 0000:01:00.0: ... appears to be valid
[   23.886112] [drm] nouveau 0000:01:00.0: BIT BIOS found
[   23.891237] [drm] nouveau 0000:01:00.0: Bios version 60.84.51.00
[   23.897226] [drm] nouveau 0000:01:00.0: TMDS table version 2.0
[   23.903041] [drm] nouveau 0000:01:00.0: Found Display Configuration Block version 4.0
[   23.910845] [drm] nouveau 0000:01:00.0: Raw DCB entry 0: 02000300 00000028
[   23.917698] [drm] nouveau 0000:01:00.0: Raw DCB entry 1: 01000302 00020030
[   23.924552] [drm] nouveau 0000:01:00.0: Raw DCB entry 2: 04011310 00000028
[   23.931405] [drm] nouveau 0000:01:00.0: Raw DCB entry 3: 02011312 00020030
[   23.938258] [drm] nouveau 0000:01:00.0: Raw DCB entry 4: 010223f1 00c0c080
[   23.945112] [drm] nouveau 0000:01:00.0: DCB connector table: VHER 0x40 5 14 2
[   23.952223] [drm] nouveau 0000:01:00.0:   0: 0x00002030: type 0x30 idx 0 tag 0x08
[   23.959688] [drm] nouveau 0000:01:00.0:   1: 0x00001130: type 0x30 idx 1 tag 0x07
[   23.967141] [drm] nouveau 0000:01:00.0:   2: 0x00000210: type 0x10 idx 2 tag 0xff
[   23.974597] [drm] nouveau 0000:01:00.0:   3: 0x00000211: type 0x11 idx 3 tag 0xff
[   23.982056] [drm] nouveau 0000:01:00.0:   4: 0x00000213: type 0x13 idx 4 tag 0xff
[   23.989517] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 0 at offset 0xC1BE
[   24.020376] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 1 at offset 0xC50B
[   24.044840] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 2 at offset 0xCF58
[   24.052481] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 3 at offset 0xD04A
[   24.061201] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 4 at offset 0xD27D
[   24.068831] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table at offset 0xD2E2
[   24.096235] [drm] nouveau 0000:01:00.0: 0xD2E2: Condition still not met after 20ms, skipping following opcodes
[   24.125550] [drm] nouveau 0000:01:00.0: 1 available performance level(s)
[   24.132228] [drm] nouveau 0000:01:00.0: 0: core 580MHz shader 1508MHz memory 800MHz fanspeed 100%
[   24.141103] [drm] nouveau 0000:01:00.0: c: core 540MHz shader 1512MHz memory 702MHz voltage 1320mV
[   24.151394] [TTM] Zone  kernel: Available graphics memory: 4088300 kiB.
[   24.157986] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB.
[   24.164582] [TTM] Initializing pool allocator.
[   24.169022] [drm] nouveau 0000:01:00.0: Detected 256MiB VRAM
[   24.174668] mtrr: type mismatch for c0000000,10000000 old: write-back new: write-combining
[   24.182938] [drm] nouveau 0000:01:00.0: 512 MiB GART (aperture)
[   24.199293] [drm] nouveau 0000:01:00.0: DCB encoder 1 unknown
[   24.205026] [drm] nouveau 0000:01:00.0: TV-1 has no encoders, removing
[   24.226756] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[   24.233364] [drm] No driver support for vblank timestamp query.
[   24.239267] parse error at position 4 in video mode 'efifb'
[   24.244829] parse error at position 4 in video mode 'efifb'
[   24.469199] [drm] nouveau 0000:01:00.0: allocated 1920x1200 fb: 0x320000, bo ffff88023535a400
[   24.477808] fbcon: nouveaufb (fb0) is primary device
[   24.482814] Console: switching to colour frame buffer device 160x64
[   24.489058] fb0: nouveaufb frame buffer device
[   24.493490] drm: registered panic notifier
[   24.497580] [drm] Initialized nouveau 0.0.16 20090420 for 0000:01:00.0 on minor 0

Debian GNU/Linux wheezy/sid luna ttyS0

luna login: [   32.363396] br0: port 1(eth0) entering forwarding state
[   37.019052] EXT4-fs (sdb1): re-mounted. Opts: discard,commit=0
[   37.026396] EXT4-fs (sdc2): re-mounted. Opts: commit=0
[   37.032583] EXT4-fs (sdd1): re-mounted. Opts: commit=0
[   37.038728] EXT4-fs (sdf1): re-mounted. Opts: commit=0

--------------050807050609090302090303--

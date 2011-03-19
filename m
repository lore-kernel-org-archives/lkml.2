Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573Ab1CSOmE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Mar 2011 10:42:04 -0400
Received: from 5.27.mail-out.ovh.net ([46.105.44.170]:43320 "HELO
	27.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1752130Ab1CSOmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Mar 2011 10:42:01 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sat, 19 Mar 2011 10:42:00 EDT
Message-ID: <4D84BF1D.2010407@example.com>
Date: Sat, 19 Mar 2011 15:35:09 +0100
From: Piotr Hosowicz <piotr@hosowicz.com>
Reply-To: LKML <linux-kernel@vger.kernel.org>
Organization: hosowicz.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110307 Icedove/3.0.11
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: No networking since git3
References: <4D84A46B.1000407@example.com>
In-Reply-To: <4D84A46B.1000407@example.com>
Content-Type: multipart/mixed;
 boundary="------------050603090107040209070909"
X-Ovh-Tracer-Id: 13771444710817362200
X-Ovh-Remote: 178.36.62.164 (178-36-62-164.adsl.inetia.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050603090107040209070909
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit

On 19.03.2011 13:41, Piotr Hosowicz wrote:
> Hello,
>
> I wrote lately, the problem persists, that's why I write again. I tested
> git7 just now and it still does not work.
>
> What are the the symptoms? Straight after booting (Debian 6) mii-tool
> shows no link for the NICs. I attach ethtool eth0 output from this
> moment, also a good boot with git3 marked as GOOD. I attach also lspci
> output, with -vv and with no options.

I attach my dmesgs now. BAD (still) is for git8, GOOD is for git3.

Regards,

Piotr Hosowicz

-- 
Miss World 2006: Jestem szczê¶liwa, ¿e mogê wspaniale uczestniczyæ w
prze¿yciu najpiêkniejszych kobiet tutaj w Warszawie, gdzie Jan Pawe³ II,
papie¿, w Polsce, sk±d pochodzi. Spotka³am siê z Ko¶cio³em Mariackim
w Krakowie, który ciep³o ludzi i wielka przyja¼ñ. Po³owa mojego serca
zostanie w Polsce, a druga po³owa pojedzie ze mn± do mojego kraju.
NP: Big Big Train - Master James Of St George
NB: 2.6.38-git3

--------------050603090107040209070909
Content-Type: text/plain;
 name="dmesg.BAD.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg.BAD.txt"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.38-git8 (root@aapi205) (gcc version 4.4.5 (Debian 4.4.5-10) ) #1 SMP PREEMPT Sat Mar 19 14:50:31 CET 2011
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-2.6.38-git8 root=UUID=cdb6c166-b027-4a29-87fa-93d604dc5e53 ro all_generic_ata quiet
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000dfee0000 (usable)
[    0.000000]  BIOS-e820: 00000000dfee0000 - 00000000dfee2000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000dfee2000 - 00000000dfef0000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000dfef0000 - 00000000dff00000 (reserved)
[    0.000000]  BIOS-e820: 00000000f4000000 - 00000000f8000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000120000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] DMI: Gigabyte Technology Co., Ltd. EP45-UD3/EP45-UD3, BIOS F10b 08/05/2010
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x120000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CDFFF write-protect
[    0.000000]   CE000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-through
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F00000000 write-back
[    0.000000]   1 base 0E0000000 mask FE0000000 uncachable
[    0.000000]   2 base 100000000 mask FE0000000 write-back
[    0.000000]   3 base 0DFF00000 mask FFFF00000 uncachable
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000dff00000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xdfee0 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [ffff8800000f5670] f5670
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff88000009a000] 9a000 size 20480
[    0.000000] init_memory_mapping: 0000000000000000-00000000dfee0000
[    0.000000]  0000000000 - 00dfe00000 page 2M
[    0.000000]  00dfe00000 - 00dfee0000 page 4k
[    0.000000] kernel direct mapping tables up to dfee0000 @ dfeda000-dfee0000
[    0.000000] init_memory_mapping: 0000000100000000-0000000120000000
[    0.000000]  0100000000 - 0120000000 page 2M
[    0.000000] kernel direct mapping tables up to 120000000 @ 11fffa000-120000000
[    0.000000] RAMDISK: 3754e000 - 37ff0000
[    0.000000] ACPI: RSDP 00000000000f7080 00014 (v00 GBT   )
[    0.000000] ACPI: RSDT 00000000dfee2040 00040 (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: FACP 00000000dfee20c0 00074 (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: DSDT 00000000dfee2180 04D29 (v01 GBT    GBTUACPI 00001000 MSFT 0100000C)
[    0.000000] ACPI: FACS 00000000dfee0000 00040
[    0.000000] ACPI: HPET 00000000dfee7000 00038 (v01 GBT    GBTUACPI 42302E31 GBTU 00000098)
[    0.000000] ACPI: MCFG 00000000dfee7080 0003C (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: EUDS 00000000dfee70c0 004D0 (v01 GBT             00000000      00000000)
[    0.000000] ACPI: TAMG 00000000dfee7590 06852 (v01 GBT    GBT   B0 5455312E BG?? 00020101)
[    0.000000] ACPI: APIC 00000000dfee6f00 00084 (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: SSDT 00000000dfeee720 003AB (v01  PmRef    CpuPm 00003000 INTL 20040311)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-0000000120000000
[    0.000000] NUMA: Using 63 for the hash shift.
[    0.000000] Initmem setup node 0 0000000000000000-0000000120000000
[    0.000000]   NODE_DATA [000000011ffeb000 - 000000011fff9fff]
[    0.000000]  [ffffea0000000000-ffffea0003ffffff] PMD -> [ffff88011b600000-ffff88011effffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00120000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000dfee0
[    0.000000]     0: 0x00100000 -> 0x00120000
[    0.000000] On node 0 totalpages: 1048175
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 5 pages reserved
[    0.000000]   DMA zone: 3922 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 898840 pages, LIFO batch:31
[    0.000000]   Normal zone: 1792 pages used for memmap
[    0.000000]   Normal zone: 129280 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000dfee0000 - 00000000dfee2000
[    0.000000] PM: Registered nosave memory: 00000000dfee2000 - 00000000dfef0000
[    0.000000] PM: Registered nosave memory: 00000000dfef0000 - 00000000dff00000
[    0.000000] PM: Registered nosave memory: 00000000dff00000 - 00000000f4000000
[    0.000000] PM: Registered nosave memory: 00000000f4000000 - 00000000f8000000
[    0.000000] PM: Registered nosave memory: 00000000f8000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at dff00000 (gap: dff00000:14100000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88011fc00000 s79488 r8192 d22912 u524288
[    0.000000] pcpu-alloc: s79488 r8192 d22912 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1032042
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-2.6.38-git8 root=UUID=cdb6c166-b027-4a29-87fa-93d604dc5e53 ro all_generic_ata quiet
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 4047080k/4718592k available (3223k kernel code, 525892k absent, 145620k reserved, 3668k data, 584k init)
[    0.000000] Preemptable hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:712 16
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2332.774 MHz processor.
[    0.004004] Calibrating delay loop (skipped), value calculated using timer frequency.. 4665.54 BogoMIPS (lpj=9331096)
[    0.004008] pid_max: default: 32768 minimum: 301
[    0.004061] Security Framework initialized
[    0.004071] SELinux:  Disabled at boot.
[    0.004407] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.008112] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.008801] Mount-cache hash table entries: 256
[    0.008942] Initializing cgroup subsys ns
[    0.008945] ns_cgroup deprecated: consider using the 'clone_children' flag without the ns_cgroup.
[    0.008948] Initializing cgroup subsys cpuacct
[    0.008953] Initializing cgroup subsys devices
[    0.008955] Initializing cgroup subsys blkio
[    0.008995] CPU: Physical Processor ID: 0
[    0.008997] CPU: Processor Core ID: 0
[    0.008999] mce: CPU supports 6 MCE banks
[    0.009007] CPU0: Thermal monitoring enabled (TM2)
[    0.009011] using mwait in idle threads.
[    0.009779] ACPI: Core revision 20110112
[    0.012954] Setting APIC routing to flat
[    0.013256] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.052951] CPU0: Intel(R) Core(TM)2 Quad  CPU   Q8200  @ 2.33GHz stepping 07
[    0.056003] Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
[    0.056003] ... version:                2
[    0.056003] ... bit width:              40
[    0.056003] ... generic registers:      2
[    0.056003] ... value mask:             000000ffffffffff
[    0.056003] ... max period:             000000007fffffff
[    0.056003] ... fixed-purpose events:   3
[    0.056003] ... event mask:             0000000700000003
[    0.076022] Booting Node   0, Processors  #1
[    0.076026] smpboot cpu 1: start_ip = 9a000
[    0.176031]  #2
[    0.176033] smpboot cpu 2: start_ip = 9a000
[    0.276046]  #3 Ok.
[    0.276049] smpboot cpu 3: start_ip = 9a000
[    0.368031] Brought up 4 CPUs
[    0.368034] Total of 4 processors activated (18663.81 BogoMIPS).
[    0.369333] devtmpfs: initialized
[    0.374376] print_constraints: dummy: 
[    0.374376] NET: Registered protocol family 16
[    0.376084] ACPI: bus type pci registered
[    0.376096] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf4000000-0xf7ffffff] (base 0xf4000000)
[    0.376096] PCI: MMCONFIG at [mem 0xf4000000-0xf7ffffff] reserved in E820
[    0.383547] PCI: Using configuration type 1 for base access
[    0.384215] bio: create slab <bio-0> at 0
[    0.389078] ACPI: EC: Look up EC in DSDT
[    0.393460] ACPI Warning: Incorrect checksum in table [TAMG] - 0xB8, should be 0xB7 (20110112/tbutils-314)
[    0.393667] ACPI: SSDT 00000000dfeede40 0022A (v01  PmRef  Cpu0Ist 00003000 INTL 20040311)
[    0.393918] ACPI: Dynamic OEM Table Load:
[    0.393921] ACPI: SSDT           (null) 0022A (v01  PmRef  Cpu0Ist 00003000 INTL 20040311)
[    0.394097] ACPI: SSDT 00000000dfeee300 00152 (v01  PmRef  Cpu1Ist 00003000 INTL 20040311)
[    0.394338] ACPI: Dynamic OEM Table Load:
[    0.394341] ACPI: SSDT           (null) 00152 (v01  PmRef  Cpu1Ist 00003000 INTL 20040311)
[    0.394528] ACPI: SSDT 00000000dfeee460 00152 (v01  PmRef  Cpu2Ist 00003000 INTL 20040311)
[    0.394769] ACPI: Dynamic OEM Table Load:
[    0.394772] ACPI: SSDT           (null) 00152 (v01  PmRef  Cpu2Ist 00003000 INTL 20040311)
[    0.394956] ACPI: SSDT 00000000dfeee5c0 00152 (v01  PmRef  Cpu3Ist 00003000 INTL 20040311)
[    0.395198] ACPI: Dynamic OEM Table Load:
[    0.395201] ACPI: SSDT           (null) 00152 (v01  PmRef  Cpu3Ist 00003000 INTL 20040311)
[    0.395388] ACPI: Interpreter enabled
[    0.395391] ACPI: (supports S0 S3 S4 S5)
[    0.395412] ACPI: Using IOAPIC for interrupt routing
[    0.404189] ACPI: No dock devices found.
[    0.404192] HEST: Table not found.
[    0.404195] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.404255] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3f])
[    0.404291] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
[    0.404291] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
[    0.404291] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.404291] pci_root PNP0A03:00: host bridge window [mem 0x000c0000-0x000dffff]
[    0.404291] pci_root PNP0A03:00: host bridge window [mem 0xdff00000-0xfebfffff]
[    0.404291] pci_bus 0000:00: scanning bus
[    0.404291] pci 0000:00:00.0: [8086:2e20] type 0 class 0x000600
[    0.404291] pci 0000:00:00.0: calling quirk_mmio_always_on+0x0/0x17
[    0.404291] pci 0000:00:00.0: calling quirk_resource_alignment+0x0/0x166
[    0.404291] pci 0000:00:00.0: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.404291] pci 0000:00:01.0: [8086:2e21] type 1 class 0x000604
[    0.404291] pci 0000:00:01.0: calling quirk_mmio_always_on+0x0/0x17
[    0.404291] pci 0000:00:01.0: calling quirk_resource_alignment+0x0/0x166
[    0.404291] pci 0000:00:01.0: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.404291] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.404291] pci 0000:00:01.0: PME# disabled
[    0.404291] pci 0000:00:1a.0: [8086:3a37] type 0 class 0x000c03
[    0.404291] pci 0000:00:1a.0: calling quirk_mmio_always_on+0x0/0x17
[    0.404306] pci 0000:00:1a.0: reg 20: [io  0xff00-0xff1f]
[    0.404324] pci 0000:00:1a.0: calling quirk_resource_alignment+0x0/0x166
[    0.404327] pci 0000:00:1a.0: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.404354] pci 0000:00:1a.1: [8086:3a38] type 0 class 0x000c03
[    0.404360] pci 0000:00:1a.1: calling quirk_mmio_always_on+0x0/0x17
[    0.404397] pci 0000:00:1a.1: reg 20: [io  0xfe00-0xfe1f]
[    0.404415] pci 0000:00:1a.1: calling quirk_resource_alignment+0x0/0x166
[    0.404418] pci 0000:00:1a.1: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.404444] pci 0000:00:1a.2: [8086:3a39] type 0 class 0x000c03
[    0.404451] pci 0000:00:1a.2: calling quirk_mmio_always_on+0x0/0x17
[    0.404487] pci 0000:00:1a.2: reg 20: [io  0xfd00-0xfd1f]
[    0.404505] pci 0000:00:1a.2: calling quirk_resource_alignment+0x0/0x166
[    0.404508] pci 0000:00:1a.2: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.404539] pci 0000:00:1a.7: [8086:3a3c] type 0 class 0x000c03
[    0.404546] pci 0000:00:1a.7: calling quirk_mmio_always_on+0x0/0x17
[    0.404558] pci 0000:00:1a.7: reg 10: [mem 0xfdfff000-0xfdfff3ff]
[    0.404607] pci 0000:00:1a.7: calling quirk_resource_alignment+0x0/0x166
[    0.404610] pci 0000:00:1a.7: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.404641] pci 0000:00:1b.0: [8086:3a3e] type 0 class 0x000403
[    0.404645] pci 0000:00:1b.0: calling quirk_mmio_always_on+0x0/0x17
[    0.404659] pci 0000:00:1b.0: reg 10: [mem 0xfdff8000-0xfdffbfff 64bit]
[    0.404693] pci 0000:00:1b.0: calling quirk_resource_alignment+0x0/0x166
[    0.404696] pci 0000:00:1b.0: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.404715] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.404718] pci 0000:00:1b.0: PME# disabled
[    0.404737] pci 0000:00:1c.0: [8086:3a40] type 1 class 0x000604
[    0.404741] pci 0000:00:1c.0: calling quirk_mmio_always_on+0x0/0x17
[    0.404772] pci 0000:00:1c.0: calling quirk_resource_alignment+0x0/0x166
[    0.404775] pci 0000:00:1c.0: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.404796] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.404800] pci 0000:00:1c.0: PME# disabled
[    0.404822] pci 0000:00:1c.3: [8086:3a46] type 1 class 0x000604
[    0.404826] pci 0000:00:1c.3: calling quirk_mmio_always_on+0x0/0x17
[    0.404857] pci 0000:00:1c.3: calling quirk_resource_alignment+0x0/0x166
[    0.404860] pci 0000:00:1c.3: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.404881] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.404885] pci 0000:00:1c.3: PME# disabled
[    0.404905] pci 0000:00:1c.4: [8086:3a48] type 1 class 0x000604
[    0.404909] pci 0000:00:1c.4: calling quirk_mmio_always_on+0x0/0x17
[    0.404940] pci 0000:00:1c.4: calling quirk_resource_alignment+0x0/0x166
[    0.404943] pci 0000:00:1c.4: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.404964] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.404967] pci 0000:00:1c.4: PME# disabled
[    0.404991] pci 0000:00:1d.0: [8086:3a34] type 0 class 0x000c03
[    0.404998] pci 0000:00:1d.0: calling quirk_mmio_always_on+0x0/0x17
[    0.405034] pci 0000:00:1d.0: reg 20: [io  0xfc00-0xfc1f]
[    0.405052] pci 0000:00:1d.0: calling quirk_resource_alignment+0x0/0x166
[    0.405055] pci 0000:00:1d.0: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.405082] pci 0000:00:1d.1: [8086:3a35] type 0 class 0x000c03
[    0.405089] pci 0000:00:1d.1: calling quirk_mmio_always_on+0x0/0x17
[    0.405124] pci 0000:00:1d.1: reg 20: [io  0xfb00-0xfb1f]
[    0.405143] pci 0000:00:1d.1: calling quirk_resource_alignment+0x0/0x166
[    0.405146] pci 0000:00:1d.1: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.405172] pci 0000:00:1d.2: [8086:3a36] type 0 class 0x000c03
[    0.405179] pci 0000:00:1d.2: calling quirk_mmio_always_on+0x0/0x17
[    0.405215] pci 0000:00:1d.2: reg 20: [io  0xfa00-0xfa1f]
[    0.405233] pci 0000:00:1d.2: calling quirk_resource_alignment+0x0/0x166
[    0.405236] pci 0000:00:1d.2: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.405267] pci 0000:00:1d.7: [8086:3a3a] type 0 class 0x000c03
[    0.405274] pci 0000:00:1d.7: calling quirk_mmio_always_on+0x0/0x17
[    0.405286] pci 0000:00:1d.7: reg 10: [mem 0xfdffe000-0xfdffe3ff]
[    0.405335] pci 0000:00:1d.7: calling quirk_resource_alignment+0x0/0x166
[    0.405338] pci 0000:00:1d.7: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.405365] pci 0000:00:1e.0: [8086:244e] type 1 class 0x000604
[    0.405372] pci 0000:00:1e.0: calling quirk_mmio_always_on+0x0/0x17
[    0.405397] pci 0000:00:1e.0: calling quirk_resource_alignment+0x0/0x166
[    0.405400] pci 0000:00:1e.0: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.405427] pci 0000:00:1f.0: [8086:3a18] type 0 class 0x000601
[    0.405435] pci 0000:00:1f.0: calling quirk_mmio_always_on+0x0/0x17
[    0.405501] pci 0000:00:1f.0: calling quirk_resource_alignment+0x0/0x166
[    0.405504] pci 0000:00:1f.0: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.405537] pci 0000:00:1f.2: [8086:3a20] type 0 class 0x000101
[    0.405544] pci 0000:00:1f.2: calling quirk_mmio_always_on+0x0/0x17
[    0.405554] pci 0000:00:1f.2: reg 10: [io  0x0000-0x0007]
[    0.405562] pci 0000:00:1f.2: reg 14: [io  0x0000-0x0003]
[    0.405569] pci 0000:00:1f.2: reg 18: [io  0x0000-0x0007]
[    0.405577] pci 0000:00:1f.2: reg 1c: [io  0x0000-0x0003]
[    0.405584] pci 0000:00:1f.2: reg 20: [io  0xf900-0xf90f]
[    0.405592] pci 0000:00:1f.2: reg 24: [io  0xf800-0xf80f]
[    0.405604] pci 0000:00:1f.2: calling quirk_resource_alignment+0x0/0x166
[    0.405607] pci 0000:00:1f.2: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.405633] pci 0000:00:1f.3: [8086:3a30] type 0 class 0x000c05
[    0.405637] pci 0000:00:1f.3: calling quirk_mmio_always_on+0x0/0x17
[    0.405650] pci 0000:00:1f.3: reg 10: [mem 0xfdffd000-0xfdffd0ff 64bit]
[    0.405670] pci 0000:00:1f.3: reg 20: [io  0x0500-0x051f]
[    0.405687] pci 0000:00:1f.3: calling quirk_resource_alignment+0x0/0x166
[    0.405690] pci 0000:00:1f.3: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.405708] pci 0000:00:1f.5: [8086:3a26] type 0 class 0x000101
[    0.405716] pci 0000:00:1f.5: calling quirk_mmio_always_on+0x0/0x17
[    0.405725] pci 0000:00:1f.5: reg 10: [io  0xf600-0xf607]
[    0.405733] pci 0000:00:1f.5: reg 14: [io  0xf500-0xf503]
[    0.405741] pci 0000:00:1f.5: reg 18: [io  0xf400-0xf407]
[    0.405748] pci 0000:00:1f.5: reg 1c: [io  0xf300-0xf303]
[    0.405756] pci 0000:00:1f.5: reg 20: [io  0xf200-0xf20f]
[    0.405763] pci 0000:00:1f.5: reg 24: [io  0xf100-0xf10f]
[    0.405775] pci 0000:00:1f.5: calling quirk_resource_alignment+0x0/0x166
[    0.405778] pci 0000:00:1f.5: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.405800] pci_bus 0000:00: fixups for bus
[    0.405803] pci 0000:00:01.0: scanning [bus 01-01] behind bridge, pass 0
[    0.405824] pci_bus 0000:01: scanning bus
[    0.405838] pci 0000:01:00.0: [10de:0641] type 0 class 0x000300
[    0.405841] pci 0000:01:00.0: calling quirk_mmio_always_on+0x0/0x17
[    0.405851] pci 0000:01:00.0: reg 10: [mem 0xfa000000-0xfaffffff]
[    0.405861] pci 0000:01:00.0: reg 14: [mem 0xe0000000-0xefffffff 64bit pref]
[    0.405872] pci 0000:01:00.0: reg 1c: [mem 0xf8000000-0xf9ffffff 64bit]
[    0.405880] pci 0000:01:00.0: reg 24: [io  0xbf00-0xbf7f]
[    0.405887] pci 0000:01:00.0: reg 30: [mem 0x00000000-0x0007ffff pref]
[    0.405893] pci 0000:01:00.0: calling quirk_resource_alignment+0x0/0x166
[    0.405933] pci_bus 0000:01: fixups for bus
[    0.405935] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.405938] pci 0000:00:01.0:   bridge window [io  0xb000-0xbfff]
[    0.405941] pci 0000:00:01.0:   bridge window [mem 0xf8000000-0xfbffffff]
[    0.405945] pci 0000:00:01.0:   bridge window [mem 0xe0000000-0xefffffff 64bit pref]
[    0.405948] pci_bus 0000:01: bus scan returning with max=01
[    0.405952] pci 0000:00:1c.0: scanning [bus 02-02] behind bridge, pass 0
[    0.405984] pci_bus 0000:02: scanning bus
[    0.405987] pci_bus 0000:02: fixups for bus
[    0.405989] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.405993] pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.405997] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.406003] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.406005] pci_bus 0000:02: bus scan returning with max=02
[    0.406010] pci 0000:00:1c.3: scanning [bus 03-03] behind bridge, pass 0
[    0.406042] pci_bus 0000:03: scanning bus
[    0.406062] pci 0000:03:00.0: [197b:2363] type 0 class 0x000101
[    0.406067] pci 0000:03:00.0: calling quirk_jmicron_ata+0x0/0x100
[    0.406081] pci 0000:03:00.0: calling quirk_mmio_always_on+0x0/0x17
[    0.406154] pci 0000:03:00.0: reg 24: [mem 0xfddfe000-0xfddfffff]
[    0.406173] pci 0000:03:00.0: calling quirk_resource_alignment+0x0/0x166
[    0.406200] pci 0000:03:00.0: PME# supported from D3hot
[    0.406205] pci 0000:03:00.0: PME# disabled
[    0.406234] pci 0000:03:00.1: [197b:2363] type 0 class 0x000101
[    0.406243] pci 0000:03:00.1: calling quirk_jmicron_ata+0x0/0x100
[    0.406246] pci 0000:03:00.1: calling quirk_mmio_always_on+0x0/0x17
[    0.406263] pci 0000:03:00.1: reg 10: [io  0xef00-0xef07]
[    0.406277] pci 0000:03:00.1: reg 14: [io  0xee00-0xee03]
[    0.406290] pci 0000:03:00.1: reg 18: [io  0xed00-0xed07]
[    0.406304] pci 0000:03:00.1: reg 1c: [io  0xec00-0xec03]
[    0.406317] pci 0000:03:00.1: reg 20: [io  0xeb00-0xeb0f]
[    0.406348] pci 0000:03:00.1: calling quirk_resource_alignment+0x0/0x166
[    0.406388] pci 0000:03:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.406401] pci_bus 0000:03: fixups for bus
[    0.406403] pci 0000:00:1c.3: PCI bridge to [bus 03-03]
[    0.406407] pci 0000:00:1c.3:   bridge window [io  0xe000-0xefff]
[    0.406411] pci 0000:00:1c.3:   bridge window [mem 0xfdd00000-0xfddfffff]
[    0.406417] pci 0000:00:1c.3:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.406419] pci_bus 0000:03: bus scan returning with max=03
[    0.406423] pci 0000:00:1c.4: scanning [bus 04-04] behind bridge, pass 0
[    0.406457] pci_bus 0000:04: scanning bus
[    0.406477] pci 0000:04:00.0: [10ec:8168] type 0 class 0x000200
[    0.406482] pci 0000:04:00.0: calling quirk_mmio_always_on+0x0/0x17
[    0.406496] pci 0000:04:00.0: reg 10: [io  0xde00-0xdeff]
[    0.406524] pci 0000:04:00.0: reg 18: [mem 0xfdeff000-0xfdefffff 64bit pref]
[    0.406542] pci 0000:04:00.0: reg 20: [mem 0xfdee0000-0xfdeeffff 64bit pref]
[    0.406554] pci 0000:04:00.0: reg 30: [mem 0x00000000-0x0000ffff pref]
[    0.406561] pci 0000:04:00.0: calling quirk_resource_alignment+0x0/0x166
[    0.406595] pci 0000:04:00.0: supports D1 D2
[    0.406597] pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.406601] pci 0000:04:00.0: PME# disabled
[    0.412041] pci_bus 0000:04: fixups for bus
[    0.412044] pci 0000:00:1c.4: PCI bridge to [bus 04-04]
[    0.412048] pci 0000:00:1c.4:   bridge window [io  0xd000-0xdfff]
[    0.412053] pci 0000:00:1c.4:   bridge window [mem 0xfdb00000-0xfdbfffff]
[    0.412059] pci 0000:00:1c.4:   bridge window [mem 0xfde00000-0xfdefffff 64bit pref]
[    0.412062] pci_bus 0000:04: bus scan returning with max=04
[    0.412067] pci 0000:00:1e.0: scanning [bus 05-05] behind bridge, pass 0
[    0.412086] pci_bus 0000:05: scanning bus
[    0.412103] pci 0000:05:00.0: [10ec:8169] type 0 class 0x000200
[    0.412112] pci 0000:05:00.0: calling quirk_mmio_always_on+0x0/0x17
[    0.412136] pci 0000:05:00.0: reg 10: [io  0xce00-0xceff]
[    0.412151] pci 0000:05:00.0: reg 14: [mem 0xfdcff000-0xfdcff0ff]
[    0.412201] pci 0000:05:00.0: reg 30: [mem 0x00000000-0x0000ffff pref]
[    0.412207] pci 0000:05:00.0: calling quirk_resource_alignment+0x0/0x166
[    0.412222] pci 0000:05:00.0: supports D1 D2
[    0.412224] pci 0000:05:00.0: PME# supported from D1 D2 D3hot D3cold
[    0.412229] pci 0000:05:00.0: PME# disabled
[    0.412253] pci 0000:05:07.0: [104c:8024] type 0 class 0x000c00
[    0.412261] pci 0000:05:07.0: calling quirk_mmio_always_on+0x0/0x17
[    0.412273] pci 0000:05:07.0: reg 10: [mem 0xfdcfe000-0xfdcfe7ff]
[    0.412283] pci 0000:05:07.0: reg 14: [mem 0xfdcf8000-0xfdcfbfff]
[    0.412328] pci 0000:05:07.0: calling quirk_resource_alignment+0x0/0x166
[    0.412343] pci 0000:05:07.0: supports D1 D2
[    0.412345] pci 0000:05:07.0: PME# supported from D0 D1 D2 D3hot
[    0.412350] pci 0000:05:07.0: PME# disabled
[    0.412384] pci_bus 0000:05: fixups for bus
[    0.412386] pci 0000:00:1e.0: PCI bridge to [bus 05-05] (subtractive decode)
[    0.412390] pci 0000:00:1e.0:   bridge window [io  0xc000-0xcfff]
[    0.412394] pci 0000:00:1e.0:   bridge window [mem 0xfdc00000-0xfdcfffff]
[    0.412399] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.412402] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.412405] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.412408] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.412410] pci 0000:00:1e.0:   bridge window [mem 0x000c0000-0x000dffff] (subtractive decode)
[    0.412413] pci 0000:00:1e.0:   bridge window [mem 0xdff00000-0xfebfffff] (subtractive decode)
[    0.412415] pci_bus 0000:05: bus scan returning with max=05
[    0.412419] pci 0000:00:01.0: scanning [bus 01-01] behind bridge, pass 1
[    0.412424] pci 0000:00:1c.0: scanning [bus 02-02] behind bridge, pass 1
[    0.412430] pci 0000:00:1c.3: scanning [bus 03-03] behind bridge, pass 1
[    0.412435] pci 0000:00:1c.4: scanning [bus 04-04] behind bridge, pass 1
[    0.412441] pci 0000:00:1e.0: scanning [bus 05-05] behind bridge, pass 1
[    0.412446] pci_bus 0000:00: bus scan returning with max=05
[    0.412449] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.412611] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
[    0.412659] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX3._PRT]
[    0.412713] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
[    0.412757] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
[    0.412911]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.424685] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
[    0.424685] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.424685] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
[    0.424685] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
[    0.424685] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
[    0.424685] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
[    0.424685] ACPI: PCI Interrupt Link [LNK0] (IRQs *3 4 5 6 7 9 10 11 12 14 15)
[    0.424685] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
[    0.424685] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.424685] vgaarb: loaded
[    0.428033] usbcore: registered new interface driver usbfs
[    0.428059] usbcore: registered new interface driver hub
[    0.428073] usbcore: registered new device driver usb
[    0.428073] PCI: Using ACPI for IRQ routing
[    0.428073] PCI: pci_cache_line_size set to 64 bytes
[    0.428073] pci 0000:00:1a.0: BAR 4: reserving [io  0xff00-0xff1f flags 0x40101] (d=0, p=0)
[    0.428073] pci 0000:00:1a.1: BAR 4: reserving [io  0xfe00-0xfe1f flags 0x40101] (d=0, p=0)
[    0.428073] pci 0000:00:1a.2: BAR 4: reserving [io  0xfd00-0xfd1f flags 0x40101] (d=0, p=0)
[    0.428073] pci 0000:00:1a.7: BAR 0: reserving [mem 0xfdfff000-0xfdfff3ff flags 0x40200] (d=0, p=0)
[    0.428073] pci 0000:00:1b.0: BAR 0: reserving [mem 0xfdff8000-0xfdffbfff flags 0x140204] (d=0, p=0)
[    0.428081] pci 0000:00:1d.0: BAR 4: reserving [io  0xfc00-0xfc1f flags 0x40101] (d=0, p=0)
[    0.428087] pci 0000:00:1d.1: BAR 4: reserving [io  0xfb00-0xfb1f flags 0x40101] (d=0, p=0)
[    0.428092] pci 0000:00:1d.2: BAR 4: reserving [io  0xfa00-0xfa1f flags 0x40101] (d=0, p=0)
[    0.428098] pci 0000:00:1d.7: BAR 0: reserving [mem 0xfdffe000-0xfdffe3ff flags 0x40200] (d=0, p=0)
[    0.428107] pci 0000:00:1f.2: BAR 0: reserving [io  0x01f0-0x01f7 flags 0x110] (d=0, p=0)
[    0.428111] pci 0000:00:1f.2: BAR 1: reserving [io  0x03f6 flags 0x110] (d=0, p=0)
[    0.428115] pci 0000:00:1f.2: BAR 2: reserving [io  0x0170-0x0177 flags 0x110] (d=0, p=0)
[    0.428119] pci 0000:00:1f.2: BAR 3: reserving [io  0x0376 flags 0x110] (d=0, p=0)
[    0.428122] pci 0000:00:1f.2: BAR 4: reserving [io  0xf900-0xf90f flags 0x40101] (d=0, p=0)
[    0.428126] pci 0000:00:1f.2: BAR 5: reserving [io  0xf800-0xf80f flags 0x40101] (d=0, p=0)
[    0.428131] pci 0000:00:1f.3: BAR 0: reserving [mem 0xfdffd000-0xfdffd0ff flags 0x140204] (d=0, p=0)
[    0.428135] pci 0000:00:1f.3: BAR 4: reserving [io  0x0500-0x051f flags 0x40101] (d=0, p=0)
[    0.428141] pci 0000:00:1f.5: BAR 0: reserving [io  0xf600-0xf607 flags 0x40101] (d=0, p=0)
[    0.428145] pci 0000:00:1f.5: BAR 1: reserving [io  0xf500-0xf503 flags 0x40101] (d=0, p=0)
[    0.428148] pci 0000:00:1f.5: BAR 2: reserving [io  0xf400-0xf407 flags 0x40101] (d=0, p=0)
[    0.428152] pci 0000:00:1f.5: BAR 3: reserving [io  0xf300-0xf303 flags 0x40101] (d=0, p=0)
[    0.428156] pci 0000:00:1f.5: BAR 4: reserving [io  0xf200-0xf20f flags 0x40101] (d=0, p=0)
[    0.428159] pci 0000:00:1f.5: BAR 5: reserving [io  0xf100-0xf10f flags 0x40101] (d=0, p=0)
[    0.428165] pci 0000:01:00.0: BAR 0: reserving [mem 0xfa000000-0xfaffffff flags 0x40200] (d=0, p=0)
[    0.428169] pci 0000:01:00.0: BAR 1: reserving [mem 0xe0000000-0xefffffff flags 0x14220c] (d=0, p=0)
[    0.428173] pci 0000:01:00.0: BAR 3: reserving [mem 0xf8000000-0xf9ffffff flags 0x140204] (d=0, p=0)
[    0.428177] pci 0000:01:00.0: BAR 5: reserving [io  0xbf00-0xbf7f flags 0x40101] (d=0, p=0)
[    0.428183] pci 0000:03:00.0: BAR 5: reserving [mem 0xfddfe000-0xfddfffff flags 0x40200] (d=0, p=0)
[    0.428192] pci 0000:04:00.0: BAR 0: reserving [io  0xde00-0xdeff flags 0x40101] (d=0, p=0)
[    0.428196] pci 0000:04:00.0: BAR 2: reserving [mem 0xfdeff000-0xfdefffff flags 0x14220c] (d=0, p=0)
[    0.428199] pci 0000:04:00.0: BAR 4: reserving [mem 0xfdee0000-0xfdeeffff flags 0x14220c] (d=0, p=0)
[    0.428205] pci 0000:05:00.0: BAR 0: reserving [io  0xce00-0xceff flags 0x40101] (d=0, p=0)
[    0.428209] pci 0000:05:00.0: BAR 1: reserving [mem 0xfdcff000-0xfdcff0ff flags 0x40200] (d=0, p=0)
[    0.428215] pci 0000:05:07.0: BAR 0: reserving [mem 0xfdcfe000-0xfdcfe7ff flags 0x40200] (d=0, p=0)
[    0.428219] pci 0000:05:07.0: BAR 1: reserving [mem 0xfdcf8000-0xfdcfbfff flags 0x40200] (d=0, p=0)
[    0.428260] pci 0000:03:00.1: BAR 0: reserving [io  0xef00-0xef07 flags 0x40101] (d=1, p=1)
[    0.428264] pci 0000:03:00.1: BAR 1: reserving [io  0xee00-0xee03 flags 0x40101] (d=1, p=1)
[    0.428268] pci 0000:03:00.1: BAR 2: reserving [io  0xed00-0xed07 flags 0x40101] (d=1, p=1)
[    0.428271] pci 0000:03:00.1: BAR 3: reserving [io  0xec00-0xec03 flags 0x40101] (d=1, p=1)
[    0.428275] pci 0000:03:00.1: BAR 4: reserving [io  0xeb00-0xeb0f flags 0x40101] (d=1, p=1)
[    0.428286] reserve RAM buffer: 000000000009f800 - 000000000009ffff 
[    0.428289] reserve RAM buffer: 00000000dfee0000 - 00000000dfffffff 
[    0.428308] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    0.428308] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.428308] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.448059] Switching to clocksource hpet
[    0.448075] Switched to NOHz mode on CPU #1
[    0.451925] Switched to NOHz mode on CPU #0
[    0.451982] Switched to NOHz mode on CPU #3
[    0.451995] Switched to NOHz mode on CPU #2
[    0.455757] pnp: PnP ACPI init
[    0.455779] ACPI: bus type pnp registered
[    0.455885] pnp 00:00: [bus 00-3f]
[    0.455888] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.455890] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.455893] pnp 00:00: [io  0x0d00-0xffff window]
[    0.455895] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.455897] pnp 00:00: [mem 0x000c0000-0x000dffff window]
[    0.455900] pnp 00:00: [mem 0xdff00000-0xfebfffff window]
[    0.456033] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.456136] pnp 00:01: [io  0x0010-0x001f]
[    0.456139] pnp 00:01: [io  0x0022-0x003f]
[    0.456141] pnp 00:01: [io  0x0044-0x005f]
[    0.456142] pnp 00:01: [io  0x0062-0x0063]
[    0.456144] pnp 00:01: [io  0x0065-0x006f]
[    0.456148] pnp 00:01: [io  0x0074-0x007f]
[    0.456150] pnp 00:01: [io  0x0091-0x0093]
[    0.456152] pnp 00:01: [io  0x00a2-0x00bf]
[    0.456154] pnp 00:01: [io  0x00e0-0x00ef]
[    0.456156] pnp 00:01: [io  0x04d0-0x04d1]
[    0.456158] pnp 00:01: [io  0x0290-0x029f]
[    0.456159] pnp 00:01: [io  0x0800-0x087f]
[    0.456161] pnp 00:01: [io  0x0290-0x0294]
[    0.456163] pnp 00:01: [io  0x0880-0x088f]
[    0.456305] system 00:01: [io  0x04d0-0x04d1] has been reserved
[    0.456308] system 00:01: [io  0x0290-0x029f] has been reserved
[    0.456311] system 00:01: [io  0x0800-0x087f] has been reserved
[    0.456313] system 00:01: [io  0x0290-0x0294] has been reserved
[    0.456316] system 00:01: [io  0x0880-0x088f] has been reserved
[    0.456320] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.456334] pnp 00:02: [dma 4]
[    0.456336] pnp 00:02: [io  0x0000-0x000f]
[    0.456338] pnp 00:02: [io  0x0080-0x0090]
[    0.456340] pnp 00:02: [io  0x0094-0x009f]
[    0.456342] pnp 00:02: [io  0x00c0-0x00df]
[    0.456426] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.456485] pnp 00:03: [irq 0 disabled]
[    0.456496] pnp 00:03: [irq 8]
[    0.456498] pnp 00:03: [mem 0xfed00000-0xfed003ff]
[    0.456582] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.456615] pnp 00:04: [io  0x0070-0x0073]
[    0.456699] pnp 00:04: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.456711] pnp 00:05: [io  0x0061]
[    0.456795] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.456807] pnp 00:06: [io  0x00f0-0x00ff]
[    0.456812] pnp 00:06: [irq 13]
[    0.456897] pnp 00:06: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.457026] pnp 00:07: [io  0x03f0-0x03f5]
[    0.457028] pnp 00:07: [io  0x03f7]
[    0.457033] pnp 00:07: [irq 6]
[    0.457035] pnp 00:07: [dma 2]
[    0.457132] pnp 00:07: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.457305] pnp 00:08: [io  0x03f8-0x03ff]
[    0.457312] pnp 00:08: [irq 4]
[    0.457422] pnp 00:08: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.457616] pnp 00:09: [io  0x0378-0x037f]
[    0.457622] pnp 00:09: [irq 7]
[    0.457727] pnp 00:09: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.457835] pnp 00:0a: [irq 12]
[    0.457921] pnp 00:0a: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.457949] pnp 00:0b: [io  0x0060]
[    0.457952] pnp 00:0b: [io  0x0064]
[    0.457956] pnp 00:0b: [irq 1]
[    0.458048] pnp 00:0b: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.458091] pnp 00:0c: [io  0x0400-0x04cf]
[    0.458094] pnp 00:0c: [io  0x04d2-0x04ff]
[    0.458210] system 00:0c: [io  0x0400-0x04cf] has been reserved
[    0.458213] system 00:0c: [io  0x04d2-0x04ff] has been reserved
[    0.458217] system 00:0c: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.458441] pnp 00:0d: [mem 0xf4000000-0xf7ffffff]
[    0.458569] system 00:0d: [mem 0xf4000000-0xf7ffffff] has been reserved
[    0.458573] system 00:0d: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.458754] pnp 00:0e: [mem 0x000ce000-0x000cffff]
[    0.458757] pnp 00:0e: [mem 0x000f0000-0x000f7fff]
[    0.458759] pnp 00:0e: [mem 0x000f8000-0x000fbfff]
[    0.458761] pnp 00:0e: [mem 0x000fc000-0x000fffff]
[    0.458763] pnp 00:0e: [mem 0xdfee0000-0xdfeeffff]
[    0.458767] pnp 00:0e: [mem 0x00000000-0x0009ffff]
[    0.458769] pnp 00:0e: [mem 0x00100000-0xdfedffff]
[    0.458771] pnp 00:0e: [mem 0xdfef0000-0xdfefffff]
[    0.458773] pnp 00:0e: [mem 0xfec00000-0xfec00fff]
[    0.458775] pnp 00:0e: [mem 0xfed10000-0xfed1dfff]
[    0.458777] pnp 00:0e: [mem 0xfed20000-0xfed8ffff]
[    0.458779] pnp 00:0e: [mem 0xfee00000-0xfee00fff]
[    0.458782] pnp 00:0e: [mem 0xffb00000-0xffb7ffff]
[    0.458784] pnp 00:0e: [mem 0xfff00000-0xffffffff]
[    0.458786] pnp 00:0e: [mem 0x000e0000-0x000effff]
[    0.458928] system 00:0e: [mem 0x000ce000-0x000cffff] has been reserved
[    0.458931] system 00:0e: [mem 0x000f0000-0x000f7fff] could not be reserved
[    0.458934] system 00:0e: [mem 0x000f8000-0x000fbfff] could not be reserved
[    0.458937] system 00:0e: [mem 0x000fc000-0x000fffff] could not be reserved
[    0.458940] system 00:0e: [mem 0xdfee0000-0xdfeeffff] could not be reserved
[    0.458943] system 00:0e: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.458946] system 00:0e: [mem 0x00100000-0xdfedffff] could not be reserved
[    0.458949] system 00:0e: [mem 0xdfef0000-0xdfefffff] has been reserved
[    0.458952] system 00:0e: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.458955] system 00:0e: [mem 0xfed10000-0xfed1dfff] has been reserved
[    0.458958] system 00:0e: [mem 0xfed20000-0xfed8ffff] has been reserved
[    0.458961] system 00:0e: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.458964] system 00:0e: [mem 0xffb00000-0xffb7ffff] has been reserved
[    0.458967] system 00:0e: [mem 0xfff00000-0xffffffff] has been reserved
[    0.458970] system 00:0e: [mem 0x000e0000-0x000effff] has been reserved
[    0.458974] system 00:0e: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.458996] pnp 00:0f: [mem 0xffb80000-0xffbfffff]
[    0.459096] pnp 00:0f: Plug and Play ACPI device, IDs INT0800 (active)
[    0.459102] pnp: PnP ACPI: found 16 devices
[    0.459104] ACPI: ACPI bus type pnp unregistered
[    0.469750] pci 0000:00:1e.0: BAR 15: assigned [mem 0xdff00000-0xdff0ffff pref]
[    0.469754] pci 0000:00:1c.0: BAR 13: assigned [io  0x1000-0x1fff]
[    0.469758] pci 0000:01:00.0: BAR 6: assigned [mem 0xfb000000-0xfb07ffff pref]
[    0.469761] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.469764] pci 0000:00:01.0:   bridge window [io  0xb000-0xbfff]
[    0.469768] pci 0000:00:01.0:   bridge window [mem 0xf8000000-0xfbffffff]
[    0.469771] pci 0000:00:01.0:   bridge window [mem 0xe0000000-0xefffffff 64bit pref]
[    0.469775] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.469778] pci 0000:00:1c.0:   bridge window [io  0x1000-0x1fff]
[    0.469783] pci 0000:00:1c.0:   bridge window [mem disabled]
[    0.469786] pci 0000:00:1c.0:   bridge window [mem pref disabled]
[    0.469792] pci 0000:00:1c.3: PCI bridge to [bus 03-03]
[    0.469795] pci 0000:00:1c.3:   bridge window [io  0xe000-0xefff]
[    0.469799] pci 0000:00:1c.3:   bridge window [mem 0xfdd00000-0xfddfffff]
[    0.469803] pci 0000:00:1c.3:   bridge window [mem pref disabled]
[    0.469810] pci 0000:04:00.0: BAR 6: assigned [mem 0xfde00000-0xfde0ffff pref]
[    0.469812] pci 0000:00:1c.4: PCI bridge to [bus 04-04]
[    0.469815] pci 0000:00:1c.4:   bridge window [io  0xd000-0xdfff]
[    0.469820] pci 0000:00:1c.4:   bridge window [mem 0xfdb00000-0xfdbfffff]
[    0.469824] pci 0000:00:1c.4:   bridge window [mem 0xfde00000-0xfdefffff 64bit pref]
[    0.469830] pci 0000:05:00.0: BAR 6: assigned [mem 0xdff00000-0xdff0ffff pref]
[    0.469833] pci 0000:00:1e.0: PCI bridge to [bus 05-05]
[    0.469836] pci 0000:00:1e.0:   bridge window [io  0xc000-0xcfff]
[    0.469840] pci 0000:00:1e.0:   bridge window [mem 0xfdc00000-0xfdcfffff]
[    0.469844] pci 0000:00:1e.0:   bridge window [mem 0xdff00000-0xdff0ffff pref]
[    0.469862] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.469866] pci 0000:00:01.0: setting latency timer to 64
[    0.469872] pci 0000:00:1c.0: enabling device (0000 -> 0001)
[    0.469876] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.469879] pci 0000:00:1c.0: enabling bus mastering
[    0.469882] pci 0000:00:1c.0: setting latency timer to 64
[    0.469895] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    0.469899] pci 0000:00:1c.3: setting latency timer to 64
[    0.469905] pci 0000:00:1c.4: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.469909] pci 0000:00:1c.4: setting latency timer to 64
[    0.469915] pci 0000:00:1e.0: setting latency timer to 64
[    0.469919] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.469921] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.469924] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.469926] pci_bus 0000:00: resource 7 [mem 0x000c0000-0x000dffff]
[    0.469928] pci_bus 0000:00: resource 8 [mem 0xdff00000-0xfebfffff]
[    0.469931] pci_bus 0000:01: resource 0 [io  0xb000-0xbfff]
[    0.469933] pci_bus 0000:01: resource 1 [mem 0xf8000000-0xfbffffff]
[    0.469935] pci_bus 0000:01: resource 2 [mem 0xe0000000-0xefffffff 64bit pref]
[    0.469938] pci_bus 0000:02: resource 0 [io  0x1000-0x1fff]
[    0.469940] pci_bus 0000:03: resource 0 [io  0xe000-0xefff]
[    0.469942] pci_bus 0000:03: resource 1 [mem 0xfdd00000-0xfddfffff]
[    0.469945] pci_bus 0000:04: resource 0 [io  0xd000-0xdfff]
[    0.469947] pci_bus 0000:04: resource 1 [mem 0xfdb00000-0xfdbfffff]
[    0.469950] pci_bus 0000:04: resource 2 [mem 0xfde00000-0xfdefffff 64bit pref]
[    0.469952] pci_bus 0000:05: resource 0 [io  0xc000-0xcfff]
[    0.469954] pci_bus 0000:05: resource 1 [mem 0xfdc00000-0xfdcfffff]
[    0.469957] pci_bus 0000:05: resource 2 [mem 0xdff00000-0xdff0ffff pref]
[    0.469959] pci_bus 0000:05: resource 4 [io  0x0000-0x0cf7]
[    0.469961] pci_bus 0000:05: resource 5 [io  0x0d00-0xffff]
[    0.469963] pci_bus 0000:05: resource 6 [mem 0x000a0000-0x000bffff]
[    0.469965] pci_bus 0000:05: resource 7 [mem 0x000c0000-0x000dffff]
[    0.469968] pci_bus 0000:05: resource 8 [mem 0xdff00000-0xfebfffff]
[    0.470097] NET: Registered protocol family 2
[    0.470283] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.471451] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.474238] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.474574] TCP: Hash tables configured (established 524288 bind 65536)
[    0.474577] TCP reno registered
[    0.474587] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.474620] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.474829] NET: Registered protocol family 1
[    0.474846] pci 0000:00:00.0: calling quirk_e100_interrupt+0x0/0x144
[    0.474851] pci 0000:00:00.0: calling quirk_cardbus_legacy+0x0/0x22
[    0.474854] pci 0000:00:00.0: calling quirk_usb_early_handoff+0x0/0x4e9
[    0.474858] pci 0000:00:00.0: calling pci_fixup_video+0x0/0xad
[    0.474863] pci 0000:00:01.0: calling quirk_e100_interrupt+0x0/0x144
[    0.474866] pci 0000:00:01.0: calling quirk_cardbus_legacy+0x0/0x22
[    0.474869] pci 0000:00:01.0: calling quirk_usb_early_handoff+0x0/0x4e9
[    0.474872] pci 0000:00:01.0: calling pci_fixup_video+0x0/0xad
[    0.474876] pci 0000:00:1a.0: calling quirk_e100_interrupt+0x0/0x144
[    0.474879] pci 0000:00:1a.0: calling quirk_cardbus_legacy+0x0/0x22
[    0.474882] pci 0000:00:1a.0: calling quirk_usb_early_handoff+0x0/0x4e9
[    0.474887] pci 0000:00:1a.0: uhci_check_and_reset_hc: legsup = 0x0f10
[    0.474889] pci 0000:00:1a.0: Performing full reset
[    0.474900] pci 0000:00:1a.0: calling pci_fixup_video+0x0/0xad
[    0.474905] pci 0000:00:1a.1: calling quirk_e100_interrupt+0x0/0x144
[    0.474908] pci 0000:00:1a.1: calling quirk_cardbus_legacy+0x0/0x22
[    0.474911] pci 0000:00:1a.1: calling quirk_usb_early_handoff+0x0/0x4e9
[    0.474915] pci 0000:00:1a.1: uhci_check_and_reset_hc: legsup = 0x0010
[    0.474917] pci 0000:00:1a.1: Performing full reset
[    0.474929] pci 0000:00:1a.1: calling pci_fixup_video+0x0/0xad
[    0.474934] pci 0000:00:1a.2: calling quirk_e100_interrupt+0x0/0x144
[    0.474937] pci 0000:00:1a.2: calling quirk_cardbus_legacy+0x0/0x22
[    0.474939] pci 0000:00:1a.2: calling quirk_usb_early_handoff+0x0/0x4e9
[    0.474944] pci 0000:00:1a.2: uhci_check_and_reset_hc: legsup = 0x0010
[    0.474945] pci 0000:00:1a.2: Performing full reset
[    0.474957] pci 0000:00:1a.2: calling pci_fixup_video+0x0/0xad
[    0.474962] pci 0000:00:1a.7: calling quirk_e100_interrupt+0x0/0x144
[    0.474965] pci 0000:00:1a.7: calling quirk_cardbus_legacy+0x0/0x22
[    0.474968] pci 0000:00:1a.7: calling quirk_usb_early_handoff+0x0/0x4e9
[    0.474988] pci 0000:00:1a.7: EHCI: BIOS handoff
[    0.488022] pci 0000:00:1a.7: calling pci_fixup_video+0x0/0xad
[    0.488029] pci 0000:00:1b.0: calling quirk_e100_interrupt+0x0/0x144
[    0.488032] pci 0000:00:1b.0: calling quirk_cardbus_legacy+0x0/0x22
[    0.488036] pci 0000:00:1b.0: calling quirk_usb_early_handoff+0x0/0x4e9
[    0.488039] pci 0000:00:1b.0: calling pci_fixup_video+0x0/0xad
[    0.488044] pci 0000:00:1c.0: calling quirk_e100_interrupt+0x0/0x144
[    0.488047] pci 0000:00:1c.0: calling quirk_cardbus_legacy+0x0/0x22
[    0.488051] pci 0000:00:1c.0: calling quirk_usb_early_handoff+0x0/0x4e9
[    0.488054] pci 0000:00:1c.0: calling pci_fixup_video+0x0/0xad
[    0.488059] pci 0000:00:1c.3: calling quirk_e100_interrupt+0x0/0x144
[    0.488063] pci 0000:00:1c.3: calling quirk_cardbus_legacy+0x0/0x22
[    0.488066] pci 0000:00:1c.3: calling quirk_usb_early_handoff+0x0/0x4e9
[    0.488069] pci 0000:00:1c.3: calling pci_fixup_video+0x0/0xad
[    0.488074] pci 0000:00:1c.4: calling quirk_e100_interrupt+0x0/0x144
[    0.488078] pci 0000:00:1c.4: calling quirk_cardbus_legacy+0x0/0x22
[    0.488081] pci 0000:00:1c.4: calling quirk_usb_early_handoff+0x0/0x4e9
[    0.488084] pci 0000:00:1c.4: calling pci_fixup_video+0x0/0xad
[    0.488089] pci 0000:00:1d.0: calling quirk_e100_interrupt+0x0/0x144
[    0.488093] pci 0000:00:1d.0: calling quirk_cardbus_legacy+0x0/0x22
[    0.488096] pci 0000:00:1d.0: calling quirk_usb_early_handoff+0x0/0x4e9
[    0.488111] pci 0000:00:1d.0: uhci_check_and_reset_hc: legsup = 0x0f30
[    0.488113] pci 0000:00:1d.0: Performing full reset
[    0.488130] pci 0000:00:1d.0: calling pci_fixup_video+0x0/0xad
[    0.488135] pci 0000:00:1d.1: calling quirk_e100_interrupt+0x0/0x144
[    0.488138] pci 0000:00:1d.1: calling quirk_cardbus_legacy+0x0/0x22
[    0.488140] pci 0000:00:1d.1: calling quirk_usb_early_handoff+0x0/0x4e9
[    0.488145] pci 0000:00:1d.1: uhci_check_and_reset_hc: legsup = 0x0010
[    0.488146] pci 0000:00:1d.1: Performing full reset
[    0.488158] pci 0000:00:1d.1: calling pci_fixup_video+0x0/0xad
[    0.488163] pci 0000:00:1d.2: calling quirk_e100_interrupt+0x0/0x144
[    0.488166] pci 0000:00:1d.2: calling quirk_cardbus_legacy+0x0/0x22
[    0.488169] pci 0000:00:1d.2: calling quirk_usb_early_handoff+0x0/0x4e9
[    0.488173] pci 0000:00:1d.2: uhci_check_and_reset_hc: legsup = 0x0010
[    0.488175] pci 0000:00:1d.2: Performing full reset
[    0.488186] pci 0000:00:1d.2: calling pci_fixup_video+0x0/0xad
[    0.488191] pci 0000:00:1d.7: calling quirk_e100_interrupt+0x0/0x144
[    0.488194] pci 0000:00:1d.7: calling quirk_cardbus_legacy+0x0/0x22
[    0.488197] pci 0000:00:1d.7: calling quirk_usb_early_handoff+0x0/0x4e9
[    0.488223] pci 0000:00:1d.7: EHCI: BIOS handoff
[    0.504017] pci 0000:00:1d.7: calling pci_fixup_video+0x0/0xad
[    0.504023] pci 0000:00:1e.0: calling quirk_e100_interrupt+0x0/0x144
[    0.504026] pci 0000:00:1e.0: calling quirk_cardbus_legacy+0x0/0x22
[    0.504030] pci 0000:00:1e.0: calling quirk_usb_early_handoff+0x0/0x4e9
[    0.504033] pci 0000:00:1e.0: calling pci_fixup_video+0x0/0xad
[    0.504038] pci 0000:00:1f.0: calling quirk_e100_interrupt+0x0/0x144
[    0.504042] pci 0000:00:1f.0: calling quirk_cardbus_legacy+0x0/0x22
[    0.504045] pci 0000:00:1f.0: calling quirk_usb_early_handoff+0x0/0x4e9
[    0.504048] pci 0000:00:1f.0: calling pci_fixup_video+0x0/0xad
[    0.504054] pci 0000:00:1f.2: calling quirk_e100_interrupt+0x0/0x144
[    0.504057] pci 0000:00:1f.2: calling quirk_cardbus_legacy+0x0/0x22
[    0.504061] pci 0000:00:1f.2: calling quirk_usb_early_handoff+0x0/0x4e9
[    0.504064] pci 0000:00:1f.2: calling pci_fixup_video+0x0/0xad
[    0.504069] pci 0000:00:1f.3: calling quirk_e100_interrupt+0x0/0x144
[    0.504072] pci 0000:00:1f.3: calling quirk_cardbus_legacy+0x0/0x22
[    0.504076] pci 0000:00:1f.3: calling quirk_usb_early_handoff+0x0/0x4e9
[    0.504079] pci 0000:00:1f.3: calling pci_fixup_video+0x0/0xad
[    0.504084] pci 0000:00:1f.5: calling quirk_e100_interrupt+0x0/0x144
[    0.504088] pci 0000:00:1f.5: calling quirk_cardbus_legacy+0x0/0x22
[    0.504091] pci 0000:00:1f.5: calling quirk_usb_early_handoff+0x0/0x4e9
[    0.504094] pci 0000:00:1f.5: calling pci_fixup_video+0x0/0xad
[    0.504104] pci 0000:01:00.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0xd
[    0.504125] pci 0000:01:00.0: calling quirk_cardbus_legacy+0x0/0x22
[    0.504127] pci 0000:01:00.0: calling quirk_usb_early_handoff+0x0/0x4e9
[    0.504130] pci 0000:01:00.0: calling pci_fixup_video+0x0/0xad
[    0.504133] pci 0000:01:00.0: Boot video device
[    0.504138] pci 0000:03:00.0: calling quirk_cardbus_legacy+0x0/0x22
[    0.504141] pci 0000:03:00.0: calling quirk_usb_early_handoff+0x0/0x4e9
[    0.504144] pci 0000:03:00.0: calling pci_fixup_video+0x0/0xad
[    0.504149] pci 0000:03:00.1: calling quirk_cardbus_legacy+0x0/0x22
[    0.504152] pci 0000:03:00.1: calling quirk_usb_early_handoff+0x0/0x4e9
[    0.504155] pci 0000:03:00.1: calling pci_fixup_video+0x0/0xad
[    0.504160] pci 0000:04:00.0: calling quirk_cardbus_legacy+0x0/0x22
[    0.504163] pci 0000:04:00.0: calling quirk_usb_early_handoff+0x0/0x4e9
[    0.504166] pci 0000:04:00.0: calling pci_fixup_video+0x0/0xad
[    0.504171] pci 0000:05:00.0: calling quirk_cardbus_legacy+0x0/0x22
[    0.504174] pci 0000:05:00.0: calling quirk_usb_early_handoff+0x0/0x4e9
[    0.504176] pci 0000:05:00.0: calling pci_fixup_video+0x0/0xad
[    0.504182] pci 0000:05:07.0: calling quirk_cardbus_legacy+0x0/0x22
[    0.504184] pci 0000:05:07.0: calling quirk_usb_early_handoff+0x0/0x4e9
[    0.504187] pci 0000:05:07.0: calling pci_fixup_video+0x0/0xad
[    0.504191] PCI: CLS 4 bytes, default 64
[    0.504248] Trying to unpack rootfs image as initramfs...
[    0.746378] Freeing initrd memory: 10888k freed
[    0.757653] DMA-API: preallocated 32768 debug entries
[    0.757655] DMA-API: debugging enabled by kernel config
[    0.757659] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.757663] Placing 64MB software IO TLB between ffff8800dbeda000 - ffff8800dfeda000
[    0.757665] software IO TLB at phys 0xdbeda000 - 0xdfeda000
[    0.760157] audit: initializing netlink socket (disabled)
[    0.760177] type=2000 audit(1300544502.756:1): initialized
[    0.760907] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.761317] VFS: Disk quotas dquot_6.5.2
[    0.761369] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.761461] msgmni has been set to 7925
[    0.761972] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.761976] io scheduler noop registered
[    0.761978] io scheduler deadline registered
[    0.762017] io scheduler cfq registered (default)
[    0.762328] pcieport 0000:00:01.0: setting latency timer to 64
[    0.762357] pcieport 0000:00:01.0: irq 40 for MSI/MSI-X
[    0.762458] pcieport 0000:00:1c.0: setting latency timer to 64
[    0.762491] pcieport 0000:00:1c.0: irq 41 for MSI/MSI-X
[    0.762600] pcieport 0000:00:1c.3: setting latency timer to 64
[    0.762634] pcieport 0000:00:1c.3: irq 42 for MSI/MSI-X
[    0.762747] pcieport 0000:00:1c.4: setting latency timer to 64
[    0.762781] pcieport 0000:00:1c.4: irq 43 for MSI/MSI-X
[    0.763784] efifb: probing for efifb
[    0.764211] efifb: framebuffer at 0xf9000000, mapped to 0xffffc90005100000, using 3072k, total 3072k
[    0.764214] efifb: mode is 1024x768x32, linelength=4096, pages=1
[    0.764215] efifb: scrolling: redraw
[    0.764218] efifb: Truecolor: size=8:8:8:8, shift=24:16:8:0
[    0.785953] Console: switching to colour frame buffer device 128x48
[    0.805934] fb0: EFI VGA frame buffer device
[    0.805937] intel_idle: MWAIT substates: 0x20
[    0.805939] intel_idle: does not run on family 6 model 23
[    0.806065] ERST: Table is not found!
[    0.851838] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.872245] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.148663] 00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.212620] Linux agpgart interface v0.103
[    1.215740] brd: module loaded
[    1.216105] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    1.216539] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.216595] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.216941] mousedev: PS/2 mouse device common for all mice
[    1.217042] rtc_cmos 00:04: RTC can wake from S4
[    1.234945] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    1.248072] rtc (null): alarm rollover: day
[    1.248184] rtc_cmos: dev (254:0)
[    1.248197] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
[    1.248221] rtc0: alarms up to one month, 242 bytes nvram, hpet irqs
[    1.248286] cpuidle: using governor ladder
[    1.248292] cpuidle: using governor menu
[    1.248588] TCP cubic registered
[    1.248591] NET: Registered protocol family 17
[    1.248596] Registering the dns_resolver key type
[    1.248900] registered taskstats version 1
[    1.248903] IMA: No TPM chip found, activating TPM-bypass!
[    1.249335] rtc_cmos 00:04: setting system clock to 2011-03-19 14:21:44 UTC (1300544504)
[    1.250844] Freeing unused kernel memory: 584k freed
[    1.250963] Write protecting the kernel read-only data: 6144k
[    1.254508] Freeing unused kernel memory: 856k freed
[    1.255856] Freeing unused kernel memory: 284k freed
[    1.273175] udev[1059]: starting version 164
[    1.355581] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.355586] ehci_hcd: block sizes: qh 104 qtd 96 itd 192 sitd 96
[    1.355640] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    1.355674] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    1.355678] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    1.355697] drivers/usb/core/inode.c: creating file 'devices'
[    1.355702] drivers/usb/core/inode.c: creating file '001'
[    1.355823] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    1.364812] Floppy drive(s): fd0 is 1.44M
[    1.365744] Uniform Multi-Platform E-IDE driver
[    1.380162] ehci_hcd 0000:00:1a.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[    1.380167] ehci_hcd 0000:00:1a.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr hw prefetch
[    1.380222] ehci_hcd 0000:00:1a.7: reset command 0080012 (park)=0 ithresh=8 Periodic period=1024 Reset HALT
[    1.383832] FDC 0 is a post-1991 82077
[    1.384121] ehci_hcd 0000:00:1a.7: Enabling legacy PCI PM
[    1.384143] ehci_hcd 0000:00:1a.7: cache line size of 4 is not supported
[    1.384145] ehci_hcd 0000:00:1a.7: supports USB remote wakeup
[    1.384168] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xfdfff000
[    1.384173] ehci_hcd 0000:00:1a.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    1.386524] uhci_hcd: USB Universal Host Controller Interface driver
[    1.388058] ehci_hcd 0000:00:1a.7: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
[    1.393634] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    1.393658] r8169 0000:04:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.393665] r8169 0000:04:00.0: enabling Mem-Wr-Inval
[    1.393709] r8169 0000:04:00.0: setting latency timer to 64
[    1.393769] r8169 0000:04:00.0: irq 44 for MSI/MSI-X
[    1.394034] r8169 0000:04:00.0: eth0: RTL8168c/8111c at 0xffffc900050fa000, 00:1f:d0:9a:d6:63, XID 1c4000c0 IRQ 44
[    1.397322] jmicron 0000:03:00.1: IDE controller (0x197b:0x2363 rev 0x02)
[    1.397337] JMicron IDE 0000:03:00.1: enabling device (0000 -> 0001)
[    1.397345] JMicron IDE 0000:03:00.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    1.397369] jmicron 0000:03:00.1: 100% native mode on irq 16
[    1.397378] JMicron IDE 0000:03:00.1: enabling bus mastering
[    1.397387] JMicron IDE 0000:03:00.1: setting latency timer to 64
[    1.397392]     ide0: BM-DMA at 0xeb00-0xeb07
[    1.397416]     ide1: BM-DMA at 0xeb08-0xeb0f
[    1.397435] Probing IDE interface ide0...
[    1.400105] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    1.400145] usb usb1: default language 0x0409
[    1.400156] usb usb1: udev 1, busnum 1, minor = 0
[    1.400161] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    1.400167] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.400175] usb usb1: Product: EHCI Host Controller
[    1.400181] usb usb1: Manufacturer: Linux 2.6.38-git8 ehci_hcd
[    1.400187] usb usb1: SerialNumber: 0000:00:1a.7
[    1.400328] usb usb1: usb_probe_device
[    1.400335] usb usb1: configuration #1 chosen from 1 choice
[    1.400347] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    1.400374] hub 1-0:1.0: usb_probe_interface
[    1.400380] hub 1-0:1.0: usb_probe_interface - got id
[    1.400386] hub 1-0:1.0: USB hub found
[    1.400395] hub 1-0:1.0: 6 ports detected
[    1.400401] hub 1-0:1.0: standalone hub
[    1.400406] hub 1-0:1.0: no power switching (usb 1.0)
[    1.400412] hub 1-0:1.0: individual port over-current protection
[    1.400417] hub 1-0:1.0: power on to power good time: 20ms
[    1.400422] hub 1-0:1.0: local power source is good
[    1.400428] hub 1-0:1.0: trying to enable port power on non-switchable hub
[    1.400496] drivers/usb/core/inode.c: creating file '001'
[    1.400573] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    1.400608] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    1.400616] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    1.400626] drivers/usb/core/inode.c: creating file '002'
[    1.400695] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    1.410325] SCSI subsystem initialized
[    1.416191] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    1.416220] r8169 0000:05:00.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    1.416225] r8169 0000:05:00.0: enabling Mem-Wr-Inval
[    1.416258] r8169 0000:05:00.0: (unregistered net_device): no PCI Express capability
[    1.416537] r8169 0000:05:00.0: eth1: RTL8169sb/8110sb at 0xffffc90000656000, 00:1f:1f:07:b0:bf, XID 10000000 IRQ 20
[    1.416552] ehci_hcd 0000:00:1d.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[    1.416557] ehci_hcd 0000:00:1d.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr hw prefetch
[    1.416609] ehci_hcd 0000:00:1d.7: reset command 0080012 (park)=0 ithresh=8 Periodic period=1024 Reset HALT
[    1.420496] ehci_hcd 0000:00:1d.7: Enabling legacy PCI PM
[    1.420508] ehci_hcd 0000:00:1d.7: cache line size of 4 is not supported
[    1.420511] ehci_hcd 0000:00:1d.7: supports USB remote wakeup
[    1.420529] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfdffe000
[    1.420534] ehci_hcd 0000:00:1d.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    1.424403] ehci_hcd 0000:00:1d.7: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
[    1.428671] libata version 3.00 loaded.
[    1.436025] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    1.436066] usb usb2: default language 0x0409
[    1.436075] usb usb2: udev 1, busnum 2, minor = 128
[    1.436078] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    1.436081] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.436086] usb usb2: Product: EHCI Host Controller
[    1.436088] usb usb2: Manufacturer: Linux 2.6.38-git8 ehci_hcd
[    1.436093] usb usb2: SerialNumber: 0000:00:1d.7
[    1.436252] usb usb2: usb_probe_device
[    1.436256] usb usb2: configuration #1 chosen from 1 choice
[    1.436264] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[    1.436286] hub 2-0:1.0: usb_probe_interface
[    1.436289] hub 2-0:1.0: usb_probe_interface - got id
[    1.436291] hub 2-0:1.0: USB hub found
[    1.436296] hub 2-0:1.0: 6 ports detected
[    1.436298] hub 2-0:1.0: standalone hub
[    1.436300] hub 2-0:1.0: no power switching (usb 1.0)
[    1.436302] hub 2-0:1.0: individual port over-current protection
[    1.436304] hub 2-0:1.0: power on to power good time: 20ms
[    1.436309] hub 2-0:1.0: local power source is good
[    1.436311] hub 2-0:1.0: trying to enable port power on non-switchable hub
[    1.436369] drivers/usb/core/inode.c: creating file '001'
[    1.436478] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.436492] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    1.436498] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    1.436510] drivers/usb/core/inode.c: creating file '003'
[    1.436647] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    1.452049] uhci_hcd 0000:00:1a.0: detected 2 ports
[    1.452056] uhci_hcd 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x0000
[    1.452058] uhci_hcd 0000:00:1a.0: Performing full reset
[    1.452091] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000ff00
[    1.452171] usb usb3: default language 0x0409
[    1.452178] usb usb3: udev 1, busnum 3, minor = 256
[    1.452181] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    1.452183] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.452185] usb usb3: Product: UHCI Host Controller
[    1.452187] usb usb3: Manufacturer: Linux 2.6.38-git8 uhci_hcd
[    1.452189] usb usb3: SerialNumber: 0000:00:1a.0
[    1.452320] usb usb3: usb_probe_device
[    1.452323] usb usb3: configuration #1 chosen from 1 choice
[    1.452331] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[    1.452357] hub 3-0:1.0: usb_probe_interface
[    1.452359] hub 3-0:1.0: usb_probe_interface - got id
[    1.452362] hub 3-0:1.0: USB hub found
[    1.452366] hub 3-0:1.0: 2 ports detected
[    1.452368] hub 3-0:1.0: standalone hub
[    1.452370] hub 3-0:1.0: no power switching (usb 1.0)
[    1.452372] hub 3-0:1.0: individual port over-current protection
[    1.452374] hub 3-0:1.0: power on to power good time: 2ms
[    1.452379] hub 3-0:1.0: local power source is good
[    1.452381] hub 3-0:1.0: trying to enable port power on non-switchable hub
[    1.452423] drivers/usb/core/inode.c: creating file '001'
[    1.452457] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.0
[    1.452501] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    1.452508] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    1.452512] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    1.452517] drivers/usb/core/inode.c: creating file '004'
[    1.452572] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    1.468021] uhci_hcd 0000:00:1a.1: detected 2 ports
[    1.468026] uhci_hcd 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x0000
[    1.468028] uhci_hcd 0000:00:1a.1: Performing full reset
[    1.468055] uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000fe00
[    1.468130] usb usb4: default language 0x0409
[    1.468137] usb usb4: udev 1, busnum 4, minor = 384
[    1.468139] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    1.468141] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.468143] usb usb4: Product: UHCI Host Controller
[    1.468145] usb usb4: Manufacturer: Linux 2.6.38-git8 uhci_hcd
[    1.468147] usb usb4: SerialNumber: 0000:00:1a.1
[    1.468227] usb usb4: usb_probe_device
[    1.468229] usb usb4: configuration #1 chosen from 1 choice
[    1.468236] usb usb4: adding 4-0:1.0 (config #1, interface 0)
[    1.468260] hub 4-0:1.0: usb_probe_interface
[    1.468262] hub 4-0:1.0: usb_probe_interface - got id
[    1.468265] hub 4-0:1.0: USB hub found
[    1.468269] hub 4-0:1.0: 2 ports detected
[    1.468271] hub 4-0:1.0: standalone hub
[    1.468273] hub 4-0:1.0: no power switching (usb 1.0)
[    1.468275] hub 4-0:1.0: individual port over-current protection
[    1.468277] hub 4-0:1.0: power on to power good time: 2ms
[    1.468281] hub 4-0:1.0: local power source is good
[    1.468283] hub 4-0:1.0: trying to enable port power on non-switchable hub
[    1.468325] drivers/usb/core/inode.c: creating file '001'
[    1.468354] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.1
[    1.468380] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    1.468386] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    1.468389] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    1.468396] drivers/usb/core/inode.c: creating file '005'
[    1.468444] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
[    1.480022] uhci_hcd 0000:00:1a.2: detected 2 ports
[    1.480027] uhci_hcd 0000:00:1a.2: uhci_check_and_reset_hc: cmd = 0x0000
[    1.480029] uhci_hcd 0000:00:1a.2: Performing full reset
[    1.480047] uhci_hcd 0000:00:1a.2: irq 18, io base 0x0000fd00
[    1.480121] usb usb5: default language 0x0409
[    1.480128] usb usb5: udev 1, busnum 5, minor = 512
[    1.480130] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    1.480133] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.480135] usb usb5: Product: UHCI Host Controller
[    1.480137] usb usb5: Manufacturer: Linux 2.6.38-git8 uhci_hcd
[    1.480139] usb usb5: SerialNumber: 0000:00:1a.2
[    1.480213] usb usb5: usb_probe_device
[    1.480216] usb usb5: configuration #1 chosen from 1 choice
[    1.480222] usb usb5: adding 5-0:1.0 (config #1, interface 0)
[    1.480245] hub 5-0:1.0: usb_probe_interface
[    1.480247] hub 5-0:1.0: usb_probe_interface - got id
[    1.480249] hub 5-0:1.0: USB hub found
[    1.480255] hub 5-0:1.0: 2 ports detected
[    1.480257] hub 5-0:1.0: standalone hub
[    1.480259] hub 5-0:1.0: no power switching (usb 1.0)
[    1.480260] hub 5-0:1.0: individual port over-current protection
[    1.480263] hub 5-0:1.0: power on to power good time: 2ms
[    1.480267] hub 5-0:1.0: local power source is good
[    1.480269] hub 5-0:1.0: trying to enable port power on non-switchable hub
[    1.480309] drivers/usb/core/inode.c: creating file '001'
[    1.480336] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.2
[    1.480362] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    1.480367] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    1.480370] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    1.480375] drivers/usb/core/inode.c: creating file '006'
[    1.480429] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
[    1.500045] hub 1-0:1.0: state 7 ports 6 chg 0000 evt 0000
[    1.508023] uhci_hcd 0000:00:1d.0: detected 2 ports
[    1.508029] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
[    1.508031] uhci_hcd 0000:00:1d.0: Performing full reset
[    1.508051] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000fc00
[    1.508127] usb usb6: default language 0x0409
[    1.508134] usb usb6: udev 1, busnum 6, minor = 640
[    1.508136] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    1.508139] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.508141] usb usb6: Product: UHCI Host Controller
[    1.508143] usb usb6: Manufacturer: Linux 2.6.38-git8 uhci_hcd
[    1.508145] usb usb6: SerialNumber: 0000:00:1d.0
[    1.508243] usb usb6: usb_probe_device
[    1.508245] usb usb6: configuration #1 chosen from 1 choice
[    1.508252] usb usb6: adding 6-0:1.0 (config #1, interface 0)
[    1.508275] hub 6-0:1.0: usb_probe_interface
[    1.508277] hub 6-0:1.0: usb_probe_interface - got id
[    1.508280] hub 6-0:1.0: USB hub found
[    1.508284] hub 6-0:1.0: 2 ports detected
[    1.508286] hub 6-0:1.0: standalone hub
[    1.508288] hub 6-0:1.0: no power switching (usb 1.0)
[    1.508290] hub 6-0:1.0: individual port over-current protection
[    1.508292] hub 6-0:1.0: power on to power good time: 2ms
[    1.508296] hub 6-0:1.0: local power source is good
[    1.508299] hub 6-0:1.0: trying to enable port power on non-switchable hub
[    1.508340] drivers/usb/core/inode.c: creating file '001'
[    1.508376] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.0
[    1.508399] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    1.508405] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    1.508408] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    1.508413] drivers/usb/core/inode.c: creating file '007'
[    1.508460] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
[    1.528022] uhci_hcd 0000:00:1d.1: detected 2 ports
[    1.528027] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
[    1.528029] uhci_hcd 0000:00:1d.1: Performing full reset
[    1.528059] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000fb00
[    1.528130] usb usb7: default language 0x0409
[    1.528137] usb usb7: udev 1, busnum 7, minor = 768
[    1.528139] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    1.528142] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.528144] usb usb7: Product: UHCI Host Controller
[    1.528146] usb usb7: Manufacturer: Linux 2.6.38-git8 uhci_hcd
[    1.528148] usb usb7: SerialNumber: 0000:00:1d.1
[    1.528229] usb usb7: usb_probe_device
[    1.528232] usb usb7: configuration #1 chosen from 1 choice
[    1.528239] usb usb7: adding 7-0:1.0 (config #1, interface 0)
[    1.528263] hub 7-0:1.0: usb_probe_interface
[    1.528265] hub 7-0:1.0: usb_probe_interface - got id
[    1.528267] hub 7-0:1.0: USB hub found
[    1.528272] hub 7-0:1.0: 2 ports detected
[    1.528274] hub 7-0:1.0: standalone hub
[    1.528275] hub 7-0:1.0: no power switching (usb 1.0)
[    1.528277] hub 7-0:1.0: individual port over-current protection
[    1.528280] hub 7-0:1.0: power on to power good time: 2ms
[    1.528284] hub 7-0:1.0: local power source is good
[    1.528286] hub 7-0:1.0: trying to enable port power on non-switchable hub
[    1.528324] drivers/usb/core/inode.c: creating file '001'
[    1.528359] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.1
[    1.528379] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    1.528384] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    1.528387] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    1.528392] drivers/usb/core/inode.c: creating file '008'
[    1.528439] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
[    1.536039] hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0000
[    1.552032] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    1.560018] uhci_hcd 0000:00:1d.2: detected 2 ports
[    1.560023] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
[    1.560025] uhci_hcd 0000:00:1d.2: Performing full reset
[    1.560044] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000fa00
[    1.560118] usb usb8: default language 0x0409
[    1.560125] usb usb8: udev 1, busnum 8, minor = 896
[    1.560127] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
[    1.560130] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.560132] usb usb8: Product: UHCI Host Controller
[    1.560134] usb usb8: Manufacturer: Linux 2.6.38-git8 uhci_hcd
[    1.560136] usb usb8: SerialNumber: 0000:00:1d.2
[    1.560216] usb usb8: usb_probe_device
[    1.560219] usb usb8: configuration #1 chosen from 1 choice
[    1.560226] usb usb8: adding 8-0:1.0 (config #1, interface 0)
[    1.560249] hub 8-0:1.0: usb_probe_interface
[    1.560251] hub 8-0:1.0: usb_probe_interface - got id
[    1.560253] hub 8-0:1.0: USB hub found
[    1.560258] hub 8-0:1.0: 2 ports detected
[    1.560260] hub 8-0:1.0: standalone hub
[    1.560261] hub 8-0:1.0: no power switching (usb 1.0)
[    1.560263] hub 8-0:1.0: individual port over-current protection
[    1.560266] hub 8-0:1.0: power on to power good time: 2ms
[    1.560270] hub 8-0:1.0: local power source is good
[    1.560272] hub 8-0:1.0: trying to enable port power on non-switchable hub
[    1.560313] drivers/usb/core/inode.c: creating file '001'
[    1.560347] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.2
[    1.568042] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    1.580039] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    1.608043] hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    1.628055] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    1.660063] hub 8-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    1.756020] Refined TSC clocksource calibration: 2333.067 MHz.
[    1.756025] Switching to clocksource tsc
[    1.964009] ------------[ cut here ]------------
[    1.964018] WARNING: at kernel/irq/manage.c:412 __enable_irq+0x59/0x88()
[    1.964020] Hardware name: EP45-UD3
[    1.964022] Unbalanced enable for IRQ 16
[    1.964024] Modules linked in: ahci(+) libahci libata scsi_mod jmicron(+) r8169 uhci_hcd ide_pci_generic(+) floppy ide_core mii ehci_hcd
[    1.964040] Pid: 1131, comm: modprobe Not tainted 2.6.38-git8 #1
[    1.964042] Call Trace:
[    1.964050]  [<ffffffff8103f368>] warn_slowpath_common+0x80/0x98
[    1.964054]  [<ffffffff8103f414>] warn_slowpath_fmt+0x41/0x43
[    1.964059]  [<ffffffff8108cfd7>] __enable_irq+0x59/0x88
[    1.964062]  [<ffffffff8108d530>] enable_irq+0x57/0x70
[    1.964073]  [<ffffffffa00eda14>] ide_probe_port+0x580/0x59f [ide_core]
[    1.964082]  [<ffffffffa00edd7e>] ide_host_register+0x2ad/0x64c [ide_core]
[    1.964106]  [<ffffffffa00f2882>] ide_pci_init_two+0x58d/0x666 [ide_core]
[    1.964111]  [<ffffffff8103561e>] ? get_parent_ip+0x11/0x41
[    1.964114]  [<ffffffff8103561e>] ? get_parent_ip+0x11/0x41
[    1.964117]  [<ffffffff8103561e>] ? get_parent_ip+0x11/0x41
[    1.964121]  [<ffffffff81037b6d>] ? sub_preempt_count+0x92/0xa6
[    1.964125]  [<ffffffff813217c6>] ? _raw_spin_unlock+0x25/0x30
[    1.964128]  [<ffffffff8132073c>] ? __mutex_unlock_slowpath+0x3d/0x42
[    1.964131]  [<ffffffff8103561e>] ? get_parent_ip+0x11/0x41
[    1.964134]  [<ffffffff8103561e>] ? get_parent_ip+0x11/0x41
[    1.964142]  [<ffffffffa00f296c>] ide_pci_init_one+0x11/0x13 [ide_core]
[    1.964147]  [<ffffffffa00680ec>] jmicron_init_one+0x12/0x14 [jmicron]
[    1.964151]  [<ffffffff811c1df6>] local_pci_probe+0x48/0x91
[    1.964155]  [<ffffffff811c2bd8>] pci_device_probe+0xc5/0xf5
[    1.964159]  [<ffffffff81248ea8>] ? driver_sysfs_add+0x6b/0x90
[    1.964162]  [<ffffffff812490b3>] driver_probe_device+0x12e/0x210
[    1.964165]  [<ffffffff812491ed>] __driver_attach+0x58/0x7c
[    1.964169]  [<ffffffff81249195>] ? __driver_attach+0x0/0x7c
[    1.964172]  [<ffffffff8124857d>] bus_for_each_dev+0x4e/0x83
[    1.964175]  [<ffffffff81248dfa>] driver_attach+0x19/0x1b
[    1.964178]  [<ffffffff81248a63>] bus_add_driver+0xd5/0x222
[    1.964181]  [<ffffffff8124977d>] driver_register+0x99/0x10a
[    1.964184]  [<ffffffff811c2e36>] __pci_register_driver+0x53/0xc3
[    1.964189]  [<ffffffffa006b000>] ? jmicron_ide_init+0x0/0x20 [jmicron]
[    1.964192]  [<ffffffffa006b01e>] jmicron_ide_init+0x1e/0x20 [jmicron]
[    1.964196]  [<ffffffff81000210>] do_one_initcall+0x7a/0x134
[    1.964201]  [<ffffffff81071391>] sys_init_module+0x9c/0x1db
[    1.964204]  [<ffffffff81322252>] system_call_fastpath+0x16/0x1b
[    1.964207] ---[ end trace 9cef210321547bfd ]---
[    1.964246] Probing IDE interface ide1...
[    2.532056] ide0 at 0xef00-0xef07,0xee02 on irq 16
[    2.532115] ide1 at 0xed00-0xed07,0xec02 on irq 16
[    2.532173] ahci 0000:03:00.0: version 3.0
[    2.532188] ahci 0000:03:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    2.548033] ahci 0000:03:00.0: AHCI 0001.0000 32 slots 2 ports 3 Gbps 0x3 impl SATA mode
[    2.548038] ahci 0000:03:00.0: flags: 64bit ncq pm led clo pmp pio slum part 
[    2.548045] ahci 0000:03:00.0: setting latency timer to 64
[    2.548371] scsi0 : ahci
[    2.548522] scsi1 : ahci
[    2.548622] ata1: SATA max UDMA/133 abar m8192@0xfddfe000 port 0xfddfe100 irq 19
[    2.548626] ata2: SATA max UDMA/133 abar m8192@0xfddfe000 port 0xfddfe180 irq 19
[    2.632011] usb usb3: suspend_rh (auto-stop)
[    2.632030] usb usb4: suspend_rh (auto-stop)
[    2.632049] usb usb5: suspend_rh (auto-stop)
[    2.632067] usb usb6: suspend_rh (auto-stop)
[    2.632085] usb usb7: suspend_rh (auto-stop)
[    2.632109] usb usb8: suspend_rh (auto-stop)
[    2.639850] ata_piix 0000:00:1f.2: version 2.13
[    2.639863] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    2.639868] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
[    2.639915] ata_piix 0000:00:1f.2: setting latency timer to 64
[    2.640239] scsi2 : ata_piix
[    2.640348] scsi3 : ata_piix
[    2.640880] ata3: SATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xf900 irq 14
[    2.640885] ata4: SATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xf908 irq 15
[    2.640915] ata_piix 0000:00:1f.5: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    2.640920] ata_piix 0000:00:1f.5: MAP [ P0 -- P1 -- ]
[    2.640963] ata_piix 0000:00:1f.5: setting latency timer to 64
[    2.641206] scsi4 : ata_piix
[    2.641295] scsi5 : ata_piix
[    2.641686] ata5: SATA max UDMA/133 cmd 0xf600 ctl 0xf500 bmdma 0xf200 irq 19
[    2.641690] ata6: SATA max UDMA/133 cmd 0xf400 ctl 0xf300 bmdma 0xf208 irq 19
[    2.868026] ata1: SATA link down (SStatus 0 SControl 300)
[    2.868064] ata2: SATA link down (SStatus 0 SControl 300)
[    2.970603] ata6: SATA link down (SStatus 0 SControl 300)
[    2.981214] ata5: SATA link down (SStatus 0 SControl 300)
[    3.436057] ata4.00: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    3.436069] ata4.01: SATA link down (SStatus 0 SControl 300)
[    3.436080] ata4.01: link offline, clearing class 3 to NONE
[    3.444130] ata4.00: ATAPI: ATAPI   iHAS222   8, 4L01, max UDMA/100
[    3.448057] ata3.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    3.448067] ata3.01: SATA link down (SStatus 0 SControl 300)
[    3.456688] ata3.00: HPA detected: current 1953523055, native 1953525168
[    3.456693] ata3.00: ATA-8: WDC WD1002FBYS-01A6B0, 03.00C05, max UDMA/133
[    3.456696] ata3.00: 1953523055 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    3.460119] ata4.00: configured for UDMA/100
[    3.472719] ata3.00: configured for UDMA/133
[    3.472846] scsi 2:0:0:0: Direct-Access     ATA      WDC WD1002FBYS-0 03.0 PQ: 0 ANSI: 5
[    3.474288] scsi 3:0:0:0: CD-ROM            ATAPI    iHAS222   8      4L01 PQ: 0 ANSI: 5
[    3.485638] sr0: scsi3-mmc drive: 48x/12x writer dvd-ram cd/rw xa/form2 cdda tray
[    3.485641] cdrom: Uniform CD-ROM driver Revision: 3.20
[    3.485952] sr 3:0:0:0: Attached scsi CD-ROM sr0
[    3.487651] sd 2:0:0:0: [sda] 1953523055 512-byte logical blocks: (1.00 TB/931 GiB)
[    3.487721] sd 2:0:0:0: [sda] Write Protect is off
[    3.487726] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.487763] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.491491] sd 2:0:0:0: Attached scsi generic sg0 type 0
[    3.491628] sr 3:0:0:0: Attached scsi generic sg1 type 5
[    3.520558]  sda: sda1 sda2 sda3
[    3.520888] sd 2:0:0:0: [sda] Attached SCSI disk
[    3.784023] hub 1-0:1.0: hub_suspend
[    3.784033] usb usb1: bus auto-suspend
[    3.784036] ehci_hcd 0000:00:1a.7: suspend root hub
[    3.784056] hub 2-0:1.0: hub_suspend
[    3.784061] usb usb2: bus auto-suspend
[    3.784063] ehci_hcd 0000:00:1d.7: suspend root hub
[    3.784082] hub 3-0:1.0: hub_suspend
[    3.784086] usb usb3: bus auto-suspend
[    3.784089] usb usb3: suspend_rh
[    3.784109] hub 4-0:1.0: hub_suspend
[    3.784112] usb usb4: bus auto-suspend
[    3.784114] usb usb4: suspend_rh
[    3.784128] hub 5-0:1.0: hub_suspend
[    3.784131] usb usb5: bus auto-suspend
[    3.784133] usb usb5: suspend_rh
[    3.784147] hub 6-0:1.0: hub_suspend
[    3.784150] usb usb6: bus auto-suspend
[    3.784152] usb usb6: suspend_rh
[    3.784166] hub 8-0:1.0: hub_suspend
[    3.784169] usb usb8: bus auto-suspend
[    3.784171] usb usb8: suspend_rh
[    3.808009] hub 7-0:1.0: hub_suspend
[    3.808015] usb usb7: bus auto-suspend
[    3.808018] usb usb7: suspend_rh
[    3.895593] PM: Starting manual resume from disk
[    3.930586] EXT4-fs (sda2): INFO: recovery required on readonly filesystem
[    3.930590] EXT4-fs (sda2): write access will be enabled during recovery
[    5.605377] EXT4-fs (sda2): orphan cleanup on readonly fs
[    5.605387] EXT4-fs (sda2): ext4_orphan_cleanup: deleting unreferenced inode 26157071
[    5.605421] EXT4-fs (sda2): ext4_orphan_cleanup: deleting unreferenced inode 26099750
[    5.605472] EXT4-fs (sda2): 2 orphan inodes deleted
[    5.605475] EXT4-fs (sda2): recovery complete
[    6.051421] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null)
[    7.469988] udev[1352]: starting version 164
[    7.672783] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[    7.672794] ACPI: Power Button [PWRB]
[    7.672874] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    7.672879] ACPI: Power Button [PWRF]
[    7.776797] input: PC Speaker as /devices/platform/pcspkr/input/input3
[    7.790554] i2c-core: driver [dummy] registered
[    7.867898] parport_pc 00:09: reported by Plug and Play ACPI
[    7.867944] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
[    7.899382] i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    7.899391] i801_smbus 0000:00:1f.3: SMBus using PCI Interrupt
[    7.899424] i2c i2c-0: adapter [SMBus I801 adapter at 0500] registered
[    7.962471] ACPI: acpi_idle registered with cpuidle
[    8.532269] input: ImPS/2 Logitech Wheel Mouse as /devices/platform/i8042/serio1/input/input4
[    8.651163] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    8.651240] HDA Intel 0000:00:1b.0: irq 45 for MSI/MSI-X
[    8.651265] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    8.651269] ALSA sound/pci/hda/hda_intel.c:2538: chipset global capabilities = 0x4401
[    8.680009] ALSA sound/pci/hda/hda_intel.c:913: codec_mask = 0x4
[    8.680082] ALSA sound/pci/hda/hda_intel.c:1356: codec #2 probed OK
[    8.737070] ALSA sound/pci/hda/hda_codec.c:3727: hda_codec: model '6stack-dig' is selected for config 1458:a002 (Gigabyte P35 DS3R)
[    8.737077] ALSA sound/pci/hda/patch_realtek.c:1457: SKU: Nid=0x1d sku_cfg=0x4005e601
[    8.737082] ALSA sound/pci/hda/patch_realtek.c:1459: SKU: port_connectivity=0x1
[    8.737085] ALSA sound/pci/hda/patch_realtek.c:1460: SKU: enable_pcbeep=0x0
[    8.737088] ALSA sound/pci/hda/patch_realtek.c:1461: SKU: check_sum=0x00000005
[    8.737092] ALSA sound/pci/hda/patch_realtek.c:1462: SKU: customization=0x000000e6
[    8.737097] ALSA sound/pci/hda/patch_realtek.c:1463: SKU: external_amp=0x0
[    8.737100] ALSA sound/pci/hda/patch_realtek.c:1464: SKU: platform_type=0x0
[    8.737102] ALSA sound/pci/hda/patch_realtek.c:1465: SKU: swap=0x0
[    8.737106] ALSA sound/pci/hda/patch_realtek.c:1466: SKU: override=0x1
[    8.739588] ALSA sound/pci/hda/hda_codec.c:2165: Cannot find slave Headphone Playback Volume, skipped
[    8.739592] ALSA sound/pci/hda/hda_codec.c:2165: Cannot find slave Speaker Playback Volume, skipped
[    8.739595] ALSA sound/pci/hda/hda_codec.c:2165: Cannot find slave Mono Playback Volume, skipped
[    8.739599] ALSA sound/pci/hda/hda_codec.c:2165: Cannot find slave Line-Out Playback Volume, skipped
[    8.739602] ALSA sound/pci/hda/hda_codec.c:2165: Cannot find slave PCM Playback Volume, skipped
[    8.739614] ALSA sound/pci/hda/hda_codec.c:2165: Cannot find slave Speaker Playback Switch, skipped
[    8.739617] ALSA sound/pci/hda/hda_codec.c:2165: Cannot find slave Mono Playback Switch, skipped
[    8.739623] ALSA sound/pci/hda/hda_codec.c:2165: Cannot find slave Line-Out Playback Switch, skipped
[    8.739626] ALSA sound/pci/hda/hda_codec.c:2165: Cannot find slave PCM Playback Switch, skipped
[    9.591252] Adding 9462280k swap on /dev/sda3.  Priority:-1 extents:1 across:9462280k 
[    9.595573] EXT4-fs (sda2): re-mounted. Opts: (null)
[    9.767512] EXT4-fs (sda2): re-mounted. Opts: errors=remount-ro
[    9.849806] loop: module loaded
[    9.870779] it87: Found IT8718F chip at 0x290, revision 5
[    9.870786] it87: VID is disabled (pins used for GPIO)
[    9.870796] it87: Beeping is supported
[   10.548174] EXT3-fs: barriers not enabled
[   10.558044] kjournald starting.  Commit interval 5 seconds
[   10.558278] EXT3-fs (sda1): using internal journal
[   10.558282] EXT3-fs (sda1): mounted filesystem with writeback data mode
[   11.592585] IPv4 FIB: Using LC-trie version 0.409
[   12.053973] fuse init (API version 7.16)
[   12.201020] r8169 0000:05:00.0: eth1: link down
[   12.653448] r8169 0000:04:00.0: eth0: link down
[   12.653460] r8169 0000:04:00.0: eth0: link down
[   13.752157] lp0: using parport0 (interrupt-driven).
[   13.752160] lp0: console ready
[   13.760893] ppdev: user-space parallel port driver
[   17.012820] Bluetooth: Core ver 2.16
[   17.012852] NET: Registered protocol family 31
[   17.012854] Bluetooth: HCI device and connection manager initialized
[   17.012857] Bluetooth: HCI socket layer initialized
[   24.720080] sshd (3027): /proc/3027/oom_adj is deprecated, please use /proc/3027/oom_score_adj instead.
[   64.747563] r8169 0000:04:00.0: eth0: link down
[   64.747570] r8169 0000:04:00.0: eth0: link down
[  154.320623] r8169 0000:04:00.0: eth0: link down
[  154.320633] r8169 0000:04:00.0: eth0: link down

--------------050603090107040209070909
Content-Type: text/plain;
 name="dmesg.GOOD.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg.GOOD.txt"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.38-git3 (root@aapi205) (gcc version 4.4.5 (Debian 4.4.5-10) ) #1 SMP PREEMPT Thu Mar 17 11:26:43 CET 2011
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-2.6.38-git3 root=UUID=cdb6c166-b027-4a29-87fa-93d604dc5e53 ro all_generic_ata quiet
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000dfee0000 (usable)
[    0.000000]  BIOS-e820: 00000000dfee0000 - 00000000dfee2000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000dfee2000 - 00000000dfef0000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000dfef0000 - 00000000dff00000 (reserved)
[    0.000000]  BIOS-e820: 00000000f4000000 - 00000000f8000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000120000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] DMI: Gigabyte Technology Co., Ltd. EP45-UD3/EP45-UD3, BIOS F10b 08/05/2010
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x120000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CDFFF write-protect
[    0.000000]   CE000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-through
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F00000000 write-back
[    0.000000]   1 base 0E0000000 mask FE0000000 uncachable
[    0.000000]   2 base 100000000 mask FE0000000 write-back
[    0.000000]   3 base 0DFF00000 mask FFFF00000 uncachable
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000dff00000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xdfee0 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [ffff8800000f5670] f5670
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff88000009a000] 9a000 size 20480
[    0.000000] init_memory_mapping: 0000000000000000-00000000dfee0000
[    0.000000]  0000000000 - 00dfe00000 page 2M
[    0.000000]  00dfe00000 - 00dfee0000 page 4k
[    0.000000] kernel direct mapping tables up to dfee0000 @ dfeda000-dfee0000
[    0.000000] init_memory_mapping: 0000000100000000-0000000120000000
[    0.000000]  0100000000 - 0120000000 page 2M
[    0.000000] kernel direct mapping tables up to 120000000 @ 11fffa000-120000000
[    0.000000] RAMDISK: 37556000 - 37ff0000
[    0.000000] ACPI: RSDP 00000000000f7080 00014 (v00 GBT   )
[    0.000000] ACPI: RSDT 00000000dfee2040 00040 (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: FACP 00000000dfee20c0 00074 (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: DSDT 00000000dfee2180 04D29 (v01 GBT    GBTUACPI 00001000 MSFT 0100000C)
[    0.000000] ACPI: FACS 00000000dfee0000 00040
[    0.000000] ACPI: HPET 00000000dfee7000 00038 (v01 GBT    GBTUACPI 42302E31 GBTU 00000098)
[    0.000000] ACPI: MCFG 00000000dfee7080 0003C (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: EUDS 00000000dfee70c0 004D0 (v01 GBT             00000000      00000000)
[    0.000000] ACPI: TAMG 00000000dfee7590 06852 (v01 GBT    GBT   B0 5455312E BG?? 00020101)
[    0.000000] ACPI: APIC 00000000dfee6f00 00084 (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: SSDT 00000000dfeee720 003AB (v01  PmRef    CpuPm 00003000 INTL 20040311)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-0000000120000000
[    0.000000] NUMA: Using 63 for the hash shift.
[    0.000000] Initmem setup node 0 0000000000000000-0000000120000000
[    0.000000]   NODE_DATA [000000011ffeb000 - 000000011fff9fff]
[    0.000000]  [ffffea0000000000-ffffea0003ffffff] PMD -> [ffff88011b600000-ffff88011effffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00120000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000dfee0
[    0.000000]     0: 0x00100000 -> 0x00120000
[    0.000000] On node 0 totalpages: 1048175
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 5 pages reserved
[    0.000000]   DMA zone: 3922 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 898840 pages, LIFO batch:31
[    0.000000]   Normal zone: 1792 pages used for memmap
[    0.000000]   Normal zone: 129280 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000dfee0000 - 00000000dfee2000
[    0.000000] PM: Registered nosave memory: 00000000dfee2000 - 00000000dfef0000
[    0.000000] PM: Registered nosave memory: 00000000dfef0000 - 00000000dff00000
[    0.000000] PM: Registered nosave memory: 00000000dff00000 - 00000000f4000000
[    0.000000] PM: Registered nosave memory: 00000000f4000000 - 00000000f8000000
[    0.000000] PM: Registered nosave memory: 00000000f8000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at dff00000 (gap: dff00000:14100000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88011fc00000 s79488 r8192 d22912 u524288
[    0.000000] pcpu-alloc: s79488 r8192 d22912 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1032042
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-2.6.38-git3 root=UUID=cdb6c166-b027-4a29-87fa-93d604dc5e53 ro all_generic_ata quiet
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 4047112k/4718592k available (3204k kernel code, 525892k absent, 145588k reserved, 3687k data, 584k init)
[    0.000000] Preemptable hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:712 16
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2332.914 MHz processor.
[    0.004004] Calibrating delay loop (skipped), value calculated using timer frequency.. 4665.82 BogoMIPS (lpj=9331656)
[    0.004008] pid_max: default: 32768 minimum: 301
[    0.004060] Security Framework initialized
[    0.004070] SELinux:  Disabled at boot.
[    0.004409] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.008115] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.008805] Mount-cache hash table entries: 256
[    0.008943] Initializing cgroup subsys ns
[    0.008946] ns_cgroup deprecated: consider using the 'clone_children' flag without the ns_cgroup.
[    0.008949] Initializing cgroup subsys cpuacct
[    0.008954] Initializing cgroup subsys devices
[    0.008957] Initializing cgroup subsys blkio
[    0.008997] CPU: Physical Processor ID: 0
[    0.008998] CPU: Processor Core ID: 0
[    0.009000] mce: CPU supports 6 MCE banks
[    0.009008] CPU0: Thermal monitoring enabled (TM2)
[    0.009012] using mwait in idle threads.
[    0.009772] ACPI: Core revision 20110112
[    0.012997] Setting APIC routing to flat
[    0.013298] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.052996] CPU0: Intel(R) Core(TM)2 Quad  CPU   Q8200  @ 2.33GHz stepping 07
[    0.056003] Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
[    0.056003] ... version:                2
[    0.056003] ... bit width:              40
[    0.056003] ... generic registers:      2
[    0.056003] ... value mask:             000000ffffffffff
[    0.056003] ... max period:             000000007fffffff
[    0.056003] ... fixed-purpose events:   3
[    0.056003] ... event mask:             0000000700000003
[    0.076022] Booting Node   0, Processors  #1
[    0.076026] smpboot cpu 1: start_ip = 9a000
[    0.176037]  #2
[    0.176039] smpboot cpu 2: start_ip = 9a000
[    0.276040]  #3 Ok.
[    0.276042] smpboot cpu 3: start_ip = 9a000
[    0.368031] Brought up 4 CPUs
[    0.368034] Total of 4 processors activated (18664.09 BogoMIPS).
[    0.369333] devtmpfs: initialized
[    0.374119] print_constraints: dummy: 
[    0.374119] NET: Registered protocol family 16
[    0.374119] ACPI: bus type pci registered
[    0.376062] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf4000000-0xf7ffffff] (base 0xf4000000)
[    0.376062] PCI: MMCONFIG at [mem 0xf4000000-0xf7ffffff] reserved in E820
[    0.382692] PCI: Using configuration type 1 for base access
[    0.384214] bio: create slab <bio-0> at 0
[    0.388184] ACPI: EC: Look up EC in DSDT
[    0.392198] ACPI Warning: Incorrect checksum in table [TAMG] - 0x14, should be 0x13 (20110112/tbutils-314)
[    0.392405] ACPI: SSDT 00000000dfeede40 0022A (v01  PmRef  Cpu0Ist 00003000 INTL 20040311)
[    0.392658] ACPI: Dynamic OEM Table Load:
[    0.392661] ACPI: SSDT           (null) 0022A (v01  PmRef  Cpu0Ist 00003000 INTL 20040311)
[    0.392843] ACPI: SSDT 00000000dfeee300 00152 (v01  PmRef  Cpu1Ist 00003000 INTL 20040311)
[    0.393085] ACPI: Dynamic OEM Table Load:
[    0.393088] ACPI: SSDT           (null) 00152 (v01  PmRef  Cpu1Ist 00003000 INTL 20040311)
[    0.393275] ACPI: SSDT 00000000dfeee460 00152 (v01  PmRef  Cpu2Ist 00003000 INTL 20040311)
[    0.393518] ACPI: Dynamic OEM Table Load:
[    0.393521] ACPI: SSDT           (null) 00152 (v01  PmRef  Cpu2Ist 00003000 INTL 20040311)
[    0.393707] ACPI: SSDT 00000000dfeee5c0 00152 (v01  PmRef  Cpu3Ist 00003000 INTL 20040311)
[    0.393951] ACPI: Dynamic OEM Table Load:
[    0.393954] ACPI: SSDT           (null) 00152 (v01  PmRef  Cpu3Ist 00003000 INTL 20040311)
[    0.394146] ACPI: Interpreter enabled
[    0.394149] ACPI: (supports S0 S3 S4 S5)
[    0.394170] ACPI: Using IOAPIC for interrupt routing
[    0.400461] ACPI: No dock devices found.
[    0.400461] HEST: Table not found.
[    0.400461] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.404066] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3f])
[    0.404112] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
[    0.404114] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
[    0.404116] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.404119] pci_root PNP0A03:00: host bridge window [mem 0x000c0000-0x000dffff]
[    0.404121] pci_root PNP0A03:00: host bridge window [mem 0xdff00000-0xfebfffff]
[    0.404126] pci_bus 0000:00: scanning bus
[    0.404135] pci 0000:00:00.0: [8086:2e20] type 0 class 0x000600
[    0.404141] pci 0000:00:00.0: calling quirk_mmio_always_on+0x0/0x17
[    0.404160] pci 0000:00:00.0: calling quirk_resource_alignment+0x0/0x166
[    0.404164] pci 0000:00:00.0: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.404186] pci 0000:00:01.0: [8086:2e21] type 1 class 0x000604
[    0.404189] pci 0000:00:01.0: calling quirk_mmio_always_on+0x0/0x17
[    0.404206] pci 0000:00:01.0: calling quirk_resource_alignment+0x0/0x166
[    0.404209] pci 0000:00:01.0: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.404223] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.404226] pci 0000:00:01.0: PME# disabled
[    0.404263] pci 0000:00:1a.0: [8086:3a37] type 0 class 0x000c03
[    0.404269] pci 0000:00:1a.0: calling quirk_mmio_always_on+0x0/0x17
[    0.404305] pci 0000:00:1a.0: reg 20: [io  0xff00-0xff1f]
[    0.404323] pci 0000:00:1a.0: calling quirk_resource_alignment+0x0/0x166
[    0.404326] pci 0000:00:1a.0: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.404353] pci 0000:00:1a.1: [8086:3a38] type 0 class 0x000c03
[    0.404360] pci 0000:00:1a.1: calling quirk_mmio_always_on+0x0/0x17
[    0.404395] pci 0000:00:1a.1: reg 20: [io  0xfe00-0xfe1f]
[    0.404413] pci 0000:00:1a.1: calling quirk_resource_alignment+0x0/0x166
[    0.404416] pci 0000:00:1a.1: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.404443] pci 0000:00:1a.2: [8086:3a39] type 0 class 0x000c03
[    0.404450] pci 0000:00:1a.2: calling quirk_mmio_always_on+0x0/0x17
[    0.404485] pci 0000:00:1a.2: reg 20: [io  0xfd00-0xfd1f]
[    0.404503] pci 0000:00:1a.2: calling quirk_resource_alignment+0x0/0x166
[    0.404506] pci 0000:00:1a.2: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.404537] pci 0000:00:1a.7: [8086:3a3c] type 0 class 0x000c03
[    0.404544] pci 0000:00:1a.7: calling quirk_mmio_always_on+0x0/0x17
[    0.404556] pci 0000:00:1a.7: reg 10: [mem 0xfdfff000-0xfdfff3ff]
[    0.404604] pci 0000:00:1a.7: calling quirk_resource_alignment+0x0/0x166
[    0.404607] pci 0000:00:1a.7: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.404639] pci 0000:00:1b.0: [8086:3a3e] type 0 class 0x000403
[    0.404642] pci 0000:00:1b.0: calling quirk_mmio_always_on+0x0/0x17
[    0.404656] pci 0000:00:1b.0: reg 10: [mem 0xfdff8000-0xfdffbfff 64bit]
[    0.404690] pci 0000:00:1b.0: calling quirk_resource_alignment+0x0/0x166
[    0.404693] pci 0000:00:1b.0: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.404712] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.404716] pci 0000:00:1b.0: PME# disabled
[    0.404735] pci 0000:00:1c.0: [8086:3a40] type 1 class 0x000604
[    0.404738] pci 0000:00:1c.0: calling quirk_mmio_always_on+0x0/0x17
[    0.404770] pci 0000:00:1c.0: calling quirk_resource_alignment+0x0/0x166
[    0.404773] pci 0000:00:1c.0: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.404794] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.404798] pci 0000:00:1c.0: PME# disabled
[    0.404820] pci 0000:00:1c.3: [8086:3a46] type 1 class 0x000604
[    0.404823] pci 0000:00:1c.3: calling quirk_mmio_always_on+0x0/0x17
[    0.404854] pci 0000:00:1c.3: calling quirk_resource_alignment+0x0/0x166
[    0.404857] pci 0000:00:1c.3: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.404879] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.404882] pci 0000:00:1c.3: PME# disabled
[    0.404902] pci 0000:00:1c.4: [8086:3a48] type 1 class 0x000604
[    0.404906] pci 0000:00:1c.4: calling quirk_mmio_always_on+0x0/0x17
[    0.404937] pci 0000:00:1c.4: calling quirk_resource_alignment+0x0/0x166
[    0.404940] pci 0000:00:1c.4: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.404962] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.404965] pci 0000:00:1c.4: PME# disabled
[    0.404989] pci 0000:00:1d.0: [8086:3a34] type 0 class 0x000c03
[    0.404995] pci 0000:00:1d.0: calling quirk_mmio_always_on+0x0/0x17
[    0.405031] pci 0000:00:1d.0: reg 20: [io  0xfc00-0xfc1f]
[    0.405049] pci 0000:00:1d.0: calling quirk_resource_alignment+0x0/0x166
[    0.405052] pci 0000:00:1d.0: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.405079] pci 0000:00:1d.1: [8086:3a35] type 0 class 0x000c03
[    0.405086] pci 0000:00:1d.1: calling quirk_mmio_always_on+0x0/0x17
[    0.405121] pci 0000:00:1d.1: reg 20: [io  0xfb00-0xfb1f]
[    0.405139] pci 0000:00:1d.1: calling quirk_resource_alignment+0x0/0x166
[    0.405142] pci 0000:00:1d.1: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.405169] pci 0000:00:1d.2: [8086:3a36] type 0 class 0x000c03
[    0.405175] pci 0000:00:1d.2: calling quirk_mmio_always_on+0x0/0x17
[    0.405211] pci 0000:00:1d.2: reg 20: [io  0xfa00-0xfa1f]
[    0.405229] pci 0000:00:1d.2: calling quirk_resource_alignment+0x0/0x166
[    0.405232] pci 0000:00:1d.2: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.405263] pci 0000:00:1d.7: [8086:3a3a] type 0 class 0x000c03
[    0.405270] pci 0000:00:1d.7: calling quirk_mmio_always_on+0x0/0x17
[    0.405282] pci 0000:00:1d.7: reg 10: [mem 0xfdffe000-0xfdffe3ff]
[    0.405330] pci 0000:00:1d.7: calling quirk_resource_alignment+0x0/0x166
[    0.405333] pci 0000:00:1d.7: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.405361] pci 0000:00:1e.0: [8086:244e] type 1 class 0x000604
[    0.405367] pci 0000:00:1e.0: calling quirk_mmio_always_on+0x0/0x17
[    0.405392] pci 0000:00:1e.0: calling quirk_resource_alignment+0x0/0x166
[    0.405396] pci 0000:00:1e.0: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.405422] pci 0000:00:1f.0: [8086:3a18] type 0 class 0x000601
[    0.405430] pci 0000:00:1f.0: calling quirk_mmio_always_on+0x0/0x17
[    0.405496] pci 0000:00:1f.0: calling quirk_resource_alignment+0x0/0x166
[    0.405499] pci 0000:00:1f.0: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.405532] pci 0000:00:1f.2: [8086:3a20] type 0 class 0x000101
[    0.405539] pci 0000:00:1f.2: calling quirk_mmio_always_on+0x0/0x17
[    0.405549] pci 0000:00:1f.2: reg 10: [io  0x0000-0x0007]
[    0.405556] pci 0000:00:1f.2: reg 14: [io  0x0000-0x0003]
[    0.405564] pci 0000:00:1f.2: reg 18: [io  0x0000-0x0007]
[    0.405571] pci 0000:00:1f.2: reg 1c: [io  0x0000-0x0003]
[    0.405579] pci 0000:00:1f.2: reg 20: [io  0xf900-0xf90f]
[    0.405586] pci 0000:00:1f.2: reg 24: [io  0xf800-0xf80f]
[    0.405597] pci 0000:00:1f.2: calling quirk_resource_alignment+0x0/0x166
[    0.405601] pci 0000:00:1f.2: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.405627] pci 0000:00:1f.3: [8086:3a30] type 0 class 0x000c05
[    0.405631] pci 0000:00:1f.3: calling quirk_mmio_always_on+0x0/0x17
[    0.405644] pci 0000:00:1f.3: reg 10: [mem 0xfdffd000-0xfdffd0ff 64bit]
[    0.405663] pci 0000:00:1f.3: reg 20: [io  0x0500-0x051f]
[    0.405680] pci 0000:00:1f.3: calling quirk_resource_alignment+0x0/0x166
[    0.405683] pci 0000:00:1f.3: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.405700] pci 0000:00:1f.5: [8086:3a26] type 0 class 0x000101
[    0.405708] pci 0000:00:1f.5: calling quirk_mmio_always_on+0x0/0x17
[    0.405717] pci 0000:00:1f.5: reg 10: [io  0xf600-0xf607]
[    0.405725] pci 0000:00:1f.5: reg 14: [io  0xf500-0xf503]
[    0.405732] pci 0000:00:1f.5: reg 18: [io  0xf400-0xf407]
[    0.405740] pci 0000:00:1f.5: reg 1c: [io  0xf300-0xf303]
[    0.405747] pci 0000:00:1f.5: reg 20: [io  0xf200-0xf20f]
[    0.405754] pci 0000:00:1f.5: reg 24: [io  0xf100-0xf10f]
[    0.405766] pci 0000:00:1f.5: calling quirk_resource_alignment+0x0/0x166
[    0.405769] pci 0000:00:1f.5: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.405791] pci_bus 0000:00: fixups for bus
[    0.405794] pci 0000:00:01.0: scanning [bus 01-01] behind bridge, pass 0
[    0.405817] pci_bus 0000:01: scanning bus
[    0.405831] pci 0000:01:00.0: [10de:0641] type 0 class 0x000300
[    0.405835] pci 0000:01:00.0: calling quirk_mmio_always_on+0x0/0x17
[    0.405844] pci 0000:01:00.0: reg 10: [mem 0xfa000000-0xfaffffff]
[    0.405854] pci 0000:01:00.0: reg 14: [mem 0xe0000000-0xefffffff 64bit pref]
[    0.405865] pci 0000:01:00.0: reg 1c: [mem 0xf8000000-0xf9ffffff 64bit]
[    0.405872] pci 0000:01:00.0: reg 24: [io  0xbf00-0xbf7f]
[    0.405880] pci 0000:01:00.0: reg 30: [mem 0x00000000-0x0007ffff pref]
[    0.405885] pci 0000:01:00.0: calling quirk_resource_alignment+0x0/0x166
[    0.405926] pci_bus 0000:01: fixups for bus
[    0.405928] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.405931] pci 0000:00:01.0:   bridge window [io  0xb000-0xbfff]
[    0.405934] pci 0000:00:01.0:   bridge window [mem 0xf8000000-0xfbffffff]
[    0.405938] pci 0000:00:01.0:   bridge window [mem 0xe0000000-0xefffffff 64bit pref]
[    0.405940] pci_bus 0000:01: bus scan returning with max=01
[    0.405944] pci 0000:00:1c.0: scanning [bus 02-02] behind bridge, pass 0
[    0.405978] pci_bus 0000:02: scanning bus
[    0.405980] pci_bus 0000:02: fixups for bus
[    0.405982] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.405986] pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.405990] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.405996] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.405998] pci_bus 0000:02: bus scan returning with max=02
[    0.406002] pci 0000:00:1c.3: scanning [bus 03-03] behind bridge, pass 0
[    0.406035] pci_bus 0000:03: scanning bus
[    0.406055] pci 0000:03:00.0: [197b:2363] type 0 class 0x000101
[    0.406061] pci 0000:03:00.0: calling quirk_jmicron_ata+0x0/0x100
[    0.406074] pci 0000:03:00.0: calling quirk_mmio_always_on+0x0/0x17
[    0.406147] pci 0000:03:00.0: reg 24: [mem 0xfddfe000-0xfddfffff]
[    0.406165] pci 0000:03:00.0: calling quirk_resource_alignment+0x0/0x166
[    0.406193] pci 0000:03:00.0: PME# supported from D3hot
[    0.406198] pci 0000:03:00.0: PME# disabled
[    0.406227] pci 0000:03:00.1: [197b:2363] type 0 class 0x000101
[    0.406237] pci 0000:03:00.1: calling quirk_jmicron_ata+0x0/0x100
[    0.406239] pci 0000:03:00.1: calling quirk_mmio_always_on+0x0/0x17
[    0.406256] pci 0000:03:00.1: reg 10: [io  0xef00-0xef07]
[    0.406270] pci 0000:03:00.1: reg 14: [io  0xee00-0xee03]
[    0.406283] pci 0000:03:00.1: reg 18: [io  0xed00-0xed07]
[    0.406296] pci 0000:03:00.1: reg 1c: [io  0xec00-0xec03]
[    0.406309] pci 0000:03:00.1: reg 20: [io  0xeb00-0xeb0f]
[    0.406340] pci 0000:03:00.1: calling quirk_resource_alignment+0x0/0x166
[    0.406380] pci 0000:03:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.406393] pci_bus 0000:03: fixups for bus
[    0.406395] pci 0000:00:1c.3: PCI bridge to [bus 03-03]
[    0.406398] pci 0000:00:1c.3:   bridge window [io  0xe000-0xefff]
[    0.406402] pci 0000:00:1c.3:   bridge window [mem 0xfdd00000-0xfddfffff]
[    0.406408] pci 0000:00:1c.3:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.406410] pci_bus 0000:03: bus scan returning with max=03
[    0.406414] pci 0000:00:1c.4: scanning [bus 04-04] behind bridge, pass 0
[    0.406448] pci_bus 0000:04: scanning bus
[    0.406468] pci 0000:04:00.0: [10ec:8168] type 0 class 0x000200
[    0.406473] pci 0000:04:00.0: calling quirk_mmio_always_on+0x0/0x17
[    0.406487] pci 0000:04:00.0: reg 10: [io  0xde00-0xdeff]
[    0.406514] pci 0000:04:00.0: reg 18: [mem 0xfdeff000-0xfdefffff 64bit pref]
[    0.406532] pci 0000:04:00.0: reg 20: [mem 0xfdee0000-0xfdeeffff 64bit pref]
[    0.406544] pci 0000:04:00.0: reg 30: [mem 0x00000000-0x0000ffff pref]
[    0.406550] pci 0000:04:00.0: calling quirk_resource_alignment+0x0/0x166
[    0.406584] pci 0000:04:00.0: supports D1 D2
[    0.406586] pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.406591] pci 0000:04:00.0: PME# disabled
[    0.412040] pci_bus 0000:04: fixups for bus
[    0.412043] pci 0000:00:1c.4: PCI bridge to [bus 04-04]
[    0.412047] pci 0000:00:1c.4:   bridge window [io  0xd000-0xdfff]
[    0.412052] pci 0000:00:1c.4:   bridge window [mem 0xfdb00000-0xfdbfffff]
[    0.412058] pci 0000:00:1c.4:   bridge window [mem 0xfde00000-0xfdefffff 64bit pref]
[    0.412060] pci_bus 0000:04: bus scan returning with max=04
[    0.412065] pci 0000:00:1e.0: scanning [bus 05-05] behind bridge, pass 0
[    0.412085] pci_bus 0000:05: scanning bus
[    0.412099] pci 0000:05:00.0: [10ec:8169] type 0 class 0x000200
[    0.412107] pci 0000:05:00.0: calling quirk_mmio_always_on+0x0/0x17
[    0.412120] pci 0000:05:00.0: reg 10: [io  0xce00-0xceff]
[    0.412146] pci 0000:05:00.0: reg 14: [mem 0xfdcff000-0xfdcff0ff]
[    0.412186] pci 0000:05:00.0: reg 30: [mem 0x00000000-0x0000ffff pref]
[    0.412191] pci 0000:05:00.0: calling quirk_resource_alignment+0x0/0x166
[    0.412207] pci 0000:05:00.0: supports D1 D2
[    0.412209] pci 0000:05:00.0: PME# supported from D1 D2 D3hot D3cold
[    0.412213] pci 0000:05:00.0: PME# disabled
[    0.412237] pci 0000:05:07.0: [104c:8024] type 0 class 0x000c00
[    0.412245] pci 0000:05:07.0: calling quirk_mmio_always_on+0x0/0x17
[    0.412257] pci 0000:05:07.0: reg 10: [mem 0xfdcfe000-0xfdcfe7ff]
[    0.412267] pci 0000:05:07.0: reg 14: [mem 0xfdcf8000-0xfdcfbfff]
[    0.412311] pci 0000:05:07.0: calling quirk_resource_alignment+0x0/0x166
[    0.412327] pci 0000:05:07.0: supports D1 D2
[    0.412329] pci 0000:05:07.0: PME# supported from D0 D1 D2 D3hot
[    0.412333] pci 0000:05:07.0: PME# disabled
[    0.412367] pci_bus 0000:05: fixups for bus
[    0.412369] pci 0000:00:1e.0: PCI bridge to [bus 05-05] (subtractive decode)
[    0.412373] pci 0000:00:1e.0:   bridge window [io  0xc000-0xcfff]
[    0.412377] pci 0000:00:1e.0:   bridge window [mem 0xfdc00000-0xfdcfffff]
[    0.412382] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.412385] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.412388] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.412390] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.412393] pci 0000:00:1e.0:   bridge window [mem 0x000c0000-0x000dffff] (subtractive decode)
[    0.412395] pci 0000:00:1e.0:   bridge window [mem 0xdff00000-0xfebfffff] (subtractive decode)
[    0.412398] pci_bus 0000:05: bus scan returning with max=05
[    0.412402] pci 0000:00:01.0: scanning [bus 01-01] behind bridge, pass 1
[    0.412406] pci 0000:00:1c.0: scanning [bus 02-02] behind bridge, pass 1
[    0.412412] pci 0000:00:1c.3: scanning [bus 03-03] behind bridge, pass 1
[    0.412417] pci 0000:00:1c.4: scanning [bus 04-04] behind bridge, pass 1
[    0.412423] pci 0000:00:1e.0: scanning [bus 05-05] behind bridge, pass 1
[    0.412427] pci_bus 0000:00: bus scan returning with max=05
[    0.412431] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.412590] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
[    0.412638] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX3._PRT]
[    0.412693] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
[    0.412737] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
[    0.412892]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.424693] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
[    0.424693] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.424693] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
[    0.424693] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
[    0.424693] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
[    0.424693] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
[    0.424693] ACPI: PCI Interrupt Link [LNK0] (IRQs *3 4 5 6 7 9 10 11 12 14 15)
[    0.424693] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
[    0.424693] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.424693] vgaarb: loaded
[    0.428054] usbcore: registered new interface driver usbfs
[    0.428054] usbcore: registered new interface driver hub
[    0.428062] usbcore: registered new device driver usb
[    0.428062] PCI: Using ACPI for IRQ routing
[    0.428062] PCI: pci_cache_line_size set to 64 bytes
[    0.428062] pci 0000:00:1a.0: BAR 4: reserving [io  0xff00-0xff1f flags 0x40101] (d=0, p=0)
[    0.428062] pci 0000:00:1a.1: BAR 4: reserving [io  0xfe00-0xfe1f flags 0x40101] (d=0, p=0)
[    0.428062] pci 0000:00:1a.2: BAR 4: reserving [io  0xfd00-0xfd1f flags 0x40101] (d=0, p=0)
[    0.428063] pci 0000:00:1a.7: BAR 0: reserving [mem 0xfdfff000-0xfdfff3ff flags 0x40200] (d=0, p=0)
[    0.428068] pci 0000:00:1b.0: BAR 0: reserving [mem 0xfdff8000-0xfdffbfff flags 0x140204] (d=0, p=0)
[    0.428078] pci 0000:00:1d.0: BAR 4: reserving [io  0xfc00-0xfc1f flags 0x40101] (d=0, p=0)
[    0.428083] pci 0000:00:1d.1: BAR 4: reserving [io  0xfb00-0xfb1f flags 0x40101] (d=0, p=0)
[    0.428088] pci 0000:00:1d.2: BAR 4: reserving [io  0xfa00-0xfa1f flags 0x40101] (d=0, p=0)
[    0.428093] pci 0000:00:1d.7: BAR 0: reserving [mem 0xfdffe000-0xfdffe3ff flags 0x40200] (d=0, p=0)
[    0.428101] pci 0000:00:1f.2: BAR 0: reserving [io  0x01f0-0x01f7 flags 0x110] (d=0, p=0)
[    0.428104] pci 0000:00:1f.2: BAR 1: reserving [io  0x03f6 flags 0x110] (d=0, p=0)
[    0.428107] pci 0000:00:1f.2: BAR 2: reserving [io  0x0170-0x0177 flags 0x110] (d=0, p=0)
[    0.428110] pci 0000:00:1f.2: BAR 3: reserving [io  0x0376 flags 0x110] (d=0, p=0)
[    0.428113] pci 0000:00:1f.2: BAR 4: reserving [io  0xf900-0xf90f flags 0x40101] (d=0, p=0)
[    0.428116] pci 0000:00:1f.2: BAR 5: reserving [io  0xf800-0xf80f flags 0x40101] (d=0, p=0)
[    0.428120] pci 0000:00:1f.3: BAR 0: reserving [mem 0xfdffd000-0xfdffd0ff flags 0x140204] (d=0, p=0)
[    0.428124] pci 0000:00:1f.3: BAR 4: reserving [io  0x0500-0x051f flags 0x40101] (d=0, p=0)
[    0.428128] pci 0000:00:1f.5: BAR 0: reserving [io  0xf600-0xf607 flags 0x40101] (d=0, p=0)
[    0.428132] pci 0000:00:1f.5: BAR 1: reserving [io  0xf500-0xf503 flags 0x40101] (d=0, p=0)
[    0.428134] pci 0000:00:1f.5: BAR 2: reserving [io  0xf400-0xf407 flags 0x40101] (d=0, p=0)
[    0.428137] pci 0000:00:1f.5: BAR 3: reserving [io  0xf300-0xf303 flags 0x40101] (d=0, p=0)
[    0.428140] pci 0000:00:1f.5: BAR 4: reserving [io  0xf200-0xf20f flags 0x40101] (d=0, p=0)
[    0.428143] pci 0000:00:1f.5: BAR 5: reserving [io  0xf100-0xf10f flags 0x40101] (d=0, p=0)
[    0.428148] pci 0000:01:00.0: BAR 0: reserving [mem 0xfa000000-0xfaffffff flags 0x40200] (d=0, p=0)
[    0.428151] pci 0000:01:00.0: BAR 1: reserving [mem 0xe0000000-0xefffffff flags 0x14220c] (d=0, p=0)
[    0.428154] pci 0000:01:00.0: BAR 3: reserving [mem 0xf8000000-0xf9ffffff flags 0x140204] (d=0, p=0)
[    0.428157] pci 0000:01:00.0: BAR 5: reserving [io  0xbf00-0xbf7f flags 0x40101] (d=0, p=0)
[    0.428163] pci 0000:03:00.0: BAR 5: reserving [mem 0xfddfe000-0xfddfffff flags 0x40200] (d=0, p=0)
[    0.428171] pci 0000:04:00.0: BAR 0: reserving [io  0xde00-0xdeff flags 0x40101] (d=0, p=0)
[    0.428174] pci 0000:04:00.0: BAR 2: reserving [mem 0xfdeff000-0xfdefffff flags 0x14220c] (d=0, p=0)
[    0.428177] pci 0000:04:00.0: BAR 4: reserving [mem 0xfdee0000-0xfdeeffff flags 0x14220c] (d=0, p=0)
[    0.428182] pci 0000:05:00.0: BAR 0: reserving [io  0xce00-0xceff flags 0x40101] (d=0, p=0)
[    0.428185] pci 0000:05:00.0: BAR 1: reserving [mem 0xfdcff000-0xfdcff0ff flags 0x40200] (d=0, p=0)
[    0.428190] pci 0000:05:07.0: BAR 0: reserving [mem 0xfdcfe000-0xfdcfe7ff flags 0x40200] (d=0, p=0)
[    0.428193] pci 0000:05:07.0: BAR 1: reserving [mem 0xfdcf8000-0xfdcfbfff flags 0x40200] (d=0, p=0)
[    0.428234] pci 0000:03:00.1: BAR 0: reserving [io  0xef00-0xef07 flags 0x40101] (d=1, p=1)
[    0.428237] pci 0000:03:00.1: BAR 1: reserving [io  0xee00-0xee03 flags 0x40101] (d=1, p=1)
[    0.428240] pci 0000:03:00.1: BAR 2: reserving [io  0xed00-0xed07 flags 0x40101] (d=1, p=1)
[    0.428242] pci 0000:03:00.1: BAR 3: reserving [io  0xec00-0xec03 flags 0x40101] (d=1, p=1)
[    0.428245] pci 0000:03:00.1: BAR 4: reserving [io  0xeb00-0xeb0f flags 0x40101] (d=1, p=1)
[    0.428255] reserve RAM buffer: 000000000009f800 - 000000000009ffff 
[    0.428258] reserve RAM buffer: 00000000dfee0000 - 00000000dfffffff 
[    0.428278] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    0.428278] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.428278] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.444063] Switching to clocksource hpet
[    0.447908] Switched to NOHz mode on CPU #0
[    0.447949] Switched to NOHz mode on CPU #2
[    0.447953] Switched to NOHz mode on CPU #3
[    0.448028] Switched to NOHz mode on CPU #1
[    0.452061] pnp: PnP ACPI init
[    0.452077] ACPI: bus type pnp registered
[    0.452181] pnp 00:00: [bus 00-3f]
[    0.452184] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.452186] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.452188] pnp 00:00: [io  0x0d00-0xffff window]
[    0.452191] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.452193] pnp 00:00: [mem 0x000c0000-0x000dffff window]
[    0.452195] pnp 00:00: [mem 0xdff00000-0xfebfffff window]
[    0.452323] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.452423] pnp 00:01: [io  0x0010-0x001f]
[    0.452426] pnp 00:01: [io  0x0022-0x003f]
[    0.452428] pnp 00:01: [io  0x0044-0x005f]
[    0.452430] pnp 00:01: [io  0x0062-0x0063]
[    0.452432] pnp 00:01: [io  0x0065-0x006f]
[    0.452435] pnp 00:01: [io  0x0074-0x007f]
[    0.452437] pnp 00:01: [io  0x0091-0x0093]
[    0.452439] pnp 00:01: [io  0x00a2-0x00bf]
[    0.452441] pnp 00:01: [io  0x00e0-0x00ef]
[    0.452443] pnp 00:01: [io  0x04d0-0x04d1]
[    0.452445] pnp 00:01: [io  0x0290-0x029f]
[    0.452447] pnp 00:01: [io  0x0800-0x087f]
[    0.452449] pnp 00:01: [io  0x0290-0x0294]
[    0.452451] pnp 00:01: [io  0x0880-0x088f]
[    0.452596] system 00:01: [io  0x04d0-0x04d1] has been reserved
[    0.452599] system 00:01: [io  0x0290-0x029f] has been reserved
[    0.452602] system 00:01: [io  0x0800-0x087f] has been reserved
[    0.452605] system 00:01: [io  0x0290-0x0294] has been reserved
[    0.452607] system 00:01: [io  0x0880-0x088f] has been reserved
[    0.452611] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.452625] pnp 00:02: [dma 4]
[    0.452628] pnp 00:02: [io  0x0000-0x000f]
[    0.452629] pnp 00:02: [io  0x0080-0x0090]
[    0.452631] pnp 00:02: [io  0x0094-0x009f]
[    0.452633] pnp 00:02: [io  0x00c0-0x00df]
[    0.452715] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.452772] pnp 00:03: [irq 0 disabled]
[    0.452783] pnp 00:03: [irq 8]
[    0.452785] pnp 00:03: [mem 0xfed00000-0xfed003ff]
[    0.452874] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.452907] pnp 00:04: [io  0x0070-0x0073]
[    0.452994] pnp 00:04: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.453006] pnp 00:05: [io  0x0061]
[    0.453088] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.453100] pnp 00:06: [io  0x00f0-0x00ff]
[    0.453105] pnp 00:06: [irq 13]
[    0.453193] pnp 00:06: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.453323] pnp 00:07: [io  0x03f0-0x03f5]
[    0.453326] pnp 00:07: [io  0x03f7]
[    0.453331] pnp 00:07: [irq 6]
[    0.453333] pnp 00:07: [dma 2]
[    0.453436] pnp 00:07: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.453610] pnp 00:08: [io  0x03f8-0x03ff]
[    0.453617] pnp 00:08: [irq 4]
[    0.453731] pnp 00:08: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.453928] pnp 00:09: [io  0x0378-0x037f]
[    0.453933] pnp 00:09: [irq 7]
[    0.454044] pnp 00:09: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.454153] pnp 00:0a: [irq 12]
[    0.454241] pnp 00:0a: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.454269] pnp 00:0b: [io  0x0060]
[    0.454271] pnp 00:0b: [io  0x0064]
[    0.454276] pnp 00:0b: [irq 1]
[    0.454367] pnp 00:0b: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.454406] pnp 00:0c: [io  0x0400-0x04cf]
[    0.454409] pnp 00:0c: [io  0x04d2-0x04ff]
[    0.454525] system 00:0c: [io  0x0400-0x04cf] has been reserved
[    0.454528] system 00:0c: [io  0x04d2-0x04ff] has been reserved
[    0.454531] system 00:0c: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.454761] pnp 00:0d: [mem 0xf4000000-0xf7ffffff]
[    0.454898] system 00:0d: [mem 0xf4000000-0xf7ffffff] has been reserved
[    0.454901] system 00:0d: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.455085] pnp 00:0e: [mem 0x000ce000-0x000cffff]
[    0.455088] pnp 00:0e: [mem 0x000f0000-0x000f7fff]
[    0.455090] pnp 00:0e: [mem 0x000f8000-0x000fbfff]
[    0.455092] pnp 00:0e: [mem 0x000fc000-0x000fffff]
[    0.455094] pnp 00:0e: [mem 0xdfee0000-0xdfeeffff]
[    0.455097] pnp 00:0e: [mem 0x00000000-0x0009ffff]
[    0.455099] pnp 00:0e: [mem 0x00100000-0xdfedffff]
[    0.455101] pnp 00:0e: [mem 0xdfef0000-0xdfefffff]
[    0.455103] pnp 00:0e: [mem 0xfec00000-0xfec00fff]
[    0.455105] pnp 00:0e: [mem 0xfed10000-0xfed1dfff]
[    0.455107] pnp 00:0e: [mem 0xfed20000-0xfed8ffff]
[    0.455109] pnp 00:0e: [mem 0xfee00000-0xfee00fff]
[    0.455111] pnp 00:0e: [mem 0xffb00000-0xffb7ffff]
[    0.455113] pnp 00:0e: [mem 0xfff00000-0xffffffff]
[    0.455115] pnp 00:0e: [mem 0x000e0000-0x000effff]
[    0.455258] system 00:0e: [mem 0x000ce000-0x000cffff] has been reserved
[    0.455262] system 00:0e: [mem 0x000f0000-0x000f7fff] could not be reserved
[    0.455265] system 00:0e: [mem 0x000f8000-0x000fbfff] could not be reserved
[    0.455268] system 00:0e: [mem 0x000fc000-0x000fffff] could not be reserved
[    0.455271] system 00:0e: [mem 0xdfee0000-0xdfeeffff] could not be reserved
[    0.455274] system 00:0e: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.455277] system 00:0e: [mem 0x00100000-0xdfedffff] could not be reserved
[    0.455280] system 00:0e: [mem 0xdfef0000-0xdfefffff] has been reserved
[    0.455283] system 00:0e: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.455285] system 00:0e: [mem 0xfed10000-0xfed1dfff] has been reserved
[    0.455288] system 00:0e: [mem 0xfed20000-0xfed8ffff] has been reserved
[    0.455291] system 00:0e: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.455294] system 00:0e: [mem 0xffb00000-0xffb7ffff] has been reserved
[    0.455297] system 00:0e: [mem 0xfff00000-0xffffffff] has been reserved
[    0.455300] system 00:0e: [mem 0x000e0000-0x000effff] has been reserved
[    0.455303] system 00:0e: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.455326] pnp 00:0f: [mem 0xffb80000-0xffbfffff]
[    0.455430] pnp 00:0f: Plug and Play ACPI device, IDs INT0800 (active)
[    0.455437] pnp: PnP ACPI: found 16 devices
[    0.455438] ACPI: ACPI bus type pnp unregistered
[    0.466209] pci 0000:00:1c.0: BAR 14: assigned [mem 0xf0000000-0xf01fffff]
[    0.466213] pci 0000:00:1c.0: BAR 15: assigned [mem 0xf0200000-0xf03fffff 64bit pref]
[    0.466217] pci 0000:00:1c.3: BAR 15: assigned [mem 0xf0400000-0xf05fffff 64bit pref]
[    0.466221] pci 0000:00:1e.0: BAR 15: assigned [mem 0xdff00000-0xdfffffff pref]
[    0.466225] pci 0000:00:1c.0: BAR 13: assigned [io  0x1000-0x1fff]
[    0.466229] pci 0000:01:00.0: BAR 6: assigned [mem 0xfb000000-0xfb07ffff pref]
[    0.466232] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.466235] pci 0000:00:01.0:   bridge window [io  0xb000-0xbfff]
[    0.466238] pci 0000:00:01.0:   bridge window [mem 0xf8000000-0xfbffffff]
[    0.466242] pci 0000:00:01.0:   bridge window [mem 0xe0000000-0xefffffff 64bit pref]
[    0.466246] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.466249] pci 0000:00:1c.0:   bridge window [io  0x1000-0x1fff]
[    0.466253] pci 0000:00:1c.0:   bridge window [mem 0xf0000000-0xf01fffff]
[    0.466257] pci 0000:00:1c.0:   bridge window [mem 0xf0200000-0xf03fffff 64bit pref]
[    0.466263] pci 0000:00:1c.3: PCI bridge to [bus 03-03]
[    0.466266] pci 0000:00:1c.3:   bridge window [io  0xe000-0xefff]
[    0.466270] pci 0000:00:1c.3:   bridge window [mem 0xfdd00000-0xfddfffff]
[    0.466274] pci 0000:00:1c.3:   bridge window [mem 0xf0400000-0xf05fffff 64bit pref]
[    0.466281] pci 0000:04:00.0: BAR 6: assigned [mem 0xfde00000-0xfde0ffff pref]
[    0.466283] pci 0000:00:1c.4: PCI bridge to [bus 04-04]
[    0.466286] pci 0000:00:1c.4:   bridge window [io  0xd000-0xdfff]
[    0.466290] pci 0000:00:1c.4:   bridge window [mem 0xfdb00000-0xfdbfffff]
[    0.466294] pci 0000:00:1c.4:   bridge window [mem 0xfde00000-0xfdefffff 64bit pref]
[    0.466301] pci 0000:05:00.0: BAR 6: assigned [mem 0xdff00000-0xdff0ffff pref]
[    0.466303] pci 0000:00:1e.0: PCI bridge to [bus 05-05]
[    0.466306] pci 0000:00:1e.0:   bridge window [io  0xc000-0xcfff]
[    0.466310] pci 0000:00:1e.0:   bridge window [mem 0xfdc00000-0xfdcfffff]
[    0.466314] pci 0000:00:1e.0:   bridge window [mem 0xdff00000-0xdfffffff pref]
[    0.466331] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.466335] pci 0000:00:01.0: setting latency timer to 64
[    0.466341] pci 0000:00:1c.0: enabling device (0000 -> 0003)
[    0.466345] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.466348] pci 0000:00:1c.0: enabling bus mastering
[    0.466351] pci 0000:00:1c.0: setting latency timer to 64
[    0.466363] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    0.466367] pci 0000:00:1c.3: setting latency timer to 64
[    0.466372] pci 0000:00:1c.4: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.466376] pci 0000:00:1c.4: setting latency timer to 64
[    0.466382] pci 0000:00:1e.0: setting latency timer to 64
[    0.466386] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.466388] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.466390] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.466392] pci_bus 0000:00: resource 7 [mem 0x000c0000-0x000dffff]
[    0.466395] pci_bus 0000:00: resource 8 [mem 0xdff00000-0xfebfffff]
[    0.466397] pci_bus 0000:01: resource 0 [io  0xb000-0xbfff]
[    0.466399] pci_bus 0000:01: resource 1 [mem 0xf8000000-0xfbffffff]
[    0.466402] pci_bus 0000:01: resource 2 [mem 0xe0000000-0xefffffff 64bit pref]
[    0.466404] pci_bus 0000:02: resource 0 [io  0x1000-0x1fff]
[    0.466406] pci_bus 0000:02: resource 1 [mem 0xf0000000-0xf01fffff]
[    0.466409] pci_bus 0000:02: resource 2 [mem 0xf0200000-0xf03fffff 64bit pref]
[    0.466411] pci_bus 0000:03: resource 0 [io  0xe000-0xefff]
[    0.466413] pci_bus 0000:03: resource 1 [mem 0xfdd00000-0xfddfffff]
[    0.466415] pci_bus 0000:03: resource 2 [mem 0xf0400000-0xf05fffff 64bit pref]
[    0.466418] pci_bus 0000:04: resource 0 [io  0xd000-0xdfff]
[    0.466420] pci_bus 0000:04: resource 1 [mem 0xfdb00000-0xfdbfffff]
[    0.466422] pci_bus 0000:04: resource 2 [mem 0xfde00000-0xfdefffff 64bit pref]
[    0.466425] pci_bus 0000:05: resource 0 [io  0xc000-0xcfff]
[    0.466427] pci_bus 0000:05: resource 1 [mem 0xfdc00000-0xfdcfffff]
[    0.466429] pci_bus 0000:05: resource 2 [mem 0xdff00000-0xdfffffff pref]
[    0.466431] pci_bus 0000:05: resource 4 [io  0x0000-0x0cf7]
[    0.466433] pci_bus 0000:05: resource 5 [io  0x0d00-0xffff]
[    0.466435] pci_bus 0000:05: resource 6 [mem 0x000a0000-0x000bffff]
[    0.466438] pci_bus 0000:05: resource 7 [mem 0x000c0000-0x000dffff]
[    0.466440] pci_bus 0000:05: resource 8 [mem 0xdff00000-0xfebfffff]
[    0.466571] NET: Registered protocol family 2
[    0.466756] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.467902] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.470690] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.471030] TCP: Hash tables configured (established 524288 bind 65536)
[    0.471033] TCP reno registered
[    0.471044] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.471075] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.471286] NET: Registered protocol family 1
[    0.471304] pci 0000:00:00.0: calling quirk_e100_interrupt+0x0/0x145
[    0.471308] pci 0000:00:00.0: calling quirk_cardbus_legacy+0x0/0x22
[    0.471312] pci 0000:00:00.0: calling quirk_usb_early_handoff+0x0/0x4e9
[    0.471315] pci 0000:00:00.0: calling pci_fixup_video+0x0/0xad
[    0.471321] pci 0000:00:01.0: calling quirk_e100_interrupt+0x0/0x145
[    0.471324] pci 0000:00:01.0: calling quirk_cardbus_legacy+0x0/0x22
[    0.471327] pci 0000:00:01.0: calling quirk_usb_early_handoff+0x0/0x4e9
[    0.471330] pci 0000:00:01.0: calling pci_fixup_video+0x0/0xad
[    0.471334] pci 0000:00:1a.0: calling quirk_e100_interrupt+0x0/0x145
[    0.471337] pci 0000:00:1a.0: calling quirk_cardbus_legacy+0x0/0x22
[    0.471340] pci 0000:00:1a.0: calling quirk_usb_early_handoff+0x0/0x4e9
[    0.471345] pci 0000:00:1a.0: uhci_check_and_reset_hc: legsup = 0x0f10
[    0.471347] pci 0000:00:1a.0: Performing full reset
[    0.471359] pci 0000:00:1a.0: calling pci_fixup_video+0x0/0xad
[    0.471364] pci 0000:00:1a.1: calling quirk_e100_interrupt+0x0/0x145
[    0.471367] pci 0000:00:1a.1: calling quirk_cardbus_legacy+0x0/0x22
[    0.471370] pci 0000:00:1a.1: calling quirk_usb_early_handoff+0x0/0x4e9
[    0.471375] pci 0000:00:1a.1: uhci_check_and_reset_hc: legsup = 0x0010
[    0.471376] pci 0000:00:1a.1: Performing full reset
[    0.471388] pci 0000:00:1a.1: calling pci_fixup_video+0x0/0xad
[    0.471393] pci 0000:00:1a.2: calling quirk_e100_interrupt+0x0/0x145
[    0.471396] pci 0000:00:1a.2: calling quirk_cardbus_legacy+0x0/0x22
[    0.471399] pci 0000:00:1a.2: calling quirk_usb_early_handoff+0x0/0x4e9
[    0.471403] pci 0000:00:1a.2: uhci_check_and_reset_hc: legsup = 0x0010
[    0.471405] pci 0000:00:1a.2: Performing full reset
[    0.471417] pci 0000:00:1a.2: calling pci_fixup_video+0x0/0xad
[    0.471422] pci 0000:00:1a.7: calling quirk_e100_interrupt+0x0/0x145
[    0.471425] pci 0000:00:1a.7: calling quirk_cardbus_legacy+0x0/0x22
[    0.471428] pci 0000:00:1a.7: calling quirk_usb_early_handoff+0x0/0x4e9
[    0.471448] pci 0000:00:1a.7: EHCI: BIOS handoff
[    0.484024] pci 0000:00:1a.7: calling pci_fixup_video+0x0/0xad
[    0.484031] pci 0000:00:1b.0: calling quirk_e100_interrupt+0x0/0x145
[    0.484034] pci 0000:00:1b.0: calling quirk_cardbus_legacy+0x0/0x22
[    0.484038] pci 0000:00:1b.0: calling quirk_usb_early_handoff+0x0/0x4e9
[    0.484041] pci 0000:00:1b.0: calling pci_fixup_video+0x0/0xad
[    0.484047] pci 0000:00:1c.0: calling quirk_e100_interrupt+0x0/0x145
[    0.484050] pci 0000:00:1c.0: calling quirk_cardbus_legacy+0x0/0x22
[    0.484054] pci 0000:00:1c.0: calling quirk_usb_early_handoff+0x0/0x4e9
[    0.484057] pci 0000:00:1c.0: calling pci_fixup_video+0x0/0xad
[    0.484063] pci 0000:00:1c.3: calling quirk_e100_interrupt+0x0/0x145
[    0.484066] pci 0000:00:1c.3: calling quirk_cardbus_legacy+0x0/0x22
[    0.484069] pci 0000:00:1c.3: calling quirk_usb_early_handoff+0x0/0x4e9
[    0.484073] pci 0000:00:1c.3: calling pci_fixup_video+0x0/0xad
[    0.484078] pci 0000:00:1c.4: calling quirk_e100_interrupt+0x0/0x145
[    0.484082] pci 0000:00:1c.4: calling quirk_cardbus_legacy+0x0/0x22
[    0.484085] pci 0000:00:1c.4: calling quirk_usb_early_handoff+0x0/0x4e9
[    0.484089] pci 0000:00:1c.4: calling pci_fixup_video+0x0/0xad
[    0.484094] pci 0000:00:1d.0: calling quirk_e100_interrupt+0x0/0x145
[    0.484097] pci 0000:00:1d.0: calling quirk_cardbus_legacy+0x0/0x22
[    0.484106] pci 0000:00:1d.0: calling quirk_usb_early_handoff+0x0/0x4e9
[    0.484112] pci 0000:00:1d.0: uhci_check_and_reset_hc: legsup = 0x0f30
[    0.484114] pci 0000:00:1d.0: Performing full reset
[    0.484130] pci 0000:00:1d.0: calling pci_fixup_video+0x0/0xad
[    0.484135] pci 0000:00:1d.1: calling quirk_e100_interrupt+0x0/0x145
[    0.484138] pci 0000:00:1d.1: calling quirk_cardbus_legacy+0x0/0x22
[    0.484141] pci 0000:00:1d.1: calling quirk_usb_early_handoff+0x0/0x4e9
[    0.484145] pci 0000:00:1d.1: uhci_check_and_reset_hc: legsup = 0x0010
[    0.484147] pci 0000:00:1d.1: Performing full reset
[    0.484159] pci 0000:00:1d.1: calling pci_fixup_video+0x0/0xad
[    0.484164] pci 0000:00:1d.2: calling quirk_e100_interrupt+0x0/0x145
[    0.484167] pci 0000:00:1d.2: calling quirk_cardbus_legacy+0x0/0x22
[    0.484170] pci 0000:00:1d.2: calling quirk_usb_early_handoff+0x0/0x4e9
[    0.484174] pci 0000:00:1d.2: uhci_check_and_reset_hc: legsup = 0x0010
[    0.484176] pci 0000:00:1d.2: Performing full reset
[    0.484187] pci 0000:00:1d.2: calling pci_fixup_video+0x0/0xad
[    0.484192] pci 0000:00:1d.7: calling quirk_e100_interrupt+0x0/0x145
[    0.484195] pci 0000:00:1d.7: calling quirk_cardbus_legacy+0x0/0x22
[    0.484198] pci 0000:00:1d.7: calling quirk_usb_early_handoff+0x0/0x4e9
[    0.484224] pci 0000:00:1d.7: EHCI: BIOS handoff
[    0.500017] pci 0000:00:1d.7: calling pci_fixup_video+0x0/0xad
[    0.500023] pci 0000:00:1e.0: calling quirk_e100_interrupt+0x0/0x145
[    0.500027] pci 0000:00:1e.0: calling quirk_cardbus_legacy+0x0/0x22
[    0.500031] pci 0000:00:1e.0: calling quirk_usb_early_handoff+0x0/0x4e9
[    0.500034] pci 0000:00:1e.0: calling pci_fixup_video+0x0/0xad
[    0.500039] pci 0000:00:1f.0: calling quirk_e100_interrupt+0x0/0x145
[    0.500043] pci 0000:00:1f.0: calling quirk_cardbus_legacy+0x0/0x22
[    0.500046] pci 0000:00:1f.0: calling quirk_usb_early_handoff+0x0/0x4e9
[    0.500050] pci 0000:00:1f.0: calling pci_fixup_video+0x0/0xad
[    0.500055] pci 0000:00:1f.2: calling quirk_e100_interrupt+0x0/0x145
[    0.500059] pci 0000:00:1f.2: calling quirk_cardbus_legacy+0x0/0x22
[    0.500062] pci 0000:00:1f.2: calling quirk_usb_early_handoff+0x0/0x4e9
[    0.500066] pci 0000:00:1f.2: calling pci_fixup_video+0x0/0xad
[    0.500071] pci 0000:00:1f.3: calling quirk_e100_interrupt+0x0/0x145
[    0.500075] pci 0000:00:1f.3: calling quirk_cardbus_legacy+0x0/0x22
[    0.500078] pci 0000:00:1f.3: calling quirk_usb_early_handoff+0x0/0x4e9
[    0.500081] pci 0000:00:1f.3: calling pci_fixup_video+0x0/0xad
[    0.500087] pci 0000:00:1f.5: calling quirk_e100_interrupt+0x0/0x145
[    0.500090] pci 0000:00:1f.5: calling quirk_cardbus_legacy+0x0/0x22
[    0.500094] pci 0000:00:1f.5: calling quirk_usb_early_handoff+0x0/0x4e9
[    0.500097] pci 0000:00:1f.5: calling pci_fixup_video+0x0/0xad
[    0.500112] pci 0000:01:00.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0xd
[    0.500129] pci 0000:01:00.0: calling quirk_cardbus_legacy+0x0/0x22
[    0.500132] pci 0000:01:00.0: calling quirk_usb_early_handoff+0x0/0x4e9
[    0.500135] pci 0000:01:00.0: calling pci_fixup_video+0x0/0xad
[    0.500138] pci 0000:01:00.0: Boot video device
[    0.500143] pci 0000:03:00.0: calling quirk_cardbus_legacy+0x0/0x22
[    0.500146] pci 0000:03:00.0: calling quirk_usb_early_handoff+0x0/0x4e9
[    0.500149] pci 0000:03:00.0: calling pci_fixup_video+0x0/0xad
[    0.500154] pci 0000:03:00.1: calling quirk_cardbus_legacy+0x0/0x22
[    0.500157] pci 0000:03:00.1: calling quirk_usb_early_handoff+0x0/0x4e9
[    0.500160] pci 0000:03:00.1: calling pci_fixup_video+0x0/0xad
[    0.500166] pci 0000:04:00.0: calling quirk_cardbus_legacy+0x0/0x22
[    0.500169] pci 0000:04:00.0: calling quirk_usb_early_handoff+0x0/0x4e9
[    0.500171] pci 0000:04:00.0: calling pci_fixup_video+0x0/0xad
[    0.500177] pci 0000:05:00.0: calling quirk_cardbus_legacy+0x0/0x22
[    0.500180] pci 0000:05:00.0: calling quirk_usb_early_handoff+0x0/0x4e9
[    0.500183] pci 0000:05:00.0: calling pci_fixup_video+0x0/0xad
[    0.500188] pci 0000:05:07.0: calling quirk_cardbus_legacy+0x0/0x22
[    0.500190] pci 0000:05:07.0: calling quirk_usb_early_handoff+0x0/0x4e9
[    0.500193] pci 0000:05:07.0: calling pci_fixup_video+0x0/0xad
[    0.500197] PCI: CLS 4 bytes, default 64
[    0.500253] Trying to unpack rootfs image as initramfs...
[    0.742210] Freeing initrd memory: 10856k freed
[    0.753267] DMA-API: preallocated 32768 debug entries
[    0.753270] DMA-API: debugging enabled by kernel config
[    0.753274] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.753277] Placing 64MB software IO TLB between ffff8800dbeda000 - ffff8800dfeda000
[    0.753279] software IO TLB at phys 0xdbeda000 - 0xdfeda000
[    0.755738] audit: initializing netlink socket (disabled)
[    0.755757] type=2000 audit(1300544792.748:1): initialized
[    0.756498] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.756914] VFS: Disk quotas dquot_6.5.2
[    0.756965] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.757053] msgmni has been set to 7925
[    0.757571] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.757575] io scheduler noop registered
[    0.757577] io scheduler deadline registered
[    0.757615] io scheduler cfq registered (default)
[    0.757929] pcieport 0000:00:01.0: setting latency timer to 64
[    0.757959] pcieport 0000:00:01.0: irq 40 for MSI/MSI-X
[    0.758062] pcieport 0000:00:1c.0: setting latency timer to 64
[    0.758096] pcieport 0000:00:1c.0: irq 41 for MSI/MSI-X
[    0.758207] pcieport 0000:00:1c.3: setting latency timer to 64
[    0.758241] pcieport 0000:00:1c.3: irq 42 for MSI/MSI-X
[    0.758349] pcieport 0000:00:1c.4: setting latency timer to 64
[    0.758383] pcieport 0000:00:1c.4: irq 43 for MSI/MSI-X
[    0.759394] efifb: probing for efifb
[    0.759764] efifb: framebuffer at 0xf9000000, mapped to 0xffffc90005100000, using 3072k, total 3072k
[    0.759766] efifb: mode is 1024x768x32, linelength=4096, pages=1
[    0.759768] efifb: scrolling: redraw
[    0.759771] efifb: Truecolor: size=8:8:8:8, shift=24:16:8:0
[    0.759870] fbcon: EFI VGA (fb0) is primary device
[    0.781560] Console: switching to colour frame buffer device 128x48
[    0.801580] fb0: EFI VGA frame buffer device
[    0.801583] intel_idle: MWAIT substates: 0x20
[    0.801585] intel_idle: does not run on family 6 model 23
[    0.801710] ERST: Table is not found!
[    0.847775] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.867643] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.128683] 00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.192649] Linux agpgart interface v0.103
[    1.195769] brd: module loaded
[    1.196147] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    1.196577] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.196633] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.197047] mousedev: PS/2 mouse device common for all mice
[    1.197172] rtc_cmos 00:04: RTC can wake from S4
[    1.214783] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    1.224069] rtc (null): alarm rollover: day
[    1.224211] rtc_cmos: dev (254:0)
[    1.224219] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
[    1.224243] rtc0: alarms up to one month, 242 bytes nvram, hpet irqs
[    1.224331] cpuidle: using governor ladder
[    1.224333] cpuidle: using governor menu
[    1.224643] TCP cubic registered
[    1.224645] NET: Registered protocol family 17
[    1.224650] Registering the dns_resolver key type
[    1.225011] registered taskstats version 1
[    1.225013] IMA: No TPM chip found, activating TPM-bypass!
[    1.225393] rtc_cmos 00:04: setting system clock to 2011-03-19 14:26:33 UTC (1300544793)
[    1.226911] Freeing unused kernel memory: 584k freed
[    1.227026] Write protecting the kernel read-only data: 6144k
[    1.230668] Freeing unused kernel memory: 872k freed
[    1.232076] Freeing unused kernel memory: 292k freed
[    1.249287] udev[1058]: starting version 164
[    1.297002] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.297007] ehci_hcd: block sizes: qh 104 qtd 96 itd 192 sitd 96
[    1.297069] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    1.297107] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    1.297111] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    1.297136] drivers/usb/core/inode.c: creating file 'devices'
[    1.297141] drivers/usb/core/inode.c: creating file '001'
[    1.297319] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    1.332085] ehci_hcd 0000:00:1a.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[    1.332092] ehci_hcd 0000:00:1a.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr hw prefetch
[    1.332167] ehci_hcd 0000:00:1a.7: reset command 0080012 (park)=0 ithresh=8 Periodic period=1024 Reset HALT
[    1.336649] ehci_hcd 0000:00:1a.7: Enabling legacy PCI PM
[    1.336672] ehci_hcd 0000:00:1a.7: cache line size of 4 is not supported
[    1.336675] ehci_hcd 0000:00:1a.7: supports USB remote wakeup
[    1.336699] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xfdfff000
[    1.336707] ehci_hcd 0000:00:1a.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    1.340604] ehci_hcd 0000:00:1a.7: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
[    1.352038] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    1.352072] usb usb1: default language 0x0409
[    1.352080] usb usb1: udev 1, busnum 1, minor = 0
[    1.352082] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    1.352085] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.352088] usb usb1: Product: EHCI Host Controller
[    1.352089] usb usb1: Manufacturer: Linux 2.6.38-git3 ehci_hcd
[    1.352091] usb usb1: SerialNumber: 0000:00:1a.7
[    1.352236] usb usb1: usb_probe_device
[    1.352239] usb usb1: configuration #1 chosen from 1 choice
[    1.352247] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    1.352270] hub 1-0:1.0: usb_probe_interface
[    1.352272] hub 1-0:1.0: usb_probe_interface - got id
[    1.352274] hub 1-0:1.0: USB hub found
[    1.352279] hub 1-0:1.0: 6 ports detected
[    1.352281] hub 1-0:1.0: standalone hub
[    1.352283] hub 1-0:1.0: no power switching (usb 1.0)
[    1.352285] hub 1-0:1.0: individual port over-current protection
[    1.352287] hub 1-0:1.0: power on to power good time: 20ms
[    1.352292] hub 1-0:1.0: local power source is good
[    1.352294] hub 1-0:1.0: trying to enable port power on non-switchable hub
[    1.352357] drivers/usb/core/inode.c: creating file '001'
[    1.352428] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    1.352457] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    1.352461] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    1.352467] drivers/usb/core/inode.c: creating file '002'
[    1.352531] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    1.360791] Floppy drive(s): fd0 is 1.44M
[    1.362326] uhci_hcd: USB Universal Host Controller Interface driver
[    1.364524] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    1.364548] r8169 0000:04:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.364559] r8169 0000:04:00.0: enabling Mem-Wr-Inval
[    1.364604] r8169 0000:04:00.0: setting latency timer to 64
[    1.364658] r8169 0000:04:00.0: irq 44 for MSI/MSI-X
[    1.364923] r8169 0000:04:00.0: eth0: RTL8168c/8111c at 0xffffc9000066c000, 00:1f:d0:9a:d6:63, XID 1c4000c0 IRQ 44
[    1.364956] Uniform Multi-Platform E-IDE driver
[    1.365684] jmicron 0000:03:00.1: IDE controller (0x197b:0x2363 rev 0x02)
[    1.365696] JMicron IDE 0000:03:00.1: enabling device (0000 -> 0001)
[    1.365704] JMicron IDE 0000:03:00.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    1.365723] jmicron 0000:03:00.1: 100% native mode on irq 16
[    1.365731] JMicron IDE 0000:03:00.1: enabling bus mastering
[    1.365737] JMicron IDE 0000:03:00.1: setting latency timer to 64
[    1.365742]     ide0: BM-DMA at 0xeb00-0xeb07
[    1.365764]     ide1: BM-DMA at 0xeb08-0xeb0f
[    1.365780] Probing IDE interface ide0...
[    1.372070] ehci_hcd 0000:00:1d.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[    1.372075] ehci_hcd 0000:00:1d.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr hw prefetch
[    1.372135] ehci_hcd 0000:00:1d.7: reset command 0080012 (park)=0 ithresh=8 Periodic period=1024 Reset HALT
[    1.380039] ehci_hcd 0000:00:1d.7: Enabling legacy PCI PM
[    1.380048] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    1.380078] ehci_hcd 0000:00:1d.7: cache line size of 4 is not supported
[    1.380080] ehci_hcd 0000:00:1d.7: supports USB remote wakeup
[    1.380085] r8169 0000:05:00.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    1.380092] r8169 0000:05:00.0: enabling Mem-Wr-Inval
[    1.380108] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfdffe000
[    1.380116] ehci_hcd 0000:00:1d.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    1.380127] r8169 0000:05:00.0: (unregistered net_device): no PCI Express capability
[    1.380392] r8169 0000:05:00.0: eth1: RTL8169sb/8110sb at 0xffffc9000065e000, 00:1f:1f:07:b0:bf, XID 10000000 IRQ 20
[    1.381729] SCSI subsystem initialized
[    1.383754] FDC 0 is a post-1991 82077
[    1.383991] ehci_hcd 0000:00:1d.7: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
[    1.396022] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    1.396059] usb usb2: default language 0x0409
[    1.396067] usb usb2: udev 1, busnum 2, minor = 128
[    1.396070] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    1.396072] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.396074] usb usb2: Product: EHCI Host Controller
[    1.396076] usb usb2: Manufacturer: Linux 2.6.38-git3 ehci_hcd
[    1.396078] usb usb2: SerialNumber: 0000:00:1d.7
[    1.396218] usb usb2: usb_probe_device
[    1.396221] usb usb2: configuration #1 chosen from 1 choice
[    1.396229] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[    1.396251] hub 2-0:1.0: usb_probe_interface
[    1.396253] hub 2-0:1.0: usb_probe_interface - got id
[    1.396256] hub 2-0:1.0: USB hub found
[    1.396261] hub 2-0:1.0: 6 ports detected
[    1.396263] hub 2-0:1.0: standalone hub
[    1.396265] hub 2-0:1.0: no power switching (usb 1.0)
[    1.396267] hub 2-0:1.0: individual port over-current protection
[    1.396269] hub 2-0:1.0: power on to power good time: 20ms
[    1.396274] hub 2-0:1.0: local power source is good
[    1.396276] hub 2-0:1.0: trying to enable port power on non-switchable hub
[    1.396331] drivers/usb/core/inode.c: creating file '001'
[    1.399595] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.399607] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    1.399611] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    1.399619] drivers/usb/core/inode.c: creating file '003'
[    1.399742] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    1.400886] libata version 3.00 loaded.
[    1.428027] uhci_hcd 0000:00:1a.0: detected 2 ports
[    1.428034] uhci_hcd 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x0000
[    1.428037] uhci_hcd 0000:00:1a.0: Performing full reset
[    1.428073] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000ff00
[    1.428161] usb usb3: default language 0x0409
[    1.428168] usb usb3: udev 1, busnum 3, minor = 256
[    1.428170] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    1.428173] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.428175] usb usb3: Product: UHCI Host Controller
[    1.428177] usb usb3: Manufacturer: Linux 2.6.38-git3 uhci_hcd
[    1.428179] usb usb3: SerialNumber: 0000:00:1a.0
[    1.428321] usb usb3: usb_probe_device
[    1.428324] usb usb3: configuration #1 chosen from 1 choice
[    1.428332] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[    1.428354] hub 3-0:1.0: usb_probe_interface
[    1.428356] hub 3-0:1.0: usb_probe_interface - got id
[    1.428359] hub 3-0:1.0: USB hub found
[    1.428364] hub 3-0:1.0: 2 ports detected
[    1.428366] hub 3-0:1.0: standalone hub
[    1.428368] hub 3-0:1.0: no power switching (usb 1.0)
[    1.428369] hub 3-0:1.0: individual port over-current protection
[    1.428372] hub 3-0:1.0: power on to power good time: 2ms
[    1.428377] hub 3-0:1.0: local power source is good
[    1.428379] hub 3-0:1.0: trying to enable port power on non-switchable hub
[    1.428424] drivers/usb/core/inode.c: creating file '001'
[    1.428455] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.0
[    1.428498] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    1.428506] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    1.428509] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    1.428516] drivers/usb/core/inode.c: creating file '004'
[    1.428571] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    1.444024] uhci_hcd 0000:00:1a.1: detected 2 ports
[    1.444030] uhci_hcd 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x0000
[    1.444033] uhci_hcd 0000:00:1a.1: Performing full reset
[    1.444063] uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000fe00
[    1.444139] usb usb4: default language 0x0409
[    1.444146] usb usb4: udev 1, busnum 4, minor = 384
[    1.444148] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    1.444151] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.444153] usb usb4: Product: UHCI Host Controller
[    1.444155] usb usb4: Manufacturer: Linux 2.6.38-git3 uhci_hcd
[    1.444156] usb usb4: SerialNumber: 0000:00:1a.1
[    1.444274] usb usb4: usb_probe_device
[    1.444277] usb usb4: configuration #1 chosen from 1 choice
[    1.444285] usb usb4: adding 4-0:1.0 (config #1, interface 0)
[    1.444308] hub 4-0:1.0: usb_probe_interface
[    1.444310] hub 4-0:1.0: usb_probe_interface - got id
[    1.444313] hub 4-0:1.0: USB hub found
[    1.444318] hub 4-0:1.0: 2 ports detected
[    1.444320] hub 4-0:1.0: standalone hub
[    1.444321] hub 4-0:1.0: no power switching (usb 1.0)
[    1.444323] hub 4-0:1.0: individual port over-current protection
[    1.444325] hub 4-0:1.0: power on to power good time: 2ms
[    1.444330] hub 4-0:1.0: local power source is good
[    1.444332] hub 4-0:1.0: trying to enable port power on non-switchable hub
[    1.444375] drivers/usb/core/inode.c: creating file '001'
[    1.444406] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.1
[    1.444438] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    1.444445] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    1.444448] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    1.444453] drivers/usb/core/inode.c: creating file '005'
[    1.444508] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
[    1.452061] hub 1-0:1.0: state 7 ports 6 chg 0000 evt 0000
[    1.456032] uhci_hcd 0000:00:1a.2: detected 2 ports
[    1.456036] uhci_hcd 0000:00:1a.2: uhci_check_and_reset_hc: cmd = 0x0000
[    1.456039] uhci_hcd 0000:00:1a.2: Performing full reset
[    1.456057] uhci_hcd 0000:00:1a.2: irq 18, io base 0x0000fd00
[    1.456130] usb usb5: default language 0x0409
[    1.456137] usb usb5: udev 1, busnum 5, minor = 512
[    1.456139] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    1.456141] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.456143] usb usb5: Product: UHCI Host Controller
[    1.456145] usb usb5: Manufacturer: Linux 2.6.38-git3 uhci_hcd
[    1.456147] usb usb5: SerialNumber: 0000:00:1a.2
[    1.456227] usb usb5: usb_probe_device
[    1.456230] usb usb5: configuration #1 chosen from 1 choice
[    1.456236] usb usb5: adding 5-0:1.0 (config #1, interface 0)
[    1.456260] hub 5-0:1.0: usb_probe_interface
[    1.456262] hub 5-0:1.0: usb_probe_interface - got id
[    1.456264] hub 5-0:1.0: USB hub found
[    1.456269] hub 5-0:1.0: 2 ports detected
[    1.456270] hub 5-0:1.0: standalone hub
[    1.456272] hub 5-0:1.0: no power switching (usb 1.0)
[    1.456274] hub 5-0:1.0: individual port over-current protection
[    1.456276] hub 5-0:1.0: power on to power good time: 2ms
[    1.456281] hub 5-0:1.0: local power source is good
[    1.456283] hub 5-0:1.0: trying to enable port power on non-switchable hub
[    1.456323] drivers/usb/core/inode.c: creating file '001'
[    1.456351] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.2
[    1.456379] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    1.456385] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    1.456388] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    1.456393] drivers/usb/core/inode.c: creating file '006'
[    1.456441] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
[    1.480019] uhci_hcd 0000:00:1d.0: detected 2 ports
[    1.480023] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
[    1.480026] uhci_hcd 0000:00:1d.0: Performing full reset
[    1.480043] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000fc00
[    1.480106] usb usb6: default language 0x0409
[    1.480114] usb usb6: udev 1, busnum 6, minor = 640
[    1.480116] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    1.480119] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.480121] usb usb6: Product: UHCI Host Controller
[    1.480123] usb usb6: Manufacturer: Linux 2.6.38-git3 uhci_hcd
[    1.480124] usb usb6: SerialNumber: 0000:00:1d.0
[    1.480210] usb usb6: usb_probe_device
[    1.480213] usb usb6: configuration #1 chosen from 1 choice
[    1.480219] usb usb6: adding 6-0:1.0 (config #1, interface 0)
[    1.480243] hub 6-0:1.0: usb_probe_interface
[    1.480246] hub 6-0:1.0: usb_probe_interface - got id
[    1.480248] hub 6-0:1.0: USB hub found
[    1.480253] hub 6-0:1.0: 2 ports detected
[    1.480255] hub 6-0:1.0: standalone hub
[    1.480257] hub 6-0:1.0: no power switching (usb 1.0)
[    1.480259] hub 6-0:1.0: individual port over-current protection
[    1.480261] hub 6-0:1.0: power on to power good time: 2ms
[    1.480265] hub 6-0:1.0: local power source is good
[    1.480268] hub 6-0:1.0: trying to enable port power on non-switchable hub
[    1.480306] drivers/usb/core/inode.c: creating file '001'
[    1.480341] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.0
[    1.480362] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    1.480368] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    1.480371] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    1.480377] drivers/usb/core/inode.c: creating file '007'
[    1.480423] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
[    1.496041] hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0000
[    1.500029] uhci_hcd 0000:00:1d.1: detected 2 ports
[    1.500034] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
[    1.500037] uhci_hcd 0000:00:1d.1: Performing full reset
[    1.500067] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000fb00
[    1.500143] usb usb7: default language 0x0409
[    1.500150] usb usb7: udev 1, busnum 7, minor = 768
[    1.500153] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    1.500155] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.500157] usb usb7: Product: UHCI Host Controller
[    1.500159] usb usb7: Manufacturer: Linux 2.6.38-git3 uhci_hcd
[    1.500161] usb usb7: SerialNumber: 0000:00:1d.1
[    1.500275] usb usb7: usb_probe_device
[    1.500277] usb usb7: configuration #1 chosen from 1 choice
[    1.500284] usb usb7: adding 7-0:1.0 (config #1, interface 0)
[    1.500306] hub 7-0:1.0: usb_probe_interface
[    1.500308] hub 7-0:1.0: usb_probe_interface - got id
[    1.500311] hub 7-0:1.0: USB hub found
[    1.500315] hub 7-0:1.0: 2 ports detected
[    1.500317] hub 7-0:1.0: standalone hub
[    1.500319] hub 7-0:1.0: no power switching (usb 1.0)
[    1.500321] hub 7-0:1.0: individual port over-current protection
[    1.500323] hub 7-0:1.0: power on to power good time: 2ms
[    1.500327] hub 7-0:1.0: local power source is good
[    1.500330] hub 7-0:1.0: trying to enable port power on non-switchable hub
[    1.500372] drivers/usb/core/inode.c: creating file '001'
[    1.500408] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.1
[    1.500432] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    1.500438] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    1.500441] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    1.500446] drivers/usb/core/inode.c: creating file '008'
[    1.500498] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
[    1.516023] uhci_hcd 0000:00:1d.2: detected 2 ports
[    1.516028] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
[    1.516030] uhci_hcd 0000:00:1d.2: Performing full reset
[    1.516050] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000fa00
[    1.516127] usb usb8: default language 0x0409
[    1.516134] usb usb8: udev 1, busnum 8, minor = 896
[    1.516136] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
[    1.516138] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.516141] usb usb8: Product: UHCI Host Controller
[    1.516142] usb usb8: Manufacturer: Linux 2.6.38-git3 uhci_hcd
[    1.516144] usb usb8: SerialNumber: 0000:00:1d.2
[    1.516226] usb usb8: usb_probe_device
[    1.516228] usb usb8: configuration #1 chosen from 1 choice
[    1.516235] usb usb8: adding 8-0:1.0 (config #1, interface 0)
[    1.516258] hub 8-0:1.0: usb_probe_interface
[    1.516260] hub 8-0:1.0: usb_probe_interface - got id
[    1.516263] hub 8-0:1.0: USB hub found
[    1.516267] hub 8-0:1.0: 2 ports detected
[    1.516269] hub 8-0:1.0: standalone hub
[    1.516270] hub 8-0:1.0: no power switching (usb 1.0)
[    1.516272] hub 8-0:1.0: individual port over-current protection
[    1.516274] hub 8-0:1.0: power on to power good time: 2ms
[    1.516279] hub 8-0:1.0: local power source is good
[    1.516281] hub 8-0:1.0: trying to enable port power on non-switchable hub
[    1.516323] drivers/usb/core/inode.c: creating file '001'
[    1.516356] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.2
[    1.528048] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    1.544031] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    1.556029] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    1.580044] hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    1.604049] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    1.616056] hub 8-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    1.752013] Refined TSC clocksource calibration: 2333.067 MHz.
[    1.752018] Switching to clocksource tsc
[    1.944009] ------------[ cut here ]------------
[    1.944016] WARNING: at kernel/irq/manage.c:412 __enable_irq+0x59/0x88()
[    1.944018] Hardware name: EP45-UD3
[    1.944020] Unbalanced enable for IRQ 16
[    1.944022] Modules linked in: ahci(+) libahci libata ide_pci_generic(+) scsi_mod jmicron(+) r8169 uhci_hcd floppy mii ide_core ehci_hcd
[    1.944036] Pid: 1116, comm: modprobe Not tainted 2.6.38-git3 #1
[    1.944038] Call Trace:
[    1.944043]  [<ffffffff8103f364>] ? warn_slowpath_common+0x80/0x98
[    1.944048]  [<ffffffff8103f410>] ? warn_slowpath_fmt+0x41/0x43
[    1.944053]  [<ffffffff8108ce03>] ? __enable_irq+0x59/0x88
[    1.944057]  [<ffffffff8108d35c>] ? enable_irq+0x57/0x70
[    1.944068]  [<ffffffffa00c8a14>] ? ide_probe_port+0x580/0x59f [ide_core]
[    1.944078]  [<ffffffffa00c8d7e>] ? ide_host_register+0x2ad/0x64c [ide_core]
[    1.944088]  [<ffffffffa00cd882>] ? ide_pci_init_two+0x58d/0x666 [ide_core]
[    1.944101]  [<ffffffff8119f2ee>] ? ida_get_new_above+0xfa/0x1b5
[    1.944106]  [<ffffffff81035619>] ? get_parent_ip+0x11/0x41
[    1.944110]  [<ffffffff81037b68>] ? sub_preempt_count+0x92/0xa6
[    1.944114]  [<ffffffff81035619>] ? get_parent_ip+0x11/0x41
[    1.944117]  [<ffffffff81035619>] ? get_parent_ip+0x11/0x41
[    1.944126]  [<ffffffffa00cd96c>] ? ide_pci_init_one+0x11/0x13 [ide_core]
[    1.944131]  [<ffffffffa00170ec>] ? jmicron_init_one+0x12/0x14 [jmicron]
[    1.944136]  [<ffffffff811c12fe>] ? local_pci_probe+0x48/0x91
[    1.944139]  [<ffffffff811c20e0>] ? pci_device_probe+0xc5/0xf5
[    1.944144]  [<ffffffff812476dd>] ? driver_sysfs_add+0x6b/0x90
[    1.944148]  [<ffffffff812478d3>] ? driver_probe_device+0x120/0x1fb
[    1.944151]  [<ffffffff81247a06>] ? __driver_attach+0x58/0x7c
[    1.944155]  [<ffffffff812479ae>] ? __driver_attach+0x0/0x7c
[    1.944158]  [<ffffffff81246dc5>] ? bus_for_each_dev+0x4e/0x83
[    1.944162]  [<ffffffff81247636>] ? driver_attach+0x19/0x1b
[    1.944165]  [<ffffffff8124729f>] ? bus_add_driver+0xce/0x21b
[    1.944169]  [<ffffffff81247f95>] ? driver_register+0x99/0x10a
[    1.944173]  [<ffffffff811c233e>] ? __pci_register_driver+0x53/0xc3
[    1.944177]  [<ffffffffa001a000>] ? jmicron_ide_init+0x0/0x20 [jmicron]
[    1.944182]  [<ffffffffa001a01e>] ? jmicron_ide_init+0x1e/0x20 [jmicron]
[    1.944186]  [<ffffffff81000210>] ? do_one_initcall+0x7a/0x134
[    1.944191]  [<ffffffff8107128d>] ? sys_init_module+0x9c/0x1db
[    1.944195]  [<ffffffff8131d852>] ? system_call_fastpath+0x16/0x1b
[    1.944199] ---[ end trace 05a95fe67ed8fdd9 ]---
[    1.944240] Probing IDE interface ide1...
[    2.512057] ide0 at 0xef00-0xef07,0xee02 on irq 16
[    2.512117] ide1 at 0xed00-0xed07,0xec02 on irq 16
[    2.512190] ahci 0000:03:00.0: version 3.0
[    2.512208] ahci 0000:03:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    2.528035] ahci 0000:03:00.0: AHCI 0001.0000 32 slots 2 ports 3 Gbps 0x3 impl SATA mode
[    2.528039] ahci 0000:03:00.0: flags: 64bit ncq pm led clo pmp pio slum part 
[    2.528045] ahci 0000:03:00.0: setting latency timer to 64
[    2.528386] scsi0 : ahci
[    2.528523] scsi1 : ahci
[    2.528630] ata1: SATA max UDMA/133 abar m8192@0xfddfe000 port 0xfddfe100 irq 19
[    2.528634] ata2: SATA max UDMA/133 abar m8192@0xfddfe000 port 0xfddfe180 irq 19
[    2.592106] ata_piix 0000:00:1f.2: version 2.13
[    2.592118] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    2.592123] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
[    2.592167] ata_piix 0000:00:1f.2: setting latency timer to 64
[    2.592477] scsi2 : ata_piix
[    2.592574] scsi3 : ata_piix
[    2.593113] ata3: SATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xf900 irq 14
[    2.593118] ata4: SATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xf908 irq 15
[    2.593148] ata_piix 0000:00:1f.5: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    2.593152] ata_piix 0000:00:1f.5: MAP [ P0 -- P1 -- ]
[    2.593192] ata_piix 0000:00:1f.5: setting latency timer to 64
[    2.593434] scsi4 : ata_piix
[    2.593526] scsi5 : ata_piix
[    2.593925] ata5: SATA max UDMA/133 cmd 0xf600 ctl 0xf500 bmdma 0xf200 irq 19
[    2.593929] ata6: SATA max UDMA/133 cmd 0xf400 ctl 0xf300 bmdma 0xf208 irq 19
[    2.632012] usb usb3: suspend_rh (auto-stop)
[    2.632032] usb usb4: suspend_rh (auto-stop)
[    2.632050] usb usb5: suspend_rh (auto-stop)
[    2.632068] usb usb6: suspend_rh (auto-stop)
[    2.632086] usb usb7: suspend_rh (auto-stop)
[    2.632115] usb usb8: suspend_rh (auto-stop)
[    2.848026] ata2: SATA link down (SStatus 0 SControl 300)
[    2.848066] ata1: SATA link down (SStatus 0 SControl 300)
[    2.922609] ata5: SATA link down (SStatus 0 SControl 300)
[    2.933217] ata6: SATA link down (SStatus 0 SControl 300)
[    3.388056] ata4.00: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    3.388069] ata4.01: SATA link down (SStatus 0 SControl 300)
[    3.388079] ata4.01: link offline, clearing class 3 to NONE
[    3.396072] ata3.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    3.396088] ata3.01: SATA link down (SStatus 0 SControl 300)
[    3.396184] ata4.00: ATAPI: ATAPI   iHAS222   8, 4L01, max UDMA/100
[    3.404372] ata3.00: HPA detected: current 1953523055, native 1953525168
[    3.404379] ata3.00: ATA-8: WDC WD1002FBYS-01A6B0, 03.00C05, max UDMA/133
[    3.404382] ata3.00: 1953523055 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    3.412141] ata4.00: configured for UDMA/100
[    3.420395] ata3.00: configured for UDMA/133
[    3.420516] scsi 2:0:0:0: Direct-Access     ATA      WDC WD1002FBYS-0 03.0 PQ: 0 ANSI: 5
[    3.421926] scsi 3:0:0:0: CD-ROM            ATAPI    iHAS222   8      4L01 PQ: 0 ANSI: 5
[    3.433146] sd 2:0:0:0: [sda] 1953523055 512-byte logical blocks: (1.00 TB/931 GiB)
[    3.433216] sd 2:0:0:0: [sda] Write Protect is off
[    3.433219] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.433247] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.436542] sr0: scsi3-mmc drive: 48x/12x writer dvd-ram cd/rw xa/form2 cdda tray
[    3.436546] cdrom: Uniform CD-ROM driver Revision: 3.20
[    3.436727] sr 3:0:0:0: Attached scsi CD-ROM sr0
[    3.471500]  sda: sda1 sda2 sda3
[    3.471802] sd 2:0:0:0: [sda] Attached SCSI disk
[    3.476847] sd 2:0:0:0: Attached scsi generic sg0 type 0
[    3.477041] sr 3:0:0:0: Attached scsi generic sg1 type 5
[    3.840497] PM: Starting manual resume from disk
[    3.880680] EXT4-fs (sda2): INFO: recovery required on readonly filesystem
[    3.880683] EXT4-fs (sda2): write access will be enabled during recovery
[    4.140377] EXT4-fs (sda2): recovery complete
[    4.140809] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null)
[    5.812599] udev[1363]: starting version 164
[    6.133532] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[    6.133541] ACPI: Power Button [PWRB]
[    6.133660] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    6.133666] ACPI: Power Button [PWRF]
[    6.201150] input: PC Speaker as /devices/platform/pcspkr/input/input3
[    6.234390] parport_pc 00:09: reported by Plug and Play ACPI
[    6.234433] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
[    6.356230] ACPI: acpi_idle registered with cpuidle
[    6.517295] i2c-core: driver [dummy] registered
[    6.703914] i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    6.703924] i801_smbus 0000:00:1f.3: SMBus using PCI Interrupt
[    6.703993] i2c i2c-0: adapter [SMBus I801 adapter at 0500] registered
[    6.979893] input: ImPS/2 Logitech Wheel Mouse as /devices/platform/i8042/serio1/input/input4
[    7.136588] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    7.136668] HDA Intel 0000:00:1b.0: irq 45 for MSI/MSI-X
[    7.136694] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    7.136698] ALSA sound/pci/hda/hda_intel.c:2535: chipset global capabilities = 0x4401
[    7.168011] ALSA sound/pci/hda/hda_intel.c:913: codec_mask = 0x4
[    7.168116] ALSA sound/pci/hda/hda_intel.c:1353: codec #2 probed OK
[    7.402822] ALSA sound/pci/hda/hda_codec.c:3726: hda_codec: model '6stack-dig' is selected for config 1458:a002 (Gigabyte P35 DS3R)
[    7.402832] ALSA sound/pci/hda/patch_realtek.c:1527: SKU: Nid=0x1d sku_cfg=0x4005e601
[    7.402836] ALSA sound/pci/hda/patch_realtek.c:1529: SKU: port_connectivity=0x1
[    7.402840] ALSA sound/pci/hda/patch_realtek.c:1530: SKU: enable_pcbeep=0x0
[    7.402845] ALSA sound/pci/hda/patch_realtek.c:1531: SKU: check_sum=0x00000005
[    7.402848] ALSA sound/pci/hda/patch_realtek.c:1532: SKU: customization=0x000000e6
[    7.402850] ALSA sound/pci/hda/patch_realtek.c:1533: SKU: external_amp=0x0
[    7.402854] ALSA sound/pci/hda/patch_realtek.c:1534: SKU: platform_type=0x0
[    7.402858] ALSA sound/pci/hda/patch_realtek.c:1535: SKU: swap=0x0
[    7.402861] ALSA sound/pci/hda/patch_realtek.c:1536: SKU: override=0x1
[    7.405344] ALSA sound/pci/hda/hda_codec.c:2164: Cannot find slave Headphone Playback Volume, skipped
[    7.405348] ALSA sound/pci/hda/hda_codec.c:2164: Cannot find slave Speaker Playback Volume, skipped
[    7.405351] ALSA sound/pci/hda/hda_codec.c:2164: Cannot find slave Mono Playback Volume, skipped
[    7.405354] ALSA sound/pci/hda/hda_codec.c:2164: Cannot find slave Line-Out Playback Volume, skipped
[    7.405357] ALSA sound/pci/hda/hda_codec.c:2164: Cannot find slave PCM Playback Volume, skipped
[    7.405369] ALSA sound/pci/hda/hda_codec.c:2164: Cannot find slave Speaker Playback Switch, skipped
[    7.405372] ALSA sound/pci/hda/hda_codec.c:2164: Cannot find slave Mono Playback Switch, skipped
[    7.405377] ALSA sound/pci/hda/hda_codec.c:2164: Cannot find slave Line-Out Playback Switch, skipped
[    7.405380] ALSA sound/pci/hda/hda_codec.c:2164: Cannot find slave PCM Playback Switch, skipped
[    7.620996] nvidia: module license 'NVIDIA' taints kernel.
[    7.621000] Disabling lock debugging due to kernel taint
[    8.543170] nvidia 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    8.543179] nvidia 0000:01:00.0: setting latency timer to 64
[    8.543184] vgaarb: device changed decodes: PCI:0000:01:00.0,olddecodes=io+mem,decodes=none:owns=io+mem
[    8.543325] NVRM: loading NVIDIA UNIX x86_64 Kernel Module  270.30  Fri Feb 25 14:34:55 PST 2011
[    9.067233] Adding 9462280k swap on /dev/sda3.  Priority:-1 extents:1 across:9462280k 
[    9.071548] EXT4-fs (sda2): re-mounted. Opts: (null)
[    9.226317] EXT4-fs (sda2): re-mounted. Opts: errors=remount-ro
[    9.326800] loop: module loaded
[    9.348058] it87: Found IT8718F chip at 0x290, revision 5
[    9.348066] it87: VID is disabled (pins used for GPIO)
[    9.348076] it87: Beeping is supported
[    9.855628] EXT3-fs: barriers not enabled
[    9.855857] kjournald starting.  Commit interval 5 seconds
[    9.856103] EXT3-fs (sda1): using internal journal
[    9.856107] EXT3-fs (sda1): mounted filesystem with writeback data mode
[   10.985868] fuse init (API version 7.16)
[   11.038643] r8169 0000:05:00.0: eth1: link down
[   11.504582] r8169 0000:04:00.0: eth0: link down
[   11.504588] r8169 0000:04:00.0: eth0: link down
[   12.578129] lp0: using parport0 (interrupt-driven).
[   12.578132] lp0: console ready
[   12.584120] ppdev: user-space parallel port driver
[   12.715114] r8169 0000:05:00.0: eth1: link up
[   13.537770] r8169 0000:04:00.0: eth0: link up
[   15.829179] Bluetooth: Core ver 2.15
[   15.829242] NET: Registered protocol family 31
[   15.829245] Bluetooth: HCI device and connection manager initialized
[   15.829250] Bluetooth: HCI socket layer initialized
[   15.980045] Bluetooth: L2CAP ver 2.15
[   15.980047] Bluetooth: L2CAP socket layer initialized
[   16.006369] Bluetooth: RFCOMM TTY layer initialized
[   16.006375] Bluetooth: RFCOMM socket layer initialized
[   16.006377] Bluetooth: RFCOMM ver 1.11
[   16.614037] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   16.614040] Bluetooth: BNEP filters: protocol multicast
[   16.730849] Bluetooth: SCO (Voice Link) ver 0.6
[   16.730851] Bluetooth: SCO socket layer initialized
[   51.179113] sshd (3149): /proc/3149/oom_adj is deprecated, please use /proc/3149/oom_score_adj instead.

--------------050603090107040209070909--

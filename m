Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030366Ab2CVFo6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 01:44:58 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36069 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754987Ab2CVFoy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 01:44:54 -0400
MIME-Version: 1.0
In-Reply-To: <4F6AAC57.3090507@gmail.com>
References: <CAMfrEMaV03CEZ-h7k9K78c8+T+AC47=QypnyhQG7LFgrQQ32tA@mail.gmail.com>
	<4F6AAC57.3090507@gmail.com>
Date: Thu, 22 Mar 2012 00:44:53 -0500
Message-ID: <CAMfrEMbUsdnQ3Roe89YaV5F2xhTwbgRhWcM9E1jizqUEbCi=QQ@mail.gmail.com>
Subject: Re: IDE DVD and CD drive seem to not work with Linux desktop 3.3.0-030300-generic
From: Chris Holland <bandidoirlandes@gmail.com>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: bandidoirlandes@gmail.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2012 at 11:36 PM, Robert Hancock <hancockrwd@gmail.com> wrote:
> On 03/21/2012 10:29 PM, Chris Holland wrote:
>>
>> Please cc me at: bandidoirlandes@gmail.com
>>
>> My optical drives are not working with 3.3 but they worked fine with
>> 3.3rc7
>> These are the kernels from http://kernel.ubuntu.com/~kernel-ppa/mainline/
>> Ubuntu 11.10
>>
>> Not working
>> Linux desktop 3.3.0-030300-generic #201203182135 SMP Mon Mar 19
>> 01:36:20 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux
>> cat /var/log/dmesg | egrep '(CD|DVD)'
>> [    0.000000]   CD000-EFFFF uncachable
>>
>> Working
>> Linux desktop 3.3.0-030300rc7-generic #201203101735 SMP Sat Mar 10
>> 22:36:28 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux
>> cat /var/log/dmesg | egrep '(CD|DVD)'
>> [    0.000000]   CD000-EFFFF uncachable
>> [    0.092676] ACPI Warning: Incorrect checksum in table [TAMG] -
>> 0xCD, should be 0xCC (20120111/tbutils-321)
>> [    6.324511] ata9.01: ATAPI: LITE-ON DVDRW SHW-160P6S, PS0A, max UDMA/66
>> [    6.397218] scsi 8:0:0:0: CD-ROM            LITE-ON  LTR-48246S
>>   SS0B PQ: 0 ANSI: 5
>> [    6.419770] cdrom: Uniform CD-ROM driver Revision: 3.20
>> [    6.419898] sr 8:0:0:0: Attached scsi CD-ROM sr0
>> [    6.427088] scsi 8:0:1:0: CD-ROM            LITE-ON  DVDRW
>> SHW-160P6S PS0A PQ: 0 ANSI: 5
>> [    6.429600] sr 8:0:1:0: Attached scsi CD-ROM sr1
>>
>> I tried to do a git bisect but I dont know what I am doing. Might just
>> be my computer acting up.
>
>
> Can you post the full dmesg output from the non-working kernel?
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.3.0-030300-generic (apw@gomeisa) (gcc
version 4.4.3 (Ubuntu 4.4.3-4ubuntu5.1) ) #201203182135 SMP Mon Mar 19
01:36:20 UTC 2012
[    0.000000] Command line:
BOOT_IMAGE=/boot/vmlinuz-3.3.0-030300-generic
root=UUID=8f453049-cbc4-41e1-8a39-483ff818c79e ro quiet splash
nomodeset video=uvesafb:mode_option=1680x1050-24,mtrr=3,scroll=ywrap
vt.handoff=7
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009dc00 (usable)
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
[    0.000000] DMI: Gigabyte Technology Co., Ltd. EP45-UD3R/EP45-UD3R,
BIOS F12 01/25/2010
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000
(usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x120000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CCFFF write-protect
[    0.000000]   CD000-EFFFF uncachable
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
[    0.000000] original variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 4GB, type WB
[    0.000000] reg 1, base: 3584MB, range: 512MB, type UC
[    0.000000] reg 2, base: 4GB, range: 512MB, type WB
[    0.000000] reg 3, base: 3583MB, range: 1MB, type UC
[    0.000000] total RAM covered: 4095M
[    0.000000] Found optimal setting for mtrr clean up
[    0.000000]  gran_size: 64K 	chunk_size: 1G 	num_reg: 4  	lose cover RAM: 0G
[    0.000000] New variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 4GB, type WB
[    0.000000] reg 1, base: 3583MB, range: 1MB, type UC
[    0.000000] reg 2, base: 3584MB, range: 512MB, type UC
[    0.000000] reg 3, base: 4GB, range: 512MB, type WB
[    0.000000] e820 update range: 00000000dff00000 - 0000000100000000
(usable) ==> (reserved)
[    0.000000] last_pfn = 0xdfee0 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [ffff8800000f5670] f5670
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff880000098000] 98000 size 20480
[    0.000000] init_memory_mapping: 0000000000000000-00000000dfee0000
[    0.000000]  0000000000 - 00dfe00000 page 2M
[    0.000000]  00dfe00000 - 00dfee0000 page 4k
[    0.000000] kernel direct mapping tables up to dfee0000 @ 1fffa000-20000000
[    0.000000] init_memory_mapping: 0000000100000000-0000000120000000
[    0.000000]  0100000000 - 0120000000 page 2M
[    0.000000] kernel direct mapping tables up to 120000000 @ dfeda000-dfee0000
[    0.000000] RAMDISK: 35886000 - 36c3b000
[    0.000000] ACPI: RSDP 00000000000f7070 00014 (v00 GBT   )
[    0.000000] ACPI: RSDT 00000000dfee2040 00040 (v01 GBT    GBTUACPI
42302E31 GBTU 01010101)
[    0.000000] ACPI: FACP 00000000dfee20c0 00074 (v01 GBT    GBTUACPI
42302E31 GBTU 01010101)
[    0.000000] ACPI: DSDT 00000000dfee2180 04C5A (v01 GBT    GBTUACPI
00001000 MSFT 0100000C)
[    0.000000] ACPI: FACS 00000000dfee0000 00040
[    0.000000] ACPI: HPET 00000000dfee6f40 00038 (v01 GBT    GBTUACPI
42302E31 GBTU 00000098)
[    0.000000] ACPI: MCFG 00000000dfee6fc0 0003C (v01 GBT    GBTUACPI
42302E31 GBTU 01010101)
[    0.000000] ACPI: EUDS 00000000dfee7000 00560 (v01 GBT
00000000      00000000)
[    0.000000] ACPI: TAMG 00000000dfee7560 06852 (v01 GBT    GBT   B0
5455312E BG?? 00020101)
[    0.000000] ACPI: APIC 00000000dfee6e40 00084 (v01 GBT    GBTUACPI
42302E31 GBTU 01010101)
[    0.000000] ACPI: SSDT 00000000dfeee420 003AB (v01  PmRef    CpuPm
00003000 INTL 20040311)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-0000000120000000
[    0.000000] Initmem setup node 0 0000000000000000-0000000120000000
[    0.000000]   NODE_DATA [000000011fffb000 - 000000011fffffff]
[    0.000000]  [ffffea0000000000-ffffea00047fffff] PMD ->
[ffff88011b600000-ffff88011f5fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00120000
[    0.000000] Movable zone start PFN for each node
[    0.000000] Early memory PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009d
[    0.000000]     0: 0x00000100 -> 0x000dfee0
[    0.000000]     0: 0x00100000 -> 0x00120000
[    0.000000] On node 0 totalpages: 1048173
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 5 pages reserved
[    0.000000]   DMA zone: 3912 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 16320 pages used for memmap
[    0.000000]   DMA32 zone: 896800 pages, LIFO batch:31
[    0.000000]   Normal zone: 2048 pages used for memmap
[    0.000000]   Normal zone: 129024 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
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
[    0.000000] SMP: Allowing 4 CPUs, 2 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009d000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000dfee0000 - 00000000dfee2000
[    0.000000] PM: Registered nosave memory: 00000000dfee2000 - 00000000dfef0000
[    0.000000] PM: Registered nosave memory: 00000000dfef0000 - 00000000dff00000
[    0.000000] PM: Registered nosave memory: 00000000dff00000 - 00000000f4000000
[    0.000000] PM: Registered nosave memory: 00000000f4000000 - 00000000f8000000
[    0.000000] PM: Registered nosave memory: 00000000f8000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at dff00000 (gap:
dff00000:14100000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:256 nr_cpumask_bits:256
nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff88011fc00000 s82624
r8192 d23872 u524288
[    0.000000] pcpu-alloc: s82624 r8192 d23872 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.
Total pages: 1029736
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line:
BOOT_IMAGE=/boot/vmlinuz-3.3.0-030300-generic
root=UUID=8f453049-cbc4-41e1-8a39-483ff818c79e ro quiet splash
nomodeset video=uvesafb:mode_option=1680x1050-24,mtrr=3,scroll=ywrap
vt.handoff=7
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave/xrstor: enabled xstate_bv 0x3, cntxt size 0x240
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 4024676k/4718592k available (6579k kernel code,
525900k absent, 168016k reserved, 6549k data, 912k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0,
CPUs=4, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] NR_IRQS:16640 nr_irqs:712 16
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 16777216 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't
want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2999.662 MHz processor.
[    0.004003] Calibrating delay loop (skipped), value calculated
using timer frequency.. 5999.32 BogoMIPS (lpj=11998648)
[    0.004007] pid_max: default: 32768 minimum: 301
[    0.004028] Security Framework initialized
[    0.004042] AppArmor: AppArmor initialized
[    0.004340] Dentry cache hash table entries: 524288 (order: 10,
4194304 bytes)
[    0.009301] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.010034] Mount-cache hash table entries: 256
[    0.010153] Initializing cgroup subsys cpuacct
[    0.010156] Initializing cgroup subsys memory
[    0.010165] Initializing cgroup subsys devices
[    0.010168] Initializing cgroup subsys freezer
[    0.010169] Initializing cgroup subsys blkio
[    0.010175] Initializing cgroup subsys perf_event
[    0.010199] CPU: Physical Processor ID: 0
[    0.010201] CPU: Processor Core ID: 0
[    0.010202] mce: CPU supports 6 MCE banks
[    0.010209] CPU0: Thermal monitoring enabled (TM2)
[    0.010212] using mwait in idle threads.
[    0.012595] ACPI: Core revision 20120111
[    0.014419] ftrace: allocating 25267 entries in 99 pages
[    0.020394] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.062276] CPU0: Intel(R) Core(TM)2 Duo CPU     E8400  @ 3.00GHz stepping 0a
[    0.064003] Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
[    0.064003] ... version:                2
[    0.064003] ... bit width:              40
[    0.064003] ... generic registers:      2
[    0.064003] ... value mask:             000000ffffffffff
[    0.064003] ... max period:             000000007fffffff
[    0.064003] ... fixed-purpose events:   3
[    0.064003] ... event mask:             0000000700000003
[    0.064003] NMI watchdog enabled, takes one hw-pmu counter.
[    0.064003] Booting Node   0, Processors  #1
[    0.064003] smpboot cpu 1: start_ip = 98000
[    0.072033] NMI watchdog enabled, takes one hw-pmu counter.
[    0.072067] Brought up 2 CPUs
[    0.072069] Total of 2 processors activated (11998.64 BogoMIPS).
[    0.076079] devtmpfs: initialized
[    0.077311] EVM: security.selinux
[    0.077312] EVM: security.SMACK64
[    0.077313] EVM: security.capability
[    0.080012] PM: Registering ACPI NVS region at dfee0000 (8192 bytes)
[    0.080645] print_constraints: dummy:
[    0.080670] RTC time:  5:35:39, date: 03/22/12
[    0.080698] NET: Registered protocol family 16
[    0.080792] ACPI FADT declares the system doesn't support PCIe
ASPM, so disable it
[    0.080794] ACPI: bus type pci registered
[    0.080839] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem
0xf4000000-0xf7ffffff] (base 0xf4000000)
[    0.080842] PCI: MMCONFIG at [mem 0xf4000000-0xf7ffffff] reserved in E820
[    0.089111] PCI: Using configuration type 1 for base access
[    0.089788] bio: create slab <bio-0> at 0
[    0.089788] ACPI: Added _OSI(Module Device)
[    0.089788] ACPI: Added _OSI(Processor Device)
[    0.089788] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.089788] ACPI: Added _OSI(Processor Aggregator Device)
[    0.089788] ACPI: EC: Look up EC in DSDT
[    0.092673] ACPI Warning: Incorrect checksum in table [TAMG] -
0xB2, should be 0xB1 (20120111/tbutils-321)
[    0.092756] ACPI: SSDT 00000000dfeede00 0022A (v01  PmRef  Cpu0Ist
00003000 INTL 20040311)
[    0.092897] ACPI: Dynamic OEM Table Load:
[    0.092900] ACPI: SSDT           (null) 0022A (v01  PmRef  Cpu0Ist
00003000 INTL 20040311)
[    0.092978] ACPI: SSDT 00000000dfeee2c0 00152 (v01  PmRef  Cpu1Ist
00003000 INTL 20040311)
[    0.093110] ACPI: Dynamic OEM Table Load:
[    0.093112] ACPI: SSDT           (null) 00152 (v01  PmRef  Cpu1Ist
00003000 INTL 20040311)
[    0.093213] ACPI: Interpreter enabled
[    0.093217] ACPI: (supports S0 S3 S4 S5)
[    0.093228] ACPI: Using IOAPIC for interrupt routing
[    0.095996] ACPI: No dock devices found.
[    0.096007] PCI: Using host bridge windows from ACPI; if necessary,
use "pci=nocrs" and report a bug
[    0.096042] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3f])
[    0.096090] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
[    0.096092] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
[    0.096094] pci_root PNP0A03:00: host bridge window [mem
0x000a0000-0x000bffff]
[    0.096096] pci_root PNP0A03:00: host bridge window [mem
0x000c0000-0x000dffff]
[    0.096098] pci_root PNP0A03:00: host bridge window [mem
0xdff00000-0xfebfffff]
[    0.096129] PCI host bridge to bus 0000:00
[    0.096131] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.096133] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.096135] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.096137] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000dffff]
[    0.096138] pci_bus 0000:00: root bus resource [mem 0xdff00000-0xfebfffff]
[    0.096146] pci 0000:00:00.0: [8086:2e20] type 0 class 0x000600
[    0.096178] pci 0000:00:01.0: [8086:2e21] type 1 class 0x000604
[    0.096207] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.096238] pci 0000:00:1a.0: [8086:3a37] type 0 class 0x000c03
[    0.096273] pci 0000:00:1a.0: reg 20: [io  0xff00-0xff1f]
[    0.096315] pci 0000:00:1a.1: [8086:3a38] type 0 class 0x000c03
[    0.096350] pci 0000:00:1a.1: reg 20: [io  0xfe00-0xfe1f]
[    0.096392] pci 0000:00:1a.2: [8086:3a39] type 0 class 0x000c03
[    0.096428] pci 0000:00:1a.2: reg 20: [io  0xfd00-0xfd1f]
[    0.096473] pci 0000:00:1a.7: [8086:3a3c] type 0 class 0x000c03
[    0.096487] pci 0000:00:1a.7: reg 10: [mem 0xfdfff000-0xfdfff3ff]
[    0.096564] pci 0000:00:1b.0: [8086:3a3e] type 0 class 0x000403
[    0.096576] pci 0000:00:1b.0: reg 10: [mem 0xfdff8000-0xfdffbfff 64bit]
[    0.096631] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.096648] pci 0000:00:1c.0: [8086:3a40] type 1 class 0x000604
[    0.096704] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.096724] pci 0000:00:1c.3: [8086:3a46] type 1 class 0x000604
[    0.096779] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.096801] pci 0000:00:1d.0: [8086:3a34] type 0 class 0x000c03
[    0.096836] pci 0000:00:1d.0: reg 20: [io  0xfc00-0xfc1f]
[    0.096878] pci 0000:00:1d.1: [8086:3a35] type 0 class 0x000c03
[    0.096913] pci 0000:00:1d.1: reg 20: [io  0xfb00-0xfb1f]
[    0.096955] pci 0000:00:1d.2: [8086:3a36] type 0 class 0x000c03
[    0.096989] pci 0000:00:1d.2: reg 20: [io  0xfa00-0xfa1f]
[    0.097035] pci 0000:00:1d.7: [8086:3a3a] type 0 class 0x000c03
[    0.097049] pci 0000:00:1d.7: reg 10: [mem 0xfdffe000-0xfdffe3ff]
[    0.097120] pci 0000:00:1e.0: [8086:244e] type 1 class 0x000604
[    0.097172] pci 0000:00:1f.0: [8086:3a16] type 0 class 0x000601
[    0.097242] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at
0800 (mask 000f)
[    0.097245] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at
0290 (mask 000f)
[    0.097287] pci 0000:00:1f.2: [8086:3a22] type 0 class 0x000106
[    0.097302] pci 0000:00:1f.2: reg 10: [io  0xf900-0xf907]
[    0.097308] pci 0000:00:1f.2: reg 14: [io  0xf800-0xf803]
[    0.097315] pci 0000:00:1f.2: reg 18: [io  0xf700-0xf707]
[    0.097321] pci 0000:00:1f.2: reg 1c: [io  0xf600-0xf603]
[    0.097327] pci 0000:00:1f.2: reg 20: [io  0xf500-0xf51f]
[    0.097334] pci 0000:00:1f.2: reg 24: [mem 0xfdffd000-0xfdffd7ff]
[    0.097370] pci 0000:00:1f.2: PME# supported from D3hot
[    0.097385] pci 0000:00:1f.3: [8086:3a30] type 0 class 0x000c05
[    0.097397] pci 0000:00:1f.3: reg 10: [mem 0xfdffc000-0xfdffc0ff 64bit]
[    0.097414] pci 0000:00:1f.3: reg 20: [io  0x0500-0x051f]
[    0.097468] pci 0000:01:00.0: [10de:0613] type 0 class 0x000300
[    0.097480] pci 0000:01:00.0: reg 10: [mem 0xfa000000-0xfaffffff]
[    0.097492] pci 0000:01:00.0: reg 14: [mem 0xe0000000-0xefffffff 64bit pref]
[    0.097505] pci 0000:01:00.0: reg 1c: [mem 0xf8000000-0xf9ffffff 64bit]
[    0.097513] pci 0000:01:00.0: reg 24: [io  0xdf00-0xdf7f]
[    0.097522] pci 0000:01:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    0.097587] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.097590] pci 0000:00:01.0:   bridge window [io  0xd000-0xdfff]
[    0.097593] pci 0000:00:01.0:   bridge window [mem 0xf8000000-0xfbffffff]
[    0.097596] pci 0000:00:01.0:   bridge window [mem
0xe0000000-0xefffffff 64bit pref]
[    0.097627] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.097680] pci 0000:03:00.0: [197b:2363] type 0 class 0x000106
[    0.097759] pci 0000:03:00.0: reg 24: [mem 0xfdefe000-0xfdefffff]
[    0.097816] pci 0000:03:00.0: PME# supported from D3hot
[    0.097844] pci 0000:03:00.1: [197b:2363] type 0 class 0x000101
[    0.097866] pci 0000:03:00.1: reg 10: [io  0xef00-0xef07]
[    0.097878] pci 0000:03:00.1: reg 14: [io  0xee00-0xee03]
[    0.097891] pci 0000:03:00.1: reg 18: [io  0xed00-0xed07]
[    0.097903] pci 0000:03:00.1: reg 1c: [io  0xec00-0xec03]
[    0.097915] pci 0000:03:00.1: reg 20: [io  0xeb00-0xeb0f]
[    0.104022] pci 0000:00:1c.3: PCI bridge to [bus 03-03]
[    0.104027] pci 0000:00:1c.3:   bridge window [io  0xe000-0xefff]
[    0.104031] pci 0000:00:1c.3:   bridge window [mem 0xfde00000-0xfdefffff]
[    0.104063] pci 0000:04:01.0: [10b7:9050] type 0 class 0x000200
[    0.104076] pci 0000:04:01.0: reg 10: [io  0xcf00-0xcf3f]
[    0.104123] pci 0000:04:01.0: reg 30: [mem 0x00000000-0x0000ffff pref]
[    0.104146] pci 0000:04:02.0: [4444:0016] type 0 class 0x000400
[    0.104163] pci 0000:04:02.0: reg 10: [mem 0xf0000000-0xf3ffffff pref]
[    0.104254] pci 0000:04:07.0: [104c:8024] type 0 class 0x000c00
[    0.104269] pci 0000:04:07.0: reg 10: [mem 0xfddff000-0xfddff7ff]
[    0.104278] pci 0000:04:07.0: reg 14: [mem 0xfddf8000-0xfddfbfff]
[    0.104338] pci 0000:04:07.0: supports D1 D2
[    0.104339] pci 0000:04:07.0: PME# supported from D0 D1 D2 D3hot
[    0.104372] pci 0000:00:1e.0: PCI bridge to [bus 04-04] (subtractive decode)
[    0.104375] pci 0000:00:1e.0:   bridge window [io  0xc000-0xcfff]
[    0.104378] pci 0000:00:1e.0:   bridge window [mem 0xfdd00000-0xfddfffff]
[    0.104383] pci 0000:00:1e.0:   bridge window [mem
0xf0000000-0xf3ffffff 64bit pref]
[    0.104385] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7]
(subtractive decode)
[    0.104387] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff]
(subtractive decode)
[    0.104389] pci 0000:00:1e.0:   bridge window [mem
0x000a0000-0x000bffff] (subtractive decode)
[    0.104391] pci 0000:00:1e.0:   bridge window [mem
0x000c0000-0x000dffff] (subtractive decode)
[    0.104393] pci 0000:00:1e.0:   bridge window [mem
0xdff00000-0xfebfffff] (subtractive decode)
[    0.104408] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.104474] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
[    0.104500] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX3._PRT]
[    0.104529] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
[    0.104596]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.104598]  pci0000:00: ACPI _OSC request failed (AE_NOT_FOUND),
returned control mask: 0x1d
[    0.104600] ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.110306] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10
*11 12 14 15)
[    0.110341] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 11
12 14 15) *0, disabled.
[    0.110374] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 11
12 *14 15)
[    0.110407] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 *10
11 12 14 15)
[    0.110440] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11
12 14 15) *0, disabled.
[    0.110473] ACPI: PCI Interrupt Link [LNKF] (IRQs *3 4 5 6 7 9 10
11 12 14 15)
[    0.110505] ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 *5 6 7 9 10
11 12 14 15)
[    0.110538] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 6 *7 9 10
11 12 14 15)
[    0.110593] vgaarb: device added:
PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.110593] vgaarb: loaded
[    0.110593] vgaarb: bridge control possible 0000:01:00.0
[    0.110593] SCSI subsystem initialized
[    0.110593] libata version 3.00 loaded.
[    0.110593] usbcore: registered new interface driver usbfs
[    0.110593] usbcore: registered new interface driver hub
[    0.110593] usbcore: registered new device driver usb
[    0.110593] PCI: Using ACPI for IRQ routing
[    0.110593] PCI: pci_cache_line_size set to 64 bytes
[    0.110593] reserve RAM buffer: 000000000009dc00 - 000000000009ffff
[    0.110593] reserve RAM buffer: 00000000dfee0000 - 00000000dfffffff
[    0.110593] NetLabel: Initializing
[    0.110593] NetLabel:  domain hash size = 128
[    0.110593] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.110593] NetLabel:  unlabeled traffic allowed by default
[    0.112023] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    0.112027] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.112031] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.116022] Switching to clocksource hpet
[    0.121585] AppArmor: AppArmor Filesystem Enabled
[    0.121603] pnp: PnP ACPI init
[    0.121617] ACPI: bus type pnp registered
[    0.121679] pnp 00:00: [bus 00-3f]
[    0.121681] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.121682] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.121684] pnp 00:00: [io  0x0d00-0xffff window]
[    0.121686] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.121688] pnp 00:00: [mem 0x000c0000-0x000dffff window]
[    0.121689] pnp 00:00: [mem 0xdff00000-0xfebfffff window]
[    0.121732] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.121784] pnp 00:01: [io  0x0010-0x001f]
[    0.121786] pnp 00:01: [io  0x0022-0x003f]
[    0.121787] pnp 00:01: [io  0x0044-0x005f]
[    0.121791] pnp 00:01: [io  0x0062-0x0063]
[    0.121792] pnp 00:01: [io  0x0065-0x006f]
[    0.121793] pnp 00:01: [io  0x0074-0x007f]
[    0.121795] pnp 00:01: [io  0x0091-0x0093]
[    0.121796] pnp 00:01: [io  0x00a2-0x00bf]
[    0.121798] pnp 00:01: [io  0x00e0-0x00ef]
[    0.121799] pnp 00:01: [io  0x04d0-0x04d1]
[    0.121801] pnp 00:01: [io  0x0290-0x029f]
[    0.121802] pnp 00:01: [io  0x0800-0x087f]
[    0.121803] pnp 00:01: [io  0x0290-0x0294]
[    0.121805] pnp 00:01: [io  0x0880-0x088f]
[    0.121854] system 00:01: [io  0x04d0-0x04d1] has been reserved
[    0.121857] system 00:01: [io  0x0290-0x029f] has been reserved
[    0.121859] system 00:01: [io  0x0800-0x087f] has been reserved
[    0.121861] system 00:01: [io  0x0290-0x0294] has been reserved
[    0.121863] system 00:01: [io  0x0880-0x088f] has been reserved
[    0.121865] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.121874] pnp 00:02: [dma 4]
[    0.121875] pnp 00:02: [io  0x0000-0x000f]
[    0.121877] pnp 00:02: [io  0x0080-0x0090]
[    0.121878] pnp 00:02: [io  0x0094-0x009f]
[    0.121880] pnp 00:02: [io  0x00c0-0x00df]
[    0.121903] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.121938] pnp 00:03: [irq 0 disabled]
[    0.121947] pnp 00:03: [irq 8]
[    0.121948] pnp 00:03: [mem 0xfed00000-0xfed003ff]
[    0.121971] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.121989] pnp 00:04: [io  0x0070-0x0073]
[    0.122012] pnp 00:04: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.122019] pnp 00:05: [io  0x0061]
[    0.122042] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.122049] pnp 00:06: [io  0x00f0-0x00ff]
[    0.122053] pnp 00:06: [irq 13]
[    0.122076] pnp 00:06: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.122292] pnp 00:07: [io  0x0400-0x04cf]
[    0.122294] pnp 00:07: [io  0x04d2-0x04ff]
[    0.122330] system 00:07: [io  0x0400-0x04cf] has been reserved
[    0.122332] system 00:07: [io  0x04d2-0x04ff] has been reserved
[    0.122335] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.122458] pnp 00:08: [mem 0xf4000000-0xf7ffffff]
[    0.122503] system 00:08: [mem 0xf4000000-0xf7ffffff] has been reserved
[    0.122506] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.122605] pnp 00:09: [mem 0x000d6000-0x000d7fff]
[    0.122607] pnp 00:09: [mem 0x000f0000-0x000f7fff]
[    0.122609] pnp 00:09: [mem 0x000f8000-0x000fbfff]
[    0.122610] pnp 00:09: [mem 0x000fc000-0x000fffff]
[    0.122612] pnp 00:09: [mem 0xdfee0000-0xdfefffff]
[    0.122614] pnp 00:09: [mem 0x00000000-0x0009ffff]
[    0.122615] pnp 00:09: [mem 0x00100000-0xdfedffff]
[    0.122617] pnp 00:09: [mem 0xfec00000-0xfec00fff]
[    0.122618] pnp 00:09: [mem 0xfed10000-0xfed1dfff]
[    0.122619] pnp 00:09: [mem 0xfed20000-0xfed8ffff]
[    0.122621] pnp 00:09: [mem 0xfee00000-0xfee00fff]
[    0.122622] pnp 00:09: [mem 0xffb00000-0xffb7ffff]
[    0.122624] pnp 00:09: [mem 0xfff00000-0xffffffff]
[    0.122625] pnp 00:09: [mem 0x000e0000-0x000effff]
[    0.122676] system 00:09: [mem 0x000d6000-0x000d7fff] has been reserved
[    0.122678] system 00:09: [mem 0x000f0000-0x000f7fff] could not be reserved
[    0.122680] system 00:09: [mem 0x000f8000-0x000fbfff] could not be reserved
[    0.122683] system 00:09: [mem 0x000fc000-0x000fffff] could not be reserved
[    0.122685] system 00:09: [mem 0xdfee0000-0xdfefffff] could not be reserved
[    0.122687] system 00:09: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.122689] system 00:09: [mem 0x00100000-0xdfedffff] could not be reserved
[    0.122691] system 00:09: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.122693] system 00:09: [mem 0xfed10000-0xfed1dfff] has been reserved
[    0.122696] system 00:09: [mem 0xfed20000-0xfed8ffff] has been reserved
[    0.122698] system 00:09: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.122700] system 00:09: [mem 0xffb00000-0xffb7ffff] has been reserved
[    0.122702] system 00:09: [mem 0xfff00000-0xffffffff] has been reserved
[    0.122704] system 00:09: [mem 0x000e0000-0x000effff] has been reserved
[    0.122707] system 00:09: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.122720] pnp 00:0a: [mem 0xffb80000-0xffbfffff]
[    0.122750] pnp 00:0a: Plug and Play ACPI device, IDs INT0800 (active)
[    0.122754] pnp: PnP ACPI: found 11 devices
[    0.122756] ACPI: ACPI bus type pnp unregistered
[    0.128920] PCI: max bus depth: 1 pci_try_num: 2
[    0.128946] pci 0000:00:1c.3: BAR 15: assigned [mem
0xfc000000-0xfc1fffff 64bit pref]
[    0.128949] pci 0000:00:1c.0: BAR 14: assigned [mem 0xfc200000-0xfc3fffff]
[    0.128952] pci 0000:00:1c.0: BAR 15: assigned [mem
0xfc400000-0xfc5fffff 64bit pref]
[    0.128954] pci 0000:00:1c.0: BAR 13: assigned [io  0x1000-0x1fff]
[    0.128957] pci 0000:01:00.0: BAR 6: assigned [mem
0xfb000000-0xfb01ffff pref]
[    0.128959] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.128961] pci 0000:00:01.0:   bridge window [io  0xd000-0xdfff]
[    0.128964] pci 0000:00:01.0:   bridge window [mem 0xf8000000-0xfbffffff]
[    0.128967] pci 0000:00:01.0:   bridge window [mem
0xe0000000-0xefffffff 64bit pref]
[    0.128970] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.128972] pci 0000:00:1c.0:   bridge window [io  0x1000-0x1fff]
[    0.128976] pci 0000:00:1c.0:   bridge window [mem 0xfc200000-0xfc3fffff]
[    0.128979] pci 0000:00:1c.0:   bridge window [mem
0xfc400000-0xfc5fffff 64bit pref]
[    0.128984] pci 0000:00:1c.3: PCI bridge to [bus 03-03]
[    0.128987] pci 0000:00:1c.3:   bridge window [io  0xe000-0xefff]
[    0.128990] pci 0000:00:1c.3:   bridge window [mem 0xfde00000-0xfdefffff]
[    0.128994] pci 0000:00:1c.3:   bridge window [mem
0xfc000000-0xfc1fffff 64bit pref]
[    0.128999] pci 0000:04:01.0: BAR 6: assigned [mem
0xfdd00000-0xfdd0ffff pref]
[    0.129001] pci 0000:00:1e.0: PCI bridge to [bus 04-04]
[    0.129003] pci 0000:00:1e.0:   bridge window [io  0xc000-0xcfff]
[    0.129007] pci 0000:00:1e.0:   bridge window [mem 0xfdd00000-0xfddfffff]
[    0.129010] pci 0000:00:1e.0:   bridge window [mem
0xf0000000-0xf3ffffff 64bit pref]
[    0.129026] pci 0000:00:1c.0: enabling device (0000 -> 0003)
[    0.129038] pci 0000:00:1e.0: setting latency timer to 64
[    0.129041] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.129043] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.129045] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.129046] pci_bus 0000:00: resource 7 [mem 0x000c0000-0x000dffff]
[    0.129048] pci_bus 0000:00: resource 8 [mem 0xdff00000-0xfebfffff]
[    0.129050] pci_bus 0000:01: resource 0 [io  0xd000-0xdfff]
[    0.129052] pci_bus 0000:01: resource 1 [mem 0xf8000000-0xfbffffff]
[    0.129054] pci_bus 0000:01: resource 2 [mem 0xe0000000-0xefffffff
64bit pref]
[    0.129056] pci_bus 0000:02: resource 0 [io  0x1000-0x1fff]
[    0.129058] pci_bus 0000:02: resource 1 [mem 0xfc200000-0xfc3fffff]
[    0.129059] pci_bus 0000:02: resource 2 [mem 0xfc400000-0xfc5fffff
64bit pref]
[    0.129061] pci_bus 0000:03: resource 0 [io  0xe000-0xefff]
[    0.129063] pci_bus 0000:03: resource 1 [mem 0xfde00000-0xfdefffff]
[    0.129065] pci_bus 0000:03: resource 2 [mem 0xfc000000-0xfc1fffff
64bit pref]
[    0.129067] pci_bus 0000:04: resource 0 [io  0xc000-0xcfff]
[    0.129069] pci_bus 0000:04: resource 1 [mem 0xfdd00000-0xfddfffff]
[    0.129071] pci_bus 0000:04: resource 2 [mem 0xf0000000-0xf3ffffff
64bit pref]
[    0.129073] pci_bus 0000:04: resource 4 [io  0x0000-0x0cf7]
[    0.129075] pci_bus 0000:04: resource 5 [io  0x0d00-0xffff]
[    0.129076] pci_bus 0000:04: resource 6 [mem 0x000a0000-0x000bffff]
[    0.129078] pci_bus 0000:04: resource 7 [mem 0x000c0000-0x000dffff]
[    0.129080] pci_bus 0000:04: resource 8 [mem 0xdff00000-0xfebfffff]
[    0.129103] NET: Registered protocol family 2
[    0.129210] IP route cache hash table entries: 131072 (order: 8,
1048576 bytes)
[    0.130027] TCP established hash table entries: 524288 (order: 11,
8388608 bytes)
[    0.132791] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.133157] TCP: Hash tables configured (established 524288 bind 65536)
[    0.133159] TCP reno registered
[    0.133166] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.133198] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.133304] NET: Registered protocol family 1
[    0.164045] pci 0000:01:00.0: Boot video device
[    0.164061] PCI: CLS 4 bytes, default 64
[    0.164116] Trying to unpack rootfs image as initramfs...
[    0.468111] Freeing initrd memory: 20180k freed
[    0.473770] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.473775] Placing 64MB software IO TLB between ffff8800dbeda000 -
ffff8800dfeda000
[    0.473777] software IO TLB at phys 0xdbeda000 - 0xdfeda000
[    0.474161] audit: initializing netlink socket (disabled)
[    0.474174] type=2000 audit(1332394539.468:1): initialized
[    0.492746] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.494506] VFS: Disk quotas dquot_6.5.2
[    0.494547] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.494907] fuse init (API version 7.18)
[    0.494977] msgmni has been set to 7900
[    0.495275] Block layer SCSI generic (bsg) driver version 0.4
loaded (major 253)
[    0.495303] io scheduler noop registered
[    0.495305] io scheduler deadline registered
[    0.495348] io scheduler cfq registered (default)
[    0.495451] pcieport 0000:00:01.0: irq 40 for MSI/MSI-X
[    0.495515] pcieport 0000:00:1c.0: irq 41 for MSI/MSI-X
[    0.495589] pcieport 0000:00:1c.3: irq 42 for MSI/MSI-X
[    0.495650] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.495665] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.495708] intel_idle: MWAIT substates: 0x22220
[    0.495710] intel_idle: does not run on family 6 model 23
[    0.495772] input: Power Button as
/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[    0.495777] ACPI: Power Button [PWRB]
[    0.495822] input: Power Button as
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    0.495824] ACPI: Power Button [PWRF]
[    0.495873] Marking TSC unstable due to TSC halts in idle
[    0.495878] ACPI: acpi_idle registered with cpuidle
[    0.496817] GHES: HEST is not enabled!
[    0.496872] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
[    0.497982] Linux agpgart interface v0.103
[    0.499149] brd: module loaded
[    0.499700] loop: module loaded
[    0.499782] ahci 0000:00:1f.2: version 3.0
[    0.499817] ahci 0000:00:1f.2: irq 43 for MSI/MSI-X
[    0.499856] ahci: SSS flag set, parallel bus scan disabled
[    0.499884] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3
Gbps 0x3f impl SATA mode
[    0.499887] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led
clo pmp pio slum part ccc ems
[    0.499891] ahci 0000:00:1f.2: setting latency timer to 64
[    0.536462] scsi0 : ahci
[    0.536526] scsi1 : ahci
[    0.536581] scsi2 : ahci
[    0.536636] scsi3 : ahci
[    0.536690] scsi4 : ahci
[    0.536744] scsi5 : ahci
[    0.536841] ata1: SATA max UDMA/133 abar m2048@0xfdffd000 port
0xfdffd100 irq 43
[    0.536844] ata2: SATA max UDMA/133 abar m2048@0xfdffd000 port
0xfdffd180 irq 43
[    0.536846] ata3: SATA max UDMA/133 abar m2048@0xfdffd000 port
0xfdffd200 irq 43
[    0.536848] ata4: SATA max UDMA/133 abar m2048@0xfdffd000 port
0xfdffd280 irq 43
[    0.536850] ata5: SATA max UDMA/133 abar m2048@0xfdffd000 port
0xfdffd300 irq 43
[    0.536853] ata6: SATA max UDMA/133 abar m2048@0xfdffd000 port
0xfdffd380 irq 43
[    0.552035] ahci 0000:03:00.0: AHCI 0001.0000 32 slots 2 ports 3
Gbps 0x3 impl SATA mode
[    0.552039] ahci 0000:03:00.0: flags: 64bit ncq pm led clo pmp pio slum part
[    0.552303] scsi6 : ahci
[    0.552360] scsi7 : ahci
[    0.552419] ata7: SATA max UDMA/133 abar m8192@0xfdefe000 port
0xfdefe100 irq 19
[    0.552422] ata8: SATA max UDMA/133 abar m8192@0xfdefe000 port
0xfdefe180 irq 19
[    0.552496] pata_acpi 0000:03:00.1: setting latency timer to 64
[    0.552710] Fixed MDIO Bus: probed
[    0.552722] tun: Universal TUN/TAP device driver, 1.6
[    0.552723] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    0.552762] PPP generic driver version 2.4.2
[    0.552837] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.552856] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    0.552859] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    0.552894] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned
bus number 1
[    0.556793] ehci_hcd 0000:00:1a.7: cache line size of 4 is not supported
[    0.556803] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xfdfff000
[    0.568013] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    0.568157] hub 1-0:1.0: USB hub found
[    0.568162] hub 1-0:1.0: 6 ports detected
[    0.568231] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    0.568234] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    0.568269] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned
bus number 2
[    0.572174] ehci_hcd 0000:00:1d.7: cache line size of 4 is not supported
[    0.572184] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfdffe000
[    0.584015] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    0.584128] hub 2-0:1.0: USB hub found
[    0.584132] hub 2-0:1.0: 6 ports detected
[    0.584201] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.584210] uhci_hcd: USB Universal Host Controller Interface driver
[    0.584226] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    0.584229] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    0.584262] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned
bus number 3
[    0.584288] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000ff00
[    0.584376] hub 3-0:1.0: USB hub found
[    0.584379] hub 3-0:1.0: 2 ports detected
[    0.584434] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    0.584437] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    0.584471] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned
bus number 4
[    0.584499] uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000fe00
[    0.584587] hub 4-0:1.0: USB hub found
[    0.584589] hub 4-0:1.0: 2 ports detected
[    0.584642] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    0.584644] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    0.584677] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned
bus number 5
[    0.584697] uhci_hcd 0000:00:1a.2: irq 18, io base 0x0000fd00
[    0.584791] hub 5-0:1.0: USB hub found
[    0.584794] hub 5-0:1.0: 2 ports detected
[    0.584845] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    0.584847] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    0.584882] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned
bus number 6
[    0.584903] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000fc00
[    0.584994] hub 6-0:1.0: USB hub found
[    0.584997] hub 6-0:1.0: 2 ports detected
[    0.585051] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    0.585053] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    0.585091] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned
bus number 7
[    0.585111] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000fb00
[    0.585199] hub 7-0:1.0: USB hub found
[    0.585202] hub 7-0:1.0: 2 ports detected
[    0.585253] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    0.585256] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    0.585288] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned
bus number 8
[    0.585308] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000fa00
[    0.585396] hub 8-0:1.0: USB hub found
[    0.585399] hub 8-0:1.0: 2 ports detected
[    0.585482] usbcore: registered new interface driver libusual
[    0.585513] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    0.585856] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.585862] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.585989] mousedev: PS/2 mouse device common for all mice
[    0.586127] rtc_cmos 00:04: RTC can wake from S4
[    0.586208] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
[    0.586229] rtc0: alarms up to one month, 242 bytes nvram, hpet irqs
[    0.586283] device-mapper: uevent: version 1.0.3
[    0.586335] device-mapper: ioctl: 4.22.0-ioctl (2011-10-19)
initialised: dm-devel@redhat.com
[    0.586356] cpuidle: using governor ladder
[    0.586378] cpuidle: using governor menu
[    0.586380] EFI Variables Facility v0.08 2004-May-17
[    0.586535] TCP cubic registered
[    0.586616] NET: Registered protocol family 10
[    0.586979] NET: Registered protocol family 17
[    0.586988] Registering the dns_resolver key type
[    0.587083] PM: Hibernation image not present or could not be loaded.
[    0.587093] registered taskstats version 1
[    0.591496]   Magic number: 4:192:568
[    0.591578] rtc_cmos 00:04: setting system clock to 2012-03-22
05:35:40 UTC (1332394540)
[    0.592715] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    0.592716] EDD information not available.
[    0.872031] ata7: SATA link down (SStatus 0 SControl 300)
[    0.872064] ata8: SATA link down (SStatus 0 SControl 300)
[    0.936015] usb 1-5: new high-speed USB device number 3 using ehci_hcd
[    1.028017] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.030026] ata1.00: ATA-8: WDC WD7501AALS-00E3A0, 05.01D05, max UDMA/133
[    1.030030] ata1.00: 1465149168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
[    1.031107] ata1.00: configured for UDMA/133
[    1.031229] scsi 0:0:0:0: Direct-Access     ATA      WDC
WD7501AALS-0 05.0 PQ: 0 ANSI: 5
[    1.031357] sd 0:0:0:0: [sda] 1465149168 512-byte logical blocks:
(750 GB/698 GiB)
[    1.031377] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.031411] sd 0:0:0:0: [sda] Write Protect is off
[    1.031414] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.031438] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    1.063597]  sda: sda1 sda2 sda3 sda4 sda5 sda6
[    1.063982] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.068755] hub 1-5:1.0: USB hub found
[    1.068848] hub 1-5:1.0: 4 ports detected
[    1.364015] usb 3-1: new low-speed USB device number 2 using uhci_hcd
[    1.520017] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.520750] ata2.00: ATA-8: WDC WD7501AALS-00J7B0, 05.00K05, max UDMA/133
[    1.520753] ata2.00: 1465149168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
[    1.521560] ata2.00: configured for UDMA/133
[    1.521650] scsi 1:0:0:0: Direct-Access     ATA      WDC
WD7501AALS-0 05.0 PQ: 0 ANSI: 5
[    1.521755] sd 1:0:0:0: [sdb] 1465149168 512-byte logical blocks:
(750 GB/698 GiB)
[    1.521778] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    1.521808] sd 1:0:0:0: [sdb] Write Protect is off
[    1.521811] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    1.521845] sd 1:0:0:0: [sdb] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    1.526924]  sdb: sdb1
[    1.527126] sd 1:0:0:0: [sdb] Attached SCSI disk
[    1.788013] usb 8-2: new low-speed USB device number 2 using uhci_hcd
[    2.012018] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.012825] ata3.00: HPA detected: current 976771055, native 976773168
[    2.012896] ata3.00: ATA-8: WDC WD5000AAKS-00A7B0, 01.03B01, max UDMA/133
[    2.012900] ata3.00: 976771055 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
[    2.013861] ata3.00: configured for UDMA/133
[    2.013952] scsi 2:0:0:0: Direct-Access     ATA      WDC
WD5000AAKS-0 01.0 PQ: 0 ANSI: 5
[    2.014063] sd 2:0:0:0: [sdc] 976771055 512-byte logical blocks:
(500 GB/465 GiB)
[    2.014089] sd 2:0:0:0: Attached scsi generic sg2 type 0
[    2.014116] sd 2:0:0:0: [sdc] Write Protect is off
[    2.014119] sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    2.014145] sd 2:0:0:0: [sdc] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    2.066104]  sdc: sdc1
[    2.066328] sd 2:0:0:0: [sdc] Attached SCSI disk
[    2.504016] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.504682] ata4.00: HPA detected: current 1953523055, native 1953525168
[    2.504750] ata4.00: ATA-8: WDC WD1001FALS-00J7B0, 05.00K05, max UDMA/133
[    2.504754] ata4.00: 1953523055 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
[    2.505561] ata4.00: configured for UDMA/133
[    2.505649] scsi 3:0:0:0: Direct-Access     ATA      WDC
WD1001FALS-0 05.0 PQ: 0 ANSI: 5
[    2.505751] sd 3:0:0:0: [sdd] 1953523055 512-byte logical blocks:
(1.00 TB/931 GiB)
[    2.505778] sd 3:0:0:0: Attached scsi generic sg3 type 0
[    2.505803] sd 3:0:0:0: [sdd] Write Protect is off
[    2.505806] sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[    2.505833] sd 3:0:0:0: [sdd] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    2.515058]  sdd: sdd1
[    2.515251] sd 3:0:0:0: [sdd] Attached SCSI disk
[    2.824018] ata5: SATA link down (SStatus 0 SControl 300)
[    3.144017] ata6: SATA link down (SStatus 0 SControl 300)
[    3.145354] Freeing unused kernel memory: 912k freed
[    3.145561] Write protecting the kernel read-only data: 12288k
[    3.149808] Freeing unused kernel memory: 1592k freed
[    3.153359] Freeing unused kernel memory: 1220k freed
[    3.165200] zram: module is from the staging directory, the quality
is unknown, you have been warned.
[    3.165372] zram: num_devices not specified. Using default: 1
[    3.165374] zram: Creating 1 devices ...
[    3.167746] udevd[109]: starting version 173
[    3.228749] 3c59x: Donald Becker and others.
[    3.228756] 0000:04:01.0: 3Com PCI 3c905 Boomerang 100baseTx at
000000000001cf00.
[    3.231464] pata_jmicron 0000:03:00.1: setting latency timer to 64
[    3.255549] scsi8 : pata_jmicron
[    3.260534] scsi9 : pata_jmicron
[    3.260933] ata9: PATA max UDMA/100 cmd 0xef00 ctl 0xee00 bmdma 0xeb00 irq 16
[    3.260936] ata10: PATA max UDMA/100 cmd 0xed00 ctl 0xec00 bmdma
0xeb08 irq 16
[    3.293776] Adding 2024288k swap on /dev/zram0.  Priority:100
extents:1 across:2024288k SS
[    3.297644] input: USB Laser Wheel Mouse as
/devices/pci0000:00/0000:00:1d.2/usb8/8-2/8-2:1.0/input/input2
[    3.297783] generic-usb 0003:1BCF:000A.0003: input,hiddev0,hidraw0:
USB HID v1.11 Mouse [USB Laser Wheel Mouse] on
usb-0000:00:1d.2-2/input0
[    3.297801] usbcore: registered new interface driver usbhid
[    3.297803] usbhid: USB HID core driver
[    3.332060] firewire_ohci: Added fw-ohci device 0000:04:07.0, OHCI
v1.10, 4 IR + 8 IT contexts, quirks 0x2
[    3.397581] input: Microsoft Microsoft® Digital Media Keyboard 3000
as /devices/pci0000:00/0000:00:1a.0/usb3/3-1/3-1:1.0/input/input3
[    3.397653] microsoft 0003:045E:0730.0001: input,hidraw1: USB HID
v1.11 Keyboard [Microsoft Microsoft® Digital Media Keyboard 3000] on
usb-0000:00:1a.0-1/input0
[    3.428497] input: Microsoft Microsoft® Digital Media Keyboard 3000
as /devices/pci0000:00/0000:00:1a.0/usb3/3-1/3-1:1.1/input/input4
[    3.428561] microsoft 0003:045E:0730.0002: input,hidraw2: USB HID
v1.11 Device [Microsoft Microsoft® Digital Media Keyboard 3000] on
usb-0000:00:1a.0-1/input1
[    3.832100] firewire_core: created device fw0: GUID 00ee724c00001fd0, S400
[    4.246639] uvesafb: NVIDIA Corporation, G92 Board - 03910050, Chip
Rev   , OEM: NVIDIA, VBE v3.0
[    4.356291] uvesafb: VBIOS/hardware supports DDC2 transfers
[    4.453302] uvesafb: monitor limits: vf = 76 Hz, hf = 94 kHz, clk = 210 MHz
[    4.453516] uvesafb: scrolling: redraw
[    4.453523] mtrr: type mismatch for f9000000,1000000 old:
write-back new: write-combining
[    4.453526] mtrr: type mismatch for f9000000,800000 old: write-back
new: write-combining
[    4.453528] mtrr: type mismatch for f9000000,400000 old: write-back
new: write-combining
[    4.453531] mtrr: type mismatch for f9000000,200000 old: write-back
new: write-combining
[    4.453533] mtrr: type mismatch for f9000000,100000 old: write-back
new: write-combining
[    4.453536] mtrr: type mismatch for f9000000,80000 old: write-back
new: write-combining
[    4.453538] mtrr: type mismatch for f9000000,40000 old: write-back
new: write-combining
[    4.453541] mtrr: type mismatch for f9000000,20000 old: write-back
new: write-combining
[    4.453543] mtrr: type mismatch for f9000000,10000 old: write-back
new: write-combining
[    4.453545] mtrr: type mismatch for f9000000,8000 old: write-back
new: write-combining
[    4.453548] mtrr: type mismatch for f9000000,4000 old: write-back
new: write-combining
[    4.453550] mtrr: type mismatch for f9000000,2000 old: write-back
new: write-combining
[    4.453552] mtrr: type mismatch for f9000000,1000 old: write-back
new: write-combining
[    4.927670] Console: switching to colour frame buffer device 210x65
[    4.931167] uvesafb: framebuffer at 0xf9000000, mapped to
0xffffc90006000000, using 13781k, total 14336k
[    4.931168] fb0: VESA VGA frame buffer device
[    5.723637] EXT4-fs (sda3): mounted filesystem with ordered data
mode. Opts: (null)
[    6.790825] init: ureadahead main process (404) terminated with status 5
[    7.585896] udevd[441]: starting version 173
[    8.013483] Adding 4194300k swap on /dev/sda2.  Priority:-1
extents:1 across:4194300k
[    8.921260] lp: driver loaded but no devices found
[    9.224671] it87: Found IT8718F chip at 0x290, revision 5
[    9.224677] it87: VID is disabled (pins used for GPIO)
[    9.224686] it87: Beeping is supported
[    9.248539] device-mapper: multipath: version 1.3.0 loaded
[    9.291012] Linux video capture interface: v2.00
[    9.552777] ivtv: Start initialization, version 1.4.3
[    9.552823] ivtv0: Initializing card 0
[    9.552825] ivtv0: Autodetected Hauppauge card (cx23416 based)
[    9.559004] ivtv0: Unreasonably low latency timer, setting to 64 (was 32)
[    9.612885] tveeprom 0-0050: Hauppauge model 26582, rev F0B2, serial# 9496618
[    9.612888] tveeprom 0-0050: tuner model is TCL M2523_5N_E (idx 112, type 50)
[    9.612890] tveeprom 0-0050: TV standards NTSC(M) (eeprom 0x08)
[    9.612892] tveeprom 0-0050: audio processor is CX25843 (idx 37)
[    9.612894] tveeprom 0-0050: decoder processor is CX25843 (idx 30)
[    9.612896] tveeprom 0-0050: has no radio
[    9.612898] ivtv0: Autodetected Hauppauge WinTV PVR-150
[    9.644839] cx25840 0-0044: cx25843-24 found @ 0x88 (ivtv i2c driver #0)
[    9.707407] i2c-core: driver [tuner] using legacy suspend method
[    9.707409] i2c-core: driver [tuner] using legacy resume method
[    9.711219] tuner 0-0061: Tuner -1 found with type(s) Radio TV.
[    9.796496] wm8775 0-001b: chip found @ 0x36 (ivtv i2c driver #0)
[   10.051160] tuner-simple 0-0061: creating new instance
[   10.051163] tuner-simple 0-0061: type set to 50 (TCL 2002N)
[   10.055805] ivtv0: Registered device video0 for encoder MPG (4096 kB)
[   10.055916] ivtv0: Registered device video32 for encoder YUV (2048 kB)
[   10.055968] ivtv0: Registered device vbi0 for encoder VBI (1024 kB)
[   10.056039] ivtv0: Registered device video24 for encoder PCM (320 kB)
[   10.056042] ivtv0: Initialized card: Hauppauge WinTV PVR-150
[   10.056110] ivtv: End initialization
[   10.178966] snd_hda_intel 0000:00:1b.0: irq 44 for MSI/MSI-X
[   10.273371] hda_codec: ALC889A: BIOS auto-probing.
[   10.282818] input: HDA Intel Line as
/devices/pci0000:00/0000:00:1b.0/sound/card0/input5
[   10.282933] input: HDA Intel Front Mic as
/devices/pci0000:00/0000:00:1b.0/sound/card0/input6
[   10.283030] input: HDA Intel Rear Mic as
/devices/pci0000:00/0000:00:1b.0/sound/card0/input7
[   10.283126] input: HDA Intel Front Headphone as
/devices/pci0000:00/0000:00:1b.0/sound/card0/input8
[   10.283222] input: HDA Intel Line Out Side as
/devices/pci0000:00/0000:00:1b.0/sound/card0/input9
[   10.283321] input: HDA Intel Line Out CLFE as
/devices/pci0000:00/0000:00:1b.0/sound/card0/input10
[   10.283420] input: HDA Intel Line Out Surround as
/devices/pci0000:00/0000:00:1b.0/sound/card0/input11
[   10.283513] input: HDA Intel Line Out Front as
/devices/pci0000:00/0000:00:1b.0/sound/card0/input12
[   10.447185] nvidia: module license 'NVIDIA' taints kernel.
[   10.447189] Disabling lock debugging due to kernel taint
[   10.462429] vgaarb: device changed decodes:
PCI:0000:01:00.0,olddecodes=io+mem,decodes=none:owns=io+mem
[   10.462677] NVRM: loading NVIDIA UNIX x86_64 Kernel Module  295.20
Mon Feb  6 21:07:30 PST 2012
[   11.032281] ivtv0: Loaded v4l-cx2341x-enc.fw firmware (376836 bytes)
[   11.232142] ivtv0: Encoder revision: 0x02060039
[   11.399087] type=1400 audit(1332394551.303:2): apparmor="STATUS"
operation="profile_load" name="/sbin/dhclient" pid=921
comm="apparmor_parser"
[   11.399134] type=1400 audit(1332394551.303:3): apparmor="STATUS"
operation="profile_load"
name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=921
comm="apparmor_parser"
[   11.399174] type=1400 audit(1332394551.303:4): apparmor="STATUS"
operation="profile_load"
name="/usr/lib/connman/scripts/dhclient-script" pid=921
comm="apparmor_parser"
[   11.441382] type=1400 audit(1332394551.347:5): apparmor="STATUS"
operation="profile_replace" name="/sbin/dhclient" pid=920
comm="apparmor_parser"
[   11.441430] type=1400 audit(1332394551.347:6): apparmor="STATUS"
operation="profile_replace"
name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=920
comm="apparmor_parser"
[   11.441473] type=1400 audit(1332394551.347:7): apparmor="STATUS"
operation="profile_replace"
name="/usr/lib/connman/scripts/dhclient-script" pid=920
comm="apparmor_parser"
[   12.079407] type=1400 audit(1332394551.983:8): apparmor="STATUS"
operation="profile_load" name="/usr/sbin/ntpd" pid=1067
comm="apparmor_parser"
[   12.093256] type=1400 audit(1332394551.999:9): apparmor="STATUS"
operation="profile_replace" name="/usr/sbin/ntpd" pid=1070
comm="apparmor_parser"
[   12.771878] EXT4-fs (sda3): re-mounted. Opts: errors=remount-ro
[   12.892882] EXT4-fs (sda4): mounted filesystem with ordered data
mode. Opts: (null)
[   12.949866] EXT4-fs (sdb1): mounted filesystem with ordered data
mode. Opts: (null)
[   12.965746] EXT4-fs (sdd1): mounted filesystem with ordered data
mode. Opts: (null)
[   13.220543] EXT4-fs (sda5): mounted filesystem with ordered data
mode. Opts: (null)
[   13.302589] EXT4-fs (sda6): mounted filesystem with ordered data
mode. Opts: (null)
[   14.871166] cx25840 0-0044: loaded v4l-cx25840.fw firmware (16382 bytes)
[   15.199055] type=1400 audit(1332394555.103:10): apparmor="STATUS"
operation="profile_replace" name="/sbin/dhclient" pid=1426
comm="apparmor_parser"
[   15.199104] type=1400 audit(1332394555.103:11): apparmor="STATUS"
operation="profile_replace"
name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=1426
comm="apparmor_parser"
[   15.628803] ppdev: user-space parallel port driver
[   16.232468] eth0:  setting full-duplex.
[   16.744299] audit_printk_skb: 21 callbacks suppressed
[   16.744301] type=1400 audit(1332394556.651:19): apparmor="STATUS"
operation="profile_replace" name="/usr/lib/cups/backend/cups-pdf"
pid=1478 comm="apparmor_parser"
[   16.744432] type=1400 audit(1332394556.651:20): apparmor="STATUS"
operation="profile_replace" name="/usr/sbin/cupsd" pid=1478
comm="apparmor_parser"
[   16.931086] type=1400 audit(1332394556.835:21): apparmor="STATUS"
operation="profile_load" name="/usr/sbin/mysqld" pid=1491
comm="apparmor_parser"
[   17.297313] type=1400 audit(1332394557.203:22): apparmor="STATUS"
operation="profile_load" name="/usr/sbin/mysqld-akonadi" pid=1493
comm="apparmor_parser"
[   17.297449] type=1400 audit(1332394557.203:23): apparmor="STATUS"
operation="profile_load"
name="/usr/sbin/mysqld-akonadi///usr/sbin/mysqld" pid=1493
comm="apparmor_parser"
[   17.471570] type=1400 audit(1332394557.376:24): apparmor="STATUS"
operation="profile_replace" name="/usr/sbin/ntpd" pid=1494
comm="apparmor_parser"
[   17.701579] type=1400 audit(1332394557.608:25): apparmor="STATUS"
operation="profile_load" name="/usr/sbin/tcpdump" pid=1496
comm="apparmor_parser"
[   20.159164] type=1400 audit(1332394560.064:26): apparmor="STATUS"
operation="profile_load" name="/usr/bin/evince" pid=1437
comm="apparmor_parser"
[   20.159631] type=1400 audit(1332394560.064:27): apparmor="STATUS"
operation="profile_load" name="/usr/bin/evince-previewer" pid=1437
comm="apparmor_parser"
[   20.159934] type=1400 audit(1332394560.064:28): apparmor="STATUS"
operation="profile_load" name="/usr/bin/evince-thumbnailer" pid=1437
comm="apparmor_parser"
[   20.513189] init: failsafe main process (1363) killed by TERM signal
[   20.538838] init: apport pre-start process (1597) terminated with status 1
[   20.540405] init: apport post-stop process (1634) terminated with status 1
[   20.558898] init: lxdm main process (1607) killed by TERM signal
[   20.560468] init: gdm main process (1631) killed by TERM signal
[   20.678224] Cannot change disksize for initialized device
[   20.678368] init: zramswap pre-start process (1615) terminated with status 1

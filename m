Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445Ab2BCEaD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 23:30:03 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:50276 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755042Ab2BCE35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 23:29:57 -0500
Date: Fri, 3 Feb 2012 13:29:32 +0900
From: Norbert Preining <preining@logic.at>
To: Lin Ming <ming.m.lin@intel.com>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, jeff@garzik.org,
        Tejun Heo <tj@kernel.org>,
        "stern@rowland.harvard.edu >> Alan Stern" <stern@rowland.harvard.edu>,
        linux-ide@vger.kernel.org,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Regression 3.2 -> 3.3-rc1 10 sec hang at boot and resume,
	COMRESET failed
Message-ID: <20120203042932.GB21988@gamma.logic.tuwien.ac.at>
References: <20120202051258.GA15550@gamma.logic.tuwien.ac.at> <4F2A4B7E.2090503@linux.vnet.ibm.com> <1328231716.15079.15.camel@minggr> <1328242884.15079.22.camel@minggr> <20120202051258.GA15550@gamma.logic.tuwien.ac.at> <4F2A4B7E.2090503@linux.vnet.ibm.com> <1328231716.15079.15.camel@minggr>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="1yeeQ81UyVL57Vl7"
Content-Disposition: inline
In-Reply-To: <1328242884.15079.22.camel@minggr> <1328231716.15079.15.camel@minggr>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1yeeQ81UyVL57Vl7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fr, 03 Feb 2012, Lin Ming wrote:
> Could you attach the full 3.3-rc2 dmesg?

Attached

> And could you do a bisect?

Will try.

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
He dropped his voice still lower. In the stillness, a fly
would not have dared cleat its throat.
                 --- Douglas Adams, The Hitchhikers Guide to the Galaxy

--1yeeQ81UyVL57Vl7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-3.3-rc2"

[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.3.0-rc2+ (norbert@mithrandir) (gcc version 4.6.2 (Debian 4.6.2-12) ) #25 SMP PREEMPT Fri Feb 3 12:53:49 JST 2012
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.3.0-rc2+ root=/dev/sda3 ro rootfstype=ext4 "acpi_osi=!Windows 2006" nmi_watchdog=0
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000ba108000 (usable)
[    0.000000]  BIOS-e820: 00000000ba108000 - 00000000ba10b000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000ba10b000 - 00000000bba6b000 (usable)
[    0.000000]  BIOS-e820: 00000000bba6b000 - 00000000bbabf000 (reserved)
[    0.000000]  BIOS-e820: 00000000bbabf000 - 00000000bbb73000 (usable)
[    0.000000]  BIOS-e820: 00000000bbb73000 - 00000000bbbbf000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bbbbf000 - 00000000bbbe9000 (usable)
[    0.000000]  BIOS-e820: 00000000bbbe9000 - 00000000bbbff000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bbbff000 - 00000000bbc00000 (usable)
[    0.000000]  BIOS-e820: 00000000bbc00000 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000f8000000 - 00000000fc000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed10000 - 00000000fed14000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed18000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffe80000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000140000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] DMI: Sony Corporation VGN-Z11VN_B/VAIO, BIOS R2168M3 03/23/2009
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x140000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 080000000 mask FC0000000 write-back
[    0.000000]   2 base 0BC000000 mask FFC000000 uncachable
[    0.000000]   3 base 0BBC00000 mask FFFC00000 uncachable
[    0.000000]   4 base 100000000 mask FC0000000 write-back
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000bbc00000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xbbc00 max_arch_pfn = 0x400000000
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff88000009a000] 9a000 size 20480
[    0.000000] init_memory_mapping: 0000000000000000-00000000bbc00000
[    0.000000]  0000000000 - 00bbc00000 page 2M
[    0.000000] kernel direct mapping tables up to bbc00000 @ 1fffc000-20000000
[    0.000000] init_memory_mapping: 0000000100000000-0000000140000000
[    0.000000]  0100000000 - 0140000000 page 2M
[    0.000000] kernel direct mapping tables up to 140000000 @ bbbe3000-bbbe9000
[    0.000000] ACPI: RSDP 00000000000fe020 00024 (v02   Sony)
[    0.000000] ACPI: XSDT 00000000bbbfe120 0006C (v01   Sony     VAIO 20090323      01000013)
[    0.000000] ACPI: FACP 00000000bbbfd000 000F4 (v04   Sony     VAIO 20090323 MSFT 01000013)
[    0.000000] ACPI: DSDT 00000000bbbec000 0B012 (v01   Sony     VAIO 20090323 MSFT 01000013)
[    0.000000] ACPI: FACS 00000000bbb92000 00040
[    0.000000] ACPI: HPET 00000000bbbfc000 00038 (v01   Sony     VAIO 20090323 MSFT 01000013)
[    0.000000] ACPI: APIC 00000000bbbfb000 0006C (v01   Sony     VAIO 20090323 MSFT 01000013)
[    0.000000] ACPI: MCFG 00000000bbbfa000 0003C (v01   Sony     VAIO 20090323 MSFT 01000013)
[    0.000000] ACPI: SLIC 00000000bbbf9000 00176 (v01   Sony     VAIO 20090323 MSFT 01000013)
[    0.000000] ACPI: ASF! 00000000bbbf8000 000A5 (v32   Sony     VAIO 20090323 MSFT 01000013)
[    0.000000] ACPI: BOOT 00000000bbbeb000 00028 (v01   Sony     VAIO 20090323 MSFT 01000013)
[    0.000000] ACPI: DBGP 00000000bbbea000 00034 (v01   Sony     VAIO 20090323 MSFT 01000013)
[    0.000000] ACPI: SSDT 00000000bbbe9000 00655 (v01   Sony     VAIO 20090323 INTL 20051117)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000]  [ffffea0000000000-ffffea00045fffff] PMD -> [ffff88013b600000-ffff88013edfffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00140000
[    0.000000] Movable zone start PFN for each node
[    0.000000] Early memory PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000ba108
[    0.000000]     0: 0x000ba10b -> 0x000bba6b
[    0.000000]     0: 0x000bbabf -> 0x000bbb73
[    0.000000]     0: 0x000bbbbf -> 0x000bbbe9
[    0.000000]     0: 0x000bbbff -> 0x000bbc00
[    0.000000]     0: 0x00100000 -> 0x00140000
[    0.000000] On node 0 totalpages: 1030870
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 5 pages reserved
[    0.000000]   DMA zone: 3922 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 750463 pages, LIFO batch:31
[    0.000000]   Normal zone: 3584 pages used for memmap
[    0.000000]   Normal zone: 258560 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x00] disabled)
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 2 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000ba108000 - 00000000ba10b000
[    0.000000] PM: Registered nosave memory: 00000000bba6b000 - 00000000bbabf000
[    0.000000] PM: Registered nosave memory: 00000000bbb73000 - 00000000bbbbf000
[    0.000000] PM: Registered nosave memory: 00000000bbbe9000 - 00000000bbbff000
[    0.000000] PM: Registered nosave memory: 00000000bbc00000 - 00000000c0000000
[    0.000000] PM: Registered nosave memory: 00000000c0000000 - 00000000f8000000
[    0.000000] PM: Registered nosave memory: 00000000f8000000 - 00000000fc000000
[    0.000000] PM: Registered nosave memory: 00000000fc000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec01000
[    0.000000] PM: Registered nosave memory: 00000000fec01000 - 00000000fed10000
[    0.000000] PM: Registered nosave memory: 00000000fed10000 - 00000000fed14000
[    0.000000] PM: Registered nosave memory: 00000000fed14000 - 00000000fed18000
[    0.000000] PM: Registered nosave memory: 00000000fed18000 - 00000000fed1a000
[    0.000000] PM: Registered nosave memory: 00000000fed1a000 - 00000000fed1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed20000
[    0.000000] PM: Registered nosave memory: 00000000fed20000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ffe80000
[    0.000000] PM: Registered nosave memory: 00000000ffe80000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at c0000000 (gap: c0000000:38000000)
[    0.000000] setup_percpu: NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 26 pages/cpu @ffff88013fc00000 s76288 r8192 d22016 u524288
[    0.000000] pcpu-alloc: s76288 r8192 d22016 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1012945
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.3.0-rc2+ root=/dev/sda3 ro rootfstype=ext4 "acpi_osi=!Windows 2006" nmi_watchdog=0
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.000000] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 3983528k/5242880k available (4467k kernel code, 1119400k absent, 139952k reserved, 4157k data, 492k init)
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:712 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2526.965 MHz processor.
[    0.004004] Calibrating delay loop (skipped), value calculated using timer frequency.. 5053.93 BogoMIPS (lpj=10107860)
[    0.004109] pid_max: default: 32768 minimum: 301
[    0.004210] Mount-cache hash table entries: 256
[    0.004383] Initializing cgroup subsys debug
[    0.004460] CPU: Physical Processor ID: 0
[    0.004511] CPU: Processor Core ID: 0
[    0.004562] mce: CPU supports 6 MCE banks
[    0.004617] CPU0: Thermal monitoring handled by SMI
[    0.004621] using mwait in idle threads.
[    0.004704] ACPI: Core revision 20120111
[    0.016444] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.057915] CPU0: Intel(R) Core(TM)2 Duo CPU     P9500  @ 2.53GHz stepping 06
[    0.060003] Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
[    0.060003] ... version:                2
[    0.060003] ... bit width:              40
[    0.060003] ... generic registers:      2
[    0.060003] ... value mask:             000000ffffffffff
[    0.060003] ... max period:             000000007fffffff
[    0.060003] ... fixed-purpose events:   3
[    0.060003] ... event mask:             0000000700000003
[    0.084020] Booting Node   0, Processors  #1
[    0.084097] smpboot cpu 1: start_ip = 9a000
[    0.008000] CPU1: Thermal monitoring handled by SMI
[    0.096024] Brought up 2 CPUs
[    0.096076] Total of 2 processors activated (10107.86 BogoMIPS).
[    0.100195] PM: Registering ACPI NVS region at ba108000 (12288 bytes)
[    0.100254] PM: Registering ACPI NVS region at bbb73000 (311296 bytes)
[    0.100433] NET: Registered protocol family 16
[    0.100505] ACPI: bus type pci registered
[    0.100505] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.100505] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.112011] PCI: Using configuration type 1 for base access
[    0.116047] bio: create slab <bio-0> at 0
[    0.116119] ACPI: Added _OSI(Module Device)
[    0.116119] ACPI: Added _OSI(Processor Device)
[    0.116123] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.116123] ACPI: Added _OSI(Processor Aggregator Device)
[    0.116123] ACPI: Deleted _OSI(Windows 2006)
[    0.117931] ACPI: EC: Look up EC in DSDT
[    0.119753] ACPI: Executed 1 blocks of module-level executable AML code
[    0.121404] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.138361] ACPI: SSDT 00000000bba6ec18 00265 (v01   Sony     VAIO 20090323 INTL 20051117)
[    0.138931] ACPI: Dynamic OEM Table Load:
[    0.139052] ACPI: SSDT           (null) 00265 (v01   Sony     VAIO 20090323 INTL 20051117)
[    0.139350] ACPI: SSDT 00000000bba6c618 005B8 (v01   Sony     VAIO 20090323 INTL 20051117)
[    0.139902] ACPI: Dynamic OEM Table Load:
[    0.140032] ACPI: SSDT           (null) 005B8 (v01   Sony     VAIO 20090323 INTL 20051117)
[    0.168307] ACPI: SSDT 00000000bba6de18 001CF (v01   Sony     VAIO 20090323 INTL 20051117)
[    0.168895] ACPI: Dynamic OEM Table Load:
[    0.169016] ACPI: SSDT           (null) 001CF (v01   Sony     VAIO 20090323 INTL 20051117)
[    0.176142] ACPI: SSDT 00000000bba6ef18 0008D (v01   Sony     VAIO 20090323 INTL 20051117)
[    0.180285] ACPI: Dynamic OEM Table Load:
[    0.180406] ACPI: SSDT           (null) 0008D (v01   Sony     VAIO 20090323 INTL 20051117)
[    0.396062] ACPI: Interpreter enabled
[    0.396116] ACPI: (supports S0 S3 S4 S5)
[    0.396334] ACPI: Using IOAPIC for interrupt routing
[    0.400513] ACPI: Power Resource [MGPR] (on)
[    0.400513] ACPI: Power Resource [DGPR] (on)
[    0.408324] ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
[    0.408798] ACPI: ACPI Dock Station Driver: 1 docks/bays found
[    0.408854] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.412462] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.413112] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.413167] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.413222] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.413289] pci_root PNP0A08:00: host bridge window [mem 0xc0000000-0xfebfffff]
[    0.413354] pci_root PNP0A08:00: host bridge window [mem 0xfed40000-0xfed44fff]
[    0.413458] PCI host bridge to bus 0000:00
[    0.413458] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.413458] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.413458] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.413458] pci_bus 0000:00: root bus resource [mem 0xc0000000-0xfebfffff]
[    0.413458] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed44fff]
[    0.413458] pci 0000:00:00.0: [8086:2a40] type 0 class 0x000600
[    0.413458] DMAR: Forcing write-buffer flush capability
[    0.413458] DMAR: Disabling IOMMU for graphics on this chipset
[    0.413458] pci 0000:00:02.0: [8086:2a42] type 0 class 0x000300
[    0.413458] pci 0000:00:02.0: reg 10: [mem 0xd4400000-0xd47fffff 64bit]
[    0.413458] pci 0000:00:02.0: reg 18: [mem 0xc0000000-0xcfffffff 64bit pref]
[    0.413458] pci 0000:00:02.0: reg 20: [io  0x7130-0x7137]
[    0.413458] pci 0000:00:02.1: [8086:2a43] type 0 class 0x000380
[    0.413458] pci 0000:00:02.1: reg 10: [mem 0xd7800000-0xd78fffff 64bit]
[    0.413458] pci 0000:00:19.0: [8086:10f5] type 0 class 0x000200
[    0.413458] pci 0000:00:19.0: reg 10: [mem 0xdaa00000-0xdaa1ffff]
[    0.413458] pci 0000:00:19.0: reg 14: [mem 0xdaa24000-0xdaa24fff]
[    0.413458] pci 0000:00:19.0: reg 18: [io  0x7100-0x711f]
[    0.413458] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.413458] pci 0000:00:1a.0: [8086:2937] type 0 class 0x000c03
[    0.413458] pci 0000:00:1a.0: reg 20: [io  0x70e0-0x70ff]
[    0.413458] pci 0000:00:1a.1: [8086:2938] type 0 class 0x000c03
[    0.413458] pci 0000:00:1a.1: reg 20: [io  0x70c0-0x70df]
[    0.413458] pci 0000:00:1a.2: [8086:2939] type 0 class 0x000c03
[    0.413458] pci 0000:00:1a.2: reg 20: [io  0x70a0-0x70bf]
[    0.413458] pci 0000:00:1a.7: [8086:293c] type 0 class 0x000c03
[    0.417919] pci 0000:00:1a.7: reg 10: [mem 0xdaa25c00-0xdaa25fff]
[    0.440079] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.440108] pci 0000:00:1b.0: [8086:293e] type 0 class 0x000403
[    0.440124] pci 0000:00:1b.0: reg 10: [mem 0xdaa20000-0xdaa23fff 64bit]
[    0.440198] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.440220] pci 0000:00:1c.0: [8086:2940] type 1 class 0x000604
[    0.440296] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.440320] pci 0000:00:1c.1: [8086:2942] type 1 class 0x000604
[    0.440396] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.440421] pci 0000:00:1c.3: [8086:2946] type 1 class 0x000604
[    0.440497] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.440526] pci 0000:00:1d.0: [8086:2934] type 0 class 0x000c03
[    0.440589] pci 0000:00:1d.0: reg 20: [io  0x7080-0x709f]
[    0.440657] pci 0000:00:1d.1: [8086:2935] type 0 class 0x000c03
[    0.440712] pci 0000:00:1d.1: reg 20: [io  0x7060-0x707f]
[    0.440786] pci 0000:00:1d.2: [8086:2936] type 0 class 0x000c03
[    0.440848] pci 0000:00:1d.2: reg 20: [io  0x7040-0x705f]
[    0.440928] pci 0000:00:1d.7: [8086:293a] type 0 class 0x000c03
[    0.445921] pci 0000:00:1d.7: reg 10: [mem 0xdaa25800-0xdaa25bff]
[    0.468076] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.468100] pci 0000:00:1e.0: [8086:2448] type 1 class 0x000604
[    0.468168] pci 0000:00:1f.0: [8086:2917] type 0 class 0x000601
[    0.468296] pci 0000:00:1f.2: [8086:2929] type 0 class 0x000106
[    0.468316] pci 0000:00:1f.2: reg 10: [io  0x7128-0x712f]
[    0.468325] pci 0000:00:1f.2: reg 14: [io  0x713c-0x713f]
[    0.468334] pci 0000:00:1f.2: reg 18: [io  0x7120-0x7127]
[    0.468342] pci 0000:00:1f.2: reg 1c: [io  0x7138-0x713b]
[    0.468351] pci 0000:00:1f.2: reg 20: [io  0x7020-0x703f]
[    0.468360] pci 0000:00:1f.2: reg 24: [mem 0xdaa25000-0xdaa257ff]
[    0.468409] pci 0000:00:1f.2: PME# supported from D3hot
[    0.468428] pci 0000:00:1f.3: [8086:2930] type 0 class 0x000c05
[    0.468445] pci 0000:00:1f.3: reg 10: [mem 0xdaa26000-0xdaa260ff 64bit]
[    0.468468] pci 0000:00:1f.3: reg 20: [io  0x7000-0x701f]
[    0.468538] pci 0000:00:1c.0: PCI bridge to [bus 02-05]
[    0.468593] pci 0000:00:1c.0:   bridge window [io  0x6000-0x6fff]
[    0.468598] pci 0000:00:1c.0:   bridge window [mem 0xd9a00000-0xda9fffff]
[    0.468604] pci 0000:00:1c.0:   bridge window [mem 0xd4800000-0xd57fffff 64bit pref]
[    0.468707] pci 0000:06:00.0: [8086:4232] type 0 class 0x000280
[    0.468745] pci 0000:06:00.0: reg 10: [mem 0xd8900000-0xd8901fff 64bit]
[    0.468919] pci 0000:06:00.0: PME# supported from D0 D3hot D3cold
[    0.476069] pci 0000:00:1c.1: PCI bridge to [bus 06-06]
[    0.476124] pci 0000:00:1c.1:   bridge window [io  0x5000-0x5fff]
[    0.476128] pci 0000:00:1c.1:   bridge window [mem 0xd8900000-0xd99fffff]
[    0.476134] pci 0000:00:1c.1:   bridge window [mem 0xd5800000-0xd67fffff 64bit pref]
[    0.476177] pci 0000:00:1c.3: PCI bridge to [bus 08-08]
[    0.476232] pci 0000:00:1c.3:   bridge window [io  0x4000-0x4fff]
[    0.476236] pci 0000:00:1c.3:   bridge window [mem 0xd7900000-0xd88fffff]
[    0.476242] pci 0000:00:1c.3:   bridge window [mem 0xd6800000-0xd77fffff 64bit pref]
[    0.476283] pci 0000:0b:04.0: [1180:0476] type 2 class 0x000607
[    0.476303] pci 0000:0b:04.0: reg 10: [mem 0xd4000000-0xd4000fff]
[    0.476334] pci 0000:0b:04.0: supports D1 D2
[    0.476336] pci 0000:0b:04.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.476358] pci 0000:0b:04.1: [1180:0832] type 0 class 0x000c00
[    0.476377] pci 0000:0b:04.1: reg 10: [mem 0xd4001000-0xd40017ff]
[    0.476462] pci 0000:0b:04.1: PME# supported from D0 D3hot D3cold
[    0.476484] pci 0000:0b:04.2: [1180:0822] type 0 class 0x000805
[    0.476504] pci 0000:0b:04.2: reg 10: [mem 0xd4001900-0xd40019ff]
[    0.476592] pci 0000:0b:04.2: supports D1 D2
[    0.476594] pci 0000:0b:04.2: PME# supported from D0 D1 D2 D3hot D3cold
[    0.476618] pci 0000:0b:04.4: [1180:0592] type 0 class 0x000880
[    0.476638] pci 0000:0b:04.4: reg 10: [mem 0xd4001800-0xd40018ff]
[    0.476726] pci 0000:0b:04.4: supports D1 D2
[    0.476728] pci 0000:0b:04.4: PME# supported from D0 D1 D2 D3hot D3cold
[    0.476782] pci 0000:00:1e.0: PCI bridge to [bus 0b-0c] (subtractive decode)
[    0.476839] pci 0000:00:1e.0:   bridge window [io  0x3000-0x3fff]
[    0.476843] pci 0000:00:1e.0:   bridge window [mem 0xd2000000-0xd40fffff]
[    0.476849] pci 0000:00:1e.0:   bridge window [mem 0xd0000000-0xd1ffffff 64bit pref]
[    0.476852] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.476855] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.476857] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.476860] pci 0000:00:1e.0:   bridge window [mem 0xc0000000-0xfebfffff] (subtractive decode)
[    0.476862] pci 0000:00:1e.0:   bridge window [mem 0xfed40000-0xfed44fff] (subtractive decode)
[    0.476900] pci_bus 0000:0c: [bus 0c-0f] partially hidden behind transparent bridge 0000:0b [bus 0b-0c]
[    0.476987] pci_bus 0000:00: on NUMA node 0
[    0.476990] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.477168] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P32_._PRT]
[    0.477252] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
[    0.477317] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP2._PRT]
[    0.477356] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP4._PRT]
[    0.477458]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.477565]  pci0000:00: ACPI _OSC request failed (AE_SUPPORT), returned control mask: 0x00
[    0.477633] ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.488391] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 9 *10 11 12)
[    0.488548] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 9 *10 11 12)
[    0.489004] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 9 *10 11 12)
[    0.489458] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 9 *10 11 12)
[    0.489912] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 9 *10 11 12)
[    0.490365] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 9 *10 11 12)
[    0.490819] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 9 *10 11 12)
[    0.492443] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 9 *10 11 12)
[    0.492877] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.492877] vgaarb: loaded
[    0.492877] vgaarb: bridge control possible 0000:00:02.0
[    0.492877] SCSI subsystem initialized
[    0.492877] libata version 3.00 loaded.
[    0.492877] usbcore: registered new interface driver usbfs
[    0.492877] usbcore: registered new interface driver hub
[    0.492877] usbcore: registered new device driver usb
[    0.492877] wmi: Mapper loaded
[    0.492877] PCI: Using ACPI for IRQ routing
[    0.496603] PCI: pci_cache_line_size set to 64 bytes
[    0.496744] reserve RAM buffer: 000000000009fc00 - 000000000009ffff 
[    0.496747] reserve RAM buffer: 00000000ba108000 - 00000000bbffffff 
[    0.496751] reserve RAM buffer: 00000000bba6b000 - 00000000bbffffff 
[    0.496754] reserve RAM buffer: 00000000bbb73000 - 00000000bbffffff 
[    0.496757] reserve RAM buffer: 00000000bbbe9000 - 00000000bbffffff 
[    0.496760] reserve RAM buffer: 00000000bbc00000 - 00000000bbffffff 
[    0.496775] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    0.496775] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.496775] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.504048] Switching to clocksource hpet
[    0.506971] pnp: PnP ACPI init
[    0.507033] ACPI: bus type pnp registered
[    0.507834] pnp 00:00: [bus 00-ff]
[    0.507837] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.507839] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.507841] pnp 00:00: [io  0x0d00-0xffff window]
[    0.507844] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.507846] pnp 00:00: [mem 0x000c0000-0x000c3fff window]
[    0.507848] pnp 00:00: [mem 0x000c4000-0x000c7fff window]
[    0.507851] pnp 00:00: [mem 0x000c8000-0x000cbfff window]
[    0.507853] pnp 00:00: [mem 0x000cc000-0x000cffff window]
[    0.507855] pnp 00:00: [mem 0x000d0000-0x000d3fff window]
[    0.507857] pnp 00:00: [mem 0x000d4000-0x000d7fff window]
[    0.507859] pnp 00:00: [mem 0x000d8000-0x000dbfff window]
[    0.507861] pnp 00:00: [mem 0x000dc000-0x000dffff window]
[    0.507863] pnp 00:00: [mem 0x000e0000-0x000e3fff window]
[    0.507865] pnp 00:00: [mem 0x000e4000-0x000e7fff window]
[    0.507868] pnp 00:00: [mem 0x000e8000-0x000ebfff window]
[    0.507870] pnp 00:00: [mem 0x000ec000-0x000effff window]
[    0.507872] pnp 00:00: [mem 0x000f0000-0x000fffff window]
[    0.507874] pnp 00:00: [mem 0xc0000000-0xfebfffff window]
[    0.507876] pnp 00:00: [mem 0xfed40000-0xfed44fff window]
[    0.507961] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    0.508519] pnp 00:01: [io  0x002e-0x002f]
[    0.508521] pnp 00:01: [io  0x004e-0x004f]
[    0.508525] pnp 00:01: [io  0x164e-0x164f]
[    0.508526] pnp 00:01: [io  0x0061]
[    0.508528] pnp 00:01: [io  0x0070]
[    0.508530] pnp 00:01: [io  0x0080]
[    0.508531] pnp 00:01: [io  0x0092]
[    0.508533] pnp 00:01: [io  0x00b2-0x00b3]
[    0.508535] pnp 00:01: [io  0x0063]
[    0.508537] pnp 00:01: [io  0x0065]
[    0.508538] pnp 00:01: [io  0x0067]
[    0.508540] pnp 00:01: [io  0x0600-0x060f]
[    0.508542] pnp 00:01: [io  0x0610]
[    0.508544] pnp 00:01: [io  0x0800-0x080f]
[    0.508546] pnp 00:01: [io  0x0810-0x0817]
[    0.508547] pnp 00:01: [io  0x0820-0x0823]
[    0.508549] pnp 00:01: [io  0x0400-0x047f]
[    0.508551] pnp 00:01: [io  0x0500-0x053f]
[    0.508553] pnp 00:01: [io  0x2000]
[    0.508555] pnp 00:01: [io  0x2004]
[    0.508557] pnp 00:01: [mem 0xf8000000-0xfbffffff]
[    0.508559] pnp 00:01: [mem 0xfed1c000-0xfed1ffff]
[    0.508561] pnp 00:01: [mem 0xfed10000-0xfed13fff]
[    0.508563] pnp 00:01: [mem 0xfed18000-0xfed18fff]
[    0.508565] pnp 00:01: [mem 0xfed19000-0xfed19fff]
[    0.508567] pnp 00:01: [mem 0xfec00000-0xfec00fff]
[    0.508569] pnp 00:01: [mem 0xfed20000-0xfed3ffff]
[    0.508571] pnp 00:01: [mem 0xfed45000-0xfed8ffff]
[    0.508572] pnp 00:01: [mem 0xfee00000-0xfee00fff]
[    0.508685] system 00:01: [io  0x164e-0x164f] has been reserved
[    0.508740] system 00:01: [io  0x0600-0x060f] has been reserved
[    0.508794] system 00:01: [io  0x0610] has been reserved
[    0.508847] system 00:01: [io  0x0800-0x080f] has been reserved
[    0.508901] system 00:01: [io  0x0810-0x0817] has been reserved
[    0.508955] system 00:01: [io  0x0820-0x0823] has been reserved
[    0.509009] system 00:01: [io  0x0400-0x047f] has been reserved
[    0.509063] system 00:01: [io  0x0500-0x053f] has been reserved
[    0.509117] system 00:01: [io  0x2000] has been reserved
[    0.509171] system 00:01: [io  0x2004] has been reserved
[    0.509225] system 00:01: [mem 0xf8000000-0xfbffffff] has been reserved
[    0.509280] system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.509335] system 00:01: [mem 0xfed10000-0xfed13fff] has been reserved
[    0.509390] system 00:01: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.509446] system 00:01: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.509502] system 00:01: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.509557] system 00:01: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.509613] system 00:01: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.509668] system 00:01: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.509724] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.509736] pnp 00:02: [io  0x0000-0x001f]
[    0.509738] pnp 00:02: [io  0x0081-0x0091]
[    0.509741] pnp 00:02: [io  0x0093-0x009f]
[    0.509743] pnp 00:02: [io  0x00c0-0x00df]
[    0.509745] pnp 00:02: [dma 4]
[    0.509803] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.509822] pnp 00:03: [io  0x0070-0x0077]
[    0.509831] pnp 00:03: [irq 8]
[    0.509890] pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.509956] pnp 00:04: [mem 0xfed00000-0xfed003ff]
[    0.510014] pnp 00:04: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.510027] pnp 00:05: [io  0x00f0]
[    0.510032] pnp 00:05: [irq 13]
[    0.510093] pnp 00:05: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.510105] pnp 00:06: [mem 0xff800000-0xffffffff]
[    0.510164] pnp 00:06: Plug and Play ACPI device, IDs INT0800 (active)
[    0.510182] pnp 00:07: [io  0x0060]
[    0.510184] pnp 00:07: [io  0x0064]
[    0.510189] pnp 00:07: [irq 1]
[    0.510248] pnp 00:07: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.510270] pnp 00:08: [irq 12]
[    0.510331] pnp 00:08: Plug and Play ACPI device, IDs SNY9001 PNP0f13 (active)
[    0.510436] pnp 00:09: Plug and Play ACPI device, IDs SNY6001 (disabled)
[    0.510463] pnp 00:0a: [mem 0xfed40000-0xfed44fff]
[    0.510524] pnp 00:0a: Plug and Play ACPI device, IDs IFX0102 PNP0c31 (active)
[    0.510615] pnp: PnP ACPI: found 11 devices
[    0.510666] ACPI: ACPI bus type pnp unregistered
[    0.518603] PCI: max bus depth: 2 pci_try_num: 3
[    0.518639] pci 0000:00:1c.0: PCI bridge to [bus 02-05]
[    0.518694] pci 0000:00:1c.0:   bridge window [io  0x6000-0x6fff]
[    0.518751] pci 0000:00:1c.0:   bridge window [mem 0xd9a00000-0xda9fffff]
[    0.518807] pci 0000:00:1c.0:   bridge window [mem 0xd4800000-0xd57fffff 64bit pref]
[    0.518877] pci 0000:00:1c.1: PCI bridge to [bus 06-06]
[    0.518931] pci 0000:00:1c.1:   bridge window [io  0x5000-0x5fff]
[    0.518988] pci 0000:00:1c.1:   bridge window [mem 0xd8900000-0xd99fffff]
[    0.519045] pci 0000:00:1c.1:   bridge window [mem 0xd5800000-0xd67fffff 64bit pref]
[    0.519115] pci 0000:00:1c.3: PCI bridge to [bus 08-08]
[    0.519168] pci 0000:00:1c.3:   bridge window [io  0x4000-0x4fff]
[    0.519225] pci 0000:00:1c.3:   bridge window [mem 0xd7900000-0xd88fffff]
[    0.519282] pci 0000:00:1c.3:   bridge window [mem 0xd6800000-0xd77fffff 64bit pref]
[    0.519355] pci 0000:0b:04.0: BAR 10: assigned [mem 0xdc000000-0xdfffffff]
[    0.519413] pci 0000:0b:04.0: BAR 9: assigned [mem 0xe0000000-0xe3ffffff pref]
[    0.519479] pci 0000:0b:04.0: BAR 8: assigned [io  0x3000-0x30ff]
[    0.519533] pci 0000:0b:04.0: BAR 7: assigned [io  0x3400-0x34ff]
[    0.519587] pci 0000:0b:04.0: CardBus bridge to [bus 0c-0f]
[    0.519640] pci 0000:0b:04.0:   bridge window [io  0x3400-0x34ff]
[    0.519696] pci 0000:0b:04.0:   bridge window [io  0x3000-0x30ff]
[    0.519753] pci 0000:0b:04.0:   bridge window [mem 0xe0000000-0xe3ffffff pref]
[    0.519820] pci 0000:0b:04.0:   bridge window [mem 0xdc000000-0xdfffffff]
[    0.519878] pci 0000:00:1e.0: PCI bridge to [bus 0b-0c]
[    0.519932] pci 0000:00:1e.0:   bridge window [io  0x3000-0x3fff]
[    0.519989] pci 0000:00:1e.0:   bridge window [mem 0xd2000000-0xd40fffff]
[    0.520058] pci 0000:00:1e.0:   bridge window [mem 0xd0000000-0xd1ffffff 64bit pref]
[    0.520132] pci 0000:00:1c.0: enabling device (0000 -> 0003)
[    0.520205] pci 0000:00:1c.3: enabling device (0000 -> 0003)
[    0.520267] pci 0000:00:1e.0: setting latency timer to 64
[    0.520282] pci 0000:0b:04.0: setting latency timer to 64
[    0.520286] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.520288] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.520290] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.520292] pci_bus 0000:00: resource 7 [mem 0xc0000000-0xfebfffff]
[    0.520295] pci_bus 0000:00: resource 8 [mem 0xfed40000-0xfed44fff]
[    0.520297] pci_bus 0000:02: resource 0 [io  0x6000-0x6fff]
[    0.520299] pci_bus 0000:02: resource 1 [mem 0xd9a00000-0xda9fffff]
[    0.520302] pci_bus 0000:02: resource 2 [mem 0xd4800000-0xd57fffff 64bit pref]
[    0.520304] pci_bus 0000:06: resource 0 [io  0x5000-0x5fff]
[    0.520306] pci_bus 0000:06: resource 1 [mem 0xd8900000-0xd99fffff]
[    0.520308] pci_bus 0000:06: resource 2 [mem 0xd5800000-0xd67fffff 64bit pref]
[    0.520311] pci_bus 0000:08: resource 0 [io  0x4000-0x4fff]
[    0.520313] pci_bus 0000:08: resource 1 [mem 0xd7900000-0xd88fffff]
[    0.520315] pci_bus 0000:08: resource 2 [mem 0xd6800000-0xd77fffff 64bit pref]
[    0.520318] pci_bus 0000:0b: resource 0 [io  0x3000-0x3fff]
[    0.520320] pci_bus 0000:0b: resource 1 [mem 0xd2000000-0xd40fffff]
[    0.520322] pci_bus 0000:0b: resource 2 [mem 0xd0000000-0xd1ffffff 64bit pref]
[    0.520324] pci_bus 0000:0b: resource 4 [io  0x0000-0x0cf7]
[    0.520327] pci_bus 0000:0b: resource 5 [io  0x0d00-0xffff]
[    0.520329] pci_bus 0000:0b: resource 6 [mem 0x000a0000-0x000bffff]
[    0.520331] pci_bus 0000:0b: resource 7 [mem 0xc0000000-0xfebfffff]
[    0.520333] pci_bus 0000:0b: resource 8 [mem 0xfed40000-0xfed44fff]
[    0.520335] pci_bus 0000:0c: resource 0 [io  0x3400-0x34ff]
[    0.520338] pci_bus 0000:0c: resource 1 [io  0x3000-0x30ff]
[    0.520340] pci_bus 0000:0c: resource 2 [mem 0xe0000000-0xe3ffffff pref]
[    0.520342] pci_bus 0000:0c: resource 3 [mem 0xdc000000-0xdfffffff]
[    0.520392] NET: Registered protocol family 2
[    0.520507] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.521024] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.522646] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.523131] TCP: Hash tables configured (established 262144 bind 65536)
[    0.523186] TCP reno registered
[    0.523238] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.523320] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.523483] NET: Registered protocol family 1
[    0.523552] pci 0000:00:02.0: Boot video device
[    0.556066] PCI: CLS 64 bytes, default 64
[    0.556118] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.556175] Placing 64MB software IO TLB between ffff8800b6108000 - ffff8800ba108000
[    0.556243] software IO TLB at phys 0xb6108000 - 0xba108000
[    0.556304] Simple Boot Flag value 0x5 read from CMOS RAM was invalid
[    0.556360] Simple Boot Flag at 0x44 set to 0x1
[    0.557062] microcode: CPU0 sig=0x10676, pf=0x80, revision=0x60c
[    0.557123] microcode: CPU1 sig=0x10676, pf=0x80, revision=0x60c
[    0.557222] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.557552] audit: initializing netlink socket (disabled)
[    0.557616] type=2000 audit(1328275443.552:1): initialized
[    0.558607] NTFS driver 2.1.30 [Flags: R/O].
[    0.558694] msgmni has been set to 7780
[    0.558933] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.559001] io scheduler noop registered
[    0.559053] io scheduler deadline registered
[    0.559119] io scheduler cfq registered (default)
[    0.559323] pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
[    0.559468] pcieport 0000:00:1c.1: irq 41 for MSI/MSI-X
[    0.559608] pcieport 0000:00:1c.3: irq 42 for MSI/MSI-X
[    0.560096] intel_idle: MWAIT substates: 0x3122220
[    0.560099] intel_idle: does not run on family 6 model 23
[    0.560532] ACPI: Deprecated procfs I/F for AC is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    0.560880] ACPI: AC Adapter [AC] (on-line)
[    0.561608] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[    0.561680] ACPI: Power Button [PWRB]
[    0.561805] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input1
[    0.562106] ACPI: Lid Switch [LID0]
[    0.562407] Monitor-Mwait will be used to enter C-1 state
[    0.562431] Monitor-Mwait will be used to enter C-2 state
[    0.562437] Marking TSC unstable due to TSC halts in idle
[    0.562498] ACPI: acpi_idle registered with cpuidle
[    0.566109] thermal LNXTHERM:00: registered as thermal_zone0
[    0.566165] ACPI: Thermal Zone [ATF0] (61 C)
[    0.568626] Non-volatile memory driver v1.3
[    0.568793] Linux agpgart interface v0.103
[    0.570205] ACPI: Deprecated procfs I/F for battery is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    0.570281] ACPI: Battery Slot [BAT0] (battery present)
[    0.570289] agpgart-intel 0000:00:00.0: Intel GM45 Chipset
[    0.570409] agpgart-intel 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
[    0.572500] agpgart-intel 0000:00:00.0: detected 65536K stolen memory
[    0.572704] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xc0000000
[    0.572936] tpm_tis 00:0a: 1.2 TPM (device-id 0xB, rev-id 16)
[    1.244070] tpm_tis 00:0a: Adjusting TPM timeout parameters.
[    2.024038] tpm_tis 00:0a: A TPM error (7) occurred attempting to read a pcr value
[    2.024152] tpm_tis 00:0a: TPM is disabled/deactivated (0x7)
[    2.024299] [drm] Initialized drm 1.1.0 20060810
[    2.024372] i915 0000:00:02.0: power state changed by ACPI to D0
[    2.024429] i915 0000:00:02.0: power state changed by ACPI to D0
[    2.024490] i915 0000:00:02.0: setting latency timer to 64
[    2.076412] i915 0000:00:02.0: irq 43 for MSI/MSI-X
[    2.076423] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    2.076481] [drm] Driver supports precise vblank timestamp query.
[    2.076601] [drm:intel_dsm_pci_probe] *ERROR* failed to get supported _DSM functions
[    2.076688] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    2.697829] fbcon: inteldrmfb (fb0) is primary device
[    2.699378] [drm] Changing LVDS panel from (+hsync, +vsync) to (-hsync, -vsync)
[    3.329575] Console: switching to colour frame buffer device 200x56
[    3.334056] fb0: inteldrmfb frame buffer device
[    3.334058] drm: registered panic notifier
[    3.353541] acpi device:01: registered as cooling_device2
[    3.353711] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input2
[    3.353767] ACPI: Video Device [OVGA] (multi-head: yes  rom: no  post: no)
[    3.353884] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    3.356017] brd: module loaded
[    3.356233] ahci 0000:00:1f.2: version 3.0
[    3.356287] ahci 0000:00:1f.2: irq 44 for MSI/MSI-X
[    3.356326] ahci: SSS flag set, parallel bus scan disabled
[    3.356391] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 4 ports 3 Gbps 0x33 impl SATA mode
[    3.356439] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part ccc ems 
[    3.356490] ahci 0000:00:1f.2: setting latency timer to 64
[    3.381077] scsi0 : ahci
[    3.381243] scsi1 : ahci
[    3.381389] scsi2 : ahci
[    3.381529] scsi3 : ahci
[    3.381668] scsi4 : ahci
[    3.381806] scsi5 : ahci
[    3.382271] ata1: SATA max UDMA/133 abar m2048@0xdaa25000 port 0xdaa25100 irq 44
[    3.382317] ata2: SATA max UDMA/133 abar m2048@0xdaa25000 port 0xdaa25180 irq 44
[    3.382360] ata3: DUMMY
[    3.382376] ata4: DUMMY
[    3.382394] ata5: SATA max UDMA/133 abar m2048@0xdaa25000 port 0xdaa25300 irq 44
[    3.382437] ata6: SATA max UDMA/133 abar m2048@0xdaa25000 port 0xdaa25380 irq 44
[    3.382613] e1000e: Intel(R) PRO/1000 Network Driver - 1.5.1-k
[    3.382649] e1000e: Copyright(c) 1999 - 2011 Intel Corporation.
[    3.382705] e1000e 0000:00:19.0: setting latency timer to 64
[    3.382809] e1000e 0000:00:19.0: irq 45 for MSI/MSI-X
[    3.572127] e1000e 0000:00:19.0: eth0: (PCI Express:2.5GT/s:Width x1) 00:1a:80:d7:59:37
[    3.573426] e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    3.574712] e1000e 0000:00:19.0: eth0: MAC: 7, PHY: 8, PBA No: FFFFFF-0FF
[    3.576033] igbvf: Intel(R) Gigabit Virtual Function Network Driver - version 2.0.1-k
[    3.577318] igbvf: Copyright (c) 2009 - 2011 Intel Corporation.
[    3.578676] yenta_cardbus 0000:0b:04.0: CardBus bridge found [104d:9025]
[    3.700024] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    3.702223] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    3.703665] ata1.00: ATA-8: WDC WD10JPVT-00A1YT0, 01.01A01, max UDMA/133
[    3.704963] ata1.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    3.707189] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    3.708652] ata1.00: configured for UDMA/133
[    3.710077] scsi 0:0:0:0: Direct-Access     ATA      WDC WD10JPVT-00A 01.0 PQ: 0 ANSI: 5
[    3.711647] sd 0:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    3.713074] sd 0:0:0:0: [sda] 4096-byte physical blocks
[    3.714514] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    3.715976] sd 0:0:0:0: [sda] Write Protect is off
[    3.717367] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.717390] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.761434]  sda: sda1 sda2 sda3 sda4
[    3.763223] sd 0:0:0:0: [sda] Attached SCSI disk
[    9.072013] ata2: link is slow to respond, please be patient (ready=0)
[   13.720011] ata2: COMRESET failed (errno=-16)
[   14.040021] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   14.044657] ata2.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by device (Stat=0x51 Err=0x04)
[   14.046116] ata2.00: ATAPI: MATSHITADVD-RAM UJ862AS, 1.21, max UDMA/33
[   14.050188] ata2.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by device (Stat=0x51 Err=0x04)
[   14.051640] ata2.00: configured for UDMA/33
[   14.056946] scsi 1:0:0:0: CD-ROM            MATSHITA DVD-RAM UJ862AS  1.21 PQ: 0 ANSI: 5
[   14.060397] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[   14.061889] cdrom: Uniform CD-ROM driver Revision: 3.20
[   14.063499] sr 1:0:0:0: Attached scsi CD-ROM sr0
[   14.063595] sr 1:0:0:0: Attached scsi generic sg1 type 5
[   14.384021] ata5: SATA link down (SStatus 0 SControl 300)
[   14.704020] ata6: SATA link down (SStatus 0 SControl 300)
[   14.832807] yenta_cardbus 0000:0b:04.0: ISA IRQ mask 0x00b8, PCI irq 20
[   14.834236] yenta_cardbus 0000:0b:04.0: Socket status: 30000006
[   14.835655] pci_bus 0000:0b: Raising subordinate bus# of parent bus (#0b) from #0c to #0f
[   14.837456] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   14.838913] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[   14.838917] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[   14.840438] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[   14.841941] ehci_hcd 0000:00:1a.7: debug port 1
[   14.847305] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
[   14.847319] ehci_hcd 0000:00:1a.7: irq 23, io mem 0xdaa25c00
[   14.860013] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[   14.861532] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[   14.863050] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   14.864595] usb usb1: Product: EHCI Host Controller
[   14.866111] usb usb1: Manufacturer: Linux 3.3.0-rc2+ ehci_hcd
[   14.867643] usb usb1: SerialNumber: 0000:00:1a.7
[   14.869320] hub 1-0:1.0: USB hub found
[   14.870844] hub 1-0:1.0: 6 ports detected
[   14.872441] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[   14.872445] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[   14.874025] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[   14.875549] ehci_hcd 0000:00:1d.7: debug port 1
[   14.880937] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[   14.880942] ehci_hcd 0000:00:1d.7: irq 20, io mem 0xdaa25800
[   14.892013] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[   14.893499] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[   14.894994] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   14.896475] usb usb2: Product: EHCI Host Controller
[   14.897941] usb usb2: Manufacturer: Linux 3.3.0-rc2+ ehci_hcd
[   14.899387] usb usb2: SerialNumber: 0000:00:1d.7
[   14.900953] hub 2-0:1.0: USB hub found
[   14.902371] hub 2-0:1.0: 6 ports detected
[   14.903876] uhci_hcd: USB Universal Host Controller Interface driver
[   14.905318] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[   14.905321] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[   14.906779] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[   14.908199] uhci_hcd 0000:00:1a.0: irq 23, io base 0x000070e0
[   14.909607] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[   14.911004] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   14.912437] usb usb3: Product: UHCI Host Controller
[   14.913830] usb usb3: Manufacturer: Linux 3.3.0-rc2+ uhci_hcd
[   14.915214] usb usb3: SerialNumber: 0000:00:1a.0
[   14.916712] hub 3-0:1.0: USB hub found
[   14.918063] hub 3-0:1.0: 2 ports detected
[   14.919481] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[   14.919485] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[   14.920898] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[   14.922244] uhci_hcd 0000:00:1a.1: irq 23, io base 0x000070c0
[   14.923588] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[   14.924917] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   14.926209] usb usb4: Product: UHCI Host Controller
[   14.927480] usb usb4: Manufacturer: Linux 3.3.0-rc2+ uhci_hcd
[   14.928755] usb usb4: SerialNumber: 0000:00:1a.1
[   14.930132] hub 4-0:1.0: USB hub found
[   14.931376] hub 4-0:1.0: 2 ports detected
[   14.932691] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[   14.932695] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[   14.934005] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
[   14.935275] uhci_hcd 0000:00:1a.2: irq 23, io base 0x000070a0
[   14.936562] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[   14.937806] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   14.939053] usb usb5: Product: UHCI Host Controller
[   14.940281] usb usb5: Manufacturer: Linux 3.3.0-rc2+ uhci_hcd
[   14.941499] usb usb5: SerialNumber: 0000:00:1a.2
[   14.942852] hub 5-0:1.0: USB hub found
[   14.944098] hub 5-0:1.0: 2 ports detected
[   14.945379] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[   14.945382] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   14.946661] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
[   14.947901] uhci_hcd 0000:00:1d.0: irq 20, io base 0x00007080
[   14.949154] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[   14.950372] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   14.951597] usb usb6: Product: UHCI Host Controller
[   14.952824] usb usb6: Manufacturer: Linux 3.3.0-rc2+ uhci_hcd
[   14.954065] usb usb6: SerialNumber: 0000:00:1d.0
[   14.955415] hub 6-0:1.0: USB hub found
[   14.956650] hub 6-0:1.0: 2 ports detected
[   14.957938] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[   14.957942] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   14.959228] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
[   14.960508] uhci_hcd 0000:00:1d.1: irq 20, io base 0x00007060
[   14.961768] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[   14.963006] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   14.964246] usb usb7: Product: UHCI Host Controller
[   14.965478] usb usb7: Manufacturer: Linux 3.3.0-rc2+ uhci_hcd
[   14.966703] usb usb7: SerialNumber: 0000:00:1d.1
[   14.968069] hub 7-0:1.0: USB hub found
[   14.969303] hub 7-0:1.0: 2 ports detected
[   14.970606] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[   14.970609] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   14.971890] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
[   14.973177] uhci_hcd 0000:00:1d.2: irq 20, io base 0x00007040
[   14.974435] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
[   14.975659] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   14.976897] usb usb8: Product: UHCI Host Controller
[   14.978114] usb usb8: Manufacturer: Linux 3.3.0-rc2+ uhci_hcd
[   14.979344] usb usb8: SerialNumber: 0000:00:1d.2
[   14.980688] hub 8-0:1.0: USB hub found
[   14.981899] hub 8-0:1.0: 2 ports detected
[   14.983281] usbcore: registered new interface driver wusb-cbaf
[   14.984618] i8042: PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:MOUE] at 0x60,0x64 irq 1,12
[   14.988498] serio: i8042 KBD port at 0x60,0x64 irq 1
[   14.989771] serio: i8042 AUX port at 0x60,0x64 irq 12
[   14.991166] mousedev: PS/2 mouse device common for all mice
[   14.992732] input: PC Speaker as /devices/platform/pcspkr/input/input3
[   14.994069] rtc_cmos 00:03: RTC can wake from S4
[   14.995433] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[   14.996727] rtc0: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[   14.998050] ACPI Warning: 0x0000000000007000-0x000000000000701f SystemIO conflicts with Region \_SB_.PCI0.SBUS.SMBI 1 (20120111/utaddress-251)
[   14.999406] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   15.000895] lirc_dev: IR Remote Control driver registered, major 251 
[   15.002256] IR RC5 (streamzap) protocol handler initialized
[   15.003625] Linux video capture interface: v2.00
[   15.005076] usbcore: registered new interface driver uvcvideo
[   15.006443] USB Video Class driver (1.1.1)
[   15.008039] cpuidle: using governor ladder
[   15.009424] cpuidle: using governor menu
[   15.009821] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
[   15.012179] sdhci: Secure Digital Host Controller Interface driver
[   15.013575] sdhci: Copyright(c) Pierre Ossman
[   15.014965] sdhci-pci 0000:0b:04.2: SDHCI controller found [1180:0822] (rev 21)
[   15.016417] sdhci-pci 0000:0b:04.2: Will use DMA mode even though HW doesn't fully claim to support it.
[   15.017819] sdhci-pci 0000:0b:04.2: setting latency timer to 64
[   15.017923] Registered led device: mmc0::
[   15.019005] mmc0: SDHCI controller on PCI [0000:0b:04.2] using DMA
[   15.020926] r592 0000:0b:04.4: setting latency timer to 64
[   15.021033] r592: driver successfully loaded
[   15.023154] ip_tables: (C) 2000-2006 Netfilter Core Team
[   15.024574] TCP cubic registered
[   15.025956] NET: Registered protocol family 17
[   15.027335] Registering the dns_resolver key type
[   15.029032] PM: Checking hibernation image partition /dev/sda4
[   15.029041] PM: Hibernation image partition 8:4 present
[   15.029043] PM: Looking for hibernation image.
[   15.296088] usb 1-2: new high-speed USB device number 3 using ehci_hcd
[   15.343803] PM: Image not found (code -22)
[   15.343805] PM: Hibernation image not present or could not be loaded.
[   15.343813] registered taskstats version 1
[   15.345780] rtc_cmos 00:03: setting system clock to 2012-02-03 13:24:18 UTC (1328275458)
[   15.347543] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[   15.349000] EDD information not available.
[   15.431135] usb 1-2: New USB device found, idVendor=05ca, idProduct=18b0
[   15.432615] usb 1-2: New USB device strings: Mfr=1, Product=0, SerialNumber=0
[   15.434079] usb 1-2: Manufacturer: Ricoh co. Ltd.
[   15.436367] uvcvideo: Found UVC 1.00 device <unnamed> (05ca:18b0)
[   15.439252] input: UVC Camera (05ca:18b0) as /devices/pci0000:00/0000:00:1a.7/usb1/1-2/1-2:1.0/input/input5
[   15.680051] usb 3-1: new full-speed USB device number 2 using uhci_hcd
[   15.684992] input: PS/2 Mouse as /devices/platform/i8042/serio1/input/input6
[   15.702661] input: AlpsPS/2 ALPS GlidePoint as /devices/platform/i8042/serio1/input/input7
[   15.795871] EXT4-fs (sda3): mounted filesystem with writeback data mode. Opts: (null)
[   15.797447] VFS: Mounted root (ext4 filesystem) readonly on device 8:3.
[   15.800308] Freeing unused kernel memory: 492k freed
[   15.801985] Write protecting the kernel read-only data: 8192k
[   15.810320] Freeing unused kernel memory: 1656k freed
[   15.813706] Freeing unused kernel memory: 324k freed
[   15.856611] usb 3-1: New USB device found, idVendor=147e, idProduct=1000
[   15.858204] usb 3-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   15.859797] usb 3-1: Product: Fingerprint Sensor   
[   15.861377] usb 3-1: Manufacturer: TouchStrip        
[   33.456242] cfg80211: Calling CRDA to update world regulatory domain
[   33.680163] firewire_ohci 0000:0b:04.1: setting latency timer to 64
[   33.744051] firewire_ohci: Added fw-ohci device 0000:0b:04.1, OHCI v1.0, 4 IR + 4 IT contexts, quirks 0x11
[   33.823969] Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:d
[   33.825583] Copyright(c) 2003-2011 Intel Corporation
[   33.827290] iwlwifi 0000:06:00.0: pci_resource_len = 0x00002000
[   33.828853] iwlwifi 0000:06:00.0: pci_resource_base = ffffc90000064000
[   33.830346] iwlwifi 0000:06:00.0: HW Revision ID = 0x0
[   33.831948] iwlwifi 0000:06:00.0: irq 46 for MSI/MSI-X
[   33.832030] iwlwifi 0000:06:00.0: CONFIG_IWLWIFI_DEBUG enabled
[   33.833529] iwlwifi 0000:06:00.0: CONFIG_IWLWIFI_DEBUGFS enabled
[   33.835012] iwlwifi 0000:06:00.0: CONFIG_IWLWIFI_DEVICE_TRACING disabled
[   33.836521] iwlwifi 0000:06:00.0: CONFIG_IWLWIFI_DEVICE_TESTMODE disabled
[   33.837961] iwlwifi 0000:06:00.0: CONFIG_IWLWIFI_P2P disabled
[   33.839480] iwlwifi 0000:06:00.0: Detected Intel(R) WiFi Link 5100 AGN, REV=0x54
[   33.841046] iwlwifi 0000:06:00.0: L1 Enabled; Disabling L0S
[   33.860993] iwlwifi 0000:06:00.0: device EEPROM VER=0x11e, CALIB=0x4
[   33.862879] sony_laptop: Sony Programmable IO Control Driver v0.9np8
[   33.864357] sony_laptop: detected Type3 model
[   33.865831] input: Sony Vaio Keys as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:0d/SNY6001:00/input/input8
[   33.865883] iwlwifi 0000:06:00.0: Device SKU: 0xF0
[   33.865892] iwlwifi 0000:06:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
[   33.870328] iwlwifi 0000:06:00.0: RF_KILL bit toggled to disable radio.
[   33.871862] input: Sony Vaio Jogdial as /devices/virtual/input/input9
[   33.874708] sony_laptop: device allocated minor is 58
[   33.878223] sony_laptop: acpi_callreadfunc failed
[   33.879708] sony_laptop: Determined GFX switch ACPI path as \_SB.PCI0.OVGA._DSM.
[   33.882935] sony_laptop: Speed/stamina switch: stamina.
[   33.888707] sony_laptop: Sony Notebook Control Driver v0.9np8
[   33.890605] sony_laptop: found Vaio model ID: 19763
[   33.925947] sony_laptop: brightness ignored, must be controlled by ACPI video driver
[   34.110766] snd_hda_intel 0000:00:1b.0: irq 47 for MSI/MSI-X
[   34.244109] firewire_core: created device fw0: GUID 0800460302b0163b, S400
[   34.372821] iwlwifi 0000:06:00.0: loaded firmware version 8.83.5.1 build 33692 (EXP)
[   34.374415] Registered led device: phy0-led
[   34.406635] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
[   34.418407] hda_codec: ALC262: SKU not ready 0x411111f0
[   34.421780] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input10
[   34.425591] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
[   34.427190] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input12
[   34.796098] cfg80211: World regulatory domain updated:
[   34.797495] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   34.798897] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   34.800335] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   34.801756] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   34.803177] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   34.804613] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   35.539350] dd: sending ioctl 80306d02 to a partition!
[   35.540803] dd: sending ioctl 80306d02 to a partition!
[   36.249435] Adding 4618964k swap on /dev/sda4.  Priority:-1 extents:1 across:4618964k 
[   36.263510] EXT4-fs (sda3): re-mounted. Opts: (null)
[   36.460096] EXT4-fs (sda3): re-mounted. Opts: errors=remount-ro,user_xattr
[   36.629088] loop: module loaded
[   36.647055] firewire_sbp2: Unknown parameter `serialize_io'
[   38.694692] fuse init (API version 7.18)
[   39.133652] Btrfs loaded
[   39.205178] ISO 9660 Extensions: Microsoft Joliet Level 3
[   39.231963] ISO 9660 Extensions: RRIP_1991A
[   39.301950] ISO 9660 Extensions: Microsoft Joliet Level 3
[   39.324624] ISO 9660 Extensions: RRIP_1991A
[   40.932188] device-mapper: ioctl: 4.22.0-ioctl (2011-10-19) initialised: dm-devel@redhat.com
[   41.104004] microcode: CPU0 updated to revision 0x60f, date = 2010-09-29
[   41.111568] microcode: CPU1 updated to revision 0x60f, date = 2010-09-29
[   43.532364] e1000e 0000:00:19.0: irq 45 for MSI/MSI-X
[   43.592104] e1000e 0000:00:19.0: irq 45 for MSI/MSI-X
[   43.652310] input: ACPI Virtual Keyboard Device as /devices/virtual/input/input13
[   45.384907] Bluetooth: Core ver 2.16
[   45.384928] NET: Registered protocol family 31
[   45.384931] Bluetooth: HCI device and connection manager initialized
[   45.384933] Bluetooth: HCI socket layer initialized
[   45.384935] Bluetooth: L2CAP socket layer initialized
[   45.384940] Bluetooth: SCO socket layer initialized
[   45.486169] Bluetooth: RFCOMM TTY layer initialized
[   45.486174] Bluetooth: RFCOMM socket layer initialized
[   45.486176] Bluetooth: RFCOMM ver 1.11
[   45.794172] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   45.794176] Bluetooth: BNEP filters: protocol multicast
[   46.740946] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: None
[   95.790471] vboxdrv: Found 2 processor cores.
[   95.790653] VBoxDrv: dbg - g_abExecMemory=ffffffffa0303d20
[   95.790673] vboxdrv: fAsync=0 offMin=0x260 offMax=0x135f
[   95.790725] vboxdrv: TSC mode is 'synchronous', kernel timer mode is 'normal'.
[   95.790727] vboxdrv: Successfully loaded version 4.1.8_Debian (interface 0x00190000).
[   95.846008] vboxpci: pci-stub module not available, cannot detach PCI devices
[   95.846012] vboxpci: IOMMU not found (not registered)
[  107.134513] type=1305 audit(1328243150.766:64546): auid=4294967295 ses=4294967295 op="remove rule" key=(null) list=4 res=1
[  107.134519] type=1305 audit(1328243150.766:64547): audit_enabled=0 old=1 auid=4294967295 ses=4294967295 res=1

--1yeeQ81UyVL57Vl7--

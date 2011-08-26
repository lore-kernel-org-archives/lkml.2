Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892Ab1HZNaC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 09:30:02 -0400
Received: from krak.alatek.krakow.pl ([46.170.108.42]:8735 "EHLO
	krak.alatek.krakow.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754894Ab1HZN37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 09:29:59 -0400
X-Greylist: delayed 1832 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Aug 2011 09:29:58 EDT
From: Pawel Sikora <pawel.sikora@agmk.net>
To: linux-kernel@vger.kernel.org
Subject: Re: Linux 3.1-rc3
Date: Fri, 26 Aug 2011 14:59:22 +0200
Message-ID: <3034607.nGfAzPVzX5@pawels>
User-Agent: KMail/4.7.0  (Linux/2.6.38.8-3; KDE/4.7.0; x86_64; ; )
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart3020778.6NdM028BRD"
Content-Transfer-Encoding: 7Bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart3020778.6NdM028BRD
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"

Hi,

i've noticed an usb related problem on the new Asus N73SV N73 laptop
please look at the read error in attached log.

[11.413705] usb 3-1.1: device descriptor read/64, error -32

this read error also occurs on stable-3.0.3.

BR,
Pawel.

--nextPart3020778.6NdM028BRD
Content-Disposition: inline; filename="dmesg.log"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-log; charset="UTF-8"; name="dmesg.log"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.1.0-rc3-00161-g671ee7f-dirty (pluto@vmx) (gcc version 4.6.1 20110714 (release) (PLD-Linux) ) #2 SMP Fri Aug 26 14:18:51 CEST 2011
[    0.000000] Command line: root=/dev/vg_storage/lv_root ramdisk_size=6144 slub_debug=FZPU
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009e800 (usable)
[    0.000000]  BIOS-e820: 000000000009e800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 0000000020000000 (usable)
[    0.000000]  BIOS-e820: 0000000020000000 - 0000000020200000 (reserved)
[    0.000000]  BIOS-e820: 0000000020200000 - 0000000040000000 (usable)
[    0.000000]  BIOS-e820: 0000000040000000 - 0000000040200000 (reserved)
[    0.000000]  BIOS-e820: 0000000040200000 - 00000000aabd1000 (usable)
[    0.000000]  BIOS-e820: 00000000aabd1000 - 00000000aace4000 (reserved)
[    0.000000]  BIOS-e820: 00000000aace4000 - 00000000aace6000 (usable)
[    0.000000]  BIOS-e820: 00000000aace6000 - 00000000aacf9000 (reserved)
[    0.000000]  BIOS-e820: 00000000aacf9000 - 00000000aacfa000 (usable)
[    0.000000]  BIOS-e820: 00000000aacfa000 - 00000000aad8e000 (reserved)
[    0.000000]  BIOS-e820: 00000000aad8e000 - 00000000aad8f000 (usable)
[    0.000000]  BIOS-e820: 00000000aad8f000 - 00000000aadb8000 (reserved)
[    0.000000]  BIOS-e820: 00000000aadb8000 - 00000000aadc8000 (usable)
[    0.000000]  BIOS-e820: 00000000aadc8000 - 00000000aade8000 (reserved)
[    0.000000]  BIOS-e820: 00000000aade8000 - 00000000aaf19000 (usable)
[    0.000000]  BIOS-e820: 00000000aaf19000 - 00000000aafe8000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000aafe8000 - 00000000aaffd000 (usable)
[    0.000000]  BIOS-e820: 00000000aaffd000 - 00000000ab000000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000ab000000 - 00000000afa00000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000e4000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed10000 - 00000000fed14000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed18000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff980000 - 00000000ffc00000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffd80000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000034fe00000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.6 present.
[    0.000000] DMI: ASUSTeK Computer Inc. N73SV/N73SV, BIOS N73SV.303 04/28/2011
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x34fe00 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-E7FFF uncachable
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask C00000000 write-back
[    0.000000]   1 base 0C0000000 mask FC0000000 uncachable
[    0.000000]   2 base 0B0000000 mask FF0000000 uncachable
[    0.000000]   3 base 0AC000000 mask FFC000000 uncachable
[    0.000000]   4 base 0AB000000 mask FFF000000 uncachable
[    0.000000]   5 base 380000000 mask F80000000 uncachable
[    0.000000]   6 base 360000000 mask FE0000000 uncachable
[    0.000000]   7 base 350000000 mask FF0000000 uncachable
[    0.000000]   8 base 34FE00000 mask FFFE00000 uncachable
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000ab000000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xaaffd max_arch_pfn = 0x400000000
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 20480
[    0.000000] init_memory_mapping: 0000000000000000-00000000aaffd000
[    0.000000]  0000000000 - 00aae00000 page 2M
[    0.000000]  00aae00000 - 00aaffd000 page 4k
[    0.000000] kernel direct mapping tables up to aaffd000 @ aaff8000-aaffd000
[    0.000000] init_memory_mapping: 0000000100000000-000000034fe00000
[    0.000000]  0100000000 - 034fe00000 page 2M
[    0.000000] kernel direct mapping tables up to 34fe00000 @ 34fdf1000-34fe00000
[    0.000000] RAMDISK: 1fe69000 - 1fff0000
[    0.000000] ACPI: RSDP 00000000000f0430 00024 (v02 _ASUS_)
[    0.000000] ACPI: XSDT 00000000aaffee18 00064 (v01 _ASUS_ NoteBook 06222004 MSFT 00010013)
[    0.000000] ACPI: FACP 00000000aaf9bd98 000F4 (v04 _ASUS_ NoteBook 06222004 MSFT 00010013)
[    0.000000] ACPI Warning: 32/64 FACS address mismatch in FADT - two FACS tables! (20110623/tbfadt-369)
[    0.000000] ACPI Warning: 32/64X FACS address mismatch in FADT - 0xAAFE5E40/0x00000000AAFE5D40, using 32 (20110623/tbfadt-489)
[    0.000000] ACPI: DSDT 00000000aaf7c018 0D922 (v01 _ASUS_ NoteBook 00000000 INTL 20091112)
[    0.000000] ACPI: FACS 00000000aafe5e40 00040
[    0.000000] ACPI: APIC 00000000aaffdf18 000CC (v02 _ASUS_ NoteBook 06222004 MSFT 00010013)
[    0.000000] ACPI: HPET 00000000aafe6d18 00038 (v01 _ASUS_ NoteBook 06222004 AMI. 00000003)
[    0.000000] ACPI: ECDT 00000000aafe5b18 000C1 (v01 _ASUS_ NoteBook 06222004 AMI  00000000)
[    0.000000] ACPI: MCFG 00000000aafe6c98 0003C (v01 _ASUS_ NoteBook 06222004 MSFT 00000097)
[    0.000000] ACPI: SSDT 00000000aaf7b018 00925 (v01  PmRef  Cpu0Ist 00003000 INTL 20091112)
[    0.000000] ACPI: SSDT 00000000aaf7a018 00996 (v01  PmRef    CpuPm 00003000 INTL 20091112)
[    0.000000] ACPI: SSDT 00000000aaf5ea98 002EF (v01 SataRe SataTabl 00001000 INTL 20091112)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000034fe00000
[    0.000000] Initmem setup node 0 0000000000000000-000000034fe00000
[    0.000000]   NODE_DATA [000000034fdfb000 - 000000034fdfffff]
[    0.000000]  [ffffea0000000000-ffffea000d3fffff] PMD -> [ffff880343400000-ffff88034f3fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x0034fe00
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[11] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009e
[    0.000000]     0: 0x00000100 -> 0x00020000
[    0.000000]     0: 0x00020200 -> 0x00040000
[    0.000000]     0: 0x00040200 -> 0x000aabd1
[    0.000000]     0: 0x000aace4 -> 0x000aace6
[    0.000000]     0: 0x000aacf9 -> 0x000aacfa
[    0.000000]     0: 0x000aad8e -> 0x000aad8f
[    0.000000]     0: 0x000aadb8 -> 0x000aadc8
[    0.000000]     0: 0x000aade8 -> 0x000aaf19
[    0.000000]     0: 0x000aafe8 -> 0x000aaffd
[    0.000000]     0: 0x00100000 -> 0x0034fe00
[    0.000000] On node 0 totalpages: 3122873
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 5 pages reserved
[    0.000000]   DMA zone: 3913 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 16320 pages used for memmap
[    0.000000]   DMA32 zone: 678251 pages, LIFO batch:31
[    0.000000]   Normal zone: 37880 pages used for memmap
[    0.000000]   Normal zone: 2386440 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x08] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x09] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x0a] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x0b] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x0c] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x0d] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x0e] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x0f] disabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] SMP: Allowing 16 CPUs, 8 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 000000000009f000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 0000000020000000 - 0000000020200000
[    0.000000] PM: Registered nosave memory: 0000000040000000 - 0000000040200000
[    0.000000] PM: Registered nosave memory: 00000000aabd1000 - 00000000aace4000
[    0.000000] PM: Registered nosave memory: 00000000aace6000 - 00000000aacf9000
[    0.000000] PM: Registered nosave memory: 00000000aacfa000 - 00000000aad8e000
[    0.000000] PM: Registered nosave memory: 00000000aad8f000 - 00000000aadb8000
[    0.000000] PM: Registered nosave memory: 00000000aadc8000 - 00000000aade8000
[    0.000000] PM: Registered nosave memory: 00000000aaf19000 - 00000000aafe8000
[    0.000000] PM: Registered nosave memory: 00000000aaffd000 - 00000000ab000000
[    0.000000] PM: Registered nosave memory: 00000000ab000000 - 00000000afa00000
[    0.000000] PM: Registered nosave memory: 00000000afa00000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000e4000000
[    0.000000] PM: Registered nosave memory: 00000000e4000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec01000
[    0.000000] PM: Registered nosave memory: 00000000fec01000 - 00000000fed10000
[    0.000000] PM: Registered nosave memory: 00000000fed10000 - 00000000fed14000
[    0.000000] PM: Registered nosave memory: 00000000fed14000 - 00000000fed18000
[    0.000000] PM: Registered nosave memory: 00000000fed18000 - 00000000fed1a000
[    0.000000] PM: Registered nosave memory: 00000000fed1a000 - 00000000fed1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed20000
[    0.000000] PM: Registered nosave memory: 00000000fed20000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ff980000
[    0.000000] PM: Registered nosave memory: 00000000ff980000 - 00000000ffc00000
[    0.000000] PM: Registered nosave memory: 00000000ffc00000 - 00000000ffd80000
[    0.000000] PM: Registered nosave memory: 00000000ffd80000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at afa00000 (gap: afa00000:30600000)
[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:16 nr_node_ids:1
[    0.000000] PERCPU: Embedded 26 pages/cpu @ffff88034fa00000 s74688 r8192 d23616 u131072
[    0.000000] pcpu-alloc: s74688 r8192 d23616 u131072 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 3068604
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: root=/dev/vg_storage/lv_root ramdisk_size=6144 slub_debug=FZPU
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave/xrstor: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 12214904k/13891584k available (4326k kernel code, 1400092k absent, 276588k reserved, 4424k data, 512k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=16, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] NR_IRQS:4352 nr_irqs:808 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 100663296 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.003333] Detected 1995.413 MHz processor.
[    0.000003] Calibrating delay loop (skipped), value calculated using timer frequency.. 3992.11 BogoMIPS (lpj=6651376)
[    0.000122] pid_max: default: 32768 minimum: 301
[    0.000369] Security Framework initialized
[    0.000430] AppArmor: AppArmor disabled by boot time parameter
[    0.002192] Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
[    0.006476] Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.008233] Mount-cache hash table entries: 256
[    0.008986] Initializing cgroup subsys cpuacct
[    0.009051] Initializing cgroup subsys memory
[    0.009163] Initializing cgroup subsys devices
[    0.009227] Initializing cgroup subsys freezer
[    0.009287] Initializing cgroup subsys net_cls
[    0.009850] Initializing cgroup subsys blkio
[    0.009944] Initializing cgroup subsys perf_event
[    0.010134] CPU: Physical Processor ID: 0
[    0.010191] CPU: Processor Core ID: 0
[    0.010251] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.010252] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.010373] mce: CPU supports 9 MCE banks
[    0.010447] CPU0: Thermal monitoring enabled (TM1)
[    0.010511] using mwait in idle threads.
[    0.010651] ACPI: Core revision 20110623
[    0.308932] Switched APIC routing to physical flat.
[    0.309383] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.342562] CPU0: Intel(R) Core(TM) i7-2630QM CPU @ 2.00GHz stepping 07
[    0.447699] Performance Events: PEBS fmt1+, SandyBridge events, Intel PMU driver.
[    0.447888] ... version:                3
[    0.447945] ... bit width:              48
[    0.448002] ... generic registers:      4
[    0.448059] ... value mask:             0000ffffffffffff
[    0.448118] ... max period:             000000007fffffff
[    0.448177] ... fixed-purpose events:   3
[    0.448234] ... event mask:             000000070000000f
[    0.449143] NMI watchdog enabled, takes one hw-pmu counter.
[    0.449549] Booting Node   0, Processors  #1
[    0.449631] smpboot cpu 1: start_ip = 99000
[    0.561147] NMI watchdog enabled, takes one hw-pmu counter.
[    0.561521]  #2
[    0.561562] smpboot cpu 2: start_ip = 99000
[    0.687795] NMI watchdog enabled, takes one hw-pmu counter.
[    0.688152]  #3
[    0.688193] smpboot cpu 3: start_ip = 99000
[    0.811081] NMI watchdog enabled, takes one hw-pmu counter.
[    0.811439]  #4
[    0.811479] smpboot cpu 4: start_ip = 99000
[    0.924339] NMI watchdog enabled, takes one hw-pmu counter.
[    0.924735]  #5
[    0.924776] smpboot cpu 5: start_ip = 99000
[    1.037651] NMI watchdog enabled, takes one hw-pmu counter.
[    1.038037]  #6
[    1.038078] smpboot cpu 6: start_ip = 99000
[    1.164308] NMI watchdog enabled, takes one hw-pmu counter.
[    1.164672]  #7
[    1.164713] smpboot cpu 7: start_ip = 99000
[    1.277603] NMI watchdog enabled, takes one hw-pmu counter.
[    1.277723] Brought up 8 CPUs
[    1.277779] Total of 8 processors activated (31940.79 BogoMIPS).
[    1.283421] devtmpfs: initialized
[    1.302804] PM: Registering ACPI NVS region at aaf19000 (847872 bytes)
[    1.304574] print_constraints: dummy: 
[    1.305068] NET: Registered protocol family 16
[    1.307398] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    1.307479] ACPI: bus type pci registered
[    1.309261] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xe0000000-0xe3ffffff] (base 0xe0000000)
[    1.309342] PCI: MMCONFIG at [mem 0xe0000000-0xe3ffffff] reserved in E820
[    1.329556] PCI: Using configuration type 1 for base access
[    1.348619] bio: create slab <bio-0> at 0
[    1.349322] ACPI: Added _OSI(Module Device)
[    1.349387] ACPI: Added _OSI(Processor Device)
[    1.349451] ACPI: Added _OSI(3.0 _SCP Extensions)
[    1.349516] ACPI: Added _OSI(Processor Aggregator Device)
[    1.352332] ACPI: EC: EC description table is found, configuring boot EC
[    1.352411] ACPI: EC: Look up EC in DSDT
[    1.358798] ACPI: Executed 1 blocks of module-level executable AML code
[    1.494421] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    1.566883] ACPI: SSDT 00000000aadcc718 00694 (v01  PmRef  Cpu0Cst 00003001 INTL 20091112)
[    1.570124] ACPI: Dynamic OEM Table Load:
[    1.570255] ACPI: SSDT           (null) 00694 (v01  PmRef  Cpu0Cst 00003001 INTL 20091112)
[    1.586344] ACPI: SSDT 00000000aadcda98 00303 (v01  PmRef    ApIst 00003000 INTL 20091112)
[    1.591864] ACPI: Dynamic OEM Table Load:
[    1.591995] ACPI: SSDT           (null) 00303 (v01  PmRef    ApIst 00003000 INTL 20091112)
[    1.604212] ACPI: SSDT 00000000aadcbd98 00119 (v01  PmRef    ApCst 00003000 INTL 20091112)
[    1.606663] ACPI: Dynamic OEM Table Load:
[    1.606792] ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst 00003000 INTL 20091112)
[    1.659756] ACPI: Interpreter enabled
[    1.659815] ACPI: (supports S0 S1 S3 S4 S5)
[    1.660502] ACPI: Using IOAPIC for interrupt routing
[    1.952803] ACPI: EC: GPE = 0x1b, I/O: command/status = 0x66, data = 0x62
[    1.955198] ACPI: No dock devices found.
[    1.955256] HEST: Table not found.
[    1.955312] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    1.964569] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
[    1.983154] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    1.983218] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    1.983280] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    1.983356] pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x000d3fff]
[    1.983431] pci_root PNP0A08:00: host bridge window [mem 0x000d4000-0x000d7fff]
[    1.983507] pci_root PNP0A08:00: host bridge window [mem 0x000d8000-0x000dbfff]
[    1.983583] pci_root PNP0A08:00: host bridge window [mem 0x000dc000-0x000dffff]
[    1.983658] pci_root PNP0A08:00: host bridge window [mem 0x000e0000-0x000e3fff]
[    1.983733] pci_root PNP0A08:00: host bridge window [mem 0x000e4000-0x000e7fff]
[    1.983809] pci_root PNP0A08:00: host bridge window [mem 0xafa00000-0xfeafffff]
[    1.983888] pci_root PNP0A08:00: host bridge window [mem 0xfed40000-0xfed44fff]
[    1.984035] pci 0000:00:00.0: [8086:0104] type 0 class 0x000600
[    1.984089] pci 0000:00:01.0: [8086:0101] type 1 class 0x000604
[    1.984120] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    1.984124] pci 0000:00:01.0: PME# disabled
[    1.984154] pci 0000:00:02.0: [8086:0116] type 0 class 0x000300
[    1.984165] pci 0000:00:02.0: reg 10: [mem 0xdc400000-0xdc7fffff 64bit]
[    1.984172] pci 0000:00:02.0: reg 18: [mem 0xb0000000-0xbfffffff 64bit pref]
[    1.984178] pci 0000:00:02.0: reg 20: [io  0xe000-0xe03f]
[    1.984241] pci 0000:00:16.0: [8086:1c3a] type 0 class 0x000780
[    1.984266] pci 0000:00:16.0: reg 10: [mem 0xdf00a000-0xdf00a00f 64bit]
[    1.984332] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    1.984336] pci 0000:00:16.0: PME# disabled
[    1.984380] pci 0000:00:1a.0: [8086:1c2d] type 0 class 0x000c03
[    1.984402] pci 0000:00:1a.0: reg 10: [mem 0xdf008000-0xdf0083ff]
[    1.984479] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    1.984484] pci 0000:00:1a.0: PME# disabled
[    1.984520] pci 0000:00:1b.0: [8086:1c20] type 0 class 0x000403
[    1.984537] pci 0000:00:1b.0: reg 10: [mem 0xdf000000-0xdf003fff 64bit]
[    1.984599] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    1.984603] pci 0000:00:1b.0: PME# disabled
[    1.984636] pci 0000:00:1c.0: [8086:1c10] type 1 class 0x000604
[    1.984706] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    1.984711] pci 0000:00:1c.0: PME# disabled
[    1.984746] pci 0000:00:1c.1: [8086:1c12] type 1 class 0x000604
[    1.984817] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    1.984821] pci 0000:00:1c.1: PME# disabled
[    1.984863] pci 0000:00:1c.3: [8086:1c16] type 1 class 0x000604
[    1.984934] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    1.984939] pci 0000:00:1c.3: PME# disabled
[    1.984976] pci 0000:00:1c.5: [8086:1c1a] type 1 class 0x000604
[    1.985046] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    1.985050] pci 0000:00:1c.5: PME# disabled
[    1.985092] pci 0000:00:1d.0: [8086:1c26] type 0 class 0x000c03
[    1.985115] pci 0000:00:1d.0: reg 10: [mem 0xdf007000-0xdf0073ff]
[    1.985191] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    1.985196] pci 0000:00:1d.0: PME# disabled
[    1.985232] pci 0000:00:1f.0: [8086:1c49] type 0 class 0x000601
[    1.985362] pci 0000:00:1f.2: [8086:1c03] type 0 class 0x000106
[    1.985382] pci 0000:00:1f.2: reg 10: [io  0xe0b0-0xe0b7]
[    1.985391] pci 0000:00:1f.2: reg 14: [io  0xe0a0-0xe0a3]
[    1.985400] pci 0000:00:1f.2: reg 18: [io  0xe090-0xe097]
[    1.985409] pci 0000:00:1f.2: reg 1c: [io  0xe080-0xe083]
[    1.985417] pci 0000:00:1f.2: reg 20: [io  0xe060-0xe07f]
[    1.985426] pci 0000:00:1f.2: reg 24: [mem 0xdf006000-0xdf0067ff]
[    1.985461] pci 0000:00:1f.2: PME# supported from D3hot
[    1.985464] pci 0000:00:1f.2: PME# disabled
[    1.985493] pci 0000:00:1f.3: [8086:1c22] type 0 class 0x000c05
[    1.985510] pci 0000:00:1f.3: reg 10: [mem 0xdf005000-0xdf0050ff 64bit]
[    1.985532] pci 0000:00:1f.3: reg 20: [io  0xe040-0xe05f]
[    1.985611] pci 0000:01:00.0: [10de:0df4] type 0 class 0x000300
[    1.985620] pci 0000:01:00.0: reg 10: [mem 0xdb000000-0xdbffffff]
[    1.985629] pci 0000:01:00.0: reg 14: [mem 0xc0000000-0xcfffffff 64bit pref]
[    1.985639] pci 0000:01:00.0: reg 1c: [mem 0xd0000000-0xd1ffffff 64bit pref]
[    1.985646] pci 0000:01:00.0: reg 24: [io  0xd000-0xd07f]
[    1.985652] pci 0000:01:00.0: reg 30: [mem 0xdc000000-0xdc07ffff pref]
[    1.985697] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    1.985758] pci 0000:00:01.0:   bridge window [io  0xd000-0xdfff]
[    1.985761] pci 0000:00:01.0:   bridge window [mem 0xdb000000-0xdc0fffff]
[    1.985765] pci 0000:00:01.0:   bridge window [mem 0xc0000000-0xd1ffffff 64bit pref]
[    1.985822] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    1.985885] pci 0000:00:1c.0:   bridge window [io  0xc000-0xcfff]
[    1.985890] pci 0000:00:1c.0:   bridge window [mem 0xde600000-0xdeffffff]
[    1.985897] pci 0000:00:1c.0:   bridge window [mem 0xd4200000-0xd4bfffff 64bit pref]
[    1.985993] pci 0000:03:00.0: [168c:002b] type 0 class 0x000280
[    1.986022] pci 0000:03:00.0: reg 10: [mem 0xddc00000-0xddc0ffff 64bit]
[    1.986135] pci 0000:03:00.0: supports D1
[    1.986136] pci 0000:03:00.0: PME# supported from D0 D1 D3hot D3cold
[    1.986142] pci 0000:03:00.0: PME# disabled
[    1.986186] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    1.986248] pci 0000:00:1c.1:   bridge window [io  0xb000-0xbfff]
[    1.986253] pci 0000:00:1c.1:   bridge window [mem 0xddc00000-0xde5fffff]
[    1.986260] pci 0000:00:1c.1:   bridge window [mem 0xd3700000-0xd40fffff 64bit pref]
[    1.986352] pci 0000:04:00.0: [1b73:1000] type 0 class 0x000c03
[    1.986374] pci 0000:04:00.0: reg 10: [mem 0xdd200000-0xdd20ffff]
[    1.986502] pci 0000:04:00.0: PME# supported from D0 D3hot
[    1.986508] pci 0000:04:00.0: PME# disabled
[    1.986543] pci 0000:00:1c.3: PCI bridge to [bus 04-04]
[    1.986604] pci 0000:00:1c.3:   bridge window [io  0xa000-0xafff]
[    1.986608] pci 0000:00:1c.3:   bridge window [mem 0xdd200000-0xddbfffff]
[    1.986615] pci 0000:00:1c.3:   bridge window [mem 0xd2c00000-0xd35fffff 64bit pref]
[    1.986707] pci 0000:05:00.0: [1969:1083] type 0 class 0x000200
[    1.986736] pci 0000:05:00.0: reg 10: [mem 0xdc800000-0xdc83ffff 64bit]
[    1.986752] pci 0000:05:00.0: reg 18: [io  0x9000-0x907f]
[    1.986858] pci 0000:05:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.986864] pci 0000:05:00.0: PME# disabled
[    1.986915] pci 0000:00:1c.5: PCI bridge to [bus 05-05]
[    1.986977] pci 0000:00:1c.5:   bridge window [io  0x9000-0x9fff]
[    1.986981] pci 0000:00:1c.5:   bridge window [mem 0xdc800000-0xdd1fffff]
[    1.986988] pci 0000:00:1c.5:   bridge window [mem 0xd2100000-0xd2afffff 64bit pref]
[    1.987013] pci 0000:00:01.0: Dev MPS 128 MPSS 128 MRRS 128
[    1.987075] pci 0000:00:01.0: Dev MPS 128 MPSS 128 MRRS 128
[    1.987136] pci 0000:01:00.0: Dev MPS 128 MPSS 128 MRRS 512
[    1.987204] pci 0000:01:00.0: Dev MPS 128 MPSS 128 MRRS 128
[    1.987268] pci 0000:00:1c.0: Dev MPS 128 MPSS 128 MRRS 128
[    1.987333] pci 0000:00:1c.0: Dev MPS 128 MPSS 128 MRRS 128
[    1.987397] pci 0000:00:1c.1: Dev MPS 128 MPSS 128 MRRS 128
[    1.987462] pci 0000:00:1c.1: Dev MPS 128 MPSS 128 MRRS 128
[    1.987524] pci 0000:03:00.0: Dev MPS 128 MPSS 128 MRRS 512
[    1.987598] pci 0000:03:00.0: Dev MPS 128 MPSS 128 MRRS 128
[    1.987660] pci 0000:00:1c.3: Dev MPS 128 MPSS 128 MRRS 128
[    1.987724] pci 0000:00:1c.3: Dev MPS 128 MPSS 128 MRRS 128
[    1.987788] pci 0000:04:00.0: Dev MPS 128 MPSS 128 MRRS 512
[    1.987861] pci 0000:04:00.0: Dev MPS 128 MPSS 128 MRRS 128
[    1.987921] pci 0000:00:1c.5: Dev MPS 128 MPSS 128 MRRS 128
[    1.987986] pci 0000:00:1c.5: Dev MPS 128 MPSS 128 MRRS 128
[    1.988050] pci 0000:05:00.0: Dev MPS 128 MPSS 4096 MRRS 512
[    1.988124] pci 0000:05:00.0: Dev MPS 128 MPSS 128 MRRS 128
[    1.988199] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    1.997609] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    1.999191] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    2.000828] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP04._PRT]
[    2.002456] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP06._PRT]
[    2.004375] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEGR._PRT]
[    2.006159]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    2.006230]  pci0000:00: ACPI _OSC request failed (AE_NOT_FOUND), returned control mask: 0x1d
[    2.006306] ACPI _OSC control for PCIe not granted, disabling ASPM
[    2.900001] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 10 *11 12 14 15)
[    2.901763] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 *5 6 10 11 12 14 15)
[    2.903663] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 *3 4 5 6 10 11 12 14 15)
[    2.905402] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 *10 11 12 14 15)
[    2.907150] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 10 11 12 14 15) *0, disabled.
[    2.908969] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 10 11 12 14 15) *0, disabled.
[    2.910789] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 *5 6 10 11 12 14 15)
[    2.912509] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 *5 6 10 11 12 14 15)
[    2.914577] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    2.914731] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=none,locks=none
[    2.914831] vgaarb: loaded
[    2.914885] vgaarb: bridge control possible 0000:01:00.0
[    2.914943] vgaarb: bridge control possible 0000:00:02.0
[    2.918063] PCI: Using ACPI for IRQ routing
[    2.919710] PCI: pci_cache_line_size set to 64 bytes
[    2.920029] reserve RAM buffer: 000000000009e800 - 000000000009ffff 
[    2.920039] reserve RAM buffer: 00000000aabd1000 - 00000000abffffff 
[    2.920161] reserve RAM buffer: 00000000aace6000 - 00000000abffffff 
[    2.920265] reserve RAM buffer: 00000000aacfa000 - 00000000abffffff 
[    2.920348] reserve RAM buffer: 00000000aad8f000 - 00000000abffffff 
[    2.920408] reserve RAM buffer: 00000000aadc8000 - 00000000abffffff 
[    2.920448] reserve RAM buffer: 00000000aaf19000 - 00000000abffffff 
[    2.920474] reserve RAM buffer: 00000000aaffd000 - 00000000abffffff 
[    2.920487] reserve RAM buffer: 000000034fe00000 - 000000034fffffff 
[    2.921657] NetLabel: Initializing
[    2.921714] NetLabel:  domain hash size = 128
[    2.921771] NetLabel:  protocols = UNLABELED CIPSOv4
[    2.921920] NetLabel:  unlabeled traffic allowed by default
[    2.922211] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    2.922604] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    2.925795] Switching to clocksource hpet
[    2.926907] Switched to NOHz mode on CPU #0
[    2.926997] Switched to NOHz mode on CPU #4
[    2.927015] Switched to NOHz mode on CPU #5
[    2.927023] Switched to NOHz mode on CPU #1
[    2.927038] Switched to NOHz mode on CPU #3
[    2.927048] Switched to NOHz mode on CPU #7
[    2.927052] Switched to NOHz mode on CPU #2
[    2.927054] Switched to NOHz mode on CPU #6
[    2.940095] pnp: PnP ACPI init
[    2.940233] ACPI: bus type pnp registered
[    2.948809] pnp 00:00: [bus 00-3e]
[    2.948817] pnp 00:00: [io  0x0000-0x0cf7 window]
[    2.948824] pnp 00:00: [io  0x0cf8-0x0cff]
[    2.948830] pnp 00:00: [io  0x0d00-0xffff window]
[    2.948836] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    2.948842] pnp 00:00: [mem 0x000c0000-0x000c3fff window]
[    2.948849] pnp 00:00: [mem 0x000c4000-0x000c7fff window]
[    2.948855] pnp 00:00: [mem 0x000c8000-0x000cbfff window]
[    2.948861] pnp 00:00: [mem 0x000cc000-0x000cffff window]
[    2.948867] pnp 00:00: [mem 0x000d0000-0x000d3fff window]
[    2.948873] pnp 00:00: [mem 0x000d4000-0x000d7fff window]
[    2.948879] pnp 00:00: [mem 0x000d8000-0x000dbfff window]
[    2.948885] pnp 00:00: [mem 0x000dc000-0x000dffff window]
[    2.948890] pnp 00:00: [mem 0x000e0000-0x000e3fff window]
[    2.948896] pnp 00:00: [mem 0x000e4000-0x000e7fff window]
[    2.948902] pnp 00:00: [mem 0x000e8000-0x000ebfff window]
[    2.948917] pnp 00:00: [mem 0x000ec000-0x000effff window]
[    2.948924] pnp 00:00: [mem 0x000f0000-0x000fffff window]
[    2.948931] pnp 00:00: [mem 0xafa00000-0xfeafffff window]
[    2.948938] pnp 00:00: [mem 0xfed40000-0xfed44fff window]
[    2.949280] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    2.949446] pnp 00:01: [io  0x0000-0x001f]
[    2.949453] pnp 00:01: [io  0x0081-0x0091]
[    2.949459] pnp 00:01: [io  0x0093-0x009f]
[    2.949466] pnp 00:01: [io  0x00c0-0x00df]
[    2.949473] pnp 00:01: [dma 4]
[    2.949770] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    2.949887] pnp 00:02: [mem 0xff000000-0xffffffff]
[    2.950214] pnp 00:02: Plug and Play ACPI device, IDs INT0800 (active)
[    2.951662] pnp 00:03: [mem 0xfed00000-0xfed003ff]
[    2.951968] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
[    2.952100] pnp 00:04: [io  0x00f0]
[    2.952113] pnp 00:04: [irq 13]
[    2.952431] pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
[    2.952544] pnp 00:05: [io  0x002e-0x002f]
[    2.952550] pnp 00:05: [io  0x004e-0x004f]
[    2.952557] pnp 00:05: [io  0x0061]
[    2.952563] pnp 00:05: [io  0x0063]
[    2.952568] pnp 00:05: [io  0x0065]
[    2.952574] pnp 00:05: [io  0x0067]
[    2.952580] pnp 00:05: [io  0x0070]
[    2.952586] pnp 00:05: [io  0x0080]
[    2.952592] pnp 00:05: [io  0x0092]
[    2.952597] pnp 00:05: [io  0x00b2-0x00b3]
[    2.952603] pnp 00:05: [io  0x0680-0x069f]
[    2.952609] pnp 00:05: [io  0x1000-0x100f]
[    2.952615] pnp 00:05: [io  0xffff]
[    2.952621] pnp 00:05: [io  0xffff]
[    2.952626] pnp 00:05: [io  0x0400-0x0453]
[    2.952632] pnp 00:05: [io  0x0458-0x047f]
[    2.952638] pnp 00:05: [io  0x0500-0x057f]
[    2.952643] pnp 00:05: [io  0x164e-0x164f]
[    2.953183] system 00:05: [io  0x0680-0x069f] has been reserved
[    2.953257] system 00:05: [io  0x1000-0x100f] has been reserved
[    2.953329] system 00:05: [io  0xffff] has been reserved
[    2.953401] system 00:05: [io  0xffff] has been reserved
[    2.953472] system 00:05: [io  0x0400-0x0453] has been reserved
[    2.953545] system 00:05: [io  0x0458-0x047f] has been reserved
[    2.953617] system 00:05: [io  0x0500-0x057f] has been reserved
[    2.953689] system 00:05: [io  0x164e-0x164f] has been reserved
[    2.953751] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    2.953858] pnp 00:06: [io  0x0070-0x0077]
[    2.953868] pnp 00:06: [irq 8]
[    2.954166] pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
[    2.954540] pnp 00:07: [io  0x0454-0x0457]
[    2.955065] system 00:07: [io  0x0454-0x0457] has been reserved
[    2.955129] system 00:07: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
[    2.956163] pnp 00:08: [irq 12]
[    2.956490] pnp 00:08: Plug and Play ACPI device, IDs ETD0001 SYN0a00 SYN0002 PNP0f03 PNP0f13 PNP0f12 (active)
[    2.956894] pnp 00:09: [io  0x0060]
[    2.956900] pnp 00:09: [io  0x0064]
[    2.956909] pnp 00:09: [irq 1]
[    2.957237] pnp 00:09: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
[    3.013425] pnp 00:0a: [mem 0xfed1c000-0xfed1ffff]
[    3.013432] pnp 00:0a: [mem 0xfed10000-0xfed17fff]
[    3.013439] pnp 00:0a: [mem 0xfed18000-0xfed18fff]
[    3.013446] pnp 00:0a: [mem 0xfed19000-0xfed19fff]
[    3.013452] pnp 00:0a: [mem 0xe0000000-0xe3ffffff]
[    3.013459] pnp 00:0a: [mem 0xfed20000-0xfed3ffff]
[    3.013465] pnp 00:0a: [mem 0xfed90000-0xfed93fff]
[    3.013472] pnp 00:0a: [mem 0xfed45000-0xfed8ffff]
[    3.013478] pnp 00:0a: [mem 0xff000000-0xffffffff]
[    3.013485] pnp 00:0a: [mem 0xfee00000-0xfeefffff]
[    3.013491] pnp 00:0a: [mem 0xafa00000-0xafa00fff]
[    3.014053] system 00:0a: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    3.014138] system 00:0a: [mem 0xfed10000-0xfed17fff] could not be reserved
[    3.014212] system 00:0a: [mem 0xfed18000-0xfed18fff] has been reserved
[    3.014284] system 00:0a: [mem 0xfed19000-0xfed19fff] has been reserved
[    3.014358] system 00:0a: [mem 0xe0000000-0xe3ffffff] has been reserved
[    3.014431] system 00:0a: [mem 0xfed20000-0xfed3ffff] has been reserved
[    3.014505] system 00:0a: [mem 0xfed90000-0xfed93fff] has been reserved
[    3.015078] system 00:0a: [mem 0xfed45000-0xfed8ffff] has been reserved
[    3.015163] system 00:0a: [mem 0xff000000-0xffffffff] could not be reserved
[    3.015249] system 00:0a: [mem 0xfee00000-0xfeefffff] could not be reserved
[    3.015324] system 00:0a: [mem 0xafa00000-0xafa00fff] has been reserved
[    3.015387] system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
[    3.016207] pnp 00:0b: [mem 0xafa00000-0xafa00fff]
[    3.016744] system 00:0b: [mem 0xafa00000-0xafa00fff] has been reserved
[    3.016808] system 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
[    3.019712] pnp 00:0c: [mem 0x20000000-0x201fffff]
[    3.019719] pnp 00:0c: [mem 0x40000000-0x401fffff]
[    3.020275] system 00:0c: [mem 0x20000000-0x201fffff] has been reserved
[    3.020349] system 00:0c: [mem 0x40000000-0x401fffff] has been reserved
[    3.020412] system 00:0c: Plug and Play ACPI device, IDs PNP0c01 (active)
[    3.020481] pnp: PnP ACPI: found 13 devices
[    3.020538] ACPI: ACPI bus type pnp unregistered
[    3.048518] PCI: max bus depth: 1 pci_try_num: 2
[    3.048557] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    3.048618] pci 0000:00:01.0:   bridge window [io  0xd000-0xdfff]
[    3.048681] pci 0000:00:01.0:   bridge window [mem 0xdb000000-0xdc0fffff]
[    3.048744] pci 0000:00:01.0:   bridge window [mem 0xc0000000-0xd1ffffff 64bit pref]
[    3.048823] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    3.048883] pci 0000:00:1c.0:   bridge window [io  0xc000-0xcfff]
[    3.048947] pci 0000:00:1c.0:   bridge window [mem 0xde600000-0xdeffffff]
[    3.049011] pci 0000:00:1c.0:   bridge window [mem 0xd4200000-0xd4bfffff 64bit pref]
[    3.049092] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    3.049152] pci 0000:00:1c.1:   bridge window [io  0xb000-0xbfff]
[    3.049216] pci 0000:00:1c.1:   bridge window [mem 0xddc00000-0xde5fffff]
[    3.049280] pci 0000:00:1c.1:   bridge window [mem 0xd3700000-0xd40fffff 64bit pref]
[    3.049372] pci 0000:00:1c.3: PCI bridge to [bus 04-04]
[    3.049432] pci 0000:00:1c.3:   bridge window [io  0xa000-0xafff]
[    3.049497] pci 0000:00:1c.3:   bridge window [mem 0xdd200000-0xddbfffff]
[    3.049561] pci 0000:00:1c.3:   bridge window [mem 0xd2c00000-0xd35fffff 64bit pref]
[    3.049641] pci 0000:00:1c.5: PCI bridge to [bus 05-05]
[    3.049701] pci 0000:00:1c.5:   bridge window [io  0x9000-0x9fff]
[    3.049766] pci 0000:00:1c.5:   bridge window [mem 0xdc800000-0xdd1fffff]
[    3.049830] pci 0000:00:1c.5:   bridge window [mem 0xd2100000-0xd2afffff 64bit pref]
[    3.049940] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.050003] pci 0000:00:01.0: setting latency timer to 64
[    3.050010] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.050074] pci 0000:00:1c.0: setting latency timer to 64
[    3.050100] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    3.050165] pci 0000:00:1c.1: setting latency timer to 64
[    3.050190] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    3.050255] pci 0000:00:1c.3: setting latency timer to 64
[    3.050262] pci 0000:00:1c.5: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    3.050327] pci 0000:00:1c.5: setting latency timer to 64
[    3.050332] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    3.050334] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    3.050336] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    3.050338] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000d3fff]
[    3.050340] pci_bus 0000:00: resource 8 [mem 0x000d4000-0x000d7fff]
[    3.050343] pci_bus 0000:00: resource 9 [mem 0x000d8000-0x000dbfff]
[    3.050345] pci_bus 0000:00: resource 10 [mem 0x000dc000-0x000dffff]
[    3.050347] pci_bus 0000:00: resource 11 [mem 0x000e0000-0x000e3fff]
[    3.050350] pci_bus 0000:00: resource 12 [mem 0x000e4000-0x000e7fff]
[    3.050352] pci_bus 0000:00: resource 13 [mem 0xafa00000-0xfeafffff]
[    3.050354] pci_bus 0000:00: resource 14 [mem 0xfed40000-0xfed44fff]
[    3.050356] pci_bus 0000:01: resource 0 [io  0xd000-0xdfff]
[    3.050358] pci_bus 0000:01: resource 1 [mem 0xdb000000-0xdc0fffff]
[    3.050361] pci_bus 0000:01: resource 2 [mem 0xc0000000-0xd1ffffff 64bit pref]
[    3.050363] pci_bus 0000:02: resource 0 [io  0xc000-0xcfff]
[    3.050365] pci_bus 0000:02: resource 1 [mem 0xde600000-0xdeffffff]
[    3.050368] pci_bus 0000:02: resource 2 [mem 0xd4200000-0xd4bfffff 64bit pref]
[    3.050370] pci_bus 0000:03: resource 0 [io  0xb000-0xbfff]
[    3.050372] pci_bus 0000:03: resource 1 [mem 0xddc00000-0xde5fffff]
[    3.050374] pci_bus 0000:03: resource 2 [mem 0xd3700000-0xd40fffff 64bit pref]
[    3.050377] pci_bus 0000:04: resource 0 [io  0xa000-0xafff]
[    3.050379] pci_bus 0000:04: resource 1 [mem 0xdd200000-0xddbfffff]
[    3.050381] pci_bus 0000:04: resource 2 [mem 0xd2c00000-0xd35fffff 64bit pref]
[    3.050383] pci_bus 0000:05: resource 0 [io  0x9000-0x9fff]
[    3.050385] pci_bus 0000:05: resource 1 [mem 0xdc800000-0xdd1fffff]
[    3.050387] pci_bus 0000:05: resource 2 [mem 0xd2100000-0xd2afffff 64bit pref]
[    3.050520] NET: Registered protocol family 2
[    3.051077] IP route cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    3.052643] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    3.054219] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    3.054423] TCP: Hash tables configured (established 524288 bind 65536)
[    3.054486] TCP reno registered
[    3.054578] UDP hash table entries: 8192 (order: 6, 262144 bytes)
[    3.054725] UDP-Lite hash table entries: 8192 (order: 6, 262144 bytes)
[    3.055299] NET: Registered protocol family 1
[    3.055410] pci 0000:00:02.0: Boot video device
[    3.302858] PCI: CLS 64 bytes, default 64
[    3.303104] Trying to unpack rootfs image as initramfs...
[    3.338761] Freeing initrd memory: 1564k freed
[    3.338976] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    3.339038] Placing 64MB software IO TLB between ffff8800a6bd1000 - ffff8800aabd1000
[    3.339114] software IO TLB at phys 0xa6bd1000 - 0xaabd1000
[    3.350855] audit: initializing netlink socket (disabled)
[    3.350950] type=2000 audit(1314368942.973:1): initialized
[    3.393914] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    3.460951] VFS: Disk quotas dquot_6.5.2
[    3.461349] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    3.462006] ROMFS MTD (C) 2007 Red Hat, Inc.
[    3.462389] msgmni has been set to 23860
[    3.463835] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    3.463970] io scheduler noop registered
[    3.464028] io scheduler deadline registered
[    3.464699] io scheduler cfq registered (default)
[    3.466089] pcieport 0000:00:01.0: setting latency timer to 64
[    3.466134] pcieport 0000:00:01.0: irq 40 for MSI/MSI-X
[    3.467929] intel_idle: MWAIT substates: 0x21120
[    3.467931] intel_idle: v0.4 model 0x2A
[    3.467932] intel_idle: lapic_timer_reliable_states 0xffffffff
[    3.469535] ERST: Table is not found!
[    3.469592] GHES: HEST is not enabled!
[    3.642103] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    3.851638] Linux agpgart interface v0.103
[    3.865112] brd: module loaded
[    3.865655] Fixed MDIO Bus: probed
[    3.866169] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
[    3.867970] i8042: Detected active multiplexing controller, rev 1.1
[    3.868908] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.868981] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[    3.869235] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[    3.869325] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[    3.869596] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[    3.870773] mousedev: PS/2 mouse device common for all mice
[    3.871091] rtc_cmos 00:06: RTC can wake from S4
[    3.871779] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
[    3.871892] rtc0: alarms up to one year, y3k, 242 bytes nvram, hpet irqs
[    3.880040] cpuidle: using governor ladder
[    3.895256] cpuidle: using governor menu
[    3.895789] TCP cubic registered
[    3.898313] NET: Registered protocol family 10
[    3.900684] Mobile IPv6
[    3.900742] NET: Registered protocol family 17
[    3.900999] Registering the dns_resolver key type
[    3.902086] registered taskstats version 1
[    3.921627] rtc_cmos 00:06: setting system clock to 2011-08-26 14:29:04 UTC (1314368944)
[    3.922493] Initializing network drop monitor service
[    3.923655] Freeing unused kernel memory: 512k freed
[    3.923775] Write protecting the kernel read-only data: 8192k
[    3.929498] Freeing unused kernel memory: 1800k freed
[    3.931066] Freeing unused kernel memory: 396k freed
[    3.931240] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    3.944787] SCSI subsystem initialized
[    3.947997] libata version 3.00 loaded.
[    3.950931] ahci 0000:00:1f.2: version 3.0
[    3.950950] ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    3.951147] ahci 0000:00:1f.2: irq 41 for MSI/MSI-X
[    3.962489] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x7 impl SATA mode
[    3.962590] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ems apst 
[    3.962671] ahci 0000:00:1f.2: setting latency timer to 64
[    3.985814] scsi0 : ahci
[    3.987923] scsi1 : ahci
[    3.988853] scsi2 : ahci
[    3.989879] scsi3 : ahci
[    3.990833] scsi4 : ahci
[    3.991727] scsi5 : ahci
[    4.006370] ata1: SATA max UDMA/133 abar m2048@0xdf006000 port 0xdf006100 irq 41
[    4.006447] ata2: SATA max UDMA/133 abar m2048@0xdf006000 port 0xdf006180 irq 41
[    4.006524] ata3: SATA max UDMA/133 abar m2048@0xdf006000 port 0xdf006200 irq 41
[    4.006598] ata4: DUMMY
[    4.006652] ata5: DUMMY
[    4.006706] ata6: DUMMY
[    4.325690] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    4.325800] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    4.333355] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    4.342258] Refined TSC clocksource calibration: 1995.467 MHz.
[    4.342323] Switching to clocksource tsc
[    4.345787] ata2.00: ACPI cmd ef/90:06:00:00:00:00 (SET FEATURES) succeeded
[    4.345791] ata2.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
[    4.345876] ata2.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION OVERLAY) filtered out
[    4.345971] ata1.00: ACPI cmd ef/90:06:00:00:00:00 (SET FEATURES) succeeded
[    4.345978] ata1.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
[    4.346057] ata1.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION OVERLAY) filtered out
[    4.346148] ata3.00: ACPI cmd ef/90:06:00:00:00:00 (SET FEATURES) succeeded
[    4.346152] ata3.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
[    4.346229] ata3.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION OVERLAY) filtered out
[    4.348171] ata1.00: ATA-8: WDC WD5000BEVT-80A0RT0, 01.01A01, max UDMA/133
[    4.348274] ata1.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    4.348366] ata3.00: ATAPI: HL-DT-STDVDRAM GT34N, AS00, max UDMA/100
[    4.348831] ata2.00: ATA-8: WDC WD5000BEVT-80A0RT0, 01.01A01, max UDMA/133
[    4.348943] ata2.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    4.373042] ata1.00: ACPI cmd ef/90:06:00:00:00:00 (SET FEATURES) succeeded
[    4.373048] ata1.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
[    4.373131] ata1.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION OVERLAY) filtered out
[    4.373226] ata2.00: ACPI cmd ef/90:06:00:00:00:00 (SET FEATURES) succeeded
[    4.373231] ata2.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
[    4.373310] ata2.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION OVERLAY) filtered out
[    4.374046] ata3.00: ACPI cmd ef/90:06:00:00:00:00 (SET FEATURES) succeeded
[    4.374054] ata3.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
[    4.374178] ata3.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION OVERLAY) filtered out
[    4.375243] ata1.00: configured for UDMA/133
[    4.375438] ata2.00: configured for UDMA/133
[    4.375979] scsi 0:0:0:0: Direct-Access     ATA      WDC WD5000BEVT-8 01.0 PQ: 0 ANSI: 5
[    4.376323] ata3.00: configured for UDMA/100
[    4.378512] scsi 1:0:0:0: Direct-Access     ATA      WDC WD5000BEVT-8 01.0 PQ: 0 ANSI: 5
[    4.382659] scsi 2:0:0:0: CD-ROM            HL-DT-ST DVDRAM GT34N     AS00 PQ: 0 ANSI: 5
[    4.388067] md: raid10 personality registered for level 10
[    4.391644] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[    4.392149] sd 1:0:0:0: [sdb] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[    4.392375] sd 0:0:0:0: [sda] Write Protect is off
[    4.392439] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    4.392694] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.392820] sd 1:0:0:0: [sdb] Write Protect is off
[    4.392882] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    4.393089] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.434903]  sda: sda1 sda2
[    4.437434] sd 0:0:0:0: [sda] Attached SCSI disk
[    4.696229]  sdb: sdb1 sdb2
[    4.698793] sd 1:0:0:0: [sdb] Attached SCSI disk
[    4.704805] device-mapper: uevent: version 1.0.3
[    4.705953] device-mapper: ioctl: 4.21.0-ioctl (2011-07-06) initialised: dm-devel@redhat.com
[    4.793191] md: md1 stopped.
[    4.795370] md: bind<sdb2>
[    4.796177] bio: create slab <bio-1> at 1
[    4.797831] md/raid10:md1: active with 1 out of 2 devices
[    4.797979] md1: detected capacity change from 0 to 500007174144
[    4.827626]  md1: unknown partition table
[    5.091161] EXT4-fs (dm-0): mounted filesystem with ordered data mode. Opts: (null)
[    9.877211] wmi: Mapper loaded
[    9.899491] cfg80211: Calling CRDA to update world regulatory domain
[    9.912802] iTCO_vendor_support: vendor-support=0
[    9.931029] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.06
[    9.931429] iTCO_wdt: Found a Cougar Point TCO device (Version=2, TCOBASE=0x0460)
[    9.931729] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[   10.178482] agpgart-intel 0000:00:00.0: Intel Sandybridge Chipset
[   10.178695] agpgart-intel 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
[   10.180521] agpgart-intel 0000:00:00.0: detected 65536K stolen memory
[   10.180923] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xb0000000
[   10.279662] thermal LNXTHERM:00: registered as thermal_zone0
[   10.279665] ACPI: Thermal Zone [TZ00] (60 C)
[   10.291689] ACPI: acpi_idle yielding to intel_idle
[   10.300323] ACPI: Deprecated procfs I/F for AC is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[   10.301087] ACPI: AC Adapter [AC0] (on-line)
[   10.301945] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input1
[   10.330902] ACPI: Deprecated procfs I/F for battery is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[   10.330996] ACPI: Battery Slot [BAT0] (battery present)
[   10.333421] ACPI: Lid Switch [LID]
[   10.333760] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input2
[   10.333775] ACPI: Sleep Button [SLPB]
[   10.334105] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[   10.334123] ACPI: Power Button [PWRF]
[   10.356710] input: PC Speaker as /devices/platform/pcspkr/input/input4
[   10.363960] usbcore: registered new interface driver usbfs
[   10.364239] usbcore: registered new interface driver hub
[   10.364444] usbcore: registered new device driver usb
[   10.397424] xhci_hcd 0000:04:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[   10.397505] xhci_hcd 0000:04:00.0: setting latency timer to 64
[   10.397511] xhci_hcd 0000:04:00.0: xHCI Host Controller
[   10.397643] xhci_hcd 0000:04:00.0: new USB bus registered, assigned bus number 1
[   10.407823] i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[   10.469826] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[   10.469836] cdrom: Uniform CD-ROM driver Revision: 3.20
[   10.470843] sr 2:0:0:0: Attached scsi CD-ROM sr0
[   10.535779] xhci_hcd 0000:04:00.0: irq 19, io mem 0xdd200000
[   10.536178] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[   10.536180] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   10.536183] usb usb1: Product: xHCI Host Controller
[   10.536185] usb usb1: Manufacturer: Linux 3.1.0-rc3-00161-g671ee7f-dirty xhci_hcd
[   10.536187] usb usb1: SerialNumber: 0000:04:00.0
[   10.536866] xHCI xhci_add_endpoint called for root hub
[   10.536869] xHCI xhci_check_bandwidth called for root hub
[   10.537269] hub 1-0:1.0: USB hub found
[   10.537344] hub 1-0:1.0: 1 port detected
[   10.538429] xhci_hcd 0000:04:00.0: xHCI Host Controller
[   10.538470] xhci_hcd 0000:04:00.0: new USB bus registered, assigned bus number 2
[   10.538808] usb usb2: New USB device found, idVendor=1d6b, idProduct=0003
[   10.538810] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   10.538812] usb usb2: Product: xHCI Host Controller
[   10.538814] usb usb2: Manufacturer: Linux 3.1.0-rc3-00161-g671ee7f-dirty xhci_hcd
[   10.538816] usb usb2: SerialNumber: 0000:04:00.0
[   10.539407] xHCI xhci_add_endpoint called for root hub
[   10.539409] xHCI xhci_check_bandwidth called for root hub
[   10.539713] hub 2-0:1.0: USB hub found
[   10.539788] hub 2-0:1.0: 1 port detected
[   10.597884] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   10.597947] ehci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   10.598002] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[   10.598007] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[   10.598051] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[   10.598141] ehci_hcd 0000:00:1a.0: debug port 2
[   10.602035] ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
[   10.602166] ehci_hcd 0000:00:1a.0: irq 16, io mem 0xdf008000
[   10.609754] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   10.610131] sd 1:0:0:0: Attached scsi generic sg1 type 0
[   10.610496] sr 2:0:0:0: Attached scsi generic sg2 type 5
[   10.613772] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[   10.614107] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
[   10.614110] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   10.614112] usb usb3: Product: EHCI Host Controller
[   10.614114] usb usb3: Manufacturer: Linux 3.1.0-rc3-00161-g671ee7f-dirty ehci_hcd
[   10.614116] usb usb3: SerialNumber: 0000:00:1a.0
[   10.614996] hub 3-0:1.0: USB hub found
[   10.615068] hub 3-0:1.0: 2 ports detected
[   10.616163] ehci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[   10.616230] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[   10.616233] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[   10.616278] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 4
[   10.616368] ehci_hcd 0000:00:1d.0: debug port 2
[   10.620246] ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
[   10.620391] ehci_hcd 0000:00:1d.0: irq 23, io mem 0xdf007000
[   10.633604] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[   10.634012] usb usb4: New USB device found, idVendor=1d6b, idProduct=0002
[   10.634015] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   10.634017] usb usb4: Product: EHCI Host Controller
[   10.634019] usb usb4: Manufacturer: Linux 3.1.0-rc3-00161-g671ee7f-dirty ehci_hcd
[   10.634021] usb usb4: SerialNumber: 0000:00:1d.0
[   10.634909] hub 4-0:1.0: USB hub found
[   10.634981] hub 4-0:1.0: 2 ports detected
[   10.672481] atl1c 0000:05:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   10.672510] atl1c 0000:05:00.0: setting latency timer to 64
[   10.682508] mei: module is from the staging directory, the quality is unknown, you have been warned.
[   10.683087] mei 0000:00:16.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   10.683093] mei 0000:00:16.0: setting latency timer to 64
[   10.716532] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   10.725016] elantech: assuming hardware version 2, firmware version 4.2.1
[   10.753698] elantech: Synaptics capabilities query result 0x78, 0x14, 0x0b.
[   10.786429] snd_hda_intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[   10.786564] snd_hda_intel 0000:00:1b.0: irq 42 for MSI/MSI-X
[   10.786739] snd_hda_intel 0000:00:1b.0: setting latency timer to 64
[   10.787921] atl1c 0000:05:00.0: version 1.0.1.0-NAPI
[   10.817045] asus_wmi: ASUS WMI generic driver loaded
[   10.833795] input: ETPS/2 Elantech Touchpad as /devices/platform/i8042/serio4/input/input5
[   10.835684] asus_wmi: Initialization: 0x1
[   10.843333] asus_wmi: SFUN value: 0x1a0af7
[   10.877072] input: Asus WMI hotkeys as /devices/platform/asus-nb-wmi/input/input6
[   10.920208] usb 3-1: new high speed USB device number 2 using ehci_hcd
[   11.012419] asus_wmi: Backlight controlled by ACPI video driver
[   11.044250] usb 3-1: New USB device found, idVendor=8087, idProduct=0024
[   11.044256] usb 3-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[   11.045538] hub 3-1:1.0: USB hub found
[   11.045734] hub 3-1:1.0: 6 ports detected
[   11.153524] usb 4-1: new high speed USB device number 2 using ehci_hcd
[   11.246202] ath9k 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   11.246217] ath9k 0000:03:00.0: setting latency timer to 64
[   11.277171] usb 4-1: New USB device found, idVendor=8087, idProduct=0024
[   11.277175] usb 4-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[   11.278463] hub 4-1:1.0: USB hub found
[   11.278651] hub 4-1:1.0: 6 ports detected
[   11.296854] ath: EEPROM regdomain: 0x60
[   11.296857] ath: EEPROM indicates we should expect a direct regpair map
[   11.296861] ath: Country alpha2 being used: 00
[   11.296863] ath: Regpair used: 0x60
[   11.346921] usb 3-1.1: new full speed USB device number 3 using ehci_hcd
[   11.357860] ieee80211 phy0: Selected rate control algorithm 'ath9k_rate_control'
[   11.359445] Registered led device: ath9k-phy0
[   11.359455] ieee80211 phy0: Atheros AR9285 Rev:2 mem=0xffffc90006620000, irq=17
[   11.413705] usb 3-1.1: device descriptor read/64, error -32
[   11.423336] hda_codec: ALC269VB: BIOS auto-probing.
[   11.495168] HDMI status: Codec=3 Pin=6 Presence_Detect=0 ELD_Valid=0
[   11.503921] input: HDA Intel PCH HDMI/DP as /devices/pci0000:00/0000:00:1b.0/sound/card0/input7
[   11.504731] input: HDA Intel PCH Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
[   11.505555] input: HDA Intel PCH Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
[   11.601440] usb 3-1.1: New USB device found, idVendor=0cf3, idProduct=3005
[   11.601446] usb 3-1.1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[   11.670171] usb 3-1.2: new high speed USB device number 4 using ehci_hcd
[   11.760663] Bluetooth: Core ver 2.16
[   11.760748] NET: Registered protocol family 31
[   11.760751] Bluetooth: HCI device and connection manager initialized
[   11.760754] Bluetooth: HCI socket layer initialized
[   11.760757] Bluetooth: L2CAP socket layer initialized
[   11.760788] Bluetooth: SCO socket layer initialized
[   11.792316] usb 3-1.2: New USB device found, idVendor=13d3, idProduct=5122
[   11.792326] usb 3-1.2: New USB device strings: Mfr=2, Product=1, SerialNumber=3
[   11.792339] usb 3-1.2: Product: USB2.0 UVC 2M WebCam
[   11.792341] usb 3-1.2: Manufacturer: USB2.0 UVC 2M WebCam
[   11.792343] usb 3-1.2: SerialNumber: USB2.0 UVC 2M WebCam
[   11.796281] Bluetooth: Generic Bluetooth USB driver ver 0.6
[   12.026655] Linux media interface: v0.10
[   12.133247] Intel AES-NI instructions are not detected.
[   12.211459] Linux video capture interface: v2.00
[   12.274006] padlock_aes: VIA PadLock not detected.
[   12.291561] uvcvideo: Found UVC 1.00 device USB2.0 UVC 2M WebCam (13d3:5122)
[   12.303662] input: USB2.0 UVC 2M WebCam as /devices/pci0000:00/0000:00:1a.0/usb3/3-1/3-1.2/3-1.2:1.0/input/input10
[   12.304289] usbcore: registered new interface driver uvcvideo
[   12.304293] USB Video Class driver (1.1.1)
[   12.354255] usbcore: registered new interface driver btusb
[   13.988702] EXT4-fs (dm-0): re-mounted. Opts: (null)
[   15.130753] md: md0 stopped.
[   15.137769] md: bind<sdb1>
[   15.192893] md: raid1 personality registered for level 1
[   15.196594] md/raid1:md0: active with 1 out of 2 mirrors
[   15.196826] md0: detected capacity change from 0 to 98566144
[   15.202833]  md0: unknown partition table
[   16.278527] EXT4-fs (dm-1): mounted filesystem with ordered data mode. Opts: (null)
[   18.316987] atl1c 0000:05:00.0: irq 43 for MSI/MSI-X
[   18.317270] atl1c 0000:05:00.0: atl1c: eth0 NIC Link is Up<1000 Mbps Full Duplex>
[   28.837871] eth0: no IPv6 routers present
[   30.137705] uvesafb: Intel Corporation, Intel(R)Sandybridge Mobile Graphics Controller, Hardware Version 0.0, OEM: Intel(R)Sandybridge Mobile Graphics Chipset Accelerated VGA BIOS, VBE v3.0
[   30.146989] uvesafb: VBIOS/hardware supports DDC2 transfers
[   30.159418] uvesafb: monitor limits: vf = 60 Hz, hf = 57 kHz, clk = 107 MHz
[   30.159675] uvesafb: scrolling: redraw
[   30.159702] mtrr: type mismatch for b0000000,800000 old: write-back new: write-combining
[   30.159714] mtrr: type mismatch for b0000000,400000 old: write-back new: write-combining
[   30.159726] mtrr: type mismatch for b0000000,200000 old: write-back new: write-combining
[   30.159738] mtrr: type mismatch for b0000000,100000 old: write-back new: write-combining
[   30.159750] mtrr: type mismatch for b0000000,80000 old: write-back new: write-combining
[   30.159761] mtrr: type mismatch for b0000000,40000 old: write-back new: write-combining
[   30.159773] mtrr: type mismatch for b0000000,20000 old: write-back new: write-combining
[   30.159785] mtrr: type mismatch for b0000000,10000 old: write-back new: write-combining
[   30.159796] mtrr: type mismatch for b0000000,8000 old: write-back new: write-combining
[   30.159808] mtrr: type mismatch for b0000000,4000 old: write-back new: write-combining
[   30.159820] mtrr: type mismatch for b0000000,2000 old: write-back new: write-combining
[   30.159832] mtrr: type mismatch for b0000000,1000 old: write-back new: write-combining
[   30.250147] Console: switching to colour frame buffer device 80x30
[   30.250661] uvesafb: framebuffer at 0xb0000000, mapped to 0xffffc90006b00000, using 6144k, total 65472k
[   30.250664] fb0: VESA VGA frame buffer device

--nextPart3020778.6NdM028BRD--


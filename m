Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511Ab1F3We1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 18:34:27 -0400
Received: from webbox4.loswebos.de ([213.187.93.205]:38234 "EHLO
	webbox4.loswebos.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab1F3WeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 18:34:25 -0400
Date: Fri, 1 Jul 2011 00:34:01 +0200
From: Marc Koschewski <marc@osknowledge.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: [REGRESSION] suspend/resume broken on T510
Message-ID: <20110630223401.GA17292@marc.osknowledge.org>
References: <20110630220050.GB30291@marc.osknowledge.org>
 <201107010007.27588.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="WIyZ46R2i8wDzkSu"
Content-Disposition: inline
In-Reply-To: <201107010007.27588.rjw@sisk.pl>
X-PGP-Fingerprint: D514 7DC1 B5F5 8989 083E 38C9 5ECF E5BD 3430 ABF5
X-PGP-Key: http://www.kosik.org/pubkey.asc
X-Blog: http://www.kosik.org/blog/
X-Operating-System: Linux marc 2.6.39-dezzy
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

* Rafael J. Wysocki <rjw@sisk.pl> [2011-07-01 00:07:27 +0200]:

Hi Rafael,

I have attached some files here to let you know what machine won't resume.

Hope this helps,
Marc

> Hi,
> 
> On Friday, July 01, 2011, Marc Koschewski wrote:
> > Hi guys,
> > 
> > I just thought to wait some what longer than -rc3 to report: suspend/resume is
> > broken in the current git. I blacklisted the 'mei' module so the suspend worked
> > as of rc4 (last 'first tested and working' version) with knowledge of the
> > mei-bug.
> > 
> > However, my system does not resume anymore on my T510. After suspend the 'moon'
> > turns on as usual on 3.0.0-git and the box sleeps. After opening the lid it somehow
> > wakes up but doesn't boot/resume. It just stalls after some HDD activity.
> > 
> > If have no idea what it could be - and I unfortunately cannot bisect it down to
> > anything > 2.6.39. I left out rc1 and rc2 this time due to having no time to
> > experiment this month. However, my .config is attached if anyone needs it...
> 
> Well, perhaps let us know the hardware configuration (attach dmesg?).
> 
> Anyway, I'm not sure if there's anyone who can figure out what _may_ be wrong
> on the basis of your description alone.  It would be good if you could file
> a bug in http://bugzilla.kernel.org and let me know its number.
> 
> Thanks,
> Rafael
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 

-- 
Marc Koschewski

--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg.txt"

[    0.000000] Linux version 2.6.39-dezzy (marc@marc) (gcc version 4.6.0-pre9999 20110421 (prerelease) rev. 172845 (Gentoo SVN) ) #1 SMP PREEMPT Thu May 19 08:39:45 CEST 2011
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009dc00 (usable)
[    0.000000]  BIOS-e820: 000000000009dc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000d2000 - 00000000000d4000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bf27c000 (usable)
[    0.000000]  BIOS-e820: 00000000bf27c000 - 00000000bf282000 (reserved)
[    0.000000]  BIOS-e820: 00000000bf282000 - 00000000bf35f000 (usable)
[    0.000000]  BIOS-e820: 00000000bf35f000 - 00000000bf371000 (reserved)
[    0.000000]  BIOS-e820: 00000000bf371000 - 00000000bf3f2000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bf3f2000 - 00000000bf40f000 (reserved)
[    0.000000]  BIOS-e820: 00000000bf40f000 - 00000000bf46f000 (usable)
[    0.000000]  BIOS-e820: 00000000bf46f000 - 00000000bf668000 (reserved)
[    0.000000]  BIOS-e820: 00000000bf668000 - 00000000bf6e8000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bf6e8000 - 00000000bf70f000 (reserved)
[    0.000000]  BIOS-e820: 00000000bf70f000 - 00000000bf717000 (usable)
[    0.000000]  BIOS-e820: 00000000bf717000 - 00000000bf71f000 (reserved)
[    0.000000]  BIOS-e820: 00000000bf71f000 - 00000000bf76b000 (usable)
[    0.000000]  BIOS-e820: 00000000bf76b000 - 00000000bf777000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bf777000 - 00000000bf77a000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bf77a000 - 00000000bf781000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bf781000 - 00000000bf782000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bf782000 - 00000000bf78b000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bf78b000 - 00000000bf78c000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bf78c000 - 00000000bf79f000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bf79f000 - 00000000bf7ff000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bf7ff000 - 00000000bf800000 (usable)
[    0.000000]  BIOS-e820: 00000000bf800000 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000feaff000 - 00000000feb00000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 00000001fc000000 (usable)
[    0.000000]  BIOS-e820: 0000000200000000 - 000000023c000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] DMI: LENOVO 43495KG/43495KG, BIOS 6MET83WW (1.43 ) 02/24/2011
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] last_pfn = 0x23c000 max_arch_pfn = 0x1000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-D3FFF write-protect
[    0.000000]   D4000-DBFFF uncachable
[    0.000000]   DC000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 disabled
[    0.000000]   1 base 000000000 mask F80000000 write-back
[    0.000000]   2 base 080000000 mask FC0000000 write-back
[    0.000000]   3 base 100000000 mask F00000000 write-back
[    0.000000]   4 base 200000000 mask FC0000000 write-back
[    0.000000]   5 base 23C000000 mask FFC000000 uncachable
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000c0000000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] initial memory mapped : 0 - 01a00000
[    0.000000] Base memory trampoline at [c0099000] 99000 size 16384
[    0.000000] init_memory_mapping: 0000000000000000-0000000037bfe000
[    0.000000]  0000000000 - 0000200000 page 4k
[    0.000000]  0000200000 - 0037a00000 page 2M
[    0.000000]  0037a00000 - 0037bfe000 page 4k
[    0.000000] kernel direct mapping tables up to 37bfe000 @ 19fb000-1a00000
[    0.000000] ACPI: RSDP 000f6870 00024 (v02 LENOVO)
[    0.000000] ACPI: XSDT bf7ef2e1 0009C (v01 LENOVO TP-6M    00001430  LTP 00000000)
[    0.000000] ACPI: FACP bf7ef400 000F4 (v04 LENOVO TP-6M    00001430 LNVO 00000001)
[    0.000000] ACPI: DSDT bf7ef7d1 0F34F (v01 LENOVO TP-6M    00001430 MSFT 03000001)
[    0.000000] ACPI: FACS bf6e7000 00040
[    0.000000] ACPI: SSDT bf7ef5b4 0021D (v01 LENOVO TP-6M    00001430 MSFT 03000001)
[    0.000000] ACPI: ECDT bf7feb20 00052 (v01 LENOVO TP-6M    00001430 LNVO 00000001)
[    0.000000] ACPI: APIC bf7feb72 00084 (v01 LENOVO TP-6M    00001430 LNVO 00000001)
[    0.000000] ACPI: MCFG bf7fec2e 0003C (v01 LENOVO TP-6M    00001430 LNVO 00000001)
[    0.000000] ACPI: HPET bf7fec6a 00038 (v01 LENOVO TP-6M    00001430 LNVO 00000001)
[    0.000000] ACPI: ASF! bf7fedbe 000A4 (v16 LENOVO TP-6M    00001430 PTL  00000001)
[    0.000000] ACPI: SLIC bf7fee62 00176 (v01 LENOVO TP-6M    00001430  LTP 00000000)
[    0.000000] ACPI: BOOT bf7fefd8 00028 (v01 LENOVO TP-6M    00001430  LTP 00000001)
[    0.000000] ACPI: SSDT bf6e591a 0084B (v01 LENOVO TP-6M    00001430 INTL 20050513)
[    0.000000] ACPI: TCPA bf78b000 00032 (v02    PTL  CRESTLN 06040000      00005A52)
[    0.000000] ACPI: DMAR bf781000 00080 (v01 INTEL  CP_DALE  00000001 INTL 00000001)
[    0.000000] ACPI: SSDT bf779000 009F1 (v01  PmRef    CpuPm 00003000 INTL 20060912)
[    0.000000] ACPI: SSDT bf778000 00259 (v01  PmRef  Cpu0Tst 00003000 INTL 20060912)
[    0.000000] ACPI: SSDT bf777000 0049F (v01  PmRef    ApTst 00003000 INTL 20060912)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 8260MB HIGHMEM available.
[    0.000000] 891MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 37bfe000
[    0.000000]   low ram: 0 - 37bfe000
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x00037bfe
[    0.000000]   HighMem  0x00037bfe -> 0x0023c000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[9] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009d
[    0.000000]     0: 0x00000100 -> 0x000bf27c
[    0.000000]     0: 0x000bf282 -> 0x000bf35f
[    0.000000]     0: 0x000bf40f -> 0x000bf46f
[    0.000000]     0: 0x000bf70f -> 0x000bf717
[    0.000000]     0: 0x000bf71f -> 0x000bf76b
[    0.000000]     0: 0x000bf7ff -> 0x000bf800
[    0.000000]     0: 0x00100000 -> 0x001fc000
[    0.000000]     0: 0x00200000 -> 0x0023c000
[    0.000000] On node 0 totalpages: 2061211
[    0.000000] free_area_init_node: node 0, pgdat c14e92c0, node_mem_map f347d200
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3949 pages, LIFO batch:0
[    0.000000]   Normal zone: 1752 pages used for memmap
[    0.000000]   Normal zone: 222502 pages, LIFO batch:31
[    0.000000]   HighMem zone: 16521 pages used for memmap
[    0.000000]   HighMem zone: 1816455 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009d000 - 000000000009e000
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000d2000
[    0.000000] PM: Registered nosave memory: 00000000000d2000 - 00000000000d4000
[    0.000000] PM: Registered nosave memory: 00000000000d4000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at c0000000 (gap: c0000000:20000000)
[    0.000000] setup_percpu: NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 12 pages/cpu @f3200000 s25984 r0 d23168 u524288
[    0.000000] pcpu-alloc: s25984 r0 d23168 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2042906
[    0.000000] Kernel command line: init=/sbin/init root=/dev/sda7 ro resume=/dev/sda8 resume2=swap:/dev/sda8 thinkpad_acpi.fan_control=1 thinkpad_acpi.experimental=1 thinkpad_acpi.volume_control=1 acpi_osi="Linux" console=tty1 libata.dma=3 libata.noacpi=0 nouveau.noaccel=1 threadirqs rootfstype=ext4 acpi_sleep=s3_bios
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00037bfe:0023c000)
[    0.000000] Memory: 8164640k/9371648k available (3705k kernel code, 80204k reserved, 1353k data, 368k init, 7331904k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff67000 - 0xfffff000   ( 608 kB)
[    0.000000]     pkmap   : 0xffc00000 - 0xffe00000   (2048 kB)
[    0.000000]     vmalloc : 0xf83fe000 - 0xffbfe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf7bfe000   ( 891 MB)
[    0.000000]       .init : 0xc14f1000 - 0xc154d000   ( 368 kB)
[    0.000000]       .data : 0xc139e538 - 0xc14f0ac0   (1353 kB)
[    0.000000]       .text : 0xc1000000 - 0xc139e538   (3705 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Preemptable hierarchical RCU implementation.
[    0.000000] 	RCU-based detection of stalled CPUs is disabled.
[    0.000000] 	Verbose stalled-CPUs detection is disabled.
[    0.000000] NR_IRQS:384
[    0.000000] CPU 0 irqstacks, hard=f2c0c000 soft=f2c0e000
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty1] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.001000] Detected 2660.254 MHz processor.
[    0.000002] Calibrating delay loop (skipped), value calculated using timer frequency.. 5320.50 BogoMIPS (lpj=2660254)
[    0.000247] pid_max: default: 32768 minimum: 301
[    0.000399] Mount-cache hash table entries: 512
[    0.000642] CPU: Physical Processor ID: 0
[    0.000766] CPU: Processor Core ID: 0
[    0.000889] mce: CPU supports 9 MCE banks
[    0.001016] CPU0: Thermal monitoring enabled (TM1)
[    0.001145] using mwait in idle threads.
[    0.001581] ACPI: Core revision 20110316
[    0.013472] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.013991] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.024095] CPU0: Intel(R) Core(TM) i7 CPU       M 620  @ 2.67GHz stepping 05
[    0.125103] Performance Events: PEBS fmt1+, Westmere events, Intel PMU driver.
[    0.125402] ... version:                3
[    0.125523] ... bit width:              48
[    0.125644] ... generic registers:      4
[    0.125764] ... value mask:             0000ffffffffffff
[    0.125886] ... max period:             000000007fffffff
[    0.126008] ... fixed-purpose events:   3
[    0.126130] ... event mask:             000000070000000f
[    0.138085] CPU 1 irqstacks, hard=f2cce000 soft=f2cd0000
[    0.138088] Booting Node   0, Processors  #1
[    0.138158] smpboot cpu 1: start_ip = 99000
[    0.148836] Initializing CPU#1
[    0.232850] CPU 2 irqstacks, hard=f2cda000 soft=f2cdc000
[    0.232985]  #2
[    0.233015] smpboot cpu 2: start_ip = 99000
[    0.243345] Initializing CPU#2
[    0.327608] CPU 3 irqstacks, hard=f2cea000 soft=f2cec000
[    0.327743]  #3 Ok.
[    0.329885] smpboot cpu 3: start_ip = 99000
[    0.340101] Initializing CPU#3
[    0.420484] Brought up 4 CPUs
[    0.420726] Total of 4 processors activated (21279.62 BogoMIPS).
[    0.422526] PM: Registering ACPI NVS region at bf371000 (528384 bytes)
[    0.422667] PM: Registering ACPI NVS region at bf668000 (524288 bytes)
[    0.422801] PM: Registering ACPI NVS region at bf76b000 (49152 bytes)
[    0.422928] PM: Registering ACPI NVS region at bf77a000 (28672 bytes)
[    0.423053] PM: Registering ACPI NVS region at bf782000 (36864 bytes)
[    0.423178] PM: Registering ACPI NVS region at bf78c000 (77824 bytes)
[    0.423402] print_constraints: dummy: 
[    0.423561] NET: Registered protocol family 16
[    0.423854] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.424072] ACPI: bus type pci registered
[    0.424248] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.424471] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.424596] PCI: Using MMCONFIG for extended config space
[    0.424719] PCI: Using configuration type 1 for base access
[    0.426502] bio: create slab <bio-0> at 0
[    0.426690] ACPI: Added _OSI(Linux)
[    0.428009] ACPI: EC: EC description table is found, configuring boot EC
[    0.431716] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query honored via cmdline
[    0.519290] ACPI: SSDT bf71a598 004F3 (v01  PmRef  Cpu0Ist 00003000 INTL 20060912)
[    0.519824] ACPI: Dynamic OEM Table Load:
[    0.520000] ACPI: SSDT   (null) 004F3 (v01  PmRef  Cpu0Ist 00003000 INTL 20060912)
[    0.520366] ACPI: SSDT bf718718 006B2 (v01  PmRef  Cpu0Cst 00003001 INTL 20060912)
[    0.520907] ACPI: Dynamic OEM Table Load:
[    0.521082] ACPI: SSDT   (null) 006B2 (v01  PmRef  Cpu0Cst 00003001 INTL 20060912)
[    0.526329] ACPI: SSDT bf719a98 00303 (v01  PmRef    ApIst 00003000 INTL 20060912)
[    0.526898] ACPI: Dynamic OEM Table Load:
[    0.527079] ACPI: SSDT   (null) 00303 (v01  PmRef    ApIst 00003000 INTL 20060912)
[    0.530204] ACPI: SSDT bf717d98 00119 (v01  PmRef    ApCst 00003000 INTL 20060912)
[    0.530744] ACPI: Dynamic OEM Table Load:
[    0.530921] ACPI: SSDT   (null) 00119 (v01  PmRef    ApCst 00003000 INTL 20060912)
[    0.535547] ACPI: Interpreter enabled
[    0.535673] ACPI: (supports S0 S3 S4 S5)
[    0.535913] ACPI: Using IOAPIC for interrupt routing
[    0.541026] ACPI: Power Resource [PUBS] (on)
[    0.544662] ACPI: EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
[    0.552848] ACPI: ACPI Dock Station Driver: 2 docks/bays found
[    0.552976] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.553204] ACPI: PCI Root Bridge [UNCR] (domain 0000 [bus ff])
[    0.553362] pci 0000:ff:00.0: [8086:2c62] type 0 class 0x000600
[    0.553384] pci 0000:ff:00.1: [8086:2d01] type 0 class 0x000600
[    0.553404] pci 0000:ff:02.0: [8086:2d10] type 0 class 0x000600
[    0.553421] pci 0000:ff:02.1: [8086:2d11] type 0 class 0x000600
[    0.553439] pci 0000:ff:02.2: [8086:2d12] type 0 class 0x000600
[    0.553456] pci 0000:ff:02.3: [8086:2d13] type 0 class 0x000600
[    0.553480] pci_bus 0000:ff: on NUMA node 0
[    0.553486]  pci0000:ff: Requesting ACPI _OSC control (0x1d)
[    0.553613] Unable to assume _OSC PCIe control. Disabling ASPM
[    0.553982] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-fe])
[    0.554153] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.554283] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.554409] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.554623] pci_root PNP0A08:00: host bridge window [mem 0x000d4000-0x000d7fff]
[    0.554835] pci_root PNP0A08:00: host bridge window [mem 0x000d8000-0x000dbfff]
[    0.555054] pci_root PNP0A08:00: host bridge window [mem 0x000dc000-0x000dffff]
[    0.555267] pci_root PNP0A08:00: host bridge window [mem 0xc0000000-0xfebfffff]
[    0.555488] pci 0000:00:00.0: [8086:0044] type 0 class 0x000600
[    0.555517] pci 0000:00:01.0: [8086:0045] type 1 class 0x000604
[    0.555538] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.555540] pci 0000:00:01.0: PME# disabled
[    0.555584] pci 0000:00:16.0: [8086:3b64] type 0 class 0x000780
[    0.555610] pci 0000:00:16.0: reg 10: [mem 0xf2427800-0xf242780f 64bit]
[    0.555683] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.555688] pci 0000:00:16.0: PME# disabled
[    0.555726] pci 0000:00:19.0: [8086:10ea] type 0 class 0x000200
[    0.555750] pci 0000:00:19.0: reg 10: [mem 0xf2400000-0xf241ffff]
[    0.555761] pci 0000:00:19.0: reg 14: [mem 0xf2425000-0xf2425fff]
[    0.555772] pci 0000:00:19.0: reg 18: [io  0x1820-0x183f]
[    0.555839] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.555843] pci 0000:00:19.0: PME# disabled
[    0.555870] pci 0000:00:1a.0: [8086:3b3c] type 0 class 0x000c03
[    0.555894] pci 0000:00:1a.0: reg 10: [mem 0xf2428000-0xf24283ff]
[    0.555980] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.555984] pci 0000:00:1a.0: PME# disabled
[    0.556015] pci 0000:00:1b.0: [8086:3b56] type 0 class 0x000403
[    0.556036] pci 0000:00:1b.0: reg 10: [mem 0xf2420000-0xf2423fff 64bit]
[    0.556110] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.556114] pci 0000:00:1b.0: PME# disabled
[    0.556136] pci 0000:00:1c.0: [8086:3b42] type 1 class 0x000604
[    0.556210] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.556214] pci 0000:00:1c.0: PME# disabled
[    0.556238] pci 0000:00:1c.1: [8086:3b44] type 1 class 0x000604
[    0.556314] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.556318] pci 0000:00:1c.1: PME# disabled
[    0.556343] pci 0000:00:1c.3: [8086:3b48] type 1 class 0x000604
[    0.556419] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.556423] pci 0000:00:1c.3: PME# disabled
[    0.556447] pci 0000:00:1c.4: [8086:3b4a] type 1 class 0x000604
[    0.556521] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.556525] pci 0000:00:1c.4: PME# disabled
[    0.556558] pci 0000:00:1d.0: [8086:3b34] type 0 class 0x000c03
[    0.556582] pci 0000:00:1d.0: reg 10: [mem 0xf2428400-0xf24287ff]
[    0.556668] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.556672] pci 0000:00:1d.0: PME# disabled
[    0.556695] pci 0000:00:1e.0: [8086:2448] type 1 class 0x000604
[    0.556767] pci 0000:00:1f.0: [8086:3b07] type 0 class 0x000601
[    0.556880] pci 0000:00:1f.2: [8086:3b2f] type 0 class 0x000106
[    0.556905] pci 0000:00:1f.2: reg 10: [io  0x1818-0x181f]
[    0.556916] pci 0000:00:1f.2: reg 14: [io  0x180c-0x180f]
[    0.556926] pci 0000:00:1f.2: reg 18: [io  0x1810-0x1817]
[    0.556936] pci 0000:00:1f.2: reg 1c: [io  0x1808-0x180b]
[    0.556946] pci 0000:00:1f.2: reg 20: [io  0x1840-0x185f]
[    0.556957] pci 0000:00:1f.2: reg 24: [mem 0xf2427000-0xf24277ff]
[    0.557005] pci 0000:00:1f.2: PME# supported from D3hot
[    0.557009] pci 0000:00:1f.2: PME# disabled
[    0.557030] pci 0000:00:1f.3: [8086:3b30] type 0 class 0x000c05
[    0.557050] pci 0000:00:1f.3: reg 10: [mem 0xf2428800-0xf24288ff 64bit]
[    0.557079] pci 0000:00:1f.3: reg 20: [io  0x1860-0x187f]
[    0.557122] pci 0000:00:1f.6: [8086:3b32] type 0 class 0x001180
[    0.557148] pci 0000:00:1f.6: reg 10: [mem 0xf2426000-0xf2426fff 64bit]
[    0.557258] pci 0000:01:00.0: [10de:0a6c] type 0 class 0x000300
[    0.557269] pci 0000:01:00.0: reg 10: [mem 0xcc000000-0xccffffff]
[    0.557282] pci 0000:01:00.0: reg 14: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.557294] pci 0000:01:00.0: reg 1c: [mem 0xce000000-0xcfffffff 64bit pref]
[    0.557302] pci 0000:01:00.0: reg 24: [io  0x2000-0x207f]
[    0.557311] pci 0000:01:00.0: reg 30: [mem 0x00000000-0x0007ffff pref]
[    0.557359] pci 0000:01:00.1: [10de:0be3] type 0 class 0x000403
[    0.557370] pci 0000:01:00.1: reg 10: [mem 0xcdefc000-0xcdefffff]
[    0.557455] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.557554] pci 0000:00:01.0:   bridge window [io  0x2000-0x2fff]
[    0.557556] pci 0000:00:01.0:   bridge window [mem 0xcc000000-0xcdefffff]
[    0.557559] pci 0000:00:01.0:   bridge window [mem 0xce000000-0xdfffffff 64bit pref]
[    0.557612] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.557712] pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.557716] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.557723] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.557848] pci 0000:03:00.0: [8086:4238] type 0 class 0x000280
[    0.557905] pci 0000:03:00.0: reg 10: [mem 0xf2000000-0xf2001fff 64bit]
[    0.558100] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.558126] pci 0000:03:00.0: PME# disabled
[    0.558192] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.558293] pci 0000:00:1c.1:   bridge window [io  0xf000-0x0000] (disabled)
[    0.558297] pci 0000:00:1c.1:   bridge window [mem 0xf2000000-0xf20fffff]
[    0.558304] pci 0000:00:1c.1:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.558358] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    0.558458] pci 0000:00:1c.3:   bridge window [io  0x3000-0x3fff]
[    0.558462] pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf1ffffff]
[    0.558469] pci 0000:00:1c.3:   bridge window [mem 0xf2500000-0xf25fffff 64bit pref]
[    0.558592] pci 0000:0d:00.0: [1180:e822] type 0 class 0x000805
[    0.558614] pci 0000:0d:00.0: reg 10: [mem 0xf2100000-0xf21000ff]
[    0.558746] pci 0000:0d:00.0: supports D1 D2
[    0.558747] pci 0000:0d:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.558753] pci 0000:0d:00.0: PME# disabled
[    0.558798] pci 0000:0d:00.1: [1180:e230] type 0 class 0x000880
[    0.558820] pci 0000:0d:00.1: reg 10: [mem 0xf2100400-0xf21004ff]
[    0.558952] pci 0000:0d:00.1: supports D1 D2
[    0.558953] pci 0000:0d:00.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.558958] pci 0000:0d:00.1: PME# disabled
[    0.559005] pci 0000:0d:00.3: [1180:e832] type 0 class 0x000c00
[    0.559026] pci 0000:0d:00.3: reg 10: [mem 0xf2100800-0xf2100fff]
[    0.559158] pci 0000:0d:00.3: supports D1 D2
[    0.559160] pci 0000:0d:00.3: PME# supported from D0 D1 D2 D3hot D3cold
[    0.559165] pci 0000:0d:00.3: PME# disabled
[    0.559230] pci 0000:00:1c.4: PCI bridge to [bus 0d-0d]
[    0.559331] pci 0000:00:1c.4:   bridge window [io  0xf000-0x0000] (disabled)
[    0.559336] pci 0000:00:1c.4:   bridge window [mem 0xf2100000-0xf21fffff]
[    0.559342] pci 0000:00:1c.4:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.559412] pci 0000:00:1e.0: PCI bridge to [bus 0e-0e] (subtractive decode)
[    0.559515] pci 0000:00:1e.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.559520] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.559526] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.559528] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.559530] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.559531] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.559533] pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive decode)
[    0.559534] pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
[    0.559536] pci 0000:00:1e.0:   bridge window [mem 0x000dc000-0x000dffff] (subtractive decode)
[    0.559537] pci 0000:00:1e.0:   bridge window [mem 0xc0000000-0xfebfffff] (subtractive decode)
[    0.559569] pci_bus 0000:00: on NUMA node 0
[    0.559570] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.559647] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEG_._PRT]
[    0.559668] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
[    0.559687] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP2._PRT]
[    0.559707] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP4._PRT]
[    0.559729] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP5._PRT]
[    0.559827]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.560056] Unable to assume _OSC PCIe control. Disabling ASPM
[    0.562883] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
[    0.563273] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 *10 11)
[    0.563648] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.564149] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 *10 11)
[    0.564533] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
[    0.564915] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 *10 11)
[    0.565296] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.565792] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 *10 11)
[    0.566262] SCSI subsystem initialized
[    0.566393] libata version 3.00 loaded.
[    0.566427] usbcore: registered new interface driver usbfs
[    0.566541] usbcore: registered new interface driver hub
[    0.566659] usbcore: registered new device driver usb
[    0.566848] Advanced Linux Sound Architecture Driver Version 1.0.24.
[    0.566947] PCI: Using ACPI for IRQ routing
[    0.567047] PCI: pci_cache_line_size set to 64 bytes
[    0.567134] reserve RAM buffer: 000000000009dc00 - 000000000009ffff 
[    0.567136] reserve RAM buffer: 00000000bf27c000 - 00000000bfffffff 
[    0.567140] reserve RAM buffer: 00000000bf35f000 - 00000000bfffffff 
[    0.567145] reserve RAM buffer: 00000000bf46f000 - 00000000bfffffff 
[    0.567149] reserve RAM buffer: 00000000bf717000 - 00000000bfffffff 
[    0.567152] reserve RAM buffer: 00000000bf76b000 - 00000000bfffffff 
[    0.567155] reserve RAM buffer: 00000000bf800000 - 00000000bfffffff 
[    0.567270] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.567585] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.569692] Switching to clocksource hpet
[    0.569837] pnp: PnP ACPI init
[    0.569935] ACPI: bus type pnp registered
[    0.570024] Switched to NOHz mode on CPU #1
[    0.570106] Switched to NOHz mode on CPU #2
[    0.570109] Switched to NOHz mode on CPU #3
[    0.570340] Switched to NOHz mode on CPU #0
[    0.570908] pnp 00:00: [mem 0x00000000-0x0009ffff]
[    0.570909] pnp 00:00: [mem 0x000c0000-0x000c3fff]
[    0.570911] pnp 00:00: [mem 0x000c4000-0x000c7fff]
[    0.570912] pnp 00:00: [mem 0x000c8000-0x000cbfff]
[    0.570913] pnp 00:00: [mem 0x000cc000-0x000cffff]
[    0.570914] pnp 00:00: [mem 0x000d0000-0x000d3fff]
[    0.570916] pnp 00:00: [mem 0x000d4000-0x000d3fff disabled]
[    0.570917] pnp 00:00: [mem 0x000d8000-0x000d7fff disabled]
[    0.570918] pnp 00:00: [mem 0x000dc000-0x000dbfff disabled]
[    0.570920] pnp 00:00: [mem 0x000e0000-0x000e3fff]
[    0.570921] pnp 00:00: [mem 0x000e4000-0x000e7fff]
[    0.570922] pnp 00:00: [mem 0x000e8000-0x000ebfff]
[    0.570923] pnp 00:00: [mem 0x000ec000-0x000effff]
[    0.570925] pnp 00:00: [mem 0x000f0000-0x000fffff]
[    0.570926] pnp 00:00: [mem 0x00100000-0xbfffffff]
[    0.570927] pnp 00:00: [mem 0xfec00000-0xfed3ffff]
[    0.570928] pnp 00:00: [mem 0xfed4c000-0xffffffff]
[    0.570992] system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.571093] system 00:00: [mem 0x000c0000-0x000c3fff] could not be reserved
[    0.571194] system 00:00: [mem 0x000c4000-0x000c7fff] could not be reserved
[    0.571294] system 00:00: [mem 0x000c8000-0x000cbfff] has been reserved
[    0.571393] system 00:00: [mem 0x000cc000-0x000cffff] could not be reserved
[    0.571494] system 00:00: [mem 0x000d0000-0x000d3fff] could not be reserved
[    0.571595] system 00:00: [mem 0x000e0000-0x000e3fff] could not be reserved
[    0.571695] system 00:00: [mem 0x000e4000-0x000e7fff] could not be reserved
[    0.571797] system 00:00: [mem 0x000e8000-0x000ebfff] could not be reserved
[    0.571917] system 00:00: [mem 0x000ec000-0x000effff] could not be reserved
[    0.572017] system 00:00: [mem 0x000f0000-0x000fffff] could not be reserved
[    0.572118] system 00:00: [mem 0x00100000-0xbfffffff] could not be reserved
[    0.572219] system 00:00: [mem 0xfec00000-0xfed3ffff] could not be reserved
[    0.572319] system 00:00: [mem 0xfed4c000-0xffffffff] could not be reserved
[    0.572420] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.572429] pnp 00:01: [bus ff]
[    0.572477] pnp 00:01: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.572489] pnp 00:02: [bus 00-fe]
[    0.572491] pnp 00:02: [io  0x0cf8-0x0cff]
[    0.572493] pnp 00:02: [io  0x0000-0x0cf7 window]
[    0.572494] pnp 00:02: [io  0x0d00-0xffff window]
[    0.572495] pnp 00:02: [mem 0x000a0000-0x000bffff window]
[    0.572497] pnp 00:02: [mem 0x000c0000-0x000c3fff window]
[    0.572498] pnp 00:02: [mem 0x000c4000-0x000c7fff window]
[    0.572499] pnp 00:02: [mem 0x000c8000-0x000cbfff window]
[    0.572501] pnp 00:02: [mem 0x000cc000-0x000cffff window]
[    0.572502] pnp 00:02: [mem 0x000d0000-0x000d3fff window]
[    0.572504] pnp 00:02: [mem 0x000d4000-0x000d7fff window]
[    0.572506] pnp 00:02: [mem 0x000d8000-0x000dbfff window]
[    0.572507] pnp 00:02: [mem 0x000dc000-0x000dffff window]
[    0.572508] pnp 00:02: [mem 0x000e0000-0x000e3fff window]
[    0.572510] pnp 00:02: [mem 0x000e4000-0x000e7fff window]
[    0.572511] pnp 00:02: [mem 0x000e8000-0x000ebfff window]
[    0.572512] pnp 00:02: [mem 0x000ec000-0x000effff window]
[    0.572514] pnp 00:02: [mem 0xc0000000-0xfebfffff window]
[    0.572515] pnp 00:02: [mem 0xfed40000-0xfed4bfff window]
[    0.572560] pnp 00:02: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    0.572798] pnp 00:03: [io  0x0010-0x001f]
[    0.572799] pnp 00:03: [io  0x0090-0x009f]
[    0.572800] pnp 00:03: [io  0x0024-0x0025]
[    0.572801] pnp 00:03: [io  0x0028-0x0029]
[    0.572803] pnp 00:03: [io  0x002c-0x002d]
[    0.572804] pnp 00:03: [io  0x0030-0x0031]
[    0.572805] pnp 00:03: [io  0x0034-0x0035]
[    0.572806] pnp 00:03: [io  0x0038-0x0039]
[    0.572807] pnp 00:03: [io  0x003c-0x003d]
[    0.572808] pnp 00:03: [io  0x00a4-0x00a5]
[    0.572809] pnp 00:03: [io  0x00a8-0x00a9]
[    0.572811] pnp 00:03: [io  0x00ac-0x00ad]
[    0.572812] pnp 00:03: [io  0x00b0-0x00b5]
[    0.572813] pnp 00:03: [io  0x00b8-0x00b9]
[    0.572814] pnp 00:03: [io  0x00bc-0x00bd]
[    0.572815] pnp 00:03: [io  0x0050-0x0053]
[    0.572816] pnp 00:03: [io  0x0072-0x0077]
[    0.572817] pnp 00:03: [io  0x164e-0x164f]
[    0.572818] pnp 00:03: [io  0x002e-0x002f]
[    0.572820] pnp 00:03: [io  0x1000-0x107f]
[    0.572821] pnp 00:03: [io  0x1180-0x11ff]
[    0.572822] pnp 00:03: [io  0x0800-0x080f]
[    0.572823] pnp 00:03: [io  0x15e0-0x15ef]
[    0.572824] pnp 00:03: [io  0x1600-0x1641]
[    0.572841] pnp 00:03: [io  0x1644-0x167f]
[    0.572842] pnp 00:03: [mem 0xe0000000-0xefffffff]
[    0.572843] pnp 00:03: [mem 0xfeaff000-0xfeafffff]
[    0.572845] pnp 00:03: [mem 0xfed1c000-0xfed1ffff]
[    0.572846] pnp 00:03: [mem 0xfed10000-0xfed13fff]
[    0.572847] pnp 00:03: [mem 0xfed18000-0xfed18fff]
[    0.572848] pnp 00:03: [mem 0xfed19000-0xfed19fff]
[    0.572850] pnp 00:03: [mem 0xfed45000-0xfed4bfff]
[    0.572924] system 00:03: [io  0x164e-0x164f] has been reserved
[    0.573024] system 00:03: [io  0x1000-0x107f] has been reserved
[    0.573123] system 00:03: [io  0x1180-0x11ff] has been reserved
[    0.573222] system 00:03: [io  0x0800-0x080f] has been reserved
[    0.573320] system 00:03: [io  0x15e0-0x15ef] has been reserved
[    0.573420] system 00:03: [io  0x1600-0x1641] has been reserved
[    0.573519] system 00:03: [io  0x1644-0x167f] could not be reserved
[    0.573618] system 00:03: [mem 0xe0000000-0xefffffff] has been reserved
[    0.573718] system 00:03: [mem 0xfeaff000-0xfeafffff] has been reserved
[    0.573817] system 00:03: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.573931] system 00:03: [mem 0xfed10000-0xfed13fff] has been reserved
[    0.574031] system 00:03: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.574132] system 00:03: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.574232] system 00:03: [mem 0xfed45000-0xfed4bfff] has been reserved
[    0.574333] system 00:03: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.574354] pnp 00:04: [mem 0xfed00000-0xfed003ff]
[    0.574392] pnp 00:04: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.574398] pnp 00:05: [io  0x0000-0x000f]
[    0.574400] pnp 00:05: [io  0x0080-0x008f]
[    0.574401] pnp 00:05: [io  0x00c0-0x00df]
[    0.574402] pnp 00:05: [dma 4]
[    0.574436] pnp 00:05: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.574441] pnp 00:06: [io  0x0061]
[    0.574475] pnp 00:06: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.574480] pnp 00:07: [io  0x00f0]
[    0.574486] pnp 00:07: [irq 13]
[    0.574520] pnp 00:07: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.574526] pnp 00:08: [io  0x0070-0x0071]
[    0.574531] pnp 00:08: [irq 8]
[    0.574565] pnp 00:08: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.574571] pnp 00:09: [io  0x0060]
[    0.574572] pnp 00:09: [io  0x0064]
[    0.574576] pnp 00:09: [irq 1]
[    0.574611] pnp 00:09: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.574619] pnp 00:0a: [irq 12]
[    0.574654] pnp 00:0a: Plug and Play ACPI device, IDs LEN0015 PNP0f13 (active)
[    0.574921] pnp 00:0b: [mem 0xfed40000-0xfed44fff]
[    0.574963] pnp 00:0b: Plug and Play ACPI device, IDs SMO1200 PNP0c31 (active)
[    0.575571] pnp: PnP ACPI: found 12 devices
[    0.575668] ACPI: ACPI bus type pnp unregistered
[    0.612461] pci 0000:01:00.0: BAR 6: assigned [mem 0xcd000000-0xcd07ffff pref]
[    0.612626] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.612724] pci 0000:00:01.0:   bridge window [io  0x2000-0x2fff]
[    0.612831] pci 0000:00:01.0:   bridge window [mem 0xcc000000-0xcdefffff]
[    0.612932] pci 0000:00:01.0:   bridge window [mem 0xce000000-0xdfffffff 64bit pref]
[    0.613099] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.613196] pci 0000:00:1c.0:   bridge window [io  disabled]
[    0.613298] pci 0000:00:1c.0:   bridge window [mem disabled]
[    0.613398] pci 0000:00:1c.0:   bridge window [mem pref disabled]
[    0.613503] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.613600] pci 0000:00:1c.1:   bridge window [io  disabled]
[    0.613702] pci 0000:00:1c.1:   bridge window [mem 0xf2000000-0xf20fffff]
[    0.613811] pci 0000:00:1c.1:   bridge window [mem pref disabled]
[    0.613915] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    0.614016] pci 0000:00:1c.3:   bridge window [io  0x3000-0x3fff]
[    0.614118] pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf1ffffff]
[    0.614220] pci 0000:00:1c.3:   bridge window [mem 0xf2500000-0xf25fffff 64bit pref]
[    0.614390] pci 0000:00:1c.4: PCI bridge to [bus 0d-0d]
[    0.614487] pci 0000:00:1c.4:   bridge window [io  disabled]
[    0.614589] pci 0000:00:1c.4:   bridge window [mem 0xf2100000-0xf21fffff]
[    0.614692] pci 0000:00:1c.4:   bridge window [mem pref disabled]
[    0.614802] pci 0000:00:1e.0: PCI bridge to [bus 0e-0e]
[    0.614899] pci 0000:00:1e.0:   bridge window [io  disabled]
[    0.615000] pci 0000:00:1e.0:   bridge window [mem disabled]
[    0.615101] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    0.615220] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.615320] pci 0000:00:01.0: setting latency timer to 64
[    0.615326] pci 0000:00:1c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    0.615428] pci 0000:00:1c.0: setting latency timer to 64
[    0.615436] pci 0000:00:1c.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    0.615537] pci 0000:00:1c.1: setting latency timer to 64
[    0.615545] pci 0000:00:1c.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    0.615647] pci 0000:00:1c.3: setting latency timer to 64
[    0.615653] pci 0000:00:1c.4: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    0.615762] pci 0000:00:1c.4: setting latency timer to 64
[    0.615769] pci 0000:00:1e.0: setting latency timer to 64
[    0.615773] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.615774] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.615776] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.615777] pci_bus 0000:00: resource 7 [mem 0x000d4000-0x000d7fff]
[    0.615779] pci_bus 0000:00: resource 8 [mem 0x000d8000-0x000dbfff]
[    0.615781] pci_bus 0000:00: resource 9 [mem 0x000dc000-0x000dffff]
[    0.615782] pci_bus 0000:00: resource 10 [mem 0xc0000000-0xfebfffff]
[    0.615784] pci_bus 0000:01: resource 0 [io  0x2000-0x2fff]
[    0.615785] pci_bus 0000:01: resource 1 [mem 0xcc000000-0xcdefffff]
[    0.615787] pci_bus 0000:01: resource 2 [mem 0xce000000-0xdfffffff 64bit pref]
[    0.615789] pci_bus 0000:03: resource 1 [mem 0xf2000000-0xf20fffff]
[    0.615790] pci_bus 0000:05: resource 0 [io  0x3000-0x3fff]
[    0.615791] pci_bus 0000:05: resource 1 [mem 0xf0000000-0xf1ffffff]
[    0.615793] pci_bus 0000:05: resource 2 [mem 0xf2500000-0xf25fffff 64bit pref]
[    0.615794] pci_bus 0000:0d: resource 1 [mem 0xf2100000-0xf21fffff]
[    0.615796] pci_bus 0000:0e: resource 4 [io  0x0000-0x0cf7]
[    0.615797] pci_bus 0000:0e: resource 5 [io  0x0d00-0xffff]
[    0.615798] pci_bus 0000:0e: resource 6 [mem 0x000a0000-0x000bffff]
[    0.615800] pci_bus 0000:0e: resource 7 [mem 0x000d4000-0x000d7fff]
[    0.615801] pci_bus 0000:0e: resource 8 [mem 0x000d8000-0x000dbfff]
[    0.615803] pci_bus 0000:0e: resource 9 [mem 0x000dc000-0x000dffff]
[    0.615804] pci_bus 0000:0e: resource 10 [mem 0xc0000000-0xfebfffff]
[    0.615820] NET: Registered protocol family 2
[    0.615935] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.616086] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.616439] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.616634] TCP: Hash tables configured (established 131072 bind 65536)
[    0.616758] TCP reno registered
[    0.616853] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    0.616953] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    0.617120] NET: Registered protocol family 1
[    0.617235] Simple Boot Flag at 0x35 set to 0x1
[    0.618517] highmem bounce pool size: 64 pages
[    0.620887] msgmni has been set to 1626
[    0.621278] alg: No test for stdrng (krng)
[    0.621441] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.621608] io scheduler noop registered
[    0.623442] io scheduler deadline registered
[    0.623546] io scheduler cfq registered (default)
[    0.623718] pcieport 0000:00:01.0: setting latency timer to 64
[    0.623738] pcieport 0000:00:01.0: irq 40 for MSI/MSI-X
[    0.624058] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.624156] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.624415] acpiphp: Slot [1] registered
[    0.624555] intel_idle: MWAIT substates: 0x1120
[    0.624557] intel_idle: v0.4 model 0x25
[    0.624558] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.633070] acpi device:0c: registered as cooling_device0
[    0.633280] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:0b/LNXVIDEO:01/input/input0
[    0.633452] ACPI: Video Device [VID1] (multi-head: yes  rom: yes  post: no)
[    0.633616] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.698889] Non-volatile memory driver v1.3
[    0.699021] Linux agpgart interface v0.103
[    0.699146] [drm] Initialized drm 1.1.0 20060810
[    0.699351] ahci 0000:00:1f.2: version 3.0
[    0.699359] ahci 0000:00:1f.2: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.699490] ahci 0000:00:1f.2: irq 41 for MSI/MSI-X
[    0.699541] ahci: SSS flag set, parallel bus scan disabled
[    0.699684] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 3 Gbps 0x33 impl SATA mode
[    0.699851] ahci 0000:00:1f.2: flags: 64bit ncq sntf ilck stag pm led clo pio slum part ems sxs apst 
[    0.700021] ahci 0000:00:1f.2: setting latency timer to 64
[    0.706144] scsi0 : ahci
[    0.706322] scsi1 : ahci
[    0.706514] scsi2 : ahci
[    0.706685] scsi3 : ahci
[    0.706854] scsi4 : ahci
[    0.707025] scsi5 : ahci
[    0.707461] ata1: SATA max UDMA/133 abar m2048@0xf2427000 port 0xf2427100 irq 41
[    0.707656] ata2: SATA max UDMA/133 abar m2048@0xf2427000 port 0xf2427180 irq 41
[    0.707820] ata3: DUMMY
[    0.707912] ata4: DUMMY
[    0.708006] ata5: SATA max UDMA/133 abar m2048@0xf2427000 port 0xf2427300 irq 41
[    0.708171] ata6: SATA max UDMA/133 abar m2048@0xf2427000 port 0xf2427380 irq 41
[    0.708534] usbcore: registered new interface driver libusual
[    0.708712] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    0.712864] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.712967] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.713165] mousedev: PS/2 mouse device common for all mice
[    0.713391] rtc_cmos 00:08: RTC can wake from S4
[    0.716372] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[    0.722599] rtc_cmos 00:08: rtc core: registered rtc_cmos as rtc0
[    0.722741] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    0.722983] device-mapper: ioctl: 4.20.0-ioctl (2011-02-02) initialised: dm-devel@redhat.com
[    0.723545] cpuidle: using governor ladder
[    0.724315] cpuidle: using governor menu
[    0.725103] ALSA device list:
[    0.725206]   No soundcards found.
[    0.725314] Netfilter messages via NETLINK v0.30.
[    0.725422] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    0.725794] ctnetlink v0.93: registering with nfnetlink.
[    0.726016] ip_tables: (C) 2000-2006 Netfilter Core Team
[    0.726175] TCP cubic registered
[    0.726282] Initializing XFRM netlink socket
[    0.726907] NET: Registered protocol family 10
[    0.727143] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    0.727262] IPv6 over IPv4 tunneling driver
[    0.727545] sit0: Features changed: 0x00007800 -> 0x00007000
[    0.727722] NET: Registered protocol family 17
[    0.727826] Using IPI No-Shortcut mode
[    1.011868] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.013754] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    1.013762] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    1.013949] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    1.015884] ata1.00: ATA-8: ST9320423AS, 0003LVM1, max UDMA/100
[    1.016002] ata1.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    1.018251] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    1.018259] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    1.018447] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    1.020354] ata1.00: configured for UDMA/100
[    1.020772] scsi 0:0:0:0: Direct-Access     ATA      ST9320423AS      0003 PQ: 0 ANSI: 5
[    1.021285] sd 0:0:0:0: [sda] 625142448 512-byte logical blocks: (320 GB/298 GiB)
[    1.021565] sd 0:0:0:0: [sda] Write Protect is off
[    1.021663] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.021684] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.022162] sda: detected capacity change from 0 to 320072933376
[    1.084204]  sda: sda1 sda2 < sda5 sda6 sda7 sda8 >
[    1.085162] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.325085] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.327970] ata2.00: ACPI cmd e3/00:10:00:00:00:a0 (IDLE) succeeded
[    1.328718] ata2.00: ACPI cmd e3/00:03:00:00:00:a0 (IDLE) succeeded
[    1.330510] ata2.00: ATAPI: MATSHITADVD-RAM UJ890, SB01, max UDMA/100
[    1.334201] ata2.00: ACPI cmd e3/00:10:00:00:00:a0 (IDLE) succeeded
[    1.335035] ata2.00: ACPI cmd e3/00:03:00:00:00:a0 (IDLE) succeeded
[    1.336785] ata2.00: configured for UDMA/100
[    1.340593] scsi 1:0:0:0: CD-ROM            MATSHITA DVD-RAM UJ890    SB01 PQ: 0 ANSI: 5
[    1.615345] Refined TSC clocksource calibration: 2659.999 MHz.
[    1.615469] Switching to clocksource tsc
[    1.645271] ata5: SATA link down (SStatus 0 SControl 300)
[    1.949503] ata6: SATA link down (SStatus 0 SControl 300)
[    2.003619] EXT4-fs (sda7): mounted filesystem with ordered data mode. Opts: (null)
[    2.003822] VFS: Mounted root (ext4 filesystem) readonly on device 8:7.
[    2.004021] Freeing unused kernel memory: 368k freed
[    6.036044] udevd[4938]: starting version 171
[    6.356019] wmi: Mapper loaded
[    6.360195] thinkpad_acpi: ThinkPad ACPI Extras v0.24
[    6.360197] thinkpad_acpi: http://ibm-acpi.sf.net/
[    6.360199] thinkpad_acpi: ThinkPad BIOS 6MET83WW (1.43 ), EC 6MHT44WW-1.19
[    6.360201] thinkpad_acpi: Lenovo ThinkPad T510, model 43495KG
[    6.363916] thinkpad_acpi: detected a 8-level brightness capable ThinkPad
[    6.364078] thinkpad_acpi: radio switch found; radios are enabled
[    6.365331] thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio is blocked
[    6.365811] thinkpad_acpi: rfkill switch tpacpi_wwan_sw: radio is unblocked
[    6.366245] Registered led device: tpacpi::thinklight
[    6.366270] Registered led device: tpacpi::power
[    6.366283] Registered led device: tpacpi::standby
[    6.366299] Registered led device: tpacpi::thinkvantage
[    6.366941] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    6.366963] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[    6.366968] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[    6.366979] ehci_hcd 0000:00:1a.0: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    6.367001] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[    6.367005] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[    6.367032] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    6.368321] thinkpad_acpi: Standard ACPI backlight interface available, not loading native one.
[    6.368375] thinkpad_acpi: Console audio control enabled, mode: override (read/write)
[    6.369464] input: ThinkPad Extra Buttons as /devices/platform/thinkpad_acpi/input/input2
[    6.371407] ehci_hcd 0000:00:1a.0: debug port 2
[    6.375424] ehci_hcd 0000:00:1a.0: irq 23, io mem 0xf2428000
[    6.375747] e1000e: Intel(R) PRO/1000 Network Driver - 1.3.10-k2
[    6.375749] e1000e: Copyright(c) 1999 - 2011 Intel Corporation.
[    6.380954] thermal LNXTHERM:00: registered as thermal_zone0
[    6.380956] ACPI: Thermal Zone [THM0] (50 C)
[    6.381161] ACPI: Deprecated procfs I/F for AC is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    6.381458] ACPI: AC Adapter [AC] (on-line)
[    6.385281] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    6.385320] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    6.385324] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.385328] usb usb1: Product: EHCI Host Controller
[    6.385332] usb usb1: Manufacturer: Linux 2.6.39-dezzy ehci_hcd
[    6.385335] usb usb1: SerialNumber: 0000:00:1a.0
[    6.385417] hub 1-0:1.0: USB hub found
[    6.385421] hub 1-0:1.0: 3 ports detected
[    6.385479] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    6.385483] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    6.385494] ehci_hcd 0000:00:1d.0: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    6.385510] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[    6.385514] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[    6.385519] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    6.391293] ehci_hcd 0000:00:1d.0: debug port 2
[    6.396712] ehci_hcd 0000:00:1d.0: irq 19, io mem 0xf2428400
[    6.401879] input: PC Speaker as /devices/platform/pcspkr/input/input3
[    6.407224] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    6.407302] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    6.407304] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.407306] usb usb2: Product: EHCI Host Controller
[    6.407307] usb usb2: Manufacturer: Linux 2.6.39-dezzy ehci_hcd
[    6.407309] usb usb2: SerialNumber: 0000:00:1d.0
[    6.407391] hub 2-0:1.0: USB hub found
[    6.407395] hub 2-0:1.0: 3 ports detected
[    6.407519] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    6.407528] e1000e 0000:00:19.0: setting latency timer to 64
[    6.407788] e1000e 0000:00:19.0: irq 42 for MSI/MSI-X
[    6.414237] ACPI: Deprecated procfs I/F for battery is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    6.414242] ACPI: Battery Slot [BAT0] (battery present)
[    6.423214] cfg80211: Calling CRDA to update world regulatory domain
[    6.435358] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input4
[    6.435547] ACPI: Lid Switch [LID]
[    6.435576] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input5
[    6.435596] ACPI: Sleep Button [SLPB]
[    6.435639] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input6
[    6.435657] ACPI: Power Button [PWRF]
[    6.465627] ACPI: acpi_idle yielding to intel_idle
[    6.471122] sdhci: Secure Digital Host Controller Interface driver
[    6.471124] sdhci: Copyright(c) Pierre Ossman
[    6.486307] sdhci-pci 0000:0d:00.0: SDHCI controller found [1180:e822] (rev 1)
[    6.486325] sdhci-pci 0000:0d:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    6.486349] sdhci-pci 0000:0d:00.0: Will use DMA mode even though HW doesn't fully claim to support it.
[    6.486355] sdhci-pci 0000:0d:00.0: setting latency timer to 64
[    6.486389] mmc0: no vmmc regulator found
[    6.486408] Registered led device: mmc0::
[    6.486437] mmc0: SDHCI controller on PCI [0000:0d:00.0] using DMA
[    6.528264] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    6.528271] cdrom: Uniform CD-ROM driver Revision: 3.20
[    6.528336] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    6.558923] e1000e 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) f0:de:f1:0b:b4:e4
[    6.558929] e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    6.558983] e1000e 0000:00:19.0: eth0: MAC: 9, PHY: 10, PBA No: A002FF-0FF
[    6.559000] intel ips 0000:00:1f.6: CPU TDP doesn't match expected value (found 25, expected 29)
[    6.559013] intel ips 0000:00:1f.6: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    6.559122] intel ips 0000:00:1f.6: failed to get i915 symbols, graphics turbo disabled
[    6.559172] intel ips 0000:00:1f.6: IPS driver initialized, MCP temp limit 90
[    6.559188] i801_smbus 0000:00:1f.3: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    6.686527] usb 1-1: new high speed USB device number 2 using ehci_hcd
[    6.778459] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    6.778522] HDA Intel 0000:00:1b.0: irq 43 for MSI/MSI-X
[    6.778574] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    6.800711] usb 1-1: New USB device found, idVendor=8087, idProduct=0020
[    6.800713] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    6.800981] hub 1-1:1.0: USB hub found
[    6.801041] hub 1-1:1.0: 6 ports detected
[    6.869464] HDA Intel 0000:01:00.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    6.869467] hda_intel: Disable MSI for Nvidia chipset
[    6.869506] HDA Intel 0000:01:00.1: setting latency timer to 64
[    6.902987] usb 2-1: new high speed USB device number 2 using ehci_hcd
[    7.017146] usb 2-1: New USB device found, idVendor=8087, idProduct=0020
[    7.017152] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    7.017407] hub 2-1:1.0: USB hub found
[    7.017553] hub 2-1:1.0: 8 ports detected
[    7.047394] hda-codec: No codec parser is available
[    7.050311] hda-codec: No codec parser is available
[    7.053196] hda-codec: No codec parser is available
[    7.056100] hda-codec: No codec parser is available
[    7.070466] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:d
[    7.070470] iwlagn: Copyright(c) 2003-2010 Intel Corporation
[    7.070538] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    7.070601] iwlagn 0000:03:00.0: setting latency timer to 64
[    7.070655] iwlagn 0000:03:00.0: Detected Intel(R) Centrino(R) Ultimate-N 6300 AGN, REV=0x74
[    7.086912] iwlagn 0000:03:00.0: device EEPROM VER=0x436, CALIB=0x6
[    7.086917] iwlagn 0000:03:00.0: Device SKU: 0Xb
[    7.086920] iwlagn 0000:03:00.0: Valid Tx ant: 0X7, Valid Rx ant: 0X7
[    7.086947] iwlagn 0000:03:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
[    7.087029] iwlagn 0000:03:00.0: irq 44 for MSI/MSI-X
[    7.091710] usb 1-1.2: new low speed USB device number 3 using ehci_hcd
[    7.181491] usb 1-1.2: New USB device found, idVendor=045e, idProduct=0040
[    7.181497] usb 1-1.2: New USB device strings: Mfr=1, Product=3, SerialNumber=0
[    7.181501] usb 1-1.2: Product: Microsoft 3-Button Mouse with IntelliEye(TM)
[    7.181505] usb 1-1.2: Manufacturer: Microsoft
[    7.244385] usb 1-1.3: new full speed USB device number 4 using ehci_hcd
[    7.330240] usb 1-1.3: New USB device found, idVendor=147e, idProduct=2016
[    7.330247] usb 1-1.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    7.330252] usb 1-1.3: Product: Biometric Coprocessor
[    7.330282] usb 1-1.3: Manufacturer: UPEK
[    7.336191] nvidia: module license 'NVIDIA' taints kernel.
[    7.336197] Disabling lock debugging due to kernel taint
[    7.372630] iwlagn 0000:03:00.0: loaded firmware version 9.221.4.1 build 25532
[    7.372915] Registered led device: phy0-led
[    7.374673] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
[    7.374768] iwlagn 0000:03:00.0: wlan0: Features changed: 0x00004800 -> 0x00004000
[    7.403806] usb 1-1.6: new high speed USB device number 5 using ehci_hcd
[    7.494200] usb 1-1.6: New USB device found, idVendor=17ef, idProduct=480f
[    7.494207] usb 1-1.6: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    7.494213] usb 1-1.6: Product: Integrated Camera
[    7.494217] usb 1-1.6: Manufacturer: Chicony Electronics Co., Ltd.
[    7.568516] usb 2-1.4: new high speed USB device number 3 using ehci_hcd
[    7.657422] usb 2-1.4: New USB device found, idVendor=05c6, idProduct=9205
[    7.657429] usb 2-1.4: New USB device strings: Mfr=3, Product=2, SerialNumber=0
[    7.657435] usb 2-1.4: Product: Qualcomm Gobi 2000
[    7.657439] usb 2-1.4: Manufacturer: Qualcomm Incorporated
[    7.732926] input: Microsoft Microsoft 3-Button Mouse with IntelliEye(TM) as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.2/1-1.2:1.0/input/input7
[    7.732969] usb 2-1.5: new full speed USB device number 4 using ehci_hcd
[    7.732993] generic-usb 0003:045E:0040.0001: input,hidraw0: USB HID v1.10 Mouse [Microsoft Microsoft 3-Button Mouse with IntelliEye(TM)] on usb-0000:00:1a.0-1.2/input0
[    7.733009] usbcore: registered new interface driver usbhid
[    7.733010] usbhid: USB HID core driver
[    7.823488] usb 2-1.5: New USB device found, idVendor=17ef, idProduct=1003
[    7.823496] usb 2-1.5: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    7.823501] usb 2-1.5: Product: Integrated Smart Card Reader
[    7.823506] usb 2-1.5: Manufacturer: Lenovo
[    7.969486] nvidia 0000:01:00.0: power state changed by ACPI to D0
[    7.969494] nvidia 0000:01:00.0: power state changed by ACPI to D0
[    7.969505] nvidia 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    7.969516] nvidia 0000:01:00.0: setting latency timer to 64
[    7.969678] NVRM: loading NVIDIA UNIX x86 Kernel Module  275.09.07  Wed Jun  8 15:42:20 PDT 2011
[    8.098121] Linux video capture interface: v2.00
[    8.106754] usbcore: registered new interface driver usbserial
[    8.106760] usbserial: USB Serial Driver core
[    8.315237] USB Serial support registered for Qualcomm USB modem
[    8.315291] drivers/usb/serial/qcserial.c: qcprobe
[    8.315296] drivers/usb/serial/qcserial.c: Num Interfaces = 4
[    8.315301] drivers/usb/serial/qcserial.c: This Interface = 0
[    8.315331] drivers/usb/serial/qcserial.c: qcprobe
[    8.315335] drivers/usb/serial/qcserial.c: Num Interfaces = 4
[    8.315340] drivers/usb/serial/qcserial.c: This Interface = 1
[    8.315344] drivers/usb/serial/qcserial.c: Diagnostics Monitor found
[    8.316279] qcserial 2-1.4:1.1: Qualcomm USB modem converter detected
[    8.316346] usb 2-1.4: Qualcomm USB modem converter now attached to ttyUSB0
[    8.316363] drivers/usb/serial/qcserial.c: qcprobe
[    8.316365] drivers/usb/serial/qcserial.c: Num Interfaces = 4
[    8.316367] drivers/usb/serial/qcserial.c: This Interface = 2
[    8.316369] drivers/usb/serial/qcserial.c: Modem port found
[    8.318032] qcserial 2-1.4:1.2: Qualcomm USB modem converter detected
[    8.318079] usb 2-1.4: Qualcomm USB modem converter now attached to ttyUSB1
[    8.318095] drivers/usb/serial/qcserial.c: qcprobe
[    8.318097] drivers/usb/serial/qcserial.c: Num Interfaces = 4
[    8.318098] drivers/usb/serial/qcserial.c: This Interface = 3
[    8.318100] drivers/usb/serial/qcserial.c: NMEA GPS interface found
[    8.318760] qcserial 2-1.4:1.3: Qualcomm USB modem converter detected
[    8.318831] usb 2-1.4: Qualcomm USB modem converter now attached to ttyUSB2
[    8.318859] usbcore: registered new interface driver qcserial
[    8.438537] uvcvideo: Found UVC 1.00 device Integrated Camera (17ef:480f)
[    8.440145] input: Integrated Camera as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.6/1-1.6:1.0/input/input8
[    8.440212] usbcore: registered new interface driver uvcvideo
[    8.440218] USB Video Class driver (v1.0.0)
[    9.375719] Bluetooth: Core ver 2.16
[    9.375734] NET: Registered protocol family 31
[    9.375736] Bluetooth: HCI device and connection manager initialized
[    9.375737] Bluetooth: HCI socket layer initialized
[    9.375738] Bluetooth: L2CAP socket layer initialized
[    9.375856] Bluetooth: SCO socket layer initialized
[    9.414519] Bluetooth: Generic Bluetooth USB driver ver 0.6
[    9.414545] usbcore: registered new interface driver btusb
[    9.457281] usbcore: registered new interface driver cdc_acm
[    9.457285] cdc_acm: v0.26:USB Abstract Control Model driver for USB modems and ISDN adapters
[    9.512668] coretemp coretemp.0: TjMax is 105 C.
[    9.512760] coretemp coretemp.2: TjMax is 105 C.
[    9.624458] fuse init (API version 7.16)
[    9.868594] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[   10.405397] thinkpad_ec: thinkpad_ec 0.40 loaded.
[   10.426408] tp_smapi 0.40 loading...
[   10.426647] tp_smapi successfully loaded (smapi_port=0xb2).
[   10.462702] tun: Universal TUN/TAP device driver, 1.6
[   10.462704] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   10.486769] uhci_hcd: USB Universal Host Controller Interface driver
[   10.526066] usbcore: registered new interface driver usblp
[   10.591215] Initializing USB Mass Storage driver...
[   10.591361] usbcore: registered new interface driver usb-storage
[   10.591366] USB Mass Storage support registered.
[   11.332481] EXT4-fs (sda7): re-mounted. Opts: nouser_xattr
[   11.555857] REISERFS (device sda1): found reiserfs format "3.6" with standard journal
[   11.555876] REISERFS (device sda1): using ordered data mode
[   11.556281] REISERFS (device sda1): journal params: device sda1, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
[   11.556479] REISERFS (device sda1): checking transaction log (sda1)
[   11.570301] REISERFS (device sda1): Using r5 hash to sort names
[   11.598384] EXT4-fs (sda6): mounted filesystem with ordered data mode. Opts: nouser_xattr
[   11.674108] Adding 8787964k swap on /dev/sda8.  Priority:64 extents:1 across:8787964k 
[   11.739603] microcode: CPU0 sig=0x20655, pf=0x10, revision=0x2
[   11.747569] microcode: CPU1 sig=0x20655, pf=0x10, revision=0x2
[   11.748971] microcode: CPU2 sig=0x20655, pf=0x10, revision=0x2
[   11.750268] microcode: CPU3 sig=0x20655, pf=0x10, revision=0x2
[   11.751505] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[   11.901447] microcode: Microcode Update Driver: v2.00 removed.
[   11.967499] ata1.00: configured for UDMA/100
[   11.967507] ata1: EH complete
[   14.452605] ------------[ cut here ]------------
[   14.452617] WARNING: at kernel/printk.c:293 do_syslog+0x8f/0x500()
[   14.452621] Hardware name: 43495KG
[   14.452623] Attempt to access syslog with CAP_SYS_ADMIN but no CAP_SYSLOG (deprecated).
[   14.452626] Modules linked in: usb_storage usbmon usblp uhci_hcd tun tp_smapi thinkpad_ec snd_seq_oss snd_seq_midi_event snd_seq_dummy snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss snd_hrtimer snd_aloop sbs sbshc ohci_hcd msr mmc_block joydev fuse fan display coretemp cdc_acm btusb bluetooth acpi_cpufreq mperf uvcvideo qcserial usb_wwan usbserial videodev usbhid nvidia(P) iwlagn snd_hda_codec_conexant snd_hda_intel mac80211 snd_hda_codec sr_mod snd_hwdep sdhci_pci snd_pcm snd_timer sdhci processor button cfg80211 i2c_i801 cdrom pcspkr intel_ips battery snd_page_alloc ac thermal e1000e ehci_hcd thinkpad_acpi wmi mmc_core [last unloaded: microcode]
[   14.452695] Pid: 6693, comm: syslog-ng Tainted: P            2.6.39-dezzy #1
[   14.452698] Call Trace:
[   14.452705]  [<c10306dd>] warn_slowpath_common+0x6d/0xa0
[   14.452710]  [<c103170f>] ? do_syslog+0x8f/0x500
[   14.452715]  [<c103170f>] ? do_syslog+0x8f/0x500
[   14.452719]  [<c103078e>] warn_slowpath_fmt+0x2e/0x30
[   14.452724]  [<c103170f>] do_syslog+0x8f/0x500
[   14.452731]  [<c10b7436>] ? d_rehash+0x26/0x30
[   14.452737]  [<c10eac8d>] ? proc_lookup_de+0x8d/0xe0
[   14.452743]  [<c10eef5b>] kmsg_open+0x1b/0x20
[   14.452749]  [<c10e56c1>] proc_reg_open+0x81/0x130
[   14.452753]  [<c10eef40>] ? kmsg_release+0x20/0x20
[   14.452758]  [<c10eef20>] ? read_vmcore+0x2d0/0x2d0
[   14.452764]  [<c10a384b>] __dentry_open.isra.16+0x11b/0x2a0
[   14.452769]  [<c10a48c4>] nameidata_to_filp+0x54/0x70
[   14.452774]  [<c10e5640>] ? proc_alloc_inode+0x80/0x80
[   14.452779]  [<c10b148f>] do_last.isra.46+0x1ff/0x7a0
[   14.452783]  [<c10b1c7d>] path_openat+0x8d/0x320
[   14.452788]  [<c10e5590>] ? proc_destroy_inode+0x10/0x20
[   14.452793]  [<c10b1f3c>] do_filp_open+0x2c/0x80
[   14.452799]  [<c10bc993>] ? alloc_fd+0xa3/0xe0
[   14.452804]  [<c10ae895>] ? getname_flags+0xc5/0x100
[   14.452808]  [<c10a49c1>] do_sys_open+0xe1/0x1b0
[   14.452813]  [<c10a4ab9>] sys_open+0x29/0x40
[   14.452819]  [<c139d610>] sysenter_do_call+0x12/0x26
[   14.452823] ---[ end trace 5b6ef4be634eb595 ]---
[   18.693677] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   19.971254] smapi smapi: set_real_thresh: set start to 34 for bat=0
[   20.174853] smapi smapi: set_real_thresh: set stop to 90 for bat=0
[   23.685187] e1000e 0000:00:19.0: irq 42 for MSI/MSI-X
[   23.735903] e1000e 0000:00:19.0: irq 42 for MSI/MSI-X
[   23.736290] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   29.615053] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   30.818381] e1000e 0000:00:19.0: irq 42 for MSI/MSI-X
[   30.869011] e1000e 0000:00:19.0: irq 42 for MSI/MSI-X
[   30.869466] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   31.176690] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   36.764395] wlan0: authenticate with 00:24:fe:06:70:b7 (try 1)
[   36.766459] wlan0: authenticated
[   36.766676] wlan0: associate with 00:24:fe:06:70:b7 (try 1)
[   36.772964] wlan0: RX AssocResp from 00:24:fe:06:70:b7 (capab=0x411 status=0 aid=2)
[   36.772968] wlan0: associated
[   36.776569] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   41.159311] nvidia 0000:01:00.0: irq 45 for MSI/MSI-X
[   47.741640] wlan0: no IPv6 routers present
[ 3150.332462] tun0: Features changed: 0x00004800 -> 0x00004000
[47444.179398] ehci_hcd 0000:00:1d.0: remove, state 1
[47444.179409] usb usb2: USB disconnect, device number 1
[47444.179412] usb 2-1: USB disconnect, device number 2
[47444.179414] usb 2-1.4: USB disconnect, device number 3
[47444.179545] qcserial ttyUSB0: Qualcomm USB modem converter now disconnected from ttyUSB0
[47444.179554] drivers/usb/serial/qcserial.c: qc_release
[47444.179562] qcserial 2-1.4:1.1: device disconnected
[47444.179626] qcserial ttyUSB1: Qualcomm USB modem converter now disconnected from ttyUSB1
[47444.179634] drivers/usb/serial/qcserial.c: qc_release
[47444.179640] qcserial 2-1.4:1.2: device disconnected
[47444.179698] qcserial ttyUSB2: Qualcomm USB modem converter now disconnected from ttyUSB2
[47444.179704] drivers/usb/serial/qcserial.c: qc_release
[47444.179709] qcserial 2-1.4:1.3: device disconnected
[47444.179762] usb 2-1.5: USB disconnect, device number 4
[47444.188632] ehci_hcd 0000:00:1d.0: USB bus 2 deregistered
[47444.188718] ehci_hcd 0000:00:1d.0: PCI INT D disabled
[47444.188727] ehci_hcd 0000:00:1a.0: remove, state 1
[47444.188734] usb usb1: USB disconnect, device number 1
[47444.188736] usb 1-1: USB disconnect, device number 2
[47444.188738] usb 1-1.2: USB disconnect, device number 3
[47444.204772] usb 1-1.3: USB disconnect, device number 4
[47444.204856] usb 1-1.6: USB disconnect, device number 5
[47444.227598] ehci_hcd 0000:00:1a.0: USB bus 1 deregistered
[47444.227671] ehci_hcd 0000:00:1a.0: PCI INT D disabled
[47444.236819] sdhci-pci 0000:0d:00.0: PCI INT A disabled
[47444.452512] ata1.00: configured for UDMA/100
[47444.452518] ata1: EH complete
[47444.452604] sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[47446.280548] PM: Syncing filesystems ... done.
[47447.126462] Freezing user space processes ... (elapsed 0.01 seconds) done.
[47447.137325] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[47447.148435] Suspending console(s) (use no_console_suspend to debug)
[47447.157335] sd 0:0:0:0: [sda] Stopping disk
[47447.158358] HDA Intel 0000:01:00.1: PCI INT A disabled
[47447.158463] ACPI handle has no context!
[47447.158493] HDA Intel 0000:00:1b.0: PCI INT B disabled
[47447.238771] e1000e 0000:00:19.0: PCI INT A disabled
[47447.542393] PM: suspend of devices complete after 394.773 msecs
[47447.553701] PM: late suspend of devices complete after 11.331 msecs
[47447.553896] ACPI: Preparing to enter system sleep state S3
[47447.603195] PM: Saving platform NVS memory
[47447.604439] Disabling non-boot CPUs ...
[47447.618503] CPU 1 is now offline
[47447.633474] CPU 2 is now offline
[47447.644191] CPU 3 is now offline
[47447.644464] Extended CMOS year: 2000
[47447.644702] ACPI: Low-level resume complete
[47447.644755] PM: Restoring platform NVS memory
[47447.645402] Extended CMOS year: 2000
[47447.645432] Enabling non-boot CPUs ...
[47447.647529] Booting Node 0 Processor 1 APIC 0x1
[47447.647532] smpboot cpu 1: start_ip = 99000
[47447.657855] Initializing CPU#1
[47447.738733] Switched to NOHz mode on CPU #1
[47447.754787] CPU1 is up
[47447.754850] Booting Node 0 Processor 2 APIC 0x4
[47447.754852] smpboot cpu 2: start_ip = 99000
[47447.765070] Initializing CPU#2
[47447.846445] Switched to NOHz mode on CPU #2
[47447.862512] CPU2 is up
[47447.862571] Booting Node 0 Processor 3 APIC 0x5
[47447.862572] smpboot cpu 3: start_ip = 99000
[47447.872790] Initializing CPU#3
[47447.954240] Switched to NOHz mode on CPU #3
[47447.970391] CPU3 is up
[47447.972166] ACPI: Waking up from system sleep state S3
[47448.035001] intel ips 0000:00:1f.6: MCP limit exceeded: Avg temp 20750, limit 9000
[47448.062098] pcieport 0000:00:01.0: restoring config space at offset 0x1 (was 0x100107, writing 0x100507)
[47448.062203] pci 0000:00:1a.0: restoring config space at offset 0xf (was 0x400, writing 0x40a)
[47448.062220] pci 0000:00:1a.0: restoring config space at offset 0x4 (was 0x0, writing 0xf2428000)
[47448.062227] pci 0000:00:1a.0: restoring config space at offset 0x1 (was 0x2900000, writing 0x2900102)
[47448.062364] pcieport 0000:00:1c.1: restoring config space at offset 0x7 (was 0xf0, writing 0x200000f0)
[47448.062460] pcieport 0000:00:1c.4: restoring config space at offset 0xf (was 0x100, writing 0x4010b)
[47448.062470] pcieport 0000:00:1c.4: restoring config space at offset 0x9 (was 0x10001, writing 0x1fff1)
[47448.062475] pcieport 0000:00:1c.4: restoring config space at offset 0x8 (was 0x0, writing 0xf210f210)
[47448.062479] pcieport 0000:00:1c.4: restoring config space at offset 0x7 (was 0x20000000, writing 0x200000f0)
[47448.062487] pcieport 0000:00:1c.4: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
[47448.062492] pcieport 0000:00:1c.4: restoring config space at offset 0x1 (was 0x100000, writing 0x100107)
[47448.062525] pci 0000:00:1d.0: restoring config space at offset 0xf (was 0x400, writing 0x40a)
[47448.062542] pci 0000:00:1d.0: restoring config space at offset 0x4 (was 0x0, writing 0xf2428400)
[47448.062549] pci 0000:00:1d.0: restoring config space at offset 0x1 (was 0x2900000, writing 0x2900102)
[47448.062659] ahci 0000:00:1f.2: restoring config space at offset 0x1 (was 0x2b00007, writing 0x2b00407)
[47448.062722] intel ips 0000:00:1f.6: restoring config space at offset 0xf (was 0x400, writing 0x40a)
[47448.062743] intel ips 0000:00:1f.6: restoring config space at offset 0x1 (was 0x100000, writing 0x100002)
[47448.062781] nvidia 0000:01:00.0: restoring config space at offset 0x3 (was 0x800010, writing 0x800000)
[47448.062785] nvidia 0000:01:00.0: restoring config space at offset 0x1 (was 0x100107, writing 0x100007)
[47448.062822] HDA Intel 0000:01:00.1: restoring config space at offset 0x1 (was 0x100106, writing 0x100102)
[47448.063059] pci 0000:0d:00.0: restoring config space at offset 0x1 (was 0x100106, writing 0x100102)
[47448.063273] PM: early resume of devices complete after 1.304 msecs
[47448.063528] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[47448.063546] HDA Intel 0000:00:1b.0: setting latency timer to 64
[47448.063587] ahci 0000:00:1f.2: setting latency timer to 64
[47448.063693] HDA Intel 0000:00:1b.0: irq 42 for MSI/MSI-X
[47448.063696] HDA Intel 0000:01:00.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[47448.063713] HDA Intel 0000:01:00.1: setting latency timer to 64
[47448.063736] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[47448.063748] sd 0:0:0:0: [sda] Starting disk
[47448.064428] pci 0000:00:1e.0: setting latency timer to 64
[47448.369199] ata5: SATA link down (SStatus 0 SControl 300)
[47448.371213] ata6: SATA link down (SStatus 0 SControl 300)
[47448.373194] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[47448.377255] ata2.00: ACPI cmd e3/00:10:00:00:00:a0 (IDLE) succeeded
[47448.379534] ata2.00: ACPI cmd e3/00:03:00:00:00:a0 (IDLE) succeeded
[47448.390932] ata2.00: ACPI cmd e3/00:10:00:00:00:a0 (IDLE) succeeded
[47448.393211] ata2.00: ACPI cmd e3/00:03:00:00:00:a0 (IDLE) succeeded
[47448.396436] ata2.00: configured for UDMA/100
[47450.249527] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[47450.441251] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[47450.441258] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[47450.441263] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[47450.445136] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[47450.445143] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[47450.445148] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[47450.446789] ata1.00: configured for UDMA/100
[47450.446959] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[47450.551615] PM: resume of devices complete after 2494.429 msecs
[47450.551721] Restarting tasks ... done.
[47450.552236] video LNXVIDEO:01: Restoring backlight state
[47450.605811] cfg80211: Calling CRDA for country: EU
[47450.827059] ata1.00: configured for UDMA/100
[47450.827069] ata1: EH complete
[47451.041720] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[47451.041724] Warning! ehci_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
[47451.041756] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[47451.041761] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[47451.041772] ehci_hcd 0000:00:1a.0: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[47451.041803] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[47451.041808] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[47451.041888] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[47451.045453] ehci_hcd 0000:00:1a.0: debug port 2
[47451.049483] ehci_hcd 0000:00:1a.0: irq 23, io mem 0xf2428000
[47451.059387] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[47451.059428] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[47451.059431] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[47451.059433] usb usb1: Product: EHCI Host Controller
[47451.059435] usb usb1: Manufacturer: Linux 2.6.39-dezzy ehci_hcd
[47451.059437] usb usb1: SerialNumber: 0000:00:1a.0
[47451.059534] hub 1-0:1.0: USB hub found
[47451.059539] hub 1-0:1.0: 3 ports detected
[47451.059612] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[47451.059617] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[47451.059626] ehci_hcd 0000:00:1d.0: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[47451.059648] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[47451.059652] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[47451.059689] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[47451.064399] ehci_hcd 0000:00:1d.0: debug port 2
[47451.068399] ehci_hcd 0000:00:1d.0: irq 19, io mem 0xf2428400
[47451.078339] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[47451.078377] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[47451.078380] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[47451.078383] usb usb2: Product: EHCI Host Controller
[47451.078385] usb usb2: Manufacturer: Linux 2.6.39-dezzy ehci_hcd
[47451.078387] usb usb2: SerialNumber: 0000:00:1d.0
[47451.078481] hub 2-0:1.0: USB hub found
[47451.078485] hub 2-0:1.0: 3 ports detected
[47451.320095] sdhci: Secure Digital Host Controller Interface driver
[47451.320099] sdhci: Copyright(c) Pierre Ossman
[47451.332928] sdhci-pci 0000:0d:00.0: SDHCI controller found [1180:e822] (rev 1)
[47451.332947] sdhci-pci 0000:0d:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[47451.332978] sdhci-pci 0000:0d:00.0: Will use DMA mode even though HW doesn't fully claim to support it.
[47451.332988] sdhci-pci 0000:0d:00.0: setting latency timer to 64
[47451.333019] mmc0: no vmmc regulator found
[47451.333054] Registered led device: mmc0::
[47451.333095] mmc0: SDHCI controller on PCI [0000:0d:00.0] using DMA
[47451.360645] usb 1-1: new high speed USB device number 2 using ehci_hcd
[47451.474685] usb 1-1: New USB device found, idVendor=8087, idProduct=0020
[47451.474688] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[47451.474961] hub 1-1:1.0: USB hub found
[47451.475053] hub 1-1:1.0: 6 ports detected
[47451.577096] usb 2-1: new high speed USB device number 2 using ehci_hcd
[47451.632707] uhci_hcd: USB Universal Host Controller Interface driver
[47451.691143] usb 2-1: New USB device found, idVendor=8087, idProduct=0020
[47451.691147] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[47451.691424] hub 2-1:1.0: USB hub found
[47451.691510] hub 2-1:1.0: 8 ports detected
[47451.765722] usb 1-1.3: new full speed USB device number 3 using ehci_hcd
[47451.851615] usb 1-1.3: New USB device found, idVendor=147e, idProduct=2016
[47451.851619] usb 1-1.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[47451.851622] usb 1-1.3: Product: Biometric Coprocessor
[47451.851624] usb 1-1.3: Manufacturer: UPEK
[47451.925060] usb 1-1.6: new high speed USB device number 4 using ehci_hcd
[47452.008596] usb 1-1.6: New USB device found, idVendor=17ef, idProduct=480f
[47452.008601] usb 1-1.6: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[47452.008604] usb 1-1.6: Product: Integrated Camera
[47452.008606] usb 1-1.6: Manufacturer: Chicony Electronics Co., Ltd.
[47452.009381] uvcvideo: Found UVC 1.00 device Integrated Camera (17ef:480f)
[47452.010548] input: Integrated Camera as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.6/1-1.6:1.0/input/input9
[47452.083927] usb 2-1.4: new high speed USB device number 3 using ehci_hcd
[47452.170568] usb 2-1.4: config 1 has an invalid interface number: 1 but max is 0
[47452.170573] usb 2-1.4: config 1 has no interface number 0
[47452.172439] usb 2-1.4: New USB device found, idVendor=05c6, idProduct=9204
[47452.172443] usb 2-1.4: New USB device strings: Mfr=3, Product=2, SerialNumber=0
[47452.172446] usb 2-1.4: Product: Qualcomm Gobi 2000
[47452.172448] usb 2-1.4: Manufacturer: Qualcomm Incorporated
[47452.173984] drivers/usb/serial/qcserial.c: qcprobe
[47452.173986] drivers/usb/serial/qcserial.c: Num Interfaces = 1
[47452.173988] drivers/usb/serial/qcserial.c: This Interface = 1
[47452.173990] drivers/usb/serial/qcserial.c: QDL port found
[47452.173994] qcserial 2-1.4:1.1: Qualcomm USB modem converter detected
[47452.174067] usb 2-1.4: Qualcomm USB modem converter now attached to ttyUSB0
[47452.246507] usb 2-1.5: new full speed USB device number 4 using ehci_hcd
[47452.338900] usb 2-1.5: New USB device found, idVendor=17ef, idProduct=1003
[47452.338905] usb 2-1.5: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[47452.338908] usb 2-1.5: Product: Integrated Smart Card Reader
[47452.338911] usb 2-1.5: Manufacturer: Lenovo
[47456.509328] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[47456.627068] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[47456.848069] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[47456.898812] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[47456.899095] ADDRCONF(NETDEV_UP): eth0: link is not ready
[47457.615043] usb 1-1.2: new low speed USB device number 5 using ehci_hcd
[47457.704942] usb 1-1.2: New USB device found, idVendor=045e, idProduct=0040
[47457.704946] usb 1-1.2: New USB device strings: Mfr=1, Product=3, SerialNumber=0
[47457.704949] usb 1-1.2: Product: Microsoft 3-Button Mouse with IntelliEye(TM)
[47457.704952] usb 1-1.2: Manufacturer: Microsoft
[47457.707469] input: Microsoft Microsoft 3-Button Mouse with IntelliEye(TM) as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.2/1-1.2:1.0/input/input10
[47457.707575] generic-usb 0003:045E:0040.0002: input,hidraw0: USB HID v1.10 Mouse [Microsoft Microsoft 3-Button Mouse with IntelliEye(TM)] on usb-0000:00:1a.0-1.2/input0
[47461.382147] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[47462.716169] smapi smapi: set_real_thresh: set start to 34 for bat=0
[47462.919657] smapi smapi: set_real_thresh: set stop to 90 for bat=0
[47462.965879] ata1.00: configured for UDMA/100
[47462.965885] ata1: EH complete
[47463.087107] udevd[10791]: starting version 171
[47466.371779] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[47466.906134] usb 2-1.4: USB disconnect, device number 3
[47466.906246] qcserial ttyUSB0: Qualcomm USB modem converter now disconnected from ttyUSB0
[47466.906259] drivers/usb/serial/qcserial.c: qc_release
[47466.906268] qcserial 2-1.4:1.1: device disconnected
[47467.848272] usb 2-1.4: new high speed USB device number 5 using ehci_hcd
[47467.934802] usb 2-1.4: New USB device found, idVendor=05c6, idProduct=9205
[47467.934806] usb 2-1.4: New USB device strings: Mfr=3, Product=2, SerialNumber=0
[47467.934809] usb 2-1.4: Product: Qualcomm Gobi 2000
[47467.934812] usb 2-1.4: Manufacturer: Qualcomm Incorporated
[47467.936720] drivers/usb/serial/qcserial.c: qcprobe
[47467.936722] drivers/usb/serial/qcserial.c: Num Interfaces = 4
[47467.936724] drivers/usb/serial/qcserial.c: This Interface = 0
[47467.936806] drivers/usb/serial/qcserial.c: qcprobe
[47467.936809] drivers/usb/serial/qcserial.c: Num Interfaces = 4
[47467.936811] drivers/usb/serial/qcserial.c: This Interface = 1
[47467.936813] drivers/usb/serial/qcserial.c: Diagnostics Monitor found
[47467.937196] qcserial 2-1.4:1.1: Qualcomm USB modem converter detected
[47467.937265] usb 2-1.4: Qualcomm USB modem converter now attached to ttyUSB0
[47467.937304] drivers/usb/serial/qcserial.c: qcprobe
[47467.937306] drivers/usb/serial/qcserial.c: Num Interfaces = 4
[47467.937308] drivers/usb/serial/qcserial.c: This Interface = 2
[47467.937310] drivers/usb/serial/qcserial.c: Modem port found
[47467.938210] qcserial 2-1.4:1.2: Qualcomm USB modem converter detected
[47467.938275] usb 2-1.4: Qualcomm USB modem converter now attached to ttyUSB1
[47467.938317] drivers/usb/serial/qcserial.c: qcprobe
[47467.938319] drivers/usb/serial/qcserial.c: Num Interfaces = 4
[47467.938321] drivers/usb/serial/qcserial.c: This Interface = 3
[47467.938323] drivers/usb/serial/qcserial.c: NMEA GPS interface found
[47467.938945] qcserial 2-1.4:1.3: Qualcomm USB modem converter detected
[47467.939007] usb 2-1.4: Qualcomm USB modem converter now attached to ttyUSB2
[47470.222357] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[47470.409769] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[47470.460500] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[47470.460772] ADDRCONF(NETDEV_UP): eth0: link is not ready
[47470.589701] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[47472.770730] wlan0: authenticate with c0:c5:20:84:f5:29 (try 1)
[47472.803251] wlan0: authenticated
[47472.803324] wlan0: associate with c0:c5:20:84:f5:29 (try 1)
[47472.815194] wlan0: RX AssocResp from c0:c5:20:84:f5:29 (capab=0x431 status=0 aid=10)
[47472.815197] wlan0: associated
[47472.822334] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[47483.173998] wlan0: no IPv6 routers present
[51839.605663] wlan0: deauthenticating from c0:c5:20:84:f5:29 by local choice (reason=3)
[51839.626843] cfg80211: Calling CRDA to update world regulatory domain
[51839.736973] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[51839.948183] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[51839.998920] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[51839.999224] ADDRCONF(NETDEV_UP): eth0: link is not ready
[51840.306622] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[51840.431345] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[51840.617490] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[51840.668233] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[51840.668519] ADDRCONF(NETDEV_UP): eth0: link is not ready
[51840.800308] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[51884.940399] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[51885.140545] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[51885.192390] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[51885.193593] ADDRCONF(NETDEV_UP): eth0: link is not ready
[51885.314437] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[51886.334333] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[51886.540995] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[51886.592855] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[51886.594040] ADDRCONF(NETDEV_UP): eth0: link is not ready
[51887.459023] wlan0: authenticate with c0:c5:20:84:f5:29 (try 1)
[51887.646109] wlan0: authenticated
[51887.646767] wlan0: associate with c0:c5:20:84:f5:29 (try 1)
[51887.845604] wlan0: associate with c0:c5:20:84:f5:29 (try 2)
[51888.045105] wlan0: associate with c0:c5:20:84:f5:29 (try 3)
[51888.244598] wlan0: association with c0:c5:20:84:f5:29 timed out
[51900.767792] wlan0: authenticate with c0:c5:20:84:f5:29 (try 1)
[51900.966353] wlan0: authenticate with c0:c5:20:84:f5:29 (try 2)
[51901.165848] wlan0: authenticate with c0:c5:20:84:f5:29 (try 3)
[51901.365342] wlan0: authentication with c0:c5:20:84:f5:29 timed out
[51913.998968] wlan0: authenticate with 00:1f:41:a5:05:49 (try 1)
[51914.001212] wlan0: authenticated
[51914.001286] wlan0: associate with 00:1f:41:a5:05:49 (try 1)
[51914.004538] wlan0: RX AssocResp from 00:1f:41:a5:05:49 (capab=0x431 status=0 aid=3)
[51914.004541] wlan0: associated
[51914.023166] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[51924.679250] wlan0: no IPv6 routers present
[56042.481028] wlan0: deauthenticating from 00:1f:41:a5:05:49 by local choice (reason=3)
[56042.498237] cfg80211: Calling CRDA for country: 97
[56042.613643] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[56042.825574] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[56042.876384] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[56042.876692] ADDRCONF(NETDEV_UP): eth0: link is not ready
[56043.002482] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[56043.122850] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[56043.313328] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[56043.364058] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[56043.364340] ADDRCONF(NETDEV_UP): eth0: link is not ready
[56043.496256] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[56092.338941] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[56092.533602] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[56092.584353] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[56092.585717] ADDRCONF(NETDEV_UP): eth0: link is not ready
[56092.712774] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[56093.713992] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[56093.923336] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[56093.973803] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[56093.974105] ADDRCONF(NETDEV_UP): eth0: link is not ready
[56094.883472] wlan0: authenticate with c0:c5:20:84:f5:29 (try 1)
[56094.942554] wlan0: authenticated
[56094.942627] wlan0: associate with c0:c5:20:84:f5:29 (try 1)
[56094.957186] wlan0: RX AssocResp from c0:c5:20:84:f5:29 (capab=0x431 status=0 aid=2)
[56094.957190] wlan0: associated
[56094.972653] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[56105.457635] wlan0: no IPv6 routers present
[63674.179698] wlan0: deauthenticating from c0:c5:20:84:f5:29 by local choice (reason=3)
[63674.207752] cfg80211: Calling CRDA to update world regulatory domain
[63674.318900] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[63674.530097] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[63674.580819] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[63674.581097] ADDRCONF(NETDEV_UP): eth0: link is not ready
[63674.827619] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[63674.954434] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[63675.149529] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[63675.200258] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[63675.200564] ADDRCONF(NETDEV_UP): eth0: link is not ready
[63675.333372] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[63723.812431] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[63724.006666] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[63724.057394] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[63724.057698] ADDRCONF(NETDEV_UP): eth0: link is not ready
[63724.182490] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[63725.187013] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[63725.382166] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[63725.432895] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[63725.433193] ADDRCONF(NETDEV_UP): eth0: link is not ready
[63726.314378] wlan0: authenticate with c0:c5:20:84:f5:29 (try 1)
[63726.335979] wlan0: authenticated
[63726.336052] wlan0: associate with c0:c5:20:84:f5:29 (try 1)
[63726.401772] wlan0: RX AssocResp from c0:c5:20:84:f5:29 (capab=0x431 status=0 aid=4)
[63726.401776] wlan0: associated
[63726.404779] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[63736.843897] wlan0: no IPv6 routers present
[67475.777745] wlan0: deauthenticating from c0:c5:20:84:f5:29 by local choice (reason=3)
[67475.799421] cfg80211: Calling CRDA for country: EU
[67475.918490] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[67476.125757] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[67476.176477] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[67476.176749] ADDRCONF(NETDEV_UP): eth0: link is not ready
[67476.377340] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[67476.501041] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[67476.695298] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[67476.746040] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[67476.746311] ADDRCONF(NETDEV_UP): eth0: link is not ready
[67476.891078] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[67479.049145] wlan0: authenticate with c0:c5:20:84:f5:29 (try 1)
[67479.057369] wlan0: authenticated
[67479.057445] wlan0: associate with c0:c5:20:84:f5:29 (try 1)
[67479.066027] wlan0: RX AssocResp from c0:c5:20:84:f5:29 (capab=0x431 status=0 aid=2)
[67479.066030] wlan0: associated
[67479.068985] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[67489.172472] wlan0: no IPv6 routers present
[71732.646288] wlan0: deauthenticating from c0:c5:20:84:f5:29 by local choice (reason=3)
[71732.673385] cfg80211: Calling CRDA to update world regulatory domain
[71732.789807] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[71733.023662] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[71733.074390] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[71733.074697] ADDRCONF(NETDEV_UP): eth0: link is not ready
[71733.378630] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[71733.495012] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[71733.683982] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[71733.734712] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[71733.734996] ADDRCONF(NETDEV_UP): eth0: link is not ready
[71733.865343] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[71736.023031] wlan0: authenticate with c0:c5:20:84:f5:29 (try 1)
[71736.040330] wlan0: authenticated
[71736.040462] wlan0: associate with c0:c5:20:84:f5:29 (try 1)
[71736.045643] wlan0: RX AssocResp from c0:c5:20:84:f5:29 (capab=0x431 status=0 aid=2)
[71736.045647] wlan0: associated
[71736.058398] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[71746.776567] wlan0: no IPv6 routers present
[72955.669588] cfg80211: Calling CRDA for country: EU
[72959.085776] wlan0: authenticate with 00:1f:41:a5:05:c9 (try 1)
[72959.092405] wlan0: authenticated
[72959.092594] wlan0: associate with 00:1f:41:a5:05:c9 (try 1)
[72959.095894] wlan0: RX AssocResp from 00:1f:41:a5:05:c9 (capab=0x431 status=0 aid=1)
[72959.095901] wlan0: associated
[72983.164742] nvidia 0000:01:00.0: irq 45 for MSI/MSI-X
[73715.183495] nvidia 0000:01:00.0: irq 45 for MSI/MSI-X
[73762.692621] wlan0: deauthenticating from 00:1f:41:a5:05:c9 by local choice (reason=3)
[73762.717879] cfg80211: Calling CRDA to update world regulatory domain
[73762.832812] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[73763.073124] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[73763.123860] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[73763.124131] ADDRCONF(NETDEV_UP): eth0: link is not ready
[73763.337964] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[73763.453552] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[73763.639690] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[73763.690413] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[73763.690682] ADDRCONF(NETDEV_UP): eth0: link is not ready
[73763.844223] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[73766.033030] wlan0: authenticate with c0:c5:20:84:f5:29 (try 1)
[73766.035283] wlan0: authenticated
[73766.035368] wlan0: waiting for beacon from c0:c5:20:84:f5:29
[73766.061150] wlan0: beacon received
[73766.069332] wlan0: associate with c0:c5:20:84:f5:29 (try 1)
[73766.072473] wlan0: RX AssocResp from c0:c5:20:84:f5:29 (capab=0x431 status=0 aid=2)
[73766.072478] wlan0: associated
[73766.078258] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[73777.016525] wlan0: no IPv6 routers present
[76922.198066] ehci_hcd 0000:00:1d.0: remove, state 1
[76922.198078] usb usb2: USB disconnect, device number 1
[76922.198081] usb 2-1: USB disconnect, device number 2
[76922.198083] usb 2-1.4: USB disconnect, device number 5
[76922.198227] qcserial ttyUSB0: Qualcomm USB modem converter now disconnected from ttyUSB0
[76922.198238] drivers/usb/serial/qcserial.c: qc_release
[76922.198246] qcserial 2-1.4:1.1: device disconnected
[76922.198329] qcserial ttyUSB1: Qualcomm USB modem converter now disconnected from ttyUSB1
[76922.198336] drivers/usb/serial/qcserial.c: qc_release
[76922.198342] qcserial 2-1.4:1.2: device disconnected
[76922.198397] qcserial ttyUSB2: Qualcomm USB modem converter now disconnected from ttyUSB2
[76922.198402] drivers/usb/serial/qcserial.c: qc_release
[76922.198408] qcserial 2-1.4:1.3: device disconnected
[76922.198464] usb 2-1.5: USB disconnect, device number 4
[76922.207345] ehci_hcd 0000:00:1d.0: USB bus 2 deregistered
[76922.207438] ehci_hcd 0000:00:1d.0: PCI INT D disabled
[76922.207449] ehci_hcd 0000:00:1a.0: remove, state 1
[76922.207458] usb usb1: USB disconnect, device number 1
[76922.207460] usb 1-1: USB disconnect, device number 2
[76922.207463] usb 1-1.2: USB disconnect, device number 5
[76922.226481] usb 1-1.3: USB disconnect, device number 3
[76922.226575] usb 1-1.6: USB disconnect, device number 4
[76922.265190] ehci_hcd 0000:00:1a.0: USB bus 1 deregistered
[76922.265291] ehci_hcd 0000:00:1a.0: PCI INT D disabled
[76922.276958] sdhci-pci 0000:0d:00.0: PCI INT A disabled
[76922.587106] ata1.00: configured for UDMA/100
[76922.587113] ata1: EH complete
[76922.587208] sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[76924.200691] PM: Syncing filesystems ... done.
[76935.389868] Freezing user space processes ... (elapsed 0.01 seconds) done.
[76935.400920] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[76935.412043] Suspending console(s) (use no_console_suspend to debug)
[76935.420424] sd 0:0:0:0: [sda] Stopping disk
[76935.421868] HDA Intel 0000:01:00.1: PCI INT A disabled
[76935.421961] ACPI handle has no context!
[76935.421975] HDA Intel 0000:00:1b.0: PCI INT B disabled
[76935.805031] PM: suspend of devices complete after 393.812 msecs
[76935.816464] PM: late suspend of devices complete after 11.456 msecs
[76935.816652] ACPI: Preparing to enter system sleep state S3
[76935.865841] PM: Saving platform NVS memory
[76935.867065] Disabling non-boot CPUs ...
[76935.881140] CPU 1 is now offline
[76935.898852] CPU 2 is now offline
[76935.908774] CPU 3 is now offline
[76935.909067] Extended CMOS year: 2000
[76935.909306] ACPI: Low-level resume complete
[76935.909358] PM: Restoring platform NVS memory
[76935.910002] Extended CMOS year: 2000
[76935.910018] Enabling non-boot CPUs ...
[76935.912130] Booting Node 0 Processor 1 APIC 0x1
[76935.912133] smpboot cpu 1: start_ip = 99000
[76935.922457] Initializing CPU#1
[76936.003314] Switched to NOHz mode on CPU #1
[76936.023384] CPU1 is up
[76936.023447] Booting Node 0 Processor 2 APIC 0x4
[76936.023448] smpboot cpu 2: start_ip = 99000
[76936.033665] Initializing CPU#2
[76936.115013] Switched to NOHz mode on CPU #2
[76936.135076] CPU2 is up
[76936.135134] Booting Node 0 Processor 3 APIC 0x5
[76936.135136] smpboot cpu 3: start_ip = 99000
[76936.145354] Initializing CPU#3
[76936.226798] Switched to NOHz mode on CPU #3
[76936.246949] CPU3 is up
[76936.248697] ACPI: Waking up from system sleep state S3
[76936.328665] pcieport 0000:00:01.0: restoring config space at offset 0x1 (was 0x100107, writing 0x100507)
[76936.328771] pci 0000:00:1a.0: restoring config space at offset 0xf (was 0x400, writing 0x40a)
[76936.328788] pci 0000:00:1a.0: restoring config space at offset 0x4 (was 0x0, writing 0xf2428000)
[76936.328795] pci 0000:00:1a.0: restoring config space at offset 0x1 (was 0x2900000, writing 0x2900102)
[76936.329023] pcieport 0000:00:1c.4: restoring config space at offset 0xf (was 0x100, writing 0x4010b)
[76936.329033] pcieport 0000:00:1c.4: restoring config space at offset 0x9 (was 0x10001, writing 0x1fff1)
[76936.329038] pcieport 0000:00:1c.4: restoring config space at offset 0x8 (was 0x0, writing 0xf210f210)
[76936.329042] pcieport 0000:00:1c.4: restoring config space at offset 0x7 (was 0x20000000, writing 0xf0)
[76936.329050] pcieport 0000:00:1c.4: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
[76936.329055] pcieport 0000:00:1c.4: restoring config space at offset 0x1 (was 0x100000, writing 0x100107)
[76936.329088] pci 0000:00:1d.0: restoring config space at offset 0xf (was 0x400, writing 0x40a)
[76936.329105] pci 0000:00:1d.0: restoring config space at offset 0x4 (was 0x0, writing 0xf2428400)
[76936.329112] pci 0000:00:1d.0: restoring config space at offset 0x1 (was 0x2900000, writing 0x2900102)
[76936.329223] ahci 0000:00:1f.2: restoring config space at offset 0x1 (was 0x2b00007, writing 0x2b00407)
[76936.329286] intel ips 0000:00:1f.6: restoring config space at offset 0xf (was 0x400, writing 0x40a)
[76936.329307] intel ips 0000:00:1f.6: restoring config space at offset 0x1 (was 0x100000, writing 0x100002)
[76936.329345] nvidia 0000:01:00.0: restoring config space at offset 0x3 (was 0x800010, writing 0x800000)
[76936.329349] nvidia 0000:01:00.0: restoring config space at offset 0x1 (was 0x100107, writing 0x100007)
[76936.329387] HDA Intel 0000:01:00.1: restoring config space at offset 0x1 (was 0x100106, writing 0x100102)
[76936.329470] iwlagn 0000:03:00.0: restoring config space at offset 0x1 (was 0x100106, writing 0x100506)
[76936.329627] pci 0000:0d:00.0: restoring config space at offset 0x1 (was 0x100106, writing 0x100102)
[76936.329839] PM: early resume of devices complete after 1.304 msecs
[76936.330095] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[76936.330102] pci 0000:00:1e.0: setting latency timer to 64
[76936.330114] HDA Intel 0000:00:1b.0: setting latency timer to 64
[76936.330145] e1000e 0000:00:19.0: irq 42 for MSI/MSI-X
[76936.330154] ahci 0000:00:1f.2: setting latency timer to 64
[76936.330235] HDA Intel 0000:00:1b.0: irq 43 for MSI/MSI-X
[76936.330286] HDA Intel 0000:01:00.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[76936.330290] HDA Intel 0000:01:00.1: setting latency timer to 64
[76936.330369] sd 0:0:0:0: [sda] Starting disk
[76936.633776] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[76936.848028] ata5: SATA link down (SStatus 0 SControl 300)
[76936.848075] ata6: SATA link down (SStatus 0 SControl 300)
[76936.848363] ata2.00: ACPI cmd e3/00:10:00:00:00:a0 (IDLE) succeeded
[76936.849150] ata2.00: ACPI cmd e3/00:03:00:00:00:a0 (IDLE) succeeded
[76936.854483] ata2.00: ACPI cmd e3/00:10:00:00:00:a0 (IDLE) succeeded
[76936.855165] ata2.00: ACPI cmd e3/00:03:00:00:00:a0 (IDLE) succeeded
[76936.856797] ata2.00: configured for UDMA/100
[76938.475143] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[76938.684846] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[76938.684853] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[76938.684859] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[76938.688687] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[76938.688694] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[76938.688700] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[76938.690343] ata1.00: configured for UDMA/100
[76938.690512] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[76938.796717] PM: resume of devices complete after 2472.959 msecs
[76938.796824] Restarting tasks ... done.
[76938.797697] video LNXVIDEO:01: Restoring backlight state
[76938.845148] cfg80211: Calling CRDA for country: 97
[76939.038530] ata1.00: configured for UDMA/100
[76939.038535] ata1: EH complete
[76939.298047] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[76939.298051] Warning! ehci_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
[76939.298084] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[76939.298090] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[76939.298100] ehci_hcd 0000:00:1a.0: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[76939.298128] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[76939.298132] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[76939.298208] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[76939.303959] ehci_hcd 0000:00:1a.0: debug port 2
[76939.308931] ehci_hcd 0000:00:1a.0: irq 23, io mem 0xf2428000
[76939.317896] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[76939.317938] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[76939.317940] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[76939.317943] usb usb1: Product: EHCI Host Controller
[76939.317945] usb usb1: Manufacturer: Linux 2.6.39-dezzy ehci_hcd
[76939.317947] usb usb1: SerialNumber: 0000:00:1a.0
[76939.318052] hub 1-0:1.0: USB hub found
[76939.318057] hub 1-0:1.0: 3 ports detected
[76939.318140] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[76939.318146] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[76939.318154] ehci_hcd 0000:00:1d.0: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[76939.318177] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[76939.318181] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[76939.318220] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[76939.323903] ehci_hcd 0000:00:1d.0: debug port 2
[76939.328870] ehci_hcd 0000:00:1d.0: irq 19, io mem 0xf2428400
[76939.337845] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[76939.337881] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[76939.337884] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[76939.337887] usb usb2: Product: EHCI Host Controller
[76939.337889] usb usb2: Manufacturer: Linux 2.6.39-dezzy ehci_hcd
[76939.337890] usb usb2: SerialNumber: 0000:00:1d.0
[76939.337982] hub 2-0:1.0: USB hub found
[76939.337986] hub 2-0:1.0: 3 ports detected
[76939.585979] sdhci: Secure Digital Host Controller Interface driver
[76939.585983] sdhci: Copyright(c) Pierre Ossman
[76939.610455] sdhci-pci 0000:0d:00.0: SDHCI controller found [1180:e822] (rev 1)
[76939.610477] sdhci-pci 0000:0d:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[76939.610513] sdhci-pci 0000:0d:00.0: Will use DMA mode even though HW doesn't fully claim to support it.
[76939.610525] sdhci-pci 0000:0d:00.0: setting latency timer to 64
[76939.610570] mmc0: no vmmc regulator found
[76939.610604] Registered led device: mmc0::
[76939.610648] mmc0: SDHCI controller on PCI [0000:0d:00.0] using DMA
[76939.619145] usb 1-1: new high speed USB device number 2 using ehci_hcd
[76939.733418] usb 1-1: New USB device found, idVendor=8087, idProduct=0020
[76939.733422] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[76939.733692] hub 1-1:1.0: USB hub found
[76939.733786] hub 1-1:1.0: 6 ports detected
[76939.836779] usb 2-1: new high speed USB device number 2 using ehci_hcd
[76939.950628] usb 2-1: New USB device found, idVendor=8087, idProduct=0020
[76939.950632] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[76939.950902] hub 2-1:1.0: USB hub found
[76939.950996] hub 2-1:1.0: 8 ports detected
[76939.966542] uhci_hcd: USB Universal Host Controller Interface driver
[76940.015366] usb 1-1.2: new low speed USB device number 3 using ehci_hcd
[76940.107507] usb 1-1.2: New USB device found, idVendor=045e, idProduct=0040
[76940.107511] usb 1-1.2: New USB device strings: Mfr=1, Product=3, SerialNumber=0
[76940.107514] usb 1-1.2: Product: Microsoft 3-Button Mouse with IntelliEye(TM)
[76940.107516] usb 1-1.2: Manufacturer: Microsoft
[76940.110300] input: Microsoft Microsoft 3-Button Mouse with IntelliEye(TM) as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.2/1-1.2:1.0/input/input11
[76940.110381] generic-usb 0003:045E:0040.0003: input,hidraw0: USB HID v1.10 Mouse [Microsoft Microsoft 3-Button Mouse with IntelliEye(TM)] on usb-0000:00:1a.0-1.2/input0
[76940.183809] usb 1-1.3: new full speed USB device number 4 using ehci_hcd
[76940.269579] usb 1-1.3: New USB device found, idVendor=147e, idProduct=2016
[76940.269584] usb 1-1.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[76940.269586] usb 1-1.3: Product: Biometric Coprocessor
[76940.269588] usb 1-1.3: Manufacturer: UPEK
[76940.320462] e1000e 0000:00:19.0: irq 42 for MSI/MSI-X
[76940.342413] usb 1-1.6: new high speed USB device number 5 using ehci_hcd
[76940.372316] e1000e 0000:00:19.0: irq 42 for MSI/MSI-X
[76940.373461] ADDRCONF(NETDEV_UP): eth0: link is not ready
[76940.438037] usb 1-1.6: New USB device found, idVendor=17ef, idProduct=480f
[76940.438041] usb 1-1.6: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[76940.438044] usb 1-1.6: Product: Integrated Camera
[76940.438045] usb 1-1.6: Manufacturer: Chicony Electronics Co., Ltd.
[76940.438814] uvcvideo: Found UVC 1.00 device Integrated Camera (17ef:480f)
[76940.440016] input: Integrated Camera as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.6/1-1.6:1.0/input/input12
[76940.512992] usb 2-1.4: new high speed USB device number 3 using ehci_hcd
[76940.600136] usb 2-1.4: config 1 has an invalid interface number: 1 but max is 0
[76940.600140] usb 2-1.4: config 1 has no interface number 0
[76940.602000] usb 2-1.4: New USB device found, idVendor=05c6, idProduct=9204
[76940.602004] usb 2-1.4: New USB device strings: Mfr=3, Product=2, SerialNumber=0
[76940.602006] usb 2-1.4: Product: Qualcomm Gobi 2000
[76940.602008] usb 2-1.4: Manufacturer: Qualcomm Incorporated
[76940.603545] drivers/usb/serial/qcserial.c: qcprobe
[76940.603548] drivers/usb/serial/qcserial.c: Num Interfaces = 1
[76940.603550] drivers/usb/serial/qcserial.c: This Interface = 1
[76940.603552] drivers/usb/serial/qcserial.c: QDL port found
[76940.603556] qcserial 2-1.4:1.1: Qualcomm USB modem converter detected
[76940.603637] usb 2-1.4: Qualcomm USB modem converter now attached to ttyUSB0
[76940.676579] usb 2-1.5: new full speed USB device number 4 using ehci_hcd
[76940.766959] usb 2-1.5: New USB device found, idVendor=17ef, idProduct=1003
[76940.766965] usb 2-1.5: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[76940.766968] usb 2-1.5: Product: Integrated Smart Card Reader
[76940.766971] usb 2-1.5: Manufacturer: Lenovo
[76951.095076] smapi smapi: set_real_thresh: set start to 34 for bat=0
[76951.298559] smapi smapi: set_real_thresh: set stop to 90 for bat=0
[76951.432821] ata1.00: configured for UDMA/100
[76951.432828] ata1: EH complete
[76951.539417] udevd[27831]: starting version 171
[76955.166621] usb 2-1.4: USB disconnect, device number 3
[76955.166749] qcserial ttyUSB0: Qualcomm USB modem converter now disconnected from ttyUSB0
[76955.166760] drivers/usb/serial/qcserial.c: qc_release
[76955.166770] qcserial 2-1.4:1.1: device disconnected
[76956.364882] usb 2-1.4: new high speed USB device number 5 using ehci_hcd
[76956.451649] usb 2-1.4: New USB device found, idVendor=05c6, idProduct=9205
[76956.451655] usb 2-1.4: New USB device strings: Mfr=3, Product=2, SerialNumber=0
[76956.451658] usb 2-1.4: Product: Qualcomm Gobi 2000
[76956.451660] usb 2-1.4: Manufacturer: Qualcomm Incorporated
[76956.453444] drivers/usb/serial/qcserial.c: qcprobe
[76956.453447] drivers/usb/serial/qcserial.c: Num Interfaces = 4
[76956.453449] drivers/usb/serial/qcserial.c: This Interface = 0
[76956.453537] drivers/usb/serial/qcserial.c: qcprobe
[76956.453539] drivers/usb/serial/qcserial.c: Num Interfaces = 4
[76956.453541] drivers/usb/serial/qcserial.c: This Interface = 1
[76956.453543] drivers/usb/serial/qcserial.c: Diagnostics Monitor found
[76956.454045] qcserial 2-1.4:1.1: Qualcomm USB modem converter detected
[76956.454124] usb 2-1.4: Qualcomm USB modem converter now attached to ttyUSB0
[76956.454167] drivers/usb/serial/qcserial.c: qcprobe
[76956.454169] drivers/usb/serial/qcserial.c: Num Interfaces = 4
[76956.454171] drivers/usb/serial/qcserial.c: This Interface = 2
[76956.454173] drivers/usb/serial/qcserial.c: Modem port found
[76956.454933] qcserial 2-1.4:1.2: Qualcomm USB modem converter detected
[76956.454999] usb 2-1.4: Qualcomm USB modem converter now attached to ttyUSB1
[76956.455043] drivers/usb/serial/qcserial.c: qcprobe
[76956.455045] drivers/usb/serial/qcserial.c: Num Interfaces = 4
[76956.455047] drivers/usb/serial/qcserial.c: This Interface = 3
[76956.455050] drivers/usb/serial/qcserial.c: NMEA GPS interface found
[76956.455540] qcserial 2-1.4:1.3: Qualcomm USB modem converter detected
[76956.455605] usb 2-1.4: Qualcomm USB modem converter now attached to ttyUSB2
[77206.484909] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[77265.005601] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[77265.242588] e1000e 0000:00:19.0: irq 42 for MSI/MSI-X
[77265.294446] e1000e 0000:00:19.0: irq 42 for MSI/MSI-X
[77265.295595] ADDRCONF(NETDEV_UP): eth0: link is not ready
[77265.416383] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[77267.603275] wlan0: authenticate with 00:24:fe:06:70:b7 (try 1)
[77267.605288] wlan0: authenticated
[77267.605372] wlan0: associate with 00:24:fe:06:70:b7 (try 1)
[77267.612073] wlan0: RX AssocResp from 00:24:fe:06:70:b7 (capab=0x411 status=0 aid=2)
[77267.612077] wlan0: associated
[77267.616291] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[77278.541773] wlan0: no IPv6 routers present

--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="lspci-vv.txt"

00:00.0 Host bridge: Intel Corporation Core Processor DRAM Controller (rev 02)
	Subsystem: Lenovo Device 2193
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: <access denied>

00:01.0 PCI bridge: Intel Corporation Core Processor PCI Express x16 Root Port (rev 02) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	I/O behind bridge: 00002000-00002fff
	Memory behind bridge: cc000000-cdefffff
	Prefetchable memory behind bridge: 00000000ce000000-00000000dfffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>
	Kernel driver in use: pcieport

00:16.0 Communication controller: Intel Corporation 5 Series/3400 Series Chipset HECI Controller (rev 06)
	Subsystem: Lenovo Device 215f
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx+
	Latency: 0
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at f2427800 (64-bit, non-prefetchable) [size=16]
	Capabilities: <access denied>

00:19.0 Ethernet controller: Intel Corporation 82577LM Gigabit Network Connection (rev 06)
	Subsystem: Lenovo Device 2153
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 42
	Region 0: Memory at f2400000 (32-bit, non-prefetchable) [size=128K]
	Region 1: Memory at f2425000 (32-bit, non-prefetchable) [size=4K]
	Region 2: I/O ports at 1820 [size=32]
	Capabilities: <access denied>
	Kernel driver in use: e1000e
	Kernel modules: e1000e

00:1a.0 USB Controller: Intel Corporation 5 Series/3400 Series Chipset USB2 Enhanced Host Controller (rev 06) (prog-if 20 [EHCI])
	Subsystem: Lenovo Device 2163
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin D routed to IRQ 23
	Region 0: Memory at f2428000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: <access denied>
	Kernel driver in use: ehci_hcd
	Kernel modules: ehci-hcd

00:1b.0 Audio device: Intel Corporation 5 Series/3400 Series Chipset High Definition Audio (rev 06)
	Subsystem: Lenovo Device 215e
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin B routed to IRQ 43
	Region 0: Memory at f2420000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: <access denied>
	Kernel driver in use: HDA Intel
	Kernel modules: snd-hda-intel

00:1c.0 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 1 (rev 06) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>
	Kernel driver in use: pcieport

00:1c.1 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 2 (rev 06) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
	Memory behind bridge: f2000000-f20fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>
	Kernel driver in use: pcieport

00:1c.3 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 4 (rev 06) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=05, subordinate=0c, sec-latency=0
	I/O behind bridge: 00003000-00003fff
	Memory behind bridge: f0000000-f1ffffff
	Prefetchable memory behind bridge: 00000000f2500000-00000000f25fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>
	Kernel driver in use: pcieport

00:1c.4 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 5 (rev 06) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=0d, subordinate=0d, sec-latency=0
	Memory behind bridge: f2100000-f21fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>
	Kernel driver in use: pcieport

00:1d.0 USB Controller: Intel Corporation 5 Series/3400 Series Chipset USB2 Enhanced Host Controller (rev 06) (prog-if 20 [EHCI])
	Subsystem: Lenovo Device 2163
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin D routed to IRQ 19
	Region 0: Memory at f2428400 (32-bit, non-prefetchable) [size=1K]
	Capabilities: <access denied>
	Kernel driver in use: ehci_hcd
	Kernel modules: ehci-hcd

00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev a6) (prog-if 01 [Subtractive decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Bus: primary=00, secondary=0e, subordinate=0e, sec-latency=0
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>

00:1f.0 ISA bridge: Intel Corporation Mobile 5 Series Chipset LPC Interface Controller (rev 06)
	Subsystem: Lenovo Device 2166
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: <access denied>

00:1f.2 SATA controller: Intel Corporation 5 Series/3400 Series Chipset 6 port SATA AHCI Controller (rev 06) (prog-if 01 [AHCI 1.0])
	Subsystem: Lenovo Device 2168
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 41
	Region 0: I/O ports at 1818 [size=8]
	Region 1: I/O ports at 180c [size=4]
	Region 2: I/O ports at 1810 [size=8]
	Region 3: I/O ports at 1808 [size=4]
	Region 4: I/O ports at 1840 [size=32]
	Region 5: Memory at f2427000 (32-bit, non-prefetchable) [size=2K]
	Capabilities: <access denied>
	Kernel driver in use: ahci

00:1f.3 SMBus: Intel Corporation 5 Series/3400 Series Chipset SMBus Controller (rev 06)
	Subsystem: Lenovo Device 2167
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 23
	Region 0: Memory at f2428800 (64-bit, non-prefetchable) [size=256]
	Region 4: I/O ports at 1860 [size=32]
	Kernel driver in use: i801_smbus
	Kernel modules: i2c-i801

00:1f.6 Signal processing controller: Intel Corporation 5 Series/3400 Series Chipset Thermal Subsystem (rev 06)
	Subsystem: Lenovo Device 2190
	Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin D routed to IRQ 19
	Region 0: Memory at f2426000 (64-bit, non-prefetchable) [size=4K]
	Capabilities: <access denied>
	Kernel driver in use: intel ips
	Kernel modules: intel_ips

01:00.0 VGA compatible controller: nVidia Corporation GT218 [NVS 3100M] (rev a2) (prog-if 00 [VGA controller])
	Subsystem: Lenovo Device 215c
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 45
	Region 0: Memory at cc000000 (32-bit, non-prefetchable) [size=16M]
	Region 1: Memory at d0000000 (64-bit, prefetchable) [size=256M]
	Region 3: Memory at ce000000 (64-bit, prefetchable) [size=32M]
	Region 5: I/O ports at 2000 [size=128]
	[virtual] Expansion ROM at cd000000 [disabled] [size=512K]
	Capabilities: <access denied>
	Kernel driver in use: nvidia
	Kernel modules: nvidia, nouveau

01:00.1 Audio device: nVidia Corporation High Definition Audio Controller (rev a1)
	Subsystem: Lenovo Device 218f
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at cdefc000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: <access denied>
	Kernel driver in use: HDA Intel
	Kernel modules: snd-hda-intel

03:00.0 Network controller: Intel Corporation Centrino Ultimate-N 6300 (rev 35)
	Subsystem: Intel Corporation Centrino Ultimate-N 6300 3x3 AGN
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 44
	Region 0: Memory at f2000000 (64-bit, non-prefetchable) [size=8K]
	Capabilities: <access denied>
	Kernel driver in use: iwlagn
	Kernel modules: iwlagn

0d:00.0 SD Host controller: Ricoh Co Ltd MMC/SD Host Controller (rev 01)
	Subsystem: Lenovo Device 2133
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at f2100000 (32-bit, non-prefetchable) [size=256]
	Capabilities: <access denied>
	Kernel driver in use: sdhci-pci
	Kernel modules: sdhci-pci

0d:00.1 System peripheral: Ricoh Co Ltd Memory Stick Host Controller (rev 01)
	Subsystem: Lenovo Device 2134
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin B routed to IRQ 10
	Region 0: Memory at f2100400 (32-bit, non-prefetchable) [size=256]
	Capabilities: <access denied>

0d:00.3 FireWire (IEEE 1394): Ricoh Co Ltd FireWire Host Controller (rev 01) (prog-if 10 [OHCI])
	Subsystem: Lenovo Device 2136
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin D routed to IRQ 10
	Region 0: Memory at f2100800 (32-bit, non-prefetchable) [size=2K]
	Capabilities: <access denied>

ff:00.0 Host bridge: Intel Corporation Core Processor QuickPath Architecture Generic Non-core Registers (rev 02)
	Subsystem: Lenovo Device 2196
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:00.1 Host bridge: Intel Corporation Core Processor QuickPath Architecture System Address Decoder (rev 02)
	Subsystem: Lenovo Device 2196
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:02.0 Host bridge: Intel Corporation Core Processor QPI Link 0 (rev 02)
	Subsystem: Lenovo Device 2196
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:02.1 Host bridge: Intel Corporation Core Processor QPI Physical 0 (rev 02)
	Subsystem: Lenovo Device 2196
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:02.2 Host bridge: Intel Corporation Core Processor Reserved (rev 02)
	Subsystem: Lenovo Device 2196
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:02.3 Host bridge: Intel Corporation Core Processor Reserved (rev 02)
	Subsystem: Lenovo Device 2196
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0


--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="interrupts.txt"

           CPU0       CPU1       CPU2       CPU3       
  0:        297         35         49         45   IO-APIC-edge      timer
  1:      29289       2760       2831       2778   IO-APIC-edge      i8042
  8:         25         20         22         23   IO-APIC-edge      rtc0
  9:     958099     201301     201355     201264   IO-APIC-fasteoi   acpi
 12:          6          1          1          1   IO-APIC-edge      i8042
 16:         15         12         18         15   IO-APIC-fasteoi   hda_intel, mmc0
 19:      10086         26         35         23   IO-APIC-fasteoi   ips, ehci_hcd:usb2
 23:      46823      79863      55579      50414   IO-APIC-fasteoi   ehci_hcd:usb1
 41:     481244      71758      71708      71786   PCI-MSI-edge      ahci
 42:        945       2740       1873       1634   PCI-MSI-edge      eth0
 43:      88306     280938     139215     104281   PCI-MSI-edge      hda_intel
 44:    2112521     420940     422471     421806   PCI-MSI-edge      iwlagn
 45:      24023      64165      51583      33809   PCI-MSI-edge      nvidia
NMI:          0          0          0          0   Non-maskable interrupts
LOC:   97096018   94894657  100359537   99741220   Local timer interrupts
SPU:          0          0          0          0   Spurious interrupts
PMI:          0          0          0          0   Performance monitoring interrupts
IWI:          0          0          0          0   IRQ work interrupts
RES:    2224790    3732132    1161795    1021567   Rescheduling interrupts
CAL:    2032239    1512187    1121241    1016947   Function call interrupts
TLB:      40624      45485      42765      42159   TLB shootdowns
TRM:          0          0          0          0   Thermal event interrupts
THR:          0          0          0          0   Threshold APIC interrupts
MCE:          0          0          0          0   Machine check exceptions
MCP:        312        311        311        311   Machine check polls
ERR:          0
MIS:          0

--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="modules.txt"

uhci_hcd 19256 0 - Live 0xf8512000
sdhci_pci 6703 0 - Live 0xf84d8000
sdhci 14975 1 sdhci_pci, Live 0xf84cc000
mmc_block 8037 0 - Live 0xf845f000
mmc_core 57109 2 sdhci,mmc_block, Live 0xf84aa000
ehci_hcd 34479 0 - Live 0xf8470000
usb_storage 28135 0 - Live 0xfa508000
usbmon 15729 0 - Live 0xfa4f0000
usblp 9095 0 - Live 0xfa4e0000
tun 12472 0 - Live 0xfa4bc000
tp_smapi 15504 0 - Live 0xfa4ab000
thinkpad_ec 3995 1 tp_smapi, Live 0xfa497000
snd_seq_oss 23584 0 - Live 0xfa485000
snd_seq_midi_event 4368 1 snd_seq_oss, Live 0xfa473000
snd_seq_dummy 983 0 - Live 0xfa469000
snd_seq 39328 5 snd_seq_oss,snd_seq_midi_event,snd_seq_dummy, Live 0xfa453000
snd_seq_device 4172 3 snd_seq_oss,snd_seq_dummy,snd_seq, Live 0xfa43b000
snd_pcm_oss 33152 0 - Live 0xfa427000
snd_mixer_oss 12248 1 snd_pcm_oss, Live 0xfa412000
snd_hrtimer 1200 0 - Live 0xfa405000
snd_aloop 11092 0 - Live 0xfa3f8000
sbs 8805 0 - Live 0xfa3e9000
sbshc 2664 1 sbs, Live 0xfa3dd000
ohci_hcd 19178 0 - Live 0xfa3ce000
msr 2016 0 - Live 0xfa3bf000
joydev 7407 0 - Live 0xfa3a6000
fuse 57109 3 - Live 0xfa389000
fan 1790 0 - Live 0xfa36d000
display 2167 0 - Live 0xfa363000
coretemp 4222 0 - Live 0xfa358000
cdc_acm 13553 0 - Live 0xfa349000
btusb 9681 0 - Live 0xfa337000
bluetooth 112005 1 btusb, Live 0xfa30a000
acpi_cpufreq 4869 1 - Live 0xfa2db000
mperf 883 1 acpi_cpufreq, Live 0xfa2d0000
uvcvideo 54357 0 - Live 0xfa2b8000
qcserial 3338 0 - Live 0xfa28f000
usb_wwan 7590 1 qcserial, Live 0xfa263000
usbserial 23879 2 qcserial,usb_wwan, Live 0xfa20f000
videodev 68079 1 uvcvideo, Live 0xfa1c6000
usbhid 22087 0 - Live 0xfa13b000
nvidia 10504894 85 - Live 0xf956d000 (P)
iwlagn 325564 0 - Live 0xf897e000
snd_hda_codec_conexant 33612 1 - Live 0xf88cd000
snd_hda_intel 18465 4 - Live 0xf889e000
mac80211 159579 1 iwlagn, Live 0xf8802000
snd_hda_codec 47828 2 snd_hda_codec_conexant,snd_hda_intel, Live 0xf885e000
sr_mod 12380 0 - Live 0xf87c0000
snd_hwdep 4447 1 snd_hda_codec, Live 0xf87ab000
snd_pcm 57369 5 snd_pcm_oss,snd_aloop,snd_hda_intel,snd_hda_codec, Live 0xf8778000
snd_timer 14975 4 snd_seq,snd_hrtimer,snd_pcm, Live 0xf8744000
processor 20996 1 acpi_cpufreq, Live 0xf8686000
button 3470 0 - Live 0xf8650000
cfg80211 124594 2 iwlagn,mac80211, Live 0xf860d000
i2c_i801 6235 0 - Live 0xf863d000
cdrom 30607 1 sr_mod, Live 0xf85ac000
pcspkr 1327 0 - Live 0xf8599000
intel_ips 9392 0 - Live 0xf858d000
battery 8529 0 - Live 0xf857f000
snd_page_alloc 5757 2 snd_hda_intel,snd_pcm, Live 0xf856e000
ac 2393 0 - Live 0xf8557000
thermal 6355 0 - Live 0xf854b000
e1000e 123512 0 - Live 0xf84dd000
thinkpad_acpi 52675 0 - Live 0xf849b000
wmi 6927 0 - Live 0xf8449000

--WIyZ46R2i8wDzkSu--

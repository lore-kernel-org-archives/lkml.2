Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764Ab0ICN0C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 09:26:02 -0400
Received: from 64.mail-out.ovh.net ([91.121.185.65]:46952 "HELO
	64.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751287Ab0ICNZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 09:25:58 -0400
Message-ID: <4C80F75E.4090906@example.com>
Date: Fri, 03 Sep 2010 15:25:50 +0200
From: Piotr Hosowicz <piotr@hosowicz.com>
Reply-To: piotr@hosowicz.com
Organization: hosowicz.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100805 Icedove/3.0.6
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Nouveau driver fails
References: <4C80DBE5.1040701@example.com>
In-Reply-To: <4C80DBE5.1040701@example.com>
Content-Type: multipart/mixed;
 boundary="------------010102070201030306020703"
X-Ovh-Tracer-Id: 17825247326350438680
X-Ovh-Remote: 83.24.90.160 (dni160.neoplus.adsl.tpnet.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010102070201030306020703
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit

On 03.09.2010 13:28, Piotr Hosowicz wrote:
> Hello,
>
> Nouveau driver seems to fail. Please find attached Xorg.0.log, lspci and
> kernel config. My card is 01:00.0 VGA compatible controller: nVidia
> Corporation G96 [GeForce 9400 GT] (rev a1). Tried with today's Linux Next.

Sorry, I forgot, here is the dmesg output. There is some text about 
unknown connector type:

[   28.935065] [drm] nouveau 0000:01:00.0: unknown connector type: 0xff!!

Regards,

Piotr Hosowicz


-- 
TV: "Jeszcze trzy ruchy i Otylia bêdzie szczê¶liwa."
NP: Peter Green Splinter Group - Big Change Is Gonna Come
NB: 2.6.36-rc3-20100831-1507-pz+

--------------010102070201030306020703
Content-Type: text/plain;
 name="dmesg.2.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg.2.txt"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.36-rc3-next-20100903 (root@aapi205) (gcc version 4.4.5 20100824 (prerelease) (Debian 4.4.4-11) ) #1 SMP PREEMPT Fri Sep 3 10:41:41 CEST 2010
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-2.6.36-rc3-next-20100903 root=UUID=cdb6c166-b027-4a29-87fa-93d604dc5e53 ro quiet vga=791 all_generic_ata
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000cfee0000 (usable)
[    0.000000]  BIOS-e820: 00000000cfee0000 - 00000000cfee2000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cfee2000 - 00000000cfef0000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000cfef0000 - 00000000cff00000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000e4000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000130000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x130000 max_arch_pfn = 0x400000000
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
[    0.000000]   2 base 0D0000000 mask FF0000000 uncachable
[    0.000000]   3 base 100000000 mask FC0000000 write-back
[    0.000000]   4 base 130000000 mask FF0000000 uncachable
[    0.000000]   5 base 0CFF00000 mask FFFF00000 uncachable
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000cff00000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xcfee0 max_arch_pfn = 0x400000000
[    0.000000] Scanning 0 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 000000000009f800 (usable)
[    0.000000]  modified: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 00000000cfee0000 (usable)
[    0.000000]  modified: 00000000cfee0000 - 00000000cfee2000 (ACPI NVS)
[    0.000000]  modified: 00000000cfee2000 - 00000000cfef0000 (ACPI data)
[    0.000000]  modified: 00000000cfef0000 - 00000000cff00000 (reserved)
[    0.000000]  modified: 00000000e0000000 - 00000000e4000000 (reserved)
[    0.000000]  modified: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000]  modified: 0000000100000000 - 0000000130000000 (usable)
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] found SMP MP-table at [ffff8800000f5880] f5880
[    0.000000] init_memory_mapping: 0000000000000000-00000000cfee0000
[    0.000000]  0000000000 - 00cfe00000 page 2M
[    0.000000]  00cfe00000 - 00cfee0000 page 4k
[    0.000000] kernel direct mapping tables up to cfee0000 @ 16000-1c000
[    0.000000] init_memory_mapping: 0000000100000000-0000000130000000
[    0.000000]  0100000000 - 0130000000 page 2M
[    0.000000] kernel direct mapping tables up to 130000000 @ 1a000-20000
[    0.000000] RAMDISK: 375bc000 - 37ff0000
[    0.000000] ACPI: RSDP 00000000000f7270 00014 (v00 GBT   )
[    0.000000] ACPI: RSDT 00000000cfee2040 0003C (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: FACP 00000000cfee20c0 00074 (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: DSDT 00000000cfee2180 04CD2 (v01 GBT    GBTUACPI 00001000 MSFT 0100000C)
[    0.000000] ACPI: FACS 00000000cfee0000 00040
[    0.000000] ACPI: EUDS 00000000cfee7580 00470 (v01 GBT             00000000      00000000)
[    0.000000] ACPI: HPET 00000000cfee74c0 00038 (v01 GBT    GBTUACPI 42302E31 GBTU 00000098)
[    0.000000] ACPI: MCFG 00000000cfee7540 0003C (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: APIC 00000000cfee6ec0 00084 (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: SSDT 00000000cfee8320 003AB (v01  PmRef    CpuPm 00003000 INTL 20040311)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-0000000130000000
[    0.000000] Initmem setup node 0 0000000000000000-0000000130000000
[    0.000000]   NODE_DATA [0000000100000000 - 000000010000efff]
[    0.000000]  [ffffea0000000000-ffffea00043fffff] PMD -> [ffff880100200000-ffff880103bfffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00130000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000cfee0
[    0.000000]     0: 0x00100000 -> 0x00130000
[    0.000000] On node 0 totalpages: 1048175
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3927 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 833304 pages, LIFO batch:31
[    0.000000]   Normal zone: 2688 pages used for memmap
[    0.000000]   Normal zone: 193920 pages, LIFO batch:31
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
[    0.000000] early_res array is doubled to 64 at [1b000 - 1b7ff]
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000cfee0000 - 00000000cfee2000
[    0.000000] PM: Registered nosave memory: 00000000cfee2000 - 00000000cfef0000
[    0.000000] PM: Registered nosave memory: 00000000cfef0000 - 00000000cff00000
[    0.000000] PM: Registered nosave memory: 00000000cff00000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000e4000000
[    0.000000] PM: Registered nosave memory: 00000000e4000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at e4000000 (gap: e4000000:1ac00000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 26 pages/cpu @ffff880001a00000 s75200 r8192 d23104 u524288
[    0.000000] pcpu-alloc: s75200 r8192 d23104 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1031151
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-2.6.36-rc3-next-20100903 root=UUID=cdb6c166-b027-4a29-87fa-93d604dc5e53 ro quiet vga=791 all_generic_ata
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Subtract (56 early reservations)
[    0.000000]   #1 [0001000000 - 000180def0]   TEXT DATA BSS
[    0.000000]   #2 [00375bc000 - 0037ff0000]         RAMDISK
[    0.000000]   #3 [000180e000 - 000180e0f6]             BRK
[    0.000000]   #4 [00000f5890 - 0000100000]   BIOS reserved
[    0.000000]   #5 [00000f5880 - 00000f5890]    MP-table mpf
[    0.000000]   #6 [000009f800 - 00000f0d00]   BIOS reserved
[    0.000000]   #7 [00000f0ecc - 00000f5880]   BIOS reserved
[    0.000000]   #8 [00000f0d00 - 00000f0ecc]    MP-table mpc
[    0.000000]   #9 [0000010000 - 0000012000]      TRAMPOLINE
[    0.000000]   #10 [0000012000 - 0000016000]     ACPI WAKEUP
[    0.000000]   #11 [0000016000 - 000001a000]         PGTABLE
[    0.000000]   #12 [000001a000 - 000001b000]         PGTABLE
[    0.000000]   #13 [0100000000 - 010000f000]       NODE_DATA
[    0.000000]   #14 [000180e100 - 000180f100]         BOOTMEM
[    0.000000]   #15 [010000f000 - 010000f300]         BOOTMEM
[    0.000000]   #16 [0100010000 - 0100011000]         BOOTMEM
[    0.000000]   #17 [0100011000 - 0100012000]         BOOTMEM
[    0.000000]   #18 [0100200000 - 0103c00000]        MEMMAP 0
[    0.000000]   #19 [000180f100 - 0001827100]         BOOTMEM
[    0.000000]   #20 [0001827100 - 000183f100]         BOOTMEM
[    0.000000]   #21 [000183f100 - 0001857100]         BOOTMEM
[    0.000000]   #22 [0001858000 - 0001859000]         BOOTMEM
[    0.000000]   #23 [000180df00 - 000180df41]         BOOTMEM
[    0.000000]   #24 [000180df80 - 000180dfc3]         BOOTMEM
[    0.000000]   #25 [0001857100 - 0001857368]         BOOTMEM
[    0.000000]   #26 [0001857380 - 00018573e8]         BOOTMEM
[    0.000000]   #27 [0001857400 - 0001857468]         BOOTMEM
[    0.000000]   #28 [0001857480 - 00018574e8]         BOOTMEM
[    0.000000]   #29 [0001857500 - 0001857568]         BOOTMEM
[    0.000000]   #30 [0001857580 - 00018575e8]         BOOTMEM
[    0.000000]   #31 [0001857600 - 0001857668]         BOOTMEM
[    0.000000]   #32 [0001857680 - 00018576e8]         BOOTMEM
[    0.000000]   #33 [0001857700 - 0001857768]         BOOTMEM
[    0.000000]   #34 [0001857780 - 00018577e8]         BOOTMEM
[    0.000000]   #35 [0001857800 - 0001857868]         BOOTMEM
[    0.000000]   #36 [0001857880 - 00018578a0]         BOOTMEM
[    0.000000]   #37 [00018578c0 - 00018578e0]         BOOTMEM
[    0.000000]   #38 [0001857900 - 000185797d]         BOOTMEM
[    0.000000]   #39 [0001857980 - 00018579fd]         BOOTMEM
[    0.000000]   #40 [0001a00000 - 0001a1a000]         BOOTMEM
[    0.000000]   #41 [0001a80000 - 0001a9a000]         BOOTMEM
[    0.000000]   #42 [0001b00000 - 0001b1a000]         BOOTMEM
[    0.000000]   #43 [0001b80000 - 0001b9a000]         BOOTMEM
[    0.000000]   #44 [0001857a00 - 0001857a08]         BOOTMEM
[    0.000000]   #45 [0001857a40 - 0001857a48]         BOOTMEM
[    0.000000]   #46 [0001857a80 - 0001857a90]         BOOTMEM
[    0.000000]   #47 [0001857ac0 - 0001857ae0]         BOOTMEM
[    0.000000]   #48 [0001857b00 - 0001857c30]         BOOTMEM
[    0.000000]   #49 [0001857c40 - 0001857c90]         BOOTMEM
[    0.000000]   #50 [0001857cc0 - 0001857d10]         BOOTMEM
[    0.000000]   #51 [0001859000 - 0001861000]         BOOTMEM
[    0.000000]   #52 [0001b9a000 - 0005b9a000]         BOOTMEM
[    0.000000]   #53 [0001861000 - 0001881000]         BOOTMEM
[    0.000000]   #54 [0001881000 - 00018c1000]         BOOTMEM
[    0.000000]   #55 [000001b800 - 0000023800]         BOOTMEM
[    0.000000] Memory: 4047792k/4980736k available (3162k kernel code, 788036k absent, 144908k reserved, 3743k data, 540k init)
[    0.000000] Preemptable hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:712
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2333.167 MHz processor.
[    0.004005] Calibrating delay loop (skipped), value calculated using timer frequency.. 4666.33 BogoMIPS (lpj=9332668)
[    0.004009] pid_max: default: 32768 minimum: 301
[    0.004062] Security Framework initialized
[    0.004071] SELinux:  Disabled at boot.
[    0.004454] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.006023] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.008656] Mount-cache hash table entries: 256
[    0.008814] Initializing cgroup subsys ns
[    0.008818] Initializing cgroup subsys cpuacct
[    0.008822] Initializing cgroup subsys devices
[    0.008825] Initializing cgroup subsys blkio
[    0.008867] CPU: Physical Processor ID: 0
[    0.008869] CPU: Processor Core ID: 0
[    0.008871] mce: CPU supports 6 MCE banks
[    0.008878] CPU0: Thermal monitoring enabled (TM2)
[    0.008882] using mwait in idle threads.
[    0.008883] Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
[    0.008891] ... version:                2
[    0.008892] ... bit width:              40
[    0.008894] ... generic registers:      2
[    0.008895] ... value mask:             000000ffffffffff
[    0.008897] ... max period:             000000007fffffff
[    0.008898] ... fixed-purpose events:   3
[    0.008900] ... event mask:             0000000700000003
[    0.009656] ACPI: Core revision 20100702
[    0.016063] Setting APIC routing to flat
[    0.016369] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.056068] CPU0: Intel(R) Core(TM)2 Quad  CPU   Q8200  @ 2.33GHz stepping 07
[    0.072022] Booting Node   0, Processors  #1 #2 #3 Ok.
[    0.356010] Brought up 4 CPUs
[    0.356014] Total of 4 processors activated (18664.61 BogoMIPS).
[    0.357325] devtmpfs: initialized
[    0.362257] regulator: core version 0.5
[    0.362257] regulator: dummy: 
[    0.362257] NET: Registered protocol family 16
[    0.364065] ACPI: bus type pci registered
[    0.364077] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xe0000000-0xe3ffffff] (base 0xe0000000)
[    0.364077] PCI: MMCONFIG at [mem 0xe0000000-0xe3ffffff] reserved in E820
[    0.371258] PCI: Using configuration type 1 for base access
[    0.372199] bio: create slab <bio-0> at 0
[    0.376294] ACPI: EC: Look up EC in DSDT
[    0.381995] ACPI: SSDT 00000000cfee7a40 0022A (v01  PmRef  Cpu0Ist 00003000 INTL 20040311)
[    0.382249] ACPI: Dynamic OEM Table Load:
[    0.382252] ACPI: SSDT (null) 0022A (v01  PmRef  Cpu0Ist 00003000 INTL 20040311)
[    0.382500] ACPI: SSDT 00000000cfee7f00 00152 (v01  PmRef  Cpu1Ist 00003000 INTL 20040311)
[    0.382741] ACPI: Dynamic OEM Table Load:
[    0.382744] ACPI: SSDT (null) 00152 (v01  PmRef  Cpu1Ist 00003000 INTL 20040311)
[    0.382979] ACPI: SSDT 00000000cfee8060 00152 (v01  PmRef  Cpu2Ist 00003000 INTL 20040311)
[    0.383220] ACPI: Dynamic OEM Table Load:
[    0.383223] ACPI: SSDT (null) 00152 (v01  PmRef  Cpu2Ist 00003000 INTL 20040311)
[    0.383459] ACPI: SSDT 00000000cfee81c0 00152 (v01  PmRef  Cpu3Ist 00003000 INTL 20040311)
[    0.383701] ACPI: Dynamic OEM Table Load:
[    0.383704] ACPI: SSDT (null) 00152 (v01  PmRef  Cpu3Ist 00003000 INTL 20040311)
[    0.383737] ACPI: Interpreter enabled
[    0.383740] ACPI: (supports S0 S3 S4 S5)
[    0.383762] ACPI: Using IOAPIC for interrupt routing
[    0.392194] ACPI: No dock devices found.
[    0.392198] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.392287] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3f])
[    0.392324] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
[    0.392324] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
[    0.392324] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.392324] pci_root PNP0A03:00: host bridge window [mem 0x000c0000-0x000dffff]
[    0.392324] pci_root PNP0A03:00: host bridge window [mem 0xcff00000-0xfebfffff]
[    0.392324] pci_bus 0000:00: scanning bus
[    0.392324] pci 0000:00:00.0: found [8086:2e20] class 000600 header type 00
[    0.392324] pci 0000:00:00.0: calling quirk_mmio_always_on+0x0/0x17
[    0.392324] pci 0000:00:00.0: calling quirk_resource_alignment+0x0/0x166
[    0.392324] pci 0000:00:00.0: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.392324] pci 0000:00:01.0: found [8086:2e21] class 000604 header type 01
[    0.392324] pci 0000:00:01.0: calling quirk_mmio_always_on+0x0/0x17
[    0.392324] pci 0000:00:01.0: calling quirk_resource_alignment+0x0/0x166
[    0.392324] pci 0000:00:01.0: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.392324] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.392324] pci 0000:00:01.0: PME# disabled
[    0.392324] pci 0000:00:1a.0: found [8086:3a37] class 000c03 header type 00
[    0.392324] pci 0000:00:1a.0: calling quirk_mmio_always_on+0x0/0x17
[    0.392341] pci 0000:00:1a.0: reg 20: [io  0xe000-0xe01f]
[    0.392359] pci 0000:00:1a.0: calling quirk_resource_alignment+0x0/0x166
[    0.392362] pci 0000:00:1a.0: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.392389] pci 0000:00:1a.1: found [8086:3a38] class 000c03 header type 00
[    0.392395] pci 0000:00:1a.1: calling quirk_mmio_always_on+0x0/0x17
[    0.392431] pci 0000:00:1a.1: reg 20: [io  0xe100-0xe11f]
[    0.392449] pci 0000:00:1a.1: calling quirk_resource_alignment+0x0/0x166
[    0.392452] pci 0000:00:1a.1: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.392478] pci 0000:00:1a.2: found [8086:3a39] class 000c03 header type 00
[    0.392485] pci 0000:00:1a.2: calling quirk_mmio_always_on+0x0/0x17
[    0.392520] pci 0000:00:1a.2: reg 20: [io  0xe500-0xe51f]
[    0.392538] pci 0000:00:1a.2: calling quirk_resource_alignment+0x0/0x166
[    0.392541] pci 0000:00:1a.2: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.392572] pci 0000:00:1a.7: found [8086:3a3c] class 000c03 header type 00
[    0.392579] pci 0000:00:1a.7: calling quirk_mmio_always_on+0x0/0x17
[    0.392590] pci 0000:00:1a.7: reg 10: [mem 0xeb205000-0xeb2053ff]
[    0.392638] pci 0000:00:1a.7: calling quirk_resource_alignment+0x0/0x166
[    0.392641] pci 0000:00:1a.7: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.392672] pci 0000:00:1b.0: found [8086:3a3e] class 000403 header type 00
[    0.392676] pci 0000:00:1b.0: calling quirk_mmio_always_on+0x0/0x17
[    0.392690] pci 0000:00:1b.0: reg 10: [mem 0xeb200000-0xeb203fff 64bit]
[    0.392724] pci 0000:00:1b.0: calling quirk_resource_alignment+0x0/0x166
[    0.392727] pci 0000:00:1b.0: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.392745] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.392749] pci 0000:00:1b.0: PME# disabled
[    0.392768] pci 0000:00:1c.0: found [8086:3a40] class 000604 header type 01
[    0.392772] pci 0000:00:1c.0: calling quirk_mmio_always_on+0x0/0x17
[    0.392803] pci 0000:00:1c.0: calling quirk_resource_alignment+0x0/0x166
[    0.392806] pci 0000:00:1c.0: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.392827] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.392831] pci 0000:00:1c.0: PME# disabled
[    0.392852] pci 0000:00:1c.3: found [8086:3a46] class 000604 header type 01
[    0.392856] pci 0000:00:1c.3: calling quirk_mmio_always_on+0x0/0x17
[    0.392887] pci 0000:00:1c.3: calling quirk_resource_alignment+0x0/0x166
[    0.392890] pci 0000:00:1c.3: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.392911] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.392915] pci 0000:00:1c.3: PME# disabled
[    0.392935] pci 0000:00:1c.4: found [8086:3a48] class 000604 header type 01
[    0.392938] pci 0000:00:1c.4: calling quirk_mmio_always_on+0x0/0x17
[    0.392970] pci 0000:00:1c.4: calling quirk_resource_alignment+0x0/0x166
[    0.392973] pci 0000:00:1c.4: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.392994] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.392997] pci 0000:00:1c.4: PME# disabled
[    0.393021] pci 0000:00:1d.0: found [8086:3a34] class 000c03 header type 00
[    0.393027] pci 0000:00:1d.0: calling quirk_mmio_always_on+0x0/0x17
[    0.393063] pci 0000:00:1d.0: reg 20: [io  0xe200-0xe21f]
[    0.393081] pci 0000:00:1d.0: calling quirk_resource_alignment+0x0/0x166
[    0.393084] pci 0000:00:1d.0: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.393110] pci 0000:00:1d.1: found [8086:3a35] class 000c03 header type 00
[    0.393117] pci 0000:00:1d.1: calling quirk_mmio_always_on+0x0/0x17
[    0.393153] pci 0000:00:1d.1: reg 20: [io  0xe300-0xe31f]
[    0.393170] pci 0000:00:1d.1: calling quirk_resource_alignment+0x0/0x166
[    0.393174] pci 0000:00:1d.1: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.393200] pci 0000:00:1d.2: found [8086:3a36] class 000c03 header type 00
[    0.393207] pci 0000:00:1d.2: calling quirk_mmio_always_on+0x0/0x17
[    0.393242] pci 0000:00:1d.2: reg 20: [io  0xe400-0xe41f]
[    0.393260] pci 0000:00:1d.2: calling quirk_resource_alignment+0x0/0x166
[    0.393263] pci 0000:00:1d.2: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.393294] pci 0000:00:1d.7: found [8086:3a3a] class 000c03 header type 00
[    0.393301] pci 0000:00:1d.7: calling quirk_mmio_always_on+0x0/0x17
[    0.393312] pci 0000:00:1d.7: reg 10: [mem 0xeb204000-0xeb2043ff]
[    0.393360] pci 0000:00:1d.7: calling quirk_resource_alignment+0x0/0x166
[    0.393363] pci 0000:00:1d.7: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.393391] pci 0000:00:1e.0: found [8086:244e] class 000604 header type 01
[    0.393397] pci 0000:00:1e.0: calling quirk_mmio_always_on+0x0/0x17
[    0.393422] pci 0000:00:1e.0: calling quirk_resource_alignment+0x0/0x166
[    0.393425] pci 0000:00:1e.0: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.393452] pci 0000:00:1f.0: found [8086:3a18] class 000601 header type 00
[    0.393460] pci 0000:00:1f.0: calling quirk_mmio_always_on+0x0/0x17
[    0.393525] pci 0000:00:1f.0: calling quirk_resource_alignment+0x0/0x166
[    0.393528] pci 0000:00:1f.0: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.393561] pci 0000:00:1f.2: found [8086:3a20] class 000101 header type 00
[    0.393569] pci 0000:00:1f.2: calling quirk_mmio_always_on+0x0/0x17
[    0.393578] pci 0000:00:1f.2: reg 10: [io  0x0000-0x0007]
[    0.393586] pci 0000:00:1f.2: reg 14: [io  0x0000-0x0003]
[    0.393593] pci 0000:00:1f.2: reg 18: [io  0x0000-0x0007]
[    0.393600] pci 0000:00:1f.2: reg 1c: [io  0x0000-0x0003]
[    0.393608] pci 0000:00:1f.2: reg 20: [io  0xf000-0xf00f]
[    0.393615] pci 0000:00:1f.2: reg 24: [io  0xf100-0xf10f]
[    0.393627] pci 0000:00:1f.2: calling quirk_resource_alignment+0x0/0x166
[    0.393630] pci 0000:00:1f.2: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.393656] pci 0000:00:1f.3: found [8086:3a30] class 000c05 header type 00
[    0.393660] pci 0000:00:1f.3: calling quirk_mmio_always_on+0x0/0x17
[    0.393673] pci 0000:00:1f.3: reg 10: [mem 0xeb206000-0xeb2060ff 64bit]
[    0.393693] pci 0000:00:1f.3: reg 20: [io  0x0500-0x051f]
[    0.393709] pci 0000:00:1f.3: calling quirk_resource_alignment+0x0/0x166
[    0.393712] pci 0000:00:1f.3: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.393730] pci 0000:00:1f.5: found [8086:3a26] class 000101 header type 00
[    0.393738] pci 0000:00:1f.5: calling quirk_mmio_always_on+0x0/0x17
[    0.393747] pci 0000:00:1f.5: reg 10: [io  0xe700-0xe707]
[    0.393754] pci 0000:00:1f.5: reg 14: [io  0xe800-0xe803]
[    0.393762] pci 0000:00:1f.5: reg 18: [io  0xe900-0xe907]
[    0.393769] pci 0000:00:1f.5: reg 1c: [io  0xea00-0xea03]
[    0.393777] pci 0000:00:1f.5: reg 20: [io  0xeb00-0xeb0f]
[    0.393784] pci 0000:00:1f.5: reg 24: [io  0xec00-0xec0f]
[    0.393795] pci 0000:00:1f.5: calling quirk_resource_alignment+0x0/0x166
[    0.393798] pci 0000:00:1f.5: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.393820] pci_bus 0000:00: fixups for bus
[    0.393824] pci 0000:00:01.0: scanning [bus 01-01] behind bridge, pass 0
[    0.393846] pci_bus 0000:01: scanning bus
[    0.393859] pci 0000:01:00.0: found [10de:0641] class 000300 header type 00
[    0.393863] pci 0000:01:00.0: calling quirk_mmio_always_on+0x0/0x17
[    0.393872] pci 0000:01:00.0: reg 10: [mem 0xe6000000-0xe6ffffff]
[    0.393883] pci 0000:01:00.0: reg 14: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.393893] pci 0000:01:00.0: reg 1c: [mem 0xe4000000-0xe5ffffff 64bit]
[    0.393901] pci 0000:01:00.0: reg 24: [io  0xa000-0xa07f]
[    0.393908] pci 0000:01:00.0: reg 30: [mem 0x00000000-0x0007ffff pref]
[    0.393913] pci 0000:01:00.0: calling quirk_resource_alignment+0x0/0x166
[    0.393954] pci_bus 0000:01: fixups for bus
[    0.393956] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.393959] pci 0000:00:01.0:   bridge window [io  0xa000-0xafff]
[    0.393962] pci 0000:00:01.0:   bridge window [mem 0xe4000000-0xe7ffffff]
[    0.393966] pci 0000:00:01.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.393968] pci_bus 0000:01: bus scan returning with max=01
[    0.393972] pci 0000:00:1c.0: scanning [bus 02-02] behind bridge, pass 0
[    0.394005] pci_bus 0000:02: scanning bus
[    0.394008] pci_bus 0000:02: fixups for bus
[    0.394010] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.394014] pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.394018] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.394023] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.394026] pci_bus 0000:02: bus scan returning with max=02
[    0.394030] pci 0000:00:1c.3: scanning [bus 03-03] behind bridge, pass 0
[    0.394063] pci_bus 0000:03: scanning bus
[    0.394084] pci 0000:03:00.0: found [197b:2363] class 000101 header type 00
[    0.394090] pci 0000:03:00.0: calling quirk_jmicron_ata+0x0/0x100
[    0.394103] pci 0000:03:00.0: calling quirk_mmio_always_on+0x0/0x17
[    0.394176] pci 0000:03:00.0: reg 24: [mem 0xeb100000-0xeb101fff]
[    0.394194] pci 0000:03:00.0: calling quirk_resource_alignment+0x0/0x166
[    0.394221] pci 0000:03:00.0: PME# supported from D3hot
[    0.394226] pci 0000:03:00.0: PME# disabled
[    0.394255] pci 0000:03:00.1: found [197b:2363] class 000101 header type 00
[    0.394265] pci 0000:03:00.1: calling quirk_jmicron_ata+0x0/0x100
[    0.394268] pci 0000:03:00.1: calling quirk_mmio_always_on+0x0/0x17
[    0.394285] pci 0000:03:00.1: reg 10: [io  0xb000-0xb007]
[    0.394298] pci 0000:03:00.1: reg 14: [io  0xb100-0xb103]
[    0.394311] pci 0000:03:00.1: reg 18: [io  0xb200-0xb207]
[    0.394325] pci 0000:03:00.1: reg 1c: [io  0xb300-0xb303]
[    0.394338] pci 0000:03:00.1: reg 20: [io  0xb400-0xb40f]
[    0.394368] pci 0000:03:00.1: calling quirk_resource_alignment+0x0/0x166
[    0.394408] pci 0000:03:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.394421] pci_bus 0000:03: fixups for bus
[    0.394423] pci 0000:00:1c.3: PCI bridge to [bus 03-03]
[    0.394426] pci 0000:00:1c.3:   bridge window [io  0xb000-0xbfff]
[    0.394430] pci 0000:00:1c.3:   bridge window [mem 0xeb100000-0xeb1fffff]
[    0.394436] pci 0000:00:1c.3:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.394438] pci_bus 0000:03: bus scan returning with max=03
[    0.394442] pci 0000:00:1c.4: scanning [bus 04-04] behind bridge, pass 0
[    0.394477] pci_bus 0000:04: scanning bus
[    0.394497] pci 0000:04:00.0: found [10ec:8168] class 000200 header type 00
[    0.394501] pci 0000:04:00.0: calling quirk_mmio_always_on+0x0/0x17
[    0.394516] pci 0000:04:00.0: reg 10: [io  0xc000-0xc0ff]
[    0.396024] pci 0000:04:00.0: reg 18: [mem 0xeb010000-0xeb010fff 64bit pref]
[    0.396042] pci 0000:04:00.0: reg 20: [mem 0xeb000000-0xeb00ffff 64bit pref]
[    0.396054] pci 0000:04:00.0: reg 30: [mem 0x00000000-0x0000ffff pref]
[    0.396064] pci 0000:04:00.0: calling quirk_resource_alignment+0x0/0x166
[    0.396100] pci 0000:04:00.0: supports D1 D2
[    0.396102] pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.396107] pci 0000:04:00.0: PME# disabled
[    0.404016] pci_bus 0000:04: fixups for bus
[    0.404019] pci 0000:00:1c.4: PCI bridge to [bus 04-04]
[    0.404023] pci 0000:00:1c.4:   bridge window [io  0xc000-0xcfff]
[    0.404027] pci 0000:00:1c.4:   bridge window [mem 0xe8000000-0xe8ffffff]
[    0.404033] pci 0000:00:1c.4:   bridge window [mem 0xeb000000-0xeb0fffff 64bit pref]
[    0.404036] pci_bus 0000:04: bus scan returning with max=04
[    0.404041] pci 0000:00:1e.0: scanning [bus 05-05] behind bridge, pass 0
[    0.404061] pci_bus 0000:05: scanning bus
[    0.404075] pci 0000:05:00.0: found [10ec:8169] class 000200 header type 00
[    0.404084] pci 0000:05:00.0: calling quirk_mmio_always_on+0x0/0x17
[    0.404097] pci 0000:05:00.0: reg 10: [io  0xd000-0xd0ff]
[    0.404118] pci 0000:05:00.0: reg 14: [mem 0xea005000-0xea0050ff]
[    0.404160] pci 0000:05:00.0: reg 30: [mem 0x00000000-0x0000ffff pref]
[    0.404166] pci 0000:05:00.0: calling quirk_resource_alignment+0x0/0x166
[    0.404187] pci 0000:05:00.0: supports D1 D2
[    0.404189] pci 0000:05:00.0: PME# supported from D1 D2 D3hot D3cold
[    0.404193] pci 0000:05:00.0: PME# disabled
[    0.404217] pci 0000:05:07.0: found [104c:8024] class 000c00 header type 00
[    0.404224] pci 0000:05:07.0: calling quirk_mmio_always_on+0x0/0x17
[    0.404237] pci 0000:05:07.0: reg 10: [mem 0xea004000-0xea0047ff]
[    0.404247] pci 0000:05:07.0: reg 14: [mem 0xea000000-0xea003fff]
[    0.404290] pci 0000:05:07.0: calling quirk_resource_alignment+0x0/0x166
[    0.404306] pci 0000:05:07.0: supports D1 D2
[    0.404308] pci 0000:05:07.0: PME# supported from D0 D1 D2 D3hot
[    0.404312] pci 0000:05:07.0: PME# disabled
[    0.404346] pci_bus 0000:05: fixups for bus
[    0.404348] pci 0000:00:1e.0: PCI bridge to [bus 05-05] (subtractive decode)
[    0.404352] pci 0000:00:1e.0:   bridge window [io  0xd000-0xdfff]
[    0.404355] pci 0000:00:1e.0:   bridge window [mem 0xe9000000-0xeaffffff]
[    0.404361] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.404364] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.404366] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.404369] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.404371] pci 0000:00:1e.0:   bridge window [mem 0x000c0000-0x000dffff] (subtractive decode)
[    0.404374] pci 0000:00:1e.0:   bridge window [mem 0xcff00000-0xfebfffff] (subtractive decode)
[    0.404376] pci_bus 0000:05: bus scan returning with max=05
[    0.404380] pci 0000:00:01.0: scanning [bus 01-01] behind bridge, pass 1
[    0.404385] pci 0000:00:1c.0: scanning [bus 02-02] behind bridge, pass 1
[    0.404390] pci 0000:00:1c.3: scanning [bus 03-03] behind bridge, pass 1
[    0.404396] pci 0000:00:1c.4: scanning [bus 04-04] behind bridge, pass 1
[    0.404401] pci 0000:00:1e.0: scanning [bus 05-05] behind bridge, pass 1
[    0.404405] pci_bus 0000:00: bus scan returning with max=05
[    0.404409] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.404573] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
[    0.404624] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX3._PRT]
[    0.404682] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
[    0.404730] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
[    0.420070] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
[    0.420135] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.420198] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
[    0.420260] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
[    0.420323] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
[    0.420385] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
[    0.420447] ACPI: PCI Interrupt Link [LNK0] (IRQs *3 4 5 6 7 9 10 11 12 14 15)
[    0.420510] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
[    0.420546] HEST: Table is not found!
[    0.420546] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.420546] vgaarb: loaded
[    0.420546] usbcore: registered new interface driver usbfs
[    0.420546] usbcore: registered new interface driver hub
[    0.420546] usbcore: registered new device driver usb
[    0.420546] PCI: Using ACPI for IRQ routing
[    0.420546] PCI: pci_cache_line_size set to 64 bytes
[    0.420546] pci 0000:00:1a.0: BAR 4: reserving [io  0xe000-0xe01f flags 0x40101] (d=0, p=0)
[    0.420546] pci 0000:00:1a.1: BAR 4: reserving [io  0xe100-0xe11f flags 0x40101] (d=0, p=0)
[    0.420546] pci 0000:00:1a.2: BAR 4: reserving [io  0xe500-0xe51f flags 0x40101] (d=0, p=0)
[    0.420546] pci 0000:00:1a.7: BAR 0: reserving [mem 0xeb205000-0xeb2053ff flags 0x40200] (d=0, p=0)
[    0.420546] pci 0000:00:1b.0: BAR 0: reserving [mem 0xeb200000-0xeb203fff flags 0x140204] (d=0, p=0)
[    0.420546] pci 0000:00:1d.0: BAR 4: reserving [io  0xe200-0xe21f flags 0x40101] (d=0, p=0)
[    0.420546] pci 0000:00:1d.1: BAR 4: reserving [io  0xe300-0xe31f flags 0x40101] (d=0, p=0)
[    0.420546] pci 0000:00:1d.2: BAR 4: reserving [io  0xe400-0xe41f flags 0x40101] (d=0, p=0)
[    0.420546] pci 0000:00:1d.7: BAR 0: reserving [mem 0xeb204000-0xeb2043ff flags 0x40200] (d=0, p=0)
[    0.420546] pci 0000:00:1f.2: BAR 0: reserving [io  0x01f0-0x01f7 flags 0x110] (d=0, p=0)
[    0.420546] pci 0000:00:1f.2: BAR 1: reserving [io  0x03f6 flags 0x110] (d=0, p=0)
[    0.420546] pci 0000:00:1f.2: BAR 2: reserving [io  0x0170-0x0177 flags 0x110] (d=0, p=0)
[    0.420546] pci 0000:00:1f.2: BAR 3: reserving [io  0x0376 flags 0x110] (d=0, p=0)
[    0.420546] pci 0000:00:1f.2: BAR 4: reserving [io  0xf000-0xf00f flags 0x40101] (d=0, p=0)
[    0.420546] pci 0000:00:1f.2: BAR 5: reserving [io  0xf100-0xf10f flags 0x40101] (d=0, p=0)
[    0.420546] pci 0000:00:1f.3: BAR 0: reserving [mem 0xeb206000-0xeb2060ff flags 0x140204] (d=0, p=0)
[    0.420546] pci 0000:00:1f.3: BAR 4: reserving [io  0x0500-0x051f flags 0x40101] (d=0, p=0)
[    0.420546] pci 0000:00:1f.5: BAR 0: reserving [io  0xe700-0xe707 flags 0x40101] (d=0, p=0)
[    0.420546] pci 0000:00:1f.5: BAR 1: reserving [io  0xe800-0xe803 flags 0x40101] (d=0, p=0)
[    0.420546] pci 0000:00:1f.5: BAR 2: reserving [io  0xe900-0xe907 flags 0x40101] (d=0, p=0)
[    0.420546] pci 0000:00:1f.5: BAR 3: reserving [io  0xea00-0xea03 flags 0x40101] (d=0, p=0)
[    0.420546] pci 0000:00:1f.5: BAR 4: reserving [io  0xeb00-0xeb0f flags 0x40101] (d=0, p=0)
[    0.420546] pci 0000:00:1f.5: BAR 5: reserving [io  0xec00-0xec0f flags 0x40101] (d=0, p=0)
[    0.420546] pci 0000:01:00.0: BAR 0: reserving [mem 0xe6000000-0xe6ffffff flags 0x40200] (d=0, p=0)
[    0.420546] pci 0000:01:00.0: BAR 1: reserving [mem 0xd0000000-0xdfffffff flags 0x14220c] (d=0, p=0)
[    0.420546] pci 0000:01:00.0: BAR 3: reserving [mem 0xe4000000-0xe5ffffff flags 0x140204] (d=0, p=0)
[    0.420546] pci 0000:01:00.0: BAR 5: reserving [io  0xa000-0xa07f flags 0x40101] (d=0, p=0)
[    0.420546] pci 0000:03:00.0: BAR 5: reserving [mem 0xeb100000-0xeb101fff flags 0x40200] (d=0, p=0)
[    0.420546] pci 0000:04:00.0: BAR 0: reserving [io  0xc000-0xc0ff flags 0x40101] (d=0, p=0)
[    0.420546] pci 0000:04:00.0: BAR 2: reserving [mem 0xeb010000-0xeb010fff flags 0x14220c] (d=0, p=0)
[    0.420546] pci 0000:04:00.0: BAR 4: reserving [mem 0xeb000000-0xeb00ffff flags 0x14220c] (d=0, p=0)
[    0.420546] pci 0000:05:00.0: BAR 0: reserving [io  0xd000-0xd0ff flags 0x40101] (d=0, p=0)
[    0.420546] pci 0000:05:00.0: BAR 1: reserving [mem 0xea005000-0xea0050ff flags 0x40200] (d=0, p=0)
[    0.420546] pci 0000:05:07.0: BAR 0: reserving [mem 0xea004000-0xea0047ff flags 0x40200] (d=0, p=0)
[    0.420546] pci 0000:05:07.0: BAR 1: reserving [mem 0xea000000-0xea003fff flags 0x40200] (d=0, p=0)
[    0.420546] pci 0000:03:00.1: BAR 0: reserving [io  0xb000-0xb007 flags 0x40101] (d=1, p=1)
[    0.420546] pci 0000:03:00.1: BAR 1: reserving [io  0xb100-0xb103 flags 0x40101] (d=1, p=1)
[    0.420546] pci 0000:03:00.1: BAR 2: reserving [io  0xb200-0xb207 flags 0x40101] (d=1, p=1)
[    0.420546] pci 0000:03:00.1: BAR 3: reserving [io  0xb300-0xb303 flags 0x40101] (d=1, p=1)
[    0.420546] pci 0000:03:00.1: BAR 4: reserving [io  0xb400-0xb40f flags 0x40101] (d=1, p=1)
[    0.420546] reserve RAM buffer: 000000000009f800 - 000000000009ffff 
[    0.420546] reserve RAM buffer: 00000000cfee0000 - 00000000cfffffff 
[    0.420546] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    0.420546] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.420546] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.436079] Switching to clocksource tsc
[    0.446844] pnp: PnP ACPI init
[    0.446867] ACPI: bus type pnp registered
[    0.450198] pnp: PnP ACPI: found 16 devices
[    0.450200] ACPI: ACPI bus type pnp unregistered
[    0.450212] system 00:01: [io  0x04d0-0x04d1] has been reserved
[    0.450215] system 00:01: [io  0x0290-0x029f] has been reserved
[    0.450218] system 00:01: [io  0x0800-0x087f] has been reserved
[    0.450221] system 00:01: [io  0x0290-0x0294] has been reserved
[    0.450224] system 00:01: [io  0x0880-0x088f] has been reserved
[    0.450227] system 00:01: [io  0x04c0-0x04ff] could not be reserved
[    0.450235] system 00:0c: [io  0x0400-0x04bf] has been reserved
[    0.450242] system 00:0d: [mem 0xe0000000-0xe3ffffff] has been reserved
[    0.450248] system 00:0e: [mem 0x000ce000-0x000cffff] has been reserved
[    0.450252] system 00:0e: [mem 0x000f0000-0x000f7fff] could not be reserved
[    0.450255] system 00:0e: [mem 0x000f8000-0x000fbfff] could not be reserved
[    0.450258] system 00:0e: [mem 0x000fc000-0x000fffff] could not be reserved
[    0.450261] system 00:0e: [mem 0xcfee0000-0xcfefffff] could not be reserved
[    0.450264] system 00:0e: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.450267] system 00:0e: [mem 0x00100000-0xcfedffff] could not be reserved
[    0.450270] system 00:0e: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.450273] system 00:0e: [mem 0xfed10000-0xfed1dfff] has been reserved
[    0.450275] system 00:0e: [mem 0xfed20000-0xfed8ffff] has been reserved
[    0.450278] system 00:0e: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.450281] system 00:0e: [mem 0xffb00000-0xffb7ffff] has been reserved
[    0.450284] system 00:0e: [mem 0xfff00000-0xffffffff] has been reserved
[    0.450287] system 00:0e: [mem 0x000e0000-0x000effff] has been reserved
[    0.460404] pci 0000:00:1c.0: BAR 14: assigned [mem 0xeb300000-0xeb4fffff]
[    0.460408] pci 0000:00:1c.0: BAR 15: assigned [mem 0xeb500000-0xeb6fffff 64bit pref]
[    0.460412] pci 0000:00:1c.3: BAR 15: assigned [mem 0xeb700000-0xeb8fffff 64bit pref]
[    0.460415] pci 0000:00:1e.0: BAR 15: assigned [mem 0xcff00000-0xcfffffff pref]
[    0.460418] pci 0000:00:1c.0: BAR 13: assigned [io  0x1000-0x1fff]
[    0.460422] pci 0000:01:00.0: BAR 6: assigned [mem 0xe7000000-0xe707ffff pref]
[    0.460424] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.460427] pci 0000:00:01.0:   bridge window [io  0xa000-0xafff]
[    0.460431] pci 0000:00:01.0:   bridge window [mem 0xe4000000-0xe7ffffff]
[    0.460434] pci 0000:00:01.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.460438] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.460441] pci 0000:00:1c.0:   bridge window [io  0x1000-0x1fff]
[    0.460446] pci 0000:00:1c.0:   bridge window [mem 0xeb300000-0xeb4fffff]
[    0.460449] pci 0000:00:1c.0:   bridge window [mem 0xeb500000-0xeb6fffff 64bit pref]
[    0.460455] pci 0000:00:1c.3: PCI bridge to [bus 03-03]
[    0.460458] pci 0000:00:1c.3:   bridge window [io  0xb000-0xbfff]
[    0.460463] pci 0000:00:1c.3:   bridge window [mem 0xeb100000-0xeb1fffff]
[    0.460466] pci 0000:00:1c.3:   bridge window [mem 0xeb700000-0xeb8fffff 64bit pref]
[    0.460473] pci 0000:04:00.0: BAR 6: assigned [mem 0xeb020000-0xeb02ffff pref]
[    0.460475] pci 0000:00:1c.4: PCI bridge to [bus 04-04]
[    0.460478] pci 0000:00:1c.4:   bridge window [io  0xc000-0xcfff]
[    0.460483] pci 0000:00:1c.4:   bridge window [mem 0xe8000000-0xe8ffffff]
[    0.460487] pci 0000:00:1c.4:   bridge window [mem 0xeb000000-0xeb0fffff 64bit pref]
[    0.460493] pci 0000:05:00.0: BAR 6: assigned [mem 0xcff00000-0xcff0ffff pref]
[    0.460495] pci 0000:00:1e.0: PCI bridge to [bus 05-05]
[    0.460498] pci 0000:00:1e.0:   bridge window [io  0xd000-0xdfff]
[    0.460503] pci 0000:00:1e.0:   bridge window [mem 0xe9000000-0xeaffffff]
[    0.460506] pci 0000:00:1e.0:   bridge window [mem 0xcff00000-0xcfffffff pref]
[    0.460518]   alloc irq_desc for 16 on node -1
[    0.460521]   alloc kstat_irqs on node -1
[    0.460527] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.460531] pci 0000:00:01.0: setting latency timer to 64
[    0.460539] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.460543] pci 0000:00:1c.0: setting latency timer to 64
[    0.460555]   alloc irq_desc for 19 on node -1
[    0.460557]   alloc kstat_irqs on node -1
[    0.460561] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    0.460565] pci 0000:00:1c.3: setting latency timer to 64
[    0.460573] pci 0000:00:1c.4: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.460577] pci 0000:00:1c.4: setting latency timer to 64
[    0.460583] pci 0000:00:1e.0: setting latency timer to 64
[    0.460586] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.460589] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.460591] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.460593] pci_bus 0000:00: resource 7 [mem 0x000c0000-0x000dffff]
[    0.460595] pci_bus 0000:00: resource 8 [mem 0xcff00000-0xfebfffff]
[    0.460598] pci_bus 0000:01: resource 0 [io  0xa000-0xafff]
[    0.460600] pci_bus 0000:01: resource 1 [mem 0xe4000000-0xe7ffffff]
[    0.460602] pci_bus 0000:01: resource 2 [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.460605] pci_bus 0000:02: resource 0 [io  0x1000-0x1fff]
[    0.460607] pci_bus 0000:02: resource 1 [mem 0xeb300000-0xeb4fffff]
[    0.460609] pci_bus 0000:02: resource 2 [mem 0xeb500000-0xeb6fffff 64bit pref]
[    0.460612] pci_bus 0000:03: resource 0 [io  0xb000-0xbfff]
[    0.460614] pci_bus 0000:03: resource 1 [mem 0xeb100000-0xeb1fffff]
[    0.460616] pci_bus 0000:03: resource 2 [mem 0xeb700000-0xeb8fffff 64bit pref]
[    0.460618] pci_bus 0000:04: resource 0 [io  0xc000-0xcfff]
[    0.460621] pci_bus 0000:04: resource 1 [mem 0xe8000000-0xe8ffffff]
[    0.460623] pci_bus 0000:04: resource 2 [mem 0xeb000000-0xeb0fffff 64bit pref]
[    0.460625] pci_bus 0000:05: resource 0 [io  0xd000-0xdfff]
[    0.460627] pci_bus 0000:05: resource 1 [mem 0xe9000000-0xeaffffff]
[    0.460630] pci_bus 0000:05: resource 2 [mem 0xcff00000-0xcfffffff pref]
[    0.460632] pci_bus 0000:05: resource 4 [io  0x0000-0x0cf7]
[    0.460634] pci_bus 0000:05: resource 5 [io  0x0d00-0xffff]
[    0.460636] pci_bus 0000:05: resource 6 [mem 0x000a0000-0x000bffff]
[    0.460638] pci_bus 0000:05: resource 7 [mem 0x000c0000-0x000dffff]
[    0.460640] pci_bus 0000:05: resource 8 [mem 0xcff00000-0xfebfffff]
[    0.460752] NET: Registered protocol family 2
[    0.460946] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.462191] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.465050] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.465397] TCP: Hash tables configured (established 524288 bind 65536)
[    0.465400] TCP reno registered
[    0.465411] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.465443] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.465654] NET: Registered protocol family 1
[    0.465678] pci 0000:00:00.0: calling quirk_e100_interrupt+0x0/0x145
[    0.465683] pci 0000:00:00.0: calling quirk_cardbus_legacy+0x0/0x22
[    0.465687] pci 0000:00:00.0: calling quirk_usb_early_handoff+0x0/0x4e9
[    0.465690] pci 0000:00:00.0: calling pci_fixup_video+0x0/0xad
[    0.465697] pci 0000:00:01.0: calling quirk_e100_interrupt+0x0/0x145
[    0.465700] pci 0000:00:01.0: calling quirk_cardbus_legacy+0x0/0x22
[    0.465703] pci 0000:00:01.0: calling quirk_usb_early_handoff+0x0/0x4e9
[    0.465706] pci 0000:00:01.0: calling pci_fixup_video+0x0/0xad
[    0.465711] pci 0000:00:1a.0: calling quirk_e100_interrupt+0x0/0x145
[    0.465714] pci 0000:00:1a.0: calling quirk_cardbus_legacy+0x0/0x22
[    0.465717] pci 0000:00:1a.0: calling quirk_usb_early_handoff+0x0/0x4e9
[    0.465722] pci 0000:00:1a.0: uhci_check_and_reset_hc: legsup = 0x0f10
[    0.465723] pci 0000:00:1a.0: Performing full reset
[    0.465736] pci 0000:00:1a.0: calling pci_fixup_video+0x0/0xad
[    0.465741] pci 0000:00:1a.1: calling quirk_e100_interrupt+0x0/0x145
[    0.465744] pci 0000:00:1a.1: calling quirk_cardbus_legacy+0x0/0x22
[    0.465747] pci 0000:00:1a.1: calling quirk_usb_early_handoff+0x0/0x4e9
[    0.465751] pci 0000:00:1a.1: uhci_check_and_reset_hc: legsup = 0x0010
[    0.465753] pci 0000:00:1a.1: Performing full reset
[    0.465765] pci 0000:00:1a.1: calling pci_fixup_video+0x0/0xad
[    0.465770] pci 0000:00:1a.2: calling quirk_e100_interrupt+0x0/0x145
[    0.465773] pci 0000:00:1a.2: calling quirk_cardbus_legacy+0x0/0x22
[    0.465776] pci 0000:00:1a.2: calling quirk_usb_early_handoff+0x0/0x4e9
[    0.465780] pci 0000:00:1a.2: uhci_check_and_reset_hc: legsup = 0x0010
[    0.465782] pci 0000:00:1a.2: Performing full reset
[    0.465794] pci 0000:00:1a.2: calling pci_fixup_video+0x0/0xad
[    0.465799] pci 0000:00:1a.7: calling quirk_e100_interrupt+0x0/0x145
[    0.465802] pci 0000:00:1a.7: calling quirk_cardbus_legacy+0x0/0x22
[    0.465805] pci 0000:00:1a.7: calling quirk_usb_early_handoff+0x0/0x4e9
[    0.465832] pci 0000:00:1a.7: calling pci_fixup_video+0x0/0xad
[    0.465837] pci 0000:00:1b.0: calling quirk_e100_interrupt+0x0/0x145
[    0.465841] pci 0000:00:1b.0: calling quirk_cardbus_legacy+0x0/0x22
[    0.465844] pci 0000:00:1b.0: calling quirk_usb_early_handoff+0x0/0x4e9
[    0.465847] pci 0000:00:1b.0: calling pci_fixup_video+0x0/0xad
[    0.465852] pci 0000:00:1c.0: calling quirk_e100_interrupt+0x0/0x145
[    0.465855] pci 0000:00:1c.0: calling quirk_cardbus_legacy+0x0/0x22
[    0.465858] pci 0000:00:1c.0: calling quirk_usb_early_handoff+0x0/0x4e9
[    0.465861] pci 0000:00:1c.0: calling pci_fixup_video+0x0/0xad
[    0.465866] pci 0000:00:1c.3: calling quirk_e100_interrupt+0x0/0x145
[    0.465869] pci 0000:00:1c.3: calling quirk_cardbus_legacy+0x0/0x22
[    0.465872] pci 0000:00:1c.3: calling quirk_usb_early_handoff+0x0/0x4e9
[    0.465875] pci 0000:00:1c.3: calling pci_fixup_video+0x0/0xad
[    0.465880] pci 0000:00:1c.4: calling quirk_e100_interrupt+0x0/0x145
[    0.465883] pci 0000:00:1c.4: calling quirk_cardbus_legacy+0x0/0x22
[    0.465886] pci 0000:00:1c.4: calling quirk_usb_early_handoff+0x0/0x4e9
[    0.465889] pci 0000:00:1c.4: calling pci_fixup_video+0x0/0xad
[    0.465893] pci 0000:00:1d.0: calling quirk_e100_interrupt+0x0/0x145
[    0.465897] pci 0000:00:1d.0: calling quirk_cardbus_legacy+0x0/0x22
[    0.465900] pci 0000:00:1d.0: calling quirk_usb_early_handoff+0x0/0x4e9
[    0.465904] pci 0000:00:1d.0: uhci_check_and_reset_hc: legsup = 0x043a
[    0.465906] pci 0000:00:1d.0: Performing full reset
[    0.465917] pci 0000:00:1d.0: calling pci_fixup_video+0x0/0xad
[    0.465922] pci 0000:00:1d.1: calling quirk_e100_interrupt+0x0/0x145
[    0.465925] pci 0000:00:1d.1: calling quirk_cardbus_legacy+0x0/0x22
[    0.465928] pci 0000:00:1d.1: calling quirk_usb_early_handoff+0x0/0x4e9
[    0.465933] pci 0000:00:1d.1: uhci_check_and_reset_hc: legsup = 0x0010
[    0.465934] pci 0000:00:1d.1: Performing full reset
[    0.465946] pci 0000:00:1d.1: calling pci_fixup_video+0x0/0xad
[    0.465951] pci 0000:00:1d.2: calling quirk_e100_interrupt+0x0/0x145
[    0.465954] pci 0000:00:1d.2: calling quirk_cardbus_legacy+0x0/0x22
[    0.465957] pci 0000:00:1d.2: calling quirk_usb_early_handoff+0x0/0x4e9
[    0.465961] pci 0000:00:1d.2: uhci_check_and_reset_hc: legsup = 0x0010
[    0.465963] pci 0000:00:1d.2: Performing full reset
[    0.465975] pci 0000:00:1d.2: calling pci_fixup_video+0x0/0xad
[    0.465980] pci 0000:00:1d.7: calling quirk_e100_interrupt+0x0/0x145
[    0.465983] pci 0000:00:1d.7: calling quirk_cardbus_legacy+0x0/0x22
[    0.465986] pci 0000:00:1d.7: calling quirk_usb_early_handoff+0x0/0x4e9
[    0.466017] pci 0000:00:1d.7: calling pci_fixup_video+0x0/0xad
[    0.466022] pci 0000:00:1e.0: calling quirk_e100_interrupt+0x0/0x145
[    0.466026] pci 0000:00:1e.0: calling quirk_cardbus_legacy+0x0/0x22
[    0.466029] pci 0000:00:1e.0: calling quirk_usb_early_handoff+0x0/0x4e9
[    0.466032] pci 0000:00:1e.0: calling pci_fixup_video+0x0/0xad
[    0.466037] pci 0000:00:1f.0: calling quirk_e100_interrupt+0x0/0x145
[    0.466040] pci 0000:00:1f.0: calling quirk_cardbus_legacy+0x0/0x22
[    0.466043] pci 0000:00:1f.0: calling quirk_usb_early_handoff+0x0/0x4e9
[    0.466046] pci 0000:00:1f.0: calling pci_fixup_video+0x0/0xad
[    0.466051] pci 0000:00:1f.2: calling quirk_e100_interrupt+0x0/0x145
[    0.466054] pci 0000:00:1f.2: calling quirk_cardbus_legacy+0x0/0x22
[    0.466057] pci 0000:00:1f.2: calling quirk_usb_early_handoff+0x0/0x4e9
[    0.466060] pci 0000:00:1f.2: calling pci_fixup_video+0x0/0xad
[    0.466065] pci 0000:00:1f.3: calling quirk_e100_interrupt+0x0/0x145
[    0.466068] pci 0000:00:1f.3: calling quirk_cardbus_legacy+0x0/0x22
[    0.466071] pci 0000:00:1f.3: calling quirk_usb_early_handoff+0x0/0x4e9
[    0.466074] pci 0000:00:1f.3: calling pci_fixup_video+0x0/0xad
[    0.466079] pci 0000:00:1f.5: calling quirk_e100_interrupt+0x0/0x145
[    0.466082] pci 0000:00:1f.5: calling quirk_cardbus_legacy+0x0/0x22
[    0.466085] pci 0000:00:1f.5: calling quirk_usb_early_handoff+0x0/0x4e9
[    0.466088] pci 0000:00:1f.5: calling pci_fixup_video+0x0/0xad
[    0.466093] pci 0000:01:00.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0xd
[    0.466105] pci 0000:01:00.0: calling quirk_cardbus_legacy+0x0/0x22
[    0.466108] pci 0000:01:00.0: calling quirk_usb_early_handoff+0x0/0x4e9
[    0.466111] pci 0000:01:00.0: calling pci_fixup_video+0x0/0xad
[    0.466114] pci 0000:01:00.0: Boot video device
[    0.466119] pci 0000:03:00.0: calling quirk_cardbus_legacy+0x0/0x22
[    0.466122] pci 0000:03:00.0: calling quirk_usb_early_handoff+0x0/0x4e9
[    0.466125] pci 0000:03:00.0: calling pci_fixup_video+0x0/0xad
[    0.466131] pci 0000:03:00.1: calling quirk_cardbus_legacy+0x0/0x22
[    0.466134] pci 0000:03:00.1: calling quirk_usb_early_handoff+0x0/0x4e9
[    0.466137] pci 0000:03:00.1: calling pci_fixup_video+0x0/0xad
[    0.466142] pci 0000:04:00.0: calling quirk_cardbus_legacy+0x0/0x22
[    0.466145] pci 0000:04:00.0: calling quirk_usb_early_handoff+0x0/0x4e9
[    0.466148] pci 0000:04:00.0: calling pci_fixup_video+0x0/0xad
[    0.466154] pci 0000:05:00.0: calling quirk_cardbus_legacy+0x0/0x22
[    0.466157] pci 0000:05:00.0: calling quirk_usb_early_handoff+0x0/0x4e9
[    0.466160] pci 0000:05:00.0: calling pci_fixup_video+0x0/0xad
[    0.466165] pci 0000:05:07.0: calling quirk_cardbus_legacy+0x0/0x22
[    0.466168] pci 0000:05:07.0: calling quirk_usb_early_handoff+0x0/0x4e9
[    0.466171] pci 0000:05:07.0: calling pci_fixup_video+0x0/0xad
[    0.466174] PCI: CLS 32 bytes, default 64
[    0.466230] Trying to unpack rootfs image as initramfs...
[    0.699732] Freeing initrd memory: 10448k freed
[    0.710628] DMA-API: preallocated 32768 debug entries
[    0.710631] DMA-API: debugging enabled by kernel config
[    0.710635] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.710638] Placing 64MB software IO TLB between ffff880001b9a000 - ffff880005b9a000
[    0.710640] software IO TLB at phys 0x1b9a000 - 0x5b9a000
[    0.712472] Scanning for low memory corruption every 60 seconds
[    0.712922] audit: initializing netlink socket (disabled)
[    0.712936] type=2000 audit(1283519483.708:1): initialized
[    0.713350] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.713754] VFS: Disk quotas dquot_6.5.2
[    0.713801] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.713889] msgmni has been set to 7926
[    0.714377] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.714380] io scheduler noop registered
[    0.714382] io scheduler deadline registered
[    0.714419] io scheduler cfq registered (default)
[    0.715425] vesafb: framebuffer at 0xe5000000, mapped to 0xffffc90005100000, using 1536k, total 1536k
[    0.715428] vesafb: mode is 1024x768x16, linelength=2048, pages=0
[    0.715430] vesafb: scrolling: redraw
[    0.715432] vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
[    0.726483] Console: switching to colour frame buffer device 128x48
[    0.736579] fb0: VESA VGA frame buffer device
[    0.736641] intel_idle: MWAIT substates: 0x20
[    0.736643] intel_idle: does not run on family 6 model 23
[    0.736746] ERST: Table is not found!
[    0.778767] Linux agpgart interface v0.103
[    0.778905] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.799289] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.820322] 00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.823254] brd: module loaded
[    0.823570] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    0.823997] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.824006] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.824309] mice: PS/2 mouse device common for all mice
[    0.824412] rtc_cmos 00:04: RTC can wake from S4
[    0.824501] rtc_cmos: dev (254:0)
[    0.824513] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
[    0.824536] rtc0: alarms up to one month, 242 bytes nvram, hpet irqs
[    0.824591] cpuidle: using governor ladder
[    0.824597] cpuidle: using governor menu
[    0.824901] TCP cubic registered
[    0.824904] NET: Registered protocol family 17
[    0.824909] Registering the dns_resolver key type
[    0.847909] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    0.851953] registered taskstats version 1
[    0.851956] IMA: No TPM chip found, activating TPM-bypass!
[    0.852360] rtc_cmos 00:04: setting system clock to 2010-09-03 13:11:24 UTC (1283519484)
[    0.852453] Freeing unused kernel memory: 540k freed
[    0.852567] Write protecting the kernel read-only data: 6144k
[    0.852772] Freeing unused kernel memory: 916k freed
[    0.853033] Freeing unused kernel memory: 348k freed
[    0.867562] udev: starting version 161
[    0.867614] udevd (1039): /proc/1039/oom_adj is deprecated, please use /proc/1039/oom_score_adj instead.
[    0.900780] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.900787] ehci_hcd: block sizes: qh 104 qtd 96 itd 192 sitd 96
[    0.900834]   alloc irq_desc for 18 on node -1
[    0.900840]   alloc kstat_irqs on node -1
[    0.900852] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.900892] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    0.900897] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    0.900919] drivers/usb/core/inode.c: creating file 'devices'
[    0.900928] drivers/usb/core/inode.c: creating file '001'
[    0.901086] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    0.901097] ehci_hcd 0000:00:1a.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[    0.901104] ehci_hcd 0000:00:1a.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr hw prefetch
[    0.901158] ehci_hcd 0000:00:1a.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    0.922268] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
[    0.922273] ehci_hcd 0000:00:1a.7: supports USB remote wakeup
[    0.922302] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xeb205000
[    0.922307] ehci_hcd 0000:00:1a.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    0.926192] ehci_hcd 0000:00:1a.7: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
[    0.944114] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    0.944160] usb usb1: default language 0x0409
[    0.944168] usb usb1: udev 1, busnum 1, minor = 0
[    0.944172] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    0.944176] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.944181] usb usb1: Product: EHCI Host Controller
[    0.944184] usb usb1: Manufacturer: Linux 2.6.36-rc3-next-20100903 ehci_hcd
[    0.944188] usb usb1: SerialNumber: 0000:00:1a.7
[    0.944392] usb usb1: usb_probe_device
[    0.944397] usb usb1: configuration #1 chosen from 1 choice
[    0.944409] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    0.944435] hub 1-0:1.0: usb_probe_interface
[    0.944438] hub 1-0:1.0: usb_probe_interface - got id
[    0.944442] hub 1-0:1.0: USB hub found
[    0.944447] hub 1-0:1.0: 6 ports detected
[    0.944449] hub 1-0:1.0: standalone hub
[    0.944451] hub 1-0:1.0: no power switching (usb 1.0)
[    0.944453] hub 1-0:1.0: individual port over-current protection
[    0.944456] hub 1-0:1.0: power on to power good time: 20ms
[    0.944464] hub 1-0:1.0: local power source is good
[    0.944469] hub 1-0:1.0: trying to enable port power on non-switchable hub
[    0.944529] drivers/usb/core/inode.c: creating file '001'
[    0.944601]   alloc irq_desc for 23 on node -1
[    0.944607]   alloc kstat_irqs on node -1
[    0.944615] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    0.944657] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    0.944661] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    0.944667] drivers/usb/core/inode.c: creating file '002'
[    0.944741] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    0.944751] ehci_hcd 0000:00:1d.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[    0.944757] ehci_hcd 0000:00:1d.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr hw prefetch
[    0.944813] ehci_hcd 0000:00:1d.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    0.958270] Uniform Multi-Platform E-IDE driver
[    0.962829] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    0.962833] ehci_hcd 0000:00:1d.7: supports USB remote wakeup
[    0.962858] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xeb204000
[    0.962864] ehci_hcd 0000:00:1d.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    0.964964] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    0.964986] r8169 0000:04:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.964994] r8169 0000:04:00.0: enabling Mem-Wr-Inval
[    0.965049] r8169 0000:04:00.0: setting latency timer to 64
[    0.965100]   alloc irq_desc for 40 on node -1
[    0.965105]   alloc kstat_irqs on node -1
[    0.965121] r8169 0000:04:00.0: irq 40 for MSI/MSI-X
[    0.965394] r8169 0000:04:00.0: eth0: RTL8168c/8111c at 0xffffc9000066a000, 00:1f:d0:9a:d6:63, XID 1c4000c0 IRQ 40
[    0.966748] ehci_hcd 0000:00:1d.7: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
[    0.968680] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    0.968695]   alloc irq_desc for 20 on node -1
[    0.968698]   alloc kstat_irqs on node -1
[    0.968703] r8169 0000:05:00.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    0.968710] r8169 0000:05:00.0: enabling Mem-Wr-Inval
[    0.968727] r8169 0000:05:00.0: (unregistered net_device): no PCI Express capability
[    0.968986] r8169 0000:05:00.0: eth1: RTL8169sb/8110sb at 0xffffc90000664000, 00:1f:1f:07:b0:bf, XID 10000000 IRQ 20
[    0.976206] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    0.976358] usb usb2: default language 0x0409
[    0.976366] usb usb2: udev 1, busnum 2, minor = 128
[    0.976369] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    0.976372] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.976376] usb usb2: Product: EHCI Host Controller
[    0.976380] usb usb2: Manufacturer: Linux 2.6.36-rc3-next-20100903 ehci_hcd
[    0.976384] usb usb2: SerialNumber: 0000:00:1d.7
[    0.976555] usb usb2: usb_probe_device
[    0.976559] usb usb2: configuration #1 chosen from 1 choice
[    0.976570] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[    0.976600] hub 2-0:1.0: usb_probe_interface
[    0.976603] hub 2-0:1.0: usb_probe_interface - got id
[    0.976606] hub 2-0:1.0: USB hub found
[    0.976611] hub 2-0:1.0: 6 ports detected
[    0.976614] hub 2-0:1.0: standalone hub
[    0.976616] hub 2-0:1.0: no power switching (usb 1.0)
[    0.976618] hub 2-0:1.0: individual port over-current protection
[    0.976621] hub 2-0:1.0: power on to power good time: 20ms
[    0.976627] hub 2-0:1.0: local power source is good
[    0.976631] hub 2-0:1.0: trying to enable port power on non-switchable hub
[    0.976691] drivers/usb/core/inode.c: creating file '001'
[    0.980391] Floppy drive(s): fd0 is 1.44M
[    0.997266] jmicron 0000:03:00.1: IDE controller (0x197b:0x2363 rev 0x02)
[    0.997284] JMicron IDE 0000:03:00.1: enabling device (0000 -> 0001)
[    0.997292] JMicron IDE 0000:03:00.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.997313] jmicron 0000:03:00.1: 100% native mode on irq 16
[    0.997323] JMicron IDE 0000:03:00.1: enabling bus mastering
[    0.997329] JMicron IDE 0000:03:00.1: setting latency timer to 64
[    0.997334]     ide0: BM-DMA at 0xb400-0xb407
[    0.997358]     ide1: BM-DMA at 0xb408-0xb40f
[    0.997374] Probing IDE interface ide0...
[    0.997857] ohci1394 0000:05:07.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    0.999628] FDC 0 is a post-1991 82077
[    1.007068] SCSI subsystem initialized
[    1.007419] uhci_hcd: USB Universal Host Controller Interface driver
[    1.007479] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.007490] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    1.007494] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    1.007505] drivers/usb/core/inode.c: creating file '003'
[    1.007635] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    1.007645] uhci_hcd 0000:00:1a.0: detected 2 ports
[    1.007649] uhci_hcd 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x0000
[    1.007653] uhci_hcd 0000:00:1a.0: Performing full reset
[    1.007666] uhci_hcd 0000:00:1a.0: supports USB remote wakeup
[    1.007687] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000e000
[    1.007754] usb usb3: default language 0x0409
[    1.007761] usb usb3: udev 1, busnum 3, minor = 256
[    1.007764] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    1.007771] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.007776] usb usb3: Product: UHCI Host Controller
[    1.007779] usb usb3: Manufacturer: Linux 2.6.36-rc3-next-20100903 uhci_hcd
[    1.007783] usb usb3: SerialNumber: 0000:00:1a.0
[    1.007870] usb usb3: usb_probe_device
[    1.007873] usb usb3: configuration #1 chosen from 1 choice
[    1.007880] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[    1.007905] hub 3-0:1.0: usb_probe_interface
[    1.007908] hub 3-0:1.0: usb_probe_interface - got id
[    1.007913] hub 3-0:1.0: USB hub found
[    1.007918] hub 3-0:1.0: 2 ports detected
[    1.007921] hub 3-0:1.0: standalone hub
[    1.007923] hub 3-0:1.0: no power switching (usb 1.0)
[    1.007925] hub 3-0:1.0: individual port over-current protection
[    1.007928] hub 3-0:1.0: power on to power good time: 2ms
[    1.007933] hub 3-0:1.0: local power source is good
[    1.007936] hub 3-0:1.0: trying to enable port power on non-switchable hub
[    1.007985] drivers/usb/core/inode.c: creating file '001'
[    1.008039] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.0
[    1.008071]   alloc irq_desc for 21 on node -1
[    1.008076]   alloc kstat_irqs on node -1
[    1.008085] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    1.008094] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    1.008100] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    1.008108] drivers/usb/core/inode.c: creating file '004'
[    1.008169] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    1.008177] uhci_hcd 0000:00:1a.1: detected 2 ports
[    1.008182] uhci_hcd 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x0000
[    1.008185] uhci_hcd 0000:00:1a.1: Performing full reset
[    1.008198] uhci_hcd 0000:00:1a.1: supports USB remote wakeup
[    1.008216] uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000e100
[    1.008270] usb usb4: default language 0x0409
[    1.008277] usb usb4: udev 1, busnum 4, minor = 384
[    1.008280] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    1.008282] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.008286] usb usb4: Product: UHCI Host Controller
[    1.008290] usb usb4: Manufacturer: Linux 2.6.36-rc3-next-20100903 uhci_hcd
[    1.008292] usb usb4: SerialNumber: 0000:00:1a.1
[    1.008402] usb usb4: usb_probe_device
[    1.008405] usb usb4: configuration #1 chosen from 1 choice
[    1.008413] usb usb4: adding 4-0:1.0 (config #1, interface 0)
[    1.008448] hub 4-0:1.0: usb_probe_interface
[    1.008450] hub 4-0:1.0: usb_probe_interface - got id
[    1.008453] hub 4-0:1.0: USB hub found
[    1.008459] hub 4-0:1.0: 2 ports detected
[    1.008462] hub 4-0:1.0: standalone hub
[    1.008464] hub 4-0:1.0: no power switching (usb 1.0)
[    1.008466] hub 4-0:1.0: individual port over-current protection
[    1.008468] hub 4-0:1.0: power on to power good time: 2ms
[    1.008473] hub 4-0:1.0: local power source is good
[    1.008475] hub 4-0:1.0: trying to enable port power on non-switchable hub
[    1.008522] drivers/usb/core/inode.c: creating file '001'
[    1.008552] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.1
[    1.008578] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    1.008584] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    1.008591] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    1.008596] drivers/usb/core/inode.c: creating file '005'
[    1.008671] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
[    1.008681] uhci_hcd 0000:00:1a.2: detected 2 ports
[    1.008685] uhci_hcd 0000:00:1a.2: uhci_check_and_reset_hc: cmd = 0x0000
[    1.008689] uhci_hcd 0000:00:1a.2: Performing full reset
[    1.008702] uhci_hcd 0000:00:1a.2: supports USB remote wakeup
[    1.008709] uhci_hcd 0000:00:1a.2: irq 18, io base 0x0000e500
[    1.008760] usb usb5: default language 0x0409
[    1.008768] usb usb5: udev 1, busnum 5, minor = 512
[    1.008770] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    1.008773] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.008775] usb usb5: Product: UHCI Host Controller
[    1.008777] usb usb5: Manufacturer: Linux 2.6.36-rc3-next-20100903 uhci_hcd
[    1.008779] usb usb5: SerialNumber: 0000:00:1a.2
[    1.008852] usb usb5: usb_probe_device
[    1.008854] usb usb5: configuration #1 chosen from 1 choice
[    1.008860] usb usb5: adding 5-0:1.0 (config #1, interface 0)
[    1.008898] hub 5-0:1.0: usb_probe_interface
[    1.008900] hub 5-0:1.0: usb_probe_interface - got id
[    1.008903] hub 5-0:1.0: USB hub found
[    1.008910] hub 5-0:1.0: 2 ports detected
[    1.008913] hub 5-0:1.0: standalone hub
[    1.008916] hub 5-0:1.0: no power switching (usb 1.0)
[    1.008920] hub 5-0:1.0: individual port over-current protection
[    1.008923] hub 5-0:1.0: power on to power good time: 2ms
[    1.008929] hub 5-0:1.0: local power source is good
[    1.008934] hub 5-0:1.0: trying to enable port power on non-switchable hub
[    1.008979] drivers/usb/core/inode.c: creating file '001'
[    1.009021] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.2
[    1.009049] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    1.009055] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    1.009058] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    1.009063] drivers/usb/core/inode.c: creating file '006'
[    1.009108] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
[    1.009115] uhci_hcd 0000:00:1d.0: detected 2 ports
[    1.009119] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
[    1.009122] uhci_hcd 0000:00:1d.0: Performing full reset
[    1.009135] uhci_hcd 0000:00:1d.0: supports USB remote wakeup
[    1.009143] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000e200
[    1.009196] usb usb6: default language 0x0409
[    1.009205] usb usb6: udev 1, busnum 6, minor = 640
[    1.009208] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    1.009212] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.009214] usb usb6: Product: UHCI Host Controller
[    1.009216] usb usb6: Manufacturer: Linux 2.6.36-rc3-next-20100903 uhci_hcd
[    1.009218] usb usb6: SerialNumber: 0000:00:1d.0
[    1.009298] usb usb6: usb_probe_device
[    1.009300] usb usb6: configuration #1 chosen from 1 choice
[    1.009307] usb usb6: adding 6-0:1.0 (config #1, interface 0)
[    1.009335] hub 6-0:1.0: usb_probe_interface
[    1.009338] hub 6-0:1.0: usb_probe_interface - got id
[    1.009341] hub 6-0:1.0: USB hub found
[    1.009345] hub 6-0:1.0: 2 ports detected
[    1.009347] hub 6-0:1.0: standalone hub
[    1.009349] hub 6-0:1.0: no power switching (usb 1.0)
[    1.009352] hub 6-0:1.0: individual port over-current protection
[    1.009355] hub 6-0:1.0: power on to power good time: 2ms
[    1.009360] hub 6-0:1.0: local power source is good
[    1.009363] hub 6-0:1.0: trying to enable port power on non-switchable hub
[    1.009442] drivers/usb/core/inode.c: creating file '001'
[    1.009492] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.0
[    1.009513] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    1.009521] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    1.009525] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    1.009531] drivers/usb/core/inode.c: creating file '007'
[    1.009585] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
[    1.009592] uhci_hcd 0000:00:1d.1: detected 2 ports
[    1.009596] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
[    1.009599] uhci_hcd 0000:00:1d.1: Performing full reset
[    1.009612] uhci_hcd 0000:00:1d.1: supports USB remote wakeup
[    1.009628] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000e300
[    1.009677] usb usb7: default language 0x0409
[    1.009685] usb usb7: udev 1, busnum 7, minor = 768
[    1.009689] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    1.009691] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.009696] usb usb7: Product: UHCI Host Controller
[    1.009698] usb usb7: Manufacturer: Linux 2.6.36-rc3-next-20100903 uhci_hcd
[    1.009701] usb usb7: SerialNumber: 0000:00:1d.1
[    1.009812] usb usb7: usb_probe_device
[    1.009816] usb usb7: configuration #1 chosen from 1 choice
[    1.009823] usb usb7: adding 7-0:1.0 (config #1, interface 0)
[    1.009854] hub 7-0:1.0: usb_probe_interface
[    1.009856] hub 7-0:1.0: usb_probe_interface - got id
[    1.009860] hub 7-0:1.0: USB hub found
[    1.009864] hub 7-0:1.0: 2 ports detected
[    1.009866] hub 7-0:1.0: standalone hub
[    1.009869] hub 7-0:1.0: no power switching (usb 1.0)
[    1.009871] hub 7-0:1.0: individual port over-current protection
[    1.009873] hub 7-0:1.0: power on to power good time: 2ms
[    1.009878] hub 7-0:1.0: local power source is good
[    1.009881] hub 7-0:1.0: trying to enable port power on non-switchable hub
[    1.009926] drivers/usb/core/inode.c: creating file '001'
[    1.009962] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.1
[    1.009982] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    1.009988] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    1.009994] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    1.009999] drivers/usb/core/inode.c: creating file '008'
[    1.010079] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
[    1.010088] uhci_hcd 0000:00:1d.2: detected 2 ports
[    1.010093] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
[    1.010095] uhci_hcd 0000:00:1d.2: Performing full reset
[    1.010109] uhci_hcd 0000:00:1d.2: supports USB remote wakeup
[    1.010116] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000e400
[    1.010167] usb usb8: default language 0x0409
[    1.010174] usb usb8: udev 1, busnum 8, minor = 896
[    1.010177] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
[    1.010180] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.010182] usb usb8: Product: UHCI Host Controller
[    1.010184] usb usb8: Manufacturer: Linux 2.6.36-rc3-next-20100903 uhci_hcd
[    1.010186] usb usb8: SerialNumber: 0000:00:1d.2
[    1.010268] usb usb8: usb_probe_device
[    1.010271] usb usb8: configuration #1 chosen from 1 choice
[    1.010278] usb usb8: adding 8-0:1.0 (config #1, interface 0)
[    1.010317] hub 8-0:1.0: usb_probe_interface
[    1.010321] hub 8-0:1.0: usb_probe_interface - got id
[    1.010325] hub 8-0:1.0: USB hub found
[    1.010332] hub 8-0:1.0: 2 ports detected
[    1.010336] hub 8-0:1.0: standalone hub
[    1.010339] hub 8-0:1.0: no power switching (usb 1.0)
[    1.010343] hub 8-0:1.0: individual port over-current protection
[    1.010347] hub 8-0:1.0: power on to power good time: 2ms
[    1.010351] hub 8-0:1.0: local power source is good
[    1.010353] hub 8-0:1.0: trying to enable port power on non-switchable hub
[    1.010392] drivers/usb/core/inode.c: creating file '001'
[    1.010427] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.2
[    1.024896] libata version 3.00 loaded.
[    1.044098] hub 1-0:1.0: state 7 ports 6 chg 0000 evt 0000
[    1.044117] hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0000
[    1.044144] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[23]  MMIO=[ea004000-ea0047ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
[    1.076034] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    1.076045] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    1.076061] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    1.076067] hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    1.076072] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    1.076085] hub 8-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    1.098806] ata_piix 0000:00:1f.2: version 2.13
[    1.098826] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    1.098831] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
[    1.098892] ata_piix 0000:00:1f.2: setting latency timer to 64
[    1.099210] scsi0 : ata_piix
[    1.099355] scsi1 : ata_piix
[    1.099994] ata1: SATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xf000 irq 14+
[    1.100007] ata2: SATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xf008 irq 15+
[    1.100050] ata_piix 0000:00:1f.5: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    1.100056] ata_piix 0000:00:1f.5: MAP [ P0 -- P1 -- ]
[    1.100101] ata_piix 0000:00:1f.5: setting latency timer to 64
[    1.100330] scsi2 : ata_piix
[    1.100417] scsi3 : ata_piix
[    1.100889] ata3: SATA max UDMA/133 cmd 0xe700 ctl 0xe800 bmdma 0xeb00 irq 19+
[    1.100893] ata4: SATA max UDMA/133 cmd 0xe900 ctl 0xea00 bmdma 0xeb08 irq 19+
[    1.430594] ata3: SATA link down (SStatus 0 SControl 300)
[    1.441164] ata4: SATA link down (SStatus 0 SControl 300)
[    1.552009] ------------[ cut here ]------------
[    1.552016] WARNING: at kernel/irq/manage.c:290 __enable_irq+0x40/0x67()
[    1.552018] Hardware name: EP45-UD3
[    1.552020] Unbalanced enable for IRQ 16
[    1.552022] Modules linked in: ata_generic(+) ata_piix ahci(+) libahci libata uhci_hcd ohci1394 jmicron(+) scsi_mod floppy ieee1394 r8169 mii ide_pci_generic ide_core thermal thermal_sys ehci_hcd
[    1.552039] Pid: 1155, comm: modprobe Not tainted 2.6.36-rc3-next-20100903 #1
[    1.552042] Call Trace:
[    1.552048]  [<ffffffff81040782>] warn_slowpath_common+0x80/0x98
[    1.552052]  [<ffffffff8104082e>] warn_slowpath_fmt+0x41/0x43
[    1.552055]  [<ffffffff8108de26>] __enable_irq+0x40/0x67
[    1.552059]  [<ffffffff8108de8f>] enable_irq+0x42/0x61
[    1.552068]  [<ffffffffa0096b64>] ide_probe_port+0x575/0x5a3 [ide_core]
[    1.552077]  [<ffffffffa00971d1>] ide_host_register+0x2ad/0x66c [ide_core]
[    1.552086]  [<ffffffffa009b9fa>] ide_pci_init_two+0x58d/0x666 [ide_core]
[    1.552093]  [<ffffffff8119b47c>] ? ida_get_new_above+0xfa/0x1b5
[    1.552101]  [<ffffffff810374b3>] ? get_parent_ip+0x11/0x42
[    1.552105]  [<ffffffff81146591>] ? sysfs_find_dirent+0x3a/0x53
[    1.552108]  [<ffffffff810374b3>] ? get_parent_ip+0x11/0x42
[    1.552111]  [<ffffffff810374b3>] ? get_parent_ip+0x11/0x42
[    1.552118]  [<ffffffffa009bae4>] ide_pci_init_one+0x11/0x13 [ide_core]
[    1.552123]  [<ffffffffa019f0ec>] jmicron_init_one+0x12/0x14 [jmicron]
[    1.552127]  [<ffffffff811ba1b1>] local_pci_probe+0x48/0x91
[    1.552130]  [<ffffffff811bafca>] pci_device_probe+0xc5/0xf5
[    1.552135]  [<ffffffff81240651>] ? driver_sysfs_add+0x6b/0x90
[    1.552138]  [<ffffffff8124087b>] driver_probe_device+0x139/0x257
[    1.552141]  [<ffffffff812409f1>] __driver_attach+0x58/0x7c
[    1.552144]  [<ffffffff81240999>] ? __driver_attach+0x0/0x7c
[    1.552147]  [<ffffffff8123fcdf>] bus_for_each_dev+0x4e/0x83
[    1.552151]  [<ffffffff81240596>] driver_attach+0x19/0x1b
[    1.552153]  [<ffffffff812401e6>] bus_add_driver+0xd0/0x236
[    1.552157]  [<ffffffff81240ccd>] driver_register+0x99/0x10a
[    1.552160]  [<ffffffff811bb228>] __pci_register_driver+0x53/0xc3
[    1.552164]  [<ffffffffa01a2000>] ? jmicron_ide_init+0x0/0x20 [jmicron]
[    1.552168]  [<ffffffffa01a201e>] jmicron_ide_init+0x1e/0x20 [jmicron]
[    1.552172]  [<ffffffff81000210>] do_one_initcall+0x7a/0x134
[    1.552176]  [<ffffffff81071d33>] sys_init_module+0x9c/0x1dd
[    1.552179]  [<ffffffff81002b42>] system_call_fastpath+0x16/0x1b
[    1.552182] ---[ end trace 196a652b1ce7a255 ]---
[    1.552219] Probing IDE interface ide1...
[    1.908057] ata1.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.908069] ata1.01: SATA link down (SStatus 0 SControl 300)
[    1.908215] ata2.00: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.908228] ata2.01: SATA link down (SStatus 0 SControl 300)
[    1.908237] ata2.01: link offline, clearing class 3 to NONE
[    1.916120] ata2.00: ATAPI: ATAPI   iHAS222   8, 4L01, max UDMA/100
[    1.917095] ata1.00: HPA detected: current 1953523055, native 1953525168
[    1.917100] ata1.00: ATA-8: WDC WD1002FBYS-01A6B0, 03.00C05, max UDMA/133
[    1.917103] ata1.00: 1953523055 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    1.932192] ata2.00: configured for UDMA/100
[    1.933116] ata1.00: configured for UDMA/133
[    1.933257] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1002FBYS-0 03.0 PQ: 0 ANSI: 5
[    1.934777] scsi 1:0:0:0: CD-ROM            ATAPI    iHAS222   8      4L01 PQ: 0 ANSI: 5
[    2.120055] ide0 at 0xb000-0xb007,0xb102 on irq 16
[    2.120113] ide1 at 0xb200-0xb207,0xb302 on irq 16
[    2.120173] ahci 0000:03:00.0: version 3.0
[    2.120192] ahci 0000:03:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    2.136015] usb usb3: suspend_rh (auto-stop)
[    2.136042] ahci 0000:03:00.0: AHCI 0001.0000 32 slots 2 ports 3 Gbps 0x3 impl SATA mode
[    2.136045] usb usb4: suspend_rh (auto-stop)
[    2.136049] ahci 0000:03:00.0: flags: 64bit ncq pm led clo pmp pio slum part 
[    2.136057] ahci 0000:03:00.0: setting latency timer to 64
[    2.136066] usb usb5: suspend_rh (auto-stop)
[    2.136085] usb usb6: suspend_rh (auto-stop)
[    2.136109] usb usb7: suspend_rh (auto-stop)
[    2.136130] usb usb8: suspend_rh (auto-stop)
[    2.136387] scsi4 : ahci
[    2.136477] scsi5 : ahci
[    2.136569] ata5: SATA max UDMA/133 abar m8192@0xeb100000 port 0xeb100100 irq 19+
[    2.136573] ata6: SATA max UDMA/133 abar m8192@0xeb100000 port 0xeb100180 irq 19+
[    2.242588] sd 0:0:0:0: [sda] 1953523055 512-byte logical blocks: (1.00 TB/931 GiB)
[    2.242662] sd 0:0:0:0: [sda] Write Protect is off
[    2.242665] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.242693] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.275853]  sda: sda1 sda2 sda3
[    2.276183] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.316154] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[007ac0a300001fd0]
[    2.456039] ata6: SATA link down (SStatus 0 SControl 300)
[    2.456046] ata5: SATA link down (SStatus 0 SControl 300)
[    2.482195] sr0: scsi3-mmc drive: 48x/12x writer dvd-ram cd/rw xa/form2 cdda tray
[    2.482199] cdrom: Uniform CD-ROM driver Revision: 3.20
[    2.482322] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    2.486601] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.486650] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    2.804256] PM: Starting manual resume from disk
[    3.186467] EXT4-fs (sda2): INFO: recovery required on readonly filesystem
[    3.186471] EXT4-fs (sda2): write access will be enabled during recovery
[    3.784128] hub 8-0:1.0: hub_suspend
[    3.784137] usb usb8: bus auto-suspend
[    3.784140] usb usb8: suspend_rh
[    3.800013] hub 3-0:1.0: hub_suspend
[    3.800020] usb usb3: bus auto-suspend
[    3.800023] usb usb3: suspend_rh
[    3.800039] hub 4-0:1.0: hub_suspend
[    3.800045] usb usb4: bus auto-suspend
[    3.800048] usb usb4: suspend_rh
[    3.800062] hub 5-0:1.0: hub_suspend
[    3.800076] usb usb5: bus auto-suspend
[    3.800077] usb usb5: suspend_rh
[    3.800096] hub 6-0:1.0: hub_suspend
[    3.800099] usb usb6: bus auto-suspend
[    3.800101] usb usb6: suspend_rh
[    3.800115] hub 7-0:1.0: hub_suspend
[    3.800118] usb usb7: bus auto-suspend
[    3.800120] usb usb7: suspend_rh
[    3.824011] hub 1-0:1.0: hub_suspend
[    3.824016] usb usb1: bus auto-suspend
[    3.824019] ehci_hcd 0000:00:1a.7: suspend root hub
[    3.824041] hub 2-0:1.0: hub_suspend
[    3.824045] usb usb2: bus auto-suspend
[    3.824047] ehci_hcd 0000:00:1d.7: suspend root hub
[   15.128011] IRQ 14: ata_piix: can't verify IRQ, will keep polling
[   15.128014] IRQ 14: ata_piix: system performance may be affected
[   21.178289] EXT4-fs (sda2): recovery complete
[   21.200019] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null)
[   24.776504] udev: starting version 161
[   26.156802] input: ImPS/2 Logitech Wheel Mouse as /devices/platform/i8042/serio1/input/input1
[   26.412551] input: PC Speaker as /devices/platform/pcspkr/input/input2
[   26.973887] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input3
[   26.974033] ACPI: Power Button [PWRB]
[   26.974115] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input4
[   26.974158] ACPI: Power Button [PWRF]
[   27.132705] i2c-core: driver [dummy] registered
[   27.144300] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   27.165060] i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[   27.165069] i801_smbus 0000:00:1f.3: SMBus using PCI Interrupt
[   27.165102] i2c i2c-0: adapter [SMBus I801 adapter at 0500] registered
[   27.212070] parport_pc 00:09: reported by Plug and Play ACPI
[   27.212113] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
[   27.282420] ACPI: acpi_idle registered with cpuidle
[   27.282460] Marking TSC unstable due to TSC halts in idle
[   27.282527] Switching to clocksource hpet
[   27.514455] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   28.326721] [drm] Initialized drm 1.1.0 20060810
[   28.668844] nouveau 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   28.668850] nouveau 0000:01:00.0: setting latency timer to 64
[   28.672054] [drm] nouveau 0000:01:00.0: Detected an NV50 generation card (0x096080c1)
[   28.672059] checking generic (e5000000 180000) vs hw (d0000000 10000000)
[   28.672061] checking generic (e5000000 180000) vs hw (e4000000 2000000)
[   28.672063] fb: conflicting fb hw usage nouveaufb vs VESA VGA - removing generic driver
[   28.672260] Console: switching to colour dummy device 80x25
[   28.676410] [drm] nouveau 0000:01:00.0: Attempting to load BIOS image from PRAMIN
[   28.733899] [drm] nouveau 0000:01:00.0: ... appears to be valid
[   28.733903] [drm] nouveau 0000:01:00.0: BIT BIOS found
[   28.733905] [drm] nouveau 0000:01:00.0: Bios version 62.94.4b.00
[   28.733908] [drm] nouveau 0000:01:00.0: TMDS table version 2.0
[   28.733911] [drm] nouveau 0000:01:00.0: Found Display Configuration Block version 4.0
[   28.733914] [drm] nouveau 0000:01:00.0: Raw DCB entry 0: 02000300 00000028
[   28.733916] [drm] nouveau 0000:01:00.0: Raw DCB entry 1: 01000302 00020030
[   28.733919] [drm] nouveau 0000:01:00.0: Raw DCB entry 2: 04011310 00000028
[   28.733921] [drm] nouveau 0000:01:00.0: Raw DCB entry 3: 02022332 00c20090
[   28.733923] [drm] nouveau 0000:01:00.0: Raw DCB entry 4: 02023342 00c00090
[   28.733926] [drm] nouveau 0000:01:00.0: DCB connector table: VHER 0x40 5 16 4
[   28.733929] [drm] nouveau 0000:01:00.0:   0: 0x00001030: type 0x30 idx 0 tag 0x07
[   28.733931] [drm] nouveau 0000:01:00.0:   1: 0x00000100: type 0x00 idx 1 tag 0xff
[   28.733934] [drm] nouveau 0000:01:00.0:   2: 0x00002261: type 0x61 idx 2 tag 0x08
[   28.733938] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 0 at offset 0xD20A
[   28.784124] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 1 at offset 0xD657
[   28.800010] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 2 at offset 0xE6A7
[   28.800017] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 3 at offset 0xE7F0
[   28.808127] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 4 at offset 0xEA5C
[   28.808129] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table at offset 0xEAC1
[   28.832018] [drm] nouveau 0000:01:00.0: 0xEAC1: Condition still not met after 20ms, skipping following opcodes
[   28.832048] [drm] nouveau 0000:01:00.0: Detected 512MiB VRAM
[   28.919473] [TTM] Zone  kernel: Available graphics memory: 2030022 kiB.
[   28.919475] [TTM] Initializing pool allocator.
[   28.934153] [drm] nouveau 0000:01:00.0: 512 MiB GART (aperture)
[   28.934159] mtrr: type mismatch for d0000000,10000000 old: write-back new: write-combining
[   28.935065] [drm] nouveau 0000:01:00.0: unknown connector type: 0xff!!
[   28.955814] [drm] nouveau 0000:01:00.0: Allocating FIFO number 1
[   28.959636] [drm] nouveau 0000:01:00.0: nouveau_channel_alloc: initialised FIFO 1
[   28.959688] i2c i2c-1: adapter [nouveau-0000:01:00.0-0] registered
[   28.959694] i2c i2c-1: master_xfer[0] W, addr=0x50, len=1
[   28.959697] i2c i2c-1: master_xfer[1] R, addr=0x50, len=1
[   28.962925] i2c i2c-1: master_xfer[0] W, addr=0x50, len=1
[   28.962928] i2c i2c-1: master_xfer[1] R, addr=0x50, len=1
[   28.966151] i2c i2c-1: master_xfer[0] W, addr=0x50, len=1
[   28.966154] i2c i2c-1: master_xfer[1] R, addr=0x50, len=128
[   29.062686] i2c i2c-2: adapter [nouveau-0000:01:00.0-1] registered
[   29.062692] i2c i2c-2: master_xfer[0] W, addr=0x50, len=1
[   29.062695] i2c i2c-2: master_xfer[1] R, addr=0x50, len=1
[   29.066336] i2c i2c-2: NAK from device addr 0x50 msg #0
[   29.111112] i2c i2c-3: adapter [nouveau-0000:01:00.0-3] registered
[   29.111117] i2c i2c-3: master_xfer[0] W, addr=0x50, len=1
[   29.111120] i2c i2c-3: master_xfer[1] R, addr=0x50, len=1
[   29.114729] i2c i2c-3: NAK from device addr 0x50 msg #0
[   29.116242] [drm] nouveau 0000:01:00.0: allocated 1920x1200 fb: 0x40240000, bo ffff88012a834400
[   29.116359] fbcon: nouveaufb (fb0) is primary device
[   29.116445] Console: switching to colour frame buffer device 240x75
[   29.119964] fb0: nouveaufb frame buffer device
[   29.119966] drm: registered panic notifier
[   29.119972] [drm] Initialized nouveau 0.0.16 20090420 for 0000:01:00.0 on minor 0
[   29.175638]   alloc irq_desc for 22 on node -1
[   29.175642]   alloc kstat_irqs on node -1
[   29.175650] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[   29.175713]   alloc irq_desc for 41 on node -1
[   29.175715]   alloc kstat_irqs on node -1
[   29.175725] HDA Intel 0000:00:1b.0: irq 41 for MSI/MSI-X
[   29.175749] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   29.175753] ALSA sound/pci/hda/hda_intel.c:2517: chipset global capabilities = 0x4401
[   29.204011] ALSA sound/pci/hda/hda_intel.c:907: codec_mask = 0x4
[   29.204116] ALSA sound/pci/hda/hda_intel.c:1345: codec #2 probed OK
[   29.274678] ALSA sound/pci/hda/patch_realtek.c:1353: SKU: Nid=0x1d sku_cfg=0x4005e601
[   29.274684] ALSA sound/pci/hda/patch_realtek.c:1355: SKU: port_connectivity=0x1
[   29.274688] ALSA sound/pci/hda/patch_realtek.c:1356: SKU: enable_pcbeep=0x0
[   29.274693] ALSA sound/pci/hda/patch_realtek.c:1357: SKU: check_sum=0x00000005
[   29.274700] ALSA sound/pci/hda/patch_realtek.c:1358: SKU: customization=0x000000e6
[   29.274705] ALSA sound/pci/hda/patch_realtek.c:1359: SKU: external_amp=0x0
[   29.274711] ALSA sound/pci/hda/patch_realtek.c:1360: SKU: platform_type=0x0
[   29.274719] ALSA sound/pci/hda/patch_realtek.c:1361: SKU: swap=0x0
[   29.274723] ALSA sound/pci/hda/patch_realtek.c:1362: SKU: override=0x1
[   29.274730] ALSA sound/pci/hda/hda_codec.c:3720: hda_codec: model '6stack-dig' is selected for config 1458:a002 (Gigabyte P35 DS3R)
[   29.277293] ALSA sound/pci/hda/hda_codec.c:2145: Cannot find slave Headphone Playback Volume, skipped
[   29.277297] ALSA sound/pci/hda/hda_codec.c:2145: Cannot find slave Speaker Playback Volume, skipped
[   29.277300] ALSA sound/pci/hda/hda_codec.c:2145: Cannot find slave Mono Playback Volume, skipped
[   29.277303] ALSA sound/pci/hda/hda_codec.c:2145: Cannot find slave Line-Out Playback Volume, skipped
[   29.277306] ALSA sound/pci/hda/hda_codec.c:2145: Cannot find slave PCM Playback Volume, skipped
[   29.277318] ALSA sound/pci/hda/hda_codec.c:2145: Cannot find slave Speaker Playback Switch, skipped
[   29.277321] ALSA sound/pci/hda/hda_codec.c:2145: Cannot find slave Mono Playback Switch, skipped
[   29.277326] ALSA sound/pci/hda/hda_codec.c:2145: Cannot find slave Line-Out Playback Switch, skipped
[   29.277329] ALSA sound/pci/hda/hda_codec.c:2145: Cannot find slave PCM Playback Switch, skipped
[   32.512562] Adding 9462280k swap on /dev/sda3.  Priority:-1 extents:1 across:9462280k 
[   32.516272] EXT4-fs (sda2): re-mounted. Opts: (null)
[   32.816054] EXT4-fs (sda2): re-mounted. Opts: errors=remount-ro
[   32.968054] loop: module loaded
[   33.065707] it87: Found IT8718F chip at 0x290, revision 5
[   33.065715] it87: VID is disabled (pins used for GPIO)
[   33.065724] it87: Beeping is supported
[   36.000039] EXT3-fs: barriers not enabled
[   36.012074] kjournald starting.  Commit interval 5 seconds
[   36.024021] EXT3-fs (sda1): using internal journal
[   36.024027] EXT3-fs (sda1): mounted filesystem with writeback data mode
[   38.414283] r8169 0000:05:00.0: eth1: link down
[   39.136022] i2c i2c-1: master_xfer[0] W, addr=0x50, len=1
[   39.136026] i2c i2c-1: master_xfer[1] R, addr=0x50, len=1
[   39.139245] i2c i2c-1: master_xfer[0] W, addr=0x50, len=1
[   39.139247] i2c i2c-1: master_xfer[1] R, addr=0x50, len=1
[   39.142471] i2c i2c-1: master_xfer[0] W, addr=0x50, len=1
[   39.142474] i2c i2c-1: master_xfer[1] R, addr=0x50, len=128
[   39.148094] r8169 0000:04:00.0: eth0: link up
[   39.148102] r8169 0000:04:00.0: eth0: link up
[   39.238978] i2c i2c-2: master_xfer[0] W, addr=0x50, len=1
[   39.238981] i2c i2c-2: master_xfer[1] R, addr=0x50, len=1
[   39.242598] i2c i2c-2: NAK from device addr 0x50 msg #0
[   39.287356] i2c i2c-3: master_xfer[0] W, addr=0x50, len=1
[   39.287359] i2c i2c-3: master_xfer[1] R, addr=0x50, len=1
[   39.290970] i2c i2c-3: NAK from device addr 0x50 msg #0
[   39.619971] fuse init (API version 7.15)
[   41.597592] lp0: using parport0 (interrupt-driven).
[   41.597595] lp0: console ready
[   41.609681] ppdev: user-space parallel port driver
[   43.962392] NET: Registered protocol family 10
[   43.962953] lo: Disabled Privacy Extensions
[   43.963639] ADDRCONF(NETDEV_UP): eth1: link is not ready
[   49.312025] i2c i2c-1: master_xfer[0] W, addr=0x50, len=1
[   49.312029] i2c i2c-1: master_xfer[1] R, addr=0x50, len=1
[   49.315249] i2c i2c-1: master_xfer[0] W, addr=0x50, len=1
[   49.315251] i2c i2c-1: master_xfer[1] R, addr=0x50, len=1
[   49.318477] i2c i2c-1: master_xfer[0] W, addr=0x50, len=1
[   49.318479] i2c i2c-1: master_xfer[1] R, addr=0x50, len=128
[   49.415031] i2c i2c-2: master_xfer[0] W, addr=0x50, len=1
[   49.415034] i2c i2c-2: master_xfer[1] R, addr=0x50, len=1
[   49.418644] i2c i2c-2: NAK from device addr 0x50 msg #0
[   49.463403] i2c i2c-3: master_xfer[0] W, addr=0x50, len=1
[   49.463405] i2c i2c-3: master_xfer[1] R, addr=0x50, len=1
[   49.467014] i2c i2c-3: NAK from device addr 0x50 msg #0
[   54.600008] eth0: no IPv6 routers present
[   57.674026] Bluetooth: Core ver 2.15
[   57.674063] NET: Registered protocol family 31
[   57.674064] Bluetooth: HCI device and connection manager initialized
[   57.674067] Bluetooth: HCI socket layer initialized
[   57.687231] Bluetooth: L2CAP ver 2.15
[   57.687233] Bluetooth: L2CAP socket layer initialized
[   57.855844] Bluetooth: RFCOMM TTY layer initialized
[   57.855852] Bluetooth: RFCOMM socket layer initialized
[   57.855854] Bluetooth: RFCOMM ver 1.11
[   57.942043] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   57.942046] Bluetooth: BNEP filters: protocol multicast
[   58.094336] Bluetooth: SCO (Voice Link) ver 0.6
[   58.094339] Bluetooth: SCO socket layer initialized
[   59.488025] i2c i2c-1: master_xfer[0] W, addr=0x50, len=1
[   59.488029] i2c i2c-1: master_xfer[1] R, addr=0x50, len=1
[   59.491247] i2c i2c-1: master_xfer[0] W, addr=0x50, len=1
[   59.491250] i2c i2c-1: master_xfer[1] R, addr=0x50, len=1
[   59.494479] i2c i2c-1: master_xfer[0] W, addr=0x50, len=1
[   59.494481] i2c i2c-1: master_xfer[1] R, addr=0x50, len=128
[   59.590786] i2c i2c-2: master_xfer[0] W, addr=0x50, len=1
[   59.590788] i2c i2c-2: master_xfer[1] R, addr=0x50, len=1
[   59.594393] i2c i2c-2: NAK from device addr 0x50 msg #0
[   59.639156] i2c i2c-3: master_xfer[0] W, addr=0x50, len=1
[   59.639159] i2c i2c-3: master_xfer[1] R, addr=0x50, len=1
[   59.642763] i2c i2c-3: NAK from device addr 0x50 msg #0
[   69.664021] i2c i2c-1: master_xfer[0] W, addr=0x50, len=1
[   69.664025] i2c i2c-1: master_xfer[1] R, addr=0x50, len=1
[   69.667243] i2c i2c-1: master_xfer[0] W, addr=0x50, len=1
[   69.667246] i2c i2c-1: master_xfer[1] R, addr=0x50, len=1
[   69.670535] i2c i2c-1: master_xfer[0] W, addr=0x50, len=1
[   69.670538] i2c i2c-1: master_xfer[1] R, addr=0x50, len=128
[   69.767535] i2c i2c-2: master_xfer[0] W, addr=0x50, len=1
[   69.767538] i2c i2c-2: master_xfer[1] R, addr=0x50, len=1
[   69.771146] i2c i2c-2: NAK from device addr 0x50 msg #0
[   69.815944] i2c i2c-3: master_xfer[0] W, addr=0x50, len=1
[   69.815946] i2c i2c-3: master_xfer[1] R, addr=0x50, len=1
[   69.819557] i2c i2c-3: NAK from device addr 0x50 msg #0
[   79.840082] i2c i2c-1: master_xfer[0] W, addr=0x50, len=1
[   79.840095] i2c i2c-1: master_xfer[1] R, addr=0x50, len=1
[   79.843321] i2c i2c-1: master_xfer[0] W, addr=0x50, len=1
[   79.843323] i2c i2c-1: master_xfer[1] R, addr=0x50, len=1
[   79.846548] i2c i2c-1: master_xfer[0] W, addr=0x50, len=1
[   79.846551] i2c i2c-1: master_xfer[1] R, addr=0x50, len=128
[   79.942878] i2c i2c-2: master_xfer[0] W, addr=0x50, len=1
[   79.942880] i2c i2c-2: master_xfer[1] R, addr=0x50, len=1
[   79.946489] i2c i2c-2: NAK from device addr 0x50 msg #0
[   79.991247] i2c i2c-3: master_xfer[0] W, addr=0x50, len=1
[   79.991249] i2c i2c-3: master_xfer[1] R, addr=0x50, len=1
[   79.994858] i2c i2c-3: NAK from device addr 0x50 msg #0
[   90.016025] i2c i2c-1: master_xfer[0] W, addr=0x50, len=1
[   90.016030] i2c i2c-1: master_xfer[1] R, addr=0x50, len=1
[   90.019257] i2c i2c-1: master_xfer[0] W, addr=0x50, len=1
[   90.019259] i2c i2c-1: master_xfer[1] R, addr=0x50, len=1
[   90.022497] i2c i2c-1: master_xfer[0] W, addr=0x50, len=1
[   90.022500] i2c i2c-1: master_xfer[1] R, addr=0x50, len=128
[   90.118918] i2c i2c-2: master_xfer[0] W, addr=0x50, len=1
[   90.118921] i2c i2c-2: master_xfer[1] R, addr=0x50, len=1
[   90.122537] i2c i2c-2: NAK from device addr 0x50 msg #0
[   90.167295] i2c i2c-3: master_xfer[0] W, addr=0x50, len=1
[   90.167298] i2c i2c-3: master_xfer[1] R, addr=0x50, len=1
[   90.170908] i2c i2c-3: NAK from device addr 0x50 msg #0
[  100.192022] i2c i2c-1: master_xfer[0] W, addr=0x50, len=1
[  100.192026] i2c i2c-1: master_xfer[1] R, addr=0x50, len=1
[  100.195244] i2c i2c-1: master_xfer[0] W, addr=0x50, len=1
[  100.195246] i2c i2c-1: master_xfer[1] R, addr=0x50, len=1
[  100.198591] i2c i2c-1: master_xfer[0] W, addr=0x50, len=1
[  100.198594] i2c i2c-1: master_xfer[1] R, addr=0x50, len=128
[  100.295317] i2c i2c-2: master_xfer[0] W, addr=0x50, len=1
[  100.295320] i2c i2c-2: master_xfer[1] R, addr=0x50, len=1
[  100.298997] i2c i2c-2: NAK from device addr 0x50 msg #0
[  100.343756] i2c i2c-3: master_xfer[0] W, addr=0x50, len=1
[  100.343758] i2c i2c-3: master_xfer[1] R, addr=0x50, len=1
[  100.347409] i2c i2c-3: NAK from device addr 0x50 msg #0
[  110.368023] i2c i2c-1: master_xfer[0] W, addr=0x50, len=1
[  110.368027] i2c i2c-1: master_xfer[1] R, addr=0x50, len=1
[  110.371249] i2c i2c-1: master_xfer[0] W, addr=0x50, len=1
[  110.371252] i2c i2c-1: master_xfer[1] R, addr=0x50, len=1
[  110.374562] i2c i2c-1: master_xfer[0] W, addr=0x50, len=1
[  110.374565] i2c i2c-1: master_xfer[1] R, addr=0x50, len=128
[  110.471148] i2c i2c-2: master_xfer[0] W, addr=0x50, len=1
[  110.471151] i2c i2c-2: master_xfer[1] R, addr=0x50, len=1
[  110.474787] i2c i2c-2: NAK from device addr 0x50 msg #0
[  110.519546] i2c i2c-3: master_xfer[0] W, addr=0x50, len=1
[  110.519549] i2c i2c-3: master_xfer[1] R, addr=0x50, len=1
[  110.523210] i2c i2c-3: NAK from device addr 0x50 msg #0
[  120.544020] i2c i2c-1: master_xfer[0] W, addr=0x50, len=1
[  120.544024] i2c i2c-1: master_xfer[1] R, addr=0x50, len=1
[  120.547242] i2c i2c-1: master_xfer[0] W, addr=0x50, len=1
[  120.547245] i2c i2c-1: master_xfer[1] R, addr=0x50, len=1
[  120.550470] i2c i2c-1: master_xfer[0] W, addr=0x50, len=1
[  120.550472] i2c i2c-1: master_xfer[1] R, addr=0x50, len=128
[  120.646774] i2c i2c-2: master_xfer[0] W, addr=0x50, len=1
[  120.646776] i2c i2c-2: master_xfer[1] R, addr=0x50, len=1
[  120.650386] i2c i2c-2: NAK from device addr 0x50 msg #0
[  120.695144] i2c i2c-3: master_xfer[0] W, addr=0x50, len=1
[  120.695146] i2c i2c-3: master_xfer[1] R, addr=0x50, len=1
[  120.698755] i2c i2c-3: NAK from device addr 0x50 msg #0
[  130.720022] i2c i2c-1: master_xfer[0] W, addr=0x50, len=1
[  130.720026] i2c i2c-1: master_xfer[1] R, addr=0x50, len=1
[  130.723244] i2c i2c-1: master_xfer[0] W, addr=0x50, len=1
[  130.723247] i2c i2c-1: master_xfer[1] R, addr=0x50, len=1
[  130.726472] i2c i2c-1: master_xfer[0] W, addr=0x50, len=1
[  130.726474] i2c i2c-1: master_xfer[1] R, addr=0x50, len=128
[  130.823255] i2c i2c-2: master_xfer[0] W, addr=0x50, len=1
[  130.823258] i2c i2c-2: master_xfer[1] R, addr=0x50, len=1
[  130.826873] i2c i2c-2: NAK from device addr 0x50 msg #0
[  130.871632] i2c i2c-3: master_xfer[0] W, addr=0x50, len=1
[  130.871635] i2c i2c-3: master_xfer[1] R, addr=0x50, len=1
[  130.875243] i2c i2c-3: NAK from device addr 0x50 msg #0
[  140.896026] i2c i2c-1: master_xfer[0] W, addr=0x50, len=1
[  140.896031] i2c i2c-1: master_xfer[1] R, addr=0x50, len=1
[  140.899252] i2c i2c-1: master_xfer[0] W, addr=0x50, len=1
[  140.899254] i2c i2c-1: master_xfer[1] R, addr=0x50, len=1
[  140.902479] i2c i2c-1: master_xfer[0] W, addr=0x50, len=1
[  140.902481] i2c i2c-1: master_xfer[1] R, addr=0x50, len=128
[  140.998819] i2c i2c-2: master_xfer[0] W, addr=0x50, len=1
[  140.998822] i2c i2c-2: master_xfer[1] R, addr=0x50, len=1
[  141.002431] i2c i2c-2: NAK from device addr 0x50 msg #0
[  141.047189] i2c i2c-3: master_xfer[0] W, addr=0x50, len=1
[  141.047192] i2c i2c-3: master_xfer[1] R, addr=0x50, len=1
[  141.050800] i2c i2c-3: NAK from device addr 0x50 msg #0
[  151.072019] i2c i2c-1: master_xfer[0] W, addr=0x50, len=1
[  151.072023] i2c i2c-1: master_xfer[1] R, addr=0x50, len=1
[  151.075241] i2c i2c-1: master_xfer[0] W, addr=0x50, len=1
[  151.075244] i2c i2c-1: master_xfer[1] R, addr=0x50, len=1
[  151.078468] i2c i2c-1: master_xfer[0] W, addr=0x50, len=1
[  151.078470] i2c i2c-1: master_xfer[1] R, addr=0x50, len=128
[  151.174784] i2c i2c-2: master_xfer[0] W, addr=0x50, len=1
[  151.174786] i2c i2c-2: master_xfer[1] R, addr=0x50, len=1
[  151.178395] i2c i2c-2: NAK from device addr 0x50 msg #0
[  151.223153] i2c i2c-3: master_xfer[0] W, addr=0x50, len=1
[  151.223156] i2c i2c-3: master_xfer[1] R, addr=0x50, len=1
[  151.226763] i2c i2c-3: NAK from device addr 0x50 msg #0
[  161.248020] i2c i2c-1: master_xfer[0] W, addr=0x50, len=1
[  161.248024] i2c i2c-1: master_xfer[1] R, addr=0x50, len=1
[  161.251242] i2c i2c-1: master_xfer[0] W, addr=0x50, len=1
[  161.251244] i2c i2c-1: master_xfer[1] R, addr=0x50, len=1
[  161.254583] i2c i2c-1: master_xfer[0] W, addr=0x50, len=1
[  161.254586] i2c i2c-1: master_xfer[1] R, addr=0x50, len=128
[  161.350924] i2c i2c-2: master_xfer[0] W, addr=0x50, len=1
[  161.350927] i2c i2c-2: master_xfer[1] R, addr=0x50, len=1
[  161.354574] i2c i2c-2: NAK from device addr 0x50 msg #0
[  161.399333] i2c i2c-3: master_xfer[0] W, addr=0x50, len=1
[  161.399336] i2c i2c-3: master_xfer[1] R, addr=0x50, len=1
[  161.402983] i2c i2c-3: NAK from device addr 0x50 msg #0
[  171.424022] i2c i2c-1: master_xfer[0] W, addr=0x50, len=1
[  171.424026] i2c i2c-1: master_xfer[1] R, addr=0x50, len=1
[  171.427244] i2c i2c-1: master_xfer[0] W, addr=0x50, len=1
[  171.427246] i2c i2c-1: master_xfer[1] R, addr=0x50, len=1
[  171.430471] i2c i2c-1: master_xfer[0] W, addr=0x50, len=1
[  171.430474] i2c i2c-1: master_xfer[1] R, addr=0x50, len=128
[  171.526771] i2c i2c-2: master_xfer[0] W, addr=0x50, len=1
[  171.526774] i2c i2c-2: master_xfer[1] R, addr=0x50, len=1
[  171.530385] i2c i2c-2: NAK from device addr 0x50 msg #0
[  171.575143] i2c i2c-3: master_xfer[0] W, addr=0x50, len=1
[  171.575146] i2c i2c-3: master_xfer[1] R, addr=0x50, len=1
[  171.578754] i2c i2c-3: NAK from device addr 0x50 msg #0
[  181.600020] i2c i2c-1: master_xfer[0] W, addr=0x50, len=1
[  181.600024] i2c i2c-1: master_xfer[1] R, addr=0x50, len=1
[  181.603242] i2c i2c-1: master_xfer[0] W, addr=0x50, len=1
[  181.603245] i2c i2c-1: master_xfer[1] R, addr=0x50, len=1
[  181.606469] i2c i2c-1: master_xfer[0] W, addr=0x50, len=1
[  181.606472] i2c i2c-1: master_xfer[1] R, addr=0x50, len=128
[  181.702814] i2c i2c-2: master_xfer[0] W, addr=0x50, len=1
[  181.702816] i2c i2c-2: master_xfer[1] R, addr=0x50, len=1
[  181.706426] i2c i2c-2: NAK from device addr 0x50 msg #0
[  181.751185] i2c i2c-3: master_xfer[0] W, addr=0x50, len=1
[  181.751187] i2c i2c-3: master_xfer[1] R, addr=0x50, len=1
[  181.754796] i2c i2c-3: NAK from device addr 0x50 msg #0

--------------010102070201030306020703--

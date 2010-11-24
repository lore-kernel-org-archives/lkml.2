Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753Ab0KXAXj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 19:23:39 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49454 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755548Ab0KXAXh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 19:23:37 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alex Deucher <alexdeucher@gmail.com>
Subject: [Regression, post-2.6.37-rc2] Unable to start KDE with 2.6.37-rc3 on Acer Ferrari One
Date: Wed, 24 Nov 2010 01:22:32 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc2-rjw+; KDE/4.4.4; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Dave Airlie <airlied@gmail.com>,
        DRI <dri-devel@lists.freedesktop.org>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_JrF7MJVFVLvabzt"
Message-Id: <201011240122.33174.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_JrF7MJVFVLvabzt
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi,

I cannot start KDE with the 2.6.37-rc3 kernel.  The X server and display
manager start normally, but when I attempt to log into KDE, it attempts to
start, but then the X apparently crashes and this appears in the dmesg output:

[   24.342287] radeon 0000:01:05.0: r600_cs_track_validate_cb offset[0] 0 46097920 4325376 too big
[   24.342298] radeon 0000:01:05.0: r600_packet3_check:1331 invalid cmd stream 502
[   24.342304] [drm:radeon_cs_ioctl] *ERROR* Invalid command stream !
[   24.694106] [drm:drm_mode_getfb] *ERROR* invalid framebuffer id
[   93.938946] radeon 0000:01:05.0: r600_cs_track_validate_cb offset[0] 0 46097920 4325376 too big
[   93.938956] radeon 0000:01:05.0: r600_packet3_check:1331 invalid cmd stream 502
[   93.938962] [drm:radeon_cs_ioctl] *ERROR* Invalid command stream !
[   94.278050] [drm:drm_mode_getfb] *ERROR* invalid framebuffer id
[  114.898043] radeon 0000:01:05.0: r600_cs_track_validate_cb offset[0] 0 46097920 4325376 too big
[  114.898053] radeon 0000:01:05.0: r600_packet3_check:1331 invalid cmd stream 502
[  114.898058] [drm:radeon_cs_ioctl] *ERROR* Invalid command stream !
[  115.266113] [drm:drm_mode_getfb] *ERROR* invalid framebuffer id
[  129.722472] [drm:drm_mode_getfb] *ERROR* invalid framebuffer id
[  142.984314] radeon 0000:01:05.0: r600_cs_track_validate_cb offset[0] 0 46097920 4325376 too big
[  142.984324] radeon 0000:01:05.0: r600_packet3_check:1331 invalid cmd stream 502
[  142.984330] [drm:radeon_cs_ioctl] *ERROR* Invalid command stream !
[  143.370083] [drm:drm_mode_getfb] *ERROR* invalid framebuffer id

This doesn't happen with 2.6.37-rc2.

Full dmesg output is attached, please let me know if you need more information.

Thanks,
Rafael

--Boundary-00=_JrF7MJVFVLvabzt
Content-Type: text/x-log;
  charset="UTF-8";
  name="ferrari.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="ferrari.log"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Linux version 2.6.37-rc3+ (rafael@chimera) (gcc version 4.2.1 (SUSE Linux)) #166 SMP PREEMPT Wed Nov 24 00:59:37 CET 2010
[    0.000000] Command line: root=/dev/sda3 resume=/dev/sda2
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009dc00 (usable)
[    0.000000]  BIOS-e820: 000000000009dc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000d0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000008dec0000 (usable)
[    0.000000]  BIOS-e820: 000000008dec0000 - 000000008ded8000 (ACPI data)
[    0.000000]  BIOS-e820: 000000008ded8000 - 000000008deda000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000008deda000 - 000000009e000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000162000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] DMI: California       /Ferrari One 200  , BIOS v1.3110  01/14/2010
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x162000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CEFFF write-protect
[    0.000000]   CF000-DFFFF uncachable
[    0.000000]   E0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask FF80000000 write-back
[    0.000000]   1 base 0080000000 mask FFF8000000 write-back
[    0.000000]   2 base 0088000000 mask FFFC000000 write-back
[    0.000000]   3 base 008C000000 mask FFFE000000 write-back
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 0000000162000000 aka 5664M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 000000008e000000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0x8dec0 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [ffff8800000f7b80] f7b80
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-000000008dec0000
[    0.000000]  0000000000 - 008dec0000 page 4k
[    0.000000] kernel direct mapping tables up to 8dec0000 @ 1fb8c000-20000000
[    0.000000] init_memory_mapping: 0000000100000000-0000000162000000
[    0.000000]  0100000000 - 0162000000 page 4k
[    0.000000] kernel direct mapping tables up to 162000000 @ 8d3a9000-8dec0000
[    0.000000] RAMDISK: 37244000 - 37ff0000
[    0.000000] ACPI: RSDP 00000000000f7ad0 00024 (v02 PTLTD )
[    0.000000] ACPI: XSDT 000000008decbddd 0004C (v01 ACRSYS ACRPRDCT 06040000  LTP 00000000)
[    0.000000] ACPI: FACP 000000008ded7c50 000F4 (v03 AMD    ANT      06040000 ATI  000F4240)
[    0.000000] ACPI: DSDT 000000008decbe29 0BE27 (v01    ATI    SB700 06040000 MSFT 03000001)
[    0.000000] ACPI: FACS 000000008ded9fc0 00040
[    0.000000] ACPI: APIC 000000008ded7db8 0005E (v01 PTLTD  ? APIC   06040000  LTP 00000000)
[    0.000000] ACPI: MCFG 000000008ded7e16 0003C (v01 PTLTD    MCFG   06040000  LTP 00000000)
[    0.000000] ACPI: HPET 000000008ded7e52 00038 (v01 PTLTD  HPETTBL  06040000  LTP 00000001)
[    0.000000] ACPI: SLIC 000000008ded7e8a 00176 (v01 ACRSYS ACRPRDCT 06040000 acer 00000000)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000]  [ffffea0000000000-ffffea0004ffffff] PMD -> [ffff880080200000-ffff8800839fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00162000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009d
[    0.000000]     0: 0x00000100 -> 0x0008dec0
[    0.000000]     0: 0x00100000 -> 0x00162000
[    0.000000] On node 0 totalpages: 982605
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 3919 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 562936 pages, LIFO batch:31
[    0.000000]   Normal zone: 5488 pages used for memmap
[    0.000000]   Normal zone: 395920 pages, LIFO batch:31
[    0.000000] Detected use of extended apic ids on hypertransport bus
[    0.000000] ACPI: PM-Timer IO Port: 0x8008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 33, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x43538301 base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009d000 - 000000000009e000
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000d0000
[    0.000000] PM: Registered nosave memory: 00000000000d0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 000000008dec0000 - 000000008ded8000
[    0.000000] PM: Registered nosave memory: 000000008ded8000 - 000000008deda000
[    0.000000] PM: Registered nosave memory: 000000008deda000 - 000000009e000000
[    0.000000] PM: Registered nosave memory: 000000009e000000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec10000
[    0.000000] PM: Registered nosave memory: 00000000fec10000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000fff00000
[    0.000000] PM: Registered nosave memory: 00000000fff00000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at 9e000000 (gap: 9e000000:42000000)
[    0.000000] setup_percpu: NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 25 pages/cpu @ffff88008dc00000 s73408 r8192 d20800 u1048576
[    0.000000] pcpu-alloc: s73408 r8192 d20800 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 962775
[    0.000000] Kernel command line: root=/dev/sda3 resume=/dev/sda2
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.000000] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Node 0: aperture @ 84000000 size 32 MB
[    0.000000] Aperture pointing to e820 RAM. Ignoring.
[    0.000000] Your BIOS doesn't leave a aperture memory hole
[    0.000000] Please enable the IOMMU option in the BIOS setup
[    0.000000] This costs you 64 MB of RAM
[    0.000000] Mapping aperture over 65536 KB of RAM @ 84000000
[    0.000000] PM: Registered nosave memory: 0000000084000000 - 0000000088000000
[    0.000000] Memory: 3705448k/5799936k available (3333k kernel code, 1869516k absent, 224972k reserved, 3174k data, 460k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Preemptable hierarchical RCU implementation.
[    0.000000] NR_IRQS:320
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] ODEBUG: 10 of 10 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 1200.029 MHz processor.
[    0.008010] Calibrating delay loop (skipped), value calculated using timer frequency.. 2400.05 BogoMIPS (lpj=4800116)
[    0.008340] pid_max: default: 32768 minimum: 301
[    0.008543] Security Framework initialized
[    0.008737] Mount-cache hash table entries: 256
[    0.009259] tseg: 008df00000
[    0.009264] CPU: Physical Processor ID: 0
[    0.009389] CPU: Processor Core ID: 0
[    0.009546] mce: CPU supports 5 MCE banks
[    0.009717] using C1E aware idle routine
[    0.009866] Performance Events: AMD PMU driver.
[    0.010069] ... version:                0
[    0.010223] ... bit width:              48
[    0.010372] ... generic registers:      4
[    0.010529] ... value mask:             0000ffffffffffff
[    0.010688] ... max period:             00007fffffffffff
[    0.010847] ... fixed-purpose events:   0
[    0.010997] ... event mask:             000000000000000f
[    0.011168] ACPI: Core revision 20101013
[    0.036158] Setting APIC routing to flat
[    0.036727] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.077272] CPU0: AMD Athlon(tm) X2 Dual Core Processor L310 stepping 02
[    0.080000] System has AMD C1E enabled
[    0.080000] Switch to broadcast mode on CPU0
[    0.088032] NMI watchdog enabled, takes one hw-pmu counter.
[    0.104048] Booting Node   0, Processors  #1 Ok.
[    0.012000] Switch to broadcast mode on CPU1
[    0.192265] NMI watchdog enabled, takes one hw-pmu counter.
[    0.196015] Brought up 2 CPUs
[    0.196173] Total of 2 processors activated (4800.23 BogoMIPS).
[    0.196603] Time:  0:07:12  Date: 11/24/10
[    0.196603] NET: Registered protocol family 16
[    0.196760] node 0 link 0: io port [1000, ffff]
[    0.196760] TOM: 000000009e000000 aka 2528M
[    0.196760] node 0 link 0: mmio [a0000, bffff]
[    0.196760] node 0 link 0: mmio [9e000000, 9fcfffff]
[    0.196760] node 0 link 0: mmio [9fd00000, 9fefffff]
[    0.196760] node 0 link 0: mmio [9ff00000, 9fffffff]
[    0.196760] node 0 link 0: mmio [a0000000, afffffff]
[    0.196760] node 0 link 0: mmio [b0000000, dfffffff]
[    0.196760] node 0 link 0: mmio [e0000000, efffffff]
[    0.196760] node 0 link 0: mmio [f0000000, ffffffff]
[    0.196760] TOM2: 0000000162000000 aka 5664M
[    0.196760] bus: [00, ff] on node 0 link 0
[    0.196760] bus: 00 index 0 [io  0x0000-0xffff]
[    0.196760] bus: 00 index 1 [mem 0x000a0000-0x000bffff]
[    0.196760] bus: 00 index 2 [mem 0x9e000000-0xffffffff]
[    0.196760] bus: 00 index 3 [mem 0x162000000-0xfcffffffff]
[    0.196760] ACPI: bus type pci registered
[    0.200092] PCI: MMCONFIG for domain 0000 [bus 00-0e] at [mem 0xe0000000-0xe0efffff] (base 0xe0000000)
[    0.200338] PCI: MMCONFIG at [mem 0xe0000000-0xe0efffff] reserved in E820
[    0.200338] PCI: Using configuration type 1 for base access
[    0.212051] bio: create slab <bio-0> at 0
[    0.214140] ACPI: EC: Look up EC in DSDT
[    0.230928] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.232171] ACPI: OEMN 000000008ded89f4 003E8 (v01 AMD    NAHP     00000001 MSFT 03000001)
[    0.234030] ACPI: Dynamic OEM Table Load:
[    0.234306] ACPI: OEMN           (null) 003E8 (v01 AMD    NAHP     00000001 MSFT 03000001)
[    0.300264] ACPI: Interpreter enabled
[    0.300458] ACPI: (supports S0 S3 S4 S5)
[    0.300820] ACPI: Using IOAPIC for interrupt routing
[    0.320432] ACPI: EC: GPE = 0x3, I/O: command/status = 0x66, data = 0x62
[    0.324611] ACPI: No dock devices found.
[    0.324808] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.328005] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.331807] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.336004] pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x000d1fff]
[    0.336004] pci_root PNP0A08:00: host bridge window [mem 0x000d2000-0x000d3fff]
[    0.336004] pci_root PNP0A08:00: host bridge window [mem 0x000d4000-0x000d5fff]
[    0.336004] pci_root PNP0A08:00: host bridge window [mem 0x000d6000-0x000d7fff]
[    0.336004] pci_root PNP0A08:00: host bridge window [mem 0x000d8000-0x000d9fff]
[    0.336004] pci_root PNP0A08:00: host bridge window [mem 0x000da000-0x000dbfff]
[    0.336004] pci_root PNP0A08:00: host bridge window [mem 0x000dc000-0x000ddfff]
[    0.336004] pci_root PNP0A08:00: host bridge window [mem 0x000de000-0x000dffff]
[    0.336004] pci_root PNP0A08:00: host bridge window [mem 0x9e000000-0xdfffffff]
[    0.336004] pci_root PNP0A08:00: host bridge window [mem 0xf0000000-0xffffffff]
[    0.336004] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.336004] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.336004] pci 0000:00:00.0: [1022:9600] type 0 class 0x000600
[    0.336004] pci 0000:00:01.0: [1025:9602] type 1 class 0x000604
[    0.336004] pci 0000:00:03.0: [1022:960b] type 1 class 0x000604
[    0.336004] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.336004] pci 0000:00:03.0: PME# disabled
[    0.336004] pci 0000:00:06.0: [1022:9606] type 1 class 0x000604
[    0.336004] pci 0000:00:06.0: PME# supported from D0 D3hot D3cold
[    0.336004] pci 0000:00:06.0: PME# disabled
[    0.336004] pci 0000:00:07.0: [1022:9607] type 1 class 0x000604
[    0.336004] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    0.336004] pci 0000:00:07.0: PME# disabled
[    0.336004] pci 0000:00:11.0: [1002:4391] type 0 class 0x000106
[    0.336004] pci 0000:00:11.0: reg 10: [io  0x8420-0x8427]
[    0.336004] pci 0000:00:11.0: reg 14: [io  0x8414-0x8417]
[    0.336004] pci 0000:00:11.0: reg 18: [io  0x8418-0x841f]
[    0.336004] pci 0000:00:11.0: reg 1c: [io  0x8410-0x8413]
[    0.336004] pci 0000:00:11.0: reg 20: [io  0x8400-0x840f]
[    0.336004] pci 0000:00:11.0: reg 24: [mem 0xf0508000-0xf05083ff]
[    0.336004] pci 0000:00:12.0: [1002:4397] type 0 class 0x000c03
[    0.336004] pci 0000:00:12.0: reg 10: [mem 0xf0304000-0xf0304fff]
[    0.336004] pci 0000:00:12.1: [1002:4398] type 0 class 0x000c03
[    0.336004] pci 0000:00:12.1: reg 10: [mem 0xf0305000-0xf0305fff]
[    0.336067] pci 0000:00:12.2: [1002:4396] type 0 class 0x000c03
[    0.336097] pci 0000:00:12.2: reg 10: [mem 0xf0508400-0xf05084ff]
[    0.336196] pci 0000:00:12.2: supports D1 D2
[    0.336201] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    0.336208] pci 0000:00:12.2: PME# disabled
[    0.336242] pci 0000:00:13.0: [1002:4397] type 0 class 0x000c03
[    0.336263] pci 0000:00:13.0: reg 10: [mem 0xf0306000-0xf0306fff]
[    0.336365] pci 0000:00:13.2: [1002:4396] type 0 class 0x000c03
[    0.336394] pci 0000:00:13.2: reg 10: [mem 0xf0508800-0xf05088ff]
[    0.336493] pci 0000:00:13.2: supports D1 D2
[    0.336498] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    0.336505] pci 0000:00:13.2: PME# disabled
[    0.336543] pci 0000:00:14.0: [1002:4385] type 0 class 0x000c05
[    0.336679] pci 0000:00:14.2: [1002:4383] type 0 class 0x000403
[    0.336712] pci 0000:00:14.2: reg 10: [mem 0xf0300000-0xf0303fff 64bit]
[    0.336794] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    0.336802] pci 0000:00:14.2: PME# disabled
[    0.336825] pci 0000:00:14.3: [1002:439d] type 0 class 0x000601
[    0.336932] pci 0000:00:14.4: [1002:4384] type 1 class 0x000604
[    0.337001] pci 0000:00:18.0: [1022:1100] type 0 class 0x000600
[    0.337039] pci 0000:00:18.1: [1022:1101] type 0 class 0x000600
[    0.337071] pci 0000:00:18.2: [1022:1102] type 0 class 0x000600
[    0.337104] pci 0000:00:18.3: [1022:1103] type 0 class 0x000600
[    0.337192] pci 0000:01:05.0: [1002:9612] type 0 class 0x000300
[    0.337210] pci 0000:01:05.0: reg 10: [mem 0xa0000000-0xafffffff pref]
[    0.337221] pci 0000:01:05.0: reg 14: [io  0x9000-0x90ff]
[    0.337231] pci 0000:01:05.0: reg 18: [mem 0x9fdf0000-0x9fdfffff]
[    0.337252] pci 0000:01:05.0: reg 24: [mem 0x9fe00000-0x9fefffff]
[    0.337279] pci 0000:01:05.0: supports D1 D2
[    0.337369] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.337534] pci 0000:00:01.0:   bridge window [io  0x9000-0x9fff]
[    0.337541] pci 0000:00:01.0:   bridge window [mem 0x9fd00000-0x9fefffff]
[    0.337549] pci 0000:00:01.0:   bridge window [mem 0xa0000000-0xafffffff 64bit pref]
[    0.337602] pci 0000:00:03.0: PCI bridge to [bus 02-07]
[    0.337799] pci 0000:00:03.0:   bridge window [io  0xa000-0xbfff]
[    0.337806] pci 0000:00:03.0:   bridge window [mem 0x9f800000-0x9f9fffff]
[    0.337815] pci 0000:00:03.0:   bridge window [mem 0xc0000000-0xdfffffff 64bit pref]
[    0.337884] pci 0000:08:00.0: [1969:1063] type 0 class 0x000200
[    0.337915] pci 0000:08:00.0: reg 10: [mem 0xf0200000-0xf023ffff 64bit]
[    0.337932] pci 0000:08:00.0: reg 18: [io  0xc000-0xc07f]
[    0.338029] pci 0000:08:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.338037] pci 0000:08:00.0: PME# disabled
[    0.348043] pci 0000:00:06.0: PCI bridge to [bus 08-08]
[    0.350189] pci 0000:00:06.0:   bridge window [io  0xc000-0xcfff]
[    0.350196] pci 0000:00:06.0:   bridge window [mem 0xf0200000-0xf02fffff]
[    0.350204] pci 0000:00:06.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.350273] pci 0000:09:00.0: [168c:002a] type 0 class 0x000280
[    0.350300] pci 0000:09:00.0: reg 10: [mem 0xf0000000-0xf000ffff 64bit]
[    0.350394] pci 0000:09:00.0: supports D1
[    0.350399] pci 0000:09:00.0: PME# supported from D0 D1 D3hot
[    0.350406] pci 0000:09:00.0: PME# disabled
[    0.350432] pci 0000:09:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.350718] pci 0000:00:07.0: PCI bridge to [bus 09-0e]
[    0.350880] pci 0000:00:07.0:   bridge window [io  0xd000-0xefff]
[    0.350887] pci 0000:00:07.0:   bridge window [mem 0xf0000000-0xf01fffff]
[    0.350896] pci 0000:00:07.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.350979] pci 0000:00:14.4: PCI bridge to [bus 0f-0f] (subtractive decode)
[    0.351146] pci 0000:00:14.4:   bridge window [io  0xf000-0x0000] (disabled)
[    0.351154] pci 0000:00:14.4:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.351163] pci 0000:00:14.4:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.351169] pci 0000:00:14.4:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.351175] pci 0000:00:14.4:   bridge window [mem 0x000d0000-0x000d1fff] (subtractive decode)
[    0.351181] pci 0000:00:14.4:   bridge window [mem 0x000d2000-0x000d3fff] (subtractive decode)
[    0.351187] pci 0000:00:14.4:   bridge window [mem 0x000d4000-0x000d5fff] (subtractive decode)
[    0.351193] pci 0000:00:14.4:   bridge window [mem 0x000d6000-0x000d7fff] (subtractive decode)
[    0.351199] pci 0000:00:14.4:   bridge window [mem 0x000d8000-0x000d9fff] (subtractive decode)
[    0.351205] pci 0000:00:14.4:   bridge window [mem 0x000da000-0x000dbfff] (subtractive decode)
[    0.351211] pci 0000:00:14.4:   bridge window [mem 0x000dc000-0x000ddfff] (subtractive decode)
[    0.351217] pci 0000:00:14.4:   bridge window [mem 0x000de000-0x000dffff] (subtractive decode)
[    0.351223] pci 0000:00:14.4:   bridge window [mem 0x9e000000-0xdfffffff] (subtractive decode)
[    0.351229] pci 0000:00:14.4:   bridge window [mem 0xf0000000-0xffffffff] (subtractive decode)
[    0.351235] pci 0000:00:14.4:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.351241] pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.351301] pci_bus 0000:00: on NUMA node 0
[    0.351311] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.351831] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PB3_._PRT]
[    0.352017] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PB6_._PRT]
[    0.352165] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PB7_._PRT]
[    0.352423] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P_._PRT]
[    0.352748] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]
[    0.372221] ACPI: PCI Interrupt Link [LNKA] (IRQs 10 11) *0, disabled.
[    0.372798] ACPI: PCI Interrupt Link [LNKB] (IRQs 10 11) *0, disabled.
[    0.373369] ACPI: PCI Interrupt Link [LNKC] (IRQs 10 11) *0, disabled.
[    0.373937] ACPI: PCI Interrupt Link [LNKD] (IRQs 10 11) *0, disabled.
[    0.376005] ACPI: PCI Interrupt Link [LNKE] (IRQs 10 11) *0, disabled.
[    0.376005] ACPI: PCI Interrupt Link [LNKF] (IRQs 10 11) *0, disabled.
[    0.376005] ACPI: PCI Interrupt Link [LNKG] (IRQs 10 11) *0, disabled.
[    0.376005] ACPI: PCI Interrupt Link [LNKH] (IRQs 10 11) *0, disabled.
[    0.376106] vgaarb: device added: PCI:0000:01:05.0,decodes=io+mem,owns=io+mem,locks=none
[    0.376359] vgaarb: loaded
[    0.376667] SCSI subsystem initialized
[    0.380064] libata version 3.00 loaded.
[    0.380072] PCI: Using ACPI for IRQ routing
[    0.380208] PCI: pci_cache_line_size set to 64 bytes
[    0.380425] reserve RAM buffer: 000000000009dc00 - 000000000009ffff 
[    0.380432] reserve RAM buffer: 000000008dec0000 - 000000008fffffff 
[    0.380438] reserve RAM buffer: 0000000162000000 - 0000000163ffffff 
[    0.380483] NetLabel: Initializing
[    0.380483] NetLabel:  domain hash size = 128
[    0.380483] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.380623] NetLabel:  unlabeled traffic allowed by default
[    0.380794] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.381160] hpet0: 4 comparators, 32-bit 14.318180 MHz counter
[    0.385108] Switching to clocksource hpet
[    0.385373] pnp: PnP ACPI init
[    0.385593] ACPI: bus type pnp registered
[    0.387713] pnp 00:00: [bus 00-ff]
[    0.387720] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.387725] pnp 00:00: [mem 0x000c0000-0x000c1fff window]
[    0.387731] pnp 00:00: [mem 0x000c2000-0x000c3fff window]
[    0.387736] pnp 00:00: [mem 0x000c4000-0x000c5fff window]
[    0.387741] pnp 00:00: [mem 0x000c6000-0x000c7fff window]
[    0.387746] pnp 00:00: [mem 0x000c8000-0x000c9fff window]
[    0.387751] pnp 00:00: [mem 0x000ca000-0x000cbfff window]
[    0.387756] pnp 00:00: [mem 0x000cc000-0x000cdfff window]
[    0.387761] pnp 00:00: [mem 0x000ce000-0x000cffff window]
[    0.387766] pnp 00:00: [mem 0x000d0000-0x000d1fff window]
[    0.387771] pnp 00:00: [mem 0x000d2000-0x000d3fff window]
[    0.387776] pnp 00:00: [mem 0x000d4000-0x000d5fff window]
[    0.387781] pnp 00:00: [mem 0x000d6000-0x000d7fff window]
[    0.387786] pnp 00:00: [mem 0x000d8000-0x000d9fff window]
[    0.387791] pnp 00:00: [mem 0x000da000-0x000dbfff window]
[    0.387796] pnp 00:00: [mem 0x000dc000-0x000ddfff window]
[    0.387801] pnp 00:00: [mem 0x000de000-0x000dffff window]
[    0.387805] pnp 00:00: [mem 0x000e0000-0x000e1fff window]
[    0.387810] pnp 00:00: [mem 0x000e2000-0x000e3fff window]
[    0.387815] pnp 00:00: [mem 0x000e4000-0x000e5fff window]
[    0.387820] pnp 00:00: [mem 0x000e6000-0x000e7fff window]
[    0.387825] pnp 00:00: [mem 0x000e8000-0x000e9fff window]
[    0.387830] pnp 00:00: [mem 0x000ea000-0x000ebfff window]
[    0.387835] pnp 00:00: [mem 0x000ec000-0x000edfff window]
[    0.387840] pnp 00:00: [mem 0x000ee000-0x000effff window]
[    0.387845] pnp 00:00: [mem 0x9e000000-0xdfffffff window]
[    0.387850] pnp 00:00: [mem 0xf0000000-0xffffffff window]
[    0.387855] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.387867] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.387872] pnp 00:00: [io  0x0d00-0xffff window]
[    0.388195] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    0.388384] pnp 00:01: [mem 0xfec00000-0xfec00fff]
[    0.388390] pnp 00:01: [mem 0xfee00000-0xfee00fff]
[    0.388616] pnp 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.390395] pnp 00:02: [io  0x0000-0x001f]
[    0.390400] pnp 00:02: [io  0x0080-0x008f]
[    0.390405] pnp 00:02: [io  0x00c0-0x00df]
[    0.390410] pnp 00:02: [dma 4]
[    0.390647] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.390677] pnp 00:03: [io  0x00f0-0x00fe]
[    0.390733] pnp 00:03: [irq 13]
[    0.390958] pnp 00:03: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.390992] pnp 00:04: [io  0x0070-0x0071]
[    0.391042] pnp 00:04: [irq 8]
[    0.391273] pnp 00:04: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.391302] pnp 00:05: [io  0x0061]
[    0.391525] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.391561] pnp 00:06: [io  0x0060]
[    0.391566] pnp 00:06: [io  0x0064]
[    0.391609] pnp 00:06: [irq 1]
[    0.391832] pnp 00:06: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.391866] pnp 00:07: [irq 12]
[    0.392158] pnp 00:07: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.392200] pnp 00:08: [io  0x0022-0x0023]
[    0.392205] pnp 00:08: [io  0x002e-0x002f]
[    0.392210] pnp 00:08: [io  0x0072-0x0073]
[    0.392214] pnp 00:08: [io  0x0068-0x0077]
[    0.392219] pnp 00:08: [io  0x0080-0x0081]
[    0.392223] pnp 00:08: [io  0x00b0-0x00b1]
[    0.392228] pnp 00:08: [io  0x00b8]
[    0.392232] pnp 00:08: [io  0x0092]
[    0.392236] pnp 00:08: [io  0x0220-0x022f]
[    0.392241] pnp 00:08: [io  0x040b]
[    0.392246] pnp 00:08: [io  0x04d0-0x04d1]
[    0.392250] pnp 00:08: [io  0x04d6]
[    0.392255] pnp 00:08: [io  0x0530-0x0537]
[    0.392259] pnp 00:08: [io  0x0c00-0x0c01]
[    0.392264] pnp 00:08: [io  0x0c14]
[    0.392268] pnp 00:08: [io  0x0c50-0x0c52]
[    0.392273] pnp 00:08: [io  0x0c6c]
[    0.392277] pnp 00:08: [io  0x0c6f]
[    0.392282] pnp 00:08: [io  0x0cd0-0x0cd1]
[    0.392286] pnp 00:08: [io  0x0cd2-0x0cd3]
[    0.392291] pnp 00:08: [io  0x0cd4-0x0cd5]
[    0.392295] pnp 00:08: [io  0x0cd6-0x0cd7]
[    0.392300] pnp 00:08: [io  0x0cd8-0x0cdf]
[    0.392304] pnp 00:08: [io  0x8000-0x805f]
[    0.392309] pnp 00:08: [io  0x8100-0x81ff window]
[    0.392321] pnp 00:08: [io  0x8200-0x82ff window]
[    0.392327] pnp 00:08: [io  0x0f40-0x0f47]
[    0.392331] pnp 00:08: [io  0x087f]
[    0.392656] pnp 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.392923] pnp 00:09: [mem 0x000e0000-0x000fffff]
[    0.392929] pnp 00:09: [mem 0xfff00000-0xffffffff]
[    0.392933] pnp 00:09: [mem 0xffc00000-0xffefffff]
[    0.392939] pnp 00:09: [mem 0x00000000-0xffffffffffffffff disabled]
[    0.392944] pnp 00:09: [mem 0xfec10000-0xfec1001f]
[    0.392949] pnp 00:09: [mem 0xff800000-0xff80ffff]
[    0.393231] pnp 00:09: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.393568] pnp 00:0a: [mem 0xfed00000-0xfed003ff]
[    0.393803] pnp 00:0a: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.394596] pnp: PnP ACPI: found 11 devices
[    0.394792] ACPI: ACPI bus type pnp unregistered
[    0.394976] system 00:01: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.395141] system 00:01: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.395319] system 00:08: [io  0x0220-0x022f] has been reserved
[    0.395483] system 00:08: [io  0x040b] has been reserved
[    0.395644] system 00:08: [io  0x04d0-0x04d1] has been reserved
[    0.395806] system 00:08: [io  0x04d6] has been reserved
[    0.395967] system 00:08: [io  0x0530-0x0537] has been reserved
[    0.396138] system 00:08: [io  0x0c00-0x0c01] has been reserved
[    0.396300] system 00:08: [io  0x0c14] has been reserved
[    0.396463] system 00:08: [io  0x0c50-0x0c52] has been reserved
[    0.396626] system 00:08: [io  0x0c6c] has been reserved
[    0.396788] system 00:08: [io  0x0c6f] has been reserved
[    0.396950] system 00:08: [io  0x0cd0-0x0cd1] has been reserved
[    0.397112] system 00:08: [io  0x0cd2-0x0cd3] has been reserved
[    0.397274] system 00:08: [io  0x0cd4-0x0cd5] has been reserved
[    0.397437] system 00:08: [io  0x0cd6-0x0cd7] has been reserved
[    0.397599] system 00:08: [io  0x0cd8-0x0cdf] has been reserved
[    0.397762] system 00:08: [io  0x8000-0x805f] has been reserved
[    0.397925] system 00:08: [io  0x8100-0x81ff window] has been reserved
[    0.398089] system 00:08: [io  0x8200-0x82ff window] has been reserved
[    0.398251] system 00:08: [io  0x0f40-0x0f47] has been reserved
[    0.398414] system 00:08: [io  0x087f] has been reserved
[    0.398584] system 00:09: [mem 0x000e0000-0x000fffff] could not be reserved
[    0.398747] system 00:09: [mem 0xfff00000-0xffffffff] has been reserved
[    0.398911] system 00:09: [mem 0xffc00000-0xffefffff] has been reserved
[    0.399074] system 00:09: [mem 0xfec10000-0xfec1001f] has been reserved
[    0.399238] system 00:09: [mem 0xff800000-0xff80ffff] has been reserved
[    0.418646] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.418815] pci 0000:00:01.0:   bridge window [io  0x9000-0x9fff]
[    0.418978] pci 0000:00:01.0:   bridge window [mem 0x9fd00000-0x9fefffff]
[    0.419143] pci 0000:00:01.0:   bridge window [mem 0xa0000000-0xafffffff 64bit pref]
[    0.419389] pci 0000:00:03.0: PCI bridge to [bus 02-07]
[    0.419550] pci 0000:00:03.0:   bridge window [io  0xa000-0xbfff]
[    0.419714] pci 0000:00:03.0:   bridge window [mem 0x9f800000-0x9f9fffff]
[    0.419878] pci 0000:00:03.0:   bridge window [mem 0xc0000000-0xdfffffff 64bit pref]
[    0.420170] pci 0000:00:06.0: PCI bridge to [bus 08-08]
[    0.420366] pci 0000:00:06.0:   bridge window [io  0xc000-0xcfff]
[    0.420529] pci 0000:00:06.0:   bridge window [mem 0xf0200000-0xf02fffff]
[    0.420693] pci 0000:00:06.0:   bridge window [mem pref disabled]
[    0.420858] pci 0000:00:07.0: PCI bridge to [bus 09-0e]
[    0.421019] pci 0000:00:07.0:   bridge window [io  0xd000-0xefff]
[    0.421182] pci 0000:00:07.0:   bridge window [mem 0xf0000000-0xf01fffff]
[    0.421344] pci 0000:00:07.0:   bridge window [mem pref disabled]
[    0.421509] pci 0000:00:14.4: PCI bridge to [bus 0f-0f]
[    0.421671] pci 0000:00:14.4:   bridge window [io  disabled]
[    0.421836] pci 0000:00:14.4:   bridge window [mem disabled]
[    0.421999] pci 0000:00:14.4:   bridge window [mem pref disabled]
[    0.422197] pci 0000:00:03.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    0.422361] pci 0000:00:03.0: setting latency timer to 64
[    0.422375] pci 0000:00:06.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.422539] pci 0000:00:06.0: setting latency timer to 64
[    0.422550] pci 0000:00:07.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    0.422713] pci 0000:00:07.0: setting latency timer to 64
[    0.422727] pci_bus 0000:00: resource 4 [mem 0x000a0000-0x000bffff]
[    0.422733] pci_bus 0000:00: resource 5 [mem 0x000d0000-0x000d1fff]
[    0.422738] pci_bus 0000:00: resource 6 [mem 0x000d2000-0x000d3fff]
[    0.422743] pci_bus 0000:00: resource 7 [mem 0x000d4000-0x000d5fff]
[    0.422748] pci_bus 0000:00: resource 8 [mem 0x000d6000-0x000d7fff]
[    0.422753] pci_bus 0000:00: resource 9 [mem 0x000d8000-0x000d9fff]
[    0.422759] pci_bus 0000:00: resource 10 [mem 0x000da000-0x000dbfff]
[    0.422764] pci_bus 0000:00: resource 11 [mem 0x000dc000-0x000ddfff]
[    0.422769] pci_bus 0000:00: resource 12 [mem 0x000de000-0x000dffff]
[    0.422774] pci_bus 0000:00: resource 13 [mem 0x9e000000-0xdfffffff]
[    0.422780] pci_bus 0000:00: resource 14 [mem 0xf0000000-0xffffffff]
[    0.422785] pci_bus 0000:00: resource 15 [io  0x0000-0x0cf7]
[    0.422790] pci_bus 0000:00: resource 16 [io  0x0d00-0xffff]
[    0.422795] pci_bus 0000:01: resource 0 [io  0x9000-0x9fff]
[    0.422800] pci_bus 0000:01: resource 1 [mem 0x9fd00000-0x9fefffff]
[    0.422806] pci_bus 0000:01: resource 2 [mem 0xa0000000-0xafffffff 64bit pref]
[    0.422811] pci_bus 0000:02: resource 0 [io  0xa000-0xbfff]
[    0.422817] pci_bus 0000:02: resource 1 [mem 0x9f800000-0x9f9fffff]
[    0.422822] pci_bus 0000:02: resource 2 [mem 0xc0000000-0xdfffffff 64bit pref]
[    0.422828] pci_bus 0000:08: resource 0 [io  0xc000-0xcfff]
[    0.422833] pci_bus 0000:08: resource 1 [mem 0xf0200000-0xf02fffff]
[    0.422838] pci_bus 0000:09: resource 0 [io  0xd000-0xefff]
[    0.422843] pci_bus 0000:09: resource 1 [mem 0xf0000000-0xf01fffff]
[    0.422849] pci_bus 0000:0f: resource 4 [mem 0x000a0000-0x000bffff]
[    0.422854] pci_bus 0000:0f: resource 5 [mem 0x000d0000-0x000d1fff]
[    0.422859] pci_bus 0000:0f: resource 6 [mem 0x000d2000-0x000d3fff]
[    0.422864] pci_bus 0000:0f: resource 7 [mem 0x000d4000-0x000d5fff]
[    0.422869] pci_bus 0000:0f: resource 8 [mem 0x000d6000-0x000d7fff]
[    0.422874] pci_bus 0000:0f: resource 9 [mem 0x000d8000-0x000d9fff]
[    0.422879] pci_bus 0000:0f: resource 10 [mem 0x000da000-0x000dbfff]
[    0.422885] pci_bus 0000:0f: resource 11 [mem 0x000dc000-0x000ddfff]
[    0.422890] pci_bus 0000:0f: resource 12 [mem 0x000de000-0x000dffff]
[    0.422895] pci_bus 0000:0f: resource 13 [mem 0x9e000000-0xdfffffff]
[    0.422900] pci_bus 0000:0f: resource 14 [mem 0xf0000000-0xffffffff]
[    0.422906] pci_bus 0000:0f: resource 15 [io  0x0000-0x0cf7]
[    0.422911] pci_bus 0000:0f: resource 16 [io  0x0d00-0xffff]
[    0.423004] NET: Registered protocol family 2
[    0.423404] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.425515] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.428962] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.429940] TCP: Hash tables configured (established 262144 bind 65536)
[    0.430137] TCP reno registered
[    0.430305] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.430522] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.430979] NET: Registered protocol family 1
[    0.431194] pci 0000:00:01.0: MSI quirk detected; subordinate MSI disabled
[    0.431616] pci 0000:01:05.0: Boot video device
[    0.431632] PCI: CLS 32 bytes, default 64
[    0.431746] Trying to unpack rootfs image as initramfs...
[    1.064110] debug: unmapping init memory ffff880037244000..ffff880037ff0000
[    1.065476] PCI-DMA: Disabling AGP.
[    1.066071] PCI-DMA: aperture base @ 84000000 size 65536 KB
[    1.066233] PCI-DMA: using GART IOMMU.
[    1.066396] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    1.106838] audit: initializing netlink socket (disabled)
[    1.107058] type=2000 audit(1290557233.104:1): initialized
[    1.107862] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.121216] VFS: Disk quotas dquot_6.5.2
[    1.121715] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.122576] msgmni has been set to 7366
[    1.123848] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    1.124106] io scheduler noop registered
[    1.124264] io scheduler deadline registered
[    1.124619] io scheduler cfq registered (default)
[    1.126170] pcieport 0000:00:03.0: ACPI _OSC control granted for 0x1d
[    1.126385] pcieport 0000:00:03.0: setting latency timer to 64
[    1.126438] pcieport 0000:00:03.0: irq 40 for MSI/MSI-X
[    1.126997] pcieport 0000:00:06.0: ACPI _OSC control granted for 0x1d
[    1.127204] pcieport 0000:00:06.0: setting latency timer to 64
[    1.127246] pcieport 0000:00:06.0: irq 41 for MSI/MSI-X
[    1.127628] pcieport 0000:00:07.0: ACPI _OSC control granted for 0x1d
[    1.127832] pcieport 0000:00:07.0: setting latency timer to 64
[    1.127874] pcieport 0000:00:07.0: irq 42 for MSI/MSI-X
[    1.128572] pcieport 0000:00:03.0: Signaling PME through PCIe PME interrupt
[    1.128772] pcie_pme 0000:00:03.0:pcie01: service driver pcie_pme loaded
[    1.128812] pcieport 0000:00:06.0: Signaling PME through PCIe PME interrupt
[    1.129009] pci 0000:08:00.0: Signaling PME through PCIe PME interrupt
[    1.129173] pcie_pme 0000:00:06.0:pcie01: service driver pcie_pme loaded
[    1.129211] pcieport 0000:00:07.0: Signaling PME through PCIe PME interrupt
[    1.129410] pci 0000:09:00.0: Signaling PME through PCIe PME interrupt
[    1.129574] pcie_pme 0000:00:07.0:pcie01: service driver pcie_pme loaded
[    1.160915] Non-volatile memory driver v1.3
[    1.161227] Linux agpgart interface v0.103
[    1.161738] [drm] Initialized drm 1.1.0 20060810
[    1.162065] [drm] radeon defaulting to kernel modesetting.
[    1.162226] [drm] radeon kernel modesetting enabled.
[    1.162543] radeon 0000:01:05.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    1.162744] radeon 0000:01:05.0: setting latency timer to 64
[    1.169158] [drm] initializing kernel modesetting (RS780 0x1002:0x9612).
[    1.169456] [drm] register mmio base: 0x9FDF0000
[    1.169621] [drm] register mmio size: 65536
[    1.170172] ATOM BIOS: Acer_California
[    1.170415] radeon 0000:01:05.0: VRAM: 336M 0xC0000000 - 0xD4FFFFFF (336M used)
[    1.170689] radeon 0000:01:05.0: GTT: 512M 0xA0000000 - 0xBFFFFFFF
[    1.171170] [drm] Detected VRAM RAM=336M, BAR=256M
[    1.171340] [drm] RAM width 32bits DDR
[    1.171661] [TTM] Zone  kernel: Available graphics memory: 1885700 kiB.
[    1.171833] [TTM] Initializing pool allocator.
[    1.172431] [drm] radeon: 336M of VRAM memory ready
[    1.172625] [drm] radeon: 512M of GTT memory ready.
[    1.172905] [drm] radeon: irq initialized.
[    1.173067] [drm] GART: num cpu pages 131072, num gpu pages 131072
[    1.175792] [drm] Loading RS780 Microcode
[    1.181708] radeon 0000:01:05.0: WB enabled
[    1.215130] [drm] ring test succeeded in 0 usecs
[    1.215982] [drm] radeon: ib pool ready.
[    1.216341] [drm] ib test succeeded in 0 usecs
[    1.216527] [drm] Enabling audio support
[    1.218626] [drm] Radeon Display Connectors
[    1.218786] [drm] Connector 0:
[    1.218942] [drm]   LVDS
[    1.219099] [drm]   DDC: 0x7e50 0x7e50 0x7e54 0x7e54 0x7e58 0x7e58 0x7e5c 0x7e5c
[    1.219336] [drm]   Encoders:
[    1.219492] [drm]     LCD1: INTERNAL_KLDSCP_LVTMA
[    1.219650] [drm] Connector 1:
[    1.219805] [drm]   VGA
[    1.219961] [drm]   DDC: 0x7e40 0x7e40 0x7e44 0x7e44 0x7e48 0x7e48 0x7e4c 0x7e4c
[    1.220223] [drm]   Encoders:
[    1.220379] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
[    1.275823] [drm] radeon: power management initialized
[    2.609532] [drm] fb mappable at 0xA0141000
[    2.609724] [drm] vram apper at 0xA0000000
[    2.609881] [drm] size 4325376
[    2.610037] [drm] fb depth is 24
[    2.610193] [drm]    pitch is 5632
[    2.610621] fbcon: radeondrmfb (fb0) is primary device
[    2.693956] Console: switching to colour frame buffer device 170x48
[    2.709443] fb0: radeondrmfb frame buffer device
[    2.709563] drm: registered panic notifier
[    2.709679] [drm] Initialized radeon 2.7.0 20080528 for 0000:01:05.0 on minor 0
[    2.710058] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    2.967500] brd: module loaded
[    2.967631] ahci 0000:00:11.0: version 3.0
[    2.967700] ahci 0000:00:11.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    2.968156] ahci 0000:00:11.0: AHCI 0001.0100 32 slots 2 ports 3 Gbps 0x9 impl SATA mode
[    2.968367] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part ccc sxs 
[    2.971805] scsi0 : ahci
[    2.972472] scsi1 : ahci
[    2.972977] scsi2 : ahci
[    2.973502] scsi3 : ahci
[    2.974325] ata1: SATA max UDMA/133 abar m1024@0xf0508000 port 0xf0508100 irq 22
[    2.974515] ata2: DUMMY
[    2.974581] ata3: DUMMY
[    2.974683] ata4: SATA max UDMA/133 abar m1024@0xf0508000 port 0xf0508280 irq 22
[    2.975753] PNP: PS/2 Controller [PNP0303:KBC0,PNP0f13:MSE0] at 0x60,0x64 irq 1,12
[    2.983594] i8042.c: Detected active multiplexing controller, rev 1.1.
[    2.992746] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.997449] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[    3.002161] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[    3.006719] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[    3.011291] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[    3.016269] mice: PS/2 mouse device common for all mice
[    3.020904] rtc_cmos 00:04: RTC can wake from S4
[    3.040268] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
[    3.044774] rtc0: alarms up to one month, 114 bytes nvram, hpet irqs
[    3.044990] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    3.053971] cpuidle: using governor ladder
[    3.058427] cpuidle: using governor menu
[    3.063718] lib80211: common routines for IEEE802.11 drivers
[    3.068239] lib80211_crypt: registered algorithm 'NULL'
[    3.068244] Registering the dns_resolver key type
[    3.073556] PM: Checking hibernation image partition /dev/sda2
[    3.292098] ata4: SATA link down (SStatus 0 SControl 300)
[    3.468091] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    3.472988] ata1.00: ATA-7: INTEL SSDSA2M080G2GC, 2CV102HD, max UDMA/133
[    3.477655] ata1.00: 156301488 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    3.482709] ata1.00: configured for UDMA/133
[    3.487818] scsi 0:0:0:0: Direct-Access     ATA      INTEL SSDSA2M080 2CV1 PQ: 0 ANSI: 5
[    3.493625] PM: Hibernation image not present or could not be loaded.
[    3.493641] registered taskstats version 1
[    3.499001]   Magic number: 2:894:102
[    3.504096] rtc_cmos 00:04: setting system clock to 2010-11-24 00:07:15 UTC (1290557235)
[    3.509422] debug: unmapping init memory ffffffff8165d000..ffffffff816d0000
[    3.514647] Write protecting the kernel read-only data: 6144k
[    3.520122] debug: unmapping init memory ffff880001346000..ffff880001400000
[    3.525477] debug: unmapping init memory ffff8800015fd000..ffff880001600000
[    3.639031] ACPI Warning: For \_TZ_.THRM._PSL: Return Package type mismatch at index 0 - found [NULL Object Descriptor], expected Reference (20101013/nspredef-1059)
[    3.644571] ACPI: Expecting a [Reference] package element, found type 0
[    3.650019] ACPI: Invalid passive threshold
[    3.656232] thermal LNXTHERM:00: registered as thermal_zone0
[    3.661572] ACPI: Thermal Zone [THRM] (54 C)
[    3.685014] ACPI: acpi_idle registered with cpuidle
[    3.685099] ACPI: processor limited to max C-state 1
[    3.715712] udev: starting version 157
[    3.721389] udevd (800): /proc/800/oom_adj is deprecated, please use /proc/800/oom_score_adj instead.
[    3.896659] sd 0:0:0:0: [sda] 156301488 512-byte logical blocks: (80.0 GB/74.5 GiB)
[    3.902900] sd 0:0:0:0: [sda] Write Protect is off
[    3.908647] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.909275] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.929464]  sda: sda1 sda2 sda3 sda4
[    3.954155] sd 0:0:0:0: [sda] Attached SCSI disk
[    4.020934] usbcore: registered new interface driver usbfs
[    4.041829] usbcore: registered new interface driver hub
[    4.057115] usbcore: registered new device driver usb
[    4.073419] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    4.079754] ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    4.089886] ehci_hcd 0000:00:12.2: EHCI Host Controller
[    4.099364] ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus number 1
[    4.120789] ehci_hcd 0000:00:12.2: debug port 1
[    4.127538] ehci_hcd 0000:00:12.2: irq 17, io mem 0xf0508400
[    4.144351] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00
[    4.150647] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    4.157690] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.164556] usb usb1: Product: EHCI Host Controller
[    4.171325] usb usb1: Manufacturer: Linux 2.6.37-rc3+ ehci_hcd
[    4.178028] usb usb1: SerialNumber: 0000:00:12.2
[    4.185694] hub 1-0:1.0: USB hub found
[    4.192315] hub 1-0:1.0: 6 ports detected
[    4.199389] ehci_hcd 0000:00:13.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    4.206178] ehci_hcd 0000:00:13.2: EHCI Host Controller
[    4.212059] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 2
[    4.224299] ehci_hcd 0000:00:13.2: debug port 1
[    4.230519] ehci_hcd 0000:00:13.2: irq 19, io mem 0xf0508800
[    4.248200] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
[    4.254679] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    4.261307] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.267657] usb usb2: Product: EHCI Host Controller
[    4.274136] usb usb2: Manufacturer: Linux 2.6.37-rc3+ ehci_hcd
[    4.280447] usb usb2: SerialNumber: 0000:00:13.2
[    4.286376] hub 2-0:1.0: USB hub found
[    4.291593] hub 2-0:1.0: 6 ports detected
[    4.321192] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    4.326335] ohci_hcd 0000:00:12.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    4.331366] ohci_hcd 0000:00:12.0: OHCI Host Controller
[    4.336500] ohci_hcd 0000:00:12.0: new USB bus registered, assigned bus number 3
[    4.356132] ohci_hcd 0000:00:12.0: irq 16, io mem 0xf0304000
[    4.420123] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    4.425142] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.430078] usb usb3: Product: OHCI Host Controller
[    4.434950] usb usb3: Manufacturer: Linux 2.6.37-rc3+ ohci_hcd
[    4.439761] usb usb3: SerialNumber: 0000:00:12.0
[    4.445027] hub 3-0:1.0: USB hub found
[    4.449738] hub 3-0:1.0: 3 ports detected
[    4.454713] ohci_hcd 0000:00:12.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    4.459516] ohci_hcd 0000:00:12.1: OHCI Host Controller
[    4.464299] ohci_hcd 0000:00:12.1: new USB bus registered, assigned bus number 4
[    4.488111] ohci_hcd 0000:00:12.1: irq 16, io mem 0xf0305000
[    4.552117] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    4.556953] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.561765] usb usb4: Product: OHCI Host Controller
[    4.566536] usb usb4: Manufacturer: Linux 2.6.37-rc3+ ohci_hcd
[    4.571370] usb usb4: SerialNumber: 0000:00:12.1
[    4.576516] hub 4-0:1.0: USB hub found
[    4.581384] hub 4-0:1.0: 3 ports detected
[    4.586490] ohci_hcd 0000:00:13.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    4.591345] ohci_hcd 0000:00:13.0: OHCI Host Controller
[    4.596089] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 5
[    4.616130] ohci_hcd 0000:00:13.0: irq 18, io mem 0xf0306000
[    4.624098] usb 1-4: new high speed USB device using ehci_hcd and address 3
[    4.680110] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    4.685120] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.690001] usb usb5: Product: OHCI Host Controller
[    4.694887] usb usb5: Manufacturer: Linux 2.6.37-rc3+ ohci_hcd
[    4.699768] usb usb5: SerialNumber: 0000:00:13.0
[    4.704981] hub 5-0:1.0: USB hub found
[    4.709915] hub 5-0:1.0: 3 ports detected
[    4.801558] usb 1-4: New USB device found, idVendor=064e, idProduct=a102
[    4.806615] usb 1-4: New USB device strings: Mfr=2, Product=1, SerialNumber=3
[    4.811562] usb 1-4: Product: WebCam
[    4.816507] usb 1-4: Manufacturer: SuYin
[    4.816511] usb 1-4: SerialNumber: CN0316-S30C-OV061-VA-R02.02.02
[    4.937430] PM: Marking nosave pages: 000000000009d000 - 0000000000100000
[    4.937443] PM: Marking nosave pages: 000000008dec0000 - 0000000100000000
[    4.943949] PM: Marking nosave pages: 0000000084000000 - 0000000088000000
[    4.944601] PM: Basic memory bitmaps created
[    4.956112] usb 3-2: new full speed USB device using ohci_hcd and address 2
[    4.993655] PM: Basic memory bitmaps freed
[    5.022675] PM: Starting manual resume from disk
[    5.033411] PM: Hibernation image partition 8:2 present
[    5.033416] PM: Looking for hibernation image.
[    5.033837] PM: Image not found (code -22)
[    5.033844] PM: Hibernation image not present or could not be loaded.
[    5.137171] usb 3-2: New USB device found, idVendor=046d, idProduct=c52b
[    5.142754] usb 3-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    5.148245] usb 3-2: Product: USB Receiver
[    5.153632] usb 3-2: Manufacturer: Logitech
[    5.202969] EXT4-fs (sda3): mounted filesystem with ordered data mode. Opts: acl,user_xattr
[    5.224679] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:12.0/usb3/3-2/3-2:1.0/input/input1
[    5.228132] EXT4-fs (sda3): re-mounted. Opts: acl,user_xattr
[    5.236833] generic-usb 0003:046D:C52B.0001: input,hidraw0: USB HID v1.11 Keyboard [Logitech USB Receiver] on usb-0000:00:12.0-2/input0
[    5.248660] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:12.0/usb3/3-2/3-2:1.1/input/input2
[    5.255747] generic-usb 0003:046D:C52B.0002: input,hiddev0,hidraw1: USB HID v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:12.0-2/input1
[    5.270580] generic-usb 0003:046D:C52B.0003: hiddev0,hidraw2: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:12.0-2/input2
[    5.277290] usbcore: registered new interface driver usbhid
[    5.283813] usbhid: USB HID core driver
[    7.384160] udev: starting version 157
[    7.569519] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input3
[    7.571080] ACPI: Sleep Button [SLPB]
[    7.572739] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input4
[    7.573827] ACPI: Power Button [PWRB]
[    7.574955] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input5
[    7.576311] ACPI: Lid Switch [LID]
[    7.578865] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input6
[    7.598567] ACPI: Power Button [PWRF]
[    7.659164] ACPI: Battery Slot [BAT1] (battery present)
[    7.662699] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    7.697318] ACPI: AC Adapter [ACAD] (on-line)
[    7.735085] atl1c 0000:08:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    7.735103] atl1c 0000:08:00.0: setting latency timer to 64
[    7.737619] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    7.802083] acpi device:2e: registered as cooling_device2
[    7.815908] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:2d/LNXVIDEO:02/input/input7
[    7.821769] ACPI: Video Device [VGA2] (multi-head: yes  rom: no  post: no)
[    7.836267] wmi: Mapper loaded
[    7.861165] atl1c 0000:08:00.0: version 1.0.1.0-NAPI
[    7.960641] cfg80211: Calling CRDA to update world regulatory domain
[    7.970941] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    8.195431] cfg80211: World regulatory domain updated:
[    8.195438]     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[    8.195443]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    8.195449]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[    8.195453]     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[    8.195458]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    8.195463]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    8.274607] piix4_smbus 0000:00:14.0: SMBus Host Controller at 0x8040, revision 0
[    8.278119] k8temp 0000:00:18.3: Temperature readouts might be wrong - check erratum #141
[    8.767898] ath9k 0000:09:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    8.777038] ath9k 0000:09:00.0: setting latency timer to 64
[    8.777257] HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    8.857619] hda_codec: ALC272X: BIOS auto-probing.
[    8.872109] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:14.2/input/input8
[    8.887866] input: HDA ATI SB Mic as /devices/pci0000:00/0000:00:14.2/sound/card0/input9
[    8.898159] input: HDA ATI SB Headphone as /devices/pci0000:00/0000:00:14.2/sound/card0/input10
[    9.241248] ath: EEPROM regdomain: 0x65
[    9.241254] ath: EEPROM indicates we should expect a direct regpair map
[    9.241262] ath: Country alpha2 being used: 00
[    9.241266] ath: Regpair used: 0x65
[    9.264541] ieee80211 phy0: Selected rate control algorithm 'ath9k_rate_control'
[    9.266208] Registered led device: ath9k-phy0::radio
[    9.266450] Registered led device: ath9k-phy0::assoc
[    9.266711] Registered led device: ath9k-phy0::tx
[    9.266954] Registered led device: ath9k-phy0::rx
[    9.266971] ieee80211 phy0: Atheros AR9280 Rev:2 mem=0xffffc90002920000, irq=19
[    9.413976] input: ImPS/2 Generic Wheel Mouse as /devices/platform/i8042/serio2/input/input11
[    9.467393] Adding 4192252k swap on /dev/sda2.  Priority:-1 extents:1 across:4192252k SS
[    9.629972] device-mapper: uevent: version 1.0.3
[    9.638855] device-mapper: ioctl: 4.18.0-ioctl (2010-06-29) initialised: dm-devel@redhat.com
[    9.834696] loop: module loaded
[    9.956866] EXT3-fs: barriers not enabled
[    9.964148] kjournald starting.  Commit interval 5 seconds
[    9.971107] EXT3-fs (sda1): using internal journal
[    9.977851] EXT3-fs (sda1): mounted filesystem with ordered data mode
[    9.994712] EXT4-fs (sda4): mounted filesystem with ordered data mode. Opts: acl,user_xattr
[   10.106697] fuse init (API version 7.15)
[   10.994614] powernow-k8: Found 1 AMD Athlon(tm) X2 Dual Core Processor L310 (2 cpu cores) (version 2.20.00)
[   11.000369] [Firmware Bug]: powernow-k8: No compatible ACPI _PSS objects found.
[   11.000373] [Firmware Bug]: powernow-k8: Try again with latest BIOS.
[   12.426979] BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
[   13.154301] atl1c 0000:08:00.0: irq 43 for MSI/MSI-X
[   13.434060] NET: Registered protocol family 17
[   24.342287] radeon 0000:01:05.0: r600_cs_track_validate_cb offset[0] 0 46097920 4325376 too big
[   24.342298] radeon 0000:01:05.0: r600_packet3_check:1331 invalid cmd stream 502
[   24.342304] [drm:radeon_cs_ioctl] *ERROR* Invalid command stream !
[   24.694106] [drm:drm_mode_getfb] *ERROR* invalid framebuffer id
[   93.938946] radeon 0000:01:05.0: r600_cs_track_validate_cb offset[0] 0 46097920 4325376 too big
[   93.938956] radeon 0000:01:05.0: r600_packet3_check:1331 invalid cmd stream 502
[   93.938962] [drm:radeon_cs_ioctl] *ERROR* Invalid command stream !
[   94.278050] [drm:drm_mode_getfb] *ERROR* invalid framebuffer id
[  114.898043] radeon 0000:01:05.0: r600_cs_track_validate_cb offset[0] 0 46097920 4325376 too big
[  114.898053] radeon 0000:01:05.0: r600_packet3_check:1331 invalid cmd stream 502
[  114.898058] [drm:radeon_cs_ioctl] *ERROR* Invalid command stream !
[  115.266113] [drm:drm_mode_getfb] *ERROR* invalid framebuffer id
[  129.722472] [drm:drm_mode_getfb] *ERROR* invalid framebuffer id
[  142.984314] radeon 0000:01:05.0: r600_cs_track_validate_cb offset[0] 0 46097920 4325376 too big
[  142.984324] radeon 0000:01:05.0: r600_packet3_check:1331 invalid cmd stream 502
[  142.984330] [drm:radeon_cs_ioctl] *ERROR* Invalid command stream !
[  143.370083] [drm:drm_mode_getfb] *ERROR* invalid framebuffer id

--Boundary-00=_JrF7MJVFVLvabzt--

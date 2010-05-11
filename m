Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007Ab0EKIBl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 04:01:41 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:49519 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441Ab0EKIBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 04:01:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=GBh0lioWEnoojx8LViY4t4WUOc/sVgv/wk0HG7dh5h2axLtZj628O1OlmuJmWb/9Z9
         7jyAKhwR88yODN0d2TbTqv+Pg4TfBoOXeiIBBO2rUlesYW3WZEt0Pd/HbBewBT5qImB5
         8bv5+IoTvErJRp0rzHzakUimTYBQkjWUENOfo=
Message-ID: <4BE90ED7.4090003@gmail.com>
Date: Tue, 11 May 2010 01:01:27 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Michael Poole <mdpoole@troilus.org>, linux-bluetooth@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: magicmouse: claimed by neither input, hiddev nor hidraw
References: <j2idd18b0c31005101341o43b652c1zf8729f5f9a60e0d3@mail.gmail.com> <alpine.LRH.2.00.1005102334140.14809@twin.jikos.cz> <s2odd18b0c31005101439v22d03bfdw4e65d7c4b8315b6a@mail.gmail.com> <alpine.LNX.2.00.1005102351220.28092@pobox.suse.cz> <4BE8859E.3090305@gmail.com> <87mxw7i33j.fsf@troilus.org> <4BE8C7CD.7030206@gmail.com> <alpine.LNX.2.00.1005110946520.28092@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1005110946520.28092@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

here is dmesg with the:
[   27.435674] magicmouse 0005:05AC:030D.0004: claimed by neither input, 
hiddev nor hidraw
[   27.435686] magicmouse 0005:05AC:030D.0004: magicmouse hw start failed




[    0.000000] Linux version 2.6.33-00095-g28918c2 (name@name) (gcc 
version 4.4.2 (GCC) ) #19 SMP Tue May 11 00:49:25 PDT 2010
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz root=/dev/sda3 ro 
debug audit=1 selinux=1 vga=790 enforcing=0
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003f0ea000 (usable)
[    0.000000]  BIOS-e820: 000000003f0ea000 - 000000003f2eb000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003f2eb000 - 000000003febe000 (ACPI data)
[    0.000000]  BIOS-e820: 000000003febe000 - 000000003feef000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003feef000 - 000000003ff00000 (ACPI data)
[    0.000000]  BIOS-e820: 000000003ff00000 - 0000000040000000 (reserved)
[    0.000000]  BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x3f0ea max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-DFFFF uncachable
[    0.000000]   E0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0FFE00000 mask FFFE00000 write-protect
[    0.000000]   1 base 000000000 mask FC0000000 write-back
[    0.000000]   2 base 03FF00000 mask FFFF00000 uncachable
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 
0x7010600070106
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-000000003f0ea000
[    0.000000]  0000000000 - 003f000000 page 2M
[    0.000000]  003f000000 - 003f0ea000 page 4k
[    0.000000] kernel direct mapping tables up to 3f0ea000 @ 8000-b000
[    0.000000] ACPI: RSDP 00000000000fe020 00024 (v02 APPLE )
[    0.000000] ACPI: XSDT 000000003fefd1c0 00074 (v01 APPLE   Apple00 
000000A5      01000013)
[    0.000000] ACPI: FACP 000000003fefb000 000F4 (v03 APPLE   Apple00 
000000A5 Loki 0000005F)
[    0.000000] ACPI: DSDT 000000003fef0000 048D1 (v01 APPLE  MacBookP 
00020002 INTL 20050309)
[    0.000000] ACPI: FACS 000000003fec0000 00040
[    0.000000] ACPI: HPET 000000003fefa000 00038 (v01 APPLE   Apple00 
00000001 Loki 0000005F)
[    0.000000] ACPI: APIC 000000003fef9000 00068 (v01 APPLE   Apple00 
00000001 Loki 0000005F)
[    0.000000] ACPI: MCFG 000000003fef8000 0003C (v01 APPLE   Apple00 
00000001 Loki 0000005F)
[    0.000000] ACPI: ASF! 000000003fef7000 000A0 (v32 APPLE   Apple00 
00000001 Loki 0000005F)
[    0.000000] ACPI: SBST 000000003fef6000 00030 (v01 APPLE   Apple00 
00000001 Loki 0000005F)
[    0.000000] ACPI: ECDT 000000003fef5000 00053 (v01 APPLE   Apple00 
00000001 Loki 0000005F)
[    0.000000] ACPI: SSDT 000000003feef000 004DC (v01 APPLE     CpuPm 
00003000 INTL 20050309)
[    0.000000] ACPI: SSDT 000000003febd000 0064F (v01 SataRe  SataPri 
00001000 INTL 20050309)
[    0.000000] ACPI: SSDT 000000003febc000 0069C (v01 SataRe  SataSec 
00001000 INTL 20050309)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] (7 early reservations) ==> bootmem [0000000000 - 003f0ea000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> 
[0000000000 - 0000001000]
[    0.000000]   #1 [0001000000 - 00017a36c8]    TEXT DATA BSS ==> 
[0001000000 - 00017a36c8]
[    0.000000]   #2 [000009fc00 - 0000100000]    BIOS reserved ==> 
[000009fc00 - 0000100000]
[    0.000000]   #3 [00017a4000 - 00017a4271]              BRK ==> 
[00017a4000 - 00017a4271]
[    0.000000]   #4 [0000001000 - 0000003000]       TRAMPOLINE ==> 
[0000001000 - 0000003000]
[    0.000000]   #5 [0000003000 - 0000007000]      ACPI WAKEUP ==> 
[0000003000 - 0000007000]
[    0.000000]   #6 [0000008000 - 0000009000]          PGTABLE ==> 
[0000008000 - 0000009000]
[    0.000000]  [ffffea0000000000-ffffea0000dfffff] PMD -> 
[ffff880001c00000-ffff8800029fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00100000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0003f0ea
[    0.000000] On node 0 totalpages: 258185
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 104 pages reserved
[    0.000000]   DMA zone: 3839 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 3476 pages used for memmap
[    0.000000]   DMA32 zone: 250710 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 
0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 
00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 
00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 
0000000000100000
[    0.000000] Allocating PCI resources starting at 40000000 (gap: 
40000000:b0000000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 
nr_node_ids:1
[    0.000000] PERCPU: Embedded 30 pages/cpu @ffff880001800000 s91096 
r8192 d23592 u1048576
[    0.000000] pcpu-alloc: s91096 r8192 d23592 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on. 
Total pages: 254549
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz 
root=/dev/sda3 ro debug audit=1 selinux=1 vga=790 enforcing=0
[    0.000000] audit: enabled (after initialization)
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 8, 
1048576 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 7, 524288 
bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 1007964k/1033128k available (3997k kernel code, 
388k absent, 24084k reserved, 2503k data, 504k init)
[    0.000000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, 
CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:320
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration failed
[    0.000000] TSC: Unable to calibrate against PIT
[    0.000000] TSC: using HPET reference calibration
[    0.000000] Detected 2161.241 MHz processor.
[    0.004007] Calibrating delay loop (skipped), value calculated using 
timer frequency.. 4322.48 BogoMIPS (lpj=2161241)
[    0.004080] Security Framework initialized
[    0.004091] SELinux:  Initializing.
[    0.004123] SELinux:  Starting in permissive mode
[    0.004142] Mount-cache hash table entries: 256
[    0.005619] CPU: Physical Processor ID: 0
[    0.005624] CPU: Processor Core ID: 0
[    0.005630] mce: CPU supports 6 MCE banks
[    0.005655] CPU0: Thermal monitoring enabled (TM2)
[    0.005662] using mwait in idle threads.
[    0.005667] Performance Events: Core2 events, Intel PMU driver.
[    0.005677] ... version:                2
[    0.005682] ... bit width:              40
[    0.005686] ... generic registers:      2
[    0.005691] ... value mask:             000000ffffffffff
[    0.005696] ... max period:             000000007fffffff
[    0.005701] ... fixed-purpose events:   3
[    0.005706] ... event mask:             0000000700000003
[    0.006919] ACPI: Core revision 20091214
[    0.030203] Setting APIC routing to flat
[    0.030591] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.040636] CPU0: Intel(R) Core(TM)2 CPU         T7400  @ 2.16GHz 
stepping 06
[    0.040999] Booting Node   0, Processors  #1 Ok.
[    0.112042] Brought up 2 CPUs
[    0.112051] Total of 2 processors activated (8644.79 BogoMIPS).
[    0.114299] NET: Registered protocol family 16
[    0.116077] ACPI: bus type pci registered
[    0.116172] PCI: Using configuration type 1 for base access
[    0.132295] bio: create slab <bio-0> at 0
[    0.135069] ACPI: EC: EC description table is found, configuring boot EC
[    0.143361] ACPI: BIOS _OSI(Linux) query ignored
[    0.144603] ACPI: Interpreter enabled
[    0.144611] ACPI: (supports S0 S3 S4 S5)
[    0.144715] ACPI: Using IOAPIC for interrupt routing
[    0.178270] ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
[    0.180074] ACPI: No dock devices found.
[    0.183463] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.183584] pci_root PNP0A08:00: ignoring host bridge windows from 
ACPI; boot with "pci=use_crs" to use them
[    0.188651] pci_root PNP0A08:00: host bridge window [io 
0x0000-0x0cf7] (ignored)
[    0.188660] pci_root PNP0A08:00: host bridge window [io 
0x0d00-0xffff] (ignored)
[    0.188669] pci_root PNP0A08:00: host bridge window [mem 
0x000a0000-0x000bffff] (ignored)
[    0.188679] pci_root PNP0A08:00: host bridge window [mem 
0x40000000-0xfebfffff] (ignored)
[    0.188786] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.188793] pci 0000:00:01.0: PME# disabled
[    0.188831] pci 0000:00:07.0: reg 10: [mem 0x50404000-0x50404fff]
[    0.188933] pci 0000:00:1b.0: reg 10: [mem 0x50400000-0x50403fff 64bit]
[    0.189004] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.189012] pci 0000:00:1b.0: PME# disabled
[    0.189118] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.189127] pci 0000:00:1c.0: PME# disabled
[    0.189236] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.189244] pci 0000:00:1c.1: PME# disabled
[    0.189353] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.189362] pci 0000:00:1c.2: PME# disabled
[    0.189437] pci 0000:00:1d.0: reg 20: [io  0x4080-0x409f]
[    0.189510] pci 0000:00:1d.1: reg 20: [io  0x4060-0x407f]
[    0.189583] pci 0000:00:1d.2: reg 20: [io  0x4040-0x405f]
[    0.189664] pci 0000:00:1d.3: reg 20: [io  0x4020-0x403f]
[    0.189735] pci 0000:00:1d.7: reg 10: [mem 0x50405400-0x504057ff]
[    0.189803] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.189812] pci 0000:00:1d.7: PME# disabled
[    0.189992] pci 0000:00:1f.0: quirk: [io  0x0400-0x047f] claimed by 
ICH6 ACPI/GPIO/TCO
[    0.190004] pci 0000:00:1f.0: quirk: [io  0x0500-0x053f] claimed by 
ICH6 GPIO
[    0.190012] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 
0680 (mask 000f)
[    0.190022] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 
1640 (mask 000f)
[    0.190035] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 4 PIO at 
0300 (mask 001f)
[    0.190132] pci 0000:00:1f.1: reg 10: [io  0x40d8-0x40df]
[    0.190144] pci 0000:00:1f.1: reg 14: [io  0x40ec-0x40ef]
[    0.190155] pci 0000:00:1f.1: reg 18: [io  0x40d0-0x40d7]
[    0.190166] pci 0000:00:1f.1: reg 1c: [io  0x40e8-0x40eb]
[    0.190177] pci 0000:00:1f.1: reg 20: [io  0x40b0-0x40bf]
[    0.190238] pci 0000:00:1f.2: reg 10: [io  0x40c8-0x40cf]
[    0.190250] pci 0000:00:1f.2: reg 14: [io  0x40e4-0x40e7]
[    0.190261] pci 0000:00:1f.2: reg 18: [io  0x40c0-0x40c7]
[    0.190272] pci 0000:00:1f.2: reg 1c: [io  0x40e0-0x40e3]
[    0.190283] pci 0000:00:1f.2: reg 20: [io  0x40a0-0x40af]
[    0.190295] pci 0000:00:1f.2: reg 24: [mem 0x50405000-0x504053ff]
[    0.190329] pci 0000:00:1f.2: PME# supported from D3hot
[    0.190337] pci 0000:00:1f.2: PME# disabled
[    0.190407] pci 0000:00:1f.3: reg 20: [io  0xefa0-0xefbf]
[    0.190485] pci 0000:01:00.0: reg 10: [mem 0x40000000-0x47ffffff pref]
[    0.190497] pci 0000:01:00.0: reg 14: [io  0x3000-0x30ff]
[    0.190509] pci 0000:01:00.0: reg 18: [mem 0x50300000-0x5030ffff]
[    0.190531] pci 0000:01:00.0: reg 30: [mem 0xfffe0000-0xffffffff pref]
[    0.190561] pci 0000:01:00.0: supports D1 D2
[    0.190626] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.190633] pci 0000:00:01.0:   bridge window [io  0x3000-0x3fff]
[    0.190640] pci 0000:00:01.0:   bridge window [mem 0x50300000-0x503fffff]
[    0.190649] pci 0000:00:01.0:   bridge window [mem 
0x40000000-0x47ffffff 64bit pref]
[    0.190723] pci 0000:02:00.0: reg 10: [mem 0x50200000-0x50203fff 64bit]
[    0.190738] pci 0000:02:00.0: reg 18: [io  0x2000-0x20ff]
[    0.190777] pci 0000:02:00.0: reg 30: [mem 0xfffe0000-0xffffffff pref]
[    0.190836] pci 0000:02:00.0: supports D1 D2
[    0.190841] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.190851] pci 0000:02:00.0: PME# disabled
[    0.190918] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.190926] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.190935] pci 0000:00:1c.0:   bridge window [mem 0x50200000-0x502fffff]
[    0.191017] pci 0000:03:00.0: reg 10: [mem 0x50100000-0x5010ffff 64bit]
[    0.191114] pci 0000:03:00.0: supports D1
[    0.191119] pci 0000:03:00.0: PME# supported from D0 D1 D3hot
[    0.191129] pci 0000:03:00.0: PME# disabled
[    0.191205] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.191216] pci 0000:00:1c.1:   bridge window [mem 0x50100000-0x501fffff]
[    0.191291] pci 0000:00:1c.2: PCI bridge to [bus 04-0b]
[    0.191299] pci 0000:00:1c.2:   bridge window [io  0x1000-0x1fff]
[    0.191308] pci 0000:00:1c.2:   bridge window [mem 0x4c100000-0x500fffff]
[    0.191320] pci 0000:00:1c.2:   bridge window [mem 
0x48000000-0x4bffffff 64bit pref]
[    0.191385] pci 0000:0c:03.0: reg 10: [mem 0x4c004000-0x4c0047ff]
[    0.191398] pci 0000:0c:03.0: reg 14: [mem 0x4c000000-0x4c003fff]
[    0.191466] pci 0000:0c:03.0: supports D1 D2
[    0.191471] pci 0000:0c:03.0: PME# supported from D0 D1 D2 D3hot
[    0.191481] pci 0000:0c:03.0: PME# disabled
[    0.191548] pci 0000:00:1e.0: PCI bridge to [bus 0c-0c] (subtractive 
decode)
[    0.191560] pci 0000:00:1e.0:   bridge window [mem 0x4c000000-0x4c0fffff]
[    0.191599] pci_bus 0000:00: on NUMA node 0
[    0.191610] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.192869] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEGP._PRT]
[    0.193290] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.193699] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    0.194113] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
[    0.194586] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
[    0.228230] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 
14 15) *11
[    0.228564] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 *11 12 
14 15)
[    0.228902] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12 
14 15) *11
[    0.229239] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 *11 12 
14 15)
[    0.229568] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 
14 15) *0, disabled.
[    0.229907] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 
14 15) *0, disabled.
[    0.230249] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 *10 12 
14 15)
[    0.230581] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *11 12 14 15)
[    0.231100] vgaarb: device added: 
PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.231100] vgaarb: loaded
[    0.232081] SCSI subsystem initialized
[    0.232081] libata version 3.00 loaded.
[    0.232110] usbcore: registered new interface driver usbfs
[    0.232110] usbcore: registered new interface driver hub
[    0.233021] usbcore: registered new device driver usb
[    0.233096] PCI: Using ACPI for IRQ routing
[    0.233096] PCI: pci_cache_line_size set to 64 bytes
[    0.234251] cfg80211: Calling CRDA to update world regulatory domain
[    0.235029] NetLabel: Initializing
[    0.235029] NetLabel:  domain hash size = 128
[    0.235029] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.235071] NetLabel:  unlabeled traffic allowed by default
[    0.235082] HPET: 3 timers in total, 0 timers will be used for 
per-cpu timer
[    0.235093] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.235101] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.238007] Switching to clocksource tsc
[    0.249831] pnp: PnP ACPI init
[    0.249886] ACPI: bus type pnp registered
[    0.256306] pnp 00:07: disabling [io  0x1640-0x164f] because it 
overlaps 0000:00:1c.2 BAR 7 [io  0x1000-0x1fff]
[    0.261321] pnp: PnP ACPI: found 9 devices
[    0.261327] ACPI: ACPI bus type pnp unregistered
[    0.261347] system 00:01: [mem 0xf0000000-0xf3ffffff] has been reserved
[    0.261356] system 00:01: [mem 0xfed14000-0xfed17fff] has been reserved
[    0.261363] system 00:01: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.261371] system 00:01: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.261379] system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.261387] system 00:01: [mem 0xfed20000-0xfed8ffff] has been reserved
[    0.261401] system 00:05: [mem 0xfed00000-0xfed003ff] has been reserved
[    0.261415] system 00:07: [io  0x0680-0x06ef] has been reserved
[    0.261423] system 00:07: [io  0x0800-0x080f] has been reserved
[    0.261430] system 00:07: [io  0x0810-0x0817] has been reserved
[    0.261437] system 00:07: [io  0x0400-0x047f] has been reserved
[    0.261445] system 00:07: [io  0x0500-0x053f] has been reserved
[    0.267603] pci 0000:01:00.0: no compatible bridge window for [mem 
0xfffe0000-0xffffffff pref]
[    0.267615] pci 0000:02:00.0: no compatible bridge window for [mem 
0xfffe0000-0xffffffff pref]
[    0.267679] pci 0000:00:1c.0: BAR 9: assigned [mem 
0x50500000-0x506fffff pref]
[    0.267689] pci 0000:00:1c.1: BAR 9: assigned [mem 
0x50700000-0x508fffff 64bit pref]
[    0.267699] pci 0000:00:1c.1: BAR 7: assigned [io  0x5000-0x5fff]
[    0.267707] pci 0000:01:00.0: BAR 6: assigned [mem 
0x50320000-0x5033ffff pref]
[    0.267716] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.267722] pci 0000:00:01.0:   bridge window [io  0x3000-0x3fff]
[    0.267730] pci 0000:00:01.0:   bridge window [mem 0x50300000-0x503fffff]
[    0.267738] pci 0000:00:01.0:   bridge window [mem 
0x40000000-0x47ffffff 64bit pref]
[    0.267750] pci 0000:02:00.0: BAR 6: assigned [mem 
0x50500000-0x5051ffff pref]
[    0.267759] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.267766] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.267776] pci 0000:00:1c.0:   bridge window [mem 0x50200000-0x502fffff]
[    0.267785] pci 0000:00:1c.0:   bridge window [mem 
0x50500000-0x506fffff pref]
[    0.267798] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.267805] pci 0000:00:1c.1:   bridge window [io  0x5000-0x5fff]
[    0.267815] pci 0000:00:1c.1:   bridge window [mem 0x50100000-0x501fffff]
[    0.267824] pci 0000:00:1c.1:   bridge window [mem 
0x50700000-0x508fffff 64bit pref]
[    0.267838] pci 0000:00:1c.2: PCI bridge to [bus 04-0b]
[    0.267845] pci 0000:00:1c.2:   bridge window [io  0x1000-0x1fff]
[    0.267855] pci 0000:00:1c.2:   bridge window [mem 0x4c100000-0x500fffff]
[    0.267864] pci 0000:00:1c.2:   bridge window [mem 
0x48000000-0x4bffffff 64bit pref]
[    0.267878] pci 0000:00:1e.0: PCI bridge to [bus 0c-0c]
[    0.267883] pci 0000:00:1e.0:   bridge window [io  disabled]
[    0.267893] pci 0000:00:1e.0:   bridge window [mem 0x4c000000-0x4c0fffff]
[    0.267901] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    0.267928] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.267936] pci 0000:00:01.0: setting latency timer to 64
[    0.267951] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.267960] pci 0000:00:1c.0: setting latency timer to 64
[    0.267974] pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.267983] pci 0000:00:1c.1: setting latency timer to 64
[    0.267998] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.268007] pci 0000:00:1c.2: setting latency timer to 64
[    0.268183] pci 0000:00:1e.0: power state changed by ACPI to D0
[    0.268194] pci 0000:00:1e.0: setting latency timer to 64
[    0.268202] pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
[    0.268208] pci_bus 0000:00: resource 1 [mem 
0x00000000-0xffffffffffffffff]
[    0.268215] pci_bus 0000:01: resource 0 [io  0x3000-0x3fff]
[    0.268220] pci_bus 0000:01: resource 1 [mem 0x50300000-0x503fffff]
[    0.268227] pci_bus 0000:01: resource 2 [mem 0x40000000-0x47ffffff 
64bit pref]
[    0.268235] pci_bus 0000:02: resource 0 [io  0x2000-0x2fff]
[    0.268241] pci_bus 0000:02: resource 1 [mem 0x50200000-0x502fffff]
[    0.268247] pci_bus 0000:02: resource 2 [mem 0x50500000-0x506fffff pref]
[    0.268253] pci_bus 0000:03: resource 0 [io  0x5000-0x5fff]
[    0.268258] pci_bus 0000:03: resource 1 [mem 0x50100000-0x501fffff]
[    0.268264] pci_bus 0000:03: resource 2 [mem 0x50700000-0x508fffff 
64bit pref]
[    0.268273] pci_bus 0000:04: resource 0 [io  0x1000-0x1fff]
[    0.268278] pci_bus 0000:04: resource 1 [mem 0x4c100000-0x500fffff]
[    0.268285] pci_bus 0000:04: resource 2 [mem 0x48000000-0x4bffffff 
64bit pref]
[    0.268293] pci_bus 0000:0c: resource 1 [mem 0x4c000000-0x4c0fffff]
[    0.268299] pci_bus 0000:0c: resource 3 [io  0x0000-0xffff]
[    0.268305] pci_bus 0000:0c: resource 4 [mem 
0x00000000-0xffffffffffffffff]
[    0.268344] NET: Registered protocol family 2
[    0.268447] IP route cache hash table entries: 32768 (order: 6, 
262144 bytes)
[    0.269006] TCP established hash table entries: 131072 (order: 9, 
2097152 bytes)
[    0.270072] TCP bind hash table entries: 65536 (order: 9, 2097152 bytes)
[    0.271493] TCP: Hash tables configured (established 131072 bind 65536)
[    0.271502] TCP reno registered
[    0.271515] UDP hash table entries: 512 (order: 3, 49152 bytes)
[    0.271555] UDP-Lite hash table entries: 512 (order: 3, 49152 bytes)
[    0.271820] NET: Registered protocol family 1
[    0.272046] pci 0000:01:00.0: Boot video device
[    0.272069] PCI: CLS mismatch (256 != 64), using 64 bytes
[    0.276213] microcode: CPU0 sig=0x6f6, pf=0x20, revision=0xc7
[    0.276228] microcode: CPU1 sig=0x6f6, pf=0x20, revision=0xc7
[    0.276371] microcode: Microcode Update Driver: v2.00 
<tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.278331] Initializing RT-Tester: OK
[    0.278488] audit: initializing netlink socket (enabled)
[    0.278520] type=2000 audit(1273564311.277:1): initialized
[    0.289010] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.312491] ROMFS MTD (C) 2007 Red Hat, Inc.
[    0.312849] fuse init (API version 7.13)
[    0.313639] msgmni has been set to 1970
[    0.314039] SELinux:  Registering netfilter hooks
[    0.315444] alg: No test for stdrng (krng)
[    0.315473] io scheduler noop registered
[    0.316055] io scheduler cfq registered (default)
[    0.317292] vesafb: framebuffer at 0x40000000, mapped to 
0xffffc90000100000, using 3072k, total 3072k
[    0.317302] vesafb: mode is 1024x768x32, linelength=4096, pages=0
[    0.317308] vesafb: scrolling: redraw
[    0.317313] vesafb: Truecolor: size=0:8:8:8, shift=0:16:8:0
[    0.365593] Console: switching to colour frame buffer device 128x48
[    0.409799] fb0: VESA VGA frame buffer device
[    0.427032] Linux agpgart interface v0.103
[    0.430944] loop: module loaded
[    0.431433] input: Macintosh mouse button emulation as 
/devices/virtual/input/input0
[    0.433482] ata_piix 0000:00:1f.1: version 2.13
[    0.434018] ata_piix 0000:00:1f.1: power state changed by ACPI to D0
[    0.434600] ata_piix 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) 
-> IRQ 18
[    0.435295] ata_piix 0000:00:1f.1: setting latency timer to 64
[    0.435933] scsi0 : ata_piix
[    0.437058] scsi1 : ata_piix
[    0.439950] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x40b0 
irq 14
[    0.440578] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x40b8 
irq 15
[    0.441243] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) 
-> IRQ 19
[    0.441974] ata_piix 0000:00:1f.2: MAP [ P0 P2 -- -- ]
[    0.592917] ata_piix 0000:00:1f.2: setting latency timer to 64
[    0.593624] scsi2 : ata_piix
[    0.594249] scsi3 : ata_piix
[    0.599362] ata3: SATA max UDMA/133 cmd 0x40c8 ctl 0x40e4 bmdma 
0x40a0 irq 19
[    0.606272] ata1.00: ATAPI: MATSHITADVD-R   UJ-857D, KCV9, max UDMA/66
[    0.612186] ata1.00: configured for UDMA/66
[    0.614239] scsi 0:0:0:0: CD-ROM            MATSHITA DVD-R   UJ-857D 
  KCV9 PQ: 0 ANSI: 5
[    0.618804] sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
[    0.618808] Uniform CD-ROM driver Revision: 3.20
[    0.619234] sr 0:0:0:0: Attached scsi CD-ROM sr0
[    0.619570] sr 0:0:0:0: Attached scsi generic sg0 type 5
[    0.672582] ata4: SATA max UDMA/133 cmd 0x40c0 ctl 0x40e0 bmdma 
0x40a8 irq 19
[    0.683734] usbcore: registered new interface driver usblcd
[    0.695028] usbcore: registered new interface driver usbled
[    0.706743] PNP: No PS/2 controller found. Probing ports directly.
[    0.719281] i8042.c: No controller found.
[    0.731646] mice: PS/2 mouse device common for all mice
[    0.744183] Linux video capture interface: v2.00
[    0.758609] device-mapper: ioctl: 4.16.0-ioctl (2009-11-05) 
initialised: dm-devel@redhat.com
[    0.772251] EDAC MC: Ver: 2.1.0 May 11 2010
[    0.786504] cpuidle: using governor ladder
[    0.800663] cpuidle: using governor menu
[    0.819254] usbcore: registered new interface driver hiddev
[    0.845104] usbcore: registered new interface driver usbhid
[    0.860799] usbhid: USB HID core driver
[    0.876015] oprofile: using NMI interrupt.
[    0.891376] ata3.01: ATA-8: FUJITSU MHW2120BH, 00810013, max UDMA/100
[    0.891695] IPVS: Registered protocols (TCP, AH, ESP)
[    0.891924] IPVS: Connection hash table configured (size=4096, 
memory=64Kbytes)
[    0.891971] IPVS: ipvs loaded.
[    0.892225] Initializing XFRM netlink socket
[    0.892244] NET: Registered protocol family 17
[    0.892301] NET: Registered protocol family 15
[    0.892303] lib80211: common routines for IEEE802.11 drivers
[    0.892306] lib80211_crypt: registered algorithm 'NULL'
[    0.892821] No TPM chip found, activating TPM-bypass!
[    1.047840] ata3.01: 234441648 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    1.067656] ata3.01: configured for UDMA/100
[    1.083567] scsi 2:0:1:0: Direct-Access     ATA      FUJITSU MHW2120B 
0081 PQ: 0 ANSI: 5
[    1.100377] sd 2:0:1:0: [sda] 234441648 512-byte logical blocks: (120 
GB/111 GiB)
[    1.100545] sd 2:0:1:0: Attached scsi generic sg1 type 0
[    1.133413] sd 2:0:1:0: [sda] Write Protect is off
[    1.149624] sd 2:0:1:0: [sda] Mode Sense: 00 3a 00 00
[    1.165896] sd 2:0:1:0: [sda] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[    1.182967]  sda: sda1 sda2 sda3 sda4
[    1.270559] sd 2:0:1:0: [sda] Attached SCSI disk
[    1.344159] EXT4-fs (sda3): mounted filesystem with ordered data mode
[    1.361097] VFS: Mounted root (ext4 filesystem) readonly on device 8:3.
[    1.378046] Freeing unused kernel memory: 504k freed
[    1.926899] SELinux: 8192 avtab hash slots, 175799 rules.
[    2.095133] SELinux: 8192 avtab hash slots, 175799 rules.
[    2.473851] SELinux:  7 users, 14 roles, 3026 types, 119 bools, 1 
sens, 256 cats
[    2.490458] SELinux:  77 classes, 175799 rules
[    2.517920] SELinux:  Completing initialization.
[    2.534250] SELinux:  Setting up existing superblocks.
[    2.550371] SELinux: initialized (dev sda3, type ext4), uses xattr
[    2.567134] SELinux: initialized (dev securityfs, type securityfs), 
uses genfs_contexts
[    2.583746] SELinux: initialized (dev selinuxfs, type selinuxfs), 
uses genfs_contexts
[    2.600372] SELinux: initialized (dev mqueue, type mqueue), uses 
transition SIDs
[    2.616955] SELinux: initialized (dev hugetlbfs, type hugetlbfs), 
uses transition SIDs
[    2.633622] SELinux: initialized (dev devpts, type devpts), uses 
transition SIDs
[    2.649964] SELinux: initialized (dev inotifyfs, type inotifyfs), 
uses genfs_contexts
[    2.666100] SELinux: initialized (dev anon_inodefs, type 
anon_inodefs), uses genfs_contexts
[    2.682442] SELinux: initialized (dev pipefs, type pipefs), uses task 
SIDs
[    2.698997] SELinux: initialized (dev debugfs, type debugfs), uses 
genfs_contexts
[    2.716410] SELinux: initialized (dev sockfs, type sockfs), uses task 
SIDs
[    2.733275] SELinux: initialized (dev tmpfs, type tmpfs), uses 
transition SIDs
[    2.750141] SELinux: initialized (dev proc, type proc), uses 
genfs_contexts
[    2.767070] SELinux: initialized (dev bdev, type bdev), uses 
genfs_contexts
[    2.783638] SELinux: initialized (dev rootfs, type rootfs), uses 
genfs_contexts
[    2.800155] SELinux: initialized (dev sysfs, type sysfs), uses 
genfs_contexts
[    2.837370] type=1403 audit(1273564313.837:2): policy loaded 
auid=4294967295 ses=4294967295
[    3.689816] usbcore: registered new interface driver uvcvideo
[    3.707461] USB Video Class driver (v0.1.0)
[    3.732724] applesmc: Apple MacBook Pro detected:
[    3.751037] applesmc:  - Model with accelerometer
[    3.769847] applesmc:  - Model with light sensors and backlight
[    3.788595] applesmc:  - Model with 12 temperature sensors
[    3.807926] applesmc: device has already been initialized (0xe0, 0x00).
[    3.807928] applesmc: device successfully initialized.
[    3.826909] applesmc: 2 fans found.
[    3.846517] input: applesmc as 
/devices/platform/applesmc.768/input/input1
[    3.865125] Registered led device: smc::kbd_backlight
[    3.883846] applesmc: driver successfully loaded.
[    3.914201] usbcore: registered new interface driver appletouch
[    3.953843] ACPI: SSDT 000000003feb8c10 002AE (v01 APPLE   Cpu0Ist 
00003000 INTL 20050309)
[    3.974371] ACPI: SSDT 000000003feb8910 002A0 (v01 APPLE   Cpu0Cst 
00003001 INTL 20050309)
[    3.994867] Monitor-Mwait will be used to enter C-1 state
[    3.994913] Monitor-Mwait will be used to enter C-2 state
[    3.994957] Monitor-Mwait will be used to enter C-3 state
[    3.994968] Marking TSC unstable due to TSC halts in idle
[    4.014243] Switching to clocksource hpet
[    4.016958] ACPI: SSDT 000000003feb8f10 00087 (v01 APPLE   Cpu1Ist 
00003000 INTL 20050309)
[    4.018244] ACPI: SSDT 000000003feb7f10 00085 (v01 APPLE   Cpu1Cst 
00003000 INTL 20050309)
[    4.130576] Bluetooth: Core ver 2.15
[    4.156847] NET: Registered protocol family 31
[    4.176676] Bluetooth: HCI device and connection manager initialized
[    4.196874] Bluetooth: HCI socket layer initialized
[    4.221076] Bluetooth: L2CAP ver 2.14
[    4.240644] Bluetooth: L2CAP socket layer initialized
[    4.270139] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[    4.296119] Bluetooth: Generic Bluetooth USB driver ver 0.6
[    4.316286] usbcore: registered new interface driver btusb
[    4.357507] Bluetooth: RFCOMM TTY layer initialized
[    4.383453] Bluetooth: RFCOMM socket layer initialized
[    4.403365] Bluetooth: RFCOMM ver 1.11
[    4.429141] Bluetooth: HCI UART driver ver 2.2
[    4.448753] Bluetooth: HCI H4 protocol initialized
[    4.474685] Bluetooth: HCI BCSP protocol initialized
[    4.511455] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    4.531880] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) 
-> IRQ 23
[    4.552618] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    4.552622] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    4.573402] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned 
bus number 1
[    4.594424] ehci_hcd 0000:00:1d.7: using broken periodic workaround
[    4.615250] ehci_hcd 0000:00:1d.7: debug port 1
[    4.639400] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    4.639454] ehci_hcd 0000:00:1d.7: irq 23, io mem 0x50405400
[    4.668385] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    4.694746] hub 1-0:1.0: USB hub found
[    4.714313] hub 1-0:1.0: 8 ports detected
[    4.739510] uhci_hcd: USB Universal Host Controller Interface driver
[    4.758513] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) 
-> IRQ 23
[    4.777234] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    4.777239] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    4.795119] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned 
bus number 2
[    4.813348] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00004080
[    4.832039] hub 2-0:1.0: USB hub found
[    4.850074] hub 2-0:1.0: 2 ports detected
[    4.868308] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) 
-> IRQ 19
[    4.886493] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    4.886497] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    4.904293] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned 
bus number 3
[    4.922338] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00004060
[    4.940626] hub 3-0:1.0: USB hub found
[    4.957767] hub 3-0:1.0: 2 ports detected
[    4.974696] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) 
-> IRQ 18
[    4.991448] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    4.991452] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    5.008039] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned 
bus number 4
[    5.024827] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00004040
[    5.042044] hub 4-0:1.0: USB hub found
[    5.058252] hub 4-0:1.0: 2 ports detected
[    5.074516] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) 
-> IRQ 16
[    5.090776] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[    5.090780] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    5.106837] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned 
bus number 5
[    5.123264] uhci_hcd 0000:00:1d.3: irq 16, io base 0x00004020
[    5.140224] hub 5-0:1.0: USB hub found
[    5.156436] hub 5-0:1.0: 2 ports detected
[    5.190290] usb 1-4: new high speed USB device using ehci_hcd and 
address 3
[    5.194416] ieee1394: raw1394: /dev/raw1394 device initialized
[    5.314194] alg: No test for cipher_null (cipher_null-generic)
[    5.358777] alg: No test for ecb(cipher_null) (ecb-cipher_null)
[    5.376514] alg: No test for digest_null (digest_null-generic)
[    5.394044] alg: No test for compress_null (compress_null-generic)
[    5.413146] uvcvideo: Found UVC 1.00 device Built-in iSight (05ac:8501)
[    5.433446] uvcvideo: UVC non compliance - GET_DEF(PROBE) not 
supported. Enabling workaround.
[    5.577940] SELinux: initialized (dev tmpfs, type tmpfs), uses 
transition SIDs
[    5.862068] usb 2-2: new full speed USB device using uhci_hcd and 
address 2
[    5.934341] udev: starting version 147
[    6.091059] input: Apple Computer Apple Internal Keyboard / Trackpad 
as /devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.0/input/input2
[    6.195742] apple 0003:05AC:021A.0001: input: USB HID v1.11 Keyboard 
[Apple Computer Apple Internal Keyboard / Trackpad] on 
usb-0000:00:1d.0-2/input0
[    6.197493] i801_smbus 0000:00:1f.3: PCI INT B -> GSI 19 (level, low) 
-> IRQ 19
[    6.197500] ACPI: I/O resource 0000:00:1f.3 [0xefa0-0xefbf] conflicts 
with ACPI region SMBI [0xefa0-0xefaf]
[    6.197502] ACPI: If an ACPI driver is available for this device, you 
should use it instead of the native driver
[    7.017921] input: Lid Switch as 
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input3
[    7.022182] sky2 driver version 1.26
[    7.022239] sky2 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    7.022255] sky2 0000:02:00.0: setting latency timer to 64
[    7.022297] sky2 0000:02:00.0: Yukon-2 EC chip revision 2
[    7.022423] sky2 0000:02:00.0: irq 24 for MSI/MSI-X
[    7.025070] sky2 eth0: addr 00:17:f2:cb:e3:71
[    7.027629] ohci1394 0000:0c:03.0: PCI INT A -> GSI 19 (level, low) 
-> IRQ 19
[    7.158316] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[19] 
MMIO=[4c004000-4c0047ff]  Max Packet=[4096]  IR/IT contexts=[4/8]
[    7.250215] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) 
-> IRQ 22
[    7.338005] ACPI: Lid Switch [LID0]
[    7.341490] HDA Intel 0000:00:1b.0: irq 25 for MSI/MSI-X
[    7.341548] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    7.357595] appletouch: Geyser mode initialized.
[    7.357759] input: appletouch as 
/devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.1/input/input4
[    7.363772] input: Apple Computer Apple Internal Keyboard / Trackpad 
as /devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.2/input/input5
[    7.363878] apple 0003:05AC:021A.0002: input: USB HID v1.11 Device 
[Apple Computer Apple Internal Keyboard / Trackpad] on 
usb-0000:00:1d.0-2/input2
[    7.518433] power_supply ADP1: uevent
[    7.518436] power_supply ADP1: No power supply yet
[    7.518467] power_supply ADP1: power_supply_changed
[    7.518472] ACPI: AC Adapter [ADP1] (on-line)
[    7.544264] power_supply ADP1: power_supply_changed_work
[    7.544267] power_supply ADP1: power_supply_update_gen_leds 1
[    7.544286] power_supply ADP1: uevent
[    7.544288] power_supply ADP1: POWER_SUPPLY_NAME=ADP1
[    7.544292] power_supply ADP1: Static prop TYPE=Mains
[    7.544296] power_supply ADP1: 1 dynamic props
[    7.544299] power_supply ADP1: prop ONLINE=1
[    7.613988] power_supply BAT0: uevent
[    7.613994] power_supply BAT0: No power supply yet
[    7.614137] power_supply BAT0: power_supply_changed
[    7.614149] power_supply BAT0: power_supply_changed_work
[    7.640451] power_supply BAT0: power_supply_update_bat_leds 0
[    7.640925] power_supply BAT0: uevent
[    7.640930] power_supply BAT0: POWER_SUPPLY_NAME=BAT0
[    7.640939] power_supply BAT0: Static prop TYPE=Battery
[    7.641023] power_supply BAT0: 13 dynamic props
[    7.641037] power_supply BAT0: prop STATUS=Unknown
[    7.641048] power_supply BAT0: prop PRESENT=1
[    7.641059] power_supply BAT0: prop TECHNOLOGY=Unknown
[    7.641068] power_supply BAT0: prop VOLTAGE_MIN_DESIGN=10800000
[    7.641079] power_supply BAT0: prop VOLTAGE_NOW=12481000
[    7.641087] power_supply BAT0: prop CURRENT_NOW=0
[    7.641095] power_supply BAT0: prop POWER_NOW=0
[    7.641103] power_supply BAT0: prop ENERGY_FULL_DESIGN=55000000
[    7.641114] power_supply BAT0: prop ENERGY_FULL=47360000
[    7.641122] power_supply BAT0: prop ENERGY_NOW=46810000
[    7.641131] power_supply BAT0: prop MODEL_NAME=ASMB012
[    7.641139] power_supply BAT0: prop MANUFACTURER=SMPN012
[    7.641147] power_supply BAT0: prop SERIAL_NUMBER=
[    7.641507] power_supply BAT0: uevent
[    7.641513] power_supply BAT0: POWER_SUPPLY_NAME=BAT0
[    7.641522] power_supply BAT0: Static prop TYPE=Battery
[    7.641530] power_supply BAT0: 13 dynamic props
[    7.641537] power_supply BAT0: prop STATUS=Unknown
[    7.641546] power_supply BAT0: prop PRESENT=1
[    7.641556] power_supply BAT0: prop TECHNOLOGY=Unknown
[    7.641566] power_supply BAT0: prop VOLTAGE_MIN_DESIGN=10800000
[    7.641578] power_supply BAT0: prop VOLTAGE_NOW=12481000
[    7.641587] power_supply BAT0: prop CURRENT_NOW=0
[    7.641596] power_supply BAT0: prop POWER_NOW=0
[    7.641606] power_supply BAT0: prop ENERGY_FULL_DESIGN=55000000
[    7.641616] power_supply BAT0: prop ENERGY_FULL=47360000
[    7.641626] power_supply BAT0: prop ENERGY_NOW=46810000
[    7.641636] power_supply BAT0: prop MODEL_NAME=ASMB012
[    7.641645] power_supply BAT0: prop MANUFACTURER=SMPN012
[    7.641655] power_supply BAT0: prop SERIAL_NUMBER=
[    7.663896] ACPI: Battery Slot [BAT0] (battery present)
[    7.698556] input: Power Button as 
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input6
[    7.735281] ACPI: Power Button [PWRB]
[    7.748032] usb 4-2: new full speed USB device using uhci_hcd and 
address 2
[    7.772215] ath9k 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> 
IRQ 17
[    7.772228] ath9k 0000:03:00.0: setting latency timer to 64
[    7.847212] input: Sleep Button as 
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input7
[    7.896301] ACPI: Sleep Button [SLPB]
[    7.906715] ath: EEPROM regdomain: 0x64
[    7.906717] ath: EEPROM indicates we should expect a direct regpair map
[    7.906721] ath: Country alpha2 being used: 00
[    7.906722] ath: Regpair used: 0x64
[    7.931261] input: Power Button as 
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input8
[    7.935534] hda_codec: STAC922x, Apple subsys_id=106b1e00
[    7.990526] ACPI: Power Button [PWRF]
[    7.997530] phy0: Selected rate control algorithm 'ath9k_rate_control'
[    7.998053] Registered led device: ath9k-phy0::radio
[    7.998108] Registered led device: ath9k-phy0::assoc
[    7.998170] Registered led device: ath9k-phy0::tx
[    7.998225] Registered led device: ath9k-phy0::rx
[    7.998273] phy0: Atheros AR5418 MAC/BB Rev:2 AR5133 RF Rev:81 
mem=0xffffc90000bc0000, irq=17
[    8.041727] generic-usb 0003:05AC:8240.0003: hiddev0: USB HID v1.11 
Device [Apple Computer, Inc. IR Receiver] on usb-0000:00:1d.2-2/input0
[    8.323115] usb 5-1: new full speed USB device using uhci_hcd and 
address 2
[    8.554846] usbhid 5-1:1.0: couldn't find an input interrupt endpoint
[    8.615707] ieee1394: Host added: ID:BUS[0-00:1023] 
GUID[0019e3fffe2ad87e]
[    8.681077] usb 5-1: usbfs: USBDEVFS_CONTROL failed cmd hid2hci rqt 
64 rq 0 len 0 ret -84
[    8.705141] usb 5-1: USB disconnect, address 2
[    8.916170] SELinux: initialized (dev tmpfs, type tmpfs), uses 
transition SIDs
[    9.009347] Adding 390616k swap on /dev/sda4.  Priority:1 extents:1 
across:390616k
[    9.411314] usb 5-1: new full speed USB device using uhci_hcd and 
address 3
[   10.944574] ip_tables: (C) 2000-2006 Netfilter Core Team
[   10.981399] nf_conntrack version 0.5.0 (7884 buckets, 31536 max)
[   10.984245] CONFIG_NF_CT_ACCT is deprecated and will be removed soon. 
Please use
[   10.984248] nf_conntrack.acct=1 kernel parameter, acct=1 nf_conntrack 
module option or
[   10.984250] sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
[   13.176234] applesmc: light sensor data length set to 6
[   16.399290] sky2 eth0: enabling interface
[   19.924510] type=1100 audit(1273564330.924:3): user pid=2016 uid=0 
auid=4294967295 ses=4294967295 
subj=system_u:system_r:local_login_t:s0-s0:c0.c255 
msg='op=PAM:authentication acct="name" exe="/bin/login" hostname=? 
addr=? terminal=/dev/tty1 res=success'
[   19.934946] type=1101 audit(1273564330.934:4): user pid=2016 uid=0 
auid=4294967295 ses=4294967295 
subj=system_u:system_r:local_login_t:s0-s0:c0.c255 
msg='op=PAM:accounting acct="name" exe="/bin/login" hostname=? addr=? 
terminal=/dev/tty1 res=success'
[   20.009616] type=1006 audit(1273564331.009:5): login pid=2016 uid=0 
old auid=4294967295 new auid=1000 old ses=4294967295 new ses=1
[   20.095026] type=2300 audit(1273564331.094:6): user pid=2016 uid=0 
auid=1000 ses=1 subj=system_u:system_r:local_login_t:s0-s0:c0.c255 
msg='pam: default-context=name:staff_r:staff_t:s0 
selected-context=name:staff_r:staff_t:s0: exe="/bin/login" hostname=? 
addr=? terminal=tty1 res=success'
[   20.178135] type=1105 audit(1273564331.178:7): user pid=2016 uid=0 
auid=1000 ses=1 subj=system_u:system_r:local_login_t:s0-s0:c0.c255 
msg='op=PAM:session_open acct="name" exe="/bin/login" hostname=? addr=? 
terminal=/dev/tty1 res=success'
[   20.191074] type=1103 audit(1273564331.190:8): user pid=2016 uid=0 
auid=1000 ses=1 subj=system_u:system_r:local_login_t:s0-s0:c0.c255 
msg='op=PAM:setcred acct="name" exe="/bin/login" hostname=? addr=? 
terminal=/dev/tty1 res=success'
[   20.191379] type=1112 audit(1273564331.191:9): user pid=2016 uid=0 
auid=1000 ses=1 subj=system_u:system_r:local_login_t:s0-s0:c0.c255 
msg='op=login acct="name" exe="/bin/login" hostname=? addr=? 
terminal=/dev/tty1 res=success'
[   22.308976] wlan0: direct probe to AP 00:1e:2a:00:67:f0 (try 1)
[   22.311733] wlan0: direct probe responded
[   22.311741] wlan0: authenticate with AP 00:1e:2a:00:67:f0 (try 1)
[   22.318090] wlan0: authenticated
[   22.318223] wlan0: associate with AP 00:1e:2a:00:67:f0 (try 1)
[   22.320730] wlan0: RX AssocResp from 00:1e:2a:00:67:f0 (capab=0x431 
status=0 aid=1)
[   22.320736] wlan0: associated
[   23.713535] [drm] Initialized drm 1.1.0 20060810
[   23.849540] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   23.849545] Bluetooth: BNEP filters: protocol multicast
[   23.928446] Bluetooth: SCO (Voice Link) ver 0.6
[   23.928449] Bluetooth: SCO socket layer initialized
[   23.929616] [drm] radeon defaulting to userspace modesetting.
[   23.930408] pci 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   23.930416] pci 0000:01:00.0: setting latency timer to 64
[   23.930766] [drm] Initialized radeon 1.32.0 20080528 for 0000:01:00.0 
on minor 0
[   24.156429] [drm] Setting GART location based on new memory map
[   24.158069] [drm] Loading R500 Microcode
[   24.158077] platform radeon_cp.0: firmware: requesting radeon/R520_cp.bin
[   24.295079] [drm] Num pipes: 1
[   24.295092] [drm] writeback test succeeded in 1 usecs
[   27.435674] magicmouse 0005:05AC:030D.0004: claimed by neither input, 
hiddev nor hidraw
[   27.435686] magicmouse 0005:05AC:030D.0004: magicmouse hw start failed
[   27.435753] type=1400 audit(1273564338.435:10): avc:  denied  { 
search } for  pid=2105 comm="bluetoothd" name="hid" dev=debugfs ino=1056 
scontext=system_u:system_r:bluetooth_t:s0-s0:c0.c255 
tcontext=system_u:object_r:debugfs_t:s0 tclass=dir
[   27.435927] type=1300 audit(1273564338.435:10): arch=c000003e 
syscall=16 success=yes exit=0 a0=18 a1=400448c8 a2=7fd2680460f0 a3=10 
items=0 ppid=1 pid=2105 auid=4294967295 uid=0 gid=0 euid=0 suid=0 
fsuid=0 egid=0 sgid=0 fsgid=0 tty=(none) ses=4294967295 
comm="bluetoothd" exe="/usr/sbin/bluetoothd" 
subj=system_u:system_r:bluetooth_t:s0-s0:c0.c255 key=(null)
[   74.910194] usb 2-1: new low speed USB device using uhci_hcd and 
address 3
[   75.094202] input: Mitsumi Electric Apple Optical USB Mouse as 
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1:1.0/input/input9
[   75.094598] apple 0003:05AC:0304.0005: input: USB HID v1.10 Mouse 
[Mitsumi Electric Apple Optical USB Mouse] on usb-0000:00:1d.0-1/input0


I'm a bit tired now.. will test commits
in the morning over here with git revert

Justin P. Mattock

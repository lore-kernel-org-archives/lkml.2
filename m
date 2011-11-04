Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932133Ab1KDDKQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 23:10:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40209 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754804Ab1KDDKO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 23:10:14 -0400
From: Thomas Renninger <trenn@suse.de>
To: Zhang Rui <rui.zhang@intel.com>
Subject: Re: [PATCH] PNP ACPI: Use real gsi
Date: Fri, 4 Nov 2011 05:10:10 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc5-5.99.12.5343e5f-desktop; KDE/4.4.4; x86_64; ; )
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "lenb@kernel.org" <lenb@kernel.org>,
        "stable@kernel.org" <stable@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        H Peter Anvin <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
References: <1320372728-3235-1-git-send-email-trenn@suse.de> <1320373233-3725-1-git-send-email-trenn@suse.de> <1320375246.27436.1353.camel@rui>
In-Reply-To: <1320375246.27436.1353.camel@rui>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201111040510.11840.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 November 2011 03:54:06 Zhang Rui wrote:
...
> can you attach the acpidump table please?
I've added you to the bugzilla.novell.com bug and attached acpidump.
Let me know if someone else wants to be added or would like to have
additional info.
You find attached dmesg of a recent 3.1 kernel until it hangs.

Thanks,

   Thomas

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.1.0-rc10-0.0.1.f6d77d4-default (geeko@buildhost) (gcc version 4.6.1 20111012 [gcc-4_6-branch revision 179856] (SUSE Linux) ) #1 SMP Thu Oct 20 08:17:26 UTC 2011 (f6d77d4)
[    0.000000] Command line: root=/dev/sda6 console=tty0 console=ttyS0,57600 sysrq_always_enabled panic=100 ignore_loglevel unknown_nmi_panic resume=/dev/disk/by-id/scsi-35000c50005206f03-part2 splash=silent crashkernel=2G-:128M showopts vga=normal apic=debug
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 0000000000099000 (usable)
[    0.000000]  BIOS-e820: 0000000000099000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000cff6a740 (usable)
[    0.000000]  BIOS-e820: 00000000cff6a740 - 00000000cff763c0 (ACPI data)
[    0.000000]  BIOS-e820: 00000000cff763c0 - 00000000d0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000130000000 (usable)
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] DMI: IBM IBM x3850-[4444aaa]-/Node1 Processor Card, BIOS -[ZSE106AUS-1.01]- 09/18/2006
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x130000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-DFFFF uncachable
[    0.000000]   E0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask FF80000000 write-back
[    0.000000]   1 base 0080000000 mask FFC0000000 write-back
[    0.000000]   2 base 00C0000000 mask FFF0000000 write-back
[    0.000000]   3 base 0100000000 mask FF00000000 write-back
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000d0000000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xcff6a max_arch_pfn = 0x400000000
[    0.000000] Scan SMP from ffff880000000000 for 1024 bytes.
[    0.000000] Scan SMP from ffff88000009fc00 for 1024 bytes.
[    0.000000] Scan SMP from ffff8800000f0000 for 65536 bytes.
[    0.000000] Scan SMP from ffff880000099000 for 1024 bytes.
[    0.000000] found SMP MP-table at [ffff880000099140] 99140
[    0.000000]   mpc: 9a8a0-9abd4
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff880000094000] 94000 size 20480
[    0.000000] init_memory_mapping: 0000000000000000-00000000cff6a000
[    0.000000]  0000000000 - 00cfe00000 page 2M
[    0.000000]  00cfe00000 - 00cff6a000 page 4k
[    0.000000] kernel direct mapping tables up to cff6a000 @ cff64000-cff6a000
[    0.000000] init_memory_mapping: 0000000100000000-0000000130000000
[    0.000000]  0100000000 - 0130000000 page 2M
[    0.000000] kernel direct mapping tables up to 130000000 @ 12fffa000-130000000
[    0.000000] RAMDISK: 37951000 - 37ff0000
[    0.000000] Reserving 128MB of memory at 752MB for crashkernel (System RAM: 4864MB)
[    0.000000] ACPI: RSDP 00000000000fdcf0 00014 (v00 IBM   )
[    0.000000] ACPI: RSDT 00000000cff76340 0003C (v01 IBM    EXA01ZEU 00001000 IBM  45444F43)
[    0.000000] ACPI: FACP 00000000cff762c0 00074 (v01 IBM    EXA01ZEU 00001000 IBM  45444F43)
[    0.000000] ACPI: DSDT 00000000cff6a740 01FC7 (v01 IBM    EXA01ZEU 00001000 INTL 20041203)
[    0.000000] ACPI: FACS 00000000cff75e80 00040
[    0.000000] ACPI: APIC 00000000cff760c0 001D0 (v01 IBM    EXA01ZEU 00001000 IBM  45444F43)
[    0.000000] ACPI: SRAT 00000000cff75f40 00180 (v01 IBM    EXA01ZEU 00001000 IBM  45444F43)
[    0.000000] ACPI: HPET 00000000cff75f00 00038 (v01 IBM    EXA01ZEU 00001000 IBM  45444F43)
[    0.000000] ACPI: MCFG 00000000cff75ec0 0003C (v01 IBM    EXA01ZEU 00001000 IBM  45444F43)
[    0.000000] ACPI: SSDT 00000000cff6c740 09719 (v01 IBM    VIGSSDT0 00001000 INTL 20041203)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] IBM Summit detected, will use apic physical
[    0.000000] Setting APIC routing to physical flat.
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
[    0.000000] SRAT: PXM 0 -> APIC 0x00 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x01 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x02 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x03 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x24 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x25 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x26 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x27 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x10 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x11 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x12 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x13 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x34 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x35 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x36 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x37 -> Node 0
[    0.000000] SRAT: Node 0 PXM 0 0-d0000000
[    0.000000] SRAT: Node 0 PXM 0 100000000-130000000
[    0.000000] NUMA: Node 0 [0,d0000000) + [100000000,130000000) -> [0,130000000)
[    0.000000] Initmem setup node 0 0000000000000000-0000000130000000
[    0.000000]   NODE_DATA [000000012ffe6000 - 000000012fff9fff]
[    0.000000]  [ffffea0000000000-ffffea00043fffff] PMD -> [ffff88012b600000-ffff88012effffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00130000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x00000099
[    0.000000]     0: 0x00000100 -> 0x000cff6a
[    0.000000]     0: 0x00100000 -> 0x00130000
[    0.000000] On node 0 totalpages: 1048307
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 5 pages reserved
[    0.000000]   DMA zone: 3916 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 833442 pages, LIFO batch:31
[    0.000000]   Normal zone: 2688 pages used for memmap
[    0.000000]   Normal zone: 193920 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x9c
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] IBM Summit detected, will use apic physicalmapped APIC to ffffffffff5fa000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x24] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x25] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x26] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x27] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x10] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x11] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x12] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x13] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x34] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x35] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x36] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x37] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x05] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x06] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x07] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x08] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x09] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0a] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0b] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0c] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0d] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0e] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0f] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x10] address[0xfecff000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 16, version 17, address 0xfecff000, GSI 0-2
[    0.000000] ACPI: IOAPIC (id[0x0f] address[0xfec00000] gsi_base[3])
[    0.000000] IOAPIC[1]: apic_id 15, version 17, address 0xfec00000, GSI 3-38
[    0.000000] ACPI: IOAPIC (id[0x0e] address[0xfec01000] gsi_base[39])
[    0.000000] IOAPIC[2]: apic_id 14, version 17, address 0xfec01000, GSI 39-74
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 5 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID f, APIC INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 1 global_irq 4 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID f, APIC INT 01
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 2 global_irq 3 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 02, APIC ID f, APIC INT 00
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 3 global_irq 6 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID f, APIC INT 03
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 4 global_irq 7 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID f, APIC INT 04
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 8 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 05, APIC ID f, APIC INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 6 global_irq 9 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID f, APIC INT 06
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 7 global_irq 10 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID f, APIC INT 07
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 8 global_irq 11 low edge)
[    0.000000] Int: type 0, pol 3, trig 1, bus 00, IRQ 08, APIC ID f, APIC INT 08
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 12 dfl dfl)
[    0.000000] Int: type 0, pol 3, trig 3, bus 00, IRQ 09, APIC ID f, APIC INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 13 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0a, APIC ID f, APIC INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 14 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0b, APIC ID f, APIC INT 0b
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 12 global_irq 15 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID f, APIC INT 0c
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 13 global_irq 16 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID f, APIC INT 0d
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 17 low edge)
[    0.000000] Int: type 0, pol 3, trig 1, bus 00, IRQ 0e, APIC ID f, APIC INT 0e
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 18 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID f, APIC INT 0f
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ1 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ3 used by override.
[    0.000000] ACPI: IRQ4 used by override.
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] ACPI: IRQ6 used by override.
[    0.000000] ACPI: IRQ7 used by override.
[    0.000000] ACPI: IRQ8 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] ACPI: IRQ12 used by override.
[    0.000000] ACPI: IRQ13 used by override.
[    0.000000] ACPI: IRQ14 used by override.
[    0.000000] ACPI: IRQ15 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x10142201 base: 0xfde84000
[    0.000000] SMP: Allowing 16 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5f9000 (fecff000)
[    0.000000] mapped IOAPIC to ffffffffff5f8000 (fec00000)
[    0.000000] mapped IOAPIC to ffffffffff5f7000 (fec01000)
[    0.000000] nr_irqs_gsi: 91
[    0.000000] PM: Registered nosave memory: 0000000000099000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000cff6a000 - 00000000cff6b000
[    0.000000] PM: Registered nosave memory: 00000000cff6b000 - 00000000cff76000
[    0.000000] PM: Registered nosave memory: 00000000cff76000 - 00000000cff77000
[    0.000000] PM: Registered nosave memory: 00000000cff77000 - 00000000d0000000
[    0.000000] PM: Registered nosave memory: 00000000d0000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at d0000000 (gap: d0000000:2ec00000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:16 nr_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88012fc00000 s77952 r8192 d24448 u131072
[    0.000000] pcpu-alloc: s77952 r8192 d24448 u131072 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1031278
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: root=/dev/sda6 console=tty0 console=ttyS0,57600 sysrq_always_enabled panic=100 ignore_loglevel unknown_nmi_panic resume=/dev/disk/by-id/scsi-35000c50005206f03-part2 splash=silent crashkernel=2G-:128M showopts vga=normal apic=debug
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] bootsplash: silent mode.
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 3913832k/4980736k available (5406k kernel code, 787508k absent, 279396k reserved, 6062k data, 940k init)
[    0.000000] Hierarchical RCU implementation.
[    0.000000]  RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] NR_IRQS:33024 nr_irqs:1675 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] allocated 33554432 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 3336.255 MHz processor.
[    0.012011] Calibrating delay loop (skipped), value calculated using timer frequency.. 6672.51 BogoMIPS (lpj=13345020)
[    0.020007] pid_max: default: 32768 minimum: 301
[    0.024082] Security Framework initialized
[    0.028033] AppArmor: AppArmor initialized
[    0.032876] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.041141] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.049003] Mount-cache hash table entries: 256
[    0.052252] Initializing cgroup subsys cpuacct
[    0.056013] Initializing cgroup subsys memory
[    0.060042] Initializing cgroup subsys devices
[    0.064009] Initializing cgroup subsys freezer
[    0.068009] Initializing cgroup subsys net_cls
[    0.072009] Initializing cgroup subsys blkio
[    0.076023] Initializing cgroup subsys perf_event
[    0.080072] CPU: Physical Processor ID: 0
[    0.084008] CPU: Processor Core ID: 0
[    0.088011] mce: CPU supports 5 MCE banks
[    0.092024] CPU0: Thermal monitoring enabled (TM1)
[    0.096013] using mwait in idle threads.
[    0.105270] ACPI: Core revision 20110623
[    0.124163] Getting VERSION: 50014
[    0.128011] Getting VERSION: 50014
[    0.132011] Getting ID: 0
[    0.136011] Getting ID: ff000000
[    0.140011] Getting LVT0: 700
[    0.144012] Getting LVT1: 400
[    0.148020] enabled ExtINT on CPU#0
[    0.152349] ENABLING IO-APIC IRQs
[    0.156013] init IO_APIC IRQs
[    0.160014]  apic 16 pin 0 not connected
[    0.164013]  apic 16 pin 1 not connected
[    0.168013]  apic 16 pin 2 not connected
[    0.172021] IOAPIC[1]: Set routing entry (15-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:0)
[    0.176020] IOAPIC[1]: Set routing entry (15-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:0)
[    0.184014] IOAPIC[1]: Set routing entry (15-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:0)
[    0.188011] IOAPIC[1]: Set routing entry (15-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:0)
[    0.188011] IOAPIC[1]: Set routing entry (15-5 -> 0x35 -> IRQ 5 Mode:0 Active:0 Dest:0)
[    0.188011] IOAPIC[1]: Set routing entry (15-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:0)
[    0.188011] IOAPIC[1]: Set routing entry (15-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:0)
[    0.188011] IOAPIC[1]: Set routing entry (15-8 -> 0x38 -> IRQ 8 Mode:0 Active:1 Dest:0)
[    0.188011] IOAPIC[1]: Set routing entry (15-9 -> 0x39 -> IRQ 9 Mode:1 Active:1 Dest:0)
[    0.188011] IOAPIC[1]: Set routing entry (15-10 -> 0x3a -> IRQ 10 Mode:0 Active:0 Dest:0)
[    0.188011] IOAPIC[1]: Set routing entry (15-11 -> 0x3b -> IRQ 11 Mode:0 Active:0 Dest:0)
[    0.188011] IOAPIC[1]: Set routing entry (15-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:0)
[    0.188011] IOAPIC[1]: Set routing entry (15-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:0)
[    0.188011] IOAPIC[1]: Set routing entry (15-14 -> 0x3e -> IRQ 14 Mode:0 Active:1 Dest:0)
[    0.188011] IOAPIC[1]: Set routing entry (15-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:0)
[    0.188011]  apic 15 pin 16 not connected
[    0.188011]  apic 15 pin 17 not connected
[    0.188011]  apic 15 pin 18 not connected
[    0.188011]  apic 15 pin 19 not connected
[    0.188011]  apic 15 pin 20 not connected
[    0.188011]  apic 15 pin 21 not connected
[    0.188011]  apic 15 pin 22 not connected
[    0.188011]  apic 15 pin 23 not connected
[    0.188011]  apic 15 pin 24 not connected
[    0.188011]  apic 15 pin 25 not connected
[    0.188011]  apic 15 pin 26 not connected
[    0.188011]  apic 15 pin 27 not connected
[    0.188011]  apic 15 pin 28 not connected
[    0.188011]  apic 15 pin 29 not connected
[    0.188011]  apic 15 pin 30 not connected
[    0.188011]  apic 15 pin 31 not connected
[    0.188011]  apic 15 pin 32 not connected
[    0.188011]  apic 15 pin 33 not connected
[    0.188011]  apic 15 pin 34 not connected
[    0.188011]  apic 15 pin 35 not connected
[    0.188011]  apic 14 pin 0 not connected
[    0.188011]  apic 14 pin 1 not connected
[    0.188011]  apic 14 pin 2 not connected
[    0.188011]  apic 14 pin 3 not connected
[    0.188011]  apic 14 pin 4 not connected
[    0.188011]  apic 14 pin 5 not connected
[    0.188011]  apic 14 pin 6 not connected
[    0.188011]  apic 14 pin 7 not connected
[    0.188011]  apic 14 pin 8 not connected
[    0.188011]  apic 14 pin 9 not connected
[    0.188011]  apic 14 pin 10 not connected
[    0.188011]  apic 14 pin 11 not connected
[    0.188011]  apic 14 pin 12 not connected
[    0.188011]  apic 14 pin 13 not connected
[    0.188011]  apic 14 pin 14 not connected
[    0.188011]  apic 14 pin 15 not connected
[    0.188011]  apic 14 pin 16 not connected
[    0.188011]  apic 14 pin 17 not connected
[    0.188011]  apic 14 pin 18 not connected
[    0.188011]  apic 14 pin 19 not connected
[    0.188011]  apic 14 pin 20 not connected
[    0.188011]  apic 14 pin 21 not connected
[    0.188011]  apic 14 pin 22 not connected
[    0.188011]  apic 14 pin 23 not connected
[    0.188011]  apic 14 pin 24 not connected
[    0.188011]  apic 14 pin 25 not connected
[    0.188011]  apic 14 pin 26 not connected
[    0.188011]  apic 14 pin 27 not connected
[    0.188011]  apic 14 pin 28 not connected
[    0.188011]  apic 14 pin 29 not connected
[    0.188011]  apic 14 pin 30 not connected
[    0.188011]  apic 14 pin 31 not connected
[    0.188011]  apic 14 pin 32 not connected
[    0.188011]  apic 14 pin 33 not connected
[    0.188011]  apic 14 pin 34 not connected
[    0.188011]  apic 14 pin 35 not connected
[    0.188011] ..TIMER: vector=0x30 apic1=1 pin1=2 apic2=-1 pin2=-1
[    0.188011] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
[    0.188011] ...trying to set up timer (IRQ0) through the 8259A ...
[    0.188011] ..... (found apic 1 pin 2) ...
[    0.188011] ....... failed.
[    0.188011] ...trying to set up timer as Virtual Wire IRQ...
[    0.228304] ..... works.
[    0.232016] CPU0: Genuine Intel(R) CPU 3.33GHz stepping 08
[    0.244017] Using local APIC timer interrupts.
[    0.244019] calibrating APIC timer ...
[    0.252015] ... lapic delta = 1042565
[    0.252015] ... PM-Timer delta = 357975
[    0.252015] ... PM-Timer result ok
[    0.252015] ..... delta 1042565
[    0.252015] ..... mult: 44775027
[    0.252015] ..... calibration result: 667241
[    0.252015] ..... CPU clock speed is 3336.0835 MHz.
[    0.252015] ..... host bus clock speed is 166.3241 MHz.
[    0.252034] Performance Events: Netburst events, Netburst P4/Xeon PMU driver.
[    0.264021] ... version:                0
[    0.268018] ... bit width:              40
[    0.272018] ... generic registers:      18
[    0.276018] ... value mask:             000000ffffffffff
[    0.280018] ... max period:             0000007fffffffff
[    0.284020] ... fixed-purpose events:   0
[    0.288020] ... event mask:             000000000003ffff
[    0.292814] NMI watchdog enabled, takes one hw-pmu counter.
[    0.296314] Booting Node   0, Processors  #1
[    0.300639] smpboot cpu 1: start_ip = 94000
[    0.016000] masked ExtINT on CPU#1
[    0.408081] NMI watchdog enabled, takes one hw-pmu counter.
[    0.412330]  #2
[    0.416030] smpboot cpu 2: start_ip = 94000
[    0.016000] masked ExtINT on CPU#2
[    0.520086] NMI watchdog enabled, takes one hw-pmu counter.
[    0.524337]  #3
[    0.528037] smpboot cpu 3: start_ip = 94000
[    0.016000] masked ExtINT on CPU#3
[    0.632089] NMI watchdog enabled, takes one hw-pmu counter.
[    0.636333]  #4
[    0.640044] smpboot cpu 4: start_ip = 94000
[    0.016000] masked ExtINT on CPU#4
[    0.744083] NMI watchdog enabled, takes one hw-pmu counter.
[    0.748287]  #5
[    0.752051] smpboot cpu 5: start_ip = 94000
[    0.016000] masked ExtINT on CPU#5
[    0.860087] NMI watchdog enabled, takes one hw-pmu counter.
[    0.864284]  #6
[    0.868058] smpboot cpu 6: start_ip = 94000
[    0.016000] masked ExtINT on CPU#6
[    0.976094] NMI watchdog enabled, takes one hw-pmu counter.
[    0.980291]  #7
[    0.984065] smpboot cpu 7: start_ip = 94000
[    0.016000] masked ExtINT on CPU#7
[    1.088100] NMI watchdog enabled, takes one hw-pmu counter.
[    1.092299]  #8
[    1.096072] smpboot cpu 8: start_ip = 94000
[    0.016000] masked ExtINT on CPU#8
[    1.200112] NMI watchdog enabled, takes one hw-pmu counter.
[    1.204313]  #9
[    1.208079] smpboot cpu 9: start_ip = 94000
[    0.016000] masked ExtINT on CPU#9
[    1.312116] NMI watchdog enabled, takes one hw-pmu counter.
[    1.316311]  #10
[    1.320086] smpboot cpu 10: start_ip = 94000
[    0.016000] masked ExtINT on CPU#10
[    1.424124] NMI watchdog enabled, takes one hw-pmu counter.
[    1.428331]  #11
[    1.432093] smpboot cpu 11: start_ip = 94000
[    0.016000] masked ExtINT on CPU#11
[    1.536129] NMI watchdog enabled, takes one hw-pmu counter.
[    1.540326]  #12
[    1.544100] smpboot cpu 12: start_ip = 94000
[    0.016000] masked ExtINT on CPU#12
[    1.648141] NMI watchdog enabled, takes one hw-pmu counter.
[    1.652331]  #13
[    1.656107] smpboot cpu 13: start_ip = 94000
[    0.016000] masked ExtINT on CPU#13
[    1.760144] NMI watchdog enabled, takes one hw-pmu counter.
[    1.764400]  #14
[    1.768114] smpboot cpu 14: start_ip = 94000
[    0.016000] masked ExtINT on CPU#14
[    1.872152] NMI watchdog enabled, takes one hw-pmu counter.
[    1.876378]  #15 Ok.
[    1.880121] smpboot cpu 15: start_ip = 94000
[    0.016000] masked ExtINT on CPU#15
[    1.984158] NMI watchdog enabled, takes one hw-pmu counter.
[    1.988173] Brought up 16 CPUs
[    1.992131] Total of 16 processors activated (106761.60 BogoMIPS).
[    2.000690] devtmpfs: initialized
[    2.008426] print_constraints: dummy:
[    2.012182] RTC time: 14:36:52, date: 10/27/11
[    2.016258] NET: Registered protocol family 16
[    2.020462] ACPI: bus type pci registered
[    2.024237] PCI: MMCONFIG for domain 0000 [bus 00-1d] at [mem 0xd0000000-0xd1dfffff] (base 0xd0000000)
[    2.028131] PCI: not using MMCONFIG
[    2.032131] PCI: Using configuration type 1 for base access
[    2.036137] PCI: IBM System x3850 detected, can skip ISA alignment
[    2.041391] bio: create slab <bio-0> at 0
[    2.044267] ACPI: Added _OSI(Module Device)
[    2.048133] ACPI: Added _OSI(Processor Device)
[    2.052132] ACPI: Added _OSI(3.0 _SCP Extensions)
[    2.056133] ACPI: Added _OSI(Processor Aggregator Device)
[    2.065937] ACPI: EC: Look up EC in DSDT
[    2.255528] ACPI: Interpreter enabled
[    2.256155] ACPI: (supports S0 S5)
[    2.261491] ACPI: Using IOAPIC for interrupt routing
[    2.264175] PCI: MMCONFIG for domain 0000 [bus 00-1d] at [mem 0xd0000000-0xd1dfffff] (base 0xd0000000)
[    2.282568] [Firmware Bug]: PCI: MMCONFIG at [mem 0xd0000000-0xd1dfffff] not reserved in ACPI motherboard resources
[    2.284153] PCI: not using MMCONFIG
[    2.305592] ACPI: No dock devices found.
[    2.308149] HEST: Table not found.
[    2.312152] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    2.320353] ACPI: PCI Root Bridge [VP00] (domain 0000 [bus 00])
[    2.324263] pci_root PNP0A08:00: host bridge window [mem 0xf3400000-0xf34fffff] (ignored)
[    2.328151] pci_root PNP0A08:00: host bridge window [mem 0xe8000000-0xefffffff] (ignored)
[    2.332150] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    2.336151] pci_root PNP0A08:00: host bridge window [io  0x0000-0x18ff] (ignored)
[    2.340171] pci 0000:00:00.0: [1014:02a1] type 0 class 0x000600
[    2.344242] pci 0000:00:01.0: [1002:5159] type 0 class 0x000300
[    2.348174] pci 0000:00:01.0: reg 10: [mem 0xe8000000-0xefffffff pref]
[    2.352161] pci 0000:00:01.0: reg 14: [io  0x1800-0x18ff]
[    2.356161] pci 0000:00:01.0: reg 18: [mem 0xf3400000-0xf340ffff]
[    2.360191] pci 0000:00:01.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    2.364182] pci 0000:00:01.0: supports D1 D2
[    2.368183] pci 0000:00:03.0: [1033:0035] type 0 class 0x000c03
[    2.372174] pci 0000:00:03.0: reg 10: [mem 0xf3410000-0xf3410fff]
[    2.376239] pci 0000:00:03.0: supports D1 D2
[    2.380153] pci 0000:00:03.0: PME# supported from D0 D1 D2 D3hot
[    2.384156] pci 0000:00:03.0: PME# disabled
[    2.388182] pci 0000:00:03.1: [1033:0035] type 0 class 0x000c03
[    2.392176] pci 0000:00:03.1: reg 10: [mem 0xf3411000-0xf3411fff]
[    2.396240] pci 0000:00:03.1: supports D1 D2
[    2.400154] pci 0000:00:03.1: PME# supported from D0 D1 D2 D3hot
[    2.404157] pci 0000:00:03.1: PME# disabled
[    2.408183] pci 0000:00:03.2: [1033:00e0] type 0 class 0x000c03
[    2.412177] pci 0000:00:03.2: reg 10: [mem 0xf3412000-0xf34120ff]
[    2.416241] pci 0000:00:03.2: supports D1 D2
[    2.420155] pci 0000:00:03.2: PME# supported from D0 D1 D2 D3hot
[    2.424158] pci 0000:00:03.2: PME# disabled
[    2.428212] pci 0000:00:0f.0: [1166:0203] type 0 class 0x000600
[    2.432225] pci 0000:00:0f.1: [1166:0213] type 0 class 0x000101
[    2.436170] pci 0000:00:0f.1: reg 10: [io  0x01f0-0x01f7]
[    2.440166] pci 0000:00:0f.1: reg 14: [io  0x03f4-0x03f7]
[    2.444166] pci 0000:00:0f.1: reg 18: [io  0x0170-0x0177]
[    2.448167] pci 0000:00:0f.1: reg 1c: [io  0x0374-0x0377]
[    2.452167] pci 0000:00:0f.1: reg 20: [io  0x0700-0x070f]
[    2.456208] pci 0000:00:0f.3: [1166:0227] type 0 class 0x000601
[    2.460290] ACPI: PCI Interrupt Routing Table [\_SB_.VP00._PRT]
[    2.464503]  pci0000:00: Unable to request _OSC control (_OSC support mask: 0x1e)
[    2.469167] ACPI: PCI Root Bridge [VP01] (domain 0000 [bus 01])
[    2.472259] pci_root PNP0A08:01: host bridge window [mem 0xf3500000-0xf35fffff] (ignored)
[    2.476160] pci_root PNP0A08:01: host bridge window [mem 0xf1800000-0xf18fffff] (ignored)
[    2.480160] pci_root PNP0A08:01: host bridge window [io  0x1900-0x19ff] (ignored)
[    2.484174] pci 0000:01:00.0: [1014:02a1] type 0 class 0x000600
[    2.488244] pci 0000:01:01.0: [14e4:1648] type 0 class 0x000200
[    2.492184] pci 0000:01:01.0: reg 10: [mem 0xf35c0000-0xf35cffff 64bit]
[    2.496235] pci 0000:01:01.0: PME# supported from D3hot D3cold
[    2.500163] pci 0000:01:01.0: PME# disabled
[    2.504200] pci 0000:01:01.1: [14e4:1648] type 0 class 0x000200
[    2.508184] pci 0000:01:01.1: reg 10: [mem 0xf35d0000-0xf35dffff 64bit]
[    2.516236] pci 0000:01:01.1: PME# supported from D3hot D3cold
[    2.520164] pci 0000:01:01.1: PME# disabled
[    2.524208] pci 0000:01:02.0: [9005:041e] type 0 class 0x000100
[    2.528185] pci 0000:01:02.0: reg 10: [mem 0xf3580000-0xf35bffff 64bit]
[    2.532175] pci 0000:01:02.0: reg 18: [mem 0xf1800000-0xf181ffff 64bit pref]
[    2.536171] pci 0000:01:02.0: reg 20: [io  0x1900-0x19ff]
[    2.540179] pci 0000:01:02.0: reg 30: [mem 0x00000000-0x0007ffff pref]
[    2.544259] ACPI: PCI Interrupt Routing Table [\_SB_.VP01._PRT]
[    2.548494]  pci0000:01: Unable to request _OSC control (_OSC support mask: 0x1e)
[    2.552734] ACPI: PCI Root Bridge [VP02] (domain 0000 [bus 02-05])
[    2.556277] pci_root PNP0A08:02: host bridge window [mem 0xf1c00000-0xf1ffffff] (ignored)
[    2.560165] pci_root PNP0A08:02: host bridge window [mem 0xf0000000-0xf03fffff] (ignored)
[    2.564165] pci_root PNP0A08:02: host bridge window [io  0x2000-0x2fff] (ignored)
[    2.568180] pci 0000:02:00.0: [1014:02a1] type 0 class 0x000600
[    2.572274] ACPI: PCI Interrupt Routing Table [\_SB_.VP02._PRT]
[    2.576495]  pci0000:02: Unable to request _OSC control (_OSC support mask: 0x1e)
[    2.581029] ACPI: PCI Root Bridge [VP03] (domain 0000 [bus 06-09])
[    2.584271] pci_root PNP0A08:03: host bridge window [mem 0xf2000000-0xf23fffff] (ignored)
[    2.588167] pci_root PNP0A08:03: host bridge window [mem 0xf0400000-0xf07fffff] (ignored)
[    2.592167] pci_root PNP0A08:03: host bridge window [io  0x3000-0x3fff] (ignored)
[    2.596182] pci 0000:06:00.0: [1014:02a1] type 0 class 0x000600
[    2.600277] ACPI: PCI Interrupt Routing Table [\_SB_.VP03._PRT]
[    2.608439]  pci0000:06: Unable to request _OSC control (_OSC support mask: 0x1e)
[    2.616557] ACPI: PCI Root Bridge [VP04] (domain 0000 [bus 0a-0e])
[    2.620276] pci_root PNP0A08:04: host bridge window [mem 0xf2400000-0xf27fffff] (ignored)
[    2.624169] pci_root PNP0A08:04: host bridge window [mem 0xf0800000-0xf0bfffff] (ignored)
[    2.628169] pci_root PNP0A08:04: host bridge window [io  0x4000-0x4fff] (ignored)
[    2.632188] pci 0000:0a:00.0: [1014:0308] type 1 class 0x000604
[    2.636234] pci 0000:0a:00.0: supports D1 D2
[    2.640169] pci 0000:0a:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    2.644172] pci 0000:0a:00.0: PME# disabled
[    2.648268] pci 0000:0a:00.0: PCI bridge to [bus 0b-0e] (subtractive decode)
[    2.652187] pci 0000:0a:00.0:   bridge window [io  0x0000-0xffff] (subtractive decode)
[    2.656171] pci 0000:0a:00.0:   bridge window [mem 0x00000000-0xffffffffff] (subtractive decode)
[    2.660182] ACPI: PCI Interrupt Routing Table [\_SB_.VP04._PRT]
[    2.664252] ACPI: PCI Interrupt Routing Table [\_SB_.VP04.CALG._PRT]
[    2.668477]  pci0000:0a: Unable to request _OSC control (_OSC support mask: 0x1e)
[    2.672956] ACPI: PCI Root Bridge [VP05] (domain 0000 [bus 0f-13])
[    2.676286] pci_root PNP0A08:05: host bridge window [mem 0xf2800000-0xf2bfffff] (ignored)
[    2.680173] pci_root PNP0A08:05: host bridge window [mem 0xf0c00000-0xf0ffffff] (ignored)
[    2.684173] pci_root PNP0A08:05: host bridge window [io  0x5000-0x5fff] (ignored)
[    2.688192] pci 0000:0f:00.0: [1014:0308] type 1 class 0x000604
[    2.692237] pci 0000:0f:00.0: supports D1 D2
[    2.696173] pci 0000:0f:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    2.700176] pci 0000:0f:00.0: PME# disabled
[    2.704270] pci 0000:0f:00.0: PCI bridge to [bus 10-13] (subtractive decode)
[    2.708189] pci 0000:0f:00.0:   bridge window [io  0x0000-0xffff] (subtractive decode)
[    2.712175] pci 0000:0f:00.0:   bridge window [mem 0x00000000-0xffffffffff] (subtractive decode)
[    2.716185] ACPI: PCI Interrupt Routing Table [\_SB_.VP05._PRT]
[    2.720253] ACPI: PCI Interrupt Routing Table [\_SB_.VP05.CALG._PRT]
[    2.724488]  pci0000:0f: Unable to request _OSC control (_OSC support mask: 0x1e)
[    2.728965] ACPI: PCI Root Bridge [VP06] (domain 0000 [bus 14-18])
[    2.732284] pci_root PNP0A08:06: host bridge window [mem 0xf2c00000-0xf2ffffff] (ignored)
[    2.736177] pci_root PNP0A08:06: host bridge window [mem 0xf1000000-0xf13fffff] (ignored)
[    2.740176] pci_root PNP0A08:06: host bridge window [io  0x6000-0x6fff] (ignored)
[    2.744195] pci 0000:14:00.0: [1014:0308] type 1 class 0x000604
[    2.748240] pci 0000:14:00.0: supports D1 D2
[    2.752176] pci 0000:14:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    2.756179] pci 0000:14:00.0: PME# disabled
[    2.760274] pci 0000:14:00.0: PCI bridge to [bus 15-18] (subtractive decode)
[    2.764192] pci 0000:14:00.0:   bridge window [io  0x0000-0xffff] (subtractive decode)
[    2.768178] pci 0000:14:00.0:   bridge window [mem 0x00000000-0xffffffffff] (subtractive decode)
[    2.772189] ACPI: PCI Interrupt Routing Table [\_SB_.VP06._PRT]
[    2.776265] ACPI: PCI Interrupt Routing Table [\_SB_.VP06.CALG._PRT]
[    2.780490]  pci0000:14: Unable to request _OSC control (_OSC support mask: 0x1e)
[    2.784964] ACPI: PCI Root Bridge [VP07] (domain 0000 [bus 19-1d])
[    2.788285] pci_root PNP0A08:07: host bridge window [mem 0xf3000000-0xf33fffff] (ignored)
[    2.792180] pci_root PNP0A08:07: host bridge window [mem 0xf1400000-0xf17fffff] (ignored)
[    2.796179] pci_root PNP0A08:07: host bridge window [io  0x7000-0x7fff] (ignored)
[    2.800198] pci 0000:19:00.0: [1014:0308] type 1 class 0x000604
[    2.804243] pci 0000:19:00.0: supports D1 D2
[    2.808180] pci 0000:19:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    2.812183] pci 0000:19:00.0: PME# disabled
[    2.816278] pci 0000:19:00.0: PCI bridge to [bus 1a-1d] (subtractive decode)
[    2.820196] pci 0000:19:00.0:   bridge window [io  0x0000-0xffff] (subtractive decode)
[    2.824182] pci 0000:19:00.0:   bridge window [mem 0x00000000-0xffffffffff] (subtractive decode)
[    2.828192] ACPI: PCI Interrupt Routing Table [\_SB_.VP07._PRT]
[    2.832257] ACPI: PCI Interrupt Routing Table [\_SB_.VP07.CALG._PRT]
[    2.836489]  pci0000:19: Unable to request _OSC control (_OSC support mask: 0x1e)
[    2.840772] vgaarb: device added: PCI:0000:00:01.0,decodes=io+mem,owns=io+mem,locks=none
[    2.844196] vgaarb: loaded
[    2.848182] vgaarb: bridge control possible 0000:00:01.0
[    2.856380] SCSI subsystem initialized
[    2.860217] libata version 3.00 loaded.
[    2.864292] PCI: Using ACPI for IRQ routing
[    2.868184] PCI: pci_cache_line_size set to 64 bytes
[    2.872289] reserve RAM buffer: 0000000000099000 - 000000000009ffff
[    2.876185] reserve RAM buffer: 00000000cff6a740 - 00000000cfffffff
[    2.880360] NetLabel: Initializing
[    2.884184] NetLabel:  domain hash size = 128
[    2.888184] NetLabel:  protocols = UNLABELED CIPSOv4
[    2.892205] NetLabel:  unlabeled traffic allowed by default
[    2.896190] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    2.900188] hpet0: at MMIO 0xfde84000, IRQs 2, 8, 0
[    2.906369] hpet0: 3 comparators, 64-bit 3.707069 MHz counter
[    2.956223] Switching to clocksource hpet
[    2.963731] Switched to NOHz mode on CPU #0
[    2.963810] Switched to NOHz mode on CPU #4
[    2.963814] Switched to NOHz mode on CPU #5
[    2.963828] Switched to NOHz mode on CPU #1
[    2.963845] Switched to NOHz mode on CPU #2
[    2.963857] Switched to NOHz mode on CPU #15
[    2.963884] Switched to NOHz mode on CPU #3
[    2.963893] Switched to NOHz mode on CPU #13
[    2.963914] Switched to NOHz mode on CPU #11
[    2.963938] Switched to NOHz mode on CPU #8
[    2.963960] Switched to NOHz mode on CPU #9
[    2.963981] Switched to NOHz mode on CPU #7
[    2.963993] Switched to NOHz mode on CPU #14
[    2.964015] Switched to NOHz mode on CPU #12
[    2.964024] Switched to NOHz mode on CPU #6
[    2.964032] Switched to NOHz mode on CPU #10
[    3.101411] AppArmor: AppArmor Filesystem Enabled
[    3.111086] pnp: PnP ACPI init
[    3.117407] ACPI: bus type pnp registered
[    3.125713] pnp 00:00: [bus 00]
[    3.132173] pnp 00:00: [mem 0xf3400000-0xf34fffff window]
[    3.143166] pnp 00:00: [mem 0xe8000000-0xefffffff window]
[    3.154144] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    3.165124] pnp 00:00: [io  0x0000-0x18ff window]
[    3.174803] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    3.189560] pnp 00:01: [io  0x0060]
[    3.196718] pnp 00:01: [io  0x0064]
[    3.205633] IOAPIC[0]: Set routing entry (16-1 -> 0x29 -> IRQ 76 Mode:0 Active:0 Dest:0)
[    3.222122] pnp 00:01: [irq 76]
[    3.228623] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    3.241893] pnp 00:02: IRQ 12 override to level, low
[    3.252011] pnp 00:02: [irq 9]
[    3.258337] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    3.271960] pnp 00:03: [io  0x03f8-0x03ff]
[    3.280341] IOAPIC[1]: Set routing entry (15-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:0)
[    3.296642] pnp 00:03: [irq 1]
[    3.303006] pnp 00:03: Plug and Play ACPI device, IDs PNP0501 (active)
[    3.316526] pnp 00:04: [io  0x02f8-0x02ff]
[    3.324895] IOAPIC[1]: Invalid reference to IRQ 0
[    3.334491] pnp 00:04: [irq 2]
[    3.340851] pnp 00:04: Plug and Play ACPI device, IDs PNP0501 (active)
[    3.354156] pnp 00:05: [io  0x0020-0x0021]
[    3.362531] pnp 00:05: [io  0x00a0-0x00a1]
[    3.370951] pnp 00:05: Plug and Play ACPI device, IDs PNP0003 (active)
[    3.384218] pnp 00:06: [dma 4]
[    3.390501] pnp 00:06: [io  0x0000-0x001f]
[    3.398883] pnp 00:06: [io  0x0080-0x008f]
[    3.407258] pnp 00:06: [io  0x00c0-0x00df]
[    3.415675] pnp 00:06: Plug and Play ACPI device, IDs PNP0200 (active)
[    3.428956] pnp 00:07: [io  0x0070-0x0073]
[    3.437332] IOAPIC[1]: Set routing entry (15-5 -> 0x35 -> IRQ 5 Mode:0 Active:0 Dest:0)
[    3.453635] pnp 00:07: [irq 5]
[    3.459969] pnp 00:07: Plug and Play ACPI device, IDs PNP0b00 (active)
[    3.473238] pnp 00:08: [io  0x0061]
[    3.480431] pnp 00:08: Plug and Play ACPI device, IDs PNP0800 (active)
[    3.493708] pnp 00:09: [io  0x00f0-0x00ff]
[    3.502081] IOAPIC[1]: Set routing entry (15-10 -> 0x3a -> IRQ 10 Mode:0 Active:0 Dest:0)
[    3.518736] pnp 00:09: [irq 10]
[    3.525238] pnp 00:09: Plug and Play ACPI device, IDs PNP0c04 (active)
[    3.538517] pnp 00:0a: [io  0x002e-0x002f]
[    3.546900] pnp 00:0a: [io  0x004e-0x004f]
[    3.555278] pnp 00:0a: [io  0x0052-0x0053]
[    3.563658] pnp 00:0a: [io  0x0092]
[    3.570819] pnp 00:0a: [io  0x0094-0x009f]
[    3.579200] pnp 00:0a: [io  0x00a8-0x00a9]
[    3.587579] pnp 00:0a: [io  0x0400-0x047f]
[    3.595957] pnp 00:0a: [io  0x0480-0x04ff]
[    3.604335] pnp 00:0a: [io  0x0500-0x055f]
[    3.612713] pnp 00:0a: [io  0x0600]
[    3.619871] pnp 00:0a: [io  0x0800-0x0803]
[    3.628254] pnp 00:0a: [io  0x0c00-0x0cdf]
[    3.636637] pnp 00:0a: [io  0x0f50-0x0f5f]
[    3.645104] system 00:0a: [io  0x0400-0x047f] has been reserved
[    3.657131] system 00:0a: [io  0x0480-0x04ff] has been reserved
[    3.669169] system 00:0a: [io  0x0500-0x055f] has been reserved
[    3.681212] system 00:0a: [io  0x0600] has been reserved
[    3.692029] system 00:0a: [io  0x0800-0x0803] has been reserved
[    3.704073] system 00:0a: [io  0x0c00-0x0cdf] has been reserved
[    3.716110] system 00:0a: [io  0x0f50-0x0f5f] has been reserved
[    3.728148] system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
[    3.742000] pnp 00:0b: [mem 0x00000400-0x000004ff]
[    3.751792] pnp 00:0b: disabling [mem 0x00000400-0x000004ff] because it overlaps 0000:00:01.0 BAR 6 [mem 0x00000000-0x0001ffff pref]
[    3.775934] pnp 00:0b: disabling [mem 0x00000400-0x000004ff disabled] because it overlaps 0000:01:02.0 BAR 6 [mem 0x00000000-0x0007ffff pref]
[    3.801697] system 00:0b: Plug and Play ACPI device, IDs PNP0c01 (active)
[    3.815517] pnp 00:0c: [mem 0xfde84000-0xfde843ff]
[    3.825356] system 00:0c: [mem 0xfde84000-0xfde843ff] has been reserved
[    3.838779] system 00:0c: Plug and Play ACPI device, IDs PNP0103 PNP0c01 (active)
[    3.855664] pnp 00:0d: [mem 0x100000000-0x12fffffff window]
[    3.867015] pnp 00:0d: [mem 0x00100000-0xcfffffff window]
[    3.878065] system 00:0d: [mem 0x100000000-0x12fffffff window] could not be reserved
[    3.893859] system 00:0d: [mem 0x00100000-0xcfffffff window] could not be reserved
[    3.909300] system 00:0d: Plug and Play ACPI device, IDs PNP0c80 PNP0c01 (active)
[    3.924694] pnp 00:0e: [bus 01]
[    3.931168] pnp 00:0e: [mem 0xf3500000-0xf35fffff window]
[    3.942161] pnp 00:0e: [mem 0xf1800000-0xf18fffff window]
[    3.953141] pnp 00:0e: [io  0x1900-0x19ff window]
[    3.962778] pnp 00:0e: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    3.977567] pnp 00:0f: [bus 02-05]
[    3.984560] pnp 00:0f: [mem 0xf1c00000-0xf1ffffff window]
[    3.995548] pnp 00:0f: [mem 0xf0000000-0xf03fffff window]
[    4.006533] pnp 00:0f: [io  0x2000-0x2fff window]
[    4.016167] pnp 00:0f: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    4.031320] pnp 00:10: [bus 06-09]
[    4.038312] pnp 00:10: [mem 0xf2000000-0xf23fffff window]
[    4.049302] pnp 00:10: [mem 0xf0400000-0xf07fffff window]
[    4.060282] pnp 00:10: [io  0x3000-0x3fff window]
[    4.069916] pnp 00:10: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    4.085070] pnp 00:11: [bus 0a-0e]
[    4.092062] pnp 00:11: [mem 0xf2400000-0xf27fffff window]
[    4.103053] pnp 00:11: [mem 0xf0800000-0xf0bfffff window]
[    4.114032] pnp 00:11: [io  0x4000-0x4fff window]
[    4.123666] pnp 00:11: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    4.139263] pnp 00:12: [bus 0f-13]
[    4.146249] pnp 00:12: [mem 0xf2800000-0xf2bfffff window]
[    4.157238] pnp 00:12: [mem 0xf0c00000-0xf0ffffff window]
[    4.168217] pnp 00:12: [io  0x5000-0x5fff window]
[    4.177858] pnp 00:12: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    4.193457] pnp 00:13: [bus 14-18]
[    4.200449] pnp 00:13: [mem 0xf2c00000-0xf2ffffff window]
[    4.211439] pnp 00:13: [mem 0xf1000000-0xf13fffff window]
[    4.222417] pnp 00:13: [io  0x6000-0x6fff window]
[    4.232052] pnp 00:13: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    4.247651] pnp 00:14: [bus 19-1d]
[    4.254639] pnp 00:14: [mem 0xf3000000-0xf33fffff window]
[    4.265629] pnp 00:14: [mem 0xf1400000-0xf17fffff window]
[    4.276608] pnp 00:14: [io  0x7000-0x7fff window]
[    4.286240] pnp 00:14: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    4.301802] pnp: PnP ACPI: found 21 devices
[    4.310349] ACPI: ACPI bus type pnp unregistered
[    4.328891] PCI: max bus depth: 1 pci_try_num: 2
[    4.338370] pci 0000:00:01.0: BAR 6: assigned [mem 0xd0000000-0xd001ffff pref]
[    4.353109] pci 0000:01:02.0: BAR 6: assigned [mem 0xd0080000-0xd00fffff pref]
[    4.367852] pci 0000:0a:00.0: BAR 14: assigned [mem 0xd0100000-0xd02fffff]
[    4.381792] pci 0000:0a:00.0: BAR 15: assigned [mem 0xd0300000-0xd04fffff 64bit pref]
[    4.397753] pci 0000:0a:00.0: BAR 13: assigned [io  0x2000-0x2fff]
[    4.410303] pci 0000:0a:00.0: PCI bridge to [bus 0b-0e]
[    4.420949] pci 0000:0a:00.0:   bridge window [io  0x2000-0x2fff]
[    4.433343] pci 0000:0a:00.0:   bridge window [mem 0xd0100000-0xd02fffff]
[    4.447118] pci 0000:0a:00.0:   bridge window [mem 0xd0300000-0xd04fffff 64bit pref]
[    4.462910] pci 0000:0f:00.0: BAR 14: assigned [mem 0xd0500000-0xd06fffff]
[    4.476865] pci 0000:0f:00.0: BAR 15: assigned [mem 0xd0700000-0xd08fffff 64bit pref]
[    4.492829] pci 0000:0f:00.0: BAR 13: assigned [io  0x3000-0x3fff]
[    4.505380] pci 0000:0f:00.0: PCI bridge to [bus 10-13]
[    4.516025] pci 0000:0f:00.0:   bridge window [io  0x3000-0x3fff]
[    4.528414] pci 0000:0f:00.0:   bridge window [mem 0xd0500000-0xd06fffff]
[    4.542188] pci 0000:0f:00.0:   bridge window [mem 0xd0700000-0xd08fffff 64bit pref]
[    4.557980] pci 0000:14:00.0: BAR 14: assigned [mem 0xd0900000-0xd0afffff]
[    4.571935] pci 0000:14:00.0: BAR 15: assigned [mem 0xd0b00000-0xd0cfffff 64bit pref]
[    4.587896] pci 0000:14:00.0: BAR 13: assigned [io  0x4000-0x4fff]
[    4.600447] pci 0000:14:00.0: PCI bridge to [bus 15-18]
[    4.611091] pci 0000:14:00.0:   bridge window [io  0x4000-0x4fff]
[    4.623472] pci 0000:14:00.0:   bridge window [mem 0xd0900000-0xd0afffff]
[    4.637244] pci 0000:14:00.0:   bridge window [mem 0xd0b00000-0xd0cfffff 64bit pref]
[    4.653040] pci 0000:19:00.0: BAR 14: assigned [mem 0xd0d00000-0xd0efffff]
[    4.666996] pci 0000:19:00.0: BAR 15: assigned [mem 0xd0f00000-0xd10fffff 64bit pref]
[    4.682955] pci 0000:19:00.0: BAR 13: assigned [io  0x5000-0x5fff]
[    4.695504] pci 0000:19:00.0: PCI bridge to [bus 1a-1d]
[    4.706153] pci 0000:19:00.0:   bridge window [io  0x5000-0x5fff]
[    4.718543] pci 0000:19:00.0:   bridge window [mem 0xd0d00000-0xd0efffff]
[    4.732317] pci 0000:19:00.0:   bridge window [mem 0xd0f00000-0xd10fffff 64bit pref]
[    4.748112] pci 0000:0a:00.0: setting latency timer to 64
[    4.759113] pci 0000:0f:00.0: setting latency timer to 64
[    4.770114] pci 0000:14:00.0: setting latency timer to 64
[    4.781113] pci 0000:19:00.0: setting latency timer to 64
[    4.792105] pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
[    4.803442] pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffffff]
[    4.816515] pci_bus 0000:01: resource 0 [io  0x0000-0xffff]
[    4.827854] pci_bus 0000:01: resource 1 [mem 0x00000000-0xffffffffff]
[    4.840939] pci_bus 0000:02: resource 0 [io  0x0000-0xffff]
[    4.852277] pci_bus 0000:02: resource 1 [mem 0x00000000-0xffffffffff]
[    4.865366] pci_bus 0000:06: resource 0 [io  0x0000-0xffff]
[    4.876703] pci_bus 0000:06: resource 1 [mem 0x00000000-0xffffffffff]
[    4.889788] pci_bus 0000:0a: resource 0 [io  0x0000-0xffff]
[    4.901129] pci_bus 0000:0a: resource 1 [mem 0x00000000-0xffffffffff]
[    4.914215] pci_bus 0000:0b: resource 0 [io  0x2000-0x2fff]
[    4.925554] pci_bus 0000:0b: resource 1 [mem 0xd0100000-0xd02fffff]
[    4.938289] pci_bus 0000:0b: resource 2 [mem 0xd0300000-0xd04fffff 64bit pref]
[    4.953039] pci_bus 0000:0b: resource 4 [io  0x0000-0xffff]
[    4.964375] pci_bus 0000:0b: resource 5 [mem 0x00000000-0xffffffffff]
[    4.979192] pci_bus 0000:0f: resource 0 [io  0x0000-0xffff]
[    4.990534] pci_bus 0000:0f: resource 1 [mem 0x00000000-0xffffffffff]
[    5.003615] pci_bus 0000:10: resource 0 [io  0x3000-0x3fff]
[    5.014957] pci_bus 0000:10: resource 1 [mem 0xd0500000-0xd06fffff]
[    5.027693] pci_bus 0000:10: resource 2 [mem 0xd0700000-0xd08fffff 64bit pref]
[    5.042440] pci_bus 0000:10: resource 4 [io  0x0000-0xffff]
[    5.053777] pci_bus 0000:10: resource 5 [mem 0x00000000-0xffffffffff]
[    5.066860] pci_bus 0000:14: resource 0 [io  0x0000-0xffff]
[    5.078204] pci_bus 0000:14: resource 1 [mem 0x00000000-0xffffffffff]
[    5.091287] pci_bus 0000:15: resource 0 [io  0x4000-0x4fff]
[    5.102628] pci_bus 0000:15: resource 1 [mem 0xd0900000-0xd0afffff]
[    5.115365] pci_bus 0000:15: resource 2 [mem 0xd0b00000-0xd0cfffff 64bit pref]
[    5.130115] pci_bus 0000:15: resource 4 [io  0x0000-0xffff]
[    5.141447] pci_bus 0000:15: resource 5 [mem 0x00000000-0xffffffffff]
[    5.154518] pci_bus 0000:19: resource 0 [io  0x0000-0xffff]
[    5.165859] pci_bus 0000:19: resource 1 [mem 0x00000000-0xffffffffff]
[    5.178941] pci_bus 0000:1a: resource 0 [io  0x5000-0x5fff]
[    5.190282] pci_bus 0000:1a: resource 1 [mem 0xd0d00000-0xd0efffff]
[    5.203019] pci_bus 0000:1a: resource 2 [mem 0xd0f00000-0xd10fffff 64bit pref]
[    5.217763] pci_bus 0000:1a: resource 4 [io  0x0000-0xffff]
[    5.229103] pci_bus 0000:1a: resource 5 [mem 0x00000000-0xffffffffff]
[    5.242399] NET: Registered protocol family 2
[    5.251676] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    5.270439] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    5.288779] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    5.302762] TCP: Hash tables configured (established 524288 bind 65536)
[    5.316197] TCP reno registered
[    5.322675] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    5.334933] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    5.348300] NET: Registered protocol family 1
[    5.357223] pci 0000:00:01.0: Boot video device
[    5.366618] PCI: CLS 64 bytes, default 64
[    5.374912] Unpacking initramfs...
[    5.544629] Freeing initrd memory: 6780k freed
[    5.558779] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    5.571891] Placing 64MB software IO TLB between ffff8800cbf64000 - ffff8800cff64000
[    5.587691] software IO TLB at phys 0xcbf64000 - 0xcff64000
[    5.601976] audit: initializing netlink socket (disabled)
[    5.613024] type=2000 audit(1319726211.608:1): initialized
[    5.672491] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    5.726056] VFS: Disk quotas dquot_6.5.2
[    5.734173] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    5.747997] msgmni has been set to 7657
[    5.756439] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    5.771611] io scheduler noop registered
[    5.779640] io scheduler deadline registered
[    5.788420] io scheduler cfq registered (default)
[    5.798462] ERST: Table is not found!
[    5.805969] GHES: HEST is not enabled!
[    5.813777] Serial: 8250/16550 driver, 32 ports, IRQ sharing disabled
[    5.847469] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    5.916583] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    5.988402] 00:03: ttyS0 at I/O 0x3f8 (irq = 1) is a 16550A
[    6.048655] 00:04: ttyS1 at I/O 0x2f8 (irq = 2) is a 16550A
[    6.100403] Non-volatile memory driver v1.3
[    6.108972] Linux agpgart interface v0.103
[    6.117735] Fixed MDIO Bus: probed
[    6.124804] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 76,9
[    6.392423] serio: i8042 KBD port at 0x60,0x64 irq 76
[    6.402892] mousedev: PS/2 mouse device common for all mice
[    6.414611] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
[    6.427032] rtc0: alarms up to one year, 242 bytes nvram
[    6.437864] cpuidle: using governor ladder
[    6.446237] cpuidle: using governor menu
[    6.454268] EFI Variables Facility v0.08 2004-May-17
[    6.464760] TCP cubic registered
[    6.471572] NET: Registered protocol family 10
[    6.481407] lib80211: common routines for IEEE802.11 drivers
[    6.492914] lib80211_crypt: registered algorithm 'NULL'
[    6.503561] Registering the dns_resolver key type
[    6.513178] libceph: loaded (mon/osd proto 15/24, osdmap 5/6 5/6)
[    6.525577]
[    6.525578] printing PIC contents
[    6.535525] ... PIC  IMR: fffe
[    6.539517] ... PIC  IRR: 0003
[    6.548103] ... PIC  ISR: 0000
[    6.554395] ... PIC ELCR: 0c20
[    6.560696] printing local APIC contents on CPU#0/0:
[    6.564692] ... APIC ID:      00000000 (0)
[    6.564692] ... APIC VERSION: 00050014
[    6.564692] ... APIC TASKPRI: 00000000 (00)
[    6.564692] ... APIC PROCPRI: 00000000
[    6.600187] Refined TSC clocksource calibration: 3336.018 MHz.
[    6.600195] Switching to clocksource tsc
[    6.600202] ... APIC LDR: 01000000
[    6.600202] ... APIC DFR: ffffffff
[    6.600202] ... APIC SPIV: 000001ff
[    6.600202] ... APIC ISR field:
[    6.600202] 0000000000000000000000000000000000000000000000000000000000000000
[    6.600202] ... APIC TMR field:
[    6.600202] 0000000000000000000000000000000000000000000000000000000000000000
[    6.600202] ... APIC IRR field:
[    6.600202] 0000000000000000000000000000000000000000000000000000000028000000
[    6.600202] ... APIC ESR: 00000000
[    6.600202] ... APIC ICR: 000000fd
[    6.600202] ... APIC ICR2: 37000000
[    6.600202] ... APIC LVTT: 000000ef
[    6.600202] ... APIC LVTPC: 00000400
[    6.600202] ... APIC LVT0: 00000030
[    6.600202] ... APIC LVT1: 00000400
[    6.600202] ... APIC LVTERR: 000000fe
[    6.600202] ... APIC TMICT: 00dff923
[    6.600202] ... APIC TMCCT: 00a72f85
[    6.600202] ... APIC TDCR: 00000003
[    6.600202]
[    6.790893] number of MP IRQ sources: 16.
[    6.799114] number of IO-APIC #16 registers: 3.
[    6.808365] number of IO-APIC #15 registers: 36.
[    6.817785] number of IO-APIC #14 registers: 36.
[    6.827208] testing the IO APIC.......................
[    6.837677]
[    6.840831] IO APIC #16......
[    6.846945] .... register #00: 00000000
[    6.854811] .......    : physical APIC id: 00
[    6.863716] .......    : Delivery Type: 0
[    6.871921] .......    : LTS          : 0
[    6.880128] .... register #01: 00020011
[    6.887985] .......     : max redirection entries: 02
[    6.898282] .......     : PRQ implemented: 0
[    6.907007] .......     : IO APIC version: 11
[    6.915908] .... register #02: 00000000
[    6.923765] .......     : arbitration: 00
[    6.931971] .... IRQ redirection table:
[    6.939828]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
[    6.950995]  00 00  1    0    0   0   0    0    0    00
[    6.961741]  01 00  0    0    0   0   0    0    0    29
[    6.972500]  02 00  1    0    0   0   0    0    0    00
[    6.983257]
[    6.986421] IO APIC #15......
[    6.992537] .... register #00: 0F000000
[    7.000400] .......    : physical APIC id: 0F
[    7.009303] .......    : Delivery Type: 0
[    7.017505] .......    : LTS          : 0
[    7.025714] .... register #01: 00230011
[    7.033574] .......     : max redirection entries: 23
[    7.043868] .......     : PRQ implemented: 0
[    7.052592] .......     : IO APIC version: 11
[    7.061492] .... register #02: 00000000
[    7.069348] .......     : arbitration: 00
[    7.077557] .... IRQ redirection table:
[    7.085412]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
[    7.096583]  00 00  1    0    0   0   0    0    0    32
[    7.107341]  01 00  1    0    0   0   0    0    0    31
[    7.118098]  02 00  1    0    0   0   0    0    0    30
[    7.128857]  03 00  1    0    0   0   0    0    0    33
[    7.139598]  04 00  1    0    0   0   0    0    0    34
[    7.150356]  05 00  0    0    0   0   0    0    0    35
[    7.161114]  06 00  1    0    0   0   0    0    0    36
[    7.171871]  07 00  1    0    0   0   0    0    0    37
[    7.182627]  08 00  0    0    0   1   0    0    0    38
[    7.193382]  09 00  0    1    0   1   0    0    0    39
[    7.204144]  0a 00  0    0    0   0   0    0    0    3A
[    7.214898]  0b 00  1    0    0   0   0    0    0    3B
[    7.225658]  0c 00  1    0    0   0   0    0    0    3C
[    7.236420]  0d 00  1    0    0   0   0    0    0    3D
[    7.247175]  0e 00  0    0    0   1   0    0    0    3E
[    7.257930]  0f 00  1    0    0   0   0    0    0    3F
[    7.268692]  10 00  1    0    0   0   0    0    0    00
[    7.279451]  11 00  1    0    0   0   0    0    0    00
[    7.290210]  12 00  1    0    0   0   0    0    0    00
[    7.300970]  13 00  1    0    0   0   0    0    0    00
[    7.311725]  14 00  1    0    0   0   0    0    0    00
[    7.322482]  15 00  1    0    0   0   0    0    0    00
[    7.333241]  16 00  1    0    0   0   0    0    0    00
[    7.343998]  17 00  1    0    0   0   0    0    0    00
[    7.354755]  18 00  1    0    0   0   0    0    0    00
[    7.365514]  19 00  1    0    0   0   0    0    0    00
[    7.376270]  1a 00  1    0    0   0   0    0    0    00
[    7.387025]  1b 00  1    0    0   0   0    0    0    00
[    7.397783]  1c 00  1    0    0   0   0    0    0    00
[    7.408541]  1d 00  1    0    0   0   0    0    0    00
[    7.419301]  1e 00  1    0    0   0   0    0    0    00
[    7.431796]  1f 00  1    0    0   0   0    0    0    00
[    7.442550]  20 00  1    0    0   0   0    0    0    00
[    7.453307]  21 00  1    0    0   0   0    0    0    00
[    7.464066]  22 00  1    0    0   0   0    0    0    00
[    7.474820]  23 00  1    0    0   0   0    0    0    00
[    7.485577]
[    7.488743] IO APIC #14......
[    7.494860] .... register #00: 0E000000
[    7.502725] .......    : physical APIC id: 0E
[    7.511628] .......    : Delivery Type: 0
[    7.519832] .......    : LTS          : 0
[    7.528044] .... register #01: 00230011
[    7.535898] .......     : max redirection entries: 23
[    7.546197] .......     : PRQ implemented: 0
[    7.554920] .......     : IO APIC version: 11
[    7.563824] .... register #02: 00000000
[    7.571678] .......     : arbitration: 00
[    7.579889] .... IRQ redirection table:
[    7.587747]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
[    7.598914]  00 00  1    0    0   0   0    0    0    00
[    7.609678]  01 00  1    0    0   0   0    0    0    00
[    7.620432]  02 00  1    0    0   0   0    0    0    00
[    7.631189]  03 00  1    0    0   0   0    0    0    00
[    7.641949]  04 00  1    0    0   0   0    0    0    00
[    7.652706]  05 00  1    0    0   0   0    0    0    00
[    7.663446]  06 00  1    0    0   0   0    0    0    00
[    7.674204]  07 00  1    0    0   0   0    0    0    00
[    7.684948]  08 00  1    0    0   0   0    0    0    00
[    7.695701]  09 00  1    0    0   0   0    0    0    00
[    7.706460]  0a 00  1    0    0   0   0    0    0    00
[    7.717217]  0b 00  1    0    0   0   0    0    0    00
[    7.727974]  0c 00  1    0    0   0   0    0    0    00
[    7.738729]  0d 00  1    0    0   0   0    0    0    00
[    7.749488]  0e 00  1    0    0   0   0    0    0    00
[    7.760245]  0f 00  1    0    0   0   0    0    0    00
[    7.771004]  10 00  1    0    0   0   0    0    0    00
[    7.781760]  11 00  1    0    0   0   0    0    0    00
[    7.792514]  12 00  1    0    0   0   0    0    0    00
[    7.803274]  13 00  1    0    0   0   0    0    0    00
[    7.814033]  14 00  1    0    0   0   0    0    0    00
[    7.824787]  15 00  1    0    0   0   0    0    0    00
[    7.835546]  16 00  1    0    0   0   0    0    0    00
[    7.846305]  17 00  1    0    0   0   0    0    0    00
[    7.857061]  18 00  1    0    0   0   0    0    0    00
[    7.867819]  19 00  1    0    0   0   0    0    0    00
[    7.878560]  1a 00  1    0    0   0   0    0    0    00
[    7.889318]  1b 00  1    0    0   0   0    0    0    00
[    7.900076]  1c 00  1    0    0   0   0    0    0    00
[    7.910831]  1d 00  1    0    0   0   0    0    0    00
[    7.921587]  1e 00  1    0    0   0   0    0    0    00
[    7.932346]  1f 00  1    0    0   0   0    0    0    00
[    7.943103]  20 00  1    0    0   0   0    0    0    00
[    7.953863]  21 00  1    0    0   0   0    0    0    00
[    7.964617]  22 00  1    0    0   0   0    0    0    00
[    7.975374]  23 00  1    0    0   0   0    0    0    00
[    7.986126] IRQ to pin mappings:
[    7.992776] IRQ0 -> 1:2
[    7.998019] IRQ1 -> 1:1
[    8.003275] IRQ2 -> 1:0
[    8.008548] IRQ3 -> 1:3
[    8.013790] IRQ4 -> 1:4
[    8.019029] IRQ5 -> 1:5
[    8.024284] IRQ6 -> 1:6
[    8.029547] IRQ7 -> 1:7
[    8.034784] IRQ8 -> 1:8
[    8.040038] IRQ9 -> 1:9
[    8.045305] IRQ10 -> 1:10
[    8.050886] IRQ11 -> 1:11
[    8.056503] IRQ12 -> 1:12
[    8.062094] IRQ13 -> 1:13
[    8.067680] IRQ14 -> 1:14
[    8.073289] IRQ15 -> 1:15
[    8.078886] IRQ76 -> 0:1
[    8.084333] .................................... done.
[    8.095087] PM: Checking hibernation image partition /dev/disk/by-id/scsi-35000c50005206f03-part2
[    8.292222] PM: Hibernation image not present or could not be loaded.
[    8.305310] registered taskstats version 1
[    8.334269]   Magic number: 15:120:638
[    8.342113] rtc_cmos 00:07: setting system clock to 2011-10-27 14:37:00 UTC (1319726220)
[    8.360837] Freeing unused kernel memory: 940k freed
[    8.372117] Write protecting the kernel read-only data: 10240k
[    8.386855] Freeing unused kernel memory: 720k freed
[    8.397966] Freeing unused kernel memory: 148k freed
[    8.488988] scsi0 : pata_serverworks
[    8.496537] scsi1 : pata_serverworks
[    8.503914] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x700 irq 14
[    8.517865] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x708 irq 15
[    8.696605] ata1.00: ATAPI: MATSHITADVD-RAM UJ-840S, 1.60, max UDMA/33
[    8.724591] ata1.00: configured for UDMA/33
[    8.735521] scsi 0:0:0:0: CD-ROM            MATSHITA DVD-RAM UJ-840S  1.60 PQ: 0 ANSI: 5
[    8.940415] ACPI: acpi_idle registered with cpuidle
[    8.990788] BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
[    9.019161] [drm] Initialized drm 1.1.0 20060810
[    9.041814] [drm] radeon defaulting to kernel modesetting.
[    9.052969] [drm] radeon kernel modesetting enabled.
[    9.063132] IOAPIC[1]: Set routing entry (15-16 -> 0x41 -> IRQ 19 Mode:1 Active:1 Dest:0)
[    9.079784] radeon 0000:00:01.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    9.094133] [drm] initializing kernel modesetting (RV100 0x1002:0x5159 0x1014:0x02C8).
[    9.110297] [drm] register mmio base: 0xF3400000
[    9.119714] [drm] register mmio size: 65536
[    9.129903] radeon 0000:00:01.0: VRAM: 128M 0x00000000E8000000 - 0x00000000EFFFFFFF (16M used)
[    9.147413] radeon 0000:00:01.0: GTT: 512M 0x00000000C8000000 - 0x00000000E7FFFFFF
[    9.162843] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    9.176259] [drm] Driver supports precise vblank timestamp query.
[    9.188656] [drm] radeon: irq initialized.
[    9.217972] [drm] Detected VRAM RAM=128M, BAR=128M
[    9.227768] [drm] RAM width 32bits DDR
[    9.235563] [TTM] Zone  kernel: Available graphics memory: 1961210 kiB.
[    9.248989] [TTM] Initializing pool allocator.
[    9.258117] [drm] radeon: 16M of VRAM memory ready
[    9.267871] [drm] radeon: 512M of GTT memory ready.
[    9.277838] [drm] GART: num cpu pages 131072, num gpu pages 131072
[    9.312438] radeon 0000:00:01.0: WB enabled
[    9.321062] [drm] Loading R100 Microcode
[   69.856073] radeon_cp: Failed to load firmware "radeon/R100_cp.bin"
[   69.868797] [drm:r100_cp_init] *ERROR* Failed to load firmware!
[   69.880819] radeon 0000:00:01.0: failed initializing CP (-2).
[   69.892500] radeon 0000:00:01.0: Disabling GPU acceleration
[   69.903820] [drm] radeon: cp finalized
[   69.912160] [drm] Radeon Display Connectors
[   69.920707] [drm] Connector 0:
[   69.926990] [drm]   VGA
[   69.932053] [drm]   DDC: 0x60 0x60 0x60 0x60 0x60 0x60 0x60 0x60
[   69.944246] [drm]   Encoders:
[   69.950353] [drm]     CRT1: INTERNAL_DAC1
[   69.958550] [drm] Connector 1:
[   69.964839] [drm]   DVI-I
[   69.970258] [drm]   HPD2
[   69.975490] [drm]   DDC: 0x6c 0x6c 0x6c 0x6c 0x6c 0x6c 0x6c 0x6c
[   69.987675] [drm]   Encoders:
[   69.993790] [drm]     CRT2: INTERNAL_DAC2
[   70.001977] [drm]     DFP2: INTERNAL_DVO1
[   70.020726] [drm] Radeon display connector VGA-1: No monitor connected or invalid EDID
[   70.092827] [drm] Radeon display connector DVI-I-1: Found valid EDID
[   70.204996] [drm] fb mappable at 0xE8040000
[   70.214101] [drm] vram apper at 0xE8000000
[   70.222461] [drm] size 786432
[   70.228577] [drm] fb depth is 8
[   70.235035] [drm]    pitch is 1024
[   70.242158] fbcon: radeondrmfb (fb0) is primary device
[   70.569259] splash_prepare: vc_num: 0
[   70.569263] splash_off:
[   70.580790] Console: switching to colour frame buffer device 128x48
[   70.580803] splash_prepare: vc_num: 0
[   70.580805] splash_off:
[   70.630152] fb0: radeondrmfb frame buffer device
[   70.630155] drm: registered panic notifier
[   70.630165] [drm] Initialized radeon 2.11.0 20080528 for 0000:00:01.0 on minor 0
[   70.668350] udevd (245): /proc/245/oom_adj is deprecated, please use /proc/245/oom_score_adj instead.
[   70.687026] udevd version 128 started
[   70.747874] usbcore: registered new interface driver usbfs
[   70.759095] usbcore: registered new interface driver hub
[   70.769937] usbcore: registered new device driver usb
[   70.781893] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   70.795187] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
[   70.795208] IOAPIC[1]: Set routing entry (15-20 -> 0x49 -> IRQ 23 Mode:1 Active:1 Dest:0)
[   70.795225] ehci_hcd 0000:00:03.2: PCI INT C -> GSI 23 (level, low) -> IRQ 23
[   70.795269] ehci_hcd 0000:00:03.2: EHCI Host Controller
[   70.795313] ehci_hcd 0000:00:03.2: new USB bus registered, assigned bus number 1
[   70.816079] ehci_hcd 0000:00:03.2: irq 23, io mem 0xf3412000
[   70.828037] ehci_hcd 0000:00:03.2: USB 2.0 started, EHCI 1.00
[   70.828082] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[   70.828090] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   70.828095] usb usb1: Product: EHCI Host Controller
[   70.828099] usb usb1: Manufacturer: Linux 3.1.0-rc10-0.0.1.f6d77d4-default ehci_hcd
[   70.828103] usb usb1: SerialNumber: 0000:00:03.2
[   70.828393] hub 1-0:1.0: USB hub found
[   70.828406] hub 1-0:1.0: 4 ports detected
[   71.020519] IOAPIC[1]: Set routing entry (15-25 -> 0x51 -> IRQ 28 Mode:1 Active:1 Dest:0)
[   71.047881] aic94xx 0000:01:02.0: PCI INT A -> GSI 28 (level, low) -> IRQ 28
[   71.073254] aic94xx: found Adaptec AIC-9410W SAS/SATA Host Adapter, device 0000:01:02.0
[   71.100501] scsi2 : aic94xx
[   71.117596] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[   71.141697] ohci_hcd 0000:00:03.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[   71.167788] ohci_hcd 0000:00:03.0: OHCI Host Controller
[   71.177695] aic94xx: Found sequencer Firmware version 1.1 (V35)
[   71.213463] ohci_hcd 0000:00:03.0: new USB bus registered, assigned bus number 2
[   71.240210] ohci_hcd 0000:00:03.0: irq 23, io mem 0xf3410000
[   71.290828] aic94xx: device 0000:01:02.0: SAS addr 5005076a018bb6a0, PCBA SN , 8 phys, 8 enabled phys, flash present, BIOS build 1325
[   71.346016] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[   71.353247] sas: phy-2:0 added to port-2:0, phy_mask:0x1 (5000c50005206f01)
[   71.353274] sas: DOING DISCOVERY on port 0, pid:168
[   71.354627] scsi 2:0:0:0: Direct-Access     IBM-ESXS ST973451SS       B612 PQ: 0 ANSI: 5
[   71.356269] sas: DONE DISCOVERY on port 0, pid:168, result:0
[   71.357130] sd 2:0:0:0: [sda] 143374000 512-byte logical blocks: (73.4 GB/68.3 GiB)
[   71.358994] sd 2:0:0:0: [sda] Write Protect is off
[   71.358998] sd 2:0:0:0: [sda] Mode Sense: bb 00 10 08
[   71.372322] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   71.411157]  sda: sda1 sda2 sda3 < sda5 sda6 sda7 sda8 sda9 >
[   71.604591] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   71.609721] sd 2:0:0:0: [sda] Attached SCSI disk
[   71.655464] usb usb2: Product: OHCI Host Controller
[   71.678878] usb usb2: Manufacturer: Linux 3.1.0-rc10-0.0.1.f6d77d4-default ohci_hcd
[   71.678882] usb usb2: SerialNumber: 0000:00:03.0
[   71.679032] hub 2-0:1.0: USB hub found
[   71.679040] hub 2-0:1.0: 2 ports detected
[   71.679136] ohci_hcd 0000:00:03.1: PCI INT B -> GSI 23 (level, low) -> IRQ 23
[   71.730881] ohci_hcd 0000:00:03.1: OHCI Host Controller
[   71.730892] ohci_hcd 0000:00:03.1: new USB bus registered, assigned bus number 3
[   71.730916] ohci_hcd 0000:00:03.1: irq 23, io mem 0xf3411000
[   71.813819] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[   71.813822] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   71.813825] usb usb3: Product: OHCI Host Controller
[   71.813827] usb usb3: Manufacturer: Linux 3.1.0-rc10-0.0.1.f6d77d4-default ohci_hcd
[   71.813829] usb usb3: SerialNumber: 0000:00:03.1
[   71.813959] hub 3-0:1.0: USB hub found
[   71.814022] hub 3-0:1.0: 2 ports detected
[   72.188028] usb 3-1: new full speed USB device number 2 using ohci_hcd
[   72.431074] usb 3-1: New USB device found, idVendor=04b3, idProduct=4001
[   72.458325] usb 3-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[   72.486302] usb 3-1: Product: IBM RSA2
[   72.507429] usb 3-1: Manufacturer: IBM
[   72.528374] usb 3-1: SerialNumber: 00145e6502d7
[   72.574544] input: IBM IBM RSA2 as /devices/pci0000:00/0000:00:03.1/usb3/3-1/3-1:1.0/input/input0
[   72.606183] generic-usb 0003:04B3:4001.0001: input,hidraw0: USB HID v1.10 Keyboard [IBM IBM RSA2] on usb-0000:00:03.1-1/input0
[   72.668157] input: IBM IBM RSA2 as /devices/pci0000:00/0000:00:03.1/usb3/3-1/3-1:1.1/input/input1
[   72.700315] generic-usb 0003:04B3:4001.0002: input,hidraw1: USB HID v1.10 Mouse [IBM IBM RSA2] on usb-0000:00:03.1-1/input1
[   72.736760] usbcore: registered new interface driver usbhid
[   72.762061] usbhid: USB HID core driver
[   72.971356] PM: Marking nosave pages: 0000000000099000 - 0000000000100000
[   72.999092] PM: Marking nosave pages: 00000000cff6a000 - 0000000100000000
[   73.027533] PM: Basic memory bitmaps created
[   73.071334] PM: Basic memory bitmaps freed
[   73.104484] PM: Starting manual resume from disk
[   73.126977] PM: Hibernation image partition 8:2 present
[   73.150141] PM: Looking for hibernation image.
[   73.171846] PM: Image not found (code -22)
[   73.192524] PM: Hibernation image not present or could not be loaded.
[   73.409464] kjournald starting.  Commit interval 5 seconds
[   73.409851] EXT3-fs (sda6): using internal journal
[   73.409857] EXT3-fs (sda6): mounted filesystem with ordered data mode

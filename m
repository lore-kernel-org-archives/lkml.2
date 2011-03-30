Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932095Ab1C3SS2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 14:18:28 -0400
Received: from mk-outboundfilter-5-a-2.mail.uk.tiscali.com ([212.74.114.4]:10131
	"EHLO mk-outboundfilter-5-a-2.mail.uk.tiscali.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753728Ab1C3SSZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 14:18:25 -0400
X-Trace: 365083489/mk-outboundfilter-5.mail.uk.tiscali.com/F2S/$F2S-ACCEPTED/f2s-freedom2Surf-customers/83.67.12.31/None/tvrtko@ursulin.net
X-SBRS: None
X-RemoteIP: 83.67.12.31
X-IP-MAIL-FROM: tvrtko@ursulin.net
X-SMTP-AUTH: 
X-Originating-Country: GB/UNITED KINGDOM
X-MUA: Evolution 2.30.3
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBANByk01TQwwf/2dsb2JhbAAMF4QjqnykH5ETgnQMgXN3BJBP
X-IronPort-AV: E=Sophos;i="4.63,269,1299456000"; 
   d="scan'208";a="365083489"
X-IP-Direction: IN
Subject: Re: 2.6.38 hangs on boot until key is pressed
From: Tvrtko Ursulin <tvrtko@ursulin.net>
To: Andreas Herrmann <herrmann.der.user@googlemail.com>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <borislav.petkov@amd.com>
In-Reply-To: <20110330155350.GA31845@alberich.amd.com>
References: <1301253485.2500.2.camel@deuteros>
	 <20110330155350.GA31845@alberich.amd.com>
Content-Type: multipart/mixed; boundary="=-bCwyszTU8F/Ly5NP9ORN"
Date: Wed, 30 Mar 2011 19:18:17 +0100
Message-ID: <1301509097.2538.4.camel@deuteros>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-bCwyszTU8F/Ly5NP9ORN
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Wed, 2011-03-30 at 17:53 +0200, Andreas Herrmann wrote:
> On Sun, Mar 27, 2011 at 08:18:05PM +0100, Tvrtko Ursulin wrote:
> > 
> > Hi all,
> > 
> > It always happens at the same spot. 2.6.37 is fine with almost
> > identical .config. Dmesg and config attached.
> 
> 
> Hi,
> 
> can you please send dmesg when 2.6.37 is booted.
> Also output of "lspci -nnxxxx" would be of interest.
> dmidecode (as root) would also help.

Attached.

> Does it help to disable C1e in your BIOS (if there is such an option)?
> If there is no such option please try to boot 2.6.38.1 with idle=mwait
> on the command line.

Both tests (on their own) booted without hanging.

Hope this helps.

Tvrtko


--=-bCwyszTU8F/Ly5NP9ORN
Content-Disposition: attachment; filename="2.6.27.2.dmesg"
Content-Type: text/plain; name="2.6.27.2.dmesg"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.37.2 (tvrtko@deuteros) (gcc version 4.4.5 (Ubuntu/Linaro 4.4.4-14ubuntu5) ) #4 SMP PREEMPT Sat Mar 5 18:50:05 GMT 2011
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-2.6.37.2 root=UUID=6737e317-fa95-4459-8ec1-059dd1456339 ro acpi_enforce_resources=lax splash
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009ec00 (usable)
[    0.000000]  BIOS-e820: 000000000009ec00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000cfe90000 (usable)
[    0.000000]  BIOS-e820: 00000000cfe90000 - 00000000cfea8000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000cfea8000 - 00000000cfed0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cfed0000 - 00000000cff00000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff700000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000120000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] DMI: System manufacturer System Product Name/M4A785TD-M EVO, BIOS 2103    06/30/2010
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x120000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000000 mask FFFF80000000 write-back
[    0.000000]   1 base 000080000000 mask FFFFC0000000 write-back
[    0.000000]   2 base 0000C0000000 mask FFFFF0000000 write-back
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 0000000130000000 aka 4864M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000d0000000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xcfe90 max_arch_pfn = 0x400000000
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: 0000000000000000-00000000cfe90000
[    0.000000]  0000000000 - 00c0000000 page 1G
[    0.000000]  00c0000000 - 00cfe00000 page 2M
[    0.000000]  00cfe00000 - 00cfe90000 page 4k
[    0.000000] kernel direct mapping tables up to cfe90000 @ 1fffd000-20000000
[    0.000000] init_memory_mapping: 0000000100000000-0000000120000000
[    0.000000]  0100000000 - 0120000000 page 2M
[    0.000000] kernel direct mapping tables up to 120000000 @ cfe8e000-cfe90000
[    0.000000] RAMDISK: 3764f000 - 37ff0000
[    0.000000] ACPI: RSDP 00000000000fb4e0 00024 (v02 ACPIAM)
[    0.000000] ACPI: XSDT 00000000cfe90100 0005C (v01 063010 XSDT1927 20100630 MSFT 00000097)
[    0.000000] ACPI: FACP 00000000cfe90290 000F4 (v03 063010 FACP1927 20100630 MSFT 00000097)
[    0.000000] ACPI Warning: Optional field Pm2ControlBlock has zero address or length: 0x0000000000000000/0x1 (20101013/tbfadt-557)
[    0.000000] ACPI: DSDT 00000000cfe90450 0DD62 (v01  A1391 A1391001 00000001 INTL 20060113)
[    0.000000] ACPI: FACS 00000000cfea8000 00040
[    0.000000] ACPI: APIC 00000000cfe90390 0007C (v01 063010 APIC1927 20100630 MSFT 00000097)
[    0.000000] ACPI: MCFG 00000000cfe90410 0003C (v01 063010 OEMMCFG  20100630 MSFT 00000097)
[    0.000000] ACPI: OEMB 00000000cfea8040 00072 (v01 063010 OEMB1927 20100630 MSFT 00000097)
[    0.000000] ACPI: SRAT 00000000cfe9f450 000E8 (v01 AMD    FAM_F_10 00000002 AMD  00000001)
[    0.000000] ACPI: HPET 00000000cfe9f540 00038 (v01 063010 OEMHPET  20100630 MSFT 00000097)
[    0.000000] ACPI: SSDT 00000000cfe9f580 0088C (v01 A M I  POWERNOW 00000001 AMD  00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000]  [ffffea0000000000-ffffea0003ffffff] PMD -> [ffff8800c0400000-ffff8800c39fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00120000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009e
[    0.000000]     0: 0x00000100 -> 0x000cfe90
[    0.000000]     0: 0x00100000 -> 0x00120000
[    0.000000] On node 0 totalpages: 982558
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 3920 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 833224 pages, LIFO batch:31
[    0.000000]   Normal zone: 1792 pages used for memmap
[    0.000000]   Normal zone: 129280 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x84] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x85] disabled)
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 33, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8300 base: 0xfed00000
[    0.000000] SMP: Allowing 6 CPUs, 2 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 000000000009f000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e4000
[    0.000000] PM: Registered nosave memory: 00000000000e4000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000cfe90000 - 00000000cfea8000
[    0.000000] PM: Registered nosave memory: 00000000cfea8000 - 00000000cfed0000
[    0.000000] PM: Registered nosave memory: 00000000cfed0000 - 00000000cff00000
[    0.000000] PM: Registered nosave memory: 00000000cff00000 - 00000000ff700000
[    0.000000] PM: Registered nosave memory: 00000000ff700000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at cff00000 (gap: cff00000:2f800000)
[    0.000000] setup_percpu: NR_CPUS:6 nr_cpumask_bits:6 nr_cpu_ids:6 nr_node_ids:1
[    0.000000] PERCPU: Embedded 26 pages/cpu @ffff8800cfc00000 s74432 r8192 d23872 u262144
[    0.000000] pcpu-alloc: s74432 r8192 d23872 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 - - 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 966424
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-2.6.37.2 root=UUID=6737e317-fa95-4459-8ec1-059dd1456339 ro acpi_enforce_resources=lax splash
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.000000] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Node 0: aperture @ c4000000 size 32 MB
[    0.000000] Aperture pointing to e820 RAM. Ignoring.
[    0.000000] Your BIOS doesn't leave a aperture memory hole
[    0.000000] Please enable the IOMMU option in the BIOS setup
[    0.000000] This costs you 64 MB of RAM
[    0.000000] Mapping aperture over 65536 KB of RAM @ c4000000
[    0.000000] PM: Registered nosave memory: 00000000c4000000 - 00000000c8000000
[    0.000000] Memory: 3716936k/4718592k available (4208k kernel code, 788360k absent, 213296k reserved, 4374k data, 448k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=6, Nodes=1
[    0.000000] Preemptable hierarchical RCU implementation.
[    0.000000] 	RCU-based detection of stalled CPUs is disabled.
[    0.000000] 	Verbose stalled-CPUs detection is disabled.
[    0.000000] NR_IRQS:448
[    0.000000] Extended CMOS year: 2000
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 3013.569 MHz processor.
[    0.001004] Calibrating delay loop (skipped), value calculated using timer frequency.. 6027.13 BogoMIPS (lpj=3013569)
[    0.001065] pid_max: default: 32768 minimum: 301
[    0.001118] Mount-cache hash table entries: 256
[    0.002042] Initializing cgroup subsys ns
[    0.002073] ns_cgroup deprecated: consider using the 'clone_children' flag without the ns_cgroup.
[    0.002107] Initializing cgroup subsys cpuacct
[    0.002138] Initializing cgroup subsys devices
[    0.002168] Initializing cgroup subsys freezer
[    0.002198] Initializing cgroup subsys net_cls
[    0.002229] Initializing cgroup subsys blkio
[    0.002272] tseg: 0000000000
[    0.002277] CPU: Physical Processor ID: 0
[    0.002307] CPU: Processor Core ID: 0
[    0.002336] mce: CPU supports 6 MCE banks
[    0.002370] using C1E aware idle routine
[    0.002400] Performance Events: AMD PMU driver.
[    0.002456] ... version:                0
[    0.002486] ... bit width:              48
[    0.002515] ... generic registers:      4
[    0.002544] ... value mask:             0000ffffffffffff
[    0.002574] ... max period:             00007fffffffffff
[    0.002604] ... fixed-purpose events:   0
[    0.002633] ... event mask:             000000000000000f
[    0.002696] ACPI: Core revision 20101013
[    0.012038] Setting APIC routing to flat
[    0.012353] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.022685] CPU0: AMD Phenom(tm) II X4 B45 Processor stepping 02
[    0.022999] System has AMD C1E enabled
[    0.022999] Switch to broadcast mode on CPU0
[    0.028011] Booting Node   0, Processors  #1
[    0.100013] Switch to broadcast mode on CPU1
[    0.102008]  #2
[    0.174013] Switch to broadcast mode on CPU2
[    0.176009]  #3
[    0.248013] Brought up 4 CPUs
[    0.248013] Switch to broadcast mode on CPU3
[    0.248099] Total of 4 processors activated (24107.60 BogoMIPS).
[    0.249029] devtmpfs: initialized
[    0.250047] NET: Registered protocol family 16
[    0.250130] node 0 link 0: io port [1000, ffffff]
[    0.250132] TOM: 00000000d0000000 aka 3328M
[    0.250162] Fam 10h mmconf [e0000000, efffffff]
[    0.250164] node 0 link 0: mmio [a0000, bffff]
[    0.250166] node 0 link 0: mmio [d0000000, efffffff] ==> [d0000000, dfffffff]
[    0.250169] node 0 link 0: mmio [f0000000, fe7fffff]
[    0.250170] node 0 link 0: mmio [fe800000, fe9fffff]
[    0.250172] node 0 link 0: mmio [fea00000, ffefffff]
[    0.250173] TOM2: 0000000130000000 aka 4864M
[    0.250203] bus: [00, 07] on node 0 link 0
[    0.250205] bus: 00 index 0 [io  0x0000-0xffff]
[    0.250207] bus: 00 index 1 [mem 0x000a0000-0x000bffff]
[    0.250208] bus: 00 index 2 [mem 0xd0000000-0xdfffffff]
[    0.250210] bus: 00 index 3 [mem 0xf0000000-0xffffffff]
[    0.250211] bus: 00 index 4 [mem 0x130000000-0xfcffffffff]
[    0.250219] ACPI: bus type pci registered
[    0.250267] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.250303] PCI: not using MMCONFIG
[    0.250332] PCI: Using configuration type 1 for base access
[    0.250362] PCI: Using configuration type 1 for extended access
[    0.250678] bio: create slab <bio-0> at 0
[    0.251669] ACPI: EC: Look up EC in DSDT
[    0.253189] ACPI: Executed 3 blocks of module-level executable AML code
[    0.271572] ACPI: Interpreter enabled
[    0.271603] ACPI: (supports S0 S1 S3 S4 S5)
[    0.271776] ACPI: Using IOAPIC for interrupt routing
[    0.271828] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.273463] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI motherboard resources
[    0.295160] ACPI: No dock devices found.
[    0.295192] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.295314] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.295526] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
[    0.295557] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
[    0.295588] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.295621] pci_root PNP0A03:00: host bridge window [mem 0x000d0000-0x000dffff]
[    0.295654] pci_root PNP0A03:00: host bridge window [mem 0xcff00000-0xdfffffff]
[    0.295687] pci_root PNP0A03:00: host bridge window [mem 0xf0000000-0xfebfffff]
[    0.295730] pci 0000:00:00.0: [1022:9601] type 0 class 0x000600
[    0.295765] pci 0000:00:01.0: [1043:9602] type 1 class 0x000604
[    0.295795] pci 0000:00:07.0: [1022:9607] type 1 class 0x000604
[    0.295817] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    0.295819] pci 0000:00:07.0: PME# disabled
[    0.295833] pci 0000:00:0a.0: [1022:9609] type 1 class 0x000604
[    0.295854] pci 0000:00:0a.0: PME# supported from D0 D3hot D3cold
[    0.295856] pci 0000:00:0a.0: PME# disabled
[    0.295880] pci 0000:00:11.0: [1002:4391] type 0 class 0x000106
[    0.295898] pci 0000:00:11.0: reg 10: [io  0xc000-0xc007]
[    0.295907] pci 0000:00:11.0: reg 14: [io  0xb000-0xb003]
[    0.295916] pci 0000:00:11.0: reg 18: [io  0xa000-0xa007]
[    0.295925] pci 0000:00:11.0: reg 1c: [io  0x9000-0x9003]
[    0.295933] pci 0000:00:11.0: reg 20: [io  0x8000-0x800f]
[    0.295942] pci 0000:00:11.0: reg 24: [mem 0xfe7ffc00-0xfe7fffff]
[    0.295984] pci 0000:00:12.0: [1002:4397] type 0 class 0x000c03
[    0.296010] pci 0000:00:12.0: reg 10: [mem 0xfe7fe000-0xfe7fefff]
[    0.296068] pci 0000:00:12.1: [1002:4398] type 0 class 0x000c03
[    0.296081] pci 0000:00:12.1: reg 10: [mem 0xfe7fd000-0xfe7fdfff]
[    0.296145] pci 0000:00:12.2: [1002:4396] type 0 class 0x000c03
[    0.296162] pci 0000:00:12.2: reg 10: [mem 0xfe7ff800-0xfe7ff8ff]
[    0.296228] pci 0000:00:12.2: supports D1 D2
[    0.296229] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    0.296233] pci 0000:00:12.2: PME# disabled
[    0.296252] pci 0000:00:13.0: [1002:4397] type 0 class 0x000c03
[    0.296264] pci 0000:00:13.0: reg 10: [mem 0xfe7fc000-0xfe7fcfff]
[    0.296324] pci 0000:00:13.1: [1002:4398] type 0 class 0x000c03
[    0.296336] pci 0000:00:13.1: reg 10: [mem 0xfe7fb000-0xfe7fbfff]
[    0.296400] pci 0000:00:13.2: [1002:4396] type 0 class 0x000c03
[    0.296417] pci 0000:00:13.2: reg 10: [mem 0xfe7ff400-0xfe7ff4ff]
[    0.296482] pci 0000:00:13.2: supports D1 D2
[    0.296484] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    0.296487] pci 0000:00:13.2: PME# disabled
[    0.296509] pci 0000:00:14.0: [1002:4385] type 0 class 0x000c05
[    0.296595] pci 0000:00:14.1: [1002:439c] type 0 class 0x000101
[    0.296610] pci 0000:00:14.1: reg 10: [io  0x0000-0x0007]
[    0.296619] pci 0000:00:14.1: reg 14: [io  0x0000-0x0003]
[    0.296628] pci 0000:00:14.1: reg 18: [io  0x0000-0x0007]
[    0.296636] pci 0000:00:14.1: reg 1c: [io  0x0000-0x0003]
[    0.296645] pci 0000:00:14.1: reg 20: [io  0xff00-0xff0f]
[    0.296690] pci 0000:00:14.2: [1002:4383] type 0 class 0x000403
[    0.296710] pci 0000:00:14.2: reg 10: [mem 0xfe7f4000-0xfe7f7fff 64bit]
[    0.296764] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    0.296767] pci 0000:00:14.2: PME# disabled
[    0.296779] pci 0000:00:14.3: [1002:439d] type 0 class 0x000601
[    0.296848] pci 0000:00:14.4: [1002:4384] type 1 class 0x000604
[    0.296885] pci 0000:00:14.5: [1002:4399] type 0 class 0x000c03
[    0.296898] pci 0000:00:14.5: reg 10: [mem 0xfe7fa000-0xfe7fafff]
[    0.296959] pci 0000:00:18.0: [1022:1200] type 0 class 0x000600
[    0.296971] pci 0000:00:18.1: [1022:1201] type 0 class 0x000600
[    0.296981] pci 0000:00:18.2: [1022:1202] type 0 class 0x000600
[    0.296991] pci 0000:00:18.3: [1022:1203] type 0 class 0x000600
[    0.297015] pci 0000:00:18.4: [1022:1204] type 0 class 0x000600
[    0.297052] pci 0000:01:05.0: [1002:9710] type 0 class 0x000300
[    0.297058] pci 0000:01:05.0: reg 10: [mem 0xd0000000-0xdfffffff pref]
[    0.297062] pci 0000:01:05.0: reg 14: [io  0xd000-0xd0ff]
[    0.297066] pci 0000:01:05.0: reg 18: [mem 0xfe9f0000-0xfe9fffff]
[    0.297074] pci 0000:01:05.0: reg 24: [mem 0xfe800000-0xfe8fffff]
[    0.297084] pci 0000:01:05.0: supports D1 D2
[    0.297092] pci 0000:01:05.1: [1002:970f] type 0 class 0x000403
[    0.297099] pci 0000:01:05.1: reg 10: [mem 0xfe9e8000-0xfe9ebfff]
[    0.297120] pci 0000:01:05.1: supports D1 D2
[    0.297154] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.297186] pci 0000:00:01.0:   bridge window [io  0xd000-0xdfff]
[    0.297188] pci 0000:00:01.0:   bridge window [mem 0xfe800000-0xfe9fffff]
[    0.297191] pci 0000:00:01.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.297225] pci 0000:02:00.0: [197b:2380] type 0 class 0x000c00
[    0.297242] pci 0000:02:00.0: reg 10: [mem 0xfeaff800-0xfeafffff]
[    0.297255] pci 0000:02:00.0: reg 14: [mem 0xfeaff400-0xfeaff47f]
[    0.297291] pci 0000:02:00.0: reg 20: [mem 0xfeaff000-0xfeaff07f]
[    0.297304] pci 0000:02:00.0: reg 24: [mem 0xfeafec00-0xfeafec7f]
[    0.299010] pci 0000:00:07.0: PCI bridge to [bus 02-02]
[    0.299042] pci 0000:00:07.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.299044] pci 0000:00:07.0:   bridge window [mem 0xfea00000-0xfeafffff]
[    0.299047] pci 0000:00:07.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.299079] pci 0000:03:00.0: [10ec:8168] type 0 class 0x000200
[    0.299090] pci 0000:03:00.0: reg 10: [io  0xe800-0xe8ff]
[    0.299109] pci 0000:03:00.0: reg 18: [mem 0xfdfff000-0xfdffffff 64bit pref]
[    0.299122] pci 0000:03:00.0: reg 20: [mem 0xfdff8000-0xfdffbfff 64bit pref]
[    0.299130] pci 0000:03:00.0: reg 30: [mem 0xfebf0000-0xfebfffff pref]
[    0.299156] pci 0000:03:00.0: supports D1 D2
[    0.299157] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.299161] pci 0000:03:00.0: PME# disabled
[    0.301008] pci 0000:00:0a.0: PCI bridge to [bus 03-03]
[    0.301040] pci 0000:00:0a.0:   bridge window [io  0xe000-0xefff]
[    0.301042] pci 0000:00:0a.0:   bridge window [mem 0xfeb00000-0xfebfffff]
[    0.301045] pci 0000:00:0a.0:   bridge window [mem 0xfdf00000-0xfdffffff 64bit pref]
[    0.301102] pci 0000:00:14.4: PCI bridge to [bus 04-04] (subtractive decode)
[    0.301136] pci 0000:00:14.4:   bridge window [io  0xf000-0x0000] (disabled)
[    0.301139] pci 0000:00:14.4:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.301143] pci 0000:00:14.4:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.301145] pci 0000:00:14.4:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.301147] pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.301149] pci 0000:00:14.4:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.301151] pci 0000:00:14.4:   bridge window [mem 0x000d0000-0x000dffff] (subtractive decode)
[    0.301152] pci 0000:00:14.4:   bridge window [mem 0xcff00000-0xdfffffff] (subtractive decode)
[    0.301154] pci 0000:00:14.4:   bridge window [mem 0xf0000000-0xfebfffff] (subtractive decode)
[    0.301165] pci_bus 0000:00: on NUMA node 0
[    0.301167] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.301287] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.301313] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE7._PRT]
[    0.301334] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCEA._PRT]
[    0.301362] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0PC._PRT]
[    0.304350] ACPI: PCI Interrupt Link [LNKA] (IRQs 4 7 10 *11 12 14 15)
[    0.304647] ACPI: PCI Interrupt Link [LNKB] (IRQs 4 7 *10 11 12 14 15)
[    0.304940] ACPI: PCI Interrupt Link [LNKC] (IRQs 4 7 10 *11 12 14 15)
[    0.305245] ACPI: PCI Interrupt Link [LNKD] (IRQs 4 7 *10 11 12 14 15)
[    0.305540] ACPI: PCI Interrupt Link [LNKE] (IRQs 4 7 10 11 12 14 15) *0, disabled.
[    0.305886] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 7 10 11 12 14 15) *0, disabled.
[    0.306216] ACPI: PCI Interrupt Link [LNKG] (IRQs 4 7 *10 11 12 14 15)
[    0.306510] ACPI: PCI Interrupt Link [LNKH] (IRQs 4 7 10 11 12 14 15) *0, disabled.
[    0.306836] HEST: Table is not found!
[    0.306900] vgaarb: device added: PCI:0000:01:05.0,decodes=io+mem,owns=io+mem,locks=none
[    0.307002] vgaarb: loaded
[    0.307070] SCSI subsystem initialized
[    0.307111] libata version 3.00 loaded.
[    0.307111] usbcore: registered new interface driver usbfs
[    0.307111] usbcore: registered new interface driver hub
[    0.307111] usbcore: registered new device driver usb
[    0.307111] PCI: Using ACPI for IRQ routing
[    0.307111] PCI: pci_cache_line_size set to 64 bytes
[    0.307111] reserve RAM buffer: 000000000009ec00 - 000000000009ffff 
[    0.307111] reserve RAM buffer: 00000000cfe90000 - 00000000cfffffff 
[    0.307158] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.307318] hpet0: 4 comparators, 32-bit 14.318180 MHz counter
[    0.310016] Switching to clocksource tsc
[    0.310069] pnp: PnP ACPI init
[    0.310104] ACPI: bus type pnp registered
[    0.310230] pnp 00:00: [bus 00-ff]
[    0.310231] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.310233] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.310234] pnp 00:00: [io  0x0d00-0xffff window]
[    0.310236] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.310237] pnp 00:00: [mem 0x000d0000-0x000dffff window]
[    0.310239] pnp 00:00: [mem 0xcff00000-0xdfffffff window]
[    0.310240] pnp 00:00: [mem 0xf0000000-0xfebfffff window]
[    0.310265] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.310339] pnp 00:01: [mem 0x00000000-0xffffffffffffffff disabled]
[    0.310341] pnp 00:01: [mem 0x00000000-0xffffffffffffffff disabled]
[    0.310368] pnp 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.310391] pnp 00:02: [dma 4]
[    0.310392] pnp 00:02: [io  0x0000-0x000f]
[    0.310394] pnp 00:02: [io  0x0081-0x0083]
[    0.310395] pnp 00:02: [io  0x0087]
[    0.310396] pnp 00:02: [io  0x0089-0x008b]
[    0.310398] pnp 00:02: [io  0x008f]
[    0.310399] pnp 00:02: [io  0x00c0-0x00df]
[    0.310415] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.310421] pnp 00:03: [io  0x0070-0x0071]
[    0.310426] pnp 00:03: [irq 8]
[    0.310442] pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.310447] pnp 00:04: [io  0x0061]
[    0.310463] pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.310468] pnp 00:05: [io  0x00f0-0x00ff]
[    0.310471] pnp 00:05: [irq 13]
[    0.310488] pnp 00:05: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.311036] pnp 00:06: [io  0x0378-0x037f]
[    0.311039] pnp 00:06: [irq 7]
[    0.311042] pnp 00:06: [dma 0 disabled]
[    0.311241] pnp 00:06: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.311269] pnp 00:07: [mem 0xfed00000-0xfed003ff]
[    0.311287] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.311724] pnp 00:08: [io  0x03f8-0x03ff]
[    0.311727] pnp 00:08: [irq 4]
[    0.311728] pnp 00:08: [dma 0 disabled]
[    0.311781] pnp 00:08: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.311868] pnp 00:09: [io  0x0060]
[    0.311869] pnp 00:09: [io  0x0064]
[    0.311870] pnp 00:09: [mem 0xfec00000-0xfec00fff]
[    0.311872] pnp 00:09: [mem 0xfee00000-0xfee00fff]
[    0.311901] pnp 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.312074] pnp 00:0a: [io  0x0010-0x001f]
[    0.312075] pnp 00:0a: [io  0x0022-0x003f]
[    0.312077] pnp 00:0a: [io  0x0062-0x0063]
[    0.312078] pnp 00:0a: [io  0x0065-0x006f]
[    0.312079] pnp 00:0a: [io  0x0072-0x007f]
[    0.312081] pnp 00:0a: [io  0x0080]
[    0.312083] pnp 00:0a: [io  0x0084-0x0086]
[    0.312084] pnp 00:0a: [io  0x0088]
[    0.312085] pnp 00:0a: [io  0x008c-0x008e]
[    0.312086] pnp 00:0a: [io  0x0090-0x009f]
[    0.312088] pnp 00:0a: [io  0x00a2-0x00bf]
[    0.312089] pnp 00:0a: [io  0x00b1]
[    0.312090] pnp 00:0a: [io  0x00e0-0x00ef]
[    0.312091] pnp 00:0a: [io  0x04d0-0x04d1]
[    0.312093] pnp 00:0a: [io  0x040b]
[    0.312094] pnp 00:0a: [io  0x04d6]
[    0.312095] pnp 00:0a: [io  0x0c00-0x0c01]
[    0.312096] pnp 00:0a: [io  0x0c14]
[    0.312098] pnp 00:0a: [io  0x0c50-0x0c51]
[    0.312099] pnp 00:0a: [io  0x0c52]
[    0.312100] pnp 00:0a: [io  0x0c6c]
[    0.312101] pnp 00:0a: [io  0x0c6f]
[    0.312102] pnp 00:0a: [io  0x0cd0-0x0cd1]
[    0.312104] pnp 00:0a: [io  0x0cd2-0x0cd3]
[    0.312105] pnp 00:0a: [io  0x0cd4-0x0cd5]
[    0.312106] pnp 00:0a: [io  0x0cd6-0x0cd7]
[    0.312107] pnp 00:0a: [io  0x0cd8-0x0cdf]
[    0.312109] pnp 00:0a: [io  0x0b00-0x0b3f]
[    0.312110] pnp 00:0a: [io  0x0800-0x089f]
[    0.312112] pnp 00:0a: [io  0x0000-0xffffffffffffffff disabled]
[    0.312113] pnp 00:0a: [io  0x0b00-0x0b0f]
[    0.312114] pnp 00:0a: [io  0x0b20-0x0b3f]
[    0.312116] pnp 00:0a: [io  0x0900-0x090f]
[    0.312117] pnp 00:0a: [io  0x0910-0x091f]
[    0.312118] pnp 00:0a: [io  0xfe00-0xfefe]
[    0.312119] pnp 00:0a: [io  0x0060]
[    0.312121] pnp 00:0a: [io  0x0064]
[    0.312122] pnp 00:0a: [mem 0xffb80000-0xffbfffff]
[    0.312123] pnp 00:0a: [mem 0xfec10000-0xfec1001f]
[    0.312125] pnp 00:0a: [mem 0xfed40000-0xfed44fff]
[    0.312183] pnp 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.312362] pnp 00:0b: [io  0x0000-0xffffffffffffffff disabled]
[    0.312364] pnp 00:0b: [io  0x0230-0x023f]
[    0.312365] pnp 00:0b: [io  0x0290-0x029f]
[    0.312366] pnp 00:0b: [io  0x0300-0x030f]
[    0.312367] pnp 00:0b: [io  0x0a30-0x0a3f]
[    0.312398] pnp 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.312430] pnp 00:0c: [mem 0xe0000000-0xefffffff]
[    0.312460] pnp 00:0c: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.312581] pnp 00:0d: [mem 0x00000000-0x0009ffff]
[    0.312584] pnp 00:0d: [mem 0x000c0000-0x000cffff]
[    0.312585] pnp 00:0d: [mem 0x000e0000-0x000fffff]
[    0.312587] pnp 00:0d: [mem 0x00100000-0xcfefffff]
[    0.312588] pnp 00:0d: [mem 0xfec00000-0xffffffff]
[    0.312621] pnp 00:0d: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.312702] pnp: PnP ACPI: found 14 devices
[    0.312732] ACPI: ACPI bus type pnp unregistered
[    0.312769] system 00:09: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.312800] system 00:09: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.312833] system 00:0a: [io  0x04d0-0x04d1] has been reserved
[    0.312864] system 00:0a: [io  0x040b] has been reserved
[    0.312895] system 00:0a: [io  0x04d6] has been reserved
[    0.312932] system 00:0a: [io  0x0c00-0x0c01] has been reserved
[    0.312963] system 00:0a: [io  0x0c14] has been reserved
[    0.312994] system 00:0a: [io  0x0c50-0x0c51] has been reserved
[    0.313025] system 00:0a: [io  0x0c52] has been reserved
[    0.313056] system 00:0a: [io  0x0c6c] has been reserved
[    0.313087] system 00:0a: [io  0x0c6f] has been reserved
[    0.313118] system 00:0a: [io  0x0cd0-0x0cd1] has been reserved
[    0.313149] system 00:0a: [io  0x0cd2-0x0cd3] has been reserved
[    0.313180] system 00:0a: [io  0x0cd4-0x0cd5] has been reserved
[    0.313211] system 00:0a: [io  0x0cd6-0x0cd7] has been reserved
[    0.313243] system 00:0a: [io  0x0cd8-0x0cdf] has been reserved
[    0.313273] system 00:0a: [io  0x0b00-0x0b3f] has been reserved
[    0.313304] system 00:0a: [io  0x0800-0x089f] has been reserved
[    0.313335] system 00:0a: [io  0x0b00-0x0b0f] has been reserved
[    0.313366] system 00:0a: [io  0x0b20-0x0b3f] has been reserved
[    0.313397] system 00:0a: [io  0x0900-0x090f] has been reserved
[    0.313431] system 00:0a: [io  0x0910-0x091f] has been reserved
[    0.313462] system 00:0a: [io  0xfe00-0xfefe] has been reserved
[    0.313494] system 00:0a: [mem 0xffb80000-0xffbfffff] has been reserved
[    0.313525] system 00:0a: [mem 0xfec10000-0xfec1001f] has been reserved
[    0.313556] system 00:0a: [mem 0xfed40000-0xfed44fff] has been reserved
[    0.313589] system 00:0b: [io  0x0230-0x023f] has been reserved
[    0.313620] system 00:0b: [io  0x0290-0x029f] has been reserved
[    0.313650] system 00:0b: [io  0x0300-0x030f] has been reserved
[    0.313681] system 00:0b: [io  0x0a30-0x0a3f] has been reserved
[    0.313713] system 00:0c: [mem 0xe0000000-0xefffffff] has been reserved
[    0.313746] system 00:0d: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.313777] system 00:0d: [mem 0x000c0000-0x000cffff] has been reserved
[    0.313808] system 00:0d: [mem 0x000e0000-0x000fffff] could not be reserved
[    0.313840] system 00:0d: [mem 0x00100000-0xcfefffff] could not be reserved
[    0.313871] system 00:0d: [mem 0xfec00000-0xffffffff] could not be reserved
[    0.319364] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.319396] pci 0000:00:01.0:   bridge window [io  0xd000-0xdfff]
[    0.319428] pci 0000:00:01.0:   bridge window [mem 0xfe800000-0xfe9fffff]
[    0.319460] pci 0000:00:01.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.319494] pci 0000:00:07.0: PCI bridge to [bus 02-02]
[    0.319525] pci 0000:00:07.0:   bridge window [io  disabled]
[    0.319556] pci 0000:00:07.0:   bridge window [mem 0xfea00000-0xfeafffff]
[    0.319587] pci 0000:00:07.0:   bridge window [mem pref disabled]
[    0.319619] pci 0000:00:0a.0: PCI bridge to [bus 03-03]
[    0.319650] pci 0000:00:0a.0:   bridge window [io  0xe000-0xefff]
[    0.319681] pci 0000:00:0a.0:   bridge window [mem 0xfeb00000-0xfebfffff]
[    0.319713] pci 0000:00:0a.0:   bridge window [mem 0xfdf00000-0xfdffffff 64bit pref]
[    0.319747] pci 0000:00:14.4: PCI bridge to [bus 04-04]
[    0.319777] pci 0000:00:14.4:   bridge window [io  disabled]
[    0.319810] pci 0000:00:14.4:   bridge window [mem disabled]
[    0.319843] pci 0000:00:14.4:   bridge window [mem pref disabled]
[    0.319885] pci 0000:00:07.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    0.319922] pci 0000:00:07.0: setting latency timer to 64
[    0.319927] pci 0000:00:0a.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.319959] pci 0000:00:0a.0: setting latency timer to 64
[    0.319966] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.319967] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.319969] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.319971] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000dffff]
[    0.319972] pci_bus 0000:00: resource 8 [mem 0xcff00000-0xdfffffff]
[    0.319974] pci_bus 0000:00: resource 9 [mem 0xf0000000-0xfebfffff]
[    0.319976] pci_bus 0000:01: resource 0 [io  0xd000-0xdfff]
[    0.319977] pci_bus 0000:01: resource 1 [mem 0xfe800000-0xfe9fffff]
[    0.319979] pci_bus 0000:01: resource 2 [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.319981] pci_bus 0000:02: resource 1 [mem 0xfea00000-0xfeafffff]
[    0.319983] pci_bus 0000:03: resource 0 [io  0xe000-0xefff]
[    0.319985] pci_bus 0000:03: resource 1 [mem 0xfeb00000-0xfebfffff]
[    0.319986] pci_bus 0000:03: resource 2 [mem 0xfdf00000-0xfdffffff 64bit pref]
[    0.319988] pci_bus 0000:04: resource 4 [io  0x0000-0x0cf7]
[    0.319990] pci_bus 0000:04: resource 5 [io  0x0d00-0xffff]
[    0.319992] pci_bus 0000:04: resource 6 [mem 0x000a0000-0x000bffff]
[    0.319994] pci_bus 0000:04: resource 7 [mem 0x000d0000-0x000dffff]
[    0.319995] pci_bus 0000:04: resource 8 [mem 0xcff00000-0xdfffffff]
[    0.319997] pci_bus 0000:04: resource 9 [mem 0xf0000000-0xfebfffff]
[    0.320012] NET: Registered protocol family 2
[    0.320067] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.320295] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.321271] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.321582] TCP: Hash tables configured (established 262144 bind 65536)
[    0.321614] TCP reno registered
[    0.321646] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.321696] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.321805] NET: Registered protocol family 1
[    0.321840] pci 0000:00:01.0: MSI quirk detected; subordinate MSI disabled
[    0.446982] pci 0000:01:05.0: Boot video device
[    0.446989] PCI: CLS 64 bytes, default 64
[    0.447019] Trying to unpack rootfs image as initramfs...
[    0.590211] Freeing initrd memory: 9860k freed
[    0.593063] PCI-DMA: Disabling AGP.
[    0.593161] PCI-DMA: aperture base @ c4000000 size 65536 KB
[    0.593191] PCI-DMA: using GART IOMMU.
[    0.593222] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    0.596512] audit: initializing netlink socket (disabled)
[    0.596551] type=2000 audit(1301508709.594:1): initialized
[    0.596793] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.598105] fuse init (API version 7.15)
[    0.598186] msgmni has been set to 7407
[    0.598331] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.598365] io scheduler noop registered
[    0.598395] io scheduler deadline registered
[    0.598447] io scheduler cfq registered (default)
[    0.598636] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[    0.598671] ACPI: Power Button [PWRB]
[    0.598726] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    0.598760] ACPI: Power Button [PWRF]
[    0.598886] ACPI: acpi_idle registered with cpuidle
[    0.598913] ACPI: processor limited to max C-state 1
[    0.600876] ERST: Table is not found!
[    0.601019] Linux agpgart interface v0.103
[    0.601051] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.621660] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.670593] 00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.679589] brd: module loaded
[    0.679923] loop: module loaded
[    0.680160] Fixed MDIO Bus: probed
[    0.680206] PPP generic driver version 2.4.2
[    0.680253] tun: Universal TUN/TAP device driver, 1.6
[    0.680283] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    0.680332] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.680378] ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.680441] ehci_hcd 0000:00:12.2: EHCI Host Controller
[    0.680474] ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus number 1
[    0.686965] ehci_hcd 0000:00:12.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    0.687018] ehci_hcd 0000:00:12.2: debug port 1
[    0.687065] ehci_hcd 0000:00:12.2: irq 17, io mem 0xfe7ff800
[    0.692965] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00
[    0.693063] hub 1-0:1.0: USB hub found
[    0.693094] hub 1-0:1.0: 6 ports detected
[    0.693174] ehci_hcd 0000:00:13.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    0.693212] ehci_hcd 0000:00:13.2: EHCI Host Controller
[    0.693244] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 2
[    0.698962] ehci_hcd 0000:00:13.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    0.699011] ehci_hcd 0000:00:13.2: debug port 1
[    0.699054] ehci_hcd 0000:00:13.2: irq 19, io mem 0xfe7ff400
[    0.704962] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
[    0.705049] hub 2-0:1.0: USB hub found
[    0.705079] hub 2-0:1.0: 6 ports detected
[    0.705159] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.705198] ohci_hcd 0000:00:12.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.705237] ohci_hcd 0000:00:12.0: OHCI Host Controller
[    0.705270] ohci_hcd 0000:00:12.0: new USB bus registered, assigned bus number 3
[    0.711977] ohci_hcd 0000:00:12.0: irq 16, io mem 0xfe7fe000
[    0.767021] hub 3-0:1.0: USB hub found
[    0.767054] hub 3-0:1.0: 3 ports detected
[    0.767124] ohci_hcd 0000:00:12.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.767161] ohci_hcd 0000:00:12.1: OHCI Host Controller
[    0.767193] ohci_hcd 0000:00:12.1: new USB bus registered, assigned bus number 4
[    0.772964] ohci_hcd 0000:00:12.1: irq 16, io mem 0xfe7fd000
[    0.828016] hub 4-0:1.0: USB hub found
[    0.828050] hub 4-0:1.0: 3 ports detected
[    0.828119] ohci_hcd 0000:00:13.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.828157] ohci_hcd 0000:00:13.0: OHCI Host Controller
[    0.828189] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 5
[    0.834968] ohci_hcd 0000:00:13.0: irq 18, io mem 0xfe7fc000
[    0.890015] hub 5-0:1.0: USB hub found
[    0.890049] hub 5-0:1.0: 3 ports detected
[    0.890118] ohci_hcd 0000:00:13.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.890155] ohci_hcd 0000:00:13.1: OHCI Host Controller
[    0.890187] ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 6
[    0.895958] ohci_hcd 0000:00:13.1: irq 18, io mem 0xfe7fb000
[    0.951012] hub 6-0:1.0: USB hub found
[    0.951045] hub 6-0:1.0: 3 ports detected
[    0.951116] ohci_hcd 0000:00:14.5: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.951154] ohci_hcd 0000:00:14.5: OHCI Host Controller
[    0.951187] ohci_hcd 0000:00:14.5: new USB bus registered, assigned bus number 7
[    0.955954] ohci_hcd 0000:00:14.5: irq 18, io mem 0xfe7fa000
[    1.011007] hub 7-0:1.0: USB hub found
[    1.011040] hub 7-0:1.0: 2 ports detected
[    1.011134] PNP: No PS/2 controller found. Probing ports directly.
[    1.011699] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.011739] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.011839] mice: PS/2 mouse device common for all mice
[    1.011931] rtc_cmos 00:03: RTC can wake from S4
[    1.018962] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    1.019013] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    1.019102] device-mapper: uevent: version 1.0.3
[    1.019200] device-mapper: ioctl: 4.18.0-ioctl (2010-06-29) initialised: dm-devel@redhat.com
[    1.019312] cpuidle: using governor ladder
[    1.019342] cpuidle: using governor menu
[    1.019413] TCP cubic registered
[    1.019510] NET: Registered protocol family 10
[    1.019644] lo: Disabled Privacy Extensions
[    1.019688] NET: Registered protocol family 17
[    1.019720] Registering the dns_resolver key type
[    1.019785] powernow-k8: Found 1 AMD Phenom(tm) II X4 B45 Processor (4 cpu cores) (version 2.20.00)
[    1.019841] powernow-k8:    0 : pstate 0 (3000 MHz)
[    1.019876] powernow-k8:    1 : pstate 1 (2300 MHz)
[    1.019906] powernow-k8:    2 : pstate 2 (1800 MHz)
[    1.019937] powernow-k8:    3 : pstate 3 (800 MHz)
[    1.020680] rtc_cmos 00:03: setting system clock to 2011-03-30 18:11:50 UTC (1301508710)
[    1.020715] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    1.020747] EDD information not available.
[    1.020813] Freeing unused kernel memory: 448k freed
[    1.020925] Write protecting the kernel read-only data: 8192k
[    1.021078] Freeing unused kernel memory: 1916k freed
[    1.021475] Freeing unused kernel memory: 472k freed
[    1.032558] udev[67]: starting version 163
[    1.049161] pata_atiixp 0000:00:14.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.049226] pata_atiixp 0000:00:14.1: setting latency timer to 64
[    1.051364] scsi0 : pata_atiixp
[    1.051609] scsi1 : pata_atiixp
[    1.052312] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xff00 irq 14
[    1.052344] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xff08 irq 15
[    1.063283] [drm] Initialized drm 1.1.0 20060810
[    1.107957] usb 4-2: new low speed USB device using ohci_hcd and address 2
[    1.133597] ata2.01: ATAPI: Optiarc DVD RW AD-5240S, 1.03, max UDMA/100
[    1.137407] ata2.01: configured for UDMA/100
[    1.139587] scsi 1:0:1:0: CD-ROM            Optiarc  DVD RW AD-5240S  1.03 PQ: 0 ANSI: 5
[    1.144739] sr0: scsi3-mmc drive: 48x/48x writer cd/rw xa/form2 cdda tray
[    1.144771] cdrom: Uniform CD-ROM driver Revision: 3.20
[    1.144877] sr 1:0:1:0: Attached scsi CD-ROM sr0
[    1.144920] sr 1:0:1:0: Attached scsi generic sg0 type 5
[    1.148084] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    1.148129] r8169 0000:03:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    1.148196] r8169 0000:03:00.0: setting latency timer to 64
[    1.148233] r8169 0000:03:00.0: irq 40 for MSI/MSI-X
[    1.148472] r8169 0000:03:00.0: eth0: RTL8168d/8111d at 0xffffc9000007a000, 90:e6:ba:10:55:5d, XID 083000c0 IRQ 40
[    1.151180] ahci 0000:00:11.0: version 3.0
[    1.151194] ahci 0000:00:11.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    1.151317] ahci 0000:00:11.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
[    1.151352] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part ccc 
[    1.151821] scsi2 : ahci
[    1.151901] scsi3 : ahci
[    1.152050] scsi4 : ahci
[    1.152139] scsi5 : ahci
[    1.152203] ata3: SATA max UDMA/133 irq_stat 0x00400040, connection status changed irq 22
[    1.152239] ata4: SATA max UDMA/133 abar m1024@0xfe7ffc00 port 0xfe7ffd80 irq 22
[    1.152274] ata5: SATA max UDMA/133 abar m1024@0xfe7ffc00 port 0xfe7ffe00 irq 22
[    1.152308] ata6: SATA max UDMA/133 abar m1024@0xfe7ffc00 port 0xfe7ffe80 irq 22
[    1.152321] firewire_ohci 0000:02:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    1.152328] firewire_ohci 0000:02:00.0: setting latency timer to 64
[    1.203124] firewire_ohci: Added fw-ohci device 0000:02:00.0, OHCI v1.10, 4 IR + 4 IT contexts, quirks 0x10
[    1.457296] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.458108] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.458537] ata4.00: ATA-8: WDC WD1600BEKT-00F3T0, 11.01A11, max UDMA/133
[    1.458571] ata4.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    1.459186] ata6: SATA link down (SStatus 0 SControl 300)
[    1.459232] ata5.00: ATA-8: WDC WD1600BEKT-00F3T0, 11.01A11, max UDMA/133
[    1.459265] ata5.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    1.459883] ata4.00: configured for UDMA/133
[    1.460643] ata5.00: configured for UDMA/133
[    1.482092] usb 4-3: new low speed USB device using ohci_hcd and address 3
[    1.649153] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:12.1/usb4/4-2/4-2:1.0/input/input2
[    1.649247] generic-usb 0003:046D:C521.0001: input,hidraw0: USB HID v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:12.1-2/input0
[    1.661083] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:12.1/usb4/4-2/4-2:1.1/input/input3
[    1.661188] generic-usb 0003:046D:C521.0002: input,hiddev0,hidraw1: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:12.1-2/input1
[    1.673122] input: HID 046a:0021 as /devices/pci0000:00/0000:00:12.1/usb4/4-3/4-3:1.0/input/input4
[    1.673191] generic-usb 0003:046A:0021.0003: input,hidraw2: USB HID v1.11 Keyboard [HID 046a:0021] on usb-0000:00:12.1-3/input0
[    1.681075] input: HID 046a:0021 as /devices/pci0000:00/0000:00:12.1/usb4/4-3/4-3:1.1/input/input5
[    1.681151] generic-usb 0003:046A:0021.0004: input,hidraw3: USB HID v1.11 Device [HID 046a:0021] on usb-0000:00:12.1-3/input1
[    1.681195] usbcore: registered new interface driver usbhid
[    1.681225] usbhid: USB HID core driver
[    1.704136] firewire_core: created device fw0: GUID 001e8c0000a82627, S400
[    1.875104] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.875763] ata3.00: ATA-9: C300-CTFDDAC064MAG, 0006, max UDMA/100
[    1.875794] ata3.00: 125045424 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    1.876636] ata3.00: configured for UDMA/100
[    1.876741] scsi 2:0:0:0: Direct-Access     ATA      C300-CTFDDAC064M 0006 PQ: 0 ANSI: 5
[    1.876871] sd 2:0:0:0: Attached scsi generic sg1 type 0
[    1.876903] sd 2:0:0:0: [sda] 125045424 512-byte logical blocks: (64.0 GB/59.6 GiB)
[    1.876988] sd 2:0:0:0: [sda] Write Protect is off
[    1.877024] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.877029] scsi 3:0:0:0: Direct-Access     ATA      WDC WD1600BEKT-0 11.0 PQ: 0 ANSI: 5
[    1.877050] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.877171] sd 3:0:0:0: Attached scsi generic sg2 type 0
[    1.877201] sd 3:0:0:0: [sdb] 312581808 512-byte logical blocks: (160 GB/149 GiB)
[    1.877244] sd 3:0:0:0: [sdb] Write Protect is off
[    1.877279] sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    1.877338] scsi 4:0:0:0: Direct-Access     ATA      WDC WD1600BEKT-0 11.0 PQ: 0 ANSI: 5
[    1.877343] sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.877498] sd 4:0:0:0: [sdc] 312581808 512-byte logical blocks: (160 GB/149 GiB)
[    1.877506]  sda: sda1 sda2 sda3 sda4
[    1.877509] sd 4:0:0:0: Attached scsi generic sg3 type 0
[    1.877646] sd 4:0:0:0: [sdc] Write Protect is off
[    1.877678] sd 4:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    1.877704] sd 4:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.877837] sd 2:0:0:0: [sda] Attached SCSI disk
[    1.901538]  sdc: sdc1
[    1.901711] sd 4:0:0:0: [sdc] Attached SCSI disk
[    1.904483]  sdb: sdb1
[    1.904645] sd 3:0:0:0: [sdb] Attached SCSI disk
[    1.918768] [drm] radeon defaulting to kernel modesetting.
[    1.918804] [drm] radeon kernel modesetting enabled.
[    1.918882] radeon 0000:01:05.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    1.918917] radeon 0000:01:05.0: setting latency timer to 64
[    1.920199] [drm] initializing kernel modesetting (RS880 0x1002:0x9710).
[    1.920288] [drm] register mmio base: 0xFE9F0000
[    1.920319] [drm] register mmio size: 65536
[    1.920934] ATOM BIOS: 113
[    1.920980] radeon 0000:01:05.0: VRAM: 368M 0x00000000C0000000 - 0x00000000D6FFFFFF (368M used)
[    1.921025] radeon 0000:01:05.0: GTT: 512M 0x00000000A0000000 - 0x00000000BFFFFFFF
[    1.923234] [drm] Detected VRAM RAM=368M, BAR=256M
[    1.923268] [drm] RAM width 32bits DDR
[    1.923354] [TTM] Zone  kernel: Available graphics memory: 1897792 kiB.
[    1.923385] [TTM] Initializing pool allocator.
[    1.923426] [drm] radeon: 368M of VRAM memory ready
[    1.923456] [drm] radeon: 512M of GTT memory ready.
[    1.923514] [drm] radeon: irq initialized.
[    1.923544] [drm] GART: num cpu pages 131072, num gpu pages 131072
[    1.924125] [drm] Loading RS780 Microcode
[    1.929914] radeon 0000:01:05.0: WB enabled
[    1.961966] [drm] ring test succeeded in 1 usecs
[    1.962054] [drm] radeon: ib pool ready.
[    1.962123] [drm] ib test succeeded in 0 usecs
[    1.962162] [drm] Enabling audio support
[    1.962195] failed to evaluate ATIF got AE_BAD_PARAMETER
[    1.962326] [drm] Radeon Display Connectors
[    1.962356] [drm] Connector 0:
[    1.962385] [drm]   VGA
[    1.962414] [drm]   DDC: 0x7e40 0x7e40 0x7e44 0x7e44 0x7e48 0x7e48 0x7e4c 0x7e4c
[    1.962448] [drm]   Encoders:
[    1.962478] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
[    1.962508] [drm] Connector 1:
[    1.962536] [drm]   DVI-D
[    1.962565] [drm]   HPD1
[    1.962594] [drm]   DDC: 0x7e50 0x7e50 0x7e54 0x7e54 0x7e58 0x7e58 0x7e5c 0x7e5c
[    1.962627] [drm]   Encoders:
[    1.962656] [drm]     DFP3: INTERNAL_KLDSCP_LVTMA
[    1.975222] md: bind<sdb1>
[    1.988346] md: bind<sdc1>
[    1.989748] md: raid0 personality registered for level 0
[    1.989904] bio: create slab <bio-1> at 1
[    1.989938] md/raid0:md0: looking at sdc1
[    1.989969] md/raid0:md0:   comparing sdc1(312577024) with sdc1(312577024)
[    1.990035] md/raid0:md0:   END
[    1.990064] md/raid0:md0:   ==> UNIQUE
[    1.990093] md/raid0:md0: 1 zones
[    1.990123] md/raid0:md0: looking at sdb1
[    1.990537] md/raid0:md0:   comparing sdb1(312577024) with sdc1(312577024)
[    1.990595] md/raid0:md0:   EQUAL
[    1.990624] md/raid0:md0: FINAL 1 zones
[    1.990656] md/raid0:md0: done.
[    1.990686] md/raid0:md0: md_size is 625154048 sectors.
[    1.990716] ******* md0 configuration *********
[    1.990746] zone0=[sdb1/sdc1/]
[    1.990855]         zone offset=0kb device offset=0kb size=312577024kb
[    1.990887] **********************************
[    1.990888] 
[    1.990950] md0: detected capacity change from 0 to 320078872576
[    1.991809]  md0: unknown partition table
[    2.016863] [drm] radeon: power management initialized
[    2.099719] [drm] fb mappable at 0xD0141000
[    2.099752] [drm] vram apper at 0xD0000000
[    2.099781] [drm] size 5242880
[    2.099810] [drm] fb depth is 24
[    2.099839] [drm]    pitch is 5120
[    2.114431] Console: switching to colour frame buffer device 160x64
[    2.125769] fb0: radeondrmfb frame buffer device
[    2.125831] drm: registered panic notifier
[    2.125890] [drm] Initialized radeon 2.7.0 20080528 for 0000:01:05.0 on minor 0
[    2.382622] md: linear personality registered for level -1
[    2.386444] md: raid1 personality registered for level 1
[    2.405183] raid6: int64x1   2636 MB/s
[    2.422003] raid6: int64x2   3394 MB/s
[    2.439013] raid6: int64x4   2656 MB/s
[    2.456002] raid6: int64x8   2527 MB/s
[    2.473015] raid6: sse2x1    4292 MB/s
[    2.490011] raid6: sse2x2    7148 MB/s
[    2.507009] raid6: sse2x4    8011 MB/s
[    2.507010] raid6: using algorithm sse2x4 (8011 MB/s)
[    2.507534] xor: automatically using best checksumming function: generic_sse
[    2.512006]    generic_sse: 12264.000 MB/sec
[    2.512008] xor: using function: generic_sse (12264.000 MB/sec)
[    2.514474] md: raid6 personality registered for level 6
[    2.514476] md: raid5 personality registered for level 5
[    2.514477] md: raid4 personality registered for level 4
[    2.518365] md: raid10 personality registered for level 10
[    2.535345] SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, no debug enabled
[    2.535873] SGI XFS Quota Management subsystem
[    2.538913] XFS mounting filesystem sda4
[    2.676772] Ending clean XFS mount for filesystem: sda4
[    2.896542] Adding 4194812k swap on /dev/sda2.  Priority:-1 extents:1 across:4194812k SS
[    6.615374] udev[418]: starting version 163
[    6.639256] ACPI: resource piix4_smbus [io  0x0b00-0x0b07] conflicts with ACPI region SOR1 [irq 2816-2831 64bit disabled]
[    6.639258] ACPI: This conflict may cause random problems and system instability
[    6.639259] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    6.639267] piix4_smbus 0000:00:14.0: SMBus Host Controller at 0xb00, revision 0
[    6.655720] it87: Found IT8712F chip at 0x290, revision 8
[    6.655738] it87: Beeping is supported
[    6.655767] ACPI: resource it87 [io  0x0295-0x0296] conflicts with ACPI region SIOE [??? 0x00000290-0x000002af flags 0xffff88011fd1a0d8]
[    6.655769] ACPI: This conflict may cause random problems and system instability
[    6.655770] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    6.693722] IT8712 SuperIO detected.
[    6.694133] parport_pc 00:06: reported by Plug and Play ACPI
[    6.694182] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
[    6.763034] HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    6.771514] Filesystem "dm-0": Disabling barriers, not supported with external log device
[    6.779169] HDA Intel 0000:01:05.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    6.779199] HDA Intel 0000:01:05.1: setting latency timer to 64
[    6.780571] XFS mounting filesystem dm-0
[    6.884909] Ending clean XFS mount for filesystem: dm-0
[    6.973344] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[    7.008644] sshd (1039): /proc/1039/oom_adj is deprecated, please use /proc/1039/oom_score_adj instead.
[    7.097545] kvm: Nested Virtualization enabled
[    7.097548] kvm: Nested Paging enabled
[    7.127511] r8169 0000:03:00.0: eth0: link up
[    7.127518] r8169 0000:03:00.0: eth0: link up
[    7.154690] Bridge firewalling registered
[    7.172998] ip_tables: (C) 2000-2006 Netfilter Core Team
[    7.223038] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    7.634596] RPC: Registered udp transport module.
[    7.634598] RPC: Registered tcp transport module.
[    7.634600] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    7.643792] FS-Cache: Loaded
[    7.667508] FS-Cache: Netfs 'nfs' registered for caching
[    7.669897] svc: failed to register lockdv1 RPC service (errno 97).
[    7.707820] EXT4-fs (sda1): re-mounted. Opts: commit=0
[    8.526932] hda-intel: IRQ timing workaround is activated for card #1. Suggest a bigger bdl_pos_adj.
[    8.535916] EXT4-fs (sda1): re-mounted. Opts: commit=0
[   17.250187] virbr0: no IPv6 routers present
[   17.611374] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   17.730049] eth0: no IPv6 routers present
[   17.745690] lo: Disabled Privacy Extensions

--=-bCwyszTU8F/Ly5NP9ORN
Content-Disposition: attachment; filename="lspci"
Content-Type: text/plain; name="lspci"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

00:00.0 Host bridge [0600]: Advanced Micro Devices [AMD] RS780 Host Bridge Alternate [1022:9601]
00: 22 10 01 96 06 00 30 22 00 00 00 06 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 43 10 a2 83
30: 00 00 00 00 c4 00 00 00 00 00 00 00 00 00 00 00

00:01.0 PCI bridge [0604]: ASUSTeK Computer Inc. RS880 PCI to PCI bridge (int gfx) [1043:9602]
00: 43 10 02 96 07 01 30 02 00 00 04 06 00 40 01 00
10: 00 00 00 00 00 00 00 00 00 01 01 40 d1 d1 20 02
20: 80 fe 90 fe 01 d0 f1 df 00 00 00 00 00 00 00 00
30: 00 00 00 00 44 00 00 00 00 00 00 00 00 00 1a 00

00:07.0 PCI bridge [0604]: Advanced Micro Devices [AMD] RS780 PCI to PCI bridge (PCIE port 3) [1022:9607]
00: 22 10 07 96 06 05 10 00 00 00 04 06 10 00 01 00
10: 00 00 00 00 00 00 00 00 00 02 02 00 f1 01 00 20
20: a0 fe a0 fe f1 ff 01 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 50 00 00 00 00 00 00 00 0a 01 07 00

00:0a.0 PCI bridge [0604]: Advanced Micro Devices [AMD] RS780 PCI to PCI bridge (PCIE port 5) [1022:9609]
00: 22 10 09 96 07 05 10 00 00 00 04 06 10 00 01 00
10: 00 00 00 00 00 00 00 00 00 03 03 00 e1 e1 00 00
20: b0 fe b0 fe f1 fd f1 fd 00 00 00 00 00 00 00 00
30: 00 00 00 00 50 00 00 00 00 00 00 00 0b 01 07 00

00:11.0 SATA controller [0106]: ATI Technologies Inc SB700/SB800 SATA Controller [AHCI mode] [1002:4391]
00: 02 10 91 43 07 01 30 02 00 01 06 01 10 40 00 00
10: 01 c0 00 00 01 b0 00 00 01 a0 00 00 01 90 00 00
20: 01 80 00 00 00 fc 7f fe 00 00 00 00 43 10 89 83
30: 00 00 00 00 60 00 00 00 00 00 00 00 0a 01 00 00

00:12.0 USB Controller [0c03]: ATI Technologies Inc SB700/SB800 USB OHCI0 Controller [1002:4397]
00: 02 10 97 43 06 01 a0 02 00 10 03 0c 10 40 80 00
10: 00 e0 7f fe 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 43 10 89 83
30: 00 00 00 00 00 00 00 00 00 00 00 00 0b 01 00 00

00:12.1 USB Controller [0c03]: ATI Technologies Inc SB700 USB OHCI1 Controller [1002:4398]
00: 02 10 98 43 17 01 a0 02 00 10 03 0c 10 40 00 00
10: 00 d0 7f fe 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 43 10 89 83
30: 00 00 00 00 00 00 00 00 00 00 00 00 0b 01 00 00

00:12.2 USB Controller [0c03]: ATI Technologies Inc SB700/SB800 USB EHCI Controller [1002:4396]
00: 02 10 96 43 16 01 b0 02 00 20 03 0c 10 40 00 00
10: 00 f8 7f fe 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 43 10 89 83
30: 00 00 00 00 c0 00 00 00 00 00 00 00 0a 02 00 00

00:13.0 USB Controller [0c03]: ATI Technologies Inc SB700/SB800 USB OHCI0 Controller [1002:4397]
00: 02 10 97 43 06 01 a0 02 00 10 03 0c 10 40 80 00
10: 00 c0 7f fe 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 43 10 89 83
30: 00 00 00 00 00 00 00 00 00 00 00 00 0b 01 00 00

00:13.1 USB Controller [0c03]: ATI Technologies Inc SB700 USB OHCI1 Controller [1002:4398]
00: 02 10 98 43 17 01 a0 02 00 10 03 0c 10 40 00 00
10: 00 b0 7f fe 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 43 10 89 83
30: 00 00 00 00 00 00 00 00 00 00 00 00 0b 01 00 00

00:13.2 USB Controller [0c03]: ATI Technologies Inc SB700/SB800 USB EHCI Controller [1002:4396]
00: 02 10 96 43 16 01 b0 02 00 20 03 0c 10 40 00 00
10: 00 f4 7f fe 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 43 10 89 83
30: 00 00 00 00 c0 00 00 00 00 00 00 00 0a 02 00 00

00:14.0 SMBus [0c05]: ATI Technologies Inc SBx00 SMBus Controller [1002:4385] (rev 3c)
00: 02 10 85 43 03 04 30 02 3c 00 05 0c 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 43 10 89 83
30: 00 00 00 00 b0 00 00 00 00 00 00 00 00 00 00 00

00:14.1 IDE interface [0101]: ATI Technologies Inc SB700/SB800 IDE Controller [1002:439c]
00: 02 10 9c 43 05 00 30 02 00 8a 01 01 00 40 00 00
10: 01 00 00 00 01 00 00 00 01 00 00 00 01 00 00 00
20: 01 ff 00 00 00 00 00 00 00 00 00 00 43 10 89 83
30: 00 00 00 00 70 00 00 00 00 00 00 00 00 01 00 00

00:14.2 Audio device [0403]: ATI Technologies Inc SBx00 Azalia (Intel HDA) [1002:4383]
00: 02 10 83 43 06 00 10 04 00 00 03 04 10 40 00 00
10: 04 40 7f fe 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 43 10 6c 83
30: 00 00 00 00 50 00 00 00 00 00 00 00 0b 00 00 00

00:14.3 ISA bridge [0601]: ATI Technologies Inc SB700/SB800 LPC host controller [1002:439d]
00: 02 10 9d 43 0f 00 20 02 00 00 01 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 43 10 89 83
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:14.4 PCI bridge [0604]: ATI Technologies Inc SBx00 PCI to PCI Bridge [1002:4384]
00: 02 10 84 43 05 01 a0 02 00 01 04 06 00 40 81 00
10: 00 00 00 00 00 00 00 00 00 04 04 40 f0 00 80 22
20: f0 ff 00 00 f0 ff 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 07 00

00:14.5 USB Controller [0c03]: ATI Technologies Inc SB700/SB800 USB OHCI2 Controller [1002:4399]
00: 02 10 99 43 06 01 a0 02 00 10 03 0c 10 40 00 00
10: 00 a0 7f fe 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 43 10 89 83
30: 00 00 00 00 00 00 00 00 00 00 00 00 0b 03 00 00

00:18.0 Host bridge [0600]: Advanced Micro Devices [AMD] Family 10h Processor HyperTransport Configuration [1022:1200]
00: 22 10 00 12 00 00 10 00 00 00 00 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 80 00 00 00 00 00 00 00 00 00 00 00

00:18.1 Host bridge [0600]: Advanced Micro Devices [AMD] Family 10h Processor Address Map [1022:1201]
00: 22 10 01 12 00 00 00 00 00 00 00 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:18.2 Host bridge [0600]: Advanced Micro Devices [AMD] Family 10h Processor DRAM Controller [1022:1202]
00: 22 10 02 12 00 00 00 00 00 00 00 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:18.3 Host bridge [0600]: Advanced Micro Devices [AMD] Family 10h Processor Miscellaneous Control [1022:1203]
00: 22 10 03 12 00 00 10 00 00 00 00 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 f0 00 00 00 00 00 00 00 00 00 00 00

00:18.4 Host bridge [0600]: Advanced Micro Devices [AMD] Family 10h Processor Link Control [1022:1204]
00: 22 10 04 12 00 00 00 00 00 00 00 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

01:05.0 VGA compatible controller [0300]: ATI Technologies Inc RS880 [Radeon HD 4200] [1002:9710]
00: 02 10 10 97 07 01 10 00 00 00 00 03 10 00 80 00
10: 08 00 00 d0 01 d0 00 00 00 00 9f fe 00 00 00 00
20: 00 00 00 00 00 00 80 fe 00 00 00 00 43 10 a2 83
30: 00 00 00 00 50 00 00 00 00 00 00 00 0b 01 00 00

01:05.1 Audio device [0403]: ATI Technologies Inc RS880 Audio Device [Radeon HD 4200] [1002:970f]
00: 02 10 0f 97 07 01 10 00 00 00 03 04 10 00 80 00
10: 00 80 9e fe 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 43 10 a2 83
30: 00 00 00 00 50 00 00 00 00 00 00 00 0a 02 00 00

02:00.0 FireWire (IEEE 1394) [0c00]: JMicron Technology Corp. IEEE 1394 Host Controller [197b:2380]
00: 7b 19 80 23 07 01 10 00 00 10 00 0c 10 00 00 00
10: 00 f8 af fe 00 f4 af fe 00 00 00 00 00 00 00 00
20: 00 f0 af fe 00 ec af fe 00 00 00 00 43 10 13 83
30: 00 00 00 00 44 00 00 00 00 00 00 00 0a 01 00 00

03:00.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit Ethernet controller [10ec:8168] (rev 03)
00: ec 10 68 81 07 05 10 00 03 00 00 02 10 00 00 00
10: 01 e8 00 00 00 00 00 00 0c f0 ff fd 00 00 00 00
20: 0c 80 ff fd 00 00 00 00 00 00 00 00 43 10 a3 83
30: 00 00 bf fe 40 00 00 00 00 00 00 00 0b 01 00 00


--=-bCwyszTU8F/Ly5NP9ORN
Content-Disposition: attachment; filename="dmidecode"
Content-Type: text/plain; name="dmidecode"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

# dmidecode 2.9
SMBIOS 2.5 present.
67 structures occupying 2414 bytes.
Table at 0x0009F000.

Handle 0x0000, DMI type 0, 24 bytes
BIOS Information
	Vendor: American Megatrends Inc.
	Version: 2103   
	Release Date: 06/30/2010
	Address: 0xF0000
	Runtime Size: 64 kB
	ROM Size: 1024 kB
	Characteristics:
		ISA is supported
		PCI is supported
		PNP is supported
		APM is supported
		BIOS is upgradeable
		BIOS shadowing is allowed
		ESCD support is available
		Boot from CD is supported
		Selectable boot is supported
		BIOS ROM is socketed
		EDD is supported
		5.25"/1.2 MB floppy services are supported (int 13h)
		3.5"/720 KB floppy services are supported (int 13h)
		3.5"/2.88 MB floppy services are supported (int 13h)
		Print screen service is supported (int 5h)
		8042 keyboard services are supported (int 9h)
		Serial services are supported (int 14h)
		Printer services are supported (int 17h)
		CGA/mono video services are supported (int 10h)
		ACPI is supported
		USB legacy is supported
		LS-120 boot is supported
		ATAPI Zip drive boot is supported
		BIOS boot specification is supported
		Targeted content distribution is supported
	BIOS Revision: 8.15

Handle 0x0001, DMI type 1, 27 bytes
System Information
	Manufacturer: System manufacturer
	Product Name: System Product Name
	Version: System Version
	Serial Number: System Serial Number
	UUID: A02F001E-8C00-00A8-2627-90E6BA10555D
	Wake-up Type: Power Switch
	SKU Number: To Be Filled By O.E.M.
	Family: To Be Filled By O.E.M.

Handle 0x0002, DMI type 2, 15 bytes
Base Board Information
	Manufacturer: ASUSTeK Computer INC.
	Product Name: M4A785TD-M EVO
	Version: Rev X.0x
	Serial Number: 101488550000197
	Asset Tag: To Be Filled By O.E.M.
	Features:
		Board is a hosting board
		Board is replaceable
	Location In Chassis: To Be Filled By O.E.M.
	Chassis Handle: 0x0003
	Type: Motherboard
	Contained Object Handles: 0

Handle 0x0003, DMI type 3, 21 bytes
Chassis Information
	Manufacturer: Chassis Manufacture
	Type: Desktop
	Lock: Not Present
	Version: Chassis Version
	Serial Number: Chassis Serial Number
	Asset Tag: Asset-1234567890
	Boot-up State: Safe
	Power Supply State: Safe
	Thermal State: Safe
	Security Status: None
	OEM Information: 0x00000001
	Height: Unspecified
	Number Of Power Cords: 1
	Contained Elements: 0

Handle 0x0004, DMI type 4, 40 bytes
Processor Information
	Socket Designation: AM3
	Type: Central Processor
	Family: <OUT OF SPEC>
	Manufacturer: AMD              
	ID: 42 0F 10 00 FF FB 8B 17
	Version: AMD Phenom(tm) II X4 B45 Processor                  
	Voltage: 1.5 V
	External Clock: 200 MHz
	Max Speed: 3000 MHz
	Current Speed: 3000 MHz
	Status: Populated, Enabled
	Upgrade: Other
	L1 Cache Handle: 0x0005
	L2 Cache Handle: 0x0006
	L3 Cache Handle: 0x0007
	Serial Number: To Be Filled By O.E.M.
	Asset Tag: To Be Filled By O.E.M.
	Part Number: To Be Filled By O.E.M.
	Core Count: 4
	Core Enabled: 4
	Characteristics:
		64-bit capable

Handle 0x0005, DMI type 7, 19 bytes
Cache Information
	Socket Designation: L1-Cache
	Configuration: Enabled, Not Socketed, Level 1
	Operational Mode: Varies With Memory Address
	Location: Internal
	Installed Size: 512 KB
	Maximum Size: 512 KB
	Supported SRAM Types:
		Pipeline Burst
	Installed SRAM Type: Pipeline Burst
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Data
	Associativity: 4-way Set-associative

Handle 0x0006, DMI type 7, 19 bytes
Cache Information
	Socket Designation: L2-Cache
	Configuration: Enabled, Not Socketed, Level 2
	Operational Mode: Varies With Memory Address
	Location: Internal
	Installed Size: 2048 KB
	Maximum Size: 2048 KB
	Supported SRAM Types:
		Pipeline Burst
	Installed SRAM Type: Pipeline Burst
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Unified
	Associativity: 4-way Set-associative

Handle 0x0007, DMI type 7, 19 bytes
Cache Information
	Socket Designation: L3-Cache
	Configuration: Enabled, Not Socketed, Level 3
	Operational Mode: Varies With Memory Address
	Location: Internal
	Installed Size: 6144 KB
	Maximum Size: 6144 KB
	Supported SRAM Types:
		Pipeline Burst
	Installed SRAM Type: Pipeline Burst
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Unified
	Associativity: 4-way Set-associative

Handle 0x0008, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: PS/2 Keyboard/Mouse
	Internal Connector Type: None
	External Reference Designator: PS/2 Keyboard/Mouse
	External Connector Type: PS/2
	Port Type: Other

Handle 0x0009, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: USB12
	Internal Connector Type: None
	External Reference Designator: USB12
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x000A, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: USB34
	Internal Connector Type: None
	External Reference Designator: USB34
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x000B, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: USB56
	Internal Connector Type: None
	External Reference Designator: USB56
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x000C, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: LAN
	Internal Connector Type: None
	External Reference Designator: LAN
	External Connector Type: RJ-45
	Port Type: Network Port

Handle 0x000D, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Audio_Line_In
	Internal Connector Type: None
	External Reference Designator: Audio_Line_In
	External Connector Type: Mini Jack (headphones)
	Port Type: Audio Port

Handle 0x000E, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Audio_Line_Out
	Internal Connector Type: None
	External Reference Designator: Audio_Line_Out
	External Connector Type: Mini Jack (headphones)
	Port Type: Audio Port

Handle 0x000F, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Audio_Mic_In
	Internal Connector Type: None
	External Reference Designator: Audio_Mic_In
	External Connector Type: Mini Jack (headphones)
	Port Type: Audio Port

Handle 0x0010, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Audio_Center/Sub
	Internal Connector Type: None
	External Reference Designator: Audio_Center/Sub
	External Connector Type: Mini Jack (headphones)
	Port Type: Audio Port

Handle 0x0011, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Audio_Rear
	Internal Connector Type: None
	External Reference Designator: Audio_Rear
	External Connector Type: Mini Jack (headphones)
	Port Type: Audio Port

Handle 0x0012, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Audio_Side
	Internal Connector Type: None
	External Reference Designator: Audio_Side
	External Connector Type: Mini Jack (headphones)
	Port Type: Audio Port

Handle 0x0013, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: HDMI
	Internal Connector Type: None
	External Reference Designator: HDMI port
	External Connector Type: Other
	Port Type: Other

Handle 0x0014, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: VGA
	Internal Connector Type: None
	External Reference Designator: D_SUB
	External Connector Type: DB-15 female
	Port Type: Video Port

Handle 0x0015, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: DVI
	Internal Connector Type: None
	External Reference Designator: DVI port
	External Connector Type: Other
	Port Type: Other

Handle 0x0016, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: IE1394_1
	Internal Connector Type: None
	External Reference Designator: 1394
	External Connector Type: IEEE 1394
	Port Type: Firewire (IEEE P1394)

Handle 0x0017, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: ESATA
	Internal Connector Type: None
	External Reference Designator: ESATA
	External Connector Type: SAS/SATA Plug Receptacle
	Port Type: SATA

Handle 0x0018, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: SPDIFO
	Internal Connector Type: None
	External Reference Designator: SPDIF_OUT
	External Connector Type: Mini Jack (headphones)
	Port Type: Audio Port

Handle 0x0019, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: PRI IDE
	Internal Connector Type: On Board IDE
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x001A, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: SB_SATA1
	Internal Connector Type: Other
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x001B, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: SB_SATA2
	Internal Connector Type: Other
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x001C, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: SB_SATA3
	Internal Connector Type: Other
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x001D, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: SB_SATA5
	Internal Connector Type: Other
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x001E, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: SB_SATA6
	Internal Connector Type: Other
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x001F, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: CPU FAN
	Internal Connector Type: Other
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x0020, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: CHA FAN
	Internal Connector Type: Other
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x0021, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: PWR FAN
	Internal Connector Type: Other
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x0022, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: USB78
	Internal Connector Type: Access Bus (USB)
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: USB

Handle 0x0023, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: USB910
	Internal Connector Type: Access Bus (USB)
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: USB

Handle 0x0024, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: USB1112
	Internal Connector Type: Access Bus (USB)
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: USB

Handle 0x0025, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: PANEL
	Internal Connector Type: Other
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x0026, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: SPDIF OUT
	Internal Connector Type: Other
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x0027, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: AAFP
	Internal Connector Type: Other
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x0028, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: CD
	Internal Connector Type: On Board Sound Input From CD-ROM
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Audio Port

Handle 0x0029, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: COM1
	Internal Connector Type: 9 Pin Dual Inline (pin 10 cut)
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x002A, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: LPT
	Internal Connector Type: 25 Pin Dual Inline (pin 26 cut)
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x002B, DMI type 9, 13 bytes
System Slot Information
	Designation: PCIE1X
	Type: 32-bit PCI Express
	Current Usage: Available
	Length: Short
	ID: 9
	Characteristics:
		3.3 V is provided
		Opening is shared
		PME signal is supported

Handle 0x002C, DMI type 9, 13 bytes
System Slot Information
	Designation: PCIE16X
	Type: 32-bit PCI Express
	Current Usage: Available
	Length: Short
	ID: 2
	Characteristics:
		3.3 V is provided
		Opening is shared
		PME signal is supported

Handle 0x002D, DMI type 9, 13 bytes
System Slot Information
	Designation: PCI1
	Type: 32-bit PCI
	Current Usage: Available
	Length: Short
	ID: 12
	Characteristics:
		3.3 V is provided
		Opening is shared
		PME signal is supported

Handle 0x002E, DMI type 9, 13 bytes
System Slot Information
	Designation: PCI2
	Type: 32-bit PCI
	Current Usage: Available
	Length: Short
	ID: 13
	Characteristics:
		3.3 V is provided
		Opening is shared
		PME signal is supported

Handle 0x002F, DMI type 10, 6 bytes
On Board Device Information
	Type: Video
	Status: Enabled
	Description:   ATI

Handle 0x0030, DMI type 10, 6 bytes
On Board Device Information
	Type: Ethernet
	Status: Enabled
	Description: To Be Filled By O.E.M.

Handle 0x0031, DMI type 10, 6 bytes
On Board Device Information
	Type: Sound
	Status: Enabled
	Description: To Be Filled By O.E.M.

Handle 0x0032, DMI type 10, 6 bytes
On Board Device Information
	Type: Other
	Status: Enabled
	Description: To Be Filled By O.E.M.

Handle 0x0033, DMI type 11, 5 bytes
OEM Strings
	String 1: 90E6BA10555D
	String 2: To Be Filled By O.E.M.
	String 3: To Be Filled By O.E.M.
	String 4: To Be Filled By O.E.M.

Handle 0x0034, DMI type 13, 22 bytes
BIOS Language Information
	Installable Languages: 1
		en|US|iso8859-1
	Currently Installed Language: en|US|iso8859-1

Handle 0x0035, DMI type 15, 35 bytes
System Event Log
	Area Length: 4 bytes
	Header Start Offset: 0x0000
	Header Length: 2 bytes
	Data Start Offset: 0x0002
	Access Method: Indexed I/O, one 16-bit index port, one 8-bit data port
	Access Address: Index 0x046A, Data 0x046C
	Status: Invalid, Not Full
	Change Token: 0x00000000
	Header Format: No Header
	Supported Log Type Descriptors: 6
	Descriptor 1: End of log
	Data Format 1: OEM-specific
	Descriptor 2: End of log
	Data Format 2: OEM-specific
	Descriptor 3: End of log
	Data Format 3: OEM-specific
	Descriptor 4: End of log
	Data Format 4: OEM-specific
	Descriptor 5: End of log
	Data Format 5: OEM-specific
	Descriptor 6: End of log
	Data Format 6: OEM-specific

Handle 0x0036, DMI type 16, 15 bytes
Physical Memory Array
	Location: System Board Or Motherboard
	Use: System Memory
	Error Correction Type: None
	Maximum Capacity: 16 GB
	Error Information Handle: Not Provided
	Number Of Devices: 4

Handle 0x0037, DMI type 19, 15 bytes
Memory Array Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x0012FFFFFFF
	Range Size: 4864 MB
	Physical Array Handle: 0x0036
	Partition Width: 0

Handle 0x0038, DMI type 17, 27 bytes
Memory Device
	Array Handle: 0x0036
	Error Information Handle: Not Provided
	Total Width: Unknown
	Data Width: Unknown
	Size: No Module Installed
	Form Factor: DIMM
	Set: None
	Locator: DIMM0
	Bank Locator: BANK0
	Type: Unknown
	Type Detail: None
	Speed: Unknown
	Manufacturer: Manufacturer0
	Serial Number: SerNum0
	Asset Tag: AssetTagNum0
	Part Number: PartNum0

Handle 0x0039, DMI type 126, 19 bytes
Inactive

Handle 0x003A, DMI type 17, 27 bytes
Memory Device
	Array Handle: 0x0036
	Error Information Handle: Not Provided
	Total Width: Unknown
	Data Width: Unknown
	Size: No Module Installed
	Form Factor: DIMM
	Set: None
	Locator: DIMM1
	Bank Locator: BANK1
	Type: Unknown
	Type Detail: None
	Speed: Unknown
	Manufacturer: Manufacturer1
	Serial Number: SerNum1
	Asset Tag: AssetTagNum1
	Part Number: PartNum1

Handle 0x003B, DMI type 126, 19 bytes
Inactive

Handle 0x003C, DMI type 17, 27 bytes
Memory Device
	Array Handle: 0x0036
	Error Information Handle: Not Provided
	Total Width: 64 bits
	Data Width: 64 bits
	Size: 2048 MB
	Form Factor: DIMM
	Set: None
	Locator: DIMM2
	Bank Locator: BANK2
	Type: Other
	Type Detail: Synchronous
	Speed: 1333 MHz (0.8 ns)
	Manufacturer: Manufacturer2
	Serial Number: SerNum2
	Asset Tag: AssetTagNum2
	Part Number: PartNum2

Handle 0x003D, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x0007FFFFFFF
	Range Size: 2 GB
	Physical Device Handle: 0x003C
	Memory Array Mapped Address Handle: 0x0037
	Partition Row Position: 1

Handle 0x003E, DMI type 17, 27 bytes
Memory Device
	Array Handle: 0x0036
	Error Information Handle: Not Provided
	Total Width: 64 bits
	Data Width: 64 bits
	Size: 2048 MB
	Form Factor: DIMM
	Set: None
	Locator: DIMM3
	Bank Locator: BANK3
	Type: Other
	Type Detail: Synchronous
	Speed: 1333 MHz (0.8 ns)
	Manufacturer: Manufacturer3
	Serial Number: SerNum3
	Asset Tag: AssetTagNum3
	Part Number: PartNum3

Handle 0x003F, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00080000000
	Ending Address: 0x000FFFFFFFF
	Range Size: 2 GB
	Physical Device Handle: 0x003E
	Memory Array Mapped Address Handle: 0x0037
	Partition Row Position: 1

Handle 0x0040, DMI type 32, 20 bytes
System Boot Information
	Status: No errors detected

Handle 0x0041, DMI type 139, 54 bytes
OEM-specific Type
	Header and Data:
		8B 36 41 00 00 1E 8C 00 00 A8 26 27 00 00 00 00
		02 A0 00 F8 00 00 00 00 43 10 13 83 03 DF 40 80
		00 20 00 00 3C 10 08 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 01
	Strings:
		1394GUID

Handle 0x0042, DMI type 127, 4 bytes
End Of Table


--=-bCwyszTU8F/Ly5NP9ORN--


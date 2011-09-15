Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365Ab1IOIXP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 04:23:15 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:60632
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753125Ab1IOIXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 04:23:05 -0400
X-Greylist: delayed 601 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Sep 2011 04:23:02 EDT
X-IronPort-AV: E=Sophos;i="4.68,385,1312149600"; 
   d="bad'?good'?scan'208";a="109138386"
Date: Thu, 15 Sep 2011 10:12:59 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Keith Packard <keithp@keithp.com>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] i915 KMS dual head broken on DELL latitude E6420 in
 3.1-rc*
Message-ID: <20110915081259.GB4877@type.bordeaux.inria.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Keith Packard <keithp@keithp.com>, dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
References: <20110914232717.GA5410@type.famille.thibault.fr>
 <yunobym743b.fsf@aiko.keithp.com>
 <20110915074106.GA4544@type.famille.thibault.fr>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="W/nzBZO5zC0uMSeA"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110915074106.GA4544@type.famille.thibault.fr>
User-Agent: Mutt/1.5.21+34 (58baf7c9f32f) (2010-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Samuel Thibault, le Thu 15 Sep 2011 09:41:06 +0200, a écrit :
> Keith Packard, le Thu 15 Sep 2011 00:43:36 -0500, a écrit :
> > On Thu, 15 Sep 2011 01:27:17 +0200, Samuel Thibault <samuel.thibault@ens-lyon.org> wrote:
> > Non-text part: multipart/mixed
> > > I'm trying to upgrade from 3.0 to 3.1-rcsomething on a DELL latitude
> > > E6420, but dual head is broken. Here is the scenario:
> > > 
> > > - Turn computer on with VGA1 connected. Both LVDS1 and VGA1 show the
> > >   text console fine.
> > > - Start X. VGA1 shows X fine, but LVDS1 (1600x900 resolution) shows an
> > >   odd screen: completely black on the left part (about 1060x900), sort
> > >   of gray on the right part (about 540x900). Playing with xrandr doesn't
> > >   help, I can at best make it completely black with --off, and not get
> > >   it back again with --auto or anything else.
> > 
> > Can you try disabling frame buffer compression?
> > 
> > i915.i915_enable-fbc=0
> > 
> > I'm about to send a patch to disable this by default; I've gotten two
> > people saying that this helps them already.
> 
> Absolutely. I have no issue any more, and the error messages are gone.

At home only. At work, with a different VGA screen, I'm still getting
the issue.

Samuel

--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg.bad"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.1.0-rc6 (samy@type) (gcc version 4.6.1 (Debian 4.6.1-4) ) #1 SMP Wed Sep 14 19:23:48 CEST 2011
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.1.0-rc6 root=UUID=38e6e493-2f5f-4a98-b1d6-a9434f0683cc ro i915.i915_enable-fbc=0
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 0000000000091400 (usable)
[    0.000000]  BIOS-e820: 0000000000091400 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 0000000020000000 (usable)
[    0.000000]  BIOS-e820: 0000000020000000 - 0000000020200000 (reserved)
[    0.000000]  BIOS-e820: 0000000020200000 - 0000000040000000 (usable)
[    0.000000]  BIOS-e820: 0000000040000000 - 0000000040200000 (reserved)
[    0.000000]  BIOS-e820: 0000000040200000 - 00000000baa2a000 (usable)
[    0.000000]  BIOS-e820: 00000000baa2a000 - 00000000baa6e000 (reserved)
[    0.000000]  BIOS-e820: 00000000baa6e000 - 00000000badb7000 (usable)
[    0.000000]  BIOS-e820: 00000000badb7000 - 00000000bade7000 (reserved)
[    0.000000]  BIOS-e820: 00000000bade7000 - 00000000bafe7000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bafe7000 - 00000000bafff000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bafff000 - 00000000bb000000 (usable)
[    0.000000]  BIOS-e820: 00000000bb800000 - 00000000bfa00000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffc00000 - 00000000ffc20000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000013e000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.6 present.
[    0.000000] DMI: Dell Inc. Latitude E6420/032T9K, BIOS A05 05/24/2011
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x13e000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 080000000 mask FC0000000 write-back
[    0.000000]   2 base 0BC000000 mask FFC000000 uncachable
[    0.000000]   3 base 0BB000000 mask FFF000000 uncachable
[    0.000000]   4 base 100000000 mask FC0000000 write-back
[    0.000000]   5 base 13E000000 mask FFE000000 uncachable
[    0.000000]   6 base 0FFC00000 mask FFFC00000 write-protect
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] last_pfn = 0xbb000 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [ffff8800000f1b60] f1b60
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff88000008c000] 8c000 size 20480
[    0.000000] init_memory_mapping: 0000000000000000-00000000bb000000
[    0.000000]  0000000000 - 00bb000000 page 2M
[    0.000000] kernel direct mapping tables up to bb000000 @ badb3000-badb7000
[    0.000000] init_memory_mapping: 0000000100000000-000000013e000000
[    0.000000]  0100000000 - 013e000000 page 2M
[    0.000000] kernel direct mapping tables up to 13e000000 @ 13dffa000-13e000000
[    0.000000] RAMDISK: 3428c000 - 3613e000
[    0.000000] ACPI: RSDP 00000000000fe300 00024 (v02 DELL  )
[    0.000000] ACPI: XSDT 00000000baffde18 0007C (v01 DELL    CBX3    06222004 MSFT 00010013)
[    0.000000] ACPI: FACP 00000000baf87d98 000F4 (v04 DELL    CBX3    06222004 MSFT 00010013)
[    0.000000] ACPI Warning: 32/64 FACS address mismatch in FADT - two FACS tables! (20110623/tbfadt-369)
[    0.000000] ACPI Warning: 32/64X FACS address mismatch in FADT - 0xBAFE4E40/0x00000000BAFE4D40, using 32 (20110623/tbfadt-489)
[    0.000000] ACPI: DSDT 00000000baf6d018 08A3D (v02 INT430 SYSFexxx 00001001 INTL 20090903)
[    0.000000] ACPI: FACS 00000000bafe4e40 00040
[    0.000000] ACPI: APIC 00000000baffcf18 000CC (v02 DELL    CBX3    06222004 MSFT 00010013)
[    0.000000] ACPI: TCPA 00000000bafe5d18 00032 (v02                 00000000      00000000)
[    0.000000] ACPI: MCFG 00000000bafe5c98 0003C (v01 DELL   SNDYBRDG 06222004 MSFT 00000097)
[    0.000000] ACPI: HPET 00000000bafe5c18 00038 (v01 A M I   PCHHPET 06222004 AMI. 00000003)
[    0.000000] ACPI: BOOT 00000000bafe5b98 00028 (v01 DELL   CBX3     06222004 AMI  00010013)
[    0.000000] ACPI: SSDT 00000000baf6c018 0094E (v01  PmRef  Cpu0Ist 00003000 INTL 20090903)
[    0.000000] ACPI: SSDT 00000000baf6b018 00996 (v01  PmRef    CpuPm 00003000 INTL 20090903)
[    0.000000] ACPI: DMAR 00000000baf87c18 000E8 (v01 INTEL      SNB  00000001 INTL 00000001)
[    0.000000] ACPI: SLIC 00000000baf88a18 00176 (v03 DELL    CBX3    06222004 MSFT 00010013)
[    0.000000] ACPI: SSDT 00000000baf65018 014A0 (v01 NvdRef  NvdTabl 00001000 INTL 20090903)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000013e000000
[    0.000000] Initmem setup node 0 0000000000000000-000000013e000000
[    0.000000]   NODE_DATA [000000013dffb000 - 000000013dffffff]
[    0.000000]  [ffffea0000000000-ffffea00045fffff] PMD -> [ffff880139600000-ffff88013cdfffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x0013e000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[7] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x00000091
[    0.000000]     0: 0x00000100 -> 0x00020000
[    0.000000]     0: 0x00020200 -> 0x00040000
[    0.000000]     0: 0x00040200 -> 0x000baa2a
[    0.000000]     0: 0x000baa6e -> 0x000badb7
[    0.000000]     0: 0x000bafff -> 0x000bb000
[    0.000000]     0: 0x00100000 -> 0x0013e000
[    0.000000] On node 0 totalpages: 1018101
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 5 pages reserved
[    0.000000]   DMA zone: 3908 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 745900 pages, LIFO batch:31
[    0.000000]   Normal zone: 3472 pages used for memmap
[    0.000000]   Normal zone: 250480 pages, LIFO batch:31
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
[    0.000000] PM: Registered nosave memory: 0000000000091000 - 0000000000092000
[    0.000000] PM: Registered nosave memory: 0000000000092000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 0000000020000000 - 0000000020200000
[    0.000000] PM: Registered nosave memory: 0000000040000000 - 0000000040200000
[    0.000000] PM: Registered nosave memory: 00000000baa2a000 - 00000000baa6e000
[    0.000000] PM: Registered nosave memory: 00000000badb7000 - 00000000bade7000
[    0.000000] PM: Registered nosave memory: 00000000bade7000 - 00000000bafe7000
[    0.000000] PM: Registered nosave memory: 00000000bafe7000 - 00000000bafff000
[    0.000000] PM: Registered nosave memory: 00000000bb000000 - 00000000bb800000
[    0.000000] PM: Registered nosave memory: 00000000bb800000 - 00000000bfa00000
[    0.000000] PM: Registered nosave memory: 00000000bfa00000 - 00000000fed1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed20000
[    0.000000] PM: Registered nosave memory: 00000000fed20000 - 00000000ffc00000
[    0.000000] PM: Registered nosave memory: 00000000ffc00000 - 00000000ffc20000
[    0.000000] PM: Registered nosave memory: 00000000ffc20000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at bfa00000 (gap: bfa00000:3f31c000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:16 nr_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88013dc00000 s80768 r8192 d21632 u131072
[    0.000000] pcpu-alloc: s80768 r8192 d21632 u131072 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1000288
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.1.0-rc6 root=UUID=38e6e493-2f5f-4a98-b1d6-a9434f0683cc ro i915.i915_enable-fbc=0
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave/xrstor: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Queued invalidation will be enabled to support x2apic and Intr-remapping.
[    0.000000] Memory: 3907288k/5210112k available (3984k kernel code, 1137708k absent, 165116k reserved, 2772k data, 576k init)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] NR_IRQS:33024 nr_irqs:808 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 33554432 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.004000] Detected 2195.430 MHz processor.
[    0.000003] Calibrating delay loop (skipped), value calculated using timer frequency.. 4390.86 BogoMIPS (lpj=8781720)
[    0.000121] pid_max: default: 32768 minimum: 301
[    0.000227] Security Framework initialized
[    0.000287] SELinux:  Disabled at boot.
[    0.000743] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.001759] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.002217] Mount-cache hash table entries: 256
[    0.002406] Initializing cgroup subsys cpuacct
[    0.002469] Initializing cgroup subsys memory
[    0.002539] Initializing cgroup subsys devices
[    0.002599] Initializing cgroup subsys freezer
[    0.002656] Initializing cgroup subsys net_cls
[    0.002715] Initializing cgroup subsys blkio
[    0.002804] CPU: Physical Processor ID: 0
[    0.002860] CPU: Processor Core ID: 0
[    0.002919] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.002920] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.003041] mce: CPU supports 9 MCE banks
[    0.003109] CPU0: Thermal monitoring enabled (TM1)
[    0.003176] using mwait in idle threads.
[    0.003724] ACPI: Core revision 20110623
[    0.012032] DMAR: Host address width 36
[    0.012091] DMAR: DRHD base: 0x000000fed90000 flags: 0x0
[    0.012157] IOMMU 0: reg_base_addr fed90000 ver 1:0 cap c0000020e60262 ecap f0101a
[    0.012234] DMAR: DRHD base: 0x000000fed91000 flags: 0x1
[    0.012298] IOMMU 1: reg_base_addr fed91000 ver 1:0 cap c9008020660262 ecap f0105a
[    0.012374] DMAR: RMRR base: 0x000000badc6000 end: 0x000000badd5fff
[    0.012436] DMAR: RMRR base: 0x000000bb800000 end: 0x000000bf9fffff
[    0.012499] DMAR: No ATSR found
[    0.012625] IOAPIC id 2 under DRHD base  0xfed91000 IOMMU 1
[    0.012685] HPET id 0 under DRHD base 0xfed91000
[    0.012744] HPET id 0 under DRHD base 0xfed91000
[    0.012803] HPET id 0 under DRHD base 0xfed91000
[    0.012862] HPET id 0 under DRHD base 0xfed91000
[    0.012920] HPET id 0 under DRHD base 0xfed91000
[    0.012979] HPET id 0 under DRHD base 0xfed91000
[    0.013037] HPET id 0 under DRHD base 0xfed91000
[    0.013096] HPET id 0 under DRHD base 0xfed91000
[    0.013349] Enabled Interrupt-remapping
[    0.013406] Enabling x2apic
[    0.013461] Enabled x2apic
[    0.014897] Switched APIC routing to cluster x2apic.
[    0.015338] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.055047] CPU0: Intel(R) Core(TM) i7-2720QM CPU @ 2.20GHz stepping 07
[    0.159663] Performance Events: PEBS fmt1+, SandyBridge events, Intel PMU driver.
[    0.159855] ... version:                3
[    0.159914] ... bit width:              48
[    0.159972] ... generic registers:      4
[    0.160030] ... value mask:             0000ffffffffffff
[    0.160089] ... max period:             000000007fffffff
[    0.160149] ... fixed-purpose events:   3
[    0.160208] ... event mask:             000000070000000f
[    0.160477] NMI watchdog enabled, takes one hw-pmu counter.
[    0.160642] Booting Node   0, Processors  #1
[    0.160727] smpboot cpu 1: start_ip = 8c000
[    0.271670] NMI watchdog enabled, takes one hw-pmu counter.
[    0.271836]  #2
[    0.271878] smpboot cpu 2: start_ip = 8c000
[    0.379536] NMI watchdog enabled, takes one hw-pmu counter.
[    0.379703]  #3
[    0.379745] smpboot cpu 3: start_ip = 8c000
[    0.487402] NMI watchdog enabled, takes one hw-pmu counter.
[    0.487567]  #4
[    0.487610] smpboot cpu 4: start_ip = 8c000
[    0.595278] NMI watchdog enabled, takes one hw-pmu counter.
[    0.595452]  #5
[    0.595495] smpboot cpu 5: start_ip = 8c000
[    0.703152] NMI watchdog enabled, takes one hw-pmu counter.
[    0.703318]  #6
[    0.703361] smpboot cpu 6: start_ip = 8c000
[    0.811016] NMI watchdog enabled, takes one hw-pmu counter.
[    0.811182]  #7
[    0.811225] smpboot cpu 7: start_ip = 8c000
[    0.918922] NMI watchdog enabled, takes one hw-pmu counter.
[    0.919012] Brought up 8 CPUs
[    0.919069] Total of 8 processors activated (35120.94 BogoMIPS).
[    0.924972] devtmpfs: initialized
[    0.928278] PM: Registering ACPI NVS region at bade7000 (2097152 bytes)
[    0.928461] Dell Latitude E6420 series board detected. Selecting PCI-method for reboots.
[    0.928682] print_constraints: dummy: 
[    0.928803] NET: Registered protocol family 16
[    0.928958] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.929035] ACPI: bus type pci registered
[    0.929178] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.929258] PCI: not using MMCONFIG
[    0.929315] PCI: Using configuration type 1 for base access
[    0.929382] dmi type 0xB1 record - unknown flag
[    0.930186] bio: create slab <bio-0> at 0
[    0.930355] ACPI: Added _OSI(Module Device)
[    0.930415] ACPI: Added _OSI(Processor Device)
[    0.930474] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.930535] ACPI: Added _OSI(Processor Aggregator Device)
[    0.932153] ACPI: EC: Look up EC in DSDT
[    0.958871] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    1.099169] ACPI: SSDT 00000000badd7718 0067C (v01  PmRef  Cpu0Cst 00003001 INTL 20090903)
[    1.099750] ACPI: Dynamic OEM Table Load:
[    1.099884] ACPI: SSDT           (null) 0067C (v01  PmRef  Cpu0Cst 00003001 INTL 20090903)
[    1.111024] ACPI: SSDT 00000000badd8a98 00303 (v01  PmRef    ApIst 00003000 INTL 20090903)
[    1.111657] ACPI: Dynamic OEM Table Load:
[    1.111791] ACPI: SSDT           (null) 00303 (v01  PmRef    ApIst 00003000 INTL 20090903)
[    1.122799] ACPI: SSDT 00000000badd6d98 00119 (v01  PmRef    ApCst 00003000 INTL 20090903)
[    1.123354] ACPI: Dynamic OEM Table Load:
[    1.123489] ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst 00003000 INTL 20090903)
[    1.206627] ACPI: Interpreter enabled
[    1.206687] ACPI: (supports S0 S3 S4 S5)
[    1.206923] ACPI: Using IOAPIC for interrupt routing
[    1.207004] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    1.207654] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in ACPI motherboard resources
[    1.926631] ACPI: EC: GPE = 0x10, I/O: command/status = 0x934, data = 0x930
[    1.973797] ACPI: No dock devices found.
[    1.973856] HEST: Table not found.
[    1.973913] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    1.974479] \_SB_.PCI0:_OSC invalid UUID
[    1.974480] _OSC request data:1 8 1f 
[    1.974485] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
[    1.975428] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    1.975491] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    1.975553] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    1.975630] pci_root PNP0A08:00: host bridge window [mem 0xbfa00000-0xfeafffff]
[    1.975705] pci_root PNP0A08:00: host bridge window [mem 0xfed40000-0xfed44fff]
[    1.975791] pci 0000:00:00.0: [8086:0104] type 0 class 0x000600
[    1.975827] pci 0000:00:01.0: [8086:0101] type 1 class 0x000604
[    1.975853] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    1.975856] pci 0000:00:01.0: PME# disabled
[    1.975876] pci 0000:00:02.0: [8086:0126] type 0 class 0x000300
[    1.975887] pci 0000:00:02.0: reg 10: [mem 0xe5400000-0xe57fffff 64bit]
[    1.975894] pci 0000:00:02.0: reg 18: [mem 0xc0000000-0xcfffffff 64bit pref]
[    1.975899] pci 0000:00:02.0: reg 20: [io  0x5000-0x503f]
[    1.975952] pci 0000:00:16.0: [8086:1c3a] type 0 class 0x000780
[    1.975976] pci 0000:00:16.0: reg 10: [mem 0xe6eb0000-0xe6eb000f 64bit]
[    1.976040] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    1.976045] pci 0000:00:16.0: PME# disabled
[    1.976077] pci 0000:00:19.0: [8086:1502] type 0 class 0x000200
[    1.976097] pci 0000:00:19.0: reg 10: [mem 0xe6e00000-0xe6e1ffff]
[    1.976106] pci 0000:00:19.0: reg 14: [mem 0xe6e80000-0xe6e80fff]
[    1.976116] pci 0000:00:19.0: reg 18: [io  0x5080-0x509f]
[    1.976168] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    1.976172] pci 0000:00:19.0: PME# disabled
[    1.976199] pci 0000:00:1a.0: [8086:1c2d] type 0 class 0x000c03
[    1.976221] pci 0000:00:1a.0: reg 10: [mem 0xe6e70000-0xe6e703ff]
[    1.976298] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    1.976302] pci 0000:00:1a.0: PME# disabled
[    1.976329] pci 0000:00:1b.0: [8086:1c20] type 0 class 0x000403
[    1.976346] pci 0000:00:1b.0: reg 10: [mem 0xe6e60000-0xe6e63fff 64bit]
[    1.976404] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    1.976408] pci 0000:00:1b.0: PME# disabled
[    1.976436] pci 0000:00:1c.0: [8086:1c10] type 1 class 0x000604
[    1.976539] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    1.976544] pci 0000:00:1c.0: PME# disabled
[    1.976579] pci 0000:00:1c.1: [8086:1c12] type 1 class 0x000604
[    1.976680] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    1.976685] pci 0000:00:1c.1: PME# disabled
[    1.976722] pci 0000:00:1c.2: [8086:1c14] type 1 class 0x000604
[    1.976823] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    1.976828] pci 0000:00:1c.2: PME# disabled
[    1.976864] pci 0000:00:1c.3: [8086:1c16] type 1 class 0x000604
[    1.976964] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    1.976969] pci 0000:00:1c.3: PME# disabled
[    1.977008] pci 0000:00:1c.5: [8086:1c1a] type 1 class 0x000604
[    1.977110] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    1.977115] pci 0000:00:1c.5: PME# disabled
[    1.977154] pci 0000:00:1d.0: [8086:1c26] type 0 class 0x000c03
[    1.977176] pci 0000:00:1d.0: reg 10: [mem 0xe6e50000-0xe6e503ff]
[    1.977252] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    1.977257] pci 0000:00:1d.0: PME# disabled
[    1.977284] pci 0000:00:1f.0: [8086:1c4f] type 0 class 0x000601
[    1.977405] pci 0000:00:1f.2: [8086:282a] type 0 class 0x000104
[    1.977425] pci 0000:00:1f.2: reg 10: [io  0x50d0-0x50d7]
[    1.977434] pci 0000:00:1f.2: reg 14: [io  0x50c0-0x50c3]
[    1.977442] pci 0000:00:1f.2: reg 18: [io  0x50b0-0x50b7]
[    1.977451] pci 0000:00:1f.2: reg 1c: [io  0x50a0-0x50a3]
[    1.977460] pci 0000:00:1f.2: reg 20: [io  0x5060-0x507f]
[    1.977468] pci 0000:00:1f.2: reg 24: [mem 0xe6e40000-0xe6e407ff]
[    1.977504] pci 0000:00:1f.2: PME# supported from D3hot
[    1.977508] pci 0000:00:1f.2: PME# disabled
[    1.977528] pci 0000:00:1f.3: [8086:1c22] type 0 class 0x000c05
[    1.977545] pci 0000:00:1f.3: reg 10: [mem 0xe6e30000-0xe6e300ff 64bit]
[    1.977567] pci 0000:00:1f.3: reg 20: [io  0x5040-0x505f]
[    1.977631] pci 0000:01:00.0: [10de:1056] type 0 class 0x000300
[    1.977648] pci 0000:01:00.0: reg 10: [mem 0xe4000000-0xe4ffffff]
[    1.977662] pci 0000:01:00.0: reg 14: [mem 0xd0000000-0xdfffffff 64bit pref]
[    1.977675] pci 0000:01:00.0: reg 1c: [mem 0xe0000000-0xe1ffffff 64bit pref]
[    1.977684] pci 0000:01:00.0: reg 24: [io  0x4000-0x407f]
[    1.977693] pci 0000:01:00.0: reg 30: [mem 0xe5000000-0xe507ffff pref]
[    1.977749] pci 0000:01:00.1: [10de:0e08] type 0 class 0x000403
[    1.977761] pci 0000:01:00.1: reg 10: [mem 0xe5080000-0xe5083fff]
[    1.977854] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    1.977915] pci 0000:00:01.0:   bridge window [io  0x4000-0x4fff]
[    1.977918] pci 0000:00:01.0:   bridge window [mem 0xe4000000-0xe50fffff]
[    1.977922] pci 0000:00:01.0:   bridge window [mem 0xd0000000-0xe1ffffff 64bit pref]
[    1.977994] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    1.978199] pci 0000:03:00.0: [14e4:4727] type 0 class 0x000280
[    1.978232] pci 0000:03:00.0: reg 10: [mem 0xe6d00000-0xe6d03fff 64bit]
[    1.978358] pci 0000:03:00.0: supports D1 D2
[    1.978360] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    1.978366] pci 0000:03:00.0: PME# disabled
[    1.978415] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    1.978480] pci 0000:00:1c.1:   bridge window [mem 0xe6d00000-0xe6dfffff]
[    1.978533] pci 0000:00:1c.2: PCI bridge to [bus 04-09]
[    1.978596] pci 0000:00:1c.2:   bridge window [io  0x3000-0x3fff]
[    1.978600] pci 0000:00:1c.2:   bridge window [mem 0xe6200000-0xe6bfffff]
[    1.978607] pci 0000:00:1c.2:   bridge window [mem 0xe2b00000-0xe34fffff 64bit pref]
[    1.978655] pci 0000:00:1c.3: PCI bridge to [bus 0a-0a]
[    1.978719] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    1.978723] pci 0000:00:1c.3:   bridge window [mem 0xe5800000-0xe61fffff]
[    1.978730] pci 0000:00:1c.3:   bridge window [mem 0xe2100000-0xe2afffff 64bit pref]
[    1.980549] pci 0000:0b:00.0: [1217:8221] type 0 class 0x000805
[    1.980592] pci 0000:0b:00.0: reg 10: [mem 0xe6c20000-0xe6c201ff]
[    1.980854] pci 0000:0b:00.0: supports D1 D2
[    1.980856] pci 0000:0b:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.980866] pci 0000:0b:00.0: PME# disabled
[    1.980966] pci 0000:0b:00.1: [1217:8231] type 0 class 0x000180
[    1.981010] pci 0000:0b:00.1: reg 10: [mem 0xe6c10000-0xe6c10fff]
[    1.981070] pci 0000:0b:00.1: reg 18: [mem 0xe6c00000-0xe6c007ff]
[    1.981266] pci 0000:0b:00.1: supports D1 D2
[    1.981267] pci 0000:0b:00.1: PME# supported from D0 D1 D2 D3hot D3cold
[    1.981278] pci 0000:0b:00.1: PME# disabled
[    1.981372] pci 0000:00:1c.5: PCI bridge to [bus 0b-0b]
[    1.981437] pci 0000:00:1c.5:   bridge window [mem 0xe6c00000-0xe6cfffff]
[    1.981488] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    1.981803] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    1.981860] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    1.981913] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP04._PRT]
[    1.981968] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP06._PRT]
[    1.982026] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEG0._PRT]
[    1.982094] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
[    1.982214] \_SB_.PCI0:_OSC invalid UUID
[    1.982215] _OSC request data:1 1f 1f 
[    1.982219]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    1.982326] \_SB_.PCI0:_OSC invalid UUID
[    1.982328] _OSC request data:1 0 1d 
[    1.982331]  pci0000:00: ACPI _OSC request failed (AE_ERROR), returned control mask: 0x1d
[    1.982408] ACPI _OSC control for PCIe not granted, disabling ASPM
[    1.988306] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
[    1.988933] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
[    1.989557] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
[    1.990191] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
[    1.990817] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 *5 6 7 10 12 14 15)
[    1.991390] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
[    1.992056] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 *3 4 5 6 7 10 12 14 15)
[    1.992628] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
[    1.993337] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    1.993424] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=none,locks=none
[    1.993502] vgaarb: loaded
[    1.993557] vgaarb: bridge control possible 0000:01:00.0
[    1.993617] vgaarb: bridge control possible 0000:00:02.0
[    1.993819] SCSI subsystem initialized
[    1.993913] libata version 3.00 loaded.
[    1.993950] PCI: Using ACPI for IRQ routing
[    1.995556] PCI: pci_cache_line_size set to 64 bytes
[    1.995653] reserve RAM buffer: 0000000000091400 - 000000000009ffff 
[    1.995656] reserve RAM buffer: 00000000baa2a000 - 00000000bbffffff 
[    1.995660] reserve RAM buffer: 00000000badb7000 - 00000000bbffffff 
[    1.995664] reserve RAM buffer: 00000000bb000000 - 00000000bbffffff 
[    1.995666] reserve RAM buffer: 000000013e000000 - 000000013fffffff 
[    1.995773] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    1.996180] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    1.998259] Switching to clocksource hpet
[    2.001315] pnp: PnP ACPI init
[    2.001383] ACPI: bus type pnp registered
[    2.001625] Switched to NOHz mode on CPU #0
[    2.001690] Switched to NOHz mode on CPU #6
[    2.001707] Switched to NOHz mode on CPU #5
[    2.001720] Switched to NOHz mode on CPU #4
[    2.001724] Switched to NOHz mode on CPU #7
[    2.001726] Switched to NOHz mode on CPU #3
[    2.001734] Switched to NOHz mode on CPU #2
[    2.001743] Switched to NOHz mode on CPU #1
[    2.001977] pnp 00:00: [bus 00-3e]
[    2.001980] pnp 00:00: [io  0x0000-0x0cf7 window]
[    2.001982] pnp 00:00: [io  0x0cf8-0x0cff]
[    2.001984] pnp 00:00: [io  0x0d00-0xffff window]
[    2.001987] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    2.001989] pnp 00:00: [mem 0x000c0000-0x000c3fff window]
[    2.001990] pnp 00:00: [mem 0x000c4000-0x000c7fff window]
[    2.001992] pnp 00:00: [mem 0x000c8000-0x000cbfff window]
[    2.001994] pnp 00:00: [mem 0x000cc000-0x000cffff window]
[    2.001996] pnp 00:00: [mem 0x000d0000-0x000d3fff window]
[    2.001997] pnp 00:00: [mem 0x000d4000-0x000d7fff window]
[    2.001999] pnp 00:00: [mem 0x000d8000-0x000dbfff window]
[    2.002001] pnp 00:00: [mem 0x000dc000-0x000dffff window]
[    2.002003] pnp 00:00: [mem 0x000e0000-0x000e3fff window]
[    2.002004] pnp 00:00: [mem 0x000e4000-0x000e7fff window]
[    2.002006] pnp 00:00: [mem 0x000e8000-0x000ebfff window]
[    2.002008] pnp 00:00: [mem 0x000ec000-0x000effff window]
[    2.002009] pnp 00:00: [mem 0x000f0000-0x000fffff window]
[    2.002011] pnp 00:00: [mem 0xbfa00000-0xfeafffff window]
[    2.002013] pnp 00:00: [mem 0xfed40000-0xfed44fff window]
[    2.002063] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    2.002079] pnp 00:01: [io  0x0000-0x001f]
[    2.002081] pnp 00:01: [io  0x0081-0x0091]
[    2.002082] pnp 00:01: [io  0x0093-0x009f]
[    2.002084] pnp 00:01: [io  0x00c0-0x00df]
[    2.002085] pnp 00:01: [dma 4]
[    2.002109] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    2.002118] pnp 00:02: [mem 0xff000000-0xffffffff]
[    2.002141] pnp 00:02: Plug and Play ACPI device, IDs INT0800 (active)
[    2.002252] pnp 00:03: [mem 0xfed00000-0xfed003ff]
[    2.002295] system 00:03: [mem 0xfed00000-0xfed003ff] has been reserved
[    2.002359] system 00:03: Plug and Play ACPI device, IDs PNP0103 PNP0c01 (active)
[    2.002371] pnp 00:04: [io  0x00f0]
[    2.002381] pnp 00:04: [irq 13]
[    2.002411] pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
[    2.002423] pnp 00:05: [io  0x002e-0x002f]
[    2.002425] pnp 00:05: [io  0x004e-0x004f]
[    2.002427] pnp 00:05: [io  0x0061]
[    2.002428] pnp 00:05: [io  0x0063]
[    2.002431] pnp 00:05: [io  0x0065]
[    2.002432] pnp 00:05: [io  0x0067]
[    2.002434] pnp 00:05: [io  0x0070]
[    2.002436] pnp 00:05: [io  0x0080]
[    2.002437] pnp 00:05: [io  0x0092]
[    2.002439] pnp 00:05: [io  0x00b2-0x00b3]
[    2.002440] pnp 00:05: [io  0x0680-0x069f]
[    2.002442] pnp 00:05: [io  0x1000-0x100f]
[    2.002444] pnp 00:05: [io  0xffff]
[    2.002445] pnp 00:05: [io  0xffff]
[    2.002447] pnp 00:05: [io  0x0400-0x047f]
[    2.002449] pnp 00:05: [io  0x0500-0x057f]
[    2.002450] pnp 00:05: [io  0x164e-0x164f]
[    2.002497] system 00:05: [io  0x0680-0x069f] has been reserved
[    2.002559] system 00:05: [io  0x1000-0x100f] has been reserved
[    2.002620] system 00:05: [io  0xffff] has been reserved
[    2.002681] system 00:05: [io  0xffff] has been reserved
[    2.002742] system 00:05: [io  0x0400-0x047f] has been reserved
[    2.002804] system 00:05: [io  0x0500-0x057f] has been reserved
[    2.002866] system 00:05: [io  0x164e-0x164f] has been reserved
[    2.002927] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    2.002936] pnp 00:06: [io  0x0070-0x0077]
[    2.002943] pnp 00:06: [irq 8]
[    2.002968] pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
[    2.002980] pnp 00:07: [io  0x0060]
[    2.002982] pnp 00:07: [io  0x0064]
[    2.002988] pnp 00:07: [irq 1]
[    2.003011] pnp 00:07: Plug and Play ACPI device, IDs PNP0303 (active)
[    2.006667] pnp 00:08: Plug and Play ACPI device, IDs PNP0401 (disabled)
[    2.006685] pnp 00:09: [irq 12]
[    2.006711] pnp 00:09: Plug and Play ACPI device, IDs DLL0493 PNP0f13 (active)
[    2.006906] pnp 00:0a: [mem 0xfed1c000-0xfed1ffff]
[    2.006908] pnp 00:0a: [mem 0xfed10000-0xfed17fff]
[    2.006910] pnp 00:0a: [mem 0xfed18000-0xfed18fff]
[    2.006912] pnp 00:0a: [mem 0xfed19000-0xfed19fff]
[    2.006914] pnp 00:0a: [mem 0xf8000000-0xfbffffff]
[    2.006916] pnp 00:0a: [mem 0xfed20000-0xfed3ffff]
[    2.006918] pnp 00:0a: [mem 0xfed90000-0xfed93fff]
[    2.006919] pnp 00:0a: [mem 0xfed45000-0xfed8ffff]
[    2.006921] pnp 00:0a: [mem 0xff000000-0xffffffff]
[    2.006923] pnp 00:0a: [mem 0xfee00000-0xfeefffff]
[    2.006925] pnp 00:0a: [mem 0x00000000-0xffffffffffffffff disabled]
[    2.006927] pnp 00:0a: [mem 0x00000000-0xffffffffffffffff disabled]
[    2.006985] system 00:0a: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    2.007049] system 00:0a: [mem 0xfed10000-0xfed17fff] has been reserved
[    2.007112] system 00:0a: [mem 0xfed18000-0xfed18fff] has been reserved
[    2.007176] system 00:0a: [mem 0xfed19000-0xfed19fff] has been reserved
[    2.007238] system 00:0a: [mem 0xf8000000-0xfbffffff] has been reserved
[    2.007302] system 00:0a: [mem 0xfed20000-0xfed3ffff] has been reserved
[    2.007366] system 00:0a: [mem 0xfed90000-0xfed93fff] has been reserved
[    2.007428] system 00:0a: [mem 0xfed45000-0xfed8ffff] has been reserved
[    2.007491] system 00:0a: [mem 0xff000000-0xffffffff] could not be reserved
[    2.007555] system 00:0a: [mem 0xfee00000-0xfeefffff] has been reserved
[    2.007618] system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
[    2.008219] pnp 00:0b: [irq 23]
[    2.008258] pnp 00:0b: Plug and Play ACPI device, IDs SMO8800 (active)
[    2.022831] pnp 00:0c: [mem 0x20000000-0x201fffff]
[    2.022834] pnp 00:0c: [mem 0x40000000-0x401fffff]
[    2.022903] system 00:0c: [mem 0x20000000-0x201fffff] has been reserved
[    2.022967] system 00:0c: [mem 0x40000000-0x401fffff] has been reserved
[    2.023031] system 00:0c: Plug and Play ACPI device, IDs PNP0c01 (active)
[    2.023039] pnp: PnP ACPI: found 13 devices
[    2.023098] ACPI: ACPI bus type pnp unregistered
[    2.029982] PCI: max bus depth: 1 pci_try_num: 2
[    2.030028] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    2.030089] pci 0000:00:01.0:   bridge window [io  0x4000-0x4fff]
[    2.030152] pci 0000:00:01.0:   bridge window [mem 0xe4000000-0xe50fffff]
[    2.030227] pci 0000:00:01.0:   bridge window [mem 0xd0000000-0xe1ffffff 64bit pref]
[    2.030306] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    2.030377] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    2.030441] pci 0000:00:1c.1:   bridge window [mem 0xe6d00000-0xe6dfffff]
[    2.030511] pci 0000:00:1c.2: PCI bridge to [bus 04-09]
[    2.030573] pci 0000:00:1c.2:   bridge window [io  0x3000-0x3fff]
[    2.030638] pci 0000:00:1c.2:   bridge window [mem 0xe6200000-0xe6bfffff]
[    2.030704] pci 0000:00:1c.2:   bridge window [mem 0xe2b00000-0xe34fffff 64bit pref]
[    2.030786] pci 0000:00:1c.3: PCI bridge to [bus 0a-0a]
[    2.030848] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    2.030914] pci 0000:00:1c.3:   bridge window [mem 0xe5800000-0xe61fffff]
[    2.030979] pci 0000:00:1c.3:   bridge window [mem 0xe2100000-0xe2afffff 64bit pref]
[    2.031060] pci 0000:00:1c.5: PCI bridge to [bus 0b-0b]
[    2.031123] pci 0000:00:1c.5:   bridge window [mem 0xe6c00000-0xe6cfffff]
[    2.031204] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.031269] pci 0000:00:01.0: setting latency timer to 64
[    2.031276] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.031341] pci 0000:00:1c.0: setting latency timer to 64
[    2.031353] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    2.031418] pci 0000:00:1c.1: setting latency timer to 64
[    2.031430] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    2.031496] pci 0000:00:1c.2: setting latency timer to 64
[    2.031508] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    2.031573] pci 0000:00:1c.3: setting latency timer to 64
[    2.031580] pci 0000:00:1c.5: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    2.031646] pci 0000:00:1c.5: setting latency timer to 64
[    2.031650] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    2.031652] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    2.031654] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    2.031656] pci_bus 0000:00: resource 7 [mem 0xbfa00000-0xfeafffff]
[    2.031658] pci_bus 0000:00: resource 8 [mem 0xfed40000-0xfed44fff]
[    2.031660] pci_bus 0000:01: resource 0 [io  0x4000-0x4fff]
[    2.031662] pci_bus 0000:01: resource 1 [mem 0xe4000000-0xe50fffff]
[    2.031664] pci_bus 0000:01: resource 2 [mem 0xd0000000-0xe1ffffff 64bit pref]
[    2.031666] pci_bus 0000:03: resource 1 [mem 0xe6d00000-0xe6dfffff]
[    2.031668] pci_bus 0000:04: resource 0 [io  0x3000-0x3fff]
[    2.031670] pci_bus 0000:04: resource 1 [mem 0xe6200000-0xe6bfffff]
[    2.031672] pci_bus 0000:04: resource 2 [mem 0xe2b00000-0xe34fffff 64bit pref]
[    2.031674] pci_bus 0000:0a: resource 0 [io  0x2000-0x2fff]
[    2.031675] pci_bus 0000:0a: resource 1 [mem 0xe5800000-0xe61fffff]
[    2.031677] pci_bus 0000:0a: resource 2 [mem 0xe2100000-0xe2afffff 64bit pref]
[    2.031680] pci_bus 0000:0b: resource 1 [mem 0xe6c00000-0xe6cfffff]
[    2.031779] NET: Registered protocol family 2
[    2.033387] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    2.034529] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    2.035952] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    2.036153] TCP: Hash tables configured (established 524288 bind 65536)
[    2.036218] TCP reno registered
[    2.036283] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    2.036363] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    2.036582] NET: Registered protocol family 1
[    2.036653] pci 0000:00:02.0: Boot video device
[    2.036777] PCI: CLS 64 bytes, default 64
[    2.036818] Unpacking initramfs...
[    2.693494] Freeing initrd memory: 31432k freed
[    2.697433] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    2.697513] Placing 64MB software IO TLB between ffff8800b6a2a000 - ffff8800baa2a000
[    2.697590] software IO TLB at phys 0xb6a2a000 - 0xbaa2a000
[    2.697667] Simple Boot Flag at 0xf3 set to 0x1
[    2.698525] audit: initializing netlink socket (disabled)
[    2.698594] type=2000 audit(1316080915.480:1): initialized
[    2.718907] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    2.727473] VFS: Disk quotas dquot_6.5.2
[    2.727575] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    2.728025] msgmni has been set to 7692
[    2.728261] alg: No test for stdrng (krng)
[    2.728357] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    2.728434] io scheduler noop registered
[    2.728492] io scheduler deadline registered
[    2.728578] io scheduler cfq registered (default)
[    2.728729] pcieport 0000:00:01.0: setting latency timer to 64
[    2.728760] pcieport 0000:00:01.0: irq 42 for MSI/MSI-X
[    2.729110] ERST: Table is not found!
[    2.729229] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    2.881674] Linux agpgart interface v0.103
[    2.881824] agpgart-intel 0000:00:00.0: Intel Sandybridge Chipset
[    2.881978] agpgart-intel 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
[    2.883278] agpgart-intel 0000:00:00.0: detected 65536K stolen memory
[    2.883469] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xc0000000
[    2.883669] ahci 0000:00:1f.2: version 3.0
[    2.883681] ahci 0000:00:1f.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    2.883793] ahci 0000:00:1f.2: irq 43 for MSI/MSI-X
[    2.883820] ahci: SSS flag set, parallel bus scan disabled
[    2.897307] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x3b impl RAID mode
[    2.897396] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part ems sxs apst 
[    2.897478] ahci 0000:00:1f.2: setting latency timer to 64
[    2.929797] scsi0 : ahci
[    2.929966] scsi1 : ahci
[    2.930091] scsi2 : ahci
[    2.930217] scsi3 : ahci
[    2.930343] scsi4 : ahci
[    2.930469] scsi5 : ahci
[    2.941943] ata1: SATA max UDMA/133 abar m2048@0xe6e40000 port 0xe6e40100 irq 43
[    2.942020] ata2: SATA max UDMA/133 abar m2048@0xe6e40000 port 0xe6e40180 irq 43
[    2.942096] ata3: DUMMY
[    2.942152] ata4: SATA max UDMA/133 abar m2048@0xe6e40000 port 0xe6e40280 irq 43
[    2.942229] ata5: SATA max UDMA/133 abar m2048@0xe6e40000 port 0xe6e40300 irq 43
[    2.942305] ata6: SATA max UDMA/133 abar m2048@0xe6e40000 port 0xe6e40380 irq 43
[    2.942475] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    2.942796] i8042: Warning: Keylock active
[    2.944241] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.944305] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.944483] mousedev: PS/2 mouse device common for all mice
[    2.944584] rtc_cmos 00:06: RTC can wake from S4
[    2.944780] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
[    2.944882] rtc0: alarms up to one year, y3k, 242 bytes nvram, hpet irqs
[    2.944953] cpuidle: using governor ladder
[    2.945012] cpuidle: using governor menu
[    2.945277] TCP cubic registered
[    2.945494] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    2.945644] NET: Registered protocol family 10
[    2.946141] Mobile IPv6
[    2.946197] NET: Registered protocol family 17
[    2.946258] Registering the dns_resolver key type
[    2.946435] PM: Hibernation image not present or could not be loaded.
[    2.946446] registered taskstats version 1
[    2.951519] rtc_cmos 00:06: setting system clock to 2011-09-15 10:01:56 UTC (1316080916)
[    2.951661] Initializing network drop monitor service
[    3.260867] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    3.269115] ata1.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by device (Stat=0x51 Err=0x04)
[    3.273425] ata1.00: ATA-8: SAMSUNG SSD PM810 2.5" 256GB, AXM08D1Q, max UDMA/133
[    3.273533] ata1.00: 500118192 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    3.281097] ata1.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by device (Stat=0x51 Err=0x04)
[    3.282329] ata1.00: configured for UDMA/133
[    3.288994] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG SSD PM81 AXM0 PQ: 0 ANSI: 5
[    3.289243] sd 0:0:0:0: [sda] 500118192 512-byte logical blocks: (256 GB/238 GiB)
[    3.289372] sd 0:0:0:0: [sda] Write Protect is off
[    3.289432] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.289448] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.291338]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 sda9 >
[    3.291905] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.608484] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    3.612103] ata2.00: ATAPI: HL-DT-ST DVD+/-RW GU40N, A103, max UDMA/133
[    3.616167] ata2.00: configured for UDMA/133
[    3.619244] scsi 1:0:0:0: CD-ROM            HL-DT-ST DVD+-RW GU40N    A103 PQ: 0 ANSI: 5
[    3.696384] Refined TSC clocksource calibration: 2195.013 MHz.
[    3.696469] Switching to clocksource tsc
[    3.936115] ata4: SATA link down (SStatus 0 SControl 300)
[    4.255761] ata5: SATA link down (SStatus 0 SControl 300)
[    4.575410] ata6: SATA link down (SStatus 0 SControl 300)
[    4.576649] Freeing unused kernel memory: 576k freed
[    4.576769] Write protecting the kernel read-only data: 6144k
[    4.577271] Freeing unused kernel memory: 96k freed
[    4.579124] Freeing unused kernel memory: 492k freed
[    4.644664] udevd[96]: starting version 172
[    4.656968] e1000e: Intel(R) PRO/1000 Network Driver - 1.4.4-k
[    4.657036] e1000e: Copyright(c) 1999 - 2011 Intel Corporation.
[    4.657147] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    4.657225] e1000e 0000:00:19.0: setting latency timer to 64
[    4.657352] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[    4.661572] sdhci: Secure Digital Host Controller Interface driver
[    4.661641] sdhci: Copyright(c) Pierre Ossman
[    4.664351] sdhci-pci 0000:0b:00.0: SDHCI controller found [1217:8221] (rev 5)
[    4.678184] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    4.678265] cdrom: Uniform CD-ROM driver Revision: 3.20
[    4.678463] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    4.679947] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    4.680053] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    4.687326] sdhci-pci 0000:0b:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    4.687435] sdhci-pci 0000:0b:00.0: Invalid iomem size. You may experience problems.
[    4.687663] sdhci-pci 0000:0b:00.0: setting latency timer to 64
[    4.687685] mmc0: no vmmc regulator found
[    4.687773] Registered led device: mmc0::
[    4.687814] mmc0: SDHCI controller on PCI [0000:0b:00.0] using DMA
[    4.767302] thermal LNXTHERM:00: registered as thermal_zone0
[    4.767367] ACPI: Thermal Zone [THM] (25 C)
[    4.956564] e1000e 0000:00:19.0: eth0: (PCI Express:2.5GT/s:Width x1) 5c:26:0a:6b:0b:75
[    4.956643] e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    4.956742] e1000e 0000:00:19.0: eth0: MAC: 10, PHY: 11, PBA No: 3041FF-0FF
[    5.649216] PM: Marking nosave pages: 0000000000091000 - 0000000000100000
[    5.649221] PM: Marking nosave pages: 0000000020000000 - 0000000020200000
[    5.649231] PM: Marking nosave pages: 0000000040000000 - 0000000040200000
[    5.649241] PM: Marking nosave pages: 00000000baa2a000 - 00000000baa6e000
[    5.649244] PM: Marking nosave pages: 00000000badb7000 - 00000000bafff000
[    5.649255] PM: Marking nosave pages: 00000000bb000000 - 0000000100000000
[    5.650909] PM: Basic memory bitmaps created
[    5.673208] PM: Basic memory bitmaps freed
[    5.682741] EXT4-fs (sda6): mounted filesystem with ordered data mode. Opts: (null)
[    6.194621] udevd[343]: starting version 172
[    6.278991] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input1
[    6.279431] ACPI: acpi_idle registered with cpuidle
[    6.280555] ACPI: Lid Switch [LID]
[    6.280704] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input2
[    6.280789] ACPI: Power Button [PBTN]
[    6.280907] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input3
[    6.280985] ACPI: Sleep Button [SBTN]
[    6.282865] Monitor-Mwait will be used to enter C-1 state
[    6.284199] Monitor-Mwait will be used to enter C-2 state
[    6.284767] Monitor-Mwait will be used to enter C-3 state
[    6.285243] ACPI: AC Adapter [AC] (on-line)
[    6.289058] parport_pc 00:08: [io  0x0378-0x037b]
[    6.289135] parport_pc 00:08: [irq 5]
[    6.302790] input: PC Speaker as /devices/platform/pcspkr/input/input4
[    6.303502] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[    6.341562] i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    6.413505] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input5
[    6.413671] ACPI: Power Button [PWRF]
[    6.527525] parport_pc 00:08: activated
[    6.529270] parport_pc 00:08: reported by Plug and Play ACPI
[    6.532489] parport_pc 00:08: disabled
[    6.537359] ACPI: Battery Slot [BAT0] (battery present)
[    6.713803] ACPI: Battery Slot [BAT1] (battery absent)
[    6.718371] ACPI: Battery Slot [BAT2] (battery absent)
[    6.718653] wmi: Mapper loaded
[    6.726022] input: Dell WMI hotkeys as /devices/virtual/input/input6
[    6.742813] cfg80211: Calling CRDA to update world regulatory domain
[    6.750595] brcmutil: module is from the staging directory, the quality is unknown, you have been warned.
[    6.753252] [drm] Initialized drm 1.1.0 20060810
[    6.795944] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    6.796012] i915 0000:00:02.0: setting latency timer to 64
[    6.806454] brcmsmac: module is from the staging directory, the quality is unknown, you have been warned.
[    6.808768] brcmsmac 0000:03:00.0: bus 3 slot 0 func 0 irq 10
[    6.808840] brcmsmac 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    6.808904] brcmsmac 0000:03:00.0: setting latency timer to 64
[    6.833625] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
[    6.843952] i915 0000:00:02.0: irq 45 for MSI/MSI-X
[    6.843958] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    6.844023] [drm] Driver supports precise vblank timestamp query.
[    6.844305] [drm:intel_dsm_platform_mux_info] *ERROR* MUX INFO call failed
[    6.844384] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=none:owns=io+mem
[    6.844464] vgaarb: transferring owner from PCI:0000:00:02.0 to PCI:0000:01:00.0
[    7.612266] fbcon: inteldrmfb (fb0) is primary device
[    7.613743] [drm:ironlake_update_pch_refclk] *ERROR* enabling SSC on PCH
[    7.788308] [drm:ironlake_update_pch_refclk] *ERROR* enabling SSC on PCH
[    7.963895] Console: switching to colour frame buffer device 200x56
[    7.969513] fb0: inteldrmfb frame buffer device
[    7.969515] drm: registered panic notifier
[    8.571031] ACPI Exception: AE_TIME, Returned by Handler for [EmbeddedControl] (20110623/evregion-478)
[    8.571104] ACPI Error: Method parse/execution failed [\_SB_.PCI0.LPCB.ECDV.ECR1] (Node ffff880136e7afd8), AE_TIME (20110623/psparse-536)
[    8.571196] ACPI Error: Method parse/execution failed [\ECRB] (Node ffff880136e7ae70), AE_TIME (20110623/psparse-536)
[    8.571276] ACPI Error: Method parse/execution failed [\ECGB] (Node ffff880136e7aba0), AE_TIME (20110623/psparse-536)
[    8.571355] ACPI Error: Method parse/execution failed [\_SB_.PCI0.PEG0.VID_._DOD] (Node ffff880136e983d0), AE_TIME (20110623/psparse-536)
[    8.571447] ACPI Exception: AE_TIME, Evaluating _DOD (20110623/video-1147)
[    9.070474] ACPI: EC: input buffer is not empty, aborting transaction
[    9.070520] ACPI Exception: AE_TIME, Returned by Handler for [EmbeddedControl] (20110623/evregion-478)
[    9.070588] ACPI Error: Method parse/execution failed [\_SB_.PCI0.LPCB.ECDV.ECR1] (Node ffff880136e7afd8), AE_TIME (20110623/psparse-536)
[    9.070680] ACPI Error: Method parse/execution failed [\ECRB] (Node ffff880136e7ae70), AE_TIME (20110623/psparse-536)
[    9.070760] ACPI Error: Method parse/execution failed [\ECGB] (Node ffff880136e7aba0), AE_TIME (20110623/psparse-536)
[    9.070838] ACPI Error: Method parse/execution failed [\_SB_.PCI0.PEG0.VID_.LCD_._ADR] (Node ffff880136e982b8), AE_TIME (20110623/psparse-536)
[    9.070932] ACPI: Can't attach device
[    9.653976] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:13/LNXVIDEO:00/input/input7
[    9.654456] ACPI: Video Device [VID] (multi-head: yes  rom: yes  post: no)
[   10.161311] ACPI Exception: AE_TIME, Returned by Handler for [EmbeddedControl] (20110623/evregion-478)
[   10.161405] ACPI Error: Method parse/execution failed [\_SB_.PCI0.LPCB.ECDV.ECR1] (Node ffff880136e7afd8), AE_TIME (20110623/psparse-536)
[   10.161498] ACPI Error: Method parse/execution failed [\ECRB] (Node ffff880136e7ae70), AE_TIME (20110623/psparse-536)
[   10.161578] ACPI Error: Method parse/execution failed [\ECGB] (Node ffff880136e7aba0), AE_TIME (20110623/psparse-536)
[   10.161656] ACPI Error: Method parse/execution failed [\_SB_.PCI0.VID_.LCD_._ADR] (Node ffff880136e7fda8), AE_TIME (20110623/psparse-536)
[   10.161748] ACPI: Can't attach device
[   10.189709] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:01/input/input8
[   10.189887] ACPI: Video Device [VID1] (multi-head: yes  rom: no  post: no)
[   10.190012] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[   10.190156] snd_hda_intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[   10.190273] snd_hda_intel 0000:00:1b.0: irq 46 for MSI/MSI-X
[   10.190297] snd_hda_intel 0000:00:1b.0: setting latency timer to 64
[   10.236443] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input9
[   10.245989] input: HDA Intel PCH Mic at Sep Left Jack as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
[   10.248110] input: HDA Intel PCH Mic at Ext Left Jack as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
[   10.250272] input: HDA Intel PCH Line Out at Sep Left Jack as /devices/pci0000:00/0000:00:1b.0/sound/card0/input12
[   10.252413] input: HDA Intel PCH HP Out at Ext Left Jack as /devices/pci0000:00/0000:00:1b.0/sound/card0/input13
[   10.255843] snd_hda_intel 0000:01:00.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[   10.257968] hda_intel: Disabling MSI
[   10.260143] snd_hda_intel 0000:01:00.1: setting latency timer to 64
[   11.020364] HDMI status: Codec=0 Pin=5 Presence_Detect=0 ELD_Valid=0
[   11.083426] input: PS/2 Generic Mouse as /devices/platform/i8042/serio1/input/input14
[   11.084253] HDMI status: Codec=0 Pin=6 Presence_Detect=0 ELD_Valid=0
[   11.148220] HDMI status: Codec=0 Pin=7 Presence_Detect=0 ELD_Valid=0
[   11.236670] input: HDA NVidia HDMI/DP as /devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input15
[   11.239002] input: HDA NVidia HDMI/DP as /devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input16
[   11.241367] input: HDA NVidia HDMI/DP as /devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input17
[   11.776985] Adding 7811068k swap on /dev/sda5.  Priority:-1 extents:1 across:7811068k SS
[   11.790503] EXT4-fs (sda6): re-mounted. Opts: (null)
[   11.889248] EXT4-fs (sda6): re-mounted. Opts: errors=remount-ro,discard
[   11.914894] loop: module loaded
[   11.985299] usbcore: registered new interface driver usbfs
[   11.987374] usbcore: registered new interface driver hub
[   11.989370] usbcore: registered new device driver usb
[   11.994949] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   11.996909] ehci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   11.998808] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[   11.998812] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[   12.000690] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[   12.002548] ehci_hcd 0000:00:1a.0: debug port 2
[   12.008221] ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
[   12.008244] ehci_hcd 0000:00:1a.0: irq 16, io mem 0xe6e70000
[   12.023226] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[   12.025122] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[   12.026892] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   12.028659] usb usb1: Product: EHCI Host Controller
[   12.030364] usb usb1: Manufacturer: Linux 3.1.0-rc6 ehci_hcd
[   12.032057] usb usb1: SerialNumber: 0000:00:1a.0
[   12.033914] hub 1-0:1.0: USB hub found
[   12.035571] hub 1-0:1.0: 2 ports detected
[   12.037267] ehci_hcd 0000:00:1d.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   12.038927] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[   12.038931] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[   12.040548] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[   12.042209] ehci_hcd 0000:00:1d.0: debug port 2
[   12.047697] ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
[   12.047706] ehci_hcd 0000:00:1d.0: irq 17, io mem 0xe6e50000
[   12.063183] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[   12.064756] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[   12.066301] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   12.067882] usb usb2: Product: EHCI Host Controller
[   12.069396] usb usb2: Manufacturer: Linux 3.1.0-rc6 ehci_hcd
[   12.070893] usb usb2: SerialNumber: 0000:00:1d.0
[   12.072609] hub 2-0:1.0: USB hub found
[   12.074097] hub 2-0:1.0: 2 ports detected
[   12.078094] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[   12.090262] coretemp coretemp.0: TjMax is 100 C.
[   12.091866] coretemp coretemp.0: TjMax is 100 C.
[   12.093401] coretemp coretemp.0: TjMax is 100 C.
[   12.094912] coretemp coretemp.0: TjMax is 100 C.
[   12.350905] usb 1-1: new high speed USB device number 2 using ehci_hcd
[   12.399268] EXT4-fs (sda9): mounted filesystem with ordered data mode. Opts: discard
[   12.414409] FAT-fs (sda1): utf8 is not a recommended IO charset for FAT filesystems, filesystem will be case sensitive!
[   12.457101] fuse init (API version 7.17)
[   12.483218] usb 1-1: New USB device found, idVendor=8087, idProduct=0024
[   12.484598] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[   12.486201] hub 1-1:1.0: USB hub found
[   12.487679] hub 1-1:1.0: 6 ports detected
[   12.598598] usb 2-1: new high speed USB device number 2 using ehci_hcd
[   12.738880] usb 2-1: New USB device found, idVendor=8087, idProduct=0024
[   12.740303] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[   12.741948] hub 2-1:1.0: USB hub found
[   12.743507] hub 2-1:1.0: 8 ports detected
[   12.814451] usb 1-1.1: new high speed USB device number 3 using ehci_hcd
[   12.906692] usb 1-1.1: New USB device found, idVendor=413c, idProduct=2513
[   12.908266] usb 1-1.1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[   12.909986] hub 1-1.1:1.0: USB hub found
[   12.911682] hub 1-1.1:1.0: 3 ports detected
[   12.986228] usb 1-1.2: new high speed USB device number 4 using ehci_hcd
[   13.082397] usb 1-1.2: New USB device found, idVendor=413c, idProduct=2513
[   13.083974] usb 1-1.2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[   13.085792] hub 1-1.2:1.0: USB hub found
[   13.087736] hub 1-1.2:1.0: 3 ports detected
[   13.170150] usb 1-1.4: new full speed USB device number 5 using ehci_hcd
[   13.270318] usb 1-1.4: New USB device found, idVendor=413c, idProduct=8187
[   13.271971] usb 1-1.4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[   13.273613] usb 1-1.4: Product: DW375 Bluetooth Module
[   13.273615] usb 1-1.4: Manufacturer: Dell Computer Corp
[   13.273616] usb 1-1.4: SerialNumber: D0DF9A3D158D
[   13.345863] usb 2-1.6: new high speed USB device number 3 using ehci_hcd
[   13.449088] usb 2-1.6: New USB device found, idVendor=413c, idProduct=818d
[   13.449092] usb 2-1.6: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[   13.449095] usb 2-1.6: Product: DW5550
[   13.449097] usb 2-1.6: Manufacturer: Dell
[   13.449099] usb 2-1.6: SerialNumber: 5B698558903EF940
[   13.557601] usb 2-1.8: new full speed USB device number 4 using ehci_hcd
[   13.680903] usb 2-1.8: New USB device found, idVendor=0a5c, idProduct=5800
[   13.685626] usb 2-1.8: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[   13.688026] usb 2-1.8: Product: 5880
[   13.690365] usb 2-1.8: Manufacturer: Broadcom Corp
[   13.692670] usb 2-1.8: SerialNumber: 0123456789ABCD
[   13.695022] usb 2-1.8: config 0 descriptor??
[   13.777542] usb 1-1.2.1: new low speed USB device number 6 using ehci_hcd
[   13.889245] usb 1-1.2.1: New USB device found, idVendor=413c, idProduct=3012
[   13.892672] usb 1-1.2.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   13.895718] usb 1-1.2.1: Product: Dell USB Optical Mouse
[   13.898057] usb 1-1.2.1: Manufacturer: Dell
[   13.977260] usb 1-1.2.2: new low speed USB device number 7 using ehci_hcd
[   14.048227] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[   14.079404] usb 1-1.2.2: New USB device found, idVendor=413c, idProduct=2003
[   14.081879] usb 1-1.2.2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   14.084267] usb 1-1.2.2: Product: Dell USB Keyboard
[   14.084269] usb 1-1.2.2: Manufacturer: Dell
[   14.101013] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[   14.101560] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   14.105391] cdc_acm 2-1.6:1.1: ttyACM0: USB ACM device
[   14.108625] cdc_acm 2-1.6:1.3: ttyACM1: USB ACM device
[   14.111261] cdc_ncm: 04-Aug-2011
[   14.115373] cdc_wdm 2-1.6:1.5: cdc-wdm-176: USB WDM device
[   14.115423] cdc_wdm 2-1.6:1.8: cdc-wdm-175: USB WDM device
[   14.115449] usbcore: registered new interface driver cdc_wdm
[   14.115616] input: Dell Dell USB Optical Mouse as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.2/1-1.2.1/1-1.2.1:1.0/input/input18
[   14.115744] generic-usb 0003:413C:3012.0001: input,hidraw0: USB HID v1.11 Mouse [Dell Dell USB Optical Mouse] on usb-0000:00:1a.0-1.2.1/input0
[   14.118515] input: Dell Dell USB Keyboard as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.2/1-1.2.2/1-1.2.2:1.0/input/input19
[   14.118617] generic-usb 0003:413C:2003.0002: input,hidraw1: USB HID v1.10 Keyboard [Dell Dell USB Keyboard] on usb-0000:00:1a.0-1.2.2/input0
[   14.118628] usbcore: registered new interface driver usbhid
[   14.118630] usbhid: USB HID core driver
[   14.139859] usb 2-1.6: MAC-Address: 0x02:0x80:0x37:0xec:0x02:0x00
[   14.140240] cdc_ncm 2-1.6:1.6: usb0: register 'cdc_ncm' at usb-0000:00:1d.0-1.6, CDC NCM, 02:80:37:ec:02:00
[   14.140272] usbcore: registered new interface driver cdc_ncm
[   14.140331] cdc_acm 2-1.6:1.9: ttyACM2: USB ACM device
[   14.143157] usbcore: registered new interface driver cdc_acm
[   14.143159] cdc_acm: USB Abstract Control Model driver for USB modems and ISDN adapters
[   14.880992] input: ACPI Virtual Keyboard Device as /devices/virtual/input/input20
[   17.666886] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: None
[   17.674285] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   21.461985] [drm:ironlake_update_pch_refclk] *ERROR* enabling SSC on PCH
[   21.462505] [drm] Changing LVDS panel from (+hsync, -vsync) to (-hsync, +vsync)
[   21.777631] [drm:ironlake_update_pch_refclk] *ERROR* enabling SSC on PCH
[   26.243165] ip_tables: (C) 2000-2006 Netfilter Core Team
[   26.261740] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   28.106000] eth0: no IPv6 routers present
[   35.091362] [drm:ironlake_update_pch_refclk] *ERROR* enabling SSC on PCH
[   35.091878] [drm] Changing LVDS panel from (-hsync, +vsync) to (+hsync, -vsync)
[   35.395044] [drm:ironlake_update_pch_refclk] *ERROR* enabling SSC on PCH

--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg.good"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.0.4 (samy@type) (gcc version 4.6.1 (Debian 4.6.1-4) ) #2 SMP Tue Aug 30 11:04:23 CEST 2011
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.0.4 root=UUID=38e6e493-2f5f-4a98-b1d6-a9434f0683cc ro i915.i915_enable-fbc=0
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 0000000000091400 (usable)
[    0.000000]  BIOS-e820: 0000000000091400 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 0000000020000000 (usable)
[    0.000000]  BIOS-e820: 0000000020000000 - 0000000020200000 (reserved)
[    0.000000]  BIOS-e820: 0000000020200000 - 0000000040000000 (usable)
[    0.000000]  BIOS-e820: 0000000040000000 - 0000000040200000 (reserved)
[    0.000000]  BIOS-e820: 0000000040200000 - 00000000baa2a000 (usable)
[    0.000000]  BIOS-e820: 00000000baa2a000 - 00000000baa6e000 (reserved)
[    0.000000]  BIOS-e820: 00000000baa6e000 - 00000000badb7000 (usable)
[    0.000000]  BIOS-e820: 00000000badb7000 - 00000000bade7000 (reserved)
[    0.000000]  BIOS-e820: 00000000bade7000 - 00000000bafe7000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bafe7000 - 00000000bafff000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bafff000 - 00000000bb000000 (usable)
[    0.000000]  BIOS-e820: 00000000bb800000 - 00000000bfa00000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffc00000 - 00000000ffc20000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000013e000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.6 present.
[    0.000000] DMI: Dell Inc. Latitude E6420/032T9K, BIOS A05 05/24/2011
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x13e000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 080000000 mask FC0000000 write-back
[    0.000000]   2 base 0BC000000 mask FFC000000 uncachable
[    0.000000]   3 base 0BB000000 mask FFF000000 uncachable
[    0.000000]   4 base 100000000 mask FC0000000 write-back
[    0.000000]   5 base 13E000000 mask FFE000000 uncachable
[    0.000000]   6 base 0FFC00000 mask FFFC00000 write-protect
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] last_pfn = 0xbb000 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [ffff8800000f1b60] f1b60
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff88000008c000] 8c000 size 20480
[    0.000000] init_memory_mapping: 0000000000000000-00000000bb000000
[    0.000000]  0000000000 - 00bb000000 page 2M
[    0.000000] kernel direct mapping tables up to bb000000 @ badb3000-badb7000
[    0.000000] init_memory_mapping: 0000000100000000-000000013e000000
[    0.000000]  0100000000 - 013e000000 page 2M
[    0.000000] kernel direct mapping tables up to 13e000000 @ 13dffa000-13e000000
[    0.000000] RAMDISK: 2db08000 - 32d7c000
[    0.000000] ACPI: RSDP 00000000000fe300 00024 (v02 DELL  )
[    0.000000] ACPI: XSDT 00000000baffde18 0007C (v01 DELL    CBX3    06222004 MSFT 00010013)
[    0.000000] ACPI: FACP 00000000baf87d98 000F4 (v04 DELL    CBX3    06222004 MSFT 00010013)
[    0.000000] ACPI Warning: 32/64 FACS address mismatch in FADT - two FACS tables! (20110413/tbfadt-369)
[    0.000000] ACPI Warning: 32/64X FACS address mismatch in FADT - 0xBAFE4E40/0x00000000BAFE4D40, using 32 (20110413/tbfadt-489)
[    0.000000] ACPI: DSDT 00000000baf6d018 08A3D (v02 INT430 SYSFexxx 00001001 INTL 20090903)
[    0.000000] ACPI: FACS 00000000bafe4e40 00040
[    0.000000] ACPI: APIC 00000000baffcf18 000CC (v02 DELL    CBX3    06222004 MSFT 00010013)
[    0.000000] ACPI: TCPA 00000000bafe5d18 00032 (v02                 00000000      00000000)
[    0.000000] ACPI: MCFG 00000000bafe5c98 0003C (v01 DELL   SNDYBRDG 06222004 MSFT 00000097)
[    0.000000] ACPI: HPET 00000000bafe5c18 00038 (v01 A M I   PCHHPET 06222004 AMI. 00000003)
[    0.000000] ACPI: BOOT 00000000bafe5b98 00028 (v01 DELL   CBX3     06222004 AMI  00010013)
[    0.000000] ACPI: SSDT 00000000baf6c018 0094E (v01  PmRef  Cpu0Ist 00003000 INTL 20090903)
[    0.000000] ACPI: SSDT 00000000baf6b018 00996 (v01  PmRef    CpuPm 00003000 INTL 20090903)
[    0.000000] ACPI: DMAR 00000000baf87c18 000E8 (v01 INTEL      SNB  00000001 INTL 00000001)
[    0.000000] ACPI: SLIC 00000000baf88a18 00176 (v03 DELL    CBX3    06222004 MSFT 00010013)
[    0.000000] ACPI: SSDT 00000000baf65018 014A0 (v01 NvdRef  NvdTabl 00001000 INTL 20090903)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000013e000000
[    0.000000] Initmem setup node 0 0000000000000000-000000013e000000
[    0.000000]   NODE_DATA [000000013dffb000 - 000000013dffffff]
[    0.000000]  [ffffea0000000000-ffffea00045fffff] PMD -> [ffff880139600000-ffff88013cdfffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x0013e000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[7] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x00000091
[    0.000000]     0: 0x00000100 -> 0x00020000
[    0.000000]     0: 0x00020200 -> 0x00040000
[    0.000000]     0: 0x00040200 -> 0x000baa2a
[    0.000000]     0: 0x000baa6e -> 0x000badb7
[    0.000000]     0: 0x000bafff -> 0x000bb000
[    0.000000]     0: 0x00100000 -> 0x0013e000
[    0.000000] On node 0 totalpages: 1018101
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 5 pages reserved
[    0.000000]   DMA zone: 3908 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 745900 pages, LIFO batch:31
[    0.000000]   Normal zone: 3472 pages used for memmap
[    0.000000]   Normal zone: 250480 pages, LIFO batch:31
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
[    0.000000] PM: Registered nosave memory: 0000000000091000 - 0000000000092000
[    0.000000] PM: Registered nosave memory: 0000000000092000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 0000000020000000 - 0000000020200000
[    0.000000] PM: Registered nosave memory: 0000000040000000 - 0000000040200000
[    0.000000] PM: Registered nosave memory: 00000000baa2a000 - 00000000baa6e000
[    0.000000] PM: Registered nosave memory: 00000000badb7000 - 00000000bade7000
[    0.000000] PM: Registered nosave memory: 00000000bade7000 - 00000000bafe7000
[    0.000000] PM: Registered nosave memory: 00000000bafe7000 - 00000000bafff000
[    0.000000] PM: Registered nosave memory: 00000000bb000000 - 00000000bb800000
[    0.000000] PM: Registered nosave memory: 00000000bb800000 - 00000000bfa00000
[    0.000000] PM: Registered nosave memory: 00000000bfa00000 - 00000000fed1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed20000
[    0.000000] PM: Registered nosave memory: 00000000fed20000 - 00000000ffc00000
[    0.000000] PM: Registered nosave memory: 00000000ffc00000 - 00000000ffc20000
[    0.000000] PM: Registered nosave memory: 00000000ffc20000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at bfa00000 (gap: bfa00000:3f31c000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:16 nr_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88013dc00000 s78976 r8192 d23424 u131072
[    0.000000] pcpu-alloc: s78976 r8192 d23424 u131072 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1000288
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.0.4 root=UUID=38e6e493-2f5f-4a98-b1d6-a9434f0683cc ro i915.i915_enable-fbc=0
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave/xrstor: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Queued invalidation will be enabled to support x2apic and Intr-remapping.
[    0.000000] Memory: 3854332k/5210112k available (3753k kernel code, 1137708k absent, 218072k reserved, 2969k data, 572k init)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] NR_IRQS:33024 nr_irqs:808 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 33554432 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.004000] Detected 2195.364 MHz processor.
[    0.000003] Calibrating delay loop (skipped), value calculated using timer frequency.. 4390.72 BogoMIPS (lpj=8781456)
[    0.000123] pid_max: default: 32768 minimum: 301
[    0.000233] Security Framework initialized
[    0.000292] SELinux:  Disabled at boot.
[    0.000722] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.001724] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.002184] Mount-cache hash table entries: 256
[    0.002363] Initializing cgroup subsys cpuacct
[    0.002426] Initializing cgroup subsys memory
[    0.002493] Initializing cgroup subsys devices
[    0.002549] Initializing cgroup subsys freezer
[    0.002606] Initializing cgroup subsys net_cls
[    0.002665] Initializing cgroup subsys blkio
[    0.002753] CPU: Physical Processor ID: 0
[    0.002809] CPU: Processor Core ID: 0
[    0.002868] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.002869] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.002991] mce: CPU supports 9 MCE banks
[    0.003060] CPU0: Thermal monitoring enabled (TM1)
[    0.003123] using mwait in idle threads.
[    0.003640] ACPI: Core revision 20110413
[    0.011762] DMAR: Host address width 36
[    0.011832] DMAR: DRHD base: 0x000000fed90000 flags: 0x0
[    0.011897] IOMMU 0: reg_base_addr fed90000 ver 1:0 cap c0000020e60262 ecap f0101a
[    0.011974] DMAR: DRHD base: 0x000000fed91000 flags: 0x1
[    0.012038] IOMMU 1: reg_base_addr fed91000 ver 1:0 cap c9008020660262 ecap f0105a
[    0.012114] DMAR: RMRR base: 0x000000badc6000 end: 0x000000badd5fff
[    0.012177] DMAR: RMRR base: 0x000000bb800000 end: 0x000000bf9fffff
[    0.012239] DMAR: No ATSR found
[    0.012365] IOAPIC id 2 under DRHD base  0xfed91000 IOMMU 1
[    0.012425] HPET id 0 under DRHD base 0xfed91000
[    0.012483] HPET id 0 under DRHD base 0xfed91000
[    0.012542] HPET id 0 under DRHD base 0xfed91000
[    0.012600] HPET id 0 under DRHD base 0xfed91000
[    0.012659] HPET id 0 under DRHD base 0xfed91000
[    0.012718] HPET id 0 under DRHD base 0xfed91000
[    0.012775] HPET id 0 under DRHD base 0xfed91000
[    0.012833] HPET id 0 under DRHD base 0xfed91000
[    0.013088] Enabled Interrupt-remapping
[    0.013145] Enabling x2apic
[    0.013201] Enabled x2apic
[    0.014634] Switched APIC routing to cluster x2apic.
[    0.015080] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.054136] CPU0: Intel(R) Core(TM) i7-2720QM CPU @ 2.20GHz stepping 07
[    0.159663] Performance Events: PEBS fmt1+, SandyBridge events, Intel PMU driver.
[    0.159857] ... version:                3
[    0.159915] ... bit width:              48
[    0.159971] ... generic registers:      4
[    0.160029] ... value mask:             0000ffffffffffff
[    0.160089] ... max period:             000000007fffffff
[    0.160149] ... fixed-purpose events:   3
[    0.160207] ... event mask:             000000070000000f
[    0.160469] NMI watchdog enabled, takes one hw-pmu counter.
[    0.160629] Booting Node   0, Processors  #1
[    0.160716] smpboot cpu 1: start_ip = 8c000
[    0.271623] NMI watchdog enabled, takes one hw-pmu counter.
[    0.271786]  #2
[    0.271827] smpboot cpu 2: start_ip = 8c000
[    0.379557] NMI watchdog enabled, takes one hw-pmu counter.
[    0.379719]  #3
[    0.379761] smpboot cpu 3: start_ip = 8c000
[    0.487389] NMI watchdog enabled, takes one hw-pmu counter.
[    0.487549]  #4
[    0.487592] smpboot cpu 4: start_ip = 8c000
[    0.595310] NMI watchdog enabled, takes one hw-pmu counter.
[    0.595477]  #5
[    0.595520] smpboot cpu 5: start_ip = 8c000
[    0.703147] NMI watchdog enabled, takes one hw-pmu counter.
[    0.703311]  #6
[    0.703353] smpboot cpu 6: start_ip = 8c000
[    0.811082] NMI watchdog enabled, takes one hw-pmu counter.
[    0.811244]  #7
[    0.811286] smpboot cpu 7: start_ip = 8c000
[    0.918913] NMI watchdog enabled, takes one hw-pmu counter.
[    0.919003] Brought up 8 CPUs
[    0.919060] Total of 8 processors activated (35119.58 BogoMIPS).
[    0.924494] devtmpfs: initialized
[    0.928015] PM: Registering ACPI NVS region at bade7000 (2097152 bytes)
[    0.928179] Dell Latitude E6420 series board detected. Selecting PCI-method for reboots.
[    0.928384] print_constraints: dummy: 
[    0.928502] NET: Registered protocol family 16
[    0.928645] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.928722] ACPI: bus type pci registered
[    0.928859] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.928939] PCI: not using MMCONFIG
[    0.928996] PCI: Using configuration type 1 for base access
[    0.929062] dmi type 0xB1 record - unknown flag
[    0.929824] bio: create slab <bio-0> at 0
[    0.931433] ACPI: EC: Look up EC in DSDT
[    0.958836] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.994965] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    1.099100] ACPI: SSDT 00000000badd7718 0067C (v01  PmRef  Cpu0Cst 00003001 INTL 20090903)
[    1.099670] ACPI: Dynamic OEM Table Load:
[    1.099805] ACPI: SSDT           (null) 0067C (v01  PmRef  Cpu0Cst 00003001 INTL 20090903)
[    1.110963] ACPI: SSDT 00000000badd8a98 00303 (v01  PmRef    ApIst 00003000 INTL 20090903)
[    1.111585] ACPI: Dynamic OEM Table Load:
[    1.111719] ACPI: SSDT           (null) 00303 (v01  PmRef    ApIst 00003000 INTL 20090903)
[    1.122752] ACPI: SSDT 00000000badd6d98 00119 (v01  PmRef    ApCst 00003000 INTL 20090903)
[    1.123306] ACPI: Dynamic OEM Table Load:
[    1.123439] ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst 00003000 INTL 20090903)
[    1.206579] ACPI: Interpreter enabled
[    1.206638] ACPI: (supports S0 S3 S4 S5)
[    1.206876] ACPI: Using IOAPIC for interrupt routing
[    1.206954] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    1.207578] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in ACPI motherboard resources
[    1.926504] ACPI: EC: GPE = 0x10, I/O: command/status = 0x934, data = 0x930
[    1.981711] ACPI: No dock devices found.
[    1.981773] HEST: Table not found.
[    1.981830] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    1.982364] \_SB_.PCI0:_OSC invalid UUID
[    1.982365] _OSC request data:1 8 1f 
[    1.982369] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
[    1.983243] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    1.983307] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    1.983369] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    1.983446] pci_root PNP0A08:00: host bridge window [mem 0xbfa00000-0xfeafffff]
[    1.983521] pci_root PNP0A08:00: host bridge window [mem 0xfed40000-0xfed44fff]
[    1.983606] pci 0000:00:00.0: [8086:0104] type 0 class 0x000600
[    1.983641] pci 0000:00:01.0: [8086:0101] type 1 class 0x000604
[    1.983666] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    1.983669] pci 0000:00:01.0: PME# disabled
[    1.983689] pci 0000:00:02.0: [8086:0126] type 0 class 0x000300
[    1.983699] pci 0000:00:02.0: reg 10: [mem 0xe5400000-0xe57fffff 64bit]
[    1.983706] pci 0000:00:02.0: reg 18: [mem 0xc0000000-0xcfffffff 64bit pref]
[    1.983710] pci 0000:00:02.0: reg 20: [io  0x5000-0x503f]
[    1.983762] pci 0000:00:16.0: [8086:1c3a] type 0 class 0x000780
[    1.983786] pci 0000:00:16.0: reg 10: [mem 0xe6eb0000-0xe6eb000f 64bit]
[    1.983850] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    1.983854] pci 0000:00:16.0: PME# disabled
[    1.983886] pci 0000:00:19.0: [8086:1502] type 0 class 0x000200
[    1.983905] pci 0000:00:19.0: reg 10: [mem 0xe6e00000-0xe6e1ffff]
[    1.983914] pci 0000:00:19.0: reg 14: [mem 0xe6e80000-0xe6e80fff]
[    1.983923] pci 0000:00:19.0: reg 18: [io  0x5080-0x509f]
[    1.983974] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    1.983979] pci 0000:00:19.0: PME# disabled
[    1.984006] pci 0000:00:1a.0: [8086:1c2d] type 0 class 0x000c03
[    1.984028] pci 0000:00:1a.0: reg 10: [mem 0xe6e70000-0xe6e703ff]
[    1.984102] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    1.984107] pci 0000:00:1a.0: PME# disabled
[    1.984132] pci 0000:00:1b.0: [8086:1c20] type 0 class 0x000403
[    1.984148] pci 0000:00:1b.0: reg 10: [mem 0xe6e60000-0xe6e63fff 64bit]
[    1.984205] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    1.984209] pci 0000:00:1b.0: PME# disabled
[    1.984235] pci 0000:00:1c.0: [8086:1c10] type 1 class 0x000604
[    1.984337] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    1.984341] pci 0000:00:1c.0: PME# disabled
[    1.984375] pci 0000:00:1c.1: [8086:1c12] type 1 class 0x000604
[    1.984477] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    1.984482] pci 0000:00:1c.1: PME# disabled
[    1.984517] pci 0000:00:1c.2: [8086:1c14] type 1 class 0x000604
[    1.984618] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    1.984623] pci 0000:00:1c.2: PME# disabled
[    1.984658] pci 0000:00:1c.3: [8086:1c16] type 1 class 0x000604
[    1.984760] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    1.984765] pci 0000:00:1c.3: PME# disabled
[    1.984802] pci 0000:00:1c.5: [8086:1c1a] type 1 class 0x000604
[    1.984902] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    1.984907] pci 0000:00:1c.5: PME# disabled
[    1.984947] pci 0000:00:1d.0: [8086:1c26] type 0 class 0x000c03
[    1.984969] pci 0000:00:1d.0: reg 10: [mem 0xe6e50000-0xe6e503ff]
[    1.985044] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    1.985048] pci 0000:00:1d.0: PME# disabled
[    1.985075] pci 0000:00:1f.0: [8086:1c4f] type 0 class 0x000601
[    1.985193] pci 0000:00:1f.2: [8086:282a] type 0 class 0x000104
[    1.985213] pci 0000:00:1f.2: reg 10: [io  0x50d0-0x50d7]
[    1.985222] pci 0000:00:1f.2: reg 14: [io  0x50c0-0x50c3]
[    1.985230] pci 0000:00:1f.2: reg 18: [io  0x50b0-0x50b7]
[    1.985239] pci 0000:00:1f.2: reg 1c: [io  0x50a0-0x50a3]
[    1.985247] pci 0000:00:1f.2: reg 20: [io  0x5060-0x507f]
[    1.985256] pci 0000:00:1f.2: reg 24: [mem 0xe6e40000-0xe6e407ff]
[    1.985290] pci 0000:00:1f.2: PME# supported from D3hot
[    1.985294] pci 0000:00:1f.2: PME# disabled
[    1.985313] pci 0000:00:1f.3: [8086:1c22] type 0 class 0x000c05
[    1.985329] pci 0000:00:1f.3: reg 10: [mem 0xe6e30000-0xe6e300ff 64bit]
[    1.985351] pci 0000:00:1f.3: reg 20: [io  0x5040-0x505f]
[    1.985414] pci 0000:01:00.0: [10de:1056] type 0 class 0x000300
[    1.985426] pci 0000:01:00.0: reg 10: [mem 0xe4000000-0xe4ffffff]
[    1.985439] pci 0000:01:00.0: reg 14: [mem 0xd0000000-0xdfffffff 64bit pref]
[    1.985452] pci 0000:01:00.0: reg 1c: [mem 0xe0000000-0xe1ffffff 64bit pref]
[    1.985461] pci 0000:01:00.0: reg 24: [io  0x4000-0x407f]
[    1.985470] pci 0000:01:00.0: reg 30: [mem 0xe5000000-0xe507ffff pref]
[    1.985522] pci 0000:01:00.1: [10de:0e08] type 0 class 0x000403
[    1.985534] pci 0000:01:00.1: reg 10: [mem 0xe5080000-0xe5083fff]
[    1.985631] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    1.985691] pci 0000:00:01.0:   bridge window [io  0x4000-0x4fff]
[    1.985694] pci 0000:00:01.0:   bridge window [mem 0xe4000000-0xe50fffff]
[    1.985698] pci 0000:00:01.0:   bridge window [mem 0xd0000000-0xe1ffffff 64bit pref]
[    1.985770] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    1.985834] pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000] (disabled)
[    1.985840] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    1.985849] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.985977] pci 0000:03:00.0: [14e4:4727] type 0 class 0x000280
[    1.986007] pci 0000:03:00.0: reg 10: [mem 0xe6d00000-0xe6d03fff 64bit]
[    1.986128] pci 0000:03:00.0: supports D1 D2
[    1.986129] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    1.986135] pci 0000:03:00.0: PME# disabled
[    1.986185] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    1.986247] pci 0000:00:1c.1:   bridge window [io  0xf000-0x0000] (disabled)
[    1.986252] pci 0000:00:1c.1:   bridge window [mem 0xe6d00000-0xe6dfffff]
[    1.986258] pci 0000:00:1c.1:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.986305] pci 0000:00:1c.2: PCI bridge to [bus 04-09]
[    1.986367] pci 0000:00:1c.2:   bridge window [io  0x3000-0x3fff]
[    1.986372] pci 0000:00:1c.2:   bridge window [mem 0xe6200000-0xe6bfffff]
[    1.986378] pci 0000:00:1c.2:   bridge window [mem 0xe2b00000-0xe34fffff 64bit pref]
[    1.986425] pci 0000:00:1c.3: PCI bridge to [bus 0a-0a]
[    1.986487] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    1.986492] pci 0000:00:1c.3:   bridge window [mem 0xe5800000-0xe61fffff]
[    1.986498] pci 0000:00:1c.3:   bridge window [mem 0xe2100000-0xe2afffff 64bit pref]
[    1.988312] pci 0000:0b:00.0: [1217:8221] type 0 class 0x000805
[    1.988352] pci 0000:0b:00.0: reg 10: [mem 0xe6c20000-0xe6c201ff]
[    1.988614] pci 0000:0b:00.0: supports D1 D2
[    1.988616] pci 0000:0b:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.988626] pci 0000:0b:00.0: PME# disabled
[    1.988719] pci 0000:0b:00.1: [1217:8231] type 0 class 0x000180
[    1.988762] pci 0000:0b:00.1: reg 10: [mem 0xe6c10000-0xe6c10fff]
[    1.988822] pci 0000:0b:00.1: reg 18: [mem 0xe6c00000-0xe6c007ff]
[    1.989025] pci 0000:0b:00.1: supports D1 D2
[    1.989026] pci 0000:0b:00.1: PME# supported from D0 D1 D2 D3hot D3cold
[    1.989037] pci 0000:0b:00.1: PME# disabled
[    1.989143] pci 0000:00:1c.5: PCI bridge to [bus 0b-0b]
[    1.989205] pci 0000:00:1c.5:   bridge window [io  0xf000-0x0000] (disabled)
[    1.989209] pci 0000:00:1c.5:   bridge window [mem 0xe6c00000-0xe6cfffff]
[    1.989215] pci 0000:00:1c.5:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.989244] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    1.989522] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    1.989577] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    1.989627] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP04._PRT]
[    1.989678] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP06._PRT]
[    1.989734] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEG0._PRT]
[    1.989798] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
[    1.989910] \_SB_.PCI0:_OSC invalid UUID
[    1.989911] _OSC request data:1 1f 1f 
[    1.989915]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    1.990019] \_SB_.PCI0:_OSC invalid UUID
[    1.990020] _OSC request data:1 0 1d 
[    1.990023]  pci0000:00: ACPI _OSC request failed (AE_ERROR), returned control mask: 0x1d
[    1.990099] ACPI _OSC control for PCIe not granted, disabling ASPM
[    1.995568] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
[    1.996197] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
[    1.996820] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
[    1.997446] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
[    1.998073] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 *5 6 7 10 12 14 15)
[    1.998643] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
[    1.999308] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 *3 4 5 6 7 10 12 14 15)
[    1.999879] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
[    2.000577] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    2.000663] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=none,locks=none
[    2.000741] vgaarb: loaded
[    2.000796] vgaarb: bridge control possible 0000:01:00.0
[    2.000856] vgaarb: bridge control possible 0000:00:02.0
[    2.001041] SCSI subsystem initialized
[    2.001139] libata version 3.00 loaded.
[    2.001174] PCI: Using ACPI for IRQ routing
[    2.002775] PCI: pci_cache_line_size set to 64 bytes
[    2.002870] reserve RAM buffer: 0000000000091400 - 000000000009ffff 
[    2.002872] reserve RAM buffer: 00000000baa2a000 - 00000000bbffffff 
[    2.002876] reserve RAM buffer: 00000000badb7000 - 00000000bbffffff 
[    2.002879] reserve RAM buffer: 00000000bb000000 - 00000000bbffffff 
[    2.002882] reserve RAM buffer: 000000013e000000 - 000000013fffffff 
[    2.002985] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    2.003396] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    2.005471] Switching to clocksource hpet
[    2.005627] Switched to NOHz mode on CPU #1
[    2.005641] Switched to NOHz mode on CPU #3
[    2.005647] Switched to NOHz mode on CPU #5
[    2.005659] Switched to NOHz mode on CPU #7
[    2.005686] Switched to NOHz mode on CPU #2
[    2.005688] Switched to NOHz mode on CPU #4
[    2.005706] Switched to NOHz mode on CPU #6
[    2.007607] pnp: PnP ACPI init
[    2.007675] ACPI: bus type pnp registered
[    2.008148] pnp 00:00: [bus 00-3e]
[    2.008151] pnp 00:00: [io  0x0000-0x0cf7 window]
[    2.008153] pnp 00:00: [io  0x0cf8-0x0cff]
[    2.008155] pnp 00:00: [io  0x0d00-0xffff window]
[    2.008157] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    2.008159] pnp 00:00: [mem 0x000c0000-0x000c3fff window]
[    2.008161] pnp 00:00: [mem 0x000c4000-0x000c7fff window]
[    2.008163] pnp 00:00: [mem 0x000c8000-0x000cbfff window]
[    2.008164] pnp 00:00: [mem 0x000cc000-0x000cffff window]
[    2.008167] pnp 00:00: [mem 0x000d0000-0x000d3fff window]
[    2.008169] pnp 00:00: [mem 0x000d4000-0x000d7fff window]
[    2.008170] pnp 00:00: [mem 0x000d8000-0x000dbfff window]
[    2.008172] pnp 00:00: [mem 0x000dc000-0x000dffff window]
[    2.008174] pnp 00:00: [mem 0x000e0000-0x000e3fff window]
[    2.008176] pnp 00:00: [mem 0x000e4000-0x000e7fff window]
[    2.008178] pnp 00:00: [mem 0x000e8000-0x000ebfff window]
[    2.008179] pnp 00:00: [mem 0x000ec000-0x000effff window]
[    2.008181] pnp 00:00: [mem 0x000f0000-0x000fffff window]
[    2.008183] pnp 00:00: [mem 0xbfa00000-0xfeafffff window]
[    2.008185] pnp 00:00: [mem 0xfed40000-0xfed44fff window]
[    2.008231] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    2.008246] pnp 00:01: [io  0x0000-0x001f]
[    2.008247] pnp 00:01: [io  0x0081-0x0091]
[    2.008250] pnp 00:01: [io  0x0093-0x009f]
[    2.008252] pnp 00:01: [io  0x00c0-0x00df]
[    2.008254] pnp 00:01: [dma 4]
[    2.008276] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    2.008285] pnp 00:02: [mem 0xff000000-0xffffffff]
[    2.008306] pnp 00:02: Plug and Play ACPI device, IDs INT0800 (active)
[    2.008390] pnp 00:03: [mem 0xfed00000-0xfed003ff]
[    2.008428] system 00:03: [mem 0xfed00000-0xfed003ff] has been reserved
[    2.008492] system 00:03: Plug and Play ACPI device, IDs PNP0103 PNP0c01 (active)
[    2.008503] pnp 00:04: [io  0x00f0]
[    2.008512] pnp 00:04: [irq 13]
[    2.008536] pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
[    2.008548] pnp 00:05: [io  0x002e-0x002f]
[    2.008549] pnp 00:05: [io  0x004e-0x004f]
[    2.008551] pnp 00:05: [io  0x0061]
[    2.008553] pnp 00:05: [io  0x0063]
[    2.008554] pnp 00:05: [io  0x0065]
[    2.008556] pnp 00:05: [io  0x0067]
[    2.008557] pnp 00:05: [io  0x0070]
[    2.008558] pnp 00:05: [io  0x0080]
[    2.008560] pnp 00:05: [io  0x0092]
[    2.008561] pnp 00:05: [io  0x00b2-0x00b3]
[    2.008563] pnp 00:05: [io  0x0680-0x069f]
[    2.008565] pnp 00:05: [io  0x1000-0x100f]
[    2.008566] pnp 00:05: [io  0xffff]
[    2.008568] pnp 00:05: [io  0xffff]
[    2.008569] pnp 00:05: [io  0x0400-0x047f]
[    2.008571] pnp 00:05: [io  0x0500-0x057f]
[    2.008572] pnp 00:05: [io  0x164e-0x164f]
[    2.008617] system 00:05: [io  0x0680-0x069f] has been reserved
[    2.008678] system 00:05: [io  0x1000-0x100f] has been reserved
[    2.008741] system 00:05: [io  0xffff] has been reserved
[    2.008802] system 00:05: [io  0xffff] has been reserved
[    2.008864] system 00:05: [io  0x0400-0x047f] has been reserved
[    2.008927] system 00:05: [io  0x0500-0x057f] has been reserved
[    2.008989] system 00:05: [io  0x164e-0x164f] has been reserved
[    2.009052] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    2.009061] pnp 00:06: [io  0x0070-0x0077]
[    2.009067] pnp 00:06: [irq 8]
[    2.009094] pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
[    2.009105] pnp 00:07: [io  0x0060]
[    2.009106] pnp 00:07: [io  0x0064]
[    2.009112] pnp 00:07: [irq 1]
[    2.009135] pnp 00:07: Plug and Play ACPI device, IDs PNP0303 (active)
[    2.009549] Switched to NOHz mode on CPU #0
[    2.013629] pnp 00:08: Plug and Play ACPI device, IDs PNP0401 (disabled)
[    2.013645] pnp 00:09: [irq 12]
[    2.013670] pnp 00:09: Plug and Play ACPI device, IDs DLL0493 PNP0f13 (active)
[    2.013854] pnp 00:0a: [mem 0xfed1c000-0xfed1ffff]
[    2.013856] pnp 00:0a: [mem 0xfed10000-0xfed17fff]
[    2.013857] pnp 00:0a: [mem 0xfed18000-0xfed18fff]
[    2.013859] pnp 00:0a: [mem 0xfed19000-0xfed19fff]
[    2.013860] pnp 00:0a: [mem 0xf8000000-0xfbffffff]
[    2.013862] pnp 00:0a: [mem 0xfed20000-0xfed3ffff]
[    2.013864] pnp 00:0a: [mem 0xfed90000-0xfed93fff]
[    2.013866] pnp 00:0a: [mem 0xfed45000-0xfed8ffff]
[    2.013867] pnp 00:0a: [mem 0xff000000-0xffffffff]
[    2.013869] pnp 00:0a: [mem 0xfee00000-0xfeefffff]
[    2.013871] pnp 00:0a: [mem 0x00000000-0xffffffffffffffff disabled]
[    2.013873] pnp 00:0a: [mem 0x00000000-0xffffffffffffffff disabled]
[    2.013927] system 00:0a: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    2.013990] system 00:0a: [mem 0xfed10000-0xfed17fff] has been reserved
[    2.014054] system 00:0a: [mem 0xfed18000-0xfed18fff] has been reserved
[    2.014118] system 00:0a: [mem 0xfed19000-0xfed19fff] has been reserved
[    2.014181] system 00:0a: [mem 0xf8000000-0xfbffffff] has been reserved
[    2.014244] system 00:0a: [mem 0xfed20000-0xfed3ffff] has been reserved
[    2.014307] system 00:0a: [mem 0xfed90000-0xfed93fff] has been reserved
[    2.014370] system 00:0a: [mem 0xfed45000-0xfed8ffff] has been reserved
[    2.014433] system 00:0a: [mem 0xff000000-0xffffffff] could not be reserved
[    2.014497] system 00:0a: [mem 0xfee00000-0xfeefffff] has been reserved
[    2.014560] system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
[    2.015153] pnp 00:0b: [irq 23]
[    2.015191] pnp 00:0b: Plug and Play ACPI device, IDs SMO8800 (active)
[    2.033574] pnp 00:0c: [mem 0x20000000-0x201fffff]
[    2.033578] pnp 00:0c: [mem 0x40000000-0x401fffff]
[    2.037553] system 00:0c: [mem 0x20000000-0x201fffff] has been reserved
[    2.037629] system 00:0c: [mem 0x40000000-0x401fffff] has been reserved
[    2.037696] system 00:0c: Plug and Play ACPI device, IDs PNP0c01 (active)
[    2.041490] pnp: PnP ACPI: found 13 devices
[    2.041557] ACPI: ACPI bus type pnp unregistered
[    2.047682] PCI: max bus depth: 1 pci_try_num: 2
[    2.047728] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    2.047790] pci 0000:00:01.0:   bridge window [io  0x4000-0x4fff]
[    2.047853] pci 0000:00:01.0:   bridge window [mem 0xe4000000-0xe50fffff]
[    2.047918] pci 0000:00:01.0:   bridge window [mem 0xd0000000-0xe1ffffff 64bit pref]
[    2.047996] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    2.048056] pci 0000:00:1c.0:   bridge window [io  disabled]
[    2.048120] pci 0000:00:1c.0:   bridge window [mem disabled]
[    2.048182] pci 0000:00:1c.0:   bridge window [mem pref disabled]
[    2.048248] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    2.048309] pci 0000:00:1c.1:   bridge window [io  disabled]
[    2.048373] pci 0000:00:1c.1:   bridge window [mem 0xe6d00000-0xe6dfffff]
[    2.048438] pci 0000:00:1c.1:   bridge window [mem pref disabled]
[    2.048502] pci 0000:00:1c.2: PCI bridge to [bus 04-09]
[    2.048563] pci 0000:00:1c.2:   bridge window [io  0x3000-0x3fff]
[    2.048628] pci 0000:00:1c.2:   bridge window [mem 0xe6200000-0xe6bfffff]
[    2.048693] pci 0000:00:1c.2:   bridge window [mem 0xe2b00000-0xe34fffff 64bit pref]
[    2.048774] pci 0000:00:1c.3: PCI bridge to [bus 0a-0a]
[    2.048835] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    2.048900] pci 0000:00:1c.3:   bridge window [mem 0xe5800000-0xe61fffff]
[    2.048965] pci 0000:00:1c.3:   bridge window [mem 0xe2100000-0xe2afffff 64bit pref]
[    2.049046] pci 0000:00:1c.5: PCI bridge to [bus 0b-0b]
[    2.049108] pci 0000:00:1c.5:   bridge window [io  disabled]
[    2.049172] pci 0000:00:1c.5:   bridge window [mem 0xe6c00000-0xe6cfffff]
[    2.049238] pci 0000:00:1c.5:   bridge window [mem pref disabled]
[    2.049485] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.049552] pci 0000:00:01.0: setting latency timer to 64
[    2.049559] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.049625] pci 0000:00:1c.0: setting latency timer to 64
[    2.049638] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    2.051080] pci 0000:00:1c.1: setting latency timer to 64
[    2.051092] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    2.051158] pci 0000:00:1c.2: setting latency timer to 64
[    2.051170] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    2.051235] pci 0000:00:1c.3: setting latency timer to 64
[    2.051242] pci 0000:00:1c.5: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    2.051307] pci 0000:00:1c.5: setting latency timer to 64
[    2.051312] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    2.051314] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    2.051316] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    2.051317] pci_bus 0000:00: resource 7 [mem 0xbfa00000-0xfeafffff]
[    2.051319] pci_bus 0000:00: resource 8 [mem 0xfed40000-0xfed44fff]
[    2.051321] pci_bus 0000:01: resource 0 [io  0x4000-0x4fff]
[    2.051323] pci_bus 0000:01: resource 1 [mem 0xe4000000-0xe50fffff]
[    2.051325] pci_bus 0000:01: resource 2 [mem 0xd0000000-0xe1ffffff 64bit pref]
[    2.051327] pci_bus 0000:03: resource 1 [mem 0xe6d00000-0xe6dfffff]
[    2.051329] pci_bus 0000:04: resource 0 [io  0x3000-0x3fff]
[    2.051331] pci_bus 0000:04: resource 1 [mem 0xe6200000-0xe6bfffff]
[    2.051333] pci_bus 0000:04: resource 2 [mem 0xe2b00000-0xe34fffff 64bit pref]
[    2.051335] pci_bus 0000:0a: resource 0 [io  0x2000-0x2fff]
[    2.051336] pci_bus 0000:0a: resource 1 [mem 0xe5800000-0xe61fffff]
[    2.051338] pci_bus 0000:0a: resource 2 [mem 0xe2100000-0xe2afffff 64bit pref]
[    2.051340] pci_bus 0000:0b: resource 1 [mem 0xe6c00000-0xe6cfffff]
[    2.051447] NET: Registered protocol family 2
[    2.051666] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    2.052736] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    2.054175] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    2.054377] TCP: Hash tables configured (established 524288 bind 65536)
[    2.054439] TCP reno registered
[    2.054504] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    2.054584] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    2.054828] NET: Registered protocol family 1
[    2.054901] pci 0000:00:02.0: Boot video device
[    2.055021] PCI: CLS 64 bytes, default 64
[    2.055060] Unpacking initramfs...
[    3.820381] Freeing initrd memory: 84432k freed
[    3.830495] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    3.830562] Placing 64MB software IO TLB between ffff8800b6a2a000 - ffff8800baa2a000
[    3.830639] software IO TLB at phys 0xb6a2a000 - 0xbaa2a000
[    3.830725] Simple Boot Flag at 0xf3 set to 0x1
[    3.831535] audit: initializing netlink socket (disabled)
[    3.831606] type=2000 audit(1316080994.616:1): initialized
[    3.850799] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    3.859379] VFS: Disk quotas dquot_6.5.2
[    3.859492] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    3.859956] msgmni has been set to 7692
[    3.860188] alg: No test for stdrng (krng)
[    3.860284] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    3.860361] io scheduler noop registered
[    3.860418] io scheduler deadline registered
[    3.860506] io scheduler cfq registered (default)
[    3.860650] pcieport 0000:00:01.0: setting latency timer to 64
[    3.860679] pcieport 0000:00:01.0: irq 42 for MSI/MSI-X
[    3.861019] ERST: Table is not found!
[    3.861132] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    4.039659] Linux agpgart interface v0.103
[    4.039797] agpgart-intel 0000:00:00.0: Intel Sandybridge Chipset
[    4.039944] agpgart-intel 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
[    4.041225] agpgart-intel 0000:00:00.0: detected 65536K stolen memory
[    4.041400] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xc0000000
[    4.041598] ahci 0000:00:1f.2: version 3.0
[    4.041609] ahci 0000:00:1f.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    4.041719] ahci 0000:00:1f.2: irq 43 for MSI/MSI-X
[    4.041745] ahci: SSS flag set, parallel bus scan disabled
[    4.055249] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x3b impl RAID mode
[    4.055341] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part ems sxs apst 
[    4.055422] ahci 0000:00:1f.2: setting latency timer to 64
[    4.087710] scsi0 : ahci
[    4.087874] scsi1 : ahci
[    4.087996] scsi2 : ahci
[    4.088118] scsi3 : ahci
[    4.088240] scsi4 : ahci
[    4.088361] scsi5 : ahci
[    4.100236] ata1: SATA max UDMA/133 abar m2048@0xe6e40000 port 0xe6e40100 irq 43
[    4.100313] ata2: SATA max UDMA/133 abar m2048@0xe6e40000 port 0xe6e40180 irq 43
[    4.100389] ata3: DUMMY
[    4.100445] ata4: SATA max UDMA/133 abar m2048@0xe6e40000 port 0xe6e40280 irq 43
[    4.100522] ata5: SATA max UDMA/133 abar m2048@0xe6e40000 port 0xe6e40300 irq 43
[    4.100597] ata6: SATA max UDMA/133 abar m2048@0xe6e40000 port 0xe6e40380 irq 43
[    4.100765] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    4.101394] i8042: Warning: Keylock active
[    4.102631] serio: i8042 KBD port at 0x60,0x64 irq 1
[    4.102695] serio: i8042 AUX port at 0x60,0x64 irq 12
[    4.102852] mousedev: PS/2 mouse device common for all mice
[    4.102953] rtc_cmos 00:06: RTC can wake from S4
[    4.103146] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
[    4.103246] rtc0: alarms up to one year, y3k, 242 bytes nvram, hpet irqs
[    4.103328] cpuidle: using governor ladder
[    4.103386] cpuidle: using governor menu
[    4.103625] TCP cubic registered
[    4.103838] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    4.103988] NET: Registered protocol family 10
[    4.104510] Mobile IPv6
[    4.104567] NET: Registered protocol family 17
[    4.104629] Registering the dns_resolver key type
[    4.104773] PM: Hibernation image not present or could not be loaded.
[    4.104782] registered taskstats version 1
[    4.112745] rtc_cmos 00:06: setting system clock to 2011-09-15 10:03:15 UTC (1316080995)
[    4.112885] Initializing network drop monitor service
[    4.418812] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    4.426958] ata1.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by device (Stat=0x51 Err=0x04)
[    4.428107] ata1.00: ATA-8: SAMSUNG SSD PM810 2.5" 256GB, AXM08D1Q, max UDMA/133
[    4.428215] ata1.00: 500118192 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    4.435037] ata1.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by device (Stat=0x51 Err=0x04)
[    4.437696] ata1.00: configured for UDMA/133
[    4.442935] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG SSD PM81 AXM0 PQ: 0 ANSI: 5
[    4.443180] sd 0:0:0:0: [sda] 500118192 512-byte logical blocks: (256 GB/238 GiB)
[    4.443305] sd 0:0:0:0: [sda] Write Protect is off
[    4.443365] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    4.443381] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.445237]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 sda9 >
[    4.445718] sd 0:0:0:0: [sda] Attached SCSI disk
[    4.762435] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    4.766059] ata2.00: ATAPI: HL-DT-ST DVD+/-RW GU40N, A103, max UDMA/133
[    4.770030] ata2.00: configured for UDMA/133
[    4.773192] scsi 1:0:0:0: CD-ROM            HL-DT-ST DVD+-RW GU40N    A103 PQ: 0 ANSI: 5
[    4.826363] Refined TSC clocksource calibration: 2195.013 MHz.
[    4.826455] Switching to clocksource tsc
[    5.090066] ata4: SATA link down (SStatus 0 SControl 300)
[    5.409713] ata5: SATA link down (SStatus 0 SControl 300)
[    5.729362] ata6: SATA link down (SStatus 0 SControl 300)
[    5.730406] Freeing unused kernel memory: 572k freed
[    5.730528] Write protecting the kernel read-only data: 6144k
[    5.731714] Freeing unused kernel memory: 324k freed
[    5.733551] Freeing unused kernel memory: 528k freed
[    5.799634] udevd[96]: starting version 172
[    5.814256] e1000e: Intel(R) PRO/1000 Network Driver - 1.3.10-k2
[    5.814324] e1000e: Copyright(c) 1999 - 2011 Intel Corporation.
[    5.825588] sdhci: Secure Digital Host Controller Interface driver
[    5.825653] sdhci: Copyright(c) Pierre Ossman
[    5.826122] sdhci-pci 0000:0b:00.0: SDHCI controller found [1217:8221] (rev 5)
[    5.830557] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    5.830635] cdrom: Uniform CD-ROM driver Revision: 3.20
[    5.830823] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    5.832711] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    5.832831] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    5.861278] sdhci-pci 0000:0b:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    5.861293] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    5.861305] e1000e 0000:00:19.0: setting latency timer to 64
[    5.861623] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[    5.861630] sdhci-pci 0000:0b:00.0: Invalid iomem size. You may experience problems.
[    5.861756] sdhci-pci 0000:0b:00.0: setting latency timer to 64
[    5.861780] mmc0: no vmmc regulator found
[    5.861883] Registered led device: mmc0::
[    5.861929] mmc0: SDHCI controller on PCI [0000:0b:00.0] using DMA
[    5.985166] thermal LNXTHERM:00: registered as thermal_zone0
[    5.985228] ACPI: Thermal Zone [THM] (25 C)
[    6.164309] e1000e 0000:00:19.0: eth0: (PCI Express:2.5GT/s:Width x1) 5c:26:0a:6b:0b:75
[    6.164387] e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    6.164486] e1000e 0000:00:19.0: eth0: MAC: 10, PHY: 11, PBA No: 3041FF-0FF
[    6.888805] PM: Marking nosave pages: 0000000000091000 - 0000000000100000
[    6.888810] PM: Marking nosave pages: 0000000020000000 - 0000000020200000
[    6.888820] PM: Marking nosave pages: 0000000040000000 - 0000000040200000
[    6.888829] PM: Marking nosave pages: 00000000baa2a000 - 00000000baa6e000
[    6.888832] PM: Marking nosave pages: 00000000badb7000 - 00000000bafff000
[    6.888842] PM: Marking nosave pages: 00000000bb000000 - 0000000100000000
[    6.890348] PM: Basic memory bitmaps created
[    6.908976] PM: Basic memory bitmaps freed
[    6.917702] EXT4-fs (sda6): mounted filesystem with ordered data mode. Opts: (null)
[    7.444488] udevd[335]: starting version 172
[    7.532206] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input1
[    7.532682] ACPI: Lid Switch [LID]
[    7.532800] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input2
[    7.532874] ACPI: Power Button [PBTN]
[    7.532996] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input3
[    7.533074] ACPI: Sleep Button [SBTN]
[    7.533207] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input4
[    7.533277] ACPI: Power Button [PWRF]
[    7.537725] ACPI: acpi_idle registered with cpuidle
[    7.539442] Monitor-Mwait will be used to enter C-1 state
[    7.539479] Monitor-Mwait will be used to enter C-2 state
[    7.539500] Monitor-Mwait will be used to enter C-3 state
[    7.546272] wmi: Mapper loaded
[    7.555015] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[    7.556806] parport_pc 00:08: [io  0x0378-0x037b]
[    7.556870] parport_pc 00:08: [irq 5]
[    7.559425] input: PC Speaker as /devices/platform/pcspkr/input/input5
[    7.631329] i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    7.841317] parport_pc 00:08: activated
[    7.841406] parport_pc 00:08: reported by Plug and Play ACPI
[    7.841912] parport_pc 00:08: disabled
[    7.844749] ACPI: Battery Slot [BAT0] (battery present)
[    8.019576] ACPI: Battery Slot [BAT1] (battery absent)
[    8.024111] ACPI: Battery Slot [BAT2] (battery absent)
[    8.025219] ACPI: AC Adapter [AC] (on-line)
[    8.034817] input: Dell WMI hotkeys as /devices/virtual/input/input6
[    8.139121] [drm] Initialized drm 1.1.0 20060810
[    8.144507] cfg80211: Calling CRDA to update world regulatory domain
[    8.227526] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    8.227677] HDA Intel 0000:00:1b.0: irq 45 for MSI/MSI-X
[    8.227705] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    8.275963] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input7
[    8.276261] hda_codec: connection list not available for 0xf
[    8.283263] input: HDA Intel PCH Mic at Sep Left Jack as /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
[    8.283401] input: HDA Intel PCH Mic at Ext Left Jack as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
[    8.283527] input: HDA Intel PCH Line Out at Sep Left Jack as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
[    8.283653] input: HDA Intel PCH HP Out at Ext Left Jack as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
[    8.284240] HDA Intel 0000:01:00.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    8.284245] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    8.284251] i915 0000:00:02.0: setting latency timer to 64
[    8.284370] hda_intel: Disabling MSI
[    8.284493] HDA Intel 0000:01:00.1: setting latency timer to 64
[    8.305552] brcmutil: module is from the staging directory, the quality is unknown, you have been warned.
[    8.864654] i915 0000:00:02.0: irq 46 for MSI/MSI-X
[    8.864660] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    8.864718] [drm] Driver supports precise vblank timestamp query.
[    8.864986] [drm:intel_dsm_platform_mux_info] *ERROR* MUX INFO call failed
[    8.865056] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=none:owns=io+mem
[    8.865128] vgaarb: transferring owner from PCI:0000:00:02.0 to PCI:0000:01:00.0
[    8.879931] brcmsmac: module is from the staging directory, the quality is unknown, you have been warned.
[    8.881768] brcmsmac 0000:03:00.0: bus 3 slot 0 func 0 irq 10
[    8.881849] brcmsmac 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    8.881929] brcmsmac 0000:03:00.0: setting latency timer to 64
[    9.349302] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
[    9.427770] fbcon: inteldrmfb (fb0) is primary device
[    9.541212] HDMI status: Pin=5 Presence_Detect=0 ELD_Valid=0
[    9.773124] Console: switching to colour frame buffer device 200x56
[    9.778692] fb0: inteldrmfb frame buffer device
[    9.778693] drm: registered panic notifier
[   10.276382] ACPI Exception: AE_TIME, Returned by Handler for [EmbeddedControl] (20110413/evregion-478)
[   10.276452] ACPI Error: Method parse/execution failed [\_SB_.PCI0.LPCB.ECDV.ECR1] (Node ffff880136f04fd8), AE_TIME (20110413/psparse-536)
[   10.276545] ACPI Error: Method parse/execution failed [\ECRB] (Node ffff880136f04e70), AE_TIME (20110413/psparse-536)
[   10.276624] ACPI Error: Method parse/execution failed [\ECGB] (Node ffff880136f04ba0), AE_TIME (20110413/psparse-536)
[   10.276702] ACPI Error: Method parse/execution failed [\_SB_.PCI0.VID_.LCD_._ADR] (Node ffff880136f09da8), AE_TIME (20110413/psparse-536)
[   10.847783] ACPI Exception: AE_TIME, Returned by Handler for [EmbeddedControl] (20110413/evregion-478)
[   10.847874] ACPI Error: Method parse/execution failed [\_SB_.PCI0.LPCB.ECDV.ECR1] (Node ffff880136f04fd8), AE_TIME (20110413/psparse-536)
[   10.847966] ACPI Error: Method parse/execution failed [\ECRB] (Node ffff880136f04e70), AE_TIME (20110413/psparse-536)
[   10.848045] ACPI Error: Method parse/execution failed [\ECGB] (Node ffff880136f04ba0), AE_TIME (20110413/psparse-536)
[   10.848123] ACPI Error: Method parse/execution failed [\_SB_.PCI0.PEG0.VID_._DOD] (Node ffff880136f223d0), AE_TIME (20110413/psparse-536)
[   10.848214] ACPI Exception: AE_TIME, Evaluating _DOD (20110413/video-1148)
[   10.867748] HDMI status: Pin=6 Presence_Detect=0 ELD_Valid=0
[   10.939673] HDMI status: Pin=7 Presence_Detect=0 ELD_Valid=0
[   11.019750] input: HDA NVidia HDMI/DP as /devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input12
[   11.019872] input: HDA NVidia HDMI/DP as /devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input13
[   11.019985] input: HDA NVidia HDMI/DP as /devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input14
[   11.347227] ACPI: EC: input buffer is not empty, aborting transaction
[   11.347295] ACPI Exception: AE_TIME, Returned by Handler for [EmbeddedControl] (20110413/evregion-478)
[   11.347367] ACPI Error: Method parse/execution failed [\_SB_.PCI0.LPCB.ECDV.ECR1] (Node ffff880136f04fd8), AE_TIME (20110413/psparse-536)
[   11.347463] ACPI Error: Method parse/execution failed [\ECRB] (Node ffff880136f04e70), AE_TIME (20110413/psparse-536)
[   11.347543] ACPI Error: Method parse/execution failed [\ECGB] (Node ffff880136f04ba0), AE_TIME (20110413/psparse-536)
[   11.347622] ACPI Error: Method parse/execution failed [\_SB_.PCI0.PEG0.VID_.LCD_._ADR] (Node ffff880136f222b8), AE_TIME (20110413/psparse-536)
[   11.347718] ACPI: Can't attach device
[   11.507169] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:13/LNXVIDEO:00/input/input15
[   11.507288] ACPI: Video Device [VID] (multi-head: yes  rom: yes  post: no)
[   12.361307] input: PS/2 Generic Mouse as /devices/platform/i8042/serio1/input/input16
[   12.642367] acpi device:3f: registered as cooling_device8
[   12.718542] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:01/input/input17
[   12.720683] ACPI: Video Device [VID1] (multi-head: yes  rom: no  post: no)
[   12.781762] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[   13.298144] Adding 7811068k swap on /dev/sda5.  Priority:-1 extents:1 across:7811068k SS
[   13.311383] EXT4-fs (sda6): re-mounted. Opts: (null)
[   13.408344] EXT4-fs (sda6): re-mounted. Opts: errors=remount-ro,discard
[   13.433648] loop: module loaded
[   13.518265] usbcore: registered new interface driver usbfs
[   13.520477] usbcore: registered new interface driver hub
[   13.523056] usbcore: registered new device driver usb
[   13.532229] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   13.534195] ehci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   13.536161] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[   13.536165] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[   13.538103] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[   13.540031] ehci_hcd 0000:00:1a.0: debug port 2
[   13.545781] ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
[   13.545800] ehci_hcd 0000:00:1a.0: irq 16, io mem 0xe6e70000
[   13.560760] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[   13.562627] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[   13.564470] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   13.566270] usb usb1: Product: EHCI Host Controller
[   13.568048] usb usb1: Manufacturer: Linux 3.0.4 ehci_hcd
[   13.569851] usb usb1: SerialNumber: 0000:00:1a.0
[   13.571744] hub 1-0:1.0: USB hub found
[   13.573530] hub 1-0:1.0: 2 ports detected
[   13.573601] ehci_hcd 0000:00:1d.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   13.573636] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[   13.573639] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[   13.573646] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[   13.573672] ehci_hcd 0000:00:1d.0: debug port 2
[   13.577546] ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
[   13.577558] ehci_hcd 0000:00:1d.0: irq 17, io mem 0xe6e50000
[   13.588725] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[   13.590588] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[   13.592611] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   13.594596] usb usb2: Product: EHCI Host Controller
[   13.596995] usb usb2: Manufacturer: Linux 3.0.4 ehci_hcd
[   13.599107] usb usb2: SerialNumber: 0000:00:1d.0
[   13.600847] hub 2-0:1.0: USB hub found
[   13.602614] hub 2-0:1.0: 2 ports detected
[   13.608112] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[   13.620414] coretemp coretemp.0: TjMax is 100 C.
[   13.621972] coretemp coretemp.0: TjMax is 100 C.
[   13.621984] coretemp coretemp.0: TjMax is 100 C.
[   13.622025] coretemp coretemp.0: TjMax is 100 C.
[   13.888442] usb 1-1: new high speed USB device number 2 using ehci_hcd
[   13.913918] EXT4-fs (sda9): mounted filesystem with ordered data mode. Opts: discard
[   13.932802] FAT-fs (sda1): utf8 is not a recommended IO charset for FAT filesystems, filesystem will be case sensitive!
[   13.932804] 
[   13.979685] fuse init (API version 7.16)
[   14.020715] usb 1-1: New USB device found, idVendor=8087, idProduct=0024
[   14.022076] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[   14.023591] hub 1-1:1.0: USB hub found
[   14.025052] hub 1-1:1.0: 6 ports detected
[   14.140132] usb 2-1: new high speed USB device number 2 using ehci_hcd
[   14.272385] usb 2-1: New USB device found, idVendor=8087, idProduct=0024
[   14.273821] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[   14.275573] hub 2-1:1.0: USB hub found
[   14.277119] hub 2-1:1.0: 8 ports detected
[   14.356106] usb 1-1.1: new high speed USB device number 3 using ehci_hcd
[   14.448210] usb 1-1.1: New USB device found, idVendor=413c, idProduct=2513
[   14.448213] usb 1-1.1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[   14.448505] hub 1-1.1:1.0: USB hub found
[   14.448554] hub 1-1.1:1.0: 3 ports detected
[   14.523922] usb 1-1.2: new high speed USB device number 4 using ehci_hcd
[   14.628293] usb 1-1.2: New USB device found, idVendor=413c, idProduct=2513
[   14.629971] usb 1-1.2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[   14.632407] hub 1-1.2:1.0: USB hub found
[   14.634727] hub 1-1.2:1.0: 3 ports detected
[   14.715671] usb 1-1.4: new full speed USB device number 5 using ehci_hcd
[   14.811684] usb 1-1.4: New USB device found, idVendor=413c, idProduct=8187
[   14.813341] usb 1-1.4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[   14.814987] usb 1-1.4: Product: DW375 Bluetooth Module
[   14.816657] usb 1-1.4: Manufacturer: Dell Computer Corp
[   14.818277] usb 1-1.4: SerialNumber: D0DF9A3D158D
[   14.891471] usb 2-1.6: new high speed USB device number 3 using ehci_hcd
[   14.993458] usb 2-1.6: New USB device found, idVendor=413c, idProduct=818d
[   14.995071] usb 2-1.6: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[   14.996688] usb 2-1.6: Product: DW5550
[   14.998302] usb 2-1.6: Manufacturer: Dell
[   14.999904] usb 2-1.6: SerialNumber: 5B698558903EF940
[   15.107244] usb 2-1.8: new full speed USB device number 4 using ehci_hcd
[   15.233960] usb 2-1.8: New USB device found, idVendor=0a5c, idProduct=5800
[   15.236165] usb 2-1.8: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[   15.238317] usb 2-1.8: Product: 5880
[   15.240469] usb 2-1.8: Manufacturer: Broadcom Corp
[   15.242623] usb 2-1.8: SerialNumber: 0123456789ABCD
[   15.244830] usb 2-1.8: config 0 descriptor??
[   15.274773] cdc_acm 2-1.6:1.1: ttyACM0: USB ACM device
[   15.277790] cdc_wdm 2-1.6:1.5: cdc-wdm-176: USB WDM device
[   15.279952] cdc_wdm 2-1.6:1.8: cdc-wdm-175: USB WDM device
[   15.282021] usbcore: registered new interface driver cdc_wdm
[   15.282078] cdc_acm 2-1.6:1.3: ttyACM1: USB ACM device
[   15.282510] cdc_acm 2-1.6:1.9: ttyACM2: USB ACM device
[   15.290617] usbcore: registered new interface driver cdc_acm
[   15.292706] cdc_acm: USB Abstract Control Model driver for USB modems and ISDN adapters
[   15.295200] cdc_ncm: 01-June-2011
[   15.315005] usb 2-1.6: MAC-Address: 0x02:0x80:0x37:0xec:0x02:0x00
[   15.317381] cdc_ncm 2-1.6:1.6: usb0: register 'cdc_ncm' at usb-0000:00:1d.0-1.6, CDC NCM, 02:80:37:ec:02:00
[   15.317404] usbcore: registered new interface driver cdc_ncm
[   15.331036] usb 1-1.2.1: new low speed USB device number 6 using ehci_hcd
[   15.450827] usb 1-1.2.1: New USB device found, idVendor=413c, idProduct=3012
[   15.454105] usb 1-1.2.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   15.456739] usb 1-1.2.1: Product: Dell USB Optical Mouse
[   15.459223] usb 1-1.2.1: Manufacturer: Dell
[   15.474521] vboxdrv: Found 8 processor cores.
[   15.474813] vboxdrv: fAsync=0 offMin=0x206 offMax=0x176c
[   15.478203] vboxdrv: TSC mode is 'synchronous', kernel timer mode is 'normal'.
[   15.478206] vboxdrv: Successfully loaded version 4.1.0_Debian (interface 0x00190000).
[   15.493323] vboxpci: IOMMU not found (not registered)
[   15.534803] usb 1-1.2.2: new low speed USB device number 7 using ehci_hcd
[   15.582775] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[   15.638584] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[   15.638954] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   15.648482] usb 1-1.2.2: New USB device found, idVendor=413c, idProduct=2003
[   15.651120] usb 1-1.2.2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   15.651122] usb 1-1.2.2: Product: Dell USB Keyboard
[   15.651124] usb 1-1.2.2: Manufacturer: Dell
[   15.679533] input: Dell Dell USB Optical Mouse as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.2/1-1.2.1/1-1.2.1:1.0/input/input18
[   15.685480] generic-usb 0003:413C:3012.0001: input,hidraw0: USB HID v1.11 Mouse [Dell Dell USB Optical Mouse] on usb-0000:00:1a.0-1.2.1/input0
[   15.695290] input: Dell Dell USB Keyboard as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.2/1-1.2.2/1-1.2.2:1.0/input/input19
[   15.698723] generic-usb 0003:413C:2003.0002: input,hidraw1: USB HID v1.10 Keyboard [Dell Dell USB Keyboard] on usb-0000:00:1a.0-1.2.2/input0
[   15.705397] usbcore: registered new interface driver usbhid
[   15.708806] usbhid: USB HID core driver
[   16.433502] input: ACPI Virtual Keyboard Device as /devices/virtual/input/input20
[   19.210764] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: None
[   19.216556] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   25.277171] [drm] Changing LVDS panel from (+hsync, -vsync) to (-hsync, +vsync)
[   27.815828] ip_tables: (C) 2000-2006 Netfilter Core Team
[   27.851787] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   28.493738] [drm] Changing LVDS panel from (-hsync, +vsync) to (+hsync, -vsync)
[   29.967183] eth0: no IPv6 routers present

--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="Xorg.0.log.bad"
Content-Transfer-Encoding: 8bit

[    20.957] 
X.Org X Server 1.10.4
Release Date: 2011-08-19
[    20.961] X Protocol Version 11, Revision 0
[    20.962] Build Operating System: Linux 3.0.0-1-amd64 x86_64 Debian
[    20.964] Current Operating System: Linux type 3.1.0-rc6 #1 SMP Wed Sep 14 19:23:48 CEST 2011 x86_64
[    20.966] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.1.0-rc6 root=UUID=38e6e493-2f5f-4a98-b1d6-a9434f0683cc ro i915.i915_enable-fbc=0
[    20.967] Build Date: 24 August 2011  08:53:55AM
[    20.969] xorg-server 2:1.10.4-1 (Cyril Brulebois <kibi@debian.org>) 
[    20.971] Current version of pixman: 0.22.2
[    20.973] 	Before reporting problems, check http://wiki.x.org
	to make sure that you have the latest version.
[    20.976] Markers: (--) probed, (**) from config file, (==) default setting,
	(++) from command line, (!!) notice, (II) informational,
	(WW) warning, (EE) error, (NI) not implemented, (??) unknown.
[    20.982] (==) Log file: "/var/log/Xorg.0.log", Time: Thu Sep 15 10:02:14 2011
[    20.997] (==) Using config file: "/etc/X11/xorg.conf"
[    20.999] (==) Using system config directory "/usr/share/X11/xorg.conf.d"
[    21.003] (==) No Layout section.  Using the first Screen section.
[    21.003] (==) No screen section available. Using defaults.
[    21.003] (**) |-->Screen "Default Screen Section" (0)
[    21.003] (**) |   |-->Monitor "<default monitor>"
[    21.005] (==) No device specified for screen "Default Screen Section".
	Using the first device section listed.
[    21.005] (**) |   |-->Device "Configured Video Device"
[    21.005] (==) No monitor specified for screen "Default Screen Section".
	Using a default monitor configuration.
[    21.005] (==) Automatically adding devices
[    21.005] (==) Automatically enabling devices
[    21.007] (==) FontPath set to:
	/usr/share/fonts/X11/misc,
	/usr/share/fonts/X11/cyrillic,
	/usr/share/fonts/X11/100dpi/:unscaled,
	/usr/share/fonts/X11/75dpi/:unscaled,
	/usr/share/fonts/X11/Type1,
	/usr/share/fonts/X11/100dpi,
	/usr/share/fonts/X11/75dpi,
	/var/lib/defoma/x-ttcidfont-conf.d/dirs/TrueType,
	built-ins
[    21.007] (==) ModulePath set to "/usr/lib/xorg/modules"
[    21.007] (==) |-->Input Device "Configured Mouse"
[    21.007] (==) No Layout section. Using the first core pointer device.
[    21.007] (II) The server relies on udev to provide the list of input devices.
	If no devices become available, reconfigure udev or disable AutoAddDevices.
[    21.007] (WW) Hotplugging is on, devices using drivers 'kbd', 'mouse' or 'vmmouse' will be disabled.
[    21.007] (WW) Disabling Configured Mouse
[    21.007] (II) Loader magic: 0x7d8500
[    21.007] (II) Module ABI versions:
[    21.007] 	X.Org ANSI C Emulation: 0.4
[    21.007] 	X.Org Video Driver: 10.0
[    21.007] 	X.Org XInput driver : 12.2
[    21.007] 	X.Org Server Extension : 5.0
[    21.008] (--) PCI:*(0:0:2:0) 8086:0126:1028:0493 rev 9, Mem @ 0xe5400000/4194304, 0xc0000000/268435456, I/O @ 0x00005000/64
[    21.008] (--) PCI: (0:1:0:0) 10de:1056:1028:1493 rev 161, Mem @ 0xe4000000/16777216, 0xd0000000/268435456, 0xe0000000/33554432, I/O @ 0x00004000/128, BIOS @ 0x????????/524288
[    21.008] (II) Open ACPI successful (/var/run/acpid.socket)
[    21.008] (II) LoadModule: "extmod"
[    21.012] (II) Loading /usr/lib/xorg/modules/extensions/libextmod.so
[    21.014] (II) Module extmod: vendor="X.Org Foundation"
[    21.014] 	compiled for 1.10.4, module version = 1.0.0
[    21.014] 	Module class: X.Org Server Extension
[    21.014] 	ABI class: X.Org Server Extension, version 5.0
[    21.014] (II) Loading extension SELinux
[    21.014] (II) Loading extension MIT-SCREEN-SAVER
[    21.014] (II) Loading extension XFree86-VidModeExtension
[    21.014] (II) Loading extension XFree86-DGA
[    21.014] (II) Loading extension DPMS
[    21.014] (II) Loading extension XVideo
[    21.014] (II) Loading extension XVideo-MotionCompensation
[    21.014] (II) Loading extension X-Resource
[    21.014] (II) LoadModule: "dbe"
[    21.014] (II) Loading /usr/lib/xorg/modules/extensions/libdbe.so
[    21.015] (II) Module dbe: vendor="X.Org Foundation"
[    21.015] 	compiled for 1.10.4, module version = 1.0.0
[    21.015] 	Module class: X.Org Server Extension
[    21.015] 	ABI class: X.Org Server Extension, version 5.0
[    21.015] (II) Loading extension DOUBLE-BUFFER
[    21.015] (II) LoadModule: "glx"
[    21.015] (II) Loading /usr/lib/xorg/modules/extensions/libglx.so
[    21.018] (II) Module glx: vendor="X.Org Foundation"
[    21.018] 	compiled for 1.10.4, module version = 1.0.0
[    21.018] 	ABI class: X.Org Server Extension, version 5.0
[    21.018] (==) AIGLX enabled
[    21.018] (II) Loading extension GLX
[    21.019] (II) LoadModule: "record"
[    21.019] (II) Loading /usr/lib/xorg/modules/extensions/librecord.so
[    21.020] (II) Module record: vendor="X.Org Foundation"
[    21.020] 	compiled for 1.10.4, module version = 1.13.0
[    21.020] 	Module class: X.Org Server Extension
[    21.020] 	ABI class: X.Org Server Extension, version 5.0
[    21.020] (II) Loading extension RECORD
[    21.020] (II) LoadModule: "dri"
[    21.020] (II) Loading /usr/lib/xorg/modules/extensions/libdri.so
[    21.022] (II) Module dri: vendor="X.Org Foundation"
[    21.022] 	compiled for 1.10.4, module version = 1.0.0
[    21.022] 	ABI class: X.Org Server Extension, version 5.0
[    21.022] (II) Loading extension XFree86-DRI
[    21.022] (II) LoadModule: "dri2"
[    21.022] (II) Loading /usr/lib/xorg/modules/extensions/libdri2.so
[    21.023] (II) Module dri2: vendor="X.Org Foundation"
[    21.023] 	compiled for 1.10.4, module version = 1.2.0
[    21.023] 	ABI class: X.Org Server Extension, version 5.0
[    21.023] (II) Loading extension DRI2
[    21.023] (==) Matched intel as autoconfigured driver 0
[    21.023] (==) Matched vesa as autoconfigured driver 1
[    21.023] (==) Matched fbdev as autoconfigured driver 2
[    21.023] (==) Assigned the driver to the xf86ConfigLayout
[    21.023] (II) LoadModule: "intel"
[    21.024] (II) Loading /usr/lib/xorg/modules/drivers/intel_drv.so
[    21.028] (II) Module intel: vendor="X.Org Foundation"
[    21.028] 	compiled for 1.10.1, module version = 2.15.0
[    21.028] 	Module class: X.Org Video Driver
[    21.028] 	ABI class: X.Org Video Driver, version 10.0
[    21.028] (II) LoadModule: "vesa"
[    21.028] (II) Loading /usr/lib/xorg/modules/drivers/vesa_drv.so
[    21.029] (II) Module vesa: vendor="X.Org Foundation"
[    21.029] 	compiled for 1.10.2, module version = 2.3.0
[    21.029] 	Module class: X.Org Video Driver
[    21.029] 	ABI class: X.Org Video Driver, version 10.0
[    21.029] (II) LoadModule: "fbdev"
[    21.030] (II) Loading /usr/lib/xorg/modules/drivers/fbdev_drv.so
[    21.031] (II) Module fbdev: vendor="X.Org Foundation"
[    21.031] 	compiled for 1.10.1, module version = 0.4.2
[    21.031] 	ABI class: X.Org Video Driver, version 10.0
[    21.031] (II) intel: Driver for Intel Integrated Graphics Chipsets: i810,
	i810-dc100, i810e, i815, i830M, 845G, 854, 852GM/855GM, 865G, 915G,
	E7221 (i915), 915GM, 945G, 945GM, 945GME, Pineview GM, Pineview G,
	965G, G35, 965Q, 946GZ, 965GM, 965GME/GLE, G33, Q35, Q33, GM45,
	4 Series, G45/G43, Q45/Q43, G41, B43, B43, Clarkdale, Arrandale,
	Sandybridge, Sandybridge, Sandybridge, Sandybridge, Sandybridge,
	Sandybridge, Sandybridge
[    21.031] (II) VESA: driver for VESA chipsets: vesa
[    21.031] (II) FBDEV: driver for framebuffer: fbdev
[    21.031] (--) using VT number 7

[    21.042] (II) Loading /usr/lib/xorg/modules/drivers/intel_drv.so
[    21.042] (WW) Falling back to old probe method for vesa
[    21.042] (WW) Falling back to old probe method for fbdev
[    21.042] (II) Loading sub module "fbdevhw"
[    21.042] (II) LoadModule: "fbdevhw"
[    21.042] (II) Loading /usr/lib/xorg/modules/libfbdevhw.so
[    21.043] (II) Module fbdevhw: vendor="X.Org Foundation"
[    21.043] 	compiled for 1.10.4, module version = 0.0.2
[    21.043] 	ABI class: X.Org Video Driver, version 10.0
[    21.043] drmOpenDevice: node name is /dev/dri/card0
[    21.043] drmOpenDevice: open result is 11, (OK)
[    21.043] drmOpenByBusid: Searching for BusID pci:0000:00:02.0
[    21.043] drmOpenDevice: node name is /dev/dri/card0
[    21.043] drmOpenDevice: open result is 11, (OK)
[    21.043] drmOpenByBusid: drmOpenMinor returns 11
[    21.043] drmOpenByBusid: drmGetBusid reports pci:0000:00:02.0
[    21.043] (II) intel(0): Creating default Display subsection in Screen section
	"Default Screen Section" for depth/fbbpp 24/32
[    21.043] (==) intel(0): Depth 24, (--) framebuffer bpp 32
[    21.043] (==) intel(0): RGB weight 888
[    21.043] (==) intel(0): Default visual is TrueColor
[    21.043] (II) intel(0): Integrated Graphics Chipset: Intel(R) Sandybridge
[    21.043] (--) intel(0): Chipset: "Sandybridge"
[    21.043] (**) intel(0): Relaxed fencing enabled
[    21.043] (**) intel(0): Framebuffer tiled
[    21.043] (**) intel(0): Pixmaps tiled
[    21.043] (**) intel(0): 3D buffers tiled
[    21.044] (**) intel(0): SwapBuffers wait disabled
[    21.044] (==) intel(0): video overlay key set to 0x101fe
[    21.044] (II) intel(0): Output LVDS1 has no monitor section
[    21.045] (II) intel(0): found backlight control interface /sys/class/backlight/intel_backlight
[    21.109] (II) intel(0): Output VGA1 has no monitor section
[    21.109] (II) intel(0): EDID for output LVDS1
[    21.109] (II) intel(0): Manufacturer: SEC  Model: 544b  Serial#: 0
[    21.109] (II) intel(0): Year: 2010  Week: 0
[    21.109] (II) intel(0): EDID Version: 1.4
[    21.109] (II) intel(0): Digital Display Input
[    21.109] (II) intel(0): 6 bits per channel
[    21.109] (II) intel(0): Digital interface is undefined
[    21.109] (II) intel(0): Max Image Size [cm]: horiz.: 31  vert.: 17
[    21.109] (II) intel(0): Gamma: 2.20
[    21.109] (II) intel(0): No DPMS capabilities specified
[    21.109] (II) intel(0): Supported color encodings: RGB 4:4:4 YCrCb 4:4:4 
[    21.109] (II) intel(0): First detailed timing is preferred mode
[    21.109] (II) intel(0): Preferred mode is native pixel format and refresh rate
[    21.109] (II) intel(0): redX: 0.610 redY: 0.340   greenX: 0.330 greenY: 0.550
[    21.109] (II) intel(0): blueX: 0.155 blueY: 0.090   whiteX: 0.313 whiteY: 0.329
[    21.109] (II) intel(0): Manufacturer's mask: 0
[    21.109] (II) intel(0): Supported detailed timing:
[    21.109] (II) intel(0): clock: 114.1 MHz   Image Size:  310 x 174 mm
[    21.109] (II) intel(0): h_active: 1600  h_sync: 1648  h_sync_end 1680 h_blank_end 2044 h_border: 0
[    21.109] (II) intel(0): v_active: 900  v_sync: 902  v_sync_end 907 v_blanking: 930 v_border: 0
[    21.109] (II) intel(0): Supported detailed timing:
[    21.109] (II) intel(0): clock: 74.1 MHz   Image Size:  310 x 174 mm
[    21.109] (II) intel(0): h_active: 1600  h_sync: 1648  h_sync_end 1680 h_blank_end 1992 h_border: 0
[    21.109] (II) intel(0): v_active: 900  v_sync: 902  v_sync_end 907 v_blanking: 930 v_border: 0
[    21.109] (II) intel(0):  MJ154€140KT
[    21.109] (II) intel(0): Unknown vendor-specific block 0
[    21.109] (II) intel(0): EDID (in hex):
[    21.109] (II) intel(0): 	00ffffffffffff004ca34b5400000000
[    21.109] (II) intel(0): 	00140104901f11780a4bc59c57548c27
[    21.109] (II) intel(0): 	17505400000001010101010101010101
[    21.109] (II) intel(0): 	0101010101018e2c40bc61841e303020
[    21.109] (II) intel(0): 	250036ae1000001af11c408861841e30
[    21.109] (II) intel(0): 	3020250036ae1000001a000000fe004d
[    21.109] (II) intel(0): 	4a313534803134304b540a2000000000
[    21.109] (II) intel(0): 	00004101980000000002010a2020001d
[    21.109] (II) intel(0): EDID vendor "SEC", prod id 21579
[    21.109] (II) intel(0): Printing DDC gathered Modelines:
[    21.109] (II) intel(0): Modeline "1600x900"x0.0  114.06  1600 1648 1680 2044  900 902 907 930 +hsync -vsync (55.8 kHz)
[    21.109] (II) intel(0): Modeline "1600x900"x0.0   74.09  1600 1648 1680 1992  900 902 907 930 +hsync -vsync (37.2 kHz)
[    21.109] (II) intel(0): Not using default mode "320x240" (doublescan mode not supported)
[    21.109] (II) intel(0): Not using default mode "400x300" (doublescan mode not supported)
[    21.109] (II) intel(0): Not using default mode "400x300" (doublescan mode not supported)
[    21.109] (II) intel(0): Not using default mode "512x384" (doublescan mode not supported)
[    21.109] (II) intel(0): Not using default mode "640x480" (doublescan mode not supported)
[    21.109] (II) intel(0): Not using default mode "640x512" (doublescan mode not supported)
[    21.109] (II) intel(0): Not using default mode "800x600" (doublescan mode not supported)
[    21.109] (II) intel(0): Not using default mode "896x672" (doublescan mode not supported)
[    21.109] (II) intel(0): Not using default mode "928x696" (doublescan mode not supported)
[    21.109] (II) intel(0): Not using default mode "960x720" (doublescan mode not supported)
[    21.109] (II) intel(0): Not using default mode "576x432" (doublescan mode not supported)
[    21.109] (II) intel(0): Not using default mode "680x384" (doublescan mode not supported)
[    21.109] (II) intel(0): Not using default mode "680x384" (doublescan mode not supported)
[    21.109] (II) intel(0): Not using default mode "700x525" (doublescan mode not supported)
[    21.109] (II) intel(0): Not using default mode "720x450" (doublescan mode not supported)
[    21.109] (II) intel(0): Not using default mode "800x512" (doublescan mode not supported)
[    21.109] (II) intel(0): Not using default mode "840x525" (doublescan mode not supported)
[    21.109] (II) intel(0): Not using default mode "840x525" (doublescan mode not supported)
[    21.109] (II) intel(0): Not using default mode "960x540" (doublescan mode not supported)
[    21.109] (II) intel(0): Not using default mode "960x600" (doublescan mode not supported)
[    21.109] (II) intel(0): Not using default mode "1024x768" (doublescan mode not supported)
[    21.109] (II) intel(0): Printing probed modes for output LVDS1
[    21.109] (II) intel(0): Modeline "1600x900"x60.0  114.06  1600 1648 1680 2044  900 902 907 930 +hsync -vsync (55.8 kHz)
[    21.109] (II) intel(0): Modeline "1600x900"x40.0   74.09  1600 1648 1680 1992  900 902 907 930 +hsync -vsync (37.2 kHz)
[    21.109] (II) intel(0): Modeline "1440x900"x59.9  106.50  1440 1520 1672 1904  900 903 909 934 -hsync +vsync (55.9 kHz)
[    21.109] (II) intel(0): Modeline "1360x768"x59.8   84.75  1360 1432 1568 1776  768 771 781 798 -hsync +vsync (47.7 kHz)
[    21.109] (II) intel(0): Modeline "1360x768"x60.0   72.00  1360 1408 1440 1520  768 771 781 790 +hsync -vsync (47.4 kHz)
[    21.109] (II) intel(0): Modeline "1152x864"x60.0   81.62  1152 1216 1336 1520  864 865 868 895 -hsync +vsync (53.7 kHz)
[    21.109] (II) intel(0): Modeline "1024x768"x60.0   65.00  1024 1048 1184 1344  768 771 777 806 -hsync -vsync (48.4 kHz)
[    21.109] (II) intel(0): Modeline "800x600"x60.3   40.00  800 840 968 1056  600 601 605 628 +hsync +vsync (37.9 kHz)
[    21.109] (II) intel(0): Modeline "800x600"x56.2   36.00  800 824 896 1024  600 601 603 625 +hsync +vsync (35.2 kHz)
[    21.109] (II) intel(0): Modeline "640x480"x59.9   25.18  640 656 752 800  480 490 492 525 -hsync -vsync (31.5 kHz)
[    21.171] (II) intel(0): EDID for output VGA1
[    21.171] (II) intel(0): Manufacturer: DEL  Model: a020  Serial#: 960974412
[    21.171] (II) intel(0): Year: 2008  Week: 21
[    21.171] (II) intel(0): EDID Version: 1.3
[    21.171] (II) intel(0): Analog Display Input,  Input Voltage Level: 0.700/0.300 V
[    21.171] (II) intel(0): Sync:  Separate  Composite  SyncOnGreen
[    21.171] (II) intel(0): Max Image Size [cm]: horiz.: 41  vert.: 31
[    21.171] (II) intel(0): Gamma: 2.20
[    21.171] (II) intel(0): DPMS capabilities: StandBy Suspend Off; RGB/Color Display
[    21.171] (II) intel(0): Default color space is primary color space
[    21.171] (II) intel(0): First detailed timing is preferred mode
[    21.171] (II) intel(0): redX: 0.640 redY: 0.330   greenX: 0.300 greenY: 0.600
[    21.171] (II) intel(0): blueX: 0.150 blueY: 0.060   whiteX: 0.312 whiteY: 0.329
[    21.171] (II) intel(0): Supported established timings:
[    21.171] (II) intel(0): 720x400@70Hz
[    21.171] (II) intel(0): 640x480@60Hz
[    21.171] (II) intel(0): 640x480@75Hz
[    21.171] (II) intel(0): 800x600@60Hz
[    21.171] (II) intel(0): 800x600@75Hz
[    21.171] (II) intel(0): 1024x768@60Hz
[    21.171] (II) intel(0): 1024x768@75Hz
[    21.171] (II) intel(0): 1280x1024@75Hz
[    21.171] (II) intel(0): Manufacturer's mask: 0
[    21.171] (II) intel(0): Supported standard timings:
[    21.171] (II) intel(0): #0: hsize: 1280  vsize 1024  refresh: 60  vid: 32897
[    21.171] (II) intel(0): #1: hsize: 1600  vsize 1200  refresh: 60  vid: 16553
[    21.171] (II) intel(0): #2: hsize: 1152  vsize 864  refresh: 75  vid: 20337
[    21.171] (II) intel(0): Supported detailed timing:
[    21.171] (II) intel(0): clock: 162.0 MHz   Image Size:  367 x 275 mm
[    21.171] (II) intel(0): h_active: 1600  h_sync: 1664  h_sync_end 1856 h_blank_end 2160 h_border: 0
[    21.171] (II) intel(0): v_active: 1200  v_sync: 1201  v_sync_end 1204 v_blanking: 1250 v_border: 0
[    21.171] (II) intel(0): Serial No: MY54685J9GNL
[    21.171] (II) intel(0): Monitor name: DELL 2007FP
[    21.171] (II) intel(0): Ranges: V min: 56 V max: 76 Hz, H min: 30 H max: 83 kHz, PixClock max 175 MHz
[    21.171] (II) intel(0): EDID (in hex):
[    21.171] (II) intel(0): 	00ffffffffffff0010ac20a04c4e4739
[    21.171] (II) intel(0): 	151201030e291f78eeee91a3544c9926
[    21.171] (II) intel(0): 	0f5054a54b008180a940714f01010101
[    21.171] (II) intel(0): 	010101010101483f403062b0324040c0
[    21.171] (II) intel(0): 	13006f131100001e000000ff004d5935
[    21.171] (II) intel(0): 	343638354a39474e4c0a000000fc0044
[    21.171] (II) intel(0): 	454c4c203230303746500a20000000fd
[    21.171] (II) intel(0): 	00384c1e5311000a20202020202000c0
[    21.171] (II) intel(0): Printing probed modes for output VGA1
[    21.171] (II) intel(0): Modeline "1600x1200"x60.0  162.00  1600 1664 1856 2160  1200 1201 1204 1250 +hsync +vsync (75.0 kHz)
[    21.171] (II) intel(0): Modeline "1280x1024"x75.0  135.00  1280 1296 1440 1688  1024 1025 1028 1066 +hsync +vsync (80.0 kHz)
[    21.171] (II) intel(0): Modeline "1280x1024"x60.0  108.00  1280 1328 1440 1688  1024 1025 1028 1066 +hsync +vsync (64.0 kHz)
[    21.171] (II) intel(0): Modeline "1152x864"x75.0  108.00  1152 1216 1344 1600  864 865 868 900 +hsync +vsync (67.5 kHz)
[    21.171] (II) intel(0): Modeline "1024x768"x75.1   78.80  1024 1040 1136 1312  768 769 772 800 +hsync +vsync (60.1 kHz)
[    21.171] (II) intel(0): Modeline "1024x768"x60.0   65.00  1024 1048 1184 1344  768 771 777 806 -hsync -vsync (48.4 kHz)
[    21.171] (II) intel(0): Modeline "800x600"x75.0   49.50  800 816 896 1056  600 601 604 625 +hsync +vsync (46.9 kHz)
[    21.171] (II) intel(0): Modeline "800x600"x60.3   40.00  800 840 968 1056  600 601 605 628 +hsync +vsync (37.9 kHz)
[    21.171] (II) intel(0): Modeline "640x480"x75.0   31.50  640 656 720 840  480 481 484 500 -hsync -vsync (37.5 kHz)
[    21.172] (II) intel(0): Modeline "640x480"x60.0   25.20  640 656 752 800  480 490 492 525 -hsync -vsync (31.5 kHz)
[    21.172] (II) intel(0): Modeline "720x400"x70.1   28.32  720 738 846 900  400 412 414 449 -hsync +vsync (31.5 kHz)
[    21.172] (II) intel(0): Output LVDS1 connected
[    21.172] (II) intel(0): Output VGA1 connected
[    21.172] (II) intel(0): Using fuzzy aspect match for initial modes
[    21.172] (II) intel(0): Output LVDS1 using initial mode 1152x864
[    21.172] (II) intel(0): Output VGA1 using initial mode 1152x864
[    21.172] (II) intel(0): Using default gamma of (1.0, 1.0, 1.0) unless otherwise stated.
[    21.172] (II) intel(0): Kernel page flipping support detected, enabling
[    21.172] (**) intel(0): Display dimensions: (310, 170) mm
[    21.172] (**) intel(0): DPI set to (94, 129)
[    21.172] (II) Loading sub module "fb"
[    21.172] (II) LoadModule: "fb"
[    21.172] (II) Loading /usr/lib/xorg/modules/libfb.so
[    21.174] (II) Module fb: vendor="X.Org Foundation"
[    21.174] 	compiled for 1.10.4, module version = 1.0.0
[    21.174] 	ABI class: X.Org ANSI C Emulation, version 0.4
[    21.174] (II) Loading sub module "dri2"
[    21.174] (II) LoadModule: "dri2"
[    21.174] (II) Loading /usr/lib/xorg/modules/extensions/libdri2.so
[    21.174] (II) Module dri2: vendor="X.Org Foundation"
[    21.174] 	compiled for 1.10.4, module version = 1.2.0
[    21.174] 	ABI class: X.Org Server Extension, version 5.0
[    21.174] (II) UnloadModule: "vesa"
[    21.174] (II) Unloading vesa
[    21.174] (II) UnloadModule: "fbdev"
[    21.174] (II) Unloading fbdev
[    21.174] (II) UnloadModule: "fbdevhw"
[    21.174] (II) Unloading fbdevhw
[    21.174] (==) Depth 24 pixmap format is 32 bpp
[    21.174] (II) intel(0): [DRI2] Setup complete
[    21.174] (II) intel(0): [DRI2]   DRI driver: i965
[    21.174] (II) intel(0): Allocated new frame buffer 1152x864 stride 4608, tiled
[    21.177] (II) UXA(0): Driver registered support for the following operations:
[    21.177] (II)         solid
[    21.177] (II)         copy
[    21.177] (II)         composite (RENDER acceleration)
[    21.177] (II)         put_image
[    21.177] (II)         get_image
[    21.177] (==) intel(0): Backing store disabled
[    21.177] (==) intel(0): Silken mouse enabled
[    21.178] (II) intel(0): Initializing HW Cursor
[    21.810] (II) intel(0): RandR 1.2 enabled, ignore the following RandR disabled message.
[    21.811] (==) intel(0): DPMS enabled
[    21.811] (II) intel(0): Set up textured video
[    21.811] (II) intel(0): direct rendering: DRI2 Enabled
[    21.811] (==) intel(0): hotplug detection: "enabled"
[    21.811] (--) RandR disabled
[    21.811] (II) Initializing built-in extension Generic Event Extension
[    21.811] (II) Initializing built-in extension SHAPE
[    21.811] (II) Initializing built-in extension MIT-SHM
[    21.811] (II) Initializing built-in extension XInputExtension
[    21.811] (II) Initializing built-in extension XTEST
[    21.811] (II) Initializing built-in extension BIG-REQUESTS
[    21.811] (II) Initializing built-in extension SYNC
[    21.811] (II) Initializing built-in extension XKEYBOARD
[    21.811] (II) Initializing built-in extension XC-MISC
[    21.811] (II) Initializing built-in extension SECURITY
[    21.811] (II) Initializing built-in extension XINERAMA
[    21.811] (II) Initializing built-in extension XFIXES
[    21.811] (II) Initializing built-in extension RENDER
[    21.811] (II) Initializing built-in extension RANDR
[    21.811] (II) Initializing built-in extension COMPOSITE
[    21.812] (II) Initializing built-in extension DAMAGE
[    21.812] (II) SELinux: Disabled on system
[    21.841] (II) AIGLX: enabled GLX_MESA_copy_sub_buffer
[    21.841] (II) AIGLX: enabled GLX_INTEL_swap_event
[    21.841] (II) AIGLX: enabled GLX_SGI_swap_control and GLX_MESA_swap_control
[    21.841] (II) AIGLX: enabled GLX_SGI_make_current_read
[    21.841] (II) AIGLX: GLX_EXT_texture_from_pixmap backed by buffer objects
[    21.841] (II) AIGLX: Loaded and initialized /usr/lib/x86_64-linux-gnu/dri/i965_dri.so
[    21.841] (II) GLX: Initialized DRI2 GL provider for screen 0
[    21.841] (II) intel(0): Setting screen physical size to 304 x 228
[    21.984] (II) config/udev: Adding input device Power Button (/dev/input/event5)
[    21.984] (**) Power Button: Applying InputClass "evdev keyboard catchall"
[    21.984] (II) LoadModule: "evdev"
[    21.984] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    21.989] (II) Module evdev: vendor="X.Org Foundation"
[    21.989] 	compiled for 1.10.1, module version = 2.6.0
[    21.989] 	Module class: X.Org XInput Driver
[    21.989] 	ABI class: X.Org XInput driver, version 12.2
[    21.989] (II) Using input driver 'evdev' for 'Power Button'
[    21.989] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    21.989] (**) Power Button: always reports core events
[    21.989] (**) Power Button: Device: "/dev/input/event5"
[    21.989] (--) Power Button: Found keys
[    21.989] (II) Power Button: Configuring as keyboard
[    21.989] (**) Option "config_info" "udev:/sys/devices/LNXSYSTM:00/LNXPWRBN:00/input/input5/event5"
[    21.989] (II) XINPUT: Adding extended input device "Power Button" (type: KEYBOARD)
[    21.989] (**) Option "xkb_rules" "evdev"
[    21.989] (**) Option "xkb_model" "geniuskb19e"
[    21.989] (**) Option "xkb_layout" "fr,brai"
[    21.989] (**) Option "xkb_variant" "oss,"
[    21.989] (**) Option "xkb_options" "compose:lwin,compose:rwin,nbsp:level3n,grp:shift_caps_toggle,grp_led:scroll,terminate:ctrl_alt_bksp"
[    22.033] (II) config/udev: Adding input device Video Bus (/dev/input/event8)
[    22.033] (**) Video Bus: Applying InputClass "evdev keyboard catchall"
[    22.033] (II) Using input driver 'evdev' for 'Video Bus'
[    22.033] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    22.033] (**) Video Bus: always reports core events
[    22.033] (**) Video Bus: Device: "/dev/input/event8"
[    22.033] (--) Video Bus: Found keys
[    22.033] (II) Video Bus: Configuring as keyboard
[    22.033] (**) Option "config_info" "udev:/sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:01/input/input8/event8"
[    22.033] (II) XINPUT: Adding extended input device "Video Bus" (type: KEYBOARD)
[    22.033] (**) Option "xkb_rules" "evdev"
[    22.033] (**) Option "xkb_model" "geniuskb19e"
[    22.033] (**) Option "xkb_layout" "fr,brai"
[    22.033] (**) Option "xkb_variant" "oss,"
[    22.034] (**) Option "xkb_options" "compose:lwin,compose:rwin,nbsp:level3n,grp:shift_caps_toggle,grp_led:scroll,terminate:ctrl_alt_bksp"
[    22.035] (II) config/udev: Adding input device Video Bus (/dev/input/event7)
[    22.035] (**) Video Bus: Applying InputClass "evdev keyboard catchall"
[    22.035] (II) Using input driver 'evdev' for 'Video Bus'
[    22.035] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    22.035] (**) Video Bus: always reports core events
[    22.035] (**) Video Bus: Device: "/dev/input/event7"
[    22.035] (--) Video Bus: Found keys
[    22.035] (II) Video Bus: Configuring as keyboard
[    22.035] (**) Option "config_info" "udev:/sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:13/LNXVIDEO:00/input/input7/event7"
[    22.035] (II) XINPUT: Adding extended input device "Video Bus" (type: KEYBOARD)
[    22.035] (**) Option "xkb_rules" "evdev"
[    22.035] (**) Option "xkb_model" "geniuskb19e"
[    22.035] (**) Option "xkb_layout" "fr,brai"
[    22.035] (**) Option "xkb_variant" "oss,"
[    22.035] (**) Option "xkb_options" "compose:lwin,compose:rwin,nbsp:level3n,grp:shift_caps_toggle,grp_led:scroll,terminate:ctrl_alt_bksp"
[    22.039] (II) config/udev: Adding input device Power Button (/dev/input/event2)
[    22.039] (**) Power Button: Applying InputClass "evdev keyboard catchall"
[    22.039] (II) Using input driver 'evdev' for 'Power Button'
[    22.039] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    22.039] (**) Power Button: always reports core events
[    22.039] (**) Power Button: Device: "/dev/input/event2"
[    22.039] (--) Power Button: Found keys
[    22.039] (II) Power Button: Configuring as keyboard
[    22.039] (**) Option "config_info" "udev:/sys/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input2/event2"
[    22.039] (II) XINPUT: Adding extended input device "Power Button" (type: KEYBOARD)
[    22.039] (**) Option "xkb_rules" "evdev"
[    22.039] (**) Option "xkb_model" "geniuskb19e"
[    22.039] (**) Option "xkb_layout" "fr,brai"
[    22.039] (**) Option "xkb_variant" "oss,"
[    22.039] (**) Option "xkb_options" "compose:lwin,compose:rwin,nbsp:level3n,grp:shift_caps_toggle,grp_led:scroll,terminate:ctrl_alt_bksp"
[    22.039] (II) config/udev: Adding input device Lid Switch (/dev/input/event1)
[    22.039] (II) No input driver/identifier specified (ignoring)
[    22.039] (II) config/udev: Adding input device Sleep Button (/dev/input/event3)
[    22.039] (**) Sleep Button: Applying InputClass "evdev keyboard catchall"
[    22.039] (II) Using input driver 'evdev' for 'Sleep Button'
[    22.039] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    22.039] (**) Sleep Button: always reports core events
[    22.039] (**) Sleep Button: Device: "/dev/input/event3"
[    22.039] (--) Sleep Button: Found keys
[    22.039] (II) Sleep Button: Configuring as keyboard
[    22.039] (**) Option "config_info" "udev:/sys/devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input3/event3"
[    22.039] (II) XINPUT: Adding extended input device "Sleep Button" (type: KEYBOARD)
[    22.039] (**) Option "xkb_rules" "evdev"
[    22.039] (**) Option "xkb_model" "geniuskb19e"
[    22.039] (**) Option "xkb_layout" "fr,brai"
[    22.039] (**) Option "xkb_variant" "oss,"
[    22.039] (**) Option "xkb_options" "compose:lwin,compose:rwin,nbsp:level3n,grp:shift_caps_toggle,grp_led:scroll,terminate:ctrl_alt_bksp"
[    22.040] (II) config/udev: Adding input device HDA NVidia HDMI/DP (/dev/input/event15)
[    22.040] (II) No input driver/identifier specified (ignoring)
[    22.040] (II) config/udev: Adding input device HDA NVidia HDMI/DP (/dev/input/event16)
[    22.040] (II) No input driver/identifier specified (ignoring)
[    22.040] (II) config/udev: Adding input device HDA NVidia HDMI/DP (/dev/input/event17)
[    22.040] (II) No input driver/identifier specified (ignoring)
[    22.042] (II) config/udev: Adding input device Dell Dell USB Optical Mouse (/dev/input/event18)
[    22.042] (**) Dell Dell USB Optical Mouse: Applying InputClass "evdev pointer catchall"
[    22.042] (II) Using input driver 'evdev' for 'Dell Dell USB Optical Mouse'
[    22.042] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    22.042] (**) Dell Dell USB Optical Mouse: always reports core events
[    22.042] (**) Dell Dell USB Optical Mouse: Device: "/dev/input/event18"
[    22.042] (--) Dell Dell USB Optical Mouse: Found 3 mouse buttons
[    22.042] (--) Dell Dell USB Optical Mouse: Found scroll wheel(s)
[    22.042] (--) Dell Dell USB Optical Mouse: Found relative axes
[    22.042] (--) Dell Dell USB Optical Mouse: Found x and y relative axes
[    22.042] (II) Dell Dell USB Optical Mouse: Configuring as mouse
[    22.042] (II) Dell Dell USB Optical Mouse: Adding scrollwheel support
[    22.042] (**) Dell Dell USB Optical Mouse: YAxisMapping: buttons 4 and 5
[    22.042] (**) Dell Dell USB Optical Mouse: EmulateWheelButton: 4, EmulateWheelInertia: 10, EmulateWheelTimeout: 200
[    22.042] (**) Option "config_info" "udev:/sys/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.2/1-1.2.1/1-1.2.1:1.0/input/input18/event18"
[    22.042] (II) XINPUT: Adding extended input device "Dell Dell USB Optical Mouse" (type: MOUSE)
[    22.042] (II) Dell Dell USB Optical Mouse: initialized for relative axes.
[    22.042] (**) Dell Dell USB Optical Mouse: (accel) keeping acceleration scheme 1
[    22.042] (**) Dell Dell USB Optical Mouse: (accel) acceleration profile 0
[    22.042] (**) Dell Dell USB Optical Mouse: (accel) acceleration factor: 2.000
[    22.042] (**) Dell Dell USB Optical Mouse: (accel) acceleration threshold: 4
[    22.042] (II) config/udev: Adding input device Dell Dell USB Optical Mouse (/dev/input/mouse1)
[    22.042] (II) No input driver/identifier specified (ignoring)
[    22.042] (II) config/udev: Adding input device Dell Dell USB Keyboard (/dev/input/event19)
[    22.042] (**) Dell Dell USB Keyboard: Applying InputClass "evdev keyboard catchall"
[    22.042] (II) Using input driver 'evdev' for 'Dell Dell USB Keyboard'
[    22.042] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    22.042] (**) Dell Dell USB Keyboard: always reports core events
[    22.042] (**) Dell Dell USB Keyboard: Device: "/dev/input/event19"
[    22.042] (--) Dell Dell USB Keyboard: Found keys
[    22.042] (II) Dell Dell USB Keyboard: Configuring as keyboard
[    22.042] (**) Option "config_info" "udev:/sys/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.2/1-1.2.2/1-1.2.2:1.0/input/input19/event19"
[    22.042] (II) XINPUT: Adding extended input device "Dell Dell USB Keyboard" (type: KEYBOARD)
[    22.042] (**) Option "xkb_rules" "evdev"
[    22.042] (**) Option "xkb_model" "geniuskb19e"
[    22.042] (**) Option "xkb_layout" "fr,brai"
[    22.042] (**) Option "xkb_variant" "oss,"
[    22.042] (**) Option "xkb_options" "compose:lwin,compose:rwin,nbsp:level3n,grp:shift_caps_toggle,grp_led:scroll,terminate:ctrl_alt_bksp"
[    22.043] (II) config/udev: Adding input device HDA Digital PCBeep (/dev/input/event9)
[    22.043] (II) No input driver/identifier specified (ignoring)
[    22.043] (II) config/udev: Adding input device HDA Intel PCH Mic at Sep Left Jack (/dev/input/event10)
[    22.043] (II) No input driver/identifier specified (ignoring)
[    22.043] (II) config/udev: Adding input device HDA Intel PCH Mic at Ext Left Jack (/dev/input/event11)
[    22.043] (II) No input driver/identifier specified (ignoring)
[    22.043] (II) config/udev: Adding input device HDA Intel PCH Line Out at Sep Left Jack (/dev/input/event12)
[    22.043] (II) No input driver/identifier specified (ignoring)
[    22.044] (II) config/udev: Adding input device HDA Intel PCH HP Out at Ext Left Jack (/dev/input/event13)
[    22.044] (II) No input driver/identifier specified (ignoring)
[    22.047] (II) config/udev: Adding input device AT Translated Set 2 keyboard (/dev/input/event0)
[    22.047] (**) AT Translated Set 2 keyboard: Applying InputClass "evdev keyboard catchall"
[    22.047] (II) Using input driver 'evdev' for 'AT Translated Set 2 keyboard'
[    22.047] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    22.047] (**) AT Translated Set 2 keyboard: always reports core events
[    22.047] (**) AT Translated Set 2 keyboard: Device: "/dev/input/event0"
[    22.047] (--) AT Translated Set 2 keyboard: Found keys
[    22.047] (II) AT Translated Set 2 keyboard: Configuring as keyboard
[    22.047] (**) Option "config_info" "udev:/sys/devices/platform/i8042/serio0/input/input0/event0"
[    22.047] (II) XINPUT: Adding extended input device "AT Translated Set 2 keyboard" (type: KEYBOARD)
[    22.047] (**) Option "xkb_rules" "evdev"
[    22.047] (**) Option "xkb_model" "geniuskb19e"
[    22.047] (**) Option "xkb_layout" "fr,brai"
[    22.047] (**) Option "xkb_variant" "oss,"
[    22.047] (**) Option "xkb_options" "compose:lwin,compose:rwin,nbsp:level3n,grp:shift_caps_toggle,grp_led:scroll,terminate:ctrl_alt_bksp"
[    22.047] (II) config/udev: Adding input device PS/2 Generic Mouse (/dev/input/event14)
[    22.047] (**) PS/2 Generic Mouse: Applying InputClass "evdev pointer catchall"
[    22.047] (II) Using input driver 'evdev' for 'PS/2 Generic Mouse'
[    22.047] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    22.048] (**) PS/2 Generic Mouse: always reports core events
[    22.048] (**) PS/2 Generic Mouse: Device: "/dev/input/event14"
[    22.048] (--) PS/2 Generic Mouse: Found 3 mouse buttons
[    22.048] (--) PS/2 Generic Mouse: Found relative axes
[    22.048] (--) PS/2 Generic Mouse: Found x and y relative axes
[    22.048] (II) PS/2 Generic Mouse: Configuring as mouse
[    22.048] (**) PS/2 Generic Mouse: YAxisMapping: buttons 4 and 5
[    22.048] (**) PS/2 Generic Mouse: EmulateWheelButton: 4, EmulateWheelInertia: 10, EmulateWheelTimeout: 200
[    22.048] (**) Option "config_info" "udev:/sys/devices/platform/i8042/serio1/input/input14/event14"
[    22.048] (II) XINPUT: Adding extended input device "PS/2 Generic Mouse" (type: MOUSE)
[    22.048] (II) PS/2 Generic Mouse: initialized for relative axes.
[    22.048] (**) PS/2 Generic Mouse: (accel) keeping acceleration scheme 1
[    22.048] (**) PS/2 Generic Mouse: (accel) acceleration profile 0
[    22.048] (**) PS/2 Generic Mouse: (accel) acceleration factor: 2.000
[    22.048] (**) PS/2 Generic Mouse: (accel) acceleration threshold: 4
[    22.048] (II) config/udev: Adding input device PS/2 Generic Mouse (/dev/input/mouse0)
[    22.048] (II) No input driver/identifier specified (ignoring)
[    22.048] (II) config/udev: Adding input device PC Speaker (/dev/input/event4)
[    22.048] (II) No input driver/identifier specified (ignoring)
[    22.049] (II) config/udev: Adding input device ACPI Virtual Keyboard Device (/dev/input/event20)
[    22.049] (**) ACPI Virtual Keyboard Device: Applying InputClass "evdev keyboard catchall"
[    22.049] (II) Using input driver 'evdev' for 'ACPI Virtual Keyboard Device'
[    22.049] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    22.049] (**) ACPI Virtual Keyboard Device: always reports core events
[    22.049] (**) ACPI Virtual Keyboard Device: Device: "/dev/input/event20"
[    22.049] (--) ACPI Virtual Keyboard Device: Found keys
[    22.049] (II) ACPI Virtual Keyboard Device: Configuring as keyboard
[    22.049] (**) Option "config_info" "udev:/sys/devices/virtual/input/input20/event20"
[    22.049] (II) XINPUT: Adding extended input device "ACPI Virtual Keyboard Device" (type: KEYBOARD)
[    22.049] (**) Option "xkb_rules" "evdev"
[    22.049] (**) Option "xkb_model" "geniuskb19e"
[    22.049] (**) Option "xkb_layout" "fr,brai"
[    22.049] (**) Option "xkb_variant" "oss,"
[    22.049] (**) Option "xkb_options" "compose:lwin,compose:rwin,nbsp:level3n,grp:shift_caps_toggle,grp_led:scroll,terminate:ctrl_alt_bksp"
[    22.049] (II) config/udev: Adding input device Dell WMI hotkeys (/dev/input/event6)
[    22.049] (**) Dell WMI hotkeys: Applying InputClass "evdev keyboard catchall"
[    22.050] (II) Using input driver 'evdev' for 'Dell WMI hotkeys'
[    22.050] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    22.050] (**) Dell WMI hotkeys: always reports core events
[    22.050] (**) Dell WMI hotkeys: Device: "/dev/input/event6"
[    22.050] (--) Dell WMI hotkeys: Found keys
[    22.050] (II) Dell WMI hotkeys: Configuring as keyboard
[    22.050] (**) Option "config_info" "udev:/sys/devices/virtual/input/input6/event6"
[    22.050] (II) XINPUT: Adding extended input device "Dell WMI hotkeys" (type: KEYBOARD)
[    22.050] (**) Option "xkb_rules" "evdev"
[    22.050] (**) Option "xkb_model" "geniuskb19e"
[    22.050] (**) Option "xkb_layout" "fr,brai"
[    22.050] (**) Option "xkb_variant" "oss,"
[    22.050] (**) Option "xkb_options" "compose:lwin,compose:rwin,nbsp:level3n,grp:shift_caps_toggle,grp_led:scroll,terminate:ctrl_alt_bksp"
[    34.676] (II) Power Button: Close
[    34.676] (II) UnloadModule: "evdev"
[    34.676] (II) Unloading evdev
[    34.780] (II) Video Bus: Close
[    34.780] (II) UnloadModule: "evdev"
[    34.780] (II) Unloading evdev
[    34.808] (II) Video Bus: Close
[    34.808] (II) UnloadModule: "evdev"
[    34.808] (II) Unloading evdev
[    34.808] (II) Power Button: Close
[    34.808] (II) UnloadModule: "evdev"
[    34.808] (II) Unloading evdev
[    34.808] (II) Sleep Button: Close
[    34.808] (II) UnloadModule: "evdev"
[    34.808] (II) Unloading evdev
[    34.808] (II) Dell Dell USB Optical Mouse: Close
[    34.808] (II) UnloadModule: "evdev"
[    34.808] (II) Unloading evdev
[    34.809] (II) Dell Dell USB Keyboard: Close
[    34.809] (II) UnloadModule: "evdev"
[    34.809] (II) Unloading evdev
[    34.809] (II) AT Translated Set 2 keyboard: Close
[    34.809] (II) UnloadModule: "evdev"
[    34.809] (II) Unloading evdev
[    34.812] (II) PS/2 Generic Mouse: Close
[    34.812] (II) UnloadModule: "evdev"
[    34.812] (II) Unloading evdev
[    34.812] (II) ACPI Virtual Keyboard Device: Close
[    34.812] (II) UnloadModule: "evdev"
[    34.812] (II) Unloading evdev
[    34.812] (II) Dell WMI hotkeys: Close
[    34.812] (II) UnloadModule: "evdev"
[    34.812] (II) Unloading evdev

--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="Xorg.0.log.good"
Content-Transfer-Encoding: 8bit

[    24.662] 
X.Org X Server 1.10.4
Release Date: 2011-08-19
[    24.666] X Protocol Version 11, Revision 0
[    24.667] Build Operating System: Linux 3.0.0-1-amd64 x86_64 Debian
[    24.668] Current Operating System: Linux type 3.0.4 #2 SMP Tue Aug 30 11:04:23 CEST 2011 x86_64
[    24.670] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.0.4 root=UUID=38e6e493-2f5f-4a98-b1d6-a9434f0683cc ro i915.i915_enable-fbc=0
[    24.671] Build Date: 24 August 2011  08:53:55AM
[    24.673] xorg-server 2:1.10.4-1 (Cyril Brulebois <kibi@debian.org>) 
[    24.674] Current version of pixman: 0.22.2
[    24.676] 	Before reporting problems, check http://wiki.x.org
	to make sure that you have the latest version.
[    24.679] Markers: (--) probed, (**) from config file, (==) default setting,
	(++) from command line, (!!) notice, (II) informational,
	(WW) warning, (EE) error, (NI) not implemented, (??) unknown.
[    24.684] (==) Log file: "/var/log/Xorg.0.log", Time: Thu Sep 15 10:03:36 2011
[    24.698] (==) Using config file: "/etc/X11/xorg.conf"
[    24.700] (==) Using system config directory "/usr/share/X11/xorg.conf.d"
[    24.703] (==) No Layout section.  Using the first Screen section.
[    24.703] (==) No screen section available. Using defaults.
[    24.703] (**) |-->Screen "Default Screen Section" (0)
[    24.703] (**) |   |-->Monitor "<default monitor>"
[    24.704] (==) No device specified for screen "Default Screen Section".
	Using the first device section listed.
[    24.704] (**) |   |-->Device "Configured Video Device"
[    24.704] (==) No monitor specified for screen "Default Screen Section".
	Using a default monitor configuration.
[    24.704] (==) Automatically adding devices
[    24.704] (==) Automatically enabling devices
[    24.706] (==) FontPath set to:
	/usr/share/fonts/X11/misc,
	/usr/share/fonts/X11/cyrillic,
	/usr/share/fonts/X11/100dpi/:unscaled,
	/usr/share/fonts/X11/75dpi/:unscaled,
	/usr/share/fonts/X11/Type1,
	/usr/share/fonts/X11/100dpi,
	/usr/share/fonts/X11/75dpi,
	/var/lib/defoma/x-ttcidfont-conf.d/dirs/TrueType,
	built-ins
[    24.706] (==) ModulePath set to "/usr/lib/xorg/modules"
[    24.706] (==) |-->Input Device "Configured Mouse"
[    24.706] (==) No Layout section. Using the first core pointer device.
[    24.706] (II) The server relies on udev to provide the list of input devices.
	If no devices become available, reconfigure udev or disable AutoAddDevices.
[    24.706] (WW) Hotplugging is on, devices using drivers 'kbd', 'mouse' or 'vmmouse' will be disabled.
[    24.706] (WW) Disabling Configured Mouse
[    24.706] (II) Loader magic: 0x7d8500
[    24.707] (II) Module ABI versions:
[    24.707] 	X.Org ANSI C Emulation: 0.4
[    24.707] 	X.Org Video Driver: 10.0
[    24.707] 	X.Org XInput driver : 12.2
[    24.707] 	X.Org Server Extension : 5.0
[    24.707] (--) PCI:*(0:0:2:0) 8086:0126:1028:0493 rev 9, Mem @ 0xe5400000/4194304, 0xc0000000/268435456, I/O @ 0x00005000/64
[    24.707] (--) PCI: (0:1:0:0) 10de:1056:1028:1493 rev 161, Mem @ 0xe4000000/16777216, 0xd0000000/268435456, 0xe0000000/33554432, I/O @ 0x00004000/128, BIOS @ 0x????????/524288
[    24.707] (II) Open ACPI successful (/var/run/acpid.socket)
[    24.707] (II) LoadModule: "extmod"
[    24.711] (II) Loading /usr/lib/xorg/modules/extensions/libextmod.so
[    24.714] (II) Module extmod: vendor="X.Org Foundation"
[    24.714] 	compiled for 1.10.4, module version = 1.0.0
[    24.714] 	Module class: X.Org Server Extension
[    24.714] 	ABI class: X.Org Server Extension, version 5.0
[    24.714] (II) Loading extension SELinux
[    24.714] (II) Loading extension MIT-SCREEN-SAVER
[    24.714] (II) Loading extension XFree86-VidModeExtension
[    24.714] (II) Loading extension XFree86-DGA
[    24.714] (II) Loading extension DPMS
[    24.714] (II) Loading extension XVideo
[    24.714] (II) Loading extension XVideo-MotionCompensation
[    24.714] (II) Loading extension X-Resource
[    24.714] (II) LoadModule: "dbe"
[    24.714] (II) Loading /usr/lib/xorg/modules/extensions/libdbe.so
[    24.714] (II) Module dbe: vendor="X.Org Foundation"
[    24.714] 	compiled for 1.10.4, module version = 1.0.0
[    24.714] 	Module class: X.Org Server Extension
[    24.714] 	ABI class: X.Org Server Extension, version 5.0
[    24.714] (II) Loading extension DOUBLE-BUFFER
[    24.714] (II) LoadModule: "glx"
[    24.715] (II) Loading /usr/lib/xorg/modules/extensions/libglx.so
[    24.717] (II) Module glx: vendor="X.Org Foundation"
[    24.718] 	compiled for 1.10.4, module version = 1.0.0
[    24.718] 	ABI class: X.Org Server Extension, version 5.0
[    24.718] (==) AIGLX enabled
[    24.718] (II) Loading extension GLX
[    24.718] (II) LoadModule: "record"
[    24.718] (II) Loading /usr/lib/xorg/modules/extensions/librecord.so
[    24.719] (II) Module record: vendor="X.Org Foundation"
[    24.719] 	compiled for 1.10.4, module version = 1.13.0
[    24.719] 	Module class: X.Org Server Extension
[    24.719] 	ABI class: X.Org Server Extension, version 5.0
[    24.719] (II) Loading extension RECORD
[    24.719] (II) LoadModule: "dri"
[    24.719] (II) Loading /usr/lib/xorg/modules/extensions/libdri.so
[    24.721] (II) Module dri: vendor="X.Org Foundation"
[    24.721] 	compiled for 1.10.4, module version = 1.0.0
[    24.721] 	ABI class: X.Org Server Extension, version 5.0
[    24.721] (II) Loading extension XFree86-DRI
[    24.721] (II) LoadModule: "dri2"
[    24.721] (II) Loading /usr/lib/xorg/modules/extensions/libdri2.so
[    24.722] (II) Module dri2: vendor="X.Org Foundation"
[    24.722] 	compiled for 1.10.4, module version = 1.2.0
[    24.722] 	ABI class: X.Org Server Extension, version 5.0
[    24.722] (II) Loading extension DRI2
[    24.722] (==) Matched intel as autoconfigured driver 0
[    24.722] (==) Matched vesa as autoconfigured driver 1
[    24.722] (==) Matched fbdev as autoconfigured driver 2
[    24.722] (==) Assigned the driver to the xf86ConfigLayout
[    24.722] (II) LoadModule: "intel"
[    24.723] (II) Loading /usr/lib/xorg/modules/drivers/intel_drv.so
[    24.727] (II) Module intel: vendor="X.Org Foundation"
[    24.727] 	compiled for 1.10.1, module version = 2.15.0
[    24.727] 	Module class: X.Org Video Driver
[    24.727] 	ABI class: X.Org Video Driver, version 10.0
[    24.727] (II) LoadModule: "vesa"
[    24.727] (II) Loading /usr/lib/xorg/modules/drivers/vesa_drv.so
[    24.728] (II) Module vesa: vendor="X.Org Foundation"
[    24.728] 	compiled for 1.10.2, module version = 2.3.0
[    24.728] 	Module class: X.Org Video Driver
[    24.728] 	ABI class: X.Org Video Driver, version 10.0
[    24.728] (II) LoadModule: "fbdev"
[    24.729] (II) Loading /usr/lib/xorg/modules/drivers/fbdev_drv.so
[    24.730] (II) Module fbdev: vendor="X.Org Foundation"
[    24.730] 	compiled for 1.10.1, module version = 0.4.2
[    24.730] 	ABI class: X.Org Video Driver, version 10.0
[    24.730] (II) intel: Driver for Intel Integrated Graphics Chipsets: i810,
	i810-dc100, i810e, i815, i830M, 845G, 854, 852GM/855GM, 865G, 915G,
	E7221 (i915), 915GM, 945G, 945GM, 945GME, Pineview GM, Pineview G,
	965G, G35, 965Q, 946GZ, 965GM, 965GME/GLE, G33, Q35, Q33, GM45,
	4 Series, G45/G43, Q45/Q43, G41, B43, B43, Clarkdale, Arrandale,
	Sandybridge, Sandybridge, Sandybridge, Sandybridge, Sandybridge,
	Sandybridge, Sandybridge
[    24.730] (II) VESA: driver for VESA chipsets: vesa
[    24.730] (II) FBDEV: driver for framebuffer: fbdev
[    24.730] (--) using VT number 7

[    24.751] (II) Loading /usr/lib/xorg/modules/drivers/intel_drv.so
[    24.751] (WW) Falling back to old probe method for vesa
[    24.751] (WW) Falling back to old probe method for fbdev
[    24.751] (II) Loading sub module "fbdevhw"
[    24.751] (II) LoadModule: "fbdevhw"
[    24.752] (II) Loading /usr/lib/xorg/modules/libfbdevhw.so
[    24.752] (II) Module fbdevhw: vendor="X.Org Foundation"
[    24.752] 	compiled for 1.10.4, module version = 0.0.2
[    24.752] 	ABI class: X.Org Video Driver, version 10.0
[    24.752] drmOpenDevice: node name is /dev/dri/card0
[    24.753] drmOpenDevice: open result is 11, (OK)
[    24.753] drmOpenByBusid: Searching for BusID pci:0000:00:02.0
[    24.753] drmOpenDevice: node name is /dev/dri/card0
[    24.753] drmOpenDevice: open result is 11, (OK)
[    24.753] drmOpenByBusid: drmOpenMinor returns 11
[    24.753] drmOpenByBusid: drmGetBusid reports pci:0000:00:02.0
[    24.753] (II) intel(0): Creating default Display subsection in Screen section
	"Default Screen Section" for depth/fbbpp 24/32
[    24.753] (==) intel(0): Depth 24, (--) framebuffer bpp 32
[    24.753] (==) intel(0): RGB weight 888
[    24.753] (==) intel(0): Default visual is TrueColor
[    24.753] (II) intel(0): Integrated Graphics Chipset: Intel(R) Sandybridge
[    24.753] (--) intel(0): Chipset: "Sandybridge"
[    24.753] (**) intel(0): Relaxed fencing enabled
[    24.753] (**) intel(0): Framebuffer tiled
[    24.753] (**) intel(0): Pixmaps tiled
[    24.753] (**) intel(0): 3D buffers tiled
[    24.753] (**) intel(0): SwapBuffers wait disabled
[    24.753] (==) intel(0): video overlay key set to 0x101fe
[    24.754] (II) intel(0): Output LVDS1 has no monitor section
[    24.868] (II) intel(0): found backlight control interface /sys/class/backlight/acpi_video0
[    24.931] (II) intel(0): Output VGA1 has no monitor section
[    24.931] (II) intel(0): EDID for output LVDS1
[    24.931] (II) intel(0): Manufacturer: SEC  Model: 544b  Serial#: 0
[    24.932] (II) intel(0): Year: 2010  Week: 0
[    24.932] (II) intel(0): EDID Version: 1.4
[    24.932] (II) intel(0): Digital Display Input
[    24.932] (II) intel(0): 6 bits per channel
[    24.932] (II) intel(0): Digital interface is undefined
[    24.932] (II) intel(0): Max Image Size [cm]: horiz.: 31  vert.: 17
[    24.932] (II) intel(0): Gamma: 2.20
[    24.932] (II) intel(0): No DPMS capabilities specified
[    24.932] (II) intel(0): Supported color encodings: RGB 4:4:4 YCrCb 4:4:4 
[    24.932] (II) intel(0): First detailed timing is preferred mode
[    24.932] (II) intel(0): Preferred mode is native pixel format and refresh rate
[    24.932] (II) intel(0): redX: 0.610 redY: 0.340   greenX: 0.330 greenY: 0.550
[    24.932] (II) intel(0): blueX: 0.155 blueY: 0.090   whiteX: 0.313 whiteY: 0.329
[    24.932] (II) intel(0): Manufacturer's mask: 0
[    24.932] (II) intel(0): Supported detailed timing:
[    24.932] (II) intel(0): clock: 114.1 MHz   Image Size:  310 x 174 mm
[    24.932] (II) intel(0): h_active: 1600  h_sync: 1648  h_sync_end 1680 h_blank_end 2044 h_border: 0
[    24.932] (II) intel(0): v_active: 900  v_sync: 902  v_sync_end 907 v_blanking: 930 v_border: 0
[    24.932] (II) intel(0): Supported detailed timing:
[    24.932] (II) intel(0): clock: 74.1 MHz   Image Size:  310 x 174 mm
[    24.932] (II) intel(0): h_active: 1600  h_sync: 1648  h_sync_end 1680 h_blank_end 1992 h_border: 0
[    24.932] (II) intel(0): v_active: 900  v_sync: 902  v_sync_end 907 v_blanking: 930 v_border: 0
[    24.932] (II) intel(0):  MJ154€140KT
[    24.932] (II) intel(0): Unknown vendor-specific block 0
[    24.932] (II) intel(0): EDID (in hex):
[    24.932] (II) intel(0): 	00ffffffffffff004ca34b5400000000
[    24.932] (II) intel(0): 	00140104901f11780a4bc59c57548c27
[    24.932] (II) intel(0): 	17505400000001010101010101010101
[    24.932] (II) intel(0): 	0101010101018e2c40bc61841e303020
[    24.932] (II) intel(0): 	250036ae1000001af11c408861841e30
[    24.932] (II) intel(0): 	3020250036ae1000001a000000fe004d
[    24.932] (II) intel(0): 	4a313534803134304b540a2000000000
[    24.932] (II) intel(0): 	00004101980000000002010a2020001d
[    24.932] (II) intel(0): EDID vendor "SEC", prod id 21579
[    24.932] (II) intel(0): Printing DDC gathered Modelines:
[    24.932] (II) intel(0): Modeline "1600x900"x0.0  114.06  1600 1648 1680 2044  900 902 907 930 +hsync -vsync (55.8 kHz)
[    24.932] (II) intel(0): Modeline "1600x900"x0.0   74.09  1600 1648 1680 1992  900 902 907 930 +hsync -vsync (37.2 kHz)
[    24.933] (II) intel(0): Not using default mode "320x240" (doublescan mode not supported)
[    24.933] (II) intel(0): Not using default mode "400x300" (doublescan mode not supported)
[    24.933] (II) intel(0): Not using default mode "400x300" (doublescan mode not supported)
[    24.933] (II) intel(0): Not using default mode "512x384" (doublescan mode not supported)
[    24.933] (II) intel(0): Not using default mode "640x480" (doublescan mode not supported)
[    24.933] (II) intel(0): Not using default mode "640x512" (doublescan mode not supported)
[    24.933] (II) intel(0): Not using default mode "800x600" (doublescan mode not supported)
[    24.933] (II) intel(0): Not using default mode "896x672" (doublescan mode not supported)
[    24.933] (II) intel(0): Not using default mode "928x696" (doublescan mode not supported)
[    24.933] (II) intel(0): Not using default mode "960x720" (doublescan mode not supported)
[    24.933] (II) intel(0): Not using default mode "576x432" (doublescan mode not supported)
[    24.933] (II) intel(0): Not using default mode "680x384" (doublescan mode not supported)
[    24.933] (II) intel(0): Not using default mode "680x384" (doublescan mode not supported)
[    24.933] (II) intel(0): Not using default mode "700x525" (doublescan mode not supported)
[    24.933] (II) intel(0): Not using default mode "720x450" (doublescan mode not supported)
[    24.933] (II) intel(0): Not using default mode "800x512" (doublescan mode not supported)
[    24.933] (II) intel(0): Not using default mode "840x525" (doublescan mode not supported)
[    24.933] (II) intel(0): Not using default mode "840x525" (doublescan mode not supported)
[    24.933] (II) intel(0): Not using default mode "960x540" (doublescan mode not supported)
[    24.933] (II) intel(0): Not using default mode "960x600" (doublescan mode not supported)
[    24.933] (II) intel(0): Not using default mode "1024x768" (doublescan mode not supported)
[    24.933] (II) intel(0): Printing probed modes for output LVDS1
[    24.933] (II) intel(0): Modeline "1600x900"x60.0  114.06  1600 1648 1680 2044  900 902 907 930 +hsync -vsync (55.8 kHz)
[    24.933] (II) intel(0): Modeline "1600x900"x40.0   74.09  1600 1648 1680 1992  900 902 907 930 +hsync -vsync (37.2 kHz)
[    24.933] (II) intel(0): Modeline "1440x900"x59.9  106.50  1440 1520 1672 1904  900 903 909 934 -hsync +vsync (55.9 kHz)
[    24.933] (II) intel(0): Modeline "1360x768"x59.8   84.75  1360 1432 1568 1776  768 771 781 798 -hsync +vsync (47.7 kHz)
[    24.933] (II) intel(0): Modeline "1360x768"x60.0   72.00  1360 1408 1440 1520  768 771 781 790 +hsync -vsync (47.4 kHz)
[    24.933] (II) intel(0): Modeline "1152x864"x60.0   81.62  1152 1216 1336 1520  864 865 868 895 -hsync +vsync (53.7 kHz)
[    24.933] (II) intel(0): Modeline "1024x768"x60.0   65.00  1024 1048 1184 1344  768 771 777 806 -hsync -vsync (48.4 kHz)
[    24.933] (II) intel(0): Modeline "800x600"x60.3   40.00  800 840 968 1056  600 601 605 628 +hsync +vsync (37.9 kHz)
[    24.933] (II) intel(0): Modeline "800x600"x56.2   36.00  800 824 896 1024  600 601 603 625 +hsync +vsync (35.2 kHz)
[    24.933] (II) intel(0): Modeline "640x480"x59.9   25.18  640 656 752 800  480 490 492 525 -hsync -vsync (31.5 kHz)
[    24.997] (II) intel(0): EDID for output VGA1
[    24.997] (II) intel(0): Manufacturer: DEL  Model: a020  Serial#: 960974412
[    24.997] (II) intel(0): Year: 2008  Week: 21
[    24.997] (II) intel(0): EDID Version: 1.3
[    24.997] (II) intel(0): Analog Display Input,  Input Voltage Level: 0.700/0.300 V
[    24.997] (II) intel(0): Sync:  Separate  Composite  SyncOnGreen
[    24.997] (II) intel(0): Max Image Size [cm]: horiz.: 41  vert.: 31
[    24.997] (II) intel(0): Gamma: 2.20
[    24.997] (II) intel(0): DPMS capabilities: StandBy Suspend Off; RGB/Color Display
[    24.997] (II) intel(0): Default color space is primary color space
[    24.997] (II) intel(0): First detailed timing is preferred mode
[    24.997] (II) intel(0): redX: 0.640 redY: 0.330   greenX: 0.300 greenY: 0.600
[    24.997] (II) intel(0): blueX: 0.150 blueY: 0.060   whiteX: 0.312 whiteY: 0.329
[    24.997] (II) intel(0): Supported established timings:
[    24.997] (II) intel(0): 720x400@70Hz
[    24.997] (II) intel(0): 640x480@60Hz
[    24.997] (II) intel(0): 640x480@75Hz
[    24.997] (II) intel(0): 800x600@60Hz
[    24.997] (II) intel(0): 800x600@75Hz
[    24.997] (II) intel(0): 1024x768@60Hz
[    24.997] (II) intel(0): 1024x768@75Hz
[    24.997] (II) intel(0): 1280x1024@75Hz
[    24.998] (II) intel(0): Manufacturer's mask: 0
[    24.998] (II) intel(0): Supported standard timings:
[    24.998] (II) intel(0): #0: hsize: 1280  vsize 1024  refresh: 60  vid: 32897
[    24.998] (II) intel(0): #1: hsize: 1600  vsize 1200  refresh: 60  vid: 16553
[    24.998] (II) intel(0): #2: hsize: 1152  vsize 864  refresh: 75  vid: 20337
[    24.998] (II) intel(0): Supported detailed timing:
[    24.998] (II) intel(0): clock: 162.0 MHz   Image Size:  367 x 275 mm
[    24.998] (II) intel(0): h_active: 1600  h_sync: 1664  h_sync_end 1856 h_blank_end 2160 h_border: 0
[    24.998] (II) intel(0): v_active: 1200  v_sync: 1201  v_sync_end 1204 v_blanking: 1250 v_border: 0
[    24.998] (II) intel(0): Serial No: MY54685J9GNL
[    24.998] (II) intel(0): Monitor name: DELL 2007FP
[    24.998] (II) intel(0): Ranges: V min: 56 V max: 76 Hz, H min: 30 H max: 83 kHz, PixClock max 175 MHz
[    24.998] (II) intel(0): EDID (in hex):
[    24.998] (II) intel(0): 	00ffffffffffff0010ac20a04c4e4739
[    24.998] (II) intel(0): 	151201030e291f78eeee91a3544c9926
[    24.998] (II) intel(0): 	0f5054a54b008180a940714f01010101
[    24.998] (II) intel(0): 	010101010101483f403062b0324040c0
[    24.998] (II) intel(0): 	13006f131100001e000000ff004d5935
[    24.998] (II) intel(0): 	343638354a39474e4c0a000000fc0044
[    24.998] (II) intel(0): 	454c4c203230303746500a20000000fd
[    24.998] (II) intel(0): 	00384c1e5311000a20202020202000c0
[    24.998] (II) intel(0): Printing probed modes for output VGA1
[    24.998] (II) intel(0): Modeline "1600x1200"x60.0  162.00  1600 1664 1856 2160  1200 1201 1204 1250 +hsync +vsync (75.0 kHz)
[    24.998] (II) intel(0): Modeline "1280x1024"x75.0  135.00  1280 1296 1440 1688  1024 1025 1028 1066 +hsync +vsync (80.0 kHz)
[    24.998] (II) intel(0): Modeline "1280x1024"x60.0  108.00  1280 1328 1440 1688  1024 1025 1028 1066 +hsync +vsync (64.0 kHz)
[    24.998] (II) intel(0): Modeline "1152x864"x75.0  108.00  1152 1216 1344 1600  864 865 868 900 +hsync +vsync (67.5 kHz)
[    24.998] (II) intel(0): Modeline "1024x768"x75.1   78.80  1024 1040 1136 1312  768 769 772 800 +hsync +vsync (60.1 kHz)
[    24.998] (II) intel(0): Modeline "1024x768"x60.0   65.00  1024 1048 1184 1344  768 771 777 806 -hsync -vsync (48.4 kHz)
[    24.998] (II) intel(0): Modeline "800x600"x75.0   49.50  800 816 896 1056  600 601 604 625 +hsync +vsync (46.9 kHz)
[    24.998] (II) intel(0): Modeline "800x600"x60.3   40.00  800 840 968 1056  600 601 605 628 +hsync +vsync (37.9 kHz)
[    24.998] (II) intel(0): Modeline "640x480"x75.0   31.50  640 656 720 840  480 481 484 500 -hsync -vsync (37.5 kHz)
[    24.998] (II) intel(0): Modeline "640x480"x60.0   25.20  640 656 752 800  480 490 492 525 -hsync -vsync (31.5 kHz)
[    24.998] (II) intel(0): Modeline "720x400"x70.1   28.32  720 738 846 900  400 412 414 449 -hsync +vsync (31.5 kHz)
[    24.998] (II) intel(0): Output LVDS1 connected
[    24.998] (II) intel(0): Output VGA1 connected
[    24.998] (II) intel(0): Using fuzzy aspect match for initial modes
[    24.998] (II) intel(0): Output LVDS1 using initial mode 1152x864
[    24.998] (II) intel(0): Output VGA1 using initial mode 1152x864
[    24.998] (II) intel(0): Using default gamma of (1.0, 1.0, 1.0) unless otherwise stated.
[    24.998] (II) intel(0): Kernel page flipping support detected, enabling
[    24.998] (**) intel(0): Display dimensions: (310, 170) mm
[    24.998] (**) intel(0): DPI set to (94, 129)
[    24.998] (II) Loading sub module "fb"
[    24.998] (II) LoadModule: "fb"
[    24.999] (II) Loading /usr/lib/xorg/modules/libfb.so
[    25.002] (II) Module fb: vendor="X.Org Foundation"
[    25.002] 	compiled for 1.10.4, module version = 1.0.0
[    25.002] 	ABI class: X.Org ANSI C Emulation, version 0.4
[    25.002] (II) Loading sub module "dri2"
[    25.002] (II) LoadModule: "dri2"
[    25.003] (II) Loading /usr/lib/xorg/modules/extensions/libdri2.so
[    25.003] (II) Module dri2: vendor="X.Org Foundation"
[    25.003] 	compiled for 1.10.4, module version = 1.2.0
[    25.003] 	ABI class: X.Org Server Extension, version 5.0
[    25.003] (II) UnloadModule: "vesa"
[    25.003] (II) Unloading vesa
[    25.003] (II) UnloadModule: "fbdev"
[    25.003] (II) Unloading fbdev
[    25.003] (II) UnloadModule: "fbdevhw"
[    25.003] (II) Unloading fbdevhw
[    25.003] (==) Depth 24 pixmap format is 32 bpp
[    25.003] (II) intel(0): [DRI2] Setup complete
[    25.003] (II) intel(0): [DRI2]   DRI driver: i965
[    25.003] (II) intel(0): Allocated new frame buffer 1152x864 stride 4608, tiled
[    25.008] (II) UXA(0): Driver registered support for the following operations:
[    25.008] (II)         solid
[    25.008] (II)         copy
[    25.008] (II)         composite (RENDER acceleration)
[    25.008] (II)         put_image
[    25.008] (II)         get_image
[    25.008] (==) intel(0): Backing store disabled
[    25.008] (==) intel(0): Silken mouse enabled
[    25.008] (II) intel(0): Initializing HW Cursor
[    25.626] (II) intel(0): RandR 1.2 enabled, ignore the following RandR disabled message.
[    25.702] (==) intel(0): DPMS enabled
[    25.703] (II) intel(0): Set up textured video
[    25.703] (II) intel(0): direct rendering: DRI2 Enabled
[    25.703] (==) intel(0): hotplug detection: "enabled"
[    25.703] (--) RandR disabled
[    25.703] (II) Initializing built-in extension Generic Event Extension
[    25.703] (II) Initializing built-in extension SHAPE
[    25.703] (II) Initializing built-in extension MIT-SHM
[    25.703] (II) Initializing built-in extension XInputExtension
[    25.703] (II) Initializing built-in extension XTEST
[    25.703] (II) Initializing built-in extension BIG-REQUESTS
[    25.703] (II) Initializing built-in extension SYNC
[    25.703] (II) Initializing built-in extension XKEYBOARD
[    25.703] (II) Initializing built-in extension XC-MISC
[    25.703] (II) Initializing built-in extension SECURITY
[    25.703] (II) Initializing built-in extension XINERAMA
[    25.703] (II) Initializing built-in extension XFIXES
[    25.703] (II) Initializing built-in extension RENDER
[    25.703] (II) Initializing built-in extension RANDR
[    25.703] (II) Initializing built-in extension COMPOSITE
[    25.703] (II) Initializing built-in extension DAMAGE
[    25.703] (II) SELinux: Disabled on system
[    25.733] (II) AIGLX: enabled GLX_MESA_copy_sub_buffer
[    25.734] (II) AIGLX: enabled GLX_INTEL_swap_event
[    25.734] (II) AIGLX: enabled GLX_SGI_swap_control and GLX_MESA_swap_control
[    25.734] (II) AIGLX: enabled GLX_SGI_make_current_read
[    25.734] (II) AIGLX: GLX_EXT_texture_from_pixmap backed by buffer objects
[    25.734] (II) AIGLX: Loaded and initialized /usr/lib/x86_64-linux-gnu/dri/i965_dri.so
[    25.734] (II) GLX: Initialized DRI2 GL provider for screen 0
[    25.735] (II) intel(0): Setting screen physical size to 304 x 228
[    25.872] (II) config/udev: Adding input device Power Button (/dev/input/event4)
[    25.872] (**) Power Button: Applying InputClass "evdev keyboard catchall"
[    25.872] (II) LoadModule: "evdev"
[    25.872] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    25.873] (II) Module evdev: vendor="X.Org Foundation"
[    25.873] 	compiled for 1.10.1, module version = 2.6.0
[    25.873] 	Module class: X.Org XInput Driver
[    25.873] 	ABI class: X.Org XInput driver, version 12.2
[    25.873] (II) Using input driver 'evdev' for 'Power Button'
[    25.873] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    25.873] (**) Power Button: always reports core events
[    25.873] (**) Power Button: Device: "/dev/input/event4"
[    25.873] (--) Power Button: Found keys
[    25.873] (II) Power Button: Configuring as keyboard
[    25.873] (**) Option "config_info" "udev:/sys/devices/LNXSYSTM:00/LNXPWRBN:00/input/input4/event4"
[    25.873] (II) XINPUT: Adding extended input device "Power Button" (type: KEYBOARD)
[    25.873] (**) Option "xkb_rules" "evdev"
[    25.873] (**) Option "xkb_model" "geniuskb19e"
[    25.873] (**) Option "xkb_layout" "fr,brai"
[    25.873] (**) Option "xkb_variant" "oss,"
[    25.873] (**) Option "xkb_options" "compose:lwin,compose:rwin,nbsp:level3n,grp:shift_caps_toggle,grp_led:scroll,terminate:ctrl_alt_bksp"
[    25.983] (II) config/udev: Adding input device Video Bus (/dev/input/event17)
[    25.983] (**) Video Bus: Applying InputClass "evdev keyboard catchall"
[    25.983] (II) Using input driver 'evdev' for 'Video Bus'
[    25.983] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    25.983] (**) Video Bus: always reports core events
[    25.983] (**) Video Bus: Device: "/dev/input/event17"
[    25.983] (--) Video Bus: Found keys
[    25.983] (II) Video Bus: Configuring as keyboard
[    25.983] (**) Option "config_info" "udev:/sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:01/input/input17/event17"
[    25.983] (II) XINPUT: Adding extended input device "Video Bus" (type: KEYBOARD)
[    25.984] (**) Option "xkb_rules" "evdev"
[    25.984] (**) Option "xkb_model" "geniuskb19e"
[    25.984] (**) Option "xkb_layout" "fr,brai"
[    25.984] (**) Option "xkb_variant" "oss,"
[    25.984] (**) Option "xkb_options" "compose:lwin,compose:rwin,nbsp:level3n,grp:shift_caps_toggle,grp_led:scroll,terminate:ctrl_alt_bksp"
[    25.988] (II) config/udev: Adding input device Video Bus (/dev/input/event15)
[    25.988] (**) Video Bus: Applying InputClass "evdev keyboard catchall"
[    25.988] (II) Using input driver 'evdev' for 'Video Bus'
[    25.988] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    25.988] (**) Video Bus: always reports core events
[    25.988] (**) Video Bus: Device: "/dev/input/event15"
[    25.988] (--) Video Bus: Found keys
[    25.988] (II) Video Bus: Configuring as keyboard
[    25.988] (**) Option "config_info" "udev:/sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:13/LNXVIDEO:00/input/input15/event15"
[    25.988] (II) XINPUT: Adding extended input device "Video Bus" (type: KEYBOARD)
[    25.988] (**) Option "xkb_rules" "evdev"
[    25.988] (**) Option "xkb_model" "geniuskb19e"
[    25.988] (**) Option "xkb_layout" "fr,brai"
[    25.988] (**) Option "xkb_variant" "oss,"
[    25.988] (**) Option "xkb_options" "compose:lwin,compose:rwin,nbsp:level3n,grp:shift_caps_toggle,grp_led:scroll,terminate:ctrl_alt_bksp"
[    26.059] (II) config/udev: Adding input device Power Button (/dev/input/event2)
[    26.059] (**) Power Button: Applying InputClass "evdev keyboard catchall"
[    26.059] (II) Using input driver 'evdev' for 'Power Button'
[    26.059] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    26.059] (**) Power Button: always reports core events
[    26.059] (**) Power Button: Device: "/dev/input/event2"
[    26.059] (--) Power Button: Found keys
[    26.059] (II) Power Button: Configuring as keyboard
[    26.059] (**) Option "config_info" "udev:/sys/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input2/event2"
[    26.059] (II) XINPUT: Adding extended input device "Power Button" (type: KEYBOARD)
[    26.059] (**) Option "xkb_rules" "evdev"
[    26.059] (**) Option "xkb_model" "geniuskb19e"
[    26.059] (**) Option "xkb_layout" "fr,brai"
[    26.059] (**) Option "xkb_variant" "oss,"
[    26.059] (**) Option "xkb_options" "compose:lwin,compose:rwin,nbsp:level3n,grp:shift_caps_toggle,grp_led:scroll,terminate:ctrl_alt_bksp"
[    26.060] (II) config/udev: Adding input device Lid Switch (/dev/input/event1)
[    26.060] (II) No input driver/identifier specified (ignoring)
[    26.061] (II) config/udev: Adding input device Sleep Button (/dev/input/event3)
[    26.061] (**) Sleep Button: Applying InputClass "evdev keyboard catchall"
[    26.061] (II) Using input driver 'evdev' for 'Sleep Button'
[    26.061] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    26.061] (**) Sleep Button: always reports core events
[    26.061] (**) Sleep Button: Device: "/dev/input/event3"
[    26.061] (--) Sleep Button: Found keys
[    26.061] (II) Sleep Button: Configuring as keyboard
[    26.061] (**) Option "config_info" "udev:/sys/devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input3/event3"
[    26.061] (II) XINPUT: Adding extended input device "Sleep Button" (type: KEYBOARD)
[    26.061] (**) Option "xkb_rules" "evdev"
[    26.061] (**) Option "xkb_model" "geniuskb19e"
[    26.061] (**) Option "xkb_layout" "fr,brai"
[    26.061] (**) Option "xkb_variant" "oss,"
[    26.061] (**) Option "xkb_options" "compose:lwin,compose:rwin,nbsp:level3n,grp:shift_caps_toggle,grp_led:scroll,terminate:ctrl_alt_bksp"
[    26.064] (II) config/udev: Adding input device HDA NVidia HDMI/DP (/dev/input/event12)
[    26.064] (II) No input driver/identifier specified (ignoring)
[    26.065] (II) config/udev: Adding input device HDA NVidia HDMI/DP (/dev/input/event13)
[    26.065] (II) No input driver/identifier specified (ignoring)
[    26.065] (II) config/udev: Adding input device HDA NVidia HDMI/DP (/dev/input/event14)
[    26.065] (II) No input driver/identifier specified (ignoring)
[    26.070] (II) config/udev: Adding input device Dell Dell USB Optical Mouse (/dev/input/event18)
[    26.070] (**) Dell Dell USB Optical Mouse: Applying InputClass "evdev pointer catchall"
[    26.070] (II) Using input driver 'evdev' for 'Dell Dell USB Optical Mouse'
[    26.070] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    26.070] (**) Dell Dell USB Optical Mouse: always reports core events
[    26.070] (**) Dell Dell USB Optical Mouse: Device: "/dev/input/event18"
[    26.070] (--) Dell Dell USB Optical Mouse: Found 3 mouse buttons
[    26.070] (--) Dell Dell USB Optical Mouse: Found scroll wheel(s)
[    26.070] (--) Dell Dell USB Optical Mouse: Found relative axes
[    26.070] (--) Dell Dell USB Optical Mouse: Found x and y relative axes
[    26.070] (II) Dell Dell USB Optical Mouse: Configuring as mouse
[    26.070] (II) Dell Dell USB Optical Mouse: Adding scrollwheel support
[    26.070] (**) Dell Dell USB Optical Mouse: YAxisMapping: buttons 4 and 5
[    26.070] (**) Dell Dell USB Optical Mouse: EmulateWheelButton: 4, EmulateWheelInertia: 10, EmulateWheelTimeout: 200
[    26.070] (**) Option "config_info" "udev:/sys/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.2/1-1.2.1/1-1.2.1:1.0/input/input18/event18"
[    26.070] (II) XINPUT: Adding extended input device "Dell Dell USB Optical Mouse" (type: MOUSE)
[    26.070] (II) Dell Dell USB Optical Mouse: initialized for relative axes.
[    26.070] (**) Dell Dell USB Optical Mouse: (accel) keeping acceleration scheme 1
[    26.070] (**) Dell Dell USB Optical Mouse: (accel) acceleration profile 0
[    26.070] (**) Dell Dell USB Optical Mouse: (accel) acceleration factor: 2.000
[    26.070] (**) Dell Dell USB Optical Mouse: (accel) acceleration threshold: 4
[    26.071] (II) config/udev: Adding input device Dell Dell USB Optical Mouse (/dev/input/mouse1)
[    26.071] (II) No input driver/identifier specified (ignoring)
[    26.072] (II) config/udev: Adding input device Dell Dell USB Keyboard (/dev/input/event19)
[    26.072] (**) Dell Dell USB Keyboard: Applying InputClass "evdev keyboard catchall"
[    26.072] (II) Using input driver 'evdev' for 'Dell Dell USB Keyboard'
[    26.072] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    26.072] (**) Dell Dell USB Keyboard: always reports core events
[    26.072] (**) Dell Dell USB Keyboard: Device: "/dev/input/event19"
[    26.072] (--) Dell Dell USB Keyboard: Found keys
[    26.072] (II) Dell Dell USB Keyboard: Configuring as keyboard
[    26.072] (**) Option "config_info" "udev:/sys/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.2/1-1.2.2/1-1.2.2:1.0/input/input19/event19"
[    26.072] (II) XINPUT: Adding extended input device "Dell Dell USB Keyboard" (type: KEYBOARD)
[    26.072] (**) Option "xkb_rules" "evdev"
[    26.072] (**) Option "xkb_model" "geniuskb19e"
[    26.072] (**) Option "xkb_layout" "fr,brai"
[    26.072] (**) Option "xkb_variant" "oss,"
[    26.072] (**) Option "xkb_options" "compose:lwin,compose:rwin,nbsp:level3n,grp:shift_caps_toggle,grp_led:scroll,terminate:ctrl_alt_bksp"
[    26.072] (II) config/udev: Adding input device HDA Digital PCBeep (/dev/input/event7)
[    26.072] (II) No input driver/identifier specified (ignoring)
[    26.073] (II) config/udev: Adding input device HDA Intel PCH Line Out at Sep Left Jack (/dev/input/event10)
[    26.073] (II) No input driver/identifier specified (ignoring)
[    26.073] (II) config/udev: Adding input device HDA Intel PCH HP Out at Ext Left Jack (/dev/input/event11)
[    26.073] (II) No input driver/identifier specified (ignoring)
[    26.073] (II) config/udev: Adding input device HDA Intel PCH Mic at Sep Left Jack (/dev/input/event8)
[    26.073] (II) No input driver/identifier specified (ignoring)
[    26.073] (II) config/udev: Adding input device HDA Intel PCH Mic at Ext Left Jack (/dev/input/event9)
[    26.073] (II) No input driver/identifier specified (ignoring)
[    26.076] (II) config/udev: Adding input device AT Translated Set 2 keyboard (/dev/input/event0)
[    26.076] (**) AT Translated Set 2 keyboard: Applying InputClass "evdev keyboard catchall"
[    26.076] (II) Using input driver 'evdev' for 'AT Translated Set 2 keyboard'
[    26.076] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    26.076] (**) AT Translated Set 2 keyboard: always reports core events
[    26.076] (**) AT Translated Set 2 keyboard: Device: "/dev/input/event0"
[    26.076] (--) AT Translated Set 2 keyboard: Found keys
[    26.076] (II) AT Translated Set 2 keyboard: Configuring as keyboard
[    26.076] (**) Option "config_info" "udev:/sys/devices/platform/i8042/serio0/input/input0/event0"
[    26.076] (II) XINPUT: Adding extended input device "AT Translated Set 2 keyboard" (type: KEYBOARD)
[    26.076] (**) Option "xkb_rules" "evdev"
[    26.076] (**) Option "xkb_model" "geniuskb19e"
[    26.076] (**) Option "xkb_layout" "fr,brai"
[    26.076] (**) Option "xkb_variant" "oss,"
[    26.076] (**) Option "xkb_options" "compose:lwin,compose:rwin,nbsp:level3n,grp:shift_caps_toggle,grp_led:scroll,terminate:ctrl_alt_bksp"
[    26.077] (II) config/udev: Adding input device PS/2 Generic Mouse (/dev/input/event16)
[    26.077] (**) PS/2 Generic Mouse: Applying InputClass "evdev pointer catchall"
[    26.077] (II) Using input driver 'evdev' for 'PS/2 Generic Mouse'
[    26.077] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    26.077] (**) PS/2 Generic Mouse: always reports core events
[    26.077] (**) PS/2 Generic Mouse: Device: "/dev/input/event16"
[    26.077] (--) PS/2 Generic Mouse: Found 3 mouse buttons
[    26.077] (--) PS/2 Generic Mouse: Found relative axes
[    26.077] (--) PS/2 Generic Mouse: Found x and y relative axes
[    26.077] (II) PS/2 Generic Mouse: Configuring as mouse
[    26.077] (**) PS/2 Generic Mouse: YAxisMapping: buttons 4 and 5
[    26.077] (**) PS/2 Generic Mouse: EmulateWheelButton: 4, EmulateWheelInertia: 10, EmulateWheelTimeout: 200
[    26.077] (**) Option "config_info" "udev:/sys/devices/platform/i8042/serio1/input/input16/event16"
[    26.077] (II) XINPUT: Adding extended input device "PS/2 Generic Mouse" (type: MOUSE)
[    26.077] (II) PS/2 Generic Mouse: initialized for relative axes.
[    26.077] (**) PS/2 Generic Mouse: (accel) keeping acceleration scheme 1
[    26.077] (**) PS/2 Generic Mouse: (accel) acceleration profile 0
[    26.077] (**) PS/2 Generic Mouse: (accel) acceleration factor: 2.000
[    26.077] (**) PS/2 Generic Mouse: (accel) acceleration threshold: 4
[    26.077] (II) config/udev: Adding input device PS/2 Generic Mouse (/dev/input/mouse0)
[    26.077] (II) No input driver/identifier specified (ignoring)
[    26.077] (II) config/udev: Adding input device PC Speaker (/dev/input/event5)
[    26.077] (II) No input driver/identifier specified (ignoring)
[    26.078] (II) config/udev: Adding input device ACPI Virtual Keyboard Device (/dev/input/event20)
[    26.078] (**) ACPI Virtual Keyboard Device: Applying InputClass "evdev keyboard catchall"
[    26.078] (II) Using input driver 'evdev' for 'ACPI Virtual Keyboard Device'
[    26.078] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    26.078] (**) ACPI Virtual Keyboard Device: always reports core events
[    26.078] (**) ACPI Virtual Keyboard Device: Device: "/dev/input/event20"
[    26.078] (--) ACPI Virtual Keyboard Device: Found keys
[    26.078] (II) ACPI Virtual Keyboard Device: Configuring as keyboard
[    26.078] (**) Option "config_info" "udev:/sys/devices/virtual/input/input20/event20"
[    26.078] (II) XINPUT: Adding extended input device "ACPI Virtual Keyboard Device" (type: KEYBOARD)
[    26.078] (**) Option "xkb_rules" "evdev"
[    26.078] (**) Option "xkb_model" "geniuskb19e"
[    26.078] (**) Option "xkb_layout" "fr,brai"
[    26.078] (**) Option "xkb_variant" "oss,"
[    26.078] (**) Option "xkb_options" "compose:lwin,compose:rwin,nbsp:level3n,grp:shift_caps_toggle,grp_led:scroll,terminate:ctrl_alt_bksp"
[    26.079] (II) config/udev: Adding input device Dell WMI hotkeys (/dev/input/event6)
[    26.079] (**) Dell WMI hotkeys: Applying InputClass "evdev keyboard catchall"
[    26.079] (II) Using input driver 'evdev' for 'Dell WMI hotkeys'
[    26.079] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    26.079] (**) Dell WMI hotkeys: always reports core events
[    26.079] (**) Dell WMI hotkeys: Device: "/dev/input/event6"
[    26.079] (--) Dell WMI hotkeys: Found keys
[    26.079] (II) Dell WMI hotkeys: Configuring as keyboard
[    26.079] (**) Option "config_info" "udev:/sys/devices/virtual/input/input6/event6"
[    26.079] (II) XINPUT: Adding extended input device "Dell WMI hotkeys" (type: KEYBOARD)
[    26.079] (**) Option "xkb_rules" "evdev"
[    26.079] (**) Option "xkb_model" "geniuskb19e"
[    26.079] (**) Option "xkb_layout" "fr,brai"
[    26.079] (**) Option "xkb_variant" "oss,"
[    26.079] (**) Option "xkb_options" "compose:lwin,compose:rwin,nbsp:level3n,grp:shift_caps_toggle,grp_led:scroll,terminate:ctrl_alt_bksp"
[    28.016] (II) Power Button: Close
[    28.016] (II) UnloadModule: "evdev"
[    28.016] (II) Unloading evdev
[    28.112] (II) Video Bus: Close
[    28.112] (II) UnloadModule: "evdev"
[    28.112] (II) Unloading evdev
[    28.176] (II) Video Bus: Close
[    28.176] (II) UnloadModule: "evdev"
[    28.176] (II) Unloading evdev
[    28.212] (II) Power Button: Close
[    28.212] (II) UnloadModule: "evdev"
[    28.212] (II) Unloading evdev
[    28.212] (II) Sleep Button: Close
[    28.212] (II) UnloadModule: "evdev"
[    28.212] (II) Unloading evdev
[    28.212] (II) Dell Dell USB Optical Mouse: Close
[    28.212] (II) UnloadModule: "evdev"
[    28.212] (II) Unloading evdev
[    28.212] (II) Dell Dell USB Keyboard: Close
[    28.212] (II) UnloadModule: "evdev"
[    28.212] (II) Unloading evdev
[    28.212] (II) AT Translated Set 2 keyboard: Close
[    28.212] (II) UnloadModule: "evdev"
[    28.213] (II) Unloading evdev
[    28.213] (II) PS/2 Generic Mouse: Close
[    28.213] (II) UnloadModule: "evdev"
[    28.213] (II) Unloading evdev
[    28.213] (II) ACPI Virtual Keyboard Device: Close
[    28.213] (II) UnloadModule: "evdev"
[    28.213] (II) Unloading evdev
[    28.213] (II) Dell WMI hotkeys: Close
[    28.213] (II) UnloadModule: "evdev"
[    28.213] (II) Unloading evdev

--W/nzBZO5zC0uMSeA--

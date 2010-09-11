Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832Ab0IKWNt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 18:13:49 -0400
Received: from cs-studio.ru ([195.178.208.66]:49451 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752718Ab0IKWNo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 18:13:44 -0400
Date: Sun, 12 Sep 2010 02:13:41 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        David Airlie <airlied@linux.ie>
Subject: Re: i915 blank screen and crash
Message-ID: <20100911221341.GA3289@ioremap.net>
References: <20100911184646.GA27154@ioremap.net> <89kc63$i1vccu@fmsmga002.fm.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="vtzGhvizbBRQ85DL"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <89kc63$i1vccu@fmsmga002.fm.intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Chris.

On Sat, Sep 11, 2010 at 08:45:34PM +0100, Chris Wilson (chris@chris-wilson.co.uk) wrote:
> An eDP panel, yes we are indeed continuing to debug the link configuration
> on those machines.
> 
> The current set of patches we have for eDP are available at
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/ickle/drm-intel.git
> 
> in the drm-intel-next branch. Jesse insists that he has a working eDP
> machine on his desk, so maybe there is hope yet.

Nope, hope quickly dissapears in the dark - I installed this version and
get blank screen after boot. nomodeset + vesa and failsafe X session
work.

dmesg and X log during failed session attached.

-- 
	Evgeniy Polyakov

--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.36-rc3-drm+ (root@gavana) (gcc version 4.4.3 (Ubuntu 4.4.3-4ubuntu5) ) #3 SMP Sun Sep 12 02:00:28 MSD 2010
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-2.6.36-rc3-drm+ root=UUID=3e0770ae-e3de-4db5-9c15-2a058ad91585 ro
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009ac00 (usable)
[    0.000000]  BIOS-e820: 000000000009ac00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000db65f000 (usable)
[    0.000000]  BIOS-e820: 00000000db65f000 - 00000000db67f000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000db67f000 - 00000000db76f000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000db76f000 - 00000000dc000000 (reserved)
[    0.000000]  BIOS-e820: 00000000dde00000 - 00000000e0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000f8000000 - 00000000fc000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed10000 - 00000000fed14000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed18000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff800000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000011c000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.6 present.
[    0.000000] e820 update range: 0000000000000000 - 0000000000001000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x11c000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 080000000 mask FC0000000 write-back
[    0.000000]   2 base 0C0000000 mask FE0000000 write-back
[    0.000000]   3 base 0DC000000 mask FFC000000 uncachable
[    0.000000]   4 base 100000000 mask FE0000000 write-back
[    0.000000]   5 base 11C000000 mask FFC000000 uncachable
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000dc000000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xdb65f max_arch_pfn = 0x400000000
[    0.000000] e820 update range: 0000000000001000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 000000000009ac00 (usable)
[    0.000000]  modified: 000000000009ac00 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 00000000db65f000 (usable)
[    0.000000]  modified: 00000000db65f000 - 00000000db67f000 (ACPI data)
[    0.000000]  modified: 00000000db67f000 - 00000000db76f000 (ACPI NVS)
[    0.000000]  modified: 00000000db76f000 - 00000000dc000000 (reserved)
[    0.000000]  modified: 00000000dde00000 - 00000000e0000000 (reserved)
[    0.000000]  modified: 00000000f8000000 - 00000000fc000000 (reserved)
[    0.000000]  modified: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  modified: 00000000fed10000 - 00000000fed14000 (reserved)
[    0.000000]  modified: 00000000fed18000 - 00000000fed1a000 (reserved)
[    0.000000]  modified: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  modified: 00000000ff800000 - 0000000100000000 (reserved)
[    0.000000]  modified: 0000000100000000 - 000000011c000000 (usable)
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] found SMP MP-table at [ffff8800000f2280] f2280
[    0.000000] init_memory_mapping: 0000000000000000-00000000db65f000
[    0.000000]  0000000000 - 00db600000 page 2M
[    0.000000]  00db600000 - 00db65f000 page 4k
[    0.000000] kernel direct mapping tables up to db65f000 @ 16000-1c000
[    0.000000] init_memory_mapping: 0000000100000000-000000011c000000
[    0.000000]  0100000000 - 011c000000 page 2M
[    0.000000] kernel direct mapping tables up to 11c000000 @ 1a000-20000
[    0.000000] RAMDISK: 37261000 - 37ff0000
[    0.000000] ACPI: RSDP 00000000000fe300 00024 (v02 DELL  )
[    0.000000] ACPI: XSDT 00000000db67de18 0005C (v01 DELL    E2      06222004 MSFT 00010013)
[    0.000000] ACPI: FACP 00000000db75fc18 000F4 (v04 DELL    E2      06222004 MSFT 00010013)
[    0.000000] ACPI Warning: 32/64 FACS address mismatch in FADT - two FACS tables! (20100702/tbfadt-369)
[    0.000000] ACPI Warning: 32/64X FACS address mismatch in FADT - 0xDB76BF40/0x00000000DB76ED40, using 32 (20100702/tbfadt-486)
[    0.000000] ACPI: DSDT 00000000db750018 09760 (v01 DELL    E2      00001001 INTL 20080729)
[    0.000000] ACPI: FACS 00000000db76bf40 00040
[    0.000000] ACPI: APIC 00000000db67cf18 0008C (v02 DELL    E2      06222004 MSFT 00010013)
[    0.000000] ACPI: MCFG 00000000db76dd18 0003C (v01 A M I  GMCH945. 06222004 MSFT 00000097)
[    0.000000] ACPI: HPET 00000000db76dc98 00038 (v01 DELL    E2      00000001 ASL  00000061)
[    0.000000] ACPI: BOOT 00000000db76dc18 00028 (v01 DELL   E2       06222004 AMI  00010013)
[    0.000000] ACPI: SLIC 00000000db766818 00176 (v03 DELL    E2      06222004 MSFT 00010013)
[    0.000000] ACPI: SSDT 00000000db75e018 009F1 (v01  PmRef    CpuPm 00003000 INTL 20080729)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000011c000000
[    0.000000] Initmem setup node 0 0000000000000000-000000011c000000
[    0.000000]   NODE_DATA [0000000100000000 - 0000000100004fff]
[    0.000000]  [ffffea0000000000-ffffea0003ffffff] PMD -> [ffff880100200000-ffff880103bfffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x0011c000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009a
[    0.000000]     0: 0x00000100 -> 0x000db65f
[    0.000000]     0: 0x00100000 -> 0x0011c000
[    0.000000] On node 0 totalpages: 1013225
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3922 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 880279 pages, LIFO batch:31
[    0.000000]   Normal zone: 1568 pages used for memmap
[    0.000000]   Normal zone: 113120 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x04] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x05] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x06] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] disabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] SMP: Allowing 8 CPUs, 4 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] early_res array is doubled to 64 at [1b000 - 1b7ff]
[    0.000000] PM: Registered nosave memory: 000000000009a000 - 000000000009b000
[    0.000000] PM: Registered nosave memory: 000000000009b000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000db65f000 - 00000000db67f000
[    0.000000] PM: Registered nosave memory: 00000000db67f000 - 00000000db76f000
[    0.000000] PM: Registered nosave memory: 00000000db76f000 - 00000000dc000000
[    0.000000] PM: Registered nosave memory: 00000000dc000000 - 00000000dde00000
[    0.000000] PM: Registered nosave memory: 00000000dde00000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f8000000
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
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ff800000
[    0.000000] PM: Registered nosave memory: 00000000ff800000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at e0000000 (gap: e0000000:18000000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff880001e00000 s88384 r8192 d22208 u262144
[    0.000000] early_res array is doubled to 128 at [1b800 - 1c7ff]
[    0.000000] pcpu-alloc: s88384 r8192 d22208 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 997321
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-2.6.36-rc3-drm+ root=UUID=3e0770ae-e3de-4db5-9c15-2a058ad91585 ro
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Subtract (65 early reservations)
[    0.000000]   #1 [0001000000 - 0001d1faa0]   TEXT DATA BSS
[    0.000000]   #2 [0037261000 - 0037ff0000]         RAMDISK
[    0.000000]   #3 [0001d20000 - 0001d20251]             BRK
[    0.000000]   #4 [000009ac00 - 00000f2280]   BIOS reserved
[    0.000000]   #5 [00000f2280 - 00000f2290]    MP-table mpf
[    0.000000]   #6 [00000f2438 - 0000100000]   BIOS reserved
[    0.000000]   #7 [00000f2290 - 00000f2438]    MP-table mpc
[    0.000000]   #8 [0000010000 - 0000012000]      TRAMPOLINE
[    0.000000]   #9 [0000012000 - 0000016000]     ACPI WAKEUP
[    0.000000]   #10 [0000016000 - 000001a000]         PGTABLE
[    0.000000]   #11 [000001a000 - 000001b000]         PGTABLE
[    0.000000]   #12 [0100000000 - 0100005000]       NODE_DATA
[    0.000000]   #13 [0001d20280 - 0001d21280]         BOOTMEM
[    0.000000]   #14 [0001d1fac0 - 0001d1fdc0]         BOOTMEM
[    0.000000]   #15 [0100005000 - 0100006000]         BOOTMEM
[    0.000000]   #16 [0100006000 - 0100007000]         BOOTMEM
[    0.000000]   #17 [0100200000 - 0103c00000]        MEMMAP 0
[    0.000000]   #18 [0001d1fdc0 - 0001d1ff40]         BOOTMEM
[    0.000000]   #19 [0001d21280 - 0001d39280]         BOOTMEM
[    0.000000]   #20 [0001d39280 - 0001d3c280]         BOOTMEM
[    0.000000]   #21 [0001d3d000 - 0001d3e000]         BOOTMEM
[    0.000000]   #22 [0001d1ff40 - 0001d1ff81]         BOOTMEM
[    0.000000]   #23 [0001d3c280 - 0001d3c2c3]         BOOTMEM
[    0.000000]   #24 [0001d3c300 - 0001d3c6b8]         BOOTMEM
[    0.000000]   #25 [0001d3c6c0 - 0001d3c728]         BOOTMEM
[    0.000000]   #26 [0001d3c740 - 0001d3c7a8]         BOOTMEM
[    0.000000]   #27 [0001d3c7c0 - 0001d3c828]         BOOTMEM
[    0.000000]   #28 [0001d3c840 - 0001d3c8a8]         BOOTMEM
[    0.000000]   #29 [0001d3c8c0 - 0001d3c928]         BOOTMEM
[    0.000000]   #30 [0001d3c940 - 0001d3c9a8]         BOOTMEM
[    0.000000]   #31 [0001d3c9c0 - 0001d3ca28]         BOOTMEM
[    0.000000]   #32 [0001d3ca40 - 0001d3caa8]         BOOTMEM
[    0.000000]   #33 [0001d3cac0 - 0001d3cb28]         BOOTMEM
[    0.000000]   #34 [0001d3cb40 - 0001d3cba8]         BOOTMEM
[    0.000000]   #35 [0001d3cbc0 - 0001d3cc28]         BOOTMEM
[    0.000000]   #36 [0001d3cc40 - 0001d3cca8]         BOOTMEM
[    0.000000]   #37 [0001d3ccc0 - 0001d3cd28]         BOOTMEM
[    0.000000]   #38 [0001d3cd40 - 0001d3cda8]         BOOTMEM
[    0.000000]   #39 [0001d3cdc0 - 0001d3ce28]         BOOTMEM
[    0.000000]   #40 [0001d3ce40 - 0001d3cea8]         BOOTMEM
[    0.000000]   #41 [0001d1ffc0 - 0001d1ffe0]         BOOTMEM
[    0.000000]   #42 [0001d3cec0 - 0001d3cee0]         BOOTMEM
[    0.000000]   #43 [0001d3cf00 - 0001d3cf5b]         BOOTMEM
[    0.000000]   #44 [0001d3cf80 - 0001d3cfdb]         BOOTMEM
[    0.000000]   #45 [0001e00000 - 0001e1d000]         BOOTMEM
[    0.000000]   #46 [0001e40000 - 0001e5d000]         BOOTMEM
[    0.000000]   #47 [0001e80000 - 0001e9d000]         BOOTMEM
[    0.000000]   #48 [0001ec0000 - 0001edd000]         BOOTMEM
[    0.000000]   #49 [0001f00000 - 0001f1d000]         BOOTMEM
[    0.000000]   #50 [0001f40000 - 0001f5d000]         BOOTMEM
[    0.000000]   #51 [0001f80000 - 0001f9d000]         BOOTMEM
[    0.000000]   #52 [0001fc0000 - 0001fdd000]         BOOTMEM
[    0.000000]   #53 [0001d40000 - 0001d40008]         BOOTMEM
[    0.000000]   #54 [0001d40040 - 0001d40048]         BOOTMEM
[    0.000000]   #55 [0001d40080 - 0001d400a0]         BOOTMEM
[    0.000000]   #56 [0001d400c0 - 0001d40100]         BOOTMEM
[    0.000000]   #57 [0001d40100 - 0001d40220]         BOOTMEM
[    0.000000]   #58 [0001d40240 - 0001d40288]         BOOTMEM
[    0.000000]   #59 [0001d402c0 - 0001d40308]         BOOTMEM
[    0.000000]   #60 [0001d40340 - 0001d48340]         BOOTMEM
[    0.000000]   #61 [0001fdd000 - 0005fdd000]         BOOTMEM
[    0.000000]   #62 [0001d48340 - 0001d68340]         BOOTMEM
[    0.000000]   #63 [0001d68340 - 0001da8340]         BOOTMEM
[    0.000000]   #64 [000001c800 - 0000024800]         BOOTMEM
[    0.000000] Memory: 3899072k/4653056k available (5669k kernel code, 600156k absent, 153828k reserved, 5441k data, 904k init)
[    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU-based detection of stalled CPUs is disabled.
[    0.000000] 	Verbose stalled-CPUs detection is disabled.
[    0.000000] NR_IRQS:4352 nr_irqs:744
[    0.000000] Extended CMOS year: 2000
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 41943040 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.010000] Detected 2526.845 MHz processor.
[    0.000007] Calibrating delay loop (skipped), value calculated using timer frequency.. 5053.69 BogoMIPS (lpj=25268450)
[    0.000122] pid_max: default: 32768 minimum: 301
[    0.000192] Security Framework initialized
[    0.000259] AppArmor: AppArmor initialized
[    0.000643] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.001663] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.002129] Mount-cache hash table entries: 256
[    0.002279] Initializing cgroup subsys ns
[    0.002335] Initializing cgroup subsys cpuacct
[    0.002391] Initializing cgroup subsys memory
[    0.002448] Initializing cgroup subsys devices
[    0.002504] Initializing cgroup subsys freezer
[    0.002559] Initializing cgroup subsys net_cls
[    0.002632] CPU: Physical Processor ID: 0
[    0.002686] CPU: Processor Core ID: 0
[    0.002742] mce: CPU supports 9 MCE banks
[    0.002801] CPU0: Thermal monitoring handled by SMI
[    0.002808] using mwait in idle threads.
[    0.002861] Performance Events: PEBS fmt1+, Westmere events, Intel PMU driver.
[    0.003014] ... version:                3
[    0.003067] ... bit width:              48
[    0.003121] ... generic registers:      4
[    0.003173] ... value mask:             0000ffffffffffff
[    0.003229] ... max period:             000000007fffffff
[    0.003283] ... fixed-purpose events:   3
[    0.003337] ... event mask:             000000070000000f
[    0.005244] ACPI: Core revision 20100702
[    0.017753] ftrace: converting mcount calls to 0f 1f 44 00 00
[    0.017820] ftrace: allocating 21484 entries in 85 pages
[    0.023966] Setting APIC routing to flat
[    0.024343] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=0 pin2=0
[    0.124354] CPU0: Intel(R) Core(TM) i5 CPU       M 540  @ 2.53GHz stepping 02
[    0.243548] Booting Node   0, Processors  #1
[    0.403336] CPU1: Thermal monitoring handled by SMI
[    0.423492]  #2
[    0.583236] CPU2: Thermal monitoring handled by SMI
[    0.603431]  #3
[    0.763133] CPU3: Thermal monitoring handled by SMI
[    0.783212] Brought up 4 CPUs
[    0.783322] Total of 4 processors activated (20215.60 BogoMIPS).
[    0.784952] devtmpfs: initialized
[    0.785820] regulator: core version 0.5
[    0.785905] Time: 22:07:42  Date: 09/11/10
[    0.785992] NET: Registered protocol family 16
[    0.786128] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.786226] ACPI: bus type pci registered
[    0.786345] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.786449] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.793044] PCI: Using configuration type 1 for base access
[    0.793609] bio: create slab <bio-0> at 0
[    0.794983] ACPI: EC: Look up EC in DSDT
[    0.801699] ACPI: BIOS _OSI(Linux) query ignored
[    0.813236] ACPI: BIOS _OSI(Linux) query ignored
[    0.819368] ACPI: SSDT 00000000db7ea918 00432 (v01  PmRef  Cpu0Ist 00003000 INTL 20080729)
[    0.819812] ACPI: Dynamic OEM Table Load:
[    0.819921] ACPI: SSDT (null) 00432 (v01  PmRef  Cpu0Ist 00003000 INTL 20080729)
[    0.820420] ACPI: SSDT 00000000db7e8018 00891 (v01  PmRef  Cpu0Cst 00003001 INTL 20080729)
[    0.820846] ACPI: Dynamic OEM Table Load:
[    0.820956] ACPI: SSDT (null) 00891 (v01  PmRef  Cpu0Cst 00003001 INTL 20080729)
[    0.821497] ACPI: SSDT 00000000db7e9a98 00303 (v01  PmRef    ApIst 00003000 INTL 20080729)
[    0.821974] ACPI: Dynamic OEM Table Load:
[    0.822082] ACPI: SSDT (null) 00303 (v01  PmRef    ApIst 00003000 INTL 20080729)
[    0.822354] ACPI: SSDT 00000000db7e7d98 00119 (v01  PmRef    ApCst 00003000 INTL 20080729)
[    0.822806] ACPI: Dynamic OEM Table Load:
[    0.822916] ACPI: SSDT (null) 00119 (v01  PmRef    ApCst 00003000 INTL 20080729)
[    0.824893] ACPI: Interpreter enabled
[    0.824957] ACPI: (supports S0 S3 S4 S5)
[    0.825132] ACPI: Using IOAPIC for interrupt routing
[    0.838424] ACPI: EC: GPE = 0x10, I/O: command/status = 0x934, data = 0x930
[    0.839295] ACPI: No dock devices found.
[    0.839356] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.840138] \_SB_.PCI0:_OSC invalid UUID
[    0.840140] _OSC request data:1 8 1f 
[    0.840143] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
[    0.841409] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.841478] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.841545] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.841639] pci_root PNP0A08:00: host bridge window [mem 0xe0000000-0xfeafffff]
[    0.841775] pci 0000:00:02.0: reg 10: [mem 0xf0000000-0xf03fffff 64bit]
[    0.841781] pci 0000:00:02.0: reg 18: [mem 0xe0000000-0xefffffff 64bit pref]
[    0.841785] pci 0000:00:02.0: reg 20: [io  0x60b0-0x60b7]
[    0.841871] pci 0000:00:19.0: reg 10: [mem 0xf5400000-0xf541ffff]
[    0.841882] pci 0000:00:19.0: reg 14: [mem 0xf5480000-0xf5480fff]
[    0.841893] pci 0000:00:19.0: reg 18: [io  0x6040-0x605f]
[    0.841961] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.841965] pci 0000:00:19.0: PME# disabled
[    0.842016] pci 0000:00:1a.0: reg 10: [mem 0xf5470000-0xf54703ff]
[    0.842101] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.842106] pci 0000:00:1a.0: PME# disabled
[    0.842153] pci 0000:00:1b.0: reg 10: [mem 0xf5460000-0xf5463fff 64bit]
[    0.842229] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.842234] pci 0000:00:1b.0: PME# disabled
[    0.842334] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.842339] pci 0000:00:1c.0: PME# disabled
[    0.842440] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.842444] pci 0000:00:1c.1: PME# disabled
[    0.842546] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.842551] pci 0000:00:1c.2: PME# disabled
[    0.842654] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.842658] pci 0000:00:1c.3: PME# disabled
[    0.842718] pci 0000:00:1d.0: reg 10: [mem 0xf5450000-0xf54503ff]
[    0.842804] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.842808] pci 0000:00:1d.0: PME# disabled
[    0.843042] pci 0000:00:1f.2: reg 10: [io  0x6090-0x6097]
[    0.843053] pci 0000:00:1f.2: reg 14: [io  0x6080-0x6083]
[    0.843063] pci 0000:00:1f.2: reg 18: [io  0x6070-0x6077]
[    0.843075] pci 0000:00:1f.2: reg 1c: [io  0x6060-0x6063]
[    0.843085] pci 0000:00:1f.2: reg 20: [io  0x6020-0x603f]
[    0.843096] pci 0000:00:1f.2: reg 24: [mem 0xf5440000-0xf54407ff]
[    0.843143] pci 0000:00:1f.2: PME# supported from D3hot
[    0.843148] pci 0000:00:1f.2: PME# disabled
[    0.843187] pci 0000:00:1f.3: reg 10: [mem 0xf5430000-0xf54300ff 64bit]
[    0.843220] pci 0000:00:1f.3: reg 20: [io  0x6000-0x601f]
[    0.843290] pci 0000:00:1f.6: reg 10: [mem 0xf5420000-0xf5420fff 64bit]
[    0.843426] pci 0000:00:1c.0: PCI bridge to [bus 01-01]
[    0.843494] pci 0000:00:1c.0:   bridge window [io  0x5000-0x5fff]
[    0.843498] pci 0000:00:1c.0:   bridge window [mem 0xf4000000-0xf53fffff]
[    0.843505] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.843673] pci 0000:02:00.0: reg 10: [mem 0xf2c00000-0xf2c01fff 64bit]
[    0.843862] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    0.843889] pci 0000:02:00.0: PME# disabled
[    0.843945] pci 0000:00:1c.1: PCI bridge to [bus 02-02]
[    0.844012] pci 0000:00:1c.1:   bridge window [io  0x4000-0x4fff]
[    0.844017] pci 0000:00:1c.1:   bridge window [mem 0xf2c00000-0xf3ffffff]
[    0.844024] pci 0000:00:1c.1:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.844168] pci 0000:03:00.0: reg 10: [mem 0xf1800000-0xf18000ff]
[    0.844302] pci 0000:03:00.0: supports D1 D2
[    0.844303] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.844309] pci 0000:03:00.0: PME# disabled
[    0.844337] pci 0000:00:1c.2: PCI bridge to [bus 03-03]
[    0.844403] pci 0000:00:1c.2:   bridge window [io  0x3000-0x3fff]
[    0.844407] pci 0000:00:1c.2:   bridge window [mem 0xf1800000-0xf2bfffff]
[    0.844414] pci 0000:00:1c.2:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.844470] pci 0000:00:1c.3: PCI bridge to [bus 04-09]
[    0.844534] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    0.844539] pci 0000:00:1c.3:   bridge window [mem 0xf0400000-0xf17fffff]
[    0.844546] pci 0000:00:1c.3:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.844616] pci 0000:00:1e.0: PCI bridge to [bus 0a-0a] (subtractive decode)
[    0.844687] pci 0000:00:1e.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.844692] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.844699] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.844701] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.844703] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.844705] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.844706] pci 0000:00:1e.0:   bridge window [mem 0xe0000000-0xfeafffff] (subtractive decode)
[    0.844737] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.844879] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.844979] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.845038] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    0.845096] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
[    0.845157] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP04._PRT]
[    0.845289] \_SB_.PCI0:_OSC invalid UUID
[    0.845291] _OSC request data:1 19 1f 
[    0.845338] \_SB_.PCI0:_OSC invalid UUID
[    0.845339] _OSC request data:1 0 1f 
[    0.845341] Unable to assume PCIe control: Disabling ASPM
[    0.848233] ACPI: PCI Root Bridge [CPBG] (domain 0000 [bus 3f])
[    0.848460] Unable to assume PCIe control: Disabling ASPM
[    0.848702] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
[    0.849168] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    0.849581] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 *10 12 14 15)
[    0.849990] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
[    0.850451] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 *5 6 7 10 12 14 15)
[    0.850863] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
[    0.851357] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 *3 4 5 6 7 10 12 14 15)
[    0.851772] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
[    0.852229] HEST: Table is not found!
[    0.852336] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.852441] vgaarb: loaded
[    0.852585] SCSI subsystem initialized
[    0.852674] libata version 3.00 loaded.
[    0.852706] usbcore: registered new interface driver usbfs
[    0.852777] usbcore: registered new interface driver hub
[    0.852860] usbcore: registered new device driver usb
[    0.853069] ACPI: WMI: Mapper loaded
[    0.853128] PCI: Using ACPI for IRQ routing
[    0.853187] PCI: pci_cache_line_size set to 64 bytes
[    0.853404] reserve RAM buffer: 000000000009ac00 - 000000000009ffff 
[    0.853405] reserve RAM buffer: 00000000db65f000 - 00000000dbffffff 
[    0.853470] NetLabel: Initializing
[    0.853529] NetLabel:  domain hash size = 128
[    0.853590] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.853661] NetLabel:  unlabeled traffic allowed by default
[    0.853759] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.854047] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.856127] Switching to clocksource tsc
[    0.860604] AppArmor: AppArmor Filesystem Enabled
[    0.860684] pnp: PnP ACPI init
[    0.860760] ACPI: bus type pnp registered
[    0.863302]   alloc irq_desc for 23 on node 0
[    0.863304]   alloc kstat_irqs on node 0
[    0.866648] pnp: PnP ACPI: found 13 devices
[    0.866711] ACPI: ACPI bus type pnp unregistered
[    0.866936] system 00:05: [io  0x0680-0x069f] has been reserved
[    0.867004] system 00:05: [io  0x1000-0x1003] has been reserved
[    0.867072] system 00:05: [io  0x1004-0x1013] has been reserved
[    0.867289] system 00:05: [io  0xffff] has been reserved
[    0.867353] system 00:05: [io  0x0400-0x047f] has been reserved
[    0.867421] system 00:05: [io  0x0500-0x057f] has been reserved
[    0.867485] system 00:05: [io  0x164e-0x164f] has been reserved
[    0.867553] system 00:0a: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.867623] system 00:0a: [mem 0xfed10000-0xfed13fff] has been reserved
[    0.867691] system 00:0a: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.867757] system 00:0a: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.867827] system 00:0a: [mem 0xf8000000-0xfbffffff] has been reserved
[    0.867894] system 00:0a: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.867963] system 00:0a: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.868031] system 00:0a: [mem 0xff000000-0xffffffff] could not be reserved
[    0.868100] system 00:0a: [mem 0xfee00000-0xfeefffff] could not be reserved
[    0.868171] system 00:0a: [mem 0xf54c0000-0xf54c0fff] has been reserved
[    0.873713] pci 0000:00:1c.0: BAR 15: assigned [mem 0xf5500000-0xf56fffff 64bit pref]
[    0.873811] pci 0000:00:1c.1: BAR 15: assigned [mem 0xf5700000-0xf58fffff 64bit pref]
[    0.873906] pci 0000:00:1c.2: BAR 15: assigned [mem 0xf5900000-0xf5afffff 64bit pref]
[    0.874001] pci 0000:00:1c.3: BAR 15: assigned [mem 0xf5b00000-0xf5cfffff 64bit pref]
[    0.874097] pci 0000:00:1c.0: PCI bridge to [bus 01-01]
[    0.874164] pci 0000:00:1c.0:   bridge window [io  0x5000-0x5fff]
[    0.874234] pci 0000:00:1c.0:   bridge window [mem 0xf4000000-0xf53fffff]
[    0.874887] pci 0000:00:1c.0:   bridge window [mem 0xf5500000-0xf56fffff 64bit pref]
[    0.874987] pci 0000:00:1c.1: PCI bridge to [bus 02-02]
[    0.875051] pci 0000:00:1c.1:   bridge window [io  0x4000-0x4fff]
[    0.875123] pci 0000:00:1c.1:   bridge window [mem 0xf2c00000-0xf3ffffff]
[    0.875195] pci 0000:00:1c.1:   bridge window [mem 0xf5700000-0xf58fffff 64bit pref]
[    0.875294] pci 0000:00:1c.2: PCI bridge to [bus 03-03]
[    0.875357] pci 0000:00:1c.2:   bridge window [io  0x3000-0x3fff]
[    0.875427] pci 0000:00:1c.2:   bridge window [mem 0xf1800000-0xf2bfffff]
[    0.875497] pci 0000:00:1c.2:   bridge window [mem 0xf5900000-0xf5afffff 64bit pref]
[    0.875600] pci 0000:00:1c.3: PCI bridge to [bus 04-09]
[    0.875666] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    0.875735] pci 0000:00:1c.3:   bridge window [mem 0xf0400000-0xf17fffff]
[    0.875808] pci 0000:00:1c.3:   bridge window [mem 0xf5b00000-0xf5cfffff 64bit pref]
[    0.875906] pci 0000:00:1e.0: PCI bridge to [bus 0a-0a]
[    0.875969] pci 0000:00:1e.0:   bridge window [io  disabled]
[    0.876036] pci 0000:00:1e.0:   bridge window [mem disabled]
[    0.876104] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    0.876188]   alloc irq_desc for 16 on node -1
[    0.876190]   alloc kstat_irqs on node -1
[    0.876194] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.876264] pci 0000:00:1c.0: setting latency timer to 64
[    0.876274]   alloc irq_desc for 17 on node -1
[    0.876275]   alloc kstat_irqs on node -1
[    0.876278] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.876348] pci 0000:00:1c.1: setting latency timer to 64
[    0.876358]   alloc irq_desc for 18 on node -1
[    0.876359]   alloc kstat_irqs on node -1
[    0.876362] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.876434] pci 0000:00:1c.2: setting latency timer to 64
[    0.876443]   alloc irq_desc for 19 on node -1
[    0.876444]   alloc kstat_irqs on node -1
[    0.876447] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    0.876519] pci 0000:00:1c.3: setting latency timer to 64
[    0.876527] pci 0000:00:1e.0: setting latency timer to 64
[    0.876531] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.876533] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.876534] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.876536] pci_bus 0000:00: resource 7 [mem 0xe0000000-0xfeafffff]
[    0.876538] pci_bus 0000:01: resource 0 [io  0x5000-0x5fff]
[    0.876539] pci_bus 0000:01: resource 1 [mem 0xf4000000-0xf53fffff]
[    0.876541] pci_bus 0000:01: resource 2 [mem 0xf5500000-0xf56fffff 64bit pref]
[    0.876543] pci_bus 0000:02: resource 0 [io  0x4000-0x4fff]
[    0.876544] pci_bus 0000:02: resource 1 [mem 0xf2c00000-0xf3ffffff]
[    0.876546] pci_bus 0000:02: resource 2 [mem 0xf5700000-0xf58fffff 64bit pref]
[    0.876548] pci_bus 0000:03: resource 0 [io  0x3000-0x3fff]
[    0.876549] pci_bus 0000:03: resource 1 [mem 0xf1800000-0xf2bfffff]
[    0.876551] pci_bus 0000:03: resource 2 [mem 0xf5900000-0xf5afffff 64bit pref]
[    0.876553] pci_bus 0000:04: resource 0 [io  0x2000-0x2fff]
[    0.876554] pci_bus 0000:04: resource 1 [mem 0xf0400000-0xf17fffff]
[    0.876556] pci_bus 0000:04: resource 2 [mem 0xf5b00000-0xf5cfffff 64bit pref]
[    0.876558] pci_bus 0000:0a: resource 4 [io  0x0000-0x0cf7]
[    0.876559] pci_bus 0000:0a: resource 5 [io  0x0d00-0xffff]
[    0.876561] pci_bus 0000:0a: resource 6 [mem 0x000a0000-0x000bffff]
[    0.876563] pci_bus 0000:0a: resource 7 [mem 0xe0000000-0xfeafffff]
[    0.876591] NET: Registered protocol family 2
[    0.876771] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.877746] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.880113] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.880456] TCP: Hash tables configured (established 524288 bind 65536)
[    0.880523] TCP reno registered
[    0.880587] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.880683] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.880866] NET: Registered protocol family 1
[    0.880946] pci 0000:00:02.0: Boot video device
[    0.881121] PCI: CLS 64 bytes, default 64
[    0.881168] Trying to unpack rootfs image as initramfs...
[    1.115052] Freeing initrd memory: 13884k freed
[    1.118026] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    1.118102] Placing 64MB software IO TLB between ffff880001fdd000 - ffff880005fdd000
[    1.118197] software IO TLB at phys 0x1fdd000 - 0x5fdd000
[    1.118304] Simple Boot Flag at 0xf1 set to 0x1
[    1.118584] Scanning for low memory corruption every 60 seconds
[    1.118785] audit: initializing netlink socket (disabled)
[    1.118859] type=2000 audit(1284242861.970:1): initialized
[    1.130609] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.131660] VFS: Disk quotas dquot_6.5.2
[    1.131758] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.132249] fuse init (API version 7.15)
[    1.132369] msgmni has been set to 7642
[    1.132564] alg: No test for stdrng (krng)
[    1.132665] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    1.132760] io scheduler noop registered
[    1.132821] io scheduler deadline registered
[    1.132907] io scheduler cfq registered (default)
[    1.133063] pcieport 0000:00:1c.0: setting latency timer to 64
[    1.133109]   alloc irq_desc for 40 on node -1
[    1.133110]   alloc kstat_irqs on node -1
[    1.133123] pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
[    1.133204] pcieport 0000:00:1c.1: setting latency timer to 64
[    1.133245]   alloc irq_desc for 41 on node -1
[    1.133246]   alloc kstat_irqs on node -1
[    1.133254] pcieport 0000:00:1c.1: irq 41 for MSI/MSI-X
[    1.133330] pcieport 0000:00:1c.2: setting latency timer to 64
[    1.133371]   alloc irq_desc for 42 on node -1
[    1.133372]   alloc kstat_irqs on node -1
[    1.133380] pcieport 0000:00:1c.2: irq 42 for MSI/MSI-X
[    1.133456] pcieport 0000:00:1c.3: setting latency timer to 64
[    1.133496]   alloc irq_desc for 43 on node -1
[    1.133497]   alloc kstat_irqs on node -1
[    1.133505] pcieport 0000:00:1c.3: irq 43 for MSI/MSI-X
[    1.133584] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.133753] \_SB_.PCI0:_OSC invalid UUID
[    1.133754] _OSC request data:1 0 1f 
[    1.133813] \_SB_.PCI0:_OSC invalid UUID
[    1.133814] _OSC request data:1 0 1f 
[    1.133866] \_SB_.PCI0:_OSC invalid UUID
[    1.133867] _OSC request data:1 0 1f 
[    1.133920] \_SB_.PCI0:_OSC invalid UUID
[    1.133921] _OSC request data:1 0 1f 
[    1.133985] \_SB_.PCI0:_OSC invalid UUID
[    1.133986] _OSC request data:1 0 1f 
[    1.134038] \_SB_.PCI0:_OSC invalid UUID
[    1.134039] _OSC request data:1 0 1f 
[    1.134091] \_SB_.PCI0:_OSC invalid UUID
[    1.134092] _OSC request data:1 0 1f 
[    1.134145] \_SB_.PCI0:_OSC invalid UUID
[    1.134146] _OSC request data:1 0 1f 
[    1.134155] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    1.134277] intel_idle: MWAIT substates: 0x1120
[    1.134279] intel_idle: v0.4 model 0x25
[    1.134280] intel_idle: lapic_timer_reliable_states 0xffffffff
[    1.134777] ACPI: AC Adapter [AC] (on-line)
[    1.134909] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input0
[    1.135346] ACPI: Lid Switch [LID]
[    1.135435] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input1
[    1.135537] ACPI: Power Button [PBTN]
[    1.135621] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input2
[    1.135717] ACPI: Sleep Button [SBTN]
[    1.135801] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    1.135896] ACPI: Power Button [PWRF]
[    1.136112] ACPI: acpi_idle yielding to intel_idle
[    1.140964] ERST: Table is not found!
[    1.141401] Linux agpgart interface v0.103
[    1.141481] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.142535] brd: module loaded
[    1.142949] loop: module loaded
[    1.143353] Fixed MDIO Bus: probed
[    1.143441] PPP generic driver version 2.4.2
[    1.143552] tun: Universal TUN/TAP device driver, 1.6
[    1.143617] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    1.143753] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.143853] ehci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.143976] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[    1.143980] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[    1.144082] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    1.144204] ehci_hcd 0000:00:1a.0: debug port 2
[    1.148184] ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
[    1.148199] ehci_hcd 0000:00:1a.0: irq 16, io mem 0xf5470000
[    1.160691] ACPI: Battery Slot [BAT0] (battery present)
[    1.161634] ACPI: Battery Slot [BAT1] (battery absent)
[    1.166024] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    1.166183] hub 1-0:1.0: USB hub found
[    1.166246] hub 1-0:1.0: 3 ports detected
[    1.166361] ehci_hcd 0000:00:1d.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    1.166441] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[    1.166445] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[    1.166529] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    1.166646] ehci_hcd 0000:00:1d.0: debug port 2
[    1.170597] ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
[    1.170610] ehci_hcd 0000:00:1d.0: irq 17, io mem 0xf5450000
[    1.186007] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    1.186152] hub 2-0:1.0: USB hub found
[    1.186213] hub 2-0:1.0: 3 ports detected
[    1.186315] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.186389] uhci_hcd: USB Universal Host Controller Interface driver
[    1.186522] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    1.186865] i8042.c: Warning: Keylock active.
[    1.188333] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.188398] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.188510] mice: PS/2 mouse device common for all mice
[    1.188672] rtc_cmos 00:06: RTC can wake from S4
[    1.188754] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
[    1.188858] rtc0: alarms up to one year, y3k, 242 bytes nvram, hpet irqs
[    1.189000] device-mapper: uevent: version 1.0.3
[    1.189124] device-mapper: ioctl: 4.18.0-ioctl (2010-06-29) initialised: dm-devel@redhat.com
[    1.189252] device-mapper: multipath: version 1.1.1 loaded
[    1.189316] device-mapper: multipath round-robin: version 1.0.0 loaded
[    1.189512] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
[    1.189548] cpuidle: using governor ladder
[    1.189781] cpuidle: using governor menu
[    1.190014] TCP cubic registered
[    1.190153] NET: Registered protocol family 10
[    1.190462] lo: Disabled Privacy Extensions
[    1.190659] NET: Registered protocol family 17
[    1.190732] Registering the dns_resolver key type
[    1.192214] PM: Resume from disk failed.
[    1.192223] registered taskstats version 1
[    1.192626]   Magic number: 10:244:148
[    1.192698] bdi 1:0: hash matches
[    1.192795] acpi device:19: hash matches
[    1.192931] rtc_cmos 00:06: setting system clock to 2010-09-11 22:07:42 UTC (1284242862)
[    1.193031] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    1.193100] EDD information not available.
[    1.193226] Freeing unused kernel memory: 904k freed
[    1.193451] Write protecting the kernel read-only data: 10240k
[    1.193775] Freeing unused kernel memory: 456k freed
[    1.194035] Freeing unused kernel memory: 1648k freed
[    1.208952] udev: starting version 151
[    1.209044] udevd (73): /proc/73/oom_adj is deprecated, please use /proc/73/oom_score_adj instead.
[    1.229838] e1000e: Intel(R) PRO/1000 Network Driver - 1.2.7-k2
[    1.229905] e1000e: Copyright (c) 1999 - 2010 Intel Corporation.
[    1.230004]   alloc irq_desc for 20 on node -1
[    1.230007]   alloc kstat_irqs on node -1
[    1.230018] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    1.230098] e1000e 0000:00:19.0: setting latency timer to 64
[    1.230221]   alloc irq_desc for 44 on node -1
[    1.230223]   alloc kstat_irqs on node -1
[    1.230237] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[    1.462808] e1000e 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:26:b9:e0:54:fd
[    1.462914] e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    1.463035] e1000e 0000:00:19.0: eth0: MAC: 9, PHY: 10, PBA No: 4041ff-0ff
[    1.463127] ahci 0000:00:1f.2: version 3.0
[    1.463150] ahci 0000:00:1f.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    1.463278]   alloc irq_desc for 45 on node -1
[    1.463280]   alloc kstat_irqs on node -1
[    1.463294] ahci 0000:00:1f.2: irq 45 for MSI/MSI-X
[    1.463379] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 3 Gbps 0x33 impl SATA mode
[    1.463485] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ems sxs apst 
[    1.463590] ahci 0000:00:1f.2: setting latency timer to 64
[    1.495891] usb 1-1: new high speed USB device using ehci_hcd and address 2
[    1.516038] scsi0 : ahci
[    1.516311] scsi1 : ahci
[    1.516535] scsi2 : ahci
[    1.516756] scsi3 : ahci
[    1.516957] scsi4 : ahci
[    1.517167] scsi5 : ahci
[    1.517640] ata1: SATA max UDMA/133 abar m2048@0xf5440000 port 0xf5440100 irq 45
[    1.517722] ata2: SATA max UDMA/133 abar m2048@0xf5440000 port 0xf5440180 irq 45
[    1.517802] ata3: DUMMY
[    1.517850] ata4: DUMMY
[    1.517899] ata5: SATA max UDMA/133 abar m2048@0xf5440000 port 0xf5440300 irq 45
[    1.517981] ata6: SATA max UDMA/133 abar m2048@0xf5440000 port 0xf5440380 irq 45
[    1.518143] agpgart-intel 0000:00:00.0: Intel HD Graphics Chipset
[    1.519108] agpgart-intel 0000:00:00.0: detected 32764K stolen memory
[    1.583681] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xe0000000
[    1.646775] hub 1-1:1.0: USB hub found
[    1.647003] hub 1-1:1.0: 6 ports detected
[    1.765731] usb 2-1: new high speed USB device using ehci_hcd and address 2
[    1.865732] ata5: SATA link down (SStatus 0 SControl 300)
[    1.865739] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.865778] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.865827] ata6: SATA link down (SStatus 0 SControl 300)
[    1.866927] ata1.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by device (Stat=0x51 Err=0x04)
[    1.867681] ata2.00: ATAPI: MATSHITA DVD+/-RW UJ892, 1.04, max UDMA/100
[    1.870587] ata2.00: configured for UDMA/100
[    1.870994] ata1.00: ATA-7: SAMSUNG SSD PM800 2.5" 256GB, VBM24D1Q, max UDMA/100
[    1.871095] ata1.00: 500118192 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    1.871677] ata1.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by device (Stat=0x51 Err=0x04)
[    1.874026] ata1.00: configured for UDMA/100
[    1.885838] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG SSD PM80 VBM2 PQ: 0 ANSI: 5
[    1.886053] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.886089] sd 0:0:0:0: [sda] 500118192 512-byte logical blocks: (256 GB/238 GiB)
[    1.886156] sd 0:0:0:0: [sda] Write Protect is off
[    1.886159] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.886175] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.886862]  sda: sda1 sda2 < sda5 >
[    1.887228] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.889370] scsi 1:0:0:0: CD-ROM            MATSHITA DVD+-RW UJ892    1.04 PQ: 0 ANSI: 5
[    1.895409] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    1.895502] cdrom: Uniform CD-ROM driver Revision: 3.20
[    1.895631] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    1.895664] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    1.913041] [drm] Initialized drm 1.1.0 20060810
[    1.917779] hub 2-1:1.0: USB hub found
[    1.917914] hub 2-1:1.0: 8 ports detected
[    1.929663] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.929726] i915 0000:00:02.0: setting latency timer to 64
[    1.963417]   alloc irq_desc for 46 on node -1
[    1.963420]   alloc kstat_irqs on node -1
[    1.963431] i915 0000:00:02.0: irq 46 for MSI/MSI-X
[    1.963440] [drm] set up 31M of stolen space
[    1.971694] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    1.995875] usb 1-1.4: new high speed USB device using ehci_hcd and address 3
[    2.235557] usb 2-1.7: new full speed USB device using ehci_hcd and address 3
[    2.435442] usb 2-1.8: new full speed USB device using ehci_hcd and address 4
[    2.568603] usb 2-1.8: config 0 descriptor??
[    2.975657] Console: switching to colour frame buffer device 170x48
[    2.978067] fb0: inteldrmfb frame buffer device
[    2.978068] drm: registered panic notifier
[    2.984264] acpi device:37: registered as cooling_device4
[    2.984732] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input5
[    2.984809] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[    2.984850] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    3.235087] EXT4-fs (sda1): INFO: recovery required on readonly filesystem
[    3.235112] EXT4-fs (sda1): write access will be enabled during recovery
[    4.103678] EXT4-fs (sda1): orphan cleanup on readonly fs
[    4.103709] EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 267352
[    4.103736] EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 267351
[    4.103764] EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 267350
[    4.103769] EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 267349
[    4.103778] EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 267335
[    4.103783] EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 267347
[    4.103791] EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 267329
[    4.103796] EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 262576
[    4.103804] EXT4-fs (sda1): 8 orphan inodes deleted
[    4.103822] EXT4-fs (sda1): recovery complete
[    4.204098] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[    4.615066] Adding 10173436k swap on /dev/sda5.  Priority:-1 extents:1 across:10173436k SSD
[    4.629980] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro
[    4.649842] udev: starting version 151
[    4.706195] intel ips 0000:00:1f.6: Warning: CPU TDP doesn't match expected value (found 25, expected 35)
[    4.706216] intel ips 0000:00:1f.6: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    4.712939] sdhci: Secure Digital Host Controller Interface driver
[    4.712942] sdhci: Copyright(c) Pierre Ossman
[    4.715700] sdhci-pci 0000:03:00.0: SDHCI controller found [1180:e822] (rev 1)
[    4.715730] sdhci-pci 0000:03:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    4.715831] sdhci-pci 0000:03:00.0: Will use DMA mode even though HW doesn't fully claim to support it.
[    4.715839] sdhci-pci 0000:03:00.0: setting latency timer to 64
[    4.715853] mmc0: no vmmc regulator found
[    4.715920] Registered led device: mmc0::
[    4.716051] mmc0: SDHCI controller on PCI [0000:03:00.0] using DMA
[    4.733952] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[    4.757523] cfg80211: Calling CRDA to update world regulatory domain
[    4.769533] input: Dell WMI hotkeys as /devices/virtual/input/input6
[    4.772752] lp: driver loaded but no devices found
[    4.777004] intel ips 0000:00:1f.6: IPS driver initialized, MCP temp limit 65535
[    4.816858] parport_pc 00:08: activated
[    4.816864] parport_pc 00:08: reported by Plug and Play ACPI
[    4.817014] parport_pc 00:08: disabled
[    4.819010] Bluetooth: Core ver 2.15
[    4.819056] NET: Registered protocol family 31
[    4.819058] Bluetooth: HCI device and connection manager initialized
[    4.819061] Bluetooth: HCI socket layer initialized
[    4.835904] cfg80211: World regulatory domain updated:
[    4.835907]     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[    4.835909]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    4.835911]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[    4.835913]     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[    4.835914]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    4.835916]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    4.858102] Linux video capture interface: v2.00
[    4.859739] ppdev: user-space parallel port driver
[    4.860706] Bluetooth: Generic Bluetooth USB driver ver 0.6
[    4.860889] usbcore: registered new interface driver btusb
[    4.874496] apparmor_parser[802]: segfault at 0 ip 0000000000409eda sp 00007fffdcb97330 error 4 in apparmor_parser[400000+c8000]
[    4.895610] uvcvideo: Found UVC 1.00 device Laptop_Integrated_Webcam_2M (0461:4db1)
[    4.900620] input: Laptop_Integrated_Webcam_2M as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.4/1-1.4:1.0/input/input7
[    4.900686] usbcore: registered new interface driver uvcvideo
[    4.900688] USB Video Class driver (v0.1.0)
[    4.911724] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:
[    4.911727] iwlagn: Copyright(c) 2003-2010 Intel Corporation
[    4.911868] iwlagn 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    4.911906] iwlagn 0000:02:00.0: setting latency timer to 64
[    4.912005] iwlagn 0000:02:00.0: Detected Intel(R) Centrino(R) Advanced-N 6200 AGN, REV=0x74
[    4.928399] iwlagn 0000:02:00.0: device EEPROM VER=0x436, CALIB=0x6
[    4.928430] iwlagn 0000:02:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
[    4.928539]   alloc irq_desc for 47 on node -1
[    4.928542]   alloc kstat_irqs on node -1
[    4.928628] iwlagn 0000:02:00.0: irq 47 for MSI/MSI-X
[    4.928923] apparmor_parser[890]: segfault at 0 ip 0000000000409eda sp 00007fff4d6847d0 error 4 in apparmor_parser[400000+c8000]
[    4.931230] apparmor_parser[893]: segfault at 0 ip 0000000000409eda sp 00007fff27cadbe0 error 4 in apparmor_parser[400000+c8000]
[    4.933951] Bluetooth: L2CAP ver 2.15
[    4.933954] Bluetooth: L2CAP socket layer initialized
[    4.944381] iwlagn 0000:02:00.0: loaded firmware version 9.193.4.1 build 19710
[    4.952044] phy0: Selected rate control algorithm 'iwl-agn-rs'
[    4.967083] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    4.967086] Bluetooth: BNEP filters: protocol multicast
[    4.973018]   alloc irq_desc for 22 on node -1
[    4.973022]   alloc kstat_irqs on node -1
[    4.973031] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    4.973113]   alloc irq_desc for 48 on node -1
[    4.973115]   alloc kstat_irqs on node -1
[    4.973128] HDA Intel 0000:00:1b.0: irq 48 for MSI/MSI-X
[    4.973158] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    4.984339] Bridge firewalling registered
[    4.992525] Bluetooth: SCO (Voice Link) ver 0.6
[    4.992528] Bluetooth: SCO socket layer initialized
[    6.082862] Bluetooth: RFCOMM TTY layer initialized
[    6.082868] Bluetooth: RFCOMM socket layer initialized
[    6.082870] Bluetooth: RFCOMM ver 1.11
[    6.093933] input: HDA Intel Mic at Sep Left Jack as /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
[    6.093995] input: HDA Intel Mic at Ext Left Jack as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
[    6.094052] input: HDA Intel Line Out at Sep Left Jack as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
[    6.094111] input: HDA Intel HP Out at Ext Left Jack as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
[    6.233084] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[    6.784727] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[    6.785186] ADDRCONF(NETDEV_UP): eth0: link is not ready
[    7.823523] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[    8.269480] cfg80211: Found new beacon on frequency: 2472 MHz (Ch 13) on phy0
[    8.451617] ACPI Exception: AE_TIME, Returned by Handler for [EmbeddedControl] (20100702/evregion-474)
[    8.451673] ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.LPCB.ECDV.ECR1] (Node ffff88011763cbe0), AE_TIME
[    8.451686] ACPI Error (psparse-0537): Method parse/execution failed [\ECBT] (Node ffff88011763ccf8), AE_TIME
[    8.451694] ACPI Error (psparse-0537): Method parse/execution failed [\ECG2] (Node ffff88011763cde8), AE_TIME
[    8.451701] ACPI Error (psparse-0537): Method parse/execution failed [\ECG6] (Node ffff88011763ced8), AE_TIME
[    8.451709] ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.BAT0._BST] (Node ffff88011763e668), AE_TIME
[    8.451722] ACPI Exception: AE_TIME, Evaluating _BST (20100702/battery-439)
[    9.056868] input: PS/2 Generic Mouse as /devices/platform/i8042/serio1/input/input12
[   11.529808] intel ips 0000:00:1f.6: MCP power or thermal limit exceeded
[   42.219774] padlock: VIA PadLock not detected.

--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="Xorg.0.log"
Content-Transfer-Encoding: 8bit


X.Org X Server 1.7.6
Release Date: 2010-03-17
X Protocol Version 11, Revision 0
Build Operating System: Linux 2.6.24-27-server x86_64 Ubuntu
Current Operating System: Linux gavana 2.6.36-rc3-drm+ #3 SMP Sun Sep 12 02:00:28 MSD 2010 x86_64
Kernel command line: BOOT_IMAGE=/boot/vmlinuz-2.6.36-rc3-drm+ root=UUID=3e0770ae-e3de-4db5-9c15-2a058ad91585 ro
Build Date: 21 July 2010  01:03:39PM
xorg-server 2:1.7.6-2ubuntu7.3 (For technical support please see http://www.ubuntu.com/support) 
Current version of pixman: 0.16.4
	Before reporting problems, check http://wiki.x.org
	to make sure that you have the latest version.
Markers: (--) probed, (**) from config file, (==) default setting,
	(++) from command line, (!!) notice, (II) informational,
	(WW) warning, (EE) error, (NI) not implemented, (??) unknown.
(==) Log file: "/var/log/Xorg.0.log", Time: Sun Sep 12 02:07:47 2010
(==) Using config file: "/etc/X11/xorg.conf"
(==) Using config directory: "/usr/lib/X11/xorg.conf.d"
(==) ServerLayout "X.org Configured"
(**) |-->Screen "Screen0" (0)
(**) |   |-->Monitor "Monitor0"
(**) |   |-->Device "Card0"
(**) |-->Input Device "Mouse0"
(**) |-->Input Device "Keyboard0"
(==) Automatically adding devices
(==) Automatically enabling devices
(WW) The directory "/usr/share/fonts/X11/cyrillic" does not exist.
	Entry deleted from font path.
(WW) The directory "/usr/share/fonts/X11/cyrillic" does not exist.
	Entry deleted from font path.
(**) FontPath set to:
	/usr/share/fonts/X11/misc,
	/usr/share/fonts/X11/100dpi/:unscaled,
	/usr/share/fonts/X11/75dpi/:unscaled,
	/usr/share/fonts/X11/Type1,
	/usr/share/fonts/X11/100dpi,
	/usr/share/fonts/X11/75dpi,
	/var/lib/defoma/x-ttcidfont-conf.d/dirs/TrueType,
	built-ins,
	/usr/share/fonts/X11/misc,
	/usr/share/fonts/X11/100dpi/:unscaled,
	/usr/share/fonts/X11/75dpi/:unscaled,
	/usr/share/fonts/X11/Type1,
	/usr/share/fonts/X11/100dpi,
	/usr/share/fonts/X11/75dpi,
	/var/lib/defoma/x-ttcidfont-conf.d/dirs/TrueType,
	built-ins
(**) ModulePath set to "/usr/lib/xorg/modules"
(WW) AllowEmptyInput is on, devices using drivers 'kbd', 'mouse' or 'vmmouse' will be disabled.
(WW) Disabling Mouse0
(WW) Disabling Keyboard0
(II) Loader magic: 0x7ca300
(II) Module ABI versions:
	X.Org ANSI C Emulation: 0.4
	X.Org Video Driver: 6.0
	X.Org XInput driver : 7.0
	X.Org Server Extension : 2.0
(++) using VT number 7

(--) PCI:*(0:0:2:0) 8086:0046:1028:0410 Intel Corporation Core Processor Integrated Graphics Controller rev 2, Mem @ 0xf0000000/4194304, 0xe0000000/268435456, I/O @ 0x000060b0/8
(II) Open ACPI successful (/var/run/acpid.socket)
(II) "extmod" will be loaded. This was enabled by default and also specified in the config file.
(II) "dbe" will be loaded. This was enabled by default and also specified in the config file.
(II) "glx" will be loaded. This was enabled by default and also specified in the config file.
(II) "record" will be loaded. This was enabled by default and also specified in the config file.
(II) "dri" will be loaded. This was enabled by default and also specified in the config file.
(II) "dri2" will be loaded. This was enabled by default and also specified in the config file.
(II) LoadModule: "dri2"
(II) Loading /usr/lib/xorg/modules/extensions/libdri2.so
(II) Module dri2: vendor="X.Org Foundation"
	compiled for 1.7.6, module version = 1.1.0
	ABI class: X.Org Server Extension, version 2.0
(II) Loading extension DRI2
(II) LoadModule: "record"
(II) Loading /usr/lib/xorg/modules/extensions/librecord.so
(II) Module record: vendor="X.Org Foundation"
	compiled for 1.7.6, module version = 1.13.0
	Module class: X.Org Server Extension
	ABI class: X.Org Server Extension, version 2.0
(II) Loading extension RECORD
(II) LoadModule: "dbe"
(II) Loading /usr/lib/xorg/modules/extensions/libdbe.so
(II) Module dbe: vendor="X.Org Foundation"
	compiled for 1.7.6, module version = 1.0.0
	Module class: X.Org Server Extension
	ABI class: X.Org Server Extension, version 2.0
(II) Loading extension DOUBLE-BUFFER
(II) LoadModule: "dri"
(II) Loading /usr/lib/xorg/modules/extensions/libdri.so
(II) Module dri: vendor="X.Org Foundation"
	compiled for 1.7.6, module version = 1.0.0
	ABI class: X.Org Server Extension, version 2.0
(II) Loading extension XFree86-DRI
(II) LoadModule: "extmod"
(II) Loading /usr/lib/xorg/modules/extensions/libextmod.so
(II) Module extmod: vendor="X.Org Foundation"
	compiled for 1.7.6, module version = 1.0.0
	Module class: X.Org Server Extension
	ABI class: X.Org Server Extension, version 2.0
(II) Loading extension MIT-SCREEN-SAVER
(II) Loading extension XFree86-VidModeExtension
(II) Loading extension XFree86-DGA
(II) Loading extension DPMS
(II) Loading extension XVideo
(II) Loading extension XVideo-MotionCompensation
(II) Loading extension X-Resource
(II) LoadModule: "glx"
(II) Loading /usr/lib/xorg/modules/extensions/libglx.so
(II) Module glx: vendor="X.Org Foundation"
	compiled for 1.7.6, module version = 1.0.0
	ABI class: X.Org Server Extension, version 2.0
(==) AIGLX enabled
(II) Loading extension GLX
(II) LoadModule: "intel"
(II) Loading /usr/lib/xorg/modules/drivers/intel_drv.so
(II) Module intel: vendor="X.Org Foundation"
	compiled for 1.7.6, module version = 2.9.1
	Module class: X.Org Video Driver
	ABI class: X.Org Video Driver, version 6.0
(II) intel: Driver for Intel Integrated Graphics Chipsets: i810,
	i810-dc100, i810e, i815, i830M, 845G, 852GM/855GM, 865G, 915G,
	E7221 (i915), 915GM, 945G, 945GM, 945GME, Pineview GM, Pineview G,
	965G, G35, 965Q, 946GZ, 965GM, 965GME/GLE, G33, Q35, Q33, GM45,
	4 Series, G45/G43, Q45/Q43, G41, B43, Clarkdale, Arrandale
(II) Primary Device is: PCI 00@00:02:0
drmOpenDevice: node name is /dev/dri/card0
drmOpenDevice: open result is 9, (OK)
drmOpenByBusid: Searching for BusID pci:0000:00:02.0
drmOpenDevice: node name is /dev/dri/card0
drmOpenDevice: open result is 9, (OK)
drmOpenByBusid: drmOpenMinor returns 9
drmOpenByBusid: drmGetBusid reports pci:0000:00:02.0
(==) intel(0): Depth 24, (--) framebuffer bpp 32
(==) intel(0): RGB weight 888
(==) intel(0): Default visual is TrueColor
(II) intel(0): Integrated Graphics Chipset: Intel(R) Arrandale
(--) intel(0): Chipset: "Arrandale"
(II) intel(0): Output (null)1 using monitor section Monitor0
(II) intel(0): Output VGA1 has no monitor section
(II) intel(0): Output HDMI1 has no monitor section
(II) intel(0): Output DP1 has no monitor section
(II) intel(0): Output HDMI2 has no monitor section
(II) intel(0): Output DP2 has no monitor section
(II) intel(0): EDID for output (null)1
(II) intel(0): Manufacturer: SEC  Model: 5441  Serial#: 0
(II) intel(0): Year: 2010  Week: 255
(II) intel(0): EDID Version: 1.4
(II) intel(0): Digital Display Input
(II) intel(0): 6 bits per channel
(II) intel(0): Digital interface is DisplayPort
(II) intel(0): Max Image Size [cm]: horiz.: 29  vert.: 16
(II) intel(0): Gamma: 2.20
(II) intel(0): No DPMS capabilities specified
(II) intel(0): Supported color encodings: RGB 4:4:4 YCrCb 4:4:4 
(II) intel(0): First detailed timing is preferred mode
(II) intel(0): Preferred mode is native pixel format and refresh rate
(II) intel(0): redX: 0.590 redY: 0.350   greenX: 0.320 greenY: 0.535
(II) intel(0): blueX: 0.155 blueY: 0.115   whiteX: 0.313 whiteY: 0.329
(II) intel(0): Manufacturer's mask: 0
(II) intel(0): Supported detailed timing:
(II) intel(0): clock: 72.1 MHz   Image Size:  293 x 165 mm
(II) intel(0): h_active: 1366  h_sync: 1414  h_sync_end 1446 h_blank_end 1522 h_border: 0
(II) intel(0): v_active: 768  v_sync: 770  v_sync_end 775 v_blanking: 790 v_border: 0
(II) intel(0): Supported detailed timing:
(II) intel(0): clock: 48.1 MHz   Image Size:  293 x 165 mm
(II) intel(0): h_active: 1366  h_sync: 1414  h_sync_end 1446 h_blank_end 1522 h_border: 0
(II) intel(0): v_active: 768  v_sync: 770  v_sync_end 775 v_blanking: 790 v_border: 0
(II) intel(0):  XF930€133AT
(II) intel(0): Unknown vendor-specific block 0
(II) intel(0): EDID (in hex):
(II) intel(0): 	00ffffffffffff004ca3415400000000
(II) intel(0): 	ff140104951d10780a20e59759528927
(II) intel(0): 	1d505400000001010101010101010101
(II) intel(0): 	0101010101012e1c569c500016303020
(II) intel(0): 	250025a51000001ac912569c50001630
(II) intel(0): 	3020250025a51000001a000000fe0058
(II) intel(0): 	463933308031333341540a2000000000
(II) intel(0): 	00004101160000000009010a2020009d
(II) intel(0): EDID vendor "SEC", prod id 21569
(II) intel(0): Printing DDC gathered Modelines:
(II) intel(0): Modeline "1366x768"x0.0   72.14  1366 1414 1446 1522  768 770 775 790 +hsync -vsync (47.4 kHz)
(II) intel(0): Modeline "1366x768"x0.0   48.09  1366 1414 1446 1522  768 770 775 790 +hsync -vsync (31.6 kHz)
(II) intel(0): Printing probed modes for output (null)1
(II) intel(0): Modeline "1366x768"x60.0   72.14  1366 1414 1446 1522  768 770 775 790 +hsync -vsync (47.4 kHz)
(II) intel(0): Modeline "1366x768"x40.0   48.09  1366 1414 1446 1522  768 770 775 790 +hsync -vsync (31.6 kHz)
(II) intel(0): EDID for output VGA1
(II) intel(0): EDID for output HDMI1
(II) intel(0): EDID for output DP1
(II) intel(0): EDID for output HDMI2
(II) intel(0): EDID for output DP2
(II) intel(0): Output (null)1 connected
(II) intel(0): Output VGA1 disconnected
(II) intel(0): Output HDMI1 disconnected
(II) intel(0): Output DP1 disconnected
(II) intel(0): Output HDMI2 disconnected
(II) intel(0): Output DP2 disconnected
(II) intel(0): Using exact sizes for initial modes
(II) intel(0): Output (null)1 using initial mode 1366x768
(II) intel(0): Using default gamma of (1.0, 1.0, 1.0) unless otherwise stated.
(==) intel(0): video overlay key set to 0x101fe
(**) intel(0): Display dimensions: (290, 160) mm
(**) intel(0): DPI set to (119, 121)
(II) Loading sub module "fb"
(II) LoadModule: "fb"
(II) Loading /usr/lib/xorg/modules/libfb.so
(II) Module fb: vendor="X.Org Foundation"
	compiled for 1.7.6, module version = 1.0.0
	ABI class: X.Org ANSI C Emulation, version 0.4
(==) Depth 24 pixmap format is 32 bpp
(II) intel(0): [DRI2] Setup complete
(**) intel(0): Framebuffer compression disabled
(**) intel(0): Tiling enabled
(**) intel(0): SwapBuffers wait enabled
(==) intel(0): VideoRam: 262144 KB
(II) intel(0): Attempting memory allocation with tiled buffers.
(II) intel(0): Tiled allocation successful.
(II) UXA(0): Driver registered support for the following operations:
(II)         solid
(II)         copy
(II)         composite (RENDER acceleration)
(==) intel(0): Backing store disabled
(==) intel(0): Silken mouse enabled
(II) intel(0): Initializing HW Cursor
(II) intel(0): No memory allocations
(II) intel(0): RandR 1.2 enabled, ignore the following RandR disabled message.
(==) intel(0): DPMS enabled
(==) intel(0): Intel XvMC decoder disabled
(II) intel(0): Set up textured video
(II) intel(0): direct rendering: DRI2 Enabled
(--) RandR disabled
(II) Initializing built-in extension Generic Event Extension
(II) Initializing built-in extension SHAPE
(II) Initializing built-in extension MIT-SHM
(II) Initializing built-in extension XInputExtension
(II) Initializing built-in extension XTEST
(II) Initializing built-in extension BIG-REQUESTS
(II) Initializing built-in extension SYNC
(II) Initializing built-in extension XKEYBOARD
(II) Initializing built-in extension XC-MISC
(II) Initializing built-in extension SECURITY
(II) Initializing built-in extension XINERAMA
(II) Initializing built-in extension XFIXES
(II) Initializing built-in extension RENDER
(II) Initializing built-in extension RANDR
(II) Initializing built-in extension COMPOSITE
(II) Initializing built-in extension DAMAGE
(II) AIGLX: enabled GLX_MESA_copy_sub_buffer
(II) AIGLX: enabled GLX_SGI_make_current_read
(II) AIGLX: enabled GLX_SGI_swap_control and GLX_MESA_swap_control
(II) AIGLX: GLX_EXT_texture_from_pixmap backed by buffer objects
(II) AIGLX: Loaded and initialized /usr/lib/dri/i965_dri.so
(II) GLX: Initialized DRI2 GL provider for screen 0
(II) intel(0): Setting screen physical size to 361 x 203
(II) XKB: reuse xkmfile /var/lib/xkb/server-B20D7FC79C7F597315E3E501AEF10E0D866E8E92.xkm
(II) config/udev: Adding input device Power Button (/dev/input/event3)
(**) Power Button: Applying InputClass "evdev keyboard catchall"
(II) LoadModule: "evdev"
(II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
(II) Module evdev: vendor="X.Org Foundation"
	compiled for 1.7.6, module version = 2.3.2
	Module class: X.Org XInput Driver
	ABI class: X.Org XInput driver, version 7.0
(**) Power Button: always reports core events
(**) Power Button: Device: "/dev/input/event3"
(II) Power Button: Found keys
(II) Power Button: Configuring as keyboard
(II) XINPUT: Adding extended input device "Power Button" (type: KEYBOARD)
(**) Option "xkb_rules" "evdev"
(**) Option "xkb_model" "pc105"
(**) Option "xkb_layout" "us"
(II) config/udev: Adding input device Video Bus (/dev/input/event5)
(**) Video Bus: Applying InputClass "evdev keyboard catchall"
(**) Video Bus: always reports core events
(**) Video Bus: Device: "/dev/input/event5"
(II) Video Bus: Found keys
(II) Video Bus: Configuring as keyboard
(II) XINPUT: Adding extended input device "Video Bus" (type: KEYBOARD)
(**) Option "xkb_rules" "evdev"
(**) Option "xkb_model" "pc105"
(**) Option "xkb_layout" "us"
(II) config/udev: Adding input device Power Button (/dev/input/event1)
(**) Power Button: Applying InputClass "evdev keyboard catchall"
(**) Power Button: always reports core events
(**) Power Button: Device: "/dev/input/event1"
(II) Power Button: Found keys
(II) Power Button: Configuring as keyboard
(II) XINPUT: Adding extended input device "Power Button" (type: KEYBOARD)
(**) Option "xkb_rules" "evdev"
(**) Option "xkb_model" "pc105"
(**) Option "xkb_layout" "us"
(II) config/udev: Adding input device Lid Switch (/dev/input/event0)
(II) No input driver/identifier specified (ignoring)
(II) config/udev: Adding input device Sleep Button (/dev/input/event2)
(**) Sleep Button: Applying InputClass "evdev keyboard catchall"
(**) Sleep Button: always reports core events
(**) Sleep Button: Device: "/dev/input/event2"
(II) Sleep Button: Found keys
(II) Sleep Button: Configuring as keyboard
(II) XINPUT: Adding extended input device "Sleep Button" (type: KEYBOARD)
(**) Option "xkb_rules" "evdev"
(**) Option "xkb_model" "pc105"
(**) Option "xkb_layout" "us"
(II) config/udev: Adding input device Laptop_Integrated_Webcam_2M (/dev/input/event7)
(**) Laptop_Integrated_Webcam_2M: Applying InputClass "evdev keyboard catchall"
(**) Laptop_Integrated_Webcam_2M: always reports core events
(**) Laptop_Integrated_Webcam_2M: Device: "/dev/input/event7"
(II) Laptop_Integrated_Webcam_2M: Found keys
(II) Laptop_Integrated_Webcam_2M: Configuring as keyboard
(II) XINPUT: Adding extended input device "Laptop_Integrated_Webcam_2M" (type: KEYBOARD)
(**) Option "xkb_rules" "evdev"
(**) Option "xkb_model" "pc105"
(**) Option "xkb_layout" "us"
(II) config/udev: Adding input device HDA Intel Line Out at Sep Left Jack (/dev/input/event10)
(II) No input driver/identifier specified (ignoring)
(II) config/udev: Adding input device HDA Intel HP Out at Ext Left Jack (/dev/input/event11)
(II) No input driver/identifier specified (ignoring)
(II) config/udev: Adding input device HDA Intel Mic at Sep Left Jack (/dev/input/event8)
(II) No input driver/identifier specified (ignoring)
(II) config/udev: Adding input device HDA Intel Mic at Ext Left Jack (/dev/input/event9)
(II) No input driver/identifier specified (ignoring)
(II) config/udev: Adding input device AT Translated Set 2 keyboard (/dev/input/event4)
(**) AT Translated Set 2 keyboard: Applying InputClass "evdev keyboard catchall"
(**) AT Translated Set 2 keyboard: always reports core events
(**) AT Translated Set 2 keyboard: Device: "/dev/input/event4"
(II) AT Translated Set 2 keyboard: Found keys
(II) AT Translated Set 2 keyboard: Configuring as keyboard
(II) XINPUT: Adding extended input device "AT Translated Set 2 keyboard" (type: KEYBOARD)
(**) Option "xkb_rules" "evdev"
(**) Option "xkb_model" "pc105"
(**) Option "xkb_layout" "us"
(II) config/udev: Adding input device Dell WMI hotkeys (/dev/input/event6)
(**) Dell WMI hotkeys: Applying InputClass "evdev keyboard catchall"
(**) Dell WMI hotkeys: always reports core events
(**) Dell WMI hotkeys: Device: "/dev/input/event6"
(II) Dell WMI hotkeys: Found keys
(II) Dell WMI hotkeys: Configuring as keyboard
(II) XINPUT: Adding extended input device "Dell WMI hotkeys" (type: KEYBOARD)
(**) Option "xkb_rules" "evdev"
(**) Option "xkb_model" "pc105"
(**) Option "xkb_layout" "us"
(II) config/udev: Adding input device PS/2 Generic Mouse (/dev/input/mouse0)
(II) No input driver/identifier specified (ignoring)
(II) config/udev: Adding input device PS/2 Generic Mouse (/dev/input/event12)
(**) PS/2 Generic Mouse: Applying InputClass "evdev pointer catchall"
(**) PS/2 Generic Mouse: always reports core events
(**) PS/2 Generic Mouse: Device: "/dev/input/event12"
(II) PS/2 Generic Mouse: Found 3 mouse buttons
(II) PS/2 Generic Mouse: Found relative axes
(II) PS/2 Generic Mouse: Found x and y relative axes
(II) PS/2 Generic Mouse: Configuring as mouse
(**) PS/2 Generic Mouse: YAxisMapping: buttons 4 and 5
(**) PS/2 Generic Mouse: EmulateWheelButton: 4, EmulateWheelInertia: 10, EmulateWheelTimeout: 200
(II) XINPUT: Adding extended input device "PS/2 Generic Mouse" (type: MOUSE)
(II) PS/2 Generic Mouse: initialized for relative axes.
(II) intel(0): EDID vendor "SEC", prod id 21569
(II) intel(0): Printing DDC gathered Modelines:
(II) intel(0): Modeline "1366x768"x0.0   72.14  1366 1414 1446 1522  768 770 775 790 +hsync -vsync (47.4 kHz)
(II) intel(0): Modeline "1366x768"x0.0   48.09  1366 1414 1446 1522  768 770 775 790 +hsync -vsync (31.6 kHz)
(II) intel(0): EDID vendor "SEC", prod id 21569
(II) intel(0): Printing DDC gathered Modelines:
(II) intel(0): Modeline "1366x768"x0.0   72.14  1366 1414 1446 1522  768 770 775 790 +hsync -vsync (47.4 kHz)
(II) intel(0): Modeline "1366x768"x0.0   48.09  1366 1414 1446 1522  768 770 775 790 +hsync -vsync (31.6 kHz)
(II) intel(0): EDID vendor "SEC", prod id 21569
(II) intel(0): Printing DDC gathered Modelines:
(II) intel(0): Modeline "1366x768"x0.0   72.14  1366 1414 1446 1522  768 770 775 790 +hsync -vsync (47.4 kHz)
(II) intel(0): Modeline "1366x768"x0.0   48.09  1366 1414 1446 1522  768 770 775 790 +hsync -vsync (31.6 kHz)
(II) AIGLX: Suspending AIGLX clients for VT switch

--vtzGhvizbBRQ85DL--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184Ab0ILTLO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 15:11:14 -0400
Received: from cet.com.ru ([195.178.208.66]:60055 "EHLO tservice.net.ru"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752047Ab0ILTLK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 15:11:10 -0400
Date: Sun, 12 Sep 2010 23:11:07 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        David Airlie <airlied@linux.ie>
Subject: Re: i915 blank screen and crash
Message-ID: <20100912191107.GA13445@ioremap.net>
References: <20100911184646.GA27154@ioremap.net> <89kc63$i1vccu@fmsmga002.fm.intel.com> <20100911221341.GA3289@ioremap.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="IS0zKkzwUGydFO0o"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100911221341.GA3289@ioremap.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Sep 12, 2010 at 02:13:41AM +0400, Evgeniy Polyakov (zbr@ioremap.net) wrote:
> >   git://git.kernel.org/pub/scm/linux/kernel/git/ickle/drm-intel.git
> > 
> > in the drm-intel-next branch. Jesse insists that he has a working eDP
> > machine on his desk, so maybe there is hope yet.
> 
> Nope, hope quickly dissapears in the dark - I installed this version and
> get blank screen after boot. nomodeset + vesa and failsafe X session
> work.

It happend that previous ran was with 'drm-intel-fixes' branch. After I
pulled 'drm-intel-next' to that tree behaviour changed, but still screen
is blank.
It blinked from previous black to dark black :) maybe it turned off and
on, do not know, but there was no such blink previously. Also it blinks
the same way when turning into fb console.
But still no screens and kernel crashes with i915.modeset=0

dmesg and X log attached. Hope it helps.

-- 
	Evgeniy Polyakov

--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.36-rc3-drm+ (root@gavana) (gcc version 4.4.3 (Ubuntu 4.4.3-4ubuntu5) ) #4 SMP Sun Sep 12 22:20:47 MSD 2010
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
[    0.000000] RAMDISK: 3725c000 - 37ff0000
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
[    0.000000]   #2 [003725c000 - 0037ff0000]         RAMDISK
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
[    0.000000] Memory: 3899052k/4653056k available (5669k kernel code, 600156k absent, 153848k reserved, 5441k data, 904k init)
[    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU-based detection of stalled CPUs is disabled.
[    0.000000] 	Verbose stalled-CPUs detection is disabled.
[    0.000000] NR_IRQS:4352 nr_irqs:744
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 41943040 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.010000] Detected 2526.998 MHz processor.
[    0.000007] Calibrating delay loop (skipped), value calculated using timer frequency.. 5053.99 BogoMIPS (lpj=25269980)
[    0.000123] pid_max: default: 32768 minimum: 301
[    0.000193] Security Framework initialized
[    0.000260] AppArmor: AppArmor initialized
[    0.000648] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.001681] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.002149] Mount-cache hash table entries: 256
[    0.002298] Initializing cgroup subsys ns
[    0.002354] Initializing cgroup subsys cpuacct
[    0.002411] Initializing cgroup subsys memory
[    0.002470] Initializing cgroup subsys devices
[    0.002525] Initializing cgroup subsys freezer
[    0.002579] Initializing cgroup subsys net_cls
[    0.002653] CPU: Physical Processor ID: 0
[    0.002705] CPU: Processor Core ID: 0
[    0.002763] mce: CPU supports 9 MCE banks
[    0.002824] CPU0: Thermal monitoring handled by SMI
[    0.002831] using mwait in idle threads.
[    0.002884] Performance Events: PEBS fmt1+, Westmere events, Intel PMU driver.
[    0.003038] ... version:                3
[    0.003090] ... bit width:              48
[    0.003144] ... generic registers:      4
[    0.003196] ... value mask:             0000ffffffffffff
[    0.003252] ... max period:             000000007fffffff
[    0.003308] ... fixed-purpose events:   3
[    0.003362] ... event mask:             000000070000000f
[    0.005253] ACPI: Core revision 20100702
[    0.017677] ftrace: converting mcount calls to 0f 1f 44 00 00
[    0.017746] ftrace: allocating 21484 entries in 85 pages
[    0.023872] Setting APIC routing to flat
[    0.024250] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=0 pin2=0
[    0.124264] CPU0: Intel(R) Core(TM) i5 CPU       M 540  @ 2.53GHz stepping 02
[    0.243767] Booting Node   0, Processors  #1
[    0.403557] CPU1: Thermal monitoring handled by SMI
[    0.423727]  #2
[    0.583457] CPU2: Thermal monitoring handled by SMI
[    0.603619]  #3
[    0.763355] CPU3: Thermal monitoring handled by SMI
[    0.783383] Brought up 4 CPUs
[    0.783492] Total of 4 processors activated (20215.91 BogoMIPS).
[    0.785120] devtmpfs: initialized
[    0.785986] regulator: core version 0.5
[    0.786074] Time: 18:47:18  Date: 09/12/10
[    0.786160] NET: Registered protocol family 16
[    0.786296] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.786391] ACPI: bus type pci registered
[    0.786509] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.786613] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.793212] PCI: Using configuration type 1 for base access
[    0.793778] bio: create slab <bio-0> at 0
[    0.795150] ACPI: EC: Look up EC in DSDT
[    0.801853] ACPI: BIOS _OSI(Linux) query ignored
[    0.803459] ACPI: BIOS _OSI(Linux) query ignored
[    0.809575] ACPI: SSDT 00000000db7ea918 00432 (v01  PmRef  Cpu0Ist 00003000 INTL 20080729)
[    0.810014] ACPI: Dynamic OEM Table Load:
[    0.810124] ACPI: SSDT (null) 00432 (v01  PmRef  Cpu0Ist 00003000 INTL 20080729)
[    0.810620] ACPI: SSDT 00000000db7e8018 00891 (v01  PmRef  Cpu0Cst 00003001 INTL 20080729)
[    0.811042] ACPI: Dynamic OEM Table Load:
[    0.811151] ACPI: SSDT (null) 00891 (v01  PmRef  Cpu0Cst 00003001 INTL 20080729)
[    0.811686] ACPI: SSDT 00000000db7e9a98 00303 (v01  PmRef    ApIst 00003000 INTL 20080729)
[    0.812163] ACPI: Dynamic OEM Table Load:
[    0.812274] ACPI: SSDT (null) 00303 (v01  PmRef    ApIst 00003000 INTL 20080729)
[    0.812545] ACPI: SSDT 00000000db7e7d98 00119 (v01  PmRef    ApCst 00003000 INTL 20080729)
[    0.812994] ACPI: Dynamic OEM Table Load:
[    0.813103] ACPI: SSDT (null) 00119 (v01  PmRef    ApCst 00003000 INTL 20080729)
[    0.815052] ACPI: Interpreter enabled
[    0.815113] ACPI: (supports S0 S3 S4 S5)
[    0.815289] ACPI: Using IOAPIC for interrupt routing
[    0.828916] ACPI: EC: GPE = 0x10, I/O: command/status = 0x934, data = 0x930
[    0.829832] ACPI: No dock devices found.
[    0.829896] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.830672] \_SB_.PCI0:_OSC invalid UUID
[    0.830673] _OSC request data:1 8 1f 
[    0.830677] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
[    0.831932] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.831999] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.832066] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.832160] pci_root PNP0A08:00: host bridge window [mem 0xe0000000-0xfeafffff]
[    0.832299] pci 0000:00:02.0: reg 10: [mem 0xf0000000-0xf03fffff 64bit]
[    0.832305] pci 0000:00:02.0: reg 18: [mem 0xe0000000-0xefffffff 64bit pref]
[    0.832309] pci 0000:00:02.0: reg 20: [io  0x60b0-0x60b7]
[    0.832394] pci 0000:00:19.0: reg 10: [mem 0xf5400000-0xf541ffff]
[    0.832405] pci 0000:00:19.0: reg 14: [mem 0xf5480000-0xf5480fff]
[    0.832416] pci 0000:00:19.0: reg 18: [io  0x6040-0x605f]
[    0.832484] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.832489] pci 0000:00:19.0: PME# disabled
[    0.832540] pci 0000:00:1a.0: reg 10: [mem 0xf5470000-0xf54703ff]
[    0.832626] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.832630] pci 0000:00:1a.0: PME# disabled
[    0.832677] pci 0000:00:1b.0: reg 10: [mem 0xf5460000-0xf5463fff 64bit]
[    0.832752] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.832757] pci 0000:00:1b.0: PME# disabled
[    0.832857] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.832861] pci 0000:00:1c.0: PME# disabled
[    0.832962] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.832966] pci 0000:00:1c.1: PME# disabled
[    0.833070] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.833074] pci 0000:00:1c.2: PME# disabled
[    0.833176] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.833180] pci 0000:00:1c.3: PME# disabled
[    0.833239] pci 0000:00:1d.0: reg 10: [mem 0xf5450000-0xf54503ff]
[    0.833329] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.833333] pci 0000:00:1d.0: PME# disabled
[    0.833567] pci 0000:00:1f.2: reg 10: [io  0x6090-0x6097]
[    0.833578] pci 0000:00:1f.2: reg 14: [io  0x6080-0x6083]
[    0.833589] pci 0000:00:1f.2: reg 18: [io  0x6070-0x6077]
[    0.833600] pci 0000:00:1f.2: reg 1c: [io  0x6060-0x6063]
[    0.833610] pci 0000:00:1f.2: reg 20: [io  0x6020-0x603f]
[    0.833621] pci 0000:00:1f.2: reg 24: [mem 0xf5440000-0xf54407ff]
[    0.833667] pci 0000:00:1f.2: PME# supported from D3hot
[    0.833671] pci 0000:00:1f.2: PME# disabled
[    0.833711] pci 0000:00:1f.3: reg 10: [mem 0xf5430000-0xf54300ff 64bit]
[    0.833740] pci 0000:00:1f.3: reg 20: [io  0x6000-0x601f]
[    0.833810] pci 0000:00:1f.6: reg 10: [mem 0xf5420000-0xf5420fff 64bit]
[    0.833947] pci 0000:00:1c.0: PCI bridge to [bus 01-01]
[    0.834013] pci 0000:00:1c.0:   bridge window [io  0x5000-0x5fff]
[    0.834017] pci 0000:00:1c.0:   bridge window [mem 0xf4000000-0xf53fffff]
[    0.834025] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.834146] pci 0000:02:00.0: reg 10: [mem 0xf2c00000-0xf2c01fff 64bit]
[    0.834293] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    0.834300] pci 0000:02:00.0: PME# disabled
[    0.834336] pci 0000:00:1c.1: PCI bridge to [bus 02-02]
[    0.834403] pci 0000:00:1c.1:   bridge window [io  0x4000-0x4fff]
[    0.834408] pci 0000:00:1c.1:   bridge window [mem 0xf2c00000-0xf3ffffff]
[    0.834415] pci 0000:00:1c.1:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.834558] pci 0000:03:00.0: reg 10: [mem 0xf1830000-0xf18300ff]
[    0.834691] pci 0000:03:00.0: supports D1 D2
[    0.834693] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.834699] pci 0000:03:00.0: PME# disabled
[    0.834741] pci 0000:00:1c.2: PCI bridge to [bus 03-03]
[    0.834805] pci 0000:00:1c.2:   bridge window [io  0x3000-0x3fff]
[    0.834810] pci 0000:00:1c.2:   bridge window [mem 0xf1800000-0xf2bfffff]
[    0.834817] pci 0000:00:1c.2:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.834872] pci 0000:00:1c.3: PCI bridge to [bus 04-09]
[    0.834939] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    0.834943] pci 0000:00:1c.3:   bridge window [mem 0xf0400000-0xf17fffff]
[    0.834950] pci 0000:00:1c.3:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.835020] pci 0000:00:1e.0: PCI bridge to [bus 0a-0a] (subtractive decode)
[    0.835091] pci 0000:00:1e.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.835095] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.835103] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.835105] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.835106] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.835108] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.835110] pci 0000:00:1e.0:   bridge window [mem 0xe0000000-0xfeafffff] (subtractive decode)
[    0.835141] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.835284] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.835382] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.835442] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    0.835500] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
[    0.835559] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP04._PRT]
[    0.835695] \_SB_.PCI0:_OSC invalid UUID
[    0.835696] _OSC request data:1 19 1f 
[    0.835743] \_SB_.PCI0:_OSC invalid UUID
[    0.835744] _OSC request data:1 0 1f 
[    0.835746] Unable to assume PCIe control: Disabling ASPM
[    0.838639] ACPI: PCI Root Bridge [CPBG] (domain 0000 [bus 3f])
[    0.838866] Unable to assume PCIe control: Disabling ASPM
[    0.839114] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
[    0.839574] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    0.839985] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 *10 12 14 15)
[    0.840399] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
[    0.840859] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 *5 6 7 10 12 14 15)
[    0.841272] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
[    0.841755] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 *3 4 5 6 7 10 12 14 15)
[    0.842161] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
[    0.842613] HEST: Table is not found!
[    0.842715] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.842817] vgaarb: loaded
[    0.842959] SCSI subsystem initialized
[    0.843049] libata version 3.00 loaded.
[    0.843079] usbcore: registered new interface driver usbfs
[    0.843152] usbcore: registered new interface driver hub
[    0.843236] usbcore: registered new device driver usb
[    0.843451] ACPI: WMI: Mapper loaded
[    0.843513] PCI: Using ACPI for IRQ routing
[    0.843575] PCI: pci_cache_line_size set to 64 bytes
[    0.843744] reserve RAM buffer: 000000000009ac00 - 000000000009ffff 
[    0.843746] reserve RAM buffer: 00000000db65f000 - 00000000dbffffff 
[    0.843816] NetLabel: Initializing
[    0.843873] NetLabel:  domain hash size = 128
[    0.843933] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.844006] NetLabel:  unlabeled traffic allowed by default
[    0.844103] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.844385] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.846463] Switching to clocksource tsc
[    0.850926] AppArmor: AppArmor Filesystem Enabled
[    0.851006] pnp: PnP ACPI init
[    0.851081] ACPI: bus type pnp registered
[    0.853615]   alloc irq_desc for 23 on node 0
[    0.853617]   alloc kstat_irqs on node 0
[    0.856382] pnp: PnP ACPI: found 13 devices
[    0.856444] ACPI: ACPI bus type pnp unregistered
[    0.856517] system 00:05: [io  0x0680-0x069f] has been reserved
[    0.856585] system 00:05: [io  0x1000-0x1003] has been reserved
[    0.856652] system 00:05: [io  0x1004-0x1013] has been reserved
[    0.856717] system 00:05: [io  0xffff] has been reserved
[    0.856783] system 00:05: [io  0x0400-0x047f] has been reserved
[    0.856850] system 00:05: [io  0x0500-0x057f] has been reserved
[    0.856916] system 00:05: [io  0x164e-0x164f] has been reserved
[    0.856983] system 00:0a: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.857050] system 00:0a: [mem 0xfed10000-0xfed13fff] has been reserved
[    0.857116] system 00:0a: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.857184] system 00:0a: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.857250] system 00:0a: [mem 0xf8000000-0xfbffffff] has been reserved
[    0.857319] system 00:0a: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.857389] system 00:0a: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.857459] system 00:0a: [mem 0xff000000-0xffffffff] could not be reserved
[    0.857527] system 00:0a: [mem 0xfee00000-0xfeefffff] could not be reserved
[    0.857595] system 00:0a: [mem 0xf54c0000-0xf54c0fff] has been reserved
[    0.863131] pci 0000:00:1c.0: BAR 15: assigned [mem 0xf5500000-0xf56fffff 64bit pref]
[    0.863227] pci 0000:00:1c.1: BAR 15: assigned [mem 0xf5700000-0xf58fffff 64bit pref]
[    0.863331] pci 0000:00:1c.2: BAR 15: assigned [mem 0xf5900000-0xf5afffff 64bit pref]
[    0.863428] pci 0000:00:1c.3: BAR 15: assigned [mem 0xf5b00000-0xf5cfffff 64bit pref]
[    0.863523] pci 0000:00:1c.0: PCI bridge to [bus 01-01]
[    0.863587] pci 0000:00:1c.0:   bridge window [io  0x5000-0x5fff]
[    0.863656] pci 0000:00:1c.0:   bridge window [mem 0xf4000000-0xf53fffff]
[    0.864309] pci 0000:00:1c.0:   bridge window [mem 0xf5500000-0xf56fffff 64bit pref]
[    0.864410] pci 0000:00:1c.1: PCI bridge to [bus 02-02]
[    0.864474] pci 0000:00:1c.1:   bridge window [io  0x4000-0x4fff]
[    0.864542] pci 0000:00:1c.1:   bridge window [mem 0xf2c00000-0xf3ffffff]
[    0.864614] pci 0000:00:1c.1:   bridge window [mem 0xf5700000-0xf58fffff 64bit pref]
[    0.864712] pci 0000:00:1c.2: PCI bridge to [bus 03-03]
[    0.864776] pci 0000:00:1c.2:   bridge window [io  0x3000-0x3fff]
[    0.864847] pci 0000:00:1c.2:   bridge window [mem 0xf1800000-0xf2bfffff]
[    0.864920] pci 0000:00:1c.2:   bridge window [mem 0xf5900000-0xf5afffff 64bit pref]
[    0.865020] pci 0000:00:1c.3: PCI bridge to [bus 04-09]
[    0.865084] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    0.865153] pci 0000:00:1c.3:   bridge window [mem 0xf0400000-0xf17fffff]
[    0.865222] pci 0000:00:1c.3:   bridge window [mem 0xf5b00000-0xf5cfffff 64bit pref]
[    0.865321] pci 0000:00:1e.0: PCI bridge to [bus 0a-0a]
[    0.865383] pci 0000:00:1e.0:   bridge window [io  disabled]
[    0.865451] pci 0000:00:1e.0:   bridge window [mem disabled]
[    0.865519] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    0.865600]   alloc irq_desc for 16 on node -1
[    0.865601]   alloc kstat_irqs on node -1
[    0.865605] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.865675] pci 0000:00:1c.0: setting latency timer to 64
[    0.865684]   alloc irq_desc for 17 on node -1
[    0.865685]   alloc kstat_irqs on node -1
[    0.865688] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.865760] pci 0000:00:1c.1: setting latency timer to 64
[    0.865769]   alloc irq_desc for 18 on node -1
[    0.865770]   alloc kstat_irqs on node -1
[    0.865773] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.865845] pci 0000:00:1c.2: setting latency timer to 64
[    0.865854]   alloc irq_desc for 19 on node -1
[    0.865855]   alloc kstat_irqs on node -1
[    0.865858] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    0.865929] pci 0000:00:1c.3: setting latency timer to 64
[    0.865937] pci 0000:00:1e.0: setting latency timer to 64
[    0.865941] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.865943] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.865944] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.865946] pci_bus 0000:00: resource 7 [mem 0xe0000000-0xfeafffff]
[    0.865948] pci_bus 0000:01: resource 0 [io  0x5000-0x5fff]
[    0.865949] pci_bus 0000:01: resource 1 [mem 0xf4000000-0xf53fffff]
[    0.865951] pci_bus 0000:01: resource 2 [mem 0xf5500000-0xf56fffff 64bit pref]
[    0.865953] pci_bus 0000:02: resource 0 [io  0x4000-0x4fff]
[    0.865954] pci_bus 0000:02: resource 1 [mem 0xf2c00000-0xf3ffffff]
[    0.865956] pci_bus 0000:02: resource 2 [mem 0xf5700000-0xf58fffff 64bit pref]
[    0.865958] pci_bus 0000:03: resource 0 [io  0x3000-0x3fff]
[    0.865959] pci_bus 0000:03: resource 1 [mem 0xf1800000-0xf2bfffff]
[    0.865961] pci_bus 0000:03: resource 2 [mem 0xf5900000-0xf5afffff 64bit pref]
[    0.865963] pci_bus 0000:04: resource 0 [io  0x2000-0x2fff]
[    0.865964] pci_bus 0000:04: resource 1 [mem 0xf0400000-0xf17fffff]
[    0.865966] pci_bus 0000:04: resource 2 [mem 0xf5b00000-0xf5cfffff 64bit pref]
[    0.865968] pci_bus 0000:0a: resource 4 [io  0x0000-0x0cf7]
[    0.865969] pci_bus 0000:0a: resource 5 [io  0x0d00-0xffff]
[    0.865971] pci_bus 0000:0a: resource 6 [mem 0x000a0000-0x000bffff]
[    0.865973] pci_bus 0000:0a: resource 7 [mem 0xe0000000-0xfeafffff]
[    0.865998] NET: Registered protocol family 2
[    0.866175] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.867130] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.869493] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.869836] TCP: Hash tables configured (established 524288 bind 65536)
[    0.869905] TCP reno registered
[    0.869969] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.870065] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.870243] NET: Registered protocol family 1
[    0.870321] pci 0000:00:02.0: Boot video device
[    0.870471] PCI: CLS 64 bytes, default 64
[    0.870515] Trying to unpack rootfs image as initramfs...
[    1.105085] Freeing initrd memory: 13904k freed
[    1.108065] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    1.108142] Placing 64MB software IO TLB between ffff880001fdd000 - ffff880005fdd000
[    1.108239] software IO TLB at phys 0x1fdd000 - 0x5fdd000
[    1.108344] Simple Boot Flag at 0xf1 set to 0x1
[    1.108628] Scanning for low memory corruption every 60 seconds
[    1.108823] audit: initializing netlink socket (disabled)
[    1.108898] type=2000 audit(1284317237.960:1): initialized
[    1.120657] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.121703] VFS: Disk quotas dquot_6.5.2
[    1.121807] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.122304] fuse init (API version 7.15)
[    1.122420] msgmni has been set to 7642
[    1.122617] alg: No test for stdrng (krng)
[    1.122724] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    1.122818] io scheduler noop registered
[    1.122877] io scheduler deadline registered
[    1.122965] io scheduler cfq registered (default)
[    1.123116] pcieport 0000:00:1c.0: setting latency timer to 64
[    1.123162]   alloc irq_desc for 40 on node -1
[    1.123164]   alloc kstat_irqs on node -1
[    1.123177] pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
[    1.123261] pcieport 0000:00:1c.1: setting latency timer to 64
[    1.123302]   alloc irq_desc for 41 on node -1
[    1.123303]   alloc kstat_irqs on node -1
[    1.123311] pcieport 0000:00:1c.1: irq 41 for MSI/MSI-X
[    1.123389] pcieport 0000:00:1c.2: setting latency timer to 64
[    1.123429]   alloc irq_desc for 42 on node -1
[    1.123430]   alloc kstat_irqs on node -1
[    1.123438] pcieport 0000:00:1c.2: irq 42 for MSI/MSI-X
[    1.123515] pcieport 0000:00:1c.3: setting latency timer to 64
[    1.123555]   alloc irq_desc for 43 on node -1
[    1.123556]   alloc kstat_irqs on node -1
[    1.123564] pcieport 0000:00:1c.3: irq 43 for MSI/MSI-X
[    1.123646] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.123815] \_SB_.PCI0:_OSC invalid UUID
[    1.123816] _OSC request data:1 0 1f 
[    1.123875] \_SB_.PCI0:_OSC invalid UUID
[    1.123876] _OSC request data:1 0 1f 
[    1.123928] \_SB_.PCI0:_OSC invalid UUID
[    1.123930] _OSC request data:1 0 1f 
[    1.123981] \_SB_.PCI0:_OSC invalid UUID
[    1.123982] _OSC request data:1 0 1f 
[    1.124045] \_SB_.PCI0:_OSC invalid UUID
[    1.124046] _OSC request data:1 0 1f 
[    1.124099] \_SB_.PCI0:_OSC invalid UUID
[    1.124100] _OSC request data:1 0 1f 
[    1.124151] \_SB_.PCI0:_OSC invalid UUID
[    1.124152] _OSC request data:1 0 1f 
[    1.124204] \_SB_.PCI0:_OSC invalid UUID
[    1.124205] _OSC request data:1 0 1f 
[    1.124213] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    1.124332] intel_idle: MWAIT substates: 0x1120
[    1.124333] intel_idle: v0.4 model 0x25
[    1.124334] intel_idle: lapic_timer_reliable_states 0xffffffff
[    1.124856] ACPI: AC Adapter [AC] (on-line)
[    1.124990] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input0
[    1.125425] ACPI: Lid Switch [LID]
[    1.125513] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input1
[    1.125613] ACPI: Power Button [PBTN]
[    1.125698] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input2
[    1.125798] ACPI: Sleep Button [SBTN]
[    1.125884] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    1.125977] ACPI: Power Button [PWRF]
[    1.126197] ACPI: acpi_idle yielding to intel_idle
[    1.131025] ERST: Table is not found!
[    1.131477] Linux agpgart interface v0.103
[    1.131558] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.132619] brd: module loaded
[    1.133036] loop: module loaded
[    1.133405] Fixed MDIO Bus: probed
[    1.133488] PPP generic driver version 2.4.2
[    1.133600] tun: Universal TUN/TAP device driver, 1.6
[    1.133683] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    1.133797] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.133906] ehci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.134041] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[    1.134044] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[    1.134130] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    1.134264] ehci_hcd 0000:00:1a.0: debug port 2
[    1.138207] ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
[    1.138226] ehci_hcd 0000:00:1a.0: irq 16, io mem 0xf5470000
[    1.150879] ACPI: Battery Slot [BAT0] (battery present)
[    1.151833] ACPI: Battery Slot [BAT1] (battery absent)
[    1.153147] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    1.153306] hub 1-0:1.0: USB hub found
[    1.153368] hub 1-0:1.0: 3 ports detected
[    1.153484] ehci_hcd 0000:00:1d.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    1.153564] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[    1.153567] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[    1.153651] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    1.153772] ehci_hcd 0000:00:1d.0: debug port 2
[    1.157730] ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
[    1.157742] ehci_hcd 0000:00:1d.0: irq 17, io mem 0xf5450000
[    1.176364] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    1.176512] hub 2-0:1.0: USB hub found
[    1.176574] hub 2-0:1.0: 3 ports detected
[    1.176675] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.176748] uhci_hcd: USB Universal Host Controller Interface driver
[    1.176881] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    1.177221] i8042.c: Warning: Keylock active.
[    1.178638] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.178703] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.178805] mice: PS/2 mouse device common for all mice
[    1.178956] rtc_cmos 00:06: RTC can wake from S4
[    1.179052] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
[    1.179151] rtc0: alarms up to one year, y3k, 242 bytes nvram, hpet irqs
[    1.179287] device-mapper: uevent: version 1.0.3
[    1.179400] device-mapper: ioctl: 4.18.0-ioctl (2010-06-29) initialised: dm-devel@redhat.com
[    1.179536] device-mapper: multipath: version 1.1.1 loaded
[    1.179603] device-mapper: multipath round-robin: version 1.0.0 loaded
[    1.179775] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
[    1.179836] cpuidle: using governor ladder
[    1.180038] cpuidle: using governor menu
[    1.180273] TCP cubic registered
[    1.180414] NET: Registered protocol family 10
[    1.180725] lo: Disabled Privacy Extensions
[    1.180918] NET: Registered protocol family 17
[    1.180989] Registering the dns_resolver key type
[    1.182134] PM: Resume from disk failed.
[    1.182144] registered taskstats version 1
[    1.182563]   Magic number: 10:66:797
[    1.182732] rtc_cmos 00:06: setting system clock to 2010-09-12 18:47:19 UTC (1284317239)
[    1.182834] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    1.182902] EDD information not available.
[    1.183023] Freeing unused kernel memory: 904k freed
[    1.183244] Write protecting the kernel read-only data: 10240k
[    1.183526] Freeing unused kernel memory: 456k freed
[    1.186236] Freeing unused kernel memory: 1648k freed
[    1.202196] udev: starting version 151
[    1.202285] udevd (72): /proc/72/oom_adj is deprecated, please use /proc/72/oom_score_adj instead.
[    1.218913] agpgart-intel 0000:00:00.0: Intel HD Graphics Chipset
[    1.219673] agpgart-intel 0000:00:00.0: detected 32768K stolen memory
[    1.223371] e1000e: Intel(R) PRO/1000 Network Driver - 1.2.7-k2
[    1.223442] e1000e: Copyright (c) 1999 - 2010 Intel Corporation.
[    1.251492] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xe0000000
[    1.251914]   alloc irq_desc for 20 on node -1
[    1.251917]   alloc kstat_irqs on node -1
[    1.251928] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    1.252005] e1000e 0000:00:19.0: setting latency timer to 64
[    1.252139]   alloc irq_desc for 44 on node -1
[    1.252141]   alloc kstat_irqs on node -1
[    1.252156] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[    1.358511] [drm] Initialized drm 1.1.0 20060810
[    1.462877] e1000e 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:26:b9:e0:54:fd
[    1.462981] e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    1.463102] e1000e 0000:00:19.0: eth0: MAC: 9, PHY: 10, PBA No: 4041ff-0ff
[    1.463253] ahci 0000:00:1f.2: version 3.0
[    1.463273] ahci 0000:00:1f.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    1.463396]   alloc irq_desc for 45 on node -1
[    1.463398]   alloc kstat_irqs on node -1
[    1.463411] ahci 0000:00:1f.2: irq 45 for MSI/MSI-X
[    1.463495] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 3 Gbps 0x33 impl SATA mode
[    1.463601] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ems sxs apst 
[    1.463705] ahci 0000:00:1f.2: setting latency timer to 64
[    1.476344] usb 1-1: new high speed USB device using ehci_hcd and address 2
[    1.516478] scsi0 : ahci
[    1.516808] scsi1 : ahci
[    1.517146] scsi2 : ahci
[    1.517306] scsi3 : ahci
[    1.517430] scsi4 : ahci
[    1.517546] scsi5 : ahci
[    1.517994] ata1: SATA max UDMA/133 abar m2048@0xf5440000 port 0xf5440100 irq 45
[    1.518076] ata2: SATA max UDMA/133 abar m2048@0xf5440000 port 0xf5440180 irq 45
[    1.518157] ata3: DUMMY
[    1.518205] ata4: DUMMY
[    1.518255] ata5: SATA max UDMA/133 abar m2048@0xf5440000 port 0xf5440300 irq 45
[    1.518335] ata6: SATA max UDMA/133 abar m2048@0xf5440000 port 0xf5440380 irq 45
[    1.518512] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.518595] i915 0000:00:02.0: setting latency timer to 64
[    1.552831]   alloc irq_desc for 46 on node -1
[    1.552835]   alloc kstat_irqs on node -1
[    1.552845] i915 0000:00:02.0: irq 46 for MSI/MSI-X
[    1.552854] [drm] set up 31M of stolen space
[    1.558647] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    1.637160] hub 1-1:1.0: USB hub found
[    1.637439] hub 1-1:1.0: 6 ports detected
[    1.756166] usb 2-1: new high speed USB device using ehci_hcd and address 2
[    1.876096] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.876103] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.876108] ata5: SATA link down (SStatus 0 SControl 300)
[    1.876146] ata6: SATA link down (SStatus 0 SControl 300)
[    1.877248] ata1.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by device (Stat=0x51 Err=0x04)
[    1.878325] ata2.00: ATAPI: MATSHITA DVD+/-RW UJ892, 1.04, max UDMA/100
[    1.878542] ata1.00: ATA-7: SAMSUNG SSD PM800 2.5" 256GB, VBM24D1Q, max UDMA/100
[    1.878631] ata1.00: 500118192 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    1.879298] ata1.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by device (Stat=0x51 Err=0x04)
[    1.880601] ata1.00: configured for UDMA/100
[    1.881250] ata2.00: configured for UDMA/100
[    1.896253] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG SSD PM80 VBM2 PQ: 0 ANSI: 5
[    1.896479] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.896490] sd 0:0:0:0: [sda] 500118192 512-byte logical blocks: (256 GB/238 GiB)
[    1.896553] sd 0:0:0:0: [sda] Write Protect is off
[    1.896555] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.896576] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.897273]  sda: sda1 sda2 < sda5 >
[    1.897645] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.899798] scsi 1:0:0:0: CD-ROM            MATSHITA DVD+-RW UJ892    1.04 PQ: 0 ANSI: 5
[    1.906021] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    1.906113] cdrom: Uniform CD-ROM driver Revision: 3.20
[    1.906252] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    1.906359] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    1.906594] hub 2-1:1.0: USB hub found
[    1.906781] hub 2-1:1.0: 8 ports detected
[    1.986192] usb 1-1.4: new high speed USB device using ehci_hcd and address 3
[    2.216067] usb 2-1.7: new full speed USB device using ehci_hcd and address 3
[    2.405960] usb 2-1.8: new full speed USB device using ehci_hcd and address 4
[    2.538855] usb 2-1.8: config 0 descriptor??
[    2.995458] Console: switching to colour frame buffer device 170x48
[    2.997833] fb0: inteldrmfb frame buffer device
[    2.997834] drm: registered panic notifier
[    3.004713] acpi device:37: registered as cooling_device4
[    3.005204] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input5
[    3.005286] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[    3.005327] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    3.835869] EXT4-fs (sda1): INFO: recovery required on readonly filesystem
[    3.835895] EXT4-fs (sda1): write access will be enabled during recovery
[    3.854577] EXT4-fs (sda1): recovery complete
[    3.854827] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[    4.316130] Adding 10173436k swap on /dev/sda5.  Priority:-1 extents:1 across:10173436k SSD
[    4.334965] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro
[    4.355777] udev: starting version 151
[    4.425225] intel ips 0000:00:1f.6: Warning: CPU TDP doesn't match expected value (found 25, expected 35)
[    4.425244] intel ips 0000:00:1f.6: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    4.446659] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[    4.493660] lp: driver loaded but no devices found
[    4.494144] intel ips 0000:00:1f.6: IPS driver initialized, MCP temp limit 65535
[    4.498034] input: Dell WMI hotkeys as /devices/virtual/input/input6
[    4.515833] sdhci: Secure Digital Host Controller Interface driver
[    4.515836] sdhci: Copyright(c) Pierre Ossman
[    4.517772] cfg80211: Calling CRDA to update world regulatory domain
[    4.529197] sdhci-pci 0000:03:00.0: SDHCI controller found [1180:e822] (rev 1)
[    4.529226] sdhci-pci 0000:03:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    4.529316] sdhci-pci 0000:03:00.0: Will use DMA mode even though HW doesn't fully claim to support it.
[    4.529324] sdhci-pci 0000:03:00.0: setting latency timer to 64
[    4.529336] mmc0: no vmmc regulator found
[    4.529404] Registered led device: mmc0::
[    4.529493] mmc0: SDHCI controller on PCI [0000:03:00.0] using DMA
[    4.541826] parport_pc 00:08: activated
[    4.541831] parport_pc 00:08: reported by Plug and Play ACPI
[    4.541986] parport_pc 00:08: disabled
[    4.555418] Linux video capture interface: v2.00
[    4.560564] ppdev: user-space parallel port driver
[    4.562834] Bluetooth: Core ver 2.15
[    4.562913] NET: Registered protocol family 31
[    4.562915] Bluetooth: HCI device and connection manager initialized
[    4.562918] Bluetooth: HCI socket layer initialized
[    4.579492] uvcvideo: Found UVC 1.00 device Laptop_Integrated_Webcam_2M (0461:4db1)
[    4.587084] apparmor_parser[790]: segfault at 0 ip 0000000000409eda sp 00007fff28cb8460 error 4 in apparmor_parser[400000+c8000]
[    4.589306] input: Laptop_Integrated_Webcam_2M as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.4/1-1.4:1.0/input/input7
[    4.589422] usbcore: registered new interface driver uvcvideo
[    4.589425] USB Video Class driver (v0.1.0)
[    4.590150] Bluetooth: Generic Bluetooth USB driver ver 0.6
[    4.591029] usbcore: registered new interface driver btusb
[    4.595580] cfg80211: World regulatory domain updated:
[    4.595584]     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[    4.595587]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    4.595590]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[    4.595592]     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[    4.595595]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    4.595597]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    4.620702] Bluetooth: L2CAP ver 2.15
[    4.620705] Bluetooth: L2CAP socket layer initialized
[    4.623659] apparmor_parser[850]: segfault at 0 ip 0000000000409eda sp 00007fff6f36f790 error 4 in apparmor_parser[400000+c8000]
[    4.640590] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:
[    4.640593] iwlagn: Copyright(c) 2003-2010 Intel Corporation
[    4.640669] iwlagn 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    4.640679] iwlagn 0000:02:00.0: setting latency timer to 64
[    4.640741] iwlagn 0000:02:00.0: Detected Intel(R) Centrino(R) Advanced-N 6200 AGN, REV=0x74
[    4.657143] iwlagn 0000:02:00.0: device EEPROM VER=0x436, CALIB=0x6
[    4.657271] iwlagn 0000:02:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
[    4.657407]   alloc irq_desc for 47 on node -1
[    4.657410]   alloc kstat_irqs on node -1
[    4.657454] iwlagn 0000:02:00.0: irq 47 for MSI/MSI-X
[    4.662562] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    4.662566] Bluetooth: BNEP filters: protocol multicast
[    4.681796] iwlagn 0000:02:00.0: loaded firmware version 9.193.4.1 build 19710
[    4.683622] apparmor_parser[902]: segfault at 0 ip 0000000000409eda sp 00007fff6bef1dd0 error 4 in apparmor_parser[400000+c8000]
[    4.684002] Bridge firewalling registered
[    4.699073] Bluetooth: SCO (Voice Link) ver 0.6
[    4.699075] Bluetooth: SCO socket layer initialized
[    5.219441] phy0: Selected rate control algorithm 'iwl-agn-rs'
[    5.223137]   alloc irq_desc for 22 on node -1
[    5.223141]   alloc kstat_irqs on node -1
[    5.223151] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    5.279093]   alloc irq_desc for 48 on node -1
[    5.279096]   alloc kstat_irqs on node -1
[    5.279111] HDA Intel 0000:00:1b.0: irq 48 for MSI/MSI-X
[    5.279146] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    5.783156] Bluetooth: RFCOMM TTY layer initialized
[    5.783162] Bluetooth: RFCOMM socket layer initialized
[    5.783163] Bluetooth: RFCOMM ver 1.11
[    5.854635] input: HDA Intel Mic at Sep Left Jack as /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
[    5.854710] input: HDA Intel Mic at Ext Left Jack as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
[    5.854761] input: HDA Intel Line Out at Sep Left Jack as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
[    5.854811] input: HDA Intel HP Out at Ext Left Jack as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
[    5.903975] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[    5.963795] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[    5.964158] ADDRCONF(NETDEV_UP): eth0: link is not ready
[    7.472237] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[    7.871897] cfg80211: Found new beacon on frequency: 2472 MHz (Ch 13) on phy0
[    8.756146] input: PS/2 Generic Mouse as /devices/platform/i8042/serio1/input/input12
[    8.767863] dell-wmi: Received unknown WMI event (0x11)
[    9.421870] [drm:ironlake_crtc_disable] *ERROR* failed to disable transcoder
[    9.681692] intel ips 0000:00:1f.6: MCP power or thermal limit exceeded
[    9.950911] dell-wmi: Received unknown WMI event (0x11)
[   34.667901] intel ips 0000:00:1f.6: MCP power or thermal limit exceeded
[   69.648587] intel ips 0000:00:1f.6: MCP power or thermal limit exceeded
[  156.144509] dell-wmi: Received unknown WMI event (0x11)
[  156.780407] [drm:ironlake_crtc_disable] *ERROR* failed to turn off cpu pipe
[  157.293844] dell-wmi: Received unknown WMI event (0x11)
[  164.674501] padlock: VIA PadLock not detected.

--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="Xorg.0.log"
Content-Transfer-Encoding: 8bit


X.Org X Server 1.7.6
Release Date: 2010-03-17
X Protocol Version 11, Revision 0
Build Operating System: Linux 2.6.24-27-server x86_64 Ubuntu
Current Operating System: Linux gavana 2.6.36-rc3-drm+ #4 SMP Sun Sep 12 22:20:47 MSD 2010 x86_64
Kernel command line: BOOT_IMAGE=/boot/vmlinuz-2.6.36-rc3-drm+ root=UUID=3e0770ae-e3de-4db5-9c15-2a058ad91585 ro
Build Date: 21 July 2010  01:03:39PM
xorg-server 2:1.7.6-2ubuntu7.3 (For technical support please see http://www.ubuntu.com/support) 
Current version of pixman: 0.16.4
	Before reporting problems, check http://wiki.x.org
	to make sure that you have the latest version.
Markers: (--) probed, (**) from config file, (==) default setting,
	(++) from command line, (!!) notice, (II) informational,
	(WW) warning, (EE) error, (NI) not implemented, (??) unknown.
(==) Log file: "/var/log/Xorg.0.log", Time: Sun Sep 12 22:47:24 2010
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
(II) config/udev: Adding input device PS/2 Generic Mouse (/dev/input/mouse0)
(II) No input driver/identifier specified (ignoring)
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

--IS0zKkzwUGydFO0o--

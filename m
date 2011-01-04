Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751172Ab1ADAfp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 19:35:45 -0500
Received: from mailout05.t-online.de ([194.25.134.82]:34273 "EHLO
	mailout05.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037Ab1ADAfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 19:35:42 -0500
Message-ID: <4D226B49.6090509@t-online.de>
Date: Tue, 04 Jan 2011 01:35:21 +0100
From: Knut Petersen <Knut_Petersen@t-online.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Chris Wilson <chris@chris-wilson.co.uk>
CC: Linus Torvalds <torvalds@linux-foundation.org>, airlied@linux.ie,
        eric@anholt.net, jesse.barnes@intel.com, linux-kernel@vger.kernel.org,
        intel-gfx <intel-gfx@lists.freedesktop.org>, gregkh@suse.de,
        Jean Delvare <khali@linux-fr.org>,
        David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH] Fix i915 drm regression on AOpen i915GMm-HFS motherboard
References: <4D21DC41.8070408@t-online.de> <b7da2f$q1ffv6@fmsmga001.fm.intel.com> <4D22119B.9050007@t-online.de> <AANLkTikffkQJnVKzcGhEZjPqg_iQPQ+P2Bbqz7A9Unq_@mail.gmail.com> <849307$b0clt4@azsmga001.ch.intel.com> <4D22571F.9060706@t-online.de> <0d30dc$kl33rh@orsmga001.jf.intel.com>
In-Reply-To: <0d30dc$kl33rh@orsmga001.jf.intel.com>
Content-Type: multipart/mixed;
 boundary="------------040009030301020905030909"
X-ID: bRPDHyZDQhBOaoyl3ZlyZVwolrp9awjtYCjf8xTqVwvAsxtFxquvLruFulfhKvlgjK
X-TOI-MSGID: 4f369a91-482e-4598-8c77-f8b02e965685
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040009030301020905030909
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Am 04.01.2011 00:22, schrieb Chris Wilson:

Well, here are the kernel messages from boot.msg.

dmesg output did not work ... there were 200000+  messages like
"[drm:intel_prepare_page_flip], preparing flip with no unpin work?" that
filled the
syslog until X had started up. A really verbose log. It's 1:27 CET, I'll
have to
take a nap now.

BTW: "All the trouble"? Not really. It believe that I have a special
talent to buy the
least supported hardware ... for my previous mobo I had to write a
working framebuffer
driver (cyblafb, now dropped from the kernel), and the PC I used before
that refused
to boot from CD until I hacked isolinux to patch BIOS pointers at
runtime ;-)

cu,
 Knut

> On Tue, 04 Jan 2011 00:09:19 +0100, Knut Petersen <Knut_Petersen@t-online.de> wrote:
>   
>> Kernel 2.6.37-rc8-git2
>> =================
>>
>> text mode console: ok, resolution 1280x1024, fully used by framebuffer
>> output
>> X: first device detected is LVDS with resolution 1024x768. VGA and DVI
>> connector work in X,
>> but X switches to 1024x768 for both of them. xrandr reports the four
>> physical connectors but
>> also LVDS, VGA2 and TV3 connectors.
>>     
> A false detection of the LVDS would appear to be a minor issue compared to
> all the trouble you have. Can you add drm.debug=0xe to your boot
> commandline and attach the resulting dmesg?
> -Chris
>
>   


--------------040009030301020905030909
Content-Type: text/plain;
 name="boot.msg-2.6.37-rc8-git2+Patch-Knut-Petersen"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="boot.msg-2.6.37-rc8-git2+Patch-Knut-Petersen"

klogd 1.4.1, log source = ksyslog started.
<6>[    0.000000] Initializing cgroup subsys cpu
<5>[    0.000000] Linux version 2.6.37-rc8-git2-kape (knut@golem) (gcc version 4.5.0 20100604 [gcc-4_5-branch revision 160292] (SUSE Linux) ) #7 PREEMPT Tue Jan 4 00:24:58 CET 2011
<6>[    0.000000] BIOS-provided physical RAM map:
<6>[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
<6>[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
<6>[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
<6>[    0.000000]  BIOS-e820: 0000000000100000 - 000000007f7f0000 (usable)
<6>[    0.000000]  BIOS-e820: 000000007f7f0000 - 000000007f7f3000 (ACPI NVS)
<6>[    0.000000]  BIOS-e820: 000000007f7f3000 - 000000007f800000 (ACPI data)
<6>[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
<6>[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
<6>[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
<6>[    0.000000]  BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
<5>[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
<6>[    0.000000] DMI 2.3 present.
<7>[    0.000000] DMI: i915GMm-HFS/ , BIOS 6.00 PG 09/14/2005
<7>[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
<7>[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
<6>[    0.000000] last_pfn = 0x7f7f0 max_arch_pfn = 0x100000
<7>[    0.000000] MTRR default type: uncachable
<7>[    0.000000] MTRR fixed ranges enabled:
<7>[    0.000000]   00000-9FFFF write-back
<7>[    0.000000]   A0000-EFFFF uncachable
<7>[    0.000000]   F0000-FFFFF write-through
<7>[    0.000000] MTRR variable ranges enabled:
<7>[    0.000000]   0 base 000000000 mask F80000000 write-back
<7>[    0.000000]   1 base 07F800000 mask FFF800000 uncachable
<7>[    0.000000]   2 disabled
<7>[    0.000000]   3 disabled
<7>[    0.000000]   4 disabled
<7>[    0.000000]   5 disabled
<7>[    0.000000]   6 disabled
<7>[    0.000000]   7 disabled
<6>[    0.000000] PAT not supported by CPU.
<7>[    0.000000] initial memory mapped : 0 - 00c00000
<6>[    0.000000] init_memory_mapping: 0000000000000000-00000000377fe000
<7>[    0.000000]  0000000000 - 0000400000 page 4k
<7>[    0.000000]  0000400000 - 0037400000 page 2M
<7>[    0.000000]  0037400000 - 00377fe000 page 4k
<7>[    0.000000] kernel direct mapping tables up to 377fe000 @ bfb000-c00000
<6>[    0.000000] RAMDISK: 3768f000 - 37ff0000
<6>[    0.000000] Allocated new RAMDISK: 36d2e000 - 3768ebd0
<6>[    0.000000] Move RAMDISK from 000000003768f000 - 0000000037fefbcf to 36d2e000 - 3768ebcf
<4>[    0.000000] ACPI: RSDP 000f9320 00014 (v00 AOpen )
<4>[    0.000000] ACPI: RSDT 7f7f3040 00038 (v01 AOpen  AWRDACPI 42302E31 AWRD 00000000)
<4>[    0.000000] ACPI: FACP 7f7f30c0 00074 (v01 AOpen  AWRDACPI 42302E31 AWRD 00000000)
<4>[    0.000000] ACPI: DSDT 7f7f3180 042E3 (v01 AOPEN  AWRDACPI 00001000 MSFT 0100000E)
<4>[    0.000000] ACPI: FACS 7f7f0000 00040
<4>[    0.000000] ACPI: MCFG 7f7f7580 0003C (v01 AOpen  AWRDACPI 42302E31 AWRD 00000000)
<4>[    0.000000] ACPI: APIC 7f7f74c0 0005A (v01 AOpen  AWRDACPI 42302E31 AWRD 00000000)
<4>[    0.000000] ACPI: SSDT 7f7f7600 00222 (v01  PmRef  Cpu0Ist 00003000 INTL 20040311)
<4>[    0.000000] ACPI: SSDT 7f7f7a00 000E0 (v01  PmRef    CpuPm 00003000 INTL 20040311)
<7>[    0.000000] ACPI: Local APIC address 0xfee00000
<5>[    0.000000] 1151MB HIGHMEM available.
<5>[    0.000000] 887MB LOWMEM available.
<6>[    0.000000]   mapped low ram: 0 - 377fe000
<6>[    0.000000]   low ram: 0 - 377fe000
<4>[    0.000000] Zone PFN ranges:
<4>[    0.000000]   DMA      0x00000010 -> 0x00001000
<4>[    0.000000]   Normal   0x00001000 -> 0x000377fe
<4>[    0.000000]   HighMem  0x000377fe -> 0x0007f7f0
<4>[    0.000000] Movable zone start PFN for each node
<4>[    0.000000] early_node_map[2] active PFN ranges
<4>[    0.000000]     0: 0x00000010 -> 0x0000009f
<4>[    0.000000]     0: 0x00000100 -> 0x0007f7f0
<7>[    0.000000] On node 0 totalpages: 522111
<7>[    0.000000] free_area_init_node: node 0, pgdat c05e72dc, node_mem_map f5d3e200
<7>[    0.000000]   DMA zone: 32 pages used for memmap
<7>[    0.000000]   DMA zone: 0 pages reserved
<7>[    0.000000]   DMA zone: 3951 pages, LIFO batch:0
<7>[    0.000000]   Normal zone: 1744 pages used for memmap
<7>[    0.000000]   Normal zone: 221486 pages, LIFO batch:31
<7>[    0.000000]   HighMem zone: 2304 pages used for memmap
<7>[    0.000000]   HighMem zone: 292594 pages, LIFO batch:31
<6>[    0.000000] Using APIC driver default
<6>[    0.000000] ACPI: PM-Timer IO Port: 0x4008
<7>[    0.000000] ACPI: Local APIC address 0xfee00000
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
<6>[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
<6>[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
<6>[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
<6>[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
<7>[    0.000000] ACPI: IRQ0 used by override.
<7>[    0.000000] ACPI: IRQ2 used by override.
<7>[    0.000000] ACPI: IRQ9 used by override.
<6>[    0.000000] Using ACPI (MADT) for SMP configuration information
<7>[    0.000000] nr_irqs_gsi: 40
<6>[    0.000000] Allocating PCI resources starting at 7f800000 (gap: 7f800000:60800000)
<7>[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
<7>[    0.000000] pcpu-alloc: [0] 0 
<4>[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 518031
<5>[    0.000000] Kernel command line: root=/dev/sdb5 drm.debug=0xe 5
<6>[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
<6>[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
<6>[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
<6>[    0.000000] Initializing CPU#0
<6>[    0.000000] allocated 10444160 bytes of page_cgroup
<6>[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
<6>[    0.000000] Initializing HighMem for node 0 (000377fe:0007f7f0)
<6>[    0.000000] Memory: 2045728k/2088896k available (3264k kernel code, 42716k reserved, 1773k data, 320k init, 1179592k highmem)
<6>[    0.000000] virtual kernel memory layout:
<6>[    0.000000]     fixmap  : 0xfffa3000 - 0xfffff000   ( 368 kB)
<6>[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
<6>[    0.000000]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
<6>[    0.000000]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
<6>[    0.000000]       .init : 0xc05ec000 - 0xc063c000   ( 320 kB)
<6>[    0.000000]       .data : 0xc0430067 - 0xc05eb4c0   (1773 kB)
<6>[    0.000000]       .text : 0xc0100000 - 0xc0430067   (3264 kB)
<6>[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
<6>[    0.000000] Preemptable hierarchical RCU implementation.
<6>[    0.000000] NR_IRQS:288
<7>[    0.000000] CPU 0 irqstacks, hard=f4c06000 soft=f4c08000
<4>[    0.000000] Console: colour VGA+ 80x25
<6>[    0.000000] console [tty0] enabled
<4>[    0.000000] Fast TSC calibration using PIT
<4>[    0.000000] Detected 1862.777 MHz processor.
<6>[    0.004006] Calibrating delay loop (skipped), value calculated using timer frequency.. 3725.55 BogoMIPS (lpj=7451108)
<6>[    0.004277] pid_max: default: 32768 minimum: 301
<6>[    0.004454] Security Framework initialized
<6>[    0.004601] AppArmor: AppArmor initialized
<4>[    0.004749] Mount-cache hash table entries: 512
<6>[    0.005020] Initializing cgroup subsys ns
<4>[    0.005154] ns_cgroup deprecated: consider using the 'clone_children' flag without the ns_cgroup.
<6>[    0.005397] Initializing cgroup subsys cpuacct
<6>[    0.005529] Initializing cgroup subsys memory
<6>[    0.008013] Initializing cgroup subsys devices
<6>[    0.008145] Initializing cgroup subsys freezer
<6>[    0.008311] mce: CPU supports 5 MCE banks
<6>[    0.008450] CPU0: Thermal monitoring enabled (TM2)
<6>[    0.008593] Performance Events: p6 PMU driver.
<6>[    0.008749] ... version:                0
<6>[    0.008880] ... bit width:              32
<6>[    0.009012] ... generic registers:      2
<6>[    0.009144] ... value mask:             00000000ffffffff
<6>[    0.009278] ... max period:             000000007fffffff
<6>[    0.009412] ... fixed-purpose events:   0
<6>[    0.009543] ... event mask:             0000000000000003
<6>[    0.009680] CPU: Intel(R) Pentium(R) M processor 1.86GHz stepping 08
<6>[    0.010196] ACPI: Core revision 20101013
<6>[    0.020153] NMI watchdog enabled, takes one hw-pmu counter.
<6>[    0.020313] Enabling APIC mode:  Flat.  Using 1 I/O APICs
<6>[    0.024233] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
<6>[    0.068000] NET: Registered protocol family 16
<6>[    0.068000] ACPI: bus type pci registered
<6>[    0.068000] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
<6>[    0.068000] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
<6>[    0.068000] PCI: Using MMCONFIG for extended config space
<6>[    0.068000] PCI: Using configuration type 1 for base access
<4>[    0.068000] bio: create slab <bio-0> at 0
<7>[    0.068000] ACPI: EC: Look up EC in DSDT
<6>[    0.073910] ACPI: Interpreter enabled
<6>[    0.074042] ACPI: (supports S0 S5)
<6>[    0.074227] ACPI: Using IOAPIC for interrupt routing
<4>[    0.075682] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-723)
<4>[    0.076428] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-723)
<4>[    0.076698] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-723)
<4>[    0.077134] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-723)
<4>[    0.077436] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-723)
<6>[    0.080616] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
<6>[    0.080970] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
<7>[    0.081304] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7] (ignored)
<7>[    0.081308] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff] (ignored)
<7>[    0.081312] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
<7>[    0.081315] pci_root PNP0A08:00: host bridge window [mem 0x000c0000-0x000dffff] (ignored)
<7>[    0.081319] pci_root PNP0A08:00: host bridge window [mem 0x7f800000-0xfebfffff] (ignored)
<7>[    0.081331] pci 0000:00:00.0: [8086:2590] type 0 class 0x000600
<7>[    0.081373] pci 0000:00:02.0: [8086:2592] type 0 class 0x000300
<7>[    0.081383] pci 0000:00:02.0: reg 10: [mem 0xd2300000-0xd237ffff]
<7>[    0.081390] pci 0000:00:02.0: reg 14: [io  0xe400-0xe407]
<7>[    0.081396] pci 0000:00:02.0: reg 18: [mem 0xc0000000-0xcfffffff pref]
<7>[    0.081403] pci 0000:00:02.0: reg 1c: [mem 0xd2400000-0xd243ffff]
<7>[    0.081433] pci 0000:00:02.1: [8086:2792] type 0 class 0x000380
<7>[    0.081442] pci 0000:00:02.1: reg 10: [mem 0xd2380000-0xd23fffff]
<7>[    0.081511] pci 0000:00:1b.0: [8086:2668] type 0 class 0x000403
<7>[    0.081527] pci 0000:00:1b.0: reg 10: [mem 0xd2440000-0xd2443fff 64bit]
<7>[    0.081580] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
<7>[    0.081585] pci 0000:00:1b.0: PME# disabled
<7>[    0.081602] pci 0000:00:1c.0: [8086:2660] type 1 class 0x000604
<7>[    0.081655] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
<7>[    0.081660] pci 0000:00:1c.0: PME# disabled
<7>[    0.081679] pci 0000:00:1c.1: [8086:2662] type 1 class 0x000604
<7>[    0.081732] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
<7>[    0.081736] pci 0000:00:1c.1: PME# disabled
<7>[    0.081756] pci 0000:00:1c.2: [8086:2664] type 1 class 0x000604
<7>[    0.081809] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
<7>[    0.081813] pci 0000:00:1c.2: PME# disabled
<7>[    0.081832] pci 0000:00:1c.3: [8086:2666] type 1 class 0x000604
<7>[    0.081885] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
<7>[    0.081889] pci 0000:00:1c.3: PME# disabled
<7>[    0.081910] pci 0000:00:1d.0: [8086:2658] type 0 class 0x000c03
<7>[    0.081949] pci 0000:00:1d.0: reg 20: [io  0xe000-0xe01f]
<7>[    0.081977] pci 0000:00:1d.1: [8086:2659] type 0 class 0x000c03
<7>[    0.082016] pci 0000:00:1d.1: reg 20: [io  0xe100-0xe11f]
<7>[    0.082045] pci 0000:00:1d.2: [8086:265a] type 0 class 0x000c03
<7>[    0.082084] pci 0000:00:1d.2: reg 20: [io  0xe200-0xe21f]
<7>[    0.082113] pci 0000:00:1d.3: [8086:265b] type 0 class 0x000c03
<7>[    0.082152] pci 0000:00:1d.3: reg 20: [io  0xe300-0xe31f]
<7>[    0.082187] pci 0000:00:1d.7: [8086:265c] type 0 class 0x000c03
<7>[    0.082204] pci 0000:00:1d.7: reg 10: [mem 0xd2444000-0xd24443ff]
<7>[    0.082266] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
<7>[    0.082271] pci 0000:00:1d.7: PME# disabled
<7>[    0.082286] pci 0000:00:1e.0: [8086:2448] type 1 class 0x000604
<7>[    0.082337] pci 0000:00:1f.0: [8086:2641] type 0 class 0x000601
<7>[    0.082412] pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
<6>[    0.082420] pci 0000:00:1f.0: quirk: [io  0x4000-0x407f] claimed by ICH6 ACPI/GPIO/TCO
<6>[    0.082655] pci 0000:00:1f.0: quirk: [io  0x4080-0x40bf] claimed by ICH6 GPIO
<6>[    0.082793] pci 0000:00:1f.0: LPC Generic IO decode 1 PIO at 0280-02ff
<6>[    0.082933] pci 0000:00:1f.0: LPC Generic IO decode 2 PIO at 1640-164f
<7>[    0.083082] pci 0000:00:1f.1: [8086:266f] type 0 class 0x000101
<7>[    0.083095] pci 0000:00:1f.1: reg 10: [io  0x0000-0x0007]
<7>[    0.083105] pci 0000:00:1f.1: reg 14: [io  0x0000-0x0003]
<7>[    0.083114] pci 0000:00:1f.1: reg 18: [io  0x0000-0x0007]
<7>[    0.083124] pci 0000:00:1f.1: reg 1c: [io  0x0000-0x0003]
<7>[    0.083134] pci 0000:00:1f.1: reg 20: [io  0xf000-0xf00f]
<7>[    0.083166] pci 0000:00:1f.2: [8086:2653] type 0 class 0x000101
<7>[    0.083180] pci 0000:00:1f.2: reg 10: [io  0xe500-0xe507]
<7>[    0.083189] pci 0000:00:1f.2: reg 14: [io  0xe600-0xe603]
<7>[    0.083197] pci 0000:00:1f.2: reg 18: [io  0xe700-0xe707]
<7>[    0.083206] pci 0000:00:1f.2: reg 1c: [io  0xe800-0xe803]
<7>[    0.083215] pci 0000:00:1f.2: reg 20: [io  0xe900-0xe90f]
<7>[    0.083223] pci 0000:00:1f.2: reg 24: [mem 0xd2445000-0xd24453ff]
<7>[    0.083245] pci 0000:00:1f.2: PME# supported from D3hot
<7>[    0.083250] pci 0000:00:1f.2: PME# disabled
<7>[    0.083263] pci 0000:00:1f.3: [8086:266a] type 0 class 0x000c05
<7>[    0.083313] pci 0000:00:1f.3: reg 20: [io  0x5000-0x501f]
<6>[    0.083380] pci 0000:00:1c.0: PCI bridge to [bus 01-01]
<7>[    0.083516] pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000] (disabled)
<7>[    0.083521] pci 0000:00:1c.0:   bridge window [mem 0x00000000-0x000fffff] (disabled)
<7>[    0.083529] pci 0000:00:1c.0:   bridge window [mem 0x00000000-0x000fffff pref] (disabled)
<7>[    0.083589] pci 0000:02:00.0: [11ab:4362] type 0 class 0x000200
<7>[    0.083612] pci 0000:02:00.0: reg 10: [mem 0xd2220000-0xd2223fff 64bit]
<7>[    0.083625] pci 0000:02:00.0: reg 18: [io  0xa000-0xa0ff]
<7>[    0.083668] pci 0000:02:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
<7>[    0.083707] pci 0000:02:00.0: supports D1 D2
<7>[    0.083710] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
<7>[    0.083716] pci 0000:02:00.0: PME# disabled
<6>[    0.083729] pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
<6>[    0.083983] pci 0000:00:1c.1: PCI bridge to [bus 02-02]
<7>[    0.084006] pci 0000:00:1c.1:   bridge window [io  0xa000-0xafff]
<7>[    0.084011] pci 0000:00:1c.1:   bridge window [mem 0xd2200000-0xd22fffff]
<7>[    0.084017] pci 0000:00:1c.1:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
<7>[    0.084076] pci 0000:03:00.0: [11ab:4362] type 0 class 0x000200
<7>[    0.084100] pci 0000:03:00.0: reg 10: [mem 0xd2020000-0xd2023fff 64bit]
<7>[    0.084113] pci 0000:03:00.0: reg 18: [io  0xb000-0xb0ff]
<7>[    0.084156] pci 0000:03:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
<7>[    0.084195] pci 0000:03:00.0: supports D1 D2
<7>[    0.084198] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
<7>[    0.084203] pci 0000:03:00.0: PME# disabled
<6>[    0.084216] pci 0000:03:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
<6>[    0.084469] pci 0000:00:1c.2: PCI bridge to [bus 03-03]
<7>[    0.084604] pci 0000:00:1c.2:   bridge window [io  0xb000-0xbfff]
<7>[    0.084609] pci 0000:00:1c.2:   bridge window [mem 0xd2000000-0xd20fffff]
<7>[    0.084616] pci 0000:00:1c.2:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
<7>[    0.084675] pci 0000:04:00.0: [1095:3132] type 0 class 0x000104
<7>[    0.084702] pci 0000:04:00.0: reg 10: [mem 0xd2184000-0xd218407f 64bit]
<7>[    0.084724] pci 0000:04:00.0: reg 18: [mem 0xd2180000-0xd2183fff 64bit]
<7>[    0.084739] pci 0000:04:00.0: reg 20: [io  0xc000-0xc07f]
<7>[    0.084765] pci 0000:04:00.0: reg 30: [mem 0x00000000-0x0007ffff pref]
<7>[    0.084805] pci 0000:04:00.0: supports D1 D2
<6>[    0.084825] pci 0000:04:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
<6>[    0.085080] pci 0000:00:1c.3: PCI bridge to [bus 04-04]
<7>[    0.085216] pci 0000:00:1c.3:   bridge window [io  0xc000-0xcfff]
<7>[    0.085220] pci 0000:00:1c.3:   bridge window [mem 0xd2100000-0xd21fffff]
<7>[    0.085227] pci 0000:00:1c.3:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
<7>[    0.085262] pci 0000:05:03.0: [11c1:5811] type 0 class 0x000c00
<7>[    0.085280] pci 0000:05:03.0: reg 10: [mem 0xd1000000-0xd1000fff]
<7>[    0.085344] pci 0000:05:03.0: supports D1 D2
<7>[    0.085347] pci 0000:05:03.0: PME# supported from D0 D1 D2 D3hot
<7>[    0.085352] pci 0000:05:03.0: PME# disabled
<7>[    0.085366] pci 0000:05:04.0: [1360:0101] type 0 class 0x000880
<7>[    0.085380] pci 0000:05:04.0: reg 10: [io  0xd000-0xd03f]
<7>[    0.085441] pci 0000:05:05.0: [10ee:3fc3] type 0 class 0x000401
<7>[    0.085455] pci 0000:05:05.0: reg 10: [mem 0xd0000000-0xd0ffffff]
<6>[    0.085543] pci 0000:00:1e.0: PCI bridge to [bus 05-05] (subtractive decode)
<7>[    0.085683] pci 0000:00:1e.0:   bridge window [io  0xd000-0xdfff]
<7>[    0.085688] pci 0000:00:1e.0:   bridge window [mem 0xd0000000-0xd1ffffff]
<7>[    0.085694] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
<7>[    0.085698] pci 0000:00:1e.0:   bridge window [io  0x0000-0xffff] (subtractive decode)
<7>[    0.085701] pci 0000:00:1e.0:   bridge window [mem 0x00000000-0xffffffff] (subtractive decode)
<7>[    0.085723] pci_bus 0000:00: on NUMA node 0
<7>[    0.085728] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
<7>[    0.085899] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
<7>[    0.085957] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX1._PRT]
<7>[    0.086013] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX2._PRT]
<7>[    0.086069] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX3._PRT]
<7>[    0.086126] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
<6>[    0.100464] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 7 9 10 11 12 14 15)
<6>[    0.100938] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 9 10 11 *12 14 15)
<6>[    0.101408] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 9 *10 11 12 14 15)
<6>[    0.101878] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 9 10 *11 12 14 15)
<6>[    0.102347] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 *9 10 11 12 14 15)
<6>[    0.102817] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
<6>[    0.103432] ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
<6>[    0.104060] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 7 9 10 *11 12 14 15)
<5>[    0.104630] SCSI subsystem initialized
<7>[    0.104810] libata version 3.00 loaded.
<6>[    0.104843] usbcore: registered new interface driver usbfs
<6>[    0.104995] usbcore: registered new interface driver hub
<6>[    0.105156] usbcore: registered new device driver usb
<6>[    0.105358] PCI: Using ACPI for IRQ routing
<7>[    0.105491] PCI: pci_cache_line_size set to 64 bytes
<7>[    0.105572] reserve RAM buffer: 000000000009f800 - 000000000009ffff 
<7>[    0.105575] reserve RAM buffer: 000000007f7f0000 - 000000007fffffff 
<7>[    0.105792] hpet clockevent registered
<6>[    0.105796] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
<6>[    0.105940] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
<6>[    0.106161] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
<6>[    0.112041] Switching to clocksource tsc
<6>[    0.112211] AppArmor: AppArmor Filesystem Enabled
<6>[    0.112351] pnp: PnP ACPI init
<6>[    0.112488] ACPI: bus type pnp registered
<7>[    0.112757] pnp 00:00: [bus 00-ff]
<7>[    0.112760] pnp 00:00: [io  0x0cf8-0x0cff]
<7>[    0.112764] pnp 00:00: [io  0x0000-0x0cf7 window]
<7>[    0.112767] pnp 00:00: [io  0x0d00-0xffff window]
<7>[    0.112770] pnp 00:00: [mem 0x000a0000-0x000bffff window]
<7>[    0.112773] pnp 00:00: [mem 0x000c0000-0x000dffff window]
<7>[    0.112776] pnp 00:00: [mem 0x7f800000-0xfebfffff window]
<7>[    0.112818] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
<7>[    0.112889] pnp 00:01: [io  0x0010-0x001f]
<7>[    0.112892] pnp 00:01: [io  0x0022-0x003f]
<7>[    0.112894] pnp 00:01: [io  0x0044-0x005f]
<7>[    0.112897] pnp 00:01: [io  0x0062-0x0063]
<7>[    0.112900] pnp 00:01: [io  0x0065-0x006f]
<7>[    0.112902] pnp 00:01: [io  0x0074-0x007f]
<7>[    0.112905] pnp 00:01: [io  0x0091-0x0093]
<7>[    0.112908] pnp 00:01: [io  0x00a2-0x00bf]
<7>[    0.112910] pnp 00:01: [io  0x00e0-0x00ef]
<7>[    0.112913] pnp 00:01: [io  0x0b78-0x0b7b]
<7>[    0.112916] pnp 00:01: [io  0x0f78-0x0f7b]
<7>[    0.112918] pnp 00:01: [io  0x0a78-0x0a7b]
<7>[    0.112921] pnp 00:01: [io  0x0e78-0x0e7b]
<7>[    0.112924] pnp 00:01: [io  0x0bbc-0x0bbf]
<7>[    0.112926] pnp 00:01: [io  0x0fbc-0x0fbf]
<7>[    0.112929] pnp 00:01: [io  0x04d0-0x04d1]
<7>[    0.112931] pnp 00:01: [io  0x0290-0x0297]
<7>[    0.112934] pnp 00:01: [io  0x0880-0x088f]
<7>[    0.112999] pnp 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
<7>[    0.113017] pnp 00:02: [dma 4]
<7>[    0.113019] pnp 00:02: [io  0x0000-0x000f]
<7>[    0.113022] pnp 00:02: [io  0x0080-0x0090]
<7>[    0.113026] pnp 00:02: [io  0x0094-0x009f]
<7>[    0.113029] pnp 00:02: [io  0x00c0-0x00df]
<7>[    0.113056] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
<7>[    0.113073] pnp 00:03: [io  0x0070-0x0073]
<7>[    0.113085] pnp 00:03: [irq 8]
<7>[    0.113109] pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
<7>[    0.113122] pnp 00:04: [io  0x0061]
<7>[    0.113147] pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
<7>[    0.113160] pnp 00:05: [io  0x00f0-0x00ff]
<7>[    0.113165] pnp 00:05: [irq 13]
<7>[    0.113190] pnp 00:05: Plug and Play ACPI device, IDs PNP0c04 (active)
<7>[    0.113572] pnp 00:06: [io  0x03f8-0x03ff]
<7>[    0.113578] pnp 00:06: [irq 4]
<7>[    0.113638] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
<7>[    0.113943] pnp 00:07: [io  0x02f8-0x02ff]
<7>[    0.113948] pnp 00:07: [irq 3]
<7>[    0.114006] pnp 00:07: Plug and Play ACPI device, IDs PNP0501 (active)
<7>[    0.114626] pnp 00:08: [io  0x0378-0x037f]
<7>[    0.114630] pnp 00:08: [io  0x0778-0x077b]
<7>[    0.114635] pnp 00:08: [irq 7]
<7>[    0.114637] pnp 00:08: [dma 3]
<7>[    0.114702] pnp 00:08: Plug and Play ACPI device, IDs PNP0401 (active)
<7>[    0.114763] pnp 00:09: [io  0x0060]
<7>[    0.114766] pnp 00:09: [io  0x0064]
<7>[    0.114771] pnp 00:09: [irq 1]
<7>[    0.114800] pnp 00:09: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
<7>[    0.114854] pnp 00:0a: [io  0x4000-0x40bf]
<7>[    0.114897] pnp 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
<7>[    0.114928] pnp 00:0b: [mem 0xffb80000-0xffbfffff]
<7>[    0.114956] pnp 00:0b: Plug and Play ACPI device, IDs INT0800 (active)
<7>[    0.115284] pnp 00:0c: [mem 0xe0000000-0xefffffff]
<7>[    0.115338] pnp 00:0c: Plug and Play ACPI device, IDs PNP0c02 (active)
<7>[    0.115610] pnp 00:0d: [mem 0x000d3800-0x000d3fff]
<7>[    0.115613] pnp 00:0d: [mem 0x000f0000-0x000f7fff]
<7>[    0.115616] pnp 00:0d: [mem 0x000f8000-0x000fbfff]
<7>[    0.115619] pnp 00:0d: [mem 0x000fc000-0x000fffff]
<7>[    0.115622] pnp 00:0d: [mem 0x7f7f0000-0x7f7fffff]
<7>[    0.115625] pnp 00:0d: [mem 0x00000000-0x0009ffff]
<7>[    0.115628] pnp 00:0d: [mem 0x00100000-0x7f7effff]
<7>[    0.115631] pnp 00:0d: [mem 0xfec00000-0xfec00fff]
<7>[    0.115635] pnp 00:0d: [mem 0xfed13000-0xfed1dfff]
<7>[    0.115638] pnp 00:0d: [mem 0xfed20000-0xfed8ffff]
<7>[    0.115641] pnp 00:0d: [mem 0xfee00000-0xfee00fff]
<7>[    0.115644] pnp 00:0d: [mem 0xffb00000-0xffb7ffff]
<7>[    0.115647] pnp 00:0d: [mem 0xfff00000-0xffffffff]
<7>[    0.115650] pnp 00:0d: [mem 0x000e0000-0x000effff]
<7>[    0.115717] pnp 00:0d: Plug and Play ACPI device, IDs PNP0c01 (active)
<6>[    0.115730] pnp: PnP ACPI: found 14 devices
<6>[    0.115861] ACPI: ACPI bus type pnp unregistered
<6>[    0.115861] system 00:01: [io  0x0b78-0x0b7b] has been reserved
<6>[    0.115981] system 00:01: [io  0x0f78-0x0f7b] has been reserved
<6>[    0.116117] system 00:01: [io  0x0a78-0x0a7b] has been reserved
<6>[    0.116255] system 00:01: [io  0x0e78-0x0e7b] has been reserved
<6>[    0.116391] system 00:01: [io  0x0bbc-0x0bbf] has been reserved
<6>[    0.116527] system 00:01: [io  0x0fbc-0x0fbf] has been reserved
<6>[    0.116665] system 00:01: [io  0x04d0-0x04d1] has been reserved
<6>[    0.116803] system 00:01: [io  0x0290-0x0297] has been reserved
<6>[    0.116939] system 00:01: [io  0x0880-0x088f] has been reserved
<6>[    0.117082] system 00:0a: [io  0x4000-0x40bf] could not be reserved
<6>[    0.117222] system 00:0c: [mem 0xe0000000-0xefffffff] has been reserved
<6>[    0.117364] system 00:0d: [mem 0x000d3800-0x000d3fff] has been reserved
<6>[    0.117503] system 00:0d: [mem 0x000f0000-0x000f7fff] could not be reserved
<6>[    0.117644] system 00:0d: [mem 0x000f8000-0x000fbfff] could not be reserved
<6>[    0.117784] system 00:0d: [mem 0x000fc000-0x000fffff] could not be reserved
<6>[    0.117923] system 00:0d: [mem 0x7f7f0000-0x7f7fffff] could not be reserved
<6>[    0.118064] system 00:0d: [mem 0x00000000-0x0009ffff] could not be reserved
<6>[    0.121185] system 00:0d: [mem 0x00100000-0x7f7effff] could not be reserved
<6>[    0.121325] system 00:0d: [mem 0xfec00000-0xfec00fff] could not be reserved
<6>[    0.121466] system 00:0d: [mem 0xfed13000-0xfed1dfff] has been reserved
<6>[    0.121604] system 00:0d: [mem 0xfed20000-0xfed8ffff] has been reserved
<6>[    0.121742] system 00:0d: [mem 0xfee00000-0xfee00fff] has been reserved
<6>[    0.121882] system 00:0d: [mem 0xffb00000-0xffb7ffff] has been reserved
<6>[    0.122021] system 00:0d: [mem 0xfff00000-0xffffffff] has been reserved
<6>[    0.122160] system 00:0d: [mem 0x000e0000-0x000effff] has been reserved
<6>[    0.158045] pci 0000:00:1c.0: BAR 8: assigned [mem 0x80000000-0x801fffff]
<6>[    0.158186] pci 0000:00:1c.0: BAR 9: assigned [mem 0x80200000-0x803fffff 64bit pref]
<6>[    0.158430] pci 0000:00:1c.1: BAR 9: assigned [mem 0x80400000-0x805fffff pref]
<6>[    0.158670] pci 0000:00:1c.2: BAR 9: assigned [mem 0x80600000-0x807fffff pref]
<6>[    0.158911] pci 0000:00:1c.3: BAR 9: assigned [mem 0x80800000-0x809fffff pref]
<6>[    0.159153] pci 0000:00:1c.0: BAR 7: assigned [io  0x1000-0x1fff]
<6>[    0.159289] pci 0000:00:1c.0: PCI bridge to [bus 01-01]
<6>[    0.159424] pci 0000:00:1c.0:   bridge window [io  0x1000-0x1fff]
<6>[    0.159564] pci 0000:00:1c.0:   bridge window [mem 0x80000000-0x801fffff]
<6>[    0.159704] pci 0000:00:1c.0:   bridge window [mem 0x80200000-0x803fffff 64bit pref]
<6>[    0.159957] pci 0000:02:00.0: BAR 6: assigned [mem 0x80400000-0x8041ffff pref]
<6>[    0.160195] pci 0000:00:1c.1: PCI bridge to [bus 02-02]
<6>[    0.160331] pci 0000:00:1c.1:   bridge window [io  0xa000-0xafff]
<6>[    0.160470] pci 0000:00:1c.1:   bridge window [mem 0xd2200000-0xd22fffff]
<6>[    0.160611] pci 0000:00:1c.1:   bridge window [mem 0x80400000-0x805fffff pref]
<6>[    0.160854] pci 0000:03:00.0: BAR 6: assigned [mem 0x80600000-0x8061ffff pref]
<6>[    0.161094] pci 0000:00:1c.2: PCI bridge to [bus 03-03]
<6>[    0.161229] pci 0000:00:1c.2:   bridge window [io  0xb000-0xbfff]
<6>[    0.161368] pci 0000:00:1c.2:   bridge window [mem 0xd2000000-0xd20fffff]
<6>[    0.161510] pci 0000:00:1c.2:   bridge window [mem 0x80600000-0x807fffff pref]
<6>[    0.161752] pci 0000:04:00.0: BAR 6: assigned [mem 0x80800000-0x8087ffff pref]
<6>[    0.161990] pci 0000:00:1c.3: PCI bridge to [bus 04-04]
<6>[    0.162125] pci 0000:00:1c.3:   bridge window [io  0xc000-0xcfff]
<6>[    0.162265] pci 0000:00:1c.3:   bridge window [mem 0xd2100000-0xd21fffff]
<6>[    0.162405] pci 0000:00:1c.3:   bridge window [mem 0x80800000-0x809fffff pref]
<6>[    0.162648] pci 0000:00:1e.0: PCI bridge to [bus 05-05]
<6>[    0.162784] pci 0000:00:1e.0:   bridge window [io  0xd000-0xdfff]
<6>[    0.162923] pci 0000:00:1e.0:   bridge window [mem 0xd0000000-0xd1ffffff]
<6>[    0.163064] pci 0000:00:1e.0:   bridge window [mem pref disabled]
<6>[    0.163207] pci 0000:00:1c.0: enabling device (0100 -> 0103)
<6>[    0.163349] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
<7>[    0.163490] pci 0000:00:1c.0: setting latency timer to 64
<6>[    0.163498] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
<7>[    0.163639] pci 0000:00:1c.1: setting latency timer to 64
<6>[    0.163647] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
<7>[    0.163788] pci 0000:00:1c.2: setting latency timer to 64
<6>[    0.163796] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
<7>[    0.163944] pci 0000:00:1c.3: setting latency timer to 64
<7>[    0.163951] pci 0000:00:1e.0: setting latency timer to 64
<7>[    0.163955] pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
<7>[    0.163958] pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffff]
<7>[    0.163961] pci_bus 0000:01: resource 0 [io  0x1000-0x1fff]
<7>[    0.163964] pci_bus 0000:01: resource 1 [mem 0x80000000-0x801fffff]
<7>[    0.163968] pci_bus 0000:01: resource 2 [mem 0x80200000-0x803fffff 64bit pref]
<7>[    0.163971] pci_bus 0000:02: resource 0 [io  0xa000-0xafff]
<7>[    0.163974] pci_bus 0000:02: resource 1 [mem 0xd2200000-0xd22fffff]
<7>[    0.163977] pci_bus 0000:02: resource 2 [mem 0x80400000-0x805fffff pref]
<7>[    0.163982] pci_bus 0000:03: resource 0 [io  0xb000-0xbfff]
<7>[    0.163985] pci_bus 0000:03: resource 1 [mem 0xd2000000-0xd20fffff]
<7>[    0.163988] pci_bus 0000:03: resource 2 [mem 0x80600000-0x807fffff pref]
<7>[    0.163991] pci_bus 0000:04: resource 0 [io  0xc000-0xcfff]
<7>[    0.163994] pci_bus 0000:04: resource 1 [mem 0xd2100000-0xd21fffff]
<7>[    0.163998] pci_bus 0000:04: resource 2 [mem 0x80800000-0x809fffff pref]
<7>[    0.164001] pci_bus 0000:05: resource 0 [io  0xd000-0xdfff]
<7>[    0.164004] pci_bus 0000:05: resource 1 [mem 0xd0000000-0xd1ffffff]
<7>[    0.164007] pci_bus 0000:05: resource 4 [io  0x0000-0xffff]
<7>[    0.164010] pci_bus 0000:05: resource 5 [mem 0x00000000-0xffffffff]
<6>[    0.164055] NET: Registered protocol family 2
<6>[    0.164246] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
<6>[    0.164644] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
<6>[    0.165850] TCP bind hash table entries: 65536 (order: 6, 262144 bytes)
<6>[    0.166299] TCP: Hash tables configured (established 131072 bind 65536)
<6>[    0.166439] TCP reno registered
<6>[    0.166571] UDP hash table entries: 512 (order: 1, 8192 bytes)
<6>[    0.166719] UDP-Lite hash table entries: 512 (order: 1, 8192 bytes)
<6>[    0.166970] NET: Registered protocol family 1
<7>[    0.167123] pci 0000:00:02.0: Boot video device
<4>[    1.764007] pci 0000:00:1d.7: EHCI: BIOS handoff failed (BIOS bug?) 01010001
<7>[    1.764183] PCI: CLS 32 bytes, default 64
<6>[    1.764255] Unpacking initramfs...
<6>[    2.081690] Freeing initrd memory: 9604k freed
<6>[    2.089991] microcode: CPU0 sig=0x6d8, pf=0x20, revision=0x20
<6>[    2.090153] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
<6>[    2.090550] audit: initializing netlink socket (disabled)
<5>[    2.090705] type=2000 audit(1294097755.088:1): initialized
<4>[    2.120248] highmem bounce pool size: 64 pages
<6>[    2.120386] HugeTLB registered 4 MB page size, pre-allocated 0 pages
<5>[    2.120629] VFS: Disk quotas dquot_6.5.2
<4>[    2.120791] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
<6>[    2.121109] fuse init (API version 7.15)
<6>[    2.121290] msgmni has been set to 1710
<6>[    2.121560] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
<6>[    2.121795] io scheduler noop registered
<6>[    2.121923] io scheduler deadline registered
<6>[    2.122069] io scheduler cfq registered (default)
<6>[    2.122447] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
<6>[    2.122685] ACPI: Power Button [PWRB]
<6>[    2.122889] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
<6>[    2.123125] ACPI: Power Button [PWRF]
<6>[    2.123306] ACPI: Fan [FAN] (on)
<7>[    2.123471] ACPI: acpi_idle registered with cpuidle
<5>[    2.123549] ACPI: AOpen i915GMm-HFS detected: disabling all active thermal trip points
<5>[    2.123788] ACPI: AOpen i915GMm-HFS detected: disabling all passive thermal trip points
<5>[    2.124047] ACPI: AOpen i915GMm-HFS detected: enabling thermal zone polling
<6>[    2.124599] thermal LNXTHERM:00: registered as thermal_zone0
<6>[    2.124734] ACPI: Thermal Zone [THRM] (55 C)
<6>[    2.127002] lp: driver loaded but no devices found
<6>[    2.127208] Non-volatile memory driver v1.3
<6>[    2.127340] Linux agpgart interface v0.103
<6>[    2.127506] agpgart-intel 0000:00:00.0: Intel 915GM Chipset
<6>[    2.127693] agpgart-intel 0000:00:00.0: detected gtt size: 262144K total, 262144K mappable
<6>[    2.128621] agpgart-intel 0000:00:00.0: detected 8192K stolen memory
<6>[    2.131370] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xc0000000
<6>[    2.131582] [drm] Initialized drm 1.1.0 20060810
<6>[    2.131734] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
<7>[    2.131879] i915 0000:00:02.0: setting latency timer to 64
<7>[    2.135325] [drm:intel_opregion_setup], graphic opregion physical addr: 0x0
<7>[    2.135332] [drm:intel_opregion_setup], ACPI OpRegion not supported!
<7>[    2.135343] [drm:i915_init_phys_hws], Enabled hardware status page
<7>[    2.135920] [drm:parse_general_definitions], crt_ddc_bus_pin: 2
<7>[    2.135951] [drm:parse_lfp_panel_data], Found panel mode in BIOS VBT tables:
<7>[    2.135955] [drm:drm_mode_debug_printmodeline], Modeline 0:"1024x768" 0 65000 1024 1048 1184 1344 768 771 777 806 0x8 0xa
<7>[    2.136048] [drm:parse_sdvo_device_mapping], the SDVO device with slave addr 70 is found on SDVOB port
<7>[    2.136053] [drm:parse_sdvo_device_mapping], SDVO device: dvo=1, addr=70, wiring=1, ddc_pin=29, i2c_pin=5, i2c_speed=83
<7>[    2.136059] [drm:parse_sdvo_device_mapping], the SDVO device with slave addr 72 is found on SDVOC port
<7>[    2.136063] [drm:parse_sdvo_device_mapping], SDVO device: dvo=2, addr=72, wiring=0, ddc_pin=29, i2c_pin=5, i2c_speed=32
<7>[    2.136119] [drm:intel_modeset_init], 2 display pipes available.
<7>[    2.136125] [drm:intel_crtc_init], swapping pipes & planes for FBC
<7>[    2.136131] [drm:intel_crtc_init], swapping pipes & planes for FBC
<7>[    2.136137] [drm:intel_no_lvds_dmi_callback], Skipping LVDS initialization for AOpen motherboard i915GMm-HFS
<7>[    2.136171] [drm:intel_setup_outputs], probing SDVOB
<7>[    2.246203] [drm:intel_sdvo_debug_write], SDVOB: W: 02                         (SDVO_CMD_GET_DEVICE_CAPS)
<7>[    2.250873] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 02 3C 06 01 01 01 01 00
<7>[    2.264626] [drm:intel_sdvo_get_capabilities], SDVO capabilities:
<4>[    2.264631]   vendor_id: 2
<4>[    2.264632]   device_id: 60
<4>[    2.264633]   device_rev_id: 6
<4>[    2.264634]   sdvo_version_major: 1
<4>[    2.264635]   sdvo_version_minor: 1
<4>[    2.264636]   sdvo_inputs_mask: 1
<4>[    2.264637]   smooth_scaling: 0
<4>[    2.264638]   sharp_scaling: 0
<4>[    2.264639]   up_scaling: 0
<4>[    2.264640]   down_scaling: 0
<4>[    2.264641]   stall_support: 0
<4>[    2.264642]   output_flags: 1
<7>[    2.266145] [drm:intel_sdvo_debug_write], SDVOB: W: 9D                         (SDVO_CMD_GET_SUPP_ENCODE)
<7>[    2.269097] [drm:intel_sdvo_write_cmd], command returns response Not supported [2]
<7>[    2.269124] [drm:intel_sdvo_debug_write], SDVOB: W: 10 00                      (SDVO_CMD_SET_TARGET_INPUT)
<7>[    2.273298] [drm:intel_sdvo_debug_write], SDVOB: W: 1D                         (SDVO_CMD_GET_INPUT_PIXEL_CLOCK_RANGE)
<7>[    2.277966] [drm:intel_sdvo_read_response], SDVOB: R: (Success) C4 09 20 4E
<7>[    2.284845] [drm:intel_sdvo_init], SDVOB device VID/DID: 02:3C.06, clock range 25MHz - 200MHz, input 1: Y, input 2: N, output 1: Y, output 2: N
<7>[    2.284852] [drm:intel_setup_outputs], probing SDVOC
<7>[    2.394872] [drm:intel_sdvo_debug_write], SDVOC: W: 02                         (SDVO_CMD_GET_DEVICE_CAPS)
<7>[    2.399541] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 02 C2 01 01 01 3D 3E 00
<7>[    2.413295] [drm:intel_sdvo_get_capabilities], SDVO capabilities:
<4>[    2.413300]   vendor_id: 2
<4>[    2.413301]   device_id: 194
<4>[    2.413302]   device_rev_id: 1
<4>[    2.413303]   sdvo_version_major: 1
<4>[    2.413304]   sdvo_version_minor: 1
<4>[    2.413305]   sdvo_inputs_mask: 1
<4>[    2.413306]   smooth_scaling: 1
<4>[    2.413307]   sharp_scaling: 1
<4>[    2.413308]   up_scaling: 1
<4>[    2.413309]   down_scaling: 1
<4>[    2.413310]   stall_support: 0
<4>[    2.413311]   output_flags: 62
<7>[    2.414863] [drm:intel_sdvo_debug_write], SDVOC: W: 11 08 00                   (SDVO_CMD_SET_TARGET_OUTPUT)
<7>[    2.420268] [drm:intel_sdvo_debug_write], SDVOC: W: 27                         (SDVO_CMD_GET_SUPPORTED_TV_FORMATS)
<7>[    2.424936] [drm:intel_sdvo_read_response], SDVOC: R: (Success) FF FF FF FF FF 1F
<7>[    2.435254] [drm:intel_sdvo_debug_write], SDVOC: W: 84                         (SDVO_CMD_GET_SUPPORTED_ENHANCEMENTS)
<7>[    2.439922] [drm:intel_sdvo_read_response], SDVOC: R: (Success) FA DF
<7>[    2.443363] [drm:intel_sdvo_debug_write], SDVOC: W: 61                         (SDVO_CMD_GET_MAX_OVERSCAN_H)
<7>[    2.448036] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 2F 00 20 00
<7>[    2.454910] [drm:intel_sdvo_debug_write], SDVOC: W: 62                         (SDVO_CMD_GET_OVERSCAN_H)
<7>[    2.459578] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 20 00
<7>[    2.463020] [drm:intel_sdvo_create_enhance_property_tv], h_overscan: max 47, default 32, current 32
<7>[    2.463025] [drm:intel_sdvo_debug_write], SDVOC: W: 64                         (SDVO_CMD_GET_MAX_OVERSCAN_V)
<7>[    2.467692] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 2F 00 20 00
<7>[    2.474573] [drm:intel_sdvo_debug_write], SDVOC: W: 65                         (SDVO_CMD_GET_OVERSCAN_V)
<7>[    2.479242] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 20 00
<7>[    2.482687] [drm:intel_sdvo_create_enhance_property_tv], v_overscan: max 47, default 32, current 32
<7>[    2.482691] [drm:intel_sdvo_debug_write], SDVOC: W: 67                         (SDVO_CMD_GET_MAX_HPOS)
<7>[    2.487358] [drm:intel_sdvo_read_response], SDVOC: R: (Success) FF 03 00 02
<7>[    2.494238] [drm:intel_sdvo_debug_write], SDVOC: W: 68                         (SDVO_CMD_GET_HPOS)
<7>[    2.498905] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 02
<7>[    2.502347] [drm:intel_sdvo_create_enhance_property_tv], hpos: max 1023, default 512, current 512
<7>[    2.502352] [drm:intel_sdvo_debug_write], SDVOC: W: 6A                         (SDVO_CMD_GET_MAX_VPOS)
<7>[    2.507019] [drm:intel_sdvo_read_response], SDVOC: R: (Success) FF 03 00 02
<7>[    2.513898] [drm:intel_sdvo_debug_write], SDVOC: W: 6B                         (SDVO_CMD_GET_VPOS)
<7>[    2.518565] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 02
<7>[    2.522008] [drm:intel_sdvo_create_enhance_property_tv], vpos: max 1023, default 512, current 512
<7>[    2.522012] [drm:intel_sdvo_debug_write], SDVOC: W: 55                         (SDVO_CMD_GET_MAX_SATURATION)
<7>[    2.526680] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 7F 00 45 00
<7>[    2.533558] [drm:intel_sdvo_debug_write], SDVOC: W: 56                         (SDVO_CMD_GET_SATURATION)
<7>[    2.538226] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 45 00
<7>[    2.541668] [drm:intel_sdvo_create_enhance_property_tv], saturation: max 127, default 69, current 69
<7>[    2.541672] [drm:intel_sdvo_debug_write], SDVOC: W: 5E                         (SDVO_CMD_GET_MAX_CONTRAST)
<7>[    2.546341] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 7F 00 40 00
<7>[    2.553225] [drm:intel_sdvo_debug_write], SDVOC: W: 5F                         (SDVO_CMD_GET_CONTRAST)
<7>[    2.557892] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 40 00
<7>[    2.561335] [drm:intel_sdvo_create_enhance_property_tv], contrast: max 127, default 64, current 64
<7>[    2.561339] [drm:intel_sdvo_debug_write], SDVOC: W: 58                         (SDVO_CMD_GET_MAX_HUE)
<7>[    2.566007] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 7F 00 40 00
<7>[    2.572886] [drm:intel_sdvo_debug_write], SDVOC: W: 59                         (SDVO_CMD_GET_HUE)
<7>[    2.577553] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 40 00
<7>[    2.580996] [drm:intel_sdvo_create_enhance_property_tv], hue: max 127, default 64, current 64
<7>[    2.581000] [drm:intel_sdvo_debug_write], SDVOC: W: 6D                         (SDVO_CMD_GET_MAX_SHARPNESS)
<7>[    2.585667] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 07 00 04 00
<7>[    2.592546] [drm:intel_sdvo_debug_write], SDVOC: W: 6E                         (SDVO_CMD_GET_SHARPNESS)
<7>[    2.597214] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 04 00
<7>[    2.600656] [drm:intel_sdvo_create_enhance_property_tv], sharpness: max 7, default 4, current 4
<7>[    2.600660] [drm:intel_sdvo_debug_write], SDVOC: W: 5B                         (SDVO_CMD_GET_MAX_BRIGHTNESS)
<7>[    2.605328] [drm:intel_sdvo_read_response], SDVOC: R: (Success) FF 00 80 00
<7>[    2.612207] [drm:intel_sdvo_debug_write], SDVOC: W: 5C                         (SDVO_CMD_GET_BRIGHTNESS)
<7>[    2.616874] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 80 00
<7>[    2.620317] [drm:intel_sdvo_create_enhance_property_tv], brightness: max 255, default 128, current 128
<7>[    2.620321] [drm:intel_sdvo_debug_write], SDVOC: W: 7B                         (SDVO_CMD_GET_MAX_FLICKER_FILTER_ADAPTIVE)
<7>[    2.624990] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 07 00 07 00
<7>[    2.631865] [drm:intel_sdvo_debug_write], SDVOC: W: 50                         (SDVO_CMD_GET_FLICKER_FILTER_ADAPTIVE)
<7>[    2.636540] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 07 00
<7>[    2.639977] [drm:intel_sdvo_create_enhance_property_tv], flicker_filter_adaptive: max 7, default 7, current 7
<7>[    2.639981] [drm:intel_sdvo_debug_write], SDVOC: W: 74                         (SDVO_CMD_GET_MAX_TV_CHROMA_FILTER)
<7>[    2.644654] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 03 00 01 00
<7>[    2.651528] [drm:intel_sdvo_debug_write], SDVOC: W: 75                         (SDVO_CMD_GET_TV_CHROMA_FILTER)
<7>[    2.656201] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 01 00
<7>[    2.659638] [drm:intel_sdvo_create_enhance_property_tv], tv_chroma_filter: max 3, default 1, current 1
<7>[    2.659642] [drm:intel_sdvo_debug_write], SDVOC: W: 77                         (SDVO_CMD_GET_MAX_TV_LUMA_FILTER)
<7>[    2.664315] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 02 00 00 00
<7>[    2.671189] [drm:intel_sdvo_debug_write], SDVOC: W: 78                         (SDVO_CMD_GET_TV_LUMA_FILTER)
<7>[    2.675857] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
<7>[    2.679299] [drm:intel_sdvo_create_enhance_property_tv], tv_luma_filter: max 2, default 0, current 0
<7>[    2.679303] [drm:intel_sdvo_debug_write], SDVOC: W: 70                         (SDVO_CMD_GET_DOT_CRAWL)
<7>[    2.683971] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
<7>[    2.687414] [drm:intel_sdvo_create_enhance_property_tv], dot crawl: current 0
<7>[    2.687444] [drm:intel_sdvo_debug_write], SDVOC: W: 11 04 00                   (SDVO_CMD_SET_TARGET_OUTPUT)
<7>[    2.692849] [drm:intel_sdvo_debug_write], SDVOC: W: 27                         (SDVO_CMD_GET_SUPPORTED_TV_FORMATS)
<7>[    2.697516] [drm:intel_sdvo_read_response], SDVOC: R: (Success) FF FF FF FF FF 1F
<7>[    2.707834] [drm:intel_sdvo_debug_write], SDVOC: W: 84                         (SDVO_CMD_GET_SUPPORTED_ENHANCEMENTS)
<7>[    2.712507] [drm:intel_sdvo_read_response], SDVOC: R: (Success) FA DF
<7>[    2.715943] [drm:intel_sdvo_debug_write], SDVOC: W: 61                         (SDVO_CMD_GET_MAX_OVERSCAN_H)
<7>[    2.720616] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 2F 00 20 00
<7>[    2.727490] [drm:intel_sdvo_debug_write], SDVOC: W: 62                         (SDVO_CMD_GET_OVERSCAN_H)
<7>[    2.732163] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 20 00
<7>[    2.735600] [drm:intel_sdvo_create_enhance_property_tv], h_overscan: max 47, default 32, current 32
<7>[    2.735604] [drm:intel_sdvo_debug_write], SDVOC: W: 64                         (SDVO_CMD_GET_MAX_OVERSCAN_V)
<7>[    2.740278] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 2F 00 20 00
<7>[    2.747151] [drm:intel_sdvo_debug_write], SDVOC: W: 65                         (SDVO_CMD_GET_OVERSCAN_V)
<7>[    2.751820] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 20 00
<7>[    2.755267] [drm:intel_sdvo_create_enhance_property_tv], v_overscan: max 47, default 32, current 32
<7>[    2.755272] [drm:intel_sdvo_debug_write], SDVOC: W: 67                         (SDVO_CMD_GET_MAX_HPOS)
<7>[    2.759939] [drm:intel_sdvo_read_response], SDVOC: R: (Success) FF 03 00 02
<7>[    2.766820] [drm:intel_sdvo_debug_write], SDVOC: W: 68                         (SDVO_CMD_GET_HPOS)
<7>[    2.771488] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 02
<7>[    2.774931] [drm:intel_sdvo_create_enhance_property_tv], hpos: max 1023, default 512, current 512
<7>[    2.774936] [drm:intel_sdvo_debug_write], SDVOC: W: 6A                         (SDVO_CMD_GET_MAX_VPOS)
<7>[    2.779606] [drm:intel_sdvo_read_response], SDVOC: R: (Success) FF 03 00 02
<7>[    2.786488] [drm:intel_sdvo_debug_write], SDVOC: W: 6B                         (SDVO_CMD_GET_VPOS)
<7>[    2.791156] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 02
<7>[    2.794600] [drm:intel_sdvo_create_enhance_property_tv], vpos: max 1023, default 512, current 512
<7>[    2.794604] [drm:intel_sdvo_debug_write], SDVOC: W: 55                         (SDVO_CMD_GET_MAX_SATURATION)
<7>[    2.799272] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 7F 00 45 00
<7>[    2.806151] [drm:intel_sdvo_debug_write], SDVOC: W: 56                         (SDVO_CMD_GET_SATURATION)
<7>[    2.810818] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 45 00
<7>[    2.814260] [drm:intel_sdvo_create_enhance_property_tv], saturation: max 127, default 69, current 69
<7>[    2.814264] [drm:intel_sdvo_debug_write], SDVOC: W: 5E                         (SDVO_CMD_GET_MAX_CONTRAST)
<7>[    2.818932] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 7F 00 40 00
<7>[    2.825813] [drm:intel_sdvo_debug_write], SDVOC: W: 5F                         (SDVO_CMD_GET_CONTRAST)
<7>[    2.830480] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 40 00
<7>[    2.833923] [drm:intel_sdvo_create_enhance_property_tv], contrast: max 127, default 64, current 64
<7>[    2.833927] [drm:intel_sdvo_debug_write], SDVOC: W: 58                         (SDVO_CMD_GET_MAX_HUE)
<7>[    2.838597] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 7F 00 40 00
<7>[    2.845478] [drm:intel_sdvo_debug_write], SDVOC: W: 59                         (SDVO_CMD_GET_HUE)
<7>[    2.850147] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 40 00
<7>[    2.853592] [drm:intel_sdvo_create_enhance_property_tv], hue: max 127, default 64, current 64
<7>[    2.853596] [drm:intel_sdvo_debug_write], SDVOC: W: 6D                         (SDVO_CMD_GET_MAX_SHARPNESS)
<7>[    2.858264] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 07 00 04 00
<7>[    2.865143] [drm:intel_sdvo_debug_write], SDVOC: W: 6E                         (SDVO_CMD_GET_SHARPNESS)
<7>[    2.869810] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 04 00
<7>[    2.873253] [drm:intel_sdvo_create_enhance_property_tv], sharpness: max 7, default 4, current 4
<7>[    2.873257] [drm:intel_sdvo_debug_write], SDVOC: W: 5B                         (SDVO_CMD_GET_MAX_BRIGHTNESS)
<7>[    2.877925] [drm:intel_sdvo_read_response], SDVOC: R: (Success) FF 00 80 00
<7>[    2.884804] [drm:intel_sdvo_debug_write], SDVOC: W: 5C                         (SDVO_CMD_GET_BRIGHTNESS)
<7>[    2.889471] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 80 00
<7>[    2.892914] [drm:intel_sdvo_create_enhance_property_tv], brightness: max 255, default 128, current 128
<7>[    2.892918] [drm:intel_sdvo_debug_write], SDVOC: W: 7B                         (SDVO_CMD_GET_MAX_FLICKER_FILTER_ADAPTIVE)
<7>[    2.897586] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 07 00 07 00
<7>[    2.904465] [drm:intel_sdvo_debug_write], SDVOC: W: 50                         (SDVO_CMD_GET_FLICKER_FILTER_ADAPTIVE)
<7>[    2.909132] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 07 00
<7>[    2.912576] [drm:intel_sdvo_create_enhance_property_tv], flicker_filter_adaptive: max 7, default 7, current 7
<7>[    2.912580] [drm:intel_sdvo_debug_write], SDVOC: W: 74                         (SDVO_CMD_GET_MAX_TV_CHROMA_FILTER)
<7>[    2.917248] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 03 00 01 00
<7>[    2.924128] [drm:intel_sdvo_debug_write], SDVOC: W: 75                         (SDVO_CMD_GET_TV_CHROMA_FILTER)
<7>[    2.928797] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 01 00
<7>[    2.932241] [drm:intel_sdvo_create_enhance_property_tv], tv_chroma_filter: max 3, default 1, current 1
<7>[    2.932245] [drm:intel_sdvo_debug_write], SDVOC: W: 77                         (SDVO_CMD_GET_MAX_TV_LUMA_FILTER)
<7>[    2.936913] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 02 00 00 00
<7>[    2.943787] [drm:intel_sdvo_debug_write], SDVOC: W: 78                         (SDVO_CMD_GET_TV_LUMA_FILTER)
<7>[    2.948460] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
<7>[    2.951897] [drm:intel_sdvo_create_enhance_property_tv], tv_luma_filter: max 2, default 0, current 0
<7>[    2.951901] [drm:intel_sdvo_debug_write], SDVOC: W: 70                         (SDVO_CMD_GET_DOT_CRAWL)
<7>[    2.956574] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
<7>[    2.960016] [drm:intel_sdvo_create_enhance_property_tv], dot crawl: current 0
<7>[    2.960043] [drm:intel_sdvo_debug_write], SDVOC: W: 10 00                      (SDVO_CMD_SET_TARGET_INPUT)
<7>[    2.964219] [drm:intel_sdvo_debug_write], SDVOC: W: 1D                         (SDVO_CMD_GET_INPUT_PIXEL_CLOCK_RANGE)
<7>[    2.968886] [drm:intel_sdvo_read_response], SDVOC: R: (Success) C4 09 D8 40
<7>[    2.975758] [drm:intel_sdvo_init], SDVOC device VID/DID: 02:C2.01, clock range 25MHz - 166MHz, input 1: Y, input 2: N, output 1: Y, output 2: N
<6>[    2.976204] [drm] initialized overlay support
<7>[    2.976351] [drm:intel_sdvo_debug_write], SDVOB: W: 05 00 00                   (SDVO_CMD_SET_ACTIVE_OUTPUTS)
<7>[    2.981751] [drm:intel_sdvo_debug_write], SDVOC: W: 05 00 00                   (SDVO_CMD_SET_ACTIVE_OUTPUTS)
<7>[    2.997227] [drm:intel_update_fbc], 
<7>[    2.997230] [drm:intel_update_watermarks], plane A (pipe 1) clock: 0
<7>[    2.997235] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
<7>[    2.997239] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
<7>[    2.997242] [drm:intel_calculate_wm], FIFO entries required for mode: 0
<7>[    2.997245] [drm:intel_calculate_wm], FIFO watermark level: 26
<7>[    2.997248] [drm:intel_calculate_wm], FIFO entries required for mode: 0
<7>[    2.997251] [drm:intel_calculate_wm], FIFO watermark level: 29
<7>[    2.997254] [drm:i9xx_update_wm], FIFO watermarks - A: 26, B: 29
<7>[    2.997258] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 26, B: 29, C: 2, SR 1
<7>[    2.997263] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 1
<7>[    2.997268] [drm:intel_update_fbc], 
<7>[    2.997274] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:VGA-1]
<7>[    3.000969] [drm:intel_crt_detect_ddc], CRT detected via DDC:0x50 [EDID]
<7>[    3.053581] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:VGA-1] probed modes :
<7>[    3.053585] [drm:drm_mode_debug_printmodeline], Modeline 61:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
<7>[    3.053591] [drm:drm_mode_debug_printmodeline], Modeline 72:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
<7>[    3.053598] [drm:drm_mode_debug_printmodeline], Modeline 63:"1280x960" 75 129936 1280 1368 1504 1728 960 961 964 1002 0x0 0x6
<7>[    3.053604] [drm:drm_mode_debug_printmodeline], Modeline 62:"1280x960" 60 108000 1280 1376 1488 1800 960 961 964 1000 0x40 0x5
<7>[    3.053610] [drm:drm_mode_debug_printmodeline], Modeline 79:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
<7>[    3.053616] [drm:drm_mode_debug_printmodeline], Modeline 73:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
<7>[    3.053623] [drm:drm_mode_debug_printmodeline], Modeline 74:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
<7>[    3.053629] [drm:drm_mode_debug_printmodeline], Modeline 75:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
<7>[    3.053635] [drm:drm_mode_debug_printmodeline], Modeline 76:"832x624" 75 57284 832 864 928 1152 624 625 628 667 0x40 0xa
<7>[    3.053641] [drm:drm_mode_debug_printmodeline], Modeline 78:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
<7>[    3.053647] [drm:drm_mode_debug_printmodeline], Modeline 77:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
<7>[    3.053653] [drm:drm_mode_debug_printmodeline], Modeline 65:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
<7>[    3.053659] [drm:drm_mode_debug_printmodeline], Modeline 66:"800x600" 56 36000 800 824 896 1024 600 601 603 625 0x40 0x5
<7>[    3.053665] [drm:drm_mode_debug_printmodeline], Modeline 68:"640x480" 73 31500 640 664 704 832 480 489 491 520 0x40 0xa
<7>[    3.053671] [drm:drm_mode_debug_printmodeline], Modeline 67:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
<7>[    3.053677] [drm:drm_mode_debug_printmodeline], Modeline 69:"640x480" 67 30240 640 704 768 864 480 483 486 525 0x40 0xa
<7>[    3.053683] [drm:drm_mode_debug_printmodeline], Modeline 70:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
<7>[    3.053689] [drm:drm_mode_debug_printmodeline], Modeline 71:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
<7>[    3.053696] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:8:DVI-D-1]
<7>[    3.053699] [drm:intel_sdvo_debug_write], SDVOB: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
<7>[    3.058368] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 01 00
<7>[    3.061811] [drm:intel_sdvo_detect], SDVO response 1 0 [1]
<7>[    3.061815] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
<7>[    3.067708] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
<7>[    3.122777] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
<7>[    3.128676] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
<7>[    3.183706] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:8:DVI-D-1] probed modes :
<7>[    3.183710] [drm:drm_mode_debug_printmodeline], Modeline 80:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
<7>[    3.183716] [drm:drm_mode_debug_printmodeline], Modeline 84:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
<7>[    3.183722] [drm:drm_mode_debug_printmodeline], Modeline 81:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
<7>[    3.183728] [drm:drm_mode_debug_printmodeline], Modeline 82:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
<7>[    3.183734] [drm:drm_mode_debug_printmodeline], Modeline 83:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
<7>[    3.183741] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:10:SVIDEO-1]
<7>[    3.183744] [drm:intel_sdvo_debug_write], SDVOC: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
<7>[    3.191849] [drm:intel_sdvo_write_cmd], command returns response Pending [4]
<7>[    3.191853] [drm:intel_sdvo_debug_write], SDVOC: W: 11 00 00                   (SDVO_CMD_SET_TARGET_OUTPUT)
<7>[    3.197254] [drm:intel_sdvo_write_cmd], command returns response Invalid arg [3]
<7>[    3.197258] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:27:SVIDEO-2]
<7>[    3.197262] [drm:intel_sdvo_debug_write], SDVOC: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
<7>[    3.205369] [drm:intel_sdvo_write_cmd], command returns response Pending [4]
<7>[    3.205372] [drm:intel_sdvo_debug_write], SDVOC: W: 11 00 00                   (SDVO_CMD_SET_TARGET_OUTPUT)
<7>[    3.210770] [drm:intel_sdvo_write_cmd], command returns response Invalid arg [3]
<7>[    3.210774] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:44:VGA-2]
<7>[    3.210777] [drm:intel_sdvo_debug_write], SDVOC: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
<7>[    3.218881] [drm:intel_sdvo_write_cmd], command returns response Pending [4]
<7>[    3.218885] [drm:intel_sdvo_debug_write], SDVOC: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
<7>[    3.277593] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:45:SVIDEO-3]
<7>[    3.277599] [drm:drm_crtc_helper_set_mode], [CRTC:3]
<7>[    3.277603] [drm:intel_sdvo_debug_write], SDVOB: W: 05 00 00                   (SDVO_CMD_SET_ACTIVE_OUTPUTS)
<7>[    3.283002] [drm:intel_sdvo_debug_write], SDVOC: W: 05 00 00                   (SDVO_CMD_SET_ACTIVE_OUTPUTS)
<7>[    3.288708] [drm:intel_crtc_mode_set], Mode for pipe A:
<7>[    3.288711] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
<7>[    3.296008] [drm:intel_pipe_set_base], No FB bound
<7>[    3.296011] [drm:drm_crtc_helper_set_mode], [ENCODER:46:TV-46] set [MODE:0:NTSC 480i]
<7>[    3.315888] [drm:intel_update_watermarks], plane B (pipe 0) clock: 107520
<7>[    3.315892] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
<7>[    3.315895] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
<7>[    3.315899] [drm:intel_calculate_wm], FIFO entries required for mode: 0
<7>[    3.315902] [drm:intel_calculate_wm], FIFO watermark level: 26
<7>[    3.315905] [drm:intel_calculate_wm], FIFO entries required for mode: 34
<7>[    3.315908] [drm:intel_calculate_wm], FIFO watermark level: -5
<7>[    3.315911] [drm:i9xx_update_wm], FIFO watermarks - A: 26, B: 1
<7>[    3.315914] [drm:i9xx_update_wm], self-refresh entries: 80
<7>[    3.315917] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 26, B: 1, C: 2, SR 15
<7>[    3.315961] [drm:intel_update_fbc], 
<7>[    3.392006] [drm:intel_sdvo_debug_write], SDVOB: W: 05 00 00                   (SDVO_CMD_SET_ACTIVE_OUTPUTS)
<7>[    3.397405] [drm:intel_sdvo_debug_write], SDVOC: W: 05 00 00                   (SDVO_CMD_SET_ACTIVE_OUTPUTS)
<7>[    3.402805] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:45:SVIDEO-3] disconnected
<7>[    3.402809] [drm:drm_setup_crtcs], 
<7>[    3.402812] [drm:drm_enable_connectors], connector 5 enabled? yes
<7>[    3.402815] [drm:drm_enable_connectors], connector 8 enabled? yes
<7>[    3.402818] [drm:drm_enable_connectors], connector 10 enabled? no
<7>[    3.402821] [drm:drm_enable_connectors], connector 27 enabled? no
<7>[    3.402824] [drm:drm_enable_connectors], connector 44 enabled? no
<7>[    3.402828] [drm:drm_enable_connectors], connector 45 enabled? no
<7>[    3.402831] [drm:drm_target_preferred], looking for cmdline mode on connector 5
<7>[    3.402835] [drm:drm_target_preferred], looking for preferred mode on connector 5
<7>[    3.402838] [drm:drm_target_preferred], found mode 1280x1024
<7>[    3.402841] [drm:drm_target_preferred], looking for cmdline mode on connector 8
<7>[    3.402844] [drm:drm_target_preferred], looking for preferred mode on connector 8
<7>[    3.402848] [drm:drm_target_preferred], found mode 1280x1024
<7>[    3.402851] [drm:drm_setup_crtcs], picking CRTCs for 4096x4096 config
<7>[    3.402856] [drm:drm_setup_crtcs], desired mode 1280x1024 set on crtc 3
<7>[    3.402860] [drm:drm_setup_crtcs], desired mode 1280x1024 set on crtc 4
<7>[    3.411434] [drm:intelfb_create], allocated 1280x1024 fb: 0x007e0000, bo f4f02540
<7>[    3.413515] [drm:drm_crtc_helper_set_config], 
<7>[    3.413518] [drm:drm_crtc_helper_set_config], [CRTC:3] [FB:87] #connectors=1 (x y) (0 0)
<7>[    3.413527] [drm:drm_crtc_helper_set_config], crtc has no fb, full mode set
<7>[    3.413530] [drm:drm_crtc_helper_set_config], modes are different, full mode set
<7>[    3.413533] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
<7>[    3.413539] [drm:drm_mode_debug_printmodeline], Modeline 85:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
<7>[    3.413545] [drm:drm_crtc_helper_set_config], encoder changed, full mode switch
<7>[    3.413548] [drm:drm_crtc_helper_set_config], crtc changed, full mode switch
<7>[    3.413551] [drm:drm_crtc_helper_set_config], [CONNECTOR:5:VGA-1] to [CRTC:3]
<7>[    3.413554] [drm:drm_crtc_helper_set_config], attempting to set mode from userspace
<7>[    3.413557] [drm:drm_mode_debug_printmodeline], Modeline 85:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
<7>[    3.413565] [drm:drm_crtc_helper_set_mode], [CRTC:3]
<7>[    3.413569] [drm:intel_sdvo_debug_write], SDVOB: W: 05 00 00                   (SDVO_CMD_SET_ACTIVE_OUTPUTS)
<7>[    3.418969] [drm:intel_sdvo_debug_write], SDVOC: W: 05 00 00                   (SDVO_CMD_SET_ACTIVE_OUTPUTS)
<7>[    3.434447] [drm:intel_update_fbc], 
<7>[    3.434752] [drm:intel_crtc_mode_set], Mode for pipe A:
<7>[    3.434754] [drm:drm_mode_debug_printmodeline], Modeline 85:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
<7>[    3.440009] [drm:intel_pipe_set_base_atomic], Writing base 007E0000 00000000 0 0 5120
<7>[    3.440014] [drm:intel_update_fbc], 
<7>[    3.440017] [drm:drm_crtc_helper_set_mode], [ENCODER:6:DAC-6] set [MODE:85:1280x1024]
<7>[    3.440021] [drm:intel_update_watermarks], plane B (pipe 0) clock: 108000
<7>[    3.440025] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
<7>[    3.440028] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
<7>[    3.440031] [drm:intel_calculate_wm], FIFO entries required for mode: 0
<7>[    3.440034] [drm:intel_calculate_wm], FIFO watermark level: 26
<7>[    3.440036] [drm:intel_calculate_wm], FIFO entries required for mode: 34
<7>[    3.440039] [drm:intel_calculate_wm], FIFO watermark level: -5
<7>[    3.440041] [drm:i9xx_update_wm], FIFO watermarks - A: 26, B: 1
<7>[    3.440044] [drm:i9xx_update_wm], self-refresh entries: 80
<7>[    3.440047] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 26, B: 1, C: 2, SR 15
<7>[    3.440212] [drm:intel_update_fbc], 
<7>[    3.440216] [drm:intel_sdvo_debug_write], SDVOB: W: 05 00 00                   (SDVO_CMD_SET_ACTIVE_OUTPUTS)
<7>[    3.445614] [drm:intel_sdvo_debug_write], SDVOC: W: 05 00 00                   (SDVO_CMD_SET_ACTIVE_OUTPUTS)
<7>[    3.451011] [drm:drm_crtc_helper_set_config], Setting connector DPMS state to on
<7>[    3.451014] [drm:drm_crtc_helper_set_config], 	[CONNECTOR:5:VGA-1] set DPMS on
<7>[    3.451018] [drm:drm_crtc_helper_set_config], 
<7>[    3.451020] [drm:drm_crtc_helper_set_config], [CRTC:4] [FB:87] #connectors=1 (x y) (0 0)
<7>[    3.451026] [drm:drm_crtc_helper_set_config], crtc has no fb, full mode set
<7>[    3.451029] [drm:drm_crtc_helper_set_config], modes are different, full mode set
<7>[    3.451032] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0x0
<7>[    3.451036] [drm:drm_mode_debug_printmodeline], Modeline 86:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
<7>[    3.451042] [drm:drm_crtc_helper_set_config], encoder changed, full mode switch
<7>[    3.451045] [drm:drm_crtc_helper_set_config], [CONNECTOR:5:VGA-1] to [CRTC:3]
<7>[    3.451048] [drm:drm_crtc_helper_set_config], crtc changed, full mode switch
<7>[    3.451051] [drm:drm_crtc_helper_set_config], [CONNECTOR:8:DVI-D-1] to [CRTC:4]
<7>[    3.451054] [drm:drm_crtc_helper_set_config], attempting to set mode from userspace
<7>[    3.451057] [drm:drm_mode_debug_printmodeline], Modeline 86:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
<7>[    3.451064] [drm:drm_crtc_helper_set_mode], [CRTC:4]
<7>[    3.451066] [drm:intel_sdvo_debug_write], SDVOB: W: 05 00 00                   (SDVO_CMD_SET_ACTIVE_OUTPUTS)
<7>[    3.456471] [drm:intel_sdvo_debug_write], SDVOC: W: 05 00 00                   (SDVO_CMD_SET_ACTIVE_OUTPUTS)
<7>[    3.462167] [drm:intel_crtc_mode_set], Mode for pipe B:
<7>[    3.462169] [drm:drm_mode_debug_printmodeline], Modeline 86:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
<7>[    3.468006] [drm:intel_pipe_set_base_atomic], Writing base 007E0000 00000000 0 0 5120
<7>[    3.468010] [drm:intel_update_fbc], 
<7>[    3.468012] [drm:intel_update_watermarks], plane B (pipe 0) clock: 108000
<7>[    3.468016] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
<7>[    3.468019] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
<7>[    3.468022] [drm:intel_calculate_wm], FIFO entries required for mode: 0
<7>[    3.468024] [drm:intel_calculate_wm], FIFO watermark level: 26
<7>[    3.468027] [drm:intel_calculate_wm], FIFO entries required for mode: 34
<7>[    3.468029] [drm:intel_calculate_wm], FIFO watermark level: -5
<7>[    3.468032] [drm:i9xx_update_wm], FIFO watermarks - A: 26, B: 1
<7>[    3.468034] [drm:i9xx_update_wm], self-refresh entries: 80
<7>[    3.468037] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 26, B: 1, C: 2, SR 15
<7>[    3.468041] [drm:drm_crtc_helper_set_mode], [ENCODER:7:TMDS-7] set [MODE:86:1280x1024]
<7>[    3.468045] [drm:intel_sdvo_debug_write], SDVOB: W: 07 01 00 00 00             (SDVO_CMD_SET_IN_OUT_MAP)
<7>[    3.475888] [drm:intel_sdvo_debug_write], SDVOB: W: 11 01 00                   (SDVO_CMD_SET_TARGET_OUTPUT)
<7>[    3.481291] [drm:intel_sdvo_debug_write], SDVOB: W: 11 01 00                   (SDVO_CMD_SET_TARGET_OUTPUT)
<7>[    3.486685] [drm:intel_sdvo_debug_write], SDVOB: W: 16 30 2A 00 98 51 00 2A 40 (SDVO_CMD_SET_OUTPUT_TIMINGS_PART1)
<7>[    3.499435] [drm:intel_sdvo_debug_write], SDVOB: W: 17 30 70 13 00 1E 00 00 00 (SDVO_CMD_SET_OUTPUT_TIMINGS_PART2)
<7>[    3.512188] [drm:intel_sdvo_debug_write], SDVOB: W: 10 00                      (SDVO_CMD_SET_TARGET_INPUT)
<7>[    3.516361] [drm:intel_sdvo_debug_write], SDVOB: W: 14 30 2A 00 98 51 00 2A 40 (SDVO_CMD_SET_INPUT_TIMINGS_PART1)
<7>[    3.529110] [drm:intel_sdvo_debug_write], SDVOB: W: 15 30 70 13 00 1E 00 00 00 (SDVO_CMD_SET_INPUT_TIMINGS_PART2)
<7>[    3.541858] [drm:intel_sdvo_debug_write], SDVOB: W: 21 01                      (SDVO_CMD_SET_CLOCK_RATE_MULT)
<7>[    3.546034] [drm:intel_update_watermarks], plane B (pipe 0) clock: 108000
<7>[    3.546037] [drm:intel_update_watermarks], plane A (pipe 1) clock: 108000
<7>[    3.546040] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
<7>[    3.546043] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
<7>[    3.546046] [drm:intel_calculate_wm], FIFO entries required for mode: 34
<7>[    3.546049] [drm:intel_calculate_wm], FIFO watermark level: -8
<7>[    3.546051] [drm:intel_calculate_wm], FIFO entries required for mode: 34
<7>[    3.546054] [drm:intel_calculate_wm], FIFO watermark level: -5
<7>[    3.546056] [drm:i9xx_update_wm], FIFO watermarks - A: 1, B: 1
<7>[    3.546059] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 1, B: 1, C: 2, SR 1
<7>[    3.546102] [drm:intel_update_fbc], 
<7>[    3.584005] [drm:intel_sdvo_debug_write], SDVOB: W: 03                         (SDVO_CMD_GET_TRAINED_INPUTS)
<7>[    3.588672] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 01
<7>[    3.590391] [drm:intel_sdvo_debug_write], SDVOB: W: 05 01 00                   (SDVO_CMD_SET_ACTIVE_OUTPUTS)
<7>[    3.595788] [drm:intel_sdvo_debug_write], SDVOC: W: 05 00 00                   (SDVO_CMD_SET_ACTIVE_OUTPUTS)
<7>[    3.601190] [drm:drm_crtc_helper_set_config], Setting connector DPMS state to on
<7>[    3.601193] [drm:drm_crtc_helper_set_config], 	[CONNECTOR:8:DVI-D-1] set DPMS on
<7>[    3.601221] [drm:drm_crtc_helper_set_config], 
<7>[    3.601223] [drm:drm_crtc_helper_set_config], [CRTC:3] [FB:87] #connectors=1 (x y) (0 0)
<7>[    3.601230] [drm:drm_crtc_helper_set_config], [CONNECTOR:5:VGA-1] to [CRTC:3]
<7>[    3.601233] [drm:drm_crtc_helper_set_config], [CONNECTOR:8:DVI-D-1] to [CRTC:4]
<7>[    3.601237] [drm:drm_crtc_helper_set_config], Setting connector DPMS state to on
<7>[    3.601239] [drm:drm_crtc_helper_set_config], 	[CONNECTOR:5:VGA-1] set DPMS on
<7>[    3.601242] [drm:drm_crtc_helper_set_config], 
<7>[    3.601244] [drm:drm_crtc_helper_set_config], [CRTC:4] [FB:87] #connectors=1 (x y) (0 0)
<7>[    3.601251] [drm:drm_crtc_helper_set_config], [CONNECTOR:5:VGA-1] to [CRTC:3]
<7>[    3.601255] [drm:drm_crtc_helper_set_config], [CONNECTOR:8:DVI-D-1] to [CRTC:4]
<7>[    3.601258] [drm:drm_crtc_helper_set_config], Setting connector DPMS state to on
<7>[    3.601261] [drm:drm_crtc_helper_set_config], 	[CONNECTOR:8:DVI-D-1] set DPMS on
<7>[    3.608250] [drm:drm_crtc_helper_set_config], 
<7>[    3.608252] [drm:drm_crtc_helper_set_config], [CRTC:3] [FB:87] #connectors=1 (x y) (0 0)
<7>[    3.608259] [drm:drm_crtc_helper_set_config], [CONNECTOR:5:VGA-1] to [CRTC:3]
<7>[    3.608263] [drm:drm_crtc_helper_set_config], [CONNECTOR:8:DVI-D-1] to [CRTC:4]
<7>[    3.608266] [drm:drm_crtc_helper_set_config], Setting connector DPMS state to on
<7>[    3.608269] [drm:drm_crtc_helper_set_config], 	[CONNECTOR:5:VGA-1] set DPMS on
<7>[    3.608272] [drm:drm_crtc_helper_set_config], 
<7>[    3.608274] [drm:drm_crtc_helper_set_config], [CRTC:4] [FB:87] #connectors=1 (x y) (0 0)
<7>[    3.608280] [drm:drm_crtc_helper_set_config], [CONNECTOR:5:VGA-1] to [CRTC:3]
<7>[    3.608284] [drm:drm_crtc_helper_set_config], [CONNECTOR:8:DVI-D-1] to [CRTC:4]
<7>[    3.608287] [drm:drm_crtc_helper_set_config], Setting connector DPMS state to on
<7>[    3.608290] [drm:drm_crtc_helper_set_config], 	[CONNECTOR:8:DVI-D-1] set DPMS on
<4>[    3.615252] Console: switching to colour frame buffer device 160x64
<7>[    3.615258] [drm:drm_crtc_helper_set_config], 
<7>[    3.615260] [drm:drm_crtc_helper_set_config], [CRTC:3] [FB:87] #connectors=1 (x y) (0 0)
<7>[    3.615267] [drm:drm_crtc_helper_set_config], [CONNECTOR:5:VGA-1] to [CRTC:3]
<7>[    3.615271] [drm:drm_crtc_helper_set_config], [CONNECTOR:8:DVI-D-1] to [CRTC:4]
<7>[    3.615274] [drm:drm_crtc_helper_set_config], Setting connector DPMS state to on
<7>[    3.615277] [drm:drm_crtc_helper_set_config], 	[CONNECTOR:5:VGA-1] set DPMS on
<7>[    3.615280] [drm:drm_crtc_helper_set_config], 
<7>[    3.615282] [drm:drm_crtc_helper_set_config], [CRTC:4] [FB:87] #connectors=1 (x y) (0 0)
<7>[    3.615288] [drm:drm_crtc_helper_set_config], [CONNECTOR:5:VGA-1] to [CRTC:3]
<7>[    3.615292] [drm:drm_crtc_helper_set_config], [CONNECTOR:8:DVI-D-1] to [CRTC:4]
<7>[    3.615295] [drm:drm_crtc_helper_set_config], Setting connector DPMS state to on
<7>[    3.615298] [drm:drm_crtc_helper_set_config], 	[CONNECTOR:8:DVI-D-1] set DPMS on
<6>[    3.622349] fb0: inteldrmfb frame buffer device
<6>[    3.622390] drm: registered panic notifier
<6>[    3.622550] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
<6>[    3.622645] Serial: 8250/16550 driver, 8 ports, IRQ sharing enabled
<6>[    3.643053] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
<6>[    3.663457] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
<6>[    3.684096] 00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
<6>[    3.704517] 00:07: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
<6>[    3.704979] parport_pc 00:08: reported by Plug and Play ACPI
<6>[    3.705078] parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,ECP,DMA]
<6>[    3.800051] lp0: using parport0 (interrupt-driven).
<6>[    3.800682] loop: module loaded
<6>[    3.800713] Uniform Multi-Platform E-IDE driver
<6>[    3.800798] piix 0000:00:1f.1: IDE controller (0x8086:0x266f rev 0x04)
<6>[    3.800870] PIIX_IDE 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
<6>[    3.800941] piix 0000:00:1f.1: IDE port disabled
<6>[    3.800990] piix 0000:00:1f.1: not 100% native mode: will probe irqs later
<6>[    3.801054]     ide0: BM-DMA at 0xf000-0xf007
<7>[    3.801099] Probing IDE interface ide0...
<6>[    4.536206] hda: PLEXTOR DVDR PX-755A, ATAPI CD/DVD-ROM drive
<7>[    4.872035] hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
<6>[    4.872101] hda: UDMA/66 mode selected
<6>[    4.872210] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
<6>[    4.873989] ide-gd driver 1.18
<6>[    4.874030] ide-cd driver 5.00
<6>[    4.874724] ide-cd: hda: ATAPI 40X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache
<6>[    4.874822] cdrom: Uniform CD-ROM driver Revision: 3.20
<7>[    4.884356] sata_sil24 0000:04:00.0: version 1.1
<6>[    4.884367] sata_sil24 0000:04:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
<7>[    4.884479] sata_sil24 0000:04:00.0: setting latency timer to 64
<6>[    4.884770] scsi0 : sata_sil24
<6>[    4.884867] scsi1 : sata_sil24
<6>[    4.884933] ata1: SATA max UDMA/100 host m128@0xd2184000 port 0xd2180000 irq 19
<6>[    4.885000] ata2: SATA max UDMA/100 host m128@0xd2184000 port 0xd2182000 irq 19
<7>[    4.885098] ata_piix 0000:00:1f.2: version 2.13
<6>[    4.885108] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
<6>[    4.885173] ata_piix 0000:00:1f.2: MAP [ P0 P2 -- -- ]
<7>[    4.885275] ata_piix 0000:00:1f.2: setting latency timer to 64
<6>[    4.885480] scsi2 : ata_piix
<6>[    4.885569] scsi3 : ata_piix
<6>[    4.885632] ata3: SATA max UDMA/133 cmd 0xe500 ctl 0xe600 bmdma 0xe900 irq 19
<6>[    4.885695] ata4: SATA max UDMA/133 cmd 0xe700 ctl 0xe800 bmdma 0xe908 irq 19
<6>[    4.885798] sky2: driver version 1.28
<6>[    4.885849] sky2 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
<7>[    4.885915] sky2 0000:02:00.0: setting latency timer to 64
<6>[    4.885936] sky2 0000:02:00.0: Yukon-2 EC chip revision 1
<7>[    4.887890] sky2 0000:02:00.0: irq 40 for MSI/MSI-X
<6>[    4.888141] sky2 0000:02:00.0: eth0: addr 00:01:80:62:25:4b
<6>[    4.890042] sky2 0000:03:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
<7>[    4.891954] sky2 0000:03:00.0: setting latency timer to 64
<6>[    4.891974] sky2 0000:03:00.0: Yukon-2 EC chip revision 1
<7>[    4.894154] sky2 0000:03:00.0: irq 41 for MSI/MSI-X
<6>[    4.894366] sky2 0000:03:00.0: eth1: addr 00:01:80:62:25:4c
<6>[    4.896332] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
<6>[    4.898344] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
<7>[    4.900376] ehci_hcd 0000:00:1d.7: setting latency timer to 64
<6>[    4.900381] ehci_hcd 0000:00:1d.7: EHCI Host Controller
<6>[    4.902410] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
<7>[    4.908388] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
<6>[    4.908398] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xd2444000
<6>[    4.924008] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
<6>[    4.926124] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
<6>[    4.928242] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
<6>[    4.930380] usb usb1: Product: EHCI Host Controller
<6>[    4.932532] usb usb1: Manufacturer: Linux 2.6.37-rc8-git2-kape ehci_hcd
<6>[    4.934716] usb usb1: SerialNumber: 0000:00:1d.7
<6>[    4.936996] hub 1-0:1.0: USB hub found
<6>[    4.939209] hub 1-0:1.0: 8 ports detected
<6>[    4.941486] uhci_hcd: USB Universal Host Controller Interface driver
<6>[    4.943764] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
<7>[    4.946065] uhci_hcd 0000:00:1d.0: setting latency timer to 64
<6>[    4.946069] uhci_hcd 0000:00:1d.0: UHCI Host Controller
<6>[    4.948378] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
<6>[    4.950749] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000e000
<6>[    4.953133] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
<6>[    4.955492] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
<6>[    4.957878] usb usb2: Product: UHCI Host Controller
<6>[    4.960224] usb usb2: Manufacturer: Linux 2.6.37-rc8-git2-kape uhci_hcd
<6>[    4.962592] usb usb2: SerialNumber: 0000:00:1d.0
<6>[    4.965008] hub 2-0:1.0: USB hub found
<6>[    4.967326] hub 2-0:1.0: 2 ports detected
<6>[    4.969664] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
<7>[    4.972027] uhci_hcd 0000:00:1d.1: setting latency timer to 64
<6>[    4.972031] uhci_hcd 0000:00:1d.1: UHCI Host Controller
<6>[    4.974376] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
<6>[    4.976780] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000e100
<6>[    4.979169] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
<6>[    4.981535] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
<6>[    4.983891] usb usb3: Product: UHCI Host Controller
<6>[    4.986247] usb usb3: Manufacturer: Linux 2.6.37-rc8-git2-kape uhci_hcd
<6>[    4.988608] usb usb3: SerialNumber: 0000:00:1d.1
<6>[    4.991007] hub 3-0:1.0: USB hub found
<6>[    4.993328] hub 3-0:1.0: 2 ports detected
<6>[    4.995645] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
<7>[    4.997975] uhci_hcd 0000:00:1d.2: setting latency timer to 64
<6>[    4.997979] uhci_hcd 0000:00:1d.2: UHCI Host Controller
<6>[    5.000281] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
<6>[    5.002612] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000e200
<6>[    5.004943] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
<6>[    5.007258] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
<6>[    5.009619] usb usb4: Product: UHCI Host Controller
<6>[    5.011962] usb usb4: Manufacturer: Linux 2.6.37-rc8-git2-kape uhci_hcd
<6>[    5.014321] usb usb4: SerialNumber: 0000:00:1d.2
<6>[    5.016723] hub 4-0:1.0: USB hub found
<6>[    5.019038] hub 4-0:1.0: 2 ports detected
<6>[    5.021350] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
<7>[    5.023680] uhci_hcd 0000:00:1d.3: setting latency timer to 64
<6>[    5.023684] uhci_hcd 0000:00:1d.3: UHCI Host Controller
<6>[    5.025998] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
<6>[    5.028370] uhci_hcd 0000:00:1d.3: irq 16, io base 0x0000e300
<6>[    5.030722] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
<6>[    5.033072] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
<6>[    5.035412] usb usb5: Product: UHCI Host Controller
<6>[    5.037781] usb usb5: Manufacturer: Linux 2.6.37-rc8-git2-kape uhci_hcd
<6>[    5.040171] usb usb5: SerialNumber: 0000:00:1d.3
<6>[    5.042613] hub 5-0:1.0: USB hub found
<6>[    5.044967] hub 5-0:1.0: 2 ports detected
<6>[    5.047352] usbcore: registered new interface driver usblp
<6>[    5.060539] Initializing USB Mass Storage driver...
<6>[    5.062930] usbcore: registered new interface driver usb-storage
<6>[    5.065303] USB Mass Storage support registered.
<6>[    5.067739] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
<4>[    5.070275] PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
<6>[    5.073504] serio: i8042 KBD port at 0x60,0x64 irq 1
<6>[    5.075993] mice: PS/2 mouse device common for all mice
<6>[    5.078704] ata3.00: ATA-7: HDT722525DLA380, V44OA91A, max UDMA/133
<6>[    5.081210] input: PC Speaker as /devices/platform/pcspkr/input/input2
<6>[    5.083660] ata3.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 0/32)
<6>[    5.086192] rtc_cmos 00:03: RTC can wake from S4
<6>[    5.088778] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
<6>[    5.091265] ata3.01: ATA-8: ST31000340NS, SN05, max UDMA/133
<6>[    5.093759] ata3.01: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
<6>[    5.096355] rtc0: alarms up to one month, 242 bytes nvram, hpet irqs
<6>[    5.098861] i801_smbus 0000:00:1f.3: PCI INT B -> GSI 19 (level, low) -> IRQ 19
<6>[    5.101430] w83627hf: Found W83627THF chip at 0x290
<4>[    5.103973] ACPI: resource w83627hf [io  0x0295-0x0296] conflicts with ACPI region SEN1 [??? 0x00000295-0x00000296 flags 0x31]
<6>[    5.106731] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
<6>[    5.109443] device-mapper: uevent: version 1.0.3
<6>[    5.112319] device-mapper: ioctl: 4.18.0-ioctl (2010-06-29) initialised: dm-devel@redhat.com
<6>[    5.115037] ata3.00: configured for UDMA/133
<6>[    5.117768] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
<6>[    5.120662] cpuidle: using governor ladder
<6>[    5.123371] cpuidle: using governor menu
<6>[    5.126249] usbcore: registered new interface driver usbhid
<6>[    5.129075] usbhid: USB HID core driver
<6>[    5.132033] TCP cubic registered
<6>[    5.134901] Using IPI Shortcut mode
<4>[    5.137799] registered taskstats version 1
<6>[    5.140495] ata3.01: configured for UDMA/133
<6>[    5.143493] rtc_cmos 00:03: setting system clock to 2011-01-03 23:35:58 UTC (1294097758)
<6>[    5.146212] BIOS EDD facility v0.16 2004-Jun-25, 2 devices found
<6>[    5.156011] Marking TSC unstable due to cpufreq changes
<6>[    5.158499] Switching to clocksource hpet
<6>[    5.420031] usb 1-4: new high speed USB device using ehci_hcd and address 4
<6>[    5.563106] usb 1-4: New USB device found, idVendor=04b8, idProduct=011b
<6>[    5.568848] usb 1-4: New USB device strings: Mfr=1, Product=2, SerialNumber=0
<6>[    5.574604] usb 1-4: Product: EPSON Scanner
<6>[    5.580367] usb 1-4: Manufacturer: EPSON
<6>[    5.820092] usb 2-2: new low speed USB device using uhci_hcd and address 2
<6>[    6.002581] usb 2-2: New USB device found, idVendor=046d, idProduct=c50e
<6>[    6.008386] usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
<6>[    6.014174] usb 2-2: Product: USB RECEIVER
<6>[    6.019965] usb 2-2: Manufacturer: Logitech
<6>[    6.047125] input: Logitech USB RECEIVER as /devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.0/input/input4
<6>[    6.050060] generic-usb 0003:046D:C50E.0001: input,hidraw0: USB HID v1.11 Mouse [Logitech USB RECEIVER] on usb-0000:00:1d.0-2/input0
<6>[    6.296030] usb 3-1: new full speed USB device using uhci_hcd and address 2
<6>[    6.492627] usb 3-1: New USB device found, idVendor=03f0, idProduct=1d17
<6>[    6.498660] usb 3-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
<6>[    6.504719] usb 3-1: Product: hp LaserJet 1320 series
<6>[    6.510839] usb 3-1: Manufacturer: Hewlett-Packard
<6>[    6.513840] usb 3-1: SerialNumber: 00CNHW646GZH
<6>[    6.523650] usblp0: USB Bidirectional printer dev 2 if 0 alt 1 proto 2 vid 0x03F0 pid 0x1D17
<6>[    6.964036] ata1: SATA link down (SStatus 0 SControl 0)
<6>[    9.064035] ata2: SATA link down (SStatus 0 SControl 0)
<5>[    9.084196] scsi 2:0:0:0: Direct-Access     ATA      HDT722525DLA380  V44O PQ: 0 ANSI: 5
<5>[    9.090525] sd 2:0:0:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 GiB)
<5>[    9.096779] sd 2:0:0:0: Attached scsi generic sg0 type 0
<5>[    9.103000] sd 2:0:0:0: [sda] Write Protect is off
<5>[    9.109141] scsi 2:0:1:0: Direct-Access     ATA      ST31000340NS     SN05 PQ: 0 ANSI: 5
<7>[    9.112227] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
<5>[    9.112252] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
<5>[    9.115363] sd 2:0:1:0: [sdb] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
<5>[    9.118389] sd 2:0:1:0: Attached scsi generic sg1 type 0
<5>[    9.121391] sd 2:0:1:0: [sdb] Write Protect is off
<7>[    9.124502] sd 2:0:1:0: [sdb] Mode Sense: 00 3a 00 00
<5>[    9.139162] sd 2:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
<6>[    9.200964]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 sda9 >
<6>[    9.274421]  sdb: sdb1 sdb2 sdb4 < sdb5 sdb6 sdb7 sdb8 sdb9 >
<5>[    9.280737] sd 2:0:0:0: [sda] Attached SCSI disk
<5>[    9.287597] sd 2:0:1:0: [sdb] Attached SCSI disk
<6>[    9.293710] Freeing unused kernel memory: 320k freed
<6>[    9.296947] Write protecting the kernel text: 3268k
<6>[    9.299823] Write protecting the kernel read-only data: 1524k
<6>[    9.388144] udev: starting version 157
<4>[    9.390685] udevd (83): /proc/83/oom_adj is deprecated, please use /proc/83/oom_score_adj instead.
<5>[   10.973450] REISERFS (device sdb5): found reiserfs format "3.6" with standard journal
<5>[   10.976474] REISERFS (device sdb5): using ordered data mode
<5>[   10.980122] REISERFS (device sdb5): journal params: device sdb5, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
<5>[   10.986719] REISERFS (device sdb5): checking transaction log (sdb5)
<5>[   11.019721] REISERFS (device sdb5): Using r5 hash to sort names
<7>[   13.632024] [drm:intel_sdvo_debug_write], SDVOB: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
<7>[   13.636901] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 01 00
<7>[   13.640736] [drm:intel_sdvo_detect], SDVO response 1 0 [1]
<7>[   13.640746] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
<7>[   13.646713] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
<7>[   13.702884] [drm:output_poll_execute], [CONNECTOR:8:DVI-D-1] status updated from 1 to 1
<7>[   13.702895] [drm:intel_sdvo_debug_write], SDVOC: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
<7>[   13.711205] [drm:intel_sdvo_write_cmd], command returns response Pending [4]
<7>[   13.711215] [drm:output_poll_execute], [CONNECTOR:44:VGA-2] status updated from 3 to 3
<6>[   14.843810] udev: starting version 157
<5>[   15.081670] intel_rng: FWH not detected
<6>[   16.310221] RME Digi96 0000:05:05.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
<6>[   17.044769] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
<7>[   17.052062] HDA Intel 0000:00:1b.0: irq 42 for MSI/MSI-X
<7>[   17.052084] HDA Intel 0000:00:1b.0: setting latency timer to 64
<6>[   17.056558] NET: Registered protocol family 10
<6>[   17.059817] lo: Disabled Privacy Extensions
<6>[   17.144615] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input5
<6>[   17.366111] Adding 963896k swap on /dev/sda2.  Priority:-1 extents:1 across:963896k 
<6>[   17.388890] Adding 4200992k swap on /dev/sdb2.  Priority:-2 extents:1 across:4200992k 

--------------040009030301020905030909--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593Ab2JAQmr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 12:42:47 -0400
Received: from nm28-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.234]:34278 "HELO
	nm28-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753541Ab2JAQmc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 12:42:32 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 570482.17170.bm@omp1050.mail.sp2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=ZZp3t5jqDnYNkU5JRlRFJ5dfIJicGnSRbGfgiUiW1phbnze0MBlG1DSfxPpXbwhVdLJsOqw7DRSv/FXe7YcWjwCut3ZQU6OjBpG6y20PNrIW8mQKqc+QJwPS2pdzRXy82eaztA8GNJ7pCww7houzNibmof66Y4T26y4jVR0Za/M=;
X-YMail-OSG: bwl4_ygVM1kPyt9L2qG3vPUV7SyI_Jlay5Zb4aXJ9lazDNl
 SUxkdboSoW8FboQkdK0sXOlHGvnZbBuCtpBlmxUZWIkEfdV5b1ZS6Et7ydeI
 YESsDyhmqOJfzMVugckraJYGjq7eiwieWpYwt9H.C_K.7AIbKEJ63mSV4lAj
 UvqUK.ceUl15ykWSqqwpe.QTYBFUYYiJ14E.xA0K9AjFcxXi9DcwDLZGMfqe
 3WBbjUSvRqZk3prau_4cUyQloxOFTsCmum8ToHmziARvmcm29zDmYht9i2qB
 fxPuJSngucMR7jvv9TlNy26kdjpgHg7OsON8D12OFcbqfaeEPw3P7hsyxMyM
 ojnu7W30932iAEBPUo8erch1Tive6ePccCMDpKOHl5verYv4TpUNWtDgHwT6
 Jo1j7X8o0Z9W3nUF6mafsWRGXOitPT13cEUuZYHPZJRMAxiBNq0W3d127Cis
 _DaxUNcb93sFSBs03_MooYjELVSf0cT.OvbJ53GZHRHKOgrxPVlkSZpHfEOx
 5cdKKvjyiRXwk2Iux.S1QtOwgK8gwYDSQAIVly5kdwgN7JejyMzWFlgc-
X-Mailer: YahooMailWebService/0.8.122.442
References: <1348086305.81224.YahooMailNeo@web164004.mail.gq1.yahoo.com> <20120928121917.GF5368@mwanda> <1348870515.1973.YahooMailNeo@web164005.mail.gq1.yahoo.com> <20120929072527.GA13767@mwanda> <1349102641.41622.YahooMailNeo@web164005.mail.gq1.yahoo.com> <20121001150913.GC13767@mwanda>
Message-ID: <1349109750.55372.YahooMailNeo@web164005.mail.gq1.yahoo.com>
Date: Mon, 1 Oct 2012 09:42:30 -0700 (PDT)
From: Kevin Cruz <skate_ops@yahoo.com>
Reply-To: Kevin Cruz <skate_ops@yahoo.com>
Subject: Re: iwlwifi can't connect to router after resuming from suspend.
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Intel Wireless <ilw@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20121001150913.GC13767@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Thanks Kevin.

> I've filed a bug for this:
> https://bugzilla.kernel.org/show_bug.cgi?id=48121
> And added the Intel and Linux Wireless maintainers to the CC list.

Thanks you for all your help, Dan!

> Kevin's iwlwifi device does not work after a suspend resume cycle

> on 3.6-rc7.  Doing an rmmod modprobe makes the wireless card work
> again.

Actually rmmod modprobe used to work on my Ubuntu 11.10 (kernel 3.0) but
no longer resolves the issue in Ubuntu 12.04 (kernel 3.2).

> He has included a dmesg below, but I don't think it included
> a suspend resume cycle.  Kevin, could you do a suspend, resume again
> and send that?

Your right, sorry about that. This should have the suspend/resume cycle:

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.6.0-rc7 (cyber@cyber-linux) (gcc version 4.6.3 (Ubuntu/Linaro 4.6.3-1ubuntu5) ) #1 SMP Sun Sep 30 09:51:00 EDT 2012
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.6.0-rc7 root=UUID=4b13fd9f-6602-4289-b822-c0b28ed6f65b ro quiet splash vt.handoff=7
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009d7ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009d800-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000009ce3efff] usable
[    0.000000] BIOS-e820: [mem 0x000000009ce3f000-0x000000009cebefff] reserved
[    0.000000] BIOS-e820: [mem 0x000000009cebf000-0x000000009cfbefff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000009cfbf000-0x000000009cffefff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000009cfff000-0x000000009cffffff] usable
[    0.000000] BIOS-e820: [mem 0x000000009d000000-0x000000009f9fffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000feb00000-0x00000000feb03fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed10000-0x00000000fed19fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ffd80000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000025fdfffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.7 present.
[    0.000000] DMI: Hewlett-Packard HP Pavilion dv6 Notebook PC/17F9, BIOS F.19 05/21/2012
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x25fe00 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 080000000 mask FE0000000 write-back
[    0.000000]   2 base 09D000000 mask FFF000000 uncachable
[    0.000000]   3 base 09E000000 mask FFE000000 uncachable
[    0.000000]   4 base 0FFC00000 mask FFFC00000 write-protect
[    0.000000]   5 base 100000000 mask F00000000 write-back
[    0.000000]   6 base 200000000 mask FC0000000 write-back
[    0.000000]   7 base 240000000 mask FF0000000 write-back
[    0.000000]   8 base 250000000 mask FF0000000 write-back
[    0.000000]   9 base 25FE00000 mask FFFE00000 uncachable
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: last_pfn = 0x9d000 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000fe1b0-0x000fe1bf] mapped at [ffff8800000fe1b0]
[    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
[    0.000000] Base memory trampoline at [ffff880000097000] 97000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x9cffffff]
[    0.000000]  [mem 0x00000000-0x9cffffff] page 2M
[    0.000000] kernel direct mapping tables up to 0x9cffffff @ [mem 0x1fb14000-0x1fffffff]
[    0.000000] init_memory_mapping: [mem 0x100000000-0x25fdfffff]
[    0.000000]  [mem 0x100000000-0x25fdfffff] page 2M
[    0.000000] kernel direct mapping tables up to 0x25fdfffff @ [mem 0x9ce34000-0x9ce3efff]
[    0.000000] RAMDISK: [mem 0x37ae8000-0x37d6bfff]
[    0.000000] ACPI: RSDP 00000000000fe020 00024 (v02 HPQOEM)
[    0.000000] ACPI: XSDT 000000009cffe120 00094 (v01 HPQOEM SLIC-MPC 00000001      01000013)
[    0.000000] ACPI: FACP 000000009cffc000 000F4 (v04 HPQOEM SLIC-MPC 00000001 MSFT 01000013)
[    0.000000] ACPI: DSDT 000000009cfeb000 0DAE4 (v01 HP     INSYDE   00000000 MSFT 01000013)
[    0.000000] ACPI: FACS 000000009cf6c000 00040
[    0.000000] ACPI: ASF! 000000009cffd000 000A5 (v32 HP     INSYDE   00000001 MSFT 01000013)
[    0.000000] ACPI: HPET 000000009cffb000 00038 (v01 HP     INSYDE   00000001 MSFT 01000013)
[    0.000000] ACPI: APIC 000000009cffa000 0008C (v02 HP     INSYDE   00000001 MSFT 01000013)
[    0.000000] ACPI: MCFG 000000009cff9000 0003C (v01 HP     INSYDE   00000001 MSFT 01000013)
[    0.000000] ACPI: SLIC 000000009cfea000 00176 (v01 HPQOEM SLIC-MPC 00000001 MSFT 01000013)
[    0.000000] ACPI: SSDT 000000009cfe9000 0051F (v01 HP     INSYDE   00001000 MSFT 01000013)
[    0.000000] ACPI: BOOT 000000009cfe7000 00028 (v01 HP     INSYDE   00000001 MSFT 01000013)
[    0.000000] ACPI: ASPT 000000009cfe4000 00034 (v07 HP     INSYDE   00000001 MSFT 01000013)
[    0.000000] ACPI: SSDT 000000009cfe3000 0094E (v01 HP     INSYDE   00003000 INTL 20100121)
[    0.000000] ACPI: SSDT 000000009cfe2000 00996 (v01 HP     INSYDE   00003000 INTL 20100121)
[    0.000000] ACPI: SSDT 000000009cfe1000 002DA (v01 HP     INSYDE   00003000 INTL 20100121)
[    0.000000] ACPI: SSDT 000000009cfe0000 0035D (v01 HP     INSYDE   00003000 INTL 20100121)
[    0.000000] ACPI: SSDT 000000009cfda000 024A1 (v01 HP     INSYDE   00001000 INTL 20100121)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000025fdfffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x25fdfffff]
[    0.000000]   NODE_DATA [mem 0x25fdfc000-0x25fdfffff]
[    0.000000]  [ffffea0000000000-ffffea00097fffff] PMD -> [ffff880257400000-ffff88025f3fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x25fdfffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x0009cfff]
[    0.000000]   node   0: [mem 0x00100000-0x9ce3efff]
[    0.000000]   node   0: [mem 0x9cfff000-0x9cffffff]
[    0.000000]   node   0: [mem 0x100000000-0x25fdfffff]
[    0.000000] On node 0 totalpages: 2083789
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 3911 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 16320 pages used for memmap
[    0.000000]   DMA32 zone: 622208 pages, LIFO batch:31
[    0.000000]   Normal zone: 22520 pages used for memmap
[    0.000000]   Normal zone: 1418760 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] enabled)
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 8 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009d000 - 000000000009e000
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 000000009ce3f000 - 000000009cebf000
[    0.000000] PM: Registered nosave memory: 000000009cebf000 - 000000009cfbf000
[    0.000000] PM: Registered nosave memory: 000000009cfbf000 - 000000009cfff000
[    0.000000] PM: Registered nosave memory: 000000009d000000 - 000000009fa00000
[    0.000000] PM: Registered nosave memory: 000000009fa00000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000feb00000
[    0.000000] PM: Registered nosave memory: 00000000feb00000 - 00000000feb04000
[    0.000000] PM: Registered nosave memory: 00000000feb04000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec01000
[    0.000000] PM: Registered nosave memory: 00000000fec01000 - 00000000fed10000
[    0.000000] PM: Registered nosave memory: 00000000fed10000 - 00000000fed1a000
[    0.000000] PM: Registered nosave memory: 00000000fed1a000 - 00000000fed1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed20000
[    0.000000] PM: Registered nosave memory: 00000000fed20000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ffd80000
[    0.000000] PM: Registered nosave memory: 00000000ffd80000 - 0000000100000000
[    0.000000] e820: [mem 0x9fa00000-0xdfffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:256 nr_cpumask_bits:256 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff88025fa00000 s84416 r8192 d22080 u262144
[    0.000000] pcpu-alloc: s84416 r8192 d22080 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2044879
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.6.0-rc7 root=UUID=4b13fd9f-6602-4289-b822-c0b28ed6f65b ro quiet splash vt.handoff=7
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 8118728k/9959424k available (6493k kernel code, 1624268k absent, 216428k reserved, 6677k data, 920k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000]     RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000]     RCU restricting CPUs from NR_CPUS=256 to nr_cpu_ids=8.
[    0.000000] NR_IRQS:16640 nr_irqs:744 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.004000] tsc: Detected 2195.156 MHz processor
[    0.000002] Calibrating delay loop (skipped), value calculated using timer frequency.. 4390.31 BogoMIPS (lpj=8780624)
[    0.000005] pid_max: default: 32768 minimum: 301
[    0.000024] Security Framework initialized
[    0.000035] AppArmor: AppArmor initialized
[    0.000591] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.002340] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.003076] Mount-cache hash table entries: 256
[    0.003246] Initializing cgroup subsys cpuacct
[    0.003248] Initializing cgroup subsys devices
[    0.003249] Initializing cgroup subsys freezer
[    0.003251] Initializing cgroup subsys blkio
[    0.003252] Initializing cgroup subsys perf_event
[    0.003275] CPU: Physical Processor ID: 0
[    0.003276] CPU: Processor Core ID: 0
[    0.003280] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.003280] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.003282] mce: CPU supports 9 MCE banks
[    0.003294] CPU0: Thermal monitoring handled by SMI
[    0.003300] process: using mwait in idle threads
[    0.003303] Last level iTLB entries: 4KB 512, 2MB 0, 4MB 0
[    0.003303] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32
[    0.003303] tlb_flushall_shift is 0x5
[    0.005958] ACPI: Core revision 20120711
[    0.026171] ftrace: allocating 24288 entries in 95 pages
[    0.039543] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.079188] smpboot: CPU0: Intel(R) Core(TM) i7-2670QM CPU @ 2.20GHz stepping 07
[    0.184161] Performance Events: PEBS fmt1+, 16-deep LBR, SandyBridge events, Intel PMU driver.
[    0.184167] perf_event_intel: PEBS disabled due to CPU errata, please upgrade microcode
[    0.184168] ... version:                3
[    0.184170] ... bit width:              48
[    0.184170] ... generic registers:      4
[    0.184172] ... value mask:             0000ffffffffffff
[    0.184173] ... max period:             000000007fffffff
[    0.184174] ... fixed-purpose events:   3
[    0.184175] ... event mask:             000000070000000f
[    0.184346] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.195574] CPU1: Thermal monitoring handled by SMI
[    0.208812] CPU2: Thermal monitoring handled by SMI
[    0.222032] CPU3: Thermal monitoring handled by SMI
[    0.235261] CPU4: Thermal monitoring handled by SMI
[    0.248486] CPU5: Thermal monitoring handled by SMI
[    0.261706] CPU6: Thermal monitoring handled by SMI
[    0.184447] smpboot: Booting Node   0, Processors  #1 #2 #3 #4 #5 #6 #7 OK
[    0.274925] CPU7: Thermal monitoring handled by SMI
[    0.277066] Brought up 8 CPUs
[    0.277069] smpboot: Total of 8 processors activated (35122.49 BogoMIPS)
[    0.284902] devtmpfs: initialized
[    0.286025] EVM: security.selinux
[    0.286027] EVM: security.SMACK64
[    0.286028] EVM: security.capability
[    0.286068] PM: Registering ACPI NVS region [mem 0x9cebf000-0x9cfbefff] (1048576 bytes)
[    0.286787] dummy: 
[    0.286818] RTC time: 12:17:39, date: 10/01/12
[    0.286856] NET: Registered protocol family 16
[    0.286993] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.286995] ACPI: bus type pci registered
[    0.287048] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.287050] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.309263] PCI: Using configuration type 1 for base access
[    0.310151] bio: create slab <bio-0> at 0
[    0.310218] ACPI: Added _OSI(Module Device)
[    0.310220] ACPI: Added _OSI(Processor Device)
[    0.310221] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.310223] ACPI: Added _OSI(Processor Aggregator Device)
[    0.311978] ACPI: EC: Look up EC in DSDT
[    0.313671] ACPI: Executed 1 blocks of module-level executable AML code
[    0.317418] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.317900] ACPI: SSDT 000000009ce70798 00727 (v01  PmRef  Cpu0Cst 00003001 INTL 20100121)
[    0.318351] ACPI: Dynamic OEM Table Load:
[    0.318354] ACPI: SSDT           (null) 00727 (v01  PmRef  Cpu0Cst 00003001 INTL 20100121)
[    0.318648] ACPI: SSDT 000000009ce71a98 00303 (v01  PmRef    ApIst 00003000 INTL 20100121)
[    0.319128] ACPI: Dynamic OEM Table Load:
[    0.319131] ACPI: SSDT           (null) 00303 (v01  PmRef    ApIst 00003000 INTL 20100121)
[    0.319265] ACPI: SSDT 000000009ce6fd98 00119 (v01  PmRef    ApCst 00003000 INTL 20100121)
[    0.319709] ACPI: Dynamic OEM Table Load:
[    0.319711] ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst 00003000 INTL 20100121)
[    0.326001] ACPI: Interpreter enabled
[    0.326004] ACPI: (supports S0 S3 S4 S5)
[    0.326025] ACPI: Using IOAPIC for interrupt routing
[    0.334744] ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
[    0.335103] ACPI: ACPI Dock Station Driver: 1 docks/bays found
[    0.335106] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.335388] \_SB_.PCI0:_OSC invalid UUID
[    0.335389] _OSC request data:1 8 1f 
[    0.335393] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-fe])
[    0.335873] PCI host bridge to bus 0000:00
[    0.335876] pci_bus 0000:00: busn_res: [bus 00-fe] is inserted under domain [bus 00-ff]
[    0.335878] pci_bus 0000:00: root bus resource [bus 00-fe]
[    0.335880] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.335882] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.335884] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.335886] pci_bus 0000:00: root bus resource [mem 0x9fa00000-0xfeafffff]
[    0.335895] pci 0000:00:00.0: [8086:0104] type 00 class 0x060000
[    0.335932] pci 0000:00:01.0: [8086:0101] type 01 class 0x060400
[    0.335966] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.335991] pci 0000:00:02.0: [8086:0116] type 00 class 0x030000
[    0.336002] pci 0000:00:02.0: reg 10: [mem 0xc0000000-0xc03fffff 64bit]
[    0.336008] pci 0000:00:02.0: reg 18: [mem 0xb0000000-0xbfffffff 64bit pref]
[    0.336013] pci 0000:00:02.0: reg 20: [io  0x6000-0x603f]
[    0.336070] pci 0000:00:16.0: [8086:1c3a] type 00 class 0x078000
[    0.336094] pci 0000:00:16.0: reg 10: [mem 0xc7504000-0xc750400f 64bit]
[    0.336174] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.336210] pci 0000:00:1a.0: [8086:1c2d] type 00 class 0x0c0320
[    0.336596] pci 0000:00:1a.0: reg 10: [mem 0xc750a000-0xc750a3ff]
[    0.338791] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.338820] pci 0000:00:1b.0: [8086:1c20] type 00 class 0x040300
[    0.338836] pci 0000:00:1b.0: reg 10: [mem 0xc7500000-0xc7503fff 64bit]
[    0.338909] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.338933] pci 0000:00:1c.0: [8086:1c10] type 01 class 0x060400
[    0.339017] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.339044] pci 0000:00:1c.1: [8086:1c12] type 01 class 0x060400
[    0.339127] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.339156] pci 0000:00:1c.2: [8086:1c14] type 01 class 0x060400
[    0.339240] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.339267] pci 0000:00:1c.3: [8086:1c16] type 01 class 0x060400
[    0.339350] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.339389] pci 0000:00:1d.0: [8086:1c26] type 00 class 0x0c0320
[    0.339754] pci 0000:00:1d.0: reg 10: [mem 0xc7509000-0xc75093ff]
[    0.341947] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.341976] pci 0000:00:1f.0: [8086:1c49] type 00 class 0x060100
[    0.342107] pci 0000:00:1f.2: [8086:1c03] type 00 class 0x010601
[    0.342128] pci 0000:00:1f.2: reg 10: [io  0x6098-0x609f]
[    0.342137] pci 0000:00:1f.2: reg 14: [io  0x60bc-0x60bf]
[    0.342145] pci 0000:00:1f.2: reg 18: [io  0x6090-0x6097]
[    0.342154] pci 0000:00:1f.2: reg 1c: [io  0x60b8-0x60bb]
[    0.342163] pci 0000:00:1f.2: reg 20: [io  0x6060-0x607f]
[    0.342171] pci 0000:00:1f.2: reg 24: [mem 0xc7508000-0xc75087ff]
[    0.342219] pci 0000:00:1f.2: PME# supported from D3hot
[    0.342240] pci 0000:00:1f.3: [8086:1c22] type 00 class 0x0c0500
[    0.342257] pci 0000:00:1f.3: reg 10: [mem 0xc7506000-0xc75060ff 64bit]
[    0.342279] pci 0000:00:1f.3: reg 20: [io  0x6040-0x605f]
[    0.342332] pci_bus 0000:01: busn_res: [bus 01-06] is inserted under [bus 00-fe]
[    0.342345] pci 0000:01:00.0: [1002:6760] type 00 class 0x030000
[    0.342362] pci 0000:01:00.0: reg 10: [mem 0xa0000000-0xafffffff 64bit pref]
[    0.342375] pci 0000:01:00.0: reg 18: [mem 0xc6500000-0xc651ffff 64bit]
[    0.342384] pci 0000:01:00.0: reg 20: [io  0x5000-0x50ff]
[    0.342401] pci 0000:01:00.0: reg 30: [mem 0xfffe0000-0xffffffff pref]
[    0.342441] pci 0000:01:00.0: supports D1 D2
[    0.347998] pci 0000:00:01.0: PCI bridge to [bus 01-06]
[    0.348006] pci 0000:00:01.0:   bridge window [io  0x5000-0x5fff]
[    0.348013] pci 0000:00:01.0:   bridge window [mem 0xc6500000-0xc74fffff]
[    0.348023] pci 0000:00:01.0:   bridge window [mem 0xa0000000-0xafffffff 64bit pref]
[    0.348103] pci_bus 0000:07: busn_res: [bus 07-0c] is inserted under [bus 00-fe]
[    0.348129] pci 0000:07:00.0: [10ec:8168] type 00 class 0x020000
[    0.348150] pci 0000:07:00.0: reg 10: [io  0x4000-0x40ff]
[    0.348185] pci 0000:07:00.0: reg 18: [mem 0xc0404000-0xc0404fff 64bit pref]
[    0.348208] pci 0000:07:00.0: reg 20: [mem 0xc0400000-0xc0403fff 64bit pref]
[    0.348303] pci 0000:07:00.0: supports D1 D2
[    0.348304] pci 0000:07:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.355996] pci 0000:00:1c.0: PCI bridge to [bus 07-0c]
[    0.356006] pci 0000:00:1c.0:   bridge window [io  0x4000-0x4fff]
[    0.356016] pci 0000:00:1c.0:   bridge window [mem 0xc5500000-0xc64fffff]
[    0.356030] pci 0000:00:1c.0:   bridge window [mem 0xc0400000-0xc13fffff 64bit pref]
[    0.356100] pci_bus 0000:0d: busn_res: [bus 0d-12] is inserted under [bus 00-fe]
[    0.356268] pci 0000:0d:00.0: [8086:0084] type 00 class 0x028000
[    0.356439] pci 0000:0d:00.0: reg 10: [mem 0xc4500000-0xc4501fff 64bit]
[    0.357172] pci 0000:0d:00.0: PME# supported from D0 D3hot D3cold
[    0.364106] pci 0000:00:1c.1: PCI bridge to [bus 0d-12]
[    0.364111] pci 0000:00:1c.1:   bridge window [io  0x3000-0x3fff]
[    0.364115] pci 0000:00:1c.1:   bridge window [mem 0xc4500000-0xc54fffff]
[    0.364122] pci 0000:00:1c.1:   bridge window [mem 0xc1400000-0xc23fffff 64bit pref]
[    0.364168] pci_bus 0000:13: busn_res: [bus 13-18] is inserted under [bus 00-fe]
[    0.364196] pci 0000:13:00.0: [10ec:5209] type 00 class 0xff0000
[    0.364219] pci 0000:13:00.0: reg 10: [mem 0xc3501000-0xc3501fff]
[    0.364306] pci 0000:13:00.0: reg 30: [mem 0xffff0000-0xffffffff pref]
[    0.364379] pci 0000:13:00.0: supports D1 D2
[    0.364380] pci 0000:13:00.0: PME# supported from D1 D2 D3hot
[    0.364434] pci 0000:13:00.1: [10ec:5209] type 00 class 0x080500
[    0.364457] pci 0000:13:00.1: reg 10: [mem 0xc3500000-0xc35000ff]
[    0.364617] pci 0000:13:00.1: supports D1 D2
[    0.364619] pci 0000:13:00.1: PME# supported from D1 D2 D3hot
[    0.371987] pci 0000:00:1c.2: PCI bridge to [bus 13-18]
[    0.371996] pci 0000:00:1c.2:   bridge window [io  0x2000-0x2fff]
[    0.372006] pci 0000:00:1c.2:   bridge window [mem 0xc3500000-0xc44fffff]
[    0.372020] pci 0000:00:1c.2:   bridge window [mem 0xc2400000-0xc33fffff 64bit pref]
[    0.372085] pci_bus 0000:19: busn_res: [bus 19] is inserted under [bus 00-fe]
[    0.372189] pci 0000:19:00.0: [1033:0194] type 00 class 0x0c0330
[    0.372245] pci 0000:19:00.0: reg 10: [mem 0xc3400000-0xc3401fff 64bit]
[    0.372543] pci 0000:19:00.0: PME# supported from D0 D3hot D3cold
[    0.380024] pci 0000:00:1c.3: PCI bridge to [bus 19]
[    0.380044] pci 0000:00:1c.3:   bridge window [mem 0xc3400000-0xc34fffff]
[    0.380074] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.380194] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.380225] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    0.380253] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
[    0.380280] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP04._PRT]
[    0.380319] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEG0._PRT]
[    0.380389] \_SB_.PCI0:_OSC invalid UUID
[    0.380390] _OSC request data:1 1f 1f 
[    0.380394]  pci0000:00: ACPI _OSC support notification failed, disabling PCIe ASPM
[    0.380395]  pci0000:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    0.383598] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 10 11 12 14 15) *7
[    0.383643] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 *3 4 5 6 10 11 12 14 15)
[    0.383685] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 *4 5 6 10 11 12 14 15)
[    0.383729] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 *10 11 12 14 15)
[    0.383771] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.383815] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 *5 6 10 11 12 14 15)
[    0.383859] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 *10 11 12 14 15)
[    0.383901] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 10 *11 12 14 15)
[    0.383979] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.383986] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=none,locks=none
[    0.383988] vgaarb: loaded
[    0.383989] vgaarb: bridge control possible 0000:01:00.0
[    0.383991] vgaarb: no bridge control possible 0000:00:02.0
[    0.384089] SCSI subsystem initialized
[    0.384090] ACPI: bus type scsi registered
[    0.384119] libata version 3.00 loaded.
[    0.384135] ACPI: bus type usb registered
[    0.384151] usbcore: registered new interface driver usbfs
[    0.384158] usbcore: registered new interface driver hub
[    0.384173] usbcore: registered new device driver usb
[    0.384234] PCI: Using ACPI for IRQ routing
[    0.392663] PCI: pci_cache_line_size set to 64 bytes
[    0.392850] e820: reserve RAM buffer [mem 0x0009d800-0x0009ffff]
[    0.392852] e820: reserve RAM buffer [mem 0x9ce3f000-0x9fffffff]
[    0.392854] e820: reserve RAM buffer [mem 0x9d000000-0x9fffffff]
[    0.392856] e820: reserve RAM buffer [mem 0x25fe00000-0x25fffffff]
[    0.392930] NetLabel: Initializing
[    0.392931] NetLabel:  domain hash size = 128
[    0.392932] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.392941] NetLabel:  unlabeled traffic allowed by default
[    0.392987] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.392993] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.396007] Switching to clocksource hpet
[    0.401456] AppArmor: AppArmor Filesystem Enabled
[    0.401474] pnp: PnP ACPI init
[    0.401487] ACPI: bus type pnp registered
[    0.401762] pnp 00:00: [bus 00-fe]
[    0.401764] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.401766] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.401768] pnp 00:00: [io  0x0d00-0xffff window]
[    0.401770] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.401772] pnp 00:00: [mem 0x000c0000-0x000c3fff window]
[    0.401774] pnp 00:00: [mem 0x000c4000-0x000c7fff window]
[    0.401776] pnp 00:00: [mem 0x000c8000-0x000cbfff window]
[    0.401777] pnp 00:00: [mem 0x000cc000-0x000cffff window]
[    0.401779] pnp 00:00: [mem 0x000d0000-0x000d3fff window]
[    0.401781] pnp 00:00: [mem 0x000d4000-0x000d7fff window]
[    0.401783] pnp 00:00: [mem 0x000d8000-0x000dbfff window]
[    0.401784] pnp 00:00: [mem 0x000dc000-0x000dffff window]
[    0.401786] pnp 00:00: [mem 0x000e0000-0x000e3fff window]
[    0.401788] pnp 00:00: [mem 0x000e4000-0x000e7fff window]
[    0.401790] pnp 00:00: [mem 0x000e8000-0x000ebfff window]
[    0.401791] pnp 00:00: [mem 0x000ec000-0x000effff window]
[    0.401793] pnp 00:00: [mem 0x000f0000-0x000fffff window]
[    0.401795] pnp 00:00: [mem 0x9fa00000-0xfeafffff window]
[    0.401848] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    0.401866] pnp 00:01: [io  0x0000-0x001f]
[    0.401869] pnp 00:01: [io  0x0081-0x0091]
[    0.401871] pnp 00:01: [io  0x0093-0x009f]
[    0.401872] pnp 00:01: [io  0x00c0-0x00df]
[    0.401874] pnp 00:01: [dma 4]
[    0.401893] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.401902] pnp 00:02: [mem 0xff000000-0xffffffff]
[    0.401919] pnp 00:02: Plug and Play ACPI device, IDs INT0800 (active)
[    0.401990] pnp 00:03: [mem 0xfed00000-0xfed003ff]
[    0.402009] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.402018] pnp 00:04: [io  0x00f0]
[    0.402027] pnp 00:04: [irq 13]
[    0.402043] pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.402053] pnp 00:05: [io  0x002e-0x002f]
[    0.402054] pnp 00:05: [io  0x004e-0x004f]
[    0.402056] pnp 00:05: [io  0x0061]
[    0.402057] pnp 00:05: [io  0x0063]
[    0.402059] pnp 00:05: [io  0x0065]
[    0.402061] pnp 00:05: [io  0x0067]
[    0.402062] pnp 00:05: [io  0x0070]
[    0.402064] pnp 00:05: [io  0x0080]
[    0.402065] pnp 00:05: [io  0x0092]
[    0.402067] pnp 00:05: [io  0x00b2-0x00b3]
[    0.402068] pnp 00:05: [io  0x0680-0x069f]
[    0.402070] pnp 00:05: [io  0x1000-0x100f]
[    0.402071] pnp 00:05: [io  0x1010-0x1013]
[    0.402073] pnp 00:05: [io  0xffff]
[    0.402075] pnp 00:05: [io  0x0400-0x0453]
[    0.402076] pnp 00:05: [io  0x0458-0x047f]
[    0.402078] pnp 00:05: [io  0x0500-0x057f]
[    0.402079] pnp 00:05: [io  0x164e-0x164f]
[    0.402121] system 00:05: [io  0x0680-0x069f] has been reserved
[    0.402123] system 00:05: [io  0x1000-0x100f] has been reserved
[    0.402125] system 00:05: [io  0x1010-0x1013] has been reserved
[    0.402127] system 00:05: [io  0xffff] has been reserved
[    0.402129] system 00:05: [io  0x0400-0x0453] has been reserved
[    0.402131] system 00:05: [io  0x0458-0x047f] has been reserved
[    0.402133] system 00:05: [io  0x0500-0x057f] has been reserved
[    0.402135] system 00:05: [io  0x164e-0x164f] has been reserved
[    0.402138] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.402145] pnp 00:06: [io  0x0070-0x0077]
[    0.402150] pnp 00:06: [irq 8]
[    0.402167] pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.402184] pnp 00:07: [io  0x0454-0x0457]
[    0.402212] system 00:07: [io  0x0454-0x0457] has been reserved
[    0.402215] system 00:07: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
[    0.402241] pnp 00:08: [io  0x0060]
[    0.402243] pnp 00:08: [io  0x0064]
[    0.402248] pnp 00:08: [irq 1]
[    0.402268] pnp 00:08: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.402295] pnp 00:09: [irq 12]
[    0.402314] pnp 00:09: Plug and Play ACPI device, IDs SYN1e47 SYN1e00 SYN0002 PNP0f13 (active)
[    0.402403] pnp 00:0a: [mem 0xfed1c000-0xfed1ffff]
[    0.402405] pnp 00:0a: [mem 0xfed10000-0xfed17fff]
[    0.402406] pnp 00:0a: [mem 0xfed18000-0xfed18fff]
[    0.402408] pnp 00:0a: [mem 0xfed19000-0xfed19fff]
[    0.402409] pnp 00:0a: [mem 0xe0000000-0xefffffff]
[    0.402411] pnp 00:0a: [mem 0xfed20000-0xfed3ffff]
[    0.402413] pnp 00:0a: [mem 0xfed90000-0xfed93fff]
[    0.402414] pnp 00:0a: [mem 0xff000000-0xffffffff]
[    0.402416] pnp 00:0a: [mem 0xfee00000-0xfeefffff]
[    0.402418] pnp 00:0a: [mem 0x9fa00000-0x9fa00fff]
[    0.402454] system 00:0a: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.402456] system 00:0a: [mem 0xfed10000-0xfed17fff] has been reserved
[    0.402458] system 00:0a: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.402460] system 00:0a: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.402462] system 00:0a: [mem 0xe0000000-0xefffffff] has been reserved
[    0.402464] system 00:0a: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.402466] system 00:0a: [mem 0xfed90000-0xfed93fff] has been reserved
[    0.402468] system 00:0a: [mem 0xff000000-0xffffffff] could not be reserved
[    0.402470] system 00:0a: [mem 0xfee00000-0xfeefffff] could not be reserved
[    0.402472] system 00:0a: [mem 0x9fa00000-0x9fa00fff] has been reserved
[    0.402474] system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.403657] pnp 00:0b: [irq 23]
[    0.403694] pnp 00:0b: Plug and Play ACPI device, IDs HPQ0004 (active)
[    0.403712] pnp 00:0c: [mem 0x20000000-0x201fffff]
[    0.403714] pnp 00:0c: [mem 0x40000000-0x401fffff]
[    0.403761] system 00:0c: [mem 0x20000000-0x201fffff] could not be reserved
[    0.403764] system 00:0c: [mem 0x40000000-0x401fffff] could not be reserved
[    0.403766] system 00:0c: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.403782] pnp: PnP ACPI: found 13 devices
[    0.403783] ACPI: ACPI bus type pnp unregistered
[    0.409898] pci 0000:01:00.0: no compatible bridge window for [mem 0xfffe0000-0xffffffff pref]
[    0.409902] pci 0000:13:00.0: no compatible bridge window for [mem 0xffff0000-0xffffffff pref]
[    0.409945] pci 0000:01:00.0: BAR 6: assigned [mem 0xc6520000-0xc653ffff pref]
[    0.409947] pci 0000:00:01.0: PCI bridge to [bus 01-06]
[    0.409950] pci 0000:00:01.0:   bridge window [io  0x5000-0x5fff]
[    0.409953] pci 0000:00:01.0:   bridge window [mem 0xc6500000-0xc74fffff]
[    0.409956] pci 0000:00:01.0:   bridge window [mem 0xa0000000-0xafffffff 64bit pref]
[    0.409959] pci 0000:00:1c.0: PCI bridge to [bus 07-0c]
[    0.409963] pci 0000:00:1c.0:   bridge window [io  0x4000-0x4fff]
[    0.409968] pci 0000:00:1c.0:   bridge window [mem 0xc5500000-0xc64fffff]
[    0.409973] pci 0000:00:1c.0:   bridge window [mem 0xc0400000-0xc13fffff 64bit pref]
[    0.409980] pci 0000:00:1c.1: PCI bridge to [bus 0d-12]
[    0.409983] pci 0000:00:1c.1:   bridge window [io  0x3000-0x3fff]
[    0.409989] pci 0000:00:1c.1:   bridge window [mem 0xc4500000-0xc54fffff]
[    0.409993] pci 0000:00:1c.1:   bridge window [mem 0xc1400000-0xc23fffff 64bit pref]
[    0.410001] pci 0000:13:00.0: BAR 6: assigned [mem 0xc2400000-0xc240ffff pref]
[    0.410002] pci 0000:00:1c.2: PCI bridge to [bus 13-18]
[    0.410006] pci 0000:00:1c.2:   bridge window [io  0x2000-0x2fff]
[    0.410011] pci 0000:00:1c.2:   bridge window [mem 0xc3500000-0xc44fffff]
[    0.410015] pci 0000:00:1c.2:   bridge window [mem 0xc2400000-0xc33fffff 64bit pref]
[    0.410022] pci 0000:00:1c.3: PCI bridge to [bus 19]
[    0.410027] pci 0000:00:1c.3:   bridge window [mem 0xc3400000-0xc34fffff]
[    0.410071] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.410073] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.410075] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.410077] pci_bus 0000:00: resource 7 [mem 0x9fa00000-0xfeafffff]
[    0.410079] pci_bus 0000:01: resource 0 [io  0x5000-0x5fff]
[    0.410080] pci_bus 0000:01: resource 1 [mem 0xc6500000-0xc74fffff]
[    0.410082] pci_bus 0000:01: resource 2 [mem 0xa0000000-0xafffffff 64bit pref]
[    0.410084] pci_bus 0000:07: resource 0 [io  0x4000-0x4fff]
[    0.410086] pci_bus 0000:07: resource 1 [mem 0xc5500000-0xc64fffff]
[    0.410088] pci_bus 0000:07: resource 2 [mem 0xc0400000-0xc13fffff 64bit pref]
[    0.410090] pci_bus 0000:0d: resource 0 [io  0x3000-0x3fff]
[    0.410092] pci_bus 0000:0d: resource 1 [mem 0xc4500000-0xc54fffff]
[    0.410093] pci_bus 0000:0d: resource 2 [mem 0xc1400000-0xc23fffff 64bit pref]
[    0.410095] pci_bus 0000:13: resource 0 [io  0x2000-0x2fff]
[    0.410097] pci_bus 0000:13: resource 1 [mem 0xc3500000-0xc44fffff]
[    0.410099] pci_bus 0000:13: resource 2 [mem 0xc2400000-0xc33fffff 64bit pref]
[    0.410101] pci_bus 0000:19: resource 1 [mem 0xc3400000-0xc34fffff]
[    0.410127] NET: Registered protocol family 2
[    0.410705] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.411950] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.412098] TCP: Hash tables configured (established 524288 bind 65536)
[    0.412114] TCP: reno registered
[    0.412126] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    0.412159] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    0.412242] NET: Registered protocol family 1
[    0.412256] pci 0000:00:02.0: Boot video device
[    0.456323] PCI: CLS 64 bytes, default 64
[    0.456363] Trying to unpack rootfs image as initramfs...
[    0.503578] Freeing initrd memory: 2576k freed
[    0.503845] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.503848] software IO TLB [mem 0x98e34000-0x9ce33fff] (64MB) mapped at [ffff880098e34000-ffff88009ce33fff]
[    0.503895] Simple Boot Flag at 0x44 set to 0x1
[    0.504313] audit: initializing netlink socket (disabled)
[    0.504323] type=2000 audit(1349093859.384:1): initialized
[    0.525145] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.526735] VFS: Disk quotas dquot_6.5.2
[    0.526772] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.527125] fuse init (API version 7.20)
[    0.527191] msgmni has been set to 15861
[    0.527453] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.527476] io scheduler noop registered
[    0.527477] io scheduler deadline registered
[    0.527501] io scheduler cfq registered (default)
[    0.527591] pcieport 0000:00:01.0: irq 40 for MSI/MSI-X
[    0.527813] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.527830] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.527880] intel_idle: MWAIT substates: 0x21120
[    0.527882] intel_idle: v0.4 model 0x2A
[    0.527883] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.528906] ACPI: Deprecated procfs I/F for AC is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    0.529824] ACPI: AC Adapter [AC] (on-line)
[    0.529892] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:02/PNP0C0D:00/input/input0
[    0.531464] ACPI: Lid Switch [LID]
[    0.531513] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[    0.531516] ACPI: Power Button [PWRB]
[    0.531544] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    0.531546] ACPI: Power Button [PWRF]
[    0.531609] ACPI: Requesting acpi_cpufreq
[    0.548478] thermal LNXTHERM:00: registered as thermal_zone0
[    0.548483] ACPI: Thermal Zone [THRM] (59 C)
[    0.548515] GHES: HEST is not enabled!
[    0.548572] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
[    0.554996] Linux agpgart interface v0.103
[    0.556141] brd: module loaded
[    0.556703] loop: module loaded
[    0.556787] ahci 0000:00:1f.2: version 3.0
[    0.556847] ahci 0000:00:1f.2: irq 41 for MSI/MSI-X
[    0.556916] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x21 impl SATA mode
[    0.556919] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ems apst 
[    0.556924] ahci 0000:00:1f.2: setting latency timer to 64
[    0.564235] scsi0 : ahci
[    0.564299] scsi1 : ahci
[    0.564351] scsi2 : ahci
[    0.564406] scsi3 : ahci
[    0.564456] scsi4 : ahci
[    0.564510] scsi5 : ahci
[    0.564541] ata1: SATA max UDMA/133 abar m2048@0xc7508000 port 0xc7508100 irq 41
[    0.564542] ata2: DUMMY
[    0.564543] ata3: DUMMY
[    0.564544] ata4: DUMMY
[    0.564545] ata5: DUMMY
[    0.564548] ata6: SATA max UDMA/133 abar m2048@0xc7508000 port 0xc7508380 irq 41
[    0.564815] libphy: Fixed MDIO Bus: probed
[    0.564827] tun: Universal TUN/TAP device driver, 1.6
[    0.564828] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    0.564863] PPP generic driver version 2.4.2
[    0.564931] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.564955] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[    0.564959] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[    0.564997] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    0.568883] ehci_hcd 0000:00:1a.0: debug port 2
[    0.568891] ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
[    0.568905] ehci_hcd 0000:00:1a.0: irq 16, io mem 0xc750a000
[    0.579833] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    0.579993] hub 1-0:1.0: USB hub found
[    0.579997] hub 1-0:1.0: 2 ports detected
[    0.580061] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[    0.580065] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[    0.580104] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    0.584004] ehci_hcd 0000:00:1d.0: debug port 2
[    0.584013] ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
[    0.584026] ehci_hcd 0000:00:1d.0: irq 20, io mem 0xc7509000
[    0.586516] ACPI: Deprecated procfs I/F for battery is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    0.586521] ACPI: Battery Slot [BAT0] (battery present)
[    0.595810] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    0.595950] hub 2-0:1.0: USB hub found
[    0.595953] hub 2-0:1.0: 2 ports detected
[    0.595998] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.596006] uhci_hcd: USB Universal Host Controller Interface driver
[    0.596046] xhci_hcd 0000:19:00.0: xHCI Host Controller
[    0.596081] xhci_hcd 0000:19:00.0: new USB bus registered, assigned bus number 3
[    0.596281] xhci_hcd 0000:19:00.0: irq 19, io mem 0xc3400000
[    0.596377] xhci_hcd 0000:19:00.0: irq 42 for MSI/MSI-X
[    0.596383] xhci_hcd 0000:19:00.0: irq 43 for MSI/MSI-X
[    0.596389] xhci_hcd 0000:19:00.0: irq 44 for MSI/MSI-X
[    0.596394] xhci_hcd 0000:19:00.0: irq 45 for MSI/MSI-X
[    0.596399] xhci_hcd 0000:19:00.0: irq 46 for MSI/MSI-X
[    0.596404] xhci_hcd 0000:19:00.0: irq 47 for MSI/MSI-X
[    0.596409] xhci_hcd 0000:19:00.0: irq 48 for MSI/MSI-X
[    0.596415] xhci_hcd 0000:19:00.0: irq 49 for MSI/MSI-X
[    0.596615] xHCI xhci_add_endpoint called for root hub
[    0.596617] xHCI xhci_check_bandwidth called for root hub
[    0.596634] hub 3-0:1.0: USB hub found
[    0.596642] hub 3-0:1.0: 2 ports detected
[    0.596692] xhci_hcd 0000:19:00.0: xHCI Host Controller
[    0.596720] xhci_hcd 0000:19:00.0: new USB bus registered, assigned bus number 4
[    0.599725] xHCI xhci_add_endpoint called for root hub
[    0.599726] xHCI xhci_check_bandwidth called for root hub
[    0.599743] hub 4-0:1.0: USB hub found
[    0.599751] hub 4-0:1.0: 2 ports detected
[    0.599869] usbcore: registered new interface driver libusual
[    0.599898] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    0.607659] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.607663] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.607754] mousedev: PS/2 mouse device common for all mice
[    0.607933] rtc_cmos 00:06: RTC can wake from S4
[    0.608048] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
[    0.608075] rtc0: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    0.608130] device-mapper: uevent: version 1.0.3
[    0.608181] device-mapper: ioctl: 4.23.0-ioctl (2012-07-25) initialised: dm-devel@redhat.com
[    0.608317] cpuidle: using governor ladder
[    0.608493] cpuidle: using governor menu
[    0.608494] EFI Variables Facility v0.08 2004-May-17
[    0.608549] TCP: cubic registered
[    0.608623] NET: Registered protocol family 10
[    0.608758] NET: Registered protocol family 17
[    0.608771] Key type dns_resolver registered
[    0.609023] PM: Hibernation image not present or could not be loaded.
[    0.609033] registered taskstats version 1
[    0.610888] Key type trusted registered
[    0.611881] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
[    0.612867] Key type encrypted registered
[    0.615584]   Magic number: 0:91:278
[    0.615606] tty tty15: hash matches
[    0.615698] rtc_cmos 00:06: setting system clock to 2012-10-01 12:17:39 UTC (1349093859)
[    0.617088] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    0.617090] EDD information not available.
[    0.883575] ata6: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    0.883617] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    0.885595] ata1.00: ATA-8: Hitachi HTS547575A9E384, JE4OA50A, max UDMA/100
[    0.885604] ata1.00: 1465149168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    0.885985] ata6.00: ATAPI: hp      BD E  DS6E2LH, FH62, max UDMA/100
[    0.887556] ata6.00: configured for UDMA/100
[    0.887676] ata1.00: configured for UDMA/100
[    0.887887] scsi 0:0:0:0: Direct-Access     ATA      Hitachi HTS54757 JE4O PQ: 0 ANSI: 5
[    0.888084] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    0.888103] sd 0:0:0:0: [sda] 1465149168 512-byte logical blocks: (750 GB/698 GiB)
[    0.888106] sd 0:0:0:0: [sda] 4096-byte physical blocks
[    0.888253] sd 0:0:0:0: [sda] Write Protect is off
[    0.888257] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    0.888351] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    0.890872] scsi 5:0:0:0: CD-ROM            hp       BD E  DS6E2LH    FH62 PQ: 0 ANSI: 5
[    0.891540] usb 1-1: new high-speed USB device number 2 using ehci_hcd
[    0.894522] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    0.894528] cdrom: Uniform CD-ROM driver Revision: 3.20
[    0.894730] sr 5:0:0:0: Attached scsi CD-ROM sr0
[    0.894841] sr 5:0:0:0: Attached scsi generic sg1 type 5
[    0.961096]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 >
[    0.962330] sd 0:0:0:0: [sda] Attached SCSI disk
[    0.963535] Freeing unused kernel memory: 920k freed
[    0.963622] Write protecting the kernel read-only data: 12288k
[    0.967817] Freeing unused kernel memory: 1688k freed
[    0.971047] Freeing unused kernel memory: 1320k freed
[    0.983850] udevd[138]: starting version 175
[    1.003067] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    1.003318] r8169 0000:07:00.0: irq 50 for MSI/MSI-X
[    1.003447] sdhci: Secure Digital Host Controller Interface driver
[    1.003449] sdhci: Copyright(c) Pierre Ossman
[    1.003530] r8169 0000:07:00.0: eth0: RTL8168evl/8111evl at 0xffffc90000c78000, 08:2e:5f:82:40:38, XID 0c900800 IRQ 50
[    1.003533] r8169 0000:07:00.0: eth0: jumbo features [frames: 9200 bytes, tx checksumming: ko]
[    1.004120] sdhci-pci 0000:13:00.1: SDHCI controller found [10ec:5209] (rev 1)
[    1.004157] sdhci-pci 0000:13:00.1: Will use DMA mode even though HW doesn't fully claim to support it.
[    1.004164] mmc0: no vmmc regulator found
[    1.004181] sdhci-pci 0000:13:00.1: Will use DMA mode even though HW doesn't fully claim to support it.
[    1.004213] Registered led device: mmc0::
[    1.024263] hub 1-1:1.0: USB hub found
[    1.024351] hub 1-1:1.0: 6 ports detected
[    1.035381] mmc0: SDHCI controller on PCI [0000:13:00.1] using DMA
[    1.038912] sdhci-pci 0000:13:00.1: Will use DMA mode even though HW doesn't fully claim to support it.
[    1.074970] sdhci-pci 0000:13:00.1: Will use DMA mode even though HW doesn't fully claim to support it.
[    1.110827] sdhci-pci 0000:13:00.1: Will use DMA mode even though HW doesn't fully claim to support it.
[    1.135235] usb 2-1: new high-speed USB device number 2 using ehci_hcd
[    1.146382] sdhci-pci 0000:13:00.1: Will use DMA mode even though HW doesn't fully claim to support it.
[    1.267736] hub 2-1:1.0: USB hub found
[    1.267824] hub 2-1:1.0: 6 ports detected
[    1.339167] usb 1-1.1: new full-speed USB device number 3 using ehci_hcd
[    1.502850] tsc: Refined TSC clocksource calibration: 2195.012 MHz
[    1.502863] Switching to clocksource tsc
[    1.502984] usb 1-1.2: new high-speed USB device number 4 using ehci_hcd
[    1.677248] EXT4-fs (sda5): mounted filesystem with ordered data mode. Opts: (null)
[    9.302766] udevd[456]: starting version 175
[    9.303326] Adding 12582908k swap on /dev/sda6.  Priority:-1 extents:1 across:12582908k 
[    9.409038] type=1400 audit(1349108268.300:2): apparmor="STATUS" operation="profile_load" name="/sbin/dhclient" pid=552 comm="apparmor_parser"
[    9.409046] type=1400 audit(1349108268.300:3): apparmor="STATUS" operation="profile_replace" name="/sbin/dhclient" pid=620 comm="apparmor_parser"
[    9.409313] type=1400 audit(1349108268.300:4): apparmor="STATUS" operation="profile_load" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=552 comm="apparmor_parser"
[    9.409321] type=1400 audit(1349108268.300:5): apparmor="STATUS" operation="profile_replace" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=620 comm="apparmor_parser"
[    9.409470] type=1400 audit(1349108268.300:6): apparmor="STATUS" operation="profile_load" name="/usr/lib/connman/scripts/dhclient-script" pid=552 comm="apparmor_parser"
[    9.409479] type=1400 audit(1349108268.300:7): apparmor="STATUS" operation="profile_replace" name="/usr/lib/connman/scripts/dhclient-script" pid=620 comm="apparmor_parser"
[    9.527975] wmi: Mapper loaded
[    9.765192] lp: driver loaded but no devices found
[    9.969357] rts_pstor: module is from the staging directory, the quality is unknown, you have been warned.
[    9.969987] Initializing Realtek PCIE storage driver...
[    9.970063] Resource length: 0x1000
[    9.970076] Original address: 0xc3501000, remapped address: 0xffffc900118a6000
[    9.970079] pci->irq = 18
[    9.970080] rtsx_acquire_irq: chip->msi_en = 0, pci->irq = 18
[   10.042191] mei 0000:00:16.0: setting latency timer to 64
[   10.042250] mei 0000:00:16.0: irq 51 for MSI/MSI-X
[   10.053660] mei 0000:00:16.0: wd: failed to find the client
[   10.173511] scsi6 : SCSI emulation for PCI-Express Mass Storage devices
[   10.173680] rts_pstor: waiting for device to settle before scanning
[   10.179530] hp_accel: laptop model unknown, using default axes configuration
[   10.198871] input: HP WMI hotkeys as /devices/virtual/input/input4
[   10.320527] lis3lv02d: 8 bits 3DC sensor found
[   10.810643] cfg80211: Calling CRDA to update world regulatory domain
[   10.813910] cfg80211: World regulatory domain updated:
[   10.813912] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   10.813914] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   10.813915] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   10.813916] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   10.813917] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   10.813918] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   11.061084] Intel(R) Wireless WiFi driver for Linux, in-tree:
[   11.061086] Copyright(c) 2003-2012 Intel Corporation
[   11.061226] iwlwifi 0000:0d:00.0: pci_resource_len = 0x00002000
[   11.061227] iwlwifi 0000:0d:00.0: pci_resource_base = ffffc900118b4000
[   11.061229] iwlwifi 0000:0d:00.0: HW Revision ID = 0x0
[   11.061557] iwlwifi 0000:0d:00.0: irq 52 for MSI/MSI-X
[   11.080252] iwlwifi 0000:0d:00.0: loaded firmware version 39.31.5.1 build 35138
[   11.172197] rts_pstor: device scan complete
[   11.172333] scsi 6:0:0:0: Direct-Access     Generic- xD/SD/M.S.       1.00 PQ: 0 ANSI: 0 CCS
[   11.172525] sd 6:0:0:0: Attached scsi generic sg2 type 0
[    0.894934] ACPI: Invalid Power Resource to register!
[   11.172541] sd 6:0:0:0: [sdb] Attached SCSI removable disk
[   11.212660] psmouse serio1: synaptics: Touchpad model: 1, fw: 7.5, id: 0x1e0b1, caps: 0xd00073/0x240000/0xa0400, board id: 1680, fw id: 726294
[   11.256376] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input5
[   11.300199] input: ST LIS3LV02DL Accelerometer as /devices/platform/lis3lv02d/input/input6
[   11.300355] Registered led device: hp::hddprotect
[   11.300370] hp_accel: driver loaded
[   11.328742] [drm] Initialized drm 1.1.0 20060810
[   12.287191] snd_hda_intel 0000:00:1b.0: irq 53 for MSI/MSI-X
[   12.554929] iwldvm: Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:
[   12.554932] iwldvm: Copyright(c) 2003-2012 Intel Corporation
[   12.554946] iwlwifi 0000:0d:00.0: CONFIG_IWLWIFI_DEBUG disabled
[   12.554948] iwlwifi 0000:0d:00.0: CONFIG_IWLWIFI_DEBUGFS enabled
[   12.554949] iwlwifi 0000:0d:00.0: CONFIG_IWLWIFI_DEVICE_TRACING enabled
[   12.554950] iwlwifi 0000:0d:00.0: CONFIG_IWLWIFI_DEVICE_TESTMODE enabled
[   12.554951] iwlwifi 0000:0d:00.0: CONFIG_IWLWIFI_P2P enabled
[   12.554953] iwlwifi 0000:0d:00.0: Detected Intel(R) Centrino(R) Wireless-N 1000 BGN, REV=0x6C
[   12.555110] iwlwifi 0000:0d:00.0: L1 Enabled; Disabling L0S
[   12.576304] iwlwifi 0000:0d:00.0: device EEPROM VER=0x15d, CALIB=0x6
[   12.576306] iwlwifi 0000:0d:00.0: Device SKU: 0x50
[   12.576307] iwlwifi 0000:0d:00.0: Valid Tx ant: 0x1, Valid Rx ant: 0x3
[   12.576381] Registered led device: phy0-led
[   12.576398] cfg80211: Ignoring regulatory request Set by core since the driver uses its own custom regulatory domain
[   12.604491] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
[   12.669576] [drm] radeon defaulting to kernel modesetting.
[   12.669578] [drm] radeon kernel modesetting enabled.
[   12.669590] VGA switcheroo: detected switching method \_SB_.PCI0.GFX0.ATPX handle
[   12.669630] radeon 0000:01:00.0: enabling device (0000 -> 0003)
[   12.669851] [drm] initializing kernel modesetting (CAICOS 0x1002:0x6760 0x103C:0x1656).
[   12.669883] [drm] register mmio base: 0xC6500000
[   12.669884] [drm] register mmio size: 131072
[   12.740179] ATOM BIOS: HP/Flex
[   12.740538] radeon 0000:01:00.0: VRAM: 1024M 0x0000000000000000 - 0x000000003FFFFFFF (1024M used)
[   12.740540] radeon 0000:01:00.0: GTT: 512M 0x0000000040000000 - 0x000000005FFFFFFF
[   12.740545] mtrr: no more MTRRs available
[   12.740546] [drm] Detected VRAM RAM=1024M, BAR=256M
[   12.740547] [drm] RAM width 64bits DDR
[   12.740583] [TTM] Zone  kernel: Available graphics memory: 4062616 kiB
[   12.740584] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB
[   12.740585] [TTM] Initializing pool allocator
[   12.740588] [TTM] Initializing DMA pool allocator
[   12.740603] [drm] radeon: 1024M of VRAM memory ready
[   12.740604] [drm] radeon: 512M of GTT memory ready.
[   12.740615] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[   12.740616] [drm] Driver supports precise vblank timestamp query.
[   12.740657] radeon 0000:01:00.0: irq 54 for MSI/MSI-X
[   12.740665] radeon 0000:01:00.0: radeon: using MSI.
[   12.740700] [drm] radeon: irq initialized.
[   12.740702] [drm] GART: num cpu pages 131072, num gpu pages 131072
[   12.740975] [drm] probing gen 2 caps for device 8086:101 = 2/0
[   12.740976] [drm] enabling PCIE gen 2 link speeds, disable with radeon.pcie_gen2=0
[   12.741033] [drm] Loading CAICOS Microcode
[   12.746928] [drm] PCIE GART of 512M enabled (table at 0x0000000000040000).
[   12.747044] radeon 0000:01:00.0: WB enabled
[   12.747046] radeon 0000:01:00.0: fence driver on ring 0 use gpu addr 0x0000000040000c00 and cpu addr 0xffff88025509fc00
[   12.763422] [drm] ring test on 0 succeeded in 3 usecs
[   12.763646] [drm] ib test on ring 0 succeeded in 0 usecs
[   12.763794] [drm] Radeon Display Connectors
[   12.770660] [drm] Internal thermal controller with fan control
[   12.771658] [drm] radeon: power management initialized
[   12.771719] No connectors reported connected with modes
[   12.771721] [drm] Cannot find any crtc or sizes - going 1024x768
[   12.773067] [drm] fb mappable at 0xA0142000
[   12.773068] [drm] vram apper at 0xA0000000
[   12.773069] [drm] size 3145728
[   12.773070] [drm] fb depth is 24
[   12.773070] [drm]    pitch is 4096
[   12.773245] Console: switching to colour frame buffer device 128x48
[   12.774608] fb0: radeondrmfb frame buffer device
[   12.774609] drm: registered panic notifier
[   12.774619] [drm] Initialized radeon 2.22.0 20080528 for 0000:01:00.0 on minor 0
[   12.918989] input: HDA Intel PCH HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input7
[   12.919064] input: HDA Intel PCH Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
[   12.919127] input: HDA Intel PCH Front Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
[   12.919576] pci 0000:00:00.0: Intel Sandybridge Chipset
[   12.919645] pci 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
[   12.920580] pci 0000:00:00.0: detected 32768K stolen memory
[   12.920630] i915 0000:00:02.0: setting latency timer to 64
[   12.942287] i915 0000:00:02.0: irq 55 for MSI/MSI-X
[   12.942294] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[   12.942295] [drm] Driver supports precise vblank timestamp query.
[   12.943014] vga_switcheroo: enabled
[   12.943055] radeon atpx: version is 1
[   12.943079] vgaarb: device changed decodes: PCI:0000:01:00.0,olddecodes=io+mem,decodes=none:owns=none
[   12.943081] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=none:owns=io+mem
[   13.121715] EXT4-fs (sda5): re-mounted. Opts: errors=remount-ro
[   13.389676] EXT4-fs (sda7): mounted filesystem with ordered data mode. Opts: (null)
[   13.421182] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[   13.556711] fbcon: inteldrmfb (fb1) is primary device
[   13.556713] fbcon: Remapping primary device, fb1, to tty 1-63
[   13.809643] fb1: inteldrmfb frame buffer device
[   13.809855] [Firmware Bug]: ACPI(PEGP) defines _DOD but not _DOS
[   13.810378] init: failsafe main process (885) killed by TERM signal
[   13.836196] acpi device:2f: registered as cooling_device8
[   13.836530] ACPI: Video Device [PEGP] (multi-head: yes  rom: no  post: no)
[   13.836583] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:2d/LNXVIDEO:00/input/input10
[   13.847553] acpi device:3c: registered as cooling_device9
[   13.847732] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[   13.847891] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:01/input/input11
[   13.848197] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 1
[   13.854406] type=1400 audit(1349108272.748:8): apparmor="STATUS" operation="profile_load" name="/usr/lib/lightdm/lightdm/lightdm-guest-session-wrapper" pid=964 comm="apparmor_parser"
[   13.854524] type=1400 audit(1349108272.748:9): apparmor="STATUS" operation="profile_load" name="/usr/sbin/tcpdump" pid=971 comm="apparmor_parser"
[   13.854644] type=1400 audit(1349108272.748:10): apparmor="STATUS" operation="profile_load" name="/usr/lib/telepathy/mission-control-5" pid=968 comm="apparmor_parser"
[   13.855039] type=1400 audit(1349108272.748:11): apparmor="STATUS" operation="profile_load" name="/usr/lib/telepathy/telepathy-*" pid=968 comm="apparmor_parser"
[   14.003161] r8169 0000:07:00.0: eth0: link down
[   14.003196] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   14.004763] iwlwifi 0000:0d:00.0: L1 Enabled; Disabling L0S
[   14.012157] iwlwifi 0000:0d:00.0: Radio type=0x0-0x0-0x3
[   14.023833] ppdev: user-space parallel port driver
[   14.067720] iwlwifi 0000:0d:00.0: L1 Enabled; Disabling L0S
[   14.075130] iwlwifi 0000:0d:00.0: Radio type=0x0-0x0-0x3
[   14.130122] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   14.382066] Bluetooth: Core ver 2.16
[   14.382079] NET: Registered protocol family 31
[   14.382081] Bluetooth: HCI device and connection manager initialized
[   14.382082] Bluetooth: HCI socket layer initialized
[   14.382083] Bluetooth: L2CAP socket layer initialized
[   14.382085] Bluetooth: SCO socket layer initialized
[   14.465983] Bluetooth: RFCOMM TTY layer initialized
[   14.465987] Bluetooth: RFCOMM socket layer initialized
[   14.465988] Bluetooth: RFCOMM ver 1.11
[   14.480123] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   14.480125] Bluetooth: BNEP filters: protocol multicast
[   14.581624] init: plymouth-stop pre-start process (1265) terminated with status 1
[   16.246691] wlan0: authenticate with 30:46:9a:68:a9:52
[   16.259674] wlan0: send auth to 30:46:9a:68:a9:52 (try 1/3)
[   16.261545] wlan0: authenticated
[   16.262602] wlan0: associate with 30:46:9a:68:a9:52 (try 1/3)
[   16.266379] wlan0: RX AssocResp from 30:46:9a:68:a9:52 (capab=0x411 status=0 aid=3)
[   16.272093] wlan0: associated
[   16.272115] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   21.073554] hp_wmi: Unknown event_id - 10 - 0x0
[   48.955887] wlan0: deauthenticating from 30:46:9a:68:a9:52 by local choice (reason=3)
[   48.974402] cfg80211: All devices are disconnected, going to restore regulatory settings
[   48.974406] cfg80211: Restoring regulatory settings
[   48.974425] cfg80211: Calling CRDA to update world regulatory domain
[   48.976905] cfg80211: Ignoring regulatory request Set by core since the driver uses its own custom regulatory domain
[   48.976907] cfg80211: World regulatory domain updated:
[   48.976908] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   48.976910] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   48.976911] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   48.976913] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   48.976914] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   48.976915] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   50.845400] PM: Syncing filesystems ... done.
[   50.845986] PM: Preparing system for mem sleep
[   51.326775] Freezing user space processes ... (elapsed 0.01 seconds) done.
[   51.342695] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[   51.358669] PM: Entering mem sleep
[   51.358745] Suspending console(s) (use no_console_suspend to debug)
[   51.359029] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[   51.359188] sd 0:0:0:0: [sda] Stopping disk
[   51.408578] Ready to suspend
[   52.422252] PM: suspend of devices complete after 1064.047 msecs
[   52.422253] PM: suspend devices took 1.064 seconds
[   52.422320] PM: late suspend of devices complete after 0.066 msecs
[   52.422539] xhci_hcd 0000:19:00.0: wake-up capability enabled by ACPI
[   52.473992] r8169 0000:07:00.0: wake-up capability enabled by ACPI
[   52.490130] ehci_hcd 0000:00:1d.0: wake-up capability enabled by ACPI
[   52.506050] ehci_hcd 0000:00:1a.0: wake-up capability enabled by ACPI
[   52.538035] PM: noirq suspend of devices complete after 115.779 msecs
[   52.538964] ACPI: Preparing to enter system sleep state S3
[   52.550233] PM: Saving platform NVS memory
[   52.553080] Disabling non-boot CPUs ...
[   52.553480] Broke affinity for irq 52
[   52.554773] smpboot: CPU 1 is now offline
[   52.657863] smpboot: CPU 2 is now offline
[   52.658350] Broke affinity for irq 20
[   52.761800] smpboot: CPU 3 is now offline
[   52.865733] smpboot: CPU 4 is now offline
[   52.866187] Broke affinity for irq 16
[   52.969672] smpboot: CPU 5 is now offline
[   53.073616] smpboot: CPU 6 is now offline
[   53.074059] Broke affinity for irq 1
[   53.177547] smpboot: CPU 7 is now offline
[   53.177920] Extended CMOS year: 2000
[   53.179017] ACPI: Low-level resume complete
[   53.179058] PM: Restoring platform NVS memory
[   53.179500] Extended CMOS year: 2000
[   53.179532] CPU0: Thermal monitoring handled by SMI
[   53.179556] Enabling non-boot CPUs ...
[   53.179618] smpboot: Booting Node 0 Processor 1 APIC 0x1
[   53.190651] CPU1: Thermal monitoring handled by SMI
[   53.193148] CPU1 is up
[   53.193196] smpboot: Booting Node 0 Processor 2 APIC 0x2
[   53.204238] CPU2: Thermal monitoring handled by SMI
[   53.206713] CPU2 is up
[   53.206754] smpboot: Booting Node 0 Processor 3 APIC 0x3
[   53.217695] CPU3: Thermal monitoring handled by SMI
[   53.220177] CPU3 is up
[   53.220219] smpboot: Booting Node 0 Processor 4 APIC 0x4
[   53.231261] CPU4: Thermal monitoring handled by SMI
[   53.233773] CPU4 is up
[   53.233816] smpboot: Booting Node 0 Processor 5 APIC 0x5
[   53.244856] CPU5: Thermal monitoring handled by SMI
[   53.247359] CPU5 is up
[   53.247399] smpboot: Booting Node 0 Processor 6 APIC 0x6
[   53.258440] CPU6: Thermal monitoring handled by SMI
[   53.260956] CPU6 is up
[   53.260994] smpboot: Booting Node 0 Processor 7 APIC 0x7
[   53.272034] CPU7: Thermal monitoring handled by SMI
[   53.274556] CPU7 is up
[   53.282163] ACPI: Waking up from system sleep state S3
[   53.383122] ehci_hcd 0000:00:1a.0: wake-up capability disabled by ACPI
[   53.415098] ehci_hcd 0000:00:1d.0: wake-up capability disabled by ACPI
[   53.527130] xhci_hcd 0000:19:00.0: wake-up capability disabled by ACPI
[   53.527192] PM: noirq resume of devices complete after 192.188 msecs
[   53.527286] PM: early resume of devices complete after 0.047 msecs
[   53.527322] i915 0000:00:02.0: setting latency timer to 64
[   53.527328] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[   53.527360] ahci 0000:00:1f.2: setting latency timer to 64
[   53.527362] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[   53.527401] Ready to resume
[   53.527434] sdhci-pci 0000:13:00.1: Will use DMA mode even though HW doesn't fully claim to support it.
[   53.527437] rtsx_acquire_irq: chip->msi_en = 0, pci->irq = 18
[   53.527464] sdhci-pci 0000:13:00.1: Will use DMA mode even though HW doesn't fully claim to support it.
[   53.527548] mei 0000:00:16.0: irq 51 for MSI/MSI-X
[   53.527573] snd_hda_intel 0000:00:1b.0: irq 53 for MSI/MSI-X
[   53.528546] mei 0000:00:16.0: wd: failed to find the client
[   53.528996] r8169 0000:07:00.0: wake-up capability disabled by ACPI
[   53.530722] [drm] probing gen 2 caps for device 8086:101 = 2/0
[   53.530722] [drm] enabling PCIE gen 2 link speeds, disable with radeon.pcie_gen2=0
[   53.543109] [drm] PCIE GART of 512M enabled (table at 0x0000000000040000).
[   53.543215] radeon 0000:01:00.0: WB enabled
[   53.543217] radeon 0000:01:00.0: fence driver on ring 0 use gpu addr 0x0000000040000c00 and cpu addr 0xffff88025509fc00
[   53.559420] [drm] ring test on 0 succeeded in 3 usecs
[   53.559496] [drm] ib test on ring 0 succeeded in 0 usecs
[   53.566969] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[   53.782921] usb 1-1.1: reset full-speed USB device number 3 using ehci_hcd
[   53.854805] ata6: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   53.857129] ata6.00: configured for UDMA/100
[   53.946887] usb 1-1.2: reset high-speed USB device number 4 using ehci_hcd
[   53.983343] hp_wmi: Unknown event_id - 10 - 0x1
[   55.693681] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   55.697166] ata1.00: configured for UDMA/100
[   55.709834] sd 0:0:0:0: [sda] Starting disk
[   55.711995] Extended CMOS year: 2000
[   55.736015] PM: resume of devices complete after 2210.050 msecs
[   55.736086] PM: resume devices took 2.208 seconds
[   55.736116] PM: Finishing wakeup.
[   55.736117] Restarting tasks ... done.
[   55.747762] video LNXVIDEO:00: Restoring backlight state
[   55.751264] video LNXVIDEO:01: Restoring backlight state
[   55.781222] sdhci-pci 0000:13:00.1: Will use DMA mode even though HW doesn't fully claim to support it.
[   55.816755] sdhci-pci 0000:13:00.1: Will use DMA mode even though HW doesn't fully claim to support it.
[   55.852660] sdhci-pci 0000:13:00.1: Will use DMA mode even though HW doesn't fully claim to support it.
[   55.888718] sdhci-pci 0000:13:00.1: Will use DMA mode even though HW doesn't fully claim to support it.
[   56.443323] r8169 0000:07:00.0: eth0: link down
[   56.443912] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   56.444654] iwlwifi 0000:0d:00.0: L1 Enabled; Disabling L0S
[   56.452444] iwlwifi 0000:0d:00.0: Radio type=0x0-0x0-0x3
[   56.508734] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   58.186398] hp_wmi: Unknown event_id - 10 - 0x1
[   58.835223] wlan0: authenticate with 30:46:9a:68:a9:52
[   58.864519] wlan0: send auth to 30:46:9a:68:a9:52 (try 1/3)
[   59.067596] wlan0: send auth to 30:46:9a:68:a9:52 (try 2/3)
[   59.271484] wlan0: send auth to 30:46:9a:68:a9:52 (try 3/3)
[   59.475356] wlan0: authentication with 30:46:9a:68:a9:52 timed out
[   70.837852] wlan0: authenticate with 30:46:9a:68:a9:52
[   70.847884] wlan0: direct probe to 30:46:9a:68:a9:52 (try 1/3)
[   71.048446] wlan0: direct probe to 30:46:9a:68:a9:52 (try 2/3)
[   71.252299] wlan0: direct probe to 30:46:9a:68:a9:52 (try 3/3)
[   71.456212] wlan0: authentication with 30:46:9a:68:a9:52 timed out
[   77.137717] wlan0: authenticate with 30:46:9a:68:a9:52
[   77.147754] wlan0: direct probe to 30:46:9a:68:a9:52 (try 1/3)
[   77.348717] wlan0: direct probe to 30:46:9a:68:a9:52 (try 2/3)
[   77.552588] wlan0: direct probe to 30:46:9a:68:a9:52 (try 3/3)
[   77.756437] wlan0: authentication with 30:46:9a:68:a9:52 timed out
[   79.771235] iwlwifi 0000:0d:00.0: fail to flush all tx fifo queues
[   83.437538] wlan0: authenticate with 30:46:9a:68:a9:52
[   83.447667] wlan0: direct probe to 30:46:9a:68:a9:52 (try 1/3)
[   83.648945] wlan0: direct probe to 30:46:9a:68:a9:52 (try 2/3)
[   83.852827] wlan0: direct probe to 30:46:9a:68:a9:52 (try 3/3)
[   84.056724] wlan0: authentication with 30:46:9a:68:a9:52 timed out
[   86.063462] iwlwifi 0000:0d:00.0: fail to flush all tx fifo queues
[   95.407718] wlan0: authenticate with 30:46:9a:68:a9:52
[   95.420221] wlan0: direct probe to 30:46:9a:68:a9:52 (try 1/3)
[   95.621777] wlan0: direct probe to 30:46:9a:68:a9:52 (try 2/3)
[   95.825653] wlan0: direct probe to 30:46:9a:68:a9:52 (try 3/3)
[   96.029529] wlan0: authentication with 30:46:9a:68:a9:52 timed out


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059Ab2IJA7s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 20:59:48 -0400
Received: from mga11.intel.com ([192.55.52.93]:2810 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753300Ab2IJA7p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 20:59:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,396,1344236400"; 
   d="scan'208";a="220053360"
Date: Mon, 10 Sep 2012 08:59:38 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [signal] double fault
Message-ID: <20120910005938.GC27826@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="c3bfwLpm8qysLVxt"
Content-Disposition: inline
In-Reply-To: <20120910004753.GB27699@localhost>
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--c3bfwLpm8qysLVxt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

FYI. As much messages as I can provide as debug aids.

x86_64-randconfig-s283      b______b___b_BBBBBB

--
12:	  f411932  
13:	B c2865bb  2012-09-10 kvm-xgwo     [    2.986734] double fault: 0000 [#1] SMP DEBUG_PAGEALLOC [kvm_read_and_reset_pf_reason __might_sleep down_read exit_mm do_exit kmsg_dump oops_end die do_double_fault double_fault do_early_param restore_args kvm_read_and_reset_pf_reason]
14:	B 549bf9c  2012-09-10 kvm-inn      [    2.157552] double fault: 0000 [#1] SMP DEBUG_PAGEALLOC 
15:	B 4e382ff  2012-09-10 kvm-waimea   [    1.557638] double fault: 0000 [#1] SMP DEBUG_PAGEALLOC 
16:	B 23ddf94  2012-09-10 kvm-stoakley [    2.668934] double fault: 0000 [#1] SMP DEBUG_PAGEALLOC 
17:	B f117e2a  2012-09-10 kvm-bay      [    4.708123] double fault: 0000 [#1] SMP DEBUG_PAGEALLOC 
18:	B a392720  2012-09-10 kvm-inn      [    3.552055] double fault: 0000 [#1] SMP DEBUG_PAGEALLOC 
18:	B a392720  2012-09-10 kvm-inn      [    4.733891] double fault: 0000 [#1] SMP DEBUG_PAGEALLOC 
18:	B a392720  2012-09-10 kvm-inn      [    3.830683] double fault: 0000 [#1] SMP DEBUG_PAGEALLOC 
18:	B a392720  2012-09-10 kvm-inn      [    3.621099] double fault: 0000 [#1] SMP DEBUG_PAGEALLOC 
18:	B a392720  2012-09-10 kvm-inn      [    4.465551] double fault: 0000 [#1] SMP DEBUG_PAGEALLOC 
18:	B a392720  2012-09-10 kvm-slim     [    2.608424] double fault: 0000 [#1] SMP DEBUG_PAGEALLOC [page_fault show_stack_log_lvl show_regs __die die do_double_fault double_fault do_early_param restore_args page_fault]
18:	B a392720  2012-09-10 kvm-xbm      [    3.616011] double fault: 0000 [#1] SMP DEBUG_PAGEALLOC [async_page_fault show_stack_log_lvl show_regs __die die do_double_fault double_fault do_early_param restore_args async_page_fault]
18:	B a392720  2012-09-10 kvm-xbm      [    3.106986] double fault: 0000 [#1] SMP DEBUG_PAGEALLOC 
18:	B a392720  2012-09-10 kvm-xgwo     [    3.029775] WARNING: at /c/kernel-tests/src/tip/kernel/lockdep.c:3122 __lock_acquire.isra.24+0xb4b/0xb80() [kvm_read_and_reset_pf_reason __might_sleep down_read exit_mm do_exit kmsg_dump oops_end die do_double_fault double_fault do_early_param restore_args kvm_read_and_reset_pf_reason]

[    2.976892] hd: no drives specified - use hd=cyl,head,sectors on kernel command line
[    2.980146] debug: unmapping init [mem 0xffffffff81b96000-0xffffffff81dd9fff]
[    2.986734] double fault: 0000 [#1] SMP DEBUG_PAGEALLOC
[    2.987767] Modules linked in:
[    2.988348] CPU 1 
[    2.988568] Pid: 1, comm: init Not tainted 3.6.0-rc3-00182-gc2865bb #44  
[    2.988568] RIP: 0010:[<ffffffff81052e33>]  [<ffffffff81052e33>] kvm_read_and_reset_pf_reason+0x13/0x60
[    2.988568] RSP: 0018:ffff880000000028  EFLAGS: 00010046
[    2.988568] RAX: 000000000000ef00 RBX: ffff880000000058 RCX: ffffffff8142f872
[    2.988568] RDX: 000000000000ef00 RSI: 0000000000000000 RDI: ffff880000000058
[    2.988568] RBP: ffff880000000028 R08: ffff880000067f48 R09: ffffffff81d6c72a
[    2.988568] R10: ffffffff81d6d07b R11: ffff880000067f40 R12: 0000000000000000
[    2.988568] R13: 0000000000000000 R14: ffffffff81dcbdb0 R15: ffffffff81dcbdb0
[    2.988568] FS:  0000000000000000(0000) GS:ffff88000dc00000(0000) knlGS:0000000000000000
[    2.988568] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    2.988568] CR2: ffff87fffffffff8 CR3: 00000000069c5000 CR4: 00000000000006e0
[    2.988568] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    2.988568] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    2.988568] Process init (pid: 1, threadinfo ffff880000066000, task ffff880000068000)
[    2.988568] Stack:
[    2.988568]  ffff880000000048 ffffffff81433a10 0000000000000001 0000000000000000
[    2.988568]  ffff880000000108 ffffffff8142fae5 ffffffff81dcbdb0 ffffffff81dcbdb0
[    2.988568]  0000000000000000 0000000000000000 ffff880000000108 ffff880000000138
[    3.010313] Call Trace:
[    3.010313] Code: 00 83 b8 44 e0 ff ff 01 0f 9f c0 e9 9d fe ff ff 0f 1f 84 00 00 00 00 00 55 48 89 e5 e8 d7 7a 3e 00 48 c7 c2 00 ef 00 00 48 89 d0 <65> 48 03 04 25 40 ec 00 00 8b 78 40 31 c9 85 ff 0f 95 c1 48 63 
[    3.010313] RIP  [<ffffffff81052e33>] kvm_read_and_reset_pf_reason+0x13/0x60
[    3.010313]  RSP <ffff880000000028>

Thanks,
Fengguang

--c3bfwLpm8qysLVxt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-kvm-xgwo-17468-2012-09-10-08-38-25-3.6.0-rc3-00182-gc2865bb-44"

[    0.000000] Linux version 3.6.0-rc3-00182-gc2865bb (kbuild@snb) (gcc version 4.7.1 (Debian 4.7.1-6) ) #44 SMP Mon Sep 10 08:37:26 CST 2012
[    0.000000] Command line: trinity=2m hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 branch=signal/experimental-kernel_thread log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=vmlinuz-2012-09-10-08-38-22-signal:experimental-kernel_thread:a392720-c2865bb-x86_64-randconfig-s283-1-xgwo BOOT_IMAGE=kernel-tests/kernels/x86_64-randconfig-s283/c2865bb/vmlinuz-3.6.0-rc3-00182-gc2865bb
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000093bff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000093c00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0xfffe max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 00E0000000 mask FFE0000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdac0-0x000fdacf] mapped at [ffff8800000fdac0]
[    0.000000]   mpc: fdad0-fdbec
[    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
[    0.000000] Base memory trampoline at [ffff88000008d000] 8d000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x0fffdfff]
[    0.000000]  [mem 0x00000000-0x0fffdfff] page 4k
[    0.000000] kernel direct mapping tables up to 0xfffdfff @ [mem 0x0e854000-0x0e8d5fff]
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 128160(97%)
[    0.000000] RAMDISK: [mem 0x0e8d6000-0x0ffeffff]
[    0.000000] ACPI: RSDP 00000000000fd930 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 000000000fffe550 00038 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: FACP 000000000fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 000000000fffe590 01121 (v01   BXPC   BXDSDT 00000001 INTL 20100528)
[    0.000000] ACPI: FACS 000000000fffff40 00040
[    0.000000] ACPI: SSDT 000000000ffffe40 000FF (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: APIC 000000000ffffd50 00080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
[    0.000000] ACPI: HPET 000000000ffffd10 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
[    0.000000] ACPI: SSDT 000000000ffff6c0 00644 (v01   BXPC BXSSDTPC 00000001 INTL 20100528)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fb000 (        fee00000)
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:1d6a6c1, boot clock
[    0.000000]  [ffffea0000000000-ffffea00003fffff] PMD -> [ffff88000d400000-ffff88000d7fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA32    [mem 0x00010000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x00092fff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65409
[    0.000000]   DMA32 zone: 1024 pages used for memmap
[    0.000000]   DMA32 zone: 6 pages reserved
[    0.000000]   DMA32 zone: 64379 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fb000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 2, APIC INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 2, APIC INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 2, APIC INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 2, APIC INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 2, APIC INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 2, APIC INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 2, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 2, APIC INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 2, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 2, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 2, APIC INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 2, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 2, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 2, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 2, APIC INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5fa000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:4096 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 477 pages/cpu @ffff88000da00000 s1921920 r8192 d23680 u2097152
[    0.000000] pcpu-alloc: s1921920 r8192 d23680 u2097152 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1 
[    0.000000] kvm-clock: cpu 0, msr 0:dbd46c1, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr da0eec0
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 64379
[    0.000000] Kernel command line: trinity=2m hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 branch=signal/experimental-kernel_thread log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=vmlinuz-2012-09-10-08-38-22-signal:experimental-kernel_thread:a392720-c2865bb-x86_64-randconfig-s283-1-xgwo BOOT_IMAGE=kernel-tests/kernels/x86_64-randconfig-s283/c2865bb/vmlinuz-3.6.0-rc3-00182-gc2865bb
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.000000] Inode-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Memory: 198396k/262136k available (4337k kernel code, 500k absent, 63240k reserved, 7522k data, 2320k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 
[    0.000000] 
[    0.000000] NR_IRQS:262400 nr_irqs:512 16
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 6335 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] ----------------------------------------------------------------------------
[    0.000000]                                  | spin |wlock |rlock |mutex | wsem | rsem |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]                      A-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.000000]                  A-B-B-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.000000]              A-B-B-C-C-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.000000]              A-B-C-A-B-C deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.000000]          A-B-B-C-C-D-D-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.000000]          A-B-C-D-B-D-D-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.000000]          A-B-C-D-B-C-D-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]               recursive read-lock:             |  ok  |             |failed|
[    0.000000]            recursive read-lock #2:             |  ok  |             |failed|
[    0.000000]             mixed read-write-lock:             |failed|             |failed|
[    0.000000]             mixed write-read-lock:             |failed|             |failed|
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:failed|failed|  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/12:failed|failed|  ok  |
[    0.000000]      hard-irqs-on + irq-safe-A/21:failed|failed|  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/21:failed|failed|  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/12:failed|failed|  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/21:failed|failed|  ok  |
[    0.000000]          hard-safe-A + irqs-on/12:failed|failed|  ok  |
[    0.000000]          soft-safe-A + irqs-on/12:failed|failed|  ok  |
[    0.000000]          hard-safe-A + irqs-on/21:failed|failed|  ok  |
[    0.000000]          soft-safe-A + irqs-on/21:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/123:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/123:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/132:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/132:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/213:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/213:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/231:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/231:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/312:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/312:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/321:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/321:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/123:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/123:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/132:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/132:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/213:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/213:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/231:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/231:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/312:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/312:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/321:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/321:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/123:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/123:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/132:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/132:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/213:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/213:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/231:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/231:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/312:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/312:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/321:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/321:failed|failed|  ok  |
[    0.000000]       hard-irq read-recursion/123:  ok  |
[    0.000000]       soft-irq read-recursion/123:  ok  |
[    0.000000]       hard-irq read-recursion/132:  ok  |
[    0.000000]       soft-irq read-recursion/132:  ok  |
[    0.000000]       hard-irq read-recursion/213:  ok  |
[    0.000000]       soft-irq read-recursion/213:  ok  |
[    0.000000]       hard-irq read-recursion/231:  ok  |
[    0.000000]       soft-irq read-recursion/231:  ok  |
[    0.000000]       hard-irq read-recursion/312:  ok  |
[    0.000000]       soft-irq read-recursion/312:  ok  |
[    0.000000]       hard-irq read-recursion/321:  ok  |
[    0.000000]       soft-irq read-recursion/321:  ok  |
[    0.000000] --------------------------------------------------------
[    0.000000] 133 out of 218 testcases failed, as expected. |
[    0.000000] ----------------------------------------------------
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2666.854 MHz processor
[    0.010000] Calibrating delay loop (skipped) preset value.. 5333.70 BogoMIPS (lpj=26668540)
[    0.010000] pid_max: default: 4096 minimum: 301
[    0.010000] Mount-cache hash table entries: 256
[    0.010000] mce: CPU supports 10 MCE banks
[    0.010000] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.010000] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.010000] tlb_flushall_shift is 0x6
[    0.014351] ACPI: Core revision 20120711
[    0.018764] Getting VERSION: 50014
[    0.019398] Getting VERSION: 50014
[    0.020018] Getting ID: 0
[    0.020504] Getting ID: ff000000
[    0.021098] Getting LVT0: 8700
[    0.021652] Getting LVT1: 8400
[    0.022379] enabled ExtINT on CPU#0
[    0.024191] ENABLING IO-APIC IRQs
[    0.024801] init IO_APIC IRQs
[    0.025342]  apic 2 pin 0 not connected
[    0.026055] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.027491] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.028931] IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.030032] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.031465] IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:1 Active:0 Dest:1)
[    0.032886] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.034310] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.035736] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.037160] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
[    0.038589] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:1)
[    0.040031] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:1)
[    0.041494] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.042949] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.044409] IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.045863] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.047316]  apic 2 pin 16 not connected
[    0.048019]  apic 2 pin 17 not connected
[    0.048728]  apic 2 pin 18 not connected
[    0.049437]  apic 2 pin 19 not connected
[    0.050005]  apic 2 pin 20 not connected
[    0.050715]  apic 2 pin 21 not connected
[    0.051423]  apic 2 pin 22 not connected
[    0.052130]  apic 2 pin 23 not connected
[    0.052983] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.054125] smpboot: CPU0: Intel Common KVM processor stepping 01
[    0.055519] Using local APIC timer interrupts.
[    0.055519] calibrating APIC timer ...
[    0.060000] ... lapic delta = 6249982
[    0.060000] ... PM-Timer delta = 357953
[    0.060000] ... PM-Timer result ok
[    0.060000] ..... delta 6249982
[    0.060000] ..... mult: 268434682
[    0.060000] ..... calibration result: 9999971
[    0.060000] ..... CPU clock speed is 2666.7438 MHz.
[    0.060000] ..... host bus clock speed is 999.9971 MHz.
[    0.060000] Performance Events: unsupported Netburst CPU model 6 no PMU driver, software events only.
[    0.060000] SMP alternatives: lockdep: fixing up alternatives
[    0.060000] smpboot: Booting Node   0, Processors  #1 OK
[    0.010000] kvm-clock: cpu 1, msr 0:ddd46c1, secondary cpu clock
[    0.010000] masked ExtINT on CPU#1
[    0.080238] KVM setup async PF for cpu 1
[    0.080260] Brought up 2 CPUs
[    0.080260] smpboot: Total of 2 processors activated (10667.41 BogoMIPS)
[    0.080569] kvm-stealtime: cpu 1, msr dc0eec0
[    0.099103] dummy: 
[    0.099940] NET: Registered protocol family 16
[    0.190666] ACPI: bus type pci registered
[    0.191565] PCI: Using configuration type 1 for base access
[    0.194339] bio: create slab <bio-0> at 0
[    0.195688] ACPI: Added _OSI(Module Device)
[    0.196437] ACPI: Added _OSI(Processor Device)
[    0.197234] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.198064] ACPI: Added _OSI(Processor Aggregator Device)
[    0.203084] ACPI: EC: Look up EC in DSDT
[    0.212303] ACPI: Interpreter enabled
[    0.212963] ACPI: (supports S0 S3 S5)
[    0.213737] ACPI: Using IOAPIC for interrupt routing
[    0.228582] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.230059] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.231464] PCI host bridge to bus 0000:00
[    0.232200] pci_bus 0000:00: busn_res: [bus 00-ff] is inserted under domain [bus 00-ff]
[    0.233595] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.234574] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.235655] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.236754] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.237955] pci_bus 0000:00: root bus resource [mem 0xe0000000-0xfebfffff]
[    0.239163] pci_bus 0000:00: scanning bus
[    0.240317] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.241390] pci 0000:00:00.0: calling quirk_mmio_always_on+0x0/0xa
[    0.243096] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.244983] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.247941] pci 0000:00:01.1: reg 20: [io  0xc1c0-0xc1cf]
[    0.250255] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.251326] pci 0000:00:01.3: calling acpi_pm_check_blacklist+0x0/0x66
[    0.253153] pci 0000:00:01.3: calling quirk_piix4_acpi+0x0/0x186
[    0.254235] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
[    0.255508] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
[    0.256823] pci 0000:00:01.3: calling pci_fixup_piix4_acpi+0x0/0x10
[    0.258137] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.260243] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
[    0.262589] pci 0000:00:02.0: reg 14: [mem 0xfebf0000-0xfebf0fff]
[    0.271251] pci 0000:00:02.0: reg 30: [mem 0xfebe0000-0xfebeffff pref]
[    0.273163] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.274645] pci 0000:00:03.0: reg 10: [mem 0xfeba0000-0xfebbffff]
[    0.276400] pci 0000:00:03.0: reg 14: [io  0xc000-0xc03f]
[    0.282359] pci 0000:00:03.0: reg 30: [mem 0xfebc0000-0xfebdffff pref]
[    0.284036] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.285548] pci 0000:00:04.0: reg 10: [io  0xc040-0xc07f]
[    0.287191] pci 0000:00:04.0: reg 14: [mem 0xfebf1000-0xfebf1fff]
[    0.292566] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.294088] pci 0000:00:05.0: reg 10: [io  0xc080-0xc0bf]
[    0.295726] pci 0000:00:05.0: reg 14: [mem 0xfebf2000-0xfebf2fff]
[    0.300863] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.302379] pci 0000:00:06.0: reg 10: [io  0xc0c0-0xc0ff]
[    0.304026] pci 0000:00:06.0: reg 14: [mem 0xfebf3000-0xfebf3fff]
[    0.309344] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.310478] pci 0000:00:07.0: reg 10: [io  0xc100-0xc13f]
[    0.312117] pci 0000:00:07.0: reg 14: [mem 0xfebf4000-0xfebf4fff]
[    0.317496] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.319017] pci 0000:00:08.0: reg 10: [io  0xc140-0xc17f]
[    0.320894] pci 0000:00:08.0: reg 14: [mem 0xfebf5000-0xfebf5fff]
[    0.326406] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.327925] pci 0000:00:09.0: reg 10: [io  0xc180-0xc1bf]
[    0.330065] pci 0000:00:09.0: reg 14: [mem 0xfebf6000-0xfebf6fff]
[    0.335339] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    0.336649] pci 0000:00:0a.0: reg 10: [mem 0xfebf7000-0xfebf700f]
[    0.340657] pci_bus 0000:00: fixups for bus
[    0.341412] pci_bus 0000:00: bus scan returning with max=00
[    0.342389] pci_bus 0000:00: on NUMA node 0
[    0.343206] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.345876]  pci0000:00: ACPI _OSC support notification failed, disabling PCIe ASPM
[    0.347200]  pci0000:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    0.368103] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.369400] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.370490] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.371779] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.373053] ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0
[    0.374474] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.375949] vgaarb: loaded
[    0.376436] vgaarb: bridge control possible 0000:00:02.0
[    0.377571] PCI: Using ACPI for IRQ routing
[    0.378335] PCI: pci_cache_line_size set to 64 bytes
[    0.379278] pci 0000:00:01.1: BAR 0: reserving [io  0x01f0-0x01f7 flags 0x110] (d=0, p=0)
[    0.380028] pci 0000:00:01.1: BAR 1: reserving [io  0x03f6 flags 0x110] (d=0, p=0)
[    0.381349] pci 0000:00:01.1: BAR 2: reserving [io  0x0170-0x0177 flags 0x110] (d=0, p=0)
[    0.382768] pci 0000:00:01.1: BAR 3: reserving [io  0x0376 flags 0x110] (d=0, p=0)
[    0.384093] pci 0000:00:01.1: BAR 4: reserving [io  0xc1c0-0xc1cf flags 0x40101] (d=0, p=0)
[    0.385587] pci 0000:00:02.0: BAR 0: reserving [mem 0xfc000000-0xfdffffff flags 0x42208] (d=0, p=0)
[    0.387153] pci 0000:00:02.0: BAR 1: reserving [mem 0xfebf0000-0xfebf0fff flags 0x40200] (d=0, p=0)
[    0.388745] pci 0000:00:03.0: BAR 0: reserving [mem 0xfeba0000-0xfebbffff flags 0x40200] (d=0, p=0)
[    0.390198] pci 0000:00:03.0: BAR 1: reserving [io  0xc000-0xc03f flags 0x40101] (d=0, p=0)
[    0.391682] pci 0000:00:04.0: BAR 0: reserving [io  0xc040-0xc07f flags 0x40101] (d=0, p=0)
[    0.393133] pci 0000:00:04.0: BAR 1: reserving [mem 0xfebf1000-0xfebf1fff flags 0x40200] (d=0, p=0)
[    0.394724] pci 0000:00:05.0: BAR 0: reserving [io  0xc080-0xc0bf flags 0x40101] (d=0, p=0)
[    0.396175] pci 0000:00:05.0: BAR 1: reserving [mem 0xfebf2000-0xfebf2fff flags 0x40200] (d=0, p=0)
[    0.397772] pci 0000:00:06.0: BAR 0: reserving [io  0xc0c0-0xc0ff flags 0x40101] (d=0, p=0)
[    0.400011] pci 0000:00:06.0: BAR 1: reserving [mem 0xfebf3000-0xfebf3fff flags 0x40200] (d=0, p=0)
[    0.401613] pci 0000:00:07.0: BAR 0: reserving [io  0xc100-0xc13f flags 0x40101] (d=0, p=0)
[    0.403062] pci 0000:00:07.0: BAR 1: reserving [mem 0xfebf4000-0xfebf4fff flags 0x40200] (d=0, p=0)
[    0.404657] pci 0000:00:08.0: BAR 0: reserving [io  0xc140-0xc17f flags 0x40101] (d=0, p=0)
[    0.406106] pci 0000:00:08.0: BAR 1: reserving [mem 0xfebf5000-0xfebf5fff flags 0x40200] (d=0, p=0)
[    0.407705] pci 0000:00:09.0: BAR 0: reserving [io  0xc180-0xc1bf flags 0x40101] (d=0, p=0)
[    0.409160] pci 0000:00:09.0: BAR 1: reserving [mem 0xfebf6000-0xfebf6fff flags 0x40200] (d=0, p=0)
[    0.410032] pci 0000:00:0a.0: BAR 0: reserving [mem 0xfebf7000-0xfebf700f flags 0x40200] (d=0, p=0)
[    0.411873] e820: reserve RAM buffer [mem 0x00093c00-0x0009ffff]
[    0.412939] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.440230] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.458808] Switching to clocksource kvm-clock
[    0.459629] Warning: could not register all branches stats
[    0.459629] Warning: could not register annotated branches stats
[    0.522777] pnp: PnP ACPI init
[    0.523451] ACPI: bus type pnp registered
[    0.524337] pnp 00:00: [bus 00-ff]
[    0.524950] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.525679] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.526515] pnp 00:00: [io  0x0d00-0xffff window]
[    0.527345] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.528297] pnp 00:00: [mem 0xe0000000-0xfebfffff window]
[    0.529545] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.530773] pnp 00:01: [io  0x0070-0x0071]
[    0.531556] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:3)
[    0.532984] pnp 00:01: [irq 8]
[    0.533539] pnp 00:01: [io  0x0072-0x0077]
[    0.534478] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.535876] pnp 00:02: [io  0x0060]
[    0.536506] pnp 00:02: [io  0x0064]
[    0.537136] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:3)
[    0.538535] pnp 00:02: [irq 1]
[    0.539195] pnp 00:02: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.540419] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:3)
[    0.541839] pnp 00:03: [irq 12]
[    0.542528] pnp 00:03: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.543742] pnp 00:04: [io  0x03f2-0x03f5]
[    0.544472] pnp 00:04: [io  0x03f7]
[    0.545096] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:3)
[    0.546498] pnp 00:04: [irq 6]
[    0.547041] pnp 00:04: [dma 2]
[    0.547751] pnp 00:04: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.549040] pnp 00:05: [io  0x0378-0x037f]
[    0.549779] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:3)
[    0.551187] pnp 00:05: [irq 7]
[    0.551873] pnp 00:05: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.553121] pnp 00:06: [io  0x03f8-0x03ff]
[    0.553858] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:3)
[    0.555265] pnp 00:06: [irq 4]
[    0.555905] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.557546] pnp 00:07: [mem 0xfed00000-0xfed003ff]
[    0.558626] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.560102] pnp: PnP ACPI: found 8 devices
[    0.560842] ACPI: ACPI bus type pnp unregistered
[    0.567642] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.568644] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.569619] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.570720] pci_bus 0000:00: resource 7 [mem 0xe0000000-0xfebfffff]
[    0.571910] NET: Registered protocol family 1
[    0.572743] pci 0000:00:00.0: calling quirk_natoma+0x0/0x47
[    0.573729] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.574789] pci 0000:00:00.0: calling quirk_passive_release+0x0/0xb0
[    0.575922] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.576978] pci 0000:00:01.0: calling quirk_isa_dma_hangs+0x0/0x45
[    0.578063] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.579223] pci 0000:00:02.0: calling pci_fixup_video+0x0/0x116
[    0.580275] pci 0000:00:02.0: Boot video device
[    0.581097] pci 0000:00:03.0: calling quirk_e100_interrupt+0x0/0x1e6
[    0.582373] PCI: CLS 0 bytes, default 64
[    0.583477] Unpacking initramfs...
[    2.567593] debug: unmapping init [mem 0xffff88000e8d6000-0xffff88000ffeffff]
[    2.589748] Kprobe smoke test started
[    2.770425] Kprobe smoke test passed successfully
[    2.772437] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    2.778529] VFS: Disk quotas dquot_6.5.2
[    2.779425] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    2.780886] msgmni has been set to 387
[    2.781703] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    2.783011] io scheduler noop registered (default)
[    2.783863] list_sort_test: start testing list_sort()
[    2.785904] crc32: CRC_LE_BITS = 64, CRC_BE BITS = 64
[    2.786797] crc32: self tests passed, processed 225944 bytes in 175530 nsec
[    2.788186] crc32c: CRC_LE_BITS = 64
[    2.788827] crc32c: self tests passed, processed 225944 bytes in 87780 nsec
[    2.790674] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    2.791980] ACPI: Power Button [PWRF]
[    2.848110] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    2.872104] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.897765] 00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.899274] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    2.901843] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.902720] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.903687] cpuidle: using governor ladder
[    2.905177] 
[    2.905177] printing PIC contents
[    2.906027] ... PIC  IMR: ffff
[    2.906584] ... PIC  IRR: 1013
[    2.907139] ... PIC  ISR: 0000
[    2.907694] ... PIC ELCR: 0c00
[    2.908312] printing local APIC contents on CPU#0/0:
[    2.909183] ... APIC ID:      00000000 (0)
[    2.909911] ... APIC VERSION: 00050014
[    2.910643] ... APIC TASKPRI: 00000000 (00)
[    2.910679] ... APIC PROCPRI: 00000000
[    2.910679] ... APIC LDR: 01000000
[    2.910679] ... APIC DFR: ffffffff
[    2.910679] ... APIC SPIV: 000001ff
[    2.910679] ... APIC ISR field:
[    2.910679] 0000000000000000000000000000000000000000000000000000000000000000
[    2.910679] ... APIC TMR field:
[    2.910679] 0000000000000000000000000000000000000000000000000000000000000000
[    2.910679] ... APIC IRR field:
[    2.910679] 0000000000000000000000000000000000000000000000000000000000008000
[    2.910679] ... APIC ESR: 00000000
[    2.910679] ... APIC ICR: 000008fb
[    2.910679] ... APIC ICR2: 02000000
[    2.910679] ... APIC LVTT: 000200ef
[    2.910679] ... APIC LVTPC: 00010000
[    2.910679] ... APIC LVT0: 00010700
[    2.910679] ... APIC LVT1: 00000400
[    2.910679] ... APIC LVTERR: 000000fe
[    2.910679] ... APIC TMICT: 00098966
[    2.910679] ... APIC TMCCT: 00044ec8
[    2.910679] ... APIC TDCR: 00000003
[    2.910679] 
[    2.927290] number of MP IRQ sources: 15.
[    2.928002] number of IO-APIC #2 registers: 24.
[    2.928817] testing the IO APIC.......................
[    2.929737] IO APIC #2......
[    2.930257] .... register #00: 00000000
[    2.930933] .......    : physical APIC id: 00
[    2.931703] .......    : Delivery Type: 0
[    2.932413] .......    : LTS          : 0
[    2.933118] .... register #01: 00170011
[    2.933801] .......     : max redirection entries: 17
[    2.934687] .......     : PRQ implemented: 0
[    2.935442] .......     : IO APIC version: 11
[    2.936212] .... register #02: 00000000
[    2.936888] .......     : arbitration: 00
[    2.937598] .... IRQ redirection table:
[    2.938288]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
[    2.939280]  00 00  1    0    0   0   0    0    0    00
[    2.940240]  01 03  0    0    0   0   0    1    1    31
[    2.941198]  02 03  0    0    0   0   0    1    1    30
[    2.942152]  03 03  0    0    0   0   0    1    1    33
[    2.943110]  04 03  1    0    0   0   0    1    1    34
[    2.944069]  05 03  1    1    0   0   0    1    1    35
[    2.945028]  06 03  0    0    0   0   0    1    1    36
[    2.945990]  07 03  0    0    0   0   0    1    1    37
[    2.946951]  08 03  0    0    0   0   0    1    1    38
[    2.947912]  09 03  0    1    0   0   0    1    1    39
[    2.948887]  0a 03  1    1    0   0   0    1    1    3A
[    2.949850]  0b 03  1    1    0   0   0    1    1    3B
[    2.950815]  0c 03  0    0    0   0   0    1    1    3C
[    2.951774]  0d 03  0    0    0   0   0    1    1    3D
[    2.952734]  0e 03  0    0    0   0   0    1    1    3E
[    2.953695]  0f 03  0    0    0   0   0    1    1    3F
[    2.954659]  10 00  1    0    0   0   0    0    0    00
[    2.955621]  11 00  1    0    0   0   0    0    0    00
[    2.956583]  12 00  1    0    0   0   0    0    0    00
[    2.957548]  13 00  1    0    0   0   0    0    0    00
[    2.958508]  14 00  1    0    0   0   0    0    0    00
[    2.959483]  15 00  1    0    0   0   0    0    0    00
[    2.960446]  16 00  1    0    0   0   0    0    0    00
[    2.961407]  17 00  1    0    0   0   0    0    0    00
[    2.962353] IRQ to pin mappings:
[    2.962929] IRQ0 -> 0:2
[    2.963431] IRQ1 -> 0:1
[    2.963926] IRQ3 -> 0:3
[    2.964428] IRQ4 -> 0:4
[    2.964924] IRQ5 -> 0:5
[    2.965427] IRQ6 -> 0:6
[    2.965923] IRQ7 -> 0:7
[    2.966426] IRQ8 -> 0:8
[    2.966923] IRQ9 -> 0:9
[    2.967426] IRQ10 -> 0:10
[    2.967952] IRQ11 -> 0:11
[    2.968485] IRQ12 -> 0:12
[    2.969024] IRQ13 -> 0:13
[    2.969557] IRQ14 -> 0:14
[    2.970082] IRQ15 -> 0:15
[    2.970614] .................................... done.
[    2.974151] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[    2.976892] hd: no drives specified - use hd=cyl,head,sectors on kernel command line
[    2.980146] debug: unmapping init [mem 0xffffffff81b96000-0xffffffff81dd9fff]
[    2.986734] double fault: 0000 [#1] SMP DEBUG_PAGEALLOC
[    2.987767] Modules linked in:
[    2.988348] CPU 1 
[    2.988568] Pid: 1, comm: init Not tainted 3.6.0-rc3-00182-gc2865bb #44  
[    2.988568] RIP: 0010:[<ffffffff81052e33>]  [<ffffffff81052e33>] kvm_read_and_reset_pf_reason+0x13/0x60
[    2.988568] RSP: 0018:ffff880000000028  EFLAGS: 00010046
[    2.988568] RAX: 000000000000ef00 RBX: ffff880000000058 RCX: ffffffff8142f872
[    2.988568] RDX: 000000000000ef00 RSI: 0000000000000000 RDI: ffff880000000058
[    2.988568] RBP: ffff880000000028 R08: ffff880000067f48 R09: ffffffff81d6c72a
[    2.988568] R10: ffffffff81d6d07b R11: ffff880000067f40 R12: 0000000000000000
[    2.988568] R13: 0000000000000000 R14: ffffffff81dcbdb0 R15: ffffffff81dcbdb0
[    2.988568] FS:  0000000000000000(0000) GS:ffff88000dc00000(0000) knlGS:0000000000000000
[    2.988568] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    2.988568] CR2: ffff87fffffffff8 CR3: 00000000069c5000 CR4: 00000000000006e0
[    2.988568] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    2.988568] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    2.988568] Process init (pid: 1, threadinfo ffff880000066000, task ffff880000068000)
[    2.988568] Stack:
[    2.988568]  ffff880000000048 ffffffff81433a10 0000000000000001 0000000000000000
[    2.988568]  ffff880000000108 ffffffff8142fae5 ffffffff81dcbdb0 ffffffff81dcbdb0
[    2.988568]  0000000000000000 0000000000000000 ffff880000000108 ffff880000000138
[    3.010313] Call Trace:
[    3.010313] Code: 00 83 b8 44 e0 ff ff 01 0f 9f c0 e9 9d fe ff ff 0f 1f 84 00 00 00 00 00 55 48 89 e5 e8 d7 7a 3e 00 48 c7 c2 00 ef 00 00 48 89 d0 <65> 48 03 04 25 40 ec 00 00 8b 78 40 31 c9 85 ff 0f 95 c1 48 63 
[    3.010313] RIP  [<ffffffff81052e33>] kvm_read_and_reset_pf_reason+0x13/0x60
[    3.010313]  RSP <ffff880000000028>
[    3.010313] ---[ end trace f331497cdb6a1163 ]---
[    3.010313] BUG: sleeping function called from invalid context at /c/kernel-tests/src/tip/kernel/rwsem.c:20
[    3.010313] in_atomic(): 0, irqs_disabled(): 1, pid: 1, name: init
[    3.010313] INFO: lockdep is turned off.
[    3.010313] Pid: 1, comm: init Tainted: G      D      3.6.0-rc3-00182-gc2865bb #44
[    3.010313] Call Trace:
[    3.010313]  <#DF>  [<ffffffff810b0def>] __might_sleep+0x12f/0x160
[    3.010313]  [<ffffffff8142bea6>] down_read+0x26/0xb0
[    3.010313]  [<ffffffff8106d1c0>] exit_mm+0x70/0x1e0
[    3.010313]  [<ffffffff8106ff9c>] do_exit+0x2dc/0xde0
[    3.010313]  [<ffffffff8106c468>] ? kmsg_dump+0xa8/0x160
[    3.010313]  [<ffffffff8106c3f8>] ? kmsg_dump+0x38/0x160
[    3.010313]  [<ffffffff8143096b>] oops_end+0x10b/0x150
[    3.010313]  [<ffffffff81021326>] die+0x86/0xc0
[    3.010313]  [<ffffffff8101dcf2>] do_double_fault+0x72/0x80
[    3.010313]  [<ffffffff8143ba45>] double_fault+0x25/0x30
[    3.010313]  [<ffffffff81d6d07b>] ? kernel_init+0x1c2/0x1c2
[    3.010313]  [<ffffffff81d6c72a>] ? do_early_param+0xc6/0xc6
[    3.010313]  [<ffffffff8142f872>] ? restore_args+0x30/0x30
[    3.010313]  [<ffffffff81052e33>] ? kvm_read_and_reset_pf_reason+0x13/0x60
[    3.010313]  <<EOE>> 
[    3.010313] BUG: unable to handle kernel paging request at ffff87ff8f9cbdb8
[    3.010313] IP: [<ffffffff811a3149>] kmem_cache_free+0xd9/0x1f0
[    3.010313] PGD 0 
[    3.010313] Thread overran stack, or stack corrupted
[    3.010313] Oops: 0000 [#2] SMP DEBUG_PAGEALLOC
[    3.010313] Modules linked in:
[    3.010313] CPU 1 
[    3.010313] Pid: 1, comm: init Tainted: G      D      3.6.0-rc3-00182-gc2865bb #44  
[    3.010313] RIP: 0010:[<ffffffff811a3149>]  [<ffffffff811a3149>] kmem_cache_free+0xd9/0x1f0
[    3.010313] RSP: 0018:ffff88000dc05bb8  EFLAGS: 00010083
[    3.010313] RAX: 0000000000000002 RBX: ffff8800069ce1a0 RCX: 0000000000000028
[    3.010313] RDX: 0000000000000003 RSI: 0000000000000000 RDI: ffffffff8199ed70
[    3.010313] RBP: ffff88000dc05bf8 R08: 0000000000000000 R09: 0000000000000000
[    3.010313] R10: 2222222222222222 R11: 2222222222222222 R12: ffff87ff8f9cbdb0
[    3.010313] R13: ffff880000018240 R14: ffffea00001a7380 R15: 0000000000000000
[    3.010313] FS:  0000000000000000(0000) GS:ffff88000dc00000(0000) knlGS:0000000000000000
[    3.010313] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    3.010313] CR2: ffff87ff8f9cbdb8 CR3: 00000000069c5000 CR4: 00000000000006e0
[    3.010313] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    3.010313] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    3.010313] Process init (pid: 1, threadinfo ffff880000066000, task ffff880000068000)
[    3.010313] Stack:
[    3.010313]  ffff88000dc05bd8 ffffea00001a7380 ffff8800069ce1b0 ffff8800069ce1a0
[    3.010313]  ffff8800069ce1a0 ffff88000cc6f0f0 ffff8800069c6310 0000000000000000
[    3.010313]  ffff88000dc05c18 ffffffff8118b06a ffff8800069c6300 ffff88000cc6f100
[    3.010313] Call Trace:
[    3.010313]  <#DF> 
[    3.010313]  [<ffffffff8118b06a>] __put_anon_vma+0xba/0xe0
[    3.010313]  [<ffffffff8118b63e>] unlink_anon_vmas+0x26e/0x2e0
[    3.010313]  [<ffffffff81177d92>] free_pgtables+0xc2/0x140
[    3.010313]  [<ffffffff81185451>] exit_mmap+0x111/0x210
[    3.010313]  [<ffffffff811404ee>] ? uprobe_clear_state+0xe/0x60
[    3.010313]  [<ffffffff81062aad>] mmput+0x8d/0x160
[    3.010313]  [<ffffffff8106d289>] exit_mm+0x139/0x1e0
[    3.010313]  [<ffffffff8106ff9c>] do_exit+0x2dc/0xde0
[    3.010313]  [<ffffffff8106c468>] ? kmsg_dump+0xa8/0x160
[    3.010313]  [<ffffffff8106c3f8>] ? kmsg_dump+0x38/0x160
[    3.010313]  [<ffffffff8143096b>] oops_end+0x10b/0x150
[    3.010313]  [<ffffffff81021326>] die+0x86/0xc0
[    3.010313]  [<ffffffff8101dcf2>] do_double_fault+0x72/0x80
[    3.010313]  [<ffffffff8143ba45>] double_fault+0x25/0x30
[    3.010313]  [<ffffffff81d6d07b>] ? kernel_init+0x1c2/0x1c2
[    3.010313]  [<ffffffff81d6c72a>] ? do_early_param+0xc6/0xc6
[    3.010313]  [<ffffffff8142f872>] ? restore_args+0x30/0x30
[    3.010313]  [<ffffffff81052e33>] ? kvm_read_and_reset_pf_reason+0x13/0x60
[    3.010313]  <<EOE>> 
[    3.010313] Code: 81 44 0f b6 e0 44 89 e6 e8 95 35 f7 ff 49 63 c4 48 83 04 c5 78 ea a7 81 01 45 85 e4 74 5e 4d 8b 65 00 65 4c 03 24 25 40 ec 00 00 <4d> 8b 74 24 08 45 31 ff 48 8b 45 c8 49 3b 44 24 10 ba 01 00 00 
[    3.010313] RIP  [<ffffffff811a3149>] kmem_cache_free+0xd9/0x1f0
[    3.010313]  RSP <ffff88000dc05bb8>
[    3.010313] CR2: ffff87ff8f9cbdb8
[    3.010313] ---[ end trace f331497cdb6a1164 ]---
[    3.010313] Fixing recursive fault but reboot is needed!
[    3.580310] ------------[ cut here ]------------
[    3.581161] WARNING: at /c/kernel-tests/src/tip/lib/list_debug.c:62 __list_del_entry+0x221/0x230()
[    3.582724] list_del corruption. next->prev should be ffff880000179d80, but was ffff88000005c0c8
[    3.584245] Modules linked in:
[    3.584819] Pid: 17, comm: kworker/0:1 Tainted: G      D      3.6.0-rc3-00182-gc2865bb #44
[    3.586255] Call Trace:
[    3.586701]  [<ffffffff81296cb1>] ? __list_del_entry+0x221/0x230
[    3.587759]  [<ffffffff81066fdf>] warn_slowpath_common+0x8f/0xc0
[    3.588814]  [<ffffffff810670c6>] warn_slowpath_fmt+0x46/0x50
[    3.589822]  [<ffffffff81296cb1>] __list_del_entry+0x221/0x230
[    3.590281]  [<ffffffff81091f4c>] worker_thread+0x2ec/0x7e0
[    3.590281]  [<ffffffff81091c60>] ? manage_workers.isra.14+0x3b0/0x3b0
[    3.590281]  [<ffffffff81091c60>] ? manage_workers.isra.14+0x3b0/0x3b0
[    3.590281]  [<ffffffff8109fa9a>] kthread+0xba/0xc0
[    3.590281]  [<ffffffff810b2b29>] ? schedule_tail+0x29/0x110
[    3.590281]  [<ffffffff8143bb84>] kernel_thread_helper+0x4/0x10
[    3.590281]  [<ffffffff8109f9e0>] ? __init_kthread_worker+0x70/0x70
[    3.590281]  [<ffffffff8143bb80>] ? gs_change+0x13/0x13
[    3.590281] ---[ end trace f331497cdb6a1165 ]---
[    3.599994] BUG: unable to handle kernel paging request at ffff900000033000
[    3.601278] IP: [<ffffffff81433ce5>] vmalloc_fault+0x265/0x40b
[    3.602355] PGD 0 
[    3.602755] Oops: 0000 [#3] SMP DEBUG_PAGEALLOC
[    3.603652] Modules linked in:
[    3.604233] CPU 0 
[    3.604574] Pid: 17, comm: kworker/0:1 Tainted: G      D W    3.6.0-rc3-00182-gc2865bb #44  
[    3.606094] RIP: 0010:[<ffffffff81433ce5>]  [<ffffffff81433ce5>] vmalloc_fault+0x265/0x40b
[    3.607570] RSP: 0018:ffff88000cc2daa8  EFLAGS: 00010086
[    3.608515] RAX: 0000080000033000 RBX: ffffffff816efc90 RCX: ffff900000033000
[    3.609762] RDX: 0000000000000000 RSI: 00003ffffffff000 RDI: ffff8800000330b8
[    3.609973] RBP: ffff88000cc2dac8 R08: ffff900000033000 R09: ffff880000033000
[    3.609973] R10: 0000000000000000 R11: 0000000000000006 R12: ffffc900000000f0
[    3.609973] R13: ffffffff816efc90 R14: 0000000000000000 R15: 00000000000000a8
[    3.609973] FS:  0000000000000000(0000) GS:ffff88000da00000(0000) knlGS:0000000000000000
[    3.609973] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    3.609973] CR2: ffff900000033000 CR3: 00000000016ef000 CR4: 00000000000006f0
[    3.609973] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    3.609973] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    3.609973] Process kworker/0:1 (pid: 17, threadinfo ffff88000cc2c000, task ffff88000019a000)
[    3.609973] Stack:
[    3.609973]  0000000000000028 ffff88000019a000 0000000000000000 0000000000000000
[    3.609973]  ffff88000cc2dbe8 ffffffff814343c2 ffffffff81352d83 0000000100000001
[    3.609973]  ffffffff825a3100 0000000000000000 ffff88000cc2dc18 ffffc900000000f0
[    3.609973] Call Trace:
[    3.609973]  [<ffffffff814343c2>] do_page_fault+0x282/0xc60
[    3.609973]  [<ffffffff81352d83>] ? wait_for_xmitr+0x53/0x100
[    3.609973]  [<ffffffff81294621>] ? do_raw_spin_unlock+0x131/0x160
[    3.609973]  [<ffffffff81294621>] ? do_raw_spin_unlock+0x131/0x160
[    3.609973]  [<ffffffff81433a25>] do_async_page_fault+0x35/0x90
[    3.609973]  [<ffffffff8142fae5>] async_page_fault+0x25/0x30
[    3.609973]  [<ffffffff81051c6d>] ? hpet_readl+0xd/0x20
[    3.609973]  [<ffffffff81026aa2>] tsc_read_refs+0xc2/0xe0
[    3.609973]  [<ffffffff8108e6e1>] ? process_one_work+0x371/0x990
[    3.609973]  [<ffffffff81026b25>] tsc_refine_calibration_work+0x65/0x250
[    3.609973]  [<ffffffff8108e7e7>] process_one_work+0x477/0x990
[    3.609973]  [<ffffffff8108e6e1>] ? process_one_work+0x371/0x990
[    3.609973]  [<ffffffff810670c6>] ? warn_slowpath_fmt+0x46/0x50
[    3.609973]  [<ffffffff81026ac0>] ? tsc_read_refs+0xe0/0xe0
[    3.609973]  [<ffffffff81092165>] worker_thread+0x505/0x7e0
[    3.609973]  [<ffffffff81091c60>] ? manage_workers.isra.14+0x3b0/0x3b0
[    3.609973]  [<ffffffff81091c60>] ? manage_workers.isra.14+0x3b0/0x3b0
[    3.609973]  [<ffffffff8109fa9a>] kthread+0xba/0xc0
[    3.609973]  [<ffffffff810b2b29>] ? schedule_tail+0x29/0x110
[    3.609973]  [<ffffffff8143bb84>] kernel_thread_helper+0x4/0x10
[    3.609973]  [<ffffffff8109f9e0>] ? __init_kthread_worker+0x70/0x70
[    3.609973]  [<ffffffff8143bb80>] ? gs_change+0x13/0x13
[    3.609973] Code: e9 12 81 e1 f8 0f 00 00 48 01 f1 48 be 00 f0 ff ff ff 3f 00 00 48 21 f0 4c 8d 04 08 48 89 f8 0f 1f 40 00 48 21 f0 31 d2 48 01 c1 <48> 83 39 00 0f 94 c2 48 63 c2 48 83 c0 02 48 ff 04 c5 88 ba 9e 
[    3.609973] RIP  [<ffffffff81433ce5>] vmalloc_fault+0x265/0x40b
[    3.609973]  RSP <ffff88000cc2daa8>
[    3.609973] CR2: ffff900000033000
[    3.609973] ---[ end trace f331497cdb6a1166 ]---
[    3.609973] kworker/0:1 (17) used greatest stack depth: 4032 bytes left
[    3.659887] BUG: unable to handle kernel paging request at ffff881ffff425b8
[    3.661168] IP: [<ffffffff81094674>] task_active_pid_ns+0x34/0x50
[    3.662282] PGD 16f0063 PUD 0 
[    3.662888] Oops: 0000 [#4] SMP DEBUG_PAGEALLOC
[    3.663777] Modules linked in:
[    3.664358] CPU 0 
[    3.664700] Pid: 17, comm: kworker/0:1 Tainted: G      D W    3.6.0-rc3-00182-gc2865bb #44  
[    3.666243] RIP: 0010:[<ffffffff81094674>]  [<ffffffff81094674>] task_active_pid_ns+0x34/0x50
[    3.667763] RSP: 0018:ffff88000cc2d630  EFLAGS: 00010006
[    3.668705] RAX: ffff880000032580 RBX: ffff88000cc2c000 RCX: 0000000000000003
[    3.669872] RDX: 0000001ffff10000 RSI: 0000000000000000 RDI: ffff88000006a000
[    3.669872] RBP: ffff88000cc2d6f8 R08: 0000000000000001 R09: 0000000000000000
[    3.669872] R10: 0000000000000000 R11: 2222222222222222 R12: ffff88000019a000
[    3.669872] R13: 0000000000000011 R14: ffff88000cc2d3f0 R15: ffff880000199ff0
[    3.669872] FS:  0000000000000000(0000) GS:ffff88000da00000(0000) knlGS:0000000000000000
[    3.669872] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    3.669872] CR2: ffff881ffff425b8 CR3: 00000000016ef000 CR4: 00000000000006f0
[    3.669872] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    3.669872] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    3.669872] Process kworker/0:1 (pid: 17, threadinfo ffff88000cc2c000, task ffff88000019a000)
[    3.669872] Stack:
[    3.669872]  ffffffff81083bcc ffffffff81083b74 0000000000000000 0000000000000011
[    3.669872]  0000000000000000 ffff88000cc2d6c8 0000000000000046 ffffffff81070773
[    3.669872]  0000000000000000 ffff88000cc2d6c8 0000000000000046 0000000100000002
[    3.669872] Call Trace:
[    3.669872]  [<ffffffff81083bcc>] ? do_notify_parent+0x18c/0x460
[    3.669872]  [<ffffffff81083b74>] ? do_notify_parent+0x134/0x460
[    3.669872]  [<ffffffff81070773>] ? do_exit+0xab3/0xde0
[    3.669872]  [<ffffffff810709cb>] do_exit+0xd0b/0xde0
[    3.669872]  [<ffffffff8143096b>] oops_end+0x10b/0x150
[    3.669872]  [<ffffffff8141e04d>] no_context+0x3cb/0x3da
[    3.669872]  [<ffffffff8141e310>] __bad_area_nosemaphore+0x2b4/0x2c3
[    3.669872]  [<ffffffff8141e332>] bad_area_nosemaphore+0x13/0x15
[    3.669872]  [<ffffffff814343b1>] do_page_fault+0x271/0xc60
[    3.669872]  [<ffffffff8127bb00>] ? sprintf+0x40/0x50
[    3.669872]  [<ffffffff81352649>] ? io_serial_in+0x9/0x20
[    3.669872]  [<ffffffff81352d83>] ? wait_for_xmitr+0x53/0x100
[    3.669872]  [<ffffffff81352669>] ? io_serial_out+0x9/0x20
[    3.669872]  [<ffffffff8127791a>] ? put_dec+0x9a/0xc0
[    3.669872]  [<ffffffff81279c17>] ? number.isra.2+0x617/0x650
[    3.669872]  [<ffffffff81433a25>] do_async_page_fault+0x35/0x90
[    3.669872]  [<ffffffff8142fae5>] async_page_fault+0x25/0x30
[    3.669872]  [<ffffffff81433ce5>] ? vmalloc_fault+0x265/0x40b
[    3.669872]  [<ffffffff81433bd6>] ? vmalloc_fault+0x156/0x40b
[    3.669872]  [<ffffffff814343c2>] do_page_fault+0x282/0xc60
[    3.669872]  [<ffffffff81352d83>] ? wait_for_xmitr+0x53/0x100
[    3.669872]  [<ffffffff81294621>] ? do_raw_spin_unlock+0x131/0x160
[    3.669872]  [<ffffffff81294621>] ? do_raw_spin_unlock+0x131/0x160
[    3.669872]  [<ffffffff81433a25>] do_async_page_fault+0x35/0x90
[    3.669872]  [<ffffffff8142fae5>] async_page_fault+0x25/0x30
[    3.669872]  [<ffffffff81051c6d>] ? hpet_readl+0xd/0x20
[    3.669872]  [<ffffffff81026aa2>] tsc_read_refs+0xc2/0xe0
[    3.669872]  [<ffffffff8108e6e1>] ? process_one_work+0x371/0x990
[    3.669872]  [<ffffffff81026b25>] tsc_refine_calibration_work+0x65/0x250
[    3.669872]  [<ffffffff8108e7e7>] process_one_work+0x477/0x990
[    3.669872]  [<ffffffff8108e6e1>] ? process_one_work+0x371/0x990
[    3.669872]  [<ffffffff810670c6>] ? warn_slowpath_fmt+0x46/0x50
[    3.669872]  [<ffffffff81026ac0>] ? tsc_read_refs+0xe0/0xe0
[    3.669872]  [<ffffffff81092165>] worker_thread+0x505/0x7e0
[    3.669872]  [<ffffffff81091c60>] ? manage_workers.isra.14+0x3b0/0x3b0
[    3.669872]  [<ffffffff81091c60>] ? manage_workers.isra.14+0x3b0/0x3b0
[    3.669872]  [<ffffffff8109fa9a>] kthread+0xba/0xc0
[    3.669872]  [<ffffffff810b2b29>] ? schedule_tail+0x29/0x110
[    3.669872]  [<ffffffff8143bb84>] kernel_thread_helper+0x4/0x10
[    3.669872]  [<ffffffff8109f9e0>] ? __init_kthread_worker+0x70/0x70
[    3.669872]  [<ffffffff8143bb80>] ? gs_change+0x13/0x13
[    3.669872] Code: 48 8b 87 c0 03 00 00 31 d2 48 85 c0 0f 95 c2 48 63 ca 48 83 c1 02 48 83 04 cd 00 73 a0 81 01 85 d2 74 14 8b 50 04 5d 48 c1 e2 05 <48> 8b 44 10 38 c3 66 0f 1f 44 00 00 31 c0 5d c3 66 66 66 2e 0f 
[    3.669872] RIP  [<ffffffff81094674>] task_active_pid_ns+0x34/0x50
[    3.669872]  RSP <ffff88000cc2d630>
[    3.669872] CR2: ffff881ffff425b8
[    3.669872] ---[ end trace f331497cdb6a1167 ]---
[    3.669872] Fixing recursive fault but reboot is needed!
[    3.669872] BUG: scheduling while atomic: kworker/0:1/17/0x00000003
[    3.669872] INFO: lockdep is turned off.
[    3.669872] Modules linked in:
[    3.669872] Pid: 17, comm: kworker/0:1 Tainted: G      D W    3.6.0-rc3-00182-gc2865bb #44
[    3.669872] Call Trace:
[    3.669872]  [<ffffffff810af645>] __schedule_bug+0x95/0xb0
[    3.669872]  [<ffffffff8142c9fe>] __schedule+0xde/0xc30
[    3.669872]  [<ffffffff81069eab>] ? console_unlock+0x3ab/0x620
[    3.669872]  [<ffffffff8141eb37>] ? printk+0x4d/0x4f
[    3.669872]  [<ffffffff8142d727>] schedule+0x97/0xa0
[    3.669872]  [<ffffffff81070598>] do_exit+0x8d8/0xde0
[    3.669872]  [<ffffffff8106c468>] ? kmsg_dump+0xa8/0x160
[    3.669872]  [<ffffffff8106c3f8>] ? kmsg_dump+0x38/0x160
[    3.669872]  [<ffffffff8143096b>] oops_end+0x10b/0x150
[    3.669872]  [<ffffffff8141e04d>] no_context+0x3cb/0x3da
[    3.669872]  [<ffffffff8141e310>] __bad_area_nosemaphore+0x2b4/0x2c3
[    3.669872]  [<ffffffff8127791a>] ? put_dec+0x9a/0xc0
[    3.669872]  [<ffffffff81277ba3>] ? format_decode+0x263/0x6b0
[    3.669872]  [<ffffffff8141e332>] bad_area_nosemaphore+0x13/0x15
[    3.669872]  [<ffffffff814343b1>] do_page_fault+0x271/0xc60
[    3.669872]  [<ffffffff8127bb00>] ? sprintf+0x40/0x50
[    3.669872]  [<ffffffff81352649>] ? io_serial_in+0x9/0x20
[    3.669872]  [<ffffffff81352d83>] ? wait_for_xmitr+0x53/0x100
[    3.669872]  [<ffffffff81352669>] ? io_serial_out+0x9/0x20
[    3.669872]  [<ffffffff81294621>] ? do_raw_spin_unlock+0x131/0x160
[    3.669872]  [<ffffffff81433a25>] do_async_page_fault+0x35/0x90
[    3.669872]  [<ffffffff8142fae5>] async_page_fault+0x25/0x30
[    3.669872]  [<ffffffff81094674>] ? task_active_pid_ns+0x34/0x50
[    3.669872]  [<ffffffff81083bcc>] ? do_notify_parent+0x18c/0x460
[    3.669872]  [<ffffffff81083b74>] ? do_notify_parent+0x134/0x460
[    3.669872]  [<ffffffff81070773>] ? do_exit+0xab3/0xde0
[    3.669872]  [<ffffffff810709cb>] do_exit+0xd0b/0xde0
[    3.669872]  [<ffffffff8143096b>] oops_end+0x10b/0x150
[    3.669872]  [<ffffffff8141e04d>] no_context+0x3cb/0x3da
[    3.669872]  [<ffffffff8141e310>] __bad_area_nosemaphore+0x2b4/0x2c3
[    3.669872]  [<ffffffff8141e332>] bad_area_nosemaphore+0x13/0x15
[    3.669872]  [<ffffffff814343b1>] do_page_fault+0x271/0xc60
[    3.669872]  [<ffffffff8127bb00>] ? sprintf+0x40/0x50
[    3.669872]  [<ffffffff81352649>] ? io_serial_in+0x9/0x20
[    3.669872]  [<ffffffff81352d83>] ? wait_for_xmitr+0x53/0x100
[    3.669872]  [<ffffffff81352669>] ? io_serial_out+0x9/0x20
[    3.669872]  [<ffffffff8127791a>] ? put_dec+0x9a/0xc0
[    3.669872]  [<ffffffff81279c17>] ? number.isra.2+0x617/0x650
[    3.669872]  [<ffffffff81433a25>] do_async_page_fault+0x35/0x90
[    3.669872]  [<ffffffff8142fae5>] async_page_fault+0x25/0x30
[    3.669872]  [<ffffffff81433ce5>] ? vmalloc_fault+0x265/0x40b
[    3.669872]  [<ffffffff81433bd6>] ? vmalloc_fault+0x156/0x40b
[    3.669872]  [<ffffffff814343c2>] do_page_fault+0x282/0xc60
[    3.669872]  [<ffffffff81352d83>] ? wait_for_xmitr+0x53/0x100
[    3.669872]  [<ffffffff81294621>] ? do_raw_spin_unlock+0x131/0x160
[    3.669872]  [<ffffffff81294621>] ? do_raw_spin_unlock+0x131/0x160
[    3.669872]  [<ffffffff81433a25>] do_async_page_fault+0x35/0x90
[    3.669872]  [<ffffffff8142fae5>] async_page_fault+0x25/0x30
[    3.669872]  [<ffffffff81051c6d>] ? hpet_readl+0xd/0x20
[    3.669872]  [<ffffffff81026aa2>] tsc_read_refs+0xc2/0xe0
[    3.669872]  [<ffffffff8108e6e1>] ? process_one_work+0x371/0x990
[    3.669872]  [<ffffffff81026b25>] tsc_refine_calibration_work+0x65/0x250
[    3.669872]  [<ffffffff8108e7e7>] process_one_work+0x477/0x990
[    3.669872]  [<ffffffff8108e6e1>] ? process_one_work+0x371/0x990
[    3.669872]  [<ffffffff810670c6>] ? warn_slowpath_fmt+0x46/0x50
[    3.669872]  [<ffffffff81026ac0>] ? tsc_read_refs+0xe0/0xe0
[    3.669872]  [<ffffffff81092165>] worker_thread+0x505/0x7e0
[    3.669872]  [<ffffffff81091c60>] ? manage_workers.isra.14+0x3b0/0x3b0
[    3.669872]  [<ffffffff81091c60>] ? manage_workers.isra.14+0x3b0/0x3b0
[    3.669872]  [<ffffffff8109fa9a>] kthread+0xba/0xc0
[    3.669872]  [<ffffffff810b2b29>] ? schedule_tail+0x29/0x110
[    3.669872]  [<ffffffff8143bb84>] kernel_thread_helper+0x4/0x10
[    3.669872]  [<ffffffff8109f9e0>] ? __init_kthread_worker+0x70/0x70
[    3.669872]  [<ffffffff8143bb80>] ? gs_change+0x13/0x13
[    3.669872] BUG: unable to handle kernel paging request at fffffffffffffff8
[    3.669872] IP: [<ffffffff8109fec1>] kthread_data+0x11/0x20
[    3.669872] PGD 16f1067 PUD 16f2067 PMD 0 
[    3.669872] Oops: 0000 [#5] SMP DEBUG_PAGEALLOC
[    3.669872] Modules linked in:
[    3.669872] CPU 0 
[    3.669872] Pid: 17, comm: kworker/0:1 Tainted: G      D W    3.6.0-rc3-00182-gc2865bb #44  
[    3.669872] RIP: 0010:[<ffffffff8109fec1>]  [<ffffffff8109fec1>] kthread_data+0x11/0x20
[    3.669872] RSP: 0018:ffff88000cc2d120  EFLAGS: 00010046
[    3.669872] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
[    3.669872] RDX: 0000000000000003 RSI: 0000000000000000 RDI: ffff88000019a000
[    3.669872] RBP: ffff88000cc2d148 R08: 0000000000000002 R09: 0000000000000000
[    3.669872] R10: 0000000000000000 R11: 0000000000000002 R12: ffff88000dbd4780
[    3.669872] R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000000
[    3.669872] FS:  0000000000000000(0000) GS:ffff88000da00000(0000) knlGS:0000000000000000
[    3.669872] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    3.669872] CR2: fffffffffffffff8 CR3: 00000000016ef000 CR4: 00000000000006f0
[    3.669872] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    3.669872] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    3.669872] Process kworker/0:1 (pid: 17, threadinfo ffff88000cc2c000, task ffff88000019a000)
[    3.669872] Stack:
[    3.669872]  ffffffff81093c15 0000000000000000 ffff88000dbd4780 0000000000000001
[    3.669872]  0000000000000002 ffff88000cc2d278 ffffffff8142d363 ffff88000cc2d1a8
[    3.669872]  ffffffff81069eab ffff88000019a000 ffff88000cc2dfd8 ffff88000cc2dfd8
[    3.669872] Call Trace:
[    3.669872]  [<ffffffff81093c15>] ? wq_worker_sleeping+0x25/0xe0
[    3.669872]  [<ffffffff8142d363>] __schedule+0xa43/0xc30
[    3.669872]  [<ffffffff81069eab>] ? console_unlock+0x3ab/0x620
[    3.669872]  [<ffffffff8141eb37>] ? printk+0x4d/0x4f
[    3.669872]  [<ffffffff8142d727>] schedule+0x97/0xa0
[    3.669872]  [<ffffffff81070598>] do_exit+0x8d8/0xde0
[    3.669872]  [<ffffffff8106c468>] ? kmsg_dump+0xa8/0x160
[    3.669872]  [<ffffffff8106c3f8>] ? kmsg_dump+0x38/0x160
[    3.669872]  [<ffffffff8143096b>] oops_end+0x10b/0x150
[    3.669872]  [<ffffffff8141e04d>] no_context+0x3cb/0x3da
[    3.669872]  [<ffffffff8141e310>] __bad_area_nosemaphore+0x2b4/0x2c3
[    3.669872]  [<ffffffff8127791a>] ? put_dec+0x9a/0xc0
[    3.669872]  [<ffffffff81277ba3>] ? format_decode+0x263/0x6b0
[    3.669872]  [<ffffffff8141e332>] bad_area_nosemaphore+0x13/0x15
[    3.669872]  [<ffffffff814343b1>] do_page_fault+0x271/0xc60
[    3.669872]  [<ffffffff8127bb00>] ? sprintf+0x40/0x50
[    3.669872]  [<ffffffff81352649>] ? io_serial_in+0x9/0x20
[    3.669872]  [<ffffffff81352d83>] ? wait_for_xmitr+0x53/0x100
[    3.669872]  [<ffffffff81352669>] ? io_serial_out+0x9/0x20
[    3.669872]  [<ffffffff81294621>] ? do_raw_spin_unlock+0x131/0x160
[    3.669872]  [<ffffffff81433a25>] do_async_page_fault+0x35/0x90
[    3.669872]  [<ffffffff8142fae5>] async_page_fault+0x25/0x30
[    3.669872]  [<ffffffff81094674>] ? task_active_pid_ns+0x34/0x50
[    3.669872]  [<ffffffff81083bcc>] ? do_notify_parent+0x18c/0x460
[    3.669872]  [<ffffffff81083b74>] ? do_notify_parent+0x134/0x460
[    3.669872]  [<ffffffff81070773>] ? do_exit+0xab3/0xde0
[    3.669872]  [<ffffffff810709cb>] do_exit+0xd0b/0xde0
[    3.669872]  [<ffffffff8143096b>] oops_end+0x10b/0x150
[    3.669872]  [<ffffffff8141e04d>] no_context+0x3cb/0x3da
[    3.669872]  [<ffffffff8141e310>] __bad_area_nosemaphore+0x2b4/0x2c3
[    3.669872]  [<ffffffff8141e332>] bad_area_nosemaphore+0x13/0x15
[    3.669872]  [<ffffffff814343b1>] do_page_fault+0x271/0xc60
[    3.669872]  [<ffffffff8127bb00>] ? sprintf+0x40/0x50
[    3.669872]  [<ffffffff81352649>] ? io_serial_in+0x9/0x20
[    3.669872]  [<ffffffff81352d83>] ? wait_for_xmitr+0x53/0x100
[    3.669872]  [<ffffffff81352669>] ? io_serial_out+0x9/0x20
[    3.669872]  [<ffffffff8127791a>] ? put_dec+0x9a/0xc0
[    3.669872]  [<ffffffff81279c17>] ? number.isra.2+0x617/0x650
[    3.669872]  [<ffffffff81433a25>] do_async_page_fault+0x35/0x90
[    3.669872]  [<ffffffff8142fae5>] async_page_fault+0x25/0x30
[    3.669872]  [<ffffffff81433ce5>] ? vmalloc_fault+0x265/0x40b
[    3.669872]  [<ffffffff81433bd6>] ? vmalloc_fault+0x156/0x40b
[    3.669872]  [<ffffffff814343c2>] do_page_fault+0x282/0xc60
[    3.669872]  [<ffffffff81352d83>] ? wait_for_xmitr+0x53/0x100
[    3.669872]  [<ffffffff81294621>] ? do_raw_spin_unlock+0x131/0x160
[    3.669872]  [<ffffffff81294621>] ? do_raw_spin_unlock+0x131/0x160
[    3.669872]  [<ffffffff81433a25>] do_async_page_fault+0x35/0x90
[    3.669872]  [<ffffffff8142fae5>] async_page_fault+0x25/0x30
[    3.669872]  [<ffffffff81051c6d>] ? hpet_readl+0xd/0x20
[    3.669872]  [<ffffffff81026aa2>] tsc_read_refs+0xc2/0xe0
[    3.669872]  [<ffffffff8108e6e1>] ? process_one_work+0x371/0x990
[    3.669872]  [<ffffffff81026b25>] tsc_refine_calibration_work+0x65/0x250
[    3.669872]  [<ffffffff8108e7e7>] process_one_work+0x477/0x990
[    3.669872]  [<ffffffff8108e6e1>] ? process_one_work+0x371/0x990
[    3.669872]  [<ffffffff810670c6>] ? warn_slowpath_fmt+0x46/0x50
[    3.669872]  [<ffffffff81026ac0>] ? tsc_read_refs+0xe0/0xe0
[    3.669872]  [<ffffffff81092165>] worker_thread+0x505/0x7e0
[    3.669872]  [<ffffffff81091c60>] ? manage_workers.isra.14+0x3b0/0x3b0
[    3.669872]  [<ffffffff81091c60>] ? manage_workers.isra.14+0x3b0/0x3b0
[    3.669872]  [<ffffffff8109fa9a>] kthread+0xba/0xc0
[    3.669872]  [<ffffffff810b2b29>] ? schedule_tail+0x29/0x110
[    3.669872]  [<ffffffff8143bb84>] kernel_thread_helper+0x4/0x10
[    3.669872]  [<ffffffff8109f9e0>] ? __init_kthread_worker+0x70/0x70
[    3.669872]  [<ffffffff8143bb80>] ? gs_change+0x13/0x13
[    3.669872] Code: c7 c7 68 ea 66 81 48 83 05 4c ba 96 00 01 e8 67 71 fc ff 5b 41 5c 5d c3 66 90 55 48 89 e5 e8 47 aa 39 00 48 8b 87 08 04 00 00 5d <48> 8b 40 f8 c3 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 e8 27 
[    3.669872] RIP  [<ffffffff8109fec1>] kthread_data+0x11/0x20
[    3.669872]  RSP <ffff88000cc2d120>
[    3.669872] CR2: fffffffffffffff8
[    3.669872] ---[ end trace f331497cdb6a1168 ]---
[    3.669872] Fixing recursive fault but reboot is needed!
[    3.669872] BUG: scheduling while atomic: kworker/0:1/17/0x00000005
[    3.669872] INFO: lockdep is turned off.
[    3.669872] Modules linked in:
[    3.669872] Pid: 17, comm: kworker/0:1 Tainted: G      D W    3.6.0-rc3-00182-gc2865bb #44
[    3.669872] Call Trace:
[    3.669872]  [<ffffffff810af645>] __schedule_bug+0x95/0xb0
[    3.669872]  [<ffffffff8142c9fe>] __schedule+0xde/0xc30
[    3.669872]  [<ffffffff81069eab>] ? console_unlock+0x3ab/0x620
[    3.669872]  [<ffffffff8141eb37>] ? printk+0x4d/0x4f
[    3.669872]  [<ffffffff8142d727>] schedule+0x97/0xa0
[    3.669872]  [<ffffffff81070598>] do_exit+0x8d8/0xde0
[    3.669872]  [<ffffffff8106c468>] ? kmsg_dump+0xa8/0x160
[    3.669872]  [<ffffffff8106c3f8>] ? kmsg_dump+0x38/0x160
[    3.669872]  [<ffffffff8143096b>] oops_end+0x10b/0x150
[    3.669872]  [<ffffffff8141e04d>] no_context+0x3cb/0x3da
[    3.669872]  [<ffffffff8141e310>] __bad_area_nosemaphore+0x2b4/0x2c3
[    3.669872]  [<ffffffff8143bb80>] ? gs_change+0x13/0x13
[    3.669872]  [<ffffffff8141e332>] bad_area_nosemaphore+0x13/0x15
[    3.669872]  [<ffffffff814343b1>] do_page_fault+0x271/0xc60
[    3.669872]  [<ffffffff8109b148>] ? __kernel_text_address+0x48/0xa0
[    3.669872]  [<ffffffff810210ab>] ? print_context_stack+0x9b/0x150
[    3.669872]  [<ffffffff810545d5>] ? pvclock_clocksource_read+0x125/0x150
[    3.669872]  [<ffffffff81433a25>] do_async_page_fault+0x35/0x90
[    3.669872]  [<ffffffff8142fae5>] async_page_fault+0x25/0x30
[    3.669872]  [<ffffffff8109fec1>] ? kthread_data+0x11/0x20
[    3.669872]  [<ffffffff81093c15>] ? wq_worker_sleeping+0x25/0xe0
[    3.669872]  [<ffffffff8142d363>] __schedule+0xa43/0xc30
[    3.669872]  [<ffffffff81069eab>] ? console_unlock+0x3ab/0x620
[    3.669872]  [<ffffffff8141eb37>] ? printk+0x4d/0x4f
[    3.669872]  [<ffffffff8142d727>] schedule+0x97/0xa0
[    3.669872]  [<ffffffff81070598>] do_exit+0x8d8/0xde0
[    3.669872]  [<ffffffff8106c468>] ? kmsg_dump+0xa8/0x160
[    3.669872]  [<ffffffff8106c3f8>] ? kmsg_dump+0x38/0x160
[    3.669872]  [<ffffffff8143096b>] oops_end+0x10b/0x150
[    3.669872]  [<ffffffff8141e04d>] no_context+0x3cb/0x3da
[    3.669872]  [<ffffffff8141e310>] __bad_area_nosemaphore+0x2b4/0x2c3
[    3.669872]  [<ffffffff8127791a>] ? put_dec+0x9a/0xc0
[    3.669872]  [<ffffffff81277ba3>] ? format_decode+0x263/0x6b0
[    3.669872]  [<ffffffff8141e332>] bad_area_nosemaphore+0x13/0x15
[    3.669872]  [<ffffffff814343b1>] do_page_fault+0x271/0xc60
[    3.669872]  [<ffffffff8127bb00>] ? sprintf+0x40/0x50
[    3.669872]  [<ffffffff81352649>] ? io_serial_in+0x9/0x20
[    3.669872]  [<ffffffff81352d83>] ? wait_for_xmitr+0x53/0x100
[    3.669872]  [<ffffffff81352669>] ? io_serial_out+0x9/0x20
[    3.669872]  [<ffffffff81294621>] ? do_raw_spin_unlock+0x131/0x160
[    3.669872]  [<ffffffff81433a25>] do_async_page_fault+0x35/0x90
[    3.669872]  [<ffffffff8142fae5>] async_page_fault+0x25/0x30
[    3.669872]  [<ffffffff81094674>] ? task_active_pid_ns+0x34/0x50
[    3.669872]  [<ffffffff81083bcc>] ? do_notify_parent+0x18c/0x460
[    3.669872]  [<ffffffff81083b74>] ? do_notify_parent+0x134/0x460
[    3.669872]  [<ffffffff81070773>] ? do_exit+0xab3/0xde0
[    3.669872]  [<ffffffff810709cb>] do_exit+0xd0b/0xde0
[    3.669872]  [<ffffffff8143096b>] oops_end+0x10b/0x150
[    3.669872]  [<ffffffff8141e04d>] no_context+0x3cb/0x3da
[    3.669872]  [<ffffffff8141e310>] __bad_area_nosemaphore+0x2b4/0x2c3
[    3.669872]  [<ffffffff8141e332>] bad_area_nosemaphore+0x13/0x15
[    3.669872]  [<ffffffff814343b1>] do_page_fault+0x271/0xc60
[    3.669872]  [<ffffffff8127bb00>] ? sprintf+0x40/0x50
[    3.669872]  [<ffffffff81352649>] ? io_serial_in+0x9/0x20
[    3.669872]  [<ffffffff81352d83>] ? wait_for_xmitr+0x53/0x100
[    3.669872]  [<ffffffff81352669>] ? io_serial_out+0x9/0x20
[    3.669872]  [<ffffffff8127791a>] ? put_dec+0x9a/0xc0
[    3.669872]  [<ffffffff81279c17>] ? number.isra.2+0x617/0x650
[    3.669872]  [<ffffffff81433a25>] do_async_page_fault+0x35/0x90
[    3.669872]  [<ffffffff8142fae5>] async_page_fault+0x25/0x30
[    3.669872]  [<ffffffff81433ce5>] ? vmalloc_fault+0x265/0x40b
[    3.669872]  [<ffffffff81433bd6>] ? vmalloc_fault+0x156/0x40b
[    3.669872]  [<ffffffff814343c2>] do_page_fault+0x282/0xc60
[    3.669872]  [<ffffffff81352d83>] ? wait_for_xmitr+0x53/0x100
[    3.669872]  [<ffffffff81294621>] ? do_raw_spin_unlock+0x131/0x160
[    3.669872]  [<ffffffff81294621>] ? do_raw_spin_unlock+0x131/0x160
[    3.669872]  [<ffffffff81433a25>] do_async_page_fault+0x35/0x90
[    3.669872]  [<ffffffff8142fae5>] async_page_fault+0x25/0x30
[    3.669872]  [<ffffffff81051c6d>] ? hpet_readl+0xd/0x20
[    3.669872]  [<ffffffff81026aa2>] tsc_read_refs+0xc2/0xe0
[    3.669872]  [<ffffffff8108e6e1>] ? process_one_work+0x371/0x990
[    3.669872]  [<ffffffff81026b25>] tsc_refine_calibration_work+0x65/0x250
[    3.669872]  [<ffffffff8108e7e7>] process_one_work+0x477/0x990
[    3.669872]  [<ffffffff8108e6e1>] ? process_one_work+0x371/0x990
[    3.669872]  [<ffffffff810670c6>] ? warn_slowpath_fmt+0x46/0x50
[    3.669872]  [<ffffffff81026ac0>] ? tsc_read_refs+0xe0/0xe0
[    3.669872]  [<ffffffff81092165>] worker_thread+0x505/0x7e0
[    3.669872]  [<ffffffff81091c60>] ? manage_workers.isra.14+0x3b0/0x3b0
[    3.669872]  [<ffffffff81091c60>] ? manage_workers.isra.14+0x3b0/0x3b0
[    3.669872]  [<ffffffff8109fa9a>] kthread+0xba/0xc0
[    3.669872]  [<ffffffff810b2b29>] ? schedule_tail+0x29/0x110
[    3.669872]  [<ffffffff8143bb84>] kernel_thread_helper+0x4/0x10
[    3.669872]  [<ffffffff8109f9e0>] ? __init_kthread_worker+0x70/0x70
[    3.669872]  [<ffffffff8143bb80>] ? gs_change+0x13/0x13

--c3bfwLpm8qysLVxt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.6.0-rc3-00182-gc2865bb"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.6.0-rc3 Kernel Configuration
#
CONFIG_64BIT=y
# CONFIG_X86_32 is not set
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_NEED_SG_DMA_LENGTH=y
# CONFIG_GENERIC_ISA_DMA is not set
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_GENERIC_GPIO=y
# CONFIG_ARCH_MAY_HAVE_PC_FDC is not set
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_ARCH_HAS_CPU_AUTOPROBE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ZONE_DMA32=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
CONFIG_ARCH_CPU_PROBE_RELEASE=y
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_HAVE_IRQ_WORK=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
# CONFIG_KERNEL_GZIP is not set
# CONFIG_KERNEL_BZIP2 is not set
CONFIG_KERNEL_LZMA=y
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
# CONFIG_POSIX_MQUEUE is not set
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_FHANDLE is not set
# CONFIG_TASKSTATS is not set
# CONFIG_AUDIT is not set
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_GENERIC_IRQ_CHIP=y
CONFIG_IRQ_DOMAIN=y
# CONFIG_IRQ_DOMAIN_DEBUG is not set
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_DATA=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y

#
# Timers subsystem
#
# CONFIG_NO_HZ is not set
# CONFIG_HIGH_RES_TIMERS is not set

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
CONFIG_TREE_RCU_TRACE=y
CONFIG_IKCONFIG=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_CHECKPOINT_RESTORE=y
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
# CONFIG_SCHED_AUTOGROUP is not set
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
# CONFIG_RD_LZO is not set
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_ANON_INODES=y
CONFIG_EXPERT=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
# CONFIG_BASE_FULL is not set
CONFIG_FUTEX=y
# CONFIG_EPOLL is not set
CONFIG_SIGNALFD=y
# CONFIG_TIMERFD is not set
# CONFIG_EVENTFD is not set
CONFIG_SHMEM=y
# CONFIG_AIO is not set
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
# CONFIG_SLUB_DEBUG is not set
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
CONFIG_TRACEPOINTS=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_KPROBES=y
# CONFIG_JUMP_LABEL is not set
CONFIG_OPTPROBES=y
CONFIG_UPROBES=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_KRETPROBES=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=1
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
# CONFIG_MODULE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
# CONFIG_BLK_DEV_INTEGRITY is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
CONFIG_OSF_PARTITION=y
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
# CONFIG_MAC_PARTITION is not set
CONFIG_MSDOS_PARTITION=y
# CONFIG_BSD_DISKLABEL is not set
# CONFIG_MINIX_SUBPARTITION is not set
CONFIG_SOLARIS_X86_PARTITION=y
# CONFIG_UNIXWARE_DISKLABEL is not set
# CONFIG_LDM_PARTITION is not set
CONFIG_SGI_PARTITION=y
CONFIG_ULTRIX_PARTITION=y
# CONFIG_SUN_PARTITION is not set
# CONFIG_KARMA_PARTITION is not set
# CONFIG_EFI_PARTITION is not set
CONFIG_SYSV68_PARTITION=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_DEADLINE is not set
CONFIG_IOSCHED_CFQ=m
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
# CONFIG_INLINE_SPIN_TRYLOCK is not set
# CONFIG_INLINE_SPIN_TRYLOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK is not set
# CONFIG_INLINE_SPIN_LOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK_IRQ is not set
# CONFIG_INLINE_SPIN_LOCK_IRQSAVE is not set
CONFIG_UNINLINE_SPIN_UNLOCK=y
# CONFIG_INLINE_SPIN_UNLOCK_BH is not set
# CONFIG_INLINE_SPIN_UNLOCK_IRQ is not set
# CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_READ_TRYLOCK is not set
# CONFIG_INLINE_READ_LOCK is not set
# CONFIG_INLINE_READ_LOCK_BH is not set
# CONFIG_INLINE_READ_LOCK_IRQ is not set
# CONFIG_INLINE_READ_LOCK_IRQSAVE is not set
# CONFIG_INLINE_READ_UNLOCK is not set
# CONFIG_INLINE_READ_UNLOCK_BH is not set
# CONFIG_INLINE_READ_UNLOCK_IRQ is not set
# CONFIG_INLINE_READ_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_WRITE_TRYLOCK is not set
# CONFIG_INLINE_WRITE_LOCK is not set
# CONFIG_INLINE_WRITE_LOCK_BH is not set
# CONFIG_INLINE_WRITE_LOCK_IRQ is not set
# CONFIG_INLINE_WRITE_LOCK_IRQSAVE is not set
# CONFIG_INLINE_WRITE_UNLOCK is not set
# CONFIG_INLINE_WRITE_UNLOCK_BH is not set
# CONFIG_INLINE_WRITE_UNLOCK_IRQ is not set
# CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE is not set
# CONFIG_MUTEX_SPIN_ON_OWNER is not set
CONFIG_FREEZER=y

#
# Processor type and features
#
# CONFIG_ZONE_DMA is not set
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_EXTENDED_PLATFORM=y
CONFIG_X86_VSMP=y
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_PARAVIRT_GUEST=y
CONFIG_PARAVIRT_TIME_ACCOUNTING=y
CONFIG_XEN=y
CONFIG_XEN_DOM0=y
CONFIG_XEN_PRIVILEGED_GUEST=y
CONFIG_XEN_PVHVM=y
CONFIG_XEN_MAX_DOMAIN_MEMORY=500
CONFIG_XEN_SAVE_RESTORE=y
# CONFIG_XEN_DEBUG_FS is not set
CONFIG_KVM_CLOCK=y
CONFIG_KVM_GUEST=y
CONFIG_PARAVIRT=y
CONFIG_PARAVIRT_SPINLOCKS=y
CONFIG_PARAVIRT_CLOCK=y
# CONFIG_PARAVIRT_DEBUG is not set
CONFIG_NO_BOOTMEM=y
# CONFIG_MEMTEST is not set
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_GENERIC_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=12
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_XADD=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
# CONFIG_DMI is not set
# CONFIG_GART_IOMMU is not set
# CONFIG_CALGARY_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_MAXSMP=y
CONFIG_NR_CPUS=4096
# CONFIG_SCHED_SMT is not set
# CONFIG_SCHED_MC is not set
# CONFIG_IRQ_TIME_ACCOUNTING is not set
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
# CONFIG_X86_MCE_INTEL is not set
# CONFIG_X86_MCE_AMD is not set
# CONFIG_X86_MCE_INJECT is not set
# CONFIG_I8K is not set
CONFIG_MICROCODE=m
CONFIG_MICROCODE_INTEL=y
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=m
# CONFIG_X86_CPUID is not set
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
# CONFIG_NUMA is not set
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_MEMORY_PROBE=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_MEMORY_ISOLATION=y
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
# CONFIG_MEMORY_HOTREMOVE is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=0
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
CONFIG_TRANSPARENT_HUGEPAGE=y
# CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS is not set
CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_CLEANCACHE=y
CONFIG_FRONTSWAP=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
# CONFIG_CC_STACKPROTECTOR is not set
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
# CONFIG_SCHED_HRTICK is not set
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATE_CALLBACKS=y
# CONFIG_HIBERNATION is not set
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_AUTOSLEEP=y
CONFIG_PM_WAKELOCKS=y
CONFIG_PM_WAKELOCKS_LIMIT=100
# CONFIG_PM_WAKELOCKS_GC is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
CONFIG_PM_ADVANCED_DEBUG=y
CONFIG_PM_SLEEP_DEBUG=y
# CONFIG_PM_TRACE_RTC is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_HOTPLUG_MEMORY is not set
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_BGRT is not set
# CONFIG_ACPI_APEI is not set
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=m
CONFIG_CPU_FREQ_STAT=m
CONFIG_CPU_FREQ_STAT_DETAILS=y
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_GOV_USERSPACE=m
# CONFIG_CPU_FREQ_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set

#
# x86 CPU frequency scaling drivers
#
# CONFIG_X86_PCC_CPUFREQ is not set
# CONFIG_X86_ACPI_CPUFREQ is not set
# CONFIG_X86_POWERNOW_K8 is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_P4_CLOCKMOD is not set

#
# shared options
#
# CONFIG_X86_SPEEDSTEP_LIB is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
# CONFIG_INTEL_IDLE is not set

#
# Memory power savings
#
CONFIG_I7300_IDLE_IOAT_CHANNEL=y
CONFIG_I7300_IDLE=m

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
# CONFIG_PCI_MMCONFIG is not set
CONFIG_PCI_XEN=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCI_CNB20LE_QUIRK=y
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=m
# CONFIG_PCIEAER is not set
CONFIG_PCIEASPM=y
CONFIG_PCIEASPM_DEBUG=y
# CONFIG_PCIEASPM_DEFAULT is not set
# CONFIG_PCIEASPM_POWERSAVE is not set
CONFIG_PCIEASPM_PERFORMANCE=y
CONFIG_PCIE_PME=y
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
CONFIG_PCI_DEBUG=y
CONFIG_PCI_REALLOC_ENABLE_AUTO=y
CONFIG_PCI_STUB=m
CONFIG_XEN_PCIDEV_FRONTEND=m
# CONFIG_HT_IRQ is not set
CONFIG_PCI_ATS=y
CONFIG_PCI_IOV=y
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y
# CONFIG_ISA_DMA_API is not set
CONFIG_AMD_NB=y
# CONFIG_PCCARD is not set
CONFIG_HOTPLUG_PCI=m
# CONFIG_HOTPLUG_PCI_FAKE is not set
# CONFIG_HOTPLUG_PCI_ACPI is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
# CONFIG_HOTPLUG_PCI_SHPC is not set
CONFIG_RAPIDIO=y
# CONFIG_RAPIDIO_TSI721 is not set
CONFIG_RAPIDIO_DISC_TIMEOUT=30
CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS=y
# CONFIG_RAPIDIO_DMA_ENGINE is not set
# CONFIG_RAPIDIO_DEBUG is not set
# CONFIG_RAPIDIO_TSI57X is not set
# CONFIG_RAPIDIO_CPS_XX is not set
CONFIG_RAPIDIO_TSI568=y
CONFIG_RAPIDIO_CPS_GEN2=y
# CONFIG_RAPIDIO_TSI500 is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=m
# CONFIG_IA32_EMULATION is not set
# CONFIG_COMPAT_FOR_U64_ALIGNMENT is not set
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_NET=y

#
# Networking options
#
# CONFIG_PACKET is not set
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
# CONFIG_NET_KEY is not set
# CONFIG_INET is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_WAN_ROUTER is not set
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
# CONFIG_DNS_RESOLVER is not set
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
CONFIG_BQL=y
# CONFIG_BPF_JIT is not set

#
# Network testing
#
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
CONFIG_WIRELESS=y
# CONFIG_CFG80211 is not set
# CONFIG_LIB80211 is not set

#
# CFG80211 needs to be enabled for MAC80211
#
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
# CONFIG_RFKILL_REGULATOR is not set
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
# CONFIG_NFC is not set
CONFIG_HAVE_BPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
# CONFIG_DEVTMPFS is not set
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=m
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=m
CONFIG_REGMAP_SPI=y
# CONFIG_DMA_SHARED_BUFFER is not set
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_PCIESSD_MTIP32XX=m
# CONFIG_BLK_CPQ_DA is not set
CONFIG_BLK_CPQ_CISS_DA=m
# CONFIG_BLK_DEV_DAC960 is not set
CONFIG_BLK_DEV_UMEM=m
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
CONFIG_BLK_DEV_CRYPTOLOOP=m

#
# DRBD disabled because PROC_FS, INET or CONNECTOR not selected
#
# CONFIG_BLK_DEV_NBD is not set
CONFIG_BLK_DEV_NVME=m
CONFIG_BLK_DEV_SX8=m
# CONFIG_BLK_DEV_RAM is not set
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
CONFIG_CDROM_PKTCDVD_WCACHE=y
# CONFIG_ATA_OVER_ETH is not set
CONFIG_XEN_BLKDEV_FRONTEND=m
# CONFIG_XEN_BLKDEV_BACKEND is not set
# CONFIG_VIRTIO_BLK is not set
CONFIG_BLK_DEV_HD=y

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
CONFIG_AD525X_DPOT=m
# CONFIG_AD525X_DPOT_I2C is not set
CONFIG_AD525X_DPOT_SPI=m
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_INTEL_MID_PTI is not set
# CONFIG_SGI_IOC4 is not set
CONFIG_TIFM_CORE=m
# CONFIG_TIFM_7XX1 is not set
CONFIG_ICS932S401=m
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_CS5535_MFGPT is not set
# CONFIG_HP_ILO is not set
CONFIG_APDS9802ALS=m
# CONFIG_ISL29003 is not set
# CONFIG_ISL29020 is not set
CONFIG_SENSORS_TSL2550=m
# CONFIG_SENSORS_BH1780 is not set
# CONFIG_SENSORS_BH1770 is not set
CONFIG_SENSORS_APDS990X=m
CONFIG_HMC6352=m
# CONFIG_DS1682 is not set
CONFIG_TI_DAC7512=m
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
CONFIG_BMP085_I2C=m
CONFIG_BMP085_SPI=m
CONFIG_PCH_PHUB=m
CONFIG_USB_SWITCH_FSA9480=m
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_AT25 is not set
# CONFIG_EEPROM_LEGACY is not set
# CONFIG_EEPROM_MAX6875 is not set
# CONFIG_EEPROM_93CX6 is not set
CONFIG_EEPROM_93XX46=m
CONFIG_CB710_CORE=m
CONFIG_CB710_DEBUG=y
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=m
# CONFIG_INTEL_MEI is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=m
CONFIG_RAID_ATTRS=m
CONFIG_SCSI=m
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
# CONFIG_SCSI_NETLINK is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
# CONFIG_BLK_DEV_SD is not set
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
# CONFIG_BLK_DEV_SR is not set
# CONFIG_CHR_DEV_SG is not set
# CONFIG_CHR_DEV_SCH is not set
# CONFIG_SCSI_MULTI_LUN is not set
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SCAN_ASYNC is not set

#
# SCSI Transports
#
# CONFIG_SCSI_SPI_ATTRS is not set
# CONFIG_SCSI_FC_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
# CONFIG_SCSI_SAS_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set
CONFIG_SCSI_SRP_ATTRS=m
# CONFIG_SCSI_LOWLEVEL is not set
# CONFIG_SCSI_DH is not set
CONFIG_SCSI_OSD_INITIATOR=m
# CONFIG_SCSI_OSD_ULD is not set
CONFIG_SCSI_OSD_DPRINT_SENSE=1
# CONFIG_SCSI_OSD_DEBUG is not set
CONFIG_ATA=m
# CONFIG_ATA_NONSTANDARD is not set
# CONFIG_ATA_VERBOSE_ERROR is not set
CONFIG_ATA_ACPI=y
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=m
CONFIG_SATA_AHCI_PLATFORM=m
# CONFIG_SATA_INIC162X is not set
# CONFIG_SATA_ACARD_AHCI is not set
CONFIG_SATA_SIL24=m
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
CONFIG_PDC_ADMA=m
CONFIG_SATA_QSTOR=m
# CONFIG_SATA_SX4 is not set
# CONFIG_ATA_BMDMA is not set

#
# PIO-only SFF controllers
#
CONFIG_PATA_CMD640_PCI=m
# CONFIG_PATA_MPIIX is not set
CONFIG_PATA_NS87410=m
CONFIG_PATA_OPTI=m
CONFIG_PATA_PLATFORM=m
# CONFIG_PATA_RZ1000 is not set

#
# Generic fallback / legacy drivers
#
CONFIG_PATA_LEGACY=m
# CONFIG_MD is not set
CONFIG_TARGET_CORE=m
# CONFIG_TCM_IBLOCK is not set
CONFIG_TCM_FILEIO=m
CONFIG_TCM_PSCSI=m
CONFIG_LOOPBACK_TARGET=m
# CONFIG_ISCSI_TARGET is not set
# CONFIG_SBP_TARGET is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=m
# CONFIG_FIREWIRE_OHCI is not set
CONFIG_FIREWIRE_SBP2=m
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
# CONFIG_NETDEVICES is not set
# CONFIG_ISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
CONFIG_INPUT_POLLDEV=m
# CONFIG_INPUT_SPARSEKMAP is not set
CONFIG_INPUT_MATRIXKMAP=m

#
# Userland interfaces
#
# CONFIG_INPUT_MOUSEDEV is not set
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_EVDEV is not set
CONFIG_INPUT_EVBUG=m

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
CONFIG_KEYBOARD_LKKBD=m
CONFIG_KEYBOARD_GPIO=m
CONFIG_KEYBOARD_GPIO_POLLED=m
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
CONFIG_KEYBOARD_MATRIX=m
CONFIG_KEYBOARD_LM8323=m
CONFIG_KEYBOARD_LM8333=m
CONFIG_KEYBOARD_MAX7359=m
# CONFIG_KEYBOARD_MCS is not set
CONFIG_KEYBOARD_MPR121=m
CONFIG_KEYBOARD_NEWTON=m
# CONFIG_KEYBOARD_OPENCORES is not set
CONFIG_KEYBOARD_STOWAWAY=m
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_OMAP4 is not set
CONFIG_KEYBOARD_XTKBD=m
# CONFIG_INPUT_MOUSE is not set
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=m
CONFIG_JOYSTICK_A3D=m
CONFIG_JOYSTICK_ADI=m
CONFIG_JOYSTICK_COBRA=m
CONFIG_JOYSTICK_GF2K=m
# CONFIG_JOYSTICK_GRIP is not set
CONFIG_JOYSTICK_GRIP_MP=m
CONFIG_JOYSTICK_GUILLEMOT=m
CONFIG_JOYSTICK_INTERACT=m
CONFIG_JOYSTICK_SIDEWINDER=m
# CONFIG_JOYSTICK_TMDC is not set
# CONFIG_JOYSTICK_IFORCE is not set
# CONFIG_JOYSTICK_WARRIOR is not set
# CONFIG_JOYSTICK_MAGELLAN is not set
CONFIG_JOYSTICK_SPACEORB=m
# CONFIG_JOYSTICK_SPACEBALL is not set
CONFIG_JOYSTICK_STINGER=m
CONFIG_JOYSTICK_TWIDJOY=m
# CONFIG_JOYSTICK_ZHENHUA is not set
# CONFIG_JOYSTICK_AS5011 is not set
# CONFIG_JOYSTICK_JOYDUMP is not set
# CONFIG_JOYSTICK_XPAD is not set
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
# CONFIG_TABLET_USB_AIPTEK is not set
# CONFIG_TABLET_USB_HANWANG is not set
# CONFIG_TABLET_USB_KBTAB is not set
# CONFIG_TABLET_USB_WACOM is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
CONFIG_INPUT_AD714X=m
CONFIG_INPUT_AD714X_I2C=m
# CONFIG_INPUT_AD714X_SPI is not set
# CONFIG_INPUT_BMA150 is not set
CONFIG_INPUT_PCSPKR=m
# CONFIG_INPUT_MC13783_PWRBUTTON is not set
CONFIG_INPUT_MMA8450=m
# CONFIG_INPUT_MPU3050 is not set
CONFIG_INPUT_APANEL=m
CONFIG_INPUT_GP2A=m
# CONFIG_INPUT_GPIO_TILT_POLLED is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
CONFIG_INPUT_KXTJ9=m
# CONFIG_INPUT_KXTJ9_POLLED_MODE is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
# CONFIG_INPUT_UINPUT is not set
CONFIG_INPUT_PCF8574=m
CONFIG_INPUT_GPIO_ROTARY_ENCODER=m
# CONFIG_INPUT_WM831X_ON is not set
CONFIG_INPUT_ADXL34X=m
CONFIG_INPUT_ADXL34X_I2C=m
CONFIG_INPUT_ADXL34X_SPI=m
# CONFIG_INPUT_CMA3000 is not set
CONFIG_INPUT_XEN_KBDDEV_FRONTEND=m

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
# CONFIG_SERIO_SERPORT is not set
CONFIG_SERIO_CT82C710=m
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_SERIO_PS2MULT is not set
CONFIG_GAMEPORT=m
CONFIG_GAMEPORT_NS558=m
# CONFIG_GAMEPORT_L4 is not set
# CONFIG_GAMEPORT_EMU10K1 is not set
CONFIG_GAMEPORT_FM801=m

#
# Character devices
#
# CONFIG_VT is not set
# CONFIG_UNIX98_PTYS is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_SERIAL_NONSTANDARD is not set
CONFIG_NOZOMI=m
# CONFIG_N_GSM is not set
CONFIG_TRACE_ROUTER=m
CONFIG_TRACE_SINK=m
CONFIG_DEVKMEM=y

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=m
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_MAX3100=m
CONFIG_SERIAL_MAX3107=m
CONFIG_SERIAL_MFD_HSU=m
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_SERIAL_TIMBERDALE=m
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
CONFIG_SERIAL_ALTERA_UART=m
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
# CONFIG_SERIAL_IFX6X60 is not set
# CONFIG_SERIAL_PCH_UART is not set
CONFIG_SERIAL_XILINX_PS_UART=m
CONFIG_TTY_PRINTK=y
CONFIG_HVC_DRIVER=y
CONFIG_HVC_IRQ=y
CONFIG_HVC_XEN=y
# CONFIG_HVC_XEN_FRONTEND is not set
CONFIG_VIRTIO_CONSOLE=m
# CONFIG_IPMI_HANDLER is not set
# CONFIG_HW_RANDOM is not set
# CONFIG_NVRAM is not set
# CONFIG_RTC is not set
# CONFIG_GEN_RTC is not set
CONFIG_R3964=m
CONFIG_APPLICOM=m
# CONFIG_MWAVE is not set
CONFIG_RAW_DRIVER=m
CONFIG_MAX_RAW_DEVS=256
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
# CONFIG_I2C_CHARDEV is not set
# CONFIG_I2C_MUX is not set
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=m
CONFIG_I2C_ALGOBIT=m

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
CONFIG_I2C_ALI1535=m
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
CONFIG_I2C_AMD756=m
CONFIG_I2C_AMD756_S4882=m
CONFIG_I2C_AMD8111=m
# CONFIG_I2C_I801 is not set
CONFIG_I2C_ISCH=m
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
CONFIG_I2C_SIS5595=m
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
CONFIG_I2C_VIA=m
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_DESIGNWARE_PCI=m
CONFIG_I2C_EG20T=m
# CONFIG_I2C_GPIO is not set
# CONFIG_I2C_INTEL_MID is not set
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=m
CONFIG_I2C_XILINX=m

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT_LIGHT=m
# CONFIG_I2C_TAOS_EVM is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_STUB is not set
# CONFIG_I2C_DEBUG_CORE is not set
CONFIG_I2C_DEBUG_ALGO=y
# CONFIG_I2C_DEBUG_BUS is not set
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
CONFIG_SPI_ALTERA=m
CONFIG_SPI_BITBANG=m
CONFIG_SPI_GPIO=m
CONFIG_SPI_OC_TINY=m
# CONFIG_SPI_PXA2XX_PCI is not set
# CONFIG_SPI_TOPCLIFF_PCH is not set
# CONFIG_SPI_XCOMM is not set
CONFIG_SPI_XILINX=m
# CONFIG_SPI_DESIGNWARE is not set

#
# SPI Protocol Masters
#
CONFIG_SPI_SPIDEV=m
# CONFIG_SPI_TLE62X0 is not set
CONFIG_HSI=m
CONFIG_HSI_BOARDINFO=y

#
# HSI clients
#
# CONFIG_HSI_CHAR is not set

#
# PPS support
#
# CONFIG_PPS is not set

#
# PPS generators support
#

#
# PTP clock support
#

#
# Enable Device Drivers -> PPS to see the PTP clock options.
#
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_DEBUG_GPIO=y
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_GENERIC=m
CONFIG_GPIO_MAX730X=m

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=m
CONFIG_GPIO_IT8761E=m
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
CONFIG_GPIO_VX855=m

#
# I2C GPIO expanders:
#
CONFIG_GPIO_MAX7300=m
CONFIG_GPIO_MAX732X=m
CONFIG_GPIO_PCA953X=m
# CONFIG_GPIO_PCF857X is not set
# CONFIG_GPIO_TPS65912 is not set
# CONFIG_GPIO_WM831X is not set
CONFIG_GPIO_ADP5588=m

#
# PCI GPIO expanders:
#
CONFIG_GPIO_CS5535=m
CONFIG_GPIO_BT8XX=m
# CONFIG_GPIO_AMD8111 is not set
CONFIG_GPIO_LANGWELL=y
CONFIG_GPIO_PCH=m
CONFIG_GPIO_ML_IOH=m
# CONFIG_GPIO_RDC321X is not set

#
# SPI GPIO expanders:
#
# CONFIG_GPIO_MAX7301 is not set
# CONFIG_GPIO_MCP23S08 is not set
# CONFIG_GPIO_MC33880 is not set
# CONFIG_GPIO_74X164 is not set

#
# AC97 GPIO expanders:
#

#
# MODULbus GPIO expanders:
#
CONFIG_GPIO_JANZ_TTL=m
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
CONFIG_PDA_POWER=m
# CONFIG_WM831X_BACKUP is not set
CONFIG_WM831X_POWER=m
CONFIG_TEST_POWER=m
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
CONFIG_BATTERY_DS2782=m
CONFIG_BATTERY_SBS=m
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_MAX17040 is not set
CONFIG_BATTERY_MAX17042=m
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_GPIO is not set
CONFIG_CHARGER_SMB347=m
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=m
CONFIG_HWMON_VID=m
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_AD7314=m
# CONFIG_SENSORS_AD7414 is not set
CONFIG_SENSORS_AD7418=m
# CONFIG_SENSORS_ADCXX is not set
CONFIG_SENSORS_ADM1021=m
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
CONFIG_SENSORS_ADM1029=m
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_ADT7411 is not set
CONFIG_SENSORS_ADT7462=m
CONFIG_SENSORS_ADT7470=m
# CONFIG_SENSORS_ADT7475 is not set
CONFIG_SENSORS_ASC7621=m
CONFIG_SENSORS_K8TEMP=m
# CONFIG_SENSORS_K10TEMP is not set
CONFIG_SENSORS_FAM15H_POWER=m
# CONFIG_SENSORS_ASB100 is not set
CONFIG_SENSORS_ATXP1=m
# CONFIG_SENSORS_DS620 is not set
CONFIG_SENSORS_DS1621=m
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_G760A is not set
# CONFIG_SENSORS_GL518SM is not set
CONFIG_SENSORS_GL520SM=m
CONFIG_SENSORS_GPIO_FAN=m
# CONFIG_SENSORS_HIH6130 is not set
CONFIG_SENSORS_CORETEMP=m
CONFIG_SENSORS_IT87=m
# CONFIG_SENSORS_JC42 is not set
# CONFIG_SENSORS_LINEAGE is not set
CONFIG_SENSORS_LM63=m
CONFIG_SENSORS_LM70=m
CONFIG_SENSORS_LM73=m
CONFIG_SENSORS_LM75=m
# CONFIG_SENSORS_LM77 is not set
CONFIG_SENSORS_LM78=m
CONFIG_SENSORS_LM80=m
CONFIG_SENSORS_LM83=m
CONFIG_SENSORS_LM85=m
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_LTC4151 is not set
# CONFIG_SENSORS_LTC4215 is not set
CONFIG_SENSORS_LTC4245=m
# CONFIG_SENSORS_LTC4261 is not set
CONFIG_SENSORS_LM95241=m
CONFIG_SENSORS_LM95245=m
# CONFIG_SENSORS_MAX1111 is not set
CONFIG_SENSORS_MAX16065=m
CONFIG_SENSORS_MAX1619=m
# CONFIG_SENSORS_MAX1668 is not set
CONFIG_SENSORS_MAX6639=m
# CONFIG_SENSORS_MAX6642 is not set
# CONFIG_SENSORS_MAX6650 is not set
CONFIG_SENSORS_MCP3021=m
# CONFIG_SENSORS_NTC_THERMISTOR is not set
# CONFIG_SENSORS_PC87360 is not set
CONFIG_SENSORS_PC87427=m
CONFIG_SENSORS_PCF8591=m
# CONFIG_PMBUS is not set
CONFIG_SENSORS_SHT15=m
CONFIG_SENSORS_SHT21=m
CONFIG_SENSORS_SIS5595=m
# CONFIG_SENSORS_SMM665 is not set
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_EMC1403 is not set
CONFIG_SENSORS_EMC2103=m
CONFIG_SENSORS_EMC6W201=m
# CONFIG_SENSORS_SMSC47M1 is not set
CONFIG_SENSORS_SMSC47M192=m
CONFIG_SENSORS_SMSC47B397=m
CONFIG_SENSORS_SCH56XX_COMMON=m
CONFIG_SENSORS_SCH5627=m
# CONFIG_SENSORS_SCH5636 is not set
CONFIG_SENSORS_ADS1015=m
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_ADS7871 is not set
# CONFIG_SENSORS_AMC6821 is not set
# CONFIG_SENSORS_INA2XX is not set
CONFIG_SENSORS_THMC50=m
CONFIG_SENSORS_TMP102=m
CONFIG_SENSORS_TMP401=m
CONFIG_SENSORS_TMP421=m
# CONFIG_SENSORS_VIA_CPUTEMP is not set
CONFIG_SENSORS_VIA686A=m
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
CONFIG_SENSORS_W83791D=m
CONFIG_SENSORS_W83792D=m
# CONFIG_SENSORS_W83793 is not set
CONFIG_SENSORS_W83795=m
CONFIG_SENSORS_W83795_FANCTRL=y
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83L786NG is not set
CONFIG_SENSORS_W83627HF=m
CONFIG_SENSORS_W83627EHF=m
CONFIG_SENSORS_WM831X=m
CONFIG_SENSORS_APPLESMC=m
CONFIG_SENSORS_MC13783_ADC=m

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
# CONFIG_SOFT_WATCHDOG is not set
# CONFIG_WM831X_WATCHDOG is not set
CONFIG_ACQUIRE_WDT=m
CONFIG_ADVANTECH_WDT=m
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
# CONFIG_F71808E_WDT is not set
# CONFIG_SP5100_TCO is not set
CONFIG_SC520_WDT=m
CONFIG_SBC_FITPC2_WATCHDOG=m
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=m
# CONFIG_IBMASR is not set
# CONFIG_WAFER_WDT is not set
# CONFIG_I6300ESB_WDT is not set
CONFIG_IE6XX_WDT=m
# CONFIG_ITCO_WDT is not set
CONFIG_IT8712F_WDT=m
# CONFIG_IT87_WDT is not set
# CONFIG_HP_WATCHDOG is not set
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
# CONFIG_NV_TCO is not set
CONFIG_60XX_WDT=m
CONFIG_SBC8360_WDT=m
CONFIG_CPU5_WDT=m
CONFIG_SMSC_SCH311X_WDT=m
# CONFIG_SMSC37B787_WDT is not set
CONFIG_VIA_WDT=m
# CONFIG_W83627HF_WDT is not set
CONFIG_W83697HF_WDT=m
# CONFIG_W83697UG_WDT is not set
CONFIG_W83877F_WDT=m
# CONFIG_W83977F_WDT is not set
# CONFIG_MACHZ_WDT is not set
# CONFIG_SBC_EPX_C3_WATCHDOG is not set
# CONFIG_XEN_WDT is not set

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
CONFIG_WDTPCI=m
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
# CONFIG_BCMA is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_SM501 is not set
# CONFIG_HTC_PASIC3 is not set
CONFIG_MFD_LM3533=m
CONFIG_TPS6105X=m
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=m
CONFIG_MFD_TPS65217=m
CONFIG_MFD_TPS65912=y
CONFIG_MFD_TPS65912_SPI=y
# CONFIG_MFD_STMPE is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_DA9052_SPI is not set
# CONFIG_MFD_ARIZONA_I2C is not set
# CONFIG_MFD_ARIZONA_SPI is not set
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_SPI=y
# CONFIG_MFD_PCF50633 is not set
CONFIG_MFD_MC13783=m
CONFIG_MFD_MC13XXX=m
CONFIG_MFD_MC13XXX_SPI=m
# CONFIG_MFD_MC13XXX_I2C is not set
# CONFIG_ABX500_CORE is not set
# CONFIG_EZX_PCAP is not set
CONFIG_MFD_CS5535=m
# CONFIG_MFD_TIMBERDALE is not set
CONFIG_LPC_SCH=m
# CONFIG_LPC_ICH is not set
# CONFIG_MFD_RDC321X is not set
CONFIG_MFD_JANZ_CMODIO=m
CONFIG_MFD_VX855=m
CONFIG_MFD_WL1273_CORE=m
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
# CONFIG_REGULATOR_DUMMY is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=m
CONFIG_REGULATOR_VIRTUAL_CONSUMER=m
CONFIG_REGULATOR_USERSPACE_CONSUMER=m
CONFIG_REGULATOR_GPIO=m
CONFIG_REGULATOR_AD5398=m
CONFIG_REGULATOR_MC13XXX_CORE=m
CONFIG_REGULATOR_MC13783=m
# CONFIG_REGULATOR_MC13892 is not set
CONFIG_REGULATOR_ISL6271A=m
# CONFIG_REGULATOR_MAX1586 is not set
# CONFIG_REGULATOR_MAX8649 is not set
# CONFIG_REGULATOR_MAX8660 is not set
CONFIG_REGULATOR_MAX8952=m
# CONFIG_REGULATOR_LP3971 is not set
# CONFIG_REGULATOR_LP3972 is not set
# CONFIG_REGULATOR_TPS6105X is not set
# CONFIG_REGULATOR_TPS62360 is not set
# CONFIG_REGULATOR_TPS65023 is not set
# CONFIG_REGULATOR_TPS6507X is not set
CONFIG_REGULATOR_TPS65217=m
# CONFIG_REGULATOR_TPS6524X is not set
# CONFIG_REGULATOR_TPS65912 is not set
# CONFIG_REGULATOR_WM831X is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
# CONFIG_DRM is not set
# CONFIG_STUB_POULSBO is not set
# CONFIG_VGASTATE is not set
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
# CONFIG_FB is not set
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
# CONFIG_BACKLIGHT_CLASS_DEVICE is not set
CONFIG_SOUND=m
CONFIG_SOUND_OSS_CORE=y
# CONFIG_SOUND_OSS_CORE_PRECLAIM is not set
# CONFIG_SND is not set
CONFIG_SOUND_PRIME=m

#
# HID support
#
CONFIG_HID=m
# CONFIG_HIDRAW is not set
# CONFIG_UHID is not set
# CONFIG_HID_GENERIC is not set

#
# Special HID drivers
#
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB_ARCH_HAS_XHCI=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
# CONFIG_USB is not set
CONFIG_USB_OTG_WHITELIST=y
CONFIG_USB_OTG_BLACKLIST_HUB=y

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
# CONFIG_UWB is not set
CONFIG_MMC=m
# CONFIG_MMC_DEBUG is not set
CONFIG_MMC_UNSAFE_RESUME=y
# CONFIG_MMC_CLKGATE is not set

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=m
CONFIG_MMC_BLOCK_MINORS=8
CONFIG_MMC_BLOCK_BOUNCE=y
CONFIG_SDIO_UART=m
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
# CONFIG_MMC_SDHCI is not set
CONFIG_MMC_TIFM_SD=m
CONFIG_MMC_SPI=m
# CONFIG_MMC_CB710 is not set
CONFIG_MMC_VIA_SDMMC=m
CONFIG_MEMSTICK=m
CONFIG_MEMSTICK_DEBUG=y

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set
CONFIG_MSPRO_BLOCK=m

#
# MemoryStick Host Controller Drivers
#
# CONFIG_MEMSTICK_TIFM_MS is not set
CONFIG_MEMSTICK_JMICRON_38X=m
# CONFIG_MEMSTICK_R592 is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=m

#
# LED drivers
#
# CONFIG_LEDS_LM3530 is not set
# CONFIG_LEDS_LM3533 is not set
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_GPIO is not set
CONFIG_LEDS_LP3944=m
# CONFIG_LEDS_LP5521 is not set
# CONFIG_LEDS_LP5523 is not set
CONFIG_LEDS_PCA955X=m
CONFIG_LEDS_PCA9633=m
# CONFIG_LEDS_WM831X_STATUS is not set
CONFIG_LEDS_DAC124S085=m
# CONFIG_LEDS_REGULATOR is not set
# CONFIG_LEDS_BD2802 is not set
CONFIG_LEDS_LT3593=m
# CONFIG_LEDS_MC13783 is not set
CONFIG_LEDS_TCA6507=m
# CONFIG_LEDS_LM3556 is not set
CONFIG_LEDS_OT200=m
# CONFIG_LEDS_BLINKM is not set
CONFIG_LEDS_TRIGGERS=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGER_TIMER=m
# CONFIG_LEDS_TRIGGER_ONESHOT is not set
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
# CONFIG_LEDS_TRIGGER_GPIO is not set
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=m
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
# CONFIG_RTC_CLASS is not set
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
# CONFIG_INTEL_MID_DMAC is not set
CONFIG_INTEL_IOATDMA=m
CONFIG_TIMB_DMA=m
CONFIG_PCH_DMA=m
CONFIG_DMA_ENGINE=y

#
# DMA Clients
#
CONFIG_NET_DMA=y
# CONFIG_ASYNC_TX_DMA is not set
CONFIG_DMATEST=m
CONFIG_DCA=m
CONFIG_AUXDISPLAY=y
CONFIG_UIO=m
CONFIG_UIO_CIF=m
# CONFIG_UIO_PDRV is not set
# CONFIG_UIO_PDRV_GENIRQ is not set
# CONFIG_UIO_AEC is not set
CONFIG_UIO_SERCOS3=m
# CONFIG_UIO_PCI_GENERIC is not set
# CONFIG_UIO_NETX is not set
CONFIG_VIRTIO=m
CONFIG_VIRTIO_RING=m

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=m
# CONFIG_VIRTIO_BALLOON is not set
# CONFIG_VIRTIO_MMIO is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set

#
# Xen driver support
#
# CONFIG_XEN_BALLOON is not set
CONFIG_XEN_DEV_EVTCHN=m
CONFIG_XEN_BACKEND=y
CONFIG_XENFS=m
# CONFIG_XEN_COMPAT_XENFS is not set
# CONFIG_XEN_SYS_HYPERVISOR is not set
CONFIG_XEN_XENBUS_FRONTEND=m
# CONFIG_XEN_GNTDEV is not set
CONFIG_XEN_GRANT_DEV_ALLOC=m
CONFIG_SWIOTLB_XEN=y
CONFIG_XEN_TMEM=y
CONFIG_XEN_PCIDEV_BACKEND=m
CONFIG_XEN_PRIVCMD=m
CONFIG_XEN_ACPI_PROCESSOR=m
# CONFIG_XEN_MCE_LOG is not set
CONFIG_STAGING=y
# CONFIG_SLICOSS is not set
# CONFIG_ECHO is not set
# CONFIG_COMEDI is not set
# CONFIG_RTS_PSTOR is not set
# CONFIG_DX_SEP is not set

#
# IIO staging drivers
#
# CONFIG_IIO_ST_HWMON is not set
CONFIG_IIO_SW_RING=m

#
# Accelerometers
#
CONFIG_ADIS16201=m
CONFIG_ADIS16203=m
# CONFIG_ADIS16204 is not set
CONFIG_ADIS16209=m
CONFIG_ADIS16220=m
# CONFIG_ADIS16240 is not set
# CONFIG_KXSD9 is not set
CONFIG_LIS3L02DQ=m
CONFIG_LIS3L02DQ_BUF_KFIFO=y
# CONFIG_LIS3L02DQ_BUF_RING_SW is not set
# CONFIG_SCA3000 is not set

#
# Analog to digital converters
#
CONFIG_AD7291=m
# CONFIG_AD7298 is not set
# CONFIG_AD7606 is not set
# CONFIG_AD799X is not set
CONFIG_AD7476=m
# CONFIG_AD7887 is not set
# CONFIG_AD7780 is not set
# CONFIG_AD7793 is not set
CONFIG_AD7816=m
# CONFIG_AD7192 is not set
CONFIG_ADT7310=m
CONFIG_ADT7410=m
CONFIG_AD7280=m
CONFIG_MAX1363=m
CONFIG_MAX1363_RING_BUFFER=y

#
# Analog digital bi-direction converters
#
# CONFIG_ADT7316 is not set

#
# Capacitance to digital converters
#
# CONFIG_AD7150 is not set
CONFIG_AD7152=m
CONFIG_AD7746=m

#
# Direct Digital Synthesis
#
CONFIG_AD5930=m
CONFIG_AD9832=m
CONFIG_AD9834=m
CONFIG_AD9850=m
CONFIG_AD9852=m
CONFIG_AD9910=m
CONFIG_AD9951=m

#
# Digital gyroscope sensors
#
# CONFIG_ADIS16060 is not set
CONFIG_ADIS16080=m
CONFIG_ADIS16130=m
# CONFIG_ADIS16260 is not set
# CONFIG_ADXRS450 is not set

#
# Network Analyzer, Impedance Converters
#
# CONFIG_AD5933 is not set

#
# Inertial measurement units
#
CONFIG_ADIS16400=m

#
# Light sensors
#
# CONFIG_SENSORS_ISL29018 is not set
# CONFIG_SENSORS_ISL29028 is not set
# CONFIG_SENSORS_TSL2563 is not set
# CONFIG_TSL2583 is not set
CONFIG_TSL2x7x=m

#
# Magnetometer sensors
#
CONFIG_SENSORS_AK8975=m
CONFIG_SENSORS_HMC5843=m

#
# Active energy metering IC
#
# CONFIG_ADE7753 is not set
# CONFIG_ADE7754 is not set
CONFIG_ADE7758=m
CONFIG_ADE7759=m
# CONFIG_ADE7854 is not set

#
# Resolver to digital converters
#
# CONFIG_AD2S90 is not set
# CONFIG_AD2S1200 is not set
# CONFIG_AD2S1210 is not set

#
# Triggers - standalone
#
CONFIG_IIO_GPIO_TRIGGER=m
# CONFIG_IIO_SYSFS_TRIGGER is not set
CONFIG_IIO_SIMPLE_DUMMY=m
# CONFIG_IIO_SIMPLE_DUMMY_EVENTS is not set
# CONFIG_IIO_SIMPLE_DUMMY_BUFFER is not set
# CONFIG_ZSMALLOC is not set
# CONFIG_CRYSTALHD is not set
# CONFIG_ACPI_QUICKSTART is not set
# CONFIG_FT1000 is not set

#
# Speakup console speech
#
CONFIG_TOUCHSCREEN_CLEARPAD_TM1217=m
# CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4 is not set
# CONFIG_STAGING_MEDIA is not set

#
# Android
#
# CONFIG_ANDROID is not set
CONFIG_PHONE=m
CONFIG_PHONE_IXJ=m
# CONFIG_IPACK_BUS is not set
# CONFIG_WIMAX_GDM72XX is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_THINKPAD_ACPI is not set
CONFIG_SENSORS_HDAPS=m
# CONFIG_INTEL_MENLOW is not set
# CONFIG_EEEPC_LAPTOP is not set
# CONFIG_ACPI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_IPS is not set
CONFIG_IBM_RTL=m
# CONFIG_XO15_EBOOK is not set
# CONFIG_SAMSUNG_Q10 is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
CONFIG_IOMMU_SUPPORT=y
# CONFIG_AMD_IOMMU is not set
# CONFIG_INTEL_IOMMU is not set
# CONFIG_IRQ_REMAP is not set

#
# Remoteproc drivers (EXPERIMENTAL)
#

#
# Rpmsg drivers (EXPERIMENTAL)
#
CONFIG_VIRT_DRIVERS=y
# CONFIG_PM_DEVFREQ is not set
# CONFIG_EXTCON is not set
# CONFIG_MEMORY is not set
CONFIG_IIO=m
CONFIG_IIO_BUFFER=y
CONFIG_IIO_KFIFO_BUF=m
CONFIG_IIO_TRIGGERED_BUFFER=m
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2

#
# Analog to digital converters
#
# CONFIG_AD7266 is not set

#
# Amplifiers
#
CONFIG_AD8366=m

#
# Light sensors
#
# CONFIG_ADJD_S311 is not set
# CONFIG_SENSORS_LM3533 is not set
# CONFIG_VCNL4000 is not set

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#
# CONFIG_AD9523 is not set

#
# Phase-Locked Loop (PLL) frequency synthesizers
#
# CONFIG_ADF4350 is not set

#
# Digital to analog converters
#
# CONFIG_AD5064 is not set
# CONFIG_AD5360 is not set
# CONFIG_AD5380 is not set
# CONFIG_AD5421 is not set
# CONFIG_AD5624R_SPI is not set
CONFIG_AD5446=m
CONFIG_AD5504=m
CONFIG_AD5764=m
CONFIG_AD5791=m
# CONFIG_AD5686 is not set
CONFIG_MAX517=m
# CONFIG_MCP4725 is not set
CONFIG_VME_BUS=m

#
# VME Bridge Drivers
#
# CONFIG_VME_CA91CX42 is not set
# CONFIG_VME_TSI148 is not set

#
# VME Board Drivers
#
# CONFIG_VMIVME_7805 is not set

#
# VME Device Drivers
#
# CONFIG_VME_USER is not set
# CONFIG_VME_PIO2 is not set
# CONFIG_PWM is not set

#
# Firmware Drivers
#
CONFIG_EDD=m
CONFIG_EDD_OFF=y
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=m
CONFIG_DCDBAS=m
CONFIG_ISCSI_IBFT_FIND=y
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_EXT2_FS is not set
# CONFIG_EXT3_FS is not set
CONFIG_EXT4_FS=m
CONFIG_EXT4_USE_FOR_EXT23=y
CONFIG_EXT4_FS_XATTR=y
# CONFIG_EXT4_FS_POSIX_ACL is not set
CONFIG_EXT4_FS_SECURITY=y
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD2=m
CONFIG_JBD2_DEBUG=y
CONFIG_FS_MBCACHE=m
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_BTRFS_FS is not set
CONFIG_NILFS2_FS=m
# CONFIG_FS_POSIX_ACL is not set
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
# CONFIG_INOTIFY_USER is not set
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
# CONFIG_PRINT_QUOTA_WARNING is not set
CONFIG_QUOTA_DEBUG=y
CONFIG_QFMT_V1=m
# CONFIG_QFMT_V2 is not set
CONFIG_QUOTACTL=y
# CONFIG_AUTOFS4_FS is not set
CONFIG_FUSE_FS=m
CONFIG_CUSE=m

#
# Caches
#
CONFIG_FSCACHE=m
CONFIG_FSCACHE_DEBUG=y
CONFIG_CACHEFILES=m
CONFIG_CACHEFILES_DEBUG=y

#
# CD-ROM/DVD Filesystems
#
# CONFIG_ISO9660_FS is not set
CONFIG_UDF_FS=m
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
# CONFIG_MSDOS_FS is not set
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_NTFS_FS=m
CONFIG_NTFS_DEBUG=y
# CONFIG_NTFS_RW is not set

#
# Pseudo filesystems
#
# CONFIG_PROC_FS is not set
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
# CONFIG_TMPFS_XATTR is not set
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=m
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ADFS_FS=m
# CONFIG_ADFS_FS_RW is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
CONFIG_HFS_FS=m
# CONFIG_HFSPLUS_FS is not set
CONFIG_BEFS_FS=m
# CONFIG_BEFS_DEBUG is not set
CONFIG_BFS_FS=m
CONFIG_EFS_FS=m
CONFIG_LOGFS=m
CONFIG_CRAMFS=m
CONFIG_SQUASHFS=m
CONFIG_SQUASHFS_XATTR=y
CONFIG_SQUASHFS_ZLIB=y
# CONFIG_SQUASHFS_LZO is not set
CONFIG_SQUASHFS_XZ=y
# CONFIG_SQUASHFS_4K_DEVBLK_SIZE is not set
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
CONFIG_OMFS_FS=m
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
CONFIG_QNX6FS_FS=m
# CONFIG_QNX6FS_DEBUG is not set
CONFIG_ROMFS_FS=m
CONFIG_ROMFS_BACKED_BY_BLOCK=y
CONFIG_ROMFS_ON_BLOCK=y
# CONFIG_PSTORE is not set
CONFIG_SYSV_FS=m
CONFIG_UFS_FS=m
CONFIG_UFS_FS_WRITE=y
CONFIG_UFS_DEBUG=y
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
CONFIG_NLS_CODEPAGE_737=m
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
CONFIG_NLS_CODEPAGE_857=m
# CONFIG_NLS_CODEPAGE_860 is not set
CONFIG_NLS_CODEPAGE_861=m
# CONFIG_NLS_CODEPAGE_862 is not set
CONFIG_NLS_CODEPAGE_863=m
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
CONFIG_NLS_CODEPAGE_869=m
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
CONFIG_NLS_CODEPAGE_1250=m
CONFIG_NLS_CODEPAGE_1251=m
# CONFIG_NLS_ASCII is not set
CONFIG_NLS_ISO8859_1=m
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
CONFIG_NLS_ISO8859_4=m
# CONFIG_NLS_ISO8859_5 is not set
CONFIG_NLS_ISO8859_6=m
# CONFIG_NLS_ISO8859_7 is not set
CONFIG_NLS_ISO8859_9=m
CONFIG_NLS_ISO8859_13=m
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=m
CONFIG_NLS_KOI8_R=m
CONFIG_NLS_KOI8_U=m
# CONFIG_NLS_MAC_ROMAN is not set
# CONFIG_NLS_MAC_CELTIC is not set
# CONFIG_NLS_MAC_CENTEURO is not set
# CONFIG_NLS_MAC_CROATIAN is not set
# CONFIG_NLS_MAC_CYRILLIC is not set
# CONFIG_NLS_MAC_GAELIC is not set
CONFIG_NLS_MAC_GREEK=m
CONFIG_NLS_MAC_ICELAND=m
# CONFIG_NLS_MAC_INUIT is not set
CONFIG_NLS_MAC_ROMANIAN=m
# CONFIG_NLS_MAC_TURKISH is not set
# CONFIG_NLS_UTF8 is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
# CONFIG_ENABLE_WARN_DEPRECATED is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=2048
CONFIG_MAGIC_SYSRQ=y
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_HARDLOCKUP_DETECTOR is not set
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
# CONFIG_DETECT_HUNG_TASK is not set
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_STATS is not set
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
# CONFIG_PROVE_LOCKING is not set
CONFIG_SPARSE_RCU_POINTER=y
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_STACKTRACE=y
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_INFO is not set
# CONFIG_DEBUG_VM is not set
CONFIG_DEBUG_VIRTUAL=y
CONFIG_DEBUG_WRITECOUNT=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_DEBUG_LIST=y
CONFIG_TEST_LIST_SORT=y
CONFIG_DEBUG_SG=y
CONFIG_DEBUG_NOTIFIERS=y
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=60
# CONFIG_RCU_CPU_STALL_INFO is not set
CONFIG_RCU_TRACE=y
CONFIG_KPROBES_SANITY_TEST=y
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_LKDTM=m
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
CONFIG_FAULT_INJECTION=y
CONFIG_FAILSLAB=y
CONFIG_FAIL_PAGE_ALLOC=y
# CONFIG_FAIL_MAKE_REQUEST is not set
CONFIG_FAIL_IO_TIMEOUT=y
CONFIG_FAIL_MMC_REQUEST=y
CONFIG_FAULT_INJECTION_DEBUG_FS=y
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_WANT_PAGE_DEBUG_FLAGS=y
CONFIG_PAGE_GUARD=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_EVENT_POWER_TRACING_DEPRECATED=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
# CONFIG_FUNCTION_GRAPH_TRACER is not set
# CONFIG_IRQSOFF_TRACER is not set
CONFIG_SCHED_TRACER=y
CONFIG_FTRACE_SYSCALLS=y
CONFIG_TRACE_BRANCH_PROFILING=y
# CONFIG_BRANCH_PROFILE_NONE is not set
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
CONFIG_PROFILE_ALL_BRANCHES=y
# CONFIG_BRANCH_TRACER is not set
# CONFIG_STACK_TRACER is not set
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_KPROBE_EVENT=y
CONFIG_UPROBE_EVENT=y
CONFIG_PROBE_EVENTS=y
# CONFIG_DYNAMIC_FTRACE is not set
# CONFIG_FUNCTION_PROFILER is not set
# CONFIG_FTRACE_STARTUP_TEST is not set
CONFIG_MMIOTRACE=y
# CONFIG_MMIOTRACE_TEST is not set
# CONFIG_RING_BUFFER_BENCHMARK is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DYNAMIC_DEBUG is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_TEST_KSTRTOX=m
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
CONFIG_DEBUG_STACKOVERFLOW=y
# CONFIG_X86_PTDUMP is not set
# CONFIG_DEBUG_RODATA is not set
CONFIG_DEBUG_SET_MODULE_RONX=y
# CONFIG_DEBUG_NX_TEST is not set
# CONFIG_DEBUG_TLBFLUSH is not set
CONFIG_IOMMU_STRESS=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
# CONFIG_X86_DECODER_SELFTEST is not set
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
CONFIG_IO_DELAY_0XED=y
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=1
CONFIG_DEBUG_BOOT_PARAMS=y
CONFIG_CPA_DEBUG=y
# CONFIG_OPTIMIZE_INLINING is not set
# CONFIG_DEBUG_NMI_SELFTEST is not set

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_ENCRYPTED_KEYS is not set
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
CONFIG_SECURITY_DMESG_RESTRICT=y
# CONFIG_SECURITY is not set
# CONFIG_SECURITYFS is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_ASYNC_TX_DISABLE_PQ_VAL_DMA=y
CONFIG_ASYNC_TX_DISABLE_XOR_VAL_DMA=y
CONFIG_CRYPTO=m

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=m
CONFIG_CRYPTO_ALGAPI2=m
CONFIG_CRYPTO_AEAD=m
CONFIG_CRYPTO_AEAD2=m
CONFIG_CRYPTO_BLKCIPHER=m
CONFIG_CRYPTO_BLKCIPHER2=m
CONFIG_CRYPTO_HASH=m
CONFIG_CRYPTO_HASH2=m
CONFIG_CRYPTO_RNG=m
CONFIG_CRYPTO_RNG2=m
CONFIG_CRYPTO_PCOMP2=m
CONFIG_CRYPTO_MANAGER=m
CONFIG_CRYPTO_MANAGER2=m
# CONFIG_CRYPTO_USER is not set
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=m
CONFIG_CRYPTO_NULL=m
# CONFIG_CRYPTO_PCRYPT is not set
CONFIG_CRYPTO_WORKQUEUE=m
CONFIG_CRYPTO_CRYPTD=m
# CONFIG_CRYPTO_AUTHENC is not set
CONFIG_CRYPTO_TEST=m
CONFIG_CRYPTO_GLUE_HELPER_X86=m

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
CONFIG_CRYPTO_GCM=m
CONFIG_CRYPTO_SEQIV=m

#
# Block modes
#
CONFIG_CRYPTO_CBC=m
CONFIG_CRYPTO_CTR=m
CONFIG_CRYPTO_CTS=m
CONFIG_CRYPTO_ECB=m
CONFIG_CRYPTO_LRW=m
# CONFIG_CRYPTO_PCBC is not set
CONFIG_CRYPTO_XTS=m

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=m
# CONFIG_CRYPTO_XCBC is not set
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=m
CONFIG_CRYPTO_CRC32C_INTEL=m
CONFIG_CRYPTO_GHASH=m
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=m
# CONFIG_CRYPTO_MICHAEL_MIC is not set
CONFIG_CRYPTO_RMD128=m
CONFIG_CRYPTO_RMD160=m
CONFIG_CRYPTO_RMD256=m
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=m
CONFIG_CRYPTO_SHA1_SSSE3=m
CONFIG_CRYPTO_SHA256=m
# CONFIG_CRYPTO_SHA512 is not set
# CONFIG_CRYPTO_TGR192 is not set
CONFIG_CRYPTO_WP512=m
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=m

#
# Ciphers
#
CONFIG_CRYPTO_AES=m
# CONFIG_CRYPTO_AES_X86_64 is not set
# CONFIG_CRYPTO_AES_NI_INTEL is not set
CONFIG_CRYPTO_ANUBIS=m
# CONFIG_CRYPTO_ARC4 is not set
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_BLOWFISH_COMMON=m
CONFIG_CRYPTO_BLOWFISH_X86_64=m
# CONFIG_CRYPTO_CAMELLIA is not set
# CONFIG_CRYPTO_CAMELLIA_X86_64 is not set
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST6 is not set
# CONFIG_CRYPTO_DES is not set
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SALSA20 is not set
CONFIG_CRYPTO_SALSA20_X86_64=m
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_SERPENT=m
# CONFIG_CRYPTO_SERPENT_SSE2_X86_64 is not set
# CONFIG_CRYPTO_SERPENT_AVX_X86_64 is not set
CONFIG_CRYPTO_TEA=m
# CONFIG_CRYPTO_TWOFISH is not set
CONFIG_CRYPTO_TWOFISH_COMMON=m
CONFIG_CRYPTO_TWOFISH_X86_64=m
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=m
# CONFIG_CRYPTO_TWOFISH_AVX_X86_64 is not set

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=m
# CONFIG_CRYPTO_ZLIB is not set
CONFIG_CRYPTO_LZO=m

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=m
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
# CONFIG_CRYPTO_HW is not set
CONFIG_HAVE_KVM=y
# CONFIG_VIRTUALIZATION is not set
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
CONFIG_CRC_CCITT=m
CONFIG_CRC16=m
# CONFIG_CRC_T10DIF is not set
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
CONFIG_CRC32_SELFTEST=y
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=m
# CONFIG_LIBCRC32C is not set
CONFIG_CRC8=m
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=m
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
# CONFIG_XZ_DEC_IA64 is not set
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_BTREE=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPUMASK_OFFSTACK=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
# CONFIG_AVERAGE is not set
# CONFIG_CORDIC is not set
# CONFIG_DDR is not set

--c3bfwLpm8qysLVxt--

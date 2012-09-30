Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125Ab2I3EkS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 00:40:18 -0400
Received: from mga11.intel.com ([192.55.52.93]:19085 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751251Ab2I3EkO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 00:40:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,511,1344236400"; 
   d="scan'208";a="228208481"
Date: Sun, 30 Sep 2012 12:40:01 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Rob Herring <rob.herring@calxeda.com>
Cc: Leann Ogasawara <leann.ogasawara@canonical.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [ubuntu quantal] BUG filp (Not tainted): Poison overwritten
Message-ID: <20120930044001.GA28972@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="3V7upXqbjpZ4EhLz"
Content-Disposition: inline
In-Reply-To: <20120930042930.GA28244@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Sep 30, 2012 at 12:29:30PM +0800, Fengguang Wu wrote:                                                                                            
> Hi,                                                                                                                                                    
>                                                                                                                                                        
> I got the below oops in tree:                                                                                                                          
>                                                                                                                                                        
>    git://sources.calxeda.com/kernel/linux.git ubuntu-quantal                                                                                           
>                      

The other (maybe related) errors in this tree:

[  790.863084] hostname (24) used greatest stack depth: 4928 bytes left
[  814.604614] =============================================================================
[  814.604614] BUG filp (Not tainted): Poison overwritten
[  814.604614] -----------------------------------------------------------------------------
[  814.604614] 
[  814.604614] INFO: 0xffff88000ccf6c78-0xffff88000ccf6c78. First byte 0x6a instead of 0x6b

Thanks,
Fengguang

--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-kvm-tyan-9555-2012-09-30-07-20-01-3.5.4-00340-gdaac8ca-2345"

[    0.000000] Linux version 3.5.4-00340-gdaac8ca (kbuild@snb) (gcc version 4.7.1 (Debian 4.7.1-6) ) #2345 SMP PREEMPT Sun Sep 30 06:58:36 CST 2012 ()
[    0.000000] Command line: trinity=5m hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 branch=calxeda/ubuntu-quantal log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=vmlinuz-2012-09-30-06-59-20-calxeda:ubuntu-quantal:c07f157-daac8ca-x86_64-randconfig-s001-1-tyan noapic nolapic nohz=off BOOT_IMAGE=kernel-tests/kernels/x86_64-randconfig-s001/daac8ca/vmlinuz-3.5.4-00340-gdaac8ca
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000093bff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000093c00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2007
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0xfffe max_arch_pfn = 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdac0-0x000fdacf] mapped at [ffff8800000fdac0]
[    0.000000]   mpc: fdad0-fdbec
[    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
[    0.000000] Base memory trampoline at [ffff88000008d000] 8d000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x0fffdfff]
[    0.000000]  [mem 0x00000000-0x0fdfffff] page 2M
[    0.000000]  [mem 0x0fe00000-0x0fffdfff] page 4k
[    0.000000] kernel direct mapping tables up to 0xfffdfff @ [mem 0x0e854000-0x0e8d5fff]
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 128696(98%)
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
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000000fffdfff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x0fffdfff]
[    0.000000]   NODE_DATA [mem 0x0fffa000-0x0fffdfff]
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
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Intel MultiProcessor Specification v1.4
[    0.000000]   mpc: fdad0-fdbec
[    0.000000] MPTABLE: OEM ID: BOCHSCPU
[    0.000000] MPTABLE: Product ID: 0.1         
[    0.000000] MPTABLE: APIC at: 0xFEE00000
[    0.000000] mapped APIC to ffffffffff5fb000 (        fee00000)
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] Processor #1
[    0.000000] Bus #0 is PCI   
[    0.000000] Bus #1 is ISA   
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 04, APIC ID 2, APIC INT 09
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 0c, APIC ID 2, APIC INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 10, APIC ID 2, APIC INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 14, APIC ID 2, APIC INT 0a
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 18, APIC ID 2, APIC INT 0a
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 1c, APIC ID 2, APIC INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 20, APIC ID 2, APIC INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 24, APIC ID 2, APIC INT 0a
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 00, APIC ID 2, APIC INT 02
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 01, APIC ID 2, APIC INT 01
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 03, APIC ID 2, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 04, APIC ID 2, APIC INT 04
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 05, APIC ID 2, APIC INT 05
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 06, APIC ID 2, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 07, APIC ID 2, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 08, APIC ID 2, APIC INT 08
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0c, APIC ID 2, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0d, APIC ID 2, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0e, APIC ID 2, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0f, APIC ID 2, APIC INT 0f
[    0.000000] Lint: type 3, pol 0, trig 0, bus 01, IRQ 00, APIC ID 0, APIC LINT 00
[    0.000000] Lint: type 1, pol 0, trig 0, bus 01, IRQ 00, APIC ID ff, APIC LINT 01
[    0.000000] Processors: 2
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5fa000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 0000000000093000 - 0000000000094000
[    0.000000] PM: Registered nosave memory: 0000000000094000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] e820: [mem 0x10000000-0xfffbffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 474 pages/cpu @ffff88000dc00000 s1911232 r8192 d22080 u2097152
[    0.000000] pcpu-alloc: s1911232 r8192 d22080 u2097152 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 64379
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: trinity=5m hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 branch=calxeda/ubuntu-quantal log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=vmlinuz-2012-09-30-06-59-20-calxeda:ubuntu-quantal:c07f157-daac8ca-x86_64-randconfig-s001-1-tyan noapic nolapic nohz=off BOOT_IMAGE=kernel-tests/kernels/x86_64-randconfig-s001/daac8ca/vmlinuz-3.5.4-00340-gdaac8ca
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 199272k/262136k available (3425k kernel code, 500k absent, 62364k reserved, 7295k data, 2264k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 
[    0.000000] NR_IRQS:4352 nr_irqs:512 16
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 6367 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] ----------------------------------------------------------------------------
[    0.000000]                                  | spin |wlock |rlock |mutex | wsem | rsem |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]               recursive read-lock:             |  ok  |             |  ok  |
[    0.000000]            recursive read-lock #2:             |  ok  |             |  ok  |
[    0.000000]             mixed read-write-lock:             |  ok  |             |  ok  |
[    0.000000]             mixed write-read-lock:             |  ok  |             |  ok  |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
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
[    0.000000] -------------------------------------------------------
[    0.000000] Good, all 218 testcases passed! |
[    0.000000] ---------------------------------
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration failed
[    0.000000] TSC: Unable to calibrate against PIT
[    0.000000] TSC: using HPET reference calibration
[    0.000000] Detected 2009.119 MHz processor.
[    0.000000] Marking TSC unstable due to TSCs unsynchronized
[    0.029997] Calibrating delay loop (skipped), value calculated using timer frequency.. 4018.23 BogoMIPS (lpj=2009119)
[    0.035704] pid_max: default: 32768 minimum: 301
[    0.135496] Security Framework initialized
[    0.168264] AppArmor: AppArmor initialized
[    0.210842] Dentry cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.230284] Inode-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.246682] Mount-cache hash table entries: 256
[    0.732299] ACPI: Core revision 20120320
[    7.474284] ACPI: setting ELCR to 0200 (from 0c00)
[    7.572266] SMP disabled
[    7.580486] Performance Events: 
[    7.582537] no APIC, boot with the "lapic" boot parameter to force-enable it.
[    7.585116] no hardware sampling interrupt available.
[    7.589147] Broken PMU hardware detected, using software events only.
[    7.842295] Brought up 1 CPUs
[    7.846116] ----------------
[    7.848071] | NMI testsuite:
[    7.849066] --------------------
[    7.850297]   remote IPI:  ok  |
[    7.853200]    local IPI:  ok  |
[   30.391677] --------------------
[   30.392792] Good, all   2 testcases passed! |
[   30.394620] ---------------------------------
[   30.396815] Total of 1 processors activated (4018.23 BogoMIPS).
[   30.429098] CPU0 attaching NULL sched-domain.
[   30.615768] device: 'platform': device_add
[   30.654599] PM: Adding info for No Bus:platform
[   30.703630] bus: 'platform': registered
[   30.739717] bus: 'cpu': registered
[   30.746767] device: 'cpu': device_add
[   30.789717] PM: Adding info for No Bus:cpu
[   31.360669] atomic64 test passed for x86-64 platform with CX8 and with SSE
[   31.493561] NET: Registered protocol family 16
[   31.534731] device class 'bdi': registering
[   31.632469] device class 'pci_bus': registering
[   31.683802] bus: 'pci': registered
[   31.687433] device class 'tty': registering
[   31.746584] bus: 'node': registered
[   31.753440] device: 'node': device_add
[   31.784559] PM: Adding info for No Bus:node
[   31.829708] bus: 'spi': registered
[   31.831482] device class 'spi_master': registering
[   31.895485] ACPI: bus type pci registered
[   31.897743] device class 'dma': registering
[   31.925722] PCI: Using configuration type 1 for base access
[   31.936416] device: 'node0': device_add
[   31.945625] bus: 'node': add device node0
[   31.976570] PM: Adding info for node:node0
[   32.019406] device: 'cpu0': device_add
[   32.027527] bus: 'cpu': add device cpu0
[   32.052523] PM: Adding info for cpu:cpu0
[   33.460190] device: 'default': device_add
[   33.529167] PM: Adding info for No Bus:default
[   33.631161] bio: create slab <bio-0> at 0
[   33.676221] device class 'block': registering
[   33.777219] ACPI: Added _OSI(Module Device)
[   33.782155] ACPI: Added _OSI(Processor Device)
[   33.787211] ACPI: Added _OSI(3.0 _SCP Extensions)
[   33.792152] ACPI: Added _OSI(Processor Aggregator Device)
[   34.574051] ACPI: EC: Look up EC in DSDT
[   53.774143] ACPI: Interpreter enabled
[   53.776153] ACPI: (supports S0 S3 S4 S5)
[   53.916201] ACPI: Using PIC for interrupt routing
[   53.972161] bus: 'acpi': registered
[   53.976082] bus: 'acpi': add driver power
[   54.071185] device: 'LNXSYSTM:00': device_add
[   54.085170] bus: 'acpi': add device LNXSYSTM:00
[   54.117308] PM: Adding info for acpi:LNXSYSTM:00
[   54.365988] device: 'device:00': device_add
[   54.375128] bus: 'acpi': add device device:00
[   54.408018] PM: Adding info for acpi:device:00
[   54.660939] device: 'PNP0A03:00': device_add
[   54.671063] bus: 'acpi': add device PNP0A03:00
[   54.701049] PM: Adding info for acpi:PNP0A03:00
[   55.474977] device: 'device:01': device_add
[   55.483937] bus: 'acpi': add device device:01
[   55.514926] PM: Adding info for acpi:device:01
[   55.736780] device: 'device:02': device_add
[   55.746901] bus: 'acpi': add device device:02
[   55.776882] PM: Adding info for acpi:device:02
[   56.001735] device: 'PNP0B00:00': device_add
[   56.011858] bus: 'acpi': add device PNP0B00:00
[   56.043877] PM: Adding info for acpi:PNP0B00:00
[   56.382677] device: 'PNP0303:00': device_add
[   56.394669] bus: 'acpi': add device PNP0303:00
[   56.424969] PM: Adding info for acpi:PNP0303:00
[   56.776617] device: 'PNP0F13:00': device_add
[   56.787595] bus: 'acpi': add device PNP0F13:00
[   56.818727] PM: Adding info for acpi:PNP0F13:00
[   57.159559] device: 'PNP0700:00': device_add
[   57.169683] bus: 'acpi': add device PNP0700:00
[   57.202616] PM: Adding info for acpi:PNP0700:00
[   57.922453] device: 'PNP0400:00': device_add
[   57.933491] bus: 'acpi': add device PNP0400:00
[   57.964493] PM: Adding info for acpi:PNP0400:00
[   58.669332] device: 'PNP0501:00': device_add
[   58.679672] bus: 'acpi': add device PNP0501:00
[   58.711438] PM: Adding info for acpi:PNP0501:00
[   59.167251] device: 'device:03': device_add
[   59.177373] bus: 'acpi': add device device:03
[   59.207360] PM: Adding info for acpi:device:03
[   59.438214] device: 'device:04': device_add
[   59.449348] bus: 'acpi': add device device:04
[   59.480227] PM: Adding info for acpi:device:04
[   59.701330] device: 'device:05': device_add
[   59.712264] bus: 'acpi': add device device:05
[   59.744284] PM: Adding info for acpi:device:05
[   60.007120] device: 'device:06': device_add
[   60.017242] bus: 'acpi': add device device:06
[   60.047231] PM: Adding info for acpi:device:06
[   60.313075] device: 'device:07': device_add
[   60.324046] bus: 'acpi': add device device:07
[   60.355053] PM: Adding info for acpi:device:07
[   60.617027] device: 'device:08': device_add
[   60.627141] bus: 'acpi': add device device:08
[   60.659065] PM: Adding info for acpi:device:08
[   60.919034] device: 'device:09': device_add
[   60.929096] bus: 'acpi': add device device:09
[   60.959256] PM: Adding info for acpi:device:09
[   61.219935] device: 'device:0a': device_add
[   61.230061] bus: 'acpi': add device device:0a
[   61.260035] PM: Adding info for acpi:device:0a
[   61.522876] device: 'device:0b': device_add
[   61.533011] bus: 'acpi': add device device:0b
[   61.563867] PM: Adding info for acpi:device:0b
[   61.821838] device: 'device:0c': device_add
[   61.831964] bus: 'acpi': add device device:0c
[   61.863885] PM: Adding info for acpi:device:0c
[   62.123780] device: 'device:0d': device_add
[   62.133917] bus: 'acpi': add device device:0d
[   62.163811] PM: Adding info for acpi:device:0d
[   62.420751] device: 'device:0e': device_add
[   62.430876] bus: 'acpi': add device device:0e
[   62.462020] PM: Adding info for acpi:device:0e
[   62.723679] device: 'device:0f': device_add
[   62.733835] bus: 'acpi': add device device:0f
[   62.765820] PM: Adding info for acpi:device:0f
[   63.021661] device: 'device:10': device_add
[   63.031948] bus: 'acpi': add device device:10
[   63.062669] PM: Adding info for acpi:device:10
[   63.318615] device: 'device:11': device_add
[   63.328723] bus: 'acpi': add device device:11
[   63.359736] PM: Adding info for acpi:device:11
[   63.646600] device: 'device:12': device_add
[   63.657721] bus: 'acpi': add device device:12
[   63.690543] PM: Adding info for acpi:device:12
[   63.974534] device: 'device:13': device_add
[   63.985640] bus: 'acpi': add device device:13
[   64.018655] PM: Adding info for acpi:device:13
[   64.295645] device: 'device:14': device_add
[   64.307468] bus: 'acpi': add device device:14
[   64.339604] PM: Adding info for acpi:device:14
[   64.617429] device: 'device:15': device_add
[   64.627556] bus: 'acpi': add device device:15
[   64.659533] PM: Adding info for acpi:device:15
[   64.937384] device: 'device:16': device_add
[   64.949372] bus: 'acpi': add device device:16
[   64.982363] PM: Adding info for acpi:device:16
[   65.257339] device: 'device:17': device_add
[   65.266480] bus: 'acpi': add device device:17
[   65.300316] PM: Adding info for acpi:device:17
[   65.573287] device: 'device:18': device_add
[   65.584367] bus: 'acpi': add device device:18
[   65.617274] PM: Adding info for acpi:device:18
[   65.894242] device: 'device:19': device_add
[   65.905379] bus: 'acpi': add device device:19
[   65.937375] PM: Adding info for acpi:device:19
[   66.213193] device: 'device:1a': device_add
[   66.224261] bus: 'acpi': add device device:1a
[   66.256489] PM: Adding info for acpi:device:1a
[   66.534121] device: 'device:1b': device_add
[   66.545278] bus: 'acpi': add device device:1b
[   66.578257] PM: Adding info for acpi:device:1b
[   66.854072] device: 'device:1c': device_add
[   66.865162] bus: 'acpi': add device device:1c
[   66.900156] PM: Adding info for acpi:device:1c
[   67.161027] device: 'device:1d': device_add
[   67.171150] bus: 'acpi': add device device:1d
[   67.201144] PM: Adding info for acpi:device:1d
[   67.465987] device: 'device:1e': device_add
[   67.477076] bus: 'acpi': add device device:1e
[   67.507242] PM: Adding info for acpi:device:1e
[   67.775934] device: 'device:1f': device_add
[   67.786976] bus: 'acpi': add device device:1f
[   67.817911] PM: Adding info for acpi:device:1f
[   68.064922] device: 'device:20': device_add
[   68.074996] bus: 'acpi': add device device:20
[   68.108915] PM: Adding info for acpi:device:20
[   68.366547] device: 'device:21': device_add
[   68.375970] bus: 'acpi': add device device:21
[   68.411828] PM: Adding info for acpi:device:21
[   68.687814] device: 'device:22': device_add
[   68.698945] bus: 'acpi': add device device:22
[   68.735104] PM: Adding info for acpi:device:22
[   69.970606] device: 'PNP0103:00': device_add
[   69.981688] bus: 'acpi': add device PNP0103:00
[   70.014731] PM: Adding info for acpi:PNP0103:00
[   70.713507] device: 'PNP0C0F:00': device_add
[   70.724502] bus: 'acpi': add device PNP0C0F:00
[   70.757477] PM: Adding info for acpi:PNP0C0F:00
[   71.386381] device: 'PNP0C0F:01': device_add
[   71.396509] bus: 'acpi': add device PNP0C0F:01
[   71.426501] PM: Adding info for acpi:PNP0C0F:01
[   72.043255] device: 'PNP0C0F:02': device_add
[   72.053462] bus: 'acpi': add device PNP0C0F:02
[   72.085366] PM: Adding info for acpi:PNP0C0F:02
[   72.694186] device: 'PNP0C0F:03': device_add
[   72.704471] bus: 'acpi': add device PNP0C0F:03
[   72.735292] PM: Adding info for acpi:PNP0C0F:03
[   73.378085] device: 'PNP0C0F:04': device_add
[   73.378780] bus: 'acpi': add device PNP0C0F:04
[   73.392057] PM: Adding info for acpi:PNP0C0F:04
[   73.805011] device: 'LNXCPU:00': device_add
[   73.814146] bus: 'acpi': add device LNXCPU:00
[   73.846050] PM: Adding info for acpi:LNXCPU:00
[   74.251939] device: 'LNXCPU:01': device_add
[   74.262056] bus: 'acpi': add device LNXCPU:01
[   74.294068] PM: Adding info for acpi:LNXCPU:01
[   74.517089] device: 'device:23': device_add
[   74.527995] bus: 'acpi': add device device:23
[   74.560021] PM: Adding info for acpi:device:23
[   74.606894] device: 'LNXPWRBN:00': device_add
[   74.616930] bus: 'acpi': add device LNXPWRBN:00
[   74.644028] PM: Adding info for acpi:LNXPWRBN:00
[   74.694081] bus: 'acpi': add driver ec
[   74.778878] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[   74.779918] bus: 'acpi': add driver pci_root
[   74.793998] bus: 'acpi': driver_probe_device: matched device PNP0A03:00 with driver pci_root
[   74.796165] bus: 'acpi': really_probe: probing driver pci_root with device PNP0A03:00
[   74.860554] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[   74.939516] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[   74.940921] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
[   74.943970] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[   74.946850] pci_root PNP0A03:00: host bridge window [mem 0xe0000000-0xfebfffff] (ignored)
[   74.953811] PCI: root bus 00: using default resources
[   74.972804] device: 'pci0000:00': device_add
[   75.039931] PM: Adding info for No Bus:pci0000:00
[   75.050002] device: '0000:00': device_add
[   75.120804] PM: Adding info for No Bus:0000:00
[   75.139986] PCI host bridge to bus 0000:00
[   75.145183] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[   75.149829] pci_bus 0000:00: root bus resource [mem 0x00000000-0xffffffffff]
[   75.169267] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[   75.200826] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[   75.225963] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[   75.251852] pci 0000:00:01.1: reg 20: [io  0xc1c0-0xc1cf]
[   75.273949] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[   75.295962] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
[   75.299781] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
[   75.313800] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[   75.323169] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
[   75.329878] pci 0000:00:02.0: reg 14: [mem 0xfebf0000-0xfebf0fff]
[   75.359818] pci 0000:00:02.0: reg 30: [mem 0xfebe0000-0xfebeffff pref]
[   75.370924] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[   75.379999] pci 0000:00:03.0: reg 10: [mem 0xfeba0000-0xfebbffff]
[   75.388829] pci 0000:00:03.0: reg 14: [io  0xc000-0xc03f]
[   75.417828] pci 0000:00:03.0: reg 30: [mem 0xfebc0000-0xfebdffff pref]
[   75.431912] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[   75.441824] pci 0000:00:04.0: reg 10: [io  0xc040-0xc07f]
[   75.449817] pci 0000:00:04.0: reg 14: [mem 0xfebf1000-0xfebf1fff]
[   75.492784] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[   75.502812] pci 0000:00:05.0: reg 10: [io  0xc080-0xc0bf]
[   75.510811] pci 0000:00:05.0: reg 14: [mem 0xfebf2000-0xfebf2fff]
[   75.553776] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[   75.563802] pci 0000:00:06.0: reg 10: [io  0xc0c0-0xc0ff]
[   75.571797] pci 0000:00:06.0: reg 14: [mem 0xfebf3000-0xfebf3fff]
[   75.614764] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[   75.624793] pci 0000:00:07.0: reg 10: [io  0xc100-0xc13f]
[   75.632788] pci 0000:00:07.0: reg 14: [mem 0xfebf4000-0xfebf4fff]
[   75.673918] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[   75.683785] pci 0000:00:08.0: reg 10: [io  0xc140-0xc17f]
[   75.691780] pci 0000:00:08.0: reg 14: [mem 0xfebf5000-0xfebf5fff]
[   75.734835] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[   75.744775] pci 0000:00:09.0: reg 10: [io  0xc180-0xc1bf]
[   75.752770] pci 0000:00:09.0: reg 14: [mem 0xfebf6000-0xfebf6fff]
[   75.794862] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[   75.802744] pci 0000:00:0a.0: reg 10: [mem 0xfebf7000-0xfebf700f]
[   75.848748] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[   82.529820]  pci0000:00: Unable to request _OSC control (_OSC support mask: 0x08)
[   82.538697] device: '0000:00:00.0': device_add
[   87.696061] bus: 'pci': add device 0000:00:00.0
[   87.773857] PM: Adding info for pci:0000:00:00.0
[   87.791893] device: '0000:00:01.0': device_add
[   93.012120] bus: 'pci': add device 0000:00:01.0
[   93.085054] PM: Adding info for pci:0000:00:01.0
[   93.099067] device: '0000:00:01.1': device_add
[   98.537591] bus: 'pci': add device 0000:00:01.1
[   98.614299] PM: Adding info for pci:0000:00:01.1
[   98.628193] device: '0000:00:01.3': device_add
[  103.830572] bus: 'pci': add device 0000:00:01.3
[  103.905458] PM: Adding info for pci:0000:00:01.3
[  103.919402] device: '0000:00:02.0': device_add
[  109.093766] bus: 'pci': add device 0000:00:02.0
[  109.168630] PM: Adding info for pci:0000:00:02.0
[  109.182606] device: '0000:00:03.0': device_add
[  114.376871] bus: 'pci': add device 0000:00:03.0
[  114.451932] PM: Adding info for pci:0000:00:03.0
[  114.465799] device: '0000:00:04.0': device_add
[  119.666146] bus: 'pci': add device 0000:00:04.0
[  119.740114] PM: Adding info for pci:0000:00:04.0
[  119.754995] device: '0000:00:05.0': device_add
[  124.957249] bus: 'pci': add device 0000:00:05.0
[  125.035269] PM: Adding info for pci:0000:00:05.0
[  125.049181] device: '0000:00:06.0': device_add
[  130.406502] bus: 'pci': add device 0000:00:06.0
[  130.482477] PM: Adding info for pci:0000:00:06.0
[  130.498331] device: '0000:00:07.0': device_add
[  135.690608] bus: 'pci': add device 0000:00:07.0
[  135.766829] PM: Adding info for pci:0000:00:07.0
[  135.781537] device: '0000:00:08.0': device_add
[  140.975888] bus: 'pci': add device 0000:00:08.0
[  141.049853] PM: Adding info for pci:0000:00:08.0
[  141.063730] device: '0000:00:09.0': device_add
[  146.202941] bus: 'pci': add device 0000:00:09.0
[  146.275056] PM: Adding info for pci:0000:00:09.0
[  146.288935] device: '0000:00:0a.0': device_add
[  151.461135] bus: 'pci': add device 0000:00:0a.0
[  151.536155] PM: Adding info for pci:0000:00:0a.0
[  151.549289] driver: 'PNP0A03:00': driver_bound: bound to device 'pci_root'
[  151.554139] bus: 'acpi': really_probe: bound device PNP0A03:00 to driver pci_root
[  151.582097] bus: 'acpi': add driver pci_link
[  151.597311] bus: 'acpi': driver_probe_device: matched device PNP0C0F:00 with driver pci_link
[  151.598154] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:00
[  151.972287] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[  152.073142] driver: 'PNP0C0F:00': driver_bound: bound to device 'pci_link'
[  152.076163] bus: 'acpi': really_probe: bound device PNP0C0F:00 to driver pci_link
[  152.079445] bus: 'acpi': driver_probe_device: matched device PNP0C0F:01 with driver pci_link
[  152.080077] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:01
[  152.433984] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[  152.530035] driver: 'PNP0C0F:01': driver_bound: bound to device 'pci_link'
[  152.533083] bus: 'acpi': really_probe: bound device PNP0C0F:01 to driver pci_link
[  152.536941] bus: 'acpi': driver_probe_device: matched device PNP0C0F:02 with driver pci_link
[  152.539934] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:02
[  152.895063] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[  152.994884] driver: 'PNP0C0F:02': driver_bound: bound to device 'pci_link'
[  152.997909] bus: 'acpi': really_probe: bound device PNP0C0F:02 to driver pci_link
[  153.001911] bus: 'acpi': driver_probe_device: matched device PNP0C0F:03 with driver pci_link
[  153.004929] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:03
[  153.361892] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[  153.457943] driver: 'PNP0C0F:03': driver_bound: bound to device 'pci_link'
[  153.460939] bus: 'acpi': really_probe: bound device PNP0C0F:03 to driver pci_link
[  153.464286] bus: 'acpi': driver_probe_device: matched device PNP0C0F:04 with driver pci_link
[  153.464866] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:04
[  153.781780] ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0
[  153.878981] driver: 'PNP0C0F:04': driver_bound: bound to device 'pci_link'
[  153.881874] bus: 'acpi': really_probe: bound device PNP0C0F:04 to driver pci_link
[  153.933868] bus: 'pnp': registered
[  153.942733] device class 'misc': registering
[  153.981758] device: 'vga_arbiter': device_add
[  154.046777] PM: Adding info for No Bus:vga_arbiter
[  154.087430] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[  154.116712] vgaarb: loaded
[  154.117912] vgaarb: bridge control possible 0000:00:02.0
[  154.120866] bus: 'spi': add driver wm831x
[  154.143877] bus: 'spi': add driver da9052
[  154.204693] bus: 'serio': registered
[  154.206707] device class 'input': registering
[  154.245691] device class 'power_supply': registering
[  154.262758] PCI: Using ACPI for IRQ routing
[  154.265826] PCI: pci_cache_line_size set to 64 bytes
[  154.375072] e820: reserve RAM buffer [mem 0x00093c00-0x0009ffff]
[  154.382769] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[  154.414750] device class 'net': registering
[  154.465684] device: 'lo': device_add
[  154.638702] PM: Adding info for No Bus:lo
[  154.871996] Switching to clocksource hpet
[  155.211915] Warning: could not register all branches stats
[  155.221910] Warning: could not register annotated branches stats
[  163.827034] AppArmor: AppArmor Filesystem Enabled
[  163.866167] bus: 'pnp': add driver system
[  163.890951] pnp: PnP ACPI init
[  163.899947] device: 'pnp0': device_add
[  163.925122] PM: Adding info for No Bus:pnp0
[  163.928053] ACPI: bus type pnp registered
[  163.993358] pnp 00:00: [bus 00-ff]
[  163.998142] pnp 00:00: [io  0x0cf8-0x0cff]
[  164.002946] pnp 00:00: [io  0x0000-0x0cf7 window]
[  164.006934] pnp 00:00: [io  0x0d00-0xffff window]
[  164.011334] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[  164.016032] pnp 00:00: [mem 0xe0000000-0xfebfffff window]
[  164.025060] device: '00:00': device_add
[  164.058090] bus: 'pnp': add device 00:00
[  164.096000] PM: Adding info for pnp:00:00
[  164.113991] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[  164.185155] pnp 00:01: [io  0x0070-0x0071]
[  164.191933] pnp 00:01: [irq 8]
[  164.195972] pnp 00:01: [io  0x0072-0x0077]
[  164.201963] device: '00:01': device_add
[  164.229959] bus: 'pnp': add device 00:01
[  164.268042] PM: Adding info for pnp:00:01
[  164.281018] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)
[  164.466008] pnp 00:02: [io  0x0060]
[  164.470041] pnp 00:02: [io  0x0064]
[  164.473940] pnp 00:02: [irq 1]
[  164.479128] device: '00:02': device_add
[  164.506971] bus: 'pnp': add device 00:02
[  164.545002] PM: Adding info for pnp:00:02
[  164.557327] pnp 00:02: Plug and Play ACPI device, IDs PNP0303 (active)
[  164.742981] pnp 00:03: [irq 12]
[  164.749000] device: '00:03': device_add
[  164.780040] bus: 'pnp': add device 00:03
[  164.819951] PM: Adding info for pnp:00:03
[  164.832119] pnp 00:03: Plug and Play ACPI device, IDs PNP0f13 (active)
[  165.017331] pnp 00:04: [io  0x03f2-0x03f5]
[  165.021335] pnp 00:04: [io  0x03f7]
[  165.025096] pnp 00:04: [irq 6]
[  165.030010] pnp 00:04: [dma 2]
[  165.035977] device: '00:04': device_add
[  165.064065] bus: 'pnp': add device 00:04
[  165.103120] PM: Adding info for pnp:00:04
[  165.116109] pnp 00:04: Plug and Play ACPI device, IDs PNP0700 (active)
[  165.445937] pnp 00:05: [io  0x0378-0x037f]
[  165.449957] pnp 00:05: [irq 7]
[  165.455895] device: '00:05': device_add
[  165.482951] bus: 'pnp': add device 00:05
[  165.521343] PM: Adding info for pnp:00:05
[  165.534043] pnp 00:05: Plug and Play ACPI device, IDs PNP0400 (active)
[  165.865977] pnp 00:06: [io  0x03f8-0x03ff]
[  165.870029] pnp 00:06: [irq 4]
[  165.875995] device: '00:06': device_add
[  165.903993] bus: 'pnp': add device 00:06
[  165.943071] PM: Adding info for pnp:00:06
[  165.956063] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[  166.955940] pnp 00:07: [mem 0xfed00000-0xfed003ff]
[  166.962125] device: '00:07': device_add
[  167.003989] bus: 'pnp': add device 00:07
[  167.044128] PM: Adding info for pnp:00:07
[  167.057072] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
[  167.919969] pnp: PnP ACPI: found 8 devices
[  167.922129] ACPI: ACPI bus type pnp unregistered
[  167.937067] device class 'mem': registering
[  167.958933] device: 'mem': device_add
[  168.008891] PM: Adding info for No Bus:mem
[  168.029890] device: 'null': device_add
[  168.078038] PM: Adding info for No Bus:null
[  168.095302] device: 'port': device_add
[  168.135980] PM: Adding info for No Bus:port
[  168.153337] device: 'zero': device_add
[  168.196900] PM: Adding info for No Bus:zero
[  168.212883] device: 'full': device_add
[  168.254082] PM: Adding info for No Bus:full
[  168.270062] device: 'random': device_add
[  168.311060] PM: Adding info for No Bus:random
[  168.328026] device: 'urandom': device_add
[  168.367992] PM: Adding info for No Bus:urandom
[  168.384033] device: 'kmsg': device_add
[  168.424900] PM: Adding info for No Bus:kmsg
[  168.440077] device: 'oldmem': device_add
[  168.482062] PM: Adding info for No Bus:oldmem
[  168.503134] device: 'tty': device_add
[  168.553153] PM: Adding info for No Bus:tty
[  168.580048] device: 'console': device_add
[  168.621136] PM: Adding info for No Bus:console
[  168.636301] device class 'thermal': registering
[  168.732986] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[  168.735129] pci_bus 0000:00: resource 5 [mem 0x00000000-0xffffffffff]
[  168.746325] NET: Registered protocol family 1
[  168.759110] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[  168.766909] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[  168.778933] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[  168.792305] pci 0000:00:02.0: Boot video device
[  168.825344] PCI: CLS 0 bytes, default 64
[  169.380075] device: 'snapshot': device_add
[  169.505943] PM: Adding info for No Bus:snapshot
[  169.525101] Unpacking initramfs...
[  169.679039] kwatchdog (14) used greatest stack depth: 6584 bytes left
[  169.739931] bus: 'clocksource': registered
[  169.765092] device: 'clocksource': device_add
[  169.870101] PM: Adding info for No Bus:clocksource
[  169.884951] device: 'clocksource0': device_add
[  169.908137] bus: 'clocksource': add device clocksource0
[  169.976381] PM: Adding info for clocksource:clocksource0
[  170.033305] bus: 'platform': add driver alarmtimer
[  170.113063] Registering platform device 'alarmtimer'. Parent at platform
[  170.117982] device: 'alarmtimer': device_add
[  170.139098] bus: 'platform': add device alarmtimer
[  170.204157] PM: Adding info for platform:alarmtimer
[  170.233334] bus: 'platform': driver_probe_device: matched device alarmtimer with driver alarmtimer
[  170.235316] bus: 'platform': really_probe: probing driver alarmtimer with device alarmtimer
[  170.263060] driver: 'alarmtimer': driver_bound: bound to device 'alarmtimer'
[  170.273075] bus: 'platform': really_probe: bound device alarmtimer to driver alarmtimer
[  170.415928] audit: initializing netlink socket (disabled)
[  170.481080] type=2000 audit(1348960140.462:1): initialized
[  170.696345] bus: 'event_source': registered
[  170.724932] device: 'breakpoint': device_add
[  170.749317] bus: 'event_source': add device breakpoint
[  170.835980] PM: Adding info for event_source:breakpoint
[  170.904067] device: 'tracepoint': device_add
[  170.935028] bus: 'event_source': add device tracepoint
[  171.004989] PM: Adding info for event_source:tracepoint
[  171.049084] device: 'software': device_add
[  171.068113] bus: 'event_source': add device software
[  171.138082] PM: Adding info for event_source:software
[  187.196008] VFS: Disk quotas dquot_6.5.2
[  187.455100] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[  188.112352] cryptomgr_test (18) used greatest stack depth: 5440 bytes left
[  188.300360] cryptomgr_test (19) used greatest stack depth: 5264 bytes left
[  188.370042] alg: No test for stdrng (krng)
[  188.675061] device class 'bsg': registering
[  188.724991] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
[  188.739014] io scheduler noop registered (default)
[  189.103101] bus: 'acpi': add driver ac
[  189.176163] bus: 'acpi': add driver button
[  189.216327] bus: 'acpi': driver_probe_device: matched device LNXPWRBN:00 with driver button
[  189.222150] bus: 'acpi': really_probe: probing driver button with device LNXPWRBN:00
[  189.281157] device: 'input0': device_add
[  189.569032] PM: Adding info for No Bus:input0
[  189.637000] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[  189.665006] ACPI: Power Button [PWRF]
[  189.674122] driver: 'LNXPWRBN:00': driver_bound: bound to device 'button'
[  189.681944] bus: 'acpi': really_probe: bound device LNXPWRBN:00 to driver button
[  189.720940] bus: 'acpi': add driver fan
[  189.807125] bus: 'acpi': add driver processor
[  189.858014] bus: 'acpi': driver_probe_device: matched device LNXCPU:00 with driver processor
[  189.866157] bus: 'acpi': really_probe: probing driver processor with device LNXCPU:00
[  191.680140] device: 'cooling_device0': device_add
[  191.810057] PM: Adding info for No Bus:cooling_device0
[  191.938022] driver: 'LNXCPU:00': driver_bound: bound to device 'processor'
[  191.946008] bus: 'acpi': really_probe: bound device LNXCPU:00 to driver processor
[  191.954321] bus: 'acpi': driver_probe_device: matched device LNXCPU:01 with driver processor
[  191.956064] bus: 'acpi': really_probe: probing driver processor with device LNXCPU:01
[  193.613029] driver: 'LNXCPU:01': driver_bound: bound to device 'processor'
[  193.622045] bus: 'acpi': really_probe: bound device LNXCPU:01 to driver processor
[  193.674032] bus: 'acpi': add driver thermal
[  193.758977] bus: 'acpi': add driver battery
[  193.914078] device: 'ptyp0': device_add
[  194.071991] PM: Adding info for No Bus:ptyp0
[  194.125105] device: 'ptyp1': device_add
[  194.264010] PM: Adding info for No Bus:ptyp1
[  194.314074] device: 'ptyp2': device_add
[  194.449105] PM: Adding info for No Bus:ptyp2
[  194.501349] device: 'ptyp3': device_add
[  194.633105] PM: Adding info for No Bus:ptyp3
[  194.695031] device: 'ptyp4': device_add
[  194.821361] PM: Adding info for No Bus:ptyp4
[  194.872073] device: 'ptyp5': device_add
[  195.025054] PM: Adding info for No Bus:ptyp5
[  195.083078] device: 'ptyp6': device_add
[  195.241971] PM: Adding info for No Bus:ptyp6
[  195.292369] device: 'ptyp7': device_add
[  195.442138] PM: Adding info for No Bus:ptyp7
[  195.488022] device: 'ptyp8': device_add
[  195.621077] PM: Adding info for No Bus:ptyp8
[  195.679020] device: 'ptyp9': device_add
[  195.810007] PM: Adding info for No Bus:ptyp9
[  195.864109] device: 'ptypa': device_add
[  196.013942] PM: Adding info for No Bus:ptypa
[  196.056102] device: 'ptypb': device_add
[  196.186370] PM: Adding info for No Bus:ptypb
[  196.233060] device: 'ptypc': device_add
[  196.370116] PM: Adding info for No Bus:ptypc
[  196.423079] device: 'ptypd': device_add
[  196.553014] PM: Adding info for No Bus:ptypd
[  196.612001] device: 'ptype': device_add
[  196.746063] PM: Adding info for No Bus:ptype
[  196.800127] device: 'ptypf': device_add
[  196.944979] PM: Adding info for No Bus:ptypf
[  196.991084] device: 'ptyq0': device_add
[  197.152949] PM: Adding info for No Bus:ptyq0
[  197.202045] device: 'ptyq1': device_add
[  197.349998] PM: Adding info for No Bus:ptyq1
[  197.401078] device: 'ptyq2': device_add
[  197.531086] PM: Adding info for No Bus:ptyq2
[  197.591965] device: 'ptyq3': device_add
[  197.719137] PM: Adding info for No Bus:ptyq3
[  197.774929] device: 'ptyq4': device_add
[  197.907124] PM: Adding info for No Bus:ptyq4
[  197.960031] device: 'ptyq5': device_add
[  198.096076] PM: Adding info for No Bus:ptyq5
[  198.159939] device: 'ptyq6': device_add
[  198.283015] PM: Adding info for No Bus:ptyq6
[  198.330038] device: 'ptyq7': device_add
[  198.441027] PM: Adding info for No Bus:ptyq7
[  198.481967] device: 'ptyq8': device_add
[  198.594951] PM: Adding info for No Bus:ptyq8
[  198.639981] device: 'ptyq9': device_add
[  198.748306] PM: Adding info for No Bus:ptyq9
[  198.795055] device: 'ptyqa': device_add
[  198.930090] PM: Adding info for No Bus:ptyqa
[  198.973920] device: 'ptyqb': device_add
[  199.090002] PM: Adding info for No Bus:ptyqb
[  199.134066] device: 'ptyqc': device_add
[  199.254999] PM: Adding info for No Bus:ptyqc
[  199.299030] device: 'ptyqd': device_add
[  199.408339] PM: Adding info for No Bus:ptyqd
[  199.433073] CPA self-test:
[  199.471325] device: 'ptyqe': device_add
[  199.509991]  4k 1022 large 126 gb 0 x 633[ffff880000000000-ffff88000fc00000] miss 0
[  199.656021] PM: Adding info for No Bus:ptyqe
[  199.722330] device: 'ptyqf': device_add
[  199.923043] PM: Adding info for No Bus:ptyqf
[  200.004110] device: 'ptyr0': device_add
[  200.187960] PM: Adding info for No Bus:ptyr0
[  200.267979] device: 'ptyr1': device_add
[  200.453982] PM: Adding info for No Bus:ptyr1
[  200.521922] device: 'ptyr2': device_add
[  200.713930] PM: Adding info for No Bus:ptyr2
[  200.786905] device: 'ptyr3': device_add
[  200.982956] PM: Adding info for No Bus:ptyr3
[  201.065909] device: 'ptyr4': device_add
[  201.277136] PM: Adding info for No Bus:ptyr4
[  201.349086] device: 'ptyr5': device_add
[  201.546019] PM: Adding info for No Bus:ptyr5
[  201.622125] device: 'ptyr6': device_add
[  201.812326] PM: Adding info for No Bus:ptyr6
[  201.888958] device: 'ptyr7': device_add
[  202.271951] PM: Adding info for No Bus:ptyr7
[  202.342346] device: 'ptyr8': device_add
[  202.567313] PM: Adding info for No Bus:ptyr8
[  202.642074] device: 'ptyr9': device_add
[  202.825980] PM: Adding info for No Bus:ptyr9
[  202.899959] device: 'ptyra': device_add
[  203.104989] PM: Adding info for No Bus:ptyra
[  203.175072] device: 'ptyrb': device_add
[  203.317981] PM: Adding info for No Bus:ptyrb
[  203.396960] device: 'ptyrc': device_add
[  203.583065] PM: Adding info for No Bus:ptyrc
[  203.675090] device: 'ptyrd': device_add
[  203.876319] PM: Adding info for No Bus:ptyrd
[  203.961997] device: 'ptyre': device_add
[  204.161309] PM: Adding info for No Bus:ptyre
[  204.234121] device: 'ptyrf': device_add
[  204.472023] PM: Adding info for No Bus:ptyrf
[  204.546010] device: 'ptys0': device_add
[  204.743298] PM: Adding info for No Bus:ptys0
[  204.822129] device: 'ptys1': device_add
[  205.019082] PM: Adding info for No Bus:ptys1
[  205.089344] device: 'ptys2': device_add
[  205.282355] PM: Adding info for No Bus:ptys2
[  205.350372] device: 'ptys3': device_add
[  205.552934] PM: Adding info for No Bus:ptys3
[  205.630016] device: 'ptys4': device_add
[  205.831057] PM: Adding info for No Bus:ptys4
[  205.901963] device: 'ptys5': device_add
[  206.105007] PM: Adding info for No Bus:ptys5
[  206.176990] device: 'ptys6': device_add
[  206.376984] PM: Adding info for No Bus:ptys6
[  206.447127] device: 'ptys7': device_add
[  206.642982] PM: Adding info for No Bus:ptys7
[  206.716987] device: 'ptys8': device_add
[  206.915080] PM: Adding info for No Bus:ptys8
[  206.998067] device: 'ptys9': device_add
[  207.196025] PM: Adding info for No Bus:ptys9
[  207.266041] device: 'ptysa': device_add
[  207.457107] PM: Adding info for No Bus:ptysa
[  207.554077] device: 'ptysb': device_add
[  207.746093] PM: Adding info for No Bus:ptysb
[  207.822974] device: 'ptysc': device_add
[  208.018966] PM: Adding info for No Bus:ptysc
[  208.089061] device: 'ptysd': device_add
[  208.291353] PM: Adding info for No Bus:ptysd
[  208.382047] device: 'ptyse': device_add
[  208.575305] PM: Adding info for No Bus:ptyse
[  208.655095] device: 'ptysf': device_add
[  208.845019] PM: Adding info for No Bus:ptysf
[  208.922343] device: 'ptyt0': device_add
[  209.115338] PM: Adding info for No Bus:ptyt0
[  209.191366] device: 'ptyt1': device_add
[  209.373078] PM: Adding info for No Bus:ptyt1
[  209.451119] device: 'ptyt2': device_add
[  209.651012] PM: Adding info for No Bus:ptyt2
[  209.721094] device: 'ptyt3': device_add
[  209.922998] PM: Adding info for No Bus:ptyt3
[  210.003316] device: 'ptyt4': device_add
[  210.198043] PM: Adding info for No Bus:ptyt4
[  210.274391] device: 'ptyt5': device_add
[  210.469321] PM: Adding info for No Bus:ptyt5
[  210.543988] device: 'ptyt6': device_add
[  210.739032] PM: Adding info for No Bus:ptyt6
[  210.817086] device: 'ptyt7': device_add
[  211.050386] PM: Adding info for No Bus:ptyt7
[  211.124369] device: 'ptyt8': device_add
[  211.309062] PM: Adding info for No Bus:ptyt8
[  211.388080] device: 'ptyt9': device_add
[  211.580067] PM: Adding info for No Bus:ptyt9
[  211.656923] device: 'ptyta': device_add
[  211.853061] PM: Adding info for No Bus:ptyta
[  211.929045] device: 'ptytb': device_add
[  212.123969] PM: Adding info for No Bus:ptytb
[  212.201119] device: 'ptytc': device_add
[  212.399049] PM: Adding info for No Bus:ptytc
[  212.470321] device: 'ptytd': device_add
[  212.664022] PM: Adding info for No Bus:ptytd
[  212.740353] device: 'ptyte': device_add
[  212.941989] PM: Adding info for No Bus:ptyte
[  213.021988] device: 'ptytf': device_add
[  213.215078] PM: Adding info for No Bus:ptytf
[  213.290325] device: 'ptyu0': device_add
[  213.489018] PM: Adding info for No Bus:ptyu0
[  213.560113] device: 'ptyu1': device_add
[  213.786065] PM: Adding info for No Bus:ptyu1
[  213.846998] device: 'ptyu2': device_add
[  214.047005] PM: Adding info for No Bus:ptyu2
[  214.122033] device: 'ptyu3': device_add
[  214.310032] PM: Adding info for No Bus:ptyu3
[  214.386998] device: 'ptyu4': device_add
[  214.571314] PM: Adding info for No Bus:ptyu4
[  214.640988] device: 'ptyu5': device_add
[  214.829931] PM: Adding info for No Bus:ptyu5
[  214.903047] device: 'ptyu6': device_add
[  215.121059] PM: Adding info for No Bus:ptyu6
[  215.201009] device: 'ptyu7': device_add
[  215.394054] PM: Adding info for No Bus:ptyu7
[  215.463308] device: 'ptyu8': device_add
[  215.645985] PM: Adding info for No Bus:ptyu8
[  215.717936] device: 'ptyu9': device_add
[  215.898395] PM: Adding info for No Bus:ptyu9
[  215.973330] device: 'ptyua': device_add
[  216.160375] PM: Adding info for No Bus:ptyua
[  216.228319] device: 'ptyub': device_add
[  216.410094] PM: Adding info for No Bus:ptyub
[  216.485346] device: 'ptyuc': device_add
[  216.685980] PM: Adding info for No Bus:ptyuc
[  216.752342] device: 'ptyud': device_add
[  216.949977] PM: Adding info for No Bus:ptyud
[  217.032106] device: 'ptyue': device_add
[  217.219985] PM: Adding info for No Bus:ptyue
[  217.290323] device: 'ptyuf': device_add
[  217.472025] PM: Adding info for No Bus:ptyuf
[  217.539090] device: 'ptyv0': device_add
[  217.702043]  4k 63998 large 3 gb 0 x 63486[ffff880000000000-ffff88000fdff000] miss 0
[  217.724027] PM: Adding info for No Bus:ptyv0
[  217.801020] device: 'ptyv1': device_add
[  217.985006] PM: Adding info for No Bus:ptyv1
[  218.062105] device: 'ptyv2': device_add
[  218.252014] PM: Adding info for No Bus:ptyv2
[  218.326024] device: 'ptyv3': device_add
[  218.534352] PM: Adding info for No Bus:ptyv3
[  218.606047] device: 'ptyv4': device_add
[  218.796027] PM: Adding info for No Bus:ptyv4
[  218.880389] device: 'ptyv5': device_add
[  219.092972] PM: Adding info for No Bus:ptyv5
[  219.161090] device: 'ptyv6': device_add
[  219.359019] PM: Adding info for No Bus:ptyv6
[  219.433966] device: 'ptyv7': device_add
[  219.635044] PM: Adding info for No Bus:ptyv7
[  219.708089] device: 'ptyv8': device_add
[  219.901332] PM: Adding info for No Bus:ptyv8
[  219.978015] device: 'ptyv9': device_add
[  220.178998] PM: Adding info for No Bus:ptyv9
[  220.250953] device: 'ptyva': device_add
[  220.447020] PM: Adding info for No Bus:ptyva
[  220.523120] device: 'ptyvb': device_add
[  220.727033] PM: Adding info for No Bus:ptyvb
[  220.796112] device: 'ptyvc': device_add
[  221.001022] PM: Adding info for No Bus:ptyvc
[  221.087973] device: 'ptyvd': device_add
[  221.286020] PM: Adding info for No Bus:ptyvd
[  221.366005] device: 'ptyve': device_add
[  221.560012] PM: Adding info for No Bus:ptyve
[  221.641341] device: 'ptyvf': device_add
[  221.833102] PM: Adding info for No Bus:ptyvf
[  221.927167] device: 'ptyw0': device_add
[  222.136052] PM: Adding info for No Bus:ptyw0
[  222.207091] device: 'ptyw1': device_add
[  222.412037] PM: Adding info for No Bus:ptyw1
[  222.482997] device: 'ptyw2': device_add
[  222.678961] PM: Adding info for No Bus:ptyw2
[  222.761046] device: 'ptyw3': device_add
[  222.962055] PM: Adding info for No Bus:ptyw3
[  223.038024] device: 'ptyw4': device_add
[  223.236073] PM: Adding info for No Bus:ptyw4
[  223.304341] device: 'ptyw5': device_add
[  223.504021] PM: Adding info for No Bus:ptyw5
[  223.584001] device: 'ptyw6': device_add
[  223.778997] PM: Adding info for No Bus:ptyw6
[  223.852325] device: 'ptyw7': device_add
[  224.272022] PM: Adding info for No Bus:ptyw7
[  224.354111] device: 'ptyw8': device_add
[  224.602032] PM: Adding info for No Bus:ptyw8
[  224.691042] device: 'ptyw9': device_add
[  224.900097] PM: Adding info for No Bus:ptyw9
[  224.989025] device: 'ptywa': device_add
[  225.223060] PM: Adding info for No Bus:ptywa
[  225.324032] device: 'ptywb': device_add
[  225.533043] PM: Adding info for No Bus:ptywb
[  225.616020] device: 'ptywc': device_add
[  225.831350] PM: Adding info for No Bus:ptywc
[  225.918033] device: 'ptywd': device_add
[  226.138055] PM: Adding info for No Bus:ptywd
[  226.215129] device: 'ptywe': device_add
[  226.420095] PM: Adding info for No Bus:ptywe
[  226.516020] device: 'ptywf': device_add
[  226.720144] PM: Adding info for No Bus:ptywf
[  226.806113] device: 'ptyx0': device_add
[  227.015121] PM: Adding info for No Bus:ptyx0
[  227.130077] device: 'ptyx1': device_add
[  227.342112] PM: Adding info for No Bus:ptyx1
[  227.423056] device: 'ptyx2': device_add
[  227.637084] PM: Adding info for No Bus:ptyx2
[  227.719057] device: 'ptyx3': device_add
[  227.934310] PM: Adding info for No Bus:ptyx3
[  228.024063] device: 'ptyx4': device_add
[  228.241104] PM: Adding info for No Bus:ptyx4
[  228.328042] device: 'ptyx5': device_add
[  228.533315] PM: Adding info for No Bus:ptyx5
[  228.612087] device: 'ptyx6': device_add
[  228.823073] PM: Adding info for No Bus:ptyx6
[  228.907311] device: 'ptyx7': device_add
[  229.128985] PM: Adding info for No Bus:ptyx7
[  229.216011] device: 'ptyx8': device_add
[  229.435096] PM: Adding info for No Bus:ptyx8
[  229.517972] device: 'ptyx9': device_add
[  229.729115] PM: Adding info for No Bus:ptyx9
[  229.812294] device: 'ptyxa': device_add
[  230.023292] PM: Adding info for No Bus:ptyxa
[  230.111933] device: 'ptyxb': device_add
[  230.327134] PM: Adding info for No Bus:ptyxb
[  230.402060] device: 'ptyxc': device_add
[  230.614072] PM: Adding info for No Bus:ptyxc
[  230.702078] device: 'ptyxd': device_add
[  230.921964] PM: Adding info for No Bus:ptyxd
[  231.004075] device: 'ptyxe': device_add
[  231.217050] PM: Adding info for No Bus:ptyxe
[  231.311060] device: 'ptyxf': device_add
[  231.518066] PM: Adding info for No Bus:ptyxf
[  231.601347] device: 'ptyy0': device_add
[  231.801331] PM: Adding info for No Bus:ptyy0
[  231.872347] device: 'ptyy1': device_add
[  232.081351] PM: Adding info for No Bus:ptyy1
[  232.163367] device: 'ptyy2': device_add
[  232.366084] PM: Adding info for No Bus:ptyy2
[  232.448032] device: 'ptyy3': device_add
[  232.648046] PM: Adding info for No Bus:ptyy3
[  232.731066] device: 'ptyy4': device_add
[  232.936095] PM: Adding info for No Bus:ptyy4
[  233.021002] device: 'ptyy5': device_add
[  233.223085] PM: Adding info for No Bus:ptyy5
[  233.302095] device: 'ptyy6': device_add
[  233.518050] PM: Adding info for No Bus:ptyy6
[  233.608005] device: 'ptyy7': device_add
[  233.686379]  4k 63998 large 3 gb 0 x 63486[ffff880000000000-ffff88000fdff000] miss 0
[  233.694332] ok.
[  233.775020] PM: Adding info for No Bus:ptyy7
[  233.824135] device: 'ptyy8': device_add
[  233.964334] PM: Adding info for No Bus:ptyy8
[  234.016953] device: 'ptyy9': device_add
[  234.169402] PM: Adding info for No Bus:ptyy9
[  234.237078] device: 'ptyya': device_add
[  234.362127] PM: Adding info for No Bus:ptyya
[  234.418093] device: 'ptyyb': device_add
[  234.560115] PM: Adding info for No Bus:ptyyb
[  234.614012] device: 'ptyyc': device_add
[  234.755328] PM: Adding info for No Bus:ptyyc
[  234.810350] device: 'ptyyd': device_add
[  234.948117] PM: Adding info for No Bus:ptyyd
[  235.001054] device: 'ptyye': device_add
[  235.153354] PM: Adding info for No Bus:ptyye
[  235.214379] device: 'ptyyf': device_add
[  235.355023] PM: Adding info for No Bus:ptyyf
[  235.403082] device: 'ptyz0': device_add
[  235.543283] PM: Adding info for No Bus:ptyz0
[  235.591057] device: 'ptyz1': device_add
[  235.726991] PM: Adding info for No Bus:ptyz1
[  235.784980] device: 'ptyz2': device_add
[  235.942120] PM: Adding info for No Bus:ptyz2
[  236.012102] device: 'ptyz3': device_add
[  236.156346] PM: Adding info for No Bus:ptyz3
[  236.208136] device: 'ptyz4': device_add
[  236.339019] PM: Adding info for No Bus:ptyz4
[  236.395097] device: 'ptyz5': device_add
[  236.530028] PM: Adding info for No Bus:ptyz5
[  236.590094] device: 'ptyz6': device_add
[  236.728971] PM: Adding info for No Bus:ptyz6
[  236.781349] device: 'ptyz7': device_add
[  236.916308] PM: Adding info for No Bus:ptyz7
[  236.965988] device: 'ptyz8': device_add
[  237.096343] PM: Adding info for No Bus:ptyz8
[  237.146932] device: 'ptyz9': device_add
[  237.287369] PM: Adding info for No Bus:ptyz9
[  237.345951] device: 'ptyza': device_add
[  237.481095] PM: Adding info for No Bus:ptyza
[  237.536127] device: 'ptyzb': device_add
[  237.684133] PM: Adding info for No Bus:ptyzb
[  237.743334] device: 'ptyzc': device_add
[  237.888124] PM: Adding info for No Bus:ptyzc
[  237.940123] device: 'ptyzd': device_add
[  238.088963] PM: Adding info for No Bus:ptyzd
[  238.149068] device: 'ptyze': device_add
[  238.278111] PM: Adding info for No Bus:ptyze
[  238.333311] device: 'ptyzf': device_add
[  238.474030] PM: Adding info for No Bus:ptyzf
[  238.526714] device: 'ptya0': device_add
[  238.626960] PM: Adding info for No Bus:ptya0
[  238.677085] device: 'ptya1': device_add
[  238.815033] PM: Adding info for No Bus:ptya1
[  238.868092] device: 'ptya2': device_add
[  239.002137] PM: Adding info for No Bus:ptya2
[  239.051112] device: 'ptya3': device_add
[  239.198037] PM: Adding info for No Bus:ptya3
[  239.250127] device: 'ptya4': device_add
[  239.407121] PM: Adding info for No Bus:ptya4
[  239.459057] device: 'ptya5': device_add
[  239.598122] PM: Adding info for No Bus:ptya5
[  239.653100] device: 'ptya6': device_add
[  239.791042] PM: Adding info for No Bus:ptya6
[  239.843130] device: 'ptya7': device_add
[  239.979018] PM: Adding info for No Bus:ptya7
[  240.032070] device: 'ptya8': device_add
[  240.163951] PM: Adding info for No Bus:ptya8
[  240.219108] device: 'ptya9': device_add
[  240.361069] PM: Adding info for No Bus:ptya9
[  240.409329] device: 'ptyaa': device_add
[  240.568311] PM: Adding info for No Bus:ptyaa
[  240.625347] device: 'ptyab': device_add
[  240.777008] PM: Adding info for No Bus:ptyab
[  240.830078] device: 'ptyac': device_add
[  240.964318] PM: Adding info for No Bus:ptyac
[  241.018106] device: 'ptyad': device_add
[  241.155315] PM: Adding info for No Bus:ptyad
[  241.218124] device: 'ptyae': device_add
[  241.360977] PM: Adding info for No Bus:ptyae
[  241.408970] device: 'ptyaf': device_add
[  241.564974] PM: Adding info for No Bus:ptyaf
[  241.628113] device: 'ptyb0': device_add
[  241.765054] PM: Adding info for No Bus:ptyb0
[  241.816090] device: 'ptyb1': device_add
[  241.971983] PM: Adding info for No Bus:ptyb1
[  242.024128] device: 'ptyb2': device_add
[  242.158135] PM: Adding info for No Bus:ptyb2
[  242.217045] device: 'ptyb3': device_add
[  242.338038] PM: Adding info for No Bus:ptyb3
[  242.388084] device: 'ptyb4': device_add
[  242.543366] PM: Adding info for No Bus:ptyb4
[  242.600070] device: 'ptyb5': device_add
[  242.722336] PM: Adding info for No Bus:ptyb5
[  242.775993] device: 'ptyb6': device_add
[  242.916955] PM: Adding info for No Bus:ptyb6
[  242.970121] device: 'ptyb7': device_add
[  243.261129] PM: Adding info for No Bus:ptyb7
[  243.316131] device: 'ptyb8': device_add
[  243.474972] PM: Adding info for No Bus:ptyb8
[  243.532098] device: 'ptyb9': device_add
[  243.672967] PM: Adding info for No Bus:ptyb9
[  243.727060] device: 'ptyba': device_add
[  243.866359] PM: Adding info for No Bus:ptyba
[  243.913066] device: 'ptybb': device_add
[  244.056310] PM: Adding info for No Bus:ptybb
[  244.111973] device: 'ptybc': device_add
[  244.261021] PM: Adding info for No Bus:ptybc
[  244.310001] device: 'ptybd': device_add
[  244.444336] PM: Adding info for No Bus:ptybd
[  244.506997] device: 'ptybe': device_add
[  244.642965] PM: Adding info for No Bus:ptybe
[  244.693350] device: 'ptybf': device_add
[  244.837137] PM: Adding info for No Bus:ptybf
[  244.887004] device: 'ptyc0': device_add
[  245.013317] PM: Adding info for No Bus:ptyc0
[  245.065026] device: 'ptyc1': device_add
[  245.198010] PM: Adding info for No Bus:ptyc1
[  245.254114] device: 'ptyc2': device_add
[  245.392028] PM: Adding info for No Bus:ptyc2
[  245.443137] device: 'ptyc3': device_add
[  245.583378] PM: Adding info for No Bus:ptyc3
[  245.637973] device: 'ptyc4': device_add
[  245.764133] PM: Adding info for No Bus:ptyc4
[  245.813332] device: 'ptyc5': device_add
[  245.950025] PM: Adding info for No Bus:ptyc5
[  246.013966] device: 'ptyc6': device_add
[  246.140124] PM: Adding info for No Bus:ptyc6
[  246.190959] device: 'ptyc7': device_add
[  246.330024] PM: Adding info for No Bus:ptyc7
[  246.381306] device: 'ptyc8': device_add
[  246.531342] PM: Adding info for No Bus:ptyc8
[  246.596107] device: 'ptyc9': device_add
[  246.736311] PM: Adding info for No Bus:ptyc9
[  246.785102] device: 'ptyca': device_add
[  246.918951] PM: Adding info for No Bus:ptyca
[  246.984309] device: 'ptycb': device_add
[  247.117122] PM: Adding info for No Bus:ptycb
[  247.173133] device: 'ptycc': device_add
[  247.313128] PM: Adding info for No Bus:ptycc
[  247.371962] device: 'ptycd': device_add
[  247.491127] PM: Adding info for No Bus:ptycd
[  247.544104] device: 'ptyce': device_add
[  247.677963] PM: Adding info for No Bus:ptyce
[  247.726313] device: 'ptycf': device_add
[  247.860097] PM: Adding info for No Bus:ptycf
[  247.913083] device: 'ptyd0': device_add
[  248.052136] PM: Adding info for No Bus:ptyd0
[  248.100041] device: 'ptyd1': device_add
[  248.239313] PM: Adding info for No Bus:ptyd1
[  248.293345] device: 'ptyd2': device_add
[  248.439361] PM: Adding info for No Bus:ptyd2
[  248.506101] device: 'ptyd3': device_add
[  248.642330] PM: Adding info for No Bus:ptyd3
[  248.691000] device: 'ptyd4': device_add
[  248.828127] PM: Adding info for No Bus:ptyd4
[  248.899018] device: 'ptyd5': device_add
[  249.052951] PM: Adding info for No Bus:ptyd5
[  249.106070] device: 'ptyd6': device_add
[  249.255343] PM: Adding info for No Bus:ptyd6
[  249.306034] device: 'ptyd7': device_add
[  249.440971] PM: Adding info for No Bus:ptyd7
[  249.493103] device: 'ptyd8': device_add
[  249.639305] PM: Adding info for No Bus:ptyd8
[  249.691950] device: 'ptyd9': device_add
[  249.816123] PM: Adding info for No Bus:ptyd9
[  249.871310] device: 'ptyda': device_add
[  250.008030] PM: Adding info for No Bus:ptyda
[  250.056104] device: 'ptydb': device_add
[  250.190320] PM: Adding info for No Bus:ptydb
[  250.245975] device: 'ptydc': device_add
[  250.401349] PM: Adding info for No Bus:ptydc
[  250.449340] device: 'ptydd': device_add
[  250.585327] PM: Adding info for No Bus:ptydd
[  250.635954] device: 'ptyde': device_add
[  250.776135] PM: Adding info for No Bus:ptyde
[  250.823063] device: 'ptydf': device_add
[  250.959302] PM: Adding info for No Bus:ptydf
[  251.023315] device: 'ptye0': device_add
[  251.153084] PM: Adding info for No Bus:ptye0
[  251.208115] device: 'ptye1': device_add
[  251.354056] PM: Adding info for No Bus:ptye1
[  251.414970] device: 'ptye2': device_add
[  251.542359] PM: Adding info for No Bus:ptye2
[  251.596043] device: 'ptye3': device_add
[  251.736105] PM: Adding info for No Bus:ptye3
[  251.787044] device: 'ptye4': device_add
[  251.920038] PM: Adding info for No Bus:ptye4
[  251.974001] device: 'ptye5': device_add
[  252.105000] PM: Adding info for No Bus:ptye5
[  252.153318] device: 'ptye6': device_add
[  252.299385] PM: Adding info for No Bus:ptye6
[  252.347025] device: 'ptye7': device_add
[  252.494075] PM: Adding info for No Bus:ptye7
[  252.544128] device: 'ptye8': device_add
[  252.679059] PM: Adding info for No Bus:ptye8
[  252.736134] device: 'ptye9': device_add
[  252.886111] PM: Adding info for No Bus:ptye9
[  252.935103] device: 'ptyea': device_add
[  253.076302] PM: Adding info for No Bus:ptyea
[  253.124116] device: 'ptyeb': device_add
[  253.267054] PM: Adding info for No Bus:ptyeb
[  253.315042] device: 'ptyec': device_add
[  253.450332] PM: Adding info for No Bus:ptyec
[  253.513344] device: 'ptyed': device_add
[  253.654993] PM: Adding info for No Bus:ptyed
[  253.698327] device: 'ptyee': device_add
[  253.831335] PM: Adding info for No Bus:ptyee
[  253.897121] device: 'ptyef': device_add
[  254.040102] PM: Adding info for No Bus:ptyef
[  254.119315] device: 'ttyp0': device_add
[  254.278351] PM: Adding info for No Bus:ttyp0
[  254.316923] device: 'ttyp1': device_add
[  254.463993] PM: Adding info for No Bus:ttyp1
[  254.517047] device: 'ttyp2': device_add
[  254.644398] PM: Adding info for No Bus:ttyp2
[  254.692977] device: 'ttyp3': device_add
[  254.831093] PM: Adding info for No Bus:ttyp3
[  254.893002] device: 'ttyp4': device_add
[  255.018357] PM: Adding info for No Bus:ttyp4
[  255.070992] device: 'ttyp5': device_add
[  255.207098] PM: Adding info for No Bus:ttyp5
[  255.278095] device: 'ttyp6': device_add
[  255.418129] PM: Adding info for No Bus:ttyp6
[  255.471084] device: 'ttyp7': device_add
[  255.612963] PM: Adding info for No Bus:ttyp7
[  255.664132] device: 'ttyp8': device_add
[  255.792289] PM: Adding info for No Bus:ttyp8
[  255.846323] device: 'ttyp9': device_add
[  255.988343] PM: Adding info for No Bus:ttyp9
[  256.046072] device: 'ttypa': device_add
[  256.174103] PM: Adding info for No Bus:ttypa
[  256.227107] device: 'ttypb': device_add
[  256.371375] PM: Adding info for No Bus:ttypb
[  256.417067] device: 'ttypc': device_add
[  256.558126] PM: Adding info for No Bus:ttypc
[  256.609119] device: 'ttypd': device_add
[  256.748295] PM: Adding info for No Bus:ttypd
[  256.799119] device: 'ttype': device_add
[  256.943952] PM: Adding info for No Bus:ttype
[  256.992941] device: 'ttypf': device_add
[  257.123025] PM: Adding info for No Bus:ttypf
[  257.174138] device: 'ttyq0': device_add
[  257.338059] PM: Adding info for No Bus:ttyq0
[  257.399346] device: 'ttyq1': device_add
[  257.522030] PM: Adding info for No Bus:ttyq1
[  257.578093] device: 'ttyq2': device_add
[  257.716136] PM: Adding info for No Bus:ttyq2
[  257.770070] device: 'ttyq3': device_add
[  257.904379] PM: Adding info for No Bus:ttyq3
[  257.968066] device: 'ttyq4': device_add
[  258.108354] PM: Adding info for No Bus:ttyq4
[  258.163365] device: 'ttyq5': device_add
[  258.323344] PM: Adding info for No Bus:ttyq5
[  258.374967] device: 'ttyq6': device_add
[  258.504132] PM: Adding info for No Bus:ttyq6
[  258.558971] device: 'ttyq7': device_add
[  258.817117] PM: Adding info for No Bus:ttyq7
[  258.869136] device: 'ttyq8': device_add
[  259.053310] PM: Adding info for No Bus:ttyq8
[  259.106133] device: 'ttyq9': device_add
[  259.245014] PM: Adding info for No Bus:ttyq9
[  259.295096] device: 'ttyqa': device_add
[  259.440371] PM: Adding info for No Bus:ttyqa
[  259.495164] device: 'ttyqb': device_add
[  259.636024] PM: Adding info for No Bus:ttyqb
[  259.686375] device: 'ttyqc': device_add
[  259.822971] PM: Adding info for No Bus:ttyqc
[  259.871019] device: 'ttyqd': device_add
[  260.010054] PM: Adding info for No Bus:ttyqd
[  260.055099] device: 'ttyqe': device_add
[  260.209971] PM: Adding info for No Bus:ttyqe
[  260.262971] device: 'ttyqf': device_add
[  260.395000] PM: Adding info for No Bus:ttyqf
[  260.449057] device: 'ttyr0': device_add
[  260.581134] PM: Adding info for No Bus:ttyr0
[  260.631114] device: 'ttyr1': device_add
[  260.769311] PM: Adding info for No Bus:ttyr1
[  260.817382] device: 'ttyr2': device_add
[  260.958051] PM: Adding info for No Bus:ttyr2
[  261.000095] device: 'ttyr3': device_add
[  261.138128] PM: Adding info for No Bus:ttyr3
[  261.200361] device: 'ttyr4': device_add
[  261.347995] PM: Adding info for No Bus:ttyr4
[  261.398353] device: 'ttyr5': device_add
[  261.525354] PM: Adding info for No Bus:ttyr5
[  261.575026] device: 'ttyr6': device_add
[  261.704145] PM: Adding info for No Bus:ttyr6
[  261.761133] device: 'ttyr7': device_add
[  261.894000] PM: Adding info for No Bus:ttyr7
[  261.947117] device: 'ttyr8': device_add
[  262.084139] PM: Adding info for No Bus:ttyr8
[  262.143078] device: 'ttyr9': device_add
[  262.306350] PM: Adding info for No Bus:ttyr9
[  262.357092] device: 'ttyra': device_add
[  262.495944] PM: Adding info for No Bus:ttyra
[  262.548020] device: 'ttyrb': device_add
[  262.671980] PM: Adding info for No Bus:ttyrb
[  262.722074] device: 'ttyrc': device_add
[  262.854357] PM: Adding info for No Bus:ttyrc
[  262.907339] device: 'ttyrd': device_add
[  263.036366] PM: Adding info for No Bus:ttyrd
[  263.092038] device: 'ttyre': device_add
[  263.252102] PM: Adding info for No Bus:ttyre
[  263.314363] device: 'ttyrf': device_add
[  263.456366] PM: Adding info for No Bus:ttyrf
[  263.519137] device: 'ttys0': device_add
[  263.663059] PM: Adding info for No Bus:ttys0
[  263.709071] device: 'ttys1': device_add
[  263.862300] PM: Adding info for No Bus:ttys1
[  263.934009] device: 'ttys2': device_add
[  264.142025] PM: Adding info for No Bus:ttys2
[  264.220160] device: 'ttys3': device_add
[  264.431061] PM: Adding info for No Bus:ttys3
[  264.509130] device: 'ttys4': device_add
[  264.721115] PM: Adding info for No Bus:ttys4
[  264.797070] device: 'ttys5': device_add
[  264.999059] PM: Adding info for No Bus:ttys5
[  265.075984] device: 'ttys6': device_add
[  265.283104] PM: Adding info for No Bus:ttys6
[  265.373347] device: 'ttys7': device_add
[  265.576311] PM: Adding info for No Bus:ttys7
[  265.652009] device: 'ttys8': device_add
[  265.853094] PM: Adding info for No Bus:ttys8
[  265.933017] device: 'ttys9': device_add
[  266.129033] PM: Adding info for No Bus:ttys9
[  266.207354] device: 'ttysa': device_add
[  266.424058] PM: Adding info for No Bus:ttysa
[  266.517986] device: 'ttysb': device_add
[  266.721341] PM: Adding info for No Bus:ttysb
[  266.802017] device: 'ttysc': device_add
[  267.010061] PM: Adding info for No Bus:ttysc
[  267.097119] device: 'ttysd': device_add
[  267.312101] PM: Adding info for No Bus:ttysd
[  267.410139] device: 'ttyse': device_add
[  267.624354] PM: Adding info for No Bus:ttyse
[  267.703036] device: 'ttysf': device_add
[  267.920327] PM: Adding info for No Bus:ttysf
[  268.006099] device: 'ttyt0': device_add
[  268.222076] PM: Adding info for No Bus:ttyt0
[  268.302020] device: 'ttyt1': device_add
[  268.507052] PM: Adding info for No Bus:ttyt1
[  268.590011] device: 'ttyt2': device_add
[  268.809103] PM: Adding info for No Bus:ttyt2
[  268.888065] device: 'ttyt3': device_add
[  269.121297] PM: Adding info for No Bus:ttyt3
[  269.208006] device: 'ttyt4': device_add
[  269.443046] PM: Adding info for No Bus:ttyt4
[  269.524079] device: 'ttyt5': device_add
[  269.715093] PM: Adding info for No Bus:ttyt5
[  269.795037] device: 'ttyt6': device_add
[  269.993034] PM: Adding info for No Bus:ttyt6
[  270.063944] device: 'ttyt7': device_add
[  270.262329] PM: Adding info for No Bus:ttyt7
[  270.329965] device: 'ttyt8': device_add
[  270.520119] PM: Adding info for No Bus:ttyt8
[  270.593093] device: 'ttyt9': device_add
[  270.782037] PM: Adding info for No Bus:ttyt9
[  270.851993] device: 'ttyta': device_add
[  271.053073] PM: Adding info for No Bus:ttyta
[  271.133000] device: 'ttytb': device_add
[  271.325065] PM: Adding info for No Bus:ttytb
[  271.402351] device: 'ttytc': device_add
[  271.614032] PM: Adding info for No Bus:ttytc
[  271.687374] device: 'ttytd': device_add
[  271.873978] PM: Adding info for No Bus:ttytd
[  271.949318] device: 'ttyte': device_add
[  272.150081] PM: Adding info for No Bus:ttyte
[  272.220360] device: 'ttytf': device_add
[  272.423036] PM: Adding info for No Bus:ttytf
[  272.498016] device: 'ttyu0': device_add
[  272.696043] PM: Adding info for No Bus:ttyu0
[  272.773975] device: 'ttyu1': device_add
[  272.967383] PM: Adding info for No Bus:ttyu1
[  273.047965] device: 'ttyu2': device_add
[  273.250013] PM: Adding info for No Bus:ttyu2
[  273.327971] device: 'ttyu3': device_add
[  273.530047] PM: Adding info for No Bus:ttyu3
[  273.601071] device: 'ttyu4': device_add
[  273.782374] PM: Adding info for No Bus:ttyu4
[  273.875117] device: 'ttyu5': device_add
[  274.124066] PM: Adding info for No Bus:ttyu5
[  274.213963] device: 'ttyu6': device_add
[  274.483047] PM: Adding info for No Bus:ttyu6
[  274.583047] device: 'ttyu7': device_add
[  274.813056] PM: Adding info for No Bus:ttyu7
[  274.917109] device: 'ttyu8': device_add
[  275.106006] PM: Adding info for No Bus:ttyu8
[  275.178959] device: 'ttyu9': device_add
[  275.370994] PM: Adding info for No Bus:ttyu9
[  275.448955] device: 'ttyua': device_add
[  275.645069] PM: Adding info for No Bus:ttyua
[  275.718339] device: 'ttyub': device_add
[  275.906008] PM: Adding info for No Bus:ttyub
[  275.976997] device: 'ttyuc': device_add
[  276.172089] PM: Adding info for No Bus:ttyuc
[  276.248343] device: 'ttyud': device_add
[  276.438036] PM: Adding info for No Bus:ttyud
[  276.514995] device: 'ttyue': device_add
[  276.711000] PM: Adding info for No Bus:ttyue
[  276.783116] device: 'ttyuf': device_add
[  276.986005] PM: Adding info for No Bus:ttyuf
[  277.055978] device: 'ttyv0': device_add
[  277.248078] PM: Adding info for No Bus:ttyv0
[  277.326117] device: 'ttyv1': device_add
[  277.522992] PM: Adding info for No Bus:ttyv1
[  277.599996] device: 'ttyv2': device_add
[  277.800058] PM: Adding info for No Bus:ttyv2
[  277.879032] device: 'ttyv3': device_add
[  278.071014] PM: Adding info for No Bus:ttyv3
[  278.146129] device: 'ttyv4': device_add
[  278.342100] PM: Adding info for No Bus:ttyv4
[  278.427103] device: 'ttyv5': device_add
[  278.617100] PM: Adding info for No Bus:ttyv5
[  278.695087] device: 'ttyv6': device_add
[  278.879959] PM: Adding info for No Bus:ttyv6
[  278.958992] device: 'ttyv7': device_add
[  279.341018] PM: Adding info for No Bus:ttyv7
[  279.418031] device: 'ttyv8': device_add
[  279.705992] PM: Adding info for No Bus:ttyv8
[  279.794955] device: 'ttyv9': device_add
[  280.023085] PM: Adding info for No Bus:ttyv9
[  280.119071] device: 'ttyva': device_add
[  280.370963] PM: Adding info for No Bus:ttyva
[  280.474334] device: 'ttyvb': device_add
[  280.712984] PM: Adding info for No Bus:ttyvb
[  280.795001] device: 'ttyvc': device_add
[  281.018086] PM: Adding info for No Bus:ttyvc
[  281.108334] device: 'ttyvd': device_add
[  281.322060] PM: Adding info for No Bus:ttyvd
[  281.417139] device: 'ttyve': device_add
[  281.647048] PM: Adding info for No Bus:ttyve
[  281.742067] device: 'ttyvf': device_add
[  281.960995] PM: Adding info for No Bus:ttyvf
[  282.054345] device: 'ttyw0': device_add
[  282.281308] PM: Adding info for No Bus:ttyw0
[  282.367002] device: 'ttyw1': device_add
[  282.585035] PM: Adding info for No Bus:ttyw1
[  282.681992] device: 'ttyw2': device_add
[  282.888025] PM: Adding info for No Bus:ttyw2
[  282.969004] device: 'ttyw3': device_add
[  283.173354] PM: Adding info for No Bus:ttyw3
[  283.256087] device: 'ttyw4': device_add
[  283.496097] PM: Adding info for No Bus:ttyw4
[  283.579108] device: 'ttyw5': device_add
[  283.797312] PM: Adding info for No Bus:ttyw5
[  283.846338] device: 'ttyw6': device_add
[  284.045940] PM: Adding info for No Bus:ttyw6
[  284.120126] device: 'ttyw7': device_add
[  284.321118] PM: Adding info for No Bus:ttyw7
[  284.394956] device: 'ttyw8': device_add
[  284.661340] PM: Adding info for No Bus:ttyw8
[  284.774002] device: 'ttyw9': device_add
[  284.960980] PM: Adding info for No Bus:ttyw9
[  285.040931] device: 'ttywa': device_add
[  285.238071] PM: Adding info for No Bus:ttywa
[  285.314121] device: 'ttywb': device_add
[  285.518974] PM: Adding info for No Bus:ttywb
[  285.599342] device: 'ttywc': device_add
[  285.785125] PM: Adding info for No Bus:ttywc
[  285.863982] device: 'ttywd': device_add
[  286.061307] PM: Adding info for No Bus:ttywd
[  286.132113] device: 'ttywe': device_add
[  286.329989] PM: Adding info for No Bus:ttywe
[  286.416065] device: 'ttywf': device_add
[  286.599969] PM: Adding info for No Bus:ttywf
[  286.668994] device: 'ttyx0': device_add
[  286.849830] PM: Adding info for No Bus:ttyx0
[  286.953970] device: 'ttyx1': device_add
[  287.187112] PM: Adding info for No Bus:ttyx1
[  287.263315] device: 'ttyx2': device_add
[  287.475049] PM: Adding info for No Bus:ttyx2
[  287.555038] device: 'ttyx3': device_add
[  287.762057] PM: Adding info for No Bus:ttyx3
[  287.843295] device: 'ttyx4': device_add
[  288.061974] PM: Adding info for No Bus:ttyx4
[  288.137983] device: 'ttyx5': device_add
[  288.341048] PM: Adding info for No Bus:ttyx5
[  288.420290] device: 'ttyx6': device_add
[  288.631087] PM: Adding info for No Bus:ttyx6
[  288.708015] device: 'ttyx7': device_add
[  288.916042] PM: Adding info for No Bus:ttyx7
[  289.001129] device: 'ttyx8': device_add
[  289.206094] PM: Adding info for No Bus:ttyx8
[  289.278114] device: 'ttyx9': device_add
[  289.491117] PM: Adding info for No Bus:ttyx9
[  289.571113] device: 'ttyxa': device_add
[  289.788099] PM: Adding info for No Bus:ttyxa
[  289.896334] device: 'ttyxb': device_add
[  290.115052] PM: Adding info for No Bus:ttyxb
[  290.205008] device: 'ttyxc': device_add
[  290.404109] PM: Adding info for No Bus:ttyxc
[  290.488310] device: 'ttyxd': device_add
[  290.706080] PM: Adding info for No Bus:ttyxd
[  290.798016] device: 'ttyxe': device_add
[  291.000026] PM: Adding info for No Bus:ttyxe
[  291.080114] device: 'ttyxf': device_add
[  291.289064] PM: Adding info for No Bus:ttyxf
[  291.373994] device: 'ttyy0': device_add
[  291.594070] PM: Adding info for No Bus:ttyy0
[  291.678037] device: 'ttyy1': device_add
[  291.880106] PM: Adding info for No Bus:ttyy1
[  291.964995] device: 'ttyy2': device_add
[  292.168055] PM: Adding info for No Bus:ttyy2
[  292.248330] device: 'ttyy3': device_add
[  292.462361] PM: Adding info for No Bus:ttyy3
[  292.541079] device: 'ttyy4': device_add
[  292.759062] PM: Adding info for No Bus:ttyy4
[  292.843342] device: 'ttyy5': device_add
[  293.049131] PM: Adding info for No Bus:ttyy5
[  293.132019] device: 'ttyy6': device_add
[  293.334317] PM: Adding info for No Bus:ttyy6
[  293.418048] device: 'ttyy7': device_add
[  293.624101] PM: Adding info for No Bus:ttyy7
[  293.700061] device: 'ttyy8': device_add
[  293.920055] PM: Adding info for No Bus:ttyy8
[  294.016342] device: 'ttyy9': device_add
[  294.225069] PM: Adding info for No Bus:ttyy9
[  294.307093] device: 'ttyya': device_add
[  294.519052] PM: Adding info for No Bus:ttyya
[  294.603982] device: 'ttyyb': device_add
[  294.805358] PM: Adding info for No Bus:ttyyb
[  294.877057] device: 'ttyyc': device_add
[  295.086125] PM: Adding info for No Bus:ttyyc
[  295.168337] device: 'ttyyd': device_add
[  295.390020] PM: Adding info for No Bus:ttyyd
[  295.473155] device: 'ttyye': device_add
[  295.691012] PM: Adding info for No Bus:ttyye
[  295.765041] device: 'ttyyf': device_add
[  295.971100] PM: Adding info for No Bus:ttyyf
[  296.072047] device: 'ttyz0': device_add
[  296.295085] PM: Adding info for No Bus:ttyz0
[  296.375316] device: 'ttyz1': device_add
[  296.611008] PM: Adding info for No Bus:ttyz1
[  296.692136] device: 'ttyz2': device_add
[  296.897049] PM: Adding info for No Bus:ttyz2
[  297.001042] device: 'ttyz3': device_add
[  297.199021] PM: Adding info for No Bus:ttyz3
[  297.273965] device: 'ttyz4': device_add
[  297.479036] PM: Adding info for No Bus:ttyz4
[  297.558980] device: 'ttyz5': device_add
[  297.758019] PM: Adding info for No Bus:ttyz5
[  297.836003] device: 'ttyz6': device_add
[  298.035009] PM: Adding info for No Bus:ttyz6
[  298.115349] device: 'ttyz7': device_add
[  298.331370] PM: Adding info for No Bus:ttyz7
[  298.412944] device: 'ttyz8': device_add
[  298.615054] PM: Adding info for No Bus:ttyz8
[  298.690993] device: 'ttyz9': device_add
[  298.887062] PM: Adding info for No Bus:ttyz9
[  298.953996] device: 'ttyza': device_add
[  299.150031] PM: Adding info for No Bus:ttyza
[  299.226977] device: 'ttyzb': device_add
[  299.399038] PM: Adding info for No Bus:ttyzb
[  299.453984] device: 'ttyzc': device_add
[  299.602349] PM: Adding info for No Bus:ttyzc
[  299.649078] device: 'ttyzd': device_add
[  299.774119] PM: Adding info for No Bus:ttyzd
[  299.820102] device: 'ttyze': device_add
[  299.963357] PM: Adding info for No Bus:ttyze
[  300.015101] device: 'ttyzf': device_add
[  300.133327] PM: Adding info for No Bus:ttyzf
[  300.187079] device: 'ttya0': device_add
[  300.316094] PM: Adding info for No Bus:ttya0
[  300.365121] device: 'ttya1': device_add
[  300.498161] PM: Adding info for No Bus:ttya1
[  300.545983] device: 'ttya2': device_add
[  300.665078] PM: Adding info for No Bus:ttya2
[  300.720997] device: 'ttya3': device_add
[  300.855047] PM: Adding info for No Bus:ttya3
[  300.897101] device: 'ttya4': device_add
[  301.030136] PM: Adding info for No Bus:ttya4
[  301.081032] device: 'ttya5': device_add
[  301.220990] PM: Adding info for No Bus:ttya5
[  301.268296] device: 'ttya6': device_add
[  301.403015] PM: Adding info for No Bus:ttya6
[  301.448316] device: 'ttya7': device_add
[  301.708115] PM: Adding info for No Bus:ttya7
[  301.743327] device: 'ttya8': device_add
[  301.911120] PM: Adding info for No Bus:ttya8
[  301.959022] device: 'ttya9': device_add
[  302.091965] PM: Adding info for No Bus:ttya9
[  302.140086] device: 'ttyaa': device_add
[  302.280050] PM: Adding info for No Bus:ttyaa
[  302.333116] device: 'ttyab': device_add
[  302.477346] PM: Adding info for No Bus:ttyab
[  302.529032] device: 'ttyac': device_add
[  302.663339] PM: Adding info for No Bus:ttyac
[  302.717026] device: 'ttyad': device_add
[  302.843336] PM: Adding info for No Bus:ttyad
[  302.888006] device: 'ttyae': device_add
[  303.020358] PM: Adding info for No Bus:ttyae
[  303.067040] device: 'ttyaf': device_add
[  303.203393] PM: Adding info for No Bus:ttyaf
[  303.252079] device: 'ttyb0': device_add
[  303.382054] PM: Adding info for No Bus:ttyb0
[  303.434961] device: 'ttyb1': device_add
[  303.559053] PM: Adding info for No Bus:ttyb1
[  303.611005] device: 'ttyb2': device_add
[  303.741141] PM: Adding info for No Bus:ttyb2
[  303.786128] device: 'ttyb3': device_add
[  303.923290] PM: Adding info for No Bus:ttyb3
[  303.973324] device: 'ttyb4': device_add
[  304.114322] PM: Adding info for No Bus:ttyb4
[  304.158036] device: 'ttyb5': device_add
[  304.292112] PM: Adding info for No Bus:ttyb5
[  304.334345] device: 'ttyb6': device_add
[  304.468301] PM: Adding info for No Bus:ttyb6
[  304.521040] device: 'ttyb7': device_add
[  304.654974] PM: Adding info for No Bus:ttyb7
[  304.703094] device: 'ttyb8': device_add
[  304.827305] PM: Adding info for No Bus:ttyb8
[  304.873961] device: 'ttyb9': device_add
[  305.017080] PM: Adding info for No Bus:ttyb9
[  305.069283] device: 'ttyba': device_add
[  305.204023] PM: Adding info for No Bus:ttyba
[  305.248073] device: 'ttybb': device_add
[  305.377322] PM: Adding info for No Bus:ttybb
[  305.431027] device: 'ttybc': device_add
[  305.570326] PM: Adding info for No Bus:ttybc
[  305.623115] device: 'ttybd': device_add
[  305.750334] PM: Adding info for No Bus:ttybd
[  305.801009] device: 'ttybe': device_add
[  305.935045] PM: Adding info for No Bus:ttybe
[  305.983999] device: 'ttybf': device_add
[  306.111965] PM: Adding info for No Bus:ttybf
[  306.161066] device: 'ttyc0': device_add
[  306.297977] PM: Adding info for No Bus:ttyc0
[  306.353077] device: 'ttyc1': device_add
[  306.485070] PM: Adding info for No Bus:ttyc1
[  306.542089] device: 'ttyc2': device_add
[  306.681295] PM: Adding info for No Bus:ttyc2
[  306.737115] device: 'ttyc3': device_add
[  306.867993] PM: Adding info for No Bus:ttyc3
[  306.918036] device: 'ttyc4': device_add
[  307.070158] PM: Adding info for No Bus:ttyc4
[  307.124000] device: 'ttyc5': device_add
[  307.252111] PM: Adding info for No Bus:ttyc5
[  307.300127] device: 'ttyc6': device_add
[  307.439364] PM: Adding info for No Bus:ttyc6
[  307.486086] device: 'ttyc7': device_add
[  307.624305] PM: Adding info for No Bus:ttyc7
[  307.676972] device: 'ttyc8': device_add
[  307.800336] PM: Adding info for No Bus:ttyc8
[  307.846981] device: 'ttyc9': device_add
[  307.979156] PM: Adding info for No Bus:ttyc9
[  308.030088] device: 'ttyca': device_add
[  308.163159] PM: Adding info for No Bus:ttyca
[  308.216999] device: 'ttycb': device_add
[  308.339110] PM: Adding info for No Bus:ttycb
[  308.392326] device: 'ttycc': device_add
[  308.525082] PM: Adding info for No Bus:ttycc
[  308.577096] device: 'ttycd': device_add
[  308.705345] PM: Adding info for No Bus:ttycd
[  308.758111] device: 'ttyce': device_add
[  308.893356] PM: Adding info for No Bus:ttyce
[  308.945050] device: 'ttycf': device_add
[  309.084046] PM: Adding info for No Bus:ttycf
[  309.134118] device: 'ttyd0': device_add
[  309.275081] PM: Adding info for No Bus:ttyd0
[  309.325067] device: 'ttyd1': device_add
[  309.451060] PM: Adding info for No Bus:ttyd1
[  309.502093] device: 'ttyd2': device_add
[  309.642350] PM: Adding info for No Bus:ttyd2
[  309.696012] device: 'ttyd3': device_add
[  309.831351] PM: Adding info for No Bus:ttyd3
[  309.874075] device: 'ttyd4': device_add
[  310.007084] PM: Adding info for No Bus:ttyd4
[  310.061095] device: 'ttyd5': device_add
[  310.189122] PM: Adding info for No Bus:ttyd5
[  310.245014] device: 'ttyd6': device_add
[  310.379304] PM: Adding info for No Bus:ttyd6
[  310.436026] device: 'ttyd7': device_add
[  310.574977] PM: Adding info for No Bus:ttyd7
[  310.623047] device: 'ttyd8': device_add
[  310.763332] PM: Adding info for No Bus:ttyd8
[  310.812996] device: 'ttyd9': device_add
[  310.941345] PM: Adding info for No Bus:ttyd9
[  310.991990] device: 'ttyda': device_add
[  311.133327] PM: Adding info for No Bus:ttyda
[  311.182123] device: 'ttydb': device_add
[  311.315357] PM: Adding info for No Bus:ttydb
[  311.365075] device: 'ttydc': device_add
[  311.498004] PM: Adding info for No Bus:ttydc
[  311.561128] device: 'ttydd': device_add
[  311.690976] PM: Adding info for No Bus:ttydd
[  311.744312] device: 'ttyde': device_add
[  311.871082] PM: Adding info for No Bus:ttyde
[  311.924068] device: 'ttydf': device_add
[  312.062337] PM: Adding info for No Bus:ttydf
[  312.117996] device: 'ttye0': device_add
[  312.248084] PM: Adding info for No Bus:ttye0
[  312.299092] device: 'ttye1': device_add
[  312.431069] PM: Adding info for No Bus:ttye1
[  312.482139] device: 'ttye2': device_add
[  312.626353] PM: Adding info for No Bus:ttye2
[  312.682005] device: 'ttye3': device_add
[  312.810319] PM: Adding info for No Bus:ttye3
[  312.865084] device: 'ttye4': device_add
[  313.002350] PM: Adding info for No Bus:ttye4
[  313.056123] device: 'ttye5': device_add
[  313.187090] PM: Adding info for No Bus:ttye5
[  313.242024] device: 'ttye6': device_add
[  313.372003] PM: Adding info for No Bus:ttye6
[  313.432100] device: 'ttye7': device_add
[  313.570070] PM: Adding info for No Bus:ttye7
[  313.621052] device: 'ttye8': device_add
[  313.747352] PM: Adding info for No Bus:ttye8
[  313.802021] device: 'ttye9': device_add
[  313.932129] PM: Adding info for No Bus:ttye9
[  313.979132] device: 'ttyea': device_add
[  314.121991] PM: Adding info for No Bus:ttyea
[  314.177328] device: 'ttyeb': device_add
[  314.313095] PM: Adding info for No Bus:ttyeb
[  314.377321] device: 'ttyec': device_add
[  314.514355] PM: Adding info for No Bus:ttyec
[  314.572018] device: 'ttyed': device_add
[  314.704963] PM: Adding info for No Bus:ttyed
[  314.756971] device: 'ttyee': device_add
[  314.896986] PM: Adding info for No Bus:ttyee
[  314.940043] device: 'ttyef': device_add
[  315.082045] PM: Adding info for No Bus:ttyef
[  315.182091] device: 'ptmx': device_add
[  315.306071] PM: Adding info for No Bus:ptmx
[  315.343101] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[  315.421343] Registering platform device 'serial8250'. Parent at platform
[  315.435073] device: 'serial8250': device_add
[  315.457087] bus: 'platform': add device serial8250
[  315.547138] PM: Adding info for platform:serial8250
[  315.700374] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[  315.732103] device: 'ttyS0': device_add
[  315.961312] PM: Adding info for No Bus:ttyS0
[  316.150069] device: 'ttyS1': device_add
[  316.300969] PM: Adding info for No Bus:ttyS1
[  316.445048] device: 'ttyS2': device_add
[  316.607329] PM: Adding info for No Bus:ttyS2
[  316.837103] device: 'ttyS3': device_add
[  317.059325] PM: Adding info for No Bus:ttyS3
[  317.169343] bus: 'platform': add driver serial8250
[  317.201012] bus: 'platform': driver_probe_device: matched device serial8250 with driver serial8250
[  317.207296] bus: 'platform': really_probe: probing driver serial8250 with device serial8250
[  317.239334] driver: 'serial8250': driver_bound: bound to device 'serial8250'
[  317.246348] bus: 'platform': really_probe: bound device serial8250 to driver serial8250
[  317.292977] bus: 'pnp': add driver serial
[  317.330092] bus: 'pnp': driver_probe_device: matched device 00:06 with driver serial
[  317.338024] bus: 'pnp': really_probe: probing driver serial with device 00:06
[  317.599104] device: 'ttyS0': device_unregister
[  317.610343] PM: Removing info for No Bus:ttyS0
[  318.230337] device: 'ttyS0': device_create_release
[  318.349024] 00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[  318.373108] device: 'ttyS0': device_add
[  318.557314] PM: Adding info for No Bus:ttyS0
[  318.662102] driver: '00:06': driver_bound: bound to device 'serial'
[  318.670074] bus: 'pnp': really_probe: bound device 00:06 to driver serial
[  318.725073] bus: 'pci': add driver serial
[  318.853098] bus: 'pnp': add driver tpm_tis
[  318.988054] bus: 'pnp': add driver i8042 kbd
[  319.026300] bus: 'pnp': driver_probe_device: matched device 00:02 with driver i8042 kbd
[  319.028087] bus: 'pnp': really_probe: probing driver i8042 kbd with device 00:02
[  319.067124] driver: '00:02': driver_bound: bound to device 'i8042 kbd'
[  319.075008] bus: 'pnp': really_probe: bound device 00:02 to driver i8042 kbd
[  319.130346] bus: 'pnp': add driver i8042 aux
[  319.161138] bus: 'pnp': driver_probe_device: matched device 00:03 with driver i8042 aux
[  319.167292] bus: 'pnp': really_probe: probing driver i8042 aux with device 00:03
[  319.201058] driver: '00:03': driver_bound: bound to device 'i8042 aux'
[  319.209123] bus: 'pnp': really_probe: bound device 00:03 to driver i8042 aux
[  319.263360] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[  319.297128] Registering platform device 'i8042'. Parent at platform
[  319.306133] device: 'i8042': device_add
[  319.332101] bus: 'platform': add device i8042
[  319.426305] PM: Adding info for platform:i8042
[  319.461040] bus: 'platform': add driver i8042
[  319.492049] bus: 'platform': driver_probe_device: matched device i8042 with driver i8042
[  319.504030] bus: 'platform': really_probe: probing driver i8042 with device i8042
[  319.771014] serio: i8042 KBD port at 0x60,0x64 irq 1
[  319.795394] serio: i8042 AUX port at 0x60,0x64 irq 12
[  319.831051] driver: 'i8042': driver_bound: bound to device 'i8042'
[  319.841058] bus: 'platform': really_probe: bound device i8042 to driver i8042
[  319.876133] device: 'serio0': device_add
[  319.918035] bus: 'serio': add driver atkbd
[  320.009932] bus: 'serio': add device serio0
[  320.101111] cpuidle: using governor ladder
[  320.190092] 
[  320.190092] printing PIC contents
[  320.199963] PM: Adding info for serio:serio0
[  320.207413] ... PIC  IMR: edf8
[  320.207642] ... PIC  IRR: 0011
[  320.214111] ... PIC  ISR: 0000
[  320.226110] ... PIC ELCR: 0200
[  320.275307] bus: 'serio': driver_probe_device: matched device serio0 with driver atkbd
[  320.293348] bus: 'serio': really_probe: probing driver atkbd with device serio0
[  320.342344] device: 'cpu_dma_latency': device_add
[  320.565104] PM: Adding info for No Bus:cpu_dma_latency
[  320.651127] device: 'network_latency': device_add
[  320.706014] device: 'input1': device_add
[  320.863315] PM: Adding info for No Bus:network_latency
[  320.948026] device: 'network_throughput': device_add
[  321.149955] PM: Adding info for No Bus:network_throughput
[  321.243326] PM: Adding info for No Bus:input1
[  321.346309] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[  321.372296] driver: 'serio0': driver_bound: bound to device 'atkbd'
[  321.385073] bus: 'serio': really_probe: bound device serio0 to driver atkbd
[  321.435315] device: 'serio1': device_add
[  321.538021] bus: 'serio': add device serio1
[  321.598020] IMA: No TPM chip found, activating TPM-bypass!
[  321.705357] PM: Adding info for serio:serio1
[  321.753964] bus: 'serio': driver_probe_device: matched device serio1 with driver atkbd
[  321.763993] bus: 'serio': really_probe: probing driver atkbd with device serio1
[  321.958111] atkbd: probe of serio1 rejects match -19
[  321.982349] bus: 'serio': driver_probe_device: matched device serio1 with driver atkbd
[  321.984322] bus: 'serio': really_probe: probing driver atkbd with device serio1
[  322.143116] atkbd: probe of serio1 rejects match -19
[  323.838025] hd: no drives specified - use hd=cyl,head,sectors on kernel command line
[  728.482341] Freeing initrd memory: 23656k freed
[  729.895291] Freeing unused kernel memory: 2264k freed
[  730.076297] Write protecting the kernel read-only data: 8192k
[  731.030083] Testing CPA: undo ffffffff81000000-ffffffff81800000
[  731.824339] Testing CPA: again
[  733.951376] Freeing unused kernel memory: 668k freed
[  734.579318] Freeing unused kernel memory: 1472k freed
[  790.863084] hostname (24) used greatest stack depth: 4928 bytes left
[  814.604614] =============================================================================
[  814.604614] BUG filp (Not tainted): Poison overwritten
[  814.604614] -----------------------------------------------------------------------------
[  814.604614] 
[  814.604614] INFO: 0xffff88000ccf6c78-0xffff88000ccf6c78. First byte 0x6a instead of 0x6b
[  814.604614] INFO: Allocated in get_empty_filp+0x7e/0x20d age=2717 cpu=0 pid=26
[  814.604614] 
[  814.604614] 
[  814.604614] 
[  814.604614] 
[  814.604614] 
[  814.604614] 
[  814.604614] 
[  814.604614] 
[  814.604614] INFO: Freed in file_free_rcu+0x45/0x49 age=2545 cpu=0 pid=26
[  814.604614] 
[  814.604614] 
[  814.604614] 
[  814.604614] 
[  814.604614] 
[  814.604614] 
[  814.604614] 
[  814.604614] 
[  814.604614] 
[  814.604614] 
[  814.604614] 
[  814.604614] 
[  814.604614] 
[  814.604614] 
[  814.604614] 
[  814.604614] 
[  814.604614] INFO: Slab 0xffff88000d787d00 objects=23 used=23 fp=0x          (null) flags=0x200000004080
[  814.604614] INFO: Object 0xffff88000ccf6c00 @offset=11264 fp=0xffff88000ccf6100
[  814.604614] 
[  814.604614] Bytes b4 ffff88000ccf6bf0: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ
[  814.604614] Object ffff88000ccf6c00: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[  814.604614] Object ffff88000ccf6c10: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[  814.604614] Object ffff88000ccf6c20: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[  814.604614] Object ffff88000ccf6c30: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[  814.604614] Object ffff88000ccf6c40: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[  814.604614] Object ffff88000ccf6c50: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[  814.604614] Object ffff88000ccf6c60: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[  814.604614] Object ffff88000ccf6c70: 6b 6b 6b 6b 6b 6b 6b 6b 6a 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkjkkkkkkk
[  814.604614] Object ffff88000ccf6c80: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[  814.604614] Object ffff88000ccf6c90: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[  814.604614] Object ffff88000ccf6ca0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[  814.604614] Object ffff88000ccf6cb0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[  814.604614] Object ffff88000ccf6cc0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[  814.604614] Object ffff88000ccf6cd0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[  814.604614] Object ffff88000ccf6ce0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[  814.604614] Object ffff88000ccf6cf0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[  814.604614] Object ffff88000ccf6d00: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[  814.604614] Object ffff88000ccf6d10: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[  814.604614] Object ffff88000ccf6d20: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[  814.604614] Object ffff88000ccf6d30: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b a5  kkkkkkkkkkkkkkk.
[  814.604614] Redzone ffff88000ccf6d40: bb bb bb bb bb bb bb bb                          ........
[  814.604614] Padding ffff88000ccf6e80: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ
[  814.604614] Padding ffff88000ccf6e90: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ
[  814.604614] Padding ffff88000ccf6ea0: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ
[  814.604614] Padding ffff88000ccf6eb0: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ
[  814.604614] Pid: 27, comm: run-parts Not tainted 3.5.4-00340-gdaac8ca #2345
[  814.604614] Call Trace:
[  814.604614]  [<ffffffff8113e7a5>] ? print_section+0x38/0x3a
[  814.604614]  [<ffffffff8113e954>] print_trailer+0x1ad/0x1b6
[  814.604614]  [<ffffffff811413a3>] check_bytes_and_report+0xbf/0x10d
[  814.604614]  [<ffffffff8114bebb>] ? get_empty_filp+0x6b/0x20d
[  814.604614]  [<ffffffff8114151b>] check_object+0x12a/0x29c
[  814.604614]  [<ffffffff8114bece>] ? get_empty_filp+0x7e/0x20d
[  814.604614]  [<ffffffff8134ca56>] alloc_debug_processing+0x93/0x19b
[  814.604614]  [<ffffffff8114365b>] __slab_alloc+0x63a/0x6c9
[  814.604614]  [<ffffffff813564b4>] ? retint_restore_args+0x13/0x13
[  814.604614]  [<ffffffff8114bece>] ? get_empty_filp+0x7e/0x20d
[  814.604614]  [<ffffffff8106bb92>] ? __might_sleep+0x44/0x15e
[  814.604614]  [<ffffffff811457e1>] kmem_cache_alloc+0xb8/0x262
[  814.604614]  [<ffffffff8114bece>] ? get_empty_filp+0x7e/0x20d
[  814.604614]  [<ffffffff8114bece>] get_empty_filp+0x7e/0x20d
[  814.604614]  [<ffffffff8115dad4>] path_openat+0x35/0x586
[  814.604614]  [<ffffffff81072bcc>] ? local_clock+0x57/0x6e
[  814.604614]  [<ffffffff810910b6>] ? trace_hardirqs_off_caller+0x1f/0x9e
[  814.604614]  [<ffffffff8115e180>] do_filp_open+0x38/0xf5
[  814.604614]  [<ffffffff81091d11>] ? lock_release_holdtime.part.25+0x83/0x8a
[  814.604614]  [<ffffffff810d012c>] ? trace_preempt_on+0x12/0x47
[  814.604614]  [<ffffffff8106e4d1>] ? sub_preempt_count+0x4a/0x5d
[  814.604614]  [<ffffffff813559f7>] ? _raw_spin_unlock+0x59/0x75
[  814.604614]  [<ffffffff8116de97>] ? alloc_fd+0x18f/0x1a1
[  814.604614]  [<ffffffff811497b7>] do_sys_open+0xa4/0x250
[  814.604614]  [<ffffffff81094c0f>] ? trace_hardirqs_on_caller+0x123/0x17f
[  814.604614]  [<ffffffff8114997f>] sys_open+0x1c/0x1e
[  814.604614]  [<ffffffff81356cb9>] system_call_fastpath+0x16/0x1b
[  814.604614] FIX filp: Restoring 0xffff88000ccf6c78-0xffff88000ccf6c78=0x6b
[  814.604614] 
[  814.604614] FIX filp: Marking all objects used

--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.5.4-00340-gdaac8ca"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.5.4 Kernel Configuration
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
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
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
CONFIG_CONSTRUCTORS=y
CONFIG_HAVE_IRQ_WORK=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
# CONFIG_EXPERIMENTAL is not set
CONFIG_INIT_ENV_ARG_LIMIT=32
# CONFIG_INIT_PASS_ALL_PARAMS is not set
CONFIG_CROSS_COMPILE=""
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
# CONFIG_KERNEL_GZIP is not set
CONFIG_KERNEL_BZIP2=y
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_VERSION_SIGNATURE=""
CONFIG_SWAP=y
# CONFIG_SYSVIPC is not set
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
CONFIG_FHANDLE=y
# CONFIG_TASKSTATS is not set
CONFIG_AUDIT=y
# CONFIG_AUDITSYSCALL is not set
# CONFIG_AUDIT_LOGINUID_IMMUTABLE is not set
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_DOMAIN_DEBUG=y
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
CONFIG_TREE_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_RCU_BOOST is not set
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
# CONFIG_CHECKPOINT_RESTORE is not set
# CONFIG_NAMESPACES is not set
# CONFIG_SCHED_AUTOGROUP is not set
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
# CONFIG_RD_LZMA is not set
# CONFIG_RD_XZ is not set
# CONFIG_RD_LZO is not set
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_ANON_INODES=y
CONFIG_EXPERT=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
# CONFIG_ELF_CORE is not set
# CONFIG_PCSPKR_PLATFORM is not set
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
# CONFIG_EPOLL is not set
# CONFIG_SIGNALFD is not set
# CONFIG_TIMERFD is not set
# CONFIG_EVENTFD is not set
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_SLUB_DEBUG=y
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
CONFIG_TRACEPOINTS=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_KPROBES is not set
# CONFIG_JUMP_LABEL is not set
CONFIG_UPROBES=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
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
CONFIG_GCOV_KERNEL=y
# CONFIG_GCOV_PROFILE_ALL is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODVERSIONS is not set
CONFIG_MODULE_SRCVERSION_ALL=y
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
# CONFIG_BLK_DEV_INTEGRITY is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_DEADLINE is not set
# CONFIG_IOSCHED_CFQ is not set
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
# CONFIG_X86_EXTENDED_PLATFORM is not set
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_PARAVIRT_GUEST=y
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
# CONFIG_XEN is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
# CONFIG_KVM_CLOCK is not set
CONFIG_KVM_GUEST=y
CONFIG_PARAVIRT=y
CONFIG_PARAVIRT_DEBUG=y
CONFIG_NO_BOOTMEM=y
CONFIG_MEMTEST=y
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_GENERIC_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
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
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_NR_CPUS=8
# CONFIG_SCHED_SMT is not set
# CONFIG_SCHED_MC is not set
# CONFIG_IRQ_TIME_ACCOUNTING is not set
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
# CONFIG_X86_MCE is not set
CONFIG_I8K=m
# CONFIG_MICROCODE is not set
# CONFIG_X86_MSR is not set
# CONFIG_X86_CPUID is not set
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
# CONFIG_DIRECT_GBPAGES is not set
CONFIG_NUMA=y
CONFIG_AMD_NUMA=y
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_NODES_SPAN_OTHER_NODES=y
# CONFIG_NUMA_EMU is not set
CONFIG_NODES_SHIFT=6
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_NEED_MULTIPLE_NODES=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
# CONFIG_SPARSEMEM_VMEMMAP is not set
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
# CONFIG_COMPACTION is not set
# CONFIG_MIGRATION is not set
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=0
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
# CONFIG_TRANSPARENT_HUGEPAGE is not set
# CONFIG_CROSS_MEMORY_ATTACH is not set
CONFIG_CLEANCACHE=y
CONFIG_FRONTSWAP=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MTRR is not set
# CONFIG_ARCH_RANDOM is not set
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
# CONFIG_SCHED_HRTICK is not set
# CONFIG_KEXEC is not set
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_USE_PERCPU_NUMA_NODE_ID=y

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
# CONFIG_PM_AUTOSLEEP is not set
CONFIG_PM_WAKELOCKS=y
CONFIG_PM_WAKELOCKS_LIMIT=100
# CONFIG_PM_WAKELOCKS_GC is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_PROCFS_POWER is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_NUMA=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_BGRT is not set
# CONFIG_ACPI_APEI is not set
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
# CONFIG_INTEL_IDLE is not set

#
# Memory power savings
#

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
# CONFIG_PCI_MMCONFIG is not set
CONFIG_PCI_DOMAINS=y
# CONFIG_PCIEPORTBUS is not set
CONFIG_ARCH_SUPPORTS_MSI=y
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=y
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
CONFIG_PCCARD=m
# CONFIG_PCMCIA is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
# CONFIG_YENTA is not set
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_RAPIDIO is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
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
CONFIG_PACKET=m
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
# CONFIG_NET_KEY is not set
# CONFIG_INET is not set
CONFIG_NETWORK_SECMARK=y
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
# CONFIG_NETFILTER_ADVANCED is not set
# CONFIG_BRIDGE_NF_EBTABLES is not set
CONFIG_ATM=m
# CONFIG_ATM_LANE is not set
CONFIG_STP=m
CONFIG_BRIDGE=m
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
CONFIG_LLC=m
CONFIG_LLC2=m
# CONFIG_IPX is not set
CONFIG_ATALK=m
CONFIG_DEV_APPLETALK=m
# CONFIG_IPDDP is not set
CONFIG_PHONET=m
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
# CONFIG_NET_SCH_CBQ is not set
CONFIG_NET_SCH_HTB=m
CONFIG_NET_SCH_HFSC=m
CONFIG_NET_SCH_ATM=m
CONFIG_NET_SCH_PRIO=m
# CONFIG_NET_SCH_MULTIQ is not set
CONFIG_NET_SCH_RED=m
CONFIG_NET_SCH_SFB=m
CONFIG_NET_SCH_SFQ=m
CONFIG_NET_SCH_TEQL=m
CONFIG_NET_SCH_TBF=m
CONFIG_NET_SCH_GRED=m
CONFIG_NET_SCH_DSMARK=m
# CONFIG_NET_SCH_NETEM is not set
CONFIG_NET_SCH_DRR=m
CONFIG_NET_SCH_MQPRIO=m
CONFIG_NET_SCH_CHOKE=m
CONFIG_NET_SCH_QFQ=m
CONFIG_NET_SCH_CODEL=m
# CONFIG_NET_SCH_FQ_CODEL is not set
# CONFIG_NET_SCH_INGRESS is not set
# CONFIG_NET_SCH_PLUG is not set

#
# Classification
#
CONFIG_NET_CLS=y
# CONFIG_NET_CLS_BASIC is not set
# CONFIG_NET_CLS_TCINDEX is not set
CONFIG_NET_CLS_FW=m
# CONFIG_NET_CLS_U32 is not set
# CONFIG_NET_CLS_RSVP is not set
CONFIG_NET_CLS_RSVP6=m
# CONFIG_NET_CLS_FLOW is not set
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
# CONFIG_NET_EMATCH_CMP is not set
CONFIG_NET_EMATCH_NBYTE=m
# CONFIG_NET_EMATCH_U32 is not set
CONFIG_NET_EMATCH_META=m
# CONFIG_NET_EMATCH_TEXT is not set
CONFIG_NET_CLS_ACT=y
# CONFIG_NET_ACT_POLICE is not set
CONFIG_NET_ACT_GACT=m
CONFIG_GACT_PROB=y
# CONFIG_NET_ACT_MIRRED is not set
CONFIG_NET_ACT_NAT=m
# CONFIG_NET_ACT_PEDIT is not set
# CONFIG_NET_ACT_SIMP is not set
CONFIG_NET_ACT_SKBEDIT=m
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y
# CONFIG_DCB is not set
CONFIG_BATMAN_ADV=m
CONFIG_BATMAN_ADV_DEBUG=y
CONFIG_OPENVSWITCH=m
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
CONFIG_BQL=y
# CONFIG_BPF_JIT is not set

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
# CONFIG_WIRELESS is not set
# CONFIG_WIMAX is not set
CONFIG_RFKILL=m
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
CONFIG_NET_9P=m
# CONFIG_NET_9P_DEBUG is not set
# CONFIG_CAIF is not set
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
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_DEBUG_DRIVER=y
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_SPI=y
CONFIG_REGMAP_IRQ=y
CONFIG_SR_REPORT_TIME_LIMIT=100
# CONFIG_CONNECTOR is not set
CONFIG_MTD=m
CONFIG_MTD_TESTS=m
# CONFIG_MTD_REDBOOT_PARTS is not set
# CONFIG_MTD_AR7_PARTS is not set

#
# User Modules And Translation Layers
#
# CONFIG_MTD_CHAR is not set
CONFIG_HAVE_MTD_OTP=y
CONFIG_MTD_BLKDEVS=m
CONFIG_MTD_BLOCK=m
# CONFIG_MTD_BLOCK_RO is not set
CONFIG_FTL=m
CONFIG_NFTL=m
# CONFIG_NFTL_RW is not set
# CONFIG_INFTL is not set
CONFIG_RFD_FTL=m
CONFIG_SSFDC=m
# CONFIG_MTD_OOPS is not set
CONFIG_MTD_SWAP=m

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=m
CONFIG_MTD_JEDECPROBE=m
CONFIG_MTD_GEN_PROBE=m
# CONFIG_MTD_CFI_ADV_OPTIONS is not set
CONFIG_MTD_MAP_BANK_WIDTH_1=y
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
CONFIG_MTD_CFI_I1=y
CONFIG_MTD_CFI_I2=y
# CONFIG_MTD_CFI_I4 is not set
# CONFIG_MTD_CFI_I8 is not set
CONFIG_MTD_CFI_INTELEXT=m
CONFIG_MTD_CFI_AMDSTD=m
CONFIG_MTD_CFI_STAA=m
CONFIG_MTD_CFI_UTIL=m
CONFIG_MTD_RAM=m
CONFIG_MTD_ROM=m
# CONFIG_MTD_ABSENT is not set

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
# CONFIG_MTD_PHYSMAP is not set
# CONFIG_MTD_SC520CDP is not set
CONFIG_MTD_NETSC520=m
CONFIG_MTD_TS5500=m
CONFIG_MTD_AMD76XROM=m
# CONFIG_MTD_ICHXROM is not set
# CONFIG_MTD_ESB2ROM is not set
# CONFIG_MTD_CK804XROM is not set
# CONFIG_MTD_SCB2_FLASH is not set
CONFIG_MTD_NETtel=m
# CONFIG_MTD_L440GX is not set
# CONFIG_MTD_INTEL_VR_NOR is not set
# CONFIG_MTD_PLATRAM is not set

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
# CONFIG_MTD_SST25L is not set
# CONFIG_MTD_SLRAM is not set
# CONFIG_MTD_PHRAM is not set
# CONFIG_MTD_MTDRAM is not set
# CONFIG_MTD_BLOCK2MTD is not set

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOCG3=m
CONFIG_BCH_CONST_M=14
CONFIG_BCH_CONST_T=4
# CONFIG_MTD_NAND is not set
CONFIG_MTD_ONENAND=m
CONFIG_MTD_ONENAND_VERIFY_WRITE=y
CONFIG_MTD_ONENAND_GENERIC=m
CONFIG_MTD_ONENAND_OTP=y
CONFIG_MTD_ONENAND_2X_PROGRAM=y
# CONFIG_MTD_ONENAND_SIM is not set

#
# LPDDR flash memory drivers
#
CONFIG_MTD_LPDDR=m
CONFIG_MTD_QINFO_PROBE=m
# CONFIG_MTD_UBI is not set
CONFIG_PARPORT=m
CONFIG_PARPORT_PC=m
# CONFIG_PARPORT_SERIAL is not set
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
# CONFIG_PARPORT_1284 is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_FD=m
# CONFIG_PARIDE is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set

#
# DRBD disabled because PROC_FS, INET or CONNECTOR not selected
#
CONFIG_BLK_DEV_NBD=m
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_RAM is not set
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
CONFIG_ATA_OVER_ETH=m
CONFIG_BLK_DEV_HD=y

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
CONFIG_AD525X_DPOT=m
CONFIG_AD525X_DPOT_SPI=m
# CONFIG_PHANTOM is not set
# CONFIG_INTEL_MID_PTI is not set
# CONFIG_SGI_IOC4 is not set
CONFIG_ENCLOSURE_SERVICES=m
# CONFIG_HP_ILO is not set
CONFIG_TI_DAC7512=m
CONFIG_VMWARE_BALLOON=m
CONFIG_BMP085=y
CONFIG_BMP085_SPI=m
# CONFIG_PCH_PHUB is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT25 is not set
CONFIG_EEPROM_93CX6=m
# CONFIG_EEPROM_93XX46 is not set
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#

#
# Altera FPGA firmware download module
#
CONFIG_HAVE_IDE=y
CONFIG_IDE=m

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_ATAPI=y
CONFIG_BLK_DEV_IDE_SATA=y
CONFIG_IDE_GD=m
# CONFIG_IDE_GD_ATA is not set
# CONFIG_IDE_GD_ATAPI is not set
# CONFIG_BLK_DEV_DELKIN is not set
CONFIG_BLK_DEV_IDECD=m
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
CONFIG_BLK_DEV_IDETAPE=m
# CONFIG_BLK_DEV_IDEACPI is not set
# CONFIG_IDE_TASK_IOCTL is not set
# CONFIG_IDE_PROC_FS is not set

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=m
CONFIG_BLK_DEV_PLATFORM=m
# CONFIG_BLK_DEV_CMD640 is not set
# CONFIG_BLK_DEV_IDEPNP is not set

#
# PCI IDE chipsets support
#
# CONFIG_BLK_DEV_GENERIC is not set
# CONFIG_BLK_DEV_RZ1000 is not set
# CONFIG_BLK_DEV_AEC62XX is not set
# CONFIG_BLK_DEV_ALI15X3 is not set
# CONFIG_BLK_DEV_AMD74XX is not set
# CONFIG_BLK_DEV_ATIIXP is not set
# CONFIG_BLK_DEV_CMD64X is not set
# CONFIG_BLK_DEV_TRIFLEX is not set
# CONFIG_BLK_DEV_CS5530 is not set
# CONFIG_BLK_DEV_HPT366 is not set
# CONFIG_BLK_DEV_JMICRON is not set
# CONFIG_BLK_DEV_SC1200 is not set
# CONFIG_BLK_DEV_PIIX is not set
# CONFIG_BLK_DEV_IT8172 is not set
# CONFIG_BLK_DEV_IT8213 is not set
# CONFIG_BLK_DEV_IT821X is not set
# CONFIG_BLK_DEV_NS87415 is not set
# CONFIG_BLK_DEV_PDC202XX_OLD is not set
# CONFIG_BLK_DEV_PDC202XX_NEW is not set
# CONFIG_BLK_DEV_SVWKS is not set
# CONFIG_BLK_DEV_SIIMAGE is not set
# CONFIG_BLK_DEV_SIS5513 is not set
# CONFIG_BLK_DEV_SLC90E66 is not set
# CONFIG_BLK_DEV_TRM290 is not set
# CONFIG_BLK_DEV_VIA82CXXX is not set
# CONFIG_BLK_DEV_TC86C001 is not set
# CONFIG_BLK_DEV_IDEDMA is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=m
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=m
CONFIG_SCSI_DMA=y
CONFIG_SCSI_NETLINK=y
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
# CONFIG_BLK_DEV_SD is not set
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=m
CONFIG_BLK_DEV_SR_VENDOR=y
# CONFIG_CHR_DEV_SG is not set
# CONFIG_CHR_DEV_SCH is not set
CONFIG_SCSI_ENCLOSURE=m
# CONFIG_SCSI_MULTI_LUN is not set
CONFIG_SCSI_CONSTANTS=y
# CONFIG_SCSI_LOGGING is not set
CONFIG_SCSI_SCAN_ASYNC=y
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=m
CONFIG_SCSI_FC_ATTRS=m
# CONFIG_SCSI_ISCSI_ATTRS is not set
CONFIG_SCSI_SAS_ATTRS=m
CONFIG_SCSI_SAS_LIBSAS=m
CONFIG_SCSI_SAS_ATA=y
CONFIG_SCSI_SAS_HOST_SMP=y
# CONFIG_SCSI_SRP_ATTRS is not set
# CONFIG_SCSI_LOWLEVEL is not set
CONFIG_SCSI_DH=m
# CONFIG_SCSI_DH_RDAC is not set
CONFIG_SCSI_DH_HP_SW=m
# CONFIG_SCSI_DH_EMC is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=m
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
# CONFIG_SATA_PMP is not set

#
# Controllers with non-SFF native interface
#
# CONFIG_SATA_AHCI is not set
CONFIG_SATA_AHCI_PLATFORM=m
# CONFIG_SATA_INIC162X is not set
# CONFIG_SATA_ACARD_AHCI is not set
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
CONFIG_ATA_BMDMA=y

#
# SATA SFF controllers with BMDMA
#
# CONFIG_ATA_PIIX is not set
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_SVW is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set

#
# PATA SFF controllers with BMDMA
#
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARASAN_CF is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_ATP867X is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CS5536 is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RDC is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SCH is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set

#
# PIO-only SFF controllers
#
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_PLATFORM is not set
# CONFIG_PATA_RZ1000 is not set

#
# Generic fallback / legacy drivers
#
# CONFIG_PATA_ACPI is not set
# CONFIG_ATA_GENERIC is not set
# CONFIG_MD is not set
CONFIG_TARGET_CORE=m
# CONFIG_TCM_IBLOCK is not set
CONFIG_TCM_FILEIO=m
CONFIG_TCM_PSCSI=m
# CONFIG_LOOPBACK_TARGET is not set
# CONFIG_ISCSI_TARGET is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
# CONFIG_NETDEVICES is not set
CONFIG_ISDN=y
CONFIG_ISDN_I4L=m
CONFIG_ISDN_AUDIO=y
CONFIG_ISDN_TTY_FAX=y

#
# ISDN feature submodules
#
# CONFIG_ISDN_DIVERSION is not set

#
# ISDN4Linux hardware drivers
#

#
# Passive cards
#
# CONFIG_ISDN_DRV_HISAX is not set

#
# Active cards
#
CONFIG_ISDN_CAPI=m
CONFIG_ISDN_DRV_AVMB1_VERBOSE_REASON=y
CONFIG_CAPI_TRACE=y
CONFIG_ISDN_CAPI_MIDDLEWARE=y
CONFIG_ISDN_CAPI_CAPI20=m
# CONFIG_ISDN_CAPI_CAPIDRV is not set

#
# CAPI hardware drivers
#
CONFIG_CAPI_AVM=y
# CONFIG_ISDN_DRV_AVMB1_B1PCI is not set
# CONFIG_ISDN_DRV_AVMB1_T1PCI is not set
# CONFIG_ISDN_DRV_AVMB1_C4 is not set
# CONFIG_CAPI_EICON is not set
CONFIG_ISDN_DRV_GIGASET=m
CONFIG_GIGASET_CAPI=y
# CONFIG_GIGASET_I4L is not set
# CONFIG_GIGASET_DUMMYLL is not set
# CONFIG_GIGASET_M101 is not set
# CONFIG_GIGASET_DEBUG is not set
# CONFIG_HYSDN is not set
# CONFIG_MISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=m
CONFIG_INPUT_POLLDEV=m
# CONFIG_INPUT_SPARSEKMAP is not set
CONFIG_INPUT_MATRIXKMAP=m

#
# Userland interfaces
#
# CONFIG_INPUT_MOUSEDEV is not set
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_EVDEV is not set
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_LKKBD=m
CONFIG_KEYBOARD_NEWTON=m
CONFIG_KEYBOARD_OPENCORES=m
# CONFIG_KEYBOARD_STOWAWAY is not set
CONFIG_KEYBOARD_SUNKBD=m
CONFIG_KEYBOARD_STMPE=m
# CONFIG_KEYBOARD_OMAP4 is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=m
# CONFIG_MOUSE_PS2_ALPS is not set
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
# CONFIG_MOUSE_PS2_LIFEBOOK is not set
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_SENTELIC is not set
CONFIG_MOUSE_PS2_TOUCHKIT=y
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
CONFIG_MOUSE_VSXXXAA=m
# CONFIG_MOUSE_SYNAPTICS_USB is not set
# CONFIG_INPUT_JOYSTICK is not set
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
# CONFIG_TABLET_USB_AIPTEK is not set
# CONFIG_TABLET_USB_HANWANG is not set
# CONFIG_TABLET_USB_KBTAB is not set
# CONFIG_TABLET_USB_WACOM is not set
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_ADS7846=m
# CONFIG_TOUCHSCREEN_AD7877 is not set
# CONFIG_TOUCHSCREEN_AD7879 is not set
# CONFIG_TOUCHSCREEN_CYTTSP_CORE is not set
# CONFIG_TOUCHSCREEN_DA9052 is not set
CONFIG_TOUCHSCREEN_DYNAPRO=m
CONFIG_TOUCHSCREEN_HAMPSHIRE=m
# CONFIG_TOUCHSCREEN_FUJITSU is not set
CONFIG_TOUCHSCREEN_GUNZE=m
# CONFIG_TOUCHSCREEN_ELO is not set
CONFIG_TOUCHSCREEN_WACOM_W8001=m
CONFIG_TOUCHSCREEN_MTOUCH=m
CONFIG_TOUCHSCREEN_INEXIO=m
CONFIG_TOUCHSCREEN_MK712=m
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
CONFIG_TOUCHSCREEN_TOUCHWIN=m
# CONFIG_TOUCHSCREEN_WM831X is not set
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
CONFIG_TOUCHSCREEN_TOUCHIT213=m
# CONFIG_TOUCHSCREEN_TSC_SERIO is not set
CONFIG_TOUCHSCREEN_TSC2005=m
# CONFIG_TOUCHSCREEN_STMPE is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_AD714X is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_POWERMATE is not set
CONFIG_INPUT_UINPUT=m
CONFIG_INPUT_DA9052_ONKEY=m
# CONFIG_INPUT_WM831X_ON is not set
# CONFIG_INPUT_ADXL34X is not set
CONFIG_INPUT_CMA3000=m

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=m
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
CONFIG_SERIO_ALTERA_PS2=m
CONFIG_SERIO_PS2MULT=m
CONFIG_GAMEPORT=m
# CONFIG_GAMEPORT_NS558 is not set
CONFIG_GAMEPORT_L4=m
# CONFIG_GAMEPORT_EMU10K1 is not set
# CONFIG_GAMEPORT_FM801 is not set

#
# Character devices
#
# CONFIG_VT is not set
CONFIG_UNIX98_PTYS=y
CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_ROCKETPORT is not set
# CONFIG_CYCLADES is not set
# CONFIG_MOXA_INTELLIO is not set
# CONFIG_MOXA_SMARTIO is not set
# CONFIG_SYNCLINK is not set
# CONFIG_SYNCLINKMP is not set
# CONFIG_SYNCLINK_GT is not set
# CONFIG_ISI is not set
CONFIG_N_HDLC=m
# CONFIG_TRACE_SINK is not set
# CONFIG_DEVKMEM is not set
CONFIG_STALDRV=y

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
# CONFIG_SERIAL_8250_SHARE_IRQ is not set
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
CONFIG_SERIAL_8250_RSA=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
# CONFIG_SERIAL_MAX3107 is not set
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
CONFIG_SERIAL_ALTERA_UART=m
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_XILINX_PS_UART is not set
# CONFIG_TTY_PRINTK is not set
# CONFIG_PRINTER is not set
CONFIG_PPDEV=m
CONFIG_IPMI_HANDLER=m
CONFIG_IPMI_PANIC_EVENT=y
# CONFIG_IPMI_PANIC_STRING is not set
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
# CONFIG_IPMI_WATCHDOG is not set
CONFIG_IPMI_POWEROFF=m
# CONFIG_HW_RANDOM is not set
# CONFIG_NVRAM is not set
# CONFIG_RTC is not set
CONFIG_GEN_RTC=m
# CONFIG_GEN_RTC_X is not set
CONFIG_R3964=m
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
CONFIG_RAW_DRIVER=m
CONFIG_MAX_RAW_DEVS=256
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=m
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
CONFIG_TCG_NSC=m
CONFIG_TCG_ATMEL=m
# CONFIG_TCG_INFINEON is not set
CONFIG_DEVPORT=y
# CONFIG_I2C is not set
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
CONFIG_SPI_ALTERA=m
CONFIG_SPI_BITBANG=m
# CONFIG_SPI_BUTTERFLY is not set
# CONFIG_SPI_PXA2XX_PCI is not set
# CONFIG_SPI_TOPCLIFF_PCH is not set
CONFIG_SPI_DESIGNWARE=m
# CONFIG_SPI_DW_PCI is not set

#
# SPI Protocol Masters
#
CONFIG_SPI_TLE62X0=m
# CONFIG_HSI is not set

#
# PPS support
#

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
# CONFIG_GPIOLIB is not set
CONFIG_W1=m

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
# CONFIG_W1_MASTER_DS1WM is not set

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
CONFIG_W1_SLAVE_SMEM=m
CONFIG_W1_SLAVE_DS2408=m
CONFIG_W1_SLAVE_DS2423=m
# CONFIG_W1_SLAVE_DS2431 is not set
# CONFIG_W1_SLAVE_DS2433 is not set
CONFIG_W1_SLAVE_DS2760=m
# CONFIG_W1_SLAVE_DS2780 is not set
CONFIG_W1_SLAVE_DS2781=m
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
# CONFIG_PDA_POWER is not set
# CONFIG_WM831X_BACKUP is not set
# CONFIG_WM831X_POWER is not set
CONFIG_TEST_POWER=m
# CONFIG_BATTERY_DS2760 is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_BQ27x00 is not set
CONFIG_CHARGER_MAX8903=m
CONFIG_HWMON=m
CONFIG_HWMON_VID=m
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
# CONFIG_SENSORS_F71805F is not set
CONFIG_SENSORS_F71882FG=m
# CONFIG_SENSORS_IBMAEM is not set
# CONFIG_SENSORS_IBMPEX is not set
# CONFIG_SENSORS_IT87 is not set
CONFIG_SENSORS_LM70=m
CONFIG_SENSORS_MAX1111=m
CONFIG_SENSORS_PC87360=m
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_ADS7871 is not set
CONFIG_SENSORS_VIA_CPUTEMP=m
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=m
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83627HF is not set
CONFIG_SENSORS_W83627EHF=m
# CONFIG_SENSORS_WM831X is not set
CONFIG_SENSORS_APPLESMC=m

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
CONFIG_THERMAL=y
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=m
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
# CONFIG_SSB_SILENT is not set
CONFIG_SSB_DEBUG=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
# CONFIG_SSB_DRIVER_PCICORE is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
# CONFIG_BCMA is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_SM501=m
# CONFIG_HTC_PASIC3 is not set
CONFIG_MFD_STMPE=y

#
# STMPE Interface Drivers
#
# CONFIG_STMPE_SPI is not set
# CONFIG_MFD_TMIO is not set
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_SPI=y
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_SPI=y
# CONFIG_MFD_MC13XXX_SPI is not set
CONFIG_ABX500_CORE=y
# CONFIG_EZX_PCAP is not set
# CONFIG_MFD_CS5535 is not set
# CONFIG_LPC_SCH is not set
# CONFIG_LPC_ICH is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_VX855 is not set
# CONFIG_REGULATOR is not set
CONFIG_MEDIA_SUPPORT=m

#
# Multimedia core support
#
# CONFIG_VIDEO_DEV is not set
# CONFIG_DVB_CORE is not set
# CONFIG_VIDEO_MEDIA is not set

#
# Multimedia drivers
#
CONFIG_RC_CORE=m
CONFIG_LIRC=m
CONFIG_RC_MAP=m
CONFIG_IR_NEC_DECODER=m
CONFIG_IR_RC5_DECODER=m
CONFIG_IR_RC6_DECODER=m
CONFIG_IR_JVC_DECODER=m
CONFIG_IR_SONY_DECODER=m
CONFIG_IR_RC5_SZ_DECODER=m
CONFIG_IR_SANYO_DECODER=m
CONFIG_IR_MCE_KBD_DECODER=m
CONFIG_IR_LIRC_CODEC=m
# CONFIG_RC_ATI_REMOTE is not set
# CONFIG_IR_ENE is not set
# CONFIG_IR_IMON is not set
# CONFIG_IR_MCEUSB is not set
# CONFIG_IR_ITE_CIR is not set
# CONFIG_IR_FINTEK is not set
# CONFIG_IR_NUVOTON is not set
# CONFIG_IR_REDRAT3 is not set
# CONFIG_IR_STREAMZAP is not set
# CONFIG_IR_WINBOND_CIR is not set
# CONFIG_RC_LOOPBACK is not set
# CONFIG_IR_GPIO_CIR is not set

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
CONFIG_EXYNOS_VIDEO=y
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
# CONFIG_SOUND is not set

#
# HID support
#
# CONFIG_HID is not set
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB_ARCH_HAS_XHCI=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
# CONFIG_USB is not set
# CONFIG_USB_OTG_WHITELIST is not set
# CONFIG_USB_OTG_BLACKLIST_HUB is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
# CONFIG_MMC is not set
CONFIG_MEMSTICK=m
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
CONFIG_MEMSTICK_UNSAFE_RESUME=y
CONFIG_MSPRO_BLOCK=m

#
# MemoryStick Host Controller Drivers
#
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=m

#
# LED drivers
#
# CONFIG_LEDS_CLEVO_MAIL is not set
# CONFIG_LEDS_WM831X_STATUS is not set
CONFIG_LEDS_DA9052=m
# CONFIG_LEDS_DAC124S085 is not set
# CONFIG_LEDS_INTEL_SS4200 is not set
CONFIG_LEDS_OT200=m
CONFIG_LEDS_TRIGGERS=y

#
# LED Triggers
#
# CONFIG_LEDS_TRIGGER_TIMER is not set
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_LEDS_TRIGGER_TRANSIENT is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y

#
# Reporting subsystems
#
# CONFIG_EDAC_DEBUG is not set
# CONFIG_EDAC_MM_EDAC is not set
# CONFIG_RTC_CLASS is not set
CONFIG_DMADEVICES=y
CONFIG_DMADEVICES_DEBUG=y
CONFIG_DMADEVICES_VDEBUG=y

#
# DMA Devices
#
# CONFIG_INTEL_MID_DMAC is not set
# CONFIG_INTEL_IOATDMA is not set
CONFIG_TIMB_DMA=m
# CONFIG_PCH_DMA is not set
CONFIG_DMA_ENGINE=y

#
# DMA Clients
#
CONFIG_NET_DMA=y
# CONFIG_ASYNC_TX_DMA is not set
# CONFIG_DMATEST is not set
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=m
# CONFIG_UIO_CIF is not set
# CONFIG_UIO_PDRV is not set
CONFIG_UIO_PDRV_GENIRQ=m
# CONFIG_UIO_AEC is not set
# CONFIG_UIO_SERCOS3 is not set
# CONFIG_UIO_PCI_GENERIC is not set
# CONFIG_UIO_NETX is not set

#
# Virtio drivers
#
# CONFIG_VIRTIO_BALLOON is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
# CONFIG_STAGING is not set
# CONFIG_X86_PLATFORM_DEVICES is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_CLKBLD_I8253=y
CONFIG_IOMMU_SUPPORT=y
# CONFIG_AMD_IOMMU is not set

#
# Remoteproc drivers (EXPERIMENTAL)
#

#
# Rpmsg drivers (EXPERIMENTAL)
#
CONFIG_VIRT_DRIVERS=y
# CONFIG_PM_DEVFREQ is not set
# CONFIG_EXTCON is not set
CONFIG_MEMORY=y
# CONFIG_IIO is not set
# CONFIG_VME_BUS is not set

#
# Ubuntu Supplied Third-Party Device Drivers
#

#
# Firmware Drivers
#
CONFIG_EDD=m
CONFIG_EDD_OFF=y
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=m
# CONFIG_DCDBAS is not set
# CONFIG_DMIID is not set
# CONFIG_DMI_SYSFS is not set
CONFIG_ISCSI_IBFT_FIND=y
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=m
CONFIG_EXT2_FS_XATTR=y
# CONFIG_EXT2_FS_POSIX_ACL is not set
CONFIG_EXT2_FS_SECURITY=y
# CONFIG_EXT2_FS_XIP is not set
# CONFIG_EXT3_FS is not set
CONFIG_EXT4_FS=m
CONFIG_EXT4_USE_FOR_EXT23=y
# CONFIG_EXT4_FS_XATTR is not set
CONFIG_EXT4_DEBUG=y
CONFIG_JBD2=m
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=m
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_XFS_FS=m
CONFIG_XFS_QUOTA=y
# CONFIG_XFS_POSIX_ACL is not set
CONFIG_XFS_RT=y
CONFIG_GFS2_FS=m
CONFIG_OCFS2_FS=m
CONFIG_OCFS2_FS_O2CB=m
# CONFIG_OCFS2_FS_STATS is not set
# CONFIG_OCFS2_DEBUG_MASKLOG is not set
# CONFIG_OCFS2_DEBUG_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
# CONFIG_INOTIFY_USER is not set
CONFIG_FANOTIFY=y
# CONFIG_FANOTIFY_ACCESS_PERMISSIONS is not set
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
# CONFIG_PRINT_QUOTA_WARNING is not set
CONFIG_QUOTA_DEBUG=y
CONFIG_QUOTA_TREE=m
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=m
CONFIG_QUOTACTL=y
# CONFIG_AUTOFS4_FS is not set
# CONFIG_FUSE_FS is not set
# CONFIG_OVERLAYFS_FS is not set

#
# Caches
#
CONFIG_FSCACHE=m
# CONFIG_FSCACHE_STATS is not set
CONFIG_FSCACHE_HISTOGRAM=y
# CONFIG_FSCACHE_DEBUG is not set
CONFIG_FSCACHE_OBJECT_LIST=y
CONFIG_CACHEFILES=m
# CONFIG_CACHEFILES_DEBUG is not set
# CONFIG_CACHEFILES_HISTOGRAM is not set

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
CONFIG_MSDOS_FS=m
# CONFIG_VFAT_FS is not set
CONFIG_FAT_DEFAULT_CODEPAGE=437
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_VMCORE=y
# CONFIG_PROC_SYSCTL is not set
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
CONFIG_TMPFS_XATTR=y
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=m
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_HFSPLUS_FS is not set
# CONFIG_JFFS2_FS is not set
# CONFIG_CRAMFS is not set
# CONFIG_SQUASHFS is not set
# CONFIG_VXFS_FS is not set
CONFIG_MINIX_FS=m
# CONFIG_OMFS_FS is not set
CONFIG_HPFS_FS=m
CONFIG_QNX4FS_FS=m
CONFIG_QNX6FS_FS=m
CONFIG_QNX6FS_DEBUG=y
# CONFIG_ROMFS_FS is not set
CONFIG_PSTORE=y
# CONFIG_PSTORE_RAM is not set
CONFIG_SYSV_FS=m
CONFIG_UFS_FS=m
# CONFIG_UFS_DEBUG is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=m
# CONFIG_NLS_CODEPAGE_850 is not set
CONFIG_NLS_CODEPAGE_852=m
CONFIG_NLS_CODEPAGE_855=m
# CONFIG_NLS_CODEPAGE_857 is not set
CONFIG_NLS_CODEPAGE_860=m
# CONFIG_NLS_CODEPAGE_861 is not set
CONFIG_NLS_CODEPAGE_862=m
# CONFIG_NLS_CODEPAGE_863 is not set
CONFIG_NLS_CODEPAGE_864=m
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
CONFIG_NLS_CODEPAGE_869=m
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=m
CONFIG_NLS_CODEPAGE_932=m
CONFIG_NLS_CODEPAGE_949=m
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
CONFIG_NLS_CODEPAGE_1250=m
# CONFIG_NLS_CODEPAGE_1251 is not set
# CONFIG_NLS_ASCII is not set
CONFIG_NLS_ISO8859_1=m
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=m
CONFIG_NLS_ISO8859_5=m
CONFIG_NLS_ISO8859_6=m
# CONFIG_NLS_ISO8859_7 is not set
CONFIG_NLS_ISO8859_9=m
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=m
CONFIG_NLS_KOI8_R=m
# CONFIG_NLS_KOI8_U is not set
# CONFIG_NLS_MAC_ROMAN is not set
CONFIG_NLS_MAC_CELTIC=m
CONFIG_NLS_MAC_CENTEURO=m
# CONFIG_NLS_MAC_CROATIAN is not set
CONFIG_NLS_MAC_CYRILLIC=m
CONFIG_NLS_MAC_GAELIC=m
CONFIG_NLS_MAC_GREEK=m
# CONFIG_NLS_MAC_ICELAND is not set
CONFIG_NLS_MAC_INUIT=m
CONFIG_NLS_MAC_ROMANIAN=m
CONFIG_NLS_MAC_TURKISH=m
# CONFIG_NLS_UTF8 is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
CONFIG_ENABLE_WARN_DEPRECATED=y
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=2048
# CONFIG_MAGIC_SYSRQ is not set
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
CONFIG_UNUSED_SYMBOLS=y
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
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
# CONFIG_DEBUG_OBJECTS is not set
CONFIG_SLUB_DEBUG_ON=y
# CONFIG_SLUB_STATS is not set
# CONFIG_DEBUG_PREEMPT is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
# CONFIG_PROVE_RCU is not set
CONFIG_SPARSE_RCU_POINTER=y
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_STACKTRACE=y
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_INFO is not set
CONFIG_DEBUG_VM=y
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_WRITECOUNT=y
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_LIST is not set
# CONFIG_TEST_LIST_SORT is not set
CONFIG_DEBUG_SG=y
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
CONFIG_RCU_TORTURE_TEST=m
CONFIG_RCU_CPU_STALL_TIMEOUT=60
CONFIG_RCU_CPU_STALL_VERBOSE=y
CONFIG_RCU_CPU_STALL_INFO=y
# CONFIG_RCU_TRACE is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_LKDTM=m
# CONFIG_CPU_NOTIFIER_ERROR_INJECT is not set
CONFIG_FAULT_INJECTION=y
# CONFIG_FAILSLAB is not set
CONFIG_FAIL_PAGE_ALLOC=y
# CONFIG_FAIL_MAKE_REQUEST is not set
# CONFIG_FAIL_IO_TIMEOUT is not set
CONFIG_FAULT_INJECTION_DEBUG_FS=y
CONFIG_LATENCYTOP=y
# CONFIG_DEBUG_PAGEALLOC is not set
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
# CONFIG_EVENT_POWER_TRACING_DEPRECATED is not set
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
# CONFIG_FUNCTION_TRACER is not set
CONFIG_IRQSOFF_TRACER=y
CONFIG_PREEMPT_TRACER=y
# CONFIG_SCHED_TRACER is not set
# CONFIG_FTRACE_SYSCALLS is not set
CONFIG_TRACE_BRANCH_PROFILING=y
# CONFIG_BRANCH_PROFILE_NONE is not set
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
CONFIG_PROFILE_ALL_BRANCHES=y
# CONFIG_BRANCH_TRACER is not set
# CONFIG_STACK_TRACER is not set
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_UPROBE_EVENT=y
CONFIG_PROBE_EVENTS=y
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
CONFIG_RING_BUFFER_BENCHMARK=m
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DYNAMIC_DEBUG is not set
# CONFIG_DMA_API_DEBUG is not set
CONFIG_ATOMIC64_SELFTEST=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_TEST_KSTRTOX=m
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
# CONFIG_DEBUG_RODATA_TEST is not set
CONFIG_DEBUG_SET_MODULE_RONX=y
CONFIG_DEBUG_NX_TEST=m
# CONFIG_IOMMU_DEBUG is not set
CONFIG_IOMMU_STRESS=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
# CONFIG_IO_DELAY_0XED is not set
CONFIG_IO_DELAY_UDELAY=y
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=2
CONFIG_DEBUG_BOOT_PARAMS=y
CONFIG_CPA_DEBUG=y
CONFIG_OPTIMIZE_INLINING=y
CONFIG_DEBUG_NMI_SELFTEST=y

#
# Security options
#
# CONFIG_KEYS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_PATH=y
# CONFIG_SECURITY_TOMOYO is not set
CONFIG_SECURITY_APPARMOR=y
CONFIG_SECURITY_APPARMOR_BOOTPARAM_VALUE=1
# CONFIG_SECURITY_YAMA is not set
CONFIG_INTEGRITY=y
CONFIG_IMA=y
CONFIG_IMA_MEASURE_PCR_IDX=10
CONFIG_IMA_AUDIT=y
CONFIG_DEFAULT_SECURITY_APPARMOR=y
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_DEFAULT_SECURITY="apparmor"
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=m
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=m
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=m
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP=m
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_USER=m
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=m
# CONFIG_CRYPTO_NULL is not set
CONFIG_CRYPTO_WORKQUEUE=y
# CONFIG_CRYPTO_CRYPTD is not set
CONFIG_CRYPTO_AUTHENC=m
# CONFIG_CRYPTO_TEST is not set

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=m
CONFIG_CRYPTO_GCM=m
CONFIG_CRYPTO_SEQIV=m

#
# Block modes
#
CONFIG_CRYPTO_CBC=m
CONFIG_CRYPTO_CTR=m
CONFIG_CRYPTO_CTS=m
# CONFIG_CRYPTO_ECB is not set
CONFIG_CRYPTO_LRW=m
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=m

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=m
# CONFIG_CRYPTO_CRC32C_INTEL is not set
CONFIG_CRYPTO_GHASH=m
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
CONFIG_CRYPTO_RMD128=m
CONFIG_CRYPTO_RMD160=m
CONFIG_CRYPTO_RMD256=m
CONFIG_CRYPTO_RMD320=m
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=m
# CONFIG_CRYPTO_SHA256 is not set
CONFIG_CRYPTO_SHA512=m
CONFIG_CRYPTO_TGR192=m
# CONFIG_CRYPTO_WP512 is not set
# CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL is not set

#
# Ciphers
#
# CONFIG_CRYPTO_AES is not set
# CONFIG_CRYPTO_AES_X86_64 is not set
# CONFIG_CRYPTO_AES_NI_INTEL is not set
CONFIG_CRYPTO_ANUBIS=m
# CONFIG_CRYPTO_ARC4 is not set
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_BLOWFISH_X86_64 is not set
CONFIG_CRYPTO_CAMELLIA=m
CONFIG_CRYPTO_CAMELLIA_X86_64=m
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST6 is not set
# CONFIG_CRYPTO_DES is not set
# CONFIG_CRYPTO_FCRYPT is not set
CONFIG_CRYPTO_KHAZAD=m
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_SERPENT=m
# CONFIG_CRYPTO_SERPENT_SSE2_X86_64 is not set
# CONFIG_CRYPTO_TEA is not set
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
# CONFIG_CRYPTO_TWOFISH_X86_64 is not set
# CONFIG_CRYPTO_TWOFISH_X86_64_3WAY is not set

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
CONFIG_CRYPTO_ZLIB=m
# CONFIG_CRYPTO_LZO is not set

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYPTO_USER_API=m
CONFIG_CRYPTO_USER_API_HASH=m
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
# CONFIG_CRYPTO_HW is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_KVM is not set
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
# CONFIG_CRC32_SELFTEST is not set
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
# CONFIG_CRC7 is not set
# CONFIG_LIBCRC32C is not set
# CONFIG_CRC8 is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=m
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_XZ_DEC=m
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
# CONFIG_XZ_DEC_ARMTHUMB is not set
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_BCH=m
CONFIG_BCH_CONST_PARAMS=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_AVERAGE=y
# CONFIG_CORDIC is not set
# CONFIG_DDR is not set

--3V7upXqbjpZ4EhLz--

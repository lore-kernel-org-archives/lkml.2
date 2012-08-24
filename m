Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756865Ab2HXHQI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 03:16:08 -0400
Received: from mga11.intel.com ([192.55.52.93]:59198 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755100Ab2HXHP5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 03:15:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,302,1344236400"; 
   d="scan'208";a="210253507"
Date: Fri, 24 Aug 2012 15:15:12 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: BUG: Kprobe smoke test: 2 out of 6 tests failed
Message-ID: <20120824071512.GA965@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="HlL+5n6rz5pIUxbD"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Steven,

The following test fails are mostly due to this commit, or one of the
last 4 commits in

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git tip/perf/core
head:   d57c5d51a30152f3175d2344cb6395f08bf8ee0c
commit: d57c5d51a30152f3175d2344cb6395f08bf8ee0c [100/100] ftrace/x86: Add support for -mfentry to x86_64

[    9.084881] Kprobe smoke test failed: register_jprobe returned -22
[    9.086786] Kprobe smoke test failed: register_jprobes returned -22
[    9.121281] BUG: Kprobe smoke test: 2 out of 6 tests failed
[    9.171132] Testing tracer function: PASSED
[    9.408938] Testing dynamic ftrace: PASSED

Thanks,
Fengguang

--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-kvm-waimea-20320-2012-08-24-06-33-30-3.6.0-rc1-00241-gd57c5d5-709"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Linux version 3.6.0-rc1-00241-gd57c5d5 (kbuild@snb) (gcc ver=
sion 4.7.1 (Debian 4.7.1-6) ) #709 SMP Fri Aug 24 05:46:29 CST 2012
[    0.000000] Command line: trinity=3D2m hung_task_panic=3D1 branch=3Dtrac=
e/tip/perf/core log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3Dd=
ebug dynamic_printk sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 con=
sole=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=
=3Dvmlinuz-2012-08-24-05-47-39-trace:tip:perf:core:d57c5d5-d57c5d5-x86_64-r=
andconfig-s158-7-waimea BOOT_IMAGE=3Dkernel-tests/kernels/x86_64-randconfig=
-s158/d57c5d5/vmlinuz-3.6.0-rc1-00241-gd57c5d5
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000093bff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000093c00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2007
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x400000000
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
[    0.000000] found SMP MP-table at [mem 0x000fdab0-0x000fdabf] mapped at =
[ffff8800000fdab0]
[    0.000000]   mpc: fdac0-fdbe4
[    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
[    0.000000] Base memory trampoline at [ffff88000008d000] 8d000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x0fffdfff]
[    0.000000]  [mem 0x00000000-0x0fdfffff] page 2M
[    0.000000]  [mem 0x0fe00000-0x0fffdfff] page 4k
[    0.000000] kernel direct mapping tables up to 0xfffdfff @ [mem 0x0e8540=
00-0x0e8d5fff]
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 128044(97%)
[    0.000000] RAMDISK: [mem 0x0e8d6000-0x0ffeffff]
[    0.000000] ACPI: RSDP 00000000000fd920 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 000000000fffe550 00038 (v01 BOCHS  BXPCRSDT 00000=
001 BXPC 00000001)
[    0.000000] ACPI: FACP 000000000fffff80 00074 (v01 BOCHS  BXPCFACP 00000=
001 BXPC 00000001)
[    0.000000] ACPI: DSDT 000000000fffe590 01121 (v01   BXPC   BXDSDT 00000=
001 INTL 20100528)
[    0.000000] ACPI: FACS 000000000fffff40 00040
[    0.000000] ACPI: SSDT 000000000ffffe40 000FF (v01 BOCHS  BXPCSSDT 00000=
001 BXPC 00000001)
[    0.000000] ACPI: APIC 000000000ffffd50 00080 (v01 BOCHS  BXPCAPIC 00000=
001 BXPC 00000001)
[    0.000000] ACPI: HPET 000000000ffffd10 00038 (v01 BOCHS  BXPCHPET 00000=
001 BXPC 00000001)
[    0.000000] ACPI: SSDT 000000000ffff6c0 00644 (v01   BXPC BXSSDTPC 00000=
001 INTL 20100528)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fb000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000000fffdfff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x0fffdfff]
[    0.000000]   NODE_DATA [mem 0x0fff9000-0x0fffdfff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:1bae841, boot clock
[    0.000000]  [ffffea0000000000-ffffea00003fffff] PMD -> [ffff88000d40000=
0-ffff88000d7fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x00092fff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65409
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 3901 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 960 pages used for memmap
[    0.000000]   DMA32 zone: 60478 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fb000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 2, APIC =
INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 2, APIC =
INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 2, APIC =
INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 2, APIC =
INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 2, APIC =
INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 2, APIC =
INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 2, APIC =
INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 2, APIC =
INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 2, APIC =
INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 2, APIC =
INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 2, APIC =
INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 2, APIC =
INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 2, APIC =
INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 2, APIC =
INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 2, APIC =
INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5fa000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:2 nr_cpu_ids:2 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 475 pages/cpu @ffff88000da00000 s1914112 r8=
192 d23296 u2097152
[    0.000000] pcpu-alloc: s1914112 r8192 d23296 u2097152 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] kvm-clock: cpu 0, msr 0:dbd2841, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr da0cec0
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 64379
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: trinity=3D2m hung_task_panic=3D1 branch=
=3Dtrace/tip/perf/core log_buf_len=3D8M ignore_loglevel debug sched_debug a=
pic=3Ddebug dynamic_printk sysrq_always_enabled panic=3D10  prompt_ramdisk=
=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 r=
w link=3Dvmlinuz-2012-08-24-05-47-39-trace:tip:perf:core:d57c5d5-d57c5d5-x8=
6_64-randconfig-s158-7-waimea BOOT_IMAGE=3Dkernel-tests/kernels/x86_64-rand=
config-s158/d57c5d5/vmlinuz-3.6.0-rc1-00241-gd57c5d5
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 195436k/262136k available (5278k kernel code, 500k a=
bsent, 66200k reserved, 4803k data, 2656k init)
[    0.000000] SLUB: Genslabs=3D15, HWalign=3D64, Order=3D0-3, MinObjects=
=3D0, CPUs=3D2, Nodes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000] NR_IRQS:4352 nr_irqs:512 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 6367 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] ODEBUG: 0 of 0 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 3300.196 MHz processor
[    0.003333] Calibrating delay loop (skipped) preset value.. 6603.40 Bogo=
MIPS (lpj=3D11000653)
[    0.003376] pid_max: default: 32768 minimum: 301
[    0.007448] Dentry cache hash table entries: 32768 (order: 6, 262144 byt=
es)
[    0.010164] Inode-cache hash table entries: 16384 (order: 5, 131072 byte=
s)
[    0.012430] Mount-cache hash table entries: 256
[    0.019694] mce: CPU supports 10 MCE banks
[    0.020077] numa_add_cpu cpu 0 node 0: mask now 0
[    0.021567] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.021567] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.021567] tlb_flushall_shift is 0x6
[    0.040075] Freeing SMP alternatives: 12k freed
[    0.043386] ACPI: Core revision 20120711
[    0.117865] ftrace: allocating 12215 entries in 48 pages
[    0.124087] Getting VERSION: 50014
[    0.126680] Getting VERSION: 50014
[    0.127810] Getting ID: 0
[    0.128766] Getting ID: ff000000
[    0.130096] Getting LVT0: 8700
[    0.131478] Getting LVT1: 8400
[    0.132557] enabled ExtINT on CPU#0
[    0.134611] ENABLING IO-APIC IRQs
[    0.136675] init IO_APIC IRQs
[    0.137803]  apic 2 pin 0 not connected
[    0.139142] IOAPIC[0]: Set routing entry (2-1 -> 0x41 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.140103] IOAPIC[0]: Set routing entry (2-2 -> 0x51 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.143398] IOAPIC[0]: Set routing entry (2-3 -> 0x61 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.146768] IOAPIC[0]: Set routing entry (2-4 -> 0x71 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.150059] IOAPIC[0]: Set routing entry (2-5 -> 0x81 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.153426] IOAPIC[0]: Set routing entry (2-6 -> 0x91 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.155808] IOAPIC[0]: Set routing entry (2-7 -> 0xa1 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.156741] IOAPIC[0]: Set routing entry (2-8 -> 0xb1 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.160051] IOAPIC[0]: Set routing entry (2-9 -> 0xc1 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.163383] IOAPIC[0]: Set routing entry (2-10 -> 0xd1 -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.165608] IOAPIC[0]: Set routing entry (2-11 -> 0xe1 -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.166724] IOAPIC[0]: Set routing entry (2-12 -> 0x22 -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.170057] IOAPIC[0]: Set routing entry (2-13 -> 0x42 -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.172333] IOAPIC[0]: Set routing entry (2-14 -> 0x52 -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.173451] IOAPIC[0]: Set routing entry (2-15 -> 0x62 -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.176691]  apic 2 pin 16 not connected
[    0.177886]  apic 2 pin 17 not connected
[    0.180000]  apic 2 pin 18 not connected
[    0.181252]  apic 2 pin 19 not connected
[    0.182329]  apic 2 pin 20 not connected
[    0.183331]  apic 2 pin 21 not connected
[    0.184352]  apic 2 pin 22 not connected
[    0.185377]  apic 2 pin 23 not connected
[    0.186859] ..TIMER: vector=3D0x51 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.188431] smpboot: CPU0: Intel Common KVM processor stepping 01
[    0.193332] Using local APIC timer interrupts.
[    0.193332] calibrating APIC timer ...
[    0.199987] ... lapic delta =3D 10498206
[    0.199987] ... PM-Timer delta =3D 601252
[    0.199987] APIC calibration not consistent with PM-Timer: 167ms instead=
 of 100ms
[    0.199987] APIC delta adjusted to PM-Timer: 6250082 (10498206)
[    0.199987] TSC delta adjusted to PM-Timer: 330018564 (554329109)
[    0.199987] ..... delta 6250082
[    0.199987] ..... mult: 268456481
[    0.199987] ..... calibration result: 3333377
[    0.199987] ..... CPU clock speed is 3300.1718 MHz.
[    0.199987] ..... host bus clock speed is 1000.0377 MHz.
[    0.200081] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.208055] Testing tracer nop: PASSED
[    0.211223] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.214986] SMP alternatives: lockdep: fixing up alternatives
[    0.223331] smpboot: Booting Node   0, Processors  #1 OK
[    0.003333] kvm-clock: cpu 1, msr 0:ddd2841, secondary cpu clock
[    0.003333] masked ExtINT on CPU#1
[    0.003333] numa_add_cpu cpu 1 node 0: mask now 0-1
[    0.267357] Brought up 2 CPUs
[    0.268323] ----------------
[    0.269990] | NMI testsuite:
[    0.270912] --------------------
[    0.271881]   remote IPI:[    0.269983] KVM setup async PF for cpu 1
[    0.269983] kvm-stealtime: cpu 1, msr dc0cec0
  ok  |
[    0.290709]    local IPI:  ok  |
[    0.310007] --------------------
[    0.311045] Good, all   2 testcases passed! |
[    0.312249] ---------------------------------
[    0.313324] smpboot: Total of 2 processors activated (13206.81 BogoMIPS)
[    0.320797] CPU0 attaching sched-domain:
[    0.322038]  domain 0: span 0-1 level CPU
[    0.323330]   groups: 0 (cpu_power =3D 1023) 1 (cpu_power =3D 1023)
[    0.327039] CPU1 attaching sched-domain:
[    0.328158]  domain 0: span 0-1 level CPU
[    0.330702]   groups: 1 (cpu_power =3D 1023) 0 (cpu_power =3D 1023)
[    0.366761] device: 'platform': device_add
[    0.368335] bus: 'platform': registered
[    0.369767] bus: 'cpu': registered
[    0.370047] device: 'cpu': device_add
[    0.371458] bus: 'memory': registered
[    0.373383] device: 'memory': device_add
[    0.374650] device: 'memory0': device_add
[    0.375897] bus: 'memory': add device memory0
[    0.376971] device: 'memory1': device_add
[    0.378164] bus: 'memory': add device memory1
[    0.390912] device class 'regulator': registering
[    0.392765] Registering platform device 'reg-dummy'. Parent at platform
[    0.393329] device: 'reg-dummy': device_add
[    0.400046] bus: 'platform': add device reg-dummy
[    0.403424] bus: 'platform': add driver reg-dummy
[    0.404794] bus: 'platform': driver_probe_device: matched device reg-dum=
my with driver reg-dummy
[    0.406650] bus: 'platform': really_probe: probing driver reg-dummy with=
 device reg-dummy
[    0.410182] device: 'regulator.0': device_add
[    0.411957] dummy:=20
[    0.416885] driver: 'reg-dummy': driver_bound: bound to device 'reg-dumm=
y'
[    0.420029] bus: 'platform': really_probe: bound device reg-dummy to dri=
ver reg-dummy
[    0.424548] NET: Registered protocol family 16
[    0.425961] device class 'bdi': registering
[    0.426888] device class 'pci_bus': registering
[    0.428419] bus: 'pci': registered
[    0.429990] device class 'tty': registering
[    0.436773] device class 'vtconsole': registering
[    0.438205] device: 'vtcon0': device_add
[    0.440054] bus: 'node': registered
[    0.441143] device: 'node': device_add
[    0.442655] bus: 'spi': registered
[    0.443313] device class 'spi_master': registering
[    0.450583] ACPI: bus type pci registered
[    0.451784] PCI: Using configuration type 1 for base access
[    0.456733] device: 'node0': device_add
[    0.458107] bus: 'node': add device node0
[    0.460204] device: 'cpu0': device_add
[    0.461566] bus: 'cpu': add device cpu0
[    0.463056] device: 'cpu1': device_add
[    0.466716] bus: 'cpu': add device cpu1
[    0.480767] device: 'default': device_add
[    0.484455] bio: create slab <bio-0> at 0
[    0.493556] device class 'block': registering
[    0.497568] ACPI: Added _OSI(Module Device)
[    0.499995] ACPI: Added _OSI(Processor Device)
[    0.501238] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.503341] ACPI: Added _OSI(Processor Aggregator Device)
[    0.527105] ACPI: EC: Look up EC in DSDT
[    0.687942] ACPI: Interpreter enabled
[    0.689183] ACPI: (supports S0 S5)
[    0.690859] ACPI: Using IOAPIC for interrupt routing
[    0.692754] bus: 'acpi': registered
[    0.693299] bus: 'acpi': add driver power
[    0.700443] device: 'LNXSYSTM:00': device_add
[    0.701649] bus: 'acpi': add device LNXSYSTM:00
[    0.704134] device: 'device:00': device_add
[    0.705496] bus: 'acpi': add device device:00
[    0.708212] device: 'PNP0A03:00': device_add
[    0.709410] bus: 'acpi': add device PNP0A03:00
[    0.718709] device: 'device:01': device_add
[    0.720028] bus: 'acpi': add device device:01
[    0.723412] device: 'device:02': device_add
[    0.724538] bus: 'acpi': add device device:02
[    0.727366] device: 'PNP0B00:00': device_add
[    0.728614] bus: 'acpi': add device PNP0B00:00
[    0.731488] device: 'PNP0303:00': device_add
[    0.732655] bus: 'acpi': add device PNP0303:00
[    0.735386] device: 'PNP0F13:00': device_add
[    0.740028] bus: 'acpi': add device PNP0F13:00
[    0.744797] device: 'PNP0700:00': device_add
[    0.745979] bus: 'acpi': add device PNP0700:00
[    0.754076] device: 'PNP0400:00': device_add
[    0.755288] bus: 'acpi': add device PNP0400:00
[    0.759769] device: 'PNP0501:00': device_add
[    0.763355] bus: 'acpi': add device PNP0501:00
[    0.767418] device: 'device:03': device_add
[    0.769029] bus: 'acpi': add device device:03
[    0.771334] device: 'device:04': device_add
[    0.772568] bus: 'acpi': add device device:04
[    0.777487] device: 'device:05': device_add
[    0.778636] bus: 'acpi': add device device:05
[    0.783673] device: 'device:06': device_add
[    0.784883] bus: 'acpi': add device device:06
[    0.796638] device: 'device:07': device_add
[    0.797956] bus: 'acpi': add device device:07
[    0.801407] device: 'device:08': device_add
[    0.803392] bus: 'acpi': add device device:08
[    0.807040] device: 'device:09': device_add
[    0.810004] bus: 'acpi': add device device:09
[    0.820226] device: 'device:0a': device_add
[    0.821550] bus: 'acpi': add device device:0a
[    0.824405] device: 'device:0b': device_add
[    0.825702] bus: 'acpi': add device device:0b
[    0.827909] device: 'device:0c': device_add
[    0.830025] bus: 'acpi': add device device:0c
[    0.833869] device: 'device:0d': device_add
[    0.835201] bus: 'acpi': add device device:0d
[    0.837684] device: 'device:0e': device_add
[    0.838822] bus: 'acpi': add device device:0e
[    0.844092] device: 'device:0f': device_add
[    0.846671] bus: 'acpi': add device device:0f
[    0.854213] device: 'device:10': device_add
[    0.855381] bus: 'acpi': add device device:10
[    0.857830] device: 'device:11': device_add
[    0.858965] bus: 'acpi': add device device:11
[    0.861236] device: 'device:12': device_add
[    0.866668] bus: 'acpi': add device device:12
[    0.869114] device: 'device:13': device_add
[    0.869998] bus: 'acpi': add device device:13
[    0.872587] device: 'device:14': device_add
[    0.873332] bus: 'acpi': add device device:14
[    0.883712] device: 'device:15': device_add
[    0.885063] bus: 'acpi': add device device:15
[    0.887953] device: 'device:16': device_add
[    0.889078] bus: 'acpi': add device device:16
[    0.891234] device: 'device:17': device_add
[    0.893352] bus: 'acpi': add device device:17
[    0.897220] device: 'device:18': device_add
[    0.898384] bus: 'acpi': add device device:18
[    0.900862] device: 'device:19': device_add
[    0.901994] bus: 'acpi': add device device:19
[    0.906671] device: 'device:1a': device_add
[    0.907877] bus: 'acpi': add device device:1a
[    0.911253] device: 'device:1b': device_add
[    0.913344] bus: 'acpi': add device device:1b
[    0.917956] device: 'device:1c': device_add
[    0.920048] bus: 'acpi': add device device:1c
[    0.924350] device: 'device:1d': device_add
[    0.925500] bus: 'acpi': add device device:1d
[    0.927933] device: 'device:1e': device_add
[    0.929062] bus: 'acpi': add device device:1e
[    0.933843] device: 'device:1f': device_add
[    0.935026] bus: 'acpi': add device device:1f
[    0.937887] device: 'device:20': device_add
[    0.939078] bus: 'acpi': add device device:20
[    0.941217] device: 'device:21': device_add
[    0.943326] bus: 'acpi': add device device:21
[    0.947957] device: 'device:22': device_add
[    0.949993] bus: 'acpi': add device device:22
[    0.957342] device: 'PNP0103:00': device_add
[    0.960010] bus: 'acpi': add device PNP0103:00
[    0.966641] device: 'PNP0C0F:00': device_add
[    0.967875] bus: 'acpi': add device PNP0C0F:00
[    0.974956] device: 'PNP0C0F:01': device_add
[    0.976683] bus: 'acpi': add device PNP0C0F:01
[    0.981560] device: 'PNP0C0F:02': device_add
[    0.982696] bus: 'acpi': add device PNP0C0F:02
[    0.990738] device: 'PNP0C0F:03': device_add
[    0.992222] bus: 'acpi': add device PNP0C0F:03
[    0.996747] device: 'PNP0C0F:04': device_add
[    1.000051] bus: 'acpi': add device PNP0C0F:04
[    1.005035] device: 'LNXCPU:00': device_add
[    1.006325] bus: 'acpi': add device LNXCPU:00
[    1.008870] device: 'LNXCPU:01': device_add
[    1.013337] bus: 'acpi': add device LNXCPU:01
[    1.017046] device: 'device:23': device_add
[    1.018199] bus: 'acpi': add device device:23
[    1.019648] device: 'LNXPWRBN:00': device_add
[    1.020014] bus: 'acpi': add device LNXPWRBN:00
[    1.021728] bus: 'acpi': add driver ec
[    1.023543] PCI: Ignoring host bridge windows from ACPI; if necessary, u=
se "pci=3Duse_crs" and report a bug
[    1.026619] bus: 'acpi': add driver pci_root
[    1.027794] bus: 'acpi': driver_probe_device: matched device PNP0A03:00 =
with driver pci_root
[    1.029941] bus: 'acpi': really_probe: probing driver pci_root with devi=
ce PNP0A03:00
[    1.033559] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    1.036967] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] =
(ignored)
[    1.039942] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] =
(ignored)
[    1.041829] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x00=
0bffff] (ignored)
[    1.046613] pci_root PNP0A03:00: host bridge window [mem 0xe0000000-0xfe=
bfffff] (ignored)
[    1.049976] PCI: root bus 00: using default resources
[    1.051294] device: 'pci0000:00': device_add
[    1.052615] device: '0000:00': device_add
[    1.053629] PCI host bridge to bus 0000:00
[    1.056641] pci_bus 0000:00: busn_res: [bus 00-ff] is inserted under dom=
ain [bus 00-ff]
[    1.059940] pci_bus 0000:00: root bus resource [bus 00-ff]
[    1.061252] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    1.063297] pci_bus 0000:00: root bus resource [mem 0x00000000-0xfffffff=
fff]
[    1.066795] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    1.070510] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    1.076613] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    1.084108] pci 0000:00:01.1: reg 20: [io  0xc1c0-0xc1cf]
[    1.087829] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    1.090573] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    1.092427] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    1.093547] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    1.100101] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
[    1.107307] pci 0000:00:02.0: reg 14: [mem 0xfebf4000-0xfebf4fff]
[    1.118440] pci 0000:00:02.0: reg 30: [mem 0xfebe0000-0xfebeffff pref]
[    1.120732] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    1.123339] pci 0000:00:03.0: reg 10: [mem 0xfeba0000-0xfebbffff]
[    1.133861] pci 0000:00:03.0: reg 14: [io  0xc000-0xc03f]
[    1.139236] pci 0000:00:03.0: reg 30: [mem 0xfebc0000-0xfebdffff pref]
[    1.143846] pci 0000:00:04.0: [8086:2668] type 00 class 0x040300
[    1.145607] pci 0000:00:04.0: reg 10: [mem 0xfebf0000-0xfebf3fff]
[    1.157401] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    1.159333] pci 0000:00:05.0: reg 10: [io  0xc040-0xc07f]
[    1.166631] pci 0000:00:05.0: reg 14: [mem 0xfebf5000-0xfebf5fff]
[    1.177740] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    1.179960] pci 0000:00:06.0: reg 10: [io  0xc080-0xc0bf]
[    1.184033] pci 0000:00:06.0: reg 14: [mem 0xfebf6000-0xfebf6fff]
[    1.193672] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    1.200454] pci 0000:00:07.0: reg 10: [io  0xc0c0-0xc0ff]
[    1.204077] pci 0000:00:07.0: reg 14: [mem 0xfebf7000-0xfebf7fff]
[    1.213065] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    1.217160] pci 0000:00:08.0: reg 10: [io  0xc100-0xc13f]
[    1.219983] pci 0000:00:08.0: reg 14: [mem 0xfebf8000-0xfebf8fff]
[    1.236867] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    1.240401] pci 0000:00:09.0: reg 10: [io  0xc140-0xc17f]
[    1.242439] pci 0000:00:09.0: reg 14: [mem 0xfebf9000-0xfebf9fff]
[    1.257480] pci 0000:00:0a.0: [1af4:1001] type 00 class 0x010000
[    1.260419] pci 0000:00:0a.0: reg 10: [io  0xc180-0xc1bf]
[    1.262666] pci 0000:00:0a.0: reg 14: [mem 0xfebfa000-0xfebfafff]
[    1.271985] pci 0000:00:0b.0: [8086:25ab] type 00 class 0x088000
[    1.276861] pci 0000:00:0b.0: reg 10: [mem 0xfebfb000-0xfebfb00f]
[    1.284310] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    1.343431]  pci0000:00: Unable to request _OSC control (_OSC support ma=
sk: 0x08)
[    1.346717] device: '0000:00:00.0': device_add
[    1.396141] bus: 'pci': add device 0000:00:00.0
[    1.400481] device: '0000:00:01.0': device_add
[    1.440719] bus: 'pci': add device 0000:00:01.0
[    1.442501] device: '0000:00:01.1': device_add
[    1.479611] bus: 'pci': add device 0000:00:01.1
[    1.480408] device: '0000:00:01.3': device_add
[    1.516745] bus: 'pci': add device 0000:00:01.3
[    1.520439] device: '0000:00:02.0': device_add
[    1.562692] bus: 'pci': add device 0000:00:02.0
[    1.563716] device: '0000:00:03.0': device_add
[    1.598595] bus: 'pci': add device 0000:00:03.0
[    1.606893] device: '0000:00:04.0': device_add
[    1.644332] bus: 'pci': add device 0000:00:04.0
[    1.646894] device: '0000:00:05.0': device_add
[    1.689054] bus: 'pci': add device 0000:00:05.0
[    1.693723] device: '0000:00:06.0': device_add
[    1.736883] bus: 'pci': add device 0000:00:06.0
[    1.738506] device: '0000:00:07.0': device_add
[    1.781412] bus: 'pci': add device 0000:00:07.0
[    1.782996] device: '0000:00:08.0': device_add
[    1.826399] bus: 'pci': add device 0000:00:08.0
[    1.830327] device: '0000:00:09.0': device_add
[    1.872861] bus: 'pci': add device 0000:00:09.0
[    1.874016] device: '0000:00:0a.0': device_add
[    1.914902] bus: 'pci': add device 0000:00:0a.0
[    1.916613] device: '0000:00:0b.0': device_add
[    1.962807] bus: 'pci': add device 0000:00:0b.0
[    1.963648] driver: 'PNP0A03:00': driver_bound: bound to device 'pci_roo=
t'
[    1.965469] bus: 'acpi': really_probe: bound device PNP0A03:00 to driver=
 pci_root
[    1.966816] bus: 'acpi': add driver pci_link
[    1.969991] bus: 'acpi': driver_probe_device: matched device PNP0C0F:00 =
with driver pci_link
[    1.976552] bus: 'acpi': really_probe: probing driver pci_link with devi=
ce PNP0C0F:00
[    1.981479] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    1.984150] driver: 'PNP0C0F:00': driver_bound: bound to device 'pci_lin=
k'
[    1.985968] bus: 'acpi': really_probe: bound device PNP0C0F:00 to driver=
 pci_link
[    1.989900] bus: 'acpi': driver_probe_device: matched device PNP0C0F:01 =
with driver pci_link
[    1.993212] bus: 'acpi': really_probe: probing driver pci_link with devi=
ce PNP0C0F:01
[    1.998383] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    2.001651] driver: 'PNP0C0F:01': driver_bound: bound to device 'pci_lin=
k'
[    2.003218] bus: 'acpi': really_probe: bound device PNP0C0F:01 to driver=
 pci_link
[    2.009901] bus: 'acpi': driver_probe_device: matched device PNP0C0F:02 =
with driver pci_link
[    2.012187] bus: 'acpi': really_probe: probing driver pci_link with devi=
ce PNP0C0F:02
[    2.016677] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    2.021580] driver: 'PNP0C0F:02': driver_bound: bound to device 'pci_lin=
k'
[    2.023219] bus: 'acpi': really_probe: bound device PNP0C0F:02 to driver=
 pci_link
[    2.025311] bus: 'acpi': driver_probe_device: matched device PNP0C0F:03 =
with driver pci_link
[    2.029886] bus: 'acpi': really_probe: probing driver pci_link with devi=
ce PNP0C0F:03
[    2.034931] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    2.037607] driver: 'PNP0C0F:03': driver_bound: bound to device 'pci_lin=
k'
[    2.039361] bus: 'acpi': really_probe: bound device PNP0C0F:03 to driver=
 pci_link
[    2.043227] bus: 'acpi': driver_probe_device: matched device PNP0C0F:04 =
with driver pci_link
[    2.046543] bus: 'acpi': really_probe: probing driver pci_link with devi=
ce PNP0C0F:04
[    2.051659] ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0
[    2.054629] driver: 'PNP0C0F:04': driver_bound: bound to device 'pci_lin=
k'
[    2.056549] bus: 'acpi': really_probe: bound device PNP0C0F:04 to driver=
 pci_link
[    2.060272] bus: 'pnp': registered
[    2.061392] device class 'misc': registering
[    2.063453] device: 'vga_arbiter': device_add
[    2.065222] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    2.066748] vgaarb: loaded
[    2.067672] vgaarb: bridge control possible 0000:00:02.0
[    2.069893] bus: 'spi': add driver wm831x
[    2.071209] bus: 'spi': add driver ezx-pcap
[    2.076697] bus: 'spi': add driver da9052
[    2.078326] bus: 'serio': registered
[    2.079881] device class 'input': registering
[    2.081452] device class 'rtc': registering
[    2.082768] device class 'power_supply': registering
[    2.083295] PCI: Using ACPI for IRQ routing
[    2.084542] PCI: pci_cache_line_size set to 64 bytes
[    2.087709] e820: reserve RAM buffer [mem 0x00093c00-0x0009ffff]
[    2.089924] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    2.093467] device class 'net': registering
[    2.095057] device: 'lo': device_add
[    2.103968] Switching to clocksource kvm-clock
[    2.106523] Warning: could not register annotated branches stats
[    2.666768] bus: 'pnp': add driver system
[    2.668178] pnp: PnP ACPI init
[    2.669204] device: 'pnp0': device_add
[    2.670385] ACPI: bus type pnp registered
[    2.671849] pnp 00:00: [bus 00-ff]
[    2.672932] pnp 00:00: [io  0x0cf8-0x0cff]
[    2.674184] pnp 00:00: [io  0x0000-0x0cf7 window]
[    2.675544] pnp 00:00: [io  0x0d00-0xffff window]
[    2.676778] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    2.698044] pnp 00:00: [mem 0xe0000000-0xfebfffff window]
[    2.699581] device: '00:00': device_add
[    2.701008] bus: 'pnp': add device 00:00
[    2.702393] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    2.704479] pnp 00:01: [io  0x0070-0x0071]
[    2.705700] pnp 00:01: [irq 8]
[    2.723958] pnp 00:01: [io  0x0072-0x0077]
[    2.725225] device: '00:01': device_add
[    2.726527] bus: 'pnp': add device 00:01
[    2.727837] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)
[    2.730441] pnp 00:02: [io  0x0060]
[    2.731585] pnp 00:02: [io  0x0064]
[    2.732681] pnp 00:02: [irq 1]
[    2.744828] device: '00:02': device_add
[    2.746194] bus: 'pnp': add device 00:02
[    2.747520] pnp 00:02: Plug and Play ACPI device, IDs PNP0303 (active)
[    2.750298] pnp 00:03: [irq 12]
[    2.751398] device: '00:03': device_add
[    2.752641] bus: 'pnp': add device 00:03
[    2.753946] pnp 00:03: Plug and Play ACPI device, IDs PNP0f13 (active)
[    2.773723] pnp 00:04: [io  0x03f2-0x03f5]
[    2.774963] pnp 00:04: [io  0x03f7]
[    2.776039] pnp 00:04: [irq 6]
[    2.776999] pnp 00:04: [dma 2]
[    2.778029] device: '00:04': device_add
[    2.779406] bus: 'pnp': add device 00:04
[    2.780717] pnp 00:04: Plug and Play ACPI device, IDs PNP0700 (active)
[    2.798079] pnp 00:05: [io  0x0378-0x037f]
[    2.799333] pnp 00:05: [irq 7]
[    2.800348] device: '00:05': device_add
[    2.801693] bus: 'pnp': add device 00:05
[    2.803081] pnp 00:05: Plug and Play ACPI device, IDs PNP0400 (active)
[    2.815914] pnp 00:06: [io  0x03f8-0x03ff]
[    2.817188] pnp 00:06: [irq 4]
[    2.818225] device: '00:06': device_add
[    2.819531] bus: 'pnp': add device 00:06
[    2.820852] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    2.850858] pnp 00:07: [mem 0xfed00000-0xfed003ff]
[    2.852370] device: '00:07': device_add
[    2.853802] bus: 'pnp': add device 00:07
[    2.855171] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
[    2.884494] pnp: PnP ACPI: found 8 devices
[    2.885729] ACPI: ACPI bus type pnp unregistered
[    2.887143] device class 'mem': registering
[    2.888517] device: 'mem': device_add
[    2.889958] device: 'kmem': device_add
[    2.891389] device: 'null': device_add
[    2.892698] device: 'port': device_add
[    2.905720] device: 'zero': device_add
[    2.907031] device: 'full': device_add
[    2.908444] device: 'random': device_add
[    2.909885] device: 'urandom': device_add
[    2.911335] device: 'kmsg': device_add
[    2.912642] device: 'oldmem': device_add
[    2.914028] device: 'tty': device_add
[    2.930491] device: 'console': device_add
[    2.931972] device: 'tty0': device_add
[    2.933447] device class 'vc': registering
[    2.934760] device: 'vcs': device_add
[    2.936184] device: 'vcsa': device_add
[    2.937526] device: 'vcs1': device_add
[    2.938980] device: 'vcsa1': device_add
[    2.957048] device: 'tty1': device_add
[    2.958597] device: 'tty2': device_add
[    2.959940] device: 'tty3': device_add
[    2.961334] device: 'tty4': device_add
[    2.962726] device: 'tty5': device_add
[    2.964062] device: 'tty6': device_add
[    2.965461] device: 'tty7': device_add
[    2.966789] device: 'tty8': device_add
[    2.984135] device: 'tty9': device_add
[    2.985503] device: 'tty10': device_add
[    2.986861] device: 'tty11': device_add
[    2.988335] device: 'tty12': device_add
[    2.989692] device: 'tty13': device_add
[    2.991155] device: 'tty14': device_add
[    2.992534] device: 'tty15': device_add
[    3.007587] device: 'tty16': device_add
[    3.009017] device: 'tty17': device_add
[    3.010408] device: 'tty18': device_add
[    3.011811] device: 'tty19': device_add
[    3.013216] device: 'tty20': device_add
[    3.025277] device: 'tty21': device_add
[    3.026673] device: 'tty22': device_add
[    3.028171] device: 'tty23': device_add
[    3.029515] device: 'tty24': device_add
[    3.030903] device: 'tty25': device_add
[    3.032304] device: 'tty26': device_add
[    3.033622] device: 'tty27': device_add
[    3.035041] device: 'tty28': device_add
[    3.053589] device: 'tty29': device_add
[    3.054968] device: 'tty30': device_add
[    3.056329] device: 'tty31': device_add
[    3.057701] device: 'tty32': device_add
[    3.059008] device: 'tty33': device_add
[    3.060362] device: 'tty34': device_add
[    3.061751] device: 'tty35': device_add
[    3.076285] device: 'tty36': device_add
[    3.077593] device: 'tty37': device_add
[    3.083720] device: 'tty38': device_add
[    3.105313] device: 'tty39': device_add
[    3.106702] device: 'tty40': device_add
[    3.108162] device: 'tty41': device_add
[    3.109528] device: 'tty42': device_add
[    3.110951] device: 'tty43': device_add
[    3.112341] device: 'tty44': device_add
[    3.113678] device: 'tty45': device_add
[    3.115037] device: 'tty46': device_add
[    3.129635] device: 'tty47': device_add
[    3.131006] device: 'tty48': device_add
[    3.132381] device: 'tty49': device_add
[    3.133748] device: 'tty50': device_add
[    3.150341] device: 'tty51': device_add
[    3.151774] device: 'tty52': device_add
[    3.153164] device: 'tty53': device_add
[    3.154539] device: 'tty54': device_add
[    3.155925] device: 'tty55': device_add
[    3.157327] device: 'tty56': device_add
[    3.158781] device: 'tty57': device_add
[    3.160193] device: 'tty58': device_add
[    3.161549] device: 'tty59': device_add
[    3.174246] device: 'tty60': device_add
[    3.175604] device: 'tty61': device_add
[    3.176968] device: 'tty62': device_add
[    3.178399] device: 'tty63': device_add
[    3.191031] device class 'firmware': registering
[    3.192514] device class 'thermal': registering
[    3.212495] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[    3.213980] pci_bus 0000:00: resource 5 [mem 0x00000000-0xffffffffff]
[    3.215961] NET: Registered protocol family 1
[    3.217362] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    3.219022] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    3.220695] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    3.238560] pci 0000:00:02.0: Boot video device
[    3.240269] PCI: CLS 0 bytes, default 64
[    3.242621] Unpacking initramfs...
[    8.250867] Freeing initrd memory: 23656k freed
[    8.804065] DMA-API: preallocated 32768 debug entries
[    8.805462] DMA-API: debugging enabled by kernel config
[    8.808397] Registering platform device 'pcspkr'. Parent at platform
[    8.810066] device: 'pcspkr': device_add
[    8.811166] bus: 'platform': add device pcspkr
[    8.812997] bus: 'clocksource': registered
[    8.814080] device: 'clocksource': device_add
[    8.825537] device: 'clocksource0': device_add
[    8.826810] bus: 'clocksource': add device clocksource0
[    8.828583] bus: 'platform': add driver alarmtimer
[    8.830029] Registering platform device 'alarmtimer'. Parent at platform
[    8.831607] device: 'alarmtimer': device_add
[    8.832774] bus: 'platform': add device alarmtimer
[    8.834051] bus: 'platform': driver_probe_device: matched device alarmti=
mer with driver alarmtimer
[    8.848573] bus: 'platform': really_probe: probing driver alarmtimer wit=
h device alarmtimer
[    8.850775] driver: 'alarmtimer': driver_bound: bound to device 'alarmti=
mer'
[    8.852459] bus: 'platform': really_probe: bound device alarmtimer to dr=
iver alarmtimer
[    8.854768] bus: 'rttest': registered
[    8.855819] device: 'rttest': device_add
[    8.896313] device: 'rttest0': device_add
[    8.897418] bus: 'rttest': add device rttest0
[    8.898926] device: 'rttest1': device_add
[    8.900024] bus: 'rttest': add device rttest1
[    8.901743] device: 'rttest2': device_add
[    8.902904] bus: 'rttest': add device rttest2
[    8.924319] device: 'rttest3': device_add
[    8.925505] bus: 'rttest': add device rttest3
[    8.927138] device: 'rttest4': device_add
[    8.928344] bus: 'rttest': add device rttest4
[    8.930133] device: 'rttest5': device_add
[    8.931255] bus: 'rttest': add device rttest5
[    8.978270] device: 'rttest6': device_add
[    8.979391] bus: 'rttest': add device rttest6
[    8.980959] device: 'rttest7': device_add
[    8.982236] bus: 'rttest': add device rttest7
[    8.983626] Initializing RT-Tester: OK
[    8.984818] audit: initializing netlink socket (disabled)
[    8.986448] type=3D2000 audit(1345761198.983:1): initialized
[    9.049363] Kprobe smoke test started
[    9.084881] Kprobe smoke test failed: register_jprobe returned -22
[    9.086786] Kprobe smoke test failed: register_jprobes returned -22
[    9.121281] BUG: Kprobe smoke test: 2 out of 6 tests failed
[    9.171132] Testing tracer function: PASSED
[    9.408938] Testing dynamic ftrace: PASSED
[    9.781718] Testing dynamic ftrace ops #1: (1 0 1 1 0) (1 1 2 1 0) (2 1 =
3 1 9) (2 2 4 1 341) PASSED
[   10.210541] Testing dynamic ftrace ops #2: [   10.314710] tsc: Refined T=
SC clocksource calibration: 3300.196 MHz
(1 0 1 3 0) (1 1 2 268 0) (2 1 3 1 3) (2 2 4 379 381) PASSED
[   10.655904] Testing ftrace recursion: PASSED
[   10.678444] Testing ftrace recursion safe: PASSED
[   10.698913] Testing ftrace regs: PASSED
[   10.797812] Testing tracer irqsoff: [   10.959633]=20
[   10.960459] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[   10.961689] [ INFO: suspicious RCU usage. ]
[   10.961689] 3.6.0-rc1-00241-gd57c5d5 #709 Not tainted
[   10.961689] -------------------------------
[   10.961689] /c/kernel-tests/src/tip/include/linux/rcupdate.h:725 rcu_rea=
d_lock() used illegally while idle!
[   10.961689]=20
[   10.961689] other info that might help us debug this:
[   10.961689]=20
[   10.961689]=20
[   10.961689] RCU used illegally from idle CPU!
[   10.961689] rcu_scheduler_active =3D 1, debug_locks =3D 1
[   10.961689] RCU used illegally from extended quiescent state!
[   10.961689] 2 locks held by swapper/1/0:

[   10.961689]  #0:  (max_trace_lock){......}, at: [<ffffffff81506eeb>] che=
ck_critical_timing+0xae/0x205
[   10.961689]  #1:  (rcu_read_lock){.+.+..}, at: [<ffffffff81156ab0>] __up=
date_max_tr+0x0/0x2f0
[   10.961689]=20
[   10.961689] stack backtrace:
[   10.961689] Pid: 0, comm: swapper/1 Not tainted 3.6.0-rc1-00241-gd57c5d5=
 #709
[   10.961689] Call Trace:
[   10.961689]  [<ffffffff810e907b>] lockdep_rcu_suspicious+0x16b/0x180
[   10.961689]  [<ffffffff81156bce>] __update_max_tr+0x11e/0x2f0
[   10.961689]  [<ffffffff81156ab0>] ? tracing_record_cmdline+0x190/0x190
[   10.961689]  [<ffffffff8115852e>] update_max_tr_single+0x1de/0x250
[   10.961689]  [<ffffffff81506fcd>] check_critical_timing+0x190/0x205
[   10.961689]  [<ffffffff81010fb1>] ? default_idle+0x361/0x900
[   10.961689]  [<ffffffff81010fb1>] ? default_idle+0x361/0x900
[   10.961689]  [<ffffffff81010fb1>] ? default_idle+0x361/0x900
[   10.961689]  [<ffffffff810ec2dd>] ? trace_hardirqs_on+0x1d/0x30
[   10.961689]  [<ffffffff811637e9>] time_hardirqs_on+0x109/0x1a0
[   10.961689]  [<ffffffff81010fb1>] ? default_idle+0x361/0x900
[   10.961689]  [<ffffffff810ebf56>] trace_hardirqs_on_caller+0x26/0x390
[   10.961689]  [<ffffffff810ec2dd>] trace_hardirqs_on+0x1d/0x30
[   10.961689]  [<ffffffff81010fb1>] default_idle+0x361/0x900
[   10.961689]  [<ffffffff81012844>] cpu_idle+0x1d4/0x300
[   10.961689]  [<ffffffff81c03609>] start_secondary+0x717/0x72d
[   10.961689]=20
[   10.961689] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[   10.961689] [ INFO: suspicious RCU usage. ]
[   10.961689] 3.6.0-rc1-00241-gd57c5d5 #709 Not tainted
[   10.961689] -------------------------------
[   10.961689] /c/kernel-tests/src/tip/kernel/trace/trace.c:675 suspicious =
rcu_dereference_check() usage!
[   10.961689]=20
[   10.961689] other info that might help us debug this:
[   10.961689]=20
[   10.961689]=20
[   10.961689] RCU used illegally from idle CPU!
[   10.961689] rcu_scheduler_active =3D 1, debug_locks =3D 1
[   10.961689] RCU used illegally from extended quiescent state!
[   10.961689] 2 locks held by swapper/1/0:
[   10.961689]  #0:  (max_trace_lock){......}, at: [<ffffffff81506eeb>] che=
ck_critical_timing+0xae/0x205
[   10.961689]  #1:  (rcu_read_lock){.+.+..}, at: [<ffffffff81156ab0>] __up=
date_max_tr+0x0/0x2f0
[   10.961689]=20
[   10.961689] stack backtrace:
[   10.961689] Pid: 0, comm: swapper/1 Not tainted 3.6.0-rc1-00241-gd57c5d5=
 #709
[   10.961689] Call Trace:
[   10.961689]  [<ffffffff810e907b>] lockdep_rcu_suspicious+0x16b/0x180
[   10.961689]  [<ffffffff81156c90>] __update_max_tr+0x1e0/0x2f0
[   10.961689]  [<ffffffff81156ab0>] ? tracing_record_cmdline+0x190/0x190
[   10.961689]  [<ffffffff8115852e>] update_max_tr_single+0x1de/0x250
[   10.961689]  [<ffffffff81506fcd>] check_critical_timing+0x190/0x205
[   10.961689]  [<ffffffff81010fb1>] ? default_idle+0x361/0x900
[   10.961689]  [<ffffffff81010fb1>] ? default_idle+0x361/0x900
[   10.961689]  [<ffffffff81010fb1>] ? default_idle+0x361/0x900
[   10.961689]  [<ffffffff810ec2dd>] ? trace_hardirqs_on+0x1d/0x30
[   10.961689]  [<ffffffff811637e9>] time_hardirqs_on+0x109/0x1a0
[   10.961689]  [<ffffffff81010fb1>] ? default_idle+0x361/0x900
[   10.961689]  [<ffffffff810ebf56>] trace_hardirqs_on_caller+0x26/0x390
[   10.961689]  [<ffffffff810ec2dd>] trace_hardirqs_on+0x1d/0x30
[   10.961689]  [<ffffffff81010fb1>] default_idle+0x361/0x900
[   10.961689]  [<ffffffff81012844>] cpu_idle+0x1d4/0x300
[   10.961689]  [<ffffffff81c03609>] start_secondary+0x717/0x72d
[   10.961689]=20
[   10.961689] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[   10.961689] [ INFO: suspicious RCU usage. ]
[   10.961689] 3.6.0-rc1-00241-gd57c5d5 #709 Not tainted
[   10.961689] -------------------------------
[   10.961689] /c/kernel-tests/src/tip/include/linux/rcupdate.h:746 rcu_rea=
d_unlock() used illegally while idle!
[   10.961689]=20
[   10.961689] other info that might help us debug this:
[   10.961689]=20
[   10.961689]=20
[   10.961689] RCU used illegally from idle CPU!
[   10.961689] rcu_scheduler_active =3D 1, debug_locks =3D 1
[   10.961689] RCU used illegally from extended quiescent state!
[   10.961689] 2 locks held by swapper/1/0:
[   10.961689]  #0:  (max_trace_lock){......}, at: [<ffffffff81506eeb>] che=
ck_critical_timing+0xae/0x205
[   10.961689]  #1:  (rcu_read_lock){.+.+..}, at: [<ffffffff81156ab0>] __up=
date_max_tr+0x0/0x2f0
[   10.961689]=20
[   10.961689] stack backtrace:
[   10.961689] Pid: 0, comm: swapper/1 Not tainted 3.6.0-rc1-00241-gd57c5d5=
 #709
[   10.961689] Call Trace:
[   10.961689]  [<ffffffff810e907b>] lockdep_rcu_suspicious+0x16b/0x180
[   10.961689]  [<ffffffff81156d06>] __update_max_tr+0x256/0x2f0
[   10.961689]  [<ffffffff81156ab0>] ? tracing_record_cmdline+0x190/0x190
[   10.961689]  [<ffffffff8115852e>] update_max_tr_single+0x1de/0x250
[   10.961689]  [<ffffffff81506fcd>] check_critical_timing+0x190/0x205
[   10.961689]  [<ffffffff81010fb1>] ? default_idle+0x361/0x900
[   10.961689]  [<ffffffff81010fb1>] ? default_idle+0x361/0x900
[   10.961689]  [<ffffffff81010fb1>] ? default_idle+0x361/0x900
[   10.961689]  [<ffffffff810ec2dd>] ? trace_hardirqs_on+0x1d/0x30
[   10.961689]  [<ffffffff811637e9>] time_hardirqs_on+0x109/0x1a0
[   10.961689]  [<ffffffff81010fb1>] ? default_idle+0x361/0x900
[   10.961689]  [<ffffffff810ebf56>] trace_hardirqs_on_caller+0x26/0x390
[   10.961689]  [<ffffffff810ec2dd>] trace_hardirqs_on+0x1d/0x30
[   10.961689]  [<ffffffff81010fb1>] default_idle+0x361/0x900
[   10.961689]  [<ffffffff81012844>] cpu_idle+0x1d4/0x300
[   10.961689]  [<ffffffff81c03609>] start_secondary+0x717/0x72d
[   11.861159] PASSED
[   11.891155] Testing tracer wakeup: PASSED
[   12.298405] Testing tracer wakeup_rt: PASSED
[   12.778406] Testing tracer function_graph: PASSED
[   13.191749] Testing tracer branch: PASSED
[   13.369297] bus: 'event_source': registered
[   13.370505] device: 'breakpoint': device_add
[   13.371813] bus: 'event_source': add device breakpoint
[   13.373406] device: 'tracepoint': device_add
[   13.374659] bus: 'event_source': add device tracepoint
[   13.376264] device: 'software': device_add
[   13.377552] bus: 'event_source': add device software
[   13.379925] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[   13.721535] msgmni has been set to 427
[   13.735281] device class 'bsg': registering
[   13.736608] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 254)
[   13.738682] io scheduler noop registered (default)
[   13.739956] start plist test
[   13.761036] end plist test
[   13.761933] list_sort_test: start testing list_sort()
[   13.778011] bus: 'acpi': add driver ac
[   13.794862] bus: 'acpi': add driver button
[   13.796159] bus: 'acpi': driver_probe_device: matched device LNXPWRBN:00=
 with driver button
[   13.800359] bus: 'acpi': really_probe: probing driver button with device=
 LNXPWRBN:00
[   13.802550] device: 'input0': device_add
[   13.804346] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[   13.806448] ACPI: Power Button [PWRF]
[   13.807521] driver: 'LNXPWRBN:00': driver_bound: bound to device 'button'
[   13.824819] bus: 'acpi': really_probe: bound device LNXPWRBN:00 to drive=
r button
[   13.826990] bus: 'acpi': add driver fan
[   13.828331] bus: 'acpi': add driver processor
[   13.829643] bus: 'acpi': driver_probe_device: matched device LNXCPU:00 w=
ith driver processor
[   13.843926] bus: 'acpi': really_probe: probing driver processor with dev=
ice LNXCPU:00
[   13.849784] device: 'cooling_device0': device_add
[   13.851497] driver: 'LNXCPU:00': driver_bound: bound to device 'processo=
r'
[   13.853249] bus: 'acpi': really_probe: bound device LNXCPU:00 to driver =
processor
[   13.875341] bus: 'acpi': driver_probe_device: matched device LNXCPU:01 w=
ith driver processor
[   13.877440] bus: 'acpi': really_probe: probing driver processor with dev=
ice LNXCPU:01
[   13.894812] device: 'cooling_device1': device_add
[   13.896404] driver: 'LNXCPU:01': driver_bound: bound to device 'processo=
r'
[   13.898145] bus: 'acpi': really_probe: bound device LNXCPU:01 to driver =
processor
[   13.900292] bus: 'acpi': add driver thermal
[   13.923254] device: 'ptmx': device_add
[   13.924679] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[   13.926439] Registering platform device 'serial8250'. Parent at platform
[   13.928307] device: 'serial8250': device_add
[   13.929639] bus: 'platform': add device serial8250
[   13.932512] bus: 'acpi': add driver battery
[   14.011068] serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[   14.011176] device: 'ttyS0': device_add
[   14.011767] device: 'ttyS1': device_add
[   14.012169] device: 'ttyS2': device_add
[   14.012499] device: 'ttyS3': device_add
[   14.012714] bus: 'platform': add driver serial8250
[   14.012769] bus: 'platform': driver_probe_device: matched device serial8=
250 with driver serial8250
[   14.012771] bus: 'platform': really_probe: probing driver serial8250 wit=
h device serial8250
[   14.012822] driver: 'serial8250': driver_bound: bound to device 'serial8=
250'
[   14.012829] bus: 'platform': really_probe: bound device serial8250 to dr=
iver serial8250
[   14.012916] bus: 'pnp': add driver serial
[   14.013021] bus: 'pnp': driver_probe_device: matched device 00:06 with d=
river serial
[   14.013023] bus: 'pnp': really_probe: probing driver serial with device =
00:06
[   14.013287] device: 'ttyS0': device_unregister
[   14.013802] device: 'ttyS0': device_create_release
[   14.110519] 00:06: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[   14.110596] device: 'ttyS0': device_add
[   14.111044] driver: '00:06': driver_bound: bound to device 'serial'
[   14.111051] bus: 'pnp': really_probe: bound device 00:06 to driver serial
[   14.111198] bus: 'pci': add driver serial
[   14.111781] bus: 'pnp': add driver i8042 kbd
[   14.111845] bus: 'pnp': driver_probe_device: matched device 00:02 with d=
river i8042 kbd
[   14.111848] bus: 'pnp': really_probe: probing driver i8042 kbd with devi=
ce 00:02
[   14.111911] driver: '00:02': driver_bound: bound to device 'i8042 kbd'
[   14.111917] bus: 'pnp': really_probe: bound device 00:02 to driver i8042=
 kbd
[   14.112043] bus: 'pnp': add driver i8042 aux
[   14.112141] bus: 'pnp': driver_probe_device: matched device 00:03 with d=
river i8042 aux
[   14.112143] bus: 'pnp': really_probe: probing driver i8042 aux with devi=
ce 00:03
[   14.112202] driver: '00:03': driver_bound: bound to device 'i8042 aux'
[   14.112207] bus: 'pnp': really_probe: bound device 00:03 to driver i8042=
 aux
[   14.112300] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[   14.112369] Registering platform device 'i8042'. Parent at platform
[   14.112380] device: 'i8042': device_add
[   14.112437] bus: 'platform': add device i8042
[   14.112556] bus: 'platform': add driver i8042
[   14.112613] bus: 'platform': driver_probe_device: matched device i8042 w=
ith driver i8042
[   14.112615] bus: 'platform': really_probe: probing driver i8042 with dev=
ice i8042
[   14.390294] serio: i8042 KBD port at 0x60,0x64 irq 1
[   14.391707] serio: i8042 AUX port at 0x60,0x64 irq 12
[   14.393272] device: 'serio0': device_add
[   14.394598] bus: 'serio': add device serio0
[   14.409254] driver: 'i8042': driver_bound: bound to device 'i8042'
[   14.410837] device: 'serio1': device_add
[   14.412177] bus: 'serio': add device serio1
[   14.413584] bus: 'platform': really_probe: bound device i8042 to driver =
i8042
[   14.415632] device: 'mice': device_add
[   14.417381] mousedev: PS/2 mouse device common for all mice
[   14.418874] bus: 'serio': add driver atkbd
[   14.420245] bus: 'serio': driver_probe_device: matched device serio0 wit=
h driver atkbd
[   14.440053] bus: 'serio': really_probe: probing driver atkbd with device=
 serio0
[   14.442225] cpuidle: using governor ladder
[   14.443404] device class 'extcon': registering
[   14.450995] bus: 'machinecheck': registered
[   14.452432] device: 'machinecheck': device_add
[   14.457367] device: 'machinecheck0': device_add
[   14.458713] bus: 'machinecheck': add device machinecheck0
[   14.460495] device: 'machinecheck1': device_add
[   14.461858] bus: 'machinecheck': add device machinecheck1
[   14.463633] device: 'mcelog': device_add
[   14.516067] device: 'input1': device_add
[   14.518088] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[   14.520597] driver: 'serio0': driver_bound: bound to device 'atkbd'
[   14.538589]=20
[   14.538589] printing PIC contents
[   14.538599] ... PIC  IMR: ffff
[   14.538605] ... PIC  IRR: 1013
[   14.538615] ... PIC  ISR: 0000
[   14.538621] ... PIC ELCR: 0c00
[   14.538632] printing local APIC contents on CPU#0/0:
[   14.538639] ... APIC ID:      00000000 (0)
[   14.538643] ... APIC VERSION: 00050014
[   14.538650] ... APIC TASKPRI: 00000000 (00)
[   14.538654] ... APIC PROCPRI: 00000000
[   14.538658] ... APIC LDR: 01000000
[   14.538662] ... APIC DFR: ffffffff
[   14.538666] ... APIC SPIV: 000001ff
[   14.538667] ... APIC ISR field:
[   14.538696] 000000000000000000000000000000000000000000000000000000000000=
0000
[   14.538697] ... APIC TMR field:
[   14.538723] 000000000000000000000000000000000000000000000000000000000000=
0000
[   14.538724] ... APIC IRR field:
[   14.538753] 000000000000000000000000000000000000000000000000000000000000=
0000
[   14.538759] ... APIC ESR: 00000000
[   14.538765] ... APIC ICR: 000008fd
[   14.538766] ... APIC ICR2: 02000000
[   14.538769] ... APIC LVTT: 000200ef
[   14.538772] ... APIC LVTPC: 00010000
[   14.538776] ... APIC LVT0: 00010700
[   14.538780] ... APIC LVT1: 00000400
[   14.538784] ... APIC LVTERR: 000000fe
[   14.538788] ... APIC TMICT: 00032dd0
[   14.538792] ... APIC TMCCT: 000235dd
[   14.538795] ... APIC TDCR: 00000003
[   14.538796]=20
[   14.538797] number of MP IRQ sources: 15.
[   14.538798] number of IO-APIC #2 registers: 24.
[   14.538799] testing the IO APIC.......................
[   14.538814] IO APIC #2......
[   14.538815] .... register #00: 00000000
[   14.538816] .......    : physical APIC id: 00
[   14.538817] .......    : Delivery Type: 0
[   14.538818] .......    : LTS          : 0
[   14.538819] .... register #01: 00170011
[   14.538820] .......     : max redirection entries: 17
[   14.538821] .......     : PRQ implemented: 0
[   14.538822] .......     : IO APIC version: 11
[   14.538823] .... register #02: 00000000
[   14.538824] .......     : arbitration: 00
[   14.538825] .... IRQ redirection table:
[   14.538825]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
[   14.538838]  00 00  1    0    0   0   0    0    0    00
[   14.538850]  01 03  0    0    0   0   0    1    1    41
[   14.538862]  02 03  0    0    0   0   0    1    1    51
[   14.538873]  03 01  0    0    0   0   0    1    1    61
[   14.538885]  04 01  1    0    0   0   0    1    1    71
[   14.538899]  05 01  1    1    0   0   0    1    1    81
[   14.538915]  06 01  0    0    0   0   0    1    1    91
[   14.538931]  07 01  0    0    0   0   0    1    1    A1
[   14.538947]  08 01  0    0    0   0   0    1    1    B1
[   14.538967]  09 01  0    1    0   0   0    1    1    C1
[   14.538982]  0a 01  1    1    0   0   0    1    1    D1
[   14.538998]  0b 01  1    1    0   0   0    1    1    E1
[   14.539016]  0c 03  0    0    0   0   0    1    1    22
[   14.539033]  0d 01  0    0    0   0   0    1    1    42
[   14.539048]  0e 01  0    0    0   0   0    1    1    52
[   14.539064]  0f 01  0    0    0   0   0    1    1    62
[   14.539080]  10 00  1    0    0   0   0    0    0    00
[   14.539126]  11 00  1    0    0   0   0    0    0    00
[   14.539142]  12 00  1    0    0   0   0    0    0    00
[   14.539156]  13 00  1    0    0   0   0    0    0    00
[   14.539172]  14 00  1    0    0   0   0    0    0    00
[   14.539188]  15 00  1    0    0   0   0    0    0    00
[   14.539204]  16 00  1    0    0   0   0    0    0    00
[   14.539221]  17 00  1    0    0   0   0    0    0    00
[   14.539222] IRQ to pin mappings:
[   14.539226] IRQ0 -> 0:2
[   14.539229] IRQ1 -> 0:1
[   14.539233] IRQ3 -> 0:3
[   14.539236] IRQ4 -> 0:4
[   14.539239] IRQ5 -> 0:5
[   14.539243] IRQ6 -> 0:6
[   14.539246] IRQ7 -> 0:7
[   14.539249] IRQ8 -> 0:8
[   14.539252] IRQ9 -> 0:9
[   14.539256] IRQ10 -> 0:10
[   14.539259] IRQ11 -> 0:11
[   14.539262] IRQ12 -> 0:12
[   14.539265] IRQ13 -> 0:13
[   14.539273] IRQ14 -> 0:14
[   14.539279] IRQ15 -> 0:15
[   14.539280] .................................... done.
[   14.539426] device: 'cpu_dma_latency': device_add
[   14.539661] device: 'network_latency': device_add
[   14.539893] device: 'network_throughput': device_add
[   14.540303] registered taskstats version 1
[   14.540305] Running tests on trace events:
[   14.795455] bus: 'serio': really_probe: bound device serio0 to driver at=
kbd
[   14.797286] bus: 'serio': driver_probe_device: matched device serio1 wit=
h driver atkbd
[   14.799543] bus: 'serio': really_probe: probing driver atkbd with device=
 serio1
[   14.802124] atkbd: probe of serio1 rejects match -19
[   14.844364] Testing event kfree_skb: OK
[   14.845546] Testing event consume_skb: OK
[   14.858631] Testing event skb_copy_datagram_iovec: OK
[   14.894873] Testing event net_dev_xmit: OK
[   14.915247] Testing event net_dev_queue: OK
[   14.934900] Testing event netif_receive_skb: OK
[   14.948606] Testing event netif_rx: OK
[   14.961848] Testing event napi_poll: OK
[   14.975254] Testing event sock_rcvqueue_full: OK
[   14.994832] Testing event sock_exceed_buf_limit: OK
[   15.008519] Testing event udp_fail_queue_rcv_skb: OK
[   15.021896] Testing event regmap_reg_write: OK
[   15.041796] Testing event regmap_reg_read: OK
[   15.055226] Testing event regmap_reg_read_cache: OK
[   15.068526] Testing event regmap_hw_read_start: OK
[   15.081925] Testing event regmap_hw_read_done: OK
[   15.131015] Testing event regmap_hw_write_start: OK
[   15.181882] Testing event regmap_hw_write_done: OK
[   15.195194] Testing event regcache_sync: OK
[   15.208510] Testing event regmap_cache_only: OK
[   15.221921] Testing event regmap_cache_bypass: OK
[   15.235227] Testing event mix_pool_bytes: OK
[   15.273811] Testing event mix_pool_bytes_nolock: OK
[   15.288561] Testing event credit_entropy_bits: OK
[   15.308886] Testing event get_random_bytes: OK
[   15.321924] Testing event extract_entropy: OK
[   15.338591] Testing event extract_entropy_user: OK
[   15.351812] Testing event regulator_enable: OK
[   15.365206] Testing event regulator_enable_delay: OK
[   15.378472] Testing event regulator_enable_complete: OK
[   15.391852] Testing event regulator_disable: OK
[   15.405068] Testing event regulator_disable_complete: OK
[   15.418498] Testing event regulator_set_voltage: OK
[   15.431799] Testing event regulator_set_voltage_complete: OK
[   15.445217] Testing event block_rq_abort: OK
[   15.458473] Testing event block_rq_requeue: OK
[   15.471847] Testing event block_rq_complete: OK
[   15.485138] Testing event block_rq_insert: OK
[   15.498519] Testing event block_rq_issue: OK
[   15.511766] Testing event block_bio_bounce: OK
[   15.525168] Testing event block_bio_complete: OK
[   15.538487] Testing event block_bio_backmerge: OK
[   15.555132] Testing event block_bio_frontmerge: OK
[   15.568548] Testing event block_bio_queue: OK
[   15.581804] Testing event block_getrq: OK
[   15.595209] Testing event block_sleeprq: OK
[   15.608481] Testing event block_plug: OK
[   15.621877] Testing event block_unplug: OK
[   15.635144] Testing event block_split: OK
[   15.648541] Testing event block_bio_remap: OK
[   15.661748] Testing event block_rq_remap: OK
[   15.675202] Testing event writeback_nothread: OK
[   15.688489] Testing event writeback_queue: OK
[   15.701856] Testing event writeback_exec: OK
[   15.715134] Testing event writeback_start: OK
[   15.728498] Testing event writeback_written: OK
[   15.741897] Testing event writeback_wait: OK
[   15.755275] Testing event writeback_pages_written: OK
[   15.773799] Testing event writeback_nowork: OK
[   15.788557] Testing event writeback_wake_background: OK
[   15.801842] Testing event writeback_wake_thread: OK
[   15.818797] Testing event writeback_wake_forker_thread: OK
[   15.831831] Testing event writeback_bdi_register: OK
[   15.845176] Testing event writeback_bdi_unregister: OK
[   15.858532] Testing event writeback_thread_start: OK
[   15.871821] Testing event writeback_thread_stop: OK
[   15.885265] Testing event wbc_writepage: OK
[   15.898558] Testing event writeback_queue_io: OK
[   15.911915] Testing event global_dirty_state: OK
[   15.925184] Testing event bdi_dirty_ratelimit: OK
[   15.938620] Testing event balance_dirty_pages: OK
[   15.951791] Testing event writeback_sb_inodes_requeue: OK
[   15.965281] Testing event writeback_congestion_wait: OK
[   15.978565] Testing event writeback_wait_iff_congested: OK
[   15.991797] Testing event writeback_single_inode: OK
[   16.005256] Testing event mm_compaction_isolate_migratepages: OK
[   16.021927] Testing event mm_compaction_isolate_freepages: OK
[   16.035174] Testing event mm_compaction_migratepages: OK
[   16.048638] Testing event kmalloc: OK
[   16.061808] Testing event kmem_cache_alloc: OK
[   16.075243] Testing event kmalloc_node: OK
[   16.088468] Testing event kmem_cache_alloc_node: OK
[   16.101838] Testing event kfree: OK
[   16.115143] Testing event kmem_cache_free: OK
[   16.128554] Testing event mm_page_free: OK
[   16.141766] Testing event mm_page_free_batched: OK
[   16.155749] Testing event mm_page_alloc: OK
[   16.168463] Testing event mm_page_alloc_zone_locked: OK
[   16.181841] Testing event mm_page_pcpu_drain: OK
[   16.195259] Testing event mm_page_alloc_extfrag: OK
[   16.208571] Testing event mm_vmscan_kswapd_sleep: OK
[   16.221800] Testing event mm_vmscan_kswapd_wake: OK
[   16.235226] Testing event mm_vmscan_wakeup_kswapd: OK
[   16.248550] Testing event mm_vmscan_direct_reclaim_begin: OK
[   16.266393] Testing event mm_vmscan_memcg_reclaim_begin: OK
[   16.281879] Testing event mm_vmscan_memcg_softlimit_reclaim_begin: OK
[   16.295176] Testing event mm_vmscan_direct_reclaim_end: OK
[   16.308666] Testing event mm_vmscan_memcg_reclaim_end: OK
[   16.321865] Testing event mm_vmscan_memcg_softlimit_reclaim_end: OK
[   16.360862] Testing event mm_shrink_slab_start: OK
[   16.382520] Testing event mm_shrink_slab_end: OK
[   16.405217] Testing event mm_vmscan_lru_isolate: OK
[   16.418593] Testing event mm_vmscan_memcg_isolate: OK
[   16.439836] Testing event mm_vmscan_writepage: OK
[   16.455253] Testing event mm_vmscan_lru_shrink_inactive: OK
[   16.468607] Testing event oom_score_adj_update: OK
[   16.514829] Testing event cpu_idle: OK
[   16.528598] Testing event cpu_frequency: OK
[   16.541866] Testing event machine_suspend:=20
--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.6.0-rc1-00241-gd57c5d5"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.6.0-rc1 Kernel Configuration
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
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y
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
CONFIG_KERNEL_BZIP2=y
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
# CONFIG_BSD_PROCESS_ACCT is not set
CONFIG_FHANDLE=y
CONFIG_TASKSTATS=y
# CONFIG_TASK_DELAY_ACCT is not set
# CONFIG_TASK_XACCT is not set
CONFIG_AUDIT=y
# CONFIG_AUDITSYSCALL is not set
CONFIG_AUDIT_LOGINUID_IMMUTABLE=y
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
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
CONFIG_RCU_FANOUT_EXACT=y
CONFIG_TREE_RCU_TRACE=y
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
# CONFIG_CGROUPS is not set
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
# CONFIG_PID_NS is not set
# CONFIG_NET_NS is not set
# CONFIG_SCHED_AUTOGROUP is not set
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
# CONFIG_EXPERT is not set
CONFIG_UID16=y
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
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
CONFIG_HAVE_PERF_REGS=y
CONFIG_HAVE_PERF_USER_STACK_DUMP=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y

#
# GCOV-based kernel profiling
#
CONFIG_GCOV_KERNEL=y
CONFIG_GCOV_PROFILE_ALL=y
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
# CONFIG_MODVERSIONS is not set
CONFIG_MODULE_SRCVERSION_ALL=y
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_BLOCK_COMPAT=y

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
# CONFIG_FREEZER is not set

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
CONFIG_SCHED_OMIT_FRAME_POINTER=y
CONFIG_PARAVIRT_GUEST=y
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
# CONFIG_XEN is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_CLOCK=y
CONFIG_KVM_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_SPINLOCKS is not set
CONFIG_PARAVIRT_CLOCK=y
# CONFIG_PARAVIRT_DEBUG is not set
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
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
# CONFIG_CALGARY_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
# CONFIG_MAXSMP is not set
CONFIG_NR_CPUS=8
# CONFIG_SCHED_SMT is not set
CONFIG_SCHED_MC=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
# CONFIG_X86_MCE_INTEL is not set
# CONFIG_X86_MCE_AMD is not set
# CONFIG_X86_MCE_INJECT is not set
CONFIG_I8K=m
# CONFIG_MICROCODE is not set
# CONFIG_X86_MSR is not set
CONFIG_X86_CPUID=m
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
CONFIG_NUMA=y
CONFIG_AMD_NUMA=y
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_NODES_SPAN_OTHER_NODES=y
# CONFIG_NUMA_EMU is not set
CONFIG_NODES_SHIFT=6
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_MEMORY_PROBE=y
CONFIG_ARCH_PROC_KCORE_TEXT=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_NEED_MULTIPLE_NODES=y
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
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
CONFIG_HWPOISON_INJECT=m
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_CLEANCACHE=y
# CONFIG_FRONTSWAP is not set
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=y
# CONFIG_HZ_1000 is not set
CONFIG_HZ=300
# CONFIG_SCHED_HRTICK is not set
# CONFIG_KEXEC is not set
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x1000000
# CONFIG_HOTPLUG_CPU is not set
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y
CONFIG_USE_PERCPU_NUMA_NODE_ID=y

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
# CONFIG_HIBERNATION is not set
# CONFIG_PM_RUNTIME is not set
CONFIG_ACPI=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_PROCFS_POWER is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_IPMI is not set
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_NUMA=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
# CONFIG_ACPI_HOTPLUG_MEMORY is not set
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_BGRT is not set
# CONFIG_ACPI_APEI is not set
CONFIG_SFI=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_STAT=m
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=m
# CONFIG_CPU_FREQ_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=m

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
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
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
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_RAPIDIO is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=m
CONFIG_IA32_EMULATION=y
# CONFIG_IA32_AOUT is not set
# CONFIG_X86_X32 is not set
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_KEYS_COMPAT=y
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
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
CONFIG_LLC=m
CONFIG_LLC2=m
CONFIG_IPX=m
CONFIG_IPX_INTERN=y
CONFIG_ATALK=m
CONFIG_DEV_APPLETALK=m
CONFIG_IPDDP=m
# CONFIG_IPDDP_ENCAP is not set
# CONFIG_IPDDP_DECAP is not set
CONFIG_X25=m
# CONFIG_LAPB is not set
CONFIG_WAN_ROUTER=m
CONFIG_PHONET=m
# CONFIG_IEEE802154 is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=m
CONFIG_NET_SCH_HTB=m
# CONFIG_NET_SCH_HFSC is not set
# CONFIG_NET_SCH_PRIO is not set
CONFIG_NET_SCH_MULTIQ=m
# CONFIG_NET_SCH_RED is not set
# CONFIG_NET_SCH_SFB is not set
# CONFIG_NET_SCH_SFQ is not set
CONFIG_NET_SCH_TEQL=m
# CONFIG_NET_SCH_TBF is not set
# CONFIG_NET_SCH_GRED is not set
# CONFIG_NET_SCH_DSMARK is not set
# CONFIG_NET_SCH_NETEM is not set
CONFIG_NET_SCH_DRR=m
CONFIG_NET_SCH_MQPRIO=m
# CONFIG_NET_SCH_CHOKE is not set
CONFIG_NET_SCH_QFQ=m
# CONFIG_NET_SCH_CODEL is not set
CONFIG_NET_SCH_FQ_CODEL=m
# CONFIG_NET_SCH_INGRESS is not set
# CONFIG_NET_SCH_PLUG is not set

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=m
CONFIG_NET_CLS_TCINDEX=m
# CONFIG_NET_CLS_FW is not set
# CONFIG_NET_CLS_U32 is not set
CONFIG_NET_CLS_RSVP=m
CONFIG_NET_CLS_RSVP6=m
CONFIG_NET_CLS_FLOW=m
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=m
CONFIG_NET_EMATCH_NBYTE=m
# CONFIG_NET_EMATCH_U32 is not set
# CONFIG_NET_EMATCH_META is not set
# CONFIG_NET_EMATCH_TEXT is not set
# CONFIG_NET_EMATCH_CANID is not set
CONFIG_NET_CLS_ACT=y
# CONFIG_NET_ACT_POLICE is not set
CONFIG_NET_ACT_GACT=m
CONFIG_GACT_PROB=y
CONFIG_NET_ACT_MIRRED=m
# CONFIG_NET_ACT_NAT is not set
CONFIG_NET_ACT_PEDIT=m
# CONFIG_NET_ACT_SIMP is not set
# CONFIG_NET_ACT_SKBEDIT is not set
CONFIG_NET_SCH_FIFO=y
# CONFIG_DCB is not set
# CONFIG_DNS_RESOLVER is not set
# CONFIG_BATMAN_ADV is not set
CONFIG_OPENVSWITCH=m
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
CONFIG_BQL=y
# CONFIG_BPF_JIT is not set

#
# Network testing
#
CONFIG_NET_PKTGEN=m
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
CONFIG_AX25=m
# CONFIG_AX25_DAMA_SLAVE is not set
# CONFIG_NETROM is not set
CONFIG_ROSE=m

#
# AX.25 network device drivers
#
CONFIG_MKISS=m
# CONFIG_6PACK is not set
# CONFIG_BPQETHER is not set
# CONFIG_BAYCOM_SER_FDX is not set
CONFIG_BAYCOM_SER_HDX=m
CONFIG_YAM=m
CONFIG_CAN=m
# CONFIG_CAN_RAW is not set
# CONFIG_CAN_BCM is not set
# CONFIG_CAN_GW is not set

#
# CAN Device Drivers
#
# CONFIG_CAN_VCAN is not set
CONFIG_CAN_SLCAN=m
CONFIG_CAN_DEV=m
CONFIG_CAN_CALC_BITTIMING=y
CONFIG_CAN_MCP251X=m
# CONFIG_PCH_CAN is not set
CONFIG_CAN_SJA1000=m
CONFIG_CAN_SJA1000_ISA=m
# CONFIG_CAN_SJA1000_PLATFORM is not set
# CONFIG_CAN_EMS_PCI is not set
# CONFIG_CAN_PEAK_PCI is not set
# CONFIG_CAN_KVASER_PCI is not set
# CONFIG_CAN_PLX_PCI is not set
CONFIG_CAN_C_CAN=m
# CONFIG_CAN_C_CAN_PLATFORM is not set
# CONFIG_CAN_C_CAN_PCI is not set
CONFIG_CAN_CC770=m
# CONFIG_CAN_CC770_ISA is not set
# CONFIG_CAN_CC770_PLATFORM is not set
CONFIG_CAN_SOFTING=m
CONFIG_CAN_DEBUG_DEVICES=y
CONFIG_IRDA=m

#
# IrDA protocols
#
# CONFIG_IRLAN is not set
# CONFIG_IRCOMM is not set
# CONFIG_IRDA_ULTRA is not set

#
# IrDA options
#
CONFIG_IRDA_CACHE_LAST_LSAP=y
# CONFIG_IRDA_FAST_RR is not set
CONFIG_IRDA_DEBUG=y

#
# Infrared-port device drivers
#

#
# SIR device drivers
#
CONFIG_IRTTY_SIR=m

#
# Dongle support
#
CONFIG_DONGLE=y
CONFIG_ESI_DONGLE=m
# CONFIG_ACTISYS_DONGLE is not set
CONFIG_TEKRAM_DONGLE=m
CONFIG_TOIM3232_DONGLE=m
# CONFIG_LITELINK_DONGLE is not set
# CONFIG_MA600_DONGLE is not set
CONFIG_GIRBIL_DONGLE=m
# CONFIG_MCP2120_DONGLE is not set
CONFIG_OLD_BELKIN_DONGLE=m
CONFIG_ACT200L_DONGLE=m

#
# FIR device drivers
#
CONFIG_NSC_FIR=m
# CONFIG_WINBOND_FIR is not set
# CONFIG_SMC_IRCC_FIR is not set
CONFIG_ALI_FIR=m
# CONFIG_VLSI_FIR is not set
# CONFIG_VIA_FIR is not set
CONFIG_BT=m
CONFIG_BT_RFCOMM=m
CONFIG_BT_RFCOMM_TTY=y
CONFIG_BT_BNEP=m
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
# CONFIG_BT_HIDP is not set

#
# Bluetooth device drivers
#
CONFIG_BT_HCIUART=m
# CONFIG_BT_HCIUART_H4 is not set
CONFIG_BT_HCIUART_BCSP=y
# CONFIG_BT_HCIUART_ATH3K is not set
CONFIG_BT_HCIUART_LL=y
# CONFIG_BT_HCIUART_3WIRE is not set
# CONFIG_BT_HCIVHCI is not set
CONFIG_BT_MRVL=m
CONFIG_WIRELESS=y
# CONFIG_CFG80211 is not set
# CONFIG_LIB80211 is not set

#
# CFG80211 needs to be enabled for MAC80211
#
CONFIG_WIMAX=m
CONFIG_WIMAX_DEBUG_LEVEL=8
# CONFIG_RFKILL is not set
CONFIG_RFKILL_REGULATOR=m
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
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
CONFIG_DEBUG_DRIVER=y
CONFIG_DEBUG_DEVRES=y
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_SPI=y
CONFIG_REGMAP_IRQ=y
# CONFIG_DMA_SHARED_BUFFER is not set
CONFIG_CONNECTOR=m
CONFIG_MTD=m
CONFIG_MTD_TESTS=m
CONFIG_MTD_REDBOOT_PARTS=m
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
# CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED is not set
CONFIG_MTD_REDBOOT_PARTS_READONLY=y
CONFIG_MTD_AR7_PARTS=m

#
# User Modules And Translation Layers
#
# CONFIG_MTD_CHAR is not set
CONFIG_HAVE_MTD_OTP=y
CONFIG_MTD_BLKDEVS=m
# CONFIG_MTD_BLOCK is not set
CONFIG_MTD_BLOCK_RO=m
CONFIG_FTL=m
# CONFIG_NFTL is not set
# CONFIG_INFTL is not set
CONFIG_RFD_FTL=m
# CONFIG_SSFDC is not set
# CONFIG_SM_FTL is not set
# CONFIG_MTD_OOPS is not set
CONFIG_MTD_SWAP=m

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=m
# CONFIG_MTD_JEDECPROBE is not set
CONFIG_MTD_GEN_PROBE=m
CONFIG_MTD_CFI_ADV_OPTIONS=y
# CONFIG_MTD_CFI_NOSWAP is not set
# CONFIG_MTD_CFI_BE_BYTE_SWAP is not set
CONFIG_MTD_CFI_LE_BYTE_SWAP=y
# CONFIG_MTD_CFI_GEOMETRY is not set
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
CONFIG_MTD_OTP=y
# CONFIG_MTD_CFI_INTELEXT is not set
# CONFIG_MTD_CFI_AMDSTD is not set
CONFIG_MTD_CFI_STAA=m
CONFIG_MTD_CFI_UTIL=m
CONFIG_MTD_RAM=m
CONFIG_MTD_ROM=m
# CONFIG_MTD_ABSENT is not set

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
CONFIG_MTD_PHYSMAP=m
# CONFIG_MTD_PHYSMAP_COMPAT is not set
# CONFIG_MTD_SC520CDP is not set
CONFIG_MTD_NETSC520=m
# CONFIG_MTD_TS5500 is not set
# CONFIG_MTD_INTEL_VR_NOR is not set
# CONFIG_MTD_PLATRAM is not set

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
# CONFIG_MTD_DATAFLASH is not set
CONFIG_MTD_M25P80=m
# CONFIG_M25PXX_USE_FAST_READ is not set
CONFIG_MTD_SST25L=m
# CONFIG_MTD_SLRAM is not set
CONFIG_MTD_PHRAM=m
# CONFIG_MTD_MTDRAM is not set
# CONFIG_MTD_BLOCK2MTD is not set

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOC2000=m
# CONFIG_MTD_DOC2001 is not set
# CONFIG_MTD_DOC2001PLUS is not set
CONFIG_MTD_DOCG3=m
CONFIG_BCH_CONST_M=14
CONFIG_BCH_CONST_T=4
CONFIG_MTD_DOCPROBE=m
CONFIG_MTD_DOCECC=m
# CONFIG_MTD_DOCPROBE_ADVANCED is not set
CONFIG_MTD_DOCPROBE_ADDRESS=0x0
CONFIG_MTD_NAND_ECC=m
CONFIG_MTD_NAND_ECC_SMC=y
CONFIG_MTD_NAND=m
CONFIG_MTD_NAND_VERIFY_WRITE=y
# CONFIG_MTD_NAND_ECC_BCH is not set
# CONFIG_MTD_SM_COMMON is not set
CONFIG_MTD_NAND_MUSEUM_IDS=y
# CONFIG_MTD_NAND_DENALI is not set
CONFIG_MTD_NAND_IDS=m
# CONFIG_MTD_NAND_RICOH is not set
# CONFIG_MTD_NAND_DISKONCHIP is not set
# CONFIG_MTD_NAND_DOCG4 is not set
# CONFIG_MTD_NAND_CAFE is not set
# CONFIG_MTD_NAND_NANDSIM is not set
CONFIG_MTD_NAND_PLATFORM=m
CONFIG_MTD_ONENAND=m
CONFIG_MTD_ONENAND_VERIFY_WRITE=y
CONFIG_MTD_ONENAND_GENERIC=m
CONFIG_MTD_ONENAND_OTP=y
CONFIG_MTD_ONENAND_2X_PROGRAM=y
# CONFIG_MTD_ONENAND_SIM is not set

#
# LPDDR flash memory drivers
#
# CONFIG_MTD_LPDDR is not set
# CONFIG_MTD_UBI is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_FD=m
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set

#
# DRBD disabled because PROC_FS, INET or CONNECTOR not selected
#
CONFIG_BLK_DEV_NBD=m
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_BLK_DEV_OSD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_RAM is not set
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
CONFIG_CDROM_PKTCDVD_WCACHE=y
CONFIG_ATA_OVER_ETH=m
# CONFIG_BLK_DEV_HD is not set

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
CONFIG_AD525X_DPOT=m
# CONFIG_AD525X_DPOT_SPI is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_INTEL_MID_PTI is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_HP_ILO is not set
# CONFIG_TI_DAC7512 is not set
# CONFIG_VMWARE_BALLOON is not set
# CONFIG_BMP085_SPI is not set
# CONFIG_PCH_PHUB is not set
CONFIG_C2PORT=m
CONFIG_C2PORT_DURAMAR_2150=m

#
# EEPROM support
#
# CONFIG_EEPROM_AT25 is not set
CONFIG_EEPROM_93CX6=m
CONFIG_EEPROM_93XX46=m
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#

#
# Altera FPGA firmware download module
#
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
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
# CONFIG_BLK_DEV_SD is not set
CONFIG_CHR_DEV_ST=m
# CONFIG_CHR_DEV_OSST is not set
# CONFIG_BLK_DEV_SR is not set
CONFIG_CHR_DEV_SG=m
# CONFIG_CHR_DEV_SCH is not set
CONFIG_SCSI_MULTI_LUN=y
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SCAN_ASYNC is not set

#
# SCSI Transports
#
# CONFIG_SCSI_SPI_ATTRS is not set
# CONFIG_SCSI_FC_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
CONFIG_SCSI_SAS_ATTRS=m
CONFIG_SCSI_SAS_LIBSAS=m
CONFIG_SCSI_SAS_HOST_SMP=y
# CONFIG_SCSI_SRP_ATTRS is not set
# CONFIG_SCSI_LOWLEVEL is not set
CONFIG_SCSI_DH=m
CONFIG_SCSI_DH_RDAC=m
CONFIG_SCSI_DH_HP_SW=m
# CONFIG_SCSI_DH_EMC is not set
# CONFIG_SCSI_DH_ALUA is not set
CONFIG_SCSI_OSD_INITIATOR=m
CONFIG_SCSI_OSD_ULD=m
CONFIG_SCSI_OSD_DPRINT_SENSE=1
CONFIG_SCSI_OSD_DEBUG=y
# CONFIG_ATA is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=m
# CONFIG_MD_LINEAR is not set
CONFIG_MD_RAID0=m
# CONFIG_MD_RAID1 is not set
# CONFIG_MD_RAID10 is not set
# CONFIG_MD_RAID456 is not set
CONFIG_MD_MULTIPATH=m
# CONFIG_MD_FAULTY is not set
# CONFIG_BLK_DEV_DM is not set
CONFIG_TARGET_CORE=m
# CONFIG_TCM_IBLOCK is not set
# CONFIG_TCM_FILEIO is not set
# CONFIG_TCM_PSCSI is not set
CONFIG_LOOPBACK_TARGET=m
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
# CONFIG_ISDN_I4L is not set
# CONFIG_ISDN_CAPI is not set
CONFIG_ISDN_DRV_GIGASET=m
CONFIG_GIGASET_DUMMYLL=y
CONFIG_GIGASET_M101=m
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
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_EVDEV is not set
CONFIG_INPUT_EVBUG=m

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_NEWTON is not set
CONFIG_KEYBOARD_OPENCORES=m
CONFIG_KEYBOARD_STOWAWAY=m
# CONFIG_KEYBOARD_SUNKBD is not set
CONFIG_KEYBOARD_OMAP4=m
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_INPUT_MOUSE is not set
# CONFIG_INPUT_JOYSTICK is not set
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
# CONFIG_TABLET_USB_AIPTEK is not set
# CONFIG_TABLET_USB_HANWANG is not set
# CONFIG_TABLET_USB_KBTAB is not set
# CONFIG_TABLET_USB_WACOM is not set
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_ADS7846=m
CONFIG_TOUCHSCREEN_AD7877=m
CONFIG_TOUCHSCREEN_AD7879=m
# CONFIG_TOUCHSCREEN_AD7879_SPI is not set
CONFIG_TOUCHSCREEN_CYTTSP_CORE=m
# CONFIG_TOUCHSCREEN_CYTTSP_SPI is not set
CONFIG_TOUCHSCREEN_DA9052=m
# CONFIG_TOUCHSCREEN_DYNAPRO is not set
CONFIG_TOUCHSCREEN_HAMPSHIRE=m
# CONFIG_TOUCHSCREEN_FUJITSU is not set
CONFIG_TOUCHSCREEN_GUNZE=m
CONFIG_TOUCHSCREEN_ELO=m
# CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
# CONFIG_TOUCHSCREEN_MTOUCH is not set
# CONFIG_TOUCHSCREEN_INEXIO is not set
# CONFIG_TOUCHSCREEN_MK712 is not set
CONFIG_TOUCHSCREEN_PENMOUNT=m
CONFIG_TOUCHSCREEN_TOUCHRIGHT=m
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
CONFIG_TOUCHSCREEN_WM831X=m
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
# CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
# CONFIG_TOUCHSCREEN_TSC_SERIO is not set
# CONFIG_TOUCHSCREEN_TSC2005 is not set
CONFIG_TOUCHSCREEN_PCAP=m
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=m
CONFIG_SERIO_CT82C710=m
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_SERIO_ALTERA_PS2 is not set
CONFIG_SERIO_PS2MULT=m
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
# CONFIG_VT_HW_CONSOLE_BINDING is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
# CONFIG_LEGACY_PTYS is not set
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set
CONFIG_N_GSM=m
# CONFIG_TRACE_ROUTER is not set
CONFIG_TRACE_SINK=m
CONFIG_DEVKMEM=y

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
# CONFIG_SERIAL_8250_EXTENDED is not set

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
CONFIG_SERIAL_ALTERA_JTAGUART=m
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_PCH_UART is not set
CONFIG_SERIAL_XILINX_PS_UART=m
CONFIG_IPMI_HANDLER=m
CONFIG_IPMI_PANIC_EVENT=y
# CONFIG_IPMI_PANIC_STRING is not set
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
CONFIG_IPMI_WATCHDOG=m
# CONFIG_IPMI_POWEROFF is not set
# CONFIG_HW_RANDOM is not set
CONFIG_NVRAM=m
CONFIG_R3964=m
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
CONFIG_RAW_DRIVER=m
CONFIG_MAX_RAW_DEVS=256
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
# CONFIG_I2C is not set
CONFIG_SPI=y
CONFIG_SPI_DEBUG=y
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
CONFIG_SPI_ALTERA=m
CONFIG_SPI_BITBANG=m
# CONFIG_SPI_PXA2XX_PCI is not set
# CONFIG_SPI_TOPCLIFF_PCH is not set
CONFIG_SPI_XILINX=m
# CONFIG_SPI_DESIGNWARE is not set

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
CONFIG_SPI_TLE62X0=m
# CONFIG_HSI is not set

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
# CONFIG_GPIOLIB is not set
CONFIG_W1=m
CONFIG_W1_CON=y

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
# CONFIG_W1_SLAVE_DS2408 is not set
# CONFIG_W1_SLAVE_DS2423 is not set
CONFIG_W1_SLAVE_DS2431=m
CONFIG_W1_SLAVE_DS2433=m
# CONFIG_W1_SLAVE_DS2433_CRC is not set
# CONFIG_W1_SLAVE_DS2760 is not set
CONFIG_W1_SLAVE_DS2780=m
CONFIG_W1_SLAVE_DS2781=m
# CONFIG_W1_SLAVE_DS28E04 is not set
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
# CONFIG_PDA_POWER is not set
# CONFIG_WM831X_BACKUP is not set
CONFIG_WM831X_POWER=m
CONFIG_TEST_POWER=m
CONFIG_BATTERY_DS2780=m
CONFIG_BATTERY_DS2781=m
CONFIG_BATTERY_BQ27x00=m
# CONFIG_BATTERY_BQ27X00_PLATFORM is not set
CONFIG_CHARGER_MAX8903=m
CONFIG_CHARGER_MANAGER=y
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=m
CONFIG_HWMON_VID=m
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
# CONFIG_SENSORS_ABITUGURU is not set
CONFIG_SENSORS_ABITUGURU3=m
CONFIG_SENSORS_AD7314=m
CONFIG_SENSORS_ADCXX=m
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
# CONFIG_SENSORS_DA9052_ADC is not set
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_CORETEMP is not set
CONFIG_SENSORS_IBMAEM=m
# CONFIG_SENSORS_IBMPEX is not set
CONFIG_SENSORS_IT87=m
# CONFIG_SENSORS_LM70 is not set
# CONFIG_SENSORS_MAX1111 is not set
CONFIG_SENSORS_NTC_THERMISTOR=m
CONFIG_SENSORS_PC87360=m
CONFIG_SENSORS_PC87427=m
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_SMSC47M1=m
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_ADS7871 is not set
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
CONFIG_SENSORS_WM831X=m
# CONFIG_SENSORS_APPLESMC is not set

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=m
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
# CONFIG_BCMA_HOST_PCI is not set
# CONFIG_BCMA_DRIVER_GMAC_CMN is not set
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_SM501 is not set
CONFIG_HTC_PASIC3=m
# CONFIG_MFD_STMPE is not set
# CONFIG_MFD_TMIO is not set
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_SPI=y
# CONFIG_MFD_ARIZONA_SPI is not set
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_SPI=y
# CONFIG_MFD_MC13XXX_SPI is not set
CONFIG_ABX500_CORE=y
CONFIG_EZX_PCAP=y
# CONFIG_MFD_CS5535 is not set
# CONFIG_LPC_SCH is not set
# CONFIG_LPC_ICH is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_VX855 is not set
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
CONFIG_REGULATOR_DUMMY=y
CONFIG_REGULATOR_FIXED_VOLTAGE=m
CONFIG_REGULATOR_VIRTUAL_CONSUMER=m
# CONFIG_REGULATOR_USERSPACE_CONSUMER is not set
CONFIG_REGULATOR_DA9052=m
CONFIG_REGULATOR_PCAP=m
CONFIG_REGULATOR_TPS6524X=m
CONFIG_REGULATOR_WM831X=m
CONFIG_MEDIA_SUPPORT=m

#
# Multimedia core support
#
# CONFIG_MEDIA_CAMERA_SUPPORT is not set
# CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
# CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
# CONFIG_MEDIA_RADIO_SUPPORT is not set
# CONFIG_MEDIA_RC_SUPPORT is not set

#
# Media drivers
#

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
CONFIG_VIDEO_OUTPUT_CONTROL=m
# CONFIG_FB is not set
# CONFIG_EXYNOS_VIDEO is not set
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
CONFIG_DUMMY_CONSOLE=y
CONFIG_SOUND=m
CONFIG_SOUND_OSS_CORE=y
# CONFIG_SOUND_OSS_CORE_PRECLAIM is not set
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_SEQUENCER=m
CONFIG_SND_SEQ_DUMMY=m
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=m
# CONFIG_SND_PCM_OSS is not set
# CONFIG_SND_SEQUENCER_OSS is not set
# CONFIG_SND_DYNAMIC_MINORS is not set
CONFIG_SND_SUPPORT_OLD_API=y
# CONFIG_SND_VERBOSE_PROCFS is not set
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_DMA_SGBUF=y
# CONFIG_SND_RAWMIDI_SEQ is not set
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
# CONFIG_SND_DRIVERS is not set
CONFIG_SND_PCI=y
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
# CONFIG_SND_ALI5451 is not set
# CONFIG_SND_ASIHPI is not set
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AW2 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_OXYGEN is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_CS5530 is not set
# CONFIG_SND_CS5535AUDIO is not set
# CONFIG_SND_CTXFI is not set
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
# CONFIG_SND_INDIGOIOX is not set
# CONFIG_SND_INDIGODJX is not set
# CONFIG_SND_EMU10K1 is not set
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
# CONFIG_SND_HDA_INTEL is not set
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
# CONFIG_SND_INTEL8X0 is not set
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_LOLA is not set
# CONFIG_SND_LX6464ES is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set
# CONFIG_SND_SPI is not set
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set

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
CONFIG_USB_HCD_BCMA=m

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
# CONFIG_UWB is not set
# CONFIG_MMC is not set
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
# CONFIG_MEMSTICK_JMICRON_38X is not set
# CONFIG_MEMSTICK_R592 is not set
CONFIG_NEW_LEDS=y
# CONFIG_LEDS_CLASS is not set

#
# LED drivers
#

#
# LED Triggers
#
CONFIG_ACCESSIBILITY=y
# CONFIG_A11Y_BRAILLE_CONSOLE is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y

#
# Reporting subsystems
#
CONFIG_EDAC_LEGACY_SYSFS=y
# CONFIG_EDAC_DEBUG is not set
# CONFIG_EDAC_MM_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
# CONFIG_RTC_INTF_PROC is not set
# CONFIG_RTC_INTF_DEV is not set
# CONFIG_RTC_DRV_TEST is not set

#
# SPI RTC drivers
#
CONFIG_RTC_DRV_M41T93=m
CONFIG_RTC_DRV_M41T94=m
# CONFIG_RTC_DRV_DS1305 is not set
CONFIG_RTC_DRV_DS1390=m
CONFIG_RTC_DRV_MAX6902=m
CONFIG_RTC_DRV_R9701=m
# CONFIG_RTC_DRV_RS5C348 is not set
CONFIG_RTC_DRV_DS3234=m
# CONFIG_RTC_DRV_PCF2123 is not set

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=m
CONFIG_RTC_DRV_DS1286=m
# CONFIG_RTC_DRV_DS1511 is not set
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_DS1742 is not set
# CONFIG_RTC_DRV_DA9052 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
CONFIG_RTC_DRV_M48T86=m
CONFIG_RTC_DRV_M48T35=m
CONFIG_RTC_DRV_M48T59=m
# CONFIG_RTC_DRV_MSM6242 is not set
# CONFIG_RTC_DRV_BQ4802 is not set
CONFIG_RTC_DRV_RP5C01=m
# CONFIG_RTC_DRV_V3020 is not set
# CONFIG_RTC_DRV_WM831X is not set

#
# on-CPU RTC drivers
#
CONFIG_RTC_DRV_PCAP=m
# CONFIG_DMADEVICES is not set
# CONFIG_AUXDISPLAY is not set
# CONFIG_UIO is not set

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
# CONFIG_VIRTIO_BALLOON is not set
# CONFIG_VIRTIO_MMIO is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
CONFIG_STAGING=y
# CONFIG_SLICOSS is not set
CONFIG_ECHO=m
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
# CONFIG_ADIS16201 is not set
CONFIG_ADIS16203=m
CONFIG_ADIS16204=m
CONFIG_ADIS16209=m
# CONFIG_ADIS16220 is not set
# CONFIG_ADIS16240 is not set
CONFIG_KXSD9=m
# CONFIG_SCA3000 is not set

#
# Analog to digital converters
#
# CONFIG_AD7298 is not set
# CONFIG_AD7476 is not set
# CONFIG_AD7887 is not set
# CONFIG_AD7793 is not set
CONFIG_AD7192=m
# CONFIG_ADT7310 is not set
# CONFIG_AD7280 is not set

#
# Analog digital bi-direction converters
#

#
# Capacitance to digital converters
#

#
# Direct Digital Synthesis
#
# CONFIG_AD5930 is not set
# CONFIG_AD9832 is not set
CONFIG_AD9834=m
# CONFIG_AD9850 is not set
# CONFIG_AD9852 is not set
# CONFIG_AD9910 is not set
CONFIG_AD9951=m

#
# Digital gyroscope sensors
#
# CONFIG_ADIS16060 is not set
# CONFIG_ADIS16080 is not set
CONFIG_ADIS16130=m
# CONFIG_ADIS16260 is not set
# CONFIG_ADXRS450 is not set

#
# Network Analyzer, Impedance Converters
#

#
# Inertial measurement units
#
CONFIG_ADIS16400=m

#
# Light sensors
#

#
# Magnetometer sensors
#

#
# Active energy metering IC
#
CONFIG_ADE7753=m
CONFIG_ADE7754=m
CONFIG_ADE7758=m
CONFIG_ADE7759=m
CONFIG_ADE7854=m
CONFIG_ADE7854_SPI=m

#
# Resolver to digital converters
#
# CONFIG_AD2S90 is not set

#
# Triggers - standalone
#
CONFIG_IIO_PERIODIC_RTC_TRIGGER=m
CONFIG_IIO_SYSFS_TRIGGER=m
# CONFIG_IIO_SIMPLE_DUMMY is not set
# CONFIG_ZSMALLOC is not set
# CONFIG_CRYSTALHD is not set
# CONFIG_ACPI_QUICKSTART is not set
CONFIG_FT1000=m

#
# Speakup console speech
#
CONFIG_SPEAKUP=m
CONFIG_SPEAKUP_SYNTH_ACNTSA=m
CONFIG_SPEAKUP_SYNTH_ACNTPC=m
CONFIG_SPEAKUP_SYNTH_APOLLO=m
CONFIG_SPEAKUP_SYNTH_AUDPTR=m
CONFIG_SPEAKUP_SYNTH_BNS=m
# CONFIG_SPEAKUP_SYNTH_DECTLK is not set
CONFIG_SPEAKUP_SYNTH_DECEXT=m
# CONFIG_SPEAKUP_SYNTH_DECPC is not set
# CONFIG_SPEAKUP_SYNTH_DTLK is not set
# CONFIG_SPEAKUP_SYNTH_KEYPC is not set
CONFIG_SPEAKUP_SYNTH_LTLK=m
# CONFIG_SPEAKUP_SYNTH_SOFT is not set
CONFIG_SPEAKUP_SYNTH_SPKOUT=m
# CONFIG_SPEAKUP_SYNTH_TXPRT is not set
CONFIG_SPEAKUP_SYNTH_DUMMY=m
CONFIG_STAGING_MEDIA=y

#
# Android
#
# CONFIG_ANDROID is not set
CONFIG_PHONE=m
# CONFIG_PHONE_IXJ is not set
# CONFIG_IPACK_BUS is not set
# CONFIG_WIMAX_GDM72XX is not set
# CONFIG_X86_PLATFORM_DEVICES is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
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
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
CONFIG_MEMORY=y
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
# CONFIG_AD8366 is not set

#
# Light sensors
#

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
CONFIG_AD5064=m
# CONFIG_AD5360 is not set
CONFIG_AD5380=m
# CONFIG_AD5421 is not set
# CONFIG_AD5624R_SPI is not set
# CONFIG_AD5446 is not set
# CONFIG_AD5504 is not set
CONFIG_AD5764=m
# CONFIG_AD5791 is not set
# CONFIG_AD5686 is not set
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
# CONFIG_DMIID is not set
CONFIG_DMI_SYSFS=m
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=m
# CONFIG_EXT2_FS_XATTR is not set
CONFIG_EXT2_FS_XIP=y
# CONFIG_EXT3_FS is not set
# CONFIG_EXT4_FS is not set
CONFIG_FS_XIP=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
# CONFIG_XFS_FS is not set
CONFIG_GFS2_FS=m
# CONFIG_OCFS2_FS is not set
# CONFIG_BTRFS_FS is not set
CONFIG_NILFS2_FS=m
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
# CONFIG_QUOTA is not set
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
CONFIG_QUOTACTL=y
CONFIG_QUOTACTL_COMPAT=y
# CONFIG_AUTOFS4_FS is not set
CONFIG_FUSE_FS=m
CONFIG_CUSE=m

#
# Caches
#
CONFIG_FSCACHE=m
# CONFIG_FSCACHE_STATS is not set
CONFIG_FSCACHE_HISTOGRAM=y
# CONFIG_FSCACHE_DEBUG is not set
CONFIG_FSCACHE_OBJECT_LIST=y
CONFIG_CACHEFILES=m
CONFIG_CACHEFILES_DEBUG=y
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
# CONFIG_MSDOS_FS is not set
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
# CONFIG_PROC_VMCORE is not set
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
# CONFIG_TMPFS is not set
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=m
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
CONFIG_AFFS_FS=m
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
CONFIG_EFS_FS=m
CONFIG_JFFS2_FS=m
CONFIG_JFFS2_FS_DEBUG=0
# CONFIG_JFFS2_FS_WRITEBUFFER is not set
# CONFIG_JFFS2_SUMMARY is not set
CONFIG_JFFS2_FS_XATTR=y
# CONFIG_JFFS2_FS_POSIX_ACL is not set
# CONFIG_JFFS2_FS_SECURITY is not set
CONFIG_JFFS2_COMPRESSION_OPTIONS=y
CONFIG_JFFS2_ZLIB=y
CONFIG_JFFS2_LZO=y
# CONFIG_JFFS2_RTIME is not set
CONFIG_JFFS2_RUBIN=y
CONFIG_JFFS2_CMODE_NONE=y
# CONFIG_JFFS2_CMODE_PRIORITY is not set
# CONFIG_JFFS2_CMODE_SIZE is not set
# CONFIG_JFFS2_CMODE_FAVOURLZO is not set
# CONFIG_LOGFS is not set
# CONFIG_CRAMFS is not set
# CONFIG_SQUASHFS is not set
# CONFIG_VXFS_FS is not set
CONFIG_MINIX_FS=m
# CONFIG_OMFS_FS is not set
CONFIG_HPFS_FS=m
CONFIG_QNX4FS_FS=m
CONFIG_QNX6FS_FS=m
# CONFIG_QNX6FS_DEBUG is not set
# CONFIG_ROMFS_FS is not set
CONFIG_PSTORE=y
# CONFIG_PSTORE_CONSOLE is not set
# CONFIG_PSTORE_FTRACE is not set
CONFIG_PSTORE_RAM=m
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
CONFIG_EXOFS_FS=m
CONFIG_EXOFS_DEBUG=y
CONFIG_ORE=m
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NCP_FS=m
CONFIG_NCPFS_PACKET_SIGNING=y
# CONFIG_NCPFS_IOCTL_LOCKING is not set
CONFIG_NCPFS_STRONG=y
# CONFIG_NCPFS_NFS_NS is not set
CONFIG_NCPFS_OS2_NS=y
CONFIG_NCPFS_SMALLDOS=y
# CONFIG_NCPFS_NLS is not set
# CONFIG_NCPFS_EXTRAS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
CONFIG_NLS_CODEPAGE_852=m
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=m
CONFIG_NLS_CODEPAGE_861=m
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
CONFIG_NLS_CODEPAGE_864=m
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
CONFIG_NLS_CODEPAGE_869=m
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
CONFIG_NLS_CODEPAGE_932=m
CONFIG_NLS_CODEPAGE_949=m
CONFIG_NLS_CODEPAGE_874=m
CONFIG_NLS_ISO8859_8=m
CONFIG_NLS_CODEPAGE_1250=m
CONFIG_NLS_CODEPAGE_1251=m
# CONFIG_NLS_ASCII is not set
CONFIG_NLS_ISO8859_1=m
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=m
CONFIG_NLS_ISO8859_5=m
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
CONFIG_NLS_ISO8859_13=m
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=m
# CONFIG_NLS_KOI8_R is not set
CONFIG_NLS_KOI8_U=m
CONFIG_NLS_MAC_ROMAN=m
CONFIG_NLS_MAC_CELTIC=m
# CONFIG_NLS_MAC_CENTEURO is not set
# CONFIG_NLS_MAC_CROATIAN is not set
CONFIG_NLS_MAC_CYRILLIC=m
# CONFIG_NLS_MAC_GAELIC is not set
CONFIG_NLS_MAC_GREEK=m
# CONFIG_NLS_MAC_ICELAND is not set
CONFIG_NLS_MAC_INUIT=m
CONFIG_NLS_MAC_ROMANIAN=m
# CONFIG_NLS_MAC_TURKISH is not set
# CONFIG_NLS_UTF8 is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
CONFIG_MAGIC_SYSRQ=y
CONFIG_STRIP_ASM_SYMS=y
CONFIG_READABLE_ASM=y
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=1
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
CONFIG_BOOTPARAM_HUNG_TASK_PANIC=y
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=1
CONFIG_SCHED_DEBUG=y
# CONFIG_SCHEDSTATS is not set
# CONFIG_TIMER_STATS is not set
CONFIG_DEBUG_OBJECTS=y
# CONFIG_DEBUG_OBJECTS_SELFTEST is not set
# CONFIG_DEBUG_OBJECTS_FREE is not set
# CONFIG_DEBUG_OBJECTS_TIMERS is not set
# CONFIG_DEBUG_OBJECTS_WORK is not set
# CONFIG_DEBUG_OBJECTS_RCU_HEAD is not set
# CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER is not set
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
CONFIG_SLUB_DEBUG_ON=y
CONFIG_SLUB_STATS=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
CONFIG_RT_MUTEX_TESTER=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_PROVE_RCU=y
CONFIG_PROVE_RCU_REPEATEDLY=y
# CONFIG_SPARSE_RCU_POINTER is not set
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
CONFIG_DEBUG_LOCKDEP=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_INFO is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_LIST is not set
CONFIG_TEST_LIST_SORT=y
# CONFIG_DEBUG_SG is not set
CONFIG_DEBUG_NOTIFIERS=y
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=60
CONFIG_RCU_CPU_STALL_INFO=y
CONFIG_RCU_TRACE=y
CONFIG_KPROBES_SANITY_TEST=y
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
CONFIG_DEBUG_PER_CPU_MAPS=y
CONFIG_LKDTM=m
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
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
CONFIG_HAVE_FENTRY=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_EVENT_POWER_TRACING_DEPRECATED=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
CONFIG_IRQSOFF_TRACER=y
CONFIG_SCHED_TRACER=y
CONFIG_FTRACE_SYSCALLS=y
CONFIG_TRACE_BRANCH_PROFILING=y
# CONFIG_BRANCH_PROFILE_NONE is not set
CONFIG_PROFILE_ANNOTATED_BRANCHES=y
# CONFIG_PROFILE_ALL_BRANCHES is not set
CONFIG_TRACING_BRANCHES=y
CONFIG_BRANCH_TRACER=y
# CONFIG_STACK_TRACER is not set
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_KPROBE_EVENT=y
CONFIG_UPROBE_EVENT=y
CONFIG_PROBE_EVENTS=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_FUNCTION_PROFILER=y
CONFIG_FTRACE_MCOUNT_RECORD=y
CONFIG_FTRACE_SELFTEST=y
CONFIG_FTRACE_STARTUP_TEST=y
# CONFIG_EVENT_TRACE_TEST_SYSCALLS is not set
# CONFIG_MMIOTRACE is not set
CONFIG_RING_BUFFER_BENCHMARK=m
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
CONFIG_DYNAMIC_DEBUG=y
CONFIG_DMA_API_DEBUG=y
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_TEST_KSTRTOX=m
CONFIG_STRICT_DEVMEM=y
# CONFIG_X86_VERBOSE_BOOTUP is not set
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_X86_PTDUMP=y
# CONFIG_DEBUG_RODATA is not set
# CONFIG_DEBUG_SET_MODULE_RONX is not set
# CONFIG_DEBUG_NX_TEST is not set
# CONFIG_DEBUG_TLBFLUSH is not set
# CONFIG_IOMMU_DEBUG is not set
CONFIG_IOMMU_STRESS=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
# CONFIG_X86_DECODER_SELFTEST is not set
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
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
CONFIG_DEBUG_NMI_SELFTEST=y

#
# Security options
#
CONFIG_KEYS=y
CONFIG_ENCRYPTED_KEYS=m
CONFIG_KEYS_DEBUG_PROC_KEYS=y
CONFIG_SECURITY_DMESG_RESTRICT=y
# CONFIG_SECURITY is not set
CONFIG_SECURITYFS=y
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_XOR_BLOCKS=m
CONFIG_ASYNC_CORE=m
CONFIG_ASYNC_XOR=m
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
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=m
CONFIG_CRYPTO_NULL=m
# CONFIG_CRYPTO_PCRYPT is not set
CONFIG_CRYPTO_WORKQUEUE=m
CONFIG_CRYPTO_CRYPTD=m
# CONFIG_CRYPTO_AUTHENC is not set
# CONFIG_CRYPTO_TEST is not set
CONFIG_CRYPTO_ABLK_HELPER_X86=m

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
CONFIG_CRYPTO_ECB=m
CONFIG_CRYPTO_LRW=m
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=m

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=m
# CONFIG_CRYPTO_XCBC is not set
CONFIG_CRYPTO_VMAC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=m
# CONFIG_CRYPTO_CRC32C_INTEL is not set
CONFIG_CRYPTO_GHASH=m
# CONFIG_CRYPTO_MD4 is not set
# CONFIG_CRYPTO_MD5 is not set
# CONFIG_CRYPTO_MICHAEL_MIC is not set
CONFIG_CRYPTO_RMD128=m
CONFIG_CRYPTO_RMD160=m
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
# CONFIG_CRYPTO_SHA1 is not set
# CONFIG_CRYPTO_SHA1_SSSE3 is not set
CONFIG_CRYPTO_SHA256=m
CONFIG_CRYPTO_SHA512=m
# CONFIG_CRYPTO_TGR192 is not set
CONFIG_CRYPTO_WP512=m
# CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=m
CONFIG_CRYPTO_AES_X86_64=m
CONFIG_CRYPTO_AES_NI_INTEL=m
CONFIG_CRYPTO_ANUBIS=m
# CONFIG_CRYPTO_ARC4 is not set
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_BLOWFISH_COMMON=m
# CONFIG_CRYPTO_BLOWFISH_X86_64 is not set
# CONFIG_CRYPTO_CAMELLIA is not set
# CONFIG_CRYPTO_CAMELLIA_X86_64 is not set
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_DES=m
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_KHAZAD=m
CONFIG_CRYPTO_SALSA20=m
CONFIG_CRYPTO_SALSA20_X86_64=m
CONFIG_CRYPTO_SEED=m
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_SERPENT_SSE2_X86_64 is not set
# CONFIG_CRYPTO_SERPENT_AVX_X86_64 is not set
# CONFIG_CRYPTO_TEA is not set
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
# CONFIG_CRYPTO_TWOFISH_X86_64 is not set
# CONFIG_CRYPTO_TWOFISH_X86_64_3WAY is not set
# CONFIG_CRYPTO_TWOFISH_AVX_X86_64 is not set

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=m
# CONFIG_CRYPTO_ZLIB is not set
# CONFIG_CRYPTO_LZO is not set

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYPTO_USER_API=m
# CONFIG_CRYPTO_USER_API_HASH is not set
CONFIG_CRYPTO_USER_API_SKCIPHER=m
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
CONFIG_CRC_T10DIF=m
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
# CONFIG_CRC32_SLICEBY8 is not set
CONFIG_CRC32_SLICEBY4=y
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=m
CONFIG_LIBCRC32C=m
CONFIG_CRC8=m
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=m
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_REED_SOLOMON=m
CONFIG_REED_SOLOMON_ENC8=y
CONFIG_REED_SOLOMON_DEC8=y
CONFIG_BCH=m
CONFIG_BCH_CONST_PARAMS=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CPUMASK_OFFSTACK=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
# CONFIG_AVERAGE is not set
# CONFIG_CORDIC is not set
# CONFIG_DDR is not set

--HlL+5n6rz5pIUxbD--

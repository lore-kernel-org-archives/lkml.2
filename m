Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657Ab2IFJzE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 05:55:04 -0400
Received: from mga14.intel.com ([143.182.124.37]:2502 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753050Ab2IFJy5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 05:54:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,379,1344236400"; 
   d="scan'208";a="189483384"
Date: Thu, 6 Sep 2012 17:54:52 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: In slow QEMU: task rb_producer:17 blocked for more than 120 seconds.
Message-ID: <20120906095452.GA30404@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="J2SCkAp4GZ/dPZZf"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Steven,

Two of my test boxes run the slower QEMU VMs and the guest kernels
often trigger warnings like:

[  511.809001] Testing event mm_vmscan_memcg_reclaim_end: [  512.852980] INFO: task rb_producer:17 blocked for more than 120 seconds.
[  513.279212] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.

Will it be possible to insert some break into the test thread for
avoiding the warnings?

Thanks,
Fengguang

--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-kvm-tyan-3845-2012-09-06-11-14-36-3.6.0-rc4-00087-gcb4f9a2-262"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.6.0-rc4-00087-gcb4f9a2 (kbuild@kbuild) (gcc =
version 4.7.1 (Debian 4.7.1-6) ) #262 PREEMPT Thu Sep 6 11:02:21 CST 2012
[    0.000000] KERNEL supported cpus:
[    0.000000]   Centaur CentaurHauls
[    0.000000]   Transmeta GenuineTMx86
[    0.000000]   Transmeta TransmetaCPU
[    0.000000] CPU: vendor_id 'AuthenticAMD' unknown, using generic init.
[    0.000000] CPU: Your system may be unstable.
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000093bff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000093c00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: n=
on-PAE kernel!
[    0.000000] DMI 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2007
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x100000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdac0-0x000fdacf] mapped at =
[c00fdac0]
[    0.000000]   mpc: fdad0-fdbec
[    0.000000] initial memory mapped: [mem 0x00000000-0x027fffff]
[    0.000000] Base memory trampoline at [c008f000] 8f000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x0fffdfff]
[    0.000000]  [mem 0x00000000-0x0fffdfff] page 4k
[    0.000000] kernel direct mapping tables up to 0xfffdfff @ [mem 0x027bd0=
00-0x027fffff]
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 128980(98%)
[    0.000000] RAMDISK: [mem 0x0e73f000-0x0ffeffff]
[    0.000000] ACPI: RSDP 000fd930 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0fffe550 00038 (v01 BOCHS  BXPCRSDT 00000001 BXPC=
 00000001)
[    0.000000] ACPI: FACP 0fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC=
 00000001)
[    0.000000] ACPI: DSDT 0fffe590 01121 (v01   BXPC   BXDSDT 00000001 INTL=
 20100528)
[    0.000000] ACPI: FACS 0fffff40 00040
[    0.000000] ACPI: SSDT 0ffffe40 000FF (v01 BOCHS  BXPCSSDT 00000001 BXPC=
 00000001)
[    0.000000] ACPI: APIC 0ffffd50 00080 (v01 BOCHS  BXPCAPIC 00000001 BXPC=
 00000001)
[    0.000000] ACPI: HPET 0ffffd10 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC=
 00000001)
[    0.000000] ACPI: SSDT 0ffff6c0 00644 (v01   BXPC BXSSDTPC 00000001 INTL=
 20100528)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 255MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 0fffe000
[    0.000000]   low ram: 0 - 0fffe000
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x0fffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x00092fff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65409
[    0.000000] free_area_init_node: node 0, pgdat c1bff860, node_mem_map cd=
cbf280
[    0.000000]   DMA zone: 40 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3931 pages, LIFO batch:0
[    0.000000]   Normal zone: 600 pages used for memmap
[    0.000000]   Normal zone: 60838 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Intel MultiProcessor Specification v1.4
[    0.000000]     Virtual Wire compatibility mode.
[    0.000000]   mpc: fdad0-fdbec
[    0.000000] MPTABLE: OEM ID: BOCHSCPU
[    0.000000] MPTABLE: Product ID: 0.1        =20
[    0.000000] MPTABLE: APIC at: 0xFEE00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] Processor #1
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 1=
/0x1 ignored.
[    0.000000] Bus #0 is PCI  =20
[    0.000000] Bus #1 is ISA  =20
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-=
23
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 04, APIC ID 2, APIC =
INT 09
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 0c, APIC ID 2, APIC =
INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 10, APIC ID 2, APIC =
INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 14, APIC ID 2, APIC =
INT 0a
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 18, APIC ID 2, APIC =
INT 0a
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 1c, APIC ID 2, APIC =
INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 20, APIC ID 2, APIC =
INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 24, APIC ID 2, APIC =
INT 0a
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 00, APIC ID 2, APIC =
INT 02
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 01, APIC ID 2, APIC =
INT 01
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 03, APIC ID 2, APIC =
INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 04, APIC ID 2, APIC =
INT 04
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 05, APIC ID 2, APIC =
INT 05
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 06, APIC ID 2, APIC =
INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 07, APIC ID 2, APIC =
INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 08, APIC ID 2, APIC =
INT 08
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0c, APIC ID 2, APIC =
INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0d, APIC ID 2, APIC =
INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0e, APIC ID 2, APIC =
INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0f, APIC ID 2, APIC =
INT 0f
[    0.000000] Lint: type 3, pol 0, trig 0, bus 01, IRQ 00, APIC ID 0, APIC=
 LINT 00
[    0.000000] Lint: type 1, pol 0, trig 0, bus 01, IRQ 00, APIC ID ff, API=
C LINT 01
[    0.000000] Processors: 1
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x10000000-0xfffbffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64769
[    0.000000] Kernel command line: trinity=3D2m hung_task_panic=3D1 rcutre=
e.rcu_cpu_stall_timeout=3D100 branch=3Dlinus/master log_buf_len=3D8M ignore=
_loglevel debug sched_debug apic=3Ddebug dynamic_printk sysrq_always_enable=
d panic=3D10  prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=
=3Dnormal  root=3D/dev/ram0 rw link=3Dvmlinuz-2012-09-06-11-02-57-linus:mas=
ter:cb4f9a2-cb4f9a2-i386-randconfig-k914-6-tyan noapic nolapic nohz=3Doff B=
OOT_IMAGE=3Dkernel-tests/kernels/i386-randconfig-k914/cb4f9a2/vmlinuz-3.6.0=
-rc4-00087-gcb4f9a2
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 204152k/262136k available (7737k kernel code, 57484k=
 reserved, 4683k data, 640k init, 0k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff8d000 - 0xfffff000   ( 456 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xd07fe000 - 0xff7fe000   ( 752 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xcfffe000   ( 255 MB)
[    0.000000]       .init : 0xc1c23000 - 0xc1cc3000   ( 640 kB)
[    0.000000]       .data : 0xc178e677 - 0xc1c21540   (4683 kB)
[    0.000000]       .text : 0xc1000000 - 0xc178e677   (7737 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] SLUB: Genslabs=3D15, HWalign=3D64, Order=3D0-3, MinObjects=
=3D0, CPUs=3D1, Nodes=3D1
[    0.000000] NR_IRQS:2304 nr_irqs:256 16
[    0.000000] CPU 0 irqstacks, hard=3Dcd808000 soft=3Dcd80a000
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
[    0.000000]  memory used by lock dependency info: 3567 kB
[    0.000000]  per task-struct memory footprint: 1152 bytes
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration failed
[    0.000000] tsc: Unable to calibrate against PIT
[    0.000000] tsc: using HPET reference calibration
[    0.000000] tsc: Detected 2009.210 MHz processor
[    0.038033] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 4020.85 BogoMIPS (lpj=3D6697366)
[    0.047283] pid_max: default: 32768 minimum: 301
[    0.069009] Mount-cache hash table entries: 512
[    0.264996] Initializing cgroup subsys debug
[    0.268146] Initializing cgroup subsys cpuacct
[    0.270606] Initializing cgroup subsys devices
[    0.271901] Initializing cgroup subsys perf_event
[    0.297459] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.297459] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.297459] tlb_flushall_shift is 0xffffffff
[    0.300565] CPU: AuthenticAMD QEMU Virtual CPU version 1.1.0 stepping 03
[    0.398483] ACPI: Core revision 20120711
[    1.047448] ACPI: setting ELCR to 0200 (from 0c00)
[    1.124033] Performance Events:=20
[    1.234173] ftrace: Allocated trace_printk buffers
[    1.254972] Testing tracer nop: PASSED
[    1.277624] Apic disabled
[    1.402329] devtmpfs: initialized
[    1.422041] device: 'platform': device_add
[    1.435247] PM: Adding info for No Bus:platform
[    1.455552] bus: 'platform': registered
[    1.462498] bus: 'cpu': registered
[    1.464505] device: 'cpu': device_add
[    1.472397] PM: Adding info for No Bus:cpu
[    1.655473] bus: 'virtio': registered
[    1.657357] device class 'regulator': registering
[    1.698374] Registering platform device 'reg-dummy'. Parent at platform
[    1.700636] device: 'reg-dummy': device_add
[    1.703856] bus: 'platform': add device reg-dummy
[    1.712323] PM: Adding info for platform:reg-dummy
[    1.727755] bus: 'platform': add driver reg-dummy
[    1.733921] bus: 'platform': driver_probe_device: matched device reg-dum=
my with driver reg-dummy
[    1.735244] bus: 'platform': really_probe: probing driver reg-dummy with=
 device reg-dummy
[    1.750484] device: 'regulator.0': device_add
[    1.768252] PM: Adding info for No Bus:regulator.0
[    1.787304] dummy:=20
[    1.800533] driver: 'reg-dummy': driver_bound: bound to device 'reg-dumm=
y'
[    1.805654] bus: 'platform': really_probe: bound device reg-dummy to dri=
ver reg-dummy
[    1.841781] NET: Registered protocol family 16
[    1.891967] device class 'bdi': registering
[    1.898130] bus: 'platform': add driver ramoops
[    1.905049] device class 'pci_bus': registering
[    1.913827] bus: 'pci': registered
[    1.914696] device class 'tty': registering
[    1.925284] bus: 'spi': registered
[    1.927232] device class 'spi_master': registering
[    1.934744] bus: 'i2c': registered
[    1.938254] bus: 'i2c': add driver dummy
[    2.018047] ACPI: bus type pci registered
[    2.020720] device class 'dma': registering
[    2.081537] PCI: PCI BIOS revision 2.10 entry at 0xfc78c, last bus=3D0
[    2.087150] PCI: Using configuration type 1 for base access
[    2.120801] device: 'cpu0': device_add
[    2.122183] bus: 'cpu': add device cpu0
[    2.124631] PM: Adding info for cpu:cpu0
[    2.611372] device: 'default': device_add
[    2.617688] PM: Adding info for No Bus:default
[    2.648374] bus: 'spi': add driver 74x164
[    2.653951] bus: 'i2c': add driver max7300
[    2.660973] bus: 'spi': add driver mcp23s08
[    2.668031] bus: 'i2c': add driver mcp230xx
[    2.672059] bus: 'i2c': add driver pca953x
[    2.678035] bus: 'i2c': add driver pcf857x
[    2.684159] bus: 'platform': add driver rc5t583-gpio
[    2.694005] bus: 'platform': add driver tps65910-gpio
[    2.701578] bus: 'platform': add driver wm8350-gpio
[    2.707301] bus: 'platform': add driver wm8994-gpio
[    2.721004] ACPI: Added _OSI(Module Device)
[    2.722016] ACPI: Added _OSI(Processor Device)
[    2.723886] ACPI: Added _OSI(3.0 _SCP Extensions)
[    2.724799] ACPI: Added _OSI(Processor Aggregator Device)
[    3.191876] ACPI: EC: Look up EC in DSDT
[    4.555486] ACPI: Interpreter enabled
[    4.557056] ACPI: (supports S0 S3 S5)
[    4.574074] ACPI: Using PIC for interrupt routing
[    4.583952] bus: 'acpi': registered
[    4.584998] bus: 'acpi': add driver power
[    4.607970] device: 'LNXSYSTM:00': device_add
[    4.612136] bus: 'acpi': add device LNXSYSTM:00
[    4.614385] PM: Adding info for acpi:LNXSYSTM:00
[    4.657149] device: 'device:00': device_add
[    4.661079] bus: 'acpi': add device device:00
[    4.663972] PM: Adding info for acpi:device:00
[    4.687771] device: 'PNP0A03:00': device_add
[    4.690406] bus: 'acpi': add device PNP0A03:00
[    4.691919] PM: Adding info for acpi:PNP0A03:00
[    4.881469] device: 'device:01': device_add
[    4.884148] bus: 'acpi': add device device:01
[    4.890285] PM: Adding info for acpi:device:01
[    4.908448] device: 'device:02': device_add
[    4.911102] bus: 'acpi': add device device:02
[    4.914200] PM: Adding info for acpi:device:02
[    4.934466] device: 'PNP0B00:00': device_add
[    4.937506] bus: 'acpi': add device PNP0B00:00
[    4.940609] PM: Adding info for acpi:PNP0B00:00
[    4.968722] device: 'PNP0303:00': device_add
[    4.970891] bus: 'acpi': add device PNP0303:00
[    4.974343] PM: Adding info for acpi:PNP0303:00
[    5.007213] device: 'PNP0F13:00': device_add
[    5.008539] bus: 'acpi': add device PNP0F13:00
[    5.011030] PM: Adding info for acpi:PNP0F13:00
[    5.039674] device: 'PNP0700:00': device_add
[    5.040808] bus: 'acpi': add device PNP0700:00
[    5.044325] PM: Adding info for acpi:PNP0700:00
[    5.091101] device: 'PNP0400:00': device_add
[    5.097059] bus: 'acpi': add device PNP0400:00
[    5.100409] PM: Adding info for acpi:PNP0400:00
[    5.141728] device: 'PNP0501:00': device_add
[    5.144178] bus: 'acpi': add device PNP0501:00
[    5.150490] PM: Adding info for acpi:PNP0501:00
[    5.184333] device: 'device:03': device_add
[    5.186331] bus: 'acpi': add device device:03
[    5.190905] PM: Adding info for acpi:device:03
[    5.215052] device: 'device:04': device_add
[    5.220478] bus: 'acpi': add device device:04
[    5.221972] PM: Adding info for acpi:device:04
[    5.243713] device: 'device:05': device_add
[    5.245027] bus: 'acpi': add device device:05
[    5.250527] PM: Adding info for acpi:device:05
[    5.274189] device: 'device:06': device_add
[    5.275536] bus: 'acpi': add device device:06
[    5.280908] PM: Adding info for acpi:device:06
[    5.305008] device: 'device:07': device_add
[    5.310371] bus: 'acpi': add device device:07
[    5.311880] PM: Adding info for acpi:device:07
[    5.335046] device: 'device:08': device_add
[    5.340410] bus: 'acpi': add device device:08
[    5.341901] PM: Adding info for acpi:device:08
[    5.364200] device: 'device:09': device_add
[    5.367443] bus: 'acpi': add device device:09
[    5.370225] PM: Adding info for acpi:device:09
[    5.392007] device: 'device:0a': device_add
[    5.394133] bus: 'acpi': add device device:0a
[    5.397421] PM: Adding info for acpi:device:0a
[    5.421298] device: 'device:0b': device_add
[    5.423844] bus: 'acpi': add device device:0b
[    5.425297] PM: Adding info for acpi:device:0b
[    5.451408] device: 'device:0c': device_add
[    5.453942] bus: 'acpi': add device device:0c
[    5.455434] PM: Adding info for acpi:device:0c
[    5.479097] device: 'device:0d': device_add
[    5.480806] bus: 'acpi': add device device:0d
[    5.484303] PM: Adding info for acpi:device:0d
[    5.508608] device: 'device:0e': device_add
[    5.510792] bus: 'acpi': add device device:0e
[    5.517281] PM: Adding info for acpi:device:0e
[    5.537787] device: 'device:0f': device_add
[    5.543597] bus: 'acpi': add device device:0f
[    5.545113] PM: Adding info for acpi:device:0f
[    5.568334] device: 'device:10': device_add
[    5.570836] bus: 'acpi': add device device:10
[    5.574309] PM: Adding info for acpi:device:10
[    5.597556] device: 'device:11': device_add
[    5.598851] bus: 'acpi': add device device:11
[    5.601013] PM: Adding info for acpi:device:11
[    5.627880] device: 'device:12': device_add
[    5.630801] bus: 'acpi': add device device:12
[    5.636302] PM: Adding info for acpi:device:12
[    5.665446] device: 'device:13': device_add
[    5.670697] bus: 'acpi': add device device:13
[    5.673628] PM: Adding info for acpi:device:13
[    5.700111] device: 'device:14': device_add
[    5.701461] bus: 'acpi': add device device:14
[    5.704110] PM: Adding info for acpi:device:14
[    5.731309] device: 'device:15': device_add
[    5.733819] bus: 'acpi': add device device:15
[    5.735281] PM: Adding info for acpi:device:15
[    5.767265] device: 'device:16': device_add
[    5.768686] bus: 'acpi': add device device:16
[    5.771022] PM: Adding info for acpi:device:16
[    5.798390] device: 'device:17': device_add
[    5.800820] bus: 'acpi': add device device:17
[    5.807055] PM: Adding info for acpi:device:17
[    5.830147] device: 'device:18': device_add
[    5.831569] bus: 'acpi': add device device:18
[    5.837439] PM: Adding info for acpi:device:18
[    5.860518] device: 'device:19': device_add
[    5.866787] bus: 'acpi': add device device:19
[    5.868426] PM: Adding info for acpi:device:19
[    5.888542] device: 'device:1a': device_add
[    5.894006] bus: 'acpi': add device device:1a
[    5.895717] PM: Adding info for acpi:device:1a
[    5.920365] device: 'device:1b': device_add
[    5.921780] bus: 'acpi': add device device:1b
[    5.924270] PM: Adding info for acpi:device:1b
[    5.947678] device: 'device:1c': device_add
[    5.950710] bus: 'acpi': add device device:1c
[    5.954271] PM: Adding info for acpi:device:1c
[    5.977495] device: 'device:1d': device_add
[    5.978842] bus: 'acpi': add device device:1d
[    5.980899] PM: Adding info for acpi:device:1d
[    6.008152] device: 'device:1e': device_add
[    6.010718] bus: 'acpi': add device device:1e
[    6.013885] PM: Adding info for acpi:device:1e
[    6.037760] device: 'device:1f': device_add
[    6.040498] bus: 'acpi': add device device:1f
[    6.043685] PM: Adding info for acpi:device:1f
[    6.067127] device: 'device:20': device_add
[    6.068445] bus: 'acpi': add device device:20
[    6.074539] PM: Adding info for acpi:device:20
[    6.100506] device: 'device:21': device_add
[    6.101824] bus: 'acpi': add device device:21
[    6.104278] PM: Adding info for acpi:device:21
[    6.127796] device: 'device:22': device_add
[    6.130479] bus: 'acpi': add device device:22
[    6.131925] PM: Adding info for acpi:device:22
[    6.200781] device: 'PNP0103:00': device_add
[    6.202159] bus: 'acpi': add device PNP0103:00
[    6.206984] PM: Adding info for acpi:PNP0103:00
[    6.255406] device: 'PNP0C0F:00': device_add
[    6.257396] bus: 'acpi': add device PNP0C0F:00
[    6.260840] PM: Adding info for acpi:PNP0C0F:00
[    6.303907] device: 'PNP0C0F:01': device_add
[    6.307208] bus: 'acpi': add device PNP0C0F:01
[    6.308665] PM: Adding info for acpi:PNP0C0F:01
[    6.351315] device: 'PNP0C0F:02': device_add
[    6.354015] bus: 'acpi': add device PNP0C0F:02
[    6.357638] PM: Adding info for acpi:PNP0C0F:02
[    6.400784] device: 'PNP0C0F:03': device_add
[    6.407076] bus: 'acpi': add device PNP0C0F:03
[    6.410209] PM: Adding info for acpi:PNP0C0F:03
[    6.454207] device: 'PNP0C0F:04': device_add
[    6.456818] bus: 'acpi': add device PNP0C0F:04
[    6.458339] PM: Adding info for acpi:PNP0C0F:04
[    6.491721] device: 'LNXCPU:00': device_add
[    6.494029] bus: 'acpi': add device LNXCPU:00
[    6.497546] PM: Adding info for acpi:LNXCPU:00
[    6.526887] device: 'LNXCPU:01': device_add
[    6.528231] bus: 'acpi': add device LNXCPU:01
[    6.530860] PM: Adding info for acpi:LNXCPU:01
[    6.560390] device: 'device:23': device_add
[    6.561755] bus: 'acpi': add device device:23
[    6.564250] PM: Adding info for acpi:device:23
[    6.581044] device: 'LNXPWRBN:00': device_add
[    6.583732] bus: 'acpi': add device LNXPWRBN:00
[    6.586816] PM: Adding info for acpi:LNXPWRBN:00
[    6.600407] bus: 'acpi': add driver ec
[    6.617072] PCI: Ignoring host bridge windows from ACPI; if necessary, u=
se "pci=3Duse_crs" and report a bug
[    6.618523] bus: 'acpi': add driver pci_root
[    6.620928] bus: 'acpi': driver_probe_device: matched device PNP0A03:00 =
with driver pci_root
[    6.626708] bus: 'acpi': really_probe: probing driver pci_root with devi=
ce PNP0A03:00
[    6.644634] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    6.659569] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] =
(ignored)
[    6.663569] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] =
(ignored)
[    6.664779] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x00=
0bffff] (ignored)
[    6.666821] pci_root PNP0A03:00: host bridge window [mem 0xe0000000-0xfe=
bfffff] (ignored)
[    6.673890] PCI: root bus 00: using default resources
[    6.677354] pci_root PNP0A03:00: fail to add MMCONFIG information, can't=
 access extended PCI configuration space under this bridge.
[    6.685158] device: 'pci0000:00': device_add
[    6.693864] PM: Adding info for No Bus:pci0000:00
[    6.703802] device: '0000:00': device_add
[    6.711453] PM: Adding info for No Bus:0000:00
[    6.717553] PCI host bridge to bus 0000:00
[    6.721326] pci_bus 0000:00: busn_res: [bus 00-ff] is inserted under dom=
ain [bus 00-ff]
[    6.723749] pci_bus 0000:00: root bus resource [bus 00-ff]
[    6.727744] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    6.730367] pci_bus 0000:00: root bus resource [mem 0x00000000-0xfffffff=
f]
[    6.744662] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    6.768278] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    6.784637] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    6.801077] pci 0000:00:01.1: reg 20: [io  0xc1c0-0xc1cf]
[    6.812892] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    6.827295] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    6.830287] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    6.837045] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    6.840921] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
[    6.850182] pci 0000:00:02.0: reg 14: [mem 0xfebf0000-0xfebf0fff]
[    6.867379] pci 0000:00:02.0: reg 30: [mem 0xfebe0000-0xfebeffff pref]
[    6.871553] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    6.877211] pci 0000:00:03.0: reg 10: [mem 0xfeba0000-0xfebbffff]
[    6.881976] pci 0000:00:03.0: reg 14: [io  0xc000-0xc03f]
[    6.907018] pci 0000:00:03.0: reg 30: [mem 0xfebc0000-0xfebdffff pref]
[    6.914070] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    6.918284] pci 0000:00:04.0: reg 10: [io  0xc040-0xc07f]
[    6.924622] pci 0000:00:04.0: reg 14: [mem 0xfebf1000-0xfebf1fff]
[    6.953948] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    6.958215] pci 0000:00:05.0: reg 10: [io  0xc080-0xc0bf]
[    6.963878] pci 0000:00:05.0: reg 14: [mem 0xfebf2000-0xfebf2fff]
[    6.991044] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    6.994873] pci 0000:00:06.0: reg 10: [io  0xc0c0-0xc0ff]
[    7.003810] pci 0000:00:06.0: reg 14: [mem 0xfebf3000-0xfebf3fff]
[    7.027158] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    7.030572] pci 0000:00:07.0: reg 10: [io  0xc100-0xc13f]
[    7.040521] pci 0000:00:07.0: reg 14: [mem 0xfebf4000-0xfebf4fff]
[    7.061775] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    7.067197] pci 0000:00:08.0: reg 10: [io  0xc140-0xc17f]
[    7.071402] pci 0000:00:08.0: reg 14: [mem 0xfebf5000-0xfebf5fff]
[    7.094455] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    7.103720] pci 0000:00:09.0: reg 10: [io  0xc180-0xc1bf]
[    7.108058] pci 0000:00:09.0: reg 14: [mem 0xfebf6000-0xfebf6fff]
[    7.137065] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    7.143942] pci 0000:00:0a.0: reg 10: [mem 0xfebf7000-0xfebf700f]
[    7.170715] pci_bus 0000:00: on NUMA node 0
[    7.172509] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    7.484920]  pci0000:00: ACPI _OSC support notification failed, disablin=
g PCIe ASPM
[    7.490269]  pci0000:00: Unable to request _OSC control (_OSC support ma=
sk: 0x08)
[    7.493586] device: '0000:00:00.0': device_add
[    7.785005] bus: 'pci': add device 0000:00:00.0
[    7.795030] PM: Adding info for pci:0000:00:00.0
[    7.803784] device: '0000:00:01.0': device_add
[    8.091161] bus: 'pci': add device 0000:00:01.0
[    8.098336] PM: Adding info for pci:0000:00:01.0
[    8.101114] device: '0000:00:01.1': device_add
[    8.391257] bus: 'pci': add device 0000:00:01.1
[    8.398506] PM: Adding info for pci:0000:00:01.1
[    8.401046] device: '0000:00:01.3': device_add
[    8.693734] bus: 'pci': add device 0000:00:01.3
[    8.703777] PM: Adding info for pci:0000:00:01.3
[    8.710071] device: '0000:00:02.0': device_add
[    9.000036] bus: 'pci': add device 0000:00:02.0
[    9.015665] PM: Adding info for pci:0000:00:02.0
[    9.017710] device: '0000:00:03.0': device_add
[    9.311140] bus: 'pci': add device 0000:00:03.0
[    9.320740] PM: Adding info for pci:0000:00:03.0
[    9.324328] device: '0000:00:04.0': device_add
[    9.624928] bus: 'pci': add device 0000:00:04.0
[    9.631334] PM: Adding info for pci:0000:00:04.0
[    9.636881] device: '0000:00:05.0': device_add
[    9.933304] bus: 'pci': add device 0000:00:05.0
[    9.940548] PM: Adding info for pci:0000:00:05.0
[    9.944282] device: '0000:00:06.0': device_add
[   10.273264] bus: 'pci': add device 0000:00:06.0
[   10.280373] PM: Adding info for pci:0000:00:06.0
[   10.284268] device: '0000:00:07.0': device_add
[   10.581809] bus: 'pci': add device 0000:00:07.0
[   10.590126] PM: Adding info for pci:0000:00:07.0
[   10.594269] device: '0000:00:08.0': device_add
[   10.881121] bus: 'pci': add device 0000:00:08.0
[   10.890581] PM: Adding info for pci:0000:00:08.0
[   10.893706] device: '0000:00:09.0': device_add
[   11.174654] bus: 'pci': add device 0000:00:09.0
[   11.187394] PM: Adding info for pci:0000:00:09.0
[   11.190695] device: '0000:00:0a.0': device_add
[   11.471022] bus: 'pci': add device 0000:00:0a.0
[   11.479992] PM: Adding info for pci:0000:00:0a.0
[   11.486701] driver: 'PNP0A03:00': driver_bound: bound to device 'pci_roo=
t'
[   11.487914] bus: 'acpi': really_probe: bound device PNP0A03:00 to driver=
 pci_root
[   11.496767] bus: 'acpi': add driver pci_link
[   11.501064] bus: 'acpi': driver_probe_device: matched device PNP0C0F:00 =
with driver pci_link
[   11.503143] bus: 'acpi': really_probe: probing driver pci_link with devi=
ce PNP0C0F:00
[   11.560830] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[   11.577385] driver: 'PNP0C0F:00': driver_bound: bound to device 'pci_lin=
k'
[   11.578878] bus: 'acpi': really_probe: bound device PNP0C0F:00 to driver=
 pci_link
[   11.580086] bus: 'acpi': driver_probe_device: matched device PNP0C0F:01 =
with driver pci_link
[   11.583092] bus: 'acpi': really_probe: probing driver pci_link with devi=
ce PNP0C0F:01
[   11.604333] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[   11.614809] driver: 'PNP0C0F:01': driver_bound: bound to device 'pci_lin=
k'
[   11.619929] bus: 'acpi': really_probe: bound device PNP0C0F:01 to driver=
 pci_link
[   11.621251] bus: 'acpi': driver_probe_device: matched device PNP0C0F:02 =
with driver pci_link
[   11.623127] bus: 'acpi': really_probe: probing driver pci_link with devi=
ce PNP0C0F:02
[   11.649245] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[   11.660281] driver: 'PNP0C0F:02': driver_bound: bound to device 'pci_lin=
k'
[   11.663296] bus: 'acpi': really_probe: bound device PNP0C0F:02 to driver=
 pci_link
[   11.666813] bus: 'acpi': driver_probe_device: matched device PNP0C0F:03 =
with driver pci_link
[   11.667986] bus: 'acpi': really_probe: probing driver pci_link with devi=
ce PNP0C0F:03
[   11.693442] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[   11.703536] driver: 'PNP0C0F:03': driver_bound: bound to device 'pci_lin=
k'
[   11.704788] bus: 'acpi': really_probe: bound device PNP0C0F:03 to driver=
 pci_link
[   11.706789] bus: 'acpi': driver_probe_device: matched device PNP0C0F:04 =
with driver pci_link
[   11.709783] bus: 'acpi': really_probe: probing driver pci_link with devi=
ce PNP0C0F:04
[   11.728268] ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0
[   11.743387] driver: 'PNP0C0F:04': driver_bound: bound to device 'pci_lin=
k'
[   11.744629] bus: 'acpi': really_probe: bound device PNP0C0F:04 to driver=
 pci_link
[   11.753669] bus: 'pnp': registered
[   11.754527] bus: 'platform': add driver reg-fixed-voltage
[   11.761027] bus: 'platform': add driver ab3100-regulators
[   11.764747] bus: 'i2c': add driver ad5398
[   11.771346] bus: 'platform': add driver gpio-regulator
[   11.779779] bus: 'i2c': add driver max8660
[   11.783439] bus: 'platform': add driver max8925-regulator
[   11.789873] bus: 'i2c': add driver max8952
[   11.793804] bus: 'platform': add driver max8997-pmic
[   11.801136] bus: 'platform': add driver mc13783-regulator
[   11.804680] bus: 'platform': add driver mc13892-regulator
[   11.811354] bus: 'platform': add driver pcap-regulator
[   11.814734] bus: 'platform': add driver pcf50633-regltr
[   11.821234] bus: 'platform': add driver rc5t583-regulator
[   11.829849] bus: 'platform': add driver tps65090-regulator
[   11.834058] bus: 'platform': add driver tps65910-pmic
[   11.840894] bus: 'platform': add driver tps65912-pmic
[   11.844504] bus: 'platform': add driver wm831x-buckv
[   11.850883] bus: 'platform': add driver wm831x-buckp
[   11.854569] bus: 'platform': add driver wm831x-boostp
[   11.861268] bus: 'platform': add driver wm831x-epe
[   11.866517] bus: 'platform': add driver wm831x-isink
[   11.873391] bus: 'platform': add driver wm831x-ldo
[   11.879924] bus: 'platform': add driver wm831x-aldo
[   11.883747] bus: 'platform': add driver wm831x-alive-ldo
[   11.891008] bus: 'platform': add driver wm8350-regulator
[   11.895896] device class 'misc': registering
[   11.910721] device: 'vga_arbiter': device_add
[   11.961803] PM: Adding info for No Bus:vga_arbiter
[   11.982557] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[   11.991517] vgaarb: loaded
[   11.993144] vgaarb: bridge control possible 0000:00:02.0
[   11.994192] bus: 'i2c': add driver stmpe-i2c
[   12.000405] bus: 'i2c': add driver WM8400
[   12.004234] bus: 'i2c': add driver wm831x
[   12.011453] bus: 'spi': add driver wm831x
[   12.014672] bus: 'i2c': add driver wm8350
[   12.021348] tps65010: version 2 May 2005
[   12.023228] bus: 'i2c': add driver tps65010
[   12.043270] bus: 'i2c': remove driver tps65010
[   12.050464] driver: 'tps65010': driver_release
[   12.070792] bus: 'i2c': add driver tps65010
[   12.077192] bus: 'i2c': remove driver tps65010
[   12.080150] driver: 'tps65010': driver_release
[   12.093607] bus: 'i2c': add driver tps65010
[   12.098111] bus: 'i2c': remove driver tps65010
[   12.100599] driver: 'tps65010': driver_release
[   12.103179] tps65010: no chip?
[   12.103996] bus: 'i2c': add driver tps65217
[   12.117687] bus: 'i2c': add driver tps65910
[   12.123392] bus: 'i2c': add driver tps65912
[   12.128361] bus: 'spi': add driver tps65912
[   12.133359] bus: 'i2c': add driver mc13xxx
[   12.140001] bus: 'spi': add driver ezx-pcap
[   12.147885] bus: 'spi': add driver da9052
[   12.151372] bus: 'i2c': add driver da9052
[   12.157828] bus: 'i2c': add driver max77693
[   12.161490] bus: 'i2c': add driver max8925
[   12.164759] bus: 'i2c': add driver max8997
[   12.169959] bus: 'i2c': add driver pcf50633
[   12.174787] bus: 'i2c': add driver ab3100
[   12.183106] bus: 'i2c': add driver tps6586x
[   12.186827] bus: 'i2c': add driver tps65090
[   12.190578] bus: 'i2c': add driver aat2870
[   12.195876] bus: 'i2c': add driver palmas
[   12.199904] bus: 'i2c': add driver rc5t583
[   12.203810] bus: 'i2c': add driver lm3533
[   12.216987] bus: 'serio': registered
[   12.221108] bus: 'gameport': registered
[   12.223262] device class 'input': registering
[   12.234233] device class 'rtc': registering
[   12.240074] bus: 'platform': add driver pxa2xx-i2c
[   12.244648] device class 'power_supply': registering
[   12.253789] device class 'hwmon': registering
[   12.257321] device class 'watchdog': registering
[   12.261016] device class 'sound': registering
[   12.264242] PCI: Using ACPI for IRQ routing
[   12.266987] PCI: pci_cache_line_size set to 64 bytes
[   12.290379] e820: reserve RAM buffer [mem 0x00093c00-0x0009ffff]
[   12.293388] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[   12.303928] device class 'net': registering
[   12.324407] device: 'lo': device_add
[   12.356582] PM: Adding info for No Bus:lo
[   12.450359] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[   12.453528] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[   12.463409] Switching to clocksource hpet
[   12.480094] CE: hpet increased min_delta_ns to 5000 nsec
[   12.480094] CE: hpet increased min_delta_ns to 7500 nsec
[   12.480094] CE: hpet increased min_delta_ns to 11250 nsec
[   12.480094] CE: hpet increased min_delta_ns to 16875 nsec
[   12.676235] Warning: could not register annotated branches stats
[   23.785980] bus: 'pnp': add driver system
[   23.789867] pnp: PnP ACPI init
[   23.790945] device: 'pnp0': device_add
[   23.829686] PM: Adding info for No Bus:pnp0
[   23.844696] ACPI: bus type pnp registered
[   23.878776] pnp 00:00: [bus 00-ff]
[   23.879931] pnp 00:00: [io  0x0cf8-0x0cff]
[   23.882413] pnp 00:00: [io  0x0000-0x0cf7 window]
[   23.883310] pnp 00:00: [io  0x0d00-0xffff window]
[   23.895441] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[   23.896438] pnp 00:00: [mem 0xe0000000-0xfebfffff window]
[   23.909608] device: '00:00': device_add
[   23.974150] bus: 'pnp': add device 00:00
[   23.995457] PM: Adding info for pnp:00:00
[   24.025309] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[   24.066075] pnp 00:01: [io  0x0070-0x0071]
[   24.069379] pnp 00:01: [irq 8]
[   24.072060] pnp 00:01: [io  0x0072-0x0077]
[   24.073232] device: '00:01': device_add
[   24.088681] bus: 'pnp': add device 00:01
[   24.102248] PM: Adding info for pnp:00:01
[   24.105385] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)
[   24.136507] pnp 00:02: [io  0x0060]
[   24.138881] pnp 00:02: [io  0x0064]
[   24.139644] pnp 00:02: [irq 1]
[   24.151656] device: '00:02': device_add
[   24.156276] bus: 'pnp': add device 00:02
[   24.169171] PM: Adding info for pnp:00:02
[   24.172288] pnp 00:02: Plug and Play ACPI device, IDs PNP0303 (active)
[   24.202872] pnp 00:03: [irq 12]
[   24.205354] device: '00:03': device_add
[   24.219667] bus: 'pnp': add device 00:03
[   24.223129] PM: Adding info for pnp:00:03
[   24.235608] pnp 00:03: Plug and Play ACPI device, IDs PNP0f13 (active)
[   24.268150] pnp 00:04: [io  0x03f2-0x03f5]
[   24.269018] pnp 00:04: [io  0x03f7]
[   24.276369] pnp 00:04: [irq 6]
[   24.279044] pnp 00:04: [dma 2]
[   24.281563] device: '00:04': device_add
[   24.296193] bus: 'pnp': add device 00:04
[   24.299646] PM: Adding info for pnp:00:04
[   24.311855] pnp 00:04: Plug and Play ACPI device, IDs PNP0700 (active)
[   24.348430] pnp 00:05: [io  0x0378-0x037f]
[   24.349291] pnp 00:05: [irq 7]
[   24.359401] device: '00:05': device_add
[   24.365692] bus: 'pnp': add device 00:05
[   24.378556] PM: Adding info for pnp:00:05
[   24.381634] pnp 00:05: Plug and Play ACPI device, IDs PNP0400 (active)
[   24.428076] pnp 00:06: [io  0x03f8-0x03ff]
[   24.428934] pnp 00:06: [irq 4]
[   24.429813] device: '00:06': device_add
[   24.446047] bus: 'pnp': add device 00:06
[   24.449907] PM: Adding info for pnp:00:06
[   24.462265] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[   24.611985] pnp 00:07: [mem 0xfed00000-0xfed003ff]
[   24.613180] device: '00:07': device_add
[   24.645446] bus: 'pnp': add device 00:07
[   24.658414] PM: Adding info for pnp:00:07
[   24.661605] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
[   24.770318] pnp: PnP ACPI: found 8 devices
[   24.772638] ACPI: ACPI bus type pnp unregistered
[   24.775523] device class 'mem': registering
[   24.788572] device: 'mem': device_add
[   24.809229] PM: Adding info for No Bus:mem
[   24.825920] device: 'null': device_add
[   24.854905] PM: Adding info for No Bus:null
[   24.858391] device: 'port': device_add
[   24.873214] PM: Adding info for No Bus:port
[   24.885646] device: 'zero': device_add
[   24.905572] PM: Adding info for No Bus:zero
[   24.915922] device: 'full': device_add
[   24.932573] PM: Adding info for No Bus:full
[   24.943013] device: 'random': device_add
[   24.968964] PM: Adding info for No Bus:random
[   24.972239] device: 'urandom': device_add
[   24.988868] PM: Adding info for No Bus:urandom
[   25.002169] device: 'kmsg': device_add
[   25.018871] PM: Adding info for No Bus:kmsg
[   25.029660] device: 'tty': device_add
[   25.046646] PM: Adding info for No Bus:tty
[   25.063085] device: 'console': device_add
[   25.079643] PM: Adding info for No Bus:console
[   25.090009] device class 'firmware': registering
[   25.101873] device class 'thermal': registering
[   25.185966] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[   25.188434] pci_bus 0000:00: resource 5 [mem 0x00000000-0xffffffff]
[   25.206144] NET: Registered protocol family 1
[   25.220290] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[   25.223346] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[   25.236255] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[   25.248664] pci 0000:00:02.0: Boot video device
[   25.265207] PCI: CLS 0 bytes, default 64
[   25.439279] Unpacking initramfs...
[   27.190714] hrtimer: interrupt took 16311296 ns
[  270.743640] debug: unmapping init [mem 0xce73f000-0xcffeffff]
[  271.883211] DMA-API: preallocated 32768 debug entries
[  271.885700] DMA-API: debugging enabled by kernel config
[  271.922449] device class 'msr': registering
[  271.926128] device: 'msr0': device_add
[  271.952411] PM: Adding info for No Bus:msr0
[  271.959058] device class 'cpuid': registering
[  271.962659] device: 'cpu0': device_add
[  271.972715] PM: Adding info for No Bus:cpu0
[  272.015832] NatSemi SCx200 Driver
[  272.016881] bus: 'pci': add driver scx200
[  272.021898] cryptomgr_test (13) used greatest stack depth: 7352 bytes le=
ft
[  272.031800] cryptomgr_test (14) used greatest stack depth: 7324 bytes le=
ft
[  272.083217] bus: 'clocksource': registered
[  272.085786] device: 'clocksource': device_add
[  272.088730] PM: Adding info for No Bus:clocksource
[  272.090207] device: 'clocksource0': device_add
[  272.092768] bus: 'clocksource': add device clocksource0
[  272.095798] PM: Adding info for clocksource:clocksource0
[  272.104955] bus: 'platform': add driver alarmtimer
[  272.109451] Registering platform device 'alarmtimer'. Parent at platform
[  272.111993] device: 'alarmtimer': device_add
[  272.113286] bus: 'platform': add device alarmtimer
[  272.116352] PM: Adding info for platform:alarmtimer
[  272.121809] bus: 'platform': driver_probe_device: matched device alarmti=
mer with driver alarmtimer
[  272.123015] bus: 'platform': really_probe: probing driver alarmtimer wit=
h device alarmtimer
[  272.126128] driver: 'alarmtimer': driver_bound: bound to device 'alarmti=
mer'
[  272.128770] bus: 'platform': really_probe: bound device alarmtimer to dr=
iver alarmtimer
[  272.228484] Testing tracer function: PASSED
[  272.421482] Testing tracer irqsoff: PASSED
[  272.509225] Testing tracer function_graph: [  273.128067] tsc: Refined T=
SC clocksource calibration: 2009.263 MHz
PASSED
[  273.275171] bus: 'event_source': registered
[  273.278646] device: 'breakpoint': device_add
[  273.281839] bus: 'event_source': add device breakpoint
[  273.286167] PM: Adding info for event_source:breakpoint
[  273.293076] device: 'tracepoint': device_add
[  273.295897] bus: 'event_source': add device tracepoint
[  273.299077] PM: Adding info for event_source:tracepoint
[  273.302588] device: 'software': device_add
[  273.305328] bus: 'event_source': add device software
[  273.308577] PM: Adding info for event_source:software
[  273.339402] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[  273.405826] Switching to clocksource tsc
[  274.172308] VFS: Disk quotas dquot_6.5.2
[  274.189028] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[  274.268595] jffs2: version 2.2.=20
[  274.309802] fuse init (API version 7.20)
[  274.342000] device: 'fuse': device_add
[  274.356179] PM: Adding info for No Bus:fuse
[  274.653323] cryptomgr_test (34) used greatest stack depth: 7124 bytes le=
ft
[  274.829566] list_sort_test: start testing list_sort()
[  274.926839] crc32: CRC_LE_BITS =3D 8, CRC_BE BITS =3D 8
[  274.929211] crc32: self tests passed, processed 225944 bytes in 5701625 =
nsec
[  274.940207] crc32c: CRC_LE_BITS =3D 8
[  274.942271] crc32c: self tests passed, processed 225944 bytes in 2858245=
 nsec
[  274.945234] bus: 'i2c': add driver adp5588-gpio
[  274.949810] bus: 'pci': add driver langwell_gpio
[  274.959115] bus: 'platform': add driver wp_gpio
[  274.965349] bus: 'pci': add driver ml_ioh_gpio
[  274.972601] bus: 'pci': add driver sdv_gpio
[  275.012332] bus: 'pci_express': registered
[  275.015046] bus: 'pci': add driver pcieport
[  275.023288] device: 'aer_inject': device_add
[  275.036270] PM: Adding info for No Bus:aer_inject
[  275.039927] bus: 'pci': add driver pci-stub
[  275.051729] bus: 'acpi': add driver button
[  275.058422] bus: 'acpi': driver_probe_device: matched device LNXPWRBN:00=
 with driver button
[  275.059666] bus: 'acpi': really_probe: probing driver button with device=
 LNXPWRBN:00
[  275.069408] device: 'input0': device_add
[  275.082905] PM: Adding info for No Bus:input0
[  275.098634] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[  275.106280] ACPI: Power Button [PWRF]
[  275.109986] driver: 'LNXPWRBN:00': driver_bound: bound to device 'button'
[  275.113016] bus: 'acpi': really_probe: bound device LNXPWRBN:00 to drive=
r button
[  275.118776] bus: 'acpi': add driver fan
[  275.138707] bus: 'acpi': add driver smbus_hc
[  275.149188] bus: 'acpi': add driver battery
[  275.168652] bus: 'acpi': add driver sbs
[  275.188933] ERST DBG: ERST support is disabled.
[  275.189949] bus: 'pci': add driver pch-dma
[  275.199533] bus: 'virtio': add driver virtio_balloon
[  275.205824] bus: 'platform': add driver reg-userspace-consumer
[  275.211849] bus: 'i2c': add driver LP3971
[  275.216568] bus: 'spi': add driver tps6524x
[  275.228943] device: 'ptyp0': device_add
[  275.239541] PM: Adding info for No Bus:ptyp0
[  275.245500] device: 'ptyp1': device_add
[  275.256180] PM: Adding info for No Bus:ptyp1
[  275.259856] device: 'ptyp2': device_add
[  275.271966] PM: Adding info for No Bus:ptyp2
[  275.275733] device: 'ptyp3': device_add
[  275.289111] PM: Adding info for No Bus:ptyp3
[  275.292781] device: 'ptyp4': device_add
[  275.303008] PM: Adding info for No Bus:ptyp4
[  275.306860] device: 'ptyp5': device_add
[  275.322301] PM: Adding info for No Bus:ptyp5
[  275.325930] device: 'ptyp6': device_add
[  275.336233] PM: Adding info for No Bus:ptyp6
[  275.339945] device: 'ptyp7': device_add
[  275.352470] PM: Adding info for No Bus:ptyp7
[  275.356098] device: 'ptyp8': device_add
[  275.368847] PM: Adding info for No Bus:ptyp8
[  275.372920] device: 'ptyp9': device_add
[  275.386278] PM: Adding info for No Bus:ptyp9
[  275.390246] device: 'ptypa': device_add
[  275.405787] PM: Adding info for No Bus:ptypa
[  275.409492] device: 'ptypb': device_add
[  275.422106] PM: Adding info for No Bus:ptypb
[  275.425890] device: 'ptypc': device_add
[  275.436219] PM: Adding info for No Bus:ptypc
[  275.439910] device: 'ptypd': device_add
[  275.452816] PM: Adding info for No Bus:ptypd
[  275.456534] device: 'ptype': device_add
[  275.468883] PM: Adding info for No Bus:ptype
[  275.472574] device: 'ptypf': device_add
[  275.485753] PM: Adding info for No Bus:ptypf
[  275.489362] device: 'ptyq0': device_add
[  275.502006] PM: Adding info for No Bus:ptyq0
[  275.506084] device: 'ptyq1': device_add
[  275.519274] PM: Adding info for No Bus:ptyq1
[  275.522986] device: 'ptyq2': device_add
[  275.539014] PM: Adding info for No Bus:ptyq2
[  275.542727] device: 'ptyq3': device_add
[  275.552996] PM: Adding info for No Bus:ptyq3
[  275.556903] device: 'ptyq4': device_add
[  275.569491] PM: Adding info for No Bus:ptyq4
[  275.573103] device: 'ptyq5': device_add
[  275.585588] PM: Adding info for No Bus:ptyq5
[  275.589260] device: 'ptyq6': device_add
[  275.602128] PM: Adding info for No Bus:ptyq6
[  275.606030] device: 'ptyq7': device_add
[  275.622551] PM: Adding info for No Bus:ptyq7
[  275.629193] device: 'ptyq8': device_add
[  275.640249] PM: Adding info for No Bus:ptyq8
[  275.648688] device: 'ptyq9': device_add
[  275.659388] PM: Adding info for No Bus:ptyq9
[  275.663058] device: 'ptyqa': device_add
[  275.675300] PM: Adding info for No Bus:ptyqa
[  275.679382] device: 'ptyqb': device_add
[  275.691777] PM: Adding info for No Bus:ptyqb
[  275.695561] device: 'ptyqc': device_add
[  275.706142] PM: Adding info for No Bus:ptyqc
[  275.709796] device: 'ptyqd': device_add
[  275.722050] PM: Adding info for No Bus:ptyqd
[  275.725774] device: 'ptyqe': device_add
[  275.739485] PM: Adding info for No Bus:ptyqe
[  275.743152] device: 'ptyqf': device_add
[  275.756267] PM: Adding info for No Bus:ptyqf
[  275.759956] device: 'ptyr0': device_add
[  275.776547] PM: Adding info for No Bus:ptyr0
[  275.782481] device: 'ptyr1': device_add
[  275.795601] PM: Adding info for No Bus:ptyr1
[  275.799293] device: 'ptyr2': device_add
[  275.809583] PM: Adding info for No Bus:ptyr2
[  275.813277] device: 'ptyr3': device_add
[  275.825691] PM: Adding info for No Bus:ptyr3
[  275.829327] device: 'ptyr4': device_add
[  275.842056] PM: Adding info for No Bus:ptyr4
[  275.845730] device: 'ptyr5': device_add
[  275.859683] PM: Adding info for No Bus:ptyr5
[  275.865694] device: 'ptyr6': device_add
[  275.879041] PM: Adding info for No Bus:ptyr6
[  275.882753] device: 'ptyr7': device_add
[  275.895960] PM: Adding info for No Bus:ptyr7
[  275.899578] device: 'ptyr8': device_add
[  275.912376] PM: Adding info for No Bus:ptyr8
[  275.916469] device: 'ptyr9': device_add
[  275.929110] PM: Adding info for No Bus:ptyr9
[  275.932822] device: 'ptyra': device_add
[  275.945502] PM: Adding info for No Bus:ptyra
[  275.949169] device: 'ptyrb': device_add
[  275.962018] PM: Adding info for No Bus:ptyrb
[  275.965715] device: 'ptyrc': device_add
[  275.976229] PM: Adding info for No Bus:ptyrc
[  275.979916] device: 'ptyrd': device_add
[  275.992346] PM: Adding info for No Bus:ptyrd
[  275.996060] device: 'ptyre': device_add
[  276.009189] PM: Adding info for No Bus:ptyre
[  276.012943] device: 'ptyrf': device_add
[  276.025411] PM: Adding info for No Bus:ptyrf
[  276.029173] device: 'ptys0': device_add
[  276.039653] PM: Adding info for No Bus:ptys0
[  276.045938] device: 'ptys1': device_add
[  276.058860] PM: Adding info for No Bus:ptys1
[  276.062578] device: 'ptys2': device_add
[  276.072909] PM: Adding info for No Bus:ptys2
[  276.076575] device: 'ptys3': device_add
[  276.093294] PM: Adding info for No Bus:ptys3
[  276.099237] device: 'ptys4': device_add
[  276.112283] PM: Adding info for No Bus:ptys4
[  276.115974] device: 'ptys5': device_add
[  276.126235] PM: Adding info for No Bus:ptys5
[  276.129938] device: 'ptys6': device_add
[  276.142957] PM: Adding info for No Bus:ptys6
[  276.146637] device: 'ptys7': device_add
[  276.159122] PM: Adding info for No Bus:ptys7
[  276.162795] device: 'ptys8': device_add
[  276.173016] PM: Adding info for No Bus:ptys8
[  276.179320] device: 'ptys9': device_add
[  276.189681] PM: Adding info for No Bus:ptys9
[  276.196025] device: 'ptysa': device_add
[  276.208942] PM: Adding info for No Bus:ptysa
[  276.212665] device: 'ptysb': device_add
[  276.222952] PM: Adding info for No Bus:ptysb
[  276.226605] device: 'ptysc': device_add
[  276.239277] PM: Adding info for No Bus:ptysc
[  276.242953] device: 'ptysd': device_add
[  276.255833] PM: Adding info for No Bus:ptysd
[  276.259538] device: 'ptyse': device_add
[  276.272274] PM: Adding info for No Bus:ptyse
[  276.276036] device: 'ptysf': device_add
[  276.289164] PM: Adding info for No Bus:ptysf
[  276.292914] device: 'ptyt0': device_add
[  276.306861] PM: Adding info for No Bus:ptyt0
[  276.312360] device: 'ptyt1': device_add
[  276.326596] PM: Adding info for No Bus:ptyt1
[  276.332503] device: 'ptyt2': device_add
[  276.342926] PM: Adding info for No Bus:ptyt2
[  276.346639] device: 'ptyt3': device_add
[  276.359079] PM: Adding info for No Bus:ptyt3
[  276.362741] device: 'ptyt4': device_add
[  276.373562] PM: Adding info for No Bus:ptyt4
[  276.379337] device: 'ptyt5': device_add
[  276.392123] PM: Adding info for No Bus:ptyt5
[  276.396065] device: 'ptyt6': device_add
[  276.408797] PM: Adding info for No Bus:ptyt6
[  276.412556] device: 'ptyt7': device_add
[  276.422914] PM: Adding info for No Bus:ptyt7
[  276.426613] device: 'ptyt8': device_add
[  276.439372] PM: Adding info for No Bus:ptyt8
[  276.443620] device: 'ptyt9': device_add
[  276.456004] PM: Adding info for No Bus:ptyt9
[  276.459695] device: 'ptyta': device_add
[  276.470219] PM: Adding info for No Bus:ptyta
[  276.475344] device: 'ptytb': device_add
[  276.486903] PM: Adding info for No Bus:ptytb
[  276.492193] device: 'ptytc': device_add
[  276.502952] PM: Adding info for No Bus:ptytc
[  276.506914] device: 'ptytd': device_add
[  276.519350] PM: Adding info for No Bus:ptytd
[  276.523013] device: 'ptyte': device_add
[  276.535333] PM: Adding info for No Bus:ptyte
[  276.539090] device: 'ptytf': device_add
[  276.552938] PM: Adding info for No Bus:ptytf
[  276.558967] device: 'ptyu0': device_add
[  276.569546] PM: Adding info for No Bus:ptyu0
[  276.575281] device: 'ptyu1': device_add
[  276.586269] PM: Adding info for No Bus:ptyu1
[  276.589955] device: 'ptyu2': device_add
[  276.602481] PM: Adding info for No Bus:ptyu2
[  276.606271] device: 'ptyu3': device_add
[  276.622468] PM: Adding info for No Bus:ptyu3
[  276.626126] device: 'ptyu4': device_add
[  276.638984] PM: Adding info for No Bus:ptyu4
[  276.642677] device: 'ptyu5': device_add
[  276.652920] PM: Adding info for No Bus:ptyu5
[  276.656572] device: 'ptyu6': device_add
[  276.669255] PM: Adding info for No Bus:ptyu6
[  276.672915] device: 'ptyu7': device_add
[  276.685597] PM: Adding info for No Bus:ptyu7
[  276.689242] device: 'ptyu8': device_add
[  276.702436] PM: Adding info for No Bus:ptyu8
[  276.706650] device: 'ptyu9': device_add
[  276.719205] PM: Adding info for No Bus:ptyu9
[  276.723318] device: 'ptyua': device_add
[  276.736363] PM: Adding info for No Bus:ptyua
[  276.740261] device: 'ptyub': device_add
[  276.752777] PM: Adding info for No Bus:ptyub
[  276.756602] device: 'ptyuc': device_add
[  276.769045] PM: Adding info for No Bus:ptyuc
[  276.772716] device: 'ptyud': device_add
[  276.786461] PM: Adding info for No Bus:ptyud
[  276.792360] device: 'ptyue': device_add
[  276.802867] PM: Adding info for No Bus:ptyue
[  276.806551] device: 'ptyuf': device_add
[  276.818945] PM: Adding info for No Bus:ptyuf
[  276.822650] device: 'ptyv0': device_add
[  276.832936] PM: Adding info for No Bus:ptyv0
[  276.838749] device: 'ptyv1': device_add
[  276.852563] PM: Adding info for No Bus:ptyv1
[  276.856319] device: 'ptyv2': device_add
[  276.868856] PM: Adding info for No Bus:ptyv2
[  276.872743] device: 'ptyv3': device_add
[  276.889171] PM: Adding info for No Bus:ptyv3
[  276.892965] device: 'ptyv4': device_add
[  276.905896] PM: Adding info for No Bus:ptyv4
[  276.909526] device: 'ptyv5': device_add
[  276.922321] PM: Adding info for No Bus:ptyv5
[  276.926008] device: 'ptyv6': device_add
[  276.936299] PM: Adding info for No Bus:ptyv6
[  276.940241] device: 'ptyv7': device_add
[  276.952467] PM: Adding info for No Bus:ptyv7
[  276.956161] device: 'ptyv8': device_add
[  276.968873] PM: Adding info for No Bus:ptyv8
[  276.972936] device: 'ptyv9': device_add
[  276.985987] PM: Adding info for No Bus:ptyv9
[  276.989697] device: 'ptyva': device_add
[  277.000265] PM: Adding info for No Bus:ptyva
[  277.005521] device: 'ptyvb': device_add
[  277.019538] PM: Adding info for No Bus:ptyvb
[  277.025482] device: 'ptyvc': device_add
[  277.036156] PM: Adding info for No Bus:ptyvc
[  277.039856] device: 'ptyvd': device_add
[  277.052236] PM: Adding info for No Bus:ptyvd
[  277.055935] device: 'ptyve': device_add
[  277.068974] PM: Adding info for No Bus:ptyve
[  277.072652] device: 'ptyvf': device_add
[  277.082938] PM: Adding info for No Bus:ptyvf
[  277.086614] device: 'ptyw0': device_add
[  277.099557] PM: Adding info for No Bus:ptyw0
[  277.105399] device: 'ptyw1': device_add
[  277.119170] PM: Adding info for No Bus:ptyw1
[  277.122918] device: 'ptyw2': device_add
[  277.135659] PM: Adding info for No Bus:ptyw2
[  277.139317] device: 'ptyw3': device_add
[  277.149578] PM: Adding info for No Bus:ptyw3
[  277.153295] device: 'ptyw4': device_add
[  277.168869] PM: Adding info for No Bus:ptyw4
[  277.172591] device: 'ptyw5': device_add
[  277.182960] PM: Adding info for No Bus:ptyw5
[  277.186891] device: 'ptyw6': device_add
[  277.199330] PM: Adding info for No Bus:ptyw6
[  277.203030] device: 'ptyw7': device_add
[  277.215767] PM: Adding info for No Bus:ptyw7
[  277.219424] device: 'ptyw8': device_add
[  277.230192] PM: Adding info for No Bus:ptyw8
[  277.235780] device: 'ptyw9': device_add
[  277.249740] PM: Adding info for No Bus:ptyw9
[  277.256109] device: 'ptywa': device_add
[  277.269010] PM: Adding info for No Bus:ptywa
[  277.272808] device: 'ptywb': device_add
[  277.285600] PM: Adding info for No Bus:ptywb
[  277.289215] device: 'ptywc': device_add
[  277.299567] PM: Adding info for No Bus:ptywc
[  277.303182] device: 'ptywd': device_add
[  277.315943] PM: Adding info for No Bus:ptywd
[  277.321892] device: 'ptywe': device_add
[  277.333265] PM: Adding info for No Bus:ptywe
[  277.338829] device: 'ptywf': device_add
[  277.349562] PM: Adding info for No Bus:ptywf
[  277.353184] device: 'ptyx0': device_add
[  277.365864] PM: Adding info for No Bus:ptyx0
[  277.369936] device: 'ptyx1': device_add
[  277.385695] PM: Adding info for No Bus:ptyx1
[  277.389348] device: 'ptyx2': device_add
[  277.402322] PM: Adding info for No Bus:ptyx2
[  277.406030] device: 'ptyx3': device_add
[  277.416254] PM: Adding info for No Bus:ptyx3
[  277.419955] device: 'ptyx4': device_add
[  277.432778] PM: Adding info for No Bus:ptyx4
[  277.436369] device: 'ptyx5': device_add
[  277.448696] PM: Adding info for No Bus:ptyx5
[  277.452365] device: 'ptyx6': device_add
[  277.465471] PM: Adding info for No Bus:ptyx6
[  277.469207] device: 'ptyx7': device_add
[  277.483065] PM: Adding info for No Bus:ptyx7
[  277.489221] device: 'ptyx8': device_add
[  277.499588] PM: Adding info for No Bus:ptyx8
[  277.505405] device: 'ptyx9': device_add
[  277.516206] PM: Adding info for No Bus:ptyx9
[  277.519936] device: 'ptyxa': device_add
[  277.532771] PM: Adding info for No Bus:ptyxa
[  277.536395] device: 'ptyxb': device_add
[  277.548760] PM: Adding info for No Bus:ptyxb
[  277.552499] device: 'ptyxc': device_add
[  277.562978] PM: Adding info for No Bus:ptyxc
[  277.566882] device: 'ptyxd': device_add
[  277.582512] PM: Adding info for No Bus:ptyxd
[  277.586212] device: 'ptyxe': device_add
[  277.598922] PM: Adding info for No Bus:ptyxe
[  277.602644] device: 'ptyxf': device_add
[  277.615468] PM: Adding info for No Bus:ptyxf
[  277.619119] device: 'ptyy0': device_add
[  277.632017] PM: Adding info for No Bus:ptyy0
[  277.636063] device: 'ptyy1': device_add
[  277.648430] PM: Adding info for No Bus:ptyy1
[  277.652222] device: 'ptyy2': device_add
[  277.662852] PM: Adding info for No Bus:ptyy2
[  277.666527] device: 'ptyy3': device_add
[  277.678940] PM: Adding info for No Bus:ptyy3
[  277.682592] device: 'ptyy4': device_add
[  277.695883] PM: Adding info for No Bus:ptyy4
[  277.699804] device: 'ptyy5': device_add
[  277.715627] PM: Adding info for No Bus:ptyy5
[  277.719871] device: 'ptyy6': device_add
[  277.732158] PM: Adding info for No Bus:ptyy6
[  277.735929] device: 'ptyy7': device_add
[  277.748830] PM: Adding info for No Bus:ptyy7
[  277.752518] device: 'ptyy8': device_add
[  277.765647] PM: Adding info for No Bus:ptyy8
[  277.769665] device: 'ptyy9': device_add
[  277.782375] PM: Adding info for No Bus:ptyy9
[  277.786493] device: 'ptyya': device_add
[  277.802359] PM: Adding info for No Bus:ptyya
[  277.806065] device: 'ptyyb': device_add
[  277.818772] PM: Adding info for No Bus:ptyyb
[  277.822517] device: 'ptyyc': device_add
[  277.835771] PM: Adding info for No Bus:ptyyc
[  277.839490] device: 'ptyyd': device_add
[  277.852143] PM: Adding info for No Bus:ptyyd
[  277.855839] device: 'ptyye': device_add
[  277.868766] PM: Adding info for No Bus:ptyye
[  277.872498] device: 'ptyyf': device_add
[  277.882886] PM: Adding info for No Bus:ptyyf
[  277.886535] device: 'ptyz0': device_add
[  277.899062] PM: Adding info for No Bus:ptyz0
[  277.903118] device: 'ptyz1': device_add
[  277.915925] PM: Adding info for No Bus:ptyz1
[  277.919570] device: 'ptyz2': device_add
[  277.932369] PM: Adding info for No Bus:ptyz2
[  277.936036] device: 'ptyz3': device_add
[  277.952514] PM: Adding info for No Bus:ptyz3
[  277.958328] device: 'ptyz4': device_add
[  277.969138] PM: Adding info for No Bus:ptyz4
[  277.972848] device: 'ptyz5': device_add
[  277.985608] PM: Adding info for No Bus:ptyz5
[  277.989227] device: 'ptyz6': device_add
[  277.999580] PM: Adding info for No Bus:ptyz6
[  278.003307] device: 'ptyz7': device_add
[  278.016294] PM: Adding info for No Bus:ptyz7
[  278.019967] device: 'ptyz8': device_add
[  278.032488] PM: Adding info for No Bus:ptyz8
[  278.036583] device: 'ptyz9': device_add
[  278.049206] PM: Adding info for No Bus:ptyz9
[  278.052930] device: 'ptyza': device_add
[  278.065651] PM: Adding info for No Bus:ptyza
[  278.069345] device: 'ptyzb': device_add
[  278.082373] PM: Adding info for No Bus:ptyzb
[  278.086068] device: 'ptyzc': device_add
[  278.099807] PM: Adding info for No Bus:ptyzc
[  278.105097] device: 'ptyzd': device_add
[  278.116603] PM: Adding info for No Bus:ptyzd
[  278.122384] device: 'ptyze': device_add
[  278.135416] PM: Adding info for No Bus:ptyze
[  278.139206] device: 'ptyzf': device_add
[  278.149593] PM: Adding info for No Bus:ptyzf
[  278.153248] device: 'ptya0': device_add
[  278.165628] PM: Adding info for No Bus:ptya0
[  278.169695] device: 'ptya1': device_add
[  278.186098] PM: Adding info for No Bus:ptya1
[  278.192156] device: 'ptya2': device_add
[  278.202862] PM: Adding info for No Bus:ptya2
[  278.206493] device: 'ptya3': device_add
[  278.222233] PM: Adding info for No Bus:ptya3
[  278.225918] device: 'ptya4': device_add
[  278.238840] PM: Adding info for No Bus:ptya4
[  278.242572] device: 'ptya5': device_add
[  278.252936] PM: Adding info for No Bus:ptya5
[  278.256593] device: 'ptya6': device_add
[  278.269127] PM: Adding info for No Bus:ptya6
[  278.272821] device: 'ptya7': device_add
[  278.285617] PM: Adding info for No Bus:ptya7
[  278.289239] device: 'ptya8': device_add
[  278.302030] PM: Adding info for No Bus:ptya8
[  278.306350] device: 'ptya9': device_add
[  278.319426] PM: Adding info for No Bus:ptya9
[  278.323151] device: 'ptyaa': device_add
[  278.335574] PM: Adding info for No Bus:ptyaa
[  278.339295] device: 'ptyab': device_add
[  278.349571] PM: Adding info for No Bus:ptyab
[  278.353259] device: 'ptyac': device_add
[  278.366408] PM: Adding info for No Bus:ptyac
[  278.372267] device: 'ptyad': device_add
[  278.382781] PM: Adding info for No Bus:ptyad
[  278.386472] device: 'ptyae': device_add
[  278.398921] PM: Adding info for No Bus:ptyae
[  278.402629] device: 'ptyaf': device_add
[  278.416502] PM: Adding info for No Bus:ptyaf
[  278.422342] device: 'ptyb0': device_add
[  278.435747] PM: Adding info for No Bus:ptyb0
[  278.439794] device: 'ptyb1': device_add
[  278.452563] PM: Adding info for No Bus:ptyb1
[  278.456235] device: 'ptyb2': device_add
[  278.468924] PM: Adding info for No Bus:ptyb2
[  278.472565] device: 'ptyb3': device_add
[  278.482883] PM: Adding info for No Bus:ptyb3
[  278.486594] device: 'ptyb4': device_add
[  278.499284] PM: Adding info for No Bus:ptyb4
[  278.502936] device: 'ptyb5': device_add
[  278.522256] PM: Adding info for No Bus:ptyb5
[  278.525959] device: 'ptyb6': device_add
[  278.536258] PM: Adding info for No Bus:ptyb6
[  278.539910] device: 'ptyb7': device_add
[  278.553127] PM: Adding info for No Bus:ptyb7
[  278.558525] device: 'ptyb8': device_add
[  278.569360] PM: Adding info for No Bus:ptyb8
[  278.575082] device: 'ptyb9': device_add
[  278.586040] PM: Adding info for No Bus:ptyb9
[  278.589733] device: 'ptyba': device_add
[  278.602471] PM: Adding info for No Bus:ptyba
[  278.606157] device: 'ptybb': device_add
[  278.619182] PM: Adding info for No Bus:ptybb
[  278.622965] device: 'ptybc': device_add
[  278.635734] PM: Adding info for No Bus:ptybc
[  278.639476] device: 'ptybd': device_add
[  278.652846] PM: Adding info for No Bus:ptybd
[  278.656516] device: 'ptybe': device_add
[  278.668912] PM: Adding info for No Bus:ptybe
[  278.672642] device: 'ptybf': device_add
[  278.685753] PM: Adding info for No Bus:ptybf
[  278.689386] device: 'ptyc0': device_add
[  278.702431] PM: Adding info for No Bus:ptyc0
[  278.706491] device: 'ptyc1': device_add
[  278.719205] PM: Adding info for No Bus:ptyc1
[  278.722925] device: 'ptyc2': device_add
[  278.735426] PM: Adding info for No Bus:ptyc2
[  278.739139] device: 'ptyc3': device_add
[  278.749620] PM: Adding info for No Bus:ptyc3
[  278.753553] device: 'ptyc4': device_add
[  278.766387] PM: Adding info for No Bus:ptyc4
[  278.770228] device: 'ptyc5': device_add
[  278.783042] PM: Adding info for No Bus:ptyc5
[  278.788328] device: 'ptyc6': device_add
[  278.799586] PM: Adding info for No Bus:ptyc6
[  278.803302] device: 'ptyc7': device_add
[  278.816006] PM: Adding info for No Bus:ptyc7
[  278.819642] device: 'ptyc8': device_add
[  278.832877] PM: Adding info for No Bus:ptyc8
[  278.838803] device: 'ptyc9': device_add
[  278.852900] PM: Adding info for No Bus:ptyc9
[  278.856598] device: 'ptyca': device_add
[  278.869084] PM: Adding info for No Bus:ptyca
[  278.872701] device: 'ptycb': device_add
[  278.886601] PM: Adding info for No Bus:ptycb
[  278.892496] device: 'ptycc': device_add
[  278.905596] PM: Adding info for No Bus:ptycc
[  278.909272] device: 'ptycd': device_add
[  278.919977] PM: Adding info for No Bus:ptycd
[  278.925999] device: 'ptyce': device_add
[  278.936316] PM: Adding info for No Bus:ptyce
[  278.940228] device: 'ptycf': device_add
[  278.952751] PM: Adding info for No Bus:ptycf
[  278.956401] device: 'ptyd0': device_add
[  278.968762] PM: Adding info for No Bus:ptyd0
[  278.972833] device: 'ptyd1': device_add
[  278.985691] PM: Adding info for No Bus:ptyd1
[  278.989354] device: 'ptyd2': device_add
[  279.002356] PM: Adding info for No Bus:ptyd2
[  279.006007] device: 'ptyd3': device_add
[  279.016262] PM: Adding info for No Bus:ptyd3
[  279.019958] device: 'ptyd4': device_add
[  279.036126] PM: Adding info for No Bus:ptyd4
[  279.039933] device: 'ptyd5': device_add
[  279.052540] PM: Adding info for No Bus:ptyd5
[  279.056146] device: 'ptyd6': device_add
[  279.068853] PM: Adding info for No Bus:ptyd6
[  279.072620] device: 'ptyd7': device_add
[  279.082940] PM: Adding info for No Bus:ptyd7
[  279.086610] device: 'ptyd8': device_add
[  279.099089] PM: Adding info for No Bus:ptyd8
[  279.103217] device: 'ptyd9': device_add
[  279.119272] PM: Adding info for No Bus:ptyd9
[  279.125181] device: 'ptyda': device_add
[  279.135913] PM: Adding info for No Bus:ptyda
[  279.139529] device: 'ptydb': device_add
[  279.152303] PM: Adding info for No Bus:ptydb
[  279.156022] device: 'ptydc': device_add
[  279.173587] PM: Adding info for No Bus:ptydc
[  279.178855] device: 'ptydd': device_add
[  279.189525] PM: Adding info for No Bus:ptydd
[  279.193299] device: 'ptyde': device_add
[  279.206288] PM: Adding info for No Bus:ptyde
[  279.210198] device: 'ptydf': device_add
[  279.222516] PM: Adding info for No Bus:ptydf
[  279.226178] device: 'ptye0': device_add
[  279.238785] PM: Adding info for No Bus:ptye0
[  279.242903] device: 'ptye1': device_add
[  279.255617] PM: Adding info for No Bus:ptye1
[  279.259268] device: 'ptye2': device_add
[  279.272115] PM: Adding info for No Bus:ptye2
[  279.275960] device: 'ptye3': device_add
[  279.288984] PM: Adding info for No Bus:ptye3
[  279.292650] device: 'ptye4': device_add
[  279.305567] PM: Adding info for No Bus:ptye4
[  279.309249] device: 'ptye5': device_add
[  279.322189] PM: Adding info for No Bus:ptye5
[  279.325991] device: 'ptye6': device_add
[  279.338865] PM: Adding info for No Bus:ptye6
[  279.342520] device: 'ptye7': device_add
[  279.356424] PM: Adding info for No Bus:ptye7
[  279.362487] device: 'ptye8': device_add
[  279.372912] PM: Adding info for No Bus:ptye8
[  279.378799] device: 'ptye9': device_add
[  279.389551] PM: Adding info for No Bus:ptye9
[  279.393272] device: 'ptyea': device_add
[  279.406425] PM: Adding info for No Bus:ptyea
[  279.411895] device: 'ptyeb': device_add
[  279.422756] PM: Adding info for No Bus:ptyeb
[  279.426370] device: 'ptyec': device_add
[  279.439041] PM: Adding info for No Bus:ptyec
[  279.442872] device: 'ptyed': device_add
[  279.458990] PM: Adding info for No Bus:ptyed
[  279.462704] device: 'ptyee': device_add
[  279.472936] PM: Adding info for No Bus:ptyee
[  279.476731] device: 'ptyef': device_add
[  279.492261] PM: Adding info for No Bus:ptyef
[  279.496652] device: 'ttyp0': device_add
[  279.509115] PM: Adding info for No Bus:ttyp0
[  279.513224] device: 'ttyp1': device_add
[  279.525941] PM: Adding info for No Bus:ttyp1
[  279.529574] device: 'ttyp2': device_add
[  279.542550] PM: Adding info for No Bus:ttyp2
[  279.546265] device: 'ttyp3': device_add
[  279.558954] PM: Adding info for No Bus:ttyp3
[  279.562662] device: 'ttyp4': device_add
[  279.575698] PM: Adding info for No Bus:ttyp4
[  279.579353] device: 'ttyp5': device_add
[  279.593030] PM: Adding info for No Bus:ttyp5
[  279.599069] device: 'ttyp6': device_add
[  279.609606] PM: Adding info for No Bus:ttyp6
[  279.613245] device: 'ttyp7': device_add
[  279.629032] PM: Adding info for No Bus:ttyp7
[  279.632679] device: 'ttyp8': device_add
[  279.645714] PM: Adding info for No Bus:ttyp8
[  279.649741] device: 'ttyp9': device_add
[  279.662875] PM: Adding info for No Bus:ttyp9
[  279.666598] device: 'ttypa': device_add
[  279.679049] PM: Adding info for No Bus:ttypa
[  279.682679] device: 'ttypb': device_add
[  279.695495] PM: Adding info for No Bus:ttypb
[  279.699183] device: 'ttypc': device_add
[  279.712965] PM: Adding info for No Bus:ttypc
[  279.716645] device: 'ttypd': device_add
[  279.729140] PM: Adding info for No Bus:ttypd
[  279.732828] device: 'ttype': device_add
[  279.745346] PM: Adding info for No Bus:ttype
[  279.749053] device: 'ttypf': device_add
[  279.762854] PM: Adding info for No Bus:ttypf
[  279.766637] device: 'ttyq0': device_add
[  279.779704] PM: Adding info for No Bus:ttyq0
[  279.785612] device: 'ttyq1': device_add
[  279.796321] PM: Adding info for No Bus:ttyq1
[  279.800260] device: 'ttyq2': device_add
[  279.812773] PM: Adding info for No Bus:ttyq2
[  279.816469] device: 'ttyq3': device_add
[  279.829514] PM: Adding info for No Bus:ttyq3
[  279.833312] device: 'ttyq4': device_add
[  279.845871] PM: Adding info for No Bus:ttyq4
[  279.849533] device: 'ttyq5': device_add
[  279.862159] PM: Adding info for No Bus:ttyq5
[  279.865889] device: 'ttyq6': device_add
[  279.878875] PM: Adding info for No Bus:ttyq6
[  279.882581] device: 'ttyq7': device_add
[  279.893583] PM: Adding info for No Bus:ttyq7
[  279.899685] device: 'ttyq8': device_add
[  279.911842] PM: Adding info for No Bus:ttyq8
[  279.916172] device: 'ttyq9': device_add
[  279.928689] PM: Adding info for No Bus:ttyq9
[  279.932415] device: 'ttyqa': device_add
[  279.942915] PM: Adding info for No Bus:ttyqa
[  279.946621] device: 'ttyqb': device_add
[  279.959042] PM: Adding info for No Bus:ttyqb
[  279.962714] device: 'ttyqc': device_add
[  279.972927] PM: Adding info for No Bus:ttyqc
[  279.976633] device: 'ttyqd': device_add
[  279.989337] PM: Adding info for No Bus:ttyqd
[  279.993005] device: 'ttyqe': device_add
[  280.003607] PM: Adding info for No Bus:ttyqe
[  280.008747] device: 'ttyqf': device_add
[  280.022788] PM: Adding info for No Bus:ttyqf
[  280.026925] device: 'ttyr0': device_add
[  280.042869] PM: Adding info for No Bus:ttyr0
[  280.049399] device: 'ttyr1': device_add
[  280.063591] PM: Adding info for No Bus:ttyr1
[  280.069264] device: 'ttyr2': device_add
[  280.082989] PM: Adding info for No Bus:ttyr2
[  280.086923] device: 'ttyr3': device_add
[  280.099151] PM: Adding info for No Bus:ttyr3
[  280.102784] device: 'ttyr4': device_add
[  280.115740] PM: Adding info for No Bus:ttyr4
[  280.119378] device: 'ttyr5': device_add
[  280.132042] PM: Adding info for No Bus:ttyr5
[  280.135808] device: 'ttyr6': device_add
[  280.148757] PM: Adding info for No Bus:ttyr6
[  280.152425] device: 'ttyr7': device_add
[  280.162962] PM: Adding info for No Bus:ttyr7
[  280.166639] device: 'ttyr8': device_add
[  280.179180] PM: Adding info for No Bus:ttyr8
[  280.183232] device: 'ttyr9': device_add
[  280.199007] PM: Adding info for No Bus:ttyr9
[  280.202732] device: 'ttyra': device_add
[  280.212942] PM: Adding info for No Bus:ttyra
[  280.216596] device: 'ttyrb': device_add
[  280.229249] PM: Adding info for No Bus:ttyrb
[  280.232938] device: 'ttyrc': device_add
[  280.245606] PM: Adding info for No Bus:ttyrc
[  280.249258] device: 'ttyrd': device_add
[  280.262812] PM: Adding info for No Bus:ttyrd
[  280.266624] device: 'ttyre': device_add
[  280.279175] PM: Adding info for No Bus:ttyre
[  280.282855] device: 'ttyrf': device_add
[  280.296562] PM: Adding info for No Bus:ttyrf
[  280.302402] device: 'ttys0': device_add
[  280.312871] PM: Adding info for No Bus:ttys0
[  280.318692] device: 'ttys1': device_add
[  280.329523] PM: Adding info for No Bus:ttys1
[  280.333210] device: 'ttys2': device_add
[  280.345760] PM: Adding info for No Bus:ttys2
[  280.349349] device: 'ttys3': device_add
[  280.362308] PM: Adding info for No Bus:ttys3
[  280.366010] device: 'ttys4': device_add
[  280.376281] PM: Adding info for No Bus:ttys4
[  280.379986] device: 'ttys5': device_add
[  280.392963] PM: Adding info for No Bus:ttys5
[  280.402321] device: 'ttys6': device_add
[  280.413045] PM: Adding info for No Bus:ttys6
[  280.418345] device: 'ttys7': device_add
[  280.429183] PM: Adding info for No Bus:ttys7
[  280.432833] device: 'ttys8': device_add
[  280.445582] PM: Adding info for No Bus:ttys8
[  280.449761] device: 'ttys9': device_add
[  280.465746] PM: Adding info for No Bus:ttys9
[  280.469491] device: 'ttysa': device_add
[  280.482731] PM: Adding info for No Bus:ttysa
[  280.486323] device: 'ttysb': device_add
[  280.499324] PM: Adding info for No Bus:ttysb
[  280.503006] device: 'ttysc': device_add
[  280.515935] PM: Adding info for No Bus:ttysc
[  280.519630] device: 'ttysd': device_add
[  280.533646] PM: Adding info for No Bus:ttysd
[  280.539370] device: 'ttyse': device_add
[  280.552157] PM: Adding info for No Bus:ttyse
[  280.556313] device: 'ttysf': device_add
[  280.568647] PM: Adding info for No Bus:ttysf
[  280.572339] device: 'ttyt0': device_add
[  280.582928] PM: Adding info for No Bus:ttyt0
[  280.588688] device: 'ttyt1': device_add
[  280.602859] PM: Adding info for No Bus:ttyt1
[  280.606506] device: 'ttyt2': device_add
[  280.619151] PM: Adding info for No Bus:ttyt2
[  280.622916] device: 'ttyt3': device_add
[  280.635992] PM: Adding info for No Bus:ttyt3
[  280.639635] device: 'ttyt4': device_add
[  280.652110] PM: Adding info for No Bus:ttyt4
[  280.655878] device: 'ttyt5': device_add
[  280.668793] PM: Adding info for No Bus:ttyt5
[  280.672612] device: 'ttyt6': device_add
[  280.682974] PM: Adding info for No Bus:ttyt6
[  280.688832] device: 'ttyt7': device_add
[  280.699482] PM: Adding info for No Bus:ttyt7
[  280.703158] device: 'ttyt8': device_add
[  280.718880] PM: Adding info for No Bus:ttyt8
[  280.722979] device: 'ttyt9': device_add
[  280.735754] PM: Adding info for No Bus:ttyt9
[  280.739343] device: 'ttyta': device_add
[  280.753242] PM: Adding info for No Bus:ttyta
[  280.758862] device: 'ttytb': device_add
[  280.772977] PM: Adding info for No Bus:ttytb
[  280.778993] device: 'ttytc': device_add
[  280.789512] PM: Adding info for No Bus:ttytc
[  280.793129] device: 'ttytd': device_add
[  280.805495] PM: Adding info for No Bus:ttytd
[  280.809200] device: 'ttyte': device_add
[  280.822023] PM: Adding info for No Bus:ttyte
[  280.825736] device: 'ttytf': device_add
[  280.836237] PM: Adding info for No Bus:ttytf
[  280.839926] device: 'ttyu0': device_add
[  280.852209] PM: Adding info for No Bus:ttyu0
[  280.856245] device: 'ttyu1': device_add
[  280.869005] PM: Adding info for No Bus:ttyu1
[  280.872656] device: 'ttyu2': device_add
[  280.885969] PM: Adding info for No Bus:ttyu2
[  280.889664] device: 'ttyu3': device_add
[  280.902780] PM: Adding info for No Bus:ttyu3
[  280.906473] device: 'ttyu4': device_add
[  280.918788] PM: Adding info for No Bus:ttyu4
[  280.922541] device: 'ttyu5': device_add
[  280.932930] PM: Adding info for No Bus:ttyu5
[  280.936584] device: 'ttyu6': device_add
[  280.949281] PM: Adding info for No Bus:ttyu6
[  280.952993] device: 'ttyu7': device_add
[  280.965674] PM: Adding info for No Bus:ttyu7
[  280.969743] device: 'ttyu8': device_add
[  280.982429] PM: Adding info for No Bus:ttyu8
[  280.986483] device: 'ttyu9': device_add
[  281.002905] PM: Adding info for No Bus:ttyu9
[  281.008816] device: 'ttyua': device_add
[  281.019383] PM: Adding info for No Bus:ttyua
[  281.023107] device: 'ttyub': device_add
[  281.035360] PM: Adding info for No Bus:ttyub
[  281.039037] device: 'ttyuc': device_add
[  281.052919] PM: Adding info for No Bus:ttyuc
[  281.056612] device: 'ttyud': device_add
[  281.069284] PM: Adding info for No Bus:ttyud
[  281.072959] device: 'ttyue': device_add
[  281.085695] PM: Adding info for No Bus:ttyue
[  281.089286] device: 'ttyuf': device_add
[  281.099588] PM: Adding info for No Bus:ttyuf
[  281.103293] device: 'ttyv0': device_add
[  281.116929] PM: Adding info for No Bus:ttyv0
[  281.122592] device: 'ttyv1': device_add
[  281.135800] PM: Adding info for No Bus:ttyv1
[  281.139422] device: 'ttyv2': device_add
[  281.153059] PM: Adding info for No Bus:ttyv2
[  281.158296] device: 'ttyv3': device_add
[  281.169194] PM: Adding info for No Bus:ttyv3
[  281.172810] device: 'ttyv4': device_add
[  281.185407] PM: Adding info for No Bus:ttyv4
[  281.189145] device: 'ttyv5': device_add
[  281.202037] PM: Adding info for No Bus:ttyv5
[  281.205821] device: 'ttyv6': device_add
[  281.216255] PM: Adding info for No Bus:ttyv6
[  281.220203] device: 'ttyv7': device_add
[  281.235964] PM: Adding info for No Bus:ttyv7
[  281.241748] device: 'ttyv8': device_add
[  281.252860] PM: Adding info for No Bus:ttyv8
[  281.258692] device: 'ttyv9': device_add
[  281.269591] PM: Adding info for No Bus:ttyv9
[  281.273220] device: 'ttyva': device_add
[  281.285769] PM: Adding info for No Bus:ttyva
[  281.289422] device: 'ttyvb': device_add
[  281.302535] PM: Adding info for No Bus:ttyvb
[  281.306188] device: 'ttyvc': device_add
[  281.318902] PM: Adding info for No Bus:ttyvc
[  281.322596] device: 'ttyvd': device_add
[  281.332956] PM: Adding info for No Bus:ttyvd
[  281.336625] device: 'ttyve': device_add
[  281.349266] PM: Adding info for No Bus:ttyve
[  281.352933] device: 'ttyvf': device_add
[  281.365842] PM: Adding info for No Bus:ttyvf
[  281.369537] device: 'ttyw0': device_add
[  281.383322] PM: Adding info for No Bus:ttyw0
[  281.389011] device: 'ttyw1': device_add
[  281.402336] PM: Adding info for No Bus:ttyw1
[  281.406039] device: 'ttyw2': device_add
[  281.416265] PM: Adding info for No Bus:ttyw2
[  281.419910] device: 'ttyw3': device_add
[  281.432580] PM: Adding info for No Bus:ttyw3
[  281.436210] device: 'ttyw4': device_add
[  281.448954] PM: Adding info for No Bus:ttyw4
[  281.452669] device: 'ttyw5': device_add
[  281.466265] PM: Adding info for No Bus:ttyw5
[  281.472232] device: 'ttyw6': device_add
[  281.485148] PM: Adding info for No Bus:ttyw6
[  281.488939] device: 'ttyw7': device_add
[  281.499558] PM: Adding info for No Bus:ttyw7
[  281.505828] device: 'ttyw8': device_add
[  281.516296] PM: Adding info for No Bus:ttyw8
[  281.522682] device: 'ttyw9': device_add
[  281.535409] PM: Adding info for No Bus:ttyw9
[  281.539314] device: 'ttywa': device_add
[  281.549568] PM: Adding info for No Bus:ttywa
[  281.553198] device: 'ttywb': device_add
[  281.566017] PM: Adding info for No Bus:ttywb
[  281.569696] device: 'ttywc': device_add
[  281.580198] PM: Adding info for No Bus:ttywc
[  281.585322] device: 'ttywd': device_add
[  281.596578] PM: Adding info for No Bus:ttywd
[  281.602029] device: 'ttywe': device_add
[  281.612940] PM: Adding info for No Bus:ttywe
[  281.616641] device: 'ttywf': device_add
[  281.629281] PM: Adding info for No Bus:ttywf
[  281.632900] device: 'ttyx0': device_add
[  281.645552] PM: Adding info for No Bus:ttyx0
[  281.649662] device: 'ttyx1': device_add
[  281.662474] PM: Adding info for No Bus:ttyx1
[  281.666134] device: 'ttyx2': device_add
[  281.679598] PM: Adding info for No Bus:ttyx2
[  281.683284] device: 'ttyx3': device_add
[  281.699838] PM: Adding info for No Bus:ttyx3
[  281.705668] device: 'ttyx4': device_add
[  281.719065] PM: Adding info for No Bus:ttyx4
[  281.722771] device: 'ttyx5': device_add
[  281.735670] PM: Adding info for No Bus:ttyx5
[  281.739460] device: 'ttyx6': device_add
[  281.752011] PM: Adding info for No Bus:ttyx6
[  281.755814] device: 'ttyx7': device_add
[  281.766373] PM: Adding info for No Bus:ttyx7
[  281.772234] device: 'ttyx8': device_add
[  281.782824] PM: Adding info for No Bus:ttyx8
[  281.788554] device: 'ttyx9': device_add
[  281.801732] PM: Adding info for No Bus:ttyx9
[  281.805419] device: 'ttyxa': device_add
[  281.816148] PM: Adding info for No Bus:ttyxa
[  281.819754] device: 'ttyxb': device_add
[  281.829955] PM: Adding info for No Bus:ttyxb
[  281.835318] device: 'ttyxc': device_add
[  281.848824] PM: Adding info for No Bus:ttyxc
[  281.852542] device: 'ttyxd': device_add
[  281.862765] PM: Adding info for No Bus:ttyxd
[  281.866420] device: 'ttyxe': device_add
[  281.876690] PM: Adding info for No Bus:ttyxe
[  281.881864] device: 'ttyxf': device_add
[  281.892624] PM: Adding info for No Bus:ttyxf
[  281.896489] device: 'ttyy0': device_add
[  281.908798] PM: Adding info for No Bus:ttyy0
[  281.912929] device: 'ttyy1': device_add
[  281.930401] PM: Adding info for No Bus:ttyy1
[  281.936184] device: 'ttyy2': device_add
[  281.946683] PM: Adding info for No Bus:ttyy2
[  281.951568] device: 'ttyy3': device_add
[  281.962294] PM: Adding info for No Bus:ttyy3
[  281.965793] device: 'ttyy4': device_add
[  281.979006] PM: Adding info for No Bus:ttyy4
[  281.982540] device: 'ttyy5': device_add
[  281.992279] PM: Adding info for No Bus:ttyy5
[  281.995641] device: 'ttyy6': device_add
[  282.005543] PM: Adding info for No Bus:ttyy6
[  282.008910] device: 'ttyy7': device_add
[  282.018821] PM: Adding info for No Bus:ttyy7
[  282.022806] device: 'ttyy8': device_add
[  282.032691] PM: Adding info for No Bus:ttyy8
[  282.036337] device: 'ttyy9': device_add
[  282.046403] PM: Adding info for No Bus:ttyy9
[  282.049844] device: 'ttyya': device_add
[  282.059266] PM: Adding info for No Bus:ttyya
[  282.062798] device: 'ttyyb': device_add
[  282.072858] PM: Adding info for No Bus:ttyyb
[  282.076152] device: 'ttyyc': device_add
[  282.085848] PM: Adding info for No Bus:ttyyc
[  282.093168] device: 'ttyyd': device_add
[  282.106065] PM: Adding info for No Bus:ttyyd
[  282.109816] device: 'ttyye': device_add
[  282.119084] PM: Adding info for No Bus:ttyye
[  282.122313] device: 'ttyyf': device_add
[  282.132546] PM: Adding info for No Bus:ttyyf
[  282.135881] device: 'ttyz0': device_add
[  282.145916] PM: Adding info for No Bus:ttyz0
[  282.149559] device: 'ttyz1': device_add
[  282.158878] PM: Adding info for No Bus:ttyz1
[  282.162187] device: 'ttyz2': device_add
[  282.172035] PM: Adding info for No Bus:ttyz2
[  282.175371] device: 'ttyz3': device_add
[  282.185014] PM: Adding info for No Bus:ttyz3
[  282.188178] device: 'ttyz4': device_add
[  282.195865] PM: Adding info for No Bus:ttyz4
[  282.199139] device: 'ttyz5': device_add
[  282.208387] PM: Adding info for No Bus:ttyz5
[  282.211589] device: 'ttyz6': device_add
[  282.219277] PM: Adding info for No Bus:ttyz6
[  282.222561] device: 'ttyz7': device_add
[  282.231796] PM: Adding info for No Bus:ttyz7
[  282.234981] device: 'ttyz8': device_add
[  282.242788] PM: Adding info for No Bus:ttyz8
[  282.246403] device: 'ttyz9': device_add
[  282.255978] PM: Adding info for No Bus:ttyz9
[  282.259392] device: 'ttyza': device_add
[  282.268792] PM: Adding info for No Bus:ttyza
[  282.272057] device: 'ttyzb': device_add
[  282.280234] PM: Adding info for No Bus:ttyzb
[  282.283381] device: 'ttyzc': device_add
[  282.292637] PM: Adding info for No Bus:ttyzc
[  282.295871] device: 'ttyzd': device_add
[  282.305954] PM: Adding info for No Bus:ttyzd
[  282.309186] device: 'ttyze': device_add
[  282.318528] PM: Adding info for No Bus:ttyze
[  282.321793] device: 'ttyzf': device_add
[  282.329784] PM: Adding info for No Bus:ttyzf
[  282.333036] device: 'ttya0': device_add
[  282.342504] PM: Adding info for No Bus:ttya0
[  282.346330] device: 'ttya1': device_add
[  282.356941] PM: Adding info for No Bus:ttya1
[  282.361489] device: 'ttya2': device_add
[  282.369312] PM: Adding info for No Bus:ttya2
[  282.372610] device: 'ttya3': device_add
[  282.381900] PM: Adding info for No Bus:ttya3
[  282.385150] device: 'ttya4': device_add
[  282.393260] PM: Adding info for No Bus:ttya4
[  282.398164] device: 'ttya5': device_add
[  282.405945] PM: Adding info for No Bus:ttya5
[  282.409223] device: 'ttya6': device_add
[  282.418965] PM: Adding info for No Bus:ttya6
[  282.422206] device: 'ttya7': device_add
[  282.431628] PM: Adding info for No Bus:ttya7
[  282.435287] device: 'ttya8': device_add
[  282.448700] PM: Adding info for No Bus:ttya8
[  282.452301] device: 'ttya9': device_add
[  282.462015] PM: Adding info for No Bus:ttya9
[  282.465303] device: 'ttyaa': device_add
[  282.473284] PM: Adding info for No Bus:ttyaa
[  282.476627] device: 'ttyab': device_add
[  282.488806] PM: Adding info for No Bus:ttyab
[  282.492098] device: 'ttyac': device_add
[  282.500225] PM: Adding info for No Bus:ttyac
[  282.503379] device: 'ttyad': device_add
[  282.512462] PM: Adding info for No Bus:ttyad
[  282.515725] device: 'ttyae': device_add
[  282.525866] PM: Adding info for No Bus:ttyae
[  282.529129] device: 'ttyaf': device_add
[  282.538911] PM: Adding info for No Bus:ttyaf
[  282.542208] device: 'ttyb0': device_add
[  282.550257] PM: Adding info for No Bus:ttyb0
[  282.555259] device: 'ttyb1': device_add
[  282.563545] PM: Adding info for No Bus:ttyb1
[  282.566918] device: 'ttyb2': device_add
[  282.575692] PM: Adding info for No Bus:ttyb2
[  282.578902] device: 'ttyb3': device_add
[  282.586882] PM: Adding info for No Bus:ttyb3
[  282.589985] device: 'ttyb4': device_add
[  282.598980] PM: Adding info for No Bus:ttyb4
[  282.602244] device: 'ttyb5': device_add
[  282.611656] PM: Adding info for No Bus:ttyb5
[  282.614828] device: 'ttyb6': device_add
[  282.622827] PM: Adding info for No Bus:ttyb6
[  282.626167] device: 'ttyb7': device_add
[  282.636854] PM: Adding info for No Bus:ttyb7
[  282.639938] device: 'ttyb8': device_add
[  282.649703] PM: Adding info for No Bus:ttyb8
[  282.653266] device: 'ttyb9': device_add
[  282.665480] PM: Adding info for No Bus:ttyb9
[  282.668818] device: 'ttyba': device_add
[  282.678376] PM: Adding info for No Bus:ttyba
[  282.681589] device: 'ttybb': device_add
[  282.689241] PM: Adding info for No Bus:ttybb
[  282.692538] device: 'ttybc': device_add
[  282.701784] PM: Adding info for No Bus:ttybc
[  282.704993] device: 'ttybd': device_add
[  282.712737] PM: Adding info for No Bus:ttybd
[  282.715937] device: 'ttybe': device_add
[  282.725571] PM: Adding info for No Bus:ttybe
[  282.728911] device: 'ttybf': device_add
[  282.738704] PM: Adding info for No Bus:ttybf
[  282.742018] device: 'ttyc0': device_add
[  282.753605] PM: Adding info for No Bus:ttyc0
[  282.758690] device: 'ttyc1': device_add
[  282.768498] PM: Adding info for No Bus:ttyc1
[  282.771749] device: 'ttyc2': device_add
[  282.779528] PM: Adding info for No Bus:ttyc2
[  282.782776] device: 'ttyc3': device_add
[  282.791969] PM: Adding info for No Bus:ttyc3
[  282.795192] device: 'ttyc4': device_add
[  282.803123] PM: Adding info for No Bus:ttyc4
[  282.806393] device: 'ttyc5': device_add
[  282.816078] PM: Adding info for No Bus:ttyc5
[  282.819501] device: 'ttyc6': device_add
[  282.828712] PM: Adding info for No Bus:ttyc6
[  282.832302] device: 'ttyc7': device_add
[  282.842708] PM: Adding info for No Bus:ttyc7
[  282.845971] device: 'ttyc8': device_add
[  282.855615] PM: Adding info for No Bus:ttyc8
[  282.859224] device: 'ttyc9': device_add
[  282.868747] PM: Adding info for No Bus:ttyc9
[  282.871981] device: 'ttyca': device_add
[  282.879941] PM: Adding info for No Bus:ttyca
[  282.883245] device: 'ttycb': device_add
[  282.892227] PM: Adding info for No Bus:ttycb
[  282.895710] device: 'ttycc': device_add
[  282.905562] PM: Adding info for No Bus:ttycc
[  282.908835] device: 'ttycd': device_add
[  282.918247] PM: Adding info for No Bus:ttycd
[  282.920233] device: 'ttyce': device_add
[  282.929176] PM: Adding info for No Bus:ttyce
[  282.932546] device: 'ttycf': device_add
[  282.941821] PM: Adding info for No Bus:ttycf
[  282.945021] device: 'ttyd0': device_add
[  282.952894] PM: Adding info for No Bus:ttyd0
[  282.956516] device: 'ttyd1': device_add
[  282.965665] PM: Adding info for No Bus:ttyd1
[  282.968927] device: 'ttyd2': device_add
[  282.976962] PM: Adding info for No Bus:ttyd2
[  282.980225] device: 'ttyd3': device_add
[  282.989374] PM: Adding info for No Bus:ttyd3
[  282.992780] device: 'ttyd4': device_add
[  283.002041] PM: Adding info for No Bus:ttyd4
[  283.005316] device: 'ttyd5': device_add
[  283.015643] PM: Adding info for No Bus:ttyd5
[  283.018925] device: 'ttyd6': device_add
[  283.026962] PM: Adding info for No Bus:ttyd6
[  283.030243] device: 'ttyd7': device_add
[  283.039231] PM: Adding info for No Bus:ttyd7
[  283.042509] device: 'ttyd8': device_add
[  283.052201] PM: Adding info for No Bus:ttyd8
[  283.055853] device: 'ttyd9': device_add
[  283.065910] PM: Adding info for No Bus:ttyd9
[  283.069162] device: 'ttyda': device_add
[  283.078513] PM: Adding info for No Bus:ttyda
[  283.081717] device: 'ttydb': device_add
[  283.091791] PM: Adding info for No Bus:ttydb
[  283.095044] device: 'ttydc': device_add
[  283.102878] PM: Adding info for No Bus:ttydc
[  283.106083] device: 'ttydd': device_add
[  283.115280] PM: Adding info for No Bus:ttydd
[  283.118586] device: 'ttyde': device_add
[  283.126607] PM: Adding info for No Bus:ttyde
[  283.129842] device: 'ttydf': device_add
[  283.138932] PM: Adding info for No Bus:ttydf
[  283.142195] device: 'ttye0': device_add
[  283.150231] PM: Adding info for No Bus:ttye0
[  283.155136] device: 'ttye1': device_add
[  283.163246] PM: Adding info for No Bus:ttye1
[  283.166623] device: 'ttye2': device_add
[  283.176336] PM: Adding info for No Bus:ttye2
[  283.179693] device: 'ttye3': device_add
[  283.191871] PM: Adding info for No Bus:ttye3
[  283.195106] device: 'ttye4': device_add
[  283.203168] PM: Adding info for No Bus:ttye4
[  283.206377] device: 'ttye5': device_add
[  283.215553] PM: Adding info for No Bus:ttye5
[  283.218790] device: 'ttye6': device_add
[  283.226693] PM: Adding info for No Bus:ttye6
[  283.231781] device: 'ttye7': device_add
[  283.239904] PM: Adding info for No Bus:ttye7
[  283.243190] device: 'ttye8': device_add
[  283.252275] PM: Adding info for No Bus:ttye8
[  283.255897] device: 'ttye9': device_add
[  283.265723] PM: Adding info for No Bus:ttye9
[  283.269098] device: 'ttyea': device_add
[  283.279182] PM: Adding info for No Bus:ttyea
[  283.282472] device: 'ttyeb': device_add
[  283.291649] PM: Adding info for No Bus:ttyeb
[  283.294861] device: 'ttyec': device_add
[  283.302577] PM: Adding info for No Bus:ttyec
[  283.305868] device: 'ttyed': device_add
[  283.315100] PM: Adding info for No Bus:ttyed
[  283.318316] device: 'ttyee': device_add
[  283.326061] PM: Adding info for No Bus:ttyee
[  283.329344] device: 'ttyef': device_add
[  283.338631] PM: Adding info for No Bus:ttyef
[  283.344949] device: 'ptmx': device_add
[  283.352559] PM: Adding info for No Bus:ptmx
[  283.358986] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[  283.365634] Registering platform device 'serial8250'. Parent at platform
[  283.366895] device: 'serial8250': device_add
[  283.369844] bus: 'platform': add device serial8250
[  283.373288] PM: Adding info for platform:serial8250
[  283.419728] serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[  283.424903] device: 'ttyS0': device_add
[  283.442464] PM: Adding info for No Bus:ttyS0
[  283.454923] device: 'ttyS1': device_add
[  283.462922] PM: Adding info for No Bus:ttyS1
[  283.469847] device: 'ttyS2': device_add
[  283.479482] PM: Adding info for No Bus:ttyS2
[  283.491826] device: 'ttyS3': device_add
[  283.501570] PM: Adding info for No Bus:ttyS3
[  283.506465] bus: 'platform': add driver serial8250
[  283.509654] bus: 'platform': driver_probe_device: matched device serial8=
250 with driver serial8250
[  283.512358] bus: 'platform': really_probe: probing driver serial8250 wit=
h device serial8250
[  283.515595] driver: 'serial8250': driver_bound: bound to device 'serial8=
250'
[  283.518854] bus: 'platform': really_probe: bound device serial8250 to dr=
iver serial8250
[  283.522783] bus: 'pnp': add driver serial
[  283.529926] bus: 'pnp': driver_probe_device: matched device 00:06 with d=
river serial
[  283.532573] bus: 'pnp': really_probe: probing driver serial with device =
00:06
[  283.575937] device: 'ttyS0': device_unregister
[  283.578587] PM: Removing info for No Bus:ttyS0
[  283.686371] device: 'ttyS0': device_create_release
[  283.754979] 00:06: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[  283.756423] device: 'ttyS0': device_add
[  283.769555] PM: Adding info for No Bus:ttyS0
[  283.778473] driver: '00:06': driver_bound: bound to device 'serial'
[  283.779638] bus: 'pnp': really_probe: bound device 00:06 to driver serial
[  283.785228] bus: 'pci': add driver serial
[  283.799795] bus: 'pci': add driver jsm
[  283.809149] bus: 'platform': add driver altera_jtaguart
[  283.819288] bus: 'pci': add driver pch_uart
[  283.829086] bus: 'platform': add driver xuartps
[  283.833094] Cyclades driver 2.6
[  283.836386] bus: 'pci': add driver cyclades
[  283.855121] bus: 'pci': add driver isicom
[  283.861932] RocketPort device driver module, version 2.09, 12-June-2003
[  283.869681] No rocketport ports found; unloading driver
[  283.878162] SyncLink GT
[  283.879816] SyncLink GT, tty major#249
[  283.882293] bus: 'pci': add driver synclink_gt
[  283.888910] SyncLink GT no devices found
[  283.893206] device: 'hpet': device_add
[  283.903217] PM: Adding info for No Bus:hpet
[  283.908688] bus: 'acpi': add driver hpet
[  283.915049] bus: 'acpi': driver_probe_device: matched device PNP0103:00 =
with driver hpet
[  283.916226] bus: 'acpi': really_probe: probing driver hpet with device P=
NP0103:00
[  283.932904] hpet: probe of PNP0103:00 rejects match -19
[  283.939828] device: 'nvram': device_add
[  283.949709] PM: Adding info for No Bus:nvram
[  283.953600] Non-volatile memory driver v1.3
[  283.956279] bus: 'platform': add driver timeriomem_rng
[  283.968935] Registering platform device 'pc8736x_gpio.0'. Parent at plat=
form
[  283.970228] device: 'pc8736x_gpio.0': device_add
[  283.972853] bus: 'platform': add device pc8736x_gpio.0
[  283.976277] PM: Adding info for platform:pc8736x_gpio.0
[  283.982618] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initial=
izing
[  283.985670] platform pc8736x_gpio.0: no device found
[  283.986890] PM: Removing info for platform:pc8736x_gpio.0
[  283.996117] bus: 'platform': remove device pc8736x_gpio.0
[  284.005189] nsc_gpio initializing
[  284.005978] Linux agpgart interface v0.103
[  284.008192] bus: 'pci': add driver agpgart-ali
[  284.015200] bus: 'pci': add driver agpgart-efficeon
[  284.022057] bus: 'pci': add driver agpgart-nvidia
[  284.028927] bus: 'pci': add driver agpgart-sis
[  284.035872] bus: 'pci': add driver agpgart-serverworks
[  284.042669] bus: 'pci': add driver agpgart-via
[  284.049596] bus: 'platform': add driver ipmi
[  284.055102] ipmi message handler version 39.2
[  284.058262] bus: 'platform': add driver ipmi_si
[  284.062383] IPMI System Interface driver.
[  284.065137] bus: 'pci': add driver ipmi_si
[  284.071771] bus: 'pnp': add driver ipmi_si
[  284.081776] ipmi_si: Adding default-specified kcs state machine
[  284.083315] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[  284.088636] ipmi_si: Interface detection failed
[  284.092970] ipmi_si: Adding default-specified smic state machine
[  284.095875] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[  284.099085] ipmi_si: Interface detection failed
[  284.101927] ipmi_si: Adding default-specified bt state machine
[  284.103126] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[  284.106658] ipmi_si: Interface detection failed
[  284.116855] bus: 'pci': remove driver ipmi_si
[  284.119776] driver: 'ipmi_si': driver_release
[  284.123368] bus: 'pnp': remove driver ipmi_si
[  284.126621] driver: 'ipmi_si': driver_release
[  284.129796] bus: 'platform': remove driver ipmi_si
[  284.133043] driver: 'ipmi_si': driver_release
[  284.135824] ipmi_si: Unable to find any System Interface(s)
[  284.138136] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via =
sys_reboot.
[  284.146119] bus: 'pnp': add driver tpm_inf_pnp
[  284.152421] device class 'drm': registering
[  284.159241] [drm] Initialized drm 1.1.0 20060810
[  284.215582] bus: 'platform': add driver parport_pc
[  284.225951] bus: 'pnp': add driver parport_pc
[  284.229191] bus: 'pnp': driver_probe_device: matched device 00:05 with d=
river parport_pc
[  284.231843] bus: 'pnp': really_probe: probing driver parport_pc with dev=
ice 00:05
[  284.236027] parport_pc 00:05: reported by Plug and Play ACPI
[  284.245340] parport0: PC-style at 0x378, irq 7 [PCSPP(,...)]
[  284.266219] driver: '00:05': driver_bound: bound to device 'parport_pc'
[  284.269043] bus: 'pnp': really_probe: bound device 00:05 to driver parpo=
rt_pc
[  284.273327] Registering platform device 'parport_pc.956'. Parent at plat=
form
[  284.276122] device: 'parport_pc.956': device_add
[  284.278842] bus: 'platform': add device parport_pc.956
[  284.282281] PM: Adding info for platform:parport_pc.956
[  284.288202] bus: 'platform': driver_probe_device: matched device parport=
_pc.956 with driver parport_pc
[  284.289517] bus: 'platform': really_probe: probing driver parport_pc wit=
h device parport_pc.956
[  284.292894] driver: 'parport_pc.956': driver_bound: bound to device 'par=
port_pc'
[  284.295825] bus: 'platform': really_probe: bound device parport_pc.956 t=
o driver parport_pc
[  284.302262] PM: Removing info for platform:parport_pc.956
[  284.308616] bus: 'platform': remove device parport_pc.956
[  284.316083] Registering platform device 'parport_pc.888'. Parent at plat=
form
[  284.318683] device: 'parport_pc.888': device_add
[  284.320234] bus: 'platform': add device parport_pc.888
[  284.324951] PM: Adding info for platform:parport_pc.888
[  284.329338] bus: 'platform': driver_probe_device: matched device parport=
_pc.888 with driver parport_pc
[  284.332197] bus: 'platform': really_probe: probing driver parport_pc wit=
h device parport_pc.888
[  284.335511] driver: 'parport_pc.888': driver_bound: bound to device 'par=
port_pc'
[  284.336901] bus: 'platform': really_probe: bound device parport_pc.888 t=
o driver parport_pc
[  284.341516] PM: Removing info for platform:parport_pc.888
[  284.346417] bus: 'platform': remove device parport_pc.888
[  284.352391] Registering platform device 'parport_pc.632'. Parent at plat=
form
[  284.355355] device: 'parport_pc.632': device_add
[  284.358215] bus: 'platform': add device parport_pc.632
[  284.360216] PM: Adding info for platform:parport_pc.632
[  284.366155] bus: 'platform': driver_probe_device: matched device parport=
_pc.632 with driver parport_pc
[  284.368819] bus: 'platform': really_probe: probing driver parport_pc wit=
h device parport_pc.632
[  284.371924] driver: 'parport_pc.632': driver_bound: bound to device 'par=
port_pc'
[  284.373161] bus: 'platform': really_probe: bound device parport_pc.632 t=
o driver parport_pc
[  284.378621] PM: Removing info for platform:parport_pc.632
[  284.383381] bus: 'platform': remove device parport_pc.632
[  284.389484] bus: 'pci': add driver parport_pc
[  284.399673] bus: 'i2c': add driver bmp085
[  284.405219] bus: 'spi': add driver bmp085
[  284.409267] bus: 'i2c': add driver bh1780
[  284.413094] bus: 'i2c': add driver apds9802als
[  284.418619] i2c-core: driver [apds9802als] using legacy suspend method
[  284.419684] i2c-core: driver [apds9802als] using legacy resume method
[  284.422295] bus: 'i2c': add driver isl29003
[  284.426162] i2c-core: driver [isl29003] using legacy suspend method
[  284.428759] i2c-core: driver [isl29003] using legacy resume method
[  284.430239] bus: 'i2c': add driver tsl2550
[  284.435199] i2c-core: driver [tsl2550] using legacy suspend method
[  284.436156] i2c-core: driver [tsl2550] using legacy resume method
[  284.438914] bus: 'spi': add driver dac7512
[  284.442830] bus: 'i2c': add driver at24
[  284.451566] bus: 'spi': add driver at25
[  284.456204] bus: 'pci': add driver pch_phub
[  284.462935] bus: 'platform': add driver pasic3
[  284.468886] bus: 'platform': remove driver pasic3
[  284.472087] driver: 'pasic3': driver_release
[  284.473187] bus: 'i2c': add driver wm8994
[  284.478650] bus: 'platform': add driver ab3100-otp
[  284.482822] bus: 'platform': remove driver ab3100-otp
[  284.486107] driver: 'ab3100-otp': driver_release
[  284.488602] bus: 'i2c': add driver adp5520
[  284.492753] bus: 'pci': add driver lpc_sch
[  284.499383] bus: 'pci': add driver lpc_ich
[  284.508865] bus: 'pci': add driver RDC321x Southbridge
[  284.515854] bus: 'pci': add driver vx855
[  284.522326] device class 'mtd': registering
[  284.526316] device: 'mtd-unmap': device_add
[  284.531868] PM: Adding info for No Bus:mtd-unmap
[  284.538421] device: 'mtd-romap': device_add
[  284.543221] PM: Adding info for No Bus:mtd-romap
[  284.549926] device: 'mtd-rwmap': device_add
[  284.555856] PM: Adding info for No Bus:mtd-rwmap
[  284.569824] L440GX flash mapping: failed to find PIIX4 ISA bridge, canno=
t continue
[  284.572591] device id =3D 2440
[  284.575771] device id =3D 2480
[  284.578603] device id =3D 24c0
[  284.579868] device id =3D 24d0
[  284.582457] device id =3D 25a1
[  284.585362] device id =3D 2670
[  284.602847] bus: 'platform': add driver physmap-flash
[  284.608844] SBC-GXx flash: IO:0x258-0x259 MEM:0xdc000-0xdffff
[  284.632971] Could not find PAR responsible for SC520CDP Flash Bank #1
[  284.636031] Trying default address 0x8c00000
[  284.639328] SC520 CDP flash device: 0x800000 at 0x8800000
[  284.642060] Failed to ioremap_nocache
[  284.642967] Failed to ioremap_nocache
[  284.645276] scx200_docflash: NatSemi SCx200 DOCCS Flash Driver
[  284.648799] bus: 'platform': add driver gpio-addr-flash
[  284.652955] bus: 'platform': add driver docg3
[  284.658574] bus: 'platform': remove driver docg3
[  284.661618] driver: 'docg3': driver_release
[  284.662589] slram: not enough parameters.
[  285.448273] onenand_wait: timeout! ctrl=3D0x0000 intr=3D0x0000
[  285.449382] OneNAND Manufacturer: Samsung (0xec)
[  285.452119] OneNAND 16MB 1.8V 16-bit (0x04)
[  285.452911] OneNAND version =3D 0x001e
[  285.455287] Lock scheme is Continuous Lock
[  285.461918] Scanning device for bad blocks
[  285.589935] Creating 1 MTD partitions on "OneNAND simulator":
[  285.595806] 0x000000000000-0x000001000000 : "OneNAND simulator partition"
[  285.655375] device: 'mtd0': device_add
[  285.675925] PM: Adding info for No Bus:mtd0
[  285.685637] device: 'mtd0ro': device_add
[  285.695667] PM: Adding info for No Bus:mtd0ro
[  285.699214] bus: 'platform': add driver spi_altera
[  285.719340] parport0: powerup/reset Butterfly
[  285.846978] device: 'spi42': device_add
[  285.859139] PM: Adding info for No Bus:spi42
[  285.868585] parport_pc 00:05: registered master spi42
[  285.869503] parport_pc 00:05: master is unqueued, this is deprecated
[  285.882895] spi spi42.1: spi_bitbang_setup, 66 nsec/bit
[  285.888640] spi spi42.1: setup mode 0, 8 bits/w, 15000000 Hz max --> 0
[  285.889811] device: 'spi42.1': device_add
[  285.896016] bus: 'spi': add device spi42.1
[  285.902181] PM: Adding info for spi:spi42.1
[  285.912848] parport_pc 00:05: registered child spi42.1
[  285.915835] parport0: dataflash at spi42.1
[  285.916634] parport0: AVR Butterfly
[  285.919101] bus: 'pci': add driver dw_spi_pci
[  285.926087] bus: 'platform': add driver spi_gpio
[  285.930280] bus: 'platform': add driver spi_oc_tiny
[  285.936184] bus: 'spi': add driver tle62x0
[  285.956028] bus: 'firewire': registered
[  285.965902] bus: 'pci': add driver firewire_ohci
[  285.973163] device class 'uio': registering
[  285.978532] bus: 'pci': add driver aectc
[  285.986088] bus: 'pci': add driver sercos3
[  285.992860] bus: 'pci': add driver netx
[  286.000273] bus: 'pnp': add driver i8042 kbd
[  286.003615] bus: 'pnp': driver_probe_device: matched device 00:02 with d=
river i8042 kbd
[  286.006404] bus: 'pnp': really_probe: probing driver i8042 kbd with devi=
ce 00:02
[  286.012226] driver: '00:02': driver_bound: bound to device 'i8042 kbd'
[  286.015148] bus: 'pnp': really_probe: bound device 00:02 to driver i8042=
 kbd
[  286.019549] bus: 'pnp': add driver i8042 aux
[  286.022819] bus: 'pnp': driver_probe_device: matched device 00:03 with d=
river i8042 aux
[  286.025735] bus: 'pnp': really_probe: probing driver i8042 aux with devi=
ce 00:03
[  286.032825] driver: '00:03': driver_bound: bound to device 'i8042 aux'
[  286.035751] bus: 'pnp': really_probe: bound device 00:03 to driver i8042=
 aux
[  286.040248] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[  286.046415] Registering platform device 'i8042'. Parent at platform
[  286.049110] device: 'i8042': device_add
[  286.051893] bus: 'platform': add device i8042
[  286.055508] PM: Adding info for platform:i8042
[  286.062043] bus: 'platform': add driver i8042
[  286.065418] bus: 'platform': driver_probe_device: matched device i8042 w=
ith driver i8042
[  286.066621] bus: 'platform': really_probe: probing driver i8042 with dev=
ice i8042
[  286.099564] serio: i8042 KBD port at 0x60,0x64 irq 1
[  286.115235] serio: i8042 AUX port at 0x60,0x64 irq 12
[  286.116938] driver: 'i8042': driver_bound: bound to device 'i8042'
[  286.122515] device: 'serio0': device_add
[  286.125841] bus: 'platform': really_probe: bound device i8042 to driver =
i8042
[  286.129950] bus: 'pci': add driver Emu10k1_gameport
[  286.148492] bus: 'serio': add device serio0
[  286.159591] device: 'mice': device_add
[  286.162969] PM: Adding info for serio:serio0
[  286.188721] PM: Adding info for No Bus:mice
[  286.196193] device: 'serio1': device_add
[  286.199904] bus: 'serio': add device serio1
[  286.205315] device: 'psaux': device_add
[  286.215591] PM: Adding info for No Bus:psaux
[  286.219941] PM: Adding info for serio:serio1
[  286.226581] mousedev: PS/2 mouse device common for all mice
[  286.229288] bus: 'serio': add driver atkbd
[  286.238687] bus: 'serio': driver_probe_device: matched device serio0 wit=
h driver atkbd
[  286.239824] bus: 'serio': really_probe: probing driver atkbd with device=
 serio0
[  286.258259] bus: 'serio': add driver psmouse
[  286.265400] bus: 'platform': add driver ab3100-rtc
[  286.281624] bus: 'platform': remove driver ab3100-rtc
[  286.283305] driver: 'ab3100-rtc': driver_release
[  286.292866] bus: 'platform': add driver rtc-bq4802
[  286.311960] bus: 'pnp': add driver rtc_cmos
[  286.314992] bus: 'pnp': driver_probe_device: matched device 00:01 with d=
river rtc_cmos
[  286.316125] bus: 'pnp': really_probe: probing driver rtc_cmos with devic=
e 00:01
[  286.328373] rtc_cmos 00:01: RTC can wake from S4
[  286.363612] device: 'input1': device_add
[  286.396175] PM: Adding info for No Bus:input1
[  286.412764] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[  286.415870] rtc (null): alarm rollover: day
[  286.430273] device: 'rtc0': device_add
[  286.442913] driver: 'serio0': driver_bound: bound to device 'atkbd'
[  286.450292] PM: Adding info for No Bus:rtc0
[  286.452995] bus: 'serio': really_probe: bound device serio0 to driver at=
kbd
[  286.455997] bus: 'serio': driver_probe_device: matched device serio1 wit=
h driver atkbd
[  286.468561] bus: 'serio': really_probe: probing driver atkbd with device=
 serio1
[  286.476248] rtc_cmos: dev (254:0)
[  286.479791] rtc_cmos 00:01: rtc core: registered rtc_cmos as rtc0
[  286.495704] atkbd: probe of serio1 rejects match -19
[  286.498929] bus: 'serio': driver_probe_device: matched device serio1 wit=
h driver psmouse
[  286.502490] rtc0: alarms up to one day, 114 bytes nvram, hpet irqs
[  286.505098] driver: '00:01': driver_bound: bound to device 'rtc_cmos'
[  286.506258] bus: 'pnp': really_probe: bound device 00:01 to driver rtc_c=
mos
[  286.509323] bus: 'serio': really_probe: probing driver psmouse with devi=
ce serio1
[  286.529293] bus: 'platform': add driver da9052-rtc
[  286.535091] bus: 'platform': add driver rtc-ds1286
[  286.550279] bus: 'platform': add driver ds1511
[  286.569007] bus: 'platform': add driver rtc-ds1553
[  286.585137] bus: 'i2c': add driver rtc-ds3232
[  286.609878] bus: 'i2c': add driver rtc-em3027
[  286.626519] bus: 'i2c': add driver rtc-isl1208
[  286.643096] bus: 'i2c': add driver rtc-isl12022
[  286.655619] bus: 'i2c': add driver rtc-m41t80
[  286.671849] bus: 'platform': add driver rtc-m48t59
[  286.676198] bus: 'platform': add driver max8925-rtc
[  286.693009] bus: 'platform': add driver mc13xxx-rtc
[  286.708536] bus: 'platform': remove driver mc13xxx-rtc
[  286.722126] driver: 'mc13xxx-rtc': driver_release
[  286.723246] bus: 'platform': add driver pcap-rtc
[  286.728884] bus: 'platform': remove driver pcap-rtc
[  286.732285] driver: 'pcap-rtc': driver_release
[  286.734982] bus: 'i2c': add driver rtc-pcf8563
[  286.739229] bus: 'spi': add driver rtc-pcf2123
[  286.743300] bus: 'platform': add driver pcf50633-rtc
[  286.749200] bus: 'spi': add driver rtc-r9701
[  286.753287] bus: 'platform': add driver rtc-rp5c01
[  286.759230] bus: 'platform': remove driver rtc-rp5c01
[  286.762540] driver: 'rtc-rp5c01': driver_release
[  286.765267] bus: 'i2c': add driver rtc-rs5c372
[  286.769631] bus: 'platform': add driver stk17ta8
[  286.776008] bus: 'platform': add driver rtc-test
[  286.782367] Registering platform device 'rtc-test.0'. Parent at platform
[  286.784975] device: 'rtc-test.0': device_add
[  286.786333] bus: 'platform': add device rtc-test.0
[  286.789730] PM: Adding info for platform:rtc-test.0
[  286.796347] bus: 'platform': driver_probe_device: matched device rtc-tes=
t.0 with driver rtc-test
[  286.799206] bus: 'platform': really_probe: probing driver rtc-test with =
device rtc-test.0
[  286.806273] device: 'rtc1': device_add
[  286.822230] PM: Adding info for No Bus:rtc1
[  286.826384] test: dev (254:1)
[  286.828849] rtc-test rtc-test.0: rtc core: registered test as rtc1
[  286.831787] driver: 'rtc-test.0': driver_bound: bound to device 'rtc-tes=
t'
[  286.832978] bus: 'platform': really_probe: bound device rtc-test.0 to dr=
iver rtc-test
[  286.836142] Registering platform device 'rtc-test.1'. Parent at platform
[  286.838919] device: 'rtc-test.1': device_add
[  286.841831] bus: 'platform': add device rtc-test.1
[  286.845133] PM: Adding info for platform:rtc-test.1
[  286.851842] bus: 'platform': driver_probe_device: matched device rtc-tes=
t.1 with driver rtc-test
[  286.853064] bus: 'platform': really_probe: probing driver rtc-test with =
device rtc-test.1
[  286.862007] device: 'rtc2': device_add
[  286.873295] PM: Adding info for No Bus:rtc2
[  286.876528] test: dev (254:2)
[  286.879017] rtc-test rtc-test.1: rtc core: registered test as rtc2
[  286.881761] driver: 'rtc-test.1': driver_bound: bound to device 'rtc-tes=
t'
[  286.882921] bus: 'platform': really_probe: bound device rtc-test.1 to dr=
iver rtc-test
[  286.886023] bus: 'platform': add driver wm8350-rtc
[  286.892030] bus: 'i2c': add driver smbus_alert
[  286.896497] bus: 'pci': add driver ali15x3_smbus
[  286.905061] bus: 'pci': add driver amd8111_smbus2
[  286.912672] bus: 'platform': add driver isch_smbus
[  286.928879] bus: 'pci': add driver nForce2_smbus
[  286.946049] bus: 'pci': add driver sis630_smbus
[  286.975077] bus: 'pci': add driver i2c-designware-pci
[  286.989092] bus: 'pci': add driver i2c_eg20t
[  286.996174] device: 'input2': device_add
[  287.003611] bus: 'pci': add driver i2c-intel-mid
[  287.016373] bus: 'pci': add driver ce4100_i2c
[  287.036147] i2c-parport: adapter type unspecified
[  287.040233] PM: Adding info for No Bus:input2
[  287.045258] Driver for 1-wire Dallas network protocol.
[  287.050266] bus: 'w1': registered
[  287.058789] bus: 'w1': add driver w1_master_driver
[  287.062761] bus: 'w1': add driver w1_slave_driver
[  287.065571] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/=
i8042/serio1/input/input2
[  287.076022] bus: 'platform': add driver w1-gpio
[  287.079366] device: 'mouse0': device_add
[  287.092499] bus: 'platform': remove driver w1-gpio
[  287.106192] driver: 'w1-gpio': driver_release
[  287.122196] PM: Adding info for No Bus:mouse0
[  287.131570] bus: 'platform': add driver wm831x-power
[  287.142565] bus: 'platform': add driver wm8350-power
[  287.155848] device: 'test_ac': device_add
[  287.158750] driver: 'serio1': driver_bound: bound to device 'psmouse'
[  287.159890] bus: 'serio': really_probe: bound device serio1 to driver ps=
mouse
[  287.169961] PM: Adding info for No Bus:test_ac
[  287.189778] device: 'test_battery': device_add
[  287.202604] PM: Adding info for No Bus:test_battery
[  287.219583] device: 'thermal_zone0': device_add
[  287.228636] PM: Adding info for No Bus:thermal_zone0
[  287.245184] device: 'hwmon0': device_add
[  287.249500] PM: Adding info for No Bus:hwmon0
[  287.269652] device: 'test_usb': device_add
[  287.279085] PM: Adding info for No Bus:test_usb
[  287.288676] bus: 'platform': add driver ds2780-battery
[  287.293057] bus: 'i2c': add driver ds2782-battery
[  287.299592] bus: 'platform': add driver olpc-battery
[  287.305412] bus: 'i2c': add driver sbs-battery
[  287.309393] i2c-core: driver [sbs-battery] using legacy suspend method
[  287.312337] bus: 'platform': add driver bq27000-battery
[  287.318327] bus: 'i2c': add driver max17042
[  287.322328] bus: 'platform': add driver pcf50633-mbc
[  287.326915] bus: 'i2c': add driver lp8727
[  287.332501] bus: 'acpi': add driver power_meter
[  287.342088] bus: 'i2c': add driver w83792d
[  287.346476] bus: 'i2c': add driver w83781d
[  287.352741] bus: 'i2c': add driver w83791d
[  287.358533] bus: 'i2c': add driver adm1025
[  287.362602] bus: 'i2c': add driver adm1031
[  287.368475] bus: 'i2c': add driver ads1015
[  287.372634] bus: 'i2c': add driver ads7828
[  287.376952] bus: 'spi': add driver ads7871
[  287.382695] bus: 'i2c': add driver asc7621
[  287.388512] bus: 'i2c': add driver emc1403
[  287.392600] bus: 'i2c': add driver emc6w201
[  287.398965] bus: 'i2c': add driver f75375
[  287.403080] bus: 'i2c': add driver g760a
[  287.408925] bus: 'i2c': add driver gl518sm
[  287.412951] bus: 'platform': add driver aem
[  287.420226] bus: 'i2c': add driver jc42
[  287.425782] bus: 'pci': add driver k10temp
[  287.432579] bus: 'i2c': add driver lm63
[  287.436962] bus: 'spi': add driver lm70
[  287.442365] bus: 'i2c': add driver lm75
[  287.446583] bus: 'i2c': add driver lm78
[  287.452340] bus: 'i2c': add driver lm80
[  287.456623] bus: 'i2c': add driver lm83
[  287.462179] bus: 'i2c': add driver lm85
[  287.466500] bus: 'i2c': add driver lm87
[  287.472713] bus: 'i2c': add driver lm90
[  287.478531] bus: 'i2c': add driver lm92
[  287.483144] bus: 'i2c': add driver lm93
[  287.491841] bus: 'i2c': add driver lm95241
[  287.495986] bus: 'i2c': add driver ltc4151
[  287.501665] bus: 'spi': add driver max1111
[  287.505826] bus: 'i2c': add driver max16065
[  287.511686] bus: 'platform': add driver mc13783-adc
[  287.515957] bus: 'platform': remove driver mc13783-adc
[  287.519480] driver: 'mc13783-adc': driver_release
[  287.522043] bus: 'platform': add driver sht10
[  287.526352] bus: 'platform': add driver sht11
[  287.532278] bus: 'platform': add driver sht15
[  287.536385] bus: 'platform': add driver sht71
[  287.542413] bus: 'platform': add driver sht75
[  287.548754] bus: 'i2c': add driver smsc47m192
[  287.552917] bus: 'platform': add driver wm831x-hwmon
[  287.558848] advantechwdt: WDT driver for Advantech single board computer=
 initialising
[  287.561573] bus: 'platform': add driver advantechwdt
[  287.568768] Registering platform device 'advantechwdt'. Parent at platfo=
rm
[  287.569919] device: 'advantechwdt': device_add
[  287.572746] bus: 'platform': add device advantechwdt
[  287.576053] PM: Adding info for platform:advantechwdt
[  287.584805] bus: 'platform': driver_probe_device: matched device advante=
chwdt with driver advantechwdt
[  287.586082] bus: 'platform': really_probe: probing driver advantechwdt w=
ith device advantechwdt
[  287.592347] device: 'watchdog': device_add
[  287.603666] PM: Adding info for No Bus:watchdog
[  287.608944] advantechwdt: initialized. timeout=3D60 sec (nowayout=3D0)
[  287.609952] driver: 'advantechwdt': driver_bound: bound to device 'advan=
techwdt'
[  287.612838] bus: 'platform': really_probe: bound device advantechwdt to =
driver advantechwdt
[  287.619269] alim7101_wdt: Steve Hill <steve@navaho.co.uk>
[  287.622494] alim7101_wdt: ALi M7101 PMU not present - WDT not set
[  287.625122] sp5100_tco: SP5100 TCO WatchDog Timer Driver v0.01
[  287.626215] bus: 'platform': add driver SP5100 TCO timer
[  287.632221] Registering platform device 'SP5100 TCO timer'. Parent at pl=
atform
[  287.633574] device: 'SP5100 TCO timer': device_add
[  287.636372] bus: 'platform': add device SP5100 TCO timer
[  287.639943] PM: Adding info for platform:SP5100 TCO timer
[  287.648516] bus: 'platform': driver_probe_device: matched device SP5100 =
TCO timer with driver SP5100 TCO timer
[  287.649881] bus: 'platform': really_probe: probing driver SP5100 TCO tim=
er with device SP5100 TCO timer
[  287.663676] SP5100 TCO timer: probe of SP5100 TCO timer rejects match -19
[  287.668957] sc520_wdt: cannot register miscdev on minor=3D130 (err=3D-16)
[  287.672331] ib700wdt: WDT driver for IB700 single board computer initial=
ising
[  287.675206] bus: 'platform': add driver ib700wdt
[  287.680274] Registering platform device 'ib700wdt'. Parent at platform
[  287.682962] device: 'ib700wdt': device_add
[  287.685823] bus: 'platform': add device ib700wdt
[  287.689199] PM: Adding info for platform:ib700wdt
[  287.696448] bus: 'platform': driver_probe_device: matched device ib700wd=
t with driver ib700wdt
[  287.699272] bus: 'platform': really_probe: probing driver ib700wdt with =
device ib700wdt
[  287.702869] ib700wdt: START method I/O 443 is not available
[  287.706368] ib700wdt: probe of ib700wdt failed with error -5
[  287.709843] bus: 'pci': add driver i6300ESB timer
[  287.715502] bus: 'pci': driver_probe_device: matched device 0000:00:0a.0=
 with driver i6300ESB timer
[  287.718341] bus: 'pci': really_probe: probing driver i6300ESB timer with=
 device 0000:00:0a.0
[  287.725743] i6300esb: Intel 6300ESB WatchDog Timer Driver v0.05
[  287.739192] i6300esb: cannot register miscdev on minor=3D130 (err=3D-16)
[  287.745403] i6300ESB timer: probe of 0000:00:0a.0 failed with error -16
[  287.749721] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
[  287.752297] bus: 'platform': add driver iTCO_wdt
[  287.758484] iTCO_vendor_support: vendor-support=3D0
[  287.759449] nv_tco: NV TCO WatchDog Timer Driver v0.01
[  287.761750] bus: 'platform': add driver NV_TCO
[  287.768769] Registering platform device 'NV_TCO'. Parent at platform
[  287.769834] device: 'NV_TCO': device_add
[  287.772533] bus: 'platform': add device NV_TCO
[  287.775937] PM: Adding info for platform:NV_TCO
[  287.783204] bus: 'platform': driver_probe_device: matched device NV_TCO =
with driver NV_TCO
[  287.785959] bus: 'platform': really_probe: probing driver NV_TCO with de=
vice NV_TCO
[  287.795891] NV_TCO: probe of NV_TCO rejects match -19
[  287.799360] sbc60xxwdt: I/O address 0x0443 already in use
[  287.802416] sbc8360: failed to register misc device
[  287.805326] sbc7240_wdt: I/O address 0x0443 already in use
[  287.808554] cpu5wdt: misc_register failed
[  287.809801] smsc37b787_wdt: SMsC 37B787 watchdog component driver 1.1 in=
itialising...
[  287.816933] smsc37b787_wdt: Unable to register miscdev on minor 130
[  287.819864] bus: 'pci': add driver via_wdt
[  287.826520] w83627hf_wdt: WDT driver for the Winbond(TM) W83627HF/THF/HG=
/DHG Super I/O chip initialising
[  287.831871] w83627hf_wdt: Watchdog already running. Resetting timeout to=
 60 sec
[  287.835024] w83627hf_wdt: cannot register miscdev on minor=3D130 (err=3D=
-16)
[  287.836320] w83697ug_wdt: WDT driver for the Winbond(TM) W83697UG/UF Sup=
er I/O chip initialising
[  287.839506] w83697ug_wdt: No W83697UG/UF could be found
[  287.842340] w83977f_wdt: driver v1.00
[  287.845071] w83977f_wdt: cannot register miscdev on minor=3D130 (err=3D-=
16)
[  287.846311] machzwd: MachZ ZF-Logic Watchdog driver initializing
[  287.848915] machzwd: no ZF-Logic found
[  287.850281] sbc_epx_c3: cannot register miscdev on minor=3D130 (err=3D-1=
6)
[  287.853041] bus: 'platform': add driver da9052-watchdog
[  287.859223] bus: 'platform': add driver wm8350-wdt
[  287.869510] watchdog: Software Watchdog: cannot register miscdev on mino=
r=3D130 (err=3D-16).
[  287.872292] watchdog: Software Watchdog: a legacy watchdog module is pro=
bably present.
[  287.879810] device: 'watchdog1': device_add
[  287.892577] PM: Adding info for No Bus:watchdog1
[  287.899110] softdog: Software Watchdog Timer: 0.08 initialized. soft_nob=
oot=3D0 soft_margin=3D60 sec soft_panic=3D0 (nowayout=3D0)
[  287.902385] EDAC MC: Ver: 3.0.0
[  287.916955] bus: 'edac': registered
[  287.919386] device: 'edac': device_add
[  287.922556] PM: Adding info for No Bus:edac
[  287.926218] device: 'mc': device_add
[  287.929362] bus: 'edac': add device mc
[  287.932569] PM: Adding info for edac:mc
[  287.935872] EDAC DEBUG: edac_mc_sysfs_init: device mc created
[  287.949017] EDAC DEBUG: i5000_init: MC:
[  287.949939] bus: 'pci': add driver i5000_edac
[  287.959201] bus: 'pci': add driver i5100_edac
[  287.966586] EDAC DEBUG: i5400_init: MC:
[  287.969225] bus: 'pci': add driver i5400_edac
[  287.976014] EDAC DEBUG: i7300_init:=20
[  287.978606] bus: 'pci': add driver i7300_edac
[  287.985694] bus: 'pci': add driver e7xxx_edac
[  287.992615] bus: 'pci': add driver i82875p_edac
[  288.002070] EDAC DEBUG: i82875p_init: 875p pci_get_device fail
[  288.005977] bus: 'pci': remove driver i82875p_edac
[  288.009255] driver: 'i82875p_edac': driver_release
[  288.011996] bus: 'pci': add driver i82975x_edac
[  288.019913] EDAC DEBUG: i82975x_init: i82975x pci_get_device fail
[  288.025222] bus: 'pci': remove driver i82975x_edac
[  288.028562] driver: 'i82975x_edac': driver_release
[  288.055127] bus: 'memstick': registered
[  288.056023] device class 'memstick_host': registering
[  288.059543] EFI Variables Facility v0.08 2004-May-17
[  288.065895] bus: 'hid': registered
[  288.070292] bus: 'hid': add driver hid-generic
[  288.076314] bus: 'platform': add driver olpc-ec
[  288.082466] device class 'extcon': registering
[  288.086267] bus: 'platform': add driver extcon-gpio
[  288.099047] oprofile: using timer interrupt.
[  288.129980]=20
[  288.129980] printing PIC contents
[  288.132537] ... PIC  IMR: ec78
[  288.133204] ... PIC  IRR: 0010
[  288.135520] ... PIC  ISR: 0000
[  288.136239] ... PIC ELCR: 0200
[  288.138604] Using IPI Shortcut mode
[  288.142011] device: 'cpu_dma_latency': device_add
[  288.152693] PM: Adding info for No Bus:cpu_dma_latency
[  288.158624] device: 'network_latency': device_add
[  288.169047] PM: Adding info for No Bus:network_latency
[  288.172588] device: 'network_throughput': device_add
[  288.182491] PM: Adding info for No Bus:network_throughput
[  288.188489] Running tests on trace events:
[  288.189361] Testing event kfree_skb: OK
[  288.266259] Testing event consume_skb: OK
[  288.308547] Testing event skb_copy_datagram_iovec: OK
[  288.349182] Testing event net_dev_xmit: OK
[  288.391720] Testing event net_dev_queue: OK
[  288.434982] Testing event netif_receive_skb: OK
[  288.475642] Testing event netif_rx: OK
[  288.518572] Testing event napi_poll: OK
[  288.561627] Testing event sock_rcvqueue_full: OK
[  288.602194] Testing event sock_exceed_buf_limit: OK
[  288.644963] Testing event udp_fail_queue_rcv_skb: OK
[  288.688956] Testing event mc_event: OK
[  288.731888] Testing event docg3_io: OK
[  288.775076] Testing event regmap_reg_write: OK
[  288.812599] Testing event regmap_reg_read: OK
[  288.852293] Testing event regmap_reg_read_cache: OK
[  288.895185] Testing event regmap_hw_read_start: OK
[  288.938555] Testing event regmap_hw_read_done: OK
[  288.979086] Testing event regmap_hw_write_start: OK
[  289.021834] Testing event regmap_hw_write_done: OK
[  289.062445] Testing event regcache_sync: OK
[  289.104963] Testing event regmap_cache_only: OK
[  289.132811] Testing event regmap_cache_bypass: OK
[  289.185627] Testing event drm_vblank_event: OK
[  289.225487] Testing event drm_vblank_event_queued: OK
[  289.265725] Testing event drm_vblank_event_delivered: OK
[  289.305623] Testing event mix_pool_bytes: OK
[  289.345570] Testing event mix_pool_bytes_nolock: OK
[  289.385471] Testing event credit_entropy_bits: OK
[  289.428536] Testing event get_random_bytes: OK
[  289.471983] Testing event extract_entropy: OK
[  289.512344] Testing event extract_entropy_user: OK
[  289.554936] Testing event regulator_enable: OK
[  289.595540] Testing event regulator_enable_delay: OK
[  289.635745] Testing event regulator_enable_complete: OK
[  289.675545] Testing event regulator_disable: OK
[  289.718546] Testing event regulator_disable_complete: OK
[  289.759007] Testing event regulator_set_voltage: OK
[  289.801774] Testing event regulator_set_voltage_complete: OK
[  289.842525] Testing event gpio_direction: OK
[  289.882369] Testing event gpio_value: OK
[  289.925041] Testing event writeback_nothread: OK
[  289.968679] Testing event writeback_queue: OK
[  290.009048] Testing event writeback_exec: OK
[  290.051741] Testing event writeback_start: OK
[  290.092350] Testing event writeback_written: OK
[  290.135177] Testing event writeback_wait: OK
[  290.178510] Testing event writeback_pages_written: OK
[  290.219063] Testing event writeback_nowork: OK
[  290.261854] Testing event writeback_wake_background: OK
[  290.302355] Testing event writeback_wake_thread: OK
[  290.342349] Testing event writeback_wake_forker_thread: OK
[  290.384910] Testing event writeback_bdi_register: OK
[  290.425476] Testing event writeback_bdi_unregister: OK
[  290.465582] Testing event writeback_thread_start: OK
[  290.505756] Testing event writeback_thread_stop: OK
[  290.548594] Testing event wbc_writepage: OK
[  290.591702] Testing event writeback_queue_io: OK
[  290.629461] Testing event global_dirty_state: OK
[  290.668923] Testing event bdi_dirty_ratelimit: OK
[  290.708970] Testing event balance_dirty_pages: OK
[  290.751764] Testing event writeback_sb_inodes_requeue: OK
[  290.794939] Testing event writeback_congestion_wait: OK
[  290.835620] Testing event writeback_wait_iff_congested: OK
[  290.878648] Testing event writeback_single_inode: OK
[  290.919090] Testing event mm_compaction_isolate_migratepages: OK
[  290.961610] Testing event mm_compaction_isolate_freepages: OK
[  291.005387] Testing event mm_compaction_migratepages: OK
[  291.045559] Testing event kmalloc: OK
[  291.085688] Testing event kmem_cache_alloc: OK
[  291.116171] Testing event kmalloc_node: OK
[  291.171682] Testing event kmem_cache_alloc_node: OK
[  291.212444] Testing event kfree: OK
[  291.255508] Testing event kmem_cache_free: OK
[  291.298997] Testing event mm_page_free: OK
[  291.341869] Testing event mm_page_free_batched: OK
[  291.382462] Testing event mm_page_alloc: OK
[  291.425628] Testing event mm_page_alloc_zone_locked: OK
[  291.456008] Testing event mm_page_pcpu_drain: OK
[  291.496190] Testing event mm_page_alloc_extfrag: OK
[  291.548670] Testing event mm_vmscan_kswapd_sleep: OK
[  291.589175] Testing event mm_vmscan_kswapd_wake: OK
[  291.629168] Testing event mm_vmscan_wakeup_kswapd: OK
[  291.669101] Testing event mm_vmscan_direct_reclaim_begin: OK
[  291.711767] Testing event mm_vmscan_memcg_reclaim_begin: OK
[  291.752326] Testing event mm_vmscan_memcg_softlimit_reclaim_begin: OK
[  291.792402] Testing event mm_vmscan_direct_reclaim_end: OK
[  291.832509] Testing event mm_vmscan_memcg_reclaim_end: OK
[  291.874886] Testing event mm_vmscan_memcg_softlimit_reclaim_end: OK
[  291.915547] Testing event mm_shrink_slab_start: OK
[  291.955570] Testing event mm_shrink_slab_end: OK
[  291.998857] Testing event mm_vmscan_lru_isolate: OK
[  292.041872] Testing event mm_vmscan_memcg_isolate: OK
[  292.085158] Testing event mm_vmscan_writepage: OK
[  292.125741] Testing event mm_vmscan_lru_shrink_inactive: OK
[  292.168379] Testing event oom_score_adj_update: OK
[  292.195961] Testing event cpu_idle: OK
[  292.235854] Testing event cpu_frequency: OK
[  292.275979] Testing event machine_suspend: OK
[  292.315815] Testing event wakeup_source_activate: OK
[  292.355936] Testing event wakeup_source_deactivate: OK
[  292.408966] Testing event power_start: OK
[  292.448950] Testing event power_frequency: OK
[  292.488820] Testing event power_end: OK
[  292.528790] Testing event clock_enable: OK
[  292.555883] Testing event clock_disable: OK
[  292.608808] Testing event clock_set_rate: OK
[  292.648922] Testing event power_domain_target: OK
[  292.688801] Testing event ftrace_test_filter: OK
[  292.728821] Testing event lock_acquire: OK
[  292.786477] Testing event lock_release: OK
[  292.855990] Testing event sched_kthread_stop: OK
[  292.908322] Testing event sched_kthread_stop_ret: OK
[  292.948300] Testing event sched_wakeup: OK
[  292.991746] Testing event sched_wakeup_new: OK
[  293.031746] Testing event sched_switch: OK
[  293.072769] Testing event sched_migrate_task: OK
[  293.112310] Testing event sched_process_free: OK
[  293.155155] Testing event sched_process_exit: OK
[  293.199013] Testing event sched_wait_task: OK
[  293.241742] Testing event sched_process_wait: OK
[  293.285028] Testing event sched_process_fork: OK
[  293.325685] Testing event sched_process_exec: OK
[  293.368672] Testing event sched_stat_wait: OK
[  293.403125] Testing event sched_stat_sleep: OK
[  293.446150] Testing event sched_stat_iowait: OK
[  293.495576] Testing event sched_stat_blocked: OK
[  293.526465] Testing event sched_stat_runtime: OK
[  293.586334] Testing event sched_pi_setprio: OK
[  293.631764] Testing event rcu_utilization: OK
[  293.666331] Testing event rcu_dyntick: [  293.712779] test-events (180) =
used greatest stack depth: 7008 bytes left
OK
[  293.716947] Testing event rcu_prep_idle: OK
[  293.763617] Testing event rcu_callback: OK
[  293.812348] Testing event rcu_kfree_callback: OK
[  293.852899] Testing event rcu_batch_start: OK
[  293.903295] Testing event rcu_invoke_callback: OK
[  293.944861] Testing event rcu_invoke_kfree_callback: OK
[  293.991610] Testing event rcu_batch_end: OK
[  294.039861] Testing event rcu_torture_read: OK
[  294.081647] Testing event rcu_barrier: OK
[  294.124896] Testing event workqueue_queue_work: OK
[  294.166657] Testing event workqueue_activate_work: OK
[  294.209766] Testing event workqueue_execute_start: OK
[  294.253044] Testing event workqueue_execute_end: OK
[  294.289602] Testing event signal_generate: OK
[  294.332821] Testing event signal_deliver: OK
[  294.373027] Testing event timer_init: OK
[  294.416326] Testing event timer_start: OK
[  294.465740] Testing event timer_expire_entry: OK
[  294.512594] Testing event timer_expire_exit: OK
[  294.566032] Testing event timer_cancel: OK
[  294.626898] Testing event hrtimer_init: OK
[  294.663298] Testing event hrtimer_start: OK
[  294.720186] Testing event hrtimer_expire_entry: OK
[  294.776493] Testing event hrtimer_expire_exit: OK
[  294.835897] Testing event hrtimer_cancel: OK
[  294.883607] Testing event itimer_state: OK
[  294.930207] Testing event itimer_expire: OK
[  294.985920] Testing event irq_handler_entry: OK
[  295.041810] Testing event irq_handler_exit: OK
[  295.096896] Testing event softirq_entry: OK
[  295.163289] Testing event softirq_exit: OK
[  295.201757] Testing event softirq_raise: OK
[  295.243239] Testing event console: OK
[  295.283012] Testing event task_newtask: OK
[  295.326387] Testing event task_rename: OK
[  295.366368] Testing event sys_enter: OK
[  295.413300] Testing event sys_exit: OK
[  295.465882] Running tests on trace event systems:
[  295.468764] Testing event system skb: OK
[  295.543325] Testing event system net: OK
[  295.616334] Testing event system napi: OK
[  295.656922] Testing event system sock: OK
[  295.709561] Testing event system udp: OK
[  295.758742] Testing event system ras: OK
[  295.808553] Testing event system docg3: OK
[  295.859716] Testing event system regmap: OK
[  295.936550] Testing event system drm: OK
[  295.976160] Testing event system random: OK
[  296.042935] Testing event system regulator: OK
[  296.103005] Testing event system gpio: OK
[  296.142630] Testing event system writeback: OK
[  296.279276] Testing event system compaction: OK
[  296.319977] Testing event system kmem: OK
[  296.422081] Testing event system vmscan: OK
[  296.518669] Testing event system oom: OK
[  296.559792] Testing event system power: OK
[  296.662897] Testing event system test: OK
[  296.706892] Testing event system lock: OK
[  296.833256] Testing event system sched: OK
[  296.956334] Testing event system rcu: OK
[  297.045081] Testing event system workqueue: OK
[  297.103550] Testing event system signal: OK
[  297.149068] Testing event system timer: OK
[  297.253207] Testing event system irq: OK
[  297.332955] Testing event system printk: OK
[  297.378747] Testing event system task: OK
[  297.435812] Testing event system syscalls: OK
[  297.741815] Testing event system raw_syscalls: OK
[  297.789182] Running tests on all trace events:
[  297.789926] Testing all events: OK
[  302.412775] Running tests again, along with the function tracer
[  302.452512] Running tests on trace events:
[  302.482460] Testing event kfree_skb: OK
[  308.795892] Testing event consume_skb: OK
[  312.679455] Testing event skb_copy_datagram_iovec: OK
[  314.163356] Testing event net_dev_xmit: OK
[  315.869255] Testing event net_dev_queue: OK
[  319.016674] Testing event netif_receive_skb: OK
[  321.279213] Testing event netif_rx: OK
[  323.219749] Testing event napi_poll: [  324.385545] test-events (256) us=
ed greatest stack depth: 6968 bytes left
OK
[  325.809323] Testing event sock_rcvqueue_full: OK
[  329.079563] Testing event sock_exceed_buf_limit: OK
[  330.752486] Testing event udp_fail_queue_rcv_skb: OK
[  332.225960] Testing event mc_event: OK
[  335.875823] Testing event docg3_io: OK
[  337.772501] Testing event regmap_reg_write: OK
[  340.569723] Testing event regmap_reg_read: OK
[  343.119170] Testing event regmap_reg_read_cache: OK
[  345.519972] Testing event regmap_hw_read_start: OK
[  347.365723] Testing event regmap_hw_read_done: OK
[  349.052518] Testing event regmap_hw_write_start: OK
[  353.336073] Testing event regmap_hw_write_done: OK
[  356.962685] Testing event regcache_sync: OK
[  360.543450] Testing event regmap_cache_only: OK
[  361.662932] Testing event regmap_cache_bypass: OK
[  364.275999] Testing event drm_vblank_event: OK
[  366.375949] Testing event drm_vblank_event_queued: OK
[  369.360264] Testing event drm_vblank_event_delivered: OK
[  371.572520] Testing event mix_pool_bytes: OK
[  375.749396] Testing event mix_pool_bytes_nolock: OK
[  378.252343] Testing event credit_entropy_bits: OK
[  379.965901] Testing event get_random_bytes: OK
[  382.289240] Testing event extract_entropy: OK
[  386.272425] Testing event extract_entropy_user: OK
[  387.046281] Testing event regulator_enable: OK
[  388.279279] Testing event regulator_enable_delay: OK
[  390.058987] Testing event regulator_enable_complete: OK
[  391.906488] Testing event regulator_disable: OK
[  393.535687] Testing event regulator_disable_complete: OK
[  396.362076] Testing event regulator_set_voltage: OK
[  397.382621] Testing event regulator_set_voltage_complete: OK
[  399.223057] Testing event gpio_direction: OK
[  401.842305] Testing event gpio_value: OK
[  402.672572] Testing event writeback_nothread: OK
[  404.876454] Testing event writeback_queue: OK
[  406.722785] Testing event writeback_exec: OK
[  407.972661] Testing event writeback_start: OK
[  410.192274] Testing event writeback_written: OK
[  412.002509] Testing event writeback_wait: OK
[  414.022641] Testing event writeback_pages_written: OK
[  415.802474] Testing event writeback_nowork: OK
[  417.155719] Testing event writeback_wake_background: OK
[  420.962430] Testing event writeback_wake_thread: OK
[  423.562869] Testing event writeback_wake_forker_thread: OK
[  425.042294] Testing event writeback_bdi_register: OK
[  427.102993] Testing event writeback_bdi_unregister: OK
[  428.702580] Testing event writeback_thread_start: OK
[  430.729208] Testing event writeback_thread_stop: OK
[  431.962712] Testing event wbc_writepage: OK
[  433.679093] Testing event writeback_queue_io: [  435.056387] test-events=
 (306) used greatest stack depth: 6752 bytes left
OK
[  435.296299] Testing event global_dirty_state: OK
[  436.885929] Testing event bdi_dirty_ratelimit: OK
[  438.832439] Testing event balance_dirty_pages: OK
[  440.609258] Testing event writeback_sb_inodes_requeue: OK
[  443.109022] Testing event writeback_congestion_wait: OK
[  446.275855] Testing event writeback_wait_iff_congested: OK
[  449.049207] Testing event writeback_single_inode: OK
[  451.416078] Testing event mm_compaction_isolate_migratepages: OK
[  453.009415] Testing event mm_compaction_isolate_freepages: OK
[  456.883126] Testing event mm_compaction_migratepages: OK
[  459.603271] Testing event kmalloc: OK
[  461.176584] Testing event kmem_cache_alloc: OK
[  465.109336] Testing event kmalloc_node: OK
[  469.225862] Testing event kmem_cache_alloc_node: OK
[  471.639239] Testing event kfree: OK
[  473.545968] Testing event kmem_cache_free: OK
[  477.989186] Testing event mm_page_free: OK
[  479.839617] Testing event mm_page_free_batched: OK
[  482.062637] Testing event mm_page_alloc: OK
[  483.675745] Testing event mm_page_alloc_zone_locked: OK
[  486.159139] Testing event mm_page_pcpu_drain: OK
[  489.135689] Testing event mm_page_alloc_extfrag: OK
[  490.802704] Testing event mm_vmscan_kswapd_sleep: OK
[  493.679228] Testing event mm_vmscan_kswapd_wake: OK
[  496.132484] Testing event mm_vmscan_wakeup_kswapd: OK
[  498.553397] Testing event mm_vmscan_direct_reclaim_begin: OK
[  502.772751] Testing event mm_vmscan_memcg_reclaim_begin: OK
[  505.809625] Testing event mm_vmscan_memcg_softlimit_reclaim_begin: OK
[  509.715921] Testing event mm_vmscan_direct_reclaim_end: OK
[  511.809001] Testing event mm_vmscan_memcg_reclaim_end: [  512.852980] IN=
FO: task rb_producer:17 blocked for more than 120 seconds.
[  513.279212] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables =
this message.

[  513.372982] rb_producer     DOK
[  513.488959] Testing event mm_vmscan_memcg_softlimit_reclaim_end:=20
[  514.249175]  cd813900  6900    17      2 0x00000000
[  514.494974]  c7789eac 00000046 c1127799 cd813900 00000246 00000001 cd838=
000 c7681340
[  514.769277]  00000001 7ec30bc3 00000055 c7681340 c7789e84 c114679d 00000=
001 00000001
[  515.069410]  cd83084c 00000246 cd813900 c1c9e840 c1789163 c17853eb c7789=
e9c c11200ae
[  515.206195] Call Trace:
[  515.222906]  [<c1127799>] ? ring_buffer_unlock_commit+0x189/0x210
[  515.289603]  [<c114679d>] ? function_test_events_call+0xad/0x190
[  515.419846]  [<c1789163>] ? schedule+0x3/0x40
[  515.439615]  [<c17853eb>] ? schedule_timeout+0x36b/0x4a0
[  515.462580]  [<c11200ae>] ? ftrace_ops_list_func+0x10e/0x160
[  515.486038]  [<c1789163>] ? schedule+0x3/0x40
[  515.793211]  [<c1789182>] schedule+0x22/0x40
[  515.812775]  [<c17853eb>] schedule_timeout+0x36b/0x4a0
[  516.009245]  [<c10b4e7c>] ? sub_preempt_count+0xc/0x230
[  516.202924]  [<c178b7d7>] ? _raw_spin_unlock_irq+0xa7/0x130
[  516.283110]  [<c11200ae>] ? ftrace_ops_list_func+0x10e/0x160
[  516.329733]  [<c10b4e7c>] ? sub_preempt_count+0xc/0x230
[  516.353805]  [<c178dc11>] ? trace+0x13/0x1e
[  516.563198]  [<c10b508b>] ? sub_preempt_count+0x21b/0x230
[  516.666495]  [<c1789c1d>] wait_for_common+0x12d/0x380
[  516.960532]  [<c10b6ad0>] ? try_to_wake_up+0x390/0x390
[  517.139755]  [<c1789fc5>] wait_for_completion+0x25/0x40
[  517.338852]  [<c112ad8d>] ring_buffer_producer_thread+0x10d/0xa80
[  517.806063]  [<c112b49b>] ? ring_buffer_producer_thread+0x81b/0xa80
[  517.829747]  [<c112ac80>] ? ring_buffer_consumer_thread+0x880/0x880
[  518.005811]  [<c1099893>] kthread+0xd3/0xf0
[  518.026207]  [<c10997c0>] ? insert_kthread_work+0x190/0x190
[  518.049923]  [<c178dbba>] kernel_thread_helper+0x6/0x10
[  518.073116] no locks held by rb_producer/17.
[  518.093479] Kernel panic - not syncing: hung_task: blocked tasks
[  518.093479] Rebooting in 10 seconds..
--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.6.0-rc4-00087-gcb4f9a2"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.6.0-rc4 Kernel Configuration
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
# CONFIG_X86_64 is not set
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf32-i386"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_GENERIC_GPIO=y
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
# CONFIG_ZONE_DMA32 is not set
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_X86_32_LAZY_GS=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
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
CONFIG_BROKEN_ON_SMP=y
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
# CONFIG_SYSVIPC is not set
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_FHANDLE=y
# CONFIG_TASKSTATS is not set
# CONFIG_AUDIT is not set
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_IRQ_CHIP=y
CONFIG_IRQ_DOMAIN=y
# CONFIG_IRQ_DOMAIN_DEBUG is not set
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_KTIME_SCALAR=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y

#
# RCU Subsystem
#
CONFIG_TINY_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_RCU_BOOST=y
CONFIG_RCU_BOOST_PRIO=1
CONFIG_RCU_BOOST_DELAY=500
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_CGROUPS=y
CONFIG_CGROUP_DEBUG=y
# CONFIG_CGROUP_FREEZER is not set
CONFIG_CGROUP_DEVICE=y
# CONFIG_CPUSETS is not set
CONFIG_CGROUP_CPUACCT=y
# CONFIG_RESOURCE_COUNTERS is not set
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CHECKPOINT_RESTORE=y
# CONFIG_NAMESPACES is not set
# CONFIG_SCHED_AUTOGROUP is not set
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
# CONFIG_RD_LZMA is not set
# CONFIG_RD_XZ is not set
CONFIG_RD_LZO=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_EXPERT=y
# CONFIG_UID16 is not set
CONFIG_SYSCTL_SYSCALL=y
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
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_PERF_USE_VMALLOC=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
CONFIG_DEBUG_PERF_USE_VMALLOC=y
# CONFIG_VM_EVENT_COUNTERS is not set
CONFIG_PCI_QUIRKS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_OPROFILE=y
# CONFIG_OPROFILE_EVENT_MULTIPLEX is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_JUMP_LABEL is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_HAVE_DMA_CONTIGUOUS=y
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
CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y

#
# GCOV-based kernel profiling
#
CONFIG_GCOV_KERNEL=y
CONFIG_GCOV_PROFILE_ALL=y
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
# CONFIG_BLOCK is not set
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
CONFIG_ZONE_DMA=y
# CONFIG_SMP is not set
CONFIG_X86_MPPARSE=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
# CONFIG_X86_32_IRIS is not set
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_PARAVIRT_GUEST=y
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
# CONFIG_KVM_CLOCK is not set
CONFIG_KVM_GUEST=y
# CONFIG_LGUEST_GUEST is not set
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
CONFIG_NO_BOOTMEM=y
# CONFIG_MEMTEST is not set
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
CONFIG_M686=y
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MELAN is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_X86_GENERIC=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_XADD=y
CONFIG_X86_PPRO_FENCE=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=5
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_PROCESSOR_SELECT=y
# CONFIG_CPU_SUP_INTEL is not set
# CONFIG_CPU_SUP_CYRIX_32 is not set
# CONFIG_CPU_SUP_AMD is not set
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
# CONFIG_CPU_SUP_UMC_32 is not set
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
# CONFIG_IOMMU_HELPER is not set
CONFIG_NR_CPUS=1
CONFIG_IRQ_TIME_ACCOUNTING=y
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_UP_APIC=y
CONFIG_X86_UP_IOAPIC=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
# CONFIG_X86_MCE is not set
CONFIG_VM86=y
# CONFIG_TOSHIBA is not set
CONFIG_I8K=y
# CONFIG_X86_REBOOTFIXUPS is not set
# CONFIG_MICROCODE is not set
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
# CONFIG_ARCH_PHYS_ADDR_T_64BIT is not set
# CONFIG_ARCH_DMA_ADDR_T_64BIT is not set
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ILLEGAL_POINTER_VALUE=0
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
# CONFIG_CROSS_MEMORY_ATTACH is not set
CONFIG_NEED_PER_CPU_KM=y
# CONFIG_CLEANCACHE is not set
CONFIG_HIGHPTE=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MATH_EMULATION is not set
# CONFIG_MTRR is not set
CONFIG_ARCH_RANDOM=y
CONFIG_EFI=y
# CONFIG_EFI_STUB is not set
# CONFIG_SECCOMP is not set
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=y
# CONFIG_HZ_1000 is not set
CONFIG_HZ=300
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_PM_SLEEP=y
# CONFIG_PM_AUTOSLEEP is not set
CONFIG_PM_WAKELOCKS=y
CONFIG_PM_WAKELOCKS_LIMIT=100
CONFIG_PM_WAKELOCKS_GC=y
# CONFIG_PM_RUNTIME is not set
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS=y
# CONFIG_ACPI_PROCFS_POWER is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_PROC_EVENT=y
# CONFIG_ACPI_AC is not set
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_PROCESSOR is not set
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
CONFIG_ACPI_DEBUG=y
# CONFIG_ACPI_DEBUG_FUNC_TRACE is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_SBS=y
# CONFIG_ACPI_HED is not set
CONFIG_ACPI_CUSTOM_METHOD=y
CONFIG_ACPI_BGRT=y
CONFIG_ACPI_APEI=y
# CONFIG_ACPI_APEI_GHES is not set
CONFIG_ACPI_APEI_PCIEAER=y
CONFIG_ACPI_APEI_EINJ=y
CONFIG_ACPI_APEI_ERST_DEBUG=y
CONFIG_SFI=y
# CONFIG_APM is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_STAT=y
CONFIG_CPU_FREQ_STAT_DETAILS=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set

#
# x86 CPU frequency scaling drivers
#
# CONFIG_X86_POWERNOW_K6 is not set
CONFIG_X86_POWERNOW_K7=y
CONFIG_X86_GX_SUSPMOD=y
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
CONFIG_X86_SPEEDSTEP_ICH=y
# CONFIG_X86_P4_CLOCKMOD is not set
# CONFIG_X86_LONGRUN is not set

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y
CONFIG_X86_SPEEDSTEP_RELAXED_CAP_CHECK=y
# CONFIG_CPU_IDLE is not set
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
# CONFIG_PCI_GOOLPC is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_OLPC=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCIEPORTBUS=y
CONFIG_PCIEAER=y
CONFIG_PCIE_ECRC=y
CONFIG_PCIEAER_INJECT=y
CONFIG_PCIEASPM=y
CONFIG_PCIEASPM_DEBUG=y
# CONFIG_PCIEASPM_DEFAULT is not set
# CONFIG_PCIEASPM_POWERSAVE is not set
CONFIG_PCIEASPM_PERFORMANCE=y
CONFIG_ARCH_SUPPORTS_MSI=y
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
CONFIG_PCI_STUB=y
CONFIG_HT_IRQ=y
CONFIG_PCI_ATS=y
# CONFIG_PCI_IOV is not set
CONFIG_PCI_PRI=y
# CONFIG_PCI_PASID is not set
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
CONFIG_SCx200=y
CONFIG_SCx200HR_TIMER=y
CONFIG_OLPC=y
# CONFIG_OLPC_XO15_SCI is not set
# CONFIG_ALIX is not set
# CONFIG_NET5501 is not set
# CONFIG_GEOS is not set
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_RAPIDIO is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_HAVE_AOUT=y
# CONFIG_BINFMT_AOUT is not set
# CONFIG_BINFMT_MISC is not set
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_HAVE_TEXT_POKE_SMP=y
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
# CONFIG_NETFILTER is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_PHONET is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
# CONFIG_NETPRIO_CGROUP is not set
CONFIG_BQL=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
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

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
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
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_SPI=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y
# CONFIG_CONNECTOR is not set
CONFIG_MTD=y
# CONFIG_MTD_REDBOOT_PARTS is not set
# CONFIG_MTD_CMDLINE_PARTS is not set
CONFIG_MTD_OF_PARTS=y
CONFIG_MTD_AR7_PARTS=y

#
# User Modules And Translation Layers
#
CONFIG_MTD_CHAR=y
# CONFIG_MTD_OOPS is not set

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=y
CONFIG_MTD_JEDECPROBE=y
CONFIG_MTD_GEN_PROBE=y
CONFIG_MTD_CFI_ADV_OPTIONS=y
CONFIG_MTD_CFI_NOSWAP=y
# CONFIG_MTD_CFI_BE_BYTE_SWAP is not set
# CONFIG_MTD_CFI_LE_BYTE_SWAP is not set
CONFIG_MTD_CFI_GEOMETRY=y
# CONFIG_MTD_MAP_BANK_WIDTH_1 is not set
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
CONFIG_MTD_MAP_BANK_WIDTH_32=y
CONFIG_MTD_CFI_I1=y
# CONFIG_MTD_CFI_I2 is not set
# CONFIG_MTD_CFI_I4 is not set
CONFIG_MTD_CFI_I8=y
# CONFIG_MTD_OTP is not set
CONFIG_MTD_CFI_INTELEXT=y
CONFIG_MTD_CFI_AMDSTD=y
# CONFIG_MTD_CFI_STAA is not set
CONFIG_MTD_CFI_UTIL=y
CONFIG_MTD_RAM=y
# CONFIG_MTD_ROM is not set
# CONFIG_MTD_ABSENT is not set

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=y
CONFIG_MTD_PHYSMAP=y
# CONFIG_MTD_PHYSMAP_COMPAT is not set
# CONFIG_MTD_PHYSMAP_OF is not set
CONFIG_MTD_SC520CDP=y
# CONFIG_MTD_NETSC520 is not set
CONFIG_MTD_TS5500=y
CONFIG_MTD_SBC_GXX=y
CONFIG_MTD_SCx200_DOCFLASH=y
# CONFIG_MTD_AMD76XROM is not set
CONFIG_MTD_ICHXROM=y
CONFIG_MTD_ESB2ROM=y
CONFIG_MTD_CK804XROM=y
# CONFIG_MTD_SCB2_FLASH is not set
# CONFIG_MTD_NETtel is not set
CONFIG_MTD_L440GX=y
# CONFIG_MTD_PCI is not set
CONFIG_MTD_GPIO_ADDR=y
# CONFIG_MTD_INTEL_VR_NOR is not set
# CONFIG_MTD_PLATRAM is not set
# CONFIG_MTD_LATCH_ADDR is not set

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
# CONFIG_MTD_SST25L is not set
CONFIG_MTD_SLRAM=y
# CONFIG_MTD_PHRAM is not set
# CONFIG_MTD_MTDRAM is not set

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOCG3=y
CONFIG_BCH_CONST_M=14
CONFIG_BCH_CONST_T=4
# CONFIG_MTD_NAND is not set
CONFIG_MTD_ONENAND=y
# CONFIG_MTD_ONENAND_VERIFY_WRITE is not set
# CONFIG_MTD_ONENAND_GENERIC is not set
# CONFIG_MTD_ONENAND_OTP is not set
CONFIG_MTD_ONENAND_2X_PROGRAM=y
CONFIG_MTD_ONENAND_SIM=y

#
# LPDDR flash memory drivers
#
CONFIG_MTD_LPDDR=y
CONFIG_MTD_QINFO_PROBE=y
# CONFIG_MTD_UBI is not set
CONFIG_OF=y

#
# Device Tree and Open Firmware support
#
# CONFIG_PROC_DEVICETREE is not set
# CONFIG_OF_SELFTEST is not set
CONFIG_OF_PROMTREE=y
CONFIG_OF_ADDRESS=y
CONFIG_OF_IRQ=y
CONFIG_OF_DEVICE=y
CONFIG_OF_I2C=y
CONFIG_OF_PCI=y
CONFIG_OF_PCI_IRQ=y
CONFIG_OF_MTD=y
CONFIG_PARPORT=y
CONFIG_PARPORT_PC=y
# CONFIG_PARPORT_SERIAL is not set
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
# CONFIG_PARPORT_1284 is not set
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_PNPACPI=y

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
# CONFIG_AD525X_DPOT is not set
# CONFIG_PHANTOM is not set
# CONFIG_INTEL_MID_PTI is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_HP_ILO is not set
CONFIG_APDS9802ALS=y
CONFIG_ISL29003=y
# CONFIG_ISL29020 is not set
CONFIG_SENSORS_TSL2550=y
CONFIG_SENSORS_BH1780=y
# CONFIG_SENSORS_BH1770 is not set
# CONFIG_SENSORS_APDS990X is not set
# CONFIG_HMC6352 is not set
CONFIG_TI_DAC7512=y
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
CONFIG_BMP085_I2C=y
CONFIG_BMP085_SPI=y
CONFIG_PCH_PHUB=y
# CONFIG_USB_SWITCH_FSA9480 is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
CONFIG_EEPROM_AT25=y
# CONFIG_EEPROM_LEGACY is not set
CONFIG_EEPROM_93CX6=y
# CONFIG_EEPROM_93XX46 is not set
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=y
CONFIG_HAVE_IDE=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_SCSI_DMA is not set
# CONFIG_SCSI_NETLINK is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=y
CONFIG_FIREWIRE_OHCI=y
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
# CONFIG_NETDEVICES is not set
# CONFIG_ISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
# CONFIG_INPUT_POLLDEV is not set
# CONFIG_INPUT_SPARSEKMAP is not set
# CONFIG_INPUT_MATRIXKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_EVDEV is not set
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5520 is not set
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_STMPE is not set
# CONFIG_KEYBOARD_OMAP4 is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_SENTELIC is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_PS2_OLPC is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_GPIO is not set
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
# CONFIG_MOUSE_SYNAPTICS_USB is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_SERIO_PS2MULT is not set
CONFIG_GAMEPORT=y
# CONFIG_GAMEPORT_NS558 is not set
# CONFIG_GAMEPORT_L4 is not set
CONFIG_GAMEPORT_EMU10K1=y
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
CONFIG_ROCKETPORT=y
CONFIG_CYCLADES=y
# CONFIG_MOXA_INTELLIO is not set
# CONFIG_MOXA_SMARTIO is not set
# CONFIG_SYNCLINK is not set
# CONFIG_SYNCLINKMP is not set
CONFIG_SYNCLINK_GT=y
CONFIG_ISI=y
# CONFIG_N_HDLC is not set
CONFIG_TRACE_ROUTER=y
CONFIG_TRACE_SINK=y
# CONFIG_DEVKMEM is not set
# CONFIG_STALDRV is not set

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
# CONFIG_SERIAL_8250_DW is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
# CONFIG_SERIAL_MAX3107 is not set
CONFIG_SERIAL_MRST_MAX3110=y
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=y
# CONFIG_SERIAL_OF_PLATFORM is not set
# CONFIG_SERIAL_TIMBERDALE is not set
CONFIG_SERIAL_ALTERA_JTAGUART=y
# CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE is not set
# CONFIG_SERIAL_ALTERA_UART is not set
CONFIG_SERIAL_PCH_UART=y
# CONFIG_SERIAL_PCH_UART_CONSOLE is not set
CONFIG_SERIAL_XILINX_PS_UART=y
CONFIG_SERIAL_XILINX_PS_UART_CONSOLE=y
# CONFIG_TTY_PRINTK is not set
# CONFIG_PRINTER is not set
# CONFIG_PPDEV is not set
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=y
CONFIG_IPMI_PANIC_EVENT=y
# CONFIG_IPMI_PANIC_STRING is not set
# CONFIG_IPMI_DEVICE_INTERFACE is not set
CONFIG_IPMI_SI=y
# CONFIG_IPMI_WATCHDOG is not set
CONFIG_IPMI_POWEROFF=y
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=y
# CONFIG_HW_RANDOM_INTEL is not set
CONFIG_HW_RANDOM_AMD=y
# CONFIG_HW_RANDOM_GEODE is not set
CONFIG_HW_RANDOM_VIA=y
# CONFIG_HW_RANDOM_VIRTIO is not set
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
# CONFIG_SCx200_GPIO is not set
CONFIG_PC8736x_GPIO=y
CONFIG_NSC_GPIO=y
CONFIG_HPET=y
# CONFIG_HPET_MMAP is not set
# CONFIG_HANGCHECK_TIMER is not set
CONFIG_TCG_TPM=y
# CONFIG_TCG_TIS is not set
CONFIG_TCG_NSC=y
# CONFIG_TCG_ATMEL is not set
CONFIG_TCG_INFINEON=y
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
# CONFIG_I2C_CHARDEV is not set
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
# CONFIG_I2C_MUX_GPIO is not set
# CONFIG_I2C_HELPER_AUTO is not set
CONFIG_I2C_SMBUS=y

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=y
# CONFIG_I2C_ALGOPCF is not set
CONFIG_I2C_ALGOPCA=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
CONFIG_I2C_ALI15X3=y
# CONFIG_I2C_AMD756 is not set
CONFIG_I2C_AMD8111=y
# CONFIG_I2C_I801 is not set
CONFIG_I2C_ISCH=y
# CONFIG_I2C_PIIX4 is not set
CONFIG_I2C_NFORCE2=y
# CONFIG_I2C_SIS5595 is not set
CONFIG_I2C_SIS630=y
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_DESIGNWARE_PCI=y
CONFIG_I2C_EG20T=y
# CONFIG_I2C_GPIO is not set
CONFIG_I2C_INTEL_MID=y
# CONFIG_I2C_PCA_PLATFORM is not set
CONFIG_I2C_PXA=y
CONFIG_I2C_PXA_PCI=y
# CONFIG_I2C_SIMTEC is not set

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT=y
# CONFIG_I2C_PARPORT_LIGHT is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_SCx200_ACB is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
CONFIG_I2C_DEBUG_BUS=y
CONFIG_SPI=y
CONFIG_SPI_DEBUG=y
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
CONFIG_SPI_ALTERA=y
CONFIG_SPI_BITBANG=y
CONFIG_SPI_BUTTERFLY=y
CONFIG_SPI_GPIO=y
CONFIG_SPI_OC_TINY=y
# CONFIG_SPI_PXA2XX_PCI is not set
# CONFIG_SPI_TOPCLIFF_PCH is not set
# CONFIG_SPI_XCOMM is not set
CONFIG_SPI_DESIGNWARE=y
CONFIG_SPI_DW_PCI=y

#
# SPI Protocol Masters
#
CONFIG_SPI_TLE62X0=y
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
CONFIG_GPIOLIB=y
CONFIG_OF_GPIO=y
CONFIG_DEBUG_GPIO=y
CONFIG_GPIO_GENERIC=y
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers:
#
# CONFIG_GPIO_GENERIC_PLATFORM is not set
# CONFIG_GPIO_IT8761E is not set
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_VX855 is not set

#
# I2C GPIO expanders:
#
CONFIG_GPIO_MAX7300=y
# CONFIG_GPIO_MAX732X is not set
CONFIG_GPIO_PCA953X=y
CONFIG_GPIO_PCA953X_IRQ=y
CONFIG_GPIO_PCF857X=y
CONFIG_GPIO_RC5T583=y
# CONFIG_GPIO_SX150X is not set
# CONFIG_GPIO_STMPE is not set
# CONFIG_GPIO_TPS65912 is not set
# CONFIG_GPIO_WM831X is not set
CONFIG_GPIO_WM8350=y
CONFIG_GPIO_WM8994=y
# CONFIG_GPIO_ADP5520 is not set
CONFIG_GPIO_ADP5588=y
# CONFIG_GPIO_ADP5588_IRQ is not set

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_BT8XX is not set
# CONFIG_GPIO_AMD8111 is not set
CONFIG_GPIO_LANGWELL=y
# CONFIG_GPIO_PCH is not set
CONFIG_GPIO_ML_IOH=y
CONFIG_GPIO_SODAVILLE=y
# CONFIG_GPIO_RDC321X is not set

#
# SPI GPIO expanders:
#
# CONFIG_GPIO_MAX7301 is not set
CONFIG_GPIO_MCP23S08=y
# CONFIG_GPIO_MC33880 is not set
CONFIG_GPIO_74X164=y

#
# AC97 GPIO expanders:
#

#
# MODULbus GPIO expanders:
#
# CONFIG_GPIO_TPS6586X is not set
CONFIG_GPIO_TPS65910=y
CONFIG_W1=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
# CONFIG_W1_MASTER_DS1WM is not set
CONFIG_W1_MASTER_GPIO=y

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
CONFIG_W1_SLAVE_SMEM=y
# CONFIG_W1_SLAVE_DS2408 is not set
CONFIG_W1_SLAVE_DS2423=y
CONFIG_W1_SLAVE_DS2431=y
# CONFIG_W1_SLAVE_DS2433 is not set
# CONFIG_W1_SLAVE_DS2760 is not set
CONFIG_W1_SLAVE_DS2780=y
# CONFIG_W1_SLAVE_DS2781 is not set
# CONFIG_W1_SLAVE_DS28E04 is not set
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_MAX8925_POWER is not set
# CONFIG_WM831X_BACKUP is not set
CONFIG_WM831X_POWER=y
CONFIG_WM8350_POWER=y
CONFIG_TEST_POWER=y
CONFIG_BATTERY_DS2780=y
# CONFIG_BATTERY_DS2781 is not set
CONFIG_BATTERY_DS2782=y
CONFIG_BATTERY_OLPC=y
CONFIG_BATTERY_SBS=y
CONFIG_BATTERY_BQ27x00=y
# CONFIG_BATTERY_BQ27X00_I2C is not set
CONFIG_BATTERY_BQ27X00_PLATFORM=y
# CONFIG_BATTERY_MAX17040 is not set
CONFIG_BATTERY_MAX17042=y
CONFIG_CHARGER_PCF50633=y
# CONFIG_CHARGER_MAX8903 is not set
CONFIG_CHARGER_LP8727=y
# CONFIG_CHARGER_GPIO is not set
CONFIG_CHARGER_MANAGER=y
# CONFIG_CHARGER_MAX8997 is not set
# CONFIG_CHARGER_SMB347 is not set
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
# CONFIG_SENSORS_ADM1021 is not set
CONFIG_SENSORS_ADM1025=y
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
CONFIG_SENSORS_ADM1031=y
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_ADT7475 is not set
CONFIG_SENSORS_ASC7621=y
CONFIG_SENSORS_K10TEMP=y
# CONFIG_SENSORS_FAM15H_POWER is not set
# CONFIG_SENSORS_DS620 is not set
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_DA9052_ADC is not set
CONFIG_SENSORS_F71805F=y
# CONFIG_SENSORS_F71882FG is not set
CONFIG_SENSORS_F75375S=y
# CONFIG_SENSORS_FSCHMD is not set
CONFIG_SENSORS_G760A=y
CONFIG_SENSORS_GL518SM=y
# CONFIG_SENSORS_GL520SM is not set
# CONFIG_SENSORS_GPIO_FAN is not set
CONFIG_SENSORS_IBMAEM=y
CONFIG_SENSORS_IBMPEX=y
# CONFIG_SENSORS_IT87 is not set
CONFIG_SENSORS_JC42=y
CONFIG_SENSORS_LM63=y
CONFIG_SENSORS_LM70=y
# CONFIG_SENSORS_LM73 is not set
CONFIG_SENSORS_LM75=y
# CONFIG_SENSORS_LM77 is not set
CONFIG_SENSORS_LM78=y
CONFIG_SENSORS_LM80=y
CONFIG_SENSORS_LM83=y
CONFIG_SENSORS_LM85=y
CONFIG_SENSORS_LM87=y
CONFIG_SENSORS_LM90=y
CONFIG_SENSORS_LM92=y
CONFIG_SENSORS_LM93=y
CONFIG_SENSORS_LTC4151=y
CONFIG_SENSORS_LM95241=y
CONFIG_SENSORS_MAX1111=y
CONFIG_SENSORS_MAX16065=y
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_PCF8591 is not set
CONFIG_SENSORS_SHT15=y
# CONFIG_SENSORS_SHT21 is not set
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_EMC1403=y
# CONFIG_SENSORS_EMC2103 is not set
CONFIG_SENSORS_EMC6W201=y
CONFIG_SENSORS_SMSC47M1=y
CONFIG_SENSORS_SMSC47M192=y
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_SCH5627 is not set
# CONFIG_SENSORS_SCH5636 is not set
CONFIG_SENSORS_ADS1015=y
CONFIG_SENSORS_ADS7828=y
CONFIG_SENSORS_ADS7871=y
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83781D=y
CONFIG_SENSORS_W83791D=y
CONFIG_SENSORS_W83792D=y
CONFIG_SENSORS_W83627HF=y
# CONFIG_SENSORS_W83627EHF is not set
CONFIG_SENSORS_WM831X=y
# CONFIG_SENSORS_WM8350 is not set
# CONFIG_SENSORS_APPLESMC is not set
CONFIG_SENSORS_MC13783_ADC=y

#
# ACPI drivers
#
CONFIG_SENSORS_ACPI_POWER=y
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=y
CONFIG_DA9052_WATCHDOG=y
# CONFIG_WM831X_WATCHDOG is not set
CONFIG_WM8350_WATCHDOG=y
# CONFIG_ACQUIRE_WDT is not set
CONFIG_ADVANTECH_WDT=y
CONFIG_ALIM1535_WDT=y
CONFIG_ALIM7101_WDT=y
CONFIG_SP5100_TCO=y
CONFIG_SC520_WDT=y
CONFIG_SBC_FITPC2_WATCHDOG=y
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=y
CONFIG_IBMASR=y
# CONFIG_WAFER_WDT is not set
CONFIG_I6300ESB_WDT=y
# CONFIG_IE6XX_WDT is not set
CONFIG_ITCO_WDT=y
CONFIG_ITCO_VENDOR_SUPPORT=y
# CONFIG_IT8712F_WDT is not set
# CONFIG_HP_WATCHDOG is not set
# CONFIG_SC1200_WDT is not set
CONFIG_SCx200_WDT=y
# CONFIG_PC87413_WDT is not set
CONFIG_NV_TCO=y
CONFIG_60XX_WDT=y
CONFIG_SBC8360_WDT=y
CONFIG_SBC7240_WDT=y
CONFIG_CPU5_WDT=y
CONFIG_SMSC_SCH311X_WDT=y
CONFIG_SMSC37B787_WDT=y
CONFIG_VIA_WDT=y
CONFIG_W83627HF_WDT=y
# CONFIG_W83697HF_WDT is not set
CONFIG_W83697UG_WDT=y
# CONFIG_W83877F_WDT is not set
CONFIG_W83977F_WDT=y
CONFIG_MACHZ_WDT=y
CONFIG_SBC_EPX_C3_WATCHDOG=y

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set
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
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_88PM800 is not set
# CONFIG_MFD_88PM805 is not set
# CONFIG_MFD_SM501 is not set
CONFIG_HTC_PASIC3=y
# CONFIG_HTC_I2CPLD is not set
CONFIG_MFD_LM3533=y
# CONFIG_TPS6105X is not set
CONFIG_TPS65010=y
# CONFIG_TPS6507X is not set
CONFIG_MFD_TPS65217=y
CONFIG_MFD_TPS6586X=y
CONFIG_MFD_TPS65910=y
CONFIG_MFD_TPS65912=y
CONFIG_MFD_TPS65912_I2C=y
CONFIG_MFD_TPS65912_SPI=y
# CONFIG_TWL4030_CORE is not set
# CONFIG_TWL6040_CORE is not set
CONFIG_MFD_STMPE=y

#
# STMPE Interface Drivers
#
CONFIG_STMPE_I2C=y
# CONFIG_STMPE_SPI is not set
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_PMIC_DA903X is not set
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_SPI=y
CONFIG_MFD_DA9052_I2C=y
CONFIG_PMIC_ADP5520=y
# CONFIG_MFD_MAX77686 is not set
CONFIG_MFD_MAX77693=y
CONFIG_MFD_MAX8925=y
CONFIG_MFD_MAX8997=y
# CONFIG_MFD_MAX8998 is not set
# CONFIG_MFD_SEC_CORE is not set
# CONFIG_MFD_ARIZONA_I2C is not set
# CONFIG_MFD_ARIZONA_SPI is not set
CONFIG_MFD_WM8400=y
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
CONFIG_MFD_WM831X_SPI=y
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
CONFIG_MFD_WM8994=y
CONFIG_MFD_PCF50633=y
# CONFIG_PCF50633_ADC is not set
# CONFIG_PCF50633_GPIO is not set
CONFIG_MFD_MC13783=y
CONFIG_MFD_MC13XXX=y
# CONFIG_MFD_MC13XXX_SPI is not set
CONFIG_MFD_MC13XXX_I2C=y
CONFIG_ABX500_CORE=y
CONFIG_AB3100_CORE=y
CONFIG_AB3100_OTP=y
CONFIG_EZX_PCAP=y
# CONFIG_MFD_CS5535 is not set
# CONFIG_MFD_TIMBERDALE is not set
CONFIG_LPC_SCH=y
CONFIG_LPC_ICH=y
CONFIG_MFD_RDC321X=y
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_MFD_VX855=y
# CONFIG_MFD_WL1273_CORE is not set
CONFIG_MFD_TPS65090=y
CONFIG_MFD_AAT2870_CORE=y
CONFIG_MFD_RC5T583=y
CONFIG_MFD_PALMAS=y
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
CONFIG_REGULATOR_DUMMY=y
CONFIG_REGULATOR_FIXED_VOLTAGE=y
# CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
CONFIG_REGULATOR_GPIO=y
CONFIG_REGULATOR_AD5398=y
# CONFIG_REGULATOR_AAT2870 is not set
# CONFIG_REGULATOR_DA9052 is not set
CONFIG_REGULATOR_MC13XXX_CORE=y
CONFIG_REGULATOR_MC13783=y
CONFIG_REGULATOR_MC13892=y
# CONFIG_REGULATOR_ISL6271A is not set
# CONFIG_REGULATOR_MAX1586 is not set
# CONFIG_REGULATOR_MAX8649 is not set
CONFIG_REGULATOR_MAX8660=y
CONFIG_REGULATOR_MAX8925=y
CONFIG_REGULATOR_MAX8952=y
CONFIG_REGULATOR_MAX8997=y
CONFIG_REGULATOR_PCAP=y
CONFIG_REGULATOR_LP3971=y
# CONFIG_REGULATOR_LP3972 is not set
# CONFIG_REGULATOR_LP872X is not set
CONFIG_REGULATOR_PCF50633=y
CONFIG_REGULATOR_RC5T583=y
CONFIG_REGULATOR_AB3100=y
# CONFIG_REGULATOR_PALMAS is not set
# CONFIG_REGULATOR_TPS62360 is not set
# CONFIG_REGULATOR_TPS65023 is not set
# CONFIG_REGULATOR_TPS6507X is not set
CONFIG_REGULATOR_TPS65090=y
# CONFIG_REGULATOR_TPS65217 is not set
CONFIG_REGULATOR_TPS6524X=y
# CONFIG_REGULATOR_TPS6586X is not set
CONFIG_REGULATOR_TPS65910=y
CONFIG_REGULATOR_TPS65912=y
CONFIG_REGULATOR_WM831X=y
CONFIG_REGULATOR_WM8350=y
# CONFIG_REGULATOR_WM8400 is not set
# CONFIG_REGULATOR_WM8994 is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_ALI=y
# CONFIG_AGP_ATI is not set
# CONFIG_AGP_AMD is not set
# CONFIG_AGP_INTEL is not set
CONFIG_AGP_NVIDIA=y
CONFIG_AGP_SIS=y
CONFIG_AGP_SWORKS=y
CONFIG_AGP_VIA=y
CONFIG_AGP_EFFICEON=y
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=y
CONFIG_DRM_TDFX=y
CONFIG_DRM_R128=y
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_NOUVEAU is not set
CONFIG_DRM_MGA=y
# CONFIG_DRM_SIS is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_STUB_POULSBO is not set
# CONFIG_VGASTATE is not set
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
# CONFIG_FB is not set
CONFIG_EXYNOS_VIDEO=y
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
CONFIG_SOUND=y
# CONFIG_SOUND_OSS_CORE is not set
# CONFIG_SND is not set
# CONFIG_SOUND_PRIME is not set

#
# HID support
#
CONFIG_HID=y
# CONFIG_HID_BATTERY_STRENGTH is not set
# CONFIG_HIDRAW is not set
# CONFIG_UHID is not set
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
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
CONFIG_MEMSTICK=y
CONFIG_MEMSTICK_DEBUG=y

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set

#
# MemoryStick Host Controller Drivers
#
CONFIG_NEW_LEDS=y
# CONFIG_LEDS_CLASS is not set

#
# LED drivers
#

#
# LED Triggers
#
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y

#
# Reporting subsystems
#
CONFIG_EDAC_LEGACY_SYSFS=y
CONFIG_EDAC_DEBUG=y
CONFIG_EDAC_MM_EDAC=y
# CONFIG_EDAC_AMD76X is not set
CONFIG_EDAC_E7XXX=y
# CONFIG_EDAC_E752X is not set
CONFIG_EDAC_I82875P=y
CONFIG_EDAC_I82975X=y
# CONFIG_EDAC_I3000 is not set
# CONFIG_EDAC_X38 is not set
CONFIG_EDAC_I5400=y
# CONFIG_EDAC_I82860 is not set
# CONFIG_EDAC_R82600 is not set
CONFIG_EDAC_I5000=y
CONFIG_EDAC_I5100=y
CONFIG_EDAC_I7300=y
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
# CONFIG_RTC_HCTOSYS is not set
CONFIG_RTC_DEBUG=y

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
CONFIG_RTC_INTF_DEV_UIE_EMUL=y
CONFIG_RTC_DRV_TEST=y

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_DS1307 is not set
# CONFIG_RTC_DRV_DS1374 is not set
# CONFIG_RTC_DRV_DS1672 is not set
CONFIG_RTC_DRV_DS3232=y
# CONFIG_RTC_DRV_MAX6900 is not set
CONFIG_RTC_DRV_MAX8925=y
CONFIG_RTC_DRV_RS5C372=y
CONFIG_RTC_DRV_ISL1208=y
CONFIG_RTC_DRV_ISL12022=y
# CONFIG_RTC_DRV_X1205 is not set
CONFIG_RTC_DRV_PCF8563=y
# CONFIG_RTC_DRV_PCF8583 is not set
CONFIG_RTC_DRV_M41T80=y
# CONFIG_RTC_DRV_M41T80_WDT is not set
# CONFIG_RTC_DRV_BQ32K is not set
# CONFIG_RTC_DRV_S35390A is not set
# CONFIG_RTC_DRV_FM3130 is not set
# CONFIG_RTC_DRV_RX8581 is not set
# CONFIG_RTC_DRV_RX8025 is not set
CONFIG_RTC_DRV_EM3027=y
# CONFIG_RTC_DRV_RV3029C2 is not set

#
# SPI RTC drivers
#
# CONFIG_RTC_DRV_M41T93 is not set
# CONFIG_RTC_DRV_M41T94 is not set
# CONFIG_RTC_DRV_DS1305 is not set
# CONFIG_RTC_DRV_DS1390 is not set
# CONFIG_RTC_DRV_MAX6902 is not set
CONFIG_RTC_DRV_R9701=y
# CONFIG_RTC_DRV_RS5C348 is not set
# CONFIG_RTC_DRV_DS3234 is not set
CONFIG_RTC_DRV_PCF2123=y

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
CONFIG_RTC_DRV_DS1286=y
CONFIG_RTC_DRV_DS1511=y
CONFIG_RTC_DRV_DS1553=y
# CONFIG_RTC_DRV_DS1742 is not set
CONFIG_RTC_DRV_DA9052=y
CONFIG_RTC_DRV_STK17TA8=y
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T35 is not set
CONFIG_RTC_DRV_M48T59=y
# CONFIG_RTC_DRV_MSM6242 is not set
CONFIG_RTC_DRV_BQ4802=y
CONFIG_RTC_DRV_RP5C01=y
# CONFIG_RTC_DRV_V3020 is not set
# CONFIG_RTC_DRV_WM831X is not set
CONFIG_RTC_DRV_WM8350=y
CONFIG_RTC_DRV_PCF50633=y
CONFIG_RTC_DRV_AB3100=y

#
# on-CPU RTC drivers
#
CONFIG_RTC_DRV_PCAP=y
CONFIG_RTC_DRV_MC13XXX=y
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
# CONFIG_INTEL_MID_DMAC is not set
# CONFIG_INTEL_IOATDMA is not set
# CONFIG_TIMB_DMA is not set
CONFIG_PCH_DMA=y
CONFIG_DMA_ENGINE=y

#
# DMA Clients
#
# CONFIG_NET_DMA is not set
CONFIG_ASYNC_TX_DMA=y
# CONFIG_DMATEST is not set
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=y
# CONFIG_UIO_CIF is not set
# CONFIG_UIO_PDRV is not set
# CONFIG_UIO_PDRV_GENIRQ is not set
CONFIG_UIO_AEC=y
CONFIG_UIO_SERCOS3=y
# CONFIG_UIO_PCI_GENERIC is not set
CONFIG_UIO_NETX=y
CONFIG_VIRTIO=y
CONFIG_VIRTIO_RING=y

#
# Virtio drivers
#
CONFIG_VIRTIO_BALLOON=y

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
# CONFIG_STAGING is not set
# CONFIG_X86_PLATFORM_DEVICES is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_CLKBLD_I8253=y
CONFIG_IOMMU_SUPPORT=y
CONFIG_OF_IOMMU=y

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
CONFIG_EXTCON_GPIO=y
# CONFIG_EXTCON_MAX77693 is not set
# CONFIG_EXTCON_MAX8997 is not set
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
# CONFIG_FIRMWARE_MEMMAP is not set
CONFIG_EFI_VARS=y
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
# CONFIG_DMIID is not set
# CONFIG_DMI_SYSFS is not set
CONFIG_ISCSI_IBFT_FIND=y
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
# CONFIG_INOTIFY_USER is not set
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
# CONFIG_PRINT_QUOTA_WARNING is not set
CONFIG_QUOTA_DEBUG=y
CONFIG_QUOTA_TREE=y
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
# CONFIG_AUTOFS4_FS is not set
CONFIG_FUSE_FS=y
# CONFIG_CUSE is not set
CONFIG_GENERIC_ACL=y

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_SYSCTL=y
# CONFIG_PROC_PAGE_MONITOR is not set
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
CONFIG_JFFS2_FS=y
CONFIG_JFFS2_FS_DEBUG=0
# CONFIG_JFFS2_FS_WRITEBUFFER is not set
CONFIG_JFFS2_COMPRESSION_OPTIONS=y
# CONFIG_JFFS2_ZLIB is not set
# CONFIG_JFFS2_LZO is not set
CONFIG_JFFS2_RTIME=y
CONFIG_JFFS2_RUBIN=y
# CONFIG_JFFS2_CMODE_NONE is not set
CONFIG_JFFS2_CMODE_PRIORITY=y
# CONFIG_JFFS2_CMODE_SIZE is not set
# CONFIG_JFFS2_CMODE_FAVOURLZO is not set
# CONFIG_ROMFS_FS is not set
CONFIG_PSTORE=y
# CONFIG_PSTORE_CONSOLE is not set
# CONFIG_PSTORE_FTRACE is not set
CONFIG_PSTORE_RAM=y
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
# CONFIG_NLS_CODEPAGE_737 is not set
CONFIG_NLS_CODEPAGE_775=y
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
CONFIG_NLS_CODEPAGE_855=y
# CONFIG_NLS_CODEPAGE_857 is not set
CONFIG_NLS_CODEPAGE_860=y
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=y
# CONFIG_NLS_CODEPAGE_863 is not set
CONFIG_NLS_CODEPAGE_864=y
# CONFIG_NLS_CODEPAGE_865 is not set
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=y
CONFIG_NLS_CODEPAGE_936=y
CONFIG_NLS_CODEPAGE_950=y
# CONFIG_NLS_CODEPAGE_932 is not set
CONFIG_NLS_CODEPAGE_949=y
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
# CONFIG_NLS_ASCII is not set
# CONFIG_NLS_ISO8859_1 is not set
# CONFIG_NLS_ISO8859_2 is not set
CONFIG_NLS_ISO8859_3=y
CONFIG_NLS_ISO8859_4=y
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
CONFIG_NLS_ISO8859_9=y
# CONFIG_NLS_ISO8859_13 is not set
CONFIG_NLS_ISO8859_14=y
# CONFIG_NLS_ISO8859_15 is not set
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=y
# CONFIG_NLS_MAC_ROMAN is not set
# CONFIG_NLS_MAC_CELTIC is not set
# CONFIG_NLS_MAC_CENTEURO is not set
# CONFIG_NLS_MAC_CROATIAN is not set
CONFIG_NLS_MAC_CYRILLIC=y
# CONFIG_NLS_MAC_GAELIC is not set
# CONFIG_NLS_MAC_GREEK is not set
# CONFIG_NLS_MAC_ICELAND is not set
# CONFIG_NLS_MAC_INUIT is not set
# CONFIG_NLS_MAC_ROMANIAN is not set
CONFIG_NLS_MAC_TURKISH=y
CONFIG_NLS_UTF8=y

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
# CONFIG_ENABLE_WARN_DEPRECATED is not set
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=1024
CONFIG_MAGIC_SYSRQ=y
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_READABLE_ASM is not set
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_HARDLOCKUP_DETECTOR is not set
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
CONFIG_BOOTPARAM_HUNG_TASK_PANIC=y
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=1
# CONFIG_SCHED_DEBUG is not set
CONFIG_SCHEDSTATS=y
# CONFIG_TIMER_STATS is not set
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
CONFIG_DEBUG_PREEMPT=y
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
# CONFIG_PROVE_RCU is not set
CONFIG_SPARSE_RCU_POINTER=y
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_LOCKDEP=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_HIGHMEM=y
# CONFIG_DEBUG_BUGVERBOSE is not set
CONFIG_DEBUG_INFO=y
CONFIG_DEBUG_INFO_REDUCED=y
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_WRITECOUNT is not set
# CONFIG_DEBUG_MEMORY_INIT is not set
# CONFIG_DEBUG_LIST is not set
CONFIG_TEST_LIST_SORT=y
# CONFIG_DEBUG_SG is not set
CONFIG_DEBUG_NOTIFIERS=y
CONFIG_DEBUG_CREDENTIALS=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_TRACE=y
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
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
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
CONFIG_IRQSOFF_TRACER=y
# CONFIG_PREEMPT_TRACER is not set
# CONFIG_SCHED_TRACER is not set
CONFIG_FTRACE_SYSCALLS=y
CONFIG_TRACE_BRANCH_PROFILING=y
# CONFIG_BRANCH_PROFILE_NONE is not set
CONFIG_PROFILE_ANNOTATED_BRANCHES=y
# CONFIG_PROFILE_ALL_BRANCHES is not set
# CONFIG_BRANCH_TRACER is not set
CONFIG_STACK_TRACER=y
# CONFIG_UPROBE_EVENT is not set
# CONFIG_PROBE_EVENTS is not set
# CONFIG_DYNAMIC_FTRACE is not set
CONFIG_FUNCTION_PROFILER=y
CONFIG_FTRACE_SELFTEST=y
CONFIG_FTRACE_STARTUP_TEST=y
# CONFIG_EVENT_TRACE_TEST_SYSCALLS is not set
CONFIG_MMIOTRACE=y
CONFIG_RING_BUFFER_BENCHMARK=y
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
CONFIG_FIREWIRE_OHCI_REMOTE_DMA=y
# CONFIG_DYNAMIC_DEBUG is not set
CONFIG_DMA_API_DEBUG=y
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_TEST_KSTRTOX=y
# CONFIG_STRICT_DEVMEM is not set
# CONFIG_X86_VERBOSE_BOOTUP is not set
# CONFIG_EARLY_PRINTK is not set
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_X86_PTDUMP=y
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
CONFIG_DOUBLEFAULT=y
# CONFIG_DEBUG_TLBFLUSH is not set
CONFIG_IOMMU_STRESS=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
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
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y
# CONFIG_DEBUG_NMI_SELFTEST is not set

#
# Security options
#
# CONFIG_KEYS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
# CONFIG_SECURITY is not set
CONFIG_SECURITYFS=y
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_ABLK_HELPER_X86=y

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=y
# CONFIG_CRYPTO_GCM is not set
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
# CONFIG_CRYPTO_CBC is not set
CONFIG_CRYPTO_CTR=y
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
# CONFIG_CRYPTO_CRC32C_INTEL is not set
CONFIG_CRYPTO_GHASH=y
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
# CONFIG_CRYPTO_SHA512 is not set
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_WP512 is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=y
CONFIG_CRYPTO_AES_NI_INTEL=y
# CONFIG_CRYPTO_ANUBIS is not set
# CONFIG_CRYPTO_ARC4 is not set
# CONFIG_CRYPTO_BLOWFISH is not set
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST6=y
# CONFIG_CRYPTO_DES is not set
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_KHAZAD is not set
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
# CONFIG_CRYPTO_SERPENT_SSE2_586 is not set
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_TWOFISH is not set
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_586=y

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
# CONFIG_CRYPTO_ZLIB is not set
# CONFIG_CRYPTO_LZO is not set

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
# CONFIG_CRYPTO_USER_API_HASH is not set
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
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
# CONFIG_CRC_T10DIF is not set
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC32_SELFTEST=y
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
CONFIG_CRC32_SARWATE=y
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=y
# CONFIG_LIBCRC32C is not set
# CONFIG_CRC8 is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
# CONFIG_XZ_DEC is not set
# CONFIG_XZ_DEC_BCJ is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_REED_SOLOMON=y
CONFIG_REED_SOLOMON_ENC8=y
CONFIG_REED_SOLOMON_DEC8=y
CONFIG_BCH=y
CONFIG_BCH_CONST_PARAMS=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
# CONFIG_AVERAGE is not set
# CONFIG_CORDIC is not set
# CONFIG_DDR is not set

--J2SCkAp4GZ/dPZZf--

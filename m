Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282Ab0KAV70 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 17:59:26 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:48000 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216Ab0KAV7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 17:59:21 -0400
Message-ID: <4CCF37E8.1070208@oracle.com>
Date: Mon, 01 Nov 2010 14:58:00 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.37-rc1: WARNING..debugobjects: ODEBUG: free active (active state
 0) object type: percpu_counter
Content-Type: multipart/mixed;
 boundary="------------050007070806000900060101"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050007070806000900060101
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

[   41.533067] ------------[ cut here ]------------
[   41.533091] WARNING: at /local/linsrc/lnx-2637-rc1/lib/debugobjects.c:259 debug_print_object+0x77/0x86()
[   41.533101] Hardware name: OptiPlex GX620               
[   41.533111] ODEBUG: free active (active state 0) object type: percpu_counter
[   41.533118] Modules linked in: ipt_MASQUERADE iptable_nat nf_nat nfsd lockd nfs_acl auth_rpcgss exportfs sco bridge stp llc bnep l2cap crc16 bluetooth rfkill sunrpc ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT xt_tcpudp nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables x_tables ipv6 p4_clockmod freq_table speedstep_lib binfmt_misc dm_mirror dm_region_hash dm_log dm_multipath scsi_dh dm_mod kvm uinput mousedev joydev snd_intel8x0 snd_ac97_codec ppdev ac97_bus snd_seq snd_seq_device usbmouse snd_pcm usbkbd usbhid led_class hid iTCO_wdt snd_timer iTCO_vendor_support tg3 dcdbas i2c_i801 sg 8250_pnp sr_mod snd pcspkr cdrom rtc_cmos soundcore parport_pc rng_core 8250 rtc_core snd_page_alloc evdev shpchp rtc_lib serial_core parport pci_hotplug mac_hid unix ide_pci_generic ide_core ata_generic pata_acpi ata_piix sd_mod crc_t10dif ext3 jbd mbcache uhci_hcd ohci_hcd ssb mmc_core pcmcia pcmcia_core firmware_class ehc
i_hcd usbcore nls_base i915 drm_kms_helper intel_agp button intel_gtt video thermal_sys hwmon output [last unloaded: mperf]
[   41.533596] Pid: 5, comm: kworker/u:0 Not tainted 2.6.37-rc1 #2
[   41.533605] Call Trace:
[   41.533625]  [<ffffffff8107ebad>] warn_slowpath_common+0xc6/0xf3
[   41.533640]  [<ffffffff812d1173>] ? __debug_check_no_obj_freed+0x66/0x252
[   41.533655]  [<ffffffff8107ecca>] warn_slowpath_fmt+0x5b/0x6b
[   41.533670]  [<ffffffff812d0a6f>] debug_print_object+0x77/0x86
[   41.533683]  [<ffffffff812d11aa>] __debug_check_no_obj_freed+0x9d/0x252
[   41.533703]  [<ffffffff8146f49a>] ? net_free+0x3a/0x45
[   41.533714]  [<ffffffff812d137f>] debug_check_no_obj_freed+0x20/0x29
[   41.533725]  [<ffffffff811b73c7>] kmem_cache_free+0xa7/0x1da
[   41.533737]  [<ffffffff8146f4a5>] ? cleanup_net+0x0/0x223
[   41.533750]  [<ffffffff8146f49a>] net_free+0x3a/0x45
[   41.533764]  [<ffffffff8146f69b>] cleanup_net+0x1f6/0x223
[   41.533774]  [<ffffffff810a0991>] process_one_work+0x2c6/0x4d9
[   41.533787]  [<ffffffff810a08cc>] ? process_one_work+0x201/0x4d9
[   41.533797]  [<ffffffff810a0458>] ? spin_lock_irq+0x15/0x1e
[   41.533807]  [<ffffffff810a30a2>] worker_thread+0x1ce/0x356
[   41.533822]  [<ffffffff810a2ed4>] ? worker_thread+0x0/0x356
[   41.533832]  [<ffffffff810a8746>] kthread+0xc3/0xd2
[   41.533851]  [<ffffffff81138a3d>] ? trace_hardirqs_on_caller+0x18/0x48
[   41.533860]  [<ffffffff8100f904>] kernel_thread_helper+0x4/0x10
[   41.533869]  [<ffffffff8154ad10>] ? restore_args+0x0/0x30
[   41.533876]  [<ffffffff810a8683>] ? kthread+0x0/0xd2
[   41.533884]  [<ffffffff8100f900>] ? kernel_thread_helper+0x0/0x10
[   41.533889] ---[ end trace bfcd91984357df49 ]---



Full log and kernel config are attached.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

--------------050007070806000900060101
Content-Type: text/plain;
 name="2637-rc1.log"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="2637-rc1.log"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.37-rc1 (rdunlap@control.site) (gcc versi=
on 4.4.1 20090725 (Red Hat 4.4.1-2) (GCC) ) #2 SMP Mon Nov 1 11:54:45 PDT=
 2010
[    0.000000] Command line: ro root=3D/dev/sda6 selinux=3D0 debug ignore=
_loglevel initcall_debug printk.time=3D1 print_fatal_signals=3D1 kern=3D2=
637-rc1 console=3DttyS0,115200n8 console=3Dtty0 netconsole=3D6666@192.168=
=2E1.5/eth0,6666@192.168.1.4/00:19:D1:7F:67:14
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 00000000000a0000 (usable)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)=

[    0.000000]  BIOS-e820: 0000000000100000 - 000000007f686c00 (usable)
[    0.000000]  BIOS-e820: 000000007f686c00 - 000000007f688c00 (ACPI NVS)=

[    0.000000]  BIOS-e820: 000000007f688c00 - 000000007f68ac00 (ACPI data=
)
[    0.000000]  BIOS-e820: 000000007f68ac00 - 0000000080000000 (reserved)=

[    0.000000]  BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)=

[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fed00400 (reserved)=

[    0.000000]  BIOS-e820: 00000000fed20000 - 00000000feda0000 (reserved)=

[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fef00000 (reserved)=

[    0.000000]  BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)=

[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.3 present.
[    0.000000] DMI: 0HH807/OptiPlex GX620               , BIOS A07 03/31/=
2006
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (us=
able) =3D=3D> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (us=
able)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn =3D 0x7f686 max_arch_pfn =3D 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 07F800000 mask FFF800000 uncachable
[    0.000000]   2 base 07F700000 mask FFFF00000 uncachable
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600=
070106
[    0.000000] found SMP MP-table at [ffff8800000fe710] fe710
[    0.000000] Scanning 0 areas for low memory corruption
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-000000007f686000
[    0.000000]  0000000000 - 007f686000 page 4k
[    0.000000] kernel direct mapping tables up to 7f686000 @ 1fc01000-200=
00000
[    0.000000] RAMDISK: 37be5000 - 37ff0000
[    0.000000] ACPI: RSDP 00000000000feb00 00024 (v02 DELL  )
[    0.000000] ACPI: XSDT 00000000000fd24f 0005C (v01 DELL    GX620   000=
00007 ASL  00000061)
[    0.000000] ACPI: FACP 00000000000fd347 000F4 (v03 DELL    GX620   000=
00007 ASL  00000061)
[    0.000000] ACPI: DSDT 00000000fffd32f4 03D69 (v01   DELL    dt_ex 000=
01000 INTL 20050309)
[    0.000000] ACPI: FACS 000000007f686c00 00040
[    0.000000] ACPI: SSDT 00000000fffd717c 000AA (v01   DELL    st_ex 000=
01000 INTL 20050309)
[    0.000000] ACPI: APIC 00000000000fd43b 00072 (v01 DELL    GX620   000=
00007 ASL  00000061)
[    0.000000] ACPI: BOOT 00000000000fd4ad 00028 (v01 DELL    GX620   000=
00007 ASL  00000061)
[    0.000000] ACPI: ASF! 00000000000fd4d5 00067 (v16 DELL    GX620   000=
00007 ASL  00000061)
[    0.000000] ACPI: MCFG 00000000000fd53c 0003E (v01 DELL    GX620   000=
00007 ASL  00000061)
[    0.000000] ACPI: HPET 00000000000fd57a 00038 (v01 DELL    GX620   000=
00007 ASL  00000061)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000007f686000
[    0.000000] Initmem setup node 0 0000000000000000-000000007f686000
[    0.000000]   NODE_DATA [000000007f655000 - 000000007f685fff]
[    0.000000]  [ffffea0000000000-ffffea0001bfffff] PMD -> [ffff88007ce00=
000-ffff88007e9fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   empty
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x000000a0
[    0.000000]     0: 0x00000100 -> 0x0007f686
[    0.000000] On node 0 totalpages: 521750
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 7 pages reserved
[    0.000000]   DMA zone: 3921 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 7079 pages used for memmap
[    0.000000]   DMA32 zone: 510687 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x05] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x07] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high level lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI =
0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level=
)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 2 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 000000000=
00f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 000000000=
0100000
[    0.000000] Allocating PCI resources starting at 80000000 (gap: 800000=
00:70000000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:4096 nr_cpumask_bits:4 nr_cpu_ids:4 =
nr_node_ids:1
[    0.000000] PERCPU: Embedded 477 pages/cpu @ffff88007c600000 s1924608 =
r8192 d20992 u2097152
[    0.000000] pcpu-alloc: s1924608 r8192 d20992 u2097152 alloc=3D1*20971=
52
[    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3=20
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  To=
tal pages: 514608
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line:=20
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - baili=
ng!
[    0.000000] Memory: 2012536k/2087448k available (5467k kernel code, 44=
8k absent, 74464k reserved, 7435k data, 3112k init)
[    0.000000] SLUB: Genslabs=3D15, HWalign=3D64, Order=3D0-3, MinObjects=
=3D0, CPUs=3D4, Nodes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU debugfs-based tracing is enabled.
[    0.000000] 	Hierarchical RCU autobalancing is disabled.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] NR_IRQS:262400 nr_irqs:712 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc=
=2E, Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 6335 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] allocated 20971520 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't w=
ant memory cgroups
[    0.000000] ODEBUG: 9 of 9 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2992.487 MHz processor.
[    0.004022] Calibrating delay loop (skipped), value calculated using t=
imer frequency.. 5984.97 BogoMIPS (lpj=3D11969948)
[    0.004242] pid_max: default: 32768 minimum: 301
[    0.004661] Security Framework initialized
[    0.004784] AppArmor: AppArmor disabled by boot time parameter
[    0.007309] Dentry cache hash table entries: 262144 (order: 9, 2097152=
 bytes)
[    0.009691] Inode-cache hash table entries: 131072 (order: 8, 1048576 =
bytes)
[    0.010417] Mount-cache hash table entries: 256
[    0.012240] Initializing cgroup subsys debug
[    0.012355] Initializing cgroup subsys ns
[    0.012463] ns_cgroup deprecated: consider using the 'clone_children' =
flag without the ns_cgroup.
[    0.012652] Initializing cgroup subsys cpuacct
[    0.012791] Initializing cgroup subsys memory
[    0.013107] Initializing cgroup subsys devices
[    0.013218] Initializing cgroup subsys freezer
[    0.013555] CPU: Physical Processor ID: 0
[    0.013659] CPU: Processor Core ID: 0
[    0.013763] mce: CPU supports 4 MCE banks
[    0.013884] CPU0: Thermal monitoring enabled (TM1)
[    0.014004] using mwait in idle threads.
[    0.014110] numa_add_cpu cpu 0 node 0: mask now 0
[    0.014115] Performance Events: Netburst events, Netburst P4/Xeon PMU =
driver.
[    0.014293] ... version:                0
[    0.014397] ... bit width:              40
[    0.014502] ... generic registers:      18
[    0.014607] ... value mask:             000000ffffffffff
[    0.014714] ... max period:             0000007fffffffff
[    0.014822] ... fixed-purpose events:   0
[    0.014927] ... event mask:             000000000003ffff
[    0.016980] ACPI: Core revision 20101013
[    0.141947] ftrace: allocating 20245 entries in 80 pages
[    0.144618] Setting APIC routing to flat
[    0.145493] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.186764] CPU0: Intel(R) Pentium(R) D CPU 3.00GHz stepping 04
[    0.188000] NMI watchdog enabled, takes one hw-pmu counter.
[    0.188000] lockdep: fixing up alternatives.
[    0.188000] Booting Node   0, Processors  #1
[    0.008000] numa_add_cpu cpu 1 node 0: mask now 0-1
[    0.280279] NMI watchdog enabled, takes one hw-pmu counter.
[    0.280711] Brought up 2 CPUs
[    0.280834] Total of 2 processors activated (11970.28 BogoMIPS).
[    0.283015] devtmpfs: initialized
[    0.291662] gcov: version magic: 0x34303452
[    0.296501] regulator: core version 0.5
[    0.297141] regulator: dummy:=20
[    0.297712] NET: Registered protocol family 16
[    0.299506] i2c-core: driver [dummy] registered
[    0.299977] ACPI: bus type pci registered
[    0.300691] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf00000=
00-0xf3ffffff] (base 0xf0000000)
[    0.300880] PCI: MMCONFIG at [mem 0xf0000000-0xf3ffffff] reserved in E=
820
[    0.342443] PCI: Using configuration type 1 for base access
[    0.353077] bio: create slab <bio-0> at 0
[    0.366985] ACPI: EC: Look up EC in DSDT
[    0.431520] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.452451] ACPI: Interpreter enabled
[    0.452567] ACPI: (supports S0 S1 S3 S4 S5)
[    0.453188] ACPI: Using IOAPIC for interrupt routing
[    0.608155] ACPI: ACPI Dock Station Driver: 1 docks/bays found
[    0.608270] PCI: Ignoring host bridge windows from ACPI; if necessary,=
 use "pci=3Duse_crs" and report a bug
[    0.624270] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.656248] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7=
] (ignored)
[    0.656256] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff=
] (ignored)
[    0.656262] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x=
000bffff] (ignored)
[    0.656268] pci_root PNP0A03:00: host bridge window [mem 0x000c0000-0x=
000effff] (ignored)
[    0.656274] pci_root PNP0A03:00: host bridge window [mem 0x000f0000-0x=
000fffff] (ignored)
[    0.656280] pci_root PNP0A03:00: host bridge window [mem 0x80000000-0x=
efffffff] (ignored)
[    0.656286] pci_root PNP0A03:00: host bridge window [mem 0xf4000000-0x=
febfffff] (ignored)
[    0.656292] pci_root PNP0A03:00: host bridge window [mem 0xffa80800-0x=
ffa80bff] (ignored)
[    0.656302] pci_bus 0000:00: scanning bus
[    0.656380] pci 0000:00:00.0: [8086:2770] type 0 class 0x000600
[    0.656396] pci 0000:00:00.0: calling quirk_mmio_always_on+0x0/0x2a
[    0.656502] pci 0000:00:00.0: calling quirk_resource_alignment+0x0/0x1=
f7
[    0.656531] pci 0000:00:00.0: calling pci_fixup_transparent_bridge+0x0=
/0x44
[    0.656652] pci 0000:00:01.0: [8086:2771] type 1 class 0x000604
[    0.656662] pci 0000:00:01.0: calling quirk_mmio_always_on+0x0/0x2a
[    0.656761] pci 0000:00:01.0: calling quirk_resource_alignment+0x0/0x1=
f7
[    0.656770] pci 0000:00:01.0: calling pci_fixup_transparent_bridge+0x0=
/0x44
[    0.656851] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.656862] pci 0000:00:01.0: PME# disabled
[    0.656951] pci 0000:00:02.0: [8086:2772] type 0 class 0x000300
[    0.656977] pci 0000:00:02.0: calling quirk_mmio_always_on+0x0/0x2a
[    0.657010] pci 0000:00:02.0: reg 10: [mem 0xfeb00000-0xfeb7ffff]
[    0.657036] pci 0000:00:02.0: reg 14: [io  0xe898-0xe89f]
[    0.657063] pci 0000:00:02.0: reg 18: [mem 0xe0000000-0xefffffff pref]=

[    0.657091] pci 0000:00:02.0: reg 1c: [mem 0xfeac0000-0xfeafffff]
[    0.657168] pci 0000:00:02.0: calling quirk_resource_alignment+0x0/0x1=
f7
[    0.657177] pci 0000:00:02.0: calling pci_fixup_transparent_bridge+0x0=
/0x44
[    0.657299] pci 0000:00:02.1: [8086:2776] type 0 class 0x000380
[    0.657319] pci 0000:00:02.1: calling quirk_mmio_always_on+0x0/0x2a
[    0.657369] pci 0000:00:02.1: reg 10: [mem 0xfeb80000-0xfebfffff]
[    0.657531] pci 0000:00:02.1: calling quirk_resource_alignment+0x0/0x1=
f7
[    0.657540] pci 0000:00:02.1: calling pci_fixup_transparent_bridge+0x0=
/0x44
[    0.657773] pci 0000:00:1c.0: [8086:27d0] type 1 class 0x000604
[    0.657783] pci 0000:00:1c.0: calling quirk_mmio_always_on+0x0/0x2a
[    0.657904] pci 0000:00:1c.0: calling quirk_resource_alignment+0x0/0x1=
f7
[    0.657912] pci 0000:00:1c.0: calling pci_fixup_transparent_bridge+0x0=
/0x44
[    0.657995] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.658007] pci 0000:00:1c.0: PME# disabled
[    0.658098] pci 0000:00:1c.1: [8086:27d2] type 1 class 0x000604
[    0.658108] pci 0000:00:1c.1: calling quirk_mmio_always_on+0x0/0x2a
[    0.658229] pci 0000:00:1c.1: calling quirk_resource_alignment+0x0/0x1=
f7
[    0.658237] pci 0000:00:1c.1: calling pci_fixup_transparent_bridge+0x0=
/0x44
[    0.658319] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.658331] pci 0000:00:1c.1: PME# disabled
[    0.658469] pci 0000:00:1d.0: [8086:27c8] type 0 class 0x000c03
[    0.658480] pci 0000:00:1d.0: calling quirk_mmio_always_on+0x0/0x2a
[    0.658610] pci 0000:00:1d.0: reg 20: [io  0xff80-0xff9f]
[    0.658675] pci 0000:00:1d.0: calling quirk_resource_alignment+0x0/0x1=
f7
[    0.658683] pci 0000:00:1d.0: calling pci_fixup_transparent_bridge+0x0=
/0x44
[    0.658743] pci 0000:00:1d.1: [8086:27c9] type 0 class 0x000c03
[    0.658754] pci 0000:00:1d.1: calling quirk_mmio_always_on+0x0/0x2a
[    0.658885] pci 0000:00:1d.1: reg 20: [io  0xff60-0xff7f]
[    0.658950] pci 0000:00:1d.1: calling quirk_resource_alignment+0x0/0x1=
f7
[    0.658958] pci 0000:00:1d.1: calling pci_fixup_transparent_bridge+0x0=
/0x44
[    0.659017] pci 0000:00:1d.2: [8086:27ca] type 0 class 0x000c03
[    0.659028] pci 0000:00:1d.2: calling quirk_mmio_always_on+0x0/0x2a
[    0.659158] pci 0000:00:1d.2: reg 20: [io  0xff40-0xff5f]
[    0.659222] pci 0000:00:1d.2: calling quirk_resource_alignment+0x0/0x1=
f7
[    0.659231] pci 0000:00:1d.2: calling pci_fixup_transparent_bridge+0x0=
/0x44
[    0.659290] pci 0000:00:1d.3: [8086:27cb] type 0 class 0x000c03
[    0.659300] pci 0000:00:1d.3: calling quirk_mmio_always_on+0x0/0x2a
[    0.659430] pci 0000:00:1d.3: reg 20: [io  0xff20-0xff3f]
[    0.659494] pci 0000:00:1d.3: calling quirk_resource_alignment+0x0/0x1=
f7
[    0.659503] pci 0000:00:1d.3: calling pci_fixup_transparent_bridge+0x0=
/0x44
[    0.659593] pci 0000:00:1d.7: [8086:27cc] type 0 class 0x000c03
[    0.659621] pci 0000:00:1d.7: calling quirk_mmio_always_on+0x0/0x2a
[    0.659659] pci 0000:00:1d.7: reg 10: [mem 0xffa80800-0xffa80bff]
[    0.659821] pci 0000:00:1d.7: calling quirk_resource_alignment+0x0/0x1=
f7
[    0.659830] pci 0000:00:1d.7: calling pci_fixup_transparent_bridge+0x0=
/0x44
[    0.659891] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.659903] pci 0000:00:1d.7: PME# disabled
[    0.659978] pci 0000:00:1e.0: [8086:244e] type 1 class 0x000604
[    0.660021] pci 0000:00:1e.0: calling quirk_mmio_always_on+0x0/0x2a
[    0.660120] pci 0000:00:1e.0: calling quirk_resource_alignment+0x0/0x1=
f7
[    0.660128] pci 0000:00:1e.0: calling pci_fixup_transparent_bridge+0x0=
/0x44
[    0.660239] pci 0000:00:1e.2: [8086:27de] type 0 class 0x000401
[    0.660260] pci 0000:00:1e.2: calling quirk_mmio_always_on+0x0/0x2a
[    0.660295] pci 0000:00:1e.2: reg 10: [io  0xec00-0xecff]
[    0.660323] pci 0000:00:1e.2: reg 14: [io  0xe8c0-0xe8ff]
[    0.660352] pci 0000:00:1e.2: reg 18: [mem 0xfeabfa00-0xfeabfbff]
[    0.660380] pci 0000:00:1e.2: reg 1c: [mem 0xfeabf900-0xfeabf9ff]
[    0.660465] pci 0000:00:1e.2: calling quirk_resource_alignment+0x0/0x1=
f7
[    0.660473] pci 0000:00:1e.2: calling pci_fixup_transparent_bridge+0x0=
/0x44
[    0.660518] pci 0000:00:1e.2: PME# supported from D0 D3hot D3cold
[    0.660530] pci 0000:00:1e.2: PME# disabled
[    0.660651] pci 0000:00:1f.0: [8086:27b8] type 0 class 0x000601
[    0.660673] pci 0000:00:1f.0: calling quirk_mmio_always_on+0x0/0x2a
[    0.660874] pci 0000:00:1f.0: calling ich_force_enable_hpet+0x0/0x214
[    0.660883] pci 0000:00:1f.0: calling quirk_ich7_lpc+0x0/0x95
[    0.660898] pci 0000:00:1f.0: quirk: [io  0x0800-0x087f] claimed by IC=
H6 ACPI/GPIO/TCO
[    0.661088] pci 0000:00:1f.0: quirk: [io  0x0880-0x08bf] claimed by IC=
H6 GPIO
[    0.661206] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0c00=
 (mask 007f)
[    0.661397] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 00e0=
 (mask 0007)
[    0.661588] pci 0000:00:1f.0: calling quirk_resource_alignment+0x0/0x1=
f7
[    0.661596] pci 0000:00:1f.0: calling pci_fixup_transparent_bridge+0x0=
/0x44
[    0.661700] pci 0000:00:1f.1: [8086:27df] type 0 class 0x000101
[    0.661711] pci 0000:00:1f.1: calling quirk_mmio_always_on+0x0/0x2a
[    0.661748] pci 0000:00:1f.1: reg 10: [io  0x01f0-0x01f7]
[    0.661777] pci 0000:00:1f.1: reg 14: [io  0x03f4-0x03f7]
[    0.661806] pci 0000:00:1f.1: reg 18: [io  0x0170-0x0177]
[    0.661835] pci 0000:00:1f.1: reg 1c: [io  0x0374-0x0377]
[    0.661864] pci 0000:00:1f.1: reg 20: [io  0xffa0-0xffaf]
[    0.661933] pci 0000:00:1f.1: calling quirk_resource_alignment+0x0/0x1=
f7
[    0.661941] pci 0000:00:1f.1: calling pci_fixup_transparent_bridge+0x0=
/0x44
[    0.662010] pci 0000:00:1f.2: [8086:27c0] type 0 class 0x000101
[    0.662031] pci 0000:00:1f.2: calling quirk_mmio_always_on+0x0/0x2a
[    0.662066] pci 0000:00:1f.2: reg 10: [io  0xfe00-0xfe07]
[    0.662094] pci 0000:00:1f.2: reg 14: [io  0xfe10-0xfe13]
[    0.662122] pci 0000:00:1f.2: reg 18: [io  0xfe20-0xfe27]
[    0.662150] pci 0000:00:1f.2: reg 1c: [io  0xfe30-0xfe33]
[    0.662177] pci 0000:00:1f.2: reg 20: [io  0xfea0-0xfeaf]
[    0.662243] pci 0000:00:1f.2: calling quirk_resource_alignment+0x0/0x1=
f7
[    0.662251] pci 0000:00:1f.2: calling pci_fixup_transparent_bridge+0x0=
/0x44
[    0.662296] pci 0000:00:1f.2: PME# supported from D3hot
[    0.662307] pci 0000:00:1f.2: PME# disabled
[    0.662368] pci 0000:00:1f.3: [8086:27da] type 0 class 0x000c05
[    0.662379] pci 0000:00:1f.3: calling quirk_mmio_always_on+0x0/0x2a
[    0.662520] pci 0000:00:1f.3: reg 20: [io  0xe8a0-0xe8bf]
[    0.662589] pci 0000:00:1f.3: calling quirk_resource_alignment+0x0/0x1=
f7
[    0.662597] pci 0000:00:1f.3: calling pci_fixup_transparent_bridge+0x0=
/0x44
[    0.662638] pci_bus 0000:00: fixups for bus
[    0.662649] pci 0000:00:01.0: scanning [bus 01-01] behind bridge, pass=
 0
[    0.662788] pci_bus 0000:01: scanning bus
[    0.662798] pci_bus 0000:01: fixups for bus
[    0.662803] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.662916] pci 0000:00:01.0:   bridge window [io  0xf000-0x0000] (dis=
abled)
[    0.662927] pci 0000:00:01.0:   bridge window [mem 0xfe900000-0xfe9fff=
ff]
[    0.662945] pci 0000:00:01.0:   bridge window [mem 0xfff00000-0x000fff=
ff pref] (disabled)
[    0.662951] pci_bus 0000:01: bus scan returning with max=3D01
[    0.662964] pci 0000:00:1c.0: scanning [bus 02-02] behind bridge, pass=
 0
[    0.663099] pci_bus 0000:02: scanning bus
[    0.663180] pci 0000:02:00.0: [14e4:1677] type 0 class 0x000200
[    0.663191] pci 0000:02:00.0: calling quirk_mmio_always_on+0x0/0x2a
[    0.663247] pci 0000:02:00.0: reg 10: [mem 0xfe8f0000-0xfe8fffff 64bit=
]
[    0.663399] pci 0000:02:00.0: calling quirk_resource_alignment+0x0/0x1=
f7
[    0.663498] pci 0000:02:00.0: PME# supported from D3hot D3cold
[    0.663511] pci 0000:02:00.0: PME# disabled
[    0.663555] pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  =
You can enable it with 'pcie_aspm=3Dforce'
[    0.663792] pci_bus 0000:02: fixups for bus
[    0.663797] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.663912] pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000] (dis=
abled)
[    0.663924] pci 0000:00:1c.0:   bridge window [mem 0xfe800000-0xfe8fff=
ff]
[    0.663944] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fff=
ff pref] (disabled)
[    0.663950] pci_bus 0000:02: bus scan returning with max=3D02
[    0.663963] pci 0000:00:1c.1: scanning [bus 03-03] behind bridge, pass=
 0
[    0.664125] pci_bus 0000:03: scanning bus
[    0.664135] pci_bus 0000:03: fixups for bus
[    0.664140] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.664255] pci 0000:00:1c.1:   bridge window [io  0xf000-0x0000] (dis=
abled)
[    0.664267] pci 0000:00:1c.1:   bridge window [mem 0xfe700000-0xfe7fff=
ff]
[    0.664286] pci 0000:00:1c.1:   bridge window [mem 0xfff00000-0x000fff=
ff pref] (disabled)
[    0.664292] pci_bus 0000:03: bus scan returning with max=3D03
[    0.664305] pci 0000:00:1e.0: scanning [bus 04-04] behind bridge, pass=
 0
[    0.664380] pci_bus 0000:04: scanning bus
[    0.664531] pci_bus 0000:04: fixups for bus
[    0.664537] pci 0000:00:1e.0: PCI bridge to [bus 04-04] (subtractive d=
ecode)
[    0.664655] pci 0000:00:1e.0:   bridge window [io  0xf000-0x0000] (dis=
abled)
[    0.664667] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fff=
ff] (disabled)
[    0.664686] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fff=
ff pref] (disabled)
[    0.664694] pci 0000:00:1e.0:   bridge window [io  0x0000-0xffff] (sub=
tractive decode)
[    0.664702] pci 0000:00:1e.0:   bridge window [mem 0x00000000-0xffffff=
fff] (subtractive decode)
[    0.664708] pci_bus 0000:04: bus scan returning with max=3D04
[    0.664721] pci 0000:00:01.0: scanning [bus 01-01] behind bridge, pass=
 1
[    0.664739] pci 0000:00:1c.0: scanning [bus 02-02] behind bridge, pass=
 1
[    0.664757] pci 0000:00:1c.1: scanning [bus 03-03] behind bridge, pass=
 1
[    0.664776] pci 0000:00:1e.0: scanning [bus 04-04] behind bridge, pass=
 1
[    0.664791] pci_bus 0000:00: bus scan returning with max=3D04
[    0.664812] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.671608] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI4._PRT]
[    0.676715] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI2._PRT]
[    0.677657] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI3._PRT]
[    0.679448] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
[    1.946564] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 1=
2 15)
[    1.948210] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 *10 11 1=
2 15)
[    1.949798] ACPI: PCI Interrupt Link [LNKC] (IRQs *3 4 5 6 7 9 10 11 1=
2 15)
[    1.951392] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 11 12=
 15) *0, disabled.
[    1.953140] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 7 9 10 11 1=
2 15)
[    1.954739] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 *9 10 11 1=
2 15)
[    1.956403] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 *5 6 7 9 10 11 1=
2 15)
[    1.959822] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 *10 11 1=
2 15)
[    1.960626] HEST: Table is not found!
[    1.961351] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,ow=
ns=3Dio+mem,locks=3Dnone
[    1.961703] vgaarb: loaded
[    1.963577] SCSI subsystem initialized
[    1.964421] libata version 3.00 loaded.
[    1.964925] PCI: Using ACPI for IRQ routing
[    1.965032] PCI: pci_cache_line_size set to 64 bytes
[    1.965093] pci 0000:00:02.0: BAR 0: reserving [mem 0xfeb00000-0xfeb7f=
fff flags 0x40200] (d=3D0, p=3D0)
[    1.965103] pci 0000:00:02.0: BAR 1: reserving [io  0xe898-0xe89f flag=
s 0x40101] (d=3D0, p=3D0)
[    1.965112] pci 0000:00:02.0: BAR 2: reserving [mem 0xe0000000-0xeffff=
fff flags 0x42208] (d=3D0, p=3D0)
[    1.965121] pci 0000:00:02.0: BAR 3: reserving [mem 0xfeac0000-0xfeaff=
fff flags 0x40200] (d=3D0, p=3D0)
[    1.965146] pci 0000:00:02.1: BAR 0: reserving [mem 0xfeb80000-0xfebff=
fff flags 0x40200] (d=3D0, p=3D0)
[    1.965200] pci 0000:00:1d.0: BAR 4: reserving [io  0xff80-0xff9f flag=
s 0x40101] (d=3D0, p=3D0)
[    1.965226] pci 0000:00:1d.1: BAR 4: reserving [io  0xff60-0xff7f flag=
s 0x40101] (d=3D0, p=3D0)
[    1.965251] pci 0000:00:1d.2: BAR 4: reserving [io  0xff40-0xff5f flag=
s 0x40101] (d=3D0, p=3D0)
[    1.965276] pci 0000:00:1d.3: BAR 4: reserving [io  0xff20-0xff3f flag=
s 0x40101] (d=3D0, p=3D0)
[    1.965301] pci 0000:00:1d.7: BAR 0: reserving [mem 0xffa80800-0xffa80=
bff flags 0x40200] (d=3D0, p=3D0)
[    1.965341] pci 0000:00:1e.2: BAR 0: reserving [io  0xec00-0xecff flag=
s 0x40101] (d=3D0, p=3D0)
[    1.965350] pci 0000:00:1e.2: BAR 1: reserving [io  0xe8c0-0xe8ff flag=
s 0x40101] (d=3D0, p=3D0)
[    1.965358] pci 0000:00:1e.2: BAR 2: reserving [mem 0xfeabfa00-0xfeabf=
bff flags 0x40200] (d=3D0, p=3D0)
[    1.965366] pci 0000:00:1e.2: BAR 3: reserving [mem 0xfeabf900-0xfeabf=
9ff flags 0x40200] (d=3D0, p=3D0)
[    1.965406] pci 0000:00:1f.1: BAR 0: reserving [io  0x01f0-0x01f7 flag=
s 0x110] (d=3D0, p=3D0)
[    1.965415] pci 0000:00:1f.1: BAR 1: reserving [io  0x03f6 flags 0x110=
] (d=3D0, p=3D0)
[    1.965423] pci 0000:00:1f.1: BAR 2: reserving [io  0x0170-0x0177 flag=
s 0x110] (d=3D0, p=3D0)
[    1.965431] pci 0000:00:1f.1: BAR 3: reserving [io  0x0376 flags 0x110=
] (d=3D0, p=3D0)
[    1.965439] pci 0000:00:1f.1: BAR 4: reserving [io  0xffa0-0xffaf flag=
s 0x40101] (d=3D0, p=3D0)
[    1.965464] pci 0000:00:1f.2: BAR 0: reserving [io  0xfe00-0xfe07 flag=
s 0x40101] (d=3D0, p=3D0)
[    1.965473] pci 0000:00:1f.2: BAR 1: reserving [io  0xfe10-0xfe13 flag=
s 0x40101] (d=3D0, p=3D0)
[    1.965481] pci 0000:00:1f.2: BAR 2: reserving [io  0xfe20-0xfe27 flag=
s 0x40101] (d=3D0, p=3D0)
[    1.965489] pci 0000:00:1f.2: BAR 3: reserving [io  0xfe30-0xfe33 flag=
s 0x40101] (d=3D0, p=3D0)
[    1.965497] pci 0000:00:1f.2: BAR 4: reserving [io  0xfea0-0xfeaf flag=
s 0x40101] (d=3D0, p=3D0)
[    1.965522] pci 0000:00:1f.3: BAR 4: reserving [io  0xe8a0-0xe8bf flag=
s 0x40101] (d=3D0, p=3D0)
[    1.965548] pci 0000:02:00.0: BAR 0: reserving [mem 0xfe8f0000-0xfe8ff=
fff flags 0x140204] (d=3D0, p=3D0)
[    1.965842] reserve RAM buffer: 000000007f686c00 - 000000007fffffff=20
[    1.966970] NetLabel: Initializing
[    1.967073] NetLabel:  domain hash size =3D 128
[    1.967181] NetLabel:  protocols =3D UNLABELED CIPSOv4
[    1.967524] NetLabel:  unlabeled traffic allowed by default
[    1.968750] HPET: 3 timers in total, 0 timers will be used for per-cpu=
 timer
[    1.968902] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    1.969108] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    1.975247] Switching to clocksource tsc
[    2.069324] pnp: PnP ACPI init
[    2.069564] ACPI: bus type pnp registered
[    2.078863] pnp 00:00: [bus 00-ff]
[    2.078872] pnp 00:00: [io  0x0cf8-0x0cff]
[    2.078880] pnp 00:00: [io  0x0000-0x0cf7 window]
[    2.078887] pnp 00:00: [io  0x0d00-0xffff window]
[    2.078894] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    2.078902] pnp 00:00: [mem 0x000c0000-0x000effff window]
[    2.078909] pnp 00:00: [mem 0x000f0000-0x000fffff window]
[    2.078916] pnp 00:00: [mem 0x80000000-0xefffffff window]
[    2.078944] pnp 00:00: [mem 0xf4000000-0xfebfffff window]
[    2.078953] pnp 00:00: [mem 0xffa80800-0xffa80bff window]
[    2.079343] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)=

[    2.084596] pnp 00:01: [io  0x0060]
[    2.084603] pnp 00:01: [io  0x0064]
[    2.084610] pnp 00:01: [io  0x0062-0x0063]
[    2.084616] pnp 00:01: [io  0x0065-0x006f]
[    2.084622] pnp 00:01: [io  0x00e0-0x00ef]
[    2.084629] pnp 00:01: [io  0x0800-0x085f]
[    2.084635] pnp 00:01: [io  0x0c00-0x0c7f]
[    2.084642] pnp 00:01: [io  0x0860-0x08ff]
[    2.084813] pnp 00:01: disabling [io  0x0800-0x085f] because it overla=
ps 0000:00:1f.0 BAR 13 [io  0x0800-0x087f]
[    2.084994] pnp 00:01: disabling [io  0x0860-0x08ff] because it overla=
ps 0000:00:1f.0 BAR 13 [io  0x0800-0x087f]
[    2.085493] pnp 00:01: Plug and Play ACPI device, IDs PNP0c01 (active)=

[    2.085952] pnp 00:02: [io  0x0080-0x009f]
[    2.085959] pnp 00:02: [io  0x0000-0x001f]
[    2.085966] pnp 00:02: [io  0x00c0-0x00df]
[    2.085973] pnp 00:02: [dma 4]
[    2.086264] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)=

[    2.086674] pnp 00:03: [io  0x00f0-0x00ff]
[    2.086722] pnp 00:03: [irq 13]
[    2.087019] pnp 00:03: Plug and Play ACPI device, IDs PNP0c04 (active)=

[    2.087468] pnp 00:04: [io  0x0061]
[    2.087771] pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)=

[    2.088203] pnp 00:05: [io  0x0070-0x007f]
[    2.088239] pnp 00:05: [irq 8]
[    2.088546] pnp 00:05: Plug and Play ACPI device, IDs PNP0b00 (active)=

[    2.106264] pnp 00:06: [io  0x0378-0x037f]
[    2.106272] pnp 00:06: [io  0x0778-0x077f]
[    2.106305] pnp 00:06: [irq 7]
[    2.106313] pnp 00:06: [dma 0 disabled]
[    2.107975] pnp 00:06: Plug and Play ACPI device, IDs PNP0401 (active)=

[    2.114143] pnp 00:07: [io  0x03f8-0x03ff]
[    2.114178] pnp 00:07: [irq 4]
[    2.115007] pnp 00:07: Plug and Play ACPI device, IDs PNP0501 (active)=

[    2.141351] pnp 00:08: [mem 0x00000000-0x0009ffff]
[    2.141359] pnp 00:08: [mem 0x00100000-0x00ffffff]
[    2.141366] pnp 00:08: [mem 0x01000000-0x7f686bff]
[    2.141373] pnp 00:08: [mem 0x000f0000-0x000fffff]
[    2.141379] pnp 00:08: [mem 0x000c0000-0x000cffff]
[    2.141386] pnp 00:08: [mem 0xfec00000-0xfecfffff]
[    2.141393] pnp 00:08: [mem 0xfee00000-0xfeefffff]
[    2.141400] pnp 00:08: [mem 0xfed20000-0xfed9ffff]
[    2.141406] pnp 00:08: [mem 0xffb00000-0xffbfffff]
[    2.141413] pnp 00:08: [mem 0xffc00000-0xffffffff]
[    2.141995] pnp 00:08: Plug and Play ACPI device, IDs PNP0c01 (active)=

[    2.145493] pnp 00:09: [mem 0xf0000000-0xf3ffffff]
[    2.145501] pnp 00:09: [mem 0xfeda0000-0xfedacfff]
[    2.145508] pnp 00:09: [io  0x0100-0x01fe]
[    2.145514] pnp 00:09: [io  0x0200-0x0277]
[    2.145521] pnp 00:09: [io  0x0280-0x02e7]
[    2.145527] pnp 00:09: [io  0x02f0-0x02f7]
[    2.145534] pnp 00:09: [io  0x0300-0x0377]
[    2.145540] pnp 00:09: [io  0x0380-0x03bb]
[    2.145547] pnp 00:09: [io  0x03c0-0x03e7]
[    2.145553] pnp 00:09: [io  0x03f6-0x03f7]
[    2.145559] pnp 00:09: [io  0x0400-0x04cf]
[    2.145566] pnp 00:09: [io  0x04d2-0x057f]
[    2.145572] pnp 00:09: [io  0x0580-0x0677]
[    2.145579] pnp 00:09: [io  0x0680-0x0777]
[    2.145585] pnp 00:09: [io  0x0780-0x07bb]
[    2.145592] pnp 00:09: [io  0x07c0-0x07ff]
[    2.145598] pnp 00:09: [io  0x08e0-0x08ff]
[    2.145605] pnp 00:09: [io  0x0900-0x09fe]
[    2.145611] pnp 00:09: [io  0x0a00-0x0afe]
[    2.145618] pnp 00:09: [io  0x0b00-0x0bfe]
[    2.145624] pnp 00:09: [io  0x0c80-0x0caf]
[    2.145631] pnp 00:09: [io  0x0cb0-0x0cbf]
[    2.145637] pnp 00:09: [io  0x0cc0-0x0cf7]
[    2.145643] pnp 00:09: [io  0x0d00-0x0dfe]
[    2.145666] pnp 00:09: [io  0x0e00-0x0efe]
[    2.145674] pnp 00:09: [io  0x0f00-0x0ffe]
[    2.145680] pnp 00:09: [io  0x2000-0x20fe]
[    2.145687] pnp 00:09: [io  0x2100-0x21fe]
[    2.145693] pnp 00:09: [io  0x2200-0x22fe]
[    2.145700] pnp 00:09: [io  0x2300-0x23fe]
[    2.145706] pnp 00:09: [io  0x2400-0x24fe]
[    2.145713] pnp 00:09: [io  0x2500-0x25fe]
[    2.145719] pnp 00:09: [io  0x2600-0x26fe]
[    2.145725] pnp 00:09: [io  0x2700-0x27fe]
[    2.145732] pnp 00:09: [io  0x2800-0x28fe]
[    2.145738] pnp 00:09: [io  0x2900-0x29fe]
[    2.145745] pnp 00:09: [io  0x2a00-0x2afe]
[    2.145751] pnp 00:09: [io  0x2b00-0x2bfe]
[    2.145757] pnp 00:09: [io  0x2c00-0x2cfe]
[    2.145764] pnp 00:09: [io  0x2d00-0x2dfe]
[    2.145770] pnp 00:09: [io  0x2e00-0x2efe]
[    2.145777] pnp 00:09: [io  0x2f00-0x2ffe]
[    2.145783] pnp 00:09: [io  0x5000-0x50fe]
[    2.145789] pnp 00:09: [io  0x5100-0x51fe]
[    2.145796] pnp 00:09: [io  0x5200-0x52fe]
[    2.145802] pnp 00:09: [io  0x5300-0x53fe]
[    2.145809] pnp 00:09: [io  0x5400-0x54fe]
[    2.145815] pnp 00:09: [io  0x5500-0x55fe]
[    2.145837] pnp 00:09: [io  0x5600-0x56fe]
[    2.145844] pnp 00:09: [io  0x5700-0x57fe]
[    2.145851] pnp 00:09: [io  0x5800-0x58fe]
[    2.145857] pnp 00:09: [io  0x5900-0x59fe]
[    2.145864] pnp 00:09: [io  0x5a00-0x5afe]
[    2.145870] pnp 00:09: [io  0x5b00-0x5bfe]
[    2.145876] pnp 00:09: [io  0x5c00-0x5cfe]
[    2.145883] pnp 00:09: [io  0x5d00-0x5dfe]
[    2.145889] pnp 00:09: [io  0x5e00-0x5efe]
[    2.145896] pnp 00:09: [io  0x5f00-0x5ffe]
[    2.145902] pnp 00:09: [io  0x6000-0x60fe]
[    2.145908] pnp 00:09: [io  0x6100-0x61fe]
[    2.145915] pnp 00:09: [io  0x6200-0x62fe]
[    2.145921] pnp 00:09: [io  0x6300-0x63fe]
[    2.145927] pnp 00:09: [io  0x6400-0x64fe]
[    2.145934] pnp 00:09: [io  0x6500-0x65fe]
[    2.145940] pnp 00:09: [io  0x6600-0x66fe]
[    2.145947] pnp 00:09: [io  0x6700-0x67fe]
[    2.145953] pnp 00:09: [io  0x6800-0x68fe]
[    2.145959] pnp 00:09: [io  0x6900-0x69fe]
[    2.145966] pnp 00:09: [io  0x6a00-0x6afe]
[    2.145972] pnp 00:09: [io  0x6b00-0x6bfe]
[    2.145979] pnp 00:09: [io  0x6c00-0x6cfe]
[    2.145985] pnp 00:09: [io  0x6d00-0x6dfe]
[    2.146007] pnp 00:09: [io  0x6e00-0x6efe]
[    2.146015] pnp 00:09: [io  0x6f00-0x6ffe]
[    2.146021] pnp 00:09: [io  0xa000-0xa0fe]
[    2.146027] pnp 00:09: [io  0xa100-0xa1fe]
[    2.146034] pnp 00:09: [io  0xa200-0xa2fe]
[    2.146040] pnp 00:09: [io  0xa300-0xa3fe]
[    2.146047] pnp 00:09: [io  0xa400-0xa4fe]
[    2.146053] pnp 00:09: [io  0xa500-0xa5fe]
[    2.146059] pnp 00:09: [io  0xa600-0xa6fe]
[    2.146066] pnp 00:09: [io  0xa700-0xa7fe]
[    2.146072] pnp 00:09: [io  0xa800-0xa8fe]
[    2.146079] pnp 00:09: [io  0xa900-0xa9fe]
[    2.146085] pnp 00:09: [io  0xaa00-0xaafe]
[    2.146091] pnp 00:09: [io  0xab00-0xabfe]
[    2.146098] pnp 00:09: [io  0xac00-0xacfe]
[    2.146104] pnp 00:09: [io  0xad00-0xadfe]
[    2.146111] pnp 00:09: [io  0xae00-0xaefe]
[    2.146117] pnp 00:09: [io  0xaf00-0xaffe]
[    2.147158] pnp 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)=

[    2.147236] pnp: PnP ACPI: found 10 devices
[    2.147343] ACPI: ACPI bus type pnp unregistered
[    2.147497] system 00:01: [io  0x0c00-0x0c7f] has been reserved
[    2.147653] system 00:08: [mem 0x00000000-0x0009ffff] could not be res=
erved
[    2.147777] system 00:08: [mem 0x00100000-0x00ffffff] could not be res=
erved
[    2.147899] system 00:08: [mem 0x01000000-0x7f686bff] could not be res=
erved
[    2.148051] system 00:08: [mem 0x000f0000-0x000fffff] could not be res=
erved
[    2.148166] system 00:08: [mem 0x000c0000-0x000cffff] has been reserve=
d
[    2.148288] system 00:08: [mem 0xfec00000-0xfecfffff] could not be res=
erved
[    2.148404] system 00:08: [mem 0xfee00000-0xfeefffff] has been reserve=
d
[    2.148519] system 00:08: [mem 0xfed20000-0xfed9ffff] has been reserve=
d
[    2.148634] system 00:08: [mem 0xffb00000-0xffbfffff] has been reserve=
d
[    2.148749] system 00:08: [mem 0xffc00000-0xffffffff] has been reserve=
d
[    2.148895] system 00:09: [io  0x0100-0x01fe] could not be reserved
[    2.149009] system 00:09: [io  0x0200-0x0277] has been reserved
[    2.149122] system 00:09: [io  0x0280-0x02e7] has been reserved
[    2.149236] system 00:09: [io  0x02f0-0x02f7] has been reserved
[    2.149355] system 00:09: [io  0x0300-0x0377] could not be reserved
[    2.149469] system 00:09: [io  0x0380-0x03bb] has been reserved
[    2.149589] system 00:09: [io  0x03c0-0x03e7] could not be reserved
[    2.149709] system 00:09: [io  0x03f6-0x03f7] could not be reserved
[    2.149824] system 00:09: [io  0x0400-0x04cf] has been reserved
[    2.149937] system 00:09: [io  0x04d2-0x057f] has been reserved
[    2.150051] system 00:09: [io  0x0580-0x0677] has been reserved
[    2.150165] system 00:09: [io  0x0680-0x0777] has been reserved
[    2.150278] system 00:09: [io  0x0780-0x07bb] has been reserved
[    2.150392] system 00:09: [io  0x07c0-0x07ff] has been reserved
[    2.150505] system 00:09: [io  0x08e0-0x08ff] has been reserved
[    2.150618] system 00:09: [io  0x0900-0x09fe] has been reserved
[    2.150733] system 00:09: [io  0x0a00-0x0afe] has been reserved
[    2.150864] system 00:09: [io  0x0b00-0x0bfe] has been reserved
[    2.150978] system 00:09: [io  0x0c80-0x0caf] has been reserved
[    2.151092] system 00:09: [io  0x0cb0-0x0cbf] has been reserved
[    2.151224] system 00:09: [io  0x0cc0-0x0cf7] has been reserved
[    2.151339] system 00:09: [io  0x0d00-0x0dfe] has been reserved
[    2.151452] system 00:09: [io  0x0e00-0x0efe] has been reserved
[    2.151565] system 00:09: [io  0x0f00-0x0ffe] has been reserved
[    2.151679] system 00:09: [io  0x2000-0x20fe] has been reserved
[    2.151793] system 00:09: [io  0x2100-0x21fe] has been reserved
[    2.151906] system 00:09: [io  0x2200-0x22fe] has been reserved
[    2.152046] system 00:09: [io  0x2300-0x23fe] has been reserved
[    2.152160] system 00:09: [io  0x2400-0x24fe] has been reserved
[    2.152275] system 00:09: [io  0x2500-0x25fe] has been reserved
[    2.152389] system 00:09: [io  0x2600-0x26fe] has been reserved
[    2.152503] system 00:09: [io  0x2700-0x27fe] has been reserved
[    2.152617] system 00:09: [io  0x2800-0x28fe] has been reserved
[    2.152731] system 00:09: [io  0x2900-0x29fe] has been reserved
[    2.152845] system 00:09: [io  0x2a00-0x2afe] has been reserved
[    2.152959] system 00:09: [io  0x2b00-0x2bfe] has been reserved
[    2.153074] system 00:09: [io  0x2c00-0x2cfe] has been reserved
[    2.153188] system 00:09: [io  0x2d00-0x2dfe] has been reserved
[    2.153302] system 00:09: [io  0x2e00-0x2efe] has been reserved
[    2.153416] system 00:09: [io  0x2f00-0x2ffe] has been reserved
[    2.153531] system 00:09: [io  0x5000-0x50fe] has been reserved
[    2.153646] system 00:09: [io  0x5100-0x51fe] has been reserved
[    2.153760] system 00:09: [io  0x5200-0x52fe] has been reserved
[    2.153874] system 00:09: [io  0x5300-0x53fe] has been reserved
[    2.153989] system 00:09: [io  0x5400-0x54fe] has been reserved
[    2.154103] system 00:09: [io  0x5500-0x55fe] has been reserved
[    2.154218] system 00:09: [io  0x5600-0x56fe] has been reserved
[    2.154348] system 00:09: [io  0x5700-0x57fe] has been reserved
[    2.154463] system 00:09: [io  0x5800-0x58fe] has been reserved
[    2.154577] system 00:09: [io  0x5900-0x59fe] has been reserved
[    2.154692] system 00:09: [io  0x5a00-0x5afe] has been reserved
[    2.154806] system 00:09: [io  0x5b00-0x5bfe] has been reserved
[    2.154921] system 00:09: [io  0x5c00-0x5cfe] has been reserved
[    2.155036] system 00:09: [io  0x5d00-0x5dfe] has been reserved
[    2.155152] system 00:09: [io  0x5e00-0x5efe] has been reserved
[    2.155266] system 00:09: [io  0x5f00-0x5ffe] has been reserved
[    2.155381] system 00:09: [io  0x6000-0x60fe] has been reserved
[    2.155495] system 00:09: [io  0x6100-0x61fe] has been reserved
[    2.155610] system 00:09: [io  0x6200-0x62fe] has been reserved
[    2.155726] system 00:09: [io  0x6300-0x63fe] has been reserved
[    2.155840] system 00:09: [io  0x6400-0x64fe] has been reserved
[    2.155952] system 00:09: [io  0x6500-0x65fe] has been reserved
[    2.156173] system 00:09: [io  0x6600-0x66fe] has been reserved
[    2.156285] system 00:09: [io  0x6700-0x67fe] has been reserved
[    2.156398] system 00:09: [io  0x6800-0x68fe] has been reserved
[    2.156511] system 00:09: [io  0x6900-0x69fe] has been reserved
[    2.156642] system 00:09: [io  0x6a00-0x6afe] has been reserved
[    2.156756] system 00:09: [io  0x6b00-0x6bfe] has been reserved
[    2.156869] system 00:09: [io  0x6c00-0x6cfe] has been reserved
[    2.156982] system 00:09: [io  0x6d00-0x6dfe] has been reserved
[    2.157095] system 00:09: [io  0x6e00-0x6efe] has been reserved
[    2.157208] system 00:09: [io  0x6f00-0x6ffe] has been reserved
[    2.157321] system 00:09: [io  0xa000-0xa0fe] has been reserved
[    2.157434] system 00:09: [io  0xa100-0xa1fe] has been reserved
[    2.157549] system 00:09: [io  0xa200-0xa2fe] has been reserved
[    2.157665] system 00:09: [io  0xa300-0xa3fe] has been reserved
[    2.157781] system 00:09: [io  0xa400-0xa4fe] has been reserved
[    2.157913] system 00:09: [io  0xa500-0xa5fe] has been reserved
[    2.158029] system 00:09: [io  0xa600-0xa6fe] has been reserved
[    2.158144] system 00:09: [io  0xa700-0xa7fe] has been reserved
[    2.158260] system 00:09: [io  0xa800-0xa8fe] has been reserved
[    2.158375] system 00:09: [io  0xa900-0xa9fe] has been reserved
[    2.158491] system 00:09: [io  0xaa00-0xaafe] has been reserved
[    2.158607] system 00:09: [io  0xab00-0xabfe] has been reserved
[    2.158723] system 00:09: [io  0xac00-0xacfe] has been reserved
[    2.158839] system 00:09: [io  0xad00-0xadfe] has been reserved
[    2.158955] system 00:09: [io  0xae00-0xaefe] has been reserved
[    2.159071] system 00:09: [io  0xaf00-0xaffe] has been reserved
[    2.159187] system 00:09: [mem 0xf0000000-0xf3ffffff] has been reserve=
d
[    2.159302] system 00:09: [mem 0xfeda0000-0xfedacfff] has been reserve=
d
[    2.183219] pci 0000:00:1c.0: BAR 15: assigned [mem 0xfffe00000-0xffff=
fffff 64bit pref]
[    2.183413] pci 0000:00:1c.1: BAR 15: assigned [mem 0xfffc00000-0xfffd=
fffff 64bit pref]
[    2.183611] pci 0000:00:1c.0: BAR 13: assigned [io  0xd000-0xdfff]
[    2.183733] pci 0000:00:1c.1: BAR 13: assigned [io  0xc000-0xcfff]
[    2.183847] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    2.183952] pci 0000:00:01.0:   bridge window [io  disabled]
[    2.184139] pci 0000:00:01.0:   bridge window [mem 0xfe900000-0xfe9fff=
ff]
[    2.184266] pci 0000:00:01.0:   bridge window [mem pref disabled]
[    2.184387] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    2.184495] pci 0000:00:1c.0:   bridge window [io  0xd000-0xdfff]
[    2.184610] pci 0000:00:1c.0:   bridge window [mem 0xfe800000-0xfe8fff=
ff]
[    2.184723] pci 0000:00:1c.0:   bridge window [mem 0xfffe00000-0xfffff=
ffff 64bit pref]
[    2.184912] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    2.185020] pci 0000:00:1c.1:   bridge window [io  0xc000-0xcfff]
[    2.185135] pci 0000:00:1c.1:   bridge window [mem 0xfe700000-0xfe7fff=
ff]
[    2.185248] pci 0000:00:1c.1:   bridge window [mem 0xfffc00000-0xfffdf=
ffff 64bit pref]
[    2.185437] pci 0000:00:1e.0: PCI bridge to [bus 04-04]
[    2.185540] pci 0000:00:1e.0:   bridge window [io  disabled]
[    2.185653] pci 0000:00:1e.0:   bridge window [mem disabled]
[    2.185763] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    2.185980] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ =
16
[    2.186098] pci 0000:00:01.0: setting latency timer to 64
[    2.186130] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ =
16
[    2.186247] pci 0000:00:1c.0: setting latency timer to 64
[    2.186367] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ =
17
[    2.186485] pci 0000:00:1c.1: setting latency timer to 64
[    2.186511] pci 0000:00:1e.0: setting latency timer to 64
[    2.186521] pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
[    2.186527] pci_bus 0000:00: resource 1 [mem 0x00000000-0xfffffffff]
[    2.186533] pci_bus 0000:01: resource 1 [mem 0xfe900000-0xfe9fffff]
[    2.186538] pci_bus 0000:02: resource 0 [io  0xd000-0xdfff]
[    2.186543] pci_bus 0000:02: resource 1 [mem 0xfe800000-0xfe8fffff]
[    2.186549] pci_bus 0000:02: resource 2 [mem 0xfffe00000-0xfffffffff 6=
4bit pref]
[    2.186555] pci_bus 0000:03: resource 0 [io  0xc000-0xcfff]
[    2.186560] pci_bus 0000:03: resource 1 [mem 0xfe700000-0xfe7fffff]
[    2.186565] pci_bus 0000:03: resource 2 [mem 0xfffc00000-0xfffdfffff 6=
4bit pref]
[    2.186571] pci_bus 0000:04: resource 4 [io  0x0000-0xffff]
[    2.186576] pci_bus 0000:04: resource 5 [mem 0x00000000-0xfffffffff]
[    2.186879] NET: Registered protocol family 2
[    2.188089] IP route cache hash table entries: 65536 (order: 7, 524288=
 bytes)
[    2.193984] TCP established hash table entries: 262144 (order: 10, 419=
4304 bytes)
[    2.200557] TCP bind hash table entries: 65536 (order: 10, 5242880 byt=
es)
[    2.212297] TCP: Hash tables configured (established 262144 bind 65536=
)
[    2.212487] TCP reno registered
[    2.212789] UDP hash table entries: 1024 (order: 5, 196608 bytes)
[    2.213420] UDP-Lite hash table entries: 1024 (order: 5, 196608 bytes)=

[    2.214740] pci 0000:00:00.0: calling quirk_e100_interrupt+0x0/0x1c9
[    2.214752] pci 0000:00:00.0: calling quirk_cardbus_legacy+0x0/0x35
[    2.214759] pci 0000:00:00.0: calling quirk_usb_early_handoff+0x0/0x13=
a
[    2.214766] pci 0000:00:00.0: calling pci_fixup_video+0x0/0xf8
[    2.214792] pci 0000:00:01.0: calling quirk_e100_interrupt+0x0/0x1c9
[    2.214799] pci 0000:00:01.0: calling quirk_cardbus_legacy+0x0/0x35
[    2.214806] pci 0000:00:01.0: calling quirk_usb_early_handoff+0x0/0x13=
a
[    2.214812] pci 0000:00:01.0: calling pci_fixup_video+0x0/0xf8
[    2.214834] pci 0000:00:02.0: calling quirk_e100_interrupt+0x0/0x1c9
[    2.214841] pci 0000:00:02.0: calling quirk_cardbus_legacy+0x0/0x35
[    2.214847] pci 0000:00:02.0: calling quirk_usb_early_handoff+0x0/0x13=
a
[    2.214853] pci 0000:00:02.0: calling pci_fixup_video+0x0/0xf8
[    2.214862] pci 0000:00:02.0: Boot video device
[    2.214883] pci 0000:00:02.1: calling quirk_e100_interrupt+0x0/0x1c9
[    2.214890] pci 0000:00:02.1: calling quirk_cardbus_legacy+0x0/0x35
[    2.214897] pci 0000:00:02.1: calling quirk_usb_early_handoff+0x0/0x13=
a
[    2.214903] pci 0000:00:02.1: calling pci_fixup_video+0x0/0xf8
[    2.214924] pci 0000:00:1c.0: calling quirk_e100_interrupt+0x0/0x1c9
[    2.214931] pci 0000:00:1c.0: calling quirk_cardbus_legacy+0x0/0x35
[    2.214938] pci 0000:00:1c.0: calling quirk_usb_early_handoff+0x0/0x13=
a
[    2.214944] pci 0000:00:1c.0: calling pci_fixup_video+0x0/0xf8
[    2.214966] pci 0000:00:1c.1: calling quirk_e100_interrupt+0x0/0x1c9
[    2.214973] pci 0000:00:1c.1: calling quirk_cardbus_legacy+0x0/0x35
[    2.214979] pci 0000:00:1c.1: calling quirk_usb_early_handoff+0x0/0x13=
a
[    2.214985] pci 0000:00:1c.1: calling pci_fixup_video+0x0/0xf8
[    2.215007] pci 0000:00:1d.0: calling quirk_e100_interrupt+0x0/0x1c9
[    2.215014] pci 0000:00:1d.0: calling quirk_cardbus_legacy+0x0/0x35
[    2.215020] pci 0000:00:1d.0: calling quirk_usb_early_handoff+0x0/0x13=
a
[    2.215035] pci 0000:00:1d.0: uhci_check_and_reset_hc: cmd =3D 0x0081
[    2.215041] pci 0000:00:1d.0: Performing full reset
[    2.215061] pci 0000:00:1d.0: calling pci_fixup_video+0x0/0xf8
[    2.215083] pci 0000:00:1d.1: calling quirk_e100_interrupt+0x0/0x1c9
[    2.215090] pci 0000:00:1d.1: calling quirk_cardbus_legacy+0x0/0x35
[    2.215097] pci 0000:00:1d.1: calling quirk_usb_early_handoff+0x0/0x13=
a
[    2.215111] pci 0000:00:1d.1: uhci_check_and_reset_hc: cmd =3D 0x0081
[    2.215117] pci 0000:00:1d.1: Performing full reset
[    2.215136] pci 0000:00:1d.1: calling pci_fixup_video+0x0/0xf8
[    2.215158] pci 0000:00:1d.2: calling quirk_e100_interrupt+0x0/0x1c9
[    2.215165] pci 0000:00:1d.2: calling quirk_cardbus_legacy+0x0/0x35
[    2.215172] pci 0000:00:1d.2: calling quirk_usb_early_handoff+0x0/0x13=
a
[    2.215185] pci 0000:00:1d.2: uhci_check_and_reset_hc: cmd =3D 0x0081
[    2.215191] pci 0000:00:1d.2: Performing full reset
[    2.215210] pci 0000:00:1d.2: calling pci_fixup_video+0x0/0xf8
[    2.215232] pci 0000:00:1d.3: calling quirk_e100_interrupt+0x0/0x1c9
[    2.215239] pci 0000:00:1d.3: calling quirk_cardbus_legacy+0x0/0x35
[    2.215246] pci 0000:00:1d.3: calling quirk_usb_early_handoff+0x0/0x13=
a
[    2.215259] pci 0000:00:1d.3: uhci_check_and_reset_hc: cmd =3D 0x0081
[    2.215265] pci 0000:00:1d.3: Performing full reset
[    2.215284] pci 0000:00:1d.3: calling pci_fixup_video+0x0/0xf8
[    2.215306] pci 0000:00:1d.7: calling quirk_e100_interrupt+0x0/0x1c9
[    2.215313] pci 0000:00:1d.7: calling quirk_cardbus_legacy+0x0/0x35
[    2.215319] pci 0000:00:1d.7: calling quirk_usb_early_handoff+0x0/0x13=
a
[    2.215416] pci 0000:00:1d.7: calling pci_fixup_video+0x0/0xf8
[    2.215451] pci 0000:00:1e.0: calling quirk_e100_interrupt+0x0/0x1c9
[    2.215459] pci 0000:00:1e.0: calling quirk_cardbus_legacy+0x0/0x35
[    2.215465] pci 0000:00:1e.0: calling quirk_usb_early_handoff+0x0/0x13=
a
[    2.215471] pci 0000:00:1e.0: calling pci_fixup_video+0x0/0xf8
[    2.215493] pci 0000:00:1e.2: calling quirk_e100_interrupt+0x0/0x1c9
[    2.215500] pci 0000:00:1e.2: calling quirk_cardbus_legacy+0x0/0x35
[    2.215506] pci 0000:00:1e.2: calling quirk_usb_early_handoff+0x0/0x13=
a
[    2.215512] pci 0000:00:1e.2: calling pci_fixup_video+0x0/0xf8
[    2.215534] pci 0000:00:1f.0: calling quirk_e100_interrupt+0x0/0x1c9
[    2.215541] pci 0000:00:1f.0: calling quirk_cardbus_legacy+0x0/0x35
[    2.215547] pci 0000:00:1f.0: calling quirk_usb_early_handoff+0x0/0x13=
a
[    2.215553] pci 0000:00:1f.0: calling pci_fixup_video+0x0/0xf8
[    2.215576] pci 0000:00:1f.1: calling quirk_e100_interrupt+0x0/0x1c9
[    2.215583] pci 0000:00:1f.1: calling quirk_cardbus_legacy+0x0/0x35
[    2.215589] pci 0000:00:1f.1: calling quirk_usb_early_handoff+0x0/0x13=
a
[    2.215595] pci 0000:00:1f.1: calling pci_fixup_video+0x0/0xf8
[    2.215619] pci 0000:00:1f.2: calling quirk_e100_interrupt+0x0/0x1c9
[    2.215626] pci 0000:00:1f.2: calling quirk_cardbus_legacy+0x0/0x35
[    2.215632] pci 0000:00:1f.2: calling quirk_usb_early_handoff+0x0/0x13=
a
[    2.215638] pci 0000:00:1f.2: calling pci_fixup_video+0x0/0xf8
[    2.215660] pci 0000:00:1f.3: calling quirk_e100_interrupt+0x0/0x1c9
[    2.215667] pci 0000:00:1f.3: calling quirk_cardbus_legacy+0x0/0x35
[    2.215673] pci 0000:00:1f.3: calling quirk_usb_early_handoff+0x0/0x13=
a
[    2.215679] pci 0000:00:1f.3: calling pci_fixup_video+0x0/0xf8
[    2.215702] pci 0000:02:00.0: calling quirk_cardbus_legacy+0x0/0x35
[    2.215709] pci 0000:02:00.0: calling quirk_usb_early_handoff+0x0/0x13=
a
[    2.215715] pci 0000:02:00.0: calling pci_fixup_video+0x0/0xf8
[    2.215733] PCI: CLS 64 bytes, default 64
[    2.216813] Unpacking initramfs...
[    2.414912] debug: unmapping init memory ffff880037be5000..ffff880037f=
f0000
[    2.489701] DMA-API: preallocated 32768 debug entries
[    2.489813] DMA-API: debugging enabled by kernel config
[    2.490289] Simple Boot Flag at 0x7a set to 0x1
[    2.492544] Scanning for low memory corruption every 60 seconds
[    2.497355] Initializing RT-Tester: OK
[    2.497868] audit: initializing netlink socket (disabled)
[    2.498150] type=3D2000 audit(1288618863.496:1): initialized
[    2.717718] Kprobe smoke test started
[    2.740154] Kprobe smoke test passed successfully
[    2.741852] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    2.791962] VFS: Disk quotas dquot_6.5.2
[    2.792857] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    2.794086] msgmni has been set to 3930
[    2.795956] cryptomgr_test used greatest stack depth: 6696 bytes left
[    2.797460] Block layer SCSI generic (bsg) driver version 0.4 loaded (=
major 254)
[    2.797661] io scheduler noop registered (default)
[    2.797766] list_sort_test: start testing list_sort()
[    2.805325] ERST: Table is not found!
[    2.950568] Linux agpgart interface v0.103
[    2.950952] [drm] Initialized drm 1.1.0 20060810
[    2.951834] Fixed MDIO Bus: probed
[    2.951967] cpuidle: using governor ladder
[    2.952113] cpuidle: using governor menu
[    2.956678] registered taskstats version 1
[    2.957183] IMA: No TPM chip found, activating TPM-bypass!
[    2.959144] hd: no drives specified - use hd=3Dcyl,head,sectors on ker=
nel command line
[    2.959853] Initalizing network drop monitor service
[    2.960692] debug: unmapping init memory ffffffff81c9b000..ffffffff81f=
a5000
[    2.961201] Write protecting the kernel read-only data: 10240k
[    2.961881] Testing CPA: undo ffffffff81000000-ffffffff81a00000
[    2.962487] Testing CPA: again
[    2.963082] debug: unmapping init memory ffff88000155c000..ffff8800016=
00000
[    2.963313] debug: unmapping init memory ffff8800018b2000..ffff880001a=
00000
[    2.999393] modprobe used greatest stack depth: 5248 bytes left
[    3.045067] nash-hotplug (56): /proc/56/oom_adj is deprecated, please =
use /proc/56/oom_score_adj instead.
[    3.356988] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0=
C0C:00/input/input0
[    3.357225] ACPI: Power Button [VBTN]
[    3.357932] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/in=
put/input1
[    3.358144] ACPI: Power Button [PWRF]
[    3.370517] agpgart-intel 0000:00:00.0: Intel 945G Chipset
[    3.371028] agpgart-intel 0000:00:00.0: detected gtt size: 262144K tot=
al, 262144K mappable
[    3.372244] agpgart-intel 0000:00:00.0: detected 8192K stolen memory
[    3.378408] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xe0000=
000
[    3.450060] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ=
 16
[    3.450187] i915 0000:00:02.0: enabling bus mastering
[    3.450199] i915 0000:00:02.0: setting latency timer to 64
[    3.640827] i2c i2c-0: adapter [gmbus disabled] registered
[    3.641059] i2c i2c-1: adapter [gmbus ssc] registered
[    3.641291] i2c i2c-2: adapter [GPIOB] registered
[    3.641513] i2c i2c-3: adapter [gmbus vga] registered
[    3.641763] i2c i2c-4: adapter [GPIOA] registered
[    3.642000] i2c i2c-5: adapter [gmbus panel] registered
[    3.642240] i2c i2c-6: adapter [GPIOC] registered
[    3.642481] i2c i2c-7: adapter [gmbus dpc] registered
[    3.642711] i2c i2c-8: adapter [GPIOD] registered
[    3.642933] i2c i2c-9: adapter [gmbus dpb] registered
[    3.643178] i2c i2c-10: adapter [GPIOE] registered
[    3.643404] i2c i2c-11: adapter [gmbus reserveddpd] registered
[    3.643671] i2c i2c-12: adapter [GPIOF] registered
[    3.643918] i2c i2c-13: adapter [gmbus (null)] registered
[    3.644252] i2c i2c-14: adapter [GPIO?] registered
[    3.646161] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecode=
s=3Dio+mem,decodes=3Dio+mem:owns=3Dio+mem
[    3.646893] [drm] initialized overlay support
[    3.680143] i2c i2c-3: master_xfer[0] W, addr=3D0x50, len=3D1
[    3.680150] i2c i2c-3: master_xfer[1] R, addr=3D0x50, len=3D1
[    3.681895] i2c i2c-3: master_xfer[0] W, addr=3D0x50, len=3D1
[    3.681901] i2c i2c-3: master_xfer[1] R, addr=3D0x50, len=3D128
[    3.776106] fbcon: inteldrmfb (fb0) is primary device
[    3.791070] Console: switching to colour frame buffer device 160x64
[    3.797988] fb0: inteldrmfb frame buffer device
[    3.798033] drm: registered panic notifier
[    3.798128] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on =
minor 0
[    3.800549] modprobe used greatest stack depth: 4000 bytes left
[    4.058888] usbcore: registered new interface driver usbfs
[    4.059318] usbcore: registered new interface driver hub
[    4.060337] usbcore: registered new device driver usb
[    4.069161] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver=

[    4.069240] ehci_hcd: block sizes: qh 104 qtd 96 itd 192 sitd 96
[    4.069460] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 21 (level, low) ->=
 IRQ 21
[    4.069601] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    4.069611] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    4.069905] /local/linsrc/lnx-2637-rc1/drivers/usb/core/inode.c: creat=
ing file 'devices'
[    4.069959] /local/linsrc/lnx-2637-rc1/drivers/usb/core/inode.c: creat=
ing file '001'
[    4.070012] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bu=
s number 1
[    4.070550] ehci_hcd 0000:00:1d.7: reset hcs_params 0x104208 dbg=3D1 c=
c=3D4 pcc=3D2 ordered !ppc ports=3D8
[    4.070559] ehci_hcd 0000:00:1d.7: reset hcc_params 6871 thresh 7 ufra=
mes 1024 64 bit addr
[    4.070755] ehci_hcd 0000:00:1d.7: using broken periodic workaround
[    4.070842] ehci_hcd 0000:00:1d.7: debug port 1
[    4.070892] ehci_hcd 0000:00:1d.7: reset command 0000002 (park)=3D0 it=
hresh=3D0 period=3D1024 Reset HALT
[    4.074800] ehci_hcd 0000:00:1d.7: cache line size of 64 is not suppor=
ted
[    4.074806] ehci_hcd 0000:00:1d.7: supports USB remote wakeup
[    4.074957] ehci_hcd 0000:00:1d.7: irq 21, io mem 0xffa80800
[    4.075020] ehci_hcd 0000:00:1d.7: reset command 0080002 (park)=3D0 it=
hresh=3D8 period=3D1024 Reset HALT
[    4.078910] ehci_hcd 0000:00:1d.7: init command 0010001 (park)=3D0 ith=
resh=3D1 period=3D1024 RUN
[    4.088172] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    4.088704] usb usb1: default language 0x0409
[    4.088806] usb usb1: udev 1, busnum 1, minor =3D 0
[    4.088812] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    4.088880] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Se=
rialNumber=3D1
[    4.088950] usb usb1: Product: EHCI Host Controller
[    4.088998] usb usb1: Manufacturer: Linux 2.6.37-rc1 ehci_hcd
[    4.089055] usb usb1: SerialNumber: 0000:00:1d.7
[    4.089920] usb usb1: usb_probe_device
[    4.089927] usb usb1: configuration #1 chosen from 1 choice
[    4.090045] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    4.090333] hub 1-0:1.0: usb_probe_interface
[    4.090339] hub 1-0:1.0: usb_probe_interface - got id
[    4.090344] hub 1-0:1.0: USB hub found
[    4.090453] hub 1-0:1.0: 8 ports detected
[    4.090495] hub 1-0:1.0: standalone hub
[    4.090500] hub 1-0:1.0: no power switching (usb 1.0)
[    4.090504] hub 1-0:1.0: individual port over-current protection
[    4.090514] hub 1-0:1.0: power on to power good time: 20ms
[    4.090610] hub 1-0:1.0: local power source is good
[    4.090618] hub 1-0:1.0: trying to enable port power on non-switchable=
 hub
[    4.091288] /local/linsrc/lnx-2637-rc1/drivers/usb/core/inode.c: creat=
ing file '001'
[    4.166675] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    4.166751] ohci_hcd: block sizes: ed 80 td 96
[    4.181209] uhci_hcd: USB Universal Host Controller Interface driver
[    4.181887] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 21 (level, low) ->=
 IRQ 21
[    4.181999] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    4.182009] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    4.182115] /local/linsrc/lnx-2637-rc1/drivers/usb/core/inode.c: creat=
ing file '002'
[    4.182148] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bu=
s number 2
[    4.188319] ehci_hcd 0000:00:1d.7: GetStatus port:3 status 001803 0  A=
CK POWER sig=3Dj CSC CONNECT
[    4.188342] hub 1-0:1.0: port 3: status 0501 change 0001
[    4.192285] uhci_hcd 0000:00:1d.0: detected 2 ports
[    4.192344] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd =3D 0x=
0000
[    4.192349] uhci_hcd 0000:00:1d.0: Performing full reset
[    4.192368] uhci_hcd 0000:00:1d.0: supports USB remote wakeup
[    4.192419] uhci_hcd 0000:00:1d.0: irq 21, io base 0x0000ff80
[    4.192827] usb usb2: default language 0x0409
[    4.192929] usb usb2: udev 1, busnum 2, minor =3D 128
[    4.192935] usb usb2: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    4.193003] usb usb2: New USB device strings: Mfr=3D3, Product=3D2, Se=
rialNumber=3D1
[    4.193074] usb usb2: Product: UHCI Host Controller
[    4.193122] usb usb2: Manufacturer: Linux 2.6.37-rc1 uhci_hcd
[    4.193179] usb usb2: SerialNumber: 0000:00:1d.0
[    4.193929] usb usb2: usb_probe_device
[    4.193937] usb usb2: configuration #1 chosen from 1 choice
[    4.193993] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[    4.194254] hub 2-0:1.0: usb_probe_interface
[    4.194260] hub 2-0:1.0: usb_probe_interface - got id
[    4.194265] hub 2-0:1.0: USB hub found
[    4.194377] hub 2-0:1.0: 2 ports detected
[    4.194419] hub 2-0:1.0: standalone hub
[    4.194424] hub 2-0:1.0: no power switching (usb 1.0)
[    4.194429] hub 2-0:1.0: individual port over-current protection
[    4.194442] hub 2-0:1.0: power on to power good time: 2ms
[    4.194495] hub 2-0:1.0: local power source is good
[    4.194503] hub 2-0:1.0: trying to enable port power on non-switchable=
 hub
[    4.194989] /local/linsrc/lnx-2637-rc1/drivers/usb/core/inode.c: creat=
ing file '001'
[    4.195327] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.0
[    4.195559] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 22 (level, low) ->=
 IRQ 22
[    4.195666] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    4.195675] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    4.195761] /local/linsrc/lnx-2637-rc1/drivers/usb/core/inode.c: creat=
ing file '003'
[    4.195790] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bu=
s number 3
[    4.220143] uhci_hcd 0000:00:1d.1: detected 2 ports
[    4.222232] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd =3D 0x=
0000
[    4.222238] uhci_hcd 0000:00:1d.1: Performing full reset
[    4.222257] uhci_hcd 0000:00:1d.1: supports USB remote wakeup
[    4.222436] uhci_hcd 0000:00:1d.1: irq 22, io base 0x0000ff60
[    4.224883] usb usb3: default language 0x0409
[    4.224991] usb usb3: udev 1, busnum 3, minor =3D 256
[    4.224997] usb usb3: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    4.227113] usb usb3: New USB device strings: Mfr=3D3, Product=3D2, Se=
rialNumber=3D1
[    4.229266] usb usb3: Product: UHCI Host Controller
[    4.231345] usb usb3: Manufacturer: Linux 2.6.37-rc1 uhci_hcd
[    4.233431] usb usb3: SerialNumber: 0000:00:1d.1
[    4.236201] usb usb3: usb_probe_device
[    4.236208] usb usb3: configuration #1 chosen from 1 choice
[    4.236271] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[    4.236530] hub 3-0:1.0: usb_probe_interface
[    4.236536] hub 3-0:1.0: usb_probe_interface - got id
[    4.236541] hub 3-0:1.0: USB hub found
[    4.238613] hub 3-0:1.0: 2 ports detected
[    4.240619] hub 3-0:1.0: standalone hub
[    4.240629] hub 3-0:1.0: no power switching (usb 1.0)
[    4.240637] hub 3-0:1.0: individual port over-current protection
[    4.240663] hub 3-0:1.0: power on to power good time: 2ms
[    4.240808] hub 3-0:1.0: local power source is good
[    4.240816] hub 3-0:1.0: trying to enable port power on non-switchable=
 hub
[    4.241472] /local/linsrc/lnx-2637-rc1/drivers/usb/core/inode.c: creat=
ing file '001'
[    4.241783] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.1
[    4.241982] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) ->=
 IRQ 18
[    4.244158] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    4.244182] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    4.246217] /local/linsrc/lnx-2637-rc1/drivers/usb/core/inode.c: creat=
ing file '004'
[    4.246248] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bu=
s number 4
[    4.248788] uhci_hcd 0000:00:1d.2: detected 2 ports
[    4.250714] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd =3D 0x=
0000
[    4.250719] uhci_hcd 0000:00:1d.2: Performing full reset
[    4.250738] uhci_hcd 0000:00:1d.2: supports USB remote wakeup
[    4.250886] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000ff40
[    4.253128] usb usb4: default language 0x0409
[    4.253256] usb usb4: udev 1, busnum 4, minor =3D 384
[    4.253261] usb usb4: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    4.255247] usb usb4: New USB device strings: Mfr=3D3, Product=3D2, Se=
rialNumber=3D1
[    4.257247] usb usb4: Product: UHCI Host Controller
[    4.259196] usb usb4: Manufacturer: Linux 2.6.37-rc1 uhci_hcd
[    4.261134] usb usb4: SerialNumber: 0000:00:1d.2
[    4.263693] usb usb4: usb_probe_device
[    4.263699] usb usb4: configuration #1 chosen from 1 choice
[    4.263758] usb usb4: adding 4-0:1.0 (config #1, interface 0)
[    4.264485] hub 4-0:1.0: usb_probe_interface
[    4.264491] hub 4-0:1.0: usb_probe_interface - got id
[    4.264496] hub 4-0:1.0: USB hub found
[    4.266480] hub 4-0:1.0: 2 ports detected
[    4.268389] hub 4-0:1.0: standalone hub
[    4.268394] hub 4-0:1.0: no power switching (usb 1.0)
[    4.268398] hub 4-0:1.0: individual port over-current protection
[    4.268411] hub 4-0:1.0: power on to power good time: 2ms
[    4.268465] hub 4-0:1.0: local power source is good
[    4.268472] hub 4-0:1.0: trying to enable port power on non-switchable=
 hub
[    4.268950] /local/linsrc/lnx-2637-rc1/drivers/usb/core/inode.c: creat=
ing file '001'
[    4.269284] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.2
[    4.269496] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 23 (level, low) ->=
 IRQ 23
[    4.271462] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[    4.271471] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    4.273500] /local/linsrc/lnx-2637-rc1/drivers/usb/core/inode.c: creat=
ing file '005'
[    4.273571] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bu=
s number 5
[    4.275921] uhci_hcd 0000:00:1d.3: detected 2 ports
[    4.277843] uhci_hcd 0000:00:1d.3: uhci_check_and_reset_hc: cmd =3D 0x=
0000
[    4.277848] uhci_hcd 0000:00:1d.3: Performing full reset
[    4.277867] uhci_hcd 0000:00:1d.3: supports USB remote wakeup
[    4.278010] uhci_hcd 0000:00:1d.3: irq 23, io base 0x0000ff20
[    4.280225] usb usb5: default language 0x0409
[    4.280331] usb usb5: udev 1, busnum 5, minor =3D 512
[    4.280336] usb usb5: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    4.282225] usb usb5: New USB device strings: Mfr=3D3, Product=3D2, Se=
rialNumber=3D1
[    4.284141] usb usb5: Product: UHCI Host Controller
[    4.286016] usb usb5: Manufacturer: Linux 2.6.37-rc1 uhci_hcd
[    4.287916] usb usb5: SerialNumber: 0000:00:1d.3
[    4.290751] usb usb5: usb_probe_device
[    4.290765] usb usb5: configuration #1 chosen from 1 choice
[    4.290904] usb usb5: adding 5-0:1.0 (config #1, interface 0)
[    4.291272] hub 5-0:1.0: usb_probe_interface
[    4.291287] hub 5-0:1.0: usb_probe_interface - got id
[    4.291296] hub 5-0:1.0: USB hub found
[    4.293343] hub 5-0:1.0: 2 ports detected
[    4.295197] hub 5-0:1.0: standalone hub
[    4.295201] hub 5-0:1.0: no power switching (usb 1.0)
[    4.295206] hub 5-0:1.0: individual port over-current protection
[    4.295219] hub 5-0:1.0: power on to power good time: 2ms
[    4.295275] hub 5-0:1.0: local power source is good
[    4.295283] hub 5-0:1.0: trying to enable port power on non-switchable=
 hub
[    4.295824] /local/linsrc/lnx-2637-rc1/drivers/usb/core/inode.c: creat=
ing file '001'
[    4.296322] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.3
[    4.296914] hub 1-0:1.0: state 7 ports 8 chg 0008 evt 0000
[    4.297068] hub 1-0:1.0: port 3, status 0501, change 0000, 480 Mb/s
[    4.340157] uhci_hcd 0000:00:1d.1: port 1 portsc 008a,00
[    4.352450] ehci_hcd 0000:00:1d.7: port 3 full speed --> companion
[    4.352465] ehci_hcd 0000:00:1d.7: GetStatus port:3 status 003801 0  A=
CK POWER OWNER sig=3Dj CONNECT
[    4.352495] hub 1-0:1.0: port 3 not reset yet, waiting 50ms
[    4.388168] ata_piix 0000:00:1f.1: version 2.13
[    4.388214] ata_piix 0000:00:1f.1: PCI INT A -> GSI 16 (level, low) ->=
 IRQ 16
[    4.390602] ata_piix 0000:00:1f.1: setting latency timer to 64
[    4.394552] scsi0 : ata_piix
[    4.398590] scsi1 : ata_piix
[    4.408210] ehci_hcd 0000:00:1d.7: GetStatus port:3 status 003002 0  A=
CK POWER OWNER sig=3Dse0 CSC
[    4.408502] hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    4.408532] hub 1-0:1.0: state 7 ports 8 chg 0000 evt 0008
[    4.408632] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    4.408661] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    4.409987] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 i=
rq 14
[    4.411874] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xffa8 i=
rq 15
[    4.414071] ata_piix 0000:00:1f.2: PCI INT C -> GSI 20 (level, low) ->=
 IRQ 20
[    4.414704] ata2: port disabled. ignoring.
[    4.416104] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
[    4.440193] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    4.444133] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0002
[    4.444196] uhci_hcd 0000:00:1d.1: port 1 portsc 0093,00
[    4.444364] hub 3-0:1.0: port 1, status 0101, change 0001, 12 Mb/s
[    4.572258] hub 3-0:1.0: debounce: port 1: total 100ms stable 100ms st=
atus 0x101
[    4.572339] ata_piix 0000:00:1f.2: setting latency timer to 64
[    4.575978] scsi2 : ata_piix
[    4.576541] ata1.00: ATAPI: HL-DT-STDVD+-RW GSA-H21N, A105, max UDMA/3=
3
[    4.580771] scsi3 : ata_piix
[    4.583178] ata3: SATA max UDMA/133 cmd 0xfe00 ctl 0xfe10 bmdma 0xfea0=
 irq 20
[    4.584377] ata1.00: configured for UDMA/33
[    4.587163] ata4: SATA max UDMA/133 cmd 0xfe20 ctl 0xfe30 bmdma 0xfea8=
 irq 20
[    4.588253] scsi 0:0:0:0: CD-ROM            HL-DT-ST DVD+-RW GSA-H21N =
A105 PQ: 0 ANSI: 5
[    4.684102] usb 3-1: new full speed USB device using uhci_hcd and addr=
ess 2
[    4.752383] ata3.00: ATA-7: WDC WD2500JS-75NCB3, 10.02E04, max UDMA/13=
3
[    4.754433] ata3.00: 488281250 sectors, multi 8: LBA48 NCQ (depth 0/32=
)
[    4.764382] ata3.00: configured for UDMA/133
[    4.766882] scsi 2:0:0:0: Direct-Access     ATA      WDC WD2500JS-75N =
10.0 PQ: 0 ANSI: 5
[    4.771381] sd 2:0:0:0: [sda] 488281250 512-byte logical blocks: (250 =
GB/232 GiB)
[    4.774175] sd 2:0:0:0: [sda] Write Protect is off
[    4.776300] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    4.776591] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enable=
d, doesn't support DPO or FUA
[    4.820110] usb 3-1: ep0 maxpacket =3D 8
[    4.826887]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[    4.833280] sd 2:0:0:0: [sda] Attached SCSI disk
[    4.842863] usb 3-1: default language 0x0409
[    4.858871] usb 3-1: udev 2, busnum 3, minor =3D 257
[    4.858877] usb 3-1: New USB device found, idVendor=3D413c, idProduct=3D=
1003
[    4.861008] usb 3-1: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D0
[    4.863128] usb 3-1: Product: Dell USB Keyboard Hub
[    4.865293] usb 3-1: Manufacturer: Dell
[    4.867971] usb 3-1: usb_probe_device
[    4.867979] usb 3-1: configuration #1 chosen from 1 choice
[    4.873879] usb 3-1: adding 3-1:1.0 (config #1, interface 0)
[    4.876070] hub 3-1:1.0: usb_probe_interface
[    4.876081] hub 3-1:1.0: usb_probe_interface - got id
[    4.876090] hub 3-1:1.0: USB hub found
[    4.878876] hub 3-1:1.0: 3 ports detected
[    4.880984] hub 3-1:1.0: compound device; port removable status: FRR
[    4.880989] hub 3-1:1.0: individual port power switching
[    4.880994] hub 3-1:1.0: individual port over-current protection
[    4.881005] hub 3-1:1.0: power on to power good time: 44ms
[    4.881873] hub 3-1:1.0: hub controller current requirement: 100mA
[    4.881878] hub 3-1:1.0: 100mA bus power budget for each child
[    4.882876] hub 3-1:1.0: enabling power on all ports
[    4.886303] /local/linsrc/lnx-2637-rc1/drivers/usb/core/inode.c: creat=
ing file '002'
[    4.985880] hub 3-1:1.0: port 1: status 0101 change 0001
[    4.988880] hub 3-1:1.0: port 3: status 0301 change 0001
[    5.088101] uhci_hcd 0000:00:1d.1: reserve dev 2 ep81-INT, period 16, =
phase 8, 12 us
[    5.088133] hub 3-1:1.0: state 7 ports 3 chg 000a evt 0000
[    5.089874] hub 3-1:1.0: port 1, status 0101, change 0000, 12 Mb/s
[    5.161919] usb 3-1.1: new full speed USB device using uhci_hcd and ad=
dress 3
[    5.260092] usb 3-1.1: ep0 maxpacket =3D 8
[    5.281909] usb 3-1.1: skipped 1 descriptor after interface
[    5.281919] usb 3-1.1: skipped 1 descriptor after interface
[    5.286879] usb 3-1.1: default language 0x0409
[    5.301892] usb 3-1.1: udev 3, busnum 3, minor =3D 258
[    5.301898] usb 3-1.1: New USB device found, idVendor=3D413c, idProduc=
t=3D2010
[    5.304041] usb 3-1.1: New USB device strings: Mfr=3D1, Product=3D3, S=
erialNumber=3D0
[    5.306162] usb 3-1.1: Product: Dell USB Keyboard
[    5.308286] usb 3-1.1: Manufacturer: Dell
[    5.310909] usb 3-1.1: usb_probe_device
[    5.310916] usb 3-1.1: configuration #1 chosen from 1 choice
[    5.316895] usb 3-1.1: adding 3-1.1:1.0 (config #1, interface 0)
[    5.319176] usb 3-1.1: adding 3-1.1:1.1 (config #1, interface 1)
[    5.321382] /local/linsrc/lnx-2637-rc1/drivers/usb/core/inode.c: creat=
ing file '003'
[    5.321567] hub 3-1:1.0: 350mA power budget left
[    5.321896] hub 3-1:1.0: port 3, status 0301, change 0000, 1.5 Mb/s
[    5.360043] usb usb2: suspend_rh (auto-stop)
[    5.360077] usb usb4: suspend_rh (auto-stop)
[    5.360108] usb usb5: suspend_rh (auto-stop)
[    5.393889] usb 3-1.3: new low speed USB device using uhci_hcd and add=
ress 4
[    5.510907] usb 3-1.3: skipped 1 descriptor after interface
[    5.515887] usb 3-1.3: default language 0x0409
[    5.531897] usb 3-1.3: udev 4, busnum 3, minor =3D 259
[    5.531903] usb 3-1.3: New USB device found, idVendor=3D046d, idProduc=
t=3Dc016
[    5.534111] usb 3-1.3: New USB device strings: Mfr=3D1, Product=3D2, S=
erialNumber=3D0
[    5.536270] usb 3-1.3: Product: Optical USB Mouse
[    5.538351] usb 3-1.3: Manufacturer: Logitech
[    5.540987] usb 3-1.3: usb_probe_device
[    5.540995] usb 3-1.3: configuration #1 chosen from 1 choice
[    5.543909] usb 3-1.3: adding 3-1.3:1.0 (config #1, interface 0)
[    5.544613] /local/linsrc/lnx-2637-rc1/drivers/usb/core/inode.c: creat=
ing file '004'
[    5.544798] hub 3-1:1.0: 250mA power budget left
[    5.544807] hub 3-1:1.0: state 7 ports 3 chg 0000 evt 0008
[    8.837141] Uniform Multi-Platform E-IDE driver
[    9.090234] EXT3-fs: barriers not enabled
[    9.102772] kjournald starting.  Commit interval 5 seconds
[    9.102986] EXT3-fs (sda6): mounted filesystem with ordered data mode
[    9.497036] modprobe used greatest stack depth: 3352 bytes left
[    9.672524] NET: Registered protocol family 1
[   12.254283] udev: starting version 141
[   13.769142] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   13.852353] ACPI: acpi_idle registered with cpuidle
[   14.044530] shpchp: Standard Hot Plug PCI Controller Driver version: 0=
=2E4
[   14.316450] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[   14.412491] parport_pc 00:06: reported by Plug and Play ACPI
[   14.412705] parport0: PC-style at 0x378 (0x778), irq 7, using FIFO [PC=
SPP,TRISTATE,COMPAT,ECP]
[   14.517652] rtc_cmos 00:05: RTC can wake from S4
[   14.533850] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[   14.534047] rtc0: alarms up to one day, 242 bytes nvram, hpet irqs
[   14.645010] intel_rng: Firmware space is locked read-only. If you can'=
t or
[   14.645015] intel_rng: don't want to disable this in firmware setup, a=
nd if
[   14.645017] intel_rng: you are certain that your system has a function=
al
[   14.645019] intel_rng: RNG, try using the 'no_fwh_detect' option.
[   14.712767] serial8250: ttyS0 at I/O 0x3f8 (irq =3D 0) is a 16550A
[   14.946492] input: PC Speaker as /devices/platform/pcspkr/input/input2=

[   15.100262] 00:07: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[   15.117654] sr0: scsi3-mmc drive: 48x/48x writer cd/rw xa/form2 cdda t=
ray
[   15.117679] cdrom: Uniform CD-ROM driver Revision: 3.20
[   15.120199] sr 0:0:0:0: Attached scsi CD-ROM sr0
[   15.155463] sr 0:0:0:0: Attached scsi generic sg0 type 5
[   15.163455] i801_smbus 0000:00:1f.3: PCI INT B -> GSI 17 (level, low) =
-> IRQ 17
[   15.163494] i801_smbus 0000:00:1f.3: SMBus using interrupt SMI#
[   15.163764] i2c i2c-15: adapter [SMBus I801 adapter at e8a0] registere=
d
[   15.170049] dcdbas dcdbas: Dell Systems Management Base Driver (versio=
n 5.6.0-3.2)
[   15.206106] tg3.c:v3.115 (October 14, 2010)
[   15.206177] tg3 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ =
16
[   15.206231] tg3 0000:02:00.0: setting latency timer to 64
[   15.211237] iTCO_vendor_support: vendor-support=3D0
[   15.222889] sd 2:0:0:0: Attached scsi generic sg1 type 0
[   15.325509] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.06
[   15.326971] iTCO_wdt: unable to reset NO_REBOOT flag, device disabled =
by hardware/BIOS
[   15.353705] tg3 0000:02:00.0: eth0: Tigon3 [partno(BCM5751PKFBG) rev 4=
001] (PCI Express) MAC address 00:18:8b:01:d2:2b
[   15.353719] tg3 0000:02:00.0: eth0: attached PHY is 5750 (10/100/1000B=
ase-T Ethernet) (WireSpeed[1])
[   15.353730] tg3 0000:02:00.0: eth0: RXcsums[1] LinkChgREG[0] MIirq[0] =
ASF[0] TSOcap[1]
[   15.353740] tg3 0000:02:00.0: eth0: dma_rwctrl[76180000] dma_mask[64-b=
it]
[   16.118180] usbhid 3-1.1:1.0: usb_probe_interface
[   16.118190] usbhid 3-1.1:1.0: usb_probe_interface - got id
[   16.145394] input: Dell Dell USB Keyboard as /devices/pci0000:00/0000:=
00:1d.1/usb3/3-1/3-1.1/3-1.1:1.0/input/input3
[   16.145684] uhci_hcd 0000:00:1d.1: reserve dev 3 ep81-INT, period 8, p=
hase 4, 17 us
[   16.147158] generic-usb 0003:413C:2010.0001: input,hidraw0: USB HID v1=
=2E10 Keyboard [Dell Dell USB Keyboard] on usb-0000:00:1d.1-1.1/input0
[   16.147262] usbhid 3-1.1:1.1: usb_probe_interface
[   16.147272] usbhid 3-1.1:1.1: usb_probe_interface - got id
[   16.158593] input: Dell Dell USB Keyboard as /devices/pci0000:00/0000:=
00:1d.1/usb3/3-1/3-1.1/3-1.1:1.1/input/input4
[   16.158682] uhci_hcd 0000:00:1d.1: reserve dev 3 ep82-INT, period 128,=
 phase 0, 14 us
[   16.159900] generic-usb 0003:413C:2010.0002: input,hidraw1: USB HID v1=
=2E10 Device [Dell Dell USB Keyboard] on usb-0000:00:1d.1-1.1/input1
[   16.160628] usbhid 3-1.3:1.0: usb_probe_interface
[   16.160640] usbhid 3-1.3:1.0: usb_probe_interface - got id
[   16.176979] input: Logitech Optical USB Mouse as /devices/pci0000:00/0=
000:00:1d.1/usb3/3-1/3-1.3/3-1.3:1.0/input/input5
[   16.178392] generic-usb 0003:046D:C016.0003: input,hidraw2: USB HID v1=
=2E10 Mouse [Logitech Optical USB Mouse] on usb-0000:00:1d.1-1.3/input0
[   16.178707] usbcore: registered new interface driver usbhid
[   16.178718] usbhid: USB HID core driver
[   16.189662] leds_ss4200: no LED devices found
[   16.438594] usbcore: registered new interface driver usbkbd
[   16.438609] usbkbd: :USB HID Boot Protocol keyboard driver
[   16.534192] usbcore: registered new interface driver usbmouse
[   16.534204] usbmouse: v1.6:USB HID Boot Protocol mouse driver
[   17.314254] ppdev: user-space parallel port driver
[   17.461741] Intel ICH 0000:00:1e.2: PCI INT A -> GSI 23 (level, low) -=
> IRQ 23
[   17.462000] Intel ICH 0000:00:1e.2: setting latency timer to 64
[   17.830859] intel8x0: white list rate for 1028:01ad is 48000
[   21.895288] mice: PS/2 mouse device common for all mice
[   22.645880] kvm: disabled by bios
[   23.406199] device-mapper: uevent: version 1.0.3
[   23.423489] device-mapper: ioctl: 4.18.0-ioctl (2010-06-29) initialise=
d: dm-devel@redhat.com
[   23.525184] device-mapper: multipath: version 1.1.1 loaded
[   25.056474] EXT3-fs (sda6): using internal journal
[   25.266876] EXT3-fs: barriers not enabled
[   25.278395] kjournald starting.  Commit interval 5 seconds
[   25.278856] EXT3-fs (sda1): using internal journal
[   25.278889] EXT3-fs (sda1): mounted filesystem with ordered data mode
[   25.296164] EXT3-fs: barriers not enabled
[   25.306044] kjournald starting.  Commit interval 5 seconds
[   25.306591] EXT3-fs (sda3): using internal journal
[   25.306626] EXT3-fs (sda3): mounted filesystem with ordered data mode
[   25.319875] EXT3-fs: barriers not enabled
[   25.329740] kjournald starting.  Commit interval 5 seconds
[   25.330225] EXT3-fs (sda5): using internal journal
[   25.330256] EXT3-fs (sda5): mounted filesystem with ordered data mode
[   26.394704] Adding 4194300k swap on /dev/sda2.  Priority:-1 extents:1 =
across:4194300k=20
[   27.024628] microcode: CPU0 sig=3D0xf64, pf=3D0x4, revision=3D0x4
[   27.061655] microcode: CPU1 sig=3D0xf64, pf=3D0x4, revision=3D0x4
[   27.107005] microcode: Microcode Update Driver: v2.00 <tigran@aivazian=
=2Efsnet.co.uk>, Peter Oruba
[   28.205036] microcode: Microcode Update Driver: v2.00 removed.
[   28.642219] p4-clockmod: P4/Xeon(TM) CPU On-Demand Clock Modulation av=
ailable
[   29.147785] NET: Registered protocol family 10
[   29.154605] lo: Disabled Privacy Extensions
[   29.299623] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   29.394124] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   29.683781] ip_tables: (C) 2000-2006 Netfilter Core Team
[   32.492055] CPA self-test:
[   32.508372]  4k 521862 large 0 gb 0 x 262144[ffff880000000000-ffff8800=
3ffff000] miss 0
[   32.550093]  4k 521862 large 0 gb 0 x 262144[ffff880000000000-ffff8800=
3ffff000] miss 0
[   32.590323]  4k 521862 large 0 gb 0 x 262144[ffff880000000000-ffff8800=
3ffff000] miss 0
[   32.590328] ok.
[   36.443329] RPC: Registered udp transport module.
[   36.443345] RPC: Registered tcp transport module.
[   36.443355] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   36.774643] Bluetooth: Core ver 2.15
[   36.774899] NET: Registered protocol family 31
[   36.774904] Bluetooth: HCI device and connection manager initialized
[   36.775082] Bluetooth: HCI socket layer initialized
[   36.856132] Bluetooth: L2CAP ver 2.15
[   36.856146] Bluetooth: L2CAP socket layer initialized
[   36.905005] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   36.905015] Bluetooth: BNEP filters: protocol multicast
[   37.018677] Bridge firewalling registered
[   37.130907] Bluetooth: SCO (Voice Link) ver 0.6
[   37.130923] Bluetooth: SCO socket layer initialized
[   37.567678] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   37.712783] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state rec=
overy directory
[   37.720295] NFSD: starting 90-second grace period
[   37.726874] rpc.nfsd used greatest stack depth: 3288 bytes left
[   38.364629] uhci_hcd 0000:00:1d.1: reserve dev 4 ep81-INT, period 8, p=
hase 4, 93 us
[   39.807508] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   40.814159] lo: Disabled Privacy Extensions
[   41.437393] tg3 0000:02:00.0: eth0: Link is up at 100 Mbps, full duple=
x
[   41.437402] tg3 0000:02:00.0: eth0: Flow control is on for TX and on f=
or RX
[   41.510442] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   41.533067] ------------[ cut here ]------------
[   41.533091] WARNING: at /local/linsrc/lnx-2637-rc1/lib/debugobjects.c:=
259 debug_print_object+0x77/0x86()
[   41.533101] Hardware name: OptiPlex GX620              =20
[   41.533111] ODEBUG: free active (active state 0) object type: percpu_c=
ounter
[   41.533118] Modules linked in: ipt_MASQUERADE iptable_nat nf_nat nfsd =
lockd nfs_acl auth_rpcgss exportfs sco bridge stp llc bnep l2cap crc16 bl=
uetooth rfkill sunrpc ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable=
_filter ip_tables ip6t_REJECT xt_tcpudp nf_conntrack_ipv6 nf_defrag_ipv6 =
xt_state nf_conntrack ip6table_filter ip6_tables x_tables ipv6 p4_clockmo=
d freq_table speedstep_lib binfmt_misc dm_mirror dm_region_hash dm_log dm=
_multipath scsi_dh dm_mod kvm uinput mousedev joydev snd_intel8x0 snd_ac9=
7_codec ppdev ac97_bus snd_seq snd_seq_device usbmouse snd_pcm usbkbd usb=
hid led_class hid iTCO_wdt snd_timer iTCO_vendor_support tg3 dcdbas i2c_i=
801 sg 8250_pnp sr_mod snd pcspkr cdrom rtc_cmos soundcore parport_pc rng=
_core 8250 rtc_core snd_page_alloc evdev shpchp rtc_lib serial_core parpo=
rt pci_hotplug mac_hid unix ide_pci_generic ide_core ata_generic pata_acp=
i ata_piix sd_mod crc_t10dif ext3 jbd mbcache uhci_hcd ohci_hcd ssb mmc_c=
ore pcmcia pcmcia_core firmware_class ehci_hcd usbcore nls_base i915 drm_=
kms_helper intel_agp button intel_gtt video thermal_sys hwmon output [las=
t unloaded: mperf]
[   41.533596] Pid: 5, comm: kworker/u:0 Not tainted 2.6.37-rc1 #2
[   41.533605] Call Trace:
[   41.533625]  [<ffffffff8107ebad>] warn_slowpath_common+0xc6/0xf3
[   41.533640]  [<ffffffff812d1173>] ? __debug_check_no_obj_freed+0x66/0x=
252
[   41.533655]  [<ffffffff8107ecca>] warn_slowpath_fmt+0x5b/0x6b
[   41.533670]  [<ffffffff812d0a6f>] debug_print_object+0x77/0x86
[   41.533683]  [<ffffffff812d11aa>] __debug_check_no_obj_freed+0x9d/0x25=
2
[   41.533703]  [<ffffffff8146f49a>] ? net_free+0x3a/0x45
[   41.533714]  [<ffffffff812d137f>] debug_check_no_obj_freed+0x20/0x29
[   41.533725]  [<ffffffff811b73c7>] kmem_cache_free+0xa7/0x1da
[   41.533737]  [<ffffffff8146f4a5>] ? cleanup_net+0x0/0x223
[   41.533750]  [<ffffffff8146f49a>] net_free+0x3a/0x45
[   41.533764]  [<ffffffff8146f69b>] cleanup_net+0x1f6/0x223
[   41.533774]  [<ffffffff810a0991>] process_one_work+0x2c6/0x4d9
[   41.533787]  [<ffffffff810a08cc>] ? process_one_work+0x201/0x4d9
[   41.533797]  [<ffffffff810a0458>] ? spin_lock_irq+0x15/0x1e
[   41.533807]  [<ffffffff810a30a2>] worker_thread+0x1ce/0x356
[   41.533822]  [<ffffffff810a2ed4>] ? worker_thread+0x0/0x356
[   41.533832]  [<ffffffff810a8746>] kthread+0xc3/0xd2
[   41.533851]  [<ffffffff81138a3d>] ? trace_hardirqs_on_caller+0x18/0x48=

[   41.533860]  [<ffffffff8100f904>] kernel_thread_helper+0x4/0x10
[   41.533869]  [<ffffffff8154ad10>] ? restore_args+0x0/0x30
[   41.533876]  [<ffffffff810a8683>] ? kthread+0x0/0xd2
[   41.533884]  [<ffffffff8100f900>] ? kernel_thread_helper+0x0/0x10
[   41.533889] ---[ end trace bfcd91984357df49 ]---
[   41.533903] BUG: sleeping function called from invalid context at /loc=
al/linsrc/lnx-2637-rc1/kernel/mutex.c:278
[   41.533910] in_atomic(): 0, irqs_disabled(): 1, pid: 5, name: kworker/=
u:0
[   41.533917] 2 locks held by kworker/u:0/5:
[   41.533922]  #0:  (netns){......}, at: [<ffffffff810a08cc>] process_on=
e_work+0x201/0x4d9
[   41.533945]  #1:  (net_cleanup_work){......}, at: [<ffffffff810a08cc>]=
 process_one_work+0x201/0x4d9
[   41.533969] Pid: 5, comm: kworker/u:0 Tainted: G        W   2.6.37-rc1=
 #2
[   41.533973] Call Trace:
[   41.533984]  [<ffffffff8106f1cf>] __might_sleep+0x1be/0x1ca
[   41.533994]  [<ffffffff8154811d>] mutex_lock_nested+0x2c/0x5a
[   41.534008]  [<ffffffff812d5b5f>] percpu_counter_destroy+0x5c/0xa2
[   41.534020]  [<ffffffff812d5bc2>] percpu_counter_fixup_free+0x1d/0x4e
[   41.534028]  [<ffffffff812d07f8>] debug_object_fixup+0x2c/0x40
[   41.534040]  [<ffffffff812d11f0>] __debug_check_no_obj_freed+0xe3/0x25=
2
[   41.534052]  [<ffffffff8146f49a>] ? net_free+0x3a/0x45
[   41.534063]  [<ffffffff812d137f>] debug_check_no_obj_freed+0x20/0x29
[   41.534075]  [<ffffffff811b73c7>] kmem_cache_free+0xa7/0x1da
[   41.534087]  [<ffffffff8146f4a5>] ? cleanup_net+0x0/0x223
[   41.534098]  [<ffffffff8146f49a>] net_free+0x3a/0x45
[   41.534112]  [<ffffffff8146f69b>] cleanup_net+0x1f6/0x223
[   41.534121]  [<ffffffff810a0991>] process_one_work+0x2c6/0x4d9
[   41.534134]  [<ffffffff810a08cc>] ? process_one_work+0x201/0x4d9
[   41.534142]  [<ffffffff810a0458>] ? spin_lock_irq+0x15/0x1e
[   41.534154]  [<ffffffff810a30a2>] worker_thread+0x1ce/0x356
[   41.534167]  [<ffffffff810a2ed4>] ? worker_thread+0x0/0x356
[   41.534177]  [<ffffffff810a8746>] kthread+0xc3/0xd2
[   41.534191]  [<ffffffff81138a3d>] ? trace_hardirqs_on_caller+0x18/0x48=

[   41.534204]  [<ffffffff8100f904>] kernel_thread_helper+0x4/0x10
[   41.534223]  [<ffffffff8154ad10>] ? restore_args+0x0/0x30
[   41.534238]  [<ffffffff810a8683>] ? kthread+0x0/0xd2
[   41.534252]  [<ffffffff8100f900>] ? kernel_thread_helper+0x0/0x10
[   41.655579] NET: Registered protocol family 17
[   49.224055] virbr0: no IPv6 routers present
[   52.416053] eth0: no IPv6 routers present

--------------050007070806000900060101
Content-Type: text/plain;
 name="config-2637-rc1"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="config-2637-rc1"

#
# Automatically generated make config: don't edit
# Linux/x86_64 2.6.37-rc1 Kernel Configuration
# Mon Nov  1 14:20:01 2010
#
CONFIG_64BIT=y
# CONFIG_X86_32 is not set
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_GENERIC_GPIO=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_HAVE_CPUMASK_OF_CPU_MAP=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ZONE_DMA32=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_HAVE_INTEL_TXT=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_TRAMPOLINE=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
# CONFIG_KTIME_SCALAR is not set
CONFIG_ARCH_CPU_PROBE_RELEASE=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y
CONFIG_HAVE_IRQ_WORK=y
CONFIG_IRQ_WORK=y

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_WATCH=y
CONFIG_AUDIT_TREE=y
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ=y
# CONFIG_GENERIC_HARDIRQS_NO_DEPRECATED is not set
CONFIG_HAVE_SPARSE_IRQ=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
# CONFIG_AUTO_IRQ_AFFINITY is not set
# CONFIG_IRQ_PER_CPU is not set
# CONFIG_HARDIRQS_SW_RESEND is not set
CONFIG_SPARSE_IRQ=y

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_TRACE=y
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_EXACT=y
CONFIG_RCU_FAST_NO_HZ=y
CONFIG_TREE_RCU_TRACE=y
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_CGROUPS=y
CONFIG_CGROUP_DEBUG=y
CONFIG_CGROUP_NS=y
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
CONFIG_CGROUP_CPUACCT=y
CONFIG_RESOURCE_COUNTERS=y
CONFIG_CGROUP_MEM_RES_CTLR=y
CONFIG_CGROUP_MEM_RES_CTLR_SWAP=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_RT_GROUP_SCHED=y
CONFIG_BLK_CGROUP=m
CONFIG_DEBUG_BLK_CGROUP=y
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
CONFIG_MM_OWNER=y
CONFIG_SYSFS_DEPRECATED=y
CONFIG_SYSFS_DEPRECATED_V2=y
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_LZO=y
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_EMBEDDED=y
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_KALLSYMS_EXTRA_PASS=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_PERF_USE_VMALLOC=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
CONFIG_PERF_COUNTERS=y
CONFIG_DEBUG_PERF_USE_VMALLOC=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_SLUB_DEBUG=y
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_OPROFILE=m
CONFIG_OPROFILE_EVENT_MULTIPLEX=y
CONFIG_HAVE_OPROFILE=y
CONFIG_KPROBES=y
CONFIG_JUMP_LABEL=y
CONFIG_OPTPROBES=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_KRETPROBES=y
CONFIG_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y

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
CONFIG_MODVERSIONS=y
CONFIG_MODULE_SRCVERSION_ALL=y
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=m
CONFIG_IOSCHED_CFQ=m
CONFIG_CFQ_GROUP_IOSCHED=y
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_PADATA=y
# CONFIG_INLINE_SPIN_TRYLOCK is not set
# CONFIG_INLINE_SPIN_TRYLOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK is not set
# CONFIG_INLINE_SPIN_LOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK_IRQ is not set
# CONFIG_INLINE_SPIN_LOCK_IRQSAVE is not set
# CONFIG_INLINE_SPIN_UNLOCK is not set
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
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP=y
CONFIG_X86_X2APIC=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_EXTENDED_PLATFORM=y
CONFIG_X86_VSMP=y
CONFIG_X86_UV=y
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
CONFIG_SCHED_OMIT_FRAME_POINTER=y
CONFIG_PARAVIRT_GUEST=y
CONFIG_XEN=y
CONFIG_XEN_DOM0=y
CONFIG_XEN_PRIVILEGED_GUEST=y
CONFIG_XEN_PVHVM=y
CONFIG_XEN_MAX_DOMAIN_MEMORY=128
CONFIG_XEN_SAVE_RESTORE=y
CONFIG_XEN_DEBUG_FS=y
CONFIG_KVM_CLOCK=y
CONFIG_KVM_GUEST=y
CONFIG_PARAVIRT=y
CONFIG_PARAVIRT_SPINLOCKS=y
CONFIG_PARAVIRT_CLOCK=y
CONFIG_PARAVIRT_DEBUG=y
CONFIG_NO_BOOTMEM=y
CONFIG_MEMTEST=y
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_GENERIC_CPU=y
CONFIG_X86_CPU=y
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
CONFIG_PROCESSOR_SELECT=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
CONFIG_CALGARY_IOMMU=y
CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT=y
CONFIG_AMD_IOMMU=y
CONFIG_AMD_IOMMU_STATS=y
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_IOMMU_API=y
CONFIG_MAXSMP=y
CONFIG_NR_CPUS=4096
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
CONFIG_IRQ_TIME_ACCOUNTING=y
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=m
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_I8K=m
CONFIG_MICROCODE=m
CONFIG_MICROCODE_INTEL=y
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=m
CONFIG_X86_CPUID=m
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
CONFIG_NUMA=y
CONFIG_K8_NUMA=y
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_NODES_SPAN_OTHER_NODES=y
CONFIG_NUMA_EMU=y
CONFIG_NODES_SHIFT=10
CONFIG_ARCH_PROC_KCORE_TEXT=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_MEMORY_PROBE=y
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
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
CONFIG_MEMORY_HOTREMOVE=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
CONFIG_HWPOISON_INJECT=m
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_EFI=y
CONFIG_SECCOMP=y
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
CONFIG_KEXEC_JUMP=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
CONFIG_COMPAT_VDSO=y
CONFIG_CMDLINE_BOOL=y
CONFIG_CMDLINE=""
CONFIG_CMDLINE_OVERRIDE=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y
CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID=y
CONFIG_USE_PERCPU_NUMA_NODE_ID=y

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_SLEEP=y
CONFIG_SUSPEND_NVS=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
# CONFIG_PM_RUNTIME is not set
CONFIG_PM_OPS=y
CONFIG_PM_OPP=y
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_PROCFS_POWER=y
CONFIG_ACPI_POWER_METER=m
CONFIG_ACPI_EC_DEBUGFS=m
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=m
CONFIG_ACPI_BATTERY=m
CONFIG_ACPI_BUTTON=m
CONFIG_ACPI_VIDEO=m
CONFIG_ACPI_FAN=m
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=m
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_PROCESSOR_AGGREGATOR=m
CONFIG_ACPI_THERMAL=m
CONFIG_ACPI_NUMA=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
CONFIG_ACPI_DEBUG=y
CONFIG_ACPI_DEBUG_FUNC_TRACE=y
CONFIG_ACPI_PCI_SLOT=m
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=m
CONFIG_ACPI_HOTPLUG_MEMORY=m
CONFIG_ACPI_SBS=m
CONFIG_ACPI_HED=m
CONFIG_ACPI_APEI=y
CONFIG_ACPI_APEI_GHES=m
CONFIG_ACPI_APEI_EINJ=m
CONFIG_ACPI_APEI_ERST_DEBUG=m
CONFIG_SFI=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=m
CONFIG_CPU_FREQ_DEBUG=y
CONFIG_CPU_FREQ_STAT=m
CONFIG_CPU_FREQ_STAT_DETAILS=y
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=m
CONFIG_CPU_FREQ_GOV_USERSPACE=m
CONFIG_CPU_FREQ_GOV_ONDEMAND=m
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=m

#
# CPUFreq processor drivers
#
CONFIG_X86_PCC_CPUFREQ=m
CONFIG_X86_ACPI_CPUFREQ=m
CONFIG_X86_POWERNOW_K8=m
CONFIG_X86_SPEEDSTEP_CENTRINO=m
CONFIG_X86_P4_CLOCKMOD=m

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=m
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
CONFIG_INTEL_IDLE=y

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
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_XEN=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCI_CNB20LE_QUIRK=y
CONFIG_DMAR=y
CONFIG_DMAR_DEFAULT_ON=y
CONFIG_DMAR_FLOPPY_WA=y
CONFIG_INTR_REMAP=y
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=m
CONFIG_PCIEAER=y
CONFIG_PCIE_ECRC=y
CONFIG_PCIEAER_INJECT=m
CONFIG_PCIEASPM=y
CONFIG_PCIEASPM_DEBUG=y
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
CONFIG_PCI_DEBUG=y
CONFIG_PCI_STUB=m
CONFIG_XEN_PCIDEV_FRONTEND=m
CONFIG_XEN_PCIDEV_FE_DEBUG=y
CONFIG_HT_IRQ=y
CONFIG_PCI_IOV=y
CONFIG_PCI_IOAPIC=y
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
CONFIG_PCCARD=m
CONFIG_PCMCIA=m
CONFIG_PCMCIA_LOAD_CIS=y
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=m
CONFIG_YENTA_O2=y
CONFIG_YENTA_RICOH=y
CONFIG_YENTA_TI=y
CONFIG_YENTA_ENE_TUNE=y
CONFIG_YENTA_TOSHIBA=y
CONFIG_PD6729=m
CONFIG_I82092=m
CONFIG_PCCARD_NONSTATIC=y
CONFIG_HOTPLUG_PCI=m
CONFIG_HOTPLUG_PCI_FAKE=m
CONFIG_HOTPLUG_PCI_ACPI=m
CONFIG_HOTPLUG_PCI_ACPI_IBM=m
CONFIG_HOTPLUG_PCI_CPCI=y
CONFIG_HOTPLUG_PCI_CPCI_ZT5550=m
CONFIG_HOTPLUG_PCI_CPCI_GENERIC=m
CONFIG_HOTPLUG_PCI_SHPC=m

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=m
CONFIG_IA32_EMULATION=y
CONFIG_IA32_AOUT=m
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_NET=y
CONFIG_COMPAT_NETLINK_MESSAGES=y

#
# Networking options
#
CONFIG_PACKET=m
CONFIG_UNIX=m
CONFIG_XFRM=y
CONFIG_XFRM_USER=m
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
CONFIG_XFRM_STATISTICS=y
CONFIG_XFRM_IPCOMP=m
CONFIG_NET_KEY=m
CONFIG_NET_KEY_MIGRATE=y
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_ASK_IP_FIB_HASH=y
# CONFIG_IP_FIB_TRIE is not set
CONFIG_IP_FIB_HASH=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
CONFIG_IP_PNP_BOOTP=y
CONFIG_IP_PNP_RARP=y
CONFIG_NET_IPIP=m
CONFIG_NET_IPGRE_DEMUX=m
CONFIG_NET_IPGRE=m
CONFIG_NET_IPGRE_BROADCAST=y
CONFIG_IP_MROUTE=y
CONFIG_IP_MROUTE_MULTIPLE_TABLES=y
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
CONFIG_ARPD=y
CONFIG_SYN_COOKIES=y
CONFIG_INET_AH=m
CONFIG_INET_ESP=m
CONFIG_INET_IPCOMP=m
CONFIG_INET_XFRM_TUNNEL=m
CONFIG_INET_TUNNEL=m
CONFIG_INET_XFRM_MODE_TRANSPORT=m
CONFIG_INET_XFRM_MODE_TUNNEL=m
CONFIG_INET_XFRM_MODE_BEET=m
CONFIG_INET_LRO=m
CONFIG_INET_DIAG=m
CONFIG_INET_TCP_DIAG=m
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=m
CONFIG_TCP_CONG_CUBIC=m
CONFIG_TCP_CONG_WESTWOOD=m
CONFIG_TCP_CONG_HTCP=m
CONFIG_TCP_CONG_HSTCP=m
CONFIG_TCP_CONG_HYBLA=m
CONFIG_TCP_CONG_VEGAS=m
CONFIG_TCP_CONG_SCALABLE=m
CONFIG_TCP_CONG_LP=m
CONFIG_TCP_CONG_VENO=m
CONFIG_TCP_CONG_YEAH=m
CONFIG_TCP_CONG_ILLINOIS=m
CONFIG_DEFAULT_RENO=y
CONFIG_DEFAULT_TCP_CONG="reno"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=m
CONFIG_IPV6_PRIVACY=y
CONFIG_IPV6_ROUTER_PREF=y
CONFIG_IPV6_ROUTE_INFO=y
CONFIG_IPV6_OPTIMISTIC_DAD=y
CONFIG_INET6_AH=m
CONFIG_INET6_ESP=m
CONFIG_INET6_IPCOMP=m
CONFIG_IPV6_MIP6=m
CONFIG_INET6_XFRM_TUNNEL=m
CONFIG_INET6_TUNNEL=m
CONFIG_INET6_XFRM_MODE_TRANSPORT=m
CONFIG_INET6_XFRM_MODE_TUNNEL=m
CONFIG_INET6_XFRM_MODE_BEET=m
CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=m
CONFIG_IPV6_SIT=m
CONFIG_IPV6_SIT_6RD=y
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=m
CONFIG_IPV6_MULTIPLE_TABLES=y
CONFIG_IPV6_SUBTREES=y
CONFIG_IPV6_MROUTE=y
CONFIG_IPV6_MROUTE_MULTIPLE_TABLES=y
CONFIG_IPV6_PIMSM_V2=y
CONFIG_NETLABEL=y
CONFIG_NETWORK_SECMARK=y
CONFIG_NETWORK_PHY_TIMESTAMPING=y
CONFIG_NETFILTER=y
CONFIG_NETFILTER_DEBUG=y
CONFIG_NETFILTER_ADVANCED=y
CONFIG_BRIDGE_NETFILTER=y

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=m
CONFIG_NETFILTER_NETLINK_QUEUE=m
CONFIG_NETFILTER_NETLINK_LOG=m
CONFIG_NF_CONNTRACK=m
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_SECMARK=y
CONFIG_NF_CONNTRACK_ZONES=y
CONFIG_NF_CONNTRACK_EVENTS=y
CONFIG_NF_CT_PROTO_DCCP=m
CONFIG_NF_CT_PROTO_GRE=m
CONFIG_NF_CT_PROTO_SCTP=m
CONFIG_NF_CT_PROTO_UDPLITE=m
CONFIG_NF_CONNTRACK_AMANDA=m
CONFIG_NF_CONNTRACK_FTP=m
CONFIG_NF_CONNTRACK_H323=m
CONFIG_NF_CONNTRACK_IRC=m
CONFIG_NF_CONNTRACK_NETBIOS_NS=m
CONFIG_NF_CONNTRACK_PPTP=m
CONFIG_NF_CONNTRACK_SANE=m
CONFIG_NF_CONNTRACK_SIP=m
CONFIG_NF_CONNTRACK_TFTP=m
CONFIG_NF_CT_NETLINK=m
CONFIG_NETFILTER_TPROXY=m
CONFIG_NETFILTER_XTABLES=m

#
# Xtables combined modules
#
CONFIG_NETFILTER_XT_MARK=m
CONFIG_NETFILTER_XT_CONNMARK=m

#
# Xtables targets
#
CONFIG_NETFILTER_XT_TARGET_CHECKSUM=m
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=m
CONFIG_NETFILTER_XT_TARGET_CT=m
CONFIG_NETFILTER_XT_TARGET_DSCP=m
CONFIG_NETFILTER_XT_TARGET_HL=m
CONFIG_NETFILTER_XT_TARGET_IDLETIMER=m
CONFIG_NETFILTER_XT_TARGET_LED=m
CONFIG_NETFILTER_XT_TARGET_MARK=m
CONFIG_NETFILTER_XT_TARGET_NFLOG=m
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
CONFIG_NETFILTER_XT_TARGET_NOTRACK=m
CONFIG_NETFILTER_XT_TARGET_RATEEST=m
CONFIG_NETFILTER_XT_TARGET_TEE=m
CONFIG_NETFILTER_XT_TARGET_TPROXY=m
CONFIG_NETFILTER_XT_TARGET_TRACE=m
CONFIG_NETFILTER_XT_TARGET_SECMARK=m
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP=m

#
# Xtables matches
#
CONFIG_NETFILTER_XT_MATCH_CLUSTER=m
CONFIG_NETFILTER_XT_MATCH_COMMENT=m
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=m
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=m
CONFIG_NETFILTER_XT_MATCH_CONNMARK=m
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
CONFIG_NETFILTER_XT_MATCH_CPU=m
CONFIG_NETFILTER_XT_MATCH_DCCP=m
CONFIG_NETFILTER_XT_MATCH_DSCP=m
CONFIG_NETFILTER_XT_MATCH_ESP=m
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m
CONFIG_NETFILTER_XT_MATCH_HELPER=m
CONFIG_NETFILTER_XT_MATCH_HL=m
CONFIG_NETFILTER_XT_MATCH_IPRANGE=m
CONFIG_NETFILTER_XT_MATCH_IPVS=m
CONFIG_NETFILTER_XT_MATCH_LENGTH=m
CONFIG_NETFILTER_XT_MATCH_LIMIT=m
CONFIG_NETFILTER_XT_MATCH_MAC=m
CONFIG_NETFILTER_XT_MATCH_MARK=m
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
CONFIG_NETFILTER_XT_MATCH_OSF=m
CONFIG_NETFILTER_XT_MATCH_OWNER=m
CONFIG_NETFILTER_XT_MATCH_POLICY=m
CONFIG_NETFILTER_XT_MATCH_PHYSDEV=m
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
CONFIG_NETFILTER_XT_MATCH_QUOTA=m
CONFIG_NETFILTER_XT_MATCH_RATEEST=m
CONFIG_NETFILTER_XT_MATCH_REALM=m
CONFIG_NETFILTER_XT_MATCH_RECENT=m
CONFIG_NETFILTER_XT_MATCH_SCTP=m
CONFIG_NETFILTER_XT_MATCH_SOCKET=m
CONFIG_NETFILTER_XT_MATCH_STATE=m
CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
CONFIG_NETFILTER_XT_MATCH_STRING=m
CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
CONFIG_NETFILTER_XT_MATCH_TIME=m
CONFIG_NETFILTER_XT_MATCH_U32=m
CONFIG_IP_VS=m
CONFIG_IP_VS_IPV6=y
CONFIG_IP_VS_DEBUG=y
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
CONFIG_IP_VS_PROTO_TCP=y
CONFIG_IP_VS_PROTO_UDP=y
CONFIG_IP_VS_PROTO_AH_ESP=y
CONFIG_IP_VS_PROTO_ESP=y
CONFIG_IP_VS_PROTO_AH=y
CONFIG_IP_VS_PROTO_SCTP=y

#
# IPVS scheduler
#
CONFIG_IP_VS_RR=m
CONFIG_IP_VS_WRR=m
CONFIG_IP_VS_LC=m
CONFIG_IP_VS_WLC=m
CONFIG_IP_VS_LBLC=m
CONFIG_IP_VS_LBLCR=m
CONFIG_IP_VS_DH=m
CONFIG_IP_VS_SH=m
CONFIG_IP_VS_SED=m
CONFIG_IP_VS_NQ=m

#
# IPVS application helper
#
CONFIG_IP_VS_FTP=m
CONFIG_IP_VS_NFCT=y
CONFIG_IP_VS_PE_SIP=m

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=m
CONFIG_NF_CONNTRACK_IPV4=m
CONFIG_NF_CONNTRACK_PROC_COMPAT=y
CONFIG_IP_NF_QUEUE=m
CONFIG_IP_NF_IPTABLES=m
CONFIG_IP_NF_MATCH_ADDRTYPE=m
CONFIG_IP_NF_MATCH_AH=m
CONFIG_IP_NF_MATCH_ECN=m
CONFIG_IP_NF_MATCH_TTL=m
CONFIG_IP_NF_FILTER=m
CONFIG_IP_NF_TARGET_REJECT=m
CONFIG_IP_NF_TARGET_LOG=m
CONFIG_IP_NF_TARGET_ULOG=m
CONFIG_NF_NAT=m
CONFIG_NF_NAT_NEEDED=y
CONFIG_IP_NF_TARGET_MASQUERADE=m
CONFIG_IP_NF_TARGET_NETMAP=m
CONFIG_IP_NF_TARGET_REDIRECT=m
CONFIG_NF_NAT_SNMP_BASIC=m
CONFIG_NF_NAT_PROTO_DCCP=m
CONFIG_NF_NAT_PROTO_GRE=m
CONFIG_NF_NAT_PROTO_UDPLITE=m
CONFIG_NF_NAT_PROTO_SCTP=m
CONFIG_NF_NAT_FTP=m
CONFIG_NF_NAT_IRC=m
CONFIG_NF_NAT_TFTP=m
CONFIG_NF_NAT_AMANDA=m
CONFIG_NF_NAT_PPTP=m
CONFIG_NF_NAT_H323=m
CONFIG_NF_NAT_SIP=m
CONFIG_IP_NF_MANGLE=m
CONFIG_IP_NF_TARGET_CLUSTERIP=m
CONFIG_IP_NF_TARGET_ECN=m
CONFIG_IP_NF_TARGET_TTL=m
CONFIG_IP_NF_RAW=m
CONFIG_IP_NF_SECURITY=m
CONFIG_IP_NF_ARPTABLES=m
CONFIG_IP_NF_ARPFILTER=m
CONFIG_IP_NF_ARP_MANGLE=m

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV6=m
CONFIG_NF_CONNTRACK_IPV6=m
CONFIG_IP6_NF_QUEUE=m
CONFIG_IP6_NF_IPTABLES=m
CONFIG_IP6_NF_MATCH_AH=m
CONFIG_IP6_NF_MATCH_EUI64=m
CONFIG_IP6_NF_MATCH_FRAG=m
CONFIG_IP6_NF_MATCH_OPTS=m
CONFIG_IP6_NF_MATCH_HL=m
CONFIG_IP6_NF_MATCH_IPV6HEADER=m
CONFIG_IP6_NF_MATCH_MH=m
CONFIG_IP6_NF_MATCH_RT=m
CONFIG_IP6_NF_TARGET_HL=m
CONFIG_IP6_NF_TARGET_LOG=m
CONFIG_IP6_NF_FILTER=m
CONFIG_IP6_NF_TARGET_REJECT=m
CONFIG_IP6_NF_MANGLE=m
CONFIG_IP6_NF_RAW=m
CONFIG_IP6_NF_SECURITY=m

#
# DECnet: Netfilter Configuration
#
CONFIG_DECNET_NF_GRABULATOR=m
CONFIG_BRIDGE_NF_EBTABLES=m
CONFIG_BRIDGE_EBT_BROUTE=m
CONFIG_BRIDGE_EBT_T_FILTER=m
CONFIG_BRIDGE_EBT_T_NAT=m
CONFIG_BRIDGE_EBT_802_3=m
CONFIG_BRIDGE_EBT_AMONG=m
CONFIG_BRIDGE_EBT_ARP=m
CONFIG_BRIDGE_EBT_IP=m
CONFIG_BRIDGE_EBT_IP6=m
CONFIG_BRIDGE_EBT_LIMIT=m
CONFIG_BRIDGE_EBT_MARK=m
CONFIG_BRIDGE_EBT_PKTTYPE=m
CONFIG_BRIDGE_EBT_STP=m
CONFIG_BRIDGE_EBT_VLAN=m
CONFIG_BRIDGE_EBT_ARPREPLY=m
CONFIG_BRIDGE_EBT_DNAT=m
CONFIG_BRIDGE_EBT_MARK_T=m
CONFIG_BRIDGE_EBT_REDIRECT=m
CONFIG_BRIDGE_EBT_SNAT=m
CONFIG_BRIDGE_EBT_LOG=m
CONFIG_BRIDGE_EBT_ULOG=m
CONFIG_BRIDGE_EBT_NFLOG=m
CONFIG_IP_DCCP=m
CONFIG_INET_DCCP_DIAG=m

#
# DCCP CCIDs Configuration (EXPERIMENTAL)
#
CONFIG_IP_DCCP_CCID2_DEBUG=y
CONFIG_IP_DCCP_CCID3=y
CONFIG_IP_DCCP_CCID3_DEBUG=y
CONFIG_IP_DCCP_TFRC_LIB=y
CONFIG_IP_DCCP_TFRC_DEBUG=y

#
# DCCP Kernel Hacking
#
CONFIG_IP_DCCP_DEBUG=y
CONFIG_NET_DCCPPROBE=m
CONFIG_IP_SCTP=m
CONFIG_NET_SCTPPROBE=m
CONFIG_SCTP_DBG_MSG=y
CONFIG_SCTP_DBG_OBJCNT=y
# CONFIG_SCTP_HMAC_NONE is not set
# CONFIG_SCTP_HMAC_SHA1 is not set
CONFIG_SCTP_HMAC_MD5=y
CONFIG_RDS=m
CONFIG_RDS_RDMA=m
CONFIG_RDS_TCP=m
CONFIG_RDS_DEBUG=y
CONFIG_TIPC=m
CONFIG_TIPC_ADVANCED=y
CONFIG_TIPC_ZONES=3
CONFIG_TIPC_CLUSTERS=1
CONFIG_TIPC_NODES=255
CONFIG_TIPC_PORTS=8191
CONFIG_TIPC_LOG=0
CONFIG_TIPC_DEBUG=y
CONFIG_ATM=m
CONFIG_ATM_CLIP=m
CONFIG_ATM_CLIP_NO_ICMP=y
CONFIG_ATM_LANE=m
CONFIG_ATM_MPOA=m
CONFIG_ATM_BR2684=m
CONFIG_ATM_BR2684_IPFILTER=y
CONFIG_L2TP=m
CONFIG_L2TP_DEBUGFS=m
CONFIG_L2TP_V3=y
CONFIG_L2TP_IP=m
CONFIG_L2TP_ETH=m
CONFIG_STP=m
CONFIG_GARP=m
CONFIG_BRIDGE=m
CONFIG_BRIDGE_IGMP_SNOOPING=y
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_DSA=y
CONFIG_NET_DSA_TAG_EDSA=y
CONFIG_NET_DSA_TAG_TRAILER=y
CONFIG_NET_DSA_MV88E6XXX=y
CONFIG_NET_DSA_MV88E6060=y
CONFIG_NET_DSA_MV88E6XXX_NEED_PPU=y
CONFIG_NET_DSA_MV88E6131=y
CONFIG_NET_DSA_MV88E6123_61_65=y
CONFIG_VLAN_8021Q=m
CONFIG_VLAN_8021Q_GVRP=y
CONFIG_DECNET=m
CONFIG_DECNET_ROUTER=y
CONFIG_LLC=m
CONFIG_LLC2=m
CONFIG_IPX=m
CONFIG_IPX_INTERN=y
CONFIG_ATALK=m
CONFIG_DEV_APPLETALK=m
CONFIG_IPDDP=m
CONFIG_IPDDP_ENCAP=y
CONFIG_IPDDP_DECAP=y
CONFIG_X25=m
CONFIG_LAPB=m
CONFIG_ECONET=m
CONFIG_ECONET_AUNUDP=y
CONFIG_ECONET_NATIVE=y
CONFIG_WAN_ROUTER=m
CONFIG_PHONET=m
CONFIG_PHONET_PIPECTRLR=y
CONFIG_IEEE802154=m
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=m
CONFIG_NET_SCH_HTB=m
CONFIG_NET_SCH_HFSC=m
CONFIG_NET_SCH_ATM=m
CONFIG_NET_SCH_PRIO=m
CONFIG_NET_SCH_MULTIQ=m
CONFIG_NET_SCH_RED=m
CONFIG_NET_SCH_SFQ=m
CONFIG_NET_SCH_TEQL=m
CONFIG_NET_SCH_TBF=m
CONFIG_NET_SCH_GRED=m
CONFIG_NET_SCH_DSMARK=m
CONFIG_NET_SCH_NETEM=m
CONFIG_NET_SCH_DRR=m
CONFIG_NET_SCH_INGRESS=m

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=m
CONFIG_NET_CLS_TCINDEX=m
CONFIG_NET_CLS_ROUTE4=m
CONFIG_NET_CLS_ROUTE=y
CONFIG_NET_CLS_FW=m
CONFIG_NET_CLS_U32=m
CONFIG_CLS_U32_PERF=y
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_RSVP=m
CONFIG_NET_CLS_RSVP6=m
CONFIG_NET_CLS_FLOW=m
CONFIG_NET_CLS_CGROUP=m
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=m
CONFIG_NET_EMATCH_NBYTE=m
CONFIG_NET_EMATCH_U32=m
CONFIG_NET_EMATCH_META=m
CONFIG_NET_EMATCH_TEXT=m
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=m
CONFIG_NET_ACT_GACT=m
CONFIG_GACT_PROB=y
CONFIG_NET_ACT_MIRRED=m
CONFIG_NET_ACT_IPT=m
CONFIG_NET_ACT_NAT=m
CONFIG_NET_ACT_PEDIT=m
CONFIG_NET_ACT_SIMP=m
CONFIG_NET_ACT_SKBEDIT=m
CONFIG_NET_ACT_CSUM=m
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=m
CONFIG_RPS=y

#
# Network testing
#
CONFIG_NET_PKTGEN=m
CONFIG_NET_TCPPROBE=m
CONFIG_NET_DROP_MONITOR=y
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
CONFIG_AX25=m
CONFIG_AX25_DAMA_SLAVE=y
CONFIG_NETROM=m
CONFIG_ROSE=m

#
# AX.25 network device drivers
#
CONFIG_MKISS=m
CONFIG_6PACK=m
CONFIG_BPQETHER=m
CONFIG_BAYCOM_SER_FDX=m
CONFIG_BAYCOM_SER_HDX=m
CONFIG_BAYCOM_PAR=m
CONFIG_YAM=m
CONFIG_CAN=m
CONFIG_CAN_RAW=m
CONFIG_CAN_BCM=m

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=m
CONFIG_CAN_DEV=m
CONFIG_CAN_CALC_BITTIMING=y
CONFIG_CAN_MCP251X=m
CONFIG_CAN_JANZ_ICAN3=m
CONFIG_PCH_CAN=m
CONFIG_CAN_SJA1000=m
CONFIG_CAN_SJA1000_PLATFORM=m
CONFIG_CAN_EMS_PCI=m
CONFIG_CAN_KVASER_PCI=m
CONFIG_CAN_PLX_PCI=m

#
# CAN USB interfaces
#
CONFIG_CAN_EMS_USB=m
CONFIG_CAN_ESD_USB2=m
CONFIG_CAN_DEBUG_DEVICES=y
CONFIG_IRDA=m

#
# IrDA protocols
#
CONFIG_IRLAN=m
CONFIG_IRNET=m
CONFIG_IRCOMM=m
CONFIG_IRDA_ULTRA=y

#
# IrDA options
#
CONFIG_IRDA_CACHE_LAST_LSAP=y
CONFIG_IRDA_FAST_RR=y
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
CONFIG_ACTISYS_DONGLE=m
CONFIG_TEKRAM_DONGLE=m
CONFIG_TOIM3232_DONGLE=m
CONFIG_LITELINK_DONGLE=m
CONFIG_MA600_DONGLE=m
CONFIG_GIRBIL_DONGLE=m
CONFIG_MCP2120_DONGLE=m
CONFIG_OLD_BELKIN_DONGLE=m
CONFIG_ACT200L_DONGLE=m
CONFIG_KINGSUN_DONGLE=m
CONFIG_KSDAZZLE_DONGLE=m
CONFIG_KS959_DONGLE=m

#
# FIR device drivers
#
CONFIG_USB_IRDA=m
CONFIG_SIGMATEL_FIR=m
CONFIG_NSC_FIR=m
CONFIG_WINBOND_FIR=m
CONFIG_SMC_IRCC_FIR=m
CONFIG_ALI_FIR=m
CONFIG_VLSI_FIR=m
CONFIG_VIA_FIR=m
CONFIG_MCS_FIR=m
CONFIG_BT=m
CONFIG_BT_L2CAP=m
CONFIG_BT_SCO=m
CONFIG_BT_RFCOMM=m
CONFIG_BT_RFCOMM_TTY=y
CONFIG_BT_BNEP=m
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_CMTP=m
CONFIG_BT_HIDP=m

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTUSB=m
CONFIG_BT_HCIBTSDIO=m
CONFIG_BT_HCIUART=m
CONFIG_BT_HCIUART_H4=y
CONFIG_BT_HCIUART_BCSP=y
CONFIG_BT_HCIUART_ATH3K=y
CONFIG_BT_HCIUART_LL=y
CONFIG_BT_HCIBCM203X=m
CONFIG_BT_HCIBPA10X=m
CONFIG_BT_HCIBFUSB=m
CONFIG_BT_HCIDTL1=m
CONFIG_BT_HCIBT3C=m
CONFIG_BT_HCIBLUECARD=m
CONFIG_BT_HCIBTUART=m
CONFIG_BT_HCIVHCI=m
CONFIG_BT_MRVL=m
CONFIG_BT_MRVL_SDIO=m
CONFIG_BT_ATH3K=m
CONFIG_AF_RXRPC=m
CONFIG_AF_RXRPC_DEBUG=y
CONFIG_RXKAD=m
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_WIRELESS_EXT=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_WEXT_SPY=y
CONFIG_WEXT_PRIV=y
CONFIG_CFG80211=m
CONFIG_NL80211_TESTMODE=y
CONFIG_CFG80211_DEVELOPER_WARNINGS=y
CONFIG_CFG80211_REG_DEBUG=y
CONFIG_CFG80211_DEFAULT_PS=y
CONFIG_CFG80211_DEBUGFS=y
CONFIG_CFG80211_INTERNAL_REGDB=y
CONFIG_CFG80211_WEXT=y
CONFIG_WIRELESS_EXT_SYSFS=y
CONFIG_LIB80211=m
CONFIG_LIB80211_CRYPT_WEP=m
CONFIG_LIB80211_CRYPT_CCMP=m
CONFIG_LIB80211_CRYPT_TKIP=m
CONFIG_LIB80211_DEBUG=y
CONFIG_MAC80211=m
CONFIG_MAC80211_HAS_RC=y
CONFIG_MAC80211_RC_PID=y
CONFIG_MAC80211_RC_MINSTREL=y
CONFIG_MAC80211_RC_MINSTREL_HT=y
# CONFIG_MAC80211_RC_DEFAULT_PID is not set
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel_ht"
CONFIG_MAC80211_MESH=y
CONFIG_MAC80211_LEDS=y
CONFIG_MAC80211_DEBUGFS=y
CONFIG_MAC80211_DEBUG_MENU=y
CONFIG_MAC80211_NOINLINE=y
CONFIG_MAC80211_VERBOSE_DEBUG=y
CONFIG_MAC80211_HT_DEBUG=y
CONFIG_MAC80211_TKIP_DEBUG=y
CONFIG_MAC80211_IBSS_DEBUG=y
CONFIG_MAC80211_VERBOSE_PS_DEBUG=y
CONFIG_MAC80211_VERBOSE_MPL_DEBUG=y
CONFIG_MAC80211_VERBOSE_MHWMP_DEBUG=y
CONFIG_MAC80211_DEBUG_COUNTERS=y
CONFIG_MAC80211_DRIVER_API_TRACER=y
CONFIG_WIMAX=m
CONFIG_WIMAX_DEBUG_LEVEL=8
CONFIG_RFKILL=m
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
CONFIG_NET_9P=m
CONFIG_NET_9P_VIRTIO=m
CONFIG_NET_9P_RDMA=m
CONFIG_NET_9P_DEBUG=y
CONFIG_CAIF=m
CONFIG_CAIF_DEBUG=y
CONFIG_CAIF_NETDEV=m
CONFIG_CEPH_LIB=m
CONFIG_CEPH_LIB_PRETTYDEBUG=y

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
CONFIG_FW_LOADER=m
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_DEBUG_DRIVER is not set
CONFIG_DEBUG_DEVRES=y
CONFIG_SYS_HYPERVISOR=y
CONFIG_CONNECTOR=m
CONFIG_MTD=m
CONFIG_MTD_DEBUG=y
CONFIG_MTD_DEBUG_VERBOSE=0
CONFIG_MTD_TESTS=m
CONFIG_MTD_CONCAT=m
CONFIG_MTD_PARTITIONS=y
CONFIG_MTD_REDBOOT_PARTS=m
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED=y
CONFIG_MTD_REDBOOT_PARTS_READONLY=y
CONFIG_MTD_AR7_PARTS=m

#
# User Modules And Translation Layers
#
CONFIG_MTD_CHAR=m
CONFIG_HAVE_MTD_OTP=y
CONFIG_MTD_BLKDEVS=m
CONFIG_MTD_BLOCK=m
CONFIG_MTD_BLOCK_RO=m
CONFIG_FTL=m
CONFIG_NFTL=m
CONFIG_NFTL_RW=y
CONFIG_INFTL=m
CONFIG_RFD_FTL=m
CONFIG_SSFDC=m
CONFIG_SM_FTL=m
CONFIG_MTD_OOPS=m

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=m
CONFIG_MTD_JEDECPROBE=m
CONFIG_MTD_GEN_PROBE=m
CONFIG_MTD_CFI_ADV_OPTIONS=y
CONFIG_MTD_CFI_NOSWAP=y
# CONFIG_MTD_CFI_BE_BYTE_SWAP is not set
# CONFIG_MTD_CFI_LE_BYTE_SWAP is not set
CONFIG_MTD_CFI_GEOMETRY=y
CONFIG_MTD_MAP_BANK_WIDTH_1=y
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
CONFIG_MTD_MAP_BANK_WIDTH_8=y
CONFIG_MTD_MAP_BANK_WIDTH_16=y
CONFIG_MTD_MAP_BANK_WIDTH_32=y
CONFIG_MTD_CFI_I1=y
CONFIG_MTD_CFI_I2=y
CONFIG_MTD_CFI_I4=y
CONFIG_MTD_CFI_I8=y
CONFIG_MTD_OTP=y
CONFIG_MTD_CFI_INTELEXT=m
CONFIG_MTD_CFI_AMDSTD=m
CONFIG_MTD_CFI_STAA=m
CONFIG_MTD_CFI_UTIL=m
CONFIG_MTD_RAM=m
CONFIG_MTD_ROM=m
CONFIG_MTD_ABSENT=m

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=y
CONFIG_MTD_PHYSMAP=m
CONFIG_MTD_PHYSMAP_COMPAT=y
CONFIG_MTD_PHYSMAP_START=0x8000000
CONFIG_MTD_PHYSMAP_LEN=0
CONFIG_MTD_PHYSMAP_BANKWIDTH=2
CONFIG_MTD_SC520CDP=m
CONFIG_MTD_NETSC520=m
CONFIG_MTD_TS5500=m
CONFIG_MTD_SBC_GXX=m
CONFIG_MTD_AMD76XROM=m
CONFIG_MTD_ICHXROM=m
CONFIG_MTD_ESB2ROM=m
CONFIG_MTD_CK804XROM=m
CONFIG_MTD_SCB2_FLASH=m
CONFIG_MTD_NETtel=m
CONFIG_MTD_L440GX=m
CONFIG_MTD_PCI=m
CONFIG_MTD_PCMCIA=m
CONFIG_MTD_PCMCIA_ANONYMOUS=y
CONFIG_MTD_GPIO_ADDR=m
CONFIG_MTD_INTEL_VR_NOR=m
CONFIG_MTD_PLATRAM=m

#
# Self-contained MTD device drivers
#
CONFIG_MTD_PMC551=m
CONFIG_MTD_PMC551_BUGFIX=y
CONFIG_MTD_PMC551_DEBUG=y
CONFIG_MTD_DATAFLASH=m
CONFIG_MTD_DATAFLASH_WRITE_VERIFY=y
CONFIG_MTD_DATAFLASH_OTP=y
CONFIG_MTD_M25P80=m
CONFIG_M25PXX_USE_FAST_READ=y
CONFIG_MTD_SST25L=m
CONFIG_MTD_SLRAM=m
CONFIG_MTD_PHRAM=m
CONFIG_MTD_MTDRAM=m
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128
CONFIG_MTD_BLOCK2MTD=m

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOC2000=m
CONFIG_MTD_DOC2001=m
CONFIG_MTD_DOC2001PLUS=m
CONFIG_MTD_DOCPROBE=m
CONFIG_MTD_DOCECC=m
CONFIG_MTD_DOCPROBE_ADVANCED=y
CONFIG_MTD_DOCPROBE_ADDRESS=0x0000
CONFIG_MTD_DOCPROBE_HIGH=y
CONFIG_MTD_DOCPROBE_55AA=y
CONFIG_MTD_NAND_ECC=m
CONFIG_MTD_NAND_ECC_SMC=y
CONFIG_MTD_NAND=m
CONFIG_MTD_NAND_VERIFY_WRITE=y
CONFIG_MTD_SM_COMMON=m
CONFIG_MTD_NAND_MUSEUM_IDS=y
CONFIG_MTD_NAND_DENALI=m
CONFIG_MTD_NAND_DENALI_SCRATCH_REG_ADDR=0xFF108018
CONFIG_MTD_NAND_IDS=m
CONFIG_MTD_NAND_RICOH=m
CONFIG_MTD_NAND_DISKONCHIP=m
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED=y
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
CONFIG_MTD_NAND_DISKONCHIP_PROBE_HIGH=y
CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE=y
CONFIG_MTD_NAND_CAFE=m
CONFIG_MTD_NAND_NANDSIM=m
CONFIG_MTD_NAND_PLATFORM=m
CONFIG_MTD_ALAUDA=m
CONFIG_MTD_ONENAND=m
CONFIG_MTD_ONENAND_VERIFY_WRITE=y
CONFIG_MTD_ONENAND_GENERIC=m
CONFIG_MTD_ONENAND_OTP=y
CONFIG_MTD_ONENAND_2X_PROGRAM=y
CONFIG_MTD_ONENAND_SIM=m

#
# LPDDR flash memory drivers
#
CONFIG_MTD_LPDDR=m
CONFIG_MTD_QINFO_PROBE=m
CONFIG_MTD_UBI=m
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_RESERVE=1
CONFIG_MTD_UBI_GLUEBI=m

#
# UBI debugging options
#
CONFIG_MTD_UBI_DEBUG=y
CONFIG_MTD_UBI_DEBUG_MSG=y
CONFIG_MTD_UBI_DEBUG_PARANOID=y
CONFIG_MTD_UBI_DEBUG_DISABLE_BGT=y
CONFIG_MTD_UBI_DEBUG_EMULATE_BITFLIPS=y
CONFIG_MTD_UBI_DEBUG_EMULATE_WRITE_FAILURES=y
CONFIG_MTD_UBI_DEBUG_EMULATE_ERASE_FAILURES=y

#
# Additional UBI debugging messages
#
CONFIG_MTD_UBI_DEBUG_MSG_BLD=y
CONFIG_MTD_UBI_DEBUG_MSG_EBA=y
CONFIG_MTD_UBI_DEBUG_MSG_WL=y
CONFIG_MTD_UBI_DEBUG_MSG_IO=y
CONFIG_PARPORT=m
CONFIG_PARPORT_PC=m
CONFIG_PARPORT_SERIAL=m
CONFIG_PARPORT_PC_FIFO=y
CONFIG_PARPORT_PC_SUPERIO=y
CONFIG_PARPORT_PC_PCMCIA=m
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=m
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_FD=m
CONFIG_PARIDE=m

#
# Parallel IDE high-level drivers
#
CONFIG_PARIDE_PD=m
CONFIG_PARIDE_PCD=m
CONFIG_PARIDE_PF=m
CONFIG_PARIDE_PT=m
CONFIG_PARIDE_PG=m

#
# Parallel IDE protocol modules
#
CONFIG_PARIDE_ATEN=m
CONFIG_PARIDE_BPCK=m
CONFIG_PARIDE_COMM=m
CONFIG_PARIDE_DSTR=m
CONFIG_PARIDE_FIT2=m
CONFIG_PARIDE_FIT3=m
CONFIG_PARIDE_EPAT=m
CONFIG_PARIDE_EPATC8=y
CONFIG_PARIDE_EPIA=m
CONFIG_PARIDE_FRIQ=m
CONFIG_PARIDE_FRPW=m
CONFIG_PARIDE_KBIC=m
CONFIG_PARIDE_KTTI=m
CONFIG_PARIDE_ON20=m
CONFIG_PARIDE_ON26=m
CONFIG_BLK_CPQ_DA=m
CONFIG_BLK_CPQ_CISS_DA=m
CONFIG_CISS_SCSI_TAPE=y
CONFIG_BLK_DEV_DAC960=m
CONFIG_BLK_DEV_UMEM=m
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_CRYPTOLOOP=m
CONFIG_BLK_DEV_DRBD=m
CONFIG_DRBD_FAULT_INJECTION=y
CONFIG_BLK_DEV_NBD=m
CONFIG_BLK_DEV_OSD=m
CONFIG_BLK_DEV_SX8=m
CONFIG_BLK_DEV_UB=m
CONFIG_BLK_DEV_RAM=m
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
CONFIG_BLK_DEV_XIP=y
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
CONFIG_CDROM_PKTCDVD_WCACHE=y
CONFIG_ATA_OVER_ETH=m
CONFIG_XEN_BLKDEV_FRONTEND=m
CONFIG_VIRTIO_BLK=m
CONFIG_BLK_DEV_HD=y
CONFIG_BLK_DEV_RBD=m
CONFIG_MISC_DEVICES=y
CONFIG_AD525X_DPOT=m
CONFIG_AD525X_DPOT_I2C=m
CONFIG_AD525X_DPOT_SPI=m
CONFIG_IBM_ASM=m
CONFIG_PHANTOM=m
CONFIG_SGI_IOC4=m
CONFIG_TIFM_CORE=m
CONFIG_TIFM_7XX1=m
CONFIG_ICS932S401=m
CONFIG_ENCLOSURE_SERVICES=m
CONFIG_SGI_XP=m
CONFIG_CS5535_MFGPT=m
CONFIG_CS5535_MFGPT_DEFAULT_IRQ=7
CONFIG_CS5535_CLOCK_EVENT_SRC=m
CONFIG_HP_ILO=m
CONFIG_SGI_GRU=m
CONFIG_SGI_GRU_DEBUG=y
CONFIG_APDS9802ALS=m
CONFIG_ISL29003=m
CONFIG_ISL29020=m
CONFIG_SENSORS_TSL2550=m
CONFIG_SENSORS_BH1780=m
CONFIG_SENSORS_BH1770=m
CONFIG_SENSORS_APDS990X=m
CONFIG_HMC6352=m
CONFIG_DS1682=m
CONFIG_TI_DAC7512=m
CONFIG_VMWARE_BALLOON=m
CONFIG_BMP085=m
CONFIG_PCH_PHUB=m
CONFIG_C2PORT=m
CONFIG_C2PORT_DURAMAR_2150=m

#
# EEPROM support
#
CONFIG_EEPROM_AT24=m
CONFIG_EEPROM_AT25=m
CONFIG_EEPROM_LEGACY=m
CONFIG_EEPROM_MAX6875=m
CONFIG_EEPROM_93CX6=m
CONFIG_CB710_CORE=m
CONFIG_CB710_DEBUG=y
CONFIG_CB710_DEBUG_ASSUMPTIONS=y
CONFIG_IWMC3200TOP=m
CONFIG_IWMC3200TOP_DEBUG=y
CONFIG_IWMC3200TOP_DEBUGFS=y

#
# Texas Instruments shared transport line discipline
#
CONFIG_TI_ST=m
CONFIG_HAVE_IDE=y
CONFIG_IDE=m

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=y
CONFIG_IDE_TIMINGS=y
CONFIG_IDE_ATAPI=y
CONFIG_BLK_DEV_IDE_SATA=y
CONFIG_IDE_GD=m
CONFIG_IDE_GD_ATA=y
CONFIG_IDE_GD_ATAPI=y
CONFIG_BLK_DEV_IDECS=m
CONFIG_BLK_DEV_DELKIN=m
CONFIG_BLK_DEV_IDECD=m
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
CONFIG_BLK_DEV_IDETAPE=m
CONFIG_BLK_DEV_IDEACPI=y
CONFIG_IDE_TASK_IOCTL=y
CONFIG_IDE_PROC_FS=y

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=m
CONFIG_BLK_DEV_PLATFORM=m
CONFIG_BLK_DEV_CMD640=m
CONFIG_BLK_DEV_CMD640_ENHANCED=y
CONFIG_BLK_DEV_IDEPNP=m
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
CONFIG_BLK_DEV_OFFBOARD=y
CONFIG_BLK_DEV_GENERIC=m
CONFIG_BLK_DEV_OPTI621=m
CONFIG_BLK_DEV_RZ1000=m
CONFIG_BLK_DEV_IDEDMA_PCI=y
CONFIG_BLK_DEV_AEC62XX=m
CONFIG_BLK_DEV_ALI15X3=m
CONFIG_BLK_DEV_AMD74XX=m
CONFIG_BLK_DEV_ATIIXP=m
CONFIG_BLK_DEV_CMD64X=m
CONFIG_BLK_DEV_TRIFLEX=m
CONFIG_BLK_DEV_CS5520=m
CONFIG_BLK_DEV_CS5530=m
CONFIG_BLK_DEV_HPT366=m
CONFIG_BLK_DEV_JMICRON=m
CONFIG_BLK_DEV_SC1200=m
CONFIG_BLK_DEV_PIIX=m
CONFIG_BLK_DEV_IT8172=m
CONFIG_BLK_DEV_IT8213=m
CONFIG_BLK_DEV_IT821X=m
CONFIG_BLK_DEV_NS87415=m
CONFIG_BLK_DEV_PDC202XX_OLD=m
CONFIG_BLK_DEV_PDC202XX_NEW=m
CONFIG_BLK_DEV_SVWKS=m
CONFIG_BLK_DEV_SIIMAGE=m
CONFIG_BLK_DEV_SIS5513=m
CONFIG_BLK_DEV_SLC90E66=m
CONFIG_BLK_DEV_TRM290=m
CONFIG_BLK_DEV_VIA82CXXX=m
CONFIG_BLK_DEV_TC86C001=m
CONFIG_BLK_DEV_IDEDMA=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=m
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=m
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=m
CONFIG_CHR_DEV_ST=m
CONFIG_CHR_DEV_OSST=m
CONFIG_BLK_DEV_SR=m
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=m
CONFIG_CHR_DEV_SCH=m
CONFIG_SCSI_ENCLOSURE=m
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=m
CONFIG_SCSI_FC_ATTRS=m
CONFIG_SCSI_FC_TGT_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=m
CONFIG_SCSI_SAS_ATTRS=m
CONFIG_SCSI_SAS_LIBSAS=m
CONFIG_SCSI_SAS_ATA=y
CONFIG_SCSI_SAS_HOST_SMP=y
CONFIG_SCSI_SAS_LIBSAS_DEBUG=y
CONFIG_SCSI_SRP_ATTRS=m
CONFIG_SCSI_SRP_TGT_ATTRS=y
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_TCP=m
CONFIG_ISCSI_BOOT_SYSFS=m
CONFIG_SCSI_CXGB3_ISCSI=m
CONFIG_SCSI_CXGB4_ISCSI=m
CONFIG_SCSI_BNX2_ISCSI=m
CONFIG_BE2ISCSI=m
CONFIG_BLK_DEV_3W_XXXX_RAID=m
CONFIG_SCSI_HPSA=m
CONFIG_SCSI_3W_9XXX=m
CONFIG_SCSI_3W_SAS=m
CONFIG_SCSI_ACARD=m
CONFIG_SCSI_AACRAID=m
CONFIG_SCSI_AIC7XXX=m
CONFIG_AIC7XXX_CMDS_PER_DEVICE=32
CONFIG_AIC7XXX_RESET_DELAY_MS=5000
CONFIG_AIC7XXX_DEBUG_ENABLE=y
CONFIG_AIC7XXX_DEBUG_MASK=0
CONFIG_AIC7XXX_REG_PRETTY_PRINT=y
CONFIG_SCSI_AIC7XXX_OLD=m
CONFIG_SCSI_AIC79XX=m
CONFIG_AIC79XX_CMDS_PER_DEVICE=32
CONFIG_AIC79XX_RESET_DELAY_MS=5000
CONFIG_AIC79XX_DEBUG_ENABLE=y
CONFIG_AIC79XX_DEBUG_MASK=0
CONFIG_AIC79XX_REG_PRETTY_PRINT=y
CONFIG_SCSI_AIC94XX=m
CONFIG_AIC94XX_DEBUG=y
CONFIG_SCSI_MVSAS=m
CONFIG_SCSI_MVSAS_DEBUG=y
CONFIG_SCSI_DPT_I2O=m
CONFIG_SCSI_ADVANSYS=m
CONFIG_SCSI_ARCMSR=m
CONFIG_SCSI_ARCMSR_AER=y
CONFIG_MEGARAID_NEWGEN=y
CONFIG_MEGARAID_MM=m
CONFIG_MEGARAID_MAILBOX=m
CONFIG_MEGARAID_LEGACY=m
CONFIG_MEGARAID_SAS=m
CONFIG_SCSI_MPT2SAS=m
CONFIG_SCSI_MPT2SAS_MAX_SGE=128
CONFIG_SCSI_MPT2SAS_LOGGING=y
CONFIG_SCSI_HPTIOP=m
CONFIG_SCSI_BUSLOGIC=m
CONFIG_VMWARE_PVSCSI=m
CONFIG_LIBFC=m
CONFIG_LIBFCOE=m
CONFIG_FCOE=m
CONFIG_FCOE_FNIC=m
CONFIG_SCSI_DMX3191D=m
CONFIG_SCSI_EATA=m
CONFIG_SCSI_EATA_TAGGED_QUEUE=y
CONFIG_SCSI_EATA_LINKED_COMMANDS=y
CONFIG_SCSI_EATA_MAX_TAGS=16
CONFIG_SCSI_FUTURE_DOMAIN=m
CONFIG_SCSI_GDTH=m
CONFIG_SCSI_IPS=m
CONFIG_SCSI_INITIO=m
CONFIG_SCSI_INIA100=m
CONFIG_SCSI_PPA=m
CONFIG_SCSI_IMM=m
CONFIG_SCSI_IZIP_EPP16=y
CONFIG_SCSI_IZIP_SLOW_CTR=y
CONFIG_SCSI_STEX=m
CONFIG_SCSI_SYM53C8XX_2=m
CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=1
CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=16
CONFIG_SCSI_SYM53C8XX_MAX_TAGS=64
CONFIG_SCSI_SYM53C8XX_MMIO=y
CONFIG_SCSI_IPR=m
CONFIG_SCSI_IPR_TRACE=y
CONFIG_SCSI_IPR_DUMP=y
CONFIG_SCSI_QLOGIC_1280=m
CONFIG_SCSI_QLA_FC=m
CONFIG_SCSI_QLA_ISCSI=m
CONFIG_SCSI_LPFC=m
CONFIG_SCSI_LPFC_DEBUG_FS=y
CONFIG_SCSI_DC395x=m
CONFIG_SCSI_DC390T=m
CONFIG_SCSI_DEBUG=m
CONFIG_SCSI_PMCRAID=m
CONFIG_SCSI_PM8001=m
CONFIG_SCSI_SRP=m
CONFIG_SCSI_BFA_FC=m
CONFIG_SCSI_LOWLEVEL_PCMCIA=y
CONFIG_PCMCIA_AHA152X=m
CONFIG_PCMCIA_FDOMAIN=m
CONFIG_PCMCIA_QLOGIC=m
CONFIG_PCMCIA_SYM53C500=m
CONFIG_SCSI_DH=m
CONFIG_SCSI_DH_RDAC=m
CONFIG_SCSI_DH_HP_SW=m
CONFIG_SCSI_DH_EMC=m
CONFIG_SCSI_DH_ALUA=m
CONFIG_SCSI_OSD_INITIATOR=m
CONFIG_SCSI_OSD_ULD=m
CONFIG_SCSI_OSD_DPRINT_SENSE=1
CONFIG_SCSI_OSD_DEBUG=y
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=y
CONFIG_SATA_AHCI_PLATFORM=m
CONFIG_SATA_INIC162X=m
CONFIG_SATA_SIL24=m
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
CONFIG_PDC_ADMA=m
CONFIG_SATA_QSTOR=m
CONFIG_SATA_SX4=m
CONFIG_ATA_BMDMA=y

#
# SATA SFF controllers with BMDMA
#
CONFIG_ATA_PIIX=m
CONFIG_SATA_MV=m
CONFIG_SATA_NV=m
CONFIG_SATA_PROMISE=m
CONFIG_SATA_SIL=m
CONFIG_SATA_SIS=m
CONFIG_SATA_SVW=m
CONFIG_SATA_ULI=m
CONFIG_SATA_VIA=m
CONFIG_SATA_VITESSE=m

#
# PATA SFF controllers with BMDMA
#
CONFIG_PATA_ALI=m
CONFIG_PATA_AMD=m
CONFIG_PATA_ARTOP=m
CONFIG_PATA_ATIIXP=m
CONFIG_PATA_ATP867X=m
CONFIG_PATA_CMD64X=m
CONFIG_PATA_CS5520=m
CONFIG_PATA_CS5530=m
CONFIG_PATA_CYPRESS=m
CONFIG_PATA_EFAR=m
CONFIG_PATA_HPT366=m
CONFIG_PATA_HPT37X=m
CONFIG_PATA_HPT3X2N=m
CONFIG_PATA_HPT3X3=m
CONFIG_PATA_HPT3X3_DMA=y
CONFIG_PATA_IT8213=m
CONFIG_PATA_IT821X=m
CONFIG_PATA_JMICRON=m
CONFIG_PATA_MARVELL=m
CONFIG_PATA_NETCELL=m
CONFIG_PATA_NINJA32=m
CONFIG_PATA_NS87415=m
CONFIG_PATA_OLDPIIX=m
CONFIG_PATA_OPTIDMA=m
CONFIG_PATA_PDC2027X=m
CONFIG_PATA_PDC_OLD=m
CONFIG_PATA_RADISYS=m
CONFIG_PATA_RDC=m
CONFIG_PATA_SC1200=m
CONFIG_PATA_SCH=m
CONFIG_PATA_SERVERWORKS=m
CONFIG_PATA_SIL680=m
CONFIG_PATA_SIS=m
CONFIG_PATA_TOSHIBA=m
CONFIG_PATA_TRIFLEX=m
CONFIG_PATA_VIA=m
CONFIG_PATA_WINBOND=m

#
# PIO-only SFF controllers
#
CONFIG_PATA_CMD640_PCI=m
CONFIG_PATA_MPIIX=m
CONFIG_PATA_NS87410=m
CONFIG_PATA_OPTI=m
CONFIG_PATA_PCMCIA=m
CONFIG_PATA_PLATFORM=m
CONFIG_PATA_RZ1000=m

#
# Generic fallback / legacy drivers
#
CONFIG_PATA_ACPI=m
CONFIG_ATA_GENERIC=m
CONFIG_PATA_LEGACY=m
CONFIG_MD=y
CONFIG_BLK_DEV_MD=m
CONFIG_MD_LINEAR=m
CONFIG_MD_RAID0=m
CONFIG_MD_RAID1=m
CONFIG_MD_RAID10=m
CONFIG_MD_RAID456=m
CONFIG_MULTICORE_RAID456=y
CONFIG_MD_MULTIPATH=m
CONFIG_MD_FAULTY=m
CONFIG_BLK_DEV_DM=m
CONFIG_DM_DEBUG=y
CONFIG_DM_CRYPT=m
CONFIG_DM_SNAPSHOT=m
CONFIG_DM_MIRROR=m
CONFIG_DM_LOG_USERSPACE=m
CONFIG_DM_ZERO=m
CONFIG_DM_MULTIPATH=m
CONFIG_DM_MULTIPATH_QL=m
CONFIG_DM_MULTIPATH_ST=m
CONFIG_DM_DELAY=m
CONFIG_DM_UEVENT=y
CONFIG_FUSION=y
CONFIG_FUSION_SPI=m
CONFIG_FUSION_FC=m
CONFIG_FUSION_SAS=m
CONFIG_FUSION_MAX_SGE=128
CONFIG_FUSION_CTL=m
CONFIG_FUSION_LAN=m
CONFIG_FUSION_LOGGING=y

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=m
CONFIG_FIREWIRE_OHCI=m
CONFIG_FIREWIRE_OHCI_DEBUG=y
CONFIG_FIREWIRE_SBP2=m
CONFIG_FIREWIRE_NET=m
CONFIG_FIREWIRE_NOSY=m
CONFIG_I2O=m
CONFIG_I2O_LCT_NOTIFY_ON_CHANGES=y
CONFIG_I2O_EXT_ADAPTEC=y
CONFIG_I2O_EXT_ADAPTEC_DMA64=y
CONFIG_I2O_CONFIG=m
CONFIG_I2O_CONFIG_OLD_IOCTL=y
CONFIG_I2O_BUS=m
CONFIG_I2O_BLOCK=m
CONFIG_I2O_SCSI=m
CONFIG_I2O_PROC=m
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=m
CONFIG_NETDEVICES=y
CONFIG_IFB=m
CONFIG_DUMMY=m
CONFIG_BONDING=m
CONFIG_MACVLAN=m
CONFIG_MACVTAP=m
CONFIG_EQUALIZER=m
CONFIG_TUN=m
CONFIG_VETH=m
CONFIG_NET_SB1000=m
CONFIG_ARCNET=m
CONFIG_ARCNET_1201=m
CONFIG_ARCNET_1051=m
CONFIG_ARCNET_RAW=m
CONFIG_ARCNET_CAP=m
CONFIG_ARCNET_COM90xx=m
CONFIG_ARCNET_COM90xxIO=m
CONFIG_ARCNET_RIM_I=m
CONFIG_ARCNET_COM20020=m
CONFIG_ARCNET_COM20020_PCI=m
CONFIG_MII=m
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
CONFIG_MARVELL_PHY=m
CONFIG_DAVICOM_PHY=m
CONFIG_QSEMI_PHY=m
CONFIG_LXT_PHY=m
CONFIG_CICADA_PHY=m
CONFIG_VITESSE_PHY=m
CONFIG_SMSC_PHY=m
CONFIG_BROADCOM_PHY=m
CONFIG_BCM63XX_PHY=m
CONFIG_ICPLUS_PHY=m
CONFIG_REALTEK_PHY=m
CONFIG_NATIONAL_PHY=m
CONFIG_STE10XP=m
CONFIG_LSI_ET1011C_PHY=m
CONFIG_MICREL_PHY=m
CONFIG_FIXED_PHY=y
CONFIG_MDIO_BITBANG=m
CONFIG_MDIO_GPIO=m
CONFIG_NET_ETHERNET=y
CONFIG_HAPPYMEAL=m
CONFIG_SUNGEM=m
CONFIG_CASSINI=m
CONFIG_NET_VENDOR_3COM=y
CONFIG_VORTEX=m
CONFIG_TYPHOON=m
CONFIG_ENC28J60=m
CONFIG_ENC28J60_WRITEVERIFY=y
CONFIG_ETHOC=m
CONFIG_DNET=m
CONFIG_NET_TULIP=y
CONFIG_DE2104X=m
CONFIG_DE2104X_DSL=0
CONFIG_TULIP=m
CONFIG_TULIP_MWI=y
CONFIG_TULIP_MMIO=y
CONFIG_TULIP_NAPI=y
CONFIG_TULIP_NAPI_HW_MITIGATION=y
CONFIG_DE4X5=m
CONFIG_WINBOND_840=m
CONFIG_DM9102=m
CONFIG_ULI526X=m
CONFIG_PCMCIA_XIRCOM=m
CONFIG_HP100=m
# CONFIG_IBM_NEW_EMAC_ZMII is not set
# CONFIG_IBM_NEW_EMAC_RGMII is not set
# CONFIG_IBM_NEW_EMAC_TAH is not set
# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
# CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
# CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
# CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
CONFIG_NET_PCI=y
CONFIG_PCNET32=m
CONFIG_AMD8111_ETH=m
CONFIG_ADAPTEC_STARFIRE=m
CONFIG_KSZ884X_PCI=m
CONFIG_B44=m
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
CONFIG_FORCEDETH=m
CONFIG_E100=m
CONFIG_FEALNX=m
CONFIG_NATSEMI=m
CONFIG_NE2K_PCI=m
CONFIG_8139CP=m
CONFIG_8139TOO=m
CONFIG_8139TOO_PIO=y
CONFIG_8139TOO_TUNE_TWISTER=y
CONFIG_8139TOO_8129=y
CONFIG_8139_OLD_RX_RESET=y
CONFIG_R6040=m
CONFIG_SIS900=m
CONFIG_EPIC100=m
CONFIG_SMSC9420=m
CONFIG_SUNDANCE=m
CONFIG_SUNDANCE_MMIO=y
CONFIG_TLAN=m
CONFIG_KS8842=m
CONFIG_KS8851=m
CONFIG_KS8851_MLL=m
CONFIG_VIA_RHINE=m
CONFIG_VIA_RHINE_MMIO=y
CONFIG_SC92031=m
CONFIG_NET_POCKET=y
CONFIG_ATP=m
CONFIG_DE600=m
CONFIG_DE620=m
CONFIG_ATL2=m
CONFIG_NETDEV_1000=y
CONFIG_ACENIC=m
CONFIG_ACENIC_OMIT_TIGON_I=y
CONFIG_DL2K=m
CONFIG_E1000=m
CONFIG_E1000E=m
CONFIG_IP1000=m
CONFIG_IGB=m
CONFIG_IGB_DCA=y
CONFIG_IGBVF=m
CONFIG_NS83820=m
CONFIG_HAMACHI=m
CONFIG_YELLOWFIN=m
CONFIG_R8169=m
CONFIG_R8169_VLAN=y
CONFIG_SIS190=m
CONFIG_SKGE=m
CONFIG_SKGE_DEBUG=y
CONFIG_SKY2=m
CONFIG_SKY2_DEBUG=y
CONFIG_VIA_VELOCITY=m
CONFIG_TIGON3=m
CONFIG_BNX2=m
CONFIG_CNIC=m
CONFIG_QLA3XXX=m
CONFIG_ATL1=m
CONFIG_ATL1E=m
CONFIG_ATL1C=m
CONFIG_JME=m
CONFIG_STMMAC_ETH=m
CONFIG_STMMAC_DA=y
CONFIG_STMMAC_DUAL_MAC=y
CONFIG_PCH_GBE=m
CONFIG_NETDEV_10000=y
CONFIG_MDIO=m
CONFIG_CHELSIO_T1=m
CONFIG_CHELSIO_T1_1G=y
CONFIG_CHELSIO_T3_DEPENDS=y
CONFIG_CHELSIO_T3=m
CONFIG_CHELSIO_T4_DEPENDS=y
CONFIG_CHELSIO_T4=m
CONFIG_CHELSIO_T4VF_DEPENDS=y
CONFIG_CHELSIO_T4VF=m
CONFIG_ENIC=m
CONFIG_IXGBE=m
CONFIG_IXGBE_DCA=y
CONFIG_IXGBE_DCB=y
CONFIG_IXGBEVF=m
CONFIG_IXGB=m
CONFIG_S2IO=m
CONFIG_VXGE=m
CONFIG_VXGE_DEBUG_TRACE_ALL=y
CONFIG_MYRI10GE=m
CONFIG_MYRI10GE_DCA=y
CONFIG_NETXEN_NIC=m
CONFIG_NIU=m
CONFIG_MLX4_EN=m
CONFIG_MLX4_CORE=m
CONFIG_MLX4_DEBUG=y
CONFIG_TEHUTI=m
CONFIG_BNX2X=m
CONFIG_QLCNIC=m
CONFIG_QLGE=m
CONFIG_BNA=m
CONFIG_SFC=m
CONFIG_SFC_MTD=y
CONFIG_BE2NET=m
CONFIG_TR=m
CONFIG_IBMOL=m
CONFIG_3C359=m
CONFIG_TMS380TR=m
CONFIG_TMSPCI=m
CONFIG_ABYSS=m
CONFIG_WLAN=y
CONFIG_PCMCIA_RAYCS=m
CONFIG_LIBERTAS_THINFIRM=m
CONFIG_LIBERTAS_THINFIRM_DEBUG=y
CONFIG_LIBERTAS_THINFIRM_USB=m
CONFIG_AIRO=m
CONFIG_ATMEL=m
CONFIG_PCI_ATMEL=m
CONFIG_PCMCIA_ATMEL=m
CONFIG_AT76C50X_USB=m
CONFIG_AIRO_CS=m
CONFIG_PCMCIA_WL3501=m
CONFIG_PRISM54=m
CONFIG_USB_ZD1201=m
CONFIG_USB_NET_RNDIS_WLAN=m
CONFIG_RTL8180=m
CONFIG_RTL8187=m
CONFIG_RTL8187_LEDS=y
CONFIG_ADM8211=m
CONFIG_MAC80211_HWSIM=m
CONFIG_MWL8K=m
CONFIG_ATH_COMMON=m
CONFIG_ATH_DEBUG=y
CONFIG_ATH5K=m
CONFIG_ATH5K_DEBUG=y
CONFIG_ATH9K_HW=m
CONFIG_ATH9K_COMMON=m
CONFIG_ATH9K=m
CONFIG_ATH9K_DEBUGFS=y
CONFIG_ATH9K_RATE_CONTROL=y
CONFIG_ATH9K_HTC=m
CONFIG_ATH9K_HTC_DEBUGFS=y
CONFIG_AR9170_USB=m
CONFIG_AR9170_LEDS=y
CONFIG_CARL9170=m
CONFIG_CARL9170_LEDS=y
CONFIG_CARL9170_DEBUGFS=y
CONFIG_CARL9170_WPC=y
CONFIG_B43=m
CONFIG_B43_PCI_AUTOSELECT=y
CONFIG_B43_PCICORE_AUTOSELECT=y
CONFIG_B43_PCMCIA=y
CONFIG_B43_SDIO=y
CONFIG_B43_PIO=y
CONFIG_B43_PHY_LP=y
CONFIG_B43_LEDS=y
CONFIG_B43_HWRNG=y
CONFIG_B43_DEBUG=y
CONFIG_B43_FORCE_PIO=y
CONFIG_B43LEGACY=m
CONFIG_B43LEGACY_PCI_AUTOSELECT=y
CONFIG_B43LEGACY_PCICORE_AUTOSELECT=y
CONFIG_B43LEGACY_LEDS=y
CONFIG_B43LEGACY_HWRNG=y
CONFIG_B43LEGACY_DEBUG=y
CONFIG_B43LEGACY_DMA=y
CONFIG_B43LEGACY_PIO=y
CONFIG_B43LEGACY_DMA_AND_PIO_MODE=y
# CONFIG_B43LEGACY_DMA_MODE is not set
# CONFIG_B43LEGACY_PIO_MODE is not set
CONFIG_HOSTAP=m
CONFIG_HOSTAP_FIRMWARE=y
CONFIG_HOSTAP_FIRMWARE_NVRAM=y
CONFIG_HOSTAP_PLX=m
CONFIG_HOSTAP_PCI=m
CONFIG_HOSTAP_CS=m
CONFIG_IPW2100=m
CONFIG_IPW2100_MONITOR=y
CONFIG_IPW2100_DEBUG=y
CONFIG_IPW2200=m
CONFIG_IPW2200_MONITOR=y
CONFIG_IPW2200_RADIOTAP=y
CONFIG_IPW2200_PROMISCUOUS=y
CONFIG_IPW2200_QOS=y
CONFIG_IPW2200_DEBUG=y
CONFIG_LIBIPW=m
CONFIG_LIBIPW_DEBUG=y
CONFIG_IWLWIFI=m

#
# Debugging Options
#
CONFIG_IWLWIFI_DEBUG=y
CONFIG_IWLWIFI_DEBUGFS=y
CONFIG_IWLWIFI_DEBUG_EXPERIMENTAL_UCODE=y
CONFIG_IWLWIFI_DEVICE_TRACING=y
CONFIG_IWLAGN=m
CONFIG_IWL4965=y
CONFIG_IWL5000=y
CONFIG_IWL3945=m
CONFIG_IWM=m
CONFIG_IWM_DEBUG=y
CONFIG_IWM_TRACING=y
CONFIG_LIBERTAS=m
CONFIG_LIBERTAS_USB=m
CONFIG_LIBERTAS_CS=m
CONFIG_LIBERTAS_SDIO=m
CONFIG_LIBERTAS_SPI=m
CONFIG_LIBERTAS_DEBUG=y
CONFIG_LIBERTAS_MESH=y
CONFIG_HERMES=m
CONFIG_HERMES_PRISM=y
CONFIG_HERMES_CACHE_FW_ON_INIT=y
CONFIG_PLX_HERMES=m
CONFIG_TMD_HERMES=m
CONFIG_NORTEL_HERMES=m
CONFIG_PCI_HERMES=m
CONFIG_PCMCIA_HERMES=m
CONFIG_PCMCIA_SPECTRUM=m
CONFIG_ORINOCO_USB=m
CONFIG_P54_COMMON=m
CONFIG_P54_USB=m
CONFIG_P54_PCI=m
CONFIG_P54_SPI=m
CONFIG_P54_SPI_DEFAULT_EEPROM=y
CONFIG_P54_LEDS=y
CONFIG_RT2X00=m
CONFIG_RT2400PCI=m
CONFIG_RT2500PCI=m
CONFIG_RT61PCI=m
CONFIG_RT2800PCI_PCI=y
CONFIG_RT2800PCI=m
CONFIG_RT2800PCI_RT30XX=y
CONFIG_RT2800PCI_RT35XX=y
CONFIG_RT2500USB=m
CONFIG_RT73USB=m
CONFIG_RT2800USB=m
CONFIG_RT2800USB_RT30XX=y
CONFIG_RT2800USB_RT35XX=y
CONFIG_RT2800USB_UNKNOWN=y
CONFIG_RT2800_LIB=m
CONFIG_RT2X00_LIB_PCI=m
CONFIG_RT2X00_LIB_USB=m
CONFIG_RT2X00_LIB=m
CONFIG_RT2X00_LIB_HT=y
CONFIG_RT2X00_LIB_FIRMWARE=y
CONFIG_RT2X00_LIB_CRYPTO=y
CONFIG_RT2X00_LIB_LEDS=y
CONFIG_RT2X00_LIB_DEBUGFS=y
CONFIG_RT2X00_DEBUG=y
CONFIG_WL1251=m
CONFIG_WL1251_SPI=m
CONFIG_WL1251_SDIO=m
CONFIG_WL12XX=m
CONFIG_WL1271=m
CONFIG_WL1271_SPI=m
CONFIG_WL1271_SDIO=m
CONFIG_WL12XX_PLATFORM_DATA=y
CONFIG_ZD1211RW=m
CONFIG_ZD1211RW_DEBUG=y

#
# WiMAX Wireless Broadband devices
#
CONFIG_WIMAX_I2400M=m
CONFIG_WIMAX_I2400M_USB=m
CONFIG_WIMAX_I2400M_SDIO=m
CONFIG_WIMAX_IWMC3200_SDIO=y
CONFIG_WIMAX_I2400M_DEBUG_LEVEL=8

#
# USB Network Adapters
#
CONFIG_USB_CATC=m
CONFIG_USB_KAWETH=m
CONFIG_USB_PEGASUS=m
CONFIG_USB_RTL8150=m
CONFIG_USB_USBNET=m
CONFIG_USB_NET_AX8817X=m
CONFIG_USB_NET_CDCETHER=m
CONFIG_USB_NET_CDC_EEM=m
CONFIG_USB_NET_DM9601=m
CONFIG_USB_NET_SMSC75XX=m
CONFIG_USB_NET_SMSC95XX=m
CONFIG_USB_NET_GL620A=m
CONFIG_USB_NET_NET1080=m
CONFIG_USB_NET_PLUSB=m
CONFIG_USB_NET_MCS7830=m
CONFIG_USB_NET_RNDIS_HOST=m
CONFIG_USB_NET_CDC_SUBSET=m
CONFIG_USB_ALI_M5632=y
CONFIG_USB_AN2720=y
CONFIG_USB_BELKIN=y
CONFIG_USB_ARMLINUX=y
CONFIG_USB_EPSON2888=y
CONFIG_USB_KC2190=y
CONFIG_USB_NET_ZAURUS=m
CONFIG_USB_NET_CX82310_ETH=m
CONFIG_USB_HSO=m
CONFIG_USB_NET_INT51X1=m
CONFIG_USB_CDC_PHONET=m
CONFIG_USB_IPHETH=m
CONFIG_USB_SIERRA_NET=m
CONFIG_NET_PCMCIA=y
CONFIG_PCMCIA_3C589=m
CONFIG_PCMCIA_3C574=m
CONFIG_PCMCIA_FMVJ18X=m
CONFIG_PCMCIA_PCNET=m
CONFIG_PCMCIA_NMCLAN=m
CONFIG_PCMCIA_SMC91C92=m
CONFIG_PCMCIA_XIRC2PS=m
CONFIG_PCMCIA_AXNET=m
CONFIG_ARCNET_COM20020_CS=m
CONFIG_PCMCIA_IBMTR=m
CONFIG_WAN=y
CONFIG_LANMEDIA=m
CONFIG_HDLC=m
CONFIG_HDLC_RAW=m
CONFIG_HDLC_RAW_ETH=m
CONFIG_HDLC_CISCO=m
CONFIG_HDLC_FR=m
CONFIG_HDLC_PPP=m
CONFIG_HDLC_X25=m
CONFIG_PCI200SYN=m
CONFIG_WANXL=m
CONFIG_PC300TOO=m
CONFIG_FARSYNC=m
CONFIG_DSCC4=m
CONFIG_DSCC4_PCISYNC=y
CONFIG_DSCC4_PCI_RST=y
CONFIG_DLCI=m
CONFIG_DLCI_MAX=8
CONFIG_WAN_ROUTER_DRIVERS=m
CONFIG_CYCLADES_SYNC=m
CONFIG_CYCLOMX_X25=y
CONFIG_LAPBETHER=m
CONFIG_X25_ASY=m
CONFIG_SBNI=m
CONFIG_SBNI_MULTILINE=y
CONFIG_ATM_DRIVERS=y
CONFIG_ATM_DUMMY=m
CONFIG_ATM_TCP=m
CONFIG_ATM_LANAI=m
CONFIG_ATM_ENI=m
CONFIG_ATM_ENI_DEBUG=y
CONFIG_ATM_ENI_TUNE_BURST=y
CONFIG_ATM_ENI_BURST_TX_16W=y
CONFIG_ATM_ENI_BURST_TX_8W=y
CONFIG_ATM_ENI_BURST_TX_4W=y
CONFIG_ATM_ENI_BURST_TX_2W=y
CONFIG_ATM_ENI_BURST_RX_16W=y
CONFIG_ATM_ENI_BURST_RX_8W=y
CONFIG_ATM_ENI_BURST_RX_4W=y
CONFIG_ATM_ENI_BURST_RX_2W=y
CONFIG_ATM_FIRESTREAM=m
CONFIG_ATM_ZATM=m
CONFIG_ATM_ZATM_DEBUG=y
CONFIG_ATM_NICSTAR=m
CONFIG_ATM_NICSTAR_USE_SUNI=y
CONFIG_ATM_NICSTAR_USE_IDT77105=y
CONFIG_ATM_IDT77252=m
CONFIG_ATM_IDT77252_DEBUG=y
CONFIG_ATM_IDT77252_RCV_ALL=y
CONFIG_ATM_IDT77252_USE_SUNI=y
CONFIG_ATM_AMBASSADOR=m
CONFIG_ATM_AMBASSADOR_DEBUG=y
CONFIG_ATM_HORIZON=m
CONFIG_ATM_HORIZON_DEBUG=y
CONFIG_ATM_IA=m
CONFIG_ATM_IA_DEBUG=y
CONFIG_ATM_FORE200E=m
CONFIG_ATM_FORE200E_USE_TASKLET=y
CONFIG_ATM_FORE200E_TX_RETRY=16
CONFIG_ATM_FORE200E_DEBUG=0
CONFIG_ATM_HE=m
CONFIG_ATM_HE_USE_SUNI=y
CONFIG_ATM_SOLOS=m
CONFIG_IEEE802154_DRIVERS=m
CONFIG_IEEE802154_FAKEHARD=m

#
# CAIF transport drivers
#
CONFIG_CAIF_TTY=m
CONFIG_CAIF_SPI_SLAVE=m
CONFIG_CAIF_SPI_SYNC=y
CONFIG_XEN_NETDEV_FRONTEND=m
CONFIG_FDDI=m
CONFIG_DEFXX=m
CONFIG_DEFXX_MMIO=y
CONFIG_SKFP=m
CONFIG_HIPPI=y
CONFIG_ROADRUNNER=m
CONFIG_ROADRUNNER_LARGE_RINGS=y
CONFIG_PLIP=m
CONFIG_PPP=m
CONFIG_PPP_MULTILINK=y
CONFIG_PPP_FILTER=y
CONFIG_PPP_ASYNC=m
CONFIG_PPP_SYNC_TTY=m
CONFIG_PPP_DEFLATE=m
CONFIG_PPP_BSDCOMP=m
CONFIG_PPP_MPPE=m
CONFIG_PPPOE=m
CONFIG_PPTP=m
CONFIG_PPPOATM=m
CONFIG_PPPOL2TP=m
CONFIG_SLIP=m
CONFIG_SLIP_COMPRESSED=y
CONFIG_SLHC=m
CONFIG_SLIP_SMART=y
CONFIG_SLIP_MODE_SLIP6=y
CONFIG_NET_FC=y
CONFIG_NETCONSOLE=m
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
CONFIG_NETPOLL_TRAP=y
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_VIRTIO_NET=m
CONFIG_VMXNET3=m
CONFIG_ISDN=y
CONFIG_ISDN_I4L=m
CONFIG_ISDN_PPP=y
CONFIG_ISDN_PPP_VJ=y
CONFIG_ISDN_MPP=y
CONFIG_IPPP_FILTER=y
CONFIG_ISDN_PPP_BSDCOMP=m
CONFIG_ISDN_AUDIO=y
CONFIG_ISDN_TTY_FAX=y
CONFIG_ISDN_X25=y

#
# ISDN feature submodules
#
CONFIG_ISDN_DIVERSION=m

#
# ISDN4Linux hardware drivers
#

#
# Passive cards
#
CONFIG_ISDN_DRV_HISAX=m

#
# D-channel protocol features
#
CONFIG_HISAX_EURO=y
CONFIG_DE_AOC=y
CONFIG_HISAX_NO_SENDCOMPLETE=y
CONFIG_HISAX_NO_LLC=y
CONFIG_HISAX_NO_KEYPAD=y
CONFIG_HISAX_1TR6=y
CONFIG_HISAX_NI1=y
CONFIG_HISAX_MAX_CARDS=8

#
# HiSax supported cards
#
CONFIG_HISAX_16_3=y
CONFIG_HISAX_TELESPCI=y
CONFIG_HISAX_S0BOX=y
CONFIG_HISAX_FRITZPCI=y
CONFIG_HISAX_AVM_A1_PCMCIA=y
CONFIG_HISAX_ELSA=y
CONFIG_HISAX_DIEHLDIVA=y
CONFIG_HISAX_SEDLBAUER=y
CONFIG_HISAX_NETJET=y
CONFIG_HISAX_NETJET_U=y
CONFIG_HISAX_NICCY=y
CONFIG_HISAX_BKM_A4T=y
CONFIG_HISAX_SCT_QUADRO=y
CONFIG_HISAX_GAZEL=y
CONFIG_HISAX_HFC_PCI=y
CONFIG_HISAX_W6692=y
CONFIG_HISAX_HFC_SX=y
CONFIG_HISAX_ENTERNOW_PCI=y
CONFIG_HISAX_DEBUG=y

#
# HiSax PCMCIA card service modules
#
CONFIG_HISAX_SEDLBAUER_CS=m
CONFIG_HISAX_ELSA_CS=m
CONFIG_HISAX_AVM_A1_CS=m
CONFIG_HISAX_TELES_CS=m

#
# HiSax sub driver modules
#
CONFIG_HISAX_ST5481=m
CONFIG_HISAX_HFCUSB=m
CONFIG_HISAX_HFC4S8S=m
CONFIG_HISAX_FRITZ_PCIPNP=m

#
# Active cards
#
CONFIG_ISDN_CAPI=m
CONFIG_ISDN_DRV_AVMB1_VERBOSE_REASON=y
CONFIG_CAPI_TRACE=y
CONFIG_ISDN_CAPI_MIDDLEWARE=y
CONFIG_ISDN_CAPI_CAPI20=m
CONFIG_ISDN_CAPI_CAPIFS_BOOL=y
CONFIG_ISDN_CAPI_CAPIFS=m
CONFIG_ISDN_CAPI_CAPIDRV=m

#
# CAPI hardware drivers
#
CONFIG_CAPI_AVM=y
CONFIG_ISDN_DRV_AVMB1_B1PCI=m
CONFIG_ISDN_DRV_AVMB1_B1PCIV4=y
CONFIG_ISDN_DRV_AVMB1_B1PCMCIA=m
CONFIG_ISDN_DRV_AVMB1_AVM_CS=m
CONFIG_ISDN_DRV_AVMB1_T1PCI=m
CONFIG_ISDN_DRV_AVMB1_C4=m
CONFIG_CAPI_EICON=y
CONFIG_ISDN_DIVAS=m
CONFIG_ISDN_DIVAS_BRIPCI=y
CONFIG_ISDN_DIVAS_PRIPCI=y
CONFIG_ISDN_DIVAS_DIVACAPI=m
CONFIG_ISDN_DIVAS_USERIDI=m
CONFIG_ISDN_DIVAS_MAINT=m
CONFIG_ISDN_DRV_GIGASET=m
CONFIG_GIGASET_CAPI=y
# CONFIG_GIGASET_I4L is not set
# CONFIG_GIGASET_DUMMYLL is not set
CONFIG_GIGASET_BASE=m
CONFIG_GIGASET_M105=m
CONFIG_GIGASET_M101=m
CONFIG_GIGASET_DEBUG=y
CONFIG_HYSDN=m
CONFIG_HYSDN_CAPI=y
CONFIG_MISDN=m
CONFIG_MISDN_DSP=m
CONFIG_MISDN_L1OIP=m

#
# mISDN hardware drivers
#
CONFIG_MISDN_HFCPCI=m
CONFIG_MISDN_HFCMULTI=m
CONFIG_MISDN_HFCUSB=m
CONFIG_MISDN_AVMFRITZ=m
CONFIG_MISDN_SPEEDFAX=m
CONFIG_MISDN_INFINEON=m
CONFIG_MISDN_W6692=m
CONFIG_MISDN_NETJET=m
CONFIG_MISDN_IPAC=m
CONFIG_MISDN_ISAR=m
CONFIG_ISDN_HDLC=m
CONFIG_PHONE=m
CONFIG_PHONE_IXJ=m
CONFIG_PHONE_IXJ_PCMCIA=m

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=m
CONFIG_INPUT_POLLDEV=m
CONFIG_INPUT_SPARSEKMAP=m

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=m
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=m
CONFIG_INPUT_EVDEV=m
# CONFIG_INPUT_EVBUG is not set
CONFIG_XEN_KBDDEV_FRONTEND=m

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ADP5588=m
CONFIG_KEYBOARD_ATKBD=m
CONFIG_KEYBOARD_QT2160=m
CONFIG_KEYBOARD_LKKBD=m
CONFIG_KEYBOARD_GPIO=m
CONFIG_KEYBOARD_TCA6416=m
CONFIG_KEYBOARD_MATRIX=m
CONFIG_KEYBOARD_LM8323=m
CONFIG_KEYBOARD_MAX7359=m
CONFIG_KEYBOARD_MCS=m
CONFIG_KEYBOARD_NEWTON=m
CONFIG_KEYBOARD_OPENCORES=m
CONFIG_KEYBOARD_STOWAWAY=m
CONFIG_KEYBOARD_SUNKBD=m
CONFIG_KEYBOARD_XTKBD=m
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=m
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
CONFIG_MOUSE_PS2_ELANTECH=y
CONFIG_MOUSE_PS2_SENTELIC=y
CONFIG_MOUSE_PS2_TOUCHKIT=y
CONFIG_MOUSE_SERIAL=m
CONFIG_MOUSE_APPLETOUCH=m
CONFIG_MOUSE_BCM5974=m
CONFIG_MOUSE_VSXXXAA=m
CONFIG_MOUSE_GPIO=m
CONFIG_MOUSE_SYNAPTICS_I2C=m
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=m
CONFIG_JOYSTICK_A3D=m
CONFIG_JOYSTICK_ADI=m
CONFIG_JOYSTICK_COBRA=m
CONFIG_JOYSTICK_GF2K=m
CONFIG_JOYSTICK_GRIP=m
CONFIG_JOYSTICK_GRIP_MP=m
CONFIG_JOYSTICK_GUILLEMOT=m
CONFIG_JOYSTICK_INTERACT=m
CONFIG_JOYSTICK_SIDEWINDER=m
CONFIG_JOYSTICK_TMDC=m
CONFIG_JOYSTICK_IFORCE=m
CONFIG_JOYSTICK_IFORCE_USB=y
CONFIG_JOYSTICK_IFORCE_232=y
CONFIG_JOYSTICK_WARRIOR=m
CONFIG_JOYSTICK_MAGELLAN=m
CONFIG_JOYSTICK_SPACEORB=m
CONFIG_JOYSTICK_SPACEBALL=m
CONFIG_JOYSTICK_STINGER=m
CONFIG_JOYSTICK_TWIDJOY=m
CONFIG_JOYSTICK_ZHENHUA=m
CONFIG_JOYSTICK_DB9=m
CONFIG_JOYSTICK_GAMECON=m
CONFIG_JOYSTICK_TURBOGRAFX=m
CONFIG_JOYSTICK_JOYDUMP=m
CONFIG_JOYSTICK_XPAD=m
CONFIG_JOYSTICK_XPAD_FF=y
CONFIG_JOYSTICK_XPAD_LEDS=y
CONFIG_JOYSTICK_WALKERA0701=m
CONFIG_INPUT_TABLET=y
CONFIG_TABLET_USB_ACECAD=m
CONFIG_TABLET_USB_AIPTEK=m
CONFIG_TABLET_USB_GTCO=m
CONFIG_TABLET_USB_HANWANG=m
CONFIG_TABLET_USB_KBTAB=m
CONFIG_TABLET_USB_WACOM=m
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_ADS7846=m
CONFIG_TOUCHSCREEN_AD7877=m
CONFIG_TOUCHSCREEN_AD7879=m
CONFIG_TOUCHSCREEN_AD7879_I2C=m
CONFIG_TOUCHSCREEN_AD7879_SPI=m
CONFIG_TOUCHSCREEN_BU21013=m
CONFIG_TOUCHSCREEN_CY8CTMG110=m
CONFIG_TOUCHSCREEN_DYNAPRO=m
CONFIG_TOUCHSCREEN_HAMPSHIRE=m
CONFIG_TOUCHSCREEN_EETI=m
CONFIG_TOUCHSCREEN_FUJITSU=m
CONFIG_TOUCHSCREEN_GUNZE=m
CONFIG_TOUCHSCREEN_ELO=m
CONFIG_TOUCHSCREEN_WACOM_W8001=m
CONFIG_TOUCHSCREEN_MCS5000=m
CONFIG_TOUCHSCREEN_MTOUCH=m
CONFIG_TOUCHSCREEN_INEXIO=m
CONFIG_TOUCHSCREEN_MK712=m
CONFIG_TOUCHSCREEN_PENMOUNT=m
CONFIG_TOUCHSCREEN_QT602240=m
CONFIG_TOUCHSCREEN_TOUCHRIGHT=m
CONFIG_TOUCHSCREEN_TOUCHWIN=m
CONFIG_TOUCHSCREEN_UCB1400=m
CONFIG_TOUCHSCREEN_WM97XX=m
CONFIG_TOUCHSCREEN_WM9705=y
CONFIG_TOUCHSCREEN_WM9712=y
CONFIG_TOUCHSCREEN_WM9713=y
CONFIG_TOUCHSCREEN_USB_COMPOSITE=m
CONFIG_TOUCHSCREEN_MC13783=m
CONFIG_TOUCHSCREEN_USB_EGALAX=y
CONFIG_TOUCHSCREEN_USB_PANJIT=y
CONFIG_TOUCHSCREEN_USB_3M=y
CONFIG_TOUCHSCREEN_USB_ITM=y
CONFIG_TOUCHSCREEN_USB_ETURBO=y
CONFIG_TOUCHSCREEN_USB_GUNZE=y
CONFIG_TOUCHSCREEN_USB_DMC_TSC10=y
CONFIG_TOUCHSCREEN_USB_IRTOUCH=y
CONFIG_TOUCHSCREEN_USB_IDEALTEK=y
CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH=y
CONFIG_TOUCHSCREEN_USB_GOTOP=y
CONFIG_TOUCHSCREEN_USB_JASTEC=y
CONFIG_TOUCHSCREEN_USB_E2I=y
CONFIG_TOUCHSCREEN_USB_ZYTRONIC=y
CONFIG_TOUCHSCREEN_USB_ETT_TC45USB=y
CONFIG_TOUCHSCREEN_USB_NEXIO=y
CONFIG_TOUCHSCREEN_TOUCHIT213=m
CONFIG_TOUCHSCREEN_TSC2007=m
CONFIG_TOUCHSCREEN_PCAP=m
CONFIG_TOUCHSCREEN_TPS6507X=m
CONFIG_INPUT_MISC=y
CONFIG_INPUT_AD714X=m
CONFIG_INPUT_AD714X_I2C=m
CONFIG_INPUT_AD714X_SPI=m
CONFIG_INPUT_PCSPKR=m
CONFIG_INPUT_APANEL=m
CONFIG_INPUT_ATLAS_BTNS=m
CONFIG_INPUT_ATI_REMOTE=m
CONFIG_INPUT_ATI_REMOTE2=m
CONFIG_INPUT_KEYSPAN_REMOTE=m
CONFIG_INPUT_POWERMATE=m
CONFIG_INPUT_YEALINK=m
CONFIG_INPUT_CM109=m
CONFIG_INPUT_UINPUT=m
CONFIG_INPUT_WINBOND_CIR=m
CONFIG_INPUT_PCF50633_PMU=m
CONFIG_INPUT_PCF8574=m
CONFIG_INPUT_GPIO_ROTARY_ENCODER=m
CONFIG_INPUT_WM831X_ON=m
CONFIG_INPUT_PCAP=m
CONFIG_INPUT_ADXL34X=m
CONFIG_INPUT_ADXL34X_I2C=m
CONFIG_INPUT_ADXL34X_SPI=m

#
# Hardware I/O ports
#
CONFIG_SERIO=m
CONFIG_SERIO_I8042=m
CONFIG_SERIO_SERPORT=m
CONFIG_SERIO_CT82C710=m
CONFIG_SERIO_PARKBD=m
CONFIG_SERIO_PCIPS2=m
CONFIG_SERIO_LIBPS2=m
CONFIG_SERIO_RAW=m
CONFIG_SERIO_ALTERA_PS2=m
CONFIG_SERIO_PS2MULT=m
CONFIG_GAMEPORT=m
CONFIG_GAMEPORT_NS558=m
CONFIG_GAMEPORT_L4=m
CONFIG_GAMEPORT_EMU10K1=m
CONFIG_GAMEPORT_FM801=m

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_DEVKMEM=y
CONFIG_SERIAL_NONSTANDARD=y
CONFIG_COMPUTONE=m
CONFIG_ROCKETPORT=m
CONFIG_CYCLADES=m
CONFIG_CYZ_INTR=y
CONFIG_DIGIEPCA=m
CONFIG_MOXA_INTELLIO=m
CONFIG_MOXA_SMARTIO=m
CONFIG_ISI=m
CONFIG_SYNCLINK=m
CONFIG_SYNCLINKMP=m
CONFIG_SYNCLINK_GT=m
CONFIG_N_HDLC=m
CONFIG_N_GSM=m
CONFIG_RISCOM8=m
CONFIG_SPECIALIX=m
CONFIG_STALDRV=y
CONFIG_STALLION=m
CONFIG_ISTALLION=m
CONFIG_NOZOMI=m

#
# Serial drivers
#
CONFIG_SERIAL_8250=m
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=m
CONFIG_SERIAL_8250_PNP=m
CONFIG_SERIAL_8250_CS=m
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
CONFIG_SERIAL_8250_DETECT_IRQ=y
CONFIG_SERIAL_8250_RSA=y

#
# Non-8250 serial port support
#
CONFIG_SERIAL_MAX3100=m
CONFIG_SERIAL_MAX3107=m
CONFIG_SERIAL_MRST_MAX3110=m
CONFIG_SERIAL_MFD_HSU=m
CONFIG_SERIAL_UARTLITE=m
CONFIG_SERIAL_CORE=m
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_CONSOLE_POLL=y
CONFIG_SERIAL_JSM=m
CONFIG_SERIAL_TIMBERDALE=m
CONFIG_SERIAL_ALTERA_JTAGUART=m
CONFIG_SERIAL_ALTERA_UART=m
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
CONFIG_UNIX98_PTYS=y
CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
CONFIG_TTY_PRINTK=y
CONFIG_PRINTER=m
CONFIG_LP_CONSOLE=y
CONFIG_PPDEV=m
CONFIG_HVC_DRIVER=y
CONFIG_HVC_IRQ=y
CONFIG_HVC_XEN=y
CONFIG_VIRTIO_CONSOLE=m
CONFIG_IPMI_HANDLER=m
CONFIG_IPMI_PANIC_EVENT=y
CONFIG_IPMI_PANIC_STRING=y
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
CONFIG_IPMI_WATCHDOG=m
CONFIG_IPMI_POWEROFF=m
CONFIG_HW_RANDOM=m
CONFIG_HW_RANDOM_TIMERIOMEM=m
CONFIG_HW_RANDOM_INTEL=m
CONFIG_HW_RANDOM_AMD=m
CONFIG_HW_RANDOM_VIA=m
CONFIG_HW_RANDOM_VIRTIO=m
CONFIG_NVRAM=m
CONFIG_R3964=m
CONFIG_APPLICOM=m

#
# PCMCIA character devices
#
CONFIG_SYNCLINK_CS=m
CONFIG_CARDMAN_4000=m
CONFIG_CARDMAN_4040=m
CONFIG_IPWIRELESS=m
CONFIG_MWAVE=m
CONFIG_RAW_DRIVER=m
CONFIG_MAX_RAW_DEVS=256
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
CONFIG_HANGCHECK_TIMER=m
CONFIG_UV_MMTIMER=m
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
CONFIG_TCG_NSC=m
CONFIG_TCG_ATMEL=m
CONFIG_TCG_INFINEON=m
CONFIG_TELCLOCK=m
CONFIG_DEVPORT=y
CONFIG_RAMOOPS=m
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_MUX=m

#
# Multiplexer I2C Chip support
#
CONFIG_I2C_MUX_PCA9541=m
CONFIG_I2C_MUX_PCA954x=m
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=m
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCA=m

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
CONFIG_I2C_ALI1535=m
CONFIG_I2C_ALI1563=m
CONFIG_I2C_ALI15X3=m
CONFIG_I2C_AMD756=m
CONFIG_I2C_AMD756_S4882=m
CONFIG_I2C_AMD8111=m
CONFIG_I2C_I801=m
CONFIG_I2C_ISCH=m
CONFIG_I2C_PIIX4=m
CONFIG_I2C_NFORCE2=m
CONFIG_I2C_NFORCE2_S4985=m
CONFIG_I2C_SIS5595=m
CONFIG_I2C_SIS630=m
CONFIG_I2C_SIS96X=m
CONFIG_I2C_VIA=m
CONFIG_I2C_VIAPRO=m

#
# ACPI drivers
#
CONFIG_I2C_SCMI=m

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_GPIO=m
CONFIG_I2C_INTEL_MID=m
CONFIG_I2C_OCORES=m
CONFIG_I2C_PCA_PLATFORM=m
CONFIG_I2C_SIMTEC=m
CONFIG_I2C_XILINX=m

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT=m
CONFIG_I2C_PARPORT_LIGHT=m
CONFIG_I2C_TAOS_EVM=m
CONFIG_I2C_TINY_USB=m

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_STUB=m
CONFIG_I2C_DEBUG_CORE=y
CONFIG_I2C_DEBUG_ALGO=y
CONFIG_I2C_DEBUG_BUS=y
CONFIG_SPI=y
CONFIG_SPI_DEBUG=y
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
CONFIG_SPI_BITBANG=m
CONFIG_SPI_BUTTERFLY=m
CONFIG_SPI_GPIO=m
CONFIG_SPI_LM70_LLP=m
CONFIG_SPI_TOPCLIFF_PCH=m
CONFIG_SPI_XILINX=m
CONFIG_SPI_XILINX_PLTFM=m
CONFIG_SPI_DESIGNWARE=m
CONFIG_SPI_DW_PCI=m

#
# SPI Protocol Masters
#
CONFIG_SPI_SPIDEV=m
CONFIG_SPI_TLE62X0=m

#
# PPS support
#
CONFIG_PPS=m
CONFIG_PPS_DEBUG=y

#
# PPS clients support
#
CONFIG_PPS_CLIENT_KTIMER=m
CONFIG_PPS_CLIENT_LDISC=m
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_DEBUG_GPIO=y
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_MAX730X=m

#
# Memory mapped GPIO expanders:
#
CONFIG_GPIO_BASIC_MMIO=m
CONFIG_GPIO_IT8761E=m
CONFIG_GPIO_SCH=m
CONFIG_GPIO_VX855=m

#
# I2C GPIO expanders:
#
CONFIG_GPIO_MAX7300=m
CONFIG_GPIO_MAX732X=m
CONFIG_GPIO_PCA953X=m
CONFIG_GPIO_PCF857X=m
# CONFIG_GPIO_SX150X is not set
CONFIG_GPIO_WM831X=m
CONFIG_GPIO_ADP5588=m

#
# PCI GPIO expanders:
#
CONFIG_GPIO_CS5535=m
CONFIG_GPIO_LANGWELL=y
CONFIG_GPIO_PCH=m
CONFIG_GPIO_TIMBERDALE=y
CONFIG_GPIO_RDC321X=m

#
# SPI GPIO expanders:
#
CONFIG_GPIO_MAX7301=m
CONFIG_GPIO_MCP23S08=m
CONFIG_GPIO_MC33880=m
CONFIG_GPIO_74X164=m

#
# AC97 GPIO expanders:
#
CONFIG_GPIO_UCB1400=y

#
# MODULbus GPIO expanders:
#
CONFIG_GPIO_JANZ_TTL=m
CONFIG_W1=m
CONFIG_W1_CON=y

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=m
CONFIG_W1_MASTER_DS2490=m
CONFIG_W1_MASTER_DS2482=m
CONFIG_W1_MASTER_GPIO=m

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=m
CONFIG_W1_SLAVE_SMEM=m
CONFIG_W1_SLAVE_DS2431=m
CONFIG_W1_SLAVE_DS2433=m
CONFIG_W1_SLAVE_DS2433_CRC=y
CONFIG_W1_SLAVE_DS2760=m
CONFIG_W1_SLAVE_BQ27000=m
CONFIG_POWER_SUPPLY=m
CONFIG_POWER_SUPPLY_DEBUG=y
CONFIG_PDA_POWER=m
CONFIG_WM831X_BACKUP=m
CONFIG_WM831X_POWER=m
CONFIG_TEST_POWER=m
CONFIG_BATTERY_DS2760=m
CONFIG_BATTERY_DS2782=m
CONFIG_BATTERY_BQ20Z75=m
CONFIG_BATTERY_BQ27x00=m
CONFIG_BATTERY_MAX17040=m
CONFIG_CHARGER_PCF50633=m
CONFIG_CHARGER_ISP1704=m
CONFIG_HWMON=m
CONFIG_HWMON_VID=m
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=m
CONFIG_SENSORS_ABITUGURU3=m
CONFIG_SENSORS_AD7414=m
CONFIG_SENSORS_AD7418=m
CONFIG_SENSORS_ADCXX=m
CONFIG_SENSORS_ADM1021=m
CONFIG_SENSORS_ADM1025=m
CONFIG_SENSORS_ADM1026=m
CONFIG_SENSORS_ADM1029=m
CONFIG_SENSORS_ADM1031=m
CONFIG_SENSORS_ADM9240=m
CONFIG_SENSORS_ADT7411=m
CONFIG_SENSORS_ADT7462=m
CONFIG_SENSORS_ADT7470=m
CONFIG_SENSORS_ADT7475=m
CONFIG_SENSORS_ASC7621=m
CONFIG_SENSORS_K8TEMP=m
CONFIG_SENSORS_K10TEMP=m
CONFIG_SENSORS_ASB100=m
CONFIG_SENSORS_ATXP1=m
CONFIG_SENSORS_DS1621=m
CONFIG_SENSORS_I5K_AMB=m
CONFIG_SENSORS_F71805F=m
CONFIG_SENSORS_F71882FG=m
CONFIG_SENSORS_F75375S=m
CONFIG_SENSORS_FSCHMD=m
CONFIG_SENSORS_G760A=m
CONFIG_SENSORS_GL518SM=m
CONFIG_SENSORS_GL520SM=m
CONFIG_SENSORS_GPIO_FAN=m
CONFIG_SENSORS_CORETEMP=m
CONFIG_SENSORS_PKGTEMP=m
CONFIG_SENSORS_IBMAEM=m
CONFIG_SENSORS_IBMPEX=m
CONFIG_SENSORS_IT87=m
CONFIG_SENSORS_JC42=m
CONFIG_SENSORS_LM63=m
CONFIG_SENSORS_LM70=m
CONFIG_SENSORS_LM73=m
CONFIG_SENSORS_LM75=m
CONFIG_SENSORS_LM77=m
CONFIG_SENSORS_LM78=m
CONFIG_SENSORS_LM80=m
CONFIG_SENSORS_LM83=m
CONFIG_SENSORS_LM85=m
CONFIG_SENSORS_LM87=m
CONFIG_SENSORS_LM90=m
CONFIG_SENSORS_LM92=m
CONFIG_SENSORS_LM93=m
CONFIG_SENSORS_LTC4215=m
CONFIG_SENSORS_LTC4245=m
CONFIG_SENSORS_LTC4261=m
CONFIG_SENSORS_LM95241=m
CONFIG_SENSORS_MAX1111=m
CONFIG_SENSORS_MAX1619=m
CONFIG_SENSORS_MAX6650=m
CONFIG_SENSORS_PC87360=m
CONFIG_SENSORS_PC87427=m
CONFIG_SENSORS_PCF8591=m
CONFIG_SENSORS_SHT15=m
CONFIG_SENSORS_SIS5595=m
CONFIG_SENSORS_SMM665=m
CONFIG_SENSORS_DME1737=m
CONFIG_SENSORS_EMC1403=m
CONFIG_SENSORS_EMC2103=m
CONFIG_SENSORS_SMSC47M1=m
CONFIG_SENSORS_SMSC47M192=m
CONFIG_SENSORS_SMSC47B397=m
CONFIG_SENSORS_ADS7828=m
CONFIG_SENSORS_ADS7871=m
CONFIG_SENSORS_AMC6821=m
CONFIG_SENSORS_THMC50=m
CONFIG_SENSORS_TMP102=m
CONFIG_SENSORS_TMP401=m
CONFIG_SENSORS_TMP421=m
CONFIG_SENSORS_VIA_CPUTEMP=m
CONFIG_SENSORS_VIA686A=m
CONFIG_SENSORS_VT1211=m
CONFIG_SENSORS_VT8231=m
CONFIG_SENSORS_W83781D=m
CONFIG_SENSORS_W83791D=m
CONFIG_SENSORS_W83792D=m
CONFIG_SENSORS_W83793=m
CONFIG_SENSORS_W83795=m
CONFIG_SENSORS_W83795_FANCTRL=y
CONFIG_SENSORS_W83L785TS=m
CONFIG_SENSORS_W83L786NG=m
CONFIG_SENSORS_W83627HF=m
CONFIG_SENSORS_W83627EHF=m
CONFIG_SENSORS_WM831X=m
CONFIG_SENSORS_LIS3_I2C=m
CONFIG_SENSORS_APPLESMC=m
CONFIG_SENSORS_MC13783_ADC=m

#
# ACPI drivers
#
CONFIG_SENSORS_ATK0110=m
CONFIG_SENSORS_LIS3LV02D=m
CONFIG_THERMAL=m
CONFIG_THERMAL_HWMON=y
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_NOWAYOUT=y

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=m
CONFIG_WM831X_WATCHDOG=m
CONFIG_ACQUIRE_WDT=m
CONFIG_ADVANTECH_WDT=m
CONFIG_ALIM1535_WDT=m
CONFIG_ALIM7101_WDT=m
CONFIG_F71808E_WDT=m
CONFIG_GEODE_WDT=m
CONFIG_SC520_WDT=m
CONFIG_SBC_FITPC2_WATCHDOG=m
CONFIG_EUROTECH_WDT=m
CONFIG_IB700_WDT=m
CONFIG_IBMASR=m
CONFIG_WAFER_WDT=m
CONFIG_I6300ESB_WDT=m
CONFIG_ITCO_WDT=m
CONFIG_ITCO_VENDOR_SUPPORT=y
CONFIG_IT8712F_WDT=m
CONFIG_IT87_WDT=m
CONFIG_HP_WATCHDOG=m
CONFIG_HPWDT_NMI_DECODING=y
CONFIG_SC1200_WDT=m
CONFIG_PC87413_WDT=m
CONFIG_60XX_WDT=m
CONFIG_SBC8360_WDT=m
CONFIG_CPU5_WDT=m
CONFIG_SMSC_SCH311X_WDT=m
CONFIG_SMSC37B787_WDT=m
CONFIG_W83627HF_WDT=m
CONFIG_W83697HF_WDT=m
CONFIG_W83697UG_WDT=m
CONFIG_W83877F_WDT=m
CONFIG_W83977F_WDT=m
CONFIG_MACHZ_WDT=m
CONFIG_SBC_EPX_C3_WATCHDOG=m

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=m
CONFIG_WDTPCI=m

#
# USB-based Watchdog Cards
#
CONFIG_USBPCWATCHDOG=m
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=m
CONFIG_SSB_SPROM=y
CONFIG_SSB_BLOCKIO=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
CONFIG_SSB_B43_PCI_BRIDGE=y
CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
CONFIG_SSB_PCMCIAHOST=y
CONFIG_SSB_SDIOHOST_POSSIBLE=y
CONFIG_SSB_SDIOHOST=y
CONFIG_SSB_SILENT=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y
CONFIG_MFD_SUPPORT=y
CONFIG_MFD_CORE=y
# CONFIG_MFD_88PM860X is not set
CONFIG_MFD_SM501=m
CONFIG_MFD_SM501_GPIO=y
CONFIG_HTC_PASIC3=m
# CONFIG_HTC_I2CPLD is not set
CONFIG_UCB1400_CORE=m
CONFIG_TPS65010=m
CONFIG_TPS6507X=m
# CONFIG_TWL4030_CORE is not set
# CONFIG_MFD_STMPE is not set
# CONFIG_MFD_TC35892 is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8998 is not set
CONFIG_MFD_WM8400=m
CONFIG_MFD_WM831X=y
# CONFIG_MFD_WM831X_I2C is not set
CONFIG_MFD_WM831X_SPI=y
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
CONFIG_MFD_PCF50633=m
CONFIG_MFD_MC13783=m
CONFIG_MFD_MC13XXX=m
CONFIG_PCF50633_ADC=m
CONFIG_PCF50633_GPIO=m
CONFIG_ABX500_CORE=y
# CONFIG_AB3100_CORE is not set
CONFIG_EZX_PCAP=y
# CONFIG_AB3550_CORE is not set
CONFIG_MFD_TIMBERDALE=m
CONFIG_LPC_SCH=m
CONFIG_MFD_RDC321X=m
CONFIG_MFD_JANZ_CMODIO=m
# CONFIG_MFD_TPS6586X is not set
CONFIG_MFD_VX855=m
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
CONFIG_REGULATOR_DUMMY=y
CONFIG_REGULATOR_FIXED_VOLTAGE=m
CONFIG_REGULATOR_VIRTUAL_CONSUMER=m
CONFIG_REGULATOR_USERSPACE_CONSUMER=m
CONFIG_REGULATOR_BQ24022=m
CONFIG_REGULATOR_MAX1586=m
CONFIG_REGULATOR_MAX8649=m
CONFIG_REGULATOR_MAX8660=m
CONFIG_REGULATOR_MAX8952=m
CONFIG_REGULATOR_WM831X=m
CONFIG_REGULATOR_WM8400=m
CONFIG_REGULATOR_PCF50633=m
CONFIG_REGULATOR_LP3971=m
CONFIG_REGULATOR_LP3972=m
CONFIG_REGULATOR_PCAP=m
CONFIG_REGULATOR_MC13783=m
CONFIG_REGULATOR_TPS65023=m
CONFIG_REGULATOR_TPS6507X=m
CONFIG_REGULATOR_ISL6271A=m
CONFIG_REGULATOR_AD5398=m
CONFIG_MEDIA_SUPPORT=m

#
# Multimedia core support
#
CONFIG_VIDEO_DEV=m
CONFIG_VIDEO_V4L2_COMMON=m
CONFIG_VIDEO_ALLOW_V4L1=y
CONFIG_VIDEO_V4L1_COMPAT=y
CONFIG_DVB_CORE=m
CONFIG_VIDEO_MEDIA=m

#
# Multimedia drivers
#
CONFIG_VIDEO_SAA7146=m
CONFIG_VIDEO_SAA7146_VV=m
CONFIG_IR_CORE=m
CONFIG_VIDEO_IR=m
CONFIG_LIRC=m
CONFIG_RC_MAP=m
CONFIG_IR_NEC_DECODER=m
CONFIG_IR_RC5_DECODER=m
CONFIG_IR_RC6_DECODER=m
CONFIG_IR_JVC_DECODER=m
CONFIG_IR_SONY_DECODER=m
CONFIG_IR_RC5_SZ_DECODER=m
CONFIG_IR_LIRC_CODEC=m
CONFIG_IR_ENE=m
CONFIG_IR_IMON=m
CONFIG_IR_MCEUSB=m
CONFIG_IR_NUVOTON=m
CONFIG_IR_STREAMZAP=m
CONFIG_MEDIA_ATTACH=y
CONFIG_MEDIA_TUNER=m
CONFIG_MEDIA_TUNER_CUSTOMISE=y
CONFIG_MEDIA_TUNER_SIMPLE=m
CONFIG_MEDIA_TUNER_TDA8290=m
CONFIG_MEDIA_TUNER_TDA827X=m
CONFIG_MEDIA_TUNER_TDA18271=m
CONFIG_MEDIA_TUNER_TDA9887=m
CONFIG_MEDIA_TUNER_TEA5761=m
CONFIG_MEDIA_TUNER_TEA5767=m
CONFIG_MEDIA_TUNER_MT20XX=m
CONFIG_MEDIA_TUNER_MT2060=m
CONFIG_MEDIA_TUNER_MT2266=m
CONFIG_MEDIA_TUNER_MT2131=m
CONFIG_MEDIA_TUNER_QT1010=m
CONFIG_MEDIA_TUNER_XC2028=m
CONFIG_MEDIA_TUNER_XC5000=m
CONFIG_MEDIA_TUNER_MXL5005S=m
CONFIG_MEDIA_TUNER_MXL5007T=m
CONFIG_MEDIA_TUNER_MC44S803=m
CONFIG_MEDIA_TUNER_MAX2165=m
CONFIG_MEDIA_TUNER_TDA18218=m
CONFIG_VIDEO_V4L2=m
CONFIG_VIDEO_V4L1=m
CONFIG_VIDEOBUF_GEN=m
CONFIG_VIDEOBUF_DMA_SG=m
CONFIG_VIDEOBUF_VMALLOC=m
CONFIG_VIDEOBUF_DVB=m
CONFIG_VIDEO_BTCX=m
CONFIG_VIDEO_TVEEPROM=m
CONFIG_VIDEO_TUNER=m
CONFIG_V4L2_MEM2MEM_DEV=m
CONFIG_VIDEO_CAPTURE_DRIVERS=y
CONFIG_VIDEO_ADV_DEBUG=y
CONFIG_VIDEO_FIXED_MINOR_RANGES=y
CONFIG_VIDEO_HELPER_CHIPS_AUTO=y
CONFIG_VIDEO_IR_I2C=m
CONFIG_VIDEO_TVAUDIO=m
CONFIG_VIDEO_TDA7432=m
CONFIG_VIDEO_TDA9840=m
CONFIG_VIDEO_TEA6415C=m
CONFIG_VIDEO_TEA6420=m
CONFIG_VIDEO_MSP3400=m
CONFIG_VIDEO_CS5345=m
CONFIG_VIDEO_CS53L32A=m
CONFIG_VIDEO_M52790=m
CONFIG_VIDEO_WM8775=m
CONFIG_VIDEO_WM8739=m
CONFIG_VIDEO_VP27SMPX=m
CONFIG_VIDEO_SAA6588=m
CONFIG_VIDEO_BT819=m
CONFIG_VIDEO_BT856=m
CONFIG_VIDEO_BT866=m
CONFIG_VIDEO_KS0127=m
CONFIG_VIDEO_OV7670=m
CONFIG_VIDEO_MT9V011=m
CONFIG_VIDEO_SAA7110=m
CONFIG_VIDEO_SAA711X=m
CONFIG_VIDEO_SAA717X=m
CONFIG_VIDEO_TVP5150=m
CONFIG_VIDEO_VPX3220=m
CONFIG_VIDEO_CX25840=m
CONFIG_VIDEO_CX2341X=m
CONFIG_VIDEO_SAA7127=m
CONFIG_VIDEO_SAA7185=m
CONFIG_VIDEO_ADV7170=m
CONFIG_VIDEO_ADV7175=m
CONFIG_VIDEO_UPD64031A=m
CONFIG_VIDEO_UPD64083=m
CONFIG_VIDEO_VIVI=m
CONFIG_VIDEO_BT848=m
CONFIG_VIDEO_BT848_DVB=y
CONFIG_VIDEO_BWQCAM=m
CONFIG_VIDEO_CQCAM=m
CONFIG_VIDEO_W9966=m
CONFIG_VIDEO_CPIA2=m
CONFIG_VIDEO_ZORAN=m
CONFIG_VIDEO_ZORAN_DC30=m
CONFIG_VIDEO_ZORAN_ZR36060=m
CONFIG_VIDEO_ZORAN_BUZ=m
CONFIG_VIDEO_ZORAN_DC10=m
CONFIG_VIDEO_ZORAN_LML33=m
CONFIG_VIDEO_ZORAN_LML33R10=m
CONFIG_VIDEO_ZORAN_AVS6EYES=m
CONFIG_VIDEO_MEYE=m
CONFIG_VIDEO_SAA7134=m
CONFIG_VIDEO_SAA7134_ALSA=m
CONFIG_VIDEO_SAA7134_RC=y
CONFIG_VIDEO_SAA7134_DVB=m
CONFIG_VIDEO_MXB=m
CONFIG_VIDEO_HEXIUM_ORION=m
CONFIG_VIDEO_HEXIUM_GEMINI=m
CONFIG_VIDEO_CX88=m
CONFIG_VIDEO_CX88_ALSA=m
CONFIG_VIDEO_CX88_BLACKBIRD=m
CONFIG_VIDEO_CX88_DVB=m
CONFIG_VIDEO_CX88_MPEG=m
CONFIG_VIDEO_CX88_VP3054=m
CONFIG_VIDEO_CX23885=m
CONFIG_VIDEO_AU0828=m
CONFIG_VIDEO_IVTV=m
CONFIG_VIDEO_FB_IVTV=m
CONFIG_VIDEO_CX18=m
CONFIG_VIDEO_CX18_ALSA=m
CONFIG_VIDEO_SAA7164=m
CONFIG_VIDEO_CAFE_CCIC=m
CONFIG_VIDEO_SR030PC30=m
CONFIG_VIDEO_VIA_CAMERA=m
CONFIG_SOC_CAMERA=m
CONFIG_SOC_CAMERA_IMX074=m
CONFIG_SOC_CAMERA_MT9M001=m
CONFIG_SOC_CAMERA_MT9M111=m
CONFIG_SOC_CAMERA_MT9T031=m
CONFIG_SOC_CAMERA_MT9T112=m
CONFIG_SOC_CAMERA_MT9V022=m
CONFIG_SOC_CAMERA_RJ54N1=m
CONFIG_SOC_CAMERA_TW9910=m
CONFIG_SOC_CAMERA_PLATFORM=m
CONFIG_SOC_CAMERA_OV6650=m
CONFIG_SOC_CAMERA_OV772X=m
CONFIG_SOC_CAMERA_OV9640=m
CONFIG_V4L_USB_DRIVERS=y
CONFIG_USB_VIDEO_CLASS=m
CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV=y
CONFIG_USB_GSPCA=m
CONFIG_USB_M5602=m
CONFIG_USB_STV06XX=m
CONFIG_USB_GL860=m
CONFIG_USB_GSPCA_BENQ=m
CONFIG_USB_GSPCA_CONEX=m
CONFIG_USB_GSPCA_CPIA1=m
CONFIG_USB_GSPCA_ETOMS=m
CONFIG_USB_GSPCA_FINEPIX=m
CONFIG_USB_GSPCA_JEILINJ=m
CONFIG_USB_GSPCA_KONICA=m
CONFIG_USB_GSPCA_MARS=m
CONFIG_USB_GSPCA_MR97310A=m
CONFIG_USB_GSPCA_OV519=m
CONFIG_USB_GSPCA_OV534=m
CONFIG_USB_GSPCA_OV534_9=m
CONFIG_USB_GSPCA_PAC207=m
CONFIG_USB_GSPCA_PAC7302=m
CONFIG_USB_GSPCA_PAC7311=m
CONFIG_USB_GSPCA_SN9C2028=m
CONFIG_USB_GSPCA_SN9C20X=m
CONFIG_USB_GSPCA_SONIXB=m
CONFIG_USB_GSPCA_SONIXJ=m
CONFIG_USB_GSPCA_SPCA500=m
CONFIG_USB_GSPCA_SPCA501=m
CONFIG_USB_GSPCA_SPCA505=m
CONFIG_USB_GSPCA_SPCA506=m
CONFIG_USB_GSPCA_SPCA508=m
CONFIG_USB_GSPCA_SPCA561=m
CONFIG_USB_GSPCA_SPCA1528=m
CONFIG_USB_GSPCA_SQ905=m
CONFIG_USB_GSPCA_SQ905C=m
CONFIG_USB_GSPCA_SQ930X=m
CONFIG_USB_GSPCA_STK014=m
CONFIG_USB_GSPCA_STV0680=m
CONFIG_USB_GSPCA_SUNPLUS=m
CONFIG_USB_GSPCA_T613=m
CONFIG_USB_GSPCA_TV8532=m
CONFIG_USB_GSPCA_VC032X=m
CONFIG_USB_GSPCA_XIRLINK_CIT=m
CONFIG_USB_GSPCA_ZC3XX=m
CONFIG_VIDEO_PVRUSB2=m
CONFIG_VIDEO_PVRUSB2_SYSFS=y
CONFIG_VIDEO_PVRUSB2_DVB=y
CONFIG_VIDEO_PVRUSB2_DEBUGIFC=y
CONFIG_VIDEO_HDPVR=m
CONFIG_VIDEO_EM28XX=m
CONFIG_VIDEO_EM28XX_ALSA=m
CONFIG_VIDEO_EM28XX_DVB=m
CONFIG_VIDEO_TLG2300=m
CONFIG_VIDEO_CX231XX=m
CONFIG_VIDEO_CX231XX_ALSA=m
CONFIG_VIDEO_CX231XX_DVB=m
CONFIG_VIDEO_USBVISION=m
CONFIG_VIDEO_USBVIDEO=m
CONFIG_USB_VICAM=m
CONFIG_USB_IBMCAM=m
CONFIG_USB_KONICAWC=m
CONFIG_USB_ET61X251=m
CONFIG_USB_SE401=m
CONFIG_USB_SN9C102=m
CONFIG_USB_PWC=m
CONFIG_USB_PWC_DEBUG=y
CONFIG_USB_PWC_INPUT_EVDEV=y
CONFIG_USB_ZR364XX=m
CONFIG_USB_STKWEBCAM=m
CONFIG_USB_S2255=m
CONFIG_V4L_MEM2MEM_DRIVERS=y
CONFIG_VIDEO_MEM2MEM_TESTDEV=m
CONFIG_RADIO_ADAPTERS=y
CONFIG_RADIO_GEMTEK_PCI=m
CONFIG_RADIO_MAXIRADIO=m
CONFIG_RADIO_MAESTRO=m
CONFIG_I2C_SI4713=m
CONFIG_RADIO_SI4713=m
CONFIG_USB_DSBR=m
CONFIG_RADIO_SI470X=y
CONFIG_USB_SI470X=m
CONFIG_I2C_SI470X=m
CONFIG_USB_MR800=m
CONFIG_RADIO_TEA5764=m
CONFIG_RADIO_SAA7706H=m
CONFIG_RADIO_TEF6862=m
CONFIG_RADIO_TIMBERDALE=m
CONFIG_DVB_MAX_ADAPTERS=8
CONFIG_DVB_DYNAMIC_MINORS=y
CONFIG_DVB_CAPTURE_DRIVERS=y

#
# Supported SAA7146 based PCI Adapters
#
CONFIG_TTPCI_EEPROM=m
CONFIG_DVB_AV7110=m
CONFIG_DVB_AV7110_OSD=y
CONFIG_DVB_BUDGET_CORE=m
CONFIG_DVB_BUDGET=m
CONFIG_DVB_BUDGET_CI=m
CONFIG_DVB_BUDGET_AV=m
CONFIG_DVB_BUDGET_PATCH=m

#
# Supported USB Adapters
#
CONFIG_DVB_USB=m
# CONFIG_DVB_USB_DEBUG is not set
CONFIG_DVB_USB_A800=m
CONFIG_DVB_USB_DIBUSB_MB=m
CONFIG_DVB_USB_DIBUSB_MB_FAULTY=y
CONFIG_DVB_USB_DIBUSB_MC=m
CONFIG_DVB_USB_DIB0700=m
CONFIG_DVB_USB_UMT_010=m
CONFIG_DVB_USB_CXUSB=m
CONFIG_DVB_USB_M920X=m
CONFIG_DVB_USB_GL861=m
CONFIG_DVB_USB_AU6610=m
CONFIG_DVB_USB_DIGITV=m
CONFIG_DVB_USB_VP7045=m
CONFIG_DVB_USB_VP702X=m
CONFIG_DVB_USB_GP8PSK=m
CONFIG_DVB_USB_NOVA_T_USB2=m
CONFIG_DVB_USB_TTUSB2=m
CONFIG_DVB_USB_DTT200U=m
CONFIG_DVB_USB_OPERA1=m
CONFIG_DVB_USB_AF9005=m
CONFIG_DVB_USB_AF9005_REMOTE=m
CONFIG_DVB_USB_DW2102=m
CONFIG_DVB_USB_CINERGY_T2=m
CONFIG_DVB_USB_ANYSEE=m
CONFIG_DVB_USB_DTV5100=m
CONFIG_DVB_USB_AF9015=m
CONFIG_DVB_USB_CE6230=m
CONFIG_DVB_USB_FRIIO=m
CONFIG_DVB_USB_EC168=m
CONFIG_DVB_USB_AZ6027=m
CONFIG_DVB_USB_LME2510=m
CONFIG_DVB_TTUSB_BUDGET=m
CONFIG_DVB_TTUSB_DEC=m
CONFIG_SMS_SIANO_MDTV=m

#
# Siano module components
#
CONFIG_SMS_USB_DRV=m
CONFIG_SMS_SDIO_DRV=m

#
# Supported FlexCopII (B2C2) Adapters
#
CONFIG_DVB_B2C2_FLEXCOP=m
CONFIG_DVB_B2C2_FLEXCOP_PCI=m
CONFIG_DVB_B2C2_FLEXCOP_USB=m
CONFIG_DVB_B2C2_FLEXCOP_DEBUG=y

#
# Supported BT878 Adapters
#
CONFIG_DVB_BT8XX=m

#
# Supported Pluto2 Adapters
#
CONFIG_DVB_PLUTO2=m

#
# Supported SDMC DM1105 Adapters
#
CONFIG_DVB_DM1105=m
CONFIG_DVB_FIREDTV=m
CONFIG_DVB_FIREDTV_FIREWIRE=y
# CONFIG_DVB_FIREDTV_IEEE1394 is not set
CONFIG_DVB_FIREDTV_INPUT=y

#
# Supported Earthsoft PT1 Adapters
#
CONFIG_DVB_PT1=m

#
# Supported Mantis Adapters
#
CONFIG_MANTIS_CORE=m
CONFIG_DVB_MANTIS=m
CONFIG_DVB_HOPPER=m

#
# Supported nGene Adapters
#
CONFIG_DVB_NGENE=m

#
# Supported DVB Frontends
#
CONFIG_DVB_FE_CUSTOMISE=y

#
# Customise DVB Frontends
#

#
# Multistandard (satellite) frontends
#
CONFIG_DVB_STB0899=m
CONFIG_DVB_STB6100=m
CONFIG_DVB_STV090x=m
CONFIG_DVB_STV6110x=m

#
# DVB-S (satellite) frontends
#
CONFIG_DVB_CX24110=m
CONFIG_DVB_CX24123=m
CONFIG_DVB_MT312=m
CONFIG_DVB_ZL10036=m
CONFIG_DVB_ZL10039=m
CONFIG_DVB_S5H1420=m
CONFIG_DVB_STV0288=m
CONFIG_DVB_STB6000=m
CONFIG_DVB_STV0299=m
CONFIG_DVB_STV6110=m
CONFIG_DVB_STV0900=m
CONFIG_DVB_TDA8083=m
CONFIG_DVB_TDA10086=m
CONFIG_DVB_TDA8261=m
CONFIG_DVB_VES1X93=m
CONFIG_DVB_TUNER_ITD1000=m
CONFIG_DVB_TUNER_CX24113=m
CONFIG_DVB_TDA826X=m
CONFIG_DVB_TUA6100=m
CONFIG_DVB_CX24116=m
CONFIG_DVB_SI21XX=m
CONFIG_DVB_DS3000=m
CONFIG_DVB_MB86A16=m

#
# DVB-T (terrestrial) frontends
#
CONFIG_DVB_SP8870=m
CONFIG_DVB_SP887X=m
CONFIG_DVB_CX22700=m
CONFIG_DVB_CX22702=m
CONFIG_DVB_S5H1432=m
CONFIG_DVB_DRX397XD=m
CONFIG_DVB_L64781=m
CONFIG_DVB_TDA1004X=m
CONFIG_DVB_NXT6000=m
CONFIG_DVB_MT352=m
CONFIG_DVB_ZL10353=m
CONFIG_DVB_DIB3000MB=m
CONFIG_DVB_DIB3000MC=m
CONFIG_DVB_DIB7000M=m
CONFIG_DVB_DIB7000P=m
CONFIG_DVB_TDA10048=m
CONFIG_DVB_AF9013=m
CONFIG_DVB_EC100=m

#
# DVB-C (cable) frontends
#
CONFIG_DVB_VES1820=m
CONFIG_DVB_TDA10021=m
CONFIG_DVB_TDA10023=m
CONFIG_DVB_STV0297=m

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
CONFIG_DVB_NXT200X=m
CONFIG_DVB_OR51211=m
CONFIG_DVB_OR51132=m
CONFIG_DVB_BCM3510=m
CONFIG_DVB_LGDT330X=m
CONFIG_DVB_LGDT3305=m
CONFIG_DVB_S5H1409=m
CONFIG_DVB_AU8522=m
CONFIG_DVB_S5H1411=m

#
# ISDB-T (terrestrial) frontends
#
CONFIG_DVB_S921=m
CONFIG_DVB_DIB8000=m

#
# Digital terrestrial only tuners/PLL
#
CONFIG_DVB_PLL=m
CONFIG_DVB_TUNER_DIB0070=m
CONFIG_DVB_TUNER_DIB0090=m

#
# SEC control devices for DVB-S
#
CONFIG_DVB_LNBP21=m
CONFIG_DVB_ISL6405=m
CONFIG_DVB_ISL6421=m
CONFIG_DVB_ISL6423=m
CONFIG_DVB_LGS8GL5=m
CONFIG_DVB_LGS8GXX=m
CONFIG_DVB_ATBM8830=m
CONFIG_DVB_TDA665x=m
CONFIG_DVB_IX2505V=m

#
# Tools to develop new frontends
#
CONFIG_DVB_DUMMY_FE=m
CONFIG_DAB=y
CONFIG_USB_DABUSB=m

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=m
CONFIG_AGP_INTEL=m
CONFIG_AGP_SIS=m
CONFIG_AGP_VIA=m
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
CONFIG_VGA_SWITCHEROO=y
CONFIG_DRM=y
CONFIG_DRM_KMS_HELPER=m
CONFIG_DRM_TTM=m
CONFIG_DRM_TDFX=m
CONFIG_DRM_R128=m
CONFIG_DRM_RADEON=m
CONFIG_DRM_RADEON_KMS=y
CONFIG_DRM_I810=m
CONFIG_DRM_I830=m
CONFIG_DRM_I915=m
CONFIG_DRM_I915_KMS=y
CONFIG_DRM_MGA=m
CONFIG_DRM_SIS=m
CONFIG_DRM_VIA=m
CONFIG_DRM_SAVAGE=m
CONFIG_STUB_POULSBO=m
CONFIG_VGASTATE=m
CONFIG_VIDEO_OUTPUT_CONTROL=m
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
CONFIG_FB_DDC=m
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=m
CONFIG_FB_SYS_COPYAREA=m
CONFIG_FB_SYS_IMAGEBLIT=m
CONFIG_FB_FOREIGN_ENDIAN=y
CONFIG_FB_BOTH_ENDIAN=y
# CONFIG_FB_BIG_ENDIAN is not set
# CONFIG_FB_LITTLE_ENDIAN is not set
CONFIG_FB_SYS_FOPS=m
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_HECUBA=m
CONFIG_FB_SVGALIB=m
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
CONFIG_FB_CIRRUS=m
CONFIG_FB_PM2=m
CONFIG_FB_PM2_FIFO_DISCONNECT=y
CONFIG_FB_CYBER2000=m
CONFIG_FB_ARC=m
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
CONFIG_FB_VGA16=m
CONFIG_FB_UVESA=m
CONFIG_FB_VESA=y
# CONFIG_FB_EFI is not set
CONFIG_FB_N411=m
CONFIG_FB_HGA=m
CONFIG_FB_HGA_ACCEL=y
CONFIG_FB_S1D13XXX=m
CONFIG_FB_NVIDIA=m
CONFIG_FB_NVIDIA_I2C=y
CONFIG_FB_NVIDIA_DEBUG=y
CONFIG_FB_NVIDIA_BACKLIGHT=y
CONFIG_FB_RIVA=m
CONFIG_FB_RIVA_I2C=y
CONFIG_FB_RIVA_DEBUG=y
CONFIG_FB_RIVA_BACKLIGHT=y
CONFIG_FB_LE80578=m
CONFIG_FB_CARILLO_RANCH=m
CONFIG_FB_INTEL=m
CONFIG_FB_INTEL_DEBUG=y
CONFIG_FB_INTEL_I2C=y
CONFIG_FB_MATROX=m
CONFIG_FB_MATROX_MILLENIUM=y
CONFIG_FB_MATROX_MYSTIQUE=y
CONFIG_FB_MATROX_G=y
CONFIG_FB_MATROX_I2C=m
CONFIG_FB_MATROX_MAVEN=m
CONFIG_FB_RADEON=m
CONFIG_FB_RADEON_I2C=y
CONFIG_FB_RADEON_BACKLIGHT=y
CONFIG_FB_RADEON_DEBUG=y
CONFIG_FB_ATY128=m
CONFIG_FB_ATY128_BACKLIGHT=y
CONFIG_FB_ATY=m
CONFIG_FB_ATY_CT=y
CONFIG_FB_ATY_GENERIC_LCD=y
CONFIG_FB_ATY_GX=y
CONFIG_FB_ATY_BACKLIGHT=y
CONFIG_FB_S3=m
CONFIG_FB_SAVAGE=m
CONFIG_FB_SAVAGE_I2C=y
CONFIG_FB_SAVAGE_ACCEL=y
CONFIG_FB_SIS=m
CONFIG_FB_SIS_300=y
CONFIG_FB_SIS_315=y
CONFIG_FB_VIA=m
CONFIG_FB_VIA_DIRECT_PROCFS=y
CONFIG_FB_NEOMAGIC=m
CONFIG_FB_KYRO=m
CONFIG_FB_3DFX=m
CONFIG_FB_3DFX_ACCEL=y
CONFIG_FB_3DFX_I2C=y
CONFIG_FB_VOODOO1=m
CONFIG_FB_VT8623=m
CONFIG_FB_TRIDENT=m
CONFIG_FB_ARK=m
CONFIG_FB_PM3=m
CONFIG_FB_CARMINE=m
CONFIG_FB_CARMINE_DRAM_EVAL=y
# CONFIG_CARMINE_DRAM_CUSTOM is not set
CONFIG_FB_GEODE=y
CONFIG_FB_GEODE_LX=m
CONFIG_FB_GEODE_GX=m
CONFIG_FB_GEODE_GX1=m
CONFIG_FB_TMIO=m
CONFIG_FB_TMIO_ACCELL=y
CONFIG_FB_SM501=m
CONFIG_FB_VIRTUAL=m
CONFIG_XEN_FBDEV_FRONTEND=m
CONFIG_FB_METRONOME=m
CONFIG_FB_MB862XX=m
CONFIG_FB_MB862XX_PCI_GDC=y
CONFIG_FB_BROADSHEET=m
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
CONFIG_LCD_L4F00242T03=m
CONFIG_LCD_LMS283GF05=m
CONFIG_LCD_LTV350QV=m
CONFIG_LCD_ILI9320=m
CONFIG_LCD_TDO24M=m
CONFIG_LCD_VGG2432A4=m
CONFIG_LCD_PLATFORM=m
CONFIG_LCD_S6E63M0=m
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=m
CONFIG_BACKLIGHT_PROGEAR=m
CONFIG_BACKLIGHT_CARILLO_RANCH=m
CONFIG_BACKLIGHT_MBP_NVIDIA=m
CONFIG_BACKLIGHT_SAHARA=m
CONFIG_BACKLIGHT_WM831X=m
CONFIG_BACKLIGHT_ADP8860=m
CONFIG_BACKLIGHT_PCF50633=m

#
# Display device support
#
CONFIG_DISPLAY_SUPPORT=m

#
# Display hardware drivers
#

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
CONFIG_FONTS=y
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
CONFIG_FONT_6x11=y
CONFIG_FONT_7x14=y
CONFIG_FONT_PEARL_8x8=y
CONFIG_FONT_ACORN_8x8=y
CONFIG_FONT_MINI_4x6=y
CONFIG_FONT_SUN8x16=y
CONFIG_FONT_SUN12x22=y
CONFIG_FONT_10x18=y
CONFIG_LOGO=y
CONFIG_LOGO_LINUX_MONO=y
CONFIG_LOGO_LINUX_VGA16=y
CONFIG_LOGO_LINUX_CLUT224=y
CONFIG_SOUND=m
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_HWDEP=m
CONFIG_SND_RAWMIDI=m
CONFIG_SND_JACK=y
CONFIG_SND_SEQUENCER=m
CONFIG_SND_SEQ_DUMMY=m
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=m
CONFIG_SND_PCM_OSS=m
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_SEQUENCER_OSS=y
CONFIG_SND_HRTIMER=m
CONFIG_SND_SEQ_HRTIMER_DEFAULT=y
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_SUPPORT_OLD_API=y
CONFIG_SND_VERBOSE_PROCFS=y
CONFIG_SND_VERBOSE_PRINTK=y
CONFIG_SND_DEBUG=y
CONFIG_SND_DEBUG_VERBOSE=y
CONFIG_SND_PCM_XRUN_DEBUG=y
CONFIG_SND_VMASTER=y
CONFIG_SND_DMA_SGBUF=y
CONFIG_SND_RAWMIDI_SEQ=m
CONFIG_SND_OPL3_LIB_SEQ=m
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
CONFIG_SND_EMU10K1_SEQ=m
CONFIG_SND_MPU401_UART=m
CONFIG_SND_OPL3_LIB=m
CONFIG_SND_VX_LIB=m
CONFIG_SND_AC97_CODEC=m
CONFIG_SND_DRIVERS=y
CONFIG_SND_PCSP=m
CONFIG_SND_DUMMY=m
CONFIG_SND_ALOOP=m
CONFIG_SND_VIRMIDI=m
CONFIG_SND_MTPAV=m
CONFIG_SND_MTS64=m
CONFIG_SND_SERIAL_U16550=m
CONFIG_SND_MPU401=m
CONFIG_SND_PORTMAN2X4=m
CONFIG_SND_AC97_POWER_SAVE=y
CONFIG_SND_AC97_POWER_SAVE_DEFAULT=0
CONFIG_SND_SB_COMMON=m
CONFIG_SND_SB16_DSP=m
CONFIG_SND_PCI=y
CONFIG_SND_AD1889=m
CONFIG_SND_ALS300=m
CONFIG_SND_ALS4000=m
CONFIG_SND_ALI5451=m
CONFIG_SND_ASIHPI=m
CONFIG_SND_ATIIXP=m
CONFIG_SND_ATIIXP_MODEM=m
CONFIG_SND_AU8810=m
CONFIG_SND_AU8820=m
CONFIG_SND_AU8830=m
CONFIG_SND_AW2=m
CONFIG_SND_AZT3328=m
CONFIG_SND_BT87X=m
CONFIG_SND_BT87X_OVERCLOCK=y
CONFIG_SND_CA0106=m
CONFIG_SND_CMIPCI=m
CONFIG_SND_OXYGEN_LIB=m
CONFIG_SND_OXYGEN=m
CONFIG_SND_CS4281=m
CONFIG_SND_CS46XX=m
CONFIG_SND_CS46XX_NEW_DSP=y
CONFIG_SND_CS5530=m
CONFIG_SND_CS5535AUDIO=m
CONFIG_SND_CTXFI=m
CONFIG_SND_DARLA20=m
CONFIG_SND_GINA20=m
CONFIG_SND_LAYLA20=m
CONFIG_SND_DARLA24=m
CONFIG_SND_GINA24=m
CONFIG_SND_LAYLA24=m
CONFIG_SND_MONA=m
CONFIG_SND_MIA=m
CONFIG_SND_ECHO3G=m
CONFIG_SND_INDIGO=m
CONFIG_SND_INDIGOIO=m
CONFIG_SND_INDIGODJ=m
CONFIG_SND_INDIGOIOX=m
CONFIG_SND_INDIGODJX=m
CONFIG_SND_EMU10K1=m
CONFIG_SND_EMU10K1X=m
CONFIG_SND_ENS1370=m
CONFIG_SND_ENS1371=m
CONFIG_SND_ES1938=m
CONFIG_SND_ES1968=m
CONFIG_SND_ES1968_INPUT=y
CONFIG_SND_FM801=m
CONFIG_SND_FM801_TEA575X_BOOL=y
CONFIG_SND_FM801_TEA575X=m
CONFIG_SND_HDA_INTEL=m
CONFIG_SND_HDA_HWDEP=y
CONFIG_SND_HDA_RECONFIG=y
CONFIG_SND_HDA_INPUT_BEEP=y
CONFIG_SND_HDA_INPUT_BEEP_MODE=1
CONFIG_SND_HDA_INPUT_JACK=y
CONFIG_SND_HDA_PATCH_LOADER=y
CONFIG_SND_HDA_CODEC_REALTEK=y
CONFIG_SND_HDA_CODEC_ANALOG=y
CONFIG_SND_HDA_CODEC_SIGMATEL=y
CONFIG_SND_HDA_CODEC_VIA=y
CONFIG_SND_HDA_CODEC_HDMI=y
CONFIG_SND_HDA_CODEC_CIRRUS=y
CONFIG_SND_HDA_CODEC_CONEXANT=y
CONFIG_SND_HDA_CODEC_CA0110=y
CONFIG_SND_HDA_CODEC_CMEDIA=y
CONFIG_SND_HDA_CODEC_SI3054=y
CONFIG_SND_HDA_GENERIC=y
CONFIG_SND_HDA_POWER_SAVE=y
CONFIG_SND_HDA_POWER_SAVE_DEFAULT=0
CONFIG_SND_HDSP=m
CONFIG_SND_HDSPM=m
CONFIG_SND_HIFIER=m
CONFIG_SND_ICE1712=m
CONFIG_SND_ICE1724=m
CONFIG_SND_INTEL8X0=m
CONFIG_SND_INTEL8X0M=m
CONFIG_SND_KORG1212=m
CONFIG_SND_LX6464ES=m
CONFIG_SND_MAESTRO3=m
CONFIG_SND_MAESTRO3_INPUT=y
CONFIG_SND_MIXART=m
CONFIG_SND_NM256=m
CONFIG_SND_PCXHR=m
CONFIG_SND_RIPTIDE=m
CONFIG_SND_RME32=m
CONFIG_SND_RME96=m
CONFIG_SND_RME9652=m
CONFIG_SND_SONICVIBES=m
CONFIG_SND_TRIDENT=m
CONFIG_SND_VIA82XX=m
CONFIG_SND_VIA82XX_MODEM=m
CONFIG_SND_VIRTUOSO=m
CONFIG_SND_VX222=m
CONFIG_SND_YMFPCI=m
CONFIG_SND_SPI=y
CONFIG_SND_USB=y
CONFIG_SND_USB_AUDIO=m
CONFIG_SND_USB_UA101=m
CONFIG_SND_USB_USX2Y=m
CONFIG_SND_USB_CAIAQ=m
CONFIG_SND_USB_CAIAQ_INPUT=y
CONFIG_SND_USB_US122L=m
CONFIG_SND_PCMCIA=y
CONFIG_SND_VXPOCKET=m
CONFIG_SND_PDAUDIOCF=m
CONFIG_SND_SOC=m
CONFIG_SND_SOC_I2C_AND_SPI=m
CONFIG_SND_SOC_ALL_CODECS=m
CONFIG_SND_SOC_WM_HUBS=m
CONFIG_SND_SOC_AD1836=m
CONFIG_SND_SOC_AD193X=m
CONFIG_SND_SOC_AD73311=m
CONFIG_SND_SOC_ADS117X=m
CONFIG_SND_SOC_AK4104=m
CONFIG_SND_SOC_AK4535=m
CONFIG_SND_SOC_AK4642=m
CONFIG_SND_SOC_AK4671=m
CONFIG_SND_SOC_CS42L51=m
CONFIG_SND_SOC_CS4270=m
CONFIG_SND_SOC_L3=m
CONFIG_SND_SOC_DA7210=m
CONFIG_SND_SOC_MAX98088=m
CONFIG_SND_SOC_PCM3008=m
CONFIG_SND_SOC_SPDIF=m
CONFIG_SND_SOC_SSM2602=m
CONFIG_SND_SOC_TLV320AIC23=m
CONFIG_SND_SOC_TLV320AIC26=m
CONFIG_SND_SOC_TLV320AIC3X=m
CONFIG_SND_SOC_TLV320DAC33=m
CONFIG_SND_SOC_UDA134X=m
CONFIG_SND_SOC_UDA1380=m
CONFIG_SND_SOC_WM8400=m
CONFIG_SND_SOC_WM8510=m
CONFIG_SND_SOC_WM8523=m
CONFIG_SND_SOC_WM8580=m
CONFIG_SND_SOC_WM8711=m
CONFIG_SND_SOC_WM8727=m
CONFIG_SND_SOC_WM8728=m
CONFIG_SND_SOC_WM8731=m
CONFIG_SND_SOC_WM8741=m
CONFIG_SND_SOC_WM8750=m
CONFIG_SND_SOC_WM8753=m
CONFIG_SND_SOC_WM8776=m
CONFIG_SND_SOC_WM8804=m
CONFIG_SND_SOC_WM8900=m
CONFIG_SND_SOC_WM8903=m
CONFIG_SND_SOC_WM8904=m
CONFIG_SND_SOC_WM8940=m
CONFIG_SND_SOC_WM8955=m
CONFIG_SND_SOC_WM8960=m
CONFIG_SND_SOC_WM8961=m
CONFIG_SND_SOC_WM8962=m
CONFIG_SND_SOC_WM8971=m
CONFIG_SND_SOC_WM8974=m
CONFIG_SND_SOC_WM8978=m
CONFIG_SND_SOC_WM8985=m
CONFIG_SND_SOC_WM8988=m
CONFIG_SND_SOC_WM8990=m
CONFIG_SND_SOC_WM8993=m
CONFIG_SND_SOC_WM9081=m
CONFIG_SND_SOC_MAX9877=m
CONFIG_SND_SOC_TPA6130A2=m
CONFIG_SND_SOC_WM2000=m
CONFIG_SND_SOC_WM9090=m
CONFIG_SOUND_PRIME=m
CONFIG_SOUND_OSS=m
CONFIG_SOUND_TRACEINIT=y
CONFIG_SOUND_DMAP=y
CONFIG_SOUND_VMIDI=m
CONFIG_SOUND_TRIX=m
CONFIG_SOUND_MSS=m
CONFIG_SOUND_MPU401=m
CONFIG_SOUND_PAS=m
CONFIG_SOUND_PSS=m
CONFIG_PSS_MIXER=y
CONFIG_SOUND_SB=m
CONFIG_SOUND_YM3812=m
CONFIG_SOUND_UART6850=m
CONFIG_SOUND_AEDSP16=m
CONFIG_SC6600=y
CONFIG_SC6600_JOY=y
CONFIG_SC6600_CDROM=4
CONFIG_SC6600_CDROMBASE=0
CONFIG_SOUND_KAHLUA=m
CONFIG_AC97_BUS=m
CONFIG_HID_SUPPORT=y
CONFIG_HID=m
CONFIG_HIDRAW=y

#
# USB Input Devices
#
CONFIG_USB_HID=m
CONFIG_HID_PID=y
CONFIG_USB_HIDDEV=y

#
# USB HID Boot Protocol drivers
#
CONFIG_USB_KBD=m
CONFIG_USB_MOUSE=m

#
# Special HID drivers
#
CONFIG_HID_3M_PCT=m
CONFIG_HID_A4TECH=m
CONFIG_HID_ACRUX_FF=m
CONFIG_HID_APPLE=m
CONFIG_HID_BELKIN=m
CONFIG_HID_CANDO=m
CONFIG_HID_CHERRY=m
CONFIG_HID_CHICONY=m
CONFIG_HID_PRODIKEYS=m
CONFIG_HID_CYPRESS=m
CONFIG_HID_DRAGONRISE=m
CONFIG_DRAGONRISE_FF=y
CONFIG_HID_EGALAX=m
CONFIG_HID_ELECOM=m
CONFIG_HID_EZKEY=m
CONFIG_HID_KYE=m
CONFIG_HID_UCLOGIC=m
CONFIG_HID_WALTOP=m
CONFIG_HID_GYRATION=m
CONFIG_HID_TWINHAN=m
CONFIG_HID_KENSINGTON=m
CONFIG_HID_LOGITECH=m
CONFIG_LOGITECH_FF=y
CONFIG_LOGIRUMBLEPAD2_FF=y
CONFIG_LOGIG940_FF=y
CONFIG_LOGIWII_FF=y
CONFIG_HID_MAGICMOUSE=m
CONFIG_HID_MICROSOFT=m
CONFIG_HID_MOSART=m
CONFIG_HID_MONTEREY=m
CONFIG_HID_NTRIG=m
CONFIG_HID_ORTEK=m
CONFIG_HID_PANTHERLORD=m
CONFIG_PANTHERLORD_FF=y
CONFIG_HID_PETALYNX=m
CONFIG_HID_PICOLCD=m
CONFIG_HID_PICOLCD_FB=y
CONFIG_HID_PICOLCD_BACKLIGHT=y
CONFIG_HID_PICOLCD_LCD=y
CONFIG_HID_PICOLCD_LEDS=y
CONFIG_HID_QUANTA=m
CONFIG_HID_ROCCAT=m
CONFIG_HID_ROCCAT_KONE=m
CONFIG_HID_ROCCAT_PYRA=m
CONFIG_HID_SAMSUNG=m
CONFIG_HID_SONY=m
CONFIG_HID_STANTUM=m
CONFIG_HID_SUNPLUS=m
CONFIG_HID_GREENASIA=m
CONFIG_GREENASIA_FF=y
CONFIG_HID_SMARTJOYPLUS=m
CONFIG_SMARTJOYPLUS_FF=y
CONFIG_HID_TOPSEED=m
CONFIG_HID_THRUSTMASTER=m
CONFIG_THRUSTMASTER_FF=y
CONFIG_HID_WACOM=m
CONFIG_HID_WACOM_POWER_SUPPLY=y
CONFIG_HID_ZEROPLUS=m
CONFIG_ZEROPLUS_FF=y
CONFIG_HID_ZYDACRON=m
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=m
CONFIG_USB_DEBUG=y
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
CONFIG_USB_DEVICE_CLASS=y
CONFIG_USB_DYNAMIC_MINORS=y
# CONFIG_USB_OTG_WHITELIST is not set
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
CONFIG_USB_MON=m
CONFIG_USB_WUSB=m
CONFIG_USB_WUSB_CBAF=m
CONFIG_USB_WUSB_CBAF_DEBUG=y

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=m
CONFIG_USB_XHCI_HCD=m
CONFIG_USB_XHCI_HCD_DEBUGGING=y
CONFIG_USB_EHCI_HCD=m
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_OXU210HP_HCD=m
CONFIG_USB_ISP116X_HCD=m
CONFIG_USB_ISP1760_HCD=m
CONFIG_USB_ISP1362_HCD=m
CONFIG_USB_OHCI_HCD=m
CONFIG_USB_OHCI_HCD_SSB=y
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=m
CONFIG_USB_U132_HCD=m
CONFIG_USB_SL811_HCD=m
CONFIG_USB_SL811_CS=m
CONFIG_USB_R8A66597_HCD=m
CONFIG_USB_WHCI_HCD=m
CONFIG_USB_HWA_HCD=m

#
# USB Device Class drivers
#
CONFIG_USB_ACM=m
CONFIG_USB_PRINTER=m
CONFIG_USB_WDM=m
CONFIG_USB_TMC=m

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=m
CONFIG_USB_STORAGE_DEBUG=y
CONFIG_USB_STORAGE_DATAFAB=m
CONFIG_USB_STORAGE_FREECOM=m
CONFIG_USB_STORAGE_ISD200=m
CONFIG_USB_STORAGE_USBAT=m
CONFIG_USB_STORAGE_SDDR09=m
CONFIG_USB_STORAGE_SDDR55=m
CONFIG_USB_STORAGE_JUMPSHOT=m
CONFIG_USB_STORAGE_ALAUDA=m
CONFIG_USB_STORAGE_ONETOUCH=m
CONFIG_USB_STORAGE_KARMA=m
CONFIG_USB_STORAGE_CYPRESS_ATACB=m
CONFIG_USB_UAS=m
CONFIG_USB_LIBUSUAL=y

#
# USB Imaging devices
#
CONFIG_USB_MDC800=m
CONFIG_USB_MICROTEK=m

#
# USB port drivers
#
CONFIG_USB_USS720=m
CONFIG_USB_SERIAL=m
CONFIG_USB_EZUSB=y
CONFIG_USB_SERIAL_GENERIC=y
CONFIG_USB_SERIAL_AIRCABLE=m
CONFIG_USB_SERIAL_ARK3116=m
CONFIG_USB_SERIAL_BELKIN=m
CONFIG_USB_SERIAL_CH341=m
CONFIG_USB_SERIAL_WHITEHEAT=m
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=m
CONFIG_USB_SERIAL_CP210X=m
CONFIG_USB_SERIAL_CYPRESS_M8=m
CONFIG_USB_SERIAL_EMPEG=m
CONFIG_USB_SERIAL_FTDI_SIO=m
CONFIG_USB_SERIAL_FUNSOFT=m
CONFIG_USB_SERIAL_VISOR=m
CONFIG_USB_SERIAL_IPAQ=m
CONFIG_USB_SERIAL_IR=m
CONFIG_USB_SERIAL_EDGEPORT=m
CONFIG_USB_SERIAL_EDGEPORT_TI=m
CONFIG_USB_SERIAL_GARMIN=m
CONFIG_USB_SERIAL_IPW=m
CONFIG_USB_SERIAL_IUU=m
CONFIG_USB_SERIAL_KEYSPAN_PDA=m
CONFIG_USB_SERIAL_KEYSPAN=m
CONFIG_USB_SERIAL_KEYSPAN_MPR=y
CONFIG_USB_SERIAL_KEYSPAN_USA28=y
CONFIG_USB_SERIAL_KEYSPAN_USA28X=y
CONFIG_USB_SERIAL_KEYSPAN_USA28XA=y
CONFIG_USB_SERIAL_KEYSPAN_USA28XB=y
CONFIG_USB_SERIAL_KEYSPAN_USA19=y
CONFIG_USB_SERIAL_KEYSPAN_USA18X=y
CONFIG_USB_SERIAL_KEYSPAN_USA19W=y
CONFIG_USB_SERIAL_KEYSPAN_USA19QW=y
CONFIG_USB_SERIAL_KEYSPAN_USA19QI=y
CONFIG_USB_SERIAL_KEYSPAN_USA49W=y
CONFIG_USB_SERIAL_KEYSPAN_USA49WLC=y
CONFIG_USB_SERIAL_KLSI=m
CONFIG_USB_SERIAL_KOBIL_SCT=m
CONFIG_USB_SERIAL_MCT_U232=m
CONFIG_USB_SERIAL_MOS7720=m
CONFIG_USB_SERIAL_MOS7715_PARPORT=y
CONFIG_USB_SERIAL_MOS7840=m
CONFIG_USB_SERIAL_MOTOROLA=m
CONFIG_USB_SERIAL_NAVMAN=m
CONFIG_USB_SERIAL_PL2303=m
CONFIG_USB_SERIAL_OTI6858=m
CONFIG_USB_SERIAL_QCAUX=m
CONFIG_USB_SERIAL_QUALCOMM=m
CONFIG_USB_SERIAL_SPCP8X5=m
CONFIG_USB_SERIAL_HP4X=m
CONFIG_USB_SERIAL_SAFE=m
CONFIG_USB_SERIAL_SAFE_PADDED=y
CONFIG_USB_SERIAL_SAMBA=m
CONFIG_USB_SERIAL_SIEMENS_MPI=m
CONFIG_USB_SERIAL_SIERRAWIRELESS=m
CONFIG_USB_SERIAL_SYMBOL=m
CONFIG_USB_SERIAL_TI=m
CONFIG_USB_SERIAL_CYBERJACK=m
CONFIG_USB_SERIAL_XIRCOM=m
CONFIG_USB_SERIAL_WWAN=m
CONFIG_USB_SERIAL_OPTION=m
CONFIG_USB_SERIAL_OMNINET=m
CONFIG_USB_SERIAL_OPTICON=m
CONFIG_USB_SERIAL_VIVOPAY_SERIAL=m
CONFIG_USB_SERIAL_ZIO=m
CONFIG_USB_SERIAL_SSU100=m
CONFIG_USB_SERIAL_DEBUG=m

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=m
CONFIG_USB_EMI26=m
CONFIG_USB_ADUTUX=m
CONFIG_USB_SEVSEG=m
CONFIG_USB_RIO500=m
CONFIG_USB_LEGOTOWER=m
CONFIG_USB_LCD=m
CONFIG_USB_LED=m
CONFIG_USB_CYPRESS_CY7C63=m
CONFIG_USB_CYTHERM=m
CONFIG_USB_IDMOUSE=m
CONFIG_USB_FTDI_ELAN=m
CONFIG_USB_APPLEDISPLAY=m
CONFIG_USB_SISUSBVGA=m
CONFIG_USB_SISUSBVGA_CON=y
CONFIG_USB_LD=m
CONFIG_USB_TRANCEVIBRATOR=m
CONFIG_USB_IOWARRIOR=m
CONFIG_USB_TEST=m
CONFIG_USB_ISIGHTFW=m
CONFIG_USB_YUREX=m
CONFIG_USB_ATM=m
CONFIG_USB_SPEEDTOUCH=m
CONFIG_USB_CXACRU=m
CONFIG_USB_UEAGLEATM=m
CONFIG_USB_XUSBATM=m
CONFIG_USB_GADGET=m
CONFIG_USB_GADGET_DEBUG=y
CONFIG_USB_GADGET_DEBUG_FILES=y
CONFIG_USB_GADGET_DEBUG_FS=y
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_SELECTED=y
CONFIG_USB_GADGET_R8A66597=y
CONFIG_USB_R8A66597=m
# CONFIG_USB_GADGET_M66592 is not set
# CONFIG_USB_GADGET_AMD5536UDC is not set
# CONFIG_USB_GADGET_CI13XXX is not set
# CONFIG_USB_GADGET_NET2280 is not set
# CONFIG_USB_GADGET_GOKU is not set
# CONFIG_USB_GADGET_LANGWELL is not set
# CONFIG_USB_GADGET_DUMMY_HCD is not set
CONFIG_USB_GADGET_DUALSPEED=y
CONFIG_USB_ZERO=m
CONFIG_USB_AUDIO=m
CONFIG_USB_ETH=m
CONFIG_USB_ETH_RNDIS=y
CONFIG_USB_ETH_EEM=y
CONFIG_USB_GADGETFS=m
CONFIG_USB_FUNCTIONFS=m
CONFIG_USB_FUNCTIONFS_ETH=y
CONFIG_USB_FUNCTIONFS_RNDIS=y
CONFIG_USB_FUNCTIONFS_GENERIC=y
CONFIG_USB_FILE_STORAGE=m
CONFIG_USB_FILE_STORAGE_TEST=y
CONFIG_USB_MASS_STORAGE=m
CONFIG_USB_G_SERIAL=m
CONFIG_USB_MIDI_GADGET=m
CONFIG_USB_G_PRINTER=m
CONFIG_USB_CDC_COMPOSITE=m
CONFIG_USB_G_NOKIA=m
CONFIG_USB_G_MULTI=m
CONFIG_USB_G_MULTI_RNDIS=y
CONFIG_USB_G_MULTI_CDC=y
CONFIG_USB_G_HID=m
CONFIG_USB_G_DBGP=m
# CONFIG_USB_G_DBGP_PRINTK is not set
CONFIG_USB_G_DBGP_SERIAL=y
CONFIG_USB_G_WEBCAM=m

#
# OTG and related infrastructure
#
CONFIG_USB_OTG_UTILS=y
CONFIG_USB_GPIO_VBUS=m
CONFIG_NOP_USB_XCEIV=m
CONFIG_UWB=m
CONFIG_UWB_HWA=m
CONFIG_UWB_WHCI=m
CONFIG_UWB_I1480U=m
CONFIG_MMC=m
CONFIG_MMC_DEBUG=y
CONFIG_MMC_UNSAFE_RESUME=y

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=m
CONFIG_MMC_BLOCK_MINORS=8
CONFIG_MMC_BLOCK_BOUNCE=y
CONFIG_SDIO_UART=m
CONFIG_MMC_TEST=m

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=m
CONFIG_MMC_SDHCI_PCI=m
CONFIG_MMC_RICOH_MMC=y
CONFIG_MMC_SDHCI_PLTFM=m
CONFIG_MMC_WBSD=m
CONFIG_MMC_TIFM_SD=m
CONFIG_MMC_SPI=m
CONFIG_MMC_SDRICOH_CS=m
CONFIG_MMC_CB710=m
CONFIG_MMC_VIA_SDMMC=m
CONFIG_MMC_USHC=m
CONFIG_MEMSTICK=m
CONFIG_MEMSTICK_DEBUG=y

#
# MemoryStick drivers
#
CONFIG_MEMSTICK_UNSAFE_RESUME=y
CONFIG_MSPRO_BLOCK=m

#
# MemoryStick Host Controller Drivers
#
CONFIG_MEMSTICK_TIFM_MS=m
CONFIG_MEMSTICK_JMICRON_38X=m
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=m

#
# LED drivers
#
CONFIG_LEDS_NET5501=m
CONFIG_LEDS_ALIX2=m
CONFIG_LEDS_PCA9532=m
CONFIG_LEDS_GPIO=m
CONFIG_LEDS_GPIO_PLATFORM=y
CONFIG_LEDS_LP3944=m
CONFIG_LEDS_CLEVO_MAIL=m
CONFIG_LEDS_PCA955X=m
CONFIG_LEDS_WM831X_STATUS=m
CONFIG_LEDS_DAC124S085=m
CONFIG_LEDS_REGULATOR=m
CONFIG_LEDS_BD2802=m
CONFIG_LEDS_INTEL_SS4200=m
CONFIG_LEDS_LT3593=m
CONFIG_LEDS_DELL_NETBOOKS=m
CONFIG_LEDS_MC13783=m
CONFIG_LEDS_TRIGGERS=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGER_TIMER=m
CONFIG_LEDS_TRIGGER_IDE_DISK=y
CONFIG_LEDS_TRIGGER_HEARTBEAT=m
CONFIG_LEDS_TRIGGER_BACKLIGHT=m
CONFIG_LEDS_TRIGGER_GPIO=m
CONFIG_LEDS_TRIGGER_DEFAULT_ON=m

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_ACCESSIBILITY=y
CONFIG_A11Y_BRAILLE_CONSOLE=y
CONFIG_INFINIBAND=m
CONFIG_INFINIBAND_USER_MAD=m
CONFIG_INFINIBAND_USER_ACCESS=m
CONFIG_INFINIBAND_USER_MEM=y
CONFIG_INFINIBAND_ADDR_TRANS=y
CONFIG_INFINIBAND_MTHCA=m
CONFIG_INFINIBAND_MTHCA_DEBUG=y
CONFIG_INFINIBAND_IPATH=m
CONFIG_INFINIBAND_QIB=m
CONFIG_INFINIBAND_AMSO1100=m
CONFIG_INFINIBAND_AMSO1100_DEBUG=y
CONFIG_INFINIBAND_CXGB3=m
CONFIG_INFINIBAND_CXGB3_DEBUG=y
CONFIG_INFINIBAND_CXGB4=m
CONFIG_MLX4_INFINIBAND=m
CONFIG_INFINIBAND_NES=m
CONFIG_INFINIBAND_NES_DEBUG=y
CONFIG_INFINIBAND_IPOIB=m
CONFIG_INFINIBAND_IPOIB_CM=y
CONFIG_INFINIBAND_IPOIB_DEBUG=y
CONFIG_INFINIBAND_IPOIB_DEBUG_DATA=y
CONFIG_INFINIBAND_SRP=m
CONFIG_INFINIBAND_ISER=m
CONFIG_EDAC=y

#
# Reporting subsystems
#
CONFIG_EDAC_DEBUG=y
CONFIG_EDAC_DECODE_MCE=m
CONFIG_EDAC_MCE_INJ=m
CONFIG_EDAC_MM_EDAC=m
CONFIG_EDAC_MCE=y
CONFIG_EDAC_AMD64=m
CONFIG_EDAC_AMD64_ERROR_INJECTION=y
CONFIG_EDAC_E752X=m
CONFIG_EDAC_I82975X=m
CONFIG_EDAC_I3000=m
CONFIG_EDAC_I3200=m
CONFIG_EDAC_X38=m
CONFIG_EDAC_I5400=m
CONFIG_EDAC_I7CORE=m
CONFIG_EDAC_I5000=m
CONFIG_EDAC_I5100=m
CONFIG_EDAC_I7300=m
CONFIG_RTC_LIB=m
CONFIG_RTC_CLASS=m

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
CONFIG_RTC_INTF_DEV_UIE_EMUL=y
CONFIG_RTC_DRV_TEST=m

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_DS1307=m
CONFIG_RTC_DRV_DS1374=m
CONFIG_RTC_DRV_DS1672=m
CONFIG_RTC_DRV_DS3232=m
CONFIG_RTC_DRV_MAX6900=m
CONFIG_RTC_DRV_RS5C372=m
CONFIG_RTC_DRV_ISL1208=m
CONFIG_RTC_DRV_ISL12022=m
CONFIG_RTC_DRV_X1205=m
CONFIG_RTC_DRV_PCF8563=m
CONFIG_RTC_DRV_PCF8583=m
CONFIG_RTC_DRV_M41T80=m
CONFIG_RTC_DRV_M41T80_WDT=y
CONFIG_RTC_DRV_BQ32K=m
CONFIG_RTC_DRV_S35390A=m
CONFIG_RTC_DRV_FM3130=m
CONFIG_RTC_DRV_RX8581=m
CONFIG_RTC_DRV_RX8025=m

#
# SPI RTC drivers
#
CONFIG_RTC_DRV_M41T94=m
CONFIG_RTC_DRV_DS1305=m
CONFIG_RTC_DRV_DS1390=m
CONFIG_RTC_DRV_MAX6902=m
CONFIG_RTC_DRV_R9701=m
CONFIG_RTC_DRV_RS5C348=m
CONFIG_RTC_DRV_DS3234=m
CONFIG_RTC_DRV_PCF2123=m

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=m
CONFIG_RTC_DRV_DS1286=m
CONFIG_RTC_DRV_DS1511=m
CONFIG_RTC_DRV_DS1553=m
CONFIG_RTC_DRV_DS1742=m
CONFIG_RTC_DRV_STK17TA8=m
CONFIG_RTC_DRV_M48T86=m
CONFIG_RTC_DRV_M48T35=m
CONFIG_RTC_DRV_M48T59=m
CONFIG_RTC_DRV_MSM6242=m
CONFIG_RTC_DRV_BQ4802=m
CONFIG_RTC_DRV_RP5C01=m
CONFIG_RTC_DRV_V3020=m
CONFIG_RTC_DRV_WM831X=m
CONFIG_RTC_DRV_PCF50633=m

#
# on-CPU RTC drivers
#
CONFIG_RTC_DRV_PCAP=m
CONFIG_RTC_DRV_MC13XXX=m
CONFIG_DMADEVICES=y
CONFIG_DMADEVICES_DEBUG=y
CONFIG_DMADEVICES_VDEBUG=y

#
# DMA Devices
#
CONFIG_INTEL_MID_DMAC=m
CONFIG_INTEL_IOATDMA=m
CONFIG_TIMB_DMA=m
CONFIG_PCH_DMA=m
CONFIG_DMA_ENGINE=y

#
# DMA Clients
#
CONFIG_NET_DMA=y
CONFIG_ASYNC_TX_DMA=y
CONFIG_DMATEST=m
CONFIG_DCA=m
CONFIG_AUXDISPLAY=y
CONFIG_KS0108=m
CONFIG_KS0108_PORT=0x378
CONFIG_KS0108_DELAY=2
CONFIG_CFAG12864B=m
CONFIG_CFAG12864B_RATE=20
CONFIG_UIO=m
CONFIG_UIO_CIF=m
CONFIG_UIO_PDRV=m
CONFIG_UIO_PDRV_GENIRQ=m
CONFIG_UIO_AEC=m
CONFIG_UIO_SERCOS3=m
CONFIG_UIO_PCI_GENERIC=m
CONFIG_UIO_NETX=m

#
# Xen driver support
#
CONFIG_XEN_BALLOON=y
CONFIG_XEN_SCRUB_PAGES=y
CONFIG_XEN_DEV_EVTCHN=m
CONFIG_XENFS=m
CONFIG_XEN_COMPAT_XENFS=y
CONFIG_XEN_SYS_HYPERVISOR=y
CONFIG_XEN_PLATFORM_PCI=m
CONFIG_SWIOTLB_XEN=y
CONFIG_STAGING=y
CONFIG_STAGING_EXCLUDE_BUILD=y
CONFIG_X86_PLATFORM_DEVICES=y
CONFIG_ACER_WMI=m
CONFIG_ACERHDF=m
CONFIG_ASUS_LAPTOP=m
CONFIG_DELL_LAPTOP=m
CONFIG_DELL_WMI=m
CONFIG_FUJITSU_LAPTOP=m
CONFIG_FUJITSU_LAPTOP_DEBUG=y
CONFIG_HP_WMI=m
CONFIG_MSI_LAPTOP=m
CONFIG_PANASONIC_LAPTOP=m
CONFIG_COMPAL_LAPTOP=m
CONFIG_SONY_LAPTOP=m
CONFIG_SONYPI_COMPAT=y
CONFIG_IDEAPAD_LAPTOP=m
CONFIG_THINKPAD_ACPI=m
CONFIG_THINKPAD_ACPI_ALSA_SUPPORT=y
CONFIG_THINKPAD_ACPI_DEBUGFACILITIES=y
CONFIG_THINKPAD_ACPI_DEBUG=y
CONFIG_THINKPAD_ACPI_UNSAFE_LEDS=y
CONFIG_THINKPAD_ACPI_VIDEO=y
CONFIG_THINKPAD_ACPI_HOTKEY_POLL=y
CONFIG_SENSORS_HDAPS=m
CONFIG_INTEL_MENLOW=m
CONFIG_EEEPC_LAPTOP=m
CONFIG_EEEPC_WMI=m
CONFIG_ACPI_WMI=m
CONFIG_MSI_WMI=m
CONFIG_ACPI_ASUS=m
CONFIG_TOPSTAR_LAPTOP=m
CONFIG_ACPI_TOSHIBA=m
CONFIG_TOSHIBA_BT_RFKILL=m
CONFIG_ACPI_CMPC=m
CONFIG_INTEL_IPS=m
CONFIG_IBM_RTL=m

#
# Firmware Drivers
#
CONFIG_EDD=m
CONFIG_EDD_OFF=y
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_EFI_VARS=m
CONFIG_DELL_RBU=m
CONFIG_DCDBAS=m
CONFIG_DMIID=y
CONFIG_ISCSI_IBFT_FIND=y
CONFIG_ISCSI_IBFT=m

#
# File systems
#
CONFIG_EXT2_FS=m
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
CONFIG_EXT2_FS_XIP=y
CONFIG_EXT3_FS=m
CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4_FS=m
CONFIG_EXT4_FS_XATTR=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
CONFIG_EXT4_DEBUG=y
CONFIG_FS_XIP=y
CONFIG_JBD=m
CONFIG_JBD_DEBUG=y
CONFIG_JBD2=m
CONFIG_JBD2_DEBUG=y
CONFIG_FS_MBCACHE=m
CONFIG_REISERFS_FS=m
CONFIG_REISERFS_CHECK=y
CONFIG_REISERFS_PROC_INFO=y
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
CONFIG_REISERFS_FS_SECURITY=y
CONFIG_JFS_FS=m
CONFIG_JFS_POSIX_ACL=y
CONFIG_JFS_SECURITY=y
CONFIG_JFS_DEBUG=y
CONFIG_JFS_STATISTICS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_XFS_FS=m
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
CONFIG_XFS_DEBUG=y
CONFIG_GFS2_FS=m
CONFIG_GFS2_FS_LOCKING_DLM=y
CONFIG_OCFS2_FS=m
CONFIG_OCFS2_FS_O2CB=m
CONFIG_OCFS2_FS_USERSPACE_CLUSTER=m
CONFIG_OCFS2_FS_STATS=y
CONFIG_OCFS2_DEBUG_MASKLOG=y
CONFIG_OCFS2_DEBUG_FS=y
CONFIG_BTRFS_FS=m
CONFIG_BTRFS_FS_POSIX_ACL=y
CONFIG_NILFS2_FS=m
CONFIG_EXPORTFS=m
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
CONFIG_FANOTIFY_ACCESS_PERMISSIONS=y
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
CONFIG_PRINT_QUOTA_WARNING=y
CONFIG_QUOTA_DEBUG=y
CONFIG_QUOTA_TREE=m
CONFIG_QFMT_V1=m
CONFIG_QFMT_V2=m
CONFIG_QUOTACTL=y
CONFIG_QUOTACTL_COMPAT=y
CONFIG_AUTOFS4_FS=m
CONFIG_FUSE_FS=m
CONFIG_CUSE=m
CONFIG_GENERIC_ACL=y

#
# Caches
#
CONFIG_FSCACHE=m
CONFIG_FSCACHE_STATS=y
CONFIG_FSCACHE_HISTOGRAM=y
CONFIG_FSCACHE_DEBUG=y
CONFIG_FSCACHE_OBJECT_LIST=y
CONFIG_CACHEFILES=m
CONFIG_CACHEFILES_DEBUG=y
CONFIG_CACHEFILES_HISTOGRAM=y

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=m
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_NTFS_FS=m
CONFIG_NTFS_DEBUG=y
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=m
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ADFS_FS=m
CONFIG_ADFS_FS_RW=y
CONFIG_AFFS_FS=m
CONFIG_ECRYPT_FS=m
CONFIG_HFS_FS=m
CONFIG_HFSPLUS_FS=m
CONFIG_BEFS_FS=m
CONFIG_BEFS_DEBUG=y
CONFIG_BFS_FS=m
CONFIG_EFS_FS=m
CONFIG_JFFS2_FS=m
CONFIG_JFFS2_FS_DEBUG=0
CONFIG_JFFS2_FS_WRITEBUFFER=y
CONFIG_JFFS2_FS_WBUF_VERIFY=y
CONFIG_JFFS2_SUMMARY=y
CONFIG_JFFS2_FS_XATTR=y
CONFIG_JFFS2_FS_POSIX_ACL=y
CONFIG_JFFS2_FS_SECURITY=y
CONFIG_JFFS2_COMPRESSION_OPTIONS=y
CONFIG_JFFS2_ZLIB=y
CONFIG_JFFS2_LZO=y
CONFIG_JFFS2_RTIME=y
CONFIG_JFFS2_RUBIN=y
# CONFIG_JFFS2_CMODE_NONE is not set
CONFIG_JFFS2_CMODE_PRIORITY=y
# CONFIG_JFFS2_CMODE_SIZE is not set
# CONFIG_JFFS2_CMODE_FAVOURLZO is not set
CONFIG_UBIFS_FS=m
CONFIG_UBIFS_FS_XATTR=y
CONFIG_UBIFS_FS_ADVANCED_COMPR=y
CONFIG_UBIFS_FS_LZO=y
CONFIG_UBIFS_FS_ZLIB=y
CONFIG_UBIFS_FS_DEBUG=y
CONFIG_UBIFS_FS_DEBUG_MSG_LVL=0
CONFIG_UBIFS_FS_DEBUG_CHKS=y
CONFIG_LOGFS=m
CONFIG_CRAMFS=m
CONFIG_SQUASHFS=m
CONFIG_SQUASHFS_XATTR=y
CONFIG_SQUASHFS_LZO=y
CONFIG_SQUASHFS_EMBEDDED=y
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
CONFIG_VXFS_FS=m
CONFIG_MINIX_FS=m
CONFIG_OMFS_FS=m
CONFIG_HPFS_FS=m
CONFIG_QNX4FS_FS=m
CONFIG_ROMFS_FS=m
CONFIG_ROMFS_BACKED_BY_BLOCK=y
# CONFIG_ROMFS_BACKED_BY_MTD is not set
# CONFIG_ROMFS_BACKED_BY_BOTH is not set
CONFIG_ROMFS_ON_BLOCK=y
CONFIG_SYSV_FS=m
CONFIG_UFS_FS=m
CONFIG_UFS_FS_WRITE=y
CONFIG_UFS_DEBUG=y
CONFIG_EXOFS_FS=m
CONFIG_EXOFS_DEBUG=y
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=m
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=y
CONFIG_NFS_V4_1=y
CONFIG_PNFS_FILE_LAYOUT=m
CONFIG_NFS_FSCACHE=y
CONFIG_NFS_USE_LEGACY_DNS=y
CONFIG_NFS_USE_NEW_IDMAPPER=y
CONFIG_NFSD=m
CONFIG_NFSD_DEPRECATED=y
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_V3_ACL=y
CONFIG_NFSD_V4=y
CONFIG_LOCKD=m
CONFIG_LOCKD_V4=y
CONFIG_NFS_ACL_SUPPORT=m
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=m
CONFIG_SUNRPC_GSS=m
CONFIG_SUNRPC_XPRT_RDMA=m
CONFIG_RPCSEC_GSS_KRB5=m
CONFIG_CEPH_FS=m
CONFIG_CIFS=m
CONFIG_CIFS_STATS=y
CONFIG_CIFS_STATS2=y
CONFIG_CIFS_WEAK_PW_HASH=y
CONFIG_CIFS_UPCALL=y
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
CONFIG_CIFS_DEBUG2=y
CONFIG_CIFS_DFS_UPCALL=y
CONFIG_CIFS_FSCACHE=y
CONFIG_CIFS_EXPERIMENTAL=y
CONFIG_NCP_FS=m
CONFIG_NCPFS_PACKET_SIGNING=y
CONFIG_NCPFS_IOCTL_LOCKING=y
CONFIG_NCPFS_STRONG=y
CONFIG_NCPFS_NFS_NS=y
CONFIG_NCPFS_OS2_NS=y
CONFIG_NCPFS_SMALLDOS=y
CONFIG_NCPFS_NLS=y
CONFIG_NCPFS_EXTRAS=y
CONFIG_CODA_FS=m
CONFIG_AFS_FS=m
CONFIG_AFS_DEBUG=y
CONFIG_AFS_FSCACHE=y
CONFIG_9P_FS=m
CONFIG_9P_FSCACHE=y
CONFIG_9P_FS_POSIX_ACL=y

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
CONFIG_ACORN_PARTITION=y
CONFIG_ACORN_PARTITION_CUMANA=y
CONFIG_ACORN_PARTITION_EESOX=y
CONFIG_ACORN_PARTITION_ICS=y
CONFIG_ACORN_PARTITION_ADFS=y
CONFIG_ACORN_PARTITION_POWERTEC=y
CONFIG_ACORN_PARTITION_RISCIX=y
CONFIG_OSF_PARTITION=y
CONFIG_AMIGA_PARTITION=y
CONFIG_ATARI_PARTITION=y
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
CONFIG_LDM_PARTITION=y
CONFIG_LDM_DEBUG=y
CONFIG_SGI_PARTITION=y
CONFIG_ULTRIX_PARTITION=y
CONFIG_SUN_PARTITION=y
CONFIG_KARMA_PARTITION=y
CONFIG_EFI_PARTITION=y
CONFIG_SYSV68_PARTITION=y
CONFIG_NLS=m
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=m
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=m
CONFIG_NLS_CODEPAGE_850=m
CONFIG_NLS_CODEPAGE_852=m
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=m
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=m
CONFIG_NLS_CODEPAGE_866=m
CONFIG_NLS_CODEPAGE_869=m
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=m
CONFIG_NLS_CODEPAGE_932=m
CONFIG_NLS_CODEPAGE_949=m
CONFIG_NLS_CODEPAGE_874=m
CONFIG_NLS_ISO8859_8=m
CONFIG_NLS_CODEPAGE_1250=m
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=m
CONFIG_NLS_ISO8859_1=m
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=m
CONFIG_NLS_ISO8859_5=m
CONFIG_NLS_ISO8859_6=m
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=m
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=m
CONFIG_NLS_KOI8_R=m
CONFIG_NLS_KOI8_U=m
CONFIG_NLS_UTF8=m
CONFIG_DLM=m
CONFIG_DLM_DEBUG=y

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
CONFIG_MAGIC_SYSRQ=y
CONFIG_STRIP_ASM_SYMS=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=1
CONFIG_DETECT_HUNG_TASK=y
CONFIG_BOOTPARAM_HUNG_TASK_PANIC=y
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=1
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
CONFIG_DEBUG_OBJECTS=y
# CONFIG_DEBUG_OBJECTS_SELFTEST is not set
CONFIG_DEBUG_OBJECTS_FREE=y
CONFIG_DEBUG_OBJECTS_TIMERS=y
CONFIG_DEBUG_OBJECTS_WORK=y
CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER=y
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
CONFIG_SLUB_DEBUG_ON=y
CONFIG_SLUB_STATS=y
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
CONFIG_RT_MUTEX_TESTER=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_BKL=y
CONFIG_DEBUG_LOCK_ALLOC=y
# CONFIG_PROVE_LOCKING is not set
CONFIG_SPARSE_RCU_POINTER=y
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
CONFIG_DEBUG_LOCKDEP=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_SPINLOCK_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
CONFIG_DEBUG_INFO_REDUCED=y
CONFIG_DEBUG_VM=y
CONFIG_DEBUG_VIRTUAL=y
CONFIG_DEBUG_WRITECOUNT=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_DEBUG_LIST=y
CONFIG_TEST_LIST_SORT=y
CONFIG_DEBUG_SG=y
CONFIG_DEBUG_NOTIFIERS=y
CONFIG_DEBUG_CREDENTIALS=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_BOOT_PRINTK_DELAY=y
CONFIG_RCU_TORTURE_TEST=m
CONFIG_RCU_CPU_STALL_DETECTOR=y
CONFIG_RCU_CPU_STALL_TIMEOUT=60
CONFIG_RCU_CPU_STALL_DETECTOR_RUNNABLE=y
CONFIG_KPROBES_SANITY_TEST=y
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_DEBUG_BLOCK_EXT_DEVT=y
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
CONFIG_LKDTM=m
CONFIG_CPU_NOTIFIER_ERROR_INJECT=m
CONFIG_FAULT_INJECTION=y
CONFIG_FAILSLAB=y
CONFIG_FAIL_PAGE_ALLOC=y
CONFIG_FAIL_MAKE_REQUEST=y
CONFIG_FAIL_IO_TIMEOUT=y
CONFIG_FAULT_INJECTION_DEBUG_FS=y
CONFIG_LATENCYTOP=y
CONFIG_SYSCTL_SYSCALL_CHECK=y
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FTRACE_NMI_ENTER=y
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
CONFIG_FTRACE_NMI_ENTER=y
CONFIG_EVENT_TRACING=y
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
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
CONFIG_STACK_TRACER=y
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_KPROBE_EVENT=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_FUNCTION_PROFILER=y
CONFIG_FTRACE_MCOUNT_RECORD=y
# CONFIG_FTRACE_STARTUP_TEST is not set
CONFIG_MMIOTRACE=y
# CONFIG_MMIOTRACE_TEST is not set
CONFIG_RING_BUFFER_BENCHMARK=m
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
CONFIG_FIREWIRE_OHCI_REMOTE_DMA=y
CONFIG_BUILD_DOCSRC=y
CONFIG_DYNAMIC_DEBUG=y
CONFIG_DMA_API_DEBUG=y
# CONFIG_ATOMIC64_SELFTEST is not set
CONFIG_ASYNC_RAID6_TEST=m
CONFIG_SAMPLES=y
CONFIG_SAMPLE_TRACEPOINTS=m
CONFIG_SAMPLE_TRACE_EVENTS=m
CONFIG_SAMPLE_KOBJECT=m
CONFIG_SAMPLE_KPROBES=m
CONFIG_SAMPLE_KRETPROBES=m
CONFIG_SAMPLE_HW_BREAKPOINT=m
CONFIG_SAMPLE_KFIFO=m
CONFIG_SAMPLE_KDB=m
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_KGDB=y
CONFIG_KGDB_SERIAL_CONSOLE=m
# CONFIG_KGDB_TESTS is not set
CONFIG_KGDB_LOW_LEVEL_TRAP=y
CONFIG_KGDB_KDB=y
CONFIG_KDB_KEYBOARD=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACK_USAGE=y
CONFIG_DEBUG_PER_CPU_MAPS=y
CONFIG_X86_PTDUMP=y
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
CONFIG_DEBUG_NX_TEST=m
CONFIG_IOMMU_DEBUG=y
CONFIG_IOMMU_STRESS=y
CONFIG_IOMMU_LEAK=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
# CONFIG_X86_DECODER_SELFTEST is not set
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
CONFIG_DEBUG_BOOT_PARAMS=y
CONFIG_CPA_DEBUG=y
CONFIG_OPTIMIZE_INLINING=y
CONFIG_DEBUG_STRICT_USER_COPY_CHECKS=y

#
# Security options
#
CONFIG_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_NETWORK_XFRM=y
CONFIG_SECURITY_PATH=y
CONFIG_INTEL_TXT=y
# CONFIG_SECURITY_SELINUX is not set
CONFIG_SECURITY_SMACK=y
CONFIG_SECURITY_TOMOYO=y
CONFIG_SECURITY_APPARMOR=y
CONFIG_SECURITY_APPARMOR_BOOTPARAM_VALUE=1
CONFIG_IMA=y
CONFIG_IMA_MEASURE_PCR_IDX=10
CONFIG_IMA_AUDIT=y
CONFIG_IMA_LSM_RULES=y
# CONFIG_DEFAULT_SECURITY_SMACK is not set
# CONFIG_DEFAULT_SECURITY_TOMOYO is not set
# CONFIG_DEFAULT_SECURITY_APPARMOR is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_XOR_BLOCKS=m
CONFIG_ASYNC_CORE=m
CONFIG_ASYNC_MEMCPY=m
CONFIG_ASYNC_XOR=m
CONFIG_ASYNC_PQ=m
CONFIG_ASYNC_RAID6_RECOV=m
CONFIG_ASYNC_TX_DISABLE_PQ_VAL_DMA=y
CONFIG_ASYNC_TX_DISABLE_XOR_VAL_DMA=y
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
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=m
CONFIG_CRYPTO_NULL=m
CONFIG_CRYPTO_PCRYPT=m
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=m
CONFIG_CRYPTO_AUTHENC=m
CONFIG_CRYPTO_TEST=m

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
CONFIG_CRYPTO_FPU=m

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=m
CONFIG_CRYPTO_VMAC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=m
CONFIG_CRYPTO_CRC32C_INTEL=m
CONFIG_CRYPTO_GHASH=m
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=m
CONFIG_CRYPTO_RMD128=m
CONFIG_CRYPTO_RMD160=m
CONFIG_CRYPTO_RMD256=m
CONFIG_CRYPTO_RMD320=m
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=m
CONFIG_CRYPTO_SHA512=m
CONFIG_CRYPTO_TGR192=m
CONFIG_CRYPTO_WP512=m
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=m

#
# Ciphers
#
CONFIG_CRYPTO_AES=m
CONFIG_CRYPTO_AES_X86_64=m
CONFIG_CRYPTO_AES_NI_INTEL=m
CONFIG_CRYPTO_ANUBIS=m
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_CAMELLIA=m
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_DES=m
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_KHAZAD=m
CONFIG_CRYPTO_SALSA20=m
CONFIG_CRYPTO_SALSA20_X86_64=m
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
CONFIG_CRYPTO_TWOFISH_X86_64=m

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=m
CONFIG_CRYPTO_ZLIB=m
CONFIG_CRYPTO_LZO=m

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=m
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=m
CONFIG_CRYPTO_DEV_PADLOCK_AES=m
CONFIG_CRYPTO_DEV_PADLOCK_SHA=m
CONFIG_CRYPTO_DEV_HIFN_795X=m
CONFIG_CRYPTO_DEV_HIFN_795X_RNG=y
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_APIC_ARCHITECTURE=y
CONFIG_KVM_MMIO=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=m
CONFIG_KVM_INTEL=m
CONFIG_KVM_AMD=m
CONFIG_KVM_MMU_AUDIT=y
CONFIG_VHOST_NET=m
CONFIG_VIRTIO=m
CONFIG_VIRTIO_RING=m
CONFIG_VIRTIO_PCI=m
CONFIG_VIRTIO_BALLOON=m
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_RAID6_PQ=m
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_GENERIC_FIND_LAST_BIT=y
CONFIG_CRC_CCITT=m
CONFIG_CRC16=m
CONFIG_CRC_T10DIF=m
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
CONFIG_CRC7=m
CONFIG_LIBCRC32C=m
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=m
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=m
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=m
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
CONFIG_BTREE=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPUMASK_OFFSTACK=y
CONFIG_NLATTR=y
CONFIG_LRU_CACHE=m

--------------050007070806000900060101--

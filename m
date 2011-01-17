Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091Ab1AQWiP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 17:38:15 -0500
Received: from mx3.schottelius.org ([77.109.138.221]:49547 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265Ab1AQWiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 17:38:11 -0500
X-Greylist: delayed 575 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Jan 2011 17:38:09 EST
Date: Mon, 17 Jan 2011 23:28:24 +0100
From: Nico Schottelius <nico-kernel-20110117@schottelius.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Nico Schottelius <nico-kernel-20110117@schottelius.org>
Subject: 2.6.37-05761-gf878133: Intel (i915) renders incorrectly
Message-ID: <20110117222824.GA20444@schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-kernel-20110117@schottelius.org>,
	LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kXdP64Ggrk/fb43R"
Content-Disposition: inline
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Netzseite: http://www.nico.schottelius.org/
X-System-Info: kr (Linux 2.6.37-07956-g8c34482 x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kXdP64Ggrk/fb43R
Content-Type: multipart/mixed; boundary="u3/rZRmxL6MmkK24"
Content-Disposition: inline


--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey!

After several suspend/resume cycles, the display is completly
screwed up, only parts are shown and rendering is slow.

Attached are xorg.log and dmesg part.

Not sure anymore, whether LKML is the right destination
or some freedesktop-ml?

I'm now on 2.6.37-05761-gf878133, but suspect that this
problem will occur soon again and hope somebody is already
trying to fix it.

Cheers,

Nico

--=20
PGP key: 7ED9 F7D3 6B10 81D7 0EC5  5C09 D7DC C8E4 3187 7DF0

--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="broken-rendering-2.6.37-05761-gf878133.screwede.dmesg"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.37-05761-gf878133 (nico@kr) (gcc version 4=
=2E5.2 (GCC) ) #55 SMP PREEMPT Thu Jan 13 16:27:39 CET 2011
[    0.000000] Command line:=20
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009e800 (usable)
[    0.000000]  BIOS-e820: 000000000009e800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000d2000 - 00000000000d4000 (reserved)
[    0.000000]  BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bb27c000 (usable)
[    0.000000]  BIOS-e820: 00000000bb27c000 - 00000000bb282000 (reserved)
[    0.000000]  BIOS-e820: 00000000bb282000 - 00000000bb363000 (usable)
[    0.000000]  BIOS-e820: 00000000bb363000 - 00000000bb375000 (reserved)
[    0.000000]  BIOS-e820: 00000000bb375000 - 00000000bb3f6000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bb3f6000 - 00000000bb40f000 (reserved)
[    0.000000]  BIOS-e820: 00000000bb40f000 - 00000000bb470000 (usable)
[    0.000000]  BIOS-e820: 00000000bb470000 - 00000000bb668000 (reserved)
[    0.000000]  BIOS-e820: 00000000bb668000 - 00000000bb6e8000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bb6e8000 - 00000000bb70f000 (reserved)
[    0.000000]  BIOS-e820: 00000000bb70f000 - 00000000bb717000 (usable)
[    0.000000]  BIOS-e820: 00000000bb717000 - 00000000bb71f000 (reserved)
[    0.000000]  BIOS-e820: 00000000bb71f000 - 00000000bb76b000 (usable)
[    0.000000]  BIOS-e820: 00000000bb76b000 - 00000000bb777000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bb777000 - 00000000bb77a000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bb77a000 - 00000000bb781000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bb781000 - 00000000bb782000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bb782000 - 00000000bb78b000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bb78b000 - 00000000bb78c000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bb78c000 - 00000000bb79f000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bb79f000 - 00000000bb7ff000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bb7ff000 - 00000000bb800000 (usable)
[    0.000000]  BIOS-e820: 00000000bb800000 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000feaff000 - 00000000feb00000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000138000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] DMI: 3626A14/3626A14, BIOS 6QET35WW (1.05 ) 01/26/2010
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usab=
le) =3D=3D> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usab=
le)
[    0.000000] last_pfn =3D 0x138000 max_arch_pfn =3D 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-D3FFF write-protect
[    0.000000]   D4000-DBFFF uncachable
[    0.000000]   DC000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 disabled
[    0.000000]   1 base 000000000 mask F80000000 write-back
[    0.000000]   2 base 080000000 mask FC0000000 write-back
[    0.000000]   3 base 100000000 mask FC0000000 write-back
[    0.000000]   4 base 138000000 mask FF8000000 uncachable
[    0.000000]   5 base 0BC000000 mask FFC000000 uncachable
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x701060007=
0106
[    0.000000] e820 update range: 00000000bc000000 - 0000000100000000 (usab=
le) =3D=3D> (reserved)
[    0.000000] last_pfn =3D 0xbb800 max_arch_pfn =3D 0x400000000
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-00000000bb800000
[    0.000000]  0000000000 - 00bb800000 page 2M
[    0.000000] kernel direct mapping tables up to bb800000 @ 1fffc000-20000=
000
[    0.000000] init_memory_mapping: 0000000100000000-0000000138000000
[    0.000000]  0100000000 - 0138000000 page 2M
[    0.000000] kernel direct mapping tables up to 138000000 @ bb765000-bb76=
b000
[    0.000000] ACPI: RSDP 00000000000f68f0 00024 (v02 LENOVO)
[    0.000000] ACPI: XSDT 00000000bb7f0a79 00094 (v01 LENOVO TP-6Q    00001=
050  LTP 00000000)
[    0.000000] ACPI: FACP 00000000bb7f0c00 000F4 (v04 LENOVO TP-6Q    00001=
050 LNVO 00000001)
[    0.000000] ACPI: DSDT 00000000bb7f0f6b 0DD9B (v01 LENOVO TP-6Q    00001=
050 MSFT 03000001)
[    0.000000] ACPI: FACS 00000000bb6e7000 00040
[    0.000000] ACPI: SSDT 00000000bb7f0db4 001B7 (v01 LENOVO TP-6Q    00001=
050 MSFT 03000001)
[    0.000000] ACPI: ECDT 00000000bb7fed06 00052 (v01 LENOVO TP-6Q    00001=
050 LNVO 00000001)
[    0.000000] ACPI: APIC 00000000bb7fed58 00084 (v01 LENOVO TP-6Q    00001=
050 LNVO 00000001)
[    0.000000] ACPI: MCFG 00000000bb7fee14 0003C (v01 LENOVO TP-6Q    00001=
050 LNVO 00000001)
[    0.000000] ACPI: HPET 00000000bb7fee50 00038 (v01 LENOVO TP-6Q    00001=
050 LNVO 00000001)
[    0.000000] ACPI: ASF! 00000000bb7fef34 000A4 (v16 LENOVO TP-6Q    00001=
050 PTL  00000001)
[    0.000000] ACPI: BOOT 00000000bb7fefd8 00028 (v01 LENOVO TP-6Q    00001=
050  LTP 00000001)
[    0.000000] ACPI: SSDT 00000000bb6e590a 0085B (v01 LENOVO TP-6Q    00001=
050 INTL 20050513)
[    0.000000] ACPI: TCPA 00000000bb78b000 00032 (v02    PTL  CRESTLN 06040=
000      00005A52)
[    0.000000] ACPI: DMAR 00000000bb781000 000B8 (v01 INTEL  CP_DALE  00000=
001 INTL 00000001)
[    0.000000] ACPI: SSDT 00000000bb779000 009F1 (v01  PmRef    CpuPm 00003=
000 INTL 20050513)
[    0.000000] ACPI: SSDT 00000000bb778000 00259 (v01  PmRef  Cpu0Tst 00003=
000 INTL 20050513)
[    0.000000] ACPI: SSDT 00000000bb777000 0049F (v01  PmRef    ApTst 00003=
000 INTL 20050513)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-0000000138000000
[    0.000000] Initmem setup node 0 0000000000000000-0000000138000000
[    0.000000]   NODE_DATA [0000000137ffb000 - 0000000137ffffff]
[    0.000000]  [ffffea0000000000-ffffea00045fffff] PMD -> [ffff88013400000=
0-ffff8801377fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00138000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[8] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009e
[    0.000000]     0: 0x00000100 -> 0x000bb27c
[    0.000000]     0: 0x000bb282 -> 0x000bb363
[    0.000000]     0: 0x000bb40f -> 0x000bb470
[    0.000000]     0: 0x000bb70f -> 0x000bb717
[    0.000000]     0: 0x000bb71f -> 0x000bb76b
[    0.000000]     0: 0x000bb7ff -> 0x000bb800
[    0.000000]     0: 0x00100000 -> 0x00138000
[    0.000000] On node 0 totalpages: 996257
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 3920 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 748619 pages, LIFO batch:31
[    0.000000]   Normal zone: 3136 pages used for memmap
[    0.000000]   Normal zone: 226240 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000=
9f000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000=
a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000=
d2000
[    0.000000] PM: Registered nosave memory: 00000000000d2000 - 00000000000=
d4000
[    0.000000] PM: Registered nosave memory: 00000000000d4000 - 00000000000=
dc000
[    0.000000] PM: Registered nosave memory: 00000000000dc000 - 00000000001=
00000
[    0.000000] PM: Registered nosave memory: 00000000bb27c000 - 00000000bb2=
82000
[    0.000000] PM: Registered nosave memory: 00000000bb363000 - 00000000bb3=
75000
[    0.000000] PM: Registered nosave memory: 00000000bb375000 - 00000000bb3=
f6000
[    0.000000] PM: Registered nosave memory: 00000000bb3f6000 - 00000000bb4=
0f000
[    0.000000] PM: Registered nosave memory: 00000000bb470000 - 00000000bb6=
68000
[    0.000000] PM: Registered nosave memory: 00000000bb668000 - 00000000bb6=
e8000
[    0.000000] PM: Registered nosave memory: 00000000bb6e8000 - 00000000bb7=
0f000
[    0.000000] PM: Registered nosave memory: 00000000bb717000 - 00000000bb7=
1f000
[    0.000000] PM: Registered nosave memory: 00000000bb76b000 - 00000000bb7=
77000
[    0.000000] PM: Registered nosave memory: 00000000bb777000 - 00000000bb7=
7a000
[    0.000000] PM: Registered nosave memory: 00000000bb77a000 - 00000000bb7=
81000
[    0.000000] PM: Registered nosave memory: 00000000bb781000 - 00000000bb7=
82000
[    0.000000] PM: Registered nosave memory: 00000000bb782000 - 00000000bb7=
8b000
[    0.000000] PM: Registered nosave memory: 00000000bb78b000 - 00000000bb7=
8c000
[    0.000000] PM: Registered nosave memory: 00000000bb78c000 - 00000000bb7=
9f000
[    0.000000] PM: Registered nosave memory: 00000000bb79f000 - 00000000bb7=
ff000
[    0.000000] PM: Registered nosave memory: 00000000bb800000 - 00000000c00=
00000
[    0.000000] PM: Registered nosave memory: 00000000c0000000 - 00000000e00=
00000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f00=
00000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fea=
ff000
[    0.000000] PM: Registered nosave memory: 00000000feaff000 - 00000000feb=
00000
[    0.000000] PM: Registered nosave memory: 00000000feb00000 - 00000000fec=
00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec=
10000
[    0.000000] PM: Registered nosave memory: 00000000fec10000 - 00000000fed=
00000
[    0.000000] PM: Registered nosave memory: 00000000fed00000 - 00000000fed=
1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed=
90000
[    0.000000] PM: Registered nosave memory: 00000000fed90000 - 00000000fee=
00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee=
01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ff0=
00000
[    0.000000] PM: Registered nosave memory: 00000000ff000000 - 00000001000=
00000
[    0.000000] Allocating PCI resources starting at c0000000 (gap: c0000000=
:20000000)
[    0.000000] setup_percpu: NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:4 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 26 pages/cpu @ffff8800bb000000 s74816 r8192=
 d23488 u524288
[    0.000000] pcpu-alloc: s74816 r8192 d23488 u524288 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3=20
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 978779
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line:=20
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Memory: 3853176k/5111808k available (3544k kernel code, 1126=
780k absent, 131852k reserved, 3030k data, 524k init)
[    0.000000] SLUB: Genslabs=3D15, HWalign=3D64, Order=3D0-3, MinObjects=
=3D0, CPUs=3D4, Nodes=3D1
[    0.000000] Preemptable hierarchical RCU implementation.
[    0.000000] 	RCU-based detection of stalled CPUs is disabled.
[    0.000000] 	Verbose stalled-CPUs detection is disabled.
[    0.000000] NR_IRQS:384
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 40632320 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't wan=
t memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.001000] Detected 2393.937 MHz processor.
[    0.000003] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 4787.87 BogoMIPS (lpj=3D2393937)
[    0.000248] pid_max: default: 32768 minimum: 301
[    0.000397] Security Framework initialized
[    0.000811] Dentry cache hash table entries: 524288 (order: 10, 4194304 =
bytes)
[    0.002000] Inode-cache hash table entries: 262144 (order: 9, 2097152 by=
tes)
[    0.002535] Mount-cache hash table entries: 256
[    0.002767] Initializing cgroup subsys debug
[    0.002886] Initializing cgroup subsys ns
[    0.003005] ns_cgroup deprecated: consider using the 'clone_children' fl=
ag without the ns_cgroup.
[    0.003205] Initializing cgroup subsys cpuacct
[    0.003338] Initializing cgroup subsys memory
[    0.005415] Initializing cgroup subsys devices
[    0.005534] Initializing cgroup subsys freezer
[    0.005677] CPU: Physical Processor ID: 0
[    0.005795] CPU: Processor Core ID: 0
[    0.005916] mce: CPU supports 9 MCE banks
[    0.006043] CPU0: Thermal monitoring enabled (TM1)
[    0.006168] using mwait in idle threads.
[    0.006355] ACPI: Core revision 20101013
[    0.103985] Setting APIC routing to flat
[    0.104522] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.114648] CPU0: Intel(R) Core(TM) i5 CPU       M 520  @ 2.40GHz steppi=
ng 02
[    0.215904] Performance Events: PEBS fmt1+, Westmere events, Intel PMU d=
river.
[    0.216254] ... version:                3
[    0.216389] ... bit width:              48
[    0.216523] ... generic registers:      4
[    0.216658] ... value mask:             0000ffffffffffff
[    0.216796] ... max period:             000000007fffffff
[    0.216936] ... fixed-purpose events:   3
[    0.217070] ... event mask:             000000070000000f
[    0.222913] Booting Node   0, Processors  #1 #2 #3 Ok.
[    0.499471] Brought up 4 CPUs
[    0.499608] Total of 4 processors activated (19151.08 BogoMIPS).
[    0.501230] regulator: core version 0.5
[    0.501453] regulator: dummy:=20
[    0.501620] NET: Registered protocol family 16
[    0.501999] ACPI FADT declares the system doesn't support PCIe ASPM, so =
disable it
[    0.502226] ACPI: bus type pci registered
[    0.502469] PCI: Using configuration type 1 for base access
[    0.504781] bio: create slab <bio-0> at 0
[    0.507617] ACPI: EC: EC description table is found, configuring boot EC
[    0.517253] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.597422] ACPI: SSDT 00000000bb71aa18 0046F (v01  PmRef  Cpu0Ist 00003=
000 INTL 20050513)
[    0.598375] ACPI: Dynamic OEM Table Load:
[    0.598591] ACPI: SSDT           (null) 0046F (v01  PmRef  Cpu0Ist 00003=
000 INTL 20050513)
[    0.599256] ACPI: SSDT 00000000bb718718 006B2 (v01  PmRef  Cpu0Cst 00003=
001 INTL 20050513)
[    0.600227] ACPI: Dynamic OEM Table Load:
[    0.600447] ACPI: SSDT           (null) 006B2 (v01  PmRef  Cpu0Cst 00003=
001 INTL 20050513)
[    0.606780] ACPI: SSDT 00000000bb719a98 00303 (v01  PmRef    ApIst 00003=
000 INTL 20050513)
[    0.607810] ACPI: Dynamic OEM Table Load:
[    0.608027] ACPI: SSDT           (null) 00303 (v01  PmRef    ApIst 00003=
000 INTL 20050513)
[    0.611449] ACPI: SSDT 00000000bb717d98 00119 (v01  PmRef    ApCst 00003=
000 INTL 20050513)
[    0.612422] ACPI: Dynamic OEM Table Load:
[    0.612640] ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst 00003=
000 INTL 20050513)
[    0.618317] ACPI: Interpreter enabled
[    0.618452] ACPI: (supports S0 S3 S4 S5)
[    0.618767] ACPI: Using IOAPIC for interrupt routing
[    0.623065] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan=
-723)
[    0.625019] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan=
-723)
[    0.629046] ACPI: EC: GPE =3D 0x11, I/O: command/status =3D 0x66, data =
=3D 0x62
[    0.629398] ACPI: Power Resource [PUBS] (on)
[    0.631194] ACPI: ACPI Dock Station Driver: 3 docks/bays found
[    0.631340] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.631583] ACPI: PCI Root Bridge [UNCR] (domain 0000 [bus ff])
[    0.631782] pci 0000:ff:00.0: [8086:2c62] type 0 class 0x000600
[    0.631804] pci 0000:ff:00.1: [8086:2d01] type 0 class 0x000600
[    0.631823] pci 0000:ff:02.0: [8086:2d10] type 0 class 0x000600
[    0.631839] pci 0000:ff:02.1: [8086:2d11] type 0 class 0x000600
[    0.631856] pci 0000:ff:02.2: [8086:2d12] type 0 class 0x000600
[    0.631872] pci 0000:ff:02.3: [8086:2d13] type 0 class 0x000600
[    0.632411] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-fe])
[    0.632623] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.632766] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.632909] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x00=
0bffff]
[    0.633136] pci_root PNP0A08:00: host bridge window [mem 0x000d4000-0x00=
0d7fff]
[    0.633364] pci_root PNP0A08:00: host bridge window [mem 0x000d8000-0x00=
0dbfff]
[    0.633591] pci_root PNP0A08:00: host bridge window [mem 0xc0000000-0xfe=
bfffff]
[    0.633823] pci 0000:00:00.0: [8086:0044] type 0 class 0x000600
[    0.633853] pci 0000:00:02.0: [8086:0046] type 0 class 0x000300
[    0.633864] pci 0000:00:02.0: reg 10: [mem 0xf2000000-0xf23fffff 64bit]
[    0.633871] pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff 64bit p=
ref]
[    0.633876] pci 0000:00:02.0: reg 20: [io  0x1800-0x1807]
[    0.633938] pci 0000:00:16.0: [8086:3b64] type 0 class 0x000780
[    0.633967] pci 0000:00:16.0: reg 10: [mem 0xf2727800-0xf272780f 64bit]
[    0.634042] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.634048] pci 0000:00:16.0: PME# disabled
[    0.634086] pci 0000:00:19.0: [8086:10ea] type 0 class 0x000200
[    0.634112] pci 0000:00:19.0: reg 10: [mem 0xf2500000-0xf251ffff]
[    0.634123] pci 0000:00:19.0: reg 14: [mem 0xf2525000-0xf2525fff]
[    0.634135] pci 0000:00:19.0: reg 18: [io  0x1820-0x183f]
[    0.634205] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.634210] pci 0000:00:19.0: PME# disabled
[    0.634241] pci 0000:00:1a.0: [8086:3b3c] type 0 class 0x000c03
[    0.634267] pci 0000:00:1a.0: reg 10: [mem 0xf2728000-0xf27283ff]
[    0.634356] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.634361] pci 0000:00:1a.0: PME# disabled
[    0.634391] pci 0000:00:1b.0: [8086:3b56] type 0 class 0x000403
[    0.634410] pci 0000:00:1b.0: reg 10: [mem 0xf2520000-0xf2523fff 64bit]
[    0.634485] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.634489] pci 0000:00:1b.0: PME# disabled
[    0.634512] pci 0000:00:1c.0: [8086:3b42] type 1 class 0x000604
[    0.634588] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.634593] pci 0000:00:1c.0: PME# disabled
[    0.634620] pci 0000:00:1c.3: [8086:3b48] type 1 class 0x000604
[    0.634697] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.634702] pci 0000:00:1c.3: PME# disabled
[    0.634728] pci 0000:00:1c.4: [8086:3b4a] type 1 class 0x000604
[    0.634806] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.634811] pci 0000:00:1c.4: PME# disabled
[    0.634847] pci 0000:00:1d.0: [8086:3b34] type 0 class 0x000c03
[    0.634873] pci 0000:00:1d.0: reg 10: [mem 0xf2728400-0xf27287ff]
[    0.634962] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.634966] pci 0000:00:1d.0: PME# disabled
[    0.634992] pci 0000:00:1e.0: [8086:2448] type 1 class 0x000604
[    0.635067] pci 0000:00:1f.0: [8086:3b07] type 0 class 0x000601
[    0.635188] pci 0000:00:1f.2: [8086:3b2f] type 0 class 0x000106
[    0.635214] pci 0000:00:1f.2: reg 10: [io  0x1860-0x1867]
[    0.635228] pci 0000:00:1f.2: reg 14: [io  0x1814-0x1817]
[    0.635239] pci 0000:00:1f.2: reg 18: [io  0x1818-0x181f]
[    0.635250] pci 0000:00:1f.2: reg 1c: [io  0x1810-0x1813]
[    0.635261] pci 0000:00:1f.2: reg 20: [io  0x1840-0x185f]
[    0.635273] pci 0000:00:1f.2: reg 24: [mem 0xf2727000-0xf27277ff]
[    0.635320] pci 0000:00:1f.2: PME# supported from D3hot
[    0.635325] pci 0000:00:1f.2: PME# disabled
[    0.635347] pci 0000:00:1f.3: [8086:3b30] type 0 class 0x000c05
[    0.635369] pci 0000:00:1f.3: reg 10: [mem 0xf2728800-0xf27288ff 64bit]
[    0.635399] pci 0000:00:1f.3: reg 20: [io  0x1880-0x189f]
[    0.635446] pci 0000:00:1f.6: [8086:3b32] type 0 class 0x001180
[    0.635474] pci 0000:00:1f.6: reg 10: [mem 0xf2526000-0xf2526fff 64bit]
[    0.635610] pci 0000:00:1c.0: PCI bridge to [bus 0d-0d]
[    0.635752] pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000] (disab=
led)
[    0.635758] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff=
] (disabled)
[    0.635765] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff=
 pref] (disabled)
[    0.635822] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    0.635963] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    0.635968] pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf1ffffff]
[    0.635976] pci 0000:00:1c.3:   bridge window [mem 0xf2800000-0xf28fffff=
 64bit pref]
[    0.636108] pci 0000:02:00.0: [8086:4238] type 0 class 0x000280
[    0.636165] pci 0000:02:00.0: reg 10: [mem 0xf2400000-0xf2401fff 64bit]
[    0.636398] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    0.636425] pci 0000:02:00.0: PME# disabled
[    0.636468] pci 0000:00:1c.4: PCI bridge to [bus 02-02]
[    0.636610] pci 0000:00:1c.4:   bridge window [io  0xf000-0x0000] (disab=
led)
[    0.636615] pci 0000:00:1c.4:   bridge window [mem 0xf2400000-0xf24fffff]
[    0.636622] pci 0000:00:1c.4:   bridge window [mem 0xfff00000-0x000fffff=
 pref] (disabled)
[    0.636696] pci 0000:00:1e.0: PCI bridge to [bus 0e-0e] (subtractive dec=
ode)
[    0.636842] pci 0000:00:1e.0:   bridge window [io  0xf000-0x0000] (disab=
led)
[    0.636847] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff=
] (disabled)
[    0.636855] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff=
 pref] (disabled)
[    0.636857] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtr=
active decode)
[    0.636860] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtr=
active decode)
[    0.636862] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff=
] (subtractive decode)
[    0.636864] pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff=
] (subtractive decode)
[    0.636867] pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff=
] (subtractive decode)
[    0.636869] pci 0000:00:1e.0:   bridge window [mem 0xc0000000-0xfebfffff=
] (subtractive decode)
[    0.636896] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.637020] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
[    0.637060] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP4._PRT]
[    0.637098] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP5._PRT]
[    0.641582] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
[    0.642239] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
[    0.642870] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 11) *0,=
 disabled.
[    0.643686] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
[    0.644335] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
[    0.644965] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11) *0,=
 disabled.
[    0.645770] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11) *0,=
 disabled.
[    0.646587] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
[    0.647294] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.647528] vgaarb: loaded
[    0.647773] SCSI subsystem initialized
[    0.647988] libata version 3.00 loaded.
[    0.648099] PCI: Using ACPI for IRQ routing
[    0.648238] PCI: pci_cache_line_size set to 64 bytes
[    0.648367] reserve RAM buffer: 000000000009e800 - 000000000009ffff=20
[    0.648369] reserve RAM buffer: 00000000bb27c000 - 00000000bbffffff=20
[    0.648375] reserve RAM buffer: 00000000bb363000 - 00000000bbffffff=20
[    0.648380] reserve RAM buffer: 00000000bb470000 - 00000000bbffffff=20
[    0.648384] reserve RAM buffer: 00000000bb717000 - 00000000bbffffff=20
[    0.648388] reserve RAM buffer: 00000000bb76b000 - 00000000bbffffff=20
[    0.648391] reserve RAM buffer: 00000000bb800000 - 00000000bbffffff=20
[    0.648541] NetLabel: Initializing
[    0.648675] NetLabel:  domain hash size =3D 128
[    0.648810] NetLabel:  protocols =3D UNLABELED CIPSOv4
[    0.648956] NetLabel:  unlabeled traffic allowed by default
[    0.649108] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.649622] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.651770] Switching to clocksource hpet
[    0.651933] pnp: PnP ACPI init
[    0.652071] ACPI: bus type pnp registered
[    0.653139] pnp 00:00: [mem 0x00000000-0x0009ffff]
[    0.653142] pnp 00:00: [mem 0x000c0000-0x000c3fff]
[    0.653143] pnp 00:00: [mem 0x000c4000-0x000c7fff]
[    0.653145] pnp 00:00: [mem 0x000c8000-0x000cbfff]
[    0.653147] pnp 00:00: [mem 0x000cc000-0x000cffff]
[    0.653149] pnp 00:00: [mem 0x000d0000-0x000d3fff]
[    0.653151] pnp 00:00: [mem 0x000d4000-0x000d3fff disabled]
[    0.653153] pnp 00:00: [mem 0x000d8000-0x000d7fff disabled]
[    0.653155] pnp 00:00: [mem 0x000dc000-0x000dffff]
[    0.653156] pnp 00:00: [mem 0x000e0000-0x000e3fff]
[    0.653158] pnp 00:00: [mem 0x000e4000-0x000e7fff]
[    0.653160] pnp 00:00: [mem 0x000e8000-0x000ebfff]
[    0.653162] pnp 00:00: [mem 0x000ec000-0x000effff]
[    0.653164] pnp 00:00: [mem 0x000f0000-0x000fffff]
[    0.653166] pnp 00:00: [mem 0x00100000-0xbfffffff]
[    0.653167] pnp 00:00: [mem 0xfec00000-0xfed3ffff]
[    0.653169] pnp 00:00: [mem 0xfed4c000-0xffffffff]
[    0.653251] pnp 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.653268] pnp 00:01: [bus ff]
[    0.653345] pnp 00:01: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.653364] pnp 00:02: [bus 00-fe]
[    0.653367] pnp 00:02: [io  0x0cf8-0x0cff]
[    0.653369] pnp 00:02: [io  0x0000-0x0cf7 window]
[    0.653370] pnp 00:02: [io  0x0d00-0xffff window]
[    0.653372] pnp 00:02: [mem 0x000a0000-0x000bffff window]
[    0.653374] pnp 00:02: [mem 0x000c0000-0x000c3fff window]
[    0.653376] pnp 00:02: [mem 0x000c4000-0x000c7fff window]
[    0.653378] pnp 00:02: [mem 0x000c8000-0x000cbfff window]
[    0.653380] pnp 00:02: [mem 0x000cc000-0x000cffff window]
[    0.653382] pnp 00:02: [mem 0x000d0000-0x000d3fff window]
[    0.653384] pnp 00:02: [mem 0x000d4000-0x000d7fff window]
[    0.653386] pnp 00:02: [mem 0x000d8000-0x000dbfff window]
[    0.653387] pnp 00:02: [mem 0x000dc000-0x000dffff window]
[    0.653389] pnp 00:02: [mem 0x000e0000-0x000e3fff window]
[    0.653391] pnp 00:02: [mem 0x000e4000-0x000e7fff window]
[    0.653393] pnp 00:02: [mem 0x000e8000-0x000ebfff window]
[    0.653395] pnp 00:02: [mem 0x000ec000-0x000effff window]
[    0.653397] pnp 00:02: [mem 0xc0000000-0xfebfffff window]
[    0.653400] pnp 00:02: [mem 0xfed40000-0xfed4bfff window]
[    0.653473] pnp 00:02: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (a=
ctive)
[    0.653790] pnp 00:03: [io  0x0010-0x001f]
[    0.653792] pnp 00:03: [io  0x0090-0x009f]
[    0.653794] pnp 00:03: [io  0x0024-0x0025]
[    0.653795] pnp 00:03: [io  0x0028-0x0029]
[    0.653797] pnp 00:03: [io  0x002c-0x002d]
[    0.653799] pnp 00:03: [io  0x0030-0x0031]
[    0.653800] pnp 00:03: [io  0x0034-0x0035]
[    0.653802] pnp 00:03: [io  0x0038-0x0039]
[    0.653804] pnp 00:03: [io  0x003c-0x003d]
[    0.653805] pnp 00:03: [io  0x00a4-0x00a5]
[    0.653807] pnp 00:03: [io  0x00a8-0x00a9]
[    0.653809] pnp 00:03: [io  0x00ac-0x00ad]
[    0.653810] pnp 00:03: [io  0x00b0-0x00b5]
[    0.653812] pnp 00:03: [io  0x00b8-0x00b9]
[    0.653814] pnp 00:03: [io  0x00bc-0x00bd]
[    0.653815] pnp 00:03: [io  0x0050-0x0053]
[    0.653817] pnp 00:03: [io  0x0072-0x0077]
[    0.653819] pnp 00:03: [io  0x164e-0x164f]
[    0.653820] pnp 00:03: [io  0x002e-0x002f]
[    0.653822] pnp 00:03: [io  0x1000-0x107f]
[    0.653824] pnp 00:03: [io  0x1180-0x11ff]
[    0.653825] pnp 00:03: [io  0x0800-0x080f]
[    0.653827] pnp 00:03: [io  0x15e0-0x15ef]
[    0.653829] pnp 00:03: [io  0x1600-0x1641]
[    0.653830] pnp 00:03: [io  0x1644-0x167f]
[    0.653832] pnp 00:03: [mem 0xe0000000-0xefffffff]
[    0.653834] pnp 00:03: [mem 0xfed1c000-0xfed1ffff]
[    0.653836] pnp 00:03: [mem 0xfed10000-0xfed13fff]
[    0.653838] pnp 00:03: [mem 0xfed18000-0xfed18fff]
[    0.653839] pnp 00:03: [mem 0xfed19000-0xfed19fff]
[    0.653841] pnp 00:03: [mem 0xfed45000-0xfed4bfff]
[    0.653931] pnp 00:03: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.653991] pnp 00:04: [mem 0xfed00000-0xfed003ff]
[    0.654054] pnp 00:04: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.654066] pnp 00:05: [io  0x0000-0x000f]
[    0.654068] pnp 00:05: [io  0x0080-0x008f]
[    0.654069] pnp 00:05: [io  0x00c0-0x00df]
[    0.654071] pnp 00:05: [dma 4]
[    0.654128] pnp 00:05: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.654138] pnp 00:06: [io  0x0061]
[    0.654194] pnp 00:06: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.654205] pnp 00:07: [io  0x00f0]
[    0.654212] pnp 00:07: [irq 13]
[    0.654271] pnp 00:07: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.654282] pnp 00:08: [io  0x0070-0x0071]
[    0.654287] pnp 00:08: [irq 8]
[    0.654346] pnp 00:08: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.654357] pnp 00:09: [io  0x0060]
[    0.654359] pnp 00:09: [io  0x0064]
[    0.654364] pnp 00:09: [irq 1]
[    0.654423] pnp 00:09: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.654437] pnp 00:0a: [irq 12]
[    0.654499] pnp 00:0a: Plug and Play ACPI device, IDs LEN0018 PNP0f13 (a=
ctive)
[    0.654805] pnp 00:0b: [mem 0xfed40000-0xfed44fff]
[    0.654868] pnp 00:0b: Plug and Play ACPI device, IDs SMO1200 PNP0c31 (a=
ctive)
[    0.655401] pnp 00:0c: [mem 0xfeaff000-0xfeafffff]
[    0.655492] pnp 00:0c: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.655605] pnp: PnP ACPI: found 13 devices
[    0.655741] ACPI: ACPI bus type pnp unregistered
[    0.655885] system 00:00: [mem 0x00000000-0x0009ffff] could not be reser=
ved
[    0.656048] system 00:00: [mem 0x000c0000-0x000c3fff] has been reserved
[    0.656191] system 00:00: [mem 0x000c4000-0x000c7fff] has been reserved
[    0.656335] system 00:00: [mem 0x000c8000-0x000cbfff] has been reserved
[    0.656477] system 00:00: [mem 0x000cc000-0x000cffff] has been reserved
[    0.656620] system 00:00: [mem 0x000d0000-0x000d3fff] could not be reser=
ved
[    0.656765] system 00:00: [mem 0x000dc000-0x000dffff] could not be reser=
ved
[    0.656909] system 00:00: [mem 0x000e0000-0x000e3fff] could not be reser=
ved
[    0.657061] system 00:00: [mem 0x000e4000-0x000e7fff] could not be reser=
ved
[    0.657205] system 00:00: [mem 0x000e8000-0x000ebfff] could not be reser=
ved
[    0.657349] system 00:00: [mem 0x000ec000-0x000effff] could not be reser=
ved
[    0.657493] system 00:00: [mem 0x000f0000-0x000fffff] could not be reser=
ved
[    0.657637] system 00:00: [mem 0x00100000-0xbfffffff] could not be reser=
ved
[    0.657782] system 00:00: [mem 0xfec00000-0xfed3ffff] could not be reser=
ved
[    0.657926] system 00:00: [mem 0xfed4c000-0xffffffff] could not be reser=
ved
[    0.658080] system 00:03: [io  0x164e-0x164f] has been reserved
[    0.658222] system 00:03: [io  0x1000-0x107f] has been reserved
[    0.658363] system 00:03: [io  0x1180-0x11ff] has been reserved
[    0.658503] system 00:03: [io  0x0800-0x080f] has been reserved
[    0.658643] system 00:03: [io  0x15e0-0x15ef] has been reserved
[    0.658784] system 00:03: [io  0x1600-0x1641] has been reserved
[    0.658924] system 00:03: [io  0x1644-0x167f] could not be reserved
[    0.659074] system 00:03: [mem 0xe0000000-0xefffffff] has been reserved
[    0.659218] system 00:03: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.659361] system 00:03: [mem 0xfed10000-0xfed13fff] has been reserved
[    0.659505] system 00:03: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.659648] system 00:03: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.659791] system 00:03: [mem 0xfed45000-0xfed4bfff] has been reserved
[    0.659939] system 00:0c: [mem 0xfeaff000-0xfeafffff] has been reserved
[    0.668218] pci 0000:00:1c.0: PCI bridge to [bus 0d-0d]
[    0.668358] pci 0000:00:1c.0:   bridge window [io  disabled]
[    0.668501] pci 0000:00:1c.0:   bridge window [mem disabled]
[    0.668643] pci 0000:00:1c.0:   bridge window [mem pref disabled]
[    0.668789] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    0.668940] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    0.669086] pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf1ffffff]
[    0.669232] pci 0000:00:1c.3:   bridge window [mem 0xf2800000-0xf28fffff=
 64bit pref]
[    0.669464] pci 0000:00:1c.4: PCI bridge to [bus 02-02]
[    0.669602] pci 0000:00:1c.4:   bridge window [io  disabled]
[    0.669747] pci 0000:00:1c.4:   bridge window [mem 0xf2400000-0xf24fffff]
[    0.669893] pci 0000:00:1c.4:   bridge window [mem pref disabled]
[    0.670045] pci 0000:00:1e.0: PCI bridge to [bus 0e-0e]
[    0.670184] pci 0000:00:1e.0:   bridge window [io  disabled]
[    0.670327] pci 0000:00:1e.0:   bridge window [mem disabled]
[    0.670470] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    0.670628] pci 0000:00:1c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    0.670774] pci 0000:00:1c.0: setting latency timer to 64
[    0.670783] pci 0000:00:1c.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    0.670942] pci 0000:00:1c.3: setting latency timer to 64
[    0.670950] pci 0000:00:1c.4: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    0.671095] pci 0000:00:1c.4: setting latency timer to 64
[    0.671103] pci 0000:00:1e.0: setting latency timer to 64
[    0.671108] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.671110] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.671112] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.671114] pci_bus 0000:00: resource 7 [mem 0x000d4000-0x000d7fff]
[    0.671116] pci_bus 0000:00: resource 8 [mem 0x000d8000-0x000dbfff]
[    0.671118] pci_bus 0000:00: resource 9 [mem 0xc0000000-0xfebfffff]
[    0.671120] pci_bus 0000:05: resource 0 [io  0x2000-0x2fff]
[    0.671122] pci_bus 0000:05: resource 1 [mem 0xf0000000-0xf1ffffff]
[    0.671124] pci_bus 0000:05: resource 2 [mem 0xf2800000-0xf28fffff 64bit=
 pref]
[    0.671126] pci_bus 0000:02: resource 1 [mem 0xf2400000-0xf24fffff]
[    0.671128] pci_bus 0000:0e: resource 4 [io  0x0000-0x0cf7]
[    0.671130] pci_bus 0000:0e: resource 5 [io  0x0d00-0xffff]
[    0.671132] pci_bus 0000:0e: resource 6 [mem 0x000a0000-0x000bffff]
[    0.671134] pci_bus 0000:0e: resource 7 [mem 0x000d4000-0x000d7fff]
[    0.671136] pci_bus 0000:0e: resource 8 [mem 0x000d8000-0x000dbfff]
[    0.671138] pci_bus 0000:0e: resource 9 [mem 0xc0000000-0xfebfffff]
[    0.671169] NET: Registered protocol family 2
[    0.671428] IP route cache hash table entries: 131072 (order: 8, 1048576=
 bytes)
[    0.672514] TCP established hash table entries: 524288 (order: 11, 83886=
08 bytes)
[    0.675158] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.675586] TCP: Hash tables configured (established 524288 bind 65536)
[    0.675730] TCP reno registered
[    0.675870] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.676055] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.676331] NET: Registered protocol family 1
[    0.676491] pci 0000:00:02.0: Boot video device
[    0.676621] PCI: CLS 64 bytes, default 64
[    0.676667] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.676810] Placing 64MB software IO TLB between ffff8800b6e7a000 - ffff=
8800bae7a000
[    0.677035] software IO TLB at phys 0xb6e7a000 - 0xbae7a000
[    0.677294] Simple Boot Flag at 0x35 set to 0x80
[    0.678608] microcode: CPU0 sig=3D0x20652, pf=3D0x10, revision=3D0x9
[    0.678755] microcode: CPU1 sig=3D0x20652, pf=3D0x10, revision=3D0x9
[    0.678902] microcode: CPU2 sig=3D0x20652, pf=3D0x10, revision=3D0x9
[    0.679065] microcode: CPU3 sig=3D0x20652, pf=3D0x10, revision=3D0x9
[    0.679253] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.f=
snet.co.uk>, Peter Oruba
[    0.680208] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.684453] VFS: Disk quotas dquot_6.5.2
[    0.684682] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.687620] JFS: nTxBlock =3D 8192, nTxLock =3D 65536
[    0.690069] Btrfs loaded
[    0.690207] msgmni has been set to 7525
[    0.690666] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 254)
[    0.690913] io scheduler noop registered
[    0.691047] io scheduler deadline registered (default)
[    0.692591] intel_idle: MWAIT substates: 0x1120
[    0.692593] intel_idle: v0.4 model 0x25
[    0.692595] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.693270] ACPI: AC Adapter [AC] (on-line)
[    0.693691] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:=
00/input/input0
[    0.694106] ACPI: Lid Switch [LID]
[    0.694316] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0=
E:00/input/input1
[    0.694546] ACPI: Sleep Button [SLPB]
[    0.694753] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input2
[    0.695004] ACPI: Power Button [PWRF]
[    0.695227] ACPI: acpi_idle yielding to intel_idle
[    0.702729] thermal LNXTHERM:00: registered as thermal_zone0
[    0.702895] ACPI: Thermal Zone [THM0] (58 C)
[    0.718688] ACPI: Battery Slot [BAT0] (battery present)
[    0.736516] Linux agpgart interface v0.103
[    0.738406] brd: module loaded
[    0.738538] Uniform Multi-Platform E-IDE driver
[    0.738752] ide-gd driver 1.18
[    0.739113] ahci 0000:00:1f.2: version 3.0
[    0.739133] ahci 0000:00:1f.2: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.739326] ahci 0000:00:1f.2: irq 40 for MSI/MSI-X
[    0.739364] ahci: SSS flag set, parallel bus scan disabled
[    0.739550] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 3 Gbps 0x=
33 impl SATA mode
[    0.739779] ahci 0000:00:1f.2: flags: 64bit ncq sntf ilck stag pm led cl=
o pmp pio slum part ems sxs apst=20
[    0.740024] ahci 0000:00:1f.2: setting latency timer to 64
[    0.746773] scsi0 : ahci
[    0.747051] scsi1 : ahci
[    0.747290] scsi2 : ahci
[    0.747529] scsi3 : ahci
[    0.747776] scsi4 : ahci
[    0.748036] scsi5 : ahci
[    0.748879] ata1: SATA max UDMA/133 abar m2048@0xf2727000 port 0xf272710=
0 irq 40
[    0.749107] ata2: SATA max UDMA/133 abar m2048@0xf2727000 port 0xf272718=
0 irq 40
[    0.749333] ata3: DUMMY
[    0.749462] ata4: DUMMY
[    0.749593] ata5: SATA max UDMA/133 abar m2048@0xf2727000 port 0xf272730=
0 irq 40
[    0.749825] ata6: SATA max UDMA/133 abar m2048@0xf2727000 port 0xf272738=
0 irq 40
[    0.750405] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    0.754259] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.754406] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.754805] mousedev: PS/2 mouse device common for all mice
[    0.755838] cpuidle: using governor ladder
[    0.757019] cpuidle: using governor menu
[    0.757535] TCP cubic registered
[    0.757669] NET: Registered protocol family 17
[    0.757848] Registering the dns_resolver key type
[    0.758488] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input3
[    0.764145] registered taskstats version 1
[    1.209096] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.211710] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succee=
ded
[    1.211717] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK=
) filtered out
[    1.211951] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filter=
ed out
[    1.215935] ata1.00: ATA-8: ST95005620AS, SD23, max UDMA/133
[    1.216096] ata1.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    1.220416] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succee=
ded
[    1.220423] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK=
) filtered out
[    1.220655] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filter=
ed out
[    1.224665] ata1.00: configured for UDMA/133
[    1.224948] scsi 0:0:0:0: Direct-Access     ATA      ST95005620AS     SD=
23 PQ: 0 ANSI: 5
[    1.225703] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB=
/465 GiB)
[    1.226075] sd 0:0:0:0: [sda] Write Protect is off
[    1.226217] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.226244] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    1.227006]  sda: sda1 sda2 sda3 sda4
[    1.228034] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.617374] Synaptics Touchpad, model: 1, fw: 7.4, id: 0x1e0b1, caps: 0x=
d047b3/0xb40000/0xa0000
[    1.617615] serio: Synaptics pass-through port at isa0060/serio1/input0
[    1.669579] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042=
/serio1/input/input4
[    1.677294] Refined TSC clocksource calibration: 2393.999 MHz.
[    1.677451] Switching to clocksource tsc
[    2.101600] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.107332] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
[    2.108324] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
[    2.112157] ata2.00: ATAPI: HL-DT-ST DVDRAM GSA-U20N, HX12, max UDMA/133
[    2.118798] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
[    2.119664] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
[    2.123976] ata2.00: configured for UDMA/133
[    2.241724] scsi 1:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-U20N  HX=
12 PQ: 0 ANSI: 5
[    2.546733] ata5: SATA link down (SStatus 0 SControl 300)
[    2.851271] ata6: SATA link down (SStatus 0 SControl 300)
[    2.854173] REISERFS (device sda1): found reiserfs format "3.6" with sta=
ndard journal
[    2.854423] REISERFS (device sda1): using ordered data mode
[    2.855549] REISERFS (device sda1): journal params: device sda1, size 81=
92, journal first block 18, max trans len 1024, max batch 900, max commit a=
ge 30, max trans age 30
[    2.856387] REISERFS (device sda1): checking transaction log (sda1)
[    2.860079] REISERFS (device sda1): Using r5 hash to sort names
[    2.860480] VFS: Mounted root (reiserfs filesystem) readonly on device 8=
:1.
[    2.862977] Freeing unused kernel memory: 524k freed
[    2.863230] Write protecting the kernel read-only data: 6144k
[    2.866157] Freeing unused kernel memory: 532k freed
[    2.868691] Freeing unused kernel memory: 744k freed
[    8.341157] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[    8.605560] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/seri=
o1/serio2/input/input5
[    9.033379] rtc_cmos 00:08: RTC can wake from S4
[    9.037842] rtc_cmos 00:08: rtc core: registered rtc_cmos as rtc0
[    9.037882] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[   10.050878] udev[1293]: starting version 165
[   10.190973] e1000e: Intel(R) PRO/1000 Network Driver - 1.2.20-k2
[   10.190977] e1000e: Copyright (c) 1999 - 2010 Intel Corporation.
[   10.191017] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ=
 20
[   10.191031] e1000e 0000:00:19.0: setting latency timer to 64
[   10.191205] e1000e 0000:00:19.0: irq 41 for MSI/MSI-X
[   10.253074] usbcore: registered new interface driver usbfs
[   10.253092] usbcore: registered new interface driver hub
[   10.253435] usbcore: registered new device driver usb
[   10.263411] wmi: Mapper loaded
[   10.266285] input: PC Speaker as /devices/platform/pcspkr/input/input6
[   10.267050] Non-volatile memory driver v1.3
[   10.287220] tpm_tis 00:0b: 1.2 TPM (device-id 0x0, rev-id 78)
[   10.302513] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   10.302560] sr 1:0:0:0: Attached scsi generic sg1 type 5
[   10.309042] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 =
cdda tray
[   10.309046] cdrom: Uniform CD-ROM driver Revision: 3.20
[   10.309174] sr 1:0:0:0: Attached scsi CD-ROM sr0
[   10.328627] cfg80211: Calling CRDA to update world regulatory domain
[   10.342734] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   10.354880] thinkpad_acpi: ThinkPad ACPI Extras v0.24
[   10.354883] thinkpad_acpi: http://ibm-acpi.sf.net/
[   10.354885] thinkpad_acpi: ThinkPad BIOS 6QET35WW (1.05 ), EC 6QHT24WW-1=
=2E05
[   10.354887] thinkpad_acpi: Lenovo ThinkPad X201, model 3626A14
[   10.355803] thinkpad_acpi: detected a 8-level brightness capable ThinkPad
[   10.355983] thinkpad_acpi: radio switch found; radios are enabled
[   10.356167] thinkpad_acpi: possible tablet mode switch found; ThinkPad i=
n laptop mode
[   10.359212] thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio is u=
nblocked
[   10.359825] Registered led device: tpacpi::thinklight
[   10.359852] Registered led device: tpacpi::power
[   10.359868] Registered led device: tpacpi:orange:batt
[   10.359881] Registered led device: tpacpi:green:batt
[   10.359905] Registered led device: tpacpi::dock_active
[   10.359919] Registered led device: tpacpi::bay_active
[   10.359938] Registered led device: tpacpi::dock_batt
[   10.359952] Registered led device: tpacpi::unknown_led
[   10.359965] Registered led device: tpacpi::standby
[   10.359978] Registered led device: tpacpi::dock_status1
[   10.359991] Registered led device: tpacpi::dock_status2
[   10.360004] Registered led device: tpacpi::unknown_led2
[   10.360018] Registered led device: tpacpi::unknown_led3
[   10.360032] Registered led device: tpacpi::thinkvantage
[   10.360034] thinkpad_acpi: warning: userspace override of important firm=
ware LEDs is enabled
[   10.362401] thinkpad_acpi: Standard ACPI backlight interface available, =
not loading native one.
[   10.362542] thinkpad_acpi: Console audio control enabled, mode: monitor =
(read only)
[   10.371456] input: ThinkPad Extra Buttons as /devices/platform/thinkpad_=
acpi/input/input7
[   10.382468] Error: Driver 'pcspkr' is already registered, aborting...
[   10.395145] e1000e 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00=
:26:2d:f7:02:12
[   10.395150] e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connect=
ion
[   10.395228] e1000e 0000:00:19.0: eth0: MAC: 9, PHY: 10, PBA No: A002FF-0=
FF
[   10.395334] agpgart-intel 0000:00:00.0: Intel HD Graphics Chipset
[   10.395553] agpgart-intel 0000:00:00.0: detected gtt size: 2097152K tota=
l, 262144K mappable
[   10.396652] agpgart-intel 0000:00:00.0: detected 32768K stolen memory
[   10.466078] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[   10.466112] intel ips 0000:00:1f.6: CPU TDP doesn't match expected value=
 (found 25, expected 29)
[   10.466137] intel ips 0000:00:1f.6: PCI INT D -> GSI 19 (level, low) -> =
IRQ 19
[   10.466292] intel ips 0000:00:1f.6: failed to get i915 symbols, graphics=
 turbo disabled
[   10.466402] intel ips 0000:00:1f.6: IPS driver initialized, MCP temp lim=
it 90
[   10.466427] i801_smbus 0000:00:1f.3: PCI INT A -> GSI 23 (level, low) ->=
 IRQ 23
[   10.466720] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[   10.466884] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[   10.466893] ehci_hcd 0000:00:1a.0: PCI INT D -> GSI 23 (level, low) -> I=
RQ 23
[   10.466915] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[   10.466921] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[   10.466929] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus =
number 1
[   10.471090] ehci_hcd 0000:00:1a.0: debug port 2
[   10.475142] ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
[   10.475168] ehci_hcd 0000:00:1a.0: irq 23, io mem 0xf2728000
[   10.483091] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[   10.483323] hub 1-0:1.0: USB hub found
[   10.483334] hub 1-0:1.0: 3 ports detected
[   10.483748] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[   10.483945] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[   10.483956] ehci_hcd 0000:00:1d.0: PCI INT D -> GSI 19 (level, low) -> I=
RQ 19
[   10.483995] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[   10.483999] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[   10.484019] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus =
number 2
[   10.489107] ehci_hcd 0000:00:1d.0: debug port 2
[   10.493018] ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
[   10.493030] ehci_hcd 0000:00:1d.0: irq 19, io mem 0xf2728400
[   10.502009] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[   10.502187] hub 2-0:1.0: USB hub found
[   10.502191] hub 2-0:1.0: 3 ports detected
[   10.502276] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> =
IRQ 17
[   10.502352] HDA Intel 0000:00:1b.0: irq 42 for MSI/MSI-X
[   10.502406] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   10.569249] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.=
0/input/input8
[   10.591081] [drm] Initialized drm 1.1.0 20060810
[   10.620760] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, in=
-tree:d
[   10.620764] iwlagn: Copyright(c) 2003-2010 Intel Corporation
[   10.620893] iwlagn 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ=
 16
[   10.620932] iwlagn 0000:02:00.0: setting latency timer to 64
[   10.621033] iwlagn 0000:02:00.0: Detected Intel(R) Centrino(R) Ultimate-=
N 6300 AGN, REV=3D0x74
[   10.638946] i915 0000:00:02.0: power state changed by ACPI to D0
[   10.638960] i915 0000:00:02.0: power state changed by ACPI to D0
[   10.638969] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   10.638974] i915 0000:00:02.0: setting latency timer to 64
[   10.644234] iwlagn 0000:02:00.0: device EEPROM VER=3D0x436, CALIB=3D0x6
[   10.644238] iwlagn 0000:02:00.0: Device SKU: 0Xb
[   10.644241] iwlagn 0000:02:00.0: Valid Tx ant: 0X7, Valid Rx ant: 0X7
[   10.644270] iwlagn 0000:02:00.0: Tunable channels: 13 802.11bg, 24 802.1=
1a channels
[   10.644436] iwlagn 0000:02:00.0: irq 43 for MSI/MSI-X
[   10.666837] iwlagn 0000:02:00.0: loaded firmware version 9.193.4.1 build=
 19710
[   10.701520] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
[   10.708653] i915 0000:00:02.0: irq 44 for MSI/MSI-X
[   10.708659] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[   10.708661] [drm] Driver supports precise vblank timestamp query.
[   10.772714] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=
=3Dio+mem,decodes=3Dio+mem:owns=3Dio+mem
[   10.784546] usb 1-1: new high speed USB device using ehci_hcd and addres=
s 2
[   10.898926] hub 1-1:1.0: USB hub found
[   10.899002] hub 1-1:1.0: 6 ports detected
[   10.941475] fb0: inteldrmfb frame buffer device
[   10.941478] drm: registered panic notifier
[   10.951087] acpi device:02: registered as cooling_device4
[   10.951309] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:0=
0/LNXVIDEO:00/input/input9
[   10.951399] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[   10.951877] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on mi=
nor 0
[   11.002192] usb 2-1: new high speed USB device using ehci_hcd and addres=
s 2
[   11.033748] device-mapper: ioctl: 4.18.0-ioctl (2010-06-29) initialised:=
 dm-devel@redhat.com
[   11.116549] hub 2-1:1.0: USB hub found
[   11.116636] hub 2-1:1.0: 8 ports detected
[   11.126795] padlock: VIA PadLock not detected.
[   11.126798] padlock: VIA PadLock Hash Engine not detected.
[   11.191077] usb 1-1.3: new full speed USB device using ehci_hcd and addr=
ess 3
[   11.350798] usb 1-1.4: new full speed USB device using ehci_hcd and addr=
ess 4
[   11.466747] Bluetooth: Core ver 2.15
[   11.466908] NET: Registered protocol family 31
[   11.466911] Bluetooth: HCI device and connection manager initialized
[   11.466914] Bluetooth: HCI socket layer initialized
[   11.482463] Bluetooth: Generic Bluetooth USB driver ver 0.6
[   11.482706] usbcore: registered new interface driver btusb
[   11.513508] usb 1-1.5: new high speed USB device using ehci_hcd and addr=
ess 5
[   11.598979] hub 1-1.5:1.0: USB hub found
[   11.599051] hub 1-1.5:1.0: 4 ports detected
[   11.673242] usb 1-1.6: new high speed USB device using ehci_hcd and addr=
ess 6
[   11.797665] Linux video capture interface: v2.00
[   11.805125] uvcvideo: Found UVC 1.00 device Integrated Camera (17ef:4816)
[   11.806701] input: Integrated Camera as /devices/pci0000:00/0000:00:1a.0=
/usb1/1-1/1-1.6/1-1.6:1.0/input/input10
[   11.806802] usbcore: registered new interface driver uvcvideo
[   11.806806] USB Video Class driver (v1.0.0)
[   11.839010] usb 2-1.1: new high speed USB device using ehci_hcd and addr=
ess 3
[   11.988788] usbcore: registered new interface driver uas
[   11.991641] usbcore: registered new interface driver libusual
[   12.001867] Initializing USB Mass Storage driver...
[   12.002112] scsi6 : usb-storage 2-1.1:1.0
[   12.002272] usbcore: registered new interface driver usb-storage
[   12.002278] USB Mass Storage support registered.
[   13.002652] scsi 6:0:0:0: Direct-Access     Generic- Multi-Card       1.=
00 PQ: 0 ANSI: 0 CCS
[   13.003006] sd 6:0:0:0: Attached scsi generic sg2 type 0
[   13.939094] sd 6:0:0:0: [sdb] 15757312 512-byte logical blocks: (8.06 GB=
/7.51 GiB)
[   13.939982] sd 6:0:0:0: [sdb] Write Protect is off
[   13.939988] sd 6:0:0:0: [sdb] Mode Sense: 03 00 00 00
[   13.941470] sd 6:0:0:0: [sdb] No Caching mode page present
[   13.941477] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[   13.945673] sd 6:0:0:0: [sdb] No Caching mode page present
[   13.945680] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[   13.946587]  sdb: sdb1
[   13.949675] sd 6:0:0:0: [sdb] No Caching mode page present
[   13.949683] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[   13.949689] sd 6:0:0:0: [sdb] Attached SCSI removable disk
[   15.658714] intel ips 0000:00:1f.6: i915 driver attached, reenabling gpu=
 turbo
[   17.558124] usb 1-1.5.4: new high speed USB device using ehci_hcd and ad=
dress 7
[   17.645090] usb-storage 1-1.5.4:1.0: Quirks match for vid 1058 pid 0704:=
 8000
[   17.645133] scsi7 : usb-storage 1-1.5.4:1.0
[   18.644030] scsi 7:0:0:0: Direct-Access     WD       5000BMV External 1.=
75 PQ: 0 ANSI: 4
[   18.644319] sd 7:0:0:0: Attached scsi generic sg3 type 0
[   18.644812] sd 7:0:0:0: [sdc] 976773168 512-byte logical blocks: (500 GB=
/465 GiB)
[   18.646037] sd 7:0:0:0: [sdc] Write Protect is off
[   18.646047] sd 7:0:0:0: [sdc] Mode Sense: 23 00 00 00
[   18.646823] sd 7:0:0:0: [sdc] No Caching mode page present
[   18.646831] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[   18.649069] sd 7:0:0:0: [sdc] No Caching mode page present
[   18.649074] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[   18.683207]  sdc: unknown partition table
[   18.685509] sd 7:0:0:0: [sdc] No Caching mode page present
[   18.685515] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[   18.685520] sd 7:0:0:0: [sdc] Attached SCSI disk
[   20.737727] REISERFS (device dm-1): found reiserfs format "3.6" with sta=
ndard journal
[   20.737766] REISERFS (device dm-1): using ordered data mode
[   20.740686] REISERFS (device dm-1): journal params: device dm-1, size 81=
92, journal first block 18, max trans len 1024, max batch 900, max commit a=
ge 30, max trans age 30
[   20.741130] REISERFS (device dm-1): checking transaction log (dm-1)
[   20.816566] REISERFS (device dm-1): Using r5 hash to sort names
[   23.314754] ------------[ cut here ]------------
[   23.314768] WARNING: at kernel/printk.c:429 do_syslog+0x427/0x452()
[   23.314772] Hardware name: 3626A14
[   23.314775] Attempt to access syslog with CAP_SYS_ADMIN but no CAP_SYSLO=
G (deprecated and denied).
[   23.314779] Modules linked in: usb_storage usb_libusual uas uvcvideo vid=
eodev v4l2_compat_ioctl32 btusb bluetooth sha256_generic aesni_intel cryptd=
 aes_x86_64 aes_generic cbc dm_crypt dm_mod arc4 ecb i915 iwlagn drm_kms_he=
lper drm snd_hda_codec_hdmi snd_hda_codec_conexant fb iwlcore fbdev snd_hda=
_intel snd_hda_codec snd_pcm_oss snd_mixer_oss i2c_algo_bit snd_hwdep mac80=
211 cfbcopyarea thinkpad_acpi hwmon ehci_hcd video snd_pcm cfg80211 snd_tim=
er backlight sg i2c_i801 snd sr_mod cdrom tpm_tis joydev tpm soundcore inte=
l_ips rfkill tpm_bios nvram pcspkr output wmi mac_hid snd_page_alloc i2c_co=
re intel_agp usbcore kvm_intel cfbimgblt cfbfillrect e1000e kvm intel_gtt r=
tc_cmos rtc_core rtc_lib
[   23.314876] Pid: 2074, comm: syslog-ng Not tainted 2.6.37-05761-gf878133=
 #55
[   23.314880] Call Trace:
[   23.314899]  [<ffffffff8103969c>] ? warn_slowpath_common+0x80/0x98
[   23.314908]  [<ffffffff8111b9e4>] ? kmsg_release+0x0/0x18
[   23.314913]  [<ffffffff81039748>] ? warn_slowpath_fmt+0x41/0x43
[   23.314920]  [<ffffffff81039fb8>] ? do_syslog+0x427/0x452
[   23.314926]  [<ffffffff8103279b>] ? get_parent_ip+0x11/0x41
[   23.314931]  [<ffffffff8103279b>] ? get_parent_ip+0x11/0x41
[   23.314937]  [<ffffffff8111b9e4>] ? kmsg_release+0x0/0x18
[   23.314943]  [<ffffffff8111ba13>] ? kmsg_open+0x17/0x19
[   23.314950]  [<ffffffff8111298f>] ? proc_reg_open+0xa3/0x144
[   23.314955]  [<ffffffff8111b9fc>] ? kmsg_open+0x0/0x19
[   23.314961]  [<ffffffff811128ec>] ? proc_reg_open+0x0/0x144
[   23.314969]  [<ffffffff810cb22c>] ? __dentry_open+0x168/0x282
[   23.314974]  [<ffffffff8103285d>] ? sub_preempt_count+0x92/0xa5
[   23.314980]  [<ffffffff810cbf77>] ? nameidata_to_filp+0x50/0x57
[   23.314987]  [<ffffffff810d7f8e>] ? finish_open+0x9d/0x16a
[   23.314992]  [<ffffffff810d7900>] ? do_path_lookup+0x8b/0xf2
[   23.314997]  [<ffffffff810d84c6>] ? do_filp_open+0x189/0x707
[   23.315003]  [<ffffffff8103279b>] ? get_parent_ip+0x11/0x41
[   23.315009]  [<ffffffff8103279b>] ? get_parent_ip+0x11/0x41
[   23.315014]  [<ffffffff8103279b>] ? get_parent_ip+0x11/0x41
[   23.315019]  [<ffffffff8103285d>] ? sub_preempt_count+0x92/0xa5
[   23.315027]  [<ffffffff81373432>] ? _raw_spin_unlock+0x10/0x2b
[   23.315033]  [<ffffffff810e296a>] ? alloc_fd+0x106/0x118
[   23.315040]  [<ffffffff811ef93d>] ? strncpy_from_user+0x34/0x37
[   23.315046]  [<ffffffff810cbfd9>] ? do_sys_open+0x5b/0xf4
[   23.315051]  [<ffffffff810cc08d>] ? sys_open+0x1b/0x1d
[   23.315057]  [<ffffffff8100293b>] ? system_call_fastpath+0x16/0x1b
[   23.315062] ---[ end trace 135c66c68e2b8408 ]---
[   23.546382] sshd (2101): /proc/2101/oom_adj is deprecated, please use /p=
roc/2101/oom_score_adj instead.
[   24.640406] NET: Registered protocol family 10
[   24.640885] lo: Disabled Privacy Extensions
[   34.189023] Console: switching to colour frame buffer device 160x50
[   67.426167] e1000e 0000:00:19.0: irq 41 for MSI/MSI-X
[   67.476916] e1000e 0000:00:19.0: irq 41 for MSI/MSI-X
[   67.477538] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   69.046169] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Contr=
ol: RX
[   69.046178] e1000e 0000:00:19.0: eth0: 10/100 speed: disabling TSO
[   69.046836] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   79.594909] eth0: no IPv6 routers present
[70565.031136] usb 2-1.2: new high speed USB device using ehci_hcd and addr=
ess 4
[70565.121295] scsi8 : usb-storage 2-1.2:1.0
[70566.120670] scsi 8:0:0:0: Direct-Access              USB DRIVE        2.=
00 PQ: 0 ANSI: 2
[70566.121060] sd 8:0:0:0: Attached scsi generic sg4 type 0
[70567.318427] ready
[70567.318970] sd 8:0:0:0: [sdd] 512000 512-byte logical blocks: (262 MB/25=
0 MiB)
[70567.319957] sd 8:0:0:0: [sdd] Write Protect is off
[70567.319964] sd 8:0:0:0: [sdd] Mode Sense: 03 00 00 00
[70567.321578] sd 8:0:0:0: [sdd] No Caching mode page present
[70567.321584] sd 8:0:0:0: [sdd] Assuming drive cache: write through
[70567.326532] sd 8:0:0:0: [sdd] No Caching mode page present
[70567.326537] sd 8:0:0:0: [sdd] Assuming drive cache: write through
[70567.327763]  sdd: sdd1
[70567.330002] sd 8:0:0:0: [sdd] No Caching mode page present
[70567.330008] sd 8:0:0:0: [sdd] Assuming drive cache: write through
[70567.330014] sd 8:0:0:0: [sdd] Attached SCSI removable disk
[70616.988532] usb 2-1.2: USB disconnect, address 4
[74338.765163] ata2.00: disabled
[74338.765377] ACPI: \_SB_.GDCK - undocking
[74338.765626] ata2.00: detaching (SCSI 1:0:0:0)
[74338.767298] ata2: exception Emask 0x10 SAct 0x0 SErr 0x4090000 action 0x=
e frozen
[74338.767306] ata2: irq_stat 0x004000c0, connection status changed
[74338.767314] ata2: SError: { PHYRdyChg 10B8B DevExch }
[74338.767333] ata2: hard resetting link
[74338.939000] usb 1-1.5: USB disconnect, address 5
[74338.939005] usb 1-1.5.4: USB disconnect, address 7
[74339.488369] ata2: SATA link down (SStatus 0 SControl 300)
[74339.488386] ata2: EH complete
[74340.472341] usb 1-1.4: USB disconnect, address 4
[74340.475309] PM: Syncing filesystems ... done.
[74340.762212] Freezing user space processes ... (elapsed 0.01 seconds) don=
e.
[74340.773168] Freezing remaining freezable tasks ... (elapsed 0.01 seconds=
) done.
[74340.784299] Suspending console(s) (use no_console_suspend to debug)
[74340.969073] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[74341.025997] ACPI handle has no context!
[74341.217730] ehci_hcd 0000:00:1d.0: PCI INT D disabled
[74341.217759] ehci_hcd 0000:00:1a.0: PCI INT D disabled
[74341.315704] sd 0:0:0:0: [sda] Stopping disk
[74341.404629] e1000e 0000:00:19.0: PCI INT A disabled
[74341.404636] e1000e 0000:00:19.0: PME# enabled
[74341.404645] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
[74341.419229] HDA Intel 0000:00:1b.0: PCI INT B disabled
[74344.229177] i915 0000:00:02.0: power state changed by ACPI to D3
[74344.229367] PM: suspend of devices complete after 3450.733 msecs
[74344.253143] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D3
[74344.266153] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D3
[74344.266284] PM: late suspend of devices complete after 36.975 msecs
[74344.266411] ACPI: Preparing to enter system sleep state S3
[74344.314100] PM: Saving platform NVS memory
[74344.457245] Disabling non-boot CPUs ...
[74344.471438] CPU 1 is now offline
[74344.483147] CPU 2 is now offline
[74344.498859] CPU 3 is now offline
[74344.499221] Extended CMOS year: 2000
[74344.499499] Back to C!
[74344.499502] PM: Restoring platform NVS memory
[74344.636873] Extended CMOS year: 2000
[74344.636929] Enabling non-boot CPUs ...
[74344.638320] Booting Node 0 Processor 1 APIC 0x1
[74344.746262] CPU1 is up
[74344.746353] Booting Node 0 Processor 2 APIC 0x4
[74344.854057] CPU2 is up
[74344.854144] Booting Node 0 Processor 3 APIC 0x5
[74344.962017] CPU3 is up
[74344.962982] ACPI: Waking up from system sleep state S3
[74345.049025] thinkpad_acpi: EC reports that Thermal Table has changed
[74345.061802] agpgart-intel 0000:00:00.0: restoring config space at offset=
 0x1 (was 0x900006, writing 0x20900006)
[74345.061820] i915 0000:00:02.0: restoring config space at offset 0x1 (was=
 0x900007, writing 0x900407)
[74345.061933] ehci_hcd 0000:00:1a.0: restoring config space at offset 0xf =
(was 0x400, writing 0x40b)
[74345.061953] ehci_hcd 0000:00:1a.0: restoring config space at offset 0x4 =
(was 0x0, writing 0xf2728000)
[74345.061961] ehci_hcd 0000:00:1a.0: restoring config space at offset 0x1 =
(was 0x2900000, writing 0x2900102)
[74345.080641] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[74345.082664] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[74345.082762] pci 0000:00:1c.0: restoring config space at offset 0x7 (was =
0xf0, writing 0x200000f0)
[74345.082860] pci 0000:00:1c.4: restoring config space at offset 0xf (was =
0x100, writing 0x4010b)
[74345.082872] pci 0000:00:1c.4: restoring config space at offset 0x9 (was =
0x10001, writing 0x1fff1)
[74345.082878] pci 0000:00:1c.4: restoring config space at offset 0x8 (was =
0x0, writing 0xf240f240)
[74345.082883] pci 0000:00:1c.4: restoring config space at offset 0x7 (was =
0x0, writing 0x200000f0)
[74345.082892] pci 0000:00:1c.4: restoring config space at offset 0x3 (was =
0x810000, writing 0x810010)
[74345.082899] pci 0000:00:1c.4: restoring config space at offset 0x1 (was =
0x100000, writing 0x100107)
[74345.082933] ehci_hcd 0000:00:1d.0: restoring config space at offset 0xf =
(was 0x400, writing 0x40b)
[74345.082952] ehci_hcd 0000:00:1d.0: restoring config space at offset 0x4 =
(was 0x0, writing 0xf2728400)
[74345.082960] ehci_hcd 0000:00:1d.0: restoring config space at offset 0x1 =
(was 0x2900000, writing 0x2900102)
[74345.084663] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[74345.086657] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[74345.086783] ahci 0000:00:1f.2: restoring config space at offset 0x1 (was=
 0x2b00007, writing 0x2b00407)
[74345.086853] intel ips 0000:00:1f.6: restoring config space at offset 0xf=
 (was 0x400, writing 0x40b)
[74345.086876] intel ips 0000:00:1f.6: restoring config space at offset 0x1=
 (was 0x100000, writing 0x100002)
[74345.087160] PM: early resume of devices complete after 25.496 msecs
[74345.087438] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[74345.087447] e1000e 0000:00:19.0: PME# disabled
[74345.087474] i915 0000:00:02.0: power state changed by ACPI to D0
[74345.087541] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> =
IRQ 17
[74345.087550] pci 0000:00:1c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[74345.087553] HDA Intel 0000:00:1b.0: setting latency timer to 64
[74345.087556] pci 0000:00:1c.0: setting latency timer to 64
[74345.087600] HDA Intel 0000:00:1b.0: irq 41 for MSI/MSI-X
[74345.087648] pci 0000:00:1c.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[74345.087654] pci 0000:00:1c.3: setting latency timer to 64
[74345.087660] pci 0000:00:1c.4: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[74345.087667] pci 0000:00:1c.4: setting latency timer to 64
[74345.087710] pci 0000:00:1e.0: setting latency timer to 64
[74345.087750] e1000e 0000:00:19.0: irq 42 for MSI/MSI-X
[74345.087757] ahci 0000:00:1f.2: setting latency timer to 64
[74345.089546] sd 0:0:0:0: [sda] Starting disk
[74345.089649] i915 0000:00:02.0: power state changed by ACPI to D0
[74345.089655] i915 0000:00:02.0: setting latency timer to 64
[74345.089715] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[74345.089881] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[74345.089889] ehci_hcd 0000:00:1a.0: PCI INT D -> GSI 23 (level, low) -> I=
RQ 23
[74345.089897] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[74345.090649] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[74345.090807] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[74345.090814] ehci_hcd 0000:00:1d.0: PCI INT D -> GSI 19 (level, low) -> I=
RQ 19
[74345.090823] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[74345.305444] usb 1-1.3: reset full speed USB device using ehci_hcd and ad=
dress 3
[74345.394104] ata6: SATA link down (SStatus 0 SControl 300)
[74345.396106] ata5: SATA link down (SStatus 0 SControl 300)
[74345.398102] ata2: SATA link down (SStatus 0 SControl 300)
[74345.463171] usb 1-1.6: reset high speed USB device using ehci_hcd and ad=
dress 6
[74345.624728] usb 2-1.1: reset high speed USB device using ehci_hcd and ad=
dress 3
[74346.717058] Synaptics Touchpad, model: 1, fw: 7.4, id: 0x1e0b1, caps: 0x=
d047b3/0xb40000/0xa0000
[74346.717066] serio: Synaptics pass-through port at isa0060/serio1/input0
[74346.767995] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042=
/serio1/input/input11
[74348.550606] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[74348.552943] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succee=
ded
[74348.552950] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK=
) filtered out
[74348.552956] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filter=
ed out
[74348.561552] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succee=
ded
[74348.561559] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK=
) filtered out
[74348.561565] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filter=
ed out
[74348.565727] ata1.00: configured for UDMA/133
[74348.663110] PM: resume of devices complete after 3582.041 msecs
[74348.663900] Restarting tasks ... done.
[74348.665021] video LNXVIDEO:00: Restoring backlight state
[74349.101910] usb 1-1.4: new full speed USB device using ehci_hcd and addr=
ess 8
[74353.414754] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[74353.675127] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/seri=
o1/serio3/input/input12
[74672.160452] PM: Syncing filesystems ... done.
[74672.207675] usb 1-1.4: USB disconnect, address 8
[74672.442238] Freezing user space processes ... (elapsed 0.01 seconds) don=
e.
[74672.453225] Freezing remaining freezable tasks ... (elapsed 0.01 seconds=
) done.
[74672.464311] Suspending console(s) (use no_console_suspend to debug)
[74672.656974] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[74672.657170] sd 0:0:0:0: [sda] Stopping disk
[74672.713522] ACPI handle has no context!
[74672.904664] ehci_hcd 0000:00:1d.0: PCI INT D disabled
[74672.904702] ehci_hcd 0000:00:1a.0: PCI INT D disabled
[74672.904705] HDA Intel 0000:00:1b.0: PCI INT B disabled
[74673.092160] e1000e 0000:00:19.0: PME# enabled
[74673.092170] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
[74675.916201] i915 0000:00:02.0: power state changed by ACPI to D3
[74675.916360] PM: suspend of devices complete after 3457.691 msecs
[74675.945148] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D3
[74675.962185] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D3
[74675.962301] PM: late suspend of devices complete after 46.015 msecs
[74675.962472] ACPI: Preparing to enter system sleep state S3
[74676.010122] PM: Saving platform NVS memory
[74676.143877] Disabling non-boot CPUs ...
[74676.158526] CPU 1 is now offline
[74676.174227] CPU 2 is now offline
[74676.188849] CPU 3 is now offline
[74676.189189] Extended CMOS year: 2000
[74676.189468] Back to C!
[74676.189471] PM: Restoring platform NVS memory
[74676.326859] Extended CMOS year: 2000
[74676.326914] Enabling non-boot CPUs ...
[74676.328372] Booting Node 0 Processor 1 APIC 0x1
[74676.436330] CPU1 is up
[74676.436420] Booting Node 0 Processor 2 APIC 0x4
[74676.544142] CPU2 is up
[74676.544247] Booting Node 0 Processor 3 APIC 0x5
[74676.652075] CPU3 is up
[74676.653066] ACPI: Waking up from system sleep state S3
[74676.729902] i915 0000:00:02.0: restoring config space at offset 0x1 (was=
 0x900007, writing 0x900407)
[74676.730016] ehci_hcd 0000:00:1a.0: restoring config space at offset 0xf =
(was 0x400, writing 0x40b)
[74676.730036] ehci_hcd 0000:00:1a.0: restoring config space at offset 0x4 =
(was 0x0, writing 0xf2728000)
[74676.730044] ehci_hcd 0000:00:1a.0: restoring config space at offset 0x1 =
(was 0x2900000, writing 0x2900102)
[74676.740718] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[74676.742764] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[74676.742956] pci 0000:00:1c.4: restoring config space at offset 0xf (was =
0x100, writing 0x4010b)
[74676.742969] pci 0000:00:1c.4: restoring config space at offset 0x9 (was =
0x10001, writing 0x1fff1)
[74676.742974] pci 0000:00:1c.4: restoring config space at offset 0x8 (was =
0x0, writing 0xf240f240)
[74676.742980] pci 0000:00:1c.4: restoring config space at offset 0x7 (was =
0x0, writing 0xf0)
[74676.742990] pci 0000:00:1c.4: restoring config space at offset 0x3 (was =
0x810000, writing 0x810010)
[74676.742997] pci 0000:00:1c.4: restoring config space at offset 0x1 (was =
0x100000, writing 0x100107)
[74676.743030] ehci_hcd 0000:00:1d.0: restoring config space at offset 0xf =
(was 0x400, writing 0x40b)
[74676.743049] ehci_hcd 0000:00:1d.0: restoring config space at offset 0x4 =
(was 0x0, writing 0xf2728400)
[74676.743058] ehci_hcd 0000:00:1d.0: restoring config space at offset 0x1 =
(was 0x2900000, writing 0x2900102)
[74676.744764] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[74676.746756] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[74676.746882] ahci 0000:00:1f.2: restoring config space at offset 0x1 (was=
 0x2b00007, writing 0x2b00407)
[74676.746952] intel ips 0000:00:1f.6: restoring config space at offset 0xf=
 (was 0x400, writing 0x40b)
[74676.746976] intel ips 0000:00:1f.6: restoring config space at offset 0x1=
 (was 0x100000, writing 0x100002)
[74676.747061] iwlagn 0000:02:00.0: restoring config space at offset 0x1 (w=
as 0x100106, writing 0x100506)
[74676.747263] PM: early resume of devices complete after 17.502 msecs
[74676.747545] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[74676.747552] e1000e 0000:00:19.0: PME# disabled
[74676.747616] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> =
IRQ 17
[74676.747625] HDA Intel 0000:00:1b.0: setting latency timer to 64
[74676.747673] HDA Intel 0000:00:1b.0: irq 41 for MSI/MSI-X
[74676.747716] pci 0000:00:1c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[74676.747721] pci 0000:00:1c.0: setting latency timer to 64
[74676.747741] pci 0000:00:1c.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[74676.747747] pci 0000:00:1c.3: setting latency timer to 64
[74676.747756] pci 0000:00:1c.4: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[74676.747762] pci 0000:00:1c.4: setting latency timer to 64
[74676.747857] e1000e 0000:00:19.0: irq 42 for MSI/MSI-X
[74676.748631] pci 0000:00:1e.0: setting latency timer to 64
[74676.748703] ahci 0000:00:1f.2: setting latency timer to 64
[74676.748824] sd 0:0:0:0: [sda] Starting disk
[74676.748901] i915 0000:00:02.0: power state changed by ACPI to D0
[74676.748981] i915 0000:00:02.0: power state changed by ACPI to D0
[74676.748991] i915 0000:00:02.0: setting latency timer to 64
[74676.749027] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[74676.749179] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[74676.749186] ehci_hcd 0000:00:1a.0: PCI INT D -> GSI 23 (level, low) -> I=
RQ 23
[74676.749193] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[74676.751116] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[74676.751278] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[74676.751287] ehci_hcd 0000:00:1d.0: PCI INT D -> GSI 19 (level, low) -> I=
RQ 19
[74676.751294] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[74676.964475] usb 1-1.3: reset full speed USB device using ehci_hcd and ad=
dress 3
[74677.055142] ata2: SATA link down (SStatus 0 SControl 300)
[74677.057147] ata6: SATA link down (SStatus 0 SControl 300)
[74677.059192] ata5: SATA link down (SStatus 0 SControl 300)
[74677.122188] usb 1-1.6: reset high speed USB device using ehci_hcd and ad=
dress 6
[74677.283942] usb 2-1.1: reset high speed USB device using ehci_hcd and ad=
dress 3
[74678.382386] Synaptics Touchpad, model: 1, fw: 7.4, id: 0x1e0b1, caps: 0x=
d047b3/0xb40000/0xa0000
[74678.382394] serio: Synaptics pass-through port at isa0060/serio1/input0
[74678.433795] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042=
/serio1/input/input13
[74680.211686] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[74680.214032] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succee=
ded
[74680.214039] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK=
) filtered out
[74680.214045] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filter=
ed out
[74680.222711] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succee=
ded
[74680.222718] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK=
) filtered out
[74680.222724] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filter=
ed out
[74680.226949] ata1.00: configured for UDMA/133
[74680.337214] PM: resume of devices complete after 3596.061 msecs
[74680.337923] Restarting tasks ... done.
[74680.339464] video LNXVIDEO:00: Restoring backlight state
[74680.750955] usb 1-1.4: new full speed USB device using ehci_hcd and addr=
ess 9
[74685.090883] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[74685.353870] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/seri=
o1/serio4/input/input14
[74700.517684] usb 1-1.4: USB disconnect, address 9
[74700.739557] PM: Syncing filesystems ... done.
[74701.153534] Freezing user space processes ... (elapsed 0.01 seconds) don=
e.
[74701.164633] Freezing remaining freezable tasks ... (elapsed 0.01 seconds=
) done.
[74701.175723] Suspending console(s) (use no_console_suspend to debug)
[74701.362430] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[74701.417120] ACPI handle has no context!
[74701.603024] ehci_hcd 0000:00:1d.0: PCI INT D disabled
[74701.603030] ehci_hcd 0000:00:1a.0: PCI INT D disabled
[74701.603039] HDA Intel 0000:00:1b.0: PCI INT B disabled
[74701.790392] e1000e 0000:00:19.0: PME# enabled
[74701.790400] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
[74701.993891] sd 0:0:0:0: [sda] Stopping disk
[74704.614643] i915 0000:00:02.0: power state changed by ACPI to D3
[74704.614795] PM: suspend of devices complete after 3444.698 msecs
[74704.643614] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D3
[74704.660607] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D3
[74704.660725] PM: late suspend of devices complete after 46.004 msecs
[74704.660883] ACPI: Preparing to enter system sleep state S3
[74704.708562] PM: Saving platform NVS memory
[74704.842128] Disabling non-boot CPUs ...
[74704.856912] CPU 1 is now offline
[74704.873611] CPU 2 is now offline
[74704.889253] CPU 3 is now offline
[74704.889600] Extended CMOS year: 2000
[74704.889878] Back to C!
[74704.889881] PM: Restoring platform NVS memory
[74705.027277] Extended CMOS year: 2000
[74705.027333] Enabling non-boot CPUs ...
[74705.028808] Booting Node 0 Processor 1 APIC 0x1
[74705.136762] CPU1 is up
[74705.136849] Booting Node 0 Processor 2 APIC 0x4
[74705.244577] CPU2 is up
[74705.244681] Booting Node 0 Processor 3 APIC 0x5
[74705.352531] CPU3 is up
[74705.353519] ACPI: Waking up from system sleep state S3
[74705.430327] i915 0000:00:02.0: restoring config space at offset 0x1 (was=
 0x900007, writing 0x900407)
[74705.430443] ehci_hcd 0000:00:1a.0: restoring config space at offset 0xf =
(was 0x400, writing 0x40b)
[74705.430462] ehci_hcd 0000:00:1a.0: restoring config space at offset 0x4 =
(was 0x0, writing 0xf2728000)
[74705.430471] ehci_hcd 0000:00:1a.0: restoring config space at offset 0x1 =
(was 0x2900000, writing 0x2900102)
[74705.441151] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[74705.443203] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[74705.443394] pci 0000:00:1c.4: restoring config space at offset 0xf (was =
0x100, writing 0x4010b)
[74705.443407] pci 0000:00:1c.4: restoring config space at offset 0x9 (was =
0x10001, writing 0x1fff1)
[74705.443412] pci 0000:00:1c.4: restoring config space at offset 0x8 (was =
0x0, writing 0xf240f240)
[74705.443418] pci 0000:00:1c.4: restoring config space at offset 0x7 (was =
0x0, writing 0xf0)
[74705.443427] pci 0000:00:1c.4: restoring config space at offset 0x3 (was =
0x810000, writing 0x810010)
[74705.443434] pci 0000:00:1c.4: restoring config space at offset 0x1 (was =
0x100000, writing 0x100107)
[74705.443468] ehci_hcd 0000:00:1d.0: restoring config space at offset 0xf =
(was 0x400, writing 0x40b)
[74705.443487] ehci_hcd 0000:00:1d.0: restoring config space at offset 0x4 =
(was 0x0, writing 0xf2728400)
[74705.443495] ehci_hcd 0000:00:1d.0: restoring config space at offset 0x1 =
(was 0x2900000, writing 0x2900102)
[74705.445197] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[74705.447196] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[74705.447321] ahci 0000:00:1f.2: restoring config space at offset 0x1 (was=
 0x2b00007, writing 0x2b00407)
[74705.447391] intel ips 0000:00:1f.6: restoring config space at offset 0xf=
 (was 0x400, writing 0x40b)
[74705.447414] intel ips 0000:00:1f.6: restoring config space at offset 0x1=
 (was 0x100000, writing 0x100002)
[74705.447499] iwlagn 0000:02:00.0: restoring config space at offset 0x1 (w=
as 0x100106, writing 0x100506)
[74705.447702] PM: early resume of devices complete after 17.513 msecs
[74705.448003] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[74705.448010] e1000e 0000:00:19.0: PME# disabled
[74705.448054] pci 0000:00:1c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[74705.448060] pci 0000:00:1c.0: setting latency timer to 64
[74705.448073] pci 0000:00:1c.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[74705.448078] pci 0000:00:1c.3: setting latency timer to 64
[74705.448090] pci 0000:00:1c.4: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[74705.448098] pci 0000:00:1c.4: setting latency timer to 64
[74705.448115] i915 0000:00:02.0: power state changed by ACPI to D0
[74705.448150] pci 0000:00:1e.0: setting latency timer to 64
[74705.448204] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> =
IRQ 17
[74705.448215] HDA Intel 0000:00:1b.0: setting latency timer to 64
[74705.448291] HDA Intel 0000:00:1b.0: irq 41 for MSI/MSI-X
[74705.448308] e1000e 0000:00:19.0: irq 42 for MSI/MSI-X
[74705.448361] ahci 0000:00:1f.2: setting latency timer to 64
[74705.448504] sd 0:0:0:0: [sda] Starting disk
[74705.448630] i915 0000:00:02.0: power state changed by ACPI to D0
[74705.448636] i915 0000:00:02.0: setting latency timer to 64
[74705.448707] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[74705.448857] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[74705.448866] ehci_hcd 0000:00:1a.0: PCI INT D -> GSI 23 (level, low) -> I=
RQ 23
[74705.448873] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[74705.449057] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[74705.449215] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[74705.449222] ehci_hcd 0000:00:1d.0: PCI INT D -> GSI 19 (level, low) -> I=
RQ 19
[74705.449231] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[74705.663904] usb 1-1.6: reset high speed USB device using ehci_hcd and ad=
dress 6
[74705.754571] ata5: SATA link down (SStatus 0 SControl 300)
[74705.756569] ata6: SATA link down (SStatus 0 SControl 300)
[74705.758568] ata2: SATA link down (SStatus 0 SControl 300)
[74705.825613] usb 1-1.3: reset full speed USB device using ehci_hcd and ad=
dress 3
[74705.983349] usb 2-1.1: reset high speed USB device using ehci_hcd and ad=
dress 3
[74707.072448] Synaptics Touchpad, model: 1, fw: 7.4, id: 0x1e0b1, caps: 0x=
d047b3/0xb40000/0xa0000
[74707.072456] serio: Synaptics pass-through port at isa0060/serio1/input0
[74707.122645] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042=
/serio1/input/input15
[74709.012963] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[74709.015312] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succee=
ded
[74709.015319] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK=
) filtered out
[74709.015324] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filter=
ed out
[74709.023865] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succee=
ded
[74709.023872] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK=
) filtered out
[74709.023877] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filter=
ed out
[74709.028073] ata1.00: configured for UDMA/133
[74709.133840] PM: resume of devices complete after 3692.419 msecs
[74709.134576] Restarting tasks ... done.
[74709.136205] video LNXVIDEO:00: Restoring backlight state
[74709.715907] usb 1-1.4: new full speed USB device using ehci_hcd and addr=
ess 10
[74713.752866] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[74714.019968] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/seri=
o1/serio5/input/input16
[75435.072882] usb 1-1.4: USB disconnect, address 10
[75435.073708] PM: Syncing filesystems ... done.
[75435.475490] Freezing user space processes ... (elapsed 0.01 seconds) don=
e.
[75435.486509] Freezing remaining freezable tasks ... (elapsed 0.01 seconds=
) done.
[75435.497611] Suspending console(s) (use no_console_suspend to debug)
[75435.690322] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[75435.744269] ACPI handle has no context!
[75435.935941] ehci_hcd 0000:00:1d.0: PCI INT D disabled
[75435.935971] ehci_hcd 0000:00:1a.0: PCI INT D disabled
[75435.935984] HDA Intel 0000:00:1b.0: PCI INT B disabled
[75436.116270] sd 0:0:0:0: [sda] Stopping disk
[75436.122910] e1000e 0000:00:19.0: PME# enabled
[75436.122919] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
[75438.947494] i915 0000:00:02.0: power state changed by ACPI to D3
[75438.947635] PM: suspend of devices complete after 3455.670 msecs
[75438.976438] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D3
[75438.993495] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D3
[75438.993608] PM: late suspend of devices complete after 46.047 msecs
[75438.993750] ACPI: Preparing to enter system sleep state S3
[75439.041417] PM: Saving platform NVS memory
[75439.175478] Disabling non-boot CPUs ...
[75439.189845] CPU 1 is now offline
[75439.202474] CPU 2 is now offline
[75439.219232] CPU 3 is now offline
[75439.219565] Extended CMOS year: 2000
[75439.219843] Back to C!
[75439.219846] PM: Restoring platform NVS memory
[75439.357182] Extended CMOS year: 2000
[75439.357237] Enabling non-boot CPUs ...
[75439.358614] Booting Node 0 Processor 1 APIC 0x1
[75439.466574] CPU1 is up
[75439.466663] Booting Node 0 Processor 2 APIC 0x4
[75439.574380] CPU2 is up
[75439.574482] Booting Node 0 Processor 3 APIC 0x5
[75439.682322] CPU3 is up
[75439.683313] ACPI: Waking up from system sleep state S3
[75439.760098] i915 0000:00:02.0: restoring config space at offset 0x1 (was=
 0x900007, writing 0x900407)
[75439.760212] ehci_hcd 0000:00:1a.0: restoring config space at offset 0xf =
(was 0x400, writing 0x40b)
[75439.760231] ehci_hcd 0000:00:1a.0: restoring config space at offset 0x4 =
(was 0x0, writing 0xf2728000)
[75439.760240] ehci_hcd 0000:00:1a.0: restoring config space at offset 0x1 =
(was 0x2900000, writing 0x2900102)
[75439.770936] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[75439.772948] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[75439.773152] pci 0000:00:1c.4: restoring config space at offset 0xf (was =
0x100, writing 0x4010b)
[75439.773165] pci 0000:00:1c.4: restoring config space at offset 0x9 (was =
0x10001, writing 0x1fff1)
[75439.773170] pci 0000:00:1c.4: restoring config space at offset 0x8 (was =
0x0, writing 0xf240f240)
[75439.773175] pci 0000:00:1c.4: restoring config space at offset 0x7 (was =
0x0, writing 0xf0)
[75439.773185] pci 0000:00:1c.4: restoring config space at offset 0x3 (was =
0x810000, writing 0x810010)
[75439.773191] pci 0000:00:1c.4: restoring config space at offset 0x1 (was =
0x100000, writing 0x100107)
[75439.773225] ehci_hcd 0000:00:1d.0: restoring config space at offset 0xf =
(was 0x400, writing 0x40b)
[75439.773245] ehci_hcd 0000:00:1d.0: restoring config space at offset 0x4 =
(was 0x0, writing 0xf2728400)
[75439.773253] ehci_hcd 0000:00:1d.0: restoring config space at offset 0x1 =
(was 0x2900000, writing 0x2900102)
[75439.774947] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[75439.776941] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[75439.777075] ahci 0000:00:1f.2: restoring config space at offset 0x1 (was=
 0x2b00007, writing 0x2b00407)
[75439.777138] intel ips 0000:00:1f.6: restoring config space at offset 0xf=
 (was 0x400, writing 0x40b)
[75439.777162] intel ips 0000:00:1f.6: restoring config space at offset 0x1=
 (was 0x100000, writing 0x100002)
[75439.777247] iwlagn 0000:02:00.0: restoring config space at offset 0x1 (w=
as 0x100106, writing 0x100506)
[75439.777450] PM: early resume of devices complete after 17.499 msecs
[75439.777719] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[75439.777725] e1000e 0000:00:19.0: PME# disabled
[75439.777771] pci 0000:00:1c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[75439.777777] pci 0000:00:1c.0: setting latency timer to 64
[75439.777799] pci 0000:00:1c.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[75439.777805] pci 0000:00:1c.3: setting latency timer to 64
[75439.777822] pci 0000:00:1c.4: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[75439.777828] pci 0000:00:1c.4: setting latency timer to 64
[75439.777850] pci 0000:00:1e.0: setting latency timer to 64
[75439.777892] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> =
IRQ 17
[75439.777904] HDA Intel 0000:00:1b.0: setting latency timer to 64
[75439.777921] ahci 0000:00:1f.2: setting latency timer to 64
[75439.778012] HDA Intel 0000:00:1b.0: irq 41 for MSI/MSI-X
[75439.778024] e1000e 0000:00:19.0: irq 42 for MSI/MSI-X
[75439.778120] sd 0:0:0:0: [sda] Starting disk
[75439.779937] i915 0000:00:02.0: power state changed by ACPI to D0
[75439.780047] i915 0000:00:02.0: power state changed by ACPI to D0
[75439.780053] i915 0000:00:02.0: setting latency timer to 64
[75439.781191] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[75439.781357] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[75439.781366] ehci_hcd 0000:00:1a.0: PCI INT D -> GSI 23 (level, low) -> I=
RQ 23
[75439.781373] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[75439.781548] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[75439.781708] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[75439.781715] ehci_hcd 0000:00:1d.0: PCI INT D -> GSI 19 (level, low) -> I=
RQ 19
[75439.781722] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[75439.996646] usb 1-1.3: reset full speed USB device using ehci_hcd and ad=
dress 3
[75440.085441] ata2: SATA link down (SStatus 0 SControl 300)
[75440.086417] ata5: SATA link down (SStatus 0 SControl 300)
[75440.088377] ata6: SATA link down (SStatus 0 SControl 300)
[75440.154398] usb 1-1.6: reset high speed USB device using ehci_hcd and ad=
dress 6
[75440.316114] usb 2-1.1: reset high speed USB device using ehci_hcd and ad=
dress 3
[75441.408903] Synaptics Touchpad, model: 1, fw: 7.4, id: 0x1e0b1, caps: 0x=
d047b3/0xb40000/0xa0000
[75441.408911] serio: Synaptics pass-through port at isa0060/serio1/input0
[75441.459194] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042=
/serio1/input/input17
[75443.342791] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[75443.345127] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succee=
ded
[75443.345134] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK=
) filtered out
[75443.345140] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filter=
ed out
[75443.353697] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succee=
ded
[75443.353704] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK=
) filtered out
[75443.353709] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filter=
ed out
[75443.357884] ata1.00: configured for UDMA/133
[75443.460922] PM: resume of devices complete after 3689.743 msecs
[75443.461737] Restarting tasks ... done.
[75443.462623] video LNXVIDEO:00: Restoring backlight state
[75444.048673] usb 1-1.4: new full speed USB device using ehci_hcd and addr=
ess 11
[75448.075917] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[75448.338963] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/seri=
o1/serio6/input/input18
[75459.893484] usb 1-1.1: new high speed USB device using ehci_hcd and addr=
ess 12
[75459.980913] scsi9 : usb-storage 1-1.1:1.0
[75460.980389] scsi 9:0:0:0: Direct-Access     USB Mass  Storage Device    =
   PQ: 0 ANSI: 0 CCS
[75460.981114] sd 9:0:0:0: Attached scsi generic sg1 type 0
[75460.983050] sd 9:0:0:0: [sdc] 15761088 512-byte logical blocks: (8.06 GB=
/7.51 GiB)
[75460.983588] sd 9:0:0:0: [sdc] Write Protect is off
[75460.983597] sd 9:0:0:0: [sdc] Mode Sense: 03 00 00 00
[75460.984483] sd 9:0:0:0: [sdc] No Caching mode page present
[75460.984490] sd 9:0:0:0: [sdc] Assuming drive cache: write through
[75460.987612] sd 9:0:0:0: [sdc] No Caching mode page present
[75460.987618] sd 9:0:0:0: [sdc] Assuming drive cache: write through
[75460.999217]  sdc: sdc1
[75461.001437] sd 9:0:0:0: [sdc] No Caching mode page present
[75461.001440] sd 9:0:0:0: [sdc] Assuming drive cache: write through
[75461.001443] sd 9:0:0:0: [sdc] Attached SCSI removable disk
[75698.768566] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[75702.062567] wlan0: authenticate with 00:14:6c:67:9c:32 (try 1)
[75702.261419] wlan0: authenticate with 00:14:6c:67:9c:32 (try 2)
[75702.268518] wlan0: authenticated
[75702.268781] wlan0: associate with 00:14:6c:67:9c:32 (try 1)
[75702.276980] wlan0: RX AssocResp from 00:14:6c:67:9c:32 (capab=3D0x611 st=
atus=3D0 aid=3D9)
[75702.276985] wlan0: associated
[75702.281605] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[75712.660484] wlan0: no IPv6 routers present
[75830.789204] usb 1-1.1: USB disconnect, address 12
[75830.970641] usb 1-1.1: new high speed USB device using ehci_hcd and addr=
ess 13
[75831.057688] scsi10 : usb-storage 1-1.1:1.0
[75831.300190] usb 1-1.1: USB disconnect, address 13
[77999.531388] thinkpad_acpi: EC reports that Thermal Table has changed
[77999.902892] ata2: exception Emask 0x10 SAct 0x0 SErr 0x4040000 action 0x=
e frozen
[77999.902897] ata2: irq_stat 0x000000c0, connection status changed
[77999.902901] ata2: SError: { CommWake DevExch }
[77999.913120] ata2: hard resetting link
[78000.126290] ACPI: \_SB_.GDCK - docking
[78000.665950] usb 1-1.5: new high speed USB device using ehci_hcd and addr=
ess 14
[78000.751612] hub 1-1.5:1.0: USB hub found
[78000.751740] hub 1-1.5:1.0: 4 ports detected
[78000.789558] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[78000.794880] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
[78000.795706] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
[78000.799440] ata2.00: ATAPI: HL-DT-ST DVDRAM GSA-U20N, HX12, max UDMA/133
[78000.805850] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
[78000.806689] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
[78000.810433] ata2.00: configured for UDMA/133
[78000.930272] ata2: EH complete
[78000.933451] scsi 1:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-U20N  HX=
12 PQ: 0 ANSI: 5
[78001.272093] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 =
cdda tray
[78001.272297] sr 1:0:0:0: Attached scsi CD-ROM sr0
[78001.272544] sr 1:0:0:0: Attached scsi generic sg1 type 5
[78001.648010] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Contr=
ol: RX
[78001.648018] e1000e 0000:00:19.0: eth0: 10/100 speed: disabling TSO
[78007.057928] usb 1-1.5.4: new high speed USB device using ehci_hcd and ad=
dress 15
[78007.144831] usb-storage 1-1.5.4:1.0: Quirks match for vid 1058 pid 0704:=
 8000
[78007.144884] scsi11 : usb-storage 1-1.5.4:1.0
[78008.143802] scsi 11:0:0:0: Direct-Access     WD       5000BMV External 1=
=2E75 PQ: 0 ANSI: 4
[78008.144339] sd 11:0:0:0: Attached scsi generic sg3 type 0
[78008.145327] sd 11:0:0:0: [sdc] 976773168 512-byte logical blocks: (500 G=
B/465 GiB)
[78008.146277] sd 11:0:0:0: [sdc] Write Protect is off
[78008.146285] sd 11:0:0:0: [sdc] Mode Sense: 23 00 00 00
[78008.148028] sd 11:0:0:0: [sdc] No Caching mode page present
[78008.148036] sd 11:0:0:0: [sdc] Assuming drive cache: write through
[78008.150274] sd 11:0:0:0: [sdc] No Caching mode page present
[78008.150280] sd 11:0:0:0: [sdc] Assuming drive cache: write through
[78008.178106]  sdc: unknown partition table
[78008.180173] sd 11:0:0:0: [sdc] No Caching mode page present
[78008.180176] sd 11:0:0:0: [sdc] Assuming drive cache: write through
[78008.180179] sd 11:0:0:0: [sdc] Attached SCSI disk
[79558.733008] ata2.00: disabled
[79558.733255] ACPI: \_SB_.GDCK - undocking
[79558.733557] ata2.00: detaching (SCSI 1:0:0:0)
[79558.734874] ata2: exception Emask 0x10 SAct 0x0 SErr 0x4080000 action 0x=
e frozen
[79558.734882] ata2: irq_stat 0x000000c0, connection status changed
[79558.734891] ata2: SError: { 10B8B DevExch }
[79558.745422] ata2: hard resetting link
[79558.891191] usb 1-1.5: USB disconnect, address 14
[79558.891197] usb 1-1.5.4: USB disconnect, address 15
[79559.467294] ata2: SATA link down (SStatus 0 SControl 300)
[79559.467313] ata2: EH complete
[79559.539245] ACPI: \_SB_.GDCK - undocking
[79559.567526] e1000e: eth0 NIC Link is Down
[79560.153690] thinkpad_acpi: EC reports that Thermal Table has changed
[84328.765036] thinkpad_acpi: EC reports that Thermal Table has changed
[84328.859020] ACPI: \_SB_.GDCK - docking
[84328.862006] ata2: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0xe froz=
en
[84328.862014] ata2: ACPI event
[84328.862068] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan=
-723)
[84328.872345] ata2: hard resetting link
[84329.455876] ACPI: \_SB_.PCI0.SAT1.PRT1 - docking
[84329.852899] usb 1-1.5: new high speed USB device using ehci_hcd and addr=
ess 16
[84329.930541] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[84329.935938] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
[84329.936783] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
[84329.938431] hub 1-1.5:1.0: USB hub found
[84329.938551] hub 1-1.5:1.0: 4 ports detected
[84329.940467] ata2.00: ATAPI: HL-DT-ST DVDRAM GSA-U20N, HX12, max UDMA/133
[84329.947192] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
[84329.948030] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
[84329.951760] ata2.00: configured for UDMA/133
[84330.145198] ata2: EH complete
[84330.148285] scsi 1:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-U20N  HX=
12 PQ: 0 ANSI: 5
[84330.500632] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 =
cdda tray
[84330.500811] sr 1:0:0:0: Attached scsi CD-ROM sr0
[84330.500998] sr 1:0:0:0: Attached scsi generic sg1 type 5
[84331.028575] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Contr=
ol: RX
[84331.028583] e1000e 0000:00:19.0: eth0: 10/100 speed: disabling TSO
[84336.244882] usb 1-1.5.4: new high speed USB device using ehci_hcd and ad=
dress 17
[84336.333566] usb-storage 1-1.5.4:1.0: Quirks match for vid 1058 pid 0704:=
 8000
[84336.333609] scsi12 : usb-storage 1-1.5.4:1.0
[84337.332779] scsi 12:0:0:0: Direct-Access     WD       5000BMV External 1=
=2E75 PQ: 0 ANSI: 4
[84337.333473] sd 12:0:0:0: Attached scsi generic sg3 type 0
[84337.334721] sd 12:0:0:0: [sdc] 976773168 512-byte logical blocks: (500 G=
B/465 GiB)
[84337.335207] sd 12:0:0:0: [sdc] Write Protect is off
[84337.335216] sd 12:0:0:0: [sdc] Mode Sense: 23 00 00 00
[84337.335955] sd 12:0:0:0: [sdc] No Caching mode page present
[84337.335963] sd 12:0:0:0: [sdc] Assuming drive cache: write through
[84337.338063] sd 12:0:0:0: [sdc] No Caching mode page present
[84337.338069] sd 12:0:0:0: [sdc] Assuming drive cache: write through
[84337.365081]  sdc: unknown partition table
[84337.367145] sd 12:0:0:0: [sdc] No Caching mode page present
[84337.367152] sd 12:0:0:0: [sdc] Assuming drive cache: write through
[84337.367159] sd 12:0:0:0: [sdc] Attached SCSI disk
[113729.357823] tun: Universal TUN/TAP device driver, 1.6
[113729.357827] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[113729.359459] tun0: Disabled Privacy Extensions
[113762.396812] ata2.00: disabled
[113762.397067] ACPI: \_SB_.GDCK - undocking
[113762.397363] ata2.00: detaching (SCSI 1:0:0:0)
[113762.399676] ata2: exception Emask 0x10 SAct 0x0 SErr 0x4080000 action 0=
xe frozen
[113762.399684] ata2: irq_stat 0x000000c0, connection status changed
[113762.399692] ata2: SError: { 10B8B DevExch }
[113762.411289] ata2: hard resetting link
[113762.463687] usb 1-1.5: USB disconnect, address 16
[113762.463693] usb 1-1.5.4: USB disconnect, address 17
[113763.133146] ata2: SATA link down (SStatus 0 SControl 300)
[113763.133166] ata2: EH complete
[113764.252453] usb 1-1.4: USB disconnect, address 11
[113764.349325] PM: Syncing filesystems ... done.
[113764.700321] Freezing user space processes ... (elapsed 0.01 seconds) do=
ne.
[113764.711373] Freezing remaining freezable tasks ... (elapsed 0.01 second=
s) done.
[113764.722578] Suspending console(s) (use no_console_suspend to debug)
[113764.914542] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[113764.918062] sd 0:0:0:0: [sda] Stopping disk
[113764.970338] ACPI handle has no context!
[113765.161947] ehci_hcd 0000:00:1d.0: PCI INT D disabled
[113765.161994] HDA Intel 0000:00:1b.0: PCI INT B disabled
[113765.162106] ehci_hcd 0000:00:1a.0: PCI INT D disabled
[113765.348643] e1000e 0000:00:19.0: PME# enabled
[113765.348653] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
[113768.173409] i915 0000:00:02.0: power state changed by ACPI to D3
[113768.173603] PM: suspend of devices complete after 3456.699 msecs
[113768.202348] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D3
[113768.219373] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D3
[113768.219504] PM: late suspend of devices complete after 45.975 msecs
[113768.219646] ACPI: Preparing to enter system sleep state S3
[113768.267321] PM: Saving platform NVS memory
[113768.402366] Disabling non-boot CPUs ...
[113768.416678] CPU 1 is now offline
[113768.433271] CPU 2 is now offline
[113768.442088] CPU 3 is now offline
[113768.442435] Extended CMOS year: 2000
[113768.442713] Back to C!
[113768.442716] PM: Restoring platform NVS memory
[113768.580093] Extended CMOS year: 2000
[113768.580147] Enabling non-boot CPUs ...
[113768.581561] Booting Node 0 Processor 1 APIC 0x1
[113768.689502] CPU1 is up
[113768.689595] Booting Node 0 Processor 2 APIC 0x4
[113768.797313] CPU2 is up
[113768.797419] Booting Node 0 Processor 3 APIC 0x5
[113768.905258] CPU3 is up
[113768.906227] ACPI: Waking up from system sleep state S3
[113768.990269] thinkpad_acpi: EC reports that Thermal Table has changed
[113769.003067] i915 0000:00:02.0: restoring config space at offset 0x1 (wa=
s 0x900007, writing 0x900407)
[113769.003182] ehci_hcd 0000:00:1a.0: restoring config space at offset 0xf=
 (was 0x400, writing 0x40b)
[113769.003202] ehci_hcd 0000:00:1a.0: restoring config space at offset 0x4=
 (was 0x0, writing 0xf2728000)
[113769.003211] ehci_hcd 0000:00:1a.0: restoring config space at offset 0x1=
 (was 0x2900000, writing 0x2900102)
[113769.021887] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[113769.023909] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[113769.024101] pci 0000:00:1c.4: restoring config space at offset 0xf (was=
 0x100, writing 0x4010b)
[113769.024113] pci 0000:00:1c.4: restoring config space at offset 0x9 (was=
 0x10001, writing 0x1fff1)
[113769.024119] pci 0000:00:1c.4: restoring config space at offset 0x8 (was=
 0x0, writing 0xf240f240)
[113769.024124] pci 0000:00:1c.4: restoring config space at offset 0x7 (was=
 0x0, writing 0xf0)
[113769.024134] pci 0000:00:1c.4: restoring config space at offset 0x3 (was=
 0x810000, writing 0x810010)
[113769.024140] pci 0000:00:1c.4: restoring config space at offset 0x1 (was=
 0x100000, writing 0x100107)
[113769.024174] ehci_hcd 0000:00:1d.0: restoring config space at offset 0xf=
 (was 0x400, writing 0x40b)
[113769.024193] ehci_hcd 0000:00:1d.0: restoring config space at offset 0x4=
 (was 0x0, writing 0xf2728400)
[113769.024202] ehci_hcd 0000:00:1d.0: restoring config space at offset 0x1=
 (was 0x2900000, writing 0x2900102)
[113769.025909] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[113769.027902] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[113769.028028] ahci 0000:00:1f.2: restoring config space at offset 0x1 (wa=
s 0x2b00007, writing 0x2b00407)
[113769.028098] intel ips 0000:00:1f.6: restoring config space at offset 0x=
f (was 0x400, writing 0x40b)
[113769.028121] intel ips 0000:00:1f.6: restoring config space at offset 0x=
1 (was 0x100000, writing 0x100002)
[113769.028206] iwlagn 0000:02:00.0: restoring config space at offset 0x1 (=
was 0x100106, writing 0x100506)
[113769.028405] PM: early resume of devices complete after 25.488 msecs
[113769.028767] pci 0000:00:1c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[113769.028776] pci 0000:00:1c.0: setting latency timer to 64
[113769.028791] pci 0000:00:1c.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[113769.028799] pci 0000:00:1c.3: setting latency timer to 64
[113769.028818] pci 0000:00:1c.4: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[113769.028824] pci 0000:00:1c.4: setting latency timer to 64
[113769.028860] pci 0000:00:1e.0: setting latency timer to 64
[113769.028895] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[113769.028902] e1000e 0000:00:19.0: PME# disabled
[113769.028907] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) ->=
 IRQ 17
[113769.028916] HDA Intel 0000:00:1b.0: setting latency timer to 64
[113769.028963] HDA Intel 0000:00:1b.0: irq 41 for MSI/MSI-X
[113769.029037] ahci 0000:00:1f.2: setting latency timer to 64
[113769.029137] i915 0000:00:02.0: power state changed by ACPI to D0
[113769.029160] sd 0:0:0:0: [sda] Starting disk
[113769.029226] e1000e 0000:00:19.0: irq 42 for MSI/MSI-X
[113769.030907] i915 0000:00:02.0: power state changed by ACPI to D0
[113769.030914] i915 0000:00:02.0: setting latency timer to 64
[113769.030945] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[113769.031112] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[113769.031120] ehci_hcd 0000:00:1a.0: PCI INT D -> GSI 23 (level, low) -> =
IRQ 23
[113769.031127] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[113769.032453] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[113769.032615] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[113769.032623] ehci_hcd 0000:00:1d.0: PCI INT D -> GSI 19 (level, low) -> =
IRQ 19
[113769.032630] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[113769.247676] usb 2-1.1: reset high speed USB device using ehci_hcd and a=
ddress 3
[113769.335291] ata5: SATA link down (SStatus 0 SControl 300)
[113769.337288] ata2: SATA link down (SStatus 0 SControl 300)
[113769.339271] ata6: SATA link down (SStatus 0 SControl 300)
[113769.403383] usb 1-1.6: reset high speed USB device using ehci_hcd and a=
ddress 6
[113769.484087] ehci_hcd 0000:00:1a.0: fatal error
[113769.490810] ehci_hcd 0000:00:1a.0: force halt; handshake ffffc9000179e0=
24 00004000 00004000 -> -110
[113769.490815] ehci_hcd 0000:00:1a.0: HC died; cleaning up
[113769.494997] usb 1-1.6: device descriptor read/all, error -19
[113769.495002] hub 1-1:1.0: cannot disable port 6 (err =3D -19)
[113769.495011] hub 1-1:1.0: cannot disable port 6 (err =3D -19)
[113769.495021] hub 1-1:1.0: cannot reset port 3 (err =3D -19)
[113769.495028] hub 1-1:1.0: cannot disable port 3 (err =3D -19)
[113769.495034] hub 1-1:1.0: cannot disable port 3 (err =3D -19)
[113770.662330] Synaptics Touchpad, model: 1, fw: 7.4, id: 0x1e0b1, caps: 0=
xd047b3/0xb40000/0xa0000
[113770.662338] serio: Synaptics pass-through port at isa0060/serio1/input0
[113770.713580] input: SynPS/2 Synaptics TouchPad as /devices/platform/i804=
2/serio1/input/input19
[113772.442893] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[113772.453391] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succe=
eded
[113772.453398] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOC=
K) filtered out
[113772.453404] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filte=
red out
[113772.458138] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succe=
eded
[113772.458146] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOC=
K) filtered out
[113772.458155] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filte=
red out
[113772.460931] ata1.00: configured for UDMA/133
[113772.604377] PM: resume of devices complete after 3582.062 msecs
[113772.605144] Restarting tasks ...=20
[113772.605194] usb 1-1: USB disconnect, address 2
[113772.605198] usb 1-1.3: USB disconnect, address 3
[113772.605352] usb 1-1.6: USB disconnect, address 6
[113772.612596] done.
[113772.612603] video LNXVIDEO:00: Restoring backlight state
[113772.655661] cfg80211: Calling CRDA to update world regulatory domain
[113775.879045] wlan0: authenticate with 02:0c:42:26:d0:95 (try 1)
[113776.078610] wlan0: authenticate with 02:0c:42:26:d0:95 (try 2)
[113776.105907] wlan0: authenticated
[113776.106165] wlan0: waiting for beacon from 02:0c:42:26:d0:95
[113777.363743] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[113777.650325] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/ser=
io1/serio7/input/input20
[113831.628680] wlan0: direct probe to 00:03:52:b2:e0:20 (try 1/3)
[113831.827604] wlan0: direct probe to 00:03:52:b2:e0:20 (try 2/3)
[113832.027200] wlan0: direct probe to 00:03:52:b2:e0:20 (try 3/3)
[113832.226911] wlan0: direct probe to 00:03:52:b2:e0:20 timed out
[113844.833849] wlan0: direct probe to 00:03:52:5c:26:40 (try 1/3)
[113845.032834] wlan0: direct probe to 00:03:52:5c:26:40 (try 2/3)
[113845.232491] wlan0: direct probe to 00:03:52:5c:26:40 (try 3/3)
[113845.432153] wlan0: direct probe to 00:03:52:5c:26:40 timed out
[113857.958171] wlan0: direct probe to 00:03:52:5c:26:40 (try 1/3)
[113858.157198] wlan0: direct probe to 00:03:52:5c:26:40 (try 2/3)
[113858.356844] wlan0: direct probe to 00:03:52:5c:26:40 (try 3/3)
[113858.556531] wlan0: direct probe to 00:03:52:5c:26:40 timed out
[113870.992938] wlan0: direct probe to 00:03:52:5c:34:80 (try 1/3)
[113871.192630] wlan0: direct probe to 00:03:52:5c:34:80 (try 2/3)
[113871.392353] wlan0: direct probe to 00:03:52:5c:34:80 (try 3/3)
[113871.592021] wlan0: direct probe to 00:03:52:5c:34:80 timed out
[113884.072766] wlan0: authenticate with 00:03:52:b2:e8:d0 (try 1)
[113884.272165] wlan0: authenticate with 00:03:52:b2:e8:d0 (try 2)
[113884.471815] wlan0: authenticate with 00:03:52:b2:e8:d0 (try 3)
[113884.475144] wlan0: authenticated
[113884.475409] wlan0: associate with 00:03:52:b2:e8:d0 (try 1)
[113884.476405] wlan0: RX AssocResp from 00:03:52:b2:e8:d0 (capab=3D0x811 s=
tatus=3D0 aid=3D1)
[113884.476411] wlan0: associated
[113907.362973] cfg80211: Calling CRDA to update world regulatory domain
[113910.685625] wlan0: direct probe to 00:03:52:5c:32:70 (try 1/3)
[113910.885309] wlan0: direct probe to 00:03:52:5c:32:70 (try 2/3)
[113911.084926] wlan0: direct probe to 00:03:52:5c:32:70 (try 3/3)
[113911.284597] wlan0: direct probe to 00:03:52:5c:32:70 timed out
[113937.085528] wlan0: authenticate with 00:0b:85:5a:d4:5a (try 1)
[113937.284765] wlan0: authenticate with 00:0b:85:5a:d4:5a (try 2)
[113937.287765] wlan0: authenticated
[113937.288102] wlan0: associate with 00:0b:85:5a:d4:5a (try 1)
[113937.292371] wlan0: RX AssocResp from 00:0b:85:5a:d4:5a (capab=3D0x421 s=
tatus=3D0 aid=3D12)
[113937.292376] wlan0: associated
[113970.237212] cfg80211: Calling CRDA for country: CH
[113973.518044] wlan0: authenticate with 00:0f:24:cc:40:a0 (try 1)
[113973.716928] wlan0: authenticate with 00:0f:24:cc:40:a0 (try 2)
[113973.719067] wlan0: authenticated
[113973.719336] wlan0: waiting for beacon from 00:0f:24:cc:40:a0
[113973.779024] wlan0: beacon received
[113973.784793] wlan0: associate with 00:0f:24:cc:40:a0 (try 1)
[113973.984499] wlan0: associate with 00:0f:24:cc:40:a0 (try 2)
[113973.987174] wlan0: RX AssocResp from 00:0f:24:cc:40:a0 (capab=3D0x421 s=
tatus=3D0 aid=3D3)
[113973.987180] wlan0: associated
[113982.211581] cfg80211: Calling CRDA to update world regulatory domain
[113985.506661] wlan0: authenticate with 00:0f:24:cc:40:a0 (try 1)
[113985.706298] wlan0: authenticate with 00:0f:24:cc:40:a0 (try 2)
[113985.905949] wlan0: authenticate with 00:0f:24:cc:40:a0 (try 3)
[113986.105591] wlan0: authentication with 00:0f:24:cc:40:a0 timed out
[113998.683519] wlan0: authenticate with 00:14:06:31:16:61 (try 1)
[113998.882568] wlan0: authenticate with 00:14:06:31:16:61 (try 2)
[113998.887944] wlan0: authenticated
[113998.888300] wlan0: waiting for beacon from 00:14:06:31:16:61
[113999.112567] wlan0: beacon received
[113999.117139] wlan0: associate with 00:14:06:31:16:61 (try 1)
[113999.316799] wlan0: associate with 00:14:06:31:16:61 (try 2)
[113999.516454] wlan0: associate with 00:14:06:31:16:61 (try 3)
[113999.519321] wlan0: RX AssocResp from 00:14:06:31:16:61 (capab=3D0x401 s=
tatus=3D0 aid=3D1)
[113999.519326] wlan0: associated
[114041.133021] cfg80211: Calling CRDA to update world regulatory domain
[114044.448489] wlan0: direct probe to 00:03:52:2b:55:20 (try 1/3)
[114044.647616] wlan0: direct probe to 00:03:52:2b:55:20 (try 2/3)
[114044.847273] wlan0: direct probe to 00:03:52:2b:55:20 (try 3/3)
[114045.046935] wlan0: direct probe to 00:03:52:2b:55:20 timed out
[114057.489594] wlan0: direct probe to 00:03:52:29:62:30 (try 1/3)
[114057.689134] wlan0: direct probe to 00:03:52:29:62:30 (try 2/3)
[114057.888794] wlan0: direct probe to 00:03:52:29:62:30 (try 3/3)
[114058.088457] wlan0: direct probe to 00:03:52:29:62:30 timed out
[114070.505236] wlan0: direct probe to 00:03:52:2b:44:10 (try 1/3)
[114070.704741] wlan0: direct probe to 00:03:52:2b:44:10 (try 2/3)
[114070.904394] wlan0: direct probe to 00:03:52:2b:44:10 (try 3/3)
[114071.104045] wlan0: direct probe to 00:03:52:2b:44:10 timed out
[114083.799705] wlan0: direct probe to 00:03:52:1c:13:80 (try 1/3)
[114083.998802] wlan0: direct probe to 00:03:52:1c:13:80 (try 2/3)
[114084.198483] wlan0: direct probe to 00:03:52:1c:13:80 (try 3/3)
[114084.398137] wlan0: direct probe to 00:03:52:1c:13:80 timed out
[114096.866904] wlan0: direct probe to 00:03:52:1c:13:80 (try 1/3)
[114097.066288] wlan0: direct probe to 00:03:52:1c:13:80 (try 2/3)
[114097.265933] wlan0: direct probe to 00:03:52:1c:13:80 (try 3/3)
[114097.465612] wlan0: direct probe to 00:03:52:1c:13:80 timed out
[114109.843409] wlan0: direct probe to 00:03:52:5d:3e:10 (try 1/3)
[114110.042882] wlan0: direct probe to 00:03:52:5d:3e:10 (try 2/3)
[114110.242584] wlan0: direct probe to 00:03:52:5d:3e:10 (try 3/3)
[114110.442220] wlan0: direct probe to 00:03:52:5d:3e:10 timed out
[114122.991801] wlan0: direct probe to 00:0f:61:1a:0f:a0 (try 1/3)
[114123.191213] wlan0: direct probe to 00:0f:61:1a:0f:a0 (try 2/3)
[114123.390862] wlan0: direct probe to 00:0f:61:1a:0f:a0 (try 3/3)
[114123.590497] wlan0: direct probe to 00:0f:61:1a:0f:a0 timed out
[114135.973643] wlan0: direct probe to 00:03:52:29:80:c0 (try 1/3)
[114136.172873] wlan0: direct probe to 00:03:52:29:80:c0 (try 2/3)
[114136.372538] wlan0: direct probe to 00:03:52:29:80:c0 (try 3/3)
[114136.572160] wlan0: direct probe to 00:03:52:29:80:c0 timed out
[114149.043571] wlan0: direct probe to 00:03:52:e3:44:c0 (try 1/3)
[114149.243344] wlan0: direct probe to 00:03:52:e3:44:c0 (try 2/3)
[114149.244124] wlan0: direct probe responded
[114149.248270] wlan0: authenticate with 00:03:52:e3:44:c0 (try 1)
[114149.248895] wlan0: authenticated
[114149.249204] wlan0: associate with 00:03:52:e3:44:c0 (try 1)
[114149.250128] wlan0: RX AssocResp from 00:03:52:e3:44:c0 (capab=3D0x11 st=
atus=3D0 aid=3D1)
[114149.250133] wlan0: associated
[114150.919708] cfg80211: Calling CRDA to update world regulatory domain
[114154.166207] wlan0: direct probe to 00:03:52:2b:ca:50 (try 1/3)
[114154.365509] wlan0: direct probe to 00:03:52:2b:ca:50 (try 2/3)
[114154.565131] wlan0: direct probe to 00:03:52:2b:ca:50 (try 3/3)
[114154.764818] wlan0: direct probe to 00:03:52:2b:ca:50 timed out
[114167.353604] wlan0: direct probe to 00:03:52:2c:01:00 (try 1/3)
[114167.552719] wlan0: direct probe to 00:03:52:2c:01:00 (try 2/3)
[114167.752430] wlan0: direct probe to 00:03:52:2c:01:00 (try 3/3)
[114167.755112] wlan0: direct probe responded
[114167.759384] wlan0: authenticate with 00:03:52:2c:01:00 (try 1)
[114167.761193] wlan0: authenticated
[114167.761448] wlan0: associate with 00:03:52:2c:01:00 (try 1)
[114167.961048] wlan0: associate with 00:03:52:2c:01:00 (try 2)
[114167.963175] wlan0: RX AssocResp from 00:03:52:2c:01:00 (capab=3D0x421 s=
tatus=3D17 aid=3D0)
[114167.963182] wlan0: 00:03:52:2c:01:00 denied association (code=3D17)
[114167.963348] wlan0: deauthenticating from 00:03:52:2c:01:00 by local cho=
ice (reason=3D3)
[114180.526824] wlan0: authenticate with 00:03:52:e3:0e:10 (try 1)
[114180.726058] wlan0: authenticate with 00:03:52:e3:0e:10 (try 2)
[114180.726693] wlan0: authenticated
[114180.726995] wlan0: associate with 00:03:52:e3:0e:10 (try 1)
[114180.727605] wlan0: RX AssocResp from 00:03:52:e3:0e:10 (capab=3D0x11 st=
atus=3D0 aid=3D1)
[114180.727610] wlan0: associated
[114195.665678] thinkpad_acpi: EC reports that Thermal Table has changed
[114195.669494] ACPI: \_SB_.GDCK - docking
[114195.672492] ata2: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0xe fro=
zen
[114195.672499] ata2: ACPI event
[114195.683207] ata2: hard resetting link
[114196.559769] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[114196.566006] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
[114196.566881] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
[114196.570550] ata2.00: ATAPI: HL-DT-ST DVDRAM GSA-U20N, HX10, max UDMA/133
[114196.576911] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
[114196.577678] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
[114196.581416] ata2.00: configured for UDMA/133
[114196.788333] ata2: EH complete
[114196.791376] scsi 1:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-U20N  H=
X10 PQ: 0 ANSI: 5
[114197.143521] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2=
 cdda tray
[114197.143720] sr 1:0:0:0: Attached scsi CD-ROM sr0
[114197.143926] sr 1:0:0:0: Attached scsi generic sg1 type 5
[114199.834338] cfg80211: Calling CRDA to update world regulatory domain
[114200.007880] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Con=
trol: RX
[114203.207317] wlan0: authenticate with 00:03:52:2c:01:00 (try 1)
[114203.209103] wlan0: authenticated
[114203.209397] wlan0: associate with 00:03:52:2c:01:00 (try 1)
[114203.211481] wlan0: RX AssocResp from 00:03:52:2c:01:00 (capab=3D0x421 s=
tatus=3D17 aid=3D0)
[114203.211487] wlan0: 00:03:52:2c:01:00 denied association (code=3D17)
[114203.212999] wlan0: deauthenticating from 00:03:52:2c:01:00 by local cho=
ice (reason=3D3)
[114216.326814] wlan0: direct probe to 00:0f:61:1a:0c:50 (try 1/3)
[114216.526334] wlan0: direct probe to 00:0f:61:1a:0c:50 (try 2/3)
[114216.725893] wlan0: direct probe to 00:0f:61:1a:0c:50 (try 3/3)
[114216.925647] wlan0: direct probe to 00:0f:61:1a:0c:50 timed out
[114229.513061] wlan0: direct probe to 00:0f:61:1a:1d:30 (try 1/3)
[114229.712631] wlan0: direct probe to 00:0f:61:1a:1d:30 (try 2/3)
[114229.912265] wlan0: direct probe to 00:0f:61:1a:1d:30 (try 3/3)
[114230.111930] wlan0: direct probe to 00:0f:61:1a:1d:30 timed out
[114242.703183] wlan0: direct probe to 00:03:52:1c:31:f0 (try 1/3)
[114242.902862] wlan0: direct probe to 00:03:52:1c:31:f0 (try 2/3)
[114243.102472] wlan0: direct probe to 00:03:52:1c:31:f0 (try 3/3)
[114243.302094] wlan0: direct probe to 00:03:52:1c:31:f0 timed out
[114255.791862] wlan0: direct probe to 00:0f:61:1a:0c:50 (try 1/3)
[114255.991238] wlan0: direct probe to 00:0f:61:1a:0c:50 (try 2/3)
[114256.190944] wlan0: direct probe to 00:0f:61:1a:0c:50 (try 3/3)
[114256.390581] wlan0: direct probe to 00:0f:61:1a:0c:50 timed out
[114269.005487] wlan0: direct probe to 00:03:52:e3:0e:10 (try 1/3)
[114269.204515] wlan0: direct probe to 00:03:52:e3:0e:10 (try 2/3)
[114269.205332] wlan0: direct probe responded
[114269.209480] wlan0: authenticate with 00:03:52:e3:0e:10 (try 1)
[114269.409135] wlan0: authenticate with 00:03:52:e3:0e:10 (try 2)
[114269.409783] wlan0: authenticated
[114269.410042] wlan0: associate with 00:03:52:e3:0e:10 (try 1)
[114269.410664] wlan0: RX AssocResp from 00:03:52:e3:0e:10 (capab=3D0x11 st=
atus=3D0 aid=3D1)
[114269.410669] wlan0: associated
[114332.625724] cfg80211: Calling CRDA to update world regulatory domain
[114335.929250] wlan0: direct probe to 00:03:52:5d:2c:c0 (try 1/3)
[114336.128086] wlan0: direct probe to 00:03:52:5d:2c:c0 (try 2/3)
[114336.327772] wlan0: direct probe to 00:03:52:5d:2c:c0 (try 3/3)
[114336.527364] wlan0: direct probe to 00:03:52:5d:2c:c0 timed out
[114349.117224] wlan0: direct probe to 00:03:52:1c:31:f0 (try 1/3)
[114349.316355] wlan0: direct probe to 00:03:52:1c:31:f0 (try 2/3)
[114349.515997] wlan0: direct probe to 00:03:52:1c:31:f0 (try 3/3)
[114349.715657] wlan0: direct probe to 00:03:52:1c:31:f0 timed out
[114362.303708] wlan0: direct probe to 00:0f:61:1a:1d:30 (try 1/3)
[114362.502654] wlan0: direct probe to 00:0f:61:1a:1d:30 (try 2/3)
[114362.702314] wlan0: direct probe to 00:0f:61:1a:1d:30 (try 3/3)
[114362.901942] wlan0: direct probe to 00:0f:61:1a:1d:30 timed out
[114375.436246] wlan0: direct probe to 00:03:52:2b:ca:50 (try 1/3)
[114375.636016] wlan0: direct probe to 00:03:52:2b:ca:50 (try 2/3)
[114375.835676] wlan0: direct probe to 00:03:52:2b:ca:50 (try 3/3)
[114376.035328] wlan0: direct probe to 00:03:52:2b:ca:50 timed out
[114388.520274] wlan0: direct probe to 00:03:52:1c:17:80 (try 1/3)
[114388.719466] wlan0: direct probe to 00:03:52:1c:17:80 (try 2/3)
[114388.919100] wlan0: direct probe to 00:03:52:1c:17:80 (try 3/3)
[114389.118770] wlan0: direct probe to 00:03:52:1c:17:80 timed out
[114401.644918] wlan0: direct probe to 00:03:52:e3:0e:10 (try 1/3)
[114401.843837] wlan0: direct probe to 00:03:52:e3:0e:10 (try 2/3)
[114401.844633] wlan0: direct probe responded
[114401.848790] wlan0: authenticate with 00:03:52:e3:0e:10 (try 1)
[114402.048407] wlan0: authenticate with 00:03:52:e3:0e:10 (try 2)
[114402.049024] wlan0: authenticated
[114402.049288] wlan0: associate with 00:03:52:e3:0e:10 (try 1)
[114402.049934] wlan0: RX AssocResp from 00:03:52:e3:0e:10 (capab=3D0x11 st=
atus=3D0 aid=3D1)
[114402.049939] wlan0: associated
[114403.476323] cfg80211: Calling CRDA to update world regulatory domain
[114406.766428] wlan0: direct probe to 00:0f:61:1a:0a:d0 (try 1/3)
[114406.965978] wlan0: direct probe to 00:0f:61:1a:0a:d0 (try 2/3)
[114407.165606] wlan0: direct probe to 00:0f:61:1a:0a:d0 (try 3/3)
[114407.365305] wlan0: direct probe to 00:0f:61:1a:0a:d0 timed out
[114419.956547] wlan0: direct probe to 00:0f:61:1a:0f:a0 (try 1/3)
[114420.156220] wlan0: direct probe to 00:0f:61:1a:0f:a0 (try 2/3)
[114420.355873] wlan0: direct probe to 00:0f:61:1a:0f:a0 (try 3/3)
[114420.555561] wlan0: direct probe to 00:0f:61:1a:0f:a0 timed out
[114433.139739] wlan0: direct probe to 00:0f:61:1a:0a:d0 (try 1/3)
[114433.338478] wlan0: direct probe to 00:0f:61:1a:0a:d0 (try 2/3)
[114433.538188] wlan0: direct probe to 00:0f:61:1a:0a:d0 (try 3/3)
[114433.737804] wlan0: direct probe to 00:0f:61:1a:0a:d0 timed out
[114446.394009] wlan0: direct probe to 00:03:52:1c:18:e0 (try 1/3)
[114446.593635] wlan0: direct probe to 00:03:52:1c:18:e0 (try 2/3)
[114446.793257] wlan0: direct probe to 00:03:52:1c:18:e0 (try 3/3)
[114446.992950] wlan0: direct probe to 00:03:52:1c:18:e0 timed out
[114459.529711] wlan0: direct probe to 00:03:52:1c:18:e0 (try 1/3)
[114459.729037] wlan0: direct probe to 00:03:52:1c:18:e0 (try 2/3)
[114459.928696] wlan0: direct probe to 00:03:52:1c:18:e0 (try 3/3)
[114460.128339] wlan0: direct probe to 00:03:52:1c:18:e0 timed out
[114472.737119] wlan0: direct probe to 00:03:52:5d:2c:c0 (try 1/3)
[114472.936265] wlan0: direct probe to 00:03:52:5d:2c:c0 (try 2/3)
[114473.135920] wlan0: direct probe to 00:03:52:5d:2c:c0 (try 3/3)
[114473.335568] wlan0: direct probe to 00:03:52:5d:2c:c0 timed out
[114485.925614] wlan0: direct probe to 00:03:52:5d:26:f0 (try 1/3)
[114486.124484] wlan0: direct probe to 00:03:52:5d:26:f0 (try 2/3)
[114486.324151] wlan0: direct probe to 00:03:52:5d:26:f0 (try 3/3)
[114486.523797] wlan0: direct probe to 00:03:52:5d:26:f0 timed out
[114499.007836] wlan0: direct probe to 00:03:52:1c:11:90 (try 1/3)
[114499.206982] wlan0: direct probe to 00:03:52:1c:11:90 (try 2/3)
[114499.406587] wlan0: direct probe to 00:03:52:1c:11:90 (try 3/3)
[114499.606273] wlan0: direct probe to 00:03:52:1c:11:90 timed out
[114512.195602] wlan0: direct probe to 00:03:52:5d:26:f0 (try 1/3)
[114512.395222] wlan0: direct probe to 00:03:52:5d:26:f0 (try 2/3)
[114512.594907] wlan0: direct probe to 00:03:52:5d:26:f0 (try 3/3)
[114512.794504] wlan0: direct probe to 00:03:52:5d:26:f0 timed out
[114525.333988] wlan0: direct probe to 00:03:52:2c:6c:50 (try 1/3)
[114525.533559] wlan0: direct probe to 00:03:52:2c:6c:50 (try 2/3)
[114525.733192] wlan0: direct probe to 00:03:52:2c:6c:50 (try 3/3)
[114525.932849] wlan0: direct probe to 00:03:52:2c:6c:50 timed out
[114538.366434] wlan0: direct probe to 00:03:52:1c:14:b0 (try 1/3)
[114538.566093] wlan0: direct probe to 00:03:52:1c:14:b0 (try 2/3)
[114538.765748] wlan0: direct probe to 00:03:52:1c:14:b0 (try 3/3)
[114538.965406] wlan0: direct probe to 00:03:52:1c:14:b0 timed out
[114551.552113] wlan0: direct probe to 00:03:52:5d:3e:10 (try 1/3)
[114551.751375] wlan0: direct probe to 00:03:52:5d:3e:10 (try 2/3)
[114551.951024] wlan0: direct probe to 00:03:52:5d:3e:10 (try 3/3)
[114552.150650] wlan0: direct probe to 00:03:52:5d:3e:10 timed out
[114564.684743] wlan0: direct probe to 00:03:52:29:5e:40 (try 1/3)
[114564.883692] wlan0: direct probe to 00:03:52:29:5e:40 (try 2/3)
[114565.083344] wlan0: direct probe to 00:03:52:29:5e:40 (try 3/3)
[114565.283048] wlan0: direct probe to 00:03:52:29:5e:40 timed out
[114577.822398] wlan0: direct probe to 00:03:52:1b:f4:f0 (try 1/3)
[114578.022064] wlan0: direct probe to 00:03:52:1b:f4:f0 (try 2/3)
[114578.221718] wlan0: direct probe to 00:03:52:1b:f4:f0 (try 3/3)
[114578.421349] wlan0: direct probe to 00:03:52:1b:f4:f0 timed out
[114590.907328] wlan0: direct probe to 00:0f:61:1a:22:b0 (try 1/3)
[114591.106491] wlan0: direct probe to 00:0f:61:1a:22:b0 (try 2/3)
[114591.306169] wlan0: direct probe to 00:0f:61:1a:22:b0 (try 3/3)
[114591.505831] wlan0: direct probe to 00:0f:61:1a:22:b0 timed out
[114604.142637] wlan0: direct probe to 00:0f:61:1a:22:b0 (try 1/3)
[114604.341710] wlan0: direct probe to 00:0f:61:1a:22:b0 (try 2/3)
[114604.541350] wlan0: direct probe to 00:0f:61:1a:22:b0 (try 3/3)
[114604.741004] wlan0: direct probe to 00:0f:61:1a:22:b0 timed out
[114617.176048] wlan0: direct probe to 00:03:52:29:5e:40 (try 1/3)
[114617.375184] wlan0: direct probe to 00:03:52:29:5e:40 (try 2/3)
[114617.574898] wlan0: direct probe to 00:03:52:29:5e:40 (try 3/3)
[114617.774502] wlan0: direct probe to 00:03:52:29:5e:40 timed out
[114630.365597] wlan0: direct probe to 00:03:52:29:a3:00 (try 1/3)
[114630.564484] wlan0: direct probe to 00:03:52:29:a3:00 (try 2/3)
[114630.764074] wlan0: direct probe to 00:03:52:29:a3:00 (try 3/3)
[114630.963834] wlan0: direct probe to 00:03:52:29:a3:00 timed out
[114643.553430] wlan0: direct probe to 00:03:52:5d:41:30 (try 1/3)
[114643.752760] wlan0: direct probe to 00:03:52:5d:41:30 (try 2/3)
[114643.952359] wlan0: direct probe to 00:03:52:5d:41:30 (try 3/3)
[114644.152035] wlan0: direct probe to 00:03:52:5d:41:30 timed out
[114656.653594] wlan0: direct probe to 00:03:52:5d:41:30 (try 1/3)
[114656.853168] wlan0: direct probe to 00:03:52:5d:41:30 (try 2/3)
[114657.052793] wlan0: direct probe to 00:03:52:5d:41:30 (try 3/3)
[114657.252448] wlan0: direct probe to 00:03:52:5d:41:30 timed out
[114669.886249] wlan0: direct probe to 00:03:52:29:a3:00 (try 1/3)
[114670.085319] wlan0: direct probe to 00:03:52:29:a3:00 (try 2/3)
[114670.284996] wlan0: direct probe to 00:03:52:29:a3:00 (try 3/3)
[114670.484638] wlan0: direct probe to 00:03:52:29:a3:00 timed out
[114683.082022] wlan0: direct probe to 00:03:52:2c:6c:50 (try 1/3)
[114683.281604] wlan0: direct probe to 00:03:52:2c:6c:50 (try 2/3)
[114683.481185] wlan0: direct probe to 00:03:52:2c:6c:50 (try 3/3)
[114683.680870] wlan0: direct probe to 00:03:52:2c:6c:50 timed out
[114696.192979] wlan0: direct probe to 00:0f:61:1a:20:80 (try 1/3)
[114696.392006] wlan0: direct probe to 00:0f:61:1a:20:80 (try 2/3)
[114696.591640] wlan0: direct probe to 00:0f:61:1a:20:80 (try 3/3)
[114696.791310] wlan0: direct probe to 00:0f:61:1a:20:80 timed out
[114709.352961] wlan0: direct probe to 00:03:52:29:91:e0 (try 1/3)
[114709.552275] wlan0: direct probe to 00:03:52:29:91:e0 (try 2/3)
[114709.751922] wlan0: direct probe to 00:03:52:29:91:e0 (try 3/3)
[114709.951582] wlan0: direct probe to 00:03:52:29:91:e0 timed out
[114722.573265] wlan0: direct probe to 00:03:52:5c:38:30 (try 1/3)
[114722.772507] wlan0: direct probe to 00:03:52:5c:38:30 (try 2/3)
[114722.972148] wlan0: direct probe to 00:03:52:5c:38:30 (try 3/3)
[114723.171830] wlan0: direct probe to 00:03:52:5c:38:30 timed out
[114735.671722] wlan0: direct probe to 00:03:52:1c:11:90 (try 1/3)
[114735.870910] wlan0: direct probe to 00:03:52:1c:11:90 (try 2/3)
[114736.070603] wlan0: direct probe to 00:03:52:1c:11:90 (try 3/3)
[114736.270249] wlan0: direct probe to 00:03:52:1c:11:90 timed out
[114748.837761] wlan0: authenticate with 00:03:52:2c:01:01 (try 1)
[114748.839598] wlan0: authenticated
[114748.839882] wlan0: waiting for beacon from 00:03:52:2c:01:01
[114748.871900] wlan0: beacon received
[114748.876432] wlan0: associate with 00:03:52:2c:01:01 (try 1)
[114748.880216] wlan0: RX AssocResp from 00:03:52:2c:01:01 (capab=3D0xc21 s=
tatus=3D0 aid=3D1)
[114748.880221] wlan0: associated
[136965.546496] ata2.00: disabled
[136965.546745] ACPI: \_SB_.GDCK - undocking
[136965.547040] ata2.00: detaching (SCSI 1:0:0:0)
[136965.548520] ata2: exception Emask 0x50 SAct 0x0 SErr 0x4080800 action 0=
xe frozen
[136965.548527] ata2: irq_stat 0x000000c0, connection status changed
[136965.548536] ata2: SError: { HostInt 10B8B DevExch }
[136965.559074] ata2: hard resetting link
[136966.280747] ata2: SATA link down (SStatus 0 SControl 300)
[136966.280766] ata2: EH complete
[136998.133611] PM: Syncing filesystems ... done.
[136998.453294] Freezing user space processes ... (elapsed 0.01 seconds) do=
ne.
[136998.464274] Freezing remaining freezable tasks ... (elapsed 0.01 second=
s) done.
[136998.475386] Suspending console(s) (use no_console_suspend to debug)
[136998.662509] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[136998.719477] ACPI handle has no context!
[136998.910733] ehci_hcd 0000:00:1d.0: PCI INT D disabled
[136998.910741] ehci_hcd 0000:00:1a.0: PCI INT D disabled
[136999.011679] HDA Intel 0000:00:1b.0: PCI INT B disabled
[136999.097788] e1000e 0000:00:19.0: PME# enabled
[136999.097798] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
[136999.786402] sd 0:0:0:0: [sda] Stopping disk
[137001.922280] i915 0000:00:02.0: power state changed by ACPI to D3
[137001.922497] PM: suspend of devices complete after 3452.786 msecs
[137001.951213] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D3
[137001.968214] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D3
[137001.968352] PM: late suspend of devices complete after 45.929 msecs
[137001.968472] ACPI: Preparing to enter system sleep state S3
[137002.016152] PM: Saving platform NVS memory
[137002.151478] Disabling non-boot CPUs ...
[137002.165533] CPU 1 is now offline
[137002.180165] CPU 2 is now offline
[137002.187979] CPU 3 is now offline
[137002.188318] Extended CMOS year: 2000
[137002.188595] Back to C!
[137002.188598] PM: Restoring platform NVS memory
[137002.326001] Extended CMOS year: 2000
[137002.326058] Enabling non-boot CPUs ...
[137002.327475] Booting Node 0 Processor 1 APIC 0x1
[137002.435401] CPU1 is up
[137002.435493] Booting Node 0 Processor 2 APIC 0x4
[137002.544209] CPU2 is up
[137002.544311] Booting Node 0 Processor 3 APIC 0x5
[137002.652170] CPU3 is up
[137002.653140] ACPI: Waking up from system sleep state S3
[137002.738113] thinkpad_acpi: EC reports that Thermal Table has changed
[137002.754902] i915 0000:00:02.0: restoring config space at offset 0x1 (wa=
s 0x900007, writing 0x900407)
[137002.755017] ehci_hcd 0000:00:1a.0: restoring config space at offset 0xf=
 (was 0x400, writing 0x40b)
[137002.755037] ehci_hcd 0000:00:1a.0: restoring config space at offset 0x4=
 (was 0x0, writing 0xf2728000)
[137002.755045] ehci_hcd 0000:00:1a.0: restoring config space at offset 0x1=
 (was 0x2900000, writing 0x22900102)
[137002.771726] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[137002.773738] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[137002.773939] pci 0000:00:1c.4: restoring config space at offset 0xf (was=
 0x100, writing 0x4010b)
[137002.773951] pci 0000:00:1c.4: restoring config space at offset 0x9 (was=
 0x10001, writing 0x1fff1)
[137002.773957] pci 0000:00:1c.4: restoring config space at offset 0x8 (was=
 0x0, writing 0xf240f240)
[137002.773963] pci 0000:00:1c.4: restoring config space at offset 0x7 (was=
 0x0, writing 0xf0)
[137002.773972] pci 0000:00:1c.4: restoring config space at offset 0x3 (was=
 0x810000, writing 0x810010)
[137002.773979] pci 0000:00:1c.4: restoring config space at offset 0x1 (was=
 0x100000, writing 0x100107)
[137002.774013] ehci_hcd 0000:00:1d.0: restoring config space at offset 0xf=
 (was 0x400, writing 0x40b)
[137002.774032] ehci_hcd 0000:00:1d.0: restoring config space at offset 0x4=
 (was 0x0, writing 0xf2728400)
[137002.774040] ehci_hcd 0000:00:1d.0: restoring config space at offset 0x1=
 (was 0x2900000, writing 0x2900102)
[137002.775736] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[137002.777739] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[137002.777874] ahci 0000:00:1f.2: restoring config space at offset 0x1 (wa=
s 0x2b00007, writing 0x2b00407)
[137002.777944] intel ips 0000:00:1f.6: restoring config space at offset 0x=
f (was 0x400, writing 0x40b)
[137002.777968] intel ips 0000:00:1f.6: restoring config space at offset 0x=
1 (was 0x100000, writing 0x100002)
[137002.778053] iwlagn 0000:02:00.0: restoring config space at offset 0x1 (=
was 0x100106, writing 0x100506)
[137002.778253] PM: early resume of devices complete after 23.500 msecs
[137002.778416] i915 0000:00:02.0: power state changed by ACPI to D0
[137002.778454] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[137002.778460] e1000e 0000:00:19.0: PME# disabled
[137002.778536] e1000e 0000:00:19.0: irq 41 for MSI/MSI-X
[137002.778707] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) ->=
 IRQ 17
[137002.778711] pci 0000:00:1c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[137002.778716] HDA Intel 0000:00:1b.0: setting latency timer to 64
[137002.778719] pci 0000:00:1c.0: setting latency timer to 64
[137002.778729] pci 0000:00:1c.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[137002.778736] pci 0000:00:1c.3: setting latency timer to 64
[137002.778747] pci 0000:00:1c.4: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[137002.778755] pci 0000:00:1c.4: setting latency timer to 64
[137002.778773] HDA Intel 0000:00:1b.0: irq 42 for MSI/MSI-X
[137002.778811] pci 0000:00:1e.0: setting latency timer to 64
[137002.778827] ahci 0000:00:1f.2: setting latency timer to 64
[137002.778919] sd 0:0:0:0: [sda] Starting disk
[137002.779328] i915 0000:00:02.0: power state changed by ACPI to D0
[137002.779334] i915 0000:00:02.0: setting latency timer to 64
[137002.782591] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[137002.783159] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[137002.783168] ehci_hcd 0000:00:1d.0: PCI INT D -> GSI 19 (level, low) -> =
IRQ 19
[137002.783176] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[137002.998607] usb 2-1.1: reset high speed USB device using ehci_hcd and a=
ddress 3
[137003.085248] ata2: SATA link down (SStatus 0 SControl 300)
[137003.087210] ata6: SATA link down (SStatus 0 SControl 300)
[137003.089236] ata5: SATA link down (SStatus 0 SControl 300)
[137004.412728] Synaptics Touchpad, model: 1, fw: 7.4, id: 0x1e0b1, caps: 0=
xd047b3/0xb40000/0xa0000
[137004.412736] serio: Synaptics pass-through port at isa0060/serio1/input0
[137004.463668] input: SynPS/2 Synaptics TouchPad as /devices/platform/i804=
2/serio1/input/input21
[137006.190860] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[137006.209936] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succe=
eded
[137006.209943] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOC=
K) filtered out
[137006.209950] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filte=
red out
[137006.215074] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succe=
eded
[137006.215080] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOC=
K) filtered out
[137006.215086] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filte=
red out
[137006.217898] ata1.00: configured for UDMA/133
[137006.357710] PM: resume of devices complete after 3585.549 msecs
[137006.358449] Restarting tasks ... done.
[137006.359646] video LNXVIDEO:00: Restoring backlight state
[137006.390667] cfg80211: Calling CRDA to update world regulatory domain
[137009.658288] wlan0: authenticate with 9c:af:ca:12:6b:d0 (try 1)
[137009.857471] wlan0: authenticate with 9c:af:ca:12:6b:d0 (try 2)
[137009.858765] wlan0: authenticated
[137009.858999] wlan0: associate with 9c:af:ca:12:6b:d0 (try 1)
[137010.058120] wlan0: associate with 9c:af:ca:12:6b:d0 (try 2)
[137010.257779] wlan0: associate with 9c:af:ca:12:6b:d0 (try 3)
[137010.457423] wlan0: association with 9c:af:ca:12:6b:d0 timed out
[137011.100990] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[137011.363360] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/ser=
io1/serio8/input/input22
[137019.156173] wlan0: deauthenticating from 64:16:8d:ee:c1:70 by local cho=
ice (reason=3D3)
[137019.356546] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[137022.546664] wlan0: authenticate with 9c:af:ca:12:6b:d0 (try 1)
[137022.548053] wlan0: authenticated
[137022.548340] wlan0: associate with 9c:af:ca:12:6b:d0 (try 1)
[137022.747294] wlan0: associate with 9c:af:ca:12:6b:d0 (try 2)
[137022.946967] wlan0: associate with 9c:af:ca:12:6b:d0 (try 3)
[137023.146624] wlan0: association with 9c:af:ca:12:6b:d0 timed out
[137035.579857] wlan0: direct probe to 9c:af:ca:12:6b:d0 (try 1/3)
[137035.580658] wlan0: direct probe responded
[137035.584142] wlan0: authenticate with 9c:af:ca:12:6b:d0 (try 1)
[137035.584728] wlan0: authenticated
[137035.584970] wlan0: associate with 9c:af:ca:12:6b:d0 (try 1)
[137035.783853] wlan0: associate with 9c:af:ca:12:6b:d0 (try 2)
[137035.983506] wlan0: associate with 9c:af:ca:12:6b:d0 (try 3)
[137036.183160] wlan0: association with 9c:af:ca:12:6b:d0 timed out
[137048.568678] wlan0: authenticate with 64:16:8d:ee:bb:80 (try 1)
[137048.571411] wlan0: authenticated
[137048.571652] wlan0: associate with 64:16:8d:ee:bb:80 (try 1)
[137048.575020] wlan0: RX AssocResp from 64:16:8d:ee:bb:80 (capab=3D0x421 s=
tatus=3D0 aid=3D6)
[137048.575026] wlan0: associated
[137048.585498] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[137058.977836] wlan0: no IPv6 routers present
[137072.434580] iwlagn 0000:02:00.0: iwlagn_tx_agg_start on ra =3D 64:16:8d=
:ee:bb:80 tid =3D 0
[137135.980935] iwlagn 0000:02:00.0: low ack count detected, restart firmwa=
re
[137135.980943] iwlagn 0000:02:00.0: On demand firmware reload
[137136.100780] iwlagn 0000:02:00.0: Stopping AGG while state not ON or sta=
rting
[137136.100791] iwlagn 0000:02:00.0: queue number out of range: 0, must be =
10 to 19
[137155.325539] iwlagn 0000:02:00.0: Aggregation not enabled for tid 0 beca=
use load =3D 4
[137176.395016] PM: Syncing filesystems ... done.
[137176.687925] Freezing user space processes ... (elapsed 0.01 seconds) do=
ne.
[137176.698871] Freezing remaining freezable tasks ... (elapsed 0.01 second=
s) done.
[137176.710028] Suspending console(s) (use no_console_suspend to debug)
[137176.903585] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[137176.958608] ACPI handle has no context!
[137177.144349] ehci_hcd 0000:00:1d.0: PCI INT D disabled
[137177.144386] HDA Intel 0000:00:1b.0: PCI INT B disabled
[137177.330975] e1000e 0000:00:19.0: PME# enabled
[137177.330985] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
[137177.428204] sd 0:0:0:0: [sda] Stopping disk
[137180.155921] i915 0000:00:02.0: power state changed by ACPI to D3
[137180.156046] PM: suspend of devices complete after 3451.663 msecs
[137180.184851] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D3
[137180.201905] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D3
[137180.202017] PM: late suspend of devices complete after 46.045 msecs
[137180.202151] ACPI: Preparing to enter system sleep state S3
[137180.249828] PM: Saving platform NVS memory
[137180.383464] Disabling non-boot CPUs ...
[137180.398225] CPU 1 is now offline
[137180.413961] CPU 2 is now offline
[137180.422666] CPU 3 is now offline
[137180.423023] Extended CMOS year: 2000
[137180.423301] Back to C!
[137180.423304] PM: Restoring platform NVS memory
[137180.560665] Extended CMOS year: 2000
[137180.560719] Enabling non-boot CPUs ...
[137180.562061] Booting Node 0 Processor 1 APIC 0x1
[137180.670017] CPU1 is up
[137180.670107] Booting Node 0 Processor 2 APIC 0x4
[137180.777834] CPU2 is up
[137180.777936] Booting Node 0 Processor 3 APIC 0x5
[137180.885785] CPU3 is up
[137180.886778] ACPI: Waking up from system sleep state S3
[137180.963580] i915 0000:00:02.0: restoring config space at offset 0x1 (wa=
s 0x900007, writing 0x900407)
[137180.963696] ehci_hcd 0000:00:1a.0: restoring config space at offset 0xf=
 (was 0x400, writing 0x40b)
[137180.963715] ehci_hcd 0000:00:1a.0: restoring config space at offset 0x4=
 (was 0x0, writing 0xf2728000)
[137180.963724] ehci_hcd 0000:00:1a.0: restoring config space at offset 0x1=
 (was 0x2900000, writing 0x2900102)
[137180.974407] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[137180.976453] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[137180.976645] pci 0000:00:1c.4: restoring config space at offset 0xf (was=
 0x100, writing 0x4010b)
[137180.976657] pci 0000:00:1c.4: restoring config space at offset 0x9 (was=
 0x10001, writing 0x1fff1)
[137180.976663] pci 0000:00:1c.4: restoring config space at offset 0x8 (was=
 0x0, writing 0xf240f240)
[137180.976668] pci 0000:00:1c.4: restoring config space at offset 0x7 (was=
 0x0, writing 0xf0)
[137180.976678] pci 0000:00:1c.4: restoring config space at offset 0x3 (was=
 0x810000, writing 0x810010)
[137180.976685] pci 0000:00:1c.4: restoring config space at offset 0x1 (was=
 0x100000, writing 0x100107)
[137180.976719] ehci_hcd 0000:00:1d.0: restoring config space at offset 0xf=
 (was 0x400, writing 0x40b)
[137180.976739] ehci_hcd 0000:00:1d.0: restoring config space at offset 0x4=
 (was 0x0, writing 0xf2728400)
[137180.976747] ehci_hcd 0000:00:1d.0: restoring config space at offset 0x1=
 (was 0x2900000, writing 0x2900102)
[137180.978452] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[137180.980445] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[137180.980569] ahci 0000:00:1f.2: restoring config space at offset 0x1 (wa=
s 0x2b00007, writing 0x2b00407)
[137180.980640] intel ips 0000:00:1f.6: restoring config space at offset 0x=
f (was 0x400, writing 0x40b)
[137180.980664] intel ips 0000:00:1f.6: restoring config space at offset 0x=
1 (was 0x100000, writing 0x100002)
[137180.980748] iwlagn 0000:02:00.0: restoring config space at offset 0x1 (=
was 0x100106, writing 0x100506)
[137180.980948] PM: early resume of devices complete after 17.507 msecs
[137180.981210] pci 0000:00:1c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[137180.981217] pci 0000:00:1c.0: setting latency timer to 64
[137180.981236] pci 0000:00:1c.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[137180.981243] pci 0000:00:1c.3: setting latency timer to 64
[137180.981247] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[137180.981254] e1000e 0000:00:19.0: PME# disabled
[137180.981258] pci 0000:00:1c.4: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[137180.981265] pci 0000:00:1c.4: setting latency timer to 64
[137180.981272] pci 0000:00:1e.0: setting latency timer to 64
[137180.981308] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) ->=
 IRQ 17
[137180.981316] HDA Intel 0000:00:1b.0: setting latency timer to 64
[137180.981373] HDA Intel 0000:00:1b.0: irq 41 for MSI/MSI-X
[137180.981443] e1000e 0000:00:19.0: irq 42 for MSI/MSI-X
[137180.984529] ahci 0000:00:1f.2: setting latency timer to 64
[137180.984651] sd 0:0:0:0: [sda] Starting disk
[137180.984726] i915 0000:00:02.0: power state changed by ACPI to D0
[137180.984742] i915 0000:00:02.0: power state changed by ACPI to D0
[137180.984749] i915 0000:00:02.0: setting latency timer to 64
[137180.984960] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[137180.985199] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[137180.985206] ehci_hcd 0000:00:1d.0: PCI INT D -> GSI 19 (level, low) -> =
IRQ 19
[137180.985243] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[137181.201229] usb 2-1.1: reset high speed USB device using ehci_hcd and a=
ddress 3
[137181.288873] ata2: SATA link down (SStatus 0 SControl 300)
[137181.290868] ata6: SATA link down (SStatus 0 SControl 300)
[137181.292880] ata5: SATA link down (SStatus 0 SControl 300)
[137182.607871] Synaptics Touchpad, model: 1, fw: 7.4, id: 0x1e0b1, caps: 0=
xd047b3/0xb40000/0xa0000
[137182.607879] serio: Synaptics pass-through port at isa0060/serio1/input0
[137182.658548] input: SynPS/2 Synaptics TouchPad as /devices/platform/i804=
2/serio1/input/input23
[137184.504274] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[137184.506568] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succe=
eded
[137184.506575] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOC=
K) filtered out
[137184.506581] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filte=
red out
[137184.514932] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succe=
eded
[137184.514939] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOC=
K) filtered out
[137184.514944] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filte=
red out
[137184.519003] ata1.00: configured for UDMA/133
[137184.754745] PM: resume of devices complete after 3780.224 msecs
[137184.755498] Restarting tasks ... done.
[137184.756485] video LNXVIDEO:00: Restoring backlight state
[137184.796023] cfg80211: Calling CRDA to update world regulatory domain
[137188.220564] wlan0: authenticate with 00:11:92:ad:65:80 (try 1)
[137188.223090] wlan0: authenticated
[137188.223359] wlan0: associate with 00:11:92:ad:65:80 (try 1)
[137188.422524] wlan0: associate with 00:11:92:ad:65:80 (try 2)
[137188.425441] wlan0: RX AssocResp from 00:11:92:ad:65:80 (capab=3D0x401 s=
tatus=3D0 aid=3D94)
[137188.425447] wlan0: associated
[137189.287563] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[137189.548796] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/ser=
io1/serio9/input/input24
[137228.990610] tun0: Disabled Privacy Extensions
[137361.185047] cfg80211: Calling CRDA to update world regulatory domain
[137372.675204] wlan0: authenticate with 00:11:92:ad:65:80 (try 1)
[137372.874549] wlan0: authenticate with 00:11:92:ad:65:80 (try 2)
[137372.889448] wlan0: authenticated
[137372.889793] wlan0: associate with 00:11:92:ad:65:80 (try 1)
[137372.907954] wlan0: RX AssocResp from 00:11:92:ad:65:80 (capab=3D0x401 s=
tatus=3D0 aid=3D99)
[137372.907959] wlan0: associated
[137387.728980] tun0: Disabled Privacy Extensions
[137441.309299] tun0: Disabled Privacy Extensions
[137621.744782] cfg80211: Calling CRDA to update world regulatory domain
[137625.022292] wlan0: authenticate with 00:11:92:ad:65:80 (try 1)
[137625.221496] wlan0: authenticate with 00:11:92:ad:65:80 (try 2)
[137625.421163] wlan0: authenticate with 00:11:92:ad:65:80 (try 3)
[137625.620828] wlan0: authentication with 00:11:92:ad:65:80 timed out
[137711.783130] wlan0: direct probe to 00:11:92:a9:5d:80 (try 1/3)
[137711.786090] wlan0: direct probe responded
[137711.790181] wlan0: authenticate with 00:11:92:a9:5d:80 (try 1)
[137711.791677] wlan0: authenticated
[137711.791937] wlan0: associate with 00:11:92:a9:5d:80 (try 1)
[137711.990888] wlan0: associate with 00:11:92:a9:5d:80 (try 2)
[137711.995499] wlan0: RX AssocResp from 00:11:92:a9:5d:80 (capab=3D0x401 s=
tatus=3D0 aid=3D124)
[137711.995505] wlan0: associated
[137726.016385] tun0: Disabled Privacy Extensions
[137735.545469] cfg80211: Calling CRDA to update world regulatory domain
[137738.953615] wlan0: authenticate with 00:11:92:a9:6a:50 (try 1)
[137739.153047] wlan0: authenticate with 00:11:92:a9:6a:50 (try 2)
[137739.155491] wlan0: authenticated
[137739.155776] wlan0: associate with 00:11:92:a9:6a:50 (try 1)
[137739.160087] wlan0: RX AssocResp from 00:11:92:a9:6a:50 (capab=3D0x401 s=
tatus=3D0 aid=3D41)
[137739.160093] wlan0: associated
[137761.486745] tun0: Disabled Privacy Extensions
[137802.433243] cfg80211: Calling CRDA to update world regulatory domain
[138124.577077] wlan0: direct probe to 00:13:49:1a:ef:4a (try 1/3)
[138124.776215] wlan0: direct probe to 00:13:49:1a:ef:4a (try 2/3)
[138124.975855] wlan0: direct probe to 00:13:49:1a:ef:4a (try 3/3)
[138125.175487] wlan0: direct probe to 00:13:49:1a:ef:4a timed out
[138362.069131] PM: Syncing filesystems ... done.
[138362.477337] Freezing user space processes ... (elapsed 0.01 seconds) do=
ne.
[138362.488398] Freezing remaining freezable tasks ... (elapsed 0.01 second=
s) done.
[138362.499463] Suspending console(s) (use no_console_suspend to debug)
[138362.698906] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[138362.757561] ACPI handle has no context!
[138362.835271] sd 0:0:0:0: [sda] Stopping disk
[138362.948841] ehci_hcd 0000:00:1d.0: PCI INT D disabled
[138362.948880] HDA Intel 0000:00:1b.0: PCI INT B disabled
[138363.135765] e1000e 0000:00:19.0: PME# enabled
[138363.135775] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
[138365.960358] i915 0000:00:02.0: power state changed by ACPI to D3
[138365.960468] PM: suspend of devices complete after 3466.676 msecs
[138365.989303] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D3
[138366.006357] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D3
[138366.006471] PM: late suspend of devices complete after 46.078 msecs
[138366.006607] ACPI: Preparing to enter system sleep state S3
[138366.054279] PM: Saving platform NVS memory
[138366.188228] Disabling non-boot CPUs ...
[138366.202679] CPU 1 is now offline
[138366.216402] CPU 2 is now offline
[138366.232045] CPU 3 is now offline
[138366.232359] Extended CMOS year: 2000
[138366.232638] Back to C!
[138366.232641] PM: Restoring platform NVS memory
[138366.370033] Extended CMOS year: 2000
[138366.370089] Enabling non-boot CPUs ...
[138366.371532] Booting Node 0 Processor 1 APIC 0x1
[138366.479482] CPU1 is up
[138366.479572] Booting Node 0 Processor 2 APIC 0x4
[138366.587299] CPU2 is up
[138366.587401] Booting Node 0 Processor 3 APIC 0x5
[138366.695249] CPU3 is up
[138366.696239] ACPI: Waking up from system sleep state S3
[138366.773049] i915 0000:00:02.0: restoring config space at offset 0x1 (wa=
s 0x900007, writing 0x900407)
[138366.773166] ehci_hcd 0000:00:1a.0: restoring config space at offset 0xf=
 (was 0x400, writing 0x40b)
[138366.773186] ehci_hcd 0000:00:1a.0: restoring config space at offset 0x4=
 (was 0x0, writing 0xf2728000)
[138366.773194] ehci_hcd 0000:00:1a.0: restoring config space at offset 0x1=
 (was 0x2900000, writing 0x2900102)
[138366.783879] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[138366.785931] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[138366.786123] pci 0000:00:1c.4: restoring config space at offset 0xf (was=
 0x100, writing 0x4010b)
[138366.786136] pci 0000:00:1c.4: restoring config space at offset 0x9 (was=
 0x10001, writing 0x1fff1)
[138366.786141] pci 0000:00:1c.4: restoring config space at offset 0x8 (was=
 0x0, writing 0xf240f240)
[138366.786147] pci 0000:00:1c.4: restoring config space at offset 0x7 (was=
 0x0, writing 0xf0)
[138366.786156] pci 0000:00:1c.4: restoring config space at offset 0x3 (was=
 0x810000, writing 0x810010)
[138366.786163] pci 0000:00:1c.4: restoring config space at offset 0x1 (was=
 0x100000, writing 0x100107)
[138366.786196] ehci_hcd 0000:00:1d.0: restoring config space at offset 0xf=
 (was 0x400, writing 0x40b)
[138366.786215] ehci_hcd 0000:00:1d.0: restoring config space at offset 0x4=
 (was 0x0, writing 0xf2728400)
[138366.786224] ehci_hcd 0000:00:1d.0: restoring config space at offset 0x1=
 (was 0x2900000, writing 0x2900102)
[138366.787925] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[138366.789924] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[138366.790054] ahci 0000:00:1f.2: restoring config space at offset 0x1 (wa=
s 0x2b00007, writing 0x2b00407)
[138366.790124] intel ips 0000:00:1f.6: restoring config space at offset 0x=
f (was 0x400, writing 0x40b)
[138366.790147] intel ips 0000:00:1f.6: restoring config space at offset 0x=
1 (was 0x100000, writing 0x100002)
[138366.790233] iwlagn 0000:02:00.0: restoring config space at offset 0x1 (=
was 0x100106, writing 0x100506)
[138366.790432] PM: early resume of devices complete after 17.524 msecs
[138366.790724] pci 0000:00:1c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[138366.790728] pci 0000:00:1c.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[138366.790731] pci 0000:00:1c.0: setting latency timer to 64
[138366.790734] pci 0000:00:1c.3: setting latency timer to 64
[138366.790746] pci 0000:00:1c.4: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[138366.790752] pci 0000:00:1c.4: setting latency timer to 64
[138366.790786] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[138366.790792] e1000e 0000:00:19.0: PME# disabled
[138366.790824] pci 0000:00:1e.0: setting latency timer to 64
[138366.790847] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) ->=
 IRQ 17
[138366.790855] HDA Intel 0000:00:1b.0: setting latency timer to 64
[138366.790944] HDA Intel 0000:00:1b.0: irq 41 for MSI/MSI-X
[138366.791039] e1000e 0000:00:19.0: irq 42 for MSI/MSI-X
[138366.792830] ahci 0000:00:1f.2: setting latency timer to 64
[138366.792963] i915 0000:00:02.0: power state changed by ACPI to D0
[138366.793002] sd 0:0:0:0: [sda] Starting disk
[138366.793026] i915 0000:00:02.0: power state changed by ACPI to D0
[138366.793032] i915 0000:00:02.0: setting latency timer to 64
[138366.793891] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[138366.794052] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[138366.794060] ehci_hcd 0000:00:1d.0: PCI INT D -> GSI 19 (level, low) -> =
IRQ 19
[138366.794068] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[138367.009631] usb 2-1.1: reset high speed USB device using ehci_hcd and a=
ddress 3
[138367.098316] ata2: SATA link down (SStatus 0 SControl 300)
[138367.100349] ata6: SATA link down (SStatus 0 SControl 300)
[138367.101293] ata5: SATA link down (SStatus 0 SControl 300)
[138368.427316] Synaptics Touchpad, model: 1, fw: 7.4, id: 0x1e0b1, caps: 0=
xd047b3/0xb40000/0xa0000
[138368.427324] serio: Synaptics pass-through port at isa0060/serio1/input0
[138368.478305] input: SynPS/2 Synaptics TouchPad as /devices/platform/i804=
2/serio1/input/input25
[138370.255956] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[138370.258289] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succe=
eded
[138370.258297] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOC=
K) filtered out
[138370.258302] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filte=
red out
[138370.266587] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succe=
eded
[138370.266593] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOC=
K) filtered out
[138370.266599] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filte=
red out
[138370.270718] ata1.00: configured for UDMA/133
[138370.538600] PM: resume of devices complete after 3754.552 msecs
[138370.539341] Restarting tasks ... done.
[138370.546037] video LNXVIDEO:00: Restoring backlight state
[138372.325364] thinkpad_acpi: EC reports that Thermal Table has changed
[138372.701100] ata2: exception Emask 0x10 SAct 0x0 SErr 0x4040000 action 0=
xe frozen
[138372.701106] ata2: irq_stat 0x000000c0, connection status changed
[138372.701111] ata2: SError: { CommWake DevExch }
[138372.711677] ata2: hard resetting link
[138372.924997] ACPI: \_SB_.GDCK - docking
[138373.588136] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[138373.593532] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
[138373.594363] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
[138373.598079] ata2.00: ATAPI: HL-DT-ST DVDRAM GSA-U20N, HX12, max UDMA/133
[138373.604478] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
[138373.605345] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
[138373.609089] ata2.00: configured for UDMA/133
[138373.727887] ata2: EH complete
[138373.730999] scsi 1:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-U20N  H=
X12 PQ: 0 ANSI: 5
[138373.804519] wlan0: authenticate with 00:14:6c:67:9c:32 (try 1)
[138373.807968] wlan0: authenticated
[138373.808254] wlan0: associate with 00:14:6c:67:9c:32 (try 1)
[138373.858379] wlan0: RX AssocResp from 00:14:6c:67:9c:32 (capab=3D0x611 s=
tatus=3D0 aid=3D10)
[138373.858385] wlan0: associated
[138374.070316] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2=
 cdda tray
[138374.070603] sr 1:0:0:0: Attached scsi CD-ROM sr0
[138374.070804] sr 1:0:0:0: Attached scsi generic sg1 type 5
[138374.684337] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Cont=
rol: RX
[138374.684345] e1000e 0000:00:19.0: eth0: 10/100 speed: disabling TSO
[138375.363428] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[138375.626295] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/ser=
io1/serio10/input/input26
[142731.520159] ata2.00: disabled
[142731.520371] ACPI: \_SB_.GDCK - undocking
[142731.520613] ata2.00: detaching (SCSI 1:0:0:0)
[142731.522151] ata2: exception Emask 0x50 SAct 0x0 SErr 0x4080800 action 0=
xe frozen
[142731.522159] ata2: irq_stat 0x000000c0, connection status changed
[142731.522168] ata2: SError: { HostInt 10B8B DevExch }
[142731.532649] ata2: hard resetting link
[142732.254468] ata2: SATA link down (SStatus 0 SControl 300)
[142732.254486] ata2: EH complete
[142733.324275] PM: Syncing filesystems ... done.
[142733.986410] Freezing user space processes ... (elapsed 0.01 seconds) do=
ne.
[142733.997427] Freezing remaining freezable tasks ... (elapsed 0.01 second=
s) done.
[142734.008572] Suspending console(s) (use no_console_suspend to debug)
[142734.197416] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[142734.197619] sd 0:0:0:0: [sda] Stopping disk
[142734.253996] ACPI handle has no context!
[142734.445948] ehci_hcd 0000:00:1d.0: PCI INT D disabled
[142734.546816] HDA Intel 0000:00:1b.0: PCI INT B disabled
[142734.632805] e1000e 0000:00:19.0: PME# enabled
[142734.632814] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
[142737.457429] i915 0000:00:02.0: power state changed by ACPI to D3
[142737.457546] PM: suspend of devices complete after 3454.653 msecs
[142737.486370] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D3
[142737.503361] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D3
[142737.503500] PM: late suspend of devices complete after 46.029 msecs
[142737.503619] ACPI: Preparing to enter system sleep state S3
[142737.551350] PM: Saving platform NVS memory
[142737.686221] Disabling non-boot CPUs ...
[142737.704691] CPU 1 is now offline
[142737.723400] CPU 2 is now offline
[142737.737063] CPU 3 is now offline
[142737.737406] Extended CMOS year: 2000
[142737.737683] Back to C!
[142737.737686] PM: Restoring platform NVS memory
[142737.875051] Extended CMOS year: 2000
[142737.875107] Enabling non-boot CPUs ...
[142737.876575] Booting Node 0 Processor 1 APIC 0x1
[142737.984496] CPU1 is up
[142737.984588] Booting Node 0 Processor 2 APIC 0x4
[142738.092310] CPU2 is up
[142738.092397] Booting Node 0 Processor 3 APIC 0x5
[142738.201258] CPU3 is up
[142738.202237] ACPI: Waking up from system sleep state S3
[142738.288198] thinkpad_acpi: EC reports that Thermal Table has changed
[142738.301001] i915 0000:00:02.0: restoring config space at offset 0x1 (wa=
s 0x900007, writing 0x900407)
[142738.301115] ehci_hcd 0000:00:1a.0: restoring config space at offset 0xf=
 (was 0x400, writing 0x40b)
[142738.301135] ehci_hcd 0000:00:1a.0: restoring config space at offset 0x4=
 (was 0x0, writing 0xf2728000)
[142738.301143] ehci_hcd 0000:00:1a.0: restoring config space at offset 0x1=
 (was 0x2900000, writing 0x2900102)
[142738.319816] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[142738.321830] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[142738.322034] pci 0000:00:1c.4: restoring config space at offset 0xf (was=
 0x100, writing 0x4010b)
[142738.322046] pci 0000:00:1c.4: restoring config space at offset 0x9 (was=
 0x10001, writing 0x1fff1)
[142738.322052] pci 0000:00:1c.4: restoring config space at offset 0x8 (was=
 0x0, writing 0xf240f240)
[142738.322057] pci 0000:00:1c.4: restoring config space at offset 0x7 (was=
 0x0, writing 0xf0)
[142738.322066] pci 0000:00:1c.4: restoring config space at offset 0x3 (was=
 0x810000, writing 0x810010)
[142738.322073] pci 0000:00:1c.4: restoring config space at offset 0x1 (was=
 0x100000, writing 0x100107)
[142738.322107] ehci_hcd 0000:00:1d.0: restoring config space at offset 0xf=
 (was 0x400, writing 0x40b)
[142738.322126] ehci_hcd 0000:00:1d.0: restoring config space at offset 0x4=
 (was 0x0, writing 0xf2728400)
[142738.322134] ehci_hcd 0000:00:1d.0: restoring config space at offset 0x1=
 (was 0x2900000, writing 0x2900102)
[142738.323823] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[142738.325831] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[142738.325964] ahci 0000:00:1f.2: restoring config space at offset 0x1 (wa=
s 0x2b00007, writing 0x2b00407)
[142738.326033] intel ips 0000:00:1f.6: restoring config space at offset 0x=
f (was 0x400, writing 0x40b)
[142738.326059] intel ips 0000:00:1f.6: restoring config space at offset 0x=
1 (was 0x100000, writing 0x100002)
[142738.326143] iwlagn 0000:02:00.0: restoring config space at offset 0x1 (=
was 0x100106, writing 0x100506)
[142738.326343] PM: early resume of devices complete after 25.496 msecs
[142738.326574] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[142738.326581] e1000e 0000:00:19.0: PME# disabled
[142738.326595] pci 0000:00:1c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[142738.326601] pci 0000:00:1c.0: setting latency timer to 64
[142738.326623] pci 0000:00:1c.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[142738.326629] pci 0000:00:1c.3: setting latency timer to 64
[142738.326640] pci 0000:00:1c.4: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[142738.326646] pci 0000:00:1c.4: setting latency timer to 64
[142738.326657] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) ->=
 IRQ 17
[142738.326667] HDA Intel 0000:00:1b.0: setting latency timer to 64
[142738.326713] HDA Intel 0000:00:1b.0: irq 41 for MSI/MSI-X
[142738.326770] pci 0000:00:1e.0: setting latency timer to 64
[142738.326876] ahci 0000:00:1f.2: setting latency timer to 64
[142738.326897] e1000e 0000:00:19.0: irq 42 for MSI/MSI-X
[142738.327080] sd 0:0:0:0: [sda] Starting disk
[142738.327818] i915 0000:00:02.0: power state changed by ACPI to D0
[142738.327951] i915 0000:00:02.0: power state changed by ACPI to D0
[142738.327957] i915 0000:00:02.0: setting latency timer to 64
[142738.330109] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[142738.330270] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[142738.330278] ehci_hcd 0000:00:1d.0: PCI INT D -> GSI 19 (level, low) -> =
IRQ 19
[142738.330286] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[142738.545553] usb 2-1.1: reset high speed USB device using ehci_hcd and a=
ddress 3
[142738.632300] ata5: SATA link down (SStatus 0 SControl 300)
[142738.636267] ata2: SATA link down (SStatus 0 SControl 300)
[142738.638270] ata6: SATA link down (SStatus 0 SControl 300)
[142739.962216] Synaptics Touchpad, model: 1, fw: 7.4, id: 0x1e0b1, caps: 0=
xd047b3/0xb40000/0xa0000
[142739.962225] serio: Synaptics pass-through port at isa0060/serio1/input0
[142740.013554] input: SynPS/2 Synaptics TouchPad as /devices/platform/i804=
2/serio1/input/input27
[142740.979226] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Con=
trol: None
[142741.741911] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[142741.744171] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succe=
eded
[142741.744179] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOC=
K) filtered out
[142741.744185] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filte=
red out
[142741.752430] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succe=
eded
[142741.752437] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOC=
K) filtered out
[142741.752442] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filte=
red out
[142741.756462] ata1.00: configured for UDMA/133
[142742.012026] PM: resume of devices complete after 3691.961 msecs
[142742.012803] Restarting tasks ... done.
[142742.014676] video LNXVIDEO:00: Restoring backlight state
[142742.043480] cfg80211: Calling CRDA to update world regulatory domain
[142745.340074] wlan0: authenticate with 64:16:8d:ee:9b:a0 (try 1)
[142745.342395] wlan0: authenticated
[142745.342758] wlan0: waiting for beacon from 64:16:8d:ee:9b:a0
[142745.355643] wlan0: beacon received
[142745.360720] wlan0: associate with 64:16:8d:ee:9b:a0 (try 1)
[142745.364101] wlan0: RX AssocResp from 64:16:8d:ee:9b:a0 (capab=3D0x421 s=
tatus=3D0 aid=3D4)
[142745.364106] wlan0: associated
[142746.665257] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[142746.927958] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/ser=
io1/serio11/input/input28
[142754.296786] wlan0: deauthenticating from 64:16:8d:ee:9b:a0 by local cho=
ice (reason=3D3)
[142754.302469] cfg80211: Calling CRDA to update world regulatory domain
[142768.457910] device eth0 entered promiscuous mode
[142772.795081] device eth0 left promiscuous mode
[147823.346263] PM: Syncing filesystems ... done.
[147823.671250] Freezing user space processes ... (elapsed 0.01 seconds) do=
ne.
[147823.682245] Freezing remaining freezable tasks ... (elapsed 0.01 second=
s) done.
[147823.693369] Suspending console(s) (use no_console_suspend to debug)
[147823.882086] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[147823.937302] ACPI handle has no context!
[147824.128741] HDA Intel 0000:00:1b.0: PCI INT B disabled
[147824.128744] ehci_hcd 0000:00:1d.0: PCI INT D disabled
[147824.230689] sd 0:0:0:0: [sda] Stopping disk
[147824.315586] e1000e 0000:00:19.0: PME# enabled
[147824.315598] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
[147827.140262] i915 0000:00:02.0: power state changed by ACPI to D3
[147827.140399] PM: suspend of devices complete after 3452.675 msecs
[147827.169199] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D3
[147827.186253] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D3
[147827.186371] PM: late suspend of devices complete after 46.046 msecs
[147827.186490] ACPI: Preparing to enter system sleep state S3
[147827.234128] PM: Saving platform NVS memory
[147827.368237] Disabling non-boot CPUs ...
[147827.382587] CPU 1 is now offline
[147827.396234] CPU 2 is now offline
[147827.411995] CPU 3 is now offline
[147827.412368] Extended CMOS year: 2000
[147827.412647] Back to C!
[147827.412650] PM: Restoring platform NVS memory
[147827.550043] Extended CMOS year: 2000
[147827.550099] Enabling non-boot CPUs ...
[147827.551430] Booting Node 0 Processor 1 APIC 0x1
[147827.659379] CPU1 is up
[147827.659465] Booting Node 0 Processor 2 APIC 0x4
[147827.767194] CPU2 is up
[147827.767297] Booting Node 0 Processor 3 APIC 0x5
[147827.875145] CPU3 is up
[147827.876137] ACPI: Waking up from system sleep state S3
[147827.952903] i915 0000:00:02.0: restoring config space at offset 0x1 (wa=
s 0x900007, writing 0x900407)
[147827.953020] ehci_hcd 0000:00:1a.0: restoring config space at offset 0xf=
 (was 0x400, writing 0x40b)
[147827.953041] ehci_hcd 0000:00:1a.0: restoring config space at offset 0x4=
 (was 0x0, writing 0xf2728000)
[147827.953050] ehci_hcd 0000:00:1a.0: restoring config space at offset 0x1=
 (was 0x2900000, writing 0x2900102)
[147827.963776] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[147827.965828] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[147827.966020] pci 0000:00:1c.4: restoring config space at offset 0xf (was=
 0x100, writing 0x4010b)
[147827.966032] pci 0000:00:1c.4: restoring config space at offset 0x9 (was=
 0x10001, writing 0x1fff1)
[147827.966038] pci 0000:00:1c.4: restoring config space at offset 0x8 (was=
 0x0, writing 0xf240f240)
[147827.966043] pci 0000:00:1c.4: restoring config space at offset 0x7 (was=
 0x0, writing 0xf0)
[147827.966053] pci 0000:00:1c.4: restoring config space at offset 0x3 (was=
 0x810000, writing 0x810010)
[147827.966060] pci 0000:00:1c.4: restoring config space at offset 0x1 (was=
 0x100000, writing 0x100107)
[147827.966093] ehci_hcd 0000:00:1d.0: restoring config space at offset 0xf=
 (was 0x400, writing 0x40b)
[147827.966112] ehci_hcd 0000:00:1d.0: restoring config space at offset 0x4=
 (was 0x0, writing 0xf2728400)
[147827.966121] ehci_hcd 0000:00:1d.0: restoring config space at offset 0x1=
 (was 0x2900000, writing 0x2900102)
[147827.967822] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[147827.969821] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[147827.969947] ahci 0000:00:1f.2: restoring config space at offset 0x1 (wa=
s 0x2b00007, writing 0x2b00407)
[147827.970018] intel ips 0000:00:1f.6: restoring config space at offset 0x=
f (was 0x400, writing 0x40b)
[147827.970041] intel ips 0000:00:1f.6: restoring config space at offset 0x=
1 (was 0x100000, writing 0x100002)
[147827.970127] iwlagn 0000:02:00.0: restoring config space at offset 0x1 (=
was 0x100106, writing 0x100506)
[147827.970326] PM: early resume of devices complete after 17.569 msecs
[147827.976777] pci 0000:00:1c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[147827.976783] pci 0000:00:1c.0: setting latency timer to 64
[147827.976814] pci 0000:00:1c.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[147827.976817] pci 0000:00:1c.4: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[147827.976820] pci 0000:00:1c.3: setting latency timer to 64
[147827.976823] pci 0000:00:1c.4: setting latency timer to 64
[147827.976878] pci 0000:00:1e.0: setting latency timer to 64
[147827.976959] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[147827.976966] e1000e 0000:00:19.0: PME# disabled
[147827.976977] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) ->=
 IRQ 17
[147827.976987] ahci 0000:00:1f.2: setting latency timer to 64
[147827.976989] HDA Intel 0000:00:1b.0: setting latency timer to 64
[147827.977096] HDA Intel 0000:00:1b.0: irq 41 for MSI/MSI-X
[147827.977159] e1000e 0000:00:19.0: irq 42 for MSI/MSI-X
[147827.977186] sd 0:0:0:0: [sda] Starting disk
[147827.977226] i915 0000:00:02.0: power state changed by ACPI to D0
[147827.977280] i915 0000:00:02.0: power state changed by ACPI to D0
[147827.977285] i915 0000:00:02.0: setting latency timer to 64
[147827.977355] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[147827.977512] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[147827.977520] ehci_hcd 0000:00:1d.0: PCI INT D -> GSI 19 (level, low) -> =
IRQ 19
[147827.977529] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[147828.193620] usb 2-1.1: reset high speed USB device using ehci_hcd and a=
ddress 3
[147828.281268] ata2: SATA link down (SStatus 0 SControl 300)
[147828.283241] ata5: SATA link down (SStatus 0 SControl 300)
[147828.287236] ata6: SATA link down (SStatus 0 SControl 300)
[147829.618211] Synaptics Touchpad, model: 1, fw: 7.4, id: 0x1e0b1, caps: 0=
xd047b3/0xb40000/0xa0000
[147829.618220] serio: Synaptics pass-through port at isa0060/serio1/input0
[147829.669124] input: SynPS/2 Synaptics TouchPad as /devices/platform/i804=
2/serio1/input/input29
[147830.768914] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Con=
trol: None
[147831.494642] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[147831.496925] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succe=
eded
[147831.496932] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOC=
K) filtered out
[147831.496938] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filte=
red out
[147831.505176] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succe=
eded
[147831.505183] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOC=
K) filtered out
[147831.505188] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filte=
red out
[147831.509220] ata1.00: configured for UDMA/133
[147831.642586] PM: resume of devices complete after 3678.515 msecs
[147831.643396] Restarting tasks ... done.
[147831.644569] video LNXVIDEO:00: Restoring backlight state
[147833.393944] cupsd[26770]: segfault at 0 ip 00007feee70bc5b2 sp 00007fff=
8719df78 error 4 in libc-2.12.2.so[7feee7041000+153000]
[147836.363978] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[147836.628439] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/ser=
io1/serio12/input/input30
[150143.340858] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[150151.938024] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[150153.575160] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[150153.575283] [drm:i915_reset] *ERROR* GPU hanging too fast, declaring we=
dged!
[150153.575289] [drm:i915_reset] *ERROR* Failed to reset chip.

--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="broken-rendering-2.6.37-05761-gf878133.screwede.xorg-log"
Content-Transfer-Encoding: quoted-printable

[133915.555]=20
X.Org X Server 1.9.2
Release Date: 2010-10-30
[133915.559] X Protocol Version 11, Revision 0
[133915.560] Build Operating System: Linux 2.6.35-ARCH x86_64=20
[133915.561] Current Operating System: Linux kr 2.6.37-05761-gf878133 #55 S=
MP PREEMPT Thu Jan 13 16:27:39 CET 2011 x86_64
[133915.562] Kernel command line:=20
[133915.564] Build Date: 01 November 2010  10:29:19PM
[133915.565] =20
[133915.565] Current version of pixman: 0.20.0
[133915.566] 	Before reporting problems, check http://wiki.x.org
	to make sure that you have the latest version.
[133915.568] Markers: (--) probed, (**) from config file, (=3D=3D) default =
setting,
	(++) from command line, (!!) notice, (II) informational,
	(WW) warning, (EE) error, (NI) not implemented, (??) unknown.
[133915.571] (=3D=3D) Log file: "/var/log/Xorg.0.log", Time: Mon Jan 17 13:=
30:26 2011
[133915.572] (=3D=3D) Using config directory: "/etc/X11/xorg.conf.d"
[133915.573] (=3D=3D) No Layout section.  Using the first Screen section.
[133915.573] (=3D=3D) No screen section available. Using defaults.
[133915.573] (**) |-->Screen "Default Screen Section" (0)
[133915.573] (**) |   |-->Monitor "<default monitor>"
[133915.573] (=3D=3D) No monitor specified for screen "Default Screen Secti=
on".
	Using a default monitor configuration.
[133915.573] (=3D=3D) Automatically adding devices
[133915.573] (=3D=3D) Automatically enabling devices
[133915.573] (WW) The directory "/usr/share/fonts/OTF/" does not exist.
[133915.573] 	Entry deleted from font path.
[133915.573] (=3D=3D) FontPath set to:
	/usr/share/fonts/misc/,
	/usr/share/fonts/TTF/,
	/usr/share/fonts/Type1/,
	/usr/share/fonts/100dpi/,
	/usr/share/fonts/75dpi/
[133915.573] (=3D=3D) ModulePath set to "/usr/lib/xorg/modules"
[133915.573] (II) The server relies on udev to provide the list of input de=
vices.
	If no devices become available, reconfigure udev or disable AutoAddDevices.
[133915.573] (II) Loader magic: 0x7d3360
[133915.573] (II) Module ABI versions:
[133915.573] 	X.Org ANSI C Emulation: 0.4
[133915.573] 	X.Org Video Driver: 8.0
[133915.573] 	X.Org XInput driver : 11.0
[133915.573] 	X.Org Server Extension : 4.0
[133915.574] (--) PCI:*(0:0:2:0) 8086:0046:17aa:215a rev 2, Mem @ 0xf200000=
0/4194304, 0xd0000000/268435456, I/O @ 0x00001800/8
[133915.574] (WW) Open ACPI failed (/var/run/acpid.socket) (No such file or=
 directory)
[133915.574] (II) LoadModule: "extmod"
[133915.574] (II) Loading /usr/lib/xorg/modules/extensions/libextmod.so
[133915.574] (II) Module extmod: vendor=3D"X.Org Foundation"
[133915.574] 	compiled for 1.9.2, module version =3D 1.0.0
[133915.574] 	Module class: X.Org Server Extension
[133915.574] 	ABI class: X.Org Server Extension, version 4.0
[133915.574] (II) Loading extension MIT-SCREEN-SAVER
[133915.574] (II) Loading extension XFree86-VidModeExtension
[133915.574] (II) Loading extension XFree86-DGA
[133915.574] (II) Loading extension DPMS
[133915.574] (II) Loading extension XVideo
[133915.574] (II) Loading extension XVideo-MotionCompensation
[133915.574] (II) Loading extension X-Resource
[133915.574] (II) LoadModule: "dbe"
[133915.574] (II) Loading /usr/lib/xorg/modules/extensions/libdbe.so
[133915.575] (II) Module dbe: vendor=3D"X.Org Foundation"
[133915.575] 	compiled for 1.9.2, module version =3D 1.0.0
[133915.575] 	Module class: X.Org Server Extension
[133915.575] 	ABI class: X.Org Server Extension, version 4.0
[133915.575] (II) Loading extension DOUBLE-BUFFER
[133915.575] (II) LoadModule: "glx"
[133915.575] (II) Loading /usr/lib/xorg/modules/extensions/libglx.so
[133915.585] (II) Module glx: vendor=3D"X.Org Foundation"
[133915.585] 	compiled for 1.9.2, module version =3D 1.0.0
[133915.585] 	ABI class: X.Org Server Extension, version 4.0
[133915.585] (=3D=3D) AIGLX enabled
[133915.585] (II) Loading extension GLX
[133915.585] (II) LoadModule: "record"
[133915.585] (II) Loading /usr/lib/xorg/modules/extensions/librecord.so
[133915.585] (II) Module record: vendor=3D"X.Org Foundation"
[133915.585] 	compiled for 1.9.2, module version =3D 1.13.0
[133915.585] 	Module class: X.Org Server Extension
[133915.585] 	ABI class: X.Org Server Extension, version 4.0
[133915.585] (II) Loading extension RECORD
[133915.585] (II) LoadModule: "dri"
[133915.585] (II) Loading /usr/lib/xorg/modules/extensions/libdri.so
[133915.586] (II) Module dri: vendor=3D"X.Org Foundation"
[133915.586] 	compiled for 1.9.2, module version =3D 1.0.0
[133915.586] 	ABI class: X.Org Server Extension, version 4.0
[133915.586] (II) Loading extension XFree86-DRI
[133915.586] (II) LoadModule: "dri2"
[133915.586] (II) Loading /usr/lib/xorg/modules/extensions/libdri2.so
[133915.586] (II) Module dri2: vendor=3D"X.Org Foundation"
[133915.586] 	compiled for 1.9.2, module version =3D 1.2.0
[133915.586] 	ABI class: X.Org Server Extension, version 4.0
[133915.586] (II) Loading extension DRI2
[133915.586] (=3D=3D) Matched intel as autoconfigured driver 0
[133915.586] (=3D=3D) Matched vesa as autoconfigured driver 1
[133915.586] (=3D=3D) Matched fbdev as autoconfigured driver 2
[133915.586] (=3D=3D) Assigned the driver to the xf86ConfigLayout
[133915.586] (II) LoadModule: "intel"
[133915.586] (II) Loading /usr/lib/xorg/modules/drivers/intel_drv.so
[133915.586] (II) Module intel: vendor=3D"X.Org Foundation"
[133915.586] 	compiled for 1.9.0.901, module version =3D 2.13.0
[133915.586] 	Module class: X.Org Video Driver
[133915.586] 	ABI class: X.Org Video Driver, version 8.0
[133915.586] (II) LoadModule: "vesa"
[133915.586] (II) Loading /usr/lib/xorg/modules/drivers/vesa_drv.so
[133915.586] (II) Module vesa: vendor=3D"X.Org Foundation"
[133915.586] 	compiled for 1.9.0, module version =3D 2.3.0
[133915.586] 	Module class: X.Org Video Driver
[133915.586] 	ABI class: X.Org Video Driver, version 8.0
[133915.586] (II) LoadModule: "fbdev"
[133915.587] (WW) Warning, couldn't open module fbdev
[133915.587] (II) UnloadModule: "fbdev"
[133915.587] (EE) Failed to load module "fbdev" (module does not exist, 0)
[133915.588] (II) intel: Driver for Intel Integrated Graphics Chipsets: i81=
0,
	i810-dc100, i810e, i815, i830M, 845G, 854, 852GM/855GM, 865G, 915G,
	E7221 (i915), 915GM, 945G, 945GM, 945GME, Pineview GM, Pineview G,
	965G, G35, 965Q, 946GZ, 965GM, 965GME/GLE, G33, Q35, Q33, GM45,
	4 Series, G45/G43, Q45/Q43, G41, B43, B43, Clarkdale, Arrandale,
	Sandybridge, Sandybridge, Sandybridge, Sandybridge, Sandybridge,
	Sandybridge, Sandybridge
[133915.588] (II) VESA: driver for VESA chipsets: vesa
[133915.588] (--) using VT number 7

[133915.594] (WW) Falling back to old probe method for vesa
[133915.594] drmOpenDevice: node name is /dev/dri/card0
[133915.594] drmOpenDevice: open result is 8, (OK)
[133915.594] drmOpenByBusid: Searching for BusID pci:0000:00:02.0
[133915.594] drmOpenDevice: node name is /dev/dri/card0
[133915.594] drmOpenDevice: open result is 8, (OK)
[133915.594] drmOpenByBusid: drmOpenMinor returns 8
[133915.594] drmOpenByBusid: drmGetBusid reports pci:0000:00:02.0
[133915.594] (II) intel(0): Creating default Display subsection in Screen s=
ection
	"Default Screen Section" for depth/fbbpp 24/32
[133915.594] (=3D=3D) intel(0): Depth 24, (--) framebuffer bpp 32
[133915.594] (=3D=3D) intel(0): RGB weight 888
[133915.594] (=3D=3D) intel(0): Default visual is TrueColor
[133915.594] (II) intel(0): Integrated Graphics Chipset: Intel(R) Arrandale
[133915.594] (--) intel(0): Chipset: "Arrandale"
[133915.594] (**) intel(0): Tiling enabled
[133915.594] (**) intel(0): SwapBuffers wait enabled
[133915.594] (=3D=3D) intel(0): video overlay key set to 0x101fe
[133915.594] (II) intel(0): Output LVDS1 has no monitor section
[133915.595] (II) intel(0): found backlight control interface /sys/class/ba=
cklight/acpi_video0
[133915.595] (II) intel(0): Output VGA1 has no monitor section
[133915.838] (II) intel(0): Output HDMI1 has no monitor section
[133915.839] (II) intel(0): Output DP1 has no monitor section
[133915.839] (II) intel(0): EDID for output LVDS1
[133915.839] (II) intel(0): Manufacturer: LEN  Model: 4011  Serial#: 0
[133915.839] (II) intel(0): Year: 2009  Week: 1
[133915.839] (II) intel(0): EDID Version: 1.3
[133915.839] (II) intel(0): Digital Display Input
[133915.839] (II) intel(0): Max Image Size [cm]: horiz.: 26  vert.: 16
[133915.839] (II) intel(0): Gamma: 2.20
[133915.839] (II) intel(0): DPMS capabilities: StandBy Suspend Off
[133915.839] (II) intel(0): Supported color encodings: RGB 4:4:4 YCrCb 4:4:=
4=20
[133915.839] (II) intel(0): First detailed timing is preferred mode
[133915.839] (II) intel(0): redX: 0.560 redY: 0.350   greenX: 0.345 greenY:=
 0.560
[133915.839] (II) intel(0): blueX: 0.150 blueY: 0.105   whiteX: 0.313 white=
Y: 0.329
[133915.839] (II) intel(0): Manufacturer's mask: 0
[133915.839] (II) intel(0): Supported detailed timing:
[133915.839] (II) intel(0): clock: 69.3 MHz   Image Size:  261 x 163 mm
[133915.839] (II) intel(0): h_active: 1280  h_sync: 1328  h_sync_end 1360 h=
_blank_end 1403 h_border: 0
[133915.839] (II) intel(0): v_active: 800  v_sync: 803  v_sync_end 809 v_bl=
anking: 821 v_border: 0
[133915.839] (II) intel(0): Supported detailed timing:
[133915.839] (II) intel(0): clock: 57.6 MHz   Image Size:  261 x 163 mm
[133915.839] (II) intel(0): h_active: 1280  h_sync: 1328  h_sync_end 1360 h=
_blank_end 1403 h_border: 0
[133915.839] (II) intel(0): v_active: 800  v_sync: 803  v_sync_end 809 v_bl=
anking: 821 v_border: 0
[133915.839] (II) intel(0): Unknown vendor-specific block f
[133915.839] (II) intel(0):  B121EW09 V3
[133915.839] (II) intel(0): EDID (in hex):
[133915.839] (II) intel(0): 	00ffffffffffff0030ae114000000000
[133915.839] (II) intel(0): 	01130103801a1078ea65858f59588f26
[133915.839] (II) intel(0): 	1b505400000001010101010101010101
[133915.839] (II) intel(0): 	010101010101121b007b502015303020
[133915.839] (II) intel(0): 	360005a3100000187f16007b50201530
[133915.839] (II) intel(0): 	3020360005a3100000180000000f0081
[133915.839] (II) intel(0): 	0a3c810a3216090006af5633000000fe
[133915.839] (II) intel(0): 	004231323145573039205633200a009b
[133915.839] (II) intel(0): EDID vendor "LEN", prod id 16401
[133915.839] (II) intel(0): Printing DDC gathered Modelines:
[133915.839] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[133915.839] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[133915.839] (II) intel(0): Not using default mode "320x240" (doublescan mo=
de not supported)
[133915.839] (II) intel(0): Not using default mode "400x300" (doublescan mo=
de not supported)
[133915.839] (II) intel(0): Not using default mode "400x300" (doublescan mo=
de not supported)
[133915.839] (II) intel(0): Not using default mode "512x384" (doublescan mo=
de not supported)
[133915.839] (II) intel(0): Not using default mode "640x480" (doublescan mo=
de not supported)
[133915.839] (II) intel(0): Not using default mode "640x512" (doublescan mo=
de not supported)
[133915.839] (II) intel(0): Not using default mode "800x600" (doublescan mo=
de not supported)
[133915.839] (II) intel(0): Not using default mode "896x672" (doublescan mo=
de not supported)
[133915.839] (II) intel(0): Not using default mode "928x696" (doublescan mo=
de not supported)
[133915.839] (II) intel(0): Not using default mode "960x720" (doublescan mo=
de not supported)
[133915.839] (II) intel(0): Not using default mode "700x525" (doublescan mo=
de not supported)
[133915.839] (II) intel(0): Not using default mode "1024x768" (doublescan m=
ode not supported)
[133915.839] (II) intel(0): Printing probed modes for output LVDS1
[133915.839] (II) intel(0): Modeline "1280x800"x60.2   69.30  1280 1328 136=
0 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[133915.839] (II) intel(0): Modeline "1280x800"x50.0   57.59  1280 1328 136=
0 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[133915.839] (II) intel(0): Modeline "1024x768"x60.0   65.00  1024 1048 118=
4 1344  768 771 777 806 -hsync -vsync (48.4 kHz)
[133915.840] (II) intel(0): Modeline "800x600"x60.3   40.00  800 840 968 10=
56  600 601 605 628 +hsync +vsync (37.9 kHz)
[133915.840] (II) intel(0): Modeline "800x600"x56.2   36.00  800 824 896 10=
24  600 601 603 625 +hsync +vsync (35.2 kHz)
[133915.840] (II) intel(0): Modeline "640x480"x59.9   25.18  640 656 752 80=
0  480 490 492 525 -hsync -vsync (31.5 kHz)
[133915.840] (II) intel(0): EDID for output VGA1
[133916.082] (II) intel(0): EDID for output HDMI1
[133916.082] (II) intel(0): Manufacturer: SAM  Model: 68b  Serial#: 1110590=
276
[133916.082] (II) intel(0): Year: 2010  Week: 42
[133916.082] (II) intel(0): EDID Version: 1.3
[133916.082] (II) intel(0): Digital Display Input
[133916.082] (II) intel(0): Max Image Size [cm]: horiz.: 53  vert.: 30
[133916.082] (II) intel(0): Gamma: 2.20
[133916.082] (II) intel(0): DPMS capabilities: Off
[133916.082] (II) intel(0): Supported color encodings: RGB 4:4:4 YCrCb 4:4:=
4=20
[133916.082] (II) intel(0): First detailed timing is preferred mode
[133916.082] (II) intel(0): redX: 0.638 redY: 0.348   greenX: 0.334 greenY:=
 0.608
[133916.082] (II) intel(0): blueX: 0.150 blueY: 0.057   whiteX: 0.312 white=
Y: 0.329
[133916.082] (II) intel(0): Supported established timings:
[133916.082] (II) intel(0): 720x400@70Hz
[133916.082] (II) intel(0): 640x480@60Hz
[133916.082] (II) intel(0): 640x480@67Hz
[133916.082] (II) intel(0): 640x480@72Hz
[133916.082] (II) intel(0): 640x480@75Hz
[133916.082] (II) intel(0): 800x600@56Hz
[133916.082] (II) intel(0): 800x600@60Hz
[133916.082] (II) intel(0): 800x600@72Hz
[133916.082] (II) intel(0): 800x600@75Hz
[133916.082] (II) intel(0): 832x624@75Hz
[133916.082] (II) intel(0): 1024x768@60Hz
[133916.082] (II) intel(0): 1024x768@70Hz
[133916.082] (II) intel(0): 1024x768@75Hz
[133916.082] (II) intel(0): 1280x1024@75Hz
[133916.082] (II) intel(0): 1152x864@75Hz
[133916.082] (II) intel(0): Manufacturer's mask: 0
[133916.082] (II) intel(0): Supported standard timings:
[133916.082] (II) intel(0): #0: hsize: 1280  vsize 800  refresh: 60  vid: 1=
29
[133916.082] (II) intel(0): #1: hsize: 1280  vsize 960  refresh: 60  vid: 1=
6513
[133916.082] (II) intel(0): #2: hsize: 1280  vsize 1024  refresh: 60  vid: =
32897
[133916.082] (II) intel(0): #3: hsize: 1440  vsize 900  refresh: 60  vid: 1=
49
[133916.082] (II) intel(0): #4: hsize: 1600  vsize 1200  refresh: 60  vid: =
16553
[133916.082] (II) intel(0): #5: hsize: 1680  vsize 1050  refresh: 60  vid: =
179
[133916.082] (II) intel(0): #6: hsize: 1152  vsize 864  refresh: 75  vid: 2=
0337
[133916.082] (II) intel(0): #7: hsize: 1440  vsize 900  refresh: 75  vid: 3=
989
[133916.082] (II) intel(0): Supported detailed timing:
[133916.082] (II) intel(0): clock: 148.5 MHz   Image Size:  531 x 299 mm
[133916.082] (II) intel(0): h_active: 1920  h_sync: 2008  h_sync_end 2052 h=
_blank_end 2200 h_border: 0
[133916.082] (II) intel(0): v_active: 1080  v_sync: 1084  v_sync_end 1089 v=
_blanking: 1125 v_border: 0
[133916.082] (II) intel(0): Ranges: V min: 56 V max: 75 Hz, H min: 30 H max=
: 81 kHz, PixClock max 175 MHz
[133916.082] (II) intel(0): Monitor name: SMBX2440
[133916.082] (II) intel(0): Serial No: H9XZA03675
[133916.082] (II) intel(0): Supported detailed timing:
[133916.082] (II) intel(0): clock: 148.5 MHz   Image Size:  521 x 293 mm
[133916.082] (II) intel(0): h_active: 1920  h_sync: 2448  h_sync_end 2492 h=
_blank_end 2640 h_border: 0
[133916.082] (II) intel(0): v_active: 1080  v_sync: 1084  v_sync_end 1089 v=
_blanking: 1125 v_border: 0
[133916.082] (II) intel(0): Supported detailed timing:
[133916.082] (II) intel(0): clock: 74.2 MHz   Image Size:  521 x 293 mm
[133916.082] (II) intel(0): h_active: 1280  h_sync: 1390  h_sync_end 1430 h=
_blank_end 1650 h_border: 0
[133916.082] (II) intel(0): v_active: 720  v_sync: 725  v_sync_end 730 v_bl=
anking: 750 v_border: 0
[133916.082] (II) intel(0): Supported detailed timing:
[133916.082] (II) intel(0): clock: 74.2 MHz   Image Size:  521 x 293 mm
[133916.082] (II) intel(0): h_active: 1280  h_sync: 1720  h_sync_end 1760 h=
_blank_end 1980 h_border: 0
[133916.082] (II) intel(0): v_active: 720  v_sync: 725  v_sync_end 730 v_bl=
anking: 750 v_border: 0
[133916.082] (II) intel(0): Supported detailed timing:
[133916.082] (II) intel(0): clock: 27.0 MHz   Image Size:  521 x 293 mm
[133916.082] (II) intel(0): h_active: 720  h_sync: 732  h_sync_end 796 h_bl=
ank_end 864 h_border: 0
[133916.082] (II) intel(0): v_active: 576  v_sync: 581  v_sync_end 586 v_bl=
anking: 625 v_border: 0
[133916.082] (II) intel(0): Supported detailed timing:
[133916.082] (II) intel(0): clock: 27.0 MHz   Image Size:  521 x 293 mm
[133916.082] (II) intel(0): h_active: 720  h_sync: 736  h_sync_end 798 h_bl=
ank_end 858 h_border: 0
[133916.082] (II) intel(0): v_active: 480  v_sync: 489  v_sync_end 495 v_bl=
anking: 525 v_border: 0
[133916.082] (II) intel(0): Number of EDID sections to follow: 1
[133916.082] (II) intel(0): EDID (in hex):
[133916.082] (II) intel(0): 	00ffffffffffff004c2d8b0644433242
[133916.082] (II) intel(0): 	2a14010380351e782a4ba1a359559b26
[133916.082] (II) intel(0): 	0e5054bfef808100814081809500a940
[133916.082] (II) intel(0): 	b300714f950f023a801871382d40582c
[133916.082] (II) intel(0): 	4500132b2100001e000000fd00384b1e
[133916.082] (II) intel(0): 	5111000a202020202020000000fc0053
[133916.082] (II) intel(0): 	4d4258323434300a20202020000000ff
[133916.083] (II) intel(0): 	004839585a4130333637350a2020014d
[133916.083] (II) intel(0): 	02010400023a80d072382d40102c4580
[133916.083] (II) intel(0): 	09252100001e011d007251d01e206e28
[133916.083] (II) intel(0): 	550009252100001e011d00bc52d01e20
[133916.083] (II) intel(0): 	b828554009252100001e8c0ad0902040
[133916.083] (II) intel(0): 	31200c4055000925210000188c0ad08a
[133916.083] (II) intel(0): 	20e02d10103e96000925210000180000
[133916.083] (II) intel(0): 	00000000000000000000000000000000
[133916.083] (II) intel(0): 	0000000000000000000000000000005e
[133916.083] (II) intel(0): Printing probed modes for output HDMI1
[133916.083] (II) intel(0): Modeline "1920x1080"x60.0  148.50  1920 2008 20=
52 2200  1080 1084 1089 1125 +hsync +vsync (67.5 kHz)
[133916.083] (II) intel(0): Modeline "1920x1080"x50.0  148.50  1920 2448 24=
92 2640  1080 1084 1089 1125 +hsync +vsync (56.2 kHz)
[133916.083] (II) intel(0): Modeline "1600x1200"x60.0  162.00  1600 1664 18=
56 2160  1200 1201 1204 1250 +hsync +vsync (75.0 kHz)
[133916.083] (II) intel(0): Modeline "1680x1050"x60.0  146.25  1680 1784 19=
60 2240  1050 1053 1059 1089 -hsync +vsync (65.3 kHz)
[133916.083] (II) intel(0): Modeline "1280x1024"x75.0  135.00  1280 1296 14=
40 1688  1024 1025 1028 1066 +hsync +vsync (80.0 kHz)
[133916.083] (II) intel(0): Modeline "1280x1024"x60.0  108.00  1280 1328 14=
40 1688  1024 1025 1028 1066 +hsync +vsync (64.0 kHz)
[133916.083] (II) intel(0): Modeline "1440x900"x75.0  136.75  1440 1536 168=
8 1936  900 903 909 942 -hsync +vsync (70.6 kHz)
[133916.083] (II) intel(0): Modeline "1440x900"x59.9  106.50  1440 1520 167=
2 1904  900 903 909 934 -hsync +vsync (55.9 kHz)
[133916.083] (II) intel(0): Modeline "1280x960"x60.0  108.00  1280 1376 148=
8 1800  960 961 964 1000 +hsync +vsync (60.0 kHz)
[133916.083] (II) intel(0): Modeline "1280x800"x59.8   83.50  1280 1352 148=
0 1680  800 803 809 831 +hsync -vsync (49.7 kHz)
[133916.083] (II) intel(0): Modeline "1152x864"x75.0  108.00  1152 1216 134=
4 1600  864 865 868 900 +hsync +vsync (67.5 kHz)
[133916.083] (II) intel(0): Modeline "1280x720"x50.0   74.25  1280 1720 176=
0 1980  720 725 730 750 +hsync +vsync (37.5 kHz)
[133916.083] (II) intel(0): Modeline "1280x720"x60.0   74.25  1280 1390 143=
0 1650  720 725 730 750 +hsync +vsync (45.0 kHz)
[133916.083] (II) intel(0): Modeline "1024x768"x75.1   78.80  1024 1040 113=
6 1312  768 769 772 800 +hsync +vsync (60.1 kHz)
[133916.083] (II) intel(0): Modeline "1024x768"x70.1   75.00  1024 1048 118=
4 1328  768 771 777 806 -hsync -vsync (56.5 kHz)
[133916.083] (II) intel(0): Modeline "1024x768"x60.0   65.00  1024 1048 118=
4 1344  768 771 777 806 -hsync -vsync (48.4 kHz)
[133916.083] (II) intel(0): Modeline "832x624"x74.6   57.28  832 864 928 11=
52  624 625 628 667 -hsync -vsync (49.7 kHz)
[133916.083] (II) intel(0): Modeline "800x600"x72.2   50.00  800 856 976 10=
40  600 637 643 666 +hsync +vsync (48.1 kHz)
[133916.083] (II) intel(0): Modeline "800x600"x75.0   49.50  800 816 896 10=
56  600 601 604 625 +hsync +vsync (46.9 kHz)
[133916.083] (II) intel(0): Modeline "800x600"x60.3   40.00  800 840 968 10=
56  600 601 605 628 +hsync +vsync (37.9 kHz)
[133916.083] (II) intel(0): Modeline "800x600"x56.2   36.00  800 824 896 10=
24  600 601 603 625 +hsync +vsync (35.2 kHz)
[133916.083] (II) intel(0): Modeline "720x576"x50.0   27.00  720 732 796 86=
4  576 581 586 625 -hsync -vsync (31.2 kHz)
[133916.083] (II) intel(0): Modeline "720x480"x59.9   27.00  720 736 798 85=
8  480 489 495 525 -hsync -vsync (31.5 kHz)
[133916.083] (II) intel(0): Modeline "640x480"x72.8   31.50  640 664 704 83=
2  480 489 491 520 -hsync -vsync (37.9 kHz)
[133916.083] (II) intel(0): Modeline "640x480"x75.0   31.50  640 656 720 84=
0  480 481 484 500 -hsync -vsync (37.5 kHz)
[133916.083] (II) intel(0): Modeline "640x480"x66.7   30.24  640 704 768 86=
4  480 483 486 525 -hsync -vsync (35.0 kHz)
[133916.083] (II) intel(0): Modeline "640x480"x60.0   25.20  640 656 752 80=
0  480 490 492 525 -hsync -vsync (31.5 kHz)
[133916.083] (II) intel(0): Modeline "720x400"x70.1   28.32  720 738 846 90=
0  400 412 414 449 -hsync +vsync (31.5 kHz)
[133916.084] (II) intel(0): EDID for output DP1
[133916.084] (II) intel(0): Output LVDS1 connected
[133916.084] (II) intel(0): Output VGA1 disconnected
[133916.084] (II) intel(0): Output HDMI1 connected
[133916.084] (II) intel(0): Output DP1 disconnected
[133916.084] (II) intel(0): Using exact sizes for initial modes
[133916.084] (II) intel(0): Output LVDS1 using initial mode 1280x800
[133916.084] (II) intel(0): Output HDMI1 using initial mode 1280x800
[133916.084] (II) intel(0): Using default gamma of (1.0, 1.0, 1.0) unless o=
therwise stated.
[133916.084] (II) intel(0): Kernel page flipping support detected, enabling
[133916.084] (**) intel(0): Display dimensions: (260, 160) mm
[133916.084] (**) intel(0): DPI set to (125, 127)
[133916.084] (II) Loading sub module "fb"
[133916.084] (II) LoadModule: "fb"
[133916.084] (II) Loading /usr/lib/xorg/modules/libfb.so
[133916.084] (II) Module fb: vendor=3D"X.Org Foundation"
[133916.084] 	compiled for 1.9.2, module version =3D 1.0.0
[133916.084] 	ABI class: X.Org ANSI C Emulation, version 0.4
[133916.084] (II) UnloadModule: "vesa"
[133916.084] (II) Unloading /usr/lib/xorg/modules/drivers/vesa_drv.so
[133916.084] (=3D=3D) Depth 24 pixmap format is 32 bpp
[133916.084] (=3D=3D) intel(0): VideoRam: 262144 KB
[133916.085] (II) intel(0): [DRI2] Setup complete
[133916.085] (II) intel(0): [DRI2]   DRI driver: i965
[133916.085] (II) intel(0): Allocated new frame buffer 1280x800 stride 5120=
, tiled
[133916.091] (II) UXA(0): Driver registered support for the following opera=
tions:
[133916.091] (II)         solid
[133916.091] (II)         copy
[133916.091] (II)         composite (RENDER acceleration)
[133916.091] (II)         put_image
[133916.091] (II)         get_image
[133916.091] (=3D=3D) intel(0): Backing store disabled
[133916.091] (=3D=3D) intel(0): Silken mouse enabled
[133916.091] (II) intel(0): Initializing HW Cursor
[133916.278] (II) intel(0): RandR 1.2 enabled, ignore the following RandR d=
isabled message.
[133916.281] (=3D=3D) intel(0): DPMS enabled
[133916.281] (=3D=3D) intel(0): Intel XvMC decoder enabled
[133916.281] (II) intel(0): Set up textured video
[133916.281] (II) intel(0): [XvMC] xvmc_vld driver initialized.
[133916.281] (II) intel(0): direct rendering: DRI2 Enabled
[133916.282] (--) RandR disabled
[133916.282] (II) Initializing built-in extension Generic Event Extension
[133916.282] (II) Initializing built-in extension SHAPE
[133916.282] (II) Initializing built-in extension MIT-SHM
[133916.282] (II) Initializing built-in extension XInputExtension
[133916.282] (II) Initializing built-in extension XTEST
[133916.282] (II) Initializing built-in extension BIG-REQUESTS
[133916.282] (II) Initializing built-in extension SYNC
[133916.282] (II) Initializing built-in extension XKEYBOARD
[133916.282] (II) Initializing built-in extension XC-MISC
[133916.282] (II) Initializing built-in extension SECURITY
[133916.282] (II) Initializing built-in extension XINERAMA
[133916.282] (II) Initializing built-in extension XFIXES
[133916.282] (II) Initializing built-in extension RENDER
[133916.282] (II) Initializing built-in extension RANDR
[133916.282] (II) Initializing built-in extension COMPOSITE
[133916.282] (II) Initializing built-in extension DAMAGE
[133916.295] (II) AIGLX: enabled GLX_MESA_copy_sub_buffer
[133916.295] (II) AIGLX: enabled GLX_INTEL_swap_event
[133916.295] (II) AIGLX: enabled GLX_SGI_swap_control and GLX_MESA_swap_con=
trol
[133916.295] (II) AIGLX: enabled GLX_SGI_make_current_read
[133916.295] (II) AIGLX: GLX_EXT_texture_from_pixmap backed by buffer objec=
ts
[133916.295] (II) AIGLX: Loaded and initialized /usr/lib/xorg/modules/dri/i=
965_dri.so
[133916.295] (II) GLX: Initialized DRI2 GL provider for screen 0
[133916.295] (II) intel(0): Setting screen physical size to 338 x 211
[133916.649] (II) config/udev: Adding input device Power Button (/dev/input=
/event2)
[133916.649] (**) Power Button: Applying InputClass "evdev keyboard catchal=
l"
[133916.649] (II) LoadModule: "evdev"
[133916.649] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[133916.649] (II) Module evdev: vendor=3D"X.Org Foundation"
[133916.649] 	compiled for 1.9.0, module version =3D 2.5.0
[133916.649] 	Module class: X.Org XInput Driver
[133916.649] 	ABI class: X.Org XInput driver, version 11.0
[133916.649] (**) Power Button: always reports core events
[133916.649] (**) Power Button: Device: "/dev/input/event2"
[133916.658] (--) Power Button: Found keys
[133916.658] (II) Power Button: Configuring as keyboard
[133916.658] (II) XINPUT: Adding extended input device "Power Button" (type=
: KEYBOARD)
[133916.658] (**) Option "xkb_rules" "evdev"
[133916.658] (**) Option "xkb_model" "evdev"
[133916.658] (**) Option "xkb_layout" "us"
[133916.693] (II) config/udev: Adding input device Video Bus (/dev/input/ev=
ent9)
[133916.693] (**) Video Bus: Applying InputClass "evdev keyboard catchall"
[133916.693] (**) Video Bus: always reports core events
[133916.693] (**) Video Bus: Device: "/dev/input/event9"
[133916.700] (--) Video Bus: Found keys
[133916.700] (II) Video Bus: Configuring as keyboard
[133916.700] (II) XINPUT: Adding extended input device "Video Bus" (type: K=
EYBOARD)
[133916.700] (**) Option "xkb_rules" "evdev"
[133916.700] (**) Option "xkb_model" "evdev"
[133916.700] (**) Option "xkb_layout" "us"
[133916.708] (II) config/udev: Adding input device Lid Switch (/dev/input/e=
vent0)
[133916.708] (II) No input driver/identifier specified (ignoring)
[133916.709] (II) config/udev: Adding input device Sleep Button (/dev/input=
/event1)
[133916.709] (**) Sleep Button: Applying InputClass "evdev keyboard catchal=
l"
[133916.709] (**) Sleep Button: always reports core events
[133916.709] (**) Sleep Button: Device: "/dev/input/event1"
[133916.720] (--) Sleep Button: Found keys
[133916.720] (II) Sleep Button: Configuring as keyboard
[133916.720] (II) XINPUT: Adding extended input device "Sleep Button" (type=
: KEYBOARD)
[133916.720] (**) Option "xkb_rules" "evdev"
[133916.720] (**) Option "xkb_model" "evdev"
[133916.720] (**) Option "xkb_layout" "us"
[133916.723] (II) config/udev: Adding input device HDA Digital PCBeep (/dev=
/input/event8)
[133916.723] (II) No input driver/identifier specified (ignoring)
[133916.733] (II) config/udev: Adding input device AT Translated Set 2 keyb=
oard (/dev/input/event3)
[133916.733] (**) AT Translated Set 2 keyboard: Applying InputClass "evdev =
keyboard catchall"
[133916.733] (**) AT Translated Set 2 keyboard: always reports core events
[133916.733] (**) AT Translated Set 2 keyboard: Device: "/dev/input/event3"
[133916.740] (--) AT Translated Set 2 keyboard: Found keys
[133916.740] (II) AT Translated Set 2 keyboard: Configuring as keyboard
[133916.740] (II) XINPUT: Adding extended input device "AT Translated Set 2=
 keyboard" (type: KEYBOARD)
[133916.740] (**) Option "xkb_rules" "evdev"
[133916.740] (**) Option "xkb_model" "evdev"
[133916.740] (**) Option "xkb_layout" "us"
[133916.741] (II) config/udev: Adding input device SynPS/2 Synaptics TouchP=
ad (/dev/input/event4)
[133916.741] (**) SynPS/2 Synaptics TouchPad: Applying InputClass "evdev to=
uchpad catchall"
[133916.741] (**) SynPS/2 Synaptics TouchPad: Applying InputClass "touchpad=
 catchall"
[133916.741] (II) LoadModule: "synaptics"
[133916.741] (II) Loading /usr/lib/xorg/modules/input/synaptics_drv.so
[133916.741] (II) Module synaptics: vendor=3D"X.Org Foundation"
[133916.741] 	compiled for 1.9.2, module version =3D 1.3.0
[133916.741] 	Module class: X.Org XInput Driver
[133916.741] 	ABI class: X.Org XInput driver, version 11.0
[133916.741] (II) Synaptics touchpad driver version 1.3.0
[133916.741] (**) Option "Device" "/dev/input/event4"
[133916.780] (--) SynPS/2 Synaptics TouchPad: x-axis range 1472 - 5888
[133916.780] (--) SynPS/2 Synaptics TouchPad: y-axis range 1408 - 4810
[133916.780] (--) SynPS/2 Synaptics TouchPad: pressure range 0 - 255
[133916.780] (--) SynPS/2 Synaptics TouchPad: finger width range 0 - 15
[133916.780] (--) SynPS/2 Synaptics TouchPad: buttons: left right double tr=
iple
[133916.780] (**) Option "TapButton1" "1"
[133916.780] (**) Option "TapButton2" "2"
[133916.780] (**) Option "TapButton3" "3"
[133916.812] (--) SynPS/2 Synaptics TouchPad: touchpad found
[133916.812] (**) SynPS/2 Synaptics TouchPad: always reports core events
[133916.828] (II) XINPUT: Adding extended input device "SynPS/2 Synaptics T=
ouchPad" (type: TOUCHPAD)
[133916.828] (**) SynPS/2 Synaptics TouchPad: (accel) MinSpeed is now const=
ant deceleration 2.5
[133916.828] (**) SynPS/2 Synaptics TouchPad: MaxSpeed is now 1.75
[133916.828] (**) SynPS/2 Synaptics TouchPad: AccelFactor is now 0.036
[133916.828] (**) SynPS/2 Synaptics TouchPad: (accel) keeping acceleration =
scheme 1
[133916.828] (**) SynPS/2 Synaptics TouchPad: (accel) acceleration profile 1
[133916.828] (**) SynPS/2 Synaptics TouchPad: (accel) acceleration factor: =
2.000
[133916.828] (**) SynPS/2 Synaptics TouchPad: (accel) acceleration threshol=
d: 4
[133916.852] (--) SynPS/2 Synaptics TouchPad: touchpad found
[133916.852] (II) config/udev: Adding input device SynPS/2 Synaptics TouchP=
ad (/dev/input/mouse0)
[133916.852] (II) No input driver/identifier specified (ignoring)
[133916.853] (II) config/udev: Adding input device TPPS/2 IBM TrackPoint (/=
dev/input/event5)
[133916.853] (**) TPPS/2 IBM TrackPoint: Applying InputClass "evdev pointer=
 catchall"
[133916.853] (**) TPPS/2 IBM TrackPoint: always reports core events
[133916.853] (**) TPPS/2 IBM TrackPoint: Device: "/dev/input/event5"
[133916.860] (--) TPPS/2 IBM TrackPoint: Found 3 mouse buttons
[133916.860] (--) TPPS/2 IBM TrackPoint: Found relative axes
[133916.860] (--) TPPS/2 IBM TrackPoint: Found x and y relative axes
[133916.860] (II) TPPS/2 IBM TrackPoint: Configuring as mouse
[133916.860] (**) TPPS/2 IBM TrackPoint: YAxisMapping: buttons 4 and 5
[133916.860] (**) TPPS/2 IBM TrackPoint: EmulateWheelButton: 4, EmulateWhee=
lInertia: 10, EmulateWheelTimeout: 200
[133916.860] (II) XINPUT: Adding extended input device "TPPS/2 IBM TrackPoi=
nt" (type: MOUSE)
[133916.860] (**) TPPS/2 IBM TrackPoint: (accel) keeping acceleration schem=
e 1
[133916.860] (**) TPPS/2 IBM TrackPoint: (accel) acceleration profile 0
[133916.860] (**) TPPS/2 IBM TrackPoint: (accel) acceleration factor: 2.000
[133916.860] (**) TPPS/2 IBM TrackPoint: (accel) acceleration threshold: 4
[133916.860] (II) TPPS/2 IBM TrackPoint: initialized for relative axes.
[133916.860] (II) config/udev: Adding input device TPPS/2 IBM TrackPoint (/=
dev/input/mouse1)
[133916.860] (II) No input driver/identifier specified (ignoring)
[133916.861] (II) config/udev: Adding input device PC Speaker (/dev/input/e=
vent6)
[133916.861] (II) No input driver/identifier specified (ignoring)
[133916.862] (II) config/udev: Adding input device ThinkPad Extra Buttons (=
/dev/input/event7)
[133916.862] (**) ThinkPad Extra Buttons: Applying InputClass "evdev keyboa=
rd catchall"
[133916.862] (**) ThinkPad Extra Buttons: always reports core events
[133916.862] (**) ThinkPad Extra Buttons: Device: "/dev/input/event7"
[133916.868] (--) ThinkPad Extra Buttons: Found keys
[133916.868] (II) ThinkPad Extra Buttons: Configuring as keyboard
[133916.868] (II) XINPUT: Adding extended input device "ThinkPad Extra Butt=
ons" (type: KEYBOARD)
[133916.868] (**) Option "xkb_rules" "evdev"
[133916.868] (**) Option "xkb_model" "evdev"
[133916.868] (**) Option "xkb_layout" "us"
[133926.004] (II) intel(0): EDID vendor "LEN", prod id 16401
[133926.004] (II) intel(0): Printing DDC gathered Modelines:
[133926.004] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[133926.004] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[133926.250] (II) intel(0): Allocated new frame buffer 1920x1880 stride 768=
0, tiled
[137233.551] (II) AIGLX: Suspending AIGLX clients for VT switch
[137241.438] (II) AIGLX: Resuming AIGLX clients after VT switch
[137241.541] (II) intel(0): EDID vendor "LEN", prod id 16401
[137241.541] (II) intel(0): Printing DDC gathered Modelines:
[137241.541] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[137241.541] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[137241.595] (--) SynPS/2 Synaptics TouchPad: touchpad found
[137241.595] (EE) Unable to open evdev device "/dev/input/event5".
[137241.595] [dix] couldn't enable device 11
[137241.605] (II) config/udev: removing device SynPS/2 Synaptics TouchPad
[137241.628] (II) UnloadModule: "synaptics"
[137241.629] (II) config/udev: removing device TPPS/2 IBM TrackPoint
[137241.629] (II) TPPS/2 IBM TrackPoint: Close
[137241.629] (II) UnloadModule: "evdev"
[137241.631] (II) config/udev: Adding input device SynPS/2 Synaptics TouchP=
ad (/dev/input/mouse0)
[137241.631] (II) No input driver/identifier specified (ignoring)
[137241.631] (II) config/udev: Adding input device SynPS/2 Synaptics TouchP=
ad (/dev/input/event4)
[137241.631] (**) SynPS/2 Synaptics TouchPad: Applying InputClass "evdev to=
uchpad catchall"
[137241.631] (**) SynPS/2 Synaptics TouchPad: Applying InputClass "touchpad=
 catchall"
[137241.631] (II) Synaptics touchpad driver version 1.3.0
[137241.631] (**) Option "Device" "/dev/input/event4"
[137241.674] (--) SynPS/2 Synaptics TouchPad: x-axis range 1472 - 5888
[137241.674] (--) SynPS/2 Synaptics TouchPad: y-axis range 1408 - 4810
[137241.674] (--) SynPS/2 Synaptics TouchPad: pressure range 0 - 255
[137241.674] (--) SynPS/2 Synaptics TouchPad: finger width range 0 - 15
[137241.674] (--) SynPS/2 Synaptics TouchPad: buttons: left right double tr=
iple
[137241.674] (**) Option "TapButton1" "1"
[137241.674] (**) Option "TapButton2" "2"
[137241.674] (**) Option "TapButton3" "3"
[137241.707] (--) SynPS/2 Synaptics TouchPad: touchpad found
[137241.707] (**) SynPS/2 Synaptics TouchPad: always reports core events
[137241.723] (II) XINPUT: Adding extended input device "SynPS/2 Synaptics T=
ouchPad" (type: TOUCHPAD)
[137241.723] (**) SynPS/2 Synaptics TouchPad: (accel) MinSpeed is now const=
ant deceleration 2.5
[137241.723] (**) SynPS/2 Synaptics TouchPad: MaxSpeed is now 1.75
[137241.723] (**) SynPS/2 Synaptics TouchPad: AccelFactor is now 0.036
[137241.723] (**) SynPS/2 Synaptics TouchPad: (accel) keeping acceleration =
scheme 1
[137241.723] (**) SynPS/2 Synaptics TouchPad: (accel) acceleration profile 1
[137241.723] (**) SynPS/2 Synaptics TouchPad: (accel) acceleration factor: =
2.000
[137241.723] (**) SynPS/2 Synaptics TouchPad: (accel) acceleration threshol=
d: 4
[137241.745] (--) SynPS/2 Synaptics TouchPad: touchpad found
[137246.464] (II) config/udev: Adding input device TPPS/2 IBM TrackPoint (/=
dev/input/mouse1)
[137246.464] (II) No input driver/identifier specified (ignoring)
[137246.465] (II) config/udev: Adding input device TPPS/2 IBM TrackPoint (/=
dev/input/event5)
[137246.465] (**) TPPS/2 IBM TrackPoint: Applying InputClass "evdev pointer=
 catchall"
[137246.465] (**) TPPS/2 IBM TrackPoint: always reports core events
[137246.465] (**) TPPS/2 IBM TrackPoint: Device: "/dev/input/event5"
[137246.472] (--) TPPS/2 IBM TrackPoint: Found 3 mouse buttons
[137246.472] (--) TPPS/2 IBM TrackPoint: Found relative axes
[137246.472] (--) TPPS/2 IBM TrackPoint: Found x and y relative axes
[137246.472] (II) TPPS/2 IBM TrackPoint: Configuring as mouse
[137246.472] (**) TPPS/2 IBM TrackPoint: YAxisMapping: buttons 4 and 5
[137246.472] (**) TPPS/2 IBM TrackPoint: EmulateWheelButton: 4, EmulateWhee=
lInertia: 10, EmulateWheelTimeout: 200
[137246.472] (II) XINPUT: Adding extended input device "TPPS/2 IBM TrackPoi=
nt" (type: MOUSE)
[137246.472] (**) TPPS/2 IBM TrackPoint: (accel) keeping acceleration schem=
e 1
[137246.472] (**) TPPS/2 IBM TrackPoint: (accel) acceleration profile 0
[137246.472] (**) TPPS/2 IBM TrackPoint: (accel) acceleration factor: 2.000
[137246.472] (**) TPPS/2 IBM TrackPoint: (accel) acceleration threshold: 4
[137246.472] (II) TPPS/2 IBM TrackPoint: initialized for relative axes.
[137411.955] (II) AIGLX: Suspending AIGLX clients for VT switch
[137420.006] (II) AIGLX: Resuming AIGLX clients after VT switch
[137420.111] (II) intel(0): EDID vendor "LEN", prod id 16401
[137420.111] (II) intel(0): Printing DDC gathered Modelines:
[137420.111] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[137420.111] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[137420.191] (--) SynPS/2 Synaptics TouchPad: touchpad found
[137420.191] (EE) Unable to open evdev device "/dev/input/event5".
[137420.191] [dix] couldn't enable device 11
[137420.201] (II) config/udev: removing device TPPS/2 IBM TrackPoint
[137420.201] (II) TPPS/2 IBM TrackPoint: Close
[137420.201] (II) UnloadModule: "evdev"
[137420.201] (II) config/udev: removing device SynPS/2 Synaptics TouchPad
[137420.231] (II) UnloadModule: "synaptics"
[137420.232] (II) config/udev: Adding input device SynPS/2 Synaptics TouchP=
ad (/dev/input/mouse0)
[137420.232] (II) No input driver/identifier specified (ignoring)
[137420.232] (II) config/udev: Adding input device SynPS/2 Synaptics TouchP=
ad (/dev/input/event4)
[137420.232] (**) SynPS/2 Synaptics TouchPad: Applying InputClass "evdev to=
uchpad catchall"
[137420.232] (**) SynPS/2 Synaptics TouchPad: Applying InputClass "touchpad=
 catchall"
[137420.232] (II) Synaptics touchpad driver version 1.3.0
[137420.232] (**) Option "Device" "/dev/input/event4"
[137420.273] (--) SynPS/2 Synaptics TouchPad: x-axis range 1472 - 5888
[137420.273] (--) SynPS/2 Synaptics TouchPad: y-axis range 1408 - 4810
[137420.273] (--) SynPS/2 Synaptics TouchPad: pressure range 0 - 255
[137420.273] (--) SynPS/2 Synaptics TouchPad: finger width range 0 - 15
[137420.273] (--) SynPS/2 Synaptics TouchPad: buttons: left right double tr=
iple
[137420.273] (**) Option "TapButton1" "1"
[137420.273] (**) Option "TapButton2" "2"
[137420.273] (**) Option "TapButton3" "3"
[137420.295] (--) SynPS/2 Synaptics TouchPad: touchpad found
[137420.295] (**) SynPS/2 Synaptics TouchPad: always reports core events
[137420.306] (II) XINPUT: Adding extended input device "SynPS/2 Synaptics T=
ouchPad" (type: TOUCHPAD)
[137420.306] (**) SynPS/2 Synaptics TouchPad: (accel) MinSpeed is now const=
ant deceleration 2.5
[137420.306] (**) SynPS/2 Synaptics TouchPad: MaxSpeed is now 1.75
[137420.306] (**) SynPS/2 Synaptics TouchPad: AccelFactor is now 0.036
[137420.306] (**) SynPS/2 Synaptics TouchPad: (accel) keeping acceleration =
scheme 1
[137420.306] (**) SynPS/2 Synaptics TouchPad: (accel) acceleration profile 1
[137420.306] (**) SynPS/2 Synaptics TouchPad: (accel) acceleration factor: =
2.000
[137420.306] (**) SynPS/2 Synaptics TouchPad: (accel) acceleration threshol=
d: 4
[137420.346] (--) SynPS/2 Synaptics TouchPad: touchpad found
[137424.817] (II) config/udev: Adding input device TPPS/2 IBM TrackPoint (/=
dev/input/mouse1)
[137424.817] (II) No input driver/identifier specified (ignoring)
[137424.817] (II) config/udev: Adding input device TPPS/2 IBM TrackPoint (/=
dev/input/event5)
[137424.818] (**) TPPS/2 IBM TrackPoint: Applying InputClass "evdev pointer=
 catchall"
[137424.818] (**) TPPS/2 IBM TrackPoint: always reports core events
[137424.818] (**) TPPS/2 IBM TrackPoint: Device: "/dev/input/event5"
[137424.824] (--) TPPS/2 IBM TrackPoint: Found 3 mouse buttons
[137424.824] (--) TPPS/2 IBM TrackPoint: Found relative axes
[137424.824] (--) TPPS/2 IBM TrackPoint: Found x and y relative axes
[137424.824] (II) TPPS/2 IBM TrackPoint: Configuring as mouse
[137424.824] (**) TPPS/2 IBM TrackPoint: YAxisMapping: buttons 4 and 5
[137424.824] (**) TPPS/2 IBM TrackPoint: EmulateWheelButton: 4, EmulateWhee=
lInertia: 10, EmulateWheelTimeout: 200
[137424.824] (II) XINPUT: Adding extended input device "TPPS/2 IBM TrackPoi=
nt" (type: MOUSE)
[137424.824] (**) TPPS/2 IBM TrackPoint: (accel) keeping acceleration schem=
e 1
[137424.824] (**) TPPS/2 IBM TrackPoint: (accel) acceleration profile 0
[137424.824] (**) TPPS/2 IBM TrackPoint: (accel) acceleration factor: 2.000
[137424.824] (**) TPPS/2 IBM TrackPoint: (accel) acceleration threshold: 4
[137424.824] (II) TPPS/2 IBM TrackPoint: initialized for relative axes.
[138599.537] (II) AIGLX: Suspending AIGLX clients for VT switch
[138607.705] (II) AIGLX: Resuming AIGLX clients after VT switch
[138607.811] (II) intel(0): EDID vendor "LEN", prod id 16401
[138607.811] (II) intel(0): Printing DDC gathered Modelines:
[138607.811] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[138607.811] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[138607.871] (--) SynPS/2 Synaptics TouchPad: touchpad found
[138607.871] (EE) Unable to open evdev device "/dev/input/event5".
[138607.871] [dix] couldn't enable device 11
[138607.889] (II) config/udev: removing device SynPS/2 Synaptics TouchPad
[138607.922] (II) UnloadModule: "synaptics"
[138607.929] (II) config/udev: removing device TPPS/2 IBM TrackPoint
[138607.929] (II) TPPS/2 IBM TrackPoint: Close
[138607.929] (II) UnloadModule: "evdev"
[138607.931] (II) config/udev: Adding input device SynPS/2 Synaptics TouchP=
ad (/dev/input/event4)
[138607.932] (**) SynPS/2 Synaptics TouchPad: Applying InputClass "evdev to=
uchpad catchall"
[138607.932] (**) SynPS/2 Synaptics TouchPad: Applying InputClass "touchpad=
 catchall"
[138607.932] (II) Synaptics touchpad driver version 1.3.0
[138607.932] (**) Option "Device" "/dev/input/event4"
[138607.972] (--) SynPS/2 Synaptics TouchPad: x-axis range 1472 - 5888
[138607.972] (--) SynPS/2 Synaptics TouchPad: y-axis range 1408 - 4810
[138607.972] (--) SynPS/2 Synaptics TouchPad: pressure range 0 - 255
[138607.972] (--) SynPS/2 Synaptics TouchPad: finger width range 0 - 15
[138607.972] (--) SynPS/2 Synaptics TouchPad: buttons: left right double tr=
iple
[138607.972] (**) Option "TapButton1" "1"
[138607.972] (**) Option "TapButton2" "2"
[138607.972] (**) Option "TapButton3" "3"
[138607.994] (--) SynPS/2 Synaptics TouchPad: touchpad found
[138607.994] (**) SynPS/2 Synaptics TouchPad: always reports core events
[138608.005] (II) XINPUT: Adding extended input device "SynPS/2 Synaptics T=
ouchPad" (type: TOUCHPAD)
[138608.005] (**) SynPS/2 Synaptics TouchPad: (accel) MinSpeed is now const=
ant deceleration 2.5
[138608.005] (**) SynPS/2 Synaptics TouchPad: MaxSpeed is now 1.75
[138608.005] (**) SynPS/2 Synaptics TouchPad: AccelFactor is now 0.036
[138608.005] (**) SynPS/2 Synaptics TouchPad: (accel) keeping acceleration =
scheme 1
[138608.005] (**) SynPS/2 Synaptics TouchPad: (accel) acceleration profile 1
[138608.005] (**) SynPS/2 Synaptics TouchPad: (accel) acceleration factor: =
2.000
[138608.005] (**) SynPS/2 Synaptics TouchPad: (accel) acceleration threshol=
d: 4
[138608.029] (--) SynPS/2 Synaptics TouchPad: touchpad found
[138608.029] (II) config/udev: Adding input device SynPS/2 Synaptics TouchP=
ad (/dev/input/mouse0)
[138608.029] (II) No input driver/identifier specified (ignoring)
[138612.801] (II) config/udev: Adding input device TPPS/2 IBM TrackPoint (/=
dev/input/mouse1)
[138612.801] (II) No input driver/identifier specified (ignoring)
[138612.801] (II) config/udev: Adding input device TPPS/2 IBM TrackPoint (/=
dev/input/event5)
[138612.801] (**) TPPS/2 IBM TrackPoint: Applying InputClass "evdev pointer=
 catchall"
[138612.801] (**) TPPS/2 IBM TrackPoint: always reports core events
[138612.801] (**) TPPS/2 IBM TrackPoint: Device: "/dev/input/event5"
[138612.813] (--) TPPS/2 IBM TrackPoint: Found 3 mouse buttons
[138612.813] (--) TPPS/2 IBM TrackPoint: Found relative axes
[138612.813] (--) TPPS/2 IBM TrackPoint: Found x and y relative axes
[138612.813] (II) TPPS/2 IBM TrackPoint: Configuring as mouse
[138612.813] (**) TPPS/2 IBM TrackPoint: YAxisMapping: buttons 4 and 5
[138612.813] (**) TPPS/2 IBM TrackPoint: EmulateWheelButton: 4, EmulateWhee=
lInertia: 10, EmulateWheelTimeout: 200
[138612.813] (II) XINPUT: Adding extended input device "TPPS/2 IBM TrackPoi=
nt" (type: MOUSE)
[138612.813] (**) TPPS/2 IBM TrackPoint: (accel) keeping acceleration schem=
e 1
[138612.813] (**) TPPS/2 IBM TrackPoint: (accel) acceleration profile 0
[138612.813] (**) TPPS/2 IBM TrackPoint: (accel) acceleration factor: 2.000
[138612.813] (**) TPPS/2 IBM TrackPoint: (accel) acceleration threshold: 4
[138612.813] (II) TPPS/2 IBM TrackPoint: initialized for relative axes.
[142978.196] (II) AIGLX: Suspending AIGLX clients for VT switch
[142986.568] (II) AIGLX: Resuming AIGLX clients after VT switch
[142986.671] (II) intel(0): EDID vendor "LEN", prod id 16401
[142986.671] (II) intel(0): Printing DDC gathered Modelines:
[142986.671] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[142986.671] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[142986.735] (--) SynPS/2 Synaptics TouchPad: touchpad found
[142986.735] (EE) Unable to open evdev device "/dev/input/event5".
[142986.735] [dix] couldn't enable device 11
[142986.737] (II) config/udev: removing device TPPS/2 IBM TrackPoint
[142986.738] (II) TPPS/2 IBM TrackPoint: Close
[142986.738] (II) UnloadModule: "evdev"
[142986.739] (II) config/udev: removing device SynPS/2 Synaptics TouchPad
[142986.761] (II) UnloadModule: "synaptics"
[142986.763] (II) config/udev: Adding input device SynPS/2 Synaptics TouchP=
ad (/dev/input/event4)
[142986.763] (**) SynPS/2 Synaptics TouchPad: Applying InputClass "evdev to=
uchpad catchall"
[142986.763] (**) SynPS/2 Synaptics TouchPad: Applying InputClass "touchpad=
 catchall"
[142986.763] (II) Synaptics touchpad driver version 1.3.0
[142986.763] (**) Option "Device" "/dev/input/event4"
[142986.805] (--) SynPS/2 Synaptics TouchPad: x-axis range 1472 - 5888
[142986.805] (--) SynPS/2 Synaptics TouchPad: y-axis range 1408 - 4810
[142986.805] (--) SynPS/2 Synaptics TouchPad: pressure range 0 - 255
[142986.805] (--) SynPS/2 Synaptics TouchPad: finger width range 0 - 15
[142986.805] (--) SynPS/2 Synaptics TouchPad: buttons: left right double tr=
iple
[142986.805] (**) Option "TapButton1" "1"
[142986.805] (**) Option "TapButton2" "2"
[142986.805] (**) Option "TapButton3" "3"
[142986.842] (--) SynPS/2 Synaptics TouchPad: touchpad found
[142986.842] (**) SynPS/2 Synaptics TouchPad: always reports core events
[142986.851] (II) XINPUT: Adding extended input device "SynPS/2 Synaptics T=
ouchPad" (type: TOUCHPAD)
[142986.851] (**) SynPS/2 Synaptics TouchPad: (accel) MinSpeed is now const=
ant deceleration 2.5
[142986.851] (**) SynPS/2 Synaptics TouchPad: MaxSpeed is now 1.75
[142986.851] (**) SynPS/2 Synaptics TouchPad: AccelFactor is now 0.036
[142986.851] (**) SynPS/2 Synaptics TouchPad: (accel) keeping acceleration =
scheme 1
[142986.851] (**) SynPS/2 Synaptics TouchPad: (accel) acceleration profile 1
[142986.851] (**) SynPS/2 Synaptics TouchPad: (accel) acceleration factor: =
2.000
[142986.851] (**) SynPS/2 Synaptics TouchPad: (accel) acceleration threshol=
d: 4
[142986.869] (--) SynPS/2 Synaptics TouchPad: touchpad found
[142986.870] (II) config/udev: Adding input device SynPS/2 Synaptics TouchP=
ad (/dev/input/mouse0)
[142986.870] (II) No input driver/identifier specified (ignoring)
[142991.502] (II) config/udev: Adding input device TPPS/2 IBM TrackPoint (/=
dev/input/mouse1)
[142991.502] (II) No input driver/identifier specified (ignoring)
[142991.502] (II) config/udev: Adding input device TPPS/2 IBM TrackPoint (/=
dev/input/event5)
[142991.502] (**) TPPS/2 IBM TrackPoint: Applying InputClass "evdev pointer=
 catchall"
[142991.502] (**) TPPS/2 IBM TrackPoint: always reports core events
[142991.502] (**) TPPS/2 IBM TrackPoint: Device: "/dev/input/event5"
[142991.507] (--) TPPS/2 IBM TrackPoint: Found 3 mouse buttons
[142991.507] (--) TPPS/2 IBM TrackPoint: Found relative axes
[142991.507] (--) TPPS/2 IBM TrackPoint: Found x and y relative axes
[142991.507] (II) TPPS/2 IBM TrackPoint: Configuring as mouse
[142991.507] (**) TPPS/2 IBM TrackPoint: YAxisMapping: buttons 4 and 5
[142991.507] (**) TPPS/2 IBM TrackPoint: EmulateWheelButton: 4, EmulateWhee=
lInertia: 10, EmulateWheelTimeout: 200
[142991.507] (II) XINPUT: Adding extended input device "TPPS/2 IBM TrackPoi=
nt" (type: MOUSE)
[142991.507] (**) TPPS/2 IBM TrackPoint: (accel) keeping acceleration schem=
e 1
[142991.507] (**) TPPS/2 IBM TrackPoint: (accel) acceleration profile 0
[142991.507] (**) TPPS/2 IBM TrackPoint: (accel) acceleration factor: 2.000
[142991.507] (**) TPPS/2 IBM TrackPoint: (accel) acceleration threshold: 4
[142991.507] (II) TPPS/2 IBM TrackPoint: initialized for relative axes.
[148076.881] (II) AIGLX: Suspending AIGLX clients for VT switch
[148084.835] (II) AIGLX: Resuming AIGLX clients after VT switch
[148084.942] (II) intel(0): EDID vendor "LEN", prod id 16401
[148084.942] (II) intel(0): Printing DDC gathered Modelines:
[148084.942] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[148084.942] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[148085.000] (--) SynPS/2 Synaptics TouchPad: touchpad found
[148085.000] (EE) Unable to open evdev device "/dev/input/event5".
[148085.000] [dix] couldn't enable device 11
[148085.086] (II) config/udev: removing device TPPS/2 IBM TrackPoint
[148085.086] (II) TPPS/2 IBM TrackPoint: Close
[148085.086] (II) UnloadModule: "evdev"
[148085.147] (II) config/udev: removing device SynPS/2 Synaptics TouchPad
[148085.178] (II) UnloadModule: "synaptics"
[148085.315] (II) config/udev: Adding input device SynPS/2 Synaptics TouchP=
ad (/dev/input/event4)
[148085.315] (**) SynPS/2 Synaptics TouchPad: Applying InputClass "evdev to=
uchpad catchall"
[148085.315] (**) SynPS/2 Synaptics TouchPad: Applying InputClass "touchpad=
 catchall"
[148085.315] (II) Synaptics touchpad driver version 1.3.0
[148085.315] (**) Option "Device" "/dev/input/event4"
[148085.356] (--) SynPS/2 Synaptics TouchPad: x-axis range 1472 - 5888
[148085.356] (--) SynPS/2 Synaptics TouchPad: y-axis range 1408 - 4810
[148085.356] (--) SynPS/2 Synaptics TouchPad: pressure range 0 - 255
[148085.356] (--) SynPS/2 Synaptics TouchPad: finger width range 0 - 15
[148085.356] (--) SynPS/2 Synaptics TouchPad: buttons: left right double tr=
iple
[148085.356] (**) Option "TapButton1" "1"
[148085.356] (**) Option "TapButton2" "2"
[148085.356] (**) Option "TapButton3" "3"
[148085.388] (--) SynPS/2 Synaptics TouchPad: touchpad found
[148085.388] (**) SynPS/2 Synaptics TouchPad: always reports core events
[148085.404] (II) XINPUT: Adding extended input device "SynPS/2 Synaptics T=
ouchPad" (type: TOUCHPAD)
[148085.404] (**) SynPS/2 Synaptics TouchPad: (accel) MinSpeed is now const=
ant deceleration 2.5
[148085.404] (**) SynPS/2 Synaptics TouchPad: MaxSpeed is now 1.75
[148085.404] (**) SynPS/2 Synaptics TouchPad: AccelFactor is now 0.036
[148085.404] (**) SynPS/2 Synaptics TouchPad: (accel) keeping acceleration =
scheme 1
[148085.404] (**) SynPS/2 Synaptics TouchPad: (accel) acceleration profile 1
[148085.404] (**) SynPS/2 Synaptics TouchPad: (accel) acceleration factor: =
2.000
[148085.404] (**) SynPS/2 Synaptics TouchPad: (accel) acceleration threshol=
d: 4
[148085.428] (--) SynPS/2 Synaptics TouchPad: touchpad found
[148085.435] (II) config/udev: Adding input device SynPS/2 Synaptics TouchP=
ad (/dev/input/mouse0)
[148085.435] (II) No input driver/identifier specified (ignoring)
[148089.840] (II) config/udev: Adding input device TPPS/2 IBM TrackPoint (/=
dev/input/mouse1)
[148089.840] (II) No input driver/identifier specified (ignoring)
[148089.842] (II) config/udev: Adding input device TPPS/2 IBM TrackPoint (/=
dev/input/event5)
[148089.842] (**) TPPS/2 IBM TrackPoint: Applying InputClass "evdev pointer=
 catchall"
[148089.842] (**) TPPS/2 IBM TrackPoint: always reports core events
[148089.842] (**) TPPS/2 IBM TrackPoint: Device: "/dev/input/event5"
[148089.853] (--) TPPS/2 IBM TrackPoint: Found 3 mouse buttons
[148089.853] (--) TPPS/2 IBM TrackPoint: Found relative axes
[148089.853] (--) TPPS/2 IBM TrackPoint: Found x and y relative axes
[148089.853] (II) TPPS/2 IBM TrackPoint: Configuring as mouse
[148089.853] (**) TPPS/2 IBM TrackPoint: YAxisMapping: buttons 4 and 5
[148089.853] (**) TPPS/2 IBM TrackPoint: EmulateWheelButton: 4, EmulateWhee=
lInertia: 10, EmulateWheelTimeout: 200
[148089.853] (II) XINPUT: Adding extended input device "TPPS/2 IBM TrackPoi=
nt" (type: MOUSE)
[148089.853] (**) TPPS/2 IBM TrackPoint: (accel) keeping acceleration schem=
e 1
[148089.853] (**) TPPS/2 IBM TrackPoint: (accel) acceleration profile 0
[148089.853] (**) TPPS/2 IBM TrackPoint: (accel) acceleration factor: 2.000
[148089.853] (**) TPPS/2 IBM TrackPoint: (accel) acceleration threshold: 4
[148089.853] (II) TPPS/2 IBM TrackPoint: initialized for relative axes.
[148090.207] (II) AIGLX: Suspending AIGLX clients for VT switch
[148091.127] (II) AIGLX: Resuming AIGLX clients after VT switch
[148091.261] (II) intel(0): EDID vendor "LEN", prod id 16401
[148091.261] (II) intel(0): Printing DDC gathered Modelines:
[148091.261] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[148091.261] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[148091.352] (--) SynPS/2 Synaptics TouchPad: touchpad found
[150130.538] (II) AIGLX: Suspending AIGLX clients for VT switch
[150207.530] (II) AIGLX: Resuming AIGLX clients after VT switch
[150207.669] (II) intel(0): EDID vendor "LEN", prod id 16401
[150207.669] (II) intel(0): Printing DDC gathered Modelines:
[150207.669] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[150207.669] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[150207.741] (--) SynPS/2 Synaptics TouchPad: touchpad found
[150393.753] (II) AIGLX: Suspending AIGLX clients for VT switch
[150414.639] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.639] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.639] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.639] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.639] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.640] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.640] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.640] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.640] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.640] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.640] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.640] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.640] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.640] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.640] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.640] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.640] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.640] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.640] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.640] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.641] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.641] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.641] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.641] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.641] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.641] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.641] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.641] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.641] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.641] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.641] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.641] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.642] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.642] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.642] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.642] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.642] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.642] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.642] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.642] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.642] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.642] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.642] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.642] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.642] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.642] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.642] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.642] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.643] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.643] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.643] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.643] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.643] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.643] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.643] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.643] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.643] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.643] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.643] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.643] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.643] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.643] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.643] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.643] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.643] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.643] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.644] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.644] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.644] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.644] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.644] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.644] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.644] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.644] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.644] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.644] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.644] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.644] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.644] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.644] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.644] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.645] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.645] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.645] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.645] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.645] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.645] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.645] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.645] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.645] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.645] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.645] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.645] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.645] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.645] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.646] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.646] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.646] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.646] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.646] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.646] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.646] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.646] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.646] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.646] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.646] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.646] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.646] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.646] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.647] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.647] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.647] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.647] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.647] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.647] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.647] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.647] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.647] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.647] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.647] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.647] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.647] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.647] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.648] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.648] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.648] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.648] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.648] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.648] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.648] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.648] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.648] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.648] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.648] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.648] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.648] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150414.648] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.639] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.639] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.639] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.639] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.639] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.639] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.639] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.640] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.640] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.640] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.640] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.640] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.640] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.640] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.640] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.640] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.640] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.640] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.640] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.640] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.640] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.640] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.641] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.641] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.641] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.641] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.641] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.641] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.641] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.641] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.641] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.641] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.641] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.641] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.642] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.642] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.642] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.642] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.642] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.642] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.642] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.642] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.642] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.642] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.642] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.642] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.642] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.642] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.643] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.643] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.643] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.643] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.643] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.643] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.643] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.643] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.643] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.643] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.643] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.643] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.643] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.643] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.644] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.644] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.644] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.644] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.644] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.644] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.644] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.644] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.644] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.644] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.644] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.644] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.645] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.645] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.645] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.645] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.645] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.645] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.645] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.645] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.645] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.645] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.645] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.645] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.645] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.645] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.645] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.645] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.646] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.646] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.646] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.646] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.646] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.646] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.646] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.646] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.646] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.646] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.646] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.646] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.646] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.646] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.646] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.647] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.647] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.647] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.647] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.647] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.647] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.647] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.647] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.647] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.647] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.647] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.647] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.647] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.647] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.647] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.648] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.648] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.648] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.648] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.648] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.648] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.648] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.648] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.648] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.648] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.648] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.648] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.648] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.648] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.648] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.648] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150419.648] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150421.636] (EE) intel(0): Detected a hung GPU, disabling acceleration.
[150421.636] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150421.636] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150421.637] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150421.637] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150421.637] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150430.770] (II) AIGLX: Resuming AIGLX clients after VT switch
[150430.914] (II) intel(0): EDID vendor "LEN", prod id 16401
[150430.914] (II) intel(0): Printing DDC gathered Modelines:
[150430.914] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[150430.914] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[150431.051] (EE) intel(0): failed to set cursor: Input/output error
[150431.051] (EE) intel(0): failed to set cursor: Input/output error
[150431.051] (EE) intel(0): failed to set cursor: Input/output error
[150431.051] (EE) intel(0): failed to set cursor: Input/output error
[150431.116] (--) SynPS/2 Synaptics TouchPad: touchpad found
[150431.230] (EE) intel(0): failed to set cursor: Input/output error
[150431.230] (EE) intel(0): failed to set cursor: Input/output error
[150431.230] (EE) intel(0): failed to set cursor: Input/output error
[150431.230] (EE) intel(0): failed to set cursor: Input/output error
[150431.242] (EE) intel(0): failed to set cursor: Input/output error
[150431.243] (EE) intel(0): failed to set cursor: Input/output error
[150431.243] (EE) intel(0): failed to set cursor: Input/output error
[150431.243] (EE) intel(0): failed to set cursor: Input/output error
[150431.472] (EE) intel(0): failed to set cursor: Input/output error
[150431.473] (EE) intel(0): failed to set cursor: Input/output error
[150431.473] (EE) intel(0): failed to set cursor: Input/output error
[150431.473] (EE) intel(0): failed to set cursor: Input/output error
[150431.485] (EE) intel(0): failed to set cursor: Input/output error
[150431.485] (EE) intel(0): failed to set cursor: Input/output error
[150431.485] (EE) intel(0): failed to set cursor: Input/output error
[150431.485] (EE) intel(0): failed to set cursor: Input/output error
[150431.497] (EE) intel(0): failed to set cursor: Input/output error
[150431.497] (EE) intel(0): failed to set cursor: Input/output error
[150431.497] (EE) intel(0): failed to set cursor: Input/output error
[150431.497] (EE) intel(0): failed to set cursor: Input/output error
[150434.369] (EE) intel(0): failed to set cursor: Input/output error
[150434.369] (EE) intel(0): failed to set cursor: Input/output error
[150434.369] (EE) intel(0): failed to set cursor: Input/output error
[150434.369] (EE) intel(0): failed to set cursor: Input/output error
[150435.249] (EE) intel(0): failed to set cursor: Input/output error
[150435.249] (EE) intel(0): failed to set cursor: Input/output error
[150435.249] (EE) intel(0): failed to set cursor: Input/output error
[150435.249] (EE) intel(0): failed to set cursor: Input/output error
[150435.251] (EE) intel(0): failed to set cursor: Input/output error
[150435.251] (EE) intel(0): failed to set cursor: Input/output error
[150435.251] (EE) intel(0): failed to set cursor: Input/output error
[150435.251] (EE) intel(0): failed to set cursor: Input/output error
[150436.065] (EE) intel(0): failed to set cursor: Input/output error
[150436.065] (EE) intel(0): failed to set cursor: Input/output error
[150436.065] (EE) intel(0): failed to set cursor: Input/output error
[150436.066] (EE) intel(0): failed to set cursor: Input/output error
[150436.086] (EE) intel(0): failed to set cursor: Input/output error
[150436.086] (EE) intel(0): failed to set cursor: Input/output error
[150436.086] (EE) intel(0): failed to set cursor: Input/output error
[150436.086] (EE) intel(0): failed to set cursor: Input/output error
[150436.574] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150436.574] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150436.574] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150436.574] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150436.575] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150436.575] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150436.575] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150436.575] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150436.575] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150436.575] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150436.575] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150436.575] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150436.575] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150436.575] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150436.575] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150436.575] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150436.576] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150436.576] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150436.576] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150436.576] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150436.576] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150436.576] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150436.576] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150436.576] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150436.577] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150436.577] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150436.577] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150436.577] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150436.577] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150436.577] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150436.577] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150436.592] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150436.592] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150436.618] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150436.618] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150436.727] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150436.727] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150436.947] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150436.947] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150437.041] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150437.041] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150437.151] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150437.151] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150437.270] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150437.270] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150437.530] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150437.530] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150437.631] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150437.631] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150437.725] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150437.725] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150437.992] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150437.992] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150438.485] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150438.485] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150438.985] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150438.985] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150439.270] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150439.270] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150439.765] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150439.765] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150440.265] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150440.265] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150440.765] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150440.765] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150441.265] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150441.265] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150441.764] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150441.764] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150442.265] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150442.265] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150442.765] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150442.765] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150443.265] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150443.265] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150443.766] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150443.766] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150444.265] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150444.265] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150444.765] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150444.765] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150445.265] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150445.265] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150445.765] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150445.765] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150446.265] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150446.265] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150446.396] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150446.396] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150446.523] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150446.524] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150446.596] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150446.596] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150446.789] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150446.789] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150447.003] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150447.003] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150447.067] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150447.067] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150447.237] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150447.237] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150447.492] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150447.492] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150447.713] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150447.713] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150447.794] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150447.794] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150447.930] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150447.930] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150448.203] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150448.203] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150448.312] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150448.312] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150448.450] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150448.450] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150448.949] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150448.950] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150449.449] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150449.449] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150449.950] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150449.950] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150450.450] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150450.450] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150450.949] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150450.950] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150451.449] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150451.449] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150451.950] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150451.950] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150452.450] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150452.450] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150452.950] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150452.950] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150453.450] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150453.450] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150453.949] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150453.949] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150454.450] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150454.450] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150454.950] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150454.950] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150455.450] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150455.450] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150455.950] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150455.950] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150456.449] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150456.450] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150456.716] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150456.716] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150456.857] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150456.857] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150457.008] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150457.008] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150457.165] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150457.165] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150457.294] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150457.294] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150457.793] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150457.793] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150457.861] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150457.862] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150457.912] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150457.912] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150458.412] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150458.412] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150458.620] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150458.620] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150458.803] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150458.803] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150459.081] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150459.081] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150459.282] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150459.282] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150459.316] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150459.316] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150459.350] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150459.350] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150460.049] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150460.049] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150460.092] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150460.092] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150460.593] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150460.593] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150460.730] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150460.730] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150460.913] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150460.914] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150461.412] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150461.412] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150461.444] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150461.444] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150461.780] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150461.780] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150461.960] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150461.960] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150462.331] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150462.331] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150462.421] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150462.421] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150462.531] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150462.531] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150462.664] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150462.664] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150462.780] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150462.780] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150462.867] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150462.867] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150462.968] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150462.968] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150463.297] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150463.297] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150463.801] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150463.801] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150463.995] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150463.995] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150464.118] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150464.118] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150464.617] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150464.617] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150465.117] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150465.117] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150465.617] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150465.617] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150466.117] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150466.117] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150466.617] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150466.617] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150467.117] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150467.117] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150467.617] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150467.617] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150468.117] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150468.117] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150468.617] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150468.618] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150469.117] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150469.117] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150469.617] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150469.617] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150470.117] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150470.117] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150470.617] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150470.617] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150471.117] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150471.117] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150471.617] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150471.617] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150472.117] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150472.117] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150472.617] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150472.617] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150473.117] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150473.117] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150473.617] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150473.617] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150474.117] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150474.117] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150474.617] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150474.617] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150475.117] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150475.117] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150475.394] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150475.394] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150475.617] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150475.617] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150476.117] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150476.117] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150476.283] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150476.283] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150476.310] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150476.310] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150476.399] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150476.399] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150476.421] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150476.421] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150476.617] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150476.617] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150476.771] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150476.771] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150476.895] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150476.895] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150477.011] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150477.011] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150477.116] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150477.116] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150477.192] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150477.192] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150477.218] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150477.218] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150477.259] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150477.259] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150477.371] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150477.371] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150477.400] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150477.400] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150477.552] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150477.552] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150477.580] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150477.580] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150477.616] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150477.616] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150477.733] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150477.733] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150477.768] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150477.768] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150477.929] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150477.929] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150477.982] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150477.982] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150478.021] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150478.021] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150478.063] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150478.063] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150478.105] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150478.105] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150478.122] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150478.122] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150478.139] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150478.139] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150478.337] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150478.337] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150478.422] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150478.422] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150478.548] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150478.548] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150478.581] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150478.581] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150478.616] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150478.616] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150478.640] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150478.640] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150478.698] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150478.698] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150478.753] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150478.753] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150478.798] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150478.798] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150478.816] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150478.816] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150478.834] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150478.834] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150478.947] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150478.947] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150479.117] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150479.117] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150479.145] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150479.145] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150479.259] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150479.259] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150479.423] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150479.423] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150479.526] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150479.526] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150479.617] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150479.617] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150479.700] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150479.700] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150479.791] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150479.791] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150480.117] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150480.117] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150480.150] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150480.150] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150480.168] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150480.168] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150480.420] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150480.420] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150480.617] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150480.617] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150480.802] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150480.802] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150480.820] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150480.820] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150481.117] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150481.117] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150481.136] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150481.136] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150481.257] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150481.257] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150481.422] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150481.422] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150481.617] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150481.617] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150481.635] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150481.635] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150481.710] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150481.710] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150481.803] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150481.803] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150481.837] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150481.837] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150481.866] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150481.866] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150481.908] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150481.908] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150481.957] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150481.957] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150482.068] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150482.068] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150482.116] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150482.116] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150482.140] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150482.140] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150482.394] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150482.394] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150482.526] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150482.526] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150482.584] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150482.584] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150482.616] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150482.616] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150482.640] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150482.640] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150482.674] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150482.674] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150482.693] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150482.693] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150482.728] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150482.728] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150482.751] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150482.751] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150482.768] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150482.768] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150482.849] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150482.849] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150482.914] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150482.914] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150482.992] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150482.992] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150483.016] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150483.016] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150483.107] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150483.107] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150483.570] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150483.570] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150483.616] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150483.617] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150484.117] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150484.117] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150484.617] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150484.617] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150485.117] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150485.117] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150485.617] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150485.617] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150486.117] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150486.117] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150486.617] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150486.618] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150487.117] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150487.117] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150487.617] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150487.617] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150488.117] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150488.117] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150488.617] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150488.617] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150489.117] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150489.118] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150489.617] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150489.617] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150490.117] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150490.117] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150490.617] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150490.617] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150491.117] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150491.117] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150491.136] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150491.136] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150491.222] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150491.222] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150491.330] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150491.330] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150491.403] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150491.403] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150491.535] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150491.535] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150491.628] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150491.628] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150491.692] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150491.692] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150491.921] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150491.921] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150492.309] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150492.309] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150492.399] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150492.399] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150492.769] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150492.769] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150492.887] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150492.887] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150492.995] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150492.995] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150493.116] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150493.116] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150493.201] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150493.201] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150493.288] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150493.288] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150493.578] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150493.578] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150493.816] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150493.816] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150493.893] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150493.893] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150494.012] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150494.012] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150494.068] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150494.068] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150494.169] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150494.169] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150494.207] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150494.207] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150494.397] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150494.397] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150494.703] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150494.703] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150494.896] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150494.897] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150495.396] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150495.396] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150495.897] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150495.897] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150496.397] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150496.397] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150496.896] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150496.896] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150497.397] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150497.397] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150497.897] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150497.897] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150498.396] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150498.396] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150498.897] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150498.897] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150499.397] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150499.397] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150499.896] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150499.896] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150500.396] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150500.396] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150500.897] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150500.897] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150501.397] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150501.397] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150501.896] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150501.896] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150502.397] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150502.397] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150502.897] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150502.897] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150503.396] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150503.396] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150503.896] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150503.896] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150504.397] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150504.397] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150504.897] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150504.897] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150505.397] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150505.397] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150505.896] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150505.896] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150506.396] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150506.396] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150506.897] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150506.897] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150507.397] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150507.397] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150507.896] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150507.897] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150508.396] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150508.396] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150508.897] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150508.897] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150509.396] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150509.397] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150509.896] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150509.896] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150510.397] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150510.397] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150510.896] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150510.897] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150511.277] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150511.277] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150511.777] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150511.777] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150512.278] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150512.278] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150512.778] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150512.778] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150513.277] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150513.278] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150513.778] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150513.778] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150514.278] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150514.278] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150514.777] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150514.778] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150515.277] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150515.278] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150515.778] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150515.778] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150516.277] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150516.277] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150516.777] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150516.778] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150517.277] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150517.277] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150517.778] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150517.778] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150518.278] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150518.278] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150518.778] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150518.778] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150519.277] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150519.277] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150519.778] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150519.778] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150520.278] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150520.278] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150520.778] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150520.778] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150521.277] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150521.277] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150521.778] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150521.778] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150522.278] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150522.278] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150522.522] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150522.522] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150523.021] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150523.022] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150523.521] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150523.521] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150523.961] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150523.961] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150524.460] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150524.460] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150524.960] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150524.960] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150525.460] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150525.460] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150525.960] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150525.960] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150526.460] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150526.460] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150526.960] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150526.960] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150527.460] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150527.461] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150527.960] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150527.960] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150528.460] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150528.460] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150528.960] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150528.960] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150529.305] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150529.305] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150529.335] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150529.335] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150529.407] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150529.407] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150529.443] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150529.443] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150529.464] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150529.464] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150529.572] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150529.572] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150529.722] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150529.722] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150529.819] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150529.819] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150529.838] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150529.838] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150529.909] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150529.909] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150529.951] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150529.951] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150530.025] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150530.025] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150530.068] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150530.068] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150530.098] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150530.098] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150530.159] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150530.159] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150530.307] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150530.307] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150530.459] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150530.459] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150530.960] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150530.960] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150531.460] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150531.460] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150531.960] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150531.960] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150532.460] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150532.460] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150532.960] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150532.961] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150533.460] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150533.460] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150533.960] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150533.960] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150534.460] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150534.460] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150534.960] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150534.960] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150535.460] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150535.460] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150535.960] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150535.960] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150536.460] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150536.460] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150536.959] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150536.960] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150537.460] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150537.460] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150537.960] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150537.960] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150538.460] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150538.460] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150538.959] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150538.960] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150539.460] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150539.460] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150539.755] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150539.755] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150539.796] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150539.796] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150539.899] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150539.899] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150539.959] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150539.959] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150540.174] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150540.174] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150540.287] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150540.287] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150540.328] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150540.328] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150540.418] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150540.418] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150540.459] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150540.459] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150540.484] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150540.484] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150540.516] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150540.516] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150540.622] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150540.622] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150540.716] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150540.716] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150540.751] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150540.751] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150540.874] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150540.874] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150540.940] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150540.940] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150540.959] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150540.959] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150541.064] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150541.064] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150541.216] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150541.216] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150541.297] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150541.297] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150541.459] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150541.459] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150541.503] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150541.503] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150541.546] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150541.546] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150541.591] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150541.591] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150541.644] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150541.644] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150541.799] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150541.799] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150541.878] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150541.878] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150541.907] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150541.907] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150541.959] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150541.959] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150542.016] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150542.016] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150542.059] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150542.059] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150548.965] (EE) intel(0): failed to set cursor: Input/output error
[150548.965] (EE) intel(0): failed to set cursor: Input/output error
[150548.966] (EE) intel(0): failed to set cursor: Input/output error
[150548.966] (EE) intel(0): failed to set cursor: Input/output error
[150548.968] (EE) intel(0): failed to set cursor: Input/output error
[150548.968] (EE) intel(0): failed to set cursor: Input/output error
[150548.969] (EE) intel(0): failed to set cursor: Input/output error
[150548.969] (EE) intel(0): failed to set cursor: Input/output error
[150549.405] (EE) intel(0): failed to set cursor: Input/output error
[150549.405] (EE) intel(0): failed to set cursor: Input/output error
[150549.405] (EE) intel(0): failed to set cursor: Input/output error
[150549.406] (EE) intel(0): failed to set cursor: Input/output error
[150574.315] (EE) intel(0): failed to set cursor: Input/output error
[150574.315] (EE) intel(0): failed to set cursor: Input/output error
[150574.316] (EE) intel(0): failed to set cursor: Input/output error
[150574.316] (EE) intel(0): failed to set cursor: Input/output error
[150574.317] (EE) intel(0): failed to set cursor: Input/output error
[150574.317] (EE) intel(0): failed to set cursor: Input/output error
[150574.317] (EE) intel(0): failed to set cursor: Input/output error
[150574.318] (EE) intel(0): failed to set cursor: Input/output error
[150574.319] (EE) intel(0): failed to set cursor: Input/output error
[150574.319] (EE) intel(0): failed to set cursor: Input/output error
[150574.319] (EE) intel(0): failed to set cursor: Input/output error
[150574.320] (EE) intel(0): failed to set cursor: Input/output error
[150574.320] (EE) intel(0): failed to set cursor: Input/output error
[150574.321] (EE) intel(0): failed to set cursor: Input/output error
[150574.321] (EE) intel(0): failed to set cursor: Input/output error
[150574.321] (EE) intel(0): failed to set cursor: Input/output error
[150574.323] (EE) intel(0): failed to set cursor: Input/output error
[150574.323] (EE) intel(0): failed to set cursor: Input/output error
[150574.323] (EE) intel(0): failed to set cursor: Input/output error
[150574.324] (EE) intel(0): failed to set cursor: Input/output error
[150574.325] (EE) intel(0): failed to set cursor: Input/output error
[150574.325] (EE) intel(0): failed to set cursor: Input/output error
[150574.325] (EE) intel(0): failed to set cursor: Input/output error
[150574.325] (EE) intel(0): failed to set cursor: Input/output error
[150574.326] (EE) intel(0): failed to set cursor: Input/output error
[150574.326] (EE) intel(0): failed to set cursor: Input/output error
[150574.326] (EE) intel(0): failed to set cursor: Input/output error
[150574.326] (EE) intel(0): failed to set cursor: Input/output error
[150574.335] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150574.336] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150574.336] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150574.336] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150574.336] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150574.336] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150574.336] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150574.336] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150574.336] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150574.336] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150574.336] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150574.336] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150574.336] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150574.336] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150574.336] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150574.336] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150574.337] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150574.337] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150574.337] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150574.337] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150574.337] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150574.337] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150574.337] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150574.337] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150574.337] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150574.337] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150574.337] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150574.337] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150574.337] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150574.337] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150574.338] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150575.057] (EE) intel(0): failed to set cursor: Input/output error
[150575.057] (EE) intel(0): failed to set cursor: Input/output error
[150575.057] (EE) intel(0): failed to set cursor: Input/output error
[150575.057] (EE) intel(0): failed to set cursor: Input/output error
[150600.131] (EE) intel(0): failed to set cursor: Input/output error
[150600.131] (EE) intel(0): failed to set cursor: Input/output error
[150600.131] (EE) intel(0): failed to set cursor: Input/output error
[150600.131] (EE) intel(0): failed to set cursor: Input/output error
[150600.133] (EE) intel(0): failed to set cursor: Input/output error
[150600.133] (EE) intel(0): failed to set cursor: Input/output error
[150600.134] (EE) intel(0): failed to set cursor: Input/output error
[150600.134] (EE) intel(0): failed to set cursor: Input/output error
[150600.743] (EE) intel(0): failed to set cursor: Input/output error
[150600.743] (EE) intel(0): failed to set cursor: Input/output error
[150600.744] (EE) intel(0): failed to set cursor: Input/output error
[150600.744] (EE) intel(0): failed to set cursor: Input/output error
[150600.755] (EE) intel(0): failed to set cursor: Input/output error
[150600.756] (EE) intel(0): failed to set cursor: Input/output error
[150600.756] (EE) intel(0): failed to set cursor: Input/output error
[150600.756] (EE) intel(0): failed to set cursor: Input/output error
[150637.523] (EE) intel(0): failed to set cursor: Input/output error
[150637.523] (EE) intel(0): failed to set cursor: Input/output error
[150637.523] (EE) intel(0): failed to set cursor: Input/output error
[150637.527] (EE) intel(0): failed to set cursor: Input/output error
[150637.549] (EE) intel(0): failed to set cursor: Input/output error
[150637.549] (EE) intel(0): failed to set cursor: Input/output error
[150637.549] (EE) intel(0): failed to set cursor: Input/output error
[150637.549] (EE) intel(0): failed to set cursor: Input/output error
[150637.570] (EE) intel(0): failed to set cursor: Input/output error
[150637.570] (EE) intel(0): failed to set cursor: Input/output error
[150637.570] (EE) intel(0): failed to set cursor: Input/output error
[150637.570] (EE) intel(0): failed to set cursor: Input/output error
[150637.589] (EE) intel(0): failed to set cursor: Input/output error
[150637.590] (EE) intel(0): failed to set cursor: Input/output error
[150637.590] (EE) intel(0): failed to set cursor: Input/output error
[150637.590] (EE) intel(0): failed to set cursor: Input/output error
[150637.590] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150637.590] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150637.590] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150637.591] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150637.591] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150637.591] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150637.591] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150637.591] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150637.591] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150637.591] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150637.591] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150637.591] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150637.592] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150637.592] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150637.592] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150637.592] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150637.592] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150637.592] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150637.592] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150637.592] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150637.593] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150637.593] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150637.593] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150637.593] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150637.593] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150637.593] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150637.593] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150637.593] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150637.593] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150637.594] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150637.594] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150637.634] (EE) intel(0): failed to set cursor: Input/output error
[150637.634] (EE) intel(0): failed to set cursor: Input/output error
[150637.634] (EE) intel(0): failed to set cursor: Input/output error
[150637.634] (EE) intel(0): failed to set cursor: Input/output error
[150637.818] (EE) intel(0): failed to set cursor: Input/output error
[150637.818] (EE) intel(0): failed to set cursor: Input/output error
[150637.819] (EE) intel(0): failed to set cursor: Input/output error
[150637.819] (EE) intel(0): failed to set cursor: Input/output error
[150637.865] (EE) intel(0): failed to set cursor: Input/output error
[150637.865] (EE) intel(0): failed to set cursor: Input/output error
[150637.866] (EE) intel(0): failed to set cursor: Input/output error
[150637.866] (EE) intel(0): failed to set cursor: Input/output error
[150637.874] (EE) intel(0): failed to set cursor: Input/output error
[150637.874] (EE) intel(0): failed to set cursor: Input/output error
[150637.874] (EE) intel(0): failed to set cursor: Input/output error
[150637.874] (EE) intel(0): failed to set cursor: Input/output error
[150637.893] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150637.894] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150637.896] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150637.896] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150637.898] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150637.958] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150637.958] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150637.960] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150637.960] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150637.962] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150641.785] (EE) intel(0): failed to set cursor: Input/output error
[150641.786] (EE) intel(0): failed to set cursor: Input/output error
[150641.786] (EE) intel(0): failed to set cursor: Input/output error
[150641.786] (EE) intel(0): failed to set cursor: Input/output error
[150641.788] (EE) intel(0): failed to set cursor: Input/output error
[150641.788] (EE) intel(0): failed to set cursor: Input/output error
[150641.788] (EE) intel(0): failed to set cursor: Input/output error
[150641.788] (EE) intel(0): failed to set cursor: Input/output error
[150641.790] (EE) intel(0): failed to set cursor: Input/output error
[150641.790] (EE) intel(0): failed to set cursor: Input/output error
[150641.790] (EE) intel(0): failed to set cursor: Input/output error
[150641.790] (EE) intel(0): failed to set cursor: Input/output error
[150641.800] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150641.800] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150641.800] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150641.801] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150641.801] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150641.801] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150641.801] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150641.801] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150641.801] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150641.801] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150641.801] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150641.801] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150641.801] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150641.802] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150641.802] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150641.802] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150641.803] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150641.803] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150641.803] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150641.803] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150641.803] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150641.809] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150641.894] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150641.920] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150642.719] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150642.746] (WW) intel(0): intel_uxa_prepare_access: bo map failed: Input/=
output error
[150642.932] (EE) intel(0): failed to set cursor: Input/output error
[150642.932] (EE) intel(0): failed to set cursor: Input/output error
[150642.932] (EE) intel(0): failed to set cursor: Input/output error
[150642.932] (EE) intel(0): failed to set cursor: Input/output error
[150662.223] (EE) intel(0): failed to set cursor: Input/output error
[150662.224] (EE) intel(0): failed to set cursor: Input/output error
[150662.224] (EE) intel(0): failed to set cursor: Input/output error
[150662.224] (EE) intel(0): failed to set cursor: Input/output error
[150662.225] (EE) intel(0): failed to set cursor: Input/output error
[150662.225] (EE) intel(0): failed to set cursor: Input/output error
[150662.225] (EE) intel(0): failed to set cursor: Input/output error
[150662.226] (EE) intel(0): failed to set cursor: Input/output error
[150662.955] (EE) intel(0): failed to set cursor: Input/output error
[150662.956] (EE) intel(0): failed to set cursor: Input/output error
[150662.956] (EE) intel(0): failed to set cursor: Input/output error
[150662.956] (EE) intel(0): failed to set cursor: Input/output error
[150663.321] (EE) intel(0): failed to set cursor: Input/output error
[150663.321] (EE) intel(0): failed to set cursor: Input/output error
[150663.321] (EE) intel(0): failed to set cursor: Input/output error
[150663.322] (EE) intel(0): failed to set cursor: Input/output error

--u3/rZRmxL6MmkK24--

--kXdP64Ggrk/fb43R
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk00wogACgkQ19zI5DGHffAyWgCePEn1CfgPeL1/jBk1AsaWYB0O
disAoMHluCjclP+hacaaA9GAAy6DTCyg
=ZKV6
-----END PGP SIGNATURE-----

--kXdP64Ggrk/fb43R--

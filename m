Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431Ab0D0Int (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 04:43:49 -0400
Received: from sgn-x201-01.ethz.ch ([129.132.102.115]:50612 "EHLO
	kr.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751306Ab0D0In1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 04:43:27 -0400
Date: Tue, 27 Apr 2010 09:49:34 +0200
From: Nico Schottelius <nico-linux-20100427@schottelius.org>
To: LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.34-rc4/5: iwlagn unusable until reload
Message-ID: <20100427074934.GB3261@ikn.schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-linux-20100427@schottelius.org>,
	LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NklN7DEeGtkPCoo3"
Content-Disposition: inline
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Netzseite: http://www.nico.schottelius.org/
X-System-Info: kr (Linux 2.6.34-rc5-NS-00211-gb91ce4d x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NklN7DEeGtkPCoo3
Content-Type: multipart/mixed; boundary="OBd5C1Lgu00Gd/Tn"
Content-Disposition: inline


--OBd5C1Lgu00Gd/Tn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello again!

If I try to use iwlagn on the X201 with

02:00.0 Network controller: Intel Corporation WiFi Link 6000 Series (rev 35)

and 2.6.34-rc5-00211-gb91ce4d, I get a lot of error and no connection,
until I

[root@kr ~]# rmmod iwlagn
[root@kr ~]# modprobe iwlagn

Attached dmesg before & after.

Cheers,

Nico

--=20
New PGP key: 7ED9 F7D3 6B10 81D7 0EC5  5C09 D7DC C8E4 3187 7DF0
Please resign, if you signed 9885188C or 8D0E27A4.

Currently moving *.schottelius.org to http://www.nico.schottelius.org/ ...

--OBd5C1Lgu00Gd/Tn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="2.6.34-rc5-NS-00211-gb91ce4d.dmesg"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Linux version 2.6.34-rc5-NS-00211-gb91ce4d (nico@kr) (gcc ve=
rsion 4.5.0 (GCC) ) #15 SMP PREEMPT Tue Apr 27 09:38:24 CEST 2010
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
[    0.000000]  BIOS-e820: 00000000bb40f000 - 00000000bb46f000 (usable)
[    0.000000]  BIOS-e820: 00000000bb46f000 - 00000000bb668000 (reserved)
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
[    0.000000] e820 update range: 0000000000000000 - 0000000000001000 (usab=
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
[    0.000000] kernel direct mapping tables up to bb800000 @ 8000-c000
[    0.000000] init_memory_mapping: 0000000100000000-0000000138000000
[    0.000000]  0100000000 - 0138000000 page 2M
[    0.000000] kernel direct mapping tables up to 138000000 @ a000-10000
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
[    0.000000]   NODE_DATA [0000000100000000 - 0000000100004fff]
[    0.000000]  [ffffea0000000000-ffffea00045fffff] PMD -> [ffff88010020000=
0-ffff8801039fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000001 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00138000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[8] active PFN ranges
[    0.000000]     0: 0x00000001 -> 0x0000009e
[    0.000000]     0: 0x00000100 -> 0x000bb27c
[    0.000000]     0: 0x000bb282 -> 0x000bb363
[    0.000000]     0: 0x000bb40f -> 0x000bb46f
[    0.000000]     0: 0x000bb70f -> 0x000bb717
[    0.000000]     0: 0x000bb71f -> 0x000bb76b
[    0.000000]     0: 0x000bb7ff -> 0x000bb800
[    0.000000]     0: 0x00100000 -> 0x00138000
[    0.000000] On node 0 totalpages: 996271
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3941 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 748618 pages, LIFO batch:31
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
[    0.000000] nr_irqs_gsi: 24
[    0.000000] early_res array is doubled to 64 at [7000 - 77ff]
[    0.000000] Allocating PCI resources starting at c0000000 (gap: c0000000=
:20000000)
[    0.000000] early_res array is doubled to 128 at [b000 - bfff]
[    0.000000] setup_percpu: NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:4 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 26 pages/cpu @ffff880001800000 s76008 r8192=
 d22296 u524288
[    0.000000] pcpu-alloc: s76008 r8192 d22296 u524288 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3=20
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 978799
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line:=20
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Subtract (74 early reservations)
[    0.000000]   #1 [0001000000 - 000163a254]   TEXT DATA BSS
[    0.000000]   #2 [000009e800 - 0000100000]   BIOS reserved
[    0.000000]   #3 [000163b000 - 000163b144]             BRK
[    0.000000]   #4 [0000001000 - 0000003000]      TRAMPOLINE
[    0.000000]   #5 [0000003000 - 0000007000]     ACPI WAKEUP
[    0.000000]   #6 [0000008000 - 000000a000]         PGTABLE
[    0.000000]   #7 [000000a000 - 000000b000]         PGTABLE
[    0.000000]   #8 [0100000000 - 0100005000]       NODE_DATA
[    0.000000]   #9 [000163b180 - 000163c180]         BOOTMEM
[    0.000000]   #10 [000163a280 - 000163a568]         BOOTMEM
[    0.000000]   #11 [0100005000 - 0100006000]         BOOTMEM
[    0.000000]   #12 [0100006000 - 0100007000]         BOOTMEM
[    0.000000]   #13 [0100200000 - 0103a00000]        MEMMAP 0
[    0.000000]   #14 [000163a580 - 000163a700]         BOOTMEM
[    0.000000]   #15 [000163c180 - 0001654180]         BOOTMEM
[    0.000000]   #16 [0001654180 - 000165a180]         BOOTMEM
[    0.000000]   #17 [000165b000 - 000165c000]         BOOTMEM
[    0.000000]   #18 [000163a700 - 000163a741]         BOOTMEM
[    0.000000]   #19 [000163a780 - 000163a7c3]         BOOTMEM
[    0.000000]   #20 [000163a800 - 000163afe0]         BOOTMEM
[    0.000000]   #21 [000165a180 - 000165a1e8]         BOOTMEM
[    0.000000]   #22 [000165a200 - 000165a268]         BOOTMEM
[    0.000000]   #23 [000165a280 - 000165a2e8]         BOOTMEM
[    0.000000]   #24 [000165a300 - 000165a368]         BOOTMEM
[    0.000000]   #25 [000165a380 - 000165a3e8]         BOOTMEM
[    0.000000]   #26 [000165a400 - 000165a468]         BOOTMEM
[    0.000000]   #27 [000165a480 - 000165a4e8]         BOOTMEM
[    0.000000]   #28 [000165a500 - 000165a568]         BOOTMEM
[    0.000000]   #29 [000165a580 - 000165a5e8]         BOOTMEM
[    0.000000]   #30 [000165a600 - 000165a668]         BOOTMEM
[    0.000000]   #31 [000165a680 - 000165a6e8]         BOOTMEM
[    0.000000]   #32 [000165a700 - 000165a768]         BOOTMEM
[    0.000000]   #33 [000165a780 - 000165a7e8]         BOOTMEM
[    0.000000]   #34 [000165a800 - 000165a868]         BOOTMEM
[    0.000000]   #35 [000165a880 - 000165a8e8]         BOOTMEM
[    0.000000]   #36 [000165a900 - 000165a968]         BOOTMEM
[    0.000000]   #37 [000165a980 - 000165a9e8]         BOOTMEM
[    0.000000]   #38 [000165aa00 - 000165aa68]         BOOTMEM
[    0.000000]   #39 [000165aa80 - 000165aae8]         BOOTMEM
[    0.000000]   #40 [000165ab00 - 000165ab68]         BOOTMEM
[    0.000000]   #41 [000165ab80 - 000165abe8]         BOOTMEM
[    0.000000]   #42 [000165ac00 - 000165ac68]         BOOTMEM
[    0.000000]   #43 [000165ac80 - 000165ace8]         BOOTMEM
[    0.000000]   #44 [000165ad00 - 000165ad68]         BOOTMEM
[    0.000000]   #45 [000165ad80 - 000165ade8]         BOOTMEM
[    0.000000]   #46 [000165ae00 - 000165ae68]         BOOTMEM
[    0.000000]   #47 [000165ae80 - 000165aee8]         BOOTMEM
[    0.000000]   #48 [000165af00 - 000165af68]         BOOTMEM
[    0.000000]   #49 [000165af80 - 000165afe8]         BOOTMEM
[    0.000000]   #50 [000165c000 - 000165c068]         BOOTMEM
[    0.000000]   #51 [000165c080 - 000165c0e8]         BOOTMEM
[    0.000000]   #52 [000165c100 - 000165c168]         BOOTMEM
[    0.000000]   #53 [000165c180 - 000165c1e8]         BOOTMEM
[    0.000000]   #54 [000165c200 - 000165c268]         BOOTMEM
[    0.000000]   #55 [000165c280 - 000165c2e8]         BOOTMEM
[    0.000000]   #56 [000165c300 - 000165c301]         BOOTMEM
[    0.000000]   #57 [000165c340 - 000165c341]         BOOTMEM
[    0.000000]   #58 [0001800000 - 000181a000]         BOOTMEM
[    0.000000]   #59 [0001880000 - 000189a000]         BOOTMEM
[    0.000000]   #60 [0001900000 - 000191a000]         BOOTMEM
[    0.000000]   #61 [0001980000 - 000199a000]         BOOTMEM
[    0.000000]   #62 [000165e380 - 000165e388]         BOOTMEM
[    0.000000]   #63 [000165e3c0 - 000165e3c8]         BOOTMEM
[    0.000000]   #64 [000165e400 - 000165e410]         BOOTMEM
[    0.000000]   #65 [000165e440 - 000165e460]         BOOTMEM
[    0.000000]   #66 [000165e480 - 000165e5b0]         BOOTMEM
[    0.000000]   #67 [000165e5c0 - 000165e610]         BOOTMEM
[    0.000000]   #68 [000165e640 - 000165e690]         BOOTMEM
[    0.000000]   #69 [000165e6c0 - 00016666c0]         BOOTMEM
[    0.000000]   #70 [000199a000 - 000599a000]         BOOTMEM
[    0.000000]   #71 [00016666c0 - 00016866c0]         BOOTMEM
[    0.000000]   #72 [00016866c0 - 00016c66c0]         BOOTMEM
[    0.000000]   #73 [000000c000 - 0000014000]         BOOTMEM
[    0.000000] Memory: 3854756k/5111808k available (3558k kernel code, 1126=
724k absent, 130328k reserved, 1806k data, 500k init)
[    0.000000] SLUB: Genslabs=3D14, HWalign=3D64, Order=3D0-3, MinObjects=
=3D0, CPUs=3D4, Nodes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:384
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.001000] Detected 2394.036 MHz processor.
[    0.000004] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 4788.07 BogoMIPS (lpj=3D2394036)
[    0.000260] Security Framework initialized
[    0.000602] Dentry cache hash table entries: 524288 (order: 10, 4194304 =
bytes)
[    0.001705] Inode-cache hash table entries: 262144 (order: 9, 2097152 by=
tes)
[    0.002249] Mount-cache hash table entries: 256
[    0.002481] CPU: Physical Processor ID: 0
[    0.002600] CPU: Processor Core ID: 0
[    0.002721] mce: CPU supports 9 MCE banks
[    0.002858] CPU0: Thermal monitoring enabled (TM1)
[    0.002984] using mwait in idle threads.
[    0.003102] Performance Events: Westmere events, Intel PMU driver.
[    0.003308] ... version:                3
[    0.003425] ... bit width:              48
[    0.003542] ... generic registers:      4
[    0.003659] ... value mask:             0000ffffffffffff
[    0.003779] ... max period:             000000007fffffff
[    0.003907] ... fixed-purpose events:   3
[    0.004024] ... event mask:             000000070000000f
[    0.004177] ACPI: Core revision 20100121
[    0.036617] Setting APIC routing to flat
[    0.037172] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.047296] CPU0: Intel(R) Core(TM) i5 CPU       M 520  @ 2.40GHz steppi=
ng 02
[    0.152608] Booting Node   0, Processors  #1 #2 #3 Ok.
[    0.429211] Brought up 4 CPUs
[    0.429345] Total of 4 processors activated (19151.28 BogoMIPS).
[    0.430826] regulator: core version 0.5
[    0.431012] NET: Registered protocol family 16
[    0.431363] ACPI FADT declares the system doesn't support PCIe ASPM, so =
disable it
[    0.431590] ACPI: bus type pci registered
[    0.431805] PCI: Using configuration type 1 for base access
[    0.433785] bio: create slab <bio-0> at 0
[    0.436140] ACPI: EC: EC description table is found, configuring boot EC
[    0.445554] ACPI: BIOS _OSI(Linux) query ignored
[    0.523631] ACPI: SSDT 00000000bb71aa18 0046F (v01  PmRef  Cpu0Ist 00003=
000 INTL 20050513)
[    0.524824] ACPI: SSDT 00000000bb718718 006B2 (v01  PmRef  Cpu0Cst 00003=
001 INTL 20050513)
[    0.526283] ACPI: SSDT 00000000bb719a98 00303 (v01  PmRef    ApIst 00003=
000 INTL 20050513)
[    0.527389] ACPI: SSDT 00000000bb717d98 00119 (v01  PmRef    ApCst 00003=
000 INTL 20050513)
[    0.529396] ACPI: Interpreter enabled
[    0.529531] ACPI: (supports S0 S3 S5)
[    0.529803] ACPI: Using IOAPIC for interrupt routing
[    0.542230] ACPI: EC: GPE =3D 0x11, I/O: command/status =3D 0x66, data =
=3D 0x62
[    0.542594] ACPI: Power Resource [PUBS] (on)
[    0.545342] ACPI: ACPI Dock Station Driver: 3 docks/bays found
[    0.545483] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.545727] ACPI: PCI Root Bridge [UNCR] (0000:ff)
[    0.546514] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.546715] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.546858] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.547001] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x00=
0bffff]
[    0.547226] pci_root PNP0A08:00: host bridge window [mem 0x000d4000-0x00=
0d7fff]
[    0.547451] pci_root PNP0A08:00: host bridge window [mem 0x000d8000-0x00=
0dbfff]
[    0.547677] pci_root PNP0A08:00: host bridge window [mem 0xc0000000-0xfe=
bfffff]
[    0.547937] pci 0000:00:02.0: reg 10: [mem 0xf2000000-0xf23fffff 64bit]
[    0.547942] pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff 64bit p=
ref]
[    0.547945] pci 0000:00:02.0: reg 20: [io  0x1800-0x1807]
[    0.548023] pci 0000:00:16.0: reg 10: [mem 0xf2727800-0xf272780f 64bit]
[    0.548079] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.548083] pci 0000:00:16.0: PME# disabled
[    0.548124] pci 0000:00:16.3: reg 10: [io  0x1808-0x180f]
[    0.548131] pci 0000:00:16.3: reg 14: [mem 0xf2524000-0xf2524fff]
[    0.548234] pci 0000:00:19.0: reg 10: [mem 0xf2500000-0xf251ffff]
[    0.548242] pci 0000:00:19.0: reg 14: [mem 0xf2525000-0xf2525fff]
[    0.548249] pci 0000:00:19.0: reg 18: [io  0x1820-0x183f]
[    0.548301] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.548305] pci 0000:00:19.0: PME# disabled
[    0.548352] pci 0000:00:1a.0: reg 10: [mem 0xf2728000-0xf27283ff]
[    0.548416] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.548420] pci 0000:00:1a.0: PME# disabled
[    0.548461] pci 0000:00:1b.0: reg 10: [mem 0xf2520000-0xf2523fff 64bit]
[    0.548518] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.548523] pci 0000:00:1b.0: PME# disabled
[    0.548605] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.548610] pci 0000:00:1c.0: PME# disabled
[    0.548699] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.548703] pci 0000:00:1c.3: PME# disabled
[    0.548789] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.548793] pci 0000:00:1c.4: PME# disabled
[    0.548845] pci 0000:00:1d.0: reg 10: [mem 0xf2728400-0xf27287ff]
[    0.548909] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.548913] pci 0000:00:1d.0: PME# disabled
[    0.549109] pci 0000:00:1f.2: reg 10: [io  0x1860-0x1867]
[    0.549115] pci 0000:00:1f.2: reg 14: [io  0x1814-0x1817]
[    0.549122] pci 0000:00:1f.2: reg 18: [io  0x1818-0x181f]
[    0.549129] pci 0000:00:1f.2: reg 1c: [io  0x1810-0x1813]
[    0.549136] pci 0000:00:1f.2: reg 20: [io  0x1840-0x185f]
[    0.549143] pci 0000:00:1f.2: reg 24: [mem 0xf2727000-0xf27277ff]
[    0.549187] pci 0000:00:1f.2: PME# supported from D3hot
[    0.549191] pci 0000:00:1f.2: PME# disabled
[    0.549226] pci 0000:00:1f.3: reg 10: [mem 0xf2728800-0xf27288ff 64bit]
[    0.549244] pci 0000:00:1f.3: reg 20: [io  0x1880-0x189f]
[    0.549304] pci 0000:00:1f.6: reg 10: [mem 0xf2526000-0xf2526fff 64bit]
[    0.549419] pci 0000:00:1c.0: PCI bridge to [bus 0d-0d]
[    0.549558] pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000] (disab=
led)
[    0.549563] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff=
] (disabled)
[    0.549570] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff=
 pref] (disabled)
[    0.549625] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    0.549765] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    0.549770] pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf1ffffff]
[    0.549777] pci 0000:00:1c.3:   bridge window [mem 0xf2800000-0xf28fffff=
 64bit pref]
[    0.549935] pci 0000:02:00.0: reg 10: [mem 0xf2400000-0xf2401fff 64bit]
[    0.550118] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    0.550145] pci 0000:02:00.0: PME# disabled
[    0.550188] pci 0000:00:1c.4: PCI bridge to [bus 02-02]
[    0.550328] pci 0000:00:1c.4:   bridge window [io  0xf000-0x0000] (disab=
led)
[    0.550332] pci 0000:00:1c.4:   bridge window [mem 0xf2400000-0xf24fffff]
[    0.550339] pci 0000:00:1c.4:   bridge window [mem 0xfff00000-0x000fffff=
 pref] (disabled)
[    0.550409] pci 0000:00:1e.0: PCI bridge to [bus 0e-0e] (subtractive dec=
ode)
[    0.550556] pci 0000:00:1e.0:   bridge window [io  0xf000-0x0000] (disab=
led)
[    0.550560] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff=
] (disabled)
[    0.550568] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff=
 pref] (disabled)
[    0.550570] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtr=
active decode)
[    0.550572] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtr=
active decode)
[    0.550574] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff=
] (subtractive decode)
[    0.550576] pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff=
] (subtractive decode)
[    0.550578] pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff=
] (subtractive decode)
[    0.550580] pci 0000:00:1e.0:   bridge window [mem 0xc0000000-0xfebfffff=
] (subtractive decode)
[    0.550608] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.550774] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
[    0.550848] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP4._PRT]
[    0.550920] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP5._PRT]
[    0.556663] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
[    0.557396] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
[    0.558111] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 11) *0,=
 disabled.
[    0.559012] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
[    0.559741] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
[    0.560457] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11) *0,=
 disabled.
[    0.561340] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11) *0,=
 disabled.
[    0.562236] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
[    0.562940] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.563174] vgaarb: loaded
[    0.563408] SCSI subsystem initialized
[    0.563597] libata version 3.00 loaded.
[    0.563690] PCI: Using ACPI for IRQ routing
[    0.563825] PCI: pci_cache_line_size set to 64 bytes
[    0.563952] reserve RAM buffer: 000000000009e800 - 000000000009ffff=20
[    0.563954] reserve RAM buffer: 00000000bb27c000 - 00000000bbffffff=20
[    0.563960] reserve RAM buffer: 00000000bb363000 - 00000000bbffffff=20
[    0.563965] reserve RAM buffer: 00000000bb46f000 - 00000000bbffffff=20
[    0.563969] reserve RAM buffer: 00000000bb717000 - 00000000bbffffff=20
[    0.563973] reserve RAM buffer: 00000000bb76b000 - 00000000bbffffff=20
[    0.563976] reserve RAM buffer: 00000000bb800000 - 00000000bbffffff=20
[    0.564079] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.564590] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.566737] Switching to clocksource tsc
[    0.566963] pnp: PnP ACPI init
[    0.567102] ACPI: bus type pnp registered
[    0.571344] pnp: PnP ACPI: found 13 devices
[    0.571479] ACPI: ACPI bus type pnp unregistered
[    0.571622] system 00:00: [mem 0x00000000-0x0009ffff] could not be reser=
ved
[    0.571765] system 00:00: [mem 0x000c0000-0x000c3fff] has been reserved
[    0.571907] system 00:00: [mem 0x000c4000-0x000c7fff] has been reserved
[    0.572052] system 00:00: [mem 0x000c8000-0x000cbfff] has been reserved
[    0.572195] system 00:00: [mem 0x000cc000-0x000cffff] has been reserved
[    0.572336] system 00:00: [mem 0x000d0000-0x000d3fff] could not be reser=
ved
[    0.572480] system 00:00: [mem 0x000dc000-0x000dffff] could not be reser=
ved
[    0.572623] system 00:00: [mem 0x000e0000-0x000e3fff] could not be reser=
ved
[    0.572766] system 00:00: [mem 0x000e4000-0x000e7fff] could not be reser=
ved
[    0.572910] system 00:00: [mem 0x000e8000-0x000ebfff] could not be reser=
ved
[    0.573057] system 00:00: [mem 0x000ec000-0x000effff] could not be reser=
ved
[    0.573201] system 00:00: [mem 0x000f0000-0x000fffff] could not be reser=
ved
[    0.573343] system 00:00: [mem 0x00100000-0xbfffffff] could not be reser=
ved
[    0.573486] system 00:00: [mem 0xfec00000-0xfed3ffff] could not be reser=
ved
[    0.573629] system 00:00: [mem 0xfed4c000-0xffffffff] could not be reser=
ved
[    0.573774] system 00:03: [io  0x164e-0x164f] has been reserved
[    0.573913] system 00:03: [io  0x1000-0x107f] has been reserved
[    0.574055] system 00:03: [io  0x1180-0x11ff] has been reserved
[    0.574195] system 00:03: [io  0x0800-0x080f] has been reserved
[    0.574335] system 00:03: [io  0x15e0-0x15ef] has been reserved
[    0.574475] system 00:03: [io  0x1600-0x1641] has been reserved
[    0.574613] system 00:03: [io  0x1644-0x167f] could not be reserved
[    0.574754] system 00:03: [mem 0xe0000000-0xefffffff] has been reserved
[    0.574894] system 00:03: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.575040] system 00:03: [mem 0xfed10000-0xfed13fff] has been reserved
[    0.575180] system 00:03: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.575323] system 00:03: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.575464] system 00:03: [mem 0xfed45000-0xfed4bfff] has been reserved
[    0.575610] system 00:0c: [mem 0xfeaff000-0xfeafffff] has been reserved
[    0.580690] PCI: max bus depth: 1 pci_try_num: 2
[    0.580730] pci 0000:00:1c.0: PCI bridge to [bus 0d-0d]
[    0.580866] pci 0000:00:1c.0:   bridge window [io  disabled]
[    0.581012] pci 0000:00:1c.0:   bridge window [mem disabled]
[    0.581153] pci 0000:00:1c.0:   bridge window [mem pref disabled]
[    0.581297] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    0.581437] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    0.581582] pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf1ffffff]
[    0.581726] pci 0000:00:1c.3:   bridge window [mem 0xf2800000-0xf28fffff=
 64bit pref]
[    0.581961] pci 0000:00:1c.4: PCI bridge to [bus 02-02]
[    0.582098] pci 0000:00:1c.4:   bridge window [io  disabled]
[    0.582241] pci 0000:00:1c.4:   bridge window [mem 0xf2400000-0xf24fffff]
[    0.582386] pci 0000:00:1c.4:   bridge window [mem pref disabled]
[    0.582530] pci 0000:00:1e.0: PCI bridge to [bus 0e-0e]
[    0.582668] pci 0000:00:1e.0:   bridge window [io  disabled]
[    0.582809] pci 0000:00:1e.0:   bridge window [mem disabled]
[    0.582954] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    0.583111] pci 0000:00:1c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    0.583257] pci 0000:00:1c.0: setting latency timer to 64
[    0.583268] pci 0000:00:1c.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    0.583412] pci 0000:00:1c.3: setting latency timer to 64
[    0.583421] pci 0000:00:1c.4: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    0.583568] pci 0000:00:1c.4: setting latency timer to 64
[    0.583576] pci 0000:00:1e.0: setting latency timer to 64
[    0.583580] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.583581] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.583583] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.583585] pci_bus 0000:00: resource 7 [mem 0x000d4000-0x000d7fff]
[    0.583586] pci_bus 0000:00: resource 8 [mem 0x000d8000-0x000dbfff]
[    0.583588] pci_bus 0000:00: resource 9 [mem 0xc0000000-0xfebfffff]
[    0.583590] pci_bus 0000:05: resource 0 [io  0x2000-0x2fff]
[    0.583591] pci_bus 0000:05: resource 1 [mem 0xf0000000-0xf1ffffff]
[    0.583593] pci_bus 0000:05: resource 2 [mem 0xf2800000-0xf28fffff 64bit=
 pref]
[    0.583595] pci_bus 0000:02: resource 1 [mem 0xf2400000-0xf24fffff]
[    0.583597] pci_bus 0000:0e: resource 4 [io  0x0000-0x0cf7]
[    0.583598] pci_bus 0000:0e: resource 5 [io  0x0d00-0xffff]
[    0.583600] pci_bus 0000:0e: resource 6 [mem 0x000a0000-0x000bffff]
[    0.583602] pci_bus 0000:0e: resource 7 [mem 0x000d4000-0x000d7fff]
[    0.583603] pci_bus 0000:0e: resource 8 [mem 0x000d8000-0x000dbfff]
[    0.583605] pci_bus 0000:0e: resource 9 [mem 0xc0000000-0xfebfffff]
[    0.583624] NET: Registered protocol family 2
[    0.583859] IP route cache hash table entries: 131072 (order: 8, 1048576=
 bytes)
[    0.584798] TCP established hash table entries: 524288 (order: 11, 83886=
08 bytes)
[    0.587392] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.587819] TCP: Hash tables configured (established 524288 bind 65536)
[    0.587964] TCP reno registered
[    0.588101] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.588273] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.588520] NET: Registered protocol family 1
[    0.588678] pci 0000:00:02.0: Boot video device
[    0.588796] PCI: CLS 64 bytes, default 64
[    0.588837] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.588979] Placing 64MB software IO TLB between ffff88000199a000 - ffff=
88000599a000
[    0.589207] software IO TLB at phys 0x199a000 - 0x599a000
[    0.589435] Simple Boot Flag at 0x35 set to 0x80
[    0.590327] microcode: CPU0 sig=3D0x20652, pf=3D0x10, revision=3D0x9
[    0.590471] microcode: CPU1 sig=3D0x20652, pf=3D0x10, revision=3D0x9
[    0.590613] microcode: CPU2 sig=3D0x20652, pf=3D0x10, revision=3D0x9
[    0.590757] microcode: CPU3 sig=3D0x20652, pf=3D0x10, revision=3D0x9
[    0.590926] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.f=
snet.co.uk>, Peter Oruba
[    0.594041] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.595956] VFS: Disk quotas dquot_6.5.2
[    0.596142] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.596772] JFS: nTxBlock =3D 8192, nTxLock =3D 65536
[    0.598631] Btrfs loaded
[    0.598767] msgmni has been set to 7528
[    0.599189] alg: No test for stdrng (krng)
[    0.599395] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 254)
[    0.599620] io scheduler noop registered
[    0.599754] io scheduler deadline registered
[    0.599967] io scheduler cfq registered (default)
[    0.600199] pcieport 0000:00:1c.0: setting latency timer to 64
[    0.600252] pcieport 0000:00:1c.0: irq 24 for MSI/MSI-X
[    0.600336] pcieport 0000:00:1c.3: setting latency timer to 64
[    0.600383] pcieport 0000:00:1c.3: irq 25 for MSI/MSI-X
[    0.600485] pcieport 0000:00:1c.4: setting latency timer to 64
[    0.600532] pcieport 0000:00:1c.4: irq 26 for MSI/MSI-X
[    0.600997] ACPI: AC Adapter [AC] (on-line)
[    0.601226] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0=
D:00/input/input0
[    0.601643] ACPI: Lid Switch [LID]
[    0.601828] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0=
C0E:00/input/input1
[    0.602060] ACPI: Sleep Button [SLPB]
[    0.602248] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input2
[    0.602474] ACPI: Power Button [PWRF]
[    0.605095] Monitor-Mwait will be used to enter C-1 state
[    0.605110] Monitor-Mwait will be used to enter C-2 state
[    0.605122] Monitor-Mwait will be used to enter C-3 state
[    0.615098] thermal LNXTHERM:01: registered as thermal_zone0
[    0.615242] ACPI: Thermal Zone [THM0] (55 C)
[    0.631161] ACPI: Battery Slot [BAT0] (battery present)
[    0.640569] Linux agpgart interface v0.103
[    0.641769] brd: module loaded
[    0.641909] Uniform Multi-Platform E-IDE driver
[    0.642103] ide-gd driver 1.18
[    0.642364] ahci 0000:00:1f.2: version 3.0
[    0.642385] ahci 0000:00:1f.2: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.642568] ahci 0000:00:1f.2: irq 27 for MSI/MSI-X
[    0.642599] ahci: SSS flag set, parallel bus scan disabled
[    0.642783] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 3 Gbps 0x=
33 impl SATA mode
[    0.643014] ahci 0000:00:1f.2: flags: 64bit ncq sntf ilck stag pm led cl=
o pmp pio slum part ems sxs apst=20
[    0.643249] ahci 0000:00:1f.2: setting latency timer to 64
[    0.648890] scsi0 : ahci
[    0.649106] scsi1 : ahci
[    0.649297] scsi2 : ahci
[    0.649488] scsi3 : ahci
[    0.649679] scsi4 : ahci
[    0.649877] scsi5 : ahci
[    0.651159] ata1: SATA max UDMA/133 abar m2048@0xf2727000 port 0xf272710=
0 irq 27
[    0.651385] ata2: SATA max UDMA/133 abar m2048@0xf2727000 port 0xf272718=
0 irq 27
[    0.651608] ata3: DUMMY
[    0.651736] ata4: DUMMY
[    0.651869] ata5: SATA max UDMA/133 abar m2048@0xf2727000 port 0xf272730=
0 irq 27
[    0.652096] ata6: SATA max UDMA/133 abar m2048@0xf2727000 port 0xf272738=
0 irq 27
[    0.652494] ieee1394: raw1394: /dev/raw1394 device initialized
[    0.652713] PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 =
irq 1,12
[    0.656141] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.656281] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.656519] mice: PS/2 mouse device common for all mice
[    0.657193] cpuidle: using governor ladder
[    0.657908] cpuidle: using governor menu
[    0.658305] TCP cubic registered
[    0.658440] NET: Registered protocol family 17
[    0.660889] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input3
[    0.662973] registered taskstats version 1
[    1.109011] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.110504] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succee=
ded
[    1.110513] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK=
) filtered out
[    1.110755] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filter=
ed out
[    1.149017] ata1.00: ATA-8: ST9500420AS, 0003LVM1, max UDMA/100
[    1.149174] ata1.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    1.152037] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succee=
ded
[    1.152045] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK=
) filtered out
[    1.152285] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filter=
ed out
[    1.154566] ata1.00: configured for UDMA/100
[    1.169506] ata1.00: configured for UDMA/100
[    1.169652] ata1: EH complete
[    1.169939] scsi 0:0:0:0: Direct-Access     ATA      ST9500420AS      00=
03 PQ: 0 ANSI: 5
[    1.170531] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB=
/465 GiB)
[    1.170865] sd 0:0:0:0: [sda] Write Protect is off
[    1.171013] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.171048] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    1.171480]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[    1.197449] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.400841] Synaptics Touchpad, model: 1, fw: 7.4, id: 0x1e0b1, caps: 0x=
d047b1/0xb40000
[    1.401074] serio: Synaptics pass-through port at isa0060/serio1/input0
[    1.452418] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042=
/serio1/input/input4
[    2.044511] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.050399] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
[    2.051277] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
[    2.054993] ata2.00: ATAPI: HL-DT-ST DVDRAM GSA-U20N, HX12, max UDMA/133
[    2.061584] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
[    2.062469] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
[    2.066265] ata2.00: configured for UDMA/133
[    2.085723] scsi 1:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-U20N  HX=
12 PQ: 0 ANSI: 5
[    2.390895] ata5: SATA link down (SStatus 0 SControl 300)
[    2.706358] ata6: SATA link down (SStatus 0 SControl 300)
[    2.781967] VFS: Mounted root (jfs filesystem) readonly on device 8:1.
[    2.782132] Freeing unused kernel memory: 500k freed
[    3.662752] rtc_cmos 00:08: RTC can wake from S4
[    3.662922] rtc_cmos 00:08: rtc core: registered rtc_cmos as rtc0
[    3.662960] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    4.224837] udev: starting version 151
[    4.558287] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    4.558368] scsi 1:0:0:0: Attached scsi generic sg1 type 5
[    4.661277] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 =
cdda tray
[    4.661281] Uniform CD-ROM driver Revision: 3.20
[    4.661396] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    4.703173] ACPI: WMI: Mapper loaded
[    4.834148] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    4.834154] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    4.834159] ILI
[    4.834161] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    4.834165] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    4.834175] end_request: I/O error, dev sr0, sector 0
[    4.834178] Buffer I/O error on device sr0, logical block 0
[    4.837168] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    4.837173] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    4.837178] ILI
[    4.837180] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    4.837185] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    4.837196] end_request: I/O error, dev sr0, sector 0
[    4.837199] Buffer I/O error on device sr0, logical block 0
[    4.840179] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    4.840184] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    4.840188] ILI
[    4.840190] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    4.840195] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    4.840205] end_request: I/O error, dev sr0, sector 0
[    4.840209] Buffer I/O error on device sr0, logical block 0
[    4.843258] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    4.843263] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    4.843268] ILI
[    4.843270] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    4.843274] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    4.843285] end_request: I/O error, dev sr0, sector 0
[    4.843289] Buffer I/O error on device sr0, logical block 0
[    4.846266] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    4.846271] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    4.846276] ILI
[    4.846278] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    4.846282] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    4.846293] end_request: I/O error, dev sr0, sector 0
[    4.846296] Buffer I/O error on device sr0, logical block 0
[    4.849286] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    4.849291] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    4.849295] ILI
[    4.849297] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    4.849301] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    4.849312] end_request: I/O error, dev sr0, sector 0
[    4.849316] Buffer I/O error on device sr0, logical block 0
[    4.852300] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    4.852307] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    4.852313] ILI
[    4.852315] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    4.852321] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    4.852334] end_request: I/O error, dev sr0, sector 0
[    4.852338] Buffer I/O error on device sr0, logical block 0
[    4.855339] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    4.855344] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    4.855349] ILI
[    4.855350] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    4.855354] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    4.855363] end_request: I/O error, dev sr0, sector 0
[    4.855367] Buffer I/O error on device sr0, logical block 0
[    4.858364] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    4.858370] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    4.858376] ILI
[    4.858378] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    4.858382] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    4.858394] end_request: I/O error, dev sr0, sector 0
[    4.858398] Buffer I/O error on device sr0, logical block 0
[    4.861333] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    4.861338] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    4.861343] ILI
[    4.861345] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    4.861349] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    4.861360] end_request: I/O error, dev sr0, sector 0
[    4.861364] Buffer I/O error on device sr0, logical block 0
[    4.864416] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    4.864420] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    4.864425] ILI
[    4.864427] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    4.864431] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 0e 00 0=
0 02 00
[    4.864442] end_request: I/O error, dev sr0, sector 56
[    4.867419] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    4.867424] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    4.867429] ILI
[    4.867431] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    4.867435] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    4.867445] end_request: I/O error, dev sr0, sector 0
[    4.870432] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    4.870438] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    4.870444] ILI
[    4.870446] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    4.870450] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    4.870462] end_request: I/O error, dev sr0, sector 0
[    4.873505] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    4.873510] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    4.873515] ILI
[    4.873517] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    4.873522] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    4.873532] end_request: I/O error, dev sr0, sector 0
[    4.876509] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    4.876514] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    4.876519] ILI
[    4.876521] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    4.876525] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    4.876536] end_request: I/O error, dev sr0, sector 0
[    4.879541] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    4.879546] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    4.879560] ILI
[    4.879563] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    4.879568] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    4.879579] end_request: I/O error, dev sr0, sector 0
[    4.882648] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    4.882654] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    4.882660] ILI
[    4.882662] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    4.882666] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    4.882678] end_request: I/O error, dev sr0, sector 0
[    4.885644] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    4.885649] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    4.885654] ILI
[    4.885656] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    4.885660] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    4.885671] end_request: I/O error, dev sr0, sector 0
[    4.888677] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    4.888684] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    4.888689] ILI
[    4.888691] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    4.888696] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    4.888707] end_request: I/O error, dev sr0, sector 0
[    4.892559] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    4.892567] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    4.892574] ILI
[    4.892577] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    4.892584] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    4.892600] end_request: I/O error, dev sr0, sector 0
[    4.893039] Non-volatile memory driver v1.3
[    4.895460] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    4.895466] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    4.895471] ILI
[    4.895473] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    4.895477] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    4.895488] end_request: I/O error, dev sr0, sector 0
[    4.898464] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    4.898471] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    4.898476] ILI
[    4.898478] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    4.898483] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    4.898494] end_request: I/O error, dev sr0, sector 0
[    4.901472] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    4.901477] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    4.901482] ILI
[    4.901484] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    4.901489] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    4.901499] end_request: I/O error, dev sr0, sector 0
[    4.904610] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    4.904615] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    4.904620] ILI
[    4.904622] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    4.904627] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    4.904637] end_request: I/O error, dev sr0, sector 0
[    4.907624] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    4.907631] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    4.907638] ILI
[    4.907640] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    4.907647] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    4.907662] end_request: I/O error, dev sr0, sector 0
[    4.910634] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    4.910642] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    4.910647] ILI
[    4.910649] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    4.910654] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    4.910665] end_request: I/O error, dev sr0, sector 0
[    4.911512] tpm_tis 00:0b: 1.2 TPM (device-id 0x0, rev-id 78)
[    4.913695] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    4.913701] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    4.913706] ILI
[    4.913708] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    4.913712] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    4.913723] end_request: I/O error, dev sr0, sector 0
[    4.916704] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    4.916709] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    4.916714] ILI
[    4.916716] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    4.916721] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 02 00 0=
0 02 00
[    4.916731] end_request: I/O error, dev sr0, sector 8
[    4.919779] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    4.919786] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    4.919791] ILI
[    4.919793] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    4.919798] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 02 00 0=
0 02 00
[    4.919809] end_request: I/O error, dev sr0, sector 8
[    4.922863] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    4.922870] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    4.922875] ILI
[    4.922878] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    4.922883] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 02 00 0=
0 02 00
[    4.922898] end_request: I/O error, dev sr0, sector 8
[    4.925883] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    4.925889] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    4.925895] ILI
[    4.925897] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    4.925902] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 02 00 0=
0 02 00
[    4.925913] end_request: I/O error, dev sr0, sector 8
[    4.928850] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    4.928857] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    4.928863] ILI
[    4.928865] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    4.928870] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 06 00 0=
0 02 00
[    4.928881] end_request: I/O error, dev sr0, sector 24
[    4.931914] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    4.931919] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    4.931924] ILI
[    4.931926] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    4.931930] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 06 00 0=
0 02 00
[    4.931941] end_request: I/O error, dev sr0, sector 24
[    4.934920] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    4.934925] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    4.934929] ILI
[    4.934931] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    4.934936] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 06 00 0=
0 02 00
[    4.934946] end_request: I/O error, dev sr0, sector 24
[    4.937933] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    4.937938] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    4.937943] ILI
[    4.937945] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    4.937949] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 06 00 0=
0 02 00
[    4.937960] end_request: I/O error, dev sr0, sector 24
[    4.940939] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    4.940947] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    4.940954] ILI
[    4.940956] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    4.940963] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 0e 00 0=
0 02 00
[    4.940978] end_request: I/O error, dev sr0, sector 56
[    4.944002] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    4.944007] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    4.944011] ILI
[    4.944013] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    4.944018] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 0e 00 0=
0 02 00
[    4.944028] end_request: I/O error, dev sr0, sector 56
[    4.948829] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    4.948835] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    4.948841] ILI
[    4.948844] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    4.948849] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 0e 00 0=
0 02 00
[    4.948863] end_request: I/O error, dev sr0, sector 56
[    4.952244] cfg80211: Calling CRDA to update world regulatory domain
[    4.954927] agpgart-intel 0000:00:00.0: Intel HD Graphics Chipset
[    4.955485] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    4.955490] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    4.955493] ILI
[    4.955495] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    4.955498] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 0e 00 0=
0 02 00
[    4.955506] end_request: I/O error, dev sr0, sector 56
[    4.956027] agpgart-intel 0000:00:00.0: detected 32764K stolen memory
[    4.958499] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    4.958502] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    4.958505] ILI
[    4.958506] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    4.958508] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 1e 00 0=
0 02 00
[    4.958514] end_request: I/O error, dev sr0, sector 120
[    4.961499] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    4.961501] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    4.961503] ILI
[    4.961504] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    4.961506] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 1e 00 0=
0 02 00
[    4.961512] end_request: I/O error, dev sr0, sector 120
[    4.964560] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    4.964563] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    4.964566] ILI
[    4.964567] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    4.964569] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 1e 00 0=
0 02 00
[    4.964574] end_request: I/O error, dev sr0, sector 120
[    4.967565] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    4.967567] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    4.967569] ILI
[    4.967570] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    4.967572] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 1e 00 0=
0 02 00
[    4.967577] end_request: I/O error, dev sr0, sector 120
[    4.970568] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    4.970571] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    4.970573] ILI
[    4.970574] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    4.970576] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    4.970581] end_request: I/O error, dev sr0, sector 0
[    4.973634] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    4.973636] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    4.973641] ILI
[    4.973642] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    4.973644] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    4.973649] end_request: I/O error, dev sr0, sector 0
[    4.976641] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    4.976643] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    4.976646] ILI
[    4.976646] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    4.976648] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 02 00 0=
0 02 00
[    4.976653] end_request: I/O error, dev sr0, sector 8
[    4.979647] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    4.979649] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    4.979651] ILI
[    4.979652] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    4.979654] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 02 00 0=
0 02 00
[    4.979659] end_request: I/O error, dev sr0, sector 8
[    4.982698] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    4.982701] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    4.982703] ILI
[    4.982704] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    4.982706] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 06 00 0=
0 02 00
[    4.982711] end_request: I/O error, dev sr0, sector 24
[    4.985705] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    4.985708] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    4.985710] ILI
[    4.985711] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    4.985713] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 06 00 0=
0 02 00
[    4.985718] end_request: I/O error, dev sr0, sector 24
[    4.988745] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    4.988747] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    4.988749] ILI
[    4.988750] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    4.988752] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 0e 00 0=
0 02 00
[    4.988758] end_request: I/O error, dev sr0, sector 56
[    4.991748] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    4.991750] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    4.991753] ILI
[    4.991754] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    4.991756] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 0e 00 0=
0 02 00
[    4.991761] end_request: I/O error, dev sr0, sector 56
[    4.994817] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    4.994820] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    4.994822] ILI
[    4.994823] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    4.994825] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 1e 00 0=
0 02 00
[    4.994830] end_request: I/O error, dev sr0, sector 120
[    4.997824] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    4.997826] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    4.997829] ILI
[    4.997829] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    4.997831] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 1e 00 0=
0 02 00
[    4.997837] end_request: I/O error, dev sr0, sector 120
[    5.001992] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.001994] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.001997] ILI
[    5.001998] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.002000] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    5.002005] end_request: I/O error, dev sr0, sector 0
[    5.005620] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.005625] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.005627] ILI
[    5.005628] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.005630] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    5.005635] end_request: I/O error, dev sr0, sector 0
[    5.008622] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.008625] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.008627] ILI
[    5.008628] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.008630] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    5.008635] end_request: I/O error, dev sr0, sector 0
[    5.011628] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.011631] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.011633] ILI
[    5.011634] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.011636] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    5.011641] end_request: I/O error, dev sr0, sector 0
[    5.014701] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.014703] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.014706] ILI
[    5.014707] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.014709] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    5.014714] end_request: I/O error, dev sr0, sector 0
[    5.017698] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.017700] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.017703] ILI
[    5.017703] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.017705] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    5.017710] end_request: I/O error, dev sr0, sector 0
[    5.020706] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.020709] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.020711] ILI
[    5.020712] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.020714] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 04 00 0=
0 02 00
[    5.020719] end_request: I/O error, dev sr0, sector 16
[    5.021991] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    5.023938] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.023945] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.023950] ILI
[    5.023952] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.023957] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 20 00 0=
0 02 00
[    5.023969] end_request: I/O error, dev sr0, sector 128
[    5.026940] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.026947] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.026952] ILI
[    5.026954] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.026959] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 20 00 0=
0 02 00
[    5.026970] end_request: I/O error, dev sr0, sector 128
[    5.029953] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.029960] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.029968] ILI
[    5.029971] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.029977] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 20 00 0=
0 02 00
[    5.029994] end_request: I/O error, dev sr0, sector 128
[    5.032962] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.032968] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.032972] ILI
[    5.032974] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.032979] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 04 00 0=
0 02 00
[    5.032990] end_request: I/O error, dev sr0, sector 16
[    5.035972] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.035979] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.035986] ILI
[    5.035989] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.035996] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 20 00 0=
0 02 00
[    5.036012] end_request: I/O error, dev sr0, sector 128
[    5.038989] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.038997] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.039004] ILI
[    5.039007] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.039013] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 10 00 0=
0 02 00
[    5.039029] end_request: I/O error, dev sr0, sector 64
[    5.042001] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.042009] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.042015] ILI
[    5.042018] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.042024] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 10 00 0=
0 02 00
[    5.042038] end_request: I/O error, dev sr0, sector 64
[    5.045072] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.045078] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.045084] ILI
[    5.045087] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.045092] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 10 00 0=
0 02 00
[    5.045106] end_request: I/O error, dev sr0, sector 64
[    5.048142] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.048149] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.048154] ILI
[    5.048156] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.048161] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 10 00 0=
0 02 00
[    5.048172] end_request: I/O error, dev sr0, sector 64
[    5.051136] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.051143] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.051148] ILI
[    5.051150] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.051155] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 10 00 0=
0 02 00
[    5.051166] end_request: I/O error, dev sr0, sector 64
[    5.054188] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.054193] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.054198] ILI
[    5.054200] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.054204] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 10 00 0=
0 02 00
[    5.054215] end_request: I/O error, dev sr0, sector 64
[    5.057231] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.057236] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.057240] ILI
[    5.057242] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.057247] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 10 00 0=
0 02 00
[    5.057257] end_request: I/O error, dev sr0, sector 64
[    5.060269] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.060275] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.060281] ILI
[    5.060283] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.060288] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 10 00 0=
0 02 00
[    5.060299] end_request: I/O error, dev sr0, sector 64
[    5.063296] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.063301] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.063306] ILI
[    5.063308] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.063313] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 10 00 0=
0 02 00
[    5.063323] end_request: I/O error, dev sr0, sector 64
[    5.066377] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.066384] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.066389] ILI
[    5.066392] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.066396] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 10 00 0=
0 02 00
[    5.066408] end_request: I/O error, dev sr0, sector 64
[    5.074819] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.074824] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.074828] ILI
[    5.074830] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.074834] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 40 00 0=
0 02 00
[    5.074843] end_request: I/O error, dev sr0, sector 256
[    5.077834] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.077839] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.077843] ILI
[    5.077845] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.077849] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 40 00 0=
0 02 00
[    5.077858] end_request: I/O error, dev sr0, sector 256
[    5.080875] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.080881] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.080885] ILI
[    5.080887] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.080891] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 42 00 0=
0 02 00
[    5.080900] end_request: I/O error, dev sr0, sector 264
[    5.083929] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.083935] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.083939] ILI
[    5.083941] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.083945] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 42 00 0=
0 02 00
[    5.083954] end_request: I/O error, dev sr0, sector 264
[    5.086967] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.086974] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.086979] ILI
[    5.086982] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.086986] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 44 00 0=
0 02 00
[    5.086997] end_request: I/O error, dev sr0, sector 272
[    5.090006] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.090012] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.090016] ILI
[    5.090018] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.090022] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 44 00 0=
0 02 00
[    5.090031] end_request: I/O error, dev sr0, sector 272
[    5.093063] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.093068] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.093073] ILI
[    5.093074] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.093079] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 c0 00 0=
0 02 00
[    5.093090] end_request: I/O error, dev sr0, sector 768
[    5.096037] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.096042] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.096046] ILI
[    5.096048] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.096052] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 c0 00 0=
0 02 00
[    5.096063] end_request: I/O error, dev sr0, sector 768
[    5.099103] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.099109] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.099115] ILI
[    5.099117] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.099122] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 c2 00 0=
0 02 00
[    5.099133] end_request: I/O error, dev sr0, sector 776
[    5.102142] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.102148] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.102152] ILI
[    5.102154] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.102158] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 c2 00 0=
0 02 00
[    5.102167] end_request: I/O error, dev sr0, sector 776
[    5.105141] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.105146] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.105151] ILI
[    5.105153] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.105157] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 c4 00 0=
0 02 00
[    5.105177] end_request: I/O error, dev sr0, sector 784
[    5.108129] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.108135] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.108140] ILI
[    5.108142] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.108146] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 c4 00 0=
0 02 00
[    5.108157] end_request: I/O error, dev sr0, sector 784
[    5.111136] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.111142] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.111147] ILI
[    5.111150] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.111154] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    5.111165] end_request: I/O error, dev sr0, sector 0
[    5.114199] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.114204] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.114208] ILI
[    5.114210] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.114215] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    5.114225] end_request: I/O error, dev sr0, sector 0
[    5.117302] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.117307] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.117312] ILI
[    5.117314] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.117318] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    5.117327] end_request: I/O error, dev sr0, sector 0
[    5.120254] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.120260] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.120266] ILI
[    5.120268] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.120272] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    5.120284] end_request: I/O error, dev sr0, sector 0
[    5.123423] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.123429] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.123433] ILI
[    5.123435] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.123439] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    5.123448] end_request: I/O error, dev sr0, sector 0
[    5.126415] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.126420] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.126425] ILI
[    5.126427] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.126430] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 04 00 0=
0 02 00
[    5.126440] end_request: I/O error, dev sr0, sector 16
[    5.129444] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.129451] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.129456] ILI
[    5.129459] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.129463] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    5.129474] end_request: I/O error, dev sr0, sector 0
[    5.132580] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.132586] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.132590] ILI
[    5.132592] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.132596] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    5.132605] end_request: I/O error, dev sr0, sector 0
[    5.135534] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.135539] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.135544] ILI
[    5.135546] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.135549] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    5.135559] end_request: I/O error, dev sr0, sector 0
[    5.138600] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.138606] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.138610] ILI
[    5.138612] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.138616] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    5.138625] end_request: I/O error, dev sr0, sector 0
[    5.141627] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.141633] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.141637] ILI
[    5.141639] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.141643] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    5.141652] end_request: I/O error, dev sr0, sector 0
[    5.144828] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.144833] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.144838] ILI
[    5.144839] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.144843] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    5.144852] end_request: I/O error, dev sr0, sector 0
[    5.147859] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.147865] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.147869] ILI
[    5.147871] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.147875] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    5.147884] end_request: I/O error, dev sr0, sector 0
[    5.150903] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.150908] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.150913] ILI
[    5.150915] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.150918] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    5.150928] end_request: I/O error, dev sr0, sector 0
[    5.159354] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.159359] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.159364] ILI
[    5.159366] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.159370] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    5.159379] end_request: I/O error, dev sr0, sector 0
[    5.162328] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.162335] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.162340] ILI
[    5.162342] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.162347] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    5.162358] end_request: I/O error, dev sr0, sector 0
[    5.165328] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.165333] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.165338] ILI
[    5.165340] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.165344] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    5.165355] end_request: I/O error, dev sr0, sector 0
[    5.168392] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.168397] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.168402] ILI
[    5.168404] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.168408] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    5.168419] end_request: I/O error, dev sr0, sector 0
[    5.171482] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.171487] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.171492] ILI
[    5.171494] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.171497] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 20 00 0=
0 02 00
[    5.171507] end_request: I/O error, dev sr0, sector 128
[    5.174504] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.174510] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.174514] ILI
[    5.174516] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.174520] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 20 00 0=
0 02 00
[    5.174529] end_request: I/O error, dev sr0, sector 128
[    5.177592] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.177598] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.177602] ILI
[    5.177604] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.177608] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 04 00 0=
0 02 00
[    5.177617] end_request: I/O error, dev sr0, sector 16
[    5.180617] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.180623] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.180627] ILI
[    5.180629] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.180633] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    5.180642] end_request: I/O error, dev sr0, sector 0
[    5.183638] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.183644] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.183648] ILI
[    5.183650] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.183654] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    5.183663] end_request: I/O error, dev sr0, sector 0
[    5.186687] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.186692] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.186696] ILI
[    5.186698] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.186702] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 02 00 0=
0 02 00
[    5.186711] end_request: I/O error, dev sr0, sector 8
[    5.189709] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.189714] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.189719] ILI
[    5.189720] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.189724] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 04 00 0=
0 02 00
[    5.189734] end_request: I/O error, dev sr0, sector 16
[    5.192730] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.192774] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.192779] ILI
[    5.192781] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.192786] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    5.192795] end_request: I/O error, dev sr0, sector 0
[    5.195793] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.195798] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.195803] ILI
[    5.195805] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.195809] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    5.195818] end_request: I/O error, dev sr0, sector 0
[    5.198819] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.198827] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.198833] ILI
[    5.198836] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.198841] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    5.198855] end_request: I/O error, dev sr0, sector 0
[    5.201815] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.201818] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.201820] ILI
[    5.201821] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.201823] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    5.201828] end_request: I/O error, dev sr0, sector 0
[    5.204855] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.204859] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.204862] ILI
[    5.204864] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.204867] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    5.204874] end_request: I/O error, dev sr0, sector 0
[    5.206679] usbcore: registered new interface driver usbfs
[    5.206693] usbcore: registered new interface driver hub
[    5.206761] usbcore: registered new device driver usb
[    5.207929] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.207933] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.207937] ILI
[    5.207938] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.207941] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    5.207949] end_request: I/O error, dev sr0, sector 0
[    5.210932] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.210935] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.210938] ILI
[    5.210939] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.210941] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 02 00 0=
0 02 00
[    5.210946] end_request: I/O error, dev sr0, sector 8
[    5.210995] e1000e: Intel(R) PRO/1000 Network Driver - 1.0.2-k2
[    5.210998] e1000e: Copyright (c) 1999 - 2009 Intel Corporation.
[    5.211049] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ=
 20
[    5.211059] e1000e 0000:00:19.0: setting latency timer to 64
[    5.211195] e1000e 0000:00:19.0: irq 28 for MSI/MSI-X
[    5.213940] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.213943] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.213946] ILI
[    5.213947] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.213950] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 20 00 0=
0 02 00
[    5.213956] end_request: I/O error, dev sr0, sector 128
[    5.217006] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.217010] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.217014] ILI
[    5.217015] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.217018] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    5.217025] end_request: I/O error, dev sr0, sector 0
[    5.220023] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.220028] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.220034] ILI
[    5.220036] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.220040] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    5.220052] end_request: I/O error, dev sr0, sector 0
[    5.222830] input: PC Speaker as /devices/platform/pcspkr/input/input5
[    5.223018] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.223021] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.223024] ILI
[    5.223026] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.223028] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 04 00 00 0=
0 02 00
[    5.223035] end_request: I/O error, dev sr0, sector 4096
[    5.227372] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    5.231518] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    5.419889] thinkpad_acpi: ThinkPad ACPI Extras v0.24
[    5.419892] thinkpad_acpi: http://ibm-acpi.sf.net/
[    5.419893] thinkpad_acpi: ThinkPad BIOS 6QET35WW (1.05 ), EC 6QHT24WW-1=
=2E05
[    5.419896] thinkpad_acpi: Lenovo ThinkPad X201, model 3626A14
[    5.420222] thinkpad_acpi: radio switch found; radios are enabled
[    5.420441] thinkpad_acpi: possible tablet mode switch found; ThinkPad i=
n laptop mode
[    5.420675] thinkpad_acpi: This ThinkPad has standard ACPI backlight bri=
ghtness control, supported by the ACPI video driver
[    5.420677] thinkpad_acpi: Disabling thinkpad-acpi brightness events by =
default...
[    5.424768] thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio is u=
nblocked
[    5.425811] Registered led device: tpacpi::thinklight
[    5.425834] Registered led device: tpacpi::power
[    5.425847] Registered led device: tpacpi:orange:batt
[    5.425862] Registered led device: tpacpi:green:batt
[    5.425877] Registered led device: tpacpi::dock_active
[    5.426045] Registered led device: tpacpi::bay_active
[    5.426058] Registered led device: tpacpi::dock_batt
[    5.426071] Registered led device: tpacpi::unknown_led
[    5.426085] Registered led device: tpacpi::standby
[    5.426148] Registered led device: tpacpi::dock_status1
[    5.426164] Registered led device: tpacpi::dock_status2
[    5.426178] Registered led device: tpacpi::unknown_led2
[    5.426338] Registered led device: tpacpi::unknown_led3
[    5.426355] Registered led device: tpacpi::thinkvantage
[    5.426357] thinkpad_acpi: warning: userspace override of important firm=
ware LEDs is enabled
[    5.428552] thinkpad_acpi: Standard ACPI backlight interface available, =
not loading native one.
[    5.428818] thinkpad_acpi: Console audio control enabled, mode: monitor =
(read only)
[    5.432358] input: ThinkPad Extra Buttons as /devices/platform/thinkpad_=
acpi/input/input6
[    5.571315] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, in=
-tree:
[    5.571317] iwlagn: Copyright(c) 2003-2010 Intel Corporation
[    5.571422] iwlagn 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ=
 16
[    5.571458] iwlagn 0000:02:00.0: setting latency timer to 64
[    5.571560] iwlagn 0000:02:00.0: Detected Intel Wireless WiFi Link 6000 =
Series 3x3 AGN REV=3D0x74
[    5.588302] iwlagn 0000:02:00.0: Tunable channels: 13 802.11bg, 24 802.1=
1a channels
[    5.588465] iwlagn 0000:02:00.0: irq 29 for MSI/MSI-X
[    5.588770] iwlagn 0000:02:00.0: firmware: requesting iwlwifi-6000-4.uco=
de
[    5.636948] iwlagn 0000:02:00.0: loaded firmware version 9.176.4.1
[    5.641762] 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:26:2d:=
f7:02:12
[    5.641764] 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    5.641832] 0000:00:19.0: eth0: MAC: 9, PHY: 10, PBA No: a002ff-0ff
[    5.641973] serial 0000:00:16.3: PCI INT B -> GSI 17 (level, low) -> IRQ=
 17
[    5.642208] 0000:00:16.3: ttyS0 at I/O 0x1808 (irq =3D 17) is a 16550A
[    5.642697] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[    5.642867] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[    5.642875] ehci_hcd 0000:00:1a.0: PCI INT D -> GSI 23 (level, low) -> I=
RQ 23
[    5.642916] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[    5.642919] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[    5.642925] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus =
number 1
[    5.642958] ehci_hcd 0000:00:1a.0: debug port 2
[    5.646857] ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
[    5.646883] ehci_hcd 0000:00:1a.0: irq 23, io mem 0xf2728000
[    5.657233] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    5.657386] hub 1-0:1.0: USB hub found
[    5.657391] hub 1-0:1.0: 3 ports detected
[    5.657474] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> =
IRQ 17
[    5.657529] HDA Intel 0000:00:1b.0: irq 30 for MSI/MSI-X
[    5.657558] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    5.714880] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.714889] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.714898] ILI
[    5.714901] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.714908] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    5.714925] end_request: I/O error, dev sr0, sector 0
[    5.717895] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.717903] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.717910] ILI
[    5.717912] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.717918] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    5.717933] end_request: I/O error, dev sr0, sector 0
[    5.721006] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.721012] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.721017] ILI
[    5.721020] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.721024] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    5.721036] end_request: I/O error, dev sr0, sector 0
[    5.806525] i801_smbus 0000:00:1f.3: PCI INT A -> GSI 23 (level, low) ->=
 IRQ 23
[    5.807094] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    5.807426] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    5.807447] ehci_hcd 0000:00:1d.0: PCI INT D -> GSI 19 (level, low) -> I=
RQ 19
[    5.807505] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[    5.807511] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[    5.807523] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus =
number 2
[    5.807568] ehci_hcd 0000:00:1d.0: debug port 2
[    5.811468] ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
[    5.811498] ehci_hcd 0000:00:1d.0: irq 19, io mem 0xf2728400
[    5.821202] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    5.821350] hub 2-0:1.0: USB hub found
[    5.821359] hub 2-0:1.0: 3 ports detected
[    5.867782] phy0: Selected rate control algorithm 'iwl-agn-rs'
[    5.948019] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.948025] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.948030] ILI
[    5.948032] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.948037] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    5.948046] end_request: I/O error, dev sr0, sector 0
[    5.951042] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.951048] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.951052] ILI
[    5.951054] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.951058] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    5.951067] end_request: I/O error, dev sr0, sector 0
[    5.954080] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.954086] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.954090] ILI
[    5.954092] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.954096] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    5.954105] end_request: I/O error, dev sr0, sector 0
[    5.957230] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.957235] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.957240] ILI
[    5.957241] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.957245] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    5.957254] end_request: I/O error, dev sr0, sector 0
[    5.958812] usb 1-1: new high speed USB device using ehci_hcd and addres=
s 2
[    5.960188] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.960192] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.960197] ILI
[    5.960198] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.960202] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    5.960211] end_request: I/O error, dev sr0, sector 0
[    5.963221] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.963226] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.963231] ILI
[    5.963233] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.963237] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    5.963248] end_request: I/O error, dev sr0, sector 0
[    5.966313] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.966320] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.966325] ILI
[    5.966328] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.966332] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    5.966343] end_request: I/O error, dev sr0, sector 0
[    5.969274] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.969280] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.969285] ILI
[    5.969287] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.969291] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    5.969302] end_request: I/O error, dev sr0, sector 0
[    5.972328] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.972333] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.972338] ILI
[    5.972340] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.972344] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    5.972355] end_request: I/O error, dev sr0, sector 0
[    5.975401] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.975406] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.975411] ILI
[    5.975412] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.975417] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    5.975428] end_request: I/O error, dev sr0, sector 0
[    5.978430] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.978437] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.978442] ILI
[    5.978444] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.978449] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 0e 00 0=
0 02 00
[    5.978460] end_request: I/O error, dev sr0, sector 56
[    5.981445] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.981452] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.981459] ILI
[    5.981461] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.981467] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    5.981481] end_request: I/O error, dev sr0, sector 0
[    5.984501] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.984506] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.984511] ILI
[    5.984513] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.984517] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    5.984526] end_request: I/O error, dev sr0, sector 0
[    5.987564] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.987572] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.987579] ILI
[    5.987582] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.987588] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    5.987603] end_request: I/O error, dev sr0, sector 0
[    5.990544] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.990550] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.990555] ILI
[    5.990557] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.990562] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    5.990573] end_request: I/O error, dev sr0, sector 0
[    5.993609] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.993616] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.993621] ILI
[    5.993624] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.993628] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    5.993639] end_request: I/O error, dev sr0, sector 0
[    5.996645] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.996651] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.996657] ILI
[    5.996659] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.996663] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    5.996675] end_request: I/O error, dev sr0, sector 0
[    5.999641] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    5.999646] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    5.999651] ILI
[    5.999653] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    5.999657] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    5.999668] end_request: I/O error, dev sr0, sector 0
[    6.002660] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.002665] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.002670] ILI
[    6.002672] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.002677] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    6.002688] end_request: I/O error, dev sr0, sector 0
[    6.005691] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.005696] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.005700] ILI
[    6.005702] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.005707] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    6.005717] end_request: I/O error, dev sr0, sector 0
[    6.008704] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.008709] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.008714] ILI
[    6.008716] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.008720] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    6.008731] end_request: I/O error, dev sr0, sector 0
[    6.011729] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.011734] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.011739] ILI
[    6.011741] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.011748] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    6.011761] end_request: I/O error, dev sr0, sector 0
[    6.014776] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.014782] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.014788] ILI
[    6.014790] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.014795] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    6.014806] end_request: I/O error, dev sr0, sector 0
[    6.017798] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.017804] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.017809] ILI
[    6.017811] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.017816] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    6.017827] end_request: I/O error, dev sr0, sector 0
[    6.020872] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.020878] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.020884] ILI
[    6.020886] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.020890] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    6.020902] end_request: I/O error, dev sr0, sector 0
[    6.023860] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.023866] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.023871] ILI
[    6.023873] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.023878] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    6.023889] end_request: I/O error, dev sr0, sector 0
[    6.026937] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.026943] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.026947] ILI
[    6.026949] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.026954] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    6.026965] end_request: I/O error, dev sr0, sector 0
[    6.029908] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.029913] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.029946] ILI
[    6.029949] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.029954] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 02 00 0=
0 02 00
[    6.029970] end_request: I/O error, dev sr0, sector 8
[    6.032921] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.032927] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.032932] ILI
[    6.032934] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.032938] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 02 00 0=
0 02 00
[    6.032949] end_request: I/O error, dev sr0, sector 8
[    6.035984] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.035990] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.035994] ILI
[    6.035996] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.036001] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 02 00 0=
0 02 00
[    6.036011] end_request: I/O error, dev sr0, sector 8
[    6.038995] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.039000] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.039005] ILI
[    6.039007] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.039012] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 02 00 0=
0 02 00
[    6.039022] end_request: I/O error, dev sr0, sector 8
[    6.042003] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.042010] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.042015] ILI
[    6.042018] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.042023] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 06 00 0=
0 02 00
[    6.042035] end_request: I/O error, dev sr0, sector 24
[    6.045010] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.045015] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.045020] ILI
[    6.045022] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.045027] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 06 00 0=
0 02 00
[    6.045038] end_request: I/O error, dev sr0, sector 24
[    6.048074] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.048080] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.048084] ILI
[    6.048086] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.048091] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 06 00 0=
0 02 00
[    6.048101] end_request: I/O error, dev sr0, sector 24
[    6.051083] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.051089] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.051095] ILI
[    6.051097] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.051102] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 06 00 0=
0 02 00
[    6.051116] end_request: I/O error, dev sr0, sector 24
[    6.054086] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.054092] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.054096] ILI
[    6.054098] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.054103] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 0e 00 0=
0 02 00
[    6.054113] end_request: I/O error, dev sr0, sector 56
[    6.057154] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.057159] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.057164] ILI
[    6.057166] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.057170] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 0e 00 0=
0 02 00
[    6.057181] end_request: I/O error, dev sr0, sector 56
[    6.060227] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.060234] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.060239] ILI
[    6.060241] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.060246] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 0e 00 0=
0 02 00
[    6.060257] end_request: I/O error, dev sr0, sector 56
[    6.063252] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.063258] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.063264] ILI
[    6.063266] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.063270] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 0e 00 0=
0 02 00
[    6.063282] end_request: I/O error, dev sr0, sector 56
[    6.066348] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.066354] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.066358] ILI
[    6.066360] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.066364] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 1e 00 0=
0 02 00
[    6.066373] end_request: I/O error, dev sr0, sector 120
[    6.069316] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.069324] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.069332] ILI
[    6.069334] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.069341] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 1e 00 0=
0 02 00
[    6.069357] end_request: I/O error, dev sr0, sector 120
[    6.072319] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.072325] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.072330] ILI
[    6.072333] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.072337] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 1e 00 0=
0 02 00
[    6.072349] end_request: I/O error, dev sr0, sector 120
[    6.073523] hub 1-1:1.0: USB hub found
[    6.073694] hub 1-1:1.0: 6 ports detected
[    6.075332] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.075340] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.075347] ILI
[    6.075350] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.075356] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 1e 00 0=
0 02 00
[    6.075371] end_request: I/O error, dev sr0, sector 120
[    6.078347] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.078356] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.078362] ILI
[    6.078365] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.078371] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    6.078386] end_request: I/O error, dev sr0, sector 0
[    6.081357] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.081365] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.081370] ILI
[    6.081373] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.081377] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    6.081389] end_request: I/O error, dev sr0, sector 0
[    6.084365] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.084370] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.084375] ILI
[    6.084377] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.084381] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 02 00 0=
0 02 00
[    6.084392] end_request: I/O error, dev sr0, sector 8
[    6.087458] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.087464] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.087470] ILI
[    6.087472] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.087477] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 02 00 0=
0 02 00
[    6.087488] end_request: I/O error, dev sr0, sector 8
[    6.090449] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.090454] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.090459] ILI
[    6.090461] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.090465] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 06 00 0=
0 02 00
[    6.090476] end_request: I/O error, dev sr0, sector 24
[    6.093455] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.093460] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.093465] ILI
[    6.093467] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.093471] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 06 00 0=
0 02 00
[    6.093490] end_request: I/O error, dev sr0, sector 24
[    6.096566] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.096571] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.096576] ILI
[    6.096578] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.096582] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 0e 00 0=
0 02 00
[    6.096593] end_request: I/O error, dev sr0, sector 56
[    6.099631] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.099637] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.099641] ILI
[    6.099643] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.099647] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 0e 00 0=
0 02 00
[    6.099656] end_request: I/O error, dev sr0, sector 56
[    6.102638] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.102644] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.102648] ILI
[    6.102650] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.102654] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 1e 00 0=
0 02 00
[    6.102663] end_request: I/O error, dev sr0, sector 120
[    6.105659] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.105665] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.105669] ILI
[    6.105671] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.105675] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 1e 00 0=
0 02 00
[    6.105684] end_request: I/O error, dev sr0, sector 120
[    6.108667] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.108673] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.108677] ILI
[    6.108679] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.108683] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    6.108692] end_request: I/O error, dev sr0, sector 0
[    6.111713] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.111718] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.111723] ILI
[    6.111725] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.111729] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    6.111738] end_request: I/O error, dev sr0, sector 0
[    6.114737] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.114742] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.114746] ILI
[    6.114748] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.114752] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    6.114761] end_request: I/O error, dev sr0, sector 0
[    6.117757] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.117763] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.117767] ILI
[    6.117769] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.117773] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    6.117782] end_request: I/O error, dev sr0, sector 0
[    6.120811] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.120819] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.120825] ILI
[    6.120828] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.120832] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    6.120843] end_request: I/O error, dev sr0, sector 0
[    6.123859] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.123866] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.123871] ILI
[    6.123873] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.123878] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    6.123889] end_request: I/O error, dev sr0, sector 0
[    6.126971] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.126976] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.126980] ILI
[    6.126982] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.126986] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 04 00 0=
0 02 00
[    6.126995] end_request: I/O error, dev sr0, sector 16
[    6.135457] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.135462] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.135467] ILI
[    6.135469] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.135472] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 20 00 0=
0 02 00
[    6.135482] end_request: I/O error, dev sr0, sector 128
[    6.138454] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.138459] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.138464] ILI
[    6.138466] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.138469] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 20 00 0=
0 02 00
[    6.138479] end_request: I/O error, dev sr0, sector 128
[    6.141494] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.141500] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.141504] ILI
[    6.141506] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.141510] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 20 00 0=
0 02 00
[    6.141519] end_request: I/O error, dev sr0, sector 128
[    6.144578] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.144583] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.144587] ILI
[    6.144589] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.144593] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 04 00 0=
0 02 00
[    6.144602] end_request: I/O error, dev sr0, sector 16
[    6.147610] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.147615] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.147620] ILI
[    6.147621] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.147625] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 20 00 0=
0 02 00
[    6.147645] end_request: I/O error, dev sr0, sector 128
[    6.150641] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.150647] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.150651] ILI
[    6.150653] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.150657] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 10 00 0=
0 02 00
[    6.150666] end_request: I/O error, dev sr0, sector 64
[    6.153721] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.153726] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.153731] ILI
[    6.153733] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.153737] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 10 00 0=
0 02 00
[    6.153746] end_request: I/O error, dev sr0, sector 64
[    6.156686] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.156692] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.156696] ILI
[    6.156698] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.156702] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 10 00 0=
0 02 00
[    6.156711] end_request: I/O error, dev sr0, sector 64
[    6.159786] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.159791] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.159796] ILI
[    6.159798] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.159801] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 10 00 0=
0 02 00
[    6.159811] end_request: I/O error, dev sr0, sector 64
[    6.162775] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.162780] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.162785] ILI
[    6.162787] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.162791] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 10 00 0=
0 02 00
[    6.162802] end_request: I/O error, dev sr0, sector 64
[    6.165809] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.165816] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.165821] ILI
[    6.165823] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.165828] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 10 00 0=
0 02 00
[    6.165839] end_request: I/O error, dev sr0, sector 64
[    6.168777] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.168783] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.168788] ILI
[    6.168790] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.168794] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 10 00 0=
0 02 00
[    6.168805] end_request: I/O error, dev sr0, sector 64
[    6.171822] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.171828] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.171833] ILI
[    6.171835] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.171839] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 10 00 0=
0 02 00
[    6.171850] end_request: I/O error, dev sr0, sector 64
[    6.174878] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.174886] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.174892] ILI
[    6.174895] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.174899] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 10 00 0=
0 02 00
[    6.174911] end_request: I/O error, dev sr0, sector 64
[    6.176451] usb 2-1: new high speed USB device using ehci_hcd and addres=
s 2
[    6.177976] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.177982] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.177988] ILI
[    6.177990] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.177995] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 10 00 0=
0 02 00
[    6.178006] end_request: I/O error, dev sr0, sector 64
[    6.180988] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.180993] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.180998] ILI
[    6.180999] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.181003] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 40 00 0=
0 02 00
[    6.181013] end_request: I/O error, dev sr0, sector 256
[    6.184069] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.184074] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.184079] ILI
[    6.184081] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.184085] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 40 00 0=
0 02 00
[    6.184094] end_request: I/O error, dev sr0, sector 256
[    6.187094] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.187099] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.187103] ILI
[    6.187105] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.187109] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 42 00 0=
0 02 00
[    6.187118] end_request: I/O error, dev sr0, sector 264
[    6.190130] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.190136] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.190140] ILI
[    6.190142] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.190146] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 42 00 0=
0 02 00
[    6.190155] end_request: I/O error, dev sr0, sector 264
[    6.193221] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.193227] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.193231] ILI
[    6.193233] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.193237] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 44 00 0=
0 02 00
[    6.193246] end_request: I/O error, dev sr0, sector 272
[    6.196243] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.196250] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.196255] ILI
[    6.196257] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.196262] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 44 00 0=
0 02 00
[    6.196273] end_request: I/O error, dev sr0, sector 272
[    6.199222] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.199224] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.199227] ILI
[    6.199227] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.199229] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 c0 00 0=
0 02 00
[    6.199234] end_request: I/O error, dev sr0, sector 768
[    6.202222] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.202227] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.202230] ILI
[    6.202232] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.202234] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 c0 00 0=
0 02 00
[    6.202241] end_request: I/O error, dev sr0, sector 768
[    6.205402] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.205405] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.205407] ILI
[    6.205408] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.205411] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 c2 00 0=
0 02 00
[    6.205417] end_request: I/O error, dev sr0, sector 776
[    6.208413] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.208420] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.208427] ILI
[    6.208429] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.208434] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 c2 00 0=
0 02 00
[    6.208445] end_request: I/O error, dev sr0, sector 776
[    6.211423] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.211428] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.211433] ILI
[    6.211435] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.211439] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 c4 00 0=
0 02 00
[    6.211450] end_request: I/O error, dev sr0, sector 784
[    6.214491] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.214496] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.214501] ILI
[    6.214503] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.214507] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 c4 00 0=
0 02 00
[    6.214518] end_request: I/O error, dev sr0, sector 784
[    6.217560] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.217570] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.217574] ILI
[    6.217576] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.217580] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    6.217589] end_request: I/O error, dev sr0, sector 0
[    6.220579] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.220586] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.220591] ILI
[    6.220593] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.220598] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    6.220609] end_request: I/O error, dev sr0, sector 0
[    6.229101] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.229106] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.229111] ILI
[    6.229112] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.229116] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    6.229125] end_request: I/O error, dev sr0, sector 0
[    6.232109] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.232115] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.232119] ILI
[    6.232121] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.232125] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    6.232134] end_request: I/O error, dev sr0, sector 0
[    6.235168] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.235174] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.235178] ILI
[    6.235180] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.235184] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    6.235193] end_request: I/O error, dev sr0, sector 0
[    6.238248] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.238254] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.238258] ILI
[    6.238260] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.238264] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 04 00 0=
0 02 00
[    6.238273] end_request: I/O error, dev sr0, sector 16
[    6.241287] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.241292] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.241297] ILI
[    6.241299] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.241302] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    6.241312] end_request: I/O error, dev sr0, sector 0
[    6.244324] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.244330] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.244334] ILI
[    6.244336] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.244340] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    6.244349] end_request: I/O error, dev sr0, sector 0
[    6.247425] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.247430] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.247435] ILI
[    6.247437] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.247440] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    6.247450] end_request: I/O error, dev sr0, sector 0
[    6.250475] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.250481] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.250485] ILI
[    6.250487] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.250491] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    6.250500] end_request: I/O error, dev sr0, sector 0
[    6.253494] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.253501] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.253506] ILI
[    6.253508] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.253513] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    6.253524] end_request: I/O error, dev sr0, sector 0
[    6.256564] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.256569] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.256574] ILI
[    6.256576] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.256579] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    6.256589] end_request: I/O error, dev sr0, sector 0
[    6.259603] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.259609] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.259613] ILI
[    6.259615] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.259619] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    6.259628] end_request: I/O error, dev sr0, sector 0
[    6.262604] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.262610] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.262614] ILI
[    6.262616] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.262620] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    6.262629] end_request: I/O error, dev sr0, sector 0
[    6.265646] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.265651] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.265656] ILI
[    6.265658] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.265661] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    6.265671] end_request: I/O error, dev sr0, sector 0
[    6.268667] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.268673] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.268678] ILI
[    6.268680] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.268684] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    6.268695] end_request: I/O error, dev sr0, sector 0
[    6.271677] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.271682] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.271687] ILI
[    6.271689] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.271693] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    6.271704] end_request: I/O error, dev sr0, sector 0
[    6.274691] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.274698] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.274703] ILI
[    6.274705] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.274710] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    6.274721] end_request: I/O error, dev sr0, sector 0
[    6.277762] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.277769] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.277774] ILI
[    6.277776] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.277781] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 20 00 0=
0 02 00
[    6.277792] end_request: I/O error, dev sr0, sector 128
[    6.280758] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.280763] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.280768] ILI
[    6.280770] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.280774] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 20 00 0=
0 02 00
[    6.280785] end_request: I/O error, dev sr0, sector 128
[    6.283767] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.283774] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.283780] ILI
[    6.283783] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.283788] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 04 00 0=
0 02 00
[    6.283803] end_request: I/O error, dev sr0, sector 16
[    6.286848] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.286857] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.286864] ILI
[    6.286867] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.286873] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    6.286888] end_request: I/O error, dev sr0, sector 0
[    6.289858] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.289864] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.289870] ILI
[    6.289872] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.289877] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    6.289888] end_request: I/O error, dev sr0, sector 0
[    6.291882] hub 2-1:1.0: USB hub found
[    6.291944] hub 2-1:1.0: 8 ports detected
[    6.292859] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.292864] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.292869] ILI
[    6.292871] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.292876] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 02 00 0=
0 02 00
[    6.292887] end_request: I/O error, dev sr0, sector 8
[    6.295871] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.295879] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.295885] ILI
[    6.295888] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.295894] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 04 00 0=
0 02 00
[    6.295908] end_request: I/O error, dev sr0, sector 16
[    6.299044] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.299049] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.299054] ILI
[    6.299056] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.299060] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    6.299071] end_request: I/O error, dev sr0, sector 0
[    6.302129] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.302135] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.302141] ILI
[    6.302143] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.302147] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    6.302159] end_request: I/O error, dev sr0, sector 0
[    6.305130] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.305135] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.305140] ILI
[    6.305142] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.305147] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    6.305157] end_request: I/O error, dev sr0, sector 0
[    6.308163] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.308169] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.308175] ILI
[    6.308177] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.308182] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    6.308193] end_request: I/O error, dev sr0, sector 0
[    6.311219] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.311225] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.311231] ILI
[    6.311234] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.311240] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    6.311255] end_request: I/O error, dev sr0, sector 0
[    6.314245] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.314253] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.314259] ILI
[    6.314262] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.314267] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    6.314281] end_request: I/O error, dev sr0, sector 0
[    6.317284] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.317291] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.317297] ILI
[    6.317299] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.317304] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 02 00 0=
0 02 00
[    6.317315] end_request: I/O error, dev sr0, sector 8
[    6.320295] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.320304] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.320311] ILI
[    6.320314] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.320320] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 20 00 0=
0 02 00
[    6.320336] end_request: I/O error, dev sr0, sector 128
[    6.323309] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.323317] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.323325] ILI
[    6.323328] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.323335] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    6.323352] end_request: I/O error, dev sr0, sector 0
[    6.326365] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.326371] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.326377] ILI
[    6.326379] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.326384] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    6.326395] end_request: I/O error, dev sr0, sector 0
[    6.329393] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.329399] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.329405] ILI
[    6.329407] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.329412] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 04 00 00 0=
0 02 00
[    6.329423] end_request: I/O error, dev sr0, sector 4096
[    6.355280] usb 1-1.3: new full speed USB device using ehci_hcd and addr=
ess 3
[    6.372217] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.372222] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.372227] ILI
[    6.372229] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.372233] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    6.372242] end_request: I/O error, dev sr0, sector 0
[    6.375264] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.375270] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.375274] ILI
[    6.375276] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.375280] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    6.375289] end_request: I/O error, dev sr0, sector 0
[    6.378250] sr 1:0:0:0: [sr0] Result: hostbyte=3D0x00 driverbyte=3D0x08
[    6.378256] sr 1:0:0:0: [sr0] Sense Key : 0x5 [current]=20
[    6.378260] ILI
[    6.378262] sr 1:0:0:0: [sr0] ASC=3D0x64 ASCQ=3D0x0
[    6.378266] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 0=
0 02 00
[    6.378275] end_request: I/O error, dev sr0, sector 0
[    6.507016] usb 1-1.4: new full speed USB device using ehci_hcd and addr=
ess 4
[    6.546836] device-mapper: ioctl: 4.17.0-ioctl (2010-03-05) initialised:=
 dm-devel@redhat.com
[    6.658726] usb 1-1.5: new high speed USB device using ehci_hcd and addr=
ess 5
[    6.659676] Bluetooth: Core ver 2.15
[    6.659739] NET: Registered protocol family 31
[    6.659740] Bluetooth: HCI device and connection manager initialized
[    6.659743] Bluetooth: HCI socket layer initialized
[    6.685525] Bluetooth: Generic Bluetooth USB driver ver 0.6
[    6.686210] usbcore: registered new interface driver btusb
[    6.744273] hub 1-1.5:1.0: USB hub found
[    6.744449] hub 1-1.5:1.0: 4 ports detected
[    6.818470] usb 1-1.6: new high speed USB device using ehci_hcd and addr=
ess 6
[    6.954659] Linux video capture interface: v2.00
[    6.966768] uvcvideo: Found UVC 1.00 device Integrated Camera (17ef:4816)
[    6.968380] input: Integrated Camera as /devices/pci0000:00/0000:00:1a.0=
/usb1/1-1/1-1.6/1-1.6:1.0/input/input7
[    6.968430] usbcore: registered new interface driver uvcvideo
[    6.968432] USB Video Class driver (v0.1.0)
[    6.984406] usb 2-1.1: new high speed USB device using ehci_hcd and addr=
ess 3
[    7.118982] usbcore: registered new interface driver libusual
[    7.128087] Initializing USB Mass Storage driver...
[    7.128267] scsi6 : usb-storage 2-1.1:1.0
[    7.128381] usbcore: registered new interface driver usb-storage
[    7.128384] USB Mass Storage support registered.
[    8.128740] scsi 6:0:0:0: Direct-Access     Generic- Multi-Card       1.=
00 PQ: 0 ANSI: 0 CCS
[    8.128984] sd 6:0:0:0: Attached scsi generic sg2 type 0
[    8.170205] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[    8.432732] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/seri=
o1/serio2/input/input8
[    8.868718] sd 6:0:0:0: [sdb] 1984000 512-byte logical blocks: (1.01 GB/=
968 MiB)
[    8.869758] sd 6:0:0:0: [sdb] Write Protect is off
[    8.869764] sd 6:0:0:0: [sdb] Mode Sense: 03 00 00 00
[    8.869768] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[    8.872542] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[    8.872550]  sdb: sdb1
[    8.901461] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[    8.901466] sd 6:0:0:0: [sdb] Attached SCSI removable disk
[   11.964704] usb 1-1.5.4: new high speed USB device using ehci_hcd and ad=
dress 7
[   12.052129] scsi7 : usb-storage 1-1.5.4:1.0
[   13.050402] scsi 7:0:0:0: Direct-Access     WD       5000BMV External 1.=
75 PQ: 0 ANSI: 4
[   13.050553] sd 7:0:0:0: Attached scsi generic sg3 type 0
[   13.051302] sd 7:0:0:0: [sdc] 976773168 512-byte logical blocks: (500 GB=
/465 GiB)
[   13.051793] sd 7:0:0:0: [sdc] Write Protect is off
[   13.051796] sd 7:0:0:0: [sdc] Mode Sense: 23 00 00 00
[   13.051798] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[   13.052935] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[   13.052938]  sdc: unknown partition table
[   13.082743] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[   13.082746] sd 7:0:0:0: [sdc] Attached SCSI disk
[   13.373419] padlock: VIA PadLock not detected.
[   13.716812] alg: No test for __cbc-aes-aesni (cryptd(__driver-cbc-aes-ae=
sni))
[   13.824048] padlock: VIA PadLock Hash Engine not detected.
[   14.919235] Adding 4000148k swap on /dev/mapper/swap.  Priority:-1 exten=
ts:1 across:4000148k=20
[   17.639036] e1000e 0000:00:19.0: irq 28 for MSI/MSI-X
[   17.689801] e1000e 0000:00:19.0: irq 28 for MSI/MSI-X
[   51.289948] NET: Registered protocol family 10
[   51.290250] lo: Disabled Privacy Extensions
[   51.290534] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   59.866078] [drm] Initialized drm 1.1.0 20060810
[   59.889554] i915 0000:00:02.0: power state changed by ACPI to D0
[   59.889669] i915 0000:00:02.0: power state changed by ACPI to D0
[   59.889676] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   59.889679] i915 0000:00:02.0: setting latency timer to 64
[   59.948400] i915 0000:00:02.0: irq 31 for MSI/MSI-X
[   59.948411] [drm] set up 31M of stolen space
[   60.711514] fb0: inteldrmfb frame buffer device
[   60.711520] registered panic notifier
[   60.717669] acpi device:01: registered as cooling_device4
[   60.717879] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08=
:00/LNXVIDEO:00/input/input9
[   60.717917] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[   60.717965] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on mi=
nor 0
[   60.800955] Console: switching to colour frame buffer device 160x50
[  111.723019] iwlagn 0000:02:00.0: Error sending REPLY_CT_KILL_CONFIG_CMD:=
 time out after 500ms.
[  111.723025] iwlagn 0000:02:00.0: REPLY_CT_KILL_CONFIG_CMD failed
[  112.222222] iwlagn 0000:02:00.0: Error sending POWER_TABLE_CMD: time out=
 after 500ms.
[  112.222226] iwlagn 0000:02:00.0: set power fail, ret =3D -110
[  112.222233] iwlagn 0000:02:00.0: Device reached critical temperature - u=
code going to sleep!
[  112.222245] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  112.222251] iwlagn 0000:02:00.0: Error sending REPLY_REMOVE_ALL_STA: enq=
ueue_hcmd failed: -5
[  112.222254] iwlagn 0000:02:00.0: Couldn't clear the station table
[  112.222260] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  112.222263] iwlagn 0000:02:00.0: Error sending REPLY_RXON: enqueue_hcmd =
failed: -5
[  112.222266] iwlagn 0000:02:00.0: Error setting new RXON (-5)
[  112.226352] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  112.226357] iwlagn 0000:02:00.0: Error sending POWER_TABLE_CMD: enqueue_=
hcmd failed: -5
[  112.226361] iwlagn 0000:02:00.0: set power fail, ret =3D -5
[  112.226364] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  112.226367] iwlagn 0000:02:00.0: Error sending REPLY_RXON: enqueue_hcmd =
failed: -5
[  112.226370] iwlagn 0000:02:00.0: Error setting new RXON (-5)
[  112.226906] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  113.225422] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  113.225427] iwlagn 0000:02:00.0: Error sending POWER_TABLE_CMD: enqueue_=
hcmd failed: -5
[  113.225431] iwlagn 0000:02:00.0: set power fail, ret =3D -5
[  113.225435] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  113.225438] iwlagn 0000:02:00.0: Error sending REPLY_RXON: enqueue_hcmd =
failed: -5
[  113.225441] iwlagn 0000:02:00.0: Error setting new RXON (-5)
[  113.225464] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  113.225470] iwlagn 0000:02:00.0: Error sending REPLY_SCAN_CMD: enqueue_h=
cmd failed: -5
[  113.225480] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  113.225485] iwlagn 0000:02:00.0: Error sending REPLY_TX_POWER_DBM_CMD: e=
nqueue_hcmd failed: -5
[  113.225546] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  113.225551] iwlagn 0000:02:00.0: Error sending REPLY_SCAN_CMD: enqueue_h=
cmd failed: -5
[  113.225564] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  113.225568] iwlagn 0000:02:00.0: Error sending REPLY_RXON: enqueue_hcmd =
failed: -5
[  113.225573] iwlagn 0000:02:00.0: Error setting new RXON (-5)
[  113.225577] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  113.225581] iwlagn 0000:02:00.0: Error sending POWER_TABLE_CMD: enqueue_=
hcmd failed: -5
[  113.225586] iwlagn 0000:02:00.0: set power fail, ret =3D -5
[  113.225590] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  113.225594] iwlagn 0000:02:00.0: Error sending REPLY_RXON: enqueue_hcmd =
failed: -5
[  113.225598] iwlagn 0000:02:00.0: Error setting new RXON (-5)
[  113.225606] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  113.225610] iwlagn 0000:02:00.0: Error sending REPLY_TX_POWER_DBM_CMD: e=
nqueue_hcmd failed: -5
[  118.232902] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  118.232909] iwlagn 0000:02:00.0: Error sending POWER_TABLE_CMD: enqueue_=
hcmd failed: -5
[  118.232912] iwlagn 0000:02:00.0: set power fail, ret =3D -5
[  118.232917] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  118.232920] iwlagn 0000:02:00.0: Error sending REPLY_RXON: enqueue_hcmd =
failed: -5
[  118.232924] iwlagn 0000:02:00.0: Error setting new RXON (-5)
[  118.232986] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  118.232991] iwlagn 0000:02:00.0: Error sending REPLY_SCAN_CMD: enqueue_h=
cmd failed: -5
[  118.233002] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  118.233005] iwlagn 0000:02:00.0: Error sending REPLY_TX_POWER_DBM_CMD: e=
nqueue_hcmd failed: -5
[  118.233017] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  118.233020] iwlagn 0000:02:00.0: Error sending REPLY_SCAN_CMD: enqueue_h=
cmd failed: -5
[  118.233031] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  118.233035] iwlagn 0000:02:00.0: Error sending REPLY_RXON: enqueue_hcmd =
failed: -5
[  118.233039] iwlagn 0000:02:00.0: Error setting new RXON (-5)
[  118.233045] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  118.233049] iwlagn 0000:02:00.0: Error sending POWER_TABLE_CMD: enqueue_=
hcmd failed: -5
[  118.233053] iwlagn 0000:02:00.0: set power fail, ret =3D -5
[  118.233057] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  118.233061] iwlagn 0000:02:00.0: Error sending REPLY_RXON: enqueue_hcmd =
failed: -5
[  118.233065] iwlagn 0000:02:00.0: Error setting new RXON (-5)
[  118.233073] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  118.233078] iwlagn 0000:02:00.0: Error sending REPLY_TX_POWER_DBM_CMD: e=
nqueue_hcmd failed: -5
[  123.229659] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  123.229666] iwlagn 0000:02:00.0: Error sending POWER_TABLE_CMD: enqueue_=
hcmd failed: -5
[  123.229669] iwlagn 0000:02:00.0: set power fail, ret =3D -5
[  123.229674] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  123.229678] iwlagn 0000:02:00.0: Error sending REPLY_RXON: enqueue_hcmd =
failed: -5
[  123.229681] iwlagn 0000:02:00.0: Error setting new RXON (-5)
[  123.229748] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  123.229753] iwlagn 0000:02:00.0: Error sending REPLY_SCAN_CMD: enqueue_h=
cmd failed: -5
[  123.229764] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  123.229768] iwlagn 0000:02:00.0: Error sending REPLY_TX_POWER_DBM_CMD: e=
nqueue_hcmd failed: -5
[  123.229786] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  123.229789] iwlagn 0000:02:00.0: Error sending REPLY_SCAN_CMD: enqueue_h=
cmd failed: -5
[  123.229800] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  123.229804] iwlagn 0000:02:00.0: Error sending REPLY_RXON: enqueue_hcmd =
failed: -5
[  123.229809] iwlagn 0000:02:00.0: Error setting new RXON (-5)
[  123.229815] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  123.229819] iwlagn 0000:02:00.0: Error sending POWER_TABLE_CMD: enqueue_=
hcmd failed: -5
[  123.229824] iwlagn 0000:02:00.0: set power fail, ret =3D -5
[  123.229828] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  123.229833] iwlagn 0000:02:00.0: Error sending REPLY_RXON: enqueue_hcmd =
failed: -5
[  123.229837] iwlagn 0000:02:00.0: Error setting new RXON (-5)
[  123.229844] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  123.229848] iwlagn 0000:02:00.0: Error sending REPLY_TX_POWER_DBM_CMD: e=
nqueue_hcmd failed: -5
[  128.226440] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  128.226447] iwlagn 0000:02:00.0: Error sending POWER_TABLE_CMD: enqueue_=
hcmd failed: -5
[  128.226450] iwlagn 0000:02:00.0: set power fail, ret =3D -5
[  128.226455] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  128.226458] iwlagn 0000:02:00.0: Error sending REPLY_RXON: enqueue_hcmd =
failed: -5
[  128.226461] iwlagn 0000:02:00.0: Error setting new RXON (-5)
[  128.226540] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  128.226545] iwlagn 0000:02:00.0: Error sending REPLY_SCAN_CMD: enqueue_h=
cmd failed: -5
[  128.226555] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  128.226559] iwlagn 0000:02:00.0: Error sending REPLY_TX_POWER_DBM_CMD: e=
nqueue_hcmd failed: -5
[  128.226571] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  128.226574] iwlagn 0000:02:00.0: Error sending REPLY_SCAN_CMD: enqueue_h=
cmd failed: -5
[  128.226584] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  128.226588] iwlagn 0000:02:00.0: Error sending REPLY_RXON: enqueue_hcmd =
failed: -5
[  128.226592] iwlagn 0000:02:00.0: Error setting new RXON (-5)
[  128.226597] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  128.226601] iwlagn 0000:02:00.0: Error sending POWER_TABLE_CMD: enqueue_=
hcmd failed: -5
[  128.226606] iwlagn 0000:02:00.0: set power fail, ret =3D -5
[  128.226610] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  128.226614] iwlagn 0000:02:00.0: Error sending REPLY_RXON: enqueue_hcmd =
failed: -5
[  128.226618] iwlagn 0000:02:00.0: Error setting new RXON (-5)
[  128.226625] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  128.226629] iwlagn 0000:02:00.0: Error sending REPLY_TX_POWER_DBM_CMD: e=
nqueue_hcmd failed: -5
[  133.223350] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  133.223356] iwlagn 0000:02:00.0: Error sending POWER_TABLE_CMD: enqueue_=
hcmd failed: -5
[  133.223360] iwlagn 0000:02:00.0: set power fail, ret =3D -5
[  133.223364] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  133.223368] iwlagn 0000:02:00.0: Error sending REPLY_RXON: enqueue_hcmd =
failed: -5
[  133.223371] iwlagn 0000:02:00.0: Error setting new RXON (-5)
[  133.223431] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  133.223436] iwlagn 0000:02:00.0: Error sending REPLY_SCAN_CMD: enqueue_h=
cmd failed: -5
[  133.223446] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  133.223450] iwlagn 0000:02:00.0: Error sending REPLY_TX_POWER_DBM_CMD: e=
nqueue_hcmd failed: -5
[  133.223462] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  133.223465] iwlagn 0000:02:00.0: Error sending REPLY_SCAN_CMD: enqueue_h=
cmd failed: -5
[  133.223476] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  133.223479] iwlagn 0000:02:00.0: Error sending REPLY_RXON: enqueue_hcmd =
failed: -5
[  133.223484] iwlagn 0000:02:00.0: Error setting new RXON (-5)
[  133.223489] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  133.223493] iwlagn 0000:02:00.0: Error sending POWER_TABLE_CMD: enqueue_=
hcmd failed: -5
[  133.223497] iwlagn 0000:02:00.0: set power fail, ret =3D -5
[  133.223501] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  133.223505] iwlagn 0000:02:00.0: Error sending REPLY_RXON: enqueue_hcmd =
failed: -5
[  133.223509] iwlagn 0000:02:00.0: Error setting new RXON (-5)
[  133.223516] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  133.223520] iwlagn 0000:02:00.0: Error sending REPLY_TX_POWER_DBM_CMD: e=
nqueue_hcmd failed: -5
[  138.219141] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  138.219146] iwlagn 0000:02:00.0: Error sending POWER_TABLE_CMD: enqueue_=
hcmd failed: -5
[  138.219149] iwlagn 0000:02:00.0: set power fail, ret =3D -5
[  138.219153] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  138.219155] iwlagn 0000:02:00.0: Error sending REPLY_RXON: enqueue_hcmd =
failed: -5
[  138.219158] iwlagn 0000:02:00.0: Error setting new RXON (-5)
[  138.219205] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  138.219208] iwlagn 0000:02:00.0: Error sending REPLY_SCAN_CMD: enqueue_h=
cmd failed: -5
[  138.219215] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  138.219217] iwlagn 0000:02:00.0: Error sending REPLY_TX_POWER_DBM_CMD: e=
nqueue_hcmd failed: -5
[  138.219225] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  138.219227] iwlagn 0000:02:00.0: Error sending REPLY_SCAN_CMD: enqueue_h=
cmd failed: -5
[  138.219234] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  138.219236] iwlagn 0000:02:00.0: Error sending REPLY_RXON: enqueue_hcmd =
failed: -5
[  138.219238] iwlagn 0000:02:00.0: Error setting new RXON (-5)
[  138.219242] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  138.219244] iwlagn 0000:02:00.0: Error sending POWER_TABLE_CMD: enqueue_=
hcmd failed: -5
[  138.219246] iwlagn 0000:02:00.0: set power fail, ret =3D -5
[  138.219248] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  138.219250] iwlagn 0000:02:00.0: Error sending REPLY_RXON: enqueue_hcmd =
failed: -5
[  138.219252] iwlagn 0000:02:00.0: Error setting new RXON (-5)
[  138.219257] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  138.219259] iwlagn 0000:02:00.0: Error sending REPLY_TX_POWER_DBM_CMD: e=
nqueue_hcmd failed: -5
[  143.215893] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  143.215899] iwlagn 0000:02:00.0: Error sending POWER_TABLE_CMD: enqueue_=
hcmd failed: -5
[  143.215903] iwlagn 0000:02:00.0: set power fail, ret =3D -5
[  143.215908] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  143.215911] iwlagn 0000:02:00.0: Error sending REPLY_RXON: enqueue_hcmd =
failed: -5
[  143.215914] iwlagn 0000:02:00.0: Error setting new RXON (-5)
[  143.215975] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  143.215980] iwlagn 0000:02:00.0: Error sending REPLY_SCAN_CMD: enqueue_h=
cmd failed: -5
[  143.215990] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  143.215994] iwlagn 0000:02:00.0: Error sending REPLY_TX_POWER_DBM_CMD: e=
nqueue_hcmd failed: -5
[  143.216006] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  143.216009] iwlagn 0000:02:00.0: Error sending REPLY_SCAN_CMD: enqueue_h=
cmd failed: -5
[  143.216019] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  143.216024] iwlagn 0000:02:00.0: Error sending REPLY_RXON: enqueue_hcmd =
failed: -5
[  143.216028] iwlagn 0000:02:00.0: Error setting new RXON (-5)
[  143.216033] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  143.216037] iwlagn 0000:02:00.0: Error sending POWER_TABLE_CMD: enqueue_=
hcmd failed: -5
[  143.216041] iwlagn 0000:02:00.0: set power fail, ret =3D -5
[  143.216045] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  143.216050] iwlagn 0000:02:00.0: Error sending REPLY_RXON: enqueue_hcmd =
failed: -5
[  143.216054] iwlagn 0000:02:00.0: Error setting new RXON (-5)
[  143.216061] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  143.216064] iwlagn 0000:02:00.0: Error sending REPLY_TX_POWER_DBM_CMD: e=
nqueue_hcmd failed: -5
[  148.212662] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  148.212667] iwlagn 0000:02:00.0: Error sending POWER_TABLE_CMD: enqueue_=
hcmd failed: -5
[  148.212671] iwlagn 0000:02:00.0: set power fail, ret =3D -5
[  148.212676] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  148.212679] iwlagn 0000:02:00.0: Error sending REPLY_RXON: enqueue_hcmd =
failed: -5
[  148.212682] iwlagn 0000:02:00.0: Error setting new RXON (-5)
[  148.212744] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  148.212749] iwlagn 0000:02:00.0: Error sending REPLY_SCAN_CMD: enqueue_h=
cmd failed: -5
[  148.212760] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  148.212763] iwlagn 0000:02:00.0: Error sending REPLY_TX_POWER_DBM_CMD: e=
nqueue_hcmd failed: -5
[  148.212776] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  148.212779] iwlagn 0000:02:00.0: Error sending REPLY_SCAN_CMD: enqueue_h=
cmd failed: -5
[  148.212790] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  148.212794] iwlagn 0000:02:00.0: Error sending REPLY_RXON: enqueue_hcmd =
failed: -5
[  148.212798] iwlagn 0000:02:00.0: Error setting new RXON (-5)
[  148.212803] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  148.212807] iwlagn 0000:02:00.0: Error sending POWER_TABLE_CMD: enqueue_=
hcmd failed: -5
[  148.212812] iwlagn 0000:02:00.0: set power fail, ret =3D -5
[  148.212816] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  148.212819] iwlagn 0000:02:00.0: Error sending REPLY_RXON: enqueue_hcmd =
failed: -5
[  148.212824] iwlagn 0000:02:00.0: Error setting new RXON (-5)
[  148.212832] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  148.212835] iwlagn 0000:02:00.0: Error sending REPLY_TX_POWER_DBM_CMD: e=
nqueue_hcmd failed: -5
[  153.208561] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  153.208566] iwlagn 0000:02:00.0: Error sending POWER_TABLE_CMD: enqueue_=
hcmd failed: -5
[  153.208568] iwlagn 0000:02:00.0: set power fail, ret =3D -5
[  153.208571] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  153.208573] iwlagn 0000:02:00.0: Error sending REPLY_RXON: enqueue_hcmd =
failed: -5
[  153.208575] iwlagn 0000:02:00.0: Error setting new RXON (-5)
[  153.208588] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  153.208591] iwlagn 0000:02:00.0: Error sending REPLY_SCAN_CMD: enqueue_h=
cmd failed: -5
[  153.208597] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  153.208599] iwlagn 0000:02:00.0: Error sending REPLY_TX_POWER_DBM_CMD: e=
nqueue_hcmd failed: -5
[  153.208606] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  153.208607] iwlagn 0000:02:00.0: Error sending REPLY_SCAN_CMD: enqueue_h=
cmd failed: -5
[  153.208614] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  153.208616] iwlagn 0000:02:00.0: Error sending REPLY_RXON: enqueue_hcmd =
failed: -5
[  153.208619] iwlagn 0000:02:00.0: Error setting new RXON (-5)
[  153.208621] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  153.208623] iwlagn 0000:02:00.0: Error sending POWER_TABLE_CMD: enqueue_=
hcmd failed: -5
[  153.208625] iwlagn 0000:02:00.0: set power fail, ret =3D -5
[  153.208627] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  153.208630] iwlagn 0000:02:00.0: Error sending REPLY_RXON: enqueue_hcmd =
failed: -5
[  153.208632] iwlagn 0000:02:00.0: Error setting new RXON (-5)
[  153.208636] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  153.208638] iwlagn 0000:02:00.0: Error sending REPLY_TX_POWER_DBM_CMD: e=
nqueue_hcmd failed: -5
[  158.205275] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  158.205281] iwlagn 0000:02:00.0: Error sending POWER_TABLE_CMD: enqueue_=
hcmd failed: -5
[  158.205284] iwlagn 0000:02:00.0: set power fail, ret =3D -5
[  158.205289] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  158.205292] iwlagn 0000:02:00.0: Error sending REPLY_RXON: enqueue_hcmd =
failed: -5
[  158.205295] iwlagn 0000:02:00.0: Error setting new RXON (-5)
[  158.205370] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  158.205375] iwlagn 0000:02:00.0: Error sending REPLY_SCAN_CMD: enqueue_h=
cmd failed: -5
[  158.205386] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  158.205389] iwlagn 0000:02:00.0: Error sending REPLY_TX_POWER_DBM_CMD: e=
nqueue_hcmd failed: -5
[  158.205401] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  158.205404] iwlagn 0000:02:00.0: Error sending REPLY_SCAN_CMD: enqueue_h=
cmd failed: -5
[  158.205415] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  158.205419] iwlagn 0000:02:00.0: Error sending REPLY_RXON: enqueue_hcmd =
failed: -5
[  158.205423] iwlagn 0000:02:00.0: Error setting new RXON (-5)
[  158.205428] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  158.205432] iwlagn 0000:02:00.0: Error sending POWER_TABLE_CMD: enqueue_=
hcmd failed: -5
[  158.205436] iwlagn 0000:02:00.0: set power fail, ret =3D -5
[  158.205440] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  158.205444] iwlagn 0000:02:00.0: Error sending REPLY_RXON: enqueue_hcmd =
failed: -5
[  158.205449] iwlagn 0000:02:00.0: Error setting new RXON (-5)
[  158.205456] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  158.205461] iwlagn 0000:02:00.0: Error sending REPLY_TX_POWER_DBM_CMD: e=
nqueue_hcmd failed: -5
[  163.201975] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  163.201981] iwlagn 0000:02:00.0: Error sending POWER_TABLE_CMD: enqueue_=
hcmd failed: -5
[  163.201984] iwlagn 0000:02:00.0: set power fail, ret =3D -5
[  163.201989] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  163.201992] iwlagn 0000:02:00.0: Error sending REPLY_RXON: enqueue_hcmd =
failed: -5
[  163.201995] iwlagn 0000:02:00.0: Error setting new RXON (-5)
[  163.202073] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  163.202079] iwlagn 0000:02:00.0: Error sending REPLY_SCAN_CMD: enqueue_h=
cmd failed: -5
[  163.202091] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  163.202095] iwlagn 0000:02:00.0: Error sending REPLY_TX_POWER_DBM_CMD: e=
nqueue_hcmd failed: -5
[  163.202108] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  163.202112] iwlagn 0000:02:00.0: Error sending REPLY_SCAN_CMD: enqueue_h=
cmd failed: -5
[  163.202124] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  163.202129] iwlagn 0000:02:00.0: Error sending REPLY_RXON: enqueue_hcmd =
failed: -5
[  163.202134] iwlagn 0000:02:00.0: Error setting new RXON (-5)
[  163.202140] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  163.202145] iwlagn 0000:02:00.0: Error sending POWER_TABLE_CMD: enqueue_=
hcmd failed: -5
[  163.202150] iwlagn 0000:02:00.0: set power fail, ret =3D -5
[  163.202155] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  163.202160] iwlagn 0000:02:00.0: Error sending REPLY_RXON: enqueue_hcmd =
failed: -5
[  163.202165] iwlagn 0000:02:00.0: Error setting new RXON (-5)
[  163.202174] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  163.202180] iwlagn 0000:02:00.0: Error sending REPLY_TX_POWER_DBM_CMD: e=
nqueue_hcmd failed: -5
[  168.198803] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  168.198808] iwlagn 0000:02:00.0: Error sending POWER_TABLE_CMD: enqueue_=
hcmd failed: -5
[  168.198812] iwlagn 0000:02:00.0: set power fail, ret =3D -5
[  168.198817] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  168.198820] iwlagn 0000:02:00.0: Error sending REPLY_RXON: enqueue_hcmd =
failed: -5
[  168.198823] iwlagn 0000:02:00.0: Error setting new RXON (-5)
[  168.198885] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  168.198890] iwlagn 0000:02:00.0: Error sending REPLY_SCAN_CMD: enqueue_h=
cmd failed: -5
[  168.198900] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  168.198903] iwlagn 0000:02:00.0: Error sending REPLY_TX_POWER_DBM_CMD: e=
nqueue_hcmd failed: -5
[  168.199006] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  168.199011] iwlagn 0000:02:00.0: Error sending REPLY_SCAN_CMD: enqueue_h=
cmd failed: -5
[  168.199024] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  168.199028] iwlagn 0000:02:00.0: Error sending REPLY_RXON: enqueue_hcmd =
failed: -5
[  168.199032] iwlagn 0000:02:00.0: Error setting new RXON (-5)
[  168.199037] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  168.199041] iwlagn 0000:02:00.0: Error sending POWER_TABLE_CMD: enqueue_=
hcmd failed: -5
[  168.199045] iwlagn 0000:02:00.0: set power fail, ret =3D -5
[  168.199050] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  168.199054] iwlagn 0000:02:00.0: Error sending REPLY_RXON: enqueue_hcmd =
failed: -5
[  168.199058] iwlagn 0000:02:00.0: Error setting new RXON (-5)
[  168.199066] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  168.199070] iwlagn 0000:02:00.0: Error sending REPLY_TX_POWER_DBM_CMD: e=
nqueue_hcmd failed: -5
[  171.094648] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  171.094653] iwlagn 0000:02:00.0: Error sending REPLY_STATISTICS_CMD: enq=
ueue_hcmd failed: -5
[  173.195706] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  173.195712] iwlagn 0000:02:00.0: Error sending POWER_TABLE_CMD: enqueue_=
hcmd failed: -5
[  173.195716] iwlagn 0000:02:00.0: set power fail, ret =3D -5
[  173.195721] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  173.195724] iwlagn 0000:02:00.0: Error sending REPLY_RXON: enqueue_hcmd =
failed: -5
[  173.195727] iwlagn 0000:02:00.0: Error setting new RXON (-5)
[  173.195788] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  173.195793] iwlagn 0000:02:00.0: Error sending REPLY_SCAN_CMD: enqueue_h=
cmd failed: -5
[  173.195804] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  173.195807] iwlagn 0000:02:00.0: Error sending REPLY_TX_POWER_DBM_CMD: e=
nqueue_hcmd failed: -5
[  173.195833] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  173.195837] iwlagn 0000:02:00.0: Error sending REPLY_SCAN_CMD: enqueue_h=
cmd failed: -5
[  173.195847] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  173.195851] iwlagn 0000:02:00.0: Error sending REPLY_RXON: enqueue_hcmd =
failed: -5
[  173.195855] iwlagn 0000:02:00.0: Error setting new RXON (-5)
[  173.195860] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  173.195864] iwlagn 0000:02:00.0: Error sending POWER_TABLE_CMD: enqueue_=
hcmd failed: -5
[  173.195868] iwlagn 0000:02:00.0: set power fail, ret =3D -5
[  173.195872] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  173.195877] iwlagn 0000:02:00.0: Error sending REPLY_RXON: enqueue_hcmd =
failed: -5
[  173.195881] iwlagn 0000:02:00.0: Error setting new RXON (-5)
[  173.195888] iwlagn 0000:02:00.0: Not sending command - CT KILL
[  173.195892] iwlagn 0000:02:00.0: Error sending REPLY_TX_POWER_DBM_CMD: e=
nqueue_hcmd failed: -5

--OBd5C1Lgu00Gd/Tn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="2.6.34-rc5-NS-00211-gb91ce4d.dmesg.past-reload"

[  177.664614] iwlagn 0000:02:00.0: PCI INT A disabled
[  182.600323] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:
[  182.600325] iwlagn: Copyright(c) 2003-2010 Intel Corporation
[  182.600429] iwlagn 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[  182.600488] iwlagn 0000:02:00.0: setting latency timer to 64
[  182.600582] iwlagn 0000:02:00.0: Detected Intel Wireless WiFi Link 6000 Series 3x3 AGN REV=0x74
[  182.617432] iwlagn 0000:02:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
[  182.617550] iwlagn 0000:02:00.0: irq 29 for MSI/MSI-X
[  182.617894] iwlagn 0000:02:00.0: firmware: requesting iwlwifi-6000-4.ucode
[  182.667853] iwlagn 0000:02:00.0: loaded firmware version 9.176.4.1
[  182.668574] phy1: Selected rate control algorithm 'iwl-agn-rs'
[  182.994882] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  187.268773] wlan0: deauthenticating from 00:05:4e:4d:82:6d by local choice (reason=3)
[  187.306691] wlan0: authenticate with 00:05:4e:4d:82:6d (try 1)
[  187.505637] wlan0: authenticate with 00:05:4e:4d:82:6d (try 2)
[  187.508192] wlan0: authenticated
[  187.509974] wlan0: associate with 00:05:4e:4d:82:6d (try 1)
[  187.516986] wlan0: RX AssocResp from 00:05:4e:4d:82:6d (capab=0x1 status=0 aid=1)
[  187.516991] wlan0: associated
[  187.521217] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[  197.653250] wlan0: no IPv6 routers present

--OBd5C1Lgu00Gd/Tn--

--NklN7DEeGtkPCoo3
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvWlw4ACgkQ19zI5DGHffANZgCg2GZl9zHEUK5aGypombCiid/X
sIwAniKAYvcv5A+4pkv7p8xER9oEqote
=lKZg
-----END PGP SIGNATURE-----

--NklN7DEeGtkPCoo3--

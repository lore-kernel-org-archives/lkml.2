Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871Ab0CQUo4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 16:44:56 -0400
Received: from li142-175.members.linode.com ([109.74.195.175]:51696 "EHLO
	designinfo.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755350Ab0CQUox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 16:44:53 -0400
X-Greylist: delayed 650 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Mar 2010 16:44:53 EDT
From: "Max V. Kotov" <ckopnuo@designinfo.ru>
To: LKML <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Fwd: linux-next: Tree for March 12, r8169 does not work
Date: Wed, 17 Mar 2010 23:29:41 +0300
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc1-next-20100311.m-desktop+; KDE/4.3.4; x86_64; ; )
References: <bbc987b61003160702w66a86d6k31f61629ea421a68@mail.gmail.com> <bbc987b61003171324i51cc0b00wabd44bc119b77d2f@mail.gmail.com>
In-Reply-To: <bbc987b61003171324i51cc0b00wabd44bc119b77d2f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1333048.h0nm7sQuEg";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201003172329.41634.ckopnuo@designinfo.ru>
X-Authenticated-User: max.kotov@designinfo.ru
X-Authenticator: plain
X-Sender-Verify: SUCCEEDED (sender exists & accepts mail)
X-Spam-Score: -6.8
X-Spam-Score-Int: -67
X-Exim-Version: 4.71 (build at 01-Jan-2010 14:03:12)
X-Date: 2010-03-17 23:33:58
X-Connected-IP: 80.251.122.142:53675
X-Message-Linecount: 978
X-Body-Linecount: 962
X-Message-Size: 50780
X-Body-Size: 50011
X-Received-Count: 1
X-Recipient-Count: 2
X-Local-Recipient-Count: 2
X-Local-Recipient-Defer-Count: 0
X-Local-Recipient-Fail-Count: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1333048.h0nm7sQuEg
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

I've sent this message several days ago from my gmail account, but it's not=
 in LKML list till now.
Awesome strange...
=20
> ---------- FWD ----------
> =D0=9E=D1=82 =D0=BA=D0=BE=D0=B3=D0=BE: =D0=9C=D0=B0=D0=BA=D1=81=D0=B8=D0=
=BC =D0=9A=D0=BE=D1=82=D0=BE=D0=B2 <designinfo.ru@gmail.com>
> =D0=94=D0=B0=D1=82=D0=B0: 16 =D0=BC=D0=B0=D1=80=D1=82=D0=B0 2010 =D0=B3. =
17:02
> =D0=A2=D0=B5=D0=BC=D0=B0: linux-next: Tree for March 12, r8169 does not w=
ork
> =D0=9A=D0=BE=D0=BC=D1=83: Stephen Rothwell <sfr@canb.auug.org.au>
> =D0=9A=D0=BE=D0=BF=D0=B8=D1=8F: linux-next@vger.kernel.org, LKML <linux-k=
ernel@vger.kernel.org>
>=20
>=20
> Hi!
>=20
> r8169 is loaded, ifconfig says that interface is up, there are egress
> packets in stat, but no ingress.
> Link on remote switch is active and no packets from linux box. So
> actually i think network card totally doesn't work.
>=20
> I can provide some more info but i don't know what exactly is required.
>=20
> Some info is below and in attachment. You may amswer directly at
> linux-next@.... , i'm subscribed.
> ----------------------------
>=20
> ckopnuo@ckopnuo ~ % uname -a
> Linux ckopnuo 2.6.34-rc1-next-20100312.m-desktop+ #6 SMP Mon Mar 15
> 17:09:14 MSK 2010 i686 GNU/Linux
>=20
> gcc -v
> Using built-in specs.
> Target: i486-linux-gnu
> Configured with: ../src/configure -v --with-pkgversion=3D'Debian
> 4.4.3-3' --with-bugurl=3Dfile:///usr/share/doc/gcc-4.4/README.Bugs
> --enable-languages=3Dc,c++,fortran,objc,obj-c++ --prefix=3D/usr
> --enable-shared --enable-multiarch --enable-linker-build-id
> --with-system-zlib --libexecdir=3D/usr/lib --without-included-gettext
> --enable-threads=3Dposix --with-gxx-include-dir=3D/usr/include/c++/4.4
> --program-suffix=3D-4.4 --enable-nls --enable-clocale=3Dgnu
> --enable-libstdcxx-debug --enable-objc-gc --enable-targets=3Dall
> --with-arch-32=3Di486 --with-tune=3Dgeneric --enable-checking=3Drelease
> --build=3Di486-linux-gnu --host=3Di486-linux-gnu --target=3Di486-linux-gnu
> Thread model: posix
> gcc version 4.4.3 (Debian 4.4.3-3)
>=20
> And dmesg
>=20
> [ 0.000000] Initializing cgroup subsys cpuset
> [ 0.000000] Initializing cgroup subsys cpu
> [ 0.000000] Linux version 2.6.34-rc1-next-20100312.m-desktop+
> (root@ckopnuo) (gcc version 4.4.3 (Debian 4.4.3-3) ) #6 SMP Mon Mar 15
> 17:09:14 MSK 2010
> [ 0.000000] BIOS-provided physical RAM map:
> [ 0.000000] BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
> [ 0.000000] BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
> [ 0.000000] BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
> [ 0.000000] BIOS-e820: 0000000000100000 - 000000003f690000 (usable)
> [ 0.000000] BIOS-e820: 000000003f690000 - 000000003f69e000 (ACPI data)
> [ 0.000000] BIOS-e820: 000000003f69e000 - 000000003f6d0000 (ACPI NVS)
> [ 0.000000] BIOS-e820: 000000003f6d0000 - 000000003f6de000 (reserved)
> [ 0.000000] BIOS-e820: 000000003f6e0000 - 000000003f700000 (reserved)
> [ 0.000000] BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
> [ 0.000000] BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
> [ 0.000000] NX (Execute Disable) protection: active
> [ 0.000000] DMI present.
> [ 0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working around i=
t.
> [ 0.000000] e820 update range: 0000000000000000 - 0000000000010000
> (usable) =3D=3D> (reserved)
> [ 0.000000] e820 update range: 0000000000000000 - 0000000000001000
> (usable) =3D=3D> (reserved)
> [ 0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usabl=
e)
> [ 0.000000] last_pfn =3D 0x3f690 max_arch_pfn =3D 0x1000000
> [ 0.000000] MTRR default type: uncachable
> [ 0.000000] MTRR fixed ranges enabled:
> [ 0.000000] 00000-9FFFF write-back
> [ 0.000000] A0000-BFFFF uncachable
> [ 0.000000] C0000-DFFFF write-protect
> [ 0.000000] E0000-EFFFF write-through
> [ 0.000000] F0000-FFFFF write-protect
> [ 0.000000] MTRR variable ranges enabled:
> [ 0.000000] 0 base 000000000 mask FC0000000 write-back
> [ 0.000000] 1 base 03F700000 mask FFFF00000 uncachable
> [ 0.000000] 2 base 03F800000 mask FFF800000 uncachable
> [ 0.000000] 3 disabled
> [ 0.000000] 4 disabled
> [ 0.000000] 5 disabled
> [ 0.000000] 6 disabled
> [ 0.000000] 7 disabled
> [ 0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new
>  0x7010600070106 [ 0.000000] initial memory mapped : 0 - 00a00000
> [ 0.000000] found SMP MP-table at [c00ff780] ff780
> [ 0.000000] init_memory_mapping: 0000000000000000-00000000379fe000
> [ 0.000000] 0000000000 - 0000200000 page 4k
> [ 0.000000] 0000200000 - 0037800000 page 2M
> [ 0.000000] 0037800000 - 00379fe000 page 4k
> [ 0.000000] kernel direct mapping tables up to 379fe000 @ 15000-1b000
> [ 0.000000] RAMDISK: 2ef06000 - 2f92b1a5
> [ 0.000000] ACPI: RSDP 000fb7c0 00024 (v02 ACPIAM)
> [ 0.000000] ACPI: XSDT 3f690100 00054 (v01 A_M_I_ OEMXSDT 02000924
> MSFT 00000097)
> [ 0.000000] ACPI: FACP 3f690290 000F4 (v03 A_M_I_ OEMFACP 02000924
> MSFT 00000097)
> [ 0.000000] ACPI: DSDT 3f6905c0 07C37 (v01 A0846 A0846000 00000000
> INTL 20051117)
> [ 0.000000] ACPI: FACS 3f69e000 00040
> [ 0.000000] ACPI: APIC 3f690390 0006C (v01 A_M_I_ OEMAPIC 02000924
> MSFT 00000097)
> [ 0.000000] ACPI: MCFG 3f690400 0003C (v01 A_M_I_ OEMMCFG 02000924
> MSFT 00000097)
> [ 0.000000] ACPI: OEMB 3f69e040 00080 (v01 A_M_I_ AMI_OEM 02000924
> MSFT 00000097)
> [ 0.000000] ACPI: HPET 3f698200 00038 (v01 A_M_I_ OEMHPET 02000924
> MSFT 00000097)
> [ 0.000000] ACPI: GSCI 3f69e0c0 02024 (v01 A_M_I_ GMCHSCI 02000924
> MSFT 00000097)
> [ 0.000000] ACPI: Local APIC address 0xfee00000
> [ 0.000000] could not find any ACPI SRAT memory areas.
> [ 0.000000] failed to get NUMA memory information from SRAT table
> [ 0.000000] NUMA - single node, flat memory mode
> [ 0.000000] node 0 pfn: [0 - 3f690]
> [ 0.000000] Reserving 2560 pages of KVA for lmem_map of node 0 at 3ec00
> [ 0.000000] remove_active_range (0, 257024, 259584)
> [ 0.000000] Reserving total of a00 pages for numa KVA remap
> [ 0.000000] kva_start_pfn ~ 36e00 max_low_pfn ~ 379fe
> [ 0.000000] max_pfn =3D 3f690
> [ 0.000000] 124MB HIGHMEM available.
> [ 0.000000] 889MB LOWMEM available.
> [ 0.000000] max_low_pfn =3D 379fe, highstart_pfn =3D 379fe
> [ 0.000000] Low memory ends at vaddr f79fe000
> [ 0.000000] node 0 will remap to vaddr f6e00000 - f7800000
> [ 0.000000] allocate_pgdat: node 0 NODE_DATA f6e00000
> [ 0.000000] remap_numa_kva: node 0
> [ 0.000000] remap_numa_kva: f6e00000 to pfn 0003ec00
> [ 0.000000] remap_numa_kva: f7000000 to pfn 0003ee00
> [ 0.000000] remap_numa_kva: f7200000 to pfn 0003f000
> [ 0.000000] remap_numa_kva: f7400000 to pfn 0003f200
> [ 0.000000] remap_numa_kva: f7600000 to pfn 0003f400
> [ 0.000000] High memory starts at vaddr f79fe000
> [ 0.000000] mapped low ram: 0 - 379fe000
> [ 0.000000] low ram: 0 - 379fe000
> [ 0.000000] Zone PFN ranges:
> [ 0.000000] DMA 0x00000010 -> 0x00001000
> [ 0.000000] Normal 0x00001000 -> 0x000379fe
> [ 0.000000] HighMem 0x000379fe -> 0x0003f690
> [ 0.000000] Movable zone start PFN for each node
> [ 0.000000] early_node_map[3] active PFN ranges
> [ 0.000000] 0: 0x00000010 -> 0x0000009f
> [ 0.000000] 0: 0x00000100 -> 0x0003ec00
> [ 0.000000] 0: 0x0003f600 -> 0x0003f690
> [ 0.000000] On node 0 totalpages: 257055
> [ 0.000000] DMA zone: 32 pages used for memmap
> [ 0.000000] DMA zone: 0 pages reserved
> [ 0.000000] DMA zone: 3951 pages, LIFO batch:0
> [ 0.000000] Normal zone: 1748 pages used for memmap
> [ 0.000000] Normal zone: 221994 pages, LIFO batch:31
> [ 0.000000] HighMem zone: 250 pages used for memmap
> [ 0.000000] HighMem zone: 29080 pages, LIFO batch:7
> [ 0.000000] Using APIC driver default
> [ 0.000000] ACPI: PM-Timer IO Port: 0x808
> [ 0.000000] ACPI: Local APIC address 0xfee00000
> [ 0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
> [ 0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
> [ 0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
> [ 0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
> [ 0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
> [ 0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
> [ 0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [ 0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> [ 0.000000] ACPI: IRQ0 used by override.
> [ 0.000000] ACPI: IRQ2 used by override.
> [ 0.000000] ACPI: IRQ9 used by override.
> [ 0.000000] Using ACPI (MADT) for SMP configuration information
> [ 0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
> [ 0.000000] SMP: Allowing 4 CPUs, 2 hotplug CPUs
> [ 0.000000] nr_irqs_gsi: 24
> [ 0.000000] early_res array is doubled to 64 at [18000 - 187ff]
> [ 0.000000] PM: Registered nosave memory: 000000000009f000 -
>  00000000000a0000 [ 0.000000] PM: Registered nosave memory:
>  00000000000a0000 - 00000000000e4000 [ 0.000000] PM: Registered nosave
>  memory: 00000000000e4000 - 0000000000100000 [ 0.000000] Allocating PCI
>  resources starting at 3f700000 (gap:
> 3f700000:bf700000)
> [ 0.000000] Booting paravirtualized kernel on bare hardware
> [ 0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:4
> nr_node_ids:16
> [ 0.000000] PERCPU: Embedded 13 pages/cpu @c1200000 s29972 r0 d23276
>  u524288 [ 0.000000] pcpu-alloc: s29972 r0 d23276 u524288 alloc=3D1*20971=
52
> [ 0.000000] pcpu-alloc: [0] 0 1 2 3
> [ 0.000000] Built 1 zonelists in Zone order, mobility grouping on.
> Total pages: 255025
> [ 0.000000] Policy zone: HighMem
> [ 0.000000] Kernel command line:
> BOOT_IMAGE=3D/vmlinuz-2.6.34-rc1-next-20100312.m-desktop+
> root=3D/dev/mapper/ckopnuo-root ro nosplash
> [ 0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
> [ 0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288
>  bytes) [ 0.000000] Inode-cache hash table entries: 65536 (order: 6, 2621=
44
>  bytes) [ 0.000000] Enabling fast FPU save and restore... done.
> [ 0.000000] Enabling unmasked SIMD FPU exception support... done.
> [ 0.000000] Initializing CPU#0
> [ 0.000000] Subtract (49 early reservations)
> [ 0.000000] #1 [0000001000 - 0000002000] EX TRAMPOLINE
> [ 0.000000] #2 [0000100000 - 0000527f44] TEXT DATA BSS
> [ 0.000000] #3 [002ef06000 - 002f92b1a5] RAMDISK
> [ 0.000000] #4 [0000528000 - 000052d220] BRK
> [ 0.000000] #5 [00000ff790 - 0000100000] BIOS reserved
> [ 0.000000] #6 [00000ff780 - 00000ff790] MP-table mpf
> [ 0.000000] #7 [000009fc00 - 00000f1900] BIOS reserved
> [ 0.000000] #8 [00000f1a54 - 00000ff780] BIOS reserved
> [ 0.000000] #9 [00000f1900 - 00000f1a54] MP-table mpc
> [ 0.000000] #10 [0000010000 - 0000011000] TRAMPOLINE
> [ 0.000000] #11 [0000011000 - 0000015000] ACPI WAKEUP
> [ 0.000000] #12 [0000015000 - 0000018000] PGTABLE
> [ 0.000000] #13 [003ec00000 - 003f600000] KVA RAM
> [ 0.000000] #14 [0036e00000 - 0037800000] KVA PG
> [ 0.000000] #15 [0001000000 - 0001001000] BOOTMEM
> [ 0.000000] #16 [0020000000 - 00200000c0] BOOTMEM
> [ 0.000000] #17 [0001001000 - 000100d000] BOOTMEM
> [ 0.000000] #18 [000100d000 - 0001019000] BOOTMEM
> [ 0.000000] #19 [0001019000 - 0001025000] BOOTMEM
> [ 0.000000] #20 [0001025000 - 000102502d] BOOTMEM
> [ 0.000000] #21 [0001025080 - 00010250af] BOOTMEM
> [ 0.000000] #22 [0001025100 - 000102528c] BOOTMEM
> [ 0.000000] #23 [0001025300 - 0001025340] BOOTMEM
> [ 0.000000] #24 [0001025380 - 00010253c0] BOOTMEM
> [ 0.000000] #25 [0001025400 - 0001025440] BOOTMEM
> [ 0.000000] #26 [0001025480 - 00010254c0] BOOTMEM
> [ 0.000000] #27 [0001025500 - 0001025540] BOOTMEM
> [ 0.000000] #28 [0001025580 - 00010255c0] BOOTMEM
> [ 0.000000] #29 [0001025600 - 0001025640] BOOTMEM
> [ 0.000000] #30 [0001025680 - 00010256c0] BOOTMEM
> [ 0.000000] #31 [0001025700 - 0001025740] BOOTMEM
> [ 0.000000] #32 [0001025780 - 00010257c0] BOOTMEM
> [ 0.000000] #33 [0001025800 - 0001025810] BOOTMEM
> [ 0.000000] #34 [0001025880 - 00010258e2] BOOTMEM
> [ 0.000000] #35 [0001025900 - 0001025962] BOOTMEM
> [ 0.000000] #36 [0001200000 - 000120d000] BOOTMEM
> [ 0.000000] #37 [0001280000 - 000128d000] BOOTMEM
> [ 0.000000] #38 [0001300000 - 000130d000] BOOTMEM
> [ 0.000000] #39 [0001380000 - 000138d000] BOOTMEM
> [ 0.000000] #40 [0001027980 - 0001027984] BOOTMEM
> [ 0.000000] #41 [0001027a00 - 0001027a04] BOOTMEM
> [ 0.000000] #42 [0001027a80 - 0001027a90] BOOTMEM
> [ 0.000000] #43 [0001027b00 - 0001027b10] BOOTMEM
> [ 0.000000] #44 [0001027b80 - 0001027c18] BOOTMEM
> [ 0.000000] #45 [0001027c80 - 0001027cb8] BOOTMEM
> [ 0.000000] #46 [0001027d00 - 000102bd00] BOOTMEM
> [ 0.000000] #47 [000102bd00 - 00010abd00] BOOTMEM
> [ 0.000000] #48 [00010abd00 - 00010ebd00] BOOTMEM
> [ 0.000000] 18 20 - 80 9f
> [ 0.000000] 52e 540 - 1000 1000
> [ 0.000000] 1026 - 1027
> [ 0.000000] 10ec 1100 - 1200 1200
> [ 0.000000] 120d 1220 - 1280 1280
> [ 0.000000] 128d 12a0 - 1300 1300
> [ 0.000000] 130d 1320 - 1380 1380
> [ 0.000000] 138d 13a0 - 20000 20000
> [ 0.000000] 20001 20020 - 2ef00 2ef06
> [ 0.000000] 2f92c 2f940 - 36e00 36e00
> [ 0.000000] 37800 37800 - 379e0 379fe
> [ 0.000000] Initializing HighMem for node 0 (000379fe:0003f690)
> [ 0.000000] Memory: 1002124k/1038912k available (2104k kernel code,
> 26096k reserved, 1320k data, 376k init, 117320k highmem)
> [ 0.000000] virtual kernel memory layout:
> [ 0.000000] fixmap : 0xffd36000 - 0xfffff000 (2852 kB)
> [ 0.000000] pkmap : 0xffa00000 - 0xffc00000 (2048 kB)
> [ 0.000000] vmalloc : 0xf81fe000 - 0xff9fe000 ( 120 MB)
> [ 0.000000] lowmem : 0xc0000000 - 0xf79fe000 ( 889 MB)
> [ 0.000000] .init : 0xc0459000 - 0xc04b7000 ( 376 kB)
> [ 0.000000] .data : 0xc030e275 - 0xc0458284 (1320 kB)
> [ 0.000000] .text : 0xc0100000 - 0xc030e275 (2104 kB)
> [ 0.000000] Checking if this processor honours the WP bit even in
> supervisor mode...Ok.
> [ 0.000000] SLUB: Genslabs=3D14, HWalign=3D64, Order=3D0-3, MinObjects=3D=
0,
> CPUs=3D4, Nodes=3D16
> [ 0.000000] Hierarchical RCU implementation.
> [ 0.000000] NR_IRQS:2304 nr_irqs:440
> [ 0.000000] Extended CMOS year: 2000
> [ 0.000000] Console: colour VGA+ 80x25
> [ 0.000000] console [tty0] enabled
> [ 0.000000] allocated 5242880 bytes of page_cgroup
> [ 0.000000] please try 'cgroup_disable=3Dmemory' option if you don't
> want memory cgroups
> [ 0.000000] hpet clockevent registered
> [ 0.000000] Fast TSC calibration using PIT
> [ 0.000000] Detected 3250.042 MHz processor.
> [ 0.001004] Calibrating delay loop (skipped), value calculated using
> timer frequency.. 6500.08 BogoMIPS (lpj=3D3250042)
> [ 0.001175] Security Framework initialized
> [ 0.001254] TOMOYO Linux initialized
> [ 0.001335] Mount-cache hash table entries: 512
> [ 0.002096] Initializing cgroup subsys ns
> [ 0.002174] Initializing cgroup subsys cpuacct
> [ 0.002252] Initializing cgroup subsys memory
> [ 0.002339] Initializing cgroup subsys devices
> [ 0.002416] Initializing cgroup subsys freezer
> [ 0.002493] Initializing cgroup subsys net_cls
> [ 0.002570] Initializing cgroup subsys blkio
> [ 0.002667] CPU: Physical Processor ID: 0
> [ 0.002743] CPU: Processor Core ID: 0
> [ 0.002820] mce: CPU supports 6 MCE banks
> [ 0.002899] CPU0: Thermal monitoring enabled (TM2)
> [ 0.003003] using mwait in idle threads.
> [ 0.003083] Performance Events: Core2 events, Intel PMU driver.
> [ 0.003198] ... version: 2
> [ 0.003274] ... bit width: 40
> [ 0.003349] ... generic registers: 2
> [ 0.003425] ... value mask: 000000ffffffffff
> [ 0.003503] ... max period: 000000007fffffff
> [ 0.003581] ... fixed-purpose events: 3
> [ 0.003656] ... event mask: 0000000700000003
> [ 0.003735] Checking 'hlt' instruction... OK.
> [ 0.008321] ACPI: Core revision 20100121
> [ 0.016042] Enabling APIC mode: Flat. Using 1 I/O APICs
> [ 0.016259] Mapping cpu 0 to node 0
> [ 0.016500] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D-1
> [ 0.026799] CPU0: Intel Pentium(R) Dual-Core CPU E5200 @ 2.50GHz stepping
>  06 [ 0.026999] Booting Node 0, Processors #1
> [ 0.001999] Initializing CPU#1
> [ 0.001999] Mapping cpu 1 to node 0
> [ 0.098010] Brought up 2 CPUs
> [ 0.099001] Total of 2 processors activated (12999.71 BogoMIPS).
> [ 0.100488] devtmpfs: initialized
> [ 0.100591] regulator: core version 0.5
> [ 0.101029] NET: Registered protocol family 16
> [ 0.101114] ACPI: bus type pci registered
> [ 0.101114] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem
> 0xf0000000-0xf3ffffff] (base 0xf0000000)
> [ 0.101167] PCI: not using MMCONFIG
> [ 0.101356] PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=3D3
> [ 0.101435] PCI: Using configuration type 1 for base access
> [ 0.102018] bio: create slab <bio-0> at 0
> [ 0.103660] ACPI: EC: Look up EC in DSDT
> [ 0.104683] ACPI: Executed 1 blocks of module-level executable AML code
> [ 0.109966] ACPI: SSDT 3f6a00f0 00190 (v01 AMI CPU1PM 00000001 INTL
>  20060113) [ 0.110484] ACPI: SSDT 3f6a0280 00143 (v01 AMI CPU2PM 00000001
>  INTL 20060113) [ 0.110886] ACPI: Interpreter enabled
> [ 0.111006] ACPI: (supports S0 S1 S3 S4 S5)
> [ 0.111180] ACPI: Using IOAPIC for interrupt routing
> [ 0.111289] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem
> 0xf0000000-0xf3ffffff] (base 0xf0000000)
> [ 0.112724] PCI: MMCONFIG at [mem 0xf0000000-0xf3ffffff] reserved in
> ACPI motherboard resources
> [ 0.112860] PCI: Using MMCONFIG for extended config space
> [ 0.119109] ACPI: No dock devices found.
> [ 0.119186] PCI: Using host bridge windows from ACPI; if necessary,
> use "pci=3Dnocrs" and report a bug
> [ 0.120055] ACPI: PCI Root Bridge [PCI0] (0000:00)
> [ 0.120153] pci_root PNP0A08:00: host bridge window [io 0x0000-0x0cf7]
> [ 0.120234] pci_root PNP0A08:00: host bridge window [io 0x0d00-0xffff]
> [ 0.120315] pci_root PNP0A08:00: host bridge window [mem
>  0x000a0000-0x000bffff] [ 0.120448] pci_root PNP0A08:00: host bridge wind=
ow
>  [mem 0x000d0000-0x000dffff] [ 0.120581] pci_root PNP0A08:00: host bridge
>  window [mem 0x3f700000-0xffffffff] [ 0.120754] pci 0000:00:02.0: reg 10:
>  [mem 0xfe980000-0xfe9fffff]
> [ 0.120757] pci 0000:00:02.0: reg 14: [io 0xcc00-0xcc07]
> [ 0.120760] pci 0000:00:02.0: reg 18: [mem 0xe0000000-0xefffffff pref]
> [ 0.120763] pci 0000:00:02.0: reg 1c: [mem 0xfe800000-0xfe8fffff]
> [ 0.120840] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
> [ 0.121023] pci 0000:00:1c.0: PME# disabled
> [ 0.121089] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
> [ 0.121092] pci 0000:00:1c.1: PME# disabled
> [ 0.121130] pci 0000:00:1d.0: reg 20: [io 0xc400-0xc41f]
> [ 0.121167] pci 0000:00:1d.1: reg 20: [io 0xc480-0xc49f]
> [ 0.121204] pci 0000:00:1d.2: reg 20: [io 0xc800-0xc81f]
> [ 0.121241] pci 0000:00:1d.3: reg 20: [io 0xc880-0xc89f]
> [ 0.121277] pci 0000:00:1d.7: reg 10: [mem 0xfe97bc00-0xfe97bfff]
> [ 0.121318] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
> [ 0.121321] pci 0000:00:1d.7: PME# disabled
> [ 0.121413] pci 0000:00:1f.0: quirk: [io 0x0800-0x087f] claimed by
> ICH6 ACPI/GPIO/TCO
> [ 0.121548] pci 0000:00:1f.0: quirk: [io 0x0480-0x04bf] claimed by ICH6
>  GPIO [ 0.121632] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at
>  0294 (mask 0003)
> [ 0.121797] pci 0000:00:1f.1: reg 10: [io 0x0000-0x0007]
> [ 0.121801] pci 0000:00:1f.1: reg 14: [io 0x0000-0x0003]
> [ 0.121806] pci 0000:00:1f.1: reg 18: [io 0x08f0-0x08f7]
> [ 0.121811] pci 0000:00:1f.1: reg 1c: [io 0x08f8-0x08fb]
> [ 0.121816] pci 0000:00:1f.1: reg 20: [io 0xffa0-0xffaf]
> [ 0.121844] pci 0000:00:1f.2: reg 10: [io 0xc080-0xc087]
> [ 0.121848] pci 0000:00:1f.2: reg 14: [io 0xc000-0xc003]
> [ 0.121852] pci 0000:00:1f.2: reg 18: [io 0xbc00-0xbc07]
> [ 0.121857] pci 0000:00:1f.2: reg 1c: [io 0xb880-0xb883]
> [ 0.121861] pci 0000:00:1f.2: reg 20: [io 0xb800-0xb80f]
> [ 0.121879] pci 0000:00:1f.2: PME# supported from D3hot
> [ 0.121881] pci 0000:00:1f.2: PME# disabled
> [ 0.121917] pci 0000:00:1f.3: reg 20: [io 0x0400-0x041f]
> [ 0.121967] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
> [ 0.122002] pci 0000:00:1c.0: bridge window [io f000 - 0000] reg reading
> [ 0.122005] pci 0000:00:1c.0: bridge window [mem 0xfff00000 -
> 0x000fffff] reg reading
> [ 0.122010] pci 0000:00:1c.0: bridge window [mem 0xfff00000 - 000fffff
> pref] reg reading
> [ 0.122066] pci 0000:01:00.0: reg 10: [io 0xd800-0xd8ff]
> [ 0.122083] pci 0000:01:00.0: reg 18: [mem 0xfdfff000-0xfdffffff 64bit
>  pref] [ 0.122095] pci 0000:01:00.0: reg 20: [mem 0xfdfe0000-0xfdfeffff
>  64bit pref] [ 0.122102] pci 0000:01:00.0: reg 30: [mem
>  0xfeaf0000-0xfeafffff pref] [ 0.122136] pci 0000:01:00.0: supports D1 D2
> [ 0.122137] pci 0000:01:00.0: PME# supported from D0 D1 D2 D3hot D3cold
> [ 0.122141] pci 0000:01:00.0: PME# disabled
> [ 0.124017] pci 0000:00:1c.1: PCI bridge to [bus 01-01]
> [ 0.124108] pci 0000:00:1c.1: bridge window [io 0xd000-0xdfff]
> [ 0.124111] pci 0000:00:1c.1: bridge window [mem 0xfea00000-0xfeafffff]
> [ 0.124116] pci 0000:00:1c.1: bridge window [mem 0xfdf00000-0xfdffffff
> 64bit pref]
> [ 0.124152] pci 0000:03:00.0: reg 10: [io 0xe800-0xe8ff]
> [ 0.124192] pci 0000:03:00.0: supports D1 D2
> [ 0.124215] pci 0000:03:01.0: reg 10: [io 0xec00-0xec7f]
> [ 0.124220] pci 0000:03:01.0: reg 14: [mem 0xfebffc00-0xfebffc7f]
> [ 0.124240] pci 0000:03:01.0: reg 30: [mem 0xfebc0000-0xfebdffff pref]
> [ 0.124256] pci 0000:03:01.0: supports D1 D2
> [ 0.124257] pci 0000:03:01.0: PME# supported from D1 D2 D3hot
> [ 0.124260] pci 0000:03:01.0: PME# disabled
> [ 0.124296] pci 0000:00:1e.0: PCI bridge to [bus 03-03] (subtractive
>  decode) [ 0.124379] pci 0000:00:1e.0: bridge window [io 0xe000-0xefff]
> [ 0.124382] pci 0000:00:1e.0: bridge window [mem 0xfeb00000-0xfebfffff]
> [ 0.124386] pci 0000:00:1e.0: bridge window [mem 0xfff00000 - 000fffff
> pref] reg reading
> [ 0.124388] pci 0000:00:1e.0: bridge window [io 0x0000-0x0cf7]
> (subtractive decode)
> [ 0.124390] pci 0000:00:1e.0: bridge window [io 0x0d00-0xffff]
> (subtractive decode)
> [ 0.124391] pci 0000:00:1e.0: bridge window [mem
> 0x000a0000-0x000bffff] (subtractive decode)
> [ 0.124393] pci 0000:00:1e.0: bridge window [mem
> 0x000d0000-0x000dffff] (subtractive decode)
> [ 0.124395] pci 0000:00:1e.0: bridge window [mem
> 0x3f700000-0xffffffff] (subtractive decode)
> [ 0.124408] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
> [ 0.124511] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
> [ 0.124580] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
> [ 0.124622] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P5._PRT]
> [ 0.130404] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 *10 11 12 14
>  15) [ 0.131027] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 *11 12
>  14 15) [ 0.131382] ACPI: PCI Interrupt Link [LNKC] (IRQs *3 4 5 6 7 10 11
>  12 14 15) [ 0.131732] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10
>  *11 12 14 15) [ 0.132068] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7
>  10 11 12 14 15) *0, disabled.
> [ 0.132506] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12
> 14 15) *0, disabled.
> [ 0.132943] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12
> 14 15) *0, disabled.
> [ 0.133403] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 *5 6 7 10 11 12 14
>  15) [ 0.133717] vgaarb: device added:
> PCI:0000:00:02.0,decodes=3Dio+mem,owns=3Dio+mem,locks=3Dnone
> [ 0.133717] vgaarb: loaded
> [ 0.134018] PCI: Using ACPI for IRQ routing
> [ 0.134084] PCI: pci_cache_line_size set to 64 bytes
> [ 0.134134] reserve RAM buffer: 000000000009fc00 - 000000000009ffff
> [ 0.134136] reserve RAM buffer: 000000003f690000 - 000000003fffffff
> [ 0.134148] HPET: 3 timers in total, 0 timers will be used for per-cpu
>  timer [ 0.134148] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
> [ 0.134254] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
> [ 0.137009] Switching to clocksource tsc
> [ 0.137097] pnp: PnP ACPI init
> [ 0.137130] ACPI: bus type pnp registered
> [ 0.140079] pnp: PnP ACPI: found 18 devices
> [ 0.140156] ACPI: ACPI bus type pnp unregistered
> [ 0.140237] system 00:01: [mem 0xfed14000-0xfed19fff] has been reserved
> [ 0.140322] system 00:07: [io 0x0290-0x0297] has been reserved
> [ 0.140403] system 00:08: [io 0x04d0-0x04d1] has been reserved
> [ 0.140483] system 00:08: [io 0x0800-0x087f] has been reserved
> [ 0.140563] system 00:08: [io 0x0480-0x04bf] has been reserved
> [ 0.140642] system 00:08: [mem 0xfed1c000-0xfed1ffff] has been reserved
> [ 0.140723] system 00:08: [mem 0xfed20000-0xfed8ffff] has been reserved
> [ 0.140807] system 00:0b: [mem 0xffc00000-0xffefffff] has been reserved
> [ 0.140892] system 00:0c: [mem 0xfec00000-0xfec00fff] could not be reserv=
ed
> [ 0.140975] system 00:0c: [mem 0xfee00000-0xfee00fff] has been reserved
> [ 0.141058] system 00:10: [mem 0xf0000000-0xf3ffffff] has been reserved
> [ 0.141141] system 00:11: [mem 0x00000000-0x0009ffff] could not be reserv=
ed
> [ 0.141223] system 00:11: [mem 0x000c0000-0x000cffff] could not be reserv=
ed
> [ 0.141305] system 00:11: [mem 0x000e0000-0x000fffff] could not be reserv=
ed
> [ 0.141387] system 00:11: [mem 0x00100000-0x3f6fffff] could not be reserv=
ed
> [ 0.176294] PCI: max bus depth: 1 pci_try_num: 2
> [ 0.176313] pci 0000:00:1c.0: BAR 14: assigned [mem 0x3f700000-0x3f8fffff]
> [ 0.176396] pci 0000:00:1c.0: BAR 15: assigned [mem
> 0x3f900000-0x3fafffff 64bit pref]
> [ 0.176530] pci 0000:00:1c.0: BAR 13: assigned [io 0x1000-0x1fff]
> [ 0.176610] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
> [ 0.176689] pci 0000:00:1c.0: bridge window [io 0x1000-0x1fff]
> [ 0.176771] pci 0000:00:1c.0: bridge window [mem 0x3f700000-0x3f8fffff]
> [ 0.176854] pci 0000:00:1c.0: bridge window [mem 0x3f900000-0x3fafffff
> 64bit pref]
> [ 0.176992] pci 0000:00:1c.1: PCI bridge to [bus 01-01]
> [ 0.177071] pci 0000:00:1c.1: bridge window [io 0xd000-0xdfff]
> [ 0.177153] pci 0000:00:1c.1: bridge window [mem 0xfea00000-0xfeafffff]
> [ 0.177236] pci 0000:00:1c.1: bridge window [mem 0xfdf00000-0xfdffffff
> 64bit pref]
> [ 0.177372] pci 0000:00:1e.0: PCI bridge to [bus 03-03]
> [ 0.177451] pci 0000:00:1e.0: bridge window [io 0xe000-0xefff]
> [ 0.177533] pci 0000:00:1e.0: bridge window [mem 0xfeb00000-0xfebfffff]
> [ 0.177615] pci 0000:00:1e.0: bridge window [mem pref disabled]
> [ 0.177702] pci 0000:00:1c.0: enabling device (0104 -> 0107)
> [ 0.177782] alloc irq_desc for 16 on node -1
> [ 0.177783] alloc kstat_irqs on node -1
> [ 0.177787] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [ 0.177870] pci 0000:00:1c.0: setting latency timer to 64
> [ 0.177877] alloc irq_desc for 17 on node -1
> [ 0.177878] alloc kstat_irqs on node -1
> [ 0.177881] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
> [ 0.177963] pci 0000:00:1c.1: setting latency timer to 64
> [ 0.177968] pci 0000:00:1e.0: setting latency timer to 64
> [ 0.177970] pci_bus 0000:00: resource 4 [io 0x0000-0x0cf7]
> [ 0.177972] pci_bus 0000:00: resource 5 [io 0x0d00-0xffff]
> [ 0.177973] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
> [ 0.177974] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000dffff]
> [ 0.177976] pci_bus 0000:00: resource 8 [mem 0x3f700000-0xffffffff]
> [ 0.177977] pci_bus 0000:02: resource 0 [io 0x1000-0x1fff]
> [ 0.177979] pci_bus 0000:02: resource 1 [mem 0x3f700000-0x3f8fffff]
> [ 0.177980] pci_bus 0000:02: resource 2 [mem 0x3f900000-0x3fafffff 64bit
>  pref] [ 0.177982] pci_bus 0000:01: resource 0 [io 0xd000-0xdfff]
> [ 0.177983] pci_bus 0000:01: resource 1 [mem 0xfea00000-0xfeafffff]
> [ 0.177985] pci_bus 0000:01: resource 2 [mem 0xfdf00000-0xfdffffff 64bit
>  pref] [ 0.177987] pci_bus 0000:03: resource 0 [io 0xe000-0xefff]
> [ 0.177988] pci_bus 0000:03: resource 1 [mem 0xfeb00000-0xfebfffff]
> [ 0.177990] pci_bus 0000:03: resource 4 [io 0x0000-0x0cf7]
> [ 0.177991] pci_bus 0000:03: resource 5 [io 0x0d00-0xffff]
> [ 0.177992] pci_bus 0000:03: resource 6 [mem 0x000a0000-0x000bffff]
> [ 0.177994] pci_bus 0000:03: resource 7 [mem 0x000d0000-0x000dffff]
> [ 0.177995] pci_bus 0000:03: resource 8 [mem 0x3f700000-0xffffffff]
> [ 0.178012] NET: Registered protocol family 2
> [ 0.178124] IP route cache hash table entries: 32768 (order: 5, 131072
>  bytes) [ 0.178343] TCP established hash table entries: 131072 (order: 8,
>  1048576 bytes) [ 0.178788] TCP bind hash table entries: 65536 (order: 7,
>  524288 bytes) [ 0.179037] TCP: Hash tables configured (established 131072
>  bind 65536) [ 0.179118] TCP reno registered
> [ 0.179193] UDP hash table entries: 512 (order: 2, 16384 bytes)
> [ 0.179277] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
> [ 0.179420] pci 0000:00:02.0: Boot video device
> [ 0.179508] PCI: CLS 32 bytes, default 64
> [ 0.179539] Unpacking initramfs...
> [ 0.387149] Freeing initrd memory: 10388k freed
> [ 0.391940] highmem bounce pool size: 64 pages
> [ 0.392024] HugeTLB registered 2 MB page size, pre-allocated 0 pages
> [ 0.393947] VFS: Disk quotas dquot_6.5.2
> [ 0.394070] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
> [ 0.394221] msgmni has been set to 1748
> [ 0.394419] alg: No test for stdrng (krng)
> [ 0.394557] Block layer SCSI generic (bsg) driver version 0.4 loaded (maj=
or
>  254) [ 0.394696] io scheduler noop registered
> [ 0.394812] io scheduler cfq registered (default)
> [ 0.395001] pcieport 0000:00:1c.0: setting latency timer to 64
> [ 0.395026] alloc irq_desc for 24 on node -1
> [ 0.395028] alloc kstat_irqs on node -1
> [ 0.395036] pcieport 0000:00:1c.0: irq 24 for MSI/MSI-X
> [ 0.395133] pcieport 0000:00:1c.1: setting latency timer to 64
> [ 0.395157] alloc irq_desc for 25 on node -1
> [ 0.395158] alloc kstat_irqs on node -1
> [ 0.395163] pcieport 0000:00:1c.1: irq 25 for MSI/MSI-X
> [ 0.395291] pcieport 0000:00:1c.0: Requesting control of PCIe PME from AC=
PI
>  BIOS [ 0.395436] pcieport 0000:00:1c.0: Failed to receive control of PCIe
>  PME service: no _OSC support
> [ 0.395577] pcie_pme: probe of 0000:00:1c.0:pcie01 failed with error -13
> [ 0.395659] pcieport 0000:00:1c.1: Requesting control of PCIe PME from AC=
PI
>  BIOS [ 0.395793] pcieport 0000:00:1c.1: Failed to receive control of PCIe
>  PME service: no _OSC support
> [ 0.395938] pcie_pme: probe of 0000:00:1c.1:pcie01 failed with error -13
> [ 0.398206] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> [ 0.398382] serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
> [ 0.398829] 00:0f: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
> [ 0.399052] Fixed MDIO Bus: probed
> [ 0.399188] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at
> 0x60,0x64 irq 1,12
> [ 0.402247] serio: i8042 KBD port at 0x60,0x64 irq 1
> [ 0.402327] serio: i8042 AUX port at 0x60,0x64 irq 12
> [ 0.402493] mice: PS/2 mouse device common for all mice
> [ 0.402603] cpuidle: using governor ladder
> [ 0.402681] cpuidle: using governor menu
> [ 0.402906] TCP htcp registered
> [ 0.403007] Using IPI No-Shortcut mode
> [ 0.403173] registered taskstats version 1
> [ 0.403454] Freeing unused kernel memory: 376k freed
> [ 0.421299] input: AT Translated Set 2 keyboard as
> /devices/platform/i8042/serio0/input/input0
> [ 0.476412] device-mapper: uevent: version 1.0.3
> [ 0.476653] device-mapper: ioctl: 4.17.0-ioctl (2010-03-05)
> initialised: dm-devel@redhat.com
> [ 0.485085] NET: Registered protocol family 1
> [ 0.559625] usbcore: registered new interface driver usbfs
> [ 0.559780] usbcore: registered new interface driver hub
> [ 0.560715] usbcore: registered new device driver usb
> [ 0.561500] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
> [ 0.561612] r8169 0000:01:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> [ 0.561719] r8169 0000:01:00.0: (unregistered net_device): using 64-bit D=
MA
> [ 0.562280] r8169 0000:01:00.0: setting latency timer to 64
> [ 0.562317] alloc irq_desc for 26 on node -1
> [ 0.562319] alloc kstat_irqs on node -1
> [ 0.562330] r8169 0000:01:00.0: irq 26 for MSI/MSI-X
> [ 0.562476] r8169 0000:01:00.0: eth0: RTL8102e at 0xf834e000,
> 00:24:8c:19:66:60, XID 04a00000 IRQ 26
> [ 0.563350] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> [ 0.563453] alloc irq_desc for 23 on node -1
> [ 0.563454] alloc kstat_irqs on node -1
> [ 0.563458] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ
>  23 [ 0.563552] ehci_hcd 0000:00:1d.7: setting latency timer to 64
> [ 0.563554] ehci_hcd 0000:00:1d.7: EHCI Host Controller
> [ 0.563642] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus
>  number 1 [ 0.563798] ehci_hcd 0000:00:1d.7: using broken periodic
>  workaround [ 0.563897] ehci_hcd 0000:00:1d.7: debug port 1
> [ 0.567875] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
> [ 0.567889] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfe97bc00
> [ 0.577461] SCSI subsystem initialized
> [ 0.577852] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
> [ 0.577961] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=3D=
0002
> [ 0.579678] usb usb1: New USB device strings: Mfr=3D3, Product=3D2,
>  SerialNumber=3D1 [ 0.579813] usb usb1: Product: EHCI Host Controller
> [ 0.579891] usb usb1: Manufacturer: Linux
> 2.6.34-rc1-next-20100312.m-desktop+ ehci_hcd
> [ 0.580025] usb usb1: SerialNumber: 0000:00:1d.7
> [ 0.580221] hub 1-0:1.0: USB hub found
> [ 0.580298] hub 1-0:1.0: 8 ports detected
> [ 0.588334] libata version 3.00 loaded.
> [ 0.589820] 3c59x 0000:03:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [ 0.589930] 3c59x: Donald Becker and others.
> [ 0.590027] 0000:03:01.0: 3Com PCI 3c905B Cyclone 100baseTx at f8474c00.
> [ 0.593456] ata_piix 0000:00:1f.1: version 2.13
> [ 0.593466] alloc irq_desc for 18 on node -1
> [ 0.593467] alloc kstat_irqs on node -1
> [ 0.593472] ata_piix 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ
>  18 [ 0.593579] ata_piix 0000:00:1f.1: setting latency timer to 64
> [ 0.593624] scsi0 : ata_piix
> [ 0.593780] scsi1 : ata_piix
> [ 0.594809] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq =
14
> [ 0.594896] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq =
15
> [ 0.594991] alloc irq_desc for 19 on node -1
> [ 0.594992] alloc kstat_irqs on node -1
> [ 0.594995] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ
>  19 [ 0.595082] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
> [ 0.595268] ata_piix 0000:00:1f.2: setting latency timer to 64
> [ 0.595436] scsi2 : ata_piix
> [ 0.595650] scsi3 : ata_piix
> [ 0.596915] ata3: SATA max UDMA/133 cmd 0xc080 ctl 0xc000 bmdma 0xb800 irq
>  19 [ 0.597002] ata4: SATA max UDMA/133 cmd 0xbc00 ctl 0xb880 bmdma 0xb808
>  irq 19 [ 0.668868] uhci_hcd: USB Universal Host Controller Interface
>  driver [ 0.668979] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, lo=
w)
>  -> IRQ 23 [ 0.669067] uhci_hcd 0000:00:1d.0: setting latency timer to 64
> [ 0.669069] uhci_hcd 0000:00:1d.0: UHCI Host Controller
> [ 0.669152] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus
>  number 2 [ 0.669307] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000c400
> [ 0.669411] usb usb2: New USB device found, idVendor=3D1d6b, idProduct=3D=
0001
> [ 0.669492] usb usb2: New USB device strings: Mfr=3D3, Product=3D2,
>  SerialNumber=3D1 [ 0.669624] usb usb2: Product: UHCI Host Controller
> [ 0.669701] usb usb2: Manufacturer: Linux
> 2.6.34-rc1-next-20100312.m-desktop+ uhci_hcd
> [ 0.669838] usb usb2: SerialNumber: 0000:00:1d.0
> [ 0.670021] hub 2-0:1.0: USB hub found
> [ 0.670098] hub 2-0:1.0: 2 ports detected
> [ 0.670215] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ
>  19 [ 0.670299] uhci_hcd 0000:00:1d.1: setting latency timer to 64
> [ 0.670301] uhci_hcd 0000:00:1d.1: UHCI Host Controller
> [ 0.670382] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus
>  number 3 [ 0.670532] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000c480
> [ 0.670630] usb usb3: New USB device found, idVendor=3D1d6b, idProduct=3D=
0001
> [ 0.670711] usb usb3: New USB device strings: Mfr=3D3, Product=3D2,
>  SerialNumber=3D1 [ 0.670855] usb usb3: Product: UHCI Host Controller
> [ 0.670932] usb usb3: Manufacturer: Linux
> 2.6.34-rc1-next-20100312.m-desktop+ uhci_hcd
> [ 0.671066] usb usb3: SerialNumber: 0000:00:1d.1
> [ 0.671234] hub 3-0:1.0: USB hub found
> [ 0.671311] hub 3-0:1.0: 2 ports detected
> [ 0.671421] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ
>  18 [ 0.671505] uhci_hcd 0000:00:1d.2: setting latency timer to 64
> [ 0.671507] uhci_hcd 0000:00:1d.2: UHCI Host Controller
> [ 0.671586] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus
>  number 4 [ 0.671740] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000c800
> [ 0.671842] usb usb4: New USB device found, idVendor=3D1d6b, idProduct=3D=
0001
> [ 0.671923] usb usb4: New USB device strings: Mfr=3D3, Product=3D2,
>  SerialNumber=3D1 [ 0.672054] usb usb4: Product: UHCI Host Controller
> [ 0.672131] usb usb4: Manufacturer: Linux
> 2.6.34-rc1-next-20100312.m-desktop+ uhci_hcd
> [ 0.672263] usb usb4: SerialNumber: 0000:00:1d.2
> [ 0.672432] hub 4-0:1.0: USB hub found
> [ 0.672508] hub 4-0:1.0: 2 ports detected
> [ 0.672616] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ
>  16 [ 0.672701] uhci_hcd 0000:00:1d.3: setting latency timer to 64
> [ 0.672703] uhci_hcd 0000:00:1d.3: UHCI Host Controller
> [ 0.672782] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus
>  number 5 [ 0.672938] uhci_hcd 0000:00:1d.3: irq 16, io base 0x0000c880
> [ 0.673036] usb usb5: New USB device found, idVendor=3D1d6b, idProduct=3D=
0001
> [ 0.673117] usb usb5: New USB device strings: Mfr=3D3, Product=3D2,
>  SerialNumber=3D1 [ 0.673250] usb usb5: Product: UHCI Host Controller
> [ 0.673327] usb usb5: Manufacturer: Linux
> 2.6.34-rc1-next-20100312.m-desktop+ uhci_hcd
> [ 0.673461] usb usb5: SerialNumber: 0000:00:1d.3
> [ 0.673631] hub 5-0:1.0: USB hub found
> [ 0.673708] hub 5-0:1.0: 2 ports detected
> [ 0.798453] ata3.00: ATA-8: ST3160813AS, CC2F, max UDMA/133
> [ 0.798549] ata3.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 0/32)
> [ 0.801876] ata4.00: ATA-7: ST380815AS, 3.AAC, max UDMA/133
> [ 0.801968] ata4.00: 156301488 sectors, multi 16: LBA48 NCQ (depth 0/32)
> [ 0.829143] ata3.01: ATA-7: ST3200820AS, 3.AAC, max UDMA/133
> [ 0.829235] ata3.01: 390721968 sectors, multi 16: LBA48 NCQ (depth 0/32)
> [ 0.876870] ata4.00: configured for UDMA/133
> [ 0.878443] ata3.00: configured for UDMA/133
> [ 0.912467] ata3.01: configured for UDMA/133
> [ 0.912623] scsi 2:0:0:0: Direct-Access ATA ST3160813AS CC2F PQ: 0 ANSI: 5
> [ 0.912936] scsi 2:0:1:0: Direct-Access ATA ST3200820AS 3.AA PQ: 0 ANSI: 5
> [ 0.913167] scsi 3:0:0:0: Direct-Access ATA ST380815AS 3.AA PQ: 0 ANSI: 5
> [ 0.919485] sd 2:0:0:0: [sda] 312581808 512-byte logical blocks: (160
> GB/149 GiB)
> [ 0.919524] sd 2:0:1:0: [sdb] 390721968 512-byte logical blocks: (200
> GB/186 GiB)
> [ 0.919559] sd 2:0:1:0: [sdb] Write Protect is off
> [ 0.919560] sd 2:0:1:0: [sdb] Mode Sense: 00 3a 00 00
> [ 0.919575] sd 2:0:1:0: [sdb] Write cache: enabled, read cache:
> enabled, doesn't support DPO or FUA
> [ 0.919664] sdb:
> [ 0.919799] sd 3:0:0:0: [sdc] 156301488 512-byte logical blocks: (80.0
> GB/74.5 GiB)
> [ 0.919831] sd 3:0:0:0: [sdc] Write Protect is off
> [ 0.919833] sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
> [ 0.919847] sd 3:0:0:0: [sdc] Write cache: enabled, read cache:
> enabled, doesn't support DPO or FUA
> [ 0.919928] sdc: sdc1
> [ 0.941845] sd 3:0:0:0: [sdc] Attached SCSI disk
> [ 0.952127] sdb1
> [ 0.952172] sd 2:0:0:0: [sda] Write Protect is off
> [ 0.952175] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [ 0.952199] sd 2:0:0:0: [sda] Write cache: enabled, read cache:
> enabled, doesn't support DPO or FUA
> [ 0.952523] sda: sda1 sda2 < sda5
> [ 0.990995] sd 2:0:1:0: [sdb] Attached SCSI disk
> [ 0.991155] sda6 >
> [ 0.991545] sd 2:0:0:0: [sda] Attached SCSI disk
> [ 1.077018] usb 2-2: new low speed USB device using uhci_hcd and address 2
> [ 1.241406] usb 2-2: New USB device found, idVendor=3D046d, idProduct=3Dc=
03e
> [ 1.241504] usb 2-2: New USB device strings: Mfr=3D1, Product=3D2,
>  SerialNumber=3D0 [ 1.241589] usb 2-2: Product: USB-PS/2 Optical Mouse
> [ 1.241668] usb 2-2: Manufacturer: Logitech
> [ 1.250629] usbcore: registered new interface driver hiddev
> [ 1.263600] input: Logitech USB-PS/2 Optical Mouse as
> /devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.0/input/input1
> [ 1.263821] generic-usb 0003:046D:C03E.0001: input,hidraw0: USB HID
> v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on
> usb-0000:00:1d.0-2/input0
> [ 1.264032] usbcore: registered new interface driver usbhid
> [ 1.264114] usbhid: USB HID core driver
> [ 5.676584] PM: Starting manual resume from disk
> [ 5.701045] EXT4-fs (dm-1): INFO: recovery required on readonly filesystem
> [ 5.701169] EXT4-fs (dm-1): write access will be enabled during recovery
> [ 5.725373] EXT4-fs (dm-1): recovery complete
> [ 5.726666] EXT4-fs (dm-1): mounted filesystem with ordered data mode
> [ 5.898541] Not activating Mandatory Access Control now since
> /sbin/tomoyo-init doesn't exist.
> [ 8.046277] udev: starting version 151
> [ 8.446274] input: Power Button as
> /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input2
> [ 8.446485] ACPI: Power Button [PWRB]
> [ 8.446603] input: Power Button as
>  /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3 [ 8.446745] ACPI: Power
>  Button [PWRF]
> [ 8.460947] input: PC Speaker as /devices/platform/pcspkr/input/input4
> [ 8.573850] Linux agpgart interface v0.103
> [ 8.575283] rtc_cmos 00:03: RTC can wake from S4
> [ 8.575524] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
> [ 8.577902] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
> [ 8.578025] parport_pc 00:06: reported by Plug and Play ACPI
> [ 8.578212] parport0: PC-style at 0x378 (0x778), irq 7, dma 3
> [PCSPP,TRISTATE,COMPAT,EPP,ECP,DMA]
> [ 8.666940] i801_smbus 0000:00:1f.3: PCI INT B -> GSI 19 (level, low) ->
>  IRQ 19 [ 8.669225] intel_rng: FWH not detected
> [ 8.671997] agpgart-intel 0000:00:00.0: Intel G33 Chipset
> [ 8.672696] agpgart-intel 0000:00:00.0: detected 7164K stolen memory
> [ 8.681275] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xe0000000
> [ 8.924151] leds_ss4200: no LED devices found
> [ 9.391152] [drm] Initialized drm 1.1.0 20060810
> [ 9.599001] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [ 9.599115] i915 0000:00:02.0: setting latency timer to 64
> [ 9.609078] alloc irq_desc for 27 on node -1
> [ 9.609080] alloc kstat_irqs on node -1
> [ 9.609087] i915 0000:00:02.0: irq 27 for MSI/MSI-X
> [ 9.609092] [drm] set up 7M of stolen space
> [ 9.609499] [drm] initialized overlay support
> [ 9.763604] fb0: inteldrmfb frame buffer device
> [ 9.763682] registered panic notifier
> [ 9.763813] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on min=
or
>  0 [ 10.084549] C-Media PCI 0000:03:00.0: PCI INT A -> GSI 19 (level, low)
>  -> IRQ 19
> [ 11.511493] loop: module loaded
> [ 24.500316] fuse init (API version 7.13)
> [ 24.828324] kjournald starting. Commit interval 5 seconds
> [ 24.828462] EXT3-fs (dm-4): warning: maximal mount count reached,
> running e2fsck is recommended
> [ 24.829020] EXT3-fs (dm-4): using internal journal
> [ 24.829149] EXT3-fs (dm-4): mounted filesystem with writeback data mode
> [ 24.908702] kjournald starting. Commit interval 5 seconds
> [ 24.909647] EXT3-fs (sda1): using internal journal
> [ 24.909775] EXT3-fs (sda1): mounted filesystem with writeback data mode
> [ 24.940042] EXT4-fs (sdb1): mounted filesystem with ordered data mode
> [ 24.993583] Adding 2715644k swap on /dev/mapper/ckopnuo-swap_1.
> Priority:-1 extents:1 across:2715644k
> [ 26.815505] IPv4 FIB: Using LC-trie version 0.409
> [ 26.993789] r8169 0000:01:00.0: eth0: link up
> [ 26.993872] r8169 0000:01:00.0: eth0: link up
> [ 28.005011] NET: Registered protocol family 10
> [ 28.005392] lo: Disabled Privacy Extensions
> [ 38.195053] eth0: no IPv6 routers present
> [ 42.592798] eth1: setting half-duplex.
> [ 42.593032] ADDRCONF(NETDEV_UP): eth1: link is not ready
> [ 56.909839] RPC: Registered udp transport module.
> [ 56.909968] RPC: Registered tcp transport module.
> [ 56.910048] RPC: Registered tcp NFSv4.1 backchannel transport module.
> [ 56.964534] Slow work thread pool: Starting up
> [ 56.964643] Slow work thread pool: Ready
> [ 56.964781] FS-Cache: Loaded
> [ 57.004628] FS-Cache: Netfs 'nfs' registered for caching
> [ 57.046908] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
> [ 66.439904] Console: switching to colour frame buffer device 160x64
> [ 69.704014] ------------[ cut here ]------------
> [ 69.704026] WARNING: at net/sched/sch_generic.c:255
>  dev_watchdog+0xc6/0x12a() [ 69.704029] Hardware name: System Product Name
> [ 69.704031] NETDEV WATCHDOG: eth0 (r8169): transmit queue 0 timed out
> [ 69.704034] Modules linked in: fbcon fbdev tileblit font bitblit
> fbcon_rotate fbcon_cw fbcon_ud fbcon_ccw softcursor nfsd exportfs nfs
> lockd fscache nfs_acl auth_rpcgss sunrpc ipv6 ext3 jbd fuse
> dm_snapshot loop snd_cmipci gameport snd_pcm_oss snd_mixer_oss snd_pcm
> snd_page_alloc snd_opl3_lib snd_hwdep snd_mpu401_uart snd_seq_dummy
> snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq i915
> snd_timer drm_kms_helper snd_seq_device drm snd fb i2c_algo_bit
> soundcore cfbcopyarea video backlight led_class output intel_agp
> i2c_i801 cfbimgblt mac_hid rng_core parport_pc rtc_cmos agpgart
> rtc_core cfbfillrect i2c_core rtc_lib tpm_tis tpm evdev pcspkr parport
> asus_atk0110 processor button tpm_bios psmouse thermal serio_raw
> thermal_sys ext4 mbcache jbd2 crc16 sha256_generic aes_i586
> aes_generic cbc dm_crypt usbhid hid sd_mod crc_t10dif ata_generic
> uhci_hcd pata_acpi ata_piix 3c59x libata scsi_mod ehci_hcd r8169 mii
> usbcore nls_base unix dm_mirror dm_region_hash dm_log dm_mod [last
> unloaded: scsi_wait_scan]
> [ 69.704130] Pid: 0, comm: swapper Not tainted
> 2.6.34-rc1-next-20100312.m-desktop+ #6
> [ 69.704132] Call Trace:
> [ 69.704136] [<c0131822>] warn_slowpath_common+0x65/0x7c
> [ 69.704138] [<c02af666>] ? dev_watchdog+0xc6/0x12a
> [ 69.704140] [<c013186d>] warn_slowpath_fmt+0x24/0x27
> [ 69.704142] [<c02af666>] dev_watchdog+0xc6/0x12a
> [ 69.704145] [<c013a5bf>] ? mod_timer+0x1b/0x22
> [ 69.704160] [<f82e5cff>] ? usb_hcd_poll_rh_status+0x11c/0x124 [usbcore]
> [ 69.704163] [<c011463c>] ? apic_write+0xf/0x11
> [ 69.704166] [<c014cf3f>] ? clockevents_program_event+0xc6/0xd8
> [ 69.704168] [<c013a2d0>] run_timer_softirq+0x121/0x183
> [ 69.704170] [<c02af5a0>] ? dev_watchdog+0x0/0x12a
> [ 69.704173] [<c0136237>] __do_softirq+0x7b/0xf5
> [ 69.704175] [<c01362e2>] do_softirq+0x31/0x3c
> [ 69.704177] [<c01363e5>] irq_exit+0x29/0x5c
> [ 69.704179] [<c0114f25>] smp_apic_timer_interrupt+0x67/0x75
> [ 69.704182] [<c030d4b5>] apic_timer_interrupt+0x31/0x38
> [ 69.704185] [<c010928b>] ? mwait_idle+0x4b/0x56
> [ 69.704187] [<c0102371>] cpu_idle+0x91/0xac
> [ 69.704190] [<c02fc92b>] rest_init+0x67/0x69
> [ 69.704193] [<c045991f>] start_kernel+0x37c/0x381
> [ 69.704195] [<c04590aa>] i386_start_kernel+0xaa/0xb1
> [ 69.704196] ---[ end trace cf4fe9093736560a ]---
> [ 69.708056] r8169 0000:01:00.0: eth0: link up
> [ 101.321857] ip_tables: (C) 2000-2006 Netfilter Core Team
> [ 101.349221] nf_conntrack version 0.5.0 (15826 buckets, 63304 max)
> [ 101.349439] CONFIG_NF_CT_ACCT is deprecated and will be removed
> soon. Please use
> [ 101.349440] nf_conntrack.acct=3D1 kernel parameter, acct=3D1
> nf_conntrack module option or
> [ 101.349442] sysctl net.netfilter.nf_conntrack_acct=3D1 to enable it.
> [ 111.708053] r8169 0000:01:00.0: eth0: link up
> [ 171.708051] r8169 0000:01:00.0: eth0: link up
> [ 207.708054] r8169 0000:01:00.0: eth0: link up
> [ 268.443431] ksplashx[3110]: segfault at ff000320 ip 08057803 sp
> bfa3f000 error 6 in ksplashx[8048000+19000]
> [ 279.708054] r8169 0000:01:00.0: eth0: link up
> [ 316.004051] r8169 0000:01:00.0: eth0: link up
> [ 334.004051] r8169 0000:01:00.0: eth0: link up
> [ 346.004054] r8169 0000:01:00.0: eth0: link up
> [ 364.004052] r8169 0000:01:00.0: eth0: link up
> [ 382.004054] r8169 0000:01:00.0: eth0: link up
> [ 405.245565] eth1: setting half-duplex.
> [ 405.245718] ADDRCONF(NETDEV_UP): eth1: link is not ready
> [ 406.004052] r8169 0000:01:00.0: eth0: link up
> [ 418.004052] r8169 0000:01:00.0: eth0: link up
> [ 442.004052] r8169 0000:01:00.0: eth0: link up
> [ 466.005050] r8169 0000:01:00.0: eth0: link up
> [ 496.980590] r8169 0000:01:00.0: eth0: link up
> [ 507.079132] eth0: no IPv6 routers present
> [ 533.001056] r8169 0000:01:00.0: eth0: link up
> [ 563.001055] r8169 0000:01:00.0: eth0: link up
> [ 587.001058] r8169 0000:01:00.0: eth0: link up
> [ 611.001056] r8169 0000:01:00.0: eth0: link up
> [ 641.001056] r8169 0000:01:00.0: eth0: link up
> [ 659.001056] r8169 0000:01:00.0: eth0: link up
> [ 683.001056] r8169 0000:01:00.0: eth0: link up
> [ 701.001178] r8169 0000:01:00.0: eth0: link up
> [ 725.001177] r8169 0000:01:00.0: eth0: link up
> [ 749.001055] r8169 0000:01:00.0: eth0: link up
> [ 773.001056] r8169 0000:01:00.0: eth0: link up
> [ 776.572426] r8169 0000:01:00.0: PCI INT A disabled
> [ 790.205284] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
> [ 790.205306] r8169 0000:01:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ
>  17 [ 790.205326] r8169 0000:01:00.0: (unregistered net_device): using
>  64-bit DMA [ 790.205353] r8169 0000:01:00.0: setting latency timer to 64
> [ 790.205400] r8169 0000:01:00.0: irq 26 for MSI/MSI-X
> [ 790.206323] r8169 0000:01:00.0: eth0: RTL8102e at 0xf8796000,
> 00:24:8c:19:66:60, XID 04a00000 IRQ 26
> [ 804.816103] r8169 0000:01:00.0: eth0: link up
> [ 815.299005] eth0: no IPv6 routers present
> [ 835.004054] r8169 0000:01:00.0: eth0: link up
> [ 859.004053] r8169 0000:01:00.0: eth0: link up
>=20
>=20
> BR,
> Max Kotov
>=20

=2D-=20
=2D-----------------
http://designinfo.ru

BR.
Max V. Kotov

--nextPart1333048.h0nm7sQuEg
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iF4EABEIAAYFAkuhO7UACgkQWiTSOjzMofLWIgD/fsYaKSnFjXRro2tO7WD/suFP
Zlk7SqFpynfP0vfjIdQA/0flJAA2VEIfiMFkC8V2pUPufmxAA2Kr7L3C3EpaKDom
=wer1
-----END PGP SIGNATURE-----

--nextPart1333048.h0nm7sQuEg--

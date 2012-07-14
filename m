Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757715Ab2GNBJ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 21:09:28 -0400
Received: from smtp-4.hut.fi ([130.233.228.94]:36344 "EHLO smtp-4.hut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756975Ab2GNBJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 21:09:23 -0400
Date: Sat, 14 Jul 2012 04:09:03 +0300
From: Sami Liedes <sami.liedes@iki.fi>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: kmemcheck: Fatal error; system fails to boot when kmemcheck
 enabled
Message-ID: <20120714010902.GA8741@sli.dy.fi>
References: <20120712213305.GA11128@sli.dy.fi>
 <CAOMGZ=F2SkQN1sw9vaDqukFUi0QSaQ=tJOhXjvnJhNz+VYEcKg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="IJpNTDwzlM2Ie8A6"
Content-Disposition: inline
In-Reply-To: <CAOMGZ=F2SkQN1sw9vaDqukFUi0QSaQ=tJOhXjvnJhNz+VYEcKg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TKK-Virus-Scanned: by amavisd-new-2.1.2-hutcc at katosiko.hut.fi
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IJpNTDwzlM2Ie8A6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 13, 2012 at 12:04:46PM +0200, Vegard Nossum wrote:
> So could you please try booting with nosmp to see if it makes a
> difference? That would narrow it down a bit.

Ok, below is the dmesg from nosmp.

> Another thing you can try is try to figure out when things went wrong.
> If you test an old kernel like 3.0 or so -- and find that kmemcheck
> works, that's great, it means we have a way to narrow it down further.
> I may also try your config here to see if I can reproduce it.

I'll probably test 3.0 and could even try to git bisect within a few
days.

	Sami


------------------------------------------------------------
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.4.4+btrfsdebug3+kmc+ (sliedes@lh) (gcc versi=
on 4.7.1 (Debian 4.7.1-4) ) #6 SMP Thu Jul 12 21:38:46 EEST 2012
[    0.000000] Command line: BOOT_IMAGE=3D/vmlinuz-3.4.4+btrfsdebug3+kmc+ r=
oot=3D/dev/mapper/rootvg-root_crypt ro netconsole=3D4444@192.168.1.2/eth0,1=
194@192.168.1.12/00:1c:10:44:47:2c nosmp
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009d400 (usable)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000deb91000 (usable)
[    0.000000]  BIOS-e820: 00000000deb91000 - 00000000df141000 (reserved)
[    0.000000]  BIOS-e820: 00000000df141000 - 00000000df386000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000df386000 - 00000000df394000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000df394000 - 00000000df3c1000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000000009d400 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000df3c1000 - 00000000df3c6000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000df3c6000 - 00000000df409000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000df409000 - 00000000df800000 (usable)
[    0.000000]  BIOS-e820: 00000000f8000000 - 00000000fc000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed04000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000021f000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.6 present.
[    0.000000] No AGP bridge found
[    0.000000] last_pfn =3D 0x21f000 max_arch_pfn =3D 0x400000000
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x701060007=
0106
[    0.000000] last_pfn =3D 0xdf800 max_arch_pfn =3D 0x400000000
[    0.000000] found SMP MP-table at [ffff8800000fce00] fce00
[    0.000000] init_memory_mapping: 0000000000000000-00000000df800000
[    0.000000] init_memory_mapping: 0000000100000000-000000021f000000
[    0.000000] RAMDISK: 364c2000 - 37259000
[    0.000000] ACPI: RSDP 00000000000f0450 00024 (v02 ALASKA)
[    0.000000] ACPI: XSDT 00000000df386070 00064 (v01 ALASKA    A M I 01072=
009 AMI  00010013)
[    0.000000] ACPI: FACP 00000000df391cd8 000F4 (v04 ALASKA    A M I 01072=
009 AMI  00010013)
[    0.000000] ACPI: DSDT 00000000df386168 0BB6D (v02 ALASKA    A M I 00000=
015 INTL 20051117)
[    0.000000] ACPI: FACS 00000000df3bff80 00040
[    0.000000] ACPI: APIC 00000000df391dd0 00092 (v03 ALASKA    A M I 01072=
009 AMI  00010013)
[    0.000000] ACPI: MCFG 00000000df391e68 0003C (v01 ALASKA    A M I 01072=
009 MSFT 00000097)
[    0.000000] ACPI: HPET 00000000df391ea8 00038 (v01 ALASKA    A M I 01072=
009 AMI. 00000005)
[    0.000000] ACPI: SSDT 00000000df391ee0 0036D (v01 SataRe SataTabl 00001=
000 INTL 20091112)
[    0.000000] ACPI: SSDT 00000000df392250 009AA (v01  PmRef  Cpu0Ist 00003=
000 INTL 20051117)
[    0.000000] ACPI: SSDT 00000000df392c00 00A92 (v01  PmRef    CpuPm 00003=
000 INTL 20051117)
[    0.000000] ACPI: DMAR 00000000df393698 00078 (v01 INTEL      SNB  00000=
001 INTL 00000001)
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x0021f000
[    0.000000] Movable zone start PFN for each node
[    0.000000] Early memory PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009d
[    0.000000]     0: 0x00000100 -> 0x000deb91
[    0.000000]     0: 0x000df409 -> 0x000df800
[    0.000000]     0: 0x00100000 -> 0x0021f000
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] ACPI: Skipping IOAPIC probe due to 'noapic' option.
[    0.000000] Using ACPI for processor (LAPIC) configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] Intel MultiProcessor Specification v1.4
[    0.000000] MPTABLE: OEM ID: A M I
[    0.000000] MPTABLE: Product ID: ALASKA
[    0.000000] MPTABLE: APIC at: 0xFEE00000
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-=
23
[    0.000000] Processors: 8
[    0.000000] 8 Processors exceeds max_cpus limit of 0
[    0.000000] SMP: Allowing 1 CPUs, 0 hotplug CPUs
[    0.000000] Allocating PCI resources starting at df800000 (gap: df800000=
:18800000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:1 nr_=
node_ids:1
[    0.000000] PERCPU: Embedded 26 pages/cpu @ffff88021ec00000 s77184 r8192=
 d21120 u2097152
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 2053971
[    0.000000] Kernel command line: BOOT_IMAGE=3D/vmlinuz-3.4.4+btrfsdebug3=
+kmc+ root=3D/dev/mapper/rootvg-root_crypt ro netconsole=3D4444@192.168.1.2=
/eth0,1194@192.168.1.12/00:1c:10:44:47:2c nosmp
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 1048576 (order: 11, 8388608=
 bytes)
[    0.000000] Inode-cache hash table entries: 524288 (order: 10, 4194304 b=
ytes)
[    0.000000] xsave/xrstor: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 8104512k/8896512k available (4332k kernel code, 5416=
12k absent, 250388k reserved, 4356k data, 512k init)
[    0.000000] SLUB: Genslabs=3D15, HWalign=3D64, Order=3D0-3, MinObjects=
=3D0, CPUs=3D1, Nodes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:256 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Fast TSC calibration using PIT
[    0.000001] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 6821.79 BogoMIPS (lpj=3D13643588)
[    0.000814] pid_max: default: 32768 minimum: 301
[    0.004000] Detected 3410.897 MHz processor.
[    0.005691] Security Framework initialized
[    0.009520] Mount-cache hash table entries: 256
[    0.039318] Initializing cgroup subsys cpuacct
[    0.039652] Initializing cgroup subsys devices
[    0.040026] Initializing cgroup subsys freezer
[    0.040413] Initializing cgroup subsys net_cls
[    0.040767] Initializing cgroup subsys blkio
[    0.041958] Initializing cgroup subsys perf_event
[    0.044214] CPU: Physical Processor ID: 0
[    0.044558] CPU: Processor Core ID: 0
[    0.044853] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.044854] ENERGY_PERF_BIAS: View and update with x86_energy_perf_polic=
y(8)
[    0.045744] mce: CPU supports 9 MCE banks
[    0.046223] CPU0: Thermal monitoring enabled (TM1)
[    0.046578] using mwait in idle threads.
[    0.046928] SMP alternatives: switching to UP code
[    0.050376] Freeing SMP alternatives: 16k freed
[    0.050711] ACPI: Core revision 20120320
[    2.058892] ACPI: setting ELCR to 0200 (from 0c28)
[    2.166517] SMP mode deactivated.
[    2.166795] SMP disabled
[    2.167054] Performance Events: PEBS fmt1+, 16-deep LBR, SandyBridge eve=
nts, Intel PMU driver.
[    2.167922] PEBS disabled due to CPU errata.
[    2.168271] ... version:                3
[    2.168573] ... bit width:              48
[    2.168880] ... generic registers:      4
[    2.169183] ... value mask:             0000ffffffffffff
[    2.169553] ... max period:             000000007fffffff
[    2.169924] ... fixed-purpose events:   3
[    2.170225] ... event mask:             000000070000000f
[    2.170862] kmemcheck: Initialized
[    2.176071] NMI watchdog: enabled, takes one hw-pmu counter.
[    2.176707] Brought up 1 CPUs
[    2.176955] Total of 1 processors activated (6821.79 BogoMIPS).
[    2.221193] dummy:=20
[    2.229802] NET: Registered protocol family 16
[    2.259369] ACPI FADT declares the system doesn't support PCIe ASPM, so =
disable it
[    2.259894] ACPI: bus type pci registered
[    2.270669] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000=
-0xfbffffff] (base 0xf8000000)
[    2.271516] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    2.280291] PCI: Using configuration type 1 for base access
[    2.499684] bio: create slab <bio-0> at 0
[    2.510953] ACPI: Added _OSI(Module Device)
[    2.511315] ACPI: Added _OSI(Processor Device)
[    2.511696] ACPI: Added _OSI(3.0 _SCP Extensions)
[    2.512108] ACPI: Added _OSI(Processor Aggregator Device)
[    2.805674] ------------[ cut here ]------------
[    2.805675] ------------[ cut here ]------------
[    2.805679] WARNING: at arch/x86/mm/kmemcheck/kmemcheck.c:634 kmemcheck_=
fault+0xb9/0xd0()
[    2.805680] Hardware name: System Product Name
[    2.805681] Modules linked in: <omitted>
[    2.805683] Pid: 1, comm: swapper/0 Not tainted 3.4.4+btrfsdebug3+kmc+ #6
[    2.805684] Call Trace:
[    2.805684]  <NMI>  [<ffffffff8103a7fa>] warn_slowpath_common+0x7a/0xb0
[    2.805688]  [<ffffffff8103a845>] warn_slowpath_null+0x15/0x20
[    2.805690]  [<ffffffff810330a9>] kmemcheck_fault+0xb9/0xd0
[    2.805693]  [<ffffffff81433465>] do_page_fault+0x445/0x4d0
[    2.805696]  [<ffffffff8142ffb5>] page_fault+0x25/0x30
[    2.805698]  [<ffffffff812836c2>] ? vt_console_print+0xa2/0x3a0
[    2.805699]  [<ffffffff81283687>] ? vt_console_print+0x67/0x3a0
[    2.805701]  [<ffffffff8103a99d>] __call_console_drivers+0x8d/0xb0
[    2.805703]  [<ffffffff8103b0bd>] _call_console_drivers+0x7d/0x100
[    2.805704]  [<ffffffff8103b4c4>] console_unlock+0xf4/0x250
[    2.805706]  [<ffffffff8103bab2>] vprintk+0x362/0x4a0
[    2.805707]  [<ffffffff810330a9>] ? kmemcheck_fault+0xb9/0xd0
[    2.805710]  [<ffffffff81427a6f>] printk+0x3c/0x3e
[    2.805711]  [<ffffffff810330a9>] ? kmemcheck_fault+0xb9/0xd0
[    2.805713]  [<ffffffff8103a7b9>] warn_slowpath_common+0x39/0xb0
[    2.805714]  [<ffffffff8103a845>] warn_slowpath_null+0x15/0x20
[    2.805716]  [<ffffffff810330a9>] kmemcheck_fault+0xb9/0xd0
[    2.805717]  [<ffffffff81433465>] do_page_fault+0x445/0x4d0
[    2.805719]  [<ffffffff8142ffb5>] page_fault+0x25/0x30
[    2.805721]  [<ffffffff81430c46>] ? nmi_handle.isra.0+0x46/0x80
[    2.805722]  [<ffffffff81430d60>] do_nmi+0xe0/0x310
[    2.805723]  [<ffffffff814302dc>] end_repeat_nmi+0x1a/0x1e
[    2.805726]  [<ffffffff81252660>] ? acpi_ns_walk_namespace+0x5f/0x173
[    2.805727]  [<ffffffff810330fb>] ? opcode_is_prefix+0xb/0x60
[    2.805729]  [<ffffffff810330fb>] ? opcode_is_prefix+0xb/0x60
[    2.805731]  [<ffffffff810330fb>] ? opcode_is_prefix+0xb/0x60
[    2.805731]  <<EOE>>  [<ffffffff81033261>] ? kmemcheck_opcode_get_primar=
y+0x21/0x40
[    2.805734]  [<ffffffff81252660>] ? acpi_ns_walk_namespace+0x5f/0x173
[    2.805736]  [<ffffffff810326d2>] kmemcheck_access+0x52/0x440
[    2.805737]  [<ffffffff81032653>] ? kmemcheck_show_addr+0x43/0x70
[    2.805739]  [<ffffffff81032af6>] ? kmemcheck_show_all+0x36/0x70
[    2.805741]  [<ffffffff8103308d>] kmemcheck_fault+0x9d/0xd0
[    2.805742]  [<ffffffff81433465>] do_page_fault+0x445/0x4d0
[    2.805743]  [<ffffffff81032592>] ? kmemcheck_read+0x42/0x70
[    2.805745]  [<ffffffff8142ffb5>] ? page_fault+0x25/0x30
[    2.805747]  [<ffffffff81246140>] ? acpi_ev_execute_reg_method+0x120/0x1=
20
[    2.805749]  [<ffffffff8142ffb5>] page_fault+0x25/0x30
[    2.805750]  [<ffffffff81246140>] ? acpi_ev_execute_reg_method+0x120/0x1=
20
[    2.805752]  [<ffffffff81252660>] ? acpi_ns_walk_namespace+0x5f/0x173
[    2.805753]  [<ffffffff81246140>] ? acpi_ev_execute_reg_method+0x120/0x1=
20
[    2.805755]  [<ffffffff81246881>] acpi_ev_execute_reg_methods+0x3d/0x127
[    2.805756]  [<ffffffff81246140>] ? acpi_ev_execute_reg_method+0x120/0x1=
20
[    2.805757]  [<ffffffff812469ac>] ? acpi_ev_initialize_op_regions+0x41/0=
x8d
[    2.805759]  [<ffffffff812469e7>] acpi_ev_initialize_op_regions+0x7c/0x8d
[    2.805762]  [<ffffffff818b8838>] ? acpi_sleep_init+0xee/0xee
[    2.805764]  [<ffffffff8125bfe8>] acpi_initialize_objects+0x1f/0x53
[    2.805766]  [<ffffffff818b894b>] acpi_init+0x113/0x28f
[    2.805768]  [<ffffffff810002b2>] do_one_initcall+0x122/0x170
[    2.805771]  [<ffffffff81891c5c>] kernel_init+0x13a/0x1be
[    2.805772]  [<ffffffff81891582>] ? do_early_param+0x8c/0x8c
[    2.805774]  [<ffffffff814389a4>] kernel_thread_helper+0x4/0x10
[    2.805776]  [<ffffffff81891b22>] ? start_kernel+0x341/0x341
[    2.805777]  [<ffffffff814389a0>] ? gs_change+0x13/0x13
[    2.805780] ---[ end trace 4eaa2a86a8e2da22 ]---
[    2.809922] WARNING: at arch/x86/mm/kmemcheck/kmemcheck.c:634 kmemcheck_=
fault+0xb9/0xd0()
[    2.809985] Hardware name: System Product Name
[    2.810040] Modules linked in: <omitted>
[    2.810140] Pid: 1, comm: swapper/0 Tainted: G        W    3.4.4+btrfsde=
bug3+kmc+ #6
[    2.810202] Call Trace:
[    2.810255]  <NMI>  [<ffffffff8103a7fa>] warn_slowpath_common+0x7a/0xb0
[    2.810364]  [<ffffffff8103a845>] warn_slowpath_null+0x15/0x20
[    2.810421]  [<ffffffff810330a9>] kmemcheck_fault+0xb9/0xd0
[    2.810478]  [<ffffffff81433465>] do_page_fault+0x445/0x4d0
[    2.810535]  [<ffffffff8142ffb5>] page_fault+0x25/0x30
[    2.810590]  [<ffffffff81430c46>] ? nmi_handle.isra.0+0x46/0x80
[    2.810647]  [<ffffffff81430d60>] do_nmi+0xe0/0x310
[    2.810703]  [<ffffffff814302dc>] end_repeat_nmi+0x1a/0x1e
[    2.810760]  [<ffffffff81252660>] ? acpi_ns_walk_namespace+0x5f/0x173
[    2.810817]  [<ffffffff810330fb>] ? opcode_is_prefix+0xb/0x60
[    2.810874]  [<ffffffff810330fb>] ? opcode_is_prefix+0xb/0x60
[    2.810931]  [<ffffffff810330fb>] ? opcode_is_prefix+0xb/0x60
[    2.810989]  <<EOE>>  [<ffffffff81033261>] ? kmemcheck_opcode_get_primar=
y+0x21/0x40
[    2.811100]  [<ffffffff81252660>] ? acpi_ns_walk_namespace+0x5f/0x173
[    2.811158]  [<ffffffff810326d2>] kmemcheck_access+0x52/0x440
[    2.811214]  [<ffffffff81032653>] ? kmemcheck_show_addr+0x43/0x70
[    2.811272]  [<ffffffff81032af6>] ? kmemcheck_show_all+0x36/0x70
[    2.811328]  [<ffffffff8103308d>] kmemcheck_fault+0x9d/0xd0
[    2.811385]  [<ffffffff81433465>] do_page_fault+0x445/0x4d0
[    2.811444]  [<ffffffff81032592>] ? kmemcheck_read+0x42/0x70
[    2.811502]  [<ffffffff8142ffb5>] ? page_fault+0x25/0x30
[    2.811558]  [<ffffffff81246140>] ? acpi_ev_execute_reg_method+0x120/0x1=
20
[    2.811615]  [<ffffffff8142ffb5>] page_fault+0x25/0x30
[    2.811671]  [<ffffffff81246140>] ? acpi_ev_execute_reg_method+0x120/0x1=
20
[    2.811726]  [<ffffffff81252660>] ? acpi_ns_walk_namespace+0x5f/0x173
[    2.811782]  [<ffffffff81246140>] ? acpi_ev_execute_reg_method+0x120/0x1=
20
[    2.811840]  [<ffffffff81246881>] acpi_ev_execute_reg_methods+0x3d/0x127
[    2.811898]  [<ffffffff81246140>] ? acpi_ev_execute_reg_method+0x120/0x1=
20
[    2.811955]  [<ffffffff812469ac>] ? acpi_ev_initialize_op_regions+0x41/0=
x8d
[    2.812014]  [<ffffffff812469e7>] acpi_ev_initialize_op_regions+0x7c/0x8d
[    2.812073]  [<ffffffff818b8838>] ? acpi_sleep_init+0xee/0xee
[    2.812130]  [<ffffffff8125bfe8>] acpi_initialize_objects+0x1f/0x53
[    2.812187]  [<ffffffff818b894b>] acpi_init+0x113/0x28f
[    2.812244]  [<ffffffff810002b2>] do_one_initcall+0x122/0x170
[    2.812301]  [<ffffffff81891c5c>] kernel_init+0x13a/0x1be
[    2.812359]  [<ffffffff81891582>] ? do_early_param+0x8c/0x8c
[    2.812414]  [<ffffffff814389a4>] kernel_thread_helper+0x4/0x10
[    2.812470]  [<ffffffff81891b22>] ? start_kernel+0x341/0x341
[    2.812527]  [<ffffffff814389a0>] ? gs_change+0x13/0x13
[    2.812584] ---[ end trace 4eaa2a86a8e2da23 ]---
[    2.812685] ERROR: kmemcheck: Fatal error
[    2.812740]=20
[    2.812795] Pid: 1, comm: swapper/0 Tainted: G        W    3.4.4+btrfsde=
bug3+kmc+ #6 System manufacturer System Product Name/P8P67 EVO
[    2.813007] RIP: 0010:[<ffffffff812836c2>]  [<ffffffff812836c2>] vt_cons=
ole_print+0xa2/0x3a0
[    2.813119] RSP: 0018:ffff88021ec07a08  EFLAGS: 00010046
[    2.813174] RAX: 0000000000000000 RBX: ffff880215810000 RCX: 00000000000=
09796
[    2.813231] RDX: 0000000000009696 RSI: ffffffff8193ea50 RDI: ffffffff81a=
1fde8
[    2.813289] RBP: ffff88021ec07a58 R08: 0000000000000002 R09: 00000000000=
00000
[    2.813345] R10: 0000000000000000 R11: 0000000000000000 R12: 00000000000=
00034
[    2.813403] R13: ffffffff8193ea50 R14: 0000000000003070 R15: 00000000000=
00034
[    2.813462] FS:  0000000000000000(0000) GS:ffff88021ec00000(0000) knlGS:=
0000000000000000
[    2.813524] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    2.813581] CR2: ffff88021580e08c CR3: 000000000180c000 CR4: 00000000000=
407f0
[    2.813637] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[    2.813697] DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 00000000000=
00400
[    2.813753]  [<ffffffff8103244a>] kmemcheck_error_save_bug+0x7a/0xb0
[    2.813860]  [<ffffffff81032850>] kmemcheck_access+0x1d0/0x440
[    2.813966]  [<ffffffff8103308d>] kmemcheck_fault+0x9d/0xd0
[    2.814070]  [<ffffffff81433465>] do_page_fault+0x445/0x4d0
[    2.814177]  [<ffffffff8142ffb5>] page_fault+0x25/0x30
[    2.814281]  [<ffffffff8103a99d>] __call_console_drivers+0x8d/0xb0
[    2.814387]  [<ffffffff8103b0bd>] _call_console_drivers+0x7d/0x100
[    2.814527]  [<ffffffff8103b4c4>] console_unlock+0xf4/0x250
[    2.814632]  [<ffffffff8103bab2>] vprintk+0x362/0x4a0
[    2.814737]  [<ffffffff81427a6f>] printk+0x3c/0x3e
[    2.814841]  [<ffffffff8103a7b9>] warn_slowpath_common+0x39/0xb0
[    2.814946]  [<ffffffff8103a845>] warn_slowpath_null+0x15/0x20
[    2.815050]  [<ffffffff810330a9>] kmemcheck_fault+0xb9/0xd0
[    2.815156]  [<ffffffff81433465>] do_page_fault+0x445/0x4d0
[    2.815262]  [<ffffffff8142ffb5>] page_fault+0x25/0x30
[    2.815367]  [<ffffffff81430d60>] do_nmi+0xe0/0x310
[    2.815471]  [<ffffffff814302dc>] end_repeat_nmi+0x1a/0x1e
[    2.815575]  [<ffffffff810326d2>] kmemcheck_access+0x52/0x440
[    2.815682]  [<ffffffff8103308d>] kmemcheck_fault+0x9d/0xd0
[    2.815787]  [<ffffffff81433465>] do_page_fault+0x445/0x4d0
[    2.815891]  [<ffffffff8142ffb5>] page_fault+0x25/0x30
[    2.815998]  [<ffffffff81246881>] acpi_ev_execute_reg_methods+0x3d/0x127
[    2.816106]  [<ffffffff812469e7>] acpi_ev_initialize_op_regions+0x7c/0x8d
[    2.816210]  [<ffffffff8125bfe8>] acpi_initialize_objects+0x1f/0x53
[    2.816316]  [<ffffffff818b894b>] acpi_init+0x113/0x28f
[    2.816421]  [<ffffffff810002b2>] do_one_initcall+0x122/0x170
[    2.816527]  [<ffffffff81891c5c>] kernel_init+0x13a/0x1be
[    2.816633]  [<ffffffff814389a4>] kernel_thread_helper+0x4/0x10
[    2.816738]  [<ffffffffffffffff>] 0xffffffffffffffff
[    2.816844] ERROR: kmemcheck: Fatal error
[    2.816899]=20
[    2.816954] Pid: 1, comm: swapper/0 Tainted: G        W    3.4.4+btrfsde=
bug3+kmc+ #6 System manufacturer System Product Name/P8P67 EVO
[    2.817164] RIP: 0010:[<ffffffff81430c46>]  [<ffffffff81430c46>] nmi_han=
dle.isra.0+0x46/0x80
[    2.817277] RSP: 0018:ffff88021ec07e78  EFLAGS: 00010046
[    2.817333] RAX: ffff880215814680 RBX: ffff880215814680 RCX: 00000000000=
00001
[    2.817390] RDX: 0000000000000000 RSI: ffff88021ec07ef8 RDI: 00000000000=
00000
[    2.817446] RBP: ffff88021ec07eb8 R08: 00003ffffffff000 R09: ffff8800000=
00000
[    2.817503] R10: 5f42535f158f9d48 R11: 43534f5f158f9c18 R12: 00000000000=
00000
[    2.817561] R13: ffffffff81816828 R14: 0000000000000000 R15: ffff88021ec=
07ef8
[    2.817617] FS:  0000000000000000(0000) GS:ffff88021ec00000(0000) knlGS:=
0000000000000000
[    2.817680] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    2.817738] CR2: ffff88021580e08c CR3: 000000000180c000 CR4: 00000000000=
407f0
[    2.817795] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[    2.817853] DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 00000000000=
00400
[    2.817911]  [<ffffffff8103244a>] kmemcheck_error_save_bug+0x7a/0xb0
[    2.818016]  [<ffffffff81032850>] kmemcheck_access+0x1d0/0x440
[    2.818120]  [<ffffffff8103308d>] kmemcheck_fault+0x9d/0xd0
[    2.818226]  [<ffffffff81433465>] do_page_fault+0x445/0x4d0
[    2.818332]  [<ffffffff8142ffb5>] page_fault+0x25/0x30
[    2.818439]  [<ffffffff81430d60>] do_nmi+0xe0/0x310
[    2.818578]  [<ffffffff814302dc>] end_repeat_nmi+0x1a/0x1e
[    2.818684]  [<ffffffff810326d2>] kmemcheck_access+0x52/0x440
[    2.818789]  [<ffffffff8103308d>] kmemcheck_fault+0x9d/0xd0
[    2.818894]  [<ffffffff81433465>] do_page_fault+0x445/0x4d0
[    2.818998]  [<ffffffff8142ffb5>] page_fault+0x25/0x30
[    2.819104]  [<ffffffff81246881>] acpi_ev_execute_reg_methods+0x3d/0x127
[    2.819210]  [<ffffffff812469e7>] acpi_ev_initialize_op_regions+0x7c/0x8d
[    2.819318]  [<ffffffff8125bfe8>] acpi_initialize_objects+0x1f/0x53
[    2.820370] RSP: 0018:ffff88021ec07d20  EFLAGS: 00010002
[    2.820427] RAX: 00000000ffffffff RBX: 0000000000000010 RCX: 00000000000=
00390
[    2.820485] RDX: 0000000000000021 RSI: 0000000000000040 RDI: ffff8802158=
70400
[    2.820542] RBP: ffff88021ec07d68 R08: 0000000000000000 R09: ffff8800000=
00000
[    2.820599] R10: 5f42535f158f9d48 R11: 0000000000000000 R12: 00000000000=
00001
[    2.820656] R13: ffff88021ec07dc0 R14: ffff880215870400 R15: 00000000000=
00021
[    2.820715] FS:  0000000000000000(0000) GS:ffff88021ec00000(0000) knlGS:=
0000000000000000
[    2.820776] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    2.821560] CR2: ffff88021580e08c CR3: 000000000180c000 CR4: 00000000000=
407f0
[    2.821617] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[    2.821674] DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 00000000000=
00400
[    2.821731]  [<ffffffff8103244a>] kmemcheck_error_save_bug+0x7a/0xb0
[    2.821838]  [<ffffffff81032850>] kmemcheck_access+0x1d0/0x440
[    2.821944]  [<ffffffff8103308d>] kmemcheck_fault+0x9d/0xd0
[    2.822047]  [<ffffffff81433465>] do_page_fault+0x445/0x4d0
[    2.822149]  [<ffffffff8142ffb5>] page_fault+0x25/0x30
[    2.822255]  [<ffffffff810179f1>] intel_pmu_save_and_restart+0x11/0x20
[    2.822361]  [<ffffffff81017b5d>] intel_pmu_handle_irq+0x15d/0x320
[    2.822502]  [<ffffffff814313ed>] perf_event_nmi_handler+0x1d/0x20
[    2.822608]  [<ffffffff81430c49>] nmi_handle.isra.0+0x49/0x80
[    2.822713]  [<ffffffff81430d60>] do_nmi+0xe0/0x310
[    2.822817]  [<ffffffff814302dc>] end_repeat_nmi+0x1a/0x1e
[    2.822923]  [<ffffffff810326d2>] kmemcheck_access+0x52/0x440
[    2.823027]  [<ffffffff8103308d>] kmemcheck_fault+0x9d/0xd0
[    2.823131]  [<ffffffff81433465>] do_page_fault+0x445/0x4d0
[    2.823236]  [<ffffffff8142ffb5>] page_fault+0x25/0x30
[    2.823342]  [<ffffffff81246881>] acpi_ev_execute_reg_methods+0x3d/0x127
[    2.823448]  [<ffffffff812469e7>] acpi_ev_initialize_op_regions+0x7c/0x8d
[    2.823552]  [<ffffffff8125bfe8>] acpi_initialize_objects+0x1f/0x53
[    2.823658]  [<ffffffff818b894b>] acpi_init+0x113/0x28f
[    2.823763]  [<ffffffff810002b2>] do_one_initcall+0x122/0x170
[    2.823870]  [<ffffffff81891c5c>] kernel_init+0x13a/0x1be
[    2.823975]  [<ffffffff814389a4>] kernel_thread_helper+0x4/0x10
[    2.824081]  [<ffffffffffffffff>] 0xffffffffffffffff
[    2.865774] ACPI: Executed 1 blocks of module-level executable AML code
[    4.179101] ACPI: SSDT 00000000df0ee018 0083B (v01  PmRef  Cpu0Cst 00003=
001 INTL 20051117)
[    4.230895] ACPI: Dynamic OEM Table Load:
[    4.231060] ACPI: SSDT           (null) 0083B (v01  PmRef  Cpu0Cst 00003=
001 INTL 20051117)
[    4.284229] ACPI: Interpreter enabled
[    4.284284] ACPI: (supports S0 S5)
[    4.287882] ACPI: Using PIC for interrupt routing
[    6.066320] ACPI: Power Resource [FN00] (off)
[    6.083819] ACPI: Power Resource [FN01] (off)
[    6.101621] ACPI: Power Resource [FN02] (off)
[    6.119355] ACPI: Power Resource [FN03] (off)
[    6.137278] ACPI: Power Resource [FN04] (off)
[    6.184874] ACPI: EC: GPE =3D 0x18, I/O: command/status =3D 0x66, data =
=3D 0x62
[    6.229609] ACPI: No dock devices found.
[    6.229679] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    6.331793] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
[    6.495210] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    6.495326] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    6.495437] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x00=
0bffff]
[    6.495651] pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x00=
0d3fff]
[    6.495768] pci_root PNP0A08:00: host bridge window [mem 0x000d4000-0x00=
0d7fff]
[    6.495885] pci_root PNP0A08:00: host bridge window [mem 0x000d8000-0x00=
0dbfff]
[    6.496004] pci_root PNP0A08:00: host bridge window [mem 0x000dc000-0x00=
0dffff]
[    6.496152] pci_root PNP0A08:00: host bridge window [mem 0x000e0000-0x00=
0e3fff]
[    6.496269] pci_root PNP0A08:00: host bridge window [mem 0x000e4000-0x00=
0e7fff]
[    6.496459] pci_root PNP0A08:00: host bridge window [mem 0xe0000000-0xfe=
afffff]
[    6.502005] PCI host bridge to bus 0000:00
[    6.502110] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    6.502215] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    6.502322] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    6.502427] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3ff=
f]
[    6.502534] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7ff=
f]
[    6.502639] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbff=
f]
[    6.502745] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dfff=
f]
[    6.502851] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000e3ff=
f]
[    6.502956] pci_bus 0000:00: root bus resource [mem 0x000e4000-0x000e7ff=
f]
[    6.503061] pci_bus 0000:00: root bus resource [mem 0xe0000000-0xfeaffff=
f]
[    6.538856] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    6.539768] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    6.542844] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    6.546233] pci 0000:00:1c.3: PCI bridge to [bus 04-04]
[    6.549403] pci 0000:00:1c.4: PCI bridge to [bus 05-05]
[    6.551783] pci 0000:00:1c.6: PCI bridge to [bus 06-07] (subtractive dec=
ode)
[    6.557596] pci 0000:06:00.0: PCI bridge to [bus 07-07] (subtractive dec=
ode)
[    6.561840] pci 0000:00:1c.7: PCI bridge to [bus 08-08]
[    6.755590]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    6.771278]  pci0000:00: ACPI _OSC request failed (AE_ERROR), returned c=
ontrol mask: 0x1d
[    6.771341] ACPI _OSC control for PCIe not granted, disabling ASPM
[    7.943228] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 14 1=
5)
[    7.954305] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 *10 11 12 14 1=
5)
[    7.965830] ACPI: PCI Interrupt Link [LNKC] (IRQs *3 4 5 6 10 11 12 14 1=
5)
[    7.976918] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 10 11 12 14 1=
5)
[    7.987992] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 10 *11 12 14 1=
5)
[    7.998994] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12 14 15=
) *0, disabled.
[    8.010421] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 *10 11 12 14 1=
5)
[    8.021481] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 *5 6 10 11 12 14 1=
5)
[    8.038250] vgaarb: device added: PCI:0000:01:00.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    8.038847] vgaarb: loaded
[    8.038928] vgaarb: bridge control possible 0000:01:00.0
[    8.058199] usbcore: registered new interface driver usbfs
[    8.062985] usbcore: registered new interface driver hub
[    8.065458] usbcore: registered new device driver usb
[    8.080609] PCI: Using ACPI for IRQ routing
[    8.118160] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    8.118661] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    8.122622] Switching to clocksource hpet
[    8.470496] pnp: PnP ACPI init
[    8.471338] ACPI: bus type pnp registered
[    8.576924] system 00:01: [mem 0xfed40000-0xfed44fff] has been reserved
[    8.636696] system 00:05: [io  0x0680-0x069f] has been reserved
[    8.636858] system 00:05: [io  0x0200-0x020f] has been reserved
[    8.637051] system 00:05: [io  0xffff] has been reserved
[    8.637250] system 00:05: [io  0xffff] has been reserved
[    8.637419] system 00:05: [io  0x0400-0x0453] has been reserved
[    8.637593] system 00:05: [io  0x0458-0x047f] has been reserved
[    8.637772] system 00:05: [io  0x0500-0x057f] has been reserved
[    8.638127] system 00:05: [io  0x164e-0x164f] has been reserved
[    8.656922] system 00:07: [io  0x0454-0x0457] has been reserved
[    8.688369] system 00:08: [io  0x0290-0x029f] has been reserved
[    8.708598] system 00:09: [io  0x04d0-0x04d1] has been reserved
[    8.857416] system 00:0c: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    8.857563] system 00:0c: [mem 0xfed10000-0xfed17fff] has been reserved
[    8.857716] system 00:0c: [mem 0xfed18000-0xfed18fff] has been reserved
[    8.857952] system 00:0c: [mem 0xfed19000-0xfed19fff] has been reserved
[    8.858151] system 00:0c: [mem 0xf8000000-0xfbffffff] has been reserved
[    8.858314] system 00:0c: [mem 0xfed20000-0xfed3ffff] has been reserved
[    8.858484] system 00:0c: [mem 0xfed90000-0xfed93fff] has been reserved
[    8.858657] system 00:0c: [mem 0xfed45000-0xfed8ffff] has been reserved
[    8.858839] system 00:0c: [mem 0xff000000-0xffffffff] has been reserved
[    8.859032] system 00:0c: [mem 0xfee00000-0xfeefffff] could not be reser=
ved
[    8.859204] system 00:0c: [mem 0xf0000000-0xf0000fff] has been reserved
[    8.893924] pnp: PnP ACPI: found 13 devices
[    8.893981] ACPI: ACPI bus type pnp unregistered
[    9.202983] pci 0000:00:1c.0: BAR 14: assigned [mem 0xf0100000-0xf02ffff=
f]
[    9.203398] pci 0000:00:1c.0: BAR 15: assigned [mem 0xf0300000-0xf04ffff=
f 64bit pref]
[    9.203821] pci 0000:00:1c.3: BAR 15: assigned [mem 0xf0500000-0xf05ffff=
f pref]
[    9.204105] pci 0000:00:1c.0: BAR 13: assigned [io  0x2000-0x2fff]
[    9.204364] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    9.204477] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    9.204638] pci 0000:00:01.0:   bridge window [mem 0xf7e00000-0xf7efffff]
[    9.204797] pci 0000:00:01.0:   bridge window [mem 0xe0000000-0xefffffff=
 64bit pref]
[    9.204922] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    9.205034] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    9.205199] pci 0000:00:1c.0:   bridge window [mem 0xf0100000-0xf02fffff]
[    9.205359] pci 0000:00:1c.0:   bridge window [mem 0xf0300000-0xf04fffff=
 64bit pref]
[    9.205541] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    9.205742] pci 0000:00:1c.1:   bridge window [mem 0xf7d00000-0xf7dfffff]
[    9.206002] pci 0000:04:00.0: BAR 6: assigned [mem 0xf0500000-0xf050ffff=
 pref]
[    9.206167] pci 0000:00:1c.3: PCI bridge to [bus 04-04]
[    9.206279] pci 0000:00:1c.3:   bridge window [io  0xd000-0xdfff]
[    9.206444] pci 0000:00:1c.3:   bridge window [mem 0xf7c00000-0xf7cfffff]
[    9.206604] pci 0000:00:1c.3:   bridge window [mem 0xf0500000-0xf05fffff=
 pref]
[    9.206748] pci 0000:00:1c.4: PCI bridge to [bus 05-05]
[    9.206948] pci 0000:00:1c.4:   bridge window [mem 0xf7b00000-0xf7bfffff]
[    9.207178] pci 0000:06:00.0: PCI bridge to [bus 07-07]
[    9.207292] pci 0000:06:00.0:   bridge window [io  0xc000-0xcfff]
[    9.207462] pci 0000:06:00.0:   bridge window [mem 0xf7a00000-0xf7afffff]
[    9.207634] pci 0000:00:1c.6: PCI bridge to [bus 06-07]
[    9.207748] pci 0000:00:1c.6:   bridge window [io  0xc000-0xcfff]
[    9.207913] pci 0000:00:1c.6:   bridge window [mem 0xf7a00000-0xf7afffff]
[    9.208105] pci 0000:00:1c.7: PCI bridge to [bus 08-08]
[    9.208219] pci 0000:00:1c.7:   bridge window [io  0xb000-0xbfff]
[    9.208385] pci 0000:00:1c.7:   bridge window [mem 0xf7900000-0xf79fffff]
[    9.222200] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
[    9.236019] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
[    9.249709] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 5
[    9.263446] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 3
[    9.271755] NET: Registered protocol family 2
[    9.275654] IP route cache hash table entries: 262144 (order: 9, 2097152=
 bytes)
[    9.294096] TCP established hash table entries: 262144 (order: 10, 41943=
04 bytes)
[    9.294828] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    9.294990] TCP: Hash tables configured (established 262144 bind 65536)
[    9.295776] TCP: reno registered
[    9.295832] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    9.295904] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    9.302123] NET: Registered protocol family 1
[    9.304656] pci 0000:00:1a.0: broken D3 during system sleep on ASUS
[    9.436582] pci 0000:00:1d.0: broken D3 during system sleep on ASUS
[    9.450432] ACPI: PCI Interrupt Link [LNKH] enabled at IRQ 5
[    9.586234] Trying to unpack rootfs image as initramfs...
[   11.582309] Freeing initrd memory: 13916k freed
[   11.583593] DMAR: Host address width 36
[   11.583651] DMAR: DRHD base: 0x000000fed90000 flags: 0x1
[   11.584310] IOMMU 0: reg_base_addr fed90000 ver 1:0 cap c9008020660262 e=
cap f0105a
[   11.584378] DMAR: RMRR base: 0x000000df0d6000 end: 0x000000df0e4fff
[   11.585385] DMAR: No ATSR found
[   11.590368] IOMMU 0 0xfed90000: using Queued invalidation
[   11.590741] IOMMU: Setting RMRR:
[   11.592681] IOMMU: Setting identity map for device 0000:00:1d.0 [0xdf0d6=
000 - 0xdf0e4fff]
[   11.594780] IOMMU: Setting identity map for device 0000:00:1a.0 [0xdf0d6=
000 - 0xdf0e4fff]
[   11.595258] IOMMU: Prepare 0-16MiB unity mapping for LPC
[   11.597195] IOMMU: Setting identity map for device 0000:00:1f.0 [0x0 - 0=
xffffff]
[   11.598926] PCI-DMA: Intel(R) Virtualization Technology for Directed I/O
[   11.599970] WARNING: kmemcheck: Caught 32-bit read from uninitialized me=
mory (ffff880215002c08)
[   11.600033] 00000000000000000c01a4000000016600000001030000002e0000000000=
0000
[   11.601650]  i i i i i i i i u u u u u u u u u u u u u u u u u u u u u u=
 u u
[   11.603256]                  ^
[   11.603310]=20
[   11.603364] Pid: 1, comm: swapper/0 Tainted: G        W    3.4.4+btrfsde=
bug3+kmc+ #6 System manufacturer System Product Name/P8P67 EVO
[   11.603575] RIP: 0010:[<ffffffff81353001>]  [<ffffffff81353001>] qi_subm=
it_sync+0x2d1/0x3f0
[   11.603691] RSP: 0018:ffff8802158f9db0  EFLAGS: 00010002
[   11.603746] RAX: ffff880215002c08 RBX: 0000000000000286 RCX: 00000002000=
00025
[   11.603805] RDX: ffff880215002c00 RSI: ffffc90000022000 RDI: ffff8802121=
75050
[   11.603861] RBP: ffff8802158f9e20 R08: 0000000000000010 R09: ffff88021ec=
152c0
[   11.603917] R10: ffff880212175000 R11: ffff880212175010 R12: 00000000000=
00000
[   11.604013] R13: ffff880212700600 R14: 0000000000000004 R15: ffff8802150=
729c0
[   11.604071] FS:  0000000000000000(0000) GS:ffff88021ec00000(0000) knlGS:=
0000000000000000
[   11.604133] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   11.604189] CR2: ffff88021580e08c CR3: 000000000180c000 CR4: 00000000000=
407f0
[   11.604246] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[   11.604303] DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 00000000000=
00400
[   11.604360]  [<ffffffff81353196>] qi_flush_context+0x46/0x50
[   11.604465]  [<ffffffff818c3343>] intel_iommu_init+0x978/0xc1a
[   11.604573]  [<ffffffff81896ab6>] pci_iommu_init+0x13/0x3e
[   11.604680]  [<ffffffff810002b2>] do_one_initcall+0x122/0x170
[   11.604786]  [<ffffffff81891c5c>] kernel_init+0x13a/0x1be
[   11.604891]  [<ffffffff814389a4>] kernel_thread_helper+0x4/0x10
[   11.604997]  [<ffffffffffffffff>] 0xffffffffffffffff
[   11.606923] ------------[ cut here ]------------
[   11.606984] WARNING: at drivers/pci/search.c:44 pci_find_upstream_pcie_b=
ridge+0x50/0x70()
[   11.607045] Hardware name: System Product Name
[   11.607101] Modules linked in: <omitted>
[   11.607208] Pid: 1, comm: swapper/0 Tainted: G        W    3.4.4+btrfsde=
bug3+kmc+ #6
[   11.607270] Call Trace:
[   11.607325]  [<ffffffff8103a7fa>] warn_slowpath_common+0x7a/0xb0
[   11.607383]  [<ffffffff8103a845>] warn_slowpath_null+0x15/0x20
[   11.607437]  [<ffffffff81208770>] pci_find_upstream_pcie_bridge+0x50/0x70
[   11.607496]  [<ffffffff8135754d>] intel_iommu_device_group+0x7d/0x100
[   11.607556]  [<ffffffff8134da70>] ? bus_set_iommu+0x50/0x50
[   11.607612]  [<ffffffff8134da9b>] add_iommu_group+0x2b/0x60
[   11.607668]  [<ffffffff8129f17d>] bus_for_each_dev+0x4d/0x90
[   11.607726]  [<ffffffff8134da5b>] bus_set_iommu+0x3b/0x50
[   11.607783]  [<ffffffff818c34b4>] intel_iommu_init+0xae9/0xc1a
[   11.607842]  [<ffffffff818939ee>] ? clean_rootfs+0x1c1/0x1c1
[   11.607900]  [<ffffffff81896aa3>] ? memblock_find_dma_reserve+0x13d/0x13d
[   11.607995]  [<ffffffff81896ab6>] pci_iommu_init+0x13/0x3e
[   11.608051]  [<ffffffff810002b2>] do_one_initcall+0x122/0x170
[   11.608109]  [<ffffffff81891c5c>] kernel_init+0x13a/0x1be
[   11.608165]  [<ffffffff81891582>] ? do_early_param+0x8c/0x8c
[   11.608222]  [<ffffffff814389a4>] kernel_thread_helper+0x4/0x10
[   11.608279]  [<ffffffff81891b22>] ? start_kernel+0x341/0x341
[   11.608340]  [<ffffffff814389a0>] ? gs_change+0x13/0x13
[   11.608395] ---[ end trace 4eaa2a86a8e2da24 ]---
[   11.650511] audit: initializing netlink socket (disabled)
[   11.651079] type=3D2000 audit(1342226593.552:1): initialized
[   11.685971] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[   12.099071] VFS: Disk quotas dquot_6.5.2
[   12.105312] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[   12.119059] msgmni has been set to 15985
[   12.144636] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 253)
[   12.145204] io scheduler noop registered
[   12.157607] io scheduler cfq registered (default)
[   12.219405] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[   12.246687] serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[   12.294991] 00:0b: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[   12.336467] Linux agpgart interface v0.103
[   12.582780] brd: module loaded
[   12.585780] e1000e: Intel(R) PRO/1000 Network Driver - 1.9.5-k
[   12.585836] e1000e: Copyright(c) 1999 - 2012 Intel Corporation.
[   12.600594] ACPI: PCI Interrupt Link [LNKE] enabled at IRQ 11
[   12.604211] e1000e 0000:00:19.0: (unregistered net_device): Interrupt Th=
rottling Rate (ints/sec) set to dynamic conservative mode
[   12.619401] Refined TSC clocksource calibration: 3411.127 MHz.
[   12.619460] Switching to clocksource tsc
[   12.940996] e1000e 0000:00:19.0: eth0: (PCI Express:2.5GT/s:Width x1) f4=
:6d:04:b0:8f:c5
[   12.941083] e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connect=
ion
[   12.941194] e1000e 0000:00:19.0: eth0: MAC: 10, PHY: 11, PBA No: FFFFFF-=
0FF
[   12.953426] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   12.955475] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[   12.961792] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus =
number 1
[   12.965911] ehci_hcd 0000:00:1a.0: debug port 2
[   12.969901] ehci_hcd 0000:00:1a.0: Enabling legacy PCI PM
[   12.970300] ehci_hcd 0000:00:1a.0: irq 11, io mem 0xf7f28000
[   12.979211] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[   12.981373] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[   12.981444] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[   12.981554] usb usb1: Product: EHCI Host Controller
[   12.981688] usb usb1: Manufacturer: Linux 3.4.4+btrfsdebug3+kmc+ ehci_hcd
[   12.981779] usb usb1: SerialNumber: 0000:00:1a.0
[   12.993110] hub 1-0:1.0: USB hub found
[   12.993463] hub 1-0:1.0: 2 ports detected
[   13.003578] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[   13.008442] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus =
number 2
[   13.012523] ehci_hcd 0000:00:1d.0: debug port 2
[   13.016504] ehci_hcd 0000:00:1d.0: Enabling legacy PCI PM
[   13.016902] ehci_hcd 0000:00:1d.0: irq 5, io mem 0xf7f27000
[   13.027179] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[   13.029292] usb usb2: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[   13.029364] usb usb2: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[   13.029474] usb usb2: Product: EHCI Host Controller
[   13.029606] usb usb2: Manufacturer: Linux 3.4.4+btrfsdebug3+kmc+ ehci_hcd
[   13.029697] usb usb2: SerialNumber: 0000:00:1d.0
[   13.041055] hub 2-0:1.0: USB hub found
[   13.041409] hub 2-0:1.0: 2 ports detected
[   13.054738] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[   13.057542] uhci_hcd: USB Universal Host Controller Interface driver
[   13.062618] xhci_hcd 0000:03:00.0: xHCI Host Controller
[   13.067932] xhci_hcd 0000:03:00.0: new USB bus registered, assigned bus =
number 3
[   13.073129] xhci_hcd 0000:03:00.0: irq 10, io mem 0xf7d00000
[   13.080131] usb usb3: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[   13.080202] usb usb3: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[   13.080311] usb usb3: Product: xHCI Host Controller
[   13.080443] usb usb3: Manufacturer: Linux 3.4.4+btrfsdebug3+kmc+ xhci_hcd
[   13.080534] usb usb3: SerialNumber: 0000:03:00.0
[   13.093084] hub 3-0:1.0: USB hub found
[   13.093448] hub 3-0:1.0: 2 ports detected
[   13.102553] xhci_hcd 0000:03:00.0: xHCI Host Controller
[   13.107382] xhci_hcd 0000:03:00.0: new USB bus registered, assigned bus =
number 4
[   13.109701] usb usb4: New USB device found, idVendor=3D1d6b, idProduct=
=3D0003
[   13.109772] usb usb4: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[   13.109880] usb usb4: Product: xHCI Host Controller
[   13.110013] usb usb4: Manufacturer: Linux 3.4.4+btrfsdebug3+kmc+ xhci_hcd
[   13.110104] usb usb4: SerialNumber: 0000:03:00.0
[   13.122339] hub 4-0:1.0: USB hub found
[   13.122700] hub 4-0:1.0: 2 ports detected
[   13.133203] xhci_hcd 0000:05:00.0: xHCI Host Controller
[   13.140629] xhci_hcd 0000:05:00.0: new USB bus registered, assigned bus =
number 5
[   13.146027] xhci_hcd 0000:05:00.0: irq 11, io mem 0xf7b00000
[   13.153077] usb usb5: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[   13.153148] usb usb5: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[   13.153258] usb usb5: Product: xHCI Host Controller
[   13.153390] usb usb5: Manufacturer: Linux 3.4.4+btrfsdebug3+kmc+ xhci_hcd
[   13.153481] usb usb5: SerialNumber: 0000:05:00.0
[   13.166799] hub 5-0:1.0: USB hub found
[   13.167350] hub 5-0:1.0: 2 ports detected
[   13.176601] xhci_hcd 0000:05:00.0: xHCI Host Controller
[   13.181332] xhci_hcd 0000:05:00.0: new USB bus registered, assigned bus =
number 6
[   13.183873] usb usb6: New USB device found, idVendor=3D1d6b, idProduct=
=3D0003
[   13.183945] usb usb6: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[   13.184781] usb usb6: Product: xHCI Host Controller
[   13.184913] usb usb6: Manufacturer: Linux 3.4.4+btrfsdebug3+kmc+ xhci_hcd
[   13.185006] usb usb6: SerialNumber: 0000:05:00.0
[   13.198604] hub 6-0:1.0: USB hub found
[   13.199140] hub 6-0:1.0: 2 ports detected
[   13.221334] i8042: PNP: No PS/2 controller found. Probing ports directly.
[   13.229558] serio: i8042 KBD port at 0x60,0x64 irq 1
[   13.229736] serio: i8042 AUX port at 0x60,0x64 irq 12
[   13.248121] mousedev: PS/2 mouse device common for all mice
[   13.251391] rtc_cmos 00:06: RTC can wake from S4
[   13.258163] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
[   13.258586] rtc0: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[   13.266651] cpuidle: using governor ladder
[   13.271694] cpuidle: using governor menu
[   13.303368] usb 1-1: new high-speed USB device number 2 using ehci_hcd
[   13.353079] usbcore: registered new interface driver usbhid
[   13.353137] usbhid: USB HID core driver
[   13.375804] TCP: cubic registered
[   13.375859] NET: Registered protocol family 17
[   13.376136] Registering the dns_resolver key type
[   13.390393] registered taskstats version 1
[   13.414506] netpoll: netconsole: local port 4444
[   13.414567] netpoll: netconsole: local IP 192.168.1.2
[   13.414630] netpoll: netconsole: interface 'eth0'
[   13.414689] netpoll: netconsole: remote port 1194
[   13.414749] netpoll: netconsole: remote IP 192.168.1.12
[   13.414980] netpoll: netconsole: remote ethernet address 00:1c:10:44:47:=
2c
[   13.415057] netpoll: netconsole: device eth0 not up yet, forcing it
[   13.445542] usb 1-1: New USB device found, idVendor=3D8087, idProduct=3D=
0024
[   13.445614] usb 1-1: New USB device strings: Mfr=3D0, Product=3D0, Seria=
lNumber=3D0
[   13.457686] hub 1-1:1.0: USB hub found
[   13.458556] hub 1-1:1.0: 6 ports detected
[   13.622908] usb 2-1: new high-speed USB device number 2 using ehci_hcd
[   13.757331] usb 2-1: New USB device found, idVendor=3D8087, idProduct=3D=
0024
[   13.757402] usb 2-1: New USB device strings: Mfr=3D0, Product=3D0, Seria=
lNumber=3D0
[   13.769746] hub 2-1:1.0: USB hub found
[   13.770526] hub 2-1:1.0: 8 ports detected
[   14.055571] usb 2-1.1: new low-speed USB device number 3 using ehci_hcd
[   14.159634] usb 2-1.1: New USB device found, idVendor=3D0518, idProduct=
=3D0001
[   14.159707] usb 2-1.1: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D0
[   14.159824] usb 2-1.1: Product: USB-compliant keyboard
[   14.159938] usb 2-1.1: Manufacturer: Plus More Enterprise LTD.
[   14.203648] input: Plus More Enterprise LTD. USB-compliant keyboard as /=
devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.1/2-1.1:1.0/input/input0
[   14.212208] generic-usb 0003:0518:0001.0001: input,hidraw0: USB HID v1.1=
0 Keyboard [Plus More Enterprise LTD. USB-compliant keyboard] on usb-0000:0=
0:1d.0-1.1/input0
[   14.245442] input: Plus More Enterprise LTD. USB-compliant keyboard as /=
devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.1/2-1.1:1.1/input/input1
[   14.257809] generic-usb 0003:0518:0001.0002: input,hidraw1: USB HID v1.1=
0 Mouse [Plus More Enterprise LTD. USB-compliant keyboard] on usb-0000:00:1=
d.0-1.1/input1
[   14.344361] usb 2-1.2: new full-speed USB device number 4 using ehci_hcd
[   14.443746] usb 2-1.2: New USB device found, idVendor=3D0d8c, idProduct=
=3D0005
[   14.443819] usb 2-1.2: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D3
[   14.443919] usb 2-1.2: Product: Blue Snowball
[   14.444016] usb 2-1.2: Manufacturer: BLUE MICROPHONE
[   14.444097] usb 2-1.2: SerialNumber: 201111
[   14.487182] input: BLUE MICROPHONE Blue Snowball as /devices/pci0000:00/=
0000:00:1d.0/usb2/2-1/2-1.2/2-1.2:1.2/input/input2
[   14.491898] generic-usb 0003:0D8C:0005.0003: input,hidraw2: USB HID v1.0=
0 Device [BLUE MICROPHONE Blue Snowball] on usb-0000:00:1d.0-1.2/input2
[   14.575597] usb 2-1.3: new low-speed USB device number 5 using ehci_hcd
[   14.683000] usb 2-1.3: New USB device found, idVendor=3D046d, idProduct=
=3Dc501
[   14.683074] usb 2-1.3: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D0
[   14.683171] usb 2-1.3: Product: USB Receiver
[   14.683254] usb 2-1.3: Manufacturer: Logitech
[   14.719958] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:=
1d.0/usb2/2-1/2-1.3/2-1.3:1.0/input/input3
[   14.728771] generic-usb 0003:046D:C501.0004: input,hidraw3: USB HID v1.1=
0 Mouse [Logitech USB Receiver] on usb-0000:00:1d.0-1.3/input0
[   14.812344] usb 2-1.7: new full-speed USB device number 6 using ehci_hcd
[   14.909752] usb 2-1.7: New USB device found, idVendor=3D0cf3, idProduct=
=3D3000
[   14.909865] usb 2-1.7: New USB device strings: Mfr=3D0, Product=3D0, Ser=
ialNumber=3D0
[   15.204564] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Contr=
ol: Rx/Tx
[   15.204652] e1000e 0000:00:19.0: eth0: 10/100 speed: disabling TSO
[   15.513486] console [netcon0] enabled
[   15.513781] netconsole: network logging started
[   15.516214] rtc_cmos 00:06: setting system clock to 2012-07-14 00:43:17 =
UTC (1342226597)
[   15.530135] Freeing unused kernel memory: 512k freed
[   15.530482] Write protecting the kernel read-only data: 8192k
[   15.534307] Freeing unused kernel memory: 1792k freed
[   15.536526] Freeing unused kernel memory: 52k freed
[   15.619006] ------------[ cut here ]------------
[   15.619310] WARNING: at kernel/smp.c:320 smp_call_function_single+0x113/=
0x170()
[   15.619635] Hardware name: System Product Name
[   15.621408] Modules linked in: <omitted>
[   15.622017] Pid: 749, comm: busybox Tainted: G        W    3.4.4+btrfsde=
bug3+kmc+ #6
[   15.622354] Call Trace:
[   15.622674]  [<ffffffff8103a7fa>] warn_slowpath_common+0x7a/0xb0
[   15.623017]  [<ffffffff810d0700>] ? perf_swevent_add+0x130/0x130
[   15.623349]  [<ffffffff8103a845>] warn_slowpath_null+0x15/0x20
[   15.623685]  [<ffffffff810883a3>] smp_call_function_single+0x113/0x170
[   15.624024]  [<ffffffff810cfaf4>] task_function_call+0x44/0x50
[   15.624371]  [<ffffffff810d4b30>] ? perf_cgroup_switch+0x170/0x170
[   15.624707]  [<ffffffff81099dcf>] ? cgroup_exit+0xcf/0x110
[   15.625071]  [<ffffffff810d0780>] perf_cgroup_exit+0x20/0x30
[   15.625400]  [<ffffffff81099dd4>] cgroup_exit+0xd4/0x110
[   15.625756]  [<ffffffff8103e65c>] do_exit+0x1ac/0x8a0
[   15.626086]  [<ffffffff8142e499>] ? __schedule+0x149/0x790
[   15.626439]  [<ffffffff8103efea>] do_group_exit+0x3a/0xa0
[   15.626777]  [<ffffffff8103f062>] sys_exit_group+0x12/0x20
[   15.627121]  [<ffffffff8143753d>] system_call_fastpath+0x1a/0x1f
[   15.627459] ---[ end trace 4eaa2a86a8e2da26 ]---
[   17.508148] ERROR: kmemcheck: Fatal error
[   17.508449]=20
[   17.508768] Pid: 772, comm: udevadm Tainted: G        W    3.4.4+btrfsde=
bug3+kmc+ #6 System manufacturer System Product Name/P8P67 EVO
[   17.511457] RIP: 0010:[<ffffffff811e0ffd>]  [<ffffffff811e0ffd>] add_uev=
ent_var+0x7d/0x100
[   17.512153] RSP: 0018:ffff880211a75d48  EFLAGS: 00010283
[   17.512480] RAX: 0000000000000047 RBX: ffff880212342000 RCX: 00000000000=
0000b
[   17.512872] RDX: 000000000000000b RSI: 0000000000000047 RDI: ffff8802118=
b4e80
[   17.513232] RBP: ffff880211a75da8 R08: 000000000000ffff R09: 00000000000=
0ffff
[   17.513583] R10: 0000000000000002 R11: 0000000000000000 R12: 00000000000=
007f5
[   17.513926] R13: ffff880215afb3c0 R14: 0000000000000000 R15: ffff8802158=
341e0
[   17.514299] FS:  00007f9e5ca507a0(0000) GS:ffff88021ec00000(0000) knlGS:=
0000000000000000
[   17.514647] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   17.514989] CR2: ffff88021236a900 CR3: 0000000211a64000 CR4: 00000000000=
407f0
[   17.515330] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[   17.515742] DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 00000000000=
00400
[   17.516083]  [<ffffffff8103244a>] kmemcheck_error_save_bug+0x7a/0xb0
[   17.516772]  [<ffffffff81032c4b>] kmemcheck_show+0x8b/0xa0
[   17.517437]  [<ffffffff81033067>] kmemcheck_fault+0x77/0xd0
[   17.518079]  [<ffffffff81433465>] do_page_fault+0x445/0x4d0
[   17.518777]  [<ffffffff8142ffb5>] page_fault+0x25/0x30
[   17.519426]  [<ffffffff811e1303>] kobject_uevent_env+0x223/0x640
[   17.520094]  [<ffffffff811e172b>] kobject_uevent+0xb/0x10
[   17.520775]  [<ffffffff8129d5ed>] store_uevent+0x5d/0x70
[   17.521486]  [<ffffffff8129c953>] dev_attr_store+0x13/0x20
[   17.522132]  [<ffffffff81191828>] sysfs_write_file+0xc8/0x140
[   17.522801]  [<ffffffff81129567>] vfs_write+0xa7/0x180
[   17.523526]  [<ffffffff81129895>] sys_write+0x45/0x90
[   17.524261]  [<ffffffff8143753d>] system_call_fastpath+0x1a/0x1f
[   17.524912]  [<ffffffffffffffff>] 0xffffffffffffffff
[   19.394928] ERROR: kmemcheck: Fatal error
[   19.395229]=20
[   19.395569] Pid: 772, comm: udevadm Tainted: G        W    3.4.4+btrfsde=
bug3+kmc+ #6 System manufacturer System Product Name/P8P67 EVO
[   19.398264] RIP: 0010:[<ffffffff81190ff8>]  [<ffffffff81190ff8>] sysfs_r=
efresh_inode+0x78/0x90
[   19.398930] RSP: 0018:ffff880211a75c98  EFLAGS: 00010146
[   19.399257] RAX: 0000000000000000 RBX: ffff880211dcc460 RCX: 00000000000=
00010
[   19.399593] RDX: 00000000000041ed RSI: ffff880211dcc460 RDI: ffff8802150=
52770
[   19.399917] RBP: ffff880211a75ca8 R08: 0000000000000010 R09: ffff880211d=
98038
[   19.400644] R13: ffff880215052770 R14: ffff880211a75e48 R15: ffff880211d=
cc460
[   19.401066] FS:  0000000000000000(0000) GS:ffff88021ec00000(0000) knlGS:=
0000000000000000
[   19.401429] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   19.401759] CR2: ffff88021236a900 CR3: 0000000211a64000 CR4: 00000000000=
407f0
[   19.402098] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[   19.402435] DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 00000000000=
00400
[   19.402764]  [<ffffffff8103244a>] kmemcheck_error_save_bug+0x7a/0xb0
[   19.403486]  [<ffffffff81032c4b>] kmemcheck_show+0x8b/0xa0
[   19.404131]  [<ffffffff81033067>] kmemcheck_fault+0x77/0xd0
[   19.404758]  [<ffffffff81433465>] do_page_fault+0x445/0x4d0
[   19.405389]  [<ffffffff8142ffb5>] page_fault+0x25/0x30
[   19.406066]  [<ffffffff81191053>] sysfs_permission+0x43/0x70
[   19.406796]  [<ffffffff81134551>] inode_permission+0x71/0x100
[   19.407463]  [<ffffffff811361b5>] link_path_walk+0x225/0x830
[   19.408105]  [<ffffffff81138274>] path_openat+0xb4/0x3c0
[   19.408780]  [<ffffffff8113868c>] do_filp_open+0x3c/0x90
[   19.409425]  [<ffffffff81128988>] do_sys_open+0xe8/0x1c0
[   19.410052]  [   19.400256] R10: ffff880211d98000 R11: 9a8ad0cec9868b8b =
R12: ffff880215052770
[   19.874068] Btrfs loaded
[   20.161318] nbd: registered device at major 43
[   21.141809] raid6: int64x1   3289 MB/s
[   21.209760] raid6: int64x2   3922 MB/s
[   21.277721] raid6: int64x4   3361 MB/s
[   21.345676] raid6: int64x8   2949 MB/s
[   21.413625] raid6: sse2x1    9103 MB/s
[   21.481577] raid6: sse2x2   11208 MB/s
[   21.549536] raid6: sse2x4   12939 MB/s
[   21.549828] raid6: using algorithm sse2x4 (12939 MB/s)
[   21.913332] ERROR: kmemcheck: Fatal error
[   21.913628]=20
[   21.913967] Pid: 771, comm: udevd Tainted: G        W    3.4.4+btrfsdebu=
g3+kmc+ #6 System manufacturer System Product Name/P8P67 EVO
[   21.916598] RIP: 0010:[<ffffffff81134520>]  [<ffffffff81134520>] inode_p=
ermission+0x40/0x100
[   21.917226] RSP: 0018:ffff880211a31ce8  EFLAGS: 00010146
[   21.917676] RAX: 0000000000000000 RBX: ffff880211c80000 RCX: 00000000000=
00000
[   21.918009] RDX: 00000000000041ed RSI: 0000000000000001 RDI: ffff880211c=
80000
[   21.918338] RBP: ffff880211a31cf8 R08: 0000000000000010 R09: ffff880211c=
32e78
[   21.918674] R10: ffff880211c32e40 R11: 9c96899a9bd0cfcf R12: 00000000000=
00001
[   21.919032] R13: 000000000000000a R14: ffff880211a31e48 R15: ffff880211c=
80000
[   21.919366] FS:  0000000000000000(0000) GS:ffff88021ec00000(0000) knlGS:=
0000000000000000
[   21.919737] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   21.920065] CR2: ffff88021236a900 CR3: 000000000180c000 CR4: 00000000000=
407f0
[   21.920422] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[   21.920754] DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 00000000000=
00400
[   21.921091]  [<ffffffff8103244a>] kmemcheck_error_save_bug+0x7a/0xb0
[   21.921811]  [<ffffffff81032c4b>] kmemcheck_show+0x8b/0xa0
[   21.922456]  [<ffffffff81033067>] kmemcheck_fault+0x77/0xd0
[   21.923104]  [<ffffffff81433465>] do_page_fault+0x445/0x4d0
[   21.923731]  [<ffffffff8142ffb5>] page_fault+0x25/0x30
[   21.924426]  [<ffffffff811361b5>] link_path_walk+0x225/0x830
[   21.925070]  [<ffffffff81138274>] path_openat+0xb4/0x3c0
[   21.925786]  [<ffffffff8113868c>] do_filp_open+0x3c/0x90
[   21.926424]  [<ffffffff81128988>] do_sys_open+0xe8/0x1c0
[   21.927121]  [<ffffffff81128a7c>] sys_open+0x1c/0x20
[   21.927763]  [<ffffffff8143753d>] system_call_fastpath+0x1a/0x1f
[   21.928412]  [<ffffffffffffffff>] 0xffffffffffffffff
[   22.047215] async_tx: api initialized (async)
[   22.062124] xor: measuring software checksum speed
[   22.081190]    8regs     : 14874.000 MB/sec
[   22.101176]    8regs_prefetch: 13834.000 MB/sec
[   22.121164]    32regs    : 14841.000 MB/sec
[   22.141150]    32regs_prefetch: 13802.000 MB/sec
[   22.141449] xor: using function: 8regs (14874.000 MB/sec)
[   22.227017] md: raid6 personality registered for level 6
[   22.227320] md: raid5 personality registered for level 5
[   22.227869] md: raid4 personality registered for level 4
[   22.351236] device-mapper: uevent: version 1.0.3
[   22.360011] device-mapper: ioctl: 4.22.0-ioctl (2011-10-19) initialised:=
 dm-devel@redhat.com
[   26.818127] ERROR: kmemcheck: Fatal error
[   26.818429]=20
[   26.818769] Pid: 889, comm: cryptroot Tainted: G        W    3.4.4+btrfs=
debug3+kmc+ #6 System manufacturer System Product Name/P8P67 EVO
[   26.821381] RIP: 0010:[<ffffffff81430c46>]  [<ffffffff81430c46>] nmi_han=
dle.isra.0+0x46/0x80
[   26.822003] RSP: 0018:ffff88021ec07e78  EFLAGS: 00010046
[   26.822384] RAX: ffff880215814680 RBX: ffff880215814680 RCX: 00000000000=
00001
[   26.822718] RDX: 0000000000000000 RSI: ffff88021ec07ef8 RDI: 00000000000=
00000
[   26.823048] RBP: ffff88021ec07eb8 R08: 00003ffffffff000 R09: ffff8800000=
00000
[   26.823385] R10: 2f2f2f2f2f2f2f2f R11: ffffffff908cd198 R12: 00000000000=
00000
[   26.823743] R13: ffffffff81816828 R14: 0000000000000000 R15: ffff88021ec=
07ef8
[   26.824077] FS:  0000000000000000(0000) GS:ffff88021ec00000(0000) knlGS:=
0000000000000000
[   26.824446] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   26.824776] CR2: ffff88021236a900 CR3: 0000000211579000 CR4: 00000000000=
407f0
[   26.825134] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[   26.825466] DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 00000000000=
00400
[   26.825803]  [<ffffffff8103244a>] kmemcheck_error_save_bug+0x7a/0xb0
[   26.826492]  [<ffffffff81032850>] kmemcheck_access+0x1d0/0x440
[   26.827139]  [<ffffffff8103308d>] kmemcheck_fault+0x9d/0xd0
[   26.827790]  [<ffffffff81433465>] do_page_fault+0x445/0x4d0
[   26.828420]  [<ffffffff8142ffb5>] page_fault+0x25/0x30
[   26.829065]  [<ffffffff81430d60>] do_nmi+0xe0/0x310
[   26.829709]  [<ffffffff814302dc>] end_repeat_nmi+0x1a/0x1e
[   26.830391]  [<ffffffff810324d9>] kmemcheck_read_strict+0x29/0xa0
[   26.831037]  [<ffffffff81032592>] kmemcheck_read+0x42/0x70
[   26.831683]  [<ffffffff81032704>] kmemcheck_access+0x84/0x440
[   26.832349]  [<ffffffff8103308d>] kmemcheck_fault+0x9d/0xd0
[   26.832998]  [<ffffffff81433465>] do_page_fault+0x445/0x4d0
[   26.833638]  [<ffffffff8142ffb5>] page_fault+0x25/0x30
[   26.834319]  [<ffffffff8113828a>] path_openat+0xca/0x3c0
[   26.834966]  [<ffffffff8113868c>] do_filp_open+0x3c/0x90
[   26.835580]  [<ffffffff8112efed>] open_exec+0x2d/0xf0
[   26.836195]  [<ffffffff81176888>] load_elf_binary+0x7a8/0x1850
[   26.836853]  [<ffffffff8112f1b7>] search_binary_handler+0x107/0x310
[   26.837505]  [<ffffffff81130694>] do_execve_common.isra.30+0x434/0x500
[   26.838214]  [<ffffffff81130776>] do_execve+0x16/0x20
[   26.838855]  [<ffffffff8100b072>] sys_execve+0x42/0x70
[   26.839530]  [<ffffffff8143797c>] stub_execve+0x6c/0xc0
[   26.840180]  [<ffffffffffffffff>] 0xffffffffffffffff
[   26.840846] ERROR: kmemcheck: Fatal error
[   26.841171]=20
[   26.841493] Pid: 889, comm: cryptroot Tainted: G        W    3.4.4+btrfs=
debug3+kmc+ #6 System manufacturer System Product Name/P8P67 EVO
[   26.842857] RIP: 0010:[<ffffffff81011f3a>]  [<ffffffff81011f3a>] x86_per=
f_event_update+0x2a/0xc0
[   26.843545] RSP: 0018:ffff88021ec07d20  EFLAGS: 00010002
[   26.843873] RAX: 00000000ffffffff RBX: 0000000000000010 RCX: 00000000000=
00390
[   26.844223] RDX: 0000000000000021 RSI: 0000000000000040 RDI: ffff8802158=
70400
[   26.844563] RBP: ffff88021ec07d68 R08: 0000000000000000 R09: ffff8800000=
00000
[   26.844940] R10: 2f2f2f2f2f2f2f2f R11: 0000000000000000 R12: 00000000000=
00001
[   26.845283] R13: ffff88021ec07dc0 R14: ffff880215870400 R15: 00000000000=
00021
[   26.845637] FS:  0000000000000000(0000) GS:ffff88021ec00000(0000) knlGS:=
0000000000000000
[   26.845989] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   26.846391] CR2: ffff88021236a900 CR3: 0000000211579000 CR4: 00000000000=
407f0
[   26.846731] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[   26.847081] DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 00000000000=
00400
[   26.847421]  [<ffffffff8103244a>] kmemcheck_error_save_bug+0x7a/0xb0
[   26.848087]  [<ffffffff81032850>] kmemcheck_access+0x1d0/0x440
[   26.848759]  [<ffffffff8103308d>] kmemcheck_fault+0x9d/0xd0
[   26.849425]  [<ffffffff81433465>] do_page_fault+0x445/0x4d0
[   26.850104]  [<ffffffff8142ffb5>] page_fault+0x25/0x30
[   26.850782]  [<ffffffff810179f1>] intel_pmu_save_and_restart+0x11/0x20
[   26.851453]  [<ffffffff81017b5d>] intel_pmu_handle_irq+0x15d/0x320
[   26.852120]  [<ffffffff814313ed>] perf_event_nmi_handler+0x1d/0x20
[   26.852766]  [<ffffffff81430c49>] nmi_handle.isra.0+0x49/0x80
[   26.853425]  [<ffffffff81430d60>] do_nmi+0xe0/0x310
[   26.854109]  [<ffffffff814302dc>] end_repeat_nmi+0x1a/0x1e
[   26.854775]  [<ffffffff810324d9>] kmemcheck_read_strict+0x29/0xa0
[   26.855442]  [<ffffffff81032592>] kmemcheck_read+0x42/0x70
[   26.856101]  [<ffffffff81032704>] kmemcheck_access+0x84/0x440
[   26.856750]  [<ffffffff8103308d>] kmemcheck_fault+0x9d/0xd0
[   26.857415]  [<ffffffff81433465>] do_page_fault+0x445/0x4d0
[   26.858179]  [<ffffffff8142ffb5>] page_fault+0x25/0x30
[   26.858837]  [<ffffffff8113828a>] path_openat+0xca/0x3c0
[   26.859483]  [<ffffffff8113868c>] do_filp_open+0x3c/0x90
[   26.860146]  [<ffffffff8112efed>] open_exec+0x2d/0xf0
[   26.860788]  [<ffffffff81176888>] load_elf_binary+0x7a8/0x1850
[   53.770742] SysRq : Resetting

--IJpNTDwzlM2Ie8A6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCgAGBQJQAMatAAoJEKLT589SE0a0utMP/R6GZ8bSYHQlOJkDR7AKj5iH
VnZpmFlgOlE9fhGlhkMqFaoCEf1WfnL+ga6Qb00cPylC3gLZKRYQMLTuZniC4Qv1
+6ChnGOd8PNFEtmM+9nNqwnaFWco7rYRSjW8RFmJ8LDancSV9HaGQjeeAr8+QcrF
UoIU3Q5ctSlF3Er9DrmQZt5mxJoto9Qlh/w/XkvDb0KRsLarbVSSk5c5u1WpkCAQ
/fAfKp605tGi5beZFxaCNBfUvpMX/+tqYKUGPTr/b0OkWFpXhjWmqIQaCLhmBFJF
nPeeId4v4d+69axdANOlAgUhxj89OkmWkP/KDT5621fkyjK4RCRvWNjx+LETp/FR
C+N1YiEnjMDj4aFPTdQPUCiuqSONkbhvM1ersCFUW3GjVig2djUY7HKihRECDFvt
l6n4kHs+FYhDAllr45/Zy931fc6TSmzDMKLho8k8wRjrPWeQwQwXh6YKWZvCZlMK
TMZ0BS199BOBMPSyyXvYncnzJZ2DHhVGpKKQhs+cO3cG791zujuaYsDWMjqVLJbA
cogRFNzyp12md1emlrFrIRCI6OfPfmlb16f6KNXNPLBGT4t96+gGBNV/plo4tnye
sL1EGyZnadst2C6qmvI/c1V+TPUdxn7iKjNumI/IYRmZbWK28LbAoqZn7T5cHr1R
XABQqOsZ+tXpmVhQkYdi
=qbOl
-----END PGP SIGNATURE-----

--IJpNTDwzlM2Ie8A6--

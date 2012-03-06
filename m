Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030863Ab2CFO7K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 09:59:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14659 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757893Ab2CFO7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 09:59:05 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: the maxcpus= boot parameter broke somewhere along the line
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 06 Mar 2012 09:59:04 -0500
Message-ID: <x49vcmhhj2f.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=

When booting my machine with maxcpus=1, it seems to be ignored with
3.3.0-rc3.  I know that 3.1.0-rc3 works fine, but I haven't had time to
track it down any further than that.  I've attached the dmesg from my
machine.  Let me know if there is any other information that would help
in solving this.

Cheers,
Jeff


--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline; filename=metallica-dmesg
Content-Transfer-Encoding: quoted-printable

Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 3.3.0-rc3+ (root@metallica.lab.bos.redhat.com) (gcc version 4=
.4.4 20100726 (Red Hat 4.4.4-13) (GCC) ) #59 SMP Thu Mar 1 11:59:00 EST 2012
Command line: ro root=3DUUID=3Dfcd9cac9-0500-4c87-b1e0-f992ee94c289 console=
=3DttyS1 crashkernel=3Dauto SYSFONT=3Dlatarcyrheb-sun16 LANG=3Den_US.UTF-8 =
KEYTABLE=3Dus selinux=3D0 maxcpus=3D1
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000d7e66000 (usable)
 BIOS-e820: 00000000d7e66000 - 00000000d7e6e000 (ACPI data)
 BIOS-e820: 00000000d7e6e000 - 00000000d7e6f000 (usable)
 BIOS-e820: 00000000d7e6f000 - 00000000d8000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fed00000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
 BIOS-e820: 00000000ffc00000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000127fff000 (usable)
NX (Execute Disable) protection: active
DMI 2.4 present.
DMI: HP ProLiant DL320 G5p, BIOS W05 02/26/2008
e820 update range: 0000000000000000 - 0000000000010000 (usable) =3D=3D> (re=
served)
e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
No AGP bridge found
last_pfn =3D 0x127fff max_arch_pfn =3D 0x400000000
MTRR default type: write-back
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 0D8000000 mask FF8000000 uncachable
  1 base 0E0000000 mask FE0000000 uncachable
  2 disabled
  3 disabled
  4 disabled
  5 disabled
  6 disabled
  7 disabled
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
last_pfn =3D 0xd7e6f max_arch_pfn =3D 0x400000000
found SMP MP-table at [ffff8800000f4f80] f4f80
initial memory mapped : 0 - 20000000
Base memory trampoline at [ffff88000009a000] 9a000 size 20480
init_memory_mapping: 0000000000000000-00000000d7e6f000
 0000000000 - 00d7e00000 page 2M
 00d7e00000 - 00d7e6f000 page 4k
kernel direct mapping tables up to d7e6f000 @ 1fffa000-20000000
init_memory_mapping: 0000000100000000-0000000127fff000
 0100000000 - 0127e00000 page 2M
 0127e00000 - 0127fff000 page 4k
kernel direct mapping tables up to 127fff000 @ d7e5f000-d7e66000
RAMDISK: 37aa9000 - 37ff0000
crashkernel: memory value expected
ACPI: RSDP 00000000000f4f00 00024 (v02 HP    )
ACPI: XSDT 00000000d7e667c0 00074 (v01 HP     ProLiant 00000002   =C3=92? 0=
000162E)
ACPI: FACP 00000000d7e66840 000F4 (v03 HP     ProLiant 00000002   =C3=92? 0=
000162E)
ACPI Warning: Invalid length for Pm1aControlBlock: 32, using default 16 (20=
120111/tbfadt-629)
ACPI: DSDT 00000000d7e66940 02D59 (v01 HP         DSDT 00000001 INTL 200302=
28)
ACPI: FACS 00000000d7e66100 00040
ACPI: SPCR 00000000d7e66140 00050 (v01 HP     SPCRRBSU 00000001   =C3=92? 0=
000162E)
ACPI: MCFG 00000000d7e661c0 0003C (v01 HP     ProLiant 00000001      000000=
00)
ACPI: HPET 00000000d7e66200 00038 (v01 HP     ProLiant 00000002   =C3=92? 0=
000162E)
ACPI: SPMI 00000000d7e66240 00040 (v05 HP     ProLiant 00000001   =C3=92? 0=
000162E)
ACPI: ERST 00000000d7e66280 001D0 (v01 HP     ProLiant 00000001   =C3=92? 0=
000162E)
ACPI: APIC 00000000d7e66480 00092 (v01 HP     ProLiant 00000002      000000=
00)
ACPI: FFFF 00000000d7e66540 00176 (v01 HP     ProLiant 00000001   =C3=92? 0=
000162E)
ACPI: BERT 00000000d7e666c0 00030 (v01 HP     ProLiant 00000001   =C3=92? 0=
000162E)
ACPI: HEST 00000000d7e66700 000BC (v01 HP     ProLiant 00000001   =C3=92? 0=
000162E)
ACPI: Local APIC address 0xfee00000
No NUMA configuration found
Faking a node at 0000000000000000-0000000127fff000
Initmem setup node 0 0000000000000000-0000000127fff000
  NODE_DATA [0000000127fd8000 - 0000000127ffefff]
 [ffffea0000000000-ffffea00041fffff] PMD -> [ffff880123600000-ffff880126fff=
fff] on node 0
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00127fff
Movable zone start PFN for each node
Early memory PFN ranges
    0: 0x00000010 -> 0x0000009f
    0: 0x00000100 -> 0x000d7e66
    0: 0x000d7e6e -> 0x000d7e6f
    0: 0x00100000 -> 0x00127fff
On node 0 totalpages: 1048053
  DMA zone: 56 pages used for memmap
  DMA zone: 5 pages reserved
  DMA zone: 3922 pages, LIFO batch:0
  DMA32 zone: 14280 pages used for memmap
  DMA32 zone: 865951 pages, LIFO batch:31
  Normal zone: 2240 pages used for memmap
  Normal zone: 161599 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x908
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] disabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
ACPI: LAPIC (acpi_id[0x06] lapic_id[0x06] disabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x05] disabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] disabled)
ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x10228201 base: 0xfed00000
SMP: Allowing 8 CPUs, 4 hotplug CPUs
nr_irqs_gsi: 40
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
PM: Registered nosave memory: 00000000d7e66000 - 00000000d7e6e000
PM: Registered nosave memory: 00000000d7e6f000 - 00000000d8000000
PM: Registered nosave memory: 00000000d8000000 - 00000000fec00000
PM: Registered nosave memory: 00000000fec00000 - 00000000fed00000
PM: Registered nosave memory: 00000000fed00000 - 00000000fee00000
PM: Registered nosave memory: 00000000fee00000 - 00000000fee10000
PM: Registered nosave memory: 00000000fee10000 - 00000000ffc00000
PM: Registered nosave memory: 00000000ffc00000 - 0000000100000000
Allocating PCI resources starting at d8000000 (gap: d8000000:26c00000)
Booting paravirtualized kernel on bare hardware
setup_percpu: NR_CPUS:4096 nr_cpumask_bits:8 nr_cpu_ids:8 nr_node_ids:1
PERCPU: Embedded 28 pages/cpu @ffff880127c00000 s82304 r8192 d24192 u262144
pcpu-alloc: s82304 r8192 d24192 u262144 alloc=3D1*2097152
pcpu-alloc: [0] 0 1 2 3 4 5 6 7=20
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1031472
Policy zone: Normal
Kernel command line: ro root=3DUUID=3Dfcd9cac9-0500-4c87-b1e0-f992ee94c289 =
console=3DttyS1 crashkernel=3Dauto SYSFONT=3Dlatarcyrheb-sun16 LANG=3Den_US=
.UTF-8 KEYTABLE=3Dus selinux=3D0 maxcpus=3D1
PID hash table entries: 4096 (order: 3, 32768 bytes)
Checking aperture...
No AGP bridge found
Memory: 4042600k/4849660k available (6535k kernel code, 657448k absent, 149=
612k reserved, 6800k data, 1468k init)
Hierarchical RCU implementation.
NR_IRQS:262400 nr_irqs:744 16
Extended CMOS year: 2000
Console: colour VGA+ 80x25
console [ttyS1] enabled
allocated 16777216 bytes of page_cgroup
please try 'cgroup_disable=3Dmemory' option if you don't want memory cgroups
hpet clockevent registered
Fast TSC calibration using PIT
Detected 2128.033 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. =
4256.06 BogoMIPS (lpj=3D2128033)
pid_max: default: 32768 minimum: 301
Security Framework initialized
SELinux:  Disabled at boot.
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Mount-cache hash table entries: 256
Initializing cgroup subsys cpuacct
Initializing cgroup subsys memory
Initializing cgroup subsys devices
Initializing cgroup subsys freezer
Initializing cgroup subsys net_cls
Initializing cgroup subsys blkio
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 6 MCE banks
CPU0: Thermal monitoring enabled (TM2)
using mwait in idle threads.
SMP alternatives: switching to UP code
ACPI: Core revision 20120111
ftrace: allocating 23839 entries in 94 pages
..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D-1
CPU0: Intel(R) Xeon(R) CPU           X3210  @ 2.13GHz stepping 0b
Performance Events: PEBS fmt0+, Core2 events, Broken BIOS detected, complai=
n to your hardware vendor.
[Firmware Bug]: the BIOS has corrupted hw-PMU resources (MSR 186 is 43003c)
Intel PMU driver.
PEBS disabled due to CPU errata.
... version:                2
... bit width:              40
... generic registers:      2
... value mask:             000000ffffffffff
... max period:             000000007fffffff
... fixed-purpose events:   3
... event mask:             0000000700000003
NMI watchdog enabled, takes one hw-pmu counter.
Brought up 1 CPUs
Total of 1 processors activated (4256.06 BogoMIPS).
devtmpfs: initialized
print_constraints: dummy:=20
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (b=
ase 0xe0000000)
PCI: not using MMCONFIG
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: Added _OSI(Module Device)
ACPI: Added _OSI(Processor Device)
ACPI: Added _OSI(3.0 _SCP Extensions)
ACPI: Added _OSI(Processor Aggregator Device)
ACPI: EC: Look up EC in DSDT
ACPI Error: Field [CDW3] at 96 exceeds Buffer [NULL] size 64 (bits) (201201=
11/dsopcode-236)
ACPI Error: Method parse/execution failed [\_SB_._OSC] (Node ffff880121e989=
e8), AE_AML_BUFFER_LIMIT (20120111/psparse-536)
ACPI: Interpreter enabled
ACPI: (supports S0 S4 S5)
ACPI: Using IOAPIC for interrupt routing
PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (b=
ase 0xe0000000)
PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI motherboard r=
esources
ACPI: No dock devices found.
HEST: Table parsing has been initialized.
PCI: Using host bridge windows from ACPI; if necessary, use "pci=3Dnocrs" a=
nd report a bug
ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-7f])
pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
pci_root PNP0A03:00: host bridge window [mem 0xd8000000-0xfebfffff]
PCI host bridge to bus 0000:00
pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: root bus resource [mem 0xd8000000-0xfebfffff]
pci 0000:00:00.0: [8086:29f0] type 0 class 0x000600
pci 0000:00:01.0: [8086:29f1] type 1 class 0x000604
pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
pci 0000:00:06.0: [8086:29f9] type 1 class 0x000604
pci 0000:00:06.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: [8086:2940] type 1 class 0x000604
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.2: [8086:2944] type 1 class 0x000604
pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.3: [8086:2946] type 1 class 0x000604
pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.4: [8086:2948] type 1 class 0x000604
pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.5: [8086:294a] type 1 class 0x000604
pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.0: [8086:2934] type 0 class 0x000c03
pci 0000:00:1d.0: reg 20: [io  0x1000-0x101f]
pci 0000:00:1d.1: [8086:2935] type 0 class 0x000c03
pci 0000:00:1d.1: reg 20: [io  0x1020-0x103f]
pci 0000:00:1d.2: [8086:2936] type 0 class 0x000c03
pci 0000:00:1d.2: reg 20: [io  0x1040-0x105f]
pci 0000:00:1d.3: [8086:2939] type 0 class 0x000c03
pci 0000:00:1d.3: reg 20: [io  0x1060-0x107f]
pci 0000:00:1d.7: [8086:293a] type 0 class 0x000c03
pci 0000:00:1d.7: reg 10: [mem 0xfdbf0000-0xfdbf03ff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1e.0: [8086:244e] type 1 class 0x000604
pci 0000:00:1f.0: [8086:2916] type 0 class 0x000601
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0300 (mask 000f)
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 0600 (mask 007f)
pci 0000:00:1f.2: [8086:2920] type 0 class 0x000101
pci 0000:00:1f.2: reg 10: [io  0x1080-0x1087]
pci 0000:00:1f.2: reg 14: [io  0x1088-0x108b]
pci 0000:00:1f.2: reg 18: [io  0x1090-0x1097]
pci 0000:00:1f.2: reg 1c: [io  0x1098-0x109b]
pci 0000:00:1f.2: reg 20: [io  0x10a0-0x10af]
pci 0000:00:1f.2: reg 24: [io  0x10b0-0x10bf]
pci 0000:00:1f.5: [8086:2926] type 0 class 0x000101
pci 0000:00:1f.5: reg 10: [io  0x10c0-0x10c7]
pci 0000:00:1f.5: reg 14: [io  0x10c8-0x10cb]
pci 0000:00:1f.5: reg 18: [io  0x10d0-0x10d7]
pci 0000:00:1f.5: reg 1c: [io  0x10d8-0x10db]
pci 0000:00:1f.5: reg 20: [io  0x10e0-0x10ef]
pci 0000:00:1f.5: reg 24: [io  0x10f0-0x10ff]
pci 0000:15:00.0: [1077:2432] type 0 class 0x000c04
pci 0000:15:00.0: reg 10: [io  0x4000-0x40ff]
pci 0000:15:00.0: reg 14: [mem 0xfdff0000-0xfdff3fff 64bit]
pci 0000:15:00.0: reg 30: [mem 0x00000000-0x0003ffff pref]
pci 0000:15:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it=
 with 'pcie_aspm=3Dforce'
pci 0000:00:01.0: PCI bridge to [bus 15-1a]
pci 0000:00:01.0:   bridge window [io  0x4000-0x4fff]
pci 0000:00:01.0:   bridge window [mem 0xfdf00000-0xfdffffff]
pci 0000:00:06.0: PCI bridge to [bus 12-14]
pci 0000:02:00.0: [1166:0103] type 1 class 0x000604
pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it=
 with 'pcie_aspm=3Dforce'
pci 0000:00:1c.0: PCI bridge to [bus 02-03]
pci 0000:00:1c.0:   bridge window [mem 0xfde00000-0xfdefffff]
pci 0000:03:04.0: [14e4:1678] type 0 class 0x000200
pci 0000:03:04.0: reg 10: [mem 0xfdef0000-0xfdefffff 64bit]
pci 0000:03:04.0: reg 18: [mem 0xfdee0000-0xfdeeffff 64bit]
pci 0000:03:04.0: PME# supported from D3hot D3cold
pci 0000:03:04.1: [14e4:1678] type 0 class 0x000200
pci 0000:03:04.1: reg 10: [mem 0xfded0000-0xfdedffff 64bit]
pci 0000:03:04.1: reg 18: [mem 0xfdec0000-0xfdecffff 64bit]
pci 0000:03:04.1: PME# supported from D3hot D3cold
pci 0000:02:00.0: PCI bridge to [bus 03-03]
pci 0000:02:00.0:   bridge window [mem 0xfde00000-0xfdefffff]
pci 0000:00:1c.2: PCI bridge to [bus 04-06]
pci 0000:00:1c.3: PCI bridge to [bus 07-09]
pci 0000:00:1c.4: PCI bridge to [bus 0a-0c]
pci 0000:00:1c.5: PCI bridge to [bus 0d-11]
pci 0000:01:02.0: [1002:515e] type 0 class 0x000300
pci 0000:01:02.0: reg 10: [mem 0xd8000000-0xdfffffff pref]
pci 0000:01:02.0: reg 14: [io  0x3000-0x30ff]
pci 0000:01:02.0: reg 18: [mem 0xfddf0000-0xfddfffff]
pci 0000:01:02.0: reg 30: [mem 0x00000000-0x0001ffff pref]
pci 0000:01:02.0: supports D1 D2
pci 0000:01:04.0: [0e11:b203] type 0 class 0x000880
pci 0000:01:04.0: reg 10: [io  0x2800-0x28ff]
pci 0000:01:04.0: reg 14: [mem 0xfdde0000-0xfdde01ff]
pci 0000:01:04.0: PME# supported from D0 D3hot D3cold
pci 0000:01:04.2: [0e11:b204] type 0 class 0x000880
pci 0000:01:04.2: reg 10: [io  0x3400-0x34ff]
pci 0000:01:04.2: reg 14: [mem 0xfddd0000-0xfddd07ff]
pci 0000:01:04.2: reg 18: [mem 0xfddc0000-0xfddc3fff]
pci 0000:01:04.2: reg 1c: [mem 0xfdd00000-0xfdd7ffff]
pci 0000:01:04.2: reg 30: [mem 0x00000000-0x0000ffff pref]
pci 0000:01:04.2: PME# supported from D0 D3hot D3cold
pci 0000:01:04.4: [103c:3300] type 0 class 0x000c03
pci 0000:01:04.4: reg 20: [io  0x3800-0x381f]
pci 0000:01:04.4: PME# supported from D0 D3hot D3cold
pci 0000:01:04.6: [103c:3302] type 0 class 0x000c07
pci 0000:01:04.6: reg 10: [mem 0xfdcf0000-0xfdcf00ff]
pci 0000:01:04.6: PME# supported from D0 D3hot D3cold
pci 0000:00:1e.0: PCI bridge to [bus 01-01] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0x2000-0x3fff]
pci 0000:00:1e.0:   bridge window [mem 0xfdc00000-0xfddfffff]
pci 0000:00:1e.0:   bridge window [mem 0xd8000000-0xdfffffff 64bit pref]
pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive =
decode)
pci 0000:00:1e.0:   bridge window [mem 0xd8000000-0xfebfffff] (subtractive =
decode)
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.IP2P._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.ICHE._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.ICHE.BCME._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.IPE2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.IPE3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.IPE4._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.IPE5._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PTA0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEG2._PRT]
 pci0000:00: Requesting ACPI _OSC control (0x1d)
 pci0000:00: ACPI _OSC request failed (AE_NOT_FOUND), returned control mask=
: 0x1d
ACPI _OSC control for PCIe not granted, disabling ASPM
ACPI: PCI Interrupt Link [LNKA] (IRQs 5 7 10 *11)
ACPI: PCI Interrupt Link [LNKB] (IRQs 5 7 *10 11)
ACPI: PCI Interrupt Link [LNKC] (IRQs 5 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKD] (IRQs 5 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKE] (IRQs 5 *7 10 11)
ACPI: PCI Interrupt Link [LNKF] (IRQs *5 7 10 11)
ACPI: PCI Interrupt Link [LNKG] (IRQs 5 7 *10 11)
ACPI: PCI Interrupt Link [LNKH] (IRQs 5 7 10 *11)
vgaarb: device added: PCI:0000:01:02.0,decodes=3Dio+mem,owns=3Dio+mem,locks=
=3Dnone
vgaarb: loaded
vgaarb: bridge control possible 0000:01:02.0
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: pci_cache_line_size set to 64 bytes
reserve RAM buffer: 000000000009fc00 - 000000000009ffff=20
reserve RAM buffer: 00000000d7e66000 - 00000000d7ffffff=20
reserve RAM buffer: 00000000d7e6f000 - 00000000d7ffffff=20
reserve RAM buffer: 0000000127fff000 - 0000000127ffffff=20
NetLabel: Initializing
NetLabel:  domain hash size =3D 128
NetLabel:  protocols =3D UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
HPET: 4 timers in total, 0 timers will be used for per-cpu timer
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
hpet0: 4 comparators, 64-bit 14.318180 MHz counter
Switching to clocksource hpet
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp 00:00: [bus 00-7f]
pnp 00:00: [io  0x0000-0x0cf7 window]
pnp 00:00: [io  0x0d00-0xffff window]
pnp 00:00: [mem 0x000a0000-0x000bffff window]
pnp 00:00: [mem 0xd8000000-0xfebfffff window]
pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
pnp 00:01: [io  0x0070-0x0077]
pnp 00:01: [io  0x0408-0x040f]
pnp 00:01: [io  0x04d0-0x04d1]
pnp 00:01: [io  0x0020-0x003f]
pnp 00:01: [io  0x00a0-0x00bf]
pnp 00:01: [io  0x0090-0x009f]
pnp 00:01: [io  0x0050-0x0053]
pnp 00:01: [io  0x00f0]
pnp 00:01: [io  0x0700-0x071f]
pnp 00:01: [io  0x0800-0x083f]
pnp 00:01: [io  0x0900-0x097f]
pnp 00:01: [io  0x0010-0x001f]
pnp 00:01: [io  0x0c80-0x0c83]
pnp 00:01: [io  0x0ca2-0x0ca5]
pnp 00:01: [io  0x0cd4-0x0cd7]
pnp 00:01: [io  0x0f50-0x0f58]
pnp 00:01: [io  0x00f0]
pnp 00:01: [io  0x0ca0-0x0ca1]
pnp 00:01: [io  0x0ca4-0x0ca5]
pnp 00:01: [mem 0xe0000000-0xefffffff]
pnp 00:01: [io  0x02f8-0x02ff]
system 00:01: [io  0x0408-0x040f] has been reserved
system 00:01: [io  0x04d0-0x04d1] has been reserved
system 00:01: [io  0x0700-0x071f] has been reserved
system 00:01: [io  0x0800-0x083f] has been reserved
system 00:01: [io  0x0900-0x097f] has been reserved
system 00:01: [io  0x0c80-0x0c83] has been reserved
system 00:01: [io  0x0ca2-0x0ca5] has been reserved
system 00:01: [io  0x0cd4-0x0cd7] has been reserved
system 00:01: [io  0x0f50-0x0f58] has been reserved
system 00:01: [io  0x0ca0-0x0ca1] has been reserved
system 00:01: [io  0x0ca4-0x0ca5] has been reserved
system 00:01: [io  0x02f8-0x02ff] has been reserved
system 00:01: [mem 0xe0000000-0xefffffff] has been reserved
system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:02: [io  0x0ca2-0x0ca3]
pnp 00:02: Plug and Play ACPI device, IDs IPI0001 (active)
pnp 00:03: [mem 0xfed00000-0xfed003ff]
pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
pnp 00:04: [dma 7]
pnp 00:04: [io  0x0000-0x000f]
pnp 00:04: [io  0x0080-0x008f]
pnp 00:04: [io  0x00c0-0x00df]
pnp 00:04: Plug and Play ACPI device, IDs PNP0200 (active)
pnp 00:05: [io  0x0061]
pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
pnp 00:06: [io  0x0060]
pnp 00:06: [io  0x0064]
pnp 00:06: [irq 1]
pnp 00:06: Plug and Play ACPI device, IDs PNP0303 (active)
pnp 00:07: [irq 12]
pnp 00:07: Plug and Play ACPI device, IDs PNP0f13 PNP0f0e (active)
pnp 00:08: [io  0x002e-0x002f]
pnp 00:08: [io  0x004e-0x004f]
pnp 00:08: [io  0x0620-0x065f]
pnp 00:08: [io  0x0680-0x069f]
pnp 00:08: [io  0x0600-0x061f]
pnp 00:08: [io  0x0660-0x067f]
pnp 00:08: [io  0x0300-0x030f]
pnp 00:08: Plug and Play ACPI device, IDs PNP0a06 (active)
pnp 00:09: [irq 4]
pnp 00:09: [io  0x03f8-0x03ff]
pnp 00:09: Plug and Play ACPI device, IDs PNP0501 PNP0500 (active)
pnp: PnP ACPI: found 10 devices
ACPI: ACPI bus type pnp unregistered
PCI: max bus depth: 2 pci_try_num: 3
pci 0000:00:01.0: BAR 15: assigned [mem 0xf0000000-0xf00fffff pref]
pci 0000:15:00.0: BAR 6: assigned [mem 0xf0000000-0xf003ffff pref]
pci 0000:00:01.0: PCI bridge to [bus 15-1a]
pci 0000:00:01.0:   bridge window [io  0x4000-0x4fff]
pci 0000:00:01.0:   bridge window [mem 0xfdf00000-0xfdffffff]
pci 0000:00:01.0:   bridge window [mem 0xf0000000-0xf00fffff pref]
pci 0000:00:06.0: PCI bridge to [bus 12-14]
pci 0000:02:00.0: PCI bridge to [bus 03-03]
pci 0000:02:00.0:   bridge window [mem 0xfde00000-0xfdefffff]
pci 0000:00:1c.0: PCI bridge to [bus 02-03]
pci 0000:00:1c.0:   bridge window [mem 0xfde00000-0xfdefffff]
pci 0000:00:1c.2: PCI bridge to [bus 04-06]
pci 0000:00:1c.3: PCI bridge to [bus 07-09]
pci 0000:00:1c.4: PCI bridge to [bus 0a-0c]
pci 0000:00:1c.5: PCI bridge to [bus 0d-11]
pci 0000:01:02.0: BAR 6: assigned [mem 0xfdc00000-0xfdc1ffff pref]
pci 0000:01:04.2: BAR 6: assigned [mem 0xfdc20000-0xfdc2ffff pref]
pci 0000:00:1e.0: PCI bridge to [bus 01-01]
pci 0000:00:1e.0:   bridge window [io  0x2000-0x3fff]
pci 0000:00:1e.0:   bridge window [mem 0xfdc00000-0xfddfffff]
pci 0000:00:1e.0:   bridge window [mem 0xd8000000-0xdfffffff 64bit pref]
pci 0000:00:1e.0: setting latency timer to 64
pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: resource 7 [mem 0xd8000000-0xfebfffff]
pci_bus 0000:15: resource 0 [io  0x4000-0x4fff]
pci_bus 0000:15: resource 1 [mem 0xfdf00000-0xfdffffff]
pci_bus 0000:15: resource 2 [mem 0xf0000000-0xf00fffff pref]
pci_bus 0000:02: resource 1 [mem 0xfde00000-0xfdefffff]
pci_bus 0000:03: resource 1 [mem 0xfde00000-0xfdefffff]
pci_bus 0000:01: resource 0 [io  0x2000-0x3fff]
pci_bus 0000:01: resource 1 [mem 0xfdc00000-0xfddfffff]
pci_bus 0000:01: resource 2 [mem 0xd8000000-0xdfffffff 64bit pref]
pci_bus 0000:01: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:01: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:01: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:01: resource 7 [mem 0xd8000000-0xfebfffff]
NET: Registered protocol family 2
IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 524288 bind 65536)
TCP reno registered
UDP hash table entries: 2048 (order: 4, 65536 bytes)
UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
NET: Registered protocol family 1
pci 0000:01:02.0: Boot video device
PCI: CLS 64 bytes, default 64
Trying to unpack rootfs image as initramfs...
Freeing initrd memory: 5404k freed
PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Placing 64MB software IO TLB between ffff8800d3e5f000 - ffff8800d7e5f000
software IO TLB at phys 0xd3e5f000 - 0xd7e5f000
platform rtc_cmos: registered platform RTC device (no PNP device found)
audit: initializing netlink socket (disabled)
type=3D2000 audit(1331045624.764:1): initialized
HugeTLB registered 2 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
SGI XFS with ACLs, security attributes, large block/inode numbers, no debug=
 enabled
SGI XFS Quota Management subsystem
Btrfs loaded
msgmni has been set to 7906
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
pcieport 0000:00:01.0: irq 40 for MSI/MSI-X
pcieport 0000:00:06.0: irq 41 for MSI/MSI-X
pcieport 0000:00:1c.0: irq 42 for MSI/MSI-X
pcieport 0000:00:1c.2: irq 43 for MSI/MSI-X
pcieport 0000:00:1c.3: irq 44 for MSI/MSI-X
pcieport 0000:00:1c.4: irq 45 for MSI/MSI-X
pcieport 0000:00:1c.5: irq 46 for MSI/MSI-X
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
pciehp: PCI Express Hot Plug Controller Driver version: 0.4
acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
intel_idle: MWAIT substates: 0x20
intel_idle: does not run on family 6 model 15
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
ACPI: Power Button [PWRF]
thermal LNXTHERM:00: registered as thermal_zone0
ACPI: Thermal Zone [THM0] (8 C)
ERST: Failed to get Error Log Address Range.
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq =3D 3) is a 16550A
00:09: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
Non-volatile memory driver v1.3
Linux agpgart interface v0.103
brd: module loaded
loop: module loaded
Fixed MDIO Bus: probed
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
ehci_hcd 0000:00:1d.7: irq 21, io mem 0xfdbf0000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
usb usb1: New USB device found, idVendor=3D1d6b, idProduct=3D0002
usb usb1: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 3.3.0-rc3+ ehci_hcd
usb usb1: SerialNumber: 0000:00:1d.7
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: irq 21, io base 0x00001000
usb usb2: New USB device found, idVendor=3D1d6b, idProduct=3D0001
usb usb2: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb2: Product: UHCI Host Controller
usb usb2: Manufacturer: Linux 3.3.0-rc3+ uhci_hcd
usb usb2: SerialNumber: 0000:00:1d.0
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: irq 21, io base 0x00001020
usb usb3: New USB device found, idVendor=3D1d6b, idProduct=3D0001
usb usb3: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 3.3.0-rc3+ uhci_hcd
usb usb3: SerialNumber: 0000:00:1d.1
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: irq 21, io base 0x00001040
usb usb4: New USB device found, idVendor=3D1d6b, idProduct=3D0001
usb usb4: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 3.3.0-rc3+ uhci_hcd
usb usb4: SerialNumber: 0000:00:1d.2
Refined TSC clocksource calibration: 2127.999 MHz.
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.3: setting latency timer to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.3: irq 21, io base 0x00001060
usb usb5: New USB device found, idVendor=3D1d6b, idProduct=3D0001
usb usb5: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 3.3.0-rc3+ uhci_hcd
usb usb5: SerialNumber: 0000:00:1d.3
Switching to clocksource tsc
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
uhci_hcd 0000:01:04.4: UHCI Host Controller
uhci_hcd 0000:01:04.4: new USB bus registered, assigned bus number 6
uhci_hcd 0000:01:04.4: port count misdetected? forcing to 2 ports
uhci_hcd 0000:01:04.4: irq 23, io base 0x00003800
usb usb6: New USB device found, idVendor=3D1d6b, idProduct=3D0001
usb usb6: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb6: Product: UHCI Host Controller
usb usb6: Manufacturer: Linux 3.3.0-rc3+ uhci_hcd
usb usb6: SerialNumber: 0000:01:04.4
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f0e:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mousedev: PS/2 mouse device common for all mice
rtc_cmos rtc_cmos: RTC can wake from S4
rtc_cmos rtc_cmos: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one year, y3k, 114 bytes nvram, hpet irqs
cpuidle: using governor ladder
cpuidle: using governor menu
EFI Variables Facility v0.08 2004-May-17
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
TCP cubic registered
NET: Registered protocol family 17
registered taskstats version 1
IMA: No TPM chip found, activating TPM-bypass!
rtc_cmos rtc_cmos: setting system clock to 2012-03-06 14:53:47 UTC (1331045=
627)
Initializing network drop monitor service
Freeing unused kernel memory: 1468k freed
Write protecting the kernel read-only data: 12288k
Freeing unused kernel memory: 1636k freed
Freeing unused kernel memory: 1376k freed
dracut: dracut-004-32.el6
udev: starting version 147
udevd (65): /proc/65/oom_adj is deprecated, please use /proc/65/oom_score_a=
dj instead.
[drm] Initialized drm 1.1.0 20060810
[drm] radeon defaulting to kernel modesetting.
[drm] radeon kernel modesetting enabled.
[drm] initializing kernel modesetting (RV100 0x1002:0x515E 0x103C:0x31FB).
[drm] register mmio base: 0xFDDF0000
[drm] register mmio size: 65536
radeon 0000:01:02.0: VRAM: 128M 0x00000000D8000000 - 0x00000000DFFFFFFF (32=
M used)
radeon 0000:01:02.0: GTT: 512M 0x00000000B8000000 - 0x00000000D7FFFFFF
[drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[drm] Driver supports precise vblank timestamp query.
[drm] radeon: irq initialized.
[drm] Detected VRAM RAM=3D128M, BAR=3D128M
[drm] RAM width 16bits DDR
[TTM] Zone  kernel: Available graphics memory: 2026242 kiB.
[TTM] Initializing pool allocator.
usb 6-1: new full-speed USB device number 2 using uhci_hcd
[TTM] Initializing DMA pool allocator.
[drm] radeon: 32M of VRAM memory ready
[drm] radeon: 512M of GTT memory ready.
[drm] GART: num cpu pages 131072, num gpu pages 131072
[drm] radeon: ib pool ready.
[drm] PCIE GART of 512M enabled (table at 0x0000000037880000).
radeon 0000:01:02.0: WB disabled
[drm] fence driver on ring 0 use gpu addr 0xb8000000 and cpu addr 0xffff880=
037817000
[drm] Loading R100 Microcode
[drm] radeon: ring at 0x00000000B8001000
[drm] ring test succeeded in 1 usecs
[drm] ib test succeeded in 0 usecs
[drm] Radeon Display Connectors
[drm] Connector 0:
[drm]   VGA
[drm]   DDC: 0x60 0x60 0x60 0x60 0x60 0x60 0x60 0x60
[drm]   Encoders:
[drm]     CRT1: INTERNAL_DAC1
[drm] Connector 1:
[drm]   VGA
[drm]   DDC: 0x6c 0x6c 0x6c 0x6c 0x6c 0x6c 0x6c 0x6c
[drm]   Encoders:
[drm]     CRT2: INTERNAL_DAC2
[drm] fb mappable at 0xD8040000
[drm] vram apper at 0xD8000000
[drm] size 786432
[drm] fb depth is 8
[drm]    pitch is 1024
fbcon: radeondrmfb (fb0) is primary device
Console: switching to colour frame buffer device 128x48
fb0: radeondrmfb frame buffer device
drm: registered panic notifier
[drm] Initialized radeon 2.13.0 20080528 for 0000:01:02.0 on minor 0
usb 6-1: New USB device found, idVendor=3D03f0, idProduct=3D1027
usb 6-1: New USB device strings: Mfr=3D1, Product=3D2, SerialNumber=3D0
usb 6-1: Product: Virtual Keyboard
usb 6-1: Manufacturer: HP
dracut: Starting plymouth daemon
input: HP Virtual Keyboard as /devices/pci0000:00/0000:00:1e.0/0000:01:04.4=
/usb6/6-1/6-1:1.0/input/input1
generic-usb 0003:03F0:1027.0001: input,hidraw0: USB HID v1.01 Keyboard [HP =
Virtual Keyboard] on usb-0000:01:04.4-1/input0
input: HP Virtual Keyboard as /devices/pci0000:00/0000:00:1e.0/0000:01:04.4=
/usb6/6-1/6-1:1.1/input/input2
generic-usb 0003:03F0:1027.0002: input,hidraw1: USB HID v1.01 Mouse [HP Vir=
tual Keyboard] on usb-0000:01:04.4-1/input1
qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driver: 8.03.07.12-=
k.
qla2xxx [0000:15:00.0]-001d: : Found an ISP2432 irq 16 iobase 0xffffc900006=
70000.
qla2xxx [0000:15:00.0]-0035:0: MSI-X; Unsupported ISP2432 (0x2, 0x3).
qla2xxx 0000:15:00.0: irq 47 for MSI/MSI-X
scsi0 : qla2xxx
qla2xxx [0000:15:00.0]-00fb:0: QLogic QLE2460 - PCI-Express Single Channel =
4Gb Fibre Channel HBA.
qla2xxx [0000:15:00.0]-00fc:0: ISP2432: PCIe (2.5GT/s x4) @ 0000:15:00.0 hd=
ma+ host#=3D0 fw=3D5.03.02 (496).
ata_piix 0000:00:1f.2: version 2.13
ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
ata_piix 0000:00:1f.2: setting latency timer to 64
scsi1 : ata_piix
scsi2 : ata_piix
ata1: SATA max UDMA/133 cmd 0x1080 ctl 0x1088 bmdma 0x10a0 irq 20
ata2: SATA max UDMA/133 cmd 0x1090 ctl 0x1098 bmdma 0x10a8 irq 20
ata_piix 0000:00:1f.5: MAP [ P0 -- P1 -- ]
ata_piix 0000:00:1f.5: setting latency timer to 64
scsi3 : ata_piix
scsi4 : ata_piix
ata3: SATA max UDMA/133 cmd 0x10c0 ctl 0x10c8 bmdma 0x10e0 irq 20
ata4: SATA max UDMA/133 cmd 0x10d0 ctl 0x10d8 bmdma 0x10e8 irq 20
ata4: SATA link down (SStatus 0 SControl 300)
ata2.00: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.01: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.01: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-7: GB0750C8047, HPG1, max UDMA/133
ata1.00: 1465149168 sectors, multi 8: LBA48 NCQ (depth 0/32)
ata1.01: ATA-7: GB0750C8047, HPG1, max UDMA/133
ata1.01: 1465149168 sectors, multi 8: LBA48 NCQ (depth 0/32)
ata2.00: ATA-7: MTRON MSP-SATA7035, 0.18R1H3, max UDMA/133
ata2.00: 62504960 sectors, multi 1: LBA=20
ata2.01: ATA-7: GB0750C8047, HPG1, max UDMA/133
ata2.01: 1465149168 sectors, multi 8: LBA48 NCQ (depth 0/32)
ata1.00: configured for UDMA/133
ata1.01: configured for UDMA/133
scsi: waiting for bus probes to complete ...
ata2.00: configured for UDMA/133
ata2.01: configured for UDMA/133
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata3.00: ATAPI: HL-DT-STDVD-ROM GDR-R10N, 2.02, max UDMA/33
ata3.00: applying bridge limits
ata3.00: configured for UDMA/33
scsi 1:0:0:0: Direct-Access     ATA      GB0750C8047      HPG1 PQ: 0 ANSI: 5
scsi 1:0:1:0: Direct-Access     ATA      GB0750C8047      HPG1 PQ: 0 ANSI: 5
scsi 2:0:0:0: Direct-Access     ATA      MTRON MSP-SATA70 0.18 PQ: 0 ANSI: 5
scsi 2:0:1:0: Direct-Access     ATA      GB0750C8047      HPG1 PQ: 0 ANSI: 5
scsi 3:0:0:0: CD-ROM            HL-DT-ST DVD-ROM GDR-R10N 2.02 PQ: 0 ANSI: 5
sd 1:0:0:0: [sda] 1465149168 512-byte logical blocks: (750 GB/698 GiB)
sd 1:0:1:0: [sdb] 1465149168 512-byte logical blocks: (750 GB/698 GiB)
sd 2:0:0:0: [sdc] 62504960 512-byte logical blocks: (32.0 GB/29.8 GiB)
sd 2:0:1:0: [sdd] 1465149168 512-byte logical blocks: (750 GB/698 GiB)
sd 1:0:0:0: [sda] Write Protect is off
sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdc] Write Protect is off
sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 1:0:1:0: [sdb] Write Protect is off
sd 1:0:1:0: [sdb] Mode Sense: 00 3a 00 00
sd 2:0:1:0: [sdd] Write Protect is off
sd 2:0:1:0: [sdd] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't suppo=
rt DPO or FUA
sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't suppor=
t DPO or FUA
sd 1:0:1:0: [sdb] Write cache: disabled, read cache: enabled, doesn't suppo=
rt DPO or FUA
sd 2:0:1:0: [sdd] Write cache: disabled, read cache: enabled, doesn't suppo=
rt DPO or FUA
 sdd: sdd1
 sda: sda1
 sdc: unknown partition table
sd 2:0:1:0: [sdd] Attached SCSI disk
sd 2:0:0:0: [sdc] Attached SCSI disk
sd 1:0:0:0: [sda] Attached SCSI disk
 sdb: sdb1 sdb2 sdb3
sd 1:0:1:0: [sdb] Attached SCSI disk
sr0: scsi3-mmc drive: 24x/24x cd/rw xa/form2 cdda tray
cdrom: Uniform CD-ROM driver Revision: 3.20
sr 3:0:0:0: Attached scsi CD-ROM sr0
scsi 0:0:0:0: RAID              HP       HSV400           0952 PQ: 0 ANSI: 5
scsi 0:0:0:1: Direct-Access     HP       HSV400           0952 PQ: 0 ANSI: 5
sd 0:0:0:1: [sde] 209715200 512-byte logical blocks: (107 GB/100 GiB)
EXT4-fs (sdb3): mounted filesystem with ordered data mode. Opts: (null)
scsi 0:0:1:0: RAID              HP       HSV400           0952 PQ: 0 ANSI: 5
sd 0:0:0:1: [sde] Write Protect is off
sd 0:0:0:1: [sde] Mode Sense: 97 00 10 08
scsi 0:0:1:1: Direct-Access     HP       HSV400           0952 PQ: 0 ANSI: 5
sd 0:0:0:1: [sde] Write cache: disabled, read cache: enabled, supports DPO =
and FUA
sd 0:0:1:1: [sdf] 209715200 512-byte logical blocks: (107 GB/100 GiB)
scsi 0:0:2:0: RAID              HP       HSV400           0952 PQ: 0 ANSI: 5
sd 0:0:1:1: [sdf] Write Protect is off
sd 0:0:1:1: [sdf] Mode Sense: 97 00 10 08
 sde: unknown partition table
scsi 0:0:2:1: Direct-Access     HP       HSV400           0952 PQ: 0 ANSI: 5
sd 0:0:1:1: [sdf] Write cache: disabled, read cache: enabled, supports DPO =
and FUA
sd 0:0:2:1: [sdg] 209715200 512-byte logical blocks: (107 GB/100 GiB)
scsi 0:0:3:0: RAID              HP       HSV400           0952 PQ: 0 ANSI: 5
sd 0:0:0:1: [sde] Attached SCSI disk
dracut: Mounted root filesystem /dev/sdb3
sd 0:0:2:1: [sdg] Write Protect is off
sd 0:0:2:1: [sdg] Mode Sense: 97 00 10 08
scsi 0:0:3:1: Direct-Access     HP       HSV400           0952 PQ: 0 ANSI: 5
 sdf: unknown partition table
sd 0:0:2:1: [sdg] Write cache: disabled, read cache: enabled, supports DPO =
and FUA
sd 0:0:1:1: [sdf] Attached SCSI disk
sd 0:0:3:1: [sdh] 209715200 512-byte logical blocks: (107 GB/100 GiB)
scsi 0:0:4:0: RAID              IBM      2810XIV-LUN-0    10.2 PQ: 0 ANSI: 5
 sdg: unknown partition table
sd 0:0:3:1: [sdh] Write Protect is off
sd 0:0:3:1: [sdh] Mode Sense: 97 00 10 08
scsi 0:0:5:0: RAID              IBM      2810XIV-LUN-0    10.2 PQ: 0 ANSI: 5
sd 0:0:2:1: [sdg] Attached SCSI disk
sd 0:0:3:1: [sdh] Write cache: disabled, read cache: enabled, supports DPO =
and FUA
scsi 0:0:6:0: RAID              IBM      2810XIV-LUN-0    10.2 PQ: 0 ANSI: 5
 sdh: unknown partition table
sd 0:0:3:1: [sdh] Attached SCSI disk
scsi 0:0:7:1: Direct-Access     NETAPP   LUN              8020 PQ: 0 ANSI: 5
sd 0:0:7:1: [sdi] 629225472 512-byte logical blocks: (322 GB/300 GiB)
scsi 0:0:8:0: RAID              IBM      2810XIV-LUN-0    10.2 PQ: 0 ANSI: 5
sd 0:0:7:1: [sdi] Write Protect is off
sd 0:0:7:1: [sdi] Mode Sense: bd 00 00 08
sd 0:0:7:1: [sdi] Write cache: disabled, read cache: enabled, doesn't suppo=
rt DPO or FUA
dracut: Switching root
scsi 0:0:9:1: Direct-Access     NETAPP   LUN              8020 PQ: 0 ANSI: 5
scsi 0:0:10:1: Direct-Access     NETAPP   LUN              8020 PQ: 0 ANSI:=
 5
sd 0:0:9:1: [sdj] 629225472 512-byte logical blocks: (322 GB/300 GiB)
 sdi: unknown partition table
scsi 0:0:11:1: Direct-Access     NETAPP   LUN              8020 PQ: 0 ANSI:=
 5
sd 0:0:10:1: [sdk] 629225472 512-byte logical blocks: (322 GB/300 GiB)
sd 0:0:11:1: [sdl] 629225472 512-byte logical blocks: (322 GB/300 GiB)
sd 0:0:9:1: [sdj] Write Protect is off
sd 0:0:9:1: [sdj] Mode Sense: bd 00 00 08
sd 0:0:10:1: [sdk] Write Protect is off
sd 0:0:10:1: [sdk] Mode Sense: bd 00 00 08
sd 0:0:7:1: [sdi] Attached SCSI disk
sd 0:0:9:1: [sdj] Write cache: disabled, read cache: enabled, doesn't suppo=
rt DPO or FUA
sd 0:0:10:1: [sdk] Write cache: disabled, read cache: enabled, doesn't supp=
ort DPO or FUA
sd 0:0:11:1: [sdl] Write Protect is off
sd 0:0:11:1: [sdl] Mode Sense: bd 00 00 08
sd 0:0:11:1: [sdl] Write cache: disabled, read cache: enabled, doesn't supp=
ort DPO or FUA
 sdl: unknown partition table
 sdj: unknown partition table
 sdk: unknown partition table
sd 0:0:11:1: [sdl] Attached SCSI disk
sd 0:0:9:1: [sdj] Attached SCSI disk
sd 0:0:10:1: [sdk] Attached SCSI disk
readahead: starting
udev: starting version 147
SMP alternatives: switching to SMP code
WARNING! power/level is deprecated; use power/control instead
EDAC MC: Ver: 2.1.0
Booting Node 0 Processor 3 APIC 0x3
smpboot cpu 3: start_ip =3D 9a000
EDAC MC0: Giving out device to 'i3200_edac' 'i3200': DEV 0000:00:00.0
NMI watchdog enabled, takes one hw-pmu counter.
Booting Node 0 Processor 2 APIC 0x1
smpboot cpu 2: start_ip =3D 9a000
NMI watchdog enabled, takes one hw-pmu counter.
Booting Node 0 Processor 1 APIC 0x2
smpboot cpu 1: start_ip =3D 9a000
NMI watchdog enabled, takes one hw-pmu counter.
sd 1:0:0:0: Attached scsi generic sg0 type 0
sd 1:0:1:0: Attached scsi generic sg1 type 0
sd 2:0:0:0: Attached scsi generic sg2 type 0
sd 2:0:1:0: Attached scsi generic sg3 type 0
sr 3:0:0:0: Attached scsi generic sg4 type 5
scsi 0:0:0:0: Attached scsi generic sg5 type 12
sd 0:0:0:1: Attached scsi generic sg6 type 0
scsi 0:0:1:0: Attached scsi generic sg7 type 12
sd 0:0:1:1: Attached scsi generic sg8 type 0
scsi 0:0:2:0: Attached scsi generic sg9 type 12
sd 0:0:2:1: Attached scsi generic sg10 type 0
scsi 0:0:3:0: Attached scsi generic sg11 type 12
sd 0:0:3:1: Attached scsi generic sg12 type 0
scsi 0:0:4:0: Attached scsi generic sg13 type 12
scsi 0:0:5:0: Attached scsi generic sg14 type 12
scsi 0:0:6:0: Attached scsi generic sg15 type 12
sd 0:0:7:1: Attached scsi generic sg16 type 0
scsi 0:0:8:0: Attached scsi generic sg17 type 12
sd 0:0:9:1: Attached scsi generic sg18 type 0
sd 0:0:10:1: Attached scsi generic sg19 type 0
sd 0:0:11:1: Attached scsi generic sg20 type 0
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
iTCO_vendor_support: vendor-support=3D0
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.07
iTCO_wdt: Found a ICH9R TCO device (Version=3D2, TCOBASE=3D0x0960)
iTCO_wdt: initialized. heartbeat=3D30 sec (nowayout=3D0)
input: PC Speaker as /devices/platform/pcspkr/input/input3
tg3.c:v3.122 (December 7, 2011)
tg3 0000:03:04.0: eth0: Tigon3 [partno(N/A) rev 9003] (PCIX:133MHz:64-bit) =
MAC address 00:21:5a:08:dc:18
tg3 0000:03:04.0: eth0: attached PHY is 5714 (10/100/1000Base-T Ethernet) (=
WireSpeed[1], EEE[0])
tg3 0000:03:04.0: eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[1] TSOcap[1]
tg3 0000:03:04.0: eth0: dma_rwctrl[76148000] dma_mask[40-bit]
tg3 0000:03:04.1: eth1: Tigon3 [partno(N/A) rev 9003] (PCIX:133MHz:64-bit) =
MAC address 00:21:5a:08:dc:19
tg3 0000:03:04.1: eth1: attached PHY is 5714 (10/100/1000Base-T Ethernet) (=
WireSpeed[1], EEE[0])
tg3 0000:03:04.1: eth1: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
tg3 0000:03:04.1: eth1: dma_rwctrl[76148000] dma_mask[40-bit]
hpwdt: New timer passed in is 30 seconds.
hpwdt 0000:01:04.0: HP Watchdog Timer Driver: NMI decoding initialized, all=
ow kernel dump: OFF (default =3D 0/OFF), priority: LAST (default =3D 0/LAST=
).
hpwdt 0000:01:04.0: Unable to register miscdev on minor=3D130 (err=3D-16).
hpwdt: probe of 0000:01:04.0 failed with error -16
ipmi message handler version 39.2
IPMI System Interface driver.
ipmi_si 0000:01:04.6: probing via PCI
ipmi_si 0000:01:04.6: [mem 0xfdcf0000-0xfdcf00ff] regsize 1 spacing 1 irq 22
ipmi_si: Adding PCI-specified kcs state machine
ipmi_si: probing via ACPI
ipmi_si 00:02: [io  0x0ca2-0x0ca3] regsize 1 spacing 1 irq 0
ipmi_si: Adding ACPI-specified kcs state machine
ipmi_si: probing via SMBIOS
ipmi_si: SMBIOS: io 0xca2 regsize 1 spacing 1 irq 0
ipmi_si: Adding SMBIOS-specified kcs state machine duplicate interface
ipmi_si: probing via SPMI
ipmi_si: SPMI: io 0xca2 regsize 2 spacing 2 irq 0
ipmi_si: Adding SPMI-specified kcs state machine duplicate interface
ipmi_si: Trying PCI-specified kcs state machine at mem address 0xfdcf0000, =
slave address 0x0, irq 22
ipmi_si 0000:01:04.6: Using irq 22
ipmi_si 0000:01:04.6: Found new BMC (man_id: 0x00000b, prod_id: 0x2000, dev=
_id: 0x11)
ipmi_si 0000:01:04.6: IPMI kcs interface initialized
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.22.0-ioctl (2011-10-19) initialised: dm-devel@redha=
t.com
device-mapper: multipath: version 1.3.0 loaded
device-mapper: multipath round-robin: version 1.0.0 loaded
device-mapper: table: 253:2: multipath: error getting device
device-mapper: ioctl: error adding target to table
device-mapper: table: 253:2: multipath: error getting device
device-mapper: ioctl: error adding target to table
EXT4-fs (sdb3): re-mounted. Opts: (null)
kjournald starting.  Commit interval 5 seconds
EXT3-fs (sdb1): using internal journal
EXT3-fs (sdb1): mounted filesystem with ordered data mode
NET: Registered protocol family 10
ip6_tables: (C) 2000-2006 Netfilter Core Team
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
tg3 0000:03:04.0: irq 48 for MSI/MSI-X
ADDRCONF(NETDEV_UP): eth0: link is not ready
tg3 0000:03:04.0: eth0: Link is up at 1000 Mbps, full duplex
tg3 0000:03:04.0: eth0: Flow control is off for TX and off for RX
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
p4-clockmod: Warning: EST-capable CPU detected. The acpi-cpufreq module off=
ers voltage scaling in addition to frequency scaling. You should use that i=
nstead of p4-clockmod, if possible.
p4-clockmod: P4/Xeon(TM) CPU On-Demand Clock Modulation available
RPC: Registered named UNIX socket transport module.
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
eth0: no IPv6 routers present

--=-=-=--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755757Ab1EOOcj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 10:32:39 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:35638 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754038Ab1EOOch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 10:32:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=k6aKUTqQV1X3fDf9PfGpAftEqFHvqkVZVVSsYTw5YTdako+32NlheBl4fooCRJtcFs
         wZPWGfv8QbxYOzzKmaRH8il0xdo8AYcNwpBqDdk3yG1E0bq3XMSg+Df8/f9GQ6HufICD
         9cUJ+1kr0LMir2CO8Ztqew2aHVc5pCT774csQ=
MIME-Version: 1.0
Date: Sun, 15 May 2011 16:32:36 +0200
Message-ID: <BANLkTimboHpcbpKAeGzTEL1j+78vX3RFiA@mail.gmail.com>
Subject: BUG() in 2.6.38.6
From: Fabio Coatti <fabio.coatti@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(please keep me CC'ed in answers, as I'm not right now subscribed, many thanks)

I'm getting a BUG() during boot process. The same issue is not present
in 2.6.38.5 so I think it could be interesting to post here. I've had
to use netconsole to get some messages.
Of course I'm available for any other information that could be useful.


May 15 16:09:24 192.168.42.2 Initializing cgroup subsys cpuset
May 15 16:09:24 192.168.42.2 Initializing cgroup subsys cpu
May 15 16:09:24 192.168.42.2 Linux version 2.6.38.6 (root@kefk) (gcc
version 4.4.5 (Gentoo 4.4.5 p1.0, pie-0.4.5) ) #4 SMP PREEMPT Sun May
15 15:54:14 CEST 2011
May 15 16:09:24 192.168.42.2 Command line: BOOT_IMAGE=2.6.38.6_nc ro
root=902 domdadm real_root=/dev/md2
netconsole=@192.168.42.2/,@192.168.42.105/
May 15 16:09:24 192.168.42.2 BIOS-provided physical RAM map:
May 15 16:09:24 192.168.42.2 BIOS-e820: 0000000000000000 -
000000000009e000 (usable)
May 15 16:09:24 192.168.42.2 BIOS-e820: 000000000009e000 -
00000000000a0000 (reserved)
May 15 16:09:24 192.168.42.2 BIOS-e820: 00000000000f0000 -
0000000000100000 (reserved)
May 15 16:09:24 192.168.42.2 BIOS-e820: 0000000000100000 -
00000000afed0000 (usable)
May 15 16:09:24 192.168.42.2 BIOS-e820: 00000000afed0000 -
00000000afee0000 (ACPI NVS)
May 15 16:09:29 192.168.42.2 BIOS-e820: 00000000afee0000 -
00000000afef0000 (ACPI data)
May 15 16:09:29 192.168.42.2 BIOS-e820: 00000000afef0000 -
00000000aff00000 (reserved)
May 15 16:09:29 192.168.42.2 BIOS-e820: 00000000b0000000 -
00000000c0000000 (reserved)
May 15 16:09:29 192.168.42.2 BIOS-e820: 00000000f0000000 -
00000000f4000000 (reserved)
May 15 16:09:29 192.168.42.2 BIOS-e820: 00000000fec00000 -
0000000100000000 (reserved)
May 15 16:09:29 192.168.42.2 BIOS-e820: 0000000100000000 -
0000000240000000 (usable)
May 15 16:09:29 192.168.42.2 NX (Execute Disable) protection: active
May 15 16:09:29 192.168.42.2 DMI 2.5 present.
May 15 16:09:29 192.168.42.2 No AGP bridge found
May 15 16:09:29 192.168.42.2 last_pfn = 0x240000 max_arch_pfn = 0x400000000
May 15 16:09:29 192.168.42.2 x86 PAT enabled: cpu 0, old
0x7040600070406, new 0x7010600070106
May 15 16:09:29 192.168.42.2 last_pfn = 0xafed0 max_arch_pfn = 0x400000000
May 15 16:09:29 192.168.42.2 Using GB pages for direct mapping
May 15 16:09:29 192.168.42.2 init_memory_mapping:
0000000000000000-00000000afed0000
May 15 16:09:29 192.168.42.2 init_memory_mapping:
0000000100000000-0000000240000000
May 15 16:09:29 192.168.42.2 ACPI: RSDP 00000000000f79b0 00024 (v02 Nvidia)
May 15 16:09:29 192.168.42.2 ACPI: XSDT 00000000afee0100 0004C (v01
Nvidia ASUSACPI 42302E31 AWRD 00000000)
May 15 16:09:29 192.168.42.2 ACPI: FACP 00000000afeea800 000F4 (v03
Nvidia ASUSACPI 42302E31 AWRD 00000000)
May 15 16:09:29 192.168.42.2 ACPI Warning: Optional field
Pm2ControlBlock has zero address or length: 0x0000000000000000/0x1
(20110112/tbfadt-557)
May 15 16:09:29 192.168.42.2 ACPI: DSDT 00000000afee0280 0A527 (v01
NVIDIA ASUSACPI 00001000 MSFT 03000000)
May 15 16:09:29 192.168.42.2 ACPI: FACS 00000000afed0a80 00040
May 15 16:09:29 192.168.42.2 ACPI: SSDT 00000000afeeaa80 00544 (v01
PTLTD  POWERNOW 00000001  LTP 00000001)
May 15 16:09:29 192.168.42.2 ACPI: HPET 00000000afeeb040 00038 (v01
Nvidia ASUSACPI 42302E31 AWRD 00000098)
May 15 16:09:29 192.168.42.2 ACPI: MCFG 00000000afeeb0c0 0003C (v01
Nvidia ASUSACPI 42302E31 AWRD 00000000)
May 15 16:09:29 192.168.42.2 ACPI: APIC 00000000afeea940 000C6 (v01
Nvidia ASUSACPI 42302E31 AWRD 00000000)
May 15 16:09:29 192.168.42.2 No NUMA configuration found
May 15 16:09:29 192.168.42.2 Faking a node at 0000000000000000-0000000240000000
May 15 16:09:29 192.168.42.2 Initmem setup node 0
0000000000000000-0000000240000000
May 15 16:09:29 192.168.42.2 NODE_DATA [000000023fffb000 - 000000023fffffff]
May 15 16:09:29 192.168.42.2 Zone PFN ranges:
May 15 16:09:29 192.168.42.2 DMA      0x00000010 -> 0x00001000
May 15 16:09:29 192.168.42.2 DMA32    0x00001000 -> 0x00100000
May 15 16:09:29 192.168.42.2 Normal   0x00100000 -> 0x00240000
May 15 16:09:29 192.168.42.2 Movable zone start PFN for each node
May 15 16:09:29 192.168.42.2 early_node_map[3] active PFN ranges
May 15 16:09:29 192.168.42.2 0: 0x00000010 -> 0x0000009e
May 15 16:09:29 192.168.42.2 0: 0x00000100 -> 0x000afed0
May 15 16:09:29 192.168.42.2 0: 0x00100000 -> 0x00240000
May 15 16:09:29 192.168.42.2 ACPI: PM-Timer IO Port: 0x1008
May 15 16:09:29 192.168.42.2 ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
May 15 16:09:29 192.168.42.2 ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
May 15 16:09:29 192.168.42.2 ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
May 15 16:09:29 192.168.42.2 ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
May 15 16:09:29 192.168.42.2 ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] disabled)
May 15 16:09:29 192.168.42.2 ACPI: LAPIC (acpi_id[0x05] lapic_id[0x05] disabled)
May 15 16:09:29 192.168.42.2 ACPI: LAPIC (acpi_id[0x06] lapic_id[0x06] disabled)
May 15 16:09:29 192.168.42.2 ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] disabled)
May 15 16:09:29 192.168.42.2 ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
May 15 16:09:29 192.168.42.2 ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
May 15 16:09:29 192.168.42.2 ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
May 15 16:09:29 192.168.42.2 ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
May 15 16:09:29 192.168.42.2 ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
May 15 16:09:29 192.168.42.2 ACPI: LAPIC_NMI (acpi_id[0x05] high edge lint[0x1])
May 15 16:09:29 192.168.42.2 ACPI: LAPIC_NMI (acpi_id[0x06] high edge lint[0x1])
May 15 16:09:29 192.168.42.2 ACPI: LAPIC_NMI (acpi_id[0x07] high edge lint[0x1])
May 15 16:09:29 192.168.42.2 ACPI: IOAPIC (id[0x04]
address[0xfec00000] gsi_base[0])
May 15 16:09:29 192.168.42.2 IOAPIC[0]: apic_id 4, version 17, address
0xfec00000, GSI 0-23
May 15 16:09:29 192.168.42.2 ACPI: INT_SRC_OVR (bus 0 bus_irq 0
global_irq 2 dfl dfl)
May 15 16:09:29 192.168.42.2 ACPI: INT_SRC_OVR (bus 0 bus_irq 9
global_irq 9 high level)
May 15 16:09:29 192.168.42.2 ACPI: INT_SRC_OVR (bus 0 bus_irq 14
global_irq 14 high edge)
May 15 16:09:29 192.168.42.2 Using ACPI (MADT) for SMP configuration information
May 15 16:09:29 192.168.42.2 ACPI: HPET id: 0x10de8201 base: 0xfeff0000
May 15 16:09:29 192.168.42.2 SMP: Allowing 4 CPUs, 0 hotplug CPUs
May 15 16:09:29 192.168.42.2 Allocating PCI resources starting at
c0000000 (gap: c0000000:30000000)
May 15 16:09:29 192.168.42.2 setup_percpu: NR_CPUS:4 nr_cpumask_bits:4
nr_cpu_ids:4 nr_node_ids:1
May 15 16:09:29 192.168.42.2 PERCPU: Embedded 25 pages/cpu
@ffff8800afc00000 s73408 r8192 d20800 u524288
May 15 16:09:29 192.168.42.2 Built 1 zonelists in Zone order, mobility
grouping on.  Total pages: 1998940
May 15 16:09:29 192.168.42.2 Policy zone: Normal
May 15 16:09:29 192.168.42.2 Kernel command line:
BOOT_IMAGE=2.6.38.6_nc ro root=902 domdadm real_root=/dev/md2
netconsole=@192.168.42.2/,@192.168.42.105/
May 15 16:09:29 192.168.42.2 PID hash table entries: 4096 (order: 3,
32768 bytes)
May 15 16:09:29 192.168.42.2 Checking aperture...
May 15 16:09:29 192.168.42.2 No AGP bridge found
May 15 16:09:29 192.168.42.2 Node 0: aperture @ a4000000 size 32 MB
May 15 16:09:29 192.168.42.2 Aperture pointing to e820 RAM. Ignoring.
May 15 16:09:29 192.168.42.2 Your BIOS doesn't leave a aperture memory hole
May 15 16:09:29 192.168.42.2 Please enable the IOMMU option in the BIOS setup
May 15 16:09:29 192.168.42.2 This costs you 64 MB of RAM
May 15 16:09:29 192.168.42.2 Mapping aperture over 65536 KB of RAM @ a4000000
May 15 16:09:29 192.168.42.2 Memory: 7867392k/9437184k available
(3895k kernel code, 1312392k absent, 257400k reserved, 1678k data,
6368k init)
May 15 16:09:29 192.168.42.2 SLUB: Genslabs=15, HWalign=64, Order=0-3,
MinObjects=0, CPUs=4, Nodes=1
May 15 16:09:29 192.168.42.2 Preemptable hierarchical RCU implementation.
May 15 16:09:29 192.168.42.2    RCU-based detection of stalled CPUs is disabled.
May 15 16:09:29 192.168.42.2    Verbose stalled-CPUs detection is disabled.
May 15 16:09:29 192.168.42.2 NR_IRQS:4352 nr_irqs:712 16
May 15 16:09:29 192.168.42.2 Extended CMOS year: 2000
May 15 16:09:29 192.168.42.2 Console: colour VGA+ 80x25
May 15 16:09:29 192.168.42.2 console [tty0] enabled
May 15 16:09:29 192.168.42.2 allocated 81264640 bytes of page_cgroup
May 15 16:09:29 192.168.42.2 please try 'cgroup_disable=memory' option
if you don't want memory cgroups
May 15 16:09:29 192.168.42.2 Fast TSC calibration using PIT
May 15 16:09:29 192.168.42.2 Detected 2511.653 MHz processor.
May 15 16:09:29 192.168.42.2 Calibrating delay loop (skipped), value
calculated using timer frequency.. 5023.30 BogoMIPS (lpj=2511653)
May 15 16:09:29 192.168.42.2 pid_max: default: 32768 minimum: 301
May 15 16:09:29 192.168.42.2 Security Framework initialized
May 15 16:09:29 192.168.42.2 AppArmor: AppArmor disabled by boot time parameter
May 15 16:09:29 192.168.42.2 Dentry cache hash table entries: 1048576
(order: 11, 8388608 bytes)
May 15 16:09:29 192.168.42.2 Inode-cache hash table entries: 524288
(order: 10, 4194304 bytes)
May 15 16:09:29 192.168.42.2 Mount-cache hash table entries: 256
May 15 16:09:29 192.168.42.2 Initializing cgroup subsys ns
May 15 16:09:29 192.168.42.2 ns_cgroup deprecated: consider using the
'clone_children' flag without the ns_cgroup.
May 15 16:09:29 192.168.42.2 Initializing cgroup subsys memory
May 15 16:09:29 192.168.42.2 Initializing cgroup subsys devices
May 15 16:09:29 192.168.42.2 Initializing cgroup subsys freezer
May 15 16:09:29 192.168.42.2 Initializing cgroup subsys blkio
May 15 16:09:29 192.168.42.2 CPU: Physical Processor ID: 0
May 15 16:09:29 192.168.42.2 CPU: Processor Core ID: 0
May 15 16:09:29 192.168.42.2 mce: CPU supports 6 MCE banks
May 15 16:09:29 192.168.42.2 Freeing SMP alternatives: 16k freed
May 15 16:09:29 192.168.42.2 ACPI: Core revision 20110112
May 15 16:09:29 192.168.42.2 Setting APIC routing to flat
May 15 16:09:29 192.168.42.2 ..TIMER: vector=0x30 apic1=0 pin1=2
apic2=-1 pin2=-1
May 15 16:09:29 192.168.42.2 CPU0: AMD Phenom(tm) 9850 Quad-Core
Processor stepping 03
May 15 16:09:29 192.168.42.2 Performance Events: AMD PMU driver.
May 15 16:09:29 192.168.42.2 ... version:                0
May 15 16:09:29 192.168.42.2 ... bit width:              48
May 15 16:09:29 192.168.42.2 ... generic registers:      4
May 15 16:09:29 192.168.42.2 ... value mask:             0000ffffffffffff
May 15 16:09:29 192.168.42.2 ... max period:             00007fffffffffff
May 15 16:09:29 192.168.42.2 ... fixed-purpose events:   0
May 15 16:09:29 192.168.42.2 ... event mask:             000000000000000f
May 15 16:09:29 192.168.42.2 Booting Node   0, Processors  #1 #2 #3 Ok.
May 15 16:09:29 192.168.42.2 Brought up 4 CPUs
May 15 16:09:29 192.168.42.2 Total of 4 processors activated (20091.46
BogoMIPS).
May 15 16:09:29 192.168.42.2 devtmpfs: initialized
May 15 16:09:29 192.168.42.2 xor: automatically using best
checksumming function: generic_sse
May 15 16:09:29 192.168.42.2 generic_sse:  9828.000 MB/sec
May 15 16:09:29 192.168.42.2 xor: using function: generic_sse (9828.000 MB/sec)
May 15 16:09:29 192.168.42.2 NET: Registered protocol family 16
May 15 16:09:29 192.168.42.2 TOM: 00000000c0000000 aka 3072M
May 15 16:09:29 192.168.42.2 TOM2: 0000000240000000 aka 9216M
May 15 16:09:29 192.168.42.2 Extended Config Space enabled on 1 nodes
May 15 16:09:29 192.168.42.2 ACPI: bus type pci registered
May 15 16:09:29 192.168.42.2 PCI: MMCONFIG for domain 0000 [bus 00-3f]
at [mem 0xf0000000-0xf3ffffff] (base 0xf0000000)
May 15 16:09:29 192.168.42.2 PCI: MMCONFIG at [mem
0xf0000000-0xf3ffffff] reserved in E820
May 15 16:09:29 192.168.42.2 PCI: Using configuration type 1 for base access
May 15 16:09:29 192.168.42.2 bio: create slab <bio-0> at 0
May 15 16:09:29 192.168.42.2 raid6: int64x1   2285 MB/s

May 15 16:09:29 192.168.42.2 raid6: int64x2   2500 MB/s
May 15 16:09:29 192.168.42.2 raid6: int64x4   1957 MB/s
May 15 16:09:29 192.168.42.2 raid6: int64x8   1777 MB/s
May 15 16:09:29 192.168.42.2 raid6: sse2x1    3562 MB/s
May 15 16:09:29 192.168.42.2 raid6: sse2x2    5742 MB/s
May 15 16:09:29 192.168.42.2 raid6: sse2x4    7035 MB/s
May 15 16:09:29 192.168.42.2 raid6: using algorithm sse2x4 (7035 MB/s)
May 15 16:09:29 192.168.42.2 ACPI: Interpreter enabled
May 15 16:09:29 192.168.42.2 ACPI: (supports S0 S5)
May 15 16:09:29 192.168.42.2 ACPI: Using IOAPIC for interrupt routing
May 15 16:09:29 192.168.42.2 HEST: Table not found.
May 15 16:09:29 192.168.42.2 PCI: Using host bridge windows from ACPI;
if necessary, use "pci=nocrs" and report a bug
May 15 16:09:29 192.168.42.2 ACPI: PCI Root Bridge [PCI0] (domain 0000
[bus 00-ff])
May 15 16:09:29 192.168.42.2 pci_root PNP0A08:00: host bridge window
[io  0x0000-0x0cf7]
May 15 16:09:29 192.168.42.2 pci_root PNP0A08:00: host bridge window
[io  0x0d00-0xffff]
May 15 16:09:29 192.168.42.2 pci_root PNP0A08:00: host bridge window
[mem 0x000a0000-0x000bffff]
May 15 16:09:29 192.168.42.2 pci_root PNP0A08:00: host bridge window
[mem 0x000c0000-0x000dffff]
May 15 16:09:29 192.168.42.2 pci_root PNP0A08:00: host bridge window
[mem 0xafff0000-0xfebfffff]
May 15 16:09:29 192.168.42.2 pci 0000:00:08.0: PCI bridge to [bus
01-01] (subtractive decode)
May 15 16:09:29 192.168.42.2 pci 0000:00:0b.0: PCI bridge to [bus 02-02]
May 15 16:09:29 192.168.42.2 pci 0000:00:10.0: PCI bridge to [bus 03-06]
May 15 16:09:29 192.168.42.2 pci 0000:03:00.0: PCI bridge to [bus 04-06]
May 15 16:09:29 192.168.42.2 pci 0000:04:00.0: PCI bridge to [bus 05-05]
May 15 16:09:29 192.168.42.2 pci 0000:04:02.0: PCI bridge to [bus 06-06]
May 15 16:09:29 192.168.42.2 pci 0000:00:13.0: PCI bridge to [bus 07-07]
May 15 16:09:29 192.168.42.2 pci 0000:08:00.0: disabling ASPM on
pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
May 15 16:09:29 192.168.42.2 pci 0000:00:14.0: PCI bridge to [bus 08-08]
May 15 16:09:29 192.168.42.2 pci0000:00: Requesting ACPI _OSC control (0x1d)
May 15 16:09:29 192.168.42.2 ACPI: PCI Interrupt Link [LNK1] (IRQs 5 7
9 10 11 14 15) *0, disabled.
May 15 16:09:29 192.168.42.2 ACPI: PCI Interrupt Link [LNK2] (IRQs 5 7
9 10 11 14 15) *0, disabled.
May 15 16:09:29 192.168.42.2 ACPI: PCI Interrupt Link [LNK3] (IRQs 5 7
9 10 11 14 15) *0, disabled.
May 15 16:09:29 192.168.42.2 ACPI: PCI Interrupt Link [LNK4] (IRQs 5 7
9 10 11 14 15) *0, disabled.
May 15 16:09:29 192.168.42.2 ACPI: PCI Interrupt Link [LE0A] (IRQs 5 7
9 10 11 14 15) *0, disabled.
May 15 16:09:29 192.168.42.2 ACPI: PCI Interrupt Link [LE0B] (IRQs 5 7
9 10 11 14 15) *0, disabled.
May 15 16:09:29 192.168.42.2 ACPI: PCI Interrupt Link [LE0C] (IRQs 5 7
9 10 11 14 15) *0, disabled.
May 15 16:09:29 192.168.42.2 ACPI: PCI Interrupt Link [LE0D] (IRQs 5 7
9 10 11 14 15) *0, disabled.
May 15 16:09:29 192.168.42.2 ACPI: PCI Interrupt Link [LE1A] (IRQs 5 7
9 *10 11 14 15)
May 15 16:09:29 192.168.42.2 ACPI: PCI Interrupt Link [LE1B] (IRQs 5 7
9 10 11 14 15) *0, disabled.
May 15 16:09:29 192.168.42.2 ACPI: PCI Interrupt Link [LE1C] (IRQs 5 7
9 10 11 14 15) *0, disabled.
May 15 16:09:29 192.168.42.2 ACPI: PCI Interrupt Link [LE1D] (IRQs *5
7 9 10 11 14 15)
May 15 16:09:29 192.168.42.2 ACPI: PCI Interrupt Link [LE2A] (IRQs 5 7
9 10 11 14 15) *0, disabled.
May 15 16:09:29 192.168.42.2 ACPI: PCI Interrupt Link [LE2B] (IRQs 5 7
9 10 11 14 15) *0, disabled.
May 15 16:09:29 192.168.42.2 ACPI: PCI Interrupt Link [LE2C] (IRQs 5 7
9 10 11 14 15) *0, disabled.
May 15 16:09:29 192.168.42.2 ACPI: PCI Interrupt Link [LE2D] (IRQs 5 7
9 10 11 14 15) *0, disabled.
May 15 16:09:29 192.168.42.2 ACPI: PCI Interrupt Link [LE3A] (IRQs 5 7
9 10 11 14 15) *0, disabled.
May 15 16:09:29 192.168.42.2 ACPI: PCI Interrupt Link [LE3B] (IRQs 5 7
9 10 11 14 15) *0, disabled.
May 15 16:09:29 192.168.42.2 ACPI: PCI Interrupt Link [LE3C] (IRQs 5 7
9 10 11 14 15) *0, disabled.
May 15 16:09:29 192.168.42.2 ACPI: PCI Interrupt Link [LE3D] (IRQs 5 7
9 10 11 14 15) *0, disabled.
May 15 16:09:29 192.168.42.2 ACPI: PCI Interrupt Link [LE4A] (IRQs 5 7
9 10 *11 14 15)
      May 15 16:09:29 192.168.42.2 ACPI: PCI Interrupt Link [LE4B]
(IRQs 5 7 9 10 11 14 15) *0, disabled.
May 15 16:09:29 192.168.42.2 ACPI: PCI Interrupt Link [LE4C] (IRQs 5 7
9 10 11 14 15) *0, disabled.
May 15 16:09:29 192.168.42.2 ACPI: PCI Interrupt Link [LE4D] (IRQs 5 7
9 10 11 14 15) *0, disabled.
May 15 16:09:29 192.168.42.2 ACPI: PCI Interrupt Link [LE5A] (IRQs 5 7
9 10 11 14 15) *0, disabled.
May 15 16:09:29 192.168.42.2 ACPI: PCI Interrupt Link [LE5B] (IRQs 5 7
9 10 11 14 15) *0, disabled.
May 15 16:09:29 192.168.42.2 ACPI: PCI Interrupt Link [LE5C] (IRQs 5 7
9 10 11 14 15) *0, disabled.
May 15 16:09:29 192.168.42.2 ACPI: PCI Interrupt Link [LE5D] (IRQs 5 7
9 10 11 14 15) *0, disabled.
May 15 16:09:29 192.168.42.2 ACPI: PCI Interrupt Link [LE6A] (IRQs 5 7
9 10 11 14 15) *0, disabled.
May 15 16:09:29 192.168.42.2 ACPI: PCI Interrupt Link [LE6B] (IRQs 5 7
9 10 11 14 15) *0, disabled.
May 15 16:09:29 192.168.42.2 ACPI: PCI Interrupt Link [LE6C] (IRQs 5 7
9 10 11 14 15) *0, disabled.
May 15 16:09:29 192.168.42.2 ACPI: PCI Interrupt Link [LE6D] (IRQs 5 7
9 10 11 14 15) *0, disabled.
May 15 16:09:29 192.168.42.2 ACPI: PCI Interrupt Link [LE7A] (IRQs 5 7
9 10 11 14 15) *0, disabled.
May 15 16:09:29 192.168.42.2 ACPI: PCI Interrupt Link [LE7B] (IRQs 5 7
9 10 11 14 15) *0, disabled.
May 15 16:09:29 192.168.42.2 ACPI: PCI Interrupt Link [LE7C] (IRQs 5 7
9 10 11 14 15) *0, disabled.
May 15 16:09:29 192.168.42.2 ACPI: PCI Interrupt Link [LE7D] (IRQs 5 7
9 10 11 14 15) *0, disabled.
May 15 16:09:29 192.168.42.2 ACPI: PCI Interrupt Link [LP2P] (IRQs 5 7
9 10 11 14 15) *0, disabled.
May 15 16:09:29 192.168.42.2 ACPI: PCI Interrupt Link [LIGP] (IRQs 5
*7 9 10 11 14 15)
May 15 16:09:29 192.168.42.2 ACPI: PCI Interrupt Link [LUBA] (IRQs 5 7
9 10 11 14 15) *0, disabled.
May 15 16:09:29 192.168.42.2 ACPI: PCI Interrupt Link [LUB2] (IRQs 5 7
9 10 11 14 15) *0, disabled.
May 15 16:09:29 192.168.42.2 ACPI: PCI Interrupt Link [LU1B] (IRQs 5 7
9 10 11 14 15) *0, disabled.
May 15 16:09:29 192.168.42.2 ACPI: PCI Interrupt Link [LU2B] (IRQs 5 7
9 10 11 14 15) *0, disabled.
May 15 16:09:29 192.168.42.2 ACPI: PCI Interrupt Link [LMAC] (IRQs 5 7
9 10 11 14 *15)
May 15 16:09:29 192.168.42.2 ACPI: PCI Interrupt Link [LAZA] (IRQs 5 7
9 10 *11 14 15)
May 15 16:09:29 192.168.42.2 ACPI: PCI Interrupt Link [LPMU] (IRQs 5
*7 9 10 11 14 15)
May 15 16:09:29 192.168.42.2 ACPI: PCI Interrupt Link [LSMB] (IRQs 5 7
9 10 11 14 15) *0, disabled.
May 15 16:09:29 192.168.42.2 ACPI: PCI Interrupt Link [LIDE] (IRQs 5 7
9 10 11 14 15) *0, disabled.
May 15 16:09:29 192.168.42.2 ACPI: PCI Interrupt Link [LSID] (IRQs 5 7
9 *10 11 14 15)
May 15 16:09:29 192.168.42.2 ACPI: PCI Interrupt Link [APC1] (IRQs 16)
*0, disabled.
May 15 16:09:29 192.168.42.2 ACPI: PCI Interrupt Link [APC2] (IRQs 17)
*0, disabled.
May 15 16:09:29 192.168.42.2 ACPI: PCI Interrupt Link [APC3] (IRQs 18)
*0, disabled.
May 15 16:09:31 192.168.42.2 BUG: unable to handle kernel
May 15 16:09:31 192.168.42.2 paging request
May 15 16:09:31 192.168.42.2 at 0000000001000000
May 15 16:09:31 192.168.42.2 IP:
May 15 16:09:31 192.168.42.2 [<0000000001000000>] 0x1000000
May 15 16:09:31 192.168.42.2 PGD 22ed1b067
May 15 16:09:31 192.168.42.2
May 15 16:09:31 192.168.42.2 sd 9:0:0:0: [sde] 1465149168 512-byte
logical blocks: (750 GB/698 GiB)
May 15 16:09:31 192.168.42.2 sd 9:0:0:0: [sde] Write Protect is off
May 15 16:09:31 192.168.42.2 sd 9:0:0:0: [sde] Mode Sense: 2d 08 00 00
May 15 16:09:31 192.168.42.2 sd 9:0:0:0: [sde] No Caching mode page present
May 15 16:09:31 192.168.42.2 sd 9:0:0:0: [sde] Assuming drive cache:
write through
May 15 16:09:31 192.168.42.2 sd 9:0:0:0: [sde] No Caching mode page present
May 15 16:09:31 192.168.42.2 sd 9:0:0:0: [sde] Assuming drive cache:
write through
May 15 16:09:31 192.168.42.2 PUD 22ed19067
May 15 16:09:31 192.168.42.2 PMD 0
May 15 16:09:31 192.168.42.2
May 15 16:09:31 192.168.42.2 Oops: 0010 [#1]
May 15 16:09:31 192.168.42.2 PREEMPT
                   May 15 16:09:31 192.168.42.2 SMP
May 15 16:09:31 192.168.42.2
May 15 16:09:31 192.168.42.2 last sysfs file:
/sys/devices/pci0000:00/0000:00:02.1/usb1/1-3/1-3:1.0/host9/target9:0:0/9:0:0:0/scsi_device/9:0:0:0/uevent
May 15 16:09:31 192.168.42.2 sde: sde1
May 15 16:09:31 192.168.42.2 CPU 2
May 15 16:09:31 192.168.42.2
May 15 16:09:31 192.168.42.2 Modules linked in:
May 15 16:09:31 192.168.42.2 snd_hda_codec_hdmi
May 15 16:09:31 192.168.42.2 snd_hda_codec_analog
May 15 16:09:31 192.168.42.2 usbhid
May 15 16:09:31 192.168.42.2 usb_storage
May 15 16:09:31 192.168.42.2 usb_libusual
May 15 16:09:31 192.168.42.2 uas
May 15 16:09:31 192.168.42.2 snd_hda_intel
May 15 16:09:31 192.168.42.2 snd_hda_codec
May 15 16:09:31 192.168.42.2 asus_atk0110
May 15 16:09:31 192.168.42.2 ohci_hcd
May 15 16:09:31 192.168.42.2 snd_hwdep
May 15 16:09:31 192.168.42.2 snd_pcm
May 15 16:09:31 192.168.42.2 snd_timer
May 15 16:09:31 192.168.42.2 snd
May 15 16:09:31 192.168.42.2 ehci_hcd
May 15 16:09:31 192.168.42.2 soundcore
May 15 16:09:31 192.168.42.2 i2c_nforce2
May 15 16:09:31 192.168.42.2 snd_page_alloc
May 15 16:09:31 192.168.42.2 usbcore
May 15 16:09:31 192.168.42.2 k10temp
May 15 16:09:31 192.168.42.2
May 15 16:09:31 192.168.42.2
May 15 16:09:31 192.168.42.2 Pid: 13, comm: ksoftirqd/2 Not tainted 2.6.38.6 #4
May 15 16:09:31 192.168.42.2
May 15 16:09:31 192.168.42.2 System manufacturer System Product Name
May 15 16:09:31 192.168.42.2 /
May 15 16:09:31 192.168.42.2 M3N-HT DELUXE
May 15 16:09:31 192.168.42.2
May 15 16:09:31 192.168.42.2 RIP: 0010:[<0000000001000000>]
May 15 16:09:31 192.168.42.2 [<0000000001000000>] 0x1000000
May 15 16:09:31 192.168.42.2 RSP: 0018:ffff8800afd03df0  EFLAGS: 00010006
May 15 16:09:31 192.168.42.2 RAX: 0000000000000001 RBX:
ffff88022e280610 RCX: ffff88022e0bbca0
May 15 16:09:31 192.168.42.2 RDX: 0000000001000000 RSI:
0000000000000000 RDI: ffff88022e280610
May 15 16:09:31 192.168.42.2 RBP: 0000000000000200 R08:
0000000000000000 R09: ffff88022e7bfc48
May 15 16:09:31 192.168.42.2 R10: ffff88022e280610 R11:
ffff88022e09f538 R12: ffff880225aa0040
May 15 16:09:31 192.168.42.2 R13: ffff88022e280610 R14:
0000000000000000 R15: 0000000000000246
May 15 16:09:31 192.168.42.2 FS:  00007f0c2be80700(0000)
GS:ffff8800afd00000(0000) knlGS:0000000000000000
May 15 16:09:31 192.168.42.2 CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
May 15 16:09:31 192.168.42.2 CR2: 0000000001000000 CR3:
000000022dd3d000 CR4: 00000000000006e0
May 15 16:09:31 192.168.42.2 DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
May 15 16:09:31 192.168.42.2 DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7: 0000000000000400
May 15 16:09:31 192.168.42.2 Process ksoftirqd/2 (pid: 13, threadinfo
ffff88022fd02000, task ffff88022fcccfa0)
         May 15 16:09:31 192.168.42.2 Stack:
May 15 16:09:31 192.168.42.2 ffffffff812160eb
May 15 16:09:31 192.168.42.2 ffff88022e280610
May 15 16:09:31 192.168.42.2 ffff88022e280610
May 15 16:09:31 192.168.42.2 0000000000000296
May 15 16:09:31 192.168.42.2
May 15 16:09:31 192.168.42.2 ffffffff81216167
May 15 16:09:31 192.168.42.2 ffff88022e09f538
May 15 16:09:31 192.168.42.2 ffff880225aa0000
May 15 16:09:31 192.168.42.2 ffff8800afd03e58
May 15 16:09:31 192.168.42.2
May 15 16:09:31 192.168.42.2 ffffffff812b2fde
May 15 16:09:31 192.168.42.2 ffff88023f8026c0
May 15 16:09:31 192.168.42.2 ffff8800afd03e58
May 15 16:09:31 192.168.42.2
May 15 16:09:31 192.168.42.2 usb 2-5: New USB device found,
idVendor=058f, idProduct=6362
May 15 16:09:31 192.168.42.2 usb 2-5: New USB device strings: Mfr=1,
Product=2, SerialNumber=3
May 15 16:09:31 192.168.42.2 usb 2-5: Product: Mass Storage Device
May 15 16:09:31 192.168.42.2 usb 2-5: Manufacturer: Generic
May 15 16:09:31 192.168.42.2 usb 2-5: SerialNumber: 058F312D81B
May 15 16:09:31 192.168.42.2 scsi10 : usb-storage 2-5:1.0
May 15 16:09:31 192.168.42.2 ffff88022e05c000
May 15 16:09:32 192.168.42.2
May 15 16:09:32 192.168.42.2 Call Trace:
May 15 16:09:32 192.168.42.2 <IRQ>
May 15 16:09:32 192.168.42.2
May 15 16:09:32 192.168.42.2 [<ffffffff812160eb>] ? __blk_run_queue+0x24/0x7e
May 15 16:09:32 192.168.42.2 [<ffffffff81216167>] ? blk_run_queue+0x22/0x34
May 15 16:09:32 192.168.42.2 [<ffffffff812b2fde>] ? scsi_run_queue+0x2ce/0x36d
May 15 16:09:32 192.168.42.2 [<ffffffff812b39ef>] ? scsi_next_command+0x2d/0x39
May 15 16:09:32 192.168.42.2 [<ffffffff812b4289>] ?
scsi_io_completion+0x1ca/0x3fd
May 15 16:09:32 192.168.42.2 [<ffffffff813cb248>] ? _raw_spin_unlock+0x1e/0x2b
May 15 16:09:32 192.168.42.2 [<ffffffff813cb275>] ?
_raw_spin_unlock_irqrestore+0x20/0x2e
May 15 16:09:32 192.168.42.2 [<ffffffff8121a81f>] ? blk_done_softirq+0x5f/0x6c
May 15 16:09:32 192.168.42.2 [<ffffffff810326f9>] ? __do_softirq+0x7b/0x11a
May 15 16:09:32 192.168.42.2 [<ffffffff81002f4c>] ? call_softirq+0x1c/0x28
May 15 16:09:32 192.168.42.2 <EOI>
May 15 16:09:32 192.168.42.2
May 15 16:09:32 192.168.42.2 [<ffffffff81004761>] ? do_softirq+0x31/0x63
May 15 16:09:32 192.168.42.2 [<ffffffff810323c2>] ? run_ksoftirqd+0x9c/0x180
May 15 16:09:32 192.168.42.2 [<ffffffff81032326>] ? run_ksoftirqd+0x0/0x180
May 15 16:09:32 192.168.42.2 [<ffffffff81042a95>] ? kthread+0x7a/0x82
May 15 16:09:32 192.168.42.2 [<ffffffff81002e54>] ?
kernel_thread_helper+0x4/0x10
May 15 16:09:32 192.168.42.2 [<ffffffff81042a1b>] ? kthread+0x0/0x82
May 15 16:09:32 192.168.42.2 [<ffffffff81002e50>] ?
kernel_thread_helper+0x0/0x10
May 15 16:09:32 192.168.42.2 Code:
May 15 16:09:32 192.168.42.2 Bad RIP value.
May 15 16:09:32 192.168.42.2
May 15 16:09:32 192.168.42.2 RIP
                      May 15 16:09:32 192.168.42.2
[<0000000001000000>] 0x1000000
May 15 16:09:32 192.168.42.2 RSP <ffff8800afd03df0>
May 15 16:09:32 192.168.42.2 CR2: 0000000001000000
May 15 16:09:32 192.168.42.2 ---[ end trace c9755e764b778783 ]---
May 15 16:09:32 192.168.42.2 Kernel panic - not syncing: Fatal
exception in interrupt
May 15 16:09:32 192.168.42.2 Pid: 13, comm: ksoftirqd/2 Tainted: G
 D     2.6.38.6 #4
May 15 16:09:32 192.168.42.2 Call Trace:
May 15 16:09:32 192.168.42.2 <IRQ>
May 15 16:09:32 192.168.42.2 [<ffffffff813c949a>] ? panic+0xa1/0x199
May 15 16:09:32 192.168.42.2 [<ffffffff8102e12c>] ? kmsg_dump+0xde/0xed
May 15 16:09:32 192.168.42.2 [<ffffffff8100586a>] ? oops_end+0x7e/0x8b
May 15 16:09:32 192.168.42.2 [<ffffffff8101b236>] ? no_context+0x1f4/0x201
May 15 16:09:32 192.168.42.2 [<ffffffff8101b718>] ? do_page_fault+0x150/0x2e8
May 15 16:09:32 192.168.42.2 [<ffffffff81022def>] ? check_preempt_curr+0x36/0x68
May 15 16:09:32 192.168.42.2 [<ffffffff810294e1>] ?
ttwu_post_activation+0x18/0xa5
May 15 16:09:32 192.168.42.2 [<ffffffff813cb275>] ?
_raw_spin_unlock_irqrestore+0x20/0x2e
May 15 16:09:32 192.168.42.2 [<ffffffff8102b101>] ? try_to_wake_up+0x197/0x1b2
May 15 16:09:32 192.168.42.2 [<ffffffff813cb9cf>] ? page_fault+0x1f/0x30
May 15 16:09:32 192.168.42.2 [<ffffffff812160eb>] ? __blk_run_queue+0x24/0x7e
May 15 16:09:32 192.168.42.2 [<ffffffff81216167>] ? blk_run_queue+0x22/0x34
May 15 16:09:32 192.168.42.2 [<ffffffff812b2fde>] ? scsi_run_queue+0x2ce/0x36d
May 15 16:09:32 192.168.42.2 [<ffffffff812b39ef>] ? scsi_next_command+0x2d/0x39
May 15 16:09:32 192.168.42.2 [<ffffffff812b4289>] ?
scsi_io_completion+0x1ca/0x3fd
May 15 16:09:32 192.168.42.2 [<ffffffff813cb248>] ? _raw_spin_unlock+0x1e/0x2b
May 15 16:09:32 192.168.42.2 [<ffffffff813cb275>] ?
_raw_spin_unlock_irqrestore+0x20/0x2e
May 15 16:09:32 192.168.42.2 [<ffffffff8121a81f>] ? blk_done_softirq+0x5f/0x6c
May 15 16:09:32 192.168.42.2 [<ffffffff810326f9>] ? __do_softirq+0x7b/0x11a
May 15 16:09:32 192.168.42.2 [<ffffffff81002f4c>] ? call_softirq+0x1c/0x28
May 15 16:09:32 192.168.42.2 <EOI>
May 15 16:09:32 192.168.42.2 [<ffffffff81004761>] ? do_softirq+0x31/0x63
May 15 16:09:32 192.168.42.2 [<ffffffff810323c2>] ? run_ksoftirqd+0x9c/0x180
May 15 16:09:32 192.168.42.2 [<ffffffff81032326>] ? run_ksoftirqd+0x0/0x180
May 15 16:09:32 192.168.42.2 [<ffffffff81042a95>] ? kthread+0x7a/0x82
May 15 16:09:32 192.168.42.2 [<ffffffff81002e54>] ?
kernel_thread_helper+0x4/0x10
May 15 16:09:32 192.168.42.2 [<ffffffff81042a1b>] ? kthread+0x0/0x82
May 15 16:09:32 192.168.42.2 [<ffffffff81002e50>] ?
kernel_thread_helper+0x0/0x10

-- 
Fabio

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752336Ab0FCMfg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 08:35:36 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:34045 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839Ab0FCMfd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 08:35:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=EtqWjqSj8pvWkDIZmWLBMyuaw771L7/fxLyWi8zyAbLQ4V6Rvx4I4LVU06fsE0gK3i
         Q3hBYwdMSPjBkQuD99DoTRuzTe4XqSAHEhE6mXF/1aL/8loR1MU2FsFADtPYHQEeHR90
         92lYj+O77DJkEsf6GU/9eUU+Bm+crq/lnDoXY=
MIME-Version: 1.0
In-Reply-To: <20100603093923.GA25856@oksana.dev.rtsoft.ru>
References: <AANLkTikWak8i-Kaj-e-EUFWE66tfMmp2UPhGJCKkK1zK@mail.gmail.com>
	<20100603075402.GA11093@oksana.dev.rtsoft.ru>
	<AANLkTil6k_4YwdvLai_VUlVjgz030ctu7djVGHu0qgd2@mail.gmail.com>
	<20100603084104.GA17431@oksana.dev.rtsoft.ru>
	<AANLkTilSNOgD1HrvYBMEsza5-IIeBS1U7AHChO1vJKuf@mail.gmail.com>
	<AANLkTima_jbwafiHQsncQzdX04ZcjO_8QIpq5UOohi3x@mail.gmail.com>
	<20100603093923.GA25856@oksana.dev.rtsoft.ru>
Date: Thu, 3 Jun 2010 20:35:31 +0800
Message-ID: <AANLkTim8TALR8Ev9KDX4tteXUrQ3oKOcnyMHk9WOdUvG@mail.gmail.com>
Subject: Re: 2.6.25-rc1 ahci regression
From: Luming Yu <luming.yu@gmail.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 3, 2010 at 5:39 PM, Anton Vorontsov <cbouatmailru@gmail.com> wrote:
> On Thu, Jun 03, 2010 at 05:18:40PM +0800, Luming Yu wrote:
> [...]
>> Linux version 2.6.32-25.el6.x86_64
>
> Hm. Can you really boot the kernels that has
> 365cfa1ed5 applied and reverted?
>
> That is, do
>
> $ git reset --hard 365cfa1ed5
> $ make
> $ ...boot...
Linux version 2.6.34-rc7 (root@localhost) (gcc version 4.4.4 20100503
(Red Hat 4.4.4-2) (GCC) ) #24 SMP Thu Jun 3 08:07:58 EDT 2010
Command line: ro root=/dev/mapper/vg_intels3ea209-lv_root
rd_LVM_LV=vg_intels3ea209/lv_root rd_LVM_LV=vg_intels3ea209/lv_swap
rd_NO_LUKS rd_NO_MD rd_NO_DM LANG=en_US.UTF-8
SYSFONT=latarcyrheb-sun16 KEYBOARDTYPE=pc KEYTABLE=us
console=ttyS0,115200n81 console=tty0 console=ttyS0,115200n81
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009d800 (usable)
 BIOS-e820: 000000000009d800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000bf340000 (usable)
 BIOS-e820: 00000000bf340000 - 00000000bf3c1000 (ACPI NVS)
 BIOS-e820: 00000000bf3c1000 - 00000000bf3c2000 (ACPI data)
 BIOS-e820: 00000000bf3c2000 - 00000000bf3d5000 (reserved)
 BIOS-e820: 00000000bf3d5000 - 00000000bf3d6000 (ACPI NVS)
 BIOS-e820: 00000000bf3d6000 - 00000000bf3e7000 (reserved)
 BIOS-e820: 00000000bf3e7000 - 00000000bf3ea000 (ACPI NVS)
 BIOS-e820: 00000000bf3ea000 - 00000000bf44f000 (reserved)
 BIOS-e820: 00000000bf44f000 - 00000000bf45a000 (ACPI data)
 BIOS-e820: 00000000bf45a000 - 00000000bf465000 (ACPI NVS)
 BIOS-e820: 00000000bf465000 - 00000000bf483000 (reserved)
 BIOS-e820: 00000000bf483000 - 00000000bf686000 (ACPI NVS)
 BIOS-e820: 00000000bf686000 - 00000000bf800000 (usable)
 BIOS-e820: 00000000c0000000 - 00000000d0000000 (reserved)
 BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
 BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 00000004c0000000 (usable)
NX (Execute Disable) protection: active
DMI 2.4 present.
AMI BIOS detected: BIOS may corrupt low RAM, working around it.
No AGP bridge found
last_pfn = 0x4c0000 max_arch_pfn = 0x400000000
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
total RAM covered: 18432M
Found optimal setting for mtrr clean up
 gran_size: 64K 	chunk_size: 64K 	num_reg: 6  	lose cover RAM: 0G
last_pfn = 0xbf800 max_arch_pfn = 0x400000000
found SMP MP-table at [ffff8800000fdf30] fdf30
init_memory_mapping: 0000000000000000-00000000bf800000
init_memory_mapping: 0000000100000000-00000004c0000000
RAMDISK: 36ce8000 - 37ff0000
ACPI: RSDP 00000000000f03f0 00024 (v02 ALASKA)
ACPI: XSDT 00000000bf458e18 00084 (v01 ALASKA    A M I 06222004 MSFT 00010013)
ACPI: FACP 00000000bf457d98 000F4 (v04 ALASKA    A M I 06222004 MSFT 00010013)
ACPI Warning: 32/64 FACS address mismatch in FADT - two FACS tables!
(20100121/tbfadt-369)
ACPI Warning: 32/64X FACS address mismatch in FADT -
BF461F40/00000000BF462E40, using 32 (20100121/tbfadt-486)
ACPI: DSDT 00000000bf450018 06E8F (v01 ALASKA    A M I 00000001 INTL 20051117)
ACPI: FACS 00000000bf461f40 00040
ACPI: APIC 00000000bf457c18 000E4 (v02 ALASKA    A M I 06222004 MSFT 00010013)
ACPI: MCFG 00000000bf459f18 0003C (v01 A M I  OEMMCFG  06222004 MSFT 00000097)
ACPI: SRAT 00000000bf44fc18 003B0 (v01 A M I  AMI SRAT 00000000 AMI. 00000000)
ACPI: SLIT 00000000bf459e98 00030 (v01 A M I  AMI SLIT 00000000 AMI. 00000000)
ACPI: HPET 00000000bf459e18 00038 (v01 A M I  ICH7HPET 06222004 AMI. 00000003)
ACPI: SPMI 00000000bf459d98 00040 (v05 A M I   OEMSPMI 00000000 AMI. 00000000)
ACPI: EINJ 00000000bf457a98 00130 (v01    AMI AMI EINJ 00000000      00000000)
ACPI: ERST 00000000bf3c1c98 00210 (v01  AMIER AMI ERST 00000000      00000000)
ACPI: HEST 00000000bf3c1f18 000A8 (v01    AMI AMI HEST 00000000      00000000)
ACPI: BERT 00000000bf459d18 00030 (v01    AMI AMI BERT 00000000      00000000)
ACPI: DMAR 00000000bf458d18 000C0 (v01 A M I   OEMDMAR 00000001 INTL 00000001)
SRAT: PXM 0 -> APIC 0x00 -> Node 0
SRAT: PXM 0 -> APIC 0x02 -> Node 0
SRAT: PXM 0 -> APIC 0x04 -> Node 0
SRAT: PXM 0 -> APIC 0x06 -> Node 0
SRAT: PXM 1 -> APIC 0x10 -> Node 1
SRAT: PXM 1 -> APIC 0x12 -> Node 1
SRAT: PXM 1 -> APIC 0x14 -> Node 1
SRAT: PXM 1 -> APIC 0x16 -> Node 1
SRAT: Node 0 PXM 0 0-c0000000
SRAT: Node 0 PXM 0 100000000-280000000
SRAT: Node 1 PXM 1 280000000-4c0000000
Initmem setup node 0 0000000000000000-0000000280000000
  NODE_DATA [0000000100000000 - 0000000100026fff]
Initmem setup node 1 0000000280000000-00000004c0000000
  NODE_DATA [0000000280000000 - 0000000280026fff]
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x004c0000
Movable zone start PFN for each node
early_node_map[5] active PFN ranges
    0: 0x00000010 -> 0x0000009d
    0: 0x00000100 -> 0x000bf340
    0: 0x000bf686 -> 0x000bf800
    0: 0x00100000 -> 0x00280000
    1: 0x00280000 -> 0x004c0000
ACPI: PM-Timer IO Port: 0x408
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x10] enabled)
ACPI: LAPIC (acpi_id[0x06] lapic_id[0x12] enabled)
ACPI: LAPIC (acpi_id[0x07] lapic_id[0x14] enabled)
ACPI: LAPIC (acpi_id[0x08] lapic_id[0x16] enabled)
ACPI: LAPIC (acpi_id[0x09] lapic_id[0x08] disabled)
ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x09] disabled)
ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x0a] disabled)
ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x0b] disabled)
ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x0c] disabled)
ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x0d] disabled)
ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x0e] disabled)
ACPI: LAPIC (acpi_id[0x10] lapic_id[0x0f] disabled)
ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 0, version 32, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x02] address[0xfec01000] gsi_base[24])
IOAPIC[1]: apic_id 2, version 32, address 0xfec01000, GSI 24-47
ACPI: IOAPIC (id[0x03] address[0xfec02000] gsi_base[48])
IOAPIC[2]: apic_id 3, version 32, address 0xfec02000, GSI 48-71
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a301 base: 0xfed00000
SMP: Allowing 16 CPUs, 8 hotplug CPUs
PM: Registered nosave memory: 000000000009d000 - 000000000009e000
PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
PM: Registered nosave memory: 00000000bf340000 - 00000000bf3c1000
PM: Registered nosave memory: 00000000bf3c1000 - 00000000bf3c2000
PM: Registered nosave memory: 00000000bf3c2000 - 00000000bf3d5000
PM: Registered nosave memory: 00000000bf3d5000 - 00000000bf3d6000
PM: Registered nosave memory: 00000000bf3d6000 - 00000000bf3e7000
PM: Registered nosave memory: 00000000bf3e7000 - 00000000bf3ea000
PM: Registered nosave memory: 00000000bf3ea000 - 00000000bf44f000
PM: Registered nosave memory: 00000000bf44f000 - 00000000bf45a000
PM: Registered nosave memory: 00000000bf45a000 - 00000000bf465000
PM: Registered nosave memory: 00000000bf465000 - 00000000bf483000
PM: Registered nosave memory: 00000000bf483000 - 00000000bf686000
PM: Registered nosave memory: 00000000bf800000 - 00000000c0000000
PM: Registered nosave memory: 00000000c0000000 - 00000000d0000000
PM: Registered nosave memory: 00000000d0000000 - 00000000fed1c000
PM: Registered nosave memory: 00000000fed1c000 - 00000000fed20000
PM: Registered nosave memory: 00000000fed20000 - 00000000ff000000
PM: Registered nosave memory: 00000000ff000000 - 0000000100000000
Allocating PCI resources starting at d0000000 (gap: d0000000:2ed1c000)
Booting paravirtualized kernel on bare hardware
setup_percpu: NR_CPUS:4096 nr_cpumask_bits:16 nr_cpu_ids:16 nr_node_ids:2
PERCPU: Embedded 31 pages/cpu @ffff880002400000 s94696 r8192 d24088 u262144
pcpu-alloc: s94696 r8192 d24088 u262144 alloc=1*2097152
pcpu-alloc: [0] 00 01 02 03 08 10 12 14 [1] 04 05 06 07 09 11 13 15
Built 2 zonelists in Zone order, mobility grouping on.  Total pages: 4647495
Policy zone: Normal
Kernel command line: ro root=/dev/mapper/vg_intels3ea209-lv_root
rd_LVM_LV=vg_intels3ea209/lv_root rd_LVM_LV=vg_intels3ea209/lv_swap
rd_NO_LUKS rd_NO_MD rd_NO_DM LANG=en_US.UTF-8
SYSFONT=latarcyrheb-sun16 KEYBOARDTYPE=pc KEYTABLE=us
console=ttyS0,115200n81 console=tty0 console=ttyS0,115200n81
PID hash table entries: 4096 (order: 3, 32768 bytes)
Checking aperture...
No AGP bridge found
Subtract (91 early reservations)
  #1 [0001000000 - 0002262998]   TEXT DATA BSS
  #2 [0036ce8000 - 0037ff0000]         RAMDISK
  #3 [0002263000 - 000226321c]             BRK
  #4 [00000fdf40 - 0000100000]   BIOS reserved
  #5 [00000fdf30 - 00000fdf40]    MP-table mpf
  #6 [000009d800 - 00000fda20]   BIOS reserved
  #7 [00000fde9c - 00000fdf30]   BIOS reserved
  #8 [00000fda20 - 00000fde9c]    MP-table mpc
  #9 [0000010000 - 0000012000]      TRAMPOLINE
  #10 [0000012000 - 0000016000]     ACPI WAKEUP
  #11 [0000016000 - 0000018000]         PGTABLE
  #12 [0000018000 - 0000027000]         PGTABLE
  #13 [0000027000 - 0000027030]       ACPI SLIT
  #14 [0100000000 - 0100027000]       NODE_DATA
  #15 [0280000000 - 0280027000]       NODE_DATA
  #16 [0002263240 - 0002264240]         BOOTMEM
  #17 [0280027000 - 0280028000]         BOOTMEM
  #18 [0002664240 - 0002664900]         BOOTMEM
  #19 [0280028000 - 02800286c0]         BOOTMEM
  #20 [0100027000 - 0100028000]         BOOTMEM
  #21 [0100028000 - 0100029000]         BOOTMEM
  #22 [0100200000 - 0108000000]        MEMMAP 0
  #23 [0280200000 - 0288000000]        MEMMAP 1
  #24 [0002264240 - 000227c240]         BOOTMEM
  #25 [000227c240 - 0002294240]         BOOTMEM
  #26 [0002294240 - 00022ac240]         BOOTMEM
  #27 [02800286c0 - 02800406c0]         BOOTMEM
  #28 [00022ad000 - 00022ae000]         BOOTMEM
  #29 [00022629c0 - 0002262a01]         BOOTMEM
  #30 [0002262a40 - 0002262b09]         BOOTMEM
  #31 [0002262b40 - 0002262fd8]         BOOTMEM
  #32 [00022ac240 - 00022ac2a8]         BOOTMEM
  #33 [00022ac2c0 - 00022ac328]         BOOTMEM
  #34 [00022ac340 - 00022ac3a8]         BOOTMEM
  #35 [00022ac3c0 - 00022ac428]         BOOTMEM
  #36 [00022ac440 - 00022ac4a8]         BOOTMEM
  #37 [00022ac4c0 - 00022ac528]         BOOTMEM
  #38 [00022ac540 - 00022ac5a8]         BOOTMEM
  #39 [00022ac5c0 - 00022ac628]         BOOTMEM
  #40 [00022ac640 - 00022ac6a8]         BOOTMEM
  #41 [00022ac6c0 - 00022ac728]         BOOTMEM
  #42 [00022ac740 - 00022ac7a8]         BOOTMEM
  #43 [00022ac7c0 - 00022ac828]         BOOTMEM
  #44 [00022ac840 - 00022ac8a8]         BOOTMEM
  #45 [00022ac8c0 - 00022ac928]         BOOTMEM
  #46 [00022ac940 - 00022ac9a8]         BOOTMEM
  #47 [00022ac9c0 - 00022aca28]         BOOTMEM
  #48 [00022aca40 - 00022acaa8]         BOOTMEM
  #49 [00022acac0 - 00022acb28]         BOOTMEM
  #50 [00022acb40 - 00022acba8]         BOOTMEM
  #51 [00022acbc0 - 00022acc28]         BOOTMEM
  #52 [00022acc40 - 00022acc60]         BOOTMEM
  #53 [00022acc80 - 00022acca0]         BOOTMEM
  #54 [00022accc0 - 00022acce0]         BOOTMEM
  #55 [00022acd00 - 00022ace11]         BOOTMEM
  #56 [00022ace40 - 00022acf51]         BOOTMEM
  #57 [0002400000 - 000241f000]         BOOTMEM
  #58 [0002440000 - 000245f000]         BOOTMEM
  #59 [0002480000 - 000249f000]         BOOTMEM
  #60 [00024c0000 - 00024df000]         BOOTMEM
  #61 [0002500000 - 000251f000]         BOOTMEM
  #62 [0002540000 - 000255f000]         BOOTMEM
  #63 [0002580000 - 000259f000]         BOOTMEM
  #64 [00025c0000 - 00025df000]         BOOTMEM
  #65 [0288000000 - 028801f000]         BOOTMEM
  #66 [0288040000 - 028805f000]         BOOTMEM
  #67 [0288080000 - 028809f000]         BOOTMEM
  #68 [02880c0000 - 02880df000]         BOOTMEM
  #69 [0288100000 - 028811f000]         BOOTMEM
  #70 [0288140000 - 028815f000]         BOOTMEM
  #71 [0288180000 - 028819f000]         BOOTMEM
  #72 [02881c0000 - 02881df000]         BOOTMEM
  #73 [00022acf80 - 00022acf90]         BOOTMEM
  #74 [00022acfc0 - 00022acfd0]         BOOTMEM
  #75 [00022b0000 - 00022b0040]         BOOTMEM
  #76 [00022b0040 - 00022b00c0]         BOOTMEM
  #77 [00022b00c0 - 00022b01e0]         BOOTMEM
  #78 [00022b0200 - 00022b0248]         BOOTMEM
  #79 [00022b0280 - 00022b02c8]         BOOTMEM
  #80 [00022ae000 - 00022ae200]         BOOTMEM
  #81 [00022ae200 - 00022ae400]         BOOTMEM
  #82 [00022ae400 - 00022ae600]         BOOTMEM
  #83 [00022ae600 - 00022ae800]         BOOTMEM
  #84 [00022ae800 - 00022aea00]         BOOTMEM
  #85 [00022aea00 - 00022aec00]         BOOTMEM
  #86 [00022b0300 - 00022b8300]         BOOTMEM
  #87 [0002665000 - 0006665000]         BOOTMEM
  #88 [00022b8300 - 00022d8300]         BOOTMEM
  #89 [00022d8300 - 0002318300]         BOOTMEM
  #90 [0000028840 - 0000030840]         BOOTMEM
Memory: 18497196k/19922944k available (4769k kernel code, 1060580k
absent, 365168k reserved, 7764k data, 1428k init)
Hierarchical RCU implementation.
NR_IRQS:262400 nr_irqs:1352
Extended CMOS year: 2000
Console: colour VGA+ 80x25
console [tty0] enabled
console [ttyS0] enabled
allocated 188743680 bytes of page_cgroup
please try 'cgroup_disable=memory' option if you don't want memory cgroups
Fast TSC calibration using PIT
Detected 2800.048 MHz processor.
Calibrating delay loop (skipped), value calculated using timer
frequency.. 5600.09 BogoMIPS (lpj=2800048)
Security Framework initialized
SELinux:  Initializing.
Dentry cache hash table entries: 4194304 (order: 13, 33554432 bytes)
Inode-cache hash table entries: 2097152 (order: 12, 16777216 bytes)
Mount-cache hash table entries: 256
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
Initializing cgroup subsys memory
Initializing cgroup subsys devices
Initializing cgroup subsys freezer
Initializing cgroup subsys net_cls
Initializing cgroup subsys blkio
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 9 MCE banks
CPU0: Thermal monitoring enabled (TM1)
using mwait in idle threads.
Performance Events: Nehalem/Corei7 events, Intel PMU driver.
... version:                3
... bit width:              48
... generic registers:      4
... value mask:             0000ffffffffffff
... max period:             000000007fffffff
... fixed-purpose events:   3
... event mask:             000000070000000f
ACPI: Core revision 20100121
ftrace: converting mcount calls to 0f 1f 44 00 00
ftrace: allocating 18173 entries in 72 pages
DMAR: Host address width 40
DMAR: DRHD base: 0x000000fe710000 flags: 0x1
IOMMU fe710000: ver 1:0 cap c90780106f0462 ecap f0207e
DMAR: RMRR base: 0x000000bf3ea000 end: 0x000000bf3fdfff
DMAR: ATSR flags: 0x0
IOAPIC id 0 under DRHD base 0xfe710000
Not all IO-APIC's listed under remapping hardware
Not enable interrupt remapping
Setting APIC routing to physical flat
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Xeon(R) CPU           X5560  @ 2.80GHz stepping 05
Booting Node   0, Processors  #1 #2 #3 Ok.
Booting Node   1, Processors  #4 #5 #6 #7
Brought up 8 CPUs
Total of 8 processors activated (44794.25 BogoMIPS).
devtmpfs: initialized
regulator: core version 0.5
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem
0xc0000000-0xcfffffff] (base 0xc0000000)
PCI: MMCONFIG at [mem 0xc0000000-0xcfffffff] reserved in E820
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: Executed 1 blocks of module-level executable AML code
ACPI: BIOS _OSI(Linux) query ignored
ACPI: SSDT 00000000bf45b018 01054 (v01    AMI      IST 00000001 MSFT 03000001)
ACPI: Interpreter enabled
ACPI: (supports S0 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: No dock devices found.
PCI: Using host bridge windows from ACPI; if necessary, use
"pci=nocrs" and report a bug
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
pci_root PNP0A08:00: host bridge window [mem 0xc0000000-0xffffffff]
pci 0000:00:1f.0: quirk: [io  0x0400-0x047f] claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: [io  0x0500-0x053f] claimed by ICH6 GPIO
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0600 (mask 00ff)
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 0ca0 (mask 000f)
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 0290 (mask 001f)
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 4 PIO at 0ca0 (mask 000f)
pci 0000:00:01.0: PCI bridge to [bus 01-02]
pci 0000:00:02.0: PCI bridge to [bus 03-03]
pci 0000:00:03.0: PCI bridge to [bus 04-04]
pci 0000:00:04.0: PCI bridge to [bus 05-05]
pci 0000:00:05.0: PCI bridge to [bus 06-06]
pci 0000:00:06.0: PCI bridge to [bus 07-07]
pci 0000:00:07.0: PCI bridge to [bus 08-08]
pci 0000:00:08.0: PCI bridge to [bus 09-09]
pci 0000:0a:00.0: PXH quirk detected; SHPC device MSI disabled
pci 0000:0a:00.2: PXH quirk detected; SHPC device MSI disabled
pci 0000:0a:00.0: disabling ASPM on pre-1.1 PCIe device.  You can
enable it with 'pcie_aspm=force'
pci 0000:00:09.0: PCI bridge to [bus 0a-0c]
pci 0000:0a:00.0: PCI bridge to [bus 0b-0b]
pci 0000:0a:00.2: PCI bridge to [bus 0c-0c]
pci 0000:00:0a.0: PCI bridge to [bus 0d-0d]
pci 0000:00:1c.0: PCI bridge to [bus 0e-0e]
pci 0000:0f:00.0: disabling ASPM on pre-1.1 PCIe device.  You can
enable it with 'pcie_aspm=force'
pci 0000:00:1c.4: PCI bridge to [bus 0f-0f]
pci 0000:00:1e.0: PCI bridge to [bus 10-10] (subtractive decode)
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 10 11 12 14 15) *0
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12 14 15) *0
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 10 11 12 14 15) *0
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 *10 11 12 14 15)
vgaarb: device added: PCI:0000:10:01.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
pci 0000:00:16.0: no compatible bridge window for [mem
0xfffff1c000-0xfffff1ffff 64bit]
pci 0000:00:16.1: no compatible bridge window for [mem
0xfffff18000-0xfffff1bfff 64bit]
pci 0000:00:16.2: no compatible bridge window for [mem
0xfffff14000-0xfffff17fff 64bit]
pci 0000:00:16.3: no compatible bridge window for [mem
0xfffff10000-0xfffff13fff 64bit]
pci 0000:00:16.4: no compatible bridge window for [mem
0xfffff0c000-0xfffff0ffff 64bit]
pci 0000:00:16.5: no compatible bridge window for [mem
0xfffff08000-0xfffff0bfff 64bit]
pci 0000:00:16.6: no compatible bridge window for [mem
0xfffff04000-0xfffff07fff 64bit]
pci 0000:00:16.7: no compatible bridge window for [mem
0xfffff00000-0xfffff03fff 64bit]
pci 0000:00:1f.3: no compatible bridge window for [mem
0xfffff20000-0xfffff200ff 64bit]
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
HPET: 4 timers in total, 0 timers will be used for per-cpu timer
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
hpet0: 4 comparators, 64-bit 14.318180 MHz counter
Switching to clocksource tsc
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 15 devices
ACPI: ACPI bus type pnp unregistered
system 00:01: [mem 0xfc000000-0xfcffffff] has been reserved
system 00:01: [mem 0xfd000000-0xfdffffff] has been reserved
system 00:01: [mem 0xfe000000-0xfe9fffff] has been reserved
system 00:01: [mem 0xfea00000-0xfea0001f] has been reserved
system 00:01: [mem 0xfeb00000-0xfebfffff] has been reserved
system 00:01: [mem 0xfed00400-0xfed3ffff] could not be reserved
system 00:01: [mem 0xfed45000-0xfedfffff] has been reserved
system 00:02: [io  0x0290-0x029f] has been reserved
system 00:0a: [io  0x04d0-0x04d1] has been reserved
system 00:0d: [io  0x0400-0x047f] has been reserved
system 00:0d: [io  0x1180-0x119f] has been reserved
system 00:0d: [io  0x0500-0x057f] could not be reserved
system 00:0d: [mem 0xfed1c000-0xfed1ffff] has been reserved
system 00:0d: [mem 0xfec00000-0xfecfffff] could not be reserved
system 00:0d: [mem 0xff000000-0xffffffff] has been reserved
pci 0000:00:1c.0: BAR 14: assigned [mem 0xd0000000-0xd01fffff]
pci 0000:00:1c.0: BAR 15: assigned [mem 0xd0200000-0xd03fffff 64bit pref]
pci 0000:00:1c.4: BAR 15: assigned [mem 0xd0400000-0xd05fffff 64bit pref]
pci 0000:00:16.0: BAR 0: assigned [mem 0xd0600000-0xd0603fff 64bit]
pci 0000:00:16.0: BAR 0: set to [mem 0xd0600000-0xd0603fff 64bit] (PCI
address [0xd0600000-0xd0603fff]
pci 0000:00:16.1: BAR 0: assigned [mem 0xd0604000-0xd0607fff 64bit]
pci 0000:00:16.1: BAR 0: set to [mem 0xd0604000-0xd0607fff 64bit] (PCI
address [0xd0604000-0xd0607fff]
pci 0000:00:16.2: BAR 0: assigned [mem 0xd0608000-0xd060bfff 64bit]
pci 0000:00:16.2: BAR 0: set to [mem 0xd0608000-0xd060bfff 64bit] (PCI
address [0xd0608000-0xd060bfff]
pci 0000:00:16.3: BAR 0: assigned [mem 0xd060c000-0xd060ffff 64bit]
pci 0000:00:16.3: BAR 0: set to [mem 0xd060c000-0xd060ffff 64bit] (PCI
address [0xd060c000-0xd060ffff]
pci 0000:00:16.4: BAR 0: assigned [mem 0xd0610000-0xd0613fff 64bit]
pci 0000:00:16.4: BAR 0: set to [mem 0xd0610000-0xd0613fff 64bit] (PCI
address [0xd0610000-0xd0613fff]
pci 0000:00:16.5: BAR 0: assigned [mem 0xd0614000-0xd0617fff 64bit]
pci 0000:00:16.5: BAR 0: set to [mem 0xd0614000-0xd0617fff 64bit] (PCI
address [0xd0614000-0xd0617fff]
pci 0000:00:16.6: BAR 0: assigned [mem 0xd0618000-0xd061bfff 64bit]
pci 0000:00:16.6: BAR 0: set to [mem 0xd0618000-0xd061bfff 64bit] (PCI
address [0xd0618000-0xd061bfff]
pci 0000:00:16.7: BAR 0: assigned [mem 0xd061c000-0xd061ffff 64bit]
pci 0000:00:16.7: BAR 0: set to [mem 0xd061c000-0xd061ffff 64bit] (PCI
address [0xd061c000-0xd061ffff]
pci 0000:00:1c.0: BAR 13: assigned [io  0x2000-0x2fff]
pci 0000:00:1f.3: BAR 0: assigned [mem 0xd0620000-0xd06200ff 64bit]
pci 0000:00:1f.3: BAR 0: set to [mem 0xd0620000-0xd06200ff 64bit] (PCI
address [0xd0620000-0xd06200ff]
pci 0000:00:01.0: PCI bridge to [bus 01-02]
pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
pci 0000:00:01.0:   bridge window [mem 0xfbb00000-0xfbcfffff]
pci 0000:00:01.0:   bridge window [mem pref disabled]
pci 0000:00:02.0: PCI bridge to [bus 03-03]
pci 0000:00:02.0:   bridge window [io  disabled]
pci 0000:00:02.0:   bridge window [mem disabled]
pci 0000:00:02.0:   bridge window [mem pref disabled]
pci 0000:00:03.0: PCI bridge to [bus 04-04]
pci 0000:00:03.0:   bridge window [io  disabled]
pci 0000:00:03.0:   bridge window [mem disabled]
pci 0000:00:03.0:   bridge window [mem pref disabled]
pci 0000:00:04.0: PCI bridge to [bus 05-05]
pci 0000:00:04.0:   bridge window [io  disabled]
pci 0000:00:04.0:   bridge window [mem disabled]
pci 0000:00:04.0:   bridge window [mem pref disabled]
pci 0000:00:05.0: PCI bridge to [bus 06-06]
pci 0000:00:05.0:   bridge window [io  disabled]
pci 0000:00:05.0:   bridge window [mem disabled]
pci 0000:00:05.0:   bridge window [mem pref disabled]
pci 0000:00:06.0: PCI bridge to [bus 07-07]
pci 0000:00:06.0:   bridge window [io  disabled]
pci 0000:00:06.0:   bridge window [mem disabled]
pci 0000:00:06.0:   bridge window [mem pref disabled]
pci 0000:00:07.0: PCI bridge to [bus 08-08]
pci 0000:00:07.0:   bridge window [io  disabled]
pci 0000:00:07.0:   bridge window [mem disabled]
pci 0000:00:07.0:   bridge window [mem pref disabled]
pci 0000:00:08.0: PCI bridge to [bus 09-09]
pci 0000:00:08.0:   bridge window [io  disabled]
pci 0000:00:08.0:   bridge window [mem disabled]
pci 0000:00:08.0:   bridge window [mem pref disabled]
pci 0000:0a:00.0: PCI bridge to [bus 0b-0b]
pci 0000:0a:00.0:   bridge window [io  disabled]
pci 0000:0a:00.0:   bridge window [mem disabled]
pci 0000:0a:00.0:   bridge window [mem pref disabled]
pci 0000:0a:00.2: PCI bridge to [bus 0c-0c]
pci 0000:0a:00.2:   bridge window [io  disabled]
pci 0000:0a:00.2:   bridge window [mem disabled]
pci 0000:0a:00.2:   bridge window [mem pref disabled]
pci 0000:00:09.0: PCI bridge to [bus 0a-0c]
pci 0000:00:09.0:   bridge window [io  disabled]
pci 0000:00:09.0:   bridge window [mem disabled]
pci 0000:00:09.0:   bridge window [mem pref disabled]
pci 0000:00:0a.0: PCI bridge to [bus 0d-0d]
pci 0000:00:0a.0:   bridge window [io  disabled]
pci 0000:00:0a.0:   bridge window [mem disabled]
pci 0000:00:0a.0:   bridge window [mem pref disabled]
pci 0000:00:1c.0: PCI bridge to [bus 0e-0e]
pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
pci 0000:00:1c.0:   bridge window [mem 0xd0000000-0xd01fffff]
pci 0000:00:1c.0:   bridge window [mem 0xd0200000-0xd03fffff 64bit pref]
pci 0000:00:1c.4: PCI bridge to [bus 0f-0f]
pci 0000:00:1c.4:   bridge window [io  0xd000-0xdfff]
pci 0000:00:1c.4:   bridge window [mem 0xfbe00000-0xfbefffff]
pci 0000:00:1c.4:   bridge window [mem 0xd0400000-0xd05fffff 64bit pref]
pci 0000:00:1e.0: PCI bridge to [bus 10-10]
pci 0000:00:1e.0:   bridge window [io  0xc000-0xcfff]
pci 0000:00:1e.0:   bridge window [mem 0xfbd00000-0xfbdfffff]
pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xf7ffffff 64bit pref]
pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:03.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:04.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:05.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:06.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:07.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:08.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:09.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:0a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:1c.0: enabling device (0000 -> 0003)
pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
NET: Registered protocol family 2
IP route cache hash table entries: 524288 (order: 10, 4194304 bytes)
TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 524288 bind 65536)
TCP reno registered
UDP hash table entries: 16384 (order: 7, 524288 bytes)
UDP-Lite hash table entries: 16384 (order: 7, 524288 bytes)
NET: Registered protocol family 1
pci 0000:00:1a.7: EHCI: BIOS handoff failed (BIOS bug?) 01010001
pci 0000:00:1d.7: EHCI: BIOS handoff failed (BIOS bug?) 01010001
pci 0000:0a:00.0: rerouting interrupts for [8086:0329]
pci 0000:0a:00.2: rerouting interrupts for [8086:032a]
Trying to unpack rootfs image as initramfs...
Freeing initrd memory: 19488k freed
PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Placing 64MB software IO TLB between ffff880002665000 - ffff880006665000
software IO TLB at phys 0x2665000 - 0x6665000
audit: initializing netlink socket (disabled)
type=2000 audit(1275552840.694:1): initialized
HugeTLB registered 2 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
msgmni has been set to 32768
alg: No test for stdrng (krng)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
pcieport 0000:00:01.0: Requesting control of PCIe PME from ACPI BIOS
pcieport 0000:00:01.0: Signaling PME through PCIe PME interrupt
pci 0000:01:00.0: Signaling PME through PCIe PME interrupt
pci 0000:01:00.1: Signaling PME through PCIe PME interrupt
pcieport 0000:00:02.0: Requesting control of PCIe PME from ACPI BIOS
pcieport 0000:00:02.0: Signaling PME through PCIe PME interrupt
pcieport 0000:00:03.0: Requesting control of PCIe PME from ACPI BIOS
pcieport 0000:00:03.0: Signaling PME through PCIe PME interrupt
pcieport 0000:00:04.0: Requesting control of PCIe PME from ACPI BIOS
pcieport 0000:00:04.0: Signaling PME through PCIe PME interrupt
pcieport 0000:00:05.0: Requesting control of PCIe PME from ACPI BIOS
pcieport 0000:00:05.0: Signaling PME through PCIe PME interrupt
pcieport 0000:00:06.0: Requesting control of PCIe PME from ACPI BIOS
pcieport 0000:00:06.0: Signaling PME through PCIe PME interrupt
pcieport 0000:00:07.0: Requesting control of PCIe PME from ACPI BIOS
pcieport 0000:00:07.0: Signaling PME through PCIe PME interrupt
pcieport 0000:00:08.0: Requesting control of PCIe PME from ACPI BIOS
pcieport 0000:00:08.0: Signaling PME through PCIe PME interrupt
pcieport 0000:00:09.0: Requesting control of PCIe PME from ACPI BIOS
pcieport 0000:00:09.0: Signaling PME through PCIe PME interrupt
pci 0000:0a:00.0: Signaling PME through PCIe PME interrupt
pci 0000:0a:00.2: Signaling PME through PCIe PME interrupt
pcieport 0000:00:0a.0: Requesting control of PCIe PME from ACPI BIOS
pcieport 0000:00:0a.0: Signaling PME through PCIe PME interrupt
pcieport 0000:00:1c.0: Requesting control of PCIe PME from ACPI BIOS
pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
pcieport 0000:00:1c.4: Requesting control of PCIe PME from ACPI BIOS
pcieport 0000:00:1c.4: Signaling PME through PCIe PME interrupt
pci 0000:0f:00.0: Signaling PME through PCIe PME interrupt
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
pciehp 0000:00:1c.0:pcie04: HPC vendor_id 8086 device_id 3a40 ss_vid
15d9 ss_did 10a7
pciehp 0000:00:1c.4:pcie04: HPC vendor_id 8086 device_id 3a48 ss_vid
15d9 ss_did 10a7
pciehp: PCI Express Hot Plug Controller Driver version: 0.4
acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
pci-stub: invalid id string ""
input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input0
ACPI: Sleep Button [SLPB]
input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input1
ACPI: Power Button [PWRB]
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
ACPI: Power Button [PWRF]
Non-volatile memory driver v1.3
Linux agpgart interface v0.103
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
�serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:06: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
brd: module loaded
loop: module loaded
Fixed MDIO Bus: probed
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1a.7: debug port 1
ehci_hcd 0000:00:1a.7: irq 18, io mem 0xfbf02000
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.34-rc7 ehci_hcd
usb usb1: SerialNumber: 0000:00:1a.7
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 6 ports detected
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfbf01000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: EHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.34-rc7 ehci_hcd
usb usb2: SerialNumber: 0000:00:1d.7
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 6 ports detected
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000f0c0
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.34-rc7 uhci_hcd
usb usb3: SerialNumber: 0000:00:1a.0
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
uhci_hcd 0000:00:1a.2: PCI INT D -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1a.2: UHCI Host Controller
uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1a.2: irq 19, io base 0x0000f0a0
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.34-rc7 uhci_hcd
usb usb4: SerialNumber: 0000:00:1a.2
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000f080
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.34-rc7 uhci_hcd
usb usb5: SerialNumber: 0000:00:1d.0
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000f060
usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb6: Product: UHCI Host Controller
usb usb6: Manufacturer: Linux 2.6.34-rc7 uhci_hcd
usb usb6: SerialNumber: 0000:00:1d.1
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000f040
usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
usb 1-5: new high speed USB device using ehci_hcd and address 2
usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb7: Product: UHCI Host Controller
usb usb7: Manufacturer: Linux 2.6.34-rc7 uhci_hcd
usb usb7: SerialNumber: 0000:00:1d.2
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 2 ports detected
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
rtc_cmos 00:08: RTC can wake from S4
rtc_cmos 00:08: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one year, y3k, 114 bytes nvram, hpet irqs
cpuidle: using governor ladder
cpuidle: using governor menu
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
nf_conntrack.acct=1 kernel parameter, acct=1 nf_conntrack module option or
sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
ip_tables: (C) 2000-2006 Netfilter Core Team
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 17
registered taskstats version 1
No TPM chip found, activating TPM-bypass!
rtc_cmos 00:08: setting system clock to 2010-06-03 08:14:03 UTC (1275552843)
Initalizing network drop monitor service
Freeing unused kernel memory: 1428k freed
usb 1-5: New USB device found, idVendor=14dd, idProduct=0002
Write protecting the kernel read-only data: 10240k
usb 1-5: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-5: Product: Multidevice
usb 1-5: Manufacturer: Peppercon AG
Freeing unused kernel memory: 1356k freed
usb 1-5: SerialNumber: 0163a4019e487fc814E72156DB3AC4FA
Freeing unused kernel memory: 1848k freed
input: Peppercon AG Multidevice as
/devices/pci0000:00/0000:00:1a.7/usb1/1-5/1-5:1.1/input/input3
generic-usb 0003:14DD:0002.0001: input,hidraw0: USB HID v1.01 Mouse
[Peppercon AG Multidevice] on usb-0000:00:1a.7-5/input1
input: Peppercon AG Multidevice as
/devices/pci0000:00/0000:00:1a.7/usb1/1-5/1-5:1.2/input/input4
dracut: dracut-004-19.el6
dracut: rd_NO_LUKS: removing cryptoluks activation
generic-usb 0003:14DD:0002.0002: input,hidraw1: USB HID v1.01 Keyboard
[Peppercon AG Multidevice] on usb-0000:00:1a.7-5/input2
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.17.0-ioctl (2010-03-05) initialised: dm-devel@redhat.com
udev: starting version 147
[drm] Initialized drm 1.1.0 20060810
[drm] radeon defaulting to kernel modesetting.
[drm] radeon kernel modesetting enabled.
radeon 0000:10:01.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[drm] initializing kernel modesetting (RV100 0x1002:0x515E).
[drm] register mmio base: 0xFBD20000
[drm] register mmio size: 65536
[drm] GPU reset succeed (RBBM_STATUS=0x00000140)
[drm] 1 Power State(s)
[drm] State 0 Default (default)
[drm] 	1 Clock Mode(s)
[drm] 		0 engine/memory: 200000/200000
[drm] radeon: power management initialized
radeon 0000:10:01.0: VRAM: 64M 0xF0000000 - 0xF3FFFFFF (32M used)
radeon 0000:10:01.0: GTT: 512M 0xD0000000 - 0xEFFFFFFF
[drm] radeon: irq initialized.
[drm] Detected VRAM RAM=64M, BAR=128M
[drm] RAM width 16bits DDR
[TTM] Zone  kernel: Available graphics memory: 9260658 kiB.
[TTM] Zone   dma32: Available graphics memory: 2097152 kiB.
[drm] radeon: 32M of VRAM memory ready
[drm] radeon: 512M of GTT memory ready.
[drm] GART: num cpu pages 131072, num gpu pages 131072
[drm] radeon: cp idle (0x00008080)
[drm] Loading R100 Microcode
platform radeon_cp.0: firmware: requesting radeon/R100_cp.bin
[drm] radeon: ring at 0x00000000D0000000
[drm] ring test succeeded in 1 usecs
[drm] radeon: ib pool ready.
[drm] ib test succeeded in 0 usecs
[drm] No TV DAC info found in BIOS
[drm] No valid Ext TMDS info found in BIOS
[drm] Radeon Display Connectors
[drm] Connector 0:
[drm]   VGA
[drm]   DDC: 0x60 0x60 0x60 0x60 0x60 0x60 0x60 0x60
[drm]   Encoders:
[drm]     CRT1: INTERNAL_DAC1
[drm] Connector 1:
[drm]   DVI-I
[drm]   HPD2
[drm]   DDC: 0x6c 0x6c 0x6c 0x6c 0x6c 0x6c 0x6c 0x6c
[drm]   Encoders:
[drm]     CRT2: INTERNAL_DAC2
[drm]     DFP2: INTERNAL_DVO1
[drm] fb mappable at 0xF0040000
[drm] vram apper at 0xF0000000
[drm] size 786432
[drm] fb depth is 8
[drm]    pitch is 1024
fbcon: radeondrmfb (fb0) is primary device
Console: switching to colour frame buffer device 128x48
fb0: radeondrmfb frame buffer device
registered panic notifier
[drm] Initialized radeon 2.3.0 20080528 for 0000:10:01.0 on minor 0
dracut: Starting plymouth daemon
pata_jmicron 0000:0f:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Initializing USB Mass Storage driver...
scsi0 : usb-storage 1-5:1.0
scsi1 : pata_jmicron
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
scsi2 : pata_jmicron
ata1: PATA max UDMA/100 cmd 0xd040 ctl 0xd030 bmdma 0xd000 irq 16
ata2: PATA max UDMA/100 cmd 0xd020 ctl 0xd010 bmdma 0xd008 irq 16
scsi 0:0:0:0: CD-ROM            PepperC  Virtual Disc 1   0.01 PQ: 0 ANSI: 3
sr0: scsi-1 drive
Uniform CD-ROM driver Revision: 3.20


No root device found


No root device found


No root device found


No root device found

Boot has failed, sleeping forever.

> And then
>
> $ git reset --hard 365cfa1ed5^
> $ make
> $ ...boot...
>
Linux version 2.6.34-rc7 (root@localhost) (gcc version 4.4.4 20100503
(Red Hat 4.4.4-2) (GCC) ) #24 SMP Thu Jun 3 08:07:58 EDT 2010
Command line: ro root=/dev/mapper/vg_intels3ea209-lv_root
rd_LVM_LV=vg_intels3ea209/lv_root rd_LVM_LV=vg_intels3ea209/lv_swap
rd_NO_LUKS rd_NO_MD rd_NO_DM LA
NG=en_US.UTF-8 SYSFONT=latarcyrheb-sun16 KEYBOARDTYPE=pc KEYTABLE=us
console=ttyS0,115200n81 console=tty0 console=ttyS0,115200n81
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009d800 (usable)
 BIOS-e820: 000000000009d800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000bf340000 (usable)
 BIOS-e820: 00000000bf340000 - 00000000bf3c1000 (ACPI NVS)
 BIOS-e820: 00000000bf3c1000 - 00000000bf3c2000 (ACPI data)
 BIOS-e820: 00000000bf3c2000 - 00000000bf3d5000 (reserved)
 BIOS-e820: 00000000bf3d5000 - 00000000bf3d6000 (ACPI NVS)
 BIOS-e820: 00000000bf3d6000 - 00000000bf3e7000 (reserved)
 BIOS-e820: 00000000bf3e7000 - 00000000bf3ea000 (ACPI NVS)
 BIOS-e820: 00000000bf3ea000 - 00000000bf44f000 (reserved)
 BIOS-e820: 00000000bf44f000 - 00000000bf45a000 (ACPI data)
 BIOS-e820: 00000000bf45a000 - 00000000bf465000 (ACPI NVS)
 BIOS-e820: 00000000bf465000 - 00000000bf483000 (reserved)
 BIOS-e820: 00000000bf483000 - 00000000bf686000 (ACPI NVS)
 BIOS-e820: 00000000bf686000 - 00000000bf800000 (usable)
 BIOS-e820: 00000000c0000000 - 00000000d0000000 (reserved)
 BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
 BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 00000004c0000000 (usable)
NX (Execute Disable) protection: active
DMI 2.4 present.
AMI BIOS detected: BIOS may corrupt low RAM, working around it.
e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
e820 update range: 0000000000000000 - 0000000000001000 (usable) ==> (reserved)
e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
No AGP bridge found
last_pfn = 0x4c0000 max_arch_pfn = 0x400000000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-CFFFF write-protect
  D0000-E7FFF uncachable
  E8000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 0000000000 mask FC00000000 write-back
  1 base 0400000000 mask FF80000000 write-back
  2 base 0480000000 mask FFC0000000 write-back
  3 base 00C0000000 mask FFC0000000 uncachable
  4 disabled
  5 disabled
  6 disabled
  7 disabled
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
original variable MTRRs
reg 0, base: 0GB, range: 16GB, type WB
reg 1, base: 16GB, range: 2GB, type WB
 reg 2, base: 18GB, range: 1GB, type WB
reg 3, base: 3GB, range: 1GB, type UC
total RAM covered: 18432M
Found optimal setting for mtrr clean up
 gran_size: 64K 	chunk_size: 64K 	num_reg: 6  	lose cover RAM: 0G
New variable MTRRs
reg 0, base: 0GB, range: 2GB, type WB
reg 1, base: 2GB, range: 1GB, type WB
reg 2, base: 4GB, range: 4GB, type WB
reg 3, base: 8GB, range: 8GB, type WB
reg 4, base: 16GB, range: 2GB, type WB
reg 5, base: 18GB, range: 1GB, type WB
e820 update range: 00000000c0000000 - 0000000100000000 (usable) ==> (reserved)
last_pfn = 0xbf800 max_arch_pfn = 0x400000000
initial memory mapped : 0 - 20000000
found SMP MP-table at [ffff8800000fdf30] fdf30
init_memory_mapping: 0000000000000000-00000000bf800000
 0000000000 - 00bf800000 page 2M
kernel direct mapping tables up to bf800000 @ 16000-1a000
init_memory_mapping: 0000000100000000-00000004c0000000
 0100000000 - 04c0000000 page 2M
kernel direct mapping tables up to 4c0000000 @ 18000-2c000
RAMDISK: 36cbf000 - 37ff0000
ACPI: RSDP 00000000000f03f0 00024 (v02 ALASKA)
ACPI: XSDT 00000000bf458e18 00084 (v01 ALASKA    A M I 06222004 MSFT 00010013)
ACPI: FACP 00000000bf457d98 000F4 (v04 ALASKA    A M I 06222004 MSFT 00010013)
ACPI Warning: 32/64 FACS address mismatch in FADT - two FACS tables!
(20100121/tbfadt-369)
ACPI Warning: 32/64X FACS address mismatch in FADT -
BF461F40/00000000BF462E40, using 32 (20100121/tbfadt-486)
ACPI: DSDT 00000000bf450018 06E8F (v01 ALASKA    A M I 00000001 INTL 20051117)
ACPI: FACS 00000000bf461f40 00040
ACPI: APIC 00000000bf457c18 000E4 (v02 ALASKA    A M I 06222004 MSFT 00010013)
ACPI: MCFG 00000000bf459f18 0003C (v01 A M I  OEMMCFG  06222004 MSFT 00000097)
ACPI: SRAT 00000000bf44fc18 003B0 (v01 A M I  AMI SRAT 00000000 AMI. 00000000)
ACPI: SLIT 00000000bf459e98 00030 (v01 A M I  AMI SLIT 00000000 AMI. 00000000)
ACPI: HPET 00000000bf459e18 00038 (v01 A M I  ICH7HPET 06222004 AMI. 00000003)
ACPI: SPMI 00000000bf459d98 00040 (v05 A M I   OEMSPMI 00000000 AMI. 00000000)
ACPI: EINJ 00000000bf457a98 00130 (v01    AMI AMI EINJ 00000000      00000000)
ACPI: ERST 00000000bf3c1c98 00210 (v01  AMIER AMI ERST 00000000      00000000)
ACPI: HEST 00000000bf3c1f18 000A8 (v01    AMI AMI HEST 00000000      00000000)
ACPI: BERT 00000000bf459d18 00030 (v01    AMI AMI BERT 00000000      00000000)
ACPI: DMAR 00000000bf458d18 000C0 (v01 A M I   OEMDMAR 00000001 INTL 00000001)
ACPI: Local APIC address 0xfee00000
SRAT: PXM 0 -> APIC 0x00 -> Node 0
SRAT: PXM 0 -> APIC 0x02 -> Node 0
SRAT: PXM 0 -> APIC 0x04 -> Node 0
SRAT: PXM 0 -> APIC 0x06 -> Node 0
SRAT: PXM 1 -> APIC 0x10 -> Node 1
SRAT: PXM 1 -> APIC 0x12 -> Node 1
SRAT: PXM 1 -> APIC 0x14 -> Node 1
SRAT: PXM 1 -> APIC 0x16 -> Node 1
SRAT: Node 0 PXM 0 0-c0000000
SRAT: Node 0 PXM 0 100000000-280000000
SRAT: Node 1 PXM 1 280000000-4c0000000
NUMA: Using 31 for the hash shift.
Initmem setup node 0 0000000000000000-0000000280000000
  NODE_DATA [0000000100000000 - 0000000100026fff]
Initmem setup node 1 0000000280000000-00000004c0000000
  NODE_DATA [0000000280000000 - 0000000280026fff]
 [ffffea0000000000-ffffea0008bfffff] PMD ->
[ffff880100200000-ffff880107ffffff] on node 0
 [ffffea0008c00000-ffffea00109fffff] PMD ->
[ffff880280200000-ffff880287ffffff] on node 1
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x004c0000
Movable zone start PFN for each node
early_node_map[5] active PFN ranges
    0: 0x00000010 -> 0x0000009d
    0: 0x00000100 -> 0x000bf340
    0: 0x000bf686 -> 0x000bf800
    0: 0x00100000 -> 0x00280000
    1: 0x00280000 -> 0x004c0000
On node 0 totalpages: 2356295
  DMA zone: 56 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 3925 pages, LIFO batch:0
  DMA32 zone: 14280 pages used for memmap
  DMA32 zone: 765170 pages, LIFO batch:31
  Normal zone: 21504 pages used for memmap
  Normal zone: 1551360 pages, LIFO batch:31
On node 1 totalpages: 2359296
  Normal zone: 32256 pages used for memmap
  Normal zone: 2327040 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x408
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x10] enabled)
ACPI: LAPIC (acpi_id[0x06] lapic_id[0x12] enabled)
ACPI: LAPIC (acpi_id[0x07] lapic_id[0x14] enabled)
ACPI: LAPIC (acpi_id[0x08] lapic_id[0x16] enabled)
ACPI: LAPIC (acpi_id[0x09] lapic_id[0x08] disabled)
ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x09] disabled)
ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x0a] disabled)
ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x0b] disabled)
ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x0c] disabled)
ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x0d] disabled)
ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x0e] disabled)
ACPI: LAPIC (acpi_id[0x10] lapic_id[0x0f] disabled)
ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 0, version 32, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x02] address[0xfec01000] gsi_base[24])
IOAPIC[1]: apic_id 2, version 32, address 0xfec01000, GSI 24-47
ACPI: IOAPIC (id[0x03] address[0xfec02000] gsi_base[48])
IOAPIC[2]: apic_id 3, version 32, address 0xfec02000, GSI 48-71
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a301 base: 0xfed00000
early_res array is doubled to 64 at [27040 - 2783f]
SMP: Allowing 16 CPUs, 8 hotplug CPUs
nr_irqs_gsi: 72
PM: Registered nosave memory: 000000000009d000 - 000000000009e000
PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
PM: Registered nosave memory: 00000000bf340000 - 00000000bf3c1000
PM: Registered nosave memory: 00000000bf3c1000 - 00000000bf3c2000
PM: Registered nosave memory: 00000000bf3c2000 - 00000000bf3d5000
PM: Registered nosave memory: 00000000bf3d5000 - 00000000bf3d6000
PM: Registered nosave memory: 00000000bf3d6000 - 00000000bf3e7000
PM: Registered nosave memory: 00000000bf3e7000 - 00000000bf3ea000
PM: Registered nosave memory: 00000000bf3ea000 - 00000000bf44f000
PM: Registered nosave memory: 00000000bf44f000 - 00000000bf45a000
PM: Registered nosave memory: 00000000bf45a000 - 00000000bf465000
PM: Registered nosave memory: 00000000bf465000 - 00000000bf483000
PM: Registered nosave memory: 00000000bf483000 - 00000000bf686000
PM: Registered nosave memory: 00000000bf800000 - 00000000c0000000
PM: Registered nosave memory: 00000000c0000000 - 00000000d0000000
PM: Registered nosave memory: 00000000d0000000 - 00000000fed1c000
PM: Registered nosave memory: 00000000fed1c000 - 00000000fed20000
PM: Registered nosave memory: 00000000fed20000 - 00000000ff000000
PM: Registered nosave memory: 00000000ff000000 - 0000000100000000
Allocating PCI resources starting at d0000000 (gap: d0000000:2ed1c000)
Booting paravirtualized kernel on bare hardware
early_res array is doubled to 128 at [27840 - 2883f]
setup_percpu: NR_CPUS:4096 nr_cpumask_bits:16 nr_cpu_ids:16 nr_node_ids:2
PERCPU: Embedded 31 pages/cpu @ffff880002400000 s94696 r8192 d24088 u262144
pcpu-alloc: s94696 r8192 d24088 u262144 alloc=1*2097152
pcpu-alloc: [0] 00 01 02 03 08 10 12 14 [1] 04 05 06 07 09 11 13 15
Built 2 zonelists in Zone order, mobility grouping on.  Total pages: 4647495
Policy zone: Normal
Kernel command line: ro root=/dev/mapper/vg_intels3ea209-lv_root
rd_LVM_LV=vg_intels3ea209/lv_root rd_LVM_LV=vg_intels3ea209/lv_swap
rd_NO_LUKS rd_NO_MD rd_N
O_DM LANG=en_US.UTF-8 SYSFONT=latarcyrheb-sun16 KEYBOARDTYPE=pc
KEYTABLE=us console=ttyS0,115200n81 console=tty0
console=ttyS0,115200n81
PID hash table entries: 4096 (order: 3, 32768 bytes)
Checking aperture...
No AGP bridge found
Subtract (91 early reservations)
  #1 [0001000000 - 0002262998]   TEXT DATA BSS
  #2 [0036cbf000 - 0037ff0000]         RAMDISK
  #3 [0002263000 - 000226321c]             BRK
  #4 [00000fdf40 - 0000100000]   BIOS reserved
  #5 [00000fdf30 - 00000fdf40]    MP-table mpf
  #6 [000009d800 - 00000fda20]   BIOS reserved
  #7 [00000fde9c - 00000fdf30]   BIOS reserved
  #8 [00000fda20 - 00000fde9c]    MP-table mpc
  #9 [0000010000 - 0000012000]      TRAMPOLINE
  #10 [0000012000 - 0000016000]     ACPI WAKEUP
 #11 [0000016000 - 0000018000]         PGTABLE
  #12 [0000018000 - 0000027000]         PGTABLE
  #13 [0000027000 - 0000027030]       ACPI SLIT
  #14 [0100000000 - 0100027000]       NODE_DATA
  #15 [0280000000 - 0280027000]       NODE_DATA
  #16 [0002263240 - 0002264240]         BOOTMEM
  #17 [0280027000 - 0280028000]         BOOTMEM
  #18 [0002664240 - 0002664900]         BOOTMEM
  #19 [0280028000 - 02800286c0]         BOOTMEM
  #20 [0100027000 - 0100028000]         BOOTMEM
  #21 [0100028000 - 0100029000]         BOOTMEM
  #22 [0100200000 - 0108000000]        MEMMAP 0
  #23 [0280200000 - 0288000000]        MEMMAP 1
  #24 [0002264240 - 000227c240]         BOOTMEM
  #25 [000227c240 - 0002294240]         BOOTMEM
  #26 [0002294240 - 00022ac240]         BOOTMEM
  #27 [02800286c0 - 02800406c0]         BOOTMEM
  #28 [00022ad000 - 00022ae000]         BOOTMEM
  #29 [00022629c0 - 0002262a01]         BOOTMEM
  #30 [0002262a40 - 0002262b09]         BOOTMEM
  #31 [0002262b40 - 0002262fd8]         BOOTMEM
  #32 [00022ac240 - 00022ac2a8]         BOOTMEM
  #33 [00022ac2c0 - 00022ac328]         BOOTMEM
  #34 [00022ac340 - 00022ac3a8]         BOOTMEM
  #35 [00022ac3c0 - 00022ac428]         BOOTMEM
  #36 [00022ac440 - 00022ac4a8]         BOOTMEM
  #37 [00022ac4c0 - 00022ac528]         BOOTMEM
  #38 [00022ac540 - 00022ac5a8]         BOOTMEM
  #39 [00022ac5c0 - 00022ac628]         BOOTMEM
  #40 [00022ac640 - 00022ac6a8]         BOOTMEM
  #41 [00022ac6c0 - 00022ac728]         BOOTMEM
  #42 [00022ac740 - 00022ac7a8]         BOOTMEM
  #43 [00022ac7c0 - 00022ac828]         BOOTMEM
  #44 [00022ac840 - 00022ac8a8]         BOOTMEM
  #45 [00022ac8c0 - 00022ac928]         BOOTMEM
  #46 [00022ac940 - 00022ac9a8]         BOOTMEM
  #47 [00022ac9c0 - 00022aca28]         BOOTMEM
  #48 [00022aca40 - 00022acaa8]         BOOTMEM
  #49 [00022acac0 - 00022acb28]         BOOTMEM
  #50 [00022acb40 - 00022acba8]         BOOTMEM
  #51 [00022acbc0 - 00022acc28]         BOOTMEM
  #52 [00022acc40 - 00022acc60]         BOOTMEM
  #53 [00022acc80 - 00022acca0]         BOOTMEM
  #54 [00022accc0 - 00022acce0]         BOOTMEM
  #55 [00022acd00 - 00022ace11]         BOOTMEM
  #56 [00022ace40 - 00022acf51]         BOOTMEM
  #57 [0002400000 - 000241f000]         BOOTMEM
  #58 [0002440000 - 000245f000]         BOOTMEM
  #59 [0002480000 - 000249f000]         BOOTMEM
  #60 [00024c0000 - 00024df000]         BOOTMEM
  #61 [0002500000 - 000251f000]         BOOTMEM
  #62 [0002540000 - 000255f000]         BOOTMEM
  #63 [0002580000 - 000259f000]         BOOTMEM
  #64 [00025c0000 - 00025df000]         BOOTMEM
 #65 [0288000000 - 028801f000]         BOOTMEM
  #66 [0288040000 - 028805f000]         BOOTMEM
  #67 [0288080000 - 028809f000]         BOOTMEM
  #68 [02880c0000 - 02880df000]         BOOTMEM
  #69 [0288100000 - 028811f000]         BOOTMEM
  #70 [0288140000 - 028815f000]         BOOTMEM
  #71 [0288180000 - 028819f000]         BOOTMEM
  #72 [02881c0000 - 02881df000]         BOOTMEM
  #73 [00022acf80 - 00022acf90]         BOOTMEM
  #74 [00022acfc0 - 00022acfd0]         BOOTMEM
  #75 [00022b0000 - 00022b0040]         BOOTMEM
  #76 [00022b0040 - 00022b00c0]         BOOTMEM
  #77 [00022b00c0 - 00022b01e0]         BOOTMEM
  #78 [00022b0200 - 00022b0248]         BOOTMEM
  #79 [00022b0280 - 00022b02c8]         BOOTMEM
  #80 [00022ae000 - 00022ae200]         BOOTMEM
  #81 [00022ae200 - 00022ae400]         BOOTMEM
  #82 [00022ae400 - 00022ae600]         BOOTMEM
  #83 [00022ae600 - 00022ae800]         BOOTMEM
  #84 [00022ae800 - 00022aea00]         BOOTMEM
  #85 [00022aea00 - 00022aec00]         BOOTMEM
  #86 [00022b0300 - 00022b8300]         BOOTMEM
  #87 [0002665000 - 0006665000]         BOOTMEM
  #88 [00022b8300 - 00022d8300]         BOOTMEM
  #89 [00022d8300 - 0002318300]         BOOTMEM
  #90 [0000028840 - 0000030840]         BOOTMEM
Memory: 18497032k/19922944k available (4769k kernel code, 1060580k
absent, 365332k reserved, 7764k data, 1428k init)
Hierarchical RCU implementation.
NR_IRQS:262400 nr_irqs:1352
Extended CMOS year: 2000
Console: colour VGA+ 80x25
console [tty0] enabled
console [ttyS0] enabled
allocated 188743680 bytes of page_cgroup
please try 'cgroup_disable=memory' option if you don't want memory cgroups
hpet clockevent registered
Fast TSC calibration using PIT
Detected 2799.844 MHz processor.
Calibrating delay loop (skipped), value calculated using timer
frequency.. 5599.68 BogoMIPS (lpj=2799844)
Security Framework initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
Dentry cache hash table entries: 4194304 (order: 13, 33554432 bytes)
Inode-cache hash table entries: 2097152 (order: 12, 16777216 bytes)
Mount-cache hash table entries: 256
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
Initializing cgroup subsys memory
Initializing cgroup subsys devices
Initializing cgroup subsys freezer
Initializing cgroup subsys net_cls
Initializing cgroup subsys blkio
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 9 MCE banks
CPU0: Thermal monitoring enabled (TM1)
using mwait in idle threads.
Performance Events: Nehalem/Corei7 events, Intel PMU driver.
... version:                3
... bit width:              48
... generic registers:      4
... value mask:             0000ffffffffffff
... max period:             000000007fffffff
... fixed-purpose events:   3
... event mask:             000000070000000f
ACPI: Core revision 20100121
ftrace: converting mcount calls to 0f 1f 44 00 00
ftrace: allocating 18173 entries in 72 pages
DMAR: Host address width 40
DMAR: DRHD base: 0x000000fe710000 flags: 0x1
IOMMU fe710000: ver 1:0 cap c90780106f0462 ecap f0207e
DMAR: RMRR base: 0x000000bf3ea000 end: 0x000000bf3fdfff
DMAR: ATSR flags: 0x0
IOAPIC id 0 under DRHD base 0xfe710000
Not all IO-APIC's listed under remapping hardware
Not enable interrupt remapping
Setting APIC routing to physical flat
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Xeon(R) CPU           X5560  @ 2.80GHz stepping 05
Booting Node   0, Processors  #1 #2 #3 Ok.
Booting Node   1, Processors  #4 #5 #6 #7
Brought up 8 CPUs
Total of 8 processors activated (44793.85 BogoMIPS).
devtmpfs: initialized
regulator: core version 0.5
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem
0xc0000000-0xcfffffff] (base 0xc0000000)
PCI: MMCONFIG at [mem 0xc0000000-0xcfffffff] reserved in E820
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: EC: Look up EC in DSDT
\_SB_:_OSC evaluation returned wrong type
_OSC request data:1 7
ACPI: Executed 1 blocks of module-level executable AML code
ACPI: BIOS _OSI(Linux) query ignored
ACPI: SSDT 00000000bf45b018 01054 (v01    AMI      IST 00000001 MSFT 03000001)
ACPI: Interpreter enabled
ACPI: (supports S0 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: No dock devices found.
PCI: Using host bridge windows from ACPI; if necessary, use
"pci=nocrs" and report a bug
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
pci_root PNP0A08:00: host bridge window [mem 0xc0000000-0xffffffff]
pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
pci 0000:00:00.0: PME# disabled
pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
pci 0000:00:01.0: PME# disabled
pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
pci 0000:00:02.0: PME# disabled
pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
pci 0000:00:03.0: PME# disabled
pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
pci 0000:00:04.0: PME# disabled
pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
pci 0000:00:05.0: PME# disabled
pci 0000:00:06.0: PME# supported from D0 D3hot D3cold
pci 0000:00:06.0: PME# disabled
pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
pci 0000:00:07.0: PME# disabled
pci 0000:00:08.0: PME# supported from D0 D3hot D3cold
pci 0000:00:08.0: PME# disabled
pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
pci 0000:00:09.0: PME# disabled
pci 0000:00:0a.0: PME# supported from D0 D3hot D3cold
pci 0000:00:0a.0: PME# disabled
pci 0000:00:13.0: reg 10: [mem 0xfbf03000-0xfbf03fff]
pci 0000:00:13.0: PME# supported from D0 D3hot D3cold
pci 0000:00:13.0: PME# disabled
pci 0000:00:16.0: reg 10: [mem 0xfffff1c000-0xfffff1ffff 64bit]
pci 0000:00:16.1: reg 10: [mem 0xfffff18000-0xfffff1bfff 64bit]
pci 0000:00:16.2: reg 10: [mem 0xfffff14000-0xfffff17fff 64bit]
pci 0000:00:16.3: reg 10: [mem 0xfffff10000-0xfffff13fff 64bit]
pci 0000:00:16.4: reg 10: [mem 0xfffff0c000-0xfffff0ffff 64bit]
pci 0000:00:16.5: reg 10: [mem 0xfffff08000-0xfffff0bfff 64bit]
pci 0000:00:16.6: reg 10: [mem 0xfffff04000-0xfffff07fff 64bit]
pci 0000:00:16.7: reg 10: [mem 0xfffff00000-0xfffff03fff 64bit]
pci 0000:00:1a.0: reg 20: [io  0xf0c0-0xf0df]
pci 0000:00:1a.2: reg 20: [io  0xf0a0-0xf0bf]
pci 0000:00:1a.7: reg 10: [mem 0xfbf02000-0xfbf023ff]
pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1a.7: PME# disabled
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.4: PME# disabled
pci 0000:00:1d.0: reg 20: [io  0xf080-0xf09f]
pci 0000:00:1d.1: reg 20: [io  0xf060-0xf07f]
pci 0000:00:1d.2: reg 20: [io  0xf040-0xf05f]
pci 0000:00:1d.7: reg 10: [mem 0xfbf01000-0xfbf013ff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1f.0: quirk: [io  0x0400-0x047f] claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: [io  0x0500-0x053f] claimed by ICH6 GPIO
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0600 (mask 00ff)
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 0ca0 (mask 000f)
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 0290 (mask 001f)
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 4 PIO at 0ca0 (mask 000f)
pci 0000:00:1f.2: reg 10: [io  0xf110-0xf117]
pci 0000:00:1f.2: reg 14: [io  0xf100-0xf103]
pci 0000:00:1f.2: reg 18: [io  0xf0f0-0xf0f7]
pci 0000:00:1f.2: reg 1c: [io  0xf0e0-0xf0e3]
pci 0000:00:1f.2: reg 20: [io  0xf020-0xf03f]
pci 0000:00:1f.2: reg 24: [mem 0xfbf00000-0xfbf007ff]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.2: PME# disabled
pci 0000:00:1f.3: reg 10: [mem 0xfffff20000-0xfffff200ff 64bit]
pci 0000:00:1f.3: reg 20: [io  0xf000-0xf01f]
pci 0000:01:00.0: reg 10: [mem 0xfbba0000-0xfbbbffff]
pci 0000:01:00.0: reg 14: [mem 0xfbb80000-0xfbb9ffff]
pci 0000:01:00.0: reg 18: [io  0xe020-0xe03f]
pci 0000:01:00.0: reg 1c: [mem 0xfbc44000-0xfbc47fff]
pci 0000:01:00.0: reg 30: [mem 0xfbb60000-0xfbb7ffff pref]
pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
pci 0000:01:00.0: PME# disabled
pci 0000:01:00.0: reg 184: [mem 0xfbc20000-0xfbc23fff 64bit]
pci 0000:01:00.0: reg 190: [mem 0xfbc00000-0xfbc03fff 64bit]
pci 0000:01:00.1: reg 10: [mem 0xfbb40000-0xfbb5ffff]
pci 0000:01:00.1: reg 14: [mem 0xfbb20000-0xfbb3ffff]
pci 0000:01:00.1: reg 18: [io  0xe000-0xe01f]
pci 0000:01:00.1: reg 1c: [mem 0xfbc40000-0xfbc43fff]
pci 0000:01:00.1: reg 30: [mem 0xfbb00000-0xfbb1ffff pref]
pci 0000:01:00.1: PME# supported from D0 D3hot D3cold
pci 0000:01:00.1: PME# disabled
pci 0000:01:00.1: reg 184: [mem 0xfbbe0000-0xfbbe3fff 64bit]
pci 0000:01:00.1: reg 190: [mem 0xfbbc0000-0xfbbc3fff 64bit]
pci 0000:00:01.0: PCI bridge to [bus 01-02]
pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
pci 0000:00:01.0:   bridge window [mem 0xfbb00000-0xfbcfffff]
pci 0000:00:01.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:00:02.0: PCI bridge to [bus 03-03]
pci 0000:00:02.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:02.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
pci 0000:00:02.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:00:03.0: PCI bridge to [bus 04-04]
pci 0000:00:03.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:03.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
pci 0000:00:03.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:00:04.0: PCI bridge to [bus 05-05]
pci 0000:00:04.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:04.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
pci 0000:00:04.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:00:05.0: PCI bridge to [bus 06-06]
pci 0000:00:05.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:05.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
pci 0000:00:05.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:00:06.0: PCI bridge to [bus 07-07]
pci 0000:00:06.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:06.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
pci 0000:00:06.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:00:07.0: PCI bridge to [bus 08-08]
pci 0000:00:07.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:07.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
pci 0000:00:07.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:00:08.0: PCI bridge to [bus 09-09]
pci 0000:00:08.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:08.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
pci 0000:00:08.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:0a:00.0: PXH quirk detected; SHPC device MSI disabled
pci 0000:0a:00.0: PME# supported from D0 D3hot D3cold
pci 0000:0a:00.0: PME# disabled
pci 0000:0a:00.2: PXH quirk detected; SHPC device MSI disabled
pci 0000:0a:00.2: PME# supported from D0 D3hot D3cold
pci 0000:0a:00.2: PME# disabled
pci 0000:0a:00.0: disabling ASPM on pre-1.1 PCIe device.  You can
enable it with 'pcie_aspm=force'
pci 0000:00:09.0: PCI bridge to [bus 0a-0c]
pci 0000:00:09.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:09.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
pci 0000:00:09.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:0a:00.0: PCI bridge to [bus 0b-0b]
pci 0000:0a:00.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:0a:00.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
pci 0000:0a:00.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:0a:00.2: PCI bridge to [bus 0c-0c]
pci 0000:0a:00.2:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:0a:00.2:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
pci 0000:0a:00.2:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:00:0a.0: PCI bridge to [bus 0d-0d]
pci 0000:00:0a.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:0a.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
pci 0000:00:0a.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:00:1c.0: PCI bridge to [bus 0e-0e]
pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:0f:00.0: reg 10: [io  0xd040-0xd047]
pci 0000:0f:00.0: reg 14: [io  0xd030-0xd033]
pci 0000:0f:00.0: reg 18: [io  0xd020-0xd027]
pci 0000:0f:00.0: reg 1c: [io  0xd010-0xd013]
pci 0000:0f:00.0: reg 20: [io  0xd000-0xd00f]
pci 0000:0f:00.0: reg 30: [mem 0xfbe00000-0xfbe0ffff pref]
pci 0000:0f:00.0: disabling ASPM on pre-1.1 PCIe device.  You can
enable it with 'pcie_aspm=force'
pci 0000:00:1c.4: PCI bridge to [bus 0f-0f]
pci 0000:00:1c.4:   bridge window [io  0xd000-0xdfff]
pci 0000:00:1c.4:   bridge window [mem 0xfbe00000-0xfbefffff]
pci 0000:00:1c.4:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:10:01.0: reg 10: [mem 0xf0000000-0xf7ffffff pref]
pci 0000:10:01.0: reg 14: [io  0xc000-0xc0ff]
pci 0000:10:01.0: reg 18: [mem 0xfbd20000-0xfbd2ffff]
pci 0000:10:01.0: reg 30: [mem 0xfbd00000-0xfbd1ffff pref]
pci 0000:10:01.0: supports D1 D2
pci 0000:00:1e.0: PCI bridge to [bus 10-10] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0xc000-0xcfff]
pci 0000:00:1e.0:   bridge window [mem 0xfbd00000-0xfbdfffff]
pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xf7ffffff 64bit pref]
pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff]
(subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0xc0000000-0xffffffff]
(subtractive decode)
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE9._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE9.PXHB._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE9.PXHA._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 10 11 12 14 15) *0
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12 14 15) *0
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 10 11 12 14 15) *0
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 *10 11 12 14 15)
vgaarb: device added: PCI:0000:10:01.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: pci_cache_line_size set to 64 bytes
pci 0000:00:16.0: no compatible bridge window for [mem
0xfffff1c000-0xfffff1ffff 64bit]
pci 0000:00:16.1: no compatible bridge window for [mem
0xfffff18000-0xfffff1bfff 64bit]
pci 0000:00:16.2: no compatible bridge window for [mem
0xfffff14000-0xfffff17fff 64bit]
pci 0000:00:16.3: no compatible bridge window for [mem
0xfffff10000-0xfffff13fff 64bit]
pci 0000:00:16.4: no compatible bridge window for [mem
0xfffff0c000-0xfffff0ffff 64bit]
pci 0000:00:16.5: no compatible bridge window for [mem
0xfffff08000-0xfffff0bfff 64bit]
pci 0000:00:16.6: no compatible bridge window for [mem
0xfffff04000-0xfffff07fff 64bit]
pci 0000:00:16.7: no compatible bridge window for [mem
0xfffff00000-0xfffff03fff 64bit]
pci 0000:00:1f.3: no compatible bridge window for [mem
0xfffff20000-0xfffff200ff 64bit]
reserve RAM buffer: 000000000009d800 - 000000000009ffff
reserve RAM buffer: 00000000bf340000 - 00000000bfffffff
reserve RAM buffer: 00000000bf800000 - 00000000bfffffff
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
HPET: 4 timers in total, 0 timers will be used for per-cpu timer
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
hpet0: 4 comparators, 64-bit 14.318180 MHz counter
Switching to clocksource tsc
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 15 devices
ACPI: ACPI bus type pnp unregistered
system 00:01: [mem 0xfc000000-0xfcffffff] has been reserved
system 00:01: [mem 0xfd000000-0xfdffffff] has been reserved
system 00:01: [mem 0xfe000000-0xfe9fffff] has been reserved
system 00:01: [mem 0xfea00000-0xfea0001f] has been reserved
system 00:01: [mem 0xfeb00000-0xfebfffff] has been reserved
system 00:01: [mem 0xfed00400-0xfed3ffff] could not be reserved
system 00:01: [mem 0xfed45000-0xfedfffff] has been reserved
system 00:02: [io  0x0290-0x029f] has been reserved
system 00:0a: [io  0x04d0-0x04d1] has been reserved
system 00:0d: [io  0x0400-0x047f] has been reserved
system 00:0d: [io  0x1180-0x119f] has been reserved
system 00:0d: [io  0x0500-0x057f] could not be reserved
system 00:0d: [mem 0xfed1c000-0xfed1ffff] has been reserved
system 00:0d: [mem 0xfec00000-0xfecfffff] could not be reserved
system 00:0d: [mem 0xff000000-0xffffffff] has been reserved
pci 0000:00:1c.0: BAR 14: assigned [mem 0xd0000000-0xd01fffff]
pci 0000:00:1c.0: BAR 15: assigned [mem 0xd0200000-0xd03fffff 64bit pref]
pci 0000:00:1c.4: BAR 15: assigned [mem 0xd0400000-0xd05fffff 64bit pref]
pci 0000:00:16.0: BAR 0: assigned [mem 0xd0600000-0xd0603fff 64bit]
pci 0000:00:16.0: BAR 0: set to [mem 0xd0600000-0xd0603fff 64bit] (PCI
address [0xd0600000-0xd0603fff]
pci 0000:00:16.1: BAR 0: assigned [mem 0xd0604000-0xd0607fff 64bit]
pci 0000:00:16.1: BAR 0: set to [mem 0xd0604000-0xd0607fff 64bit] (PCI
address [0xd0604000-0xd0607fff]
pci 0000:00:16.2: BAR 0: assigned [mem 0xd0608000-0xd060bfff 64bit]
pci 0000:00:16.2: BAR 0: set to [mem 0xd0608000-0xd060bfff 64bit] (PCI
address [0xd0608000-0xd060bfff]
pci 0000:00:16.3: BAR 0: assigned [mem 0xd060c000-0xd060ffff 64bit]
pci 0000:00:16.3: BAR 0: set to [mem 0xd060c000-0xd060ffff 64bit] (PCI
address [0xd060c000-0xd060ffff]
pci 0000:00:16.4: BAR 0: assigned [mem 0xd0610000-0xd0613fff 64bit]
pci 0000:00:16.4: BAR 0: set to [mem 0xd0610000-0xd0613fff 64bit] (PCI
address [0xd0610000-0xd0613fff]
pci 0000:00:16.5: BAR 0: assigned [mem 0xd0614000-0xd0617fff 64bit]
pci 0000:00:16.5: BAR 0: set to [mem 0xd0614000-0xd0617fff 64bit] (PCI
address [0xd0614000-0xd0617fff]
pci 0000:00:16.6: BAR 0: assigned [mem 0xd0618000-0xd061bfff 64bit]
pci 0000:00:16.6: BAR 0: set to [mem 0xd0618000-0xd061bfff 64bit] (PCI
address [0xd0618000-0xd061bfff]
pci 0000:00:16.7: BAR 0: assigned [mem 0xd061c000-0xd061ffff 64bit]
pci 0000:00:16.7: BAR 0: set to [mem 0xd061c000-0xd061ffff 64bit] (PCI
address [0xd061c000-0xd061ffff]
pci 0000:00:1c.0: BAR 13: assigned [io  0x2000-0x2fff]
pci 0000:00:1f.3: BAR 0: assigned [mem 0xd0620000-0xd06200ff 64bit]
pci 0000:00:1f.3: BAR 0: set to [mem 0xd0620000-0xd06200ff 64bit] (PCI
address [0xd0620000-0xd06200ff]
pci 0000:00:01.0: PCI bridge to [bus 01-02]
pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
pci 0000:00:01.0:   bridge window [mem 0xfbb00000-0xfbcfffff]
pci 0000:00:01.0:   bridge window [mem pref disabled]
pci 0000:00:02.0: PCI bridge to [bus 03-03]
pci 0000:00:02.0:   bridge window [io  disabled]
pci 0000:00:02.0:   bridge window [mem disabled]
pci 0000:00:02.0:   bridge window [mem pref disabled]
pci 0000:00:03.0: PCI bridge to [bus 04-04]
pci 0000:00:03.0:   bridge window [io  disabled]
pci 0000:00:03.0:   bridge window [mem disabled]
pci 0000:00:03.0:   bridge window [mem pref disabled]
pci 0000:00:04.0: PCI bridge to [bus 05-05]
pci 0000:00:04.0:   bridge window [io  disabled]
pci 0000:00:04.0:   bridge window [mem disabled]
pci 0000:00:04.0:   bridge window [mem pref disabled]
pci 0000:00:05.0: PCI bridge to [bus 06-06]
pci 0000:00:05.0:   bridge window [io  disabled]
pci 0000:00:05.0:   bridge window [mem disabled]
pci 0000:00:05.0:   bridge window [mem pref disabled]
pci 0000:00:06.0: PCI bridge to [bus 07-07]
pci 0000:00:06.0:   bridge window [io  disabled]
pci 0000:00:06.0:   bridge window [mem disabled]
pci 0000:00:06.0:   bridge window [mem pref disabled]
pci 0000:00:07.0: PCI bridge to [bus 08-08]
pci 0000:00:07.0:   bridge window [io  disabled]
pci 0000:00:07.0:   bridge window [mem disabled]
pci 0000:00:07.0:   bridge window [mem pref disabled]
pci 0000:00:08.0: PCI bridge to [bus 09-09]
pci 0000:00:08.0:   bridge window [io  disabled]
pci 0000:00:08.0:   bridge window [mem disabled]
pci 0000:00:08.0:   bridge window [mem pref disabled]
pci 0000:0a:00.0: PCI bridge to [bus 0b-0b]
pci 0000:0a:00.0:   bridge window [io  disabled]
pci 0000:0a:00.0:   bridge window [mem disabled]
pci 0000:0a:00.0:   bridge window [mem pref disabled]
pci 0000:0a:00.2: PCI bridge to [bus 0c-0c]
pci 0000:0a:00.2:   bridge window [io  disabled]
pci 0000:0a:00.2:   bridge window [mem disabled]
pci 0000:0a:00.2:   bridge window [mem pref disabled]
pci 0000:00:09.0: PCI bridge to [bus 0a-0c]
pci 0000:00:09.0:   bridge window [io  disabled]
pci 0000:00:09.0:   bridge window [mem disabled]
pci 0000:00:09.0:   bridge window [mem pref disabled]
pci 0000:00:0a.0: PCI bridge to [bus 0d-0d]
pci 0000:00:0a.0:   bridge window [io  disabled]
pci 0000:00:0a.0:   bridge window [mem disabled]
pci 0000:00:0a.0:   bridge window [mem pref disabled]
pci 0000:00:1c.0: PCI bridge to [bus 0e-0e]
pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
pci 0000:00:1c.0:   bridge window [mem 0xd0000000-0xd01fffff]
pci 0000:00:1c.0:   bridge window [mem 0xd0200000-0xd03fffff 64bit pref]
pci 0000:00:1c.4: PCI bridge to [bus 0f-0f]
pci 0000:00:1c.4:   bridge window [io  0xd000-0xdfff]
pci 0000:00:1c.4:   bridge window [mem 0xfbe00000-0xfbefffff]
pci 0000:00:1c.4:   bridge window [mem 0xd0400000-0xd05fffff 64bit pref]
pci 0000:00:1e.0: PCI bridge to [bus 10-10]
pci 0000:00:1e.0:   bridge window [io  0xc000-0xcfff]
pci 0000:00:1e.0:   bridge window [mem 0xfbd00000-0xfbdfffff]
pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xf7ffffff 64bit pref]
  alloc irq_desc for 16 on node -1
  alloc kstat_irqs on node -1
pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:01.0: setting latency timer to 64
pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:02.0: setting latency timer to 64
pci 0000:00:03.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:03.0: setting latency timer to 64
pci 0000:00:04.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:04.0: setting latency timer to 64
pci 0000:00:05.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:05.0: setting latency timer to 64
pci 0000:00:06.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:06.0: setting latency timer to 64
pci 0000:00:07.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:07.0: setting latency timer to 64
pci 0000:00:08.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:08.0: setting latency timer to 64
pci 0000:00:09.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:09.0: setting latency timer to 64
pci 0000:0a:00.0: setting latency timer to 64
pci 0000:0a:00.2: setting latency timer to 64
pci 0000:00:0a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:0a.0: setting latency timer to 64
pci 0000:00:1c.0: enabling device (0000 -> 0003)
  alloc irq_desc for 17 on node -1
  alloc kstat_irqs on node -1
pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.0: setting latency timer to 64
pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.4: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: resource 7 [mem 0xc0000000-0xffffffff]
pci_bus 0000:01: resource 0 [io  0xe000-0xefff]
pci_bus 0000:01: resource 1 [mem 0xfbb00000-0xfbcfffff]
pci_bus 0000:0e: resource 0 [io  0x2000-0x2fff]
pci_bus 0000:0e: resource 1 [mem 0xd0000000-0xd01fffff]
pci_bus 0000:0e: resource 2 [mem 0xd0200000-0xd03fffff 64bit pref]
pci_bus 0000:0f: resource 0 [io  0xd000-0xdfff]
pci_bus 0000:0f: resource 1 [mem 0xfbe00000-0xfbefffff]
pci_bus 0000:0f: resource 2 [mem 0xd0400000-0xd05fffff 64bit pref]
pci_bus 0000:10: resource 0 [io  0xc000-0xcfff]
pci_bus 0000:10: resource 1 [mem 0xfbd00000-0xfbdfffff]
pci_bus 0000:10: resource 2 [mem 0xf0000000-0xf7ffffff 64bit pref]
pci_bus 0000:10: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:10: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:10: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:10: resource 7 [mem 0xc0000000-0xffffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 524288 (order: 10, 4194304 bytes)
TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 524288 bind 65536)
TCP reno registered
UDP hash table entries: 16384 (order: 7, 524288 bytes)
UDP-Lite hash table entries: 16384 (order: 7, 524288 bytes)
NET: Registered protocol family 1
pci 0000:00:1a.7: EHCI: BIOS handoff failed (BIOS bug?) 01010001
pci 0000:00:1d.7: EHCI: BIOS handoff failed (BIOS bug?) 01010001
pci 0000:0a:00.0: rerouting interrupts for [8086:0329]
pci 0000:0a:00.2: rerouting interrupts for [8086:032a]
pci 0000:10:01.0: Boot video device
PCI: CLS 64 bytes, default 64
Trying to unpack rootfs image as initramfs...
Freeing initrd memory: 19652k freed
PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Placing 64MB software IO TLB between ffff880002665000 - ffff880006665000
software IO TLB at phys 0x2665000 - 0x6665000
audit: initializing netlink socket (disabled)
type=2000 audit(1275553738.700:1): initialized
HugeTLB registered 2 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
msgmni has been set to 32768
SELinux:  Registering netfilter hooks
alg: No test for stdrng (krng)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
pcieport 0000:00:01.0: setting latency timer to 64
  alloc irq_desc for 72 on node -1
  alloc kstat_irqs on node -1
pcieport 0000:00:01.0: irq 72 for MSI/MSI-X
pcieport 0000:00:02.0: setting latency timer to 64
  alloc irq_desc for 73 on node -1
  alloc kstat_irqs on node -1
pcieport 0000:00:02.0: irq 73 for MSI/MSI-X
pcieport 0000:00:03.0: setting latency timer to 64
  alloc irq_desc for 74 on node -1
  alloc kstat_irqs on node -1
pcieport 0000:00:03.0: irq 74 for MSI/MSI-X
pcieport 0000:00:04.0: setting latency timer to 64
  alloc irq_desc for 75 on node -1
  alloc kstat_irqs on node -1
pcieport 0000:00:04.0: irq 75 for MSI/MSI-X
pcieport 0000:00:05.0: setting latency timer to 64
  alloc irq_desc for 76 on node -1
  alloc kstat_irqs on node -1
pcieport 0000:00:05.0: irq 76 for MSI/MSI-X
pcieport 0000:00:06.0: setting latency timer to 64
  alloc irq_desc for 77 on node -1
  alloc kstat_irqs on node -1
pcieport 0000:00:06.0: irq 77 for MSI/MSI-X
pcieport 0000:00:07.0: setting latency timer to 64
  alloc irq_desc for 78 on node -1
  alloc kstat_irqs on node -1
pcieport 0000:00:07.0: irq 78 for MSI/MSI-X
pcieport 0000:00:08.0: setting latency timer to 64
  alloc irq_desc for 79 on node -1
  alloc kstat_irqs on node -1
pcieport 0000:00:08.0: irq 79 for MSI/MSI-X
pcieport 0000:00:09.0: setting latency timer to 64
  alloc irq_desc for 80 on node -1
  alloc kstat_irqs on node -1
pcieport 0000:00:09.0: irq 80 for MSI/MSI-X
pcieport 0000:00:0a.0: setting latency timer to 64
  alloc irq_desc for 81 on node -1
  alloc kstat_irqs on node -1
pcieport 0000:00:0a.0: irq 81 for MSI/MSI-X
pcieport 0000:00:1c.0: setting latency timer to 64
  alloc irq_desc for 82 on node -1
  alloc kstat_irqs on node -1
pcieport 0000:00:1c.0: irq 82 for MSI/MSI-X
pcieport 0000:00:1c.4: setting latency timer to 64
  alloc irq_desc for 83 on node -1
  alloc kstat_irqs on node -1
pcieport 0000:00:1c.4: irq 83 for MSI/MSI-X
aer 0000:00:01.0:pcie02: service driver aer loaded
aer 0000:00:02.0:pcie02: service driver aer loaded
aer 0000:00:03.0:pcie02: service driver aer loaded
aer 0000:00:04.0:pcie02: service driver aer loaded
aer 0000:00:05.0:pcie02: service driver aer loaded
aer 0000:00:06.0:pcie02: service driver aer loaded
aer 0000:00:07.0:pcie02: service driver aer loaded
aer 0000:00:08.0:pcie02: service driver aer loaded
aer 0000:00:09.0:pcie02: service driver aer loaded
aer 0000:00:0a.0:pcie02: service driver aer loaded
pcieport 0000:00:01.0: Requesting control of PCIe PME from ACPI BIOS
pcieport 0000:00:01.0: Signaling PME through PCIe PME interrupt
pci 0000:01:00.0: Signaling PME through PCIe PME interrupt
pci 0000:01:00.1: Signaling PME through PCIe PME interrupt
pcie_pme 0000:00:01.0:pcie01: service driver pcie_pme loaded
pcieport 0000:00:02.0: Requesting control of PCIe PME from ACPI BIOS
pcieport 0000:00:02.0: Signaling PME through PCIe PME interrupt
pcie_pme 0000:00:02.0:pcie01: service driver pcie_pme loaded
pcieport 0000:00:03.0: Requesting control of PCIe PME from ACPI BIOS
pcieport 0000:00:03.0: Signaling PME through PCIe PME interrupt
pcie_pme 0000:00:03.0:pcie01: service driver pcie_pme loaded
pcieport 0000:00:04.0: Requesting control of PCIe PME from ACPI BIOS
pcieport 0000:00:04.0: Signaling PME through PCIe PME interrupt
pcie_pme 0000:00:04.0:pcie01: service driver pcie_pme loaded
pcieport 0000:00:05.0: Requesting control of PCIe PME from ACPI BIOS
pcieport 0000:00:05.0: Signaling PME through PCIe PME interrupt
pcie_pme 0000:00:05.0:pcie01: service driver pcie_pme loaded
pcieport 0000:00:06.0: Requesting control of PCIe PME from ACPI BIOS
pcieport 0000:00:06.0: Signaling PME through PCIe PME interrupt
pcie_pme 0000:00:06.0:pcie01: service driver pcie_pme loaded
pcieport 0000:00:07.0: Requesting control of PCIe PME from ACPI BIOS
pcieport 0000:00:07.0: Signaling PME through PCIe PME interrupt
pcie_pme 0000:00:07.0:pcie01: service driver pcie_pme loaded
pcieport 0000:00:08.0: Requesting control of PCIe PME from ACPI BIOS
pcieport 0000:00:08.0: Signaling PME through PCIe PME interrupt
pcie_pme 0000:00:08.0:pcie01: service driver pcie_pme loaded
pcieport 0000:00:09.0: Requesting control of PCIe PME from ACPI BIOS
pcieport 0000:00:09.0: Signaling PME through PCIe PME interrupt
pci 0000:0a:00.0: Signaling PME through PCIe PME interrupt
pci 0000:0a:00.2: Signaling PME through PCIe PME interrupt
pcie_pme 0000:00:09.0:pcie01: service driver pcie_pme loaded
pcieport 0000:00:0a.0: Requesting control of PCIe PME from ACPI BIOS
pcieport 0000:00:0a.0: Signaling PME through PCIe PME interrupt
pcie_pme 0000:00:0a.0:pcie01: service driver pcie_pme loaded
pcieport 0000:00:1c.0: Requesting control of PCIe PME from ACPI BIOS
pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
pcieport 0000:00:1c.4: Requesting control of PCIe PME from ACPI BIOS
pcieport 0000:00:1c.4: Signaling PME through PCIe PME interrupt
pci 0000:0f:00.0: Signaling PME through PCIe PME interrupt
pcie_pme 0000:00:1c.4:pcie01: service driver pcie_pme loaded
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
pciehp 0000:00:1c.0:pcie04: HPC vendor_id 8086 device_id 3a40 ss_vid
15d9 ss_did 10a7
pciehp 0000:00:1c.0:pcie04: service driver pciehp loaded
pciehp 0000:00:1c.4:pcie04: HPC vendor_id 8086 device_id 3a48 ss_vid
15d9 ss_did 10a7
pciehp 0000:00:1c.4:pcie04: service driver pciehp loaded
pciehp: PCI Express Hot Plug Controller Driver version: 0.4
acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
pci-stub: invalid id string ""
input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input0
ACPI: Sleep Button [SLPB]
input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input1
ACPI: Power Button [PWRB]
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
ACPI: Power Button [PWRF]
Monitor-Mwait will be used to enter C-3 state
Monitor-Mwait will be used to enter C-3 state
Non-volatile memory driver v1.3
Linux agpgart interface v0.103
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:06: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
brd: module loaded
loop: module loaded
Fixed MDIO Bus: probed
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
  alloc irq_desc for 18 on node -1
  alloc kstat_irqs on node -1
ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
ehci_hcd 0000:00:1a.7: setting latency timer to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1a.7: debug port 1
ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
ehci_hcd 0000:00:1a.7: irq 18, io mem 0xfbf02000
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.34-rc7 ehci_hcd
usb usb1: SerialNumber: 0000:00:1a.7
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 6 ports detected
  alloc irq_desc for 23 on node -1
  alloc kstat_irqs on node -1
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfbf01000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: EHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.34-rc7 ehci_hcd
usb usb2: SerialNumber: 0000:00:1d.7
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 6 ports detected
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1a.0: setting latency timer to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000f0c0
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.34-rc7 uhci_hcd
usb usb3: SerialNumber: 0000:00:1a.0
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
  alloc irq_desc for 19 on node -1
  alloc kstat_irqs on node -1
uhci_hcd 0000:00:1a.2: PCI INT D -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1a.2: setting latency timer to 64
uhci_hcd 0000:00:1a.2: UHCI Host Controller
uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1a.2: irq 19, io base 0x0000f0a0
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.34-rc7 uhci_hcd
usb usb4: SerialNumber: 0000:00:1a.2
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000f080
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.34-rc7 uhci_hcd
usb usb5: SerialNumber: 0000:00:1d.0
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000f060
usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb6: Product: UHCI Host Controller
usb usb6: Manufacturer: Linux 2.6.34-rc7 uhci_hcd
usb usb6: SerialNumber: 0000:00:1d.1
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000f040
usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
usb 1-5: new high speed USB device using ehci_hcd and address 2
usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb7: Product: UHCI Host Controller
usb usb7: Manufacturer: Linux 2.6.34-rc7 uhci_hcd
usb usb7: SerialNumber: 0000:00:1d.2
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 2 ports detected
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
rtc_cmos 00:08: RTC can wake from S4
rtc_cmos 00:08: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one year, y3k, 114 bytes nvram, hpet irqs
cpuidle: using governor ladder
cpuidle: using governor menu
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
nf_conntrack.acct=1 kernel parameter, acct=1 nf_conntrack module option or
sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
ip_tables: (C) 2000-2006 Netfilter Core Team
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 17
registered taskstats version 1
No TPM chip found, activating TPM-bypass!
rtc_cmos 00:08: setting system clock to 2010-06-03 08:29:01 UTC (1275553741)
Initalizing network drop monitor service
usb 1-5: New USB device found, idVendor=14dd, idProduct=0002
usb 1-5: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-5: Product: Multidevice
usb 1-5: Manufacturer: Peppercon AG
usb 1-5: SerialNumber: 0163a4019e487fc814E72156DB3AC4FA
Freeing unused kernel memory: 1428k freed
Write protecting the kernel read-only data: 10240k
input: Peppercon AG Multidevice as
/devices/pci0000:00/0000:00:1a.7/usb1/1-5/1-5:1.1/input/input3
generic-usb 0003:14DD:0002.0001: input,hidraw0: USB HID v1.01 Mouse
[Peppercon AG Multidevice] on usb-0000:00:1a.7-5/input1
Freeing unused kernel memory: 1356k freed
input: Peppercon AG Multidevice as
/devices/pci0000:00/0000:00:1a.7/usb1/1-5/1-5:1.2/input/input4
Freeing unused kernel memory: 1848k freed
generic-usb 0003:14DD:0002.0002: input,hidraw1: USB HID v1.01 Keyboard
[Peppercon AG Multidevice] on usb-0000:00:1a.7-5/input2
dracut: dracut-004-19.el6
dracut: rd_NO_LUKS: removing cryptoluks activation
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.17.0-ioctl (2010-03-05) initialised: dm-devel@redhat.com
udev: starting version 147
[drm] Initialized drm 1.1.0 20060810
[drm] radeon defaulting to kernel modesetting.
[drm] radeon kernel modesetting enabled.
radeon 0000:10:01.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[drm] initializing kernel modesetting (RV100 0x1002:0x515E).
[drm] register mmio base: 0xFBD20000
[drm] register mmio size: 65536
[drm] GPU reset succeed (RBBM_STATUS=0x00000140)
[drm] 1 Power State(s)
[drm] State 0 Default (default)
[drm] 	1 Clock Mode(s)
[drm] 		0 engine/memory: 200000/200000
[drm] radeon: power management initialized
radeon 0000:10:01.0: VRAM: 64M 0xF0000000 - 0xF3FFFFFF (32M used)
radeon 0000:10:01.0: GTT: 512M 0xD0000000 - 0xEFFFFFFF
[drm] radeon: irq initialized.
[drm] Detected VRAM RAM=64M, BAR=128M
[drm] RAM width 16bits DDR
[TTM] Zone  kernel: Available graphics memory: 9260658 kiB.
[TTM] Zone   dma32: Available graphics memory: 2097152 kiB.
[drm] radeon: 32M of VRAM memory ready
[drm] radeon: 512M of GTT memory ready.
[drm] GART: num cpu pages 131072, num gpu pages 131072
[drm] radeon: cp idle (0x00008080)
[drm] Loading R100 Microcode
platform radeon_cp.0: firmware: requesting radeon/R100_cp.bin
[drm] radeon: ring at 0x00000000D0000000
[drm] ring test succeeded in 1 usecs
[drm] radeon: ib pool ready.
[drm] ib test succeeded in 0 usecs
[drm] No TV DAC info found in BIOS
[drm] No valid Ext TMDS info found in BIOS
[drm] Radeon Display Connectors
[drm] Connector 0:
[drm]   VGA
[drm]   DDC: 0x60 0x60 0x60 0x60 0x60 0x60 0x60 0x60
[drm]   Encoders:
[drm]     CRT1: INTERNAL_DAC1
[drm] Connector 1:
[drm]   DVI-I
[drm]   HPD2
[drm]   DDC: 0x6c 0x6c 0x6c 0x6c 0x6c 0x6c 0x6c 0x6c
[drm]   Encoders:
[drm]     CRT2: INTERNAL_DAC2
[drm]     DFP2: INTERNAL_DVO1
[drm] fb mappable at 0xF0040000
[drm] vram apper at 0xF0000000
[drm] size 786432
[drm] fb depth is 8
[drm]    pitch is 1024
fbcon: radeondrmfb (fb0) is primary device
Console: switching to colour frame buffer device 128x48
fb0: radeondrmfb frame buffer device
registered panic notifier
[drm] Initialized radeon 2.3.0 20080528 for 0000:10:01.0 on minor 0
dracut: Starting plymouth daemon
pata_jmicron 0000:0f:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
ahci 0000:00:1f.2: version 3.0
ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
Initializing USB Mass Storage driver...
scsi0 : usb-storage 1-5:1.0
  alloc irq_desc for 84 on node -1
  alloc kstat_irqs on node -1
ahci 0000:00:1f.2: irq 84 for MSI/MSI-X
pata_jmicron 0000:0f:00.0: setting latency timer to 64
ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
scsi1 : pata_jmicron
scsi2 : pata_jmicron
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
ata1: PATA max UDMA/100 cmd 0xd040 ctl 0xd030 bmdma 0xd000 irq 16
ata2: PATA max UDMA/100 cmd 0xd020 ctl 0xd010 bmdma 0xd008 irq 16
ahci 0000:00:1f.2: flags: 64bit ncq sntf led clo pio slum part ccc ems sxs
ahci 0000:00:1f.2: setting latency timer to 64
scsi3 : ahci
scsi4 : ahci
scsi5 : ahci
scsi6 : ahci
scsi7 : ahci
scsi8 : ahci
ata3: SATA max UDMA/133 irq_stat 0x00400040, connection status changed irq 84
ata4: SATA max UDMA/133 abar m2048@0xfbf00000 port 0xfbf00180 irq 84
ata5: SATA max UDMA/133 abar m2048@0xfbf00000 port 0xfbf00200 irq 84
ata6: SATA max UDMA/133 abar m2048@0xfbf00000 port 0xfbf00280 irq 84
ata7: SATA max UDMA/133 abar m2048@0xfbf00000 port 0xfbf00300 irq 84
ata8: SATA max UDMA/133 irq_stat 0x00400040, connection status changed irq 84
CE: hpet increased min_delta_ns to 7500 nsec
ata4: SATA link down (SStatus 0 SControl 300)
ata6: SATA link down (SStatus 0 SControl 300)
ata7: SATA link down (SStatus 0 SControl 300)
ata5: SATA link down (SStatus 0 SControl 300)
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata3.00: ATA-6: ST3500320NS, SN04, max UDMA/133
ata3.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata3.00: configured for UDMA/133
scsi 3:0:0:0: Direct-Access     ATA      ST3500320NS      SN04 PQ: 0 ANSI: 5
ata8: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata8.00: ATAPI: SlimtypeDVD A  DS8A1P, CX17, max UDMA/33
ata8.00: applying bridge limits
ata8.00: configured for UDMA/33
scsi 0:0:0:0: CD-ROM            PepperC  Virtual Disc 1   0.01 PQ: 0 ANSI: 3
scsi 8:0:0:0: CD-ROM            Slimtype DVD A  DS8A1P    CX17 PQ: 0 ANSI: 5
sr0: scsi-1 drive
sd 3:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
sd 3:0:0:0: [sda] Write Protect is off
sd 3:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sda: sda1 sda2
Uniform CD-ROM driver Revision: 3.20
sd 3:0:0:0: [sda] Attached SCSI disk
sr 0:0:0:0: Attached scsi CD-ROM sr0
sr1: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
sr 8:0:0:0: Attached scsi CD-ROM sr1
dracut: Scanning devices sda2  for LVM logical volumes
vg_intels3ea209/lv_root vg_intels3ea209/lv_swap
dracut: inactive '/dev/vg_intels3ea209/lv_root' [50.00 GiB] inherit
dracut: inactive '/dev/vg_intels3ea209/lv_home' [395.60 GiB] inherit
dracut: inactive '/dev/vg_intels3ea209/lv_swap' [19.67 GiB] inherit
EXT4-fs (dm-0): mounted filesystem with ordered data mode
dracut: Mounted root filesystem /dev/mapper/vg_intels3ea209-lv_root
dracut: Loading SELinux policy
type=1404 audit(1275553744.812:2): enforcing=1 old_enforcing=0
auid=4294967295 ses=4294967295
SELinux: 2048 avtab hash slots, 196492 rules.
SELinux: 2048 avtab hash slots, 196492 rules.
SELinux:  9 users, 13 roles, 3237 types, 157 bools, 1 sens, 1024 cats
SELinux:  77 classes, 196492 rules
SELinux:  Completing initialization.
SELinux:  Setting up existing superblocks.
SELinux: initialized (dev dm-0, type ext4), uses xattr
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
SELinux: initialized (dev securityfs, type securityfs), uses genfs_contexts
SELinux: initialized (dev usbfs, type usbfs), uses genfs_contexts
SELinux: initialized (dev selinuxfs, type selinuxfs), uses genfs_contexts
SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses transition SIDs
SELinux: initialized (dev devpts, type devpts), uses transition SIDs
SELinux: initialized (dev anon_inodefs, type anon_inodefs), uses genfs_contexts
SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
SELinux: initialized (dev debugfs, type debugfs), uses genfs_contexts
SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
SELinux: initialized (dev devtmpfs, type devtmpfs), uses transition SIDs
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
SELinux: initialized (dev proc, type proc), uses genfs_contexts
SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
type=1403 audit(1275553745.123:3): policy loaded auid=4294967295 ses=4294967295
dracut: Switching root
readahead: starting
udev: starting version 147
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
input: PC Speaker as /devices/platform/pcspkr/input/input5

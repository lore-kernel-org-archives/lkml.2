Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896Ab0LIMlp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 07:41:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60149 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755075Ab0LIMlk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 07:41:40 -0500
Date: Thu, 9 Dec 2010 13:41:19 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Maxim Uvarov <muvarov@gmail.com>,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        Neil Horman <nhorman@redhat.com>
Subject: Re: kdump broken on 2.6.37-rc4
Message-ID: <20101209124117.GA6032@redhat.com>
References: <20101203111623.GA2741@redhat.com>
 <AANLkTi=Xvbi5M_cNRL=wC+uwksG08SiCyWcqdmwB_5TU@mail.gmail.com>
 <20101203171147.GA2299@redhat.com>
 <20101203175401.GE28603@hmsreliant.think-freely.org>
 <20101207105053.GA2803@redhat.com>
 <4CFE89FE.1090901@kernel.org>
 <20101208141942.GA2335@redhat.com>
 <4D00823A.9050808@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="PNTmBPCT7hxwcZjr"
Content-Disposition: inline
In-Reply-To: <4D00823A.9050808@kernel.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 08, 2010 at 11:16:10PM -0800, Yinghai Lu wrote:
> >> please check debug patches, and boot first kernel and kexec second kernel with "ignore_loglevel debug earlyprintk...."
> > 
> > Second kernel does not print anything, so maybe it not even start.
> > Dmesg from primary kernel attached.
> > 
> > Stanislaw
> 
> 
> please try attached debug patch.

With debug patch kdump kernel boot. Dmesg's from kdump and 
primary kernel in attachment.

Stanislaw

--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="t60_kdump.dmesg"

    memblock_x86_reserve_range: [0x00001000-0x00001fff]    EX TRAMPOLINE
    memblock_x86_reserve_range: [0x02400000-0x032ccaa7]    TEXT DATA BSS
    memblock_x86_reserve_range: [0x09b1b000-0x09f4efff]          RAMDISK
    memblock_x86_reserve_range: [0x0009f000-0x000fffff]  * BIOS reserved
Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 2.6.37-rc4+ (stasiu@dhcp-27-172.brq.redhat.com) (gcc version 4.4.4 20100726 (Red Hat 4.4.4-13) (GCC) ) #22 SMP Thu Dec 9 10:08:46 CET 2010
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000100 - 000000000009f000 (usable)
 BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000d2000 - 00000000000d4000 (reserved)
 BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007f6d0000 (usable)
 BIOS-e820: 000000007f6d0000 - 000000007f6df000 (ACPI data)
 BIOS-e820: 000000007f6df000 - 000000007f700000 (ACPI NVS)
 BIOS-e820: 000000007f700000 - 0000000080000000 (reserved)
 BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
 BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
 BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ff800000 - 0000000100000000 (reserved)
debug: ignoring loglevel setting.
debug: ignoring loglevel setting.
last_pfn = 0x7f6d0 max_arch_pfn = 0x1000000
NX (Execute Disable) protection: active
user-defined physical RAM map:
 user: 0000000000000000 - 00000000000a0000 (usable)
 user: 00000000000d2000 - 00000000000d4000 (reserved)
 user: 00000000000dc000 - 0000000000100000 (reserved)
 user: 0000000002000000 - 0000000009f5a000 (usable)
 user: 0000000009f5a400 - 0000000009f5f000 (usable)
 user: 0000000009fff000 - 000000000a000000 (usable)
 user: 000000007f6d0000 - 000000007f700000 (ACPI data)
 user: 000000007f700000 - 0000000080000000 (reserved)
 user: 00000000f0000000 - 00000000f4000000 (reserved)
 user: 00000000fec00000 - 00000000fec10000 (reserved)
 user: 00000000fed00000 - 00000000fed00400 (reserved)
 user: 00000000fed14000 - 00000000fed1a000 (reserved)
 user: 00000000fed1c000 - 00000000fed90000 (reserved)
 user: 00000000fee00000 - 00000000fee01000 (reserved)
 user: 00000000ff800000 - 0000000100000000 (reserved)
DMI present.
DMI: 6369CTO/6369CTO, BIOS 7IET32WW (1.13 ) 02/05/2008
e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
last_pfn = 0xa000 max_arch_pfn = 0x1000000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-CFFFF write-protect
  D0000-DBFFF uncachable
  DC000-DFFFF write-back
  E0000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 000000000 mask F80000000 write-back
  1 base 07F700000 mask FFFF00000 uncachable
  2 base 07F800000 mask FFF800000 uncachable
  3 base 0D0000000 mask FF0000000 write-combining
  4 disabled
  5 disabled
  6 disabled
  7 disabled
x86 PAT enabled: cpu 0, old 0x7010600070106, new 0x7010600070106
found SMP MP-table at [c00f6810] f6810
    memblock_x86_reserve_range: [0x000f6810-0x000f681f]   * MP-table mpf
    memblock_x86_reserve_range: [0x0009f5a1-0x0009f6b4]   * MP-table mpc
    memblock_x86_reserve_range: [0x032cd000-0x032e9137]              BRK
MEMBLOCK configuration:
 memory size = 0x7fefc00
 memory.cnt  = 0x4
 memory[0x0]	[0x00000000010000-0x0000000009ffff], 0x90000 bytes
 memory[0x1]	[0x00000002000000-0x00000009f59fff], 0x7f5a000 bytes
 memory[0x2]	[0x00000009f5a400-0x00000009f5efff], 0x4c00 bytes
 memory[0x3]	[0x00000009fff000-0x00000009ffffff], 0x1000 bytes
 reserved.cnt  = 0x7
 reserved[0x0]	[0x00000000001000-0x00000000001fff], 0x1000 bytes
 reserved[0x1]	[0x0000000009f000-0x000000000fffff], 0x61000 bytes
 reserved[0x2]	[0x0000000009f5a1-0x0000000009f6b4], 0x114 bytes
 reserved[0x3]	[0x000000000f6810-0x000000000f681f], 0x10 bytes
 reserved[0x4]	[0x00000002400000-0x000000032ccaa7], 0xeccaa8 bytes
 reserved[0x5]	[0x000000032cd000-0x000000032e9137], 0x1c138 bytes
 reserved[0x6]	[0x00000009b1b000-0x00000009f4efff], 0x434000 bytes
initial memory mapped : 0 - 03800000
    memblock_x86_reserve_range: [0x00010000-0x00010fff]       TRAMPOLINE
    memblock_x86_reserve_range: [0x00011000-0x00014fff]      ACPI WAKEUP
init_memory_mapping: 0000000000000000-000000000a000000
 0000000000 - 0000200000 page 4k
 0000200000 - 000a000000 page 2M
kernel direct mapping tables up to a000000 @ 15000-1c000
    memblock_x86_reserve_range: [0x00015000-0x00017fff]          PGTABLE
RAMDISK: 09b1b000 - 09f4f000
ACPI: RSDP 000f67e0 00024 (v02 LENOVO)
ACPI: XSDT 7f6d14b0 0008C (v01 LENOVO TP-7I    00001130  LTP 00000000)
ACPI: FACP 7f6d1600 000F4 (v03 LENOVO TP-7I    00001130 LNVO 00000001)
ACPI Warning: 32/64X length mismatch in Gpe1Block: 0/32 (20101013/tbfadt-526)
ACPI Warning: Optional field Gpe1Block has zero address or length: 0x000000000000102C/0x0 (20101013/tbfadt-557)
ACPI: DSDT 7f6d195e 0D2D9 (v01 LENOVO TP-7I    00001130 MSFT 0100000E)
ACPI: FACS 7f6f4000 00040
ACPI: SSDT 7f6d17b4 001AA (v01 LENOVO TP-7I    00001130 MSFT 0100000E)
ACPI: ECDT 7f6dec37 00052 (v01 LENOVO TP-7I    00001130 LNVO 00000001)
ACPI: TCPA 7f6dec89 00032 (v02 LENOVO TP-7I    00001130 LNVO 00000001)
ACPI: APIC 7f6decbb 00068 (v01 LENOVO TP-7I    00001130 LNVO 00000001)
ACPI: MCFG 7f6ded23 0003C (v01 LENOVO TP-7I    00001130 LNVO 00000001)
ACPI: HPET 7f6ded5f 00038 (v01 LENOVO TP-7I    00001130 LNVO 00000001)
ACPI: SLIC 7f6dee62 00176 (v01 LENOVO TP-7I    00001130  LTP 00000000)
ACPI: BOOT 7f6defd8 00028 (v01 LENOVO TP-7I    00001130  LTP 00000001)
ACPI: SSDT 7f6f2697 0025F (v01 LENOVO TP-7I    00001130 INTL 20050513)
ACPI: SSDT 7f6f28f6 000A6 (v01 LENOVO TP-7I    00001130 INTL 20050513)
ACPI: SSDT 7f6f299c 004F7 (v01 LENOVO TP-7I    00001130 INTL 20050513)
ACPI: SSDT 7f6f2e93 001D8 (v01 LENOVO TP-7I    00001130 INTL 20050513)
ACPI: Local APIC address 0xfee00000
0MB HIGHMEM available.
160MB LOWMEM available.
  mapped low ram: 0 - 0a000000
  low ram: 0 - 0a000000
    memblock_x86_reserve_range: [0x02000000-0x02000fff]      pgtable pte
    memblock_x86_reserve_range: [0x02001000-0x020011ff]       usemap_map
    memblock_x86_reserve_range: [0x02001200-0x0200125f]          usermap
    memblock_x86_reserve_range: [0x032ea000-0x036e9fff]   sparse mem_map
       memblock_x86_free_range: [0x02001000-0x020011ff]
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  Normal   0x00001000 -> 0x0000a000
  HighMem  empty
Movable zone start PFN for each node
early_node_map[4] active PFN ranges
    0: 0x00000010 -> 0x000000a0
    0: 0x00002000 -> 0x00009f5a
    0: 0x00009f5b -> 0x00009f5f
    0: 0x00009fff -> 0x0000a000
On node 0 totalpages: 32751
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 112 pages, LIFO batch:0
    memblock_x86_reserve_range: [0x02001280-0x0203127f]            pgdat
  Normal zone: 288 pages used for memmap
  Normal zone: 32319 pages, LIFO batch:7
    memblock_x86_reserve_range: [0x02031280-0x0206127f]            pgdat
Using APIC driver default
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a201 base: 0xfed00000
    memblock_x86_reserve_range: [0x02001000-0x0200102c]         hpet res
SMP: Allowing 2 CPUs, 0 hotplug CPUs
    memblock_x86_reserve_range: [0x02001040-0x0200106e]       ioapic res
nr_irqs_gsi: 40
    memblock_x86_reserve_range: [0x02061280-0x020614bf]   e820 resources
    memblock_x86_reserve_range: [0x02001080-0x020010bf]     firmware map
    memblock_x86_reserve_range: [0x020010c0-0x020010ff]     firmware map
    memblock_x86_reserve_range: [0x02001100-0x0200113f]     firmware map
    memblock_x86_reserve_range: [0x02001140-0x0200117f]     firmware map
    memblock_x86_reserve_range: [0x02001180-0x020011bf]     firmware map
    memblock_x86_reserve_range: [0x020011c0-0x020011ff]     firmware map
    memblock_x86_reserve_range: [0x020614c0-0x020614ff]     firmware map
    memblock_x86_reserve_range: [0x02061500-0x0206153f]     firmware map
    memblock_x86_reserve_range: [0x02061540-0x0206157f]     firmware map
    memblock_x86_reserve_range: [0x02061580-0x020615bf]     firmware map
    memblock_x86_reserve_range: [0x020615c0-0x020615ff]     firmware map
    memblock_x86_reserve_range: [0x02061600-0x0206163f]     firmware map
    memblock_x86_reserve_range: [0x02061640-0x0206167f]     firmware map
    memblock_x86_reserve_range: [0x02061680-0x020616bf]     firmware map
    memblock_x86_reserve_range: [0x020616c0-0x020616ff]     firmware map
    memblock_x86_reserve_range: [0x02061700-0x0206170f]    nosave region
PM: Registered nosave memory: 00000000000a0000 - 00000000000d2000
PM: Registered nosave memory: 00000000000d2000 - 00000000000d4000
PM: Registered nosave memory: 00000000000d4000 - 00000000000dc000
PM: Registered nosave memory: 00000000000dc000 - 0000000000100000
PM: Registered nosave memory: 0000000000100000 - 0000000002000000
    memblock_x86_reserve_range: [0x02061740-0x0206174f]    nosave region
PM: Registered nosave memory: 0000000009f5a000 - 0000000009f5b000
    memblock_x86_reserve_range: [0x02061780-0x0206178f]    nosave region
PM: Registered nosave memory: 0000000009f5f000 - 0000000009fff000
Allocating PCI resources starting at a000000 (gap: a000000:756d0000)
Booting paravirtualized kernel on bare hardware
    memblock_x86_reserve_range: [0x020617c0-0x02061a1c]  saved_command_l
    memblock_x86_reserve_range: [0x02061a40-0x02061c9c]  static_command_
setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:2 nr_node_ids:1
    memblock_x86_reserve_range: [0x02061cc0-0x02062cbf]  pcpu_alloc_info
    memblock_x86_reserve_range: [0x02062cc0-0x02063cbf]        pcpu area
    memblock_x86_reserve_range: [0x03800000-0x03bfffff]       pcpu_alloc
       memblock_x86_free_range: [0x0394d000-0x039fffff]
       memblock_x86_free_range: [0x03b4d000-0x03bfffff]
PERCPU: Embedded 333 pages/cpu @c3800000 s1343296 r0 d20672 u2097152
    memblock_x86_reserve_range: [0x02063cc0-0x02063cc3]  pcpu group_offs
    memblock_x86_reserve_range: [0x02063d00-0x02063d03]  pcpu group_size
    memblock_x86_reserve_range: [0x02063d40-0x02063d47]    pcpu unit_map
    memblock_x86_reserve_range: [0x02063d80-0x02063d87]    pcpu unit_off
pcpu-alloc: s1343296 r0 d20672 u2097152 alloc=1*2097152
pcpu-alloc: [0] 0 [0] 1 
    memblock_x86_reserve_range: [0x02063dc0-0x02063e67]        pcpu slot
    memblock_x86_reserve_range: [0x02063e80-0x02063ee7]  pcpu chunk_stru
       memblock_x86_free_range: [0x02061cc0-0x02062cbf]
       memblock_x86_free_range: [0x02062cc0-0x02063cbf]
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 32431
Kernel command line: ro root=UUID=da6d958d-32d6-43fc-bce2-a19b5f6f9d31 rhgb quiet selinux=0 SYSFONT=latarcyrheb-sun16 LANG=en_US.UTF-8 KEYTABLE=us rdshell ignore_loglevel debug earlyprintk irqpoll maxcpus=1 reset_devices cgroup_disable=memory  ignore_loglevel debug earlyprintk memmap=exactmap memmap=640K@0K memmap=8K$840K memmap=144K$880K memmap=130408K@32768K memmap=19K@163177K memmap=4K@163836K memmap=60K#2087744K memmap=132K#2087804K memmap=9216K$2087936K memmap=65536K$3932160K memmap=64K$4173824K memmap=1K$4174848K memmap=24K$4174928K memmap=464K$4174960K memmap=4K$4175872K memmap=8192K$4186112K elfcorehdr=163176K
Misrouted IRQ fixup and polling support enabled
This may significantly impact system performance
Disabling memory control group subsystem
    memblock_x86_reserve_range: [0x02061cc0-0x020624bf]  large system ha
PID hash table entries: 512 (order: -1, 2048 bytes)
    memblock_x86_reserve_range: [0x02063f00-0x02073eff]  large system ha
Dentry cache hash table entries: 16384 (order: 4, 65536 bytes)
    memblock_x86_reserve_range: [0x02073f00-0x0207beff]  large system ha
Inode-cache hash table entries: 8192 (order: 3, 32768 bytes)
Initializing CPU#0
Subtract (27 early reservations)
  [0000001000-0000001fff]
  [0000010000-0000017fff]
  [000009f000-00000fffff]
  [000009f5a1-000009f6b4]
  [00000f6810-00000f681f]
  [0002000000-000200102c]
  [0002001040-000200106e]
  [0002001080-000200125f]
  [0002001280-000206170f]
  [0002061740-000206174f]
  [0002061780-000206178f]
  [00020617c0-0002061a1c]
  [0002061a40-0002061c9c]
  [0002061cc0-00020624bf]
  [0002063cc0-0002063cc3]
  [0002063d00-0002063d03]
  [0002063d40-0002063d47]
  [0002063d80-0002063d87]
  [0002063dc0-0002063e67]
  [0002063e80-0002063ee7]
  [0002063f00-000207beff]
  [0002400000-00032ccaa7]
  [00032cd000-00032e9137]
  [00032ea000-00036e9fff]
  [0003800000-000394cfff]
  [0003a00000-0003b4cfff]
  [0009b1b000-0009f4efff]
(8 free memory ranges)
       [0x00018000-0x0009efff]
       [0x0207c000-0x023fffff]
       [0x036ea000-0x037fffff]
       [0x0394d000-0x039fffff]
       [0x03b4d000-0x09b1afff]
       [0x09f4f000-0x09f59fff]
       [0x09f5b000-0x09f5efff]
       [0x09fff000-0x09ffffff]
Initializing HighMem for node 0 (00000000:00000000)
Subtract (27 early reservations)
  [0000001000-0000001fff]
  [0000010000-0000017fff]
  [000009f000-00000fffff]
  [000009f5a1-000009f6b4]
  [00000f6810-00000f681f]
  [0002000000-000200102c]
  [0002001040-000200106e]
  [0002001080-000200125f]
  [0002001280-000206170f]
  [0002061740-000206174f]
  [0002061780-000206178f]
  [00020617c0-0002061a1c]
  [0002061a40-0002061c9c]
  [0002061cc0-00020624bf]
  [0002063cc0-0002063cc3]
  [0002063d00-0002063d03]
  [0002063d40-0002063d47]
  [0002063d80-0002063d87]
  [0002063dc0-0002063e67]
  [0002063e80-0002063ee7]
  [0002063f00-000207beff]
  [0002400000-00032ccaa7]
  [00032cd000-00032e9137]
  [00032ea000-00036e9fff]
  [0003800000-000394cfff]
  [0003a00000-0003b4cfff]
  [0009b1b000-0009f4efff]
Memory: 104136k/163840k available (4159k kernel code, 26868k reserved, 2171k data, 1796k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xffa95000 - 0xfffff000   (5544 kB)
    pkmap   : 0xff600000 - 0xff800000   (2048 kB)
    vmalloc : 0xca800000 - 0xff5fe000   ( 845 MB)
    lowmem  : 0xc0000000 - 0xca000000   ( 160 MB)
      .init : 0xc2a2f000 - 0xc2bf0000   (1796 kB)
      .data : 0xc280fc42 - 0xc2a2eb68   (2171 kB)
      .text : 0xc2400000 - 0xc280fc42   (4159 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
Hierarchical RCU implementation.
	RCU-based detection of stalled CPUs is disabled.
NR_IRQS:2304 nr_irqs:512 16
CPU 0 irqstacks, hard=c940a000 soft=c940c000
Extended CMOS year: 2000
Spurious LAPIC timer interrupt on cpu 0
do_IRQ: 0.169 No irq handler for vector (irq -1)
Console: colour VGA+ 80x25
console [tty0] enabled
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:  8
... MAX_LOCK_DEPTH:          48
... MAX_LOCKDEP_KEYS:        8191
... CLASSHASH_SIZE:          4096
... MAX_LOCKDEP_ENTRIES:     16384
... MAX_LOCKDEP_CHAINS:      32768
... CHAINHASH_SIZE:          16384
 memory used by lock dependency info: 3823 kB
 per task-struct memory footprint: 1920 bytes
ODEBUG: 10 of 10 active objects replaced
hpet clockevent registered
Fast TSC calibration using PIT
Detected 1995.203 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 3990.40 BogoMIPS (lpj=1995203)
pid_max: default: 32768 minimum: 301
Security Framework initialized
SELinux:  Disabled at boot.
Mount-cache hash table entries: 512
Initializing cgroup subsys ns
ns_cgroup deprecated: consider using the 'clone_children' flag without the ns_cgroup.
Initializing cgroup subsys cpuacct
Initializing cgroup subsys memory
Initializing cgroup subsys devices
Initializing cgroup subsys freezer
Initializing cgroup subsys net_cls
Initializing cgroup subsys blkio
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 6 MCE banks
CPU0: Thermal monitoring handled by SMI
using mwait in idle threads.
Performance Events: PEBS fmt0-, Core2 events, Intel PMU driver.
PEBS disabled due to CPU errata.
... version:                2
... bit width:              40
... generic registers:      2
... value mask:             000000ffffffffff
... max period:             000000007fffffff
... fixed-purpose events:   3
... event mask:             0000000700000003
lockdep: fixing up alternatives.
SMP alternatives: switching to UP code
ACPI: Core revision 20101013
Enabling APIC mode:  Flat.  Using 1 I/O APICs
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Core(TM)2 CPU         T7200  @ 2.00GHz stepping 06
Brought up 1 CPUs
Total of 1 processors activated (3990.40 BogoMIPS).
devtmpfs: initialized
NET: Registered protocol family 16
ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
ACPI: bus type pci registered
PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf0000000-0xf3ffffff] (base 0xf0000000)
PCI: MMCONFIG at [mem 0xf0000000-0xf3ffffff] reserved in E820
PCI: Using MMCONFIG for extended config space
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: EC: EC description table is found, configuring boot EC
ACPI: SSDT 7f6f1d36 00282 (v01  PmRef  Cpu0Ist 00000100 INTL 20050513)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT   (null) 00282 (v01  PmRef  Cpu0Ist 00000100 INTL 20050513)
ACPI: SSDT 7f6f203d 0065A (v01  PmRef  Cpu0Cst 00000100 INTL 20050513)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT   (null) 0065A (v01  PmRef  Cpu0Cst 00000100 INTL 20050513)
ACPI: SSDT 7f6f1c6e 000C8 (v01  PmRef  Cpu1Ist 00000100 INTL 20050513)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT   (null) 000C8 (v01  PmRef  Cpu1Ist 00000100 INTL 20050513)
ACPI: SSDT 7f6f1fb8 00085 (v01  PmRef  Cpu1Cst 00000100 INTL 20050513)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT   (null) 00085 (v01  PmRef  Cpu1Cst 00000100 INTL 20050513)
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: EC: GPE = 0x1c, I/O: command/status = 0x66, data = 0x62
ACPI: Power Resource [PUBS] (on)
ACPI: ACPI Dock Station Driver: 3 docks/bays found
PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
pci_root PNP0A08:00: host bridge window [mem 0x000d4000-0x000d7fff]
pci_root PNP0A08:00: host bridge window [mem 0x000d8000-0x000dbfff]
pci_root PNP0A08:00: host bridge window [mem 0x80000000-0xfebfffff]
pci_root PNP0A08:00: host bridge window [mem 0xfed40000-0xfed40fff]
pci 0000:00:00.0: [8086:27a0] type 0 class 0x000600
pci 0000:00:02.0: [8086:27a2] type 0 class 0x000300
pci 0000:00:02.0: reg 10: [mem 0xee100000-0xee17ffff]
pci 0000:00:02.0: reg 14: [io  0x1800-0x1807]
pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff pref]
pci 0000:00:02.0: reg 1c: [mem 0xee200000-0xee23ffff]
pci 0000:00:02.1: [8086:27a6] type 0 class 0x000380
pci 0000:00:02.1: reg 10: [mem 0xee180000-0xee1fffff]
pci 0000:00:1b.0: [8086:27d8] type 0 class 0x000403
pci 0000:00:1b.0: reg 10: [mem 0xee240000-0xee243fff 64bit]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: PME# disabled
pci 0000:00:1c.0: [8086:27d0] type 1 class 0x000604
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.1: [8086:27d2] type 1 class 0x000604
pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.1: PME# disabled
pci 0000:00:1c.2: [8086:27d4] type 1 class 0x000604
pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.2: PME# disabled
pci 0000:00:1c.3: [8086:27d6] type 1 class 0x000604
pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.3: PME# disabled
pci 0000:00:1d.0: [8086:27c8] type 0 class 0x000c03
pci 0000:00:1d.0: reg 20: [io  0x1820-0x183f]
pci 0000:00:1d.1: [8086:27c9] type 0 class 0x000c03
pci 0000:00:1d.1: reg 20: [io  0x1840-0x185f]
pci 0000:00:1d.2: [8086:27ca] type 0 class 0x000c03
pci 0000:00:1d.2: reg 20: [io  0x1860-0x187f]
pci 0000:00:1d.3: [8086:27cb] type 0 class 0x000c03
pci 0000:00:1d.3: reg 20: [io  0x1880-0x189f]
pci 0000:00:1d.7: [8086:27cc] type 0 class 0x000c03
pci 0000:00:1d.7: reg 10: [mem 0xee444000-0xee4443ff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1e.0: [8086:2448] type 1 class 0x000604
pci 0000:00:1f.0: [8086:27b9] type 0 class 0x000601
pci 0000:00:1f.0: quirk: [io  0x1000-0x107f] claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: [io  0x1180-0x11bf] claimed by ICH6 GPIO
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 1600 (mask 007f)
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 15e0 (mask 000f)
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 1680 (mask 001f)
pci 0000:00:1f.1: [8086:27df] type 0 class 0x000101
pci 0000:00:1f.1: reg 10: [io  0x0000-0x0007]
pci 0000:00:1f.1: reg 14: [io  0x0000-0x0003]
pci 0000:00:1f.1: reg 18: [io  0x0000-0x0007]
pci 0000:00:1f.1: reg 1c: [io  0x0000-0x0003]
pci 0000:00:1f.1: reg 20: [io  0x1810-0x181f]
pci 0000:00:1f.2: [8086:27c5] type 0 class 0x000106
pci 0000:00:1f.2: reg 10: [io  0x18d0-0x18d7]
pci 0000:00:1f.2: reg 14: [io  0x18c4-0x18c7]
pci 0000:00:1f.2: reg 18: [io  0x18c8-0x18cf]
pci 0000:00:1f.2: reg 1c: [io  0x18c0-0x18c3]
pci 0000:00:1f.2: reg 20: [io  0x18b0-0x18bf]
pci 0000:00:1f.2: reg 24: [mem 0xee444400-0xee4447ff]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.2: PME# disabled
pci 0000:00:1f.3: [8086:27da] type 0 class 0x000c05
pci 0000:00:1f.3: reg 20: [io  0x18e0-0x18ff]
pci 0000:02:00.0: [8086:109a] type 0 class 0x000200
pci 0000:02:00.0: reg 10: [mem 0xee000000-0xee01ffff]
pci 0000:02:00.0: reg 18: [io  0x2000-0x201f]
pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
pci 0000:02:00.0: PME# disabled
pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
pci 0000:00:1c.0: PCI bridge to [bus 02-02]
pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
pci 0000:00:1c.0:   bridge window [mem 0xee000000-0xee0fffff]
pci 0000:00:1c.0:   bridge window [mem 0xfea00000-0xfebfffff 64bit pref]
pci 0000:03:00.0: [8086:4227] type 0 class 0x000280
pci 0000:03:00.0: reg 10: [mem 0xedf00000-0xedf00fff]
pci 0000:03:00.0: PME# supported from D0 D3hot
pci 0000:03:00.0: PME# disabled
pci 0000:03:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
pci 0000:00:1c.1: PCI bridge to [bus 03-03]
pci 0000:00:1c.1:   bridge window [io  0x3000-0x4fff]
pci 0000:00:1c.1:   bridge window [mem 0xec000000-0xedffffff]
pci 0000:00:1c.1:   bridge window [mem 0xe4000000-0xe40fffff 64bit pref]
pci 0000:00:1c.2: PCI bridge to [bus 04-0b]
pci 0000:00:1c.2:   bridge window [io  0x5000-0x6fff]
pci 0000:00:1c.2:   bridge window [mem 0xe8000000-0xe9ffffff]
pci 0000:00:1c.2:   bridge window [mem 0xe4100000-0xe41fffff 64bit pref]
pci 0000:00:1c.3: PCI bridge to [bus 0c-13]
pci 0000:00:1c.3:   bridge window [io  0x7000-0x8fff]
pci 0000:00:1c.3:   bridge window [mem 0xea000000-0xebffffff]
pci 0000:00:1c.3:   bridge window [mem 0xe4200000-0xe42fffff 64bit pref]
pci 0000:15:00.0: [104c:ac56] type 2 class 0x000607
pci 0000:15:00.0: reg 10: [mem 0xe4300000-0xe4300fff]
pci 0000:15:00.0: supports D1 D2
pci 0000:15:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:15:00.0: PME# disabled
pci 0000:00:1e.0: PCI bridge to [bus 15-18] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0x9000-0xcfff]
pci 0000:00:1e.0:   bridge window [mem 0xe4300000-0xe7ffffff]
pci 0000:00:1e.0:   bridge window [mem 0xe0000000-0xe3ffffff 64bit pref]
pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x80000000-0xfebfffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0xfed40000-0xfed40fff] (subtractive decode)
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: pci_cache_line_size set to 64 bytes
reserve RAM buffer: 0000000009f5a000 - 000000000bffffff 
reserve RAM buffer: 0000000009f5f000 - 000000000bffffff 
reserve RAM buffer: 000000000a000000 - 000000000bffffff 
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
HPET: 3 timers in total, 0 timers will be used for per-cpu timer
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 comparators, 64-bit 14.318180 MHz counter
Switching to clocksource tsc
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp 00:00: [mem 0x00000000-0x0009ffff]
pnp 00:00: [mem 0x000c0000-0x000c3fff]
pnp 00:00: [mem 0x000c4000-0x000c7fff]
pnp 00:00: [mem 0x000c8000-0x000cbfff]
pnp 00:00: [mem 0x000cc000-0x000cffff]
pnp 00:00: [mem 0x000d0000-0x000d3fff]
pnp 00:00: [mem 0x000d4000-0x000d3fff disabled]
pnp 00:00: [mem 0x000d8000-0x000d7fff disabled]
pnp 00:00: [mem 0x000dc000-0x000dffff]
pnp 00:00: [mem 0x000e0000-0x000e3fff]
pnp 00:00: [mem 0x000e4000-0x000e7fff]
pnp 00:00: [mem 0x000e8000-0x000ebfff]
pnp 00:00: [mem 0x000ec000-0x000effff]
pnp 00:00: [mem 0x000f0000-0x000fffff]
pnp 00:00: [mem 0x00100000-0x7fffffff]
pnp 00:00: [mem 0xfec00000-0xfed3ffff]
pnp 00:00: [mem 0xfed41000-0xffffffff]
pnp 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
pnp 00:01: [bus 00-ff]
pnp 00:01: [io  0x0cf8-0x0cff]
pnp 00:01: [io  0x0000-0x0cf7 window]
pnp 00:01: [io  0x0d00-0xffff window]
pnp 00:01: [mem 0x000a0000-0x000bffff window]
pnp 00:01: [mem 0x000c0000-0x000c3fff window]
pnp 00:01: [mem 0x000c4000-0x000c7fff window]
pnp 00:01: [mem 0x000c8000-0x000cbfff window]
pnp 00:01: [mem 0x000cc000-0x000cffff window]
pnp 00:01: [mem 0x000d0000-0x000d3fff window]
pnp 00:01: [mem 0x000d4000-0x000d7fff window]
pnp 00:01: [mem 0x000d8000-0x000dbfff window]
pnp 00:01: [mem 0x000dc000-0x000dffff window]
pnp 00:01: [mem 0x000e0000-0x000e3fff window]
pnp 00:01: [mem 0x000e4000-0x000e7fff window]
pnp 00:01: [mem 0x000e8000-0x000ebfff window]
pnp 00:01: [mem 0x000ec000-0x000effff window]
pnp 00:01: [mem 0x80000000-0xfebfffff window]
pnp 00:01: [mem 0xfed40000-0xfed40fff window]
pnp 00:01: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
pnp 00:02: [io  0x0010-0x001f]
pnp 00:02: [io  0x0090-0x009f]
pnp 00:02: [io  0x0024-0x0025]
pnp 00:02: [io  0x0028-0x0029]
pnp 00:02: [io  0x002c-0x002d]
pnp 00:02: [io  0x0030-0x0031]
pnp 00:02: [io  0x0034-0x0035]
pnp 00:02: [io  0x0038-0x0039]
pnp 00:02: [io  0x003c-0x003d]
pnp 00:02: [io  0x00a4-0x00a5]
pnp 00:02: [io  0x00a8-0x00a9]
pnp 00:02: [io  0x00ac-0x00ad]
pnp 00:02: [io  0x00b0-0x00b5]
pnp 00:02: [io  0x00b8-0x00b9]
pnp 00:02: [io  0x00bc-0x00bd]
pnp 00:02: [io  0x0050-0x0053]
pnp 00:02: [io  0x0072-0x0077]
pnp 00:02: [io  0x164e-0x164f]
pnp 00:02: [io  0x002e-0x002f]
pnp 00:02: [io  0x1000-0x107f]
pnp 00:02: [io  0x1180-0x11bf]
pnp 00:02: [io  0x0800-0x080f]
pnp 00:02: [io  0x15e0-0x15ef]
pnp 00:02: [io  0x1600-0x165f]
pnp 00:02: [mem 0xf0000000-0xf3ffffff]
pnp 00:02: [mem 0xfed1c000-0xfed1ffff]
pnp 00:02: [mem 0xfed14000-0xfed17fff]
pnp 00:02: [mem 0xfed18000-0xfed18fff]
pnp 00:02: [mem 0xfed19000-0xfed19fff]
pnp 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:03: [mem 0xfed00000-0xfed003ff]
pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
pnp 00:04: [io  0x0000-0x000f]
pnp 00:04: [io  0x0080-0x008f]
pnp 00:04: [io  0x00c0-0x00df]
pnp 00:04: [dma 4]
pnp 00:04: Plug and Play ACPI device, IDs PNP0200 (active)
pnp 00:05: [io  0x0061]
pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
pnp 00:06: [io  0x00f0]
pnp 00:06: [irq 13]
pnp 00:06: Plug and Play ACPI device, IDs PNP0c04 (active)
pnp 00:07: [io  0x0070-0x0071]
pnp 00:07: [irq 8]
pnp 00:07: Plug and Play ACPI device, IDs PNP0b00 (active)
pnp 00:08: [io  0x0060]
pnp 00:08: [io  0x0064]
pnp 00:08: [irq 1]
pnp 00:08: Plug and Play ACPI device, IDs PNP0303 (active)
pnp 00:09: [irq 12]
pnp 00:09: Plug and Play ACPI device, IDs IBM0057 PNP0f13 (active)
pnp 00:0a: Plug and Play ACPI device, IDs IBM0071 PNP0511 (disabled)
pnp 00:0b: [mem 0xfed40000-0xfed40fff]
pnp 00:0b: Plug and Play ACPI device, IDs ATM1200 PNP0c31 (active)
pnp: PnP ACPI: found 12 devices
ACPI: ACPI bus type pnp unregistered
system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
system 00:00: [mem 0x000c0000-0x000c3fff] could not be reserved
system 00:00: [mem 0x000c4000-0x000c7fff] could not be reserved
system 00:00: [mem 0x000c8000-0x000cbfff] has been reserved
system 00:00: [mem 0x000cc000-0x000cffff] could not be reserved
system 00:00: [mem 0x000d0000-0x000d3fff] could not be reserved
system 00:00: [mem 0x000dc000-0x000dffff] could not be reserved
system 00:00: [mem 0x000e0000-0x000e3fff] could not be reserved
system 00:00: [mem 0x000e4000-0x000e7fff] could not be reserved
system 00:00: [mem 0x000e8000-0x000ebfff] could not be reserved
system 00:00: [mem 0x000ec000-0x000effff] could not be reserved
system 00:00: [mem 0x000f0000-0x000fffff] could not be reserved
system 00:00: [mem 0x00100000-0x7fffffff] could not be reserved
system 00:00: [mem 0xfec00000-0xfed3ffff] could not be reserved
system 00:00: [mem 0xfed41000-0xffffffff] could not be reserved
system 00:02: [io  0x164e-0x164f] has been reserved
system 00:02: [io  0x1000-0x107f] has been reserved
system 00:02: [io  0x1180-0x11bf] has been reserved
system 00:02: [io  0x0800-0x080f] has been reserved
system 00:02: [io  0x15e0-0x15ef] has been reserved
system 00:02: [io  0x1600-0x165f] could not be reserved
system 00:02: [mem 0xf0000000-0xf3ffffff] has been reserved
system 00:02: [mem 0xfed1c000-0xfed1ffff] has been reserved
system 00:02: [mem 0xfed14000-0xfed17fff] has been reserved
system 00:02: [mem 0xfed18000-0xfed18fff] has been reserved
system 00:02: [mem 0xfed19000-0xfed19fff] has been reserved
pci 0000:00:1c.0: PCI bridge to [bus 02-02]
pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
pci 0000:00:1c.0:   bridge window [mem 0xee000000-0xee0fffff]
pci 0000:00:1c.0:   bridge window [mem 0xfea00000-0xfebfffff 64bit pref]
pci 0000:00:1c.1: PCI bridge to [bus 03-03]
pci 0000:00:1c.1:   bridge window [io  0x3000-0x4fff]
pci 0000:00:1c.1:   bridge window [mem 0xec000000-0xedffffff]
pci 0000:00:1c.1:   bridge window [mem 0xe4000000-0xe40fffff 64bit pref]
pci 0000:00:1c.2: PCI bridge to [bus 04-0b]
pci 0000:00:1c.2:   bridge window [io  0x5000-0x6fff]
pci 0000:00:1c.2:   bridge window [mem 0xe8000000-0xe9ffffff]
pci 0000:00:1c.2:   bridge window [mem 0xe4100000-0xe41fffff 64bit pref]
pci 0000:00:1c.3: PCI bridge to [bus 0c-13]
pci 0000:00:1c.3:   bridge window [io  0x7000-0x8fff]
pci 0000:00:1c.3:   bridge window [mem 0xea000000-0xebffffff]
pci 0000:00:1c.3:   bridge window [mem 0xe4200000-0xe42fffff 64bit pref]
pci 0000:15:00.0: BAR 15: assigned [mem 0xe0000000-0xe3ffffff pref]
pci 0000:15:00.0: BAR 16: assigned [mem 0xf8000000-0xfbffffff]
pci 0000:15:00.0: BAR 13: assigned [io  0xcc00-0xccff]
pci 0000:15:00.0: BAR 14: assigned [io  0xc800-0xc8ff]
pci 0000:15:00.0: CardBus bridge to [bus 16-17]
pci 0000:15:00.0:   bridge window [io  0xcc00-0xccff]
pci 0000:15:00.0:   bridge window [io  0xc800-0xc8ff]
pci 0000:15:00.0:   bridge window [mem 0xe0000000-0xe3ffffff pref]
pci 0000:15:00.0:   bridge window [mem 0xf8000000-0xfbffffff]
pci 0000:00:1e.0: PCI bridge to [bus 15-18]
pci 0000:00:1e.0:   bridge window [io  0x9000-0xcfff]
pci 0000:00:1e.0:   bridge window [mem 0xe4300000-0xe7ffffff]
pci 0000:00:1e.0:   bridge window [mem 0xe0000000-0xe3ffffff 64bit pref]
pci 0000:00:1c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
pci 0000:00:1c.0: setting latency timer to 64
pci 0000:00:1c.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
pci 0000:00:1c.1: setting latency timer to 64
pci 0000:00:1c.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
pci 0000:00:1c.2: setting latency timer to 64
pci 0000:00:1c.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
pci 0000:00:1c.3: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
pci 0000:15:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: resource 7 [mem 0x000d4000-0x000d7fff]
pci_bus 0000:00: resource 8 [mem 0x000d8000-0x000dbfff]
pci_bus 0000:00: resource 9 [mem 0x80000000-0xfebfffff]
pci_bus 0000:00: resource 10 [mem 0xfed40000-0xfed40fff]
pci_bus 0000:02: resource 0 [io  0x2000-0x2fff]
pci_bus 0000:02: resource 1 [mem 0xee000000-0xee0fffff]
pci_bus 0000:02: resource 2 [mem 0xfea00000-0xfebfffff 64bit pref]
pci_bus 0000:03: resource 0 [io  0x3000-0x4fff]
pci_bus 0000:03: resource 1 [mem 0xec000000-0xedffffff]
pci_bus 0000:03: resource 2 [mem 0xe4000000-0xe40fffff 64bit pref]
pci_bus 0000:04: resource 0 [io  0x5000-0x6fff]
pci_bus 0000:04: resource 1 [mem 0xe8000000-0xe9ffffff]
pci_bus 0000:04: resource 2 [mem 0xe4100000-0xe41fffff 64bit pref]
pci_bus 0000:0c: resource 0 [io  0x7000-0x8fff]
pci_bus 0000:0c: resource 1 [mem 0xea000000-0xebffffff]
pci_bus 0000:0c: resource 2 [mem 0xe4200000-0xe42fffff 64bit pref]
pci_bus 0000:15: resource 0 [io  0x9000-0xcfff]
pci_bus 0000:15: resource 1 [mem 0xe4300000-0xe7ffffff]
pci_bus 0000:15: resource 2 [mem 0xe0000000-0xe3ffffff 64bit pref]
pci_bus 0000:15: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:15: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:15: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:15: resource 7 [mem 0x000d4000-0x000d7fff]
pci_bus 0000:15: resource 8 [mem 0x000d8000-0x000dbfff]
pci_bus 0000:15: resource 9 [mem 0x80000000-0xfebfffff]
pci_bus 0000:15: resource 10 [mem 0xfed40000-0xfed40fff]
pci_bus 0000:16: resource 0 [io  0xcc00-0xccff]
pci_bus 0000:16: resource 1 [io  0xc800-0xc8ff]
pci_bus 0000:16: resource 2 [mem 0xe0000000-0xe3ffffff pref]
pci_bus 0000:16: resource 3 [mem 0xf8000000-0xfbffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 1024 (order: 0, 4096 bytes)
TCP established hash table entries: 4096 (order: 3, 32768 bytes)
TCP bind hash table entries: 4096 (order: 5, 180224 bytes)
TCP: Hash tables configured (established 4096 bind 4096)
TCP reno registered
UDP hash table entries: 64 (order: 0, 6144 bytes)
UDP-Lite hash table entries: 64 (order: 0, 6144 bytes)
NET: Registered protocol family 1
pci 0000:00:02.0: Boot video device
PCI: CLS 64 bytes, default 64
Trying to unpack rootfs image as initramfs...
Freeing initrd memory: 4304k freed
DMA-API: preallocated 32768 debug entries
DMA-API: debugging enabled by kernel config
Simple Boot Flag at 0x35 set to 0x1
apm: BIOS not found.
audit: initializing netlink socket (disabled)
type=2000 audit(1291899999.065:1): initialized
HugeTLB registered 2 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
msgmni has been set to 211
cryptomgr_test used greatest stack depth: 7212 bytes left
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
pcieport 0000:00:1c.0: ACPI _OSC control granted for 0x1d
pcieport 0000:00:1c.0: setting latency timer to 64
pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
pcieport 0000:00:1c.1: ACPI _OSC control granted for 0x1d
pcieport 0000:00:1c.1: setting latency timer to 64
pcieport 0000:00:1c.1: irq 41 for MSI/MSI-X
pcieport 0000:00:1c.2: ACPI _OSC control granted for 0x1d
pcieport 0000:00:1c.2: setting latency timer to 64
pcieport 0000:00:1c.2: irq 42 for MSI/MSI-X
pcieport 0000:00:1c.3: ACPI _OSC control granted for 0x1d
pcieport 0000:00:1c.3: setting latency timer to 64
pcieport 0000:00:1c.3: irq 43 for MSI/MSI-X
pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
pci 0000:02:00.0: Signaling PME through PCIe PME interrupt
pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
pcieport 0000:00:1c.1: Signaling PME through PCIe PME interrupt
pci 0000:03:00.0: Signaling PME through PCIe PME interrupt
pcie_pme 0000:00:1c.1:pcie01: service driver pcie_pme loaded
pcieport 0000:00:1c.2: Signaling PME through PCIe PME interrupt
pcie_pme 0000:00:1c.2:pcie01: service driver pcie_pme loaded
pcieport 0000:00:1c.3: Signaling PME through PCIe PME interrupt
pcie_pme 0000:00:1c.3:pcie01: service driver pcie_pme loaded
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
pciehp 0000:00:1c.0:pcie04: HPC vendor_id 8086 device_id 27d0 ss_vid 17aa ss_did 2011
pciehp 0000:00:1c.0:pcie04: service driver pciehp loaded
pciehp 0000:00:1c.1:pcie04: HPC vendor_id 8086 device_id 27d2 ss_vid 17aa ss_did 2011
pciehp 0000:00:1c.1:pcie04: service driver pciehp loaded
pciehp 0000:00:1c.2:pcie04: HPC vendor_id 8086 device_id 27d4 ss_vid 17aa ss_did 2011
pciehp 0000:00:1c.2:pcie04: service driver pciehp loaded
pciehp 0000:00:1c.3:pcie04: HPC vendor_id 8086 device_id 27d6 ss_vid 17aa ss_did 2011
pciehp 0000:00:1c.3:pcie04: service driver pciehp loaded
pciehp: PCI Express Hot Plug Controller Driver version: 0.4
acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
acpiphp_glue: Slot 1 already registered by another hotplug driver
acpiphp_glue: Slot 1 already registered by another hotplug driver
pci-stub: invalid id string ""
ACPI: AC Adapter [AC] (on-line)
input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
ACPI: Lid Switch [LID]
input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input1
ACPI: Sleep Button [SLPB]
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
ACPI: Power Button [PWRF]
ACPI: acpi_idle registered with cpuidle
Monitor-Mwait will be used to enter C-1 state
Monitor-Mwait will be used to enter C-2 state
Monitor-Mwait will be used to enter C-3 state
Marking TSC unstable due to TSC halts in idle
Switching to clocksource hpet
kwatchdog used greatest stack depth: 6940 bytes left
thermal LNXTHERM:00: registered as thermal_zone0
ACPI: Thermal Zone [THM0] (48 C)
thermal LNXTHERM:01: registered as thermal_zone1
ACPI: Thermal Zone [THM1] (48 C)
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Non-volatile memory driver v1.3
Linux agpgart interface v0.103
agpgart-intel 0000:00:00.0: Intel 945GM Chipset
agpgart-intel 0000:00:00.0: detected gtt size: 262144K total, 262144K mappable
agpgart-intel 0000:00:00.0: detected 8192K stolen memory
agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
ACPI: Battery Slot [BAT0] (battery present)
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
brd: module loaded
loop: module loaded
Fixed MDIO Bus: probed
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1d.7: using broken periodic workaround
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
ehci_hcd 0000:00:1d.7: irq 19, io mem 0xee444000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.37-rc4+ ehci_hcd
usb usb1: SerialNumber: 0000:00:1d.7
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: irq 16, io base 0x00001820
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: UHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.37-rc4+ uhci_hcd
usb usb2: SerialNumber: 0000:00:1d.0
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: irq 17, io base 0x00001840
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.37-rc4+ uhci_hcd
usb usb3: SerialNumber: 0000:00:1d.1
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.2: power state changed by ACPI to D0
uhci_hcd 0000:00:1d.2: power state changed by ACPI to D0
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001860
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.37-rc4+ uhci_hcd
usb usb4: SerialNumber: 0000:00:1d.2
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1d.3: setting latency timer to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.3: irq 19, io base 0x00001880
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.37-rc4+ uhci_hcd
usb usb5: SerialNumber: 0000:00:1d.3
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
rtc_cmos 00:07: RTC can wake from S4
rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
cpuidle: using governor ladder
cpuidle: using governor menu
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 17
Registering the dns_resolver key type
Using IPI No-Shortcut mode
registered taskstats version 1
IMA: No TPM chip found, activating TPM-bypass!
rtc_cmos 00:07: setting system clock to 2010-12-09 13:06:40 UTC (1291900000)
Initalizing network drop monitor service
Freeing unused kernel memory: 1796k freed
mount used greatest stack depth: 6500 bytes left
mknod used greatest stack depth: 6376 bytes left
display_mem_usa used greatest stack depth: 6348 bytes left
handle_event used greatest stack depth: 6272 bytes left
fuse init (API version 7.15)
handle_event used greatest stack depth: 6268 bytes left
insmod used greatest stack depth: 6204 bytes left
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
handle_event used greatest stack depth: 6000 bytes left
iTCO_vendor_support: vendor-support=0
cfg80211: Calling CRDA to update world regulatory domain
e1000e: Intel(R) PRO/1000 Network Driver - 1.2.7-k2
e1000e: Copyright (c) 1999 - 2010 Intel Corporation.
e1000e 0000:02:00.0: Disabling ASPM  L1
e1000e 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
e1000e 0000:02:00.0: setting latency timer to 64
e1000e 0000:02:00.0: irq 44 for MSI/MSI-X
e1000e 0000:02:00.0: Disabling ASPM L0s 
e1000e 0000:02:00.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:1e:37:23:c6:16
e1000e 0000:02:00.0: eth0: Intel(R) PRO/1000 Network Connection
e1000e 0000:02:00.0: eth0: MAC: 2, PHY: 2, PBA No: 005301-003
insmod used greatest stack depth: 5856 bytes left
yenta_cardbus 0000:15:00.0: CardBus bridge found [17aa:2012]
yenta_cardbus 0000:15:00.0: Using INTVAL to route CSC interrupts to PCI
yenta_cardbus 0000:15:00.0: Routing CardBus interrupts to PCI
yenta_cardbus 0000:15:00.0: TI: mfunc 0x01d01002, devctl 0x64
usb 5-1: new full speed USB device using uhci_hcd and address 2
Synaptics Touchpad, model: 1, fw: 6.2, id: 0x81a0b1, caps: 0xa04793/0x300000/0x0
serio: Synaptics pass-through port at isa0060/serio1/input0
yenta_cardbus 0000:15:00.0: ISA IRQ mask 0x0cf8, PCI irq 16
yenta_cardbus 0000:15:00.0: Socket status: 30000007
yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge window: [io  0x9000-0xcfff]
pcmcia_socket pcmcia_socket0: cs: IO port probe 0x9000-0xcfff:
usb 5-1: New USB device found, idVendor=0a5c, idProduct=2110
usb 5-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 5-1: Product: BCM2045B
usb 5-1: Manufacturer: Broadcom Corp
input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input4
 excluding 0xc800-0xc8ff 0xcc00-0xccff
yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge window: [mem 0xe4300000-0xe7ffffff]
pcmcia_socket pcmcia_socket0: cs: memory probe 0xe4300000-0xe7ffffff: excluding 0xe4300000-0xe46cffff
yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge window: [mem 0xe0000000-0xe3ffffff 64bit pref]
pcmcia_socket pcmcia_socket0: cs: memory probe 0xe0000000-0xe3ffffff: excluding 0xe0000000-0xe3ffffff
pata_acpi 0000:00:1f.1: PCI INT C -> GSI 16 (level, low) -> IRQ 16
pata_acpi 0000:00:1f.1: setting latency timer to 64
pata_acpi 0000:00:1f.1: PCI INT C disabled
ata_piix 0000:00:1f.1: version 2.13
ata_piix 0000:00:1f.1: PCI INT C -> GSI 16 (level, low) -> IRQ 16
ata_piix 0000:00:1f.1: setting latency timer to 64
scsi0 : ata_piix
scsi1 : ata_piix
ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x1810 irq 14
ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x1818 irq 15
ata2: port disabled. ignoring.
usb 5-2: new full speed USB device using uhci_hcd and address 3
ata1.00: ATAPI: HL-DT-ST DVDRAM GSA-4083N, 1.00, max UDMA/33
ata1.00: configured for UDMA/33
scsi 0:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-4083N 1.00 PQ: 0 ANSI: 5
scsi 0:0:0:0: Attached scsi generic sg0 type 5
insmod used greatest stack depth: 5820 bytes left
insmod used greatest stack depth: 5700 bytes left
thinkpad_acpi: ThinkPad ACPI Extras v0.24
thinkpad_acpi: http://ibm-acpi.sf.net/
thinkpad_acpi: ThinkPad BIOS 7IET32WW (1.13 ), EC 79HT50WW-1.07
thinkpad_acpi: Lenovo ThinkPad T60, model 6369CTO
thinkpad_acpi: WARNING: Outdated ThinkPad BIOS/EC firmware
thinkpad_acpi: WARNING: This firmware may be missing critical bug fixes and/or important features
thinkpad_acpi: detected a 8-level brightness capable ThinkPad
thinkpad_acpi: radio switch found; radios are enabled
thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio is unblocked
Registered led device: tpacpi::thinklight
Registered led device: tpacpi::power
Registered led device: tpacpi::standby
usb 5-2: New USB device found, idVendor=0483, idProduct=2016
usb 5-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 5-2: Product: Biometric Coprocessor
usb 5-2: Manufacturer: STMicroelectronics
Registered led device: tpacpi::thinkvantage
thinkpad_acpi: Standard ACPI backlight interface available, not loading native one.
thinkpad_acpi: volume: disabled as there is no ALSA support in this kernel
input: ThinkPad Extra Buttons as /devices/platform/thinkpad_acpi/input/input5
i801_smbus 0000:00:1f.3: PCI INT A -> GSI 23 (level, low) -> IRQ 23
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.06
iTCO_wdt: Found a ICH7-M or ICH7-U TCO device (Version=2, TCOBASE=0x1060)
iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
cdrom: Uniform CD-ROM driver Revision: 3.20
sr 0:0:0:0: Attached scsi CD-ROM sr0
ahci 0000:00:1f.2: version 3.0
ahci 0000:00:1f.2: PCI INT B -> GSI 16 (level, low) -> IRQ 16
ahci 0000:00:1f.2: irq 45 for MSI/MSI-X
ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 1.5 Gbps 0x1 impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum part 
ahci 0000:00:1f.2: setting latency timer to 64
scsi2 : ahci
scsi3 : ahci
scsi4 : ahci
scsi5 : ahci
ata3: SATA max UDMA/133 irq_stat 0x00400040, connection status changed irq 45
ata4: DUMMY
ata5: DUMMY
ata6: DUMMY
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata3.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
ata3.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
ata3.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES) succeeded
ata3.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
ata3.00: ATA-7: ST910021AS, 4.06, max UDMA/100
ata3.00: 195371568 sectors, multi 16: LBA48 
ata3.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
ata3.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
ata3.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES) succeeded
ata3.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
ata3.00: configured for UDMA/100
ata3.00: configured for UDMA/100
ata3: EH complete
scsi 2:0:0:0: Direct-Access     ATA      ST910021AS       4.06 PQ: 0 ANSI: 5
sd 2:0:0:0: [sda] 195371568 512-byte logical blocks: (100 GB/93.1 GiB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:0:0: Attached scsi generic sg1 type 0
 sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 >
sd 2:0:0:0: [sda] Attached SCSI disk
[drm] Initialized drm 1.1.0 20060810
acpi device:02: registered as cooling_device1
input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input6
ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
i915 0000:00:02.0: power state changed by ACPI to D0
i915 0000:00:02.0: power state changed by ACPI to D0
i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
i915 0000:00:02.0: setting latency timer to 64
vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[drm] initialized overlay support
fbcon: inteldrmfb (fb0) is primary device
Console: switching to colour frame buffer device 210x65
fb0: inteldrmfb frame buffer device
drm: registered panic notifier
[drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
insmod used greatest stack depth: 4636 bytes left
psmouse serio2: ID: 10 00 64
 sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 >
IBM TrackPoint firmware: 0x0e, buttons: 3/3
input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/serio2/input/input7
EXT4-fs (sda5): mounted filesystem with ordered data mode. Opts: 
EXT4-fs (sda5): mounted filesystem with ordered data mode. Opts: 

--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="t60_2.dmesg"

    memblock_x86_reserve_range: [0x00001000-0x00001fff]    EX TRAMPOLINE
    memblock_x86_reserve_range: [0x00400000-0x012ccaa7]    TEXT DATA BSS
    memblock_x86_reserve_range: [0x37b96000-0x37feffff]          RAMDISK
    memblock_x86_reserve_range: [0x0009f000-0x000fffff]  * BIOS reserved
Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 2.6.37-rc4+ (stasiu@dhcp-27-172.brq.redhat.com) (gcc version 4.4.4 20100726 (Red Hat 4.4.4-13) (GCC) ) #22 SMP Thu Dec 9 10:08:46 CET 2010
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
 BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000d2000 - 00000000000d4000 (reserved)
 BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007f6d0000 (usable)
 BIOS-e820: 000000007f6d0000 - 000000007f6df000 (ACPI data)
 BIOS-e820: 000000007f6df000 - 000000007f700000 (ACPI NVS)
 BIOS-e820: 000000007f700000 - 0000000080000000 (reserved)
 BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
 BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
 BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ff800000 - 0000000100000000 (reserved)
e820 remove range: 0000000040000000 - ffffffffffffffff (usable)
debug: ignoring loglevel setting.
NX (Execute Disable) protection: active
user-defined physical RAM map:
 user: 0000000000000000 - 000000000009f000 (usable)
 user: 000000000009f000 - 00000000000a0000 (reserved)
 user: 00000000000d2000 - 00000000000d4000 (reserved)
 user: 00000000000dc000 - 0000000000100000 (reserved)
 user: 0000000000100000 - 0000000040000000 (usable)
 user: 000000007f6d0000 - 000000007f6df000 (ACPI data)
 user: 000000007f6df000 - 000000007f700000 (ACPI NVS)
 user: 000000007f700000 - 0000000080000000 (reserved)
 user: 00000000f0000000 - 00000000f4000000 (reserved)
 user: 00000000fec00000 - 00000000fec10000 (reserved)
 user: 00000000fed00000 - 00000000fed00400 (reserved)
 user: 00000000fed14000 - 00000000fed1a000 (reserved)
 user: 00000000fed1c000 - 00000000fed90000 (reserved)
 user: 00000000fee00000 - 00000000fee01000 (reserved)
 user: 00000000ff800000 - 0000000100000000 (reserved)
DMI present.
DMI: 6369CTO/6369CTO, BIOS 7IET32WW (1.13 ) 02/05/2008
e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
last_pfn = 0x40000 max_arch_pfn = 0x1000000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-CFFFF write-protect
  D0000-DBFFF uncachable
  DC000-DFFFF write-back
  E0000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 000000000 mask F80000000 write-back
  1 base 07F700000 mask FFFF00000 uncachable
  2 base 07F800000 mask FFF800000 uncachable
  3 disabled
  4 disabled
  5 disabled
  6 disabled
  7 disabled
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
original variable MTRRs
reg 0, base: 0GB, range: 2GB, type WB
reg 1, base: 2039MB, range: 1MB, type UC
reg 2, base: 2040MB, range: 8MB, type UC
total RAM covered: 2039M
Found optimal setting for mtrr clean up
 gran_size: 64K 	chunk_size: 16M 	num_reg: 3  	lose cover RAM: 0G
New variable MTRRs
reg 0, base: 0GB, range: 2GB, type WB
reg 1, base: 2039MB, range: 1MB, type UC
reg 2, base: 2040MB, range: 8MB, type UC
found SMP MP-table at [c00f6810] f6810
    memblock_x86_reserve_range: [0x000f6810-0x000f681f]   * MP-table mpf
    memblock_x86_reserve_range: [0x0009f5a1-0x0009f6b4]   * MP-table mpc
    memblock_x86_reserve_range: [0x012cd000-0x012d9137]              BRK
MEMBLOCK configuration:
 memory size = 0x3ff8f000
 memory.cnt  = 0x2
 memory[0x0]	[0x00000000010000-0x0000000009efff], 0x8f000 bytes
 memory[0x1]	[0x00000000100000-0x0000003fffffff], 0x3ff00000 bytes
 reserved.cnt  = 0x7
 reserved[0x0]	[0x00000000001000-0x00000000001fff], 0x1000 bytes
 reserved[0x1]	[0x0000000009f000-0x000000000fffff], 0x61000 bytes
 reserved[0x2]	[0x0000000009f5a1-0x0000000009f6b4], 0x114 bytes
 reserved[0x3]	[0x000000000f6810-0x000000000f681f], 0x10 bytes
 reserved[0x4]	[0x00000000400000-0x000000012ccaa7], 0xeccaa8 bytes
 reserved[0x5]	[0x000000012cd000-0x000000012d9137], 0xc138 bytes
 reserved[0x6]	[0x00000037b96000-0x00000037feffff], 0x45a000 bytes
initial memory mapped : 0 - 01800000
    memblock_x86_reserve_range: [0x00010000-0x00010fff]       TRAMPOLINE
    memblock_x86_reserve_range: [0x00011000-0x00014fff]      ACPI WAKEUP
init_memory_mapping: 0000000000000000-00000000375fe000
 0000000000 - 0000200000 page 4k
 0000200000 - 0037400000 page 2M
 0037400000 - 00375fe000 page 4k
kernel direct mapping tables up to 375fe000 @ 15000-1d000
    memblock_x86_reserve_range: [0x00015000-0x00018fff]          PGTABLE
RAMDISK: 37b96000 - 37ff0000
    memblock_x86_reserve_range: [0x012da000-0x01733fff]      NEW RAMDISK
Allocated new RAMDISK: 012da000 - 017337fd
Move RAMDISK from 0000000037b96000 - 0000000037fef7fc to 012da000 - 017337fc
       memblock_x86_free_range: [0x37b96000-0x37feffff]
    memblock_x86_reserve_range: [0x02000000-0x09ffffff]     CRASH KERNEL
Reserving 128MB of memory at 32MB for crashkernel (System RAM: 1024MB)
ACPI: RSDP 000f67e0 00024 (v02 LENOVO)
ACPI: XSDT 7f6d14b0 0008C (v01 LENOVO TP-7I    00001130  LTP 00000000)
ACPI: FACP 7f6d1600 000F4 (v03 LENOVO TP-7I    00001130 LNVO 00000001)
ACPI Warning: 32/64X length mismatch in Gpe1Block: 0/32 (20101013/tbfadt-526)
ACPI Warning: Optional field Gpe1Block has zero address or length: 0x000000000000102C/0x0 (20101013/tbfadt-557)
ACPI: DSDT 7f6d195e 0D2D9 (v01 LENOVO TP-7I    00001130 MSFT 0100000E)
ACPI: FACS 7f6f4000 00040
ACPI: SSDT 7f6d17b4 001AA (v01 LENOVO TP-7I    00001130 MSFT 0100000E)
ACPI: ECDT 7f6dec37 00052 (v01 LENOVO TP-7I    00001130 LNVO 00000001)
ACPI: TCPA 7f6dec89 00032 (v02 LENOVO TP-7I    00001130 LNVO 00000001)
ACPI: APIC 7f6decbb 00068 (v01 LENOVO TP-7I    00001130 LNVO 00000001)
ACPI: MCFG 7f6ded23 0003C (v01 LENOVO TP-7I    00001130 LNVO 00000001)
ACPI: HPET 7f6ded5f 00038 (v01 LENOVO TP-7I    00001130 LNVO 00000001)
ACPI: SLIC 7f6dee62 00176 (v01 LENOVO TP-7I    00001130  LTP 00000000)
ACPI: BOOT 7f6defd8 00028 (v01 LENOVO TP-7I    00001130  LTP 00000001)
ACPI: SSDT 7f6f2697 0025F (v01 LENOVO TP-7I    00001130 INTL 20050513)
ACPI: SSDT 7f6f28f6 000A6 (v01 LENOVO TP-7I    00001130 INTL 20050513)
ACPI: SSDT 7f6f299c 004F7 (v01 LENOVO TP-7I    00001130 INTL 20050513)
ACPI: SSDT 7f6f2e93 001D8 (v01 LENOVO TP-7I    00001130 INTL 20050513)
ACPI: Local APIC address 0xfee00000
138MB HIGHMEM available.
885MB LOWMEM available.
  mapped low ram: 0 - 375fe000
  low ram: 0 - 375fe000
    memblock_x86_reserve_range: [0x01734000-0x01734fff]      pgtable pte
    memblock_x86_reserve_range: [0x012ccac0-0x012cccbf]       usemap_map
    memblock_x86_reserve_range: [0x012cccc0-0x012ccd7f]          usermap
    memblock_x86_reserve_range: [0x01735000-0x01b34fff]   sparse mem_map
    memblock_x86_reserve_range: [0x01b35000-0x01f34fff]   sparse mem_map
       memblock_x86_free_range: [0x012ccac0-0x012cccbf]
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  Normal   0x00001000 -> 0x000375fe
  HighMem  0x000375fe -> 0x00040000
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000010 -> 0x0000009f
    0: 0x00000100 -> 0x00040000
On node 0 totalpages: 262031
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 3951 pages, LIFO batch:0
    memblock_x86_reserve_range: [0x01f35000-0x01f64fff]            pgdat
  Normal zone: 1740 pages used for memmap
  Normal zone: 220978 pages, LIFO batch:31
    memblock_x86_reserve_range: [0x01f65000-0x01f94fff]            pgdat
  HighMem zone: 277 pages used for memmap
  HighMem zone: 35053 pages, LIFO batch:7
    memblock_x86_reserve_range: [0x01f95000-0x01fc4fff]            pgdat
Using APIC driver default
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a201 base: 0xfed00000
    memblock_x86_reserve_range: [0x012ccac0-0x012ccaec]         hpet res
SMP: Allowing 2 CPUs, 0 hotplug CPUs
    memblock_x86_reserve_range: [0x012ccb00-0x012ccb2e]       ioapic res
nr_irqs_gsi: 40
    memblock_x86_reserve_range: [0x012ccd80-0x012ccfbf]   e820 resources
    memblock_x86_reserve_range: [0x012ccb40-0x012ccb7f]     firmware map
    memblock_x86_reserve_range: [0x012ccb80-0x012ccbbf]     firmware map
    memblock_x86_reserve_range: [0x012ccbc0-0x012ccbff]     firmware map
    memblock_x86_reserve_range: [0x012ccc00-0x012ccc3f]     firmware map
    memblock_x86_reserve_range: [0x012ccc40-0x012ccc7f]     firmware map
    memblock_x86_reserve_range: [0x012ccc80-0x012cccbf]     firmware map
    memblock_x86_reserve_range: [0x012ccfc0-0x012ccfff]     firmware map
    memblock_x86_reserve_range: [0x012d9140-0x012d917f]     firmware map
    memblock_x86_reserve_range: [0x012d9180-0x012d91bf]     firmware map
    memblock_x86_reserve_range: [0x012d91c0-0x012d91ff]     firmware map
    memblock_x86_reserve_range: [0x012d9200-0x012d923f]     firmware map
    memblock_x86_reserve_range: [0x012d9240-0x012d927f]     firmware map
    memblock_x86_reserve_range: [0x012d9280-0x012d92bf]     firmware map
    memblock_x86_reserve_range: [0x012d92c0-0x012d92ff]     firmware map
    memblock_x86_reserve_range: [0x012d9300-0x012d933f]     firmware map
    memblock_x86_reserve_range: [0x012d9340-0x012d934f]    nosave region
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000d2000
PM: Registered nosave memory: 00000000000d2000 - 00000000000d4000
PM: Registered nosave memory: 00000000000d4000 - 00000000000dc000
PM: Registered nosave memory: 00000000000dc000 - 0000000000100000
Allocating PCI resources starting at 80000000 (gap: 80000000:70000000)
Booting paravirtualized kernel on bare hardware
    memblock_x86_reserve_range: [0x012d9380-0x012d943f]  saved_command_l
    memblock_x86_reserve_range: [0x012d9440-0x012d94ff]  static_command_
setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:2 nr_node_ids:1
    memblock_x86_reserve_range: [0x01fc5000-0x01fc5fff]  pcpu_alloc_info
    memblock_x86_reserve_range: [0x01fc6000-0x01fc6fff]        pcpu area
    memblock_x86_reserve_range: [0x0a000000-0x0a3fffff]       pcpu_alloc
       memblock_x86_free_range: [0x0a14d000-0x0a1fffff]
       memblock_x86_free_range: [0x0a34d000-0x0a3fffff]
PERCPU: Embedded 333 pages/cpu @ca000000 s1343296 r0 d20672 u2097152
    memblock_x86_reserve_range: [0x012d9500-0x012d9503]  pcpu group_offs
    memblock_x86_reserve_range: [0x012d9540-0x012d9543]  pcpu group_size
    memblock_x86_reserve_range: [0x012d9580-0x012d9587]    pcpu unit_map
    memblock_x86_reserve_range: [0x012d95c0-0x012d95c7]    pcpu unit_off
pcpu-alloc: s1343296 r0 d20672 u2097152 alloc=1*2097152
pcpu-alloc: [0] 0 [0] 1 
    memblock_x86_reserve_range: [0x012d9600-0x012d96a7]        pcpu slot
    memblock_x86_reserve_range: [0x012d96c0-0x012d9727]  pcpu chunk_stru
       memblock_x86_free_range: [0x01fc5000-0x01fc5fff]
       memblock_x86_free_range: [0x01fc6000-0x01fc6fff]
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 259982
Kernel command line: ro root=UUID=da6d958d-32d6-43fc-bce2-a19b5f6f9d31 rhgb quiet selinux=0 SYSFONT=latarcyrheb-sun16 LANG=en_US.UTF-8 KEYTABLE=us crashkernel=128M rdshell mem=1G ignore_loglevel debug earlyprintk
    memblock_x86_reserve_range: [0x01fc5000-0x01fc8fff]  large system ha
PID hash table entries: 4096 (order: 2, 16384 bytes)
    memblock_x86_reserve_range: [0x0a14d000-0x0a1ccfff]  large system ha
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
    memblock_x86_reserve_range: [0x0a34d000-0x0a38cfff]  large system ha
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Initializing CPU#0
Subtract (19 early reservations)
  [0000001000-0000001fff]
  [0000010000-0000018fff]
  [000009f000-00000fffff]
  [000009f5a1-000009f6b4]
  [00000f6810-00000f681f]
  [0000400000-00012ccaa7]
  [00012ccac0-00012ccaec]
  [00012ccb00-00012ccb2e]
  [00012ccb40-00012d9137]
  [00012d9140-00012d934f]
  [00012d9380-00012d9503]
  [00012d9540-00012d9543]
  [00012d9580-00012d9587]
  [00012d95c0-00012d95c7]
  [00012d9600-00012d96a7]
  [00012d96c0-00012d9727]
  [00012da000-0001fc8fff]
  [0002000000-000a1ccfff]
  [000a200000-000a38cfff]
(5 free memory ranges)
       [0x00019000-0x0009efff]
       [0x00100000-0x003fffff]
       [0x01fc9000-0x01ffffff]
       [0x0a1cd000-0x0a1fffff]
       [0x0a38d000-0x375fdfff]
Initializing HighMem for node 0 (000375fe:00040000)
Subtract (19 early reservations)
  [0000001000-0000001fff]
  [0000010000-0000018fff]
  [000009f000-00000fffff]
  [000009f5a1-000009f6b4]
  [00000f6810-00000f681f]
  [0000400000-00012ccaa7]
  [00012ccac0-00012ccaec]
  [00012ccb00-00012ccb2e]
  [00012ccb40-00012d9137]
  [00012d9140-00012d934f]
  [00012d9380-00012d9503]
  [00012d9540-00012d9543]
  [00012d9580-00012d9587]
  [00012d95c0-00012d95c7]
  [00012d9600-00012d96a7]
  [00012d96c0-00012d9727]
  [00012da000-0001fc8fff]
  [0002000000-000a1ccfff]
  [000a200000-000a38cfff]
Memory: 885132k/1048576k available (4159k kernel code, 162992k reserved, 2171k data, 1796k init, 141320k highmem)
virtual kernel memory layout:
    fixmap  : 0xffa95000 - 0xfffff000   (5544 kB)
    pkmap   : 0xff600000 - 0xff800000   (2048 kB)
    vmalloc : 0xf7dfe000 - 0xff5fe000   ( 120 MB)
    lowmem  : 0xc0000000 - 0xf75fe000   ( 885 MB)
      .init : 0xc0a2f000 - 0xc0bf0000   (1796 kB)
      .data : 0xc080fc42 - 0xc0a2eb68   (2171 kB)
      .text : 0xc0400000 - 0xc080fc42   (4159 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
Hierarchical RCU implementation.
	RCU-based detection of stalled CPUs is disabled.
NR_IRQS:2304 nr_irqs:512 16
CPU 0 irqstacks, hard=f700a000 soft=f700c000
Extended CMOS year: 2000
Console: colour VGA+ 80x25
console [tty0] enabled
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:  8
... MAX_LOCK_DEPTH:          48
... MAX_LOCKDEP_KEYS:        8191
... CLASSHASH_SIZE:          4096
... MAX_LOCKDEP_ENTRIES:     16384
... MAX_LOCKDEP_CHAINS:      32768
... CHAINHASH_SIZE:          16384
 memory used by lock dependency info: 3823 kB
 per task-struct memory footprint: 1920 bytes
allocated 5242880 bytes of page_cgroup
please try 'cgroup_disable=memory' option if you don't want memory cgroups
ODEBUG: 10 of 10 active objects replaced
hpet clockevent registered
Fast TSC calibration using PIT
Detected 1995.219 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 3990.43 BogoMIPS (lpj=1995219)
pid_max: default: 32768 minimum: 301
Security Framework initialized
SELinux:  Disabled at boot.
Mount-cache hash table entries: 512
Initializing cgroup subsys ns
ns_cgroup deprecated: consider using the 'clone_children' flag without the ns_cgroup.
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
Performance Events: PEBS fmt0-, Core2 events, Intel PMU driver.
PEBS disabled due to CPU errata.
... version:                2
... bit width:              40
... generic registers:      2
... value mask:             000000ffffffffff
... max period:             000000007fffffff
... fixed-purpose events:   3
... event mask:             0000000700000003
ACPI: Core revision 20101013
Enabling APIC mode:  Flat.  Using 1 I/O APICs
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Core(TM)2 CPU         T7200  @ 2.00GHz stepping 06
lockdep: fixing up alternatives.
CPU 1 irqstacks, hard=f70e6000 soft=f70e8000
Booting Node   0, Processors  #1 Ok.
Initializing CPU#1
TSC synchronization [CPU#0 -> CPU#1]:
Measured 617472 cycles TSC warp between CPUs, turning off TSC clock.
Marking TSC unstable due to check_tsc_sync_source failed
Brought up 2 CPUs
Total of 2 processors activated (7980.22 BogoMIPS).
devtmpfs: initialized
NET: Registered protocol family 16
ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
ACPI: bus type pci registered
PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf0000000-0xf3ffffff] (base 0xf0000000)
PCI: MMCONFIG at [mem 0xf0000000-0xf3ffffff] reserved in E820
PCI: Using MMCONFIG for extended config space
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: EC: EC description table is found, configuring boot EC
ACPI: SSDT 7f6f1d36 00282 (v01  PmRef  Cpu0Ist 00000100 INTL 20050513)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT   (null) 00282 (v01  PmRef  Cpu0Ist 00000100 INTL 20050513)
ACPI: SSDT 7f6f203d 0065A (v01  PmRef  Cpu0Cst 00000100 INTL 20050513)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT   (null) 0065A (v01  PmRef  Cpu0Cst 00000100 INTL 20050513)
ACPI: SSDT 7f6f1c6e 000C8 (v01  PmRef  Cpu1Ist 00000100 INTL 20050513)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT   (null) 000C8 (v01  PmRef  Cpu1Ist 00000100 INTL 20050513)
ACPI: SSDT 7f6f1fb8 00085 (v01  PmRef  Cpu1Cst 00000100 INTL 20050513)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT   (null) 00085 (v01  PmRef  Cpu1Cst 00000100 INTL 20050513)
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: EC: GPE = 0x1c, I/O: command/status = 0x66, data = 0x62
ACPI: Power Resource [PUBS] (on)
ACPI: ACPI Dock Station Driver: 3 docks/bays found
PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
pci_root PNP0A08:00: host bridge window [mem 0x000d4000-0x000d7fff]
pci_root PNP0A08:00: host bridge window [mem 0x000d8000-0x000dbfff]
pci_root PNP0A08:00: host bridge window [mem 0x80000000-0xfebfffff]
pci_root PNP0A08:00: host bridge window [mem 0xfed40000-0xfed40fff]
pci 0000:00:00.0: [8086:27a0] type 0 class 0x000600
pci 0000:00:02.0: [8086:27a2] type 0 class 0x000300
pci 0000:00:02.0: reg 10: [mem 0xee100000-0xee17ffff]
pci 0000:00:02.0: reg 14: [io  0x1800-0x1807]
pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff pref]
pci 0000:00:02.0: reg 1c: [mem 0xee200000-0xee23ffff]
pci 0000:00:02.1: [8086:27a6] type 0 class 0x000380
pci 0000:00:02.1: reg 10: [mem 0xee180000-0xee1fffff]
pci 0000:00:1b.0: [8086:27d8] type 0 class 0x000403
pci 0000:00:1b.0: reg 10: [mem 0xee240000-0xee243fff 64bit]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: PME# disabled
pci 0000:00:1c.0: [8086:27d0] type 1 class 0x000604
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.1: [8086:27d2] type 1 class 0x000604
pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.1: PME# disabled
pci 0000:00:1c.2: [8086:27d4] type 1 class 0x000604
pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.2: PME# disabled
pci 0000:00:1c.3: [8086:27d6] type 1 class 0x000604
pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.3: PME# disabled
pci 0000:00:1d.0: [8086:27c8] type 0 class 0x000c03
pci 0000:00:1d.0: reg 20: [io  0x1820-0x183f]
pci 0000:00:1d.1: [8086:27c9] type 0 class 0x000c03
pci 0000:00:1d.1: reg 20: [io  0x1840-0x185f]
pci 0000:00:1d.2: [8086:27ca] type 0 class 0x000c03
pci 0000:00:1d.2: reg 20: [io  0x1860-0x187f]
pci 0000:00:1d.3: [8086:27cb] type 0 class 0x000c03
pci 0000:00:1d.3: reg 20: [io  0x1880-0x189f]
pci 0000:00:1d.7: [8086:27cc] type 0 class 0x000c03
pci 0000:00:1d.7: reg 10: [mem 0xee444000-0xee4443ff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1e.0: [8086:2448] type 1 class 0x000604
pci 0000:00:1f.0: [8086:27b9] type 0 class 0x000601
pci 0000:00:1f.0: quirk: [io  0x1000-0x107f] claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: [io  0x1180-0x11bf] claimed by ICH6 GPIO
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 1600 (mask 007f)
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 15e0 (mask 000f)
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 1680 (mask 001f)
pci 0000:00:1f.1: [8086:27df] type 0 class 0x000101
pci 0000:00:1f.1: reg 10: [io  0x0000-0x0007]
pci 0000:00:1f.1: reg 14: [io  0x0000-0x0003]
pci 0000:00:1f.1: reg 18: [io  0x0000-0x0007]
pci 0000:00:1f.1: reg 1c: [io  0x0000-0x0003]
pci 0000:00:1f.1: reg 20: [io  0x1810-0x181f]
pci 0000:00:1f.2: [8086:27c5] type 0 class 0x000106
pci 0000:00:1f.2: reg 10: [io  0x18d0-0x18d7]
pci 0000:00:1f.2: reg 14: [io  0x18c4-0x18c7]
pci 0000:00:1f.2: reg 18: [io  0x18c8-0x18cf]
pci 0000:00:1f.2: reg 1c: [io  0x18c0-0x18c3]
pci 0000:00:1f.2: reg 20: [io  0x18b0-0x18bf]
pci 0000:00:1f.2: reg 24: [mem 0xee444400-0xee4447ff]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.2: PME# disabled
pci 0000:00:1f.3: [8086:27da] type 0 class 0x000c05
pci 0000:00:1f.3: reg 20: [io  0x18e0-0x18ff]
pci 0000:02:00.0: [8086:109a] type 0 class 0x000200
pci 0000:02:00.0: reg 10: [mem 0xee000000-0xee01ffff]
pci 0000:02:00.0: reg 18: [io  0x2000-0x201f]
pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
pci 0000:02:00.0: PME# disabled
pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
pci 0000:00:1c.0: PCI bridge to [bus 02-02]
pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
pci 0000:00:1c.0:   bridge window [mem 0xee000000-0xee0fffff]
pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:03:00.0: [8086:4227] type 0 class 0x000280
pci 0000:03:00.0: reg 10: [mem 0xedf00000-0xedf00fff]
pci 0000:03:00.0: PME# supported from D0 D3hot
pci 0000:03:00.0: PME# disabled
pci 0000:03:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
pci 0000:00:1c.1: PCI bridge to [bus 03-03]
pci 0000:00:1c.1:   bridge window [io  0x3000-0x4fff]
pci 0000:00:1c.1:   bridge window [mem 0xec000000-0xedffffff]
pci 0000:00:1c.1:   bridge window [mem 0xe4000000-0xe40fffff 64bit pref]
pci 0000:00:1c.2: PCI bridge to [bus 04-0b]
pci 0000:00:1c.2:   bridge window [io  0x5000-0x6fff]
pci 0000:00:1c.2:   bridge window [mem 0xe8000000-0xe9ffffff]
pci 0000:00:1c.2:   bridge window [mem 0xe4100000-0xe41fffff 64bit pref]
pci 0000:00:1c.3: PCI bridge to [bus 0c-13]
pci 0000:00:1c.3:   bridge window [io  0x7000-0x8fff]
pci 0000:00:1c.3:   bridge window [mem 0xea000000-0xebffffff]
pci 0000:00:1c.3:   bridge window [mem 0xe4200000-0xe42fffff 64bit pref]
pci 0000:15:00.0: [104c:ac56] type 2 class 0x000607
pci 0000:15:00.0: reg 10: [mem 0xe4300000-0xe4300fff]
pci 0000:15:00.0: supports D1 D2
pci 0000:15:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:15:00.0: PME# disabled
pci 0000:00:1e.0: PCI bridge to [bus 15-18] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0x9000-0xcfff]
pci 0000:00:1e.0:   bridge window [mem 0xe4300000-0xe7ffffff]
pci 0000:00:1e.0:   bridge window [mem 0xe0000000-0xe3ffffff 64bit pref]
pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x80000000-0xfebfffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0xfed40000-0xfed40fff] (subtractive decode)
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: pci_cache_line_size set to 64 bytes
reserve RAM buffer: 000000000009f000 - 000000000009ffff 
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
HPET: 3 timers in total, 0 timers will be used for per-cpu timer
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 comparators, 64-bit 14.318180 MHz counter
Switching to clocksource hpet
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp 00:00: [mem 0x00000000-0x0009ffff]
pnp 00:00: [mem 0x000c0000-0x000c3fff]
pnp 00:00: [mem 0x000c4000-0x000c7fff]
pnp 00:00: [mem 0x000c8000-0x000cbfff]
pnp 00:00: [mem 0x000cc000-0x000cffff]
pnp 00:00: [mem 0x000d0000-0x000d3fff]
pnp 00:00: [mem 0x000d4000-0x000d3fff disabled]
pnp 00:00: [mem 0x000d8000-0x000d7fff disabled]
pnp 00:00: [mem 0x000dc000-0x000dffff]
pnp 00:00: [mem 0x000e0000-0x000e3fff]
pnp 00:00: [mem 0x000e4000-0x000e7fff]
pnp 00:00: [mem 0x000e8000-0x000ebfff]
pnp 00:00: [mem 0x000ec000-0x000effff]
pnp 00:00: [mem 0x000f0000-0x000fffff]
pnp 00:00: [mem 0x00100000-0x7fffffff]
pnp 00:00: [mem 0xfec00000-0xfed3ffff]
pnp 00:00: [mem 0xfed41000-0xffffffff]
pnp 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
pnp 00:01: [bus 00-ff]
pnp 00:01: [io  0x0cf8-0x0cff]
pnp 00:01: [io  0x0000-0x0cf7 window]
pnp 00:01: [io  0x0d00-0xffff window]
pnp 00:01: [mem 0x000a0000-0x000bffff window]
pnp 00:01: [mem 0x000c0000-0x000c3fff window]
pnp 00:01: [mem 0x000c4000-0x000c7fff window]
pnp 00:01: [mem 0x000c8000-0x000cbfff window]
pnp 00:01: [mem 0x000cc000-0x000cffff window]
pnp 00:01: [mem 0x000d0000-0x000d3fff window]
pnp 00:01: [mem 0x000d4000-0x000d7fff window]
pnp 00:01: [mem 0x000d8000-0x000dbfff window]
pnp 00:01: [mem 0x000dc000-0x000dffff window]
pnp 00:01: [mem 0x000e0000-0x000e3fff window]
pnp 00:01: [mem 0x000e4000-0x000e7fff window]
pnp 00:01: [mem 0x000e8000-0x000ebfff window]
pnp 00:01: [mem 0x000ec000-0x000effff window]
pnp 00:01: [mem 0x80000000-0xfebfffff window]
pnp 00:01: [mem 0xfed40000-0xfed40fff window]
pnp 00:01: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
pnp 00:02: [io  0x0010-0x001f]
pnp 00:02: [io  0x0090-0x009f]
pnp 00:02: [io  0x0024-0x0025]
pnp 00:02: [io  0x0028-0x0029]
pnp 00:02: [io  0x002c-0x002d]
pnp 00:02: [io  0x0030-0x0031]
pnp 00:02: [io  0x0034-0x0035]
pnp 00:02: [io  0x0038-0x0039]
pnp 00:02: [io  0x003c-0x003d]
pnp 00:02: [io  0x00a4-0x00a5]
pnp 00:02: [io  0x00a8-0x00a9]
pnp 00:02: [io  0x00ac-0x00ad]
pnp 00:02: [io  0x00b0-0x00b5]
pnp 00:02: [io  0x00b8-0x00b9]
pnp 00:02: [io  0x00bc-0x00bd]
pnp 00:02: [io  0x0050-0x0053]
pnp 00:02: [io  0x0072-0x0077]
pnp 00:02: [io  0x164e-0x164f]
pnp 00:02: [io  0x002e-0x002f]
pnp 00:02: [io  0x1000-0x107f]
pnp 00:02: [io  0x1180-0x11bf]
pnp 00:02: [io  0x0800-0x080f]
pnp 00:02: [io  0x15e0-0x15ef]
pnp 00:02: [io  0x1600-0x165f]
pnp 00:02: [mem 0xf0000000-0xf3ffffff]
pnp 00:02: [mem 0xfed1c000-0xfed1ffff]
pnp 00:02: [mem 0xfed14000-0xfed17fff]
pnp 00:02: [mem 0xfed18000-0xfed18fff]
pnp 00:02: [mem 0xfed19000-0xfed19fff]
pnp 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:03: [mem 0xfed00000-0xfed003ff]
pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
pnp 00:04: [io  0x0000-0x000f]
pnp 00:04: [io  0x0080-0x008f]
pnp 00:04: [io  0x00c0-0x00df]
pnp 00:04: [dma 4]
pnp 00:04: Plug and Play ACPI device, IDs PNP0200 (active)
pnp 00:05: [io  0x0061]
pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
pnp 00:06: [io  0x00f0]
pnp 00:06: [irq 13]
pnp 00:06: Plug and Play ACPI device, IDs PNP0c04 (active)
pnp 00:07: [io  0x0070-0x0071]
pnp 00:07: [irq 8]
pnp 00:07: Plug and Play ACPI device, IDs PNP0b00 (active)
pnp 00:08: [io  0x0060]
pnp 00:08: [io  0x0064]
pnp 00:08: [irq 1]
pnp 00:08: Plug and Play ACPI device, IDs PNP0303 (active)
pnp 00:09: [irq 12]
pnp 00:09: Plug and Play ACPI device, IDs IBM0057 PNP0f13 (active)
pnp 00:0a: Plug and Play ACPI device, IDs IBM0071 PNP0511 (disabled)
pnp 00:0b: [mem 0xfed40000-0xfed40fff]
pnp 00:0b: Plug and Play ACPI device, IDs ATM1200 PNP0c31 (active)
pnp: PnP ACPI: found 12 devices
ACPI: ACPI bus type pnp unregistered
system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
system 00:00: [mem 0x000c0000-0x000c3fff] could not be reserved
system 00:00: [mem 0x000c4000-0x000c7fff] could not be reserved
system 00:00: [mem 0x000c8000-0x000cbfff] has been reserved
system 00:00: [mem 0x000cc000-0x000cffff] could not be reserved
system 00:00: [mem 0x000d0000-0x000d3fff] could not be reserved
system 00:00: [mem 0x000dc000-0x000dffff] could not be reserved
system 00:00: [mem 0x000e0000-0x000e3fff] could not be reserved
system 00:00: [mem 0x000e4000-0x000e7fff] could not be reserved
system 00:00: [mem 0x000e8000-0x000ebfff] could not be reserved
system 00:00: [mem 0x000ec000-0x000effff] could not be reserved
system 00:00: [mem 0x000f0000-0x000fffff] could not be reserved
system 00:00: [mem 0x00100000-0x7fffffff] could not be reserved
system 00:00: [mem 0xfec00000-0xfed3ffff] could not be reserved
system 00:00: [mem 0xfed41000-0xffffffff] could not be reserved
system 00:02: [io  0x164e-0x164f] has been reserved
system 00:02: [io  0x1000-0x107f] has been reserved
system 00:02: [io  0x1180-0x11bf] has been reserved
system 00:02: [io  0x0800-0x080f] has been reserved
system 00:02: [io  0x15e0-0x15ef] has been reserved
system 00:02: [io  0x1600-0x165f] could not be reserved
system 00:02: [mem 0xf0000000-0xf3ffffff] has been reserved
system 00:02: [mem 0xfed1c000-0xfed1ffff] has been reserved
system 00:02: [mem 0xfed14000-0xfed17fff] has been reserved
system 00:02: [mem 0xfed18000-0xfed18fff] has been reserved
system 00:02: [mem 0xfed19000-0xfed19fff] has been reserved
pci 0000:00:1c.0: BAR 15: assigned [mem 0xfea00000-0xfebfffff 64bit pref]
pci 0000:00:1c.0: PCI bridge to [bus 02-02]
pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
pci 0000:00:1c.0:   bridge window [mem 0xee000000-0xee0fffff]
pci 0000:00:1c.0:   bridge window [mem 0xfea00000-0xfebfffff 64bit pref]
pci 0000:00:1c.1: PCI bridge to [bus 03-03]
pci 0000:00:1c.1:   bridge window [io  0x3000-0x4fff]
pci 0000:00:1c.1:   bridge window [mem 0xec000000-0xedffffff]
pci 0000:00:1c.1:   bridge window [mem 0xe4000000-0xe40fffff 64bit pref]
pci 0000:00:1c.2: PCI bridge to [bus 04-0b]
pci 0000:00:1c.2:   bridge window [io  0x5000-0x6fff]
pci 0000:00:1c.2:   bridge window [mem 0xe8000000-0xe9ffffff]
pci 0000:00:1c.2:   bridge window [mem 0xe4100000-0xe41fffff 64bit pref]
pci 0000:00:1c.3: PCI bridge to [bus 0c-13]
pci 0000:00:1c.3:   bridge window [io  0x7000-0x8fff]
pci 0000:00:1c.3:   bridge window [mem 0xea000000-0xebffffff]
pci 0000:00:1c.3:   bridge window [mem 0xe4200000-0xe42fffff 64bit pref]
pci 0000:15:00.0: BAR 15: assigned [mem 0xe0000000-0xe3ffffff pref]
pci 0000:15:00.0: BAR 16: assigned [mem 0xf8000000-0xfbffffff]
pci 0000:15:00.0: BAR 13: assigned [io  0xcc00-0xccff]
pci 0000:15:00.0: BAR 14: assigned [io  0xc800-0xc8ff]
pci 0000:15:00.0: CardBus bridge to [bus 16-17]
pci 0000:15:00.0:   bridge window [io  0xcc00-0xccff]
pci 0000:15:00.0:   bridge window [io  0xc800-0xc8ff]
pci 0000:15:00.0:   bridge window [mem 0xe0000000-0xe3ffffff pref]
pci 0000:15:00.0:   bridge window [mem 0xf8000000-0xfbffffff]
pci 0000:00:1e.0: PCI bridge to [bus 15-18]
pci 0000:00:1e.0:   bridge window [io  0x9000-0xcfff]
pci 0000:00:1e.0:   bridge window [mem 0xe4300000-0xe7ffffff]
pci 0000:00:1e.0:   bridge window [mem 0xe0000000-0xe3ffffff 64bit pref]
pci 0000:00:1c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
pci 0000:00:1c.0: setting latency timer to 64
pci 0000:00:1c.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
pci 0000:00:1c.1: setting latency timer to 64
pci 0000:00:1c.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
pci 0000:00:1c.2: setting latency timer to 64
pci 0000:00:1c.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
pci 0000:00:1c.3: setting latency timer to 64
pci 0000:00:1e.0: enabling device (0005 -> 0007)
pci 0000:00:1e.0: setting latency timer to 64
pci 0000:15:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: resource 7 [mem 0x000d4000-0x000d7fff]
pci_bus 0000:00: resource 8 [mem 0x000d8000-0x000dbfff]
pci_bus 0000:00: resource 9 [mem 0x80000000-0xfebfffff]
pci_bus 0000:00: resource 10 [mem 0xfed40000-0xfed40fff]
pci_bus 0000:02: resource 0 [io  0x2000-0x2fff]
pci_bus 0000:02: resource 1 [mem 0xee000000-0xee0fffff]
pci_bus 0000:02: resource 2 [mem 0xfea00000-0xfebfffff 64bit pref]
pci_bus 0000:03: resource 0 [io  0x3000-0x4fff]
pci_bus 0000:03: resource 1 [mem 0xec000000-0xedffffff]
pci_bus 0000:03: resource 2 [mem 0xe4000000-0xe40fffff 64bit pref]
pci_bus 0000:04: resource 0 [io  0x5000-0x6fff]
pci_bus 0000:04: resource 1 [mem 0xe8000000-0xe9ffffff]
pci_bus 0000:04: resource 2 [mem 0xe4100000-0xe41fffff 64bit pref]
pci_bus 0000:0c: resource 0 [io  0x7000-0x8fff]
pci_bus 0000:0c: resource 1 [mem 0xea000000-0xebffffff]
pci_bus 0000:0c: resource 2 [mem 0xe4200000-0xe42fffff 64bit pref]
pci_bus 0000:15: resource 0 [io  0x9000-0xcfff]
pci_bus 0000:15: resource 1 [mem 0xe4300000-0xe7ffffff]
pci_bus 0000:15: resource 2 [mem 0xe0000000-0xe3ffffff 64bit pref]
pci_bus 0000:15: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:15: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:15: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:15: resource 7 [mem 0x000d4000-0x000d7fff]
pci_bus 0000:15: resource 8 [mem 0x000d8000-0x000dbfff]
pci_bus 0000:15: resource 9 [mem 0x80000000-0xfebfffff]
pci_bus 0000:15: resource 10 [mem 0xfed40000-0xfed40fff]
pci_bus 0000:16: resource 0 [io  0xcc00-0xccff]
pci_bus 0000:16: resource 1 [io  0xc800-0xc8ff]
pci_bus 0000:16: resource 2 [mem 0xe0000000-0xe3ffffff pref]
pci_bus 0000:16: resource 3 [mem 0xf8000000-0xfbffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 9, 2883584 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
UDP hash table entries: 512 (order: 3, 49152 bytes)
UDP-Lite hash table entries: 512 (order: 3, 49152 bytes)
NET: Registered protocol family 1
pci 0000:00:02.0: Boot video device
PCI: CLS mismatch (64 != 32), using 64 bytes
Trying to unpack rootfs image as initramfs...
Freeing initrd memory: 4456k freed
DMA-API: preallocated 32768 debug entries
DMA-API: debugging enabled by kernel config
Simple Boot Flag at 0x35 set to 0x1
apm: BIOS not found.
audit: initializing netlink socket (disabled)
type=2000 audit(1291900181.706:1): initialized
highmem bounce pool size: 64 pages
HugeTLB registered 2 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
msgmni has been set to 1461
cryptomgr_test used greatest stack depth: 7192 bytes left
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
pcieport 0000:00:1c.0: ACPI _OSC control granted for 0x1d
pcieport 0000:00:1c.0: setting latency timer to 64
pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
pcieport 0000:00:1c.1: ACPI _OSC control granted for 0x1d
pcieport 0000:00:1c.1: setting latency timer to 64
pcieport 0000:00:1c.1: irq 41 for MSI/MSI-X
pcieport 0000:00:1c.2: ACPI _OSC control granted for 0x1d
pcieport 0000:00:1c.2: setting latency timer to 64
pcieport 0000:00:1c.2: irq 42 for MSI/MSI-X
pcieport 0000:00:1c.3: ACPI _OSC control granted for 0x1d
pcieport 0000:00:1c.3: setting latency timer to 64
pcieport 0000:00:1c.3: irq 43 for MSI/MSI-X
pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
pci 0000:02:00.0: Signaling PME through PCIe PME interrupt
pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
pcieport 0000:00:1c.1: Signaling PME through PCIe PME interrupt
pci 0000:03:00.0: Signaling PME through PCIe PME interrupt
pcie_pme 0000:00:1c.1:pcie01: service driver pcie_pme loaded
pcieport 0000:00:1c.2: Signaling PME through PCIe PME interrupt
pcie_pme 0000:00:1c.2:pcie01: service driver pcie_pme loaded
pcieport 0000:00:1c.3: Signaling PME through PCIe PME interrupt
pcie_pme 0000:00:1c.3:pcie01: service driver pcie_pme loaded
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
pciehp 0000:00:1c.0:pcie04: HPC vendor_id 8086 device_id 27d0 ss_vid 17aa ss_did 2011
pciehp 0000:00:1c.0:pcie04: service driver pciehp loaded
pciehp 0000:00:1c.1:pcie04: HPC vendor_id 8086 device_id 27d2 ss_vid 17aa ss_did 2011
pciehp 0000:00:1c.1:pcie04: service driver pciehp loaded
pciehp 0000:00:1c.2:pcie04: HPC vendor_id 8086 device_id 27d4 ss_vid 17aa ss_did 2011
pciehp 0000:00:1c.2:pcie04: service driver pciehp loaded
pciehp 0000:00:1c.3:pcie04: HPC vendor_id 8086 device_id 27d6 ss_vid 17aa ss_did 2011
pciehp 0000:00:1c.3:pcie04: service driver pciehp loaded
pciehp: PCI Express Hot Plug Controller Driver version: 0.4
acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
acpiphp_glue: Slot 1 already registered by another hotplug driver
acpiphp_glue: Slot 1 already registered by another hotplug driver
pci-stub: invalid id string ""
ACPI: AC Adapter [AC] (on-line)
input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
ACPI: Lid Switch [LID]
input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input1
ACPI: Sleep Button [SLPB]
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
ACPI: Power Button [PWRF]
ACPI: acpi_idle registered with cpuidle
Monitor-Mwait will be used to enter C-1 state
Monitor-Mwait will be used to enter C-2 state
Monitor-Mwait will be used to enter C-3 state
thermal LNXTHERM:00: registered as thermal_zone0
ACPI: Thermal Zone [THM0] (52 C)
thermal LNXTHERM:01: registered as thermal_zone1
ACPI: Thermal Zone [THM1] (56 C)
isapnp: Scanning for PnP cards...
ACPI: Battery Slot [BAT0] (battery present)
isapnp: No Plug & Play device found
Non-volatile memory driver v1.3
Linux agpgart interface v0.103
agpgart-intel 0000:00:00.0: Intel 945GM Chipset
agpgart-intel 0000:00:00.0: detected gtt size: 262144K total, 262144K mappable
agpgart-intel 0000:00:00.0: detected 8192K stolen memory
agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
brd: module loaded
loop: module loaded
Fixed MDIO Bus: probed
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1d.7: using broken periodic workaround
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
ehci_hcd 0000:00:1d.7: irq 19, io mem 0xee444000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.37-rc4+ ehci_hcd
usb usb1: SerialNumber: 0000:00:1d.7
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: irq 16, io base 0x00001820
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: UHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.37-rc4+ uhci_hcd
usb usb2: SerialNumber: 0000:00:1d.0
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: irq 17, io base 0x00001840
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.37-rc4+ uhci_hcd
usb usb3: SerialNumber: 0000:00:1d.1
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.2: power state changed by ACPI to D0
uhci_hcd 0000:00:1d.2: power state changed by ACPI to D0
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001860
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.37-rc4+ uhci_hcd
usb usb4: SerialNumber: 0000:00:1d.2
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1d.3: setting latency timer to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.3: irq 19, io base 0x00001880
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.37-rc4+ uhci_hcd
usb usb5: SerialNumber: 0000:00:1d.3
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
rtc_cmos 00:07: RTC can wake from S4
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
cpuidle: using governor ladder
cpuidle: using governor menu
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 17
Registering the dns_resolver key type
Using IPI No-Shortcut mode
registered taskstats version 1
IMA: No TPM chip found, activating TPM-bypass!
rtc_cmos 00:07: setting system clock to 2010-12-09 13:09:44 UTC (1291900184)
Initalizing network drop monitor service
Freeing unused kernel memory: 1796k freed
mknod used greatest stack depth: 6668 bytes left
mount used greatest stack depth: 6404 bytes left
dracut: dracut-004-32.el6
udev: starting version 147
udevd (70): /proc/70/oom_adj is deprecated, please use /proc/70/oom_score_adj instead.
acpi device:02: registered as cooling_device2
input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input4
ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
udevadm used greatest stack depth: 6228 bytes left
[drm] Initialized drm 1.1.0 20060810
i915 0000:00:02.0: power state changed by ACPI to D0
i915 0000:00:02.0: power state changed by ACPI to D0
i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
i915 0000:00:02.0: setting latency timer to 64
vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[drm] initialized overlay support
usb 5-1: new full speed USB device using uhci_hcd and address 2
Synaptics Touchpad, model: 1, fw: 6.2, id: 0x81a0b1, caps: 0xa04793/0x300000/0x0
serio: Synaptics pass-through port at isa0060/serio1/input0
input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input5
usb 5-1: New USB device found, idVendor=0a5c, idProduct=2110
usb 5-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 5-1: Product: BCM2045B
usb 5-1: Manufacturer: Broadcom Corp
fbcon: inteldrmfb (fb0) is primary device
Console: switching to colour frame buffer device 210x65
fb0: inteldrmfb frame buffer device
drm: registered panic notifier
[drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
modprobe used greatest stack depth: 4620 bytes left
usb 5-2: new full speed USB device using uhci_hcd and address 3
dracut: Starting plymouth daemon
usb 5-2: New USB device found, idVendor=0483, idProduct=2016
usb 5-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 5-2: Product: Biometric Coprocessor
usb 5-2: Manufacturer: STMicroelectronics
ata_piix 0000:00:1f.1: version 2.13
ata_piix 0000:00:1f.1: PCI INT C -> GSI 16 (level, low) -> IRQ 16
ata_piix 0000:00:1f.1: setting latency timer to 64
scsi0 : ata_piix
scsi1 : ata_piix
ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x1810 irq 14
ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x1818 irq 15
ata2: port disabled. ignoring.
ata1.00: ATAPI: HL-DT-ST DVDRAM GSA-4083N, 1.00, max UDMA/33
ata1.00: configured for UDMA/33
scsi 0:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-4083N 1.00 PQ: 0 ANSI: 5
ahci 0000:00:1f.2: version 3.0
ahci 0000:00:1f.2: PCI INT B -> GSI 16 (level, low) -> IRQ 16
ahci 0000:00:1f.2: irq 44 for MSI/MSI-X
ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 1.5 Gbps 0x1 impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum part 
ahci 0000:00:1f.2: setting latency timer to 64
scsi2 : ahci
scsi3 : ahci
scsi4 : ahci
scsi5 : ahci
ata3: SATA max UDMA/133 abar m1024@0xee444400 port 0xee444500 irq 44
ata4: DUMMY
ata5: DUMMY
ata6: DUMMY
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata3.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
ata3.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
ata3.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES) succeeded
ata3.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
ata3.00: ATA-7: ST910021AS, 4.06, max UDMA/100
ata3.00: 195371568 sectors, multi 16: LBA48 
ata3.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
ata3.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
ata3.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES) succeeded
ata3.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
ata3.00: configured for UDMA/100
ata3.00: configured for UDMA/100
ata3: EH complete
scsi 2:0:0:0: Direct-Access     ATA      ST910021AS       4.06 PQ: 0 ANSI: 5
yenta_cardbus 0000:15:00.0: CardBus bridge found [17aa:2012]
yenta_cardbus 0000:15:00.0: Using INTVAL to route CSC interrupts to PCI
yenta_cardbus 0000:15:00.0: Routing CardBus interrupts to PCI
yenta_cardbus 0000:15:00.0: TI: mfunc 0x01d01002, devctl 0x64
yenta_cardbus 0000:15:00.0: ISA IRQ mask 0x0cf8, PCI irq 16
yenta_cardbus 0000:15:00.0: Socket status: 30000007
yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge window: [io  0x9000-0xcfff]
pcmcia_socket pcmcia_socket0: cs: IO port probe 0x9000-0xcfff: excluding 0xc800-0xc8ff 0xcc00-0xccff
yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge window: [mem 0xe4300000-0xe7ffffff]
pcmcia_socket pcmcia_socket0: cs: memory probe 0xe4300000-0xe7ffffff: excluding 0xe4300000-0xe46cffff
yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge window: [mem 0xe0000000-0xe3ffffff 64bit pref]
pcmcia_socket pcmcia_socket0: cs: memory probe 0xe0000000-0xe3ffffff: excluding 0xe0000000-0xe3ffffff
sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
cdrom: Uniform CD-ROM driver Revision: 3.20
sr 0:0:0:0: Attached scsi CD-ROM sr0
sd 2:0:0:0: [sda] 195371568 512-byte logical blocks: (100 GB/93.1 GiB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 >
sd 2:0:0:0: [sda] Attached SCSI disk
psmouse serio2: ID: 10 00 64
EXT4-fs (sda5): mounted filesystem with ordered data mode. Opts: (null)
dracut: Mounted root filesystem /dev/sda5
dracut: Switching root
udev: starting version 147
IBM TrackPoint firmware: 0x0e, buttons: 3/3
WARNING! power/level is deprecated; use power/control instead
input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/serio2/input/input6
e1000e: Intel(R) PRO/1000 Network Driver - 1.2.7-k2
e1000e: Copyright (c) 1999 - 2010 Intel Corporation.
e1000e 0000:02:00.0: Disabling ASPM  L1
e1000e 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
e1000e 0000:02:00.0: setting latency timer to 64
e1000e 0000:02:00.0: irq 45 for MSI/MSI-X
e1000e 0000:02:00.0: Disabling ASPM L0s 
e1000e 0000:02:00.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:1e:37:23:c6:16
e1000e 0000:02:00.0: eth0: Intel(R) PRO/1000 Network Connection
e1000e 0000:02:00.0: eth0: MAC: 2, PHY: 2, PBA No: 005301-003
cfg80211: Calling CRDA to update world regulatory domain
iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux, in-tree:ds
iwl3945: Copyright(c) 2003-2010 Intel Corporation
iwl3945 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
iwl3945 0000:03:00.0: setting latency timer to 64
iwl3945 0000:03:00.0: Tunable channels: 13 802.11bg, 23 802.11a channels
iwl3945 0000:03:00.0: Detected Intel Wireless WiFi Link 3945ABG
iwl3945 0000:03:00.0: irq 46 for MSI/MSI-X
ieee80211 phy0: Selected rate control algorithm 'iwl-3945-rs'
intel_rng: FWH not detected
iTCO_vendor_support: vendor-support=0
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.06
iTCO_wdt: Found a ICH7-M or ICH7-U TCO device (Version=2, TCOBASE=0x1060)
iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
i801_smbus 0000:00:1f.3: PCI INT A -> GSI 23 (level, low) -> IRQ 23
sr 0:0:0:0: Attached scsi generic sg0 type 5
sd 2:0:0:0: Attached scsi generic sg1 type 0
thinkpad_acpi: ThinkPad ACPI Extras v0.24
thinkpad_acpi: http://ibm-acpi.sf.net/
thinkpad_acpi: ThinkPad BIOS 7IET32WW (1.13 ), EC 79HT50WW-1.07
thinkpad_acpi: Lenovo ThinkPad T60, model 6369CTO
thinkpad_acpi: WARNING: Outdated ThinkPad BIOS/EC firmware
thinkpad_acpi: WARNING: This firmware may be missing critical bug fixes and/or important features
thinkpad_acpi: detected a 8-level brightness capable ThinkPad
thinkpad_acpi: radio switch found; radios are enabled
thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio is unblocked
Registered led device: tpacpi::thinklight
Registered led device: tpacpi::power
Registered led device: tpacpi::standby
Registered led device: tpacpi::thinkvantage
thinkpad_acpi: Standard ACPI backlight interface available, not loading native one.
thinkpad_acpi: volume: disabled as there is no ALSA support in this kernel
input: ThinkPad Extra Buttons as /devices/platform/thinkpad_acpi/input/input7
pcmcia_socket pcmcia_socket0: cs: IO port probe 0x100-0x3af: excluding 0x170-0x177 0x1f0-0x1f7 0x370-0x377
pcmcia_socket pcmcia_socket0: cs: IO port probe 0x3e0-0x4ff: excluding 0x3f0-0x3f7 0x4d0-0x4d7
pcmcia_socket pcmcia_socket0: cs: IO port probe 0x820-0x8ff: clean.
pcmcia_socket pcmcia_socket0: cs: IO port probe 0xc00-0xcf7: clean.
pcmcia_socket pcmcia_socket0: cs: memory probe 0x0c0000-0x0fffff: excluding 0xc0000-0xd3fff 0xdc000-0xfffff
pcmcia_socket pcmcia_socket0: cs: memory probe 0xa0000000-0xa0ffffff: clean.
pcmcia_socket pcmcia_socket0: cs: memory probe 0x60000000-0x60ffffff: excluding 0x60000000-0x60ffffff
pcmcia_socket pcmcia_socket0: cs: IO port probe 0xa00-0xaff: clean.
cfg80211: World regulatory domain updated:
    (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
    (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
    (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
    (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
    (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
    (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211: Calling CRDA for country: CZ
cfg80211: Regulatory domain changed to country: CZ
    (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
    (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
    (5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2301 mBm)
    (5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2301 mBm)
    (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 3000 mBm)
EXT4-fs (sda5): re-mounted. Opts: (null)
EXT2-fs (sda1): warning: mounting unchecked fs, running e2fsck is recommended
EXT4-fs (sda7): warning: maximal mount count reached, running e2fsck is recommended
EXT4-fs (sda7): recovery complete
EXT4-fs (sda7): mounted filesystem with ordered data mode. Opts: (null)
Adding 4192960k swap on /dev/sda3.  Priority:-1 extents:1 across:4192960k 
microcode: CPU0 sig=0x6f6, pf=0x20, revision=0xc7
microcode: CPU1 sig=0x6f6, pf=0x20, revision=0xc7
microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
microcode: CPU0 updated to revision 0xcc, date = 2007-09-16
microcode: CPU1 updated to revision 0xcc, date = 2007-09-16
microcode: Microcode Update Driver: v2.00 removed.
e1000e 0000:02:00.0: irq 45 for MSI/MSI-X
e1000e 0000:02:00.0: irq 45 for MSI/MSI-X
iwl3945 0000:03:00.0: loaded firmware version 15.32.2.9
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Control: RX/TX
e1000e 0000:02:00.0: eth0: 10/100 speed: disabling TSO
fuse init (API version 7.15)
DMA-API: debugging out of memory - disabling
wlan0: deauthenticating from 00:18:39:d4:03:ad by local choice (reason=3)
wlan0: authenticate with 00:18:39:d4:03:ad (try 1)
wlan0: authenticated
wlan0: associate with 00:18:39:d4:03:ad (try 1)
wlan0: RX AssocResp from 00:18:39:d4:03:ad (capab=0x411 status=0 aid=1)
wlan0: associated
padlock: VIA PadLock not detected.
e1000e: eth0 NIC Link is Down

--PNTmBPCT7hxwcZjr--

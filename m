Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917Ab0DTSqH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 14:46:07 -0400
Received: from mail-ew0-f220.google.com ([209.85.219.220]:53579 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753718Ab0DTSqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 14:46:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=o0awFh92BouJ243fJq50VhCfUblA6fx2z5wF8a4H9cZ/08b4HZqsPR4hSK2VpLd709
         TIF+IhemT4Cc+eLNWEavFq5AF0VKLCnWFMmocHawyilb4UedHXb1VJftotsG7QK1IELo
         YCNQrj1/P2fhl802jAE0BVbh4GVLEG7mReReQ=
Subject: Re: [regression, bisected] Xonar DX invalid PCI I/O range since 
 977d17bb174
From: Peter Henriksson <peter.henriksson@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Yinghai <yinghai.lu@oracle.com>, Clemens Ladisch <clemens@ladisch.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <r2o86802c441004201022i32f328e2n7a125df88f67e390@mail.gmail.com>
References: <4BCBFE89.9070401@ladisch.de>
	 <o2gf046f1351004190044h6c3f6536ga916d2fa047f3fe7@mail.gmail.com>
	 <4BCC0F10.3070208@ladisch.de>
	 <l2sf046f1351004190142ocb2e5f1fyc0e892489caa76a3@mail.gmail.com>
	 <4BCCA5FD.6060002@oracle.com> <1271706161.2505.6.camel@darwin.lan>
	 <4BCD4C8D.7070805@oracle.com>
	 <n2yf046f1351004200103zdcf703e6ofea41dc688a5e62e@mail.gmail.com>
	 <r2o86802c441004201022i32f328e2n7a125df88f67e390@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Apr 2010 20:45:55 +0200
Message-ID: <1271789155.2554.2.camel@darwin.lan>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.0.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> please make sure your .config have CONFIG_PCI_DEBUG=y
> 
> and in the grub.conf, the append line have "debug" there.
> 
> YH

Sorry about that. This should be better.
// Peter

Apr 20 20:31:42 [kernel] Linux version 2.6.34-rc4 (root@darwin) (gcc
version 4.4.3 (Gentoo 4.4.3 p1.0) ) #2 SMP PREEMPT Tue Apr 20 20:30:04
CEST 2010
Apr 20 20:31:42 [kernel] BIOS-provided physical RAM map:
Apr 20 20:31:42 [kernel]  BIOS-e820: 0000000000000000 - 000000000009ec00
(usable)
Apr 20 20:31:42 [kernel]  BIOS-e820: 000000000009ec00 - 00000000000a0000
(reserved)
Apr 20 20:31:42 [kernel]  BIOS-e820: 00000000000e5000 - 0000000000100000
(reserved)
Apr 20 20:31:42 [kernel]  BIOS-e820: 0000000000100000 - 000000007ff40000
(usable)
Apr 20 20:31:42 [kernel]  BIOS-e820: 000000007ff40000 - 000000007ff4e000
(ACPI data)
Apr 20 20:31:42 [kernel]  BIOS-e820: 000000007ff4e000 - 000000007ffe0000
(ACPI NVS)
Apr 20 20:31:42 [kernel]  BIOS-e820: 000000007ffe0000 - 0000000080000000
(reserved)
Apr 20 20:31:42 [kernel]  BIOS-e820: 00000000fee00000 - 00000000fee01000
(reserved)
Apr 20 20:31:42 [kernel]  BIOS-e820: 00000000ffe00000 - 0000000100000000
(reserved)
Apr 20 20:31:42 [kernel] Notice: NX (Execute Disable) protection cannot
be enabled: non-PAE kernel!
Apr 20 20:31:42 [kernel] DMI 2.4 present.
Apr 20 20:31:42 [kernel] AMI BIOS detected: BIOS may corrupt low RAM,
working around it.
Apr 20 20:31:42 [kernel] e820 update range: 0000000000000000 -
0000000000010000 (usable) ==> (reserved)
Apr 20 20:31:42 [kernel] e820 update range: 0000000000000000 -
0000000000001000 (usable) ==> (reserved)
Apr 20 20:31:42 [kernel] e820 remove range: 00000000000a0000 -
0000000000100000 (usable)
Apr 20 20:31:42 [kernel] last_pfn = 0x7ff40 max_arch_pfn = 0x100000
Apr 20 20:31:42 [kernel] MTRR default type: uncachable
Apr 20 20:31:42 [kernel] MTRR fixed ranges enabled:
Apr 20 20:31:42 [kernel]   00000-9FFFF write-back
Apr 20 20:31:42 [kernel]   A0000-BFFFF uncachable
Apr 20 20:31:42 [kernel]   C0000-DFFFF write-protect
Apr 20 20:31:42 [kernel]   E0000-EFFFF write-through
Apr 20 20:31:42 [kernel]   F0000-FFFFF write-protect
Apr 20 20:31:42 [kernel] MTRR variable ranges enabled:
Apr 20 20:31:42 [kernel]   0 base 000000000 mask F80000000 write-back
Apr 20 20:31:42 [kernel]   1 disabled
Apr 20 20:31:42 [kernel]   2 disabled
Apr 20 20:31:42 [kernel]   3 disabled
Apr 20 20:31:42 [kernel]   4 disabled
Apr 20 20:31:42 [kernel]   5 disabled
Apr 20 20:31:42 [kernel]   6 disabled
Apr 20 20:31:42 [kernel]   7 disabled
Apr 20 20:31:42 [kernel] x86 PAT enabled: cpu 0, old 0x7040600070406,
new 0x7010600070106
Apr 20 20:31:42 [kernel] Scanning 0 areas for low memory corruption
Apr 20 20:31:42 [kernel] modified physical RAM map:
Apr 20 20:31:42 [kernel]  modified: 0000000000000000 - 0000000000010000
(reserved)
Apr 20 20:31:42 [kernel]  modified: 0000000000010000 - 000000000009ec00
(usable)
Apr 20 20:31:42 [kernel]  modified: 000000000009ec00 - 00000000000a0000
(reserved)
Apr 20 20:31:42 [kernel]  modified: 00000000000e5000 - 0000000000100000
(reserved)
Apr 20 20:31:42 [kernel]  modified: 0000000000100000 - 000000007ff40000
(usable)
Apr 20 20:31:42 [kernel]  modified: 000000007ff4e000 - 000000007ffe0000
(ACPI NVS)
Apr 20 20:31:42 [kernel]  modified: 000000007ffe0000 - 0000000080000000
(reserved)
Apr 20 20:31:42 [kernel]  modified: 00000000fee00000 - 00000000fee01000
(reserved)
Apr 20 20:31:42 [kernel]  modified: 00000000ffe00000 - 0000000100000000
(reserved)
Apr 20 20:31:42 [kernel] initial memory mapped : 0 - 01800000
Apr 20 20:31:42 [kernel] found SMP MP-table at [c00ff780] ff780
Apr 20 20:31:42 [kernel] init_memory_mapping:
0000000000000000-00000000377fe000
Apr 20 20:31:42 [kernel]  0000000000 - 0000400000 page 4k
Apr 20 20:31:42 [kernel]  0000400000 - 0037400000 page 2M
Apr 20 20:31:42 [kernel]  0037400000 - 00377fe000 page 4k
Apr 20 20:31:42 [kernel] kernel direct mapping tables up to 377fe000 @
15000-1a000
Apr 20 20:31:42 [kernel] ACPI: RSDP 000faff0 00024 (v02 ACPIAM)
Apr 20 20:31:42 [kernel] ACPI: XSDT 7ff40100 00054 (v01 A_M_I_ OEMXSDT
12000810 MSFT 00000097)
Apr 20 20:31:42 [kernel] ACPI: FACP 7ff40290 000F4 (v03 A_M_I_ OEMFACP
12000810 MSFT 00000097)
Apr 20 20:31:42 [kernel] ACPI: DSDT 7ff40440 09516 (v01  A0963 A0963031
00000031 INTL 20060113)
Apr 20 20:31:42 [kernel] ACPI: FACS 7ff4e000 00040
Apr 20 20:31:42 [kernel] ACPI: APIC 7ff40390 0006C (v01 A_M_I_ OEMAPIC
12000810 MSFT 00000097)
Apr 20 20:31:42 [kernel] ACPI: MCFG 7ff40400 0003C (v01 A_M_I_ OEMMCFG
12000810 MSFT 00000097)
Apr 20 20:31:42 [kernel] ACPI: OEMB 7ff4e040 00081 (v01 A_M_I_ AMI_OEM
12000810 MSFT 00000097)
Apr 20 20:31:42 [kernel] ACPI: HPET 7ff49960 00038 (v01 A_M_I_ OEMHPET
12000810 MSFT 00000097)
Apr 20 20:31:42 [kernel] ACPI: OSFR 7ff499a0 000B0 (v01 A_M_I_ OEMOSFR
12000810 MSFT 00000097)
Apr 20 20:31:42 [kernel] ACPI: Local APIC address 0xfee00000
Apr 20 20:31:42 [kernel] 1159MB HIGHMEM available.
Apr 20 20:31:42 [kernel] 887MB LOWMEM available.
Apr 20 20:31:42 [kernel]   mapped low ram: 0 - 377fe000
Apr 20 20:31:42 [kernel]   low ram: 0 - 377fe000
Apr 20 20:31:42 [kernel] Zone PFN ranges:
Apr 20 20:31:42 [kernel]   DMA      0x00000010 -> 0x00001000
Apr 20 20:31:42 [kernel]   Normal   0x00001000 -> 0x000377fe
Apr 20 20:31:42 [kernel]   HighMem  0x000377fe -> 0x0007ff40
Apr 20 20:31:42 [kernel] Movable zone start PFN for each node
Apr 20 20:31:42 [kernel] early_node_map[2] active PFN ranges
Apr 20 20:31:42 [kernel]     0: 0x00000010 -> 0x0000009e
Apr 20 20:31:42 [kernel]     0: 0x00000100 -> 0x0007ff40
Apr 20 20:31:42 [kernel] On node 0 totalpages: 523982
Apr 20 20:31:42 [kernel] free_area_init_node: node 0, pgdat c153aac0,
node_mem_map c161a200
Apr 20 20:31:42 [kernel]   DMA zone: 32 pages used for memmap
Apr 20 20:31:42 [kernel]   DMA zone: 0 pages reserved
Apr 20 20:31:42 [kernel]   DMA zone: 3950 pages, LIFO batch:0
Apr 20 20:31:42 [kernel]   Normal zone: 1744 pages used for memmap
Apr 20 20:31:42 [kernel]   Normal zone: 221486 pages, LIFO batch:31
Apr 20 20:31:42 [kernel]   HighMem zone: 2319 pages used for memmap
Apr 20 20:31:42 [kernel]   HighMem zone: 294451 pages, LIFO batch:31
Apr 20 20:31:42 [kernel] ACPI: PM-Timer IO Port: 0x808
Apr 20 20:31:42 [kernel] ACPI: Local APIC address 0xfee00000
Apr 20 20:31:42 [kernel] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00]
enabled)
Apr 20 20:31:42 [kernel] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01]
enabled)
Apr 20 20:31:42 [kernel] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02]
enabled)
Apr 20 20:31:42 [kernel] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03]
enabled)
Apr 20 20:31:42 [kernel] ACPI: IOAPIC (id[0x04] address[0xfec00000]
gsi_base[0])
Apr 20 20:31:42 [kernel] IOAPIC[0]: apic_id 4, version 32, address
0xfec00000, GSI 0-23
Apr 20 20:31:42 [kernel] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2
dfl dfl)
Apr 20 20:31:42 [kernel] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9
high level)
Apr 20 20:31:42 [kernel] ACPI: IRQ0 used by override.
Apr 20 20:31:42 [kernel] ACPI: IRQ2 used by override.
Apr 20 20:31:42 [kernel] ACPI: IRQ9 used by override.
Apr 20 20:31:42 [kernel] Using ACPI (MADT) for SMP configuration
information
Apr 20 20:31:42 [kernel] ACPI: HPET id: 0x8086a301 base: 0xfed00000
Apr 20 20:31:42 [kernel] SMP: Allowing 4 CPUs, 0 hotplug CPUs
Apr 20 20:31:42 [kernel] nr_irqs_gsi: 24
Apr 20 20:31:42 [kernel] early_res array is doubled to 64 at [16000 -
167ff]
Apr 20 20:31:42 [kernel] PM: Registered nosave memory: 000000000009e000
- 000000000009f000
Apr 20 20:31:42 [kernel] PM: Registered nosave memory: 000000000009f000
- 00000000000a0000
Apr 20 20:31:42 [kernel] PM: Registered nosave memory: 00000000000a0000
- 00000000000e5000
Apr 20 20:31:42 [kernel] PM: Registered nosave memory: 00000000000e5000
- 0000000000100000
Apr 20 20:31:42 [kernel] Allocating PCI resources starting at 80000000
(gap: 80000000:7ee00000)
Apr 20 20:31:42 [kernel] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8
nr_cpu_ids:4 nr_node_ids:1
Apr 20 20:31:42 [kernel] PERCPU: Embedded 12 pages/cpu @c2800000 s27796
r0 d21356 u1048576
Apr 20 20:31:42 [kernel] pcpu-alloc: s27796 r0 d21356 u1048576
alloc=1*4194304
Apr 20 20:31:42 [kernel] pcpu-alloc: [0] 0 1 2 3 
Apr 20 20:31:42 [kernel] Built 1 zonelists in Zone order, mobility
grouping on.  Total pages: 519887
Apr 20 20:31:42 [kernel] Kernel command line: root=/dev/md3 debug
Apr 20 20:31:42 [kernel] PID hash table entries: 4096 (order: 2, 16384
bytes)
Apr 20 20:31:42 [kernel] Dentry cache hash table entries: 131072 (order:
7, 524288 bytes)
Apr 20 20:31:42 [kernel] Inode-cache hash table entries: 65536 (order:
6, 262144 bytes)
Apr 20 20:31:42 [kernel] Enabling fast FPU save and restore... done.
Apr 20 20:31:42 [kernel] Enabling unmasked SIMD FPU exception support...
done.
Apr 20 20:31:42 [kernel] Initializing CPU#0
Apr 20 20:31:42 [kernel] Subtract (48 early reservations)
Apr 20 20:31:42 [kernel]   #1 [0000001000 - 0000002000]   EX TRAMPOLINE
Apr 20 20:31:42 [kernel]   #2 [0001000000 - 0001611c30]   TEXT DATA BSS
Apr 20 20:31:42 [kernel]   #3 [0001612000 - 0001618234]             BRK
Apr 20 20:31:42 [kernel]   #4 [00000ff790 - 0000100000]   BIOS reserved
Apr 20 20:31:42 [kernel]   #5 [00000ff780 - 00000ff790]    MP-table mpf
Apr 20 20:31:42 [kernel]   #6 [000009ec00 - 00000f1540]   BIOS reserved
Apr 20 20:31:42 [kernel]   #7 [00000f175c - 00000ff780]   BIOS reserved
Apr 20 20:31:42 [kernel]   #8 [00000f1540 - 00000f175c]    MP-table mpc
Apr 20 20:31:42 [kernel]   #9 [0000010000 - 0000011000]      TRAMPOLINE
Apr 20 20:31:42 [kernel]   #10 [0000011000 - 0000015000]     ACPI WAKEUP
Apr 20 20:31:42 [kernel]   #11 [0000015000 - 0000016000]         PGTABLE
Apr 20 20:31:42 [kernel]   #12 [0001619000 - 000161a000]         BOOTMEM
Apr 20 20:31:42 [kernel]   #13 [000161a000 - 000261a000]         BOOTMEM
Apr 20 20:31:42 [kernel]   #14 [0001611c40 - 0001611c44]         BOOTMEM
Apr 20 20:31:42 [kernel]   #15 [0001611c80 - 0001611d40]         BOOTMEM
Apr 20 20:31:42 [kernel]   #16 [0001611d40 - 0001611d94]         BOOTMEM
Apr 20 20:31:42 [kernel]   #17 [000261a000 - 000261d000]         BOOTMEM
Apr 20 20:31:42 [kernel]   #18 [0001611dc0 - 0001611e30]         BOOTMEM
Apr 20 20:31:42 [kernel]   #19 [000261d000 - 0002623000]         BOOTMEM
Apr 20 20:31:42 [kernel]   #20 [0001611e40 - 0001611e65]         BOOTMEM
Apr 20 20:31:42 [kernel]   #21 [0001611e80 - 0001611ea7]         BOOTMEM
Apr 20 20:31:42 [kernel]   #22 [0001611ec0 - 0001611fd8]         BOOTMEM
Apr 20 20:31:42 [kernel]   #23 [0001618240 - 0001618280]         BOOTMEM
Apr 20 20:31:42 [kernel]   #24 [0001618280 - 00016182c0]         BOOTMEM
Apr 20 20:31:42 [kernel]   #25 [00016182c0 - 0001618300]         BOOTMEM
Apr 20 20:31:42 [kernel]   #26 [0001618300 - 0001618340]         BOOTMEM
Apr 20 20:31:42 [kernel]   #27 [0001618340 - 0001618380]         BOOTMEM
Apr 20 20:31:42 [kernel]   #28 [0001618380 - 00016183c0]         BOOTMEM
Apr 20 20:31:42 [kernel]   #29 [00016183c0 - 0001618400]         BOOTMEM
Apr 20 20:31:42 [kernel]   #30 [0001618400 - 0001618440]         BOOTMEM
Apr 20 20:31:42 [kernel]   #31 [0001618440 - 0001618480]         BOOTMEM
Apr 20 20:31:42 [kernel]   #32 [0001618480 - 0001618490]         BOOTMEM
Apr 20 20:31:42 [kernel]   #33 [00016184c0 - 00016184d4]         BOOTMEM
Apr 20 20:31:42 [kernel]   #34 [0001618500 - 0001618514]         BOOTMEM
Apr 20 20:31:42 [kernel]   #35 [0002800000 - 000280c000]         BOOTMEM
Apr 20 20:31:42 [kernel]   #36 [0002900000 - 000290c000]         BOOTMEM
Apr 20 20:31:42 [kernel]   #37 [0002a00000 - 0002a0c000]         BOOTMEM
Apr 20 20:31:42 [kernel]   #38 [0002b00000 - 0002b0c000]         BOOTMEM
Apr 20 20:31:42 [kernel]   #39 [0001618540 - 0001618544]         BOOTMEM
Apr 20 20:31:42 [kernel]   #40 [0001618580 - 0001618584]         BOOTMEM
Apr 20 20:31:42 [kernel]   #41 [00016185c0 - 00016185d0]         BOOTMEM
Apr 20 20:31:42 [kernel]   #42 [0001618600 - 0001618610]         BOOTMEM
Apr 20 20:31:42 [kernel] Initializing HighMem for node 0
(000377fe:0007ff40)
Apr 20 20:31:42 [kernel] Memory: 2072260k/2096384k available (3811k
kernel code, 23668k reserved, 1572k data, 352k init, 1187080k highmem)
Apr 20 20:31:42 [kernel] virtual kernel memory layout:
Apr 20 20:31:42 [kernel]     fixmap  : 0xfff1f000 - 0xfffff000   ( 896
kB)
Apr 20 20:31:42 [kernel]     pkmap   : 0xff800000 - 0xffc00000   (4096
kB)
Apr 20 20:31:42 [kernel]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120
MB)
Apr 20 20:31:42 [kernel]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887
MB)
Apr 20 20:31:42 [kernel]       .init : 0xc1542000 - 0xc159a000   ( 352
kB)
Apr 20 20:31:42 [kernel]       .data : 0xc13b8dd1 - 0xc1541f2c   (1572
kB)
Apr 20 20:31:42 [kernel]       .text : 0xc1000000 - 0xc13b8dd1   (3811
kB)
Apr 20 20:31:42 [kernel] Checking if this processor honours the WP bit
even in supervisor mode...Ok.
Apr 20 20:31:42 [kernel] SLUB: Genslabs=13, HWalign=64, Order=0-3,
MinObjects=0, CPUs=4, Nodes=1
Apr 20 20:31:42 [kernel] Hierarchical RCU implementation.
Apr 20 20:31:42 [kernel] NR_IRQS:512
Apr 20 20:31:42 [kernel] Extended CMOS year: 2000
Apr 20 20:31:42 [kernel] Console: colour VGA+ 80x25
Apr 20 20:31:42 [kernel] console [tty0] enabled
Apr 20 20:31:42 [kernel] hpet clockevent registered
Apr 20 20:31:42 [kernel] Fast TSC calibration using PIT
Apr 20 20:31:42 [kernel] Detected 2671.228 MHz processor.
Apr 20 20:31:42 [kernel] Calibrating delay loop (skipped), value
calculated using timer frequency.. 5342.45 BogoMIPS (lpj=2671228)
Apr 20 20:31:42 [kernel] Mount-cache hash table entries: 512
Apr 20 20:31:42 [kernel] CPU: Physical Processor ID: 0
Apr 20 20:31:42 [kernel] CPU: Processor Core ID: 0
Apr 20 20:31:42 [kernel] mce: CPU supports 6 MCE banks
Apr 20 20:31:42 [kernel] CPU0: Thermal monitoring enabled (TM2)
Apr 20 20:31:42 [kernel] using mwait in idle threads.
Apr 20 20:31:42 [kernel] Performance Events: Core2 events, Intel PMU
driver.
Apr 20 20:31:42 [kernel] ... version:                2
Apr 20 20:31:42 [kernel] ... bit width:              40
Apr 20 20:31:42 [kernel] ... generic registers:      2
Apr 20 20:31:42 [kernel] ... value mask:             000000ffffffffff
Apr 20 20:31:42 [kernel] ... max period:             000000007fffffff
Apr 20 20:31:42 [kernel] ... fixed-purpose events:   3
Apr 20 20:31:42 [kernel] ... event mask:             0000000700000003
Apr 20 20:31:42 [kernel] Checking 'hlt' instruction... OK.
Apr 20 20:31:42 [kernel] ACPI: Core revision 20100121
Apr 20 20:31:42 [kernel] Enabling APIC mode:  Flat.  Using 1 I/O APICs
Apr 20 20:31:42 [kernel] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1
pin2=-1
Apr 20 20:31:42 [kernel] CPU0: Intel(R) Core(TM)2 Quad  CPU   Q9450  @
2.66GHz stepping 07
Apr 20 20:31:42 [kernel] Booting Node   0, Processors  #1
Apr 20 20:31:42 [kernel] Initializing CPU#1
Apr 20 20:31:42 [kernel]  #2
Apr 20 20:31:42 [kernel] Initializing CPU#2
Apr 20 20:31:42 [kernel]  #3 Ok.
Apr 20 20:31:42 [kernel] Initializing CPU#3
Apr 20 20:31:42 [kernel] Brought up 4 CPUs
Apr 20 20:31:42 [kernel] Total of 4 processors activated (21371.50
BogoMIPS).
Apr 20 20:31:42 [kernel] NET: Registered protocol family 16
Apr 20 20:31:42 [kernel] ACPI: bus type pci registered
Apr 20 20:31:42 [kernel] PCI: MMCONFIG for domain 0000 [bus 00-ff] at
[mem 0xe0000000-0xefffffff] (base 0xe0000000)
Apr 20 20:31:42 [kernel] PCI: not using MMCONFIG
Apr 20 20:31:42 [kernel] PCI: PCI BIOS revision 3.00 entry at 0xf0031,
last bus=10
Apr 20 20:31:42 [kernel] PCI: Using configuration type 1 for base access
Apr 20 20:31:42 [kernel] bio: create slab <bio-0> at 0
Apr 20 20:31:42 [kernel] ACPI: EC: Look up EC in DSDT
Apr 20 20:31:42 [kernel] ACPI: Executed 1 blocks of module-level
executable AML code
Apr 20 20:31:42 [kernel] ACPI: SSDT 7ff4e0d0 001D2 (v01    AMI   CPU1PM
00000001 INTL 20060113)
Apr 20 20:31:42 [kernel] ACPI: SSDT 7ff4e2b0 00143 (v01    AMI   CPU2PM
00000001 INTL 20060113)
Apr 20 20:31:42 [kernel] ACPI: SSDT 7ff4e400 00143 (v01    AMI   CPU3PM
00000001 INTL 20060113)
Apr 20 20:31:42 [kernel] ACPI: SSDT 7ff4e550 00143 (v01    AMI   CPU4PM
00000001 INTL 20060113)
Apr 20 20:31:42 [kernel] ACPI: Interpreter enabled
Apr 20 20:31:42 [kernel] ACPI: (supports S0 S1 S3 S4 S5)
Apr 20 20:31:42 [kernel] ACPI: Using IOAPIC for interrupt routing
Apr 20 20:31:42 [kernel] PCI: MMCONFIG for domain 0000 [bus 00-ff] at
[mem 0xe0000000-0xefffffff] (base 0xe0000000)
Apr 20 20:31:42 [kernel] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff]
reserved in ACPI motherboard resources
Apr 20 20:31:42 [kernel] PCI: Using MMCONFIG for extended config space
Apr 20 20:31:42 [kernel] ACPI: No dock devices found.
Apr 20 20:31:42 [kernel] PCI: Using host bridge windows from ACPI; if
necessary, use "pci=nocrs" and report a bug
Apr 20 20:31:42 [kernel] ACPI: PCI Root Bridge [PCI0] (0000:00)
Apr 20 20:31:42 [kernel] pci_root PNP0A08:00: host bridge window [io
0x0000-0x0cf7]
Apr 20 20:31:42 [kernel] pci_root PNP0A08:00: host bridge window [io
0x0d00-0xffff]
Apr 20 20:31:42 [kernel] pci_root PNP0A08:00: host bridge window [mem
0x000a0000-0x000bffff]
Apr 20 20:31:42 [kernel] pci_root PNP0A08:00: host bridge window [mem
0x000d0000-0x000dffff]
Apr 20 20:31:42 [kernel] pci_root PNP0A08:00: host bridge window [mem
0x80000000-0xffffffff]
Apr 20 20:31:42 [kernel] pci_bus 0000:00: scanning bus
Apr 20 20:31:42 [kernel] pci 0000:00:00.0: found [8086:29e0] class
000600 header type 00
Apr 20 20:31:42 [kernel] pci 0000:00:00.0: calling
quirk_resource_alignment+0x0/0x166
Apr 20 20:31:42 [kernel] pci 0000:00:00.0: calling
pci_fixup_transparent_bridge+0x0/0x28
Apr 20 20:31:42 [kernel] pci 0000:00:01.0: found [8086:29e1] class
000604 header type 01
Apr 20 20:31:42 [kernel] pci 0000:00:01.0: calling
quirk_resource_alignment+0x0/0x166
Apr 20 20:31:42 [kernel] pci 0000:00:01.0: PME# supported from D0 D3hot
D3cold
Apr 20 20:31:42 [kernel] pci 0000:00:1a.0: found [8086:2937] class
000c03 header type 00
Apr 20 20:31:42 [kernel] pci 0000:00:1a.0: reg 20: [io  0x9800-0x981f]
Apr 20 20:31:42 [kernel] pci 0000:00:1a.0: calling
quirk_resource_alignment+0x0/0x166
Apr 20 20:31:42 [kernel] pci 0000:00:1a.0: calling
pci_fixup_transparent_bridge+0x0/0x28
Apr 20 20:31:42 [kernel] pci 0000:00:1a.1: found [8086:2938] class
000c03 header type 00
Apr 20 20:31:42 [kernel] pci 0000:00:1a.1: reg 20: [io  0x9880-0x989f]
Apr 20 20:31:42 [kernel] pci 0000:00:1a.1: calling
quirk_resource_alignment+0x0/0x166
Apr 20 20:31:42 [kernel] pci 0000:00:1a.1: calling
pci_fixup_transparent_bridge+0x0/0x28
Apr 20 20:31:42 [kernel] pci 0000:00:1a.2: found [8086:2939] class
000c03 header type 00
Apr 20 20:31:42 [kernel] pci 0000:00:1a.2: reg 20: [io  0x9c00-0x9c1f]
Apr 20 20:31:42 [kernel] pci 0000:00:1a.2: calling
quirk_resource_alignment+0x0/0x166
Apr 20 20:31:42 [kernel] pci 0000:00:1a.2: calling
pci_fixup_transparent_bridge+0x0/0x28
Apr 20 20:31:42 [kernel] pci 0000:00:1a.7: found [8086:293c] class
000c03 header type 00
Apr 20 20:31:42 [kernel] pci 0000:00:1a.7: reg 10: [mem
0xf9fffc00-0xf9ffffff]
Apr 20 20:31:42 [kernel] pci 0000:00:1a.7: calling
quirk_resource_alignment+0x0/0x166
Apr 20 20:31:42 [kernel] pci 0000:00:1a.7: calling
pci_fixup_transparent_bridge+0x0/0x28
Apr 20 20:31:42 [kernel] pci 0000:00:1a.7: PME# supported from D0 D3hot
D3cold
Apr 20 20:31:42 [kernel] pci 0000:00:1a.7: PME# disabled
Apr 20 20:31:42 [kernel] pci 0000:00:1b.0: found [8086:293e] class
000403 header type 00
Apr 20 20:31:42 [kernel] pci 0000:00:1b.0: reg 10: [mem
0xf9ff8000-0xf9ffbfff 64bit]
Apr 20 20:31:42 [kernel] pci 0000:00:1b.0: calling
quirk_resource_alignment+0x0/0x166
Apr 20 20:31:42 [kernel] pci 0000:00:1b.0: calling
pci_fixup_transparent_bridge+0x0/0x28
Apr 20 20:31:42 [kernel] pci 0000:00:1b.0: PME# supported from D0 D3hot
D3cold
Apr 20 20:31:42 [kernel] pci 0000:00:1b.0: PME# disabled
Apr 20 20:31:42 [kernel] pci 0000:00:1c.0: found [8086:2940] class
000604 header type 01
Apr 20 20:31:42 [kernel] pci 0000:00:1c.0: calling
quirk_resource_alignment+0x0/0x166
Apr 20 20:31:42 [kernel] pci 0000:00:1c.0: calling
pci_fixup_transparent_bridge+0x0/0x28
Apr 20 20:31:42 [kernel] pci 0000:00:1c.0: PME# supported from D0 D3hot
D3cold
Apr 20 20:31:42 [kernel] pci 0000:00:1c.0: PME# disabled
Apr 20 20:31:42 [kernel] pci 0000:00:1c.4: found [8086:2948] class
000604 header type 01
Apr 20 20:31:42 [kernel] pci 0000:00:1c.4: calling
quirk_resource_alignment+0x0/0x166
Apr 20 20:31:42 [kernel] pci 0000:00:1c.4: calling
pci_fixup_transparent_bridge+0x0/0x28
Apr 20 20:31:42 [kernel] pci 0000:00:1c.4: PME# supported from D0 D3hot
D3cold
Apr 20 20:31:42 [kernel] pci 0000:00:1c.4: PME# disabled
Apr 20 20:31:42 [kernel] pci 0000:00:1c.5: found [8086:294a] class
000604 header type 01
Apr 20 20:31:42 [kernel] pci 0000:00:1c.5: calling
quirk_resource_alignment+0x0/0x166
Apr 20 20:31:42 [kernel] pci 0000:00:1c.5: calling
pci_fixup_transparent_bridge+0x0/0x28
Apr 20 20:31:42 [kernel] pci 0000:00:1c.5: PME# supported from D0 D3hot
D3cold
Apr 20 20:31:42 [kernel] pci 0000:00:1c.5: PME# disabled
Apr 20 20:31:42 [kernel] pci 0000:00:1d.0: found [8086:2934] class
000c03 header type 00
Apr 20 20:31:42 [kernel] pci 0000:00:1d.0: reg 20: [io  0x9080-0x909f]
Apr 20 20:31:42 [kernel] pci 0000:00:1d.0: calling
quirk_resource_alignment+0x0/0x166
Apr 20 20:31:42 [kernel] pci 0000:00:1d.0: calling
pci_fixup_transparent_bridge+0x0/0x28
Apr 20 20:31:42 [kernel] pci 0000:00:1d.1: found [8086:2935] class
000c03 header type 00
Apr 20 20:31:42 [kernel] pci 0000:00:1d.1: reg 20: [io  0x9400-0x941f]
Apr 20 20:31:42 [kernel] pci 0000:00:1d.1: calling
quirk_resource_alignment+0x0/0x166
Apr 20 20:31:42 [kernel] pci 0000:00:1d.1: calling
pci_fixup_transparent_bridge+0x0/0x28
Apr 20 20:31:42 [kernel] pci 0000:00:1d.2: found [8086:2936] class
000c03 header type 00
Apr 20 20:31:42 [kernel] pci 0000:00:1d.2: reg 20: [io  0x9480-0x949f]
Apr 20 20:31:42 [kernel] pci 0000:00:1d.2: calling
quirk_resource_alignment+0x0/0x166
Apr 20 20:31:42 [kernel] pci 0000:00:1d.2: calling
pci_fixup_transparent_bridge+0x0/0x28
Apr 20 20:31:42 [kernel] pci 0000:00:1d.7: found [8086:293a] class
000c03 header type 00
Apr 20 20:31:42 [kernel] pci 0000:00:1d.7: reg 10: [mem
0xf9fff800-0xf9fffbff]
Apr 20 20:31:42 [kernel] pci 0000:00:1d.7: calling
quirk_resource_alignment+0x0/0x166
Apr 20 20:31:42 [kernel] pci 0000:00:1d.7: calling
pci_fixup_transparent_bridge+0x0/0x28
Apr 20 20:31:42 [kernel] pci 0000:00:1d.7: PME# supported from D0 D3hot
D3cold
Apr 20 20:31:42 [kernel] pci 0000:00:1d.7: PME# disabled
Apr 20 20:31:42 [kernel] pci 0000:00:1e.0: found [8086:244e] class
000604 header type 01
Apr 20 20:31:42 [kernel] pci 0000:00:1e.0: calling
quirk_resource_alignment+0x0/0x166
Apr 20 20:31:42 [kernel] pci 0000:00:1e.0: calling
pci_fixup_transparent_bridge+0x0/0x28
Apr 20 20:31:42 [kernel] pci 0000:00:1f.0: found [8086:2916] class
000601 header type 00
Apr 20 20:31:42 [kernel] pci 0000:00:1f.0: calling ich_force_enable_hpet
+0x0/0x156
Apr 20 20:31:42 [kernel] pci 0000:00:1f.0: calling quirk_ich7_lpc
+0x0/0x4d
Apr 20 20:31:42 [kernel] pci 0000:00:1f.0: quirk: [io  0x0800-0x087f]
claimed by ICH6 ACPI/GPIO/TCO
Apr 20 20:31:42 [kernel] pci 0000:00:1f.0: quirk: [io  0x0480-0x04bf]
claimed by ICH6 GPIO
Apr 20 20:31:42 [kernel] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1
PIO at 0294 (mask 0003)
Apr 20 20:31:42 [kernel] pci 0000:00:1f.0: calling
quirk_resource_alignment+0x0/0x166
Apr 20 20:31:42 [kernel] pci 0000:00:1f.2: found [8086:2922] class
000106 header type 00
Apr 20 20:31:42 [kernel] pci 0000:00:1f.2: reg 10: [io  0x8c00-0x8c07]
Apr 20 20:31:42 [kernel] pci 0000:00:1f.2: reg 14: [io  0x8880-0x8883]
Apr 20 20:31:42 [kernel] pci 0000:00:1f.2: reg 18: [io  0x8800-0x8807]
Apr 20 20:31:42 [kernel] pci 0000:00:1f.2: reg 1c: [io  0x8480-0x8483]
Apr 20 20:31:42 [kernel] pci 0000:00:1f.2: reg 20: [io  0x8400-0x841f]
Apr 20 20:31:42 [kernel] pci 0000:00:1f.2: reg 24: [mem
0xf9ffe800-0xf9ffefff]
Apr 20 20:31:42 [kernel] pci 0000:00:1f.2: calling
quirk_resource_alignment+0x0/0x166
Apr 20 20:31:42 [kernel] pci 0000:00:1f.2: calling
pci_fixup_transparent_bridge+0x0/0x28
Apr 20 20:31:42 [kernel] pci 0000:00:1f.2: PME# supported from D3hot
Apr 20 20:31:42 [kernel] pci 0000:00:1f.2: PME# disabled
Apr 20 20:31:42 [kernel] pci 0000:00:1f.3: found [8086:2930] class
000c05 header type 00
Apr 20 20:31:42 [kernel] pci 0000:00:1f.3: reg 10: [mem
0xf9fff400-0xf9fff4ff 64bit]
Apr 20 20:31:42 [kernel] pci 0000:00:1f.3: reg 20: [io  0x0400-0x041f]
Apr 20 20:31:42 [kernel] pci 0000:00:1f.3: calling
quirk_resource_alignment+0x0/0x166
Apr 20 20:31:42 [kernel] pci 0000:00:1f.3: calling
pci_fixup_transparent_bridge+0x0/0x28
Apr 20 20:31:42 [kernel] pci_bus 0000:00: fixups for bus
Apr 20 20:31:42 [kernel] pci 0000:00:01.0: scanning [bus 01-01] behind
bridge, pass 0
Apr 20 20:31:42 [kernel] pci_bus 0000:01: scanning bus
Apr 20 20:31:42 [kernel] pci 0000:01:00.0: found [10de:05e6] class
000300 header type 00
Apr 20 20:31:42 [kernel] pci 0000:01:00.0: reg 10: [mem
0xfd000000-0xfdffffff]
Apr 20 20:31:42 [kernel] pci 0000:01:00.0: reg 14: [mem
0xd0000000-0xdfffffff 64bit pref]
Apr 20 20:31:42 [kernel] pci 0000:01:00.0: reg 1c: [mem
0xfa000000-0xfbffffff 64bit]
Apr 20 20:31:42 [kernel] pci 0000:01:00.0: reg 24: [io  0xac00-0xac7f]
Apr 20 20:31:42 [kernel] pci 0000:01:00.0: reg 30: [mem
0xfe780000-0xfe7fffff pref]
Apr 20 20:31:42 [kernel] pci 0000:01:00.0: calling
quirk_resource_alignment+0x0/0x166
Apr 20 20:31:42 [kernel] pci_bus 0000:01: fixups for bus
Apr 20 20:31:42 [kernel] pci 0000:00:01.0: PCI bridge to [bus 01-01]
Apr 20 20:31:42 [kernel] pci 0000:00:01.0:   bridge window [io
0xa000-0xafff]
Apr 20 20:31:42 [kernel] pci 0000:00:01.0:   bridge window [mem
0xfa000000-0xfe7fffff]
Apr 20 20:31:42 [kernel] pci 0000:00:01.0:   bridge window [mem
0xd0000000-0xdfffffff 64bit pref]
Apr 20 20:31:42 [kernel] pci_bus 0000:01: bus scan returning with max=01
Apr 20 20:31:42 [kernel] pci 0000:00:1c.0: scanning [bus 04-09] behind
bridge, pass 0
Apr 20 20:31:42 [kernel] pci_bus 0000:04: scanning bus
Apr 20 20:31:42 [kernel] pci 0000:04:00.0: found [10b5:8518] class
000604 header type 01
Apr 20 20:31:42 [kernel] pci 0000:04:00.0: reg 10: [mem
0xfeae0000-0xfeafffff]
Apr 20 20:31:42 [kernel] pci 0000:04:00.0: calling
quirk_resource_alignment+0x0/0x166
Apr 20 20:31:42 [kernel] pci 0000:04:00.0: PME# supported from D0 D3hot
D3cold
Apr 20 20:31:42 [kernel] pci 0000:04:00.0: PME# disabled
Apr 20 20:31:42 [kernel] pci_bus 0000:04: fixups for bus
Apr 20 20:31:42 [kernel] pci 0000:00:1c.0: PCI bridge to [bus 04-09]
Apr 20 20:31:42 [kernel] pci 0000:00:1c.0:   bridge window [io
0xd000-0xdfff]
Apr 20 20:31:42 [kernel] pci 0000:00:1c.0:   bridge window [mem
0xfea00000-0xfeafffff]
Apr 20 20:31:42 [kernel] pci 0000:00:1c.0:   bridge window [mem
0xf8e00000-0xf8ffffff 64bit pref]
Apr 20 20:31:42 [kernel] pci 0000:04:00.0: scanning [bus 05-09] behind
bridge, pass 0
Apr 20 20:31:42 [kernel] pci_bus 0000:05: scanning bus
Apr 20 20:31:42 [kernel] pci 0000:05:01.0: found [10b5:8518] class
000604 header type 01
Apr 20 20:31:42 [kernel] pci 0000:05:01.0: calling
quirk_resource_alignment+0x0/0x166
Apr 20 20:31:42 [kernel] pci 0000:05:01.0: PME# supported from D0 D3hot
D3cold
Apr 20 20:31:42 [kernel] pci 0000:05:01.0: PME# disabled
Apr 20 20:31:42 [kernel] pci 0000:05:02.0: found [10b5:8518] class
000604 header type 01
Apr 20 20:31:42 [kernel] pci 0000:05:02.0: calling
quirk_resource_alignment+0x0/0x166
Apr 20 20:31:42 [kernel] pci 0000:05:02.0: PME# supported from D0 D3hot
D3cold
Apr 20 20:31:42 [kernel] pci 0000:05:02.0: PME# disabled
Apr 20 20:31:42 [kernel] pci 0000:05:03.0: found [10b5:8518] class
000604 header type 01
Apr 20 20:31:42 [kernel] pci 0000:05:03.0: calling
quirk_resource_alignment+0x0/0x166
Apr 20 20:31:42 [kernel] pci 0000:05:03.0: PME# supported from D0 D3hot
D3cold
Apr 20 20:31:42 [kernel] pci 0000:05:03.0: PME# disabled
Apr 20 20:31:42 [kernel] pci_bus 0000:05: fixups for bus
Apr 20 20:31:42 [kernel] pci 0000:04:00.0: PCI bridge to [bus 05-09]
Apr 20 20:31:42 [kernel] pci 0000:04:00.0:   bridge window [io
0xd000-0xdfff]
Apr 20 20:31:42 [kernel] pci 0000:04:00.0:   bridge window [mem
0xfff00000-0x000fffff] (disabled)
Apr 20 20:31:42 [kernel] pci 0000:04:00.0:   bridge window [mem
0xf8e00000-0xf8ffffff 64bit pref]
Apr 20 20:31:42 [kernel] pci 0000:05:01.0: scanning [bus 08-09] behind
bridge, pass 0
Apr 20 20:31:42 [kernel] pci_bus 0000:08: scanning bus
Apr 20 20:31:42 [kernel] pci 0000:08:00.0: found [10b5:8112] class
000604 header type 01
Apr 20 20:31:42 [kernel] pci 0000:08:00.0: calling
quirk_resource_alignment+0x0/0x166
Apr 20 20:31:42 [kernel] pci_bus 0000:08: fixups for bus
Apr 20 20:31:42 [kernel] pci 0000:05:01.0: PCI bridge to [bus 08-09]
Apr 20 20:31:42 [kernel] pci 0000:05:01.0:   bridge window [io
0xd000-0xdfff]
Apr 20 20:31:42 [kernel] pci 0000:05:01.0:   bridge window [mem
0xfff00000-0x000fffff] (disabled)
Apr 20 20:31:42 [kernel] pci 0000:05:01.0:   bridge window [mem
0xfff00000-0x000fffff pref] (disabled)
Apr 20 20:31:42 [kernel] pci_bus 0000:09: scanning bus
Apr 20 20:31:42 [kernel] pci 0000:09:04.0: found [13f6:8788] class
000401 header type 00
Apr 20 20:31:42 [kernel] pci 0000:09:04.0: reg 10: [io  0xd800-0xd8ff]
Apr 20 20:31:42 [kernel] pci 0000:09:04.0: calling
quirk_resource_alignment+0x0/0x166
Apr 20 20:31:42 [kernel] pci 0000:09:04.0: supports D1 D2
Apr 20 20:31:42 [kernel] pci_bus 0000:09: fixups for bus
Apr 20 20:31:42 [kernel] pci 0000:08:00.0: PCI bridge to [bus 09-09]
Apr 20 20:31:42 [kernel] pci 0000:08:00.0:   bridge window [io
0xd000-0xdfff]
Apr 20 20:31:42 [kernel] pci 0000:08:00.0:   bridge window [mem
0xfff00000-0x000fffff] (disabled)
Apr 20 20:31:42 [kernel] pci 0000:08:00.0:   bridge window [mem
0xfff00000-0x000fffff pref] (disabled)
Apr 20 20:31:42 [kernel] pci_bus 0000:09: bus scan returning with max=09
Apr 20 20:31:42 [kernel] pci 0000:08:00.0: scanning [bus 09-09] behind
bridge, pass 1
Apr 20 20:31:42 [kernel] pci_bus 0000:08: bus scan returning with max=09
Apr 20 20:31:42 [kernel] pci 0000:05:02.0: scanning [bus 07-07] behind
bridge, pass 0
Apr 20 20:31:42 [kernel] pci_bus 0000:07: scanning bus
Apr 20 20:31:42 [kernel] pci_bus 0000:07: fixups for bus
Apr 20 20:31:42 [kernel] pci 0000:05:02.0: PCI bridge to [bus 07-07]
Apr 20 20:31:42 [kernel] pci 0000:05:02.0:   bridge window [io
0xf000-0x0000] (disabled)
Apr 20 20:31:42 [kernel] pci 0000:05:02.0:   bridge window [mem
0xfff00000-0x000fffff] (disabled)
Apr 20 20:31:42 [kernel] pci 0000:05:02.0:   bridge window [mem
0xf8f00000-0xf8ffffff 64bit pref]
Apr 20 20:31:42 [kernel] pci_bus 0000:07: bus scan returning with max=07
Apr 20 20:31:42 [kernel] pci 0000:05:03.0: scanning [bus 06-06] behind
bridge, pass 0
Apr 20 20:31:42 [kernel] pci_bus 0000:06: scanning bus
Apr 20 20:31:42 [kernel] pci_bus 0000:06: fixups for bus
Apr 20 20:31:42 [kernel] pci 0000:05:03.0: PCI bridge to [bus 06-06]
Apr 20 20:31:42 [kernel] pci 0000:05:03.0:   bridge window [io
0xf000-0x0000] (disabled)
Apr 20 20:31:42 [kernel] pci 0000:05:03.0:   bridge window [mem
0xfff00000-0x000fffff] (disabled)
Apr 20 20:31:42 [kernel] pci 0000:05:03.0:   bridge window [mem
0xf8e00000-0xf8efffff 64bit pref]
Apr 20 20:31:42 [kernel] pci_bus 0000:06: bus scan returning with max=06
Apr 20 20:31:42 [kernel] pci 0000:05:01.0: scanning [bus 08-09] behind
bridge, pass 1
Apr 20 20:31:42 [kernel] pci 0000:05:02.0: scanning [bus 07-07] behind
bridge, pass 1
Apr 20 20:31:42 [kernel] pci 0000:05:03.0: scanning [bus 06-06] behind
bridge, pass 1
Apr 20 20:31:42 [kernel] pci_bus 0000:05: bus scan returning with max=09
Apr 20 20:31:42 [kernel] pci 0000:04:00.0: scanning [bus 05-09] behind
bridge, pass 1
Apr 20 20:31:42 [kernel] pci_bus 0000:04: bus scan returning with max=09
Apr 20 20:31:42 [kernel] pci 0000:00:1c.4: scanning [bus 03-03] behind
bridge, pass 0
Apr 20 20:31:42 [kernel] pci_bus 0000:03: scanning bus
Apr 20 20:31:42 [kernel] pci 0000:03:00.0: found [11ab:6145] class
000101 header type 00
Apr 20 20:31:42 [kernel] pci 0000:03:00.0: reg 10: [io  0xcc00-0xcc07]
Apr 20 20:31:42 [kernel] pci 0000:03:00.0: reg 14: [io  0xc880-0xc883]
Apr 20 20:31:42 [kernel] pci 0000:03:00.0: reg 18: [io  0xc800-0xc807]
Apr 20 20:31:42 [kernel] pci 0000:03:00.0: reg 1c: [io  0xc480-0xc483]
Apr 20 20:31:42 [kernel] pci 0000:03:00.0: reg 20: [io  0xc400-0xc40f]
Apr 20 20:31:42 [kernel] pci 0000:03:00.0: reg 24: [mem
0xfe9ffc00-0xfe9fffff]
Apr 20 20:31:42 [kernel] pci 0000:03:00.0: reg 30: [mem
0xfe980000-0xfe9bffff pref]
Apr 20 20:31:42 [kernel] pci 0000:03:00.0: calling
quirk_resource_alignment+0x0/0x166
Apr 20 20:31:42 [kernel] pci 0000:03:00.0: supports D1
Apr 20 20:31:42 [kernel] pci 0000:03:00.0: PME# supported from D0 D1
D3hot
Apr 20 20:31:42 [kernel] pci 0000:03:00.0: PME# disabled
Apr 20 20:31:42 [kernel] pci_bus 0000:03: fixups for bus
Apr 20 20:31:42 [kernel] pci 0000:00:1c.4: PCI bridge to [bus 03-03]
Apr 20 20:31:42 [kernel] pci 0000:00:1c.4:   bridge window [io
0xc000-0xcfff]
Apr 20 20:31:42 [kernel] pci 0000:00:1c.4:   bridge window [mem
0xfe900000-0xfe9fffff]
Apr 20 20:31:42 [kernel] pci 0000:00:1c.4:   bridge window [mem
0xfff00000-0x000fffff pref] (disabled)
Apr 20 20:31:42 [kernel] pci_bus 0000:03: bus scan returning with max=03
Apr 20 20:31:42 [kernel] pci 0000:00:1c.5: scanning [bus 02-02] behind
bridge, pass 0
Apr 20 20:31:42 [kernel] pci_bus 0000:02: scanning bus
Apr 20 20:31:42 [kernel] pci 0000:02:00.0: found [11ab:4364] class
000200 header type 00
Apr 20 20:31:42 [kernel] pci 0000:02:00.0: reg 10: [mem
0xfe8fc000-0xfe8fffff 64bit]
Apr 20 20:31:42 [kernel] pci 0000:02:00.0: reg 18: [io  0xb800-0xb8ff]
Apr 20 20:31:42 [kernel] pci 0000:02:00.0: reg 30: [mem
0xfe8c0000-0xfe8dffff pref]
Apr 20 20:31:42 [kernel] pci 0000:02:00.0: calling
quirk_resource_alignment+0x0/0x166
Apr 20 20:31:42 [kernel] pci 0000:02:00.0: supports D1 D2
Apr 20 20:31:42 [kernel] pci 0000:02:00.0: PME# supported from D0 D1 D2
D3hot D3cold
Apr 20 20:31:42 [kernel] pci 0000:02:00.0: PME# disabled
Apr 20 20:31:42 [kernel] pci_bus 0000:02: fixups for bus
Apr 20 20:31:42 [kernel] pci 0000:00:1c.5: PCI bridge to [bus 02-02]
Apr 20 20:31:42 [kernel] pci 0000:00:1c.5:   bridge window [io
0xb000-0xbfff]
Apr 20 20:31:42 [kernel] pci 0000:00:1c.5:   bridge window [mem
0xfe800000-0xfe8fffff]
Apr 20 20:31:42 [kernel] pci 0000:00:1c.5:   bridge window [mem
0xfff00000-0x000fffff pref] (disabled)
Apr 20 20:31:42 [kernel] pci_bus 0000:02: bus scan returning with max=02
Apr 20 20:31:42 [kernel] pci 0000:00:1e.0: scanning [bus 0a-0a] behind
bridge, pass 0
Apr 20 20:31:42 [kernel] pci_bus 0000:0a: scanning bus
Apr 20 20:31:42 [kernel] pci 0000:0a:04.0: found [11ab:4320] class
000200 header type 00
Apr 20 20:31:42 [kernel] pci 0000:0a:04.0: reg 14: [io  0xe800-0xe8ff]
Apr 20 20:31:42 [kernel] pci 0000:0a:04.0: reg 30: [mem
0xfebc0000-0xfebdffff pref]
Apr 20 20:31:42 [kernel] pci 0000:0a:04.0: calling
quirk_resource_alignment+0x0/0x166
Apr 20 20:31:42 [kernel] pci 0000:0a:04.0: supports D1 D2
Apr 20 20:31:42 [kernel] pci 0000:0a:04.0: PME# supported from D0 D1 D2
D3hot D3cold
Apr 20 20:31:42 [kernel] pci 0000:0a:04.0: PME# disabled
Apr 20 20:31:42 [kernel] pci_bus 0000:0a: fixups for bus
Apr 20 20:31:42 [kernel] pci 0000:00:1e.0: PCI bridge to [bus 0a-0a]
(subtractive decode)
Apr 20 20:31:42 [kernel] pci 0000:00:1e.0:   bridge window [io
0xe000-0xefff]
Apr 20 20:31:42 [kernel] pci 0000:00:1e.0:   bridge window [mem
0xfeb00000-0xfebfffff]
Apr 20 20:31:42 [kernel] pci 0000:00:1e.0:   bridge window [mem
0xfff00000-0x000fffff pref] (disabled)
Apr 20 20:31:42 [kernel] pci 0000:00:1e.0:   bridge window [io
0x0000-0x0cf7] (subtractive decode)
Apr 20 20:31:42 [kernel] pci 0000:00:1e.0:   bridge window [io
0x0d00-0xffff] (subtractive decode)
Apr 20 20:31:42 [kernel] pci 0000:00:1e.0:   bridge window [mem
0x000a0000-0x000bffff] (subtractive decode)
Apr 20 20:31:42 [kernel] pci 0000:00:1e.0:   bridge window [mem
0x000d0000-0x000dffff] (subtractive decode)
Apr 20 20:31:42 [kernel] pci 0000:00:1e.0:   bridge window [mem
0x80000000-0xffffffff] (subtractive decode)
Apr 20 20:31:42 [kernel] pci_bus 0000:0a: bus scan returning with max=0a
Apr 20 20:31:42 [kernel] pci 0000:00:01.0: scanning [bus 01-01] behind
bridge, pass 1
Apr 20 20:31:42 [kernel] pci 0000:00:1c.0: scanning [bus 04-09] behind
bridge, pass 1
Apr 20 20:31:42 [kernel] pci 0000:00:1c.4: scanning [bus 03-03] behind
bridge, pass 1
Apr 20 20:31:42 [kernel] pci 0000:00:1c.5: scanning [bus 02-02] behind
bridge, pass 1
Apr 20 20:31:42 [kernel] pci 0000:00:1e.0: scanning [bus 0a-0a] behind
bridge, pass 1
Apr 20 20:31:42 [kernel] pci_bus 0000:00: bus scan returning with max=0a
Apr 20 20:31:42 [kernel] pci_bus 0000:00: on NUMA node 0
Apr 20 20:31:42 [kernel] ACPI: PCI Interrupt Routing Table
[\_SB_.PCI0._PRT]
Apr 20 20:31:42 [kernel] ACPI: PCI Interrupt Routing Table
[\_SB_.PCI0.P0P2._PRT]
Apr 20 20:31:42 [kernel] ACPI: PCI Interrupt Routing Table
[\_SB_.PCI0.P0P1._PRT]
Apr 20 20:31:42 [kernel] ACPI: PCI Interrupt Routing Table
[\_SB_.PCI0.P0P4._PRT]
Apr 20 20:31:42 [kernel] ACPI: PCI Interrupt Routing Table
[\_SB_.PCI0.P0P8._PRT]
Apr 20 20:31:42 [kernel] ACPI: PCI Interrupt Routing Table
[\_SB_.PCI0.P0P9._PRT]
Apr 20 20:31:42 [kernel] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7
10 *11 12 14 15)
Apr 20 20:31:42 [kernel] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7
*10 11 12 14 15)
Apr 20 20:31:42 [kernel] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6
7 10 11 12 14 15)
Apr 20 20:31:42 [kernel] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7
10 11 12 14 *15)
Apr 20 20:31:42 [kernel] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7
10 11 12 14 15) *0, disabled.
Apr 20 20:31:42 [kernel] ACPI: PCI Interrupt Link [LNKF] (IRQs *3 4 5 6
7 10 11 12 14 15)
Apr 20 20:31:42 [kernel] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6
*7 10 11 12 14 15)
Apr 20 20:31:42 [kernel] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 *4 5 6
7 10 11 12 14 15)
Apr 20 20:31:42 [kernel] vgaarb: device added:
PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
Apr 20 20:31:42 [kernel] vgaarb: loaded
Apr 20 20:31:42 [kernel] SCSI subsystem initialized
Apr 20 20:31:42 [kernel] libata version 3.00 loaded.
Apr 20 20:31:42 [kernel] usbcore: registered new interface driver usbfs
Apr 20 20:31:42 [kernel] usbcore: registered new interface driver hub
Apr 20 20:31:42 [kernel] usbcore: registered new device driver usb
Apr 20 20:31:42 [kernel] Advanced Linux Sound Architecture Driver
Version 1.0.22.1.
Apr 20 20:31:42 [kernel] PCI: Using ACPI for IRQ routing
Apr 20 20:31:42 [kernel] PCI: pci_cache_line_size set to 64 bytes
Apr 20 20:31:42 [kernel] pci 0000:00:1a.0: BAR 4: reserving [io
0x9800-0x981f flags 0x40101] (d=0, p=0)
Apr 20 20:31:42 [kernel] pci 0000:00:1a.1: BAR 4: reserving [io
0x9880-0x989f flags 0x40101] (d=0, p=0)
Apr 20 20:31:42 [kernel] pci 0000:00:1a.2: BAR 4: reserving [io
0x9c00-0x9c1f flags 0x40101] (d=0, p=0)
Apr 20 20:31:42 [kernel] pci 0000:00:1a.7: BAR 0: reserving [mem
0xf9fffc00-0xf9ffffff flags 0x40200] (d=0, p=0)
Apr 20 20:31:42 [kernel] pci 0000:00:1b.0: BAR 0: reserving [mem
0xf9ff8000-0xf9ffbfff flags 0x140204] (d=0, p=0)
Apr 20 20:31:42 [kernel] pci 0000:00:1d.0: BAR 4: reserving [io
0x9080-0x909f flags 0x40101] (d=0, p=0)
Apr 20 20:31:42 [kernel] pci 0000:00:1d.1: BAR 4: reserving [io
0x9400-0x941f flags 0x40101] (d=0, p=0)
Apr 20 20:31:42 [kernel] pci 0000:00:1d.2: BAR 4: reserving [io
0x9480-0x949f flags 0x40101] (d=0, p=0)
Apr 20 20:31:42 [kernel] pci 0000:00:1d.7: BAR 0: reserving [mem
0xf9fff800-0xf9fffbff flags 0x40200] (d=0, p=0)
Apr 20 20:31:42 [kernel] pci 0000:00:1f.2: BAR 0: reserving [io
0x8c00-0x8c07 flags 0x40101] (d=0, p=0)
Apr 20 20:31:42 [kernel] pci 0000:00:1f.2: BAR 1: reserving [io
0x8880-0x8883 flags 0x40101] (d=0, p=0)
Apr 20 20:31:42 [kernel] pci 0000:00:1f.2: BAR 2: reserving [io
0x8800-0x8807 flags 0x40101] (d=0, p=0)
Apr 20 20:31:42 [kernel] pci 0000:00:1f.2: BAR 3: reserving [io
0x8480-0x8483 flags 0x40101] (d=0, p=0)
Apr 20 20:31:42 [kernel] pci 0000:00:1f.2: BAR 4: reserving [io
0x8400-0x841f flags 0x40101] (d=0, p=0)
Apr 20 20:31:42 [kernel] pci 0000:00:1f.3: BAR 0: reserving [mem
0xf9fff400-0xf9fff4ff flags 0x140204] (d=0, p=0)
Apr 20 20:31:42 [kernel] pci 0000:00:1f.3: BAR 4: reserving [io
0x0400-0x041f flags 0x40101] (d=0, p=0)
Apr 20 20:31:42 [kernel] pci 0000:01:00.0: BAR 0: reserving [mem
0xfd000000-0xfdffffff flags 0x40200] (d=0, p=0)
Apr 20 20:31:42 [kernel] pci 0000:01:00.0: BAR 1: reserving [mem
0xd0000000-0xdfffffff flags 0x14220c] (d=0, p=0)
Apr 20 20:31:42 [kernel] pci 0000:01:00.0: BAR 3: reserving [mem
0xfa000000-0xfbffffff flags 0x140204] (d=0, p=0)
Apr 20 20:31:42 [kernel] pci 0000:01:00.0: BAR 5: reserving [io
0xac00-0xac7f flags 0x40101] (d=0, p=0)
Apr 20 20:31:42 [kernel] pci 0000:04:00.0: BAR 0: reserving [mem
0xfeae0000-0xfeafffff flags 0x40200] (d=0, p=0)
Apr 20 20:31:42 [kernel] pci 0000:09:04.0: BAR 0: reserving [io
0xd800-0xd8ff flags 0x40101] (d=0, p=0)
Apr 20 20:31:42 [kernel] pci 0000:03:00.0: BAR 0: reserving [io
0xcc00-0xcc07 flags 0x40101] (d=0, p=0)
Apr 20 20:31:42 [kernel] pci 0000:03:00.0: BAR 1: reserving [io
0xc880-0xc883 flags 0x40101] (d=0, p=0)
Apr 20 20:31:42 [kernel] pci 0000:03:00.0: BAR 2: reserving [io
0xc800-0xc807 flags 0x40101] (d=0, p=0)
Apr 20 20:31:42 [kernel] pci 0000:03:00.0: BAR 3: reserving [io
0xc480-0xc483 flags 0x40101] (d=0, p=0)
Apr 20 20:31:42 [kernel] pci 0000:03:00.0: BAR 4: reserving [io
0xc400-0xc40f flags 0x40101] (d=0, p=0)
Apr 20 20:31:42 [kernel] pci 0000:03:00.0: BAR 5: reserving [mem
0xfe9ffc00-0xfe9fffff flags 0x40200] (d=0, p=0)
Apr 20 20:31:42 [kernel] pci 0000:02:00.0: BAR 0: reserving [mem
0xfe8fc000-0xfe8fffff flags 0x140204] (d=0, p=0)
Apr 20 20:31:42 [kernel] pci 0000:02:00.0: BAR 2: reserving [io
0xb800-0xb8ff flags 0x40101] (d=0, p=0)
Apr 20 20:31:42 [kernel] pci 0000:0a:04.0: BAR 0: reserving [mem
0xfebfc000-0xfebfffff flags 0x40200] (d=0, p=0)
Apr 20 20:31:42 [kernel] pci 0000:0a:04.0: BAR 1: reserving [io
0xe800-0xe8ff flags 0x40101] (d=0, p=0)
Apr 20 20:31:42 [kernel] reserve RAM buffer: 000000000009ec00 -
000000000009ffff 
Apr 20 20:31:42 [kernel] reserve RAM buffer: 000000007ff40000 -
000000007fffffff 
Apr 20 20:31:42 [kernel] Bluetooth: Core ver 2.15
Apr 20 20:31:42 [kernel] NET: Registered protocol family 31
Apr 20 20:31:42 [kernel] Bluetooth: HCI device and connection manager
initialized
Apr 20 20:31:42 [kernel] Bluetooth: HCI socket layer initialized
Apr 20 20:31:42 [kernel] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
Apr 20 20:31:42 [kernel] hpet0: 4 comparators, 64-bit 14.318180 MHz
counter
Apr 20 20:31:42 [kernel] Switching to clocksource tsc
Apr 20 20:31:42 [kernel] pnp: PnP ACPI init
Apr 20 20:31:42 [kernel] ACPI: bus type pnp registered
Apr 20 20:31:42 [kernel] pnp: PnP ACPI: found 15 devices
Apr 20 20:31:42 [kernel] ACPI: ACPI bus type pnp unregistered
Apr 20 20:31:42 [kernel] system 00:01: [mem 0xfed14000-0xfed19fff] has
been reserved
Apr 20 20:31:42 [kernel] system 00:06: [io  0x0290-0x0297] has been
reserved
Apr 20 20:31:42 [kernel] system 00:07: [io  0x04d0-0x04d1] has been
reserved
Apr 20 20:31:42 [kernel] system 00:07: [io  0x0800-0x087f] has been
reserved
Apr 20 20:31:42 [kernel] system 00:07: [io  0x0480-0x04bf] has been
reserved
Apr 20 20:31:42 [kernel] system 00:07: [mem 0xfed1c000-0xfed1ffff] has
been reserved
Apr 20 20:31:42 [kernel] system 00:07: [mem 0xfed20000-0xfed3ffff] has
been reserved
Apr 20 20:31:42 [kernel] system 00:07: [mem 0xfed50000-0xfed8ffff] has
been reserved
Apr 20 20:31:42 [kernel] system 00:07: [mem 0xffa00000-0xffafffff] has
been reserved
Apr 20 20:31:42 [kernel] system 00:07: [mem 0xffb00000-0xffbfffff] has
been reserved
Apr 20 20:31:42 [kernel] system 00:07: [mem 0xffe00000-0xffefffff] has
been reserved
Apr 20 20:31:42 [kernel] system 00:07: [mem 0xfff00000-0xfffffffe] has
been reserved
Apr 20 20:31:42 [kernel] system 00:0a: [mem 0xffc00000-0xffdfffff] has
been reserved
Apr 20 20:31:42 [kernel] system 00:0b: [mem 0xfec00000-0xfec00fff] could
not be reserved
Apr 20 20:31:42 [kernel] system 00:0b: [mem 0xfee00000-0xfee00fff] has
been reserved
Apr 20 20:31:42 [kernel] system 00:0d: [mem 0xe0000000-0xefffffff] has
been reserved
Apr 20 20:31:42 [kernel] system 00:0e: [mem 0x00000000-0x0009ffff] could
not be reserved
Apr 20 20:31:42 [kernel] system 00:0e: [mem 0x000c0000-0x000cffff] could
not be reserved
Apr 20 20:31:42 [kernel] system 00:0e: [mem 0x000e0000-0x000fffff] could
not be reserved
Apr 20 20:31:42 [kernel] system 00:0e: [mem 0x00100000-0x7fffffff] could
not be reserved
Apr 20 20:31:42 [kernel] PCI: max bus depth: 4 pci_try_num: 5
Apr 20 20:31:42 [kernel] pci 0000:00:1c.4: BAR 9: assigned [mem
0x80000000-0x801fffff 64bit pref]
Apr 20 20:31:42 [kernel] pci 0000:00:1c.5: BAR 9: assigned [mem
0x80200000-0x803fffff 64bit pref]
Apr 20 20:31:42 [kernel] pci 0000:00:01.0: PCI bridge to [bus 01-01]
Apr 20 20:31:42 [kernel] pci 0000:00:01.0:   bridge window [io
0xa000-0xafff]
Apr 20 20:31:42 [kernel] pci 0000:00:01.0:   bridge window [mem
0xfa000000-0xfe7fffff]
Apr 20 20:31:42 [kernel] pci 0000:00:01.0:   bridge window [mem
0xd0000000-0xdfffffff 64bit pref]
Apr 20 20:31:42 [kernel] pci 0000:04:00.0: BAR 8: can't assign mem (size
0xc00000)
Apr 20 20:31:42 [kernel] pci 0000:05:01.0: BAR 8: can't assign mem (size
0x200000)
Apr 20 20:31:42 [kernel] pci 0000:05:01.0: BAR 9: can't assign mem pref
(size 0x200000)
Apr 20 20:31:42 [kernel] pci 0000:05:02.0: BAR 8: can't assign mem (size
0x400000)
Apr 20 20:31:42 [kernel] pci 0000:05:03.0: BAR 7: can't assign io (size
0x1000)
Apr 20 20:31:42 [kernel] pci 0000:08:00.0: PCI bridge to [bus 09-09]
Apr 20 20:31:42 [kernel] pci 0000:08:00.0:   bridge window [io
0xd000-0xdfff]
Apr 20 20:31:42 [kernel] pci 0000:08:00.0:   bridge window [mem
disabled]
Apr 20 20:31:42 [kernel] pci 0000:08:00.0:   bridge window [mem pref
disabled]
Apr 20 20:31:42 [kernel] pci 0000:05:01.0: PCI bridge to [bus 08-09]
Apr 20 20:31:42 [kernel] pci 0000:05:01.0:   bridge window [io
0xd000-0xdfff]
Apr 20 20:31:42 [kernel] pci 0000:05:01.0:   bridge window [mem
disabled]
Apr 20 20:31:42 [kernel] pci 0000:05:01.0:   bridge window [mem pref
disabled]
Apr 20 20:31:42 [kernel] pci 0000:05:02.0: PCI bridge to [bus 07-07]
Apr 20 20:31:42 [kernel] pci 0000:05:02.0:   bridge window [io
disabled]
Apr 20 20:31:42 [kernel] pci 0000:05:02.0:   bridge window [mem
disabled]
Apr 20 20:31:42 [kernel] pci 0000:05:02.0:   bridge window [mem
0xf8f00000-0xf8ffffff 64bit pref]
Apr 20 20:31:42 [kernel] pci 0000:05:03.0: PCI bridge to [bus 06-06]
Apr 20 20:31:42 [kernel] pci 0000:05:03.0:   bridge window [io
disabled]
Apr 20 20:31:42 [kernel] pci 0000:05:03.0:   bridge window [mem
disabled]
Apr 20 20:31:42 [kernel] pci 0000:05:03.0:   bridge window [mem
0xf8e00000-0xf8efffff 64bit pref]
Apr 20 20:31:42 [kernel] pci 0000:04:00.0: PCI bridge to [bus 05-09]
Apr 20 20:31:42 [kernel] pci 0000:04:00.0:   bridge window [io
0xd000-0xdfff]
Apr 20 20:31:42 [kernel] pci 0000:04:00.0:   bridge window [mem
disabled]
Apr 20 20:31:42 [kernel] pci 0000:04:00.0:   bridge window [mem
0xf8e00000-0xf8ffffff 64bit pref]
Apr 20 20:31:42 [kernel] pci 0000:00:1c.0: PCI bridge to [bus 04-09]
Apr 20 20:31:42 [kernel] pci 0000:00:1c.0:   bridge window [io
0xd000-0xdfff]
Apr 20 20:31:42 [kernel] pci 0000:00:1c.0:   bridge window [mem
0xfea00000-0xfeafffff]
Apr 20 20:31:42 [kernel] pci 0000:00:1c.0:   bridge window [mem
0xf8e00000-0xf8ffffff 64bit pref]
Apr 20 20:31:42 [kernel] pci 0000:00:1c.4: PCI bridge to [bus 03-03]
Apr 20 20:31:42 [kernel] pci 0000:00:1c.4:   bridge window [io
0xc000-0xcfff]
Apr 20 20:31:42 [kernel] pci 0000:00:1c.4:   bridge window [mem
0xfe900000-0xfe9fffff]
Apr 20 20:31:42 [kernel] pci 0000:00:1c.4:   bridge window [mem
0x80000000-0x801fffff 64bit pref]
Apr 20 20:31:42 [kernel] pci 0000:00:1c.5: PCI bridge to [bus 02-02]
Apr 20 20:31:42 [kernel] pci 0000:00:1c.5:   bridge window [io
0xb000-0xbfff]
Apr 20 20:31:42 [kernel] pci 0000:00:1c.5:   bridge window [mem
0xfe800000-0xfe8fffff]
Apr 20 20:31:42 [kernel] pci 0000:00:1c.5:   bridge window [mem
0x80200000-0x803fffff 64bit pref]
Apr 20 20:31:42 [kernel] pci 0000:00:1e.0: PCI bridge to [bus 0a-0a]
Apr 20 20:31:42 [kernel] pci 0000:00:1e.0:   bridge window [io
0xe000-0xefff]
Apr 20 20:31:42 [kernel] pci 0000:00:1e.0:   bridge window [mem
0xfeb00000-0xfebfffff]
Apr 20 20:31:42 [kernel] pci 0000:00:1e.0:   bridge window [mem pref
disabled]
Apr 20 20:31:42 [kernel] PCI: No. 2 try to assign unassigned res
Apr 20 20:31:42 [kernel] pci 0000:00:01.0: PCI bridge to [bus 01-01]
Apr 20 20:31:42 [kernel] pci 0000:00:01.0:   bridge window [io
0xa000-0xafff]
Apr 20 20:31:42 [kernel] pci 0000:00:01.0:   bridge window [mem
0xfa000000-0xfe7fffff]
Apr 20 20:31:42 [kernel] pci 0000:00:01.0:   bridge window [mem
0xd0000000-0xdfffffff 64bit pref]
Apr 20 20:31:42 [kernel] pci 0000:04:00.0: BAR 8: can't assign mem (size
0xc00000)
Apr 20 20:31:42 [kernel] pci 0000:05:01.0: BAR 8: can't assign mem (size
0x200000)
Apr 20 20:31:42 [kernel] pci 0000:05:01.0: BAR 9: can't assign mem pref
(size 0x200000)
Apr 20 20:31:42 [kernel] pci 0000:05:02.0: BAR 8: can't assign mem (size
0x400000)
Apr 20 20:31:42 [kernel] pci 0000:05:03.0: BAR 8: can't assign mem (size
0x400000)
Apr 20 20:31:42 [kernel] pci 0000:05:02.0: BAR 7: can't assign io (size
0x1000)
Apr 20 20:31:42 [kernel] pci 0000:05:03.0: BAR 7: can't assign io (size
0x1000)
Apr 20 20:31:42 [kernel] pci 0000:08:00.0: PCI bridge to [bus 09-09]
Apr 20 20:31:42 [kernel] pci 0000:08:00.0:   bridge window [io
0xd000-0xdfff]
Apr 20 20:31:42 [kernel] pci 0000:08:00.0:   bridge window [mem
disabled]
Apr 20 20:31:42 [kernel] pci 0000:08:00.0:   bridge window [mem pref
disabled]
Apr 20 20:31:42 [kernel] pci 0000:05:01.0: PCI bridge to [bus 08-09]
Apr 20 20:31:42 [kernel] pci 0000:05:01.0:   bridge window [io
0xd000-0xdfff]
Apr 20 20:31:42 [kernel] pci 0000:05:01.0:   bridge window [mem
disabled]
Apr 20 20:31:42 [kernel] pci 0000:05:01.0:   bridge window [mem pref
disabled]
Apr 20 20:31:42 [kernel] pci 0000:05:02.0: PCI bridge to [bus 07-07]
Apr 20 20:31:42 [kernel] pci 0000:05:02.0:   bridge window [io
disabled]
Apr 20 20:31:42 [kernel] pci 0000:05:02.0:   bridge window [mem
disabled]
Apr 20 20:31:42 [kernel] pci 0000:05:02.0:   bridge window [mem
0xf8f00000-0xf8ffffff 64bit pref]
Apr 20 20:31:42 [kernel] pci 0000:05:03.0: PCI bridge to [bus 06-06]
Apr 20 20:31:42 [kernel] pci 0000:05:03.0:   bridge window [io
disabled]
Apr 20 20:31:42 [kernel] pci 0000:05:03.0:   bridge window [mem
disabled]
Apr 20 20:31:42 [kernel] pci 0000:05:03.0:   bridge window [mem
0xf8e00000-0xf8efffff 64bit pref]
Apr 20 20:31:42 [kernel] pci 0000:04:00.0: PCI bridge to [bus 05-09]
Apr 20 20:31:42 [kernel] pci 0000:04:00.0:   bridge window [io
0xd000-0xdfff]
Apr 20 20:31:42 [kernel] pci 0000:04:00.0:   bridge window [mem
disabled]
Apr 20 20:31:42 [kernel] pci 0000:04:00.0:   bridge window [mem
0xf8e00000-0xf8ffffff 64bit pref]
Apr 20 20:31:42 [kernel] pci 0000:00:1c.0: PCI bridge to [bus 04-09]
Apr 20 20:31:42 [kernel] pci 0000:00:1c.4:   bridge window [io
0xc000-0xcfff]
Apr 20 20:31:42 [kernel] pci 0000:00:1c.4:   bridge window [mem
0xfe900000-0xfe9fffff]
Apr 20 20:31:42 [kernel] pci 0000:00:1c.4:   bridge window [mem
0x80000000-0x801fffff 64bit pref]
Apr 20 20:31:42 [kernel] pci 0000:00:1c.5: PCI bridge to [bus 02-02]
Apr 20 20:31:42 [kernel] pci 0000:00:1c.5:   bridge window [io
0xb000-0xbfff]
Apr 20 20:31:42 [kernel] pci 0000:00:1c.5:   bridge window [mem
0xfe800000-0xfe8fffff]
Apr 20 20:31:42 [kernel] pci 0000:00:1c.5:   bridge window [mem
0x80200000-0x803fffff 64bit pref]
Apr 20 20:31:42 [kernel] pci 0000:00:1e.0: PCI bridge to [bus 0a-0a]
Apr 20 20:31:42 [kernel] pci 0000:00:1e.0:   bridge window [io
0xe000-0xefff]
Apr 20 20:31:42 [kernel] pci 0000:00:1e.0:   bridge window [mem
0xfeb00000-0xfebfffff]
Apr 20 20:31:42 [kernel] pci 0000:00:1e.0:   bridge window [mem pref
disabled]
Apr 20 20:31:42 [kernel] PCI: No. 3 try to assign unassigned res
Apr 20 20:31:42 [kernel] release child resource [io  0xd800-0xd8ff]
Apr 20 20:31:42 [kernel] pci 0000:08:00.0: resource 7 [io
0xd000-0xdfff] released
Apr 20 20:31:42 [kernel] pci 0000:08:00.0: PCI bridge to [bus 09-09]
Apr 20 20:31:42 [kernel] pci 0000:08:00.0:   bridge window [io
disabled]
Apr 20 20:31:42 [kernel] pci 0000:05:01.0: resource 7 [io
0xd000-0xdfff] released
Apr 20 20:31:42 [kernel] pci 0000:05:01.0: PCI bridge to [bus 08-09]
Apr 20 20:31:42 [kernel] pci 0000:05:01.0:   bridge window [io
disabled]
Apr 20 20:31:42 [kernel] pci 0000:04:00.0: resource 7 [io
0xd000-0xdfff] released
Apr 20 20:31:42 [kernel] pci 0000:04:00.0: PCI bridge to [bus 05-09]
Apr 20 20:31:42 [kernel] pci 0000:04:00.0:   bridge window [io
disabled]
Apr 20 20:31:42 [kernel] pci 0000:05:02.0: resource 9 [mem
0xf8f00000-0xf8ffffff 64bit pref] released
Apr 20 20:31:42 [kernel] pci 0000:05:02.0: PCI bridge to [bus 07-07]
Apr 20 20:31:42 [kernel] pci 0000:05:02.0:   bridge window [mem pref
disabled]
Apr 20 20:31:42 [kernel] pci 0000:05:03.0: resource 9 [mem
0xf8e00000-0xf8efffff 64bit pref] released
Apr 20 20:31:42 [kernel] pci 0000:05:03.0: PCI bridge to [bus 06-06]
Apr 20 20:31:42 [kernel] pci 0000:05:03.0:   bridge window [mem pref
disabled]
Apr 20 20:31:42 [kernel] pci 0000:04:00.0: resource 9 [mem
0xf8e00000-0xf8ffffff 64bit pref] released
Apr 20 20:31:42 [kernel] pci 0000:04:00.0: PCI bridge to [bus 05-09]
Apr 20 20:31:42 [kernel] pci 0000:04:00.0:   bridge window [mem pref
disabled]
Apr 20 20:31:42 [kernel] release child resource [mem
0xfeae0000-0xfeafffff]
Apr 20 20:31:42 [kernel] pci 0000:00:1c.0: resource 8 [mem
0xfea00000-0xfeafffff] released
Apr 20 20:31:42 [kernel] pci 0000:00:1c.0: PCI bridge to [bus 04-09]
Apr 20 20:31:42 [kernel] pci 0000:00:1c.0:   bridge window [mem
disabled]
Apr 20 20:31:42 [kernel] pci 0000:00:1c.0: BAR 8: assigned [mem
0x80400000-0x816fffff]
Apr 20 20:31:42 [kernel] pci 0000:00:01.0: PCI bridge to [bus 01-01]
Apr 20 20:31:42 [kernel] pci 0000:00:01.0:   bridge window [io
0xa000-0xafff]
Apr 20 20:31:42 [kernel] pci 0000:00:01.0:   bridge window [mem
0xfa000000-0xfe7fffff]
Apr 20 20:31:42 [kernel] pci 0000:00:01.0:   bridge window [mem
0xd0000000-0xdfffffff 64bit pref]
Apr 20 20:31:42 [kernel] pci 0000:04:00.0: BAR 8: assigned [mem
0x80400000-0x80ffffff]
Apr 20 20:31:42 [kernel] pci 0000:04:00.0: BAR 9: assigned [mem
0x81000000-0x815fffff 64bit pref]
Apr 20 20:31:42 [kernel] pci 0000:04:00.0: BAR 0: assigned [mem
0x81600000-0x8161ffff]
Apr 20 20:31:42 [kernel] pci 0000:04:00.0: BAR 0: set to [mem
0x81600000-0x8161ffff] (PCI address [0x81600000-0x8161ffff]
Apr 20 20:31:42 [kernel] pci 0000:04:00.0: BAR 7: can't assign io (size
0x4000)
Apr 20 20:31:42 [kernel] pci 0000:05:01.0: BAR 8: assigned [mem
0x80400000-0x805fffff]
Apr 20 20:31:42 [kernel] pci 0000:05:01.0: BAR 9: assigned [mem
0x81000000-0x811fffff 64bit pref]
Apr 20 20:31:42 [kernel] pci 0000:05:02.0: BAR 8: assigned [mem
0x80600000-0x809fffff]
Apr 20 20:31:42 [kernel] pci 0000:05:02.0: BAR 9: assigned [mem
0x81200000-0x813fffff 64bit pref]
Apr 20 20:31:42 [kernel] pci 0000:05:03.0: BAR 8: assigned [mem
0x80a00000-0x80dfffff]
Apr 20 20:31:42 [kernel] pci 0000:05:03.0: BAR 9: assigned [mem
0x81400000-0x815fffff 64bit pref]
Apr 20 20:31:42 [kernel] pci 0000:05:01.0: BAR 7: can't assign io (size
0x2000)
Apr 20 20:31:42 [kernel] pci 0000:05:02.0: BAR 7: can't assign io (size
0x1000)
Apr 20 20:31:42 [kernel] pci 0000:05:03.0: BAR 7: can't assign io (size
0x1000)
Apr 20 20:31:42 [kernel] pci 0000:08:00.0: BAR 7: can't assign io (size
0x1000)
Apr 20 20:31:42 [kernel] pci 0000:09:04.0: BAR 0: can't assign io (size
0x100)
Apr 20 20:31:42 [kernel] pci 0000:08:00.0: PCI bridge to [bus 09-09]
Apr 20 20:31:42 [kernel] pci 0000:08:00.0:   bridge window [io
disabled]
Apr 20 20:31:42 [kernel] pci 0000:08:00.0:   bridge window [mem
disabled]
Apr 20 20:31:42 [kernel] pci 0000:08:00.0:   bridge window [mem pref
disabled]
Apr 20 20:31:42 [kernel] pci 0000:05:01.0: PCI bridge to [bus 08-09]
Apr 20 20:31:42 [kernel] pci 0000:05:01.0:   bridge window [io
disabled]
Apr 20 20:31:42 [kernel] pci 0000:05:01.0:   bridge window [mem
0x80400000-0x805fffff]
Apr 20 20:31:42 [kernel] pci 0000:05:01.0:   bridge window [mem
0x81000000-0x811fffff 64bit pref]
Apr 20 20:31:42 [kernel] pci 0000:05:02.0: PCI bridge to [bus 07-07]
Apr 20 20:31:42 [kernel] pci 0000:05:02.0:   bridge window [io
disabled]
Apr 20 20:31:42 [kernel] pci 0000:05:02.0:   bridge window [mem
0x80600000-0x809fffff]
Apr 20 20:31:42 [kernel] pci 0000:05:03.0: PCI bridge to [bus 06-06]
Apr 20 20:31:42 [kernel] pci 0000:05:03.0:   bridge window [mem
0x80a00000-0x80dfffff]
Apr 20 20:31:42 [kernel] pci 0000:05:03.0:   bridge window [mem
0x81400000-0x815fffff 64bit pref]
Apr 20 20:31:42 [kernel] pci 0000:04:00.0: PCI bridge to [bus 05-09]
Apr 20 20:31:42 [kernel] pci 0000:04:00.0:   bridge window [io
disabled]
Apr 20 20:31:42 [kernel] pci 0000:04:00.0:   bridge window [mem
0x80400000-0x80ffffff]
Apr 20 20:31:42 [kernel] pci 0000:04:00.0:   bridge window [mem
0x81000000-0x815fffff 64bit pref]
Apr 20 20:31:42 [kernel] pci 0000:00:1c.0: PCI bridge to [bus 04-09]
Apr 20 20:31:42 [kernel] pci 0000:00:1c.0:   bridge window [io
0xd000-0xdfff]
Apr 20 20:31:42 [kernel] pci 0000:00:1c.0:   bridge window [mem
0x80400000-0x816fffff]
Apr 20 20:31:42 [kernel] pci 0000:00:1c.0:   bridge window [mem
0xf8e00000-0xf8ffffff 64bit pref]
Apr 20 20:31:42 [kernel] pci 0000:00:1c.4: PCI bridge to [bus 03-03]
Apr 20 20:31:42 [kernel] pci 0000:00:1c.4:   bridge window [io
0xc000-0xcfff]
Apr 20 20:31:42 [kernel] pci 0000:00:1c.4:   bridge window [mem
0xfe900000-0xfe9fffff]
Apr 20 20:31:42 [kernel] pci 0000:00:1c.4:   bridge window [mem
0x80000000-0x801fffff 64bit pref]
Apr 20 20:31:42 [kernel] pci 0000:00:1c.5: PCI bridge to [bus 02-02]
Apr 20 20:31:42 [kernel] pci 0000:00:1c.5:   bridge window [io
0xb000-0xbfff]
Apr 20 20:31:42 [kernel] pci 0000:00:1c.5:   bridge window [mem
0xfe800000-0xfe8fffff]
Apr 20 20:31:42 [kernel] pci 0000:00:1c.5:   bridge window [mem
0x80200000-0x803fffff 64bit pref]
Apr 20 20:31:42 [kernel] pci 0000:00:1e.0: PCI bridge to [bus 0a-0a]
Apr 20 20:31:42 [kernel] pci 0000:00:1e.0:   bridge window [io
0xe000-0xefff]
Apr 20 20:31:42 [kernel] pci 0000:00:1e.0:   bridge window [mem
0xfeb00000-0xfebfffff]
Apr 20 20:31:42 [kernel] pci 0000:00:1e.0:   bridge window [mem pref
disabled]
Apr 20 20:31:42 [kernel] pci 0000:00:01.0: PCI INT A -> GSI 16 (level,
low) -> IRQ 16
Apr 20 20:31:42 [kernel] pci 0000:00:01.0: setting latency timer to 64
Apr 20 20:31:42 [kernel] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level,
low) -> IRQ 17
Apr 20 20:31:42 [kernel] pci 0000:00:1c.0: setting latency timer to 64
Apr 20 20:31:42 [kernel] pci 0000:04:00.0: PCI INT A -> GSI 16 (level,
low) -> IRQ 16
Apr 20 20:31:42 [kernel] pci 0000:04:00.0: setting latency timer to 64
Apr 20 20:31:42 [kernel] pci 0000:05:01.0: enabling device (0105 ->
0107)
Apr 20 20:31:42 [kernel] pci 0000:05:01.0: PCI INT A -> GSI 17 (level,
low) -> IRQ 17
Apr 20 20:31:42 [kernel] pci 0000:05:01.0: setting latency timer to 64
Apr 20 20:31:42 [kernel] pci 0000:08:00.0: PCI INT A -> GSI 17 (level,
low) -> IRQ 17
Apr 20 20:31:42 [kernel] pci 0000:08:00.0: setting latency timer to 64
Apr 20 20:31:42 [kernel] pci 0000:05:02.0: PCI INT A -> GSI 18 (level,
low) -> IRQ 18
Apr 20 20:31:42 [kernel] pci 0000:05:02.0: setting latency timer to 64
Apr 20 20:31:42 [kernel] pci 0000:05:03.0: PCI INT A -> GSI 19 (level,
low) -> IRQ 19
Apr 20 20:31:42 [kernel] pci 0000:05:03.0: setting latency timer to 64
Apr 20 20:31:42 [kernel] pci 0000:00:1c.4: PCI INT A -> GSI 17 (level,
low) -> IRQ 17
Apr 20 20:31:42 [kernel] pci 0000:00:1c.4: setting latency timer to 64
Apr 20 20:31:42 [kernel] pci 0000:00:1c.5: PCI INT B -> GSI 16 (level,
low) -> IRQ 16
Apr 20 20:31:42 [kernel] pci 0000:00:1c.5: setting latency timer to 64
Apr 20 20:31:42 [kernel] pci 0000:00:1e.0: setting latency timer to 64
Apr 20 20:31:42 [kernel] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
Apr 20 20:31:42 [kernel] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
Apr 20 20:31:42 [kernel] pci_bus 0000:00: resource 6 [mem
0x000a0000-0x000bffff]
Apr 20 20:31:42 [kernel] pci_bus 0000:00: resource 7 [mem
0x000d0000-0x000dffff]
Apr 20 20:31:42 [kernel] pci_bus 0000:00: resource 8 [mem
0x80000000-0xffffffff]
Apr 20 20:31:42 [kernel] pci_bus 0000:01: resource 0 [io  0xa000-0xafff]
Apr 20 20:31:42 [kernel] pci_bus 0000:01: resource 1 [mem
0xfa000000-0xfe7fffff]
Apr 20 20:31:42 [kernel] pci_bus 0000:01: resource 2 [mem
0xd0000000-0xdfffffff 64bit pref]
Apr 20 20:31:42 [kernel] pci_bus 0000:04: resource 0 [io  0xd000-0xdfff]
Apr 20 20:31:42 [kernel] pci_bus 0000:04: resource 1 [mem
0x80400000-0x816fffff]
Apr 20 20:31:42 [kernel] pci_bus 0000:04: resource 2 [mem
0xf8e00000-0xf8ffffff 64bit pref]
Apr 20 20:31:42 [kernel] pci_bus 0000:05: resource 1 [mem
0x80400000-0x80ffffff]
Apr 20 20:31:42 [kernel] pci_bus 0000:05: resource 2 [mem
0x81000000-0x815fffff 64bit pref]
Apr 20 20:31:42 [kernel] pci_bus 0000:08: resource 1 [mem
0x80400000-0x805fffff]
Apr 20 20:31:42 [kernel] pci_bus 0000:08: resource 2 [mem
0x81000000-0x811fffff 64bit pref]
Apr 20 20:31:42 [kernel] pci_bus 0000:07: resource 1 [mem
0x80600000-0x809fffff]
Apr 20 20:31:42 [kernel] pci_bus 0000:07: resource 2 [mem
0x81200000-0x813fffff 64bit pref]
Apr 20 20:31:42 [kernel] pci_bus 0000:06: resource 1 [mem
0x80a00000-0x80dfffff]
Apr 20 20:31:42 [kernel] pci_bus 0000:06: resource 2 [mem
0x81400000-0x815fffff 64bit pref]
Apr 20 20:31:42 [kernel] pci_bus 0000:03: resource 0 [io  0xc000-0xcfff]
Apr 20 20:31:42 [kernel] pci_bus 0000:03: resource 1 [mem
0xfe900000-0xfe9fffff]
Apr 20 20:31:42 [kernel] pci_bus 0000:03: resource 2 [mem
0x80000000-0x801fffff 64bit pref]
Apr 20 20:31:42 [kernel] pci_bus 0000:02: resource 0 [io  0xb000-0xbfff]
Apr 20 20:31:42 [kernel] pci_bus 0000:02: resource 1 [mem
0xfe800000-0xfe8fffff]
Apr 20 20:31:42 [kernel] pci_bus 0000:02: resource 2 [mem
0x80200000-0x803fffff 64bit pref]
Apr 20 20:31:42 [kernel] pci_bus 0000:0a: resource 0 [io  0xe000-0xefff]
Apr 20 20:31:42 [kernel] pci_bus 0000:0a: resource 5 [io  0x0d00-0xffff]
Apr 20 20:31:42 [kernel] pci_bus 0000:0a: resource 6 [mem
0x000a0000-0x000bffff]
Apr 20 20:31:42 [kernel] pci_bus 0000:0a: resource 7 [mem
0x000d0000-0x000dffff]
Apr 20 20:31:42 [kernel] pci_bus 0000:0a: resource 8 [mem
0x80000000-0xffffffff]
Apr 20 20:31:42 [kernel] NET: Registered protocol family 2
Apr 20 20:31:42 [kernel] IP route cache hash table entries: 32768
(order: 5, 131072 bytes)
Apr 20 20:31:42 [kernel] TCP established hash table entries: 131072
(order: 8, 1048576 bytes)
Apr 20 20:31:42 [kernel] TCP bind hash table entries: 65536 (order: 7,
524288 bytes)
Apr 20 20:31:42 [kernel] TCP: Hash tables configured (established 131072
bind 65536)
Apr 20 20:31:42 [kernel] TCP reno registered
Apr 20 20:31:42 [kernel] UDP hash table entries: 512 (order: 2, 16384
bytes)
Apr 20 20:31:42 [kernel] UDP-Lite hash table entries: 512 (order: 2,
16384 bytes)
Apr 20 20:31:42 [kernel] NET: Registered protocol family 1
Apr 20 20:31:42 [kernel] pci 0000:00:00.0: calling quirk_e100_interrupt
+0x0/0x14a
Apr 20 20:31:42 [kernel] pci 0000:00:00.0: calling quirk_cardbus_legacy
+0x0/0x1d
Apr 20 20:31:42 [kernel] pci 0000:00:00.0: calling
quirk_usb_early_handoff+0x0/0x4ea
Apr 20 20:31:42 [kernel] pci 0000:00:00.0: calling pci_fixup_video
+0x0/0x91
Apr 20 20:31:42 [kernel] pci 0000:00:01.0: calling quirk_e100_interrupt
+0x0/0x14a
Apr 20 20:31:42 [kernel] pci 0000:00:01.0: calling quirk_cardbus_legacy
+0x0/0x1d
Apr 20 20:31:42 [kernel] pci 0000:00:01.0: calling
quirk_usb_early_handoff+0x0/0x4ea
Apr 20 20:31:42 [kernel] pci 0000:00:01.0: calling pci_fixup_video
+0x0/0x91
Apr 20 20:31:42 [kernel] pci 0000:00:1a.0: calling quirk_e100_interrupt
+0x0/0x14a
Apr 20 20:31:42 [kernel] pci 0000:00:1a.0: calling quirk_cardbus_legacy
+0x0/0x1d
Apr 20 20:31:42 [kernel] pci 0000:00:1a.0: calling
quirk_usb_early_handoff+0x0/0x4ea
Apr 20 20:31:42 [kernel] pci 0000:00:1a.0: uhci_check_and_reset_hc:
legsup = 0x0f30
Apr 20 20:31:42 [kernel] pci 0000:00:1a.0: Performing full reset
Apr 20 20:31:42 [kernel] pci 0000:00:1a.0: calling pci_fixup_video
+0x0/0x91
Apr 20 20:31:42 [kernel] pci 0000:00:1a.1: calling quirk_e100_interrupt
+0x0/0x14a
Apr 20 20:31:42 [kernel] pci 0000:00:1a.1: calling quirk_cardbus_legacy
+0x0/0x1d
Apr 20 20:31:42 [kernel] pci 0000:00:1a.1: calling
quirk_usb_early_handoff+0x0/0x4ea
Apr 20 20:31:42 [kernel] pci 0000:00:1a.1: uhci_check_and_reset_hc:
legsup = 0x0030
Apr 20 20:31:42 [kernel] pci 0000:00:1a.1: Performing full reset
Apr 20 20:31:42 [kernel] pci 0000:00:1a.1: calling pci_fixup_video
+0x0/0x91
Apr 20 20:31:42 [kernel] pci 0000:00:1a.2: calling quirk_e100_interrupt
+0x0/0x14a
Apr 20 20:31:42 [kernel] pci 0000:00:1a.2: calling quirk_cardbus_legacy
+0x0/0x1d
Apr 20 20:31:42 [kernel] pci 0000:00:1a.2: calling
quirk_usb_early_handoff+0x0/0x4ea
Apr 20 20:31:42 [kernel] pci 0000:00:1a.2: uhci_check_and_reset_hc:
legsup = 0x0030
Apr 20 20:31:42 [kernel] pci 0000:00:1a.2: Performing full reset
Apr 20 20:31:42 [kernel] pci 0000:00:1a.2: calling pci_fixup_video
+0x0/0x91
Apr 20 20:31:42 [kernel] pci 0000:00:1a.7: calling quirk_e100_interrupt
+0x0/0x14a
Apr 20 20:31:42 [kernel] pci 0000:00:1a.7: calling quirk_cardbus_legacy
+0x0/0x1d
Apr 20 20:31:42 [kernel] pci 0000:00:1a.7: calling
quirk_usb_early_handoff+0x0/0x4ea
Apr 20 20:31:42 [kernel] pci 0000:00:1a.7: calling pci_fixup_video
+0x0/0x91
Apr 20 20:31:42 [kernel] pci 0000:00:1b.0: calling quirk_e100_interrupt
+0x0/0x14a
Apr 20 20:31:42 [kernel] pci 0000:00:1b.0: calling quirk_cardbus_legacy
+0x0/0x1d
Apr 20 20:31:42 [kernel] pci 0000:00:1b.0: calling
quirk_usb_early_handoff+0x0/0x4ea
Apr 20 20:31:42 [kernel] pci 0000:00:1b.0: calling pci_fixup_video
+0x0/0x91
Apr 20 20:31:42 [kernel] pci 0000:00:1c.0: calling quirk_e100_interrupt
+0x0/0x14a
Apr 20 20:31:42 [kernel] pci 0000:00:1c.0: calling quirk_cardbus_legacy
+0x0/0x1d
Apr 20 20:31:42 [kernel] pci 0000:00:1c.0: calling
quirk_usb_early_handoff+0x0/0x4ea
Apr 20 20:31:42 [kernel] pci 0000:00:1c.0: calling pci_fixup_video
+0x0/0x91
Apr 20 20:31:42 [kernel] pci 0000:00:1c.4: calling quirk_e100_interrupt
+0x0/0x14a
Apr 20 20:31:42 [kernel] pci 0000:00:1c.4: calling quirk_cardbus_legacy
+0x0/0x1d
Apr 20 20:31:42 [kernel] pci 0000:00:1c.4: calling
quirk_usb_early_handoff+0x0/0x4ea
Apr 20 20:31:42 [kernel] pci 0000:00:1c.4: calling pci_fixup_video
+0x0/0x91
Apr 20 20:31:42 [kernel] pci 0000:00:1c.5: calling quirk_e100_interrupt
+0x0/0x14a
Apr 20 20:31:42 [kernel] pci 0000:00:1c.5: calling quirk_cardbus_legacy
+0x0/0x1d
Apr 20 20:31:42 [kernel] pci 0000:00:1c.5: calling
quirk_usb_early_handoff+0x0/0x4ea
Apr 20 20:31:42 [kernel] pci 0000:00:1c.5: calling pci_fixup_video
+0x0/0x91
Apr 20 20:31:42 [kernel] pci 0000:00:1d.0: calling quirk_e100_interrupt
+0x0/0x14a
Apr 20 20:31:42 [kernel] pci 0000:00:1d.0: calling quirk_cardbus_legacy
+0x0/0x1d
Apr 20 20:31:42 [kernel] pci 0000:00:1d.0: calling
quirk_usb_early_handoff+0x0/0x4ea
Apr 20 20:31:42 [kernel] pci 0000:00:1d.0: uhci_check_and_reset_hc:
legsup = 0x0f30
Apr 20 20:31:42 [kernel] pci 0000:00:1d.0: Performing full reset
Apr 20 20:31:42 [kernel] pci 0000:00:1d.0: calling pci_fixup_video
+0x0/0x91
Apr 20 20:31:42 [kernel] pci 0000:00:1d.1: calling quirk_e100_interrupt
+0x0/0x14a
Apr 20 20:31:42 [kernel] pci 0000:00:1d.1: calling quirk_cardbus_legacy
+0x0/0x1d
Apr 20 20:31:42 [kernel] pci 0000:00:1d.1: calling
quirk_usb_early_handoff+0x0/0x4ea
Apr 20 20:31:42 [kernel] pci 0000:00:1d.1: uhci_check_and_reset_hc:
legsup = 0x0030
Apr 20 20:31:42 [kernel] pci 0000:00:1d.1: Performing full reset
Apr 20 20:31:42 [kernel] pci 0000:00:1d.1: calling pci_fixup_video
+0x0/0x91
Apr 20 20:31:42 [kernel] pci 0000:00:1d.2: calling quirk_cardbus_legacy
+0x0/0x1d
Apr 20 20:31:42 [kernel] pci 0000:00:1d.2: calling
quirk_usb_early_handoff+0x0/0x4ea
Apr 20 20:31:42 [kernel] pci 0000:00:1d.2: uhci_check_and_reset_hc:
legsup = 0x0030
Apr 20 20:31:42 [kernel] pci 0000:00:1d.2: Performing full reset
Apr 20 20:31:42 [kernel] pci 0000:00:1d.2: calling pci_fixup_video
+0x0/0x91
Apr 20 20:31:42 [kernel] pci 0000:00:1d.7: calling quirk_e100_interrupt
+0x0/0x14a
Apr 20 20:31:42 [kernel] pci 0000:00:1d.7: calling quirk_cardbus_legacy
+0x0/0x1d
Apr 20 20:31:42 [kernel] pci 0000:00:1d.7: calling
quirk_usb_early_handoff+0x0/0x4ea
Apr 20 20:31:42 [kernel] pci 0000:00:1d.7: calling pci_fixup_video
+0x0/0x91
Apr 20 20:31:42 [kernel] pci 0000:00:1e.0: calling quirk_e100_interrupt
+0x0/0x14a
Apr 20 20:31:42 [kernel] pci 0000:00:1e.0: calling quirk_cardbus_legacy
+0x0/0x1d
Apr 20 20:31:42 [kernel] pci 0000:00:1e.0: calling
quirk_usb_early_handoff+0x0/0x4ea
Apr 20 20:31:42 [kernel] pci 0000:00:1e.0: calling pci_fixup_video
+0x0/0x91
Apr 20 20:31:42 [kernel] pci 0000:00:1f.0: calling quirk_e100_interrupt
+0x0/0x14a
Apr 20 20:31:42 [kernel] pci 0000:00:1f.0: calling quirk_cardbus_legacy
+0x0/0x1d
Apr 20 20:31:42 [kernel] pci 0000:00:1f.0: calling
quirk_usb_early_handoff+0x0/0x4ea
Apr 20 20:31:42 [kernel] pci 0000:00:1f.0: calling pci_fixup_video
+0x0/0x91
Apr 20 20:31:42 [kernel] pci 0000:00:1f.2: calling quirk_e100_interrupt
+0x0/0x14a
Apr 20 20:31:42 [kernel] pci 0000:00:1f.2: calling quirk_cardbus_legacy
+0x0/0x1d
Apr 20 20:31:42 [kernel] pci 0000:00:1f.2: calling
quirk_usb_early_handoff+0x0/0x4ea
Apr 20 20:31:42 [kernel] pci 0000:00:1f.2: calling pci_fixup_video
+0x0/0x91
Apr 20 20:31:42 [kernel] pci 0000:00:1f.3: calling quirk_e100_interrupt
+0x0/0x14a
Apr 20 20:31:42 [kernel] pci 0000:00:1f.3: calling quirk_cardbus_legacy
+0x0/0x1d
Apr 20 20:31:42 [kernel] pci 0000:00:1f.3: calling
quirk_usb_early_handoff+0x0/0x4ea
Apr 20 20:31:42 [kernel] pci 0000:00:1f.3: calling pci_fixup_video
+0x0/0x91
Apr 20 20:31:42 [kernel] pci 0000:01:00.0: calling quirk_cardbus_legacy
+0x0/0x1d
Apr 20 20:31:42 [kernel] pci 0000:01:00.0: calling
quirk_usb_early_handoff+0x0/0x4ea
Apr 20 20:31:42 [kernel] pci 0000:01:00.0: calling pci_fixup_video
+0x0/0x91
Apr 20 20:31:42 [kernel] pci 0000:01:00.0: Boot video device
Apr 20 20:31:42 [kernel] pci 0000:04:00.0: calling quirk_cardbus_legacy
+0x0/0x1d
Apr 20 20:31:42 [kernel] pci 0000:04:00.0: calling
quirk_usb_early_handoff+0x0/0x4ea
Apr 20 20:31:42 [kernel] pci 0000:04:00.0: calling pci_fixup_video
+0x0/0x91
Apr 20 20:31:42 [kernel] pci 0000:05:01.0: calling quirk_cardbus_legacy
+0x0/0x1d
Apr 20 20:31:42 [kernel] pci 0000:05:01.0: calling
quirk_usb_early_handoff+0x0/0x4ea
Apr 20 20:31:42 [kernel] pci 0000:05:01.0: calling pci_fixup_video
+0x0/0x91
Apr 20 20:31:42 [kernel] pci 0000:05:02.0: calling quirk_cardbus_legacy
+0x0/0x1d
Apr 20 20:31:42 [kernel] pci 0000:05:02.0: calling
quirk_usb_early_handoff+0x0/0x4ea
Apr 20 20:31:42 [kernel] pci 0000:05:02.0: calling pci_fixup_video
+0x0/0x91
Apr 20 20:31:42 [kernel] pci 0000:05:03.0: calling quirk_cardbus_legacy
+0x0/0x1d
Apr 20 20:31:42 [kernel] pci 0000:05:03.0: calling
quirk_usb_early_handoff+0x0/0x4ea
Apr 20 20:31:42 [kernel] pci 0000:05:03.0: calling pci_fixup_video
+0x0/0x91
Apr 20 20:31:42 [kernel] pci 0000:08:00.0: calling quirk_cardbus_legacy
+0x0/0x1d
Apr 20 20:31:42 [kernel] pci 0000:08:00.0: calling
quirk_usb_early_handoff+0x0/0x4ea
Apr 20 20:31:42 [kernel] pci 0000:08:00.0: calling pci_fixup_video
+0x0/0x91
Apr 20 20:31:42 [kernel] pci 0000:09:04.0: calling quirk_cardbus_legacy
+0x0/0x1d
Apr 20 20:31:42 [kernel] pci 0000:09:04.0: calling
quirk_usb_early_handoff+0x0/0x4ea
Apr 20 20:31:42 [kernel] pci 0000:09:04.0: calling pci_fixup_video
+0x0/0x91
Apr 20 20:31:42 [kernel] pci 0000:03:00.0: calling quirk_cardbus_legacy
+0x0/0x1d
Apr 20 20:31:42 [kernel] pci 0000:03:00.0: calling
quirk_usb_early_handoff+0x0/0x4ea
Apr 20 20:31:42 [kernel] pci 0000:03:00.0: calling pci_fixup_video
+0x0/0x91
Apr 20 20:31:42 [kernel] pci 0000:02:00.0: calling quirk_cardbus_legacy
+0x0/0x1d
Apr 20 20:31:42 [kernel] pci 0000:02:00.0: calling
quirk_usb_early_handoff+0x0/0x4ea
Apr 20 20:31:42 [kernel] pci 0000:02:00.0: calling pci_fixup_video
+0x0/0x91
Apr 20 20:31:42 [kernel] pci 0000:0a:04.0: calling quirk_cardbus_legacy
+0x0/0x1d
Apr 20 20:31:42 [kernel] pci 0000:0a:04.0: calling
quirk_usb_early_handoff+0x0/0x4ea
Apr 20 20:31:42 [kernel] pci 0000:0a:04.0: calling pci_fixup_video
+0x0/0x91
Apr 20 20:31:42 [kernel] PCI: CLS 32 bytes, default 64
Apr 20 20:31:42 [kernel] microcode: CPU0 sig=0x10677, pf=0x10,
revision=0x703
Apr 20 20:31:42 [kernel] microcode: CPU1 sig=0x10677, pf=0x10,
revision=0x703
Apr 20 20:31:42 [kernel] microcode: CPU2 sig=0x10677, pf=0x10,
revision=0x703
Apr 20 20:31:42 [kernel] microcode: CPU3 sig=0x10677, pf=0x10,
revision=0x703
Apr 20 20:31:42 [kernel] microcode: Microcode Update Driver: v2.00
<tigran@aivazian.fsnet.co.uk>, Peter Oruba
Apr 20 20:31:42 [kernel] Scanning for low memory corruption every 60
seconds
Apr 20 20:31:42 [kernel] highmem bounce pool size: 64 pages
Apr 20 20:31:42 [kernel] HugeTLB registered 4 MB page size,
pre-allocated 0 pages
Apr 20 20:31:42 [kernel] Slow work thread pool: Starting up
Apr 20 20:31:42 [kernel] Slow work thread pool: Ready
Apr 20 20:31:42 [kernel] fuse init (API version 7.13)
Apr 20 20:31:42 [kernel] msgmni has been set to 1728
Apr 20 20:31:42 [kernel] alg: No test for stdrng (krng)
Apr 20 20:31:42 [kernel] Block layer SCSI generic (bsg) driver version
0.4 loaded (major 253)
Apr 20 20:31:42 [kernel] io scheduler noop registered
Apr 20 20:31:42 [kernel] io scheduler cfq registered (default)
Apr 20 20:31:42 [kernel] pcieport 0000:00:1c.0: setting latency timer to
64
Apr 20 20:31:42 [kernel] pcieport 0000:00:1c.4: setting latency timer to
64
Apr 20 20:31:42 [kernel] pcieport 0000:00:1c.5: setting latency timer to
64
Apr 20 20:31:42 [kernel] pcieport 0000:04:00.0: setting latency timer to
64
Apr 20 20:31:42 [kernel] pcieport 0000:05:01.0: setting latency timer to
64
Apr 20 20:31:42 [kernel] pcieport 0000:05:02.0: setting latency timer to
64
Apr 20 20:31:42 [kernel] pcieport 0000:05:03.0: setting latency timer to
64
Apr 20 20:31:42 [kernel] input: Power Button
as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
Apr 20 20:31:42 [kernel] ACPI: Power Button [PWRB]
Apr 20 20:31:42 [kernel] input: Power Button
as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
Apr 20 20:31:42 [kernel] ACPI: Power Button [PWRF]
Apr 20 20:31:42 [kernel] Non-volatile memory driver v1.3
Apr 20 20:31:42 [kernel] Linux agpgart interface v0.103
Apr 20 20:31:42 [kernel] [drm] Initialized drm 1.1.0 20060810
Apr 20 20:31:42 [kernel] nouveau 0000:01:00.0: PCI INT A -> GSI 16
(level, low) -> IRQ 16
Apr 20 20:31:42 [kernel] nouveau 0000:01:00.0: setting latency timer to
64
Apr 20 20:31:42 [kernel] [drm] nouveau 0000:01:00.0: Detected an NV50
generation card (0x0a0300b1)
Apr 20 20:31:42 [kernel] [drm] nouveau 0000:01:00.0: Attempting to load
BIOS image from PRAMIN
Apr 20 20:31:42 [kernel] [drm] nouveau 0000:01:00.0: ... appears to be
valid
Apr 20 20:31:42 [kernel] [drm] nouveau 0000:01:00.0: BIT BIOS found
Apr 20 20:31:42 [kernel] [drm] nouveau 0000:01:00.0: Bios version
62.00.59.00
Apr 20 20:31:42 [kernel] [drm] nouveau 0000:01:00.0: TMDS table revision
2.0 not currently supported
Apr 20 20:31:42 [kernel] [drm] nouveau 0000:01:00.0: Found Display
Configuration Block version 4.0
Apr 20 20:31:42 [kernel] [drm] nouveau 0000:01:00.0: Raw DCB entry 0:
04000320 00000028
Apr 20 20:31:42 [kernel] [drm] nouveau 0000:01:00.0: Raw DCB entry 1:
01000322 00020030
Apr 20 20:31:42 [kernel] [drm] nouveau 0000:01:00.0: Raw DCB entry 2:
02011310 00000028
Apr 20 20:31:42 [kernel] [drm] nouveau 0000:01:00.0: Raw DCB entry 3:
02011312 00020030
Apr 20 20:31:42 [kernel] [drm] nouveau 0000:01:00.0: Raw DCB entry 4:
010223f1 00c1c023
Apr 20 20:31:42 [kernel] [drm] nouveau 0000:01:00.0: DCB connector
table: VHER 0x40 5 16 4
Apr 20 20:31:42 [kernel] [drm] nouveau 0000:01:00.0:   0: 0x00001030:
type 0x30 idx 0 tag 0x07
Apr 20 20:31:42 [kernel] [drm] nouveau 0000:01:00.0:   1: 0x00002130:
type 0x30 idx 1 tag 0x08
Apr 20 20:31:42 [kernel] [drm] nouveau 0000:01:00.0:   2: 0x00000210:
type 0x10 idx 2 tag 0xff
Apr 20 20:31:42 [kernel] [drm] nouveau 0000:01:00.0:   3: 0x00000211:
type 0x11 idx 3 tag 0xff
Apr 20 20:31:42 [kernel] [drm] nouveau 0000:01:00.0:   4: 0x00000213:
type 0x13 idx 4 tag 0xff
Apr 20 20:31:42 [kernel] [drm] nouveau 0000:01:00.0:   5: 0x00000360:
type 0x60 idx 5 tag 0xff
Apr 20 20:31:42 [kernel] [drm] nouveau 0000:01:00.0: Parsing VBIOS init
table 0 at offset 0xD113
Apr 20 20:31:42 [kernel] [drm] nouveau 0000:01:00.0: Parsing VBIOS init
table 1 at offset 0xD53E
Apr 20 20:31:42 [kernel] [drm] nouveau 0000:01:00.0: Parsing VBIOS init
table 2 at offset 0xE9DB
Apr 20 20:31:42 [kernel] [drm] nouveau 0000:01:00.0: Parsing VBIOS init
table 3 at offset 0xEAB8
Apr 20 20:31:42 [kernel] [drm] nouveau 0000:01:00.0: Parsing VBIOS init
table 4 at offset 0xEB8A
Apr 20 20:31:42 [kernel] [drm] nouveau 0000:01:00.0: Parsing VBIOS init
table at offset 0xEBEF
Apr 20 20:31:42 [kernel] [drm] nouveau 0000:01:00.0: 0xEBEF: Condition
still not met after 20ms, skipping following opcodes
Apr 20 20:31:42 [kernel] [drm] nouveau 0000:01:00.0: 0xC0A4: parsing
output script 0
                - Last output repeated twice -
Apr 20 20:31:42 [kernel] [drm] nouveau 0000:01:00.0: 0xA642: parsing
output script 0
Apr 20 20:31:42 [kernel] [drm] nouveau 0000:01:00.0: Detected 896MiB
VRAM
Apr 20 20:31:42 [kernel] [TTM] Zone  kernel: Available graphics memory:
442590 kiB.
Apr 20 20:31:42 [kernel] [TTM] Zone highmem: Available graphics memory:
1036130 kiB.
Apr 20 20:31:42 [kernel] [drm] nouveau 0000:01:00.0: 512 MiB GART
(aperture)
Apr 20 20:31:42 [kernel] [drm] nouveau 0000:01:00.0: Allocating FIFO
number 1
Apr 20 20:31:42 [kernel] [drm] nouveau 0000:01:00.0:
nouveau_channel_alloc: initialised FIFO 1
Apr 20 20:31:42 [kernel] [drm] nouveau 0000:01:00.0: Detected a DAC
output
Apr 20 20:31:42 [kernel] [drm] nouveau 0000:01:00.0: Detected a TMDS
output
Apr 20 20:31:42 [kernel] [drm] nouveau 0000:01:00.0: Detected a DAC
output
Apr 20 20:31:42 [kernel] [drm] nouveau 0000:01:00.0: Detected a TMDS
output
Apr 20 20:31:42 [kernel] [drm] nouveau 0000:01:00.0: DCB encoder 1
unknown
Apr 20 20:31:42 [kernel] [drm] nouveau 0000:01:00.0: Detected a DVI-I
connector
                - Last output repeated twice -
Apr 20 20:31:42 [kernel] [drm] nouveau 0000:01:00.0: Detected a TV
connector
Apr 20 20:31:42 [kernel] [drm] nouveau 0000:01:00.0:   no encoders,
ignoring
Apr 20 20:31:42 [kernel] [drm] nouveau 0000:01:00.0: Detected a HDMI
connector
Apr 20 20:31:42 [kernel] [drm] nouveau 0000:01:00.0:   no encoders,
ignoring
Apr 20 20:31:42 [kernel] [drm] nouveau 0000:01:00.0: allocated 1920x1200
fb: 0x40250000, bo f68c4e00
Apr 20 20:31:42 [kernel] [drm] nouveau 0000:01:00.0: 0xC0A8: parsing
output script 1
Apr 20 20:31:42 [kernel] [drm] nouveau 0000:01:00.0: 0xC0A9: parsing
output script 2
Apr 20 20:31:42 [kernel] Console: switching to colour frame buffer
device 240x75
Apr 20 20:31:42 [kernel] fb0: nouveaufb frame buffer device
Apr 20 20:31:42 [kernel] registered panic notifier
Apr 20 20:31:42 [kernel] [drm] Initialized nouveau 0.0.16 20090420 for
0000:01:00.0 on minor 0
Apr 20 20:31:42 [kernel] Serial: 8250/16550 driver, 4 ports, IRQ sharing
enabled
Apr 20 20:31:42 [kernel] brd: module loaded
Apr 20 20:31:42 [kernel] loop: module loaded
Apr 20 20:31:42 [kernel] ahci 0000:00:1f.2: version 3.0
Apr 20 20:31:42 [kernel] ahci 0000:00:1f.2: PCI INT B -> GSI 22 (level,
low) -> IRQ 22
Apr 20 20:31:42 [kernel] ahci: SSS flag set, parallel bus scan disabled
Apr 20 20:31:42 [kernel] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6
ports 3 Gbps 0x3f impl SATA mode
Apr 20 20:31:42 [kernel] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag
pm led clo pmp pio slum part ccc ems sxs 
Apr 20 20:31:42 [kernel] ahci 0000:00:1f.2: setting latency timer to 64
Apr 20 20:31:42 [kernel] scsi0 : ahci
Apr 20 20:31:42 [kernel] scsi1 : ahci
Apr 20 20:31:42 [kernel] scsi2 : ahci
Apr 20 20:31:42 [kernel] scsi3 : ahci
Apr 20 20:31:42 [kernel] scsi4 : ahci
Apr 20 20:31:42 [kernel] scsi5 : ahci
Apr 20 20:31:42 [kernel] ata1: SATA max UDMA/133 abar m2048@0xf9ffe800
port 0xf9ffe900 irq 22
Apr 20 20:31:42 [kernel] ata2: SATA max UDMA/133 irq_stat 0x00400040,
connection status changed irq 22
Apr 20 20:31:42 [kernel] ata3: SATA max UDMA/133 abar m2048@0xf9ffe800
port 0xf9ffea00 irq 22
Apr 20 20:31:42 [kernel] ata4: SATA max UDMA/133 irq_stat 0x00400040,
connection status changed
Apr 20 20:31:42 [kernel] ata5: SATA max UDMA/133 irq_stat 0x00400040,
connection status changed
Apr 20 20:31:42 [kernel] ata6: SATA max UDMA/133 irq_stat 0x00400040,
connection status changed
Apr 20 20:31:42 [kernel] ahci 0000:03:00.0: PCI INT A -> GSI 16 (level,
low) -> IRQ 16
Apr 20 20:31:42 [kernel] ahci 0000:03:00.0: controller can't do NCQ,
turning off CAP_NCQ
Apr 20 20:31:42 [kernel] ahci 0000:03:00.0: controller can't do PMP,
turning off CAP_PMP
Apr 20 20:31:42 [kernel] ahci 0000:03:00.0: MV_AHCI HACK: port_map 1f ->
f
Apr 20 20:31:42 [kernel] ahci 0000:03:00.0: Disabling your PATA port.
Use the boot option 'ahci.marvell_enable=0' to avoid this.
Apr 20 20:31:42 [kernel] ahci: SSS flag set, parallel bus scan disabled
Apr 20 20:31:42 [kernel] ahci 0000:03:00.0: AHCI 0001.0000 32 slots 5
ports 3 Gbps 0xf impl IDE mode
Apr 20 20:31:42 [kernel] ahci 0000:03:00.0: flags: 64bit stag slum part 
Apr 20 20:31:42 [kernel] ahci 0000:03:00.0: setting latency timer to 64
Apr 20 20:31:42 [kernel] scsi6 : ahci
Apr 20 20:31:42 [kernel] scsi7 : ahci
Apr 20 20:31:42 [kernel] scsi8 : ahci
Apr 20 20:31:42 [kernel] scsi9 : ahci
Apr 20 20:31:42 [kernel] scsi10 : ahci
Apr 20 20:31:42 [kernel] ata7: SATA max UDMA/133 abar m1024@0xfe9ffc00
port 0xfe9ffd00 irq 16
Apr 20 20:31:42 [kernel] ata8: SATA max UDMA/133 abar m1024@0xfe9ffc00
port 0xfe9ffd80 irq 16
Apr 20 20:31:42 [kernel] ata9: SATA max UDMA/133 abar m1024@0xfe9ffc00
port 0xfe9ffe00 irq 16
Apr 20 20:31:42 [kernel] ata10: SATA max UDMA/133 abar m1024@0xfe9ffc00
port 0xfe9ffe80 irq 16
Apr 20 20:31:42 [kernel] ata11: DUMMY
Apr 20 20:31:42 [kernel] skge 0000:0a:04.0: PCI INT A -> GSI 19 (level,
low) -> IRQ 19
Apr 20 20:31:42 [kernel] skge: 1.13 addr 0xfebfc000 irq 19 chip
Yukon-Lite rev 9
Apr 20 20:31:42 [kernel] skge 0000:0a:04.0: eth0: addr 00:1f:c6:5c:93:38
Apr 20 20:31:42 [kernel] sky2: driver version 1.27
Apr 20 20:31:42 [kernel] sky2 0000:02:00.0: PCI INT A -> GSI 17 (level,
low) -> IRQ 17
Apr 20 20:31:42 [kernel] sky2 0000:02:00.0: setting latency timer to 64
Apr 20 20:31:42 [kernel] sky2 0000:02:00.0: Yukon-2 EC Ultra chip
revision 3
Apr 20 20:31:42 [kernel] sky2 0000:02:00.0: eth1: addr 00:1f:c6:5c:94:1f
Apr 20 20:31:42 [kernel] usbmon: debugfs is not available
Apr 20 20:31:42 [kernel] ehci_hcd: USB 2.0 'Enhanced' Host Controller
(EHCI) Driver
Apr 20 20:31:42 [kernel] ehci_hcd: block sizes: qh 60 qtd 96 itd 160
sitd 96
Apr 20 20:31:42 [kernel] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18
(level, low) -> IRQ 18
Apr 20 20:31:42 [kernel] ehci_hcd 0000:00:1a.7: setting latency timer to
64
Apr 20 20:31:42 [kernel] ehci_hcd 0000:00:1a.7: EHCI Host Controller
Apr 20 20:31:42 [kernel] drivers/usb/core/inode.c: creating file
'devices'
Apr 20 20:31:42 [kernel] drivers/usb/core/inode.c: creating file '001'
Apr 20 20:31:42 [kernel] ehci_hcd 0000:00:1a.7: new USB bus registered,
assigned bus number 1
Apr 20 20:31:42 [kernel] ehci_hcd 0000:00:1a.7: reset hcs_params
0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
Apr 20 20:31:42 [kernel] ehci_hcd 0000:00:1a.7: reset hcc_params 16871
thresh 7 uframes 1024 64 bit addr
Apr 20 20:31:42 [kernel] ehci_hcd 0000:00:1a.7: debug port 1
Apr 20 20:31:42 [kernel] ehci_hcd 0000:00:1a.7: reset command 080002
(park)=0 ithresh=8 period=1024 Reset HALT
Apr 20 20:31:42 [kernel] ehci_hcd 0000:00:1a.7: cache line size of 32 is
not supported
Apr 20 20:31:42 [kernel] ehci_hcd 0000:00:1a.7: supports USB remote
wakeup
Apr 20 20:31:42 [kernel] ehci_hcd 0000:00:1a.7: irq 18, io mem
0xf9fffc00
Apr 20 20:31:42 [kernel] ehci_hcd 0000:00:1a.7: reset command 080002
(park)=0 ithresh=8 period=1024 Reset HALT
Apr 20 20:31:42 [kernel] ehci_hcd 0000:00:1a.7: init command 010001
(park)=0 ithresh=1 period=1024 RUN
Apr 20 20:31:42 [kernel] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI
1.00
Apr 20 20:31:42 [kernel] usb usb1: default language 0x0409
Apr 20 20:31:42 [kernel] usb usb1: udev 1, busnum 1, minor = 0
Apr 20 20:31:42 [kernel] usb usb1: New USB device found, idVendor=1d6b,
idProduct=0002
Apr 20 20:31:42 [kernel] usb usb1: New USB device strings: Mfr=3,
Product=2, SerialNumber=1
Apr 20 20:31:42 [kernel] usb usb1: SerialNumber: 0000:00:1a.7
Apr 20 20:31:42 [kernel] usb usb1: usb_probe_device
Apr 20 20:31:42 [kernel] usb usb1: configuration #1 chosen from 1 choice
Apr 20 20:31:42 [kernel] usb usb1: adding 1-0:1.0 (config #1, interface
0)
Apr 20 20:31:42 [kernel] hub 1-0:1.0: usb_probe_interface
Apr 20 20:31:42 [kernel] hub 1-0:1.0: usb_probe_interface - got id
Apr 20 20:31:42 [kernel] hub 1-0:1.0: USB hub found
Apr 20 20:31:42 [kernel] hub 1-0:1.0: 6 ports detected
Apr 20 20:31:42 [kernel] hub 1-0:1.0: standalone hub
Apr 20 20:31:42 [kernel] hub 1-0:1.0: no power switching (usb 1.0)
Apr 20 20:31:42 [kernel] hub 1-0:1.0: individual port over-current
protection
Apr 20 20:31:42 [kernel] hub 1-0:1.0: power on to power good time: 20ms
Apr 20 20:31:42 [kernel] hub 1-0:1.0: local power source is good
Apr 20 20:31:42 [kernel] hub 1-0:1.0: trying to enable port power on
non-switchable hub
Apr 20 20:31:42 [kernel] drivers/usb/core/inode.c: creating file '001'
Apr 20 20:31:42 [kernel] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23
(level, low) -> IRQ 23
Apr 20 20:31:42 [kernel] ehci_hcd 0000:00:1d.7: setting latency timer to
64
Apr 20 20:31:42 [kernel] ehci_hcd 0000:00:1d.7: EHCI Host Controller
Apr 20 20:31:42 [kernel] drivers/usb/core/inode.c: creating file '002'
Apr 20 20:31:42 [kernel] ehci_hcd 0000:00:1d.7: new USB bus registered,
assigned bus number 2
Apr 20 20:31:42 [kernel] ehci_hcd 0000:00:1d.7: reset hcs_params
0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
Apr 20 20:31:42 [kernel] ehci_hcd 0000:00:1d.7: reset hcc_params 16871
thresh 7 uframes 1024 64 bit addr
Apr 20 20:31:42 [kernel] ehci_hcd 0000:00:1d.7: debug port 1
Apr 20 20:31:42 [kernel] ehci_hcd 0000:00:1d.7: reset command 080002
(park)=0 ithresh=8 period=1024 Reset HALT
Apr 20 20:31:42 [kernel] ehci_hcd 0000:00:1d.7: cache line size of 32 is
not supported
Apr 20 20:31:42 [kernel] ehci_hcd 0000:00:1d.7: supports USB remote
wakeup
Apr 20 20:31:42 [kernel] ehci_hcd 0000:00:1d.7: irq 23, io mem
0xf9fff800
Apr 20 20:31:42 [kernel] ehci_hcd 0000:00:1d.7: reset command 080002
(park)=0 ithresh=8 period=1024 Reset HALT
Apr 20 20:31:42 [kernel] ehci_hcd 0000:00:1d.7: init command 010001
(park)=0 ithresh=1 period=1024 RUN
Apr 20 20:31:42 [kernel] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI
1.00
Apr 20 20:31:42 [kernel] usb usb2: default language 0x0409
Apr 20 20:31:42 [kernel] usb usb2: udev 1, busnum 2, minor = 128
Apr 20 20:31:42 [kernel] usb usb2: New USB device found, idVendor=1d6b,
idProduct=0002
Apr 20 20:31:42 [kernel] usb usb2: New USB device strings: Mfr=3,
Product=2, SerialNumber=1
Apr 20 20:31:42 [kernel] usb usb2: Product: EHCI Host Controller
Apr 20 20:31:42 [kernel] usb usb2: Manufacturer: Linux 2.6.34-rc4
ehci_hcd
Apr 20 20:31:42 [kernel] usb usb2: SerialNumber: 0000:00:1d.7
Apr 20 20:31:42 [kernel] usb usb2: usb_probe_device
Apr 20 20:31:42 [kernel] usb usb2: configuration #1 chosen from 1 choice
Apr 20 20:31:42 [kernel] usb usb2: adding 2-0:1.0 (config #1, interface
0)
Apr 20 20:31:42 [kernel] hub 2-0:1.0: usb_probe_interface
Apr 20 20:31:42 [kernel] hub 2-0:1.0: usb_probe_interface - got id
Apr 20 20:31:42 [kernel] hub 2-0:1.0: USB hub found
Apr 20 20:31:42 [kernel] hub 2-0:1.0: 6 ports detected
Apr 20 20:31:42 [kernel] hub 2-0:1.0: standalone hub
Apr 20 20:31:42 [kernel] hub 2-0:1.0: no power switching (usb 1.0)
Apr 20 20:31:42 [kernel] hub 2-0:1.0: individual port over-current
protection
Apr 20 20:31:42 [kernel] hub 2-0:1.0: power on to power good time: 20ms
Apr 20 20:31:42 [kernel] hub 2-0:1.0: local power source is good
Apr 20 20:31:42 [kernel] hub 2-0:1.0: trying to enable port power on
non-switchable hub
Apr 20 20:31:42 [kernel] drivers/usb/core/inode.c: creating file '001'
Apr 20 20:31:42 [kernel] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI)
Driver
Apr 20 20:31:42 [kernel] ohci_hcd: block sizes: ed 64 td 64
Apr 20 20:31:42 [kernel] uhci_hcd: USB Universal Host Controller
Interface driver
Apr 20 20:31:42 [kernel] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16
(level, low) -> IRQ 16
Apr 20 20:31:42 [kernel] uhci_hcd 0000:00:1a.0: setting latency timer to
64
Apr 20 20:31:42 [kernel] uhci_hcd 0000:00:1a.0: UHCI Host Controller
Apr 20 20:31:42 [kernel] drivers/usb/core/inode.c: creating file '003'
Apr 20 20:31:42 [kernel] uhci_hcd 0000:00:1a.0: new USB bus registered,
assigned bus number 3
Apr 20 20:31:42 [kernel] uhci_hcd 0000:00:1a.0: detected 2 ports
Apr 20 20:31:42 [kernel] uhci_hcd 0000:00:1a.0: uhci_check_and_reset_hc:
cmd = 0x0000
Apr 20 20:31:42 [kernel] uhci_hcd 0000:00:1a.0: Performing full reset
Apr 20 20:31:42 [kernel] uhci_hcd 0000:00:1a.0: supports USB remote
wakeup
Apr 20 20:31:42 [kernel] uhci_hcd 0000:00:1a.0: irq 16, io base
0x00009800
Apr 20 20:31:42 [kernel] usb usb3: default language 0x0409
Apr 20 20:31:42 [kernel] usb usb3: udev 1, busnum 3, minor = 256
Apr 20 20:31:42 [kernel] usb usb3: New USB device found, idVendor=1d6b,
idProduct=0001
Apr 20 20:31:42 [kernel] usb usb3: New USB device strings: Mfr=3,
Product=2, SerialNumber=1
Apr 20 20:31:42 [kernel] usb usb3: Product: UHCI Host Controller
Apr 20 20:31:42 [kernel] usb usb3: Manufacturer: Linux 2.6.34-rc4
uhci_hcd
Apr 20 20:31:42 [kernel] usb usb3: SerialNumber: 0000:00:1a.0
Apr 20 20:31:42 [kernel] usb usb3: usb_probe_device
Apr 20 20:31:42 [kernel] usb usb3: configuration #1 chosen from 1 choice
Apr 20 20:31:42 [kernel] usb usb3: adding 3-0:1.0 (config #1, interface
0)
Apr 20 20:31:42 [kernel] hub 3-0:1.0: usb_probe_interface
Apr 20 20:31:42 [kernel] hub 3-0:1.0: usb_probe_interface - got id
Apr 20 20:31:42 [kernel] hub 3-0:1.0: USB hub found
Apr 20 20:31:42 [kernel] hub 3-0:1.0: 2 ports detected
Apr 20 20:31:42 [kernel] hub 3-0:1.0: standalone hub
Apr 20 20:31:42 [kernel] hub 3-0:1.0: no power switching (usb 1.0)
Apr 20 20:31:42 [kernel] drivers/usb/core/inode.c: creating file '001'
Apr 20 20:31:42 [kernel] ehci_hcd 0000:00:1a.7: HS companion for
0000:00:1a.0
Apr 20 20:31:42 [kernel] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21
(level, low) -> IRQ 21
Apr 20 20:31:42 [kernel] uhci_hcd 0000:00:1a.1: setting latency timer to
64
Apr 20 20:31:42 [kernel] uhci_hcd 0000:00:1a.1: UHCI Host Controller
Apr 20 20:31:42 [kernel] drivers/usb/core/inode.c: creating file '004'
Apr 20 20:31:42 [kernel] uhci_hcd 0000:00:1a.1: new USB bus registered,
assigned bus number 4
Apr 20 20:31:42 [kernel] uhci_hcd 0000:00:1a.1: detected 2 ports
Apr 20 20:31:42 [kernel] uhci_hcd 0000:00:1a.1: uhci_check_and_reset_hc:
cmd = 0x0000
Apr 20 20:31:42 [kernel] uhci_hcd 0000:00:1a.1: Performing full reset
Apr 20 20:31:42 [kernel] uhci_hcd 0000:00:1a.1: supports USB remote
wakeup
Apr 20 20:31:42 [kernel] uhci_hcd 0000:00:1a.1: irq 21, io base
0x00009880
Apr 20 20:31:42 [kernel] usb usb4: default language 0x0409
Apr 20 20:31:42 [kernel] usb usb4: udev 1, busnum 4, minor = 384
Apr 20 20:31:42 [kernel] usb usb4: New USB device found, idVendor=1d6b,
idProduct=0001
Apr 20 20:31:42 [kernel] usb usb4: New USB device strings: Mfr=3,
Product=2, SerialNumber=1
Apr 20 20:31:42 [kernel] usb usb4: Product: UHCI Host Controller
Apr 20 20:31:42 [kernel] usb usb4: Manufacturer: Linux 2.6.34-rc4
uhci_hcd
Apr 20 20:31:42 [kernel] usb usb4: SerialNumber: 0000:00:1a.1
Apr 20 20:31:42 [kernel] usb usb4: usb_probe_device
Apr 20 20:31:42 [kernel] usb usb4: configuration #1 chosen from 1 choice
Apr 20 20:31:42 [kernel] usb usb4: adding 4-0:1.0 (config #1, interface
0)
Apr 20 20:31:42 [kernel] hub 4-0:1.0: usb_probe_interface
Apr 20 20:31:42 [kernel] hub 4-0:1.0: usb_probe_interface - got id
Apr 20 20:31:42 [kernel] hub 4-0:1.0: USB hub found
Apr 20 20:31:42 [kernel] hub 4-0:1.0: 2 ports detected
Apr 20 20:31:42 [kernel] hub 4-0:1.0: standalone hub
Apr 20 20:31:42 [kernel] hub 4-0:1.0: no power switching (usb 1.0)
Apr 20 20:31:42 [kernel] hub 4-0:1.0: individual port over-current
protection
Apr 20 20:31:42 [kernel] hub 4-0:1.0: power on to power good time: 2ms
Apr 20 20:31:42 [kernel] hub 4-0:1.0: local power source is good
Apr 20 20:31:42 [kernel] hub 4-0:1.0: trying to enable port power on
non-switchable hub
Apr 20 20:31:42 [kernel] drivers/usb/core/inode.c: creating file '001'
Apr 20 20:31:42 [kernel] ehci_hcd 0000:00:1a.7: HS companion for
0000:00:1a.1
Apr 20 20:31:42 [kernel] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 18
(level, low) -> IRQ 18
Apr 20 20:31:42 [kernel] uhci_hcd 0000:00:1a.2: setting latency timer to
64
Apr 20 20:31:42 [kernel] uhci_hcd 0000:00:1a.2: UHCI Host Controller
Apr 20 20:31:42 [kernel] drivers/usb/core/inode.c: creating file '005'
Apr 20 20:31:42 [kernel] uhci_hcd 0000:00:1a.2: new USB bus registered,
assigned bus number 5
Apr 20 20:31:42 [kernel] uhci_hcd 0000:00:1a.2: detected 2 ports
Apr 20 20:31:42 [kernel] uhci_hcd 0000:00:1a.2: uhci_check_and_reset_hc:
cmd = 0x0000
Apr 20 20:31:42 [kernel] uhci_hcd 0000:00:1a.2: Performing full reset
Apr 20 20:31:42 [kernel] uhci_hcd 0000:00:1a.2: supports USB remote
wakeup
Apr 20 20:31:42 [kernel] uhci_hcd 0000:00:1a.2: irq 18, io base
0x00009c00
Apr 20 20:31:42 [kernel] usb usb5: default language 0x0409
Apr 20 20:31:42 [kernel] usb usb5: udev 1, busnum 5, minor = 512
Apr 20 20:31:42 [kernel] usb usb5: New USB device found, idVendor=1d6b,
idProduct=0001
Apr 20 20:31:42 [kernel] usb usb5: New USB device strings: Mfr=3,
Product=2, SerialNumber=1
Apr 20 20:31:42 [kernel] usb usb5: Product: UHCI Host Controller
Apr 20 20:31:42 [kernel] usb usb5: Manufacturer: Linux 2.6.34-rc4
uhci_hcd
Apr 20 20:31:42 [kernel] usb usb5: SerialNumber: 0000:00:1a.2
Apr 20 20:31:42 [kernel] usb usb5: usb_probe_device
Apr 20 20:31:42 [kernel] usb usb5: configuration #1 chosen from 1 choice
Apr 20 20:31:42 [kernel] usb usb5: adding 5-0:1.0 (config #1, interface
0)
Apr 20 20:31:42 [kernel] hub 5-0:1.0: usb_probe_interface
Apr 20 20:31:42 [kernel] hub 5-0:1.0: usb_probe_interface - got id
Apr 20 20:31:42 [kernel] hub 5-0:1.0: USB hub found
Apr 20 20:31:42 [kernel] hub 5-0:1.0: 2 ports detected
Apr 20 20:31:42 [kernel] hub 5-0:1.0: standalone hub
Apr 20 20:31:42 [kernel] hub 5-0:1.0: no power switching (usb 1.0)
Apr 20 20:31:42 [kernel] hub 5-0:1.0: individual port over-current
protection
Apr 20 20:31:42 [kernel] hub 5-0:1.0: power on to power good time: 2ms
Apr 20 20:31:42 [kernel] hub 5-0:1.0: local power source is good
Apr 20 20:31:42 [kernel] hub 5-0:1.0: trying to enable port power on
non-switchable hub
Apr 20 20:31:42 [kernel] drivers/usb/core/inode.c: creating file '001'
Apr 20 20:31:42 [kernel] ehci_hcd 0000:00:1a.7: HS companion for
0000:00:1a.2
Apr 20 20:31:42 [kernel] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23
(level, low) -> IRQ 23
Apr 20 20:31:42 [kernel] uhci_hcd 0000:00:1d.0: setting latency timer to
64
Apr 20 20:31:42 [kernel] uhci_hcd 0000:00:1d.0: UHCI Host Controller
Apr 20 20:31:42 [kernel] drivers/usb/core/inode.c: creating file '006'
Apr 20 20:31:42 [kernel] uhci_hcd 0000:00:1d.0: new USB bus registered,
assigned bus number 6
Apr 20 20:31:42 [kernel] uhci_hcd 0000:00:1d.0: detected 2 ports
Apr 20 20:31:42 [kernel] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc:
cmd = 0x0000
Apr 20 20:31:42 [kernel] uhci_hcd 0000:00:1d.0: Performing full reset
Apr 20 20:31:42 [kernel] uhci_hcd 0000:00:1d.0: supports USB remote
wakeup
Apr 20 20:31:42 [kernel] uhci_hcd 0000:00:1d.0: irq 23, io base
0x00009080
Apr 20 20:31:42 [kernel] usb usb6: default language 0x0409
Apr 20 20:31:42 [kernel] usb usb6: udev 1, busnum 6, minor = 640
Apr 20 20:31:42 [kernel] usb usb6: New USB device found, idVendor=1d6b,
idProduct=0001
Apr 20 20:31:42 [kernel] usb usb6: New USB device strings: Mfr=3,
Product=2, SerialNumber=1
Apr 20 20:31:42 [kernel] usb usb6: Product: UHCI Host Controller
Apr 20 20:31:42 [kernel] usb usb6: SerialNumber: 0000:00:1d.0
Apr 20 20:31:42 [kernel] usb usb6: usb_probe_device
Apr 20 20:31:42 [kernel] usb usb6: configuration #1 chosen from 1 choice
Apr 20 20:31:42 [kernel] usb usb6: adding 6-0:1.0 (config #1, interface
0)
Apr 20 20:31:42 [kernel] hub 6-0:1.0: usb_probe_interface
Apr 20 20:31:42 [kernel] hub 6-0:1.0: usb_probe_interface - got id
Apr 20 20:31:42 [kernel] hub 6-0:1.0: USB hub found
Apr 20 20:31:42 [kernel] hub 6-0:1.0: 2 ports detected
Apr 20 20:31:42 [kernel] hub 6-0:1.0: standalone hub
Apr 20 20:31:42 [kernel] hub 6-0:1.0: no power switching (usb 1.0)
Apr 20 20:31:42 [kernel] hub 6-0:1.0: individual port over-current
protection
Apr 20 20:31:42 [kernel] hub 6-0:1.0: power on to power good time: 2ms
Apr 20 20:31:42 [kernel] hub 6-0:1.0: local power source is good
Apr 20 20:31:42 [kernel] hub 6-0:1.0: trying to enable port power on
non-switchable hub
Apr 20 20:31:42 [kernel] drivers/usb/core/inode.c: creating file '001'
Apr 20 20:31:42 [kernel] ehci_hcd 0000:00:1d.7: HS companion for
0000:00:1d.0
Apr 20 20:31:42 [kernel] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19
(level, low) -> IRQ 19
Apr 20 20:31:42 [kernel] uhci_hcd 0000:00:1d.1: setting latency timer to
64
Apr 20 20:31:42 [kernel] uhci_hcd 0000:00:1d.1: UHCI Host Controller
Apr 20 20:31:42 [kernel] drivers/usb/core/inode.c: creating file '007'
Apr 20 20:31:42 [kernel] uhci_hcd 0000:00:1d.1: new USB bus registered,
assigned bus number 7
Apr 20 20:31:42 [kernel] uhci_hcd 0000:00:1d.1: detected 2 ports
Apr 20 20:31:42 [kernel] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc:
cmd = 0x0000
Apr 20 20:31:42 [kernel] uhci_hcd 0000:00:1d.1: Performing full reset
Apr 20 20:31:42 [kernel] uhci_hcd 0000:00:1d.1: supports USB remote
wakeup
Apr 20 20:31:42 [kernel] uhci_hcd 0000:00:1d.1: irq 19, io base
0x00009400
Apr 20 20:31:42 [kernel] usb usb7: default language 0x0409
Apr 20 20:31:42 [kernel] usb usb7: udev 1, busnum 7, minor = 768
Apr 20 20:31:42 [kernel] usb usb7: New USB device found, idVendor=1d6b,
idProduct=0001
Apr 20 20:31:42 [kernel] usb usb7: New USB device strings: Mfr=3,
Product=2, SerialNumber=1
Apr 20 20:31:42 [kernel] usb usb7: Product: UHCI Host Controller
Apr 20 20:31:42 [kernel] usb usb7: Manufacturer: Linux 2.6.34-rc4
uhci_hcd
Apr 20 20:31:42 [kernel] usb usb7: SerialNumber: 0000:00:1d.1
Apr 20 20:31:42 [kernel] usb usb7: usb_probe_device
Apr 20 20:31:42 [kernel] usb usb7: configuration #1 chosen from 1 choice
Apr 20 20:31:42 [kernel] usb usb7: adding 7-0:1.0 (config #1, interface
0)
Apr 20 20:31:42 [kernel] hub 7-0:1.0: usb_probe_interface
Apr 20 20:31:42 [kernel] hub 7-0:1.0: usb_probe_interface - got id
Apr 20 20:31:42 [kernel] hub 7-0:1.0: USB hub found
Apr 20 20:31:42 [kernel] hub 7-0:1.0: 2 ports detected
Apr 20 20:31:42 [kernel] hub 7-0:1.0: standalone hub
Apr 20 20:31:42 [kernel] hub 7-0:1.0: no power switching (usb 1.0)
Apr 20 20:31:42 [kernel] hub 7-0:1.0: individual port over-current
protection
Apr 20 20:31:42 [kernel] hub 7-0:1.0: power on to power good time: 2ms
Apr 20 20:31:42 [kernel] hub 7-0:1.0: local power source is good
Apr 20 20:31:42 [kernel] hub 7-0:1.0: trying to enable port power on
non-switchable hub
Apr 20 20:31:42 [kernel] drivers/usb/core/inode.c: creating file '001'
Apr 20 20:31:42 [kernel] ehci_hcd 0000:00:1d.7: HS companion for
0000:00:1d.1
Apr 20 20:31:42 [kernel] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18
(level, low) -> IRQ 18
Apr 20 20:31:42 [kernel] uhci_hcd 0000:00:1d.2: setting latency timer to
64
Apr 20 20:31:42 [kernel] uhci_hcd 0000:00:1d.2: UHCI Host Controller
Apr 20 20:31:42 [kernel] drivers/usb/core/inode.c: creating file '008'
Apr 20 20:31:42 [kernel] uhci_hcd 0000:00:1d.2: new USB bus registered,
assigned bus number 8
Apr 20 20:31:42 [kernel] uhci_hcd 0000:00:1d.2: detected 2 ports
Apr 20 20:31:42 [kernel] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc:
cmd = 0x0000
Apr 20 20:31:42 [kernel] uhci_hcd 0000:00:1d.2: Performing full reset
Apr 20 20:31:42 [kernel] uhci_hcd 0000:00:1d.2: supports USB remote
wakeup
Apr 20 20:31:42 [kernel] uhci_hcd 0000:00:1d.2: irq 18, io base
0x00009480
Apr 20 20:31:42 [kernel] usb usb8: default language 0x0409
Apr 20 20:31:42 [kernel] usb usb8: udev 1, busnum 8, minor = 896
Apr 20 20:31:42 [kernel] usb usb8: New USB device found, idVendor=1d6b,
idProduct=0001
Apr 20 20:31:42 [kernel] usb usb8: New USB device strings: Mfr=3,
Product=2, SerialNumber=1
Apr 20 20:31:42 [kernel] usb usb8: Product: UHCI Host Controller
Apr 20 20:31:42 [kernel] usb usb8: Manufacturer: Linux 2.6.34-rc4
uhci_hcd
Apr 20 20:31:42 [kernel] usb usb8: SerialNumber: 0000:00:1d.2
Apr 20 20:31:42 [kernel] hub 1-0:1.0: state 7 ports 6 chg 0000 evt 0000
Apr 20 20:31:42 [kernel] usb usb8: usb_probe_device
Apr 20 20:31:42 [kernel] usb usb8: configuration #1 chosen from 1 choice
Apr 20 20:31:42 [kernel] usb usb8: adding 8-0:1.0 (config #1, interface
0)
Apr 20 20:31:42 [kernel] hub 8-0:1.0: usb_probe_interface
Apr 20 20:31:42 [kernel] hub 8-0:1.0: usb_probe_interface - got id
Apr 20 20:31:42 [kernel] hub 8-0:1.0: USB hub found
Apr 20 20:31:42 [kernel] hub 8-0:1.0: 2 ports detected
Apr 20 20:31:42 [kernel] hub 8-0:1.0: standalone hub
Apr 20 20:31:42 [kernel] hub 8-0:1.0: no power switching (usb 1.0)
Apr 20 20:31:42 [kernel] hub 8-0:1.0: individual port over-current
protection
Apr 20 20:31:42 [kernel] hub 8-0:1.0: power on to power good time: 2ms
Apr 20 20:31:42 [kernel] hub 8-0:1.0: local power source is good
Apr 20 20:31:42 [kernel] hub 8-0:1.0: trying to enable port power on
non-switchable hub
Apr 20 20:31:42 [kernel] drivers/usb/core/inode.c: creating file '001'
Apr 20 20:31:42 [kernel] ehci_hcd 0000:00:1d.7: HS companion for
0000:00:1d.2
Apr 20 20:31:42 [kernel] usbcore: registered new interface driver usblp
Apr 20 20:31:42 [kernel] Initializing USB Mass Storage driver...
Apr 20 20:31:42 [kernel] usbcore: registered new interface driver
libusual
Apr 20 20:31:42 [kernel] PNP: PS/2 Controller [PNP0303:PS2K] at
0x60,0x64 irq 1
Apr 20 20:31:42 [kernel] PNP: PS/2 appears to have AUX port disabled, if
this is incorrect please boot with i8042.nopnp
Apr 20 20:31:42 [kernel] serio: i8042 KBD port at 0x60,0x64 irq 1
Apr 20 20:31:42 [kernel] mice: PS/2 mouse device common for all mice
Apr 20 20:31:42 [kernel] rtc_cmos 00:03: RTC can wake from S4
Apr 20 20:31:42 [kernel] rtc_cmos 00:03: rtc core: registered rtc_cmos
as rtc0
Apr 20 20:31:42 [kernel] rtc0: alarms up to one month, y3k, 114 bytes
nvram, hpet irqs
Apr 20 20:31:42 [kernel] i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18
(level, low) -> IRQ 18
Apr 20 20:31:42 [kernel] ACPI: resource 0000:00:1f.3 [io  0x0400-0x041f]
conflicts with ACPI region SMRG [??? 0x00000400-0x0000040f flags 0x47]
Apr 20 20:31:42 [kernel] ACPI: If an ACPI driver is available for this
device, you should use it instead of the native driver
Apr 20 20:31:42 [kernel] md: raid0 personality registered for level 0
Apr 20 20:31:42 [kernel] md: raid1 personality registered for level 1
Apr 20 20:31:42 [kernel] Bluetooth: Broadcom Blutonium firmware driver
ver 1.2
Apr 20 20:31:42 [kernel] usbcore: registered new interface driver
bcm203x
Apr 20 20:31:42 [kernel] Bluetooth: Generic Bluetooth USB driver ver 0.6
Apr 20 20:31:42 [kernel] usbcore: registered new interface driver btusb
Apr 20 20:31:42 [kernel] cpuidle: using governor ladder
Apr 20 20:31:42 [kernel] cpuidle: using governor menu
Apr 20 20:31:42 [kernel] wacom driver registered
Apr 20 20:31:42 [kernel] ehci_hcd 0000:00:1d.7: GetStatus port 1 status
001803 POWER sig=j CSC CONNECT
Apr 20 20:31:42 [kernel] hub 2-0:1.0: port 1: status 0501 change 0001
Apr 20 20:31:42 [kernel] ehci_hcd 0000:00:1d.7: GetStatus port 2 status
001403 POWER sig=k CSC CONNECT
Apr 20 20:31:42 [kernel] usbcore: registered new interface driver hiddev
Apr 20 20:31:42 [kernel] usbcore: registered new interface driver usbhid
Apr 20 20:31:42 [kernel] usbhid: USB HID core driver
Apr 20 20:31:42 [kernel] AV200 0000:09:04.0: PCI INT A -> GSI 17 (level,
low) -> IRQ 17
Apr 20 20:31:42 [kernel] ALSA sound/pci/oxygen/oxygen_lib.c:582: invalid
PCI I/O range
Apr 20 20:31:42 [kernel] AV200 0000:09:04.0: PCI INT A disabled
Apr 20 20:31:42 [kernel] ALSA device list:
Apr 20 20:31:42 [kernel]   No soundcards found.
Apr 20 20:31:42 [kernel] Netfilter messages via NETLINK v0.30.
Apr 20 20:31:42 [kernel] nf_conntrack version 0.5.0 (16384 buckets,
65536 max)
Apr 20 20:31:42 [kernel] ctnetlink v0.93: registering with nfnetlink.
Apr 20 20:31:42 [kernel] ip_tables: (C) 2000-2006 Netfilter Core Team
Apr 20 20:31:42 [kernel] TCP cubic registered
Apr 20 20:31:42 [kernel] Initializing XFRM netlink socket
Apr 20 20:31:42 [kernel] NET: Registered protocol family 10
Apr 20 20:31:42 [kernel] ip6_tables: (C) 2000-2006 Netfilter Core Team
Apr 20 20:31:42 [kernel] IPv6 over IPv4 tunneling driver
Apr 20 20:31:42 [kernel] NET: Registered protocol family 17
Apr 20 20:31:42 [kernel] Bluetooth: L2CAP ver 2.14
Apr 20 20:31:42 [kernel] Bluetooth: L2CAP socket layer initialized
Apr 20 20:31:42 [kernel] Bluetooth: SCO (Voice Link) ver 0.6
Apr 20 20:31:42 [kernel] Bluetooth: SCO socket layer initialized
Apr 20 20:31:42 [kernel] Bluetooth: RFCOMM socket layer initialized
Apr 20 20:31:42 [kernel] Bluetooth: RFCOMM ver 1.11
Apr 20 20:31:42 [kernel] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
Apr 20 20:31:42 [kernel] Bluetooth: HIDP (Human Interface Emulation) ver
1.2
Apr 20 20:31:42 [kernel] Using IPI No-Shortcut mode
Apr 20 20:31:42 [kernel] hub 2-0:1.0: port 2: status 0501 change 0001
Apr 20 20:31:42 [kernel] ehci_hcd 0000:00:1d.7: GetStatus port 3 status
001803 POWER sig=j CSC CONNECT
Apr 20 20:31:42 [kernel] hub 2-0:1.0: port 3: status 0501 change 0001
Apr 20 20:31:42 [kernel] ehci_hcd 0000:00:1d.7: GetStatus port 4 status
001803 POWER sig=j CSC CONNECT
Apr 20 20:31:42 [kernel] hub 2-0:1.0: port 4: status 0501 change 0001
Apr 20 20:31:42 [kernel] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
Apr 20 20:31:42 [kernel] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
Apr 20 20:31:42 [kernel] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
Apr 20 20:31:42 [kernel] uhci_hcd 0000:00:1d.0: port 1 portsc 008a,00
Apr 20 20:31:42 [kernel] uhci_hcd 0000:00:1d.0: port 2 portsc 008a,00
Apr 20 20:31:42 [kernel] uhci_hcd 0000:00:1d.1: port 1 portsc 0082,00
Apr 20 20:31:42 [kernel] uhci_hcd 0000:00:1d.1: port 2 portsc 0082,00
Apr 20 20:31:42 [kernel] hub 8-0:1.0: state 7 ports 2 chg 0000 evt 0000
Apr 20 20:31:42 [kernel] hub 2-0:1.0: state 7 ports 6 chg 001e evt 0000
Apr 20 20:31:42 [kernel] hub 2-0:1.0: port 1, status 0501, change 0000,
480 Mb/s
Apr 20 20:31:42 [kernel] ata7: SATA link down (SStatus 0 SControl 300)
Apr 20 20:31:42 [kernel] ehci_hcd 0000:00:1d.7: port 1 full speed -->
companion
Apr 20 20:31:42 [kernel] ehci_hcd 0000:00:1d.7: GetStatus port 1 status
003801 POWER OWNER sig=j CONNECT
Apr 20 20:31:42 [kernel] hub 2-0:1.0: port 1 not reset yet, waiting 50ms
Apr 20 20:31:42 [kernel] ehci_hcd 0000:00:1d.7: GetStatus port 1 status
003002 POWER OWNER sig=se0 CSC
Apr 20 20:31:42 [kernel] hub 2-0:1.0: port 2, status 0501, change 0000,
480 Mb/s
Apr 20 20:31:42 [kernel] ehci_hcd 0000:00:1d.7: port 2 low speed -->
companion
Apr 20 20:31:42 [kernel] ehci_hcd 0000:00:1d.7: GetStatus port 2 status
003002 POWER OWNER sig=se0 CSC
Apr 20 20:31:42 [kernel] hub 2-0:1.0: port 3, status 0501, change 0000,
480 Mb/s
Apr 20 20:31:42 [kernel] ata1: SATA link up 3.0 Gbps (SStatus 123
SControl 300)
Apr 20 20:31:42 [kernel] ata1.00: ATA-7: INTEL SSDSA2M080G2GC, 2CV102HD,
max UDMA/133
Apr 20 20:31:42 [kernel] ata1.00: 156301488 sectors, multi 1: LBA48 NCQ
(depth 31/32)
Apr 20 20:31:42 [kernel] sd 0:0:0:0: [sda] 156301488 512-byte logical
blocks: (80.0 GB/74.5 GiB)
Apr 20 20:31:42 [kernel] sd 0:0:0:0: Attached scsi generic sg0 type 0
Apr 20 20:31:42 [kernel] sd 0:0:0:0: [sda] Write Protect is off
Apr 20 20:31:42 [kernel] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Apr 20 20:31:42 [kernel] sd 0:0:0:0: [sda] Write cache: enabled, read
cache: enabled, doesn't support DPO or FUA
Apr 20 20:31:42 [kernel]  sda: sda1 sda2 sda3
Apr 20 20:31:42 [kernel] sd 0:0:0:0: [sda] Attached SCSI disk
Apr 20 20:31:42 [kernel] ehci_hcd 0000:00:1d.7: port 3 full speed -->
companion
Apr 20 20:31:42 [kernel] ehci_hcd 0000:00:1d.7: GetStatus port 3 status
003801 POWER OWNER sig=j CONNECT
Apr 20 20:31:42 [kernel] hub 2-0:1.0: port 3 not reset yet, waiting 50ms
Apr 20 20:31:42 [kernel] ehci_hcd 0000:00:1d.7: GetStatus port 3 status
003002 POWER OWNER sig=se0 CSC
Apr 20 20:31:42 [kernel] hub 2-0:1.0: port 4, status 0501, change 0000,
480 Mb/s
Apr 20 20:31:42 [kernel] ehci_hcd 0000:00:1d.7: port 4 high speed
Apr 20 20:31:42 [kernel] ehci_hcd 0000:00:1d.7: GetStatus port 4 status
001005 POWER sig=se0 PE CONNECT
Apr 20 20:31:42 [kernel] usb 2-4: new high speed USB device using
ehci_hcd and address 5
Apr 20 20:31:42 [kernel] ehci_hcd 0000:00:1d.7: port 4 high speed
Apr 20 20:31:42 [kernel] ehci_hcd 0000:00:1d.7: GetStatus port 4 status
001005 POWER sig=se0 PE CONNECT
Apr 20 20:31:42 [kernel] usb 2-4: udev 5, busnum 2, minor = 132
Apr 20 20:31:42 [kernel] usb 2-4: New USB device found, idVendor=0424,
idProduct=2504
Apr 20 20:31:42 [kernel] usb 2-4: New USB device strings: Mfr=0,
Product=0, SerialNumber=0
Apr 20 20:31:42 [kernel] usb 2-4: usb_probe_device
Apr 20 20:31:42 [kernel] usb 2-4: configuration #1 chosen from 1 choice
Apr 20 20:31:42 [kernel] usb 2-4: adding 2-4:1.0 (config #1, interface
0)
Apr 20 20:31:42 [kernel] hub 2-4:1.0: usb_probe_interface
Apr 20 20:31:42 [kernel] hub 2-4:1.0: usb_probe_interface - got id
Apr 20 20:31:42 [kernel] hub 2-4:1.0: USB hub found
Apr 20 20:31:42 [kernel] hub 2-4:1.0: 4 ports detected
Apr 20 20:31:42 [kernel] hub 2-4:1.0: standalone hub
Apr 20 20:31:42 [kernel] hub 2-4:1.0: ganged power switching
Apr 20 20:31:42 [kernel] hub 2-4:1.0: global over-current protection
Apr 20 20:31:42 [kernel] hub 2-4:1.0: TT per port
Apr 20 20:31:42 [kernel] hub 2-4:1.0: TT requires at most 8 FS bit times
(666 ns)
Apr 20 20:31:42 [kernel] hub 2-4:1.0: power on to power good time: 100ms
Apr 20 20:31:42 [kernel] hub 2-4:1.0: local power source is good
Apr 20 20:31:42 [kernel] hub 2-4:1.0: no over-current condition exists
Apr 20 20:31:42 [kernel] hub 2-4:1.0: enabling power on all ports
Apr 20 20:31:42 [kernel] drivers/usb/core/inode.c: creating file '005'
Apr 20 20:31:42 [kernel] hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0006
Apr 20 20:31:42 [kernel] uhci_hcd 0000:00:1d.0: port 1 portsc 0093,00
Apr 20 20:31:42 [kernel] hub 6-0:1.0: port 1, status 0101, change 0001,
12 Mb/s
Apr 20 20:31:42 [kernel] usb 2-4: link qh256-0001/f6a1f740 start 1 [1/0
us]
Apr 20 20:31:42 [kernel] hub 6-0:1.0: debounce: port 1: total 100ms
stable 100ms status 0x101
Apr 20 20:31:42 [kernel] usb 6-1: new full speed USB device using
uhci_hcd and address 2
Apr 20 20:31:42 [kernel] usb 6-1: ep0 maxpacket = 8
Apr 20 20:31:42 [kernel] usb 6-1: skipped 1 descriptor after interface
                - Last output repeated twice -
Apr 20 20:31:42 [kernel] usb 6-1: default language 0x0409
Apr 20 20:31:42 [kernel] usb 6-1: udev 2, busnum 6, minor = 641
Apr 20 20:31:42 [kernel] usb 6-1: New USB device found, idVendor=046d,
idProduct=c041
Apr 20 20:31:42 [kernel] usb 6-1: New USB device strings: Mfr=1,
Product=2, SerialNumber=0
Apr 20 20:31:42 [kernel] usb 6-1: Product: USB Gaming Mouse
Apr 20 20:31:42 [kernel] usb 6-1: Manufacturer: Logitech
Apr 20 20:31:42 [kernel] usb 6-1: usb_probe_device
Apr 20 20:31:42 [kernel] usb 6-1: configuration #1 chosen from 1 choice
Apr 20 20:31:42 [kernel] usb 6-1: adding 6-1:1.0 (config #1, interface
0)
Apr 20 20:31:42 [kernel] usbhid 6-1:1.0: usb_probe_interface
Apr 20 20:31:42 [kernel] usbhid 6-1:1.0: usb_probe_interface - got id
Apr 20 20:31:42 [kernel] usb usb3: suspend_rh (auto-stop)
Apr 20 20:31:42 [kernel] usb usb4: suspend_rh (auto-stop)
Apr 20 20:31:42 [kernel] usb usb5: suspend_rh (auto-stop)
Apr 20 20:31:42 [kernel] usb usb8: suspend_rh (auto-stop)
Apr 20 20:31:42 [kernel] input: Logitech USB Gaming Mouse
as /devices/pci0000:00/0000:00:1d.0/usb6/6-1/6-1:1.0/input/input2
Apr 20 20:31:42 [kernel] generic-usb 0003:046D:C041.0001: input,hidraw0:
USB HID v1.11 Mouse [Logitech USB Gaming Mouse] on
usb-0000:00:1d.0-1/input0
Apr 20 20:31:42 [kernel] usb 6-1: adding 6-1:1.1 (config #1, interface
1)
Apr 20 20:31:42 [kernel] usbhid 6-1:1.1: usb_probe_interface
Apr 20 20:31:42 [kernel] usbhid 6-1:1.1: usb_probe_interface - got id
Apr 20 20:31:42 [kernel] drivers/usb/core/file.c: looking for a minor,
starting at 96
Apr 20 20:31:42 [kernel] generic-usb 0003:046D:C041.0002:
hiddev96,hidraw1: USB HID v1.11 Device [Logitech USB Gaming Mouse] on
usb-0000:00:1d.0-1/input1
Apr 20 20:31:42 [kernel] drivers/usb/core/inode.c: creating file '002'
Apr 20 20:31:42 [kernel] uhci_hcd 0000:00:1d.0: port 2 portsc 01a3,00
Apr 20 20:31:42 [kernel] hub 6-0:1.0: port 2, status 0301, change 0001,
1.5 Mb/s
Apr 20 20:31:42 [kernel] hub 6-0:1.0: debounce: port 2: total 100ms
stable 100ms status 0x301
Apr 20 20:31:42 [kernel] ata2: SATA link up 3.0 Gbps (SStatus 123
SControl 300)
Apr 20 20:31:42 [kernel] ata2.00: ATA-7: INTEL SSDSA2M080G2GC, 2CV102HD,
max UDMA/133
Apr 20 20:31:42 [kernel] ata2.00: 156301488 sectors, multi 1: LBA48 NCQ
(depth 31/32)
Apr 20 20:31:42 [kernel] sd 1:0:0:0: [sdb] 156301488 512-byte logical
blocks: (80.0 GB/74.5 GiB)
Apr 20 20:31:42 [kernel] sd 1:0:0:0: Attached scsi generic sg1 type 0
Apr 20 20:31:42 [kernel] sd 1:0:0:0: [sdb] Write Protect is off
Apr 20 20:31:42 [kernel] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
Apr 20 20:31:42 [kernel] sd 1:0:0:0: [sdb] Write cache: enabled, read
cache: enabled, doesn't support DPO or FUA
Apr 20 20:31:42 [kernel]  sdb: sdb1 sdb2 sdb3
Apr 20 20:31:42 [kernel] sd 1:0:0:0: [sdb] Attached SCSI disk
Apr 20 20:31:42 [kernel] usb 6-2: new low speed USB device using
uhci_hcd and address 3
Apr 20 20:31:42 [kernel] usb 6-2: skipped 1 descriptor after interface
                - Last output repeated twice -
Apr 20 20:31:42 [kernel] usb 6-2: default language 0x0409
Apr 20 20:31:42 [kernel] usb 6-2: udev 3, busnum 6, minor = 642
Apr 20 20:31:42 [kernel] usb 6-2: New USB device found, idVendor=045e,
idProduct=00db
Apr 20 20:31:42 [kernel] usb 6-2: New USB device strings: Mfr=1,
Product=2, SerialNumber=0
Apr 20 20:31:42 [kernel] usb 6-2: Product: Natural® Ergonomic Keyboard
4000
Apr 20 20:31:42 [kernel] usb 6-2: Manufacturer: Microsoft
Apr 20 20:31:42 [kernel] usb 6-2: usb_probe_device
Apr 20 20:31:42 [kernel] usb 6-2: configuration #1 chosen from 1 choice
Apr 20 20:31:42 [kernel] usb 6-2: adding 6-2:1.0 (config #1, interface
0)
Apr 20 20:31:42 [kernel] usbhid 6-2:1.0: usb_probe_interface
Apr 20 20:31:42 [kernel] usbhid 6-2:1.0: usb_probe_interface - got id
Apr 20 20:31:42 [kernel] input: Microsoft Natural® Ergonomic Keyboard
4000 as /devices/pci0000:00/0000:00:1d.0/usb6/6-2/6-2:1.0/input/input3
Apr 20 20:31:42 [kernel] uhci_hcd 0000:00:1d.0: reserve dev 3 ep81-INT,
period 8, phase 4, 118 us
Apr 20 20:31:42 [kernel] microsoft 0003:045E:00DB.0003: input,hidraw2:
USB HID v1.11 Keyboard [Microsoft Natural® Ergonomic Keyboard 4000] on
usb-0000:00:1d.0-2/input0
Apr 20 20:31:42 [kernel] usb 6-2: adding 6-2:1.1 (config #1, interface
1)
Apr 20 20:31:42 [kernel] usbhid 6-2:1.1: usb_probe_interface
Apr 20 20:31:42 [kernel] usbhid 6-2:1.1: usb_probe_interface - got id
Apr 20 20:31:42 [kernel] input: Microsoft Natural® Ergonomic Keyboard
4000 as /devices/pci0000:00/0000:00:1d.0/usb6/6-2/6-2:1.1/input/input4
Apr 20 20:31:42 [kernel] uhci_hcd 0000:00:1d.0: reserve dev 3 ep82-INT,
period 8, phase 4, 118 us
Apr 20 20:31:42 [kernel] microsoft 0003:045E:00DB.0004: input,hidraw3:
USB HID v1.11 Device [Microsoft Natural® Ergonomic Keyboard 4000] on
usb-0000:00:1d.0-2/input1
Apr 20 20:31:42 [kernel] drivers/usb/core/inode.c: creating file '003'
Apr 20 20:31:42 [kernel] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0002
Apr 20 20:31:42 [kernel] uhci_hcd 0000:00:1d.1: port 1 portsc 0093,00
Apr 20 20:31:42 [kernel] hub 7-0:1.0: port 1, status 0101, change 0001,
12 Mb/s
Apr 20 20:31:42 [kernel] ata3: SATA link down (SStatus 0 SControl 300)
Apr 20 20:31:42 [kernel] hub 7-0:1.0: debounce: port 1: total 100ms
stable 100ms status 0x101
Apr 20 20:31:42 [kernel] usb 7-1: new full speed USB device using
uhci_hcd and address 2
Apr 20 20:31:42 [kernel] usb 7-1: skipped 1 descriptor after interface
Apr 20 20:31:42 [kernel] usb 7-1: default language 0x0409
Apr 20 20:31:42 [kernel] usb 7-1: udev 2, busnum 7, minor = 769
Apr 20 20:31:42 [kernel] usb 7-1: New USB device found, idVendor=07b8,
idProduct=b02a
Apr 20 20:31:42 [kernel] usb 7-1: New USB device strings: Mfr=0,
Product=2, SerialNumber=0
Apr 20 20:31:42 [kernel] usb 7-1: Product: Bluetooth USB Adapter
Apr 20 20:31:42 [kernel] usb 7-1: usb_probe_device
Apr 20 20:31:42 [kernel] usb 7-1: configuration #1 chosen from 1 choice
Apr 20 20:31:42 [kernel] usb 7-1: adding 7-1:1.0 (config #1, interface
0)
Apr 20 20:31:42 [kernel] btusb 7-1:1.0: usb_probe_interface
Apr 20 20:31:42 [kernel] btusb 7-1:1.0: usb_probe_interface - got id
Apr 20 20:31:42 [kernel] usb 7-1: adding 7-1:1.1 (config #1, interface
1)
Apr 20 20:31:42 [kernel] usb 7-1: adding 7-1:1.2 (config #1, interface
2)
Apr 20 20:31:42 [kernel] btusb 7-1:1.2: usb_probe_interface
Apr 20 20:31:42 [kernel] btusb 7-1:1.2: usb_probe_interface - got id
Apr 20 20:31:42 [kernel] drivers/usb/core/inode.c: creating file '002'
Apr 20 20:31:42 [kernel] hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0008
Apr 20 20:31:42 [kernel] hub 2-4:1.0: state 7 ports 4 chg 0000 evt 0000
Apr 20 20:31:42 [kernel] hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0004
Apr 20 20:31:42 [kernel] ata4: SATA link up 1.5 Gbps (SStatus 113
SControl 300)
Apr 20 20:31:42 [kernel] ata4.00: ATAPI: HL-DT-ST BD-RE  GGW-H20L, YL01,
max UDMA/133
Apr 20 20:31:42 [kernel] ata4.00: configured for UDMA/133
Apr 20 20:31:42 [kernel] scsi 3:0:0:0: CD-ROM            HL-DT-ST BD-RE
GGW-H20L  YL01 PQ: 0 ANSI: 5
Apr 20 20:31:42 [kernel] sr0: scsi3-mmc drive: 40x/40x writer dvd-ram
cd/rw xa/form2 cdda tray
Apr 20 20:31:42 [kernel] Uniform CD-ROM driver Revision: 3.20
Apr 20 20:31:42 [kernel] sr 3:0:0:0: Attached scsi CD-ROM sr0
Apr 20 20:31:42 [kernel] sr 3:0:0:0: Attached scsi generic sg2 type 5
Apr 20 20:31:42 [kernel] ata5: SATA link up 3.0 Gbps (SStatus 123
SControl 300)
Apr 20 20:31:42 [kernel] ata5.00: ATA-8: WDC WD10EACS-00ZJB0, 01.01B01,
max UDMA/133
Apr 20 20:31:42 [kernel] ata5.00: 1953525168 sectors, multi 0: LBA48 NCQ
(depth 31/32), AA
Apr 20 20:31:42 [kernel] ata5.00: configured for UDMA/133
Apr 20 20:31:42 [kernel] scsi 4:0:0:0: Direct-Access     ATA      WDC
WD10EACS-00Z 01.0 PQ: 0 ANSI: 5
Apr 20 20:31:42 [kernel] sd 4:0:0:0: [sdc] 1953525168 512-byte logical
blocks: (1.00 TB/931 GiB)
Apr 20 20:31:42 [kernel] sd 4:0:0:0: [sdc] Mode Sense: 00 3a 00 00
Apr 20 20:31:42 [kernel] sd 4:0:0:0: [sdc] Write cache: enabled, read
cache: enabled, doesn't support DPO or FUA
Apr 20 20:31:42 [kernel]  sdc: sdc1
Apr 20 20:31:42 [kernel] sd 4:0:0:0: [sdc] Attached SCSI disk
Apr 20 20:31:42 [kernel] ata6: SATA link up 3.0 Gbps (SStatus 123
SControl 300)
Apr 20 20:31:42 [kernel] ata6.00: ATA-8: WDC WD10EACS-00ZJB0, 01.01B01,
max UDMA/133
Apr 20 20:31:42 [kernel] ata6.00: 1953525168 sectors, multi 0: LBA48 NCQ
(depth 31/32), AA
Apr 20 20:31:42 [kernel] ata6.00: configured for UDMA/133
Apr 20 20:31:42 [kernel] scsi 5:0:0:0: Direct-Access     ATA      WDC
WD10EACS-00Z 01.0 PQ: 0 ANSI: 5
Apr 20 20:31:42 [kernel] sd 5:0:0:0: [sdd] 1953525168 512-byte logical
blocks: (1.00 TB/931 GiB)
Apr 20 20:31:42 [kernel] sd 5:0:0:0: Attached scsi generic sg4 type 0
Apr 20 20:31:42 [kernel] sd 5:0:0:0: [sdd] Write Protect is off
Apr 20 20:31:42 [kernel] sd 5:0:0:0: [sdd] Mode Sense: 00 3a 00 00
Apr 20 20:31:42 [kernel] sd 5:0:0:0: [sdd] Write cache: enabled, read
cache: enabled, doesn't support DPO or FUA
Apr 20 20:31:42 [kernel]  sdd: sdd1
Apr 20 20:31:42 [kernel] sd 5:0:0:0: [sdd] Attached SCSI disk
Apr 20 20:31:42 [kernel] ata8: SATA link down (SStatus 0 SControl 300)
Apr 20 20:31:42 [kernel] ata9: SATA link down (SStatus 0 SControl 300)
Apr 20 20:31:42 [kernel] ata10: SATA link down (SStatus 0 SControl 300)
Apr 20 20:31:42 [kernel] md: Waiting for all devices to be available
before autodetect
Apr 20 20:31:42 [kernel] md: If you don't use raid, use
raid=noautodetect
Apr 20 20:31:42 [kernel] md: Autodetecting RAID arrays.
Apr 20 20:31:42 [kernel] md: Scanned 6 and added 6 devices.
Apr 20 20:31:42 [kernel] md: autorun ...
Apr 20 20:31:42 [kernel] md: considering sdd1 ...
Apr 20 20:31:42 [kernel] md:  adding sdd1 ...
Apr 20 20:31:42 [kernel] md:  adding sdc1 ...
Apr 20 20:31:42 [kernel] md: sdb3 has different UUID to sdd1
Apr 20 20:31:42 [kernel] md: sdb1 has different UUID to sdd1
Apr 20 20:31:42 [kernel] md: sda3 has different UUID to sdd1
Apr 20 20:31:42 [kernel] md: sda1 has different UUID to sdd1
Apr 20 20:31:42 [kernel] md: created md4
Apr 20 20:31:42 [kernel] md: bind<sdc1>
Apr 20 20:31:42 [kernel] md: bind<sdd1>
Apr 20 20:31:42 [kernel] md: running: <sdd1><sdc1>
Apr 20 20:31:42 [kernel] raid0: looking at sdd1
Apr 20 20:31:42 [kernel] raid0:   comparing sdd1(1953519872)
Apr 20 20:31:42 [kernel]  with sdd1(1953519872)
Apr 20 20:31:42 [kernel] raid0:   END
Apr 20 20:31:42 [kernel] raid0:   ==> UNIQUE
Apr 20 20:31:42 [kernel] raid0: 1 zones
Apr 20 20:31:42 [kernel] raid0: looking at sdc1
Apr 20 20:31:42 [kernel] raid0:   comparing sdc1(1953519872)
Apr 20 20:31:42 [kernel]  with sdd1(1953519872)
Apr 20 20:31:42 [kernel] raid0:   EQUAL
Apr 20 20:31:42 [kernel] raid0: FINAL 1 zones
Apr 20 20:31:42 [kernel] raid0: done.
Apr 20 20:31:42 [kernel] raid0 : md_size is 3907039744 sectors.
Apr 20 20:31:42 [kernel] ******* md4 configuration *********
Apr 20 20:31:42 [kernel] zone0=[sdc1/sdd1/]
Apr 20 20:31:42 [kernel]         zone offset=0kb device offset=0kb
size=1953519872kb
Apr 20 20:31:42 [kernel] **********************************
Apr 20 20:31:42 [kernel] md4: detected capacity change from 0 to
2000404348928
Apr 20 20:31:42 [kernel] md: considering sdb3 ...
Apr 20 20:31:42 [kernel] md:  adding sdb3 ...
Apr 20 20:31:42 [kernel] md: sdb1 has different UUID to sdb3
Apr 20 20:31:42 [kernel] md:  adding sda3 ...
Apr 20 20:31:42 [kernel] md: sda1 has different UUID to sdb3
Apr 20 20:31:42 [kernel] md: created md3
Apr 20 20:31:42 [kernel] md: bind<sda3>
Apr 20 20:31:42 [kernel] md: bind<sdb3>
Apr 20 20:31:42 [kernel] md: running: <sdb3><sda3>
Apr 20 20:31:42 [kernel] raid0: looking at sdb3
Apr 20 20:31:42 [kernel] raid0:   comparing sdb3(154962688)
Apr 20 20:31:42 [kernel]  with sdb3(154962688)
Apr 20 20:31:42 [kernel] raid0:   END
Apr 20 20:31:42 [kernel] raid0:   ==> UNIQUE
Apr 20 20:31:42 [kernel] raid0: 1 zones
Apr 20 20:31:42 [kernel] raid0: looking at sda3
Apr 20 20:31:42 [kernel] raid0:   comparing sda3(154962688)
Apr 20 20:31:42 [kernel]  with sdb3(154962688)
Apr 20 20:31:42 [kernel] raid0:   EQUAL
Apr 20 20:31:42 [kernel] raid0: FINAL 1 zones
Apr 20 20:31:42 [kernel] raid0: done.
Apr 20 20:31:42 [kernel] raid0 : md_size is 309925376 sectors.
Apr 20 20:31:42 [kernel] ******* md3 configuration *********
Apr 20 20:31:42 [kernel] zone0=[sda3/sdb3/]
Apr 20 20:31:42 [kernel]         zone offset=0kb device offset=0kb
size=154962688kb
Apr 20 20:31:42 [kernel] **********************************
Apr 20 20:31:42 [kernel] md3: detected capacity change from 0 to
158681792512
Apr 20 20:31:42 [kernel] md: considering sdb1 ...
Apr 20 20:31:42 [kernel] md:  adding sdb1 ...
Apr 20 20:31:42 [kernel] md:  adding sda1 ...
Apr 20 20:31:42 [kernel] md: created md1
Apr 20 20:31:42 [kernel] md: bind<sda1>
Apr 20 20:31:42 [kernel] md: bind<sdb1>
Apr 20 20:31:42 [kernel] md: running: <sdb1><sda1>
Apr 20 20:31:42 [kernel] raid1: raid set md1 active with 2 out of 2
mirrors
Apr 20 20:31:42 [kernel] md1: detected capacity change from 0 to
139722752
Apr 20 20:31:42 [kernel] md: ... autorun DONE.
Apr 20 20:31:42 [kernel]  md3: unknown partition table
Apr 20 20:31:42 [kernel] EXT4-fs (md3): mounted filesystem with ordered
data mode
Apr 20 20:31:42 [kernel] VFS: Mounted root (ext2 filesystem) readonly on
device 9:3.
Apr 20 20:31:42 [kernel] Freeing unused kernel memory: 352k freed
Apr 20 20:31:42 [kernel] Write protecting the kernel text: 3812k
Apr 20 20:31:42 [kernel] Write protecting the kernel read-only data:
1256k
Apr 20 20:31:42 [kernel] udev: starting version 151
Apr 20 20:31:42 [kernel]  md1:
Apr 20 20:31:42 [kernel]  md4: unknown partition table
Apr 20 20:31:42 [kernel]  unknown partition table
Apr 20 20:31:42 [kernel] EXT4-fs (md4): mounted filesystem with ordered
data mode
Apr 20 20:31:42 [kernel] uhci_hcd 0000:00:1d.1: reserve dev 2 ep81-INT,
period 1, phase 0, 23 us
Apr 20 20:31:42 [kernel] skge 0000:0a:04.0: eth0: enabling interface
Apr 20 20:31:42 [kernel] ADDRCONF(NETDEV_UP): eth0: link is not ready
Apr 20 20:31:43 [kernel] Adding 530140k swap on /dev/sda2.  Priority:-1
extents:1 across:530140k SSD
Apr 20 20:31:43 [kernel] Adding 530140k swap on /dev/sdb2.  Priority:-2
extents:1 across:530140k SSD
Apr 20 20:31:44 [kernel] [drm] nouveau 0000:01:00.0: Allocating FIFO
number 2
Apr 20 20:31:44 [kernel] [drm] nouveau 0000:01:00.0:
nouveau_channel_alloc: initialised FIFO 2
Apr 20 20:31:44 [kernel] [drm] nouveau 0000:01:00.0: Allocating FIFO
number 3
Apr 20 20:31:44 [kernel] [drm] nouveau 0000:01:00.0:
nouveau_channel_alloc: initialised FIFO 3
Apr 20 20:31:44 [kernel] uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT,
period 1, phase 0, 19 us
Apr 20 20:31:45 [kernel] skge 0000:0a:04.0: eth0: Link is up at 1000
Mbps, full duplex, flow control both
Apr 20 20:31:45 [kernel] ADDRCONF(NETDEV_CHANGE): eth0: link becomes
ready
Apr 20 20:31:56 [kernel] eth0: no IPv6 routers present


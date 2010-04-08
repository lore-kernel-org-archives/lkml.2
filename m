Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477Ab0DHDvt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 23:51:49 -0400
Received: from mail-pz0-f193.google.com ([209.85.222.193]:54942 "EHLO
	mail-pz0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756914Ab0DHDv2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 23:51:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=P/QrIbjgAivuTj4LU/PCvraR8IfpU3bKgzXM2wRgNiaz9GS1W1Ii6o/CjLb7MKLekS
         7ezNWJDeHbYDxZvGhNAhgOfvuWqUGGbfLXcx84zWuwMlqWp1tAd8jYIcpJQZNK338kh9
         afEY+ewpSCyOkLIuw2Y6/MD4grL92aPixOOJE=
MIME-Version: 1.0
In-Reply-To: <4BBD1957.90502@gmail.com>
References: <x2w5bdc1c8b1004051355o3f803c75t2515ef46320e00bd@mail.gmail.com>
	 <4BBC9CA1.5080102@ladisch.de>
	 <m2l5bdc1c8b1004070857r823821ack6cc99354db73eaa0@mail.gmail.com>
	 <4BBD1957.90502@gmail.com>
Date: Wed, 7 Apr 2010 20:51:26 -0700
Message-ID: <k2l5bdc1c8b1004072051h957c3f1crf0a139bd96a093a4@mail.gmail.com>
Subject: Re: Failed to initialize MSI interrupts && ioremap reserve_memtype 
	failed -22
From: Mark Knecht <markknecht@gmail.com>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: Clemens Ladisch <clemens@ladisch.de>,
       Linux Kernel List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 7, 2010 at 4:46 PM, Robert Hancock <hancockrwd@gmail.com> wrote:
> On 04/07/2010 09:57 AM, Mark Knecht wrote:
>>
>> On Wed, Apr 7, 2010 at 7:54 AM, Clemens Ladisch<clemens@ladisch.de>
>>  wrote:
>>>
>>> Mark Knecht wrote:
>>>>
>>>>    New hardware and I haven't seen these messages before so I thought
>>>> I'd post them.
>>>
>>> Both might be harmless.  Please show the entire boot log.
>>>
>>>
>>> Regards,
>>> Clemens
>>>
>>
>> Hopefully you mean the contents of dmesg. If it's something else let me
>> know.
>>
>> If the mail server deletes the text file attachment I'll reply again
>> pasting the text in by hand.
>
> Looks like the start of the log was truncated. Can you check if your distro
> writes the bootup kernel output somewhere (like /var/log/dmesg)?
>

Sorry about that. Apparently the default kernel log buffer wasn;t big
enough anymore. It's a new machine and the first time I've run into
that.

Hopefully this is everything this time.

Thanks!

- MArk

mark@k2 ~ $ dmesg
Linux version 2.6.33-gentoo (root@k2) (gcc version 4.3.4 (Gentoo 4.3.4
p1.1, pie-10.1.5) ) #2 SMP PREEMPT Wed Apr 7 19:20:31 PDT 2010
Command line: root=/dev/md3
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000008f000 (usable)
 BIOS-e820: 000000000008f000 - 0000000000090000 (reserved)
 BIOS-e820: 0000000000090000 - 000000000009d000 (usable)
 BIOS-e820: 000000000009d000 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000cf4bd000 (usable)
 BIOS-e820: 00000000cf4bd000 - 00000000cf4bf000 (reserved)
 BIOS-e820: 00000000cf4bf000 - 00000000cf4c4000 (usable)
 BIOS-e820: 00000000cf4c4000 - 00000000cf7bf000 (ACPI NVS)
 BIOS-e820: 00000000cf7bf000 - 00000000cf7df000 (usable)
 BIOS-e820: 00000000cf7df000 - 00000000cf7ff000 (ACPI data)
 BIOS-e820: 00000000cf7ff000 - 00000000cf800000 (usable)
 BIOS-e820: 00000000cf800000 - 00000000d0000000 (reserved)
 BIOS-e820: 00000000f8000000 - 00000000fd000000 (reserved)
 BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 00000001b0000000 (usable)
NX (Execute Disable) protection: active
DMI 2.5 present.
No AGP bridge found
last_pfn = 0x1b0000 max_arch_pfn = 0x400000000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-DFFFF write-protect
  E0000-FFFFF uncachable
MTRR variable ranges enabled:
  0 base 000000000 mask F80000000 write-back
  1 base 080000000 mask FC0000000 write-back
  2 base 0C0000000 mask FF0000000 write-back
  3 base 100000000 mask F80000000 write-back
  4 base 180000000 mask FE0000000 write-back
  5 base 1A0000000 mask FF0000000 write-back
  6 base 0FFFF0000 mask FFFFF0000 write-protect
  7 disabled
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
last_pfn = 0xcf800 max_arch_pfn = 0x400000000
initial memory mapped : 0 - 20000000
init_memory_mapping: 0000000000000000-00000000cf800000
 0000000000 - 00cf800000 page 2M
kernel direct mapping tables up to cf800000 @ 8000-d000
init_memory_mapping: 0000000100000000-00000001b0000000
 0100000000 - 01b0000000 page 2M
kernel direct mapping tables up to 1b0000000 @ b000-13000
ACPI: RSDP 00000000000fe020 00024 (v02 INTEL )
ACPI: XSDT 00000000cf7fe120 00074 (v01 INTEL  DX58SO   00001135
01000013)
ACPI: FACP 00000000cf7fd000 000F4 (v03 INTEL  DX58SO   00001135 MSFT
0100000D)
ACPI Warning: Optional field Pm2ControlBlock has zero address or
length: 0000000000000450/0 (20091214/tbfadt-557)
ACPI Warning: Invalid length for Pm2ControlBlock: 0, using default 8
(20091214/tbfadt-607)
ACPI: DSDT 00000000cf7f8000 04641 (v02 INTEL  DX58SO   00001135 MSFT
0100000D)
ACPI: FACS 00000000cf728000 00040
ACPI: APIC 00000000cf7f7000 00138 (v02 INTEL  DX58SO   00001135 MSFT
0100000D)
ACPI: WDDT 00000000cf7f6000 00040 (v01 INTEL  DX58SO   00001135 MSFT
0100000D)
ACPI: MCFG 00000000cf7f5000 0003C (v01 INTEL  DX58SO   00001135 MSFT
0100000D)
ACPI: ASF! 00000000cf7f4000 000AC (v32 INTEL  DX58SO   00001135 MSFT
0100000D)
ACPI: HPET 00000000cf7f3000 00038 (v01 INTEL  DX58SO   00001135 MSFT
0100000D)
ACPI: SSDT 00000000cf7e2000 0E134 (v01 INTEL  SSDT  PM 00001135 MSFT
0100000D)
ACPI: DMAR 00000000cf7df000 00140 (v01 INTEL  DX58SO   00001135 MSFT
0100000D)
ACPI: WDTT 00000000cf7f1000 0020C (v02 INTEL  DX58SO   00001135 MSFT
0100000D)
ACPI: ASPT 00000000cf7f2000 00034 (v04 INTEL  PerfTune 00001135 MSFT
0100000D)
ACPI: Local APIC address 0xfee00000
(7 early reservations) ==> bootmem [0000000000 - 01b0000000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 -
0000001000]
  #1 [0001000000 - 0001737e74]    TEXT DATA BSS ==> [0001000000 -
0001737e74]
  #2 [000009d000 - 0000100000]    BIOS reserved ==> [000009d000 -
0000100000]
  #3 [0001738000 - 000173815e]              BRK ==> [0001738000 -
000173815e]
  #4 [0000001000 - 0000003000]       TRAMPOLINE ==> [0000001000 -
0000003000]
  #5 [0000008000 - 000000b000]          PGTABLE ==> [0000008000 -
000000b000]
  #6 [000000b000 - 000000e000]          PGTABLE ==> [000000b000 -
000000e000]
 [ffffea0000000000-ffffea0005ffffff] PMD ->
[ffff880028600000-ffff88002dbfffff] on node 0
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x001b0000
Movable zone start PFN for each node
early_node_map[7] active PFN ranges
    0: 0x00000000 -> 0x0000008f
    0: 0x00000090 -> 0x0000009d
    0: 0x00000100 -> 0x000cf4bd
    0: 0x000cf4bf -> 0x000cf4c4
    0: 0x000cf7bf -> 0x000cf7df
    0: 0x000cf7ff -> 0x000cf800
    0: 0x00100000 -> 0x001b0000
On node 0 totalpages: 1569919
  DMA zone: 56 pages used for memmap
  DMA zone: 108 pages reserved
  DMA zone: 3832 pages, LIFO batch:0
  DMA32 zone: 14280 pages used for memmap
  DMA32 zone: 830747 pages, LIFO batch:31
  Normal zone: 9856 pages used for memmap
  Normal zone: 711040 pages, LIFO batch:31
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x02] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x04] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x06] enabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x03] enabled)
ACPI: LAPIC (acpi_id[0x06] lapic_id[0x05] enabled)
ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x10] disabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x12] disabled)
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x14] disabled)
ACPI: LAPIC (acpi_id[0x07] lapic_id[0x16] disabled)
ACPI: LAPIC (acpi_id[0x09] lapic_id[0x11] disabled)
ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x13] disabled)
ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x15] disabled)
ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x17] disabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x04] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x05] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x06] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x07] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x08] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x09] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x0a] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x0b] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x0c] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x0d] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x0e] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x0f] high level lint[0x1])
ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a301 base: 0xfed00000
16 Processors exceeds NR_CPUS limit of 8
SMP: Allowing 8 CPUs, 0 hotplug CPUs
nr_irqs_gsi: 24
Allocating PCI resources starting at d0000000 (gap: d0000000:28000000)
setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:8 nr_node_ids:1
PERCPU: Embedded 25 pages/cpu @ffff880028200000 s73304 r8192 d20904
u262144
pcpu-alloc: s73304 r8192 d20904 u262144 alloc=1*2097152
pcpu-alloc: [0] 0 1 2 3 4 5 6 7
Built 1 zonelists in Zone order, mobility grouping on.  Total pages:
1545619
Kernel command line: root=/dev/md3
PID hash table entries: 4096 (order: 3, 32768 bytes)
Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
Checking aperture...
No AGP bridge found
Memory: 6103968k/7077888k available (3345k kernel code, 798212k
absent, 174800k reserved, 3225k data, 440k init)
Experimental preemptable hierarchical RCU implementation.
NR_IRQS:512
Extended CMOS year: 2000
Console: colour VGA+ 80x25
console [tty0] enabled
hpet clockevent registered
Fast TSC calibration using PIT
Detected 2666.181 MHz processor.
Calibrating delay loop (skipped), value calculated using timer
frequency.. 5332.36 BogoMIPS (lpj=2666181)
Security Framework initialized
Mount-cache hash table entries: 256
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 9 MCE banks
CPU0: Thermal monitoring enabled (TM1)
CPU 0 MCA banks CMCI:2 CMCI:3 CMCI:5 CMCI:6 CMCI:8
using mwait in idle threads.
Performance Events: Nehalem/Corei7 events, Intel PMU driver.
... version:                3
... bit width:              48
... generic registers:      4
... value mask:             0000ffffffffffff
... max period:             000000007fffffff
... fixed-purpose events:   3
... event mask:             000000070000000f
Freeing SMP alternatives: 33k freed
ACPI: Core revision 20091214
Setting APIC routing to flat
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Core(TM) i7 CPU         920  @ 2.67GHz stepping 05
Booting Node   0, Processors  #1
CPU 1 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
 #2
CPU 2 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
 #3
CPU 3 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
 #4
CPU 4 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
 #5
CPU 5 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
 #6
CPU 6 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
 #7 Ok.
CPU 7 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
Brought up 8 CPUs
Total of 8 processors activated (42659.97 BogoMIPS).
NET: Registered protocol family 16
ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
ACPI: bus type pci registered
dca service started, version 1.12.1
PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem
0xf8000000-0xfbffffff] (base 0xf8000000)
PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: No dock devices found.
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci_root PNP0A08:00: ignoring host bridge windows from ACPI; boot with
"pci=use_crs" to use them
pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7] (ignored)
pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff] (ignored)
pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
(ignored)
pci_root PNP0A08:00: host bridge window [mem 0x000c4000-0x000cbfff]
(ignored)
pci_root PNP0A08:00: host bridge window [mem 0xfed40000-0xfedfffff]
(ignored)
pci_root PNP0A08:00: host bridge window [mem 0xd0000000-0xf7ffffff]
(ignored)
pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
pci 0000:00:01.0: PME# disabled
pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
pci 0000:00:03.0: PME# disabled
pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
pci 0000:00:07.0: PME# disabled
pci 0000:00:19.0: reg 10: [mem 0xd3200000-0xd321ffff]
pci 0000:00:19.0: reg 14: [mem 0xd3223000-0xd3223fff]
pci 0000:00:19.0: reg 18: [io  0x3100-0x311f]
pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
pci 0000:00:19.0: PME# disabled
pci 0000:00:1a.0: reg 20: [io  0x30e0-0x30ff]
pci 0000:00:1a.1: reg 20: [io  0x30c0-0x30df]
pci 0000:00:1a.2: reg 20: [io  0x30a0-0x30bf]
pci 0000:00:1a.7: reg 10: [mem 0xd3222000-0xd32223ff]
pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1a.7: PME# disabled
pci 0000:00:1b.0: reg 10: [mem 0xf0000000-0xf0003fff 64bit]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: PME# disabled
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.1: PME# disabled
pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.4: PME# disabled
pci 0000:00:1d.0: reg 20: [io  0x3080-0x309f]
pci 0000:00:1d.1: reg 20: [io  0x3060-0x307f]
pci 0000:00:1d.2: reg 20: [io  0x3040-0x305f]
pci 0000:00:1d.7: reg 10: [mem 0xd3221000-0xd32213ff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1f.0: quirk: [io  0x0400-0x047f] claimed by ICH6
ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: [io  0x0500-0x053f] claimed by ICH6 GPIO
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0680 (mask 007f)
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 0810 (mask 007f)
pci 0000:00:1f.2: reg 10: [io  0x3128-0x312f]
pci 0000:00:1f.2: reg 14: [io  0x3134-0x3137]
pci 0000:00:1f.2: reg 18: [io  0x3120-0x3127]
pci 0000:00:1f.2: reg 1c: [io  0x3130-0x3133]
pci 0000:00:1f.2: reg 20: [io  0x3020-0x303f]
pci 0000:00:1f.2: reg 24: [mem 0xd3220000-0xd32207ff]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.2: PME# disabled
pci 0000:00:1f.3: reg 10: [mem 0xf0004000-0xf00040ff 64bit]
pci 0000:00:1f.3: reg 20: [io  0x3000-0x301f]
pci 0000:00:01.0: PCI bridge to [bus 01-01]
pci 0000:02:00.0: reg 10: [mem 0xd2000000-0xd2ffffff]
pci 0000:02:00.0: reg 14: [mem 0xe0000000-0xefffffff 64bit pref]
pci 0000:02:00.0: reg 1c: [mem 0xd0000000-0xd1ffffff 64bit]
pci 0000:02:00.0: reg 24: [io  0x2000-0x207f]
pci 0000:02:00.0: reg 30: [mem 0xfff80000-0xffffffff pref]
pci 0000:00:03.0: PCI bridge to [bus 02-02]
pci 0000:00:03.0:   bridge window [io  0x2000-0x2fff]
pci 0000:00:03.0:   bridge window [mem 0xd0000000-0xd2ffffff]
pci 0000:00:03.0:   bridge window [mem 0xe0000000-0xefffffff 64bit
pref]
pci 0000:00:07.0: PCI bridge to [bus 03-03]
pci 0000:00:1c.0: PCI bridge to [bus 04-04]
pci 0000:00:1c.1: PCI bridge to [bus 05-05]
pci 0000:06:00.0: reg 10: [io  0x1018-0x101f]
pci 0000:06:00.0: reg 14: [io  0x1024-0x1027]
pci 0000:06:00.0: reg 18: [io  0x1010-0x1017]
pci 0000:06:00.0: reg 1c: [io  0x1020-0x1023]
pci 0000:06:00.0: reg 20: [io  0x1000-0x100f]
pci 0000:06:00.0: reg 24: [mem 0xd3100000-0xd31003ff]
pci 0000:06:00.0: supports D1
pci 0000:06:00.0: PME# supported from D0 D1 D3hot
pci 0000:06:00.0: PME# disabled
pci 0000:00:1c.4: PCI bridge to [bus 06-06]
pci 0000:00:1c.4:   bridge window [io  0x1000-0x1fff]
pci 0000:00:1c.4:   bridge window [mem 0xd3100000-0xd31fffff]
pci 0000:07:03.0: reg 10: [mem 0xd3004000-0xd30047ff]
pci 0000:07:03.0: reg 14: [mem 0xd3000000-0xd3003fff]
pci 0000:07:03.0: supports D1 D2
pci 0000:07:03.0: PME# supported from D0 D1 D2 D3hot
pci 0000:07:03.0: PME# disabled
pci 0000:00:1e.0: PCI bridge to [bus 07-07] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0xd3000000-0xd30fffff]
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P32_._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEG1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEG3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEG7._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
SCSI subsystem initialized
libata version 3.00 loaded.
PCI: Using ACPI for IRQ routing
PCI: pci_cache_line_size set to 64 bytes
Switching to clocksource tsc
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 10 devices
ACPI: ACPI bus type pnp unregistered
system 00:05: [io  0x0500-0x053f] has been reserved
system 00:05: [io  0x0400-0x047f] has been reserved
system 00:05: [io  0x0680-0x06ff] has been reserved
pci 0000:02:00.0: no compatible bridge window for [mem
0xfff80000-0xffffffff pref]
pci 0000:00:01.0: PCI bridge to [bus 01-01]
pci 0000:00:01.0:   bridge window [io  disabled]
pci 0000:00:01.0:   bridge window [mem disabled]
pci 0000:00:01.0:   bridge window [mem pref disabled]
pci 0000:02:00.0: BAR 6: can't assign mem pref (size 0x80000)
pci 0000:00:03.0: PCI bridge to [bus 02-02]
pci 0000:00:03.0:   bridge window [io  0x2000-0x2fff]
pci 0000:00:03.0:   bridge window [mem 0xd0000000-0xd2ffffff]
pci 0000:00:03.0:   bridge window [mem 0xe0000000-0xefffffff 64bit
pref]
pci 0000:00:07.0: PCI bridge to [bus 03-03]
pci 0000:00:07.0:   bridge window [io  disabled]
pci 0000:00:07.0:   bridge window [mem disabled]
pci 0000:00:07.0:   bridge window [mem pref disabled]
pci 0000:00:1c.0: PCI bridge to [bus 04-04]
pci 0000:00:1c.0:   bridge window [io  disabled]
pci 0000:00:1c.0:   bridge window [mem disabled]
pci 0000:00:1c.0:   bridge window [mem pref disabled]
pci 0000:00:1c.1: PCI bridge to [bus 05-05]
pci 0000:00:1c.1:   bridge window [io  disabled]
pci 0000:00:1c.1:   bridge window [mem disabled]
pci 0000:00:1c.1:   bridge window [mem pref disabled]
pci 0000:00:1c.4: PCI bridge to [bus 06-06]
pci 0000:00:1c.4:   bridge window [io  0x1000-0x1fff]
pci 0000:00:1c.4:   bridge window [mem 0xd3100000-0xd31fffff]
pci 0000:00:1c.4:   bridge window [mem pref disabled]
pci 0000:00:1e.0: PCI bridge to [bus 07-07]
pci 0000:00:1e.0:   bridge window [io  disabled]
pci 0000:00:1e.0:   bridge window [mem 0xd3000000-0xd30fffff]
pci 0000:00:1e.0:   bridge window [mem pref disabled]
pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:01.0: setting latency timer to 64
pci 0000:00:03.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:03.0: setting latency timer to 64
pci 0000:00:07.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:07.0: setting latency timer to 64
pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.0: setting latency timer to 64
pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:1c.1: setting latency timer to 64
pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.4: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffffffffffff]
pci_bus 0000:02: resource 0 [io  0x2000-0x2fff]
pci_bus 0000:02: resource 1 [mem 0xd0000000-0xd2ffffff]
pci_bus 0000:02: resource 2 [mem 0xe0000000-0xefffffff 64bit pref]
pci_bus 0000:06: resource 0 [io  0x1000-0x1fff]
pci_bus 0000:06: resource 1 [mem 0xd3100000-0xd31fffff]
pci_bus 0000:07: resource 1 [mem 0xd3000000-0xd30fffff]
pci_bus 0000:07: resource 3 [io  0x0000-0xffff]
pci_bus 0000:07: resource 4 [mem 0x00000000-0xffffffffffffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
UDP hash table entries: 4096 (order: 5, 131072 bytes)
UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
NET: Registered protocol family 1
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
pci 0000:02:00.0: Boot video device
PCI: CLS 64 bytes, default 64
PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Placing 64MB software IO TLB between ffff880020000000 -
ffff880024000000
software IO TLB at phys 0x20000000 - 0x24000000
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
squashfs: version 4.0 (2009/01/31) Phillip Lougher
NTFS driver 2.1.29 [Flags: R/W].
msgmni has been set to 11923
alg: No test for stdrng (krng)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
pcieport 0000:00:01.0: setting latency timer to 64
pcieport 0000:00:03.0: setting latency timer to 64
pcieport 0000:00:07.0: setting latency timer to 64
pcieport 0000:00:1c.0: setting latency timer to 64
pcieport 0000:00:1c.1: setting latency timer to 64
pcieport 0000:00:1c.4: setting latency timer to 64
input: Sleep Button as
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input0
ACPI: Sleep Button [SLPB]
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
ACPI: Power Button [PWRF]
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a NS16550A
brd: module loaded
loop: module loaded
Uniform Multi-Platform E-IDE driver
ide_generic: please use "probe_mask=0x3f" module parameter for probing
all legacy ISA IDE ports
Probing IDE interface ide0...
ide0: no devices on the port
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
ide1: no devices on the port
ide1 at 0x170-0x177,0x376 on irq 15
ide-gd driver 1.18
ide-cd driver 5.00
Loading iSCSI transport class v2.0-870.
SCSI Media Changer driver v0.25
ahci 0000:00:1f.2: version 3.0
ahci 0000:00:1f.2: PCI INT A -> GSI 19 (level, low) -> IRQ 19
ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl
SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ccc
ems
ahci 0000:00:1f.2: setting latency timer to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
scsi4 : ahci
scsi5 : ahci
ata1: SATA max UDMA/133 irq_stat 0x00400040, connection status changed
irq 19
ata2: SATA max UDMA/133 irq_stat 0x00400040, connection status changed
ata3: SATA max UDMA/133 irq_stat 0x00400040, connection status changed
ata4: SATA max UDMA/133 abar m2048@0xd3220000 port 0xd3220280 irq 19
ata5: SATA max UDMA/133 irq_stat 0x00400040, connection status changed
ata6: SATA max UDMA/133 abar m2048@0xd3220000 port 0xd3220380 irq 19
ahci 0000:06:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
ahci 0000:06:00.0: controller can't do NCQ, turning off CAP_NCQ
ahci 0000:06:00.0: controller can't do PMP, turning off CAP_PMP
ahci 0000:06:00.0: MV_AHCI HACK: port_map 7 -> 3
ahci 0000:06:00.0: Disabling your PATA port. Use the boot option
'ahci.marvell_enable=0' to avoid this.
ahci: SSS flag set, parallel bus scan disabled
ahci 0000:06:00.0: AHCI 0001.0000 32 slots 3 ports 3 Gbps 0x3 impl IDE
mode
ahci 0000:06:00.0: flags: 64bit stag led slum part
ahci 0000:06:00.0: setting latency timer to 64
scsi6 : ahci
scsi7 : ahci
scsi8 : ahci
ata7: SATA max UDMA/133 abar m1024@0xd3100000 port 0xd3100100 irq 16
ata8: SATA max UDMA/133 abar m1024@0xd3100000 port 0xd3100180 irq 16
ata9: DUMMY
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
md: raid0 personality registered for level 0
md: raid1 personality registered for level 1
device-mapper: ioctl: 4.16.0-ioctl (2009-11-05) initialised:
dm-devel@redhat.com
cpuidle: using governor ladder
cpuidle: using governor menu
ioatdma: Intel(R) QuickData Technology Driver 4.00
TCP cubic registered
NET: Registered protocol family 17
ata6: SATA link down (SStatus 0 SControl 300)
ata4: SATA link down (SStatus 0 SControl 300)
ata7: SATA link down (SStatus 0 SControl 300)
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata3.00: ATA-8: WDC WD5002ABYS-02B1B0, 02.03B03, max UDMA/133
ata3.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
ata5.00: ATA-8: WDC WD5002ABYS-02B1B0, 02.03B03, max UDMA/133
ata5.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
ata1.00: ATA-8: WDC WD10EARS-00Y5B1, 80.00A80, max UDMA/133
ata1.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
ata3.00: configured for UDMA/133
ata2.00: ATAPI: Optiarc DVD RW AD-7241S, 1.03, max UDMA/100, ATAPI AN
ata5.00: configured for UDMA/133
ata1.00: configured for UDMA/133
ata2.00: configured for UDMA/100
scsi 0:0:0:0: Direct-Access     ATA      WDC WD10EARS-00Y 80.0 PQ: 0
ANSI: 5
sd 0:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00 TB/931
GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sda:
scsi 1:0:0:0: CD-ROM            Optiarc  DVD RW AD-7241S  1.03 PQ: 0
ANSI: 5
 sda1 sda2 sda3 sda4 <sr0: scsi3-mmc drive: 48x/48x writer dvd-ram
cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 1:0:0:0: Attached scsi CD-ROM sr0
scsi 2:0:0:0: Direct-Access     ATA      WDC WD5002ABYS-0 02.0 PQ: 0
ANSI: 5
sd 2:0:0:0: [sdb] 976773168 512-byte logical blocks: (500 GB/465 GiB)
scsi 4:0:0:0: Direct-Access     ATA      WDC WD5002ABYS-0 02.0 PQ: 0
ANSI: 5
sd 4:0:0:0: [sdc] 976773168 512-byte logical blocks: (500 GB/465 GiB)
sd 4:0:0:0: [sdc] Write Protect is off
sd 4:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 4:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sdc:
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sdb: sda5 >
 sdc1 sdc2 sdc3
sd 4:0:0:0: [sdc] Attached SCSI disk
sd 0:0:0:0: [sda] Attached SCSI disk
 sdb1 sdb2 sdb3
sd 2:0:0:0: [sdb] Attached SCSI disk
ata8: SATA link down (SStatus 0 SControl 300)
md: Waiting for all devices to be available before autodetect
md: If you don't use raid, use raid=noautodetect
md: Autodetecting RAID arrays.
md: Scanned 2 and added 2 devices.
md: autorun ...
md: considering sdb3 ...
md:  adding sdb3 ...
md:  adding sdc3 ...
md: created md3
md: bind<sdc3>
md: bind<sdb3>
md: running: <sdb3><sdc3>
raid1: raid set md3 active with 2 out of 2 mirrors
md3: detected capacity change from 0 to 42960551936
md: ... autorun DONE.
 md3: unknown partition table
kjournald starting.  Commit interval 5 seconds
EXT3-fs (md3): mounted filesystem with writeback data mode
VFS: Mounted root (ext3 filesystem) readonly on device 9:3.
Freeing unused kernel memory: 440k freed
Write protecting the kernel read-only data: 6144k
Freeing unused kernel memory: 732k freed
Freeing unused kernel memory: 780k freed
udev: starting version 149
Monitor-Mwait will be used to enter C-1 state
rtc_cmos 00:02: RTC can wake from S4
rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
e1000e: Intel(R) PRO/1000 Network Driver - 1.0.2-k2
e1000e: Copyright (c) 1999 - 2009 Intel Corporation.
e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
e1000e 0000:00:19.0: setting latency timer to 64
0000:00:19.0: 0000:00:19.0: Failed to initialize MSI interrupts.
Falling back to legacy interrupts.
Linux agpgart interface v0.103
sd 0:0:0:0: Attached scsi generic sg0 type 0
sr 1:0:0:0: Attached scsi generic sg1 type 5
sd 2:0:0:0: Attached scsi generic sg2 type 0
sd 4:0:0:0: Attached scsi generic sg3 type 0
firewire_ohci 0000:07:03.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
uhci_hcd: USB Universal Host Controller Interface driver
firewire_ohci: Added fw-ohci device 0000:07:03.0, OHCI version 1.10
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
Warning! ehci_hcd should always be loaded before uhci_hcd and
ohci_hcd, not after
0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:1c:c0:b1:9a:fd
0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
0000:00:19.0: eth0: MAC: 7, PHY: 8, PBA No: ffffff-0ff
uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1a.0: setting latency timer to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1a.0: irq 16, io base 0x000030e0
usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: UHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.33-gentoo uhci_hcd
usb usb1: SerialNumber: 0000:00:1a.0
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
ehci_hcd 0000:00:1a.7: setting latency timer to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:1a.7: debug port 1
ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
ehci_hcd 0000:00:1a.7: irq 18, io mem 0xd3222000
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: EHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.33-gentoo ehci_hcd
usb usb2: SerialNumber: 0000:00:1a.7
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 6 ports detected
uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:1a.1: setting latency timer to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1a.1: irq 21, io base 0x000030c0
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.33-gentoo uhci_hcd
usb usb3: SerialNumber: 0000:00:1a.1
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 4
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xd3221000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
usb usb4: New USB device found, idVendor=1d6b, idProduct=0002
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: EHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.33-gentoo ehci_hcd
usb usb4: SerialNumber: 0000:00:1d.7
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 6 ports detected
uhci_hcd 0000:00:1a.2: PCI INT D -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1a.2: setting latency timer to 64
uhci_hcd 0000:00:1a.2: UHCI Host Controller
uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1a.2: irq 19, io base 0x000030a0
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.33-gentoo uhci_hcd
usb usb5: SerialNumber: 0000:00:1a.2
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
uhci_hcd 0000:00:1d.0: irq 23, io base 0x00003080
usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb6: Product: UHCI Host Controller
usb usb6: Manufacturer: Linux 2.6.33-gentoo uhci_hcd
usb usb6: SerialNumber: 0000:00:1d.0
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
uhci_hcd 0000:00:1d.1: irq 19, io base 0x00003060
usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb7: Product: UHCI Host Controller
usb usb7: Manufacturer: Linux 2.6.33-gentoo uhci_hcd
usb usb7: SerialNumber: 0000:00:1d.1
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
uhci_hcd 0000:00:1d.2: irq 18, io base 0x00003040
usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb8: Product: UHCI Host Controller
usb usb8: Manufacturer: Linux 2.6.33-gentoo uhci_hcd
usb usb8: SerialNumber: 0000:00:1d.2
hub 8-0:1.0: USB hub found
hub 8-0:1.0: 2 ports detected
HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
HDA Intel 0000:00:1b.0: setting latency timer to 64
nvidia: module license 'NVIDIA' taints kernel.
Disabling lock debugging due to kernel taint
firewire_core: created device fw0: GUID 00902700025d5a61, S400
usb 5-2: new low speed USB device using uhci_hcd and address 2
nvidia 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
nvidia 0000:02:00.0: setting latency timer to 64
NVRM: loading NVIDIA UNIX x86_64 Kernel Module  195.36.15  Fri Mar 12
00:29:13 PST 2010
usb 5-2: New USB device found, idVendor=045e, idProduct=0084
usb 5-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 5-2: Product: Basic Optical Mouse
usb 5-2: Manufacturer: Microsoft
usbcore: registered new interface driver hiddev
input: Microsoft Basic Optical Mouse as
/devices/pci0000:00/0000:00:1a.2/usb5/5-2/5-2:1.0/input/input2
generic-usb 0003:045E:0084.0001: input,hidraw0: USB HID v1.10 Mouse
[Microsoft Basic Optical Mouse] on usb-0000:00:1a.2-2/input0
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
usb 8-2: new low speed USB device using uhci_hcd and address 2
EXT3-fs (md3): using internal journal
usb 8-2: New USB device found, idVendor=047b, idProduct=0011
usb 8-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 8-2: Product: Standard USB Keyboard
usb 8-2: Manufacturer: Silitek
input: Silitek Standard USB Keyboard  as
/devices/pci0000:00/0000:00:1d.2/usb8/8-2/8-2:1.0/input/input3
generic-usb 0003:047B:0011.0002: input,hidraw1: USB HID v1.00 Keyboard
[Silitek Standard USB Keyboard ] on usb-0000:00:1d.2-2/input0
Adding 4200988k swap on /dev/sda2.  Priority:-1 extents:1 across:4200988k
Adding 4200988k swap on /dev/sdb2.  Priority:-2 extents:1 across:4200988k
Adding 4200988k swap on /dev/sdc2.  Priority:-3 extents:1 across:4200988k
e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Control: RX/TX
0000:00:19.0: eth0: 10/100 speed: disabling TSO
NET: Registered protocol family 10
ioremap reserve_memtype failed -22
eth0: no IPv6 routers present
mark@k2 ~ $

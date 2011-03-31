Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758697Ab1CaRJs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 13:09:48 -0400
Received: from adelie.canonical.com ([91.189.90.139]:49915 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758305Ab1CaRJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 13:09:45 -0400
Message-ID: <4D94B552.8020108@canonical.com>
Date: Thu, 31 Mar 2011 12:09:38 -0500
From: Manoj <manoj.iyer@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Chris Ball <cjb@laptop.org>
CC: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: SDHCI: Ricoh [1180:e823] unable to mount MMC cards.
References: <4D93AD5C.1070308@canonical.com>	<m34o6k43c4.fsf@pullcord.laptop.org> <4D93BDA9.1020107@canonical.com>	<m3vcz02mi1.fsf@pullcord.laptop.org> <4D948BC4.6020904@canonical.com>	<m3sju3z6yc.fsf@pullcord.laptop.org> <4D949298.4000701@canonical.com>	<m3oc4rz5kp.fsf@pullcord.laptop.org> <4D94A510.4040509@canonical.com> <m3fwq3z1yu.fsf@pullcord.laptop.org>
In-Reply-To: <m3fwq3z1yu.fsf@pullcord.laptop.org>
Content-Type: multipart/mixed;
 boundary="------------060703000603000006060303"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060703000603000006060303
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Sorry about that... dmesg is attached.

Manoj Iyer
Ubuntu/Canonical
Hardware Enablement

On 03/31/2011 11:31 AM, Chris Ball wrote:
> Hi,
>
> On Thu, Mar 31 2011, Manoj wrote:
>> Tried your patch, also enabled CONFIG_MMC_DEBUG=y
>> CONFIG_MMC_RICOH_MMC=y, with the same result. MMC did not mount.
>
> Okay, thanks for trying.
>
>> Here is a portion of dmesg:
>
> Please send all of dmesg; I want to see whether the Ricoh code ran.
>
> - Chris.

--------------060703000603000006060303
Content-Type: text/plain;
 name="dmesg.out"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg.out"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.35-28-generic-pae (root@tangerine) (gcc version 4.4.5 (Ubuntu/Linaro 4.4.4-14ubuntu5) ) #50 SMP Thu Mar 31 15:23:42 UTC 2011 (Ubuntu 2.6.35-28.50-generic-pae 2.6.35.11)
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009d800 (usable)
[    0.000000]  BIOS-e820: 000000000009d800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000ba99f000 (usable)
[    0.000000]  BIOS-e820: 00000000ba99f000 - 00000000bae9f000 (reserved)
[    0.000000]  BIOS-e820: 00000000bae9f000 - 00000000baf9f000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000baf9f000 - 00000000bafff000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bafff000 - 00000000bb000000 (usable)
[    0.000000]  BIOS-e820: 00000000bb000000 - 00000000bfa00000 (reserved)
[    0.000000]  BIOS-e820: 00000000f8000000 - 00000000fc000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed08000 - 00000000fed09000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed10000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffd20000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000013e600000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.6 present.
[    0.000000] e820 update range: 0000000000000000 - 0000000000001000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] last_pfn = 0x13e600 max_arch_pfn = 0x1000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0FFC00000 mask FFFC00000 write-protect
[    0.000000]   1 base 000000000 mask F80000000 write-back
[    0.000000]   2 base 080000000 mask FC0000000 write-back
[    0.000000]   3 base 0BC000000 mask FFC000000 uncachable
[    0.000000]   4 base 0BB000000 mask FFF000000 uncachable
[    0.000000]   5 base 100000000 mask FC0000000 write-back
[    0.000000]   6 base 13F000000 mask FFF000000 uncachable
[    0.000000]   7 base 13E800000 mask FFF800000 uncachable
[    0.000000]   8 base 13E600000 mask FFFE00000 uncachable
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 0000000000002000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000001000 (reserved)
[    0.000000]  modified: 0000000000001000 - 0000000000002000 (usable)
[    0.000000]  modified: 0000000000002000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 000000000009d800 (usable)
[    0.000000]  modified: 000000000009d800 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 00000000ba99f000 (usable)
[    0.000000]  modified: 00000000ba99f000 - 00000000bae9f000 (reserved)
[    0.000000]  modified: 00000000bae9f000 - 00000000baf9f000 (ACPI NVS)
[    0.000000]  modified: 00000000baf9f000 - 00000000bafff000 (ACPI data)
[    0.000000]  modified: 00000000bafff000 - 00000000bb000000 (usable)
[    0.000000]  modified: 00000000bb000000 - 00000000bfa00000 (reserved)
[    0.000000]  modified: 00000000f8000000 - 00000000fc000000 (reserved)
[    0.000000]  modified: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  modified: 00000000fed08000 - 00000000fed09000 (reserved)
[    0.000000]  modified: 00000000fed10000 - 00000000fed1a000 (reserved)
[    0.000000]  modified: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  modified: 00000000ffd20000 - 0000000100000000 (reserved)
[    0.000000]  modified: 0000000100000000 - 000000013e600000 (usable)
[    0.000000] initial memory mapped : 0 - 00e00000
[    0.000000] init_memory_mapping: 0000000000000000-0000000037bfe000
[    0.000000]  0000000000 - 0000200000 page 4k
[    0.000000]  0000200000 - 0037a00000 page 2M
[    0.000000]  0037a00000 - 0037bfe000 page 4k
[    0.000000] kernel direct mapping tables up to 37bfe000 @ 15000-1a000
[    0.000000] RAMDISK: 370be000 - 37ff0000
[    0.000000] Allocated new RAMDISK: 00a0a000 - 0193b465
[    0.000000] Move RAMDISK from 00000000370be000 - 0000000037fef464 to 00a0a000 - 0193b464
[    0.000000] ACPI: RSDP 000f00e0 00024 (v02 LENOVO)
[    0.000000] ACPI: XSDT baffe120 000A4 (v01 LENOVO TP-83    00001130 PTEC 00000002)
[    0.000000] ACPI: FACP bafe9000 000F4 (v04 LENOVO TP-83    00001130 PTL  00000002)
[    0.000000] ACPI: DSDT bafec000 0DD2E (v01 LENOVO TP-83    00001130 INTL 20061109)
[    0.000000] ACPI: FACS baf2e000 00040
[    0.000000] ACPI: SLIC baffd000 00176 (v01 LENOVO TP-83    00001130 PTEC 00000001)
[    0.000000] ACPI: SSDT baffc000 00249 (v01 LENOVO TP-SSDT2 00000200 INTL 20061109)
[    0.000000] ACPI: SSDT baffb000 00033 (v01 LENOVO TP-SSDT1 00000100 INTL 20061109)
[    0.000000] ACPI: SSDT baffa000 00797 (v01 LENOVO SataAhci 00001000 INTL 20061109)
[    0.000000] ACPI: HPET bafe8000 00038 (v01 LENOVO TP-83    00001130 PTL  00000002)
[    0.000000] ACPI: APIC bafe7000 00098 (v01 LENOVO TP-83    00001130 PTL  00000002)
[    0.000000] ACPI: MCFG bafe6000 0003C (v01 LENOVO TP-83    00001130 PTL  00000002)
[    0.000000] ACPI: ECDT bafe5000 00052 (v01 LENOVO TP-83    00001130 PTL  00000002)
[    0.000000] ACPI: ASF! bafeb000 000A5 (v32 LENOVO TP-83    00001130 PTL  00000002)
[    0.000000] ACPI: TCPA bafe4000 00032 (v02    PTL   LENOVO 06040000 LNVO 00000001)
[    0.000000] ACPI: SSDT bafe3000 00A27 (v01  PmRef  Cpu0Ist 00003000 INTL 20061109)
[    0.000000] ACPI: SSDT bafe2000 00996 (v01  PmRef    CpuPm 00003000 INTL 20061109)
[    0.000000] ACPI: UEFI bafe1000 0003E (v01 LENOVO TP-83    00001130 PTL  00000002)
[    0.000000] ACPI: UEFI bafe0000 00042 (v01 PTL      COMBUF 00000001 PTL  00000001)
[    0.000000] ACPI: UEFI bafdf000 0027E (v01 LENOVO TP-83    00001130 PTL  00000002)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 4202MB HIGHMEM available.
[    0.000000] 891MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 37bfe000
[    0.000000]   low ram: 0 - 37bfe000
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000001 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x00037bfe
[    0.000000]   HighMem  0x00037bfe -> 0x0013e600
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[5] active PFN ranges
[    0.000000]     0: 0x00000001 -> 0x00000002
[    0.000000]     0: 0x00000010 -> 0x0000009d
[    0.000000]     0: 0x00000100 -> 0x000ba99f
[    0.000000]     0: 0x000bafff -> 0x000bb000
[    0.000000]     0: 0x00100000 -> 0x0013e600
[    0.000000] On node 0 totalpages: 1019694
[    0.000000] free_area_init_node: node 0, pgdat c0844cc0, node_mem_map c193d020
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3950 pages, LIFO batch:0
[    0.000000]   Normal zone: 1752 pages used for memmap
[    0.000000]   Normal zone: 222502 pages, LIFO batch:31
[    0.000000]   HighMem zone: 8405 pages used for memmap
[    0.000000]   HighMem zone: 783053 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] SMP: Allowing 8 CPUs, 4 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] early_res array is doubled to 64 at [16000 - 167ff]
[    0.000000] PM: Registered nosave memory: 0000000000002000 - 0000000000010000
[    0.000000] PM: Registered nosave memory: 000000000009d000 - 000000000009e000
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at bfa00000 (gap: bfa00000:38600000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 15 pages/cpu @c4200000 s39872 r0 d21568 u262144
[    0.000000] pcpu-alloc: s39872 r0 d21568 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] early_res array is doubled to 128 at [16800 - 177ff]
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1009505
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-2.6.35-28-generic-pae root=UUID=26c93f37-84e0-418f-8c40-262eb76c18fa sdhci.debug_quirks=1 ro quiet splash
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] xsave/xrstor: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] allocated 26081260 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] Subtract (60 early reservations)
[    0.000000]   #1 [0000001000 - 0000002000]   EX TRAMPOLINE
[    0.000000]   #2 [0000100000 - 0000a0165c]   TEXT DATA BSS
[    0.000000]   #3 [000009d800 - 0000100000]   BIOS reserved
[    0.000000]   #4 [0000a02000 - 0000a090ed]             BRK
[    0.000000]   #5 [0000010000 - 0000011000]      TRAMPOLINE
[    0.000000]   #6 [0000011000 - 0000015000]     ACPI WAKEUP
[    0.000000]   #7 [0000015000 - 0000016000]         PGTABLE
[    0.000000]   #8 [0000a0a000 - 000193c000]     NEW RAMDISK
[    0.000000]   #9 [000193c000 - 000193d000]         BOOTMEM
[    0.000000]   #10 [000193d000 - 000410d000]         BOOTMEM
[    0.000000]   #11 [000410d000 - 000410d004]         BOOTMEM
[    0.000000]   #12 [000410d040 - 000410d100]         BOOTMEM
[    0.000000]   #13 [000410d100 - 000410d1a8]         BOOTMEM
[    0.000000]   #14 [000410d1c0 - 00041101c0]         BOOTMEM
[    0.000000]   #15 [00041101c0 - 00041104d8]         BOOTMEM
[    0.000000]   #16 [0004110500 - 000411c500]         BOOTMEM
[    0.000000]   #17 [000411c500 - 000411c52d]         BOOTMEM
[    0.000000]   #18 [000411c540 - 000411c56f]         BOOTMEM
[    0.000000]   #19 [000411c580 - 000411c850]         BOOTMEM
[    0.000000]   #20 [000411c880 - 000411c8c0]         BOOTMEM
[    0.000000]   #21 [000411c8c0 - 000411c900]         BOOTMEM
[    0.000000]   #22 [000411c900 - 000411c940]         BOOTMEM
[    0.000000]   #23 [000411c940 - 000411c980]         BOOTMEM
[    0.000000]   #24 [000411c980 - 000411c9c0]         BOOTMEM
[    0.000000]   #25 [000411c9c0 - 000411ca00]         BOOTMEM
[    0.000000]   #26 [000411ca00 - 000411ca40]         BOOTMEM
[    0.000000]   #27 [000411ca40 - 000411ca80]         BOOTMEM
[    0.000000]   #28 [000411ca80 - 000411cac0]         BOOTMEM
[    0.000000]   #29 [000411cac0 - 000411cb00]         BOOTMEM
[    0.000000]   #30 [000411cb00 - 000411cb40]         BOOTMEM
[    0.000000]   #31 [000411cb40 - 000411cb80]         BOOTMEM
[    0.000000]   #32 [000411cb80 - 000411cbc0]         BOOTMEM
[    0.000000]   #33 [000411cbc0 - 000411cc00]         BOOTMEM
[    0.000000]   #34 [000411cc00 - 000411cc40]         BOOTMEM
[    0.000000]   #35 [000411cc40 - 000411cc80]         BOOTMEM
[    0.000000]   #36 [000411cc80 - 000411ccc0]         BOOTMEM
[    0.000000]   #37 [000411ccc0 - 000411ccd0]         BOOTMEM
[    0.000000]   #38 [000411cd00 - 000411cd10]         BOOTMEM
[    0.000000]   #39 [000411cd40 - 000411cdc3]         BOOTMEM
[    0.000000]   #40 [000411ce00 - 000411ce83]         BOOTMEM
[    0.000000]   #41 [0004200000 - 000420f000]         BOOTMEM
[    0.000000]   #42 [0004240000 - 000424f000]         BOOTMEM
[    0.000000]   #43 [0004280000 - 000428f000]         BOOTMEM
[    0.000000]   #44 [00042c0000 - 00042cf000]         BOOTMEM
[    0.000000]   #45 [0004300000 - 000430f000]         BOOTMEM
[    0.000000]   #46 [0004340000 - 000434f000]         BOOTMEM
[    0.000000]   #47 [0004380000 - 000438f000]         BOOTMEM
[    0.000000]   #48 [00043c0000 - 00043cf000]         BOOTMEM
[    0.000000]   #49 [000411eec0 - 000411eec4]         BOOTMEM
[    0.000000]   #50 [000411ef00 - 000411ef04]         BOOTMEM
[    0.000000]   #51 [000411ef40 - 000411ef60]         BOOTMEM
[    0.000000]   #52 [000411ef80 - 000411efa0]         BOOTMEM
[    0.000000]   #53 [000411efc0 - 000411f050]         BOOTMEM
[    0.000000]   #54 [000411f080 - 000411f0b0]         BOOTMEM
[    0.000000]   #55 [000411f0c0 - 00041230c0]         BOOTMEM
[    0.000000]   #56 [00041230c0 - 00041a30c0]         BOOTMEM
[    0.000000]   #57 [00041a30c0 - 00041e30c0]         BOOTMEM
[    0.000000]   #58 [000411cec0 - 000411d200]         BOOTMEM
[    0.000000]   #59 [00043cf000 - 0005cae7ec]         BOOTMEM
[    0.000000] Initializing HighMem for node 0 (00037bfe:0013e600)
[    0.000000] Memory: 3986348k/5216256k available (5095k kernel code, 92428k reserved, 2446k data, 708k init, 3165832k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff16000 - 0xfffff000   ( 932 kB)
[    0.000000]     pkmap   : 0xffc00000 - 0xffe00000   (2048 kB)
[    0.000000]     vmalloc : 0xf83fe000 - 0xffbfe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf7bfe000   ( 891 MB)
[    0.000000]       .init : 0xc085e000 - 0xc090f000   ( 708 kB)
[    0.000000]       .data : 0xc05f9e4a - 0xc085d908   (2446 kB)
[    0.000000]       .text : 0xc0100000 - 0xc05f9e4a   (5095 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU-based detection of stalled CPUs is disabled.
[    0.000000] 	Verbose stalled-CPUs detection is disabled.
[    0.000000] NR_IRQS:2304 nr_irqs:744
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.004000] Detected 2591.555 MHz processor.
[    0.000004] Calibrating delay loop (skipped), value calculated using timer frequency.. 5183.11 BogoMIPS (lpj=10366220)
[    0.000007] pid_max: default: 32768 minimum: 301
[    0.000021] Security Framework initialized
[    0.000032] AppArmor: AppArmor initialized
[    0.000033] Yama: becoming mindful.
[    0.000068] Mount-cache hash table entries: 512
[    0.000149] Initializing cgroup subsys ns
[    0.000152] Initializing cgroup subsys cpuacct
[    0.000156] Initializing cgroup subsys memory
[    0.000172] Initializing cgroup subsys devices
[    0.000173] Initializing cgroup subsys freezer
[    0.000175] Initializing cgroup subsys net_cls
[    0.000194] CPU: Physical Processor ID: 0
[    0.000195] CPU: Processor Core ID: 0
[    0.000200] mce: CPU supports 7 MCE banks
[    0.000210] CPU0: Thermal monitoring enabled (TM1)
[    0.000216] using mwait in idle threads.
[    0.000220] Performance Events: PEBS fmt1+, generic architected perfmon, Intel PMU driver.
[    0.000225] ... version:                3
[    0.000226] ... bit width:              48
[    0.000227] ... generic registers:      4
[    0.000229] ... value mask:             0000ffffffffffff
[    0.000230] ... max period:             000000007fffffff
[    0.000231] ... fixed-purpose events:   3
[    0.000232] ... event mask:             000000070000000f
[    0.002890] ACPI: Core revision 20100428
[    0.017014] ftrace: converting mcount calls to 0f 1f 44 00 00
[    0.017017] ftrace: allocating 22399 entries in 44 pages
[    0.024867] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.025220] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.064891] CPU0: Intel(R) Core(TM) i5-2540M CPU @ 2.60GHz stepping 07
[    0.172251] Booting Node   0, Processors  #1
[    0.182391] Initializing CPU#1
[    0.280172]  #2
[    0.290402] Initializing CPU#2
[    0.388189]  #3
[    0.398419] Initializing CPU#3
[    0.496057] Brought up 4 CPUs
[    0.496059] Total of 4 processors activated (20732.05 BogoMIPS).
[    0.497920] devtmpfs: initialized
[    0.498766] regulator: core version 0.5
[    0.498792] Time: 15:52:38  Date: 03/31/11
[    0.498818] NET: Registered protocol family 16
[    0.498887] Trying to unpack rootfs image as initramfs...
[    0.498913] EISA bus registered
[    0.498918] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.498920] ACPI: bus type pci registered
[    0.499131] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.499133] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.499134] PCI: Using MMCONFIG for extended config space
[    0.499136] PCI: Using configuration type 1 for base access
[    0.499977] bio: create slab <bio-0> at 0
[    0.501814] ACPI: EC: EC description table is found, configuring boot EC
[    0.508970] ACPI: BIOS _OSI(Linux) query ignored
[    0.512903] ACPI: SSDT bae90018 008C0 (v01  PmRef  Cpu0Cst 00003001 INTL 20061109)
[    0.513392] ACPI: Dynamic OEM Table Load:
[    0.513395] ACPI: SSDT (null) 008C0 (v01  PmRef  Cpu0Cst 00003001 INTL 20061109)
[    0.513844] ACPI: SSDT bae91a98 00303 (v01  PmRef    ApIst 00003000 INTL 20061109)
[    0.514361] ACPI: Dynamic OEM Table Load:
[    0.514363] ACPI: SSDT (null) 00303 (v01  PmRef    ApIst 00003000 INTL 20061109)
[    0.514514] ACPI: SSDT bae8fd98 00119 (v01  PmRef    ApCst 00003000 INTL 20061109)
[    0.514992] ACPI: Dynamic OEM Table Load:
[    0.514993] ACPI: SSDT (null) 00119 (v01  PmRef    ApCst 00003000 INTL 20061109)
[    0.516183] ACPI: Interpreter enabled
[    0.516186] ACPI: (supports S0 S3 S4 S5)
[    0.516207] ACPI: Using IOAPIC for interrupt routing
[    0.523323] ACPI: EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
[    0.523483] ACPI: Power Resource [PUBS] (on)
[    0.524559] ACPI: ACPI Dock Station Driver: 2 docks/bays found
[    0.524563] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.524748] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-fe])
[    0.524795] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.524796] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.524799] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.524801] pci_root PNP0A08:00: host bridge window [mem 0xbfa00000-0xfebfffff]
[    0.524803] pci_root PNP0A08:00: host bridge window [mem 0xfed40000-0xfed4bfff]
[    0.524852] pci 0000:00:02.0: reg 10: [mem 0xd0000000-0xd03fffff 64bit]
[    0.524856] pci 0000:00:02.0: reg 18: [mem 0xc0000000-0xcfffffff 64bit pref]
[    0.524860] pci 0000:00:02.0: reg 20: [io  0x5000-0x503f]
[    0.524925] pci 0000:00:16.0: reg 10: [mem 0xd2525000-0xd252500f 64bit]
[    0.524972] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.524976] pci 0000:00:16.0: PME# disabled
[    0.525012] pci 0000:00:16.3: reg 10: [io  0x50b0-0x50b7]
[    0.525019] pci 0000:00:16.3: reg 14: [mem 0xd252c000-0xd252cfff]
[    0.525102] pci 0000:00:19.0: reg 10: [mem 0xd2500000-0xd251ffff]
[    0.525108] pci 0000:00:19.0: reg 14: [mem 0xd252b000-0xd252bfff]
[    0.525114] pci 0000:00:19.0: reg 18: [io  0x5080-0x509f]
[    0.525153] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.525157] pci 0000:00:19.0: PME# disabled
[    0.525198] pci 0000:00:1a.0: reg 10: [mem 0xd252a000-0xd252a3ff]
[    0.525251] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.525256] pci 0000:00:1a.0: PME# disabled
[    0.525292] pci 0000:00:1b.0: reg 10: [mem 0xd2520000-0xd2523fff 64bit]
[    0.525333] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.525337] pci 0000:00:1b.0: PME# disabled
[    0.525445] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.525451] pci 0000:00:1c.0: PME# disabled
[    0.525569] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.525574] pci 0000:00:1c.1: PME# disabled
[    0.525691] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.525696] pci 0000:00:1c.3: PME# disabled
[    0.525813] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.525818] pci 0000:00:1c.4: PME# disabled
[    0.525872] pci 0000:00:1d.0: reg 10: [mem 0xd2529000-0xd25293ff]
[    0.525925] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.525929] pci 0000:00:1d.0: PME# disabled
[    0.526054] pci 0000:00:1f.2: reg 10: [io  0x50a8-0x50af]
[    0.526060] pci 0000:00:1f.2: reg 14: [io  0x50bc-0x50bf]
[    0.526066] pci 0000:00:1f.2: reg 18: [io  0x50a0-0x50a7]
[    0.526072] pci 0000:00:1f.2: reg 1c: [io  0x50b8-0x50bb]
[    0.526077] pci 0000:00:1f.2: reg 20: [io  0x5060-0x507f]
[    0.526083] pci 0000:00:1f.2: reg 24: [mem 0xd2528000-0xd25287ff]
[    0.526113] pci 0000:00:1f.2: PME# supported from D3hot
[    0.526117] pci 0000:00:1f.2: PME# disabled
[    0.526146] pci 0000:00:1f.3: reg 10: [mem 0xd2524000-0xd25240ff 64bit]
[    0.526159] pci 0000:00:1f.3: reg 20: [io  0xefa0-0xefbf]
[    0.526250] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.526255] pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.526261] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.526269] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.526595] pci 0000:03:00.0: reg 10: [mem 0xd2400000-0xd2401fff 64bit]
[    0.527016] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.527051] pci 0000:03:00.0: PME# disabled
[    0.527186] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.527191] pci 0000:00:1c.1:   bridge window [io  0xf000-0x0000] (disabled)
[    0.527196] pci 0000:00:1c.1:   bridge window [mem 0xd2400000-0xd24fffff]
[    0.527204] pci 0000:00:1c.1:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.527275] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    0.527280] pci 0000:00:1c.3:   bridge window [io  0x4000-0x4fff]
[    0.527285] pci 0000:00:1c.3:   bridge window [mem 0xd1c00000-0xd23fffff]
[    0.527293] pci 0000:00:1c.3:   bridge window [mem 0xd0400000-0xd0bfffff 64bit pref]
[    0.527447] pci 0000:0d:00.0: reg 10: [mem 0xd1400000-0xd14000ff]
[    0.527565] pci 0000:0d:00.0: supports D1 D2
[    0.527566] pci 0000:0d:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.527572] pci 0000:0d:00.0: PME# disabled
[    0.527623] pci 0000:00:1c.4: PCI bridge to [bus 0d-0d]
[    0.527627] pci 0000:00:1c.4:   bridge window [io  0x3000-0x3fff]
[    0.527632] pci 0000:00:1c.4:   bridge window [mem 0xd1400000-0xd1bfffff]
[    0.527640] pci 0000:00:1c.4:   bridge window [mem 0xd0c00000-0xd13fffff 64bit pref]
[    0.527673] pci_bus 0000:00: on NUMA node 0
[    0.527677] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.527817] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
[    0.527875] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP2._PRT]
[    0.527930] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP4._PRT]
[    0.527996] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP5._PRT]
[    0.530982] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
[    0.531126] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 *7 9 10 11)
[    0.531268] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
[    0.531408] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
[    0.531549] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 *10 11)
[    0.531677] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.531817] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 *7 9 10 11)
[    0.531957] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 *10 11)
[    0.532018] HEST: Table is not found!
[    0.532074] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.532081] vgaarb: loaded
[    0.532203] SCSI subsystem initialized
[    0.532291] libata version 3.00 loaded.
[    0.532334] usbcore: registered new interface driver usbfs
[    0.532344] usbcore: registered new interface driver hub
[    0.532365] usbcore: registered new device driver usb
[    0.532617] ACPI: WMI: Mapper loaded
[    0.532619] PCI: Using ACPI for IRQ routing
[    0.532621] PCI: pci_cache_line_size set to 64 bytes
[    0.532828] reserve RAM buffer: 0000000000002000 - 000000000000ffff 
[    0.532830] reserve RAM buffer: 000000000009d800 - 000000000009ffff 
[    0.532831] reserve RAM buffer: 00000000ba99f000 - 00000000bbffffff 
[    0.532834] reserve RAM buffer: 00000000bb000000 - 00000000bbffffff 
[    0.532835] reserve RAM buffer: 000000013e600000 - 000000013fffffff 
[    0.532901] NetLabel: Initializing
[    0.532903] NetLabel:  domain hash size = 128
[    0.532904] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.532912] NetLabel:  unlabeled traffic allowed by default
[    0.532944] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.532949] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.534964] Switching to clocksource tsc
[    0.541692] AppArmor: AppArmor Filesystem Enabled
[    0.541702] pnp: PnP ACPI init
[    0.541714] ACPI: bus type pnp registered
[    0.543814] pnp: PnP ACPI: found 11 devices
[    0.543816] ACPI: ACPI bus type pnp unregistered
[    0.543818] PnPBIOS: Disabled by ACPI PNP
[    0.543827] system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.543829] system 00:00: [mem 0x000c0000-0x000c3fff] could not be reserved
[    0.543831] system 00:00: [mem 0x000c4000-0x000c7fff] could not be reserved
[    0.543833] system 00:00: [mem 0x000c8000-0x000cbfff] has been reserved
[    0.543835] system 00:00: [mem 0x000cc000-0x000cffff] has been reserved
[    0.543837] system 00:00: [mem 0x000d0000-0x000d3fff] has been reserved
[    0.543838] system 00:00: [mem 0x000d4000-0x000d7fff] has been reserved
[    0.543840] system 00:00: [mem 0x000d8000-0x000dbfff] has been reserved
[    0.543842] system 00:00: [mem 0x000dc000-0x000dffff] has been reserved
[    0.543844] system 00:00: [mem 0x000e0000-0x000e3fff] could not be reserved
[    0.543846] system 00:00: [mem 0x000e4000-0x000e7fff] could not be reserved
[    0.543848] system 00:00: [mem 0x000e8000-0x000ebfff] could not be reserved
[    0.543849] system 00:00: [mem 0x000ec000-0x000effff] could not be reserved
[    0.543851] system 00:00: [mem 0x000f0000-0x000fffff] could not be reserved
[    0.543853] system 00:00: [mem 0x00100000-0xbf9fffff] could not be reserved
[    0.543855] system 00:00: [mem 0xfec00000-0xfed3ffff] could not be reserved
[    0.543857] system 00:00: [mem 0xfed4c000-0xffffffff] could not be reserved
[    0.543863] system 00:02: [io  0x0400-0x047f] has been reserved
[    0.543864] system 00:02: [io  0x0500-0x057f] has been reserved
[    0.543866] system 00:02: [io  0x0800-0x080f] has been reserved
[    0.543868] system 00:02: [io  0x15e0-0x15ef] has been reserved
[    0.543870] system 00:02: [io  0x1600-0x167f] has been reserved
[    0.543872] system 00:02: [mem 0xf8000000-0xfbffffff] has been reserved
[    0.543874] system 00:02: [mem 0x00000000-0x00000fff] could not be reserved
[    0.543876] system 00:02: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.543878] system 00:02: [mem 0xfed10000-0xfed13fff] has been reserved
[    0.543880] system 00:02: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.543882] system 00:02: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.543884] system 00:02: [mem 0xfed45000-0xfed4bfff] has been reserved
[    0.579433] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.579435] pci 0000:00:1c.0:   bridge window [io  disabled]
[    0.579442] pci 0000:00:1c.0:   bridge window [mem disabled]
[    0.579446] pci 0000:00:1c.0:   bridge window [mem pref disabled]
[    0.579455] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.579456] pci 0000:00:1c.1:   bridge window [io  disabled]
[    0.579463] pci 0000:00:1c.1:   bridge window [mem 0xd2400000-0xd24fffff]
[    0.579468] pci 0000:00:1c.1:   bridge window [mem pref disabled]
[    0.579476] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    0.579479] pci 0000:00:1c.3:   bridge window [io  0x4000-0x4fff]
[    0.579486] pci 0000:00:1c.3:   bridge window [mem 0xd1c00000-0xd23fffff]
[    0.579492] pci 0000:00:1c.3:   bridge window [mem 0xd0400000-0xd0bfffff 64bit pref]
[    0.579500] pci 0000:00:1c.4: PCI bridge to [bus 0d-0d]
[    0.579504] pci 0000:00:1c.4:   bridge window [io  0x3000-0x3fff]
[    0.579510] pci 0000:00:1c.4:   bridge window [mem 0xd1400000-0xd1bfffff]
[    0.579515] pci 0000:00:1c.4:   bridge window [mem 0xd0c00000-0xd13fffff 64bit pref]
[    0.579537]   alloc irq_desc for 16 on node -1
[    0.579539]   alloc kstat_irqs on node -1
[    0.579544] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.579551] pci 0000:00:1c.0: setting latency timer to 64
[    0.579562]   alloc irq_desc for 17 on node -1
[    0.579563]   alloc kstat_irqs on node -1
[    0.579566] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.579571] pci 0000:00:1c.1: setting latency timer to 64
[    0.579581]   alloc irq_desc for 19 on node -1
[    0.579582]   alloc kstat_irqs on node -1
[    0.579585] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    0.579590] pci 0000:00:1c.3: setting latency timer to 64
[    0.579601] pci 0000:00:1c.4: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.579605] pci 0000:00:1c.4: setting latency timer to 64
[    0.579609] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.579611] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.579612] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.579614] pci_bus 0000:00: resource 7 [mem 0xbfa00000-0xfebfffff]
[    0.579615] pci_bus 0000:00: resource 8 [mem 0xfed40000-0xfed4bfff]
[    0.579617] pci_bus 0000:03: resource 1 [mem 0xd2400000-0xd24fffff]
[    0.579619] pci_bus 0000:05: resource 0 [io  0x4000-0x4fff]
[    0.579620] pci_bus 0000:05: resource 1 [mem 0xd1c00000-0xd23fffff]
[    0.579622] pci_bus 0000:05: resource 2 [mem 0xd0400000-0xd0bfffff 64bit pref]
[    0.579624] pci_bus 0000:0d: resource 0 [io  0x3000-0x3fff]
[    0.579625] pci_bus 0000:0d: resource 1 [mem 0xd1400000-0xd1bfffff]
[    0.579627] pci_bus 0000:0d: resource 2 [mem 0xd0c00000-0xd13fffff 64bit pref]
[    0.579653] NET: Registered protocol family 2
[    0.579705] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.579871] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.580068] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.580158] TCP: Hash tables configured (established 131072 bind 65536)
[    0.580160] TCP reno registered
[    0.580162] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    0.580166] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    0.580235] NET: Registered protocol family 1
[    0.580244] pci 0000:00:02.0: Boot video device
[    0.580379] PCI: CLS 64 bytes, default 64
[    0.580632] cpufreq-nforce2: No nForce2 chipset.
[    0.580655] Scanning for low memory corruption every 60 seconds
[    0.580744] audit: initializing netlink socket (disabled)
[    0.580751] type=2000 audit(1301586757.424:1): initialized
[    0.588387] highmem bounce pool size: 64 pages
[    0.588391] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.589368] VFS: Disk quotas dquot_6.5.2
[    0.589412] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.589807] fuse init (API version 7.14)
[    0.589869] msgmni has been set to 1602
[    0.774920] Freeing initrd memory: 15560k freed
[    0.779150] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.779153] io scheduler noop registered
[    0.779155] io scheduler deadline registered
[    0.779163] io scheduler cfq registered (default)
[    0.779247] pcieport 0000:00:1c.0: setting latency timer to 64
[    0.779303]   alloc irq_desc for 40 on node -1
[    0.779305]   alloc kstat_irqs on node -1
[    0.779317] pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
[    0.779410] pcieport 0000:00:1c.1: setting latency timer to 64
[    0.779463]   alloc irq_desc for 41 on node -1
[    0.779464]   alloc kstat_irqs on node -1
[    0.779473] pcieport 0000:00:1c.1: irq 41 for MSI/MSI-X
[    0.779562] pcieport 0000:00:1c.3: setting latency timer to 64
[    0.779615]   alloc irq_desc for 42 on node -1
[    0.779616]   alloc kstat_irqs on node -1
[    0.779626] pcieport 0000:00:1c.3: irq 42 for MSI/MSI-X
[    0.779722] pcieport 0000:00:1c.4: setting latency timer to 64
[    0.779775]   alloc irq_desc for 43 on node -1
[    0.779777]   alloc kstat_irqs on node -1
[    0.779786] pcieport 0000:00:1c.4: irq 43 for MSI/MSI-X
[    0.779892] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.779907] Firmware did not grant requested _OSC control
[    0.779913] Firmware did not grant requested _OSC control
[    0.779930] Firmware did not grant requested _OSC control
[    0.779935] Firmware did not grant requested _OSC control
[    0.779945] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.780010] intel_idle: MWAIT substates: 0x21120
[    0.780011] intel_idle: v0.4 model 0x2A
[    0.780012] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.780294] ACPI: AC Adapter [AC] (off-line)
[    0.780345] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input0
[    0.780533] ACPI: Lid Switch [LID]
[    0.780566] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input1
[    0.780569] ACPI: Sleep Button [SLPB]
[    0.780605] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    0.780608] ACPI: Power Button [PWRF]
[    0.780786] ACPI: acpi_idle yielding to intel_idle
[    0.784570] thermal LNXTHERM:01: registered as thermal_zone0
[    0.784576] ACPI: Thermal Zone [THM0] (49 C)
[    0.784629] ERST: Table is not found!
[    0.784683] isapnp: Scanning for PnP cards...
[    0.784917] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.785470] serial 0000:00:16.3: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    0.785576] 0000:00:16.3: ttyS0 at I/O 0x50b0 (irq = 19) is a 16550A
[    0.786744] brd: module loaded
[    0.787280] loop: module loaded
[    0.787849] Fixed MDIO Bus: probed
[    0.787876] PPP generic driver version 2.4.2
[    0.787906] tun: Universal TUN/TAP device driver, 1.6
[    0.787908] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    0.788015] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.788336] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[    0.788988] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[    0.788996] ehci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.789007] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[    0.789029] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[    0.789100] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    0.789125] ehci_hcd 0000:00:1a.0: debug port 2
[    0.793015] ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
[    0.793028] ehci_hcd 0000:00:1a.0: irq 16, io mem 0xd252a000
[    0.796914] ACPI: Battery Slot [BAT0] (battery present)
[    0.807889] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    0.807977] hub 1-0:1.0: USB hub found
[    0.807980] hub 1-0:1.0: 3 ports detected
[    0.808159] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    0.808297] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    0.808303]   alloc irq_desc for 23 on node -1
[    0.808304]   alloc kstat_irqs on node -1
[    0.808308] ehci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    0.808318] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[    0.808321] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[    0.808347] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    0.808369] ehci_hcd 0000:00:1d.0: debug port 2
[    0.812255] ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
[    0.812266] ehci_hcd 0000:00:1d.0: irq 23, io mem 0xd2529000
[    0.827881] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    0.827960] hub 2-0:1.0: USB hub found
[    0.827963] hub 2-0:1.0: 3 ports detected
[    0.828007] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.828016] uhci_hcd: USB Universal Host Controller Interface driver
[    0.828077] PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    0.830966] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.830970] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.831028] mice: PS/2 mouse device common for all mice
[    0.831117] rtc_cmos 00:07: RTC can wake from S4
[    0.831142] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
[    0.831169] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    0.831234] device-mapper: uevent: version 1.0.3
[    0.831310] device-mapper: ioctl: 4.17.0-ioctl (2010-03-05) initialised: dm-devel@redhat.com
[    0.831386] device-mapper: multipath: version 1.1.1 loaded
[    0.831389] device-mapper: multipath round-robin: version 1.0.0 loaded
[    0.831470] EISA: Probing bus 0 at eisa.0
[    0.831472] EISA: Cannot allocate resource for mainboard
[    0.831474] Cannot allocate resource for EISA slot 1
[    0.831475] Cannot allocate resource for EISA slot 2
[    0.831477] Cannot allocate resource for EISA slot 3
[    0.831478] Cannot allocate resource for EISA slot 4
[    0.831480] Cannot allocate resource for EISA slot 5
[    0.831482] Cannot allocate resource for EISA slot 6
[    0.831483] Cannot allocate resource for EISA slot 7
[    0.831485] Cannot allocate resource for EISA slot 8
[    0.831486] EISA: Detected 0 cards.
[    0.831715] cpuidle: using governor ladder
[    0.831936] cpuidle: using governor menu
[    0.832112] TCP cubic registered
[    0.832244] NET: Registered protocol family 10
[    0.832592] lo: Disabled Privacy Extensions
[    0.832776] NET: Registered protocol family 17
[    0.834959] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
[    0.836475] Using IPI No-Shortcut mode
[    0.836540] PM: Resume from disk failed.
[    0.836550] registered taskstats version 1
[    0.836890]   Magic number: 3:242:893
[    0.836942] rtc_cmos 00:07: setting system clock to 2011-03-31 15:52:38 UTC (1301586758)
[    0.836944] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    0.836946] EDD information not available.
[    1.119819] usb 1-1: new high speed USB device using ehci_hcd and address 2
[    1.138376] isapnp: No Plug & Play device found
[    1.138392] Freeing unused kernel memory: 708k freed
[    1.138617] Write protecting the kernel text: 5096k
[    1.138669] Write protecting the kernel read-only data: 2028k
[    1.151314] udev[101]: starting version 163
[    1.172945] Linux agpgart interface v0.103
[    1.176793] sdhci: Secure Digital Host Controller Interface driver
[    1.176795] sdhci: Copyright(c) Pierre Ossman
[    1.178043] sdhci-pci 0000:0d:00.0: SDHCI controller found [1180:e823] (rev 5)
[    1.178049] sdhci-pci 0000:0d:00.0: found 1 slot(s)
[    1.178071] sdhci-pci 0000:0d:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.178139] mmc0: Unknown controller version (2). You may experience problems.
[    1.178149] sdhci-pci 0000:0d:00.0: setting latency timer to 64
[    1.178163] sdhci: ============== REGISTER DUMP ==============
[    1.178169] sdhci: Sys addr: 0x00000000 | Version:  0x00000502
[    1.178174] sdhci: Blk size: 0x00000000 | Blk cnt:  0x00000000
[    1.178180] sdhci: Argument: 0x00000000 | Trn mode: 0x00000000
[    1.178186] sdhci: Present:  0x01f20000 | Host ctl: 0x00000000
[    1.178192] sdhci: Power:    0x00000000 | Blk gap:  0x00000000
[    1.178197] sdhci: Wake-up:  0x00000000 | Clock:    0x00000000
[    1.178203] sdhci: Timeout:  0x00000000 | Int stat: 0x00000000
[    1.178209] sdhci: Int enab: 0x00ff0003 | Sig enab: 0x00ff0003
[    1.178214] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[    1.178220] sdhci: Caps:     0x21e8c8b2 | Max curr: 0x00000040
[    1.178226] sdhci: ADMA Err: 0x00000000 | ADMA Ptr: 0x00000000
[    1.178227] sdhci: ===========================================
[    1.178250] Registered led device: mmc0::
[    1.178272] mmc0: clock 0Hz busmode 1 powermode 0 cs 0 Vdd 0 width 0 timing 0
[    1.178331] mmc0: clock 0Hz busmode 1 powermode 1 cs 0 Vdd 21 width 0 timing 0
[    1.178409] mmc0: SDHCI controller on PCI [0000:0d:00.0] using ADMA
[    1.186216] agpgart-intel 0000:00:00.0: Intel Sandybridge Chipset
[    1.187272] agpgart-intel 0000:00:00.0: detected 65532K stolen memory, trimming to 32768K
[    1.190407] e1000e: Intel(R) PRO/1000 Network Driver - 1.0.2-k4
[    1.190409] e1000e: Copyright (c) 1999 - 2009 Intel Corporation.
[    1.206059] mmc0: clock 400000Hz busmode 1 powermode 2 cs 0 Vdd 21 width 0 timing 0
[    1.212187] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xc0000000
[    1.212204] ahci 0000:00:1f.2: version 3.0
[    1.212221] ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    1.212258]   alloc irq_desc for 44 on node -1
[    1.212260]   alloc kstat_irqs on node -1
[    1.212270] ahci 0000:00:1f.2: irq 44 for MSI/MSI-X
[    1.212309] ahci: SSS flag set, parallel bus scan disabled
[    1.219649] mmc0: starting CMD52 arg 00000c00 flags 00000195
[    1.221698] mmc0: req done (CMD52): -123: 00000000 00000000 00000000 00000000
[    1.221704] mmc0: starting CMD52 arg 80000c08 flags 00000195
[    1.223714] mmc0: req done (CMD52): -123: 00000000 00000000 00000000 00000000
[    1.223719] mmc0: clock 400000Hz busmode 1 powermode 2 cs 1 Vdd 21 width 0 timing 0
[    1.224717] mmc0: starting CMD0 arg 00000000 flags 000000c0
[    1.226726] mmc0: req done (CMD0): -123: 00000000 00000000 00000000 00000000
[    1.227723] mmc0: clock 400000Hz busmode 1 powermode 2 cs 0 Vdd 21 width 0 timing 0
[    1.228720] mmc0: starting CMD8 arg 000001aa flags 000002f5
[    1.230724] mmc0: req done (CMD8): -123: 00000000 00000000 00000000 00000000
[    1.230728] mmc0: starting CMD5 arg 00000000 flags 000002e1
[    1.230919] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x1b impl SATA mode
[    1.230922] ahci 0000:00:1f.2: flags: 64bit ncq sntf ilck stag pm led clo pio slum part ems sxs apst 
[    1.230927] ahci 0000:00:1f.2: setting latency timer to 64
[    1.232731] mmc0: req failed (CMD5): -123, retrying...
[    1.234730] mmc0: req failed (CMD5): -123, retrying...
[    1.236730] mmc0: req failed (CMD5): -123, retrying...
[    1.238731] mmc0: req done (CMD5): -123: 00000000 00000000 00000000 00000000
[    1.238735] mmc0: starting CMD55 arg 00000000 flags 000000f5
[    1.240741] mmc0: req done (CMD55): -123: 00000000 00000000 00000000 00000000
[    1.240746] mmc0: starting CMD55 arg 00000000 flags 000000f5
[    1.242754] mmc0: req done (CMD55): -123: 00000000 00000000 00000000 00000000
[    1.242758] mmc0: starting CMD55 arg 00000000 flags 000000f5
[    1.242895] [drm] Initialized drm 1.1.0 20060810
[    1.244764] mmc0: req done (CMD55): -123: 00000000 00000000 00000000 00000000
[    1.244768] mmc0: starting CMD55 arg 00000000 flags 000000f5
[    1.246774] mmc0: req done (CMD55): -123: 00000000 00000000 00000000 00000000
[    1.246780] mmc0: starting CMD1 arg 00000000 flags 000000e1
[    1.248787] mmc0: req done (CMD1): -123: 00000000 00000000 00000000 00000000
[    1.248792] mmc0: clock 0Hz busmode 1 powermode 0 cs 0 Vdd 0 width 0 timing 0
[    1.255386] scsi0 : ahci
[    1.255502] scsi1 : ahci
[    1.255560] scsi2 : ahci
[    1.255617] scsi3 : ahci
[    1.255754] scsi4 : ahci
[    1.255852] scsi5 : ahci
[    1.256689] ata1: SATA max UDMA/133 abar m2048@0xd2528000 port 0xd2528100 irq 44
[    1.256692] ata2: SATA max UDMA/133 abar m2048@0xd2528000 port 0xd2528180 irq 44
[    1.256693] ata3: DUMMY
[    1.256695] ata4: SATA max UDMA/133 abar m2048@0xd2528000 port 0xd2528280 irq 44
[    1.256698] ata5: SATA max UDMA/133 abar m2048@0xd2528000 port 0xd2528300 irq 44
[    1.256699] ata6: DUMMY
[    1.256759]   alloc irq_desc for 20 on node -1
[    1.256761]   alloc kstat_irqs on node -1
[    1.256767] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    1.256775] e1000e 0000:00:19.0: setting latency timer to 64
[    1.256846]   alloc irq_desc for 45 on node -1
[    1.256847]   alloc kstat_irqs on node -1
[    1.256855] e1000e 0000:00:19.0: irq 45 for MSI/MSI-X
[    1.263697] hub 1-1:1.0: USB hub found
[    1.263792] hub 1-1:1.0: 6 ports detected
[    1.378853] usb 2-1: new high speed USB device using ehci_hcd and address 2
[    1.379633] e1000e 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:21:cc:49:ca:80
[    1.379636] e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    1.379684] e1000e 0000:00:19.0: eth0: MAC: 10, PHY: 11, PBA No: 1000ff-0ff
[    1.379773] i915 0000:00:02.0: power state changed by ACPI to D0
[    1.379805] i915 0000:00:02.0: power state changed by ACPI to D0
[    1.379811] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.379814] i915 0000:00:02.0: setting latency timer to 64
[    1.390635] [drm] detected 63M stolen memory, trimming to 32M
[    1.390723]   alloc irq_desc for 46 on node -1
[    1.390724]   alloc kstat_irqs on node -1
[    1.390730] i915 0000:00:02.0: irq 46 for MSI/MSI-X
[    1.390737] [drm] set up 32M of stolen space
[    1.507726] hub 2-1:1.0: USB hub found
[    1.507838] hub 2-1:1.0: 8 ports detected
[    1.566562] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    1.575549] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.576399] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    1.576403] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    1.576405] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    1.577247] ata1.00: ATA-8: HITACHI HTS725032A9A364, PC3ZC70F, max UDMA/100
[    1.577249] ata1.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    1.578214] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    1.578216] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    1.578219] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    1.579073] ata1.00: configured for UDMA/100
[    1.582985] usb 1-1.3: new full speed USB device using ehci_hcd and address 3
[    1.600645] ata1.00: configured for UDMA/100
[    1.600647] ata1: EH complete
[    1.600721] scsi 0:0:0:0: Direct-Access     ATA      HITACHI HTS72503 PC3Z PQ: 0 ANSI: 5
[    1.600832] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.600857] sd 0:0:0:0: [sda] 625142448 512-byte logical blocks: (320 GB/298 GiB)
[    1.600903] sd 0:0:0:0: [sda] Write Protect is off
[    1.600905] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.600917] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.601015]  sda:
[    1.754805] usb 1-1.4: new full speed USB device using ehci_hcd and address 4
[    1.823603] Skipping EDID probe due to cached edid
[    1.904545]  sda1 sda2 <
[    1.926954] usb 1-1.6: new high speed USB device using ehci_hcd and address 5
[    1.928104]  sda5 >
[    1.928448] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.323054] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.325257] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
[    2.325492] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
[    2.325495] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    2.326359] Console: switching to colour frame buffer device 170x48
[    2.327066] ata2.00: ATAPI: HL-DT-STDVDRAM GT33N, LT20, max UDMA/66
[    2.328385] fb0: inteldrmfb frame buffer device
[    2.328386] drm: registered panic notifier
[    2.328388] Slow work thread pool: Starting up
[    2.328423] Slow work thread pool: Ready
[    2.329807] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
[    2.330041] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
[    2.330043] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    2.330783] acpi device:00: registered as cooling_device4
[    2.331112] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input4
[    2.331145] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[    2.331173] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    2.331528] ata2.00: configured for UDMA/66
[    2.348507] scsi 1:0:0:0: CD-ROM            HL-DT-ST DVDRAM GT33N     LT20 PQ: 0 ANSI: 5
[    2.353111] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    2.353120] Uniform CD-ROM driver Revision: 3.20
[    2.353305] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    2.353363] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    2.671260] ata4: SATA link down (SStatus 0 SControl 300)
[    3.006399] ata5: SATA link down (SStatus 0 SControl 300)
[    3.947828] Skipping EDID probe due to cached edid
[    4.258577] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[   12.395918] udev[428]: starting version 163
[   12.408882] lp: driver loaded but no devices found
[   12.459861] Adding 12286972k swap on /dev/sda5.  Priority:-1 extents:1 across:12286972k 
[   12.508223] tpm_tis 00:0a: 1.2 TPM (device-id 0x0, rev-id 78)
[   12.513625] Compat-wireless backport release: compat-wireless-v2.6.37-4
[   12.513628] Backport based on linux-2.6-allstable.git v2.6.37
[   12.522536] Non-volatile memory driver v1.3
[   12.534493] Bluetooth: Core ver 2.15
[   12.550928] NET: Registered protocol family 31
[   12.550931] Bluetooth: HCI device and connection manager initialized
[   12.550933] Bluetooth: HCI socket layer initialized
[   12.555761] Bluetooth: Generic Bluetooth USB driver ver 0.6
[   12.555932] Linux video capture interface: v2.00
[   12.558962] uvcvideo: Found UVC 1.00 device Integrated Camera (04f2:b221)
[   12.562858] cfg80211: Calling CRDA to update world regulatory domain
[   12.563519] input: Integrated Camera as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.6/1-1.6:1.0/input/input5
[   12.563571] usbcore: registered new interface driver uvcvideo
[   12.563573] USB Video Class driver (v0.1.0)
[   12.567480] usbcore: registered new interface driver btusb
[   12.573290] cfg80211: World regulatory domain updated:
[   12.573292]     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   12.573294]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   12.573296]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   12.573297]     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   12.573298]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   12.573300]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   12.575932] type=1400 audit(1301586770.241:2): apparmor="STATUS" operation="profile_load" name="/sbin/dhclient3" pid=735 comm="apparmor_parser"
[   12.576477] type=1400 audit(1301586770.241:3): apparmor="STATUS" operation="profile_load" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=735 comm="apparmor_parser"
[   12.576664] type=1400 audit(1301586770.241:4): apparmor="STATUS" operation="profile_replace" name="/sbin/dhclient3" pid=771 comm="apparmor_parser"
[   12.576769] type=1400 audit(1301586770.241:5): apparmor="STATUS" operation="profile_load" name="/usr/lib/connman/scripts/dhclient-script" pid=735 comm="apparmor_parser"
[   12.577181] type=1400 audit(1301586770.241:6): apparmor="STATUS" operation="profile_replace" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=771 comm="apparmor_parser"
[   12.577477] type=1400 audit(1301586770.241:7): apparmor="STATUS" operation="profile_replace" name="/usr/lib/connman/scripts/dhclient-script" pid=771 comm="apparmor_parser"
[   12.604874] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:sutton2
[   12.604877] iwlagn: Copyright(c) 2003-2010 Intel Corporation
[   12.605002] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   12.605034] iwlagn 0000:03:00.0: setting latency timer to 64
[   12.605119] iwlagn 0000:03:00.0: Detected 6000 Series 2x2 AGN Gen2a, REV=0xB0
[   12.615664] iwlagn 0000:03:00.0: device EEPROM VER=0x715, CALIB=0x6
[   12.615688] iwlagn 0000:03:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
[   12.615864]   alloc irq_desc for 47 on node -1
[   12.615865]   alloc kstat_irqs on node -1
[   12.615922] iwlagn 0000:03:00.0: irq 47 for MSI/MSI-X
[   12.638657]   alloc irq_desc for 22 on node -1
[   12.638660]   alloc kstat_irqs on node -1
[   12.638666] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[   12.638714]   alloc irq_desc for 48 on node -1
[   12.638715]   alloc kstat_irqs on node -1
[   12.638725] HDA Intel 0000:00:1b.0: irq 48 for MSI/MSI-X
[   12.638751] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   12.650074] iwlagn 0000:03:00.0: loaded firmware version 17.168.5.2 build 35905
[   12.654798] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
[   12.686743] thinkpad_acpi: ThinkPad ACPI Extras v0.24sutton1
[   12.686746] thinkpad_acpi: http://ibm-acpi.sf.net/
[   12.686747] thinkpad_acpi: ThinkPad BIOS 83ET43WW (1.13 ), EC unknown
[   12.686749] thinkpad_acpi: Lenovo ThinkPad T420, model 4177Q2U
[   12.686959] thinkpad_acpi: detected a 16-level brightness capable ThinkPad
[   12.687335] thinkpad_acpi: radio switch found; radios are enabled
[   12.687349] thinkpad_acpi: This ThinkPad has standard ACPI backlight brightness control, supported by the ACPI video driver
[   12.687351] thinkpad_acpi: Disabling thinkpad-acpi brightness events by default...
[   12.690520] thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio is unblocked
[   12.691072] Registered led device: tpacpi::thinklight
[   12.691103] Registered led device: tpacpi::power
[   12.691121] Registered led device: tpacpi::standby
[   12.691137] Registered led device: tpacpi::thinkvantage
[   12.691144] thinkpad_acpi: Standard ACPI backlight interface available, not loading native one.
[   12.691209] thinkpad_acpi: Console audio control enabled, mode: monitor (read only)
[   12.693242] input: ThinkPad Extra Buttons as /devices/platform/thinkpad_acpi/input/input6
[   12.796027] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro
[   12.948400] type=1400 audit(1301586770.613:8): apparmor="STATUS" operation="profile_replace" name="/sbin/dhclient3" pid=1025 comm="apparmor_parser"
[   12.948928] type=1400 audit(1301586770.613:9): apparmor="STATUS" operation="profile_replace" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=1025 comm="apparmor_parser"
[   12.949219] type=1400 audit(1301586770.613:10): apparmor="STATUS" operation="profile_replace" name="/usr/lib/connman/scripts/dhclient-script" pid=1025 comm="apparmor_parser"
[   12.949853] type=1400 audit(1301586770.613:11): apparmor="STATUS" operation="profile_load" name="/usr/lib/cups/backend/cups-pdf" pid=1028 comm="apparmor_parser"
[   13.083497] e1000e 0000:00:19.0: irq 45 for MSI/MSI-X
[   13.125146] Bluetooth: L2CAP ver 2.14
[   13.125148] Bluetooth: L2CAP socket layer initialized
[   13.128980] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   13.128982] Bluetooth: BNEP filters: protocol multicast
[   13.131673] Bluetooth: SCO (Voice Link) ver 0.6
[   13.131675] Bluetooth: SCO socket layer initialized
[   13.139288] e1000e 0000:00:19.0: irq 45 for MSI/MSI-X
[   13.139483] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   13.199038] Bluetooth: RFCOMM TTY layer initialized
[   13.199042] Bluetooth: RFCOMM socket layer initialized
[   13.199044] Bluetooth: RFCOMM ver 1.11
[   13.226040] Skipping EDID probe due to cached edid
[   13.270549] ppdev: user-space parallel port driver
[   13.285223] Synaptics Touchpad, model: 1, fw: 7.2, id: 0x1c0b1, caps: 0xd047b1/0xb40000/0xa0000
[   13.285227] serio: Synaptics pass-through port at isa0060/serio1/input0
[   13.334200] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input7
[   13.404978] Skipping EDID probe due to cached edid
[   13.513470] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   14.005320] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro,commit=600
[   14.735369] Skipping EDID probe due to cached edid
[   14.901596] Skipping EDID probe due to cached edid
[   15.065822] Skipping EDID probe due to cached edid
[   15.229298] Skipping EDID probe due to cached edid
[   15.352564] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro,commit=600
[   15.539154] Skipping EDID probe due to cached edid
[   16.066495] psmouse serio2: ID: 10 00 64
[   19.907259] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[   20.153405] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/serio2/input/input8
[   20.811021] Skipping EDID probe due to cached edid
[   26.840087] wlan0: authenticate with 00:23:69:ed:6f:b2 (try 1)
[   26.843485] wlan0: authenticated
[   26.858840] wlan0: associate with 00:23:69:ed:6f:b2 (try 1)
[   26.863309] wlan0: RX AssocResp from 00:23:69:ed:6f:b2 (capab=0x411 status=0 aid=9)
[   26.863318] wlan0: associated
[   26.873607] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   27.508892] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000040
[   27.706286] mmc0: clock 0Hz busmode 1 powermode 1 cs 0 Vdd 21 width 0 timing 0
[   27.722274] mmc0: clock 400000Hz busmode 1 powermode 2 cs 0 Vdd 21 width 0 timing 0
[   27.738270] mmc0: starting CMD52 arg 00000c00 flags 00000195
[   27.738399] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[   27.740399] mmc0: req done (CMD52): -110: 00000000 00000000 00000000 00000000
[   27.740407] mmc0: starting CMD52 arg 80000c08 flags 00000195
[   27.740485] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[   27.742492] mmc0: req done (CMD52): -110: 00000000 00000000 00000000 00000000
[   27.742497] mmc0: clock 400000Hz busmode 1 powermode 2 cs 1 Vdd 21 width 0 timing 0
[   27.743493] mmc0: starting CMD0 arg 00000000 flags 000000c0
[   27.743540] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
[   27.743546] mmc0: req done (CMD0): 0: 00000000 00000000 00000000 00000000
[   27.744543] mmc0: clock 400000Hz busmode 1 powermode 2 cs 0 Vdd 21 width 0 timing 0
[   27.745539] mmc0: starting CMD8 arg 000001aa flags 000002f5
[   27.745580] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[   27.747584] mmc0: req done (CMD8): -110: 00000000 00000000 00000000 00000000
[   27.747639] mmc0: starting CMD5 arg 00000000 flags 000002e1
[   27.747675] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[   27.749671] mmc0: req failed (CMD5): -110, retrying...
[   27.749708] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[   27.751710] mmc0: req failed (CMD5): -110, retrying...
[   27.751743] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[   27.753738] mmc0: req failed (CMD5): -110, retrying...
[   27.753771] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[   27.755771] mmc0: req done (CMD5): -110: 00000000 00000000 00000000 00000000
[   27.755790] mmc0: starting CMD55 arg 00000000 flags 000000f5
[   27.755826] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[   27.757824] mmc0: req done (CMD55): -110: 00000000 00000000 00000000 00000000
[   27.757828] mmc0: starting CMD55 arg 00000000 flags 000000f5
[   27.757863] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[   27.759863] mmc0: req done (CMD55): -110: 00000000 00000000 00000000 00000000
[   27.759905] mmc0: starting CMD55 arg 00000000 flags 000000f5
[   27.759941] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[   27.761939] mmc0: req done (CMD55): -110: 00000000 00000000 00000000 00000000
[   27.761942] mmc0: starting CMD55 arg 00000000 flags 000000f5
[   27.761981] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[   27.763985] mmc0: req done (CMD55): -110: 00000000 00000000 00000000 00000000
[   27.764026] mmc0: starting CMD1 arg 00000000 flags 000000e1
[   27.764060] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
[   27.764067] mmc0: req done (CMD1): 0: 003f8000 00000000 00000000 00000000
[   27.764072] mmc0: clock 400000Hz busmode 1 powermode 2 cs 0 Vdd 20 width 0 timing 0
[   27.764077] mmc0: clock 400000Hz busmode 1 powermode 2 cs 1 Vdd 20 width 0 timing 0
[   27.765073] mmc0: starting CMD0 arg 00000000 flags 000000c0
[   27.765096] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
[   27.765100] mmc0: req done (CMD0): 0: 00000000 00000000 00000000 00000000
[   27.766094] mmc0: clock 400000Hz busmode 1 powermode 2 cs 0 Vdd 20 width 0 timing 0
[   27.767090] mmc0: starting CMD1 arg 40300000 flags 000000e1
[   27.767129] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
[   27.767142] mmc0: req done (CMD1): 0: 003f8000 00000000 00000000 00000000
[   27.782251] mmc0: starting CMD1 arg 40300000 flags 000000e1
[   27.782309] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
[   27.782324] mmc0: req done (CMD1): 0: 003f8000 00000000 00000000 00000000
[   27.798246] mmc0: starting CMD1 arg 40300000 flags 000000e1
[   27.798320] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
[   27.798336] mmc0: req done (CMD1): 0: 003f8000 00000000 00000000 00000000
[   27.814242] mmc0: starting CMD1 arg 40300000 flags 000000e1
[   27.814314] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
[   27.814331] mmc0: req done (CMD1): 0: 003f8000 00000000 00000000 00000000
[   27.830232] mmc0: starting CMD1 arg 40300000 flags 000000e1
[   27.830288] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
[   27.830304] mmc0: req done (CMD1): 0: 003f8000 00000000 00000000 00000000
[   27.846231] mmc0: starting CMD1 arg 40300000 flags 000000e1
[   27.846285] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
[   27.846301] mmc0: req done (CMD1): 0: 003f8000 00000000 00000000 00000000
[   27.862226] mmc0: starting CMD1 arg 40300000 flags 000000e1
[   27.862299] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
[   27.862315] mmc0: req done (CMD1): 0: 003f8000 00000000 00000000 00000000
[   27.878217] mmc0: starting CMD1 arg 40300000 flags 000000e1
[   27.878273] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
[   27.878290] mmc0: req done (CMD1): 0: 803f8000 00000000 00000000 00000000
[   27.878303] mmc0: starting CMD2 arg 00000000 flags 00000067
[   27.878359] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
[   27.878382] mmc0: req done (CMD2): 0: ffffffff ffffffff ffffffff ffffff00
[   27.878399] mmc0: starting CMD3 arg 00010000 flags 00000015
[   27.878438] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[   27.880442] mmc0: req failed (CMD3): -110, retrying...
[   27.880474] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[   27.882468] mmc0: req failed (CMD3): -110, retrying...
[   27.882501] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[   27.884498] mmc0: req failed (CMD3): -110, retrying...
[   27.884532] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[   27.886530] mmc0: req done (CMD3): -110: 00000000 00000000 00000000 00000000
[   27.886537] mmc0: clock 0Hz busmode 1 powermode 0 cs 0 Vdd 0 width 0 timing 0
[   27.886548] mmc0: error -110 whilst initialising MMC card
[   27.886550] mmc0: clock 0Hz busmode 1 powermode 0 cs 0 Vdd 0 width 0 timing 0
[   37.471039] wlan0: no IPv6 routers present
[  472.228899] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro,commit=0
[  473.476826] usb 1-1.4: USB disconnect, address 4
[  473.476909] btusb_bulk_complete: hci0 urb f5083b80 failed to resubmit (19)
[  473.477012] btusb_intr_complete: hci0 urb f5083200 failed to resubmit (19)
[  473.477158] btusb_bulk_complete: hci0 urb f5083800 failed to resubmit (19)
[  473.477231] btusb_send_frame: hci0 urb f3d3fd00 submission failed
[  473.616116] wlan0: deauthenticating from 00:23:69:ed:6f:b2 by local choice (reason=3)
[  473.680565] cfg80211: All devices are disconnected, going to restore regulatory settings
[  473.680580] cfg80211: Restoring regulatory settings
[  473.680590] cfg80211: Calling CRDA to update world regulatory domain
[  473.689715] cfg80211: World regulatory domain updated:
[  473.689723]     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[  473.689730]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  473.689737]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[  473.689743]     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[  473.689748]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  473.689753]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  474.014786] PM: Syncing filesystems ... done.
[  474.015255] PM: Preparing system for mem sleep
[  474.431846] Freezing user space processes ... (elapsed 0.01 seconds) done.
[  474.447715] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[  474.463700] PM: Entering mem sleep
[  474.463794] Suspending console(s) (use no_console_suspend to debug)
[  474.622909] PM: suspend of drv:psmouse dev:serio2 complete after 159.058 msecs
[  474.623142] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  474.623336] sd 0:0:0:0: [sda] Stopping disk
[  474.863570] PM: suspend of drv:tpm_tis dev:00:0a complete after 189.821 msecs
[  474.863709] mmc0: clock 0Hz busmode 1 powermode 0 cs 0 Vdd 0 width 0 timing 0
[  474.864227] ehci_hcd 0000:00:1d.0: PCI INT A disabled
[  474.864477] ehci_hcd 0000:00:1a.0: PCI INT A disabled
[  474.866161] sdhci-pci 0000:0d:00.0: PCI INT A disabled
[  474.866199] ACPI handle has no context!
[  474.895721] i915 0000:00:02.0: power state changed by ACPI to D3
[  474.990703] e1000e 0000:00:19.0: PCI INT A disabled
[  474.990708] e1000e 0000:00:19.0: PME# enabled
[  474.990713] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
[  475.003495] PM: suspend of drv:e1000e dev:0000:00:19.0 complete after 139.049 msecs
[  475.071552] HDA Intel 0000:00:1b.0: PCI INT A disabled
[  475.087456] PM: suspend of drv:HDA Intel dev:0000:00:1b.0 complete after 223.283 msecs
[  475.097867] PM: suspend of drv:sd dev:0:0:0:0 complete after 474.873 msecs
[  475.097975] PM: suspend of drv:scsi dev:target0:0:0 complete after 474.985 msecs
[  475.097993] PM: suspend of drv:scsi dev:host0 complete after 474.958 msecs
[  475.191419] PM: suspend of drv:ahci dev:0000:00:1f.2 complete after 327.513 msecs
[  475.191539] PM: suspend of drv: dev:pci0000:00 complete after 325.418 msecs
[  475.191575] PM: suspend of devices complete after 727.923 msecs
[  475.191577] PM: suspend devices took 0.728 seconds
[  475.235768] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D3
[  475.275765] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D3
[  475.275815] PM: late suspend of devices complete after 84.259 msecs
[  475.315743] ACPI: Preparing to enter system sleep state S3
[  475.447741] PM: Saving platform NVS memory
[  475.465640] Disabling non-boot CPUs ...
[  475.467890] Broke affinity for irq 47
[  475.469088] CPU 1 is now offline
[  475.472629] CPU 2 is now offline
[  475.475521] Broke affinity for irq 1
[  475.475554] Broke affinity for irq 16
[  475.579276] CPU 3 is now offline
[  475.579283] SMP alternatives: switching to UP code
[  475.583542] Extended CMOS year: 2000
[  475.583821] Back to C!
[  475.583823] PM: Restoring platform NVS memory
[  475.594806] Extended CMOS year: 2000
[  475.594831] Enabling non-boot CPUs ...
[  475.594941] SMP alternatives: switching to SMP code
[  475.599766] Booting Node 0 Processor 1 APIC 0x1
[  475.610005] Initializing CPU#1
[  475.758668] CPU1 is up
[  475.758893] Booting Node 0 Processor 2 APIC 0x2
[  475.769116] Initializing CPU#2
[  475.934852] CPU2 is up
[  475.935046] Booting Node 0 Processor 3 APIC 0x3
[  475.945261] Initializing CPU#3
[  476.122830] CPU3 is up
[  476.124702] ACPI: Waking up from system sleep state S3
[  476.302710] ACPI: \_SB_.PCI0.LPC_.EC__.BAT1 - docking
[  476.330442] ACPI: Unable to dock!
[  476.430696] i915 0000:00:02.0: restoring config space at offset 0xf (was 0x100, writing 0x10b)
[  476.430704] i915 0000:00:02.0: restoring config space at offset 0x1 (was 0x900007, writing 0x900407)
[  476.430721] pci 0000:00:16.0: restoring config space at offset 0xf (was 0x100, writing 0x10b)
[  476.430734] pci 0000:00:16.0: restoring config space at offset 0x4 (was 0xfed0a004, writing 0xd2525004)
[  476.430740] pci 0000:00:16.0: restoring config space at offset 0x1 (was 0x100006, writing 0x180006)
[  476.430757] serial 0000:00:16.3: restoring config space at offset 0xf (was 0x200, writing 0x20b)
[  476.430769] serial 0000:00:16.3: restoring config space at offset 0x5 (was 0x0, writing 0xd252c000)
[  476.430773] serial 0000:00:16.3: restoring config space at offset 0x4 (was 0x1, writing 0x50b1)
[  476.430778] serial 0000:00:16.3: restoring config space at offset 0x1 (was 0xb00000, writing 0xb00007)
[  476.430798] e1000e 0000:00:19.0: restoring config space at offset 0xf (was 0x100, writing 0x10a)
[  476.430809] e1000e 0000:00:19.0: restoring config space at offset 0x6 (was 0x1, writing 0x5081)
[  476.430816] e1000e 0000:00:19.0: restoring config space at offset 0x1 (was 0x100002, writing 0x100007)
[  476.430839] ehci_hcd 0000:00:1a.0: restoring config space at offset 0xf (was 0x100, writing 0x10b)
[  476.430853] ehci_hcd 0000:00:1a.0: restoring config space at offset 0x4 (was 0x0, writing 0xd252a000)
[  476.430859] ehci_hcd 0000:00:1a.0: restoring config space at offset 0x1 (was 0x2900000, writing 0x2900002)
[  476.474628] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[  476.482639] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[  476.482660] HDA Intel 0000:00:1b.0: restoring config space at offset 0xf (was 0x100, writing 0x107)
[  476.482673] HDA Intel 0000:00:1b.0: restoring config space at offset 0x4 (was 0x4, writing 0xd2520004)
[  476.482677] HDA Intel 0000:00:1b.0: restoring config space at offset 0x3 (was 0x0, writing 0x10)
[  476.482682] HDA Intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100002)
[  476.482716] pcieport 0000:00:1c.0: restoring config space at offset 0xf (was 0x100, writing 0x10b)
[  476.482730] pcieport 0000:00:1c.0: restoring config space at offset 0x9 (was 0x10001, writing 0x1fff1)
[  476.482735] pcieport 0000:00:1c.0: restoring config space at offset 0x8 (was 0x0, writing 0xfff0)
[  476.482740] pcieport 0000:00:1c.0: restoring config space at offset 0x7 (was 0x20000000, writing 0x200000f0)
[  476.482750] pcieport 0000:00:1c.0: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
[  476.482756] pcieport 0000:00:1c.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100404)
[  476.482817] pcieport 0000:00:1c.1: restoring config space at offset 0xf (was 0x200, writing 0x207)
[  476.482831] pcieport 0000:00:1c.1: restoring config space at offset 0x9 (was 0x10001, writing 0x1fff1)
[  476.482836] pcieport 0000:00:1c.1: restoring config space at offset 0x8 (was 0x0, writing 0xd240d240)
[  476.482841] pcieport 0000:00:1c.1: restoring config space at offset 0x7 (was 0x0, writing 0xf0)
[  476.482851] pcieport 0000:00:1c.1: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
[  476.482856] pcieport 0000:00:1c.1: restoring config space at offset 0x1 (was 0x100000, writing 0x100407)
[  476.482916] pcieport 0000:00:1c.3: restoring config space at offset 0xf (was 0x400, writing 0x40b)
[  476.482929] pcieport 0000:00:1c.3: restoring config space at offset 0x9 (was 0x10001, writing 0xd0b1d041)
[  476.482933] pcieport 0000:00:1c.3: restoring config space at offset 0x8 (was 0x0, writing 0xd230d1c0)
[  476.482938] pcieport 0000:00:1c.3: restoring config space at offset 0x7 (was 0x20000000, writing 0x4040)
[  476.482948] pcieport 0000:00:1c.3: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
[  476.482955] pcieport 0000:00:1c.3: restoring config space at offset 0x1 (was 0x100000, writing 0x100407)
[  476.483014] pcieport 0000:00:1c.4: restoring config space at offset 0xf (was 0x100, writing 0x10b)
[  476.483027] pcieport 0000:00:1c.4: restoring config space at offset 0x9 (was 0x10001, writing 0xd131d0c1)
[  476.483032] pcieport 0000:00:1c.4: restoring config space at offset 0x8 (was 0x0, writing 0xd1b0d140)
[  476.483036] pcieport 0000:00:1c.4: restoring config space at offset 0x7 (was 0x20000000, writing 0x3030)
[  476.483046] pcieport 0000:00:1c.4: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
[  476.483052] pcieport 0000:00:1c.4: restoring config space at offset 0x1 (was 0x100000, writing 0x100407)
[  476.483100] ehci_hcd 0000:00:1d.0: restoring config space at offset 0xf (was 0x100, writing 0x10a)
[  476.483115] ehci_hcd 0000:00:1d.0: restoring config space at offset 0x4 (was 0x0, writing 0xd2529000)
[  476.483121] ehci_hcd 0000:00:1d.0: restoring config space at offset 0x1 (was 0x2900000, writing 0x2900002)
[  476.490635] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[  476.498629] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[  476.498693] ahci 0000:00:1f.2: restoring config space at offset 0x1 (was 0x2b00403, writing 0x2b00407)
[  476.498861] iwlagn 0000:03:00.0: restoring config space at offset 0xf (was 0x100, writing 0x107)
[  476.498989] iwlagn 0000:03:00.0: restoring config space at offset 0x4 (was 0x4, writing 0xd2400004)
[  476.499024] iwlagn 0000:03:00.0: restoring config space at offset 0x3 (was 0x0, writing 0x10)
[  476.499068] iwlagn 0000:03:00.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100006)
[  476.499365] sdhci-pci 0000:0d:00.0: restoring config space at offset 0xf (was 0x1ff, writing 0x10b)
[  476.499402] sdhci-pci 0000:0d:00.0: restoring config space at offset 0x1 (was 0x100002, writing 0x100006)
[  476.499465] PM: early resume of devices complete after 68.818 msecs
[  476.499752] i915 0000:00:02.0: power state changed by ACPI to D0
[  476.499774] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[  476.499780] e1000e 0000:00:19.0: PME# disabled
[  476.499959] e1000e 0000:00:19.0: irq 45 for MSI/MSI-X
[  476.500087] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[  476.500119] HDA Intel 0000:00:1b.0: setting latency timer to 64
[  476.500159] HDA Intel 0000:00:1b.0: irq 48 for MSI/MSI-X
[  476.500202] ahci 0000:00:1f.2: setting latency timer to 64
[  476.500270] sdhci-pci 0000:0d:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[  476.500375] i915 0000:00:02.0: power state changed by ACPI to D0
[  476.500378] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[  476.500380] i915 0000:00:02.0: setting latency timer to 64
[  476.500493] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[  476.500644] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[  476.500649] ehci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[  476.500655] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[  476.503482] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[  476.503487] ehci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[  476.503492] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[  476.514763] sd 0:0:0:0: [sda] Starting disk
[  476.686213] PM: resume of drv:usb dev:1-1 complete after 185.648 msecs
[  476.686242] PM: resume of drv:hub dev:1-1:1.0 complete after 185.620 msecs
[  476.758350] usb 1-1.6: reset high speed USB device using ehci_hcd and address 5
[  476.834648] ata5: SATA link down (SStatus 0 SControl 300)
[  476.842156] ata4: SATA link down (SStatus 0 SControl 300)
[  476.858153] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[  476.860652] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
[  476.860896] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
[  476.860907] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[  476.865221] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
[  476.865447] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
[  476.865456] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[  476.867073] ata2.00: configured for UDMA/66
[  477.002623] sdhci-pci 0000:0d:00.0: setting latency timer to 64
[  477.002769] PM: resume of drv:sdhci-pci dev:0000:0d:00.0 complete after 503.039 msecs
[  477.002797] PM: resume of drv:leds dev:mmc0:: complete after 463.432 msecs
[  477.021045] usb 1-1.3: reset full speed USB device using ehci_hcd and address 3
[  477.036801] PM: resume of drv:usb dev:1-1.6 complete after 536.037 msecs
[  477.036837] PM: resume of drv:uvcvideo dev:1-1.6:1.1 complete after 535.980 msecs
[  477.036909] PM: resume of drv:uvcvideo dev:1-1.6:1.0 complete after 536.089 msecs
[  477.115385] PM: resume of drv:usb dev:1-1.3 complete after 614.698 msecs
[  477.115482] PM: resume of drv:usb dev:1-1.3:1.0 complete after 614.788 msecs
[  478.205941] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  478.214968] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[  478.214980] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[  478.214988] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[  478.217914] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[  478.217930] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[  478.217938] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[  478.219399] ata1.00: configured for UDMA/100
[  478.236952] ata1.00: configured for UDMA/100
[  478.236965] ata1: EH complete
[  478.256047] PM: resume of drv:sd dev:0:0:0:0 complete after 1755.865 msecs
[  478.256072] PM: resume of drv:scsi_disk dev:0:0:0:0 complete after 1253.657 msecs
[  478.256203] PM: resume of drv:scsi_device dev:0:0:0:0 complete after 1755.932 msecs
[  478.257976] PM: resume of devices complete after 1759.068 msecs
[  478.258065] PM: resume devices took 1.760 seconds
[  478.258083] PM: Finishing wakeup.
[  478.258084] Restarting tasks ... done.
[  478.261144] video LNXVIDEO:00: Restoring backlight state
[  478.261151] mmc0: clock 0Hz busmode 1 powermode 1 cs 0 Vdd 20 width 0 timing 0
[  478.277622] mmc0: clock 400000Hz busmode 1 powermode 2 cs 0 Vdd 20 width 0 timing 0
[  478.293624] mmc0: starting CMD52 arg 00000c00 flags 00000195
[  478.293727] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[  478.295751] mmc0: req done (CMD52): -110: 00000000 00000000 00000000 00000000
[  478.295764] mmc0: starting CMD52 arg 80000c08 flags 00000195
[  478.295899] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[  478.297919] mmc0: req done (CMD52): -110: 00000000 00000000 00000000 00000000
[  478.298126] mmc0: clock 400000Hz busmode 1 powermode 2 cs 1 Vdd 20 width 0 timing 0
[  478.299131] mmc0: starting CMD0 arg 00000000 flags 000000c0
[  478.299168] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
[  478.299182] mmc0: req done (CMD0): 0: 00000000 00000000 00000000 00000000
[  478.300215] mmc0: clock 400000Hz busmode 1 powermode 2 cs 0 Vdd 20 width 0 timing 0
[  478.301217] mmc0: starting CMD8 arg 000001aa flags 000002f5
[  478.301260] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[  478.303290] mmc0: req done (CMD8): -110: 00000000 00000000 00000000 00000000
[  478.303306] mmc0: starting CMD5 arg 00000000 flags 000002e1
[  478.303351] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[  478.305354] mmc0: req failed (CMD5): -110, retrying...
[  478.305392] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[  478.307407] mmc0: req failed (CMD5): -110, retrying...
[  478.307456] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[  478.309459] mmc0: req failed (CMD5): -110, retrying...
[  478.309501] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[  478.310522] mmc0: req done (CMD5): -110: 00000000 00000000 00000000 00000000
[  478.310565] mmc0: starting CMD55 arg 00000000 flags 000000f5
[  478.310608] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[  478.311620] mmc0: req done (CMD55): -110: 00000000 00000000 00000000 00000000
[  478.311623] mmc0: starting CMD55 arg 00000000 flags 000000f5
[  478.311668] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[  478.312685] mmc0: req done (CMD55): -110: 00000000 00000000 00000000 00000000
[  478.312688] mmc0: starting CMD55 arg 00000000 flags 000000f5
[  478.312730] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[  478.313744] mmc0: req done (CMD55): -110: 00000000 00000000 00000000 00000000
[  478.313804] mmc0: starting CMD55 arg 00000000 flags 000000f5
[  478.313847] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[  478.314864] mmc0: req done (CMD55): -110: 00000000 00000000 00000000 00000000
[  478.314868] mmc0: starting CMD1 arg 00000000 flags 000000e1
[  478.314910] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[  478.315861] Skipping EDID probe due to cached edid
[  478.316921] mmc0: req done (CMD1): -110: 00000000 00000000 00000000 00000000
[  478.316926] mmc0: clock 0Hz busmode 1 powermode 0 cs 0 Vdd 0 width 0 timing 0
[  478.365685] e1000e 0000:00:19.0: irq 45 for MSI/MSI-X
[  478.421603] e1000e 0000:00:19.0: irq 45 for MSI/MSI-X
[  478.421761] ADDRCONF(NETDEV_UP): eth0: link is not ready
[  478.545020] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  478.557824] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000080
[  478.761462] mmc0: clock 0Hz busmode 1 powermode 1 cs 0 Vdd 20 width 0 timing 0
[  478.777461] mmc0: clock 400000Hz busmode 1 powermode 2 cs 0 Vdd 20 width 0 timing 0
[  478.789433] mmc0: starting CMD52 arg 00000c00 flags 00000195
[  478.791484] mmc0: req done (CMD52): -123: 00000000 00000000 00000000 00000000
[  478.791491] mmc0: starting CMD52 arg 80000c08 flags 00000195
[  478.793514] mmc0: req done (CMD52): -123: 00000000 00000000 00000000 00000000
[  478.794018] mmc0: clock 400000Hz busmode 1 powermode 2 cs 1 Vdd 20 width 0 timing 0
[  478.795016] mmc0: starting CMD0 arg 00000000 flags 000000c0
[  478.797261] mmc0: req done (CMD0): -123: 00000000 00000000 00000000 00000000
[  478.798324] mmc0: clock 400000Hz busmode 1 powermode 2 cs 0 Vdd 20 width 0 timing 0
[  478.799323] mmc0: starting CMD8 arg 000001aa flags 000002f5
[  478.801524] mmc0: req done (CMD8): -123: 00000000 00000000 00000000 00000000
[  478.801605] mmc0: starting CMD5 arg 00000000 flags 000002e1
[  478.803609] mmc0: req failed (CMD5): -123, retrying...
[  478.805622] mmc0: req failed (CMD5): -123, retrying...
[  478.807623] mmc0: req failed (CMD5): -123, retrying...
[  478.809702] mmc0: req done (CMD5): -123: 00000000 00000000 00000000 00000000
[  478.810185] mmc0: starting CMD55 arg 00000000 flags 000000f5
[  478.812217] mmc0: req done (CMD55): -123: 00000000 00000000 00000000 00000000
[  478.812225] mmc0: starting CMD55 arg 00000000 flags 000000f5
[  478.814988] mmc0: req done (CMD55): -123: 00000000 00000000 00000000 00000000
[  478.815285] mmc0: starting CMD55 arg 00000000 flags 000000f5
[  478.817485] mmc0: req done (CMD55): -123: 00000000 00000000 00000000 00000000
[  478.817609] mmc0: starting CMD55 arg 00000000 flags 000000f5
[  478.819676] mmc0: req done (CMD55): -123: 00000000 00000000 00000000 00000000
[  478.819740] mmc0: starting CMD1 arg 00000000 flags 000000e1
[  478.821939] mmc0: req done (CMD1): -123: 00000000 00000000 00000000 00000000
[  478.821983] mmc0: clock 0Hz busmode 1 powermode 0 cs 0 Vdd 0 width 0 timing 0
[  479.009843] usb 1-1.4: new full speed USB device using ehci_hcd and address 6
[  479.431299] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro,commit=600
[  485.091584] wlan0: authenticate with 00:23:69:ed:6f:b2 (try 1)
[  485.094928] wlan0: authenticated
[  485.101748] wlan0: associate with 00:23:69:ed:6f:b2 (try 1)
[  485.107460] wlan0: RX AssocResp from 00:23:69:ed:6f:b2 (capab=0x411 status=0 aid=10)
[  485.107469] wlan0: associated
[  485.118409] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[  488.460108] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000040
[  488.657760] mmc0: clock 0Hz busmode 1 powermode 1 cs 0 Vdd 20 width 0 timing 0
[  488.673710] mmc0: clock 400000Hz busmode 1 powermode 2 cs 0 Vdd 20 width 0 timing 0
[  488.689728] mmc0: starting CMD52 arg 00000c00 flags 00000195
[  488.689846] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[  488.691856] mmc0: req done (CMD52): -110: 00000000 00000000 00000000 00000000
[  488.691871] mmc0: starting CMD52 arg 80000c08 flags 00000195
[  488.691927] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[  488.693945] mmc0: req done (CMD52): -110: 00000000 00000000 00000000 00000000
[  488.694085] mmc0: clock 400000Hz busmode 1 powermode 2 cs 1 Vdd 20 width 0 timing 0
[  488.695084] mmc0: starting CMD0 arg 00000000 flags 000000c0
[  488.695111] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
[  488.695115] mmc0: req done (CMD0): 0: 00000000 00000000 00000000 00000000
[  488.696116] mmc0: clock 400000Hz busmode 1 powermode 2 cs 0 Vdd 20 width 0 timing 0
[  488.697119] mmc0: starting CMD8 arg 000001aa flags 000002f5
[  488.697173] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[  488.699175] mmc0: req done (CMD8): -110: 00000000 00000000 00000000 00000000
[  488.699180] mmc0: starting CMD5 arg 00000000 flags 000002e1
[  488.699215] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[  488.701210] mmc0: req failed (CMD5): -110, retrying...
[  488.701243] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[  488.703243] mmc0: req failed (CMD5): -110, retrying...
[  488.703291] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[  488.705291] mmc0: req failed (CMD5): -110, retrying...
[  488.705326] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[  488.707330] mmc0: req done (CMD5): -110: 00000000 00000000 00000000 00000000
[  488.707334] mmc0: starting CMD55 arg 00000000 flags 000000f5
[  488.707369] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[  488.709366] mmc0: req done (CMD55): -110: 00000000 00000000 00000000 00000000
[  488.709370] mmc0: starting CMD55 arg 00000000 flags 000000f5
[  488.709414] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[  488.711411] mmc0: req done (CMD55): -110: 00000000 00000000 00000000 00000000
[  488.711414] mmc0: starting CMD55 arg 00000000 flags 000000f5
[  488.711461] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[  488.713463] mmc0: req done (CMD55): -110: 00000000 00000000 00000000 00000000
[  488.713466] mmc0: starting CMD55 arg 00000000 flags 000000f5
[  488.713500] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[  488.715501] mmc0: req done (CMD55): -110: 00000000 00000000 00000000 00000000
[  488.715506] mmc0: starting CMD1 arg 00000000 flags 000000e1
[  488.715544] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
[  488.715551] mmc0: req done (CMD1): 0: 003f8000 00000000 00000000 00000000
[  488.715557] mmc0: clock 400000Hz busmode 1 powermode 2 cs 0 Vdd 20 width 0 timing 0
[  488.715562] mmc0: clock 400000Hz busmode 1 powermode 2 cs 1 Vdd 20 width 0 timing 0
[  488.716558] mmc0: starting CMD0 arg 00000000 flags 000000c0
[  488.716580] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
[  488.716584] mmc0: req done (CMD0): 0: 00000000 00000000 00000000 00000000
[  488.717578] mmc0: clock 400000Hz busmode 1 powermode 2 cs 0 Vdd 20 width 0 timing 0
[  488.718574] mmc0: starting CMD1 arg 40300000 flags 000000e1
[  488.718620] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
[  488.718634] mmc0: req done (CMD1): 0: 003f8000 00000000 00000000 00000000
[  488.733697] mmc0: starting CMD1 arg 40300000 flags 000000e1
[  488.733753] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
[  488.733769] mmc0: req done (CMD1): 0: 003f8000 00000000 00000000 00000000
[  488.749655] mmc0: starting CMD1 arg 40300000 flags 000000e1
[  488.749713] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
[  488.749729] mmc0: req done (CMD1): 0: 003f8000 00000000 00000000 00000000
[  488.765664] mmc0: starting CMD1 arg 40300000 flags 000000e1
[  488.765720] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
[  488.765736] mmc0: req done (CMD1): 0: 003f8000 00000000 00000000 00000000
[  488.781648] mmc0: starting CMD1 arg 40300000 flags 000000e1
[  488.781704] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
[  488.781720] mmc0: req done (CMD1): 0: 003f8000 00000000 00000000 00000000
[  488.797639] mmc0: starting CMD1 arg 40300000 flags 000000e1
[  488.797695] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
[  488.797711] mmc0: req done (CMD1): 0: 003f8000 00000000 00000000 00000000
[  488.813627] mmc0: starting CMD1 arg 40300000 flags 000000e1
[  488.813701] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
[  488.813718] mmc0: req done (CMD1): 0: 003f8000 00000000 00000000 00000000
[  488.829609] mmc0: starting CMD1 arg 40300000 flags 000000e1
[  488.829665] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
[  488.829682] mmc0: req done (CMD1): 0: 803f8000 00000000 00000000 00000000
[  488.829695] mmc0: starting CMD2 arg 00000000 flags 00000067
[  488.829792] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
[  488.829822] mmc0: req done (CMD2): 0: ffffffff ffffffff ffffffff ffffff00
[  488.829848] mmc0: starting CMD3 arg 00010000 flags 00000015
[  488.829913] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[  488.831918] mmc0: req failed (CMD3): -110, retrying...
[  488.831971] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[  488.833989] mmc0: req failed (CMD3): -110, retrying...
[  488.834028] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[  488.836057] mmc0: req failed (CMD3): -110, retrying...
[  488.836094] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[  488.838115] mmc0: req done (CMD3): -110: 00000000 00000000 00000000 00000000
[  488.838140] mmc0: clock 0Hz busmode 1 powermode 0 cs 0 Vdd 0 width 0 timing 0
[  488.838159] mmc0: error -110 whilst initialising MMC card
[  488.838168] mmc0: clock 0Hz busmode 1 powermode 0 cs 0 Vdd 0 width 0 timing 0

--------------060703000603000006060303--

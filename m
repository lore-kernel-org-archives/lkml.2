Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758824Ab1CaR7H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 13:59:07 -0400
Received: from adelie.canonical.com ([91.189.90.139]:45641 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758648Ab1CaR7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 13:59:03 -0400
Message-ID: <4D94C0E5.6070801@canonical.com>
Date: Thu, 31 Mar 2011 12:59:01 -0500
From: Manoj <manoj.iyer@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Chris Ball <cjb@laptop.org>
CC: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: SDHCI: Ricoh [1180:e823] unable to mount MMC cards.
References: <4D93AD5C.1070308@canonical.com>	<m34o6k43c4.fsf@pullcord.laptop.org> <4D93BDA9.1020107@canonical.com>	<m3vcz02mi1.fsf@pullcord.laptop.org> <4D948BC4.6020904@canonical.com>	<m3sju3z6yc.fsf@pullcord.laptop.org> <4D949298.4000701@canonical.com>	<m3oc4rz5kp.fsf@pullcord.laptop.org> <4D94A510.4040509@canonical.com>	<m3fwq3z1yu.fsf@pullcord.laptop.org> <4D94B552.8020108@canonical.com> <m3zkoburoz.fsf@pullcord.laptop.org>
In-Reply-To: <m3zkoburoz.fsf@pullcord.laptop.org>
Content-Type: multipart/mixed;
 boundary="------------000203050800070504050101"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000203050800070504050101
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Card did not mount. New dmesg is attached.

Manoj Iyer
Ubuntu/Canonical
Hardware Enablement

On 03/31/2011 12:26 PM, Chris Ball wrote:
> Hi,
>
> On Thu, Mar 31 2011, Manoj wrote:
>> Sorry about that... dmesg is attached.
>
> Thanks.  I see that the Ricoh code didn't run and that the PCI ID in
> the patch is wrong; in include/linux/pci_ids.h, it should be:
>
> #define PCI_DEVICE_ID_RICOH_R5C823     0xe823
>
> So, please retry with the "e" there in place and resend full dmesg.
>
> - Chris.

--------------000203050800070504050101
Content-Type: text/plain;
 name="dmesg.pci_id.out"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg.pci_id.out"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.35-28-generic-pae (root@tangerine) (gcc version 4.4.5 (Ubuntu/Linaro 4.4.4-14ubuntu5) ) #50 SMP Thu Mar 31 17:24:48 UTC 2011 (Ubuntu 2.6.35-28.50-generic-pae 2.6.35.11)
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
[    0.000000] Allocated new RAMDISK: 00a0a000 - 0193b694
[    0.000000] Move RAMDISK from 00000000370be000 - 0000000037fef693 to 00a0a000 - 0193b693
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
[    0.004000] Detected 2591.215 MHz processor.
[    0.000003] Calibrating delay loop (skipped), value calculated using timer frequency.. 5182.43 BogoMIPS (lpj=10364860)
[    0.000006] pid_max: default: 32768 minimum: 301
[    0.000020] Security Framework initialized
[    0.000031] AppArmor: AppArmor initialized
[    0.000032] Yama: becoming mindful.
[    0.000067] Mount-cache hash table entries: 512
[    0.000149] Initializing cgroup subsys ns
[    0.000152] Initializing cgroup subsys cpuacct
[    0.000156] Initializing cgroup subsys memory
[    0.000161] Initializing cgroup subsys devices
[    0.000163] Initializing cgroup subsys freezer
[    0.000174] Initializing cgroup subsys net_cls
[    0.000193] CPU: Physical Processor ID: 0
[    0.000195] CPU: Processor Core ID: 0
[    0.000199] mce: CPU supports 7 MCE banks
[    0.000210] CPU0: Thermal monitoring enabled (TM1)
[    0.000215] using mwait in idle threads.
[    0.000219] Performance Events: PEBS fmt1+, generic architected perfmon, Intel PMU driver.
[    0.000224] ... version:                3
[    0.000225] ... bit width:              48
[    0.000226] ... generic registers:      4
[    0.000227] ... value mask:             0000ffffffffffff
[    0.000228] ... max period:             000000007fffffff
[    0.000230] ... fixed-purpose events:   3
[    0.000231] ... event mask:             000000070000000f
[    0.002889] ACPI: Core revision 20100428
[    0.017012] ftrace: converting mcount calls to 0f 1f 44 00 00
[    0.017016] ftrace: allocating 22399 entries in 44 pages
[    0.024860] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.025214] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.064880] CPU0: Intel(R) Core(TM) i5-2540M CPU @ 2.60GHz stepping 07
[    0.172250] Booting Node   0, Processors  #1
[    0.182488] Initializing CPU#1
[    0.280257]  #2
[    0.290486] Initializing CPU#2
[    0.388156]  #3
[    0.398385] Initializing CPU#3
[    0.496104] Brought up 4 CPUs
[    0.496106] Total of 4 processors activated (20731.38 BogoMIPS).
[    0.497958] devtmpfs: initialized
[    0.498800] regulator: core version 0.5
[    0.498825] Time: 17:54:50  Date: 03/31/11
[    0.498852] NET: Registered protocol family 16
[    0.498921] Trying to unpack rootfs image as initramfs...
[    0.498947] EISA bus registered
[    0.498952] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.498954] ACPI: bus type pci registered
[    0.499161] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.499164] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.499165] PCI: Using MMCONFIG for extended config space
[    0.499166] PCI: Using configuration type 1 for base access
[    0.500009] bio: create slab <bio-0> at 0
[    0.501817] ACPI: EC: EC description table is found, configuring boot EC
[    0.508966] ACPI: BIOS _OSI(Linux) query ignored
[    0.513005] ACPI: SSDT bae90018 008C0 (v01  PmRef  Cpu0Cst 00003001 INTL 20061109)
[    0.513493] ACPI: Dynamic OEM Table Load:
[    0.513495] ACPI: SSDT (null) 008C0 (v01  PmRef  Cpu0Cst 00003001 INTL 20061109)
[    0.513947] ACPI: SSDT bae91a98 00303 (v01  PmRef    ApIst 00003000 INTL 20061109)
[    0.514465] ACPI: Dynamic OEM Table Load:
[    0.514466] ACPI: SSDT (null) 00303 (v01  PmRef    ApIst 00003000 INTL 20061109)
[    0.514616] ACPI: SSDT bae8fd98 00119 (v01  PmRef    ApCst 00003000 INTL 20061109)
[    0.515094] ACPI: Dynamic OEM Table Load:
[    0.515096] ACPI: SSDT (null) 00119 (v01  PmRef    ApCst 00003000 INTL 20061109)
[    0.516286] ACPI: Interpreter enabled
[    0.516290] ACPI: (supports S0 S3 S4 S5)
[    0.516311] ACPI: Using IOAPIC for interrupt routing
[    0.523426] ACPI: EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
[    0.523585] ACPI: Power Resource [PUBS] (on)
[    0.524654] ACPI: ACPI Dock Station Driver: 2 docks/bays found
[    0.524658] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.524842] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-fe])
[    0.524887] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.524889] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.524891] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.524894] pci_root PNP0A08:00: host bridge window [mem 0xbfa00000-0xfebfffff]
[    0.524896] pci_root PNP0A08:00: host bridge window [mem 0xfed40000-0xfed4bfff]
[    0.524944] pci 0000:00:02.0: reg 10: [mem 0xd0000000-0xd03fffff 64bit]
[    0.524949] pci 0000:00:02.0: reg 18: [mem 0xc0000000-0xcfffffff 64bit pref]
[    0.524953] pci 0000:00:02.0: reg 20: [io  0x5000-0x503f]
[    0.525019] pci 0000:00:16.0: reg 10: [mem 0xd2525000-0xd252500f 64bit]
[    0.525065] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.525070] pci 0000:00:16.0: PME# disabled
[    0.525107] pci 0000:00:16.3: reg 10: [io  0x50b0-0x50b7]
[    0.525112] pci 0000:00:16.3: reg 14: [mem 0xd252c000-0xd252cfff]
[    0.525196] pci 0000:00:19.0: reg 10: [mem 0xd2500000-0xd251ffff]
[    0.525202] pci 0000:00:19.0: reg 14: [mem 0xd252b000-0xd252bfff]
[    0.525208] pci 0000:00:19.0: reg 18: [io  0x5080-0x509f]
[    0.525247] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.525250] pci 0000:00:19.0: PME# disabled
[    0.525290] pci 0000:00:1a.0: reg 10: [mem 0xd252a000-0xd252a3ff]
[    0.525343] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.525347] pci 0000:00:1a.0: PME# disabled
[    0.525382] pci 0000:00:1b.0: reg 10: [mem 0xd2520000-0xd2523fff 64bit]
[    0.525423] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.525427] pci 0000:00:1b.0: PME# disabled
[    0.525535] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.525540] pci 0000:00:1c.0: PME# disabled
[    0.525659] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.525664] pci 0000:00:1c.1: PME# disabled
[    0.525783] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.525788] pci 0000:00:1c.3: PME# disabled
[    0.525906] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.525912] pci 0000:00:1c.4: PME# disabled
[    0.525965] pci 0000:00:1d.0: reg 10: [mem 0xd2529000-0xd25293ff]
[    0.526018] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.526022] pci 0000:00:1d.0: PME# disabled
[    0.526148] pci 0000:00:1f.2: reg 10: [io  0x50a8-0x50af]
[    0.526153] pci 0000:00:1f.2: reg 14: [io  0x50bc-0x50bf]
[    0.526159] pci 0000:00:1f.2: reg 18: [io  0x50a0-0x50a7]
[    0.526165] pci 0000:00:1f.2: reg 1c: [io  0x50b8-0x50bb]
[    0.526171] pci 0000:00:1f.2: reg 20: [io  0x5060-0x507f]
[    0.526176] pci 0000:00:1f.2: reg 24: [mem 0xd2528000-0xd25287ff]
[    0.526207] pci 0000:00:1f.2: PME# supported from D3hot
[    0.526210] pci 0000:00:1f.2: PME# disabled
[    0.526239] pci 0000:00:1f.3: reg 10: [mem 0xd2524000-0xd25240ff 64bit]
[    0.526252] pci 0000:00:1f.3: reg 20: [io  0xefa0-0xefbf]
[    0.526342] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.526348] pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.526353] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.526362] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.526681] pci 0000:03:00.0: reg 10: [mem 0xd2400000-0xd2401fff 64bit]
[    0.527099] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.527127] pci 0000:03:00.0: PME# disabled
[    0.527255] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.527260] pci 0000:00:1c.1:   bridge window [io  0xf000-0x0000] (disabled)
[    0.527265] pci 0000:00:1c.1:   bridge window [mem 0xd2400000-0xd24fffff]
[    0.527273] pci 0000:00:1c.1:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.527345] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    0.527349] pci 0000:00:1c.3:   bridge window [io  0x4000-0x4fff]
[    0.527354] pci 0000:00:1c.3:   bridge window [mem 0xd1c00000-0xd23fffff]
[    0.527363] pci 0000:00:1c.3:   bridge window [mem 0xd0400000-0xd0bfffff 64bit pref]
[    0.527519] pci 0000:0d:00.0: reg 10: [mem 0xd1400000-0xd14000ff]
[    0.527636] pci 0000:0d:00.0: supports D1 D2
[    0.527637] pci 0000:0d:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.527643] pci 0000:0d:00.0: PME# disabled
[    0.527675] pci 0000:00:1c.4: PCI bridge to [bus 0d-0d]
[    0.527679] pci 0000:00:1c.4:   bridge window [io  0x3000-0x3fff]
[    0.527684] pci 0000:00:1c.4:   bridge window [mem 0xd1400000-0xd1bfffff]
[    0.527692] pci 0000:00:1c.4:   bridge window [mem 0xd0c00000-0xd13fffff 64bit pref]
[    0.527725] pci_bus 0000:00: on NUMA node 0
[    0.527729] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.527867] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
[    0.527923] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP2._PRT]
[    0.527978] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP4._PRT]
[    0.528045] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP5._PRT]
[    0.531030] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
[    0.531175] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 *7 9 10 11)
[    0.531317] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
[    0.531458] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
[    0.531598] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 *10 11)
[    0.531727] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.531868] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 *7 9 10 11)
[    0.532012] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 *10 11)
[    0.532070] HEST: Table is not found!
[    0.532126] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.532133] vgaarb: loaded
[    0.532257] SCSI subsystem initialized
[    0.532343] libata version 3.00 loaded.
[    0.532386] usbcore: registered new interface driver usbfs
[    0.532395] usbcore: registered new interface driver hub
[    0.532417] usbcore: registered new device driver usb
[    0.532670] ACPI: WMI: Mapper loaded
[    0.532672] PCI: Using ACPI for IRQ routing
[    0.532674] PCI: pci_cache_line_size set to 64 bytes
[    0.532883] reserve RAM buffer: 0000000000002000 - 000000000000ffff 
[    0.532885] reserve RAM buffer: 000000000009d800 - 000000000009ffff 
[    0.532887] reserve RAM buffer: 00000000ba99f000 - 00000000bbffffff 
[    0.532889] reserve RAM buffer: 00000000bb000000 - 00000000bbffffff 
[    0.532891] reserve RAM buffer: 000000013e600000 - 000000013fffffff 
[    0.532958] NetLabel: Initializing
[    0.532959] NetLabel:  domain hash size = 128
[    0.532960] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.532969] NetLabel:  unlabeled traffic allowed by default
[    0.533001] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.533006] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.535020] Switching to clocksource tsc
[    0.541765] AppArmor: AppArmor Filesystem Enabled
[    0.541776] pnp: PnP ACPI init
[    0.541787] ACPI: bus type pnp registered
[    0.543886] pnp: PnP ACPI: found 11 devices
[    0.543888] ACPI: ACPI bus type pnp unregistered
[    0.543890] PnPBIOS: Disabled by ACPI PNP
[    0.543898] system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.543901] system 00:00: [mem 0x000c0000-0x000c3fff] could not be reserved
[    0.543903] system 00:00: [mem 0x000c4000-0x000c7fff] could not be reserved
[    0.543905] system 00:00: [mem 0x000c8000-0x000cbfff] has been reserved
[    0.543906] system 00:00: [mem 0x000cc000-0x000cffff] has been reserved
[    0.543908] system 00:00: [mem 0x000d0000-0x000d3fff] has been reserved
[    0.543910] system 00:00: [mem 0x000d4000-0x000d7fff] has been reserved
[    0.543912] system 00:00: [mem 0x000d8000-0x000dbfff] has been reserved
[    0.543913] system 00:00: [mem 0x000dc000-0x000dffff] has been reserved
[    0.543915] system 00:00: [mem 0x000e0000-0x000e3fff] could not be reserved
[    0.543917] system 00:00: [mem 0x000e4000-0x000e7fff] could not be reserved
[    0.543919] system 00:00: [mem 0x000e8000-0x000ebfff] could not be reserved
[    0.543921] system 00:00: [mem 0x000ec000-0x000effff] could not be reserved
[    0.543923] system 00:00: [mem 0x000f0000-0x000fffff] could not be reserved
[    0.543925] system 00:00: [mem 0x00100000-0xbf9fffff] could not be reserved
[    0.543927] system 00:00: [mem 0xfec00000-0xfed3ffff] could not be reserved
[    0.543929] system 00:00: [mem 0xfed4c000-0xffffffff] could not be reserved
[    0.543934] system 00:02: [io  0x0400-0x047f] has been reserved
[    0.543936] system 00:02: [io  0x0500-0x057f] has been reserved
[    0.543938] system 00:02: [io  0x0800-0x080f] has been reserved
[    0.543939] system 00:02: [io  0x15e0-0x15ef] has been reserved
[    0.543941] system 00:02: [io  0x1600-0x167f] has been reserved
[    0.543944] system 00:02: [mem 0xf8000000-0xfbffffff] has been reserved
[    0.543945] system 00:02: [mem 0x00000000-0x00000fff] could not be reserved
[    0.543947] system 00:02: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.543949] system 00:02: [mem 0xfed10000-0xfed13fff] has been reserved
[    0.543951] system 00:02: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.543953] system 00:02: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.543955] system 00:02: [mem 0xfed45000-0xfed4bfff] has been reserved
[    0.579504] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.579506] pci 0000:00:1c.0:   bridge window [io  disabled]
[    0.579512] pci 0000:00:1c.0:   bridge window [mem disabled]
[    0.579518] pci 0000:00:1c.0:   bridge window [mem pref disabled]
[    0.579526] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.579527] pci 0000:00:1c.1:   bridge window [io  disabled]
[    0.579535] pci 0000:00:1c.1:   bridge window [mem 0xd2400000-0xd24fffff]
[    0.579540] pci 0000:00:1c.1:   bridge window [mem pref disabled]
[    0.579548] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    0.579552] pci 0000:00:1c.3:   bridge window [io  0x4000-0x4fff]
[    0.579558] pci 0000:00:1c.3:   bridge window [mem 0xd1c00000-0xd23fffff]
[    0.579564] pci 0000:00:1c.3:   bridge window [mem 0xd0400000-0xd0bfffff 64bit pref]
[    0.579573] pci 0000:00:1c.4: PCI bridge to [bus 0d-0d]
[    0.579577] pci 0000:00:1c.4:   bridge window [io  0x3000-0x3fff]
[    0.579584] pci 0000:00:1c.4:   bridge window [mem 0xd1400000-0xd1bfffff]
[    0.579589] pci 0000:00:1c.4:   bridge window [mem 0xd0c00000-0xd13fffff 64bit pref]
[    0.579610]   alloc irq_desc for 16 on node -1
[    0.579611]   alloc kstat_irqs on node -1
[    0.579616] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.579624] pci 0000:00:1c.0: setting latency timer to 64
[    0.579634]   alloc irq_desc for 17 on node -1
[    0.579635]   alloc kstat_irqs on node -1
[    0.579638] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.579643] pci 0000:00:1c.1: setting latency timer to 64
[    0.579654]   alloc irq_desc for 19 on node -1
[    0.579655]   alloc kstat_irqs on node -1
[    0.579658] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    0.579663] pci 0000:00:1c.3: setting latency timer to 64
[    0.579674] pci 0000:00:1c.4: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.579679] pci 0000:00:1c.4: setting latency timer to 64
[    0.579683] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.579685] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.579686] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.579688] pci_bus 0000:00: resource 7 [mem 0xbfa00000-0xfebfffff]
[    0.579690] pci_bus 0000:00: resource 8 [mem 0xfed40000-0xfed4bfff]
[    0.579691] pci_bus 0000:03: resource 1 [mem 0xd2400000-0xd24fffff]
[    0.579693] pci_bus 0000:05: resource 0 [io  0x4000-0x4fff]
[    0.579695] pci_bus 0000:05: resource 1 [mem 0xd1c00000-0xd23fffff]
[    0.579696] pci_bus 0000:05: resource 2 [mem 0xd0400000-0xd0bfffff 64bit pref]
[    0.579698] pci_bus 0000:0d: resource 0 [io  0x3000-0x3fff]
[    0.579699] pci_bus 0000:0d: resource 1 [mem 0xd1400000-0xd1bfffff]
[    0.579701] pci_bus 0000:0d: resource 2 [mem 0xd0c00000-0xd13fffff 64bit pref]
[    0.579728] NET: Registered protocol family 2
[    0.579780] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.579946] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.580142] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.580232] TCP: Hash tables configured (established 131072 bind 65536)
[    0.580234] TCP reno registered
[    0.580236] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    0.580240] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    0.580309] NET: Registered protocol family 1
[    0.580319] pci 0000:00:02.0: Boot video device
[    0.580455] PCI: CLS 64 bytes, default 64
[    0.580709] cpufreq-nforce2: No nForce2 chipset.
[    0.580731] Scanning for low memory corruption every 60 seconds
[    0.580822] audit: initializing netlink socket (disabled)
[    0.580828] type=2000 audit(1301594089.424:1): initialized
[    0.588459] highmem bounce pool size: 64 pages
[    0.588463] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.589437] VFS: Disk quotas dquot_6.5.2
[    0.589480] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.589878] fuse init (API version 7.14)
[    0.589939] msgmni has been set to 1602
[    0.774928] Freeing initrd memory: 15560k freed
[    0.779171] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.779174] io scheduler noop registered
[    0.779175] io scheduler deadline registered
[    0.779184] io scheduler cfq registered (default)
[    0.779269] pcieport 0000:00:1c.0: setting latency timer to 64
[    0.779324]   alloc irq_desc for 40 on node -1
[    0.779325]   alloc kstat_irqs on node -1
[    0.779337] pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
[    0.779431] pcieport 0000:00:1c.1: setting latency timer to 64
[    0.779484]   alloc irq_desc for 41 on node -1
[    0.779485]   alloc kstat_irqs on node -1
[    0.779495] pcieport 0000:00:1c.1: irq 41 for MSI/MSI-X
[    0.779583] pcieport 0000:00:1c.3: setting latency timer to 64
[    0.779637]   alloc irq_desc for 42 on node -1
[    0.779638]   alloc kstat_irqs on node -1
[    0.779647] pcieport 0000:00:1c.3: irq 42 for MSI/MSI-X
[    0.779743] pcieport 0000:00:1c.4: setting latency timer to 64
[    0.779797]   alloc irq_desc for 43 on node -1
[    0.779798]   alloc kstat_irqs on node -1
[    0.779807] pcieport 0000:00:1c.4: irq 43 for MSI/MSI-X
[    0.779916] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.779927] Firmware did not grant requested _OSC control
[    0.779932] Firmware did not grant requested _OSC control
[    0.779949] Firmware did not grant requested _OSC control
[    0.779954] Firmware did not grant requested _OSC control
[    0.779960] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.780028] intel_idle: MWAIT substates: 0x21120
[    0.780029] intel_idle: v0.4 model 0x2A
[    0.780030] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.780429] ACPI: AC Adapter [AC] (on-line)
[    0.780479] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input0
[    0.780666] ACPI: Lid Switch [LID]
[    0.780698] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input1
[    0.780701] ACPI: Sleep Button [SLPB]
[    0.780738] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    0.780741] ACPI: Power Button [PWRF]
[    0.780919] ACPI: acpi_idle yielding to intel_idle
[    0.784748] thermal LNXTHERM:01: registered as thermal_zone0
[    0.784756] ACPI: Thermal Zone [THM0] (50 C)
[    0.784810] ERST: Table is not found!
[    0.784864] isapnp: Scanning for PnP cards...
[    0.785099] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.785652] serial 0000:00:16.3: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    0.785757] 0000:00:16.3: ttyS0 at I/O 0x50b0 (irq = 19) is a 16550A
[    0.786932] brd: module loaded
[    0.787461] loop: module loaded
[    0.787913] Fixed MDIO Bus: probed
[    0.787972] PPP generic driver version 2.4.2
[    0.788019] tun: Universal TUN/TAP device driver, 1.6
[    0.788022] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    0.788146] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.788804] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[    0.789612] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[    0.789620] ehci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.789651] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[    0.789655] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[    0.789726] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    0.789751] ehci_hcd 0000:00:1a.0: debug port 2
[    0.793624] ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
[    0.793666] ehci_hcd 0000:00:1a.0: irq 16, io mem 0xd252a000
[    0.797709] ACPI: Battery Slot [BAT0] (battery present)
[    0.807890] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    0.807977] hub 1-0:1.0: USB hub found
[    0.807980] hub 1-0:1.0: 3 ports detected
[    0.808157] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    0.808296] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    0.808301]   alloc irq_desc for 23 on node -1
[    0.808302]   alloc kstat_irqs on node -1
[    0.808306] ehci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    0.808316] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[    0.808319] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[    0.808346] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    0.808367] ehci_hcd 0000:00:1d.0: debug port 2
[    0.812261] ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
[    0.812273] ehci_hcd 0000:00:1d.0: irq 23, io mem 0xd2529000
[    0.827883] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    0.827960] hub 2-0:1.0: USB hub found
[    0.827963] hub 2-0:1.0: 3 ports detected
[    0.828008] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.828018] uhci_hcd: USB Universal Host Controller Interface driver
[    0.828078] PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    0.831593] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.831597] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.831657] mice: PS/2 mouse device common for all mice
[    0.831745] rtc_cmos 00:07: RTC can wake from S4
[    0.831771] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
[    0.831797] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    0.831863] device-mapper: uevent: version 1.0.3
[    0.831941] device-mapper: ioctl: 4.17.0-ioctl (2010-03-05) initialised: dm-devel@redhat.com
[    0.832030] device-mapper: multipath: version 1.1.1 loaded
[    0.832032] device-mapper: multipath round-robin: version 1.0.0 loaded
[    0.832109] EISA: Probing bus 0 at eisa.0
[    0.832111] EISA: Cannot allocate resource for mainboard
[    0.832113] Cannot allocate resource for EISA slot 1
[    0.832115] Cannot allocate resource for EISA slot 2
[    0.832116] Cannot allocate resource for EISA slot 3
[    0.832118] Cannot allocate resource for EISA slot 4
[    0.832119] Cannot allocate resource for EISA slot 5
[    0.832121] Cannot allocate resource for EISA slot 6
[    0.832122] Cannot allocate resource for EISA slot 7
[    0.832124] Cannot allocate resource for EISA slot 8
[    0.832125] EISA: Detected 0 cards.
[    0.832357] cpuidle: using governor ladder
[    0.832568] cpuidle: using governor menu
[    0.832803] TCP cubic registered
[    0.832932] NET: Registered protocol family 10
[    0.833282] lo: Disabled Privacy Extensions
[    0.833466] NET: Registered protocol family 17
[    0.835980] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
[    0.840394] Using IPI No-Shortcut mode
[    0.840458] PM: Resume from disk failed.
[    0.840467] registered taskstats version 1
[    0.840813]   Magic number: 3:7:948
[    0.840828] tty tty5: hash matches
[    0.840867] rtc_cmos 00:07: setting system clock to 2011-03-31 17:54:50 UTC (1301594090)
[    0.840869] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    0.840871] EDD information not available.
[    1.119905] usb 1-1: new high speed USB device using ehci_hcd and address 2
[    1.138614] isapnp: No Plug & Play device found
[    1.138630] Freeing unused kernel memory: 708k freed
[    1.138854] Write protecting the kernel text: 5096k
[    1.138905] Write protecting the kernel read-only data: 2028k
[    1.151535] udev[101]: starting version 163
[    1.175714] sdhci: Secure Digital Host Controller Interface driver
[    1.175717] sdhci: Copyright(c) Pierre Ossman
[    1.177032] sdhci-pci 0000:0d:00.0: SDHCI controller found [1180:e823] (rev 5)
[    1.177037] sdhci-pci 0000:0d:00.0: found 1 slot(s)
[    1.177057] sdhci-pci 0000:0d:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.177123] mmc0: Unknown controller version (2). You may experience problems.
[    1.177133] sdhci-pci 0000:0d:00.0: setting latency timer to 64
[    1.177152] sdhci: ============== REGISTER DUMP ==============
[    1.177158] sdhci: Sys addr: 0x00000000 | Version:  0x00000502
[    1.177164] sdhci: Blk size: 0x00000000 | Blk cnt:  0x00000000
[    1.177169] sdhci: Argument: 0x00000000 | Trn mode: 0x00000000
[    1.177174] sdhci: Present:  0x01f20000 | Host ctl: 0x00000000
[    1.177180] sdhci: Power:    0x00000000 | Blk gap:  0x00000000
[    1.177185] sdhci: Wake-up:  0x00000000 | Clock:    0x00000000
[    1.177191] sdhci: Timeout:  0x00000000 | Int stat: 0x00000000
[    1.177197] sdhci: Int enab: 0x00ff0003 | Sig enab: 0x00ff0003
[    1.177202] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[    1.177208] sdhci: Caps:     0x21e8c8b2 | Max curr: 0x00000040
[    1.177213] sdhci: ADMA Err: 0x00000000 | ADMA Ptr: 0x00000000
[    1.177215] sdhci: ===========================================
[    1.177236] Registered led device: mmc0::
[    1.177257] mmc0: clock 0Hz busmode 1 powermode 0 cs 0 Vdd 0 width 0 timing 0
[    1.177312] mmc0: SDHCI controller on PCI [0000:0d:00.0] using ADMA
[    1.177316] mmc0: clock 0Hz busmode 1 powermode 1 cs 0 Vdd 21 width 0 timing 0
[    1.180702] Linux agpgart interface v0.103
[    1.185302] agpgart-intel 0000:00:00.0: Intel Sandybridge Chipset
[    1.186298] agpgart-intel 0000:00:00.0: detected 65532K stolen memory, trimming to 32768K
[    1.191181] mmc0: clock 400000Hz busmode 1 powermode 2 cs 0 Vdd 21 width 0 timing 0
[    1.192010] e1000e: Intel(R) PRO/1000 Network Driver - 1.0.2-k4
[    1.192012] e1000e: Copyright (c) 1999 - 2009 Intel Corporation.
[    1.207169] mmc0: starting CMD52 arg 00000c00 flags 00000195
[    1.209219] mmc0: req done (CMD52): -123: 00000000 00000000 00000000 00000000
[    1.209226] mmc0: starting CMD52 arg 80000c08 flags 00000195
[    1.211422] mmc0: req done (CMD52): -123: 00000000 00000000 00000000 00000000
[    1.211436] mmc0: clock 400000Hz busmode 1 powermode 2 cs 1 Vdd 21 width 0 timing 0
[    1.212434] mmc0: starting CMD0 arg 00000000 flags 000000c0
[    1.214446] mmc0: req done (CMD0): -123: 00000000 00000000 00000000 00000000
[    1.214879] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xc0000000
[    1.214898] ahci 0000:00:1f.2: version 3.0
[    1.214913] ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    1.214949]   alloc irq_desc for 44 on node -1
[    1.214951]   alloc kstat_irqs on node -1
[    1.214961] ahci 0000:00:1f.2: irq 44 for MSI/MSI-X
[    1.214998] ahci: SSS flag set, parallel bus scan disabled
[    1.215511] mmc0: clock 400000Hz busmode 1 powermode 2 cs 0 Vdd 21 width 0 timing 0
[    1.216510] mmc0: starting CMD8 arg 000001aa flags 000002f5
[    1.218518] mmc0: req done (CMD8): -123: 00000000 00000000 00000000 00000000
[    1.218525] mmc0: starting CMD5 arg 00000000 flags 000002e1
[    1.220532] mmc0: req failed (CMD5): -123, retrying...
[    1.222535] mmc0: req failed (CMD5): -123, retrying...
[    1.224542] mmc0: req failed (CMD5): -123, retrying...
[    1.226549] mmc0: req done (CMD5): -123: 00000000 00000000 00000000 00000000
[    1.226573] mmc0: starting CMD55 arg 00000000 flags 000000f5
[    1.228582] mmc0: req done (CMD55): -123: 00000000 00000000 00000000 00000000
[    1.228607] mmc0: starting CMD55 arg 00000000 flags 000000f5
[    1.230612] mmc0: req done (CMD55): -123: 00000000 00000000 00000000 00000000
[    1.230617] mmc0: starting CMD55 arg 00000000 flags 000000f5
[    1.231958] [drm] Initialized drm 1.1.0 20060810
[    1.232627] mmc0: req done (CMD55): -123: 00000000 00000000 00000000 00000000
[    1.232632] mmc0: starting CMD55 arg 00000000 flags 000000f5
[    1.234637] mmc0: req done (CMD55): -123: 00000000 00000000 00000000 00000000
[    1.234642] mmc0: starting CMD1 arg 00000000 flags 000000e1
[    1.235644] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x1b impl SATA mode
[    1.235648] ahci 0000:00:1f.2: flags: 64bit ncq sntf ilck stag pm led clo pio slum part ems sxs apst 
[    1.235653] ahci 0000:00:1f.2: setting latency timer to 64
[    1.236651] mmc0: req done (CMD1): -123: 00000000 00000000 00000000 00000000
[    1.236657] mmc0: clock 0Hz busmode 1 powermode 0 cs 0 Vdd 0 width 0 timing 0
[    1.255605] scsi0 : ahci
[    1.255687] scsi1 : ahci
[    1.255741] scsi2 : ahci
[    1.255789] scsi3 : ahci
[    1.255855] hub 1-1:1.0: USB hub found
[    1.255868] scsi4 : ahci
[    1.255936] scsi5 : ahci
[    1.255948] hub 1-1:1.0: 6 ports detected
[    1.256907] ata1: SATA max UDMA/133 abar m2048@0xd2528000 port 0xd2528100 irq 44
[    1.256910] ata2: SATA max UDMA/133 abar m2048@0xd2528000 port 0xd2528180 irq 44
[    1.256911] ata3: DUMMY
[    1.256913] ata4: SATA max UDMA/133 abar m2048@0xd2528000 port 0xd2528280 irq 44
[    1.256915] ata5: SATA max UDMA/133 abar m2048@0xd2528000 port 0xd2528300 irq 44
[    1.256916] ata6: DUMMY
[    1.256952]   alloc irq_desc for 20 on node -1
[    1.256954]   alloc kstat_irqs on node -1
[    1.256959] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    1.256970] e1000e 0000:00:19.0: setting latency timer to 64
[    1.257050]   alloc irq_desc for 45 on node -1
[    1.257051]   alloc kstat_irqs on node -1
[    1.257059] e1000e 0000:00:19.0: irq 45 for MSI/MSI-X
[    1.268584] e1000e 0000:00:19.0: PCI INT A disabled
[    1.268587] e1000e: probe of 0000:00:19.0 failed with error -2
[    1.268651] i915 0000:00:02.0: power state changed by ACPI to D0
[    1.268680] i915 0000:00:02.0: power state changed by ACPI to D0
[    1.268683] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.268685] i915 0000:00:02.0: setting latency timer to 64
[    1.279586] [drm] detected 63M stolen memory, trimming to 32M
[    1.279736] i915 0000:00:02.0: irq 45 for MSI/MSI-X
[    1.279744] [drm] set up 32M of stolen space
[    1.366814] usb 2-1: new high speed USB device using ehci_hcd and address 2
[    1.454771] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    1.499274] hub 2-1:1.0: USB hub found
[    1.499370] hub 2-1:1.0: 8 ports detected
[    1.574912] usb 1-1.3: new full speed USB device using ehci_hcd and address 3
[    1.575236] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.577044] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    1.577047] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    1.577050] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    1.577958] ata1.00: ATA-8: HITACHI HTS725032A9A364, PC3ZC70F, max UDMA/100
[    1.577961] ata1.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    1.578970] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    1.578974] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    1.578976] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    1.579872] ata1.00: configured for UDMA/100
[    1.600752] ata1.00: configured for UDMA/100
[    1.600755] ata1: EH complete
[    1.600838] scsi 0:0:0:0: Direct-Access     ATA      HITACHI HTS72503 PC3Z PQ: 0 ANSI: 5
[    1.600967] sd 0:0:0:0: [sda] 625142448 512-byte logical blocks: (320 GB/298 GiB)
[    1.600973] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.601009] sd 0:0:0:0: [sda] Write Protect is off
[    1.601012] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.601039] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.601177]  sda: sda1 sda2 < sda5 >
[    1.643858] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.726644] Skipping EDID probe due to cached edid
[    1.746859] usb 1-1.4: new full speed USB device using ehci_hcd and address 4
[    1.918679] usb 1-1.6: new high speed USB device using ehci_hcd and address 5
[    2.259001] Console: switching to colour frame buffer device 170x48
[    2.260901] fb0: inteldrmfb frame buffer device
[    2.260903] drm: registered panic notifier
[    2.260905] Slow work thread pool: Starting up
[    2.260988] Slow work thread pool: Ready
[    2.263154] acpi device:00: registered as cooling_device4
[    2.263455] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input4
[    2.263489] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[    2.263517] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    2.323209] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.448284] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
[    2.448516] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
[    2.448529] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    2.450164] ata2.00: ATAPI: HL-DT-STDVDRAM GT33N, LT20, max UDMA/66
[    2.453030] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
[    2.453276] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
[    2.453288] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    2.454887] ata2.00: configured for UDMA/66
[    2.475915] scsi 1:0:0:0: CD-ROM            HL-DT-ST DVDRAM GT33N     LT20 PQ: 0 ANSI: 5
[    2.480431] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    2.480440] Uniform CD-ROM driver Revision: 3.20
[    2.480621] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    2.480678] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    2.798250] ata4: SATA link down (SStatus 0 SControl 300)
[    3.134092] ata5: SATA link down (SStatus 0 SControl 300)
[    3.496173] Skipping EDID probe due to cached edid
[    3.774447] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[   11.747459] udev[427]: starting version 163
[   11.756572] lp: driver loaded but no devices found
[   11.795109] Compat-wireless backport release: compat-wireless-v2.6.37-4
[   11.795112] Backport based on linux-2.6-allstable.git v2.6.37
[   11.837441] Adding 12286972k swap on /dev/sda5.  Priority:-1 extents:1 across:12286972k 
[   11.857133] Linux video capture interface: v2.00
[   11.863965] cfg80211: Calling CRDA to update world regulatory domain
[   11.873671] Bluetooth: Core ver 2.15
[   11.873691] NET: Registered protocol family 31
[   11.873692] Bluetooth: HCI device and connection manager initialized
[   11.873695] Bluetooth: HCI socket layer initialized
[   11.884803] tpm_tis 00:0a: 1.2 TPM (device-id 0x0, rev-id 78)
[   11.890313] Bluetooth: Generic Bluetooth USB driver ver 0.6
[   11.893103] Non-volatile memory driver v1.3
[   11.894161] usbcore: registered new interface driver btusb
[   11.910063] type=1400 audit(1301594101.569:2): apparmor="STATUS" operation="profile_load" name="/sbin/dhclient3" pid=692 comm="apparmor_parser"
[   11.910591] type=1400 audit(1301594101.573:3): apparmor="STATUS" operation="profile_load" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=692 comm="apparmor_parser"
[   11.910893] type=1400 audit(1301594101.573:4): apparmor="STATUS" operation="profile_load" name="/usr/lib/connman/scripts/dhclient-script" pid=692 comm="apparmor_parser"
[   11.914795] uvcvideo: Found UVC 1.00 device Integrated Camera (04f2:b221)
[   11.915215] thinkpad_acpi: ThinkPad ACPI Extras v0.24sutton1
[   11.915217] thinkpad_acpi: http://ibm-acpi.sf.net/
[   11.915219] thinkpad_acpi: ThinkPad BIOS 83ET43WW (1.13 ), EC unknown
[   11.915221] thinkpad_acpi: Lenovo ThinkPad T420, model 4177Q2U
[   11.916501] input: Integrated Camera as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.6/1-1.6:1.0/input/input5
[   11.916557] usbcore: registered new interface driver uvcvideo
[   11.916559] USB Video Class driver (v0.1.0)
[   11.917418] cfg80211: World regulatory domain updated:
[   11.917420]     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   11.917423]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   11.917426]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   11.917428]     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   11.917431]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   11.917433]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   11.922736] thinkpad_acpi: detected a 16-level brightness capable ThinkPad
[   11.923236] thinkpad_acpi: radio switch found; radios are enabled
[   11.923251] thinkpad_acpi: This ThinkPad has standard ACPI backlight brightness control, supported by the ACPI video driver
[   11.923254] thinkpad_acpi: Disabling thinkpad-acpi brightness events by default...
[   11.927224] thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio is unblocked
[   11.930325] Registered led device: tpacpi::thinklight
[   11.930360] Registered led device: tpacpi::power
[   11.930377] Registered led device: tpacpi::standby
[   11.930395] Registered led device: tpacpi::thinkvantage
[   11.930403] thinkpad_acpi: Standard ACPI backlight interface available, not loading native one.
[   11.930470] thinkpad_acpi: Console audio control enabled, mode: monitor (read only)
[   11.932754] input: ThinkPad Extra Buttons as /devices/platform/thinkpad_acpi/input/input6
[   11.945735] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:sutton2
[   11.945737] iwlagn: Copyright(c) 2003-2010 Intel Corporation
[   11.945837] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   11.945876] iwlagn 0000:03:00.0: setting latency timer to 64
[   11.945950] iwlagn 0000:03:00.0: Detected 6000 Series 2x2 AGN Gen2a, REV=0xB0
[   11.956447] iwlagn 0000:03:00.0: device EEPROM VER=0x715, CALIB=0x6
[   11.956470] iwlagn 0000:03:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
[   11.956693]   alloc irq_desc for 46 on node -1
[   11.956695]   alloc kstat_irqs on node -1
[   11.956773] iwlagn 0000:03:00.0: irq 46 for MSI/MSI-X
[   11.969777]   alloc irq_desc for 22 on node -1
[   11.969780]   alloc kstat_irqs on node -1
[   11.969786] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[   11.969841]   alloc irq_desc for 47 on node -1
[   11.969843]   alloc kstat_irqs on node -1
[   11.969852] HDA Intel 0000:00:1b.0: irq 47 for MSI/MSI-X
[   11.969878] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   11.990969] iwlagn 0000:03:00.0: loaded firmware version 17.168.5.2 build 35905
[   11.995718] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
[   12.145163] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro
[   12.353092] type=1400 audit(1301594102.013:5): apparmor="STATUS" operation="profile_load" name="/usr/share/gdm/guest-session/Xsession" pid=1040 comm="apparmor_parser"
[   12.355655] type=1400 audit(1301594102.017:6): apparmor="STATUS" operation="profile_replace" name="/sbin/dhclient3" pid=1045 comm="apparmor_parser"
[   12.356166] type=1400 audit(1301594102.017:7): apparmor="STATUS" operation="profile_replace" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=1045 comm="apparmor_parser"
[   12.356443] type=1400 audit(1301594102.017:8): apparmor="STATUS" operation="profile_replace" name="/usr/lib/connman/scripts/dhclient-script" pid=1045 comm="apparmor_parser"
[   12.358029] type=1400 audit(1301594102.021:9): apparmor="STATUS" operation="profile_load" name="/usr/sbin/tcpdump" pid=1049 comm="apparmor_parser"
[   12.358086] type=1400 audit(1301594102.021:10): apparmor="STATUS" operation="profile_load" name="/usr/bin/evince" pid=1046 comm="apparmor_parser"
[   12.361697] type=1400 audit(1301594102.021:11): apparmor="STATUS" operation="profile_load" name="/usr/lib/cups/backend/cups-pdf" pid=1048 comm="apparmor_parser"
[   12.540658] Skipping EDID probe due to cached edid
[   12.595206] Bluetooth: L2CAP ver 2.14
[   12.595208] Bluetooth: L2CAP socket layer initialized
[   12.597644] ppdev: user-space parallel port driver
[   12.599654] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   12.599656] Bluetooth: BNEP filters: protocol multicast
[   12.603998] Bluetooth: SCO (Voice Link) ver 0.6
[   12.604000] Bluetooth: SCO socket layer initialized
[   12.668137] Bluetooth: RFCOMM TTY layer initialized
[   12.668141] Bluetooth: RFCOMM socket layer initialized
[   12.668143] Bluetooth: RFCOMM ver 1.11
[   12.701727] Synaptics Touchpad, model: 1, fw: 7.2, id: 0x1c0b1, caps: 0xd047b1/0xb40000/0xa0000
[   12.701731] serio: Synaptics pass-through port at isa0060/serio1/input0
[   12.704287] Skipping EDID probe due to cached edid
[   12.740112] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   12.753811] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input7
[   13.318738] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro,commit=0
[   14.095657] Skipping EDID probe due to cached edid
[   14.291351] Skipping EDID probe due to cached edid
[   14.456339] Skipping EDID probe due to cached edid
[   14.619552] Skipping EDID probe due to cached edid
[   14.750809] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro,commit=0
[   15.588978] psmouse serio2: ID: 10 00 64
[   19.296037] wlan0: authenticate with 00:23:69:ed:6f:b2 (try 1)
[   19.299360] wlan0: authenticated
[   19.304655] wlan0: associate with 00:23:69:ed:6f:b2 (try 1)
[   19.310362] wlan0: RX AssocResp from 00:23:69:ed:6f:b2 (capab=0x411 status=0 aid=9)
[   19.310369] wlan0: associated
[   19.320229] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   19.650496] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[   19.711637] Skipping EDID probe due to cached edid
[   19.920768] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/serio2/input/input8
[   29.960897] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x000000c0
[   30.157254] mmc0: clock 0Hz busmode 1 powermode 1 cs 0 Vdd 21 width 0 timing 0
[   30.173236] mmc0: clock 400000Hz busmode 1 powermode 2 cs 0 Vdd 21 width 0 timing 0
[   30.189221] mmc0: starting CMD52 arg 00000c00 flags 00000195
[   30.191243] mmc0: req done (CMD52): -123: 00000000 00000000 00000000 00000000
[   30.191250] mmc0: starting CMD52 arg 80000c08 flags 00000195
[   30.193256] mmc0: req done (CMD52): -123: 00000000 00000000 00000000 00000000
[   30.193263] mmc0: clock 400000Hz busmode 1 powermode 2 cs 1 Vdd 21 width 0 timing 0
[   30.194260] mmc0: starting CMD0 arg 00000000 flags 000000c0
[   30.196265] mmc0: req done (CMD0): -123: 00000000 00000000 00000000 00000000
[   30.197261] mmc0: clock 400000Hz busmode 1 powermode 2 cs 0 Vdd 21 width 0 timing 0
[   30.198257] mmc0: starting CMD8 arg 000001aa flags 000002f5
[   30.200260] mmc0: req done (CMD8): -123: 00000000 00000000 00000000 00000000
[   30.200264] mmc0: starting CMD5 arg 00000000 flags 000002e1
[   30.202269] mmc0: req failed (CMD5): -123, retrying...
[   30.204267] mmc0: req failed (CMD5): -123, retrying...
[   30.206267] mmc0: req failed (CMD5): -123, retrying...
[   30.208266] mmc0: req done (CMD5): -123: 00000000 00000000 00000000 00000000
[   30.208271] mmc0: starting CMD55 arg 00000000 flags 000000f5
[   30.210279] mmc0: req done (CMD55): -123: 00000000 00000000 00000000 00000000
[   30.210283] mmc0: starting CMD55 arg 00000000 flags 000000f5
[   30.212287] mmc0: req done (CMD55): -123: 00000000 00000000 00000000 00000000
[   30.212292] mmc0: starting CMD55 arg 00000000 flags 000000f5
[   30.214298] mmc0: req done (CMD55): -123: 00000000 00000000 00000000 00000000
[   30.214304] mmc0: starting CMD55 arg 00000000 flags 000000f5
[   30.216308] mmc0: req done (CMD55): -123: 00000000 00000000 00000000 00000000
[   30.216312] mmc0: starting CMD1 arg 00000000 flags 000000e1
[   30.218318] mmc0: req done (CMD1): -123: 00000000 00000000 00000000 00000000
[   30.218325] mmc0: clock 0Hz busmode 1 powermode 0 cs 0 Vdd 0 width 0 timing 0
[   30.230131] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000040
[   30.305045] wlan0: no IPv6 routers present
[   30.429012] mmc0: clock 0Hz busmode 1 powermode 1 cs 0 Vdd 21 width 0 timing 0
[   30.444947] mmc0: clock 400000Hz busmode 1 powermode 2 cs 0 Vdd 21 width 0 timing 0
[   30.460966] mmc0: starting CMD52 arg 00000c00 flags 00000195
[   30.461064] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[   30.463073] mmc0: req done (CMD52): -110: 00000000 00000000 00000000 00000000
[   30.463127] mmc0: starting CMD52 arg 80000c08 flags 00000195
[   30.463182] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[   30.465181] mmc0: req done (CMD52): -110: 00000000 00000000 00000000 00000000
[   30.465187] mmc0: clock 400000Hz busmode 1 powermode 2 cs 1 Vdd 21 width 0 timing 0
[   30.466183] mmc0: starting CMD0 arg 00000000 flags 000000c0
[   30.466230] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
[   30.466236] mmc0: req done (CMD0): 0: 00000000 00000000 00000000 00000000
[   30.467233] mmc0: clock 400000Hz busmode 1 powermode 2 cs 0 Vdd 21 width 0 timing 0
[   30.468228] mmc0: starting CMD8 arg 000001aa flags 000002f5
[   30.468268] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[   30.470274] mmc0: req done (CMD8): -110: 00000000 00000000 00000000 00000000
[   30.470307] mmc0: starting CMD5 arg 00000000 flags 000002e1
[   30.470342] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[   30.472338] mmc0: req failed (CMD5): -110, retrying...
[   30.472375] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[   30.474376] mmc0: req failed (CMD5): -110, retrying...
[   30.474408] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[   30.476403] mmc0: req failed (CMD5): -110, retrying...
[   30.476435] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[   30.478433] mmc0: req done (CMD5): -110: 00000000 00000000 00000000 00000000
[   30.478456] mmc0: starting CMD55 arg 00000000 flags 000000f5
[   30.478511] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[   30.480509] mmc0: req done (CMD55): -110: 00000000 00000000 00000000 00000000
[   30.480514] mmc0: starting CMD55 arg 00000000 flags 000000f5
[   30.480555] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[   30.482560] mmc0: req done (CMD55): -110: 00000000 00000000 00000000 00000000
[   30.482605] mmc0: starting CMD55 arg 00000000 flags 000000f5
[   30.482640] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[   30.484637] mmc0: req done (CMD55): -110: 00000000 00000000 00000000 00000000
[   30.484640] mmc0: starting CMD55 arg 00000000 flags 000000f5
[   30.484678] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[   30.486681] mmc0: req done (CMD55): -110: 00000000 00000000 00000000 00000000
[   30.486718] mmc0: starting CMD1 arg 00000000 flags 000000e1
[   30.486750] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
[   30.486756] mmc0: req done (CMD1): 0: 003f8000 00000000 00000000 00000000
[   30.486760] mmc0: clock 400000Hz busmode 1 powermode 2 cs 0 Vdd 20 width 0 timing 0
[   30.486764] mmc0: clock 400000Hz busmode 1 powermode 2 cs 1 Vdd 20 width 0 timing 0
[   30.487759] mmc0: starting CMD0 arg 00000000 flags 000000c0
[   30.487781] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
[   30.487785] mmc0: req done (CMD0): 0: 00000000 00000000 00000000 00000000
[   30.488779] mmc0: clock 400000Hz busmode 1 powermode 2 cs 0 Vdd 20 width 0 timing 0
[   30.489775] mmc0: starting CMD1 arg 40300000 flags 000000e1
[   30.489813] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
[   30.489825] mmc0: req done (CMD1): 0: 003f8000 00000000 00000000 00000000
[   30.504915] mmc0: starting CMD1 arg 40300000 flags 000000e1
[   30.504966] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
[   30.504981] mmc0: req done (CMD1): 0: 003f8000 00000000 00000000 00000000
[   30.520894] mmc0: starting CMD1 arg 40300000 flags 000000e1
[   30.520964] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
[   30.520982] mmc0: req done (CMD1): 0: 003f8000 00000000 00000000 00000000
[   30.536887] mmc0: starting CMD1 arg 40300000 flags 000000e1
[   30.536951] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
[   30.536968] mmc0: req done (CMD1): 0: 003f8000 00000000 00000000 00000000
[   30.552867] mmc0: starting CMD1 arg 40300000 flags 000000e1
[   30.552941] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
[   30.552957] mmc0: req done (CMD1): 0: 003f8000 00000000 00000000 00000000
[   30.568852] mmc0: starting CMD1 arg 40300000 flags 000000e1
[   30.568924] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
[   30.568940] mmc0: req done (CMD1): 0: 003f8000 00000000 00000000 00000000
[   30.584840] mmc0: starting CMD1 arg 40300000 flags 000000e1
[   30.584892] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
[   30.584908] mmc0: req done (CMD1): 0: 003f8000 00000000 00000000 00000000
[   30.600833] mmc0: starting CMD1 arg 40300000 flags 000000e1
[   30.600906] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
[   30.600923] mmc0: req done (CMD1): 0: 803f8000 00000000 00000000 00000000
[   30.600938] mmc0: starting CMD2 arg 00000000 flags 00000067
[   30.600992] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
[   30.601016] mmc0: req done (CMD2): 0: ffffffff ffffffff ffffffff ffffff00
[   30.601040] mmc0: starting CMD3 arg 00010000 flags 00000015
[   30.601079] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[   30.603082] mmc0: req failed (CMD3): -110, retrying...
[   30.603114] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[   30.605109] mmc0: req failed (CMD3): -110, retrying...
[   30.605146] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[   30.607143] mmc0: req failed (CMD3): -110, retrying...
[   30.607174] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[   30.609172] mmc0: req done (CMD3): -110: 00000000 00000000 00000000 00000000
[   30.609188] mmc0: clock 0Hz busmode 1 powermode 0 cs 0 Vdd 0 width 0 timing 0
[   30.609198] mmc0: error -110 whilst initialising MMC card
[   30.609201] mmc0: clock 0Hz busmode 1 powermode 0 cs 0 Vdd 0 width 0 timing 0

--------------000203050800070504050101--

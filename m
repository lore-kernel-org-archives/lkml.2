Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819Ab0F3TVM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 15:21:12 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:40340 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754953Ab0F3TVI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 15:21:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=KukvWathSpqb2q6A9K1V+iDAg73seq+hpMdOaI1WRh44iI973DZZhqxMnwObaG+D4e
         j6jH8RCCjaCHu0uae0TfkahbFlB9bQmflA/+UXhK7leZxHsnTdW1KvsfUB8wuu80Xofe
         R4JKDObioGo8TiYeJYUbKuR3DA3hvDgDjn2bg=
MIME-Version: 1.0
In-Reply-To: <20100630063844.GB27891@liondog.tnic>
References: <AANLkTingidlvRUaD4FwNDybaZ29Qrr_507Pto1vVqo-a@mail.gmail.com>
	<20100630063844.GB27891@liondog.tnic>
Date: Wed, 30 Jun 2010 13:21:04 -0600
Message-ID: <AANLkTilrpslDI4hFzbZRTJCd3JnkbGqN7fvsMEl9wJ9_@mail.gmail.com>
Subject: Re: 2.6.34 Northbridge Chipset Errors on HP Proliant 4 x Opteron in 
	x86_64 mode
From: Jeffrey Merkey <jeffmerkey@gmail.com>
To: Borislav Petkov <bp@alien8.de>, Jeffrey Merkey <jeffmerkey@gmail.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> It looks like you don't have extended PCI config space accesses enabled
> on that machine. Can you send me the whole dmesg?
>

Here is the complete dmesg log of the Northbridge chip error messages.
 The drives report IO problems before the chip error message happens.


Jun 28 23:28:06 cloudstream kernel: Linux version 2.6.34
(root@cloudstream) (gcc version 4.4.4 20100503 (Red Hat 4.4.4-2) (GCC)
) #3 SMP Mon Jun 28 11:48:02 MDT 2010
Jun 28 23:28:06 cloudstream kernel: Command line: ro
root=UUID=90544c75-c442-4a9a-a474-7aa49db1cb37 rd_NO_LUKS rd_NO_LVM
rd_NO_MD rd_NO_DM LANG=en_US.UTF-8 SYSFONT=lat0-sun16 KEYTABLE=us rhgb
quiet
Jun 28 23:28:06 cloudstream kernel: BIOS-provided physical RAM map:
Jun 28 23:28:06 cloudstream kernel: BIOS-e820: 0000000000000000 -
000000000009f400 (usable)
Jun 28 23:28:06 cloudstream kernel: BIOS-e820: 000000000009f400 -
00000000000a0000 (reserved)
Jun 28 23:28:06 cloudstream kernel: BIOS-e820: 00000000000f0000 -
0000000000100000 (reserved)
Jun 28 23:28:06 cloudstream kernel: BIOS-e820: 0000000000100000 -
00000000f57f8000 (usable)
Jun 28 23:28:06 cloudstream kernel: BIOS-e820: 00000000f57f8000 -
00000000f5800000 (ACPI data)
Jun 28 23:28:06 cloudstream kernel: BIOS-e820: 00000000fdc00000 -
00000000fdc01000 (reserved)
Jun 28 23:28:06 cloudstream kernel: BIOS-e820: 00000000fdc10000 -
00000000fdc11000 (reserved)
Jun 28 23:28:06 cloudstream kernel: BIOS-e820: 00000000fec00000 -
00000000fec01000 (reserved)
Jun 28 23:28:06 cloudstream kernel: BIOS-e820: 00000000fec10000 -
00000000fec11000 (reserved)
Jun 28 23:28:06 cloudstream kernel: BIOS-e820: 00000000fec20000 -
00000000fec21000 (reserved)
Jun 28 23:28:06 cloudstream kernel: BIOS-e820: 00000000fee00000 -
00000000fee10000 (reserved)
Jun 28 23:28:06 cloudstream kernel: BIOS-e820: 00000000ff800000 -
0000000100000000 (reserved)
Jun 28 23:28:06 cloudstream kernel: BIOS-e820: 0000000100000000 -
00000001fffff000 (usable)
Jun 28 23:28:06 cloudstream kernel: NX (Execute Disable) protection: active
Jun 28 23:28:06 cloudstream kernel: DMI 2.3 present.
Jun 28 23:28:06 cloudstream kernel: No AGP bridge found
Jun 28 23:28:06 cloudstream kernel: last_pfn = 0x1fffff max_arch_pfn =
0x400000000
Jun 28 23:28:06 cloudstream kernel: x86 PAT enabled: cpu 0, old
0x7040600070406, new 0x7010600070106
Jun 28 23:28:06 cloudstream kernel: last_pfn = 0xf57f8 max_arch_pfn =
0x400000000
Jun 28 23:28:06 cloudstream kernel: found SMP MP-table at
[ffff8800000f4fa0] f4fa0
Jun 28 23:28:06 cloudstream kernel: init_memory_mapping:
0000000000000000-00000000f57f8000
Jun 28 23:28:06 cloudstream kernel: init_memory_mapping:
0000000100000000-00000001fffff000
Jun 28 23:28:06 cloudstream kernel: RAMDISK: 37aa2000 - 37ff0000
Jun 28 23:28:06 cloudstream kernel: ACPI: RSDP 00000000000f4f20 00024
(v02 HP    )
Jun 28 23:28:06 cloudstream kernel: ACPI: XSDT 00000000f57f83e0 00044
(v01 HP     A05      00000002   Ò? 0000162E)
Jun 28 23:28:06 cloudstream kernel: ACPI: FACP 00000000f57f8460 000F4
(v03 HP     A05      00000002   Ò? 0000162E)
Jun 28 23:28:06 cloudstream kernel: ACPI Warning: Invalid length for
Pm1aControlBlock: 32, using default 16 (20100121/tbfadt-607)
Jun 28 23:28:06 cloudstream kernel: ACPI Warning: Invalid length for
Pm1bControlBlock: 32, using default 16 (20100121/tbfadt-607)
Jun 28 23:28:06 cloudstream kernel: ACPI: DSDT 00000000f57f8560 0422D
(v01 HP         DSDT 00000001 MSFT 02000001)
Jun 28 23:28:06 cloudstream kernel: ACPI: FACS 00000000f57f80c0 00040
Jun 28 23:28:06 cloudstream kernel: ACPI: APIC 00000000f57f8100 000B8
(v01 HP     00000083 00000002      00000000)
Jun 28 23:28:06 cloudstream kernel: ACPI: SPCR 00000000f57f81e0 00050
(v01 HP     SPCRRBSU 00000001   Ò? 0000162E)
Jun 28 23:28:06 cloudstream kernel: ACPI: SRAT 00000000f57f8260 00150
(v01 HP     A05      00000001      00000000)
Jun 28 23:28:06 cloudstream kernel: SRAT: PXM 1 -> APIC 0x00 -> Node 0
Jun 28 23:28:06 cloudstream kernel: SRAT: PXM 2 -> APIC 0x02 -> Node 1
Jun 28 23:28:06 cloudstream kernel: SRAT: PXM 1 -> APIC 0x01 -> Node 0
Jun 28 23:28:06 cloudstream kernel: SRAT: PXM 2 -> APIC 0x03 -> Node 1
Jun 28 23:28:06 cloudstream kernel: SRAT: Node 0 PXM 1 0-100000000
Jun 28 23:28:06 cloudstream kernel: SRAT: Node 1 PXM 2 100000000-200000000
Jun 28 23:28:06 cloudstream kernel: Initmem setup node 0
0000000000000000-0000000100000000
Jun 28 23:28:06 cloudstream kernel:  NODE_DATA [0000000001dd1100 -
0000000001de50ff]
Jun 28 23:28:06 cloudstream kernel: Initmem setup node 1
0000000100000000-00000001fffff000
Jun 28 23:28:06 cloudstream kernel:  NODE_DATA [0000000100000000 -
0000000100013fff]
Jun 28 23:28:06 cloudstream kernel: Zone PFN ranges:
Jun 28 23:28:06 cloudstream kernel:  DMA      0x00000001 -> 0x00001000
Jun 28 23:28:06 cloudstream kernel:  DMA32    0x00001000 -> 0x00100000
Jun 28 23:28:06 cloudstream kernel:  Normal   0x00100000 -> 0x001fffff
Jun 28 23:28:06 cloudstream kernel: Movable zone start PFN for each node
Jun 28 23:28:06 cloudstream kernel: early_node_map[3] active PFN ranges
Jun 28 23:28:06 cloudstream kernel:    0: 0x00000001 -> 0x0000009f
Jun 28 23:28:06 cloudstream kernel:    0: 0x00000100 -> 0x000f57f8
Jun 28 23:28:06 cloudstream kernel:    1: 0x00100000 -> 0x001fffff
Jun 28 23:28:06 cloudstream kernel: ACPI: PM-Timer IO Port: 0x908
Jun 28 23:28:06 cloudstream kernel: ACPI: LAPIC (acpi_id[0x00]
lapic_id[0x00] enabled)
Jun 28 23:28:06 cloudstream kernel: ACPI: LAPIC (acpi_id[0x02]
lapic_id[0x02] enabled)
Jun 28 23:28:06 cloudstream kernel: ACPI: LAPIC (acpi_id[0x04]
lapic_id[0x04] disabled)
Jun 28 23:28:06 cloudstream kernel: ACPI: LAPIC (acpi_id[0x06]
lapic_id[0x06] disabled)
Jun 28 23:28:06 cloudstream kernel: ACPI: LAPIC (acpi_id[0x01]
lapic_id[0x01] enabled)
Jun 28 23:28:06 cloudstream kernel: ACPI: LAPIC (acpi_id[0x03]
lapic_id[0x03] enabled)
Jun 28 23:28:06 cloudstream kernel: ACPI: LAPIC (acpi_id[0x05]
lapic_id[0x05] disabled)
Jun 28 23:28:06 cloudstream kernel: ACPI: LAPIC (acpi_id[0x07]
lapic_id[0x07] disabled)
Jun 28 23:28:06 cloudstream kernel: ACPI: LAPIC_NMI (acpi_id[0xff]
high edge lint[0x1])
Jun 28 23:28:06 cloudstream kernel: ACPI: IOAPIC (id[0x04]
address[0xfec00000] gsi_base[0])
Jun 28 23:28:06 cloudstream kernel: IOAPIC[0]: apic_id 4, version 17,
address 0xfec00000, GSI 0-23
Jun 28 23:28:06 cloudstream kernel: ACPI: IOAPIC (id[0x05]
address[0xfec10000] gsi_base[24])
Jun 28 23:28:06 cloudstream kernel: IOAPIC[1]: apic_id 5, version 17,
address 0xfec10000, GSI 24-27
Jun 28 23:28:06 cloudstream kernel: ACPI: IOAPIC (id[0x06]
address[0xfec20000] gsi_base[28])
Jun 28 23:28:06 cloudstream kernel: IOAPIC[2]: apic_id 6, version 17,
address 0xfec20000, GSI 28-31
Jun 28 23:28:06 cloudstream kernel: ACPI: IOAPIC (id[0x07]
address[0xfdc00000] gsi_base[32])
Jun 28 23:28:06 cloudstream kernel: IOAPIC[3]: apic_id 7, version 17,
address 0xfdc00000, GSI 32-35
Jun 28 23:28:06 cloudstream kernel: ACPI: IOAPIC (id[0x08]
address[0xfdc10000] gsi_base[36])
Jun 28 23:28:06 cloudstream kernel: IOAPIC[4]: apic_id 8, version 17,
address 0xfdc10000, GSI 36-39
Jun 28 23:28:06 cloudstream kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 0
global_irq 2 high edge)
Jun 28 23:28:06 cloudstream kernel: Using ACPI (MADT) for SMP
configuration information
Jun 28 23:28:06 cloudstream kernel: SMP: Allowing 8 CPUs, 4 hotplug CPUs
Jun 28 23:28:06 cloudstream kernel: PM: Registered nosave memory:
000000000009f000 - 00000000000a0000
Jun 28 23:28:06 cloudstream kernel: PM: Registered nosave memory:
00000000000a0000 - 00000000000f0000
Jun 28 23:28:06 cloudstream kernel: PM: Registered nosave memory:
00000000000f0000 - 0000000000100000
Jun 28 23:28:06 cloudstream kernel: PM: Registered nosave memory:
00000000f57f8000 - 00000000f5800000
Jun 28 23:28:06 cloudstream kernel: PM: Registered nosave memory:
00000000f5800000 - 00000000fdc00000
Jun 28 23:28:06 cloudstream kernel: PM: Registered nosave memory:
00000000fdc00000 - 00000000fdc01000
Jun 28 23:28:06 cloudstream kernel: PM: Registered nosave memory:
00000000fdc01000 - 00000000fdc10000
Jun 28 23:28:06 cloudstream kernel: PM: Registered nosave memory:
00000000fdc10000 - 00000000fdc11000
Jun 28 23:28:06 cloudstream kernel: PM: Registered nosave memory:
00000000fdc11000 - 00000000fec00000
Jun 28 23:28:06 cloudstream kernel: PM: Registered nosave memory:
00000000fec00000 - 00000000fec01000
Jun 28 23:28:06 cloudstream kernel: PM: Registered nosave memory:
00000000fec01000 - 00000000fec10000
Jun 28 23:28:06 cloudstream kernel: PM: Registered nosave memory:
00000000fec10000 - 00000000fec11000
Jun 28 23:28:06 cloudstream kernel: PM: Registered nosave memory:
00000000fec11000 - 00000000fec20000
Jun 28 23:28:06 cloudstream kernel: PM: Registered nosave memory:
00000000fec20000 - 00000000fec21000
Jun 28 23:28:06 cloudstream kernel: PM: Registered nosave memory:
00000000fec21000 - 00000000fee00000
Jun 28 23:28:06 cloudstream kernel: PM: Registered nosave memory:
00000000fee00000 - 00000000fee10000
Jun 28 23:28:06 cloudstream kernel: PM: Registered nosave memory:
00000000fee10000 - 00000000ff800000
Jun 28 23:28:06 cloudstream kernel: PM: Registered nosave memory:
00000000ff800000 - 0000000100000000
Jun 28 23:28:06 cloudstream kernel: Allocating PCI resources starting
at f5800000 (gap: f5800000:8400000)
Jun 28 23:28:06 cloudstream kernel: Booting paravirtualized kernel on
bare hardware
Jun 28 23:28:06 cloudstream kernel: setup_percpu: NR_CPUS:256
nr_cpumask_bits:256 nr_cpu_ids:8 nr_node_ids:2
Jun 28 23:28:06 cloudstream kernel: PERCPU: Embedded 29 pages/cpu
@ffff880002000000 s89512 r8192 d21080 u524288
Jun 28 23:28:06 cloudstream kernel: pcpu-alloc: s89512 r8192 d21080
u524288 alloc=1*2097152
Jun 28 23:28:06 cloudstream kernel: pcpu-alloc: [0] 0 2 4 6 [1] 1 3 5 7
Jun 28 23:28:06 cloudstream kernel: Built 2 zonelists in Node order,
mobility grouping on.  Total pages: 2025953
Jun 28 23:28:06 cloudstream kernel: Policy zone: Normal
Jun 28 23:28:06 cloudstream kernel: Kernel command line: ro
root=UUID=90544c75-c442-4a9a-a474-7aa49db1cb37 rd_NO_LUKS rd_NO_LVM
rd_NO_MD rd_NO_DM LANG=en_US.UTF-8 SYSFONT=lat0-sun16 KEYTABLE=us rhgb
quiet
Jun 28 23:28:06 cloudstream kernel: PID hash table entries: 4096
(order: 3, 32768 bytes)
Jun 28 23:28:06 cloudstream kernel: Checking aperture...
Jun 28 23:28:06 cloudstream kernel: No AGP bridge found
Jun 28 23:28:06 cloudstream kernel: Node 0: aperture @ 1c60000000 size 32 MB
Jun 28 23:28:06 cloudstream kernel: Aperture beyond 4GB. Ignoring.
Jun 28 23:28:06 cloudstream kernel: Your BIOS doesn't leave a aperture
memory hole
Jun 28 23:28:06 cloudstream kernel: Please enable the IOMMU option in
the BIOS setup
Jun 28 23:28:06 cloudstream kernel: This costs you 64 MB of RAM
Jun 28 23:28:06 cloudstream kernel: Mapping aperture over 65536 KB of
RAM @ 20000000
Jun 28 23:28:06 cloudstream kernel: PM: Registered nosave memory:
0000000020000000 - 0000000024000000
Jun 28 23:28:06 cloudstream kernel: Subtract (67 early reservations)
Jun 28 23:28:06 cloudstream kernel:  #1 [0001000000 - 0001dd0708]
TEXT DATA BSS
Jun 28 23:28:06 cloudstream kernel:  #2 [0037aa2000 - 0037ff0000]
   RAMDISK
Jun 28 23:28:06 cloudstream kernel:  #3 [0001dd1000 - 0001dd10d4]
       BRK
Jun 28 23:28:06 cloudstream kernel:  #4 [000009f400 - 00000f4fa0]
BIOS reserved
Jun 28 23:28:06 cloudstream kernel:  #5 [00000f4fa0 - 00000f4fb0]
MP-table mpf
Jun 28 23:28:06 cloudstream kernel:  #6 [00000f4fb0 - 00000f7d12]
BIOS reserved
Jun 28 23:28:06 cloudstream kernel:  #7 [00000f7efe - 0000100000]
BIOS reserved
Jun 28 23:28:06 cloudstream kernel:  #8 [00000f7d12 - 00000f7efe]
MP-table mpc
Jun 28 23:28:06 cloudstream kernel:  #9 [0000001000 - 0000003000]
TRAMPOLINE
Jun 28 23:28:06 cloudstream kernel:  #10 [0000003000 - 0000007000]
ACPI WAKEUP
Jun 28 23:28:06 cloudstream kernel:  #11 [0000008000 - 000000c000]
    PGTABLE
Jun 28 23:28:06 cloudstream kernel:  #12 [000000c000 - 0000011000]
    PGTABLE
Jun 28 23:28:06 cloudstream kernel:  #13 [0001dd1100 - 0001de5100]
  NODE_DATA
Jun 28 23:28:06 cloudstream kernel:  #14 [0100000000 - 0100014000]
  NODE_DATA
Jun 28 23:28:06 cloudstream kernel:  #15 [0001de5100 - 0001de6100]
    BOOTMEM
Jun 28 23:28:06 cloudstream kernel:  #16 [0000007000 - 00000072e8]
    BOOTMEM
Jun 28 23:28:06 cloudstream kernel:  #17 [0100014000 - 0100014300]
    BOOTMEM
Jun 28 23:28:06 cloudstream kernel:  #18 [00025e7000 - 00025e8000]
    BOOTMEM
Jun 28 23:28:06 cloudstream kernel:  #19 [00025e8000 - 00025e9000]
    BOOTMEM
Jun 28 23:28:06 cloudstream kernel:  #20 [0002600000 - 0005e00000]
   MEMMAP 0
Jun 28 23:28:06 cloudstream kernel:  #21 [0100200000 - 0103a00000]
   MEMMAP 1
Jun 28 23:28:06 cloudstream kernel:  #22 [0001de6100 - 0001dfe100]
    BOOTMEM
Jun 28 23:28:06 cloudstream kernel:  #23 [0001dfe100 - 0001e16100]
    BOOTMEM
Jun 28 23:28:06 cloudstream kernel:  #24 [0100014300 - 010002c300]
    BOOTMEM
Jun 28 23:28:06 cloudstream kernel:  #25 [0001e17000 - 0001e18000]
    BOOTMEM
Jun 28 23:28:06 cloudstream kernel:  #26 [0001dd0740 - 0001dd088f]
    BOOTMEM
Jun 28 23:28:06 cloudstream kernel:  #27 [0001dd08c0 - 0001dd0bd0]
    BOOTMEM
Jun 28 23:28:06 cloudstream kernel:  #28 [0001dd0c00 - 0001dd0c68]
    BOOTMEM
Jun 28 23:28:06 cloudstream kernel:  #29 [0001dd0c80 - 0001dd0ce8]
    BOOTMEM
Jun 28 23:28:06 cloudstream kernel:  #30 [0001dd0d00 - 0001dd0d68]
    BOOTMEM
Jun 28 23:28:06 cloudstream kernel:  #31 [0001dd0d80 - 0001dd0de8]
    BOOTMEM
Jun 28 23:28:06 cloudstream kernel:  #32 [0001dd0e00 - 0001dd0e68]
    BOOTMEM
Jun 28 23:28:06 cloudstream kernel:  #33 [0001dd0e80 - 0001dd0ee8]
    BOOTMEM
Jun 28 23:28:06 cloudstream kernel:  #34 [0001dd0f00 - 0001dd0f68]
    BOOTMEM
Jun 28 23:28:06 cloudstream kernel:  #35 [0001dd0f80 - 0001dd0fe8]
    BOOTMEM
Jun 28 23:28:06 cloudstream kernel:  #36 [0001e16100 - 0001e16168]
    BOOTMEM
Jun 28 23:28:06 cloudstream kernel:  #37 [0001e16180 - 0001e161e8]
    BOOTMEM
Jun 28 23:28:06 cloudstream kernel:  #38 [0001e16200 - 0001e16268]
    BOOTMEM
Jun 28 23:28:06 cloudstream kernel:  #39 [0001e16280 - 0001e162e8]
    BOOTMEM
Jun 28 23:28:06 cloudstream kernel:  #40 [0001e16300 - 0001e16368]
    BOOTMEM
Jun 28 23:28:06 cloudstream kernel:  #41 [0001e16380 - 0001e163a0]
    BOOTMEM
Jun 28 23:28:06 cloudstream kernel:  #42 [0001e163c0 - 0001e163e0]
    BOOTMEM
Jun 28 23:28:06 cloudstream kernel:  #43 [0001e16400 - 0001e16494]
    BOOTMEM
Jun 28 23:28:06 cloudstream kernel:  #44 [0001e164c0 - 0001e16554]
    BOOTMEM
Jun 28 23:28:06 cloudstream kernel:  #45 [0002000000 - 000201d000]
    BOOTMEM
Jun 28 23:28:06 cloudstream kernel:  #46 [0002080000 - 000209d000]
    BOOTMEM
Jun 28 23:28:06 cloudstream kernel:  #47 [0002100000 - 000211d000]
    BOOTMEM
Jun 28 23:28:06 cloudstream kernel:  #48 [0002180000 - 000219d000]
    BOOTMEM
Jun 28 23:28:06 cloudstream kernel:  #49 [0103a00000 - 0103a1d000]
    BOOTMEM
Jun 28 23:28:06 cloudstream kernel:  #50 [0103a80000 - 0103a9d000]
    BOOTMEM
Jun 28 23:28:06 cloudstream kernel:  #51 [0103b00000 - 0103b1d000]
    BOOTMEM
Jun 28 23:28:06 cloudstream kernel:  #52 [0103b80000 - 0103b9d000]
    BOOTMEM
Jun 28 23:28:06 cloudstream kernel:  #53 [0001e16580 - 0001e16590]
    BOOTMEM
Jun 28 23:28:06 cloudstream kernel:  #54 [0001e165c0 - 0001e165d0]
    BOOTMEM
Jun 28 23:28:06 cloudstream kernel:  #55 [0001e16600 - 0001e16620]
    BOOTMEM
Jun 28 23:28:06 cloudstream kernel:  #56 [0001e16640 - 0001e16680]
    BOOTMEM
Jun 28 23:28:06 cloudstream kernel:  #57 [0001e16680 - 0001e167b0]
    BOOTMEM
Jun 28 23:28:06 cloudstream kernel:  #58 [0001e167c0 - 0001e16810]
    BOOTMEM
Jun 28 23:28:06 cloudstream kernel:  #59 [0001e16840 - 0001e16890]
    BOOTMEM
Jun 28 23:28:06 cloudstream kernel:  #60 [0001e18000 - 0001e20000]
    BOOTMEM
Jun 28 23:28:06 cloudstream kernel:  #61 [0020000000 - 0024000000]
    BOOTMEM
Jun 28 23:28:06 cloudstream kernel:  #62 [0001e168c0 - 0001e168e0]
    BOOTMEM
Jun 28 23:28:06 cloudstream kernel:  #63 [0005e00000 - 0009e00000]
    BOOTMEM
Jun 28 23:28:06 cloudstream kernel:  #64 [0001e20000 - 0001e40000]
    BOOTMEM
Jun 28 23:28:06 cloudstream kernel:  #65 [0001e40000 - 0001e80000]
    BOOTMEM
Jun 28 23:28:06 cloudstream kernel:  #66 [0000012000 - 000001a000]
    BOOTMEM
Jun 28 23:28:06 cloudstream kernel: Memory: 7948896k/8388604k
available (4278k kernel code, 172456k absent, 267252k reserved, 7561k
data, 724k init)
Jun 28 23:28:06 cloudstream kernel: SLUB: Genslabs=14, HWalign=64,
Order=0-3, MinObjects=0, CPUs=8, Nodes=2
Jun 28 23:28:06 cloudstream kernel: Hierarchical RCU implementation.
Jun 28 23:28:06 cloudstream kernel: NR_IRQS:16640 nr_irqs:744
Jun 28 23:28:06 cloudstream kernel: Extended CMOS year: 2000
Jun 28 23:28:06 cloudstream kernel: Console: colour VGA+ 80x25
Jun 28 23:28:06 cloudstream kernel: console [tty0] enabled
Jun 28 23:28:06 cloudstream kernel: allocated 82575360 bytes of page_cgroup
Jun 28 23:28:06 cloudstream kernel: please try 'cgroup_disable=memory'
option if you don't want memory cgroups
Jun 28 23:28:06 cloudstream kernel: Fast TSC calibration using PIT
Jun 28 23:28:06 cloudstream kernel: Detected 2205.290 MHz processor.
Jun 28 23:28:06 cloudstream kernel: Calibrating delay loop (skipped),
value calculated using timer frequency.. 4410.58 BogoMIPS
(lpj=2205290)
Jun 28 23:28:06 cloudstream kernel: Security Framework initialized
Jun 28 23:28:06 cloudstream kernel: SELinux:  Initializing.
Jun 28 23:28:06 cloudstream kernel: Dentry cache hash table entries:
1048576 (order: 11, 8388608 bytes)
Jun 28 23:28:06 cloudstream kernel: Inode-cache hash table entries:
524288 (order: 10, 4194304 bytes)
Jun 28 23:28:06 cloudstream kernel: Mount-cache hash table entries: 256
Jun 28 23:28:06 cloudstream kernel: Initializing cgroup subsys debug
Jun 28 23:28:06 cloudstream kernel: Initializing cgroup subsys ns
Jun 28 23:28:06 cloudstream kernel: Initializing cgroup subsys cpuacct
Jun 28 23:28:06 cloudstream kernel: Initializing cgroup subsys memory
Jun 28 23:28:06 cloudstream kernel: Initializing cgroup subsys devices
Jun 28 23:28:06 cloudstream kernel: Initializing cgroup subsys freezer
Jun 28 23:28:06 cloudstream kernel: Initializing cgroup subsys net_cls
Jun 28 23:28:06 cloudstream kernel: Initializing cgroup subsys blkio
Jun 28 23:28:06 cloudstream kernel: CPU: Physical Processor ID: 0
Jun 28 23:28:06 cloudstream kernel: CPU: Processor Core ID: 0
Jun 28 23:28:06 cloudstream kernel: mce: CPU supports 5 MCE banks
Jun 28 23:28:06 cloudstream kernel: Performance Events: AMD PMU driver.
Jun 28 23:28:06 cloudstream kernel: ... version:                0
Jun 28 23:28:06 cloudstream kernel: ... bit width:              48
Jun 28 23:28:06 cloudstream kernel: ... generic registers:      4
Jun 28 23:28:06 cloudstream kernel: ... value mask:             0000ffffffffffff
Jun 28 23:28:06 cloudstream kernel: ... max period:             00007fffffffffff
Jun 28 23:28:06 cloudstream kernel: ... fixed-purpose events:   0
Jun 28 23:28:06 cloudstream kernel: ... event mask:             000000000000000f
Jun 28 23:28:06 cloudstream kernel: ACPI: Core revision 20100121
Jun 28 23:28:06 cloudstream kernel: Setting APIC routing to flat
Jun 28 23:28:06 cloudstream kernel: ..TIMER: vector=0x30 apic1=0
pin1=2 apic2=0 pin2=0
Jun 28 23:28:06 cloudstream kernel: CPU0: AMD Opteron(tm) Processor
275 stepping 02
Jun 28 23:28:06 cloudstream kernel: Booting Node   1, Processors  #1 Ok.
Jun 28 23:28:06 cloudstream kernel: Booting Node   0, Processors  #2 Ok.
Jun 28 23:28:06 cloudstream kernel: Booting Node   1, Processors  #3
Jun 28 23:28:06 cloudstream kernel: Brought up 4 CPUs
Jun 28 23:28:06 cloudstream kernel: Total of 4 processors activated
(17638.30 BogoMIPS).
Jun 28 23:28:06 cloudstream kernel: devtmpfs: initialized
Jun 28 23:28:06 cloudstream kernel: regulator: core version 0.5
Jun 28 23:28:06 cloudstream kernel: Time:  5:27:56  Date: 06/29/10
Jun 28 23:28:06 cloudstream kernel: NET: Registered protocol family 16
Jun 28 23:28:06 cloudstream kernel: TOM: 00000000f5800000 aka 3928M
Jun 28 23:28:06 cloudstream kernel: TOM2: 0000000200000000 aka 8192M
Jun 28 23:28:06 cloudstream kernel: ACPI: bus type pci registered
Jun 28 23:28:06 cloudstream kernel: PCI: Using configuration type 1
for base access
Jun 28 23:28:06 cloudstream kernel: bio: create slab <bio-0> at 0
Jun 28 23:28:06 cloudstream kernel: ACPI: SSDT 00000000f57fd000 0059D
(v01 HP        SSDT0 00000001 MSFT 02000001)
Jun 28 23:28:06 cloudstream kernel: ACPI: SSDT 00000000f57fd700 0059D
(v01 HP        SSDT1 00000001 MSFT 02000001)
Jun 28 23:28:06 cloudstream kernel: ACPI: SSDT 00000000f57fde00 0059D
(v01 HP        SSDT2 00000001 MSFT 02000001)
Jun 28 23:28:06 cloudstream kernel: ACPI: SSDT 00000000f57fe500 0059D
(v01 HP        SSDT3 00000001 MSFT 02000001)
Jun 28 23:28:06 cloudstream kernel: ACPI: Interpreter enabled
Jun 28 23:28:06 cloudstream kernel: ACPI: (supports S0 S4 S5)
Jun 28 23:28:06 cloudstream kernel: ACPI: Using IOAPIC for interrupt routing
Jun 28 23:28:06 cloudstream kernel: ACPI: No dock devices found.
Jun 28 23:28:06 cloudstream kernel: PCI: Ignoring host bridge windows
from ACPI; if necessary, use "pci=use_crs" and report a bug
Jun 28 23:28:06 cloudstream kernel: ACPI: PCI Root Bridge [CFG0] (0000:00)
Jun 28 23:28:06 cloudstream kernel: pci 0000:00:03.0: PCI bridge to [bus 01-01]
Jun 28 23:28:06 cloudstream kernel: pci 0000:00:07.0: PCI bridge to [bus 02-02]
Jun 28 23:28:06 cloudstream kernel: pci 0000:00:08.0: PCI bridge to [bus 03-03]
Jun 28 23:28:06 cloudstream kernel: ACPI: PCI Root Bridge [CFG1] (0000:04)
Jun 28 23:28:06 cloudstream kernel: pci 0000:04:09.0: PCI bridge to [bus 05-05]
Jun 28 23:28:06 cloudstream kernel: pci 0000:04:0a.0: PCI bridge to [bus 06-06]
Jun 28 23:28:06 cloudstream kernel: ACPI: PCI Interrupt Link [LNKA]
(IRQs 3 5 *7 10 11)
Jun 28 23:28:06 cloudstream kernel: ACPI: PCI Interrupt Link [LNKB]
(IRQs 3 5 7 *10 11)
Jun 28 23:28:06 cloudstream kernel: ACPI: PCI Interrupt Link [LNKC]
(IRQs 3 5 7 10 11) *0, disabled.
Jun 28 23:28:06 cloudstream kernel: ACPI: PCI Interrupt Link [LNKD]
(IRQs 3 *5 7 10 11)
Jun 28 23:28:06 cloudstream kernel: vgaarb: device added:
PCI:0000:01:03.0,decodes=io+mem,owns=io+mem,locks=none
Jun 28 23:28:06 cloudstream kernel: vgaarb: loaded
Jun 28 23:28:06 cloudstream kernel: SCSI subsystem initialized
Jun 28 23:28:06 cloudstream kernel: usbcore: registered new interface
driver usbfs
Jun 28 23:28:06 cloudstream kernel: usbcore: registered new interface driver hub
Jun 28 23:28:06 cloudstream kernel: usbcore: registered new device driver usb
Jun 28 23:28:06 cloudstream kernel: PCI: Using ACPI for IRQ routing
Jun 28 23:28:06 cloudstream kernel: NetLabel: Initializing
Jun 28 23:28:06 cloudstream kernel: NetLabel:  domain hash size = 128
Jun 28 23:28:06 cloudstream kernel: NetLabel:  protocols = UNLABELED CIPSOv4
Jun 28 23:28:06 cloudstream kernel: NetLabel:  unlabeled traffic
allowed by default
Jun 28 23:28:06 cloudstream kernel: pnp: PnP ACPI init
Jun 28 23:28:06 cloudstream kernel: ACPI: bus type pnp registered
Jun 28 23:28:06 cloudstream kernel: pnp: PnP ACPI: found 10 devices
Jun 28 23:28:06 cloudstream kernel: ACPI: ACPI bus type pnp unregistered
Jun 28 23:28:06 cloudstream kernel: system 00:01: [io  0x0230-0x0233]
has been reserved
Jun 28 23:28:06 cloudstream kernel: system 00:01: [io  0x0260-0x0267]
has been reserved
Jun 28 23:28:06 cloudstream kernel: system 00:01: [io  0x04d0-0x04d1]
has been reserved
Jun 28 23:28:06 cloudstream kernel: system 00:01: [io  0x0800-0x081f]
has been reserved
Jun 28 23:28:06 cloudstream kernel: system 00:01: [io  0x0840-0x085f]
has been reserved
Jun 28 23:28:06 cloudstream kernel: system 00:01: [io  0x0900-0x0903]
has been reserved
Jun 28 23:28:06 cloudstream kernel: system 00:01: [io  0x0904-0x0907]
has been reserved
Jun 28 23:28:06 cloudstream kernel: system 00:01: [io  0x0908-0x090b]
has been reserved
Jun 28 23:28:06 cloudstream kernel: system 00:01: [io  0x090c-0x092e]
has been reserved
Jun 28 23:28:06 cloudstream kernel: system 00:01: [io  0x092f] has been reserved
Jun 28 23:28:06 cloudstream kernel: system 00:01: [io  0x0930-0x09ff]
has been reserved
Jun 28 23:28:06 cloudstream kernel: system 00:01: [io  0x0c80-0x0c87]
has been reserved
Jun 28 23:28:06 cloudstream kernel: system 00:01: [io  0x0cf9] could
not be reserved
Jun 28 23:28:06 cloudstream kernel: system 00:01: [io  0x02f8-0x02ff]
has been reserved
Jun 28 23:28:06 cloudstream kernel: Switching to clocksource acpi_pm
Jun 28 23:28:06 cloudstream kernel: pci 0000:00:03.0: BAR 15: assigned
[mem 0xf5800000-0xf58fffff pref]
Jun 28 23:28:06 cloudstream kernel: pci 0000:00:07.0: BAR 15: assigned
[mem 0xf5900000-0xf59fffff pref]
Jun 28 23:28:06 cloudstream kernel: pci 0000:01:03.0: BAR 6: assigned
[mem 0xf5800000-0xf581ffff pref]
Jun 28 23:28:06 cloudstream kernel: pci 0000:01:02.2: BAR 6: assigned
[mem 0xf5820000-0xf582ffff pref]
Jun 28 23:28:06 cloudstream kernel: pci 0000:00:03.0: PCI bridge to [bus 01-01]
Jun 28 23:28:06 cloudstream kernel: pci 0000:00:03.0:   bridge window
[io  0x4000-0x4fff]
Jun 28 23:28:06 cloudstream kernel: pci 0000:00:03.0:   bridge window
[mem 0xf5f00000-0xf7dfffff]
Jun 28 23:28:06 cloudstream kernel: pci 0000:00:03.0:   bridge window
[mem 0xf5800000-0xf58fffff pref]
Jun 28 23:28:06 cloudstream kernel: pci 0000:02:04.0: BAR 6: assigned
[mem 0xf5900000-0xf593ffff pref]
Jun 28 23:28:06 cloudstream kernel: pci 0000:00:07.0: PCI bridge to [bus 02-02]
Jun 28 23:28:06 cloudstream kernel: pci 0000:00:07.0:   bridge window
[io  0x5000-0x5fff]
Jun 28 23:28:06 cloudstream kernel: pci 0000:00:07.0:   bridge window
[mem 0xf7e00000-0xf7efffff]
Jun 28 23:28:06 cloudstream kernel: pci 0000:00:07.0:   bridge window
[mem 0xf5900000-0xf59fffff pref]
Jun 28 23:28:06 cloudstream kernel: pci 0000:00:08.0: PCI bridge to [bus 03-03]
Jun 28 23:28:06 cloudstream kernel: pci 0000:00:08.0:   bridge window
[io  disabled]
Jun 28 23:28:06 cloudstream kernel: pci 0000:00:08.0:   bridge window
[mem 0xf7f00000-0xf7ffffff]
Jun 28 23:28:06 cloudstream kernel: pci 0000:00:08.0:   bridge window
[mem pref disabled]
Jun 28 23:28:06 cloudstream kernel: pci 0000:04:09.0: PCI bridge to [bus 05-05]
Jun 28 23:28:06 cloudstream kernel: pci 0000:04:09.0:   bridge window
[io  disabled]
Jun 28 23:28:06 cloudstream kernel: pci 0000:04:09.0:   bridge window
[mem disabled]
Jun 28 23:28:06 cloudstream kernel: pci 0000:04:09.0:   bridge window
[mem pref disabled]
Jun 28 23:28:06 cloudstream kernel: pci 0000:04:0a.0: PCI bridge to [bus 06-06]
Jun 28 23:28:06 cloudstream kernel: pci 0000:04:0a.0:   bridge window
[io  disabled]
Jun 28 23:28:06 cloudstream kernel: pci 0000:04:0a.0:   bridge window
[mem disabled]
Jun 28 23:28:06 cloudstream kernel: pci 0000:04:0a.0:   bridge window
[mem pref disabled]
Jun 28 23:28:06 cloudstream kernel: NET: Registered protocol family 2
Jun 28 23:28:06 cloudstream kernel: IP route cache hash table entries:
262144 (order: 9, 2097152 bytes)
Jun 28 23:28:06 cloudstream kernel: TCP established hash table
entries: 524288 (order: 11, 8388608 bytes)
Jun 28 23:28:06 cloudstream kernel: TCP bind hash table entries: 65536
(order: 8, 1048576 bytes)
Jun 28 23:28:06 cloudstream kernel: TCP: Hash tables configured
(established 524288 bind 65536)
Jun 28 23:28:06 cloudstream kernel: TCP reno registered
Jun 28 23:28:06 cloudstream kernel: UDP hash table entries: 4096
(order: 5, 131072 bytes)
Jun 28 23:28:06 cloudstream kernel: UDP-Lite hash table entries: 4096
(order: 5, 131072 bytes)
Jun 28 23:28:06 cloudstream kernel: NET: Registered protocol family 1
Jun 28 23:28:06 cloudstream kernel: pci 0000:00:04.3: boot interrupts
on device [1022:746b] already disabled
Jun 28 23:28:06 cloudstream kernel: pci 0000:00:07.0: MSI quirk
detected; subordinate MSI disabled
Jun 28 23:28:06 cloudstream kernel: pci 0000:00:07.0: AMD8131 rev 12
detected; disabling PCI-X MMRBC
Jun 28 23:28:06 cloudstream kernel: pci 0000:00:08.0: MSI quirk
detected; subordinate MSI disabled
Jun 28 23:28:06 cloudstream kernel: pci 0000:00:08.0: AMD8131 rev 12
detected; disabling PCI-X MMRBC
Jun 28 23:28:06 cloudstream kernel: pci 0000:04:09.0: MSI quirk
detected; subordinate MSI disabled
Jun 28 23:28:06 cloudstream kernel: pci 0000:04:09.0: AMD8131 rev 12
detected; disabling PCI-X MMRBC
Jun 28 23:28:06 cloudstream kernel: pci 0000:04:0a.0: MSI quirk
detected; subordinate MSI disabled
Jun 28 23:28:06 cloudstream kernel: pci 0000:04:0a.0: AMD8131 rev 12
detected; disabling PCI-X MMRBC
Jun 28 23:28:06 cloudstream kernel: Trying to unpack rootfs image as
initramfs...
Jun 28 23:28:06 cloudstream kernel: Freeing initrd memory: 5432k freed
Jun 28 23:28:06 cloudstream kernel: PCI-DMA: Disabling AGP.
Jun 28 23:28:06 cloudstream kernel: PCI-DMA: aperture base @ 20000000
size 65536 KB
Jun 28 23:28:06 cloudstream kernel: PCI-DMA: using GART IOMMU.
Jun 28 23:28:06 cloudstream kernel: PCI-DMA: Reserving 64MB of IOMMU
area in the AGP aperture
Jun 28 23:28:06 cloudstream kernel: platform rtc_cmos: registered
platform RTC device (no PNP device found)
Jun 28 23:28:06 cloudstream kernel: Intel PCLMULQDQ-NI instructions
are not detected.
Jun 28 23:28:06 cloudstream kernel: audit: initializing netlink socket
(disabled)
Jun 28 23:28:06 cloudstream kernel: type=2000 audit(1277789275.483:1):
initialized
Jun 28 23:28:06 cloudstream kernel: HugeTLB registered 2 MB page size,
pre-allocated 0 pages
Jun 28 23:28:06 cloudstream kernel: VFS: Disk quotas dquot_6.5.2
Jun 28 23:28:06 cloudstream kernel: Dquot-cache hash table entries:
512 (order 0, 4096 bytes)
Jun 28 23:28:06 cloudstream kernel: msgmni has been set to 15664
Jun 28 23:28:06 cloudstream kernel: alg: No test for stdrng (krng)
Jun 28 23:28:06 cloudstream kernel: Block layer SCSI generic (bsg)
driver version 0.4 loaded (major 253)
Jun 28 23:28:06 cloudstream kernel: io scheduler noop registered
Jun 28 23:28:06 cloudstream kernel: io scheduler deadline registered
Jun 28 23:28:06 cloudstream kernel: io scheduler cfq registered (default)
Jun 28 23:28:06 cloudstream kernel: pci_hotplug: PCI Hot Plug PCI Core
version: 0.5
Jun 28 23:28:06 cloudstream kernel: pciehp: PCI Express Hot Plug
Controller Driver version: 0.4
Jun 28 23:28:06 cloudstream kernel: acpiphp: ACPI Hot Plug PCI
Controller Driver version: 0.5
Jun 28 23:28:06 cloudstream kernel: pci-stub: invalid id string ""
Jun 28 23:28:06 cloudstream kernel: input: Power Button as
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
Jun 28 23:28:06 cloudstream kernel: ACPI: Power Button [PWRF]
Jun 28 23:28:06 cloudstream kernel: Non-volatile memory driver v1.3
Jun 28 23:28:06 cloudstream kernel: Linux agpgart interface v0.103
Jun 28 23:28:06 cloudstream kernel: Serial: 8250/16550 driver, 4
ports, IRQ sharing enabled
Jun 28 23:28:06 cloudstream kernel: serial8250: ttyS0 at I/O 0x3f8
(irq = 4) is a 16550A
Jun 28 23:28:06 cloudstream kernel: serial8250: ttyS1 at I/O 0x2f8
(irq = 3) is a 16550A
Jun 28 23:28:06 cloudstream kernel: 00:07: ttyS0 at I/O 0x3f8 (irq =
4) is a 16550A
Jun 28 23:28:06 cloudstream kernel: brd: module loaded
Jun 28 23:28:06 cloudstream kernel: loop: module loaded
Jun 28 23:28:06 cloudstream kernel: Fixed MDIO Bus: probed
Jun 28 23:28:06 cloudstream kernel: ehci_hcd: USB 2.0 'Enhanced' Host
Controller (EHCI) Driver
Jun 28 23:28:06 cloudstream kernel: ohci_hcd: USB 1.1 'Open' Host
Controller (OHCI) Driver
Jun 28 23:28:06 cloudstream kernel: ohci_hcd 0000:01:00.0: PCI INT D
-> GSI 19 (level, low) -> IRQ 19
Jun 28 23:28:06 cloudstream kernel: ohci_hcd 0000:01:00.0: OHCI Host Controller
Jun 28 23:28:06 cloudstream kernel: ohci_hcd 0000:01:00.0: new USB bus
registered, assigned bus number 1
Jun 28 23:28:06 cloudstream kernel: ohci_hcd 0000:01:00.0: irq 19, io
mem 0xf7df0000
Jun 28 23:28:06 cloudstream kernel: usb usb1: New USB device found,
idVendor=1d6b, idProduct=0001
Jun 28 23:28:06 cloudstream kernel: usb usb1: New USB device strings:
Mfr=3, Product=2, SerialNumber=1
Jun 28 23:28:06 cloudstream kernel: usb usb1: Product: OHCI Host Controller
Jun 28 23:28:06 cloudstream kernel: usb usb1: Manufacturer: Linux
2.6.34 ohci_hcd
Jun 28 23:28:06 cloudstream kernel: usb usb1: SerialNumber: 0000:01:00.0
Jun 28 23:28:06 cloudstream kernel: hub 1-0:1.0: USB hub found
Jun 28 23:28:06 cloudstream kernel: hub 1-0:1.0: 3 ports detected
Jun 28 23:28:06 cloudstream kernel: ohci_hcd 0000:01:00.1: PCI INT D
-> GSI 19 (level, low) -> IRQ 19
Jun 28 23:28:06 cloudstream kernel: ohci_hcd 0000:01:00.1: OHCI Host Controller
Jun 28 23:28:06 cloudstream kernel: ohci_hcd 0000:01:00.1: new USB bus
registered, assigned bus number 2
Jun 28 23:28:06 cloudstream kernel: ohci_hcd 0000:01:00.1: irq 19, io
mem 0xf7de0000
Jun 28 23:28:06 cloudstream kernel: usb usb2: New USB device found,
idVendor=1d6b, idProduct=0001
Jun 28 23:28:06 cloudstream kernel: usb usb2: New USB device strings:
Mfr=3, Product=2, SerialNumber=1
Jun 28 23:28:06 cloudstream kernel: usb usb2: Product: OHCI Host Controller
Jun 28 23:28:06 cloudstream kernel: usb usb2: Manufacturer: Linux
2.6.34 ohci_hcd
Jun 28 23:28:06 cloudstream kernel: usb usb2: SerialNumber: 0000:01:00.1
Jun 28 23:28:06 cloudstream kernel: hub 2-0:1.0: USB hub found
Jun 28 23:28:06 cloudstream kernel: hub 2-0:1.0: 3 ports detected
Jun 28 23:28:06 cloudstream kernel: uhci_hcd: USB Universal Host
Controller Interface driver
Jun 28 23:28:06 cloudstream kernel: PNP: PS/2 Controller
[PNP0303:KBD,PNP0f0e:PS2M] at 0x60,0x64 irq 1,12
Jun 28 23:28:06 cloudstream kernel: serio: i8042 KBD port at 0x60,0x64 irq 1
Jun 28 23:28:06 cloudstream kernel: serio: i8042 AUX port at 0x60,0x64 irq 12
Jun 28 23:28:06 cloudstream kernel: mice: PS/2 mouse device common for all mice
Jun 28 23:28:06 cloudstream kernel: rtc_cmos rtc_cmos: RTC can wake from S4
Jun 28 23:28:06 cloudstream kernel: rtc_cmos rtc_cmos: rtc core:
registered rtc_cmos as rtc0
Jun 28 23:28:06 cloudstream kernel: rtc0: alarms up to one year, y3k,
114 bytes nvram
Jun 28 23:28:06 cloudstream kernel: device-mapper: uevent: version 1.0.3
Jun 28 23:28:06 cloudstream kernel: device-mapper: ioctl: 4.17.0-ioctl
(2010-03-05) initialised: dm-devel@redhat.com
Jun 28 23:28:06 cloudstream kernel: cpuidle: using governor ladder
Jun 28 23:28:06 cloudstream kernel: cpuidle: using governor menu
Jun 28 23:28:06 cloudstream kernel: usbcore: registered new interface
driver hiddev
Jun 28 23:28:06 cloudstream kernel: usbcore: registered new interface
driver usbhid
Jun 28 23:28:06 cloudstream kernel: usbhid: USB HID core driver
Jun 28 23:28:06 cloudstream kernel: nf_conntrack version 0.5.0 (16384
buckets, 65536 max)
Jun 28 23:28:06 cloudstream kernel: CONFIG_NF_CT_ACCT is deprecated
and will be removed soon. Please use
Jun 28 23:28:06 cloudstream kernel: nf_conntrack.acct=1 kernel
parameter, acct=1 nf_conntrack module option or
Jun 28 23:28:06 cloudstream kernel: sysctl
net.netfilter.nf_conntrack_acct=1 to enable it.
Jun 28 23:28:06 cloudstream kernel: ip_tables: (C) 2000-2006 Netfilter Core Team
Jun 28 23:28:06 cloudstream kernel: TCP cubic registered
Jun 28 23:28:06 cloudstream kernel: Initializing XFRM netlink socket
Jun 28 23:28:06 cloudstream kernel: NET: Registered protocol family 17
Jun 28 23:28:06 cloudstream kernel: registered taskstats version 1
Jun 28 23:28:06 cloudstream kernel: No TPM chip found, activating TPM-bypass!
Jun 28 23:28:06 cloudstream kernel:  Magic number: 14:632:467
Jun 28 23:28:06 cloudstream kernel: rtc_cmos rtc_cmos: setting system
clock to 2010-06-29 05:27:57 UTC (1277789277)
Jun 28 23:28:06 cloudstream kernel: Initalizing network drop monitor service
Jun 28 23:28:06 cloudstream kernel: Freeing unused kernel memory: 724k freed
Jun 28 23:28:06 cloudstream kernel: Write protecting the kernel
read-only data: 10240k
Jun 28 23:28:06 cloudstream kernel: Freeing unused kernel memory: 1848k freed
Jun 28 23:28:06 cloudstream kernel: Freeing unused kernel memory: 1956k freed
Jun 28 23:28:06 cloudstream kernel: dracut: dracut-005-3.fc13
Jun 28 23:28:06 cloudstream kernel: dracut: rd_NO_LUKS: removing
cryptoluks activation
Jun 28 23:28:06 cloudstream kernel: udev: starting version 151
Jun 28 23:28:06 cloudstream kernel: input: AT Translated Set 2
keyboard as /devices/platform/i8042/serio0/input/input1
Jun 28 23:28:06 cloudstream kernel: dracut: Starting plymouth daemon
Jun 28 23:28:06 cloudstream kernel: Floppy drive(s): fd0 is 1.44M
Jun 28 23:28:06 cloudstream kernel: scsi0 : pata_amd
Jun 28 23:28:06 cloudstream kernel: scsi1 : pata_amd
Jun 28 23:28:06 cloudstream kernel: ata1: PATA max UDMA/133 cmd 0x1f0
ctl 0x3f6 bmdma 0x2000 irq 14
Jun 28 23:28:06 cloudstream kernel: ata2: PATA max UDMA/133 cmd 0x170
ctl 0x376 bmdma 0x2008 irq 15
Jun 28 23:28:06 cloudstream kernel: HP CISS Driver (v 3.6.20)
Jun 28 23:28:06 cloudstream kernel: cciss 0000:02:04.0: PCI INT A ->
GSI 24 (level, low) -> IRQ 24
Jun 28 23:28:06 cloudstream kernel: FDC 0 is a National Semiconductor PC87306
Jun 28 23:28:06 cloudstream kernel: IRQ 24/cciss0: IRQF_DISABLED is
not guaranteed on shared IRQs
Jun 28 23:28:06 cloudstream kernel: cciss0: <0x46> at PCI 0000:02:04.0
IRQ 24 using DAC
Jun 28 23:28:06 cloudstream kernel: cciss/c0d0: p1 p2 p3
Jun 28 23:28:06 cloudstream kernel: cciss/c0d1: p1 p2 p3
Jun 28 23:28:06 cloudstream kernel: cciss/c0d2: p1
Jun 28 23:28:06 cloudstream kernel: ata1.00: ATAPI: DV-28E-N, C.6B, max UDMA/33
Jun 28 23:28:06 cloudstream kernel: ata1.00: configured for UDMA/33
Jun 28 23:28:06 cloudstream kernel: scsi 0:0:0:0: CD-ROM
TEAC     DV-28E-N         C.6B PQ: 0 ANSI: 5
Jun 28 23:28:06 cloudstream kernel: sr0: scsi3-mmc drive: 24x/24x
cd/rw xa/form2 cdda tray
Jun 28 23:28:06 cloudstream kernel: Uniform CD-ROM driver Revision: 3.20
Jun 28 23:28:06 cloudstream kernel: sr 0:0:0:0: Attached scsi generic sg0 type 5
Jun 28 23:28:06 cloudstream kernel: kjournald starting.  Commit
interval 5 seconds
Jun 28 23:28:06 cloudstream kernel: EXT3-fs (cciss/c0d1p3): mounted
filesystem with ordered data mode
Jun 28 23:28:06 cloudstream kernel: input: ImPS/2 Generic Wheel Mouse
as /devices/platform/i8042/serio1/input/input2
Jun 28 23:28:06 cloudstream kernel: dracut: Mounted root filesystem
/dev/cciss/c0d1p3
Jun 28 23:28:06 cloudstream kernel: dracut: Loading SELinux policy
Jun 28 23:28:06 cloudstream kernel: type=1404 audit(1277789278.537:2):
enforcing=1 old_enforcing=0 auid=4294967295 ses=4294967295
Jun 28 23:28:06 cloudstream kernel: type=1403 audit(1277789279.100:3):
policy loaded auid=4294967295 ses=4294967295
Jun 28 23:28:06 cloudstream kernel: dracut: Switching root
Jun 28 23:28:06 cloudstream kernel: readahead: starting
Jun 28 23:28:06 cloudstream kernel: udev: starting version 151
Jun 28 23:28:06 cloudstream kernel: microcode: microcode: CPU0: AMD
CPU family 0xf not supported
Jun 28 23:28:06 cloudstream kernel: microcode: microcode: CPU1: AMD
CPU family 0xf not supported
Jun 28 23:28:06 cloudstream kernel: microcode: microcode: CPU2: AMD
CPU family 0xf not supported
Jun 28 23:28:06 cloudstream kernel: microcode: microcode: CPU3: AMD
CPU family 0xf not supported
Jun 28 23:28:06 cloudstream kernel: microcode: Microcode Update
Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
Jun 28 23:28:06 cloudstream kernel: shpchp 0000:00:03.0: HPC vendor_id
1022 device_id 7460 ss_vid 0 ss_did 0
Jun 28 23:28:06 cloudstream kernel: shpchp 0000:00:03.0: Cannot
reserve MMIO region
Jun 28 23:28:06 cloudstream kernel: shpchp 0000:00:07.0: HPC vendor_id
1022 device_id 7450 ss_vid 0 ss_did 0
Jun 28 23:28:06 cloudstream kernel: shpchp 0000:00:07.0: Cannot
reserve MMIO region
Jun 28 23:28:06 cloudstream kernel: shpchp 0000:00:08.0: HPC vendor_id
1022 device_id 7450 ss_vid 0 ss_did 0
Jun 28 23:28:06 cloudstream kernel: shpchp 0000:00:08.0: Cannot
reserve MMIO region
Jun 28 23:28:06 cloudstream kernel: shpchp 0000:04:09.0: HPC vendor_id
1022 device_id 7450 ss_vid 0 ss_did 0
Jun 28 23:28:06 cloudstream kernel: shpchp 0000:04:09.0: Cannot
reserve MMIO region
Jun 28 23:28:06 cloudstream kernel: shpchp 0000:04:0a.0: HPC vendor_id
1022 device_id 7450 ss_vid 0 ss_did 0
Jun 28 23:28:06 cloudstream kernel: shpchp 0000:04:0a.0: Cannot
reserve MMIO region
Jun 28 23:28:06 cloudstream kernel: shpchp: Standard Hot Plug PCI
Controller Driver version: 0.4
Jun 28 23:28:06 cloudstream kernel: hpwdt 0000:01:02.0: This server
does not have an iLO2 ASIC.
Jun 28 23:28:06 cloudstream kernel: tg3.c:v3.108 (February 17, 2010)
Jun 28 23:28:06 cloudstream kernel: tg3 0000:03:06.0: PCI INT A -> GSI
28 (level, low) -> IRQ 28
Jun 28 23:28:06 cloudstream kernel: AMD768 RNG detected
Jun 28 23:28:06 cloudstream kernel: tg3 0000:03:06.0: eth0: Tigon3
[partno(N/A) rev 2100] (PCIX:133MHz:64-bit) MAC address
00:17:a4:a9:71:74
Jun 28 23:28:06 cloudstream kernel: tg3 0000:03:06.0: eth0: attached
PHY is 5704 (10/100/1000Base-T Ethernet) (WireSpeed[1])
Jun 28 23:28:06 cloudstream kernel: tg3 0000:03:06.0: eth0: RXcsums[1]
LinkChgREG[0] MIirq[0] ASF[1] TSOcap[0]
Jun 28 23:28:06 cloudstream kernel: tg3 0000:03:06.0: eth0:
dma_rwctrl[769f4000] dma_mask[64-bit]
Jun 28 23:28:06 cloudstream kernel: tg3 0000:03:06.1: PCI INT B -> GSI
29 (level, low) -> IRQ 29
Jun 28 23:28:06 cloudstream kernel: tg3 0000:03:06.1: eth1: Tigon3
[partno(N/A) rev 2100] (PCIX:133MHz:64-bit) MAC address
00:17:a4:a9:71:73
Jun 28 23:28:06 cloudstream kernel: tg3 0000:03:06.1: eth1: attached
PHY is 5704 (10/100/1000Base-T Ethernet) (WireSpeed[1])
Jun 28 23:28:06 cloudstream kernel: tg3 0000:03:06.1: eth1: RXcsums[1]
LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
Jun 28 23:28:06 cloudstream kernel: tg3 0000:03:06.1: eth1:
dma_rwctrl[769f4000] dma_mask[64-bit]
Jun 28 23:28:06 cloudstream kernel: type=1400 audit(1277789282.079:4):
avc:  denied  { mmap_zero } for  pid=688 comm="vbetool"
scontext=system_u:system_r:vbetool_t:s0-s0:c0.c1023
tcontext=system_u:system_r:vbetool_t:s0-s0:c0.c1023 tclass=memprotect
Jun 28 23:28:06 cloudstream kernel: input: PC Speaker as
/devices/platform/pcspkr/input/input3
Jun 28 23:28:06 cloudstream kernel: EDAC MC: Ver: 2.1.0 Jun 28 2010
Jun 28 23:28:06 cloudstream kernel: EDAC amd64_edac:  Ver: 3.3.0 Jun 28 2010
Jun 28 23:28:06 cloudstream kernel: EDAC amd64: ECC is enabled by BIOS.
Jun 28 23:28:06 cloudstream kernel: EDAC amd64: ECC is enabled by BIOS.
Jun 28 23:28:06 cloudstream kernel: EDAC MC0: Giving out device to
'amd64_edac' 'RevF': DEV 0000:00:18.2
Jun 28 23:28:06 cloudstream kernel: EDAC MC1: Giving out device to
'amd64_edac' 'RevF': DEV 0000:00:19.2
Jun 28 23:28:06 cloudstream kernel: EDAC PCI0: Giving out device to
module 'amd64_edac' controller 'EDAC PCI controller': DEV
'0000:00:18.2' (POLLED)
Jun 28 23:28:06 cloudstream kernel: EXT3-fs (cciss/c0d1p3): using
internal journal
Jun 28 23:28:06 cloudstream kernel: kjournald starting.  Commit
interval 5 seconds
Jun 28 23:28:06 cloudstream kernel: EXT3-fs (cciss/c0d1p1): using
internal journal
Jun 28 23:28:06 cloudstream kernel: EXT3-fs (cciss/c0d1p1): mounted
filesystem with ordered data mode
Jun 28 23:28:06 cloudstream kernel: Adding 5119996k swap on
/dev/cciss/c0d1p2.  Priority:-1 extents:1 across:5119996k
Jun 28 23:28:06 cloudstream kernel: NET: Registered protocol family 10
Jun 28 23:28:06 cloudstream kernel: lo: Disabled Privacy Extensions
Jun 28 23:28:06 cloudstream kernel: ip6_tables: (C) 2000-2006
Netfilter Core Team
Jun 28 23:28:06 cloudstream kernel: powernow-k8: Found 2 AMD
Opteron(tm) Processor 275 processors (4 cpu cores) (version 2.20.00)
Jun 28 23:28:06 cloudstream kernel: powernow-k8:    0 : fid 0xe (2200
MHz), vid 0x8
Jun 28 23:28:06 cloudstream kernel: powernow-k8:    1 : fid 0xc (2000
MHz), vid 0xa
Jun 28 23:28:06 cloudstream kernel: powernow-k8:    2 : fid 0xa (1800
MHz), vid 0xc
Jun 28 23:28:06 cloudstream kernel: powernow-k8:    0 : fid 0xe (2200
MHz), vid 0x8
Jun 28 23:28:06 cloudstream kernel: powernow-k8:    1 : fid 0xc (2000
MHz), vid 0xa
Jun 28 23:28:06 cloudstream kernel: powernow-k8:    2 : fid 0xa (1800
MHz), vid 0xc
Jun 28 23:28:06 cloudstream cpuspeed: Enabling ondemand cpu frequency
scaling governor
Jun 28 23:28:06 cloudstream NetworkManager[1046]: <info>
NetworkManager (version 0.8.0.997) is starting...
Jun 28 23:28:06 cloudstream NetworkManager[1046]: <info> trying to
start the modem manager...
Jun 28 23:28:06 cloudstream NetworkManager[1046]:    ifcfg-rh:
Acquired D-Bus service com.redhat.ifcfgrh1
Jun 28 23:28:06 cloudstream NetworkManager[1046]: <info> Loaded plugin
ifcfg-rh: (c) 2007 - 2008 Red Hat, Inc.  To report bugs please use the
NetworkManager mailing list.
Jun 28 23:28:06 cloudstream NetworkManager[1046]:    ifcfg-rh: parsing
/etc/sysconfig/network-scripts/ifcfg-eth1 ...
Jun 28 23:28:06 cloudstream modem-manager: Loaded plugin Novatel
Jun 28 23:28:06 cloudstream modem-manager: Loaded plugin Option High-Speed
Jun 28 23:28:06 cloudstream modem-manager: Loaded plugin Generic
Jun 28 23:28:06 cloudstream modem-manager: Loaded plugin Huawei
Jun 28 23:28:06 cloudstream modem-manager: Loaded plugin MotoC
Jun 28 23:28:06 cloudstream modem-manager: Loaded plugin Nokia
Jun 28 23:28:06 cloudstream modem-manager: Loaded plugin Sierra
Jun 28 23:28:06 cloudstream modem-manager: Loaded plugin AnyData
Jun 28 23:28:06 cloudstream modem-manager: Loaded plugin ZTE
Jun 28 23:28:06 cloudstream modem-manager: Loaded plugin Longcheer
Jun 28 23:28:06 cloudstream modem-manager: Loaded plugin Ericsson MBM
Jun 28 23:28:06 cloudstream modem-manager: Loaded plugin Gobi
Jun 28 23:28:06 cloudstream modem-manager: Loaded plugin Option
Jun 28 23:28:06 cloudstream NetworkManager[1046]:    ifcfg-rh:
read connection 'System eth1'
Jun 28 23:28:06 cloudstream NetworkManager[1046]:    ifcfg-rh: parsing
/etc/sysconfig/network-scripts/ifcfg-eth0 ...
Jun 28 23:28:06 cloudstream NetworkManager[1046]:    ifcfg-rh:
read connection 'System eth0'
Jun 28 23:28:06 cloudstream avahi-daemon[1057]: Found user 'avahi'
(UID 496) and group 'avahi' (GID 489).
Jun 28 23:28:06 cloudstream NetworkManager[1046]:    ifcfg-rh: parsing
/etc/sysconfig/network-scripts/ifcfg-lo ...
Jun 28 23:28:06 cloudstream avahi-daemon[1057]: Successfully dropped
root privileges.
Jun 28 23:28:06 cloudstream avahi-daemon[1057]: avahi-daemon 0.6.25 starting up.
Jun 28 23:28:06 cloudstream avahi-daemon[1057]: WARNING: No NSS
support for mDNS detected, consider installing nss-mdns!
Jun 28 23:28:06 cloudstream NetworkManager[1046]: <info> WiFi enabled
by radio killswitch; enabled by state file
Jun 28 23:28:06 cloudstream NetworkManager[1046]: <info> WWAN enabled
by radio killswitch; enabled by state file
Jun 28 23:28:06 cloudstream NetworkManager[1046]: <info> WiMAX enabled
by radio killswitch; enabled by state file
Jun 28 23:28:06 cloudstream NetworkManager[1046]: <info> Networking is
enabled by state file
Jun 28 23:28:06 cloudstream NetworkManager[1046]: <info> (eth0): carrier is OFF
Jun 28 23:28:06 cloudstream NetworkManager[1046]: <info> (eth0): new
Ethernet device (driver: 'tg3' ifindex: 2)
Jun 28 23:28:06 cloudstream NetworkManager[1046]: <info> (eth0):
exported as /org/freedesktop/NetworkManager/Devices/0
Jun 28 23:28:06 cloudstream avahi-daemon[1057]: Successfully called chroot().
Jun 28 23:28:06 cloudstream avahi-daemon[1057]: Successfully dropped
remaining capabilities.
Jun 28 23:28:06 cloudstream avahi-daemon[1057]: Loading service file
/services/ssh.service.
Jun 28 23:28:06 cloudstream avahi-daemon[1057]: Loading service file
/services/udisks.service.
Jun 28 23:28:06 cloudstream NetworkManager[1046]: <info> (eth0): now managed
Jun 28 23:28:06 cloudstream NetworkManager[1046]: <info> (eth0):
device state change: 1 -> 2 (reason 2)
Jun 28 23:28:06 cloudstream NetworkManager[1046]: <info> (eth0):
bringing up device.
Jun 28 23:28:07 cloudstream kernel: ADDRCONF(NETDEV_UP): eth0: link is not ready
Jun 28 23:28:07 cloudstream NetworkManager[1046]: <info> (eth0):
preparing device.
Jun 28 23:28:07 cloudstream avahi-daemon[1057]: Network interface
enumeration completed.
Jun 28 23:28:07 cloudstream NetworkManager[1046]: <info> (eth0):
deactivating device (reason: 2).
Jun 28 23:28:07 cloudstream avahi-daemon[1057]: Registering HINFO
record with values 'X86_64'/'LINUX'.
Jun 28 23:28:07 cloudstream avahi-daemon[1057]: Server startup
complete. Host name is cloudstream.local. Local service cookie is
2478164084.
Jun 28 23:28:07 cloudstream avahi-daemon[1057]: Service "cloudstream"
(/services/udisks.service) successfully established.
Jun 28 23:28:07 cloudstream avahi-daemon[1057]: Service "cloudstream"
(/services/ssh.service) successfully established.
Jun 28 23:28:07 cloudstream kernel: Clocksource tsc unstable (delta =
-96585935 ns)
Jun 28 23:28:07 cloudstream NetworkManager[1046]: <info> (eth1): carrier is OFF
Jun 28 23:28:07 cloudstream NetworkManager[1046]: <info> (eth1): new
Ethernet device (driver: 'tg3' ifindex: 3)
Jun 28 23:28:07 cloudstream NetworkManager[1046]: <info> (eth1):
exported as /org/freedesktop/NetworkManager/Devices/1
Jun 28 23:28:07 cloudstream NetworkManager[1046]: <info> (eth1): now managed
Jun 28 23:28:07 cloudstream NetworkManager[1046]: <info> (eth1):
device state change: 1 -> 2 (reason 2)
Jun 28 23:28:07 cloudstream NetworkManager[1046]: <info> (eth1):
bringing up device.
Jun 28 23:28:07 cloudstream kernel: tg3 0000:03:06.1: firmware:
requesting tigon/tg3_tso.bin
Jun 28 23:28:07 cloudstream NetworkManager[1046]: <info> (eth1):
preparing device.
Jun 28 23:28:07 cloudstream NetworkManager[1046]: <info> (eth1):
deactivating device (reason: 2).
Jun 28 23:28:07 cloudstream kernel: ADDRCONF(NETDEV_UP): eth1: link is not ready
Jun 28 23:28:07 cloudstream NetworkManager[1046]: <info> modem-manager
is now available
Jun 28 23:28:07 cloudstream NetworkManager[1046]: <warn> bluez error
getting default adapter: The name org.bluez was not provided by any
.service files
Jun 28 23:28:07 cloudstream NetworkManager[1046]: <info> Trying to
start the supplicant...
Jun 28 23:28:07 cloudstream rpc.statd[1078]: Version 1.2.2 starting
Jun 28 23:28:07 cloudstream sm-notify[1079]: Version 1.2.2 starting
Jun 28 23:28:07 cloudstream kernel: RPC: Registered udp transport module.
Jun 28 23:28:07 cloudstream kernel: RPC: Registered tcp transport module.
Jun 28 23:28:07 cloudstream kernel: RPC: Registered tcp NFSv4.1
backchannel transport module.
Jun 28 23:28:08 cloudstream acpid: starting up
Jun 28 23:28:08 cloudstream acpid: 1 rule loaded
Jun 28 23:28:08 cloudstream acpid: waiting for events: event logging is off
Jun 28 23:28:09 cloudstream abrtd: Registered Analyzer plugin 'CCpp'
Jun 28 23:28:09 cloudstream abrtd: Registered Analyzer plugin 'Kerneloops'
Jun 28 23:28:09 cloudstream abrtd: Registered Reporter plugin
'KerneloopsReporter'
Jun 28 23:28:09 cloudstream abrtd: Registered Reporter plugin 'Bugzilla'
Jun 28 23:28:09 cloudstream abrtd: Registered Reporter plugin 'Logger'
Jun 28 23:28:09 cloudstream abrtd: Registered Analyzer plugin 'Python'
Jun 28 23:28:09 cloudstream abrtd: Registered Action plugin 'KerneloopsScanner'
Jun 28 23:28:09 cloudstream abrtd: Init complete, entering main loop
Jun 28 23:28:09 cloudstream /usr/sbin/gpm[1288]: *** info
[daemon/startup.c(136)]:
Jun 28 23:28:09 cloudstream /usr/sbin/gpm[1288]: Started gpm
successfully. Entered daemon mode.
Jun 29 00:44:29 cloudstream kernel: SysRq : MDB
Jun 29 00:44:47 cloudstream kernel: CloudStream(tm) v2.6.34
Jun 29 00:44:47 cloudstream kernel: UUID 0E3FC3DE-07C7-4295-B186-88E36462B92A
Jun 29 00:44:47 cloudstream kernel: Copyright (c) 1997-2010 Jeff V.
Merkey.  All Rights Reserved.
Jun 29 00:44:47 cloudstream kernel: Copyright (c) 2010 BlueLotus, Inc.
 All Rights Reserved.
Jun 29 00:44:47 cloudstream kernel: Total System Memory: 8217403392,
Total Free Memory: 7812104192
Jun 29 00:44:47 cloudstream kernel: DetectedMode: 5 Depth: 28
PagesDepth: 1023 CacheMode: 0
Jun 29 00:44:49 cloudstream kernel: CacheMemory: 1879048192,
CacheBinSize: 67108864, TotalBins: 28
Jun 29 00:44:49 cloudstream kernel: Store: StoreDepth:28 StorePageDepth:1024
Jun 29 00:44:49 cloudstream kernel: [VOL1            ] [64K striping]
active segments: 8934
Jun 29 00:44:49 cloudstream kernel:  cciss/c0d2p1 104:33 segments
8934/8934 start 0/0 (599990448640 bytes) 4 rsvd
Jun 29 00:44:49 cloudstream kernel:   stripe size: 8934 segment size: 67108864
Jun 29 00:44:49 cloudstream kernel:   logical segments: 8934 logical
sectors 1171045467
Jun 29 00:44:49 cloudstream kernel:   stripe segments: 8934 stripe
sectors 1170997248
Jun 29 00:44:49 cloudstream kernel:   netmap table size: 67108864
netmap table entries 2097152
Jun 29 00:44:49 cloudstream kernel:   device table size: 67108864
device table entries 131072
Jun 29 00:44:49 cloudstream kernel:   touchfile table size: 67108864
touchfile table entries 71697
Jun 29 00:44:49 cloudstream kernel: CloudStream:  mounting volume VOL1
Jun 29 00:44:49 cloudstream kernel: CloudStream:  reading netdev table (5)
Jun 29 00:44:49 cloudstream kernel: CloudStream:  reading netdev map (327680)
Jun 29 00:44:49 cloudstream kernel: CloudStream:  reading touchfile table (0)
Jun 29 00:44:49 cloudstream kernel: MemTotal:  8024808 kB, MemFree:
5791968 kB, Buffers:     4688 kB
Jun 29 00:44:49 cloudstream NetworkManager[1046]: <warn>
/sys/devices/virtual/net/cs9: couldn't determine device driver;
ignoring...
Jun 29 00:44:49 cloudstream NetworkManager[1046]: <warn>
/sys/devices/virtual/net/cs3: couldn't determine device driver;
ignoring...
Jun 29 00:44:49 cloudstream NetworkManager[1046]: <warn>
/sys/devices/virtual/net/cs2: couldn't determine device driver;
ignoring...
Jun 29 00:44:49 cloudstream NetworkManager[1046]: <warn>
/sys/devices/virtual/net/cs1: couldn't determine device driver;
ignoring...
Jun 29 00:44:49 cloudstream NetworkManager[1046]: <warn>
/sys/devices/virtual/net/cs8: couldn't determine device driver;
ignoring...
Jun 29 00:44:49 cloudstream NetworkManager[1046]: <warn>
/sys/devices/virtual/net/cs0: couldn't determine device driver;
ignoring...
Jun 29 00:44:49 cloudstream NetworkManager[1046]: <warn>
/sys/devices/virtual/net/cs4: couldn't determine device driver;
ignoring...
Jun 29 00:44:49 cloudstream NetworkManager[1046]: <warn>
/sys/devices/virtual/net/cs14: couldn't determine device driver;
ignoring...
Jun 29 00:44:49 cloudstream NetworkManager[1046]: <warn>
/sys/devices/virtual/net/cs5: couldn't determine device driver;
ignoring...
Jun 29 00:44:49 cloudstream NetworkManager[1046]: <warn>
/sys/devices/virtual/net/cs11: couldn't determine device driver;
ignoring...
Jun 29 00:44:49 cloudstream NetworkManager[1046]: <warn>
/sys/devices/virtual/net/cs13: couldn't determine device driver;
ignoring...
Jun 29 00:44:49 cloudstream NetworkManager[1046]: <warn>
/sys/devices/virtual/net/cs12: couldn't determine device driver;
ignoring...
Jun 29 00:44:49 cloudstream NetworkManager[1046]: <warn>
/sys/devices/virtual/net/cs6: couldn't determine device driver;
ignoring...
Jun 29 00:44:49 cloudstream NetworkManager[1046]: <warn>
/sys/devices/virtual/net/cs15: couldn't determine device driver;
ignoring...
Jun 29 00:44:49 cloudstream NetworkManager[1046]: <warn>
/sys/devices/virtual/net/cs10: couldn't determine device driver;
ignoring...
Jun 29 00:44:49 cloudstream NetworkManager[1046]: <warn>
/sys/devices/virtual/net/cs7: couldn't determine device driver;
ignoring...
Jun 29 00:44:56 cloudstream kernel: device cs0 entered promiscuous mode
Jun 29 00:44:58 cloudstream kernel: device cs1 entered promiscuous mode
Jun 29 00:45:00 cloudstream kernel: CloudStream:  device lo bound to cs0
Jun 29 00:45:00 cloudstream kernel: device lo entered promiscuous mode
Jun 29 00:46:49 cloudstream kernel: CloudStream: bad state in storage event
Jun 29 00:52:26 cloudstream kernel: CloudStream: bad state in storage event
Jun 29 01:23:11 cloudstream kernel: CloudStream: bad state in storage event
Jun 29 01:30:47 cloudstream kernel: CloudStream: bad state in storage event
Jun 29 01:34:59 cloudstream kernel: CloudStream: bad state in storage event
Jun 29 01:36:14 cloudstream kernel: CloudStream: bad state in storage event
Jun 29 01:42:09 cloudstream kernel: CloudStream: bad state in storage event
Jun 29 02:00:04 cloudstream kernel: CloudStream: bad state in storage event
Jun 29 02:02:08 cloudstream kernel: Northbridge Error, node 0, core: 0
Jun 29 02:02:08 cloudstream kernel: ECC/ChipKill ECC error.
Jun 29 02:02:08 cloudstream kernel: EDAC amd64 MC0: CE ERROR_ADDRESS= 0xc7358280
Jun 29 02:02:08 cloudstream kernel: EDAC amd64:
get_channel_from_ecc_syndrome: error reading F3x180.
Jun 29 02:02:08 cloudstream kernel: EDAC MC0: CE page 0xc7358, offset
0x280, grain 0, syndrome 0xa4c1, row 3, channel 0, label "":
amd64_edac
Jun 29 02:03:21 cloudstream kernel: Northbridge Error, node 0
Jun 29 02:03:21 cloudstream kernel: ECC/ChipKill ECC error.
Jun 29 02:03:21 cloudstream kernel: EDAC amd64 MC0: CE ERROR_ADDRESS= 0xc7358280
Jun 29 02:03:21 cloudstream kernel: EDAC amd64:
get_channel_from_ecc_syndrome: error reading F3x180.
Jun 29 02:03:21 cloudstream kernel: EDAC MC0: CE page 0xc7358, offset
0x280, grain 0, syndrome 0xa4c1, row 3, channel 0, label "":
amd64_edac
Jun 29 02:28:29 cloudstream kernel: CloudStream: bad state in storage event
Jun 29 02:31:49 cloudstream kernel: CloudStream: bad state in storage event
Jun 29 02:57:47 cloudstream kernel: CloudStream: bad state in storage event
Jun 29 02:58:46 cloudstream kernel: CloudStream: bad state in storage event
Jun 29 03:06:44 cloudstream kernel: CloudStream: bad state in storage event
Jun 29 03:11:17 cloudstream pcscd: winscard.c:309:SCardConnect()
Reader E-Gate 0 0 Not Found
Jun 29 03:11:17 cloudstream pcscd: winscard.c:309:SCardConnect()
Reader E-Gate 0 0 Not Found
Jun 29 03:11:17 cloudstream pcscd: winscard.c:309:SCardConnect()
Reader E-Gate 0 0 Not Found
Jun 29 03:11:17 cloudstream pcscd: winscard.c:309:SCardConnect()
Reader E-Gate 0 0 Not Found

jeff

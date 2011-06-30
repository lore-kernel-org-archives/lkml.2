Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118Ab1F3RFK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 13:05:10 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:3432
	"EHLO CH1EHSOBE016.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751189Ab1F3RFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 13:05:05 -0400
X-SpamScore: -2
X-BigFish: VPS-2(zz98dKzz1202hzzz32i668h839h34h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LNM4S6-02-97Q-02
X-M-MSG: 
Date: Thu, 30 Jun 2011 19:04:51 +0200
From: Hans Rosenfeld <hans.rosenfeld@amd.com>
To: Tejun Heo <tj@kernel.org>
CC: "Seidel, Conny" <Conny.Seidel@amd.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: 32bit NUMA and fakeNUMA broken for AMD CPUs
Message-ID: <20110630170450.GV478@escobedo.osrc.amd.com>
References: <20110628174613.GP478@escobedo.osrc.amd.com>
 <20110629094451.GJ3386@htj.dyndns.org>
 <20110629123409.GL3386@htj.dyndns.org>
 <20110629125507.GQ478@escobedo.osrc.amd.com>
 <20110629130349.GM3386@htj.dyndns.org>
 <20110629161517.GN3386@htj.dyndns.org>
 <20110630131337.GT478@escobedo.osrc.amd.com>
 <20110630155557.GS3386@htj.dyndns.org>
 <20110630163227.GU478@escobedo.osrc.amd.com>
 <20110630164216.GU3386@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="UfEAyuTBtIjiZzX6"
Content-Disposition: inline
In-Reply-To: <20110630164216.GU3386@htj.dyndns.org>
Organization: Advanced Micro Devices GmbH, Einsteinring 24, 85609 Dornach b.
 Muenchen; Geschaeftsfuehrer: Andrew Bowd, Alberto Bozzo; Sitz: Dornach,
 Gemeinde Aschheim, Landkreis Muenchen; Registergericht Muenchen, HRB Nr.
 43632
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--UfEAyuTBtIjiZzX6
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

On Thu, Jun 30, 2011 at 12:42:16PM -0400, Tejun Heo wrote:
> Can you please attach boot log w/ SPARSEMEM?  Let's see whether NUMA
> config is being rejected correctly.

I already sent it in the earlier mail, but here it is again. NUMA is
rejected.


Hans


-- 
%SYSTEM-F-ANARCHISM, The operating system has been overthrown

--UfEAyuTBtIjiZzX6
Content-Type: text/plain; charset="us-ascii"; name="bootlog_sparsemem"
Content-Disposition: attachment; filename="bootlog_sparsemem"
Content-Description: bootlog_sparsemem

kernel /boot/vmlinuz.panic root=/dev/sda1 console=ttyS0,115200 console=tty0 ign
ore_loglevel earlyprintk=ttyS0,115200 debug
   [Linux-bzImage, setup=0x3200, size=0x34ce70]

early console in setup code
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Linux version 2.6.39-rc5-00181-g2706a0b-dirty (root@worms) (gcc version 4.5.2 (Gentoo 4.5.2 p1.1, pie-0.4.5) ) #27 SMP Thu Jun 30 15:00:39 CEST 2011
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 0000000000087800 (usable)
[    0.000000]  BIOS-e820: 0000000000087800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000cc000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000c7e70000 (usable)
[    0.000000]  BIOS-e820: 00000000c7e70000 - 00000000c7e8c000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000c7e8c000 - 00000000c7e8e000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000c7e8e000 - 00000000c8000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000001838000000 (usable)
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] DMI: AMD DRACHMA/DRACHMA, BIOS PDPAX1-6 12/15/2009
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] last_pfn = 0x1000000 max_arch_pfn = 0x1000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-D7FFF write-protect
[    0.000000]   D8000-DFFFF uncachable
[    0.000000]   E0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000000 mask FFFF80000000 write-back
[    0.000000]   1 base 000080000000 mask FFFFC0000000 write-back
[    0.000000]   2 base 0000C0000000 mask FFFFF8000000 write-back
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 0000001838000000 aka 99200M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000c8000000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] found SMP MP-table at [c00f7240] f7240
[    0.000000] initial memory mapped : 0 - 01c00000
[    0.000000] Base memory trampoline at [c0083000] 83000 size 16384
[    0.000000] init_memory_mapping: 0000000000000000-00000000375fe000
[    0.000000]  0000000000 - 0000200000 page 4k
[    0.000000]  0000200000 - 0037400000 page 2M
[    0.000000]  0037400000 - 00375fe000 page 4k
[    0.000000] kernel direct mapping tables up to 375fe000 @ 1bf8000-1c00000
[    0.000000] ACPI: RSDP 000f71c0 00024 (v02 PTLTD )
[    0.000000] ACPI: XSDT c7e78aee 00074 (v01 PTLTD  ? XSDT   06040000  LTP 00000000)
[    0.000000] ACPI: FACP c7e83b26 000F4 (v03 AMD    CHIPOTLE 06040000 AMD  000F4240)
[    0.000000] ACPI: DSDT c7e78b62 0AFC4 (v02    AMD    SB700 06040000 MSFT 03000000)
[    0.000000] ACPI: FACS c7e8dfc0 00040
[    0.000000] ACPI: TCPA c7e83c8e 00032 (v02 AMD             06040000 PTEC 00000000)
[    0.000000] ACPI: SLIT c7e83cc0 0006C (v01 AMD    F10      06040000 AMD  00000001)
[    0.000000] ACPI: SRAT c7e83d2c 004C0 (v02 AMD    F10      06040000 AMD  00000001)
[    0.000000] ACPI: IVRS c7e841ec 000E8 (v01  AMD     RD890S 06040000 AMD  00000000)
[    0.000000] ACPI: SSDT c7e842d4 078B4 (v01 AMD    POWERNOW 06040000 AMD  00000001)
[    0.000000] ACPI: SSDT c7e8bb88 0010A (v01 AMD-K8 AMD-ACPI 06040000  AMD 00000001)
[    0.000000] ACPI: APIC c7e8bc92 002FA (v01 PTLTD  ? APIC   06040000  LTP 00000000)
[    0.000000] ACPI: MCFG c7e8bf8c 0003C (v01 PTLTD    MCFG   06040000  LTP 00000000)
[    0.000000] ACPI: HPET c7e8bfc8 00038 (v01 PTLTD  HPETTBL  06040000  LTP 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] Scanning NUMA topology in Northbridge 24
[    0.000000] Number of physical nodes 8
[    0.000000] Node 0 MemBase 0000000000000000 Limit 0000000238000000
[    0.000000] Node 1 MemBase 0000000238000000 Limit 0000000638000000
[    0.000000] Node 2 MemBase 0000000638000000 Limit 0000000838000000
[    0.000000] Node 3 MemBase 0000000838000000 Limit 0000000c38000000
[    0.000000] Node 4 MemBase 0000000c38000000 Limit 0000000e38000000
[    0.000000] Node 5 MemBase 0000000e38000000 Limit 0000001000000000
[    0.000000] Node 6 bogus settings 1238000000-1000000000.
[    0.000000] Node 7 bogus settings 1438000000-1000000000.
[    0.000000] BSP APIC ID: 10
[    0.000000] Node alignment 128MB < min 512MB, rejecting NUMA config
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-0000001000000000
[    0.000000] node 0 pfn: [0 - 1000000]
[    0.000000] remap_alloc: node 0 [fffe00000-1000000000) -> [f7200000-f7400000)
[    0.000000] Initmem setup node 0 0000000000000000-0000001000000000
[    0.000000]   NODE_DATA [0000000037200000 - 0000000037201fff] (remapped)
[    0.000000] 64650MB HIGHMEM available.
[    0.000000] 885MB LOWMEM available.
[    0.000000] max_low_pfn = 375fe, highstart_pfn = 375fe
[    0.000000] Low memory ends at vaddr f75fe000
[    0.000000] High memory starts at vaddr f75fe000
[    0.000000]   mapped low ram: 0 - 375fe000
[    0.000000]   low ram: 0 - 375fe000
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000375fe
[    0.000000]   HighMem  0x000375fe -> 0x01000000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x00000087
[    0.000000]     0: 0x00000100 -> 0x000c7e70
[    0.000000]     0: 0x00100000 -> 0x01000000
[    0.000000] On node 0 totalpages: 16547303
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3927 pages, LIFO batch:0
[    0.000000]   Normal zone: 1740 pages used for memmap
[    0.000000]   Normal zone: 220978 pages, LIFO batch:31
[    0.000000]   HighMem zone: 129301 pages used for memmap
[    0.000000]   HighMem zone: 16191325 pages, LIFO batch:31
[    0.000000] Using APIC driver default

--UfEAyuTBtIjiZzX6--

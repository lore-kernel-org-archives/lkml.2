Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040Ab2JMS5J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 14:57:09 -0400
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:11651 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170Ab2JMS5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 14:57:05 -0400
X-Authority-Analysis: v=2.0 cv=Q6tQEvKa c=1 sm=0 a=YPDeGStqRoQnMAluW+pq4Q==:17 a=65KWcu232dMA:10 a=h9GbcFHyNoYA:10 a=DpEkYpXRGzUA:10 a=05ChyHeVI94A:10 a=ayC55rCoAAAA:8 a=nULq49Tkjo8A:10 a=LN7EJh0wAAAA:8 a=gRbAvwS9rVteY757uoMA:9 a=wPNLvfGTeEIA:10 a=1N10a5YcSQUA:10 a=20KFwNOVAAAA:8 a=Vjn1TBLfN7xNLg6NYPEA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=RThl9-PaEtCMFXTm:21 a=tcgW7_0pxWb2x3pJ:21 a=bhhegv1t6XailCjw:21 a=gIQz-hhscQYDWgzIZtYA:9 a=OYQLMpdwetFm4R_P:21 a=8IpaOc21EsgsWb0m:21 a=Wvs9zA-D4uoiuzeP:21 a=YPDeGStqRoQnMAluW+pq4Q==:117
X-Cloudmark-Score: 0
X-Originating-IP: 50.89.247.146
Message-ID: <5079B97C.7020401@cfl.rr.com>
Date: Sat, 13 Oct 2012 14:57:00 -0400
From: Mark Hounschell <dmarkh@cfl.rr.com>
Reply-To: dmarkh@cfl.rr.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
CC: markh@compro.net, linux-kernel@vger.kernel.org,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>
Subject: Re: Intel graphics drm issue?
References: <507812E8.3060607@compro.net> <20121012231459.166e29fd@neptune.home>
In-Reply-To: <20121012231459.166e29fd@neptune.home>
Content-Type: multipart/mixed;
 boundary="------------040200070506070205090009"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040200070506070205090009
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Hi Bruno,

Thanks for the response.

On 10/12/2012 05:14 PM, Bruno Pr=E9mont wrote:
> Hi Mark,
>
> [CCing intel-gfx]
>
> On Fri, 12 October 2012 Mark Hounschell <markh@compro.net> wrote:
>> Not sure this is the correct place to ask about a possible drm issue. =
I
>> have an intel based PC with an HDMI port that I'm trying to connect to=

>> an LG TV. I have successfully used this HDMI port connected to an Opti=
ma
>> projector. Using that projector, everything from the BIOS post, BIOS
>> configuration, and all the way up to a graphical login worked just fin=
e.
>> The same HDMI port and cable connected to this TV gives me the below
>> messages during boot. I also get no BIOS post or BIOS configuration
>> output while in the BIOS. I have a monitor connected to the DVI port s=
o
>> I can see what I should see on the TV there, just as when I was
>> connected to the Optima projector. That alone makes me pretty sure it'=
s
>> not a kernel issue but here are the messages anyway. Maybe they will
>> give someone a hint as to what the problem may be, in the case they
>> might be willing to give me any pointers.
>>
>> TV - LG 42lb9df
>> PC - intel DH77DF motherboard
>
>> [    0.000000] Linux version 3.4.10-lcrs (root@geexbox) (gcc version 4=
=2E7.1 20120723 [gcc-4_7-branch revision 189773] (SUSE Linux) ) #1 SMP PR=
EEMPT Wed Oct 10 16:16:16 EDT 2012
>> ...
>> [    1.897955] [drm] MTRR allocation failed.  Graphics performance may=
 suffer.
>> [    1.898045] i915 0000:00:02.0: irq 43 for MSI/MSI-X
>> [    1.898050] [drm] Supports vblank timestamp caching Rev 1 (10.10.20=
10).
>> [    1.898051] [drm] Driver supports precise vblank timestamp query.
>> [    1.898084] [drm:intel_dsm_platform_mux_info] *ERROR* MUX INFO call=
 failed
>> [    1.898737] vgaarb: device changed decodes: PCI:0000:00:02.0,olddec=
odes=3Dio+mem,decodes=3Dio+mem:owns=3Dio+mem
>> [    1.995523] [drm] Enabling RC6 states: RC6 on, RC6p on, RC6pp off
>> [    2.299535] [drm:drm_edid_block_valid] *ERROR* EDID checksum is inv=
alid, remainder is 128
>> [    2.299865] Raw EDID:
>> [    2.299957]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff f=
f
>> [    2.300188]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff f=
f
>> [    2.300418]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff f=
f
>> [    2.300648]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff f=
f
>> [    2.300879]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff f=
f
>> [    2.301109]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff f=
f
>> [    2.301339]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff f=
f
>> [    2.301569]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff f=
f
>
> This looks like your LG TV either does not provide EDID information via=
 HDMI
> connector, or otherwise behaves in a special way which makes reading ED=
ID
> fail.
>
> Did you try the TV on some other computer to check if EDID can be read =
there
> (e.g. with nvidia/amd GPU and matching open/closed driver)?
>
> Also make sure the TV is on (neither off nor on stand-by) as some TVs
> disable too much of connector interface in those states.
>

I have another AMD based PC here with an nvidia card and HDMI port. Using=
=20
the nvidia driver, it boots up with no output to the tv until X starts.=20
Once X starts I get my kdm login screen. All is well except the resolutio=
n=20
is 800x600 and I have no VTs. I suspect if I had a properly configured=20
xorg.conf file, my resolution would be what I defined in it and work.

Using the nouveau driver, I get nothing but "no signal" on the tv.  Just =

like the the intel box, except no EDID messages in the log file. I've=20
attached a dmesg outputs for each config.

Back on the Intel machine. I boot up with a normal monitor connected to t=
he=20
DVI port of the PC. Then at the kdm login screen, I disconnect the DVI=20
cable from the PC and connect the TV to the PCs DVI port using a DVI/HDMI=
=20
adapter. I get a beautiful 1600x1200 resolution screen on the TV. This do=
es=20
not happen using the PC HDMI port.

I have no control over the tv with regards to stand-by mode. Off is stand=
by=20
mode, on is on.

>> [    2.434378] i915 0000:00:02.0: HDMI-A-3: EDID block 0 invalid.
>> [    2.477539] checking generic (e0000000 3ff0000) vs hw (e0000000 100=
00000)
>> [    2.477541] fb: conflicting fb hw usage inteldrmfb vs VESA VGA - re=
moving generic driver
>> [    2.477549] Console: switching to colour dummy device 80x25
>> [    2.477831] fbcon: inteldrmfb (fb0) is primary device
>> [    2.637915] Console: switching to colour frame buffer device 128x48=

>> [    2.679625] fb0: inteldrmfb frame buffer device
>> [    2.679626] drm: registered panic notifier
>> [    2.691536] acpi device:4b: registered as cooling_device9
>> [    2.691660] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0=
A08:00/LNXVIDEO:00/input/input4
>> [    2.691698] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  po=
st: no)
>> [    2.691709] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 =
on minor 0
>
>> geexbox:/home/mplayer # lspci
>> 00:00.0 Host bridge: Intel Corporation Xeon E3-1200 v2/3rd Gen Core pr=
ocessor DRAM Controller (rev 09)
>> ...
>> 00:02.0 VGA compatible controller: Intel Corporation Xeon E3-1200 v2/3=
rd Gen Core processor Graphics Controller (rev 09)
>> ...
>
> Note, usually `lspci -nn` is more informative as it also provides vendo=
r/device
> IDs in addition to nice names.

# lspci -nn
00:00.0 Host bridge [0600]: Intel Corporation Xeon E3-1200 v2/3rd Gen Cor=
e=20
processor DRAM Controller [8086:0150] (rev 09)
00:01.0 PCI bridge [0604]: Intel Corporation Xeon E3-1200 v2/3rd Gen Core=
=20
processor PCI Express Root Port [8086:0151] (rev 09)
00:02.0 VGA compatible controller [0300]: Intel Corporation Xeon E3-1200 =

v2/3rd Gen Core processor Graphics Controller [8086:0162] (rev 09)
00:14.0 USB controller [0c03]: Intel Corporation 7 Series/C210 Series=20
Chipset Family USB xHCI Host Controller [8086:1e31] (rev 04)
00:16.0 Communication controller [0780]: Intel Corporation 7 Series/C210 =

Series Chipset Family MEI Controller #1 [8086:1e3a] (rev 04)
00:19.0 Ethernet controller [0200]: Intel Corporation 82579V Gigabit=20
Network Connection [8086:1503] (rev 04)
00:1a.0 USB controller [0c03]: Intel Corporation 7 Series/C210 Series=20
Chipset Family USB Enhanced Host Controller #2 [8086:1e2d] (rev 04)
00:1c.0 PCI bridge [0604]: Intel Corporation 7 Series/C210 Series Chipset=
=20
Family PCI Express Root Port 1 [8086:1e10] (rev c4)
00:1c.7 PCI bridge [0604]: Intel Corporation 7 Series/C210 Series Chipset=
=20
Family PCI Express Root Port 8 [8086:1e1e] (rev c4)
00:1d.0 USB controller [0c03]: Intel Corporation 7 Series/C210 Series=20
Chipset Family USB Enhanced Host Controller #1 [8086:1e26] (rev 04)
00:1f.0 ISA bridge [0601]: Intel Corporation H77 Express Chipset LPC=20
Controller [8086:1e4a] (rev 04)
00:1f.2 SATA controller [0106]: Intel Corporation 7 Series/C210 Series=20
Chipset Family 6-port SATA Controller [AHCI mode] [8086:1e02] (rev 04)
00:1f.3 SMBus [0c05]: Intel Corporation 7 Series/C210 Series Chipset Fami=
ly=20
SMBus Controller [8086:1e22] (rev 04)
01:00.0 PCI bridge [0604]: PLX Technology, Inc. PEX8112 x1 Lane PCI=20
Express-to-PCI Bridge [10b5:8112] (rev aa)
02:04.0 Multimedia audio controller [0401]: C-Media Electronics Inc CMI87=
88=20
[Oxygen HD Audio] [13f6:8788]


I can do more to help if asked.

Regards
Mark

--------------040200070506070205090009
Content-Type: text/plain; charset=UTF-8;
 name="dmesg.nvidia-hdmi"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg.nvidia-hdmi"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.37.6-0.20-desktop (geeko@buildhost) (gcc version 4.5.1 20101208 [gcc-4_5-branch revision 167585] (SUSE Linux) ) #1 SMP PREEMPT 2011-12-19 23:39:38 +0100
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
[    0.000000]  BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000affe0000 (usable)
[    0.000000]  BIOS-e820: 00000000affe0000 - 00000000affe3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000affe3000 - 00000000afff0000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000afff0000 - 00000000b0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000150000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.5 present.
[    0.000000] DMI: BIOSTAR Group A78XA-A2T/TA770 A2+, BIOS 6.00 PG 06/12/2008
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] last_pfn = 0x150000 max_arch_pfn = 0x1000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-C7FFF write-protect
[    0.000000]   C8000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-through
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask FF80000000 write-back
[    0.000000]   1 base 0080000000 mask FFE0000000 write-back
[    0.000000]   2 base 00A0000000 mask FFF0000000 write-back
[    0.000000]   3 base 0100000000 mask FFC0000000 write-back
[    0.000000]   4 base 0140000000 mask FFF0000000 write-back
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 0000000150000000 aka 5376M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000b0000000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] found SMP MP-table at [c00f3f00] f3f00
[    0.000000] initial memory mapped : 0 - 01000000
[    0.000000] init_memory_mapping: 0000000000000000-00000000371fe000
[    0.000000]  0000000000 - 0000200000 page 4k
[    0.000000]  0000200000 - 0037000000 page 2M
[    0.000000]  0037000000 - 00371fe000 page 4k
[    0.000000] kernel direct mapping tables up to 371fe000 @ ff6000-1000000
[    0.000000] RAMDISK: 3758e000 - 37ff0000
[    0.000000] Allocated new RAMDISK: 3679c000 - 371fdffa
[    0.000000] Move RAMDISK from 000000003758e000 - 0000000037fefff9 to 3679c000 - 371fdff9
[    0.000000] ACPI: RSDP 000f7fb0 00024 (v02 RX780 )
[    0.000000] ACPI: RSDT affe3000 00038 (v01 RX780  AWRDACPI 42302E31 AWRD 00000000)
[    0.000000] ACPI: FACP affe3080 00074 (v01 RX780  AWRDACPI 42302E31 AWRD 00000000)
[    0.000000] ACPI: DSDT affe3100 05A71 (v01 RX780  AWRDACPI 00001000 MSFT 0100000E)
[    0.000000] ACPI: FACS affe0000 00040
[    0.000000] ACPI: SSDT affe8c40 00350 (v01 PTLTD  POWERNOW 00000001  LTP 00000001)
[    0.000000] ACPI: HPET affe8fc0 00038 (v01 RX780  AWRDACPI 42302E31 AWRD 00000098)
[    0.000000] ACPI: MCFG affe9000 0003C (v01 RX780  AWRDACPI 42302E31 AWRD 00000000)
[    0.000000] ACPI: APIC affe8b80 00084 (v01 RX780  AWRDACPI 42302E31 AWRD 00000000)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] could not find any ACPI SRAT memory areas.
[    0.000000] failed to get NUMA memory information from SRAT table
[    0.000000] NUMA - single node, flat memory mode
[    0.000000] Node: 0, start_pfn: 0, end_pfn: 150000
[    0.000000]   Setting physnode_map array to node 0 for pfns:
[    0.000000]   0 4000 8000 c000 10000 14000 18000 1c000 20000 24000 28000 2c000 30000 34000 38000 3c000 40000 44000 48000 4c000 50000 54000 58000 5c000 60000 64000 68000 6c000 70000 74000 78000 7c000 80000 84000 88000 8c000 90000 94000 98000 9c000 a0000 a4000 a8000 ac000 b0000 b4000 b8000 bc000 c0000 c4000 c8000 cc000 d0000 d4000 d8000 dc000 e0000 e4000 e8000 ec000 f0000 f4000 f8000 fc000 100000 104000 108000 10c000 110000 114000 118000 11c000 120000 124000 128000 12c000 130000 134000 138000 13c000 140000 144000 148000 14c000 
[    0.000000] node 0 pfn: [0 - 150000]
[    0.000000] Reserving 11264 pages of KVA for lmem_map of node 0 at 14d400
[    0.000000] Reserving total of 2c00 pages for numa KVA remap
[    0.000000] kva_start_pfn ~ 33a00 max_low_pfn ~ 371fe
[    0.000000] max_pfn = 150000
[    0.000000] 4494MB HIGHMEM available.
[    0.000000] 881MB LOWMEM available.
[    0.000000] max_low_pfn = 371fe, highstart_pfn = 371fe
[    0.000000] Low memory ends at vaddr f71fe000
[    0.000000] node 0 will remap to vaddr f3a00000 - f6600000
[    0.000000] allocate_pgdat: node 0 NODE_DATA f3a00000
[    0.000000] remap_numa_kva: node 0
[    0.000000] remap_numa_kva: f3a00000 to pfn 0014d400
[    0.000000] remap_numa_kva: f3c00000 to pfn 0014d600
[    0.000000] remap_numa_kva: f3e00000 to pfn 0014d800
[    0.000000] remap_numa_kva: f4000000 to pfn 0014da00
[    0.000000] remap_numa_kva: f4200000 to pfn 0014dc00
[    0.000000] remap_numa_kva: f4400000 to pfn 0014de00
[    0.000000] remap_numa_kva: f4600000 to pfn 0014e000
[    0.000000] remap_numa_kva: f4800000 to pfn 0014e200
[    0.000000] remap_numa_kva: f4a00000 to pfn 0014e400
[    0.000000] remap_numa_kva: f4c00000 to pfn 0014e600
[    0.000000] remap_numa_kva: f4e00000 to pfn 0014e800
[    0.000000] remap_numa_kva: f5000000 to pfn 0014ea00
[    0.000000] remap_numa_kva: f5200000 to pfn 0014ec00
[    0.000000] remap_numa_kva: f5400000 to pfn 0014ee00
[    0.000000] remap_numa_kva: f5600000 to pfn 0014f000
[    0.000000] remap_numa_kva: f5800000 to pfn 0014f200
[    0.000000] remap_numa_kva: f5a00000 to pfn 0014f400
[    0.000000] remap_numa_kva: f5c00000 to pfn 0014f600
[    0.000000] remap_numa_kva: f5e00000 to pfn 0014f800
[    0.000000] remap_numa_kva: f6000000 to pfn 0014fa00
[    0.000000] remap_numa_kva: f6200000 to pfn 0014fc00
[    0.000000] remap_numa_kva: f6400000 to pfn 0014fe00
[    0.000000] High memory starts at vaddr f71fe000
[    0.000000]   mapped low ram: 0 - 371fe000
[    0.000000]   low ram: 0 - 371fe000
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000371fe
[    0.000000]   HighMem  0x000371fe -> 0x00150000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000affe0
[    0.000000]     0: 0x00100000 -> 0x00150000
[    0.000000] On node 0 totalpages: 1048431
[    0.000000] free_area_init_node: node 0, pgdat f3a00000, node_mem_map f3a02200
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3951 pages, LIFO batch:0
[    0.000000]   Normal zone: 1732 pages used for memmap
[    0.000000]   Normal zone: 219962 pages, LIFO batch:31
[    0.000000]   HighMem zone: 8989 pages used for memmap
[    0.000000]   HighMem zone: 813765 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] Detected use of extended apic ids on hypertransport bus
[    0.000000] ACPI: PM-Timer IO Port: 0x4008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 33, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x10b9a201 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 2 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at b0000000 (gap: b0000000:30000000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:128 nr_cpumask_bits:128 nr_cpu_ids:4 nr_node_ids:8
[    0.000000] PERCPU: Embedded 12 pages/cpu @f3800000 s28160 r0 d20992 u524288
[    0.000000] pcpu-alloc: s28160 r0 d20992 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1037678
[    0.000000] Policy zone: HighMem
[    0.000000] Kernel command line: root=/dev/sda5 resume=/dev/disk/by-id/ata-ST3250318AS_6VY3CK0B-part2 splash=silent quiet vga=0x31a nomodeset
[    0.000000] bootsplash: silent mode.
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] allocated 27524800 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] Initializing HighMem for node 0 (000371fe:00150000)
[    0.000000] Memory: 4055300k/5505024k available (4704k kernel code, 93368k reserved, 3493k data, 452k init, 3245960k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xff5b4000 - 0xfffff000   (10540 kB)
[    0.000000]     pkmap   : 0xff200000 - 0xff400000   (2048 kB)
[    0.000000]     vmalloc : 0xf79fe000 - 0xff1fe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf71fe000   ( 881 MB)
[    0.000000]       .init : 0xc0a02000 - 0xc0a73000   ( 452 kB)
[    0.000000]       .data : 0xc06980ad - 0xc0a01708   (3493 kB)
[    0.000000]       .text : 0xc0200000 - 0xc06980ad   (4704 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] Preemptable hierarchical RCU implementation.
[    0.000000] 	RCU-based detection of stalled CPUs is disabled.
[    0.000000] 	Verbose stalled-CPUs detection is disabled.
[    0.000000] NR_IRQS:8448 nr_irqs:712 16
[    0.000000] CPU 0 irqstacks, hard=f180c000 soft=f180e000
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration failed
[    0.000000] TSC: Unable to calibrate against PIT
[    0.000000] TSC: using HPET reference calibration
[    0.000000] Detected 3200.267 MHz processor.
[    0.004005] Calibrating delay loop (skipped), value calculated using timer frequency.. 6400.53 BogoMIPS (lpj=3200267)
[    0.004008] pid_max: default: 32768 minimum: 301
[    0.004059] Security Framework initialized
[    0.004068] AppArmor: AppArmor initialized
[    0.004109] Mount-cache hash table entries: 512
[    0.004189] Initializing cgroup subsys ns
[    0.004191] ns_cgroup deprecated: consider using the 'clone_children' flag without the ns_cgroup.
[    0.004193] Initializing cgroup subsys cpuacct
[    0.004196] Initializing cgroup subsys memory
[    0.004204] Initializing cgroup subsys devices
[    0.004205] Initializing cgroup subsys freezer
[    0.004206] Initializing cgroup subsys net_cls
[    0.004208] Initializing cgroup subsys blkio
[    0.004230] CPU: Physical Processor ID: 0
[    0.004231] CPU: Processor Core ID: 0
[    0.004232] mce: CPU supports 5 MCE banks
[    0.004239] using C1E aware idle routine
[    0.004244] Performance Events: AMD PMU driver.
[    0.004246] ... version:                0
[    0.004247] ... bit width:              48
[    0.004248] ... generic registers:      4
[    0.004250] ... value mask:             0000ffffffffffff
[    0.004251] ... max period:             00007fffffffffff
[    0.004252] ... fixed-purpose events:   0
[    0.004253] ... event mask:             000000000000000f
[    0.004479] ACPI: Core revision 20101013
[    0.012070] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.012377] Mapping cpu 0 to node 0
[    0.013144] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.023149] CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 6400+ stepping 03
[    0.026011] NMI watchdog enabled, takes one hw-pmu counter.
[    0.030012] CPU 1 irqstacks, hard=f18a0000 soft=f18a2000
[    0.030016] Booting Node   0, Processors  #1
[    0.004999] Initializing CPU#1
[    0.004999] Mapping cpu 1 to node 0
[    0.101087] NMI watchdog enabled, takes one hw-pmu counter.
[    0.102003] Brought up 2 CPUs
[    0.102005] Total of 2 processors activated (12800.61 BogoMIPS).
[    0.102238] devtmpfs: initialized
[    0.102238] regulator: core version 0.5
[    0.102238] regulator: dummy: 
[    0.102238] Time: 11:39:06  Date: 10/13/12
[    0.102238] NET: Registered protocol family 16
[    0.102323] node 0 link 0: io port [b000, ffff]
[    0.102325] TOM: 00000000b0000000 aka 2816M
[    0.102327] node 0 link 0: mmio [a0000, bffff]
[    0.102329] node 0 link 0: mmio [b0000000, dfffffff]
[    0.102331] node 0 link 0: mmio [f0000000, fe02ffff]
[    0.102333] node 0 link 0: mmio [e0000000, e04fffff]
[    0.102335] TOM2: 0000000150000000 aka 5376M
[    0.102337] bus: [00, 04] on node 0 link 0
[    0.102339] bus: 00 index 0 [io  0x0000-0xffff]
[    0.102340] bus: 00 index 1 [mem 0x000a0000-0x000bffff]
[    0.102342] bus: 00 index 2 [mem 0xb0000000-0xefffffff]
[    0.102343] bus: 00 index 3 [mem 0xf0000000-0xffffffff]
[    0.102345] bus: 00 index 4 [mem 0x150000000-0xfcffffffff]
[    0.102409] ACPI: bus type pci registered
[    0.102469] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.102472] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.102473] PCI: Using MMCONFIG for extended config space
[    0.102474] PCI: Using configuration type 1 for base access
[    0.103613] bio: create slab <bio-0> at 0
[    0.104600] ACPI: EC: Look up EC in DSDT
[    0.105441] ACPI: Executed 1 blocks of module-level executable AML code
[    0.108567] ACPI: Interpreter enabled
[    0.108570] ACPI: (supports S0 S1 S4 S5)
[    0.108588] ACPI: Using IOAPIC for interrupt routing
[    0.112090] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-743)
[    0.112155] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-743)
[    0.112174] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-743)
[    0.115375] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-743)
[    0.115443] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-743)
[    0.115846] ACPI: No dock devices found.
[    0.115849] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.115912] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.116056] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
[    0.116058] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
[    0.116060] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.116062] pci_root PNP0A03:00: host bridge window [mem 0x000c0000-0x000dffff]
[    0.116064] pci_root PNP0A03:00: host bridge window [mem 0xafff0000-0xffffffff]
[    0.116079] pci 0000:00:00.0: [1002:5957] type 0 class 0x000600
[    0.116091] pci 0000:00:00.0: reg 1c: [mem 0xe0000000-0xffffffff 64bit]
[    0.116121] pci 0000:00:02.0: [1002:5978] type 1 class 0x000604
[    0.116147] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
[    0.116150] pci 0000:00:02.0: PME# disabled
[    0.116167] pci 0000:00:06.0: [1002:597c] type 1 class 0x000604
[    0.116192] pci 0000:00:06.0: PME# supported from D0 D3hot D3cold
[    0.116194] pci 0000:00:06.0: PME# disabled
[    0.116207] pci 0000:00:07.0: [1002:597d] type 1 class 0x000604
[    0.116232] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    0.116234] pci 0000:00:07.0: PME# disabled
[    0.116265] pci 0000:00:12.0: [1002:4380] type 0 class 0x000101
[    0.116282] pci 0000:00:12.0: reg 10: [io  0xff00-0xff07]
[    0.116292] pci 0000:00:12.0: reg 14: [io  0xfe00-0xfe03]
[    0.116303] pci 0000:00:12.0: reg 18: [io  0xfd00-0xfd07]
[    0.116313] pci 0000:00:12.0: reg 1c: [io  0xfc00-0xfc03]
[    0.116323] pci 0000:00:12.0: reg 20: [io  0xfb00-0xfb0f]
[    0.116333] pci 0000:00:12.0: reg 24: [mem 0xfe02f000-0xfe02f3ff]
[    0.116355] pci 0000:00:12.0: set SATA to AHCI mode
[    0.116383] pci 0000:00:13.0: [1002:4387] type 0 class 0x000c03
[    0.116397] pci 0000:00:13.0: reg 10: [mem 0xfe02e000-0xfe02efff]
[    0.116464] pci 0000:00:13.1: [1002:4388] type 0 class 0x000c03
[    0.116478] pci 0000:00:13.1: reg 10: [mem 0xfe02d000-0xfe02dfff]
[    0.116543] pci 0000:00:13.2: [1002:4389] type 0 class 0x000c03
[    0.116557] pci 0000:00:13.2: reg 10: [mem 0xfe02c000-0xfe02cfff]
[    0.116624] pci 0000:00:13.3: [1002:438a] type 0 class 0x000c03
[    0.116638] pci 0000:00:13.3: reg 10: [mem 0xfe02b000-0xfe02bfff]
[    0.116703] pci 0000:00:13.4: [1002:438b] type 0 class 0x000c03
[    0.116718] pci 0000:00:13.4: reg 10: [mem 0xfe02a000-0xfe02afff]
[    0.116790] pci 0000:00:13.5: [1002:4386] type 0 class 0x000c03
[    0.116810] pci 0000:00:13.5: reg 10: [mem 0xfe029000-0xfe0290ff]
[    0.116884] pci 0000:00:13.5: supports D1 D2
[    0.116885] pci 0000:00:13.5: PME# supported from D0 D1 D2 D3hot
[    0.116889] pci 0000:00:13.5: PME# disabled
[    0.116911] pci 0000:00:14.0: [1002:4385] type 0 class 0x000c05
[    0.116934] pci 0000:00:14.0: reg 10: [io  0x0b00-0x0b0f]
[    0.117017] pci 0000:00:14.1: [1002:438c] type 0 class 0x000101
[    0.117030] pci 0000:00:14.1: reg 10: [io  0x0000-0x0007]
[    0.117040] pci 0000:00:14.1: reg 14: [io  0x0000-0x0003]
[    0.117050] pci 0000:00:14.1: reg 18: [io  0x0000-0x0007]
[    0.117060] pci 0000:00:14.1: reg 1c: [io  0x0000-0x0003]
[    0.117070] pci 0000:00:14.1: reg 20: [io  0xf900-0xf90f]
[    0.117107] pci 0000:00:14.2: [1002:4383] type 0 class 0x000403
[    0.117130] pci 0000:00:14.2: reg 10: [mem 0xfe024000-0xfe027fff 64bit]
[    0.117190] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    0.117194] pci 0000:00:14.2: PME# disabled
[    0.117208] pci 0000:00:14.3: [1002:438d] type 0 class 0x000601
[    0.117284] pci 0000:00:14.4: [1002:4384] type 1 class 0x000604
[    0.117329] pci 0000:00:18.0: [1022:1100] type 0 class 0x000600
[    0.117342] pci 0000:00:18.1: [1022:1101] type 0 class 0x000600
[    0.117353] pci 0000:00:18.2: [1022:1102] type 0 class 0x000600
[    0.117364] pci 0000:00:18.3: [1022:1103] type 0 class 0x000600
[    0.117415] pci 0000:01:00.0: [10de:0a65] type 0 class 0x000300
[    0.117425] pci 0000:01:00.0: reg 10: [mem 0xfb000000-0xfbffffff]
[    0.117436] pci 0000:01:00.0: reg 14: [mem 0xb0000000-0xbfffffff 64bit pref]
[    0.117447] pci 0000:01:00.0: reg 1c: [mem 0xce000000-0xcfffffff 64bit pref]
[    0.117455] pci 0000:01:00.0: reg 24: [io  0xcf00-0xcf7f]
[    0.117462] pci 0000:01:00.0: reg 30: [mem 0x00000000-0x0007ffff pref]
[    0.117506] pci 0000:01:00.1: [10de:0be3] type 0 class 0x000403
[    0.117517] pci 0000:01:00.1: reg 10: [mem 0xfcffc000-0xfcffffff]
[    0.119012] pci 0000:00:02.0: PCI bridge to [bus 01-01]
[    0.119015] pci 0000:00:02.0:   bridge window [io  0xc000-0xcfff]
[    0.119018] pci 0000:00:02.0:   bridge window [mem 0xfb000000-0xfcffffff]
[    0.119021] pci 0000:00:02.0:   bridge window [mem 0xb0000000-0xcfffffff 64bit pref]
[    0.119058] pci 0000:02:00.0: [197b:2363] type 0 class 0x000104
[    0.119126] pci 0000:02:00.0: reg 24: [mem 0xfdffe000-0xfdffffff]
[    0.119137] pci 0000:02:00.0: reg 30: [mem 0x00000000-0x0000ffff pref]
[    0.119162] pci 0000:02:00.0: PME# supported from D3hot
[    0.119166] pci 0000:02:00.0: PME# disabled
[    0.119189] pci 0000:02:00.1: [197b:2363] type 0 class 0x000101
[    0.119207] pci 0000:02:00.1: reg 10: [io  0xef00-0xef07]
[    0.119218] pci 0000:02:00.1: reg 14: [io  0xee00-0xee03]
[    0.119229] pci 0000:02:00.1: reg 18: [io  0xed00-0xed07]
[    0.119240] pci 0000:02:00.1: reg 1c: [io  0xec00-0xec03]
[    0.119251] pci 0000:02:00.1: reg 20: [io  0xeb00-0xeb0f]
[    0.119304] pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.119314] pci 0000:00:06.0: PCI bridge to [bus 02-02]
[    0.119317] pci 0000:00:06.0:   bridge window [io  0xe000-0xefff]
[    0.119320] pci 0000:00:06.0:   bridge window [mem 0xfdf00000-0xfdffffff]
[    0.119323] pci 0000:00:06.0:   bridge window [mem 0xfde00000-0xfdefffff 64bit pref]
[    0.119362] pci 0000:03:00.0: [11ab:4364] type 0 class 0x000200
[    0.119380] pci 0000:03:00.0: reg 10: [mem 0xfddfc000-0xfddfffff 64bit]
[    0.119389] pci 0000:03:00.0: reg 18: [io  0xde00-0xdeff]
[    0.119422] pci 0000:03:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    0.119451] pci 0000:03:00.0: supports D1 D2
[    0.119453] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.119457] pci 0000:03:00.0: PME# disabled
[    0.121009] pci 0000:00:07.0: PCI bridge to [bus 03-03]
[    0.121012] pci 0000:00:07.0:   bridge window [io  0xd000-0xdfff]
[    0.121015] pci 0000:00:07.0:   bridge window [mem 0xfdd00000-0xfddfffff]
[    0.121018] pci 0000:00:07.0:   bridge window [mem 0xfdc00000-0xfdcfffff 64bit pref]
[    0.121081] pci 0000:00:14.4: PCI bridge to [bus 04-04] (subtractive decode)
[    0.121085] pci 0000:00:14.4:   bridge window [io  0xb000-0xbfff]
[    0.121089] pci 0000:00:14.4:   bridge window [mem 0xfdb00000-0xfdbfffff]
[    0.121093] pci 0000:00:14.4:   bridge window [mem 0xfda00000-0xfdafffff pref]
[    0.121095] pci 0000:00:14.4:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.121097] pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.121100] pci 0000:00:14.4:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.121102] pci 0000:00:14.4:   bridge window [mem 0x000c0000-0x000dffff] (subtractive decode)
[    0.121104] pci 0000:00:14.4:   bridge window [mem 0xafff0000-0xffffffff] (subtractive decode)
[    0.121118] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.121350] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P_._PRT]
[    0.121418] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE2._PRT]
[    0.121457] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE6._PRT]
[    0.121490] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE7._PRT]
[    0.135555] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.135605] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.135654] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.135703] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.135752] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.135802] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.135851] ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.135900] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.135923] HEST: Table is not found!
[    0.136088] SCSI subsystem initialized
[    0.136097] libata version 3.00 loaded.
[    0.136097] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.136097] vgaarb: loaded
[    0.136101] usbcore: registered new interface driver usbfs
[    0.136113] usbcore: registered new interface driver hub
[    0.136121] usbcore: registered new device driver usb
[    0.136121] PCI: Using ACPI for IRQ routing
[    0.136121] PCI: pci_cache_line_size set to 64 bytes
[    0.136121] pci 0000:00:00.0: address space collision: [mem 0xe0000000-0xffffffff 64bit] conflicts with PCI Bus 0000:01 [mem 0xfb000000-0xfcffffff]
[    0.136121] reserve RAM buffer: 000000000009f400 - 000000000009ffff 
[    0.136121] reserve RAM buffer: 00000000affe0000 - 00000000afffffff 
[    0.136213] NetLabel: Initializing
[    0.136214] NetLabel:  domain hash size = 128
[    0.136215] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.136225] NetLabel:  unlabeled traffic allowed by default
[    0.136235] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.136239] hpet0: 4 comparators, 32-bit 14.318180 MHz counter
[    0.138023] Switching to clocksource hpet
[    0.139053] AppArmor: AppArmor Filesystem Enabled
[    0.139059] pnp: PnP ACPI init
[    0.139073] ACPI: bus type pnp registered
[    0.139181] pnp 00:00: [bus 00-ff]
[    0.139183] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.139185] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.139186] pnp 00:00: [io  0x0d00-0xffff window]
[    0.139188] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.139190] pnp 00:00: [mem 0x000c0000-0x000dffff window]
[    0.139192] pnp 00:00: [mem 0xafff0000-0xffffffff window]
[    0.139241] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.139409] pnp 00:01: [io  0x4100-0x411f]
[    0.139411] pnp 00:01: [io  0x0228-0x022f]
[    0.139412] pnp 00:01: [io  0x040b]
[    0.139414] pnp 00:01: [io  0x04d6]
[    0.139415] pnp 00:01: [io  0x0c00-0x0c01]
[    0.139417] pnp 00:01: [io  0x0c14]
[    0.139419] pnp 00:01: [io  0x0c50-0x0c52]
[    0.139420] pnp 00:01: [io  0x0c6c-0x0c6d]
[    0.139422] pnp 00:01: [io  0x0c6f]
[    0.139424] pnp 00:01: [io  0x0cd0-0x0cd1]
[    0.139426] pnp 00:01: [io  0x0cd2-0x0cd3]
[    0.139428] pnp 00:01: [io  0x0cd4-0x0cdf]
[    0.139429] pnp 00:01: [io  0x4000-0x40fe]
[    0.139431] pnp 00:01: [io  0x4210-0x4217]
[    0.139432] pnp 00:01: [io  0x0b10-0x0b1f]
[    0.139434] pnp 00:01: [mem 0x00000000-0x00000fff window]
[    0.139436] pnp 00:01: [mem 0xfee00400-0xfee00fff window]
[    0.139441] pnp 00:01: disabling [mem 0x00000000-0x00000fff window] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
[    0.139465] pnp 00:01: disabling [mem 0x00000000-0x00000fff window disabled] because it overlaps 0000:01:00.0 BAR 6 [mem 0x00000000-0x0007ffff pref]
[    0.139469] pnp 00:01: disabling [mem 0x00000000-0x00000fff window disabled] because it overlaps 0000:02:00.0 BAR 6 [mem 0x00000000-0x0000ffff pref]
[    0.139476] pnp 00:01: disabling [mem 0x00000000-0x00000fff window disabled] because it overlaps 0000:03:00.0 BAR 6 [mem 0x00000000-0x0001ffff pref]
[    0.139503] pnp 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.139620] pnp 00:02: [dma 4]
[    0.139621] pnp 00:02: [io  0x0000-0x000f]
[    0.139623] pnp 00:02: [io  0x0080-0x0090]
[    0.139624] pnp 00:02: [io  0x0094-0x009f]
[    0.139626] pnp 00:02: [io  0x00c0-0x00df]
[    0.139652] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.139704] pnp 00:03: [irq 0 disabled]
[    0.139716] pnp 00:03: [irq 8]
[    0.139718] pnp 00:03: [mem 0xfed00000-0xfed003ff]
[    0.139747] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.139776] pnp 00:04: [io  0x0070-0x0073]
[    0.139804] pnp 00:04: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.139812] pnp 00:05: [io  0x0061]
[    0.139838] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.139846] pnp 00:06: [io  0x00f0-0x00ff]
[    0.139854] pnp 00:06: [irq 13]
[    0.139885] pnp 00:06: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.139942] pnp 00:07: [io  0x0010-0x001f]
[    0.139944] pnp 00:07: [io  0x0022-0x003f]
[    0.139946] pnp 00:07: [io  0x0044-0x005f]
[    0.139947] pnp 00:07: [io  0x0062-0x0063]
[    0.139949] pnp 00:07: [io  0x0065-0x006f]
[    0.139950] pnp 00:07: [io  0x0074-0x007f]
[    0.139952] pnp 00:07: [io  0x0091-0x0093]
[    0.139953] pnp 00:07: [io  0x00a2-0x00bf]
[    0.139955] pnp 00:07: [io  0x00e0-0x00ef]
[    0.139956] pnp 00:07: [io  0x04d0-0x04d1]
[    0.139958] pnp 00:07: [io  0x0220-0x0225]
[    0.140026] pnp 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.140209] pnp 00:08: [io  0x03f0-0x03f5]
[    0.140210] pnp 00:08: [io  0x03f7]
[    0.140218] pnp 00:08: [irq 6]
[    0.140220] pnp 00:08: [dma 2]
[    0.140262] pnp 00:08: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.140513] pnp 00:09: [io  0x03f8-0x03ff]
[    0.140521] pnp 00:09: [irq 4]
[    0.140571] pnp 00:09: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.140846] pnp 00:0a: [io  0x0378-0x037f]
[    0.140853] pnp 00:0a: [irq 7]
[    0.140899] pnp 00:0a: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.141127] pnp 00:0b: [mem 0x000f0000-0x000fffff]
[    0.141130] pnp 00:0b: [mem 0x00000000-0x001fffff]
[    0.141132] pnp 00:0b: [mem 0xfed00000-0xfed000ff]
[    0.141134] pnp 00:0b: [mem 0xaffe0000-0xafffffff]
[    0.141136] pnp 00:0b: [mem 0xffff0000-0xffffffff]
[    0.141137] pnp 00:0b: [mem 0x00000000-0x0009ffff]
[    0.141139] pnp 00:0b: [mem 0x00100000-0xaffdffff]
[    0.141141] pnp 00:0b: [mem 0xfec00000-0xfec00fff]
[    0.141142] pnp 00:0b: [mem 0xfee00000-0xfee00fff]
[    0.141144] pnp 00:0b: [mem 0xfff80000-0xfffeffff]
[    0.141148] pnp 00:0b: disabling [mem 0x000f0000-0x000fffff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
[    0.141151] pnp 00:0b: disabling [mem 0x00000000-0x001fffff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
[    0.141154] pnp 00:0b: disabling [mem 0x00000000-0x0009ffff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
[    0.141156] pnp 00:0b: disabling [mem 0x00100000-0xaffdffff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
[    0.141209] pnp 00:0b: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.141217] pnp: PnP ACPI: found 12 devices
[    0.141218] ACPI: ACPI bus type pnp unregistered
[    0.141226] system 00:01: [io  0x4100-0x411f] has been reserved
[    0.141229] system 00:01: [io  0x0228-0x022f] has been reserved
[    0.141231] system 00:01: [io  0x040b] has been reserved
[    0.141233] system 00:01: [io  0x04d6] has been reserved
[    0.141235] system 00:01: [io  0x0c00-0x0c01] has been reserved
[    0.141238] system 00:01: [io  0x0c14] has been reserved
[    0.141240] system 00:01: [io  0x0c50-0x0c52] has been reserved
[    0.141242] system 00:01: [io  0x0c6c-0x0c6d] has been reserved
[    0.141244] system 00:01: [io  0x0c6f] has been reserved
[    0.141246] system 00:01: [io  0x0cd0-0x0cd1] has been reserved
[    0.141249] system 00:01: [io  0x0cd2-0x0cd3] has been reserved
[    0.141251] system 00:01: [io  0x0cd4-0x0cdf] has been reserved
[    0.141253] system 00:01: [io  0x4000-0x40fe] has been reserved
[    0.141256] system 00:01: [io  0x4210-0x4217] has been reserved
[    0.141258] system 00:01: [io  0x0b10-0x0b1f] has been reserved
[    0.141261] system 00:01: [mem 0xfee00400-0xfee00fff window] has been reserved
[    0.141266] system 00:07: [io  0x04d0-0x04d1] has been reserved
[    0.141268] system 00:07: [io  0x0220-0x0225] has been reserved
[    0.141273] system 00:0b: [mem 0xfed00000-0xfed000ff] has been reserved
[    0.141276] system 00:0b: [mem 0xaffe0000-0xafffffff] could not be reserved
[    0.141278] system 00:0b: [mem 0xffff0000-0xffffffff] has been reserved
[    0.141281] system 00:0b: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.141284] system 00:0b: [mem 0xfee00000-0xfee00fff] could not be reserved
[    0.141286] system 00:0b: [mem 0xfff80000-0xfffeffff] has been reserved
[    0.177583] pci 0000:01:00.0: BAR 6: assigned [mem 0xc0000000-0xc007ffff pref]
[    0.177586] pci 0000:00:02.0: PCI bridge to [bus 01-01]
[    0.177588] pci 0000:00:02.0:   bridge window [io  0xc000-0xcfff]
[    0.177591] pci 0000:00:02.0:   bridge window [mem 0xfb000000-0xfcffffff]
[    0.177594] pci 0000:00:02.0:   bridge window [mem 0xb0000000-0xcfffffff 64bit pref]
[    0.177598] pci 0000:02:00.0: BAR 6: assigned [mem 0xfde00000-0xfde0ffff pref]
[    0.177600] pci 0000:00:06.0: PCI bridge to [bus 02-02]
[    0.177602] pci 0000:00:06.0:   bridge window [io  0xe000-0xefff]
[    0.177605] pci 0000:00:06.0:   bridge window [mem 0xfdf00000-0xfdffffff]
[    0.177608] pci 0000:00:06.0:   bridge window [mem 0xfde00000-0xfdefffff 64bit pref]
[    0.177612] pci 0000:03:00.0: BAR 6: assigned [mem 0xfdc00000-0xfdc1ffff pref]
[    0.177613] pci 0000:00:07.0: PCI bridge to [bus 03-03]
[    0.177615] pci 0000:00:07.0:   bridge window [io  0xd000-0xdfff]
[    0.177618] pci 0000:00:07.0:   bridge window [mem 0xfdd00000-0xfddfffff]
[    0.177621] pci 0000:00:07.0:   bridge window [mem 0xfdc00000-0xfdcfffff 64bit pref]
[    0.177624] pci 0000:00:14.4: PCI bridge to [bus 04-04]
[    0.177627] pci 0000:00:14.4:   bridge window [io  0xb000-0xbfff]
[    0.177632] pci 0000:00:14.4:   bridge window [mem 0xfdb00000-0xfdbfffff]
[    0.177636] pci 0000:00:14.4:   bridge window [mem 0xfda00000-0xfdafffff pref]
[    0.177656] pci 0000:00:02.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.177659] pci 0000:00:02.0: setting latency timer to 64
[    0.177662] pci 0000:00:06.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.177665] pci 0000:00:06.0: setting latency timer to 64
[    0.177674] pci 0000:00:07.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    0.177676] pci 0000:00:07.0: setting latency timer to 64
[    0.177683] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.177685] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.177686] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.177688] pci_bus 0000:00: resource 7 [mem 0x000c0000-0x000dffff]
[    0.177690] pci_bus 0000:00: resource 8 [mem 0xafff0000-0xffffffff]
[    0.177692] pci_bus 0000:01: resource 0 [io  0xc000-0xcfff]
[    0.177694] pci_bus 0000:01: resource 1 [mem 0xfb000000-0xfcffffff]
[    0.177696] pci_bus 0000:01: resource 2 [mem 0xb0000000-0xcfffffff 64bit pref]
[    0.177698] pci_bus 0000:02: resource 0 [io  0xe000-0xefff]
[    0.177699] pci_bus 0000:02: resource 1 [mem 0xfdf00000-0xfdffffff]
[    0.177701] pci_bus 0000:02: resource 2 [mem 0xfde00000-0xfdefffff 64bit pref]
[    0.177703] pci_bus 0000:03: resource 0 [io  0xd000-0xdfff]
[    0.177705] pci_bus 0000:03: resource 1 [mem 0xfdd00000-0xfddfffff]
[    0.177707] pci_bus 0000:03: resource 2 [mem 0xfdc00000-0xfdcfffff 64bit pref]
[    0.177709] pci_bus 0000:04: resource 0 [io  0xb000-0xbfff]
[    0.177711] pci_bus 0000:04: resource 1 [mem 0xfdb00000-0xfdbfffff]
[    0.177712] pci_bus 0000:04: resource 2 [mem 0xfda00000-0xfdafffff pref]
[    0.177714] pci_bus 0000:04: resource 4 [io  0x0000-0x0cf7]
[    0.177716] pci_bus 0000:04: resource 5 [io  0x0d00-0xffff]
[    0.177718] pci_bus 0000:04: resource 6 [mem 0x000a0000-0x000bffff]
[    0.177720] pci_bus 0000:04: resource 7 [mem 0x000c0000-0x000dffff]
[    0.177721] pci_bus 0000:04: resource 8 [mem 0xafff0000-0xffffffff]
[    0.177777] NET: Registered protocol family 2
[    0.177840] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.178085] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.178511] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.178740] TCP: Hash tables configured (established 131072 bind 65536)
[    0.178742] TCP reno registered
[    0.178745] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    0.178753] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    0.178859] NET: Registered protocol family 1
[    0.264056] pci 0000:01:00.0: Boot video device
[    0.264073] PCI: CLS 32 bytes, default 64
[    0.264113] Unpacking initramfs...
[    0.439773] Freeing initrd memory: 10632k freed
[    0.444972] audit: initializing netlink socket (disabled)
[    0.444983] type=2000 audit(1350128346.443:1): initialized
[    0.453432] highmem bounce pool size: 64 pages
[    0.453436] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.453689] VFS: Disk quotas dquot_6.5.2
[    0.453720] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.453874] msgmni has been set to 400
[    0.454121] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.454153] io scheduler noop registered
[    0.454155] io scheduler deadline registered
[    0.454178] io scheduler cfq registered (default)
[    0.454902] vesafb: framebuffer at 0xcf000000, mapped to 0xf7a80000, using 5120k, total 14336k
[    0.454904] vesafb: mode is 1280x1024x16, linelength=2560, pages=1
[    0.454905] vesafb: protected mode interface info at c000:c600
[    0.454907] vesafb: pmi: set display start = c00cc663, set palette = c00cc6be
[    0.454908] vesafb: pmi: ports = 3b4 3b5 3ba 3c0 3c1 3c4 3c5 3c6 3c7 3c8 3c9 3cc 3ce 3cf 3d0 3d1 3d2 3d3 3d4 3d5 3da 
[    0.454917] vesafb: scrolling: redraw
[    0.454919] vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
[    0.455290] bootsplash 3.1.6-2004/03/31: looking for picture...
[    0.455292] bootsplash: silentjpeg size 245922 bytes
[    0.477208] bootsplash: ...found (1280x1024, 255920 bytes, v3).
[    0.534335] Console: switching to colour frame buffer device 156x60
[    0.590753] fb0: VESA VGA frame buffer device
[    0.590796] ERST: Table is not found!
[    0.591056] Non-volatile memory driver v1.3
[    0.591058] Linux agpgart interface v0.103
[    0.592317] Serial: 8250/16550 driver, 8 ports, IRQ sharing disabled
[    0.612974] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.748738] 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.764148] ahci 0000:00:12.0: version 3.0
[    0.764167] ahci 0000:00:12.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    0.764191] ahci 0000:00:12.0: controller can't do 64bit DMA, forcing 32bit
[    0.764334] ahci 0000:00:12.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
[    0.764337] ahci 0000:00:12.0: flags: ncq sntf ilck led clo pmp pio ccc 
[    0.765016] scsi0 : ahci
[    0.765116] scsi1 : ahci
[    0.765181] scsi2 : ahci
[    0.765246] scsi3 : ahci
[    0.765358] ata1: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f100 irq 22
[    0.765361] ata2: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f180 irq 22
[    0.765364] ata3: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f200 irq 22
[    0.765367] ata4: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f280 irq 22
[    0.766033] ahci 0000:02:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.777035] ahci 0000:02:00.0: AHCI 0001.0000 32 slots 2 ports 3 Gbps 0x3 impl SATA mode
[    0.777037] ahci 0000:02:00.0: flags: 64bit ncq pm led clo pmp pio slum part 
[    0.777042] ahci 0000:02:00.0: setting latency timer to 64
[    0.777401] scsi4 : ahci
[    0.777461] scsi5 : ahci
[    0.777498] ata5: SATA max UDMA/133 abar m8192@0xfdffe000 port 0xfdffe100 irq 18
[    0.777501] ata6: SATA max UDMA/133 abar m8192@0xfdffe000 port 0xfdffe180 irq 18
[    0.777574] Fixed MDIO Bus: probed
[    0.777578] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.778033] ehci_hcd 0000:00:13.5: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    0.778042] ehci_hcd 0000:00:13.5: EHCI Host Controller
[    0.778062] ehci_hcd 0000:00:13.5: new USB bus registered, assigned bus number 1
[    0.786033] ehci_hcd 0000:00:13.5: applying AMD SB600/SB700 USB freeze workaround
[    0.786046] ehci_hcd 0000:00:13.5: debug port 1
[    0.786071] ehci_hcd 0000:00:13.5: irq 19, io mem 0xfe029000
[    0.792014] ehci_hcd 0000:00:13.5: USB 2.0 started, EHCI 1.00
[    0.792030] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    0.792032] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.792034] usb usb1: Product: EHCI Host Controller
[    0.792035] usb usb1: Manufacturer: Linux 2.6.37.6-0.20-desktop ehci_hcd
[    0.792037] usb usb1: SerialNumber: 0000:00:13.5
[    0.792128] hub 1-0:1.0: USB hub found
[    0.792131] hub 1-0:1.0: 10 ports detected
[    0.792227] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.792286] ohci_hcd 0000:00:13.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.792294] ohci_hcd 0000:00:13.0: OHCI Host Controller
[    0.792300] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 2
[    0.798037] ohci_hcd 0000:00:13.0: irq 16, io mem 0xfe02e000
[    0.853047] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    0.853049] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.853051] usb usb2: Product: OHCI Host Controller
[    0.853052] usb usb2: Manufacturer: Linux 2.6.37.6-0.20-desktop ohci_hcd
[    0.853054] usb usb2: SerialNumber: 0000:00:13.0
[    0.853122] hub 2-0:1.0: USB hub found
[    0.853128] hub 2-0:1.0: 2 ports detected
[    0.853232] ohci_hcd 0000:00:13.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.853240] ohci_hcd 0000:00:13.1: OHCI Host Controller
[    0.853246] ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 3
[    0.861035] ohci_hcd 0000:00:13.1: irq 17, io mem 0xfe02d000
[    0.916042] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    0.916044] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.916045] usb usb3: Product: OHCI Host Controller
[    0.916047] usb usb3: Manufacturer: Linux 2.6.37.6-0.20-desktop ohci_hcd
[    0.916048] usb usb3: SerialNumber: 0000:00:13.1
[    0.916113] hub 3-0:1.0: USB hub found
[    0.916119] hub 3-0:1.0: 2 ports detected
[    0.916214] ohci_hcd 0000:00:13.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.916223] ohci_hcd 0000:00:13.2: OHCI Host Controller
[    0.916228] ohci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 4
[    0.924021] ohci_hcd 0000:00:13.2: irq 18, io mem 0xfe02c000
[    0.979034] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    0.979036] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.979038] usb usb4: Product: OHCI Host Controller
[    0.979039] usb usb4: Manufacturer: Linux 2.6.37.6-0.20-desktop ohci_hcd
[    0.979041] usb usb4: SerialNumber: 0000:00:13.2
[    0.979109] hub 4-0:1.0: USB hub found
[    0.979114] hub 4-0:1.0: 2 ports detected
[    0.979207] ohci_hcd 0000:00:13.3: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.979215] ohci_hcd 0000:00:13.3: OHCI Host Controller
[    0.979221] ohci_hcd 0000:00:13.3: new USB bus registered, assigned bus number 5
[    0.987022] ohci_hcd 0000:00:13.3: irq 17, io mem 0xfe02b000
[    1.042040] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    1.042041] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.042043] usb usb5: Product: OHCI Host Controller
[    1.042045] usb usb5: Manufacturer: Linux 2.6.37.6-0.20-desktop ohci_hcd
[    1.042046] usb usb5: SerialNumber: 0000:00:13.3
[    1.042115] hub 5-0:1.0: USB hub found
[    1.042120] hub 5-0:1.0: 2 ports detected
[    1.042214] ohci_hcd 0000:00:13.4: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    1.042223] ohci_hcd 0000:00:13.4: OHCI Host Controller
[    1.042229] ohci_hcd 0000:00:13.4: new USB bus registered, assigned bus number 6
[    1.051021] ohci_hcd 0000:00:13.4: irq 18, io mem 0xfe02a000
[    1.070061] ata4: SATA link down (SStatus 0 SControl 300)
[    1.070097] ata2: SATA link down (SStatus 0 SControl 300)
[    1.070130] ata3: SATA link down (SStatus 0 SControl 300)
[    1.082034] ata5: SATA link down (SStatus 0 SControl 300)
[    1.082068] ata6: SATA link down (SStatus 0 SControl 300)
[    1.106045] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    1.106047] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.106048] usb usb6: Product: OHCI Host Controller
[    1.106050] usb usb6: Manufacturer: Linux 2.6.37.6-0.20-desktop ohci_hcd
[    1.106052] usb usb6: SerialNumber: 0000:00:13.4
[    1.106116] hub 6-0:1.0: USB hub found
[    1.106121] hub 6-0:1.0: 2 ports detected
[    1.106190] uhci_hcd: USB Universal Host Controller Interface driver
[    1.106218] Initializing USB Mass Storage driver...
[    1.106244] usbcore: registered new interface driver usb-storage
[    1.106245] USB Mass Storage support registered.
[    1.106254] usbcore: registered new interface driver ums-alauda
[    1.106263] usbcore: registered new interface driver ums-cypress
[    1.106272] usbcore: registered new interface driver ums-datafab
[    1.106281] usbcore: registered new interface driver ums-freecom
[    1.106290] usbcore: registered new interface driver ums-isd200
[    1.106298] usbcore: registered new interface driver ums-jumpshot
[    1.106307] usbcore: registered new interface driver ums-karma
[    1.106316] usbcore: registered new interface driver ums-onetouch
[    1.106325] usbcore: registered new interface driver ums-sddr09
[    1.106335] usbcore: registered new interface driver ums-sddr55
[    1.106344] usbcore: registered new interface driver ums-usbat
[    1.106380] PNP: No PS/2 controller found. Probing ports directly.
[    1.106785] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.106790] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.106859] mice: PS/2 mouse device common for all mice
[    1.106935] rtc_cmos 00:04: RTC can wake from S4
[    1.109052] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
[    1.109087] rtc0: alarms up to one month, 242 bytes nvram, hpet irqs
[    1.109095] cpuidle: using governor ladder
[    1.109096] cpuidle: using governor menu
[    1.109348] usbcore: registered new interface driver usbhid
[    1.109350] usbhid: USB HID core driver
[    1.109528] TCP cubic registered
[    1.109596] NET: Registered protocol family 10
[    1.109859] lo: Disabled Privacy Extensions
[    1.110017] lib80211: common routines for IEEE802.11 drivers
[    1.110018] lib80211_crypt: registered algorithm 'NULL'
[    1.110020] Registering the dns_resolver key type
[    1.110068] libceph: loaded (mon/osd proto 15/24, osdmap 5/5 5/5)
[    1.110076] Using IPI No-Shortcut mode
[    1.110147] PM: Checking hibernation image partition /dev/disk/by-id/ata-ST3250318AS_6VY3CK0B-part2
[    1.225022] ata1: softreset failed (device not ready)
[    1.225028] ata1: applying SB600 PMP SRST workaround and retrying
[    1.380031] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.381035] ata1.00: ATA-8: ST3250318AS, CC37, max UDMA/133
[    1.381037] ata1.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    1.381040] ata1.00: SB600 AHCI: limiting to 255 sectors per cmd
[    1.382215] ata1.00: SB600 AHCI: limiting to 255 sectors per cmd
[    1.382217] ata1.00: configured for UDMA/133
[    1.382347] scsi 0:0:0:0: Direct-Access     ATA      ST3250318AS      CC37 PQ: 0 ANSI: 5
[    1.382462] sd 0:0:0:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 GiB)
[    1.382557] sd 0:0:0:0: [sda] Write Protect is off
[    1.382559] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.382592] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.443209]  sda: sda1 sda2 sda3 < sda5 sda6 sda7 >
[    1.443530] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.443538] PM: Hibernation image not present or could not be loaded.
[    1.443547] registered taskstats version 1
[    1.443767]   Magic number: 0:300:681
[    1.443842] rtc_cmos 00:04: setting system clock to 2012-10-13 11:39:07 UTC (1350128347)
[    1.443910] Freeing unused kernel memory: 452k freed
[    1.444107] Write protecting the kernel text: 4708k
[    1.444167] Write protecting the kernel read-only data: 3188k
[    1.489991] pata_atiixp 0000:00:14.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.490320] scsi6 : pata_atiixp
[    1.490379] scsi7 : pata_atiixp
[    1.491065] ata7: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xf900 irq 14
[    1.491067] ata8: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xf908 irq 15
[    1.535028] usb 6-1: new full speed USB device using ohci_hcd and address 2
[    1.645499] ata7.00: ATAPI: TSSTcorpCD/DVDW TS-H552B, TS12, max UDMA/33
[    1.651434] ata7.00: configured for UDMA/33
[    1.652283] scsi 6:0:0:0: CD-ROM            TSSTcorp CD/DVDW TS-H552B TS12 PQ: 0 ANSI: 5
[    1.655408] pata_jmicron 0000:02:00.1: enabling device (0000 -> 0001)
[    1.655416] pata_jmicron 0000:02:00.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    1.655446] pata_jmicron 0000:02:00.1: setting latency timer to 64
[    1.655710] scsi8 : pata_jmicron
[    1.655770] scsi9 : pata_jmicron
[    1.655802] ata9: PATA max UDMA/100 cmd 0xef00 ctl 0xee00 bmdma 0xeb00 irq 19
[    1.655804] ata10: PATA max UDMA/100 cmd 0xed00 ctl 0xec00 bmdma 0xeb08 irq 19
[    1.688066] usb 6-1: New USB device found, idVendor=19ff, idProduct=0231
[    1.688069] usb 6-1: New USB device strings: Mfr=0, Product=2, SerialNumber=0
[    1.688071] usb 6-1: Product: Dynex wireless combo
[    1.698060] input: Dynex wireless combo as /devices/pci0000:00/0000:00:13.4/usb6/6-1/6-1:1.0/input/input0
[    1.698111] generic-usb 0003:19FF:0231.0001: input,hidraw0: USB HID v1.11 Keyboard [Dynex wireless combo] on usb-0000:00:13.4-1/input0
[    1.702705] input: Dynex wireless combo as /devices/pci0000:00/0000:00:13.4/usb6/6-1/6-1:1.1/input/input1
[    1.702771] generic-usb 0003:19FF:0231.0002: input,hidraw1: USB HID v1.11 Mouse [Dynex wireless combo] on usb-0000:00:13.4-1/input1
[    1.974663] ACPI Warning: For \_TZ_.THRM._PSL: Return Package type mismatch at index 0 - found [NULL Object Descriptor], expected Reference (20101013/nspredef-1059)
[    1.974670] ACPI: Expecting a [Reference] package element, found type 0
[    1.974678] ACPI: Invalid passive threshold
[    1.974818] thermal LNXTHERM:00: registered as thermal_zone0
[    1.974822] ACPI: Thermal Zone [THRM] (36 C)
[    1.980160] ACPI: acpi_idle registered with cpuidle
[    1.981891] ACPI: Fan [FAN] (on)
[    1.987547] BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
[    1.991689] udev[145]: starting version 166
[    3.119667] kjournald starting.  Commit interval 15 seconds
[    3.119899] EXT3-fs (sda5): using internal journal
[    3.119902] EXT3-fs (sda5): mounted filesystem with ordered data mode
[    4.759093] preloadtrace: systemtap: 1.4/0.149, base: f8197000, memory: 30data/39text/13ctx/13net/282alloc kb, probes: 34
[    5.498673] udev[417]: starting version 166
[    5.610941] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input2
[    5.610975] ACPI: Power Button [PWRB]
[    5.611045] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    5.611067] ACPI: Power Button [PWRF]
[    5.928026] k8temp 0000:00:18.3: Temperature readouts might be wrong - check erratum #141
[    5.964038] piix4_smbus 0000:00:14.0: SMBus Host Controller at 0xb00, revision 0
[    6.001275] input: PC Speaker as /devices/platform/pcspkr/input/input4
[    6.009937] IT8718 SuperIO detected.
[    6.010533] parport_pc 00:0a: reported by Plug and Play ACPI
[    6.010588] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
[    6.020835] sr0: scsi3-mmc drive: 48x/48x writer cd/rw xa/form2 cdda tray
[    6.020838] cdrom: Uniform CD-ROM driver Revision: 3.20
[    6.020922] sr 6:0:0:0: Attached scsi CD-ROM sr0
[    6.029250] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    6.029343] sr 6:0:0:0: Attached scsi generic sg1 type 5
[    6.034894] FDC 0 is a post-1991 82077
[    6.099368] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    6.140703] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    6.155733] ppdev: user-space parallel port driver
[    6.199506] sky2: driver version 1.28
[    6.200042] sky2 0000:03:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    6.200051] sky2 0000:03:00.0: setting latency timer to 64
[    6.200080] sky2 0000:03:00.0: Yukon-2 EC Ultra chip revision 5
[    6.200163] sky2 0000:03:00.0: irq 40 for MSI/MSI-X
[    6.200551] sky2 0000:03:00.0: eth0: addr 00:e0:4d:75:bc:d3
[    6.894260] nvidia: module license 'NVIDIA' taints kernel.
[    6.894264] Disabling lock debugging due to kernel taint
[    7.120908] HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    7.120912] ALSA hda_intel.c:2398: Using LPIB position fix
[    7.126107] ALSA hda_intel.c:1488: Enable sync_write for stable communication
[    7.217600] hda_codec: ALC888: BIOS auto-probing.
[    7.217604] ALSA patch_realtek.c:1522: SKU: Nid=0x0 sku_cfg=0x0000e601
[    7.217606] ALSA patch_realtek.c:1524: SKU: port_connectivity=0x0
[    7.217608] ALSA patch_realtek.c:1525: SKU: enable_pcbeep=0x1
[    7.217610] ALSA patch_realtek.c:1526: SKU: check_sum=0x00000000
[    7.217612] ALSA patch_realtek.c:1527: SKU: customization=0x00000000
[    7.217614] ALSA patch_realtek.c:1528: SKU: external_amp=0x0
[    7.217615] ALSA patch_realtek.c:1529: SKU: platform_type=0x0
[    7.217617] ALSA patch_realtek.c:1530: SKU: swap=0x0
[    7.217619] ALSA patch_realtek.c:1531: SKU: override=0x1
[    7.217622] ALSA hda_codec.c:4633: autoconfig: line_outs=4 (0x14/0x15/0x16/0x17/0x0)
[    7.217625] ALSA hda_codec.c:4637:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[    7.217627] ALSA hda_codec.c:4641:    hp_outs=1 (0x1b/0x0/0x0/0x0/0x0)
[    7.217629] ALSA hda_codec.c:4642:    mono: mono_out=0x0
[    7.217631] ALSA hda_codec.c:4645:    dig-out=0x1e/0x0
[    7.217633] ALSA hda_codec.c:4646:    inputs:
[    7.217634] ALSA hda_codec.c:4652: 
[    7.217636] ALSA hda_codec.c:4654:    dig-in=0x1f
[    7.219187] ALSA patch_realtek.c:1595: realtek: Enabling init ASM_ID=0xe601 CODEC_ID=10ec0888
[    7.224046] nvidia 0000:01:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    7.224055] nvidia 0000:01:00.0: setting latency timer to 64
[    7.224059] vgaarb: device changed decodes: PCI:0000:01:00.0,olddecodes=io+mem,decodes=none:owns=io+mem
[    7.224506] NVRM: loading NVIDIA UNIX x86 Kernel Module  304.43  Sun Aug 19 20:20:21 PDT 2012
[    7.227237] input: HDA ATI SB Headphone as /devices/pci0000:00/0000:00:14.2/sound/card0/input5
[    7.227395] HDA Intel 0000:01:00.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    7.227398] hda_intel: Disabling MSI
[    7.227414] HDA Intel 0000:01:00.1: setting latency timer to 64
[    7.234978] ALSA hda_intel.c:1450: Enable delay in RIRB handling
[    8.071660] Adding 4200992k swap on /dev/sda2.  Priority:-1 extents:1 across:4200992k 
[    8.743145] device-mapper: uevent: version 1.0.3
[    8.743262] device-mapper: ioctl: 4.18.0-ioctl (2010-06-29) initialised: dm-devel@redhat.com
[    9.498449] kjournald starting.  Commit interval 15 seconds
[    9.498745] EXT3-fs (sda7): using internal journal
[    9.498749] EXT3-fs (sda7): mounted filesystem with ordered data mode
[    9.524932] kjournald starting.  Commit interval 15 seconds
[    9.525465] EXT3-fs (sda1): using internal journal
[    9.525467] EXT3-fs (sda1): mounted filesystem with ordered data mode
[    9.537551] kjournald starting.  Commit interval 15 seconds
[    9.537756] EXT3-fs (sda6): using internal journal
[    9.537758] EXT3-fs (sda6): mounted filesystem with ordered data mode
[   11.616370] powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processor 6400+ (2 cpu cores) (version 2.20.00)
[   11.616418] powernow-k8:    0 : fid 0x18 (3200 MHz), vid 0x6
[   11.616419] powernow-k8:    1 : fid 0x16 (3000 MHz), vid 0x8
[   11.616421] powernow-k8:    2 : fid 0x14 (2800 MHz), vid 0xa
[   11.616422] powernow-k8:    3 : fid 0x12 (2600 MHz), vid 0xc
[   11.616424] powernow-k8:    4 : fid 0x10 (2400 MHz), vid 0xe
[   11.616425] powernow-k8:    5 : fid 0xe (2200 MHz), vid 0x10
[   11.616426] powernow-k8:    6 : fid 0xc (2000 MHz), vid 0x10
[   11.616427] powernow-k8:    7 : fid 0xa (1800 MHz), vid 0x10
[   11.616429] powernow-k8:    8 : fid 0x2 (1000 MHz), vid 0x12
[   12.004021] Clocksource tsc unstable (delta = -113198785 ns)
[   14.145924] sky2 0000:03:00.0: eth0: enabling interface
[   14.146115] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   18.723650] NVRM: GPU at 0000:01:00: GPU-530fdfac-1f26-a973-7c44-dd5dd2360f4f
[   18.723655] NVRM: Your system is not currently configured to drive a VGA console
[   18.723658] NVRM: on the primary VGA device. The NVIDIA Linux graphics driver
[   18.723660] NVRM: requires the use of a text-mode VGA console. Use of other console
[   18.723662] NVRM: drivers including, but not limited to, vesafb, may result in
[   18.723663] NVRM: corruption and stability problems, and is not supported.
[   36.755668] start_kdeinit (2217): /proc/2217/oom_adj is deprecated, please use /proc/2217/oom_score_adj instead.
[   42.740585] bootsplash: status on console 0 changed to on
[   84.998747] fuse init (API version 7.15)

--------------040200070506070205090009
Content-Type: text/plain; charset=UTF-8;
 name="dmesg.nouveau-hdmi"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg.nouveau-hdmi"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.37.6-0.20-desktop (geeko@buildhost) (gcc version 4.5.1 20101208 [gcc-4_5-branch revision 167585] (SUSE Linux) ) #1 SMP PREEMPT 2011-12-19 23:39:38 +0100
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
[    0.000000]  BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000affe0000 (usable)
[    0.000000]  BIOS-e820: 00000000affe0000 - 00000000affe3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000affe3000 - 00000000afff0000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000afff0000 - 00000000b0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000150000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.5 present.
[    0.000000] DMI: BIOSTAR Group A78XA-A2T/TA770 A2+, BIOS 6.00 PG 06/12/2008
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] last_pfn = 0x150000 max_arch_pfn = 0x1000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-C7FFF write-protect
[    0.000000]   C8000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-through
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask FF80000000 write-back
[    0.000000]   1 base 0080000000 mask FFE0000000 write-back
[    0.000000]   2 base 00A0000000 mask FFF0000000 write-back
[    0.000000]   3 base 0100000000 mask FFC0000000 write-back
[    0.000000]   4 base 0140000000 mask FFF0000000 write-back
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 0000000150000000 aka 5376M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000b0000000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] found SMP MP-table at [c00f3f00] f3f00
[    0.000000] initial memory mapped : 0 - 01000000
[    0.000000] init_memory_mapping: 0000000000000000-00000000371fe000
[    0.000000]  0000000000 - 0000200000 page 4k
[    0.000000]  0000200000 - 0037000000 page 2M
[    0.000000]  0037000000 - 00371fe000 page 4k
[    0.000000] kernel direct mapping tables up to 371fe000 @ ff6000-1000000
[    0.000000] RAMDISK: 3758e000 - 37ff0000
[    0.000000] Allocated new RAMDISK: 3679c000 - 371fdffa
[    0.000000] Move RAMDISK from 000000003758e000 - 0000000037fefff9 to 3679c000 - 371fdff9
[    0.000000] ACPI: RSDP 000f7fb0 00024 (v02 RX780 )
[    0.000000] ACPI: RSDT affe3000 00038 (v01 RX780  AWRDACPI 42302E31 AWRD 00000000)
[    0.000000] ACPI: FACP affe3080 00074 (v01 RX780  AWRDACPI 42302E31 AWRD 00000000)
[    0.000000] ACPI: DSDT affe3100 05A71 (v01 RX780  AWRDACPI 00001000 MSFT 0100000E)
[    0.000000] ACPI: FACS affe0000 00040
[    0.000000] ACPI: SSDT affe8c40 00350 (v01 PTLTD  POWERNOW 00000001  LTP 00000001)
[    0.000000] ACPI: HPET affe8fc0 00038 (v01 RX780  AWRDACPI 42302E31 AWRD 00000098)
[    0.000000] ACPI: MCFG affe9000 0003C (v01 RX780  AWRDACPI 42302E31 AWRD 00000000)
[    0.000000] ACPI: APIC affe8b80 00084 (v01 RX780  AWRDACPI 42302E31 AWRD 00000000)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] could not find any ACPI SRAT memory areas.
[    0.000000] failed to get NUMA memory information from SRAT table
[    0.000000] NUMA - single node, flat memory mode
[    0.000000] Node: 0, start_pfn: 0, end_pfn: 150000
[    0.000000]   Setting physnode_map array to node 0 for pfns:
[    0.000000]   0 4000 8000 c000 10000 14000 18000 1c000 20000 24000 28000 2c000 30000 34000 38000 3c000 40000 44000 48000 4c000 50000 54000 58000 5c000 60000 64000 68000 6c000 70000 74000 78000 7c000 80000 84000 88000 8c000 90000 94000 98000 9c000 a0000 a4000 a8000 ac000 b0000 b4000 b8000 bc000 c0000 c4000 c8000 cc000 d0000 d4000 d8000 dc000 e0000 e4000 e8000 ec000 f0000 f4000 f8000 fc000 100000 104000 108000 10c000 110000 114000 118000 11c000 120000 124000 128000 12c000 130000 134000 138000 13c000 140000 144000 148000 14c000 
[    0.000000] node 0 pfn: [0 - 150000]
[    0.000000] Reserving 11264 pages of KVA for lmem_map of node 0 at 14d400
[    0.000000] Reserving total of 2c00 pages for numa KVA remap
[    0.000000] kva_start_pfn ~ 33a00 max_low_pfn ~ 371fe
[    0.000000] max_pfn = 150000
[    0.000000] 4494MB HIGHMEM available.
[    0.000000] 881MB LOWMEM available.
[    0.000000] max_low_pfn = 371fe, highstart_pfn = 371fe
[    0.000000] Low memory ends at vaddr f71fe000
[    0.000000] node 0 will remap to vaddr f3a00000 - f6600000
[    0.000000] allocate_pgdat: node 0 NODE_DATA f3a00000
[    0.000000] remap_numa_kva: node 0
[    0.000000] remap_numa_kva: f3a00000 to pfn 0014d400
[    0.000000] remap_numa_kva: f3c00000 to pfn 0014d600
[    0.000000] remap_numa_kva: f3e00000 to pfn 0014d800
[    0.000000] remap_numa_kva: f4000000 to pfn 0014da00
[    0.000000] remap_numa_kva: f4200000 to pfn 0014dc00
[    0.000000] remap_numa_kva: f4400000 to pfn 0014de00
[    0.000000] remap_numa_kva: f4600000 to pfn 0014e000
[    0.000000] remap_numa_kva: f4800000 to pfn 0014e200
[    0.000000] remap_numa_kva: f4a00000 to pfn 0014e400
[    0.000000] remap_numa_kva: f4c00000 to pfn 0014e600
[    0.000000] remap_numa_kva: f4e00000 to pfn 0014e800
[    0.000000] remap_numa_kva: f5000000 to pfn 0014ea00
[    0.000000] remap_numa_kva: f5200000 to pfn 0014ec00
[    0.000000] remap_numa_kva: f5400000 to pfn 0014ee00
[    0.000000] remap_numa_kva: f5600000 to pfn 0014f000
[    0.000000] remap_numa_kva: f5800000 to pfn 0014f200
[    0.000000] remap_numa_kva: f5a00000 to pfn 0014f400
[    0.000000] remap_numa_kva: f5c00000 to pfn 0014f600
[    0.000000] remap_numa_kva: f5e00000 to pfn 0014f800
[    0.000000] remap_numa_kva: f6000000 to pfn 0014fa00
[    0.000000] remap_numa_kva: f6200000 to pfn 0014fc00
[    0.000000] remap_numa_kva: f6400000 to pfn 0014fe00
[    0.000000] High memory starts at vaddr f71fe000
[    0.000000]   mapped low ram: 0 - 371fe000
[    0.000000]   low ram: 0 - 371fe000
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000371fe
[    0.000000]   HighMem  0x000371fe -> 0x00150000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000affe0
[    0.000000]     0: 0x00100000 -> 0x00150000
[    0.000000] On node 0 totalpages: 1048431
[    0.000000] free_area_init_node: node 0, pgdat f3a00000, node_mem_map f3a02200
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3951 pages, LIFO batch:0
[    0.000000]   Normal zone: 1732 pages used for memmap
[    0.000000]   Normal zone: 219962 pages, LIFO batch:31
[    0.000000]   HighMem zone: 8989 pages used for memmap
[    0.000000]   HighMem zone: 813765 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] Detected use of extended apic ids on hypertransport bus
[    0.000000] ACPI: PM-Timer IO Port: 0x4008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 33, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x10b9a201 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 2 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at b0000000 (gap: b0000000:30000000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:128 nr_cpumask_bits:128 nr_cpu_ids:4 nr_node_ids:8
[    0.000000] PERCPU: Embedded 12 pages/cpu @f3800000 s28160 r0 d20992 u524288
[    0.000000] pcpu-alloc: s28160 r0 d20992 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1037678
[    0.000000] Policy zone: HighMem
[    0.000000] Kernel command line: root=/dev/sda5 resume=/dev/disk/by-id/ata-ST3250318AS_6VY3CK0B-part2 splash=silent quiet vga=0x31a nomodeset
[    0.000000] bootsplash: silent mode.
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] allocated 27524800 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] Initializing HighMem for node 0 (000371fe:00150000)
[    0.000000] Memory: 4055300k/5505024k available (4704k kernel code, 93368k reserved, 3493k data, 452k init, 3245960k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xff5b4000 - 0xfffff000   (10540 kB)
[    0.000000]     pkmap   : 0xff200000 - 0xff400000   (2048 kB)
[    0.000000]     vmalloc : 0xf79fe000 - 0xff1fe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf71fe000   ( 881 MB)
[    0.000000]       .init : 0xc0a02000 - 0xc0a73000   ( 452 kB)
[    0.000000]       .data : 0xc06980ad - 0xc0a01708   (3493 kB)
[    0.000000]       .text : 0xc0200000 - 0xc06980ad   (4704 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] Preemptable hierarchical RCU implementation.
[    0.000000] 	RCU-based detection of stalled CPUs is disabled.
[    0.000000] 	Verbose stalled-CPUs detection is disabled.
[    0.000000] NR_IRQS:8448 nr_irqs:712 16
[    0.000000] CPU 0 irqstacks, hard=f180c000 soft=f180e000
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration failed
[    0.000000] TSC: Unable to calibrate against PIT
[    0.000000] TSC: using HPET reference calibration
[    0.000000] Detected 3200.220 MHz processor.
[    0.004005] Calibrating delay loop (skipped), value calculated using timer frequency.. 6400.44 BogoMIPS (lpj=3200220)
[    0.004008] pid_max: default: 32768 minimum: 301
[    0.004059] Security Framework initialized
[    0.004068] AppArmor: AppArmor initialized
[    0.004108] Mount-cache hash table entries: 512
[    0.004189] Initializing cgroup subsys ns
[    0.004191] ns_cgroup deprecated: consider using the 'clone_children' flag without the ns_cgroup.
[    0.004193] Initializing cgroup subsys cpuacct
[    0.004195] Initializing cgroup subsys memory
[    0.004203] Initializing cgroup subsys devices
[    0.004205] Initializing cgroup subsys freezer
[    0.004206] Initializing cgroup subsys net_cls
[    0.004207] Initializing cgroup subsys blkio
[    0.004230] CPU: Physical Processor ID: 0
[    0.004231] CPU: Processor Core ID: 0
[    0.004232] mce: CPU supports 5 MCE banks
[    0.004239] using C1E aware idle routine
[    0.004243] Performance Events: AMD PMU driver.
[    0.004246] ... version:                0
[    0.004247] ... bit width:              48
[    0.004248] ... generic registers:      4
[    0.004249] ... value mask:             0000ffffffffffff
[    0.004251] ... max period:             00007fffffffffff
[    0.004252] ... fixed-purpose events:   0
[    0.004253] ... event mask:             000000000000000f
[    0.004479] ACPI: Core revision 20101013
[    0.012071] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.012372] Mapping cpu 0 to node 0
[    0.012591] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.023101] CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 6400+ stepping 03
[    0.026011] NMI watchdog enabled, takes one hw-pmu counter.
[    0.030012] CPU 1 irqstacks, hard=f18a0000 soft=f18a2000
[    0.030016] Booting Node   0, Processors  #1
[    0.004999] Initializing CPU#1
[    0.004999] Mapping cpu 1 to node 0
[    0.101085] NMI watchdog enabled, takes one hw-pmu counter.
[    0.102003] Brought up 2 CPUs
[    0.102005] Total of 2 processors activated (12800.52 BogoMIPS).
[    0.102236] devtmpfs: initialized
[    0.102236] regulator: core version 0.5
[    0.102236] regulator: dummy: 
[    0.102236] Time: 16:11:53  Date: 10/13/12
[    0.102236] NET: Registered protocol family 16
[    0.102323] node 0 link 0: io port [b000, ffff]
[    0.102326] TOM: 00000000b0000000 aka 2816M
[    0.102328] node 0 link 0: mmio [a0000, bffff]
[    0.102330] node 0 link 0: mmio [b0000000, dfffffff]
[    0.102332] node 0 link 0: mmio [f0000000, fe02ffff]
[    0.102334] node 0 link 0: mmio [e0000000, e04fffff]
[    0.102336] TOM2: 0000000150000000 aka 5376M
[    0.102337] bus: [00, 04] on node 0 link 0
[    0.102339] bus: 00 index 0 [io  0x0000-0xffff]
[    0.102341] bus: 00 index 1 [mem 0x000a0000-0x000bffff]
[    0.102342] bus: 00 index 2 [mem 0xb0000000-0xefffffff]
[    0.102344] bus: 00 index 3 [mem 0xf0000000-0xffffffff]
[    0.102345] bus: 00 index 4 [mem 0x150000000-0xfcffffffff]
[    0.102409] ACPI: bus type pci registered
[    0.102469] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.102472] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.102473] PCI: Using MMCONFIG for extended config space
[    0.102474] PCI: Using configuration type 1 for base access
[    0.103611] bio: create slab <bio-0> at 0
[    0.104597] ACPI: EC: Look up EC in DSDT
[    0.105438] ACPI: Executed 1 blocks of module-level executable AML code
[    0.108566] ACPI: Interpreter enabled
[    0.108569] ACPI: (supports S0 S1 S4 S5)
[    0.108587] ACPI: Using IOAPIC for interrupt routing
[    0.112090] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-743)
[    0.112156] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-743)
[    0.112174] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-743)
[    0.115372] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-743)
[    0.115440] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-743)
[    0.115844] ACPI: No dock devices found.
[    0.115847] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.115909] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.116054] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
[    0.116056] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
[    0.116058] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.116060] pci_root PNP0A03:00: host bridge window [mem 0x000c0000-0x000dffff]
[    0.116062] pci_root PNP0A03:00: host bridge window [mem 0xafff0000-0xffffffff]
[    0.116076] pci 0000:00:00.0: [1002:5957] type 0 class 0x000600
[    0.116089] pci 0000:00:00.0: reg 1c: [mem 0xe0000000-0xffffffff 64bit]
[    0.116118] pci 0000:00:02.0: [1002:5978] type 1 class 0x000604
[    0.116144] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
[    0.116147] pci 0000:00:02.0: PME# disabled
[    0.116164] pci 0000:00:06.0: [1002:597c] type 1 class 0x000604
[    0.116189] pci 0000:00:06.0: PME# supported from D0 D3hot D3cold
[    0.116191] pci 0000:00:06.0: PME# disabled
[    0.116204] pci 0000:00:07.0: [1002:597d] type 1 class 0x000604
[    0.116229] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    0.116231] pci 0000:00:07.0: PME# disabled
[    0.116261] pci 0000:00:12.0: [1002:4380] type 0 class 0x000101
[    0.116279] pci 0000:00:12.0: reg 10: [io  0xff00-0xff07]
[    0.116289] pci 0000:00:12.0: reg 14: [io  0xfe00-0xfe03]
[    0.116299] pci 0000:00:12.0: reg 18: [io  0xfd00-0xfd07]
[    0.116309] pci 0000:00:12.0: reg 1c: [io  0xfc00-0xfc03]
[    0.116319] pci 0000:00:12.0: reg 20: [io  0xfb00-0xfb0f]
[    0.116329] pci 0000:00:12.0: reg 24: [mem 0xfe02f000-0xfe02f3ff]
[    0.116350] pci 0000:00:12.0: set SATA to AHCI mode
[    0.116378] pci 0000:00:13.0: [1002:4387] type 0 class 0x000c03
[    0.116392] pci 0000:00:13.0: reg 10: [mem 0xfe02e000-0xfe02efff]
[    0.116457] pci 0000:00:13.1: [1002:4388] type 0 class 0x000c03
[    0.116471] pci 0000:00:13.1: reg 10: [mem 0xfe02d000-0xfe02dfff]
[    0.116536] pci 0000:00:13.2: [1002:4389] type 0 class 0x000c03
[    0.116550] pci 0000:00:13.2: reg 10: [mem 0xfe02c000-0xfe02cfff]
[    0.116615] pci 0000:00:13.3: [1002:438a] type 0 class 0x000c03
[    0.116629] pci 0000:00:13.3: reg 10: [mem 0xfe02b000-0xfe02bfff]
[    0.116694] pci 0000:00:13.4: [1002:438b] type 0 class 0x000c03
[    0.116708] pci 0000:00:13.4: reg 10: [mem 0xfe02a000-0xfe02afff]
[    0.116779] pci 0000:00:13.5: [1002:4386] type 0 class 0x000c03
[    0.116799] pci 0000:00:13.5: reg 10: [mem 0xfe029000-0xfe0290ff]
[    0.116871] pci 0000:00:13.5: supports D1 D2
[    0.116873] pci 0000:00:13.5: PME# supported from D0 D1 D2 D3hot
[    0.116877] pci 0000:00:13.5: PME# disabled
[    0.116898] pci 0000:00:14.0: [1002:4385] type 0 class 0x000c05
[    0.116920] pci 0000:00:14.0: reg 10: [io  0x0b00-0x0b0f]
[    0.117003] pci 0000:00:14.1: [1002:438c] type 0 class 0x000101
[    0.117017] pci 0000:00:14.1: reg 10: [io  0x0000-0x0007]
[    0.117026] pci 0000:00:14.1: reg 14: [io  0x0000-0x0003]
[    0.117036] pci 0000:00:14.1: reg 18: [io  0x0000-0x0007]
[    0.117046] pci 0000:00:14.1: reg 1c: [io  0x0000-0x0003]
[    0.117056] pci 0000:00:14.1: reg 20: [io  0xf900-0xf90f]
[    0.117092] pci 0000:00:14.2: [1002:4383] type 0 class 0x000403
[    0.117114] pci 0000:00:14.2: reg 10: [mem 0xfe024000-0xfe027fff 64bit]
[    0.117174] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    0.117178] pci 0000:00:14.2: PME# disabled
[    0.117191] pci 0000:00:14.3: [1002:438d] type 0 class 0x000601
[    0.117266] pci 0000:00:14.4: [1002:4384] type 1 class 0x000604
[    0.117311] pci 0000:00:18.0: [1022:1100] type 0 class 0x000600
[    0.117323] pci 0000:00:18.1: [1022:1101] type 0 class 0x000600
[    0.117334] pci 0000:00:18.2: [1022:1102] type 0 class 0x000600
[    0.117345] pci 0000:00:18.3: [1022:1103] type 0 class 0x000600
[    0.117396] pci 0000:01:00.0: [10de:0a65] type 0 class 0x000300
[    0.117406] pci 0000:01:00.0: reg 10: [mem 0xfb000000-0xfbffffff]
[    0.117417] pci 0000:01:00.0: reg 14: [mem 0xb0000000-0xbfffffff 64bit pref]
[    0.117428] pci 0000:01:00.0: reg 1c: [mem 0xce000000-0xcfffffff 64bit pref]
[    0.117436] pci 0000:01:00.0: reg 24: [io  0xcf00-0xcf7f]
[    0.117443] pci 0000:01:00.0: reg 30: [mem 0x00000000-0x0007ffff pref]
[    0.117488] pci 0000:01:00.1: [10de:0be3] type 0 class 0x000403
[    0.117498] pci 0000:01:00.1: reg 10: [mem 0xfcffc000-0xfcffffff]
[    0.119012] pci 0000:00:02.0: PCI bridge to [bus 01-01]
[    0.119015] pci 0000:00:02.0:   bridge window [io  0xc000-0xcfff]
[    0.119018] pci 0000:00:02.0:   bridge window [mem 0xfb000000-0xfcffffff]
[    0.119021] pci 0000:00:02.0:   bridge window [mem 0xb0000000-0xcfffffff 64bit pref]
[    0.119058] pci 0000:02:00.0: [197b:2363] type 0 class 0x000104
[    0.119128] pci 0000:02:00.0: reg 24: [mem 0xfdffe000-0xfdffffff]
[    0.119139] pci 0000:02:00.0: reg 30: [mem 0x00000000-0x0000ffff pref]
[    0.119164] pci 0000:02:00.0: PME# supported from D3hot
[    0.119168] pci 0000:02:00.0: PME# disabled
[    0.119191] pci 0000:02:00.1: [197b:2363] type 0 class 0x000101
[    0.119210] pci 0000:02:00.1: reg 10: [io  0xef00-0xef07]
[    0.119221] pci 0000:02:00.1: reg 14: [io  0xee00-0xee03]
[    0.119232] pci 0000:02:00.1: reg 18: [io  0xed00-0xed07]
[    0.119243] pci 0000:02:00.1: reg 1c: [io  0xec00-0xec03]
[    0.119254] pci 0000:02:00.1: reg 20: [io  0xeb00-0xeb0f]
[    0.119309] pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.119319] pci 0000:00:06.0: PCI bridge to [bus 02-02]
[    0.119322] pci 0000:00:06.0:   bridge window [io  0xe000-0xefff]
[    0.119324] pci 0000:00:06.0:   bridge window [mem 0xfdf00000-0xfdffffff]
[    0.119328] pci 0000:00:06.0:   bridge window [mem 0xfde00000-0xfdefffff 64bit pref]
[    0.119366] pci 0000:03:00.0: [11ab:4364] type 0 class 0x000200
[    0.119383] pci 0000:03:00.0: reg 10: [mem 0xfddfc000-0xfddfffff 64bit]
[    0.119393] pci 0000:03:00.0: reg 18: [io  0xde00-0xdeff]
[    0.119425] pci 0000:03:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    0.119455] pci 0000:03:00.0: supports D1 D2
[    0.119457] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.119461] pci 0000:03:00.0: PME# disabled
[    0.121009] pci 0000:00:07.0: PCI bridge to [bus 03-03]
[    0.121012] pci 0000:00:07.0:   bridge window [io  0xd000-0xdfff]
[    0.121015] pci 0000:00:07.0:   bridge window [mem 0xfdd00000-0xfddfffff]
[    0.121018] pci 0000:00:07.0:   bridge window [mem 0xfdc00000-0xfdcfffff 64bit pref]
[    0.121080] pci 0000:00:14.4: PCI bridge to [bus 04-04] (subtractive decode)
[    0.121084] pci 0000:00:14.4:   bridge window [io  0xb000-0xbfff]
[    0.121088] pci 0000:00:14.4:   bridge window [mem 0xfdb00000-0xfdbfffff]
[    0.121092] pci 0000:00:14.4:   bridge window [mem 0xfda00000-0xfdafffff pref]
[    0.121095] pci 0000:00:14.4:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.121097] pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.121099] pci 0000:00:14.4:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.121101] pci 0000:00:14.4:   bridge window [mem 0x000c0000-0x000dffff] (subtractive decode)
[    0.121103] pci 0000:00:14.4:   bridge window [mem 0xafff0000-0xffffffff] (subtractive decode)
[    0.121117] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.121349] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P_._PRT]
[    0.121417] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE2._PRT]
[    0.121456] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE6._PRT]
[    0.121489] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE7._PRT]
[    0.135499] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.135549] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.135598] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.135647] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.135697] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.135746] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.135795] ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.135844] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.135867] HEST: Table is not found!
[    0.136031] SCSI subsystem initialized
[    0.136040] libata version 3.00 loaded.
[    0.136075] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.136078] vgaarb: loaded
[    0.136101] usbcore: registered new interface driver usbfs
[    0.136113] usbcore: registered new interface driver hub
[    0.136121] usbcore: registered new device driver usb
[    0.136121] PCI: Using ACPI for IRQ routing
[    0.136121] PCI: pci_cache_line_size set to 64 bytes
[    0.136121] pci 0000:00:00.0: address space collision: [mem 0xe0000000-0xffffffff 64bit] conflicts with PCI Bus 0000:01 [mem 0xfb000000-0xfcffffff]
[    0.136121] reserve RAM buffer: 000000000009f400 - 000000000009ffff 
[    0.136121] reserve RAM buffer: 00000000affe0000 - 00000000afffffff 
[    0.136212] NetLabel: Initializing
[    0.136213] NetLabel:  domain hash size = 128
[    0.136214] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.136225] NetLabel:  unlabeled traffic allowed by default
[    0.136234] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.136238] hpet0: 4 comparators, 32-bit 14.318180 MHz counter
[    0.138023] Switching to clocksource hpet
[    0.139053] AppArmor: AppArmor Filesystem Enabled
[    0.139059] pnp: PnP ACPI init
[    0.139073] ACPI: bus type pnp registered
[    0.139180] pnp 00:00: [bus 00-ff]
[    0.139182] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.139184] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.139186] pnp 00:00: [io  0x0d00-0xffff window]
[    0.139188] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.139190] pnp 00:00: [mem 0x000c0000-0x000dffff window]
[    0.139192] pnp 00:00: [mem 0xafff0000-0xffffffff window]
[    0.139241] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.139409] pnp 00:01: [io  0x4100-0x411f]
[    0.139411] pnp 00:01: [io  0x0228-0x022f]
[    0.139412] pnp 00:01: [io  0x040b]
[    0.139414] pnp 00:01: [io  0x04d6]
[    0.139415] pnp 00:01: [io  0x0c00-0x0c01]
[    0.139417] pnp 00:01: [io  0x0c14]
[    0.139418] pnp 00:01: [io  0x0c50-0x0c52]
[    0.139420] pnp 00:01: [io  0x0c6c-0x0c6d]
[    0.139421] pnp 00:01: [io  0x0c6f]
[    0.139424] pnp 00:01: [io  0x0cd0-0x0cd1]
[    0.139426] pnp 00:01: [io  0x0cd2-0x0cd3]
[    0.139427] pnp 00:01: [io  0x0cd4-0x0cdf]
[    0.139429] pnp 00:01: [io  0x4000-0x40fe]
[    0.139430] pnp 00:01: [io  0x4210-0x4217]
[    0.139432] pnp 00:01: [io  0x0b10-0x0b1f]
[    0.139434] pnp 00:01: [mem 0x00000000-0x00000fff window]
[    0.139436] pnp 00:01: [mem 0xfee00400-0xfee00fff window]
[    0.139441] pnp 00:01: disabling [mem 0x00000000-0x00000fff window] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
[    0.139464] pnp 00:01: disabling [mem 0x00000000-0x00000fff window disabled] because it overlaps 0000:01:00.0 BAR 6 [mem 0x00000000-0x0007ffff pref]
[    0.139469] pnp 00:01: disabling [mem 0x00000000-0x00000fff window disabled] because it overlaps 0000:02:00.0 BAR 6 [mem 0x00000000-0x0000ffff pref]
[    0.139476] pnp 00:01: disabling [mem 0x00000000-0x00000fff window disabled] because it overlaps 0000:03:00.0 BAR 6 [mem 0x00000000-0x0001ffff pref]
[    0.139502] pnp 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.139619] pnp 00:02: [dma 4]
[    0.139621] pnp 00:02: [io  0x0000-0x000f]
[    0.139622] pnp 00:02: [io  0x0080-0x0090]
[    0.139624] pnp 00:02: [io  0x0094-0x009f]
[    0.139625] pnp 00:02: [io  0x00c0-0x00df]
[    0.139652] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.139703] pnp 00:03: [irq 0 disabled]
[    0.139716] pnp 00:03: [irq 8]
[    0.139718] pnp 00:03: [mem 0xfed00000-0xfed003ff]
[    0.139746] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.139775] pnp 00:04: [io  0x0070-0x0073]
[    0.139803] pnp 00:04: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.139811] pnp 00:05: [io  0x0061]
[    0.139838] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.139845] pnp 00:06: [io  0x00f0-0x00ff]
[    0.139853] pnp 00:06: [irq 13]
[    0.139885] pnp 00:06: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.139942] pnp 00:07: [io  0x0010-0x001f]
[    0.139944] pnp 00:07: [io  0x0022-0x003f]
[    0.139945] pnp 00:07: [io  0x0044-0x005f]
[    0.139947] pnp 00:07: [io  0x0062-0x0063]
[    0.139948] pnp 00:07: [io  0x0065-0x006f]
[    0.139950] pnp 00:07: [io  0x0074-0x007f]
[    0.139951] pnp 00:07: [io  0x0091-0x0093]
[    0.139953] pnp 00:07: [io  0x00a2-0x00bf]
[    0.139954] pnp 00:07: [io  0x00e0-0x00ef]
[    0.139956] pnp 00:07: [io  0x04d0-0x04d1]
[    0.139958] pnp 00:07: [io  0x0220-0x0225]
[    0.140026] pnp 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.140208] pnp 00:08: [io  0x03f0-0x03f5]
[    0.140210] pnp 00:08: [io  0x03f7]
[    0.140218] pnp 00:08: [irq 6]
[    0.140219] pnp 00:08: [dma 2]
[    0.140262] pnp 00:08: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.140512] pnp 00:09: [io  0x03f8-0x03ff]
[    0.140520] pnp 00:09: [irq 4]
[    0.140570] pnp 00:09: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.140843] pnp 00:0a: [io  0x0378-0x037f]
[    0.140851] pnp 00:0a: [irq 7]
[    0.140897] pnp 00:0a: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.141124] pnp 00:0b: [mem 0x000f0000-0x000fffff]
[    0.141127] pnp 00:0b: [mem 0x00000000-0x001fffff]
[    0.141129] pnp 00:0b: [mem 0xfed00000-0xfed000ff]
[    0.141131] pnp 00:0b: [mem 0xaffe0000-0xafffffff]
[    0.141133] pnp 00:0b: [mem 0xffff0000-0xffffffff]
[    0.141134] pnp 00:0b: [mem 0x00000000-0x0009ffff]
[    0.141136] pnp 00:0b: [mem 0x00100000-0xaffdffff]
[    0.141138] pnp 00:0b: [mem 0xfec00000-0xfec00fff]
[    0.141140] pnp 00:0b: [mem 0xfee00000-0xfee00fff]
[    0.141141] pnp 00:0b: [mem 0xfff80000-0xfffeffff]
[    0.141145] pnp 00:0b: disabling [mem 0x000f0000-0x000fffff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
[    0.141148] pnp 00:0b: disabling [mem 0x00000000-0x001fffff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
[    0.141151] pnp 00:0b: disabling [mem 0x00000000-0x0009ffff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
[    0.141154] pnp 00:0b: disabling [mem 0x00100000-0xaffdffff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
[    0.141206] pnp 00:0b: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.141214] pnp: PnP ACPI: found 12 devices
[    0.141215] ACPI: ACPI bus type pnp unregistered
[    0.141223] system 00:01: [io  0x4100-0x411f] has been reserved
[    0.141226] system 00:01: [io  0x0228-0x022f] has been reserved
[    0.141228] system 00:01: [io  0x040b] has been reserved
[    0.141230] system 00:01: [io  0x04d6] has been reserved
[    0.141232] system 00:01: [io  0x0c00-0x0c01] has been reserved
[    0.141234] system 00:01: [io  0x0c14] has been reserved
[    0.141236] system 00:01: [io  0x0c50-0x0c52] has been reserved
[    0.141238] system 00:01: [io  0x0c6c-0x0c6d] has been reserved
[    0.141241] system 00:01: [io  0x0c6f] has been reserved
[    0.141243] system 00:01: [io  0x0cd0-0x0cd1] has been reserved
[    0.141245] system 00:01: [io  0x0cd2-0x0cd3] has been reserved
[    0.141248] system 00:01: [io  0x0cd4-0x0cdf] has been reserved
[    0.141250] system 00:01: [io  0x4000-0x40fe] has been reserved
[    0.141252] system 00:01: [io  0x4210-0x4217] has been reserved
[    0.141255] system 00:01: [io  0x0b10-0x0b1f] has been reserved
[    0.141257] system 00:01: [mem 0xfee00400-0xfee00fff window] has been reserved
[    0.141263] system 00:07: [io  0x04d0-0x04d1] has been reserved
[    0.141265] system 00:07: [io  0x0220-0x0225] has been reserved
[    0.141270] system 00:0b: [mem 0xfed00000-0xfed000ff] has been reserved
[    0.141273] system 00:0b: [mem 0xaffe0000-0xafffffff] could not be reserved
[    0.141275] system 00:0b: [mem 0xffff0000-0xffffffff] has been reserved
[    0.141278] system 00:0b: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.141280] system 00:0b: [mem 0xfee00000-0xfee00fff] could not be reserved
[    0.141283] system 00:0b: [mem 0xfff80000-0xfffeffff] has been reserved
[    0.177569] pci 0000:01:00.0: BAR 6: assigned [mem 0xc0000000-0xc007ffff pref]
[    0.177572] pci 0000:00:02.0: PCI bridge to [bus 01-01]
[    0.177574] pci 0000:00:02.0:   bridge window [io  0xc000-0xcfff]
[    0.177577] pci 0000:00:02.0:   bridge window [mem 0xfb000000-0xfcffffff]
[    0.177580] pci 0000:00:02.0:   bridge window [mem 0xb0000000-0xcfffffff 64bit pref]
[    0.177584] pci 0000:02:00.0: BAR 6: assigned [mem 0xfde00000-0xfde0ffff pref]
[    0.177586] pci 0000:00:06.0: PCI bridge to [bus 02-02]
[    0.177588] pci 0000:00:06.0:   bridge window [io  0xe000-0xefff]
[    0.177591] pci 0000:00:06.0:   bridge window [mem 0xfdf00000-0xfdffffff]
[    0.177593] pci 0000:00:06.0:   bridge window [mem 0xfde00000-0xfdefffff 64bit pref]
[    0.177597] pci 0000:03:00.0: BAR 6: assigned [mem 0xfdc00000-0xfdc1ffff pref]
[    0.177599] pci 0000:00:07.0: PCI bridge to [bus 03-03]
[    0.177601] pci 0000:00:07.0:   bridge window [io  0xd000-0xdfff]
[    0.177604] pci 0000:00:07.0:   bridge window [mem 0xfdd00000-0xfddfffff]
[    0.177606] pci 0000:00:07.0:   bridge window [mem 0xfdc00000-0xfdcfffff 64bit pref]
[    0.177610] pci 0000:00:14.4: PCI bridge to [bus 04-04]
[    0.177612] pci 0000:00:14.4:   bridge window [io  0xb000-0xbfff]
[    0.177618] pci 0000:00:14.4:   bridge window [mem 0xfdb00000-0xfdbfffff]
[    0.177622] pci 0000:00:14.4:   bridge window [mem 0xfda00000-0xfdafffff pref]
[    0.177641] pci 0000:00:02.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.177644] pci 0000:00:02.0: setting latency timer to 64
[    0.177648] pci 0000:00:06.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.177650] pci 0000:00:06.0: setting latency timer to 64
[    0.177659] pci 0000:00:07.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    0.177661] pci 0000:00:07.0: setting latency timer to 64
[    0.177668] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.177670] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.177672] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.177673] pci_bus 0000:00: resource 7 [mem 0x000c0000-0x000dffff]
[    0.177675] pci_bus 0000:00: resource 8 [mem 0xafff0000-0xffffffff]
[    0.177677] pci_bus 0000:01: resource 0 [io  0xc000-0xcfff]
[    0.177679] pci_bus 0000:01: resource 1 [mem 0xfb000000-0xfcffffff]
[    0.177681] pci_bus 0000:01: resource 2 [mem 0xb0000000-0xcfffffff 64bit pref]
[    0.177683] pci_bus 0000:02: resource 0 [io  0xe000-0xefff]
[    0.177684] pci_bus 0000:02: resource 1 [mem 0xfdf00000-0xfdffffff]
[    0.177686] pci_bus 0000:02: resource 2 [mem 0xfde00000-0xfdefffff 64bit pref]
[    0.177688] pci_bus 0000:03: resource 0 [io  0xd000-0xdfff]
[    0.177690] pci_bus 0000:03: resource 1 [mem 0xfdd00000-0xfddfffff]
[    0.177692] pci_bus 0000:03: resource 2 [mem 0xfdc00000-0xfdcfffff 64bit pref]
[    0.177694] pci_bus 0000:04: resource 0 [io  0xb000-0xbfff]
[    0.177696] pci_bus 0000:04: resource 1 [mem 0xfdb00000-0xfdbfffff]
[    0.177698] pci_bus 0000:04: resource 2 [mem 0xfda00000-0xfdafffff pref]
[    0.177699] pci_bus 0000:04: resource 4 [io  0x0000-0x0cf7]
[    0.177701] pci_bus 0000:04: resource 5 [io  0x0d00-0xffff]
[    0.177703] pci_bus 0000:04: resource 6 [mem 0x000a0000-0x000bffff]
[    0.177705] pci_bus 0000:04: resource 7 [mem 0x000c0000-0x000dffff]
[    0.177707] pci_bus 0000:04: resource 8 [mem 0xafff0000-0xffffffff]
[    0.177762] NET: Registered protocol family 2
[    0.177825] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.178070] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.178496] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.178725] TCP: Hash tables configured (established 131072 bind 65536)
[    0.178727] TCP reno registered
[    0.178730] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    0.178739] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    0.178845] NET: Registered protocol family 1
[    0.264057] pci 0000:01:00.0: Boot video device
[    0.264074] PCI: CLS 32 bytes, default 64
[    0.264114] Unpacking initramfs...
[    0.439760] Freeing initrd memory: 10632k freed
[    0.444968] audit: initializing netlink socket (disabled)
[    0.444978] type=2000 audit(1350144712.443:1): initialized
[    0.453427] highmem bounce pool size: 64 pages
[    0.453430] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.453683] VFS: Disk quotas dquot_6.5.2
[    0.453714] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.453868] msgmni has been set to 400
[    0.454114] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.454144] io scheduler noop registered
[    0.454146] io scheduler deadline registered
[    0.454170] io scheduler cfq registered (default)
[    0.454895] vesafb: framebuffer at 0xcf000000, mapped to 0xf7a80000, using 5120k, total 14336k
[    0.454897] vesafb: mode is 1280x1024x16, linelength=2560, pages=1
[    0.454898] vesafb: protected mode interface info at c000:c600
[    0.454900] vesafb: pmi: set display start = c00cc663, set palette = c00cc6be
[    0.454901] vesafb: pmi: ports = 3b4 3b5 3ba 3c0 3c1 3c4 3c5 3c6 3c7 3c8 3c9 3cc 3ce 3cf 3d0 3d1 3d2 3d3 3d4 3d5 3da 
[    0.454909] vesafb: scrolling: redraw
[    0.454911] vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
[    0.455286] bootsplash 3.1.6-2004/03/31: looking for picture...
[    0.455289] bootsplash: silentjpeg size 245922 bytes
[    0.477195] bootsplash: ...found (1280x1024, 255920 bytes, v3).
[    0.534343] Console: switching to colour frame buffer device 156x60
[    0.590767] fb0: VESA VGA frame buffer device
[    0.590810] ERST: Table is not found!
[    0.591070] Non-volatile memory driver v1.3
[    0.591072] Linux agpgart interface v0.103
[    0.592328] Serial: 8250/16550 driver, 8 ports, IRQ sharing disabled
[    0.612979] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.748730] 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.764147] ahci 0000:00:12.0: version 3.0
[    0.764167] ahci 0000:00:12.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    0.764190] ahci 0000:00:12.0: controller can't do 64bit DMA, forcing 32bit
[    0.764321] ahci 0000:00:12.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
[    0.764324] ahci 0000:00:12.0: flags: ncq sntf ilck led clo pmp pio ccc 
[    0.765014] scsi0 : ahci
[    0.765115] scsi1 : ahci
[    0.765180] scsi2 : ahci
[    0.765247] scsi3 : ahci
[    0.765358] ata1: SATA max UDMA/133 irq_stat 0x00400000, PHY RDY changed irq 22
[    0.765361] ata2: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f180 irq 22
[    0.765364] ata3: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f200 irq 22
[    0.765367] ata4: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f280 irq 22
[    0.766023] ahci 0000:02:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.777035] ahci 0000:02:00.0: AHCI 0001.0000 32 slots 2 ports 3 Gbps 0x3 impl SATA mode
[    0.777038] ahci 0000:02:00.0: flags: 64bit ncq pm led clo pmp pio slum part 
[    0.777042] ahci 0000:02:00.0: setting latency timer to 64
[    0.777401] scsi4 : ahci
[    0.777461] scsi5 : ahci
[    0.777498] ata5: SATA max UDMA/133 abar m8192@0xfdffe000 port 0xfdffe100 irq 18
[    0.777501] ata6: SATA max UDMA/133 abar m8192@0xfdffe000 port 0xfdffe180 irq 18
[    0.777589] Fixed MDIO Bus: probed
[    0.777593] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.777636] ehci_hcd 0000:00:13.5: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    0.777645] ehci_hcd 0000:00:13.5: EHCI Host Controller
[    0.777665] ehci_hcd 0000:00:13.5: new USB bus registered, assigned bus number 1
[    0.783031] ehci_hcd 0000:00:13.5: applying AMD SB600/SB700 USB freeze workaround
[    0.783045] ehci_hcd 0000:00:13.5: debug port 1
[    0.783070] ehci_hcd 0000:00:13.5: irq 19, io mem 0xfe029000
[    0.789014] ehci_hcd 0000:00:13.5: USB 2.0 started, EHCI 1.00
[    0.789030] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    0.789032] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.789034] usb usb1: Product: EHCI Host Controller
[    0.789035] usb usb1: Manufacturer: Linux 2.6.37.6-0.20-desktop ehci_hcd
[    0.789037] usb usb1: SerialNumber: 0000:00:13.5
[    0.789129] hub 1-0:1.0: USB hub found
[    0.789132] hub 1-0:1.0: 10 ports detected
[    0.789230] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.789289] ohci_hcd 0000:00:13.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.789297] ohci_hcd 0000:00:13.0: OHCI Host Controller
[    0.789303] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 2
[    0.795037] ohci_hcd 0000:00:13.0: irq 16, io mem 0xfe02e000
[    0.850048] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    0.850050] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.850052] usb usb2: Product: OHCI Host Controller
[    0.850053] usb usb2: Manufacturer: Linux 2.6.37.6-0.20-desktop ohci_hcd
[    0.850055] usb usb2: SerialNumber: 0000:00:13.0
[    0.850120] hub 2-0:1.0: USB hub found
[    0.850126] hub 2-0:1.0: 2 ports detected
[    0.850229] ohci_hcd 0000:00:13.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.850237] ohci_hcd 0000:00:13.1: OHCI Host Controller
[    0.850243] ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 3
[    0.858034] ohci_hcd 0000:00:13.1: irq 17, io mem 0xfe02d000
[    0.913041] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    0.913043] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.913045] usb usb3: Product: OHCI Host Controller
[    0.913046] usb usb3: Manufacturer: Linux 2.6.37.6-0.20-desktop ohci_hcd
[    0.913048] usb usb3: SerialNumber: 0000:00:13.1
[    0.913113] hub 3-0:1.0: USB hub found
[    0.913118] hub 3-0:1.0: 2 ports detected
[    0.913214] ohci_hcd 0000:00:13.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.913222] ohci_hcd 0000:00:13.2: OHCI Host Controller
[    0.913228] ohci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 4
[    0.921021] ohci_hcd 0000:00:13.2: irq 18, io mem 0xfe02c000
[    0.976039] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    0.976041] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.976043] usb usb4: Product: OHCI Host Controller
[    0.976044] usb usb4: Manufacturer: Linux 2.6.37.6-0.20-desktop ohci_hcd
[    0.976046] usb usb4: SerialNumber: 0000:00:13.2
[    0.976112] hub 4-0:1.0: USB hub found
[    0.976117] hub 4-0:1.0: 2 ports detected
[    0.976210] ohci_hcd 0000:00:13.3: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.976218] ohci_hcd 0000:00:13.3: OHCI Host Controller
[    0.976225] ohci_hcd 0000:00:13.3: new USB bus registered, assigned bus number 5
[    0.988021] ohci_hcd 0000:00:13.3: irq 17, io mem 0xfe02b000
[    1.043040] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    1.043042] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.043043] usb usb5: Product: OHCI Host Controller
[    1.043045] usb usb5: Manufacturer: Linux 2.6.37.6-0.20-desktop ohci_hcd
[    1.043046] usb usb5: SerialNumber: 0000:00:13.3
[    1.043115] hub 5-0:1.0: USB hub found
[    1.043121] hub 5-0:1.0: 2 ports detected
[    1.043219] ohci_hcd 0000:00:13.4: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    1.043227] ohci_hcd 0000:00:13.4: OHCI Host Controller
[    1.043232] ohci_hcd 0000:00:13.4: new USB bus registered, assigned bus number 6
[    1.051021] ohci_hcd 0000:00:13.4: irq 18, io mem 0xfe02a000
[    1.070040] ata2: SATA link down (SStatus 0 SControl 300)
[    1.070074] ata4: SATA link down (SStatus 0 SControl 300)
[    1.070106] ata3: SATA link down (SStatus 0 SControl 300)
[    1.082033] ata5: SATA link down (SStatus 0 SControl 300)
[    1.082067] ata6: SATA link down (SStatus 0 SControl 300)
[    1.106045] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    1.106047] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.106049] usb usb6: Product: OHCI Host Controller
[    1.106050] usb usb6: Manufacturer: Linux 2.6.37.6-0.20-desktop ohci_hcd
[    1.106052] usb usb6: SerialNumber: 0000:00:13.4
[    1.106116] hub 6-0:1.0: USB hub found
[    1.106121] hub 6-0:1.0: 2 ports detected
[    1.106188] uhci_hcd: USB Universal Host Controller Interface driver
[    1.106220] Initializing USB Mass Storage driver...
[    1.106247] usbcore: registered new interface driver usb-storage
[    1.106248] USB Mass Storage support registered.
[    1.106257] usbcore: registered new interface driver ums-alauda
[    1.106267] usbcore: registered new interface driver ums-cypress
[    1.106276] usbcore: registered new interface driver ums-datafab
[    1.106285] usbcore: registered new interface driver ums-freecom
[    1.106294] usbcore: registered new interface driver ums-isd200
[    1.106303] usbcore: registered new interface driver ums-jumpshot
[    1.106312] usbcore: registered new interface driver ums-karma
[    1.106321] usbcore: registered new interface driver ums-onetouch
[    1.106331] usbcore: registered new interface driver ums-sddr09
[    1.106340] usbcore: registered new interface driver ums-sddr55
[    1.106350] usbcore: registered new interface driver ums-usbat
[    1.106385] PNP: No PS/2 controller found. Probing ports directly.
[    1.106802] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.106807] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.106872] mice: PS/2 mouse device common for all mice
[    1.106950] rtc_cmos 00:04: RTC can wake from S4
[    1.109053] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
[    1.109087] rtc0: alarms up to one month, 242 bytes nvram, hpet irqs
[    1.109096] cpuidle: using governor ladder
[    1.109097] cpuidle: using governor menu
[    1.109354] usbcore: registered new interface driver usbhid
[    1.109355] usbhid: USB HID core driver
[    1.109534] TCP cubic registered
[    1.109602] NET: Registered protocol family 10
[    1.109862] lo: Disabled Privacy Extensions
[    1.110020] lib80211: common routines for IEEE802.11 drivers
[    1.110022] lib80211_crypt: registered algorithm 'NULL'
[    1.110024] Registering the dns_resolver key type
[    1.110073] libceph: loaded (mon/osd proto 15/24, osdmap 5/5 5/5)
[    1.110081] Using IPI No-Shortcut mode
[    1.110156] PM: Checking hibernation image partition /dev/disk/by-id/ata-ST3250318AS_6VY3CK0B-part2
[    1.535022] usb 6-1: new full speed USB device using ohci_hcd and address 2
[    1.643023] ata1: softreset failed (device not ready)
[    1.643029] ata1: applying SB600 PMP SRST workaround and retrying
[    1.688065] usb 6-1: New USB device found, idVendor=19ff, idProduct=0231
[    1.688067] usb 6-1: New USB device strings: Mfr=0, Product=2, SerialNumber=0
[    1.688069] usb 6-1: Product: Dynex wireless combo
[    1.698057] input: Dynex wireless combo as /devices/pci0000:00/0000:00:13.4/usb6/6-1/6-1:1.0/input/input0
[    1.698108] generic-usb 0003:19FF:0231.0001: input,hidraw0: USB HID v1.11 Keyboard [Dynex wireless combo] on usb-0000:00:13.4-1/input0
[    1.702699] input: Dynex wireless combo as /devices/pci0000:00/0000:00:13.4/usb6/6-1/6-1:1.1/input/input1
[    1.702763] generic-usb 0003:19FF:0231.0002: input,hidraw1: USB HID v1.11 Mouse [Dynex wireless combo] on usb-0000:00:13.4-1/input1
[    1.798070] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.799071] ata1.00: ATA-8: ST3250318AS, CC37, max UDMA/133
[    1.799073] ata1.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    1.799076] ata1.00: SB600 AHCI: limiting to 255 sectors per cmd
[    1.800251] ata1.00: SB600 AHCI: limiting to 255 sectors per cmd
[    1.800253] ata1.00: configured for UDMA/133
[    1.800382] scsi 0:0:0:0: Direct-Access     ATA      ST3250318AS      CC37 PQ: 0 ANSI: 5
[    1.800502] sd 0:0:0:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 GiB)
[    1.800589] sd 0:0:0:0: [sda] Write Protect is off
[    1.800591] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.800625] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.866456]  sda: sda1 sda2 sda3 < sda5 sda6 sda7 >
[    1.866784] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.866792] PM: Hibernation image not present or could not be loaded.
[    1.866802] registered taskstats version 1
[    1.867040]   Magic number: 0:315:186
[    1.867121] rtc_cmos 00:04: setting system clock to 2012-10-13 16:11:55 UTC (1350144715)
[    1.867189] Freeing unused kernel memory: 452k freed
[    1.867376] Write protecting the kernel text: 4708k
[    1.867434] Write protecting the kernel read-only data: 3188k
[    1.912750] pata_atiixp 0000:00:14.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.913077] scsi6 : pata_atiixp
[    1.913136] scsi7 : pata_atiixp
[    1.913799] ata7: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xf900 irq 14
[    1.913801] ata8: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xf908 irq 15
[    2.067491] ata7.00: ATAPI: TSSTcorpCD/DVDW TS-H552B, TS12, max UDMA/33
[    2.073425] ata7.00: configured for UDMA/33
[    2.074257] scsi 6:0:0:0: CD-ROM            TSSTcorp CD/DVDW TS-H552B TS12 PQ: 0 ANSI: 5
[    2.077400] pata_jmicron 0000:02:00.1: enabling device (0000 -> 0001)
[    2.077407] pata_jmicron 0000:02:00.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    2.077438] pata_jmicron 0000:02:00.1: setting latency timer to 64
[    2.077709] scsi8 : pata_jmicron
[    2.077766] scsi9 : pata_jmicron
[    2.077799] ata9: PATA max UDMA/100 cmd 0xef00 ctl 0xee00 bmdma 0xeb00 irq 19
[    2.077801] ata10: PATA max UDMA/100 cmd 0xed00 ctl 0xec00 bmdma 0xeb08 irq 19
[    2.396539] ACPI Warning: For \_TZ_.THRM._PSL: Return Package type mismatch at index 0 - found [NULL Object Descriptor], expected Reference (20101013/nspredef-1059)
[    2.396546] ACPI: Expecting a [Reference] package element, found type 0
[    2.396553] ACPI: Invalid passive threshold
[    2.396693] thermal LNXTHERM:00: registered as thermal_zone0
[    2.396697] ACPI: Thermal Zone [THRM] (34 C)
[    2.402041] ACPI: acpi_idle registered with cpuidle
[    2.403768] ACPI: Fan [FAN] (on)
[    2.409433] BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
[    2.413544] udev[145]: starting version 166
[    3.667793] kjournald starting.  Commit interval 15 seconds
[    3.668022] EXT3-fs (sda5): using internal journal
[    3.668025] EXT3-fs (sda5): mounted filesystem with ordered data mode
[    5.307221] preloadtrace: systemtap: 1.4/0.149, base: f8161000, memory: 30data/39text/13ctx/13net/282alloc kb, probes: 34
[    6.030723] udev[410]: starting version 166
[    6.254426] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input2
[    6.254468] ACPI: Power Button [PWRB]
[    6.254527] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    6.254550] ACPI: Power Button [PWRF]
[    6.293032] k8temp 0000:00:18.3: Temperature readouts might be wrong - check erratum #141
[    6.303831] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    6.326245] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    6.328932] FDC 0 is a post-1991 82077
[    6.549211] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    6.549415] scsi 6:0:0:0: Attached scsi generic sg1 type 5
[    6.586559] piix4_smbus 0000:00:14.0: SMBus Host Controller at 0xb00, revision 0
[    6.645429] IT8718 SuperIO detected.
[    6.645880] parport_pc 00:0a: reported by Plug and Play ACPI
[    6.645934] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
[    6.649276] input: PC Speaker as /devices/platform/pcspkr/input/input4
[    6.656077] sky2: driver version 1.28
[    6.656146] sky2 0000:03:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    6.656155] sky2 0000:03:00.0: setting latency timer to 64
[    6.656182] sky2 0000:03:00.0: Yukon-2 EC Ultra chip revision 5
[    6.656267] sky2 0000:03:00.0: irq 40 for MSI/MSI-X
[    6.656648] sky2 0000:03:00.0: eth0: addr 00:e0:4d:75:bc:d3
[    6.750074] [drm] Initialized drm 1.1.0 20060810
[    6.750864] ppdev: user-space parallel port driver
[    6.910353] sr0: scsi3-mmc drive: 48x/48x writer cd/rw xa/form2 cdda tray
[    6.910357] cdrom: Uniform CD-ROM driver Revision: 3.20
[    6.910458] sr 6:0:0:0: Attached scsi CD-ROM sr0
[    7.318694] HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    7.318698] ALSA hda_intel.c:2398: Using LPIB position fix
[    7.324129] ALSA hda_intel.c:1488: Enable sync_write for stable communication
[    7.424477] hda_codec: ALC888: BIOS auto-probing.
[    7.424481] ALSA patch_realtek.c:1522: SKU: Nid=0x0 sku_cfg=0x0000e601
[    7.424483] ALSA patch_realtek.c:1524: SKU: port_connectivity=0x0
[    7.424485] ALSA patch_realtek.c:1525: SKU: enable_pcbeep=0x1
[    7.424487] ALSA patch_realtek.c:1526: SKU: check_sum=0x00000000
[    7.424488] ALSA patch_realtek.c:1527: SKU: customization=0x00000000
[    7.424490] ALSA patch_realtek.c:1528: SKU: external_amp=0x0
[    7.424492] ALSA patch_realtek.c:1529: SKU: platform_type=0x0
[    7.424493] ALSA patch_realtek.c:1530: SKU: swap=0x0
[    7.424495] ALSA patch_realtek.c:1531: SKU: override=0x1
[    7.424499] ALSA hda_codec.c:4633: autoconfig: line_outs=4 (0x14/0x15/0x16/0x17/0x0)
[    7.424502] ALSA hda_codec.c:4637:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[    7.424504] ALSA hda_codec.c:4641:    hp_outs=1 (0x1b/0x0/0x0/0x0/0x0)
[    7.424506] ALSA hda_codec.c:4642:    mono: mono_out=0x0
[    7.424508] ALSA hda_codec.c:4645:    dig-out=0x1e/0x0
[    7.424509] ALSA hda_codec.c:4646:    inputs:
[    7.424511] ALSA hda_codec.c:4652: 
[    7.424513] ALSA hda_codec.c:4654:    dig-in=0x1f
[    7.426082] ALSA patch_realtek.c:1595: realtek: Enabling init ASM_ID=0xe601 CODEC_ID=10ec0888
[    7.434051] input: HDA ATI SB Headphone as /devices/pci0000:00/0000:00:14.2/sound/card0/input5
[    7.434225] HDA Intel 0000:01:00.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    7.434228] hda_intel: Disabling MSI
[    7.434252] HDA Intel 0000:01:00.1: setting latency timer to 64
[    7.440050] ALSA hda_intel.c:1450: Enable delay in RIRB handling
[    8.195174] Adding 4200992k swap on /dev/sda2.  Priority:-1 extents:1 across:4200992k 
[    8.950167] device-mapper: uevent: version 1.0.3
[    8.950271] device-mapper: ioctl: 4.18.0-ioctl (2010-06-29) initialised: dm-devel@redhat.com
[    9.688581] kjournald starting.  Commit interval 15 seconds
[    9.688881] EXT3-fs (sda7): using internal journal
[    9.688885] EXT3-fs (sda7): mounted filesystem with ordered data mode
[    9.715068] kjournald starting.  Commit interval 15 seconds
[    9.715607] EXT3-fs (sda1): using internal journal
[    9.715609] EXT3-fs (sda1): mounted filesystem with ordered data mode
[    9.735997] kjournald starting.  Commit interval 15 seconds
[    9.736211] EXT3-fs (sda6): using internal journal
[    9.736213] EXT3-fs (sda6): mounted filesystem with ordered data mode
[   12.010365] powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processor 6400+ (2 cpu cores) (version 2.20.00)
[   12.010414] powernow-k8:    0 : fid 0x18 (3200 MHz), vid 0x6
[   12.010415] powernow-k8:    1 : fid 0x16 (3000 MHz), vid 0x8
[   12.010417] powernow-k8:    2 : fid 0x14 (2800 MHz), vid 0xa
[   12.010418] powernow-k8:    3 : fid 0x12 (2600 MHz), vid 0xc
[   12.010419] powernow-k8:    4 : fid 0x10 (2400 MHz), vid 0xe
[   12.010420] powernow-k8:    5 : fid 0xe (2200 MHz), vid 0x10
[   12.010422] powernow-k8:    6 : fid 0xc (2000 MHz), vid 0x10
[   12.010423] powernow-k8:    7 : fid 0xa (1800 MHz), vid 0x10
[   12.010424] powernow-k8:    8 : fid 0x2 (1000 MHz), vid 0x12
[   12.504017] Clocksource tsc unstable (delta = -130480912 ns)
[   13.705144] sky2 0000:03:00.0: eth0: enabling interface
[   13.705312] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   16.764958] sky2 0000:03:00.0: eth0: Link is up at 100 Mbps, full duplex, flow control both
[   16.765266] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   20.738535] bootsplash: status on console 0 changed to on
[   27.266023] eth0: no IPv6 routers present

--------------040200070506070205090009--

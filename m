Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603Ab0HXJMe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 05:12:34 -0400
Received: from mailout-us.gmx.com ([74.208.5.67]:36830 "HELO
	mailout-us.gmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754433Ab0HXJM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 05:12:27 -0400
X-Authenticated: #65048216
X-Provags-ID: V01U2FsdGVkX190ZugRUaF0Xiu0Ng8el3aTjbfPbP+sUnDQXANQLz
	ia6rqVX4FG9N8F
Subject: Re: i915: 2.6.36-rc2 wrong resolution on gdm start
From: Ivan Bulatovic <combuster@gmx.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        jbarnes@virtuousgeek.org, eric@anholt.net, penberg@kernel.org
In-Reply-To: <89kc63$hrqmar@fmsmga002.fm.intel.com>
References: <1282611655.2177.19.camel@localhost.localdomain>
	 <8u3s8d$jcftu0@orsmga001.jf.intel.com>
	 <1282638912.2191.17.camel@localhost.localdomain>
	 <89kc63$hrqmar@fmsmga002.fm.intel.com>
Content-Type: multipart/mixed; boundary="=-VvVq7WiiE4PudwTTyALl"
Date: Tue, 24 Aug 2010 11:12:06 +0200
Message-ID: <1282641126.2259.15.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-VvVq7WiiE4PudwTTyALl
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Tue, 2010-08-24 at 09:50 +0100, Chris Wilson wrote: 
> On Tue, 24 Aug 2010 10:35:12 +0200, Ivan Bulatovic <combuster@gmx.com> wrote:
> > Above patches didn't help when applied to 2.6.36-rc2. 
> 
> Would be useful to double check reverting the bad commit helps.
>  
> > I'm going to compare dmesg between 2.6.35.3 and 2.6.36-rc2 with
> > drm.debug=0x6. Thanks,
> 
> Aye that would be a useful check.
> 
> -- 
> Chris Wilson, Intel Open Source Technology Centre
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Here are both dmesg outputs with drm.debug=0x6 in the attachements

cat dmesg.drm.35 | grep TV
[    1.006007] [drm:intel_tv_detect_type], No TV connection detected
[   26.391167] [drm:intel_tv_detect_type], No TV connection detected
[   26.539169] [drm:intel_tv_detect_type], No TV connection detected
[   26.805170] [drm:intel_tv_detect_type], No TV connection detected
[   26.953169] [drm:intel_tv_detect_type], No TV connection detected
[   31.935291] [drm:intel_tv_detect_type], No TV connection detected
[   32.083153] [drm:intel_tv_detect_type], No TV connection detected
[   32.352162] [drm:intel_tv_detect_type], No TV connection detected
[   32.500166] [drm:intel_tv_detect_type], No TV connection detected
[   32.819162] [drm:intel_tv_detect_type], No TV connection detected
[   32.967161] [drm:intel_tv_detect_type], No TV connection detected
[   42.666163] [drm:intel_tv_detect_type], No TV connection detected
[   42.814164] [drm:intel_tv_detect_type], No TV connection detected
[   43.083165] [drm:intel_tv_detect_type], No TV connection detected
[   43.231164] [drm:intel_tv_detect_type], No TV connection detected
[   43.500165] [drm:intel_tv_detect_type], No TV connection detected
[   43.648165] [drm:intel_tv_detect_type], No TV connection detected
[   47.134054] [drm:intel_tv_detect_type], No TV connection detected
[   47.281076] [drm:intel_tv_detect_type], No TV connection detected

cat dmesg.drm.36 | grep TV
[    1.487022] [drm:drm_crtc_helper_set_mode], [ENCODER:15:TV-15] set
[MODE:0:NTSC 480i]
[    1.691016] [drm:intel_tv_detect_type], No TV connection detected
[   25.939358] [drm:drm_crtc_helper_set_mode], [ENCODER:15:TV-15] set
[MODE:0:NTSC 480i]
[   26.143015] [drm:intel_tv_detect_type], No TV connection detected
[   26.264155] [drm:drm_crtc_helper_set_mode], [ENCODER:15:TV-15] set
[MODE:0:NTSC 480i]
[   26.269980] [drm:intel_tv_detect_type], Detected S-Video TV
connection
[   26.406164] [drm:drm_crtc_helper_set_mode], [ENCODER:15:TV-15] set
[MODE:0:NTSC 480i]
[   26.419933] [drm:intel_tv_detect_type], Detected Composite TV
connection
[   26.657428] [drm:drm_crtc_helper_set_mode], [ENCODER:15:TV-15] set
[MODE:0:NTSC 480i]
[   26.670054] [drm:intel_tv_detect_type], Detected S-Video TV
connection
[   27.171031] [drm:drm_crtc_helper_set_mode], [ENCODER:15:TV-15] set
[MODE:54:1024x768]
[   32.772020] [drm:intel_tv_detect_type], No TV connection detected
[   32.874039] [drm:intel_tv_detect_type], No TV connection detected
[   33.090015] [drm:intel_tv_detect_type], No TV connection detected
[   33.192015] [drm:intel_tv_detect_type], No TV connection detected
[   33.473017] [drm:intel_tv_detect_type], No TV connection detected
[   33.575016] [drm:intel_tv_detect_type], No TV connection detected
[   42.800550] [drm:intel_tv_detect_type], Detected Component TV
connection
[   42.916789] [drm:intel_tv_detect_type], Detected Component TV
connection
[   43.034997] [drm:intel_tv_detect_type], Detected Component TV
connection
[   46.486754] [drm:drm_crtc_helper_set_mode], [ENCODER:15:TV-15] set
[MODE:0:NTSC 480i]
[   46.690019] [drm:intel_tv_detect_type], No TV connection detected
[   46.821272] [drm:drm_crtc_helper_set_mode], [ENCODER:15:TV-15] set
[MODE:0:NTSC 480i]
[   46.833086] [drm:intel_tv_detect_type], Detected S-Video TV
connection
[   46.964281] [drm:drm_crtc_helper_set_mode], [ENCODER:15:TV-15] set
[MODE:0:NTSC 480i]
[   46.967099] [drm:intel_tv_detect_type], Detected Composite TV
connection
[   47.132794] [drm:drm_crtc_helper_set_mode], [ENCODER:15:TV-15] set
[MODE:57:]

I'll try to revert 9d0498a2bf7455159b317f19531a3e5db2ecc9c4 and see if
that helps.

Thanks for the confirmation Pekka. I've managed to change the resolution
but gdm always starts with 1024x768 and upon login it gets 1280x1024,
and sometimes the mouse pointer go out of bounds to the right edge of
the screen but when I maximize windows it sticks to 1280x1024. When I
start gnome-display-properties that invisible right portion of the
screen dissapears.


--=-VvVq7WiiE4PudwTTyALl
Content-Disposition: attachment; filename="dmesg.drm.35"
Content-Type: text/plain; name="dmesg.drm.35"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

[    0.000000] Linux version 2.6.35.3-DELL (root@vostro) (gcc version 4.5.1 (GCC) ) #1 SMP PREEMPT Sat Aug 21 01:38:46 CEST 2010
[    0.000000] Command line: root=/dev/sda1 ro video=LVDS-1:d drm.debug=0x6
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007f6d0000 (usable)
[    0.000000]  BIOS-e820: 000000007f6d0000 - 000000007f6e3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007f6e3000 - 0000000080000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
[    0.000000]  BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] e820 update range: 0000000000000000 - 0000000000001000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x7f6d0 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 07F700000 mask FFFF00000 uncachable
[    0.000000]   2 base 07F800000 mask FFF800000 uncachable
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 0000000000001000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 000000000009f800 (usable)
[    0.000000]  modified: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 000000007f6d0000 (usable)
[    0.000000]  modified: 000000007f6d0000 - 000000007f6e3000 (ACPI NVS)
[    0.000000]  modified: 000000007f6e3000 - 0000000080000000 (reserved)
[    0.000000]  modified: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  modified: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  modified: 00000000fed00000 - 00000000fed00400 (reserved)
[    0.000000]  modified: 00000000fed14000 - 00000000fed1a000 (reserved)
[    0.000000]  modified: 00000000fed1c000 - 00000000fed90000 (reserved)
[    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  modified: 00000000ff000000 - 0000000100000000 (reserved)
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] found SMP MP-table at [ffff8800000f7680] f7680
[    0.000000] init_memory_mapping: 0000000000000000-000000007f6d0000
[    0.000000]  0000000000 - 007f600000 page 2M
[    0.000000]  007f600000 - 007f6d0000 page 4k
[    0.000000] kernel direct mapping tables up to 7f6d0000 @ 16000-1a000
[    0.000000] RAMDISK: 37ec9000 - 37ff0000
[    0.000000] ACPI: RSDP 00000000000f7600 00024 (v02 DELL  )
[    0.000000] ACPI: XSDT 000000007f6d6873 00094 (v01 DELL    M08     06040000  LTP 00000000)
[    0.000000] ACPI: FACP 000000007f6decd6 000F4 (v03 TOSCPL CRESTLNE 06040000 ALAN 00000001)
[    0.000000] ACPI: DSDT 000000007f6d7db1 06EB1 (v02 TOSCPL CRESTLNE 06040000 INTL 20060608)
[    0.000000] ACPI: FACS 000000007f6e2fc0 00040
[    0.000000] ACPI: APIC 000000007f6dedca 00068 (v01 INTEL  CRESTLNE 06040000 LOHR 0000005A)
[    0.000000] ACPI: HPET 000000007f6dee32 00038 (v01 INTEL  CRESTLNE 06040000 LOHR 0000005A)
[    0.000000] ACPI: MCFG 000000007f6dee6a 0003C (v01 INTEL  CRESTLNE 06040000 LOHR 0000005A)
[    0.000000] ACPI: TCPA 000000007f6deea6 00032 (v01 Intel  CRESTLNE 06040000 LOHR 0000005A)
[    0.000000] ACPI: TMOR 000000007f6deed8 00026 (v01 PTLTD           06040000 PTL  00000003)
[    0.000000] ACPI: OSFR 000000007f6deefe 00072 (v01 TOSHIB A+2nd ID 06040000 TASM 04010000)
[    0.000000] ACPI: APIC 000000007f6def70 00068 (v01 PTLTD  ? APIC   06040000  LTP 00000000)
[    0.000000] ACPI: BOOT 000000007f6defd8 00028 (v01 PTLTD  $SBFTBL$ 06040000  LTP 00000001)
[    0.000000] ACPI: SSDT 000000007f6d7b04 002AD (v01 SataRe SataAhci 00001000 INTL 20061109)
[    0.000000] ACPI: SSDT 000000007f6d7a61 000A3 (v01 BrtRef  DD01BRT 00001000 INTL 20061109)
[    0.000000] ACPI: SSDT 000000007f6d6e93 0025F (v01  PmRef  Cpu0Tst 00003000 INTL 20061109)
[    0.000000] ACPI: SSDT 000000007f6d6ded 000A6 (v01  PmRef  Cpu1Tst 00003000 INTL 20061109)
[    0.000000] ACPI: SSDT 000000007f6d6907 004E6 (v01  PmRef    CpuPm 00003000 INTL 20061109)
[    0.000000] ACPI: BIOS bug: multiple APIC/MADT found, using 0
[    0.000000] ACPI: If "acpi_apic_instance=2" works better, notify linux-acpi@vger.kernel.org
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000]  [ffffea0000000000-ffffea0001bfffff] PMD -> [ffff880001e00000-ffff8800039fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   empty
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0007f6d0
[    0.000000] On node 0 totalpages: 521823
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3927 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 7080 pages used for memmap
[    0.000000]   DMA32 zone: 510760 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] early_res array is doubled to 64 at [18000 - 187ff]
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000dc000
[    0.000000] PM: Registered nosave memory: 00000000000dc000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 80000000 (gap: 80000000:60000000)
[    0.000000] setup_percpu: NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff880001800000 s81024 r8192 d21376 u1048576
[    0.000000] pcpu-alloc: s81024 r8192 d21376 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 514687
[    0.000000] Kernel command line: root=/dev/sda1 ro video=LVDS-1:d drm.debug=0x6
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.000000] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Subtract (51 early reservations)
[    0.000000]   #1 [0001000000 - 00015ef0b8]   TEXT DATA BSS
[    0.000000]   #2 [0037ec9000 - 0037ff0000]         RAMDISK
[    0.000000]   #3 [00015f0000 - 00015f0184]             BRK
[    0.000000]   #4 [00000f7690 - 0000100000]   BIOS reserved
[    0.000000]   #5 [00000f7680 - 00000f7690]    MP-table mpf
[    0.000000]   #6 [000009f800 - 000009fd71]   BIOS reserved
[    0.000000]   #7 [000009ff15 - 00000f7680]   BIOS reserved
[    0.000000]   #8 [000009fd71 - 000009ff15]    MP-table mpc
[    0.000000]   #9 [0000010000 - 0000012000]      TRAMPOLINE
[    0.000000]   #10 [0000012000 - 0000016000]     ACPI WAKEUP
[    0.000000]   #11 [0000016000 - 0000018000]         PGTABLE
[    0.000000]   #12 [00015f01c0 - 00015f11c0]         BOOTMEM
[    0.000000]   #13 [00015ef0c0 - 00015ef1c0]         BOOTMEM
[    0.000000]   #14 [0001df2000 - 0001df3000]         BOOTMEM
[    0.000000]   #15 [0001df3000 - 0001df4000]         BOOTMEM
[    0.000000]   #16 [0001e00000 - 0003a00000]        MEMMAP 0
[    0.000000]   #17 [00015ef1c0 - 00015ef340]         BOOTMEM
[    0.000000]   #18 [00015f11c0 - 00015fd1c0]         BOOTMEM
[    0.000000]   #19 [00015fe000 - 00015ff000]         BOOTMEM
[    0.000000]   #20 [00015ef340 - 00015ef381]         BOOTMEM
[    0.000000]   #21 [00015ef3c0 - 00015ef403]         BOOTMEM
[    0.000000]   #22 [00015ef440 - 00015ef750]         BOOTMEM
[    0.000000]   #23 [00015ef780 - 00015ef7e8]         BOOTMEM
[    0.000000]   #24 [00015ef800 - 00015ef868]         BOOTMEM
[    0.000000]   #25 [00015ef880 - 00015ef8e8]         BOOTMEM
[    0.000000]   #26 [00015ef900 - 00015ef968]         BOOTMEM
[    0.000000]   #27 [00015ef980 - 00015ef9e8]         BOOTMEM
[    0.000000]   #28 [00015efa00 - 00015efa68]         BOOTMEM
[    0.000000]   #29 [00015efa80 - 00015efae8]         BOOTMEM
[    0.000000]   #30 [00015efb00 - 00015efb68]         BOOTMEM
[    0.000000]   #31 [00015efb80 - 00015efbe8]         BOOTMEM
[    0.000000]   #32 [00015efc00 - 00015efc68]         BOOTMEM
[    0.000000]   #33 [00015efc80 - 00015efce8]         BOOTMEM
[    0.000000]   #34 [00015efd00 - 00015efd68]         BOOTMEM
[    0.000000]   #35 [00015efd80 - 00015efde8]         BOOTMEM
[    0.000000]   #36 [00015efe00 - 00015efe20]         BOOTMEM
[    0.000000]   #37 [00015efe40 - 00015efe6f]         BOOTMEM
[    0.000000]   #38 [00015efe80 - 00015efeaf]         BOOTMEM
[    0.000000]   #39 [0001800000 - 000181b000]         BOOTMEM
[    0.000000]   #40 [0001900000 - 000191b000]         BOOTMEM
[    0.000000]   #41 [00015efec0 - 00015efec8]         BOOTMEM
[    0.000000]   #42 [00015eff00 - 00015eff08]         BOOTMEM
[    0.000000]   #43 [00015eff40 - 00015eff48]         BOOTMEM
[    0.000000]   #44 [00015eff80 - 00015eff90]         BOOTMEM
[    0.000000]   #45 [00015fd1c0 - 00015fd300]         BOOTMEM
[    0.000000]   #46 [00015fd300 - 00015fd360]         BOOTMEM
[    0.000000]   #47 [00015fd380 - 00015fd3e0]         BOOTMEM
[    0.000000]   #48 [00015ff000 - 0001607000]         BOOTMEM
[    0.000000]   #49 [000191b000 - 0001b1b000]         BOOTMEM
[    0.000000]   #50 [0001607000 - 0001707000]         BOOTMEM
[    0.000000] Memory: 2047940k/2087744k available (3080k kernel code, 452k absent, 39352k reserved, 1552k data, 432k init)
[    0.000000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Preemptable hierarchical RCU implementation.
[    0.000000] 	RCU-based detection of stalled CPUs is disabled.
[    0.000000] 	Verbose stalled-CPUs detection is disabled.
[    0.000000] NR_IRQS:320
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 1795.495 MHz processor.
[    0.001006] Calibrating delay loop (skipped), value calculated using timer frequency.. 3590.99 BogoMIPS (lpj=1795495)
[    0.001126] pid_max: default: 32768 minimum: 301
[    0.001205] Security Framework initialized
[    0.001271] Mount-cache hash table entries: 256
[    0.001493] CPU: Physical Processor ID: 0
[    0.001551] CPU: Processor Core ID: 0
[    0.001609] mce: CPU supports 6 MCE banks
[    0.001669] CPU0: Thermal monitoring handled by SMI
[    0.001673] using mwait in idle threads.
[    0.002004] Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
[    0.003099] PEBS disabled due to CPU errata.
[    0.003158] ... version:                2
[    0.003215] ... bit width:              40
[    0.003271] ... generic registers:      2
[    0.003326] ... value mask:             000000ffffffffff
[    0.003385] ... max period:             000000007fffffff
[    0.003443] ... fixed-purpose events:   3
[    0.003500] ... event mask:             0000000700000003
[    0.003599] ACPI: Core revision 20100428
[    0.014059] Setting APIC routing to flat
[    0.015330] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.025399] CPU0: Intel(R) Core(TM)2 Duo CPU     T5670  @ 1.80GHz stepping 0d
[    0.030023] Booting Node   0, Processors  #1 Ok.
[    0.001999] CPU1: Thermal monitoring handled by SMI
[    0.102018] Brought up 2 CPUs
[    0.102075] Total of 2 processors activated (7181.81 BogoMIPS).
[    0.102534] devtmpfs: initialized
[    0.103032] NET: Registered protocol family 16
[    0.103226] ACPI: bus type pci registered
[    0.103367] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.103443] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.123666] PCI: Using configuration type 1 for base access
[    0.124187] bio: create slab <bio-0> at 0
[    0.126242] ACPI: EC: Look up EC in DSDT
[    0.131065] ACPI: BIOS _OSI(Linux) query ignored
[    0.132811] ACPI: SSDT 000000007f6d7761 00238 (v01  PmRef  Cpu0Ist 00003000 INTL 20061109)
[    0.133460] ACPI: Dynamic OEM Table Load:
[    0.133600] ACPI: SSDT (null) 00238 (v01  PmRef  Cpu0Ist 00003000 INTL 20061109)
[    0.134068] ACPI: SSDT 000000007f6d70f2 005EA (v01  PmRef  Cpu0Cst 00003001 INTL 20061109)
[    0.134689] ACPI: Dynamic OEM Table Load:
[    0.134830] ACPI: SSDT (null) 005EA (v01  PmRef  Cpu0Cst 00003001 INTL 20061109)
[    0.135447] ACPI: SSDT 000000007f6d7999 000C8 (v01  PmRef  Cpu1Ist 00003000 INTL 20061109)
[    0.136087] ACPI: Dynamic OEM Table Load:
[    0.136224] ACPI: SSDT (null) 000C8 (v01  PmRef  Cpu1Ist 00003000 INTL 20061109)
[    0.136532] ACPI: SSDT 000000007f6d76dc 00085 (v01  PmRef  Cpu1Cst 00003000 INTL 20061109)
[    0.137158] ACPI: Dynamic OEM Table Load:
[    0.137293] ACPI: SSDT (null) 00085 (v01  PmRef  Cpu1Cst 00003000 INTL 20061109)
[    0.137729] ACPI: Interpreter enabled
[    0.137786] ACPI: (supports S0 S3 S4 S5)
[    0.138005] ACPI: Using IOAPIC for interrupt routing
[    0.220881] ACPI: EC: GPE = 0x1c, I/O: command/status = 0x66, data = 0x62
[    0.221249] ACPI: No dock devices found.
[    0.221308] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.222050] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.223405] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.223468] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.223527] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.223600] pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x000d3fff]
[    0.223670] pci_root PNP0A08:00: host bridge window [mem 0x000d4000-0x000d7fff]
[    0.223739] pci_root PNP0A08:00: host bridge window [mem 0x000d8000-0x000dbfff]
[    0.223811] pci_root PNP0A08:00: host bridge window [mem 0x80000000-0xdfffffff]
[    0.223882] pci_root PNP0A08:00: host bridge window [mem 0xf0000000-0xfebfffff]
[    0.224024] pci 0000:00:02.0: reg 10: [mem 0xf8000000-0xf80fffff 64bit]
[    0.224033] pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.224039] pci 0000:00:02.0: reg 20: [io  0x1800-0x1807]
[    0.224081] pci 0000:00:02.1: reg 10: [mem 0xf8100000-0xf81fffff 64bit]
[    0.224204] pci 0000:00:1a.0: reg 20: [io  0x1820-0x183f]
[    0.224273] pci 0000:00:1a.1: reg 20: [io  0x1840-0x185f]
[    0.224338] pci 0000:00:1a.7: reg 10: [mem 0xf8504800-0xf8504bff]
[    0.224404] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.224410] pci 0000:00:1a.7: PME# disabled
[    0.224458] pci 0000:00:1b.0: reg 10: [mem 0xf8500000-0xf8503fff 64bit]
[    0.224526] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.224531] pci 0000:00:1b.0: PME# disabled
[    0.224636] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.224642] pci 0000:00:1c.0: PME# disabled
[    0.224749] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.224755] pci 0000:00:1c.1: PME# disabled
[    0.224866] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.224871] pci 0000:00:1c.3: PME# disabled
[    0.224979] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.224985] pci 0000:00:1c.4: PME# disabled
[    0.225056] pci 0000:00:1d.0: reg 20: [io  0x1860-0x187f]
[    0.225126] pci 0000:00:1d.1: reg 20: [io  0x1880-0x189f]
[    0.225188] pci 0000:00:1d.2: reg 20: [io  0x18a0-0x18bf]
[    0.225254] pci 0000:00:1d.7: reg 10: [mem 0xf8504c00-0xf8504fff]
[    0.225325] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.225331] pci 0000:00:1d.7: PME# disabled
[    0.225499] pci 0000:00:1f.0: quirk: [io  0x1000-0x107f] claimed by ICH6 ACPI/GPIO/TCO
[    0.225574] pci 0000:00:1f.0: quirk: [io  0x1180-0x11bf] claimed by ICH6 GPIO
[    0.225637] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0680 (mask 007f)
[    0.225709] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 1640 (mask 007f)
[    0.225834] pci 0000:00:1f.1: reg 10: [io  0x0000-0x0007]
[    0.225843] pci 0000:00:1f.1: reg 14: [io  0x0000-0x0003]
[    0.225852] pci 0000:00:1f.1: reg 18: [io  0x0000-0x0007]
[    0.225861] pci 0000:00:1f.1: reg 1c: [io  0x0000-0x0003]
[    0.225870] pci 0000:00:1f.1: reg 20: [io  0x1810-0x181f]
[    0.225937] pci 0000:00:1f.2: reg 10: [io  0x1c00-0x1c07]
[    0.225945] pci 0000:00:1f.2: reg 14: [io  0x18d4-0x18d7]
[    0.225953] pci 0000:00:1f.2: reg 18: [io  0x18d8-0x18df]
[    0.225962] pci 0000:00:1f.2: reg 1c: [io  0x18d0-0x18d3]
[    0.225970] pci 0000:00:1f.2: reg 20: [io  0x18e0-0x18ff]
[    0.225978] pci 0000:00:1f.2: reg 24: [mem 0xf8504000-0xf85047ff]
[    0.226029] pci 0000:00:1f.2: PME# supported from D3hot
[    0.226035] pci 0000:00:1f.2: PME# disabled
[    0.226070] pci 0000:00:1f.3: reg 10: [mem 0x00000000-0x000000ff]
[    0.226097] pci 0000:00:1f.3: reg 20: [io  0x1c20-0x1c3f]
[    0.226193] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.226255] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.226262] pci 0000:00:1c.0:   bridge window [mem 0xc4000000-0xc7ffffff]
[    0.226271] pci 0000:00:1c.0:   bridge window [mem 0xcc000000-0xcdffffff 64bit pref]
[    0.226340] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.226399] pci 0000:00:1c.1:   bridge window [io  0x3000-0x3fff]
[    0.226405] pci 0000:00:1c.1:   bridge window [mem 0xf0000000-0xf3ffffff]
[    0.226413] pci 0000:00:1c.1:   bridge window [mem 0xfa000000-0xfbffffff 64bit pref]
[    0.226617] pci 0000:06:00.0: reg 10: [mem 0xf4000000-0xf4000fff]
[    0.226859] pci 0000:06:00.0: PME# supported from D0 D3hot D3cold
[    0.226872] pci 0000:06:00.0: PME# disabled
[    0.226932] pci 0000:06:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.227034] pci 0000:00:1c.3: PCI bridge to [bus 06-06]
[    0.227096] pci 0000:00:1c.3:   bridge window [io  0x4000-0x4fff]
[    0.227101] pci 0000:00:1c.3:   bridge window [mem 0xf4000000-0xf7ffffff]
[    0.227109] pci 0000:00:1c.3:   bridge window [mem 0xfc000000-0xfdffffff 64bit pref]
[    0.227286] pci 0000:07:00.0: reg 10: [io  0x5000-0x50ff]
[    0.227364] pci 0000:07:00.0: reg 18: [mem 0xf8610000-0xf8610fff 64bit pref]
[    0.227417] pci 0000:07:00.0: reg 20: [mem 0xf8600000-0xf860ffff 64bit pref]
[    0.227445] pci 0000:07:00.0: reg 30: [mem 0x00000000-0x0000ffff pref]
[    0.227597] pci 0000:07:00.0: supports D1 D2
[    0.227600] pci 0000:07:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.227616] pci 0000:07:00.0: PME# disabled
[    0.227755] pci 0000:00:1c.4: PCI bridge to [bus 07-07]
[    0.227818] pci 0000:00:1c.4:   bridge window [io  0x5000-0x5fff]
[    0.227824] pci 0000:00:1c.4:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.227834] pci 0000:00:1c.4:   bridge window [mem 0xf8600000-0xf86fffff 64bit pref]
[    0.227908] pci 0000:08:05.0: reg 10: [mem 0xf8200000-0xf8200fff]
[    0.227917] pci 0000:08:05.0: reg 14: [mem 0xf8202000-0xf82027ff]
[    0.227975] pci 0000:08:05.0: supports D1 D2
[    0.227977] pci 0000:08:05.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.227983] pci 0000:08:05.0: PME# disabled
[    0.228036] pci 0000:08:05.2: reg 10: [mem 0xf8202800-0xf82028ff]
[    0.228108] pci 0000:08:05.2: supports D1 D2
[    0.228110] pci 0000:08:05.2: PME# supported from D0 D1 D2 D3hot D3cold
[    0.228117] pci 0000:08:05.2: PME# disabled
[    0.228158] pci 0000:08:05.3: reg 10: [mem 0xf8201000-0xf8201fff]
[    0.228230] pci 0000:08:05.3: supports D1 D2
[    0.228232] pci 0000:08:05.3: PME# supported from D0 D1 D2 D3hot D3cold
[    0.228239] pci 0000:08:05.3: PME# disabled
[    0.228302] pci 0000:00:1e.0: PCI bridge to [bus 08-08] (subtractive decode)
[    0.228366] pci 0000:00:1e.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.228372] pci 0000:00:1e.0:   bridge window [mem 0xf8200000-0xf82fffff]
[    0.228381] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.228385] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.228388] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.228392] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.228395] pci 0000:00:1e.0:   bridge window [mem 0x000d0000-0x000d3fff] (subtractive decode)
[    0.228399] pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive decode)
[    0.228402] pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
[    0.228405] pci 0000:00:1e.0:   bridge window [mem 0x80000000-0xdfffffff] (subtractive decode)
[    0.228409] pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xfebfffff] (subtractive decode)
[    0.228443] pci_bus 0000:00: on NUMA node 0
[    0.228450] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.228742] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.228837] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    0.228936] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP04._PRT]
[    0.229038] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP05._PRT]
[    0.229178] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
[    0.243584] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 *5 6 7 10 12 14 15)
[    0.244244] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    0.244899] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 *10 12 14 15)
[    0.245524] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    0.246203] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
[    0.246946] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    0.247606] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 *10 12 14 15)
[    0.248242] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
[    0.248957] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.249019] vgaarb: loaded
[    0.249089] PCI: Using ACPI for IRQ routing
[    0.249102] PCI: pci_cache_line_size set to 64 bytes
[    0.249247] reserve RAM buffer: 000000000009f800 - 000000000009ffff 
[    0.249250] reserve RAM buffer: 000000007f6d0000 - 000000007fffffff 
[    0.249367] NetLabel: Initializing
[    0.249426] NetLabel:  domain hash size = 128
[    0.249482] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.249556] NetLabel:  unlabeled traffic allowed by default
[    0.249617] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.249684] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.249900] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.254024] Switching to clocksource tsc
[    0.255735] pnp: PnP ACPI init
[    0.255798] ACPI: bus type pnp registered
[    0.287013] pnp: PnP ACPI: found 10 devices
[    0.287070] ACPI: ACPI bus type pnp unregistered
[    0.287136] system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.287197] system 00:01: [mem 0xfed14000-0xfed17fff] has been reserved
[    0.287257] system 00:01: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.287317] system 00:01: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.287380] system 00:01: [mem 0xe0000000-0xefffffff] has been reserved
[    0.287440] system 00:01: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.287503] system 00:01: [mem 0xfed40000-0xfed44fff] has been reserved
[    0.287563] system 00:01: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.287629] system 00:04: [mem 0xfed00000-0xfed003ff] has been reserved
[    0.287695] system 00:06: [io  0x0680-0x069f] has been reserved
[    0.287755] system 00:06: [io  0x0800-0x080f] has been reserved
[    0.287819] system 00:06: [io  0x1000-0x107f] has been reserved
[    0.287877] system 00:06: [io  0x1180-0x11bf] has been reserved
[    0.287937] system 00:06: [io  0xfe00] has been reserved
[    0.287995] system 00:06: [io  0xff00-0xff7f] has been reserved
[    0.292877] pci 0000:00:1c.4: BAR 8: assigned [mem 0x80000000-0x803fffff]
[    0.292941] pci 0000:00:1f.3: BAR 0: assigned [mem 0x80400000-0x804000ff]
[    0.293005] pci 0000:00:1f.3: BAR 0: set to [mem 0x80400000-0x804000ff] (PCI address [0x80400000-0x804000ff]
[    0.293079] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.293139] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.293201] pci 0000:00:1c.0:   bridge window [mem 0xc4000000-0xc7ffffff]
[    0.293265] pci 0000:00:1c.0:   bridge window [mem 0xcc000000-0xcdffffff 64bit pref]
[    0.293340] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.293400] pci 0000:00:1c.1:   bridge window [io  0x3000-0x3fff]
[    0.293462] pci 0000:00:1c.1:   bridge window [mem 0xf0000000-0xf3ffffff]
[    0.293527] pci 0000:00:1c.1:   bridge window [mem 0xfa000000-0xfbffffff 64bit pref]
[    0.293606] pci 0000:00:1c.3: PCI bridge to [bus 06-06]
[    0.293666] pci 0000:00:1c.3:   bridge window [io  0x4000-0x4fff]
[    0.293730] pci 0000:00:1c.3:   bridge window [mem 0xf4000000-0xf7ffffff]
[    0.293796] pci 0000:00:1c.3:   bridge window [mem 0xfc000000-0xfdffffff 64bit pref]
[    0.293872] pci 0000:07:00.0: BAR 6: assigned [mem 0xf8620000-0xf862ffff pref]
[    0.293943] pci 0000:00:1c.4: PCI bridge to [bus 07-07]
[    0.294002] pci 0000:00:1c.4:   bridge window [io  0x5000-0x5fff]
[    0.294064] pci 0000:00:1c.4:   bridge window [mem 0x80000000-0x803fffff]
[    0.294129] pci 0000:00:1c.4:   bridge window [mem 0xf8600000-0xf86fffff 64bit pref]
[    0.294207] pci 0000:00:1e.0: PCI bridge to [bus 08-08]
[    0.294264] pci 0000:00:1e.0:   bridge window [io  disabled]
[    0.294326] pci 0000:00:1e.0:   bridge window [mem 0xf8200000-0xf82fffff]
[    0.294390] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    0.294469] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.294532] pci 0000:00:1c.0: setting latency timer to 64
[    0.294546] pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.294612] pci 0000:00:1c.1: setting latency timer to 64
[    0.294624] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    0.294690] pci 0000:00:1c.3: setting latency timer to 64
[    0.294702] pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.294763] pci 0000:00:1c.4: setting latency timer to 64
[    0.294772] pci 0000:00:1e.0: setting latency timer to 64
[    0.294777] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.294784] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.294787] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.294790] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000d3fff]
[    0.294792] pci_bus 0000:00: resource 8 [mem 0x000d4000-0x000d7fff]
[    0.294795] pci_bus 0000:00: resource 9 [mem 0x000d8000-0x000dbfff]
[    0.294798] pci_bus 0000:00: resource 10 [mem 0x80000000-0xdfffffff]
[    0.294801] pci_bus 0000:00: resource 11 [mem 0xf0000000-0xfebfffff]
[    0.294804] pci_bus 0000:02: resource 0 [io  0x2000-0x2fff]
[    0.294807] pci_bus 0000:02: resource 1 [mem 0xc4000000-0xc7ffffff]
[    0.294810] pci_bus 0000:02: resource 2 [mem 0xcc000000-0xcdffffff 64bit pref]
[    0.294813] pci_bus 0000:03: resource 0 [io  0x3000-0x3fff]
[    0.294816] pci_bus 0000:03: resource 1 [mem 0xf0000000-0xf3ffffff]
[    0.294819] pci_bus 0000:03: resource 2 [mem 0xfa000000-0xfbffffff 64bit pref]
[    0.294822] pci_bus 0000:06: resource 0 [io  0x4000-0x4fff]
[    0.294824] pci_bus 0000:06: resource 1 [mem 0xf4000000-0xf7ffffff]
[    0.294827] pci_bus 0000:06: resource 2 [mem 0xfc000000-0xfdffffff 64bit pref]
[    0.294830] pci_bus 0000:07: resource 0 [io  0x5000-0x5fff]
[    0.294833] pci_bus 0000:07: resource 1 [mem 0x80000000-0x803fffff]
[    0.294836] pci_bus 0000:07: resource 2 [mem 0xf8600000-0xf86fffff 64bit pref]
[    0.294839] pci_bus 0000:08: resource 1 [mem 0xf8200000-0xf82fffff]
[    0.294842] pci_bus 0000:08: resource 4 [io  0x0000-0x0cf7]
[    0.294845] pci_bus 0000:08: resource 5 [io  0x0d00-0xffff]
[    0.294848] pci_bus 0000:08: resource 6 [mem 0x000a0000-0x000bffff]
[    0.294850] pci_bus 0000:08: resource 7 [mem 0x000d0000-0x000d3fff]
[    0.294853] pci_bus 0000:08: resource 8 [mem 0x000d4000-0x000d7fff]
[    0.294856] pci_bus 0000:08: resource 9 [mem 0x000d8000-0x000dbfff]
[    0.294859] pci_bus 0000:08: resource 10 [mem 0x80000000-0xdfffffff]
[    0.294862] pci_bus 0000:08: resource 11 [mem 0xf0000000-0xfebfffff]
[    0.294897] NET: Registered protocol family 2
[    0.295013] IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.295507] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.297817] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.298420] TCP: Hash tables configured (established 262144 bind 65536)
[    0.298480] TCP reno registered
[    0.298537] UDP hash table entries: 1024 (order: 3, 32768 bytes)
[    0.298613] UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
[    0.298834] NET: Registered protocol family 1
[    0.298914] pci 0000:00:02.0: Boot video device
[    0.299126] PCI: CLS 64 bytes, default 64
[    0.299193] Unpacking initramfs...
[    0.567254] Freeing initrd memory: 1180k freed
[    0.567922] Simple Boot Flag at 0x36 set to 0x1
[    0.568346] Scanning for low memory corruption every 60 seconds
[    0.568558] audit: initializing netlink socket (disabled)
[    0.568631] type=2000 audit(1282639812.566:1): initialized
[    0.570568] VFS: Disk quotas dquot_6.5.2
[    0.570695] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.570882] msgmni has been set to 4002
[    0.571093] alg: No test for stdrng (krng)
[    0.571211] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
[    0.571287] io scheduler noop registered
[    0.571346] io scheduler deadline registered
[    0.573288] io scheduler cfq registered (default)
[    0.573471] pcieport 0000:00:1c.0: setting latency timer to 64
[    0.573535] pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
[    0.573650] pcieport 0000:00:1c.1: setting latency timer to 64
[    0.573706] pcieport 0000:00:1c.1: irq 41 for MSI/MSI-X
[    0.573821] pcieport 0000:00:1c.3: setting latency timer to 64
[    0.573878] pcieport 0000:00:1c.3: irq 42 for MSI/MSI-X
[    0.573992] pcieport 0000:00:1c.4: setting latency timer to 64
[    0.574049] pcieport 0000:00:1c.4: irq 43 for MSI/MSI-X
[    0.574294] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input0
[    0.574457] ACPI: Lid Switch [LID0]
[    0.574577] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input1
[    0.574653] ACPI: Power Button [PWRB]
[    0.574772] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input2
[    0.574847] ACPI: Sleep Button [SLPB]
[    0.574998] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    0.575072] ACPI: Power Button [PWRF]
[    0.577070] Linux agpgart interface v0.103
[    0.577207] agpgart-intel 0000:00:00.0: Intel 965GM Chipset
[    0.577985] agpgart-intel 0000:00:00.0: detected 7676K stolen memory
[    0.582501] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    0.582622] [drm] Initialized drm 1.1.0 20060810
[    0.582703] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.582782] i915 0000:00:02.0: setting latency timer to 64
[    0.619477] [drm:i915_init_phys_hws], Enabled hardware status page
[    0.619501] i915 0000:00:02.0: irq 44 for MSI/MSI-X
[    0.619515] [drm] set up 7M of stolen space
[    0.619759] [drm:i915_gtt_to_phys], GTT addr: 0x00000000, PTE: 0x7f800001
[    0.619794] [drm:i915_gtt_to_phys], GTT addr: 0x00000000, phys addr: 0x7f800000
[    0.619859] [drm:i915_gtt_to_phys], GTT addr: 0x006c8000, PTE: 0x7abc4001
[    0.619896] [drm:i915_gtt_to_phys], GTT addr: 0x006c8000, phys addr: 0x7abc4000
[    0.619929] [drm:parse_general_definitions], crt_ddc_bus_pin: 2
[    0.619935] [drm:parse_lfp_panel_data], Found panel mode in BIOS VBT tables:
[    0.619939] [drm:drm_mode_debug_printmodeline], Modeline 0:"1280x800" 0 69300 1280 1304 1336 1416 800 804 810 817 0x8 0xa
[    0.619954] [drm:parse_sdvo_device_mapping], No SDVO device info is found in VBT
[    0.619969] [drm:intel_modeset_init], 2 display pipes available.
[    0.725893] [drm] initialized overlay support
[    0.747033] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 1
[    0.768033] [drm:drm_fb_helper_connector_parse_command_line], cmdline mode for connector LVDS-1 0x0@60Hz
[    0.768038] [drm] forcing LVDS-1 connector OFF
[    0.768099] [drm:drm_helper_probe_single_connector_modes], VGA-1
[    0.881470] [drm:drm_helper_probe_single_connector_modes], Probed modes for VGA-1
[    0.881473] [drm:drm_mode_debug_printmodeline], Modeline 30:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[    0.881480] [drm:drm_mode_debug_printmodeline], Modeline 40:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[    0.881486] [drm:drm_mode_debug_printmodeline], Modeline 31:"1280x960" 60 108000 1280 1376 1488 1800 960 961 964 1000 0x40 0x5
[    0.881492] [drm:drm_mode_debug_printmodeline], Modeline 47:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[    0.881498] [drm:drm_mode_debug_printmodeline], Modeline 41:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[    0.881503] [drm:drm_mode_debug_printmodeline], Modeline 42:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[    0.881509] [drm:drm_mode_debug_printmodeline], Modeline 43:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[    0.881515] [drm:drm_mode_debug_printmodeline], Modeline 44:"832x624" 75 57284 832 864 928 1152 624 625 628 667 0x40 0xa
[    0.881521] [drm:drm_mode_debug_printmodeline], Modeline 46:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[    0.881526] [drm:drm_mode_debug_printmodeline], Modeline 45:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[    0.881532] [drm:drm_mode_debug_printmodeline], Modeline 33:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[    0.881538] [drm:drm_mode_debug_printmodeline], Modeline 34:"800x600" 56 36000 800 824 896 1024 600 601 603 625 0x40 0x5
[    0.881544] [drm:drm_mode_debug_printmodeline], Modeline 36:"640x480" 73 31500 640 664 704 832 480 489 491 520 0x40 0xa
[    0.881549] [drm:drm_mode_debug_printmodeline], Modeline 35:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[    0.881555] [drm:drm_mode_debug_printmodeline], Modeline 37:"640x480" 67 30240 640 704 768 864 480 483 486 525 0x40 0xa
[    0.881560] [drm:drm_mode_debug_printmodeline], Modeline 38:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[    0.881566] [drm:drm_mode_debug_printmodeline], Modeline 39:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[    0.881572] [drm:drm_helper_probe_single_connector_modes], LVDS-1
[    0.881575] [drm:drm_helper_probe_single_connector_modes], LVDS-1 is disconnected
[    0.881580] [drm:drm_helper_probe_single_connector_modes], SVIDEO-1
[    0.881588] [drm:intel_update_watermarks], plane A (pipe 0) clock: 107520
[    0.881592] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 40
[    0.881596] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 0
[    0.902264] [drm:intel_crtc_mode_set], Mode for pipe A:
[    0.902267] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[    0.922871] [drm:intel_pipe_set_base], No FB bound
[    0.922874] [drm:intel_update_fbc], 
[    0.922876] [drm:intel_update_watermarks], plane A (pipe 0) clock: 107520
[    0.922880] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 40
[    0.943886] [drm:intel_update_watermarks], plane A (pipe 0) clock: 107520
[    0.943890] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 40
[    0.943919] [drm:intel_update_fbc], 
[    1.006007] [drm:intel_tv_detect_type], No TV connection detected
[    1.027161] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 1
[    1.048160] [drm:drm_helper_probe_single_connector_modes], SVIDEO-1 is disconnected
[    1.048164] [drm:drm_setup_crtcs], 
[    1.048166] [drm:drm_enable_connectors], connector 5 enabled? yes
[    1.048170] [drm:drm_enable_connectors], connector 7 enabled? no
[    1.048173] [drm:drm_enable_connectors], connector 14 enabled? no
[    1.048176] [drm:drm_target_preferred], looking for cmdline mode on connector 5
[    1.048180] [drm:drm_target_preferred], looking for preferred mode on connector 5
[    1.048183] [drm:drm_target_preferred], found mode 1280x1024
[    1.048186] [drm:drm_setup_crtcs], picking CRTCs for 8192x8192 config
[    1.048191] [drm:drm_setup_crtcs], desired mode 1280x1024 set on crtc 3
[    1.054715] [drm:intelfb_create], allocated 1280x1024 fb: 0x007f0000, bo ffff88007f153c00
[    1.056230] [drm:drm_crtc_helper_set_config], 
[    1.056232] [drm:drm_crtc_helper_set_config], crtc: ffff88007f163000 3 fb: ffff88007f153ab0 connectors: ffff88007f200500 num_connectors: 1 (x, y) (0, 0)
[    1.056241] [drm:drm_crtc_helper_set_config], crtc has no fb, full mode set
[    1.056244] [drm:drm_crtc_helper_set_config], modes are different, full mode set
[    1.056246] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[    1.056255] [drm:drm_mode_debug_printmodeline], Modeline 10:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[    1.056262] [drm:drm_crtc_helper_set_config], encoder changed, full mode switch
[    1.056264] [drm:drm_crtc_helper_set_config], crtc changed, full mode switch
[    1.056267] [drm:drm_crtc_helper_set_config], setting connector 5 crtc to ffff88007f163000
[    1.056270] [drm:drm_crtc_helper_set_config], attempting to set mode from userspace
[    1.056273] [drm:drm_mode_debug_printmodeline], Modeline 10:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[    1.056284] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[    1.056287] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 40
[    1.056291] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 0
[    1.077405] [drm:intel_crtc_mode_set], Mode for pipe A:
[    1.077407] [drm:drm_mode_debug_printmodeline], Modeline 10:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[    1.098011] [drm:intel_pipe_set_base], Writing base 007F0000 00000000 0 0 5120
[    1.098015] [drm:intel_update_fbc], 
[    1.098017] [drm:intel_update_fbc], 1 pipes active
[    1.098020] [drm:intel_update_fbc], framebuffer not tiled, disabling compression
[    1.119010] [drm:intel_update_fbc], 
[    1.119012] [drm:intel_update_fbc], 1 pipes active
[    1.119014] [drm:intel_update_fbc], framebuffer not tiled, disabling compression
[    1.119017] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[    1.119020] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 40
[    1.119024] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[    1.119027] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 40
[    1.119055] [drm:intel_update_fbc], 
[    1.119057] [drm:intel_update_fbc], 1 pipes active
[    1.119060] [drm:intel_update_fbc], framebuffer not tiled, disabling compression
[    1.119066] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[    1.119069] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 40
[    1.119072] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 1
[    1.140160] [drm:drm_crtc_helper_set_config], 
[    1.140162] [drm:drm_crtc_helper_set_config], crtc: ffff88007f164000 4 fb: ffff88007f153ab0 connectors: ffff88007f200520 num_connectors: 0 (x, y) (0, 0)
[    1.140169] [drm:drm_crtc_helper_set_config], crtc has no fb, full mode set
[    1.140171] [drm:drm_crtc_helper_set_config], setting connector 5 crtc to ffff88007f163000
[    1.140176] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[    1.140179] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 40
[    1.140183] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 1
[    1.161181] [drm:drm_crtc_helper_set_config], 
[    1.161183] [drm:drm_crtc_helper_set_config], crtc: ffff88007f163000 3 fb: ffff88007f153ab0 connectors: ffff88007f200500 num_connectors: 1 (x, y) (0, 0)
[    1.161191] [drm:drm_crtc_helper_set_config], setting connector 5 crtc to ffff88007f163000
[    1.165173] [drm:drm_crtc_helper_set_config], 
[    1.165175] [drm:drm_crtc_helper_set_config], crtc: ffff88007f163000 3 fb: ffff88007f153ab0 connectors: ffff88007f200500 num_connectors: 1 (x, y) (0, 0)
[    1.165183] [drm:drm_crtc_helper_set_config], setting connector 5 crtc to ffff88007f163000
[    1.169157] Console: switching to colour frame buffer device 160x64
[    1.169163] [drm:drm_crtc_helper_set_config], 
[    1.169165] [drm:drm_crtc_helper_set_config], crtc: ffff88007f163000 3 fb: ffff88007f153ab0 connectors: ffff88007f200500 num_connectors: 1 (x, y) (0, 0)
[    1.169172] [drm:drm_crtc_helper_set_config], setting connector 5 crtc to ffff88007f163000
[    1.173189] fb0: inteldrmfb frame buffer device
[    1.173216] drm: registered panic notifier
[    1.173245] Slow work thread pool: Starting up
[    1.173322] Slow work thread pool: Ready
[    1.173355] [drm:intel_opregion_init], graphic opregion physical addr: 0x7f6dfe3c
[    1.173367] [drm:intel_opregion_init], Public ACPI methods supported
[    1.173680] [drm:intel_opregion_init], SWSCI supported
[    1.173683] [drm:intel_opregion_init], ASLE supported
[    1.192491] acpi device:07: registered as cooling_device0
[    1.192785] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:01/input/input4
[    1.192846] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[    1.192918] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    1.192986] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    1.193569] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    1.221981] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.222022] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.222120] mice: PS/2 mouse device common for all mice
[    1.222212] i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    1.222257] ACPI: resource 0000:00:1f.3 [io  0x1c20-0x1c3f] conflicts with ACPI region SMBI [mem 0x00001c20-0x00001c2f pref disabled]
[    1.222323] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    1.222411] cpuidle: using governor ladder
[    1.222439] cpuidle: using governor menu
[    1.222515] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[    1.222845] TCP cubic registered
[    1.222870] NET: Registered protocol family 17
[    1.223008] registered taskstats version 1
[    1.224980] Freeing unused kernel memory: 432k freed
[    1.231889] udev: starting version 161
[    1.250314] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input5
[    1.360691] SCSI subsystem initialized
[    1.487277] libata version 3.00 loaded.
[    1.493402] pata_acpi 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    1.493497] pata_acpi 0000:00:1f.1: setting latency timer to 64
[    1.493513] pata_acpi 0000:00:1f.1: PCI INT A disabled
[    1.496517] ata_piix 0000:00:1f.1: version 2.13
[    1.496537] ata_piix 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    1.496632] ata_piix 0000:00:1f.1: setting latency timer to 64
[    1.510635] scsi0 : ata_piix
[    1.525083] scsi1 : ata_piix
[    1.525941] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x1810 irq 14
[    1.525987] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x1818 irq 15
[    1.526096] ahci 0000:00:1f.2: version 3.0
[    1.526116] ahci 0000:00:1f.2: PCI INT B -> GSI 18 (level, low) -> IRQ 18
[    1.526224] ahci 0000:00:1f.2: irq 45 for MSI/MSI-X
[    1.526301] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 3 ports 3 Gbps 0x7 impl SATA mode
[    1.527798] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ccc 
[    1.529327] ahci 0000:00:1f.2: setting latency timer to 64
[    1.536428] scsi2 : ahci
[    1.542114] scsi3 : ahci
[    1.547737] scsi4 : ahci
[    1.549526] ata3: SATA max UDMA/133 abar m2048@0xf8504000 port 0xf8504100 irq 45
[    1.551138] ata4: SATA max UDMA/133 abar m2048@0xf8504000 port 0xf8504180 irq 45
[    1.552764] ata5: SATA max UDMA/133 abar m2048@0xf8504000 port 0xf8504200 irq 45
[    1.705369] ata1.00: ATAPI: TEAC   DVD+/-RW DVW28SLC, A.06, max UDMA/33
[    1.729271] ata1.00: configured for UDMA/33
[    1.745054] scsi 0:0:0:0: CD-ROM            TEAC     DVD+-RW DVW28SLC A.06 PQ: 0 ANSI: 5
[    1.866023] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.868311] ata3.00: unexpected _GTF length (8)
[    1.871021] ata4: SATA link down (SStatus 0 SControl 300)
[    1.873019] ata5: SATA link down (SStatus 0 SControl 300)
[    1.917856] ata3.00: ATA-8: WDC WD1600BEVT-75ZCT0, 11.01A11, max UDMA/133
[    1.919612] ata3.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    1.922336] ata3.00: unexpected _GTF length (8)
[    1.924390] ata3.00: configured for UDMA/133
[    1.937096] scsi 2:0:0:0: Direct-Access     ATA      WDC WD1600BEVT-7 11.0 PQ: 0 ANSI: 5
[    1.978528] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda caddy
[    1.980451] Uniform CD-ROM driver Revision: 3.20
[    1.982510] sr 0:0:0:0: Attached scsi CD-ROM sr0
[    1.982980] sd 2:0:0:0: [sda] 312581808 512-byte logical blocks: (160 GB/149 GiB)
[    1.985050] sd 2:0:0:0: [sda] Write Protect is off
[    1.987154] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.987188] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.989878]  sda: sda1 sda2 sda3 sda4
[    2.002911] sd 2:0:0:0: [sda] Attached SCSI disk
[    2.549098] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[    3.486696] rtc_cmos 00:07: RTC can wake from S4
[    3.486764] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
[    3.486802] rtc0: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    4.416514] udev: starting version 161
[    4.738938] iTCO_vendor_support: vendor-support=0
[    4.747542] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    4.747586] r8169 0000:07:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    4.747691] r8169 0000:07:00.0: setting latency timer to 64
[    4.747875] r8169 0000:07:00.0: irq 46 for MSI/MSI-X
[    4.748316] r8169 0000:07:00.0: eth0: RTL8168c/8111c at 0xffffc90010876000, 00:1c:23:4e:23:72, XID 1c4000c0 IRQ 46
[    4.758751] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.06
[    4.759235] iTCO_wdt: Found a ICH8M TCO device (Version=2, TCOBASE=0x1060)
[    4.759738] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    4.766029] ACPI: WMI: Mapper loaded
[    4.852348] usbcore: registered new interface driver usbfs
[    4.852377] usbcore: registered new interface driver hub
[    4.854971] input: PC Speaker as /devices/platform/pcspkr/input/input6
[    4.859522] ACPI: acpi_idle registered with cpuidle
[    4.870236] cfg80211: Calling CRDA to update world regulatory domain
[    4.882868] usbcore: registered new device driver usb
[    4.884959] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    4.885001] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    4.885056] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    4.885061] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    4.885177] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    4.885212] ehci_hcd 0000:00:1a.7: debug port 1
[    4.889115] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
[    4.889143] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xf8504800
[    4.899182] Monitor-Mwait will be used to enter C-1 state
[    4.915732] Monitor-Mwait will be used to enter C-2 state
[    4.919174] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    4.919396] hub 1-0:1.0: USB hub found
[    4.919403] hub 1-0:1.0: 4 ports detected
[    4.919545] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    4.919583] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    4.919587] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    4.919595] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    4.919632] ehci_hcd 0000:00:1d.7: debug port 1
[    4.941432] input: Dell WMI hotkeys as /devices/virtual/input/input7
[    4.943537] Monitor-Mwait will be used to enter C-3 state
[    4.943747] Marking TSC unstable due to TSC halts in idle
[    4.945845] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    4.945873] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xf8504c00
[    4.979049] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    4.979593] hub 2-0:1.0: USB hub found
[    4.979600] hub 2-0:1.0: 6 ports detected
[    5.007556] Switching to clocksource hpet
[    5.028759] ACPI: AC Adapter [ACAD] (on-line)
[    5.176613] ohci1394 0000:08:05.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    5.193970] sr 0:0:0:0: Attached scsi generic sg0 type 5
[    5.194013] sd 2:0:0:0: Attached scsi generic sg1 type 0
[    5.225074] uhci_hcd: USB Universal Host Controller Interface driver
[    5.225366] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    5.225376] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    5.225382] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    5.225392] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    5.225442] uhci_hcd 0000:00:1a.0: irq 16, io base 0x00001820
[    5.225686] hub 3-0:1.0: USB hub found
[    5.225693] hub 3-0:1.0: 2 ports detected
[    5.225841] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    5.225848] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    5.225853] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    5.225861] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    5.225901] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00001840
[    5.226141] hub 4-0:1.0: USB hub found
[    5.226147] hub 4-0:1.0: 2 ports detected
[    5.226287] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    5.226295] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    5.226299] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    5.226307] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
[    5.226365] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00001860
[    5.226674] hub 5-0:1.0: USB hub found
[    5.226680] hub 5-0:1.0: 2 ports detected
[    5.229693] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[22]  MMIO=[f8200000-f82007ff]  Max Packet=[2048]  IR/IT contexts=[8/8]
[    5.232166] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    5.232175] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    5.232180] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    5.232191] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
[    5.232239] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00001880
[    5.232647] hub 6-0:1.0: USB hub found
[    5.232654] hub 6-0:1.0: 2 ports detected
[    5.232799] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    5.232808] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    5.232813] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    5.232821] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
[    5.232854] uhci_hcd 0000:00:1d.2: irq 18, io base 0x000018a0
[    5.234261] hub 7-0:1.0: USB hub found
[    5.234269] hub 7-0:1.0: 2 ports detected
[    5.406355] ACPI: Battery Slot [BAT1] (battery present)
[    5.433809] sdhci: Secure Digital Host Controller Interface driver
[    5.433813] sdhci: Copyright(c) Pierre Ossman
[    5.459957] iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux, in-tree:ds
[    5.459961] iwl3945: Copyright(c) 2003-2010 Intel Corporation
[    5.460058] iwl3945 0000:06:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    5.460073] iwl3945 0000:06:00.0: setting latency timer to 64
[    5.495731] sdhci-pci 0000:08:05.2: SDHCI controller found [1217:7120] (rev 2)
[    5.495759] sdhci-pci 0000:08:05.2: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    5.495795] mmc0: Unknown controller version (2). You may experience problems.
[    5.495880] Registered led device: mmc0::
[    5.495954] mmc0: SDHCI controller on PCI [0000:08:05.2] using DMA
[    5.516358] iwl3945 0000:06:00.0: Tunable channels: 13 802.11bg, 23 802.11a channels
[    5.516362] iwl3945 0000:06:00.0: Detected Intel Wireless WiFi Link 3945ABG
[    5.516509] iwl3945 0000:06:00.0: irq 47 for MSI/MSI-X
[    5.534042] usb 5-2: new low speed USB device using uhci_hcd and address 2
[    5.615413] coretemp coretemp.0: TjMax is assumed as 100 C!
[    5.615790] coretemp coretemp.1: TjMax is assumed as 100 C!
[    5.651268] phy0: Selected rate control algorithm 'iwl-3945-rs'
[    5.768765] usbcore: registered new interface driver hiddev
[    5.769123] usbcore: registered new interface driver usbhid
[    5.769126] usbhid: USB HID core driver
[    5.779221] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    5.779308] HDA Intel 0000:00:1b.0: irq 48 for MSI/MSI-X
[    5.779349] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    5.844696] fuse init (API version 7.14)
[    5.881045] input: PS/2 Mouse as /devices/platform/i8042/serio1/input/input8
[    5.919470] input: AlpsPS/2 ALPS GlidePoint as /devices/platform/i8042/serio1/input/input9
[    5.958903] input: Logitech 2.4GHz Cordless Desktop as /devices/pci0000:00/0000:00:1d.0/usb5/5-2/5-2:1.0/input/input10
[    5.959050] logitech 0003:046D:C512.0001: input,hidraw0: USB HID v1.11 Keyboard [Logitech 2.4GHz Cordless Desktop] on usb-0000:00:1d.0-2/input0
[    5.990503] hda_codec: ALC268: BIOS auto-probing.
[    5.992657] input: Logitech 2.4GHz Cordless Desktop as /devices/pci0000:00/0000:00:1d.0/usb5/5-2/5-2:1.1/input/input11
[    5.993657] logitech 0003:046D:C512.0002: input,hiddev0,hidraw1: USB HID v1.11 Mouse [Logitech 2.4GHz Cordless Desktop] on usb-0000:00:1d.0-2/input1
[    6.497344] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0000c010a000b000]
[    6.718799] EXT4-fs (sda1): re-mounted. Opts: (null)
[    6.976717] EXT4-fs (sda1): re-mounted. Opts: (null)
[    7.114094] EXT4-fs (sda3): mounted filesystem with ordered data mode. Opts: (null)
[    7.194335] Adding 4000180k swap on /dev/sda4.  Priority:-1 extents:1 across:4000180k 
[    9.600207] r8169 0000:07:00.0: eth0: link up
[    9.600224] r8169 0000:07:00.0: eth0: link up
[   23.959059] vboxdrv: Trying to deactivate the NMI watchdog permanently...
[   23.959064] vboxdrv: Warning: 2.6.31+ kernel detected. Most likely the hardware performance
[   23.959066] vboxdrv: counter framework which can generate NMIs is active. You have to prevent
[   23.959068] vboxdrv: the usage of hardware performance counters by
[   23.959069] vboxdrv:   echo 2 > /proc/sys/kernel/perf_counter_paranoid
[   23.959072] vboxdrv: Found 2 processor cores.
[   23.959300] VBoxDrv: dbg - g_abExecMemory=ffffffffa0723260
[   23.959320] vboxdrv: fAsync=0 offMin=0x1ef offMax=0x1236
[   23.959659] vboxdrv: TSC mode is 'synchronous', kernel timer mode is 'normal'.
[   23.959662] vboxdrv: Successfully loaded version 3.2.8 (interface 0x00140001).
[   24.396765] ip_tables: (C) 2000-2006 Netfilter Core Team
[   24.436437] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   24.436842] CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
[   24.436845] nf_conntrack.acct=1 kernel parameter, acct=1 nf_conntrack module option or
[   24.436848] sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
[   26.124117] [drm:drm_crtc_helper_set_config], 
[   26.124121] [drm:drm_crtc_helper_set_config], crtc: ffff88007f163000 3 fb: ffff88007f153ab0 connectors: ffff88007f200500 num_connectors: 1 (x, y) (0, 0)
[   26.124133] [drm:drm_crtc_helper_set_config], setting connector 5 crtc to ffff88007f163000
[   26.129896] [drm:i915_driver_open], 
[   26.129942] [drm:drm_crtc_helper_set_config], 
[   26.129945] [drm:drm_crtc_helper_set_config], crtc: ffff88007f163000 3 fb: ffff88007f153ab0 connectors: ffff88007f200500 num_connectors: 1 (x, y) (0, 0)
[   26.129958] [drm:drm_crtc_helper_set_config], setting connector 5 crtc to ffff88007f163000
[   26.129962] [drm:drm_crtc_helper_set_config], 
[   26.129965] [drm:drm_crtc_helper_set_config], crtc: ffff88007f164000 4 fb: ffff88007f153ab0 connectors: ffff88007f200520 num_connectors: 0 (x, y) (0, 0)
[   26.129973] [drm:drm_crtc_helper_set_config], crtc has no fb, full mode set
[   26.129976] [drm:drm_crtc_helper_set_config], setting connector 5 crtc to ffff88007f163000
[   26.129985] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   26.129989] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 40
[   26.129995] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 1
[   26.150480] [drm:i915_driver_open], 
[   26.151160] [drm:drm_mode_getresources], Counted 2 3 3
[   26.151174] [drm:drm_mode_getresources], Counted 2 3 3
[   26.151304] [drm:drm_mode_getconnector], connector id 5:
[   26.151318] [drm:drm_helper_probe_single_connector_modes], VGA-1
[   26.261445] [drm:drm_helper_probe_single_connector_modes], Probed modes for VGA-1
[   26.261449] [drm:drm_mode_debug_printmodeline], Modeline 30:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[   26.261456] [drm:drm_mode_debug_printmodeline], Modeline 40:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[   26.261462] [drm:drm_mode_debug_printmodeline], Modeline 31:"1280x960" 60 108000 1280 1376 1488 1800 960 961 964 1000 0x40 0x5
[   26.261468] [drm:drm_mode_debug_printmodeline], Modeline 47:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[   26.261474] [drm:drm_mode_debug_printmodeline], Modeline 41:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[   26.261479] [drm:drm_mode_debug_printmodeline], Modeline 42:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[   26.261485] [drm:drm_mode_debug_printmodeline], Modeline 43:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[   26.261491] [drm:drm_mode_debug_printmodeline], Modeline 44:"832x624" 75 57284 832 864 928 1152 624 625 628 667 0x40 0xa
[   26.261497] [drm:drm_mode_debug_printmodeline], Modeline 46:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[   26.261502] [drm:drm_mode_debug_printmodeline], Modeline 45:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[   26.261508] [drm:drm_mode_debug_printmodeline], Modeline 33:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[   26.261514] [drm:drm_mode_debug_printmodeline], Modeline 34:"800x600" 56 36000 800 824 896 1024 600 601 603 625 0x40 0x5
[   26.261520] [drm:drm_mode_debug_printmodeline], Modeline 36:"640x480" 73 31500 640 664 704 832 480 489 491 520 0x40 0xa
[   26.261525] [drm:drm_mode_debug_printmodeline], Modeline 35:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[   26.261531] [drm:drm_mode_debug_printmodeline], Modeline 37:"640x480" 67 30240 640 704 768 864 480 483 486 525 0x40 0xa
[   26.261537] [drm:drm_mode_debug_printmodeline], Modeline 38:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[   26.261542] [drm:drm_mode_debug_printmodeline], Modeline 39:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[   26.261559] [drm:drm_mode_getconnector], connector id 5:
[   26.261668] [drm:drm_mode_getconnector], connector id 7:
[   26.261673] [drm:drm_helper_probe_single_connector_modes], LVDS-1
[   26.261676] [drm:drm_helper_probe_single_connector_modes], LVDS-1 is disconnected
[   26.261681] [drm:drm_mode_getconnector], connector id 7:
[   26.261685] [drm:drm_helper_probe_single_connector_modes], LVDS-1
[   26.261688] [drm:drm_helper_probe_single_connector_modes], LVDS-1 is disconnected
[   26.264201] [drm:drm_mode_getconnector], connector id 14:
[   26.264206] [drm:drm_helper_probe_single_connector_modes], SVIDEO-1
[   26.264218] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   26.264222] [drm:intel_update_watermarks], plane B (pipe 1) clock: 107520
[   26.264226] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   26.264231] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 1
[   26.285804] [drm:intel_crtc_mode_set], Mode for pipe B:
[   26.285813] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[   26.307125] [drm:intel_pipe_set_base], No FB bound
[   26.307133] [drm:intel_update_fbc], 
[   26.307139] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   26.307148] [drm:intel_update_watermarks], plane B (pipe 1) clock: 107520
[   26.307156] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   26.328167] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   26.328178] [drm:intel_update_watermarks], plane B (pipe 1) clock: 107520
[   26.328187] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   26.328223] [drm:intel_update_fbc], 
[   26.391167] [drm:intel_tv_detect_type], No TV connection detected
[   26.391186] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   26.391195] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 40
[   26.403239] [drm:i915_driver_irq_handler], pipe a underrun
[   26.403248] [drm:i915_driver_irq_handler], pipe b underrun
[   26.412279] [drm:drm_helper_probe_single_connector_modes], SVIDEO-1 is disconnected
[   26.412304] [drm:drm_mode_getconnector], connector id 14:
[   26.412314] [drm:drm_helper_probe_single_connector_modes], SVIDEO-1
[   26.412337] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   26.412346] [drm:intel_update_watermarks], plane B (pipe 1) clock: 107520
[   26.412354] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   26.412365] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 1
[   26.433833] [drm:intel_crtc_mode_set], Mode for pipe B:
[   26.433844] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[   26.436547] [drm:i915_driver_irq_handler], pipe b underrun
[   26.453210] [drm:i915_driver_irq_handler], pipe b underrun
[   26.455109] [drm:intel_pipe_set_base], No FB bound
[   26.455116] [drm:intel_update_fbc], 
[   26.455123] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   26.455132] [drm:intel_update_watermarks], plane B (pipe 1) clock: 107520
[   26.455141] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   26.469847] [drm:i915_driver_irq_handler], pipe b underrun
[   26.476165] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   26.476176] [drm:intel_update_watermarks], plane B (pipe 1) clock: 107520
[   26.476185] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   26.476221] [drm:intel_update_fbc], 
[   26.486545] [drm:i915_driver_irq_handler], pipe b underrun
[   26.539169] [drm:intel_tv_detect_type], No TV connection detected
[   26.539186] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   26.539196] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 40
[   26.553190] [drm:i915_driver_irq_handler], pipe b underrun
[   26.560310] [drm:drm_helper_probe_single_connector_modes], SVIDEO-1 is disconnected
[   26.560517] [drm:drm_mode_getconnector], connector id 5:
[   26.560529] [drm:drm_helper_probe_single_connector_modes], VGA-1
[   26.676481] [drm:drm_helper_probe_single_connector_modes], Probed modes for VGA-1
[   26.676485] [drm:drm_mode_debug_printmodeline], Modeline 30:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[   26.676492] [drm:drm_mode_debug_printmodeline], Modeline 40:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[   26.676498] [drm:drm_mode_debug_printmodeline], Modeline 31:"1280x960" 60 108000 1280 1376 1488 1800 960 961 964 1000 0x40 0x5
[   26.676504] [drm:drm_mode_debug_printmodeline], Modeline 47:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[   26.676510] [drm:drm_mode_debug_printmodeline], Modeline 41:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[   26.676516] [drm:drm_mode_debug_printmodeline], Modeline 42:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[   26.676522] [drm:drm_mode_debug_printmodeline], Modeline 43:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[   26.676528] [drm:drm_mode_debug_printmodeline], Modeline 44:"832x624" 75 57284 832 864 928 1152 624 625 628 667 0x40 0xa
[   26.676533] [drm:drm_mode_debug_printmodeline], Modeline 46:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[   26.676539] [drm:drm_mode_debug_printmodeline], Modeline 45:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[   26.676545] [drm:drm_mode_debug_printmodeline], Modeline 33:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[   26.676551] [drm:drm_mode_debug_printmodeline], Modeline 34:"800x600" 56 36000 800 824 896 1024 600 601 603 625 0x40 0x5
[   26.676557] [drm:drm_mode_debug_printmodeline], Modeline 36:"640x480" 73 31500 640 664 704 832 480 489 491 520 0x40 0xa
[   26.676562] [drm:drm_mode_debug_printmodeline], Modeline 35:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[   26.676568] [drm:drm_mode_debug_printmodeline], Modeline 37:"640x480" 67 30240 640 704 768 864 480 483 486 525 0x40 0xa
[   26.676574] [drm:drm_mode_debug_printmodeline], Modeline 38:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[   26.676579] [drm:drm_mode_debug_printmodeline], Modeline 39:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[   26.676597] [drm:drm_mode_getconnector], connector id 5:
[   26.678542] [drm:drm_mode_getconnector], connector id 7:
[   26.678548] [drm:drm_helper_probe_single_connector_modes], LVDS-1
[   26.678552] [drm:drm_helper_probe_single_connector_modes], LVDS-1 is disconnected
[   26.678557] [drm:drm_mode_getconnector], connector id 7:
[   26.678560] [drm:drm_helper_probe_single_connector_modes], LVDS-1
[   26.678564] [drm:drm_helper_probe_single_connector_modes], LVDS-1 is disconnected
[   26.678591] [drm:drm_mode_getconnector], connector id 14:
[   26.678596] [drm:drm_helper_probe_single_connector_modes], SVIDEO-1
[   26.678607] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   26.678611] [drm:intel_update_watermarks], plane B (pipe 1) clock: 107520
[   26.678615] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   26.678620] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 1
[   26.699807] [drm:intel_crtc_mode_set], Mode for pipe B:
[   26.699816] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[   26.703157] [drm:i915_driver_irq_handler], pipe b underrun
[   26.719819] [drm:i915_driver_irq_handler], pipe b underrun
[   26.719835] [drm:i915_driver_irq_handler], pipe b underrun
[   26.721045] [drm:intel_pipe_set_base], No FB bound
[   26.721054] [drm:intel_update_fbc], 
[   26.721060] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   26.721069] [drm:intel_update_watermarks], plane B (pipe 1) clock: 107520
[   26.721078] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   26.736462] [drm:i915_driver_irq_handler], pipe b underrun
[   26.742142] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   26.742152] [drm:intel_update_watermarks], plane B (pipe 1) clock: 107520
[   26.742161] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   26.742196] [drm:intel_update_fbc], 
[   26.753127] [drm:i915_driver_irq_handler], pipe b underrun
[   26.805170] [drm:intel_tv_detect_type], No TV connection detected
[   26.805188] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   26.805198] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 40
[   26.819749] [drm:i915_driver_irq_handler], pipe b underrun
[   26.826296] [drm:drm_helper_probe_single_connector_modes], SVIDEO-1 is disconnected
[   26.826320] [drm:drm_mode_getconnector], connector id 14:
[   26.826331] [drm:drm_helper_probe_single_connector_modes], SVIDEO-1
[   26.826354] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   26.826362] [drm:intel_update_watermarks], plane B (pipe 1) clock: 107520
[   26.826371] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   26.826381] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 1
[   26.847838] [drm:intel_crtc_mode_set], Mode for pipe B:
[   26.847847] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[   26.853090] [drm:i915_driver_irq_handler], pipe b underrun
[   26.853102] [drm:i915_driver_irq_handler], pipe b underrun
[   26.869142] [drm:intel_pipe_set_base], No FB bound
[   26.869151] [drm:intel_update_fbc], 
[   26.869158] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   26.869167] [drm:intel_update_watermarks], plane B (pipe 1) clock: 107520
[   26.869176] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   26.869745] [drm:i915_driver_irq_handler], pipe b underrun
[   26.886419] [drm:i915_driver_irq_handler], pipe b underrun
[   26.890146] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   26.890157] [drm:intel_update_watermarks], plane B (pipe 1) clock: 107520
[   26.890166] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   26.890202] [drm:intel_update_fbc], 
[   26.903079] [drm:i915_driver_irq_handler], pipe b underrun
[   26.953169] [drm:intel_tv_detect_type], No TV connection detected
[   26.953187] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   26.953197] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 40
[   26.969726] [drm:i915_driver_irq_handler], pipe b underrun
[   26.974291] [drm:drm_helper_probe_single_connector_modes], SVIDEO-1 is disconnected
[   27.058249] [drm:drm_crtc_helper_set_config], 
[   27.058254] [drm:drm_crtc_helper_set_config], crtc: ffff88007f163000 3 fb: ffff88007b6a7c00 connectors: ffff88007bac1020 num_connectors: 1 (x, y) (0, 0)
[   27.058268] [drm:drm_crtc_helper_set_config], setting connector 5 crtc to ffff88007f163000
[   27.064595] [drm:intel_pipe_set_base], Writing base 00CF0000 00000000 0 0 5120
[   27.064601] [drm:intel_update_fbc], 
[   27.064604] [drm:intel_update_fbc], 1 pipes active
[   27.064619] [drm:i8xx_enable_fbc], enabled FBC, pitch 71, yoff 0, plane 0, 
[   27.543035] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[   27.613418] [drm:intel_crtc_cursor_set], 
[   28.674067] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[   29.176063] [drm:intel_crtc_idle_timer], idle timer fired, downclocking
[   31.595242] EXT4-fs (sda1): re-mounted. Opts: commit=0
[   31.647486] EXT4-fs (sda3): re-mounted. Opts: commit=0
[   31.688508] [drm:drm_mode_getconnector], connector id 5:
[   31.688516] [drm:drm_helper_probe_single_connector_modes], VGA-1
[   31.808610] [drm:drm_helper_probe_single_connector_modes], Probed modes for VGA-1
[   31.808615] [drm:drm_mode_debug_printmodeline], Modeline 30:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[   31.808621] [drm:drm_mode_debug_printmodeline], Modeline 40:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[   31.808627] [drm:drm_mode_debug_printmodeline], Modeline 31:"1280x960" 60 108000 1280 1376 1488 1800 960 961 964 1000 0x40 0x5
[   31.808633] [drm:drm_mode_debug_printmodeline], Modeline 47:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[   31.808639] [drm:drm_mode_debug_printmodeline], Modeline 41:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[   31.808645] [drm:drm_mode_debug_printmodeline], Modeline 42:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[   31.808651] [drm:drm_mode_debug_printmodeline], Modeline 43:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[   31.808657] [drm:drm_mode_debug_printmodeline], Modeline 44:"832x624" 75 57284 832 864 928 1152 624 625 628 667 0x40 0xa
[   31.808662] [drm:drm_mode_debug_printmodeline], Modeline 46:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[   31.808668] [drm:drm_mode_debug_printmodeline], Modeline 45:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[   31.808674] [drm:drm_mode_debug_printmodeline], Modeline 33:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[   31.808680] [drm:drm_mode_debug_printmodeline], Modeline 34:"800x600" 56 36000 800 824 896 1024 600 601 603 625 0x40 0x5
[   31.808686] [drm:drm_mode_debug_printmodeline], Modeline 36:"640x480" 73 31500 640 664 704 832 480 489 491 520 0x40 0xa
[   31.808691] [drm:drm_mode_debug_printmodeline], Modeline 35:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[   31.808697] [drm:drm_mode_debug_printmodeline], Modeline 37:"640x480" 67 30240 640 704 768 864 480 483 486 525 0x40 0xa
[   31.808703] [drm:drm_mode_debug_printmodeline], Modeline 38:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[   31.808708] [drm:drm_mode_debug_printmodeline], Modeline 39:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[   31.808734] [drm:drm_mode_getconnector], connector id 5:
[   31.809364] [drm:drm_mode_getconnector], connector id 7:
[   31.809371] [drm:drm_helper_probe_single_connector_modes], LVDS-1
[   31.809375] [drm:drm_helper_probe_single_connector_modes], LVDS-1 is disconnected
[   31.809381] [drm:drm_mode_getconnector], connector id 7:
[   31.809385] [drm:drm_helper_probe_single_connector_modes], LVDS-1
[   31.809389] [drm:drm_helper_probe_single_connector_modes], LVDS-1 is disconnected
[   31.809397] [drm:drm_mode_getconnector], connector id 14:
[   31.809402] [drm:drm_helper_probe_single_connector_modes], SVIDEO-1
[   31.809415] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   31.809419] [drm:intel_update_watermarks], plane B (pipe 1) clock: 107520
[   31.809424] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   31.809430] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 1
[   31.830445] [drm:intel_crtc_mode_set], Mode for pipe B:
[   31.830449] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[   31.834786] [drm:i915_driver_irq_handler], pipe b underrun
[   31.834795] [drm:i915_driver_irq_handler], pipe b underrun
[   31.851300] [drm:intel_pipe_set_base], No FB bound
[   31.851310] [drm:intel_update_fbc], 
[   31.851316] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   31.851325] [drm:intel_update_watermarks], plane B (pipe 1) clock: 107520
[   31.851334] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   31.851436] [drm:i915_driver_irq_handler], pipe b underrun
[   31.868107] [drm:i915_driver_irq_handler], pipe b underrun
[   31.872086] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   31.872092] [drm:intel_update_watermarks], plane B (pipe 1) clock: 107520
[   31.872098] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   31.872129] [drm:intel_update_fbc], 
[   31.884759] [drm:i915_driver_irq_handler], pipe b underrun
[   31.884770] [drm:i915_driver_irq_handler], pipe b underrun
[   31.935291] [drm:intel_tv_detect_type], No TV connection detected
[   31.935305] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   31.935312] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 40
[   31.951414] [drm:i915_driver_irq_handler], pipe b underrun
[   31.956230] [drm:drm_helper_probe_single_connector_modes], SVIDEO-1 is disconnected
[   31.956251] [drm:drm_mode_getconnector], connector id 14:
[   31.956265] [drm:drm_helper_probe_single_connector_modes], SVIDEO-1
[   31.956279] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   31.956282] [drm:intel_update_watermarks], plane B (pipe 1) clock: 107520
[   31.956286] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   31.956291] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 1
[   31.977680] [drm:intel_crtc_mode_set], Mode for pipe B:
[   31.977684] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[   31.984725] [drm:i915_driver_irq_handler], pipe b underrun
[   31.999051] [drm:intel_pipe_set_base], No FB bound
[   31.999057] [drm:intel_update_fbc], 
[   31.999062] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   31.999068] [drm:intel_update_watermarks], plane B (pipe 1) clock: 107520
[   31.999074] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   32.001381] [drm:i915_driver_irq_handler], pipe b underrun
[   32.018063] [drm:i915_driver_irq_handler], pipe b underrun
[   32.020090] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   32.020097] [drm:intel_update_watermarks], plane B (pipe 1) clock: 107520
[   32.020104] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   32.020134] [drm:intel_update_fbc], 
[   32.034707] [drm:i915_driver_irq_handler], pipe b underrun
[   32.083153] [drm:intel_tv_detect_type], No TV connection detected
[   32.083174] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   32.083185] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 40
[   32.084715] [drm:i915_driver_irq_handler], pipe b underrun
[   32.104435] [drm:drm_helper_probe_single_connector_modes], SVIDEO-1 is disconnected
[   32.107482] [drm:drm_mode_getconnector], connector id 5:
[   32.107490] [drm:drm_helper_probe_single_connector_modes], VGA-1
[   32.225450] [drm:drm_helper_probe_single_connector_modes], Probed modes for VGA-1
[   32.225455] [drm:drm_mode_debug_printmodeline], Modeline 30:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[   32.225462] [drm:drm_mode_debug_printmodeline], Modeline 40:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[   32.225468] [drm:drm_mode_debug_printmodeline], Modeline 31:"1280x960" 60 108000 1280 1376 1488 1800 960 961 964 1000 0x40 0x5
[   32.225474] [drm:drm_mode_debug_printmodeline], Modeline 47:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[   32.225480] [drm:drm_mode_debug_printmodeline], Modeline 41:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[   32.225486] [drm:drm_mode_debug_printmodeline], Modeline 42:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[   32.225491] [drm:drm_mode_debug_printmodeline], Modeline 43:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[   32.225497] [drm:drm_mode_debug_printmodeline], Modeline 44:"832x624" 75 57284 832 864 928 1152 624 625 628 667 0x40 0xa
[   32.225503] [drm:drm_mode_debug_printmodeline], Modeline 46:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[   32.225509] [drm:drm_mode_debug_printmodeline], Modeline 45:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[   32.225515] [drm:drm_mode_debug_printmodeline], Modeline 33:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[   32.225520] [drm:drm_mode_debug_printmodeline], Modeline 34:"800x600" 56 36000 800 824 896 1024 600 601 603 625 0x40 0x5
[   32.225526] [drm:drm_mode_debug_printmodeline], Modeline 36:"640x480" 73 31500 640 664 704 832 480 489 491 520 0x40 0xa
[   32.225532] [drm:drm_mode_debug_printmodeline], Modeline 35:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[   32.225538] [drm:drm_mode_debug_printmodeline], Modeline 37:"640x480" 67 30240 640 704 768 864 480 483 486 525 0x40 0xa
[   32.225543] [drm:drm_mode_debug_printmodeline], Modeline 38:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[   32.225549] [drm:drm_mode_debug_printmodeline], Modeline 39:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[   32.225574] [drm:drm_mode_getconnector], connector id 5:
[   32.226145] [drm:drm_mode_getconnector], connector id 7:
[   32.226151] [drm:drm_helper_probe_single_connector_modes], LVDS-1
[   32.226154] [drm:drm_helper_probe_single_connector_modes], LVDS-1 is disconnected
[   32.226159] [drm:drm_mode_getconnector], connector id 7:
[   32.226163] [drm:drm_helper_probe_single_connector_modes], LVDS-1
[   32.226166] [drm:drm_helper_probe_single_connector_modes], LVDS-1 is disconnected
[   32.226173] [drm:drm_mode_getconnector], connector id 14:
[   32.226177] [drm:drm_helper_probe_single_connector_modes], SVIDEO-1
[   32.226189] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   32.226193] [drm:intel_update_watermarks], plane B (pipe 1) clock: 107520
[   32.226197] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   32.226202] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 1
[   32.246833] [drm:intel_crtc_mode_set], Mode for pipe B:
[   32.246842] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[   32.251391] [drm:i915_driver_irq_handler], pipe b underrun
[   32.268064] [drm:i915_driver_irq_handler], pipe b underrun
[   32.268144] [drm:intel_pipe_set_base], No FB bound
[   32.268152] [drm:intel_update_fbc], 
[   32.268159] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   32.268168] [drm:intel_update_watermarks], plane B (pipe 1) clock: 107520
[   32.268177] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   32.284705] [drm:i915_driver_irq_handler], pipe b underrun
[   32.289185] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   32.289195] [drm:intel_update_watermarks], plane B (pipe 1) clock: 107520
[   32.289203] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   32.289239] [drm:intel_update_fbc], 
[   32.301365] [drm:i915_driver_irq_handler], pipe b underrun
[   32.352162] [drm:intel_tv_detect_type], No TV connection detected
[   32.352181] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   32.352191] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 40
[   32.368012] [drm:i915_driver_irq_handler], pipe b underrun
[   32.373324] [drm:drm_helper_probe_single_connector_modes], SVIDEO-1 is disconnected
[   32.373365] [drm:drm_mode_getconnector], connector id 14:
[   32.373376] [drm:drm_helper_probe_single_connector_modes], SVIDEO-1
[   32.373399] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   32.373407] [drm:intel_update_watermarks], plane B (pipe 1) clock: 107520
[   32.373416] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   32.373427] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 1
[   32.394864] [drm:intel_crtc_mode_set], Mode for pipe B:
[   32.394874] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[   32.401336] [drm:i915_driver_irq_handler], pipe b underrun
[   32.416168] [drm:intel_pipe_set_base], No FB bound
[   32.416177] [drm:intel_update_fbc], 
[   32.416183] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   32.416192] [drm:intel_update_watermarks], plane B (pipe 1) clock: 107520
[   32.416200] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   32.417995] [drm:i915_driver_irq_handler], pipe b underrun
[   32.434679] [drm:i915_driver_irq_handler], pipe b underrun
[   32.437195] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   32.437205] [drm:intel_update_watermarks], plane B (pipe 1) clock: 107520
[   32.437214] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   32.437250] [drm:intel_update_fbc], 
[   32.451338] [drm:i915_driver_irq_handler], pipe b underrun
[   32.500166] [drm:intel_tv_detect_type], No TV connection detected
[   32.500184] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   32.500193] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 40
[   32.501303] [drm:i915_driver_irq_handler], pipe b underrun
[   32.521325] [drm:drm_helper_probe_single_connector_modes], SVIDEO-1 is disconnected
[   32.581848] [drm:drm_mode_getconnector], connector id 5:
[   32.581855] [drm:drm_helper_probe_single_connector_modes], VGA-1
[   32.691529] [drm:drm_helper_probe_single_connector_modes], Probed modes for VGA-1
[   32.691533] [drm:drm_mode_debug_printmodeline], Modeline 30:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[   32.691540] [drm:drm_mode_debug_printmodeline], Modeline 40:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[   32.691546] [drm:drm_mode_debug_printmodeline], Modeline 31:"1280x960" 60 108000 1280 1376 1488 1800 960 961 964 1000 0x40 0x5
[   32.691552] [drm:drm_mode_debug_printmodeline], Modeline 47:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[   32.691558] [drm:drm_mode_debug_printmodeline], Modeline 41:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[   32.691564] [drm:drm_mode_debug_printmodeline], Modeline 42:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[   32.691569] [drm:drm_mode_debug_printmodeline], Modeline 43:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[   32.691575] [drm:drm_mode_debug_printmodeline], Modeline 44:"832x624" 75 57284 832 864 928 1152 624 625 628 667 0x40 0xa
[   32.691581] [drm:drm_mode_debug_printmodeline], Modeline 46:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[   32.691587] [drm:drm_mode_debug_printmodeline], Modeline 45:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[   32.691592] [drm:drm_mode_debug_printmodeline], Modeline 33:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[   32.691598] [drm:drm_mode_debug_printmodeline], Modeline 34:"800x600" 56 36000 800 824 896 1024 600 601 603 625 0x40 0x5
[   32.691604] [drm:drm_mode_debug_printmodeline], Modeline 36:"640x480" 73 31500 640 664 704 832 480 489 491 520 0x40 0xa
[   32.691610] [drm:drm_mode_debug_printmodeline], Modeline 35:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[   32.691615] [drm:drm_mode_debug_printmodeline], Modeline 37:"640x480" 67 30240 640 704 768 864 480 483 486 525 0x40 0xa
[   32.691621] [drm:drm_mode_debug_printmodeline], Modeline 38:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[   32.691626] [drm:drm_mode_debug_printmodeline], Modeline 39:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[   32.691654] [drm:drm_mode_getconnector], connector id 5:
[   32.692208] [drm:drm_mode_getconnector], connector id 7:
[   32.692214] [drm:drm_helper_probe_single_connector_modes], LVDS-1
[   32.692218] [drm:drm_helper_probe_single_connector_modes], LVDS-1 is disconnected
[   32.692223] [drm:drm_mode_getconnector], connector id 7:
[   32.692226] [drm:drm_helper_probe_single_connector_modes], LVDS-1
[   32.692230] [drm:drm_helper_probe_single_connector_modes], LVDS-1 is disconnected
[   32.692236] [drm:drm_mode_getconnector], connector id 14:
[   32.692240] [drm:drm_helper_probe_single_connector_modes], SVIDEO-1
[   32.692265] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   32.692269] [drm:intel_update_watermarks], plane B (pipe 1) clock: 107520
[   32.692274] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   32.692280] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 1
[   32.713836] [drm:intel_crtc_mode_set], Mode for pipe B:
[   32.713845] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[   32.717839] [drm:i915_driver_irq_handler], pipe b underrun
[   32.717848] [drm:i915_driver_irq_handler], pipe b underrun
[   32.734556] [drm:i915_driver_irq_handler], pipe b underrun
[   32.735055] [drm:intel_pipe_set_base], No FB bound
[   32.735062] [drm:intel_update_fbc], 
[   32.735067] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   32.735073] [drm:intel_update_watermarks], plane B (pipe 1) clock: 107520
[   32.735080] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   32.751243] [drm:i915_driver_irq_handler], pipe b underrun
[   32.756192] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   32.756202] [drm:intel_update_watermarks], plane B (pipe 1) clock: 107520
[   32.756211] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   32.756247] [drm:intel_update_fbc], 
[   32.767905] [drm:i915_driver_irq_handler], pipe b underrun
[   32.819162] [drm:intel_tv_detect_type], No TV connection detected
[   32.819180] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   32.819189] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 40
[   32.834532] [drm:i915_driver_irq_handler], pipe b underrun
[   32.840318] [drm:drm_helper_probe_single_connector_modes], SVIDEO-1 is disconnected
[   32.840357] [drm:drm_mode_getconnector], connector id 14:
[   32.840368] [drm:drm_helper_probe_single_connector_modes], SVIDEO-1
[   32.840387] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   32.840395] [drm:intel_update_watermarks], plane B (pipe 1) clock: 107520
[   32.840404] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   32.840413] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 1
[   32.861864] [drm:intel_crtc_mode_set], Mode for pipe B:
[   32.861874] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[   32.867820] [drm:i915_driver_irq_handler], pipe b underrun
[   32.883165] [drm:intel_pipe_set_base], No FB bound
[   32.883175] [drm:intel_update_fbc], 
[   32.883182] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   32.883191] [drm:intel_update_watermarks], plane B (pipe 1) clock: 107520
[   32.883199] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   32.884514] [drm:i915_driver_irq_handler], pipe b underrun
[   32.901178] [drm:i915_driver_irq_handler], pipe b underrun
[   32.904186] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   32.904196] [drm:intel_update_watermarks], plane B (pipe 1) clock: 107520
[   32.904205] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   32.904239] [drm:intel_update_fbc], 
[   32.917820] [drm:i915_driver_irq_handler], pipe b underrun
[   32.967161] [drm:intel_tv_detect_type], No TV connection detected
[   32.967179] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   32.967188] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 40
[   32.967760] [drm:i915_driver_irq_handler], pipe b underrun
[   32.988325] [drm:drm_helper_probe_single_connector_modes], SVIDEO-1 is disconnected
[   41.549031] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[   42.050029] [drm:intel_crtc_idle_timer], idle timer fired, downclocking
[   42.193062] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[   42.429618] [drm:drm_mode_getconnector], connector id 5:
[   42.429626] [drm:drm_helper_probe_single_connector_modes], VGA-1
[   42.539447] [drm:drm_helper_probe_single_connector_modes], Probed modes for VGA-1
[   42.539452] [drm:drm_mode_debug_printmodeline], Modeline 30:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[   42.539458] [drm:drm_mode_debug_printmodeline], Modeline 40:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[   42.539464] [drm:drm_mode_debug_printmodeline], Modeline 31:"1280x960" 60 108000 1280 1376 1488 1800 960 961 964 1000 0x40 0x5
[   42.539470] [drm:drm_mode_debug_printmodeline], Modeline 47:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[   42.539476] [drm:drm_mode_debug_printmodeline], Modeline 41:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[   42.539482] [drm:drm_mode_debug_printmodeline], Modeline 42:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[   42.539488] [drm:drm_mode_debug_printmodeline], Modeline 43:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[   42.539494] [drm:drm_mode_debug_printmodeline], Modeline 44:"832x624" 75 57284 832 864 928 1152 624 625 628 667 0x40 0xa
[   42.539500] [drm:drm_mode_debug_printmodeline], Modeline 46:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[   42.539505] [drm:drm_mode_debug_printmodeline], Modeline 45:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[   42.539511] [drm:drm_mode_debug_printmodeline], Modeline 33:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[   42.539517] [drm:drm_mode_debug_printmodeline], Modeline 34:"800x600" 56 36000 800 824 896 1024 600 601 603 625 0x40 0x5
[   42.539523] [drm:drm_mode_debug_printmodeline], Modeline 36:"640x480" 73 31500 640 664 704 832 480 489 491 520 0x40 0xa
[   42.539529] [drm:drm_mode_debug_printmodeline], Modeline 35:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[   42.539534] [drm:drm_mode_debug_printmodeline], Modeline 37:"640x480" 67 30240 640 704 768 864 480 483 486 525 0x40 0xa
[   42.539540] [drm:drm_mode_debug_printmodeline], Modeline 38:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[   42.539545] [drm:drm_mode_debug_printmodeline], Modeline 39:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[   42.539572] [drm:drm_mode_getconnector], connector id 5:
[   42.540125] [drm:drm_mode_getconnector], connector id 7:
[   42.540130] [drm:drm_helper_probe_single_connector_modes], LVDS-1
[   42.540134] [drm:drm_helper_probe_single_connector_modes], LVDS-1 is disconnected
[   42.540139] [drm:drm_mode_getconnector], connector id 7:
[   42.540143] [drm:drm_helper_probe_single_connector_modes], LVDS-1
[   42.540146] [drm:drm_helper_probe_single_connector_modes], LVDS-1 is disconnected
[   42.540153] [drm:drm_mode_getconnector], connector id 14:
[   42.540157] [drm:drm_helper_probe_single_connector_modes], SVIDEO-1
[   42.540169] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   42.540173] [drm:intel_update_watermarks], plane B (pipe 1) clock: 107520
[   42.540177] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   42.540182] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 1
[   42.560831] [drm:intel_crtc_mode_set], Mode for pipe B:
[   42.560840] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[   42.564795] [drm:i915_driver_irq_handler], pipe b underrun
[   42.581469] [drm:i915_driver_irq_handler], pipe b underrun
[   42.582094] [drm:intel_pipe_set_base], No FB bound
[   42.582103] [drm:intel_update_fbc], 
[   42.582110] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   42.582119] [drm:intel_update_watermarks], plane B (pipe 1) clock: 107520
[   42.582129] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   42.598129] [drm:i915_driver_irq_handler], pipe b underrun
[   42.603193] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   42.603203] [drm:intel_update_watermarks], plane B (pipe 1) clock: 107520
[   42.603212] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   42.603248] [drm:intel_update_fbc], 
[   42.614791] [drm:i915_driver_irq_handler], pipe b underrun
[   42.666163] [drm:intel_tv_detect_type], No TV connection detected
[   42.666181] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   42.666190] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 40
[   42.681417] [drm:i915_driver_irq_handler], pipe b underrun
[   42.687269] [drm:drm_helper_probe_single_connector_modes], SVIDEO-1 is disconnected
[   42.687308] [drm:drm_mode_getconnector], connector id 14:
[   42.687318] [drm:drm_helper_probe_single_connector_modes], SVIDEO-1
[   42.687338] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   42.687346] [drm:intel_update_watermarks], plane B (pipe 1) clock: 107520
[   42.687355] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   42.687364] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 1
[   42.708876] [drm:intel_crtc_mode_set], Mode for pipe B:
[   42.708886] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[   42.714740] [drm:i915_driver_irq_handler], pipe b underrun
[   42.730168] [drm:intel_pipe_set_base], No FB bound
[   42.730178] [drm:intel_update_fbc], 
[   42.730184] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   42.730193] [drm:intel_update_watermarks], plane B (pipe 1) clock: 107520
[   42.730202] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   42.731402] [drm:i915_driver_irq_handler], pipe b underrun
[   42.748026] [drm:i915_driver_irq_handler], pipe b underrun
[   42.751196] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   42.751207] [drm:intel_update_watermarks], plane B (pipe 1) clock: 107520
[   42.751216] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   42.751268] [drm:intel_update_fbc], 
[   42.764743] [drm:i915_driver_irq_handler], pipe b underrun
[   42.814164] [drm:intel_tv_detect_type], No TV connection detected
[   42.814181] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   42.814191] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 40
[   42.814646] [drm:i915_driver_irq_handler], pipe b underrun
[   42.835284] [drm:drm_helper_probe_single_connector_modes], SVIDEO-1 is disconnected
[   42.838301] [drm:drm_mode_getconnector], connector id 5:
[   42.838315] [drm:drm_helper_probe_single_connector_modes], VGA-1
[   42.910260] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[   42.956444] [drm:drm_helper_probe_single_connector_modes], Probed modes for VGA-1
[   42.956449] [drm:drm_mode_debug_printmodeline], Modeline 30:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[   42.956455] [drm:drm_mode_debug_printmodeline], Modeline 40:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[   42.956461] [drm:drm_mode_debug_printmodeline], Modeline 31:"1280x960" 60 108000 1280 1376 1488 1800 960 961 964 1000 0x40 0x5
[   42.956467] [drm:drm_mode_debug_printmodeline], Modeline 47:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[   42.956473] [drm:drm_mode_debug_printmodeline], Modeline 41:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[   42.956479] [drm:drm_mode_debug_printmodeline], Modeline 42:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[   42.956485] [drm:drm_mode_debug_printmodeline], Modeline 43:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[   42.956490] [drm:drm_mode_debug_printmodeline], Modeline 44:"832x624" 75 57284 832 864 928 1152 624 625 628 667 0x40 0xa
[   42.956496] [drm:drm_mode_debug_printmodeline], Modeline 46:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[   42.956502] [drm:drm_mode_debug_printmodeline], Modeline 45:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[   42.956508] [drm:drm_mode_debug_printmodeline], Modeline 33:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[   42.956514] [drm:drm_mode_debug_printmodeline], Modeline 34:"800x600" 56 36000 800 824 896 1024 600 601 603 625 0x40 0x5
[   42.956519] [drm:drm_mode_debug_printmodeline], Modeline 36:"640x480" 73 31500 640 664 704 832 480 489 491 520 0x40 0xa
[   42.956525] [drm:drm_mode_debug_printmodeline], Modeline 35:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[   42.956531] [drm:drm_mode_debug_printmodeline], Modeline 37:"640x480" 67 30240 640 704 768 864 480 483 486 525 0x40 0xa
[   42.956536] [drm:drm_mode_debug_printmodeline], Modeline 38:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[   42.956542] [drm:drm_mode_debug_printmodeline], Modeline 39:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[   42.956569] [drm:drm_mode_getconnector], connector id 5:
[   42.957108] [drm:drm_mode_getconnector], connector id 7:
[   42.957114] [drm:drm_helper_probe_single_connector_modes], LVDS-1
[   42.957118] [drm:drm_helper_probe_single_connector_modes], LVDS-1 is disconnected
[   42.957123] [drm:drm_mode_getconnector], connector id 7:
[   42.957126] [drm:drm_helper_probe_single_connector_modes], LVDS-1
[   42.957130] [drm:drm_helper_probe_single_connector_modes], LVDS-1 is disconnected
[   42.957136] [drm:drm_mode_getconnector], connector id 14:
[   42.957140] [drm:drm_helper_probe_single_connector_modes], SVIDEO-1
[   42.957152] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   42.957155] [drm:intel_update_watermarks], plane B (pipe 1) clock: 107520
[   42.957159] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   42.957164] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 1
[   42.977804] [drm:intel_crtc_mode_set], Mode for pipe B:
[   42.977813] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[   42.981323] [drm:i915_driver_irq_handler], pipe b underrun
[   42.998004] [drm:i915_driver_irq_handler], pipe b underrun
[   42.998021] [drm:i915_driver_irq_handler], pipe b underrun
[   42.999087] [drm:intel_pipe_set_base], No FB bound
[   42.999095] [drm:intel_update_fbc], 
[   42.999103] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   42.999111] [drm:intel_update_watermarks], plane B (pipe 1) clock: 107520
[   42.999121] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   43.014664] [drm:i915_driver_irq_handler], pipe b underrun
[   43.020156] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   43.020165] [drm:intel_update_watermarks], plane B (pipe 1) clock: 107520
[   43.020174] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   43.020210] [drm:intel_update_fbc], 
[   43.031307] [drm:i915_driver_irq_handler], pipe b underrun
[   43.083165] [drm:intel_tv_detect_type], No TV connection detected
[   43.083183] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   43.083192] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 40
[   43.097948] [drm:i915_driver_irq_handler], pipe b underrun
[   43.104281] [drm:drm_helper_probe_single_connector_modes], SVIDEO-1 is disconnected
[   43.104320] [drm:drm_mode_getconnector], connector id 14:
[   43.104331] [drm:drm_helper_probe_single_connector_modes], SVIDEO-1
[   43.104350] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   43.104358] [drm:intel_update_watermarks], plane B (pipe 1) clock: 107520
[   43.104367] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   43.104376] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 1
[   43.125869] [drm:intel_crtc_mode_set], Mode for pipe B:
[   43.125879] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[   43.131275] [drm:i915_driver_irq_handler], pipe b underrun
[   43.147168] [drm:intel_pipe_set_base], No FB bound
[   43.147177] [drm:intel_update_fbc], 
[   43.147184] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   43.147192] [drm:intel_update_watermarks], plane B (pipe 1) clock: 107520
[   43.147201] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   43.147874] [drm:i915_driver_irq_handler], pipe b underrun
[   43.164598] [drm:i915_driver_irq_handler], pipe b underrun
[   43.168148] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   43.168158] [drm:intel_update_watermarks], plane B (pipe 1) clock: 107520
[   43.168166] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   43.168202] [drm:intel_update_fbc], 
[   43.181259] [drm:i915_driver_irq_handler], pipe b underrun
[   43.231164] [drm:intel_tv_detect_type], No TV connection detected
[   43.231182] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   43.231191] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 40
[   43.247904] [drm:i915_driver_irq_handler], pipe b underrun
[   43.252282] [drm:drm_helper_probe_single_connector_modes], SVIDEO-1 is disconnected
[   43.256641] [drm:drm_mode_getconnector], connector id 5:
[   43.256655] [drm:drm_helper_probe_single_connector_modes], VGA-1
[   43.372530] [drm:drm_helper_probe_single_connector_modes], Probed modes for VGA-1
[   43.372534] [drm:drm_mode_debug_printmodeline], Modeline 30:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[   43.372541] [drm:drm_mode_debug_printmodeline], Modeline 40:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[   43.372547] [drm:drm_mode_debug_printmodeline], Modeline 31:"1280x960" 60 108000 1280 1376 1488 1800 960 961 964 1000 0x40 0x5
[   43.372553] [drm:drm_mode_debug_printmodeline], Modeline 47:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[   43.372559] [drm:drm_mode_debug_printmodeline], Modeline 41:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[   43.372565] [drm:drm_mode_debug_printmodeline], Modeline 42:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[   43.372570] [drm:drm_mode_debug_printmodeline], Modeline 43:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[   43.372576] [drm:drm_mode_debug_printmodeline], Modeline 44:"832x624" 75 57284 832 864 928 1152 624 625 628 667 0x40 0xa
[   43.372582] [drm:drm_mode_debug_printmodeline], Modeline 46:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[   43.372587] [drm:drm_mode_debug_printmodeline], Modeline 45:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[   43.372593] [drm:drm_mode_debug_printmodeline], Modeline 33:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[   43.372599] [drm:drm_mode_debug_printmodeline], Modeline 34:"800x600" 56 36000 800 824 896 1024 600 601 603 625 0x40 0x5
[   43.372605] [drm:drm_mode_debug_printmodeline], Modeline 36:"640x480" 73 31500 640 664 704 832 480 489 491 520 0x40 0xa
[   43.372610] [drm:drm_mode_debug_printmodeline], Modeline 35:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[   43.372616] [drm:drm_mode_debug_printmodeline], Modeline 37:"640x480" 67 30240 640 704 768 864 480 483 486 525 0x40 0xa
[   43.372622] [drm:drm_mode_debug_printmodeline], Modeline 38:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[   43.372627] [drm:drm_mode_debug_printmodeline], Modeline 39:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[   43.372656] [drm:drm_mode_getconnector], connector id 5:
[   43.373214] [drm:drm_mode_getconnector], connector id 7:
[   43.373220] [drm:drm_helper_probe_single_connector_modes], LVDS-1
[   43.373224] [drm:drm_helper_probe_single_connector_modes], LVDS-1 is disconnected
[   43.373229] [drm:drm_mode_getconnector], connector id 7:
[   43.373232] [drm:drm_helper_probe_single_connector_modes], LVDS-1
[   43.373236] [drm:drm_helper_probe_single_connector_modes], LVDS-1 is disconnected
[   43.373243] [drm:drm_mode_getconnector], connector id 14:
[   43.373247] [drm:drm_helper_probe_single_connector_modes], SVIDEO-1
[   43.373275] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   43.373279] [drm:intel_update_watermarks], plane B (pipe 1) clock: 107520
[   43.373283] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   43.373289] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 1
[   43.394801] [drm:intel_crtc_mode_set], Mode for pipe B:
[   43.394809] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[   43.397857] [drm:i915_driver_irq_handler], pipe b underrun
[   43.414518] [drm:i915_driver_irq_handler], pipe b underrun
[   43.416127] [drm:intel_pipe_set_base], No FB bound
[   43.416135] [drm:intel_update_fbc], 
[   43.416141] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   43.416150] [drm:intel_update_watermarks], plane B (pipe 1) clock: 107520
[   43.416158] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   43.431141] [drm:i915_driver_irq_handler], pipe b underrun
[   43.437148] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   43.437158] [drm:intel_update_watermarks], plane B (pipe 1) clock: 107520
[   43.437167] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   43.437202] [drm:intel_update_fbc], 
[   43.447841] [drm:i915_driver_irq_handler], pipe b underrun
[   43.500165] [drm:intel_tv_detect_type], No TV connection detected
[   43.500183] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   43.500193] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 40
[   43.514488] [drm:i915_driver_irq_handler], pipe b underrun
[   43.521327] [drm:drm_helper_probe_single_connector_modes], SVIDEO-1 is disconnected
[   43.521368] [drm:drm_mode_getconnector], connector id 14:
[   43.521378] [drm:drm_helper_probe_single_connector_modes], SVIDEO-1
[   43.521402] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   43.521410] [drm:intel_update_watermarks], plane B (pipe 1) clock: 107520
[   43.521419] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   43.521430] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 1
[   43.542864] [drm:intel_crtc_mode_set], Mode for pipe B:
[   43.542874] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[   43.547810] [drm:i915_driver_irq_handler], pipe b underrun
[   43.564167] [drm:intel_pipe_set_base], No FB bound
[   43.564176] [drm:intel_update_fbc], 
[   43.564183] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   43.564192] [drm:intel_update_watermarks], plane B (pipe 1) clock: 107520
[   43.564200] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   43.564409] [drm:i915_driver_irq_handler], pipe b underrun
[   43.581132] [drm:i915_driver_irq_handler], pipe b underrun
[   43.585149] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   43.585159] [drm:intel_update_watermarks], plane B (pipe 1) clock: 107520
[   43.585167] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   43.585202] [drm:intel_update_fbc], 
[   43.597794] [drm:i915_driver_irq_handler], pipe b underrun
[   43.648165] [drm:intel_tv_detect_type], No TV connection detected
[   43.648183] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   43.648193] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 40
[   43.664438] [drm:i915_driver_irq_handler], pipe b underrun
[   43.669280] [drm:drm_helper_probe_single_connector_modes], SVIDEO-1 is disconnected
[   43.708881] [drm:intel_crtc_cursor_set], 
[   43.708890] [drm:intel_crtc_cursor_set], cursor off
[   43.709467] [drm:intel_crtc_cursor_set], 
[   46.882179] [drm:drm_mode_getconnector], connector id 5:
[   46.882186] [drm:drm_helper_probe_single_connector_modes], VGA-1
[   47.007207] [drm:drm_helper_probe_single_connector_modes], Probed modes for VGA-1
[   47.007212] [drm:drm_mode_debug_printmodeline], Modeline 30:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[   47.007219] [drm:drm_mode_debug_printmodeline], Modeline 40:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[   47.007225] [drm:drm_mode_debug_printmodeline], Modeline 31:"1280x960" 60 108000 1280 1376 1488 1800 960 961 964 1000 0x40 0x5
[   47.007231] [drm:drm_mode_debug_printmodeline], Modeline 47:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[   47.007236] [drm:drm_mode_debug_printmodeline], Modeline 41:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[   47.007242] [drm:drm_mode_debug_printmodeline], Modeline 42:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[   47.007248] [drm:drm_mode_debug_printmodeline], Modeline 43:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[   47.007257] [drm:drm_mode_debug_printmodeline], Modeline 44:"832x624" 75 57284 832 864 928 1152 624 625 628 667 0x40 0xa
[   47.007262] [drm:drm_mode_debug_printmodeline], Modeline 46:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[   47.007268] [drm:drm_mode_debug_printmodeline], Modeline 45:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[   47.007274] [drm:drm_mode_debug_printmodeline], Modeline 33:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[   47.007280] [drm:drm_mode_debug_printmodeline], Modeline 34:"800x600" 56 36000 800 824 896 1024 600 601 603 625 0x40 0x5
[   47.007286] [drm:drm_mode_debug_printmodeline], Modeline 36:"640x480" 73 31500 640 664 704 832 480 489 491 520 0x40 0xa
[   47.007291] [drm:drm_mode_debug_printmodeline], Modeline 35:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[   47.007297] [drm:drm_mode_debug_printmodeline], Modeline 37:"640x480" 67 30240 640 704 768 864 480 483 486 525 0x40 0xa
[   47.007302] [drm:drm_mode_debug_printmodeline], Modeline 38:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[   47.007308] [drm:drm_mode_debug_printmodeline], Modeline 39:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[   47.007336] [drm:drm_mode_getconnector], connector id 5:
[   47.007889] [drm:drm_mode_getconnector], connector id 7:
[   47.007895] [drm:drm_helper_probe_single_connector_modes], LVDS-1
[   47.007899] [drm:drm_helper_probe_single_connector_modes], LVDS-1 is disconnected
[   47.007904] [drm:drm_mode_getconnector], connector id 7:
[   47.007908] [drm:drm_helper_probe_single_connector_modes], LVDS-1
[   47.007911] [drm:drm_helper_probe_single_connector_modes], LVDS-1 is disconnected
[   47.007918] [drm:drm_mode_getconnector], connector id 14:
[   47.007922] [drm:drm_helper_probe_single_connector_modes], SVIDEO-1
[   47.007934] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   47.007938] [drm:intel_update_watermarks], plane B (pipe 1) clock: 107520
[   47.007942] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   47.007947] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 1
[   47.028738] [drm:intel_crtc_mode_set], Mode for pipe B:
[   47.028749] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[   47.046639] [drm:i915_driver_irq_handler], pipe b underrun
[   47.050040] [drm:intel_pipe_set_base], No FB bound
[   47.050046] [drm:intel_update_fbc], 
[   47.050051] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   47.050056] [drm:intel_update_watermarks], plane B (pipe 1) clock: 107520
[   47.050062] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   47.063302] [drm:i915_driver_irq_handler], pipe b underrun
[   47.071058] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   47.071065] [drm:intel_update_watermarks], plane B (pipe 1) clock: 107520
[   47.071071] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   47.071102] [drm:intel_update_fbc], 
[   47.079964] [drm:i915_driver_irq_handler], pipe b underrun
[   47.134054] [drm:intel_tv_detect_type], No TV connection detected
[   47.134066] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   47.134072] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 40
[   47.146594] [drm:i915_driver_irq_handler], pipe b underrun
[   47.155191] [drm:drm_helper_probe_single_connector_modes], SVIDEO-1 is disconnected
[   47.155211] [drm:drm_mode_getconnector], connector id 14:
[   47.155216] [drm:drm_helper_probe_single_connector_modes], SVIDEO-1
[   47.155225] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   47.155229] [drm:intel_update_watermarks], plane B (pipe 1) clock: 107520
[   47.155233] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   47.155237] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 1
[   47.176430] [drm:intel_crtc_mode_set], Mode for pipe B:
[   47.176434] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[   47.179909] [drm:i915_driver_irq_handler], pipe b underrun
[   47.196584] [drm:i915_driver_irq_handler], pipe b underrun
[   47.196602] [drm:i915_driver_irq_handler], pipe b underrun
[   47.197350] [drm:intel_pipe_set_base], No FB bound
[   47.197359] [drm:intel_update_fbc], 
[   47.197366] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   47.197375] [drm:intel_update_watermarks], plane B (pipe 1) clock: 107520
[   47.197384] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   47.213256] [drm:i915_driver_irq_handler], pipe b underrun
[   47.218067] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   47.218074] [drm:intel_update_watermarks], plane B (pipe 1) clock: 107520
[   47.218080] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   47.218111] [drm:intel_update_fbc], 
[   47.229901] [drm:i915_driver_irq_handler], pipe b underrun
[   47.281076] [drm:intel_tv_detect_type], No TV connection detected
[   47.281091] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   47.281098] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 40
[   47.296563] [drm:i915_driver_irq_handler], pipe b underrun
[   47.302223] [drm:drm_helper_probe_single_connector_modes], SVIDEO-1 is disconnected
[   55.569143] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[   56.570138] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[   57.569139] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[   61.569141] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[   63.570138] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[   74.570141] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[   77.642141] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[   78.642142] [drm:intel_gpu_idle_timer], idle timer fired, downclocking

--=-VvVq7WiiE4PudwTTyALl
Content-Disposition: attachment; filename="dmesg.drm.36"
Content-Type: text/plain; name="dmesg.drm.36"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.36-rc2-RC (root@vostro) (gcc version 4.5.1 (GCC) ) #3 SMP PREEMPT Tue Aug 24 10:12:46 CEST 2010
[    0.000000] Command line: root=/dev/sda1 ro video=LVDS-1:d drm.debug=0x6
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007f6d0000 (usable)
[    0.000000]  BIOS-e820: 000000007f6d0000 - 000000007f6e3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007f6e3000 - 0000000080000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
[    0.000000]  BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] e820 update range: 0000000000000000 - 0000000000001000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x7f6d0 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 07F700000 mask FFFF00000 uncachable
[    0.000000]   2 base 07F800000 mask FFF800000 uncachable
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] original variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 2GB, type WB
[    0.000000] reg 1, base: 2039MB, range: 1MB, type UC
[    0.000000] reg 2, base: 2040MB, range: 8MB, type UC
[    0.000000] total RAM covered: 2039M
[    0.000000] Found optimal setting for mtrr clean up
[    0.000000]  gran_size: 64K 	chunk_size: 16M 	num_reg: 3  	lose cover RAM: 0G
[    0.000000] New variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 2GB, type WB
[    0.000000] reg 1, base: 2039MB, range: 1MB, type UC
[    0.000000] reg 2, base: 2040MB, range: 8MB, type UC
[    0.000000] e820 update range: 0000000000001000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 000000000009f800 (usable)
[    0.000000]  modified: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 000000007f6d0000 (usable)
[    0.000000]  modified: 000000007f6d0000 - 000000007f6e3000 (ACPI NVS)
[    0.000000]  modified: 000000007f6e3000 - 0000000080000000 (reserved)
[    0.000000]  modified: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  modified: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  modified: 00000000fed00000 - 00000000fed00400 (reserved)
[    0.000000]  modified: 00000000fed14000 - 00000000fed1a000 (reserved)
[    0.000000]  modified: 00000000fed1c000 - 00000000fed90000 (reserved)
[    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  modified: 00000000ff000000 - 0000000100000000 (reserved)
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] found SMP MP-table at [ffff8800000f7680] f7680
[    0.000000] init_memory_mapping: 0000000000000000-000000007f6d0000
[    0.000000]  0000000000 - 007f600000 page 2M
[    0.000000]  007f600000 - 007f6d0000 page 4k
[    0.000000] kernel direct mapping tables up to 7f6d0000 @ 16000-1a000
[    0.000000] RAMDISK: 37ec3000 - 37ff0000
[    0.000000] ACPI: RSDP 00000000000f7600 00024 (v02 DELL  )
[    0.000000] ACPI: XSDT 000000007f6d6873 00094 (v01 DELL    M08     06040000  LTP 00000000)
[    0.000000] ACPI: FACP 000000007f6decd6 000F4 (v03 TOSCPL CRESTLNE 06040000 ALAN 00000001)
[    0.000000] ACPI: DSDT 000000007f6d7db1 06EB1 (v02 TOSCPL CRESTLNE 06040000 INTL 20060608)
[    0.000000] ACPI: FACS 000000007f6e2fc0 00040
[    0.000000] ACPI: APIC 000000007f6dedca 00068 (v01 INTEL  CRESTLNE 06040000 LOHR 0000005A)
[    0.000000] ACPI: HPET 000000007f6dee32 00038 (v01 INTEL  CRESTLNE 06040000 LOHR 0000005A)
[    0.000000] ACPI: MCFG 000000007f6dee6a 0003C (v01 INTEL  CRESTLNE 06040000 LOHR 0000005A)
[    0.000000] ACPI: TCPA 000000007f6deea6 00032 (v01 Intel  CRESTLNE 06040000 LOHR 0000005A)
[    0.000000] ACPI: TMOR 000000007f6deed8 00026 (v01 PTLTD           06040000 PTL  00000003)
[    0.000000] ACPI: OSFR 000000007f6deefe 00072 (v01 TOSHIB A+2nd ID 06040000 TASM 04010000)
[    0.000000] ACPI: APIC 000000007f6def70 00068 (v01 PTLTD  ? APIC   06040000  LTP 00000000)
[    0.000000] ACPI: BOOT 000000007f6defd8 00028 (v01 PTLTD  $SBFTBL$ 06040000  LTP 00000001)
[    0.000000] ACPI: SSDT 000000007f6d7b04 002AD (v01 SataRe SataAhci 00001000 INTL 20061109)
[    0.000000] ACPI: SSDT 000000007f6d7a61 000A3 (v01 BrtRef  DD01BRT 00001000 INTL 20061109)
[    0.000000] ACPI: SSDT 000000007f6d6e93 0025F (v01  PmRef  Cpu0Tst 00003000 INTL 20061109)
[    0.000000] ACPI: SSDT 000000007f6d6ded 000A6 (v01  PmRef  Cpu1Tst 00003000 INTL 20061109)
[    0.000000] ACPI: SSDT 000000007f6d6907 004E6 (v01  PmRef    CpuPm 00003000 INTL 20061109)
[    0.000000] ACPI: BIOS bug: multiple APIC/MADT found, using 0
[    0.000000] ACPI: If "acpi_apic_instance=2" works better, notify linux-acpi@vger.kernel.org
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000007f6d0000
[    0.000000] Initmem setup node 0 0000000000000000-000000007f6d0000
[    0.000000]   NODE_DATA [0000000001fe21c0 - 0000000001fe71bf]
[    0.000000]  [ffffea0000000000-ffffea0001bfffff] PMD -> [ffff880002800000-ffff8800043fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   empty
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0007f6d0
[    0.000000] On node 0 totalpages: 521823
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3927 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 7080 pages used for memmap
[    0.000000]   DMA32 zone: 510760 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] early_res array is doubled to 64 at [18000 - 187ff]
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000dc000
[    0.000000] PM: Registered nosave memory: 00000000000dc000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 80000000 (gap: 80000000:60000000)
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff880002200000 s80896 r8192 d21504 u1048576
[    0.000000] pcpu-alloc: s80896 r8192 d21504 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 514687
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: root=/dev/sda1 ro video=LVDS-1:d drm.debug=0x6
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Subtract (50 early reservations)
[    0.000000]   #1 [0001000000 - 0001fe15a8]   TEXT DATA BSS
[    0.000000]   #2 [0037ec3000 - 0037ff0000]         RAMDISK
[    0.000000]   #3 [0001fe2000 - 0001fe2184]             BRK
[    0.000000]   #4 [00000f7690 - 0000100000]   BIOS reserved
[    0.000000]   #5 [00000f7680 - 00000f7690]    MP-table mpf
[    0.000000]   #6 [000009f800 - 000009fd71]   BIOS reserved
[    0.000000]   #7 [000009ff15 - 00000f7680]   BIOS reserved
[    0.000000]   #8 [000009fd71 - 000009ff15]    MP-table mpc
[    0.000000]   #9 [0000010000 - 0000012000]      TRAMPOLINE
[    0.000000]   #10 [0000012000 - 0000016000]     ACPI WAKEUP
[    0.000000]   #11 [0000016000 - 0000018000]         PGTABLE
[    0.000000]   #12 [0001fe21c0 - 0001fe71c0]       NODE_DATA
[    0.000000]   #13 [0001fe71c0 - 0001fe81c0]         BOOTMEM
[    0.000000]   #14 [0001fe15c0 - 0001fe1740]         BOOTMEM
[    0.000000]   #15 [00027e9000 - 00027ea000]         BOOTMEM
[    0.000000]   #16 [00027ea000 - 00027eb000]         BOOTMEM
[    0.000000]   #17 [0002800000 - 0004400000]        MEMMAP 0
[    0.000000]   #18 [0001fe1740 - 0001fe1b40]         BOOTMEM
[    0.000000]   #19 [0001fe81c0 - 00020081c0]         BOOTMEM
[    0.000000]   #20 [0002009000 - 000200a000]         BOOTMEM
[    0.000000]   #21 [0001fe1b40 - 0001fe1b81]         BOOTMEM
[    0.000000]   #22 [0001fe1bc0 - 0001fe1c03]         BOOTMEM
[    0.000000]   #23 [0001fe1c40 - 0001fe1f50]         BOOTMEM
[    0.000000]   #24 [0001fe1f80 - 0001fe1fe8]         BOOTMEM
[    0.000000]   #25 [00020081c0 - 0002008228]         BOOTMEM
[    0.000000]   #26 [0002008240 - 00020082a8]         BOOTMEM
[    0.000000]   #27 [00020082c0 - 0002008328]         BOOTMEM
[    0.000000]   #28 [0002008340 - 00020083a8]         BOOTMEM
[    0.000000]   #29 [00020083c0 - 0002008428]         BOOTMEM
[    0.000000]   #30 [0002008440 - 00020084a8]         BOOTMEM
[    0.000000]   #31 [00020084c0 - 0002008528]         BOOTMEM
[    0.000000]   #32 [0002008540 - 00020085a8]         BOOTMEM
[    0.000000]   #33 [00020085c0 - 0002008628]         BOOTMEM
[    0.000000]   #34 [0002008640 - 00020086a8]         BOOTMEM
[    0.000000]   #35 [00020086c0 - 0002008728]         BOOTMEM
[    0.000000]   #36 [0002008740 - 00020087a8]         BOOTMEM
[    0.000000]   #37 [00020087c0 - 00020087e0]         BOOTMEM
[    0.000000]   #38 [0002008800 - 000200882f]         BOOTMEM
[    0.000000]   #39 [0002008840 - 000200886f]         BOOTMEM
[    0.000000]   #40 [0002200000 - 000221b000]         BOOTMEM
[    0.000000]   #41 [0002300000 - 000231b000]         BOOTMEM
[    0.000000]   #42 [0002008880 - 0002008888]         BOOTMEM
[    0.000000]   #43 [00020088c0 - 00020088c8]         BOOTMEM
[    0.000000]   #44 [0002008900 - 0002008908]         BOOTMEM
[    0.000000]   #45 [0002008940 - 0002008950]         BOOTMEM
[    0.000000]   #46 [0002008980 - 0002008ac0]         BOOTMEM
[    0.000000]   #47 [0002008ac0 - 0002008b20]         BOOTMEM
[    0.000000]   #48 [0002008b40 - 0002008ba0]         BOOTMEM
[    0.000000]   #49 [000200a000 - 0002012000]         BOOTMEM
[    0.000000] Memory: 2040704k/2087744k available (3781k kernel code, 452k absent, 46588k reserved, 2895k data, 548k init)
[    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU-based detection of stalled CPUs is disabled.
[    0.000000] 	Verbose stalled-CPUs detection is disabled.
[    0.000000] NR_IRQS:4352 nr_irqs:512
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 5855 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 1795.483 MHz processor.
[    0.001016] Calibrating delay loop (skipped), value calculated using timer frequency.. 3590.96 BogoMIPS (lpj=1795483)
[    0.002006] pid_max: default: 32768 minimum: 301
[    0.002190] Security Framework initialized
[    0.002312] Smack:  Initializing.
[    0.002746] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.004237] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.005018] Mount-cache hash table entries: 256
[    0.006345] Initializing cgroup subsys ns
[    0.006466] Initializing cgroup subsys cpuacct
[    0.006591] Initializing cgroup subsys freezer
[    0.006796] CPU: Physical Processor ID: 0
[    0.006914] CPU: Processor Core ID: 0
[    0.007006] mce: CPU supports 6 MCE banks
[    0.007128] CPU0: Thermal monitoring handled by SMI
[    0.007134] using mwait in idle threads.
[    0.007252] Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
[    0.007499] PEBS disabled due to CPU errata.
[    0.007628] ... version:                2
[    0.007747] ... bit width:              40
[    0.007864] ... generic registers:      2
[    0.008005] ... value mask:             000000ffffffffff
[    0.008125] ... max period:             000000007fffffff
[    0.008243] ... fixed-purpose events:   3
[    0.008361] ... event mask:             0000000700000003
[    0.008607] ACPI: Core revision 20100702
[    0.027214] Setting APIC routing to flat
[    0.027742] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.037932] CPU0: Intel(R) Core(TM)2 Duo CPU     T5670  @ 1.80GHz stepping 0d
[    0.040428] NMI watchdog enabled, takes one hw-pmu counter.
[    0.042053] lockdep: fixing up alternatives.
[    0.043194] Booting Node   0, Processors  #1 Ok.
[    0.001999] CPU1: Thermal monitoring handled by SMI
[    0.115123] NMI watchdog enabled, takes one hw-pmu counter.
[    0.116014] Brought up 2 CPUs
[    0.116130] Total of 2 processors activated (7181.80 BogoMIPS).
[    0.117258] devtmpfs: initialized
[    0.118299] NET: Registered protocol family 16
[    0.119408] ACPI: bus type pci registered
[    0.119712] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.119910] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.176750] PCI: Using configuration type 1 for base access
[    0.178494] bio: create slab <bio-0> at 0
[    0.186498] ACPI: EC: Look up EC in DSDT
[    0.199055] ACPI: BIOS _OSI(Linux) query ignored
[    0.200485] ACPI: SSDT 000000007f6d7761 00238 (v01  PmRef  Cpu0Ist 00003000 INTL 20061109)
[    0.202664] ACPI: Dynamic OEM Table Load:
[    0.202862] ACPI: SSDT (null) 00238 (v01  PmRef  Cpu0Ist 00003000 INTL 20061109)
[    0.203485] ACPI: SSDT 000000007f6d70f2 005EA (v01  PmRef  Cpu0Cst 00003001 INTL 20061109)
[    0.205661] ACPI: Dynamic OEM Table Load:
[    0.205858] ACPI: SSDT (null) 005EA (v01  PmRef  Cpu0Cst 00003001 INTL 20061109)
[    0.206675] ACPI: SSDT 000000007f6d7999 000C8 (v01  PmRef  Cpu1Ist 00003000 INTL 20061109)
[    0.208863] ACPI: Dynamic OEM Table Load:
[    0.209004] ACPI: SSDT (null) 000C8 (v01  PmRef  Cpu1Ist 00003000 INTL 20061109)
[    0.209489] ACPI: SSDT 000000007f6d76dc 00085 (v01  PmRef  Cpu1Cst 00003000 INTL 20061109)
[    0.211709] ACPI: Dynamic OEM Table Load:
[    0.211909] ACPI: SSDT (null) 00085 (v01  PmRef  Cpu1Cst 00003000 INTL 20061109)
[    0.212755] ACPI: Interpreter enabled
[    0.212875] ACPI: (supports S0 S3 S4 S5)
[    0.213309] ACPI: Using IOAPIC for interrupt routing
[    0.296327] ACPI: EC: GPE = 0x1c, I/O: command/status = 0x66, data = 0x62
[    0.297221] ACPI: No dock devices found.
[    0.297339] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.298574] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.300847] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.300972] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.301006] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.301196] pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x000d3fff]
[    0.301388] pci_root PNP0A08:00: host bridge window [mem 0x000d4000-0x000d7fff]
[    0.301577] pci_root PNP0A08:00: host bridge window [mem 0x000d8000-0x000dbfff]
[    0.301765] pci_root PNP0A08:00: host bridge window [mem 0x80000000-0xdfffffff]
[    0.302006] pci_root PNP0A08:00: host bridge window [mem 0xf0000000-0xfebfffff]
[    0.302415] pci 0000:00:02.0: reg 10: [mem 0xf8000000-0xf80fffff 64bit]
[    0.302434] pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.302447] pci 0000:00:02.0: reg 20: [io  0x1800-0x1807]
[    0.302559] pci 0000:00:02.1: reg 10: [mem 0xf8100000-0xf81fffff 64bit]
[    0.302820] pci 0000:00:1a.0: reg 20: [io  0x1820-0x183f]
[    0.303032] pci 0000:00:1a.1: reg 20: [io  0x1840-0x185f]
[    0.303152] pci 0000:00:1a.7: reg 10: [mem 0xf8504800-0xf8504bff]
[    0.303295] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.303303] pci 0000:00:1a.7: PME# disabled
[    0.303379] pci 0000:00:1b.0: reg 10: [mem 0xf8500000-0xf8503fff 64bit]
[    0.303504] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.303511] pci 0000:00:1b.0: PME# disabled
[    0.303676] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.303684] pci 0000:00:1c.0: PME# disabled
[    0.303855] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.303862] pci 0000:00:1c.1: PME# disabled
[    0.304045] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.304053] pci 0000:00:1c.3: PME# disabled
[    0.304231] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.304238] pci 0000:00:1c.4: PME# disabled
[    0.304382] pci 0000:00:1d.0: reg 20: [io  0x1860-0x187f]
[    0.304533] pci 0000:00:1d.1: reg 20: [io  0x1880-0x189f]
[    0.304680] pci 0000:00:1d.2: reg 20: [io  0x18a0-0x18bf]
[    0.304799] pci 0000:00:1d.7: reg 10: [mem 0xf8504c00-0xf8504fff]
[    0.304941] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.304950] pci 0000:00:1d.7: PME# disabled
[    0.305270] pci 0000:00:1f.0: quirk: [io  0x1000-0x107f] claimed by ICH6 ACPI/GPIO/TCO
[    0.305465] pci 0000:00:1f.0: quirk: [io  0x1180-0x11bf] claimed by ICH6 GPIO
[    0.305589] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0680 (mask 007f)
[    0.305781] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 1640 (mask 007f)
[    0.306062] pci 0000:00:1f.1: reg 10: [io  0x0000-0x0007]
[    0.306081] pci 0000:00:1f.1: reg 14: [io  0x0000-0x0003]
[    0.306100] pci 0000:00:1f.1: reg 18: [io  0x0000-0x0007]
[    0.306120] pci 0000:00:1f.1: reg 1c: [io  0x0000-0x0003]
[    0.306139] pci 0000:00:1f.1: reg 20: [io  0x1810-0x181f]
[    0.306258] pci 0000:00:1f.2: reg 10: [io  0x1c00-0x1c07]
[    0.306277] pci 0000:00:1f.2: reg 14: [io  0x18d4-0x18d7]
[    0.306294] pci 0000:00:1f.2: reg 18: [io  0x18d8-0x18df]
[    0.306312] pci 0000:00:1f.2: reg 1c: [io  0x18d0-0x18d3]
[    0.306330] pci 0000:00:1f.2: reg 20: [io  0x18e0-0x18ff]
[    0.306348] pci 0000:00:1f.2: reg 24: [mem 0xf8504000-0xf85047ff]
[    0.306420] pci 0000:00:1f.2: PME# supported from D3hot
[    0.306428] pci 0000:00:1f.2: PME# disabled
[    0.306484] pci 0000:00:1f.3: reg 10: [mem 0x00000000-0x000000ff]
[    0.306546] pci 0000:00:1f.3: reg 20: [io  0x1c20-0x1c3f]
[    0.306689] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.306813] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.306821] pci 0000:00:1c.0:   bridge window [mem 0xc4000000-0xc7ffffff]
[    0.306833] pci 0000:00:1c.0:   bridge window [mem 0xcc000000-0xcdffffff 64bit pref]
[    0.306926] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.307009] pci 0000:00:1c.1:   bridge window [io  0x3000-0x3fff]
[    0.307017] pci 0000:00:1c.1:   bridge window [mem 0xf0000000-0xf3ffffff]
[    0.307030] pci 0000:00:1c.1:   bridge window [mem 0xfa000000-0xfbffffff 64bit pref]
[    0.307289] pci 0000:06:00.0: reg 10: [mem 0xf4000000-0xf4000fff]
[    0.307676] pci 0000:06:00.0: PME# supported from D0 D3hot D3cold
[    0.307692] pci 0000:06:00.0: PME# disabled
[    0.307760] pci 0000:06:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.308166] pci 0000:00:1c.3: PCI bridge to [bus 06-06]
[    0.308290] pci 0000:00:1c.3:   bridge window [io  0x4000-0x4fff]
[    0.308298] pci 0000:00:1c.3:   bridge window [mem 0xf4000000-0xf7ffffff]
[    0.308311] pci 0000:00:1c.3:   bridge window [mem 0xfc000000-0xfdffffff 64bit pref]
[    0.308549] pci 0000:07:00.0: reg 10: [io  0x5000-0x50ff]
[    0.308677] pci 0000:07:00.0: reg 18: [mem 0xf8610000-0xf8610fff 64bit pref]
[    0.308756] pci 0000:07:00.0: reg 20: [mem 0xf8600000-0xf860ffff 64bit pref]
[    0.308808] pci 0000:07:00.0: reg 30: [mem 0x00000000-0x0000ffff pref]
[    0.308987] pci 0000:07:00.0: supports D1 D2
[    0.308990] pci 0000:07:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.309018] pci 0000:07:00.0: PME# disabled
[    0.309195] pci 0000:00:1c.4: PCI bridge to [bus 07-07]
[    0.309320] pci 0000:00:1c.4:   bridge window [io  0x5000-0x5fff]
[    0.309328] pci 0000:00:1c.4:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.309341] pci 0000:00:1c.4:   bridge window [mem 0xf8600000-0xf86fffff 64bit pref]
[    0.309454] pci 0000:08:05.0: reg 10: [mem 0xf8200000-0xf8200fff]
[    0.309474] pci 0000:08:05.0: reg 14: [mem 0xf8202000-0xf82027ff]
[    0.309591] pci 0000:08:05.0: supports D1 D2
[    0.309595] pci 0000:08:05.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.309602] pci 0000:08:05.0: PME# disabled
[    0.309673] pci 0000:08:05.2: reg 10: [mem 0xf8202800-0xf82028ff]
[    0.309814] pci 0000:08:05.2: supports D1 D2
[    0.309817] pci 0000:08:05.2: PME# supported from D0 D1 D2 D3hot D3cold
[    0.309826] pci 0000:08:05.2: PME# disabled
[    0.309896] pci 0000:08:05.3: reg 10: [mem 0xf8201000-0xf8201fff]
[    0.310048] pci 0000:08:05.3: supports D1 D2
[    0.310052] pci 0000:08:05.3: PME# supported from D0 D1 D2 D3hot D3cold
[    0.310060] pci 0000:08:05.3: PME# disabled
[    0.310155] pci 0000:00:1e.0: PCI bridge to [bus 08-08] (subtractive decode)
[    0.310282] pci 0000:00:1e.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.310291] pci 0000:00:1e.0:   bridge window [mem 0xf8200000-0xf82fffff]
[    0.310303] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.310307] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.310311] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.310316] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.310320] pci 0000:00:1e.0:   bridge window [mem 0x000d0000-0x000d3fff] (subtractive decode)
[    0.310324] pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive decode)
[    0.310328] pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
[    0.310332] pci 0000:00:1e.0:   bridge window [mem 0x80000000-0xdfffffff] (subtractive decode)
[    0.310336] pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xfebfffff] (subtractive decode)
[    0.310389] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.311062] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.311209] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    0.311369] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP04._PRT]
[    0.311517] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP05._PRT]
[    0.311767] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
[    0.311940] Unable to assume PCIe control: Disabling ASPM
[    0.334406] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 *5 6 7 10 12 14 15)
[    0.335136] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    0.335879] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 *10 12 14 15)
[    0.336613] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    0.337364] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
[    0.338244] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    0.339052] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 *10 12 14 15)
[    0.339798] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
[    0.341094] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.341335] vgaarb: loaded
[    0.341590] usbcore: registered new interface driver usbfs
[    0.341750] usbcore: registered new interface driver hub
[    0.341880] usbcore: registered new device driver usb
[    0.342111] PCI: Using ACPI for IRQ routing
[    0.342229] PCI: pci_cache_line_size set to 64 bytes
[    0.342496] reserve RAM buffer: 000000000009f800 - 000000000009ffff 
[    0.342501] reserve RAM buffer: 000000007f6d0000 - 000000007fffffff 
[    0.343430] cfg80211: Calling CRDA to update world regulatory domain
[    0.343602] NetLabel: Initializing
[    0.344004] NetLabel:  domain hash size = 128
[    0.344121] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.344319] NetLabel:  unlabeled traffic allowed by default
[    0.344597] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.344881] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.348065] Switching to clocksource tsc
[    0.355660] pnp: PnP ACPI init
[    0.355831] ACPI: bus type pnp registered
[    0.387991] pnp: PnP ACPI: found 10 devices
[    0.388111] ACPI: ACPI bus type pnp unregistered
[    0.388262] system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.388385] system 00:01: [mem 0xfed14000-0xfed17fff] has been reserved
[    0.388507] system 00:01: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.388637] system 00:01: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.388758] system 00:01: [mem 0xe0000000-0xefffffff] has been reserved
[    0.388881] system 00:01: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.389005] system 00:01: [mem 0xfed40000-0xfed44fff] has been reserved
[    0.389127] system 00:01: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.389261] system 00:04: [mem 0xfed00000-0xfed003ff] has been reserved
[    0.389395] system 00:06: [io  0x0680-0x069f] has been reserved
[    0.389515] system 00:06: [io  0x0800-0x080f] has been reserved
[    0.389644] system 00:06: [io  0x1000-0x107f] has been reserved
[    0.389764] system 00:06: [io  0x1180-0x11bf] has been reserved
[    0.389884] system 00:06: [io  0xfe00] has been reserved
[    0.390004] system 00:06: [io  0xff00-0xff7f] has been reserved
[    0.399574] pci 0000:00:1c.4: BAR 8: assigned [mem 0x80000000-0x803fffff]
[    0.399702] pci 0000:00:1f.3: BAR 0: assigned [mem 0x80400000-0x804000ff]
[    0.399831] pci 0000:00:1f.3: BAR 0: set to [mem 0x80400000-0x804000ff] (PCI address [0x80400000-0x804000ff]
[    0.400029] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.400151] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.400276] pci 0000:00:1c.0:   bridge window [mem 0xc4000000-0xc7ffffff]
[    0.400404] pci 0000:00:1c.0:   bridge window [mem 0xcc000000-0xcdffffff 64bit pref]
[    0.400617] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.400740] pci 0000:00:1c.1:   bridge window [io  0x3000-0x3fff]
[    0.400865] pci 0000:00:1c.1:   bridge window [mem 0xf0000000-0xf3ffffff]
[    0.400993] pci 0000:00:1c.1:   bridge window [mem 0xfa000000-0xfbffffff 64bit pref]
[    0.401192] pci 0000:00:1c.3: PCI bridge to [bus 06-06]
[    0.401316] pci 0000:00:1c.3:   bridge window [io  0x4000-0x4fff]
[    0.401446] pci 0000:00:1c.3:   bridge window [mem 0xf4000000-0xf7ffffff]
[    0.401578] pci 0000:00:1c.3:   bridge window [mem 0xfc000000-0xfdffffff 64bit pref]
[    0.401781] pci 0000:07:00.0: BAR 6: assigned [mem 0xf8620000-0xf862ffff pref]
[    0.401975] pci 0000:00:1c.4: PCI bridge to [bus 07-07]
[    0.402097] pci 0000:00:1c.4:   bridge window [io  0x5000-0x5fff]
[    0.402223] pci 0000:00:1c.4:   bridge window [mem 0x80000000-0x803fffff]
[    0.402351] pci 0000:00:1c.4:   bridge window [mem 0xf8600000-0xf86fffff 64bit pref]
[    0.402563] pci 0000:00:1e.0: PCI bridge to [bus 08-08]
[    0.402683] pci 0000:00:1e.0:   bridge window [io  disabled]
[    0.404737] pci 0000:00:1e.0:   bridge window [mem 0xf8200000-0xf82fffff]
[    0.404861] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    0.405018]   alloc irq_desc for 17 on node -1
[    0.405022]   alloc kstat_irqs on node -1
[    0.405031] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.405156] pci 0000:00:1c.0: setting latency timer to 64
[    0.405174]   alloc irq_desc for 16 on node -1
[    0.405177]   alloc kstat_irqs on node -1
[    0.405184] pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.405308] pci 0000:00:1c.1: setting latency timer to 64
[    0.405325]   alloc irq_desc for 19 on node -1
[    0.405327]   alloc kstat_irqs on node -1
[    0.405334] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    0.405459] pci 0000:00:1c.3: setting latency timer to 64
[    0.405475] pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.405606] pci 0000:00:1c.4: setting latency timer to 64
[    0.405620] pci 0000:00:1e.0: setting latency timer to 64
[    0.405626] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.405630] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.405633] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.405637] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000d3fff]
[    0.405640] pci_bus 0000:00: resource 8 [mem 0x000d4000-0x000d7fff]
[    0.405644] pci_bus 0000:00: resource 9 [mem 0x000d8000-0x000dbfff]
[    0.405647] pci_bus 0000:00: resource 10 [mem 0x80000000-0xdfffffff]
[    0.405651] pci_bus 0000:00: resource 11 [mem 0xf0000000-0xfebfffff]
[    0.405654] pci_bus 0000:02: resource 0 [io  0x2000-0x2fff]
[    0.405658] pci_bus 0000:02: resource 1 [mem 0xc4000000-0xc7ffffff]
[    0.405661] pci_bus 0000:02: resource 2 [mem 0xcc000000-0xcdffffff 64bit pref]
[    0.405665] pci_bus 0000:03: resource 0 [io  0x3000-0x3fff]
[    0.405668] pci_bus 0000:03: resource 1 [mem 0xf0000000-0xf3ffffff]
[    0.405672] pci_bus 0000:03: resource 2 [mem 0xfa000000-0xfbffffff 64bit pref]
[    0.405676] pci_bus 0000:06: resource 0 [io  0x4000-0x4fff]
[    0.405679] pci_bus 0000:06: resource 1 [mem 0xf4000000-0xf7ffffff]
[    0.405683] pci_bus 0000:06: resource 2 [mem 0xfc000000-0xfdffffff 64bit pref]
[    0.405687] pci_bus 0000:07: resource 0 [io  0x5000-0x5fff]
[    0.405690] pci_bus 0000:07: resource 1 [mem 0x80000000-0x803fffff]
[    0.405694] pci_bus 0000:07: resource 2 [mem 0xf8600000-0xf86fffff 64bit pref]
[    0.405697] pci_bus 0000:08: resource 1 [mem 0xf8200000-0xf82fffff]
[    0.405701] pci_bus 0000:08: resource 4 [io  0x0000-0x0cf7]
[    0.405704] pci_bus 0000:08: resource 5 [io  0x0d00-0xffff]
[    0.405708] pci_bus 0000:08: resource 6 [mem 0x000a0000-0x000bffff]
[    0.405711] pci_bus 0000:08: resource 7 [mem 0x000d0000-0x000d3fff]
[    0.405714] pci_bus 0000:08: resource 8 [mem 0x000d4000-0x000d7fff]
[    0.405718] pci_bus 0000:08: resource 9 [mem 0x000d8000-0x000dbfff]
[    0.405721] pci_bus 0000:08: resource 10 [mem 0x80000000-0xdfffffff]
[    0.405725] pci_bus 0000:08: resource 11 [mem 0xf0000000-0xfebfffff]
[    0.405810] NET: Registered protocol family 2
[    0.406232] IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.408040] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.411141] TCP bind hash table entries: 65536 (order: 9, 3670016 bytes)
[    0.417841] TCP: Hash tables configured (established 262144 bind 65536)
[    0.418038] TCP reno registered
[    0.418197] UDP hash table entries: 1024 (order: 5, 131072 bytes)
[    0.418563] UDP-Lite hash table entries: 1024 (order: 5, 131072 bytes)
[    0.419126] NET: Registered protocol family 1
[    0.419282] pci 0000:00:02.0: Boot video device
[    0.419302] pci 0000:00:1a.0: uhci_check_and_reset_hc: legsup = 0x3e00
[    0.419305] pci 0000:00:1a.0: Performing full reset
[    0.419331] pci 0000:00:1a.1: uhci_check_and_reset_hc: legsup = 0x2000
[    0.419334] pci 0000:00:1a.1: Performing full reset
[    0.419423] pci 0000:00:1d.0: uhci_check_and_reset_hc: legsup = 0x2e00
[    0.419426] pci 0000:00:1d.0: Performing full reset
[    0.419453] pci 0000:00:1d.1: uhci_check_and_reset_hc: legsup = 0x2000
[    0.419456] pci 0000:00:1d.1: Performing full reset
[    0.419481] pci 0000:00:1d.2: uhci_check_and_reset_hc: legsup = 0x2000
[    0.419484] pci 0000:00:1d.2: Performing full reset
[    0.419599] PCI: CLS 64 bytes, default 64
[    0.419919] Trying to unpack rootfs image as initramfs...
[    0.708791] Freeing initrd memory: 1204k freed
[    0.709588] Simple Boot Flag at 0x36 set to 0x1
[    0.710888] microcode: CPU0 sig=0x6fd, pf=0x80, revision=0xa1
[    0.711026] microcode: CPU1 sig=0x6fd, pf=0x80, revision=0xa1
[    0.711210] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.711396] Scanning for low memory corruption every 60 seconds
[    0.711921] cryptomgr_test used greatest stack depth: 6448 bytes left
[    0.712167] audit: initializing netlink socket (disabled)
[    0.712354] type=2000 audit(1282639963.710:1): initialized
[    0.739438] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.743796] VFS: Disk quotas dquot_6.5.2
[    0.744078] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.744676] msgmni has been set to 3988
[    0.745474] cryptomgr_test used greatest stack depth: 6080 bytes left
[    0.745955] alg: No test for stdrng (krng)
[    0.746187] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.746395] io scheduler noop registered
[    0.746521] io scheduler deadline registered
[    0.746725] io scheduler cfq registered (default)
[    0.747183] pcieport 0000:00:1c.0: setting latency timer to 64
[    0.747414] pcieport 0000:00:1c.1: setting latency timer to 64
[    0.747642] pcieport 0000:00:1c.3: setting latency timer to 64
[    0.747863] pcieport 0000:00:1c.4: setting latency timer to 64
[    0.748222] intel_idle: MWAIT substates: 0x22220
[    0.748225] intel_idle: does not run on family 6 model 15
[    0.753055] ACPI: AC Adapter [ACAD] (on-line)
[    0.753426] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input0
[    0.753718] ACPI: Lid Switch [LID0]
[    0.753960] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input1
[    0.754206] ACPI: Power Button [PWRB]
[    0.754448] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input2
[    0.754647] ACPI: Sleep Button [SLPB]
[    0.754923] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    0.755112] ACPI: Power Button [PWRF]
[    0.755352] ACPI: acpi_idle registered with cpuidle
[    0.761169] Monitor-Mwait will be used to enter C-1 state
[    0.761235] Monitor-Mwait will be used to enter C-2 state
[    0.761289] Monitor-Mwait will be used to enter C-3 state
[    0.761299] Marking TSC unstable due to TSC halts in idle
[    0.761874] Switching to clocksource hpet
[    0.999612] ACPI: Battery Slot [BAT1] (battery present)
[    1.000060] Non-volatile memory driver v1.3
[    1.000553] Linux agpgart interface v0.103
[    1.000927] agpgart-intel 0000:00:00.0: Intel 965GM Chipset
[    1.001931] agpgart-intel 0000:00:00.0: detected 7676K stolen memory
[    1.006723] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    1.006950] [drm] Initialized drm 1.1.0 20060810
[    1.007134] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.007258] i915 0000:00:02.0: setting latency timer to 64
[    1.080799] [drm:i915_init_phys_hws], Enabled hardware status page
[    1.080824] [drm] set up 7M of stolen space
[    1.081675] [drm:i915_gtt_to_phys], GTT addr: 0x00000000, PTE: 0x7f800001
[    1.081751] [drm:i915_gtt_to_phys], GTT addr: 0x00000000, phys addr: 0x7f800000
[    1.081898] [drm:i915_gtt_to_phys], GTT addr: 0x006c8000, PTE: 0x7e9eb001
[    1.081972] [drm:i915_gtt_to_phys], GTT addr: 0x006c8000, phys addr: 0x7e9eb000
[    1.081977] [drm:i915_setup_compression], FBC base 0x7f800000, ll base 0x7e9eb000, size 6M
[    1.082028] [drm:parse_general_definitions], crt_ddc_bus_pin: 2
[    1.082036] [drm:parse_lfp_panel_data], Found panel mode in BIOS VBT tables:
[    1.082040] [drm:drm_mode_debug_printmodeline], Modeline 0:"1280x800" 0 69300 1280 1304 1336 1416 800 804 810 817 0x8 0xa
[    1.082056] [drm:parse_sdvo_device_mapping], No SDVO device info is found in VBT
[    1.082246] [drm:intel_modeset_init], 2 display pipes available.
[    1.189327] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    1.189915] [drm] initialized overlay support
[    1.300385] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 1
[    1.310545] [drm:drm_fb_helper_connector_parse_command_line], cmdline mode for connector LVDS-1 0x0@60Hz
[    1.310552] [drm] forcing LVDS-1 connector OFF
[    1.310669] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[    1.310673] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] disconnected
[    1.310700] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
[    1.425531] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] probed modes :
[    1.425536] [drm:drm_mode_debug_printmodeline], Modeline 29:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[    1.425544] [drm:drm_mode_debug_printmodeline], Modeline 39:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[    1.425550] [drm:drm_mode_debug_printmodeline], Modeline 30:"1280x960" 60 108000 1280 1376 1488 1800 960 961 964 1000 0x40 0x5
[    1.425557] [drm:drm_mode_debug_printmodeline], Modeline 46:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[    1.425564] [drm:drm_mode_debug_printmodeline], Modeline 40:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[    1.425570] [drm:drm_mode_debug_printmodeline], Modeline 41:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[    1.425577] [drm:drm_mode_debug_printmodeline], Modeline 42:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[    1.425583] [drm:drm_mode_debug_printmodeline], Modeline 43:"832x624" 75 57284 832 864 928 1152 624 625 628 667 0x40 0xa
[    1.425589] [drm:drm_mode_debug_printmodeline], Modeline 45:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[    1.425596] [drm:drm_mode_debug_printmodeline], Modeline 44:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[    1.425602] [drm:drm_mode_debug_printmodeline], Modeline 32:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[    1.425609] [drm:drm_mode_debug_printmodeline], Modeline 33:"800x600" 56 36000 800 824 896 1024 600 601 603 625 0x40 0x5
[    1.425615] [drm:drm_mode_debug_printmodeline], Modeline 35:"640x480" 73 31500 640 664 704 832 480 489 491 520 0x40 0xa
[    1.425621] [drm:drm_mode_debug_printmodeline], Modeline 34:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[    1.425628] [drm:drm_mode_debug_printmodeline], Modeline 36:"640x480" 67 30240 640 704 768 864 480 483 486 525 0x40 0xa
[    1.425634] [drm:drm_mode_debug_printmodeline], Modeline 37:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[    1.425640] [drm:drm_mode_debug_printmodeline], Modeline 38:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[    1.425647] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1]
[    1.425656] [drm:drm_crtc_helper_set_mode], [CRTC:3]
[    1.425665] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 0
[    1.436075] [drm:intel_crtc_mode_set], Mode for pipe A:
[    1.436079] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[    1.487012] [drm:intel_wait_for_vblank], vblank wait timed out
[    1.487017] [drm:intel_pipe_set_base], No FB bound
[    1.487022] [drm:drm_crtc_helper_set_mode], [ENCODER:15:TV-15] set [MODE:0:NTSC 480i]
[    1.538012] [drm:intel_wait_for_vblank], vblank wait timed out
[    1.538033] [drm:intel_update_watermarks], plane A (pipe 0) clock: 107520
[    1.538038] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[    1.538042] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[    1.538072] [drm:intel_update_fbc], 
[    1.589013] [drm:intel_wait_for_vblank], vblank wait timed out
[    1.640012] [drm:intel_wait_for_vblank], vblank wait timed out
[    1.691012] [drm:intel_wait_for_vblank], vblank wait timed out
[    1.691016] [drm:intel_tv_detect_type], No TV connection detected
[    1.811195] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 1
[    1.821353] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1] disconnected
[    1.821359] [drm:drm_setup_crtcs], 
[    1.821363] [drm:drm_enable_connectors], connector 5 enabled? no
[    1.821367] [drm:drm_enable_connectors], connector 12 enabled? yes
[    1.821371] [drm:drm_enable_connectors], connector 14 enabled? no
[    1.821375] [drm:drm_target_preferred], looking for cmdline mode on connector 12
[    1.821380] [drm:drm_target_preferred], looking for preferred mode on connector 12
[    1.821384] [drm:drm_target_preferred], found mode 1280x1024
[    1.821388] [drm:drm_setup_crtcs], picking CRTCs for 8192x8192 config
[    1.821394] [drm:drm_setup_crtcs], desired mode 1280x1024 set on crtc 3
[    1.831092] [drm:intelfb_create], allocated 1280x1024 fb: 0x00800000, bo ffff88007a28f400
[    1.833340] [drm:drm_crtc_helper_set_config], 
[    1.833343] [drm:drm_crtc_helper_set_config], [CRTC:3] [FB:47] #connectors=1 (x y) (0 0)
[    1.833352] [drm:drm_crtc_helper_set_config], crtc has no fb, full mode set
[    1.833355] [drm:drm_crtc_helper_set_config], modes are different, full mode set
[    1.833358] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[    1.833364] [drm:drm_mode_debug_printmodeline], Modeline 31:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[    1.833373] [drm:drm_crtc_helper_set_config], encoder changed, full mode switch
[    1.833377] [drm:drm_crtc_helper_set_config], crtc changed, full mode switch
[    1.833380] [drm:drm_crtc_helper_set_config], [CONNECTOR:12:VGA-1] to [CRTC:3]
[    1.833384] [drm:drm_crtc_helper_set_config], attempting to set mode from userspace
[    1.833387] [drm:drm_mode_debug_printmodeline], Modeline 31:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[    1.833395] [drm:drm_crtc_helper_set_mode], [CRTC:3]
[    1.833429] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 0
[    1.843826] [drm:intel_crtc_mode_set], Mode for pipe A:
[    1.843829] [drm:drm_mode_debug_printmodeline], Modeline 31:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[    1.895012] [drm:intel_wait_for_vblank], vblank wait timed out
[    1.895044] [drm:intel_pipe_set_base], Writing base 00800000 00000000 0 0 5120
[    1.895048] [drm:intel_update_fbc], 
[    1.895051] [drm:intel_update_fbc], 1 pipes active
[    1.895054] [drm:intel_update_fbc], framebuffer not tiled, disabling compression
[    1.946013] [drm:intel_wait_for_vblank], vblank wait timed out
[    1.946018] [drm:drm_crtc_helper_set_mode], [ENCODER:13:DAC-13] set [MODE:31:1280x1024]
[    1.946023] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[    1.946026] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[    1.946030] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[    1.946059] [drm:intel_update_fbc], 
[    1.946061] [drm:intel_update_fbc], 1 pipes active
[    1.946064] [drm:intel_update_fbc], framebuffer not tiled, disabling compression
[    1.946078] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 1
[    1.956234] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[    1.956238] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[    1.956242] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[    1.956246] [drm:drm_crtc_helper_set_config], 
[    1.956249] [drm:drm_crtc_helper_set_config], [CRTC:4] [FB:47] #connectors=0 (x y) (0 0)
[    1.956255] [drm:drm_crtc_helper_set_config], crtc has no fb, full mode set
[    1.956259] [drm:drm_crtc_helper_set_config], [CONNECTOR:12:VGA-1] to [CRTC:3]
[    1.956266] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 1
[    1.966422] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[    1.966425] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[    1.966429] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[    1.967831] [drm:drm_crtc_helper_set_config], 
[    1.967834] [drm:drm_crtc_helper_set_config], [CRTC:3] [FB:47] #connectors=1 (x y) (0 0)
[    1.967843] [drm:drm_crtc_helper_set_config], [CONNECTOR:12:VGA-1] to [CRTC:3]
[    1.971966] [drm:drm_crtc_helper_set_config], 
[    1.971969] [drm:drm_crtc_helper_set_config], [CRTC:3] [FB:47] #connectors=1 (x y) (0 0)
[    1.971978] [drm:drm_crtc_helper_set_config], [CONNECTOR:12:VGA-1] to [CRTC:3]
[    1.976062] Console: switching to colour frame buffer device 160x64
[    1.976070] [drm:drm_crtc_helper_set_config], 
[    1.976072] [drm:drm_crtc_helper_set_config], [CRTC:3] [FB:47] #connectors=1 (x y) (0 0)
[    1.976081] [drm:drm_crtc_helper_set_config], [CONNECTOR:12:VGA-1] to [CRTC:3]
[    1.980220] fb0: inteldrmfb frame buffer device
[    1.980249] drm: registered panic notifier
[    1.980316] [drm:intel_opregion_init], graphic opregion physical addr: 0x7f6dfe3c
[    1.980335] [drm:intel_opregion_init], Public ACPI methods supported
[    1.980647] [drm:intel_opregion_init], SWSCI supported
[    1.980651] [drm:intel_opregion_init], ASLE supported
[    1.999151] acpi device:07: registered as cooling_device2
[    1.999693] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:01/input/input4
[    1.999765] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[    1.999924] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    2.003356] brd: module loaded
[    2.003433] console [netcon0] enabled
[    2.003458] netconsole: network logging started
[    2.003787] usbcore: registered new interface driver libusual
[    2.003923] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    2.035967] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.036061] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.036278] mice: PS/2 mouse device common for all mice
[    2.036396] rtc_cmos 00:07: RTC can wake from S4
[    2.036762] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
[    2.036852] rtc0: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    2.036911] i2c /dev entries driver
[    2.037489]   alloc irq_desc for 18 on node -1
[    2.037493]   alloc kstat_irqs on node -1
[    2.037530] i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    2.037590] ACPI: resource 0000:00:1f.3 [io  0x1c20-0x1c3f] conflicts with ACPI region SMBI [io  0x1c20-0x1c2f disabled]
[    2.037656] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    2.037969] cpuidle: using governor ladder
[    2.038635] cpuidle: using governor menu
[    2.038746] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[    2.039229] usbcore: registered new interface driver hiddev
[    2.039292] usbcore: registered new interface driver usbhid
[    2.039328] usbhid: USB HID core driver
[    2.039399] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    2.041650] ip_tables: (C) 2000-2006 Netfilter Core Team
[    2.041810] TCP cubic registered
[    2.041833] Initializing XFRM netlink socket
[    2.041887] NET: Registered protocol family 17
[    2.041924] lib80211: common routines for IEEE802.11 drivers
[    2.041969] lib80211_crypt: registered algorithm 'NULL'
[    2.041972] Registering the dns_resolver key type
[    2.043638] registered taskstats version 1
[    2.044516] rtc_cmos 00:07: setting system clock to 2010-08-24 08:52:45 UTC (1282639965)
[    2.044570] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    2.044611] EDD information not available.
[    2.044741] Initalizing network drop monitor service
[    2.047344] Freeing unused kernel memory: 548k freed
[    2.049514] Write protecting the kernel read-only data: 6144k
[    2.051741] Freeing unused kernel memory: 292k freed
[    2.053962] Freeing unused kernel memory: 260k freed
[    2.060950] busybox used greatest stack depth: 5688 bytes left
[    2.063271] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input5
[    2.070135] mount used greatest stack depth: 5632 bytes left
[    2.080961] udev: starting version 161
[    2.083079] udevd (55): /proc/55/oom_adj is deprecated, please use /proc/55/oom_score_adj instead.
[    2.091350] init used greatest stack depth: 5576 bytes left
[    2.149443] load-modules.sh used greatest stack depth: 5400 bytes left
[    2.158520] sed used greatest stack depth: 5312 bytes left
[    2.267275] modprobe used greatest stack depth: 5248 bytes left
[    2.280552] modprobe used greatest stack depth: 4976 bytes left
[    2.362992] udevadm used greatest stack depth: 4112 bytes left
[    2.642783] SCSI subsystem initialized
[    2.674678] libata version 3.00 loaded.
[    2.683054] ahci 0000:00:1f.2: version 3.0
[    2.683084] ahci 0000:00:1f.2: PCI INT B -> GSI 18 (level, low) -> IRQ 18
[    2.685347] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 3 ports 3 Gbps 0x7 impl SATA mode
[    2.687419] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ccc 
[    2.689505] ahci 0000:00:1f.2: setting latency timer to 64
[    2.689888] scsi0 : ahci
[    2.692556] scsi1 : ahci
[    2.694786] scsi2 : ahci
[    2.697291] ata1: SATA max UDMA/133 irq 18, connection status changed
[    2.699347] ata2: SATA max UDMA/133 abar m2048@0xf8504000 port 0xf8504180 irq 18
[    2.701390] ata3: SATA max UDMA/133 abar m2048@0xf8504000 port 0xf8504200 irq 18
[    2.703586] pata_acpi 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    2.705681] pata_acpi 0000:00:1f.1: setting latency timer to 64
[    2.705709] pata_acpi 0000:00:1f.1: PCI INT A disabled
[    3.008169] ata2: SATA link down (SStatus 0 SControl 300)
[    3.010273] ata3: SATA link down (SStatus 0 SControl 300)
[    3.426132] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    3.428870] ata1.00: unexpected _GTF length (8)
[    3.476717] ata1.00: ATA-8: WDC WD1600BEVT-75ZCT0, 11.01A11, max UDMA/133
[    3.478690] ata1.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    3.481633] ata1.00: unexpected _GTF length (8)
[    3.483898] ata1.00: configured for UDMA/133
[    3.497087] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1600BEVT-7 11.0 PQ: 0 ANSI: 5
[    3.504613] ata_piix 0000:00:1f.1: version 2.13
[    3.504637] ata_piix 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    3.506893] ata_piix 0000:00:1f.1: setting latency timer to 64
[    3.507061] scsi3 : ata_piix
[    3.510110] scsi4 : ata_piix
[    3.513385] ata4: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x1810 irq 14
[    3.515422] ata5: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x1818 irq 15
[    3.519503] sd 0:0:0:0: [sda] 312581808 512-byte logical blocks: (160 GB/149 GiB)
[    3.521569] sd 0:0:0:0: [sda] Write Protect is off
[    3.523499] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.523560] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.537297]  sda: sda1 sda2 sda3 sda4
[    3.540464] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.698604] ata4.00: ATAPI: TEAC   DVD+/-RW DVW28SLC, A.06, max UDMA/33
[    3.738381] ata4.00: configured for UDMA/33
[    3.754478] scsi 3:0:0:0: CD-ROM            TEAC     DVD+-RW DVW28SLC A.06 PQ: 0 ANSI: 5
[    3.801686] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda caddy
[    3.803780] cdrom: Uniform CD-ROM driver Revision: 3.20
[    3.806308] sr 3:0:0:0: Attached scsi CD-ROM sr0
[    4.342184] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[    5.820203] udev: starting version 161
[    6.363697] iTCO_vendor_support: vendor-support=0
[    6.385214] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    6.385219] ehci_hcd: block sizes: qh 104 qtd 96 itd 192 sitd 96
[    6.385300] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    6.385332] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    6.385339] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    6.385905] drivers/usb/core/inode.c: creating file 'devices'
[    6.386112] drivers/usb/core/inode.c: creating file '001'
[    6.386678] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    6.386691] ehci_hcd 0000:00:1a.7: reset hcs_params 0x102204 dbg=1 cc=2 pcc=2 ordered !ppc ports=4
[    6.386698] ehci_hcd 0000:00:1a.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr hw prefetch
[    6.386779] ehci_hcd 0000:00:1a.7: debug port 1
[    6.386787] ehci_hcd 0000:00:1a.7: reset command 0080032 (park)=0 ithresh=8 Async Periodic period=1024 Reset HALT
[    6.451698] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
[    6.451703] ehci_hcd 0000:00:1a.7: supports USB remote wakeup
[    6.451722] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xf8504800
[    6.451730] ehci_hcd 0000:00:1a.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    6.496327] ehci_hcd 0000:00:1a.7: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
[    6.503128] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    6.503534] usb usb1: default language 0x0409
[    6.503560] usb usb1: udev 1, busnum 1, minor = 0
[    6.503564] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    6.503568] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.503571] usb usb1: Product: EHCI Host Controller
[    6.503575] usb usb1: Manufacturer: Linux 2.6.36-rc2-RC ehci_hcd
[    6.503578] usb usb1: SerialNumber: 0000:00:1a.7
[    6.504538] usb usb1: usb_probe_device
[    6.504544] usb usb1: configuration #1 chosen from 1 choice
[    6.504787] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    6.505115] hub 1-0:1.0: usb_probe_interface
[    6.505119] hub 1-0:1.0: usb_probe_interface - got id
[    6.505128] hub 1-0:1.0: USB hub found
[    6.505190] hub 1-0:1.0: 4 ports detected
[    6.505194] hub 1-0:1.0: standalone hub
[    6.505197] hub 1-0:1.0: no power switching (usb 1.0)
[    6.505200] hub 1-0:1.0: individual port over-current protection
[    6.505204] hub 1-0:1.0: power on to power good time: 20ms
[    6.505368] hub 1-0:1.0: local power source is good
[    6.505373] hub 1-0:1.0: trying to enable port power on non-switchable hub
[    6.505483] drivers/usb/core/inode.c: creating file '001'
[    6.505794]   alloc irq_desc for 23 on node -1
[    6.505798]   alloc kstat_irqs on node -1
[    6.505811] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    6.505854] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    6.505861] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    6.505877] drivers/usb/core/inode.c: creating file '002'
[    6.506170] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    6.506184] ehci_hcd 0000:00:1d.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[    6.506190] ehci_hcd 0000:00:1d.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr hw prefetch
[    6.506236] ehci_hcd 0000:00:1d.7: debug port 1
[    6.506243] ehci_hcd 0000:00:1d.7: reset command 0080032 (park)=0 ithresh=8 Async Periodic period=1024 Reset HALT
[    6.543473] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    6.543479] ehci_hcd 0000:00:1d.7: supports USB remote wakeup
[    6.543528] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xf8504c00
[    6.543536] ehci_hcd 0000:00:1d.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    6.556128] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.06
[    6.564578] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    6.564687] sr 3:0:0:0: Attached scsi generic sg1 type 5
[    6.568389] ACPI: WMI: Mapper loaded
[    6.570993] iTCO_wdt: Found a ICH8M TCO device (Version=2, TCOBASE=0x1060)
[    6.575987] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    6.592648] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    6.592702] r8169 0000:07:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    6.592831] r8169 0000:07:00.0: setting latency timer to 64
[    6.592860] r8169 0000:07:00.0: no MSI. Back to INTx.
[    6.594179] r8169 0000:07:00.0: eth0: RTL8168c/8111c at 0xffffc900214da000, 00:1c:23:4e:23:72, XID 1c4000c0 IRQ 16
[    6.596317] ehci_hcd 0000:00:1d.7: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
[    6.602043] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    6.602223] usb usb2: default language 0x0409
[    6.602246] usb usb2: udev 1, busnum 2, minor = 128
[    6.602249] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    6.602253] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.602257] usb usb2: Product: EHCI Host Controller
[    6.602260] usb usb2: Manufacturer: Linux 2.6.36-rc2-RC ehci_hcd
[    6.602263] usb usb2: SerialNumber: 0000:00:1d.7
[    6.602557] usb usb2: usb_probe_device
[    6.602563] usb usb2: configuration #1 chosen from 1 choice
[    6.602587] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[    6.602670] hub 2-0:1.0: usb_probe_interface
[    6.602674] hub 2-0:1.0: usb_probe_interface - got id
[    6.602681] hub 2-0:1.0: USB hub found
[    6.602695] hub 2-0:1.0: 6 ports detected
[    6.602699] hub 2-0:1.0: standalone hub
[    6.602702] hub 2-0:1.0: no power switching (usb 1.0)
[    6.602705] hub 2-0:1.0: individual port over-current protection
[    6.602709] hub 2-0:1.0: power on to power good time: 20ms
[    6.602727] hub 2-0:1.0: local power source is good
[    6.602731] hub 2-0:1.0: trying to enable port power on non-switchable hub
[    6.602838] drivers/usb/core/inode.c: creating file '001'
[    6.605346] hub 1-0:1.0: state 7 ports 4 chg 0000 evt 0000
[    6.647888] input: Dell WMI hotkeys as /devices/virtual/input/input6
[    6.652624] uhci_hcd: USB Universal Host Controller Interface driver
[    6.654171] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    6.654186] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    6.654193] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    6.654212] drivers/usb/core/inode.c: creating file '003'
[    6.654422] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    6.654434] uhci_hcd 0000:00:1a.0: detected 2 ports
[    6.654442] uhci_hcd 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x0000
[    6.654446] uhci_hcd 0000:00:1a.0: Performing full reset
[    6.654465] uhci_hcd 0000:00:1a.0: supports USB remote wakeup
[    6.654482] uhci_hcd 0000:00:1a.0: irq 16, io base 0x00001820
[    6.654665] usb usb3: default language 0x0409
[    6.654688] usb usb3: udev 1, busnum 3, minor = 256
[    6.654692] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    6.654696] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.654699] usb usb3: Product: UHCI Host Controller
[    6.654702] usb usb3: Manufacturer: Linux 2.6.36-rc2-RC uhci_hcd
[    6.654705] usb usb3: SerialNumber: 0000:00:1a.0
[    6.654935] usb usb3: usb_probe_device
[    6.654940] usb usb3: configuration #1 chosen from 1 choice
[    6.654961] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[    6.655065] hub 3-0:1.0: usb_probe_interface
[    6.655068] hub 3-0:1.0: usb_probe_interface - got id
[    6.655075] hub 3-0:1.0: USB hub found
[    6.655095] hub 3-0:1.0: 2 ports detected
[    6.655099] hub 3-0:1.0: standalone hub
[    6.655102] hub 3-0:1.0: no power switching (usb 1.0)
[    6.655105] hub 3-0:1.0: individual port over-current protection
[    6.655109] hub 3-0:1.0: power on to power good time: 2ms
[    6.655150] hub 3-0:1.0: local power source is good
[    6.655154] hub 3-0:1.0: trying to enable port power on non-switchable hub
[    6.655225] drivers/usb/core/inode.c: creating file '001'
[    6.655326] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.0
[    6.655415]   alloc irq_desc for 21 on node -1
[    6.655419]   alloc kstat_irqs on node -1
[    6.655430] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    6.655443] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    6.655448] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    6.655466] drivers/usb/core/inode.c: creating file '004'
[    6.655607] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    6.655618] uhci_hcd 0000:00:1a.1: detected 2 ports
[    6.655626] uhci_hcd 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x0000
[    6.655629] uhci_hcd 0000:00:1a.1: Performing full reset
[    6.655649] uhci_hcd 0000:00:1a.1: supports USB remote wakeup
[    6.655690] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00001840
[    6.655787] usb usb4: default language 0x0409
[    6.656718] usb usb4: udev 1, busnum 4, minor = 384
[    6.656722] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    6.656726] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.656729] usb usb4: Product: UHCI Host Controller
[    6.656732] usb usb4: Manufacturer: Linux 2.6.36-rc2-RC uhci_hcd
[    6.656736] usb usb4: SerialNumber: 0000:00:1a.1
[    6.656968] usb usb4: usb_probe_device
[    6.656972] usb usb4: configuration #1 chosen from 1 choice
[    6.656999] usb usb4: adding 4-0:1.0 (config #1, interface 0)
[    6.657100] hub 4-0:1.0: usb_probe_interface
[    6.657104] hub 4-0:1.0: usb_probe_interface - got id
[    6.657110] hub 4-0:1.0: USB hub found
[    6.657124] hub 4-0:1.0: 2 ports detected
[    6.657128] hub 4-0:1.0: standalone hub
[    6.657131] hub 4-0:1.0: no power switching (usb 1.0)
[    6.657134] hub 4-0:1.0: individual port over-current protection
[    6.657138] hub 4-0:1.0: power on to power good time: 2ms
[    6.657155] hub 4-0:1.0: local power source is good
[    6.657158] hub 4-0:1.0: trying to enable port power on non-switchable hub
[    6.657223] drivers/usb/core/inode.c: creating file '001'
[    6.657321] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.1
[    6.657412] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    6.657425] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    6.657430] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    6.657445] drivers/usb/core/inode.c: creating file '005'
[    6.657578] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
[    6.657591] uhci_hcd 0000:00:1d.0: detected 2 ports
[    6.657598] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
[    6.657602] uhci_hcd 0000:00:1d.0: Performing full reset
[    6.657621] uhci_hcd 0000:00:1d.0: supports USB remote wakeup
[    6.657637] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00001860
[    6.657717] usb usb5: default language 0x0409
[    6.657739] usb usb5: udev 1, busnum 5, minor = 512
[    6.657743] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    6.657747] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.657750] usb usb5: Product: UHCI Host Controller
[    6.657753] usb usb5: Manufacturer: Linux 2.6.36-rc2-RC uhci_hcd
[    6.657756] usb usb5: SerialNumber: 0000:00:1d.0
[    6.657967] usb usb5: usb_probe_device
[    6.657971] usb usb5: configuration #1 chosen from 1 choice
[    6.657989] usb usb5: adding 5-0:1.0 (config #1, interface 0)
[    6.658091] hub 5-0:1.0: usb_probe_interface
[    6.658095] hub 5-0:1.0: usb_probe_interface - got id
[    6.658101] hub 5-0:1.0: USB hub found
[    6.658115] hub 5-0:1.0: 2 ports detected
[    6.658118] hub 5-0:1.0: standalone hub
[    6.658121] hub 5-0:1.0: no power switching (usb 1.0)
[    6.658124] hub 5-0:1.0: individual port over-current protection
[    6.658128] hub 5-0:1.0: power on to power good time: 2ms
[    6.658145] hub 5-0:1.0: local power source is good
[    6.658148] hub 5-0:1.0: trying to enable port power on non-switchable hub
[    6.658212] drivers/usb/core/inode.c: creating file '001'
[    6.658335] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.0
[    6.658394] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    6.658407] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    6.658413] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    6.658427] drivers/usb/core/inode.c: creating file '006'
[    6.658591] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
[    6.658603] uhci_hcd 0000:00:1d.1: detected 2 ports
[    6.658610] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
[    6.658614] uhci_hcd 0000:00:1d.1: Performing full reset
[    6.658632] uhci_hcd 0000:00:1d.1: supports USB remote wakeup
[    6.658673] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00001880
[    6.658756] usb usb6: default language 0x0409
[    6.658778] usb usb6: udev 1, busnum 6, minor = 640
[    6.658781] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    6.658785] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.658789] usb usb6: Product: UHCI Host Controller
[    6.658792] usb usb6: Manufacturer: Linux 2.6.36-rc2-RC uhci_hcd
[    6.658795] usb usb6: SerialNumber: 0000:00:1d.1
[    6.659020] usb usb6: usb_probe_device
[    6.659025] usb usb6: configuration #1 chosen from 1 choice
[    6.659043] usb usb6: adding 6-0:1.0 (config #1, interface 0)
[    6.659127] hub 6-0:1.0: usb_probe_interface
[    6.659131] hub 6-0:1.0: usb_probe_interface - got id
[    6.659137] hub 6-0:1.0: USB hub found
[    6.659150] hub 6-0:1.0: 2 ports detected
[    6.659154] hub 6-0:1.0: standalone hub
[    6.659157] hub 6-0:1.0: no power switching (usb 1.0)
[    6.659160] hub 6-0:1.0: individual port over-current protection
[    6.659164] hub 6-0:1.0: power on to power good time: 2ms
[    6.659181] hub 6-0:1.0: local power source is good
[    6.659184] hub 6-0:1.0: trying to enable port power on non-switchable hub
[    6.659247] drivers/usb/core/inode.c: creating file '001'
[    6.659370] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.1
[    6.659429] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    6.659441] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    6.659447] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    6.659463] drivers/usb/core/inode.c: creating file '007'
[    6.659613] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
[    6.659625] uhci_hcd 0000:00:1d.2: detected 2 ports
[    6.659632] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
[    6.659635] uhci_hcd 0000:00:1d.2: Performing full reset
[    6.659654] uhci_hcd 0000:00:1d.2: supports USB remote wakeup
[    6.659668] uhci_hcd 0000:00:1d.2: irq 18, io base 0x000018a0
[    6.659750] usb usb7: default language 0x0409
[    6.659772] usb usb7: udev 1, busnum 7, minor = 768
[    6.659775] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    6.659779] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.659782] usb usb7: Product: UHCI Host Controller
[    6.659785] usb usb7: Manufacturer: Linux 2.6.36-rc2-RC uhci_hcd
[    6.659788] usb usb7: SerialNumber: 0000:00:1d.2
[    6.661284] usb usb7: usb_probe_device
[    6.661289] usb usb7: configuration #1 chosen from 1 choice
[    6.661313] usb usb7: adding 7-0:1.0 (config #1, interface 0)
[    6.661453] hub 7-0:1.0: usb_probe_interface
[    6.661456] hub 7-0:1.0: usb_probe_interface - got id
[    6.661464] hub 7-0:1.0: USB hub found
[    6.661478] hub 7-0:1.0: 2 ports detected
[    6.661481] hub 7-0:1.0: standalone hub
[    6.661484] hub 7-0:1.0: no power switching (usb 1.0)
[    6.661488] hub 7-0:1.0: individual port over-current protection
[    6.661492] hub 7-0:1.0: power on to power good time: 2ms
[    6.661509] hub 7-0:1.0: local power source is good
[    6.661513] hub 7-0:1.0: trying to enable port power on non-switchable hub
[    6.663979] drivers/usb/core/inode.c: creating file '001'
[    6.664184] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.2
[    6.702293] ehci_hcd 0000:00:1d.7: GetStatus port:2 status 001403 0  ACK POWER sig=k CSC CONNECT
[    6.702303] hub 2-0:1.0: port 2: status 0501 change 0001
[    6.707272] coretemp coretemp.0: TjMax is assumed as 100 C!
[    6.707694] coretemp coretemp.1: TjMax is assumed as 100 C!
[    6.733528]   alloc irq_desc for 22 on node -1
[    6.733532]   alloc kstat_irqs on node -1
[    6.733546] firewire_ohci 0000:08:05.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    6.755088] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    6.763373] uhci_hcd 0000:00:1d.0: port 2 portsc 008a,00
[    6.763482] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    6.763500] hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    6.763511] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    6.784393] firewire_ohci: Added fw-ohci device 0000:08:05.0, OHCI v1.10, 8 IR + 8 IT contexts, quirks 0x0
[    6.805061] hub 2-0:1.0: state 7 ports 6 chg 0004 evt 0000
[    6.805112] hub 2-0:1.0: port 2, status 0501, change 0000, 480 Mb/s
[    6.805272] ehci_hcd 0000:00:1d.7: port 2 low speed --> companion
[    6.825267] iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux, in-tree:s
[    6.825272] iwl3945: Copyright(c) 2003-2010 Intel Corporation
[    6.825435] iwl3945 0000:06:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    6.825453] iwl3945 0000:06:00.0: setting latency timer to 64
[    6.856072] ehci_hcd 0000:00:1d.7: GetStatus port:2 status 003002 0  ACK POWER OWNER sig=se0 CSC
[    6.856201] hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0004
[    6.863063] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    6.864651] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0004
[    6.864676] uhci_hcd 0000:00:1d.0: port 2 portsc 01a3,00
[    6.864695] hub 5-0:1.0: port 2, status 0301, change 0001, 1.5 Mb/s
[    6.882619] iwl3945 0000:06:00.0: Tunable channels: 13 802.11bg, 23 802.11a channels
[    6.882625] iwl3945 0000:06:00.0: Detected Intel Wireless WiFi Link 3945ABG
[    6.894113] phy0: Selected rate control algorithm 'iwl-3945-rs'
[    6.894747] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    6.894804] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    6.968078] hub 5-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x301
[    7.015856] hda_codec: ALC268: BIOS auto-probing.
[    7.070068] usb 5-2: new low speed USB device using uhci_hcd and address 2
[    7.152609] fuse init (API version 7.15)
[    7.218764] usb 5-2: skipped 1 descriptor after interface
[    7.218772] usb 5-2: skipped 1 descriptor after interface
[    7.225720] usb 5-2: default language 0x0409
[    7.243741] usb 5-2: udev 2, busnum 5, minor = 513
[    7.243748] usb 5-2: New USB device found, idVendor=046d, idProduct=c512
[    7.243754] usb 5-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    7.243760] usb 5-2: Product: 2.4GHz Cordless Desktop
[    7.243764] usb 5-2: Manufacturer: Logitech
[    7.244266] usb 5-2: usb_probe_device
[    7.244272] usb 5-2: configuration #1 chosen from 1 choice
[    7.246785] usb 5-2: adding 5-2:1.0 (config #1, interface 0)
[    7.246935] usbhid 5-2:1.0: usb_probe_interface
[    7.246940] usbhid 5-2:1.0: usb_probe_interface - got id
[    7.261419] input: Logitech 2.4GHz Cordless Desktop as /devices/pci0000:00/0000:00:1d.0/usb5/5-2/5-2:1.0/input/input7
[    7.261591] uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 8, phase 4, 118 us
[    7.262723] logitech 0003:046D:C512.0001: input,hidraw0: USB HID v1.11 Keyboard [Logitech 2.4GHz Cordless Desktop] on usb-0000:00:1d.0-2/input0
[    7.262794] usb 5-2: adding 5-2:1.1 (config #1, interface 1)
[    7.262883] usbhid 5-2:1.1: usb_probe_interface
[    7.262887] usbhid 5-2:1.1: usb_probe_interface - got id
[    7.286915] firewire_core: created device fw0: GUID 0000c010a000b000, S400
[    7.293575] input: Logitech 2.4GHz Cordless Desktop as /devices/pci0000:00/0000:00:1d.0/usb5/5-2/5-2:1.1/input/input8
[    7.293603] uhci_hcd 0000:00:1d.0: reserve dev 2 ep82-INT, period 8, phase 4, 118 us
[    7.293892] drivers/usb/core/file.c: looking for a minor, starting at 0
[    7.294733] logitech 0003:046D:C512.0002: input,hiddev0,hidraw1: USB HID v1.11 Mouse [Logitech 2.4GHz Cordless Desktop] on usb-0000:00:1d.0-2/input1
[    7.294806] drivers/usb/core/inode.c: creating file '002'
[    7.304649] input: PS/2 Mouse as /devices/platform/i8042/serio1/input/input9
[    7.343526] input: AlpsPS/2 ALPS GlidePoint as /devices/platform/i8042/serio1/input/input10
[    7.704066] usb usb7: suspend_rh (auto-stop)
[    7.705044] usb usb3: suspend_rh (auto-stop)
[    7.705078] usb usb4: suspend_rh (auto-stop)
[    7.705111] usb usb6: suspend_rh (auto-stop)
[    7.912558] EXT4-fs (sda1): re-mounted. Opts: (null)
[    8.100434] EXT4-fs (sda1): re-mounted. Opts: (null)
[    8.175932] findmnt used greatest stack depth: 4000 bytes left
[    8.284496] EXT4-fs (sda3): mounted filesystem with ordered data mode. Opts: (null)
[    8.353228] Adding 4000180k swap on /dev/sda4.  Priority:-1 extents:1 across:4000180k 
[    8.712261] hub 1-0:1.0: hub_suspend
[    8.712376] usb usb1: bus auto-suspend
[    8.712380] ehci_hcd 0000:00:1a.7: suspend root hub
[    8.821484] find used greatest stack depth: 3840 bytes left
[    9.712144] hub 3-0:1.0: hub_suspend
[    9.712164] usb usb3: bus auto-suspend
[    9.712195] usb usb3: suspend_rh
[    9.712227] hub 4-0:1.0: hub_suspend
[    9.712244] usb usb4: bus auto-suspend
[    9.712248] usb usb4: suspend_rh
[    9.712272] hub 6-0:1.0: hub_suspend
[    9.712280] usb usb6: bus auto-suspend
[    9.712283] usb usb6: suspend_rh
[    9.712307] hub 7-0:1.0: hub_suspend
[    9.712315] usb usb7: bus auto-suspend
[    9.712318] usb usb7: suspend_rh
[    9.712342] hub 2-0:1.0: hub_suspend
[    9.712350] usb usb2: bus auto-suspend
[    9.712354] ehci_hcd 0000:00:1d.7: suspend root hub
[   11.071706] [drm:i915_driver_irq_handler], pipe a underrun
[   11.071835] r8169 0000:07:00.0: eth0: link up
[   11.071856] r8169 0000:07:00.0: eth0: link up
[   25.783637] [drm:drm_crtc_helper_set_config], 
[   25.783640] [drm:drm_crtc_helper_set_config], [CRTC:3] [FB:47] #connectors=1 (x y) (0 0)
[   25.783666] [drm:drm_crtc_helper_set_config], [CONNECTOR:12:VGA-1] to [CRTC:3]
[   25.792370] [drm:i915_driver_open], 
[   25.792618] [drm:drm_crtc_helper_set_config], 
[   25.792624] [drm:drm_crtc_helper_set_config], [CRTC:3] [FB:47] #connectors=1 (x y) (0 0)
[   25.792655] [drm:drm_crtc_helper_set_config], [CONNECTOR:12:VGA-1] to [CRTC:3]
[   25.792663] [drm:drm_crtc_helper_set_config], 
[   25.792668] [drm:drm_crtc_helper_set_config], [CRTC:4] [FB:47] #connectors=0 (x y) (0 0)
[   25.792678] [drm:drm_crtc_helper_set_config], crtc has no fb, full mode set
[   25.792685] [drm:drm_crtc_helper_set_config], [CONNECTOR:12:VGA-1] to [CRTC:3]
[   25.792722] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 1
[   25.802882] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   25.802888] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[   25.802893] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[   25.802983] [drm:i915_driver_open], 
[   25.803464] [drm:drm_mode_getresources], CRTC[2] CONNECTORS[3] ENCODERS[3]
[   25.803495] [drm:drm_mode_getresources], CRTC[2] CONNECTORS[3] ENCODERS[3]
[   25.803719] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   25.803727] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[   25.803731] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] disconnected
[   25.803739] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   25.803745] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[   25.803749] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] disconnected
[   25.807176] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[   25.807184] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
[   25.928130] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] probed modes :
[   25.928136] [drm:drm_mode_debug_printmodeline], Modeline 29:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[   25.928143] [drm:drm_mode_debug_printmodeline], Modeline 39:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[   25.928150] [drm:drm_mode_debug_printmodeline], Modeline 30:"1280x960" 60 108000 1280 1376 1488 1800 960 961 964 1000 0x40 0x5
[   25.928157] [drm:drm_mode_debug_printmodeline], Modeline 46:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[   25.928164] [drm:drm_mode_debug_printmodeline], Modeline 40:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[   25.928170] [drm:drm_mode_debug_printmodeline], Modeline 41:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[   25.928177] [drm:drm_mode_debug_printmodeline], Modeline 42:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[   25.928183] [drm:drm_mode_debug_printmodeline], Modeline 43:"832x624" 75 57284 832 864 928 1152 624 625 628 667 0x40 0xa
[   25.928190] [drm:drm_mode_debug_printmodeline], Modeline 45:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[   25.928196] [drm:drm_mode_debug_printmodeline], Modeline 44:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[   25.928202] [drm:drm_mode_debug_printmodeline], Modeline 32:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[   25.928209] [drm:drm_mode_debug_printmodeline], Modeline 33:"800x600" 56 36000 800 824 896 1024 600 601 603 625 0x40 0x5
[   25.928215] [drm:drm_mode_debug_printmodeline], Modeline 35:"640x480" 73 31500 640 664 704 832 480 489 491 520 0x40 0xa
[   25.928222] [drm:drm_mode_debug_printmodeline], Modeline 34:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[   25.928228] [drm:drm_mode_debug_printmodeline], Modeline 36:"640x480" 67 30240 640 704 768 864 480 483 486 525 0x40 0xa
[   25.928235] [drm:drm_mode_debug_printmodeline], Modeline 37:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[   25.928241] [drm:drm_mode_debug_printmodeline], Modeline 38:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[   25.928270] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[   25.928423] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[   25.928430] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1]
[   25.928441] [drm:drm_crtc_helper_set_mode], [CRTC:4]
[   25.928459] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 1
[   25.938616] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   25.938622] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[   25.938627] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[   25.938873] [drm:intel_crtc_mode_set], Mode for pipe B:
[   25.938877] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[   25.939338] [drm:intel_pipe_set_base], No FB bound
[   25.939342] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   25.939347] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[   25.939352] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[   25.939358] [drm:drm_crtc_helper_set_mode], [ENCODER:15:TV-15] set [MODE:0:NTSC 480i]
[   25.990011] [drm:intel_wait_for_vblank], vblank wait timed out
[   25.990032] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   25.990037] [drm:intel_update_watermarks], plane B (pipe 1) clock: 107520
[   25.990041] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   25.990071] [drm:intel_update_fbc], 
[   26.041011] [drm:intel_wait_for_vblank], vblank wait timed out
[   26.092011] [drm:intel_wait_for_vblank], vblank wait timed out
[   26.143011] [drm:intel_wait_for_vblank], vblank wait timed out
[   26.143015] [drm:intel_tv_detect_type], No TV connection detected
[   26.153272] [drm:i915_driver_irq_handler], pipe b underrun
[   26.169932] [drm:i915_driver_irq_handler], pipe b underrun
[   26.186594] [drm:i915_driver_irq_handler], pipe b underrun
[   26.203255] [drm:i915_driver_irq_handler], pipe b underrun
[   26.219916] [drm:i915_driver_irq_handler], pipe b underrun
[   26.236578] [drm:i915_driver_irq_handler], pipe b underrun
[   26.253190] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   26.253195] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[   26.253200] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[   26.253205] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1] disconnected
[   26.253213] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[   26.253219] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1]
[   26.253228] [drm:drm_crtc_helper_set_mode], [CRTC:4]
[   26.253235] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 1
[   26.253242] [drm:i915_driver_irq_handler], pipe b underrun
[   26.263414] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   26.263419] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[   26.263424] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[   26.263668] [drm:intel_crtc_mode_set], Mode for pipe B:
[   26.263672] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[   26.264132] [drm:intel_pipe_set_base], No FB bound
[   26.264137] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   26.264142] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[   26.264148] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[   26.264155] [drm:drm_crtc_helper_set_mode], [ENCODER:15:TV-15] set [MODE:0:NTSC 480i]
[   26.269900] [drm:i915_driver_irq_handler], pipe b underrun
[   26.269933] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   26.269938] [drm:intel_update_watermarks], plane B (pipe 1) clock: 107520
[   26.269942] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   26.269972] [drm:intel_update_fbc], 
[   26.269980] [drm:intel_tv_detect_type], Detected S-Video TV connection
[   26.286562] [drm:i915_driver_irq_handler], pipe b underrun
[   26.303223] [drm:i915_driver_irq_handler], pipe b underrun
[   26.319884] [drm:i915_driver_irq_handler], pipe b underrun
[   26.336546] [drm:i915_driver_irq_handler], pipe b underrun
[   26.353207] [drm:i915_driver_irq_handler], pipe b underrun
[   26.369868] [drm:i915_driver_irq_handler], pipe b underrun
[   26.370016] [drm:intel_wait_for_vblank_off], vblank wait timed out
[   26.386530] [drm:i915_driver_irq_handler], pipe b underrun
[   26.395176] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   26.395181] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[   26.395185] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[   26.395207] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1] probed modes :
[   26.395212] [drm:drm_mode_debug_printmodeline], Modeline 51:"848x480" 30 14513 848 849 912 944 480 481 512 513 0x48 0x0
[   26.395218] [drm:drm_mode_debug_printmodeline], Modeline 48:"640x480" 30 11315 640 641 704 736 480 481 512 513 0x48 0x0
[   26.395225] [drm:drm_mode_debug_printmodeline], Modeline 50:"1024x768" 30 26886 1024 1025 1088 1120 768 769 800 801 0x40 0x0
[   26.395231] [drm:drm_mode_debug_printmodeline], Modeline 49:"800x600" 30 16998 800 801 864 896 600 601 632 633 0x40 0x0
[   26.395246] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[   26.395252] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1]
[   26.395260] [drm:drm_crtc_helper_set_mode], [CRTC:4]
[   26.395267] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 1
[   26.403191] [drm:i915_driver_irq_handler], pipe b underrun
[   26.405424] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   26.405429] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[   26.405433] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[   26.405677] [drm:intel_crtc_mode_set], Mode for pipe B:
[   26.405682] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[   26.406142] [drm:intel_pipe_set_base], No FB bound
[   26.406146] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   26.406151] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[   26.406157] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[   26.406164] [drm:drm_crtc_helper_set_mode], [ENCODER:15:TV-15] set [MODE:0:NTSC 480i]
[   26.419853] [drm:i915_driver_irq_handler], pipe b underrun
[   26.419886] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   26.419891] [drm:intel_update_watermarks], plane B (pipe 1) clock: 107520
[   26.419895] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   26.419925] [drm:intel_update_fbc], 
[   26.419933] [drm:intel_tv_detect_type], Detected Composite TV connection
[   26.436514] [drm:i915_driver_irq_handler], pipe b underrun
[   26.453175] [drm:i915_driver_irq_handler], pipe b underrun
[   26.469837] [drm:i915_driver_irq_handler], pipe b underrun
[   26.486499] [drm:i915_driver_irq_handler], pipe b underrun
[   26.503160] [drm:i915_driver_irq_handler], pipe b underrun
[   26.503170] [drm:i915_driver_irq_handler], pipe b underrun
[   26.519821] [drm:i915_driver_irq_handler], pipe b underrun
[   26.535109] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   26.535114] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[   26.535119] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[   26.535145] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1] probed modes :
[   26.535150] [drm:drm_mode_debug_printmodeline], Modeline 51:"848x480" 30 14513 848 849 912 944 480 481 512 513 0x48 0x0
[   26.535157] [drm:drm_mode_debug_printmodeline], Modeline 48:"640x480" 30 11315 640 641 704 736 480 481 512 513 0x48 0x0
[   26.535163] [drm:drm_mode_debug_printmodeline], Modeline 50:"1024x768" 30 26886 1024 1025 1088 1120 768 769 800 801 0x40 0x0
[   26.535170] [drm:drm_mode_debug_printmodeline], Modeline 49:"800x600" 30 16998 800 801 864 896 600 601 632 633 0x40 0x0
[   26.535181] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[   26.535279] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   26.535285] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[   26.535290] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] disconnected
[   26.535297] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   26.535302] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[   26.535307] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] disconnected
[   26.535371] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[   26.535377] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
[   26.536484] [drm:i915_driver_irq_handler], pipe b underrun
[   26.643631] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] probed modes :
[   26.643637] [drm:drm_mode_debug_printmodeline], Modeline 29:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[   26.643644] [drm:drm_mode_debug_printmodeline], Modeline 39:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[   26.643651] [drm:drm_mode_debug_printmodeline], Modeline 30:"1280x960" 60 108000 1280 1376 1488 1800 960 961 964 1000 0x40 0x5
[   26.643658] [drm:drm_mode_debug_printmodeline], Modeline 46:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[   26.643665] [drm:drm_mode_debug_printmodeline], Modeline 40:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[   26.643671] [drm:drm_mode_debug_printmodeline], Modeline 41:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[   26.643678] [drm:drm_mode_debug_printmodeline], Modeline 42:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[   26.643684] [drm:drm_mode_debug_printmodeline], Modeline 43:"832x624" 75 57284 832 864 928 1152 624 625 628 667 0x40 0xa
[   26.643691] [drm:drm_mode_debug_printmodeline], Modeline 45:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[   26.643697] [drm:drm_mode_debug_printmodeline], Modeline 44:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[   26.643704] [drm:drm_mode_debug_printmodeline], Modeline 32:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[   26.643710] [drm:drm_mode_debug_printmodeline], Modeline 33:"800x600" 56 36000 800 824 896 1024 600 601 603 625 0x40 0x5
[   26.643717] [drm:drm_mode_debug_printmodeline], Modeline 35:"640x480" 73 31500 640 664 704 832 480 489 491 520 0x40 0xa
[   26.643723] [drm:drm_mode_debug_printmodeline], Modeline 34:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[   26.643730] [drm:drm_mode_debug_printmodeline], Modeline 36:"640x480" 67 30240 640 704 768 864 480 483 486 525 0x40 0xa
[   26.643736] [drm:drm_mode_debug_printmodeline], Modeline 37:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[   26.643742] [drm:drm_mode_debug_printmodeline], Modeline 38:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[   26.643755] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[   26.646505] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[   26.646513] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1]
[   26.646522] [drm:drm_crtc_helper_set_mode], [CRTC:4]
[   26.646531] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 1
[   26.656688] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   26.656694] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[   26.656698] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[   26.656943] [drm:intel_crtc_mode_set], Mode for pipe B:
[   26.656947] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[   26.657408] [drm:intel_pipe_set_base], No FB bound
[   26.657412] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   26.657417] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[   26.657422] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[   26.657428] [drm:drm_crtc_helper_set_mode], [ENCODER:15:TV-15] set [MODE:0:NTSC 480i]
[   26.669948] [drm:i915_driver_irq_handler], pipe b underrun
[   26.669985] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   26.669990] [drm:intel_update_watermarks], plane B (pipe 1) clock: 107520
[   26.669995] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   26.670045] [drm:intel_update_fbc], 
[   26.670054] [drm:intel_tv_detect_type], Detected S-Video TV connection
[   26.686451] [drm:i915_driver_irq_handler], pipe b underrun
[   26.686462] [drm:i915_driver_irq_handler], pipe b underrun
[   26.703113] [drm:i915_driver_irq_handler], pipe b underrun
[   26.719774] [drm:i915_driver_irq_handler], pipe b underrun
[   26.719784] [drm:i915_driver_irq_handler], pipe b underrun
[   26.736435] [drm:i915_driver_irq_handler], pipe b underrun
[   26.753097] [drm:i915_driver_irq_handler], pipe b underrun
[   26.753107] [drm:i915_driver_irq_handler], pipe b underrun
[   26.769758] [drm:i915_driver_irq_handler], pipe b underrun
[   26.785228] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   26.785233] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[   26.785238] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[   26.785264] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1] probed modes :
[   26.785269] [drm:drm_mode_debug_printmodeline], Modeline 51:"848x480" 30 14513 848 849 912 944 480 481 512 513 0x48 0x0
[   26.785276] [drm:drm_mode_debug_printmodeline], Modeline 48:"640x480" 30 11315 640 641 704 736 480 481 512 513 0x48 0x0
[   26.785282] [drm:drm_mode_debug_printmodeline], Modeline 50:"1024x768" 30 26886 1024 1025 1088 1120 768 769 800 801 0x40 0x0
[   26.785289] [drm:drm_mode_debug_printmodeline], Modeline 49:"800x600" 30 16998 800 801 864 896 600 601 632 633 0x40 0x0
[   26.785300] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[   26.786405] [drm:i915_driver_irq_handler], pipe b underrun
[   26.882843] [drm:drm_mode_addfb], [FB:52]
[   26.882933] [drm:drm_mode_setcrtc], [CRTC:3]
[   26.882943] [drm:drm_mode_setcrtc], [CONNECTOR:12:VGA-1]
[   26.882947] [drm:drm_crtc_helper_set_config], 
[   26.882951] [drm:drm_crtc_helper_set_config], [CRTC:3] [FB:52] #connectors=1 (x y) (0 0)
[   26.882963] [drm:drm_crtc_helper_set_config], modes are different, full mode set
[   26.882967] [drm:drm_mode_debug_printmodeline], Modeline 31:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[   26.882974] [drm:drm_mode_debug_printmodeline], Modeline 53:"1024x768" 0 65000 1024 1048 1184 1344 768 771 777 806 0x0 0xa
[   26.882983] [drm:drm_crtc_helper_set_config], [CONNECTOR:12:VGA-1] to [CRTC:3]
[   26.882987] [drm:drm_crtc_helper_set_config], attempting to set mode from userspace
[   26.882992] [drm:drm_mode_debug_printmodeline], Modeline 53:"1024x768" 0 65000 1024 1048 1184 1344 768 771 777 806 0x0 0xa
[   26.883001] [drm:drm_crtc_helper_set_mode], [CRTC:3]
[   26.993483] [drm:intel_crtc_mode_set], Mode for pipe A:
[   26.993488] [drm:drm_mode_debug_printmodeline], Modeline 53:"1024x768" 0 65000 1024 1048 1184 1344 768 771 777 806 0x0 0xa
[   27.044027] [drm:intel_wait_for_vblank], vblank wait timed out
[   27.048755] [drm:intel_pipe_set_base], Writing base 00D00000 00000000 0 0 4096
[   27.048762] [drm:intel_update_fbc], 
[   27.048766] [drm:intel_update_fbc], 1 pipes active
[   27.048782] [drm:i8xx_enable_fbc], enabled FBC, pitch 63, yoff 0, plane 0, 
[   27.099011] [drm:intel_wait_for_vblank], vblank wait timed out
[   27.099021] [drm:drm_crtc_helper_set_mode], [ENCODER:13:DAC-13] set [MODE:53:1024x768]
[   27.099026] [drm:intel_update_watermarks], plane A (pipe 0) clock: 65000
[   27.099031] [drm:i965_update_wm], self-refresh watermark: display plane 448 cursor 32
[   27.099036] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 448
[   27.099066] [drm:intel_update_fbc], 
[   27.099069] [drm:intel_update_fbc], 1 pipes active
[   27.099074] [drm:i8xx_disable_fbc], disabled FBC
[   27.099088] [drm:i8xx_enable_fbc], enabled FBC, pitch 63, yoff 0, plane 0, 
[   27.099105] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 1
[   27.109262] [drm:intel_update_watermarks], plane A (pipe 0) clock: 65000
[   27.109267] [drm:i965_update_wm], self-refresh watermark: display plane 448 cursor 32
[   27.109272] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 448
[   27.109344] [drm:drm_mode_setcrtc], [CRTC:4]
[   27.109355] [drm:drm_mode_setcrtc], [CONNECTOR:14:SVIDEO-1]
[   27.109359] [drm:drm_crtc_helper_set_config], 
[   27.109363] [drm:drm_crtc_helper_set_config], [CRTC:4] [FB:52] #connectors=1 (x y) (0 0)
[   27.109371] [drm:drm_crtc_helper_set_config], crtc has no fb, full mode set
[   27.109375] [drm:drm_crtc_helper_set_config], modes are different, full mode set
[   27.109379] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[   27.109386] [drm:drm_mode_debug_printmodeline], Modeline 54:"1024x768" 0 26886 1024 1025 1088 1120 768 769 800 801 0x0 0x0
[   27.109395] [drm:drm_crtc_helper_set_config], encoder changed, full mode switch
[   27.109399] [drm:drm_crtc_helper_set_config], [CONNECTOR:12:VGA-1] to [CRTC:3]
[   27.109404] [drm:drm_crtc_helper_set_config], crtc changed, full mode switch
[   27.109408] [drm:drm_crtc_helper_set_config], [CONNECTOR:14:SVIDEO-1] to [CRTC:4]
[   27.109413] [drm:drm_crtc_helper_set_config], attempting to set mode from userspace
[   27.109417] [drm:drm_mode_debug_printmodeline], Modeline 54:"1024x768" 0 26886 1024 1025 1088 1120 768 769 800 801 0x0 0x0
[   27.109426] [drm:drm_crtc_helper_set_mode], [CRTC:4]
[   27.109434] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 1
[   27.119590] [drm:intel_update_watermarks], plane A (pipe 0) clock: 65000
[   27.119595] [drm:i965_update_wm], self-refresh watermark: display plane 448 cursor 32
[   27.119600] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 448
[   27.119845] [drm:intel_crtc_mode_set], Mode for pipe B:
[   27.119849] [drm:drm_mode_debug_printmodeline], Modeline 54:"1024x768" 0 26886 1024 1025 1088 1120 768 769 800 801 0x0 0x0
[   27.120321] [drm:intel_pipe_set_base], Writing base 00D00000 00000000 0 0 4096
[   27.120327] [drm:intel_update_fbc], 
[   27.120330] [drm:intel_update_fbc], 2 pipes active
[   27.120334] [drm:intel_update_fbc], more than one pipe active, disabling compression
[   27.120338] [drm:intel_update_fbc], unsupported config, disabling FBC
[   27.120343] [drm:i8xx_disable_fbc], disabled FBC
[   27.171011] [drm:intel_wait_for_vblank], vblank wait timed out
[   27.171016] [drm:intel_update_watermarks], plane A (pipe 0) clock: 65000
[   27.171021] [drm:i965_update_wm], self-refresh watermark: display plane 448 cursor 32
[   27.171025] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 448
[   27.171031] [drm:drm_crtc_helper_set_mode], [ENCODER:15:TV-15] set [MODE:54:1024x768]
[   27.222011] [drm:intel_wait_for_vblank], vblank wait timed out
[   27.222033] [drm:intel_update_watermarks], plane A (pipe 0) clock: 65000
[   27.222037] [drm:intel_update_watermarks], plane B (pipe 1) clock: 26886
[   27.222041] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   27.222071] [drm:intel_update_fbc], 
[   27.222074] [drm:intel_update_fbc], 2 pipes active
[   27.222078] [drm:intel_update_fbc], more than one pipe active, disabling compression
[   27.371170] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[   27.816103] [drm:intel_crtc_cursor_set], 
[   27.816137] [drm:intel_crtc_cursor_set], 
[   28.317149] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[   29.388036] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[   29.888191] [drm:intel_crtc_idle_timer], idle timer fired, downclocking
[   29.888282] [drm:intel_crtc_idle_timer], idle timer fired, downclocking
[   32.096640] EXT4-fs (sda1): re-mounted. Opts: commit=0
[   32.118141] EXT4-fs (sda3): re-mounted. Opts: commit=0
[   32.558156] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   32.558167] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[   32.558172] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] disconnected
[   32.558180] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   32.558186] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[   32.558190] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] disconnected
[   32.558213] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[   32.558220] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
[   32.670094] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] probed modes :
[   32.670100] [drm:drm_mode_debug_printmodeline], Modeline 29:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[   32.670108] [drm:drm_mode_debug_printmodeline], Modeline 39:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[   32.670115] [drm:drm_mode_debug_printmodeline], Modeline 30:"1280x960" 60 108000 1280 1376 1488 1800 960 961 964 1000 0x40 0x5
[   32.670121] [drm:drm_mode_debug_printmodeline], Modeline 46:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[   32.670128] [drm:drm_mode_debug_printmodeline], Modeline 40:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[   32.670134] [drm:drm_mode_debug_printmodeline], Modeline 41:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[   32.670141] [drm:drm_mode_debug_printmodeline], Modeline 42:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[   32.670147] [drm:drm_mode_debug_printmodeline], Modeline 43:"832x624" 75 57284 832 864 928 1152 624 625 628 667 0x40 0xa
[   32.670154] [drm:drm_mode_debug_printmodeline], Modeline 45:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[   32.670160] [drm:drm_mode_debug_printmodeline], Modeline 44:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[   32.670167] [drm:drm_mode_debug_printmodeline], Modeline 32:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[   32.670173] [drm:drm_mode_debug_printmodeline], Modeline 33:"800x600" 56 36000 800 824 896 1024 600 601 603 625 0x40 0x5
[   32.670180] [drm:drm_mode_debug_printmodeline], Modeline 35:"640x480" 73 31500 640 664 704 832 480 489 491 520 0x40 0xa
[   32.670186] [drm:drm_mode_debug_printmodeline], Modeline 34:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[   32.670192] [drm:drm_mode_debug_printmodeline], Modeline 36:"640x480" 67 30240 640 704 768 864 480 483 486 525 0x40 0xa
[   32.670199] [drm:drm_mode_debug_printmodeline], Modeline 37:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[   32.670205] [drm:drm_mode_debug_printmodeline], Modeline 38:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[   32.670238] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[   32.670321] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[   32.670328] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1]
[   32.721012] [drm:intel_wait_for_vblank], vblank wait timed out
[   32.772014] [drm:intel_wait_for_vblank], vblank wait timed out
[   32.772020] [drm:intel_tv_detect_type], No TV connection detected
[   32.772027] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1] disconnected
[   32.772033] [drm:drm_mode_debug_printmodeline], Modeline 51:"848x480" 30 14513 848 849 912 944 480 481 512 513 0x48 0x0
[   32.772040] [drm:drm_mode_prune_invalid], Not using 848x480 mode -3
[   32.772047] [drm:drm_mode_debug_printmodeline], Modeline 48:"640x480" 30 11315 640 641 704 736 480 481 512 513 0x48 0x0
[   32.772054] [drm:drm_mode_prune_invalid], Not using 640x480 mode -3
[   32.772059] [drm:drm_mode_debug_printmodeline], Modeline 50:"1024x768" 30 26886 1024 1025 1088 1120 768 769 800 801 0x40 0x0
[   32.772066] [drm:drm_mode_prune_invalid], Not using 1024x768 mode -3
[   32.772071] [drm:drm_mode_debug_printmodeline], Modeline 49:"800x600" 30 16998 800 801 864 896 600 601 632 633 0x40 0x0
[   32.772077] [drm:drm_mode_prune_invalid], Not using 800x600 mode -3
[   32.772105] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[   32.772112] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1]
[   32.823012] [drm:intel_wait_for_vblank], vblank wait timed out
[   32.874033] [drm:intel_wait_for_vblank], vblank wait timed out
[   32.874039] [drm:intel_tv_detect_type], No TV connection detected
[   32.874046] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1] disconnected
[   32.878425] [drm:i915_driver_irq_handler], pipe b underrun
[   32.878486] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   32.878495] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[   32.878500] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] disconnected
[   32.878509] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   32.878515] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[   32.878519] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] disconnected
[   32.878537] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[   32.878544] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
[   32.987384] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] probed modes :
[   32.987391] [drm:drm_mode_debug_printmodeline], Modeline 29:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[   32.987398] [drm:drm_mode_debug_printmodeline], Modeline 39:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[   32.987405] [drm:drm_mode_debug_printmodeline], Modeline 30:"1280x960" 60 108000 1280 1376 1488 1800 960 961 964 1000 0x40 0x5
[   32.987412] [drm:drm_mode_debug_printmodeline], Modeline 46:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[   32.987418] [drm:drm_mode_debug_printmodeline], Modeline 40:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[   32.987425] [drm:drm_mode_debug_printmodeline], Modeline 41:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[   32.987431] [drm:drm_mode_debug_printmodeline], Modeline 42:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[   32.987438] [drm:drm_mode_debug_printmodeline], Modeline 43:"832x624" 75 57284 832 864 928 1152 624 625 628 667 0x40 0xa
[   32.987444] [drm:drm_mode_debug_printmodeline], Modeline 45:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[   32.987451] [drm:drm_mode_debug_printmodeline], Modeline 44:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[   32.987457] [drm:drm_mode_debug_printmodeline], Modeline 32:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[   32.987464] [drm:drm_mode_debug_printmodeline], Modeline 33:"800x600" 56 36000 800 824 896 1024 600 601 603 625 0x40 0x5
[   32.987470] [drm:drm_mode_debug_printmodeline], Modeline 35:"640x480" 73 31500 640 664 704 832 480 489 491 520 0x40 0xa
[   32.987476] [drm:drm_mode_debug_printmodeline], Modeline 34:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[   32.987483] [drm:drm_mode_debug_printmodeline], Modeline 36:"640x480" 67 30240 640 704 768 864 480 483 486 525 0x40 0xa
[   32.987489] [drm:drm_mode_debug_printmodeline], Modeline 37:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[   32.987495] [drm:drm_mode_debug_printmodeline], Modeline 38:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[   32.987526] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[   32.988589] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[   32.988597] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1]
[   33.039011] [drm:intel_wait_for_vblank], vblank wait timed out
[   33.090011] [drm:intel_wait_for_vblank], vblank wait timed out
[   33.090015] [drm:intel_tv_detect_type], No TV connection detected
[   33.090020] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1] disconnected
[   33.090036] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[   33.090043] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1]
[   33.141011] [drm:intel_wait_for_vblank], vblank wait timed out
[   33.192011] [drm:intel_wait_for_vblank], vblank wait timed out
[   33.192015] [drm:intel_tv_detect_type], No TV connection detected
[   33.192020] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1] disconnected
[   33.262364] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   33.262375] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[   33.262380] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] disconnected
[   33.262389] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   33.262394] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[   33.262399] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] disconnected
[   33.262417] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[   33.262424] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
[   33.370582] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] probed modes :
[   33.370588] [drm:drm_mode_debug_printmodeline], Modeline 29:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[   33.370595] [drm:drm_mode_debug_printmodeline], Modeline 39:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[   33.370602] [drm:drm_mode_debug_printmodeline], Modeline 30:"1280x960" 60 108000 1280 1376 1488 1800 960 961 964 1000 0x40 0x5
[   33.370608] [drm:drm_mode_debug_printmodeline], Modeline 46:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[   33.370615] [drm:drm_mode_debug_printmodeline], Modeline 40:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[   33.370622] [drm:drm_mode_debug_printmodeline], Modeline 41:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[   33.370628] [drm:drm_mode_debug_printmodeline], Modeline 42:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[   33.370635] [drm:drm_mode_debug_printmodeline], Modeline 43:"832x624" 75 57284 832 864 928 1152 624 625 628 667 0x40 0xa
[   33.370641] [drm:drm_mode_debug_printmodeline], Modeline 45:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[   33.370648] [drm:drm_mode_debug_printmodeline], Modeline 44:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[   33.370654] [drm:drm_mode_debug_printmodeline], Modeline 32:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[   33.370661] [drm:drm_mode_debug_printmodeline], Modeline 33:"800x600" 56 36000 800 824 896 1024 600 601 603 625 0x40 0x5
[   33.370667] [drm:drm_mode_debug_printmodeline], Modeline 35:"640x480" 73 31500 640 664 704 832 480 489 491 520 0x40 0xa
[   33.370674] [drm:drm_mode_debug_printmodeline], Modeline 34:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[   33.370680] [drm:drm_mode_debug_printmodeline], Modeline 36:"640x480" 67 30240 640 704 768 864 480 483 486 525 0x40 0xa
[   33.370686] [drm:drm_mode_debug_printmodeline], Modeline 37:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[   33.370693] [drm:drm_mode_debug_printmodeline], Modeline 38:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[   33.370717] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[   33.371687] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[   33.371696] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1]
[   33.422011] [drm:intel_wait_for_vblank], vblank wait timed out
[   33.473012] [drm:intel_wait_for_vblank], vblank wait timed out
[   33.473017] [drm:intel_tv_detect_type], No TV connection detected
[   33.473024] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1] disconnected
[   33.473049] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[   33.473056] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1]
[   33.524026] [drm:intel_wait_for_vblank], vblank wait timed out
[   33.575012] [drm:intel_wait_for_vblank], vblank wait timed out
[   33.575016] [drm:intel_tv_detect_type], No TV connection detected
[   33.575021] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1] disconnected
[   34.182845] [drm:intel_update_watermarks], plane A (pipe 0) clock: 65000
[   34.182852] [drm:i965_update_wm], self-refresh watermark: display plane 448 cursor 32
[   34.182857] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 448
[   34.183565] [drm:intel_crtc_cursor_set], 
[   34.183570] [drm:intel_crtc_cursor_set], cursor off
[   34.183862] [drm:intel_crtc_cursor_set], 
[   41.705102] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[   42.206073] [drm:intel_crtc_idle_timer], idle timer fired, downclocking
[   42.206088] [drm:intel_crtc_idle_timer], idle timer fired, downclocking
[   42.441081] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[   42.685903] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   42.685913] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[   42.685918] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] disconnected
[   42.685927] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   42.685933] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[   42.685937] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] disconnected
[   42.685957] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[   42.685963] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
[   42.799406] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] probed modes :
[   42.799412] [drm:drm_mode_debug_printmodeline], Modeline 29:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[   42.799420] [drm:drm_mode_debug_printmodeline], Modeline 39:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[   42.799426] [drm:drm_mode_debug_printmodeline], Modeline 30:"1280x960" 60 108000 1280 1376 1488 1800 960 961 964 1000 0x40 0x5
[   42.799433] [drm:drm_mode_debug_printmodeline], Modeline 46:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[   42.799440] [drm:drm_mode_debug_printmodeline], Modeline 40:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[   42.799447] [drm:drm_mode_debug_printmodeline], Modeline 41:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[   42.799453] [drm:drm_mode_debug_printmodeline], Modeline 42:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[   42.799460] [drm:drm_mode_debug_printmodeline], Modeline 43:"832x624" 75 57284 832 864 928 1152 624 625 628 667 0x40 0xa
[   42.799466] [drm:drm_mode_debug_printmodeline], Modeline 45:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[   42.799473] [drm:drm_mode_debug_printmodeline], Modeline 44:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[   42.799479] [drm:drm_mode_debug_printmodeline], Modeline 32:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[   42.799486] [drm:drm_mode_debug_printmodeline], Modeline 33:"800x600" 56 36000 800 824 896 1024 600 601 603 625 0x40 0x5
[   42.799492] [drm:drm_mode_debug_printmodeline], Modeline 35:"640x480" 73 31500 640 664 704 832 480 489 491 520 0x40 0xa
[   42.799498] [drm:drm_mode_debug_printmodeline], Modeline 34:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[   42.799505] [drm:drm_mode_debug_printmodeline], Modeline 36:"640x480" 67 30240 640 704 768 864 480 483 486 525 0x40 0xa
[   42.799511] [drm:drm_mode_debug_printmodeline], Modeline 37:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[   42.799517] [drm:drm_mode_debug_printmodeline], Modeline 38:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[   42.799552] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[   42.800531] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[   42.800540] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1]
[   42.800550] [drm:intel_tv_detect_type], Detected Component TV connection
[   42.800585] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1] probed modes :
[   42.800590] [drm:drm_mode_debug_printmodeline], Modeline 55:"848x480" 60 29027 848 849 912 944 480 481 512 513 0x48 0x0
[   42.800597] [drm:drm_mode_debug_printmodeline], Modeline 48:"640x480" 60 22631 640 641 704 736 480 481 512 513 0x48 0x0
[   42.800604] [drm:drm_mode_debug_printmodeline], Modeline 57:"1920x1080" 60 134493 1920 1921 1984 2016 1080 1081 1112 1113 0x40 0x0
[   42.800612] [drm:drm_mode_debug_printmodeline], Modeline 51:"1280x1024" 60 87178 1280 1281 1344 1376 1024 1025 1056 1057 0x40 0x0
[   42.800618] [drm:drm_mode_debug_printmodeline], Modeline 56:"1280x720" 60 62105 1280 1281 1344 1376 720 721 752 753 0x40 0x0
[   42.800626] [drm:drm_mode_debug_printmodeline], Modeline 50:"1024x768" 60 53773 1024 1025 1088 1120 768 769 800 801 0x40 0x0
[   42.800633] [drm:drm_mode_debug_printmodeline], Modeline 49:"800x600" 60 33996 800 801 864 896 600 601 632 633 0x40 0x0
[   42.800643] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[   42.805115] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   42.805124] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[   42.805129] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] disconnected
[   42.805137] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   42.805143] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[   42.805148] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] disconnected
[   42.805165] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[   42.805172] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
[   42.915680] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] probed modes :
[   42.915686] [drm:drm_mode_debug_printmodeline], Modeline 29:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[   42.915693] [drm:drm_mode_debug_printmodeline], Modeline 39:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[   42.915700] [drm:drm_mode_debug_printmodeline], Modeline 30:"1280x960" 60 108000 1280 1376 1488 1800 960 961 964 1000 0x40 0x5
[   42.915707] [drm:drm_mode_debug_printmodeline], Modeline 46:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[   42.915713] [drm:drm_mode_debug_printmodeline], Modeline 40:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[   42.915720] [drm:drm_mode_debug_printmodeline], Modeline 41:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[   42.915726] [drm:drm_mode_debug_printmodeline], Modeline 42:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[   42.915733] [drm:drm_mode_debug_printmodeline], Modeline 43:"832x624" 75 57284 832 864 928 1152 624 625 628 667 0x40 0xa
[   42.915739] [drm:drm_mode_debug_printmodeline], Modeline 45:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[   42.915746] [drm:drm_mode_debug_printmodeline], Modeline 44:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[   42.915752] [drm:drm_mode_debug_printmodeline], Modeline 32:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[   42.915759] [drm:drm_mode_debug_printmodeline], Modeline 33:"800x600" 56 36000 800 824 896 1024 600 601 603 625 0x40 0x5
[   42.915765] [drm:drm_mode_debug_printmodeline], Modeline 35:"640x480" 73 31500 640 664 704 832 480 489 491 520 0x40 0xa
[   42.915771] [drm:drm_mode_debug_printmodeline], Modeline 34:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[   42.915778] [drm:drm_mode_debug_printmodeline], Modeline 36:"640x480" 67 30240 640 704 768 864 480 483 486 525 0x40 0xa
[   42.915784] [drm:drm_mode_debug_printmodeline], Modeline 37:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[   42.915790] [drm:drm_mode_debug_printmodeline], Modeline 38:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[   42.915814] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[   42.916772] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[   42.916780] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1]
[   42.916789] [drm:intel_tv_detect_type], Detected Component TV connection
[   42.916834] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1] probed modes :
[   42.916839] [drm:drm_mode_debug_printmodeline], Modeline 55:"848x480" 60 29027 848 849 912 944 480 481 512 513 0x48 0x0
[   42.916846] [drm:drm_mode_debug_printmodeline], Modeline 48:"640x480" 60 22631 640 641 704 736 480 481 512 513 0x48 0x0
[   42.916854] [drm:drm_mode_debug_printmodeline], Modeline 57:"1920x1080" 60 134493 1920 1921 1984 2016 1080 1081 1112 1113 0x40 0x0
[   42.916861] [drm:drm_mode_debug_printmodeline], Modeline 51:"1280x1024" 60 87178 1280 1281 1344 1376 1024 1025 1056 1057 0x40 0x0
[   42.916868] [drm:drm_mode_debug_printmodeline], Modeline 56:"1280x720" 60 62105 1280 1281 1344 1376 720 721 752 753 0x40 0x0
[   42.916875] [drm:drm_mode_debug_printmodeline], Modeline 50:"1024x768" 60 53773 1024 1025 1088 1120 768 769 800 801 0x40 0x0
[   42.916882] [drm:drm_mode_debug_printmodeline], Modeline 49:"800x600" 60 33996 800 801 864 896 600 601 632 633 0x40 0x0
[   42.916893] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[   42.920603] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   42.920612] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[   42.920617] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] disconnected
[   42.920625] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   42.920630] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[   42.920635] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] disconnected
[   42.920652] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[   42.920658] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
[   43.033852] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] probed modes :
[   43.033857] [drm:drm_mode_debug_printmodeline], Modeline 29:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[   43.033865] [drm:drm_mode_debug_printmodeline], Modeline 39:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[   43.033871] [drm:drm_mode_debug_printmodeline], Modeline 30:"1280x960" 60 108000 1280 1376 1488 1800 960 961 964 1000 0x40 0x5
[   43.033878] [drm:drm_mode_debug_printmodeline], Modeline 46:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[   43.033885] [drm:drm_mode_debug_printmodeline], Modeline 40:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[   43.033891] [drm:drm_mode_debug_printmodeline], Modeline 41:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[   43.033898] [drm:drm_mode_debug_printmodeline], Modeline 42:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[   43.033904] [drm:drm_mode_debug_printmodeline], Modeline 43:"832x624" 75 57284 832 864 928 1152 624 625 628 667 0x40 0xa
[   43.033911] [drm:drm_mode_debug_printmodeline], Modeline 45:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[   43.033917] [drm:drm_mode_debug_printmodeline], Modeline 44:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[   43.033923] [drm:drm_mode_debug_printmodeline], Modeline 32:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[   43.033930] [drm:drm_mode_debug_printmodeline], Modeline 33:"800x600" 56 36000 800 824 896 1024 600 601 603 625 0x40 0x5
[   43.033937] [drm:drm_mode_debug_printmodeline], Modeline 35:"640x480" 73 31500 640 664 704 832 480 489 491 520 0x40 0xa
[   43.033943] [drm:drm_mode_debug_printmodeline], Modeline 34:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[   43.033949] [drm:drm_mode_debug_printmodeline], Modeline 36:"640x480" 67 30240 640 704 768 864 480 483 486 525 0x40 0xa
[   43.033955] [drm:drm_mode_debug_printmodeline], Modeline 37:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[   43.033962] [drm:drm_mode_debug_printmodeline], Modeline 38:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[   43.033999] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[   43.034978] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[   43.034986] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1]
[   43.034997] [drm:intel_tv_detect_type], Detected Component TV connection
[   43.035058] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1] probed modes :
[   43.035063] [drm:drm_mode_debug_printmodeline], Modeline 55:"848x480" 60 29027 848 849 912 944 480 481 512 513 0x48 0x0
[   43.035069] [drm:drm_mode_debug_printmodeline], Modeline 48:"640x480" 60 22631 640 641 704 736 480 481 512 513 0x48 0x0
[   43.035076] [drm:drm_mode_debug_printmodeline], Modeline 57:"1920x1080" 60 134493 1920 1921 1984 2016 1080 1081 1112 1113 0x40 0x0
[   43.035083] [drm:drm_mode_debug_printmodeline], Modeline 51:"1280x1024" 60 87178 1280 1281 1344 1376 1024 1025 1056 1057 0x40 0x0
[   43.035089] [drm:drm_mode_debug_printmodeline], Modeline 56:"1280x720" 60 62105 1280 1281 1344 1376 720 721 752 753 0x40 0x0
[   43.035095] [drm:drm_mode_debug_printmodeline], Modeline 50:"1024x768" 60 53773 1024 1025 1088 1120 768 769 800 801 0x40 0x0
[   43.035102] [drm:drm_mode_debug_printmodeline], Modeline 49:"800x600" 60 33996 800 801 864 896 600 601 632 633 0x40 0x0
[   43.035112] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[   43.054948] [drm:intel_crtc_cursor_set], 
[   43.054960] [drm:intel_crtc_cursor_set], cursor off
[   43.055302] [drm:drm_mode_addfb], [FB:58]
[   43.055377] [drm:drm_mode_setcrtc], [CRTC:3]
[   43.055398] [drm:drm_mode_setcrtc], [CONNECTOR:12:VGA-1]
[   43.055408] [drm:drm_crtc_helper_set_config], 
[   43.055415] [drm:drm_crtc_helper_set_config], [CRTC:3] [FB:58] #connectors=1 (x y) (0 0)
[   43.055439] [drm:drm_crtc_helper_set_config], [CONNECTOR:12:VGA-1] to [CRTC:3]
[   43.055450] [drm:drm_crtc_helper_set_config], [CONNECTOR:14:SVIDEO-1] to [CRTC:4]
[   43.067870] [drm:intel_pipe_set_base], Writing base 01EAC000 00000000 0 0 5120
[   43.067878] [drm:intel_update_fbc], 
[   43.067881] [drm:intel_update_fbc], 2 pipes active
[   43.067885] [drm:intel_update_fbc], more than one pipe active, disabling compression
[   43.067956] [drm:drm_crtc_helper_set_config], 
[   43.067960] [drm:drm_crtc_helper_set_config], [CRTC:4] [NOFB] #connectors=0 (x y) (0 0)
[   43.067969] [drm:drm_crtc_helper_set_config], [CONNECTOR:12:VGA-1] to [CRTC:3]
[   43.067974] [drm:drm_crtc_helper_set_config], crtc changed, full mode switch
[   43.067978] [drm:drm_crtc_helper_set_config], [CONNECTOR:14:SVIDEO-1] to [NOCRTC]
[   43.067990] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 1
[   43.078148] [drm:intel_update_watermarks], plane A (pipe 0) clock: 65000
[   43.078153] [drm:i965_update_wm], self-refresh watermark: display plane 448 cursor 32
[   43.078158] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 448
[   43.078453] [drm:intel_crtc_cursor_set], 
[   43.081238] [drm:drm_mode_setcrtc], [CRTC:3]
[   43.081252] [drm:drm_mode_setcrtc], [CONNECTOR:12:VGA-1]
[   43.081256] [drm:drm_crtc_helper_set_config], 
[   43.081260] [drm:drm_crtc_helper_set_config], [CRTC:3] [FB:58] #connectors=1 (x y) (0 0)
[   43.081270] [drm:drm_crtc_helper_set_config], modes are different, full mode set
[   43.081274] [drm:drm_mode_debug_printmodeline], Modeline 53:"1024x768" 0 65000 1024 1048 1184 1344 768 771 777 806 0x0 0xa
[   43.081281] [drm:drm_mode_debug_printmodeline], Modeline 52:"" 0 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x0 0x5
[   43.081289] [drm:drm_crtc_helper_set_config], [CONNECTOR:12:VGA-1] to [CRTC:3]
[   43.081294] [drm:drm_crtc_helper_set_config], [CONNECTOR:14:SVIDEO-1] to [NOCRTC]
[   43.081299] [drm:drm_crtc_helper_set_config], attempting to set mode from userspace
[   43.081303] [drm:drm_mode_debug_printmodeline], Modeline 52:"" 0 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x0 0x5
[   43.081312] [drm:drm_crtc_helper_set_mode], [CRTC:3]
[   43.184794] [drm:intel_wait_for_vblank_off], vblank wait timed out
[   43.200204] [drm:intel_crtc_mode_set], Mode for pipe A:
[   43.200208] [drm:drm_mode_debug_printmodeline], Modeline 52:"" 0 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x0 0x5
[   43.251011] [drm:intel_wait_for_vblank], vblank wait timed out
[   43.254430] [drm:intel_pipe_set_base], Writing base 01EAC000 00000000 0 0 5120
[   43.254437] [drm:intel_update_fbc], 
[   43.254440] [drm:intel_update_fbc], 1 pipes active
[   43.254456] [drm:i8xx_enable_fbc], enabled FBC, pitch 71, yoff 0, plane 0, 
[   43.305012] [drm:intel_wait_for_vblank], vblank wait timed out
[   43.305020] [drm:drm_crtc_helper_set_mode], [ENCODER:13:DAC-13] set [MODE:52:]
[   43.305026] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   43.305030] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[   43.305035] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[   43.305064] [drm:intel_update_fbc], 
[   43.305068] [drm:intel_update_fbc], 1 pipes active
[   43.305073] [drm:i8xx_disable_fbc], disabled FBC
[   43.305086] [drm:i8xx_enable_fbc], enabled FBC, pitch 71, yoff 0, plane 0, 
[   43.305102] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 1
[   43.315259] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   43.315263] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[   43.315268] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[   44.940053] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[   46.364784] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   46.364795] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[   46.364801] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] disconnected
[   46.364809] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   46.364815] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[   46.364819] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] disconnected
[   46.364840] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[   46.364847] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
[   46.474648] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] probed modes :
[   46.474654] [drm:drm_mode_debug_printmodeline], Modeline 29:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[   46.474661] [drm:drm_mode_debug_printmodeline], Modeline 39:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[   46.474668] [drm:drm_mode_debug_printmodeline], Modeline 30:"1280x960" 60 108000 1280 1376 1488 1800 960 961 964 1000 0x40 0x5
[   46.474675] [drm:drm_mode_debug_printmodeline], Modeline 46:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[   46.474682] [drm:drm_mode_debug_printmodeline], Modeline 40:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[   46.474688] [drm:drm_mode_debug_printmodeline], Modeline 41:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[   46.474695] [drm:drm_mode_debug_printmodeline], Modeline 42:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[   46.474702] [drm:drm_mode_debug_printmodeline], Modeline 43:"832x624" 75 57284 832 864 928 1152 624 625 628 667 0x40 0xa
[   46.474708] [drm:drm_mode_debug_printmodeline], Modeline 45:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[   46.474714] [drm:drm_mode_debug_printmodeline], Modeline 44:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[   46.474721] [drm:drm_mode_debug_printmodeline], Modeline 32:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[   46.474727] [drm:drm_mode_debug_printmodeline], Modeline 33:"800x600" 56 36000 800 824 896 1024 600 601 603 625 0x40 0x5
[   46.474734] [drm:drm_mode_debug_printmodeline], Modeline 35:"640x480" 73 31500 640 664 704 832 480 489 491 520 0x40 0xa
[   46.474740] [drm:drm_mode_debug_printmodeline], Modeline 34:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[   46.474746] [drm:drm_mode_debug_printmodeline], Modeline 36:"640x480" 67 30240 640 704 768 864 480 483 486 525 0x40 0xa
[   46.474753] [drm:drm_mode_debug_printmodeline], Modeline 37:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[   46.474760] [drm:drm_mode_debug_printmodeline], Modeline 38:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[   46.474805] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[   46.475810] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[   46.475819] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1]
[   46.475832] [drm:drm_crtc_helper_set_mode], [CRTC:4]
[   46.475844] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 1
[   46.486013] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   46.486019] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[   46.486024] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[   46.486270] [drm:intel_crtc_mode_set], Mode for pipe B:
[   46.486274] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[   46.486735] [drm:intel_pipe_set_base], No FB bound
[   46.486738] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   46.486743] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[   46.486748] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[   46.486754] [drm:drm_crtc_helper_set_mode], [ENCODER:15:TV-15] set [MODE:0:NTSC 480i]
[   46.537013] [drm:intel_wait_for_vblank], vblank wait timed out
[   46.537041] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   46.537046] [drm:intel_update_watermarks], plane B (pipe 1) clock: 107520
[   46.537050] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   46.537080] [drm:intel_update_fbc], 
[   46.588016] [drm:intel_wait_for_vblank], vblank wait timed out
[   46.639012] [drm:intel_wait_for_vblank], vblank wait timed out
[   46.652012] [drm:intel_crtc_idle_timer], idle timer fired, downclocking
[   46.690014] [drm:intel_wait_for_vblank], vblank wait timed out
[   46.690019] [drm:intel_tv_detect_type], No TV connection detected
[   46.810205] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   46.810212] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[   46.810217] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[   46.810223] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1] disconnected
[   46.810229] [drm:drm_mode_debug_printmodeline], Modeline 55:"848x480" 60 29027 848 849 912 944 480 481 512 513 0x48 0x0
[   46.810236] [drm:drm_mode_prune_invalid], Not using 848x480 mode -3
[   46.810243] [drm:drm_mode_debug_printmodeline], Modeline 48:"640x480" 60 22631 640 641 704 736 480 481 512 513 0x48 0x0
[   46.810249] [drm:drm_mode_prune_invalid], Not using 640x480 mode -3
[   46.810255] [drm:drm_mode_debug_printmodeline], Modeline 57:"1920x1080" 60 134493 1920 1921 1984 2016 1080 1081 1112 1113 0x40 0x0
[   46.810261] [drm:drm_mode_prune_invalid], Not using 1920x1080 mode -3
[   46.810267] [drm:drm_mode_debug_printmodeline], Modeline 51:"1280x1024" 60 87178 1280 1281 1344 1376 1024 1025 1056 1057 0x40 0x0
[   46.810273] [drm:drm_mode_prune_invalid], Not using 1280x1024 mode -3
[   46.810279] [drm:drm_mode_debug_printmodeline], Modeline 56:"1280x720" 60 62105 1280 1281 1344 1376 720 721 752 753 0x40 0x0
[   46.810285] [drm:drm_mode_prune_invalid], Not using 1280x720 mode -3
[   46.810291] [drm:drm_mode_debug_printmodeline], Modeline 50:"1024x768" 60 53773 1024 1025 1088 1120 768 769 800 801 0x40 0x0
[   46.810297] [drm:drm_mode_prune_invalid], Not using 1024x768 mode -3
[   46.810302] [drm:drm_mode_debug_printmodeline], Modeline 49:"800x600" 60 33996 800 801 864 896 600 601 632 633 0x40 0x0
[   46.810309] [drm:drm_mode_prune_invalid], Not using 800x600 mode -3
[   46.810338] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[   46.810346] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1]
[   46.810363] [drm:drm_crtc_helper_set_mode], [CRTC:4]
[   46.810373] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 1
[   46.820530] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   46.820536] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[   46.820540] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[   46.820786] [drm:intel_crtc_mode_set], Mode for pipe B:
[   46.820791] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[   46.821252] [drm:intel_pipe_set_base], No FB bound
[   46.821256] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   46.821260] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[   46.821266] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[   46.821272] [drm:drm_crtc_helper_set_mode], [ENCODER:15:TV-15] set [MODE:0:NTSC 480i]
[   46.833037] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   46.833042] [drm:intel_update_watermarks], plane B (pipe 1) clock: 107520
[   46.833046] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   46.833076] [drm:intel_update_fbc], 
[   46.833086] [drm:intel_tv_detect_type], Detected S-Video TV connection
[   46.864011] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[   46.953262] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   46.953267] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[   46.953272] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[   46.953300] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1] probed modes :
[   46.953305] [drm:drm_mode_debug_printmodeline], Modeline 51:"848x480" 30 14513 848 849 912 944 480 481 512 513 0x48 0x0
[   46.953312] [drm:drm_mode_debug_printmodeline], Modeline 48:"640x480" 30 11315 640 641 704 736 480 481 512 513 0x48 0x0
[   46.953318] [drm:drm_mode_debug_printmodeline], Modeline 50:"1024x768" 30 26886 1024 1025 1088 1120 768 769 800 801 0x40 0x0
[   46.953325] [drm:drm_mode_debug_printmodeline], Modeline 49:"800x600" 30 16998 800 801 864 896 600 601 632 633 0x40 0x0
[   46.953357] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[   46.953364] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1]
[   46.953373] [drm:drm_crtc_helper_set_mode], [CRTC:4]
[   46.953381] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 1
[   46.963539] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   46.963544] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[   46.963549] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[   46.963795] [drm:intel_crtc_mode_set], Mode for pipe B:
[   46.963799] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[   46.964260] [drm:intel_pipe_set_base], No FB bound
[   46.964265] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   46.964270] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[   46.964275] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[   46.964281] [drm:drm_crtc_helper_set_mode], [ENCODER:15:TV-15] set [MODE:0:NTSC 480i]
[   46.967049] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   46.967054] [drm:intel_update_watermarks], plane B (pipe 1) clock: 107520
[   46.967058] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   46.967088] [drm:intel_update_fbc], 
[   46.967099] [drm:intel_tv_detect_type], Detected Composite TV connection
[   47.077275] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   47.077282] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[   47.077287] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[   47.077331] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1] probed modes :
[   47.077336] [drm:drm_mode_debug_printmodeline], Modeline 51:"848x480" 30 14513 848 849 912 944 480 481 512 513 0x48 0x0
[   47.077343] [drm:drm_mode_debug_printmodeline], Modeline 48:"640x480" 30 11315 640 641 704 736 480 481 512 513 0x48 0x0
[   47.077349] [drm:drm_mode_debug_printmodeline], Modeline 50:"1024x768" 30 26886 1024 1025 1088 1120 768 769 800 801 0x40 0x0
[   47.077355] [drm:drm_mode_debug_printmodeline], Modeline 49:"800x600" 30 16998 800 801 864 896 600 601 632 633 0x40 0x0
[   47.077389] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[   47.095576] [drm:intel_crtc_cursor_set], 
[   47.095582] [drm:intel_crtc_cursor_set], cursor off
[   47.098125] [drm:drm_mode_addfb], [FB:55]
[   47.098174] [drm:drm_mode_setcrtc], [CRTC:3]
[   47.098184] [drm:drm_mode_setcrtc], [CONNECTOR:12:VGA-1]
[   47.098188] [drm:drm_crtc_helper_set_config], 
[   47.098192] [drm:drm_crtc_helper_set_config], [CRTC:3] [FB:55] #connectors=1 (x y) (0 0)
[   47.098208] [drm:drm_crtc_helper_set_config], [CONNECTOR:12:VGA-1] to [CRTC:3]
[   47.114680] [drm:intel_pipe_set_base], Writing base 032AC000 00000000 0 0 8704
[   47.114688] [drm:intel_update_fbc], 
[   47.114692] [drm:intel_update_fbc], 1 pipes active
[   47.114696] [drm:intel_update_fbc], framebuffer too large, disabling compression
[   47.114701] [drm:intel_update_fbc], unsupported config, disabling FBC
[   47.114706] [drm:i8xx_disable_fbc], disabled FBC
[   47.115030] [drm:intel_crtc_cursor_set], 
[   47.121066] [drm:drm_mode_setcrtc], [CRTC:4]
[   47.121078] [drm:drm_mode_setcrtc], [CONNECTOR:14:SVIDEO-1]
[   47.121083] [drm:drm_crtc_helper_set_config], 
[   47.121087] [drm:drm_crtc_helper_set_config], [CRTC:4] [FB:55] #connectors=1 (x y) (1280 0)
[   47.121097] [drm:drm_crtc_helper_set_config], crtc has no fb, full mode set
[   47.121101] [drm:drm_crtc_helper_set_config], modes are different, full mode set
[   47.121105] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[   47.121112] [drm:drm_mode_debug_printmodeline], Modeline 57:"" 0 14513 848 849 912 944 480 481 512 513 0x0 0x0
[   47.121120] [drm:drm_crtc_helper_set_config], encoder changed, full mode switch
[   47.121124] [drm:drm_crtc_helper_set_config], [CONNECTOR:12:VGA-1] to [CRTC:3]
[   47.121129] [drm:drm_crtc_helper_set_config], crtc changed, full mode switch
[   47.121133] [drm:drm_crtc_helper_set_config], [CONNECTOR:14:SVIDEO-1] to [CRTC:4]
[   47.121138] [drm:drm_crtc_helper_set_config], attempting to set mode from userspace
[   47.121142] [drm:drm_mode_debug_printmodeline], Modeline 57:"" 0 14513 848 849 912 944 480 481 512 513 0x0 0x0
[   47.121151] [drm:drm_crtc_helper_set_mode], [CRTC:4]
[   47.121161] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 1
[   47.131321] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   47.131328] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[   47.131333] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[   47.131581] [drm:intel_crtc_mode_set], Mode for pipe B:
[   47.131585] [drm:drm_mode_debug_printmodeline], Modeline 57:"" 0 14513 848 849 912 944 480 481 512 513 0x0 0x0
[   47.132049] [drm:intel_pipe_set_base], Writing base 032AC000 00001400 1280 0 8704
[   47.132055] [drm:intel_update_fbc], 
[   47.132059] [drm:intel_update_fbc], 2 pipes active
[   47.132063] [drm:intel_update_fbc], more than one pipe active, disabling compression
[   47.132778] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   47.132783] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[   47.132788] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[   47.132794] [drm:drm_crtc_helper_set_mode], [ENCODER:15:TV-15] set [MODE:57:]
[   47.132819] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   47.132823] [drm:intel_update_watermarks], plane B (pipe 1) clock: 14513
[   47.132828] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   47.132858] [drm:intel_update_fbc], 
[   47.132861] [drm:intel_update_fbc], 2 pipes active
[   47.132864] [drm:intel_update_fbc], more than one pipe active, disabling compression
[   47.132917] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   47.132922] [drm:intel_update_watermarks], plane B (pipe 1) clock: 14513
[   47.132926] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   47.132956] [drm:intel_update_fbc], 
[   47.132959] [drm:intel_update_fbc], 2 pipes active
[   47.132963] [drm:intel_update_fbc], more than one pipe active, disabling compression
[   47.133114] [drm:intel_crtc_cursor_set], 
[   47.133118] [drm:intel_crtc_cursor_set], cursor off
[   47.523313] ACPI: EC: GPE storm detected, transactions will use polling mode
[   49.388017] [drm:intel_crtc_idle_timer], idle timer fired, downclocking
[   49.388031] [drm:intel_crtc_idle_timer], idle timer fired, downclocking
[   52.963158] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[   58.008170] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[   64.081189] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[   68.098157] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[   72.050178] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[   73.251172] [drm:intel_gpu_idle_timer], idle timer fired, downclocking

--=-VvVq7WiiE4PudwTTyALl--


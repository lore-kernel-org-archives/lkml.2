Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970Ab0GHEYg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 00:24:36 -0400
Received: from client-adsl-93-121-138-180.mediaserv.net ([93.121.138.180]:58522
	"EHLO werner.loopback" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750722Ab0GHEYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 00:24:34 -0400
From: werner@guyane.yi.org
Subject: 2.6.35-rc2,3 -- Problem with PS2 keyboard and mouse driver
To: linux-kernel@vger.kernel.org
X-Originating-IP: 127.0.0.1
X-Mailer: Usermin 1.360
Message-Id: <1278563108.9127@guyane.yi.org>
Date: Thu, 08 Jul 2010 01:25:08 -0300 (GFT)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="bound1278563108"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--bound1278563108
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit

2.6.35-rc2,3,3-git1 -- Problem with PS2 keyboard and mouse driver

That problem continues at 2.6.35-rc4-git2 .

Since 2.6.35-rc2 the USB keyboard driver don't work longer, on different mainboards and keyboards.

On 2.6.35-rc1 things still were (more or less) normal.

THIS IS AN ERROR WHICH ENTERED BETWEEN 2.6.35 -rc1 and -rc2 !!

werner landgraf


BELOW a syslog:  

1) Jul 8, 1:09   boot with 2.6.35-rc4-git2  .  Imediately when kernel was loaded, keyboard (caps lock button) stopped to react.   The boot reached KDE start, but neither
the PS/2 keyboard nor the PS2 mouse reacted, so that I rebooted.

2) Jul 8, 1:13   boot with 2.6.35-rc1 , here everything still worked normal, that's the
kernel I'm using actually on my server (it dont crash during days)

==========================
Jul  8 01:09:41 werner hcid[5406]: Got disconnected from the system message bus
Jul  8 01:10:57 werner kernel: Malformed early option 'acpi'
Jul  8 01:10:57 werner kernel: ACPI: RSDP 000fb9f0 00024 (v02 ACPIAM)
Jul  8 01:10:57 werner kernel: ACPI: XSDT affc0100 0004C (v01 A_M_I_ OEMXSDT  01000715 MSFT 00000097)
Jul  8 01:10:57 werner kernel: ACPI: FACP affc0290 000F4 (v03 A_M_I_ OEMFACP  01000715 MSFT 00000097)
Jul  8 01:10:57 werner kernel: ACPI: DSDT affc0440 04DAE (v01  A0647 A0647000 00000000 INTL 02002026)
Jul  8 01:10:57 werner kernel: ACPI: FACS affce000 00040
Jul  8 01:10:57 werner kernel: ACPI: APIC affc0390 00070 (v01 A_M_I_ OEMAPIC  01000715 MSFT 00000097)
Jul  8 01:10:57 werner kernel: ACPI: MCFG affc0400 0003C (v01 A_M_I_ OEMMCFG  01000715 MSFT 00000097)
Jul  8 01:10:57 werner kernel: ACPI: OEMB affce040 00060 (v01 A_M_I_ AMI_OEM  01000715 MSFT 00000097)
Jul  8 01:10:57 werner kernel: ACPI: HPET affc51f0 00038 (v01 A_M_I_ OEMHPET0 01000715 MSFT 00000097)
Jul  8 01:10:57 werner kernel: Zone PFN ranges:
Jul  8 01:10:57 werner kernel:   DMA      0x00000010 -> 0x00001000
Jul  8 01:10:57 werner kernel:   Normal   0x00001000 -> 0x000377fe
Jul  8 01:10:57 werner kernel:   HighMem  0x000377fe -> 0x000affc0
Jul  8 01:10:57 werner kernel: Movable zone start PFN for each node
Jul  8 01:10:57 werner kernel: early_node_map[2] active PFN ranges
Jul  8 01:10:57 werner kernel:     0: 0x00000010 -> 0x0000009f
Jul  8 01:10:57 werner kernel:     0: 0x00000100 -> 0x000affc0
Jul  8 01:10:57 werner kernel: Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 715087
Jul  8 01:10:57 werner kernel: Console: colour dummy device 80x25
Jul  8 01:10:57 werner kernel: Fast TSC calibration using PIT
Jul  8 01:10:57 werner kernel: Detected 2410.884 MHz processor.
Jul  8 01:10:57 werner kernel: Mount-cache hash table entries: 512
Jul  8 01:10:57 werner kernel: AMD PMU driver.
Jul  8 01:10:57 werner kernel: ACPI: setting ELCR to 0200 (from 8c00)
Jul  8 01:10:57 werner kernel: bio: create slab <bio-0> at 0
Jul  8 01:10:57 werner kernel: ACPI: Executed 1 blocks of module-level executable AML code
Jul  8 01:10:57 werner kernel: ACPI Warning: Incorrect checksum in table [OEMB] - 0xF8, should be 0xEB (20100428/tbutils-314)
Jul  8 01:10:57 werner kernel: raid6: int32x1    617 MB/s
Jul  8 01:10:57 werner kernel: raid6: int32x2    832 MB/s
Jul  8 01:10:57 werner kernel: raid6: int32x4    675 MB/s
Jul  8 01:10:57 werner kernel: raid6: int32x8    519 MB/s
Jul  8 01:10:57 werner kernel: raid6: mmxx1     1929 MB/s
Jul  8 01:10:57 werner kernel: raid6: mmxx2     3511 MB/s
Jul  8 01:10:57 werner kernel: raid6: sse1x1    1941 MB/s
Jul  8 01:10:57 werner kernel: raid6: sse1x2    3183 MB/s
Jul  8 01:10:57 werner kernel: raid6: sse2x1    2980 MB/s
Jul  8 01:10:57 werner kernel: raid6: sse2x2    4207 MB/s
Jul  8 01:10:57 werner kernel: raid6: using algorithm sse2x2 (4207 MB/s)
Jul  8 01:10:57 werner kernel: microcode: microcode: CPU0: AMD CPU family 0xf not supported
Jul  8 01:10:57 werner kernel: highmem bounce pool size: 64 pages
Jul  8 01:10:57 werner kernel: Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
Jul  8 01:10:57 werner kernel: DLM (built Jul  7 2010 23:25:04) installed
Jul  8 01:10:57 werner kernel: EFS: 1.0a - http://aeschi.ch.eu.org/efs/
Jul  8 01:10:57 werner kernel: OCFS2 User DLM kernel interface loaded
Jul  8 01:10:57 werner kernel: GFS2 (built Jul  7 2010 23:26:29) installed
Jul  8 01:10:57 werner kernel: acpiphp_ibm: ibm_acpiphp_init: acpi_walk_namespace failed
Jul  8 01:10:57 werner kernel: mdacon: MDA with 8K of memory detected.
Jul  8 01:10:57 werner kernel: Console: switching consoles 13-16 to MDA-2
Jul  8 01:10:57 werner kernel: ACPI: PCI Interrupt Link [LMC9] enabled at IRQ 11
Jul  8 01:10:57 werner kernel: nvidiafb: CRTC0 analog found
Jul  8 01:10:57 werner kernel: nvidiafb: CRTC1 analog not found
Jul  8 01:10:57 werner kernel: i2c i2c-0: unable to read EDID block.
Jul  8 01:10:57 werner last message repeated 2 times
Jul  8 01:10:57 werner kernel: nvidiafb: EDID found from BUS2
Jul  8 01:10:57 werner kernel: nvidiafb: CRTC 0 appears to have a CRT attached
Jul  8 01:10:57 werner kernel: nvidiafb: Using CRT on CRTC 0
Jul  8 01:10:57 werner kernel: Console: switching to colour frame buffer device 210x65
Jul  8 01:10:57 werner kernel: Could not find Carillo Ranch MCH device.
Jul  8 01:10:57 werner kernel: no IO addresses supplied
Jul  8 01:10:57 werner kernel: hgafb: probe of hgafb.0 failed with error -22
Jul  8 01:10:57 werner kernel: uvesafb: failed to execute /sbin/v86d
Jul  8 01:10:57 werner kernel: uvesafb: make sure that the v86d helper is installed and executable
Jul  8 01:10:57 werner kernel: uvesafb: Getting VBE info block failed (eax=0x4f00, err=-2)
Jul  8 01:10:57 werner kernel: uvesafb: vbe_init() failed with -22
Jul  8 01:10:57 werner kernel: uvesafb: probe of uvesafb.0 failed with error -22
Jul  8 01:10:57 werner kernel: vesafb: cannot reserve video memory at 0xc0000000
Jul  8 01:10:57 werner kernel: toshiba: not a supported Toshiba laptop
Jul  8 01:10:57 werner kernel: Compaq SMART2 Driver (v 2.6.0)
Jul  8 01:10:57 werner kernel:  hda3: <minix: hda5 hda6 hda7 >
Jul  8 01:10:57 werner kernel: Loading Adaptec I2O RAID: Version 2.4 Build 5go
Jul  8 01:10:57 werner kernel: scsi: <fdomain> Detection failed (no card)
Jul  8 01:10:57 werner kernel: NCR53c406a: no available ports found
Jul  8 01:10:57 werner kernel: Emulex LightPulse Fibre Channel SCSI driver 8.3.12
Jul  8 01:10:57 werner kernel: Copyright(c) 2004-2009 Emulex.  All rights reserved.
Jul  8 01:10:57 werner kernel: Failed initialization of WD-7000 SCSI card!
Jul  8 01:10:57 werner kernel: GDT-HA: Storage RAID Controller Driver. Version: 3.05
Jul  8 01:10:57 werner kernel: 3ware Storage Controller device driver for Linux v1.26.02.003.
Jul  8 01:10:57 werner kernel: 3ware 9000 Storage Controller device driver for Linux v2.26.02.014.
Jul  8 01:10:57 werner kernel: imm: Version 2.05 (for Linux 2.4.0)
Jul  8 01:10:57 werner kernel: ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 15
Jul  8 01:10:57 werner kernel: Error: Driver 'pata_platform' is already registered, aborting...
Jul  8 01:10:57 werner kernel: mtdoops: mtd device (mtddev=name/number) must be supplied
Jul  8 01:10:57 werner kernel: physmap-flash.0: failed to claim resource 0
Jul  8 01:10:57 werner kernel: Failed to ioremap_nocache
Jul  8 01:10:57 werner last message repeated 2 times
Jul  8 01:10:57 werner kernel: SNAPGEAR: failed to ioremap() BOOTCS
Jul  8 01:10:57 werner kernel: Generic platform RAM MTD, (c) 2004 Simtec Electronics
Jul  8 01:10:57 werner kernel: [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
Jul  8 01:10:57 werner last message repeated 5 times
Jul  8 01:10:57 werner kernel: flash size: 8 MiB
Jul  8 01:10:57 werner kernel: page size: 512 bytes
Jul  8 01:10:57 werner kernel: OOB area size: 16 bytes
Jul  8 01:10:57 werner kernel: sector size: 8 KiB
Jul  8 01:10:57 werner kernel: pages number: 16384
Jul  8 01:10:57 werner kernel: pages per sector: 16
Jul  8 01:10:57 werner kernel: bus width: 8
Jul  8 01:10:57 werner kernel: bits in sector size: 13
Jul  8 01:10:57 werner kernel: bits in page size: 9
Jul  8 01:10:57 werner kernel: bits in OOB size: 4
Jul  8 01:10:57 werner kernel: flash size with OOB: 8448 KiB
Jul  8 01:10:57 werner kernel: page address bytes: 3
Jul  8 01:10:57 werner kernel: sector address bytes: 2
Jul  8 01:10:57 werner kernel: options: 0x62
Jul  8 01:10:57 werner kernel: onenand_wait: timeout! ctrl=0x0000 intr=0x0000
Jul  8 01:10:57 werner kernel: DE600: port 0x378 busy
Jul  8 01:10:57 werner kernel: paride: aten registered as protocol 0
Jul  8 01:10:57 werner kernel: paride: bpck registered as protocol 1
Jul  8 01:10:57 werner kernel: paride: comm registered as protocol 2
Jul  8 01:10:57 werner kernel: paride: dstr registered as protocol 3
Jul  8 01:10:57 werner kernel: paride: k951 registered as protocol 4
Jul  8 01:10:57 werner kernel: paride: k971 registered as protocol 5
Jul  8 01:10:57 werner kernel: paride: epat registered as protocol 6
Jul  8 01:10:57 werner kernel: paride: epia registered as protocol 7
Jul  8 01:10:57 werner kernel: paride: frpw registered as protocol 8
Jul  8 01:10:57 werner kernel: paride: friq registered as protocol 9
Jul  8 01:10:57 werner kernel: paride: fit2 registered as protocol 10
Jul  8 01:10:57 werner kernel: paride: fit3 registered as protocol 11
Jul  8 01:10:57 werner kernel: paride: on20 registered as protocol 12
Jul  8 01:10:57 werner kernel: paride: on26 registered as protocol 13
Jul  8 01:10:57 werner kernel: paride: ktti registered as protocol 14
Jul  8 01:10:57 werner kernel: paride: bpck6 registered as protocol 15
Jul  8 01:10:57 werner kernel: pd: pd version 1.05, major 45, cluster 64, nice 0
Jul  8 01:10:57 werner kernel: pda: Autoprobe failed
Jul  8 01:10:57 werner kernel: pd: no valid drive found
Jul  8 01:10:57 werner kernel: pcd: pcd version 1.07, major 46, nice 0
Jul  8 01:10:57 werner kernel: pcd0: Autoprobe failed
Jul  8 01:10:57 werner kernel: pcd: No CD-ROM drive found
Jul  8 01:10:57 werner kernel: pf: pf version 1.04, major 47, cluster 64, nice 0
Jul  8 01:10:57 werner kernel: pf: No ATAPI disk detected
Jul  8 01:10:57 werner kernel: pt: pt version 1.04, major 96
Jul  8 01:10:57 werner kernel: pt0: Autoprobe failed
Jul  8 01:10:57 werner kernel: pt: No ATAPI tape drive detected
Jul  8 01:10:57 werner kernel: pg: pg version 1.02, major 97
Jul  8 01:10:57 werner kernel: pga: Autoprobe failed
Jul  8 01:10:57 werner kernel: pg: No ATAPI device detected
Jul  8 01:10:57 werner kernel: ACPI: PCI Interrupt Link [LUB2] enabled at IRQ 10
Jul  8 01:10:57 werner kernel: ACPI: PCI Interrupt Link [LUB0] enabled at IRQ 11
Jul  8 01:10:57 werner kernel: GTCO usb driver version: 2.00.0006
Jul  8 01:10:57 werner kernel: EISA: Cannot allocate resource for mainboard
Jul  8 01:10:57 werner kernel: Cannot allocate resource for EISA slot 1
Jul  8 01:10:57 werner kernel: Cannot allocate resource for EISA slot 2
Jul  8 01:10:57 werner kernel: Cannot allocate resource for EISA slot 3
Jul  8 01:10:57 werner kernel: Cannot allocate resource for EISA slot 4
Jul  8 01:10:57 werner kernel: Cannot allocate resource for EISA slot 5
Jul  8 01:10:57 werner kernel: Cannot allocate resource for EISA slot 6
Jul  8 01:10:57 werner kernel: Cannot allocate resource for EISA slot 7
Jul  8 01:10:57 werner kernel: Cannot allocate resource for EISA slot 8
Jul  8 01:10:57 werner kernel: dell-wmi: No known WMI GUID found
Jul  8 01:10:57 werner kernel: This machine doesn't have MSI-hotkeys through WMI
Jul  8 01:10:57 werner kernel: [Firmware Bug]: powernow-k8: No PSB or ACPI _PSS objects
Jul  8 01:10:57 werner kernel: sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
Jul  8 01:10:57 werner kernel: VFS: Mounted root (ext3 filesystem) readonly on device 8:1.
Jul  8 01:10:57 werner kernel: ACPI: PCI Interrupt Link [LNEA] enabled at IRQ 11
Jul  8 01:10:57 werner kernel: ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 11
Jul  8 01:10:57 werner kernel: k8temp 0000:00:18.3: Temperature readouts might be wrong - check erratum #141
Jul  8 01:10:57 werner kernel: ACPI: PCI Interrupt Link [LAZA] enabled at IRQ 11
Jul  8 01:10:57 werner kernel: rt2860sta: module is from the staging directory, the quality is unknown, you have been warned.
Jul  8 01:10:57 werner kernel: EXT3-fs (sda2): warning: maximal mount count reached, running e2fsck is recommended
Jul  8 01:10:57 werner kernel: EXT3-fs (hda1): warning: maximal mount count reached, running e2fsck is recommended
Jul  8 01:10:57 werner kernel: EXT3-fs (sda3): warning: maximal mount count reached, running e2fsck is recommended
Jul  8 01:10:57 werner udevd-event[5106]: udev_rules_apply_format: unknown format variable '$modalias | grep -q eagle-usb || exit; while ! /sbin/eaglectrl -p 2>/dev/null | /bin/grep -q Post-firmware; do sleep 2; done; /sbin/eaglectrl -d''
Jul  8 01:10:57 werner udevd-event[5105]: udev_rules_apply_format: unknown format variable '$modalias | grep -q eagle-usb || exit; while ! /sbin/eaglectrl -p 2>/dev/null | /bin/grep -q Post-firmware; do sleep 2; done; /sbin/eaglectrl -d''
Jul  8 01:11:08 werner apcupsd[5083]: apcupsd FATAL ERROR in smartsetup.c at line 171 PANIC! Cannot communicate with UPS via serial port. Please make sure the port specified on the DEVICE directive is correct, and that your cable specification on the UPSCABLE directive is correct. 
Jul  8 01:11:08 werner apcupsd[5083]: apcupsd error shutdown completed
Jul  8 01:11:13 werner hpijs: unable to init hpijs server 
Jul  8 01:11:16 werner udevd[2393]: add_to_rules: unknown key 'MODALIAS' in /etc/udev/rules.d/80-eagle-usb.rules:1
Jul  8 01:11:35 werner kdm_greet[5520]: Can't open default user face
Jul  8 01:13:03 werner kernel: Malformed early option 'acpi'
Jul  8 01:13:03 werner kernel: ACPI: RSDP 000fb9f0 00024 (v02 ACPIAM)
Jul  8 01:13:03 werner kernel: ACPI: XSDT affc0100 0004C (v01 A_M_I_ OEMXSDT  01000715 MSFT 00000097)
Jul  8 01:13:03 werner kernel: ACPI: FACP affc0290 000F4 (v03 A_M_I_ OEMFACP  01000715 MSFT 00000097)
Jul  8 01:13:03 werner kernel: ACPI: DSDT affc0440 04DAE (v01  A0647 A0647000 00000000 INTL 02002026)
Jul  8 01:13:03 werner kernel: ACPI: FACS affce000 00040
Jul  8 01:13:03 werner kernel: ACPI: APIC affc0390 00070 (v01 A_M_I_ OEMAPIC  01000715 MSFT 00000097)
Jul  8 01:13:03 werner kernel: ACPI: MCFG affc0400 0003C (v01 A_M_I_ OEMMCFG  01000715 MSFT 00000097)
Jul  8 01:13:03 werner kernel: ACPI: OEMB affce040 00060 (v01 A_M_I_ AMI_OEM  01000715 MSFT 00000097)
Jul  8 01:13:03 werner kernel: ACPI: HPET affc51f0 00038 (v01 A_M_I_ OEMHPET0 01000715 MSFT 00000097)
Jul  8 01:13:03 werner kernel: Zone PFN ranges:
Jul  8 01:13:03 werner kernel:   DMA      0x00000010 -> 0x00001000
Jul  8 01:13:03 werner kernel:   Normal   0x00001000 -> 0x000377fe
Jul  8 01:13:03 werner kernel:   HighMem  0x000377fe -> 0x000affc0
Jul  8 01:13:03 werner kernel: Movable zone start PFN for each node
Jul  8 01:13:03 werner kernel: early_node_map[2] active PFN ranges
Jul  8 01:13:03 werner kernel:     0: 0x00000010 -> 0x0000009f
Jul  8 01:13:03 werner kernel:     0: 0x00000100 -> 0x000affc0
Jul  8 01:13:03 werner kernel: Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 715087
Jul  8 01:13:03 werner kernel: Console: colour dummy device 80x25
Jul  8 01:13:03 werner kernel: Fast TSC calibration using PIT
Jul  8 01:13:03 werner kernel: Detected 2411.015 MHz processor.
Jul  8 01:13:03 werner kernel: Mount-cache hash table entries: 512
Jul  8 01:13:03 werner kernel: AMD PMU driver.
Jul  8 01:13:03 werner kernel: ACPI: setting ELCR to 0200 (from 8c00)
Jul  8 01:13:03 werner kernel: bio: create slab <bio-0> at 0
Jul  8 01:13:03 werner kernel: ACPI: Executed 1 blocks of module-level executable AML code
Jul  8 01:13:03 werner kernel: ACPI Warning: Incorrect checksum in table [OEMB] - 0xF8, should be 0xEB (20100428/tbutils-314)
Jul  8 01:13:03 werner kernel: raid6: int32x1    617 MB/s
Jul  8 01:13:03 werner kernel: raid6: int32x2    820 MB/s
Jul  8 01:13:03 werner kernel: raid6: int32x4    675 MB/s
Jul  8 01:13:03 werner kernel: raid6: int32x8    515 MB/s
Jul  8 01:13:03 werner kernel: raid6: mmxx1     1929 MB/s
Jul  8 01:13:03 werner kernel: raid6: mmxx2     3523 MB/s
Jul  8 01:13:03 werner kernel: raid6: sse1x1    1906 MB/s
Jul  8 01:13:03 werner kernel: raid6: sse1x2    3199 MB/s
Jul  8 01:13:03 werner kernel: raid6: sse2x1    3312 MB/s
Jul  8 01:13:03 werner kernel: raid6: sse2x2    4238 MB/s
Jul  8 01:13:03 werner kernel: raid6: using algorithm sse2x2 (4238 MB/s)
Jul  8 01:13:03 werner kernel: microcode: microcode: CPU0: AMD CPU family 0xf not supported
Jul  8 01:13:03 werner kernel: highmem bounce pool size: 64 pages
Jul  8 01:13:03 werner kernel: Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
Jul  8 01:13:03 werner kernel: DLM (built May 30 2010 20:44:58) installed
Jul  8 01:13:03 werner kernel: EFS: 1.0a - http://aeschi.ch.eu.org/efs/
Jul  8 01:13:03 werner kernel: OCFS2 User DLM kernel interface loaded
Jul  8 01:13:03 werner kernel: GFS2 (built May 30 2010 20:46:08) installed
Jul  8 01:13:03 werner kernel: acpiphp_ibm: ibm_acpiphp_init: acpi_walk_namespace failed
Jul  8 01:13:03 werner kernel: mdacon: MDA with 8K of memory detected.
Jul  8 01:13:03 werner kernel: Console: switching consoles 13-16 to MDA-2
Jul  8 01:13:03 werner kernel: ACPI: PCI Interrupt Link [LMC9] enabled at IRQ 11
Jul  8 01:13:03 werner kernel: nvidiafb: CRTC0 analog found
Jul  8 01:13:03 werner kernel: nvidiafb: CRTC1 analog not found
Jul  8 01:13:03 werner kernel: i2c i2c-0: unable to read EDID block.
Jul  8 01:13:03 werner last message repeated 2 times
Jul  8 01:13:03 werner kernel: nvidiafb: EDID found from BUS2
Jul  8 01:13:03 werner kernel: nvidiafb: CRTC 0 appears to have a CRT attached
Jul  8 01:13:03 werner kernel: nvidiafb: Using CRT on CRTC 0
Jul  8 01:13:03 werner kernel: Console: switching to colour frame buffer device 210x65
Jul  8 01:13:03 werner kernel: Could not find Carillo Ranch MCH device.
Jul  8 01:13:03 werner kernel: no IO addresses supplied
Jul  8 01:13:03 werner kernel: hgafb: probe of hgafb.0 failed with error -22
Jul  8 01:13:03 werner kernel: uvesafb: failed to execute /sbin/v86d
Jul  8 01:13:03 werner kernel: uvesafb: make sure that the v86d helper is installed and executable
Jul  8 01:13:03 werner kernel: uvesafb: Getting VBE info block failed (eax=0x4f00, err=-2)
Jul  8 01:13:03 werner kernel: uvesafb: vbe_init() failed with -22
Jul  8 01:13:03 werner kernel: uvesafb: probe of uvesafb.0 failed with error -22
Jul  8 01:13:03 werner kernel: vesafb: cannot reserve video memory at 0xc0000000
Jul  8 01:13:03 werner kernel: ERST: Table is not found!
Jul  8 01:13:03 werner kernel: toshiba: not a supported Toshiba laptop
Jul  8 01:13:03 werner kernel: Compaq SMART2 Driver (v 2.6.0)
Jul  8 01:13:03 werner kernel:  hda3: <minix: hda5 hda6 hda7 >
Jul  8 01:13:03 werner kernel: Loading Adaptec I2O RAID: Version 2.4 Build 5go
Jul  8 01:13:03 werner kernel: scsi: <fdomain> Detection failed (no card)
Jul  8 01:13:03 werner kernel: NCR53c406a: no available ports found
Jul  8 01:13:03 werner kernel: Emulex LightPulse Fibre Channel SCSI driver 8.3.12
Jul  8 01:13:03 werner kernel: Copyright(c) 2004-2009 Emulex.  All rights reserved.
Jul  8 01:13:03 werner kernel: Failed initialization of WD-7000 SCSI card!
Jul  8 01:13:03 werner kernel: GDT-HA: Storage RAID Controller Driver. Version: 3.05
Jul  8 01:13:03 werner kernel: 3ware Storage Controller device driver for Linux v1.26.02.003.
Jul  8 01:13:03 werner kernel: 3ware 9000 Storage Controller device driver for Linux v2.26.02.014.
Jul  8 01:13:03 werner kernel: imm: Version 2.05 (for Linux 2.4.0)
Jul  8 01:13:03 werner kernel: ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 15
Jul  8 01:13:03 werner kernel: Error: Driver 'pata_platform' is already registered, aborting...
Jul  8 01:13:03 werner kernel: mtdoops: mtd device (mtddev=name/number) must be supplied
Jul  8 01:13:03 werner kernel: physmap-flash.0: failed to claim resource 0
Jul  8 01:13:03 werner kernel: Failed to ioremap_nocache
Jul  8 01:13:03 werner last message repeated 2 times
Jul  8 01:13:03 werner kernel: SNAPGEAR: failed to ioremap() BOOTCS
Jul  8 01:13:03 werner kernel: Generic platform RAM MTD, (c) 2004 Simtec Electronics
Jul  8 01:13:03 werner kernel: [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
Jul  8 01:13:03 werner last message repeated 5 times
Jul  8 01:13:03 werner kernel: flash size: 8 MiB
Jul  8 01:13:03 werner kernel: page size: 512 bytes
Jul  8 01:13:03 werner kernel: OOB area size: 16 bytes
Jul  8 01:13:03 werner kernel: sector size: 8 KiB
Jul  8 01:13:03 werner kernel: pages number: 16384
Jul  8 01:13:03 werner kernel: pages per sector: 16
Jul  8 01:13:03 werner kernel: bus width: 8
Jul  8 01:13:03 werner kernel: bits in sector size: 13
Jul  8 01:13:03 werner kernel: bits in page size: 9
Jul  8 01:13:03 werner kernel: bits in OOB size: 4
Jul  8 01:13:03 werner kernel: flash size with OOB: 8448 KiB
Jul  8 01:13:03 werner kernel: page address bytes: 3
Jul  8 01:13:03 werner kernel: sector address bytes: 2
Jul  8 01:13:03 werner kernel: options: 0x62
Jul  8 01:13:03 werner kernel: onenand_wait: timeout! ctrl=0x0000 intr=0x0000
Jul  8 01:13:03 werner kernel: DE600: port 0x378 busy
Jul  8 01:13:03 werner kernel: paride: aten registered as protocol 0
Jul  8 01:13:03 werner kernel: paride: bpck registered as protocol 1
Jul  8 01:13:03 werner kernel: paride: comm registered as protocol 2
Jul  8 01:13:03 werner kernel: paride: dstr registered as protocol 3
Jul  8 01:13:03 werner kernel: paride: k951 registered as protocol 4
Jul  8 01:13:03 werner kernel: paride: k971 registered as protocol 5
Jul  8 01:13:03 werner kernel: paride: epat registered as protocol 6
Jul  8 01:13:03 werner kernel: paride: epia registered as protocol 7
Jul  8 01:13:03 werner kernel: paride: frpw registered as protocol 8
Jul  8 01:13:03 werner kernel: paride: friq registered as protocol 9
Jul  8 01:13:03 werner kernel: paride: fit2 registered as protocol 10
Jul  8 01:13:03 werner kernel: paride: fit3 registered as protocol 11
Jul  8 01:13:03 werner kernel: paride: on20 registered as protocol 12
Jul  8 01:13:03 werner kernel: paride: on26 registered as protocol 13
Jul  8 01:13:03 werner kernel: paride: ktti registered as protocol 14
Jul  8 01:13:03 werner kernel: paride: bpck6 registered as protocol 15
Jul  8 01:13:03 werner kernel: pd: pd version 1.05, major 45, cluster 64, nice 0
Jul  8 01:13:03 werner kernel: pda: Autoprobe failed
Jul  8 01:13:03 werner kernel: pd: no valid drive found
Jul  8 01:13:03 werner kernel: pcd: pcd version 1.07, major 46, nice 0
Jul  8 01:13:03 werner kernel: pcd0: Autoprobe failed
Jul  8 01:13:03 werner kernel: pcd: No CD-ROM drive found
Jul  8 01:13:03 werner kernel: pf: pf version 1.04, major 47, cluster 64, nice 0
Jul  8 01:13:03 werner kernel: pf: No ATAPI disk detected
Jul  8 01:13:03 werner kernel: pt: pt version 1.04, major 96
Jul  8 01:13:03 werner kernel: pt0: Autoprobe failed
Jul  8 01:13:03 werner kernel: pt: No ATAPI tape drive detected
Jul  8 01:13:03 werner kernel: pg: pg version 1.02, major 97
Jul  8 01:13:03 werner kernel: pga: Autoprobe failed
Jul  8 01:13:03 werner kernel: pg: No ATAPI device detected
Jul  8 01:13:03 werner kernel: ACPI: PCI Interrupt Link [LUB2] enabled at IRQ 10
Jul  8 01:13:03 werner kernel: ACPI: PCI Interrupt Link [LUB0] enabled at IRQ 11
Jul  8 01:13:03 werner kernel: GTCO usb driver version: 2.00.0006
Jul  8 01:13:03 werner kernel: EISA: Cannot allocate resource for mainboard
Jul  8 01:13:03 werner kernel: Cannot allocate resource for EISA slot 1
Jul  8 01:13:03 werner kernel: Cannot allocate resource for EISA slot 2
Jul  8 01:13:03 werner kernel: Cannot allocate resource for EISA slot 3
Jul  8 01:13:03 werner kernel: Cannot allocate resource for EISA slot 4
Jul  8 01:13:03 werner kernel: Cannot allocate resource for EISA slot 5
Jul  8 01:13:03 werner kernel: Cannot allocate resource for EISA slot 6
Jul  8 01:13:03 werner kernel: Cannot allocate resource for EISA slot 7
Jul  8 01:13:03 werner kernel: Cannot allocate resource for EISA slot 8
Jul  8 01:13:03 werner kernel: dell-wmi: No known WMI GUID found
Jul  8 01:13:03 werner kernel: This machine doesn't have MSI-hotkeys through WMI
Jul  8 01:13:03 werner kernel: [Firmware Bug]: powernow-k8: No PSB or ACPI _PSS objects
Jul  8 01:13:03 werner kernel: sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
Jul  8 01:13:03 werner kernel: VFS: Mounted root (ext3 filesystem) readonly on device 8:1.
Jul  8 01:13:03 werner kernel: ACPI: PCI Interrupt Link [LNEA] enabled at IRQ 11
Jul  8 01:13:03 werner kernel: ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 11
Jul  8 01:13:03 werner kernel: k8temp 0000:00:18.3: Temperature readouts might be wrong - check erratum #141
Jul  8 01:13:03 werner kernel: ACPI: PCI Interrupt Link [LAZA] enabled at IRQ 11
Jul  8 01:13:03 werner kernel: rt2860sta: module is from the staging directory, the quality is unknown, you have been warned.
Jul  8 01:13:03 werner kernel: EXT3-fs (sda2): warning: maximal mount count reached, running e2fsck is recommended
Jul  8 01:13:03 werner kernel: EXT3-fs (hda1): warning: maximal mount count reached, running e2fsck is recommended
Jul  8 01:13:03 werner kernel: EXT3-fs (sda3): warning: maximal mount count reached, running e2fsck is recommended
Jul  8 01:13:15 werner apcupsd[5127]: apcupsd FATAL ERROR in smartsetup.c at line 171 PANIC! Cannot communicate with UPS via serial port. Please make sure the port specified on the DEVICE directive is correct, and that your cable specification on the UPSCABLE directive is correct. 
Jul  8 01:13:15 werner apcupsd[5127]: apcupsd error shutdown completed
Jul  8 01:13:17 werner hpijs: unable to init hpijs server 
Jul  8 01:13:20 werner udevd[2406]: add_to_rules: unknown key 'MODALIAS' in /etc/udev/rules.d/80-eagle-usb.rules:1
Jul  8 01:13:38 werner kdm_greet[5521]: Can't open default user face


--bound1278563108--


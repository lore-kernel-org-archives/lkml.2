Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794Ab2LVCBi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 21:01:38 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:56474 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775Ab2LVCBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 21:01:21 -0500
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 21 Dec 2012 18:00:58 -0800
X-Google-Sender-Auth: f1V6PIX67myC8tOONxmvq89zeq0
Message-ID: <CA+55aFyd0Wk=hPqiRmk5MMnrwPhse5k1Aih9P-j-Badr7kwhbw@mail.gmail.com>
Subject: Linux 3.8-rc1
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The longest night of the year is upon us (*), and what better thing to
do than get yourself some nice mulled wine, sit back, relax, and play
with the most recent rc kernel?

This has been a big merge window: we've got more commits than any
other kernel in the v3.x kernel series (although v3.2-rc1 was *almost*
as big). It's been a rather busy merge window, in other words.

The diffstat looks normal: about 63% of the patch being to drivers
(staging, networking, scsi, gpu, sound, drbd etc) , 18% architecture
updates (with various ARM platform things being the bulk of it as
usual, sigh), and the rest being "various", like core networking,
filesystems (new f2fs flash-optimized filesystem) and include files
etc.

I'm appending the "merge shortlog" which is about the only half-way
readable automated data I can give you. There's a *ton* of stuff here.
Go out and test it,

              Linus

(*) And by "us" I mean mainly people in the same timezone and
hemisphere as I am. Because I'm too self-centered to care about
anybody else.

---

Alasdair G Kergon
 - dm update

Alex Williamson
 - vfio update

Al Viro
 - big execve/kernel_thread/fork unification series
 - signal handling cleanups
 - VFS update

Andrew Morton
 - misc patches
 - misc updates
 - misc VM changes
 - patches

Anton Vorontsov
 - battery subsystem updates
 - battery update, part 2
 - pstore update

Arnd Bergmann
 - asm-generic cleanup

Artem Bityutskiy
 - UBI update

Benjamin Herrenschmidt
 - powerpc update

Ben Myers
 - xfs update

Bjorn Helgaas
 - PCI update

Boaz Harrosh
 - exofs changes

Bob Liu
 - blackfin update

Borislav Petkov
 - EDAC fixes

Bruce Fields
 - nfsd update

Bryan Wu
 - LED subsystem update

Catalin Marinas
 - ARM64 updates

Chris Ball
 - MMC updates

Chris Mason
 - btrfs update
 - two btrfs reverts

Chris Metcalf
 - tile updates

Chris Zankel
 - Xtensa patchset

Dave Airlie
 - drm bugfix
 - DRM updates

David Howells
 - MN10300 changes
 - UAPI disintegration for Alpha
 - UAPI disintegration for H8/300, M32R and Score
 - x86 UAPI disintegration

David Miller
 - networking changes
 - networking fixes
 - networking fixes
 - sparc fixes
 - tiny sparc update

David Teigland
 - dlm updates

David Woodhouse
 - MTD updates
 - preparatory gcc intrisics bswap patch

Dmitry Torokhov
 - second round of input updates

Eric Biederman
 - user namespace changes
 - (again) user namespace infrastructure changes

Eric Paris
 - filesystem notification updates

Geert Uytterhoeven
 - m68k updates

Grant Likely
 - another devicetree update
 - device tree changes
 - devicetree, gpio and spi bugfixes
 - GPIO updates
 - irqdomain changes
 - SPI updates

Greg Kroah-Hartman
 - Char/Misc driver merge
 - driver core updates
 - EXTCON patches
 - staging driver tree merge
 - TTY/Serial merge
 - USB patches

Greg Ungerer
 - m68knommu updates

Guenter Roeck
 - hwmon fixlet
 - hwmon updates

Herbert Xu
 - crypto update

Ian Kent
 - emailed autofs cleanup/fix patches

Ingo Molnar
 - core timer changes
 - irq fixes
 - "Nuke 386-DX/SX support"
 - perf fixes
 - perf updates
 - RCU update
 - scheduler updates
 - trivial fix branches
 - x86 asm changes
 - x86 boot changes
 - x86 BSP hotplug changes
 - x86 cleanups
 - x86 RAS update
 - x86 timer update
 - x86 topology discovery improvements

Jaegeuk Kim
 - new F2FS filesystem

James Bottomley
 - first round of SCSI updates

James Morris
 - security subsystem updates

Jan Kara
 - ext3, udf, quota fixes

Jean Delvare
 - hwmon subsystem update
 - i2c update

Jeff Garzik
 - libata updates

Jens Axboe
 - block driver update
 - block layer core updates

Jesper Nilsson
 - CRIS changes

Jiri Kosina
 - HID subsystem updates
 - trivial branch

Joerg Roedel
 - IOMMU updates

Jonas Bonn
 - OpenRISC update

Konrad Rzeszutek Wilk
 - swiotlb update
 - Xen bugfixes
 - Xen updates

Len Brown
 - powertool update

Linus Walleij
 - pinctrl changes

Marcelo Tosatti
 - KVM updates

Marek Szyprowski
 - CMA and DMA-mapping update

Mark Brown
 - regmap updates
 - regulator updates

Martin Schwidefsky
 - s390 update
 - s390 update #2

Mauro Carvalho Chehab
 - media updates

Mel Gorman
 - Automatic NUMA Balancing bare-bones

Michal Marek
 - kbuild changes
 - kbuild misc changes

Michal Simek
 - microblaze update

Mike Turquette
 - clock framework changes

Neil Brown
 - md update

Nicholas Bellinger
 - target updates

Olof Johansson
 - ARM SoC board updates
 - ARM SoC board updates, take 2
 - ARM SoC cleanups on various subarchitectures
 - ARM SoC device tree conversions and enablement
 - ARM SoC device-tree updates, take 2,
 - ARM SoC driver specific changes
 - ARM SoC fixes
 - ARM SoC fixes part 2
 - ARM SoC Header cleanups
 - ARM SoC multiplatform conversion patches
 - ARM SoC Non-critical bug fixes
 - ARM SoC power management and clock changes
 - ARM SoC updates
 - ARM SoC updates for Marvell mvebu/kirkwood
 - ARM Soc updates, take 2,

Pekka Enberg
 - SLAB changes

Peter Anvin
 - one final 386 removal patch
 - small x86 fixes
 - x86 ACPI update
 - x86 EFI update

Rafael Wysocki
 - ACPI and power management updates

Ralf Baechle
 - MIPS updates

Roland Dreier
 - infiniband upate
 - more infiniband changes

Russell King
 - ARM fixes
 - ARM OMAP serial updates
 - ARM updates

Rusty Russell
 - module update
 - virtio update

Sage Weil
 - Ceph update

Samuel Ortiz
 - MFS update

Stefan Richter
 - IEEE 1394 (FireWire) subsystem updates

Steve French
 - CIFS fixes
 - CIFS fixes

Steven Rostedt
 - ktest update
 - minor tracing updates and fixes

Steven Whitehouse
 - GFS2 updates

Sumit Semwal
 - dma-buf updates

Takashi Iwai
 - sound fixes
 - sound updates

Ted Ts'o
 - ext4 update
 - random updates

Tejun Heo
 - cgroup changes
 - percpu changes
 - workqueue changes

Thierry Reding
 - pwm changes

Tomi Valkeinen
 - fbdev changes

Tony Luck
 - ACPI5 error injection fix
 - ia64 fix
 - pstore fixes

Trond Myklebust
 - NFS client updates

Wim Van Sebroeck
 - watchdog updates

Wolfram Sang
 - i2c-embedded changes

Zhang Rui
 - thermal management update

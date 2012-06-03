Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063Ab2FCSHm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 14:07:42 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:55636 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204Ab2FCSHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 14:07:41 -0400
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 3 Jun 2012 11:07:19 -0700
X-Google-Sender-Auth: 2IHbSGT6x6aYMWZD6USfk2uduE8
Message-ID: <CA+55aFz6R-pnKeDg9Uiufd8-PYWoEgFRv4Ho_L8rnGMDq061LQ@mail.gmail.com>
Subject: Linux 3.5-rc1
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So I released it yesterday but didn't write a message about it because
I didn't feel up to it.

It's a pretty normal release - roughly 60% drivers, 20% arch updates,
and 20% "all over" - filesystems, documentation, tools, you name it.

Nothing hugely special springs to mind - there's some memory
compaction issue that is still being discussed, but I don't think
there's anything particularly scary or special that stands out over
everything else in the -rc1.

Appended is my "merge shortlog" - largely automatically generated from
my merge messages. There's probably a few merges missing just because
it's generated from my free-form messages that *tend* to have a
particular format, but if I screwed up somewhere it won't necessarily
have triggered my grep. Also note that the "from xyz" is about who
sent me the pull request, not who coded it (and some trees - arm-soc
and x86 in particular - tend to have multiple maintainers too, and so
the person who sends me the pull request is not necessariyl the sole
proprietor of the tree, just the "point man").

Depending on what your interest is, you might be excited about the
CoDel packet scheduler, or about the GPU driver updates, or the new
scsi targets. There is something in here for pretty much anybody.

          Linus

---

 - networking changes from David Miller
 - sparc updates from David Miller
 - s390 updates from Martin Schwidefsky
 - m68k updates from Geert Uytterhoeven
 - c6x updates from Mark Salter
 - blackfin changes from Bob Liu
 - clkdev updates from Russell King
 - core ARM updates from Russell King
 - PCI changes from Bjorn Helgaas
 - regmap updates from Mark Brown
 - regulator updates from Mark Brown
 - pin control subsystem changes from Linus Walleij
 - OpenRISC updates from Jonas Bonn
 - scsi-target changes from Nicholas Bellinger
 - usb-gadget scsi-target merge from Nicholas Bellinger
 - SCSI misc update from James Bottomley
 - InfiniBand/RDMA changes from Roland Dreier
 - m68knommu tree from Greg Ungerer
 - GFS2 changes from Steven Whitehouse
 - core/debugobjects changes from Ingo Molnar
 - iommu core changes from Ingo Molnar
 - core locking updates from Ingo Molnar
 - RCU changes from Ingo Molnar
 - smp hotplug cleanups from Thomas Gleixner
 - virtio updates from Rusty Russell
 - security subsystem updates from James Morris
 - core irq changes from Ingo Molnar
 - ktest updates from Steven Rostedt
 - arm-soc updates for MAINTAINERS file from Olof Johansson
 - first batch of arm-soc cleanups from Olof Johansson
 - non-critical arm-soc bug fixes from Olof Johansson
 - device tree conversions for arm-soc, part 1, from Olof Johansson
 - support for new arm SoCs from Olof Johansson
 - arm soc-specific pinctrl changes from Olof Johansson
 - arm-soc power management changes from Olof Johansson
 - arm-soc board specific changes from Olof Johansson
 - USB 3.5-rc1 changes from Greg Kroah-Hartman
 - Char/Misc patches from Greg Kroah-Hartman
 - driver core updates from Greg Kroah-Hartman
 - TTY updates from Greg Kroah-Hartman
 - staging tree changes from Greg Kroah-Hartman
 - workqueue changes from Tejun Heo
 - percpu updates from Tejun Heo
 - cgroup updates from Tejun Heo
 - perf changes from Ingo Molnar
 - scheduler changes from Ingo Molnar
 - x86/apic changes from Ingo Molnar
 - HID subsystem updates from Jiri Kosina
 - trivial updates from Jiri Kosina
 - UBI and UBIFS updates from Artem Bityutskiy
 - dlm updates from David Teigland
 - SuperH updates from Paul Mundt
 - UML updates from Richard Weinberger
 - powerpc updates from Benjamin Herrenschmidt
 - Hexagon architecture changes from Richard Kuo
 - initial trivial x86 stuff from Ingo Molnar
 - x86/urgent branch from Ingo Molnar
 - x86 EFI updates from Ingo Molnar
 - exception table generation updates from Ingo Molnar
 - fpu state cleanups from Ingo Molnar
 - MCE updates from Ingo Molnar
 - x86 mm changes from Ingo Molnar
 - x86 platform changes from Ingo Molnar
 - x86 reboot changes from Ingo Molnar
 - Itanium fixes from Tony Luck
 - perf fixes from Ingo Molnar
 - trivial ktest spelling fix from Steven Rostedt
 - sound updates from Takashi Iwai
 - a regmap kconfig dependency fix from Mark Brown
 - power management updates from Rafael Wysocki
 - hwmon updates from Guenter Roeck
 - libata update from Jeff Garzik
 - first set of watchdog updates from Wim Van Sebroeck
 - crypto updates from Herbert Xu
 - sbp-2 (firewire) target mode support from Nicholas Bellinger
 - md updates from NeilBrown
 - the MCA deletion branch from Paul Gortmaker
 - module patches from Rusty Russell, who really sells them
 - user namespace enhancements from Eric Biederman
 - first series of signal handling cleanups from Al Viro
 - media updates from Mauro Carvalho Chehab
 - input layer updates from Dmitry Torokhov
 - user-space probe instrumentation from Ingo Molnar
 - more networking updates from David Miller
 - main drm updates from Dave Airlie
 - IEEE 1394 (FireWire) subsystem updates from Stefan Richter
 - timer updates from Thomas Gleixner
 - alpha updates from Matt Turner
 - irqdomain changes from Grant Likely
 - SPI changes from Grant Likely
 - device tree changes from Grant Likely
 - GPIO driver changes from Grant Likely
 - more relocation fixes from Peter Anvin
 - XFS update from Ben Myers
 - sparc changes from David S. Miller
 - Xen updates from Konrad Rzeszutek Wilk
 - KVM changes from Avi Kivity
 - ext2, ext3 and quota fixes from Jan Kara
 - MMC changes from Chris Ball
 - CRIS changes from Jesper Nilsson
 - VGA-switcheroo audio client support for HD-audio from Takashi Iwai
 - sound update from Takashi Iwai
 - CMA and ARM DMA-mapping updates from Marek Szyprowski
 - slave-dmaengine updates from Vinod Koul
 - dma-buf updates from Sumit Semwal
 - tile updates from Chris Metcalf
 - x86/mce merge window patches from Tony Luck
 - arm-soc defconfig updates from Olof Johansson
 - arm-soc driver specific updates from Olof Johansson
 - arm-soc cleanups (part 2) from Olof Johansson
 - arm-soc clock driver changes from Olof Johansson
 - arm-soc stmp-dev library code from Olof Johansson
 - arm-soc device tree conversions (part 2) from Olof Johansson
 - arm-soc: soc specific changes (part 2) from Olof Johansson
 - sweeping late_initcall cleanup for arm-soc from Olof Johansson
 - i2c-embedded changes from Wolfram Sang
 - microblaze changes from Michal Simek
 - writeback tree from Wu Fengguang
 - kbuild updates from Michal Marek
 - kconfig changes from Michal Marek
 - misc kbuild changes from Michal Marek
 - documentation updates from Jiri Kosina
 - exofs updates from Boaz Harrosh
 - NFS client updates from Trond Myklebust
 - MFD changes from Samuel Ortiz
 - CIFS updates from Steve French
 - arm updates from Russell King
 - MIPS updates from Ralf Baechle
 - EDAC internal API changes from Mauro Carvalho Chehab
 - x86 trampoline rework from H. Peter Anvin
 - IOMMU updates from Joerg Roedel
 - block/IO core bits from Jens Axboe
 - block driver updates from Jens Axboe
 - drm fixes from Dave Airlie
 - second set of watchdog updates from Wim Van Sebroeck
 - i2c updates from Jean Delvare
 - perf updates from Ingo Molnar
 - ceph updates from Sage Weil
 - networking changes from David S. Miller
 - Sparc updates from David S. Miller
 - late-merged development and first fixes for arm-soc from Olof Johansson
 - additional x86 fixes from Peter Anvin
 - misc parisc updates from James Bottomley
 - s390 patches from Heiko Carstens
 - mce cleanup from Tony Luck
 - follow-up block updates from Jens Axboe
 - final round of SCSI updates from James Bottomley
 - two small kvm fixes from Avi Kivity
 - battery updates from Anton Vorontsov
 - drm prime mmap/vmap code from Dave Airlie
 - misc patches from Andrew Morton
 - nfsd update from Bruce Fields
 - second pile of signal handling patches from Al Viro
 - the rest of the nfsd commits from Bruce Fields
 - btrfs updates from Chris Mason
 - Ext4 updates from Theodore Ts'o
 - vfs changes from Al Viro
 - third pile of signal handling patches from Al Viro
 - sound fixes from Takashi Iwai
 - drm fixes from Dave Airlie
 - arm fixes for ux500 mismerge mishap from Arnd Bergmann
 - slab updates from Pekka Enberg
 - x86 platform driver updates from Matthew Garrett
 - mtd update from David Woodhouse
 - fbdev updates from Florian Tobias Schandinat
 - fixups for the mac NLS tables from Andrew
 - vfs fix and a fix from the signal changes for frv from Al Viro
 - straggler x86 fixes from Peter Anvin
 - networking updates from David Miller
 - device-mapper updates from Alasdair G Kergon

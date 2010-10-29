Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759034Ab0J2BMF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 21:12:05 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:53780 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754444Ab0J2BL5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 21:11:57 -0400
Date: Fri, 29 Oct 2010 12:11:48 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for October 29
Message-Id: <20101029121148.d27e03bc.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__29_Oct_2010_12_11_48_+1100_SeHVyWPc=K_ZyJsz"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__29_Oct_2010_12_11_48_+1100_SeHVyWPc=K_ZyJsz
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

The linux-next releases may be erratic at best over the next week or so
while I am traveling.

Reminder: do not add 2.6.38 destined stuff to linux-next until after
2.6.37-rc1 is released.

Reminder 2: if what you ask Linus to merge turns out to be a little
different from what you have in linux-next (or Linus' fixes things up a
little), please updtae your linux-next submission so I don't have to
worry about those differences.

Changes since 20101028:

The s5p tree lost its conflict.

The genesis tree lost its conflict.

The ext4 tree lost its conflicts.

The mfd tree lost its conflicts.

The fsnotify tree lost its conflict.

The xen-pvhvm tree gained a conflict against the xen tree.

The driver-core tree lost its conflict.

The usb tree lost its conflicts.

The staging-next tree lost its conflicts.

----------------------------------------------------------------------------

I have created today's linux-next tree at
git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
(patches at http://www.kernel.org/pub/linux/kernel/v2.6/next/ ).  If you
are tracking the linux-next tree using git, you should not use "git pull"
to do so as that will try to merge the new linux-next release with the
old one.  You should use "git fetch" as mentioned in the FAQ on the wiki
(see below).

You can see which trees have been included by looking in the Next/Trees
file in the source.  There are also quilt-import.log and merge.log files
in the Next directory.  Between each merge, the tree was built with
a ppc64_defconfig for powerpc and an allmodconfig for x86_64. After the
final fixups (if any), it is also built with powerpc allnoconfig (32 and
64 bit), ppc44x_defconfig and allyesconfig (minus
CONFIG_PROFILE_ALL_BRANCHES - this fails its final link) and i386, sparc
and sparc64 defconfig. These builds also have
CONFIG_ENABLE_WARN_DEPRECATED, CONFIG_ENABLE_MUST_CHECK and
CONFIG_DEBUG_INFO disabled when necessary.

Below is a summary of the state of the merge.

We are up to 176 trees (counting Linus' and 22 trees of patches pending
for Linus' tree), more are welcome (even if they are currently empty).
Thanks to those who have contributed, and to those who haven't, please do.

Status of my local build tests will be at
http://kisskb.ellerman.id.au/linux-next .  If maintainers want to give
advice about cross compilers/configs that work, we are always open to add
more builds.

Thanks to Randy Dunlap for doing many randconfig builds.

There is a wiki covering stuff to do with linux-next at
http://linux.f-seidel.de/linux-next/pmwiki/ .  Thanks to Frank Seidel.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

$ git checkout master
$ git reset --hard stable
Merging origin/master
Merging fixes/fixes
Merging arm-current/master
Merging m68k-current/for-linus
Merging powerpc-merge/merge
Merging sparc-current/master
Merging scsi-rc-fixes/master
Merging net-current/master
Merging sound-current/for-linus
Merging pci-current/for-linus
Merging wireless-current/master
Merging kbuild-current/rc-fixes
Merging quilt/driver-core.current
Merging quilt/tty.current
Merging quilt/usb.current
Merging quilt/staging.current
Merging cpufreq-current/fixes
Merging input-current/for-linus
Merging md-current/for-linus
Merging audit-current/for-linus
Merging crypto-current/master
Merging ide-curent/master
Merging dwmw2/master
Merging gcl-current/merge
Merging arm/devel
Merging davinci/davinci-next
Merging i.MX/for-next
Merging msm/for-next
Merging omap/for-next
Merging pxa/for-next
Merging samsung/next-samsung
Merging s5p/for-next
Merging tegra/for-next
Merging avr32/avr32-arch
Merging blackfin/for-linus
Merging cris/for-next
Merging ia64/test
Merging m68k/for-next
Merging m68knommu/for-next
Merging microblaze/next
Merging mips/mips-for-linux-next
CONFLICT (content): Merge conflict in drivers/usb/host/Kconfig
CONFLICT (content): Merge conflict in drivers/usb/host/Makefile
Merging parisc/next
Merging powerpc/next
Merging 4xx/next
Merging 52xx-and-virtex/next
Merging galak/next
Merging s390/features
Merging sh/master
Merging genesis/master
Merging sparc/master
Merging tile/master
Merging xtensa/master
CONFLICT (content): Merge conflict in arch/xtensa/configs/iss_defconfig
Merging ceph/for-next
Merging cifs/master
Merging configfs/linux-next
Merging ecryptfs/next
Merging ext3/for_next
Merging ext4/next
Merging fatfs/master
Merging fuse/for-next
Merging gfs2/master
Merging hfsplus/for-next
Merging jfs/next
Merging logfs/master
CONFLICT (content): Merge conflict in fs/logfs/logfs.h
Merging nfs/linux-next
Merging nfsd/nfsd-next
Merging nilfs2/for-next
Merging ocfs2/linux-next
Merging omfs/for-next
Merging squashfs/master
Merging udf/for_next
Merging v9fs/for-next
Merging ubifs/linux-next
Merging xfs/master
Merging vfs/for-next
Merging pci/linux-next
Merging hid/for-next
Merging quilt/i2c
Merging bjdooks-i2c/next-i2c
Merging quilt/jdelvare-hwmon
Merging hwmon-staging/hwmon-next
Merging quilt/kernel-doc
CONFLICT (content): Merge conflict in lib/idr.c
Merging v4l-dvb/master
Merging kbuild/for-next
Merging kconfig/for-next
Merging ide/master
Merging libata/NEXT
Merging infiniband/for-next
Merging acpi/test
Merging idle-test/idle-test
Merging ieee1394/for-next
Merging ubi/linux-next
Merging kvm/linux-next
Merging dlm/next
Merging swiotlb/master
Merging ibft/master
Merging scsi/master
Merging async_tx/next
Merging net/master
Merging wireless/master
Merging bluetooth/master
Merging mtd/master
CONFLICT (content): Merge conflict in drivers/mtd/mtd_blkdevs.c
Merging crypto/master
Merging sound/for-next
Merging sound-asoc/for-next
Merging cpufreq/next
Merging quilt/rr
Merging input/next
Merging lsm/for-next
Merging block/for-next
CONFLICT (content): Merge conflict in fs/ocfs2/file.c
Merging quilt/device-mapper
Merging embedded/master
Merging firmware/master
Merging pcmcia/master
Merging battery/master
Merging leds/for-mm
Merging backlight/for-mm
Merging mmc/mmc-next
Merging kgdb/kgdb-next
Merging slab/for-next
Merging uclinux/for-next
Merging md/for-next
Merging mfd/for-next
Merging hdlc/hdlc-next
Merging drm/drm-next
Merging viafb/viafb-next
Merging voltage/for-next
CONFLICT (rename/add): Rename arch/arm/mach-s5p6440/include/mach/dma.h->inc=
lude/linux/regulator/lp3972.h in HEAD. include/linux/regulator/lp3972.h add=
ed in voltage/for-next
Merging security-testing/next
Merging lblnet/master
Merging agp/agp-next
Merging watchdog/master
CONFLICT (add/add): Merge conflict in drivers/watchdog/bcm63xx_wdt.c
CONFLICT (content): Merge conflict in drivers/watchdog/iTCO_wdt.c
Merging bdev/master
Merging dwmw2-iommu/master
Merging cputime/cputime
Merging osd/linux-next
Merging jc_docs/docs-next
Merging nommu/master
Merging trivial/for-next
Merging audit/for-next
Merging quilt/aoe
Merging suspend/linux-next
Merging fsnotify/for-next
Merging irda/for-next
Merging catalin/for-next
CONFLICT (content): Merge conflict in arch/arm/kernel/Makefile
CONFLICT (content): Merge conflict in arch/arm/mach-vexpress/ct-ca9x4.c
CONFLICT (content): Merge conflict in arch/arm/mm/flush.c
CONFLICT (content): Merge conflict in arch/arm/mm/mmu.c
Merging alacrity/linux-next
CONFLICT (content): Merge conflict in include/linux/Kbuild
Merging i7core_edac/linux_next
Merging i7300_edac/linux_next
Merging devicetree/next-devicetree
Merging spi/next-spi
Merging omap_dss2/for-next
Merging tip/auto-latest
Merging rcu/rcu/next
Merging oprofile/for-next
Merging xen/upstream/xen
CONFLICT (content): Merge conflict in arch/x86/xen/mmu.c
Merging swiotlb-xen/master
CONFLICT (content): Merge conflict in arch/x86/include/asm/io_apic.h
CONFLICT (content): Merge conflict in drivers/pci/Makefile
Merging xen-pvhvm/linux-next
CONFLICT (content): Merge conflict in arch/x86/xen/setup.c
Merging edac-amd/for-next
Merging percpu/for-next
Merging workqueues/for-next
Merging sfi/sfi-test
Merging asm-generic/next
Merging drivers-x86/linux-next
Merging hwpoison/hwpoison
Merging sysctl/master
Merging quilt/driver-core
Merging quilt/tty
Merging quilt/usb
Merging staging-next/staging-next
Merging slabh/slabh
Merging bkl-trivial/trivial
Merging bkl-llseek/llseek
Merging bkl-vfs/vfs
Merging bkl-config/config
Merging irqflags/master
Merging cleancache/linux-next
CONFLICT (content): Merge conflict in include/linux/fs.h
CONFLICT (content): Merge conflict in mm/Kconfig
Merging scsi-post-merge/merge-base:master

--Signature=_Fri__29_Oct_2010_12_11_48_+1100_SeHVyWPc=K_ZyJsz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMyh9UAAoJEDMEi1NhKgbsh98H/Akz/eDrlt6//Pgsp2k8aOuV
nNAWliU/Xz3IaNLZkQpWnTsnQ0rmRkY/OD8b0isCsapY2FuQViIje1LnGjXmfYUD
9IS/z89doL7FAGcmhhFtCBWsc49LUcEshWJ/980iZEim8WL8D94F1Hs7+mQkv60P
KZMNv0oPl2P4FyU6YwW1IFdOtmk/o+DD8/MdJoVYgsWeU/7KNoQsC4+wENxnays0
eweJY7Qez/EDCa4dQjXzkpIBE/fQ3hS+2pjEXpGB9bqglwbpgi++WYJbE0JXsAo5
S+4vhIysa3bQ+dvAEAtYn4hzCqJXnjhNDTYf/GvlrZ7EDlcJOa7BY7untfriUHo=
=LB9b
-----END PGP SIGNATURE-----

--Signature=_Fri__29_Oct_2010_12_11_48_+1100_SeHVyWPc=K_ZyJsz--

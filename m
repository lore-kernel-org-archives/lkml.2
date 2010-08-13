Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761306Ab0HMDN5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 23:13:57 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:48262 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750897Ab0HMDNx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 23:13:53 -0400
Date: Fri, 13 Aug 2010 13:13:47 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for August 13
Message-Id: <20100813131347.1938f349.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__13_Aug_2010_13_13_47_+1000_7h4jQ_xn9zud8QWn"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__13_Aug_2010_13_13_47_+1000_7h4jQ_xn9zud8QWn
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

As the merge window is open, please do not add 2.6.37 material to your
linux-next included trees until after 2.6.36-rc1.

Changes since 20100812:

The ceph tree gained a conflict against Linus' tree.

The cifs tree lost its build failure.

The ocfs2 tree gained a conflict against Linus' tree.

The acpi tree gained a build failure for which I applied a patch.

The swiotlb-xen tree lost its conflicts.

The rr tree lost its merge fix patches.

The battery tree lost its conflicts.

The mfd tree lost its conflict.

the hwpoison tree lost its conflict.

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

We are up to 169 trees (counting Linus' and 22 trees of patches pending
for Linus' tree), more are welcome (even if they are currently empty).
Thanks to those who have contributed, and to those who haven't, please do.

Status of my local build tests will be at
http://kisskb.ellerman.id.au/linux-next .  If maintainers want to give
advice about cross compilers/configs that work, we are always open to add
more builds.

Thanks to Jan Dittmer for adding the linux-next tree to his build tests
at http://l4x.org/k/ , the guys at http://test.kernel.org/ and Randy
Dunlap for doing many randconfig builds.

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
CONFLICT (content): Merge conflict in arch/arm/mach-s3c64xx/Makefile
CONFLICT (content): Merge conflict in arch/arm/mach-s3c64xx/mach-smdk6410.c
CONFLICT (content): Merge conflict in arch/arm/plat-samsung/Kconfig
CONFLICT (content): Merge conflict in drivers/input/touchscreen/s3c2410_ts.c
Merging s5p/for-next
Merging tegra/for-next
CONFLICT (content): Merge conflict in arch/arm/Kconfig
CONFLICT (content): Merge conflict in arch/arm/mm/Kconfig
Merging avr32/avr32-arch
Merging blackfin/for-linus
Merging cris/for-next
Merging ia64/test
Merging m68k/for-next
Merging m68knommu/for-next
Merging microblaze/next
Merging mips/mips-for-linux-next
Merging parisc/next
Merging powerpc/next
Merging 4xx/next
Merging 52xx-and-virtex/next
Merging galak/next
Merging s390/features
Merging sh/master
CONFLICT (content): Merge conflict in drivers/Makefile
Merging genesis/master
Merging sparc/master
Merging tile/master
Merging xtensa/master
CONFLICT (content): Merge conflict in arch/xtensa/configs/iss_defconfig
Merging ceph/for-next
CONFLICT (content): Merge conflict in net/Makefile
Merging cifs/master
Merging configfs/linux-next
Merging ecryptfs/next
Merging ext3/for_next
Merging ext4/next
Merging fatfs/master
Merging fuse/for-next
Merging gfs2/master
Merging jfs/next
Merging logfs/master
CONFLICT (content): Merge conflict in fs/logfs/logfs.h
Merging nfs/linux-next
Merging nfsd/nfsd-next
Merging nilfs2/for-next
Merging ocfs2/linux-next
CONFLICT (content): Merge conflict in fs/ocfs2/file.c
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
Merging quilt/kernel-doc
CONFLICT (content): Merge conflict in Documentation/kernel-parameters.txt
Merging v4l-dvb/master
CONFLICT (content): Merge conflict in drivers/media/video/cx23885/Kconfig
CONFLICT (add/add): Merge conflict in drivers/media/video/v4l2-ctrls.c
Applying: v4l-dvb: fix up bad automatic merge
Merging kbuild/for-next
Merging kconfig/for-next
Merging ide/master
Merging libata/NEXT
Merging infiniband/for-next
Merging acpi/test
Applying: acpi: using copy_from_user needs linux/uaccess.h
Merging idle-test/idle-test
Merging ieee1394/for-next
Merging ubi/linux-next
Merging kvm/linux-next
Merging dlm/next
Merging swiotlb/master
Merging swiotlb-xen/master
Merging ibft/master
Merging scsi/master
Merging async_tx/next
Merging net/master
Merging wireless/master
Merging mtd/master
Merging crypto/master
Merging sound/for-next
Merging cpufreq/next
Merging quilt/rr
CONFLICT (content): Merge conflict in arch/um/drivers/hostaudio_kern.c
CONFLICT (content): Merge conflict in drivers/acpi/debug.c
CONFLICT (content): Merge conflict in drivers/block/virtio_blk.c
CONFLICT (content): Merge conflict in kernel/module.c
Merging input/next
Merging lsm/for-next
Merging block/for-next
Merging quilt/device-mapper
Merging embedded/master
Merging firmware/master
Merging pcmcia/master
Merging battery/master
Merging leds/for-mm
Merging backlight/for-mm
Merging kgdb/kgdb-next
Merging slab/for-next
Merging uclinux/for-next
Merging md/for-next
Merging mfd/for-next
Merging hdlc/hdlc-next
Merging drm/drm-next
Merging viafb/viafb-next
Merging voltage/for-next
Merging security-testing/next
Merging lblnet/master
Merging agp/agp-next
Merging uwb/for-upstream
Merging watchdog/master
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
Merging bluetooth/master
Merging fsnotify/for-next
Merging irda/for-next
CONFLICT (content): Merge conflict in drivers/net/irda/irda-usb.c
Merging catalin/for-next
Merging alacrity/linux-next
Merging i7core_edac/linux_next
CONFLICT (content): Merge conflict in MAINTAINERS
Merging devicetree/next-devicetree
Merging spi/next-spi
CONFLICT (content): Merge conflict in drivers/spi/mpc512x_psc_spi.c
Applying: spi: update for of_device to platform_device replacement
Merging limits/writable_limits
Merging omap_dss2/for-next
Merging xen/upstream/xen
Merging tip/auto-latest
Merging lost-spurious-irq/lost-spurious-irq
CONFLICT (content): Merge conflict in drivers/ata/sata_fsl.c
CONFLICT (content): Merge conflict in drivers/ata/sata_mv.c
CONFLICT (content): Merge conflict in drivers/ata/sata_nv.c
CONFLICT (content): Merge conflict in include/linux/libata.h
Merging edac-amd/for-next
Merging oprofile/for-next
Merging percpu/for-next
Merging workqueues/for-next
Merging sfi/sfi-test
Merging asm-generic/next
Merging drivers-x86/linux-next
Merging hwpoison/hwpoison
Merging sysctl/master
Merging bkl-core/bkl/core
Merging bkl-procfs/bkl/procfs
Merging bkl-ioctl/bkl/ioctl
Merging quilt/driver-core
Merging quilt/tty
Merging quilt/usb
Merging staging-next/staging-next
Merging slabh/slabh
Merging scsi-post-merge/merge-base:master
$ git checkout scsi-post-merge/master

--Signature=_Fri__13_Aug_2010_13_13_47_+1000_7h4jQ_xn9zud8QWn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMZLhrAAoJEDMEi1NhKgbsy9gH/2gkGu0zhIws5uVTN0ykA7ag
fjszyDw7ZFuoIXOT4eJEGZ07uQUV4T0TJXCoKh4Gae29ZNnmybCOae0GXLlyA5m7
hBBdZ5R0FneRYtbGbZnuJunTJts5/dKaQ6N3h/6nYYkSE8e7E+xB7Z6mK6E8pX8j
dGce9OYdHPTwOR1wRPm+5Uv9/8644NvZmACjzHb0kTJOrTvt5le1pSy8XHIUSxYs
Ac1yy32bwigQO5frZjap+ngyGzrDmwHJf/tjox4/O6UIV4XWW1Xiw81xoPj8UQ5U
spTmO6i5OIjTSgV8t3EU9jk7sOIVNTBqZI7x/Q47hhNuSmIid/qd+YWuo1Y8YeU=
=SDk/
-----END PGP SIGNATURE-----

--Signature=_Fri__13_Aug_2010_13_13_47_+1000_7h4jQ_xn9zud8QWn--

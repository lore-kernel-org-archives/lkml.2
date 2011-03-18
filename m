Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756466Ab1CRIuc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 04:50:32 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:53670 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756414Ab1CRIu0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 04:50:26 -0400
Date: Fri, 18 Mar 2011 19:50:13 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for March 18
Message-Id: <20110318195013.9ea3ef04.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__18_Mar_2011_19_50_13_+1100_XtfnwMH=S.aypoYd"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__18_Mar_2011_19_50_13_+1100_XtfnwMH=S.aypoYd
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Reminder: no not add any of your changes for v2.6.40 to your linux-next
included branches until after v2.6.39-rc1 is released.

Lots of conflicts are rising to the top :-)

Changes since 20110317:

Removed tree: catalin (will be coming back later)
=20
Dropped tree: xen

Linus' tree gained a build failure for which I reverted a merge.

The powerpc tree lost a build failure.

The tile tree gained a conflict against Linus' tree.

The kbuild tree gained a conflict against the hwmon-staging tree.

The block tree lost a build failure.

The drm tree lost its build failure.

The spi tree gained a conflict against the mfd tree.

The tty tree lost its conflicts.

The usb tree lost its conflicts.

The staging tree lost its conflicts.

The powerpc allyesconfig build is still broken by some obscure bloating
of the low memory code.

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

We are up to 183 trees (counting Linus' and 28 trees of patches pending
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
Merging kbuild-current/rc-fixes
Merging arm-current/master
Merging m68k-current/for-linus
Merging powerpc-merge/merge
Merging 52xx-and-virtex-current/powerpc/merge
Merging sparc-current/master
Merging scsi-rc-fixes/master
Merging net-current/master
Merging sound-current/for-linus
Merging pci-current/for-linus
Merging wireless-current/master
Merging driver-core.current/driver-core-linus
Merging tty.current/tty-linus
Merging usb.current/usb-linus
Merging staging.current/staging-linus
Merging cpufreq-current/fixes
Merging input-current/for-linus
Merging md-current/for-linus
Merging audit-current/for-linus
Merging crypto-current/master
Merging ide-curent/master
Merging dwmw2/master
Merging sh-current/sh-fixes-for-linus
Merging rmobile-current/rmobile-fixes-for-linus
Merging fbdev-current/fbdev-fixes-for-linus
Merging devicetree-current/devicetree/merge
Merging spi-current/spi/merge
[master d83942d] Revert "Pull pstorev4 into release branch"
Merging arm/for-next
CONFLICT (content): Merge conflict in drivers/video/Kconfig
Merging davinci/davinci-next
Merging i.MX/for-next
CONFLICT (content): Merge conflict in arch/arm/mach-mxs/mach-mx28evk.c
Merging linux-spec/for-next
Merging msm/for-next
CONFLICT (content): Merge conflict in arch/arm/mach-msm/board-msm7x27.c
CONFLICT (content): Merge conflict in arch/arm/mach-msm/board-msm7x30.c
CONFLICT (content): Merge conflict in arch/arm/mach-msm/board-qsd8x50.c
CONFLICT (content): Merge conflict in arch/arm/mach-msm/board-sapphire.c
CONFLICT (content): Merge conflict in arch/arm/mach-msm/include/mach/memory=
.h
Merging omap/for-next
CONFLICT (content): Merge conflict in arch/arm/mach-omap2/board-omap3evm.c
CONFLICT (content): Merge conflict in arch/arm/mach-omap2/clock3xxx_data.c
CONFLICT (content): Merge conflict in arch/arm/mach-omap2/usb-musb.c
CONFLICT (content): Merge conflict in arch/arm/plat-omap/include/plat/usb.h
CONFLICT (content): Merge conflict in drivers/usb/musb/musb_core.h
Merging pxa/for-next
Merging samsung/next-samsung
Merging s5p/for-next
Merging tegra/for-next
Merging ux500-core/ux500-core
CONFLICT (content): Merge conflict in arch/arm/configs/u8500_defconfig
Merging avr32/avr32-arch
Merging blackfin/for-linus
Merging cris/for-next
Merging ia64/test
Merging m68k/for-next
Merging m68knommu/for-next
Merging microblaze/next
Merging mips/mips-for-linux-next
Merging parisc/for-next
Merging powerpc/next
CONFLICT (content): Merge conflict in arch/powerpc/sysdev/fsl_msi.c
Merging 4xx/next
Merging 52xx-and-virtex/powerpc/next
Merging galak/next
Merging s390/features
Merging sh/sh-latest
Merging rmobile/rmobile-latest
Merging sparc/master
Merging tile/master
CONFLICT (content): Merge conflict in arch/tile/kernel/vmlinux.lds.S
Merging unicore32/unicore32
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
Merging vfs-scale/vfs-scale-working
Merging pci/linux-next
Merging hid/for-next
Merging quilt/i2c
Merging bjdooks-i2c/next-i2c
Merging quilt/jdelvare-hwmon
Merging hwmon-staging/hwmon-next
CONFLICT (content): Merge conflict in drivers/hwmon/Makefile
Merging quilt/kernel-doc
Merging v4l-dvb/master
CONFLICT (content): Merge conflict in drivers/staging/Kconfig
CONFLICT (content): Merge conflict in drivers/staging/Makefile
CONFLICT (delete/modify): drivers/staging/dabusb/dabusb.c deleted in v4l-dv=
b/master and modified in HEAD. Version HEAD of drivers/staging/dabusb/dabus=
b.c left in tree.
CONFLICT (delete/modify): drivers/staging/dabusb/dabusb.h deleted in v4l-dv=
b/master and modified in HEAD. Version HEAD of drivers/staging/dabusb/dabus=
b.h left in tree.
CONFLICT (content): Merge conflict in drivers/staging/easycap/easycap_ioctl=
.c
CONFLICT (delete/modify): drivers/staging/usbvideo/usbvideo.c deleted in v4=
l-dvb/master and modified in HEAD. Version HEAD of drivers/staging/usbvideo=
/usbvideo.c left in tree.
CONFLICT (delete/modify): drivers/staging/usbvideo/vicam.c deleted in v4l-d=
vb/master and modified in HEAD. Version HEAD of drivers/staging/usbvideo/vi=
cam.c left in tree.
$ git rm -f drivers/staging/usbvideo/usbvideo.c
$ git rm -f drivers/staging/usbvideo/vicam.c
$ git rm -f drivers/staging/dabusb/dabusb.c drivers/staging/dabusb/dabusb.h
Merging kbuild/for-next
CONFLICT (content): Merge conflict in drivers/hwmon/Makefile
Merging kconfig/for-next
Merging ide/master
Merging libata/NEXT
Merging infiniband/for-next
Merging acpi/test
CONFLICT (content): Merge conflict in arch/alpha/Kconfig
CONFLICT (content): Merge conflict in arch/parisc/Kconfig
CONFLICT (content): Merge conflict in arch/powerpc/Kconfig
CONFLICT (content): Merge conflict in arch/sparc/Kconfig
CONFLICT (content): Merge conflict in arch/tile/Kconfig
CONFLICT (content): Merge conflict in arch/x86/kernel/acpi/sleep.c
CONFLICT (content): Merge conflict in lib/Makefile
Merging idle-test/idle-test
Merging powertools/tools-test
Merging ieee1394/for-next
Merging ubi/linux-next
Merging kvm/linux-next
Merging dlm/next
Merging swiotlb/master
Merging ibft/master
Merging scsi/master
CONFLICT (content): Merge conflict in drivers/scsi/libsas/sas_ata.c
CONFLICT (content): Merge conflict in drivers/scsi/libsas/sas_scsi_host.c
Merging async_tx/next
Merging net/master
Merging wireless/master
Merging bluetooth/master
Merging mtd/master
Merging crypto/master
Merging sound/for-next
Merging sound-asoc/for-next
Merging cpufreq/next
CONFLICT (content): Merge conflict in arch/arm/mach-exynos4/cpufreq.c
Merging quilt/rr
Merging input/next
Merging input-mt/next
Merging lsm/for-next
Merging block/for-next
CONFLICT (content): Merge conflict in fs/aio.c
[master e7cbe5b] Revert "mtd: fix printf format warnings, mostly lack of %z=
d for size_t, in mtdswap"
[master fe1d720] Revert "mtd: Add mtdswap block driver"
[master ef981c1] Revert "mtd_blkdevs: Add background processing support"
Merging quilt/device-mapper
Merging embedded/master
Merging firmware/master
Merging pcmcia/master
Merging battery/master
Merging leds/for-mm
CONFLICT (content): Merge conflict in drivers/leds/Kconfig
Merging backlight/for-mm
Merging mmc/mmc-next
Merging kgdb/kgdb-next
Merging slab/for-next
Merging uclinux/for-next
Merging md/for-next
Merging mfd/for-next
CONFLICT (content): Merge conflict in arch/arm/mach-imx/mach-mx27_3ds.c
CONFLICT (content): Merge conflict in arch/arm/mach-imx/mach-pcm038.c
CONFLICT (content): Merge conflict in arch/arm/mach-mx3/mach-mx31_3ds.c
CONFLICT (content): Merge conflict in arch/arm/mach-mx3/mach-mx31moboard.c
Merging hdlc/hdlc-next
Merging drm/drm-next
Merging fbdev/master
Merging viafb/viafb-next
Merging omap_dss2/for-next
CONFLICT (content): Merge conflict in arch/arm/mach-omap2/board-overo.c
Merging voltage/for-next
Merging security-testing/next
Merging selinux/master
Merging lblnet/master
Merging agp/agp-next
Merging watchdog/master
Merging bdev/master
Merging dwmw2-iommu/master
Merging cputime/cputime
Merging osd/linux-next
Merging jc_docs/docs-next
Merging nommu/master
Merging trivial/for-next
CONFLICT (content): Merge conflict in MAINTAINERS
CONFLICT (content): Merge conflict in fs/eventpoll.c
Merging audit/for-next
Merging suspend/linux-next
Merging fsnotify/for-next
Merging irda/for-next
Merging alacrity/linux-next
CONFLICT (content): Merge conflict in drivers/Makefile
CONFLICT (content): Merge conflict in include/linux/Kbuild
CONFLICT (content): Merge conflict in lib/Kconfig
Merging i7core_edac/linux_next
Merging i7300_edac/linux_next
Merging devicetree/devicetree/next
Merging spi/spi/next
CONFLICT (content): Merge conflict in drivers/gpio/Kconfig
Merging tip/auto-latest
Merging rcu/rcu/next
Merging oprofile/for-next
Merging xen-two/linux-next
CONFLICT (content): Merge conflict in drivers/xen/events.c
Merging xen-pvhvm/linux-next
Merging edac-amd/for-next
CONFLICT (content): Merge conflict in include/linux/pci_ids.h
Merging percpu/for-next
Merging workqueues/for-next
Merging sfi/sfi-test
Merging asm-generic/next
Merging drivers-x86/linux-next
Applying: OLPC: fix for removal of run_wake_count
Merging hwpoison/hwpoison
Merging sysctl/master
Merging driver-core/driver-core-next
Merging tty/tty-next
Merging usb/usb-next
Merging staging/staging-next
Merging slabh/slabh
Merging bkl-config/config
Merging cleancache/linux-next
CONFLICT (content): Merge conflict in fs/ocfs2/super.c
CONFLICT (content): Merge conflict in fs/super.c
CONFLICT (content): Merge conflict in include/linux/fs.h
CONFLICT (content): Merge conflict in mm/Kconfig
Merging scsi-post-merge/merge-base:master
$ git checkout scsi-post-merge/master

--Signature=_Fri__18_Mar_2011_19_50_13_+1100_XtfnwMH=S.aypoYd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNgxzFAAoJEDMEi1NhKgbss7YH/3TMsIGK2PngVYRPnTJz+Ojs
V85KI3AbNh5cfqSJsu/kzy5p4/9uDb3lciK0NS83ay3QNIyQ5t4b6cOuOB8yAWdb
X0AkqiNGrxJXJLIIvCiouvUBEgIdzgogkjtyCPjAyDVFBgiWW3ZylH+TGIYpXArM
lVmrwQhahZiHBZ61Z18U2zcFgCKSoWVAfQPHSw5smmjP6yTyA6bbJHXiC6YmAzlv
vDtWVJzhdlIfeyQwoXKZLJCPoO2vwFyKbyOJga+NdXEy96uiGolWVzS5tkAEoJMG
hF+fNIc5eDo0G2SJEA+gbYKp691Il3toAmVVi6gsfhA9rrDGAcIpENbpQ1MGCWE=
=3XpB
-----END PGP SIGNATURE-----

--Signature=_Fri__18_Mar_2011_19_50_13_+1100_XtfnwMH=S.aypoYd--

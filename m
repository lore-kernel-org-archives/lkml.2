Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752395Ab0L0GFJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 01:05:09 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:52190 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939Ab0L0GFH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 01:05:07 -0500
Date: Mon, 27 Dec 2010 17:04:51 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for December 27
Message-Id: <20101227170451.a9a9f873.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__27_Dec_2010_17_04_51_+1100_16MDsyZe/i4/=Uz9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__27_Dec_2010_17_04_51_+1100_16MDsyZe/i4/=Uz9
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

[The mirroring on kernel.org is running slowly]

Changes since 20101221:

Linus' tree lost its build failure.

The omap tree gained a conflict against the arm tree.

The ux500-core tree gained a build failure for which I reverted a commit.

The sh tree gained a conflict against the sh-current tree.

The pci tree lost its conflicts.

The kvm tree lost its conflict.

The net tree gained a conflict against Linus' tree.

The wireless tree lost its conflicts.

The sound tree gained a build failure, so I used the version that would
have been in next-20101223.

The sound-asoc tree also had a build failure, so I used the version from
next-20101221.

The trivial tree lost its conflicts.

The workqueues tree gained conflicts against the tip and v4l-dvb trees.

The tty tree still has its build failure so I reverted a commit.

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

We are up to 183 trees (counting Linus' and 26 trees of patches pending
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
Merging gcl-current/merge
Merging arm/devel
Merging davinci/davinci-next
Merging i.MX/for-next
Merging linux-spec/for-next
Merging msm/for-next
Merging omap/for-next
CONFLICT (content): Merge conflict in arch/arm/plat-omap/Kconfig
Merging pxa/for-next
Merging samsung/next-samsung
Merging s5p/for-next
Merging tegra/for-next
CONFLICT (content): Merge conflict in arch/arm/mach-tegra/timer.c
Merging ux500-core/ux500-core
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
Merging sh/sh-latest
CONFLICT (content): Merge conflict in arch/sh/kernel/cpu/sh2a/clock-sh7201.c
Merging rmobile/rmobile-latest
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/Kconfig
Applying: rmobile: merge fixup for clkdev changes
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
Merging vfs-scale/vfs-scale-working
CONFLICT (content): Merge conflict in fs/cifs/dir.c
CONFLICT (content): Merge conflict in fs/fuse/inode.c
CONFLICT (content): Merge conflict in fs/hfsplus/hfsplus_fs.h
CONFLICT (content): Merge conflict in fs/hfsplus/unicode.c
Merging pci/linux-next
Merging hid/for-next
Merging quilt/i2c
Merging bjdooks-i2c/next-i2c
Merging quilt/jdelvare-hwmon
Merging hwmon-staging/hwmon-next
Merging quilt/kernel-doc
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
CONFLICT (content): Merge conflict in net/9p/protocol.c
CONFLICT (content): Merge conflict in net/ipv4/fib_frontend.c
Merging wireless/master
Merging bluetooth/master
CONFLICT (content): Merge conflict in net/bluetooth/Makefile
Merging mtd/master
Merging crypto/master
Merging sound/for-next
CONFLICT (rename/modify): Merge conflict in sound/soc/samsung/smdk_wm8580.c
CONFLICT (rename/modify): Merge conflict in sound/soc/samsung/smdk_wm9713.c
CONFLICT (add/add): Merge conflict in arch/arm/plat-samsung/dev-asocdma.c
$ git reset --hard HEAD^
Merging refs/next/20101223/sound
CONFLICT (rename/modify): Merge conflict in sound/soc/samsung/smdk_wm8580.c
CONFLICT (rename/modify): Merge conflict in sound/soc/samsung/smdk_wm9713.c
CONFLICT (add/add): Merge conflict in arch/arm/plat-samsung/dev-asocdma.c
[master 399efb0] Merge commit 'refs/next/20101223/sound'
Merging sound-asoc/for-next
$ git reset --hard HEAD^
Merging refs/next/20101221/sound-asoc
Merging cpufreq/next
Merging quilt/rr
Merging input/next
CONFLICT (content): Merge conflict in drivers/input/keyboard/Kconfig
CONFLICT (content): Merge conflict in include/linux/input.h
Merging lsm/for-next
Merging block/for-next
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
CONFLICT (content): Merge conflict in drivers/mfd/Makefile
CONFLICT (content): Merge conflict in drivers/mfd/wm8994-core.c
Merging hdlc/hdlc-next
Merging drm/drm-next
Merging fbdev/master
Merging viafb/viafb-next
Merging omap_dss2/for-next
Merging voltage/for-next
CONFLICT (content): Merge conflict in drivers/regulator/core.c
CONFLICT (content): Merge conflict in drivers/regulator/mc13783-regulator.c
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
Merging audit/for-next
Merging suspend/linux-next
Merging fsnotify/for-next
Merging irda/for-next
Merging catalin/for-next
Merging alacrity/linux-next
CONFLICT (content): Merge conflict in drivers/Makefile
CONFLICT (content): Merge conflict in include/linux/Kbuild
CONFLICT (content): Merge conflict in lib/Kconfig
Merging i7core_edac/linux_next
Merging i7300_edac/linux_next
Merging devicetree/next-devicetree
Merging spi/next-spi
Merging tip/auto-latest
Merging rcu/rcu/next
Merging oprofile/for-next
Merging xen/upstream/xen
Merging swiotlb-xen/master
CONFLICT (content): Merge conflict in drivers/xen/Kconfig
CONFLICT (content): Merge conflict in drivers/xen/Makefile
Merging xen-pvhvm/linux-next
Merging edac-amd/for-next
Merging percpu/for-next
Merging workqueues/for-next
CONFLICT (content): Merge conflict in Documentation/feature-removal-schedul=
e.txt
CONFLICT (content): Merge conflict in drivers/media/video/bt8xx/bttv-input.c
CONFLICT (content): Merge conflict in drivers/rtc/rtc-dev.c
Merging sfi/sfi-test
Merging asm-generic/next
Merging drivers-x86/linux-next
Merging hwpoison/hwpoison
Merging sysctl/master
Merging driver-core/driver-core-next
Merging tty/tty-next
[master ed994a8] Revert "drivers: serial: apbuart: Handle OF failures grace=
fully"
Merging usb/usb-next
CONFLICT (content): Merge conflict in arch/arm/mach-omap2/Kconfig
CONFLICT (content): Merge conflict in arch/arm/mach-omap2/clock3xxx_data.c
CONFLICT (content): Merge conflict in arch/arm/mach-omap2/clock44xx_data.c
CONFLICT (content): Merge conflict in arch/sh/Kconfig
Merging staging/staging-next
Merging slabh/slabh
Merging bkl-trivial/trivial
Merging bkl-llseek/llseek
Merging bkl-vfs/vfs
Merging bkl-config/config
CONFLICT (content): Merge conflict in arch/powerpc/kernel/setup_64.c
CONFLICT (content): Merge conflict in include/linux/hardirq.h
CONFLICT (content): Merge conflict in include/linux/smp_lock.h
Merging irqflags/master
Merging cleancache/linux-next
CONFLICT (content): Merge conflict in fs/ocfs2/super.c
CONFLICT (content): Merge conflict in fs/super.c
CONFLICT (content): Merge conflict in include/linux/fs.h
CONFLICT (content): Merge conflict in mm/Kconfig
Merging scsi-post-merge/merge-base:master
$ git checkout scsi-post-merge/master
Applying: [SCSI] target: Add LIO target core v4.0.0-rc6
Applying: [SCSI] sd: implement sd_check_events()
[master 7fdf0d2] Revert "input/tc3589x: add tc3589x keypad support"

--Signature=_Mon__27_Dec_2010_17_04_51_+1100_16MDsyZe/i4/=Uz9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNGCyDAAoJEDMEi1NhKgbs/wkH+wSgRpSHAVJ5CheDGroI6G2j
zGRMht1Qa1aJ5WYcN4LovmsQWmyqIbtVpBk/MAPgL7IUHtWVX5zpcz9vVHSxZJn9
BshL8mA6IHDlIuMXJY6XOJ23Sw8fTMbTpxEBI4LjyFeOUPRuSM6SJKX8hBLcpjpr
dT7ftS6f04Bm5m9BUIV1TCF/MXMk5WMB054YbsNFoGVJBD4H8LgjkGIwQ0LNXcdJ
kM7kaEMkgcPd6kGsMLEOuixiiDFHsHJLaCu8SuLj1vG6OVGXiZyW5OhiPnj1I6KT
pYlhkiqEPbaKKHxq35sHSyMe7OM6mxAG1JfMdWgYB+zCAuko2rUz+kP5P1qN7nU=
=Hr9q
-----END PGP SIGNATURE-----

--Signature=_Mon__27_Dec_2010_17_04_51_+1100_16MDsyZe/i4/=Uz9--

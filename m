Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067Ab1DLFOe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 01:14:34 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:48894 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753580Ab1DLFOT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 01:14:19 -0400
Date: Tue, 12 Apr 2011 15:14:08 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for April 12
Message-Id: <20110412151408.b80a3afb.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__12_Apr_2011_15_14_08_+1000_KB+jWgi8bZDWk+te"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__12_Apr_2011_15_14_08_+1000_KB+jWgi8bZDWk+te
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20110411:

Added tree: cpupowerutils

Dropped tree: xen

The net tree lost its conflict.

The sound-asoc tree gained a build failure so I used the version from
next-20110411.

The block tree lost its conflict.

The tip tree lost a conflict but gained a build failure for which I
applied a patch.

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

We are up to 185 trees (counting Linus' and 28 trees of patches pending
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
Merging arm/for-next
Merging davinci/davinci-next
Merging i.MX/for-next
CONFLICT (content): Merge conflict in arch/arm/mach-mxs/mach-mx28evk.c
Merging linux-spec/for-next
Merging msm/for-next
Merging omap/for-next
Merging pxa/for-next
Merging samsung/next-samsung
Merging s5p/for-next
Merging tegra/for-next
Merging ux500-core/ux500-core
Merging xilinx/arm-next
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
Merging 4xx/next
Merging 52xx-and-virtex/powerpc/next
Merging galak/next
Merging s390/features
Merging sh/sh-latest
Merging rmobile/rmobile-latest
Merging sparc/master
Merging tile/master
Merging unicore32/unicore32
Merging xtensa/master
CONFLICT (content): Merge conflict in arch/xtensa/configs/iss_defconfig
Merging ceph/for-next
Merging cifs/master
Merging configfs/linux-next
Merging ecryptfs/next
CONFLICT (content): Merge conflict in fs/ecryptfs/ecryptfs_kernel.h
Merging ext3/for_next
Merging ext4/next
Merging fatfs/master
Merging fuse/for-next
Merging gfs2/master
CONFLICT (content): Merge conflict in fs/gfs2/log.c
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
CONFLICT (content): Merge conflict in arch/arm/mach-pxa/tosa.c
CONFLICT (content): Merge conflict in drivers/i2c/busses/i2c-designware-cor=
e.c
CONFLICT (delete/modify): drivers/i2c/busses/i2c-intel-mid.c deleted in bjd=
ooks-i2c/next-i2c and modified in HEAD. Version HEAD of drivers/i2c/busses/=
i2c-intel-mid.c left in tree.
CONFLICT (content): Merge conflict in drivers/i2c/busses/i2c-pxa.c
$ git rm -f drivers/i2c/busses/i2c-intel-mid.c
Applying: i2c-designware: mdelay use needs linux/delay.h inclusion
Merging quilt/jdelvare-hwmon
Merging hwmon-staging/hwmon-next
Merging quilt/kernel-doc
Merging v4l-dvb/master
CONFLICT (content): Merge conflict in arch/arm/mach-omap2/devices.c
CONFLICT (delete/modify): drivers/media/dvb/frontends/drx397xD.c deleted in=
 v4l-dvb/master and modified in HEAD. Version HEAD of drivers/media/dvb/fro=
ntends/drx397xD.c left in tree.
CONFLICT (content): Merge conflict in drivers/staging/Kconfig
CONFLICT (content): Merge conflict in drivers/staging/easycap/easycap_ioctl=
.c
$ git rm -f drivers/media/dvb/frontends/drx397xD.c
Merging kbuild/for-next
Merging kconfig/for-next
Merging ide/master
Merging libata/NEXT
Merging infiniband/for-next
Merging acpi/test
Merging idle-test/idle-test
Merging powertools/tools-test
Merging cpupowerutils/cpupowerutils
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
CONFLICT (delete/modify): drivers/net/wireless/ath/ar9170/main.c deleted in=
 wireless/master and modified in HEAD. Version HEAD of drivers/net/wireless=
/ath/ar9170/main.c left in tree.
CONFLICT (delete/modify): drivers/net/wireless/ath/ar9170/phy.c deleted in =
wireless/master and modified in HEAD. Version HEAD of drivers/net/wireless/=
ath/ar9170/phy.c left in tree.
CONFLICT (content): Merge conflict in drivers/net/wireless/zd1211rw/zd_rf_r=
f2959.c
$ git rm -f drivers/net/wireless/ath/ar9170/main.c drivers/net/wireless/ath=
/ar9170/phy.c
Merging bluetooth/master
Merging mtd/master
Merging crypto/master
Merging sound/for-next
CONFLICT (content): Merge conflict in sound/soc/codecs/wm8994.c
Merging sound-asoc/for-next
$ git reset --hard HEAD^
Merging refs/next/20110411/sound-asoc
Merging cpufreq/next
Merging quilt/rr
Merging input/next
Merging input-mt/next
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
Merging hdlc/hdlc-next
Merging drm/drm-next
Merging fbdev/master
Merging viafb/viafb-next
Merging omap_dss2/for-next
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
CONFLICT (content): Merge conflict in drivers/net/wireless/ath/ath9k/phy.h
Merging audit/for-next
Merging suspend/linux-next
Merging fsnotify/for-next
Merging irda/for-next
Merging i7core_edac/linux_next
Merging i7300_edac/linux_next
Merging devicetree/devicetree/next
Merging spi/spi/next
Merging tip/auto-latest
CONFLICT (content): Merge conflict in arch/x86/kernel/process.c
Applying: x86 idle: merge fix for mwait move
Merging rcu/rcu/next
Merging oprofile/for-next
Merging ptrace/ptrace
Merging xen-two/linux-next
Merging xen-pvhvm/linux-next
Merging edac-amd/for-next
Merging percpu/for-next
Merging workqueues/for-next
Merging sfi/sfi-test
Merging asm-generic/next
Merging drivers-x86/linux-next
CONFLICT (content): Merge conflict in drivers/platform/x86/intel_mid_therma=
l.c
Merging hwpoison/hwpoison
Merging sysctl/master
Merging driver-core/driver-core-next
Merging tty/tty-next
Merging usb/usb-next
Merging staging/staging-next
CONFLICT (delete/modify): drivers/staging/ath6kl/os/linux/ar6000_android.c =
deleted in staging/staging-next and modified in HEAD. Version HEAD of drive=
rs/staging/ath6kl/os/linux/ar6000_android.c left in tree.
CONFLICT (content): Merge conflict in drivers/staging/brcm80211/README
CONFLICT (content): Merge conflict in drivers/staging/brcm80211/brcmsmac/wl=
c_ampdu.c
CONFLICT (content): Merge conflict in drivers/staging/gma500/psb_drm.h
CONFLICT (delete/modify): drivers/staging/gma500/psb_ttm_fence_user.h delet=
ed in staging/staging-next and modified in HEAD. Version HEAD of drivers/st=
aging/gma500/psb_ttm_fence_user.h left in tree.
CONFLICT (content): Merge conflict in drivers/staging/hv/hv_util.c
CONFLICT (content): Merge conflict in drivers/staging/hv/vmbus_drv.c
$ git rm -f drivers/staging/ath6kl/os/linux/ar6000_android.c
$ git rm -f drivers/staging/gma500/psb_ttm_fence_user.h
Merging slabh/slabh
Merging bkl-config/config
Merging cleancache/linux-next
CONFLICT (content): Merge conflict in fs/ocfs2/super.c
CONFLICT (content): Merge conflict in fs/super.c
CONFLICT (content): Merge conflict in include/linux/fs.h
CONFLICT (content): Merge conflict in mm/Kconfig
CONFLICT (content): Merge conflict in mm/truncate.c
Merging scsi-post-merge/merge-base:master
$ git checkout scsi-post-merge/master
Applying: sched: fix sparc64 for sched_domain changes

--Signature=_Tue__12_Apr_2011_15_14_08_+1000_KB+jWgi8bZDWk+te
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNo9+gAAoJEDMEi1NhKgbsBEkH/RxIt1tvUTHmHXjyDzV5n0GG
7kpaFJXloKNPiOfwgwp7hePsNcC1f5wZXYZ5PyO2BYtmOGOoaSmg6kZ+lWJ1Nohq
J3/U+w3VO1J7p1T7it2YVE/bvmamH29Tw0ryq59oOZphGzKZw9DjoAQODnyFDGyO
Bln11biTsau5YHIDmSkJc5p0UXhoknm+KwqC2+ZymLv3i0XTTy67sgj++GxQq1+i
MSWDGv1t3/ORCS75DUjWdXVqfL7me68vSPGsDKJ12d9ToW4QvGkwzU0aWgLn2XEi
tvg/KEVTCA6TASwChXxvGtpYbNa0MWNwd0XTUihQ871F69VN6voKF3raL9troTg=
=+Sd8
-----END PGP SIGNATURE-----

--Signature=_Tue__12_Apr_2011_15_14_08_+1000_KB+jWgi8bZDWk+te--

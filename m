Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071Ab0KLCF5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 21:05:57 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:53142 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751732Ab0KLCFz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 21:05:55 -0500
Date: Fri, 12 Nov 2010 13:05:47 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for November 12
Message-Id: <20101112130547.c2a3c2c1.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__12_Nov_2010_13_05_47_+1100_HiID5wlpAAIixgDs"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__12_Nov_2010_13_05_47_+1100_HiID5wlpAAIixgDs
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20101111:

The voltage tree lost its build failure.

The fsnotify tree lost its build failure.

The tty tree gained a build failure for which I reverted a commit.

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

We are up to 179 trees (counting Linus' and 26 trees of patches pending
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
Merging parisc/next
Merging powerpc/next
Merging 4xx/next
Merging 52xx-and-virtex/next
Merging galak/next
Merging s390/features
Merging sh/sh-latest
Merging rmobile/rmobile-latest
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
CONFLICT (content): Merge conflict in drivers/hid/hid-input.c
Merging quilt/i2c
Merging bjdooks-i2c/next-i2c
Merging quilt/jdelvare-hwmon
CONFLICT (content): Merge conflict in Documentation/feature-removal-schedul=
e.txt
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
Merging wireless/master
Merging bluetooth/master
Merging mtd/master
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
Merging fbdev/master
Merging viafb/viafb-next
Merging omap_dss2/for-next
Merging voltage/for-next
Merging security-testing/next
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
CONFLICT (delete/modify): arch/blackfin/mach-bf518/include/mach/defBF51x_ba=
se.h deleted in HEAD and modified in trivial/for-next. Version trivial/for-=
next of arch/blackfin/mach-bf518/include/mach/defBF51x_base.h left in tree.
CONFLICT (delete/modify): arch/blackfin/mach-bf527/include/mach/defBF52x_ba=
se.h deleted in HEAD and modified in trivial/for-next. Version trivial/for-=
next of arch/blackfin/mach-bf527/include/mach/defBF52x_base.h left in tree.
CONFLICT (content): Merge conflict in arch/blackfin/mach-bf538/include/mach=
/defBF539.h
CONFLICT (content): Merge conflict in drivers/scsi/bfa/bfa_fcpim.c
$ git rm -f arch/blackfin/mach-bf518/include/mach/defBF51x_base.h arch/blac=
kfin/mach-bf527/include/mach/defBF52x_base.h
Merging audit/for-next
Merging suspend/linux-next
Merging fsnotify/for-next
Merging irda/for-next
Merging catalin/for-next
Merging alacrity/linux-next
CONFLICT (content): Merge conflict in include/linux/Kbuild
Merging i7core_edac/linux_next
Merging i7300_edac/linux_next
Merging devicetree/next-devicetree
Merging spi/next-spi
Merging tip/auto-latest
Merging rcu/rcu/next
Merging oprofile/for-next
Merging xen/upstream/xen
Merging swiotlb-xen/master
Merging xen-pvhvm/linux-next
Merging edac-amd/for-next
Merging percpu/for-next
Merging workqueues/for-next
Merging sfi/sfi-test
Merging asm-generic/next
Merging drivers-x86/linux-next
Merging hwpoison/hwpoison
Merging sysctl/master
Merging driver-core/driver-core-next
Merging tty/tty-next
Merging usb/usb-next
Merging staging/staging-next
CONFLICT (content): Merge conflict in drivers/staging/bcm/Bcmchar.c
CONFLICT (content): Merge conflict in drivers/staging/intel_sst/intel_sst_a=
pp_interface.c
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
[master d0e885e] Revert "ifx6x60: SPI protocol driver for Infineon 6x60 mod=
em"

--Signature=_Fri__12_Nov_2010_13_05_47_+1100_HiID5wlpAAIixgDs
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJM3KD7AAoJEDMEi1NhKgbsSkcIAInfNpG2+yRm2Fvl0U0D/r6B
h99J1S1cpvQ7ygB5cX9xzIbLrpxV6tVP2q/WUvBPa7eVBjSO11KnfXSDSGnvJ32B
GjwKn2YfyMv7C7SzVM5FZpXmFYS2d+h4/sP1GJYWx2T/kHxulCfChsV2tQxt81wG
XUFP9JqROSGEaPKUq+8bagRFWY4z9EuPzouf0JVsL5Ls/ytpw+4i2z97+GFuywqP
nZ/m8Cw1+/wzOp/WY/bEy6Z4TdXu7kEn0zbq7w8m8S7onA4BSotFIeAy5VzQnKwC
EtRtq9A3X0udt5bwtacd8tXPOrgiOV9vi2tvxODiR/Rm/SKLCfeMxtVuNLjj3jI=
=jqFJ
-----END PGP SIGNATURE-----

--Signature=_Fri__12_Nov_2010_13_05_47_+1100_HiID5wlpAAIixgDs--

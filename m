Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787Ab1BOGky (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 01:40:54 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:47186 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753214Ab1BOGkv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 01:40:51 -0500
Date: Tue, 15 Feb 2011 17:40:42 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for February 15
Message-Id: <20110215174042.b9c86c1f.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__15_Feb_2011_17_40_42_+1100_dq721B7rkko6KHEl"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__15_Feb_2011_17_40_42_+1100_dq721B7rkko6KHEl
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20110214:

Dropped tree: xen

The bluetooth tree gained a build failure so I used the version from
next-20110214.

The sound-asoc tree gained a build failure so I used the version from
next-20110214.

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

We are up to 188 trees (counting Linus' and 28 trees of patches pending
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
Merging 52xx-and-virtex-current/powerpc/merge
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
Merging devicetree-current/devicetree/merge
Merging spi-current/spi/merge
Merging arm/for-next
Merging davinci/davinci-next
Merging i.MX/for-next
Merging linux-spec/for-next
Merging msm/for-next
CONFLICT (content): Merge conflict in arch/arm/mach-msm/board-msm7x27.c
CONFLICT (content): Merge conflict in arch/arm/mach-msm/board-msm7x30.c
CONFLICT (content): Merge conflict in arch/arm/mach-msm/board-qsd8x50.c
CONFLICT (content): Merge conflict in arch/arm/mach-msm/board-sapphire.c
CONFLICT (content): Merge conflict in arch/arm/mach-msm/include/mach/memory=
.h
Merging omap/for-next
Merging pxa/for-next
Merging samsung/next-samsung
Merging s5p/for-next
Merging tegra/for-next
Merging ux500-core/ux500-core
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
Merging ext3/for_next
Merging ext4/next
CONFLICT (content): Merge conflict in fs/ext4/mballoc.c
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
Merging quilt/kernel-doc
Merging v4l-dvb/master
Merging kbuild/for-next
Merging kconfig/for-next
Merging ide/master
Merging libata/NEXT
Merging infiniband/for-next
Merging acpi/test
Merging idle-test/idle-test
Merging powertools/tools
Merging ieee1394/for-next
Merging ubi/linux-next
Merging kvm/linux-next
Merging dlm/next
Merging swiotlb/master
Merging ibft/master
Merging scsi/master
Merging async_tx/next
Merging net/master
CONFLICT (content): Merge conflict in Documentation/feature-removal-schedul=
e.txt
Merging wireless/master
Merging bluetooth/master
$ git reset --hard HEAD^
Merging refs/next/20110214/bluetooth
Merging mtd/master
Merging crypto/master
Merging sound/for-next
Merging sound-asoc/for-next
$ git reset --hard HEAD^
Merging refs/next/20110214/sound-asoc
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
Merging devicetree/devicetree/next
Merging spi/spi/next
Merging tip/auto-latest
Merging rcu/rcu/next
Merging oprofile/for-next
Merging xen-two/linux-next
Merging xen-pvhvm/linux-next
CONFLICT (content): Merge conflict in arch/x86/include/asm/xen/page.h
Merging edac-amd/for-next
CONFLICT (content): Merge conflict in include/linux/pci_ids.h
Merging percpu/for-next
CONFLICT (content): Merge conflict in arch/x86/kernel/vmlinux.lds.S
Merging workqueues/for-next
Merging sfi/sfi-test
Merging asm-generic/next
Merging drivers-x86/linux-next
Applying: OLPC: fix for removal of run_wake_count
Merging hwpoison/hwpoison
Merging sysctl/master
Merging driver-core/driver-core-next
Merging tty/tty-next
CONFLICT (content): Merge conflict in drivers/tty/serial/Kconfig
Merging usb/usb-next
CONFLICT (content): Merge conflict in drivers/usb/gadget/Kconfig
CONFLICT (content): Merge conflict in drivers/usb/host/ehci-pci.c
Merging staging/staging-next
CONFLICT (content): Merge conflict in drivers/staging/zram/zram_drv.c
Merging slabh/slabh
Merging bkl-trivial/trivial
Merging bkl-llseek/llseek
Merging bkl-vfs/vfs
Merging bkl-config/config
CONFLICT (content): Merge conflict in arch/powerpc/kernel/setup_64.c
CONFLICT (content): Merge conflict in drivers/scsi/pm8001/pm8001_sas.h
CONFLICT (delete/modify): drivers/staging/stradis/Kconfig deleted in HEAD a=
nd modified in bkl-config/config. Version bkl-config/config of drivers/stag=
ing/stradis/Kconfig left in tree.
CONFLICT (content): Merge conflict in fs/nfsd/nfs4state.c
CONFLICT (content): Merge conflict in include/linux/hardirq.h
CONFLICT (content): Merge conflict in include/linux/smp_lock.h
$ git rm -f drivers/staging/stradis/Kconfig
Merging irqflags/master
Merging cleancache/linux-next
CONFLICT (content): Merge conflict in fs/ocfs2/super.c
CONFLICT (content): Merge conflict in fs/super.c
CONFLICT (content): Merge conflict in include/linux/fs.h
CONFLICT (content): Merge conflict in mm/Kconfig
Merging scsi-post-merge/merge-base:master
$ git checkout scsi-post-merge/master

--Signature=_Tue__15_Feb_2011_17_40_42_+1100_dq721B7rkko6KHEl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNWh/qAAoJEDMEi1NhKgbst98H/if/QogwfuWw+vk/AtEBr2qz
p2f9hxGCgPP4ICYkwnMdXyWe/Pb/MyGOcK4pEN1HLanA085gTYmORIb7f9G9DhVD
jyCFk+UudxK2/sblM4SrnuilCsso8NGahgvX4A9gidXQ8vG0bq/R7h+KvHJmSNNB
I5xPOUtLwq2X0+9BvpJYU9KB82Hku6QbOvUZxOWUFXCLaILqZPfKveFQIMGWM1Ay
8Wm41t7sMrAyEFLVVMrY6jICNRiJK4LG/wWrk9eZ8MAR9HvjutVaNtn4qq2gRvNu
X4s0vwJnEucdEfo4RTxsk7rWdE8fvmoVFElSd2Xl8zCFvT5v1CER0S4Ixvc3sK4=
=lDi5
-----END PGP SIGNATURE-----

--Signature=_Tue__15_Feb_2011_17_40_42_+1100_dq721B7rkko6KHEl--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751409Ab1AEFbB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 00:31:01 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:47310 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924Ab1AEFa7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 00:30:59 -0500
Date: Wed, 5 Jan 2011 16:30:51 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for January 5
Message-Id: <20110105163051.0ae9bd68.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__5_Jan_2011_16_30_51_+1100_b2Z6rXttqAiLi7iD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__5_Jan_2011_16_30_51_+1100_b2Z6rXttqAiLi7iD
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

[The mirroring of this out to the kernel.org servers is being slow]

Changes since 201101041:

The wireless tree gained a build failure for which I reverted a commit.

The devicetree tree gained conflicts against the sparc and mtd trees.

The percpu tree gained a conflict against the tip tree and still has its
build failure so I used the version from next-20101231.

The tty tree still has its build failure for which I reverted a commit.

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

We are up to 184 trees (counting Linus' and 26 trees of patches pending
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
CONFLICT (content): Merge conflict in Documentation/filesystems/Locking
CONFLICT (content): Merge conflict in fs/9p/vfs_inode.c
CONFLICT (content): Merge conflict in fs/cifs/dir.c
CONFLICT (content): Merge conflict in fs/fuse/inode.c
CONFLICT (content): Merge conflict in fs/hfsplus/hfsplus_fs.h
CONFLICT (content): Merge conflict in fs/hfsplus/unicode.c
Applying: v9fs: merge fix for changes in the vfs-scale tree
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
CONFLICT (content): Merge conflict in drivers/net/skge.c
CONFLICT (content): Merge conflict in drivers/net/sky2.c
CONFLICT (content): Merge conflict in net/9p/protocol.c
Merging wireless/master
CONFLICT (content): Merge conflict in net/bluetooth/Makefile
Merging bluetooth/master
Merging mtd/master
Merging crypto/master
Merging sound-asoc/for-next
Merging sound/for-next
Merging cpufreq/next
Merging quilt/rr
Merging input/next
CONFLICT (content): Merge conflict in drivers/input/keyboard/Kconfig
CONFLICT (content): Merge conflict in include/linux/input.h
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
CONFLICT (content): Merge conflict in drivers/mfd/Makefile
CONFLICT (content): Merge conflict in drivers/mfd/wm8994-core.c
Merging hdlc/hdlc-next
Merging drm/drm-next
Merging fbdev/master
CONFLICT (content): Merge conflict in drivers/video/sh_mobile_lcdcfb.c
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
CONFLICT (content): Merge conflict in drivers/net/wireless/iwlwifi/iwl-core=
.c
CONFLICT (content): Merge conflict in fs/ext4/ext4.h
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
CONFLICT (content): Merge conflict in arch/sparc/prom/tree_32.c
CONFLICT (content): Merge conflict in drivers/mtd/Kconfig
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
CONFLICT (delete/modify): arch/x86/kernel/apic/nmi.c deleted in HEAD and mo=
dified in percpu/for-next. Version percpu/for-next of arch/x86/kernel/apic/=
nmi.c left in tree.
CONFLICT (content): Merge conflict in arch/x86/kernel/apic/x2apic_uv_x.c
CONFLICT (content): Merge conflict in arch/x86/kernel/process.c
$ git rm -f arch/x86/kernel/apic/nmi.c
$ git reset --hard HEAD^
Merging refs/next/20101231/percpu
CONFLICT (delete/modify): arch/x86/kernel/apic/nmi.c deleted in HEAD and mo=
dified in refs/next/20101231/percpu. Version refs/next/20101231/percpu of a=
rch/x86/kernel/apic/nmi.c left in tree.
CONFLICT (content): Merge conflict in arch/x86/kernel/apic/x2apic_uv_x.c
CONFLICT (content): Merge conflict in arch/x86/kernel/process.c
$ git rm -f arch/x86/kernel/apic/nmi.c
[master a8efb4f] Merge commit 'refs/next/20101231/percpu'
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
[master c50cbac] Revert "drivers: serial: apbuart: Handle OF failures grace=
fully"
Merging usb/usb-next
CONFLICT (content): Merge conflict in arch/arm/mach-omap2/Kconfig
CONFLICT (content): Merge conflict in arch/arm/mach-omap2/clock3xxx_data.c
CONFLICT (content): Merge conflict in arch/arm/mach-omap2/clock44xx_data.c
CONFLICT (content): Merge conflict in arch/sh/Kconfig
CONFLICT (content): Merge conflict in drivers/usb/Kconfig
CONFLICT (content): Merge conflict in drivers/usb/host/ehci-hcd.c
Merging staging/staging-next
Merging slabh/slabh
Merging bkl-trivial/trivial
Merging bkl-llseek/llseek
Merging bkl-vfs/vfs
Merging bkl-config/config
CONFLICT (content): Merge conflict in arch/powerpc/kernel/setup_64.c
CONFLICT (delete/modify): drivers/staging/stradis/Kconfig deleted in HEAD a=
nd modified in bkl-config/config. Version bkl-config/config of drivers/stag=
ing/stradis/Kconfig left in tree.
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
Applying: [SCSI] sd: implement sd_check_events()
Applying: [SCSI] target: Add LIO target core v4.0.0-rc6
Applying: [SCSI] sd,sr: kill compat SDEV_MEDIA_CHANGE event
[master ec5ca24] Revert "ath5k: Move mac80211 functions into new file"

--Signature=_Wed__5_Jan_2011_16_30_51_+1100_b2Z6rXttqAiLi7iD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNJAILAAoJEDMEi1NhKgbsAR8H/jQw7ukOPlIJskZqjZimrBpg
QG5qfVDBqb6lRGa5yW1lWjlPZ+DcpycKcDO8c2MLDisHqKBMRgUNU0+UKoFCbGyW
cCCD7dQxka3XDcWXaUckzW8CLBCXRyGRygb8OY39no0qGGgTMEGBx7ssVb/DYWkX
aTKMHKBWZbwunlHzunGTtK4lgouqZdn9LhKLwiX2xON+cnzhGPQ7FG0t7SkRKXWH
34u+19VULIZVwyi+LLqoSC62uqIY/of+WG8mWCXLKZHFK2oK3ZWQ7cTIeUxgFRLn
FX4UHGHfLBwgMQA/JF4ccsjFDznO6+N5G7Mltlol2dSh+cEU2+LKywaxOXg3rOQ=
=NmKj
-----END PGP SIGNATURE-----

--Signature=_Wed__5_Jan_2011_16_30_51_+1100_b2Z6rXttqAiLi7iD--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425Ab1COIpy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 04:45:54 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:52915 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754457Ab1COIpt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 04:45:49 -0400
Date: Tue, 15 Mar 2011 19:45:43 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for March 15
Message-Id: <20110315194543.a5d56c0c.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__15_Mar_2011_19_45_43_+1100_2biFMq3GceLlZ+8A"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__15_Mar_2011_19_45_43_+1100_2biFMq3GceLlZ+8A
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20110314:

Dropped tree: xen

The ux500-core tree lost a conflict.

The powerpc tree still has its build failure for which I reverted a commit.

The drm tree gained a build failure for which I applied a patch.

The net tree still has its build failure for which I merged a fix from the =
tip
tree.

The jdelvare-hwmon tree gained a build failure for which I reverted a commi=
t.

The block tree still has its build failures.

The xen-two tree gained a conflict against the tip tree.

The blk-config tree gained a build failure for which I applied a patch.

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

We are up to 184 trees (counting Linus' and 28 trees of patches pending
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
CONFLICT (content): Merge conflict in arch/arm/mm/Kconfig
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
[master d206cdd] Revert "powerpc: Enable GENERIC_HARDIRQS_NO_DEPRECATED."
Merging 4xx/next
Merging 52xx-and-virtex/powerpc/next
Merging galak/next
Merging s390/features
Merging sh/sh-latest
Merging rmobile/rmobile-latest
Merging sparc/master
Merging tile/master
Merging unicore32/unicore32
CONFLICT (content): Merge conflict in drivers/video/Kconfig
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
Merging kbuild/for-next
Merging kconfig/for-next
Merging ide/master
Merging libata/NEXT
Merging infiniband/for-next
Merging acpi/test
CONFLICT (content): Merge conflict in arch/alpha/Kconfig
CONFLICT (content): Merge conflict in arch/parisc/Kconfig
CONFLICT (content): Merge conflict in arch/sparc/Kconfig
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
CONFLICT (content): Merge conflict in drivers/net/Kconfig
CONFLICT (content): Merge conflict in lib/Makefile
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
Applying: drbd: need include for bitops functions declarations
[master 56d5f5a] Revert "mtd: fix printf format warnings, mostly lack of %z=
d for size_t, in mtdswap"
[master daff3fe] Revert "mtd: Add mtdswap block driver"
[master c034482] Revert "mtd_blkdevs: Add background processing support"
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
CONFLICT (content): Merge conflict in drivers/gpu/drm/nouveau/nouveau_mem.c
Applying: drm/radeon/kms: update for active_vram_size removal
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
CONFLICT (content): Merge conflict in MAINTAINERS
CONFLICT (content): Merge conflict in fs/eventpoll.c
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
CONFLICT (content): Merge conflict in arch/x86/ia32/ia32entry.S
CONFLICT (content): Merge conflict in arch/x86/include/asm/unistd_32.h
CONFLICT (content): Merge conflict in arch/x86/include/asm/unistd_64.h
CONFLICT (content): Merge conflict in arch/x86/kernel/acpi/sleep.c
CONFLICT (content): Merge conflict in arch/x86/kernel/syscall_table_32.S
CONFLICT (content): Merge conflict in arch/x86/kernel/vmlinux.lds.S
Merging rcu/rcu/next
Merging oprofile/for-next
Merging xen-two/linux-next
CONFLICT (content): Merge conflict in arch/x86/pci/xen.c
Applying: xen: fixup for set_irq_msi to irq_set_msi_desc change
Merging xen-pvhvm/linux-next
Merging edac-amd/for-next
CONFLICT (content): Merge conflict in include/linux/pci_ids.h
Merging percpu/for-next
Merging workqueues/for-next
CONFLICT (content): Merge conflict in fs/aio.c
Merging sfi/sfi-test
Merging asm-generic/next
Merging drivers-x86/linux-next
Applying: OLPC: fix for removal of run_wake_count
Merging hwpoison/hwpoison
Merging sysctl/master
Merging driver-core/driver-core-next
Merging tty/tty-next
CONFLICT (content): Merge conflict in drivers/misc/pch_phub.c
CONFLICT (content): Merge conflict in drivers/tty/serial/Kconfig
CONFLICT (content): Merge conflict in drivers/tty/serial/Makefile
Merging usb/usb-next
CONFLICT (content): Merge conflict in arch/arm/mach-omap2/board-omap3evm.c
CONFLICT (content): Merge conflict in arch/arm/mach-omap2/board-overo.c
CONFLICT (content): Merge conflict in arch/arm/mach-omap2/clock3xxx_data.c
CONFLICT (content): Merge conflict in arch/arm/mach-omap2/usb-musb.c
CONFLICT (content): Merge conflict in arch/arm/plat-omap/include/plat/usb.h
CONFLICT (content): Merge conflict in drivers/usb/gadget/Kconfig
CONFLICT (content): Merge conflict in drivers/usb/gadget/fsl_mxc_udc.c
CONFLICT (content): Merge conflict in drivers/usb/musb/musb_core.h
Merging staging/staging-next
CONFLICT (content): Merge conflict in drivers/staging/Kconfig
CONFLICT (content): Merge conflict in drivers/staging/Makefile
CONFLICT (content): Merge conflict in drivers/staging/brcm80211/brcmsmac/wl=
_mac80211.c
CONFLICT (delete/modify): drivers/staging/dabusb/dabusb.c deleted in HEAD a=
nd modified in staging/staging-next. Version staging/staging-next of driver=
s/staging/dabusb/dabusb.c left in tree.
CONFLICT (delete/modify): drivers/staging/dabusb/dabusb.h deleted in HEAD a=
nd modified in staging/staging-next. Version staging/staging-next of driver=
s/staging/dabusb/dabusb.h left in tree.
CONFLICT (content): Merge conflict in drivers/staging/easycap/easycap_ioctl=
.c
CONFLICT (delete/modify): drivers/staging/usbvideo/usbvideo.c deleted in HE=
AD and modified in staging/staging-next. Version staging/staging-next of dr=
ivers/staging/usbvideo/usbvideo.c left in tree.
CONFLICT (delete/modify): drivers/staging/usbvideo/vicam.c deleted in HEAD =
and modified in staging/staging-next. Version staging/staging-next of drive=
rs/staging/usbvideo/vicam.c left in tree.
$ git rm -f drivers/staging/usbvideo/usbvideo.c
$ git rm -f drivers/staging/usbvideo/vicam.c
$ git rm -f drivers/staging/dabusb/dabusb.c drivers/staging/dabusb/dabusb.h
Merging slabh/slabh
Merging bkl-config/config
Applying: nfs: BKL is no longer needed, so remove the include
Merging cleancache/linux-next
CONFLICT (content): Merge conflict in fs/ocfs2/super.c
CONFLICT (content): Merge conflict in fs/super.c
CONFLICT (content): Merge conflict in include/linux/fs.h
CONFLICT (content): Merge conflict in mm/Kconfig
Merging scsi-post-merge/merge-base:master
$ git checkout scsi-post-merge/master
[master 68e17d8] Revert "hwmon: New driver for SMSC SCH5627"

--Signature=_Tue__15_Mar_2011_19_45_43_+1100_2biFMq3GceLlZ+8A
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNfyc3AAoJEDMEi1NhKgbsKR8H/jSxZvxZvphY94SUcfXtSCOx
qNjIpHg3pEpFxoMyQnV0WJdKTQLzZORVfuyInJQSA6Uh6RVynhdZMB4WzK7ALAUD
Q8MyD7A+X8OC+dGGak6s6+0Qs6vFlWIyXaWGDqPeJy4FSOgZIV6pjXiE7VfdDQQ6
nYMahRU0WegMc2RdxeBL2AmTgPC/WUzDzJgPEuCn37ydi0VObAqJTu4/SENdtFld
Qvw1lLFYZAxxNBbV5ptSxnoCovtCF3JVXav7Io49yCq135BJQWR5o53DnbtugQsK
IGexF7VKBmOKvHlc4QOfswRxEVSeTITJ0Ua8Uv8G+nNbYUBudL9Vz4fFWCMxuC4=
=1/LQ
-----END PGP SIGNATURE-----

--Signature=_Tue__15_Mar_2011_19_45_43_+1100_2biFMq3GceLlZ+8A--

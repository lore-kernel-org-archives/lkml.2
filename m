Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372Ab1GPO2R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 10:28:17 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:49216 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755310Ab1GPO2P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 10:28:15 -0400
Date: Sun, 17 Jul 2011 00:28:06 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for July 16
Message-Id: <20110717002806.0f377c296e6b49019ba92372@canb.auug.org.au>
In-Reply-To: <20110717000815.c83755be9598d34ac8431908@canb.auug.org.au>
References: <20110717000815.c83755be9598d34ac8431908@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sun__17_Jul_2011_00_28_06_+1000_QnGXxUrFbi8lC5v3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__17_Jul_2011_00_28_06_+1000_QnGXxUrFbi8lC5v3
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

sent a little early, sorry.

On Sun, 17 Jul 2011 00:08:15 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Changes since 20110707:

The powerpc allyesconfig build fails for now.

> New trees: arm-soc, openrisc and .

... regmap

> Dropped tree: arm-soc.
> =09
> The pci-current tree lost its build failure.
>=20
> The arm-soc tree has complex conflicts against the arm tree so I have
> dropped it for today.
>=20
> The arm-lpae tree lost a conflict.
>=20
> The vfs tree gained some build failures so I used the version from
> next-20110707 and then added a couple of patches.
>=20
> The jdelvare-hwmon tree gained a build failure so I used the version from
> next-20110707.
>=20
> The idle-test tree lost its conflict.
>=20
> The net tree lost a conflict.
>=20
> The rr tree lost its build failure and gained a conflict against the
> openrisc tree.
>=20
> The block tree lost its build failure.
>=20
> The mmc tree gained a build failure so I used the version from
> next-20110707.
>=20
> The security-testing tree gained a build failure that I have left.
>=20
> The gpio tree gained conflicts against the i.MX tree.
>=20
> The tip tree gained a conflict against the of-pci tree.
>=20
> The rcu tree gained a conflict agains the ext4 tree.
>=20
> The staging tree lost its build failure but gained conflicts agains the
> trivial and v4l-dvb trees and another 2 build failures so I have used the
> version from next-20110707.
>=20
> The akpm tree lost its build failures.
>=20
> -------------------------------------------------------------------------=
---
>=20
> I have created today's linux-next tree at
> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
> (patches at http://www.kernel.org/pub/linux/kernel/v2.6/next/ ).  If you
> are tracking the linux-next tree using git, you should not use "git pull"
> to do so as that will try to merge the new linux-next release with the
> old one.  You should use "git fetch" as mentioned in the FAQ on the wiki
> (see below).
>=20
> You can see which trees have been included by looking in the Next/Trees
> file in the source.  There are also quilt-import.log and merge.log files
> in the Next directory.  Between each merge, the tree was built with
> a ppc64_defconfig for powerpc and an allmodconfig for x86_64. After the
> final fixups (if any), it is also built with powerpc allnoconfig (32 and
> 64 bit), ppc44x_defconfig and allyesconfig (minus
> CONFIG_PROFILE_ALL_BRANCHES - this fails its final link) and i386, sparc
> and sparc64 defconfig. These builds also have
> CONFIG_ENABLE_WARN_DEPRECATED, CONFIG_ENABLE_MUST_CHECK and
> CONFIG_DEBUG_INFO disabled when necessary.
>=20
> Below is a summary of the state of the merge.
>=20
> We are up to 195 trees (counting Linus' and 28 trees of patches pending

198 trees.

> for Linus' tree), more are welcome (even if they are currently empty).
> Thanks to those who have contributed, and to those who haven't, please do.
>=20
> Status of my local build tests will be at
> http://kisskb.ellerman.id.au/linux-next .  If maintainers want to give
> advice about cross compilers/configs that work, we are always open to add
> more builds.
>=20
> Thanks to Randy Dunlap for doing many randconfig builds.
>=20
> There is a wiki covering stuff to do with linux-next at
> http://linux.f-seidel.de/linux-next/pmwiki/ .  Thanks to Frank Seidel.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

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
Merging arm-soc/master
CONFLICT (content): Merge conflict in arch/arm/include/asm/assembler.h
CONFLICT (delete/modify): arch/arm/include/asm/suspend.h deleted in arm-soc=
/master and modified in HEAD. Version HEAD of arch/arm/include/asm/suspend.=
h left in tree.
CONFLICT (content): Merge conflict in arch/arm/kernel/sleep.S
CONFLICT (content): Merge conflict in arch/arm/mach-exynos4/pm.c
CONFLICT (content): Merge conflict in arch/arm/mach-omap2/pm34xx.c
CONFLICT (content): Merge conflict in arch/arm/mach-omap2/sleep34xx.S
CONFLICT (content): Merge conflict in arch/arm/mach-pxa/include/mach/pm.h
CONFLICT (content): Merge conflict in arch/arm/mach-pxa/pxa3xx.c
CONFLICT (content): Merge conflict in arch/arm/mach-s3c2412/pm.c
CONFLICT (content): Merge conflict in arch/arm/mach-s3c2416/pm.c
CONFLICT (content): Merge conflict in arch/arm/mach-s3c64xx/pm.c
CONFLICT (content): Merge conflict in arch/arm/mach-sa1100/pm.c
CONFLICT (content): Merge conflict in arch/arm/mm/proc-v7.S
CONFLICT (content): Merge conflict in arch/arm/plat-samsung/include/plat/pm=
.h
CONFLICT (content): Merge conflict in arch/arm/plat-samsung/pm.c
$ git reset --hard
Merging arm-lpae/for-next
CONFLICT (content): Merge conflict in arch/arm/include/asm/pgalloc.h
CONFLICT (content): Merge conflict in arch/arm/include/asm/pgtable.h
CONFLICT (content): Merge conflict in arch/arm/include/asm/proc-fns.h
CONFLICT (content): Merge conflict in arch/arm/include/asm/tlb.h
CONFLICT (content): Merge conflict in arch/arm/mm/context.c
CONFLICT (content): Merge conflict in arch/arm/mm/proc-v7.S
Merging at91/at91-next
Merging davinci/davinci-next
Merging i.MX/for-next
CONFLICT (content): Merge conflict in arch/arm/plat-mxc/devices/platform-im=
x-dma.c
Merging linux-spec/for-next
Merging msm/for-next
Merging omap/for-next
Merging pxa/for-next
Merging samsung/next-samsung
Merging s5p/for-next
Merging tegra/for-next
Merging ux500-core/ux500-core
Merging xilinx/arm-next
Merging blackfin/for-linus
Merging cris/for-next
Merging ia64/test
Merging m68k/for-next
Merging m68knommu/for-next
Merging microblaze/next
Merging mips/mips-for-linux-next
Merging openrisc/for-upstream
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
CONFLICT (content): Merge conflict in fs/ceph/export.c
Merging cifs/master
Merging configfs/linux-next
Merging ecryptfs/next
Merging ext3/for_next
Merging ext4/dev
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
$ git reset --hard HEAD^
Merging refs/next/20110707/vfs
Applying: vfs/nfs: fixup for nfs_open_context change
[master 7644789] Merge commit 'refs/next/20110707/vfs'
Applying: vfs/nfs: another fixup for nfs_open_context change
[master c88e0a5] Merge commit 'refs/next/20110707/vfs'
Merging vfs-scale/vfs-scale-working
Merging pci/linux-next
Merging of-pci/of-pci
Merging hid/for-next
Merging quilt/i2c
Merging bjdooks-i2c/next-i2c
Merging quilt/jdelvare-hwmon
$ git reset --hard HEAD^
Merging refs/next/20110707/jdelvare-hwmon
Merging hwmon-staging/hwmon-next
Merging quilt/kernel-doc
Merging docs/docs-move
Merging v4l-dvb/master
Merging kbuild/for-next
Merging kconfig/for-next
Merging ide/master
Merging libata/NEXT
CONFLICT (content): Merge conflict in drivers/ata/libahci.c
Merging infiniband/for-next
Merging acpi/test
CONFLICT (content): Merge conflict in arch/ia64/Kconfig
CONFLICT (content): Merge conflict in arch/powerpc/Kconfig
Merging idle-test/idle-test
Merging powertools/tools-test
Merging cpupowerutils/master
Merging ieee1394/for-next
Merging ubi/linux-next
Merging dlm/next
Merging swiotlb/master
Merging ibft/master
Merging scsi/master
Merging slave-dma/next
Merging async_tx/next
Merging net/master
CONFLICT (content): Merge conflict in drivers/Makefile
CONFLICT (content): Merge conflict in drivers/scsi/bnx2fc/bnx2fc.h
CONFLICT (content): Merge conflict in drivers/scsi/bnx2fc/bnx2fc_fcoe.c
CONFLICT (content): Merge conflict in lib/Kconfig
CONFLICT (content): Merge conflict in lib/Makefile
Merging wireless/master
Merging bluetooth/master
Merging mtd/master
Merging l2-mtd/master
Merging crypto/master
Merging sound/for-next
Merging sound-asoc/for-next
Merging cpufreq/next
Merging quilt/rr
CONFLICT (delete/modify): arch/m68k/kernel/module_mm.c deleted in HEAD and =
modified in quilt/rr. Version quilt/rr of arch/m68k/kernel/module_mm.c left=
 in tree.
CONFLICT (content): Merge conflict in arch/openrisc/kernel/module.c
$ git rm -f arch/m68k/kernel/module_mm.c
Applying: modules/m68k: make arch's use default loader hooks
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
CONFLICT (content): Merge conflict in drivers/mmc/card/queue.c
CONFLICT (content): Merge conflict in drivers/mmc/core/mmc.c
CONFLICT (content): Merge conflict in drivers/mmc/host/omap_hsmmc.c
CONFLICT (delete/modify): drivers/mmc/host/sdhci-of-core.c deleted in mmc/m=
mc-next and modified in HEAD. Version HEAD of drivers/mmc/host/sdhci-of-cor=
e.c left in tree.
$ git rm -f drivers/mmc/host/sdhci-of-core.c
$ git reset --hard HEAD^
Merging refs/next/20110707/mmc
CONFLICT (delete/modify): drivers/mmc/host/sdhci-of-core.c deleted in refs/=
next/20110707/mmc and modified in HEAD. Version HEAD of drivers/mmc/host/sd=
hci-of-core.c left in tree.
$ git rm -f drivers/mmc/host/sdhci-of-core.c
[master bd89759] Merge commit 'refs/next/20110707/mmc'
Merging kgdb/kgdb-next
Merging slab/for-next
Merging uclinux/for-next
Merging md/for-next
Merging mfd/for-next
CONFLICT (content): Merge conflict in drivers/mfd/Makefile
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
CONFLICT (content): Merge conflict in Documentation/feature-removal-schedul=
e.txt
CONFLICT (delete/modify): arch/arm/mach-ep93xx/dma-m2p.c deleted in HEAD an=
d modified in trivial/for-next. Version trivial/for-next of arch/arm/mach-e=
p93xx/dma-m2p.c left in tree.
CONFLICT (content): Merge conflict in drivers/dma/mv_xor.c
CONFLICT (content): Merge conflict in drivers/mtd/maps/pxa2xx-flash.c
$ git rm -f arch/arm/mach-ep93xx/dma-m2p.c
Merging audit/for-next
Merging suspend/linux-next
Merging apm/for-next
Merging fsnotify/for-next
Merging irda/for-next
Merging i7core_edac/linux_next
Merging i7300_edac/linux_next
Merging devicetree/devicetree/next
Merging spi/spi/next
Merging gpio/gpio/next
CONFLICT (content): Merge conflict in arch/arm/mach-ep93xx/Makefile
CONFLICT (content): Merge conflict in arch/arm/mach-imx/mm-imx1.c
CONFLICT (content): Merge conflict in arch/arm/mach-imx/mm-imx21.c
CONFLICT (content): Merge conflict in arch/arm/mach-imx/mm-imx25.c
CONFLICT (content): Merge conflict in arch/arm/mach-imx/mm-imx27.c
CONFLICT (content): Merge conflict in arch/arm/mach-imx/mm-imx31.c
CONFLICT (content): Merge conflict in arch/arm/mach-imx/mm-imx35.c
CONFLICT (content): Merge conflict in arch/arm/mach-mx5/mm.c
CONFLICT (content): Merge conflict in drivers/gpio/Makefile
CONFLICT (content): Merge conflict in drivers/gpio/gpio-ep93xx.c
Merging tip/auto-latest
CONFLICT (content): Merge conflict in arch/x86/Kconfig
CONFLICT (content): Merge conflict in drivers/Kconfig
CONFLICT (content): Merge conflict in drivers/Makefile
CONFLICT (content): Merge conflict in include/linux/pci.h
Merging rcu/rcu/next
CONFLICT (content): Merge conflict in fs/jbd2/journal.c
Merging kvm/linux-next
Merging oprofile/for-next
Merging ptrace/ptrace
Merging xen/upstream/xen
Merging xen-two/linux-next
Merging xen-pvhvm/linux-next
Merging edac-amd/for-next
Merging percpu/for-next
Merging workqueues/for-next
CONFLICT (content): Merge conflict in Documentation/feature-removal-schedul=
e.txt
Merging sfi/sfi-test
Merging asm-generic/next
Merging drivers-x86/linux-next
CONFLICT (content): Merge conflict in Documentation/feature-removal-schedul=
e.txt
Merging hwpoison/hwpoison
Merging sysctl/master
Merging namespace/master
Merging regmap/for-next
CONFLICT (content): Merge conflict in drivers/spi/Makefile
Merging driver-core/driver-core-next
Merging tty/tty-next
Merging usb/usb-next
CONFLICT (content): Merge conflict in Documentation/feature-removal-schedul=
e.txt
Merging staging/staging-next
CONFLICT (content): Merge conflict in Documentation/feature-removal-schedul=
e.txt
CONFLICT (content): Merge conflict in drivers/staging/bcm/headers.h
CONFLICT (content): Merge conflict in drivers/staging/brcm80211/brcmfmac/dh=
d_linux.c
CONFLICT (content): Merge conflict in drivers/staging/brcm80211/brcmfmac/dh=
d_sdio.c
CONFLICT (content): Merge conflict in drivers/staging/brcm80211/brcmfmac/wl=
_cfg80211.h
CONFLICT (delete/modify): drivers/staging/brcm80211/brcmfmac/wl_iw.c delete=
d in staging/staging-next and modified in HEAD. Version HEAD of drivers/sta=
ging/brcm80211/brcmfmac/wl_iw.c left in tree.
CONFLICT (delete/modify): drivers/staging/generic_serial/ser_a2232.c delete=
d in staging/staging-next and modified in HEAD. Version HEAD of drivers/sta=
ging/generic_serial/ser_a2232.c left in tree.
CONFLICT (content): Merge conflict in drivers/staging/rtl8187se/ieee80211/i=
eee80211_softmac.c
CONFLICT (content): Merge conflict in drivers/staging/rtl8192e/r8192E.h
CONFLICT (content): Merge conflict in drivers/staging/tm6000/tm6000-alsa.c
CONFLICT (content): Merge conflict in drivers/staging/usbip/userspace/src/u=
tils.h
CONFLICT (delete/modify): drivers/staging/westbridge/astoria/arch/arm/plat-=
omap/include/mach/westbridge/westbridge-omap3-pnand-hal/cyashalomap_kernel.=
h deleted in staging/staging-next and modified in HEAD. Version HEAD of dri=
vers/staging/westbridge/astoria/arch/arm/plat-omap/include/mach/westbridge/=
westbridge-omap3-pnand-hal/cyashalomap_kernel.h left in tree.
CONFLICT (delete/modify): drivers/staging/westbridge/astoria/gadget/cyasgad=
get.h deleted in staging/staging-next and modified in HEAD. Version HEAD of=
 drivers/staging/westbridge/astoria/gadget/cyasgadget.h left in tree.
$ git rm -f drivers/staging/generic_serial/ser_a2232.c
$ git rm -f drivers/staging/brcm80211/brcmfmac/wl_iw.c
$ git rm -f drivers/staging/westbridge/astoria/arch/arm/plat-omap/include/m=
ach/westbridge/westbridge-omap3-pnand-hal/cyashalomap_kernel.h drivers/stag=
ing/westbridge/astoria/gadget/cyasgadget.h
[master 6a30e64] Revert "gma500: Fix dependencies"
$ git reset --hard HEAD^
$ git reset --hard HEAD^
Merging refs/next/20110707/staging
CONFLICT (content): Merge conflict in Documentation/feature-removal-schedul=
e.txt
CONFLICT (content): Merge conflict in drivers/staging/bcm/headers.h
CONFLICT (content): Merge conflict in drivers/staging/brcm80211/brcmfmac/dh=
d_linux.c
CONFLICT (content): Merge conflict in drivers/staging/brcm80211/brcmfmac/dh=
d_sdio.c
CONFLICT (content): Merge conflict in drivers/staging/brcm80211/brcmfmac/wl=
_cfg80211.h
CONFLICT (delete/modify): drivers/staging/brcm80211/brcmfmac/wl_iw.c delete=
d in refs/next/20110707/staging and modified in HEAD. Version HEAD of drive=
rs/staging/brcm80211/brcmfmac/wl_iw.c left in tree.
CONFLICT (content): Merge conflict in drivers/staging/rtl8187se/ieee80211/i=
eee80211_softmac.c
CONFLICT (content): Merge conflict in drivers/staging/rtl8192e/r8192E.h
CONFLICT (content): Merge conflict in drivers/staging/tm6000/tm6000-alsa.c
CONFLICT (content): Merge conflict in drivers/staging/usbip/userspace/src/u=
tils.h
$ git rm -f drivers/staging/brcm80211/brcmfmac/wl_iw.c
[master b190f9f] Merge commit 'refs/next/20110707/staging'
Merging bkl-config/config
Merging tmem/linux-next
Merging writeback/next
Merging arm-dt/devicetree/arm-next
Merging scsi-post-merge/merge-base:master
$ git checkout akpm
Applying: During allocator-intensive workloads, kswapd will be woken freque=
ntly
Applying: During allocator-intensive workloads, kswapd will be woken freque=
ntly
CONFLICT (content): Merge conflict in mm/vmscan.c
Merging akpm

--Signature=_Sun__17_Jul_2011_00_28_06_+1000_QnGXxUrFbi8lC5v3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOIZ/2AAoJEDMEi1NhKgbsLlUH/0122Nyy/phXUcl4iZzXapDJ
5HtxEL1+4l5zyAlmvW1eCGtGkvq4vJc1R5ZCSO9aaETn3Dc7Bz33aK5D1en8JXd/
PflyDGJqXyNP6n1c8qD4qTRYrlKTb14XZyiiOlJmEYz1PbUlwaBfWn3XkNVDPRoY
OiakzEOpOAM26slotGfSUhM72ImX1WPHT1F36J5FBDVlUCoI2TveFMbwJkFT4f3K
tvgkZzseE1W/JD8rL8oeaLhjKSFOFPvO560MPgPTRxlkqMpgERtm2haGcktGdlrN
dRiGAl6b1TS/7fSHWcdmusrF0ShAoyNqWARMEpWRjrKSHSh+Q7dF/Msa0oPxRt4=
=VGlc
-----END PGP SIGNATURE-----

--Signature=_Sun__17_Jul_2011_00_28_06_+1000_QnGXxUrFbi8lC5v3--

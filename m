Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202Ab0JLFgA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 01:36:00 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:36838 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752655Ab0JLFf5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 01:35:57 -0400
Date: Tue, 12 Oct 2010 16:35:52 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for October 12
Message-Id: <20101012163552.7306165b.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__12_Oct_2010_16_35_52_+1100_Wtk+AxCUX/mB_bbE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__12_Oct_2010_16_35_52_+1100_Wtk+AxCUX/mB_bbE
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Note: for those that are interested in these things, there is a graph of
linux-next and Linus' tree progress at
http://neuling.org/linux-next-size.html .  You can zoom by selecting a
horizontal area.

Changes since 20101011:

The arm tree gained a conflict against the arm-current tree.

The net tree gained a conflict against the ieee1394.

The trivial tree gained a conflict against the net tree.

The catalin tree lost a conflict.

The oprofile tree gained conflicts against the tip tree.

The workqueues tree gained a conflict against the gfs2 tree.

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
CONFLICT (content): Merge conflict in arch/arm/mach-at91/include/mach/syste=
m.h
CONFLICT (content): Merge conflict in arch/arm/mach-imx/mach-cpuimx27.c
Merging davinci/davinci-next
Merging i.MX/for-next
CONFLICT (content): Merge conflict in arch/arm/mach-mx25/clock.c
CONFLICT (content): Merge conflict in arch/arm/plat-mxc/devices/Kconfig
CONFLICT (content): Merge conflict in arch/arm/plat-mxc/devices/Makefile
CONFLICT (add/add): Merge conflict in arch/arm/plat-mxc/devices/platform-im=
x-dma.c
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
Applying: xfs: fix up mismerge of __xfs_inode_clear_reclaim_tag
Merging vfs/for-next
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
CONFLICT (content): Merge conflict in virt/kvm/kvm_main.c
Merging dlm/next
Merging swiotlb/master
Merging swiotlb-xen/master
Merging ibft/master
Merging scsi/master
Merging async_tx/next
Merging wireless/master
CONFLICT (content): Merge conflict in Documentation/feature-removal-schedul=
e.txt
CONFLICT (content): Merge conflict in arch/arm/mach-omap2/board-omap3pandor=
a.c
CONFLICT (content): Merge conflict in arch/arm/mach-omap2/board-zoom-periph=
erals.c
CONFLICT (content): Merge conflict in drivers/net/wireless/libertas/if_sdio=
.c
Merging net/master
CONFLICT (content): Merge conflict in Documentation/feature-removal-schedul=
e.txt
CONFLICT (delete/modify): drivers/ieee1394/eth1394.c deleted in HEAD and mo=
dified in net/master. Version net/master of drivers/ieee1394/eth1394.c left=
 in tree.
$ git rm -f drivers/ieee1394/eth1394.c
Merging mtd/master
Merging crypto/master
CONFLICT (content): Merge conflict in arch/arm/mach-omap2/devices.c
Merging sound-asoc/for-next
CONFLICT (content): Merge conflict in arch/arm/mach-s3c64xx/dev-audio.c
CONFLICT (content): Merge conflict in drivers/video/sh_mobile_hdmi.c
Merging sound/for-next
Merging cpufreq/next
Merging quilt/rr
Merging input/next
CONFLICT (content): Merge conflict in drivers/input/keyboard/Kconfig
Merging lsm/for-next
Merging block/for-next
CONFLICT (content): Merge conflict in fs/ext4/mballoc.c
Applying: ext4: merge fix for blkdev_issue_zeroout API change
Merging quilt/device-mapper
Merging embedded/master
Merging firmware/master
Merging pcmcia/master
CONFLICT (content): Merge conflict in drivers/net/pcmcia/smc91c92_cs.c
Merging battery/master
Merging leds/for-mm
Merging backlight/for-mm
Merging mmc/mmc-next
Merging kgdb/kgdb-next
CONFLICT (content): Merge conflict in drivers/char/sysrq.c
Merging slab/for-next
Merging uclinux/for-next
Merging md/for-next
Merging mfd/for-next
CONFLICT (content): Merge conflict in drivers/mfd/sh_mobile_sdhi.c
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
CONFLICT (content): Merge conflict in net/irda/irnet/irnet_ppp.c
Merging audit/for-next
Merging quilt/aoe
Merging suspend/linux-next
Merging bluetooth/master
Merging fsnotify/for-next
Merging irda/for-next
Merging catalin/for-next
CONFLICT (content): Merge conflict in arch/arm/kernel/Makefile
CONFLICT (content): Merge conflict in arch/arm/mach-vexpress/ct-ca9x4.c
CONFLICT (content): Merge conflict in arch/arm/mm/flush.c
Merging alacrity/linux-next
CONFLICT (content): Merge conflict in include/linux/Kbuild
Merging i7core_edac/linux_next
CONFLICT (content): Merge conflict in MAINTAINERS
Merging i7300_edac/linux_next
Merging devicetree/next-devicetree
Merging spi/next-spi
Merging omap_dss2/for-next
Merging xen/upstream/xen
Merging rcu/rcu/next
Merging tip/auto-latest
CONFLICT (content): Merge conflict in include/linux/percpu.h
CONFLICT (content): Merge conflict in net/core/dev.c
Merging edac-amd/for-next
Merging oprofile/for-next
CONFLICT (content): Merge conflict in arch/arm/oprofile/common.c
CONFLICT (content): Merge conflict in kernel/perf_event.c
Applying: perf events: fix up merge conflict
Merging percpu/for-next
CONFLICT (content): Merge conflict in include/linux/percpu.h
CONFLICT (content): Merge conflict in mm/percpu.c
Merging workqueues/for-next
CONFLICT (content): Merge conflict in fs/gfs2/main.c
Merging sfi/sfi-test
Merging asm-generic/next
Merging drivers-x86/linux-next
Merging hwpoison/hwpoison
Merging sysctl/master
Merging quilt/driver-core
CONFLICT (content): Merge conflict in drivers/misc/Makefile
Merging quilt/tty
Merging quilt/usb
CONFLICT (content): Merge conflict in drivers/usb/gadget/rndis.c
Merging staging-next/staging-next
CONFLICT (rename/modify): Merge conflict in drivers/misc/ti-st/st_kim.c
CONFLICT (content): Merge conflict in arch/arm/plat-omap/devices.c
CONFLICT (content): Merge conflict in drivers/misc/Makefile
CONFLICT (content): Merge conflict in drivers/staging/Makefile
CONFLICT (content): Merge conflict in drivers/staging/batman-adv/hard-inter=
face.c
CONFLICT (delete/modify): drivers/staging/mrst-touchscreen/Makefile deleted=
 in HEAD and modified in staging-next/staging-next. Version staging-next/st=
aging-next of drivers/staging/mrst-touchscreen/Makefile left in tree.
CONFLICT (delete/modify): drivers/staging/mrst-touchscreen/intel-mid-touch.=
c deleted in HEAD and modified in staging-next/staging-next. Version stagin=
g-next/staging-next of drivers/staging/mrst-touchscreen/intel-mid-touch.c l=
eft in tree.
CONFLICT (delete/modify): drivers/staging/ti-st/st_core.h deleted in stagin=
g-next/staging-next and modified in HEAD. Version HEAD of drivers/staging/t=
i-st/st_core.h left in tree.
$ git rm -f drivers/staging/mrst-touchscreen/Makefile drivers/staging/mrst-=
touchscreen/intel-mid-touch.c
$ git rm -f drivers/staging/ti-st/st.h drivers/staging/ti-st/st_core.h
Applying: staging: ath6kl: Fixing the driver to use modified mmc_host struc=
ture
Merging slabh/slabh
Merging bkl-trivial/trivial
CONFLICT (content): Merge conflict in drivers/block/ataflop.c
CONFLICT (content): Merge conflict in drivers/char/pcmcia/cm4000_cs.c
CONFLICT (content): Merge conflict in drivers/char/pcmcia/cm4040_cs.c
CONFLICT (content): Merge conflict in drivers/mmc/card/block.c
Merging bkl-llseek/llseek
CONFLICT (content): Merge conflict in drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
CONFLICT (content): Merge conflict in drivers/infiniband/hw/cxgb4/device.c
Merging bkl-vfs/vfs
CONFLICT (content): Merge conflict in fs/cifs/cifsfs.c
CONFLICT (content): Merge conflict in fs/nilfs2/super.c
Merging bkl-config/config
CONFLICT (content): Merge conflict in fs/compat_ioctl.c
Merging irqflags/master
Merging cleancache/linux-next
CONFLICT (content): Merge conflict in include/linux/fs.h
CONFLICT (content): Merge conflict in mm/Kconfig
Merging scsi-post-merge/merge-base:master

--Signature=_Tue__12_Oct_2010_16_35_52_+1100_Wtk+AxCUX/mB_bbE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMs/O4AAoJEDMEi1NhKgbsJZYH/i9Mfl1IbnFqM1hFJ8t9zdz1
fJpyC0fzHIXivanlC9FOz6/omTqAG1LQiOY5fPFdOWFC1itBcIk/LRkwSm0quc5l
J23IgJml5IK2CwnNBMT86rMuBXXIitaaxyLiIKCooXvv/25WDJVfwbqq/tn+GBAw
QQjIst/twxpjNzZcNxQNv302bsmjq109QDY3deNQrNFScoSsMCXm0nLDQEn6H0dq
9r4DG1g+Iux5nL+H5tXipOhZA2fL6OlpxgutSoCfm6ix3te4cD279q3ABdUA11g7
b7W/eaxMI+PrwrYSIwrZCt0a+VfiTkIceb1Lcc5jt3qx0r+4hlYpUQ2Zxuopv9o=
=qs97
-----END PGP SIGNATURE-----

--Signature=_Tue__12_Oct_2010_16_35_52_+1100_Wtk+AxCUX/mB_bbE--

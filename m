Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368Ab0JDAgs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 20:36:48 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:38997 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751425Ab0JDAgr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 20:36:47 -0400
Date: Mon, 4 Oct 2010 11:36:38 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for October 4
Message-Id: <20101004113638.a7f8517b.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__4_Oct_2010_11_36_38_+1100_g6w.LXJpA/c.BV=y"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__4_Oct_2010_11_36_38_+1100_g6w.LXJpA/c.BV=y
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

This tree is not as well tested as others since it was only built after
all the merges had been done.

Changes since 20101001:

New tree: hfsplus

The drm tree gained conflicts against Linus' tree.

The v4l-dvb tree lost its build failure and conflicts.

The oprofile tree lost a conflict.

The hwpoison tree still has its build failure so I used the version from
next-20100924.

The bkl-trivial tree gained a conflict against the hfsplus tree.

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
CONFLICT (content): Merge conflict in arch/arm/mm/mmu.c
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
CONFLICT (content): Merge conflict in arch/powerpc/platforms/85xx/mpc85xx_m=
ds.c
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
Merging vfs/for-next
Merging pci/linux-next
Merging hid/for-next
Merging quilt/i2c
Merging bjdooks-i2c/next-i2c
Merging quilt/jdelvare-hwmon
CONFLICT (content): Merge conflict in MAINTAINERS
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
Merging swiotlb-xen/master
Merging ibft/master
Merging scsi/master
Merging async_tx/next
Merging wireless/master
CONFLICT (content): Merge conflict in arch/arm/mach-omap2/board-omap3pandor=
a.c
CONFLICT (content): Merge conflict in arch/arm/mach-omap2/board-zoom-periph=
erals.c
CONFLICT (content): Merge conflict in drivers/net/wireless/libertas/if_sdio=
.c
Merging net/master
CONFLICT (content): Merge conflict in drivers/net/pcmcia/pcnet_cs.c
CONFLICT (content): Merge conflict in net/ipv4/Kconfig
CONFLICT (content): Merge conflict in net/ipv4/tcp_timer.c
Merging mtd/master
Merging crypto/master
CONFLICT (content): Merge conflict in arch/arm/mach-omap2/devices.c
Merging sound-asoc/for-next
CONFLICT (content): Merge conflict in drivers/video/sh_mobile_hdmi.c
Merging sound/for-next
Merging cpufreq/next
Merging quilt/rr
Merging input/next
CONFLICT (content): Merge conflict in drivers/input/keyboard/Kconfig
Merging lsm/for-next
Merging block/for-next
CONFLICT (content): Merge conflict in fs/ext4/mballoc.c
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
Merging slab/for-next
Merging uclinux/for-next
Merging md/for-next
Merging mfd/for-next
CONFLICT (content): Merge conflict in drivers/mfd/sh_mobile_sdhi.c
Merging hdlc/hdlc-next
Merging drm/drm-next
CONFLICT (content): Merge conflict in drivers/gpu/drm/drm_gem.c
CONFLICT (content): Merge conflict in drivers/gpu/drm/radeon/atombios_crtc.c
CONFLICT (content): Merge conflict in drivers/gpu/drm/radeon/radeon_legacy_=
crtc.c
CONFLICT (content): Merge conflict in drivers/gpu/drm/radeon/radeon_mode.h
CONFLICT (content): Merge conflict in include/drm/drmP.h
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
CONFLICT (content): Merge conflict in arch/arm/include/asm/smp_plat.h
CONFLICT (content): Merge conflict in arch/arm/kernel/Makefile
CONFLICT (content): Merge conflict in arch/arm/mach-vexpress/ct-ca9x4.c
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
Merging lost-spurious-irq/lost-spurious-irq
CONFLICT (content): Merge conflict in drivers/ata/libata-core.c
CONFLICT (content): Merge conflict in include/linux/libata.h
Merging edac-amd/for-next
Merging oprofile/for-next
Merging percpu/for-next
CONFLICT (content): Merge conflict in include/linux/percpu.h
CONFLICT (content): Merge conflict in mm/percpu.c
Merging workqueues/for-next
Merging sfi/sfi-test
Merging asm-generic/next
Merging drivers-x86/linux-next
Merging hwpoison/hwpoison
$ git reset --hard HEAD^
Merging refs/next/20100924/hwpoison
Merging sysctl/master
Merging quilt/driver-core
CONFLICT (content): Merge conflict in drivers/misc/Makefile
Merging quilt/tty
Merging quilt/usb
CONFLICT (content): Merge conflict in drivers/usb/gadget/rndis.c
Merging staging-next/staging-next
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
CONFLICT (delete/modify): drivers/staging/ti-st/st.h deleted in staging-nex=
t/staging-next and modified in HEAD. Version HEAD of drivers/staging/ti-st/=
st.h left in tree.
CONFLICT (delete/modify): drivers/staging/ti-st/st_core.h deleted in stagin=
g-next/staging-next and modified in HEAD. Version HEAD of drivers/staging/t=
i-st/st_core.h left in tree.
CONFLICT (content): Merge conflict in drivers/staging/ti-st/st_kim.c
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
CONFLICT (content): Merge conflict in fs/hfsplus/ioctl.c
Merging bkl-llseek/llseek
CONFLICT (content): Merge conflict in drivers/infiniband/hw/cxgb4/device.c
Merging bkl-vfs/vfs
CONFLICT (content): Merge conflict in fs/nilfs2/super.c
Merging bkl-config/config
Merging irqflags/master
Merging cleancache/linux-next
CONFLICT (content): Merge conflict in include/linux/fs.h
CONFLICT (content): Merge conflict in mm/Kconfig
Merging scsi-post-merge/merge-base:master

--Signature=_Mon__4_Oct_2010_11_36_38_+1100_g6w.LXJpA/c.BV=y
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMqSGWAAoJEDMEi1NhKgbs7P0H/RlBR2wQuyyxkY7FGi3T61Fn
upGt80wRMWqWw9Wo1fkCZGmuCnH+VIF9Spoq2KWM5uml/0ouv8W5QaF05H43vCUr
WdUGxgeKJiJsyC26lHLer8iQ60DKm9OtUOJ//tUGGCQ/uYe+gGwHXyacZ23R2VCt
AQl1eMt55wHaG/RaxxVo8a6FfO9mQyHu3lF4cHhVuFE40hbUsPBhvpIvX6Lk0jbt
IyslPgNaUoWvnukrCBikGobLO8VCfKcaNXzDf/dscetneaBAG9pUOEQcMNfVs4ai
2pO/giBTSHa5PvRtGEi3FsepyNZOrSBXF0fQGhrCjeFKAhra6iXH7iBcbopdK2g=
=QZZP
-----END PGP SIGNATURE-----

--Signature=_Mon__4_Oct_2010_11_36_38_+1100_g6w.LXJpA/c.BV=y--

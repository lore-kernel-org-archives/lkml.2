Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623Ab0I1ESg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 00:18:36 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:57568 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624Ab0I1ESe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 00:18:34 -0400
Date: Tue, 28 Sep 2010 14:18:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for September 28
Message-Id: <20100928141823.8c61000e.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__28_Sep_2010_14_18_23_+1000_OH2Alk/a+a5qyy9A"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__28_Sep_2010_14_18_23_+1000_OH2Alk/a+a5qyy9A
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20100927:

New tree: hwmon-staging

The nfs tree lost its build failure.

The net tree lost 2 conflicts, but still has its build failure for which
I reverted 3 commits.

The hwpoison tree still has its build failure so I used the version from
next-20100924.

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

We are up to 175 trees (counting Linus' and 22 trees of patches pending
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
CONFLICT (content): Merge conflict in drivers/media/IR/ir-keytable.c
CONFLICT (content): Merge conflict in drivers/media/IR/ir-lirc-codec.c
CONFLICT (content): Merge conflict in drivers/media/IR/ir-raw-event.c
CONFLICT (add/add): Merge conflict in drivers/media/IR/streamzap.c
CONFLICT (content): Merge conflict in drivers/media/dvb/siano/smscoreapi.c
CONFLICT (add/add): Merge conflict in drivers/media/video/s5p-fimc/fimc-cor=
e.c
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
Merging net/master
CONFLICT (content): Merge conflict in arch/arm/mach-omap2/board-zoom-periph=
erals.c
CONFLICT (content): Merge conflict in drivers/net/pcmcia/pcnet_cs.c
[master 5a2eb3f] Revert "wl1271: make ref_clock configurable by board"
[master 64b0ef8] Revert "wl1271: take irq info from private board data"
[master 3ab3533] Revert "wl12xx: add platform data passing support"
Merging wireless/master
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
CONFLICT (content): Merge conflict in drivers/gpu/drm/radeon/atombios_crtc.c
CONFLICT (content): Merge conflict in drivers/gpu/drm/radeon/radeon_legacy_=
crtc.c
CONFLICT (content): Merge conflict in drivers/gpu/drm/radeon/radeon_mode.h
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
t/staging-next and modified in HEAD. Version HEAD of drivers/staging/tiReso=
lved 'drivers/staging/Makefile' using previous resolution.
CONFLICT (delete/modify): drivers/staging/ti-st/st_core.h deleted in stagin=
g-next/staging-next and modified in HEAD. Version HEAD of drivers/staging/t=
i-st/st_core.h left in tree.
CONFLICT (content): Merge conflict in drivers/staging/ti-st/st_kim.c
$ git rm -f drivers/staging/mrst-touchscreen/Makefile drivers/staging/mrst-=
touchscreen/intel-mid-touch.c
$ git rm -f drivers/staging/ti-st/st.h drivers/staging/ti-st/st_core.h
Merging slabh/slabh
Merging bkl-trivial/trivial
CONFLICT (content): Merge conflict in drivers/block/ataflop.c
CONFLICT (content): Merge conflict in drivers/char/pcmcia/cm4000_cs.c
CONFLICT (content): Merge conflict in drivers/char/pcmcia/cm4040_cs.c
CONFLICT (content): Merge conflict in drivers/mmc/card/block.c
Merging bkl-llseek/llseek
Merging bkl-vfs/vfs
CONFLICT (content): Merge conflict in fs/cifs/cifsfs.c
CONFLICT (content): Merge conflict in fs/nilfs2/super.c
Merging bkl-config/config
Merging irqflags/master
Merging scsi-post-merge/merge-base:master

--Signature=_Tue__28_Sep_2010_14_18_23_+1000_OH2Alk/a+a5qyy9A
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMoWyPAAoJEDMEi1NhKgbsFjoH/jqCq2O7XBBWtw1Qfj24uXXa
D9DJpD1IQfERz3vrolnOIRTmxeIqHHJ4JUXzQMh2XWKTIpddY9Ql71vEblg4ZxPn
79m0KL2+wtg/+WYnCwxQihO6YWG+MOUvn0lnkfb2t8s4fvnFqR5n3jzBPNn7dtYd
gUKiFa5MF6SCruUPFyeBXexNCrdd6xjEcuMpiGoTUmQcOno6VyLsCE5jpTWRS2lP
Lg9cKGlCixMekOoABKDQVp8JzU5Z7+9jGg5nQ8JbYrhelYpzasTS6uAn8SbZsAnE
WydUNhBUdhATbWS8jQJfj2qaLJGyZXVqU+/ReU6QYGKpztzaYt2R7OS3EX5gX6k=
=2bEt
-----END PGP SIGNATURE-----

--Signature=_Tue__28_Sep_2010_14_18_23_+1000_OH2Alk/a+a5qyy9A--

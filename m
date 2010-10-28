Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932924Ab0J1DUr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 23:20:47 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:59678 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756615Ab0J1DUp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 23:20:45 -0400
Date: Thu, 28 Oct 2010 14:20:31 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for October 28
Message-Id: <20101028142031.5a4d6612.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__28_Oct_2010_14_20_31_+1100_nH.50.tOIX5q3dio"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__28_Oct_2010_14_20_31_+1100_nH.50.tOIX5q3dio
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Reminder: do not add 2.6.38 destined stuff to linux-next until after
2.6.37-rc1 is released.

Reminder 2: if what you ask Linus to merge turns out to be a little
different from what you have in linux-next (or Linus' fixes things up a
little), please updtae your linux-next submission so I don't have to
worry about those differences.

Changes since 20101027:

The ext4 tree gained a conflict against Linus' tree.

The slab tree lost its build failure.

The drm tree lost its conflict.

The fsnotify tree gained a conflict against Linus' tree.

The xen tree lost a conflict.

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
Merging davinci/davinci-next
Merging i.MX/for-next
Merging msm/for-next
Merging omap/for-next
Merging pxa/for-next
Merging samsung/next-samsung
Merging s5p/for-next
CONFLICT (content): Merge conflict in arch/arm/mach-s3c64xx/dev-audio.c
Merging tegra/for-next
Merging avr32/avr32-arch
Merging blackfin/for-linus
Merging cris/for-next
Merging ia64/test
Merging m68k/for-next
Merging m68knommu/for-next
Merging microblaze/next
Merging mips/mips-for-linux-next
CONFLICT (content): Merge conflict in drivers/usb/host/Kconfig
CONFLICT (content): Merge conflict in drivers/usb/host/Makefile
Merging parisc/next
Merging powerpc/next
Merging 4xx/next
Merging 52xx-and-virtex/next
Merging galak/next
Merging s390/features
Merging sh/master
Merging genesis/master
CONFLICT (content): Merge conflict in drivers/video/sh_mobile_hdmi.c
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
CONFLICT (content): Merge conflict in fs/ext4/inode.c
CONFLICT (content): Merge conflict in fs/ext4/mballoc.c
Applying: ext4: merge fix for blkdev_issue_zeroout API change
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
Merging hwmon-staging/hwmon-next
Merging quilt/kernel-doc
CONFLICT (content): Merge conflict in lib/idr.c
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
CONFLICT (content): Merge conflict in drivers/mtd/mtd_blkdevs.c
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
CONFLICT (content): Merge conflict in drivers/mfd/sh_mobile_sdhi.c
CONFLICT (content): Merge conflict in drivers/misc/Makefile
Merging hdlc/hdlc-next
Merging drm/drm-next
Merging viafb/viafb-next
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
Merging audit/for-next
Merging quilt/aoe
Merging suspend/linux-next
Merging fsnotify/for-next
CONFLICT (content): Merge conflict in fs/notify/fsnotify.c
Merging irda/for-next
Merging catalin/for-next
CONFLICT (content): Merge conflict in arch/arm/kernel/Makefile
CONFLICT (content): Merge conflict in arch/arm/mach-vexpress/ct-ca9x4.c
CONFLICT (content): Merge conflict in arch/arm/mm/flush.c
CONFLICT (content): Merge conflict in arch/arm/mm/mmu.c
Merging alacrity/linux-next
CONFLICT (content): Merge conflict in include/linux/Kbuild
Merging i7core_edac/linux_next
Merging i7300_edac/linux_next
Merging devicetree/next-devicetree
Merging spi/next-spi
Merging omap_dss2/for-next
Merging tip/auto-latest
Merging rcu/rcu/next
Merging oprofile/for-next
Merging xen/upstream/xen
CONFLICT (content): Merge conflict in arch/x86/xen/mmu.c
Merging swiotlb-xen/master
CONFLICT (content): Merge conflict in arch/x86/include/asm/io_apic.h
CONFLICT (content): Merge conflict in drivers/pci/Makefile
Merging xen-pvhvm/linux-next
Merging edac-amd/for-next
Merging percpu/for-next
Merging workqueues/for-next
Merging sfi/sfi-test
Merging asm-generic/next
Merging drivers-x86/linux-next
Merging hwpoison/hwpoison
Merging sysctl/master
Merging quilt/driver-core
CONFLICT (content): Merge conflict in drivers/misc/Makefile
Merging quilt/tty
Merging quilt/usb
CONFLICT (content): Merge conflict in arch/powerpc/sysdev/fsl_soc.c
CONFLICT (content): Merge conflict in drivers/scsi/sd.c
CONFLICT (content): Merge conflict in drivers/usb/gadget/rndis.c
CONFLICT (content): Merge conflict in drivers/usb/host/Kconfig
CONFLICT (content): Merge conflict in drivers/usb/host/Makefile
CONFLICT (delete/modify): drivers/uwb/wlp/wss-lc.c deleted in HEAD and modi=
fied in quilt/usb. Version quilt/usb of drivers/uwb/wlp/wss-lc.c left in tr=
ee.
$ git rm -f drivers/uwb/wlp/wss-lc.c
Merging staging-next/staging-next
CONFLICT (rename/modify): Merge conflict in drivers/misc/ti-st/st_core.c
CONFLICT (rename/modify): Merge conflict in drivers/misc/ti-st/st_kim.c
CONFLICT (content): Merge conflict in arch/arm/plat-omap/devices.c
CONFLICT (content): Merge conflict in drivers/misc/Makefile
CONFLICT (content): Merge conflict in drivers/staging/Makefile
CONFLICT (content): Merge conflict in drivers/staging/batman-adv/hard-inter=
face.c
CONFLICT (content): Merge conflict in drivers/staging/cx25821/cx25821-audio=
-upstream.c
CONFLICT (content): Merge conflict in drivers/staging/cx25821/cx25821-audio=
.h
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
CONFLICT (content): Merge conflict in fs/compat_ioctl.c
$ git rm -f drivers/staging/mrst-touchscreen/Makefile drivers/staging/mrst-=
touchscreen/intel-mid-touch.c
$ git rm -f drivers/staging/ti-st/st.h drivers/staging/ti-st/st_core.h
Applying: staging: ath6kl: Fixing the driver to use modified mmc_host struc=
ture
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

--Signature=_Thu__28_Oct_2010_14_20_31_+1100_nH.50.tOIX5q3dio
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMyOv/AAoJEDMEi1NhKgbsdDAIAJ21henvHzV9mZG7d3LxWtQV
WDchobhvRvTTm6HPcpx54RYuI4nOfhpRFDoB6yESUWVtr9ks58MYXJWXGc0E9NER
MiXyrddMfjNF1p1WmW5uQZOl7VfVZw+x5ib3wZ+t8KQ7yXWftINFGCOPL06xOdve
kD5URu7KvBXqtJBNhDLWr3y1x8QDPp4v5jEAkT+oP/9K08oE/gkED/VuMn6tPfPC
OhIdvEsvgrk1IQZvGuoTTjG2CT7quHWG1zQao7ZJ6H82+msjIrN1JG9xvN9EVbdh
EEJyjZVy0gofkTa2yEGolDl2KH6CpeJ5X/fwze/xQUeDDj6oTUN2H5N6L+zcZzA=
=zlb+
-----END PGP SIGNATURE-----

--Signature=_Thu__28_Oct_2010_14_20_31_+1100_nH.50.tOIX5q3dio--

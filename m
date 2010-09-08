Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202Ab0IHCQi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 22:16:38 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56130 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019Ab0IHCQg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 22:16:36 -0400
Date: Wed, 8 Sep 2010 12:16:30 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for September 8
Message-Id: <20100908121630.7b7be75e.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__8_Sep_2010_12_16_30_+1000_9jA/KbvC=4XaP.P+"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__8_Sep_2010_12_16_30_+1000_9jA/KbvC=4XaP.P+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20100907:

The powerpc tree still has its build failure for which I applied a patch.

The kgdb tree gained a build failure for which I applied a patch.

I still have a patch to the drivers-x86 tree to remove a Kconfig warning.

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

We are up to 171 trees (counting Linus' and 22 trees of patches pending
for Linus' tree), more are welcome (even if they are currently empty).
Thanks to those who have contributed, and to those who haven't, please do.

Status of my local build tests will be at
http://kisskb.ellerman.id.au/linux-next .  If maintainers want to give
advice about cross compilers/configs that work, we are always open to add
more builds.

Thanks to Jan Dittmer for adding the linux-next tree to his build tests
at http://l4x.org/k/ , the guys at http://test.kernel.org/ and Randy
Dunlap for doing many randconfig builds.

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
CONFLICT (content): Merge conflict in arch/arm/mach-s3c64xx/Makefile
CONFLICT (content): Merge conflict in arch/arm/mach-s3c64xx/mach-smdk6410.c
CONFLICT (content): Merge conflict in arch/arm/plat-samsung/Kconfig
CONFLICT (content): Merge conflict in drivers/input/touchscreen/s3c2410_ts.c
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
Applying: powerpc: define a compat_sys_recv cond_syscall
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
Merging quilt/kernel-doc
Merging v4l-dvb/master
CONFLICT (content): Merge conflict in drivers/media/IR/ir-raw-event.c
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
CONFLICT (content): Merge conflict in net/mac80211/main.c
Merging wireless/master
Merging mtd/master
Merging crypto/master
Merging sound-asoc/for-next
CONFLICT (content): Merge conflict in arch/arm/mach-s3c64xx/mach-smdk6410.c
Merging sound/for-next
Merging cpufreq/next
Merging quilt/rr
Merging input/next
Merging lsm/for-next
Merging block/for-next
Merging quilt/device-mapper
Merging embedded/master
Merging firmware/master
Merging pcmcia/master
Merging battery/master
Merging leds/for-mm
Merging backlight/for-mm
Merging kgdb/kgdb-next
Merging slab/for-next
Merging uclinux/for-next
Merging md/for-next
Merging mfd/for-next
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
Merging audit/for-next
Merging quilt/aoe
Merging suspend/linux-next
Merging bluetooth/master
Merging fsnotify/for-next
Merging irda/for-next
CONFLICT (content): Merge conflict in drivers/net/irda/irda-usb.c
Merging catalin/for-next
Merging alacrity/linux-next
CONFLICT (content): Merge conflict in include/linux/Kbuild
Merging i7core_edac/linux_next
CONFLICT (content): Merge conflict in MAINTAINERS
Merging devicetree/next-devicetree
Merging spi/next-spi
Merging limits/writable_limits
Merging omap_dss2/for-next
Merging xen/upstream/xen
Merging rcu/rcu/next
Merging tip/auto-latest
Merging lost-spurious-irq/lost-spurious-irq
CONFLICT (content): Merge conflict in drivers/ata/libata-core.c
CONFLICT (content): Merge conflict in include/linux/libata.h
Merging edac-amd/for-next
Merging oprofile/for-next
Merging percpu/for-next
Merging workqueues/for-next
Merging sfi/sfi-test
Merging asm-generic/next
Merging drivers-x86/linux-next
Applying: Fix Kconfig mistaken update
Merging hwpoison/hwpoison
Merging sysctl/master
Merging bkl-core/bkl/core
Merging bkl-procfs/bkl/procfs
Merging bkl-ioctl/bkl/ioctl
Merging quilt/driver-core
Merging quilt/tty
CONFLICT (content): Merge conflict in drivers/serial/uartlite.c
Merging quilt/usb
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
$ git rm -f drivers/staging/mrst-touchscreen/Makefile drivers/staging/mrst-=
touchscreen/intel-mid-touch.c
Merging slabh/slabh
Merging scsi-post-merge/merge-base:master
Applying: kgdb: merge fix for mode_set_base_atomic API change

--Signature=_Wed__8_Sep_2010_12_16_30_+1000_9jA/KbvC=4XaP.P+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMhvH+AAoJEDMEi1NhKgbstvMIAIKfDoo0IFhhjKAe2/bZXvA6
LVHWoa/KGYdI4BABG74DgtRlbXaWV9gYfT6GyG60dIxGRZ4XJCvWoen9laZDrFX4
INScEhTSMG0DL41LgDXw8E9fPwDVsOixXvNZC52J2UON9nSGlvugtQIkrXLE1acS
tulSI7o5dx7kWx9apfhYIDds11pi//q2DzzMoAJ9y4M9iBqbZ/V14eVToEEAvCIa
oJdlSBToQ0WjQ4uzjRpWbp0MMEDVvlb5gfpkbeUCOdRafdNFH/MdQ77fl2xbN50n
4ayfG8sEFAOiFEPfWdnR+amuLoX8oBMQZOJtHG9kjYUXk41yOItb1uwPT3EQpZ0=
=RXBg
-----END PGP SIGNATURE-----

--Signature=_Wed__8_Sep_2010_12_16_30_+1000_9jA/KbvC=4XaP.P+--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935605Ab0GPDjJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 23:39:09 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:47466 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935392Ab0GPDjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 23:39:07 -0400
Date: Fri, 16 Jul 2010 13:38:59 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for July 15
Message-Id: <20100716133859.7ef91e10.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__16_Jul_2010_13_38_59_+1000_AyWSnmmcCP0XepSU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__16_Jul_2010_13_38_59_+1000_AyWSnmmcCP0XepSU
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20100715:

The microblaze tree gained a conflict against Linus' tree.

The cifs tree gained a build failure so I used the version from
next-20100715.

The vfs tree still has its build failure for which I applied a merge fix
patch.

The rr tree lost a conflict.

The devicetree tree lost its build failure but gained a conflict against
Linus' tree.

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

We are up to 165 trees (counting Linus' and 22 trees of patches pending
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
CONFLICT (delete/modify): arch/arm/configs/lusl7200_defconfig deleted in ar=
m/devel and modified in HEAD. Version HEAD of arch/arm/configs/lusl7200_def=
config left in tree.
$ git rm -f arch/arm/configs/lusl7200_defconfig
Merging davinci/davinci-next
Merging i.MX/for-next
Merging msm/for-next
Merging omap/for-next
CONFLICT (content): Merge conflict in arch/arm/mach-omap2/board-3430sdp.c
CONFLICT (content): Merge conflict in arch/arm/mach-omap2/board-3630sdp.c
CONFLICT (content): Merge conflict in arch/arm/mach-omap2/board-am3517evm.c
CONFLICT (content): Merge conflict in arch/arm/mach-omap2/board-cm-t35.c
CONFLICT (content): Merge conflict in arch/arm/mach-omap2/board-devkit8000.c
CONFLICT (content): Merge conflict in arch/arm/mach-omap2/board-igep0020.c
CONFLICT (content): Merge conflict in arch/arm/mach-omap2/board-ldp.c
CONFLICT (content): Merge conflict in arch/arm/mach-omap2/board-omap3beagle=
.c
CONFLICT (content): Merge conflict in arch/arm/mach-omap2/board-omap3evm.c
CONFLICT (content): Merge conflict in arch/arm/mach-omap2/board-omap3pandor=
a.c
CONFLICT (content): Merge conflict in arch/arm/mach-omap2/board-omap3touchb=
ook.c
CONFLICT (content): Merge conflict in arch/arm/mach-omap2/board-overo.c
CONFLICT (content): Merge conflict in arch/arm/mach-omap2/board-zoom2.c
CONFLICT (content): Merge conflict in arch/arm/mach-omap2/board-zoom3.c
Merging pxa/for-next
Merging samsung/next-samsung
Merging s5p/for-next
Merging tegra/for-next
CONFLICT (content): Merge conflict in arch/arm/Kconfig
Merging avr32/avr32-arch
Merging blackfin/for-linus
Merging cris/for-next
Merging ia64/test
Merging m68k/for-next
Merging m68knommu/for-next
Merging microblaze/next
CONFLICT (content): Merge conflict in arch/microblaze/mm/init.c
Merging mips/mips-for-linux-next
Merging parisc/next
Merging powerpc/next
Merging 4xx/next
Merging 52xx-and-virtex/next
CONFLICT (content): Merge conflict in drivers/serial/mpc52xx_uart.c
Merging galak/next
Merging s390/features
Merging sh/master
Merging genesis/master
CONFLICT (content): Merge conflict in arch/arm/configs/ap4evb_defconfig
CONFLICT (content): Merge conflict in arch/arm/configs/g3evm_defconfig
CONFLICT (content): Merge conflict in arch/arm/configs/g4evm_defconfig
Merging sparc/master
Merging tile/master
Merging xtensa/master
Merging ceph/for-next
Merging cifs/master
$ git reset --hard HEAD^
Merging refs/next/20100715/cifs
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
CONFLICT (content): Merge conflict in fs/nilfs2/super.c
CONFLICT (content): Merge conflict in fs/xfs/linux-2.6/xfs_super.c
Applying: v9fs: fixup for inode_setattr being removed
Applying: xfs: update tracing for clear_inode to evit_inode transition
Applying: nilfs2: inode.c needs to include btnode.h directly now
Merging pci/linux-next
Merging hid/for-next
Merging quilt/i2c
CONFLICT (content): Merge conflict in drivers/i2c/i2c-core.c
Merging bjdooks-i2c/next-i2c
CONFLICT (content): Merge conflict in arch/arm/plat-omap/i2c.c
CONFLICT (content): Merge conflict in drivers/i2c/busses/i2c-cpm.c
CONFLICT (content): Merge conflict in drivers/i2c/busses/i2c-mpc.c
Merging quilt/jdelvare-hwmon
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
Merging ibft/master
Merging swiotlb/master
Merging scsi/master
Merging async_tx/next
Merging net/master
Merging wireless/master
Merging mtd/master
Merging crypto/master
Merging sound/for-next
CONFLICT (content): Merge conflict in Documentation/kernel-parameters.txt
Merging cpufreq/next
Merging quilt/rr
CONFLICT (content): Merge conflict in arch/um/drivers/hostaudio_kern.c
Merging input/next
Merging lsm/for-next
Merging block/for-next
CONFLICT (content): Merge conflict in drivers/block/virtio_blk.c
Merging quilt/device-mapper
CONFLICT (content): Merge conflict in drivers/md/dm.c
Applying: device-mapper: fix for bio API change
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
CONFLICT (delete/modify): fs/notify/inotify/inotify.c deleted in fsnotify/f=
or-next and modified in HEAD. Version HEAD of fs/notify/inotify/inotify.c l=
eft in tree.
$ git rm -f fs/notify/inotify/inotify.c
Applying: fsnotify: update gfp/slab.h includes
Merging irda/for-next
CONFLICT (content): Merge conflict in drivers/net/irda/irda-usb.c
Merging catalin/for-next
Merging alacrity/linux-next
Merging i7core_edac/linux_next
CONFLICT (content): Merge conflict in MAINTAINERS
Merging devicetree/next-devicetree
CONFLICT (content): Merge conflict in arch/sparc/kernel/prom_64.c
Merging spi/next-spi
Merging omap_dss2/for-next
Merging tip/auto-latest
CONFLICT (content): Merge conflict in Makefile
Merging edac-amd/for-next
Merging oprofile/for-next
Merging percpu/for-next
Merging workqueues/for-next
Merging sfi/sfi-test
Merging asm-generic/next
Merging drivers-x86/linux-next
Merging hwpoison/hwpoison
CONFLICT (content): Merge conflict in mm/memory-failure.c
Merging sysctl/master
Merging bkl-core/bkl/core
Merging bkl-procfs/bkl/procfs
Merging bkl-ioctl/bkl/ioctl
Merging quilt/driver-core
Merging quilt/tty
CONFLICT (content): Merge conflict in include/linux/serial_core.h
Merging quilt/usb
CONFLICT (content): Merge conflict in drivers/media/video/uvc/uvcvideo.h
CONFLICT (content): Merge conflict in include/linux/usb/video.h
Merging staging-next/staging-next
CONFLICT (content): Merge conflict in drivers/staging/batman-adv/bat_sysfs.c
CONFLICT (delete/modify): drivers/staging/batman-adv/device.c deleted in st=
aging-next/staging-next and modified in HEAD. Version HEAD of drivers/stagi=
ng/batman-adv/device.c left in tree.
CONFLICT (delete/modify): drivers/staging/cx25821/cx25821-audups11.c delete=
d in HEAD and modified in staging-next/staging-next. Version staging-next/s=
taging-next of drivers/staging/cx25821/cx25821-audups11.c left in tree.
$ git rm -f drivers/staging/cx25821/cx25821-audups11.c
$ git rm -f drivers/staging/batman-adv/device.c
Merging slabh/slabh
Merging scsi-post-merge/master

--Signature=_Fri__16_Jul_2010_13_38_59_+1000_AyWSnmmcCP0XepSU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMP9RTAAoJEDMEi1NhKgbs8AcIAIvzCTyczmnTRyfyyN9Ealtw
UL/XOGvMvjqLVGx8kDbnGfrl21Acdo9KYGpGGlTgYWKVtCN8MuPp+GxrLxttHFCo
KixPxCQ0nE+FVrbQGxzfYmdEfEg0Rr47lDCv/tXeOxcvn968Gjr6jHfWZ+uh25Au
UIFjAiAVLqeR9wX3vgOpY0qWcfsIIz4zWc4ArV5CFL5AXCowpCxAeeNCydMyaoXU
At6QbfR/3AXYyFXxAJsPXkhZ0cjiwlKQltGuUahjV7vkUJnc+CiWvYCynedCccgH
5/bcrlpByXq+LfUinPCy7CRhNFTAobUpF7EkMVUFu1W588LqTRm5WBbRFSv0cgo=
=bZFZ
-----END PGP SIGNATURE-----

--Signature=_Fri__16_Jul_2010_13_38_59_+1000_AyWSnmmcCP0XepSU--

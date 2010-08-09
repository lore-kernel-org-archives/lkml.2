Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365Ab0HIDXX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 23:23:23 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:37665 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755266Ab0HIDXV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 23:23:21 -0400
Date: Mon, 9 Aug 2010 13:23:14 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for August 9
Message-Id: <20100809132314.789e13f3.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__9_Aug_2010_13_23_14_+1000_+GfHE2/Du=JZt95_"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__9_Aug_2010_13_23_14_+1000_+GfHE2/Du=JZt95_
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

As the merge window is open, please do not add 2.6.37 material to your
linux-next included trees until after 2.6.36-rc1.

Changes since 20100807:

The ext4 tree lost its conflicts.

The block tree gained a build failure so I used the version from
next-20100807.

The kgdb tree lost its conflicts and build failure.

The mfd tree gained a build failure so I used the version from
next-20100807.

The spi tree gained a conflict against the devicetree tree.

The workqueues tree lost its conflicts.

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

We are up to 169 trees (counting Linus' and 22 trees of patches pending
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
Merging s5p/for-next
CONFLICT (content): Merge conflict in arch/arm/Kconfig
CONFLICT (content): Merge conflict in arch/arm/mm/Kconfig
Merging tegra/for-next
CONFLICT (content): Merge conflict in arch/arm/Kconfig
CONFLICT (content): Merge conflict in arch/arm/mm/Kconfig
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
CONFLICT (content): Merge conflict in drivers/Makefile
Merging genesis/master
Merging sparc/master
Merging tile/master
Merging xtensa/master
CONFLICT (content): Merge conflict in arch/xtensa/configs/iss_defconfig
Merging ceph/for-next
Applying: ceph: update for removal of request flag wrappers
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
CONFLICT (content): Merge conflict in fs/nilfs2/super.c
CONFLICT (content): Merge conflict in fs/xfs/linux-2.6/xfs_aops.c
CONFLICT (content): Merge conflict in fs/xfs/linux-2.6/xfs_super.c
Applying: v9fs: fixup for inode_setattr being removed
Applying: xfs: update tracing for clear_inode to evit_inode transition
Applying: cifs: fix for clear_inode -> evict_inode API change
Merging pci/linux-next
Merging hid/for-next
Merging quilt/i2c
Merging bjdooks-i2c/next-i2c
CONFLICT (content): Merge conflict in arch/arm/plat-omap/i2c.c
CONFLICT (content): Merge conflict in drivers/i2c/busses/i2c-cpm.c
CONFLICT (content): Merge conflict in drivers/i2c/busses/i2c-mpc.c
Merging quilt/jdelvare-hwmon
Merging quilt/kernel-doc
CONFLICT (content): Merge conflict in Documentation/kernel-parameters.txt
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
CONFLICT (content): Merge conflict in drivers/xen/Kconfig
CONFLICT (content): Merge conflict in drivers/xen/Makefile
CONFLICT (content): Merge conflict in include/xen/xen-ops.h
Merging ibft/master
Merging scsi/master
Merging async_tx/next
CONFLICT (content): Merge conflict in arch/arm/mach-ux500/devices-db8500.c
Merging net/master
Merging wireless/master
Merging mtd/master
CONFLICT (content): Merge conflict in drivers/mtd/maps/Kconfig
CONFLICT (delete/modify): drivers/mtd/maps/redwood.c deleted in mtd/master =
and modified in HEAD. Version HEAD of drivers/mtd/maps/redwood.c left in tr=
ee.
$ git rm -f drivers/mtd/maps/redwood.c
Merging crypto/master
Merging sound/for-next
Merging cpufreq/next
Merging quilt/rr
CONFLICT (content): Merge conflict in arch/um/drivers/hostaudio_kern.c
CONFLICT (content): Merge conflict in kernel/module.c
Applying: nfs: update for module_param_named API change
Applying: AppArmor: update for module_param_named API change
Merging input/next
Merging lsm/for-next
Merging block/for-next
CONFLICT (content): Merge conflict in drivers/block/virtio_blk.c
CONFLICT (content): Merge conflict in drivers/scsi/scsi_error.c
$ git reset --hard HEAD^
Merging refs/next/20100807/block
Merging quilt/device-mapper
CONFLICT (content): Merge conflict in drivers/md/dm.c
Merging embedded/master
Merging firmware/master
Merging pcmcia/master
Merging battery/master
CONFLICT (content): Merge conflict in drivers/power/Kconfig
CONFLICT (content): Merge conflict in drivers/power/Makefile
Merging leds/for-mm
Merging backlight/for-mm
Merging kgdb/kgdb-next
Merging slab/for-next
Merging uclinux/for-next
Merging md/for-next
Merging mfd/for-next
$ git reset --hard HEAD^
Merging refs/next/20100807/mfd
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
Merging irda/for-next
CONFLICT (content): Merge conflict in drivers/net/irda/irda-usb.c
Merging catalin/for-next
CONFLICT (content): Merge conflict in arch/arm/include/asm/io.h
CONFLICT (content): Merge conflict in arch/arm/kernel/entry-armv.S
CONFLICT (content): Merge conflict in arch/arm/mm/cache-l2x0.c
CONFLICT (content): Merge conflict in arch/arm/mm/mmu.c
Merging alacrity/linux-next
Merging i7core_edac/linux_next
CONFLICT (content): Merge conflict in MAINTAINERS
Merging devicetree/next-devicetree
Merging spi/next-spi
CONFLICT (content): Merge conflict in drivers/spi/mpc512x_psc_spi.c
Applying: spi: update for of_device to platform_device replacement
Merging limits/writable_limits
CONFLICT (content): Merge conflict in arch/x86/ia32/ia32entry.S
CONFLICT (content): Merge conflict in arch/x86/include/asm/unistd_32.h
CONFLICT (content): Merge conflict in arch/x86/include/asm/unistd_64.h
CONFLICT (content): Merge conflict in arch/x86/kernel/syscall_table_32.S
CONFLICT (content): Merge conflict in include/asm-generic/unistd.h
Merging omap_dss2/for-next
Merging xen/upstream/xen
Merging tip/auto-latest
Merging lost-spurious-irq/lost-spurious-irq
CONFLICT (content): Merge conflict in drivers/ata/sata_fsl.c
CONFLICT (content): Merge conflict in drivers/ata/sata_mv.c
CONFLICT (content): Merge conflict in drivers/ata/sata_nv.c
CONFLICT (content): Merge conflict in include/linux/libata.h
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
CONFLICT (content): Merge conflict in drivers/char/vt.c
CONFLICT (content): Merge conflict in include/linux/serial_core.h
Merging quilt/usb
Merging staging-next/staging-next
Merging slabh/slabh
Merging scsi-post-merge/merge-base:master
$ git checkout scsi-post-merge/master

--Signature=_Mon__9_Aug_2010_13_23_14_+1000_+GfHE2/Du=JZt95_
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMX3SiAAoJEDMEi1NhKgbsPLYH/2y5nTLUZFJA30AlHpXaGoDf
AmOMHs9V/hPrQkeD/oTIweRQwZww7x/H3J/npDoPvmYfCEPa9Bur0eGqLo6uJ0UQ
NsGu/wj5t8V/aeZuVno/y9lYo284h+stqjbKQVCVYKCa5AKpqi5FGpbreNjSFg5L
zE4myypPNlFC3ZAYBA39RKDSrRyF7zbm8WAbERFtTlzhraqZ8sdBmi3VMtUj/Zoz
bkmnmND+GyGW5DzVmKL+f3sknei+AAe50dydyyLrBjx3LpqrKhZBpffZU8qlaPKD
T6ag6sgLfVzsbsx5comMkS9N42kU9HINFpmvGtouGmxMajb2azNHCon4QnCA2js=
=51YZ
-----END PGP SIGNATURE-----

--Signature=_Mon__9_Aug_2010_13_23_14_+1000_+GfHE2/Du=JZt95_--

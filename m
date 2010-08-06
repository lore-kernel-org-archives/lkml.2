Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761075Ab0HFD2N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 23:28:13 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:60608 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759148Ab0HFD2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 23:28:08 -0400
Date: Fri, 6 Aug 2010 13:27:58 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for August 6
Message-Id: <20100806132758.6001d416.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__6_Aug_2010_13_27_58_+1000_Q5QmGs=Xe71RTXqE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__6_Aug_2010_13_27_58_+1000_Q5QmGs=Xe71RTXqE
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

As the merge window is open, please do not add 2.6.37 material to your
linux-next included trees until after 2.6.36-rc1.

Changes since 20100805:

The davinci tree lost its conflict.

The cifs tree still has its build failure.

The hid tree lost its conflict.

The sound tree lost its conflict.

The block tree lost its build failure and a conflict.

The security-testing tree lost its conflicts.

The devicetree tree lost its conflict.

The xen tree lost its conflicts.

The usb tree lost its conflict.

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
CONFLICT (add/add): Merge conflict in arch/arm/plat-samsung/include/plat/ke=
ypad.h
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
CONFLICT (content): Merge conflict in arch/mips/powertv/memory.c
CONFLICT (add/add): Merge conflict in arch/mips/sibyte/Makefile
CONFLICT (add/add): Merge conflict in arch/mips/txx9/Makefile
Merging parisc/next
Merging powerpc/next
Merging 4xx/next
Merging 52xx-and-virtex/next
Merging galak/next
Merging s390/features
Merging sh/master
Merging genesis/master
CONFLICT (content): Merge conflict in drivers/net/irda/sh_irda.c
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
CONFLICT (content): Merge conflict in fs/ext4/inode.c
CONFLICT (content): Merge conflict in fs/xfs/linux-2.6/xfs_aops.c
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
CONFLICT (content): Merge conflict in Documentation/DocBook/kgdb.tmpl
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
Merging limits/writable_limits
CONFLICT (content): Merge conflict in arch/x86/ia32/ia32entry.S
CONFLICT (content): Merge conflict in arch/x86/include/asm/unistd_32.h
CONFLICT (content): Merge conflict in arch/x86/include/asm/unistd_64.h
CONFLICT (content): Merge conflict in arch/x86/kernel/syscall_table_32.S
CONFLICT (content): Merge conflict in include/asm-generic/unistd.h
Merging omap_dss2/for-next
Merging xen/upstream/xen
Merging tip/auto-latest
CONFLICT (content): Merge conflict in Documentation/feature-removal-schedul=
e.txt
CONFLICT (content): Merge conflict in Makefile
CONFLICT (content): Merge conflict in arch/powerpc/kernel/time.c
CONFLICT (content): Merge conflict in drivers/Makefile
CONFLICT (content): Merge conflict in drivers/cpufreq/cpufreq.c
Merging lost-spurious-irq/lost-spurious-irq
CONFLICT (content): Merge conflict in drivers/ata/sata_fsl.c
CONFLICT (content): Merge conflict in drivers/ata/sata_mv.c
CONFLICT (content): Merge conflict in drivers/ata/sata_nv.c
Merging edac-amd/for-next
Merging oprofile/for-next
Merging percpu/for-next
Merging workqueues/for-next
CONFLICT (content): Merge conflict in fs/cifs/cifsfs.c
CONFLICT (content): Merge conflict in fs/cifs/cifsglob.h
CONFLICT (content): Merge conflict in fs/cifs/file.c
CONFLICT (content): Merge conflict in include/linux/libata.h
CONFLICT (content): Merge conflict in include/linux/workqueue.h
CONFLICT (content): Merge conflict in kernel/trace/Kconfig
CONFLICT (content): Merge conflict in kernel/workqueue.c
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
CONFLICT (content): Merge conflict in drivers/staging/Kconfig
CONFLICT (content): Merge conflict in drivers/staging/batman-adv/bat_sysfs.c
CONFLICT (delete/modify): drivers/staging/batman-adv/device.c deleted in st=
aging-next/staging-next and modified in HEAD. Version HEAD of drivers/stagi=
ng/batman-adv/device.c left in tree.
CONFLICT (content): Merge conflict in drivers/staging/batman-adv/hard-inter=
face.c
CONFLICT (content): Merge conflict in drivers/staging/comedi/drivers/quatec=
h_daqp_cs.c
CONFLICT (delete/modify): drivers/staging/cx25821/cx25821-audups11.c delete=
d in HEAD and modified in staging-next/staging-next. Version staging-next/s=
taging-next of drivers/staging/cx25821/cx25821-audups11.c left in tree.
CONFLICT (content): Merge conflict in drivers/staging/wlags49_h2/wl_cs.c
$ git rm -f drivers/staging/cx25821/cx25821-audups11.c
$ git rm -f drivers/staging/batman-adv/device.c
Merging slabh/slabh
Merging scsi-post-merge/merge-base:master
$ git checkout scsi-post-merge/master
Applying: [SCSI] be2iscsi: Add support for iscsi boot
Applying: [SCSI] be2iscsi: Increase max sector
Applying: [SCSI] be2iscsi: Driver Version change to 2.0.549.0
Applying: [SCSI] be2iscsi: select ISCSI_BOOT_SYSFS
Applying: cifs: include linux/err.h for IS_ERR and PTR_ERR

--Signature=_Fri__6_Aug_2010_13_27_58_+1000_Q5QmGs=Xe71RTXqE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMW4E+AAoJEDMEi1NhKgbsdmoH/jKh/LAfb2ISLNaVxUXmSCNs
oYWnqsWcl9xFCqyiiZlgqBg5hDEhJoxD9ngZoGNU0ppn79vAZigq7EJFiRmgjAc7
QTXUuAdc4/s1bMkzIyJd9Y4S+iofMtEvnRG2ggeIbITN21z1LTofx+9WG+hIFzia
BiF/OmOA+DgLpQ6smzYVQkpQkGGxU/ZDbaJA+aUAASStJD4GEtPLVAT2SzdNGBSP
jee7vZTRt0QGefUsZboOh9J1ngI9EGMw8xAZshE4phdegg+nMTjYdz6q8mgavaZr
kR17XCxJbpI6TyEqkElMXRyuzBVQum6kUf5K3oeR53SyJIMjN3gBrd3bpmNd0PE=
=iHHS
-----END PGP SIGNATURE-----

--Signature=_Fri__6_Aug_2010_13_27_58_+1000_Q5QmGs=Xe71RTXqE--

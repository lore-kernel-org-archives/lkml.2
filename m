Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533Ab0ENGOQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 02:14:16 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:47056 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752221Ab0ENGON (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 02:14:13 -0400
Date: Fri, 14 May 2010 16:14:07 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for May 14
Message-Id: <20100514161407.740da901.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__14_May_2010_16_14_07_+1000_aAapIOaP5KYI6zSu"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__14_May_2010_16_14_07_+1000_aAapIOaP5KYI6zSu
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20100513:

Dropped trees: tmio-mmc (long unresolved conflicts and unable to fetch)
	hwlat (at the maintainer's request)

The ceph tree gained 3 conflicts against Linus' tree.

The vl4-dvb tree lost its conflicts.

The backlight tree still has its build failure so I used the version from
next-20100507.

The tip tree gained a conflict against the kgdb tree and a build failure
(on sparc64 at least).

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

We are up to 162 trees (counting Linus' and 22 trees of patches pending
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
Merging kbuild-current/for-linus
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
Applying: arm: update gfp/slab.h includes
Merging davinci/davinci-next
Applying: davinci: update gfp/slab.h includes
Merging i.MX/for-next
Merging msm/for-next
CONFLICT (content): Merge conflict in arch/arm/mach-msm/Kconfig
Merging omap/for-next
Merging pxa/for-next
Merging samsung/next-samsung
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
Merging xtensa/master
Merging ceph/for-next
CONFLICT (content): Merge conflict in fs/ceph/caps.c
CONFLICT (content): Merge conflict in fs/ceph/messenger.c
CONFLICT (content): Merge conflict in fs/ceph/super.c
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
Merging nfs/linux-next
Merging nfsd/nfsd-next
Merging nilfs2/for-next
Merging ocfs2/linux-next
Applying: ocfs2: update gfp/slab.h includes
Merging squashfs/master
Merging udf/for_next
Merging v9fs/for-next
CONFLICT (content): Merge conflict in fs/9p/vfs_super.c
Merging ubifs/linux-next
Merging xfs/master
Merging vfs/for-next
CONFLICT (content): Merge conflict in fs/cifs/file.c
CONFLICT (content): Merge conflict in fs/namei.c
CONFLICT (content): Merge conflict in fs/nfs/inode.c
CONFLICT (content): Merge conflict in fs/nfsd/nfs4xdr.c
CONFLICT (content): Merge conflict in fs/nfsd/vfs.c
CONFLICT (content): Merge conflict in fs/ufs/inode.c
CONFLICT (content): Merge conflict in fs/xfs/linux-2.6/xfs_super.c
CONFLICT (content): Merge conflict in security/tomoyo/realpath.c
Merging pci/linux-next
Merging hid/for-next
Merging quilt/i2c
Merging bjdooks-i2c/next-i2c
Merging quilt/jdelvare-hwmon
Merging quilt/kernel-doc
Merging v4l-dvb/master
Applying: v4l-dvb: update gfp/slab.h includes
Merging kbuild/for-next
Merging kconfig/for-next
Merging ide/master
Merging libata/NEXT
Merging infiniband/for-next
Merging acpi/test
Applying: acpi: update gfp/slab.h includes
Merging ieee1394/for-next
Merging ubi/linux-next
Merging kvm/linux-next
CONFLICT (content): Merge conflict in kernel/fork.c
Merging dlm/next
Merging ibft/master
Merging scsi/master
Merging async_tx/next
Merging net/master
CONFLICT (content): Merge conflict in Documentation/feature-removal-schedul=
e.txt
CONFLICT (content): Merge conflict in drivers/net/wireless/iwlwifi/iwl-dev.h
Merging wireless/master
CONFLICT (content): Merge conflict in drivers/net/wireless/iwlwifi/iwl-dev.h
Applying: wireless: update gfp/slab.h includes
Merging mtd/master
Applying: mtd: update gfp/slab.h includes
Merging crypto/master
CONFLICT (content): Merge conflict in arch/arm/mach-omap2/devices.c
Merging sound/for-next
Merging cpufreq/next
Merging quilt/rr
CONFLICT (content): Merge conflict in drivers/net/virtio_net.c
CONFLICT (content): Merge conflict in drivers/net/wireless/libertas_tf/if_u=
sb.c
CONFLICT (content): Merge conflict in include/linux/mod_devicetable.h
CONFLICT (content): Merge conflict in scripts/mod/file2alias.c
Merging mmc/next
Merging input/next
CONFLICT (content): Merge conflict in Documentation/feature-removal-schedul=
e.txt
Merging lsm/for-next
Merging block/for-next
CONFLICT (content): Merge conflict in fs/ext3/fsync.c
CONFLICT (content): Merge conflict in fs/ext4/fsync.c
Merging quilt/device-mapper
Merging embedded/master
Merging firmware/master
Merging pcmcia/master
CONFLICT (content): Merge conflict in drivers/net/pcmcia/3c589_cs.c
CONFLICT (content): Merge conflict in drivers/net/wireless/orinoco/orinoco_=
cs.c
CONFLICT (content): Merge conflict in drivers/net/wireless/orinoco/spectrum=
_cs.c
Merging battery/master
Merging leds/for-mm
Merging backlight/for-mm
$ git reset --hard HEAD^
Merging refs/next/20100507/backlight
Merging kgdb/kgdb-next
Applying: kgdb: update for sysrq handling change
Applying: kdb: update gfp/slab.h includes
Merging slab/for-next
Merging uclinux/for-next
Merging md/for-next
Merging mfd/for-next
CONFLICT (content): Merge conflict in drivers/dma/Makefile
CONFLICT (add/add): Merge conflict in drivers/dma/timb_dma.c
Merging hdlc/hdlc-next
Merging drm/drm-next
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/i915_drv.h
CONFLICT (content): Merge conflict in drivers/gpu/drm/radeon/r300.c
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
Applying: wireless: update for pm_qos_requirement to pm_qos_request rename
Merging bluetooth/master
Merging fsnotify/for-next
Applying: fsnotify: update gfp/slab.h includes
Merging irda/for-next
CONFLICT (content): Merge conflict in drivers/net/irda/irda-usb.c
Merging drbd/for-jens
Merging catalin/for-next
Merging alacrity/linux-next
CONFLICT (content): Merge conflict in include/linux/Kbuild
CONFLICT (content): Merge conflict in lib/Kconfig
Applying: vbus: use of kzalloc/kfree requires the include of slab.h
Applying: vbus: update gfp/slab.h includes
Merging i7core_edac/linux_next
Merging devicetree/next-devicetree
Merging spi/next-spi
Merging omap_dss2/for-next
Merging tip/auto-latest
CONFLICT (content): Merge conflict in Documentation/feature-removal-schedul=
e.txt
CONFLICT (content): Merge conflict in kernel/Makefile
CONFLICT (content): Merge conflict in kernel/fork.c
Merging edac-amd/for-next
Merging oprofile/for-next
Merging percpu/for-next
Merging workqueues/for-next
Merging sfi/sfi-test
Merging asm-generic/next
Merging hwpoison/hwpoison
Merging sysctl/master
Merging bkl-core/bkl/core
Merging bkl-procfs/bkl/procfs
Merging bkl-ioctl/bkl/ioctl
CONFLICT (content): Merge conflict in arch/cris/arch-v10/drivers/ds1302.c
CONFLICT (content): Merge conflict in drivers/block/pktcdvd.c
Merging quilt/driver-core
CONFLICT (content): Merge conflict in drivers/base/platform.c
Applying: md: fixup for sysfs_get_dirent API change
Merging quilt/tty
CONFLICT (content): Merge conflict in include/linux/tty.h
Merging quilt/usb
CONFLICT (content): Merge conflict in drivers/input/tablet/acecad.c
CONFLICT (content): Merge conflict in drivers/input/tablet/kbtab.c
CONFLICT (content): Merge conflict in drivers/input/tablet/wacom_sys.c
CONFLICT (content): Merge conflict in drivers/media/video/gspca/gspca.c
CONFLICT (delete/modify): sound/usb/usbaudio.c deleted in HEAD and modified=
 in quilt/usb. Version quilt/usb of sound/usb/usbaudio.c left in tree.
$ git rm -f sound/usb/usbaudio.c
Applying: usb: update gfp/slab.h includes
Applying: sound: fixup for usb_buffer_alloc/free rename
Merging staging-next/staging-next
CONFLICT (rename/modify): Merge conflict in drivers/staging/hv/hv.c
CONFLICT (delete/modify): drivers/staging/arlan/arlan-main.c deleted in sta=
ging-next/staging-next and modified in HEAD. Version HEAD of drivers/stagin=
g/arlan/arlan-main.c left in tree.
CONFLICT (content): Merge conflict in drivers/staging/comedi/drivers/cb_das=
16_cs.c
CONFLICT (content): Merge conflict in drivers/staging/cx25821/cx25821-alsa.c
CONFLICT (content): Merge conflict in drivers/staging/dt3155/dt3155_drv.c
CONFLICT (delete/modify): drivers/staging/netwave/netwave_cs.c deleted in s=
taging-next/staging-next and modified in HEAD. Version HEAD of drivers/stag=
ing/netwave/netwave_cs.c left in tree.
CONFLICT (content): Merge conflict in drivers/staging/rtl8187se/r8180_core.c
CONFLICT (delete/modify): drivers/staging/wavelan/wavelan.c deleted in stag=
ing-next/staging-next and modified in HEAD. Version HEAD of drivers/staging=
/wavelan/wavelan.c left in tree.
CONFLICT (delete/modify): drivers/staging/wavelan/wavelan_cs.c deleted in s=
taging-next/sResolved 'drivers/staging/comedi/drivers/cb_das16_cs.c' using =
previous resolution.
CONFLICT (content): Merge conflict in drivers/staging/wlags49_h2/wl_cs.c
$ git rm -f drivers/staging/arlan/arlan-main.c
$ git rm -f drivers/staging/netwave/netwave_cs.c
$ git rm -f drivers/staging/wavelan/wavelan.c
$ git rm -f drivers/staging/wavelan/wavelan_cs.c
Merging slabh/slabh
Merging scsi-post-merge/master

--Signature=_Fri__14_May_2010_16_14_07_+1000_aAapIOaP5KYI6zSu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvs6i8ACgkQjjKRsyhoI8w+rwCfQN4eOH7x2y9DB70c40V684Ju
XNMAoK1QVnNqECrMHGIGxAxwU52It90S
=aQ4j
-----END PGP SIGNATURE-----

--Signature=_Fri__14_May_2010_16_14_07_+1000_aAapIOaP5KYI6zSu--

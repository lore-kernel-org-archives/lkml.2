Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750Ab1FJG3D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 02:29:03 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:32798 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751803Ab1FJG27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 02:28:59 -0400
Date: Fri, 10 Jun 2011 16:28:49 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for June 10
Message-Id: <20110610162849.facd0129.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__10_Jun_2011_16_28_49_+1000_4f7OnMVwlcILlrq."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__10_Jun_2011_16_28_49_+1000_4f7OnMVwlcILlrq.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20110609:

The powerpc allyesconfig (and probably others) is broken because we now
build the staging drivers (but less broken than yesterday).

The arm-lpae tree gained a conflict against the arm tree.

The unicore32 tree lost its conflict.

The net tree still has its build failure for which I applied a patch.

The staging tree lost a conflict.

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

We are up to 194 trees (counting Linus' and 28 trees of patches pending
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
Merging arm-lpae/for-next
CONFLICT (content): Merge conflict in arch/arm/include/asm/pgalloc.h
CONFLICT (content): Merge conflict in arch/arm/include/asm/pgtable.h
CONFLICT (content): Merge conflict in arch/arm/include/asm/tlb.h
CONFLICT (content): Merge conflict in arch/arm/mm/context.c
Merging at91/at91-next
Merging davinci/davinci-next
Merging i.MX/for-next
Merging linux-spec/for-next
Merging msm/for-next
Merging omap/for-next
Merging pxa/for-next
Merging samsung/next-samsung
Merging s5p/for-next
Merging tegra/for-next
Merging ux500-core/ux500-core
Merging xilinx/arm-next
CONFLICT (add/add): Merge conflict in arch/arm/kernel/devtree.c
Merging blackfin/for-linus
Merging cris/for-next
Merging ia64/test
Merging m68k/for-next
Merging m68knommu/for-next
Merging microblaze/next
Merging mips/mips-for-linux-next
Merging parisc/for-next
Merging powerpc/next
Merging 4xx/next
Merging 52xx-and-virtex/powerpc/next
Merging galak/next
CONFLICT (content): Merge conflict in arch/powerpc/boot/dts/p2020ds.dts
CONFLICT (content): Merge conflict in arch/powerpc/boot/dts/p2020rdb.dts
Merging s390/features
Merging sh/sh-latest
Merging rmobile/rmobile-latest
Merging sparc/master
Merging tile/master
Merging unicore32/unicore32
Merging xtensa/master
CONFLICT (content): Merge conflict in arch/xtensa/configs/iss_defconfig
Merging ceph/for-next
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
Merging vfs-scale/vfs-scale-working
Merging pci/linux-next
Merging of-pci/of-pci
Merging hid/for-next
Merging quilt/i2c
Merging bjdooks-i2c/next-i2c
Merging quilt/jdelvare-hwmon
Merging hwmon-staging/hwmon-next
Merging quilt/kernel-doc
Merging docs/docs-move
Merging v4l-dvb/master
Merging kbuild/for-next
Merging kconfig/for-next
Merging ide/master
Merging libata/NEXT
Merging infiniband/for-next
Merging acpi/test
Merging idle-test/idle-test
CONFLICT (content): Merge conflict in arch/x86/kernel/process.c
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
CONFLICT (content): Merge conflict in drivers/net/wireless/iwlwifi/iwl-agn-=
rxon.c
CONFLICT (content): Merge conflict in drivers/net/wireless/rtlwifi/pci.c
Applying: net/staging: add needed interrupt.h and hardirq.h includes
Merging wireless/master
Merging bluetooth/master
Merging mtd/master
Merging l2-mtd/master
Merging crypto/master
Merging sound/for-next
Merging sound-asoc/for-next
Merging cpufreq/next
Merging quilt/rr
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
CONFLICT (delete/modify): drivers/mmc/host/sdhci-of-core.c deleted in mmc/m=
mc-next and modified in HEAD. Version HEAD of drivers/mmc/host/sdhci-of-cor=
e.c left in tree.
$ git rm -f drivers/mmc/host/sdhci-of-core.c
Merging kgdb/kgdb-next
Merging slab/for-next
Merging uclinux/for-next
Merging md/for-next
Merging mfd/for-next
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
CONFLICT (content): Merge conflict in drivers/gpio/Kconfig
Merging tip/auto-latest
Merging rcu/rcu/next
CONFLICT (content): Merge conflict in kernel/rcutree.c
Merging kvm/linux-next
Merging oprofile/for-next
Merging ptrace/ptrace
Merging xen/upstream/xen
Merging xen-two/linux-next
Merging xen-pvhvm/linux-next
Merging edac-amd/for-next
Merging percpu/for-next
Merging workqueues/for-next
Merging sfi/sfi-test
Merging asm-generic/next
Merging drivers-x86/linux-next
Merging hwpoison/hwpoison
Merging sysctl/master
Merging namespace/master
Merging driver-core/driver-core-next
Merging tty/tty-next
Merging usb/usb-next
Merging staging/staging-next
CONFLICT (content): Merge conflict in drivers/staging/brcm80211/brcmfmac/dh=
d_linux.c
CONFLICT (content): Merge conflict in drivers/staging/brcm80211/brcmfmac/wl=
_iw.c
Merging bkl-config/config
Merging tmem/linux-next
Merging writeback/next
Merging arm-dt/devicetree/arm-next
Merging scsi-post-merge/merge-base:master

--Signature=_Fri__10_Jun_2011_16_28_49_+1000_4f7OnMVwlcILlrq.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN8bmhAAoJEDMEi1NhKgbsHbIIAItnvH1pcpAEMB1OsRhRFLhx
U0nl+9ZZg3fS9OPYsyap73Dcp62ICiqUMXDco2R/b7e0I8l9JNoXrqdvFwI5s3yu
gCzatINRB3Qe/b1KxfkPSY8G0g5dX+QGQvGYZPONVaKn0k7+nAx7ixEKbLHsqrvb
zSsRBZhsrK/lSrTuGnZsu5q9RnsnuKCfAONjRNqsu8atQMTjLQCRP3D6E7TELLGf
+VRdM/tMSAfuv5CwKyv+v6KmkqUtRM2wqHzB9QTA4kQh6Ry9uYpQ/mbmwFozW3+6
ISgjhO+dU+E/T9HrxMekDtMKpczHO1Qxiv3jKpMYKzl9gJhE8GCQind+mnmgRzA=
=m1bp
-----END PGP SIGNATURE-----

--Signature=_Fri__10_Jun_2011_16_28_49_+1000_4f7OnMVwlcILlrq.--

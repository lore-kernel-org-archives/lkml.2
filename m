Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848Ab1EQE1y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 00:27:54 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:48679 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751188Ab1EQE1w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 00:27:52 -0400
Date: Tue, 17 May 2011 14:27:49 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for May 17
Message-Id: <20110517142749.8927b65b.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__17_May_2011_14_27_49_+1000_cMdttrfNC7ZEPTVx"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__17_May_2011_14_27_49_+1000_cMdttrfNC7ZEPTVx
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20110516:

Dropped trees: xen

The net tree gained conflicts against the net-current tree.

The wireless tree lost its build failure.

The tip tree gained conflicts against the sparc and wireless trees.

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

We are up to 191 trees (counting Linus' and 28 trees of patches pending
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
Merging avr32/avr32-arch
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
Merging s390/features
Merging sh/sh-latest
Merging rmobile/rmobile-latest
Merging sparc/master
Merging tile/master
Merging unicore32/unicore32
CONFLICT (content): Merge conflict in drivers/net/Kconfig
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
CONFLICT (content): Merge conflict in include/linux/pci_ids.h
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
Merging powertools/tools-test
Merging cpupowerutils/master
Merging ieee1394/for-next
Merging ubi/linux-next
Merging dlm/next
Merging swiotlb/master
Merging ibft/master
Merging scsi/master
Merging async_tx/next
Merging net/master
CONFLICT (content): Merge conflict in drivers/net/vmxnet3/vmxnet3_ethtool.c
CONFLICT (content): Merge conflict in net/core/dev.c
Merging wireless/master
CONFLICT (content): Merge conflict in drivers/net/wireless/iwlwifi/iwl-agn-=
tx.c
CONFLICT (content): Merge conflict in net/mac80211/sta_info.h
Merging bluetooth/master
Merging mtd/master
Merging crypto/master
Merging sound/for-next
Merging sound-asoc/for-next
Merging cpufreq/next
Merging cpufreq-move/move-drivers
CONFLICT (content): Merge conflict in drivers/cpufreq/cpufreq_stats.c
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
CONFLICT (content): Merge conflict in drivers/mmc/host/tmio_mmc_pio.c
Merging kgdb/kgdb-next
Merging slab/for-next
CONFLICT (content): Merge conflict in mm/slub.c
Merging uclinux/for-next
Merging md/for-next
Merging mfd/for-next
CONFLICT (content): Merge conflict in drivers/mfd/twl4030-power.c
Merging hdlc/hdlc-next
Merging drm/drm-next
Merging fbdev/master
Merging viafb/viafb-next
Merging omap_dss2/for-next
CONFLICT (content): Merge conflict in drivers/video/omap2/dss/dsi.c
CONFLICT (content): Merge conflict in drivers/video/omap2/dss/dss_features.c
CONFLICT (content): Merge conflict in drivers/video/omap2/dss/dss_features.h
Merging voltage/for-next
CONFLICT (content): Merge conflict in drivers/mfd/Kconfig
CONFLICT (content): Merge conflict in drivers/mfd/Makefile
Merging security-testing/next
CONFLICT (content): Merge conflict in include/linux/capability.h
Merging selinux/master
CONFLICT (content): Merge conflict in lib/flex_array.c
CONFLICT (content): Merge conflict in security/selinux/avc.c
CONFLICT (content): Merge conflict in security/selinux/hooks.c
CONFLICT (content): Merge conflict in security/selinux/ss/policydb.c
CONFLICT (content): Merge conflict in security/smack/smack_lsm.c
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
CONFLICT (content): Merge conflict in arch/x86/Kconfig
Merging apm/for-next
Merging fsnotify/for-next
Merging irda/for-next
Merging i7core_edac/linux_next
Merging i7300_edac/linux_next
Merging devicetree/devicetree/next
Merging spi/spi/next
Merging tip/auto-latest
CONFLICT (content): Merge conflict in arch/sparc/kernel/smp_32.c
CONFLICT (content): Merge conflict in net/mac80211/agg-tx.c
Merging rcu/rcu/next
Merging kvm/linux-next
Merging oprofile/for-next
Merging ptrace/ptrace
Merging xen-two/linux-next
Merging xen-pvhvm/linux-next
Merging edac-amd/for-next
Merging percpu/for-next
CONFLICT (content): Merge conflict in arch/x86/include/asm/percpu.h
Merging workqueues/for-next
Merging sfi/sfi-test
Merging asm-generic/next
Merging drivers-x86/linux-next
CONFLICT (content): Merge conflict in drivers/platform/x86/Kconfig
CONFLICT (content): Merge conflict in drivers/platform/x86/Makefile
CONFLICT (content): Merge conflict in drivers/platform/x86/eeepc-laptop.c
CONFLICT (content): Merge conflict in drivers/platform/x86/sony-laptop.c
Merging hwpoison/hwpoison
Merging sysctl/master
Merging namespace/master
CONFLICT (content): Merge conflict in arch/alpha/include/asm/unistd.h
CONFLICT (content): Merge conflict in arch/alpha/kernel/systbls.S
CONFLICT (content): Merge conflict in arch/m68k/kernel/entry_mm.S
Merging driver-core/driver-core-next
CONFLICT (content): Merge conflict in fs/debugfs/file.c
Merging tty/tty-next
CONFLICT (content): Merge conflict in drivers/bluetooth/hci_ldisc.c
CONFLICT (content): Merge conflict in drivers/tty/serial/Makefile
Merging usb/usb-next
CONFLICT (content): Merge conflict in arch/arm/mach-exynos4/mach-nuri.c
Merging staging/staging-next
CONFLICT (content): Merge conflict in drivers/staging/intel_sst/intelmid.c
CONFLICT (delete/modify): drivers/staging/rt2860/common/cmm_data_pci.c dele=
ted in staging/staging-next and modified in HEAD. Version HEAD of drivers/s=
taging/rt2860/common/cmm_data_pci.c left in tree.
CONFLICT (delete/modify): drivers/staging/rt2860/common/cmm_data_usb.c dele=
ted in staging/staging-next and modified in HEAD. Version HEAD of drivers/s=
taging/rt2860/common/cmm_data_usb.c left in tree.
CONFLICT (content): Merge conflict in drivers/staging/usbip/vhci_sysfs.c
$ git rm -f drivers/staging/rt2860/common/cmm_data_pci.c drivers/staging/rt=
2860/common/cmm_data_usb.c
Merging slabh/slabh
Merging bkl-config/config
Merging cleancache/linux-next
Merging arm-dt/devicetree/arm-next
Merging scsi-post-merge/merge-base:master

--Signature=_Tue__17_May_2011_14_27_49_+1000_cMdttrfNC7ZEPTVx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN0flFAAoJEDMEi1NhKgbsdqQH/3Kq137uQRGxLG6gAzoVG7Zh
PQzhehThQ2iRkBYUFs3qT1QUqZpP0PVUWa9ryVoMtU3a3nPjibfw9nvqLqOswxoo
QSfL5irw5Q0HMdYHD9X1uxq3FAoeBkFAPnGAw7RIelXaswN/K7sLiPlNWvXyswb5
Xmog1armnFPVwjhWwDisgK8GuRKz5rbTqhp+M0RMG6JTXOvNbk8ppOHqjf71tOyK
Hzy/tvI1zkl+9GgrXFVGUDY4fyIQSd2+k/WLoWo3R6bL/sG8N13vUjv2antn/jFW
psswS0pWsQlOLAnqsSRAEasMY+/hLQ//jDuI5av1FA7MhzZyxvFe49fae4VauGg=
=2PZB
-----END PGP SIGNATURE-----

--Signature=_Tue__17_May_2011_14_27_49_+1000_cMdttrfNC7ZEPTVx--

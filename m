Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683Ab0DGHlh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 03:41:37 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:58525 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013Ab0DGHla (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 03:41:30 -0400
Date: Wed, 7 Apr 2010 17:41:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for April 7
Message-Id: <20100407174123.81b32310.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.1 (GTK+ 2.18.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__7_Apr_2010_17_41_23_+1000_4m_PZRjlyuB43aVj"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__7_Apr_2010_17_41_23_+1000_4m_PZRjlyuB43aVj
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20100401:

Dropped tree: tmio-mmc (long unresolved conflicts and unable to fetch)
	hwlat (at the maintainers request)

My fixes tree contains:
	a patch for a pktcdvd build error from Arnd Bergmann
	a fix for the commit that broke virtual consoles on PowerPC

The ceph tree lost its conflicts.

The hid tree lost its build failure.

The v4l-dvb tree gained a conflict against Linus' tree.

The kvm tree gained a build failure so I reverted the tree for today.

The net tree gained 2 conflicts against Linus' tree and a build failure
for which I reverted 2 commits.

The wireless tree gained a conflict against the wireless-current tree.

The sound tree gained a conflict against Linus' tree and a build failure
so I used the version from next-20100401.

The rr tree gained a conflict against the net tree.

The pcmcia tree gained a conflict against the net tree.

The mfd tree gained 2 build failures so I used the version from
next-20100401.

The slabh tree lost its build failure and all its conflicts.

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

We are up to 160 trees (counting Linus' and 22 trees of patches pending
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
Applying: ar9170: fix for driver-core ABI change
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
CONFLICT (content): Merge conflict in drivers/s390/char/vmcp.c
Merging sh/master
Merging genesis/master
Merging sparc/master
Merging xtensa/master
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
Merging reiserfs-bkl/reiserfs/kill-bkl
Merging vfs/for-next
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
CONFLICT (content): Merge conflict in drivers/media/video/meye.c
CONFLICT (content): Merge conflict in drivers/media/video/soc_camera.c
CONFLICT (content): Merge conflict in drivers/staging/cx25821/cx25821-audio=
-upstream.c
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
Merging dlm/next
Merging ibft/master
Merging scsi/master
Merging async_tx/next
Merging net/master
CONFLICT (content): Merge conflict in drivers/net/bonding/bond_main.c
CONFLICT (content): Merge conflict in drivers/net/via-velocity.c
CONFLICT (content): Merge conflict in drivers/net/wireless/iwlwifi/iwl-agn.c
CONFLICT (content): Merge conflict in drivers/net/wireless/wl12xx/wl1271_cm=
d.c
CONFLICT (content): Merge conflict in drivers/net/wireless/wl12xx/wl1271_ma=
in.c
CONFLICT (content): Merge conflict in drivers/net/wireless/wl12xx/wl1271_sp=
i.c
CONFLICT (content): Merge conflict in net/mac80211/scan.c
Merging wireless/master
CONFLICT (content): Merge conflict in Documentation/feature-removal-schedul=
e.txt
CONFLICT (content): Merge conflict in drivers/net/wireless/iwlwifi/iwl-4965=
.c
CONFLICT (content): Merge conflict in drivers/net/wireless/iwlwifi/iwl-core=
.c
CONFLICT (content): Merge conflict in drivers/net/wireless/iwlwifi/iwl-core=
.h
CONFLICT (content): Merge conflict in drivers/net/wireless/iwlwifi/iwl-tx.c
Applying: wireless: update gfp/slab.h includes
[master cb7ede2] Revert "net: Hook up cxgb4 to Kconfig and Makefile"
[master a824553] Revert "cxgb4: Add main driver file and driver Makefile"
Merging mtd/master
Applying: mtd: update gfp/slab.h includes
Merging crypto/master
Merging sound/for-next
CONFLICT (delete/modify): sound/soc/codecs/ad1938.c deleted in sound/for-ne=
xt and modified in HEAD. Version HEAD of sound/soc/codecs/ad1938.c left in =
tree.
$ git rm -f sound/soc/codecs/ad1938.c
Applying: sound: ASoC; merge fixup for slab.h changes
$ git reset --hard HEAD^
Merging refs/next/20100401/sound
CONFLICT (delete/modify): sound/soc/codecs/ad1938.c deleted in refs/next/20=
100401/sound and modified in HEAD. Version HEAD of sound/soc/codecs/ad1938.=
c left in tree.
$ git rm -f sound/soc/codecs/ad1938.c
Applying: sound: ASoC; merge fixup for slab.h changes
Merging cpufreq/next
Merging quilt/rr
CONFLICT (content): Merge conflict in include/linux/mod_devicetable.h
CONFLICT (content): Merge conflict in scripts/mod/file2alias.c
Merging mmc/next
Merging input/next
CONFLICT (content): Merge conflict in drivers/char/sysrq.c
Merging lsm/for-next
Merging block/for-next
Merging quilt/device-mapper
Merging embedded/master
Merging firmware/master
Merging pcmcia/master
CONFLICT (content): Merge conflict in drivers/net/pcmcia/3c589_cs.c
CONFLICT (content): Merge conflict in drivers/pcmcia/pcmcia_resource.c
Merging battery/master
Merging leds/for-mm
Merging backlight/for-mm
Merging kgdb/kgdb-next
Applying: kgdb: update for sysrq handling change
Applying: kdb: update gfp/slab.h includes
Merging slab/for-next
Merging uclinux/for-next
Merging md/for-next
Merging mfd/for-next
Applying: gpio: janz-ttl: using kzalloc/kfree requires including slab.h
$ git reset --hard HEAD^
Merging refs/next/20100401/mfd
Applying: mfd: update gfp/slab.h includes
Merging hdlc/hdlc-next
Merging drm/drm-next
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
CONFLICT (content): Merge conflict in fs/notify/inotify/inotify_user.c
CONFLICT (content): Merge conflict in include/linux/fsnotify.h
CONFLICT (content): Merge conflict in kernel/audit_tree.c
CONFLICT (content): Merge conflict in kernel/audit_watch.c
CONFLICT (content): Merge conflict in kernel/sysctl.c
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
Merging limits/writable_limits
CONFLICT (content): Merge conflict in arch/x86/ia32/ia32entry.S
CONFLICT (content): Merge conflict in arch/x86/include/asm/unistd_32.h
CONFLICT (content): Merge conflict in arch/x86/include/asm/unistd_64.h
CONFLICT (content): Merge conflict in arch/x86/kernel/syscall_table_32.S
Merging omap_dss2/for-next
Merging tip/auto-latest
Merging edac-amd/for-next
Merging oprofile/for-next
Merging percpu/for-next
Merging workqueues/for-next
Merging sfi/sfi-test
Merging asm-generic/next
Merging hwpoison/hwpoison
Merging sysctl/master
Merging quilt/driver-core
CONFLICT (content): Merge conflict in drivers/base/platform.c
Merging quilt/tty
Merging quilt/usb
Applying: usb: update gfp/slab.h includes
Merging quilt/staging
Applying: staging: update gfp/slab.h includes
Merging slabh/slabh
Merging scsi-post-merge/master
[master 6ec6c54] Revert "Merge remote branch 'kvm/linux-next'"

--Signature=_Wed__7_Apr_2010_17_41_23_+1000_4m_PZRjlyuB43aVj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAku8NyMACgkQjjKRsyhoI8wlmACglYSm70ed6B3V+N0pe42CFsx9
MWIAoJYhIR//3q1zmc1h4zddzvru9v1h
=yCn0
-----END PGP SIGNATURE-----

--Signature=_Wed__7_Apr_2010_17_41_23_+1000_4m_PZRjlyuB43aVj--

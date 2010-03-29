Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334Ab0C2H3R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 03:29:17 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:44716 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753301Ab0C2H3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 03:29:15 -0400
Date: Mon, 29 Mar 2010 18:29:08 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for March 29
Message-Id: <20100329182908.deb45810.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.1 (GTK+ 2.18.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__29_Mar_2010_18_29_08_+1100_6ZCsYiOrinUyAwsQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__29_Mar_2010_18_29_08_+1100_6ZCsYiOrinUyAwsQ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20100326:

New tree: slabh

Dropped tree: tmio-mmc (long unresolved conflicts and unable to fetch)

My fixes tree contains:
	a patch for a pktcdvd build error from Arnd Bergmann
	a revert of the commit that broke virtual consoles on PowerPC

The libata tree lost its conflict.

The net tree gained a build failure for which I applied a patch.

The mtd tree lost its conflict.

The slabh tree gained a conflict against the sound tree and 14 build
failures (due to interactions with other trees) for which I applied
patches.

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
[master 37f1885] Revert "hvc_console: Fix race between hvc_close and hvc_re=
move"
Merging arm/devel
Merging davinci/davinci-next
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
Merging squashfs/master
Merging udf/for_next
Merging v9fs/for-next
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
CONFLICT (content): Merge conflict in arch/x86/pci/acpi.c
Merging hid/for-next
Merging quilt/i2c
Merging bjdooks-i2c/next-i2c
Merging quilt/jdelvare-hwmon
Merging quilt/kernel-doc
Merging v4l-dvb/master
Merging kbuild/for-next
Merging kconfig/for-next
Merging ide/master
Merging libata/NEXT
Merging infiniband/for-next
Merging acpi/test
Merging ieee1394/for-next
Merging ubi/linux-next
Merging kvm/linux-next
Merging dlm/next
Merging ibft/master
Merging scsi/master
Merging async_tx/next
Merging net/master
Merging wireless/master
Merging mtd/master
Merging crypto/master
Merging sound/for-next
Merging cpufreq/next
Merging quilt/rr
CONFLICT (content): Merge conflict in MAINTAINERS
CONFLICT (content): Merge conflict in drivers/char/hvc_console.c
CONFLICT (content): Merge conflict in drivers/char/hvc_console.h
CONFLICT (content): Merge conflict in drivers/char/virtio_console.c
Merging mmc/next
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
Applying: kgdb: update for sysrq handling change
Merging slab/for-next
Merging uclinux/for-next
Merging md/for-next
Merging mfd/for-next
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
CONFLICT (content): Merge conflict in kernel/sysctl.c
Merging irda/for-next
CONFLICT (content): Merge conflict in drivers/net/irda/irda-usb.c
Merging hwlat/for-linus
CONFLICT (content): Merge conflict in MAINTAINERS
CONFLICT (content): Merge conflict in drivers/misc/Makefile
Merging drbd/for-jens
Merging catalin/for-next
Merging alacrity/linux-next
CONFLICT (content): Merge conflict in include/linux/Kbuild
CONFLICT (content): Merge conflict in lib/Kconfig
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
Merging quilt/tty
Merging quilt/usb
Merging quilt/staging
Merging scsi-post-merge/master
Merging slabh/slabh
CONFLICT (content): Merge conflict in drivers/char/sysrq.c
CONFLICT (content): Merge conflict in drivers/gpu/drm/radeon/r300.c
CONFLICT (content): Merge conflict in drivers/hid/hid-wacom.c
CONFLICT (content): Merge conflict in drivers/media/video/soc_camera.c
CONFLICT (content): Merge conflict in drivers/net/wireless/wl12xx/wl1271_cm=
d.c
CONFLICT (content): Merge conflict in drivers/net/wireless/wl12xx/wl1271_ma=
in.c
CONFLICT (content): Merge conflict in drivers/net/wireless/wl12xx/wl1271_sp=
i.c
CONFLICT (content): Merge conflict in drivers/pcmcia/pcmcia_resource.c
CONFLICT (content): Merge conflict in drivers/s390/char/vmcp.c
CONFLICT (content): Merge conflict in drivers/staging/cx25821/cx25821-audio=
-upstream.c
CONFLICT (content): Merge conflict in kernel/audit_watch.c
CONFLICT (content): Merge conflict in net/mac80211/scan.c
CONFLICT (delete/modify): sound/soc/codecs/ad1938.c deleted in HEAD and mod=
ified in slabh/slabh. Version slabh/slabh of sound/soc/codecs/ad1938.c left=
 in tree.
$ git rm -f sound/soc/codecs/ad1938.c
Applying: sound: update for removeal of slab.h from percpu.h
Applying: hwlat: using kzalloc/kfree requires the include of slab.h
Applying: kgdb: use of kmalloc/kfree requires the include of slab.h
Applying: async_tx: use of kzalloc/kfree requires the include of slab.h
Applying: sound: use of kmalloc requires the include of slab.h
Applying: sound: quirks: use of kmalloc/kfree requires the include of slab.h
Applying: Input: ad714x: use of kzalloc/kfree requires the include of slab.h
Applying: sound: usb format: use of kmalloc/kzalloc/kfree requires the incl=
ude of slab.h
Applying: sound: usb endpoint: use of kzalloc/kfree requires the include of=
 slab.h
Applying: sound: usb pcm: use of kmalloc requires the include of slab.h
Applying: input: pcf8574_keypad: use of kzalloc/kfree requires the include =
of slab.h
Applying: mtd: SmartMedia/xD FTL: use of kmalloc/kfree requires the include=
 of slab.h
Applying: vbus: use of kzalloc/kfree requires the include of slab.h
Applying: sound: usb helper: use of kfree requires the include of slab.h
Applying: rps: fix net-sysfs build for !CONFIG_RPS
Applying: Asoc: TWL6040: use of kzalloc/kfree requires the include of slab.h

--Signature=_Mon__29_Mar_2010_18_29_08_+1100_6ZCsYiOrinUyAwsQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuwVsQACgkQjjKRsyhoI8y7tACdEzF6HI7IFr3fgcfbxiPPkljC
NXkAnRZDDsfE8Ed1psE2gts2JF8uJFJa
=msro
-----END PGP SIGNATURE-----

--Signature=_Mon__29_Mar_2010_18_29_08_+1100_6ZCsYiOrinUyAwsQ--

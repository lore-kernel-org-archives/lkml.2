Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466Ab1GDHKH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 03:10:07 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56151 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751380Ab1GDHKC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 03:10:02 -0400
Date: Mon, 4 Jul 2011 17:09:52 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for July 4
Message-Id: <20110704170952.1024e89b.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__4_Jul_2011_17_09_52_+1000_MWJMmziAp2_6i3wN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__4_Jul_2011_17_09_52_+1000_MWJMmziAp2_6i3wN
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20110701:

The powerpc tree lost its build failures.

The v4l-dvb tree gained a build failure so I used the version from
next-20110701.

The block tree gained a build failure so I used the version from
next-20110701.

The akpm tree still has its two build failures for which I revertd a
commit and applied a patch.

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

We are up to 195 trees (counting Linus' and 28 trees of patches pending
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
CONFLICT (content): Merge conflict in arch/arm/mm/dma-mapping.c
CONFLICT (content): Merge conflict in arch/arm/mm/proc-v7.S
Merging at91/at91-next
Merging davinci/davinci-next
Merging i.MX/for-next
CONFLICT (content): Merge conflict in arch/arm/plat-mxc/devices/platform-im=
x-dma.c
Merging linux-spec/for-next
Merging msm/for-next
Merging omap/for-next
Merging pxa/for-next
Merging samsung/next-samsung
Merging s5p/for-next
Merging tegra/for-next
Merging ux500-core/ux500-core
Merging xilinx/arm-next
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
Merging xtensa/master
CONFLICT (content): Merge conflict in arch/xtensa/configs/iss_defconfig
Merging ceph/for-next
CONFLICT (content): Merge conflict in fs/ceph/export.c
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
CONFLICT (content): Merge conflict in MAINTAINERS
$ git reset --hard HEAD^
Merging refs/next/20110701/v4l-dvb
Merging kbuild/for-next
Merging kconfig/for-next
Merging ide/master
Merging libata/NEXT
CONFLICT (content): Merge conflict in drivers/ata/libahci.c
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
CONFLICT (content): Merge conflict in drivers/net/wireless/iwlwifi/iwl-tx.c
CONFLICT (content): Merge conflict in drivers/scsi/bnx2fc/bnx2fc.h
CONFLICT (content): Merge conflict in drivers/scsi/bnx2fc/bnx2fc_fcoe.c
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
$ git reset --hard HEAD^
Merging refs/next/20110701/block
CONFLICT (content): Merge conflict in block/blk-throttle.c
[master 174d913] Merge commit 'refs/next/20110701/block'
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
CONFLICT (delete/modify): arch/arm/mach-ep93xx/dma-m2p.c deleted in HEAD an=
d modified in trivial/for-next. Version trivial/for-next of arch/arm/mach-e=
p93xx/dma-m2p.c left in tree.
CONFLICT (content): Merge conflict in drivers/mtd/maps/pxa2xx-flash.c
$ git rm -f arch/arm/mach-ep93xx/dma-m2p.c
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
CONFLICT (content): Merge conflict in drivers/gpio/Makefile
CONFLICT (content): Merge conflict in drivers/gpio/gpio-ep93xx.c
Merging tip/auto-latest
Merging rcu/rcu/next
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
CONFLICT (content): Merge conflict in Documentation/feature-removal-schedul=
e.txt
Merging staging/staging-next
CONFLICT (content): Merge conflict in Documentation/feature-removal-schedul=
e.txt
CONFLICT (content): Merge conflict in drivers/staging/brcm80211/Kconfig
CONFLICT (content): Merge conflict in drivers/staging/brcm80211/brcmfmac/dh=
d_linux.c
CONFLICT (content): Merge conflict in drivers/staging/brcm80211/brcmfmac/dh=
d_sdio.c
CONFLICT (content): Merge conflict in drivers/staging/brcm80211/brcmfmac/wl=
_cfg80211.h
CONFLICT (content): Merge conflict in drivers/staging/brcm80211/brcmfmac/wl=
_iw.c
CONFLICT (content): Merge conflict in drivers/staging/usbip/userspace/src/u=
tils.h
Merging bkl-config/config
Merging tmem/linux-next
Merging writeback/next
Merging arm-dt/devicetree/arm-next
Merging scsi-post-merge/merge-base:master
$ git checkout akpm
Applying: During allocator-intensive workloads, kswapd will be woken freque=
ntly
Applying: During allocator-intensive workloads, kswapd will be woken freque=
ntly
Applying: When deciding if kswapd is sleeping prematurely, the classzone is=
 taken
Applying: During allocator-intensive workloads, kswapd will be woken freque=
ntly
Applying: __tlb_remove_page() switches to a new batch page, but still check=
s space
Applying: Now, in mem_cgroup_hierarchical_reclaim(), mem_cgroup_local_usage=
() is
Applying: ERROR: code indent should use tabs where possible
Applying: fix kerneldoc layout
Applying: commit 889976dbcb12 ("memcg: reclaim memory from nodes in round-r=
obin
Applying: attempt to repair code layout
Applying: Currently we are keeping faulted page locked throughout whole __d=
o_fault
Applying: fix code layout
Applying: The often-NULL data arg to read_cache_page() and read_mapping_pag=
e()
Applying: Correct comment on truncate_inode_pages*() in linux/mm.h; and rem=
ove
Applying: Use consistent variable names in truncate_pagecache(), truncate_s=
etsize(),
Applying: Make the pagevec_lookup loops in truncate_inode_pages_range(),
Applying: truncate_inode_pages_range()'s final loop has a nice pincer prope=
rty,
Applying: 2.6.36's 7e496299d4d2 ("tmpfs: make tmpfs scalable with percpu_co=
unter for
Applying: remap_pfn_range() means map physical address pfn<<PAGE_SHIFT to u=
ser addr.
Applying: Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Applying: If dmi_get_system_info() returns NULL, pch_phub_probe() will dere=
ferencea
Applying: Vito said:
Applying: kernel/fork.c:267: error: implicit declaration of function
Applying: WARNING: line over 80 characters
Applying: arch/cris/arch-v10/drivers/sync_serial.c:628: error: 'ret' undecl=
ared (first use in this function)
Applying: arch/cris/arch-v10/drivers/sync_serial.c:961: error: conflicting =
types for 'sync_serial_ioctl'
Applying: arch/cris/arch-v10/kernel/irq.c:239: error: implicit declaration =
of function 'kgdb_init'
Applying: hfsplus leaks bio objects by failing to call bio_put() on the bio=
s it
Applying: There's a code path in pmcraid that can be reached via device ioc=
tl that
Applying: The out_msi_disable label should be before cleanup_nomem to addit=
ionally
Applying: ERROR: "__bad_udelay" [drivers/net/wireless/rtlwifi/rtl8192de/rtl=
8192de.ko] undefined!
Applying: It's about time to revert 16d752397301b9 ("thermal: Create
Applying: We'll soon need to reuse it.
Applying: THERMAL_HWMON is implemented inside the thermal_sys driver and ha=
s no
Applying: b552a8c56db8 ("ACPI: remove NID_INVAL") removed the left over use=
s of
Applying: Add support for Aspire 1410 BIOS v1.3314.  Fixes the following er=
ror:
Applying: With a non-constant 8-bit argument, a call to udelay() generates =
a warning:
Applying: On x86_32 casting the unsigned int result of get_random_int() to =
long may
Applying: This new driver replaces the old PCEngines Alix 2/3 LED driver wi=
th a new
Applying: Replace the bubble sort in sanitize_e820_map() with a call to the=
 generic
Applying: In response to new device tree code in the kernel, OLPC will star=
t using
Applying: Move these definitions into the relevant header file.  This was r=
equested
Applying: Based on earlier review comments, we'll no longer try to stick al=
l of our
Applying: Add code needed for basic suspend/resume of the XO-1 laptop.  Bas=
ed on
Applying: The System Control Interrupt is used in the OLPC XO-1 to control =
various
Applying: Update the EC SCI masks with recent additions.
Applying: The EC in the OLPC XO-1 delivers GPE events to provide various
Applying: Configure the XO-1's lid switch GPIO to trigger an SCI interrupt,=
 and
Applying: EC events indicate change in AC power connectivity, battery state=
 of
Applying: Add a driver to configure the XO-1 RTC via CS5536 MSRs, to be use=
d as a
Applying: Add a driver for the ACPI-based EC event interface found on the O=
LPC
Applying: MTRR rendezvous sequence using stop_one_cpu_nowait() can potentia=
lly
CONFLICT (content): Merge conflict in arch/x86/kernel/cpu/mtrr/main.c
Applying: Refactor the queuing part of the stop cpus work from __stop_cpus(=
) into
Applying: Currently, mtrr wants stop_machine functionality while a CPU is b=
eing
Applying: MTRR rendezvous sequence is not implemened using stop_machine() b=
efore, as
Applying: Don't allow everybody to use a modem.
Applying: The address limit is already set in flush_old_exec() so this
Applying: A call to va_copy() should always be followed by a call to va_end=
() in the
Applying: Don't dereference em if it's NULL or an error pointer.
Applying: The buffer 'sc.cpu_mask' is a kernel buffer.  If bitmap_parse is =
used
Applying: The address limit is already set in flush_old_exec() so this
Applying: fb_set_suspend() must be called with the console semaphore held, =
which
Applying: When 1280x1024@75Hz mode is set, console palette is not set prope=
rly -
Applying: Unless I'm very much missing something these tests are intended t=
o check
Applying: The address limit is already set in flush_old_exec() so this
Applying: The address limit is already set in flush_old_exec() so this
Applying: The address limit is already set in flush_old_exec() via set_fs(U=
SER_DS)
Applying: The address limit is already set in flush_old_exec() so this
Applying: - Fix checking of wrong return value for backlight_device_registe=
r()
Applying: Add the ams369fg06 amoled panel driver.  The ams369fg06 amoled pa=
nel (480
Applying: Not all systems expose a firmware or platform mechanism for chang=
ing the
Applying: The Apple MBP model 6.2 (and maybe other recent MBPs) uses an App=
le
Applying: ext4_{set,clear}_bit() is defined as __test_and_{set,clear}_bit_l=
e() for
Applying: The dqc_bitmap field of struct ocfs2_local_disk_chunk is 32-bit a=
ligned,
Applying: The address limit is already set in flush_old_exec() so those cal=
ls to
Applying: When do pci remove/rescan on system that have more iommus, got
Applying: The current implementation of dmi_name_in_vendors() is an invitat=
ion to
Applying: When hot-plugging a root bridge, we always prevent assigning a bu=
s number
Applying: fix comment layout
Applying: Aside of the usual motivation for constification, this function h=
as a
Applying: The address limit is already set in flush_old_exec() so those cal=
ls to
Applying: For headers that get exported to userland and make use of u32 sty=
le
Applying: Fix sparse warnings of right shift bigger than source value size:
Applying: brd_make_request() always returns 0, which doesn't make much sens=
e.
Applying: Remove the (unsigned long long) cast in diskstats_show() and adju=
sts the
Applying: The address limit is already set in flush_old_exec() so this assi=
gnment of
Applying: x86_64 allmodconfig:
Applying: x86_64 allmodconfig:
Applying: alpha allmodconfig:
Applying: alpha allmodconfig:
Applying: alpha allmodconfig:
Applying: Cc: Greg KH <greg@kroah.com>
Applying: Use the nice enumerated constant.
Applying: There is no need to define VM_{STACK,DATA}_DEFAULT_FLAGS as varia=
ble.
Applying: The address limit is already set in flush_old_exec() so this
Applying: Both sys-i386 and sys-x86_64 support now ndelay().  The delay fun=
ctions
Applying: When UML is compiled with _FORTIFY_SOURCE we have to export all _=
chk()
Applying: To make netconsole usable on UML, its ethernet driver needs netpo=
ll
Applying: commit 0954828fcbf3bd13d593499b16b901a4e801b0b9 ("kconfig: replace
Applying: We presently define all kinds of notifiers in notifier.h.  This i=
s not
Applying: It is not necessary to share the same notifier.h.
Applying: It is not necessary to share the same notifier.h.
Applying: It is not necessary to share the same notifier.h.
Applying: Cc: David Miller <davem@davemloft.net>
Applying: It is not necessary to share the same notifier.h.
Applying: If CONFIG_IKCONFIG=3Dm but CONFIG_IKCONFIG_PROC=3Dn we get a modu=
le that has
Applying: For each CPU, do the calibration delay only once.  For subsequent=
 calls,
Applying: make cpu_loops_per_jiffy static
Applying: Cc: Andrew Worsley <amworsley@gmail.com>
Applying: prevent ARM build breakage :)
Applying: fix things up after upstream rmk changes
Applying: MPC5200B contains a limited version of RTC from MPC5121.  Add sup=
port for
Applying: Add support for clock gating.  Power consumption can be reduced b=
y setting
Applying: Add support for PMIC8xxx based RTC.  PMIC8xxx is Qualcomm's power
Applying: cosmetic tweaks
Applying: Signed-off-by: Anirudh Ghayal <aghayal@codeaurora.org>
Merging akpm
[master f6e3d8e] Revert "It is not necessary to share the same notifier.h."
Applying: backlight: make some varibales static

--Signature=_Mon__4_Jul_2011_17_09_52_+1000_MWJMmziAp2_6i3wN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEbBAEBAgAGBQJOEWdAAAoJEDMEi1NhKgbs158H9iaKZUcAFbxvVHLc5J3a08ok
PMtKzUH9ms8Cqa8TZhwMlgOqgA3lIZAAfTJ0fL+ZWKhwLMTOFIVP8wAmENwbDEFh
ZUGlrF6vTdvhE1W42Z2xKFfgFSFEITRSwNRP2PhCKSzjnkSdVjWCOsdL5bjn4O7H
vnObnt7B2j4z1/LUZsGiqy/uzEd6hf7nCN8Od1vivuA5nMUgXm1gqvy9XIoLxJrt
0cJrnxs417uaKcZQpcwYwwt38IEcsDyxtFQRkMN1JBrEcptuLhw8gERbVwA5rO6Q
atv18KfnDExlK2+oyASs6HrOORg64Dw9ib8XA6+McErMOMc6+bi8Zb06sfPUBw==
=vLvz
-----END PGP SIGNATURE-----

--Signature=_Mon__4_Jul_2011_17_09_52_+1000_MWJMmziAp2_6i3wN--

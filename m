Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949Ab1GUGzw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 02:55:52 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:51063 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973Ab1GUGzu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 02:55:50 -0400
Date: Thu, 21 Jul 2011 16:55:42 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for July 21
Message-Id: <20110721165542.7748c88a1d1e0b228c7fe3fa@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__21_Jul_2011_16_55_42_+1000_PDy/yRTiTxGpAysK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__21_Jul_2011_16_55_42_+1000_PDy/yRTiTxGpAysK
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

The powerpc allyesconfig build (at least) still fails today.  The sparc
and sparc64 defconfigs are fixed by a patch I applied from Al Viro.

Changes since 20110720:

The s5p tree lost 2 conflicts.

The mmc tree lost its conflicts.

The security-testing tree still has its build failure.

The staging tree still has its build failure but lost 3 conflicts.

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

We are up to 198 trees (counting Linus' and 28 trees of patches pending
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
CONFLICT (content): Merge conflict in arch/arm/include/asm/proc-fns.h
CONFLICT (content): Merge conflict in arch/arm/include/asm/tlb.h
CONFLICT (content): Merge conflict in arch/arm/mm/context.c
CONFLICT (content): Merge conflict in arch/arm/mm/proc-v7.S
Merging arm-soc/for-next
Merging at91/at91-next
Merging davinci/davinci-next
Merging i.MX/for-next
CONFLICT (content): Merge conflict in arch/arm/mach-imx/mach-mx27_3ds.c
CONFLICT (content): Merge conflict in arch/arm/mach-imx/mm-imx1.c
CONFLICT (content): Merge conflict in arch/arm/mach-imx/mm-imx21.c
CONFLICT (content): Merge conflict in arch/arm/mach-imx/mm-imx25.c
CONFLICT (content): Merge conflict in arch/arm/mach-imx/mm-imx27.c
CONFLICT (content): Merge conflict in arch/arm/mach-imx/mm-imx31.c
CONFLICT (content): Merge conflict in arch/arm/mach-imx/mm-imx35.c
CONFLICT (content): Merge conflict in arch/arm/mach-mx5/mm.c
Merging linux-spec/for-next
Merging msm/for-next
Merging omap/for-next
Merging pxa/for-next
Merging samsung/next-samsung
Merging s5p/for-next
CONFLICT (content): Merge conflict in arch/arm/mach-exynos4/pm.c
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
Merging openrisc/for-upstream
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
CONFLICT (content): Merge conflict in fs/ext3/fsync.c
CONFLICT (content): Merge conflict in fs/ext4/inode.c
CONFLICT (content): Merge conflict in fs/xfs/linux-2.6/xfs_super.c
Applying: vfs/nfs: fixup for nfs_open_context change
Applying: vfs/ext4: merge fixup for moved function
Merging vfs-scale/vfs-scale-working
Merging pci/linux-next
Merging of-pci/of-pci
CONFLICT (content): Merge conflict in arch/microblaze/include/asm/pci-bridg=
e.h
Merging hid/for-next
Merging quilt/i2c
Merging bjdooks-i2c/next-i2c
Merging quilt/jdelvare-hwmon
CONFLICT (content): Merge conflict in drivers/hwmon/max1111.c
Merging hwmon-staging/hwmon-next
Merging quilt/kernel-doc
Merging docs/docs-move
Merging v4l-dvb/master
Merging kbuild/for-next
Merging kconfig/for-next
Merging ide/master
Merging libata/NEXT
CONFLICT (content): Merge conflict in drivers/ata/libahci.c
Merging infiniband/for-next
Merging acpi/test
CONFLICT (content): Merge conflict in arch/ia64/Kconfig
CONFLICT (content): Merge conflict in arch/powerpc/Kconfig
Merging idle-test/idle-test
Merging powertools/tools-test
Merging cpupowerutils/master
Merging ieee1394/for-next
Merging ubi/linux-next
Merging dlm/next
Merging swiotlb/master
Merging ibft/master
Merging scsi/master
Merging slave-dma/next
CONFLICT (content): Merge conflict in arch/arm/mach-ep93xx/Makefile
Merging async_tx/next
Merging net/master
CONFLICT (content): Merge conflict in drivers/Makefile
CONFLICT (content): Merge conflict in drivers/scsi/bnx2fc/bnx2fc.h
CONFLICT (content): Merge conflict in drivers/scsi/bnx2fc/bnx2fc_fcoe.c
CONFLICT (content): Merge conflict in lib/Kconfig
CONFLICT (content): Merge conflict in lib/Makefile
CONFLICT (content): Merge conflict in net/bluetooth/l2cap_core.c
Merging wireless/master
Merging bluetooth/master
Merging mtd/master
Merging l2-mtd/master
Merging crypto/master
Merging sound/for-next
Merging sound-asoc/for-next
Merging cpufreq/next
CONFLICT (content): Merge conflict in drivers/cpufreq/Kconfig
CONFLICT (content): Merge conflict in drivers/cpufreq/Makefile
Merging quilt/rr
CONFLICT (delete/modify): arch/m68k/kernel/module_mm.c deleted in HEAD and =
modified in quilt/rr. Version quilt/rr of arch/m68k/kernel/module_mm.c left=
 in tree.
CONFLICT (delete/modify): arch/m68k/kernel/module_no.c deleted in HEAD and =
modified in quilt/rr. Version quilt/rr of arch/m68k/kernel/module_no.c left=
 in tree.
$ git rm -f arch/m68k/kernel/module_mm.c arch/m68k/kernel/module_no.c
Applying: modules/m68k: make arch's use default loader hooks
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
Merging kgdb/kgdb-next
Merging slab/for-next
Merging uclinux/for-next
Merging md/for-next
Merging mfd/for-next
CONFLICT (content): Merge conflict in drivers/gpio/Makefile
CONFLICT (content): Merge conflict in drivers/mfd/Makefile
Merging hdlc/hdlc-next
Merging drm/drm-next
Merging fbdev/master
Merging viafb/viafb-next
Merging omap_dss2/for-next
Merging voltage/for-next
Merging security-testing/next
CONFLICT (content): Merge conflict in security/tomoyo/realpath.c
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
CONFLICT (content): Merge conflict in Documentation/feature-removal-schedul=
e.txt
CONFLICT (delete/modify): arch/arm/mach-ep93xx/dma-m2p.c deleted in HEAD an=
d modified in trivial/for-next. Version trivial/for-next of arch/arm/mach-e=
p93xx/dma-m2p.c left in tree.
CONFLICT (content): Merge conflict in drivers/dma/mv_xor.c
CONFLICT (content): Merge conflict in drivers/gpio/gpio-ep93xx.c
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
Merging tip/auto-latest
CONFLICT (content): Merge conflict in arch/x86/Kconfig
CONFLICT (content): Merge conflict in drivers/Kconfig
CONFLICT (content): Merge conflict in drivers/Makefile
CONFLICT (content): Merge conflict in include/linux/pci.h
Merging rcu/rcu/next
Merging kvm/linux-next
Merging oprofile/for-next
Merging ptrace/ptrace
CONFLICT (content): Merge conflict in arch/s390/kernel/traps.c
Merging xen/upstream/xen
Merging xen-two/linux-next
Merging xen-pvhvm/linux-next
Merging edac-amd/for-next
Merging percpu/for-next
Merging workqueues/for-next
CONFLICT (content): Merge conflict in Documentation/feature-removal-schedul=
e.txt
Merging sfi/sfi-test
Merging asm-generic/next
Merging drivers-x86/linux-next
CONFLICT (content): Merge conflict in Documentation/feature-removal-schedul=
e.txt
Merging hwpoison/hwpoison
Merging sysctl/master
Merging namespace/master
Merging regmap/for-next
Merging driver-core/driver-core-next
Merging tty/tty-next
Merging usb/usb-next
CONFLICT (content): Merge conflict in Documentation/feature-removal-schedul=
e.txt
Merging staging/staging-next
CONFLICT (content): Merge conflict in Documentation/feature-removal-schedul=
e.txt
CONFLICT (content): Merge conflict in drivers/staging/bcm/headers.h
CONFLICT (content): Merge conflict in drivers/staging/brcm80211/brcmfmac/dh=
d_linux.c
CONFLICT (content): Merge conflict in drivers/staging/brcm80211/brcmfmac/dh=
d_sdio.c
CONFLICT (content): Merge conflict in drivers/staging/brcm80211/brcmfmac/wl=
_cfg80211.h
CONFLICT (delete/modify): drivers/staging/brcm80211/brcmfmac/wl_iw.c delete=
d in staging/staging-next and modified in HEAD. Version HEAD of drivers/sta=
ging/brcm80211/brcmfmac/wl_iw.c left in tree.
CONFLICT (content): Merge conflict in drivers/staging/rtl8187se/ieee80211/i=
eee80211_softmac.c
CONFLICT (content): Merge conflict in drivers/staging/rtl8192e/r8192E.h
CONFLICT (content): Merge conflict in drivers/staging/tm6000/tm6000-alsa.c
CONFLICT (content): Merge conflict in drivers/staging/usbip/userspace/src/u=
tils.h
$ git rm -f drivers/staging/brcm80211/brcmfmac/wl_iw.c
Merging bkl-config/config
Merging tmem/linux-next
Merging writeback/next
CONFLICT (content): Merge conflict in fs/fs-writeback.c
CONFLICT (content): Merge conflict in mm/filemap.c
Merging arm-dt/devicetree/arm-next
Merging scsi-post-merge/merge-base:master
$ git checkout akpm
Applying: During allocator-intensive workloads, kswapd will be woken freque=
ntly
Applying: During allocator-intensive workloads, kswapd will be woken freque=
ntly
CONFLICT (content): Merge conflict in mm/vmscan.c
Applying: When deciding if kswapd is sleeping prematurely, the classzone is=
 taken
Applying: During allocator-intensive workloads, kswapd will be woken freque=
ntly
Applying: __tlb_remove_page() switches to a new batch page, but still check=
s space
Applying: Now, in mem_cgroup_hierarchical_reclaim(), mem_cgroup_local_usage=
() is
CONFLICT (content): Merge conflict in mm/memcontrol.c
Applying: ERROR: code indent should use tabs where possible
Applying: fix kerneldoc layout
Applying:  memcg-fix-reclaimable-lru-check-in-memcg.patch
Applying: commit 889976dbcb12 ("memcg: reclaim memory from nodes in round-r=
obin
CONFLICT (content): Merge conflict in mm/memcontrol.c
Applying: attempt to repair code layout
Applying: Currently we are keeping faulted page locked throughout whole __d=
o_fault
Applying: fix code layout
Applying: This fixes a regression in 3.0 reported by Paul Parsons regarding=
 the
CONFLICT (content): Merge conflict in drivers/w1/masters/ds1wm.c
Applying: ERROR: Invalid UTF-8, patch and commit message should be encoded =
in UTF-8
Applying: remap_pfn_range() means map physical address pfn<<PAGE_SHIFT to u=
ser addr.
CONFLICT (content): Merge conflict in mm/nommu.c
Applying: Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Applying: This driver handles the variants pca9530-pca9533, so it chose the=
 name
Applying: Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Applying: Prevent an arbitrary kernel read.  Check the user pointer with ac=
cess_ok()
Applying: s/EIO/EFAULT/
Applying: The often-NULL data arg to read_cache_page() and read_mapping_pag=
e()
Applying: Correct comment on truncate_inode_pages*() in linux/mm.h; and rem=
ove
Applying: Use consistent variable names in truncate_pagecache(), truncate_s=
etsize(),
CONFLICT (content): Merge conflict in mm/truncate.c
Applying: Use consistent variable names in truncate_pagecache(), truncate_s=
etsize(),
Applying: Make the pagevec_lookup loops in truncate_inode_pages_range(),
Applying: truncate_inode_pages_range()'s final loop has a nice pincer prope=
rty,
Applying: 2.6.36's 7e496299d4d2 ("tmpfs: make tmpfs scalable with percpu_co=
unter for
Applying: If dmi_get_system_info() returns NULL, pch_phub_probe() will dere=
ferencea
Applying: Vito said:
Applying: I came across a memory leak during a cyclic cpu-online-offline te=
st.
Applying: kernel/fork.c:267: error: implicit declaration of function
Applying: WARNING: line over 80 characters
Applying: arch/cris/arch-v10/drivers/sync_serial.c:628: error: 'ret' undecl=
ared (first use in this function)
Applying: arch/cris/arch-v10/drivers/sync_serial.c:961: error: conflicting =
types for 'sync_serial_ioctl'
Applying: arch/cris/arch-v10/kernel/irq.c:239: error: implicit declaration =
of function 'kgdb_init'
Applying: This reverts my commit a3d77411e8b2ad ("dell-laptop: Toggle the
Applying: There's a code path in pmcraid that can be reached via device ioc=
tl that
Applying: The out_msi_disable label should be before cleanup_nomem to addit=
ionally
Applying: The parameter's origin type is long.  On an i386 architecture, it=
 can
Applying: kernel/time.c:578: error: conflicting types for 'jiffies_to_clock=
_t'
Applying: It's about time to revert 16d752397301b9 ("thermal: Create
Applying: We'll soon need to reuse it.
Applying: THERMAL_HWMON is implemented inside the thermal_sys driver and ha=
s no
Applying: b552a8c56db8 ("ACPI: remove NID_INVAL") removed the left over use=
s of
Applying: Linux supports some optional features, but it should notify the B=
IOS about
Applying: Add support for Aspire 1410 BIOS v1.3314.  Fixes the following er=
ror:
Applying: This makes the iris driver use the platform API, so it is properl=
y exposed
Applying: - remove commented-out code
Applying: There was one code block that I commented to be able to test the =
patch dnd
Applying: With a non-constant 8-bit argument, a call to udelay() generates =
a warning:
CONFLICT (content): Merge conflict in arch/x86/include/asm/delay.h
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
Applying: When IKCONFIG is built-in, make oldconfig will cause the kernel t=
o be
Applying: The address limit is already set in flush_old_exec() so this
Applying: The address limit is already set in flush_old_exec() via set_fs(U=
SER_DS)
Applying: The address limit is already set in flush_old_exec() so this
Applying: Mike McLagan hasn't contributed in many years and his email bounc=
es.
Applying: Addresses https://bugzilla.kernel.org/show_bug.cgi?id=3D38862
CONFLICT (content): Merge conflict in drivers/net/skge.c
Applying: - Fix checking of wrong return value for backlight_device_registe=
r()
Applying: Add the ams369fg06 amoled panel driver.  The ams369fg06 amoled pa=
nel (480
Applying: backlight: make some varibales static
Applying: unregister backlight device when unloading the module
Applying: Fix section mismatch warning by adding the correct annotation __d=
evinit
Applying: It's only used in ams369fg06.c, no need for it to be in the globa=
l namespace.
Applying: Since commit a19a6ee "backlight: Allow properties to be passed at
Applying: backlight_device_register() returns ERR_PTR() on error.
Applying: 1. current implementation tests wrong value for setting aat2870_b=
l->max_current.
Applying: i386 allmodconfig:
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
Applying: We leak in drivers/scsi/aacraid/commctrl.c::aac_send_raw_srb() :
Applying: brd_make_request() always returns 0, which doesn't make much sens=
e.
Applying: Remove the (unsigned long long) cast in diskstats_show() and adju=
sts the
Applying: Fix the loopback device to emit a uevent on auto release.  The lo=
opback
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
Applying: With this patch applied, make allyesconfig succeeds on ppc64.
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
Applying: We forget to save the return value of the call to
Merging akpm
Applying: linux-next: build failure after merge of the final tree (maybe vf=
s tree related)

--Signature=_Thu__21_Jul_2011_16_55_42_+1000_PDy/yRTiTxGpAysK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOJ81uAAoJEDMEi1NhKgbssc4H/RR0EWN6WPaXr4WBL/PYygu4
0FIhYbPPcEI5ltxGWnr/GlNtO9nStDrRRoxLd/dqDv5r7CWB8PdINJXTmLpzbWgc
to11Z6sctBVQH+PXvgOOJigyeKb7TAUZp6r5mF0nilo9WXZkCKG1j8SYlZ0s1R/P
QTFvFf43DADLWtwS1Wkl7D4P7GXGQkf8uz5xi4/rorBn9/ENmnIFLwplPZvGfDHf
g0ucIuSB0leXmvDHbHDCarIprMkLkRptGD3Te3H+ylq9CiXkrJXwYw/K8Q+8xdmb
H+NKvv3TYlZMhvKD1CGqB18yQwkgIjaOIOhABXLnK734orRhcEKMSzPZ9zE4S74=
=jATG
-----END PGP SIGNATURE-----

--Signature=_Thu__21_Jul_2011_16_55_42_+1000_PDy/yRTiTxGpAysK--

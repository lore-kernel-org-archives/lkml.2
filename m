Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724Ab1IOHPQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 03:15:16 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:48902 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754623Ab1IOHPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 03:15:14 -0400
Date: Thu, 15 Sep 2011 17:15:00 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Sept 15
Message-Id: <20110915171500.509eb82fd27927da04d6fb79@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__15_Sep_2011_17_15_00_+1000_9YwyeW4maOch+rta"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__15_Sep_2011_17_15_00_+1000_9YwyeW4maOch+rta
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

With master.kernel.org down, some trees have moved to temporary locations
(so some updates are coming through).  However, the actual release of the
linux-next trees will be delayed until master returns.  I will still do
the overnight builds, though.

The powerpc allyesconfig build still fails today.

Changes since 20110914:

The xfs tree gained a conflict against Linus' tree.

The hid tree lost its conflicts.

The wireless tree gained conflicts against Linus' tree.

The security tree gained a build failure for which I applied a patch.

The xen tree gained a build failure so I used the version from
next-20110914.

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

We are up to 200 trees (counting Linus' and 27 trees of patches pending
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
Merging devicetree-current/devicetree/merge
Merging spi-current/spi/merge
Merging arm/for-next
Merging arm-lpae/for-next
CONFLICT (content): Merge conflict in arch/arm/include/asm/page.h
CONFLICT (content): Merge conflict in arch/arm/include/asm/pgalloc.h
CONFLICT (content): Merge conflict in arch/arm/include/asm/pgtable-hwdef.h
CONFLICT (content): Merge conflict in arch/arm/include/asm/pgtable.h
CONFLICT (content): Merge conflict in arch/arm/include/asm/tlb.h
CONFLICT (content): Merge conflict in arch/arm/kernel/head.S
CONFLICT (content): Merge conflict in arch/arm/kernel/sleep.S
CONFLICT (content): Merge conflict in arch/arm/mm/dma-mapping.c
CONFLICT (content): Merge conflict in arch/arm/mm/mmu.c
Merging arm-soc/for-next
CONFLICT (content): Merge conflict in arch/arm/include/asm/hardware/cache-l=
2x0.h
CONFLICT (delete/modify): arch/arm/mach-at91/board-usb-a9260.c deleted in a=
rm-soc/for-next and modified in HEAD. Version HEAD of arch/arm/mach-at91/bo=
ard-usb-a9260.c left in tree.
CONFLICT (content): Merge conflict in arch/arm/mach-msm/board-msm8x60.c
CONFLICT (content): Merge conflict in arch/arm/mach-mxs/include/mach/gpio.h
CONFLICT (content): Merge conflict in arch/arm/mach-u300/Makefile.boot
CONFLICT (content): Merge conflict in arch/arm/plat-mxc/include/mach/gpio.h
$ git rm -f arch/arm/mach-at91/board-usb-a9260.c
Applying: arm-soc: merge fixup for fixup/reserve being added to MACHINE des=
criptions
Merging at91/at91-next
Merging davinci/davinci-next
Merging i.MX/for-next
Merging linux-spec/for-next
Merging omap/for-next
Merging pxa/for-next
Merging samsung/next-samsung
Merging s5p/for-next
CONFLICT (delete/modify): arch/arm/mach-exynos4/mach-smdkc210.c deleted in =
s5p/for-next and modified in HEAD. Version HEAD of arch/arm/mach-exynos4/ma=
ch-smdkc210.c left in tree.
$ git rm -f arch/arm/mach-exynos4/mach-smdkc210.c
Applying: s5p: merge fixup for atags_offset use
Merging tegra/for-next
Merging ux500-core/ux500-core
Merging xilinx/arm-next
Merging blackfin/for-linus
Merging cris/for-next
Merging quilt/hexagon
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
Merging nfs/linux-next
Merging nfsd/nfsd-next
Merging nilfs2/for-next
Merging ocfs2/linux-next
Merging omfs/for-next
Merging squashfs/master
Merging udf/for_next
Merging v9fs/for-next
CONFLICT (content): Merge conflict in net/9p/trans_virtio.c
Merging ubifs/linux-next
Merging xfs/master
CONFLICT (content): Merge conflict in fs/xfs/xfs_aops.c
CONFLICT (content): Merge conflict in fs/xfs/xfs_super.c
Merging vfs/for-next
Merging vfs-scale/vfs-scale-working
Merging pci/linux-next
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
Merging iscsi-target/for-next
Merging slave-dma/next
Merging async_tx/next
Merging net/master
CONFLICT (content): Merge conflict in MAINTAINERS
CONFLICT (delete/modify): arch/powerpc/configs/40x/hcu4_defconfig deleted i=
n HEAD and modified in net/master. Version net/master of arch/powerpc/confi=
gs/40x/hcu4_defconfig left in tree.
CONFLICT (content): Merge conflict in drivers/s390/cio/qdio_main.c
$ git rm -f arch/powerpc/configs/40x/hcu4_defconfig
Merging wireless/master
CONFLICT (content): Merge conflict in drivers/net/wireless/iwlwifi/iwl-pci.c
CONFLICT (content): Merge conflict in drivers/net/wireless/iwlwifi/iwl-tran=
s-tx-pcie.c
CONFLICT (content): Merge conflict in drivers/net/wireless/rt2x00/rt2800usb=
.c
Merging bluetooth/master
Merging mtd/master
Merging l2-mtd/master
CONFLICT (delete/modify): arch/arm/mach-at91/board-usb-a9260.c deleted in H=
EAD and modified in l2-mtd/master. Version l2-mtd/master of arch/arm/mach-a=
t91/board-usb-a9260.c left in tree.
CONFLICT (content): Merge conflict in drivers/mtd/maps/lantiq-flash.c
$ git rm -f arch/arm/mach-at91/board-usb-a9260.c
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
Merging kgdb/kgdb-next
Merging slab/for-next
Merging uclinux/for-next
Merging md/for-next
Merging mfd/for-next
CONFLICT (content): Merge conflict in drivers/rtc/rtc-twl.c
Merging hdlc/hdlc-next
Merging drm/drm-next
Merging fbdev/fbdev-next
Merging viafb/viafb-next
Merging omap_dss2/for-next
Merging voltage/for-next
Merging security/next
CONFLICT (content): Merge conflict in fs/ocfs2/xattr.c
Merging selinux/master
Merging lblnet/master
Merging agp/agp-next
Merging watchdog/master
Merging bdev/master
Merging dwmw2-iommu/master
Merging iommu/next
Merging cputime/cputime
Merging osd/linux-next
Merging jc_docs/docs-next
Merging nommu/master
Merging trivial/for-next
Merging audit/for-next
Merging pm/linux-next
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/board-ap4evb.c
CONFLICT (content): Merge conflict in arch/s390/include/asm/thread_info.h
CONFLICT (content): Merge conflict in drivers/mfd/twl4030-irq.c
Merging apm/for-next
Merging fsnotify/for-next
Merging irda/for-next
Merging i7core_edac/linux_next
Merging i7300_edac/linux_next
CONFLICT (content): Merge conflict in arch/x86/kernel/cpu/mcheck/mce.c
Merging devicetree/devicetree/next
CONFLICT (content): Merge conflict in drivers/of/base.c
Merging spi/spi/next
Merging gpio/gpio/next
Merging tip/auto-latest
Merging rcu/rcu/next
Merging kvm/linux-next
Merging oprofile/for-next
Merging ptrace/ptrace
Merging xen/upstream/xen
$ git reset --hard HEAD^
Merging refs/next/20110914/xen
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
Merging regmap/for-next
Merging driver-core/driver-core-next
CONFLICT (content): Merge conflict in arch/arm/plat-mxc/devices.c
Merging tty/tty-next
Merging usb/usb-next
Merging staging/staging-next
CONFLICT (delete/modify): drivers/staging/rtl8192e/r8192E_core.c deleted in=
 staging/staging-next and modified in HEAD. Version HEAD of drivers/staging=
/rtl8192e/r8192E_core.c left in tree.
CONFLICT (content): Merge conflict in drivers/staging/xgifb/XGI_main_26.c
$ git rm -f drivers/staging/rtl8192e/r8192E_core.c
Merging bkl-config/config
Merging tmem/linux-next
Merging writeback/next
Merging arm-dt/devicetree/arm-next
Merging moduleh/module.h-split
CONFLICT (content): Merge conflict in arch/arm/mach-bcmring/mm.c
CONFLICT (content): Merge conflict in drivers/s390/char/vmur.c
CONFLICT (content): Merge conflict in drivers/scsi/libfc/fc_lport.c
CONFLICT (content): Merge conflict in include/linux/dmaengine.h
Applying: dm: use export.h instead of module.h where possible
Applying: block: bsg-lib.c needs export.h not module.h
Applying: PM: EXPORT_SYMBOL needs export.h
Merging kvmtool/master
CONFLICT (content): Merge conflict in include/net/9p/9p.h
Merging scsi-post-merge/merge-base:master
$ git checkout akpm
Applying: Because of x86-implement-strict-user-copy-checks-for-x86_64.patch
Applying: When no floppy is found the module code can be released while a t=
imer
Applying: Fix kconfig unmet dependency warning.  BACKLIGHT_CLASS_DEVICE dep=
ends on
Applying: The parameter's origin type is long.  On an i386 architecture, it=
 can
Applying: Since the commit below which added O_PATH support to the *at() ca=
lls, the
Applying: Add support for Aspire 1410 BIOS v1.3314.  Fixes the following er=
ror:
Applying: This makes the iris driver use the platform API, so it is properl=
y exposed
Applying: On x86_32 casting the unsigned int result of get_random_int() to =
long may
Applying: This new driver replaces the old PCEngines Alix 2/3 LED driver wi=
th a new
Applying: Cc: Ed Wildgoose <git@wildgooses.com>
Applying: Replace the bubble sort in sanitize_e820_map() with a call to the=
 generic
Applying: The x86 timer interrupt handler is the only handler not traced in=
 the
Applying: The current interrupt traces from irq_handler_entry and irq_handl=
er_exit
Applying: Don't allow everybody to use a modem.
Applying: The address limit is already set in flush_old_exec() so this
Applying: A call to va_copy() should always be followed by a call to va_end=
() in the
Applying: Don't dereference em if it's NULL or an error pointer.
Applying: Some messing with error codes to return 0 on out id's and match
Applying: kbuf is a buffer that is local to this function, so all of the er=
ror paths
Applying: fb_set_suspend() must be called with the console semaphore held, =
which
Applying: hwmon was using an idr with a NULL pointer, so convert to an
Applying: A straightforward looking use of idr for a device id.
Applying: The address limit is already set in flush_old_exec() so this
Applying: The address limit is already set in flush_old_exec() so this
Applying: Add new check (assert_init) to make sure objects are initialized =
and
Applying: del_timer_sync() calls debug_object_assert_init() to assert that =
a timer
Applying: ext4_{set,clear}_bit() is defined as __test_and_{set,clear}_bit_l=
e() for
Applying: The dqc_bitmap field of struct ocfs2_local_disk_chunk is 32-bit a=
ligned,
Applying: The address limit is already set in flush_old_exec() so those cal=
ls to
Applying: When do pci remove/rescan on system that have more iommus, got
Applying: The current implementation of dmi_name_in_vendors() is an invitat=
ion to
Applying: For headers that get exported to userland and make use of u32 sty=
le
Applying: Fix sparse warnings of right shift bigger than source value size:
Applying: We leak in drivers/scsi/aacraid/commctrl.c::aac_send_raw_srb() :
Applying: Some mangling of errors was necessary to maintain current interfa=
ce.
Applying: This does involve additional use of the spin lock in idr.c.  Is t=
his an
Applying: Instead of open coding this function use kstrtoul_from_user() dir=
ectly.
Applying: brd_make_request() always returns 0, which doesn't make much sens=
e.
Applying: The address limit is already set in flush_old_exec() so this assi=
gnment of
Applying: Unbreak the alpha build.
Applying: Unbreak alpha build.
Applying: Unbreak alpha build.
Applying: When we get corruption reports, it's useful to see if the kernel =
was
Applying: When we get corruption reports, it's useful to see if the kernel =
was
Applying: The basic idea behind cross memory attach is to allow MPI program=
s doing
Applying: - Add x86_64 specific wire up
Applying: > You might get some speed benefit by optimising for the small co=
pies
Applying: acct_isolated of compaction uses page_lru_base_type which returns=
 only
Applying: Change ISOLATE_XXX macro with bitwise isolate_mode_t type.  Norma=
lly,
Applying: In async mode, compaction doesn't migrate dirty or writeback page=
s.  So,
Applying: In __zone_reclaim case, we don't want to shrink mapped page.  Non=
etheless,
Applying: unmap_and_move() is one a big messy function.  Clean it up.
Applying: radix_tree_tag_get()'s BUG (when it sees a tag after saw_unset_ta=
g) was
Applying: per-task block plug can reduce block queue lock contention and in=
crease
Applying: The tracing ring-buffer used this function briefly, but not anymo=
re.
Applying: After selecting a task to kill, the oom killer iterates all proce=
sses and
Applying: Add the leading word "tmpfs" to the Kconfig string to make it bli=
ndingly
Applying: When we get a bad_page bug report, it's useful to see what module=
s the
Applying: Without swap, anonymous pages are not scanned.  As such, they sho=
uld not
Applying: fix comment
Applying: The nr_force_scan[] tuple holds the effective scan numbers for an=
on and
Applying: Some kernel components pin user space memory (infiniband and perf=
) (by
Applying: Add comments to explain the page statistics field in the mm_struc=
t.
Applying: add missing ;
Applying: Testing from the XFS folk revealed that there is still too much I=
/O from
Applying: Lumpy reclaim worked with two passes - the first which queued pag=
es for IO
Applying: Direct reclaim should never writeback pages.  For now, handle the
Applying: Direct reclaim should never writeback pages.  Warn if an attempt =
is made.
Applying: It is preferable that no dirty pages are dispatched for cleaning =
from the
Applying: Workloads that are allocating frequently and writing files place =
a large
Applying: When direct reclaim encounters a dirty page, it gets recycled aro=
und the
Applying: It's possible a zone watermark is ok when entering the balance_pg=
dat()
Applying: printk_ratelimit() should not be used, because it shares ratelimi=
ting
Applying: memchr_inv() is mainly used to check whether the whole buffer is =
filled
Applying: Use newly introduced memchr_inv() for page verification.
Applying: A shrinker function can return -1, means that it cannot do anythi=
ng
Applying: Use atomic-long operations instead of looping around cmpxchg().
Applying: massage atomic.h inclusions
Applying: The /proc/vmallocinfo shows information about vmalloc allocations=
 in
Applying: Commit 645747462435 ("vmscan: detect mapped file pages used only =
once")
Applying: Logic added in commit 8cab4754d24a0 ("vmscan: make mapped executa=
ble pages
Applying: SPARC32 require access to the start address.  Add a new helper
Applying: With the NO_BOOTMEM symbol added architectures may now use the fo=
llowing
Applying: Using "- 1" relies on the old_end to be page aligned and PAGE_SIZ=
E > 1,
Applying: This replaces ptep_clear_flush() with ptep_get_and_clear() and a =
single
Applying: This adds THP support to mremap (decreases the number of split_hu=
ge_page()
Applying: coding-style nitpicking
Applying: Cc: Andrea Arcangeli <aarcange@redhat.com>
Applying: Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Applying: vmstat_text is only available when PROC_FS or SYSFS is enabled.  =
This
Applying: reduce ifdeffery
Applying: Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Applying: Make the security_inode_init_security() initxattrs arg const, to =
match the
Applying: The current implementation of the /dev/hpet driver couples openin=
g the
Applying: smp_call_function() only lets all other CPUs execute a specific f=
unction,
Applying: auto_demotion_disable is called only for online CPUs.  For hotplu=
gged
Applying: Enabling DEBUG_STRICT_USER_COPY_CHECKS causes the following warni=
ng:
Applying: Strict user copy checks are only really supported on x86_32 even =
though
Applying: The help text for this config is duplicated across the x86, paris=
c, and
Applying: s/lib-/obj-/ for usercopy.o
Applying: After an "unexpected" reboot, I found this Oops in my logs:
Applying: In the move of the lis3 driver, the hp_accel.c file got dropped f=
rom the
Applying: Add axis correction for HP EliteBook 2730p.
Applying: Add axis correction for HP EliteBook 8540w.
Applying: Add axis correction for HP ProBook 6555b.
Applying: Adapt the help text for CONFIG_HP_ACCEL to the move of
Applying: Signed-off-by: Ilkka Koskinen <ilkka.koskinen@nokia.com>
Applying: Signed-off-by: Ilkka Koskinen <ilkka.koskinen@nokia.com>
Applying: Change exported functions to use the device given as parameter
Applying: Signed-off-by: Ilkka Koskinen <ilkka.koskinen@nokia.com>
Applying: We are enabling some power features on medfield.  To test suspend=
-2-RAM
Applying: We are enabling some power features on medfield.  To test suspend=
-2-RAM
Applying: We are enabling some power features on medfield.  To test suspend=
-2-RAM
Applying: Cc: Al Viro <viro@zeniv.linux.org.uk>
Applying: Add V2 of the LED driver for a single timer channel for the TPU h=
ardware
Applying: include linux/module.h
Applying: The memory for struct led_trigger should be kfreed in the
Applying: Currently termination logic (\0 or \n\0) is hardcoded in _kstrtou=
ll(),
Applying: Add support for slice by 8 to existing crc32 algorithm.  Also mod=
ify
Applying: don't include asm/msr.h
Applying: epoll can acquire recursively acquire ep->mtx on multiple "struct
Applying: Currently in oprofilefs, files that use ulong_fops mis-handle wri=
tes of
Applying: This is the one use of an ida that doesn't retry on receiving -EA=
GAIN.
Applying: One can get this information from minix/inode.c, but adding the
Applying: The memcg code sometimes uses "struct mem_cgroup *mem" and someti=
mes uses
Applying: Before calling schedule_timeout(), task state should be changed.
Applying: Signed-off-by: Bob Liu <lliubbo@gmail.com>
Applying: While back-porting Johannes Weiner's patch "mm: memcg-aware global
Applying: If somebody is touching data too early, it might be easier to dia=
gnose a
Applying: Both mem_cgroup_charge_statistics() and mem_cgroup_move_account()=
 were
Applying: On reading sysctl dirs we should return -EISDIR instead of -EINVA=
L.
Applying: Force this on for -next/mm testing purposes.
Applying: Expand root=3DPARTUUID=3DUUID syntax to support selecting a root =
partition by
Applying: After merging the akpm tree, today's linux-next build (lost of th=
em)
Applying: The discovered bit in PGCCSR register indicates if the device has=
 been
Applying: Add RapidIO mport driver for IDT TSI721 PCI Express-to-SRIO bridg=
e device.
Applying: When I tried to send a patch to remove it, Andi told me we still =
need to
Applying: A default echo function has been provided so it is no longer an e=
rror when
Applying: This client driver allows you to use a GPIO pin as a source for P=
PS
Applying: remove unneeded cast of void*
Applying: Straightforward.  As an aside, the ida_init calls are not needed =
as far as
Applying: Simply creates one point to call the w1 interface.
Applying: Adds a nolock function to the w1 interface to avoid locking the
Applying: Fixes the deadlock when inserting and removing the ds2780.
Merging akpm
Applying: encrypted-keys: IS_ERR need include/err.h

--Signature=_Thu__15_Sep_2011_17_15_00_+1000_9YwyeW4maOch+rta
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOcaX0AAoJEDMEi1NhKgbsQtcH/3C9bhqA6WIrKne5xJQN+nMa
RCpzqdjA4YzMKdRzd7P0I9G8EHaiqP82PyTTHwN07ECGyl9nB4BskBy4bQNj43Ho
CKijd6xzxgy8tmjuG+6+0le6VlWBswKds+5+5Hup/nwloD7NgDDSlg0fawds9utM
Mnfk1arbUC361TjWhIqGBf2FEx61VhE56r5TBl19LU9as2hOwA/sS6PslSMo5RJC
s/2LaUurnqTYzWXYSDk+QSW2RdqP+MMTeeLjZcAE0X3LSL6ydRyGKldLdSb0/Qb4
+RpMpLQIzLODq0S1eVxcbrRtGNPY94J/2PE7f8iIhD/Zz3zdHuFFyij9klFfxxc=
=wRXY
-----END PGP SIGNATURE-----

--Signature=_Thu__15_Sep_2011_17_15_00_+1000_9YwyeW4maOch+rta--

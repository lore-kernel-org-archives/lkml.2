Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619Ab1HXGET (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 02:04:19 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:47969 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750788Ab1HXGER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 02:04:17 -0400
Date: Wed, 24 Aug 2011 16:04:04 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Aug 24
Message-Id: <20110824160404.ebad6370aee2cad82a990142@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta2 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__24_Aug_2011_16_04_04_+1000_1aj1ccJm/Y3K7f8+"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__24_Aug_2011_16_04_04_+1000_1aj1ccJm/Y3K7f8+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

The powerpc allyesconfig build still fails today.

Changes since 20110823:

New tree: kvmtool

The security tree lost its build failure.

The ptrace tree gained a build failure (yeaterday) for which I have
reveretd a commit.

The tty tree gained a build failure so I used the version from
next-20110823.

The staging tree gained a conflict against the fbdev tree and a build
failure for which I reverted a commit.

The moduleh tree gained a conflict against the staging tree.

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

We are up to 199 trees (counting Linus' and 28 trees of patches pending
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
Merging arm-soc/for-next
Merging at91/at91-next
Merging davinci/davinci-next
Merging i.MX/for-next
Merging linux-spec/for-next
Merging msm/for-next
CONFLICT (content): Merge conflict in arch/arm/mach-msm/io.c
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
Merging ubifs/linux-next
Merging xfs/master
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
CONFLICT (delete/modify): arch/powerpc/configs/40x/hcu4_defconfig deleted i=
n HEAD and modified in net/master. Version net/master of arch/powerpc/confi=
gs/40x/hcu4_defconfig left in tree.
CONFLICT (content): Merge conflict in drivers/net/Kconfig
CONFLICT (content): Merge conflict in drivers/net/Makefile
$ git rm -f arch/powerpc/configs/40x/hcu4_defconfig
Applying: powerpc: update ppc64_defconfig for net device movement
Applying: sparc: update sparc32_defconfig for net device movement
Applying: sparc: update sparc64_defconfig for net device movement
Merging wireless/master
Merging bluetooth/master
Merging mtd/master
Merging l2-mtd/master
CONFLICT (content): Merge conflict in drivers/mtd/maps/lantiq-flash.c
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
Merging hdlc/hdlc-next
Merging drm/drm-next
Merging fbdev/master
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
Merging cputime/cputime
Merging osd/linux-next
Merging jc_docs/docs-next
Merging nommu/master
Merging trivial/for-next
Merging audit/for-next
Merging pm/linux-next
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
CONFLICT (content): Merge conflict in arch/x86/mm/fault.c
Merging rcu/rcu/next
Merging kvm/linux-next
Merging oprofile/for-next
Merging ptrace/ptrace
[master 12688b4] Revert "signal: Add block_sigmask() for adding sigmask to =
current->blocked"
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
Merging regmap/for-next
Merging driver-core/driver-core-next
Merging tty/tty-next
$ git reset --hard HEAD^
Merging refs/next/20110823/tty
Merging usb/usb-next
Applying: usb: include module.h in the DesignWare USB3 DRD driver
Merging staging/staging-next
CONFLICT (content): Merge conflict in drivers/staging/xgifb/XGI_main_26.c
Merging bkl-config/config
Merging tmem/linux-next
Merging writeback/next
Merging arm-dt/devicetree/arm-next
Merging moduleh/module.h-split
CONFLICT (content): Merge conflict in drivers/staging/iio/accel/adis16220_c=
ore.c
CONFLICT (content): Merge conflict in include/linux/dmaengine.h
Applying: dm: use export.h instead of module.h where possible
Applying: block: bsg-lib.c needs export.h not module.h
Applying: PM: EXPORT_SYMBOL needs export.h
Merging kvmtool/master
CONFLICT (content): Merge conflict in include/net/9p/9p.h
Merging scsi-post-merge/merge-base:master
$ git checkout akpm
Applying: Expand root=3DPARTUUID=3DUUID syntax to support selecting a root =
partition by
Applying: This patch makes two changes:
Applying: On thread exit shm_exit_ns() is called, it uses shm_ids(ns).rw_mu=
tex.  It
Applying: Because of x86-implement-strict-user-copy-checks-for-x86_64.patch
Applying: When no floppy is found the module code can be released while a t=
imer
Applying: The parameter's origin type is long.  On an i386 architecture, it=
 can
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
Applying: The basic idea behind cross memory attach is to allow MPI program=
s doing
Applying: - Add x86_64 specific wire up
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
Applying: Remove PageSwapBacked (!page_is_file_cache) cases from
Applying: Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
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
Applying: Add V2 of the LED driver for a single timer channel for the TPU h=
ardware
Applying: Add support for slice by 8 to existing crc32 algorithm.  Also mod=
ify
Applying: don't include asm/msr.h
Applying: This is the one use of an ida that doesn't retry on receiving -EA=
GAIN.
Applying: One can get this information from minix/inode.c, but adding the
Applying: Signed-off-by: Igor Mammedov <imammedo@redhat.com>
Applying: Force this on for -next/mm testing purposes.
Applying: Add a proc_dointvec_bool() sysctl handler for cases where the inp=
ut value
Applying: Use the new proc_do_intvec_bool() handler for various boolean inp=
uts.
Applying: Add a proc_dointvec_unsigned() sysctl handler for positive value =
cases.
Applying: Cc: Alexey Dobriyan <adobriyan@gmail.com>
Applying: Use the new proc_do_intvec_unsigned() handler for various unsigne=
d inputs.
Applying: A default echo function has been provided so it is no longer an e=
rror when
Applying: This client driver allows you to use a GPIO pin as a source for P=
PS
Applying: remove unneeded cast of void*
Applying: Straightforward.  As an aside, the ida_init calls are not needed =
as far as
Merging akpm
Applying: do_mounts: remove __init_data from root_wait
[master 9cba48a] Revert "Staging: add driver for Realtek RTS5139 cardreader"

--Signature=_Wed__24_Aug_2011_16_04_04_+1000_1aj1ccJm/Y3K7f8+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOVJRUAAoJEDMEi1NhKgbsuYEIAJbufd33G8ZS2ENBIIVbSl5w
B+XCpe9QK1YD8Vldk2h3MmfXm6DceCOo6mVfSzh0YBrwDyOy2BYWbMTY3Hmskhe+
s2j13vpKzfaZRr6r5ITuAgoss5AOl14/45QgAwU+8BrOrAf9T9ZptMKM35xumhIF
TQ+5YfOxVpg9mVqzgKb9Q40ESN5pnjyy3o4YwTnNOpUrScPVWRlzDyuEUkNexSE/
gmadI89mvJWVXI7mjtaWaKrxrKZE+4jG/ik0ox6E1zNytKxk/mvXd1clZEb/Pqtn
TTMLVALhDotG2YKtbbaH3TOQr2jCrpzEI/qPK5NyOKhEM/cubzy49+CJv3jRWbA=
=Qa9/
-----END PGP SIGNATURE-----

--Signature=_Wed__24_Aug_2011_16_04_04_+1000_1aj1ccJm/Y3K7f8+--

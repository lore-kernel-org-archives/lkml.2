Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513Ab1HAErs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 00:47:48 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:52370 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752291Ab1HAErk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 00:47:40 -0400
Date: Mon, 1 Aug 2011 14:47:32 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Aug 1
Message-Id: <20110801144732.7f5204b219f628f2a2a63b0c@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__1_Aug_2011_14_47_32_+1000_guudN=kIdcR3yonP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__1_Aug_2011_14_47_32_+1000_guudN=kIdcR3yonP
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Just in case anyone needs reminding:  Please do not add anything destined
for v3.2 into linux-next included trees until after v3.1-rc1.

The powerpc allyesconfig build (at least) fails today.

Changes since 20110729:

Linus' tree still lost its build failure.

The v4l-dvb tree lost its conflicts.

The kgdb tree gained a build failure for which I reverted 3 commits.

The moduleh tree gained a conflict against the slabe-dma tree but lost
its build failures (except for a few remaining merge fixups).

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

We are up to 200 trees (counting Linus' and 28 trees of patches pending
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
CONFLICT (content): Merge conflict in arch/arm/mach-exynos4/pm.c
CONFLICT (content): Merge conflict in arch/arm/mach-imx/mm-imx25.c
CONFLICT (content): Merge conflict in arch/arm/mach-imx/mm-imx31.c
CONFLICT (content): Merge conflict in arch/arm/mach-imx/mm-imx35.c
CONFLICT (content): Merge conflict in arch/arm/mach-mx5/mm.c
CONFLICT (content): Merge conflict in arch/arm/mach-omap2/cm-regbits-44xx.h
Merging at91/at91-next
Merging davinci/davinci-next
Merging i.MX/for-next
Merging linux-spec/for-next
Merging msm/for-next
Merging omap/for-next
Merging pxa/for-next
Merging samsung/next-samsung
Merging s5p/for-next
CONFLICT (content): Merge conflict in arch/arm/mach-exynos4/Kconfig
CONFLICT (content): Merge conflict in arch/arm/mach-exynos4/mach-smdkc210.c
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
CONFLICT (content): Merge conflict in fs/ceph/export.c
Merging cifs/master
Merging configfs/linux-next
Merging ecryptfs/next
Merging ext3/for_next
Merging ext4/dev
CONFLICT (content): Merge conflict in fs/ext4/inode.c
Applying: vfs/ext4: merge fixup for moved function
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
CONFLICT (content): Merge conflict in arch/ia64/Kconfig
CONFLICT (content): Merge conflict in arch/powerpc/Kconfig
CONFLICT (content): Merge conflict in arch/x86/Kconfig
CONFLICT (content): Merge conflict in lib/Kconfig
CONFLICT (content): Merge conflict in lib/Makefile
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
CONFLICT (content): Merge conflict in drivers/dma/mv_xor.c
Merging async_tx/next
Merging net/master
Merging wireless/master
Merging bluetooth/master
Merging mtd/master
Merging l2-mtd/master
CONFLICT (content): Merge conflict in drivers/mtd/maps/lantiq-flash.c
CONFLICT (content): Merge conflict in drivers/mtd/maps/pxa2xx-flash.c
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
CONFLICT (content): Merge conflict in Documentation/feature-removal-schedul=
e.txt
Merging hwpoison/hwpoison
Merging sysctl/master
Merging namespace/master
Merging regmap/for-next
Merging driver-core/driver-core-next
Merging tty/tty-next
Merging usb/usb-next
Merging staging/staging-next
Merging bkl-config/config
Merging tmem/linux-next
Merging writeback/next
Merging arm-dt/devicetree/arm-next
Merging scsi-post-merge/merge-base:master
Merging moduleh/module.h-split
CONFLICT (content): Merge conflict in drivers/dma/ste_dma40.c
Applying: include export.h to use EXPORT_SYMBOL
Applying: block: bsg-lib.c needs export.h
$ git checkout akpm
Applying: kernel/fork.c:267: error: implicit declaration of function
Applying: WARNING: line over 80 characters
Applying: arch/cris/arch-v10/drivers/sync_serial.c:628: error: 'ret' undecl=
ared (first use in this function)
Applying: arch/cris/arch-v10/drivers/sync_serial.c:961: error: conflicting =
types for 'sync_serial_ioctl'
Applying: arch/cris/arch-v10/kernel/irq.c:239: error: implicit declaration =
of function 'kgdb_init'
Applying: My load tests on PowerPC freeze within minutes in __slab_free(). =
 I
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
Applying: On x86_32 casting the unsigned int result of get_random_int() to =
long may
Applying: This new driver replaces the old PCEngines Alix 2/3 LED driver wi=
th a new
Applying: Replace the bubble sort in sanitize_e820_map() with a call to the=
 generic
Applying: Don't allow everybody to use a modem.
Applying: The address limit is already set in flush_old_exec() so this
Applying: A call to va_copy() should always be followed by a call to va_end=
() in the
Applying: Don't dereference em if it's NULL or an error pointer.
Applying: The buffer 'sc.cpu_mask' is a kernel buffer.  If bitmap_parse is =
used
Applying: fb_set_suspend() must be called with the console semaphore held, =
which
Applying: Unless I'm very much missing something these tests are intended t=
o check
Applying: The address limit is already set in flush_old_exec() so this
Applying: The address limit is already set in flush_old_exec() so this
Applying: Mike McLagan hasn't contributed in many years and his email bounc=
es.
Applying: proc_fork_connector() uses ->real_parent lockless.  This is not s=
afe if
Applying: backlight_device_register() returns ERR_PTR() on error.
Applying: 1. current implementation tests wrong value for setting aat2870_b=
l->max_current.
Applying: i386 allmodconfig:
Applying: ext4_{set,clear}_bit() is defined as __test_and_{set,clear}_bit_l=
e() for
Applying: The dqc_bitmap field of struct ocfs2_local_disk_chunk is 32-bit a=
ligned,
Applying: The address limit is already set in flush_old_exec() so those cal=
ls to
Applying: When do pci remove/rescan on system that have more iommus, got
Applying: The current implementation of dmi_name_in_vendors() is an invitat=
ion to
Applying: fix comment layout
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
Applying: The report has an ISO which has a very long manufacturer ID.  It =
seems
Applying: The address limit is already set in flush_old_exec() so this assi=
gnment of
Applying: x86_64 allmodconfig:
Applying: alpha allmodconfig:
Applying: alpha allmodconfig:
Applying: alpha allmodconfig:
Applying: Cc: Greg KH <greg@kroah.com>
Applying: Use the nice enumerated constant.
Applying: A patchset to extend tmpfs to MAX_LFS_FILESIZE by abandoning its =
peculiar
Applying: If swap entries are to be stored along with struct page pointers =
in a
Applying: The maximum size of a shmem/tmpfs file has been limited by the ma=
ximum
Applying: While it's at its least, make a number of boring nitpicky cleanup=
s to
Applying: Bring truncate.c's code for truncate_inode_pages_range() inline i=
nto
Applying: Disable the toy swapping implementation in shmem_writepage() - it=
's hard
Applying: Convert shmem_unuse_inode() to use a lockless gang lookup of the =
radix
Applying: Convert shmem_getpage_gfp(), the engine-room of shmem, to expect =
page or
Applying: Remove mem_cgroup_shmem_charge_fallback(): it was only required w=
hen we
Applying: Convert shmem_writepage() to use shmem_delete_from_page_cache() t=
o use
Applying: But we've not yet removed the old swp_entry_t i_direct[16] from
Applying: Remove PageSwapBacked (!page_is_file_cache) cases from
Applying: Fix NULL dereference I introduced in mincore_page().
Applying: Expand the fs/Kconfig "help" info to clarify why it's a bad idea =
to
Applying: Expand the fs/Kconfig "help" info to clarify why you might need t=
o select
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
Applying: Signed-off-by: Igor Mammedov <imammedo@redhat.com>
Applying: Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Applying: No need to declare show_regs() in ptrace.h, sched.h does this.
Applying: Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Applying: Expand root=3DPARTUUID=3DUUID syntax to support selecting a root =
partition by
Applying: Update kernel-parameters.txt to point users to the authoritative =
comment
Applying: While ramoops writes to ram, accessing the dump requires using /d=
ev/mem
Merging akpm
Applying: power_supply: max8997_charger.c need to include module.h
[master a87004f] Revert "kdb,kgdb: Allow arbitrary kgdb magic knock sequenc=
es"
[master bdd1281] Revert "kdb: Remove all references to DOING_KGDB2"
[master 92450785] Revert "kdb,kgdb: Implement switch and pass buffer from k=
db -> gdb"

--Signature=_Mon__1_Aug_2011_14_47_32_+1000_guudN=kIdcR3yonP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJONi/kAAoJEDMEi1NhKgbsRaYH/22uLJjEjSN9VVwR+wIe742D
5vKKfR+DGeJlnYcyvOvUktEYHFPjtVJPMegUI9SGfFoIKAj6pG8ahUvvcRMsBqmq
353lZjUBzh9Y6oWtQSd7RSv4Op59Ff5RZPNRHYa8xRITORiPVNqOU/hmpjfxqTuP
/JZ1BCPXN9ClnRjHHjzvAsnRaQMLObrm6cvyaoMZwAkCyxbkw4CoYItoAxjkYYtA
nTMEKORaFk2PpkU4IKeRJd1nC9Kz0Ar63VH3oWY00NxPBcWwi6ZRIWfisR/KXHIh
qcrznctdf3uZJIhGeyYleIAQSUgrAy8tgeImMyjUgKEKKIoU4kkAuC42Kr2PpoM=
=gkxq
-----END PGP SIGNATURE-----

--Signature=_Mon__1_Aug_2011_14_47_32_+1000_guudN=kIdcR3yonP--

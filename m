Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258Ab1G0EMG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 00:12:06 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:42217 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754225Ab1G0EMA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 00:12:00 -0400
Date: Wed, 27 Jul 2011 14:11:51 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for July 27
Message-Id: <20110727141151.d31e3da6a8d21a255473293c@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__27_Jul_2011_14_11_51_+1000_J8F=HzOiNf6G.332"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__27_Jul_2011_14_11_51_+1000_J8F=HzOiNf6G.332
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Just in case anyone needs reminding:  Please do not add anything destined
for v3.2 into linux-next included trees until after v3.1-rc1.

The powerpc allyesconfig build (at least) still fails today.

Changes since 20110726:

Linus' tree lost its build failure but gained another from the staging
tree which I have still left.

The arm-soc tree lost its conflicts.

The microblaze tree lost its conflict.

The powerpc tree lost its conflicts.

The ext3 tree lost its conflict.

The nfsd tree lost its conflict.

The slave-dma tree gained a conflict agains Linus' tree.

The rr tree lost its conflicts.

The usb tree lost its conflict.

The staging tree lost its conflicts and build failures (one is still
present in Linus' tree).

The writeback tree lost its conflicts.

The akpm tree gained a build failure for which I applied a patch.

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
CONFLICT (content): Merge conflict in arch/xtensa/configs/iss_defconfig
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
CONFLICT (content): Merge conflict in Documentation/feature-removal-schedul=
e.txt
CONFLICT (content): Merge conflict in drivers/staging/tm6000/tm6000-alsa.c
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
CONFLICT (content): Merge conflict in drivers/spi/spi-pl022.c
Merging async_tx/next
Merging net/master
Merging wireless/master
Merging bluetooth/master
Merging mtd/master
Merging l2-mtd/master
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
$ git checkout akpm
Applying: kernel/fork.c:267: error: implicit declaration of function
Applying: WARNING: line over 80 characters
Applying: arch/cris/arch-v10/drivers/sync_serial.c:628: error: 'ret' undecl=
ared (first use in this function)
Applying: arch/cris/arch-v10/drivers/sync_serial.c:961: error: conflicting =
types for 'sync_serial_ioctl'
Applying: arch/cris/arch-v10/kernel/irq.c:239: error: implicit declaration =
of function 'kgdb_init'
Applying: There's a code path in pmcraid that can be reached via device ioc=
tl that
Applying: The out_msi_disable label should be before cleanup_nomem to addit=
ionally
Applying: Most smartarrays tolerate it, but a few new ones don't.
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
Applying: In response to new device tree code in the kernel, OLPC will star=
t using
Applying: Move these definitions into the relevant header file.  This was r=
equested
CONFLICT (delete/modify): arch/x86/platform/olpc/olpc-xo1.c deleted in HEAD=
 and modified in Move these definitions into the relevant header file.  Thi=
s was requested. Version Move these definitions into the relevant header fi=
le.  This was requested of arch/x86/platform/olpc/olpc-xo1.c left in tree.
CONFLICT (content): Merge conflict in include/linux/cs5535.h
Applying: Based on earlier review comments, we'll no longer try to stick al=
l of our
CONFLICT (rename/delete): Rename arch/x86/platform/olpc/olpc-xo1.c->arch/x8=
6/platform/olpc/olpc-xo1-pm.c in Based on earlier review comments, we'll no=
 longer try to stick all of our and deleted in HEAD
CONFLICT (content): Merge conflict in arch/x86/Kconfig
CONFLICT (content): Merge conflict in arch/x86/platform/olpc/Makefile
Applying: Add code needed for basic suspend/resume of the XO-1 laptop.  Bas=
ed on
CONFLICT (content): Merge conflict in arch/x86/Kconfig
CONFLICT (content): Merge conflict in arch/x86/include/asm/olpc.h
CONFLICT (content): Merge conflict in arch/x86/platform/olpc/Makefile
Applying: The System Control Interrupt is used in the OLPC XO-1 to control =
various
CONFLICT (content): Merge conflict in arch/x86/platform/olpc/Makefile
CONFLICT (add/add): Merge conflict in arch/x86/platform/olpc/olpc-xo1-sci.c
CONFLICT (content): Merge conflict in include/linux/cs5535.h
Applying: Update the EC SCI masks with recent additions.
CONFLICT (content): Merge conflict in arch/x86/platform/olpc/olpc.c
Applying: The EC in the OLPC XO-1 delivers GPE events to provide various
CONFLICT (content): Merge conflict in arch/x86/Kconfig
CONFLICT (content): Merge conflict in arch/x86/platform/olpc/olpc-xo1-sci.c
Applying: Configure the XO-1's lid switch GPIO to trigger an SCI interrupt,=
 and
CONFLICT (content): Merge conflict in arch/x86/Kconfig
CONFLICT (content): Merge conflict in arch/x86/platform/olpc/olpc-xo1-sci.c
Applying: EC events indicate change in AC power connectivity, battery state=
 of
CONFLICT (content): Merge conflict in arch/x86/Kconfig
Applying: Add a driver to configure the XO-1 RTC via CS5536 MSRs, to be use=
d as a
CONFLICT (add/add): Merge conflict in arch/x86/platform/olpc/olpc-xo1-rtc.c
Applying: Add a driver for the ACPI-based EC event interface found on the O=
LPC
CONFLICT (content): Merge conflict in arch/x86/Kconfig
CONFLICT (add/add): Merge conflict in arch/x86/platform/olpc/olpc-xo15-sci.c
Applying: Don't allow everybody to use a modem.
Applying: The address limit is already set in flush_old_exec() so this
Applying: A call to va_copy() should always be followed by a call to va_end=
() in the
Applying: Don't dereference em if it's NULL or an error pointer.
Applying: The buffer 'sc.cpu_mask' is a kernel buffer.  If bitmap_parse is =
used
Applying: The camera there identifies itself as being manufactured by Cheng=
 Uei
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
Applying: Dev_opp initial value shoule be ERR_PTR(), IS_ERR() is used to ch=
eck
Applying: The address limit is already set in flush_old_exec() so this
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
Applying: The code checks the correctness of the parameters, but unconditio=
nally
Applying: Due to the hrtimer self rearming mode a user can DoS the machine =
simply
Applying: Ben reported a lockup related to rtc. The lockup happens due to:
Applying: Each memory cgroup has a 'swappiness' value which can be accessed=
 by
Applying: In mm/memcontrol.c, there are many lru stat functions as..
Applying: mm/vmscan.c: In function 'zone_nr_lru_pages':
Applying: Signed-off-by: Igor Mammedov <imammedo@redhat.com>
Applying: 867578cb ("memcg: fix oom kill behavior") introduced oom_lock cou=
nter
Applying: memcg_oom_mutex is used to protect memcg OOM path and eventfd int=
erface
Applying: 246e87a ("memcg: fix get_scan_count() for small targets") fixes t=
he
Applying: 22a668d7 ("memcg: fix behavior under memory.limit equals to memsw=
.limit")
Applying: The commit log of 0ae5e89 ("memcg: count the soft_limit reclaim i=
n...")
Applying: drain_all_stock_async tries to optimize a work to be done on the =
work
Applying: Currently we have two ways how to drain per-CPU caches for charge=
s.
Applying: We are checking whether a given two groups are same or at least i=
n the
Applying: percpu_charge_mutex protects from multiple simultaneous per-cpu c=
harge
Applying: [This patch has already been accepted as 0ac0c0d but later revert=
ed
Applying: fix CONFIG_NUMA=3Dy, MAX_NUMNODES>1 build
Applying: Kosaki Motohiro raised a concern that copy_process is hot path an=
d we do
Applying: make David happy
Applying: Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Applying: No need to declare show_regs() in ptrace.h, sched.h does this.
Applying: sys_ssetmask(), sys_rt_sigsuspend() and compat_sys_rt_sigsuspend()
Applying: If we don't know the file corresponding to the binary (i.e.  exe_=
file is
Applying: Change every occurence of / in comm and hostname to !.  If the pr=
ocess
Applying: do_coredump() assumes that if format_corename() fails it should r=
eturn
Applying: Signed-off-by: Daniel Rebelo de Oliveira <psykon@gmail.com>
Applying: a8bef8ff ("mm: migration: avoid race between shift_arg_pages() and
Applying: Currently, search_binary_handler() tries to load binary loader mo=
dule
Applying: If CONFIG_MODULES=3Dn, it makes no sense to retry the list of bin=
ary formats
Applying: acct_arg_size() takes ->page_table_lock around add_mm_counter() if
Applying: If new_inode fails to allocate an inode we need only to return wi=
th NULL.
Applying: We return ENOMEM from mqueue_get_inode even when we have enough m=
emory.
Applying: Add support for the shm_rmid_forced sysctl.  If set to 1, all
Applying: fix documentation, per Randy
Applying: include/linux/shm.h: In function 'exit_shm':
Applying: readability/conventionality tweaks
Applying: shm_may_destroy() and ipc_namespace.shm_forced_rmid lack comments.
Applying: - fix shm_rmid_forced/shm_forced_rmid confusion
Applying: Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Applying: Expand root=3DPARTUUID=3DUUID syntax to support selecting a root =
partition by
Applying: Update kernel-parameters.txt to point users to the authoritative =
comment
Applying: Parameter offset_in_page in edac_mc_handle_ce() should mask the h=
igher
Applying: When kernel BUG or oops occurs, ChromeOS intends to panic and imm=
ediately
Applying: Don't force output if you intend to reboot immediately.
Applying: With the arrival of concurrency-managed workqueues there is no ne=
ed for
Applying: fix comment layout & grammar
Applying: Use generic module parameters instead of platform data, if platfo=
rm data
Applying: ERROR: Invalid UTF-8, patch and commit message should be encoded =
in UTF-8
Applying: Add new line to each print.
Applying: The platform driver currently allows setting the mem_size and mem=
_address.
Applying: The size of the dump is currently set using the RECORD_SIZE macro=
 which is
Applying: While ramoops writes to ram, accessing the dump requires using /d=
ev/mem
Applying: No need to include linux/kallsyms.h.
Applying: should_fail_srandom() does not exist.
Applying: Minor cosmetic changes for simple attribute of stacktrace_depth:
Applying: Use debugfs_remove_recursive() to simplify initialization and
Applying: Now cleanup_fault_attr_dentries() recursively removes a directory=
, So we
Applying: Now cleanup_fault_attr_dentries() recursively removes a directory=
, So we
Applying: This changes should_fail_request() to more usable wrapper functio=
n of
Applying: The majority of architectures implement ext2 atomic bitops as
Applying: This allows us to move duplicated code in <asm/atomic.h>
Applying: This is in preparation for more generic atomic
Applying: After changing all consumers of atomics to include
Applying: This clarifies the differences between <linux/atomic.h> and
Applying: We already declared inc/dec helpers, so we don't need to call the
Applying: The atomic helpers are supposed to take an atomic_t pointer, not =
a random
Applying: Since arches are expected to implement this guy, add a common ver=
sion for
Applying: Only a few core funcs need to be implemented for SMP systems, so =
allow the
Merging akpm
Applying: sparc: rename atomic_add_unless

--Signature=_Wed__27_Jul_2011_14_11_51_+1000_J8F=HzOiNf6G.332
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOL5AHAAoJEDMEi1NhKgbsaoQIAISHml2/HepMD9hpqxrzo0En
bc2XROCtWEVT4ERV12Z2BMCA6k8uuK+YXbTemu5hjkQTEwipY5wQWM7k9D4qA3eI
2rIq2e1qgeo6JxXrwIoZyFD1fS3LiBmVLQhrHQWt/9hPlVAkuCnV9OCXhV3EoEB1
Lkc0LcDCXOY18Hz+HTvb45bwgp+p/6kzmRIGK++G8ZX9een/+tWvbHXHC4YcFFNw
YPTYyuU8GaNl1ekDHadDNW8byZudXOvR9kPOZD5T/JkkO4Y2a/LcP6wVKcYK/vC/
Hb3yKhW50BgbY1uHu2MAnR999QUn51S2pM3eK4KD9ilSzY9GkhRODJGE5jGdJZA=
=qWos
-----END PGP SIGNATURE-----

--Signature=_Wed__27_Jul_2011_14_11_51_+1000_J8F=HzOiNf6G.332--

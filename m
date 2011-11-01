Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314Ab1KAJxf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 05:53:35 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:49066 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157Ab1KAJxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 05:53:32 -0400
Date: Tue, 1 Nov 2011 20:53:23 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, Linus <torvalds@linux-foundation.org>
Subject: linux-next: Tree for Nov 1
Message-Id: <20111101205323.c12f2f940f23febba8ab8989@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__1_Nov_2011_20_53_23_+1100_21oeQM7eDyQhQPaj"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__1_Nov_2011_20_53_23_+1100_21oeQM7eDyQhQPaj
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

We are headed back to some level of normalcy with this release.

The linux-next tree on github is no longer being updated and will be
rmeoved soon.

The patch is still absent.

Changes since 20111025:

Removed trees: leds, backlight (Andrew says that the maintiner has retired)
Renamed tree: iscsi-target -> target-updates
Added tree: target-merge

The arm-soc tree lost its conflicts.

The crypot-current and crypto trees gained a build failure so I used the
version from next-20111025.

The logfs tree gained a conflict against Linus' tree.

The hid tree lost ints conflict.

The kbuild tree gained a conflict against Linus' tree.

The libata tree lost its conflict.

The scsi tree lost its conflict.

The net-next tree lost its conflicts.

The sound tree lost its conflicts, but gained a build failure for which I
reverted a commit.

The block tree gained a conflict against Linus' tree.

The mmc tree lost its conflicts.

The mfd tree lost a conflict but gained another against the arm-soc tree.

The fbdev tree lost its conflicts.

The security tree lost its conflict.

The watchdog tree gained a buils failure so I used the version from
next-20111025.

The trivial tree lost its conflicts.

The pm tree lost its conflicts.

The edac tree gained a build failure so I used the version from
next-20111025.

The tip tree lost its conflicts.

The regmap tree lost its conflict.

The driver-core tree lost its conflicts.

The tty tree lost its conflicts.

The usb tree lost its conflict.

The staging tree lost its conflicts.

The hwspinlock tree gained a conflict against the arm-soc tree.

The moduleh tree gained conflicts against the mfd and device-mapper trees
and also gained a build failure for which I applied a patch.  It lost 9
conflicts.

The akpm tree gained conflicts against Linus' and the scsi trees.  I also
dropped some patches that appeared eleswhere.

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

We are up to 197 trees (counting Linus' and 27 trees of patches pending
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
Merging fixes/master
Merging kbuild-current/rc-fixes
Merging arm-current/fixes
Merging m68k-current/for-linus
Merging powerpc-merge/merge
Merging 52xx-and-virtex-current/powerpc/merge
Merging sparc/master
Merging scsi-rc-fixes/master
Merging net/master
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
$ git reset --hard HEAD^
Merging refs/next/20111025/crypto-current
Merging ide/master
Merging dwmw2/master
Merging sh-current/sh-fixes-for-linus
Merging rmobile-current/rmobile-fixes-for-linus
Merging devicetree-current/devicetree/merge
Merging spi-current/spi/merge
Merging arm/for-next
Merging arm-lpae/for-next
CONFLICT (content): Merge conflict in arch/arm/mm/mmu.c
CONFLICT (content): Merge conflict in arch/arm/mm/dma-mapping.c
CONFLICT (content): Merge conflict in arch/arm/kernel/sleep.S
CONFLICT (content): Merge conflict in arch/arm/kernel/head.S
CONFLICT (content): Merge conflict in arch/arm/include/asm/pgtable.h
CONFLICT (content): Merge conflict in arch/arm/include/asm/pgtable-hwdef.h
CONFLICT (content): Merge conflict in arch/arm/include/asm/page.h
Merging arm-soc/for-next
Applying: arm-soc: merge fixup for fixup/reserve being added to MACHINE des=
criptions
Merging at91/at91-next
CONFLICT (content): Merge conflict in drivers/ata/pata_at91.c
CONFLICT (content): Merge conflict in arch/arm/mach-at91/at91sam9g45.c
CONFLICT (content): Merge conflict in arch/arm/mach-at91/at91sam9260.c
Merging davinci/davinci-next
Merging i.MX/for-next
CONFLICT (content): Merge conflict in arch/arm/plat-mxc/include/mach/hardwa=
re.h
CONFLICT (content): Merge conflict in arch/arm/mach-mx5/mm.c
CONFLICT (content): Merge conflict in arch/arm/mach-mx5/devices-imx53.h
CONFLICT (content): Merge conflict in arch/arm/mach-mx5/clock-mx51-mx53.c
Merging linux-spec/for-next
Merging omap/for-next
Merging pxa/for-next
Merging samsung/next-samsung
Merging s5p/for-next
Merging tegra/for-next
Merging xilinx/arm-next
Merging blackfin/for-linus
Merging c6x/for-linux-next
Merging cris/for-next
Merging quilt/hexagon
Merging ia64/next
Merging m68k/for-next
Merging m68knommu/for-next
CONFLICT (content): Merge conflict in arch/m68k/kernel/Makefile
CONFLICT (add/add): Merge conflict in arch/m68k/Kconfig.devices
CONFLICT (add/add): Merge conflict in arch/m68k/Kconfig.bus
Merging microblaze/next
Merging mips/mips-for-linux-next
CONFLICT (content): Merge conflict in sound/mips/Kconfig
CONFLICT (content): Merge conflict in drivers/video/Kconfig
CONFLICT (content): Merge conflict in drivers/mmc/host/au1xmmc.c
CONFLICT (content): Merge conflict in drivers/ide/Kconfig
CONFLICT (content): Merge conflict in arch/mips/alchemy/devboards/db1x00/pl=
atform.c
Merging openrisc/for-upstream
Merging parisc/for-next
Merging powerpc/next
CONFLICT (content): Merge conflict in drivers/tty/serial/8250.c
CONFLICT (content): Merge conflict in arch/powerpc/kernel/udbg.c
CONFLICT (content): Merge conflict in arch/powerpc/include/asm/udbg.h
CONFLICT (modify/delete): arch/powerpc/configs/40x/hcu4_defconfig deleted i=
n powerpc/next and modified in HEAD. Version HEAD of arch/powerpc/configs/4=
0x/hcu4_defconfig left in tree.
$ git rm -f arch/powerpc/configs/40x/hcu4_defconfig
Merging 4xx/next
Merging 52xx-and-virtex/powerpc/next
Merging galak/next
Merging s390/features
Merging sh/sh-latest
Merging rmobile/rmobile-latest
Merging sparc-next/master
Merging tile/master
CONFLICT (content): Merge conflict in arch/tile/lib/atomic_asm_32.S
CONFLICT (content): Merge conflict in arch/tile/kernel/intvec_32.S
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
CONFLICT (content): Merge conflict in fs/gfs2/file.c
Merging hfsplus/for-next
Merging jfs/next
Merging logfs/master
CONFLICT (content): Merge conflict in fs/logfs/file.c
Merging nfs/linux-next
Merging nfsd/nfsd-next
Merging nilfs2/for-next
Merging ocfs2/linux-next
CONFLICT (content): Merge conflict in fs/ocfs2/xattr.c
Merging omfs/for-next
Merging squashfs/master
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
CONFLICT (content): Merge conflict in Documentation/PCI/pci.txt
Merging docs/docs-move
Merging v4l-dvb/master
Merging kbuild/for-next
CONFLICT (content): Merge conflict in drivers/net/ethernet/stmicro/stmmac/K=
config
Merging kconfig/for-next
Merging libata/NEXT
Merging infiniband/for-next
Merging acpi/acpi
Merging idle-test/idle-test
Merging powertools/tools-test
Merging cpupowerutils/master
Merging ieee1394/for-next
Merging ubi/linux-next
Merging dlm/next
Merging swiotlb/master
CONFLICT (content): Merge conflict in drivers/xen/swiotlb-xen.c
Merging ibft/master
Merging scsi/master
Merging target-updates/for-next
Merging target-merge/for-next-merge
Merging slave-dma/next
Merging async_tx/next
Merging net-next/master
Merging wireless/master
Merging bluetooth/master
CONFLICT (content): Merge conflict in net/bluetooth/l2cap_sock.c
Merging mtd/master
Merging l2-mtd/master
CONFLICT (content): Merge conflict in drivers/mtd/maps/lantiq-flash.c
CONFLICT (modify/delete): arch/arm/mach-at91/board-usb-a9260.c deleted in H=
EAD and modified in l2-mtd/master. Version l2-mtd/master of arch/arm/mach-a=
t91/board-usb-a9260.c left in tree.
CONFLICT (content): Merge conflict in arch/arm/mach-at91/board-sam9m10g45ek=
.c
CONFLICT (content): Merge conflict in arch/arm/mach-at91/board-sam9g20ek.c
CONFLICT (content): Merge conflict in arch/arm/mach-at91/board-rm9200dk.c
CONFLICT (content): Merge conflict in arch/arm/mach-at91/board-neocore926.c
CONFLICT (content): Merge conflict in arch/arm/mach-at91/board-afeb-9260v1.c
$ git rm -f arch/arm/mach-at91/board-usb-a9260.c
Merging crypto/master
$ git reset --hard HEAD^
Merging refs/next/20111025/crypto
Merging sound/for-next
Merging sound-asoc/for-next
Merging cpufreq/next
Merging quilt/rr
Merging input/next
Merging input-mt/next
Merging lsm/for-next
Merging block/for-next
CONFLICT (content): Merge conflict in drivers/staging/zram/zram_drv.c
CONFLICT (content): Merge conflict in drivers/md/raid5.c
CONFLICT (content): Merge conflict in drivers/md/raid10.c
CONFLICT (content): Merge conflict in drivers/md/raid1.c
CONFLICT (content): Merge conflict in drivers/md/raid0.c
CONFLICT (content): Merge conflict in drivers/md/multipath.c
CONFLICT (content): Merge conflict in drivers/md/md.h
CONFLICT (content): Merge conflict in drivers/md/md.c
CONFLICT (content): Merge conflict in drivers/md/linear.c
CONFLICT (content): Merge conflict in drivers/md/faulty.c
Merging quilt/device-mapper
Merging embedded/master
Merging firmware/master
Merging pcmcia/master
Merging battery/master
Merging mmc/mmc-next
Merging kgdb/kgdb-next
Merging slab/for-next
Merging uclinux/for-next
Merging md/for-next
Merging mfd/for-next
CONFLICT (content): Merge conflict in arch/arm/mach-omap2/board-omap3beagle=
.c
CONFLICT (content): Merge conflict in arch/arm/mach-imx/mach-mx31moboard.c
Merging hdlc/hdlc-next
Merging drm/drm-next
Merging fbdev/fbdev-next
Merging viafb/viafb-next
Merging omap_dss2/for-next
Merging regulator/for-next
Applying: regulator: using module related services requires module.h
Merging security/next
Merging selinux/master
Merging lblnet/master
Merging watchdog/linux-next
$ git reset --hard HEAD^
Merging refs/next/20111025/watchdog
Merging bdev/master
Merging dwmw2-iommu/master
Merging iommu/next
Merging cputime/cputime
CONFLICT (content): Merge conflict in kernel/sched_stats.h
CONFLICT (content): Merge conflict in include/asm-generic/cputime.h
CONFLICT (content): Merge conflict in fs/proc/stat.c
Merging osd/linux-next
Merging jc_docs/docs-next
Merging nommu/master
Merging trivial/for-next
Merging audit/for-next
Merging pm/linux-next
Merging apm/for-next
Merging fsnotify/for-next
Merging irda/for-next
Merging edac/linux_next
$ git reset --hard HEAD^
Merging refs/next/20111025/edac
CONFLICT (content): Merge conflict in arch/x86/kernel/cpu/mcheck/mce.c
[master c97bf54] Merge commit 'refs/next/20111025/edac'
Merging edac-amd/for-next
Merging devicetree/devicetree/next
Merging spi/spi/next
Merging gpio/gpio/next
Merging tip/auto-latest
CONFLICT (content): Merge conflict in drivers/char/random.c
CONFLICT (content): Merge conflict in arch/x86/kernel/cpu/amd.c
Merging rcu/rcu/next
Merging kmemleak/kmemleak
Merging kvm/kvm-updates/3.2
Merging oprofile/for-next
Merging xen/upstream/xen
CONFLICT (content): Merge conflict in arch/x86/xen/Kconfig
Merging xen-two/linux-next
Merging xen-pvhvm/linux-next
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
Merging usb/usb-next
Merging staging/staging-next
Merging bkl-config/config
Merging tmem/tmem
Merging writeback/writeback-for-next
Merging arm-dt/devicetree/arm-next
Merging hwspinlock/linux-next
CONFLICT (content): Merge conflict in arch/arm/mach-omap2/hwspinlock.c
Merging pinctrl/for-next
CONFLICT (content): Merge conflict in arch/arm/mach-u300/core.c
CONFLICT (content): Merge conflict in arch/arm/mach-u300/Kconfig
Merging moduleh/for-sfr
CONFLICT (content): Merge conflict in include/linux/dmaengine.h
CONFLICT (modify/delete): drivers/mfd/ab3550-core.c deleted in HEAD and mod=
ified in moduleh/for-sfr. Version moduleh/for-sfr of drivers/mfd/ab3550-cor=
e.c left in tree.
CONFLICT (content): Merge conflict in drivers/media/dvb/frontends/dibx000_c=
ommon.c
$ git rm -f drivers/mfd/ab3550-core.c
Applying: arm: Add export.h to recently added files for EXPORT_SYMBOL
Applying: powerpc/powernv: include export.h in hvc_opal.h for THIS_MODULE
Applying: drivers/md: change module.h -> export.h in persistent-data/dm-*
CONFLICT (content): Merge conflict in drivers/md/persistent-data/dm-space-m=
ap-disk.c
Applying: device-mapper: dm-bufio.c needs to include module.h
Merging kvmtool/master
CONFLICT (content): Merge conflict in include/net/9p/9p.h
Merging scsi-post-merge/merge-base:master
$ git checkout akpm
Applying: include/linux/dmar.h: forward-declare struct acpi_dmar_header
Applying: drivers/net/ethernet/i825xx/3c505.c: fix build with dynamic debug
Applying: drm: fix kconfig unmet dependency warning
Applying: net/netfilter/nf_conntrack_netlink.c: fix Oops on container destr=
oy
Applying: readlinkat: ensure we return ENOENT for the empty pathname for no=
rmal lookups
Applying: readlinkat-ensure-we-return-enoent-for-the-empty-pathname-for-nor=
mal-lookups-fix
Applying: acerhdf: add support for Aspire 1410 BIOS v1.3314
Applying: arch/x86/platform/iris/iris.c: register a platform device and a p=
latform driver
Applying: x86: fix mmap random address range
Applying: arch/x86/kernel/e820.c: eliminate bubble sort from sanitize_e820_=
map
Applying: vrtc: change its year offset from 1960 to 1972
Applying: x86: rtc: don't register a platform RTC device for Intel MID plat=
forms
Applying: mrst: battery fixes
Applying: drivers/power/intel_mid_battery.c: fix build
Applying: x86,mrst: add mapping for bma023
Applying: arch/x86/kernel/e820.c: quiet sparse noise about plain integer as=
 NULL pointer
Applying: arch/x86/kernel/ptrace.c: quiet sparse noise
Applying: arch/x86/mm/pageattr.c: quiet sparse noise; local functions shoul=
d be static
Applying: x86: tlb flush avoid superflous leave_mm()
Applying: x86: reduce clock calibration time during slave cpu startup
Applying: x86-reduce-clock-calibration-time-during-slave-cpu-startup-fix
Applying: arch/arm/mach-ux500/mbox-db5500.c: world-writable sysfs fifo file
Applying: arm, exec: remove redundant set_fs(USER_DS)
Applying: audit: always follow va_copy() with va_end()
Applying: btrfs: don't dereference extent_mapping if NULL
Applying: ceph/mds_client.c: quiet sparse noise
Applying: drivers/edac/mpc85xx_edac.c: fix memory controller compatible for=
 edac
Applying: devtmpfsd: fix task state handling
Applying: drivers/gpu/vga/vgaarb.c: add missing kfree
Applying: drm: avoid switching to text console if there is no panic timeout
Applying: hrtimers: Special-case zero length sleeps
Applying: ia64, exec: remove redundant set_fs(USER_DS)
Applying: brlocks/lglocks: clean up code
Applying: brlocks-lglocks-clean-up-code-checkpatch-fixes
Applying: ipc/mqueue: cleanup definition names and locations
Applying: ipc/mqueue: switch back to using non-max values on create
Applying: ipc/mqueue: enforce hard limits
Applying: ipc/mqueue: update maximums for the mqueue subsystem
Applying: ipc-mqueue-update-maximums-for-the-mqueue-subsystem-fix
Applying: ipc-mqueue-update-maximums-for-the-mqueue-subsystem-checkpatch-fi=
xes
Applying: unicore32, exec: remove redundant set_fs(USER_DS)
Applying: drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe.h: remove unused ma=
cro pr_fmt()
Applying: debugobjects: extend debugobjects to assert that an object is ini=
tialized
Applying: kernel/timer.c: use debugobjects to catch deletion of uninitializ=
ed timers
Applying: ext4: use proper little-endian bitops
Applying: ocfs2: avoid unaligned access to dqc_bitmap
Applying: parisc, exec: remove redundant set_fs(USER_DS)
Applying: drivers/firmware/dmi_scan.c: make dmi_name_in_vendors more focused
Applying: scsi: fix a header to include linux/types.h
Applying: drivers/scsi/megaraid.c: fix sparse warnings
Applying: drivers/scsi/aacraid/commctrl.c: fix mem leak in aac_send_raw_srb=
()
Applying: drivers/scsi/sd.c: use ida_simple_get() and ida_simple_remove() i=
n place of boilerplate code
CONFLICT (content): Merge conflict in drivers/scsi/sd.c
Applying: drivers/scsi/osd/osd_uld.c: use ida_simple_get() to handle id
Applying: drivers/scsi/sg.c: convert to kstrtoul_from_user()
Applying: drivers/scsi/mpt2sas/mpt2sas_base.c: fix mismatch in mpt2sas_base=
_hard_reset_handler() mutex lock-unlock
Applying: drivers/message/fusion/mptbase.c: ensure NUL-termination of MptCa=
llbacksName elements
Applying: loop: prevent information leak after failed read
Applying: loop: cleanup set_status interface
Applying: loop-cleanup-set_status-interface-checkpatch-fixes
Applying: cciss: auto engage SCSI mid layer at driver load time
Applying: block: avoid unnecessary plug list flush
Applying: block: add missed trace_block_plug
Applying: include/linux/bio.h: use a static inline function for bio_integri=
ty_clone()
Applying: bio: change some signed vars to unsigned
Applying: paride: fix potential information leak in pg_read()
Applying: drivers/watchdog/w83627hf_wdt.c: implement WDIOC_GETTIMELEFT ioct=
l support
Applying: slab: add taint flag outputting to debug paths.
Applying: slub: add taint flag outputting to debug paths
Applying: drivers/tty/serial/pch_uart.c: add console support
Applying: Cross Memory Attach
Applying: cross-memory-attach-update
Applying: cross-memory-attach-v4
Applying: mm: compaction: trivial clean up in acct_isolated()
Applying: mm: change isolate mode from #define to bitwise type
Applying: mm-change-isolate-mode-from-define-to-bitwise-type-fix
Applying: mm: compaction: make isolate_lru_page() filter-aware
Applying: mm-compaction-make-isolate_lru_page-filter-aware-fix
Applying: mm: zone_reclaim: make isolate_lru_page() filter-aware
Applying: mm-zone_reclaim-make-isolate_lru_page-filter-aware-fix
Applying: mm: migration: clean up unmap_and_move()
Applying: radix_tree: clean away saw_unset_tag leftovers
Applying: vmscan: add block plug for page reclaim
Applying: mm/page-writeback.c: make determine_dirtyable_memory static again
Applying: mm/page-writeback.c: document bdi_min_ratio
Applying: oom: avoid killing kthreads if they assume the oom killed thread'=
s mm
Applying: oom: remove oom_disable_count
Applying: oom: fix race while temporarily setting current's oom_score_adj
Applying: tmpfs: add "tmpfs" to the Kconfig prompt to make it obvious.
Applying: mm: output a list of loaded modules when we hit bad_page()
Applying: mm: vmscan: drop nr_force_scan[] from get_scan_count
Applying: mm: distinguish between mlocked and pinned pages
Applying: mm: add comments to explain mm_struct fields
Applying: mm-add-comments-to-explain-mm_struct-fields-fix
Applying: mm: vmscan: do not writeback filesystem pages in direct reclaim
Applying: mm: vmscan: remove dead code related to lumpy reclaim waiting on =
pages under writeback
Applying: xfs: warn if direct reclaim tries to writeback pages
Applying: ext4: warn if direct reclaim tries to writeback pages
Applying: mm: vmscan: do not writeback filesystem pages in kswapd except in=
 high priority
Applying: mm: vmscan: throttle reclaim if encountering too many dirty pages=
 under writeback
Applying: mm-vmscan-throttle-reclaim-if-encountering-too-many-dirty-pages-u=
nder-writeback-update
Applying: mm: vmscan: immediately reclaim end-of-LRU dirty pages when write=
back completes
Applying: vmscan: count pages into balanced for zone with good watermark
Applying: mm/debug-pagealloc.c: use plain __ratelimit() instead of printk_r=
atelimit()
Applying: lib/string.c: introduce memchr_inv()
Applying: lib-stringc-introduce-memchr_inv-fix-kernel-doc-for-memchr_inv
Applying: mm/debug-pagealloc.c: use memchr_inv
Applying: vmscan: fix initial shrinker size handling
Applying: vmscan: use atomic-long for shrinker batching
Applying: vmscan-use-atomic-long-for-shrinker-batching-fix
Applying: mm: avoid null pointer access in vm_struct via /proc/vmallocinfo
Applying: vmscan: promote shared file mapped pages
Applying: vmscan: activate executable pages after first usage
Applying: memblock: add memblock_start_of_DRAM()
Applying: memblock: add NO_BOOTMEM config symbol
Applying: mremap: check for overflow using deltas
Applying: mremap: avoid sending one IPI per page
Applying: thp: mremap support and TLB optimization
Applying: thp-mremap-support-and-tlb-optimization-fix
Applying: thp-mremap-support-and-tlb-optimization-fix-fix
Applying: thp-mremap-support-and-tlb-optimization-fix-fix-fix
Applying: include/asm-generic/page.h: calculate virt_to_page and page_to_vi=
rt via predefined macro
Applying: mm: neaten warn_alloc_failed
Applying: mm-neaten-warn_alloc_failed-fix
Applying: debug-pagealloc: add support for highmem pages
Applying: debug-pagealloc-add-support-for-highmem-pages-fix
Applying: kswapd: avoid unnecessary rebalance after an unsuccessful balanci=
ng
Applying: mm: add free_hot_cold_page_list() helper
Applying: mm/memblock.c: small function definition fixes
Applying: kswapd: assign new_order and new_classzone_idx after wakeup in sl=
eeping
Applying: mm: fix page-faults detection in swap-token logic
Applying: mm/vmalloc.c: report more vmalloc failures
Applying: mm: add extra free kbytes tunable
Applying: mm-add-extra-free-kbytes-tunable-update
Applying: mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes
Applying: mm: thp: tail page refcounting fix
Applying: powerpc: remove superfluous PageTail checks on the pte gup_fast
Applying: powerpc: get_hugepte() don't put_page() the wrong page
Applying: powerpc: gup_hugepte() avoid to free the head page too many times
Applying: powerpc: gup_hugepte() support THP based tail recounting
Applying: powerpc: gup_huge_pmd() return 0 if pte changes
Applying: s390: gup_huge_pmd() support THP tail recounting
Applying: s390: gup_huge_pmd() return 0 if pte changes
Applying: sparc: gup_pte_range() support THP based tail recounting
Applying: thp: share get_huge_page_tail()
Applying: ksm: fix the comment of try_to_unmap_one()
Applying: mm-add-comment-explaining-task-state-setting-in-bdi_forker_thread=
-fix
Applying: vmscan: fix shrinker callback bug in fs/super.c
Applying: mm/mmap.c: eliminate the ret variable from mm_take_all_locks()
Applying: mm-mmapc-eliminate-the-ret-variable-from-mm_take_all_locks-fix
Applying: fs/buffer.c: add device information for error output in __find_ge=
t_block_slow()
Applying: HWPOISON: convert pr_debug()s to pr_info()s
Applying: mm: compaction: make compact_zone_order() static
Applying: mm: fix kunmap_high() comment
Applying: vmscan.c: fix invalid strict_strtoul() check in write_scan_unevic=
table_node()
Applying: mm: disable user interface to manually rescue unevictable pages
Applying: mm/memblock.c: quiet sparse noise
Applying: mm/thrash.c: quiet sparse noise
Applying: mm/mempolicy.c: quiet sparse noise
Applying: mm/huge_memory.c: quiet sparse noise
Applying: vmscan: add barrier to prevent evictable page in unevictable list
Applying: vmscan: limit direct reclaim for higher order allocations
Applying: vmscan-limit-direct-reclaim-for-higher-order-allocations-fix
Applying: vmscan: abort reclaim/compaction if compaction can proceed
Applying: mm: add vm_area_add_early()
Applying: oom: thaw threads if oom killed thread is frozen before deferring
Applying: mm: do not drain pagevecs for mlockall(MCL_FUTURE)
Applying: mm/huge_memory: fix copying user highpage
Applying: mm/huge_memory: fix typo when updating mmu cache
Applying: mm: munlock use mapcount to avoid terrible overhead
Applying: mm-munlock-use-mapcount-to-avoid-terrible-overhead-fix
Applying: selinuxfs: remove custom hex_to_bin()
Applying: include/linux/security.h: fix security_inode_init_security() arg
Applying: hpet: factor timer allocate from open
Applying: alpha: wire up accept4 syscall
Applying: alpha: wire up sendmmsg syscall
Applying: intel_idle: fix API misuse
Applying: intel_idle: disable auto_demotion for hotplugged CPUs
Applying: fs/pipe.c: add ->statfs callback for pipefs
Applying: lib/Kconfig.debug: fix help message for DEFAULT_HUNG_TASK_TIMEOUT
Applying: hwmon: convert idr to ida and use ida_simple interface
Applying: drivers/hwmon/hwmon.c: convert idr to ida and use ida_simple_get()
Applying: lis3lv02d: avoid divide by zero due to unchecked
Applying: lis3: update maintainer information
Applying: lis3: add support for HP EliteBook 2730p
Applying: lis3: add support for HP EliteBook 8540w
Applying: hp_accel: add HP ProBook 655x
Applying: lis3: free regulators if probe() fails
Applying: lis3: use consistent naming of variables
Applying: lis3: change exported function to use passed parameter
Applying: lis3: remove the references to the global variable in core driver
Applying: lis3-remove-the-references-to-the-global-variable-in-core-driver-=
fix
Applying: lis3lv02d: make regulator API usage unconditional
Applying: driver/misc/fsa9480.c fix potential null-pointer dereference
Applying: drivers/misc/ad525x_dpot-i2c.c: add i2c support for AD5161
Applying: stop_machine: make stop_machine safe and efficient to call early
Applying: stop_machine-make-stop_machine-safe-and-efficient-to-call-early-v=
3.
Applying: watchdog: move watchdog_*_all_cpus under CONFIG_SYSCTL
Applying: kernel/sysctl.c: add cap_last_cap to /proc/sys/kernel
Applying: kernel-sysctlc-add-cap_last_cap-to-proc-sys-kernel-fix
Applying: printk: add module parameter ignore_loglevel to control ignore_lo=
glevel
Applying: printk: add ignore_loglevel as module parameter
Applying: printk: add console_suspend module parameter
Applying: printk: fix bounds checking for log_prefix
Applying: printk: remove bounds checking for log_prefix
Applying: treewide: use __printf not __attribute__((format(printf,...)))
Applying: treewide-use-__printf-not-__attribute__formatprintf: revert arch =
bits
Applying: poll: add poll_requested_events() function
Applying: MAINTAINERS: Linas has moved
Applying: MAINTAINERS: add ASLR maintainer
Applying: video/backlight: remove obsolete cleanup for clientdata
Applying: backlight: fix broken regulator API usage in l4f00242t03
Applying: drivers/video/backlight/l4f00242t03.c: use gpio_request_one() to =
simplify error handling
Applying: backlight: rename corgibl_limit_intensity() to genericbl_limit_in=
tensity()
Applying: leds: Renesas TPU LED driver
Applying: leds-renesas-tpu-led-driver-v2-fix
Applying: drivers/leds/led-triggers.c: fix memory leak
Applying: drivers/leds/leds-lm3530.c: remove obsolete cleanup for clientdata
Applying: drivers/leds/leds-renesas-tpu.c: update driver to use workqueue
Applying: drivers/leds/leds-renesas-tpu.c: move Renesas TPU LED driver plat=
form data
Applying: drivers/leds/leds-lp5521.c: avoid writing uninitialized value to =
LP5521_REG_OP_MODE register
Applying: leds-leds-lp5521-avoid-writing-uninitialized-value-to-lp5521_reg_=
op_mode-register-fix
Applying: drivers/leds/leds-lm3530.c: add __devexit_p where needed
Applying: drivers/leds/leds-gpio.c: use gpio_get_value_cansleep() when init=
ializing
Applying: leds: save the delay values after a successful call to blink_set()
Applying: leds: turn the blink_timer off before starting to blink
Applying: drivers/leds/leds-lp5521.c: check if reset is successful
Applying: drivers-leds-leds-lp5521c-check-if-reset-is-successful-fix
Applying: lib/kstrtox: common code between kstrto*() and simple_strto*() fu=
nctions
Applying: lib/spinlock_debug.c: print owner on spinlock lockup
Applying: lib/bitmap.c: quiet sparse noise about address space
Applying: lib-bitmapc-quiet-sparse-noise-about-address-space-fix
Applying: lib/percpu_counter.c: enclose hotplug only variables in hotplug i=
fdef
Applying: lib/idr.c: fix comment for ida_get_new_above()
Applying: lib/string.c: fix strim() semantics for strings that have only bl=
anks
Applying: security: follow rename pack_hex_byte() to hex_byte_pack()
Applying: fat: follow rename pack_hex_byte() to hex_byte_pack()
Applying: wireless: at76c50x: follow rename pack_hex_byte to hex_byte_pack
Applying: llist-return-whether-list-is-empty-before-adding-in-llist_add-fix
Applying: kernel.h/checkpatch: mark strict_strto<foo> and simple_strto<foo>=
 as obsolete
Applying: checkpatch: add a --strict check for utf-8 in commit logs
Applying: lib/crc: add slice by 8 algorithm to crc32.c
Applying: lib-crc-add-slice-by-8-algorithm-to-crc32c-fix
Applying: epoll: fix spurious lockdep warnings
Applying: epoll: limit paths
Applying: binfmt_elf: fix PIE execution with randomization disabled
Applying: ramfs: remove module leftovers
Applying: init/do_mounts_rd.c: fix ramdisk identification for padded cramfs
Applying: oprofilefs: handle zero-length writes
Applying: drivers/rtc/class.c: convert idr to ida and use ida_simple_get()
Applying: rtc: add initial support for mcp7941x parts
Applying: drivers/rtc/rtc-mc13xxx.c: move probe and remove callbacks to .in=
it.text and .exit.text
Applying: minix: describe usage of different magic numbers
Applying: isofs: add readpages support
Applying: hfs: fix hfs_find_init() sb->ext_tree NULL ptr oops
Applying: cgroups: more safe tasklist locking in cgroup_attach_proc
Applying: cgroups: don't attach task to subsystem if migration failed
Applying: cgroup/kmemleak: Annotate alloc_page() for cgroup allocations
Applying: cgroups: add res_counter_write_u64() API
Applying: cgroups: new resource counter inheritance API
Applying: cgroups: add previous cgroup in can_attach_task/attach_task callb=
acks
Applying: cgroups: new cancel_attach_task() subsystem callback
Applying: cgroups: ability to stop res charge propagation on bounded ancest=
or
Applying: cgroups: add res counter common ancestor searching
Applying: res_counter: allow charge failure pointer to be null
Applying: cgroups: pull up res counter charge failure interpretation to cal=
ler
Applying: cgroups: allow subsystems to cancel a fork
Applying: cgroups: add a task counter subsystem
Applying: cgroups: ERR_PTR needs err.h
Applying: memcg: rename mem variable to memcg
Applying: memcg: fix oom schedule_timeout()
Applying: memcg: replace ss->id_lock with a rwlock
Applying: memcg: do not expose uninitialized mem_cgroup_per_node to world
Applying: memcg: skip scanning active lists based on individual size
Applying: memcg-skip-scanning-active-lists-based-on-individual-size-fix
Applying: memcg: close race between charge and putback
Applying: memcg: Fix race condition in memcg_check_events() with this_cpu u=
sage
Applying: mm/page_cgroup.c: quiet sparse noise
Applying: cpusets: avoid looping when storing to mems_allowed if one node r=
emains set
Applying: procfs: report EISDIR when reading sysctl dirs in proc
Applying: proc: fix races against execve() of /proc/PID/fd**
Applying: proc-fix-races-against-execve-of-proc-pid-fd-fix
Applying: proc: force dcache drop on unauthorized access
Applying: ipc/sem.c: fix return code race with semop vs. semop +semctl(IPC_=
RMID)
Applying: ipc/sem.c: handle spurious wakeups
Applying: ipc/sem.c: remove private structures from public header file
Applying: include/linux/sem.h: make sysv_sem empty if SYSVIPC is disabled
Applying: ipc/sem.c: alternatives to preempt_disable()
Applying: init: add root=3DPARTUUID=3DUUID/PARTNROFF=3D%d support
Applying: init-add-root=3Dpartuuid=3Duuid-partnroff=3D%d-support-fix
Applying: drivers/rapidio/rio-scan.c: use discovered bit to test if enumera=
tion is complete
Applying: arch/powerpc/sysdev/fsl_rio.c: release rapidio port I/O region re=
source if port failed to initialize
Applying: RapidIO: add mport driver for Tsi721 bridge
Applying: RapidIO: Tsi721 driver - fixes for the initial release
Applying: RapidIO: fix potential null deref in rio_setup_device()
Applying: drivers/net/rionet.c: fix ethernet address macros for LE platforms
Applying: RapidIO: documentation update
Applying: sysctl: add support for poll()
Applying: sysctl-add-support-for-poll-fix
Applying: sysctl: make CONFIG_SYSCTL_SYSCALL default to n
Applying: include/linux/dma-mapping.h: add dma_zalloc_coherent()
Applying: pps: default echo function
Applying: pps: new client driver using GPIO
Applying: pps-new-client-driver-using-gpio-fix
Applying: pps gpio client: add missing dependency
Applying: w1: ds2760 and ds2780, use ida for id and ida_simple_get() to get=
 it
Applying: drivers/power/ds2780_battery.c: create central point for calling =
w1 interface
Applying: drivers/power/ds2780_battery.c: add a nolock function to w1 inter=
face
Applying: drivers/power/ds2780_battery.c: fix deadlock upon insertion and r=
emoval
Applying: drivers/w1/w1_int.c: multiple masters used same init_name
Applying: w1: disable irqs in critical section
Applying: drivers/misc/vmw_balloon.c: determine page allocation flag can_sl=
eep outside loop
Applying: drivers/misc/vmw_balloon.c: fix typo in code comment
Applying: aio: allocate kiocbs in batches
Applying: fs/direct-io.c: salcuate fs_count correctly in get_more_blocks()
CONFLICT (content): Merge conflict in fs/direct-io.c
Applying: vfs: cache request_queue in struct block_device
Applying: dio: optimize cache misses in the submission path
Applying: dio-optimize-cache-misses-in-the-submission-path-v2-checkpatch-fi=
xes
Applying: dio: using prefetch requires including prefetch.h
Applying: ramoops: update parameters only after successful init
Merging akpm
[master 17e2bb6] Revert "drivers/scsi/sd.c: use ida_simple_get() and ida_si=
mple_remove() in place of boilerplate code"
[master aff418b] Revert "ALSA: intel8x0: Improve performance in virtual env=
ironment"
Applying: device-mapper: using EXPORT_SYBOL in dm-space-map-checker.c needs=
 export.h

--Signature=_Tue__1_Nov_2011_20_53_23_+1100_21oeQM7eDyQhQPaj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOr8GTAAoJEECxmPOUX5FEibwQAJnkpHosSHd7B/DMamQGICD/
nbx3Oiq3p10WX+K1R/uNS86mRg7ByXVJZ5pEvOSW6c0LixqTMyTMaM+qjewWvsuT
+vO6Geffd8+K4UqQI5cat4DcXHvHluhsNaSJX1z1UHzITfgvAQG7O48tdbrPqvXp
OEgNOwu0l0Pfl8KJg6zZ8p+jR5zGMA85Co/m/bekxZN3atcqrYLrBPu35hec20Qc
Faf1Xp7INX7hEeP0+DDy9OlOUc7C4EXGf2RWX0HVqAcJN2UDwyIcjtue2fKOSbED
UdSgcbtsPCk4/o6lZKNSq9ky6tY+mGUq2bYEPnTR6uQg2qrc96B5KVkJXC3WRBZX
Fp2haIJGFF9/yPTRATjuov15up26jJsIGfDjh3J/tacClnfH2O7twqGxaFx1SJbT
CajQiTia4vLfKslxvYsuTlu0C+xF43JWOpe+EtamqmM9rPqrxtvalmziakAk8ZFR
x9SXyvDFH9noycOgoaMBW/THbpECXK8I4lx0i/nmw7Ti9OrrB6Bpm+IqzxSP50r0
olR4G2QxIyNc+w/QRVyLCRmmwixlQQ9HORRLhEEpzOeau+NP1nOOJFQpjm5EN/G8
8WtUizkUQCWto+1wJv/EpJVeattcOGyc3KfkiVdMPZSElBkCg2cn1gEHpddFucUB
4I4M5DGFP0jzFaz9Kum1
=xEbs
-----END PGP SIGNATURE-----

--Signature=_Tue__1_Nov_2011_20_53_23_+1100_21oeQM7eDyQhQPaj--

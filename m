Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126Ab1KBFyX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 01:54:23 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:47032 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073Ab1KBFyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 01:54:21 -0400
Date: Wed, 2 Nov 2011 16:54:13 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, Linus <torvalds@linux-foundation.org>
Subject: linux-next: Tree for Nov 2
Message-Id: <20111102165413.8cf3105a12e435f078c813eb@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__2_Nov_2011_16_54_13_+1100_tS=zzCKohDjZosv+"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__2_Nov_2011_16_54_13_+1100_tS=zzCKohDjZosv+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

The linux-next tree on github is no longer being updated and will be
removed soon.

The patch is still absent.

Changes since 20111101:

I reverted a commit from Linus' tree to fix a regression with hvc_console
and added a patch for a network driver build problem.

The crypot-current and crypto trees lost their build failure.

The ext3 tree gained a conflict against Linus' tree.

The bjdooks-i2c tree gained a conflict against Linus' tree.

The sound tree lost its build failure.

The watchdog tree still has its build failure so I used the version from
next-20111025.

The edac tree lost its build failure and conflict.

The tmem tree gained a conflict against Linus' tree.

I dropped some patches from the akpm tree that appeared in Linus' tree.

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
CONFLICT (add/add): Merge conflict in arch/hexagon/mm/strnlen_user.S
CONFLICT (add/add): Merge conflict in arch/hexagon/mm/pgalloc.c
CONFLICT (add/add): Merge conflict in arch/hexagon/mm/Makefile
CONFLICT (add/add): Merge conflict in arch/hexagon/lib/memset.S
CONFLICT (add/add): Merge conflict in arch/hexagon/kernel/vmlinux.lds.S
CONFLICT (add/add): Merge conflict in arch/hexagon/kernel/vm_vectors.S
CONFLICT (add/add): Merge conflict in arch/hexagon/kernel/vdso.c
CONFLICT (add/add): Merge conflict in arch/hexagon/kernel/kgdb.c
CONFLICT (add/add): Merge conflict in arch/hexagon/kernel/hexagon_ksyms.c
CONFLICT (add/add): Merge conflict in arch/hexagon/kernel/head.S
CONFLICT (add/add): Merge conflict in arch/hexagon/kernel/Makefile
CONFLICT (add/add): Merge conflict in arch/hexagon/include/asm/vdso.h
CONFLICT (add/add): Merge conflict in arch/hexagon/include/asm/timex.h
CONFLICT (add/add): Merge conflict in arch/hexagon/include/asm/Kbuild
CONFLICT (add/add): Merge conflict in arch/hexagon/Makefile
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
CONFLICT (content): Merge conflict in fs/udf/udfdecl.h
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
CONFLICT (add/add): Merge conflict in drivers/i2c/busses/i2c-designware-pla=
tdrv.c
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
CONFLICT (content): Merge conflict in mm/swapfile.c
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
Applying: device-mapper: dm-bufio.c needs to include module.h
Applying: device-mapper: using EXPORT_SYBOL in dm-space-map-checker.c needs=
 export.h
Merging kvmtool/master
CONFLICT (content): Merge conflict in include/net/9p/9p.h
Merging scsi-post-merge/merge-base:master
$ git checkout akpm
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
Applying: mm/page-writeback.c: make determine_dirtyable_memory static again
Applying: vmscan: fix initial shrinker size handling
Applying: vmscan: use atomic-long for shrinker batching
Applying: vmscan-use-atomic-long-for-shrinker-batching-fix
Applying: vmscan: promote shared file mapped pages
Applying: vmscan: activate executable pages after first usage
Applying: mm: add free_hot_cold_page_list() helper
Applying: mm: fix page-faults detection in swap-token logic
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
Applying: mm: add vm_area_add_early()
Applying: selinuxfs: remove custom hex_to_bin()
Applying: include/linux/security.h: fix security_inode_init_security() arg
Applying: hpet: factor timer allocate from open
Applying: intel_idle: fix API misuse
Applying: intel_idle: disable auto_demotion for hotplugged CPUs
Applying: poll: add poll_requested_events() function
Applying: lib/crc: add slice by 8 algorithm to crc32.c
Applying: lib-crc-add-slice-by-8-algorithm-to-crc32c-fix
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
Applying: vfs: cache request_queue in struct block_device
Applying: dio: optimize cache misses in the submission path
Applying: dio-optimize-cache-misses-in-the-submission-path-v2-checkpatch-fi=
xes
Applying: dio: using prefetch requires including prefetch.h
Applying: ramoops: update parameters only after successful init
Merging akpm
Applying: net: fix typo in drivers/net/ethernet/xilinx/ll_temac_main.c
[master c821cb3] Revert "hvc_console: display printk messages on console."

--Signature=_Wed__2_Nov_2011_16_54_13_+1100_tS=zzCKohDjZosv+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOsNsFAAoJEECxmPOUX5FEaPoP/jUqd5h00UwgYYQWA1L4J2Pn
KJ/I41SPCud5TJxXo8xtbj9kbfeA+olk3mVEftDoV9sQmPnYvHbzC4mI0ozRmami
MDQdwjJhP6wpcnKlmjVc95mdD917cbocXUYR4p+y0DTrcJXvJCU3uhrCWpHUB1AP
v5FOkHTp/Fr2hFiCjRUHCWvKtRRebGsN7BNHvtdcOPIJzh1zZuAFvM4K2+uXnldq
Z7TPeEtALbuTvb++J3tQfGz1iuAH43uY5xKqa6dpqN7HNA7atGro9o8QLa8EhCFv
P6gS2V1RTpEtiMpmsxRSfYLd9lo7KQZXXRte8chllAmXnnBgVGszHeJKHPkL2jiB
v48hue3JiW7Wav0p9R3VUGESCW7Kgab9GB9PdQgR/FWa0T4acoc5B5jQqUu7/sZh
th1ulufLa2I51odh71fhePdSUTU7UDdh5N1qkgT7lQRTcmPVu4cd3gnoJdH/KiMY
O8SgknZqak/6vJYjaZstABVOXXyoyEjaUvn3R8HuQ/cFdk4/14ftRYfoAR2x+BrF
VvrrnWdKtrFJgf4v8yatJy+m6wGQYeVkLyajt9a5blzdJt9EtlknWNHjKZ7hJxxo
G/9ekk0JnmcxyrwtdVx0BI//gsb1yM18F0mNorPPG3lUDRwzWB3+97d1hOXWXf5K
/qHCjjOaj8tS1XHpSMJp
=DDBd
-----END PGP SIGNATURE-----

--Signature=_Wed__2_Nov_2011_16_54_13_+1100_tS=zzCKohDjZosv+--

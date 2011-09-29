Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230Ab1I2G5i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 02:57:38 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:57138 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493Ab1I2G5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 02:57:35 -0400
Date: Thu, 29 Sep 2011 16:57:30 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Sept 29
Message-Id: <20110929165730.661cf28c9bb27b8a85432cd2@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__29_Sep_2011_16_57_30_+1000_yNxLepMX7JazDICl"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__29_Sep_2011_16_57_30_+1000_yNxLepMX7JazDICl
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

The linux-next tree is now available from
git://github.com/sfrothwell/linux-next.git as a temporary measure while
the kernel.org servers are unavailable.

Changes since 20110928:

The pm tree lost its build failure.

The wireless tree lost a conflict.

The regmap tree gained a build failure so I used the version from
next-20110928.

The moduleh tree lost  build failures but gained another for which I
applied a patch.  It also lost 15 conflicts but gained another.

The akpm tree lost its build failure.  Also, I dropped another patch
that turned up elsewhere.

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

We are up to 199 trees (counting Linus' and 27 trees of patches pending
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
Merging arm-current/fixes
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
CONFLICT (content): Merge conflict in arch/arm/mm/mmu.c
Merging arm-soc/for-next
CONFLICT (add/add): Merge conflict in Documentation/devicetree/bindings/arm=
/l2cc.txt
CONFLICT (delete/modify): arch/arm/mach-at91/board-usb-a9260.c deleted in a=
rm-soc/for-next and modified in HEAD. Version HEAD of arch/arm/mach-at91/bo=
ard-usb-a9260.c left in tree.
CONFLICT (content): Merge conflict in arch/arm/mach-msm/board-msm7x30.c
CONFLICT (content): Merge conflict in arch/arm/mach-msm/board-msm8x60.c
CONFLICT (content): Merge conflict in arch/arm/mach-mxs/include/mach/gpio.h
CONFLICT (delete/modify): arch/arm/mach-nuc93x/Makefile.boot deleted in arm=
-soc/for-next and modified in HEAD. Version HEAD of arch/arm/mach-nuc93x/Ma=
kefile.boot left in tree.
CONFLICT (content): Merge conflict in arch/arm/mach-u300/Makefile.boot
CONFLICT (content): Merge conflict in arch/arm/mm/cache-l2x0.c
CONFLICT (content): Merge conflict in arch/arm/mm/dma-mapping.c
CONFLICT (content): Merge conflict in arch/arm/plat-mxc/include/mach/gpio.h
$ git rm -f arch/arm/mach-at91/board-usb-a9260.c arch/arm/mach-nuc93x/Makef=
ile.boot
Applying: arm-soc: merge fixup for fixup/reserve being added to MACHINE des=
criptions
Merging at91/at91-next
Merging davinci/davinci-next
Merging i.MX/for-next
CONFLICT (content): Merge conflict in arch/arm/mach-imx/Makefile
Merging linux-spec/for-next
Merging omap/for-next
Merging pxa/for-next
Merging samsung/next-samsung
Merging s5p/for-next
CONFLICT (content): Merge conflict in drivers/gpio/Makefile
Merging tegra/for-next
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
Merging acpi/acpi
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
CONFLICT (content): Merge conflict in drivers/net/wireless/iwlwifi/iwl-scan=
.c
CONFLICT (content): Merge conflict in drivers/s390/cio/qdio_main.c
CONFLICT (content): Merge conflict in net/batman-adv/soft-interface.c
$ git rm -f arch/powerpc/configs/40x/hcu4_defconfig
Merging wireless/master
CONFLICT (content): Merge conflict in drivers/net/wireless/iwlwifi/iwl-pci.c
CONFLICT (content): Merge conflict in drivers/net/wireless/wl12xx/main.c
Merging bluetooth/master
CONFLICT (content): Merge conflict in net/bluetooth/hci_core.c
CONFLICT (content): Merge conflict in net/bluetooth/l2cap_core.c
CONFLICT (content): Merge conflict in net/bluetooth/mgmt.c
CONFLICT (content): Merge conflict in net/bluetooth/smp.c
Merging mtd/master
Merging l2-mtd/master
CONFLICT (content): Merge conflict in arch/arm/mach-at91/board-afeb-9260v1.c
CONFLICT (content): Merge conflict in arch/arm/mach-at91/board-neocore926.c
CONFLICT (content): Merge conflict in arch/arm/mach-at91/board-rm9200dk.c
CONFLICT (content): Merge conflict in arch/arm/mach-at91/board-sam9g20ek.c
CONFLICT (content): Merge conflict in arch/arm/mach-at91/board-sam9m10g45ek=
.c
CONFLICT (delete/modify): arch/arm/mach-at91/board-usb-a9260.c deleted in H=
EAD and modified in l2-mtd/master. Version l2-mtd/master of arch/arm/mach-a=
t91/board-usb-a9260.c left in tree.
$ git rm -f arch/arm/mach-at91/board-usb-a9260.c
Merging crypto/master
Merging sound/for-next
CONFLICT (content): Merge conflict in arch/mips/alchemy/devboards/db1x00/pl=
atform.c
CONFLICT (content): Merge conflict in sound/mips/Kconfig
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
CONFLICT (content): Merge conflict in drivers/mmc/core/core.c
CONFLICT (content): Merge conflict in drivers/mmc/core/sd.c
Merging kgdb/kgdb-next
Merging slab/for-next
Merging uclinux/for-next
Merging md/for-next
Merging mfd/for-next
CONFLICT (content): Merge conflict in arch/arm/mach-u300/include/mach/irqs.h
Merging hdlc/hdlc-next
Merging drm/drm-next
Merging fbdev/fbdev-next
CONFLICT (content): Merge conflict in drivers/video/Kconfig
Merging viafb/viafb-next
Merging omap_dss2/for-next
CONFLICT (content): Merge conflict in arch/arm/mach-omap2/board-4430sdp.c
CONFLICT (delete/modify): drivers/video/omap/lcd_apollon.c deleted in omap_=
dss2/for-next and modified in HEAD. Version HEAD of drivers/video/omap/lcd_=
apollon.c left in tree.
CONFLICT (delete/modify): drivers/video/omap/lcd_ldp.c deleted in omap_dss2=
/for-next and modified in HEAD. Version HEAD of drivers/video/omap/lcd_ldp.=
c left in tree.
CONFLICT (delete/modify): drivers/video/omap/lcd_overo.c deleted in omap_ds=
s2/for-next and modified in HEAD. Version HEAD of drivers/video/omap/lcd_ov=
ero.c left in tree.
$ git rm -f drivers/video/omap/lcd_apollon.c drivers/video/omap/lcd_ldp.c d=
rivers/video/omap/lcd_overo.c
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
CONFLICT (content): Merge conflict in Documentation/PCI/pci.txt
CONFLICT (delete/modify): arch/arm/mach-nuc93x/time.c deleted in HEAD and m=
odified in trivial/for-next. Version trivial/for-next of arch/arm/mach-nuc9=
3x/time.c left in tree.
CONFLICT (content): Merge conflict in drivers/net/Kconfig
$ git rm -f arch/arm/mach-nuc93x/time.c
Merging audit/for-next
Merging pm/linux-next
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/board-ap4evb.c
Merging apm/for-next
Merging fsnotify/for-next
Merging irda/for-next
Merging edac/linux_next
CONFLICT (content): Merge conflict in arch/x86/kernel/cpu/mcheck/mce.c
Merging edac-amd/for-next
Merging devicetree/devicetree/next
Merging spi/spi/next
Merging gpio/gpio/next
Merging tip/auto-latest
CONFLICT (content): Merge conflict in drivers/iommu/Makefile
Merging rcu/rcu/next
CONFLICT (content): Merge conflict in arch/x86/kernel/cpu/mcheck/mce.c
CONFLICT (content): Merge conflict in arch/x86/kernel/process_64.c
Merging kvm/kvm-updates/3.2
Merging oprofile/for-next
Merging ptrace/ptrace
Merging xen/upstream/xen
Merging xen-two/linux-next
CONFLICT (content): Merge conflict in arch/x86/xen/Kconfig
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
CONFLICT (content): Merge conflict in drivers/mfd/wm831x-spi.c
$ git reset --hard HEAD^
Merging refs/next/20110928/regmap
CONFLICT (content): Merge conflict in drivers/mfd/wm831x-spi.c
[master feb9ae8] Merge commit 'refs/next/20110928/regmap'
Merging driver-core/driver-core-next
CONFLICT (content): Merge conflict in arch/arm/plat-mxc/devices.c
Merging tty/tty-next
CONFLICT (content): Merge conflict in arch/powerpc/include/asm/udbg.h
CONFLICT (content): Merge conflict in arch/powerpc/kernel/udbg.c
CONFLICT (content): Merge conflict in drivers/tty/serial/8250.c
Merging usb/usb-next
Merging staging/staging-next
CONFLICT (content): Merge conflict in drivers/misc/altera-stapl/altera.c
CONFLICT (content): Merge conflict in drivers/staging/comedi/drivers/ni_lab=
pc.c
CONFLICT (delete/modify): drivers/staging/rtl8192e/r8192E_core.c deleted in=
 staging/staging-next and modified in HEAD. Version HEAD of drivers/staging=
/rtl8192e/r8192E_core.c left in tree.
CONFLICT (content): Merge conflict in drivers/staging/xgifb/XGI_main_26.c
$ git rm -f drivers/staging/rtl8192e/r8192E_core.c
Merging bkl-config/config
Merging tmem/tmem
Merging writeback/next
Merging arm-dt/devicetree/arm-next
Merging hwspinlock/linux-next
Merging moduleh/for-sfr
CONFLICT (content): Merge conflict in arch/arm/mach-bcmring/mm.c
CONFLICT (content): Merge conflict in drivers/media/dvb/frontends/dibx000_c=
ommon.c
CONFLICT (content): Merge conflict in drivers/misc/altera-stapl/altera.c
CONFLICT (content): Merge conflict in drivers/net/ethernet/oki-semi/pch_gbe=
/pch_gbe_main.c
CONFLICT (content): Merge conflict in drivers/scsi/libfc/fc_lport.c
CONFLICT (content): Merge conflict in drivers/staging/iio/accel/adis16220_c=
ore.c
CONFLICT (content): Merge conflict in include/linux/dmaengine.h
CONFLICT (content): Merge conflict in sound/soc/soc-io.c
Applying: drivers/md: change module.h -> export.h in persistent-data/dm-*
Applying: block/bsg-lib.c: change module.h -> export.h in power/common.c
Applying: drivers/base: change module.h -> export.h in power/common.c
Applying: wireless/ath6kl: use of module_param requires the inclusion of mo=
duleparam.h
Applying: rtlwifi: use of module_param requires the inclusion of modulepara=
m.h
Applying: mmc: using mopdule_param requires the inclusion of moduleparam.h
Applying: NFC: use of module facilities requires the inclusion of module.h
Applying: block/mtip32xx: include module.h for its utilities
Applying: x86, amd: include linux/elf.h since we use stuff from asm/elf.h
Applying: powerpc/powernv: include export.h in hvc_opal.h for THIS_MODULE
Applying: PM QoS: include export.h in qos.c for EXPORT_SYMBOL
Applying: net: Add export.h to nfc/nci/core.c
Applying: scsi: Add export.h to drivers/scsi/libsas/sas_host_smp.c
Applying: drivers/net: Add module.h to wireless/ath/ath6kl/sdio.c
Applying: drivers/bcma: driver_chipcommon_pmu.c needs export.h for EXPORT_S=
YMBOL
Applying: drivers/base: Add export.h to regmap/regcache.c
Applying: drivers/usb: Add module.h to dwc3/dwc3-omap.c
Applying: drivers/usb: Add module.h to dwc3/core.c
Applying: staging: fix implicit stat.h use in impedance-analyzer/ad5933.c
Applying: staging: add module.h to impedance-analyzer/ad5933.c
Applying: staging: fix implicit stat.h use in iio/adc/ad7280a.c
Applying: staging: add module.h to iio/adc/ad7280a.c
Applying: staging: Add export.h to rts5139/rts51x_scsi.c
Merging kvmtool/master
CONFLICT (content): Merge conflict in include/net/9p/9p.h
Merging scsi-post-merge/merge-base:master
$ git checkout akpm
Applying: include/linux/dmar.h: forward-declare struct acpi_dmar_header
Applying: arch/x86/kernel/cpu/perf_event_amd.c needs asm/apicdef.h
Applying: drivers/net/ethernet/i825xx/3c505.c: fix build with dynamic debug
Applying: drm: fix kconfig unmet dependency warning
Applying: net/netfilter/nf_conntrack_netlink.c: fix Oops on container destr=
oy
Applying: readlinkat: ensure we return ENOENT for the empty pathname for no=
rmal lookups
Applying: acerhdf: add support for Aspire 1410 BIOS v1.3314
Applying: arch/x86/platform/iris/iris.c: register a platform device and a p=
latform driver
Applying: hp_accel: Add a new PNP id
Applying: hp_accel: Add axis-mapping for HP ProBook / EliteBook
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
Applying: arch/arm/mach-ux500/mbox-db5500.c: world-writable sysfs fifo file
Applying: arm, exec: remove redundant set_fs(USER_DS)
Applying: audit: always follow va_copy() with va_end()
Applying: btrfs: don't dereference extent_mapping if NULL
Applying: drivers/edac/mpc85xx_edac.c: fix memory controller compatible for=
 edac
Applying: drivers/gpu/vga/vgaarb.c: add missing kfree
Applying: ia64, exec: remove redundant set_fs(USER_DS)
Applying: unicore32, exec: remove redundant set_fs(USER_DS)
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
Applying: drivers/scsi/osd/osd_uld.c: use ida_simple_get() to handle id
Applying: drivers/scsi/sg.c: convert to kstrtoul_from_user()
Applying: drivers/scsi/mpt2sas/mpt2sas_base.c: fix mismatch in mpt2sas_base=
_hard_reset_handler() mutex lock-unlock
Applying: drivers/message/fusion/mptbase.c: ensure NUL-termination of MptCa=
llbacksName elements
Applying: loop: prevent information leak after failed read
Applying: loop: cleanup set_status interface
Applying: loop-cleanup-set_status-interface-checkpatch-fixes
Applying: drivers/block/mtip32xx/mtip32xx.c needs compat.h
Applying: sparc, exec: remove redundant addr_limit assignment
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
Applying: mm: iov_iter: have iov_iter_advance() decrement nr_segs appropria=
tely
Applying: mm: neaten warn_alloc_failed
Applying: mm-neaten-warn_alloc_failed-fix
Applying: debug-pagealloc: add support for highmem pages
Applying: debug-pagealloc-add-support-for-highmem-pages-fix
Applying: kswapd: avoid unnecessary rebalance after an unsuccessful balanci=
ng
Applying: mm: add free_hot_cold_page_list() helper
Applying: mm/memblock.c: small function definition fixes
Applying: mm: compaction: compact unevictable pages
Applying: mm-compaction-compact-unevictable-pages-checkpatch-fixes
Applying: mm: compaction: accounting fix
Applying: kswapd: assign new_order and new_classzone_idx after wakeup in sl=
eeping
Applying: mm: fix page-faults detection in swap-token logic
Applying: mm/vmalloc.c: report more vmalloc failures
Applying: mm: add extra free kbytes tunable
Applying: mm-add-extra-free-kbytes-tunable-update
Applying: mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes
Applying: mm: thp: tail page refcounting fix
Applying: thp-tail-page-refcounting-fix-6
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
Applying: selinuxfs: remove custom hex_to_bin()
Applying: include/linux/security.h: fix security_inode_init_security() arg
Applying: hpet: factor timer allocate from open
Applying: alpha: wire up accept4 syscall
Applying: alpha: wire up sendmmsg syscall
Applying: intel_idle: fix API misuse
Applying: intel_idle: disable auto_demotion for hotplugged CPUs
Applying: cris: lower the printk level in cris serial driver
Applying: kprobes: silence DEBUG_STRICT_USER_COPY_CHECKS=3Dy warning
Applying: x86: implement strict user copy checks for x86_64
Applying: Consolidate CONFIG_DEBUG_STRICT_USER_COPY_CHECKS
Applying: consolidate-config_debug_strict_user_copy_checks-fix
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
Applying: dynamic_debug: consolidate repetitive struct _ddebug descriptor d=
efinitions
Applying: dynamic_debug: remove num_enabled accounting
Applying: dynamic_debug: use a single printk() to emit messages
Applying: dynamic_debug: fix undefined reference to `__netdev_printk'
Applying: printk: add module parameter ignore_loglevel to control ignore_lo=
glevel
Applying: printk: add ignore_loglevel as module parameter
Applying: printk: add console_suspend module parameter
Applying: printk: fix bounds checking for log_prefix
Applying: printk: remove bounds checking for log_prefix
Applying: treewide: use __printf not __attribute__((format(printf,...)))
Applying: treewide-use-__printf-not-__attribute__formatprintf-checkpatch-fi=
xes
Applying: fs/namei.c: remove unused getname_flags()
Applying: poll: add poll_requested_events() function
Applying: MAINTAINERS: add new entry for ideapad-laptop
Applying: video/backlight: remove obsolete cleanup for clientdata
Applying: backlight: fix broken regulator API usage in l4f00242t03
Applying: drivers/video/backlight/l4f00242t03.c: use gpio_request_one() to =
simplify error handling
Applying: leds: Renesas TPU LED driver
Applying: leds-renesas-tpu-led-driver-v2-fix
Applying: drivers/leds/led-triggers.c: fix memory leak
Applying: drivers/leds/leds-lm3530.c: remove obsolete cleanup for clientdata
Applying: drivers/leds/leds-renesas-tpu.c: update driver to use workqueue
Applying: drivers/leds/leds-renesas-tpu.c: move Renesas TPU LED driver plat=
form data
Applying: drivers/leds/leds-gpio.c: use gpio_get_value_cansleep() when init=
ializing
Applying: lib/kstrtox: common code between kstrto*() and simple_strto*() fu=
nctions
Applying: lib/spinlock_debug.c: print owner on spinlock lockup
Applying: lib/bitmap.c: quiet sparse noise about address space
Applying: lib-bitmapc-quiet-sparse-noise-about-address-space-fix
Applying: lib/percpu_counter.c: enclose hotplug only variables in hotplug i=
fdef
Applying: lib/idr.c: fix comment for ida_get_new_above()
Applying: llist: make all llist functions inline
Applying: llist: define macro to check NMI safe cmpxchg
Applying: llist: move cpu_relax after cmpxchg
Applying: llist: return whether list is empty before adding in llist_add
Applying: llist-return-whether-list-is-empty-before-adding-in-llist_add-fix
Applying: kernel/irq_work.c: use llist
Applying: kernel.h/checkpatch: mark strict_strto<foo> and simple_strto<foo>=
 as obsolete
Applying: lib/crc: add slice by 8 algorithm to crc32.c
Applying: lib-crc-add-slice-by-8-algorithm-to-crc32c-fix
Applying: epoll: fix spurious lockdep warnings
Applying: epoll: limit paths
Applying: init/do_mounts_rd.c: fix ramdisk identification for padded cramfs
Applying: oprofilefs: handle zero-length writes
Applying: drivers/rtc/class.c: convert idr to ida and use ida_simple_get()
Applying: rtc: add initial support for mcp7941x parts
Applying: drivers/rtc/rtc-mc13xxx.c: move probe and remove callbacks to .in=
it.text and .exit.text
Applying: minix: describe usage of different magic numbers
Applying: cgroups: more safe tasklist locking in cgroup_attach_proc
Applying: cgroups: don't attach task to subsystem if migration failed
Applying: memcg: rename mem variable to memcg
Applying: memcg: fix oom schedule_timeout()
Applying: memcg: replace ss->id_lock with a rwlock
Applying: memcg: do not expose uninitialized mem_cgroup_per_node to world
Applying: memcg: skip scanning active lists based on individual size
Applying: memcg-skip-scanning-active-lists-based-on-individual-size-fix
Applying: memcg: close race between charge and putback
Applying: memcg: Fix race condition in memcg_check_events() with this_cpu u=
sage
Applying: cpusets: avoid looping when storing to mems_allowed if one node r=
emains set
Applying: procfs: report EISDIR when reading sysctl dirs in proc
Applying: proc: fix races against execve() of /proc/PID/fd**
Applying: proc-fix-races-against-execve-of-proc-pid-fd-fix
Applying: proc: force dcache drop on unauthorized access
Applying: ipc-introduce-shm_rmid_forced-sysctl-testing
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
Applying: sysctl: add support for poll()
Applying: sysctl-add-support-for-poll-fix
Applying: sysctl: make CONFIG_SYSCTL_SYSCALL default to n
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
Applying: fs/direct-io.c: salcuate fs_count correctly in get_more_blocks()
Applying: dio: separate fields only used in the submission path from struct=
 dio
Applying: dio-separate-fields-only-used-in-the-submission-path-from-struct-=
dio-checkpatch-fixes
Applying: dio: fix a wrong comment
Applying: dio: rearrange fields in dio/dio_submit to avoid holes
Applying: dio: use a slab cache for struct dio
Applying: dio: separate map_bh from dio
Applying: dio: inline the complete submission path
Applying: dio-inline-the-complete-submission-path-v2-checkpatch-fixes
Applying: dio: merge direct_io_walker() into __blockdev_direct_IO()
Applying: dio-merge-direct_io_walker-into-__blockdev_direct_io-checkpatch-f=
ixes
Applying: dio: remove unnecessary dio argument from dio_pages_present()
Applying: dio: remove unused dio parameter from dio_bio_add_page()
Applying: vfs: cache request_queue in struct block_device
Applying: dio: optimize cache misses in the submission path
Applying: dio-optimize-cache-misses-in-the-submission-path-v2-checkpatch-fi=
xes
Applying: treewide-use-__printf-not-__attribute__formatprintf-fix
Applying: llist: using in_nmi requires including hardirq.h
Applying: dio: using prefetch requires including prefetch.h
Merging akpm

--Signature=_Thu__29_Sep_2011_16_57_30_+1000_yNxLepMX7JazDICl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOhBbaAAoJEDMEi1NhKgbsZt0IAJOJrDuPU6iZP+PGIJmPPprH
BpNc/Bu5QZbOlELfKsUq/n+nV6ljMR2Pt5cc4qLxAiwUjQIRCwRaqu5gvTg55D3K
cxAgvpwt15lo0YyquAegVsY4GrwfUXHu/C8QNjdR3XGDarmcsDxpNhAGmkhFBA2M
FVQXXOeGgEEiQVe2HoJ2WT1lKj1KCtzq3OtiIcSVKc3Q+yskZofzX3yV8rgTjY1s
pOV+dT3glSvUF6JxVLwcxtHiBe8eMx1N0RBLohmYcsKs0+Xie5HPFgi1d2Q+lOK+
o2oc5Sl0g00XDtZBxFFsP6u3NDBywnJx+o6RFn/X+PGJ6tT5NMuzWQsIBh6rNMc=
=4nRN
-----END PGP SIGNATURE-----

--Signature=_Thu__29_Sep_2011_16_57_30_+1000_yNxLepMX7JazDICl--

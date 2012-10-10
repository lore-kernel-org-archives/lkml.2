Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690Ab2JJFJQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 01:09:16 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:54796 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185Ab2JJFJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 01:09:12 -0400
Date: Wed, 10 Oct 2012 16:09:04 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <linux-next@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Oct 10
Message-Id: <20121010160904.e73f247f4c7034876bf5af30@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__10_Oct_2012_16_09_04_+1100_6rmZ04Notz8NEyaF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__10_Oct_2012_16_09_04_+1100_6rmZ04Notz8NEyaF
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Do not add stuff destined for v3.8 to your linux-next included branches
until after v3.7-rc1 is released.

Changes since 201201009:

New tree: lzo-update

Conflicts are migrating as trees are merged by Linus.

Linus' tree gained a build failure for which I reverted a commit.

The block tree gained a build failure for which I add a merge fix patch.

The tip tree gained conflicts against Linus' tree.

The kmemleak tree gained a conflict against Linus' tree.

The akpm tree lost lots of commits that turned up in Linus' tree.

----------------------------------------------------------------------------

I have created today's linux-next tree at
git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
(patches at http://www.kernel.org/pub/linux/kernel/next/ ).  If you
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
CONFIG_PROFILE_ALL_BRANCHES - this fails its final link) and i386, sparc,
sparc64 and arm defconfig. These builds also have
CONFIG_ENABLE_WARN_DEPRECATED, CONFIG_ENABLE_MUST_CHECK and
CONFIG_DEBUG_INFO disabled when necessary.

Below is a summary of the state of the merge.

We are up to 204 trees (counting Linus' and 26 trees of patches pending
for Linus' tree), more are welcome (even if they are currently empty).
Thanks to those who have contributed, and to those who haven't, please do.

Status of my local build tests will be at
http://kisskb.ellerman.id.au/linux-next .  If maintainers want to give
advice about cross compilers/configs that work, we are always open to add
more builds.

Thanks to Randy Dunlap for doing many randconfig builds.  And to Paul
Gortmaker for triage and bug fixes.

There is a wiki covering stuff to do with linux-next at
http://linux.f-seidel.de/linux-next/pmwiki/ .  Thanks to Frank Seidel.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

$ git checkout master
$ git reset --hard stable
Merging origin/master (547b1e8 Fix staging driver use of VM_RESERVED)
Merging fixes/master (9023a40 Merge tag 'mmc-fixes-for-3.5-rc4' of git://gi=
t.kernel.org/pub/scm/linux/kernel/git/cjb/mmc)
[master 92fbc9f] Revert "memory-hotplug: suppress "Trying to free nonexiste=
nt resource <XXXXXXXXXXXXXXXX-YYYYYYYYYYYYYYYY>" warning"
Merging kbuild-current/rc-fixes (b1e0d8b kbuild: Fix gcc -x syntax)
Merging arm-current/fixes (846a136 ARM: vfp: fix saving d16-d31 vfp registe=
rs on v6+ kernels)
Merging m68k-current/for-linus (f82735d m68k: Use PTR_RET rather than if(IS=
_ERR(...)) + PTR_ERR)
Merging powerpc-merge/merge (636802e powerpc: Don't use __put_user() in pat=
ch_instruction)
Merging sparc/master (9836d34 Merge tag 'disintegrate-sparc-20121009' of gi=
t://git.infradead.org/users/dhowells/linux-headers)
Merging net/master (5175a5e RDS: fix rds-ping spinlock recursion)
Merging sound-current/for-linus (5d037f9 Merge tag 'asoc-3.6' of git://git.=
kernel.org/pub/scm/linux/kernel/git/broonie/sound into for-linus)
Merging pci-current/for-linus (0ff9514 PCI: Don't print anything while deco=
ding is disabled)
Merging wireless/master (c3e7724 mac80211: use ieee80211_free_txskb to fix =
possible skb leaks)
Merging driver-core.current/driver-core-linus (5698bd7 Linux 3.6-rc6)
Merging tty.current/tty-linus (b70936d tty: serial: sccnxp: Fix bug with un=
terminated platform_id list)
Merging usb.current/usb-linus (ecefbd9 Merge tag 'kvm-3.7-1' of git://git.k=
ernel.org/pub/scm/virt/kvm/kvm)
Merging staging.current/staging-linus (5698bd7 Linux 3.6-rc6)
Merging char-misc.current/char-misc-linus (fea7a08 Linux 3.6-rc3)
Merging input-current/for-linus (dde3ada Merge branch 'next' into for-linus)
Merging md-current/for-linus (80b4812 md/raid10: fix "enough" function for =
detecting if array is failed.)
Merging audit-current/for-linus (c158a35 audit: no leading space in audit_l=
og_d_path prefix)
Merging crypto-current/master (c9f97a2 crypto: x86/glue_helper - fix storin=
g of new IV in CBC encryption)
Merging ide/master (9974e43 ide: fix generic_ide_suspend/resume Oops)
Merging dwmw2/master (244dc4e Merge git://git.infradead.org/users/dwmw2/ran=
dom-2.6)
Merging sh-current/sh-fixes-for-linus (4403310 SH: Convert out[bwl] macros =
to inline functions)
Merging irqdomain-current/irqdomain/merge (15e06bf irqdomain: Fix debugfs f=
ormatting)
Merging devicetree-current/devicetree/merge (4e8383b of: release node fix f=
or of_parse_phandle_with_args)
Merging spi-current/spi/merge (d1c185b of/spi: Fix SPI module loading by us=
ing proper "spi:" modalias prefixes.)
Merging gpio-current/gpio/merge (96b7064 gpio/tca6424: merge I2C transactio=
ns, remove cast)
Merging asm-generic/master (c37d615 Merge branch 'disintegrate-asm-generic'=
 of git://git.infradead.org/users/dhowells/linux-headers into asm-generic)
Merging arm/for-next (4231a1e Merge branch 'devel-stable' into for-next)
Merging arm-perf/for-next/perf (b90c4b9 Merge branch 'hw-breakpoint' into f=
or-next/perf)
CONFLICT (content): Merge conflict in arch/arm/mach-ux500/cpu-db8500.c
CONFLICT (modify/delete): arch/arm/mach-tegra/devices.c deleted in HEAD and=
 modified in arm-perf/for-next/perf. Version arm-perf/for-next/perf of arch=
/arm/mach-tegra/devices.c left in tree.
CONFLICT (content): Merge conflict in arch/arm/mach-omap2/devices.c
CONFLICT (modify/delete): arch/arm/mach-bcmring/arch.c deleted in HEAD and =
modified in arm-perf/for-next/perf. Version arm-perf/for-next/perf of arch/=
arm/mach-bcmring/arch.c left in tree.
CONFLICT (content): Merge conflict in arch/arm/kernel/hw_breakpoint.c
$ git rm -f arch/arm/mach-tegra/devices.c arch/arm/mach-bcmring/arch.c
Merging davinci/davinci-next (fe0d422 Linux 3.0-rc6)
Merging xilinx/arm-next (b85a3ef ARM: Xilinx: Adding Xilinx board support)
Merging arm64/upstream (6916fd0 arm64: Enable interrupts before calling do_=
notify_resume())
Merging blackfin/for-linus (9f57151 Merge tag 'disintegrate-blackfin-201210=
09' into for-linus)
Merging c6x/for-linux-next (fbdd63d UAPI: (Scripted) Disintegrate arch/c6x/=
include/asm)
Merging cris/for-next (d75d806 CRIS: Remove VCS simulator specific code)
Merging hexagon/linux-next (5042ab9 various Kconfig cleanup and old platfor=
m build code removal)
Merging ia64/next (f68301f UAPI: (Scripted) Disintegrate arch/ia64/include/=
asm)
CONFLICT (content): Merge conflict in arch/ia64/include/asm/Kbuild
Merging m68k/for-next (f82735d m68k: Use PTR_RET rather than if(IS_ERR(...)=
) + PTR_ERR)
Merging m68knommu/for-next (a255172 m68knommu: fix inconsistent formating i=
n ColdFire 5407 definitions)
Merging microblaze/next (1883baa UAPI: (Scripted) Disintegrate arch/microbl=
aze/include/asm)
Merging mips/mips-for-linux-next (0f96572 Merge tag 'disintegrate-mips-2012=
1009' of git://git.infradead.org/users/dhowells/linux-headers into mips-for=
-linux-next)
Merging openrisc/for-upstream (4c8faa4 openrisc: mask interrupts in irq_mas=
k_ack function)
Merging parisc/for-next (5b24c42 [PARISC] fix personality flag check in cop=
y_thread())
Merging s390/features (ab08ff3 Merge tag 'disintegrate-s390-20121009' of gi=
t://git.infradead.org/users/dhowells/linux-headers)
Merging sh/sh-latest (16d74eb sh: pfc: Fix up GPIO mux type reconfig case.)
Merging sparc-next/master (7fe0b14 Merge tag 'spi-3.7' of git://git.kernel.=
org/pub/scm/linux/kernel/git/broonie/misc)
Merging tile/master (e70cf54 tile: gxio iorpc numbering change for TRIO int=
erface)
Merging unicore32/unicore32 (e4baa56 UniCore32-bugfix: Remove definitions i=
n asm/bug.h to solve difference between native and cross compiler)
Merging xtensa/for_next (ded389d xtensa: Add missing RCU idle APIs on idle =
loop)
CONFLICT (content): Merge conflict in scripts/mod/modpost.c
CONFLICT (content): Merge conflict in arch/xtensa/boot/boot-elf/Makefile
Merging btrfs/next (f46dbe3 btrfs: init ref_index to zero in add_inode_ref)
Merging ceph/master (6285bc2 ceph: avoid 32-bit page index overflow)
Merging cifs/for-next (72bd481 cifs: reinstate the forcegid option)
Merging configfs/linux-next (b930c26 Merge branch 'for-linus' of git://git.=
kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (0d7614f Linux 3.6-rc1)
Merging ext3/for_next (6c29c50 quota: Silence warning about PRJQUOTA not be=
ing handled in need_print_warning())
Merging ext4/dev (c278531 ext4: fix ext4_flush_completed_IO wait semantics)
Merging fuse/for-next (c7a3f5e fuse: Move CUSE Kconfig entry from fs/Kconfi=
g into fs/fuse/Kconfig)
Merging gfs2/master (ecefbd9 Merge tag 'kvm-3.7-1' of git://git.kernel.org/=
pub/scm/virt/kvm/kvm)
Merging jfs/jfs-next (84f4141 jfs: Fix do_div precision in commit b40c2e66)
Merging logfs/master (ab2ec19 logfs: fix possible memory leak in logfs_mtd_=
can_write_buf())
Merging nfs/linux-next (af28388 pnfsblock: cleanup nfs4_blkdev_get)
Merging nfsd/nfsd-next (0d22f68 nfsd4: don't allow reclaims of expired clie=
nts)
Merging ocfs2/linux-next (4538df6 ocfs2: Don't spam on -EDQUOT.)
Merging omfs/for-next (976d167 Linux 3.1-rc9)
Merging squashfs/master (4b0180a Squashfs: add mount time sanity check for =
block_size and block_log match)
Merging v9fs/for-next (552aad0 9P: Fix race between p9_write_work() and p9_=
fd_request())
Merging ubifs/linux-next (3668b70 UBIFS: print less)
Merging xfs/for-next (2ea0392 xfs: Make inode32 a remountable option)
Merging vfs/for-next (2bd2c19 MAX_LFS_FILESIZE should be a loff_t)
Merging pci/next (78c8f84 Merge branch 'pci/yinghai-misc' into next)
Merging powerpc/next (d900bd7 powerpc/iommu: Fix multiple issues with IOMMU=
 pools code)
Merging 4xx/next (2074b1d powerpc: Fix irq distribution)
Merging mpc5xxx/next (f3ac712 powerpc/pcm030: add pcm030-audio-fabric to dt=
s)
Merging galak/next (10bfa76 driver/mtd:IFC NAND:Initialise internal SRAM be=
fore any write)
Merging hid/for-next (0b82411 Merge branch 'hidraw' into for-next)
CONFLICT (content): Merge conflict in drivers/hid/hid-multitouch.c
Merging quilt/i2c (d43b716 Merge branch 'rc-fixes' of git://git.kernel.org/=
pub/scm/linux/kernel/git/mmarek/kbuild)
Merging i2c-embedded/i2c-embedded/for-next (62885f5 MXS: Implement DMA supp=
ort into mxs-i2c)
CONFLICT (content): Merge conflict in drivers/i2c/busses/i2c-omap.c
Merging quilt/jdelvare-hwmon (e086be6 hwmon: Drop needless includes of <lin=
ux/delay.h>)
Merging hwmon-staging/hwmon-next (967d7fe hwmon: (ads7828) driver cleanup)
Merging v4l-dvb/master (7da79d8 Merge /home/v4l/v4l/patchwork)
CONFLICT (content): Merge conflict in arch/arm/mach-davinci/include/mach/da=
8xx.h
Merging kbuild/for-next (f1748a9 Merge branch 'kbuild/rc-fixes' into kbuild=
/for-next)
Merging kconfig/for-next (4eae518 localmodconfig: Fix localyesconfig to set=
 to 'y' not 'm')
Merging libata/NEXT (13b7408 sata_mv: Fix warnings when no PCI)
Merging infiniband/for-next (56040f0 Merge branches 'cma', 'ipoib', 'iser',=
 'mlx4' and 'nes' into for-next)
Merging pstore/master (80c9d03 pstore: Avoid recursive spinlocks in the oop=
s_in_progress case)
Merging acpi/next (d1d4a81 Merge branches 'fixes-for-37', 'ec' and 'thermal=
' into release)
Merging cpuidle/cpuidle-next (3cf7997 acpi: intel_idle : break dependency b=
etween modules)
CONFLICT (content): Merge conflict in include/linux/cpuidle.h
CONFLICT (add/add): Merge conflict in drivers/cpuidle/coupled.c
Merging cpupowerutils/master (f166033 cpupower tools: add install target to=
 the debug tools' makefiles)
Merging thermal/next (f5a246e Merge tag 'sound-3.7' of git://git.kernel.org=
/pub/scm/linux/kernel/git/tiwai/sound)
Applying: thermal: fix for for MAX_ID_MASK to MAX_IDR_MASK rename
Merging ieee1394/for-next (790198f firewire: cdev: fix user memory corrupti=
on (i386 userland on amd64 kernel))
Merging ubi/linux-next (76ac66e UBI: Wire-up fastmap)
Merging dlm/next (2b75bc9 dlm: check the maximum size of a request from use=
r)
Merging scsi/for-next (5c1b10a [SCSI] storvsc: Account for in-transit packe=
ts in the RESET path)
Merging target-updates/for-next (cf0eb28 iscsi-target: Bump defaults for no=
pin_timeout + nopin_response_timeout values)
Merging target-merge/for-next-merge (d987569 Linux 3.6-rc2)
Merging ibft/linux-next (935a9fe ibft: Fix finding IBFT ACPI table on UEFI)
Merging isci/all (6734092 isci: add a couple __iomem annotations)
Merging slave-dma/next (d0fc905 dma: tegra: fix interrupt name issue with a=
pb dma.)
CONFLICT (content): Merge conflict in drivers/spi/spi-davinci.c
CONFLICT (content): Merge conflict in drivers/mmc/host/davinci_mmc.c
CONFLICT (content): Merge conflict in drivers/dma/mmp_tdma.c
Applying: DMA: PL330: Fix build error (on linux-next-20120924)
Merging dmaengine/next (a2bd114 netdma: adding alignment check for NETDMA o=
ps)
Merging net-next/master (7fe0b14 Merge tag 'spi-3.7' of git://git.kernel.or=
g/pub/scm/linux/kernel/git/broonie/misc)
Merging wireless-next/master (5160b46 ath9k: Fix BTCOEX weight initializati=
on)
Merging bluetooth/master (23d3a86 Bluetooth: don't attempt to free a channe=
l that wasn't created)
Merging mtd/master (f5cf8f0 mtd: Disable mtdchar mmap on MMU systems)
Merging l2-mtd/master (35c241d mtd: onenand: Make flexonenand_set_boundary =
static)
Merging crypto/master (c9f97a2 crypto: x86/glue_helper - fix storing of new=
 IV in CBC encryption)
Merging drm/drm-next (1f31c69 Merge branch 'drm-intel-fixes' of git://peopl=
e.freedesktop.org/~danvet/drm-intel into drm-next)
Merging sound/for-next (8d032a8 ALSA: hda - remove "Mic Jack Mode" for head=
set jacks (Latitude Exx30))
Merging sound-asoc/for-next (961a7ae ASoC: dmaengine: Correct Makefile when=
 sound is built as module)
Merging modules/modules-next (3a7989c X.509: Fix indefinite length element =
skip error handling)
CONFLICT (content): Merge conflict in lib/Makefile
CONFLICT (content): Merge conflict in init/Kconfig
CONFLICT (content): Merge conflict in arch/xtensa/Kconfig
CONFLICT (content): Merge conflict in arch/x86/um/Kconfig
CONFLICT (content): Merge conflict in arch/x86/Kconfig
CONFLICT (content): Merge conflict in arch/m32r/include/asm/Kbuild
CONFLICT (content): Merge conflict in arch/h8300/include/asm/Kbuild
CONFLICT (content): Merge conflict in arch/cris/include/asm/Kbuild
CONFLICT (content): Merge conflict in arch/Kconfig
CONFLICT (content): Merge conflict in Makefile
Merging virtio/virtio-next (d43b716 Merge branch 'rc-fixes' of git://git.ke=
rnel.org/pub/scm/linux/kernel/git/mmarek/kbuild)
Merging input/next (7f8d4ca Input: extend the number of event (and other) d=
evices)
Merging input-mt/for-next (51c80b7 Input: bcm5974 - Convert to MT-B)
Merging cgroup/for-next (c0a93e2 Merge branch 'for-3.7-hierarchy' into for-=
next)
Merging block/for-next (454832b Merge branch 'for-3.7/drivers' into for-nex=
t)
CONFLICT (content): Merge conflict in init/Kconfig
Applying: fs/block_dev.c:set_blocksize(): use mapping_mapped()
Merging quilt/device-mapper (24d047b Use the recently-added bio front_pad f=
ield to allocate struct dm_target_io.)
CONFLICT (content): Merge conflict in drivers/md/dm.c
CONFLICT (content): Merge conflict in drivers/md/dm-thin.c
Merging embedded/master (4744b43 embedded: fix vc_translate operator preced=
ence)
Merging firmware/master (6e03a20 firmware: speed up request_firmware(), v3)
Merging pcmcia/master (80af9e6 pcmcia at91_cf: fix raw gpio number usage)
Merging mmc/mmc-next (a1487fb mmc: rtsx_pci_sdmmc: Add realtek pcie sdmmc h=
ost driver)
CONFLICT (content): Merge conflict in drivers/mmc/host/omap.c
CONFLICT (content): Merge conflict in drivers/mmc/host/davinci_mmc.c
Merging kgdb/kgdb-next (08f9553 tty/console: fix warnings in drivers/tty/se=
rial/kgdboc.c)
Merging slab/for-next (e2087be Merge branch 'slab/tracing' into slab/for-li=
nus)
Merging uclinux/for-next (a0d271c Linux 3.6)
Merging md/for-next (c0c6d3f md: writing to sync_action should clear the re=
ad-auto state.)
CONFLICT (content): Merge conflict in fs/bio.c
CONFLICT (content): Merge conflict in drivers/md/raid0.c
Merging mfd/for-next (74d8378 ARM: dts: Enable 88pm860x pmic)
Merging battery/master (18766f0 Merge with upstream to accommodate with MFD=
 changes)
Merging fbdev/fbdev-next (ebe9f7b video: exynos_mipi_dsi: Remove unnecessar=
y NULL check)
CONFLICT (content): Merge conflict in drivers/video/msm/mdp_hw.h
CONFLICT (content): Merge conflict in drivers/video/msm/mdp.c
CONFLICT (content): Merge conflict in drivers/video/msm/mddi.c
CONFLICT (modify/delete): drivers/video/epson1355fb.c deleted in HEAD and m=
odified in fbdev/fbdev-next. Version fbdev/fbdev-next of drivers/video/epso=
n1355fb.c left in tree.
CONFLICT (content): Merge conflict in arch/arm/mach-s3c64xx/mach-real6410.c
CONFLICT (content): Merge conflict in arch/arm/mach-s3c64xx/mach-mini6410.c
$ git rm -f drivers/video/epson1355fb.c
Merging viafb/viafb-next (838ac78 viafb: avoid refresh and mode lookup in s=
et_par)
Merging omap_dss2/for-next (13b1ba7 OMAPDSS: add missing include for string=
.h)
CONFLICT (content): Merge conflict in drivers/video/omap2/dss/dispc.c
CONFLICT (content): Merge conflict in drivers/video/omap2/displays/panel-ta=
al.c
CONFLICT (content): Merge conflict in drivers/video/omap/lcd_ams_delta.c
Merging regulator/for-next (6a2027a Merge remote-tracking branches 'regulat=
or/topic/core', 'regulator/topic/bypass', 'regulator/topic/tol', 'regulator=
/topic/drivers' and 'regulator/topic/tps6586x' into regulator-next)
Merging security/next (bf53083 Merge tag 'v3.6-rc7' into next)
Merging selinux/master (c2d7b24 Merge tag 'v3.4' into 20120409)
Merging lblnet/master (7e27d6e Linux 2.6.35-rc3)
Merging watchdog/master (58ddfed Merge branch 'master' of ../linux-watchdog)
Merging dwmw2-iommu/master (c3b92c8 Linux 3.1)
Merging iommu/next (0094872 Merge branches 'dma-debug', 'iommu/fixes', 'arm=
/tegra', 'arm/exynos', 'x86/amd', 'x86/vt-d' and 'x86/amd-irq-remapping' in=
to next)
Merging vfio/next (f448d31 vfio: Fix PCI INTx disable consistency)
Merging osd/linux-next (7f8d145 pnfs_osd_xdr: Remove unused #include from p=
nfs_osd_xdr.h)
Merging jc_docs/docs-next (5c050fb docs: update the development process doc=
ument)
Merging trivial/for-next (9c33c51 doc: fix old config name of kprobetrace)
Merging audit/for-next (dcd6c92 Linux 3.3-rc1)
Merging pm/linux-next (df5a2a1 Merge tag 'firewire-updates' of git://git.ke=
rnel.org/pub/scm/linux/kernel/git/ieee1394/linux1394)
Merging apm/for-next (fb9d78a Merge branch 'for-linus' of git://git.kernel.=
org/pub/scm/linux/kernel/git/jikos/apm)
Merging fsnotify/for-next (1aec9c0 inotify: automatically restart syscalls)
CONFLICT (content): Merge conflict in kernel/audit_tree.c
Merging edac/linux_next (cfe5031 edac: edac_mc no longer deals with kobject=
s directly)
Merging edac-amd/for-next (305f1c3 Merge branch '3.3-pci_device_id' into ed=
ac-for-next)
CONFLICT (content): Merge conflict in drivers/edac/amd64_edac.c
CONFLICT (content): Merge conflict in Documentation/edac.txt
Merging devicetree/devicetree/next (efd68e7 devicetree: add helper inline f=
or retrieving a node's full name)
Merging dt-rh/for-next (36165f5 MAINTAINERS: add scripts/dtc under Devicetr=
ee maintainers)
Merging spi/spi/next (d8e328b spi: Add "spi:" prefix to modalias attribute =
of spi devices)
Merging spi-mb/spi-next (43e37b0 spi: tsc2005: delete soon-obsolete e-mail =
address)
Merging tip/auto-latest (6b90cb2 Merge branch 'sched/urgent')
CONFLICT (content): Merge conflict in mm/mempolicy.c
CONFLICT (content): Merge conflict in mm/huge_memory.c
Merging rcu/rcu/next (a4fbe35 rcu: Grace-period initialization excludes onl=
y RCU notifier)
Merging cputime/cputime (c3e0ef9 [S390] fix cputime overflow in uptime_proc=
_show)
Merging uprobes/for-next (0326f5a uprobes/core: Handle breakpoint and singl=
estep exceptions)
Merging kmemleak/kmemleak (4878677 kmemleak: do not leak object after tree =
insertion error)
CONFLICT (content): Merge conflict in mm/kmemleak.c
Merging kvm/linux-next (ecefbd9 Merge tag 'kvm-3.7-1' of git://git.kernel.o=
rg/pub/scm/virt/kvm/kvm)
Merging kvm-ppc/kvm-ppc-next (2c4eb8b KVM: PPC: Move mtspr/mfspr emulation =
into own functions)
Merging oprofile/for-next (61bccf1 oprofile: Remove 'WQ on CPUx, prefer CPU=
y' warning)
Merging xen/upstream/xen (af3a3ab Merge git://git.kernel.org/pub/scm/linux/=
kernel/git/steve/gfs2-3.0-fixes)
Merging xen-two/linux-next (8825f04 Merge branch 'stable/for-linus-3.7' int=
o linux-next)
Applying: The Xen tree tries to add a line to arch/arm/mach-vexpress/Makefi=
le.boot that has been removed by the following commit in Linus' master:
Merging xen-pvhvm/linux-next (b056b6a xen: suspend: remove xen_hvm_suspend)
Merging percpu/for-next (61011677 Merge tag 'dlm-3.5' of git://git.kernel.o=
rg/pub/scm/linux/kernel/git/teigland/linux-dlm)
Merging workqueues/for-next (2b0f620 Merge branch 'for-3.7' into for-next)
Merging drivers-x86/linux-next (455f38c eeepc-laptop: fix device reference =
count leakage in eeepc_rfkill_hotplug())
Merging hwpoison/hwpoison (46e387b Merge branch 'hwpoison-hugepages' into h=
wpoison)
Merging sysctl/master (4e474a0 sysctl: protect poll() in entries that may g=
o away)
Merging regmap/for-next (613dac3 Merge remote-tracking branches 'regmap/top=
ic/cache' and 'regmap/topic/irq' into regmap-next)
Merging hsi/for-next (43139a6 HSI: hsi_char: Update ioctl-number.txt)
Merging leds/for-next (2f73c39 leds: add output driver configuration for pc=
a9633 led driver)
Merging driver-core/driver-core-next (e0f21e6 memory: tegra{20,30}-mc: Fix =
reading incorrect register in mc_readl())
Merging tty/tty-next (ecefbd9 Merge tag 'kvm-3.7-1' of git://git.kernel.org=
/pub/scm/virt/kvm/kvm)
Merging usb/usb-next (ecefbd9 Merge tag 'kvm-3.7-1' of git://git.kernel.org=
/pub/scm/virt/kvm/kvm)
Merging staging/staging-next (e187895 staging: comedi: jr3_pci: fix iomem d=
ereference)
Merging char-misc/char-misc-next (5dc2db0 drivers/misc/lis3lv02d/lis3lv02d_=
i2c.c: add lis3lv02d device tree init)
Merging tmem/linux-next (a728d5e Merge commit 'v3.6-rc6' into linux-next)
Merging writeback/writeback-for-next (2f60d62 CPU hotplug, writeback: Don't=
 call writeback_set_ratelimit() too often during hotplug)
Merging arm-dt/devicetree/arm-next (ede338f dt: add documentation of ARM dt=
 boot interface)
Merging hwspinlock/linux-next (8b37fcf hwspinlock: add MAINTAINERS entries)
Merging pinctrl/for-next (e1b2dc7 pinctrl: add bcm2835 driver)
Merging vhost/linux-next (e0953c8 tun: experimental zero copy tx support)
CONFLICT (content): Merge conflict in drivers/net/tun.c
Merging memblock/memblock-kill-early_node_map (7bd0b0f memblock: Reimplemen=
t memblock allocation using reverse free area iterator)
Merging remoteproc/for-next (ed26d19 remoteproc: fix (again) the virtio-rel=
ated build breakage)
Merging irqdomain/irqdomain/next (f5a1ad0 irqdomain: Improve diagnostics wh=
en a domain mapping fails)
Merging gpio/gpio/next (ddf343f Merge branch 'for-linus' of git://git.kerne=
l.org/pub/scm/linux/kernel/git/s390/linux)
Merging gpio-lw/for-next (901acf5 gpio: pcf857x: select IRQ_DOMAIN)
Merging arm-soc/for-next (ab3ee84 Merge branch 'fixes' into for-next)
Merging ep93xx/ep93xx-for-next (70f0f7c Merge branch 'ep93xx-fixes' into ep=
93xx-for-next)
Merging ixp4xx/next (2346020 IXP4xx: map CPU config registers within VMALLO=
C region.)
CONFLICT (content): Merge conflict in arch/arm/mach-ixp4xx/include/mach/ixp=
4xx-regs.h
CONFLICT (content): Merge conflict in arch/arm/mach-ixp4xx/common.c
Merging msm/for-next (a0d271c Linux 3.6)
Merging renesas/next (b681273 Merge branch 'heads/boards' into next)
CONFLICT (content): Merge conflict in arch/arm/Kconfig
Merging samsung/for-next (59e65fd Merge branch 'next/dt-samsung-new' into f=
or-next)
CONFLICT (content): Merge conflict in arch/arm/mach-exynos/clock-exynos5.c
Merging tegra/for-next (979570e Linux 3.6-rc7)
Merging kvmtool/master (5fd2a45 kvm tools: Drop lchown() calls from 9p)
Merging dma-mapping/dma-mapping-next (461b6f0 Merge branch 'next-cleanup' i=
nto for-v3.7)
Merging pwm/for-next (85f8879 pwm: dt: Fix description of second PWM cell)
Merging dma-buf/for-next (ba42051 dma-buf: might_sleep() in dma_buf_unmap_a=
ttachment())
Merging userns/for-next (f3d94c2 userns: Fix posix_acl_file_xattr_userns gi=
d conversion)
Merging ktest/for-next (95f5783 ktest: Fix ELSE IF statements)
Merging signal/for-next (12f79be alpha: don't open-code trace_report_syscal=
l_{enter,exit})
CONFLICT (content): Merge conflict in fs/exec.c
CONFLICT (content): Merge conflict in arch/xtensa/include/asm/Kbuild
CONFLICT (content): Merge conflict in arch/x86/kernel/signal.c
CONFLICT (content): Merge conflict in arch/x86/kernel/process_32.c
CONFLICT (content): Merge conflict in arch/x86/Kconfig
CONFLICT (content): Merge conflict in arch/um/kernel/exec.c
CONFLICT (content): Merge conflict in arch/s390/Kconfig
CONFLICT (content): Merge conflict in arch/powerpc/Kconfig
CONFLICT (content): Merge conflict in arch/mn10300/include/asm/Kbuild
CONFLICT (content): Merge conflict in arch/mn10300/Kconfig
CONFLICT (content): Merge conflict in arch/microblaze/include/asm/Kbuild
CONFLICT (content): Merge conflict in arch/m68k/Kconfig
CONFLICT (content): Merge conflict in arch/m32r/include/asm/Kbuild
CONFLICT (content): Merge conflict in arch/ia64/include/asm/Kbuild
CONFLICT (content): Merge conflict in arch/h8300/include/asm/Kbuild
CONFLICT (content): Merge conflict in arch/frv/include/asm/Kbuild
CONFLICT (content): Merge conflict in arch/cris/include/asm/Kbuild
CONFLICT (content): Merge conflict in arch/c6x/Kconfig
CONFLICT (content): Merge conflict in arch/avr32/include/asm/Kbuild
CONFLICT (content): Merge conflict in arch/arm/include/asm/thread_info.h
CONFLICT (content): Merge conflict in arch/arm/Kconfig
CONFLICT (content): Merge conflict in arch/alpha/Kconfig
Merging clk/clk-next (494bfec clk: add of_clk_src_onecell_get() support)
Merging random/dev (d2e7c96 random: mix in architectural randomness in extr=
act_buf())
Merging lzo-update/lzo-update (5f70278 lib/lzo: Optimize code for CPUs with=
 inefficient unaligned access)
Merging scsi-post-merge/merge-base:master ()
$ git checkout akpm
Applying: CRIS: Fix I/O macros
Applying: selinux: fix sel_netnode_insert() suspicious rcu dereference
Applying: vfs: d_obtain_alias() needs to use "/" as default name.
Applying: x86 cpu_hotplug: unmap cpu2node when the cpu is hotremoved
Applying: cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved-fix
Applying: acpi_memhotplug.c: fix memory leak when memory device is unbound =
from the module acpi_memhotplug
Applying: acpi_memhotplug.c: free memory device if acpi_memory_enable_devic=
e() failed
Applying: acpi_memhotplug.c: remove memory info from list before freeing it
Applying: acpi_memhotplug.c: don't allow to eject the memory device if it i=
s being used
Applying: acpi_memhotplug.c: bind the memory device when the driver is bein=
g loaded
Applying: acpi_memhotplug.c: auto bind the memory device which is hotplugge=
d before the driver is loaded
Applying: arch/x86/platform/iris/iris.c: register a platform device and a p=
latform driver
Applying: x86 numa: don't check if node is NUMA_NO_NODE
Applying: arch/x86/tools/insn_sanity.c: identify source of messages
Applying: arch/x86/platform/uv: fix incorrect tlb flush all issue
Applying: fs/debugsfs: remove unnecessary inode->i_private initialization
Applying: pcmcia: move unbind/rebind into dev_pm_ops.complete
Applying: drm/i915: optimize DIV_ROUND_CLOSEST() call
Applying: timeconst.pl: remove deprecated defined(@array)
Applying: time: don't inline EXPORT_SYMBOL functions
Applying: compiler-gcc4.h: correct verion check for __compiletime_error
Applying: h8300: select generic atomic64_t support
CONFLICT (content): Merge conflict in arch/h8300/Kconfig
Applying: cciss: cleanup bitops usage
Applying: cciss: use check_signature()
Applying: block: store partition_meta_info.uuid as a string
Applying: init: reduce PARTUUID min length to 1 from 36
Applying: block: partition: msdos: provide UUIDs for partitions
Applying: drbd: use copy_highpage
Applying: vfs: increment iversion when a file is truncated
Applying: fs: change return values from -EACCES to -EPERM
Applying: fs/block_dev.c: no need to check inode->i_bdev in bd_forget()
Applying: mm/page_alloc.c: remove duplicate check
Applying: swap: add a simple detector for inappropriate swapin readahead
Applying: swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix
Applying: mm/memblock: reduce overhead in binary search
Applying: KSM: numa awareness sysfs knob
Applying: score: select generic atomic64_t support
Applying: pwm_backlight: add device tree support for Low Threshold Brightne=
ss
Applying: pwm_backlight-add-device-tree-support-for-low-threshold-brightnes=
s-fix
Applying: drivers/firmware/dmi_scan.c: check dmi version when get system uu=
id
Applying: drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid=
-fix
Applying: drivers/firmware/dmi_scan.c: fetch dmi version from SMBIOS if it =
exists
Applying: drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-ex=
ists-checkpatch-fixes
Applying: hfsplus: add on-disk layout declarations related to attributes tr=
ee
Applying: hfsplus: add functionality of manipulating by records in attribut=
es tree
Applying: hfsplus: rework functionality of getting, setting and deleting of=
 extended attributes
Applying: hfsplus: add support of manipulation by attributes file
Applying: hfsplus-add-support-of-manipulation-by-attributes-file-checkpatch=
-fixes
Applying: hfsplus: code style fixes - reworked support of extended attribut=
es
Applying: ipc/sem.c: alternatives to preempt_disable()
Merging akpm/master (1091262 ipc/sem.c: alternatives to preempt_disable())

--Signature=_Wed__10_Oct_2012_16_09_04_+1100_6rmZ04Notz8NEyaF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQdQLwAAoJEECxmPOUX5FEkKkP/2E8c5LJ++3XF9Rb+OiwyQ8S
n4/QeR3MONhVgDD//1SEGCOi+0N+fKwYdZ++LR8wtLWMdYOXQsiJsXajTIHOuSDW
61n1E5K1HMClOuL0EX5kDOsa0yRwUQm2BSDEvcysmlvrsDjpTw3ONRtWOaYkDa4X
Icdv0zpEo3I1MmPye/6IMTEHgvTRVyi0/lGZU1ZEdJxhf5GaOceeq1ekn/nzjZP6
jVMKQV6MIlzNhPAkOak245NLiPa6R8TkljE1JNnGery23/ADYHM3/Zy/aZcSOTOu
H5LywE9gJORzwYNVVIYkwKDm/c2zCIZ2A/CkFQP+tpxEFyfJV5TYiDnntcbl7jxA
3WdG830Ra7PA23TRq6Hh3Sgzy7tb+A0e97FEZW6Vhp1lRvwS3d23IXZIpXWC/Q3c
pqegAr9K1N36yBSILIwbYWOiQDti5DAWHrOHNxSzrf5XPht61jJpOkDOliDRIrL2
o70cTn3sNfNAAymKiN+0ee0u6sNbFYarDsHAJPJYsqpKK6DNybLrTNnx/EahGhDg
ZlXSLarFbpSZw0lc3FoZMspTi40GzE9acjxhPO3gIIbS7gcvrCB+GnaGePRCndGh
tZcfsIXYbEaH9LCMMqKSFJXCR42zspHnQytZdKDkTpo2zUovkjU5NJ0gQxwdkF1f
9P27rVqsXg7JYDRgrKoW
=wXjx
-----END PGP SIGNATURE-----

--Signature=_Wed__10_Oct_2012_16_09_04_+1100_6rmZ04Notz8NEyaF--

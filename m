Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932119Ab2JCHaY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 03:30:24 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:47595 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932087Ab2JCHaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 03:30:17 -0400
Date: Wed, 3 Oct 2012 17:30:07 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Oct 3
Message-Id: <20121003173007.c322d79c31676b9494a6bfd5@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__3_Oct_2012_17_30_07_+1000_5F4qj=b/O36OknE."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__3_Oct_2012_17_30_07_+1000_5F4qj=b/O36OknE.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Do not add stuff destined for v3.8 to your linux-next included branches
until after v3.7-rc1 is released.

Changes since 201201002:

Removed tree: rr
New trees: modules and virtio (replacing rr)

Conflicts are migrating as trees are merged by Linus.

The nfs tree lost its build failure.

The ubi tree gained a build failure so I used the version from
next-20121002.

The mfd tree gained a conflict against Linus' tree.

The battery tree gained a conflict against the mfd tree.

The xen-two tree lost its build failure.

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

We are up to 202 trees (counting Linus' and 26 trees of patches pending
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
Merging origin/master (7fe0b14 Merge tag 'spi-3.7' of git://git.kernel.org/=
pub/scm/linux/kernel/git/broonie/misc)
Merging fixes/master (9023a40 Merge tag 'mmc-fixes-for-3.5-rc4' of git://gi=
t.kernel.org/pub/scm/linux/kernel/git/cjb/mmc)
Merging kbuild-current/rc-fixes (fe04ddf kbuild: Do not package /boot and /=
lib in make tar-pkg)
Merging arm-current/fixes (7253b85 ARM: 7541/1: Add ARM ERRATA 775420 worka=
round)
Merging m68k-current/for-linus (f82735d m68k: Use PTR_RET rather than if(IS=
_ERR(...)) + PTR_ERR)
Merging powerpc-merge/merge (636802e powerpc: Don't use __put_user() in pat=
ch_instruction)
Merging sparc/master (1b62ca7 sparc64: Fix return value of Niagara-2 memcpy=
.)
Merging net/master (a0d271c Linux 3.6)
Merging sound-current/for-linus (5d037f9 Merge tag 'asoc-3.6' of git://git.=
kernel.org/pub/scm/linux/kernel/git/broonie/sound into for-linus)
Merging pci-current/for-linus (0ff9514 PCI: Don't print anything while deco=
ding is disabled)
Merging wireless/master (a7be50b iwlwifi: don't double free the interrupt i=
n failure path)
Merging driver-core.current/driver-core-linus (5698bd7 Linux 3.6-rc6)
Merging tty.current/tty-linus (5698bd7 Linux 3.6-rc6)
Merging usb.current/usb-linus (0d00dc2 USB: Fix race condition when removin=
g host controllers)
Merging staging.current/staging-linus (5698bd7 Linux 3.6-rc6)
Merging char-misc.current/char-misc-linus (fea7a08 Linux 3.6-rc3)
Merging input-current/for-linus (dde3ada Merge branch 'next' into for-linus)
Merging md-current/for-linus (80b4812 md/raid10: fix "enough" function for =
detecting if array is failed.)
Merging audit-current/for-linus (c158a35 audit: no leading space in audit_l=
og_d_path prefix)
Merging crypto-current/master (298b973 crypto: x86/glue_helper - fix storin=
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
Merging arm/for-next (f537d06 Merge branch 'devel-stable' into for-next)
CONFLICT (content): Merge conflict in arch/arm/mach-integrator/integrator_c=
p.c
CONFLICT (content): Merge conflict in arch/arm/kernel/smp.c
CONFLICT (content): Merge conflict in arch/arm/include/asm/timex.h
Merging arm-perf/for-next/perf (b90c4b9 Merge branch 'hw-breakpoint' into f=
or-next/perf)
CONFLICT (content): Merge conflict in arch/arm/mach-ux500/cpu-db8500.c
CONFLICT (modify/delete): arch/arm/mach-tegra/devices.c deleted in HEAD and=
 modified in arm-perf/for-next/perf. Version arm-perf/for-next/perf of arch=
/arm/mach-tegra/devices.c left in tree.
CONFLICT (modify/delete): arch/arm/mach-bcmring/arch.c deleted in HEAD and =
modified in arm-perf/for-next/perf. Version arm-perf/for-next/perf of arch/=
arm/mach-bcmring/arch.c left in tree.
CONFLICT (content): Merge conflict in arch/arm/kernel/hw_breakpoint.c
$ git rm -f arch/arm/mach-tegra/devices.c arch/arm/mach-bcmring/arch.c
Merging davinci/davinci-next (fe0d422 Linux 3.0-rc6)
Merging xilinx/arm-next (b85a3ef ARM: Xilinx: Adding Xilinx board support)
Merging arm64/upstream (27aa55c arm64: ptrace: remove obsolete ptrace reque=
st numbers from user headers)
Merging blackfin/for-linus (6895f97 kbuild: add symbol prefix arg to kallsy=
ms)
Merging c6x/for-linux-next (a0d271c Linux 3.6)
Merging cris/for-next (2608747 CRIS: Remove VCS simulator specific code)
Merging hexagon/linux-next (5042ab9 various Kconfig cleanup and old platfor=
m build code removal)
Merging ia64/next (39c9a4a [IA64] xen: Fix return value check in xencomm_vt=
op())
Merging m68k/for-next (f82735d m68k: Use PTR_RET rather than if(IS_ERR(...)=
) + PTR_ERR)
Merging m68knommu/for-next (a255172 m68knommu: fix inconsistent formating i=
n ColdFire 5407 definitions)
Merging microblaze/next (a01ee16 Merge branch 'for-linus' of git://git.open=
-osd.org/linux-open-osd)
Merging mips/mips-for-linux-next (97541cc MIPS: ath79: Fix CPU/DDR frequenc=
y calculation for SRIF PLLs)
CONFLICT (content): Merge conflict in drivers/pinctrl/Makefile
CONFLICT (content): Merge conflict in drivers/net/ethernet/octeon/octeon_mg=
mt.c
Merging openrisc/for-upstream (4c8faa4 openrisc: mask interrupts in irq_mas=
k_ack function)
Merging parisc/for-next (5b24c42 [PARISC] fix personality flag check in cop=
y_thread())
Merging s390/features (12dce10 s390/mm,pageattr: remove superfluous EXPORT_=
SYMBOLs)
Merging sh/sh-latest (16d74eb sh: pfc: Fix up GPIO mux type reconfig case.)
Merging sparc-next/master (42a4172 sparc64: Fix trailing whitespace in NG4 =
memcpy.)
Merging tile/master (e70cf54 tile: gxio iorpc numbering change for TRIO int=
erface)
Merging unicore32/unicore32 (e4baa56 UniCore32-bugfix: Remove definitions i=
n asm/bug.h to solve difference between native and cross compiler)
Merging xtensa/for_next (ded389d xtensa: Add missing RCU idle APIs on idle =
loop)
Merging btrfs/next (b456b5a btrfs: move inline function code to header file)
Merging ceph/master (5ce765a libceph: only kunmap kmapped pages)
Merging cifs/for-next (1d4ab90 [CIFS] Fix indentation of fs/cifs/Kconfig en=
tries)
Merging configfs/linux-next (b930c26 Merge branch 'for-linus' of git://git.=
kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (0d7614f Linux 3.6-rc1)
Merging ext3/for_next (09e05d4 jbd: Fix assertion failure in commit code du=
e to lacking transaction credits)
Merging ext4/dev (041bbb6 ext4: fix mtime update in nodelalloc mode)
Merging fuse/for-next (c7a3f5e fuse: Move CUSE Kconfig entry from fs/Kconfi=
g into fs/fuse/Kconfig)
Merging gfs2/master (2216db7 GFS2: Write out dirty inode metadata in delaye=
d deletes)
Merging jfs/jfs-next (84f4141 jfs: Fix do_div precision in commit b40c2e66)
Merging logfs/master (ab2ec19 logfs: fix possible memory leak in logfs_mtd_=
can_write_buf())
Merging nfs/linux-next (807d66d8 NFSv4: nfs4_open_done first must check tha=
t GETATTR decoded a file type)
Merging nfsd/nfsd-next (0d22f68 nfsd4: don't allow reclaims of expired clie=
nts)
Merging ocfs2/linux-next (4538df6 ocfs2: Don't spam on -EDQUOT.)
Merging omfs/for-next (976d167 Linux 3.1-rc9)
Merging squashfs/master (4b0180a Squashfs: add mount time sanity check for =
block_size and block_log match)
Merging v9fs/for-next (552aad0 9P: Fix race between p9_write_work() and p9_=
fd_request())
Merging ubifs/linux-next (3668b70 UBIFS: print less)
CONFLICT (content): Merge conflict in fs/ubifs/debug.c
Merging xfs/for-next (2ea0392 xfs: Make inode32 a remountable option)
Merging vfs/for-next (49de614 MAX_LFS_FILESIZE should be a loff_t)
CONFLICT (content): Merge conflict in net/socket.c
CONFLICT (content): Merge conflict in drivers/staging/android/binder.c
Applying: net: cope with sock_alloc_file() API change
Merging pci/next (78c8f84 Merge branch 'pci/yinghai-misc' into next)
Merging powerpc/next (7844663 powerpc/eeh: Don't release eeh_mutex in eeh_p=
hb_pe_get)
CONFLICT (content): Merge conflict in drivers/scsi/ipr.c
Merging 4xx/next (2074b1d powerpc: Fix irq distribution)
Merging mpc5xxx/next (9d9fd88 powerpc/mpc52xx_lpbfifo: optionally defer fif=
o transfer start)
Merging galak/next (10bfa76 driver/mtd:IFC NAND:Initialise internal SRAM be=
fore any write)
Merging hid/for-next (0b82411 Merge branch 'hidraw' into for-next)
CONFLICT (content): Merge conflict in drivers/hid/hid-multitouch.c
Merging quilt/i2c (cf53e33 i2c-viapro: Add VIA VX900 device ID)
Merging i2c-embedded/i2c-embedded/for-next (2bdbfa9 i2c: davinci: preparati=
on for switch to common clock framework)
CONFLICT (content): Merge conflict in drivers/i2c/busses/i2c-omap.c
Merging quilt/jdelvare-hwmon (65c575a hwmon: Fix spelling of Celsius)
Merging hwmon-staging/hwmon-next (967d7fe hwmon: (ads7828) driver cleanup)
Merging v4l-dvb/master (0421fb6 Merge /home/v4l/v4l/patchwork)
CONFLICT (content): Merge conflict in arch/arm/mach-omap2/board-rx51-periph=
erals.c
CONFLICT (content): Merge conflict in arch/arm/mach-imx/mach-imx27_visstrim=
_m10.c
CONFLICT (modify/delete): Documentation/feature-removal-schedule.txt delete=
d in HEAD and modified in v4l-dvb/master. Version v4l-dvb/master of Documen=
tation/feature-removal-schedule.txt left in tree.
$ git rm -f Documentation/feature-removal-schedule.txt
Merging kbuild/for-next (ea8fafa Merge branches 'kbuild/rc-fixes', 'kbuild/=
kbuild' and 'kbuild/kconfig' into kbuild/for-next)
Merging kconfig/for-next (4eae518 localmodconfig: Fix localyesconfig to set=
 to 'y' not 'm')
Merging libata/NEXT (13b7408 sata_mv: Fix warnings when no PCI)
Merging infiniband/for-next (e3e5475 Merge branch 'qib' into for-next)
Merging pstore/master (80c9d03 pstore: Avoid recursive spinlocks in the oop=
s_in_progress case)
Merging acpi/next (10eaea0 Merge branch 'misc' into next)
CONFLICT (content): Merge conflict in drivers/usb/core/usb-acpi.c
Applying: usb-acpi: Comply with the ACPI API change after usb tree merge
Merging cpuidle/cpuidle-next (3cf7997 acpi: intel_idle : break dependency b=
etween modules)
CONFLICT (content): Merge conflict in include/linux/cpuidle.h
CONFLICT (add/add): Merge conflict in drivers/cpuidle/coupled.c
Merging cpupowerutils/master (f166033 cpupower tools: add install target to=
 the debug tools' makefiles)
Merging thermal/next (4b69a04 thermal: user_space: Add missing static stora=
ge class specifiers)
CONFLICT (content): Merge conflict in drivers/thermal/thermal_sys.c
CONFLICT (content): Merge conflict in drivers/staging/omap-thermal/omap-the=
rmal-common.c
Merging ieee1394/for-next (4d50c44 firewire: addendum to address handler RC=
U conversion)
Merging ubi/linux-next (2d23729 UBI: Wire-up fastmap)
$ git reset --hard HEAD^
Merging refs/next/20121002/ubi
Merging dlm/next (2b75bc9 dlm: check the maximum size of a request from use=
r)
Merging scsi/for-next (3da4202 Merge branch 'misc' into for-next)
CONFLICT (content): Merge conflict in drivers/scsi/qla2xxx/qla_nx.c
CONFLICT (content): Merge conflict in drivers/scsi/ipr.c
Merging target-updates/for-next (cea0b4c iscsit: add missing endianess conv=
ersion in iscsit_check_inaddr_any)
Merging target-merge/for-next-merge (d987569 Linux 3.6-rc2)
Merging ibft/linux-next (935a9fe ibft: Fix finding IBFT ACPI table on UEFI)
Merging isci/all (6734092 isci: add a couple __iomem annotations)
Merging slave-dma/next (3d4f860 dw_dmac: fix a regression in dwc_prep_dma_m=
emcpy)
CONFLICT (content): Merge conflict in drivers/spi/spi-davinci.c
CONFLICT (content): Merge conflict in drivers/mmc/host/davinci_mmc.c
CONFLICT (content): Merge conflict in drivers/dma/mmp_tdma.c
Applying: DMA: PL330: Fix build error (on linux-next-20120924)
Merging dmaengine/next (a2bd114 netdma: adding alignment check for NETDMA o=
ps)
Merging net-next/master (a3a6cab hyperv: Add buffer for extended info after=
 the RNDIS response message.)
Merging wireless-next/master (5160b46 ath9k: Fix BTCOEX weight initializati=
on)
Merging bluetooth/master (dfee1eb Bluetooth: remove unused member of hci_de=
v.)
Merging mtd/master (e2d3a35 mtd: nand: detect Samsung K9GBG08U0A, K9GAG08U0=
F ID)
CONFLICT (content): Merge conflict in drivers/mtd/nand/orion_nand.c
CONFLICT (modify/delete): drivers/mtd/nand/nand_bcm_umi.h deleted in mtd/ma=
ster and modified in HEAD. Version HEAD of drivers/mtd/nand/nand_bcm_umi.h =
left in tree.
CONFLICT (modify/delete): drivers/mtd/nand/bcm_umi_nand.c deleted in mtd/ma=
ster and modified in HEAD. Version HEAD of drivers/mtd/nand/bcm_umi_nand.c =
left in tree.
CONFLICT (content): Merge conflict in drivers/mtd/nand/Kconfig
CONFLICT (content): Merge conflict in arch/arm/mach-imx/clk-imx51-imx53.c
CONFLICT (modify/delete): arch/arm/configs/bcmring_defconfig deleted in HEA=
D and modified in mtd/master. Version mtd/master of arch/arm/configs/bcmrin=
g_defconfig left in tree.
CONFLICT (content): Merge conflict in MAINTAINERS
$ git rm -f arch/arm/configs/bcmring_defconfig drivers/mtd/nand/bcm_umi_nan=
d.c drivers/mtd/nand/nand_bcm_umi.h
Merging l2-mtd/master (e2d3a35 mtd: nand: detect Samsung K9GBG08U0A, K9GAG0=
8U0F ID)
Merging crypto/master (200429c crypto: cast5/avx - fix storing of new IV in=
 CBC encryption)
CONFLICT (content): Merge conflict in crypto/Kconfig
Merging drm/drm-next (df86b57 drm/savage: re-add busmaster enable, regressi=
on fix)
Merging sound/for-next (b7ef37d ARM: SAMSUNG: dma-ops: Fix dmaengine_prep_d=
ma_cyclic() parameter list)
CONFLICT (modify/delete): sound/soc/omap/overo.c deleted in sound/for-next =
and modified in HEAD. Version HEAD of sound/soc/omap/overo.c left in tree.
CONFLICT (modify/delete): sound/soc/omap/omap3evm.c deleted in sound/for-ne=
xt and modified in HEAD. Version HEAD of sound/soc/omap/omap3evm.c left in =
tree.
CONFLICT (modify/delete): sound/soc/omap/omap3beagle.c deleted in sound/for=
-next and modified in HEAD. Version HEAD of sound/soc/omap/omap3beagle.c le=
ft in tree.
CONFLICT (content): Merge conflict in sound/soc/omap/omap-pcm.c
CONFLICT (content): Merge conflict in sound/soc/omap/omap-mcbsp.c
CONFLICT (modify/delete): sound/soc/omap/igep0020.c deleted in sound/for-ne=
xt and modified in HEAD. Version HEAD of sound/soc/omap/igep0020.c left in =
tree.
CONFLICT (content): Merge conflict in arch/arm/mach-imx/mach-imx27_visstrim=
_m10.c
CONFLICT (content): Merge conflict in arch/arm/mach-davinci/include/mach/da=
8xx.h
CONFLICT (content): Merge conflict in arch/arm/mach-davinci/dm365.c
CONFLICT (content): Merge conflict in arch/arm/mach-davinci/dm355.c
CONFLICT (content): Merge conflict in arch/arm/mach-davinci/davinci.h
$ git rm -f sound/soc/omap/igep0020.c sound/soc/omap/omap3beagle.c sound/so=
c/omap/omap3evm.c sound/soc/omap/overo.c
Merging sound-asoc/for-next (fbe18b4 Merge branch 'for-3.7' into asoc-next)
Merging modules/modules-next (8921e2e MODSIGN: Make mrproper should remove =
generated files.)
CONFLICT (content): Merge conflict in arch/xtensa/Kconfig
CONFLICT (content): Merge conflict in arch/x86/um/Kconfig
CONFLICT (content): Merge conflict in arch/x86/Kconfig
CONFLICT (content): Merge conflict in arch/Kconfig
Merging virtio/virtio-next (bb81110 virtio-blk: Disable callback in virtblk=
_done())
Merging input/next (7774036 Merge branch 'for-next' of git://github.com/ryd=
berg/linux into next)
Merging input-mt/for-next (51c80b7 Input: bcm5974 - Convert to MT-B)
Merging cgroup/for-next (c0a93e2 Merge branch 'for-3.7-hierarchy' into for-=
next)
Merging block/for-next (454832b Merge branch 'for-3.7/drivers' into for-nex=
t)
CONFLICT (content): Merge conflict in init/Kconfig
Merging quilt/device-mapper (1ca30da Use the recently-added bio front_pad f=
ield to allocate struct dm_target_io.)
CONFLICT (content): Merge conflict in drivers/md/dm.c
CONFLICT (content): Merge conflict in drivers/md/dm-thin.c
Merging embedded/master (4744b43 embedded: fix vc_translate operator preced=
ence)
Merging firmware/master (6e03a20 firmware: speed up request_firmware(), v3)
Merging pcmcia/master (80af9e6 pcmcia at91_cf: fix raw gpio number usage)
Merging mmc/mmc-next (0f59ede mmc: sdhci-spear: Add clk_{un}prepare() suppo=
rt)
CONFLICT (content): Merge conflict in drivers/mmc/host/omap.c
CONFLICT (content): Merge conflict in drivers/mmc/host/davinci_mmc.c
Merging kgdb/kgdb-next (08f9553 tty/console: fix warnings in drivers/tty/se=
rial/kgdboc.c)
Merging slab/for-next (2f5f5d8 Merge branch 'slab/tracing' into for-next)
Merging uclinux/for-next (5e442a4 Revert "proc: fix races against execve() =
of /proc/PID/fd**")
Merging md/for-next (c0c6d3f md: writing to sync_action should clear the re=
ad-auto state.)
CONFLICT (content): Merge conflict in fs/bio.c
CONFLICT (content): Merge conflict in drivers/md/raid0.c
Merging mfd/for-next (74d8378 ARM: dts: Enable 88pm860x pmic)
CONFLICT (content): Merge conflict in drivers/video/backlight/88pm860x_bl.c
CONFLICT (content): Merge conflict in drivers/regulator/anatop-regulator.c
CONFLICT (content): Merge conflict in drivers/mfd/tps65217.c
CONFLICT (content): Merge conflict in drivers/mfd/tc3589x.c
CONFLICT (content): Merge conflict in drivers/mfd/max8925-core.c
CONFLICT (content): Merge conflict in drivers/mfd/db8500-prcmu.c
CONFLICT (content): Merge conflict in drivers/mfd/88pm860x-core.c
CONFLICT (content): Merge conflict in Documentation/devicetree/bindings/reg=
ulator/tps6586x.txt
Merging battery/master (18766f0 Merge with upstream to accommodate with MFD=
 changes)
CONFLICT (content): Merge conflict in include/linux/mfd/88pm860x.h
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
CONFLICT (content): Merge conflict in security/integrity/ima/ima_policy.c
CONFLICT (content): Merge conflict in kernel/auditsc.c
Merging selinux/master (c2d7b24 Merge tag 'v3.4' into 20120409)
Merging lblnet/master (7e27d6e Linux 2.6.35-rc3)
Merging watchdog/master (58ddfed Merge branch 'master' of ../linux-watchdog)
Merging dwmw2-iommu/master (c3b92c8 Linux 3.1)
Merging iommu/next (0094872 Merge branches 'dma-debug', 'iommu/fixes', 'arm=
/tegra', 'arm/exynos', 'x86/amd', 'x86/vt-d' and 'x86/amd-irq-remapping' in=
to next)
Merging vfio/next (b68e7fa vfio: Fix virqfd release race)
Merging osd/linux-next (b8017d2 exofs: check for allocation failure in uri_=
store())
Merging jc_docs/docs-next (5c050fb docs: update the development process doc=
ument)
Merging trivial/for-next (9c33c51 doc: fix old config name of kprobetrace)
Merging audit/for-next (dcd6c92 Linux 3.3-rc1)
Merging pm/linux-next (1ac9af7 Merge branch 'master' into linux-next)
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/include/mach/c=
ommon.h
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
CONFLICT (content): Merge conflict in include/linux/of.h
CONFLICT (content): Merge conflict in drivers/of/base.c
Merging spi/spi/next (d8e328b spi: Add "spi:" prefix to modalias attribute =
of spi devices)
Merging spi-mb/spi-next (536a53a spi: remove completely broken Tegra driver)
Merging tip/auto-latest (e029a27 Merge branch 'x86/smap')
Merging rcu/rcu/next (593d100 Merge remote-tracking branch 'tip/core/rcu' i=
nto next.2012.09.25b)
Merging cputime/cputime (c3e0ef9 [S390] fix cputime overflow in uptime_proc=
_show)
Merging uprobes/for-next (0326f5a uprobes/core: Handle breakpoint and singl=
estep exceptions)
Merging kmemleak/kmemleak (4878677 kmemleak: do not leak object after tree =
insertion error)
Merging kvm/linux-next (1e08ec4 KVM: optimize apic interrupt delivery)
CONFLICT (content): Merge conflict in arch/x86/kvm/i8259.c
CONFLICT (content): Merge conflict in arch/s390/include/asm/processor.h
Merging kvm-ppc/kvm-ppc-next (d1805bf arch/powerpc/kvm/e500_tlb.c: fix erro=
r return code)
Merging oprofile/for-next (61bccf1 oprofile: Remove 'WQ on CPUx, prefer CPU=
y' warning)
Merging xen/upstream/xen (af3a3ab Merge git://git.kernel.org/pub/scm/linux/=
kernel/git/steve/gfs2-3.0-fixes)
Merging xen-two/linux-next (1f793bc Merge branch 'stable/for-linus-3.7' int=
o linux-next)
CONFLICT (content): Merge conflict in drivers/xen/Makefile
CONFLICT (modify/delete): arch/arm/mach-vexpress/Makefile.boot deleted in H=
EAD and modified in xen-two/linux-next. Version xen-two/linux-next of arch/=
arm/mach-vexpress/Makefile.boot left in tree.
CONFLICT (content): Merge conflict in arch/arm/Kconfig
$ git rm -f arch/arm/mach-vexpress/Makefile.boot
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
Merging tty/tty-next (0c57dfc tty/serial: Add kgdb_nmi driver)
Merging usb/usb-next (70c048a USB: ezusb: move ezusb.c from drivers/usb/ser=
ial to drivers/usb/misc)
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
Merging remoteproc/for-next (d09f53a remoteproc: Fix use of format specifye=
r)
Merging irqdomain/irqdomain/next (f5a1ad0 irqdomain: Improve diagnostics wh=
en a domain mapping fails)
Merging gpio/gpio/next (ddf343f Merge branch 'for-linus' of git://git.kerne=
l.org/pub/scm/linux/kernel/git/s390/linux)
Merging gpio-lw/for-next (901acf5 gpio: pcf857x: select IRQ_DOMAIN)
Merging arm-soc/for-next (5a5571c Merge branch 'fixes' into for-next)
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
Merging kvmtool/master (5a337ac kvm tools: don't exit on debug ioport write)
Merging dma-mapping/dma-mapping-next (461b6f0 Merge branch 'next-cleanup' i=
nto for-v3.7)
CONFLICT (content): Merge conflict in arch/arm/boot/dts/highbank.dts
CONFLICT (content): Merge conflict in Documentation/devicetree/bindings/ata=
/ahci-platform.txt
Merging pwm/for-next (72004bd pwm: Add Ingenic JZ4740 support)
Merging dma-buf/for-next (ba42051 dma-buf: might_sleep() in dma_buf_unmap_a=
ttachment())
Merging userns/for-next (72235465 userns: Convert the ufs filesystem to use=
 kuid/kgid where appropriate)
Merging ktest/for-next (95f5783 ktest: Fix ELSE IF statements)
Merging signal/for-next (12f79be alpha: don't open-code trace_report_syscal=
l_{enter,exit})
CONFLICT (content): Merge conflict in fs/exec.c
CONFLICT (content): Merge conflict in arch/x86/kernel/signal.c
CONFLICT (content): Merge conflict in arch/x86/kernel/process_32.c
CONFLICT (content): Merge conflict in arch/x86/Kconfig
CONFLICT (content): Merge conflict in arch/um/kernel/exec.c
CONFLICT (content): Merge conflict in arch/s390/Kconfig
CONFLICT (content): Merge conflict in arch/powerpc/Kconfig
CONFLICT (content): Merge conflict in arch/mn10300/Kconfig
CONFLICT (content): Merge conflict in arch/m68k/Kconfig
CONFLICT (content): Merge conflict in arch/m32r/include/asm/Kbuild
CONFLICT (content): Merge conflict in arch/h8300/include/asm/Kbuild
CONFLICT (content): Merge conflict in arch/cris/include/asm/Kbuild
CONFLICT (content): Merge conflict in arch/c6x/Kconfig
CONFLICT (content): Merge conflict in arch/arm/include/asm/thread_info.h
CONFLICT (content): Merge conflict in arch/arm/Kconfig
CONFLICT (content): Merge conflict in arch/alpha/Kconfig
Merging clk/clk-next (494bfec clk: add of_clk_src_onecell_get() support)
Merging random/dev (d2e7c96 random: mix in architectural randomness in extr=
act_buf())
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
Applying: audit.h: replace defines with C stubs
Applying: audith-replace-defines-with-c-stubs-fix
Applying: mn10300: only add -mmem-funcs to KBUILD_CFLAGS if gcc supports it
Applying: fs/debugsfs: remove unnecessary inode->i_private initialization
Applying: drivers/dma/dmaengine.c: lower the priority of 'failed to get' dm=
a channel message
Applying: pcmcia: move unbind/rebind into dev_pm_ops.complete
Applying: drm/i915: optimize DIV_ROUND_CLOSEST() call
Applying: timeconst.pl: remove deprecated defined(@array)
Applying: time: don't inline EXPORT_SYMBOL functions
Applying: kbuild: make: fix if_changed when command contains backslashes
Applying: compiler-gcc4.h: correct verion check for __compiletime_error
Applying: h8300: select generic atomic64_t support
Applying: unicore32: select generic atomic64_t support
Applying: rapidio/rionet: fix multicast packet transmit logic
Applying: readahead: fault retry breaks mmap file read random detection
Applying: drivers/scsi/atp870u.c: fix bad use of udelay
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
Applying: mm: remove __GFP_NO_KSWAPD
Applying: x86, pat: remove the dependency on 'vm_pgoff' in track/untrack pf=
n vma routines
Applying: x86, pat: separate the pfn attribute tracking for remap_pfn_range=
 and vm_insert_pfn
Applying: x86-pat-separate-the-pfn-attribute-tracking-for-remap_pfn_range-a=
nd-vm_insert_pfn-fix
Applying: mm, x86, pat: rework linear pfn-mmap tracking
Applying: mm: introduce arch-specific vma flag VM_ARCH_1
Applying: mm: kill vma flag VM_INSERTPAGE
Applying: mm: kill vma flag VM_CAN_NONLINEAR
Applying: mm: use mm->exe_file instead of first VM_EXECUTABLE vma->vm_file
Applying: mm: kill vma flag VM_EXECUTABLE and mm->num_exe_file_vmas
Applying: mm: prepare VM_DONTDUMP for using in drivers
Applying: mm: kill vma flag VM_RESERVED and mm->reserved_vm counter
Applying: mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix
Applying: mm: fix nonuniform page status when writing new file with small b=
uffer
Applying: mm-fix-nonuniform-page-status-when-writing-new-file-with-small-bu=
ffer-fix
Applying: mm-fix-nonuniform-page-status-when-writing-new-file-with-small-bu=
ffer-fix-fix
Applying: mm/mmap.c: replace find_vma_prepare() with clearer find_vma_links=
()
Applying: mm-mmapc-replace-find_vma_prepare-with-clearer-find_vma_links fix
Applying: mm: compaction: update comment in try_to_compact_pages
Applying: mm: vmscan: scale number of pages reclaimed by reclaim/compaction=
 based on failures
Applying: mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-b=
ased-on-failures-fix
Applying: mm: compaction: capture a suitable high-order page immediately wh=
en it is made available
Applying: Revert "mm: mempolicy: Let vma_merge and vma_split handle vma->vm=
_policy linkages"
Applying: mempolicy: remove mempolicy sharing
Applying: mempolicy: fix a race in shared_policy_replace()
Applying: mempolicy: fix refcount leak in mpol_set_shared_policy()
Applying: mempolicy: fix a memory corruption by refcount imbalance in alloc=
_pages_vma()
Applying: mempolicy-fix-a-memory-corruption-by-refcount-imbalance-in-alloc_=
pages_vma-v2
Applying: mm: mmu_notifier: fix inconsistent memory between secondary MMU a=
nd host
Applying: mm-mmu_notifier-fix-inconsistent-memory-between-secondary-mmu-and=
-host-fix
Applying: mm: mmu_notifier: have mmu_notifiers use a global SRCU so they ma=
y safely schedule
Applying: mm/mmu_notifier: init notifier if necessary
Applying: mm/mmu_notifier: init notifier if necessary
Applying: mm/vmscan: fix error number for failed kthread
Applying: mm: hugetlb: add arch hook for clearing page flags before enterin=
g pool
Applying: mm: adjust final #endif position in mm/internal.h
Applying: thp: fix the count of THP_COLLAPSE_ALLOC
Applying: thp: remove unnecessary check in start_khugepaged
Applying: thp: move khugepaged_mutex out of khugepaged
Applying: thp: remove unnecessary khugepaged_thread check
Applying: thp: remove wake_up_interruptible in the exit path
Applying: thp: remove some code depend on CONFIG_NUMA
Applying: thp: merge page pre-alloc in khugepaged_loop into khugepaged_do_s=
can
Applying: thp: release page in page pre-alloc path
Applying: thp: introduce khugepaged_prealloc_page and khugepaged_alloc_page
Applying: thp: remove khugepaged_loop
Applying: thp: use khugepaged_enabled to remove duplicate code
Applying: thp: remove unnecessary set_recommended_min_free_kbytes
Applying: mm: fix potential anon_vma locking issue in mprotect()
Applying: thp, x86: introduce HAVE_ARCH_TRANSPARENT_HUGEPAGE
Applying: thp: remove assumptions on pgtable_t type
Applying: thp: introduce pmdp_invalidate()
Applying: thp: make MADV_HUGEPAGE check for mm->def_flags
Applying: thp, s390: thp splitting backend for s390
Applying: thp, s390: thp pagetable pre-allocation for s390
Applying: thp, s390: disable thp for kvm host on s390
Applying: thp, s390: architecture backend for thp on s390
Applying: thp, s390: add missing earlyclobber to inline assembly
Applying: ipc/mqueue: remove unnecessary rb_init_node() calls
Applying: rbtree: reference Documentation/rbtree.txt for usage instructions
Applying: rbtree: empty nodes have no color
Applying: rbtree-empty-nodes-have-no-color-fix
Applying: rbtree: fix incorrect rbtree node insertion in fs/proc/proc_sysct=
l.c
Applying: rbtree: move some implementation details from rbtree.h to rbtree.c
Applying: rbtree: fix jffs2 build issue due to renamed __rb_parent_color fi=
eld
Applying: rbtree: performance and correctness test
CONFLICT (content): Merge conflict in lib/Makefile
Applying: rbtree-performance-and-correctness-test-fix
Applying: rbtree: break out of rb_insert_color loop after tree rotation
Applying: rbtree: adjust root color in rb_insert_color() only when necessary
Applying: rbtree: low level optimizations in rb_insert_color()
Applying: rbtree: adjust node color in __rb_erase_color() only when necessa=
ry
Applying: perf tools: fix build for another rbtree.c change
Applying: rbtree: optimize case selection logic in __rb_erase_color()
Applying: rbtree: low level optimizations in __rb_erase_color()
Applying: rbtree: coding style adjustments
Applying: rbtree: optimize fetching of sibling node
Applying: rbtree test: fix sparse warning about 64-bit constant
Applying: rbtree: add __rb_change_child() helper function
Applying: rbtree: place easiest case first in rb_erase()
Applying: rbtree: handle 1-child recoloring in rb_erase() instead of rb_era=
se_color()
Applying: rbtree: low level optimizations in rb_erase()
Applying: rbtree: augmented rbtree test
Applying: rbtree: faster augmented rbtree manipulation
Applying: rbtree: remove prior augmented rbtree implementation
Applying: rbtree: add RB_DECLARE_CALLBACKS() macro
Applying: rbtree: add prio tree and interval tree tests
Applying: mm: replace vma prio_tree with an interval tree
Applying: kmemleak: use rbtree instead of prio tree
Applying: prio_tree: remove
Applying: rbtree: move augmented rbtree functionality to rbtree_augmented.h
Applying: mm: interval tree updates
Applying: mm anon rmap: remove anon_vma_moveto_tail
Applying: mm anon rmap: replace same_anon_vma linked list with an interval =
tree.
Applying: mm rmap: remove vma_address check for address inside vma
Applying: mm: add CONFIG_DEBUG_VM_RB build option
Applying: mm anon rmap: in mremap, set the new vma's position before anon_v=
ma_clone()
Applying: mm: avoid taking rmap locks in move_ptes()
Applying: memory-hotplug: build zonelists when offlining pages
Applying: mm: mmu_notifier: make the mmu_notifier srcu static
Applying: mm: cma: discard clean pages during contiguous allocation instead=
 of migration
Applying: mm-cma-discard-clean-pages-during-contiguous-allocation-instead-o=
f-migration-fix
Applying: mm-cma-discard-clean-pages-during-contiguous-allocation-instead-o=
f-migration-fix-fix
Applying: mm: fix tracing in free_pcppages_bulk()
Applying: mm-fix-tracing-in-free_pcppages_bulk-fix
Applying: cma: fix counting of isolated pages
Applying: cma: count free CMA pages
Applying: cma-count-free-cma-pages-fix
Applying: cma: fix watermark checking
Applying: cma: fix watermark checking cleanup
Applying: mm: page_alloc: use get_freepage_migratetype() instead of page_pr=
ivate()
Applying: mm: remain migratetype in freed page
Applying: memory-hotplug: bug fix race between isolation and allocation
Applying: memory-hotplug: fix pages missed by race rather than failing
Applying: memory-hotplug-fix-pages-missed-by-race-rather-than-failng-fix
Applying: atomic: implement generic atomic_dec_if_positive()
Applying: atomic-implement-generic-atomic_dec_if_positive-fix
Applying: swap: add a simple detector for inappropriate swapin readahead
Applying: swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix
Applying: mm/memblock: reduce overhead in binary search
Applying: mm/memblock: use existing interface to set nid
Applying: mm/memblock: cleanup early_node_map[] related comments
Applying: mm: compaction: abort compaction loop if lock is contended or run=
 too long
Applying: mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-t=
oo-long-fix
Applying: mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-t=
oo-long-fix-2
Applying: mm: compaction: move fatal signal check out of compact_checklock_=
irqsave
Applying: mm: compaction: Update try_to_compact_pages()kerneldoc comment
Applying: mm: compaction: acquire the zone->lru_lock as late as possible
Applying: mm-compaction-acquire-the-zone-lru_lock-as-late-as-possible-fix
Applying: mm-compaction-acquire-the-zone-lru_lock-as-late-as-possible-fix-f=
ix
Applying: mm: compaction: acquire the zone->lock as late as possible
Applying: mm: compaction: iron out isolate_freepages_block() and isolate_fr=
eepages_range()
Applying: Revert "mm: have order > 0 compaction start off where it left"
Applying: mm: compaction: cache if a pageblock was scanned and no pages wer=
e isolated
Applying: mm-compaction-cache-if-a-pageblock-was-scanned-and-no-pages-were-=
isolated-fix
Applying: mm: compaction: cache if a pageblock was scanned and no pages wer=
e isolated -fix2
Applying: mm: compaction: Restart compaction from near where it left off
Applying: mm: compaction: Restart compaction from near where it left off -f=
ix
Applying: mm: compaction: clear PG_migrate_skip based on compaction and rec=
laim activity
Applying: mm/hugetlb.c: remove duplicate inclusion of header file
Applying: mm/page_alloc: refactor out __alloc_contig_migrate_alloc()
Applying: mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc-checkpatc=
h-fixes
Applying: memory-hotplug: don't replace lowmem pages with highmem
Applying: thp: khugepaged_prealloc_page() forgot to reset the page alloc in=
dicator
Applying: mm: thp: fix the pmd_clear() arguments in pmdp_get_and_clear()
Applying: mm: thp: fix the update_mmu_cache() last argument passing in mm/h=
uge_memory.c
Applying: mm: enable CONFIG_COMPACTION by default
Applying: mm: fix-up zone present pages
Applying: memcg: trivial fixes for Documentation/cgroups/memory.txt
Applying: memcg: cleanup kmem tcp ifdefs
Applying: memcg: move mem_cgroup_is_root upwards
Applying: mm: fix invalidate_complete_page2() lock ordering
Applying: mm: remove vma arg from page_evictable
Applying: mm: use clear_page_mlock() in page_remove_rmap()
Applying: mm: remove free_page_mlock
Applying: mm, numa: reclaim from all nodes within reclaim distance
Applying: mm-numa-reclaim-from-all-nodes-within-reclaim-distance-fix
Applying: mm, numa: reclaim from all nodes within reclaim distance fix fix
Applying: memory.txt: remove stray information
Applying: mm: thp: fix pmd_present for split_huge_page and PROT_NONE with T=
HP
Applying: hugetlb: do not use vma_hugecache_offset() for vma_prio_tree_fore=
ach
Applying: mm: move all mmu notifier invocations to be done outside the PT l=
ock
Applying: mm: wrap calls to set_pte_at_notify with invalidate_range_start a=
nd invalidate_range_end
Applying: mm: call invalidate_range_end in do_wp_page even for zero pages
Applying: Revert 0def08e3 because check_range can't fail in migrate_to_node=
 with
Applying: mm: enhance comment and bug check
Applying: memory-hotplug: fix zone stat mismatch
Applying: mm: remove unevictable_pgs_mlockfreed
Applying: KSM: numa awareness sysfs knob
Applying: mm/memory.c: fix typo in comment
Applying: fs/fs-writeback.c: remove unneccesary parameter of __writeback_si=
ngle_inode()
Applying: kpageflags: fix wrong KPF_THP on non-huge compound pages
Applying: CMA: migrate mlocked pages
Applying: cma: decrease cc.nr_migratepages after reclaiming pagelist
Applying: sections: disable const sections for PA-RISC v2
CONFLICT (content): Merge conflict in init/Kconfig
Applying: sections: fix section conflicts in arch/arm/
Applying: sections: fix section conflicts in arch/frv
Applying: sections: fix section conflicts in arch/h8300
Applying: sections-fix-section-conflicts-in-arch-h8300-checkpatch-fixes
Applying: sections: fix section conflicts in arch/ia64
Applying: sections: fix section conflicts in arch/mips
Applying: sections: fix section conflicts in arch/powerpc
Applying: sections: fix section conflicts in arch/score
Applying: sections: fix section conflicts in arch/sh
Applying: sections-fix-section-conflicts-in-arch-sh-fix
Applying: sections: fix section conflicts in arch/x86
Applying: sections: fix section conflicts in drivers/atm
Applying: sections: fix section conflicts in drivers/char
Applying: sections: fix section conflicts in drivers/ide
Applying: sections: fix section conflicts in drivers/macintosh
Applying: sections-fix-section-conflicts-in-drivers-macintosh-checkpatch-fi=
xes
Applying: sections: fix section conflicts in drivers/mfd
Applying: sections: fix section conflicts in drivers/mmc
Applying: sections: fix section conflicts in drivers/net
Applying: sections: fix section conflicts in drivers/net/hamradio
Applying: sections: fix section conflicts in drivers/net/wan
Applying: sections: fix section conflicts in drivers/platform/x86
Applying: sections: fix section conflicts in drivers/scsi
Applying: sections: fix section conflicts in drivers/video
Applying: sections: fix section conflicts in mm/percpu.c
Applying: sections: fix section conflicts in net/can
Applying: sections: fix section conflicts in net
Applying: sections: fix section conflicts in sound
Applying: sections: fix const sections for crc32 table
Applying: sectons-fix-const-sections-for-crc32-table-checkpatch-fixes
Applying: frv: kill used but uninitialized variable
Applying: score: select generic atomic64_t support
Applying: cross-arch: don't corrupt personality flags upon exec()
Applying: tile: fix personality bits handling upon exec()
Applying: kernel/sys.c: call disable_nonboot_cpus() in kernel_restart()
Applying: poweroff: fix bug in orderly_poweroff()
Applying: lib: vsprintf: optimize division by 10 for small integers
Applying: lib: vsprintf: optimize division by 10000
Applying: lib: vsprintf: optimize put_dec_trunc8()
Applying: lib-vsprintf-optimize-put_dec_trunc8-fix
Applying: lib: vsprintf: fix broken comments
Applying: lib/vsprintf: update documentation to cover all of %p[Mm][FR]
Applying: MAINTAINERS: update gpio subsystem file list
Applying: MAINTAINERS: add defconfig file to IMX section
Applying: MAINTAINERS: Update gianfar_ptp after renaming
Applying: MAINTAINERS: fix indentation for Viresh Kumar
Applying: drivers/video/backlight/da9052_bl.c: use usleep_range() instead o=
f msleep() for small sleeps
Applying: drivers/video/backlight/ltv350qv.c: use usleep_range() instead of=
 msleep() for small sleeps
Applying: drivers/video/backlight/kb3886_bl.c: use usleep_range() instead o=
f msleep() for small sleeps
Applying: backlight: lp855x: add FAST bit description for LP8556
Applying: backlight: add Backlight driver for lm3630 chip
Applying: backlight-add-backlight-driver-for-lm3630-chip-fix
Applying: backlight: add new lm3639 backlight driver
Applying: backlight-add-new-lm3639-backlight-driver-fix
Applying: backlight-add-new-lm3639-backlight-driver-fix-2
Applying: backlight: remove ProGear driver
Applying: drivers/video/backlight/da9052_bl.c: drop devm_kfree of devm_kzal=
loc'd data
Applying: drivers/video/backlight/platform_lcd.c: add support for device tr=
ee based probe
Applying: backlight-platform-lcd-add-support-for-device-tree-based-probe-fix
Applying: pwm_backlight: add device tree support for Low Threshold Brightne=
ss
Applying: pwm_backlight-add-device-tree-support-for-low-threshold-brightnes=
s-fix
Applying: drivers/net/ethernet/sfc: use standard __{clear,set}_bit_le() fun=
ctions
Applying: drivers/net/ethernet/dec/tulip: Use standard __set_bit_le() funct=
ion
Applying: bitops: introduce generic {clear,set}_bit_le()
Applying: powerpc: bitops: introduce {clear,set}_bit_le()
Applying: kvm: replace test_and_set_bit_le() in mark_page_dirty_in_slot() w=
ith set_bit_le()
Applying: idr: rename MAX_LEVEL to MAX_IDR_LEVEL
Applying: idr-rename-max_level-to-max_idr_level-fix
Applying: idr-rename-max_level-to-max_idr_level-fix-fix-2
Applying: idr-rename-max_level-to-max_idr_level-fix-fix-2-fix
Applying: idr-rename-max_level-to-max_idr_level-fix-3
Applying: lib/parser.c: avoid overflow in match_number()
Applying: lib-parserc-avoid-overflow-in-match_number-fix
Applying: lib/Kconfig.debug: adjust hard-lockup related Kconfig options
Applying: lib/gcd.c: prevent possible div by 0
Applying: genalloc: make it possible to use a custom allocation algorithm
Applying: lib/spinlock_debug: avoid livelock in do_raw_spin_lock()
Applying: lib-spinlock_debug-avoid-livelock-in-do_raw_spin_lock-fix
Applying: lib/vsprintf.c: improve standard conformance of sscanf()
Applying: lib/plist.c: make plist test announcements KERN_DEBUG
Applying: scatterlist: atomic sg_mapping_iter() no longer needs disabled IR=
Qs
Applying: drivers/firmware/dmi_scan.c: check dmi version when get system uu=
id
Applying: drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid=
-fix
Applying: drivers/firmware/dmi_scan.c: fetch dmi version from SMBIOS if it =
exists
Applying: drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-ex=
ists-checkpatch-fixes
Applying: checkpatch: check utf-8 content from a commit log when it's missi=
ng from charset
Applying: checkpatch: update suggested printk conversions
Applying: checkpatch: check networking specific block comment style
Applying: CodingStyle: add networking specific block comment style
Applying: epoll: support for disabling items, and a self-test app
Applying: binfmt_elf: Uninitialized variable
Applying: drivers/rtc/rtc-isl1208.c: add support for the ISL1218
Applying: rtc-proc: permit the /proc/driver/rtc device to use other devices
Applying: rtc: add Dallas DS2404 driver
Applying: rtc-add-dallas-ds2404-driver-fix
Applying: rtc: snvs: add Freescale rtc-snvs driver
Applying: rtc: snvs: change timeout to use a fixed number of loop
Applying: rtc: recycle id when unloading a rtc driver
Applying: drivers/rtc/rtc-at91sam9.c: use module_platform_driver() macro
Applying: rtc: tps65910: add RTC driver for TPS65910 PMIC RTC
Applying: rtc: tps65910: change RTC driver name as per mfd
Applying: rtc: add MAX8907 RTC driver
Applying: rtc: kconfig: remove unnecessary dependencies.
Applying: drivers/rtc/rtc-jz4740.c: fix IRQ error check
Applying: drivers/rtc/rtc-spear.c: fix several error checks
Applying: rtc: rc5t583: add ricoh rc5t583 RTC driver
Applying: drivers/rtc/rtc-coh901331.c: use clk_prepare_enable() and clk_dis=
able_unprepare()
Applying: rtc: rtc-mxc: adapt to the new i.mx clock framework
Applying: rtc: rtc-mxc: convert to module_platform_driver
Applying: rtc_sysfs_show_hctosys(): display 0 if resume failed
Applying: rtc_sysfs_show_hctosys-return-0-if-resume-failed-fix
Applying: rtc_sysfs_show_hctosys-return-0-if-resume-failed-fix-fix
Applying: drivers/rtc/rtc-s3c.c: fix return value in s3c_rtc_probe()
Applying: drivers/rtc/rtc-ds1672.c: convert struct i2c_msg initialization t=
o C99 format
Applying: drivers/rtc/rtc-x1205.c: convert struct i2c_msg initialization to=
 C99 format
Applying: drivers/rtc/rtc-s35390a.c: convert struct i2c_msg initialization =
to C99 format
Applying: drivers/rtc/rtc-rs5c372.c: convert struct i2c_msg initialization =
to C99 format
Applying: drivers/rtc/rtc-pcf8563.c: convert struct i2c_msg initialization =
to C99 format
Applying: drivers/rtc/rtc-isl1208.c: convert struct i2c_msg initialization =
to C99 format
Applying: drivers/rtc/rtc-em3027.c: convert struct i2c_msg initialization t=
o C99 format
Applying: rtc: kconfig: fix up dependency for ab8500
Applying: drivers/rtc/rtc-tps65910.c: use platform_get_irq() to get RTC irq=
 details
Applying: drivers/rtc/rtc-m41t80.c: remove disabled alarm functionality
Applying: drivers/rtc/rtc-s35390a.c: add wakealarm support for rtc-s35390A =
rtc chip
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
Applying: fat: use accessor function for msdos_dir_entry 'start'
Applying: fat (exportfs): move NFS support code
Applying: fat (exportfs): fix dentry reconnection
Applying: fs/fat: fix a checkpatch issue in namei_msdos.c
Applying: fs/fat: fix some checkpatch issues in fat.h
Applying: fs/fat: chang indentation of some comments in fat.h
Applying: fs/fat: fix two checkpatch issues in cache.c
Applying: fs/fat: fix some small checkpatch issues in dir.c
Applying: fs/fat: fix all other checkpatch issues in dir.c
Applying: fs-fat-fix-all-other-checkpatch-issues-in-dirc-fix
Applying: fs/fat: fix checkpatch issues in fatent.c
Applying: fat: no need to reset EOF in ent_put for FAT32
Applying: fat: simplify writeback_inode()
Applying: fat-simplify-writeback_inode-checkpatch-fixes
Applying: fat-simplify-writeback_inode-checkpatch-fixes-fix
Applying: device_cgroup: add "deny_all" in dev_cgroup structure
Applying: device_cgroup: introduce dev_whitelist_clean()
Applying: device_cgroup: convert device_cgroup internally to policy + excep=
tions
Applying: device_cgroup: rename whitelist to exception list
Applying: coredump: make core dump functionality optional
Applying: fs: amended coredump-related sysctl functions
Applying: coredump-make-core-dump-functionality-optional-fix-fix
Applying: coredump: update coredump-related headers
Applying: coredump: add support for %d=3D__get_dumpable() in core name
Applying: coredump-add-support-for-%d=3D__get_dumpable-in-core-name-fix
Applying: coredump: use SUID_DUMPABLE_ENABLED rather than hardcoded 1
Applying: coredump-use-suid_dumpable_enabled-rather-than-hardcoded-1-checkp=
atch-fixes
Applying: coredump: pass siginfo_t* to do_coredump() and below, not merely =
signr
Applying: compat: move compat_siginfo_t definition to asm/compat.h
Applying: coredump: add a new elf note with siginfo of the signal
Applying: coredump: extend core dump note section to contain file names of =
mapped files
Applying: proc: return -ENOMEM when inode allocation failed
Applying: proc: no need to initialize proc_inode->fd in proc_get_inode()
Applying: proc: use kzalloc instead of kmalloc and memset
Applying: proc-use-kzalloc-instead-of-kmalloc-and-memset-fix
Applying: proc_sysctl.c: use BUG_ON instead of BUG
Applying: fs/proc/root.c: use NULL instead of 0 for pointer
Applying: kdump: remove unneeded include
Applying: ipc/sem.c: alternatives to preempt_disable()
Applying: rapidio/tsi721: modify mport name assignment
Applying: rapidio: fix kerneldoc warnings after DMA support was added
Applying: drivers/rapidio/devices/tsi721.c: fix error return code
Applying: rapidio: add inbound memory mapping interface
Applying: rapidio/tsi721: add inbound memory mapping callbacks
Applying: rapidio: apply RX/TX enable to active switch ports only
Applying: nbd: add set flags ioctl
Applying: nbd: handle discard requests
Applying: aoe: for performance support larger packet payloads
Applying: aoe: kernel thread handles I/O completions for simple locking
Applying: aoe: cleanup an allocation a bit
Applying: aoe: become I/O request queue handler for increased user control
Applying: aoe: use a kernel thread for transmissions
Applying: aoe: use packets that work with the smallest-MTU local interface
Applying: aoe: failover remote interface based on aoe_deadsecs parameter
Applying: aoe: do revalidation steps in order
Applying: aoe: disallow unsupported AoE minor addresses
Applying: aoe: associate frames with the AoE storage target
Applying: aoe: increase net_device reference count while using it
Applying: aoe: remove unused code and add cosmetic improvements
Applying: aoe: update internal version number to 49
Applying: aoe: update copyright year in touched files
Applying: aoe: update documentation with new URL and VM settings reference
Applying: taskstats: cgroupstats_user_cmd() may leak on error
Applying: kernel/resource.c: fix stack overflow in __reserve_region_with_sp=
lit()
Applying: lib/decompress.c add __init to decompress_method and data
Applying: prio_tree: fix fs/block_dev.c for removal of prio_tree
Applying: fs/block_dev.c:set_blocksize(): use mapping_mapped()
Merging akpm/master (467509e fs/block_dev.c:set_blocksize(): use mapping_ma=
pped())

--Signature=_Wed__3_Oct_2012_17_30_07_+1000_5F4qj=b/O36OknE.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQa+l/AAoJEECxmPOUX5FEsWkP/1yuNI5UaHKOdzaACKEe0Mbi
GiHgGW1kGo0QLUWpsO2w4LWPfCJ/20DHsdndp3lRCBX+tc7qkJcYMeoHpFCO8u3J
VPKvWYayxytn/6Ox27QHHJ5WgxsdcNUWNE0c6Wl2tUEH3EMnMyj26YFwH91a0BkZ
7r4x6dHy+LIeCL663VOXwcJrdn5gDutF0WNa7/yqXBE/WBmqEUu+BAXHpHVSmlCx
8SRpIpDD7OONQv6Nf/8WwKuSzRkZCsnp+qdCT877bXRFpzvUkQSSZMvKvrjRu5HF
NEcez8CwQphEiDoVEGgppu040xeWoGJ73QB1htftgB1Cujt/gTbmQUS0CuYUjTc+
4kc2gzACxmugieFN/7FTAFJbkHKUo9QQoVfzTbUj5g2RCPwDoFKqJziCyB2zaifb
RjRvKraqBgrY47baip9/+V2DJfR92puTWn2tELPWlsDQ/tcnu8g+u+BGparoz221
NJq40R9+A74o5icJfJaQFfSQiHJ/eJ8egDi4pY7NU3YmXFykmqSMNL7OpnZBnuh/
kQ+ImD/eCQ+ucUuki20/3V+yDuWgihrnfatAg8zwC6LVDf1J8d5MJLxDH4Em7gCC
R+hJM62pPLl7/vWU/SzFVz0dWaHAOF+zWKdAslYlhWo2w3DcFE9cK/xBuK615RKY
WSu2vRiDKSf0hnLnvop2
=4BaW
-----END PGP SIGNATURE-----

--Signature=_Wed__3_Oct_2012_17_30_07_+1000_5F4qj=b/O36OknE.--

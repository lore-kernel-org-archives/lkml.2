Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030880Ab2CVGIp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 02:08:45 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:35519 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030452Ab2CVGIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 02:08:40 -0400
Date: Thu, 22 Mar 2012 17:08:29 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Mar 22
Message-Id: <20120322170829.38a649b3f84d225d94808648@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__22_Mar_2012_17_08_29_+1100_uoko12AgP2/+jdtV"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__22_Mar_2012_17_08_29_+1100_uoko12AgP2/+jdtV
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Reminder: please do not add stuff destined for v3.5 to linux-next
included trees/branches until after v3.4-rc1 has been released.

Changes since 20120321:

Lots of conflicts move between trees and disappear as things are merged
into Linus' tree.

Removed tree: 52xx-and-virtex-current

Replaced tree: the mpc5xxx tree replaces the 52xx-and-virtex tree
=20
The ceph tree still had ist build failure so I used the version from
next-20120320.

The slave-dma tree gained conflicts against the sound tree.

The l2-mtd tree gained a conflicts against the slave-dma tree.

The battery tree still had its build failure so I used the version from
next-20120314.

The oprofile tree lost its conflicts.

The drivers-x86 tree lost its build failure but gained another so I used
the version from next-20120320.

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
CONFIG_PROFILE_ALL_BRANCHES - this fails its final link) and i386, sparc
and sparc64 defconfig. These builds also have
CONFIG_ENABLE_WARN_DEPRECATED, CONFIG_ENABLE_MUST_CHECK and
CONFIG_DEBUG_INFO disabled when necessary.

Below is a summary of the state of the merge.

We are up to 187 trees (counting Linus' and 25 trees of patches pending
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
Merging origin/master (30d73f3 Merge tag 'dlm-3.4' of git://git.kernel.org/=
pub/scm/linux/kernel/git/teigland/linux-dlm)
Merging fixes/master (88ebdda Merge tag 'for-3.3' of git://openrisc.net/jon=
as/linux)
Merging kbuild-current/rc-fixes (42f1c01 coccicheck: change handling of C=
=3D{1,2} when M=3D is set)
Merging arm-current/fixes (a0feb6d ARM: 7358/1: perf: add PMU hotplug notif=
ier)
Merging m68k-current/for-linus (2a35350 m68k: Fix assembler constraint to p=
revent overeager gcc optimisation)
Merging powerpc-merge/merge (c2ea377 Merge remote-tracking branch 'origin/m=
aster' into merge)
CONFLICT (content): Merge conflict in arch/powerpc/sysdev/mpic.c
Applying: powerpc: do not adjust the load address for ps3
Merging sparc/master (e0adb99 sparc32: Add -Av8 to assembler command line.)
Merging scsi-rc-fixes/master (41f8ad7 [SCSI] osd_uld: Bump MAX_OSD_DEVICES =
from 64 to 1,048,576)
Merging net/master (5676cc7 sky2: override for PCI legacy power management)
Merging sound-current/for-linus (6681bc0 Merge tag 'asoc-3.4' of git://git.=
kernel.org/pub/scm/linux/kernel/git/broonie/sound into for-linus)
Merging pci-current/for-linus (4949be1 PCI: ignore pre-1.1 ASPM quirking wh=
en ASPM is disabled)
Merging wireless/master (c16fa4f Linux 3.3)
Merging driver-core.current/driver-core-linus (fde7d90 Linux 3.3-rc7)
Merging tty.current/tty-linus (fde7d90 Linux 3.3-rc7)
Merging usb.current/usb-linus (fde7d90 Linux 3.3-rc7)
Merging staging.current/staging-linus (fde7d90 Linux 3.3-rc7)
Merging char-misc.current/char-misc-linus (c16fa4f Linux 3.3)
Merging cpufreq-current/fixes (6139b65 Merge branch 'for_3.4/cpufreq' of gi=
t://git.kernel.org/pub/scm/linux/kernel/git/khilman/linux-omap-pm into fixe=
s)
Merging input-current/for-linus (10ce3cc Merge branch 'next' into for-linus)
Merging md-current/for-linus (ecb178b md: Add judgement bb->unacked_exist i=
n function md_ack_all_badblocks().)
CONFLICT (content): Merge conflict in drivers/md/bitmap.c
Merging audit-current/for-linus (c158a35 audit: no leading space in audit_l=
og_d_path prefix)
Merging crypto-current/master (2dc9b5d padata: Fix race on sequence number =
wrap)
Merging ide/master (0ab3d8b cy82c693: fix PCI device selection)
Merging dwmw2/master (244dc4e Merge git://git.infradead.org/users/dwmw2/ran=
dom-2.6)
Merging devicetree-current/devicetree/merge (29f141f Merge branch 'fixes-fo=
r-grant' of git://sources.calxeda.com/kernel/linux into devicetree/merge)
Merging spi-current/spi/merge (a5ab629 Fix section mismatch in spi-pl022.c)
Merging gpio-current/gpio/merge (7e3a70f gpio: Add missing spin_lock_init i=
n gpio-ml-ioh driver)
Merging arm/for-next (467fa4e Merge branch 'acorn' into for-next)
CONFLICT (content): Merge conflict in arch/c6x/Kconfig
CONFLICT (content): Merge conflict in arch/arm/common/gic.c
Merging arm-perf/for-next/perf (c16fa4f Linux 3.3)
Merging davinci/davinci-next (fe0d422 Linux 3.0-rc6)
Merging samsung/next-samsung (9edb240 ARM: H1940/RX1950: Change default LED=
 triggers)
Merging s5p/for-next (d782c13 Merge branch 'next/soc-exynos5250-gpio' into =
for-next)
Merging tegra/for-next (e8ce8f9 Merge branch 'for-3.4/cleanup-and-fixes' in=
to for-next)
CONFLICT (content): Merge conflict in arch/arm/mach-tegra/fuse.c
Merging xilinx/arm-next (b85a3ef ARM: Xilinx: Adding Xilinx board support)
Merging blackfin/for-linus (1762275 blackfin: clean up string bfin_dma_5xx =
after rename.)
Merging c6x/for-linux-next (fde7d90 Linux 3.3-rc7)
Merging cris/for-next (ea78f5b CRIS: Update documentation)
Merging quilt/hexagon (110b372 Remove unneeded include of version.h from ar=
ch/hexagon/include/asm/spinlock_types.h)
CONFLICT (content): Merge conflict in arch/hexagon/Kconfig
Merging ia64/next (5cd288c Merge branch 'pstore' into next)
CONFLICT (content): Merge conflict in arch/ia64/hp/sim/simserial.c
Merging m68k/for-next (2a35350 m68k: Fix assembler constraint to prevent ov=
ereager gcc optimisation)
Merging m68knommu/for-next (ae909ea m68knommu: factor more common ColdFire =
cpu reset code)
CONFLICT (modify/delete): arch/m68k/kernel/process_no.c deleted in m68knomm=
u/for-next and modified in HEAD. Version HEAD of arch/m68k/kernel/process_n=
o.c left in tree.
CONFLICT (modify/delete): arch/m68k/kernel/process_mm.c deleted in m68knomm=
u/for-next and modified in HEAD. Version HEAD of arch/m68k/kernel/process_m=
m.c left in tree.
$ git rm -f arch/m68k/kernel/process_no.c arch/m68k/kernel/process_mm.c
Applying: sched/rt: Use schedule_preempt_disabled() in m68k
Merging microblaze/next (8597559 Merge tag 'gpio-for-linus' of git://git.se=
cretlab.ca/git/linux-2.6)
Merging mips/mips-for-linux-next (2fea377 Merge branch 'fixes-for-linus' in=
to mips-for-linux-next)
Merging openrisc/for-upstream (fa8d9d7 OpenRISC: Remove memory_start/end pr=
ototypes)
Merging parisc/for-next (c60dc74 Merge branch 'fixes' into for-next)
Merging powerpc/next (dfbc2d7 powerpc/ps3: Do not adjust the wrapper load a=
ddress)
CONFLICT (content): Merge conflict in include/linux/of.h
CONFLICT (modify/delete): drivers/char/viotape.c deleted in powerpc/next an=
d modified in HEAD. Version HEAD of drivers/char/viotape.c left in tree.
CONFLICT (content): Merge conflict in drivers/base/driver.c
CONFLICT (content): Merge conflict in arch/powerpc/sysdev/mpic.c
CONFLICT (modify/delete): arch/powerpc/platforms/iseries/setup.c deleted in=
 powerpc/next and modified in HEAD. Version HEAD of arch/powerpc/platforms/=
iseries/setup.c left in tree.
CONFLICT (modify/delete): arch/powerpc/platforms/iseries/irq.c deleted in p=
owerpc/next and modified in HEAD. Version HEAD of arch/powerpc/platforms/is=
eries/irq.c left in tree.
CONFLICT (modify/delete): arch/powerpc/platforms/iseries/Kconfig deleted in=
 powerpc/next and modified in HEAD. Version HEAD of arch/powerpc/platforms/=
iseries/Kconfig left in tree.
CONFLICT (content): Merge conflict in arch/powerpc/Kconfig
$ git rm -f arch/powerpc/platforms/iseries/Kconfig arch/powerpc/platforms/i=
series/irq.c arch/powerpc/platforms/iseries/setup.c drivers/char/viotape.c
Merging 4xx/next (b5594a7 powerpc/44x: Add additional device support for AP=
M821xx SoC and Bluestone board)
Merging mpc5xxx/next (7b6bb64 powerpc/5200: convert mpc5200 to use of_platf=
orm_populate())
Merging galak/next (5a0acea powerpc/qe: Update the SNUM table for MPC8569 R=
ev2.0)
Merging s390/features (c6da39f [S390] kernel: Pass correct stack for smp_ca=
ll_ipl_cpu())
CONFLICT (content): Merge conflict in arch/s390/kernel/smp.c
Merging sparc-next/master (e9b57cc sparc: Use vsprintf extention %pf with b=
uiltin_return_address)
Merging tile/master (48b25c4 [PATCH v3] ipc: provide generic compat version=
s of IPC syscalls)
Merging unicore32/unicore32 (0994695 Merge branch 'akpm' (aka "Andrew's pat=
ch-bomb, take two"))
Merging ceph/master (dd2a081 rbd: move snap_rwsem to the device, rename to =
header_rwsem)
CONFLICT (content): Merge conflict in fs/ceph/xattr.c
$ git reset --hard HEAD^
Merging refs/next/20120320/ceph
Merging cifs/master (3dd9330 cifs: clean up ordering in exit_cifs)
Merging configfs/linux-next (b930c26 Merge branch 'for-linus' of git://git.=
kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (6cfd4b4 ecryptfs: remove the second argument of k[un=
]map_atomic())
CONFLICT (content): Merge conflict in fs/ecryptfs/ecryptfs_kernel.h
Merging ext3/for_next (e703c20 ext3: fix start and len arguments handling i=
n ext3_trim_fs())
Merging ext4/dev (f16a28b ext4: update s_free_{inodes,blocks}_count during =
online resize)
Merging fuse/for-next (4273b79 fuse: O_DIRECT support for files)
Merging gfs2/master (220cca2 GFS2: Change truncate page allocation to be GF=
P_NOFS)
Merging logfs/master (e45836f Merge branch 'for-3.4' of git://git.kernel.or=
g/pub/scm/linux/kernel/git/tj/wq)
Merging nfs/linux-next (5a7c9ee NFS: fix sb->s_id in nfs debug prints)
Merging nfsd/nfsd-next (ab4684d NFSD: Fix nfs4_verifier memory alignment)
Merging ocfs2/linux-next (9392557 ocfs2: avoid unaligned access to dqc_bitm=
ap)
Merging omfs/for-next (976d167 Linux 3.1-rc9)
Merging squashfs/master (4b0180a Squashfs: add mount time sanity check for =
block_size and block_log match)
Merging v9fs/for-next (5bdad93 9p: statfs should not override server f_type)
Merging ubifs/linux-next (5a1f36c UBIFS: improve error messages)
Merging xfs/for-next (f074211 xfs: fallback to vmalloc for large buffers in=
 xfs_getbmap)
CONFLICT (content): Merge conflict in fs/xfs/xfs_trans_dquot.c
CONFLICT (modify/delete): fs/xfs/xfs_qm_stats.c deleted in xfs/for-next and=
 modified in HEAD. Version HEAD of fs/xfs/xfs_qm_stats.c left in tree.
CONFLICT (content): Merge conflict in fs/xfs/xfs_qm.h
CONFLICT (content): Merge conflict in fs/xfs/xfs_qm.c
CONFLICT (content): Merge conflict in fs/xfs/xfs_dquot.c
$ git rm -f fs/xfs/xfs_qm_stats.c
Merging vfs/for-next (07c0c5d ext4: initialization of ext4_li_mtx needs to =
be done earlier)
Merging pci/linux-next (1488d51 PCI: Bjorn gets PCI hotplug too)
CONFLICT (content): Merge conflict in include/linux/pci.h
CONFLICT (modify/delete): arch/powerpc/platforms/iseries/pci.c deleted in H=
EAD and modified in pci/linux-next. Version pci/linux-next of arch/powerpc/=
platforms/iseries/pci.c left in tree.
CONFLICT (content): Merge conflict in arch/powerpc/include/asm/ppc-pci.h
CONFLICT (content): Merge conflict in arch/mips/pci/pci.c
$ git rm -f arch/powerpc/platforms/iseries/pci.c
Merging hid/for-next (d464c92 Merge branch 'for-linus' of git://git.kernel.=
org/pub/scm/linux/kernel/git/jikos/hid)
Merging quilt/i2c (9dbe38f i2c-algo-bit: Don't resched on clock stretching)
Merging bjdooks-i2c/next-i2c (fc84fe1 Merge branch 'for_3.3/i2c/misc' of gi=
t://git.kernel.org/pub/scm/linux/kernel/git/khilman/linux-omap-pm into for-=
33/i2c/omap)
CONFLICT (content): Merge conflict in drivers/i2c/busses/i2c-omap.c
Merging i2c-embedded/i2c-embedded/for-next (bbceeee i2c-eg20t: Remove write=
-only variables)
Merging quilt/jdelvare-hwmon (013d8b1 hwmon: Add MCP3021 ADC driver)
Merging hwmon-staging/hwmon-next (28c85aa hwmon: (sht15) Fix Kconfig depend=
encies)
Merging quilt/kernel-doc (4441c30 Clarify that the 'cat' command does not i=
nclude the (c, 13, 32) after it.)
Merging docs/docs-move (5c24d8b Merge branch 'docs/docbook/drm' of git://gi=
thub.com/mfwitten/linux into docs-move)
Merging v4l-dvb/master (153fb4d Merge /home/v4l/v4l/patchwork)
Merging kbuild/for-next (17c0999 Merge branch 'kbuild/misc' into kbuild/for=
-next)
Merging kconfig/for-next (eae1c36 Merge branch 'kconfig/for-linus-2' into k=
config/for-next)
Merging libata/NEXT (b8cec3c pata_cmd64x: implement sff_irq_check() method)
Merging infiniband/for-next (5ad19b0 Merge branches 'cma', 'cxgb3', 'cxgb4'=
, 'ehca', 'iser', 'mad', 'nes', 'qib', 'srp' and 'srpt' into for-next)
Merging acpi/next (aa5228b Merge branch 'red-hat-bz-727865' into release)
CONFLICT (content): Merge conflict in drivers/cpuidle/cpuidle.c
Merging cpupowerutils/master (f166033 cpupower tools: add install target to=
 the debug tools' makefiles)
Merging ieee1394/for-next (19f8399 Merge branch 'iso-flush' into for-next)
Merging ubi/linux-next (898e567 UBI: fix eraseblock picking criteria)
Merging dlm/next (1b189b8 dlm: last element of dlm_local_addr[] never used)
Merging scsi/master (cd8df93 [SCSI] qla4xxx: Update driver version to 5.02.=
00-k15)
Merging target-updates/for-next (187e70a ib_srpt: Fix srpt_handle_cmd send_=
ioctx->ioctx_kref leak on exception)
Merging target-merge/for-next-merge (06de5ee tcm_qla2xxx: Add >=3D 24xx ser=
ies fabric module for target-core)
Merging ibft/linux-next (935a9fe ibft: Fix finding IBFT ACPI table on UEFI)
Merging isci/all (2f70c31 Merge branch 'devel' into all)
Merging slave-dma/next (beeaa10 dmaengine: at_hdmac: add slave config opera=
tion)
CONFLICT (content): Merge conflict in sound/soc/mxs/mxs-pcm.c
CONFLICT (content): Merge conflict in sound/soc/imx/imx-pcm-dma-mx2.c
CONFLICT (content): Merge conflict in sound/soc/ep93xx/ep93xx-pcm.c
CONFLICT (content): Merge conflict in drivers/mmc/host/atmel-mci.c
CONFLICT (modify/delete): arch/arm/include/asm/hardware/pl330.h deleted in =
slave-dma/next and modified in HEAD. Version HEAD of arch/arm/include/asm/h=
ardware/pl330.h left in tree.
CONFLICT (modify/delete): arch/arm/common/pl330.c deleted in slave-dma/next=
 and modified in HEAD. Version HEAD of arch/arm/common/pl330.c left in tree.
$ git rm -f arch/arm/common/pl330.c arch/arm/include/asm/hardware/pl330.h
Applying: DMA: PL330: update for code movement
Merging dmaengine/next (d07a74a dmaengine: fix missing 'cnt' in ?: in dmate=
st)
Merging net-next/master (3556485 Merge branch 'next' of git://git.kernel.or=
g/pub/scm/linux/kernel/git/jmorris/linux-security)
Merging wireless-next/master (3775265 libertas: remove dump_survey implemen=
tation)
Merging bluetooth/master (7c364b9 Bluetooth: Simplify L2CAP timer logic)
Merging mtd/master (3c3e51d Merge ../linux-2.6 to bring in 3.3-rc fixes alr=
eady merged)
Merging l2-mtd/master (0d9af43 mtd: phram: fix section mismatch for phram_s=
etup)
CONFLICT (content): Merge conflict in sound/soc/mxs/mxs-pcm.h
CONFLICT (content): Merge conflict in fs/jffs2/fs.c
CONFLICT (content): Merge conflict in fs/jffs2/compr.c
CONFLICT (content): Merge conflict in drivers/mtd/nand/gpmi-nand/gpmi-lib.c
CONFLICT (content): Merge conflict in drivers/mtd/chips/cfi_cmdset_0002.c
CONFLICT (content): Merge conflict in drivers/mmc/host/mxs-mmc.c
CONFLICT (content): Merge conflict in drivers/dma/mxs-dma.c
Merging crypto/master (2dc9b5d padata: Fix race on sequence number wrap)
Merging sound/for-next (4689e5e Merge branch 'for-linus' into for-next)
Merging sound-asoc/for-next (b055bdd Merge branch 'for-3.4' into asoc-next)
Merging cpufreq/next (a7b422c provide disable_cpufreq() function to disable=
 the API.)
CONFLICT (content): Merge conflict in drivers/cpufreq/Makefile
CONFLICT (content): Merge conflict in drivers/cpufreq/Kconfig.arm
Merging quilt/rr (2a22b63 cpumask: remove old cpu_*_map.)
CONFLICT (content): Merge conflict in arch/arm/kernel/kprobes.c
Merging input/next (d8ee4a1 Input: gpio_keys - add support for interrupt on=
ly keys)
Merging input-mt/for-next (7491f3d bcm5974: Add pointer and buttonpad prope=
rties)
Merging block/for-next (c16fa4f Linux 3.3)
Merging quilt/device-mapper (a35f363 This patch introduces a new function d=
m_bufio_prefetch. It prefetches the specified range of blocks into dm-bufio=
 cache without waiting for i/o completion.)
CONFLICT (content): Merge conflict in drivers/md/dm-raid.c
Merging embedded/master (4744b43 embedded: fix vc_translate operator preced=
ence)
Merging firmware/master (6e03a20 firmware: speed up request_firmware(), v3)
Merging pcmcia/master (80af9e6 pcmcia at91_cf: fix raw gpio number usage)
CONFLICT (content): Merge conflict in drivers/pcmcia/soc_common.c
Merging battery/master (d6a047c max17042_battery: Fix CHARGE_FULL represent=
ation.)
$ git reset --hard HEAD^
Merging refs/next/20120314/battery
Merging mmc/mmc-next (7e9d684 mmc: sh_mmcif: simplify bitmask macros)
CONFLICT (content): Merge conflict in include/linux/mmc/host.h
CONFLICT (content): Merge conflict in drivers/mmc/host/tmio_mmc_pio.c
CONFLICT (content): Merge conflict in drivers/mmc/host/sh_mmcif.c
CONFLICT (content): Merge conflict in drivers/mmc/host/sdhci-s3c.c
CONFLICT (content): Merge conflict in drivers/mmc/host/atmel-mci.c
CONFLICT (content): Merge conflict in drivers/mmc/core/host.h
CONFLICT (content): Merge conflict in drivers/mmc/core/core.c
Merging kgdb/kgdb-next (b6149b6 kgdb,debug_core,kgdbts: End DEBUG_RODATA li=
mitation using kprobe breakpoints)
Merging slab/for-next (b80b6c0 Merge branch 'slab/next' into for-next)
Merging uclinux/for-next (5e442a4 Revert "proc: fix races against execve() =
of /proc/PID/fd**")
Merging md/for-next (ecb178b md: Add judgement bb->unacked_exist in functio=
n md_ack_all_badblocks().)
Merging mfd/for-next (fd7cddd Revert "mfd: Add platform data for MAX8997 ha=
ptic driver")
CONFLICT (content): Merge conflict in drivers/mfd/ab8500-core.c
Merging drm/drm-next (5466c7b drm/i915: use DDC_ADDR instead of hard-coding=
 it)
Merging fbdev/fbdev-next (6bff98b Revert "video:uvesafb: Fix oops that uves=
afb try to execute NX-protected page")
CONFLICT (content): Merge conflict in drivers/video/udlfb.c
Merging viafb/viafb-next (838ac78 viafb: avoid refresh and mode lookup in s=
et_par)
Merging omap_dss2/for-next (df01d53 OMAPDSS: APPLY: fix clearing shadow dir=
ty flag with manual update)
Merging regulator/for-next (4992fa1 Merge tag 'topic/twl' into regulator-ne=
xt)
Merging security/next (09f61cd Merge branch 'for-security' of git://git.ker=
nel.org/pub/scm/linux/kernel/git/jj/linux-apparmor into next)
Merging selinux/master (ecf093d SELinux: add default_type statements)
Merging lblnet/master (7e27d6e Linux 2.6.35-rc3)
Merging watchdog/master (691dc60 watchdog: xen: don't unconditionally enabl=
e the watchdog during resume)
Merging dwmw2-iommu/master (c3b92c8 Linux 3.1)
Merging iommu/next (7799846 Merge branches 'iommu/fixes', 'arm/tegra' and '=
x86/amd' into next)
Merging osd/linux-next (72749a2 exofs: Cap on the memcpy() size)
Merging jc_docs/docs-next (5c050fb docs: update the development process doc=
ument)
Merging trivial/for-next (f1f996b kcore: fix spelling in read_kcore() comme=
nt)
Merging audit/for-next (dcd6c92 Linux 3.3-rc1)
Merging pm/linux-next (30d73f3 Merge tag 'dlm-3.4' of git://git.kernel.org/=
pub/scm/linux/kernel/git/teigland/linux-dlm)
Merging apm/for-next (b4a133d Merge branch 'for-linus' of git://git.kernel.=
org/pub/scm/linux/kernel/git/jikos/apm)
Merging fsnotify/for-next (ef9bf3b fanotify: only destroy a mark if both it=
s mask and its ignored_mask are cleared)
Merging edac/linux_next (4d096ca MAINTAINERS: add an entry for Edac Sandy B=
ridge driver)
Merging edac-amd/for-next (305f1c3 Merge branch '3.3-pci_device_id' into ed=
ac-for-next)
Merging devicetree/devicetree/next (0f22dd3 of: Only compile OF_DYNAMIC on =
PowerPC pseries and iseries)
Merging spi/spi/next (87bf5ab spi/fsl-espi: Make sure pm is within 2..32)
Merging tip/auto-latest (6ead017 Merge branch 'linus')
CONFLICT (content): Merge conflict in arch/x86/platform/mrst/mrst.c
CONFLICT (content): Merge conflict in arch/x86/Kconfig
Merging rcu/rcu/next (1cc8596 rcu: Stop spurious warnings from synchronize_=
sched_expedited)
Merging cputime/cputime (c3e0ef9 [S390] fix cputime overflow in uptime_proc=
_show)
Merging uprobes/for-next (0326f5a uprobes/core: Handle breakpoint and singl=
estep exceptions)
Merging cgroup/for-next (3ce3230 cgroup: Walk task list under tasklist_lock=
 in cgroup_enable_task_cg_list)
Merging kmemleak/kmemleak (d65b4e9 Linux 3.3-rc3)
Merging kvm/linux-next (f8753c5 KVM: Convert intx_mask_lock to spin lock)
Merging oprofile/for-next (c16fa4f Linux 3.3)
Merging xen/upstream/xen (59e9a6b Merge branch 'upstream/ticketlock-cleanup=
' into upstream/xen)
CONFLICT (content): Merge conflict in arch/x86/include/asm/cmpxchg.h
Merging xen-two/linux-next (963ec11 Merge branch 'stable/for-linus-3.4' int=
o linux-next)
CONFLICT (content): Merge conflict in drivers/tty/hvc/hvc_xen.c
Merging xen-pvhvm/linux-next (b056b6a xen: suspend: remove xen_hvm_suspend)
Merging percpu/for-next (adb7950 percpu: fix __this_cpu_{sub,inc,dec}_retur=
n() definition)
Merging workqueues/for-next (e06ffa1 workqueue: use percpu allocator for cw=
q on UP)
Merging drivers-x86/linux-next (1474c6b thinkpad-acpi: recognize Lenovo as =
version string in newer V-series BIOS)
CONFLICT (content): Merge conflict in arch/x86/platform/mrst/mrst.c
CONFLICT (content): Merge conflict in arch/x86/platform/geode/Makefile
CONFLICT (content): Merge conflict in arch/x86/Kconfig
$ git reset --hard HEAD^
Merging refs/next/20120320/drivers-x86
CONFLICT (content): Merge conflict in arch/x86/platform/mrst/mrst.c
CONFLICT (content): Merge conflict in arch/x86/platform/geode/Makefile
CONFLICT (content): Merge conflict in arch/x86/Kconfig
[master 848274e] Merge commit 'refs/next/20120320/drivers-x86'
Merging hwpoison/hwpoison (46e387b Merge branch 'hwpoison-hugepages' into h=
wpoison)
Merging sysctl/master (4e75732 sysctl: Don't call sysctl_follow_link unless=
 we are a link.)
CONFLICT (content): Merge conflict in fs/proc/proc_sysctl.c
Merging regmap/for-next (7d680ba Merge remote-tracking branch 'regmap/topic=
/introspection' into regmap-next)
Merging hsi/for-next (43139a6 HSI: hsi_char: Update ioctl-number.txt)
Merging driver-core/driver-core-next (adc80ae Tools: hv: Support enumeratio=
n from all the pools)
Merging tty/tty-next (fb8ebec serial: pxa: add clk_prepare/clk_unprepare ca=
lls)
Merging usb/usb-next (11207b6 net: qmi_wwan: add support for ZTE MF820D)
Merging staging/staging-next (bc01caf staging/zmem: Use lockdep_assert_held=
 instead of spin_is_locked)
Merging char-misc/char-misc-next (b222258 misc: bmp085: Use unsigned long t=
o store jiffies)
Merging tmem/linux-next (16c0cfa Merge branch 'stable/cleancache.v13' into =
linux-next)
Merging writeback/writeback-for-next (697e6fe writeback: Remove outdated co=
mment)
Merging arm-dt/devicetree/arm-next (ede338f dt: add documentation of ARM dt=
 boot interface)
Merging hwspinlock/linux-next (8b37fcf hwspinlock: add MAINTAINERS entries)
Merging pinctrl/for-next (51dddfe ARM: u300: configure some pins as an exam=
ple)
Merging moduleh/for-sfr (de2272c Merge branch 'device-3.4' into for-sfr)
CONFLICT (content): Merge conflict in include/linux/reiserfs_fs.h
CONFLICT (content): Merge conflict in include/linux/mfd/abx500/ab8500.h
CONFLICT (content): Merge conflict in fs/inode.c
CONFLICT (content): Merge conflict in drivers/usb/dwc3/dwc3-omap.c
Applying: reiserfs: reiserfs.h uses BUG so should include bug.h
Merging vhost/linux-next (1e05b62 sh: use the the PCI channels's io_map_bas=
e)
Merging kmap_atomic/kmap_atomic (317b6e1 feature-removal-schedule.txt: sche=
dule the deprecated form of kmap_atomic() for removal)
Merging modem-shm/for-next (3cff1cc caif_shm: Add CAIF driver for Shared me=
mory for M7400)
Merging memblock/memblock-kill-early_node_map (7bd0b0f memblock: Reimplemen=
t memblock allocation using reverse free area iterator)
Merging remoteproc/for-next (e12bc14 remoteproc: s/big switch/lookup table/)
CONFLICT (content): Merge conflict in include/linux/virtio_ids.h
Merging irqdomain/irqdomain/next (409a6f6 Merge branch 'irqdomain-for-grant=
' of git://sources.calxeda.com/kernel/linux into irqdomain/next)
CONFLICT (content): Merge conflict in arch/arm/Kconfig
Merging gpio/gpio/next (9e116f1 Merge branch 'for_3.4/gpio_more_fixes' of g=
it://gitorious.org/~tarunkanti/omap-sw-develoment/tarunkantis-linux-omap-de=
v into gpio/next)
CONFLICT (content): Merge conflict in include/linux/mfd/tps65910.h
Merging arm-soc/for-next (bc57f2e [arm-soc internal] add back contents file)
CONFLICT (content): Merge conflict in drivers/watchdog/ep93xx_wdt.c
CONFLICT (content): Merge conflict in drivers/regulator/Makefile
CONFLICT (content): Merge conflict in drivers/regulator/Kconfig
CONFLICT (content): Merge conflict in drivers/mtd/nand/atmel_nand.c
CONFLICT (content): Merge conflict in drivers/i2c/busses/i2c-gpio.c
CONFLICT (modify/delete): arch/arm/plat-mxc/audmux-v1.c deleted in HEAD and=
 modified in arm-soc/for-next. Version arm-soc/for-next of arch/arm/plat-mx=
c/audmux-v1.c left in tree.
CONFLICT (modify/delete): arch/arm/mach-vexpress/include/mach/io.h deleted =
in arm-soc/for-next and modified in HEAD. Version HEAD of arch/arm/mach-vex=
press/include/mach/io.h left in tree.
CONFLICT (content): Merge conflict in arch/arm/mach-tegra/Makefile
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/setup-sh7377.c
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/setup-sh7367.c
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/setup-r8a7740.c
CONFLICT (modify/delete): arch/arm/mach-s3c24xx/common.h deleted in arm-soc=
/for-next and modified in HEAD. Version HEAD of arch/arm/mach-s3c24xx/commo=
n.h left in tree.
CONFLICT (content): Merge conflict in arch/arm/mach-omap2/board-omap4panda.c
CONFLICT (content): Merge conflict in arch/arm/mach-omap1/board-palmz71.c
CONFLICT (content): Merge conflict in arch/arm/mach-omap1/board-palmtt.c
CONFLICT (content): Merge conflict in arch/arm/mach-omap1/board-osk.c
CONFLICT (content): Merge conflict in arch/arm/mach-omap1/board-nokia770.c
CONFLICT (content): Merge conflict in arch/arm/mach-omap1/board-ams-delta.c
CONFLICT (content): Merge conflict in arch/arm/mach-msm/timer.c
CONFLICT (content): Merge conflict in arch/arm/mach-imx/mm-imx5.c
CONFLICT (content): Merge conflict in arch/arm/mach-imx/mm-imx3.c
CONFLICT (content): Merge conflict in arch/arm/mach-imx/mach-imx27_visstrim=
_m10.c
CONFLICT (content): Merge conflict in arch/arm/mach-ep93xx/include/mach/ep9=
3xx-regs.h
CONFLICT (content): Merge conflict in arch/arm/mach-at91/cpuidle.c
CONFLICT (content): Merge conflict in arch/arm/Kconfig
CONFLICT (content): Merge conflict in Documentation/feature-removal-schedul=
e.txt
$ git rm -f arch/arm/plat-mxc/audmux-v1.c arch/arm/mach-vexpress/include/ma=
ch/io.h
Merging kvmtool/master (20082f5 kvm tools: Fix realpath() error checking)
Merging dma-mapping/dma-mapping-next (e749a9f common: DMA-mapping: add NON-=
CONSISTENT attribute)
Merging dma-buf/for-next (ff626cc Merge branch 'master' of git://git.kernel=
.org/pub/scm/linux/kernel/git/torvalds/linux into for-next)
Merging ktest/for-next (648a182 ktest: Allow a test to override REBOOT_ON_S=
UCCESS)
Merging cpuidle-cons/cpuidle_consol_pull (203b52e SH: shmobile: Consolidate=
 time keeping and irq enable)
CONFLICT (content): Merge conflict in drivers/cpuidle/cpuidle.c
CONFLICT (content): Merge conflict in arch/arm/mach-at91/cpuidle.c
CONFLICT (add/add): Merge conflict in arch/arm/include/asm/cpuidle.h
Merging scsi-post-merge/merge-base:master ()
$ git checkout akpm
Applying: mm: thp: fix pmd_bad() triggering in code paths holding mmap_sem =
read mode
Applying: mm-thp-fix-pmd_bad-triggering-in-code-paths-holding-mmap_sem-read=
-mode-checkpatch-fixes
Applying: fs/namei.c: fix warnings on 32-bit
Applying: net/netfilter/nf_conntrack_netlink.c: fix Oops on container destr=
oy
Applying: drivers/platform/x86/samsung-laptop.c: fix build
Applying: acerhdf: add support for Aspire 1410 BIOS v1.3314
Applying: acerhdf: add support for new hardware
Applying: acerhdf: lowered default temp fanon/fanoff values
Applying: arch/x86/platform/iris/iris.c: register a platform device and a p=
latform driver
Applying: intel_mid_powerbtn: mark irq as IRQF_NO_SUSPEND
Applying: x86, olpc: add debugfs interface for EC commands
Applying: x86-olpc-add-debugfs-interface-for-ec-commands v3
Applying: arch/arm/mach-ux500/mbox-db5500.c: world-writable sysfs fifo file
Applying: avr32: don't mask signals in the error path
Applying: avr32: use set_current_blocked() in handle_signal/sys_rt_sigreturn
Applying: avr32: use block_sigmask()
Applying: x86: use this_cpu_xxx to replace percpu_xxx funcs
Applying: x86: change percpu_read_stable() to this_cpu_read_stable()
Applying: net: use this_cpu_xxx replace percpu_xxx funcs
Applying: percpu: remove percpu_xxx() functions
Applying: percpu-remove-percpu_xxx-functions-fix
Applying: drivers/idle/intel_idle.c: fix confusing code identation
Applying: ia64: use set_current_blocked() and block_sigmask()
Applying: headers_check: recursively search for linux/types.h inclusion
Applying: microblaze: don't reimplement force_sigsegv()
Applying: microblaze: no need to reset handler if SA_ONESHOT
Applying: microblaze: fix signal masking
Applying: microblaze: use set_current_blocked() and block_sigmask()
Applying: MIPS: use set_current_blocked() and block_sigmask()
Applying: score: don't mask signals if we fail to setup signal stack
Applying: score: use set_current_blocked() and block_sigmask()
Applying: drivers/thermal/thermal_sys.c: fix build warning
Applying: thermal_sys: remove unnecessary line continuations
Applying: thermal_sys: remove obfuscating used-once macros
Applying: thermal_sys: kernel style cleanups
Applying: thermal_sys: convert printks to pr_<level>
Applying: thermal: add support for thermal sensor present on SPEAr13xx mach=
ines
Applying: thermal/spear_thermal: replace readl/writel with lighter _relaxed=
 variants
Applying: thermal: spear13xx: checking for NULL instead of IS_ERR()
Applying: unicore32: use block_sigmask()
Applying: net/netfilter/nfnetlink_acct.c: use linux/atomic.h
Applying: blackfin: use set_current_blocked() and block_sigmask()
Applying: ocfs2: use find_last_bit()
Applying: ocfs2: use bitmap_weight()
Applying: parisc: use set_current_blocked() and block_sigmask()
Applying: vfs: increment iversion when a file is truncated
Applying: brlocks/lglocks: cleanups
Applying: vfs: fix dup_mnt_ns
Applying: hugetlbfs: lockdep annotate root inode properly
Applying: libfs: add simple_open()
Applying: scripts/coccinelle/api/simple_open.cocci: semantic patch for simp=
le_open()
Applying: simple_open: automatically convert to simple_open()
Applying: simple_open-automatically-convert-to-simple_open-checkpatch-fixes
Applying: seq_file: fix mishandling of consecutive pread() invocations.
Applying: fs: symlink restrictions on sticky directories
Applying: fs-symlink-restrictions-on-sticky-directories-fix-2
Applying: fs: hardlink creation restrictions
Applying: fs-hardlink-creation-restrictions-fix
Applying: fs: hardlink creation restriction cleanup
Applying: xtensa: don't reimplement force_sigsegv()
Applying: xtensa: no need to reset handler if SA_ONESHOT
Applying: xtensa: don't mask signals if we fail to setup signal stack
Applying: xtensa: use set_current_blocked() and block_sigmask()
Applying: sparc: use block_sigmask()
Applying: mm, oom: avoid looping when chosen thread detaches its mm
Applying: mm, oom: fold oom_kill_task() into oom_kill_process()
Applying: mm, oom: do not emit oom killer warning if chosen thread is alrea=
dy exiting
Applying: mm, oom: introduce independent oom killer ratelimit state
Applying: mm: add rss counters consistency check
Applying: mm/vmscan.c: cleanup with s/reclaim_mode/isolate_mode/
Applying: mm: make get_mm_counter static-inline
Applying: mm: vmscan: fix misused nr_reclaimed in shrink_mem_cgroup_zone()
Applying: mm: make swapin readahead skip over holes
Applying: make-swapin-readahead-skip-over-holes-fix
Applying: vmscan: reclaim at order 0 when compaction is enabled
Applying: vmscan: kswapd carefully call compaction
Applying: vmscan-kswapd-carefully-call-compaction-fix
Applying: vmscan: only defer compaction for failed order and higher
Applying: compact_pgdat: workaround lockdep warning in kswapd
Applying: mm: compaction: make compact_control order signed
Applying: mm-compaction-make-compact_control-order-signed-fix
Applying: hugetlbfs: fix hugetlb_get_unmapped_area()
Applying: hugetlb: try to search again if it is really needed
Applying: hugetlb-try-to-search-again-if-it-is-really-needed-fix
Applying: mm: do not reset cached_hole_size when vma is unmapped
Applying: mm: search from free_area_cache for the bigger size
Applying: pagemap: avoid splitting thp when reading /proc/pid/pagemap
Applying: thp: optimize away unnecessary page table locking
Applying: fix mremap bug of failing to split thp
Applying: thp-optimize-away-unnecessary-page-table-locking-fix-checkpatch-f=
ixes
Applying: pagemap: export KPF_THP
Applying: pagemap: document KPF_THP and make page-types aware of it
Applying: pagemap: introduce data structure for pagemap entry
Applying: mm: replace PAGE_MIGRATION with IS_ENABLED(CONFIG_MIGRATION)
Applying: mm: vmscan: forcibly scan highmem if there are too many buffer_he=
ads pinning highmem
Applying: mm: move buffer_heads_over_limit check up
Applying: mm-vmscan-forcibly-scan-highmem-if-there-are-too-many-buffer_head=
s-pinning-highmem-fix-fix
Applying: mm: hugetlb: defer freeing pages when gathering surplus pages
Applying: rmap: anon_vma_prepare: Reduce code duplication by calling anon_v=
ma_chain_link
Applying: rmap: remove __anon_vma_link() declaration
Applying: vmscan: handle isolated pages with lru lock released
Applying: thp: documentation: 'transparent_hugepage=3D' can also be specifi=
ed on cmdline
Applying: mm: hugetlb: bail out unmapping after serving reference page
Applying: mm: hugetlb: cleanup duplicated code in unmapping vm range
Applying: procfs: mark thread stack correctly in proc/<pid>/maps
Applying: mm: Fix task_nommu build regression in linux-next
Applying: procfs-mark-thread-stack-correctly-in-proc-pid-maps-v3
Applying: procfs-mark-thread-stack-correctly-in-proc-pid-maps-v3-checkpatch=
-fixes
Applying: mm, oom: force oom kill on sysrq+f
Applying: tmpfs: security xattr setting on inode creation
Applying: thp: allow a hwpoisoned head page to be put back to LRU
Applying: mm: fix move/migrate_pages() race on task struct
Applying: mm-fix-move-migrate_pages-race-on-task-struct-checkpatch-fixes
Applying: mm: drain percpu lru add/rotate page-vectors on cpu hot-unplug
Applying: bootmem/sparsemem: remove limit constraint in alloc_bootmem_secti=
on
Applying: bootmem-sparsemem-remove-limit-constraint-in-alloc_bootmem_sectio=
n-fix
Applying: hugetlbfs: avoid taking i_mutex from hugetlbfs_read()
Applying: mm: don't set __GFP_WRITE on ramfs/sysfs writes
Applying: mm: use global_dirty_limit in throttle_vm_writeout()
Applying: mm: update stale lock ordering comment for memory-failure.c
Applying: mm/vmscan.c: fix spelling error
Applying: mm, memcg: pass charge order to oom killer
Applying: cpuset: mm: reduce large amounts of memory barrier related damage=
 v3
Applying: ksm: cleanup: introduce find_mergeable_vma()
Applying: hugetlb: cleanup hugetlb.h
Applying: hugepages: fix use after free bug in "quota" handling
Applying: mm, counters: remove task argument to sync_mm_rss() and __sync_ta=
sk_rss_stat()
Applying: mm, counters: fold __sync_task_rss_stat() into sync_mm_rss()
Applying: mm, hugetlb: add thread name and pid to SHM_HUGETLB mlock rlimit =
warning
Applying: hugetlbfs: fix alignment of huge page requests
Applying: hugetlbfs-fix-alignment-of-huge-page-requests-fix
Applying: hugetlb: remove prev_vma from hugetlb_get_unmapped_area_topdown()
Applying: hugetlbfs: return error code when initializing module
Applying: hugetlbfs-return-error-code-when-initializing-module-fix
Applying: page_alloc.c: remove add_from_early_node_map()
Applying: page_alloc: remove unused find_zone_movable_pfns_for_nodes() argu=
ment
Applying: numa_emulation: fix cpumask_of_node()
Applying: mmap.c: fix comment for __insert_vm_struct()
Applying: mmapc-fix-comment-for-__insert_vm_struct-fix
Applying: mm: forbid lumpy-reclaim in shrink_active_list()
Applying: swap: don't do discard if no discard option added
Applying: mm: fix page-faults detection in swap-token logic
Applying: mm: add extra free kbytes tunable
Applying: mm-add-extra-free-kbytes-tunable-update
Applying: mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes
Applying: memcg: replace MEM_CONT by MEM_RES_CTLR
Applying: memcg: replace mem and mem_cont stragglers
Applying: memcg: lru_size instead of MEM_CGROUP_ZSTAT
Applying: memcg: enum lru_list lru
Applying: memcg: remove redundant returns
Applying: memcg: remove unnecessary thp check in page stat accounting
Applying: idr: make idr_get_next() good for rcu_read_lock()
Applying: cgroup: revert ss_id_lock to spinlock
Applying: memcg: let css_get_next() rely upon rcu_read_lock()
Applying: memcg: remove PCG_CACHE page_cgroup flag
Applying: memcg-remove-pcg_cache-page_cgroup-flag-checkpatch-fixes
Applying: memcg: remove PCG_CACHE page_cgroup flag fix
Applying: memcg: kill dead prev_priority stubs
Applying: memcg: remove EXPORT_SYMBOL(mem_cgroup_update_page_stat)
Applying: memcg: simplify move_account() check
Applying: memcg-simplify-move_account-check-fix
Applying: memcg: remove PCG_MOVE_LOCK flag from page_cgroup
Applying: memcg: use new logic for page stat accounting
Applying: memcg-use-new-logic-for-page-stat-accounting-fix
Applying: memcg: fix deadlock by avoiding stat lock when anon
Applying: memcg: remove PCG_FILE_MAPPED
Applying: memcg-remove-pcg_file_mapped-fix
Applying: memcg: remove PCG_FILE_MAPPED fix cosmetic fix
Applying: memcg: remove PCG_CACHE page_cgroup flag fix2
Applying: memcg: fix performance of mem_cgroup_begin_update_page_stat()
Applying: memcg-fix-performance-of-mem_cgroup_begin_update_page_stat-fix
Applying: mm/memcontrol.c: s/stealed/stolen/
Applying: mm/memcontrol.c: remove redundant BUG_ON() in mem_cgroup_usage_un=
register_event()
Applying: mm/memcontrol.c: remove unnecessary 'break' in mem_cgroup_read()
Applying: memcg: clean up existing move charge code
Applying: thp: add HPAGE_PMD_* definitions for !CONFIG_TRANSPARENT_HUGEPAGE
Applying: memcg: avoid THP split in task migration
Applying: frv: use set_current_blocked() and block_sigmask()
Applying: sh: no need to reset handler if SA_ONESHOT
Applying: sh: use set_current_blocked() and block_sigmask()
Applying: h8300: use set_current_blocked() and block_sigmask()
Applying: alpha: use set_current_blocked() and block_sigmask()
Applying: m32r: use set_current_blocked() and block_sigmask()
Applying: m68k: use set_current_blocked() and block_sigmask()
Applying: mn10300: use set_current_blocked() and block_sigmask()
Applying: C6X: use set_current_blocked() and block_sigmask()
Applying: cpuidle: add a sysfs entry to disable specific C state for debug =
purpose.
Applying: cpuidle-add-a-sysfs-entry-to-disable-specific-c-state-for-debug-p=
urpose-fix
Applying: cris: use set_current_blocked() and block_sigmask()
Applying: cris: select GENERIC_ATOMIC64
Applying: um: don't restore current->blocked on error
Applying: um: use set_current_blocked() and block_sigmask()
Applying: um/kernel/trap.c: port OOM changes to handle_page_fault()
Applying: magic.h: move some FS magic numbers into magic.h
Applying: nmi watchdog: do not use cpp symbol in Kconfig
Applying: ceph, cifs, nfs, fuse: boolean and / or confusion
Applying: headers: include linux/types.h where appropriate
Applying: consolidate WARN_...ONCE() static variables
Applying: Remove remaining bits of io_remap_page_range()
Applying: fs/dcache.c: fix kernel-doc warnings
Applying: prctl: add PR_{SET,GET}_CHILD_SUBREAPER to allow simple process s=
upervision
Applying: prctl-add-pr_setget_child_subreaper-to-allow-simple-process-super=
vision-fix
Applying: prctl-add-pr_setget_child_subreaper-to-allow-simple-process-super=
vision-fix-fix
Applying: kernel/exit.c: if init dies, log a signal which killed it, if any
Applying: kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any-fix
Applying: powerpc/eeh: remove eeh_event_handler()->daemonize()
Applying: arch/powerpc/platforms/pseries/eeh_event.c: slightly fix set_curr=
ent_state() wart
Applying: watchdog: Make sure the watchdog thread gets CPU on loaded system
Applying: kernel/watchdog.c: convert to pr_foo()
Applying: kernel/watchdog.c: add comment to watchdog() exit path
Applying: get_maintainer: use a default "unknown" S: status/role
Applying: get_maintainer.pl: add support for moderated lists
Applying: MAINTAINERS: fix REMOTEPROC F: typo
Applying: MAINTAINERS: Update MCA section
Applying: MAINTAINERS: update git urls for 2.6 deletions
Applying: MAINTAINERS: add status to ALPHA architecture
Applying: MAINTAINERS: Add "S: Maintained" to clkdev and clk sections
Applying: MAINTAINERS: update maintainership of LTP
Applying: backlight: convert backlight i2c drivers to module_i2c_driver
Applying: backlight: convert backlight spi drivers to module_spi_driver
Applying: drivers/video/backlight/wm831x_bl.c: use devm_ functions
Applying: drivers/video/backlight: use devm_ functions
Applying: drivers/video/backlight/adp5520_bl.c: use devm_ functions
Applying: backlight: new backlight driver for LP855x devices
Applying: backlight: lp855x_bl: Add missing mutex_unlock in lp855x_read_byt=
e error path
Applying: backlight/lp855x_bl.c: check platform data in lp855x_probe()
Applying: backlight/lp855x_bl.c: small cleanups
Applying: lp855x-bl: remove unnecessary platform data
Applying: lp855x-bl: remove unnecessary headers
Applying: drivers/video/backlight/lp855x_bl.c: silence a compiler warning
Applying: backlight: add driver for Bachmann's ot200
Applying: backlight-add-driver-for-bachmanns-ot200-fix
Applying: backlight: add support for Pandora backlight
Applying: backlight-add-support-for-pandora-backlight-v2
Applying: backlight: convert platform_lcd to dev_pm_ops
Applying: backlight: fix ot200_bl build
Applying: bitops: rename for_each_set_bit_cont() in favor of analogous list=
.h function
Applying: bitops: remove for_each_set_bit_cont()
Applying: regmap: cope with bitops API change (for_each_set_bit_cont)
Applying: bitops: introduce for_each_clear_bit()
Applying: mtd: use for_each_clear_bit()
Applying: s390/char: use for_each_clear_bit()
Applying: uwb: use for_each_clear_bit()
Applying: x86: use for_each_clear_bit_from()
Applying: drivers/leds/leds-lp5521.c: fix typo
Applying: drivers/leds/leds-tca6507.c: cleanup error handling in tca6507_pr=
obe()
Applying: drivers/leds/leds-tca6507.c: remove obsolete cleanup for clientda=
ta
Applying: drivers/leds/leds-lp5521.c: add 'name' in the lp5521_led_config
Applying: drivers/leds/leds-lp5521.c: add 'update_config' in the lp5521_pla=
tform_data
Applying: drivers/leds/leds-lp5521.c: support led pattern data
Applying: leds-lp5521-support-led-pattern-data-checkpatch-fixes
Applying: drivers/leds/leds-lp5521.c: redefinition of register bits
Applying: drivers/leds/leds-lp5521.c: ret may be uninitialized
Applying: drivers/leds/leds-lp5523.c: constify some data
Applying: drivers/leds: add driver for PCA9633 I2C chip
Applying: drivers-leds-add-driver-for-pca9663-i2c-chip-fix
Applying: drivers-leds-add-driver-for-pca9663-i2c-chip-fix-2
Applying: drivers/leds/leds-pca9633.c: fix kcalloc parameters swapped
Applying: drivers/leds/leds-gpio.c: use linux/gpio.h rather than asm/gpio.h
Applying: leds-lm3530: set the max_brightness to 127
Applying: leds-lm3530: replace i2c_client with led_classdev
Applying: leds-lm3530-replace-i2c_client-with-led_classdev-fix
Applying: leds-lm3530: support pwm input mode
Applying: leds-lm3530: remove LM3530_ALS_ZONE_REG code
Applying: leds-lm3530: replace pltfm with pdata
Applying: drivers/leds/leds-pca9633.c: remove unused 'adapter' variable
Applying: drivers/leds/leds-lm3530.c: move the code setting gen_config to o=
ne place
Applying: drivers-leds-leds-lm3530c-move-the-code-setting-gen_config-to-one=
-place-fix
Applying: led-class: change back LEDS_CLASS to tristate instead of bool
Applying: string: memchr_inv speed improvements
Applying: prio_tree: remove unnecessary code in prio_tree_replace
Applying: prio_tree: cleanup prio_tree_left()/prio_tree_right()
Applying: prio_tree: simplify prio_tree_expand()
Applying: prio_tree: introduce prio_set_parent()
Applying: include/ and checkpatch: prefer __scanf to __attribute__((format(=
scanf,...)
Applying: checkpatch: add some --strict coding style checks
Applying: checkpatch-add-some-strict-coding-style-checks-v3
Applying: checkpatch.pl: be silent when -q and --ignore is given
Applying: checkpatch: catch [ ... ] usage when not at the beginning of defi=
nition
Applying: checkpatch: allow simple character constants in #defines
Applying: checkpatch: handle string concatenation in simple #defines
Applying: checkpatch: high precedence operators do not require additional p=
arentheses in #defines
Applying: checkpatch: add [] to type extensions
Applying: checkpatch: add --strict tests for braces, comments and casts
Applying: checkpatch: add --strict test for strings split across multiple l=
ines
Applying: checkpatch: Warn on use of yield()
Applying: checkpatch: whitespace - add/remove blank lines
Applying: checkpatch: suggest pr_<level> over printk(KERN_<LEVEL>
Applying: crc32: remove two instances of trailing whitespaces
Applying: crc32: move long comment about crc32 fundamentals to Documentatio=
n/
Applying: crc32-move-long-comment-about-crc32-fundamentals-to-documentation=
-fix
Applying: crc32: simplify unit test code
Applying: crc32: miscellaneous cleanups
Applying: crc32: fix mixing of endian-specific types
Applying: crc32: make CRC_*_BITS definition correspond to actual bit counts
Applying: crc32: add slice-by-8 algorithm to existing code
Applying: crc32: optimize loop counter for x86
Applying: crc32: add note about this patchset to crc32.c
Applying: crc32: bolt on crc32c
Applying: crc32: Don't reference unnecessary crc32 tables in single-bit mode
Applying: crypto: crc32c should use library implementation
Applying: crc32: add self-test code for crc32c
Applying: crc32: select an algorithm via Kconfig
Applying: epoll: comment the funky #ifdef
Applying: epoll: remove unneeded variable in reverse_path_check()
Applying: init: check printed flag to skip printing message
Applying: init/do_mounts.c: print error code on mount failure
Applying: init/do_mounts.c: create /root if it does not exist
Applying: rtc-spear: fix for balancing the enable_irq_wake in Power Mgmt
Applying: rtc/spear: fix for RTC_AIE_ON and RTC_AIE_OFF ioctl errors
Applying: rtc/rtc-spear: call platform_set_drvdata() before registering rtc=
 device
Applying: rtc: convert rtc spi drivers to module_spi_driver
Applying: rtc: convert rtc i2c drivers to module_i2c_driver
Applying: MIPS: add RTC support for loongson1B
Applying: drivers/rtc/rtc-twl.c: optimize IRQ bit access
Applying: drivers/rtc/rtc-twl.c: enable RTC irrespective of its prior state
Applying: drivers/rtc/rtc-twl.c: simplify RTC interrupt clearing
Applying: drivers/rtc/rtc-twl.c: return correct RTC event from ISR
Applying: drivers/rtc: remove IRQF_DISABLED
Applying: drivers/rtc/rtc-pm8xxx.c: make pm8xxx_rtc_pm_ops static
Applying: drivers/rtc/rtc-max8925.c: fix max8925_rtc_read_alarm() return va=
lue error
Applying: drivers/rtc/rtc-max8925.c: fix alarm->enabled mistake in max8925_=
rtc_read_alarm/max8925_rtc_set_alarm
Applying: rtc: driver for DA9052/53 PMIC v1
Applying: rtc-rtc-driver-for-da9052-53-pmic-v1-fix
Applying: rtc: ds1307: refactor chip_desc table
Applying: rtc: ds1307: simplify irq setup code
Applying: rtc: ds1307: comment and format cleanup
Applying: rtc: ds1307: generalise ram size and offset
Applying: rtc: fix rtc-ds1307 printk format warning
Applying: fat: clean up xlate_to_uni()
Applying: fat: fix bug in enforcing Long File Name length
Applying: ptrace: the killed tracee should not enter the syscall
Applying: ptrace: don't send SIGTRAP on exec if SEIZED
Applying: ptrace: don't modify flags on PTRACE_SETOPTIONS failure
Applying: ptrace: simplify PTRACE_foo constants and PTRACE_SETOPTIONS code
Applying: ptrace: make PTRACE_SEIZE set ptrace options specified in 'data' =
parameter
Applying: ptrace: renumber PTRACE_EVENT_STOP so that future new options and=
 events can match
Applying: ptrace: remove PTRACE_SEIZE_DEVEL bit
Applying: Hexagon: use set_current_blocked() and block_sigmask()
Applying: signal: give SEND_SIG_FORCED more power to beat SIGNAL_UNKILLABLE
Applying: signal: cosmetic, s/from_ancestor_ns/force/ in prepare_signal() p=
aths
Applying: signal: oom_kill_task: use SEND_SIG_FORCED instead of force_sig()
Applying: signal: zap_pid_ns_processes: s/SEND_SIG_NOINFO/SEND_SIG_FORCED/
Applying: signals: CLONE_PARENT shouldn't allow to set ->exit_signal
Applying: usermodehelper: use UMH_WAIT_PROC consistently
Applying: usermodehelper: introduce umh_complete(sub_info)
Applying: usermodehelper: implement UMH_KILLABLE
Applying: usermodehelper: kill umh_wait, renumber UMH_* constants
Applying: usermodehelper: ____call_usermodehelper() doesn't need do_exit()
Applying: kmod: introduce call_modprobe() helper
Applying: kmod: make __request_module() killable
Applying: kmod: avoid deadlock from recursive kmod call
Applying: kmod-avoid-deadlock-by-recursive-kmod-call-fix
Applying: coredump: remove VM_ALWAYSDUMP flag
Applying: coredump: add VM_NODUMP, MADV_NODUMP, MADV_CLEAR_NODUMP
Applying: coredump-add-vm_nodump-madv_nodump-madv_clear_nodump-fix
Applying: coredump-add-vm_nodump-madv_nodump-madv_clear_nodump-fix-fix
Applying: fs/proc/kcore.c: make get_sparsemem_vmemmap_info() static
Applying: proc: speedup /proc/stat handling
Applying: procfs: add num_to_str() to speed up /proc/stat
Applying: procfs-add-num_to_str-to-speed-up-proc-stat-fix
Applying: procfs: avoid breaking the ABI in /proc/stat
Applying: procfs: speed up /proc/pid/stat, statm
Applying: procfs-speed-up-proc-pid-stat-statm-checkpatch-fixes
Applying: proc: clean up /proc/<pid>/environ handling
Applying: seq_file: add seq_set_overflow(), seq_overflow()
Applying: seq_file-add-seq_set_overflow-seq_overflow-fix
Applying: smp: introduce a generic on_each_cpu_mask() function
Applying: arm: move arm over to generic on_each_cpu_mask
Applying: tile: move tile to use generic on_each_cpu_mask
Applying: smp: add func to IPI cpus based on parameter func
Applying: smp-add-func-to-ipi-cpus-based-on-parameter-func-fix
Applying: smp-add-func-to-ipi-cpus-based-on-parameter-func-update
Applying: smp-add-func-to-ipi-cpus-based-on-parameter-func-update-fix
Applying: smp: add func to IPI cpus based on parameter func
Applying: smp-add-func-to-ipi-cpus-based-on-parameter-func-v9-fix
Applying: slub: only IPI CPUs that have per cpu obj to flush
Applying: fs: only send IPI to invalidate LRU BH when needed
Applying: mm: only IPI CPUs to drain local pages if they exist
Applying: mm-only-ipi-cpus-to-drain-local-pages-if-they-exist-update
Applying: mm-only-ipi-cpus-to-drain-local-pages-if-they-exist-v9
Applying: lib/cpumask.c: remove __any_online_cpu()
Applying: arch/ia64: remove references to cpu_*_map
Applying: kexec: crash: don't save swapper_pg_dir for !CONFIG_MMU configura=
tions
Applying: kexec: add further check to crashkernel
Applying: kdump x86: fix total mem size calculation for reservation
Applying: ipc/sem.c: alternatives to preempt_disable()
Applying: ipmi: decrease the IPMI message transaction time in interrupt mode
Applying: ipmi: increase KCS timeouts
Applying: ipmi: use a tasklet for handling received messages
Applying: ipmi: fix message handling during panics
Applying: ipmi: simplify locking
Applying: ipmi: use locks on watchdog timeout set on reboot
Applying: sysctl: use bitmap library functions
Applying: sysctl: protect poll() in entries that may go away
Applying: pidns: add reboot_pid_ns() to handle the reboot syscall
Applying: pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-fix
Applying: pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-checkpatch-f=
ixes
Applying: nbd: rename the nbd_device variable from lo to nbd
Applying: fs/proc/namespaces.c: prevent crash when ns_entries[] is empty
Applying: radix-tree: introduce bit-optimized iterator
Applying: radix-tree-introduce-bit-optimized-iterator-v3
Applying: radix-tree-introduce-bit-optimized-iterator-v3-fix
Applying: radix-tree: rewrite gang lookup using iterator
Applying: radix-tree: use iterators in find_get_pages* functions
Applying: selftests: launch individual selftests from the main Makefile
Applying: selftests/Makefile: make `run_tests' depend on `all'
Applying: mm: move page-types.c from Documentation to tools/vm
Applying: mm: move slabinfo.c to tools/vm
Applying: mm: move hugepage test examples to tools/testing/selftests/vm
Applying: move-hugepage-test-examples-to-tools-testing-selftests-vm-fix
Applying: move-hugepage-test-examples-to-tools-testing-selftests-vm-fix-fix
Applying: sysctl: make kernel.ns_last_pid control dependent on CHECKPOINT_R=
ESTORE
Applying: fs, proc: introduce /proc/<pid>/task/<tid>/children entry
Applying: syscalls, x86: add __NR_kcmp syscall
Applying: syscalls-x86-add-__nr_kcmp-syscall-v8-fix
Applying: syscalls-x86-add-__nr_kcmp-syscall-v8-fix-2
Applying: c/r: procfs: add arg_start/end, env_start/end and exit_code membe=
rs to /proc/$pid/stat
Applying: c/r: prctl: extend PR_SET_MM to set up more mm_struct entries
Applying: c/r: prctl: add ability to set new mm_struct::exe_file
Applying: c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-v2
Applying: c/r: prctl: add ability to get clear_tid_address
Applying: c-r-prctl-add-ability-to-get-clear_tid_address-fix
Applying: ramoops: use pstore interface
Applying: ramoops: fix printk format warnings
Applying: notify_change(): check that i_mutex is held
Merging akpm (b2735cf notify_change(): check that i_mutex is held)

--Signature=_Thu__22_Mar_2012_17_08_29_+1100_uoko12AgP2/+jdtV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPasHdAAoJEECxmPOUX5FEf/8P/0CwnVgsdPPCjJCogcGw3X2j
axezJ/m7R/azme/MrUCnYqhk1tWIHfhjkQ2ZLRTywc3D6fTak8yq9J/OfIrKZBw7
6lANIwhveiQb5/utMgVbuiCrhGzb49PmEPPhpKDaO8YIl+RlHlRncgnQvXfLSuJd
qWP+DqVXzRWsX2BmnbWEvC5wws/D1vMY8p95yliR/ECd63uN+8gDAmlKSBew23uo
GciESBs5CwkmNua36DQeD6DREVK3gR+Uu2Y5AEFxqdVUi9gtE3qCvTPzFmad+yXN
tgZK6GRszldRnQVcCOXvTE2v5ILgbbCCR02YDN8PP8J0yL2QHm1c0ObT8zZSv9++
GHXJKb7OwySpojyc6BVPEPlk5giQ2Hx6xHhcBYqCpKeYGOOEqmOXLFvAYekZ9fux
ABYMCXFzJIoXqkf1ICuIYhbvtWnS1Y0ZyCqVQ0sReNmmYbe3Kr0G7Wa5JbV5cx4Q
HNYQVqD1UVCk9b489yWrrlIq++5esFaqTAYc6V6ttjOHJGkmu7MiYB2GD4YNXRXL
quNJx7tQ0HrJWizZwhUMz7yOld+/kYCXMP8R/R0qNMJNsF0jkLOKeZe14c2tqW8Z
+U3rBFi3ru6oRXX35I6dINl/3k+yiRdzwrJoYpBnHiAW9BBu3cjf1M3CmROvccp9
2mRk51B5ci3XULUWxr4b
=6Yh8
-----END PGP SIGNATURE-----

--Signature=_Thu__22_Mar_2012_17_08_29_+1100_uoko12AgP2/+jdtV--

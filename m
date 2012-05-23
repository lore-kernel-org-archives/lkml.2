Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756302Ab2EWHHu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 03:07:50 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:57634 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754532Ab2EWHHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 03:07:45 -0400
Date: Wed, 23 May 2012 17:07:40 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for May 23
Message-Id: <20120523170740.ae058d8d5468d471eb948c39@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__23_May_2012_17_07_40_+1000_ZE.RLuRnpNS40F1J"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__23_May_2012_17_07_40_+1000_ZE.RLuRnpNS40F1J
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20120522:

New tree: signal

With the merge window open, conflicts are moving from tree to tree.

The i386 defconfig build is still broken.

The nfs tree lost its conflict.

The rr tree gained a conflict against Linus' tree.

The mmc tree lost its conflict.

The mfd tree gained a conflict against Linus' tree and still has its build
failure so I used the version from next-20120511.

The security tree lost its conflicts.

The watchdog tree lost its conflict but gained a build failure for which
I applied a patch.

The trivial tree lost a conflict.

The edac tree lost its conflict.

The tip tree lost a conflict.

The usb tree lost its conflicts.

The staging tree lost its conflicts.

The char-misc tree lost its conflict.

The arm-soc tree lost lots of conflicts.

The signal tree gained a conflict against the tip tree.

The akpm tree lost several patches to the new signal tree.

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

We are up to 189 trees (counting Linus' and 26 trees of patches pending
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
Merging origin/master (fb09baf Merge tag 'staging-3.5-rc1' of git://git.ker=
nel.org/pub/scm/linux/kernel/git/gregkh/staging)
Merging fixes/master (b1a808f Merge branch 'for-next' of git://gitorious.or=
g/kernel-hsi/kernel-hsi)
Merging kbuild-current/rc-fixes (e88aa7b Fix modpost failures in fedora 17)
Merging arm-current/fixes (72c04af fbdev: sh_mobile_lcdc: Don't confuse lin=
e size with pitch)
Merging ep93xx-current/ep93xx-fixes (2b3c83e dmaengine/ep93xx_dma: Implemen=
t double buffering for M2M DMA channels)
Merging m68k-current/for-linus (f25e918 m68k: Setup CROSS_COMPILE at the to=
p)
Merging powerpc-merge/merge (7c0482e powerpc/irq: Fix another case of lazy =
IRQ state getting out of sync)
Merging sparc/master (29af0eb sparc32: use the common implementation of all=
oc_thread_info_node())
Merging net/master (37c106d if: restore token ring ARP type to header)
Merging sound-current/for-linus (85e184e Merge tag 'asoc-3.5' of git://git.=
kernel.org/pub/scm/linux/kernel/git/broonie/sound into for-linus)
CONFLICT (content): Merge conflict in sound/soc/mxs/mxs-saif.c
CONFLICT (content): Merge conflict in drivers/base/regmap/regmap.c
CONFLICT (content): Merge conflict in drivers/base/regmap/regmap-irq.c
CONFLICT (content): Merge conflict in drivers/base/regmap/internal.h
Merging pci-current/for-linus (314489b Merge tag 'fixes-for-linus' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc)
Merging wireless/master (a0d0d16 Merge git://git.kernel.org/pub/scm/linux/k=
ernel/git/linville/wireless-next)
Merging driver-core.current/driver-core-linus (69964ea Linux 3.4-rc5)
Merging tty.current/tty-linus (d48b97b Linux 3.4-rc6)
Merging usb.current/usb-linus (36be505 Linux 3.4-rc7)
Merging staging.current/staging-linus (69964ea Linux 3.4-rc5)
Merging char-misc.current/char-misc-linus (e816b57 Linux 3.4-rc3)
Merging input-current/for-linus (899c612 Input: synaptics - fix regression =
with "image sensor" trackpads)
Merging md-current/for-linus (b0d634d md/raid10: fix transcription error in=
 calc_sectors conversion.)
Merging audit-current/for-linus (c158a35 audit: no leading space in audit_l=
og_d_path prefix)
Merging crypto-current/master (511d63c crypto: talitos - properly lock acce=
ss to global talitos registers)
Merging ide/master (0ab3d8b cy82c693: fix PCI device selection)
Merging dwmw2/master (244dc4e Merge git://git.infradead.org/users/dwmw2/ran=
dom-2.6)
Merging sh-current/sh-fixes-for-linus (3c3c801 Merge branch 'sh/urgent' int=
o sh-fixes-for-linus)
Merging irqdomain-current/irqdomain/merge (15e06bf irqdomain: Fix debugfs f=
ormatting)
Merging devicetree-current/devicetree/merge (766644d of/irq: add empty irq_=
of_parse_and_map() for non-dt builds)
Merging spi-current/spi/merge (ba2092c spi/topcliff: use correct __devexit_=
p annotation)
Merging gpio-current/gpio/merge (7fd0fcf gpio/pch: Fix build failure when s=
elected as a module)
Merging arm/for-next (72c04af fbdev: sh_mobile_lcdc: Don't confuse line siz=
e with pitch)
Merging arm-perf/for-next/perf (b3426c5 ARM: perf: remove arm_perf_pmu_ids =
global enumeration)
Merging davinci/davinci-next (fe0d422 Linux 3.0-rc6)
Merging samsung/next-samsung (9edb240 ARM: H1940/RX1950: Change default LED=
 triggers)
Merging xilinx/arm-next (b85a3ef ARM: Xilinx: Adding Xilinx board support)
Merging blackfin/for-linus (672552a blackfin: fix build after add bf60x mac=
h/pm.h)
Merging c6x/for-linux-next (8ff98b9 C6X: remove unused config items)
Merging cris/for-next (7b91747 cris: Remove old legacy "-traditional" flag =
from arch-v10/lib/Makefile)
Merging hexagon/linux-next (4bd8193 various Kconfig cleanup and old platfor=
m build code removal)
CONFLICT (content): Merge conflict in arch/hexagon/Kconfig
Merging ia64/next (4035c6d [IA64] Liberate the signal layer from IA64 assem=
bler)
Merging m68k/for-next (f25e918 m68k: Setup CROSS_COMPILE at the top)
Merging m68knommu/for-next (7094ac0 m68k: add a defconfig for the M5475EVB =
ColdFire with MMU board)
Merging microblaze/next (258f742 modpost: Fix modpost license checking of v=
mlinux.o)
Merging mips/mips-for-linux-next (e9ade1e Merge branches 'fixes-for-linus',=
 'generic', 'cavium', 'module.h-fixes', 'next/ath79' and 'next/lantiq' into=
 mips-for-linux-next)
Merging openrisc/for-upstream (207e715 openrisc: use scratch regs in atomic=
 syscall)
Merging parisc/for-next (07e85b2 [PARISC] fix TLB fault path on PA2.0 narro=
w systems)
Merging powerpc/next (2074b1d powerpc: Fix irq distribution)
Merging 4xx/next (dce4c92 powerpc/40x: Use {upper,lower}_32_bits for msi_ph=
ys)
Merging mpc5xxx/next (f8d5842 powerpc: Option FB_FSL_DIU is not really opti=
onal for mpc512x)
Merging galak/next (fa1b42b powerpc/qe: Update the SNUM table for MPC8569 R=
ev2.0)
Merging s390/features (a7475af s390/ap: Fix wrong or missing comments)
Merging sh/sh-latest (5f19f14 sh: intc: Kill off special reservation interf=
ace.)
Merging sparc-next/master (31a6710 Fix blocking allocations called very ear=
ly during bootup)
Merging tile/master (9c27eda arch/tile: tilegx PCI root complex support)
Merging unicore32/unicore32 (0994695 Merge branch 'akpm' (aka "Andrew's pat=
ch-bomb, take two"))
Merging ceph/master (6bd9adb libceph: fix pg_temp updates)
CONFLICT (content): Merge conflict in net/ceph/osdmap.c
CONFLICT (content): Merge conflict in net/ceph/messenger.c
Merging cifs/for-next (0d0c223 cifs: fix oops while traversing open file li=
st (try #4))
Merging configfs/linux-next (b930c26 Merge branch 'for-linus' of git://git.=
kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (6cfd4b4 ecryptfs: remove the second argument of k[un=
]map_atomic())
CONFLICT (content): Merge conflict in fs/ecryptfs/ecryptfs_kernel.h
Merging ext3/for_next (0324876 ext2: trivial fix to comment for ext2_free_b=
locks)
Merging ext4/dev (f1d470b ext4: add metadata checksumming to the list of su=
pported features)
Merging fuse/for-next (203627b fuse: fix blksize calculation)
Merging gfs2/master (72c04af fbdev: sh_mobile_lcdc: Don't confuse line size=
 with pitch)
Merging logfs/master (cd8bfa9 logfs: initialize the number of iovecs in bio)
Merging nfs/linux-next (5b4498c Merge branch 'devel' into linux-next)
Merging nfsd/nfsd-next (8be4df8 nfsd4: move rq_flavor into svc_cred)
Merging ocfs2/linux-next (9392557 ocfs2: avoid unaligned access to dqc_bitm=
ap)
Merging omfs/for-next (976d167 Linux 3.1-rc9)
Merging squashfs/master (4b0180a Squashfs: add mount time sanity check for =
block_size and block_log match)
Merging v9fs/for-next (01627d9 Merge branch 'drm-fixes-intel' of git://peop=
le.freedesktop.org/~airlied/linux)
Merging ubifs/linux-next (62f38455 UBI: modify ubi_wl_flush function to cle=
ar work queue for a lnum)
Merging xfs/for-next (14c26c6 xfs: add trace points for log forces)
Merging vfs/for-next (9448152 sch_atm.c: get rid of poinless extern)
CONFLICT (modify/delete): drivers/usb/core/inode.c deleted in HEAD and modi=
fied in vfs/for-next. Version vfs/for-next of drivers/usb/core/inode.c left=
 in tree.
$ git rm -f drivers/usb/core/inode.c
Merging pci/next (5420e46 microblaze/PCI: fix "io_offset undeclared" error)
Merging hid/for-next (d53c833 Merge branch 'wacom' into for-next)
Merging quilt/i2c (f7c1584 i2c: Split I2C_M_NOSTART support out of I2C_FUNC=
_PROTOCOL_MANGLING)
Merging bjdooks-i2c/next-i2c (fc84fe1 Merge branch 'for_3.3/i2c/misc' of gi=
t://git.kernel.org/pub/scm/linux/kernel/git/khilman/linux-omap-pm into for-=
33/i2c/omap)
CONFLICT (content): Merge conflict in drivers/i2c/busses/i2c-omap.c
Merging i2c-embedded/i2c-embedded/for-next (9868a06 i2c: davinci: Free requ=
ested IRQ in remove)
CONFLICT (content): Merge conflict in arch/arm/mach-lpc32xx/common.c
Merging quilt/jdelvare-hwmon (e3a9568 hwmon: Add MCP3021 ADC driver)
Merging hwmon-staging/hwmon-next (4573acb hwmon: (it87) Make temp3 attribut=
e conditional for IT8782F)
Merging v4l-dvb/master (20a2218 Merge /home/v4l/v4l/patchwork)
CONFLICT (content): Merge conflict in drivers/staging/media/easycap/easycap=
_main.c
Merging kbuild/for-next (82f4625 Merge branches 'kbuild/kbuild' and 'kbuild=
/kconfig' into kbuild/for-next)
CONFLICT (content): Merge conflict in arch/sparc/boot/Makefile
Merging kconfig/for-next (eae1c36 Merge branch 'kconfig/for-linus-2' into k=
config/for-next)
Merging libata/NEXT (2fff275 PATA host controller driver for ep93xx)
Merging infiniband/for-next (e979fb9 Merge branch 'mlx4' into for-next)
CONFLICT (content): Merge conflict in drivers/net/ethernet/emulex/benet/be_=
main.c
CONFLICT (content): Merge conflict in drivers/net/ethernet/emulex/benet/be_=
cmds.c
CONFLICT (content): Merge conflict in drivers/net/ethernet/emulex/benet/be.h
Merging acpi/next (29bdc67 Merge branch 'pss-workaround' into next)
Merging cpupowerutils/master (f166033 cpupower tools: add install target to=
 the debug tools' makefiles)
Merging ieee1394/for-next (26c72e2 firewire: sbp2: document the absence of =
alignment requirements)
Merging ubi/linux-next (d48b97b Linux 3.4-rc6)
Merging dlm/next (75af271e dlm: NULL dereference on failure in kmem_cache_c=
reate())
Merging scsi/for-next (841f97b [SCSI] qla2xxx: don't free pool that wasn't =
allocated)
Merging target-updates/for-next (f80e8ed iscsi-target: Fix iov_count calcul=
ation bug in iscsit_allocate_iovecs)
Merging target-merge/for-next-merge (ef872d2 Merge branch 'qla-target-merge=
' into for-next-merge)
CONFLICT (add/add): Merge conflict in drivers/scsi/qla2xxx/tcm_qla2xxx.c
CONFLICT (add/add): Merge conflict in drivers/scsi/qla2xxx/qla_target.h
CONFLICT (add/add): Merge conflict in drivers/scsi/qla2xxx/qla_target.c
CONFLICT (content): Merge conflict in drivers/scsi/qla2xxx/qla_os.c
CONFLICT (content): Merge conflict in drivers/scsi/qla2xxx/qla_mbx.c
CONFLICT (content): Merge conflict in drivers/scsi/qla2xxx/qla_def.h
CONFLICT (content): Merge conflict in drivers/scsi/qla2xxx/qla_dbg.h
Merging ibft/linux-next (935a9fe ibft: Fix finding IBFT ACPI table on UEFI)
Merging isci/all (6df8ea3 merge: devel rnc-devel fixes)
Merging slave-dma/next (1dd1ea8 dmaengine: at_hdmac: take maxburst from sla=
ve configuration)
Merging dmaengine/next (a2bd114 netdma: adding alignment check for NETDMA o=
ps)
Merging net-next/master (31a6710 Fix blocking allocations called very early=
 during bootup)
Merging wireless-next/master (05f8f25 Merge branch 'for-upstream' of git://=
git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next)
Merging bluetooth/master (4433c1e Bluetooth: Remove dead int returns)
Merging mtd/master (85cd83f JFFS2: Add parameter to reserve disk space for =
root)
Merging l2-mtd/master (d9c04f2 mtd: tests: use random32 instead of home-bre=
wed generator)
CONFLICT (content): Merge conflict in drivers/mtd/nand/plat_nand.c
CONFLICT (content): Merge conflict in drivers/mtd/nand/gpmi-nand/gpmi-nand.c
CONFLICT (content): Merge conflict in arch/arm/mach-ixp4xx/ixdp425-setup.c
Merging crypto/master (ef45b83 crypto: aesni-intel - move more common code =
to ablk_init_common)
CONFLICT (content): Merge conflict in drivers/crypto/Kconfig
CONFLICT (content): Merge conflict in drivers/char/hw_random/Kconfig
CONFLICT (content): Merge conflict in arch/arm/mach-ux500/devices-common.h
Merging drm/drm-next (4d93914 drm: add plane properties)
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/intel_ringbuffer=
.c
CONFLICT (content): Merge conflict in drivers/gpu/drm/gma500/psb_drv.c
Merging sound/for-next (2d41509 Merge branch 'fix/misc' into for-next)
Merging sound-asoc/for-next (abe2c7b Merge branch 'for-3.5' into asoc-next)
Merging quilt/rr (7f14929 virtio: fix typo in comment)
CONFLICT (content): Merge conflict in Documentation/virtual/virtio-spec.txt
Merging input/next (829c4f9 Input: spear-keyboard - add device tree binding=
s)
CONFLICT (content): Merge conflict in drivers/input/tablet/wacom_wac.c
Merging input-mt/for-next (66f75a5 Linux 3.4-rc4)
Merging cgroup/for-next (0d4dde1 res_counter: Account max_usage when callin=
g res_counter_charge_nofail())
CONFLICT (content): Merge conflict in Documentation/feature-removal-schedul=
e.txt
Merging block/for-next (2173105 Merge branch 'for-3.5/drivers' into for-nex=
t)
CONFLICT (content): Merge conflict in Documentation/feature-removal-schedul=
e.txt
Merging quilt/device-mapper (053388f After the failure of a group of paths,=
 any alternative paths that need initialising do not become available until=
 further I/O is sent to the device.  Until this has happened, ioctls return=
 -EAGAIN.)
Merging embedded/master (4744b43 embedded: fix vc_translate operator preced=
ence)
Merging firmware/master (6e03a20 firmware: speed up request_firmware(), v3)
Merging pcmcia/master (80af9e6 pcmcia at91_cf: fix raw gpio number usage)
Merging mmc/mmc-next (0caaa95 mmc: at91-mci: this driver is now deprecated)
Merging kgdb/kgdb-next (3751d3e x86,kgdb: Fix DEBUG_RODATA limitation using=
 text_poke())
Merging slab/for-next (b80b6c0 Merge branch 'slab/next' into for-next)
Merging uclinux/for-next (5e442a4 Revert "proc: fix races against execve() =
of /proc/PID/fd**")
Merging md/for-next (cac3ecf md: check the return of mddev_find())
Merging mfd/for-next (6fe02e9 gpio: tps65910: dt: process gpio specific dev=
ice node info)
CONFLICT (content): Merge conflict in include/linux/i2c/twl.h
CONFLICT (content): Merge conflict in drivers/regulator/tps65910-regulator.c
CONFLICT (content): Merge conflict in drivers/mfd/da9052-core.c
CONFLICT (modify/delete): drivers/mfd/ab5500-core.c deleted in HEAD and mod=
ified in mfd/for-next. Version mfd/for-next of drivers/mfd/ab5500-core.c le=
ft in tree.
CONFLICT (content): Merge conflict in drivers/mfd/Makefile
$ git rm -f drivers/mfd/ab5500-core.c
$ git reset --hard HEAD^
Merging refs/next/20120511/mfd
CONFLICT (modify/delete): drivers/mfd/ab5500-core.c deleted in HEAD and mod=
ified in refs/next/20120511/mfd. Version refs/next/20120511/mfd of drivers/=
mfd/ab5500-core.c left in tree.
$ git rm -f drivers/mfd/ab5500-core.c
[master 74e1e69] Merge commit 'refs/next/20120511/mfd'
Merging battery/master (96facd2 smb347-charger: Include missing <linux/err.=
h>)
Merging fbdev/fbdev-next (5e7b911 drivers/video: fsl-diu-fb: don't initiali=
ze the THRESHOLDS registers)
Merging viafb/viafb-next (838ac78 viafb: avoid refresh and mode lookup in s=
et_par)
Merging omap_dss2/for-next (05dd0f5 OMAPDSS: DISPC: Update Accumulator conf=
iguration for chroma plane)
Merging regulator/for-next (7c1e25b regulator: palmas: Fix wrong kfree call=
s)
Merging security/next (ff2bb04 Merge branch 'master' of git://git.infradead=
.org/users/eparis/selinux into next)
Merging selinux/master (c737f82 SELinux: remove unused common_audit_data in=
 flush_unauthorized_files)
Merging lblnet/master (7e27d6e Linux 2.6.35-rc3)
Merging watchdog/master (d194a8f watchdog: Add support for dynamically allo=
cated watchdog_device structs)
Merging dwmw2-iommu/master (c3b92c8 Linux 3.1)
Merging iommu/next (ce74cec Merge branches 'iommu/fixes', 'dma-debug', 'arm=
/omap' and 'arm/tegra' into next)
Merging osd/linux-next (8b56a30 exofs:  Add SYSFS info for autologin/pNFS e=
xport)
Merging jc_docs/docs-next (5c050fb docs: update the development process doc=
ument)
Merging trivial/for-next (f70d4a9 edac, mips: don't change code that has be=
en removed in edac/mips tree)
CONFLICT (modify/delete): sound/soc/imx/Kconfig deleted in HEAD and modifie=
d in trivial/for-next. Version trivial/for-next of sound/soc/imx/Kconfig le=
ft in tree.
CONFLICT (modify/delete): arch/mips/lantiq/xway/gpio_stp.c deleted in HEAD =
and modified in trivial/for-next. Version trivial/for-next of arch/mips/lan=
tiq/xway/gpio_stp.c left in tree.
CONFLICT (modify/delete): arch/mips/lantiq/xway/gpio_ebu.c deleted in HEAD =
and modified in trivial/for-next. Version trivial/for-next of arch/mips/lan=
tiq/xway/gpio_ebu.c left in tree.
$ git rm -f sound/soc/imx/Kconfig arch/mips/lantiq/xway/gpio_ebu.c arch/mip=
s/lantiq/xway/gpio_stp.c
Merging audit/for-next (dcd6c92 Linux 3.3-rc1)
Merging pm/linux-next (e374831 Merge branch 'master' into linux-next)
Merging apm/for-next (f283d22 APM: fix deadlock in APM_IOC_SUSPEND ioctl)
Merging fsnotify/for-next (1aec9c0 inotify: automatically restart syscalls)
Merging edac/linux_next (6bd3dbf edac_mc: check for allocation failure in e=
dac_mc_alloc())
CONFLICT (content): Merge conflict in drivers/edac/edac_device.c
Merging edac-amd/for-next (305f1c3 Merge branch '3.3-pci_device_id' into ed=
ac-for-next)
CONFLICT (content): Merge conflict in drivers/edac/amd64_edac.c
CONFLICT (content): Merge conflict in Documentation/edac.txt
Merging devicetree/devicetree/next (8d6c1ef Merge branch 'devicetree/merge'=
 into devicetree/next)
Merging spi/spi/next (d8e328b spi: Add "spi:" prefix to modalias attribute =
of spi devices)
Merging tip/auto-latest (bf474fd Merge branch 'irq/core')
CONFLICT (content): Merge conflict in mm/memory.c
CONFLICT (content): Merge conflict in arch/x86/Kconfig
CONFLICT (content): Merge conflict in arch/tile/Kconfig
CONFLICT (content): Merge conflict in arch/sparc/Kconfig
CONFLICT (content): Merge conflict in arch/sh/kernel/process.c
CONFLICT (content): Merge conflict in arch/hexagon/Kconfig
CONFLICT (content): Merge conflict in arch/arm/Kconfig
CONFLICT (content): Merge conflict in Makefile
Applying: kbuild: merge fix for sorting exceptions tables at build time
Applying: sched, numa: Allocate node_queue on any node for offline nodes
Merging rcu/rcu/next (860e1cc rcu: Fix broken strings in RCU's source code.)
Merging cputime/cputime (c3e0ef9 [S390] fix cputime overflow in uptime_proc=
_show)
Merging uprobes/for-next (0326f5a uprobes/core: Handle breakpoint and singl=
estep exceptions)
Merging kmemleak/kmemleak (4878677 kmemleak: do not leak object after tree =
insertion error)
Merging kvm/linux-next (322728e KVM: make asm-generic/kvm_para.h have an if=
def __KERNEL__ block)
CONFLICT (content): Merge conflict in arch/x86/include/asm/kvm_para.h
CONFLICT (content): Merge conflict in arch/powerpc/kvm/book3s_segment.S
CONFLICT (content): Merge conflict in Documentation/feature-removal-schedul=
e.txt
Merging kvm-ppc/kvm-ppc-next (5104b17 KVM: PPC: Not optimizing MSR_CE and M=
SR_ME with paravirt.)
Merging oprofile/for-next (c16fa4f Linux 3.3)
Merging xen/upstream/xen (af3a3ab Merge git://git.kernel.org/pub/scm/linux/=
kernel/git/steve/gfs2-3.0-fixes)
Merging xen-two/linux-next (105228a Merge branch 'stable/for-linus-3.5' int=
o linux-next)
Merging xen-pvhvm/linux-next (b056b6a xen: suspend: remove xen_hvm_suspend)
Merging percpu/for-next (641b695 percpu: remove percpu_xxx() functions)
CONFLICT (content): Merge conflict in arch/x86/mm/tlb.c
Merging workqueues/for-next (4d82a1d lockdep: fix oops in processing workqu=
eue)
Merging drivers-x86/linux-next (ad229c5 toshiba_acpi: Add support for trans=
flective LCD)
Merging hwpoison/hwpoison (46e387b Merge branch 'hwpoison-hugepages' into h=
wpoison)
Merging sysctl/master (4e474a0 sysctl: protect poll() in entries that may g=
o away)
Merging regmap/for-next (c948ef3 mfd: palmas PMIC device support Kconfig)
Merging hsi/for-next (43139a6 HSI: hsi_char: Update ioctl-number.txt)
Merging driver-core/driver-core-next (94ca629 uio_pdrv_genirq: get irq thro=
ugh platform resource if not set otherwise)
Merging tty/tty-next (59bd234 serial: bfin_uart: Make MMR access compatible=
 with 32 bits bf609 style controller.)
Merging usb/usb-next (cda4db5 Merge tag 'for-usb-next-2012-05-21' of git://=
git.kernel.org/pub/scm/linux/kernel/git/sarah/xhci into usb-next)
Merging staging/staging-next (c3c6cc9 Staging: bcm: Remove two unused varia=
bles from Adapter.h)
Merging char-misc/char-misc-next (9912143 parport: remove unused dead code =
from lowlevel drivers)
Merging tmem/linux-next (0f1ea93 Merge branch 'stable/frontswap.v14' into l=
inux-next)
Merging writeback/writeback-for-next (169ebd9 writeback: Avoid iput() from =
flusher thread)
Merging arm-dt/devicetree/arm-next (ede338f dt: add documentation of ARM dt=
 boot interface)
Merging hwspinlock/linux-next (8b37fcf hwspinlock: add MAINTAINERS entries)
Merging pinctrl/for-next (4f6a16b pinctrl: pinctrl-imx: add imx51 pinctrl d=
river)
Merging tegra/for-next (ef14f5c Merge branch 'for-3.5/defconfig2' into for-=
next)
Merging moduleh/for-sfr (bb8187d MCA: delete all remaining traces of microc=
hannel bus support.)
Merging vhost/linux-next (53ffd22 virtio-net: remove useless disable on fre=
eze)
CONFLICT (content): Merge conflict in drivers/net/virtio_net.c
Merging kmap_atomic/kmap_atomic (317b6e1 feature-removal-schedule.txt: sche=
dule the deprecated form of kmap_atomic() for removal)
Merging modem-shm/for-next (3cff1cc caif_shm: Add CAIF driver for Shared me=
mory for M7400)
CONFLICT (content): Merge conflict in drivers/Kconfig
Merging memblock/memblock-kill-early_node_map (7bd0b0f memblock: Reimplemen=
t memblock allocation using reverse free area iterator)
Merging remoteproc/for-next (d48b97b Linux 3.4-rc6)
Merging irqdomain/irqdomain/next (a87487e irqdomain: Document size paramete=
r of irq_domain_add_linear())
Merging gpio/gpio/next (3e11f7b gpio/generic: initialize basic_mmio_gpio sh=
adow variables properly)
CONFLICT (content): Merge conflict in drivers/gpio/gpio-samsung.c
Merging arm-soc/for-next (71d6afd Merge branch 'late/board' into for-next)
CONFLICT (content): Merge conflict in lib/Makefile
CONFLICT (content): Merge conflict in drivers/gpio/gpio-samsung.c
CONFLICT (content): Merge conflict in drivers/gpio/gpio-mxs.c
CONFLICT (content): Merge conflict in drivers/dma/imx-sdma.c
CONFLICT (content): Merge conflict in arch/arm/plat-omap/counter_32k.c
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/Makefile
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/Kconfig
CONFLICT (content): Merge conflict in arch/arm/mach-omap2/board-omap4panda.c
CONFLICT (content): Merge conflict in arch/arm/mach-mmp/ttc_dkb.c
Merging ep93xx/ep93xx-cleanup (a1eacd7 arm: ep93xx: use gpio_led_register_d=
evice)
Merging renesas/next (76ab1e9 Merge branch 'renesas-emev2' into renesas-nex=
t)
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/Makefile
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/Kconfig
Merging s5p/for-next (3bd5eba Merge branch 'next/board-samsung-2' into for-=
next)
CONFLICT (content): Merge conflict in arch/arm/mach-exynos/Kconfig
Merging kvmtool/master (cdb90a0 kvm tools: increase amount of virtio-9p FID=
s)
Merging dma-mapping/dma-mapping-next (b7ef7df Merge branch 'for-next-other'=
 into for-next)
CONFLICT (content): Merge conflict in arch/x86/include/asm/dma-mapping.h
Merging dma-buf/for-next (700cbdb dma-buf: add vmap interface)
Merging userns/for-next (4b06a81 userns:  Silence silly gcc warning.)
CONFLICT (content): Merge conflict in include/linux/sched.h
CONFLICT (content): Merge conflict in fs/stat.c
Applying: userns: fix up for user_ns move to struct cred
Merging ktest/for-next (648a182 ktest: Allow a test to override REBOOT_ON_S=
UCCESS)
Merging scsi-post-merge/merge-base:master ()
Merging signal/for-next (8e5ad56 Merge remote branch 'um/for-linus' into fo=
r-next)
CONFLICT (content): Merge conflict in arch/um/Kconfig.common
$ git checkout akpm
Applying: pagemap.h: fix warning about possibly used before init var
Applying: umem: fix up unplugging
Applying: cciss: fix incorrect scsi status reporting
Applying: arch/x86/platform/iris/iris.c: register a platform device and a p=
latform driver
Applying: arch/x86/include/asm/spinlock.h: fix comment
Applying: cpuidle: remove unused hrtimer_peek_ahead_timers() call
Applying: cpuidle: add checks to avoid NULL pointer dereference
Applying: cris: select GENERIC_ATOMIC64
Applying: timeconst.pl: remove deprecated defined(@array)
Applying: drivers/thermal/spear_thermal.c: add Device Tree probing capabili=
ty
Applying: ocfs2: use find_last_bit()
Applying: ocfs2: use bitmap_weight()
Applying: drivers/scsi/ufs: use module_pci_driver
Applying: drivers/scsi/ufs: reverse the ufshcd_is_device_present logic
Applying: drivers/scsi/ufs: fix incorrect return value about SUCCESS and FA=
ILED
Applying: drivers/scsi/atp870u.c: fix bad use of udelay
Applying: vfs: increment iversion when a file is truncated
Applying: fs: symlink restrictions on sticky directories
Applying: fs: hardlink creation restrictions
Applying: fsnotify: remove unused parameter from send_to_group()
Applying: fsnotify: handle subfiles' perm events
Applying: mm/memory_failure: let the compiler add the function name
Applying: mm/mempolicy.c: use enum value MPOL_REBIND_ONCE in mpol_rebind_po=
licy()
Applying: mm/hugetlb.c: use long vars instead of int in region_count()
Applying: mm, thp: remove unnecessary ret variable
Applying: mm, thp: allow fallback when pte_alloc_one() fails for huge pmd
Applying: mm: remove swap token code
Applying: mm: vmscan: remove lumpy reclaim
Applying: mm: vmscan: do not stall on writeback during memory compaction
Applying: mm: vmscan: remove reclaim_mode_t
Applying: hugetlb: rename max_hstate to hugetlb_max_hstate
Applying: hugetlbfs: don't use ERR_PTR with VM_FAULT* values
Applying: hugetlbfs: add an inline helper for finding hstate index
Applying: hugetlb: use mmu_gather instead of a temporary linked list for ac=
cumulating pages
Applying: hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-acc=
umulating-pages-fix
Applying: hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-acc=
umulating-pages-fix-fix
Applying: hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-acc=
umulating-pages-fix-2
Applying: hugetlb: avoid taking i_mmap_mutex in unmap_single_vma() for huge=
tlb
Applying: hugetlb: simplify migrate_huge_page()
Applying: memcg: add HugeTLB extension
Applying: memcg-add-hugetlb-extension-fix
Applying: memcg-add-hugetlb-extension-fix-fix
Applying: hugetlb: add charge/uncharge calls for HugeTLB alloc/free
Applying: memcg: track resource index in cftype private
Applying: hugetlbfs: add memcg control files for hugetlbfs
Applying: memcg: use scnprintf instead of sprintf
Applying: hugetlbfs-add-memcg-control-files-for-hugetlbfs-use-scnprintf-ins=
tead-of-sprintf-fix
Applying: hugetlbfs: add a list for tracking in-use HugeTLB pages
Applying: memcg: move HugeTLB resource count to parent cgroup on memcg remo=
val
Applying: memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-remov=
al-fix
Applying: memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-remov=
al-fix-fix
Applying: hugetlb: migrate memcg info from oldpage to new page during migra=
tion
Applying: hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migrat=
ion-fix
Applying: hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-acc=
umulating-pages-fix-2
Applying: memcg: add memory controller documentation for hugetlb management
Applying: mm: fix off-by-one bug in print_nodes_state()
Applying: mm: use kcalloc() instead of kzalloc() to allocate array
Applying: mm/mmap.c: find_vma(): remove unnecessary if(mm) check
Applying: mm-mmapc-find_vma-remove-unnecessary-ifmm-check-fix
Applying: mm/fork: fix overflow in vma length when copying mmap on clone
Applying: mm/vmstat.c: remove debug fs entries on failure of file creation =
and made extfrag_debug_root dentry local
Applying: mm: correctly synchronize rss-counters at exit/exec
Applying: thp, memcg: split hugepage for memcg oom on cow
Applying: mm: do_migrate_pages() calls migrate_to_node() even if task is al=
ready on a correct node
Applying: mm-do_migrate_pages-calls-migrate_to_node-even-if-task-is-already=
-on-a-correct-node-fix
Applying: mm: do_migrate_pages(): rename arguments
Applying: kernel: cgroup: push rcu read locking from css_is_ancestor() to c=
allsite
Applying: mm: memcg: count pte references from every member of the reclaime=
d hierarchy
Applying: mm-memcg-count-pte-references-from-every-member-of-the-reclaimed-=
hierarchy-fix
Applying: mm: rename is_mlocked_vma() to mlocked_vma_newpage()
Applying: mm-rename-is_mlocked_vma-to-mlocked_vma_newpage-fix
Applying: mm, thp: drop page_table_lock to uncharge memcg pages
Applying: Documentation: memcg: future proof hierarchical statistics docume=
ntation
Applying: Cross Memory Attach: make it Kconfigurable
Applying: bug: introduce BUILD_BUG_ON_INVALID() macro
Applying: bug: completely remove code generated by disabled VM_BUG_ON()
Applying: x86: print e820 physical addresses consistently with other parts =
of kernel
Applying: x86: print physical addresses consistently with other parts of ke=
rnel
Applying: swiotlb: print physical addresses consistently with other parts o=
f kernel
Applying: mm: print physical addresses consistently with other parts of ker=
nel
Applying: kbuild: install kernel-page-flags.h
Applying: tools/vm/page-types.c: cleanups
Applying: mm: move is_vma_temporary_stack() declaration to huge_mm.h
Applying: mm/page_alloc.c: remove pageblock_default_order()
Applying: mm: bootmem: fix checking the bitmap when finally freeing bootmem
Applying: mm: bootmem: remove redundant offset check when finally freeing b=
ootmem
Applying: mm: bootmem: rename alloc_bootmem_core to alloc_bootmem_bdata
Applying: mm: bootmem: split out goal-to-node mapping from goal dropping
Applying: mm: bootmem: allocate in order node+goal, goal, node, anywhere
Applying: mm: bootmem: unify allocation policy of (non-)panicking node allo=
cations
Applying: mm: nobootmem: panic on node-specific allocation failure
Applying: mm: nobootmem: unify allocation policy of (non-)panicking node al=
locations
Applying: mm: bootmem: pass pgdat instead of pgdat->bdata down the stack
Applying: mm: remove sparsemem allocation details from the bootmem allocator
Applying: mm-remove-sparsemem-allocation-details-from-the-bootmem-allocator=
-fix
Applying: mm: compaction: handle incorrect MIGRATE_UNMOVABLE type pageblocks
Applying: memcg: fix/change behavior of shared anon at moving task
Applying: memcg swap: mem_cgroup_move_swap_account never needs fixup
Applying: memcg swap: use mem_cgroup_uncharge_swap()
Applying: mm/memcg: scanning_global_lru means mem_cgroup_disabled
Applying: mm/memcg: move reclaim_stat into lruvec
Applying: mm: push lru index into shrink_[in]active_list()
Applying: mm-push-lru-index-into-shrink_active_list-fix
Applying: mm: mark mm-inline functions as __always_inline
Applying: mm: remove lru type checks from __isolate_lru_page()
Applying: mm/memcg: kill mem_cgroup_lru_del()
Applying: memcg: mark more functions/variables as static
Applying: memcg: remove unused variable
Applying: memcg: mark stat field of mem_cgroup struct as __percpu
Applying: memcg: remove redundant parentheses
Applying: memcg: make threshold index in the right position
Applying: memcg: revise the position of threshold index while unregistering=
 event
Applying: mm/memcg: use vm_swappiness from target memory cgroup
Applying: memcg: add mlock statistic in memory.stat
Applying: memcg-add-mlock-statistic-in-memorystat-fix
Applying: mm/vmscan: store "priority" in struct scan_control
Applying: mm: add link from struct lruvec to struct zone
Applying: mm/vmscan: push lruvec pointer into isolate_lru_pages()
Applying: mm/vmscan: push zone pointer into shrink_page_list()
Applying: mm/vmscan: remove update_isolated_counts()
Applying: mm/vmscan: push lruvec pointer into putback_inactive_pages()
Applying: mm/vmscan: replace zone_nr_lru_pages() with get_lruvec_size()
Applying: mm/vmscan: push lruvec pointer into inactive_list_is_low()
Applying: mm/vmscan: push lruvec pointer into shrink_list()
Applying: mm/vmscan: push lruvec pointer into get_scan_count()
Applying: mm/vmscan: push lruvec pointer into should_continue_reclaim()
Applying: mm/vmscan: kill struct mem_cgroup_zone
Applying: security/keys/keyctl.c: suppress memory allocation failure warning
Applying: um/kernel/trap.c: port OOM changes to handle_page_fault()
Applying: sgi-xp: use lockdep_assert_held()
Applying: drivers/scsi/aha152x.c: remove broken usage of spin_is_locked()
Applying: XFS: fix lock ASSERT on UP
Applying: mm/huge_memory.c: use lockdep_assert_held()
Applying: futex: use lockdep_assert_held() for lock checking
Applying: drivers/net/irda/sir_dev.c: remove spin_is_locked()
Applying: drivers/net/ethernet/smsc/smsc911x.h: use lockdep_assert_held() i=
nstead of home grown buggy construct
Applying: spinlocks.txt: add a discussion on why spin_is_locked() is bad
Applying: spinlockstxt-add-a-discussion-on-why-spin_is_locked-is-bad-fix
Applying: include/linux/spinlock.h: add a kerneldoc comment to spin_is_lock=
ed() that discourages its use
Applying: checkpatch: check for spin_is_locked()
Applying: CodingStyle: add kmalloc_array() to memory allocators
Applying: introduce SIZE_MAX
Applying: locking: add KERN_CONT when needed to self test
Applying: x86, NMI: add missing KERN_CONT to NMI selftest
Applying: ISDN: add missing KERN_CONT
Applying: clk: add non CONFIG_HAVE_CLK routines
Applying: clk: remove redundant depends on from drivers/Kconfig
Applying: i2c/i2c-pxa: remove conditional compilation of clk code
Applying: usb/marvell: remove conditional compilation of clk code
Applying: usb/musb: remove conditional compilation of clk code
Applying: ata/pata_arasan: remove conditional compilation of clk code
Applying: ata/sata_mv: remove conditional compilation of clk code
Applying: net/c_can: remove conditional compilation of clk code
Applying: net/stmmac: remove conditional compilation of clk code
Applying: gadget/m66592: remove conditional compilation of clk code
Applying: gadget/r8a66597: remove conditional compilation of clk code
Applying: usb/host/r8a66597: remove conditional compilation of clk code
Applying: kernel/resource.c: correct the comment of allocate_resource()
Applying: sethostname/setdomainname: notify userspace when there is a chang=
e in uts_kern_table
Applying: NMI watchdog: fix for lockup detector breakage on resume
Applying: nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix
Applying: nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix-fix-f=
ix
Applying: nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix-fix
Applying: watchdog: fix for lockup detector breakage on resume
Applying: nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-v2-fix
Applying: task_work_add: generic process-context callbacks
Applying: genirq: reimplement exit_irq_thread() hook via task_work_add()
Applying: keys: change keyctl_session_to_parent() to use task_work_add()
Applying: keys: kill the dummy key_replace_session_keyring()
Applying: keys: kill task_struct->replacement_session_keyring
Applying: kernel/irq/manage.c: use the pr_foo() infrastructure to prefix pr=
intks
Applying: vsprintf: correctly handle width when '#' flag used in %#p format.
Applying: vsprintf-correctly-handle-width-when-flag-used-in-%p-format-check=
patch-fixes
Applying: vsprintf: further optimize decimal conversion
Applying: vsprintf-further-optimize-decimal-conversion-v2
Applying: vsprintf-further-optimize-decimal-conversion-checkpatch-fixes
Applying: hamradio/scc: orphan driver in MAINTAINERS
Applying: MAINTAINERS: remove Alessandro
Applying: blacklight: remove redundant spi driver bus initialization
Applying: lcd: add callbacks for early fb event blank support
Applying: fbdev: add events for early fb event support
Applying: drivers/video/backlight/apple_bl.c: include header for exported s=
ymbol prototypes
Applying: drivers-video-backlight-apple_blc-include-header-for-exported-sym=
bol-prototypes-fix
Applying: backlight: add LM3533 backlight driver
Applying: backlight-add-lm3533-backlight-driver-fix
Applying: backlight-add-lm3533-backlight-driver-fix-fix
Applying: drivers/leds/leds-lp5521.c: fix lp5521_read() error handling
Applying: leds: driver for DA9052/53 PMIC v2
Applying: leds-led-module-for-da9052-53-pmic-v2-fix
Applying: leds: add LED driver for lm3556 chip
Applying: leds-add-led-driver-for-lm3556-chip-checkpatch-fixes
Applying: leds: lm3556: don't call kfree for the memory allocated by devm_k=
zalloc
Applying: leds: simple_strtoul() cleanup
Applying: leds: Use kcalloc instead of kzalloc to allocate array
Applying: leds: add new field to led_classdev struct to save activation sta=
te
Applying: leds: change existing triggers to use activated flag
Applying: leds: change ledtrig-timer to use activated flag
Applying: include/linux/led-lm3530.h: comment correction about the range of=
 brightness
Applying: drivers/leds/leds-lm3530.c: simplify als configuration on initial=
ization
Applying: leds: heartbeat: stop on shutdown
Applying: leds-heartbeat-stop-on-shutdown-v5
Applying: leds-heartbeat-stop-on-shutdown-checkpatch-fixes
Applying: leds: add new transient trigger for one shot timer activation
Applying: drivers/leds/leds-pca955x.c: fix race condition while setting bri=
ghtness on several LEDs
Applying: list_debug: WARN for adding something already in the list
Applying: lib/test-kstrtox.c: mark const init data with __initconst instead=
 of __initdata
Applying: lib/string_helpers.c: make arrays static
Applying: lib/bitmap.c: fix documentation for scnprintf() functions
Applying: vsprintf: fix %ps on non symbols when using kallsyms
Applying: spinlock_debug: print kallsyms name for lock
Applying: radix-tree: fix preload vector size
Applying: lib/vsprintf.c: "%#o",0 becomes '0' instead of '00'
Applying: checkpatch: suggest pr_<level> over printk(KERN_<LEVEL>
Applying: init: disable sparse checking of the mount.o source files
Applying: rtc/spear: add Device Tree probing capability
Applying: drivers/rtc/rtc-ep93xx.c: convert to use module_platform_driver()
Applying: rtc: add ioctl to get/clear battery low voltage status
Applying: drivers/rtc/rtc-pcf8563.c: add RTC_VL_READ/RTC_VL_CLR ioctl featu=
re
Applying: drivers/rtc/Kconfig: place RTC_DRV_IMXDI and RTC_MXC under "on-CP=
U RTC drivers"
Applying: rtc: rename CONFIG_RTC_MXC to CONFIG_RTC_DRV_MXC
Applying: rtc-rename-config_rtc_mxc-to-config_rtc_drv_mxc-fix
Applying: rtc: ds1307: remove superfluous initialization
Applying: rtc: ds1307: add trickle charger support
Applying: drivers/rtc/rtc-m41t93.c: don't let get_time() reset M41T93_FLAG_=
OF
Applying: drivers/rtc/rtc-lpc32xx.c: add device tree support
Applying: nilfs2: flush disk caches in syncing
Applying: HPFS: remove PRINTK() macro
Applying: fat: introduce special inode for managing the FSINFO block
Applying: fat: introduce mark_fsinfo_dirty helper
Applying: fat: mark superblock as dirty less often
Applying: fat: switch to fsinfo_inode
Applying: kmod: unexport call_usermodehelper_freeinfo()
Applying: kmod: convert two call sites to call_usermodehelper_fns()
Applying: kmod: move call_usermodehelper_fns() to .c file and unexport all =
it's helpers
Applying: kmod.c: fix kernel-doc warning
Applying: kmod: avoid deadlock from recursive kmod call
Applying: cred: remove task_is_dead() from __task_cred() validation
Applying: stack usage: add pid to warning printk in check_stack_usage
Applying: proc: clean up /proc/<pid>/environ handling
Applying: proc-clean-up-proc-pid-environ-handling-checkpatch-fixes
Applying: proc: unify ptrace_may_access() locking code
Applying: proc: remove mm_for_maps()
Applying: proc: use mm_access() instead of ptrace_may_access()
Applying: proc: don't do dummy rcu_read_lock/rcu_read_unlock on error path
Applying: proc: pass "fd" by value in /proc/*/{fd,fdinfo} code
Applying: procfs: use more apprioriate types when dumping /proc/N/stat
Applying: proc: report file/anon bit in /proc/pid/pagemap
Applying: proc/smaps: carefully handle migration entries
Applying: proc/smaps: show amount of nonlinear ptes in vma
Applying: proc/smaps: show amount of hwpoison pages
Applying: proc: use IS_ERR_OR_NULL()
Applying: fork: call complete_vfork_done() after clearing child_tid and flu=
shing rss-counters
Applying: cpu: introduce clear_tasks_mm_cpumask() helper
Applying: arm: use clear_tasks_mm_cpumask()
Applying: powerpc: use clear_tasks_mm_cpumask()
Applying: sh: use clear_tasks_mm_cpumask()
Applying: blackfin: a couple of task->mm handling fixes
Applying: blackfin: fix possible deadlock in decode_address()
Applying: um: should hold tasklist_lock while traversing processes
Applying: um: fix possible race on task->mm
Applying: um: properly check all process' threads for a live mm
Applying: kernel/cpu.c: document clear_tasks_mm_cpumask()
Applying: kernel-cpuc-document-clear_tasks_mm_cpumask-fix
Applying: ipc/sem.c: alternatives to preempt_disable()
Applying: ipc/mqueue: cleanup definition names and locations
Applying: ipc/mqueue: switch back to using non-max values on create
Applying: ipc/mqueue: enforce hard limits
Applying: ipc/mqueue: update maximums for the mqueue subsystem
Applying: ipc/mqueue: using vmalloc requires including vmalloc.h
Applying: mqueue: revert bump up DFLT_*MAX
Applying: mqueue: don't use kmalloc with KMALLOC_MAX_SIZE
Applying: mqueue: separate mqueue default value from maximum value
Applying: selftests: add mq_open_tests
Applying: ipc/mqueue: improve performance of send/recv
Applying: ipc-mqueue-improve-performance-of-send-recv-fix
Applying: ipc/mqueue: correct mq_attr_ok test
Applying: ipc-mqueue-correct-mq_attr_ok-test-fix
Applying: ipc/mqueue: strengthen checks on mqueue creation
Applying: ipc-mqueue-strengthen-checks-on-mqueue-creation-fix
Applying: tools/selftests: add mq_perf_tests
Applying: tools-selftests-add-mq_perf_tests-checkpatch-fixes
Applying: rapidio: add DMA engine support for RIO data transfers
Applying: rapidio/tsi721: add DMA engine support
Applying: pidns: use task_active_pid_ns in do_notify_parent
Applying: pidns: guarantee that the pidns init will be the last pidns proce=
ss reaped
Applying: pidns: make killed children autoreap
Applying: pidns-make-killed-children-autoreap-checkpatch-fixes
Applying: eventfd: change int to __u64 in eventfd_signal()
Applying: eventfd-change-int-to-__u64-in-eventfd_signal-fix
Applying: aio/vfs: cleanup of rw_copy_check_uvector() and compat_rw_copy_ch=
eck_uvector()
Applying: sysctl: make kernel.ns_last_pid control dependent on CHECKPOINT_R=
ESTORE
Applying: fs, proc: introduce /proc/<pid>/task/<tid>/children entry
Applying: c/r: fs, proc: Move children entry back to tid_base_stuff
Applying: syscalls, x86: add __NR_kcmp syscall
Applying: syscalls-x86-add-__nr_kcmp-syscall-v8 comment update
Applying: syscalls-x86-add-__nr_kcmp-syscall-v8-comment-update-fix
Applying: c/r: procfs: add arg_start/end, env_start/end and exit_code membe=
rs to /proc/$pid/stat
Applying: c/r: prctl: extend PR_SET_MM to set up more mm_struct entries
Applying: c/r: prctl: simplify PR_SET_MM on mm::code/data assignment
Applying: c-r-prctl-simplify-pr_set_mm-on-mm-code-data-assignment-fix
Applying: c/r: prctl: return -EFAULT instead of -EINVAL in case if underlie=
d VMA is not found
Applying: c/r: prctl: add ability to set new mm_struct::exe_file
Applying: c/r: prctl: update prctl_set_mm_exe_file() after mm->num_exe_file=
_vmas removal
Applying: c/r: prctl: add ability to get clear_tid_address
Applying: c/r: prctl: drop VMA flags test on PR_SET_MM_ stack data assignme=
nt
Applying: kconfig: update compression algorithm info
Applying: notify_change(): check that i_mutex is held
Applying: isdn-add-missing-kern_cont-fix
Merging quilt/akpm (900cd0f isdn-add-missing-kern_cont-fix)
Applying: sparc: fix bad merge of sparc Kconfig
Applying: watchdog: usin IS_ERR needs linux/err.h

--Signature=_Wed__23_May_2012_17_07_40_+1000_ZE.RLuRnpNS40F1J
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPvIy8AAoJEECxmPOUX5FEnLYP/399NPCL7e/LdVCNkwWud7le
RDzaqDbSwzmRC07ppLoK84iAt0SY5aXlqEqEGu+Akwln+IqMAB0tbfx6WyGm1th8
Glgg+ouCnPx5oM7uayz9GDKeYhZsMIvCAZcWFrqiyu0zfWNl29uWd91cHubc5xSY
3/F7qxpX0G03+Ut3fdog3paJv9VXsWMmglToLinAVsti5O3yywy/XTfUQCpU6XLu
HV+70IAvj1mWQ553H/UpUCjmMX1SBfkGivOkFijaZephvY5MY7T9qxQXLul7WPbG
As6kfJIn81IZYnZRF68y4RmV4+wqbkhkJA8Q0EzfNHiC/A9Y5irlUfnKB1Cnvz1X
8etE+eYj3fO4vMT4R3Es/1rblAs3VNaR0u23ZFNOJafMzQua9miftG9qDydseRN0
rpO2HFvhYNj2HFl/2KjaZ/22QnE7Mq8lVa9d09HDT9O4+LDv173GCVLAKxqC/2rK
bztcdFeJ4I7bJwoJ3z81Xk6xo8amV7UPAtcnTp4CuaZ7AiHFaRBP4ZlrVdT0brxR
xmA5VDDxt2wv7P3oAxJFKGjXK6mTMJSUMYiU+mOg+w+3V3oPES8AtUdjHYNPgNe8
Pdqs4srQReK2o8Nvm4vnNk2Z76bKyWERvcMIr7E95QB43e7+Isvwwwwp+9RzlQ8W
YdkfWunnWpuEdRreh8ff
=55fU
-----END PGP SIGNATURE-----

--Signature=_Wed__23_May_2012_17_07_40_+1000_ZE.RLuRnpNS40F1J--

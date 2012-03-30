Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760488Ab2C3DpE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 23:45:04 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:47983 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759829Ab2C3Dow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 23:44:52 -0400
Date: Fri, 30 Mar 2012 14:44:43 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Mar 30
Message-Id: <20120330144443.4f9c6fdbd7f877e00b79b6da@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__30_Mar_2012_14_44_43_+1100_SZnQVQbLNcHOUDaG"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__30_Mar_2012_14_44_43_+1100_SZnQVQbLNcHOUDaG
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Reminder: please do not add stuff destined for v3.5 to linux-next
included trees/branches until after v3.4-rc1 has been released.

Changes since 20120329:

Lots of conflicts move between trees and disappear as things are merged
into Linus' tree.

New tree: irqdomain-current

Linus' tree gained a build failure for which I applied a patch.

The arm tree gained a conflict against Linus' tree.

The tegra tree lost its conflict.

The acpi tree gained a conflict against Linus' tree.

The slave-dma tree lost its conflicts.

The pcmcia tree lost its conflicts.

The arm-soc tree lost most of its conflicts.

The akpm tree lost several patches that turned up in Linus' tree.

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

We are up to 188 trees (counting Linus' and 26 trees of patches pending
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
Merging origin/master (1c03658 Merge git://git.kernel.org/pub/scm/linux/ker=
nel/git/brodo/cpupowerutils)
Merging fixes/master (b0c60de powerpc: fix fallout from system.h split up)
Merging kbuild-current/rc-fixes (42f1c01 coccicheck: change handling of C=
=3D{1,2} when M=3D is set)
Merging arm-current/fixes (a0feb6d ARM: 7358/1: perf: add PMU hotplug notif=
ier)
Merging m68k-current/for-linus (2a35350 m68k: Fix assembler constraint to p=
revent overeager gcc optimisation)
Merging powerpc-merge/merge (e22057c Merge tag 'stable/for-linus-3.4-tag-tw=
o' of git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen)
Merging sparc/master (e0adb99 sparc32: Add -Av8 to assembler command line.)
Merging scsi-rc-fixes/master (41f8ad7 [SCSI] osd_uld: Bump MAX_OSD_DEVICES =
from 64 to 1,048,576)
Merging net/master (1d24fb3 x86 bpf_jit: fix a bug in emitting the 16-bit i=
mmediate operand of AND)
Merging sound-current/for-linus (c578ae0 ALSA: fix isa/opti9xx module param=
 type)
Merging pci-current/for-linus (4949be1 PCI: ignore pre-1.1 ASPM quirking wh=
en ASPM is disabled)
Merging wireless/master (de312db mac80211: fix oper channel timestamp updat=
ion)
Merging driver-core.current/driver-core-linus (fde7d90 Linux 3.3-rc7)
Merging tty.current/tty-linus (fde7d90 Linux 3.3-rc7)
Merging usb.current/usb-linus (fde7d90 Linux 3.3-rc7)
Merging staging.current/staging-linus (fde7d90 Linux 3.3-rc7)
Merging char-misc.current/char-misc-linus (c16fa4f Linux 3.3)
Merging cpufreq-current/fixes (6139b65 Merge branch 'for_3.4/cpufreq' of gi=
t://git.kernel.org/pub/scm/linux/kernel/git/khilman/linux-omap-pm into fixe=
s)
Merging input-current/for-linus (9938082 Merge branch 'next' into for-linus)
Merging md-current/for-linus (ecb178b md: Add judgement bb->unacked_exist i=
n function md_ack_all_badblocks().)
Merging audit-current/for-linus (c158a35 audit: no leading space in audit_l=
og_d_path prefix)
Merging crypto-current/master (5219a53 crypto: user - Fix size of netlink d=
ump message)
Merging ide/master (0ab3d8b cy82c693: fix PCI device selection)
Merging dwmw2/master (244dc4e Merge git://git.infradead.org/users/dwmw2/ran=
dom-2.6)
Merging irqdomain-current/irqdomain/merge (d4886bc irqdomain/powerpc: updat=
ed defconfigs for VIRQ_DEBUG rename)
Merging devicetree-current/devicetree/merge (29f141f Merge branch 'fixes-fo=
r-grant' of git://sources.calxeda.com/kernel/linux into devicetree/merge)
Merging spi-current/spi/merge (a5ab629 Fix section mismatch in spi-pl022.c)
Merging gpio-current/gpio/merge (735e941c Merge tag 'common-clk-api' of git=
://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc)
Merging arm/for-next (6d09a99 Merge branch 'for-linus' into for-next)
CONFLICT (content): Merge conflict in arch/powerpc/Kconfig
CONFLICT (content): Merge conflict in arch/c6x/Kconfig
CONFLICT (content): Merge conflict in arch/arm/mm/alignment.c
CONFLICT (content): Merge conflict in arch/arm/mach-vexpress/hotplug.c
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/setup-sh7377.c
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/setup-sh7367.c
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/setup-r8a7740.c
CONFLICT (content): Merge conflict in arch/arm/mach-msm/timer.c
CONFLICT (content): Merge conflict in arch/arm/mach-integrator/pci.c
CONFLICT (content): Merge conflict in arch/arm/mach-integrator/core.c
CONFLICT (content): Merge conflict in arch/arm/kernel/process.c
CONFLICT (content): Merge conflict in arch/arm/include/asm/system.h
CONFLICT (add/add): Merge conflict in arch/arm/include/asm/cp15.h
CONFLICT (content): Merge conflict in arch/arm/common/gic.c
CONFLICT (content): Merge conflict in arch/arm/Kconfig
Merging arm-perf/for-next/perf (c16fa4f Linux 3.3)
Merging davinci/davinci-next (fe0d422 Linux 3.0-rc6)
Merging samsung/next-samsung (9edb240 ARM: H1940/RX1950: Change default LED=
 triggers)
Merging s5p/for-next (d782c13 Merge branch 'next/soc-exynos5250-gpio' into =
for-next)
CONFLICT (modify/delete): arch/arm/mach-s3c24xx/common.h deleted in HEAD an=
d modified in s5p/for-next. Version s5p/for-next of arch/arm/mach-s3c24xx/c=
ommon.h left in tree.
Merging tegra/for-next (8c3ec84 ARM: tegra: Fix device tree AUXDATA for USB=
/EHCI)
Merging xilinx/arm-next (b85a3ef ARM: Xilinx: Adding Xilinx board support)
Merging blackfin/for-linus (0172c0a blackfin: gpio: fix compile error if !C=
ONFIG_GPIOLIB)
Merging c6x/for-linux-next (fde7d90 Linux 3.3-rc7)
Merging cris/for-next (ea78f5b CRIS: Update documentation)
Merging quilt/hexagon (110b372 Remove unneeded include of version.h from ar=
ch/hexagon/include/asm/spinlock_types.h)
CONFLICT (content): Merge conflict in arch/hexagon/Kconfig
Merging ia64/next (5cd288c Merge branch 'pstore' into next)
Merging m68k/for-next (2a35350 m68k: Fix assembler constraint to prevent ov=
ereager gcc optimisation)
Merging m68knommu/for-next (ae909ea m68knommu: factor more common ColdFire =
cpu reset code)
Merging microblaze/next (a28d73c microblaze: Fix tlb_skip variable on noMMU=
 system)
Merging mips/mips-for-linux-next (2fea377 Merge branch 'fixes-for-linus' in=
to mips-for-linux-next)
Merging openrisc/for-upstream (fa8d9d7 OpenRISC: Remove memory_start/end pr=
ototypes)
Merging parisc/for-next (c60dc74 Merge branch 'fixes' into for-next)
Merging powerpc/next (1ce447b powerpc/perf: Fix instruction address samplin=
g on 970 and Power4)
Merging 4xx/next (b5594a7 powerpc/44x: Add additional device support for AP=
M821xx SoC and Bluestone board)
Merging mpc5xxx/next (7b6bb64 powerpc/5200: convert mpc5200 to use of_platf=
orm_populate())
Merging galak/next (fa1b42b powerpc/qe: Update the SNUM table for MPC8569 R=
ev2.0)
Merging s390/features (5d3b56f [S390] register cpu devices for SMP=3Dn)
Merging sparc-next/master (e9b57cc sparc: Use vsprintf extention %pf with b=
uiltin_return_address)
Merging tile/master (1631fce compat: use sys_sendfile64() implementation fo=
r sendfile syscall)
Merging unicore32/unicore32 (0994695 Merge branch 'akpm' (aka "Andrew's pat=
ch-bomb, take two"))
Merging ceph/master (c666601 rbd: move snap_rwsem to the device, rename to =
header_rwsem)
Merging cifs/master (867646f [CIFS] Update CIFS version number to 1.77)
Merging configfs/linux-next (b930c26 Merge branch 'for-linus' of git://git.=
kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (6cfd4b4 ecryptfs: remove the second argument of k[un=
]map_atomic())
CONFLICT (content): Merge conflict in fs/ecryptfs/ecryptfs_kernel.h
Merging ext3/for_next (e703c20 ext3: fix start and len arguments handling i=
n ext3_trim_fs())
Merging ext4/dev (9d547c3 vfs: remove unused superblock helpers)
Merging fuse/for-next (4273b79 fuse: O_DIRECT support for files)
Merging gfs2/master (e22057c Merge tag 'stable/for-linus-3.4-tag-two' of gi=
t://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen)
Merging logfs/master (e22057c Merge tag 'stable/for-linus-3.4-tag-two' of g=
it://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen)
Merging nfs/linux-next (b5174fa Merge tag 'mmc-merge-for-3.4-rc1' of git://=
git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc)
Merging nfsd/nfsd-next (797a9d7 nfsd: only register cld pipe notifier when =
CONFIG_NFSD_V4 is enabled)
Merging ocfs2/linux-next (9392557 ocfs2: avoid unaligned access to dqc_bitm=
ap)
Merging omfs/for-next (976d167 Linux 3.1-rc9)
Merging squashfs/master (4b0180a Squashfs: add mount time sanity check for =
block_size and block_log match)
Merging v9fs/for-next (5bdad93 9p: statfs should not override server f_type)
Merging ubifs/linux-next (5a1f36c UBIFS: improve error messages)
Merging xfs/for-next (5a5881c xfs: add lots of attribute trace points)
Merging vfs/for-next (07c0c5d ext4: initialization of ext4_li_mtx needs to =
be done earlier)
Merging pci/linux-next (1488d51 PCI: Bjorn gets PCI hotplug too)
Merging hid/for-next (41c6748 Merge branch 'wacom' into for-next)
Merging quilt/i2c (81b2104 i2c-algo-bit: Don't resched on clock stretching)
CONFLICT (content): Merge conflict in drivers/i2c/busses/i2c-gpio.c
Merging bjdooks-i2c/next-i2c (fc84fe1 Merge branch 'for_3.3/i2c/misc' of gi=
t://git.kernel.org/pub/scm/linux/kernel/git/khilman/linux-omap-pm into for-=
33/i2c/omap)
CONFLICT (content): Merge conflict in drivers/i2c/busses/i2c-omap.c
Merging i2c-embedded/i2c-embedded/for-next (bbceeee i2c-eg20t: Remove write=
-only variables)
Merging quilt/jdelvare-hwmon (e3a9568 hwmon: Add MCP3021 ADC driver)
Merging hwmon-staging/hwmon-next (f980878 acpi_power_meter: fix lockdep spe=
w due to non-static lock class)
Merging quilt/kernel-doc (93a1e8b Documentation:"the the" in ABI/stable/sys=
fs-driver-usb-usbtmc Documentation misspelling)
Merging docs/docs-move (5c24d8b Merge branch 'docs/docbook/drm' of git://gi=
thub.com/mfwitten/linux into docs-move)
Merging v4l-dvb/master (2f6edcb Merge branch 'poll')
Merging kbuild/for-next (4904b4b Merge branch 'kbuild/misc' into kbuild/for=
-next)
Merging kconfig/for-next (eae1c36 Merge branch 'kconfig/for-linus-2' into k=
config/for-next)
Merging libata/NEXT (b8cec3c pata_cmd64x: implement sff_irq_check() method)
Merging infiniband/for-next (5ad19b0 Merge branches 'cma', 'cxgb3', 'cxgb4'=
, 'ehca', 'iser', 'mad', 'nes', 'qib', 'srp' and 'srpt' into for-next)
Merging acpi/next (be6fb23 Merge branch 'acpica' into next)
CONFLICT (content): Merge conflict in drivers/cpuidle/cpuidle.c
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/cpuidle.c
CONFLICT (content): Merge conflict in arch/arm/mach-at91/cpuidle.c
Merging cpupowerutils/master (f166033 cpupower tools: add install target to=
 the debug tools' makefiles)
Merging ieee1394/for-next (19f8399 Merge branch 'iso-flush' into for-next)
Merging ubi/linux-next (cc83146 UBI: rename MOVE_CANCEL_BITFLIPS to MOVE_TA=
RGET_BITFLIPS)
Merging dlm/next (1b189b8 dlm: last element of dlm_local_addr[] never used)
Merging scsi/master (6993169 [SCSI] ipr: Driver version 2.5.3)
Merging target-updates/for-next (187e70a ib_srpt: Fix srpt_handle_cmd send_=
ioctx->ioctx_kref leak on exception)
Merging target-merge/for-next-merge (06de5ee tcm_qla2xxx: Add >=3D 24xx ser=
ies fabric module for target-core)
Merging ibft/linux-next (935a9fe ibft: Fix finding IBFT ACPI table on UEFI)
Merging isci/all (fbabacb Merge branches 'devel', 'rnc-devel' and 'fixes' i=
nto all)
Merging slave-dma/next (5b2e02e dmaengine: imx: fix the build failure on x8=
6_64)
Merging dmaengine/next (3d9ea9e iop-adma: Corrected array overflow in RAID6=
 Xscale(R) test.)
Merging net-next/master (de8856d Merge git://git.kernel.org/pub/scm/linux/k=
ernel/git/davem/net)
Merging wireless-next/master (8a78335 usbnet: consider device busy at each =
recieved packet)
Merging bluetooth/master (77e771b Bluetooth: btusb: typo in Broadcom SoftSa=
iling id)
Merging mtd/master (7b0e67f mtd: docg3 add protection against concurrency)
CONFLICT (content): Merge conflict in sound/soc/mxs/mxs-pcm.h
CONFLICT (content): Merge conflict in fs/jffs2/fs.c
CONFLICT (content): Merge conflict in fs/jffs2/compr.c
CONFLICT (content): Merge conflict in drivers/mtd/nand/gpmi-nand/gpmi-lib.c
CONFLICT (content): Merge conflict in drivers/mtd/nand/atmel_nand.c
CONFLICT (content): Merge conflict in drivers/mmc/host/mxs-mmc.c
CONFLICT (content): Merge conflict in drivers/dma/mxs-dma.c
Merging l2-mtd/master (282cb52 mtd: docg3 add protection against concurrenc=
y)
CONFLICT (content): Merge conflict in sound/soc/mxs/mxs-pcm.h
CONFLICT (add/add): Merge conflict in include/linux/mtd/spear_smi.h
CONFLICT (content): Merge conflict in fs/jffs2/fs.c
CONFLICT (content): Merge conflict in drivers/mtd/nand/gpmi-nand/gpmi-lib.c
CONFLICT (add/add): Merge conflict in drivers/mtd/nand/docg4.c
CONFLICT (content): Merge conflict in drivers/mtd/nand/atmel_nand.c
CONFLICT (content): Merge conflict in drivers/mtd/nand/Kconfig
CONFLICT (add/add): Merge conflict in drivers/mtd/devices/spear_smi.c
CONFLICT (content): Merge conflict in drivers/mmc/host/mxs-mmc.c
CONFLICT (content): Merge conflict in drivers/dma/mxs-dma.c
Merging crypto/master (a0ea0f6 crypto: caam - add backward compatible strin=
g sec4.0)
Merging sound/for-next (c81486a Merge branch 'for-linus' into for-next)
Merging sound-asoc/for-next (320692d ASoC: sgtl5000: Enable VAG when DAC/AD=
C up)
Merging cpufreq/next (a7b422c provide disable_cpufreq() function to disable=
 the API.)
Merging quilt/rr (2a22b63 cpumask: remove old cpu_*_map.)
CONFLICT (content): Merge conflict in arch/arm/kernel/kprobes.c
Merging input/next (131c713 Input: tegra-kbc - allocate pdata before using =
it)
Merging input-mt/for-next (7491f3d bcm5974: Add pointer and buttonpad prope=
rties)
Merging block/for-next (ff5eb00 Merge branch 'for-3.5/core' into for-next)
CONFLICT (content): Merge conflict in block/blk-cgroup.c
Merging quilt/device-mapper (4b63eba This device-mapper target creates a re=
ad-only device that transparently validates the data on one underlying devi=
ce against a pre-generated tree of cryptographic checksums stored on a seco=
nd device.)
Merging embedded/master (4744b43 embedded: fix vc_translate operator preced=
ence)
Merging firmware/master (6e03a20 firmware: speed up request_firmware(), v3)
Merging pcmcia/master (80af9e6 pcmcia at91_cf: fix raw gpio number usage)
Merging mmc/mmc-next (135111c mmc: sh_mmcif: simplify bitmask macros)
Merging kgdb/kgdb-next (3751d3e x86,kgdb: Fix DEBUG_RODATA limitation using=
 text_poke())
Merging slab/for-next (b80b6c0 Merge branch 'slab/next' into for-next)
Merging uclinux/for-next (5e442a4 Revert "proc: fix races against execve() =
of /proc/PID/fd**")
Merging md/for-next (440c26c md: Avoid OOPS when reshaping raid1 to raid0)
Merging mfd/for-next (b8589e2 gpio/twl: Add DT support to gpio-twl4030 driv=
er)
Merging battery/master (5cdd4d7 max17042_battery: Clean up interrupt handli=
ng)
Merging drm/drm-next (5466c7b drm/i915: use DDC_ADDR instead of hard-coding=
 it)
Merging fbdev/fbdev-next (6bff98b Revert "video:uvesafb: Fix oops that uves=
afb try to execute NX-protected page")
Merging viafb/viafb-next (838ac78 viafb: avoid refresh and mode lookup in s=
et_par)
Merging omap_dss2/for-next (df01d53 OMAPDSS: APPLY: fix clearing shadow dir=
ty flag with manual update)
Merging regulator/for-next (e032b37 regulator: Fix deadlock on removal of r=
egulators with supplies)
Merging security/next (09f61cd Merge branch 'for-security' of git://git.ker=
nel.org/pub/scm/linux/kernel/git/jj/linux-apparmor into next)
Merging selinux/master (ecf093d SELinux: add default_type statements)
Merging lblnet/master (7e27d6e Linux 2.6.35-rc3)
Merging watchdog/master (b92c803 watchdog: txx9wdt: fix timeout)
Merging dwmw2-iommu/master (c3b92c8 Linux 3.1)
Merging iommu/next (7de4730 Merge branches 'iommu/fixes', 'arm/tegra' and '=
x86/amd' into next)
Merging osd/linux-next (72749a2 exofs: Cap on the memcpy() size)
Merging jc_docs/docs-next (5c050fb docs: update the development process doc=
ument)
Merging trivial/for-next (409a3e9 Email/web address change)
CONFLICT (content): Merge conflict in drivers/net/ethernet/realtek/r8169.c
Merging audit/for-next (dcd6c92 Linux 3.3-rc1)
Merging pm/linux-next (c4772d1 PM / QoS: add pm_qos_update_request_timeout(=
) API)
Merging apm/for-next (b4a133d Merge branch 'for-linus' of git://git.kernel.=
org/pub/scm/linux/kernel/git/jikos/apm)
Merging fsnotify/for-next (ef9bf3b fanotify: only destroy a mark if both it=
s mask and its ignored_mask are cleared)
Merging edac/linux_next (a4b4be3 edac: rename channel_info to rank_info)
Merging edac-amd/for-next (305f1c3 Merge branch '3.3-pci_device_id' into ed=
ac-for-next)
Merging devicetree/devicetree/next (0f22dd3 of: Only compile OF_DYNAMIC on =
PowerPC pseries and iseries)
Merging spi/spi/next (87bf5ab spi/fsl-espi: Make sure pm is within 2..32)
Merging tip/auto-latest (9e122d6 Merge branch 'x86/urgent')
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
Merging kvm/linux-next (cf9eeac KVM: Convert intx_mask_lock to spin lock)
Merging oprofile/for-next (c16fa4f Linux 3.3)
Merging xen/upstream/xen (59e9a6b Merge branch 'upstream/ticketlock-cleanup=
' into upstream/xen)
CONFLICT (content): Merge conflict in arch/x86/include/asm/cmpxchg.h
Merging xen-two/linux-next (2faaa4d Merge branch 'stable/for-linus-3.4' int=
o linux-next)
CONFLICT (content): Merge conflict in arch/x86/kernel/apic/io_apic.c
CONFLICT (content): Merge conflict in arch/x86/include/asm/io_apic.h
Merging xen-pvhvm/linux-next (b056b6a xen: suspend: remove xen_hvm_suspend)
Merging percpu/for-next (adb7950 percpu: fix __this_cpu_{sub,inc,dec}_retur=
n() definition)
Merging workqueues/for-next (e06ffa1 workqueue: use percpu allocator for cw=
q on UP)
Merging drivers-x86/linux-next (86924de acer-wmi: add quirk table for video=
 backlight vendor mode)
Merging hwpoison/hwpoison (46e387b Merge branch 'hwpoison-hugepages' into h=
wpoison)
Merging sysctl/master (4e474a0 sysctl: protect poll() in entries that may g=
o away)
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
Merging tmem/linux-next (9c9fc31 Merge commit 'e22057c8599373e5caef0bc42bdb=
95d2a361ab0d' into linux-next)
Merging writeback/writeback-for-next (697e6fe writeback: Remove outdated co=
mment)
Merging arm-dt/devicetree/arm-next (ede338f dt: add documentation of ARM dt=
 boot interface)
Merging hwspinlock/linux-next (8b37fcf hwspinlock: add MAINTAINERS entries)
Merging pinctrl/for-next (51dddfe ARM: u300: configure some pins as an exam=
ple)
Merging moduleh/for-sfr (de2272c Merge branch 'device-3.4' into for-sfr)
CONFLICT (content): Merge conflict in lib/string.c
Merging vhost/linux-next (437578b virtio-pci: switch to PM ops macro to ini=
tialise PM functions)
Merging kmap_atomic/kmap_atomic (317b6e1 feature-removal-schedule.txt: sche=
dule the deprecated form of kmap_atomic() for removal)
Merging modem-shm/for-next (3cff1cc caif_shm: Add CAIF driver for Shared me=
mory for M7400)
Merging memblock/memblock-kill-early_node_map (7bd0b0f memblock: Reimplemen=
t memblock allocation using reverse free area iterator)
Merging remoteproc/for-next (e12bc14 remoteproc: s/big switch/lookup table/)
Merging irqdomain/irqdomain/next (409a6f6 Merge branch 'irqdomain-for-grant=
' of git://sources.calxeda.com/kernel/linux into irqdomain/next)
CONFLICT (content): Merge conflict in arch/arm/Kconfig
Merging gpio/gpio/next (c77c8a6 gpio/ep93xx: Remove unused inline function =
and useless pr_err message)
Merging arm-soc/for-next (d34072c Merge branch 'fixes' into for-next)
CONFLICT (modify/delete): arch/arm/mach-vexpress/include/mach/io.h deleted =
in arm-soc/for-next and modified in HEAD. Version HEAD of arch/arm/mach-vex=
press/include/mach/io.h left in tree.
$ git rm -f arch/arm/mach-vexpress/include/mach/io.h
Merging kvmtool/master (20082f5 kvm tools: Fix realpath() error checking)
Merging dma-mapping/dma-mapping-next (64d70fe common: DMA-mapping: add NON-=
CONSISTENT attribute)
Merging dma-buf/for-next (9f28056 dma-buf: Correct dummy function declarati=
ons.)
CONFLICT (content): Merge conflict in include/linux/dma-buf.h
Merging ktest/for-next (648a182 ktest: Allow a test to override REBOOT_ON_S=
UCCESS)
Merging cpuidle-cons/cpuidle_consol_pull (203b52e SH: shmobile: Consolidate=
 time keeping and irq enable)
CONFLICT (content): Merge conflict in drivers/cpuidle/cpuidle.c
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/cpuidle.c
CONFLICT (content): Merge conflict in arch/arm/mach-davinci/cpuidle.c
CONFLICT (content): Merge conflict in arch/arm/mach-at91/cpuidle.c
CONFLICT (add/add): Merge conflict in arch/arm/include/asm/cpuidle.h
Merging scsi-post-merge/merge-base:master ()
$ git checkout akpm
Applying: net/netfilter/nf_conntrack_netlink.c: fix Oops on container destr=
oy
Applying: acerhdf: add support for Aspire 1410 BIOS v1.3314
Applying: acerhdf: add support for new hardware
Applying: acerhdf: lowered default temp fanon/fanoff values
Applying: arch/x86/platform/iris/iris.c: register a platform device and a p=
latform driver
Applying: intel_mid_powerbtn: mark irq as IRQF_NO_SUSPEND
Applying: arch/arm/mach-ux500/mbox-db5500.c: world-writable sysfs fifo file
Applying: avr32: don't mask signals in the error path
Applying: avr32: use set_current_blocked() in handle_signal/sys_rt_sigreturn
Applying: avr32: use block_sigmask()
Applying: x86: use this_cpu_xxx to replace percpu_xxx funcs
Applying: x86: change percpu_read_stable() to this_cpu_read_stable()
Applying: net: use this_cpu_xxx replace percpu_xxx funcs
Applying: percpu: remove percpu_xxx() functions
Applying: percpu-remove-percpu_xxx-functions-fix
Applying: ia64: use set_current_blocked() and block_sigmask()
Applying: microblaze: don't reimplement force_sigsegv()
Applying: microblaze: no need to reset handler if SA_ONESHOT
Applying: microblaze: fix signal masking
Applying: microblaze: use set_current_blocked() and block_sigmask()
Applying: MIPS: use set_current_blocked() and block_sigmask()
Applying: score: don't mask signals if we fail to setup signal stack
Applying: score: use set_current_blocked() and block_sigmask()
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
Applying: fs: symlink restrictions on sticky directories
Applying: fs-symlink-restrictions-on-sticky-directories-fix-2
Applying: fs: hardlink creation restrictions
Applying: fs-hardlink-creation-restrictions-fix
Applying: fs: hardlink creation restriction cleanup
Applying: mm: fix page-faults detection in swap-token logic
Applying: mm: add extra free kbytes tunable
Applying: mm-add-extra-free-kbytes-tunable-update
Applying: mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes
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
Applying: um/kernel/trap.c: port OOM changes to handle_page_fault()
Applying: ceph, cifs, nfs, fuse: boolean and / or confusion
Applying: powerpc/eeh: remove eeh_event_handler()->daemonize()
Applying: arch/powerpc/platforms/pseries/eeh_event.c: slightly fix set_curr=
ent_state() wart
Applying: MAINTAINERS: fix REMOTEPROC F: typo
Applying: checkpatch: suggest pr_<level> over printk(KERN_<LEVEL>
Applying: init/do_mounts.c: create /root if it does not exist
Applying: kmod: avoid deadlock from recursive kmod call
Applying: kmod-avoid-deadlock-by-recursive-kmod-call-fix
Applying: proc: clean up /proc/<pid>/environ handling
Applying: ipc/sem.c: alternatives to preempt_disable()
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
Merging akpm (ed111a1 notify_change(): check that i_mutex is held)
Applying: sparc: fix fallout from system.h split

--Signature=_Fri__30_Mar_2012_14_44_43_+1100_SZnQVQbLNcHOUDaG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPdSwrAAoJEECxmPOUX5FEfQIP/3kh/rSC2IqjSQiMrmRcYbif
kMJvmjJLE/lrYh8n00Tg7zOJWWlEpHsadXHhVrGIe4P+T0I476egWQFfarVKQKfO
0TSFO2Ukjj0AIiBqZfm3CbwDTLH3VKQcIN3PI006XnvjS5s9//l3D2o3iUDZdLl0
wP/Sd2iK65l0Uc3CyUWTftgELcqs+eiOB/JsHcmPxs/Fi+WuUmxzug3B2qw16rfO
/+8vVyFZ7dGm04HQwtxBgAyrKX1z9pttZkKq4cS9RtIOnSNEbhoykshWlZnkVZvP
ftuCa6bkM3j1Xzulg/cAcKRyxkpeZW6v6XzyRTyPnKm4POy2O23KvZfZ2mf08rq9
U6TCha8A4DnrfivB9ujXt3SSTBB77raKZY815H1rNl4LqzCRx3Lm2xTlJ4a1pf6s
NF+mB/mFRc+Rc2d3ietXyvCbmjPrgt4L1R9mjV8MkAF9kTqZUumNGC8Eaw7SrXAJ
fW7IPUeKL6KaYj6UzZHO6r/blVopVxejAiq5XWovgBpJcsLqgG4zlILid1Rfi+ky
dnjFZp6wzcQM12r6694Y5fTVlB6104ZDzZPFt/+ziJAj16JLSStkWnL3piCMVpkc
W4CC++DPpzY8ro9RibtI4OdIlUKa20wOi5QLC1V5Swesk9PYUixomDJ46QI4IvoW
yziPSBuJErPp4DYkE/KK
=61IK
-----END PGP SIGNATURE-----

--Signature=_Fri__30_Mar_2012_14_44_43_+1100_SZnQVQbLNcHOUDaG--

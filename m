Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758981Ab2COIAI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 04:00:08 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:54115 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758740Ab2COH7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 03:59:54 -0400
Date: Thu, 15 Mar 2012 18:59:35 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Mar 15
Message-Id: <20120315185935.a0c475a30b2836765273a1e5@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__15_Mar_2012_18_59_35_+1100_fl5hMTic44IsDA4."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__15_Mar_2012_18_59_35_+1100_fl5hMTic44IsDA4.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

News: the build system (see below) has had its toolchains for most
architectures updated to gcc 4.6.3.  People might like to check the build
results and consider if this change has caused any problems.  There are
also a number of architectures that are building today for the first
time.  Thanks to Tony Breeds for his efforts in providing toolchains.

Changes since 20120314:

Undropped tree: uprobes

There are quite a few conflicts caused by the same patches (as opposed to
commits) appearing in more than one tree.

The tile tree lost its conflict.

The pci tree still has its build failure, for which I applied a patch.

The isci tree lost its conflicts.

The sound tree still had its build failure for which I reverted 3 commits.

The cpufreq tree gained a conflict against the cpufreq-current tree.

The battery tree gained a build failure so I used the version from
next-20120314.

The md tree gained a conflict against the device-mapper tree.

The tip tree gained conflicts against the s390 and tile trees.

The uprobes tree lost its conflicts and its build.

The regmap tree lost its conflicts.

The tty tree gained a conflict against the xen-two tree.

The kmap_atomic tree gained a conflict against the md tree.

The arm-soc tree lost a conflict, but gained more against Linus' and the
arm trees.  I also reverted a commit that was causing build failures.

I applied a patch to the cpuidle-cons tree to solve a runtime instability.

The akpm tree lost a couple of patches that turned up elsewhere.

I dropped the Sparc build fix patch.

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

Thanks to Randy Dunlap for doing many randconfig builds.

There is a wiki covering stuff to do with linux-next at
http://linux.f-seidel.de/linux-next/pmwiki/ .  Thanks to Frank Seidel.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

$ git checkout master
$ git reset --hard stable
Merging origin/master (762ad8a Merge git://git.kernel.org/pub/scm/linux/ker=
nel/git/davem/sparc)
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
Merging 52xx-and-virtex-current/powerpc/merge (c49f878 dtc/powerpc: remove =
obsolete .gitignore entries)
Merging sparc/master (e0adb99 sparc32: Add -Av8 to assembler command line.)
Merging scsi-rc-fixes/master (41f8ad7 [SCSI] osd_uld: Bump MAX_OSD_DEVICES =
from 64 to 1,048,576)
Merging net/master (762ad8a Merge git://git.kernel.org/pub/scm/linux/kernel=
/git/davem/sparc)
Merging sound-current/for-linus (25dc16f ALSA: hda - fix printing of high H=
DMI sample rates)
Merging pci-current/for-linus (4949be1 PCI: ignore pre-1.1 ASPM quirking wh=
en ASPM is disabled)
Merging wireless/master (3780d03 rt2x00: fix random stalls)
Merging driver-core.current/driver-core-linus (fde7d90 Linux 3.3-rc7)
Merging tty.current/tty-linus (fde7d90 Linux 3.3-rc7)
Merging usb.current/usb-linus (fde7d90 Linux 3.3-rc7)
Merging staging.current/staging-linus (fde7d90 Linux 3.3-rc7)
Merging char-misc.current/char-misc-linus (fde7d90 Linux 3.3-rc7)
Merging cpufreq-current/fixes (6139b65 Merge branch 'for_3.4/cpufreq' of gi=
t://git.kernel.org/pub/scm/linux/kernel/git/khilman/linux-omap-pm into fixe=
s)
Merging input-current/for-linus (24e3e5a Input: wacom - fix physical size c=
alculation for 3rd-gen Bamboo)
Merging md-current/for-linus (7a90484 md/raid10: fix assembling of arrays w=
ith replacement devices.)
Merging audit-current/for-linus (c158a35 audit: no leading space in audit_l=
og_d_path prefix)
Merging crypto-current/master (f8f54e1 crypto: mv_cesa - fix final callback=
 not ignoring input data)
Merging ide/master (0ab3d8b cy82c693: fix PCI device selection)
Merging dwmw2/master (244dc4e Merge git://git.infradead.org/users/dwmw2/ran=
dom-2.6)
Merging devicetree-current/devicetree/merge (29f141f Merge branch 'fixes-fo=
r-grant' of git://sources.calxeda.com/kernel/linux into devicetree/merge)
Merging spi-current/spi/merge (a5ab629 Fix section mismatch in spi-pl022.c)
Merging gpio-current/gpio/merge (7e3a70f gpio: Add missing spin_lock_init i=
n gpio-ml-ioh driver)
Merging arm/for-next (50351fa Merge branch 'acorn' into for-next)
Merging arm-perf/for-next/perf (cdd2a5b Merge branches 'perf/updates' and '=
perf/fixes' into for-next/perf)
Merging davinci/davinci-next (fe0d422 Linux 3.0-rc6)
Merging samsung/next-samsung (9edb240 ARM: H1940/RX1950: Change default LED=
 triggers)
Merging s5p/for-next (c64c4c5 Merge branch 'next/soc-exynos5250-arch-gpio' =
into for-next)
Merging tegra/for-next (1233655 Merge branch 'for-3.4/cleanup-and-fixes' in=
to for-next)
CONFLICT (content): Merge conflict in arch/arm/mach-tegra/Makefile
Merging xilinx/arm-next (b85a3ef ARM: Xilinx: Adding Xilinx board support)
Merging blackfin/for-linus (e651fe5 Blackfin: wire up new process_vm syscal=
ls)
Merging c6x/for-linux-next (fde7d90 Linux 3.3-rc7)
Merging cris/for-next (ea78f5b CRIS: Update documentation)
Merging quilt/hexagon (110b372 Remove unneeded include of version.h from ar=
ch/hexagon/include/asm/spinlock_types.h)
CONFLICT (content): Merge conflict in arch/hexagon/Kconfig
Merging ia64/next (15839b4 [IA64] Fix a couple of warnings for EXPORT_SYMBO=
L)
Merging m68k/for-next (2a35350 m68k: Fix assembler constraint to prevent ov=
ereager gcc optimisation)
Merging m68knommu/for-next (ae909ea m68knommu: factor more common ColdFire =
cpu reset code)
Merging microblaze/next (8597559 Merge tag 'gpio-for-linus' of git://git.se=
cretlab.ca/git/linux-2.6)
Merging mips/mips-for-linux-next (2fea377 Merge branch 'fixes-for-linus' in=
to mips-for-linux-next)
Merging openrisc/for-upstream (fa8d9d7 OpenRISC: Remove memory_start/end pr=
ototypes)
Merging parisc/for-next (c60dc74 Merge branch 'fixes' into for-next)
Merging powerpc/next (aba0eb8 Merge branch 'eeh' into next)
CONFLICT (content): Merge conflict in arch/powerpc/Kconfig
Merging 4xx/next (ef88e39 powerpc: fix compile error with 85xx/p1010rdb.c)
Merging 52xx-and-virtex/powerpc/next (c1395f4 dtc/powerpc: remove obsolete =
.gitignore entries)
Merging galak/next (ef88e39 powerpc: fix compile error with 85xx/p1010rdb.c)
Merging s390/features (c6da39f [S390] kernel: Pass correct stack for smp_ca=
ll_ipl_cpu())
Merging sparc-next/master (e9b57cc sparc: Use vsprintf extention %pf with b=
uiltin_return_address)
Merging tile/master (19998a2 Fix merge conflict in arch/Kconfig with new co=
nfig options from master.)
Merging unicore32/unicore32 (0994695 Merge branch 'akpm' (aka "Andrew's pat=
ch-bomb, take two"))
Merging ceph/master (83eb26a ceph: ensure prealloc_blob is in place when re=
moving xattr)
Merging cifs/master (762ad8a Merge git://git.kernel.org/pub/scm/linux/kerne=
l/git/davem/sparc)
Merging configfs/linux-next (b930c26 Merge branch 'for-linus' of git://git.=
kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (6cfd4b4 ecryptfs: remove the second argument of k[un=
]map_atomic())
CONFLICT (content): Merge conflict in fs/ecryptfs/ecryptfs_kernel.h
Merging ext3/for_next (e703c20 ext3: fix start and len arguments handling i=
n ext3_trim_fs())
Merging ext4/dev (24a1c12 ext4: check for zero length extent)
Merging fuse/for-next (4273b79 fuse: O_DIRECT support for files)
Merging gfs2/master (58a7d5f GFS2: call gfs2_write_alloc_required for each =
chunk)
Merging logfs/master (762ad8a Merge git://git.kernel.org/pub/scm/linux/kern=
el/git/davem/sparc)
Merging nfs/linux-next (96dcadc NFSv4: Rate limit the state manager for loc=
k reclaim warning messages)
Merging nfsd/nfsd-next (8546ee5 nfsd4: make sure set CB_PATH_DOWN sequence =
flag set)
Merging ocfs2/linux-next (9392557 ocfs2: avoid unaligned access to dqc_bitm=
ap)
Merging omfs/for-next (976d167 Linux 3.1-rc9)
Merging squashfs/master (4b0180a Squashfs: add mount time sanity check for =
block_size and block_log match)
Merging v9fs/for-next (5bdad93 9p: statfs should not override server f_type)
Merging ubifs/linux-next (5a1f36c UBIFS: improve error messages)
Merging xfs/for-next (8f639dd xfs: reimplement fdatasync support)
CONFLICT (content): Merge conflict in fs/xfs/xfs_trans_dquot.c
Merging vfs/for-next (9161999 fs: initial qnx6fs addition)
Merging pci/linux-next (63ab387 x86/PCI: add spinlock held check to 'pcibio=
s_fwaddrmap_lookup()')
CONFLICT (modify/delete): arch/powerpc/platforms/iseries/pci.c deleted in H=
EAD and modified in pci/linux-next. Version pci/linux-next of arch/powerpc/=
platforms/iseries/pci.c left in tree.
CONFLICT (content): Merge conflict in arch/powerpc/include/asm/ppc-pci.h
CONFLICT (content): Merge conflict in arch/mips/pci/pci.c
$ git rm -f arch/powerpc/platforms/iseries/pci.c
Applying: powerpc/PCI: fix up for mismatch between resource_size_t and poin=
ter size
Merging hid/for-next (b6560ea Merge branch 'multitouch' into for-next)
Merging quilt/i2c (49d4384 i2c: Update the FSF address)
Merging bjdooks-i2c/next-i2c (fc84fe1 Merge branch 'for_3.3/i2c/misc' of gi=
t://git.kernel.org/pub/scm/linux/kernel/git/khilman/linux-omap-pm into for-=
33/i2c/omap)
CONFLICT (content): Merge conflict in drivers/i2c/busses/i2c-omap.c
Merging i2c-embedded/i2c-embedded/for-next (bbceeee i2c-eg20t: Remove write=
-only variables)
Merging quilt/jdelvare-hwmon (23bbf12 hwmon: Add MCP3021 ADC driver)
Merging hwmon-staging/hwmon-next (2e2ff2a hwmon: (w83627ehf) Add support fo=
r temperature offset registers)
Merging quilt/kernel-doc (7e7b32a Update quilt tree location for Documentat=
ion/ patches.)
Merging docs/docs-move (5c24d8b Merge branch 'docs/docbook/drm' of git://gi=
thub.com/mfwitten/linux into docs-move)
Merging v4l-dvb/master (704f8b9 Merge /home/v4l/v4l/patchwork)
Merging kbuild/for-next (17c0999 Merge branch 'kbuild/misc' into kbuild/for=
-next)
Merging kconfig/for-next (eae1c36 Merge branch 'kconfig/for-linus-2' into k=
config/for-next)
Merging libata/NEXT (b8cec3c pata_cmd64x: implement sff_irq_check() method)
Merging infiniband/for-next (5ad19b0 Merge branches 'cma', 'cxgb3', 'cxgb4'=
, 'ehca', 'iser', 'mad', 'nes', 'qib', 'srp' and 'srpt' into for-next)
Merging acpi/next (71ad90e ACPICA: Fix regression in FADT revision checks)
Merging cpupowerutils/master (f166033 cpupower tools: add install target to=
 the debug tools' makefiles)
Merging ieee1394/for-next (6f6f92d Merge branch 'master' into for-next)
Merging ubi/linux-next (898e567 UBI: fix eraseblock picking criteria)
Merging dlm/next (7210cb7 dlm: fix slow rsb search in dir recovery)
Merging scsi/master (cd8df93 [SCSI] qla4xxx: Update driver version to 5.02.=
00-k15)
Merging target-updates/for-next (9765b1f target: Bump core version to v4.1.=
0-rc2-ml + fabric versions)
Merging target-merge/for-next-merge (b3fd3cc tcm_qla2xxx: Add >=3D 24xx ser=
ies fabric module for target-core)
Merging ibft/linux-next (935a9fe ibft: Fix finding IBFT ACPI table on UEFI)
Merging isci/all (2f70c31 Merge branch 'devel' into all)
Merging slave-dma/next (5170c05 Revert "drivers/dma: linux/module.h include=
d twice")
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
Merging net-next/master (cdf485b ixgbe: dcb: use DCB config values for FCoE=
 traffic class on open)
Merging wireless-next/master (b093863 mwifiex: correction in structure name=
 passed to sizeof())
Merging bluetooth/master (44e612b Bluetooth: Check FINDING state in interle=
aved discovery)
Merging mtd/master (3c3e51d Merge ../linux-2.6 to bring in 3.3-rc fixes alr=
eady merged)
Merging l2-mtd/master (7916855 mtd: nand/fsmc: Remove sparse warnings and e=
rrors)
CONFLICT (content): Merge conflict in fs/jffs2/fs.c
CONFLICT (content): Merge conflict in drivers/mtd/chips/cfi_cmdset_0002.c
Merging crypto/master (2dc9b5d padata: Fix race on sequence number wrap)
CONFLICT (content): Merge conflict in arch/arm/mach-tegra/fuse.c
Merging sound/for-next (d39d46e Merge branch 'topic/hda' into for-next)
CONFLICT (content): Merge conflict in sound/soc/mxs/mxs-pcm.h
CONFLICT (content): Merge conflict in sound/soc/imx/imx-pcm-dma-mx2.c
[master f4251a9] Revert "ALSA: hda - Add expose_enum_ctl flag to snd_hda_ad=
d_vmaster_hook()"
[master ad526d4] Revert "ALSA: hda - Add "Mute-LED Mode" enum control"
[master fe151f1] Revert "ALSA: hda - Rewrite the mute-LED hook with vmaster=
 hook in patch_sigmatel.c"
Merging sound-asoc/for-next (f65eab9 Merge branch 'for-3.4' into asoc-next)
Merging cpufreq/next (a7b422c provide disable_cpufreq() function to disable=
 the API.)
CONFLICT (content): Merge conflict in drivers/cpufreq/Makefile
CONFLICT (content): Merge conflict in drivers/cpufreq/Kconfig.arm
Merging quilt/rr (2a22b63 cpumask: remove old cpu_*_map.)
CONFLICT (content): Merge conflict in arch/arm/kernel/kprobes.c
Merging input/next (145e973 Input: tegra-kbc - revise device tree support)
Merging input-mt/for-next (7491f3d bcm5974: Add pointer and buttonpad prope=
rties)
Merging block/for-next (7622d14 Merge branch 'for-3.4/drivers' into for-nex=
t)
Merging quilt/device-mapper (01ddb38 This patch introduces a new function d=
m_bufio_prefetch. It prefetches the specified range of blocks into dm-bufio=
 cache without waiting for i/o completion.)
Merging embedded/master (4744b43 embedded: fix vc_translate operator preced=
ence)
Merging firmware/master (6e03a20 firmware: speed up request_firmware(), v3)
Merging pcmcia/master (80af9e6 pcmcia at91_cf: fix raw gpio number usage)
CONFLICT (content): Merge conflict in drivers/pcmcia/soc_common.c
Merging battery/master (cd79dbc ab8500: Turn unneeded global symbols into l=
ocal ones)
$ git reset --hard HEAD^
Merging refs/next/20120314/battery
Merging mmc/mmc-next (5f0390f mmc: omap_hsmmc: Avoid a regulator voltage ch=
ange with dt)
CONFLICT (content): Merge conflict in include/linux/mmc/host.h
CONFLICT (content): Merge conflict in drivers/mmc/host/sdhci-s3c.c
CONFLICT (content): Merge conflict in drivers/mmc/host/atmel-mci.c
CONFLICT (content): Merge conflict in drivers/mmc/core/host.h
CONFLICT (content): Merge conflict in drivers/mmc/core/core.c
Merging kgdb/kgdb-next (0e997a4 KDB: Fix usability issues relating to the '=
enter' key.)
Merging slab/for-next (b80b6c0 Merge branch 'slab/next' into for-next)
Merging uclinux/for-next (5e442a4 Revert "proc: fix races against execve() =
of /proc/PID/fd**")
Merging md/for-next (5f868f9 md: Add judgement bb->unacked_exist in functio=
n md_ack_all_badblocks().)
CONFLICT (content): Merge conflict in drivers/md/dm-raid.c
Merging mfd/for-next (2f5f89b mfd: Fix pm8606 build failure)
CONFLICT (content): Merge conflict in drivers/mfd/ab8500-core.c
Merging drm/drm-next (abd3200 Merge branch 'drm-nouveau-next' of git://anon=
git.freedesktop.org/git/nouveau/linux-2.6 into drm-core-next)
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/intel_ringbuffer=
.c
Merging fbdev/fbdev-next (c2bc0a7 video:uvesafb: notice user when we failed=
 to save hardware state)
Merging viafb/viafb-next (838ac78 viafb: avoid refresh and mode lookup in s=
et_par)
Merging omap_dss2/for-next (001b7f3 ARM: OMAP2+: Fix compile error when FB_=
OMAP2 is not set)
Merging regulator/for-next (367d0fe Merge branch 'regulator-drivers' into r=
egulator-next)
Merging security/next (f67dabb KEYS: testing wrong bit for KEY_FLAG_REVOKED)
Merging selinux/master (a9ab18a selinux: include flow.h where used rather t=
han get it indirectly)
Merging lblnet/master (7e27d6e Linux 2.6.35-rc3)
Merging watchdog/linux-next (05195ec watchdog: ep93xx_wdt.c: fix platform p=
robe)
Merging dwmw2-iommu/master (c3b92c8 Linux 3.1)
Merging iommu/next (8bb9ad1 Merge branches 'iommu/fixes', 'arm/tegra' and '=
x86/amd' into next)
Merging osd/linux-next (0aa436b exofs: Cap on the memcpy() size)
Merging jc_docs/docs-next (5c050fb docs: update the development process doc=
ument)
Merging trivial/for-next (cd635af usb: gadget: Kconfig: fix typo for 'diffe=
rent')
CONFLICT (content): Merge conflict in fs/jffs2/compr.c
CONFLICT (content): Merge conflict in drivers/watchdog/pnx4008_wdt.c
Merging audit/for-next (dcd6c92 Linux 3.3-rc1)
Merging pm/linux-next (ffb8811 PM / shmobile: Make MTU2 driver use pm_genpd=
_dev_always_on())
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
CONFLICT (content): Merge conflict in include/linux/of.h
CONFLICT (modify/delete): arch/powerpc/platforms/iseries/Kconfig deleted in=
 HEAD and modified in devicetree/devicetree/next. Version devicetree/device=
tree/next of arch/powerpc/platforms/iseries/Kconfig left in tree.
$ git rm -f arch/powerpc/platforms/iseries/Kconfig
Merging spi/spi/next (9af4acc spi: release lock on error path in spi_pump_m=
essages())
Merging tip/auto-latest (d564d63 Merge branch 'perf/urgent')
CONFLICT (content): Merge conflict in include/net/sock.h
CONFLICT (content): Merge conflict in arch/x86/platform/mrst/mrst.c
CONFLICT (content): Merge conflict in arch/x86/Kconfig
CONFLICT (content): Merge conflict in arch/s390/kernel/smp.c
CONFLICT (modify/delete): arch/powerpc/platforms/iseries/setup.c deleted in=
 HEAD and modified in tip/auto-latest. Version tip/auto-latest of arch/powe=
rpc/platforms/iseries/setup.c left in tree.
CONFLICT (modify/delete): arch/m68k/kernel/process_no.c deleted in HEAD and=
 modified in tip/auto-latest. Version tip/auto-latest of arch/m68k/kernel/p=
rocess_no.c left in tree.
CONFLICT (modify/delete): arch/m68k/kernel/process_mm.c deleted in HEAD and=
 modified in tip/auto-latest. Version tip/auto-latest of arch/m68k/kernel/p=
rocess_mm.c left in tree.
$ git rm -f arch/m68k/kernel/process_no.c arch/m68k/kernel/process_mm.c arc=
h/powerpc/platforms/iseries/setup.c
Applying: sched/rt: Use schedule_preempt_disabled() in m68k
Applying: staging: disable the sep driver due to breakage
Merging rcu/rcu/next (1cc8596 rcu: Stop spurious warnings from synchronize_=
sched_expedited)
Merging cputime/cputime (c3e0ef9 [S390] fix cputime overflow in uptime_proc=
_show)
Merging uprobes/for-next (0326f5a uprobes/core: Handle breakpoint and singl=
estep exceptions)
Merging cgroup/for-next (3ce3230 cgroup: Walk task list under tasklist_lock=
 in cgroup_enable_task_cg_list)
CONFLICT (content): Merge conflict in block/blk-cgroup.c
Merging kmemleak/kmemleak (d65b4e9 Linux 3.3-rc3)
Merging kvm/linux-next (5c53b75 KVM: nVMX: Fix erroneous exception bitmap c=
heck)
Merging oprofile/for-next (b9e7f8e Merge branches 'oprofile/urgent' and 'op=
rofile/core' into oprofile/master)
CONFLICT (content): Merge conflict in tools/perf/util/header.h
CONFLICT (content): Merge conflict in tools/perf/util/header.c
Merging xen/upstream/xen (59e9a6b Merge branch 'upstream/ticketlock-cleanup=
' into upstream/xen)
CONFLICT (content): Merge conflict in arch/x86/include/asm/cmpxchg.h
Merging xen-two/linux-next (f7dd097 Merge branch 'stable/for-linus-3.4' int=
o linux-next)
Merging xen-pvhvm/linux-next (b056b6a xen: suspend: remove xen_hvm_suspend)
Merging percpu/for-next (adb7950 percpu: fix __this_cpu_{sub,inc,dec}_retur=
n() definition)
Merging workqueues/for-next (e06ffa1 workqueue: use percpu allocator for cw=
q on UP)
Merging drivers-x86/linux-next (2d23b05 panasonic-laptop: avoid overflow in=
 acpi_pcc_hotkey_add())
CONFLICT (content): Merge conflict in arch/x86/platform/mrst/mrst.c
CONFLICT (content): Merge conflict in arch/x86/platform/geode/Makefile
CONFLICT (content): Merge conflict in arch/x86/Kconfig
Merging hwpoison/hwpoison (46e387b Merge branch 'hwpoison-hugepages' into h=
wpoison)
Merging sysctl/master (4e75732 sysctl: Don't call sysctl_follow_link unless=
 we are a link.)
CONFLICT (content): Merge conflict in fs/proc/proc_sysctl.c
Merging regmap/for-next (addfd8a Merge remote-tracking branch 'regmap/topic=
/bulk' into regmap-next)
Merging hsi/for-next (43139a6 HSI: hsi_char: Update ioctl-number.txt)
Merging driver-core/driver-core-next (e485ceac Drivers: hv: Add new message=
 types to enhance KVP)
CONFLICT (content): Merge conflict in include/linux/pci.h
CONFLICT (content): Merge conflict in drivers/base/driver.c
Merging tty/tty-next (9b96fba serial: PL011: clear pending interrupts)
CONFLICT (content): Merge conflict in drivers/tty/hvc/hvc_xen.c
CONFLICT (content): Merge conflict in drivers/isdn/gigaset/interface.c
CONFLICT (content): Merge conflict in arch/ia64/hp/sim/simserial.c
Merging usb/usb-next (dc0827c USB: ftdi_sio: add support for FT-X series de=
vices)
CONFLICT (add/add): Merge conflict in drivers/net/usb/qmi_wwan.c
Merging staging/staging-next (dec3a00 Staging: rtl8187se: r8180_core.c: Fix=
 some long line issues)
Merging char-misc/char-misc-next (b222258 misc: bmp085: Use unsigned long t=
o store jiffies)
Merging tmem/linux-next (b05b561 Merge branch 'devel/frontswap.v13' into li=
nux-next)
Applying: mm: frontswap: update for security_vm_enough_memory API change
Merging writeback/writeback-for-next (b3f14b0 writeback: Remove outdated co=
mment)
Merging arm-dt/devicetree/arm-next (ede338f dt: add documentation of ARM dt=
 boot interface)
Merging hwspinlock/linux-next (8b37fcf hwspinlock: add MAINTAINERS entries)
Merging pinctrl/for-next (70b3637 pinctrl: fix error path in pinconf_map_to=
_setting())
Merging moduleh/for-sfr (9e1c4a5 Merge branch 'device-3.4' into for-sfr)
CONFLICT (content): Merge conflict in include/linux/mfd/abx500/ab8500.h
CONFLICT (content): Merge conflict in drivers/usb/dwc3/dwc3-omap.c
Merging vhost/linux-next (1e05b62 sh: use the the PCI channels's io_map_bas=
e)
Merging kmap_atomic/kmap_atomic (23a000f feature-removal-schedule.txt: sche=
dule the deprecated form of kmap_atomic() for removal)
CONFLICT (content): Merge conflict in drivers/staging/zram/zram_drv.c
CONFLICT (content): Merge conflict in drivers/staging/zcache/zcache-main.c
CONFLICT (content): Merge conflict in drivers/scsi/storvsc_drv.c
CONFLICT (content): Merge conflict in drivers/net/ethernet/intel/e1000e/net=
dev.c
CONFLICT (content): Merge conflict in drivers/md/bitmap.c
Merging modem-shm/for-next (3cff1cc caif_shm: Add CAIF driver for Shared me=
mory for M7400)
Merging memblock/memblock-kill-early_node_map (7bd0b0f memblock: Reimplemen=
t memblock allocation using reverse free area iterator)
Merging remoteproc/for-next (e12bc14 remoteproc: s/big switch/lookup table/)
CONFLICT (content): Merge conflict in include/linux/virtio_ids.h
Merging irqdomain/irqdomain/next (e7cc3ac dt: fix twl4030 for non-dt compil=
e on x86)
CONFLICT (content): Merge conflict in arch/powerpc/sysdev/mpic.c
CONFLICT (modify/delete): arch/powerpc/platforms/iseries/irq.c deleted in H=
EAD and modified in irqdomain/irqdomain/next. Version irqdomain/irqdomain/n=
ext of arch/powerpc/platforms/iseries/irq.c left in tree.
CONFLICT (content): Merge conflict in arch/c6x/Kconfig
CONFLICT (content): Merge conflict in arch/arm/common/gic.c
$ git rm -f arch/powerpc/platforms/iseries/irq.c
Merging gpio/gpio/next (81b279d gpio/davinci: fix enabling unbanked GPIO IR=
Qs)
CONFLICT (content): Merge conflict in include/linux/mfd/tps65910.h
Merging arm-soc/for-next (84729e9 Merge branch 'next/cleanup2' into for-nex=
t)
CONFLICT (content): Merge conflict in drivers/regulator/Makefile
CONFLICT (content): Merge conflict in drivers/regulator/Kconfig
CONFLICT (modify/delete): arch/arm/plat-mxc/audmux-v1.c deleted in HEAD and=
 modified in arm-soc/for-next. Version arm-soc/for-next of arch/arm/plat-mx=
c/audmux-v1.c left in tree.
CONFLICT (content): Merge conflict in arch/arm/mach-vexpress/ct-ca9x4.c
CONFLICT (content): Merge conflict in arch/arm/mach-ux500/timer.c
CONFLICT (content): Merge conflict in arch/arm/mach-tegra/Makefile
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/timer.c
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/setup-sh7377.c
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/setup-sh7367.c
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/setup-r8a7740.c
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/board-mackerel=
.c
CONFLICT (modify/delete): arch/arm/mach-s3c2440/common.h deleted in HEAD an=
d modified in arm-soc/for-next. Version arm-soc/for-next of arch/arm/mach-s=
3c2440/common.h left in tree.
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
CONFLICT (content): Merge conflict in arch/arm/Kconfig
CONFLICT (content): Merge conflict in Documentation/feature-removal-schedul=
e.txt
$ git rm -f arch/arm/plat-mxc/audmux-v1.c arch/arm/mach-s3c2440/common.h
[master 6026dba] Revert "ARM: kirkwood: sata_mv: add device tree binding"
Merging kvmtool/master (20082f5 kvm tools: Fix realpath() error checking)
Merging dma-mapping/dma-mapping-next (6cc2bf1 common: DMA-mapping: add NON-=
CONSISTENT attribute)
Merging dma-buf/for-next (ab006e7 dma-buf: add dma_data_direction to unmap =
dma_buf_op)
Merging ktest/for-next (be405f9 ktest: Add INGORE_ERRORS to ignore warnings=
 in boot up)
Merging cpuidle-cons/cpuidle_consol_pull (bd7fd2a SH: shmobile: Consolidate=
 time keeping and irq enable)
CONFLICT (content): Merge conflict in drivers/cpuidle/cpuidle.c
CONFLICT (content): Merge conflict in arch/arm/mach-at91/cpuidle.c
Applying: cpuidle : fix random hangs with intel_idle
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
Applying: x86, olpc: add debugfs interface for EC commands
Applying: x86: use this_cpu_xxx to replace percpu_xxx funcs
Applying: x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs-fix
Applying: x86: change percpu_read_stable() to this_cpu_read_stable()
Applying: x86-change-percpu_read_stable-to-this_cpu_read_stable-fix
Applying: arch/arm/mach-ux500/mbox-db5500.c: world-writable sysfs fifo file
Applying: avr32: don't mask signals in the error path
Applying: avr32: use set_current_blocked() in handle_signal/sys_rt_sigreturn
Applying: avr32: use block_sigmask()
Applying: drivers/media/video/uvc/uvc_driver.c: use linux/atomic.h
Applying: Hexagon: use set_current_blocked() and block_sigmask()
Applying: drivers/idle/intel_idle.c: fix confusing code identation
Applying: hrtimers: Special-case zero length sleeps
Applying: hpet: factor timer allocate from open
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
Applying: thermal-add-support-for-thermal-sensor-present-on-spear13xx-machi=
nes-fix
Applying: thermal-add-support-for-thermal-sensor-present-on-spear13xx-machi=
nes-fix-fix
Applying: thermal/spear_thermal: Add compilation dependency on PLAT_SPEAR
Applying: thermal/spear_thermal: replace readl/writel with lighter _relaxed=
 variants
Applying: thermal: spear13xx: checking for NULL instead of IS_ERR()
Applying: unicore32: use block_sigmask()
Applying: net/netfilter/nfnetlink_acct.c: use linux/atomic.h
Applying: blackfin: use set_current_blocked() and block_sigmask()
Applying: ocfs2: use find_last_bit()
Applying: ocfs2: use bitmap_weight()
Applying: parisc: use set_current_blocked() and block_sigmask()
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
Applying: hugetlb: remove prev_vma from hugetlb_get_unmapped_area_topdown()
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
Applying: vmscan: handle isolated pages with lru lock released
Applying: thp: documentation: 'transparent_hugepage=3D' can also be specifi=
ed on cmdline
Applying: mm: hugetlb: bail out unmapping after serving reference page
Applying: mm: hugetlb: cleanup duplicated code in unmapping vm range
Applying: procfs: mark thread stack correctly in proc/<pid>/maps
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
Applying: ksm: clean up page_trans_compound_anon_split()
Applying: ksm: cleanup: introduce ksm_check_mm()
Applying: ksm-cleanup-introduce-ksm_check_mm-fix
Applying: hugetlbfs: avoid taking i_mutex from hugetlbfs_read()
Applying: mm: don't set __GFP_WRITE on ramfs/sysfs writes
Applying: mm: use global_dirty_limit in throttle_vm_writeout()
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
Applying: cris: use set_current_blocked() and block_sigmask()
Applying: cris: select GENERIC_ATOMIC64
Applying: um: don't restore current->blocked on error
Applying: um: use set_current_blocked() and block_sigmask()
Applying: magic.h: move some FS magic numbers into magic.h
Applying: nmi watchdog: do not use cpp symbol in Kconfig
Applying: ceph, cifs, nfs, fuse: boolean and / or confusion
Applying: net: use this_cpu_xxx replace percpu_xxx funcs
Applying: percpu: remove percpu_xxx() functions
Applying: percpu-remove-percpu_xxx-functions-fix
Applying: headers: include linux/types.h where appropriate
Applying: consolidate WARN_...ONCE() static variables
Applying: Remove remaining bits of io_remap_page_range()
Applying: prctl: add PR_{SET,GET}_CHILD_SUBREAPER to allow simple process s=
upervision
Applying: prctl-add-pr_setget_child_subreaper-to-allow-simple-process-super=
vision-fix
Applying: prctl-add-pr_setget_child_subreaper-to-allow-simple-process-super=
vision-fix-fix
Applying: kernel/exit.c: if init dies, log a signal which killed it, if any
Applying: kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any-fix
Applying: powerpc/eeh: remove eeh_event_handler()->daemonize()
Applying: vfs: increment iversion when a file is truncated
Applying: brlocks/lglocks: cleanups
Applying: seq_file: fix mishandling of consecutive pread() invocations.
Applying: fs: symlink restrictions on sticky directories
Applying: fs-symlink-restrictions-on-sticky-directories-fix-2
Applying: fs: hardlink creation restrictions
Applying: fs-hardlink-creation-restrictions-fix
Applying: fs: hardlink creation restriction cleanup
Applying: get_maintainer: use a default "unknown" S: status/role
Applying: MAINTAINERS: fix REMOTEPROC F: typo
Applying: MAINTAINERS: Update MCA section
Applying: MAINTAINERS: update git urls for 2.6 deletions
Applying: MAINTAINERS: add status to ALPHA architecture
Applying: MAINTAINERS: Add "S: Maintained" to clkdev and clk sections
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
Applying: ptrace: the killed tracee should not enter the syscall
Applying: ptrace: don't send SIGTRAP on exec if SEIZED
Applying: ptrace: don't modify flags on PTRACE_SETOPTIONS failure
Applying: ptrace: simplify PTRACE_foo constants and PTRACE_SETOPTIONS code
Applying: ptrace: make PTRACE_SEIZE set ptrace options specified in 'data' =
parameter
Applying: ptrace: renumber PTRACE_EVENT_STOP so that future new options and=
 events can match
Applying: ptrace: remove PTRACE_SEIZE_DEVEL bit
Applying: signal: give SEND_SIG_FORCED more power to beat SIGNAL_UNKILLABLE
Applying: signal: cosmetic, s/from_ancestor_ns/force/ in prepare_signal() p=
aths
Applying: signal: oom_kill_task: use SEND_SIG_FORCED instead of force_sig()
Applying: signal: zap_pid_ns_processes: s/SEND_SIG_NOINFO/SEND_SIG_FORCED/
Applying: usermodehelper: use UMH_WAIT_PROC consistently
Applying: usermodehelper: introduce umh_complete(sub_info)
Applying: usermodehelper: implement UMH_KILLABLE
Applying: usermodehelper: kill umh_wait, renumber UMH_* constants
Applying: usermodehelper: ____call_usermodehelper() doesn't need do_exit()
Applying: kmod: introduce call_modprobe() helper
Applying: kmod: make __request_module() killable
Applying: kmod: avoid deadlock from recursive kmod call
Applying: kmod-avoid-deadlock-by-recursive-kmod-call-fix
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
Applying: ipc/sem.c: alternatives to preempt_disable()
Applying: ipmi: decrease the IPMI message transaction time in interrupt mode
Applying: ipmi: increase KCS timeouts
Applying: ipmi: use a tasklet for handling received messages
Applying: ipmi: fix message handling during panics
Applying: ipmi: simplify locking
Applying: ipmi: use locks on watchdog timeout set on reboot
Applying: sysctl: use bitmap library functions
Applying: pidns: add reboot_pid_ns() to handle the reboot syscall
Applying: pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-fix
Applying: pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-checkpatch-f=
ixes
Applying: fs/proc/namespaces.c: prevent crash when ns_entries[] is empty
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
Applying: ramoops: use pstore interface
Applying: ramoops: fix printk format warnings
Applying: notify_change(): check that i_mutex is held
Merging akpm (29f7e90 notify_change(): check that i_mutex is held)

--Signature=_Thu__15_Mar_2012_18_59_35_+1100_fl5hMTic44IsDA4.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPYaFnAAoJEECxmPOUX5FE5UcP/2ePoVkFQivy7Z2ZHzY9SJty
0CQ8zpUwJGA9Te+HmbfFrNUCtoAuiPM8ebxQxgFwFQe/oHBNIZeWqH4dIMRVy/JC
21NXbBo06RI9wmpw3GOB+FieMTwKoCmq5nMjqJ5CSE15Dg1PRY4RUAwGG29DRB0u
ko/Xe00AvcVq5n8M4faeobYMGkNg0CJo8hV9UaPRaLreThvpiUtZoflZ0558cRj9
Hk3gfL5KkUE8VbqY57uIpPYivP1taVaYFtv+mWClSGUdhS4qy9DJyF9R1hcVlEr+
vt1RH+7uitEGS/cRnqFSN4O7h88hoAlNv0xnNp6Ds5GWpBdgJH7PMvPBuh+pxEqe
WR+/4s9a+7kJZbd616kZJF3JfpIQ9qyXZpqx84WEB2Zp3Bigxb7TGnvMWFBP0JjD
fya2CtlGqUgAJdm07yts+mDh7Im5kAFJHQuojV63JIVn46Dddq89AvdJFElpIiBU
ix0TeAH13EcgeJPAlG92nFya49WSV/woIdWIITh0kLHX0Kas49WJTXs0HYAW07q7
XM3clEmykHuZTMpss8I4eBDKoN9xsydr/GvjOxwbTbb/gdDZOK9ZcaWNiV59GuNT
OMm/CrpTLTaPpFjBPy84ztO5K9whkTrfaDbeSRMIZhroaQzpt2mfAs3LjF0m2z8p
Bm3+M6dKl+Q5pCgaedo3
=3YCJ
-----END PGP SIGNATURE-----

--Signature=_Thu__15_Mar_2012_18_59_35_+1100_fl5hMTic44IsDA4.--

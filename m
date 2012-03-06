Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757528Ab2CFHIA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 02:08:00 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:34303 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755353Ab2CFHHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 02:07:55 -0500
Date: Tue, 6 Mar 2012 18:07:46 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Mar 6
Message-Id: <20120306180746.25c595babf8b5072366cdbec@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__6_Mar_2012_18_07_46_+1100_x.tlt.=U1sh=JLd9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__6_Mar_2012_18_07_46_+1100_x.tlt.=U1sh=JLd9
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20120305:

The nfs tree lost its build failure.

The pci tree still has its build failure for which I applied a patch.

The kvm tree gained a build failure so I used the version from
next-20120305.

The moduleh tree gained a conflict against the usb tree and a build
failure for which I applied a patch.

The arm-soc tree gained conflicts against the sound-asoc tree.

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

We are up to 185 trees (counting Linus' and 26 trees of patches pending
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
Merging origin/master (055bf38 drm, gma500: Fix Cedarview boot failures in =
3.3-rc)
Merging fixes/master (88ebdda Merge tag 'for-3.3' of git://openrisc.net/jon=
as/linux)
Merging kbuild-current/rc-fixes (42f1c01 coccicheck: change handling of C=
=3D{1,2} when M=3D is set)
Merging arm-current/fixes (7e55d05 ARM: 7339/1: amba/serial.h: Include type=
s.h for resolving dependency of type bool)
Merging m68k-current/for-linus (2a35350 m68k: Fix assembler constraint to p=
revent overeager gcc optimisation)
Merging powerpc-merge/merge (c2ea377 Merge remote-tracking branch 'origin/m=
aster' into merge)
Merging 52xx-and-virtex-current/powerpc/merge (c49f878 dtc/powerpc: remove =
obsolete .gitignore entries)
Merging sparc/master (e51e07e sparc32: forced setting of mode of sun4m per-=
cpu timers)
Merging scsi-rc-fixes/master (41f8ad7 [SCSI] osd_uld: Bump MAX_OSD_DEVICES =
from 64 to 1,048,576)
Merging net/master (9d1dfc0 qla3xxx: ethernet: Fix bogus interrupt state fl=
ag.)
Merging sound-current/for-linus (019ae33 Merge tag 'asoc-3.3' of git://git.=
kernel.org/pub/scm/linux/kernel/git/broonie/sound into for-linus)
Merging pci-current/for-linus (a97f4f5 x86/PCI: do not tie MSI MS-7253 use_=
crs quirk to BIOS version)
Merging wireless/master (182ada1 iwlwifi: fix wowlan suspend)
Merging driver-core.current/driver-core-linus (192cfd5 Linux 3.3-rc6)
Merging tty.current/tty-linus (f21c6d4 tty/powerpc: early udbg consoles can=
't be modules)
Merging usb.current/usb-linus (7191940 Revert "powerpc/usb: fix issue of CP=
U halt when missing USB PHY clock")
Merging staging.current/staging-linus (6b21d18 Linux 3.3-rc5)
Merging char-misc.current/char-misc-linus (b01543d Linux 3.3-rc4)
Merging cpufreq-current/fixes (88ebdda Merge tag 'for-3.3' of git://openris=
c.net/jonas/linux)
Merging input-current/for-linus (f3761c0 Input: twl4030-vibra - use proper =
guard for PM methods)
Merging md-current/for-linus (7a90484 md/raid10: fix assembling of arrays w=
ith replacement devices.)
Merging audit-current/for-linus (c158a35 audit: no leading space in audit_l=
og_d_path prefix)
Merging crypto-current/master (f8f54e1 crypto: mv_cesa - fix final callback=
 not ignoring input data)
Merging ide/master (0ab3d8b cy82c693: fix PCI device selection)
Merging dwmw2/master (244dc4e Merge git://git.infradead.org/users/dwmw2/ran=
dom-2.6)
Merging devicetree-current/devicetree/merge (2261cc6 dt: add empty of_find_=
compatible_node function)
Merging spi-current/spi/merge (c88db23 spi-topcliff-pch: rename pch_spi_pci=
dev to pch_spi_pcidev_driver)
Merging gpio-current/gpio/merge (7e3a70f gpio: Add missing spin_lock_init i=
n gpio-ml-ioh driver)
Merging arm/for-next (5742ee4 Merge branch 'devel-stable' into for-next)
Merging arm-perf/for-next/perf (cdd2a5b Merge branches 'perf/updates' and '=
perf/fixes' into for-next/perf)
Merging davinci/davinci-next (fe0d422 Linux 3.0-rc6)
Merging samsung/next-samsung (9edb240 ARM: H1940/RX1950: Change default LED=
 triggers)
Merging s5p/for-next (734b5bb Merge branch 'next/soc-exynos5250-arch-wip' i=
nto for-next)
Merging tegra/for-next (6f70c98 Merge branch 'for-3.4/boards' into for-next)
Merging xilinx/arm-next (b85a3ef ARM: Xilinx: Adding Xilinx board support)
Merging blackfin/for-linus (e651fe5 Blackfin: wire up new process_vm syscal=
ls)
Merging c6x/for-linux-next (6b21d18 Linux 3.3-rc5)
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
Merging openrisc/for-upstream (754d5c2 openrisc: Set shortest clock event t=
o 100 ticks)
Merging parisc/for-next (c60dc74 Merge branch 'fixes' into for-next)
Merging powerpc/next (6c15d7a carma-fpga: fix race between data dumping and=
 DMA callback)
Merging 4xx/next (ef88e39 powerpc: fix compile error with 85xx/p1010rdb.c)
Merging 52xx-and-virtex/powerpc/next (c1395f4 dtc/powerpc: remove obsolete =
.gitignore entries)
Merging galak/next (ef88e39 powerpc: fix compile error with 85xx/p1010rdb.c)
Merging s390/features (e11eae9 [S390] Ensure that vmcore_info pointer is ne=
ver accessed directly)
Merging sparc-next/master (e9b57cc sparc: Use vsprintf extention %pf with b=
uiltin_return_address)
Merging tile/master (0c90547 arch/tile: use new generic {enable,disable}_pe=
rcpu_irq() routines)
Merging unicore32/unicore32 (0994695 Merge branch 'akpm' (aka "Andrew's pat=
ch-bomb, take two"))
Merging ceph/master (83eb26a ceph: ensure prealloc_blob is in place when re=
moving xattr)
Merging cifs/master (5bccda0 cifs: fix dentry refcount leak when opening a =
FIFO on lookup)
Merging configfs/linux-next (b930c26 Merge branch 'for-linus' of git://git.=
kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (6cfd4b4 ecryptfs: remove the second argument of k[un=
]map_atomic())
CONFLICT (content): Merge conflict in fs/ecryptfs/ecryptfs_kernel.h
Merging ext3/for_next (e703c20 ext3: fix start and len arguments handling i=
n ext3_trim_fs())
Merging ext4/dev (9ee4930 ext4: format flag in dx_probe())
Merging fuse/for-next (4273b79 fuse: O_DIRECT support for files)
Merging gfs2/master (58884c4 GFS2: make sure rgrps are up to date in func g=
fs2_blk2rgrpd)
Merging logfs/master (203738e Merge git://git.kernel.org/pub/scm/linux/kern=
el/git/davem/net)
Merging nfs/linux-next (2c11c0e NFSv4: Add a helper encode_uint64)
Merging nfsd/nfsd-next (03cfb42 NFSD: Clean up the test_stateid function)
Merging ocfs2/linux-next (9392557 ocfs2: avoid unaligned access to dqc_bitm=
ap)
Merging omfs/for-next (976d167 Linux 3.1-rc9)
Merging squashfs/master (3d4a1c8 Squashfs: fix i_blocks calculation with ex=
tended regular files)
Merging v9fs/for-next (208f3c2 net/9p: handle flushed Tclunk/Tremove)
Merging ubifs/linux-next (c43be10 UBIFS: do not use inc_link when i_nlink i=
s zero)
Merging xfs/for-next (4b217ed quota: make Q_XQUOTASYNC a noop)
CONFLICT (content): Merge conflict in fs/xfs/xfs_trans_dquot.c
Merging vfs/for-next (9161999 fs: initial qnx6fs addition)
Merging pci/linux-next (63ab387 x86/PCI: add spinlock held check to 'pcibio=
s_fwaddrmap_lookup()')
CONFLICT (content): Merge conflict in arch/mips/pci/pci.c
Applying: powerpc/PCI: fix up for mismatch between resource_size_t and poin=
ter size
Merging hid/for-next (bda02ea Merge branch 'wacom' into for-next)
Merging quilt/i2c (c3632e0 i2c-i801: Use usleep_range to wait for command c=
ompletion)
Merging bjdooks-i2c/next-i2c (fc84fe1 Merge branch 'for_3.3/i2c/misc' of gi=
t://git.kernel.org/pub/scm/linux/kernel/git/khilman/linux-omap-pm into for-=
33/i2c/omap)
CONFLICT (content): Merge conflict in drivers/i2c/busses/i2c-omap.c
Merging i2c-embedded/i2c-embedded/for-next (7e87f54 Merge branch 'for-34/i2=
c/i2c-samsung' of git://git.fluff.org/bjdooks/linux into i2c-embedded/for-3=
.4)
Merging quilt/jdelvare-hwmon (064628b hwmon: Add MCP3021 ADC driver)
Merging hwmon-staging/hwmon-next (828c60c hwmon: (max34440) Add support for=
 'lowest' output voltage attribute)
Merging quilt/kernel-doc (7e7b32a Update quilt tree location for Documentat=
ion/ patches.)
Merging docs/docs-move (5c24d8b Merge branch 'docs/docbook/drm' of git://gi=
thub.com/mfwitten/linux into docs-move)
Merging v4l-dvb/master (df0877b Merge /home/v4l/v4l/patchwork)
Merging kbuild/for-next (17c0999 Merge branch 'kbuild/misc' into kbuild/for=
-next)
Merging kconfig/for-next (eae1c36 Merge branch 'kconfig/for-linus-2' into k=
config/for-next)
Merging libata/NEXT (3f1581f sata_fsl: add support for interrupt coalsecing=
 feature)
Merging infiniband/for-next (4af99ec Merge branches 'iser', 'misc', 'mlx4' =
and 'srp' into for-next)
Merging acpi/next (71ad90e ACPICA: Fix regression in FADT revision checks)
Merging cpupowerutils/master (f166033 cpupower tools: add install target to=
 the debug tools' makefiles)
Merging ieee1394/for-next (02c68b7 Merge branch 'master' into for-next)
Merging ubi/linux-next (a29852b UBI: fix error handling in ubi_scan())
Merging dlm/next (60f98d1 dlm: add recovery callbacks)
Merging scsi/master (cd8df93 [SCSI] qla4xxx: Update driver version to 5.02.=
00-k15)
Merging target-updates/for-next (c0974f8 target: Allow target_submit_tmr in=
terrupt context + pass ABORT_TASK tag)
Merging target-merge/for-next-merge (c0974f8 target: Allow target_submit_tm=
r interrupt context + pass ABORT_TASK tag)
Merging ibft/linux-next (935a9fe ibft: Fix finding IBFT ACPI table on UEFI)
Merging isci/all (57872c2 Merge branches 'devel' and 'fixes' into all)
CONFLICT (content): Merge conflict in include/scsi/libsas.h
CONFLICT (content): Merge conflict in drivers/scsi/libsas/sas_scsi_host.c
CONFLICT (content): Merge conflict in drivers/scsi/libsas/sas_init.c
CONFLICT (content): Merge conflict in drivers/scsi/libsas/sas_expander.c
CONFLICT (content): Merge conflict in drivers/scsi/libsas/sas_discover.c
CONFLICT (content): Merge conflict in drivers/scsi/isci/registers.h
CONFLICT (content): Merge conflict in drivers/scsi/isci/init.c
Merging slave-dma/next (a1c4601 dmaengine/dw_dmac: Remove unused fields in =
struct dw_dma_slave)
CONFLICT (content): Merge conflict in drivers/mmc/host/atmel-mci.c
Merging dmaengine/next (d07a74a dmaengine: fix missing 'cnt' in ?: in dmate=
st)
Merging net-next/master (18f973a mlx4_en: remove sparse errors)
CONFLICT (content): Merge conflict in drivers/net/vmxnet3/vmxnet3_drv.c
Merging wireless-next/master (769009b brcm80211: smac: cleanup couple of de=
bug output statements)
Merging bluetooth/master (5f15903 Bluetooth: mgmt: Add new error code for i=
nvalid index)
Merging mtd/master (3c3e51d Merge ../linux-2.6 to bring in 3.3-rc fixes alr=
eady merged)
Merging l2-mtd/master (309756e mtd : change the location of the ONFI detect=
ed log)
CONFLICT (content): Merge conflict in drivers/mtd/chips/cfi_cmdset_0002.c
Merging crypto/master (8940426 crypto: twofish-x86_64/i586 - set alignmask =
to zero)
CONFLICT (content): Merge conflict in arch/arm/mach-tegra/fuse.c
Merging sound/for-next (c1536d8 Merge branch 'topic/hda' into for-next)
CONFLICT (content): Merge conflict in sound/soc/mxs/mxs-pcm.h
CONFLICT (content): Merge conflict in sound/soc/imx/imx-pcm-dma-mx2.c
Merging sound-asoc/for-next (4ca757b Merge branch 'for-3.4' into asoc-next)
Merging cpufreq/next (fd0ef7a [CPUFREQ] CPUfreq ondemand: update sampling r=
ate without waiting for next sampling)
Merging quilt/rr (2a22b63 cpumask: remove old cpu_*_map.)
CONFLICT (content): Merge conflict in arch/arm/kernel/kprobes.c
Merging input/next (fa3e44f Input: atmel-wm97xx - convert to dev_pm_ops)
Merging input-mt/for-next (7491f3d bcm5974: Add pointer and buttonpad prope=
rties)
Merging block/for-next (b3021da Merge branch 'for-3.3/core' into for-next)
Merging quilt/device-mapper (347f18f Commit unwritten data every second to =
prevent too much building up. In future we might make the commit interval t=
unable.)
Merging embedded/master (4744b43 embedded: fix vc_translate operator preced=
ence)
Merging firmware/master (6e03a20 firmware: speed up request_firmware(), v3)
Merging pcmcia/master (80af9e6 pcmcia at91_cf: fix raw gpio number usage)
CONFLICT (content): Merge conflict in drivers/pcmcia/soc_common.c
Merging battery/master (913272b Merge git://git.infradead.org/users/cbou/ba=
ttery-urgent)
Merging mmc/mmc-next (5cdc5a0 mmc: core: Detect card removal on I/O error)
CONFLICT (content): Merge conflict in include/linux/mmc/host.h
CONFLICT (content): Merge conflict in drivers/mmc/host/atmel-mci.c
Merging kgdb/kgdb-next (0e997a4 KDB: Fix usability issues relating to the '=
enter' key.)
Merging slab/for-next (96438bc Merge branch 'slub/cleanups' into for-next)
Merging uclinux/for-next (5e442a4 Revert "proc: fix races against execve() =
of /proc/PID/fd**")
Merging md/for-next (0850820 md/raid5: use atomic_dec_return() instead of a=
tomic_dec() and atomic_read().)
Merging mfd/for-next (2fcf164 mfd: Fix a typo in MFD_MAX8997 Kconfig entry)
CONFLICT (content): Merge conflict in drivers/mfd/ab8500-core.c
Merging drm/drm-next (81ffbbe drm/radeon: fix deferred page-flip detection =
logic on Avivo-based ASICs)
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/intel_ringbuffer=
.c
Merging fbdev/fbdev-next (0d04c58 Merge branch 'fbdev-for-linus' into fbdev=
-next)
Merging viafb/viafb-next (91dc1be viafb: LCD bpp cleanup)
Merging omap_dss2/for-next (9a90168 OMAPDSS: HDMI: Disable DDC internal pul=
l up)
Merging regulator/for-next (a2ce876 Merge branches 'regulator-linus' and 'r=
egulator-drivers' into regulator-next)
Merging security/next (df91e49 TOMOYO: Fix mount flags checking order.)
Merging selinux/master (a9ab18a selinux: include flow.h where used rather t=
han get it indirectly)
Merging lblnet/master (7e27d6e Linux 2.6.35-rc3)
Merging watchdog/linux-next (d6b7074 watchdog: pnx4008: don't use __raw_-ac=
cessors)
Merging dwmw2-iommu/master (c3b92c8 Linux 3.1)
Merging iommu/next (b1ad1ef Merge branches 'iommu/fixes', 'arm/tegra' and '=
x86/amd' into next)
Merging osd/linux-next (0aa436b exofs: Cap on the memcpy() size)
Merging jc_docs/docs-next (5c050fb docs: update the development process doc=
ument)
Merging trivial/for-next (d7ec70f writeback: fix fn name in writeback_inode=
s_sb_nr_if_idle() comment header)
CONFLICT (content): Merge conflict in drivers/watchdog/pnx4008_wdt.c
Merging audit/for-next (dcd6c92 Linux 3.3-rc1)
Merging pm/linux-next (ed819e3 Merge branch 'pm-qos')
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
CONFLICT (modify/delete): arch/powerpc/platforms/iseries/Kconfig deleted in=
 HEAD and modified in devicetree/devicetree/next. Version devicetree/device=
tree/next of arch/powerpc/platforms/iseries/Kconfig left in tree.
$ git rm -f arch/powerpc/platforms/iseries/Kconfig
Merging spi/spi/next (14af60b spi/pl022: Add high priority message pump sup=
port)
Merging tip/auto-latest (300c1f3 Merge branch 'perf/core' into auto-latest)
CONFLICT (content): Merge conflict in include/net/sock.h
CONFLICT (modify/delete): arch/m68k/kernel/process_no.c deleted in HEAD and=
 modified in tip/auto-latest. Version tip/auto-latest of arch/m68k/kernel/p=
rocess_no.c left in tree.
CONFLICT (modify/delete): arch/m68k/kernel/process_mm.c deleted in HEAD and=
 modified in tip/auto-latest. Version tip/auto-latest of arch/m68k/kernel/p=
rocess_mm.c left in tree.
$ git rm -f arch/m68k/kernel/process_no.c arch/m68k/kernel/process_mm.c
Applying: sched/rt: Use schedule_preempt_disabled() in m68k
Merging rcu/rcu/next (1cc8596 rcu: Stop spurious warnings from synchronize_=
sched_expedited)
Merging cputime/cputime (c3e0ef9 [S390] fix cputime overflow in uptime_proc=
_show)
Merging uprobes/for-next (f0b42ab uprobes/core: handle breakpoint and signa=
l step exception.)
CONFLICT (content): Merge conflict in kernel/fork.c
CONFLICT (add/add): Merge conflict in kernel/events/uprobes.c
CONFLICT (content): Merge conflict in kernel/events/Makefile
CONFLICT (add/add): Merge conflict in include/linux/uprobes.h
CONFLICT (content): Merge conflict in fs/signalfd.c
CONFLICT (content): Merge conflict in fs/eventpoll.c
CONFLICT (add/add): Merge conflict in arch/x86/kernel/uprobes.c
CONFLICT (add/add): Merge conflict in arch/x86/include/asm/uprobes.h
Merging cgroup/for-next (3ce3230 cgroup: Walk task list under tasklist_lock=
 in cgroup_enable_task_cg_list)
Merging kmemleak/kmemleak (d65b4e9 Linux 3.3-rc3)
Merging kvm/linux-next (ab0bd7d KVM: Ensure all vcpus are consistent with i=
n-kernel irqchip settings)
$ git reset --hard HEAD^
Merging refs/next/20120305/kvm
Merging oprofile/for-next (b9e7f8e Merge branches 'oprofile/urgent' and 'op=
rofile/core' into oprofile/master)
CONFLICT (content): Merge conflict in tools/perf/util/header.c
Merging xen/upstream/xen (59e9a6b Merge branch 'upstream/ticketlock-cleanup=
' into upstream/xen)
CONFLICT (content): Merge conflict in arch/x86/include/asm/cmpxchg.h
Merging xen-two/linux-next (eb76442 Merge branch 'stable/for-linus-3.4' int=
o linux-next)
Merging xen-pvhvm/linux-next (b056b6a xen: suspend: remove xen_hvm_suspend)
Merging percpu/for-next (adb7950 percpu: fix __this_cpu_{sub,inc,dec}_retur=
n() definition)
Merging workqueues/for-next (6b3da11 Merge branch 'for-3.3' of git://git.ke=
rnel.org/pub/scm/linux/kernel/git/tj/percpu)
Merging hwpoison/hwpoison (46e387b Merge branch 'hwpoison-hugepages' into h=
wpoison)
Merging sysctl/master (4e75732 sysctl: Don't call sysctl_follow_link unless=
 we are a link.)
CONFLICT (content): Merge conflict in fs/proc/proc_sysctl.c
Merging regmap/for-next (52c6221 Merge remote-tracking branches 'regmap/top=
ic/bulk', 'regmap/topic/devm', 'regmap/topic/patch' and 'regmap/topic/sync'=
 into regmap-next)
Merging hsi/for-next (43139a6 HSI: hsi_char: Update ioctl-number.txt)
Merging driver-core/driver-core-next (f6e8a1d w1_bq27000: Only one thread c=
an access the bq27000 at a time.)
CONFLICT (content): Merge conflict in include/linux/pci.h
CONFLICT (content): Merge conflict in drivers/base/cpu.c
Merging tty/tty-next (6623d64 tty: keyboard.c: add uaccess.h to fix a build=
 problem on sparc32)
Merging usb/usb-next (5f0b3f9 usb: otg: ab8500-usb: make probe() work again)
CONFLICT (content): Merge conflict in drivers/usb/host/ehci-fsl.h
Merging staging/staging-next (1ec41a3 staging: ozwpan: remove debug allocat=
or)
Merging char-misc/char-misc-next (b222258 misc: bmp085: Use unsigned long t=
o store jiffies)
Merging tmem/linux-next (b05b561 Merge branch 'devel/frontswap.v13' into li=
nux-next)
Applying: mm: frontswap: update for security_vm_enough_memory API change
Merging writeback/writeback-for-next (977b7e3 writeback: fix dereferencing =
NULL bdi->dev on trace_writeback_queue)
Merging arm-dt/devicetree/arm-next (ede338f dt: add documentation of ARM dt=
 boot interface)
Merging hwspinlock/linux-next (8b37fcf hwspinlock: add MAINTAINERS entries)
Merging pinctrl/for-next (057052d Merge branch 'pinctrl-tegra-for-next-diet=
' into for-next)
Merging moduleh/for-sfr (807c278 Merge branch 'module-mips' into for-sfr)
CONFLICT (content): Merge conflict in drivers/usb/dwc3/dwc3-omap.c
Merging vhost/linux-next (1e05b62 sh: use the the PCI channels's io_map_bas=
e)
Merging kmap_atomic/kmap_atomic (019e9ad feature-removal-schedule.txt: sche=
dule the deprecated form of kmap_atomic() for removal)
CONFLICT (content): Merge conflict in drivers/staging/zram/zram_drv.c
CONFLICT (content): Merge conflict in drivers/staging/zcache/zcache-main.c
CONFLICT (content): Merge conflict in drivers/scsi/storvsc_drv.c
CONFLICT (content): Merge conflict in drivers/net/ethernet/intel/e1000e/net=
dev.c
Merging modem-shm/for-next (3cff1cc caif_shm: Add CAIF driver for Shared me=
mory for M7400)
Merging memblock/memblock-kill-early_node_map (7bd0b0f memblock: Reimplemen=
t memblock allocation using reverse free area iterator)
Merging remoteproc/for-next (e12bc14 remoteproc: s/big switch/lookup table/)
CONFLICT (content): Merge conflict in include/linux/virtio_ids.h
Merging irqdomain/irqdomain/next (e7cc3ac dt: fix twl4030 for non-dt compil=
e on x86)
CONFLICT (content): Merge conflict in arch/powerpc/sysdev/mpic.c
CONFLICT (content): Merge conflict in arch/c6x/Kconfig
CONFLICT (content): Merge conflict in arch/arm/common/gic.c
Merging gpio/gpio/next (e4e449e gpiolib: Add comments explaining the _cansl=
eep() WARN_ON()s)
CONFLICT (content): Merge conflict in include/linux/mfd/tps65910.h
Merging arm-soc/for-next (6469d9d Merge branch 'staging/kirkwood/dt' into f=
or-next)
CONFLICT (modify/delete): arch/arm/plat-mxc/audmux-v1.c deleted in HEAD and=
 modified in arm-soc/for-next. Version arm-soc/for-next of arch/arm/plat-mx=
c/audmux-v1.c left in tree.
CONFLICT (content): Merge conflict in arch/arm/mach-tegra/Makefile
CONFLICT (content): Merge conflict in arch/arm/mach-imx/mm-imx3.c
CONFLICT (content): Merge conflict in arch/arm/Kconfig
CONFLICT (content): Merge conflict in Documentation/feature-removal-schedul=
e.txt
$ git rm -f arch/arm/plat-mxc/audmux-v1.c
Merging kvmtool/master (402e975 kvm tools: Bring mptables back in case if n=
o firmware used)
Merging dma-mapping/dma-mapping-next (6cc2bf1 common: DMA-mapping: add NON-=
CONSISTENT attribute)
Merging ktest/for-next (be405f9 ktest: Add INGORE_ERRORS to ignore warnings=
 in boot up)
Merging scsi-post-merge/merge-base:master ()
$ git checkout akpm
Applying: kmsg_dump: don't run on non-error paths by default
Applying: kprobes: return proper error code from register_kprobe()
Applying: aio: wake up waiters when freeing unused kiocbs
Applying: vfork: introduce complete_vfork_done()
Applying: vfork: make it killable
Applying: coredump_wait: don't call complete_vfork_done()
Applying: vfork: kill PF_STARTING
Applying: hung_task: fix the broken rcu_lock_break() logic
Applying: pps: class_create() returns an ERR_PTR, not NULL
Applying: c2port: class_create() returns an ERR_PTR
Applying: drivers/rtc/rtc-r9701.c: fix crash in r9701_remove()
Applying: memcg: fix deadlock by inverting lrucare nesting
Applying: floppy/scsi: fix setting of BIO flags
Applying: debugobjects: Fix selftest for static warnings
Applying: memcg: fix GPF when cgroup removal races with last exit
Applying: alpha: fix 32/64-bit bug in futex support
Applying: mm: thp: fix BUG on mm->nr_ptes
Applying: memcg: fix mapcount check in move charge code for anonymous page
Applying: rapidio/tsi721: fix bug in inbound doorbell handler
Applying: net/netfilter/nf_conntrack_netlink.c: fix Oops on container destr=
oy
Applying: acerhdf: add support for Aspire 1410 BIOS v1.3314
Applying: acerhdf: add support for new hardware
Applying: acerhdf: lowered default temp fanon/fanoff values
Applying: arch/x86/platform/iris/iris.c: register a platform device and a p=
latform driver
Applying: x86, olpc-xo15-sci: enable lid close wakeup control through sysfs
Applying: geos: platform driver for Geos and Geos2 single-board computers
Applying: platform-drivers-x86: convert drivers/platform/x86/* to use modul=
e_platform_driver()
Applying: drivers/platform/x86/sony-laptop.c: fix scancodes
Applying: platform, x86: kill off Moorestown
Applying: intel_scu_ipc: remove Moorestown support
Applying: platform-x86: intel_mid_thermal: add msic_thermal alias
Applying: platform-x86: intel_mid_thermal: convert to use Intel MSIC API
Applying: platform-x86: intel_mid_thermal: turn off thermistor voltage by d=
efault
Applying: intel_mid_powerbtn: use MSIC read/write instead of ipc_scu
Applying: intel_mid_powerbtn: mark irq as IRQF_NO_SUSPEND
Applying: drivers/platform/x86/acer-wmi.c: no wifi rfkill on Lenovo machines
Applying: x86, olpc: add debugfs interface for EC commands
Applying: x86, mm: fix the size calculation of mapping tables
Applying: alix2: supplement driver to include GPIO button support
Applying: x86: net5501: platform driver for Soekris Engineering net5501 sin=
gle-board computer
Applying: x86: use this_cpu_xxx to replace percpu_xxx funcs
Applying: x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs-fix
Applying: x86: change percpu_read_stable() to this_cpu_read_stable()
Applying: x86-change-percpu_read_stable-to-this_cpu_read_stable-fix
Applying: x86 PCI: fix identity mapping for sandy bridge
Applying: x86, pci: increase the number of iommus supported to be MAX_IO_AP=
ICS
Applying: x86-pci-increase-the-number-of-iommus-supported-to-be-max_io_apic=
s-v2
Applying: x86-pci-increase-the-number-of-iommus-supported-to-be-max_io_apic=
s-v2-fix
Applying: arch/arm/mach-ux500/mbox-db5500.c: world-writable sysfs fifo file
Applying: arm, exec: remove redundant set_fs(USER_DS)
Applying: arm: use set_current_blocked() and block_sigmask()
Applying: avr32: don't mask signals in the error path
Applying: avr32: use set_current_blocked() in handle_signal/sys_rt_sigreturn
Applying: avr32: use block_sigmask()
Applying: powerpc: use set_current_blocked() and block_sigmask()
Applying: drivers/media/video/uvc/uvc_driver.c: use linux/atomic.h
Applying: Hexagon: use set_current_blocked() and block_sigmask()
Applying: drivers/idle/intel_idle.c: fix confusing code identation
Applying: irqs: fix long-term regression in genirq irq_set_irq_type() handl=
ing
Applying: softirq: reduce invoke_softirq() code duplication
Applying: tile: use set_current_blocked() and block_sigmask()
Applying: hrtimers: Special-case zero length sleeps
Applying: cs5535-clockevt: don't ignore MFGPT on SMP-capable kernels
Applying: cs5535-clockevt: allow the MFGPT IRQ to be shared
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
Applying: bluetooth: add support for BCM20702A0 [0a5c:21e6]
Applying: ocfs2: use find_last_bit()
Applying: ocfs2: use bitmap_weight()
Applying: parisc: use set_current_blocked() and block_sigmask()
Applying: xtensa: don't reimplement force_sigsegv()
Applying: xtensa: no need to reset handler if SA_ONESHOT
Applying: xtensa: don't mask signals if we fail to setup signal stack
Applying: xtensa: use set_current_blocked() and block_sigmask()
Applying: slab: introduce kmalloc_array()
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
Applying: hugetlb: drop prev_vma in hugetlb_get_unmapped_area_topdown()
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
Applying: vfs: correctly set the dir i_mutex lockdep class
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
Applying: ipc: provide generic compat versions of IPC syscalls
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
Merging akpm (2e7e5de notify_change(): check that i_mutex is held)
Applying: power, max8998: we need at least one include of module.h

--Signature=_Tue__6_Mar_2012_18_07_46_+1100_x.tlt.=U1sh=JLd9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPVbfCAAoJEECxmPOUX5FE4rYQAJUPsAr0/RZ0hkGBnD7D0liI
O9AfyoWsmFEmFd7tGhgv3VFivm6j7GiNELbP6JaNzzyYNakX8Ej9G6cBpQJ2z4+B
LuumhPKzQHRVc0vrg7Knmepa2jeNsNaBpcueSDAjR3A8oEm0dQfcxwjAPHQEgdCG
Ve5Or9XpyxItO8NhK8qWY/RwjwgtwGx8sMsxPr8wR8VaDmH8aMHtTrD5CY53QZJd
kkJFlYWLkEZYb7oEwBj718oUNRGSPoiWoLTeyy4uHR5wMfkXnnP3m3guAHUkXm7a
fDRsJw+uE2To4IpK9TTxN9Jg0YZQCb8FHYLxEvVMclJi6DWiOfTkONobwhgMPjfv
7DK2Kb0E4W23OciZ0wsj4pRrCAe5GH3xe6SHUuQFjGcf6G9xKf3N2v1aAnjAfQ6i
pZhtUIaWnM5Jcm+88xdOBlLcHDy0NUoG3QwKV3zmu4fmeKl2J6FKVLnGQWZS7un1
1HmiLUDwiZa0hxw/Gzd89auaUxo6mfZ7Dk9ZNccvXKgP1dcsNGWa9S09UV4d3uCd
Bh3ta6B1FLGis6GRivhHCUIN+Vh8f9tSCTUKu05Ms/fX/LhSZhOmVCbMA2TEoL2M
0iqp1AGKQiNVcrvAywf2nOkwOomqcc+e9O/YT/eg1+wVwq1z/m9l4OEU9/KPLIGo
2LHZdL/zQSreVLP6hWIh
=0hKo
-----END PGP SIGNATURE-----

--Signature=_Tue__6_Mar_2012_18_07_46_+1100_x.tlt.=U1sh=JLd9--

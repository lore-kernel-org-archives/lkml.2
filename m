Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932119Ab2K3G6P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 01:58:15 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:48397 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756254Ab2K3G6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 01:58:11 -0500
Date: Fri, 30 Nov 2012 17:58:01 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <linux-next@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Nov 30
Message-Id: <20121130175801.cb2016e51a839da5e165aaf2@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__30_Nov_2012_17_58_01_+1100_++03mAPaLCS9LgOf"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__30_Nov_2012_17_58_01_+1100_++03mAPaLCS9LgOf
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20121129:

The powerpc tree still had its build failure for which I applied a patch.

The wireless-next tree lost its conflict.

The drm tree gained a conflict against Linus' tree.

The modules tree still had its build failure so I used the version from
next-20121115.

The kvm tree gained a conflict against the tip tree.

The arm-soc tree gained a conflict against the ompa_dss2 tree.

The signal tree gained a conflict against the ftrace tree.

The akpm tree gained a conflict against Linus' tree and also lost a patch
that turned up elsewhere.

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

We are up to 211 trees (counting Linus' and 28 trees of patches pending
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
Merging origin/master (e9296e8 Merge git://git.kernel.org/pub/scm/linux/ker=
nel/git/davem/net)
Merging fixes/master (12250d8 Merge branch 'i2c-embedded/for-next' of git:/=
/git.pengutronix.de/git/wsa/linux)
Merging kbuild-current/rc-fixes (bad9955 menuconfig: Replace CIRCLEQ by lis=
t_head-style lists.)
Merging arm-current/fixes (ea3aacf ARM: 7586/1: sp804: set cpumask to cpu_p=
ossible_mask for clock event device)
Merging m68k-current/for-linus (34fa78b m68k: fix sigset_t accessor functio=
ns)
Merging powerpc-merge/merge (e716e01 powerpc/eeh: Do not invalidate PE prop=
erly)
Merging sparc/master (194d983 Merge tag 'sound-3.7' of git://git.kernel.org=
/pub/scm/linux/kernel/git/tiwai/sound)
Merging net/master (e196c0e bonding: fix race condition in bonding_store_sl=
aves_active)
Merging sound-current/for-linus (d846b17 ALSA: hda - Fix build without CONF=
IG_PM)
Merging pci-current/for-linus (ff8e59b PCI/portdrv: Don't create hotplug sl=
ots unless port supports hotplug)
Merging wireless/master (6bdd253 mac80211: fix remain-on-channel (non-)canc=
elling)
Merging driver-core.current/driver-core-linus (77b6706 Linux 3.7-rc5)
Merging tty.current/tty-linus (b1a925f tty vt: Fix a regression in command =
line edition)
Merging usb.current/usb-linus (f4a75d2e Linux 3.7-rc6)
Merging staging.current/staging-linus (f4a75d2e Linux 3.7-rc6)
Merging char-misc.current/char-misc-linus (f4a75d2e Linux 3.7-rc6)
Merging input-current/for-linus (0a0d628 ARM - OMAP: ads7846: fix pendown d=
ebounce setting)
Merging md-current/for-linus (874807a md/raid1{,0}: fix deadlock in bitmap_=
unplug.)
Merging audit-current/for-linus (c158a35 audit: no leading space in audit_l=
og_d_path prefix)
Merging crypto-current/master (9efade1 crypto: cryptd - disable softirqs in=
 cryptd_queue_worker to prevent data corruption)
Merging ide/master (9974e43 ide: fix generic_ide_suspend/resume Oops)
Merging dwmw2/master (244dc4e Merge git://git.infradead.org/users/dwmw2/ran=
dom-2.6)
Merging sh-current/sh-fixes-for-linus (4403310 SH: Convert out[bwl] macros =
to inline functions)
Merging irqdomain-current/irqdomain/merge (a0d271c Linux 3.6)
Merging devicetree-current/devicetree/merge (0e622d3 of/address: sparc: Dec=
lare of_iomap as an extern function for sparc again)
Merging spi-current/spi/merge (a0d271c Linux 3.6)
Merging gpio-current/gpio/merge (96b7064 gpio/tca6424: merge I2C transactio=
ns, remove cast)
Merging rr-fixes/fixes (b251f0f Merge git://git.kernel.org/pub/scm/linux/ke=
rnel/git/davem/net)
Merging asm-generic/master (9b04ebd asm-generic/io.h: remove asm/cacheflush=
.h include)
Merging arm/for-next (5350eb2 Merge branch 'devel-stable' into for-next)
Merging arm-perf/for-next/perf (3d70f8c Linux 3.7-rc4)
Merging davinci/davinci-next (fe0d422 Linux 3.0-rc6)
Merging xilinx/arm-next (74cad60 serial: xilinx_uartps: get clock rate info=
 from dts)
Merging arm64/upstream (f2bd5d2 ARM64: Remove incorrect Kconfig symbol HAVE=
_SPARSE_IRQ)
Merging blackfin/for-linus (9d84601 Blackfin: dpmc: use module_platform_dri=
ver macro)
Merging c6x/for-linux-next (93bbd0c c6x: use generic kvm_para.h)
Merging cris/for-next (eacb25c UAPI: Fix up empty files in arch/cris/)
Merging hexagon/linux-next (e1858b2 Hexagon: Copyright marking changes)
Merging ia64/next (7843ae0 Merge branch 'pstore_mevent' into next)
Merging m68k/for-next (5fec45a m68k/sun3: Fix instruction faults)
Merging m68knommu/for-next (5a1b2a1 m68knommu: modify clock code so it can =
be used by all ColdFire CPU types)
Merging microblaze/next (f229605 microblaze: dma-mapping: Support debug_dma=
_mapping_error)
Merging mips/mips-for-linux-next (46845cf Merge branch 'mips-next' of http:=
//dev.phrozen.org/githttp/mips-next into mips-for-linux-next)
Merging openrisc/for-upstream (634bd40 openrisc: use kbuild.h instead of de=
fining macros in asm-offset.c)
Merging parisc/for-next (949a05d [PARISC] fix virtual aliasing issue in get=
_shared_area())
Merging powerpc/next (1a9bd45 powerpc+of: Export of_reconfig_notifier_[regi=
ster,unregister])
Applying: lib: disable PSERIES_RECONFIG_NOTIFIER_ERROR_INJECT
Merging 4xx/next (2074b1d powerpc: Fix irq distribution)
Merging mpc5xxx/next (451815b powerpc: mpc5200: Add a3m071 board support)
Merging galak/next (1723d90 powerpc/dma/raidengine: add raidengine device)
Merging s390/features (683c3dc s390/ccwgroup: allow drivers to call set_{on=
,off}line)
Merging sh/sh-latest (0dd4d5c sh: Fix up more fallout from pointless ARM __=
iomem churn.)
Merging sparc-next/master (43c422e apparmor: fix apparmor OOPS in audit_log=
_untrustedstring+0x1c/0x40)
Merging tile/master (ddffeb8 Linux 3.7-rc1)
Merging unicore32/unicore32 (c284464 arch/unicore32: remove CONFIG_EXPERIME=
NTAL)
Merging xtensa/for_next (518129b xtensa: add XTFPGA DTS)
Merging btrfs/next (c37b2b6 Btrfs: do not bug when we fail to commit the tr=
ansaction)
Merging ceph/master (3515297 rbd: activate v2 image support)
Merging cifs/for-next (0950d2a cifs: Add handling of blank password option)
Merging configfs/linux-next (b930c26 Merge branch 'for-linus' of git://git.=
kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (e4bc652 eCryptfs: Avoid unnecessary disk read and da=
ta decryption during writing)
Merging ext3/for_next (55eede2 quota: Use the pre-processor to compile out =
quotactl_cmd_write when !CONFIG_BLOCK)
Merging ext4/dev (f3b5929 ext4: remove calls to ext4_jbd2_file_inode() from=
 delalloc write path)
Merging f2fs/dev (7117448 f2fs: fix endian conversion bugs reported by spar=
se)
Merging fuse/for-next (23ab0c7 cuse: do not register multiple devices with =
identical names)
Merging gfs2/master (1e2d9d4 GFS2: Set gl_object during inode create)
Merging jfs/jfs-next (4e7a4b0 jfs: Fix FITRIM argument handling)
Merging logfs/master (3394661 Fix the call to BUG() caused by no free segme=
nt found)
Merging nfs/linux-next (f937b66 Merge branch 'bugfixes' into linux-next)
Merging nfsd/nfsd-next (f3c7521 NFSD: Fold fault_inject.h into state.h)
Merging ocfs2/linux-next (4538df6 ocfs2: Don't spam on -EDQUOT.)
Merging omfs/for-next (976d167 Linux 3.1-rc9)
Merging squashfs/master (4b0180a Squashfs: add mount time sanity check for =
block_size and block_log match)
Merging v9fs/for-next (552aad0 9P: Fix race between p9_write_work() and p9_=
fd_request())
Merging ubifs/linux-next (a28ad42 UBIFS: fix mounting problems after power =
cuts)
Merging xfs/for-next (b870553 xfs: fix stray dquot unlock when reclaiming d=
quots)
CONFLICT (content): Merge conflict in fs/xfs/xfs_fsops.c
Merging pci/next (053f328 Merge branch 'pci/don-sriov' into next)
Merging hid/for-next (8f348a1 Merge branch 'for-3.8/upstream' into for-next)
Merging i2c/master (c1ec1ae i2c: Mention functionality flags in SMBus proto=
col documentation)
Merging i2c-embedded/i2c-embedded/for-next (972deb4 i2c: omap: Remove the O=
MAP_I2C_FLAG_RESET_REGS_POSTIDLE flag)
CONFLICT (content): Merge conflict in drivers/i2c/busses/i2c-omap.c
Merging jdelvare-hwmon/master (d2d9cf3 hwmon: (it87) Support PECI for addit=
ional chips)
Merging hwmon-staging/hwmon-next (8b59397 hwmon: (da9055) Fix chan_mux[DA90=
55_ADC_ADCIN3] setting)
Merging v4l-dvb/master (db46f44 Merge /home/v4l/v4l/for_upstream)
Merging kbuild/for-next (a5ce08d Merge branches 'kbuild/kbuild' and 'kbuild=
/kconfig' into kbuild/for-next)
Merging kconfig/for-next (4eae518 localmodconfig: Fix localyesconfig to set=
 to 'y' not 'm')
Merging libata/NEXT (a52f514 ata: Convert dev_printk(KERN_<LEVEL> to dev_<l=
evel>()
Merging infiniband/for-next (78c9024 Merge branches 'cma' and 'mlx4' into f=
or-next)
Merging pstore/master (b042e47 pstore/ram: Fix undefined usage of rounddown=
_pow_of_two(0))
Merging acpi/next (32cc109 tools/power turbostat: v3.0: monitor Watts and T=
emperature)
Merging cpuidle/cpuidle-next (3cf7997 acpi: intel_idle : break dependency b=
etween modules)
CONFLICT (content): Merge conflict in include/linux/cpuidle.h
CONFLICT (add/add): Merge conflict in drivers/cpuidle/coupled.c
Merging cpupowerutils/master (f166033 cpupower tools: add install target to=
 the debug tools' makefiles)
Merging thermal/next (d12250e thermal: rcar: add rcar_zone_to_priv() macro)
Merging ieee1394/for-next (790198f firewire: cdev: fix user memory corrupti=
on (i386 userland on amd64 kernel))
Merging ubi/linux-next (6a059ab UBI: use list_move_tail instead of list_del=
/list_add_tail)
Merging dlm/next (da8c666 dlm: fix lvb invalidation conditions)
Merging swiotlb/linux-next (af51a9f swiotlb: Do not export swiotlb_bounce s=
ince there are no external consumers)
Merging scsi/for-next (a3667aa [SCSI] csiostor: Chelsio FCoE offload driver)
Merging target-updates/for-next (3e4f574 ib_srpt: Convert TMR path to targe=
t_submit_tmr)
Merging target-merge/for-next-merge (6f0c058 Linux 3.7-rc2)
Merging ibft/linux-next (935a9fe ibft: Fix finding IBFT ACPI table on UEFI)
Merging isci/all (6734092 isci: add a couple __iomem annotations)
Merging slave-dma/next (858e3fc dmaengine: fix !of_dma compilation warning)
Merging dmaengine/next (a2bd114 netdma: adding alignment check for NETDMA o=
ps)
Merging net-next/master (bb72882 core: make GRO methods static.)
CONFLICT (content): Merge conflict in drivers/net/ethernet/mellanox/mlx4/en=
_rx.c
CONFLICT (modify/delete): arch/m68k/include/uapi/asm/socket.h deleted in HE=
AD and modified in net-next/master. Version net-next/master of arch/m68k/in=
clude/uapi/asm/socket.h left in tree.
$ git rm -f arch/m68k/include/uapi/asm/socket.h
Merging wireless-next/master (0751f86 bcma: add more package IDs)
Merging bluetooth/master (92a185b Bluetooth: AMP: Mark controller radio pow=
ered down after HCIDEVDOWN)
Merging mtd/master (35f95d2 Merge tag 'for-linus-20121123' of git://git.inf=
radead.org/mtd-2.6)
Merging l2-mtd/master (0f722de mtd: m25p80: modify info for Micron N25Q128)
Merging crypto/master (a465348 crypto: s5p-sss - Fix compilation error)
Merging drm/drm-next (7136470 Merge branch 'for-airlied' of git://people.fr=
eedesktop.org/~danvet/drm-intel into drm-next)
CONFLICT (content): Merge conflict in drivers/gpu/drm/nouveau/core/engine/d=
isp/nv50.c
Merging sound/for-next (9b4ef97 ALSA: usb - Don't create "Speaker" mixer co=
ntrols on headphones and headsets)
Merging sound-asoc/for-next (536bc8f Merge branches 'fix/fsl', 'topic/ab850=
0', 'topic/adsp', 'topic/ak4104', 'topic/ak4535', 'topic/ak4642', 'topic/at=
mel', 'topic/cs4271', 'topic/da7210', 'topic/da9055', 'topic/davinci', 'top=
ic/dmaengine', 'topic/fsi', 'topic/fsl', 'topic/hotplug', 'topic/jack', 'to=
pic/jz4740', 'topic/kirkwood', 'topic/lm49453', 'topic/log', 'topic/max9809=
0', 'topic/rt5631', 'topic/samsung', 'topic/si476x', 'topic/tlv320aic32x4',=
 'topic/ux500', 'topic/wm0010', 'topic/wm2000', 'topic/wm2200', 'topic/wm83=
50', 'topic/wm8400', 'topic/wm8510', 'topic/wm8741', 'topic/wm8750', 'topic=
/wm8753', 'topic/wm8770', 'topic/wm8804', 'topic/wm8962', 'topic/wm8971', '=
topic/wm8978', 'topic/wm8985', 'topic/wm8988', 'topic/wm8993', 'topic/wm899=
4' and 'topic/wm8995' of git://git.kernel.org/pub/scm/linux/kernel/git/broo=
nie/sound into asoc-next)
Merging modules/modules-next (58876af moduleparam: use __UNIQUE_ID())
$ git reset --hard HEAD^
Merging refs/next/20121115/modules
Merging virtio/virtio-next (b15a62a virtio-mmio: Fix irq parsing in command=
 line parameter)
Merging input/next (1a22e16 Input: gpio-keys-polled - honor 'autorepeat' se=
tting in platform data)
Merging input-mt/for-next (6f0c058 Linux 3.7-rc2)
Merging cgroup/for-next (9718ceb cgroup: list_del_init() on removed events)
CONFLICT (content): Merge conflict in net/sched/cls_cgroup.c
CONFLICT (content): Merge conflict in mm/memcontrol.c
Merging block/for-next (95678ef Merge branch 'for-3.8/core' into for-next)
Merging device-mapper/master (cee3685 track_chunk is always called with int=
errupts enabled. Consequently, we do not need to save and restore interrupt=
 state in "flags" variable. This patch changes spin_lock_irqsave to spin_lo=
ck_irq and spin_unlock_irqrestore to spin_unlock_irq.)
Merging embedded/master (4744b43 embedded: fix vc_translate operator preced=
ence)
Merging firmware/master (6e03a20 firmware: speed up request_firmware(), v3)
Merging pcmcia/master (80af9e6 pcmcia at91_cf: fix raw gpio number usage)
Merging mmc/mmc-next (2656109 mmc: sdhci-spear: Don't call clk_{un}prepare(=
) in suspend/resume)
Merging kgdb/kgdb-next (58bcdf6 tty/console: fix warnings in drivers/tty/se=
rial/kgdboc.c)
Merging slab/for-next (f1d58d7 Merge branch 'slab/next' into for-next)
CONFLICT (content): Merge conflict in mm/slob.c
Merging uclinux/for-next (ddffeb8 Linux 3.7-rc1)
Merging md/for-next (fb07cce md/raid5: use async_tx_quiesce() instead of op=
en-coding it.)
Merging mfd/for-next (64cdfe2 mfd: tps65090: MFD_TPS65090 needs to select R=
EGMAP_IRQ)
CONFLICT (content): Merge conflict in drivers/mmc/host/Kconfig
CONFLICT (content): Merge conflict in drivers/mfd/twl-core.c
CONFLICT (modify/delete): drivers/input/touchscreen/ti_tscadc.c deleted in =
mfd/for-next and modified in HEAD. Version HEAD of drivers/input/touchscree=
n/ti_tscadc.c left in tree.
$ git rm -f drivers/input/touchscreen/ti_tscadc.c
Merging battery/master (eba3b67 max8925_power: Add support for device-tree =
initialization)
Merging fbdev/fbdev-next (cd9d6f1 gbefb: fix compile error)
Merging viafb/viafb-next (838ac78 viafb: avoid refresh and mode lookup in s=
et_par)
Merging omap_dss2/for-next (bb02669 Merge branch 'master' of git://gitoriou=
s.org/linux-omap-dss2/linux into for-linus)
Merging regulator/for-next (4736661 Merge remote-tracking branches 'regulat=
or/fix/wm831x', 'regulator/topic/arizona', 'regulator/topic/as3711', 'regul=
ator/topic/da9052', 'regulator/topic/da9055', 'regulator/topic/log', 'regul=
ator/topic/lp8788', 'regulator/topic/max77686', 'regulator/topic/max8973', =
'regulator/topic/max8997', 'regulator/topic/min', 'regulator/topic/s2mps11'=
, 'regulator/topic/stub', 'regulator/topic/tol', 'regulator/topic/tps65090'=
, 'regulator/topic/tps6586x', 'regulator/topic/tps65910' and 'regulator/top=
ic/tps80031' into regulator-next)
CONFLICT (content): Merge conflict in include/linux/mfd/tps65090.h
Merging security/next (c91c1bf Smack: create a sysfs mount point for smackf=
s)
CONFLICT (content): Merge conflict in security/keys/process_keys.c
CONFLICT (content): Merge conflict in security/keys/keyring.c
CONFLICT (content): Merge conflict in security/keys/keyctl.c
CONFLICT (content): Merge conflict in net/dns_resolver/dns_key.c
Merging selinux/master (c2d7b24 Merge tag 'v3.4' into 20120409)
Merging lblnet/master (7e27d6e Linux 2.6.35-rc3)
Merging watchdog/master (58ddfed Merge branch 'master' of ../linux-watchdog)
Merging dwmw2-iommu/master (c3b92c8 Linux 3.1)
Merging iommu/next (f6cffc1 Merge branches 'iommu/fixes', 'dma-debug', 'x86=
/amd', 'arm/exynos', 'x86/vt-d' and 'arm/tegra' into next)
Merging vfio/next (74d8627 vfio-pci: Enable device before attempting reset)
Merging osd/linux-next (b6755ff osduld: Add osdname & systemid sysfs at scs=
i_osd class)
Merging jc_docs/docs-next (5c050fb docs: update the development process doc=
ument)
Merging trivial/for-next (8fdbb34 messages: i2o: Fix typo in messages/i2o)
Merging audit/for-next (dcd6c92 Linux 3.3-rc1)
Merging pm/linux-next (5d699e5 Merge branch 'acpi-enumeration-next' into li=
nux-next)
Merging apm/for-next (fb9d78a Merge branch 'for-linus' of git://git.kernel.=
org/pub/scm/linux/kernel/git/jikos/apm)
Merging fsnotify/for-next (1aec9c0 inotify: automatically restart syscalls)
CONFLICT (content): Merge conflict in kernel/audit_tree.c
Merging edac/linux_next (c215786 Merge branch 'fixes' into next)
Merging edac-amd/for-next (a8373ec EDAC: Handle error path in edac_mc_sysfs=
_init() properly)
Merging devicetree/devicetree/next (f3b6159 of/spi: Honour "status=3Ddisabl=
ed" property of device)
Merging dt-rh/for-next (4a92a38 Merge remote-tracking branch 'grant/devicet=
ree/next' into for-next)
Merging spi/spi/next (7431798 of_spi: add generic binding support to specif=
y cs gpio)
Merging spi-mb/spi-next (170c2d0 Merge branch 'spi-mcspi' into spi-next)
Merging tip/auto-latest (a07005c Merge branch 'x86/mm')
Merging ftrace/for-next (bf3071f tracing: Remove unnecessary WARN_ONCE's fr=
om tracing_buffers_splice_read)
Merging rcu/rcu/next (98dbec1 context_tracking: New context tracking susbsy=
stem)
CONFLICT (content): Merge conflict in arch/x86/kernel/ptrace.c
Merging cputime/cputime (c3e0ef9 [S390] fix cputime overflow in uptime_proc=
_show)
Merging uprobes/for-next (0326f5a uprobes/core: Handle breakpoint and singl=
estep exceptions)
Merging kvm/linux-next (e6c7d32 KVM: VMX: fix invalid cpu passed to smp_cal=
l_function_single)
CONFLICT (content): Merge conflict in kernel/sched/core.c
Merging kvm-ppc/kvm-ppc-next (a2ef34a KVM: PPC: Book3S HV: Handle guest-cau=
sed machine checks on POWER7 without panicking)
Merging oprofile/for-next (4400910 oprofile, x86: Fix wrapping bug in op_x8=
6_get_ctrl())
Merging xen/upstream/xen (af3a3ab Merge git://git.kernel.org/pub/scm/linux/=
kernel/git/steve/gfs2-3.0-fixes)
Merging xen-two/linux-next (ca63454 Merge branch 'stable/pvh.v6.1' into lin=
ux-next)
Merging xen-pvhvm/linux-next (b056b6a xen: suspend: remove xen_hvm_suspend)
Merging percpu/for-next (b4916cb percpu: make pcpu_free_chunk() use pcpu_me=
m_free() instead of kfree())
Merging workqueues/for-next (d8318e5 Merge branch 'for-3.8' into for-next)
Merging drivers-x86/linux-next (455f38c eeepc-laptop: fix device reference =
count leakage in eeepc_rfkill_hotplug())
Merging hwpoison/hwpoison (46e387b Merge branch 'hwpoison-hugepages' into h=
wpoison)
Merging sysctl/master (4e474a0 sysctl: protect poll() in entries that may g=
o away)
Merging regmap/for-next (51b6d98 Merge remote-tracking branches 'regmap/top=
ic/domain', 'regmap/topic/table' and 'regmap/topic/type' into regmap-next)
Merging hsi/for-next (43139a6 HSI: hsi_char: Update ioctl-number.txt)
Merging leds/for-next (5c6f844 leds: leds-clevo-mail: Use pr_* instead of p=
rintks)
Merging driver-core/driver-core-next (da095fd acpi: remove use of __devinit)
CONFLICT (content): Merge conflict in lib/Makefile
CONFLICT (content): Merge conflict in drivers/power/max8925_power.c
CONFLICT (content): Merge conflict in drivers/power/da9052-battery.c
CONFLICT (content): Merge conflict in drivers/power/abx500_chargalg.c
CONFLICT (content): Merge conflict in drivers/power/ab8500_fg.c
CONFLICT (content): Merge conflict in drivers/power/ab8500_charger.c
CONFLICT (content): Merge conflict in drivers/power/ab8500_btemp.c
CONFLICT (content): Merge conflict in drivers/pci/quirks.c
CONFLICT (content): Merge conflict in drivers/pci/pci.h
CONFLICT (content): Merge conflict in drivers/mfd/tps65090.c
CONFLICT (content): Merge conflict in drivers/mfd/sta2x11-mfd.c
CONFLICT (content): Merge conflict in drivers/mfd/da9052-core.c
CONFLICT (content): Merge conflict in drivers/mfd/ab8500-core.c
CONFLICT (content): Merge conflict in drivers/gpio/gpio-tps6586x.c
CONFLICT (content): Merge conflict in drivers/dma/dw_dmac.c
Merging tty/tty-next (218cbbd staging/fwserial: Remove superfluous free)
CONFLICT (content): Merge conflict in drivers/tty/serial/xilinx_uartps.c
CONFLICT (content): Merge conflict in drivers/tty/serial/omap-serial.c
Applying: disable the SB105X driver
Merging usb/usb-next (fb37ef9 USB: mark uas driver as BROKEN)
Merging staging/staging-next (8b7a13c staging: r8712u: Fix possible buffer =
overrun)
CONFLICT (add/add): Merge conflict in drivers/staging/fwserial/fwserial.c
CONFLICT (content): Merge conflict in drivers/staging/dgrp/dgrp_tty.c
CONFLICT (content): Merge conflict in drivers/staging/Makefile
CONFLICT (content): Merge conflict in drivers/staging/Kconfig
CONFLICT (content): Merge conflict in drivers/iio/adc/Makefile
CONFLICT (content): Merge conflict in drivers/iio/adc/Kconfig
Merging char-misc/char-misc-next (962b686 Merge tag 'pull_req_20121122' of =
git://git.kernel.org/pub/scm/linux/kernel/git/mzx/extcon into char-misc-nex=
t)
CONFLICT (add/add): Merge conflict in drivers/mmc/host/rtsx_pci_sdmmc.c
CONFLICT (content): Merge conflict in drivers/mmc/host/Kconfig
CONFLICT (content): Merge conflict in drivers/misc/atmel-ssc.c
CONFLICT (add/add): Merge conflict in drivers/mfd/rtsx_pcr.c
Merging tmem/linux-next (8f0d816 Linux 3.7-rc3)
Merging writeback/writeback-for-next (2f60d62 CPU hotplug, writeback: Don't=
 call writeback_set_ratelimit() too often during hotplug)
Merging arm-dt/devicetree/arm-next (ede338f dt: add documentation of ARM dt=
 boot interface)
Merging hwspinlock/linux-next (8b37fcf hwspinlock: add MAINTAINERS entries)
Merging pinctrl/for-next (e7125b5 Merge branch 'devel' into for-next)
CONFLICT (content): Merge conflict in arch/arm/boot/dts/spear1340.dtsi
CONFLICT (content): Merge conflict in arch/arm/boot/dts/at91sam9g20ek_commo=
n.dtsi
CONFLICT (content): Merge conflict in arch/arm/boot/dts/at91sam9260.dtsi
Merging vhost/linux-next (e0953c8 tun: experimental zero copy tx support)
CONFLICT (content): Merge conflict in drivers/net/tun.c
Merging memblock/memblock-kill-early_node_map (7bd0b0f memblock: Reimplemen=
t memblock allocation using reverse free area iterator)
Merging remoteproc/for-next (6f0c058 Linux 3.7-rc2)
Merging irqdomain/irqdomain/next (a0d271c Linux 3.6)
Merging gpio/gpio/next (b53bc28 gpio: SPEAr: add spi chipselect control dri=
ver)
CONFLICT (content): Merge conflict in drivers/gpio/gpio-em.c
Merging gpio-lw/for-next (12fff48 Merge branch 'devel' into for-next)
Merging arm-soc/for-next (d180b0b Merge branch 'next/fixes-non-critical' in=
to for-next)
CONFLICT (content): Merge conflict in include/linux/platform_data/mmc-omap.h
CONFLICT (content): Merge conflict in drivers/usb/host/ehci-orion.c
CONFLICT (content): Merge conflict in drivers/tty/serial/atmel_serial.c
CONFLICT (content): Merge conflict in drivers/power/Kconfig
CONFLICT (content): Merge conflict in drivers/pinctrl/pinctrl-nomadik.c
CONFLICT (content): Merge conflict in drivers/net/ethernet/cadence/at91_eth=
er.c
CONFLICT (content): Merge conflict in drivers/mtd/nand/mxc_nand.c
CONFLICT (content): Merge conflict in drivers/mfd/Makefile
CONFLICT (content): Merge conflict in drivers/leds/leds-ns2.c
CONFLICT (modify/delete): arch/arm/plat-omap/common.c deleted in arm-soc/fo=
r-next and modified in HEAD. Version HEAD of arch/arm/plat-omap/common.c le=
ft in tree.
CONFLICT (content): Merge conflict in arch/arm/mach-ux500/cpu-db8500.c
CONFLICT (content): Merge conflict in arch/arm/mach-ux500/board-mop500.c
CONFLICT (content): Merge conflict in arch/arm/mach-ux500/board-mop500-stui=
b.c
CONFLICT (content): Merge conflict in arch/arm/mach-ux500/board-mop500-audi=
o.c
CONFLICT (content): Merge conflict in arch/arm/mach-spear13xx/spear13xx.c
CONFLICT (content): Merge conflict in arch/arm/mach-spear13xx/spear1310.c
CONFLICT (content): Merge conflict in arch/arm/mach-omap2/drm.c
CONFLICT (content): Merge conflict in arch/arm/mach-nomadik/board-nhk8815.c
CONFLICT (content): Merge conflict in arch/arm/mach-davinci/devices-da8xx.c
CONFLICT (modify/delete): arch/arm/configs/stamp9g20_defconfig deleted in a=
rm-soc/for-next and modified in HEAD. Version HEAD of arch/arm/configs/stam=
p9g20_defconfig left in tree.
CONFLICT (modify/delete): arch/arm/configs/afeb9260_defconfig deleted in ar=
m-soc/for-next and modified in HEAD. Version HEAD of arch/arm/configs/afeb9=
260_defconfig left in tree.
CONFLICT (content): Merge conflict in arch/arm/boot/dts/spear13xx.dtsi
CONFLICT (content): Merge conflict in arch/arm/boot/dts/spear1340.dtsi
CONFLICT (content): Merge conflict in arch/arm/boot/dts/snowball.dts
CONFLICT (content): Merge conflict in arch/arm/boot/dts/dbx5x0.dtsi
CONFLICT (content): Merge conflict in arch/arm/boot/dts/at91sam9g45.dtsi
CONFLICT (content): Merge conflict in arch/arm/boot/dts/at91sam9263.dtsi
CONFLICT (content): Merge conflict in arch/arm/boot/dts/am33xx.dtsi
CONFLICT (content): Merge conflict in arch/arm/boot/dts/Makefile
CONFLICT (content): Merge conflict in arch/arm/Kconfig.debug
$ git rm -f arch/arm/configs/afeb9260_defconfig arch/arm/configs/stamp9g20_=
defconfig arch/arm/plat-omap/common.c
Applying: OMAP: common.c: remove init call to vram fixup
Merging bcm2835/for-next (d7f292e Merge branch 'for-3.8/defconfig' into for=
-next)
Merging cortex/for-next (77a3018 Cortex-M3: Add support for exception handl=
ing)
Merging ep93xx/ep93xx-for-next (fab1f74 Merge branch 'ep93xx-fixes' into ep=
93xx-for-next)
Merging ixp4xx/next (b94740b IXP4xx: use __iomem for MMIO)
Merging msm/for-next (a0d271c Linux 3.6)
Merging renesas/next (6cee927 Merge branches 'heads/fixes', 'heads/defconfi=
g', 'heads/boards3', 'heads/soc4' and 'heads/maintainers'; commit 'ab6f6d85=
210c4d0265cf48e9958c04e08595055a' into next)
Merging samsung/for-next (d1a8169 Merge branch 'next/cleanup-samsung-3' int=
o for-next)
CONFLICT (content): Merge conflict in arch/arm/mach-exynos/mach-exynos5-dt.c
CONFLICT (content): Merge conflict in arch/arm/boot/dts/exynos5250.dtsi
CONFLICT (content): Merge conflict in arch/arm/boot/dts/exynos5250-smdk5250=
.dts
CONFLICT (content): Merge conflict in arch/arm/boot/dts/Makefile
Merging tegra/for-next (3c8d1fc Merge branch 'for-3.8/fixes-for-rc1' into f=
or-next)
Merging kvmtool/master (6f09dab kvm tools: add support for ARMv7 processors)
Merging dma-mapping/dma-mapping-next (2b8836a Merge branch 'dma-fixes-for-v=
3.7' into HEAD)
Merging pwm/for-next (9685ac4 pwm: Export of_pwm_xlate_with_flags())
CONFLICT (modify/delete): drivers/pwm/pwm-twl6030.c deleted in pwm/for-next=
 and modified in HEAD. Version HEAD of drivers/pwm/pwm-twl6030.c left in tr=
ee.
CONFLICT (content): Merge conflict in drivers/pwm/pwm-tiehrpwm.c
CONFLICT (content): Merge conflict in drivers/pwm/pwm-tiecap.c
$ git rm -f drivers/pwm/pwm-twl6030.c
Merging dma-buf/for-next (ba42051 dma-buf: might_sleep() in dma_buf_unmap_a=
ttachment())
Merging userns/for-next (98f842e proc: Usable inode numbers for the namespa=
ce file descriptors.)
CONFLICT (content): Merge conflict in kernel/nsproxy.c
CONFLICT (content): Merge conflict in include/net/net_namespace.h
Merging ktest/for-next (95f5783 ktest: Fix ELSE IF statements)
Merging signal/for-next (541880d do_coredump(): get rid of pt_regs argument)
CONFLICT (content): Merge conflict in arch/xtensa/Kconfig
CONFLICT (content): Merge conflict in arch/powerpc/kernel/entry_64.S
CONFLICT (content): Merge conflict in arch/microblaze/include/asm/Kbuild
CONFLICT (content): Merge conflict in arch/cris/include/asm/signal.h
CONFLICT (content): Merge conflict in arch/arm/kernel/process.c
Merging clk/clk-next (1f61e5f clk: clock multiplexers may register out of o=
rder)
CONFLICT (content): Merge conflict in arch/arm/mach-ux500/cpu-db8500.c
Merging random/dev (ec8f02da random: prime last_data value per fips require=
ments)
Merging lzo-update/lzo-update (ba32bf9 lib/lzo: Do not leak implementation =
details in lzo1x_1_compress())
Merging drop-experimental/linux-next (9387123 tools/lguest: remove depends =
on CONFIG_EXPERIMENTAL)
CONFLICT (content): Merge conflict in net/dsa/Kconfig
CONFLICT (content): Merge conflict in drivers/ptp/Kconfig
CONFLICT (content): Merge conflict in drivers/net/ethernet/intel/Kconfig
Merging scsi-post-merge/merge-base:master ()
Merging vfs/for-next (a77cfcb fix off-by-one in argument passed by iterate_=
fd() to callbacks)
Merging akpm-current/current (064904e drivers/rtc/rtc-tps65910.c: fix inval=
id pointer access on _remove())
$ git checkout akpm
Applying: thp: fix update_mmu_cache_pmd() calls
Applying: CRIS: Fix I/O macros
Applying: vfs: d_obtain_alias() needs to use "/" as default name.
Applying: fs/block_dev.c: page cache wrongly left invalidated after revalid=
ate_disk()
Applying: arch/x86/platform/iris/iris.c: register a platform device and a p=
latform driver
Applying: x86 numa: don't check if node is NUMA_NO_NODE
Applying: arch/x86/tools/insn_sanity.c: identify source of messages
Applying: arch/x86/platform/uv: fix incorrect tlb flush all issue
Applying: olpc: fix olpc-xo1-sci.c build errors
Applying: x86: convert update_mmu_cache() and update_mmu_cache_pmd() to fun=
ctions
Applying: x86: fix the argument passed to sync_global_pgds()
Applying: x86: make 'mem=3D' option to work for efi platform
Applying: audit: create explicit AUDIT_SECCOMP event type
Applying: audit: catch possible NULL audit buffers
Applying: ceph: fix dentry reference leak in ceph_encode_fh()
Applying: pcmcia: move unbind/rebind into dev_pm_ops.complete
Applying: drivers/video: add support for the Solomon SSD1307 OLED Controller
Applying: drivers-video-add-support-for-the-solomon-ssd1307-oled-controller=
-checkpatch-fixes
Applying: drivers/video/console/softcursor.c: remove redundant NULL check b=
efore kfree()
Applying: irq: tsk->comm is an array
Applying: timeconst.pl: remove deprecated defined(@array)
Applying: time: don't inline EXPORT_SYMBOL functions
Applying: Coccinelle: Add api/d_find_alias.cocci.
Applying: h8300: select generic atomic64_t support
Applying: drivers/message/fusion/mptscsih.c: missing break
Applying: wait: add wait_event_lock_irq() interface
Applying: loop: limit the number of requests in the bio list
Applying: vfs: increment iversion when a file is truncated
Applying: fs: change return values from -EACCES to -EPERM
Applying: fs/block_dev.c: no need to check inode->i_bdev in bd_forget()
Applying: watchdog: trigger all-cpu backtrace when locked up and going to p=
anic
Applying: mm/page_alloc.c: remove duplicate check
Applying: writeback: remove nr_pages_dirtied arg from balance_dirty_pages_r=
atelimited_nr()
Applying: mm: show migration types in show_mem
Applying: mm, memcg: make mem_cgroup_out_of_memory() static
Applying: mm: use IS_ENABLED(CONFIG_NUMA) instead of NUMA_BUILD
Applying: mm: use IS_ENABLED(CONFIG_COMPACTION) instead of COMPACTION_BUILD
Applying: mm-use-is_enabledconfig_compaction-instead-of-compaction_build-fix
Applying: thp: clean up __collapse_huge_page_isolate
Applying: thp-clean-up-__collapse_huge_page_isolate v2
Applying: mm: introduce mm_find_pmd()
Applying: mm-introduce-mm_find_pmd-fix
Applying: thp: introduce hugepage_vma_check()
Applying: thp: cleanup: introduce mk_huge_pmd()
Applying: memory hotplug: suppress "Device memoryX does not have a release(=
) function" warning
Applying: memory-hotplug: skip HWPoisoned page when offlining pages
Applying: memory-hotplug: update mce_bad_pages when removing the memory
Applying: memory-hotplug-update-mce_bad_pages-when-removing-the-memory-fix
Applying: memory-hotplug: auto offline page_cgroup when onlining memory blo=
ck failed
Applying: memory-hotplug: fix NR_FREE_PAGES mismatch
Applying: memory-hotplug: fix NR_FREE_PAGES mismatch's fix
Applying: numa: convert static memory to dynamically allocated memory for p=
er node device
Applying: memory-hotplug: suppress "Device nodeX does not have a release() =
function" warning
Applying: memory-hotplug, mm/sparse.c: clear the memory to store struct page
Applying: memory-hotplug: allocate zone's pcp before onlining pages
Applying: mm: make zone_pcp_reset independent of MEMORY_HOTREMOVE
Applying: memory-hotplug: build zonelist if a zone is populated after onlin=
ing pages
Applying: memory_hotplug: fix possible incorrect node_states[N_NORMAL_MEMOR=
Y]
Applying: slub, hotplug: ignore unrelated node's hot-adding and hot-removing
Applying: mm/memory_hotplug.c: update start_pfn in zone and pg_data when sp=
anned_pages =3D=3D 0.
Applying: mm: add comment on storage key dirty bit semantics
Applying: mm,vmscan: only evict file pages when we have plenty
Applying: mmvmscan-only-evict-file-pages-when-we-have-plenty-fix
Applying: mm: refactor reinsert of swap_info in sys_swapoff()
Applying: mm: do not call frontswap_init() during swapoff
Applying: mm, highmem: use PKMAP_NR() to calculate an index of pkmap
Applying: mm, highmem: remove useless pool_lock
Applying: mm, highmem: remove page_address_pool list
Applying: mm-highmem-remove-page_address_pool-list-v2
Applying: mm, highmem: get virtual address of the page using PKMAP_ADDR()
Applying: mm: thp: set the accessed flag for old pages on access fault
Applying: mm: memmap_init_zone() performance improvement
Applying: Documentation/cgroups/memory.txt: s/mem_cgroup_charge/mem_cgroup_=
change_common/
Applying: mm, oom: allow exiting threads to have access to memory reserves
Applying: memcg: make it possible to use the stock for more than one page
Applying: memcg: reclaim when more than one page needed
Applying: memcg: change defines to an enum
Applying: memcg: kmem accounting basic infrastructure
Applying: mm: add a __GFP_KMEMCG flag
Applying: memcg: kmem controller infrastructure
Applying: memcg: replace __always_inline with plain inline
Applying: mm: allocate kernel pages to the right memcg
Applying: res_counter: return amount of charges after res_counter_uncharge()
Applying: memcg: kmem accounting lifecycle management
Applying: memcg: use static branches when code not in use
Applying: memcg: allow a memcg with kmem charges to be destructed
Applying: memcg: execute the whole memcg freeing in free_worker()
Applying: fork: protect architectures where THREAD_SIZE >=3D PAGE_SIZE agai=
nst fork bombs
Applying: memcg: add documentation about the kmem controller
Applying: slab/slub: struct memcg_params
Applying: slab: annotate on-slab caches nodelist locks
Applying: slab/slub: consider a memcg parameter in kmem_create_cache
Applying: memcg: allocate memory for memcg caches whenever a new memcg appe=
ars
Applying: memcg: simplify ida initialization
Applying: memcg: infrastructure to match an allocation to the right cache
Applying: memcg: skip memcg kmem allocations in specified code regions
Applying: memcg: remove test for current->mm in memcg_stop/resume_kmem_acco=
unt
Applying: sl[au]b: always get the cache from its page in kmem_cache_free()
Applying: sl[au]b: allocate objects from memcg cache
Applying: memcg: destroy memcg caches
Applying: move include of workqueue.h to top of slab.h file
Applying: memcg/sl[au]b: track all the memcg children of a kmem_cache
Applying: memcg/sl[au]b: shrink dead caches
Applying: memcg: get rid of once-per-second cache shrinking for dead memcgs
Applying: memcg: aggregate memcg cache values in slabinfo
Applying: slab: propagate tunable values
Applying: slub: slub-specific propagation changes
Applying: slub-slub-specific-propagation-changes-fix
Applying: kmem: add slab-specific documentation about the kmem controller
Applying: memcg: add comments clarifying aspects of cache attribute propaga=
tion
Applying: slub: drop mutex before deleting sysfs entry
Applying: dmapool: make DMAPOOL_DEBUG detect corruption of free marker
Applying: dmapool-make-dmapool_debug-detect-corruption-of-free-marker-fix
Applying: mm: hwpoison: fix action_result() to print out dirty/clean
Applying: mm: print out information of file affected by memory error
Applying: mm: support more pagesizes for MAP_HUGETLB/SHM_HUGETLB
Applying: mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix
Applying: mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix-fix
Applying: MM: Support more pagesizes for MAP_HUGETLB/SHM_HUGETLB v7 fix fix=
 fix
Applying: MM: Support more pagesizes for MAP_HUGETLB/SHM_HUGETLB v7 fix fix=
 fix fix
Applying: mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix-fix-=
fix-fix-checkpatch-fixes
Applying: selftests: add a test program for variable huge page sizes in mma=
p/shmget
Applying: mm: augment vma rbtree with rb_subtree_gap
Applying: mm: ensure safe rb_subtree_gap update when inserting new VMA
Applying: mm: ensure safe rb_subtree_gap update when removing VMA
Applying: mm: debug code to verify rb_subtree_gap updates are safe
Applying: mm-augment-vma-rbtree-with-rb_subtree_gap-fix
Applying: mm: check rb_subtree_gap correctness
Applying: mm-check-rb_subtree_gap-correctness-fix
Applying: mm: rearrange vm_area_struct for fewer cache misses
Applying: mm-rearrange-vm_area_struct-for-fewer-cache-misses-checkpatch-fix=
es
Applying: mm: vm_unmapped_area() lookup function
Applying: mm-vm_unmapped_area-lookup-function-checkpatch-fixes
Applying: mm: use vm_unmapped_area() on x86_64 architecture
Applying: mm: fix cache coloring on x86_64 architecture
Applying: mm: use vm_unmapped_area() in hugetlbfs
Applying: mm: use vm_unmapped_area() in hugetlbfs on i386 architecture
Applying: mm-use-vm_unmapped_area-in-hugetlbfs-on-i386-architecture-fix
Applying: mm: use vm_unmapped_area() on mips architecture
Applying: mm-use-vm_unmapped_area-on-mips-architecture-fix
Applying: mm: use vm_unmapped_area() on arm architecture
Applying: mm-use-vm_unmapped_area-on-arm-architecture-fix
Applying: mm-use-vm_unmapped_area-on-arm-architecture-fix-fix
Applying: mm: use vm_unmapped_area() on sh architecture
Applying: mm-use-vm_unmapped_area-on-sh-architecture-fix
Applying: mm-use-vm_unmapped_area-on-sh-architecture-fix2
Applying: mm: use vm_unmapped_area() on sparc32 architecture
Applying: mm-use-vm_unmapped_area-on-sparc32-architecture-fix
Applying: mm-use-vm_unmapped_area-on-sparc32-architecture-fix-fix
Applying: mm: use vm_unmapped_area() in hugetlbfs on tile architecture
Applying: mm-use-vm_unmapped_area-in-hugetlbfs-on-tile-architecture-fix
Applying: mm: use vm_unmapped_area() on sparc64 architecture
Applying: mm-use-vm_unmapped_area-on-sparc64-architecture-fix
Applying: linux-next: build warning after merge of the final tree (akpm tre=
e related)
Applying: mm: use vm_unmapped_area() in hugetlbfs on sparc64 architecture
Applying: mm-use-vm_unmapped_area-in-hugetlbfs-on-sparc64-architecture-fix
Applying: arch/sparc/kernel/sys_sparc_64.c: s/COLOUR/COLOR/
Applying: mm: adjust address_space_operations.migratepage() return code
Applying: mm: redefine address_space.assoc_mapping
Applying: mm: introduce a common interface for balloon pages mobility
Applying: mm: fix balloon_page_movable() page->flags check
Applying: mm: introduce a common interface for balloon pages mobility fix
Applying: mm: introduce compaction and migration for ballooned pages
Applying: virtio_balloon: introduce migration primitives to balloon pages
Applying: virtio: balloon: fix missing unlock on error in fill_balloon()
Applying: virtio_balloon-introduce-migration-primitives-to-balloon-pages-fi=
x-fix
Applying: virtio_balloon-introduce-migration-primitives-to-balloon-pages-fi=
x-fix-fix
Applying: mm: introduce putback_movable_pages()
Applying: mm: add vm event counters for balloon pages compaction
Applying: mm/vmscan.c: try_to_freeze() returns boolean
Applying: mm, mempolicy: remove duplicate code
Applying: mm: cleanup register_node()
Applying: mm, oom: change type of oom_score_adj to short
Applying: mm, oom: fix race when specifying a thread as the oom origin
Applying: mm: cma: skip watermarks check for already isolated blocks in spl=
it_free_page()
Applying: mm: cma: skip watermarks check for already isolated blocks in spl=
it_free_page() fix
Applying: mm-cma-skip-watermarks-check-for-already-isolated-blocks-in-split=
_free_page-fix-fix
Applying: mm: cma: remove watermark hacks
Applying: mm: cma: remove watermark hacks (fix)
Applying: bootmem: remove not implemented function call, bootmem_arch_prefe=
rred_node()
Applying: avr32, kconfig: remove HAVE_ARCH_BOOTMEM
Applying: bootmem: remove alloc_arch_preferred_bootmem()
Applying: bootmem: fix wrong call parameter for free_bootmem()
Applying: bootmem-fix-wrong-call-parameter-for-free_bootmem-fix
Applying: mm: cma: WARN if freed memory is still in use
Applying: drivers/base/node.c: cleanup node_state_attr[]
Applying: mm, memory-hotplug: dynamic configure movable memory and portion =
memory
Applying: mm-memory-hotplug-dynamic-configure-movable-memory-and-portion-me=
mory-fix
Applying: memory_hotplug: handle empty zone when online_movable/online_kern=
el
Applying: memory_hotplug: ensure every online node has NORMAL memory
Applying: thp: huge zero page: basic preparation
Applying: thp-huge-zero-page-basic-preparation-v6
Applying: thp: zap_huge_pmd(): zap huge zero pmd
Applying: thp: copy_huge_pmd(): copy huge zero page
Applying: thp-copy_huge_pmd-copy-huge-zero-page-v6
Applying: thp: copy_huge_pmd(): copy huge zero page v6 fix
Applying: thp: do_huge_pmd_wp_page(): handle huge zero page
Applying: thp-do_huge_pmd_wp_page-handle-huge-zero-page-v6
Applying: thp: change_huge_pmd(): keep huge zero page write-protected
Applying: thp: change split_huge_page_pmd() interface
Applying: thp-change-split_huge_page_pmd-interface-v6
Applying: thp: implement splitting pmd for huge zero page
Applying: thp-implement-splitting-pmd-for-huge-zero-page-fix
Applying: thp-implement-splitting-pmd-for-huge-zero-page-v6
Applying: thp: setup huge zero page on non-write page fault
Applying: thp-setup-huge-zero-page-on-non-write-page-fault-fix
Applying: thp: lazy huge zero page allocation
Applying: thp: implement refcounting for huge zero page
Applying: thp, vmstat: implement HZP_ALLOC and HZP_ALLOC_FAILED events
Applying: thp, vmstat: implement HZP_ALLOC and HZP_ALLOC_FAILED events
Applying: thp: introduce sysfs knob to disable huge zero page
Applying: mm: compaction: Fix compiler warning
Applying: mm: use migrate_prep() instead of migrate_prep_local()
Applying: mm: node_states: introduce N_MEMORY
Applying: cpuset: use N_MEMORY instead N_HIGH_MEMORY
Applying: procfs: use N_MEMORY instead N_HIGH_MEMORY
Applying: memcontrol: use N_MEMORY instead N_HIGH_MEMORY
Applying: oom: use N_MEMORY instead N_HIGH_MEMORY
Applying: mm,migrate: use N_MEMORY instead N_HIGH_MEMORY
Applying: mempolicy: use N_MEMORY instead N_HIGH_MEMORY
Applying: hugetlb: use N_MEMORY instead N_HIGH_MEMORY
Applying: vmstat: use N_MEMORY instead N_HIGH_MEMORY
Applying: kthread: use N_MEMORY instead N_HIGH_MEMORY
Applying: init: use N_MEMORY instead N_HIGH_MEMORY
Applying: vmscan: use N_MEMORY instead N_HIGH_MEMORY
Applying: page_alloc: use N_MEMORY instead N_HIGH_MEMORY change the node_st=
ates initialization
Applying: hotplug: update nodemasks management
Applying: res_counter: delete res_counter_write()
Applying: mm: WARN_ON_ONCE if f_op->mmap() change vma's start address
Applying: mm: add a reminder comment for __GFP_BITS_SHIFT
Applying: mm, memcg: avoid unnecessary function call when memcg is disabled
Applying: numa: add CONFIG_MOVABLE_NODE for movable-dedicated node
Applying: numa-add-config_movable_node-for-movable-dedicated-node-fix
Applying: memory_hotplug: allow online/offline memory to result movable node
Applying: mm, oom: cleanup pagefault oom handler
Applying: mm, oom: remove redundant sleep in pagefault oom handler
Applying: mm, oom: remove statically defined arch functions of same name
Applying: mm: introduce new field "managed_pages" to struct zone
Applying: mm-introduce-new-field-managed_pages-to-struct-zone-fix
Applying: mm: trace filemap add and del
Applying: writeback: fix a typo in comment
Applying: fs/buffer.c: do not inline exported function
Applying: fs/buffer.c: remove redundant initialization in alloc_page_buffer=
s()
Applying: mm: provide more accurate estimation of pages occupied by memmap
Applying: mm-provide-more-accurate-estimation-of-pages-occupied-by-memmap-f=
ix
Applying: drop_caches: add some documentation and info message
Applying: drop_caches-add-some-documentation-and-info-messsge-checkpatch-fi=
xes
Applying: swap: add a simple detector for inappropriate swapin readahead
Applying: swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix
Applying: mm/memblock: reduce overhead in binary search
Applying: drivers/usb/gadget/amd5536udc.c: avoid calling dma_pool_create() =
with NULL dev
Applying: mm/dmapool.c: fix null dev in dma_pool_create()
Applying: scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes
Applying: Documentation/kernel-parameters.txt: update mem=3D option's spec =
according to its implementation
Applying: include/linux/init.h: use the stringify operator for the __define=
_initcall macro
Applying: scripts/tags.sh: add magic for declarations of popular kernel type
Applying: Documentation: remove reference to feature-removal-schedule.txt
Applying: kernel: remove reference to feature-removal-schedule.txt
Applying: sound: remove reference to feature-removal-schedule.txt
Applying: drivers: remove reference to feature-removal-schedule.txt
Applying: Kconfig: centralise CONFIG_ARCH_NO_VIRT_TO_BUS
Applying: printk: boot_delay should only affect output
Applying: MAINTAINERS: CHINESE MAINTAINERS mailing list is subscribers only
Applying: MAINTAINERS: remove include/linux/ext3*
Applying: backlight: da903x_bl: use dev_get_drvdata() instead of platform_g=
et_drvdata()
Applying: backlight: 88pm860x_bl: fix checkpatch warning
Applying: backlight: atmel-pwm-bl: fix checkpatch warning
Applying: backlight: corgi_lcd: fix checkpatch error and warning
Applying: backlight: da903x_bl: fix checkpatch warning
Applying: backlight: generic_bl: fix checkpatch warning
Applying: backlight: hp680_bl: fix checkpatch error and warning
Applying: backlight: ili9320: fix checkpatch error and warning
Applying: backlight: jornada720: fix checkpatch error and warning
Applying: backlight: l4f00242t03: fix checkpatch warning
Applying: backlight: lm3630: fix checkpatch warning
Applying: backlight: locomolcd: fix checkpatch error and warning
Applying: backlight: omap1: fix checkpatch warning
Applying: backlight: pcf50633: fix checkpatch warning
Applying: backlight: platform_lcd: fix checkpatch error
Applying: backlight: tdo24m: fix checkpatch warning
Applying: backlight: tosa: fix checkpatch error and warning
Applying: backlight: vgg2432a4: fix checkpatch warning
Applying: backlight: lms283gf05: use devm_gpio_request_one
Applying: backlight: tosa: use devm_gpio_request_one
Applying: drivers/video/backlight/lp855x_bl.c: use generic PWM functions
Applying: drivers-video-backlight-lp855x_blc-use-generic-pwm-functions-fix
Applying: drivers/video/backlight/lp855x_bl.c: remove unnecessary mutex code
Applying: drivers/video/backlight/da9052_bl.c: add missing const
Applying: drivers/video/backlight/lms283gf05.c: add missing const
Applying: drivers/video/backlight/tdo24m.c: add missing const
Applying: drivers/video/backlight/vgg2432a4.c: add missing const
Applying: drivers/video/backlight/s6e63m0.c: remove unnecessary cast of voi=
d pointer
Applying: drivers/video/backlight/88pm860x_bl.c: drop devm_kfree of devm_kz=
alloc'd data
Applying: drivers/video/backlight/max8925_bl.c: drop devm_kfree of devm_kza=
lloc'd data
Applying: drivers/video/backlight/lm3639_bl.c: fix up world writable sysfs =
file
Applying: drivers/video/backlight/ep93xx_bl.c: fix section mismatch
Applying: drivers/video/backlight/hp680_bl.c: add missing __devexit macros =
for remove
Applying: drivers/video/backlight/ili9320.c: add missing __devexit macros f=
or remove
Applying: backlight: add of_find_backlight_by_node()
Applying: backlight-add-of_find_backlight_by_node-function-fix
Applying: backlight-add-of_find_backlight_by_node-function-fix-2
Applying: drivers/video/backlight/pandora_bl.c: change TWL4030_MODULE_PWM0 =
to TWL_MODULE_PWM
Applying: backlight: 88pm860x_bl: remove an unnecessary line continuation
Applying: backlight-88pm860x_bl-remove-an-unnecessary-line-continuation-fix
Applying: drivers/video/backlight/lcd.c: return ENXIO when ops functions ca=
nnot be called
Applying: drivers/video/backlight/lms283gf05.c: use GPIOF_INIT flags when u=
sing devm_gpio_request_one()
Applying: string: introduce helper to get base file name from given path
Applying: lib: dynamic_debug: use kbasename()
Applying: mm: use kbasename()
Applying: procfs: use kbasename()
Applying: proc_devtree: remove duplicated include from proc_devtree.c
Applying: trace: use kbasename()
Applying: drivers/of/fdt.c: re-use kernel's kbasename()
Applying: sscanf: don't ignore field widths for numeric conversions
Applying: percpu_rw_semaphore: reimplement to not block the readers unneces=
sarily
CONFLICT (content): Merge conflict in include/linux/percpu-rwsem.h
Applying: percpu_rw_semaphore-reimplement-to-not-block-the-readers-unnecess=
ari-lyfix
Applying: percpu_rw_semaphore: kill ->writer_mutex, add ->write_ctr
Applying: percpu_rw_semaphore: add lockdep annotations
Applying: percpu_rw_semaphore: introduce CONFIG_PERCPU_RWSEM
Applying: compat: generic compat_sys_sched_rr_get_interval() implementation
Applying: drivers/firmware/dmi_scan.c: check dmi version when get system uu=
id
Applying: drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid=
-fix
Applying: drivers/firmware/dmi_scan.c: fetch dmi version from SMBIOS if it =
exists
Applying: drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-ex=
ists-checkpatch-fixes
Applying: checkpatch: warn on unnecessary line continuations
Applying: checkpatch: warn about using CONFIG_EXPERIMENTAL
Applying: checkpatch: remove reference to feature-removal-schedule.txt
Applying: checkpatch: consolidate if (foo) bar(foo) checks and add debugfs_=
remove
Applying: checkpatch: allow control over line length warning, default remai=
ns 80
Applying: checkpatch: extend line continuation test
Applying: checkpatch: Add --strict messages for blank lines around braces
Applying: epoll: support for disabling items, and a self-test app
Applying: binfmt_elf: fix corner case kfree of uninitialized data
Applying: binfmt_elf-fix-corner-case-kfree-of-uninitialized-data-checkpatch=
-fixes
Applying: binfmt_elf.c: use get_random_int() to fix entropy depleting
Applying: rtc: omap: kicker mechanism support
Applying: ARM: davinci: remove rtc kicker release
Applying: rtc: omap: dt support
Applying: rtc: omap: depend on am33xx
Applying: rtc: omap: add runtime pm support
Applying: drivers/rtc/rtc-imxdi: support for i.MX53
Applying: drivers/rtc/rtc-imxdi.c: add devicetree support
Applying: drivers/rtc/rtc-vt8500.c: convert to use devm_kzalloc
Applying: drivers/rtc/rtc-test.c: avoid calling platform_device_put() twice
Applying: rtc-avoid-calling-platform_device_put-twice-in-test_init-fix
Applying: rtc: rtc-spear: use devm_*() routines
Applying: rtc-rtc-spear-use-devm_-routines-fix
Applying: rtc: rtc-spear: Add clk_{un}prepare() support
Applying: rtc: rtc-spear: Provide flag for no support of UIE mode
Applying: drivers/rtc/rtc-tps65910.c: rename irq to match device
Applying: rtc: rtc-davinci: return correct error code if rtc_device_registe=
r() fails
Applying: rtc: rtc-davinci: use devm_kzalloc()
Applying: rtc: add NXP PCF8523 support
Applying: rtc-add-nxp-pcf8523-support-v2
Applying: drivers/rtc/rtc-s3c.c: remove unnecessary err_nores label
Applying: drivers/rtc/rtc-s3c.c: convert to use devm_* API
Applying: drivers/rtc/rtc-dev.c: remove unused code from rtc-dev.c
Applying: hfsplus: avoid crash on failed block map free
Applying: hfsplus: add osx.* prefix for handling namespace of Mac OS X exte=
nded attributes
Applying: hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extende=
d-attributes-checkpatch-fixes
Applying: hfsplus: add on-disk layout declarations related to attributes tr=
ee
Applying: hfsplus: add functionality of manipulating by records in attribut=
es tree
Applying: hfsplus: rework functionality of getting, setting and deleting of=
 extended attributes
Applying: hfsplus-rework-functionality-of-getting-setting-and-deleting-of-e=
xtended-attributes-fix
Applying: hfsplus: add support of manipulation by attributes file
Applying: hfsplus: rework processing errors in hfsplus_free_extents()
Applying: fat: notify when discard is not supported
Applying: fat: provide option for setting timezone offset
Applying: fat: ix mount option parsing
Applying: fs/fat: strip "cp" prefix from codepage in display
Applying: Documentation/DMA-API-HOWTO.txt: minor grammar corrections
Applying: Documentation: fix Documentation/security/00-INDEX
Applying: kstrto*: add documentation
Applying: simple_strto*: annotate function as obsolete
Applying: ptrace: introduce PTRACE_O_EXITKILL
Applying: proc: don't show nonexistent capabilities
Applying: procfs: add VmFlags field in smaps output
Applying: procfs-add-vmflags-field-in-smaps-output-v4-fix
Applying: /proc/pid/status: add "Seccomp" field
Applying: proc: pid/status: show all supplementary groups
Applying: fork: unshare: remove dead code
Applying: exec: do not leave bprm->interp on stack
Applying: exec: use -ELOOP for max recursion depth
Applying: ipc: remove forced assignment of selected message
Applying: ipc: add sysctl to specify desired next object id
Applying: ipc-add-sysctl-to-specify-desired-next-object-id-checkpatch-fixes
Applying: ipc: wrap new sysctls for CRIU inside CONFIG_CHECKPOINT_RESTORE
Applying: Documentation: update sysctl/kernel.txt
Applying: ipc: message queue receive cleanup
Applying: ipc-message-queue-receive-cleanup-checkpatch-fixes
Applying: ipc: introduce message queue copy feature
Applying: ipc: remove redundant MSG_COPY check
Applying: ipc: cleanup do_msgrcv() around MSG_COPY feature
Applying: selftests: IPC message queue copy feature test
Applying: test: IPC message queue copy feature test update
Applying: ipc: simplify free_copy() call
Applying: ipc: convert prepare_copy() from macro to function
Applying: ipc-convert-prepare_copy-from-macro-to-function-fix
Applying: ipc: simplify message copying
Applying: ipc: add more comments to message copying related code
Applying: Documentation/sysctl/kernel.txt: document /proc/sys/shmall
Applying: ipc/sem.c: alternatives to preempt_disable()
Applying: pidns: remove unused is_container_init()
Applying: linux/compiler.h: add __must_hold macro for functions called with=
 a lock held
Applying: Documentation/sparse.txt: document context annotations for lock c=
hecking
Applying: aoe: describe the behavior of the "err" character device
Applying: aoe: print warning regarding a common reason for dropped transmits
Applying: aoe-print-warning-regarding-a-common-reason-for-dropped-transmits=
-v2
Applying: aoe: avoid using skb member after dev_queue_xmit
Applying: aoe: update cap on outstanding commands based on config query res=
ponse
Applying: aoe: support the forgetting (flushing) of a user-specified AoE ta=
rget
Applying: aoe: support larger I/O requests via aoe_maxsectors module param
Applying: aoe: "payload" sysfs file exports per-AoE-command data transfer s=
ize
Applying: aoe: cleanup: remove unused ata_scnt function
Applying: aoe: whitespace cleanup
Applying: aoe: update driver-internal version number to 60
Applying: aoe: provide ATA identify device content to user on request
Applying: aoe: improve network congestion handling
Applying: aoe: err device: include MAC addresses for unexpected responses
Applying: aoe: manipulate aoedev network stats under lock
Applying: aoe: use high-resolution RTTs with fallback to low-res
Applying: aoe: commands in retransmit queue use new destination on failure
Applying: aoe: update driver-internal version to 64+
Applying: aoe: copy fallback timing information on destination failover
Applying: aoe: remove vestigial request queue allocation
Applying: aoe: increase default cap on outstanding AoE commands in the netw=
ork
Applying: aoe: cleanup: correct comment for aoetgt nout
Applying: aoe: remove call to request handler from I/O completion
Applying: aoe: make error messages more specific in static minor allocation
Applying: aoe: initialize sysminor to avoid compiler warning
Applying: aoe: return real minor number for static minors
Applying: random32: rename random32 to prandom
Applying: prandom: introduce prandom_bytes() and prandom_bytes_state()
Applying: bnx2x: use prandom_bytes()
Applying: mtd: nandsim: use prandom_bytes
Applying: ubifs: use prandom_bytes
Applying: mtd: mtd_nandecctest: use prandom_bytes instead of get_random_byt=
es()
Applying: mtd: mtd_oobtest: convert to use prandom library
Applying: mtd: mtd_pagetest: convert to use prandom library
Applying: mtd: mtd_speedtest: use prandom_bytes
Applying: mtd: mtd_subpagetest: convert to use prandom library
Applying: mtd: mtd_stresstest: use prandom_bytes()
Applying: Documentation/DMA-API-HOWTO.txt: fix typo
Applying: vm selftests: print failure status instead of cause make error
Applying: mqueue selftests: print failure status instead of cause make error
Applying: cpu-hotplug selftests: print failure status instead of cause make=
 error
Applying: mem-hotplug selftests: print failure status instead of cause make=
 error
Applying: kcmp selftests: make run_tests fix
Applying: kcmp selftests: print fail status instead of cause make error
Applying: breakpoint selftests: print failure status instead of cause make =
error
Applying: tools/testing/selftests/kcmp/kcmp_test.c: print reason for failur=
e in kcmp_test
Applying: procfs: add ability to plug in auxiliary fdinfo providers
Applying: fs, eventfd: add procfs fdinfo helper
Applying: fs, epoll: add procfs fdinfo helper
Applying: fs, epoll: drop enabled field from fdinfo output
Applying: fdinfo: show sigmask for signalfd fd
Applying: fs, exportfs: escape nil dereference if no s_export_op present
Applying: fs, exportfs: add exportfs_encode_inode_fh() helper
Applying: fs, notify: add procfs fdinfo helper
Applying: fs, notify: Move bare fdinfo helpers to a header
Applying: fs, notify: add missing space after prefix
Applying: fs, notify: don't forget to provide fhandle for inode fanotify
Applying: docs: add documentation about /proc/<pid>/fdinfo/<fd> output
Applying: docs-add-documentation-about-proc-pid-fdinfo-fd-output-fix
Applying: fs-notify-add-procfs-fdinfo-helper-v7-fix
Applying: scatterlist: don't BUG when we can trivially return a proper erro=
r.
Applying: scatterlist-dont-bug-when-we-can-trivially-return-a-proper-error-=
fix
Merging akpm/master (cfb65da scatterlist-dont-bug-when-we-can-trivially-ret=
urn-a-proper-error-fix)

--Signature=_Fri__30_Nov_2012_17_58_01_+1100_++03mAPaLCS9LgOf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQuFj6AAoJEECxmPOUX5FEum0P/AgzkJrNhWyg7yDAjJKMkvwA
QFLWMLDoXgrQ/+BfL0CWLUqXKgAWQvQzIHpUxopGaPUxm4XrZ2ziMb+IYb13D8wu
qNzez95RP5l5fUkgzrYlrjEZ1Wegm20yP0zWat4U4QSQdqSy+jY1j926h0pzuouU
OK8OmJ15gGodFTdE9ikEH3yBiOj0J4KWnkigg/HgPnsOZPfuqEjPKzFFj/Ku5xwM
Kygbrtn4fiy/m7KGfmKSldidMHK8NE2c0g1vWxrS2bmUgqBpXM6EIvsNHsZpD999
cIzJAqpkvtDNYzS62euJM1zIE9SRQt9pQFPpJD+96eehh+3JDx2KhFQcZhf0g6/o
XG2k0+jdYKMOcAirA1MlLueeDzG1OEBnaFL/oBKx/xdS1ltOAnsknA8cLliNtJKf
G5HDmkdh9KwpVd5laatXlRkO2qaVSCQM1vpGCw500PLXDZqxcb54WudTeGlskmTf
xPkebEGJdyvlIWDhHbDCWq8b4NbMdBx5778c5M9JZiAFlonlE0a3jSwXpi7t4k0M
Oikuevl0AkPqkM+YThraUM+CTXVYKmmVgCiEiGxhw8GEMbu8NBineuoQaGUIUNqE
2gzYHsQ0L84JuSAJOWnLaBWQfZVEXu3GkJuP0gQgIeGgSg0eihPJQMgmc7lyGUmj
gv2udQCl0d/sMvIok6lG
=bug3
-----END PGP SIGNATURE-----

--Signature=_Fri__30_Nov_2012_17_58_01_+1100_++03mAPaLCS9LgOf--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167Ab3ACDhy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 22:37:54 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:41931 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037Ab3ACDht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 22:37:49 -0500
Date: Thu, 3 Jan 2013 14:37:41 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <linux-next@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Jan 3
Message-Id: <20130103143741.8027cf717514309b98c5d35f@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__3_Jan_2013_14_37_41_+1100__dPNL+Ser0fi=IZa"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__3_Jan_2013_14_37_41_+1100__dPNL+Ser0fi=IZa
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20130102:

The net-next tree gained a build failure for which I applied a patch.

The kvm tree gained a conflict against the s390 tree.

The pinctrl tree gained a conflict against the driver-core.current tree.

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

We are up to 213 trees (counting Linus' and 28 trees of patches pending
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
Merging origin/master (5439ca6 Merge tag 'ext4_for_linus' of git://git.kern=
el.org/pub/scm/linux/kernel/git/tytso/ext4)
Merging fixes/master (3b095f2 disable the SB105X driver)
Merging kbuild-current/rc-fixes (bad9955 menuconfig: Replace CIRCLEQ by lis=
t_head-style lists.)
Merging arm-current/fixes (5ced33b ARM: 7611/1: VIC: fix bug in VIC irqdoma=
in code)
Merging m68k-current/for-linus (e7e29b4 m68k: Wire up finit_module)
Merging powerpc-merge/merge (e716e01 powerpc/eeh: Do not invalidate PE prop=
erly)
Merging sparc/master (4e4d78f sparc: Hook up finit_module syscall.)
Merging net/master (612a7c4 forcedeth: Fix WARNINGS that result when DMA ma=
pping is not checked)
Merging sound-current/for-linus (a49f0d1 Linux 3.8-rc1)
Merging pci-current/for-linus (812089e PCI: Reduce Ricoh 0xe822 SD card rea=
der base clock frequency to 50MHz)
Merging wireless/master (619c5a9 brcmfmac: fix parsing rsn ie for ap mode.)
Merging driver-core.current/driver-core-linus (76da5cf Drivers: i2c: fix i2=
c-au1550.c build error)
CONFLICT (content): Merge conflict in drivers/i2c/muxes/i2c-mux-gpio.c
CONFLICT (content): Merge conflict in drivers/i2c/busses/scx200_acb.c
CONFLICT (content): Merge conflict in drivers/i2c/busses/i2c-xiic.c
CONFLICT (content): Merge conflict in drivers/i2c/busses/i2c-viapro.c
CONFLICT (content): Merge conflict in drivers/i2c/busses/i2c-sis96x.c
CONFLICT (content): Merge conflict in drivers/i2c/busses/i2c-pxa-pci.c
CONFLICT (content): Merge conflict in drivers/i2c/busses/i2c-powermac.c
CONFLICT (content): Merge conflict in drivers/i2c/busses/i2c-piix4.c
CONFLICT (content): Merge conflict in drivers/i2c/busses/i2c-pasemi.c
CONFLICT (content): Merge conflict in drivers/i2c/busses/i2c-omap.c
CONFLICT (content): Merge conflict in drivers/i2c/busses/i2c-nforce2.c
CONFLICT (content): Merge conflict in drivers/i2c/busses/i2c-mv64xxx.c
CONFLICT (content): Merge conflict in drivers/i2c/busses/i2c-mpc.c
CONFLICT (content): Merge conflict in drivers/i2c/busses/i2c-intel-mid.c
CONFLICT (content): Merge conflict in drivers/i2c/busses/i2c-ibm_iic.c
CONFLICT (content): Merge conflict in drivers/i2c/busses/i2c-i801.c
CONFLICT (content): Merge conflict in drivers/i2c/busses/i2c-hydra.c
CONFLICT (content): Merge conflict in drivers/i2c/busses/i2c-eg20t.c
CONFLICT (content): Merge conflict in drivers/i2c/busses/i2c-designware-pci=
drv.c
CONFLICT (content): Merge conflict in drivers/i2c/busses/i2c-au1550.c
CONFLICT (content): Merge conflict in drivers/i2c/busses/i2c-ali1563.c
Merging tty.current/tty-linus (a49f0d1 Linux 3.8-rc1)
Merging usb.current/usb-linus (a49f0d1 Linux 3.8-rc1)
Merging staging.current/staging-linus (a49f0d1 Linux 3.8-rc1)
Merging char-misc.current/char-misc-linus (a49f0d1 Linux 3.8-rc1)
Merging input-current/for-linus (e324ce6 Input: gpio_keys - defer probing i=
f GPIO probing is deferred)
Merging md-current/for-linus (a9add5d md/raid5: add blktrace calls)
Merging audit-current/for-linus (c158a35 audit: no leading space in audit_l=
og_d_path prefix)
Merging crypto-current/master (a2c0911 crypto: caam - Updated SEC-4.0 devic=
e tree binding for ERA information.)
Merging ide/master (9974e43 ide: fix generic_ide_suspend/resume Oops)
Merging dwmw2/master (084a0ec x86: add CONFIG_X86_MOVBE option)
CONFLICT (content): Merge conflict in arch/x86/Kconfig
Merging sh-current/sh-fixes-for-linus (4403310 SH: Convert out[bwl] macros =
to inline functions)
Merging irqdomain-current/irqdomain/merge (a0d271c Linux 3.6)
Merging devicetree-current/devicetree/merge (ab28698 of: define struct devi=
ce in of_platform.h if !OF_DEVICE and !OF_ADDRESS)
Merging spi-current/spi/merge (d3601e5 spi/sh-hspi: fix return value check =
in hspi_probe().)
Merging gpio-current/gpio/merge (bc1008c gpio/mvebu-gpio: Make mvebu-gpio d=
epend on OF_CONFIG)
Merging rr-fixes/fixes (f4953fe virtio-blk: Don't free ida when disk is in =
use)
Merging asm-generic/master (fb9de7e xtensa: Use generic asm/mmu.h for nommu)
Merging arm/for-next (5ced33b ARM: 7611/1: VIC: fix bug in VIC irqdomain co=
de)
Merging arm-perf/for-next/perf (3d70f8c Linux 3.7-rc4)
Merging davinci/davinci-next (fe0d422 Linux 3.0-rc6)
Merging xilinx/arm-next (a3607ea serial: xilinx_uartps: fix return value ch=
eck in xuartps_probe())
Merging arm64/upstream (db2789b arm64: Keep the ARM64 Kconfig selects sorte=
d)
Merging blackfin/for-linus (86794b4 blackfin: SEC: clean up SEC interrupt i=
nitialization)
Merging c6x/for-linux-next (93bbd0c c6x: use generic kvm_para.h)
Merging cris/for-next (77c8006 UAPI: Fix up empty files in arch/cris/)
Merging hexagon/linux-next (e1858b2 Hexagon: Copyright marking changes)
Merging ia64/next (7843ae0 Merge branch 'pstore_mevent' into next)
Merging m68k/for-next (e7e29b4 m68k: Wire up finit_module)
Merging m68knommu/for-next (280ef31 m68knommu: modify clock code so it can =
be used by all ColdFire CPU types)
Merging microblaze/next (6659c3a microblaze: Update microblaze defconfigs)
Merging mips/mips-for-linux-next (664fb16 Merge branch 'current/for-linus' =
into mips-for-linux-next)
Merging openrisc/for-upstream (634bd40 openrisc: use kbuild.h instead of de=
fining macros in asm-offset.c)
Merging parisc/for-next (949a05d [PARISC] fix virtual aliasing issue in get=
_shared_area())
Merging powerpc/next (376bddd Merge remote-tracking branch 'agust/next' int=
o next)
Merging 4xx/next (2074b1d powerpc: Fix irq distribution)
Merging mpc5xxx/next (a49f0d1 Linux 3.8-rc1)
Merging galak/next (1723d90 powerpc/dma/raidengine: add raidengine device)
Merging s390/features (4c51fa36 s390/irq: count cpu restart events)
CONFLICT (content): Merge conflict in arch/s390/kernel/smp.c
Merging sh/sh-latest (0dd4d5c sh: Fix up more fallout from pointless ARM __=
iomem churn.)
Merging sparc-next/master (c4271c6 NFS: Kill fscache warnings when mounting=
 without -ofsc)
Merging tile/master (548a172 arch/tile: Enable HAVE_ARCH_TRACEHOOK)
Merging unicore32/unicore32 (c284464 arch/unicore32: remove CONFIG_EXPERIME=
NTAL)
Merging xtensa/for_next (055d4db xtensa: don't try to build DTB when OF is =
disabled)
Merging btrfs/next (fb8ec37 Merge branch 'master' of git://git.kernel.org/p=
ub/scm/linux/kernel/git/torvalds/linux into linus-merge)
Merging ceph/master (0fa6ebc libceph: fix protocol feature mismatch failure=
 path)
Merging cifs/for-next (63b7d3a CIFS: Don't let read only caching for mandat=
ory byte-range locked files)
Merging configfs/linux-next (b930c26 Merge branch 'for-linus' of git://git.=
kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (3702875 fs/ecryptfs/crypto.c: make ecryptfs_encode_f=
or_filename() static)
Merging ext3/for_next (56df127 quota: Use the pre-processor to compile out =
quotactl_cmd_write when !CONFIG_BLOCK)
Merging ext4/dev (0e9a9a1 ext4: avoid hang when mounting non-journal filesy=
stems with orphan list)
Merging f2fs/dev (09f20c0 f2fs: remove unneeded INIT_LIST_HEAD at few place=
s)
Merging fuse/for-next (23ab0c7 cuse: do not register multiple devices with =
identical names)
Merging gfs2/master (e525d6d GFS2: Reset rd_last_alloc when it reaches the =
end of the rgrp)
Merging jfs/jfs-next (4e7a4b0 jfs: Fix FITRIM argument handling)
Merging logfs/master (3394661 Fix the call to BUG() caused by no free segme=
nt found)
Merging nfs/linux-next (5439ca6 Merge tag 'ext4_for_linus' of git://git.ker=
nel.org/pub/scm/linux/kernel/git/tytso/ext4)
Merging nfsd/nfsd-next (24ffb93 nfsd4: don't leave freed stateid hashed)
Merging ocfs2/linux-next (4538df6 ocfs2: Don't spam on -EDQUOT.)
Merging omfs/for-next (976d167 Linux 3.1-rc9)
Merging squashfs/master (4b0180a Squashfs: add mount time sanity check for =
block_size and block_log match)
Merging v9fs/for-next (3d59eeb Merge tag 'balancenuma-v11' of git://git.ker=
nel.org/pub/scm/linux/kernel/git/mel/linux-balancenuma)
Merging ubifs/linux-next (a28ad42 UBIFS: fix mounting problems after power =
cuts)
Merging xfs/for-next (ec47eb6 xfs remove the XFS_TRANS_DEBUG routines)
Merging vfs/for-next (b729d75 vfs: make lremovexattr retry once on ESTALE e=
rror)
Merging pci/next (1cb73f8 Merge branch 'pci/mjg-pci-roms-from-efi' into nex=
t)
Merging hid/for-next (01c4f7e Merge branch 'for-3.8/i2c-hid' into for-next)
Merging i2c-embedded/i2c-embedded/for-next (0b255e9 i2c: remove __dev* attr=
ibutes from subsystem)
Merging jdelvare-hwmon/master (54e37b8 Merge tag 'vfio-for-v3.8-v2' of git:=
//github.com/awilliam/linux-vfio)
Merging hwmon-staging/hwmon-next (4670d57 hwmon: (vexpress) Fix build error=
 seen if CONFIG_OF_DEVICE is not set)
Merging v4l-dvb/master (76b8479 Merge /home/v4l/v4l/patchwork)
CONFLICT (content): Merge conflict in drivers/media/pci/dm1105/dm1105.c
Merging kbuild/for-next (f853c4a Merge branch 'kbuild/kconfig' into kbuild/=
for-next)
Merging kconfig/for-next (4eae518 localmodconfig: Fix localyesconfig to set=
 to 'y' not 'm')
Merging libata/NEXT (72d5f2d sata_dwc_460ex: remove file exec bit (chmod 07=
55 -> 0644))
Merging infiniband/for-next (d72623b Merge branches 'cxgb4', 'ipoib' and 'm=
lx4' into for-next)
Merging pstore/master (ebacfd1 pstore/ftrace: Adjust for ftrace_ops->func p=
rototype change)
Merging acpi/next (61dc7fc tools/power turbostat: fix build error due to ua=
pi changes)
Merging cpuidle/cpuidle-next (3cf7997 acpi: intel_idle : break dependency b=
etween modules)
CONFLICT (content): Merge conflict in drivers/cpuidle/cpuidle.c
CONFLICT (add/add): Merge conflict in drivers/cpuidle/coupled.c
CONFLICT (content): Merge conflict in drivers/cpuidle/Makefile
CONFLICT (content): Merge conflict in drivers/cpuidle/Kconfig
CONFLICT (content): Merge conflict in drivers/acpi/processor_driver.c
Applying: cpuidle: fix mismerge
Merging cpupowerutils/master (f166033 cpupower tools: add install target to=
 the debug tools' makefiles)
Merging thermal/next (d12250e thermal: rcar: add rcar_zone_to_priv() macro)
Merging ieee1394/for-next (db2cad2 firewire: net: remove unused variable in=
 fwnet_receive_broadcast())
Merging ubi/linux-next (eab7377 UBI: embed ubi_debug_info field in ubi_devi=
ce struct)
Merging dlm/next (da8c666 dlm: fix lvb invalidation conditions)
Merging swiotlb/linux-next (af51a9f swiotlb: Do not export swiotlb_bounce s=
ince there are no external consumers)
Merging scsi/for-next (e3ff197 [SCSI] mpt3sas: remove unused variables)
Merging target-updates/for-next (79e62fc target/iscsi_target: Add NodeACL t=
ags for initiator group support)
Merging target-merge/for-next-merge (6f0c058 Linux 3.7-rc2)
Merging ibft/linux-next (935a9fe ibft: Fix finding IBFT ACPI table on UEFI)
Merging isci/all (6734092 isci: add a couple __iomem annotations)
Merging slave-dma/next (3226658 Merge git://git.kernel.org/pub/scm/linux/ke=
rnel/git/djbw/dmaengine.git/next)
CONFLICT (content): Merge conflict in drivers/dma/mv_xor.c
CONFLICT (content): Merge conflict in drivers/dma/ioat/dma_v3.c
CONFLICT (content): Merge conflict in drivers/dma/dw_dmac.c
CONFLICT (content): Merge conflict in drivers/dma/dmatest.c
CONFLICT (content): Merge conflict in arch/arm/mach-spear13xx/spear13xx.c
CONFLICT (content): Merge conflict in arch/arm/mach-spear13xx/spear1310.c
CONFLICT (content): Merge conflict in arch/arm/boot/dts/spear1340.dtsi
Merging dmaengine/next (7f34986 dma: ipu: Drop unused spinlock)
Merging net-next/master (dc8ba10 qlcnic: update driver version)
Merging wireless-next/master (a49f0d1 Linux 3.8-rc1)
Merging bluetooth/master (c668d4c Bluetooth: mgmt: Avoid using magic number=
 in status code)
Merging mtd/master (5a40b5f mtd: bcm47xxnflash: increase NFLASH_READY_RETRI=
ES)
Merging l2-mtd/master (d4d4f1b mtd: nand: typo in nand_id_has_period() comm=
ents)
Merging crypto/master (a2c0911 crypto: caam - Updated SEC-4.0 device tree b=
inding for ERA information.)
Merging drm/drm-next (d5757db Revert "drm: tegra: protect DC register acces=
s with mutex")
Merging sound/for-next (e4cc615 ALSA: usb-audio: support delay calculation =
on capture streams)
Merging sound-asoc/for-next (73edbd8 Merge remote-tracking branch 'asoc/fix=
/arizona' into asoc-next)
Merging modules/modules-next (4a490b7 Merge branch 'drm-next' of git://peop=
le.freedesktop.org/~airlied/linux)
Merging virtio/virtio-next (4a490b7 Merge branch 'drm-next' of git://people=
.freedesktop.org/~airlied/linux)
Merging input/next (03c86ee Input: adxl34x - default platform_data should n=
ot use defines from driver)
Merging input-mt/for-next (6f0c058 Linux 3.7-rc2)
Merging cgroup/for-next (a0a4bdd cgroup: remove unused dummy cgroup_fork_ca=
llbacks())
Merging block/for-next (b6c46cf Merge branch 'stable/for-jens-3.8' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/konrad/xen into for-linus)
Merging device-mapper/master (a49f0d1 Linux 3.8-rc1)
Merging embedded/master (4744b43 embedded: fix vc_translate operator preced=
ence)
Merging firmware/master (6e03a20 firmware: speed up request_firmware(), v3)
Merging pcmcia/master (80af9e6 pcmcia at91_cf: fix raw gpio number usage)
Merging mmc/mmc-next (6be35c7 Merge git://git.kernel.org/pub/scm/linux/kern=
el/git/davem/net-next)
Merging kgdb/kgdb-next (58bcdf6 tty/console: fix warnings in drivers/tty/se=
rial/kgdboc.c)
Merging slab/for-next (ce343df Merge branch 'slab/next' into for-next)
Merging uclinux/for-next (b69f085 Linux 3.7-rc8)
Merging md/for-next (eb9efc4 raid5: create multiple threads to handle strip=
es)
Merging mfd/for-next (1881b68 mfd: tps6507x: Convert to devm_kzalloc)
Merging battery/master (f36b9dd charger-manager: Fix bug when check dropped=
 voltage after fullbatt event)
Merging fbdev/fbdev-next (a49f0d1 Linux 3.8-rc1)
Merging viafb/viafb-next (838ac78 viafb: avoid refresh and mode lookup in s=
et_par)
Merging omap_dss2/for-next (e7f5c9a Merge tag 'omapdss-for-3.8' of git://gi=
torious.org/linux-omap-dss2/linux into for-linus)
Merging regulator/for-next (ce407c7 Merge remote-tracking branch 'regulator=
/topic/tps51632' into regulator-next)
Merging security/next (e930723 Smack: create a sysfs mount point for smackf=
s)
Merging selinux/master (c2d7b24 Merge tag 'v3.4' into 20120409)
Merging lblnet/master (7e27d6e Linux 2.6.35-rc3)
Merging watchdog/master (604a008 Merge branch 'master' of ../linux-watchdog)
Merging dwmw2-iommu/master (6491d4d intel-iommu: Free old page tables befor=
e creating superpage)
Merging iommu/next (9c6ecf6 Merge branches 'iommu/fixes', 'dma-debug', 'x86=
/amd', 'x86/vt-d', 'arm/tegra' and 'arm/omap' into next)
Merging vfio/next (9a92c50 vfio-pci: Enable device before attempting reset)
Merging osd/linux-next (861d666 exofs: don't leak io_state and pages on rea=
d error)
Merging jc_docs/docs-next (5c050fb docs: update the development process doc=
ument)
Merging trivial/for-next (106f9d9 HOWTO: fix double words typo)
Merging audit/for-next (dcd6c92 Linux 3.3-rc1)
Merging pm/linux-next (2b0719f Merge branch 'acpi-scan-next' into linux-nex=
t)
Merging apm/for-next (fb9d78a Merge branch 'for-linus' of git://git.kernel.=
org/pub/scm/linux/kernel/git/jikos/apm)
Merging fsnotify/for-next (1ca39ab inotify: automatically restart syscalls)
Merging edac/linux_next (1c06910 i7core_edac: fix kernel crash on unloading=
 i7core_edac.)
Merging edac-amd/for-next (f7dd80d EDAC, MCE, AMD: Remove unneeded exports)
Merging devicetree/devicetree/next (93c667c of: *node argument to of_parse_=
phandle_with_args should be const)
Merging dt-rh/for-next (58fea35 arm64: Fix the dtbs target building)
Merging spi/spi/next (7cb9436 spi/sparc: Allow of_register_spi_devices for =
sparc)
Merging spi-mb/spi-next (227c4ce spi: omap2-mcspi: remove duplicate inclusi=
on of linux/err.h)
Merging tip/auto-latest (60c190c Merge branch 'linus')
Merging ftrace/for-next (2faffc4 Merge branch 'trace/tip/perf/urgent' into =
trace/for-next)
Merging rcu/rcu/next (91d1aa43 context_tracking: New context tracking susbs=
ystem)
Merging cputime/cputime (c3e0ef9 [S390] fix cputime overflow in uptime_proc=
_show)
Merging uprobes/for-next (0326f5a uprobes/core: Handle breakpoint and singl=
estep exceptions)
Merging kvm/linux-next (7ec4fb4 KVM: move the code that installs new slots =
array to a separate function.)
CONFLICT (content): Merge conflict in arch/s390/kernel/irq.c
CONFLICT (content): Merge conflict in arch/s390/include/asm/irq.h
Applying: KVM: s390: fix for IOINT_VIR name change
Merging kvm-ppc/kvm-ppc-next (26cb772 powerpc: Corrected include header pat=
h in kvm_para.h)
Merging oprofile/for-next (4400910 oprofile, x86: Fix wrapping bug in op_x8=
6_get_ctrl())
Merging fw-cputime/cputime/adjustment-v2 (fa09205 cputime: Comment cputime'=
s adjusting code)
Merging fw-sched/sched/cputime-v2 (1b2852b vtime: Warn if irqs aren't disab=
led on system time accounting APIs)
Merging fw-nohz/nohz/printk-v8 (74876a9 printk: Wake up klogd using irq_wor=
k)
Merging xen/upstream/xen (af3a3ab Merge git://git.kernel.org/pub/scm/linux/=
kernel/git/steve/gfs2-3.0-fixes)
Merging xen-two/linux-next (9736dea Merge commit '74b84233458e9db7c160cec67=
638efdbec748ca9' into linux-next)
CONFLICT (content): Merge conflict in arch/arm/xen/enlighten.c
Merging xen-pvhvm/linux-next (b056b6a xen: suspend: remove xen_hvm_suspend)
Merging percpu/for-next (5479c78 mm, percpu: Make sure percpu_alloc early p=
arameter has an argument)
Merging workqueues/for-next (03c11b2 Merge branch 'for-3.9-cleanups' into f=
or-next)
Merging drivers-x86/linux-next (6710c61 asus-laptop: Fix potential invalid =
pointer dereference)
CONFLICT (content): Merge conflict in drivers/platform/x86/toshiba_acpi.c
CONFLICT (content): Merge conflict in drivers/platform/x86/intel_oaktrail.c
CONFLICT (content): Merge conflict in drivers/platform/x86/ideapad-laptop.c
CONFLICT (content): Merge conflict in drivers/platform/x86/fujitsu-tablet.c
CONFLICT (content): Merge conflict in drivers/platform/x86/compal-laptop.c
CONFLICT (content): Merge conflict in drivers/platform/x86/apple-gmux.c
Merging hwpoison/hwpoison (46e387b Merge branch 'hwpoison-hugepages' into h=
wpoison)
Merging sysctl/master (4e474a0 sysctl: protect poll() in entries that may g=
o away)
Merging regmap/for-next (b956c87 Merge remote-tracking branch 'regmap/topic=
/flat' into regmap-next)
Merging hsi/for-next (43139a6 HSI: hsi_char: Update ioctl-number.txt)
Merging leds/for-next (2f05e1d leds: leds-lp5521: return an error code on e=
rror in probe())
Merging driver-core/driver-core-next (a49f0d1 Linux 3.8-rc1)
Merging tty/tty-next (a49f0d1 Linux 3.8-rc1)
Merging usb/usb-next (a49f0d1 Linux 3.8-rc1)
Merging staging/staging-next (a49f0d1 Linux 3.8-rc1)
Merging char-misc/char-misc-next (a49f0d1 Linux 3.8-rc1)
Merging tmem/linux-next (8f0d816 Linux 3.7-rc3)
Merging writeback/writeback-for-next (2f60d62 CPU hotplug, writeback: Don't=
 call writeback_set_ratelimit() too often during hotplug)
Merging arm-dt/devicetree/arm-next (ede338f dt: add documentation of ARM dt=
 boot interface)
Merging hwspinlock/linux-next (8b37fcf hwspinlock: add MAINTAINERS entries)
Merging pinctrl/for-next (8ab2e75 Merge branch 'devel' into for-next)
CONFLICT (content): Merge conflict in drivers/pinctrl/pinctrl-sirf.c
CONFLICT (content): Merge conflict in drivers/pinctrl/pinctrl-nomadik.c
Merging vhost/linux-next (0e9ff68 vhost-blk: add eventfd dependency)
Merging memblock/memblock-kill-early_node_map (7bd0b0f memblock: Reimplemen=
t memblock allocation using reverse free area iterator)
Merging remoteproc/for-next (6f0c058 Linux 3.7-rc2)
Merging irqdomain/irqdomain/next (023bba3 irqdomain: update documentation)
Merging gpio/gpio/next (fc13d5a gpio: Provide the STMPE GPIO driver with it=
s own IRQ Domain)
Merging gpio-lw/for-next (fc13d5a gpio: Provide the STMPE GPIO driver with =
its own IRQ Domain)
Merging arm-soc/for-next (cfa7abd Merge branch 'heads/fixes' into for-next)
Merging bcm2835/for-next (a49f0d1 Linux 3.8-rc1)
Merging cortex/for-next (77a3018 Cortex-M3: Add support for exception handl=
ing)
CONFLICT (content): Merge conflict in arch/arm/kernel/process.c
Merging ep93xx/ep93xx-for-next (cf92d86 Merge branch 'ep93xx-fixes' into ep=
93xx-for-next)
Merging ixp4xx/next (b94740b IXP4xx: use __iomem for MMIO)
Merging msm/for-next (a0d271c Linux 3.6)
Merging renesas/next (88545c8 Merge branches 'heads/fixes', 'heads/defconfi=
g', 'heads/boards' and 'heads/soc' into next)
Merging samsung/for-next (641cf3b Merge branch 'next/common-exynos' into fo=
r-next)
Merging tegra/for-next (c4009da Merge branch 'for-3.9/defconfig' into for-n=
ext)
Merging kvmtool/master (7c6238b kvm tools: remove unneeded checks in qcow c=
ode)
Merging dma-mapping/dma-mapping-next (41b8d1e ARM: iommu: Include linux/kre=
f.h in asm/dma-iommu.h)
Merging pwm/for-next (20e8ac3 pwm: samsung: add missing s3c->pwm_id assignm=
ent)
Merging dma-buf/for-next (1d40cc8 dma-buf: remove fallback for !CONFIG_DMA_=
SHARED_BUFFER)
Merging userns/for-next (923c753 userns: Allow unprivileged reboot)
Merging ktest/for-next (95f5783 ktest: Fix ELSE IF statements)
Merging signal/for-next (115a1dc x86: convert to ksignal)
CONFLICT (content): Merge conflict in arch/x86/Kconfig
CONFLICT (content): Merge conflict in arch/powerpc/Kconfig
CONFLICT (content): Merge conflict in arch/mips/kernel/syscall.c
CONFLICT (content): Merge conflict in arch/mips/Kconfig
Merging clk/clk-next (8f87189 MAINTAINERS: bad email address for Mike Turqu=
ette)
Merging random/dev (6133705 random: Mix cputime from each thread that exits=
 to the pool)
Merging lzo-update/lzo-update (ba32bf9 lib/lzo: Do not leak implementation =
details in lzo1x_1_compress())
Merging drop-experimental/linux-next (dddaa92 tools/lguest: remove depends =
on CONFIG_EXPERIMENTAL)
CONFLICT (content): Merge conflict in net/dsa/Kconfig
CONFLICT (content): Merge conflict in init/Kconfig
CONFLICT (content): Merge conflict in drivers/ptp/Kconfig
CONFLICT (content): Merge conflict in drivers/net/ethernet/intel/Kconfig
Merging scsi-post-merge/merge-base:master (65112dc Merge git://git.samba.or=
g/sfrench/cifs-2.6)
Merging akpm-current/current (3605cce keys: use keyring_alloc() to create m=
odule signing keyring)
CONFLICT (content): Merge conflict in fs/proc/generic.c
$ git checkout akpm
Applying: drivers/rtc/rtc-tegra.c: convert to DT driver
Applying: mm: cond_resched in tlb_flush_mmu to fix soft lockups on !CONFIG_=
PREEMPT
Applying: mm: fix zone_watermark_ok_safe() accounting of isolated pages
Applying: mm: limit mmu_gather batching to fix soft lockups on !CONFIG_PREE=
MPT
Applying: fs/block_dev.c: page cache wrongly left invalidated after revalid=
ate_disk()
Applying: x86 numa: don't check if node is NUMA_NO_NODE
Applying: arch/x86/tools/insn_sanity.c: identify source of messages
Applying: arch/x86/platform/uv: fix incorrect tlb flush all issue
Applying: olpc: fix olpc-xo1-sci.c build errors
Applying: x86: convert update_mmu_cache() and update_mmu_cache_pmd() to fun=
ctions
Applying: x86: fix the argument passed to sync_global_pgds()
Applying: arch/x86/kernel/cpu/perf_event_p6.c: fix section warning
Applying: x86: make 'mem=3D' option to work for efi platform
Applying: audit: create explicit AUDIT_SECCOMP event type
Applying: audit: catch possible NULL audit buffers
Applying: cris: Use "int" for ssize_t to match size_t
Applying: pcmcia: move unbind/rebind into dev_pm_ops.complete
Applying: drivers/gpu/drm/drm_fb_helper.c: avoid sleeping in unblank_screen=
() if oops in progress
Applying: fb: rework locking to fix lock ordering on takeover
Applying: fb-rework-locking-to-fix-lock-ordering-on-takeover-fix
Applying: fb-rework-locking-to-fix-lock-ordering-on-takeover-fix-2
Applying: cyber2000fb: avoid palette corruption at higher clocks
Applying: timeconst.pl: remove deprecated defined(@array)
Applying: time: don't inline EXPORT_SYMBOL functions
Applying: mm, mempolicy: introduce spinlock to read shared policy tree
Applying: block: restore /proc/partitions to not display non-partitionable =
removable devices
Applying: fs: change return values from -EACCES to -EPERM
Applying: fs/block_dev.c: no need to check inode->i_bdev in bd_forget()
Applying: watchdog: trigger all-cpu backtrace when locked up and going to p=
anic
Applying: memcg, oom: provide more precise dump info while memcg oom happen=
ing
Applying: mm/memcontrol.c: convert printk(KERN_FOO) to pr_foo()
Applying: mm/hugetlb.c: convert to pr_foo()
Applying: CMA: make putback_lru_pages() call conditional
Applying: mm/page_alloc.c:__alloc_contig_migrate_range(): cleanup
Applying: mm: memcg: only evict file pages when we have plenty
Applying: mm: vmscan: save work scanning (almost) empty LRU lists
Applying: mm: vmscan: clarify how swappiness, highest priority, memcg inter=
act
Applying: mm: vmscan: improve comment on low-page cache handling
Applying: mm: vmscan: clean up get_scan_count()
Applying: mm-vmscan-clean-up-get_scan_count-fix
Applying: mm: vmscan: compaction works against zones, not lruvecs
Applying: mm-vmscan-compaction-works-against-zones-not-lruvecs-fix
Applying: mm: reduce rmap overhead for ex-KSM page copies created on swap f=
aults
Applying: mm/page_alloc.c:__setup_per_zone_wmarks: make min_pages unsigned =
long
Applying: mm/vmscan.c:__zone_reclaim(): replace max_t() with max()
Applying: mm: compaction: do not accidentally skip pageblocks in the migrat=
e scanner
Applying: cma-use-unsigned-type-for-count-argument-fix
Applying: mm: memmap_init_zone() performance improvement
Applying: drop_caches: add some documentation and info message
Applying: drivers/usb/gadget/amd5536udc.c: avoid calling dma_pool_create() =
with NULL dev
Applying: mm/dmapool.c: fix null dev in dma_pool_create()
Applying: memcg: debugging facility to access dangling memcgs
Applying: memcg-debugging-facility-to-access-dangling-memcgs-fix
Applying: mm: add vm event counters for balloon pages compaction
Applying: ext3, ext4, ocfs2: remove unused macro NAMEI_RA_INDEX
Applying: scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes
Applying: scripts/tags.sh: add magic for declarations of popular kernel type
Applying: backlight: add lms501kf03 LCD driver
Applying: backlight-add-lms501kf03-lcd-driver-fix
Applying: backlight: ld9040: use sleep instead of delay
Applying: backlight: ld9040: remove unnecessary NULL deference check
Applying: backlight: ld9040: replace EFAULT with EINVAL
Applying: backlight: ld9040: remove redundant return variables
Applying: backlight: ld9040: reorder inclusions of <linux/xxx.h>
Applying: backlight: s6e63m0: use lowercase names of structs
Applying: backlight: s6e63m0: use sleep instead of delay
Applying: backlight: s6e63m0: remove unnecessary NULL deference check
Applying: backlight: s6e63m0: replace EFAULT with EINVAL
Applying: backlight: s6e63m0: remove redundant variable 'before_power'
Applying: backlight: s6e63m0: reorder inclusions of <linux/xxx.h>
Applying: backlight: ams369fg06: use sleep instead of delay
Applying: backlight: ams369fg06: remove unnecessary NULL deference check
Applying: backlight: ams369fg06: replace EFAULT with EINVAL
Applying: backlight: ams369fg06: remove redundant variable 'before_power'
Applying: backlight: ams369fg06: reorder inclusions of <linux/xxx.h>
Applying: epoll: support for disabling items, and a self-test app
Applying: binfmt_elf.c: use get_random_int() to fix entropy depleting
Applying: drivers/rtc: dump small buffers via %*ph
Applying: drivers/rtc/rtc-pxa.c: fix alarm not match issue
Applying: drivers/rtc/rtc-pxa.c: fix alarm can't wake up system issue
Applying: drivers/rtc/rtc-pxa.c: fix set time sync time issue
Applying: drivers/rtc/rtc-ds1307.c: long block operations bugfix
Applying: rtc-ds1307-long-block-operations-bugfix-fix
Applying: rtc: max77686: add Maxim 77686 driver
Applying: rtc-max77686-add-maxim-77686-driver-fix
Applying: rtc-pcf8523: add low battery voltage support
Applying: rtc-pcf8523-add-low-battery-voltage-support-fix
Applying: drivers/rtc: use of_match_ptr() macro
Applying: drivers/rtc/rtc-pxa.c: avoid cpuid checking
Applying: drivers/rtc: remove unnecessary semicolons
Applying: drivers/rtc/rtc-ds2404.c: use module_platform_driver macro
Applying: hfsplus: add osx.* prefix for handling namespace of Mac OS X exte=
nded attributes
Applying: hfsplus: add on-disk layout declarations related to attributes tr=
ee
Applying: hfsplus: add functionality of manipulating by records in attribut=
es tree
Applying: hfsplus: rework functionality of getting, setting and deleting of=
 extended attributes
Applying: hfsplus: add support of manipulation by attributes file
Applying: Documentation/DMA-API-HOWTO.txt: minor grammar corrections
Applying: fork: unshare: remove dead code
Applying: kexec: add the values related to buddy system for filtering free =
pages.
Applying: ipc: remove forced assignment of selected message
Applying: ipc: add sysctl to specify desired next object id
Applying: ipc: message queue receive cleanup
Applying: ipc: introduce message queue copy feature
Applying: selftests: IPC message queue copy feature test
Applying: ipc: simplify free_copy() call
Applying: ipc: convert prepare_copy() from macro to function
Applying: ipc: simplify message copying
Applying: ipc: add more comments to message copying related code
Applying: Documentation/sysctl/kernel.txt: document /proc/sys/shmall
Applying: ipc/sem.c: alternatives to preempt_disable()
Applying: drivers/char/misc.c:misc_register(): do not loop on misc_list unc=
onditionally
Applying: drivers-char-miscc-misc_register-do-not-loop-on-misc_list-uncondi=
tionally-fix
Applying: mtd: mtd_nandecctest: use prandom_bytes instead of get_random_byt=
es()
Applying: mtd: mtd_oobtest: convert to use prandom library
Applying: mtd: mtd_pagetest: convert to use prandom library
Applying: mtd: mtd_speedtest: use prandom_bytes
Applying: mtd: mtd_subpagetest: convert to use prandom library
Applying: mtd: mtd_stresstest: use prandom_bytes()
Applying: Documentation/DMA-API-HOWTO.txt: fix typo
Merging akpm/master (611a74f Documentation/DMA-API-HOWTO.txt: fix typo)
Applying: qlcnic: do not duplicate infrstructure functions

--Signature=_Thu__3_Jan_2013_14_37_41_+1100__dPNL+Ser0fi=IZa
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ5P0FAAoJEECxmPOUX5FECpAP/1cJjkRyXBKxH2aWVvZ3KJZR
xBoqvVFtXEMZSukpbvA+34bMH3kpbVQTkAIPJMWHMSoa2oXqXQaB2cx9OJp/J876
O+715+i8jz84/cidjtZMSGHV3bZtTCiGqZgDhkj42YVaQ+fDqkya2cdK1xh2ezEW
osYZC3aGQ7zEAM44z6WV1x2te6bpscJAyDA9bPZdQrn2tAqec1Pn4n5GoOazMkRd
Nz4F2DKtL6MZLP9c3BNpsUcryYKkUGft5zMZern+ykXNnjWwA+Tn8rxgIX52c4ye
5CHmWnRmLzcNsGbiw6q4NpUqbJ18g7zi0Ms9BTmTe3XFa9jP07rL5B99mMjQWB0M
JrQTLrEVLhWD3lVXjrPJ228uKyZygeBpCVVEi/6g6vivR8lRB7P39r59sq11fDP+
4PTzHXcKp88ijo9RZ4LkQHjupJQ7SEaqrRlo5XRaa7UCYBj9/gG+0WxFl++ZGev0
BHSxixp6eB0krx6pGi8x9kS1aDRV121rVkDtnmWKjU4zEd9iKr+XDJ2WOz/hubmv
FlopJlu3O85q+MQJDgsDvV7cQExrHDiMIgJ7lSZnheFeIdKze/odJycZhVKXVcxa
j5x2H5OpJHv5PB8ukN3Tq+fENibLVyn0p7PZwBzxlC6TEzWH24pwvXAelMQTM5cq
wlVcq39JIhBCULpUnYvM
=xCzh
-----END PGP SIGNATURE-----

--Signature=_Thu__3_Jan_2013_14_37_41_+1100__dPNL+Ser0fi=IZa--

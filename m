Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700Ab2LTGrE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 01:47:04 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:39062 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241Ab2LTGqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 01:46:55 -0500
Date: Thu, 20 Dec 2012 17:46:45 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <linux-next@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Dec 20
Message-Id: <20121220174645.fa520d874bb03d25dc70f76c@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__20_Dec_2012_17_46_45_+1100_mZnmtykeGJFvGH/I"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__20_Dec_2012_17_46_45_+1100_mZnmtykeGJFvGH/I
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20121219:

Lots of conflicts are migrating between trees.

The infiniband tree gained a build failure so I used the version from
next-20121219.

Ths signal tree gained conflicts against Linus' and the cris trees.

The akpm tree lost lots of patches that turned up in Linus' tree.

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
Merging origin/master (2f0bf92 Merge tag 'xtensa-20121218' of git://github.=
com/czankel/xtensa-linux)
Merging fixes/master (791cb02 OMAP: common.c: remove init call to vram fixu=
p)
Merging kbuild-current/rc-fixes (bad9955 menuconfig: Replace CIRCLEQ by lis=
t_head-style lists.)
Merging arm-current/fixes (dad5451 ARM: 7605/1: vmlinux.lds: Move .notes se=
ction next to the rodata)
Merging m68k-current/for-linus (5fec45a m68k/sun3: Fix instruction faults)
Merging powerpc-merge/merge (e716e01 powerpc/eeh: Do not invalidate PE prop=
erly)
Merging sparc/master (6cb9c36 sparc: huge_ptep_set_* functions need to call=
 set_huge_pte_at())
Merging net/master (f8b8403 net: qmi_wwan: add ZTE MF880)
Merging sound-current/for-linus (d846b17 ALSA: hda - Fix build without CONF=
IG_PM)
Merging pci-current/for-linus (ff8e59b PCI/portdrv: Don't create hotplug sl=
ots unless port supports hotplug)
Merging wireless/master (009b969 wireless: fix Atheros drivers compilation)
Merging driver-core.current/driver-core-linus (9360b53 Revert "bdi: add a u=
ser-tunable cpu_list for the bdi flusher threads")
Merging tty.current/tty-linus (1ebaf4f Merge branch 'x86-timers-for-linus' =
of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip)
Merging usb.current/usb-linus (1ebaf4f Merge branch 'x86-timers-for-linus' =
of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip)
Merging staging.current/staging-linus (1ebaf4f Merge branch 'x86-timers-for=
-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip)
Merging char-misc.current/char-misc-linus (1ebaf4f Merge branch 'x86-timers=
-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip)
Merging input-current/for-linus (022573c Merge branch 'next' into for-linus)
Merging md-current/for-linus (a9add5d md/raid5: add blktrace calls)
Merging audit-current/for-linus (c158a35 audit: no leading space in audit_l=
og_d_path prefix)
Merging crypto-current/master (a2c0911 crypto: caam - Updated SEC-4.0 devic=
e tree binding for ERA information.)
Merging ide/master (9974e43 ide: fix generic_ide_suspend/resume Oops)
Merging dwmw2/master (2c37d57 x86: add CONFIG_X86_MOVBE option)
CONFLICT (content): Merge conflict in arch/x86/Kconfig.cpu
CONFLICT (content): Merge conflict in arch/x86/Kconfig
CONFLICT (content): Merge conflict in arch/powerpc/Kconfig
Merging sh-current/sh-fixes-for-linus (4403310 SH: Convert out[bwl] macros =
to inline functions)
Merging irqdomain-current/irqdomain/merge (a0d271c Linux 3.6)
Merging devicetree-current/devicetree/merge (80c2022 of: Fix export of of_f=
ind_matching_node_and_match())
Merging spi-current/spi/merge (d3601e5 spi/sh-hspi: fix return value check =
in hspi_probe().)
Merging gpio-current/gpio/merge (488a00f gpio/ich: Add missing spinlock ini=
t)
Merging rr-fixes/fixes (f3537f9 ASN.1: Fix an indefinite length skip error)
Merging asm-generic/master (fb9de7e xtensa: Use generic asm/mmu.h for nommu)
Merging arm/for-next (dad5451 ARM: 7605/1: vmlinux.lds: Move .notes section=
 next to the rodata)
Merging arm-perf/for-next/perf (3d70f8c Linux 3.7-rc4)
Merging davinci/davinci-next (fe0d422 Linux 3.0-rc6)
Merging xilinx/arm-next (8d32044 ARM: zynq: Remove all unused mach headers)
CONFLICT (content): Merge conflict in drivers/tty/serial/xilinx_uartps.c
CONFLICT (content): Merge conflict in arch/arm/Kconfig.debug
Merging arm64/upstream (d19766e arm64: Update the MAINTAINERS entry)
Merging blackfin/for-linus (86794b4 blackfin: SEC: clean up SEC interrupt i=
nitialization)
Merging c6x/for-linux-next (93bbd0c c6x: use generic kvm_para.h)
Merging cris/for-next (eacb25c UAPI: Fix up empty files in arch/cris/)
CONFLICT (content): Merge conflict in arch/cris/include/asm/signal.h
Merging hexagon/linux-next (e1858b2 Hexagon: Copyright marking changes)
Merging ia64/next (7843ae0 Merge branch 'pstore_mevent' into next)
Merging m68k/for-next (5fec45a m68k/sun3: Fix instruction faults)
Merging m68knommu/for-next (280ef31 m68knommu: modify clock code so it can =
be used by all ColdFire CPU types)
Merging microblaze/next (a4f1de1 mm: fix kernel BUG at huge_memory.c:1474!)
Merging mips/mips-for-linux-next (544bbc6 Merge branch 'current/for-linus' =
into mips-for-linux-next)
Merging openrisc/for-upstream (634bd40 openrisc: use kbuild.h instead of de=
fining macros in asm-offset.c)
Merging parisc/for-next (949a05d [PARISC] fix virtual aliasing issue in get=
_shared_area())
Merging powerpc/next (376bddd Merge remote-tracking branch 'agust/next' int=
o next)
Merging 4xx/next (2074b1d powerpc: Fix irq distribution)
Merging mpc5xxx/next (667b504 powerpc: mpc5200: Add a3m071 board support)
Merging galak/next (1723d90 powerpc/dma/raidengine: add raidengine device)
Merging s390/features (1f1c961 s390/ccwdev: Include asm/schid.h.)
Merging sh/sh-latest (0dd4d5c sh: Fix up more fallout from pointless ARM __=
iomem churn.)
Merging sparc-next/master (66cdd0c Merge tag 'kvm-3.8-1' of git://git.kerne=
l.org/pub/scm/virt/kvm/kvm)
Merging tile/master (e6cdebd arch/tile: set CORE_DUMP_USE_REGSET on tile)
Merging unicore32/unicore32 (c284464 arch/unicore32: remove CONFIG_EXPERIME=
NTAL)
Merging xtensa/for_next (055d4db xtensa: don't try to build DTB when OF is =
disabled)
Merging btrfs/next (23b6d7c Merge branch 'master' of git://git.kernel.org/p=
ub/scm/linux/kernel/git/torvalds/linux into linus-merge)
Merging ceph/master (3515297 rbd: activate v2 image support)
Merging cifs/for-next (4afefde cifs: fix double-free of "string" in cifs_pa=
rse_mount_options)
Merging configfs/linux-next (b930c26 Merge branch 'for-linus' of git://git.=
kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (3702875 fs/ecryptfs/crypto.c: make ecryptfs_encode_f=
or_filename() static)
Merging ext3/for_next (56df127 quota: Use the pre-processor to compile out =
quotactl_cmd_write when !CONFIG_BLOCK)
Merging ext4/dev (bd9926e ext4: zero out inline data using memset() instead=
 of empty_zero_page)
Merging f2fs/dev (4dfd087 f2fs: rewrite the f2fs_gc flow)
Merging fuse/for-next (23ab0c7 cuse: do not register multiple devices with =
identical names)
Merging gfs2/master (1e2d9d4 GFS2: Set gl_object during inode create)
Merging jfs/jfs-next (4e7a4b0 jfs: Fix FITRIM argument handling)
Merging logfs/master (3394661 Fix the call to BUG() caused by no free segme=
nt found)
Merging nfs/linux-next (cd6c596 SUNRPC: continue run over clients list on P=
ipeFS event instead of break)
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
Merging vfs/for-next (a77cfcb fix off-by-one in argument passed by iterate_=
fd() to callbacks)
Merging pci/next (1cb73f8 Merge branch 'pci/mjg-pci-roms-from-efi' into nex=
t)
Merging hid/for-next (01c4f7e Merge branch 'for-3.8/i2c-hid' into for-next)
Merging i2c-embedded/i2c-embedded/for-next (972deb4 i2c: omap: Remove the O=
MAP_I2C_FLAG_RESET_REGS_POSTIDLE flag)
Merging jdelvare-hwmon/master (d699e68 hwmon-vid: Add support for AMD famil=
y 11h to 15h processors)
Merging hwmon-staging/hwmon-next (7764b52 hwmon: (twl4030-madc-hwmon) Fix w=
arning message caused by removal of __devexit)
Merging v4l-dvb/master (db46f44 Merge /home/v4l/v4l/for_upstream)
Merging kbuild/for-next (861e84e Merge branch 'kbuild/misc' into kbuild/for=
-next)
Merging kconfig/for-next (4eae518 localmodconfig: Fix localyesconfig to set=
 to 'y' not 'm')
Merging libata/NEXT (72d5f2d sata_dwc_460ex: remove file exec bit (chmod 07=
55 -> 0644))
Merging infiniband/for-next (4d4b72d Merge branches 'cxgb4', 'ipoib' and 'm=
lx4' into for-next)
$ git reset --hard HEAD^
Merging 20121219 version of infiniband
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
Merging slave-dma/next (fa774f8 dmaengine/dmatest: terminate transfers only=
 in case of errors)
CONFLICT (content): Merge conflict in drivers/dma/mv_xor.c
CONFLICT (content): Merge conflict in drivers/dma/dw_dmac.c
CONFLICT (content): Merge conflict in drivers/dma/dmatest.c
CONFLICT (content): Merge conflict in arch/arm/mach-spear13xx/spear13xx.c
CONFLICT (content): Merge conflict in arch/arm/mach-spear13xx/spear1310.c
CONFLICT (content): Merge conflict in arch/arm/boot/dts/spear1340.dtsi
Merging dmaengine/next (7f34986 dma: ipu: Drop unused spinlock)
Merging net-next/master (66cdd0c Merge tag 'kvm-3.8-1' of git://git.kernel.=
org/pub/scm/virt/kvm/kvm)
Merging wireless-next/master (eca2a43 bridge: fix icmpv6 endian bug and oth=
er sparse warnings)
Merging bluetooth/master (3101c536 Bluetooth: Remove unnecessary include l2=
cap.h)
Merging mtd/master (35f95d2 Merge tag 'for-linus-20121123' of git://git.inf=
radead.org/mtd-2.6)
Merging l2-mtd/master (d4d4f1b mtd: nand: typo in nand_id_has_period() comm=
ents)
Merging crypto/master (a2c0911 crypto: caam - Updated SEC-4.0 device tree b=
inding for ERA information.)
Merging drm/drm-next (55bde6b Merge branch 'drm-intel-fixes' of git://peopl=
e.freedesktop.org/~danvet/drm-intel into drm-next)
Merging sound/for-next (cb99864 ALSA: usb-audio: Support for Digidesign Mbo=
x 2 USB sound card:)
Merging sound-asoc/for-next (8246b5b Merge remote-tracking branch 'asoc/top=
ic/tpa6130a2' into asoc-next)
Merging modules/modules-next (e10e177 MODSIGN: Fix kbuild output when using=
 default extra_certificates)
Merging virtio/virtio-next (1b63704 virtio_console: Add support for remotep=
roc serial)
CONFLICT (content): Merge conflict in drivers/virtio/virtio_balloon.c
CONFLICT (content): Merge conflict in drivers/net/virtio_net.c
Applying: virtnet: for up for virtqueue_get_queue_index removal
Merging input/next (a455e29 Input: walkera0701 - fix crash on startup)
Merging input-mt/for-next (6f0c058 Linux 3.7-rc2)
Merging cgroup/for-next (15ef4ff cgroup: update Documentation/cgroups/00-IN=
DEX)
Merging block/for-next (b6c46cf Merge branch 'stable/for-jens-3.8' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/konrad/xen into for-linus)
Merging device-mapper/master (5cf9de0 If the parameter buffer is small enou=
gh, try to allocate it with kmalloc() rather than vmalloc().)
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
Merging fbdev/fbdev-next (cd9d6f1 gbefb: fix compile error)
Merging viafb/viafb-next (838ac78 viafb: avoid refresh and mode lookup in s=
et_par)
Merging omap_dss2/for-next (e7f5c9a Merge tag 'omapdss-for-3.8' of git://gi=
torious.org/linux-omap-dss2/linux into for-linus)
Merging regulator/for-next (a824b57 Merge remote-tracking branch 'regulator=
/fix/core' into regulator-next)
Merging security/next (e930723 Smack: create a sysfs mount point for smackf=
s)
Merging selinux/master (c2d7b24 Merge tag 'v3.4' into 20120409)
Merging lblnet/master (7e27d6e Linux 2.6.35-rc3)
Merging watchdog/master (7d6d4d8 Merge branch 'master' of git://git.kernel.=
org/pub/scm/linux/kernel/git/torvalds/linux)
Merging dwmw2-iommu/master (c3b92c8 Linux 3.1)
Merging iommu/next (9c6ecf6 Merge branches 'iommu/fixes', 'dma-debug', 'x86=
/amd', 'x86/vt-d', 'arm/tegra' and 'arm/omap' into next)
CONFLICT (modify/delete): arch/arm/mach-omap2/clock44xx_data.c deleted in H=
EAD and modified in iommu/next. Version iommu/next of arch/arm/mach-omap2/c=
lock44xx_data.c left in tree.
$ git rm -f arch/arm/mach-omap2/clock44xx_data.c
Merging vfio/next (9a92c50 vfio-pci: Enable device before attempting reset)
Merging osd/linux-next (861d666 exofs: don't leak io_state and pages on rea=
d error)
Merging jc_docs/docs-next (5c050fb docs: update the development process doc=
ument)
Merging trivial/for-next (106f9d9 HOWTO: fix double words typo)
Merging audit/for-next (dcd6c92 Linux 3.3-rc1)
Merging pm/linux-next (8ab6785 Merge branch 'pm-sleep-next' into linux-next)
Merging apm/for-next (fb9d78a Merge branch 'for-linus' of git://git.kernel.=
org/pub/scm/linux/kernel/git/jikos/apm)
Merging fsnotify/for-next (1ca39ab inotify: automatically restart syscalls)
Applying: fsnotify: cope with change from spinlock to mutex
Merging edac/linux_next (c215786 Merge branch 'fixes' into next)
Merging edac-amd/for-next (3bfe5aa EDAC, pci_sysfs: Use for_each_pci_dev to=
 simplify the code)
Merging devicetree/devicetree/next (93c667c of: *node argument to of_parse_=
phandle_with_args should be const)
Merging dt-rh/for-next (58fea35 arm64: Fix the dtbs target building)
Merging spi/spi/next (7cb9436 spi/sparc: Allow of_register_spi_devices for =
sparc)
Merging spi-mb/spi-next (227c4ce spi: omap2-mcspi: remove duplicate inclusi=
on of linux/err.h)
Merging tip/auto-latest (35fabb6 Merge branch 'linus')
Merging ftrace/for-next (2faffc4 Merge branch 'trace/tip/perf/urgent' into =
trace/for-next)
Merging rcu/rcu/next (91d1aa43 context_tracking: New context tracking susbs=
ystem)
Merging cputime/cputime (c3e0ef9 [S390] fix cputime overflow in uptime_proc=
_show)
Merging uprobes/for-next (0326f5a uprobes/core: Handle breakpoint and singl=
estep exceptions)
Merging kvm/linux-next (e11ae1a KVM: remove unused variable.)
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
Merging workqueues/for-next (023f27d workqueue: fix find_worker_executing_w=
ork() brekage from hashtable conversion)
Merging drivers-x86/linux-next (455f38c eeepc-laptop: fix device reference =
count leakage in eeepc_rfkill_hotplug())
Merging hwpoison/hwpoison (46e387b Merge branch 'hwpoison-hugepages' into h=
wpoison)
Merging sysctl/master (4e474a0 sysctl: protect poll() in entries that may g=
o away)
Merging regmap/for-next (7c8a299 Merge remote-tracking branch 'regmap/topic=
/type' into regmap-next)
Merging hsi/for-next (43139a6 HSI: hsi_char: Update ioctl-number.txt)
Merging leds/for-next (2f05e1d leds: leds-lp5521: return an error code on e=
rror in probe())
Merging driver-core/driver-core-next (9360b53 Revert "bdi: add a user-tunab=
le cpu_list for the bdi flusher threads")
Merging tty/tty-next (1ebaf4f Merge branch 'x86-timers-for-linus' of git://=
git.kernel.org/pub/scm/linux/kernel/git/tip/tip)
Merging usb/usb-next (1ebaf4f Merge branch 'x86-timers-for-linus' of git://=
git.kernel.org/pub/scm/linux/kernel/git/tip/tip)
Merging staging/staging-next (1ebaf4f Merge branch 'x86-timers-for-linus' o=
f git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip)
Merging char-misc/char-misc-next (962b686 Merge tag 'pull_req_20121122' of =
git://git.kernel.org/pub/scm/linux/kernel/git/mzx/extcon into char-misc-nex=
t)
Merging tmem/linux-next (8f0d816 Linux 3.7-rc3)
Merging writeback/writeback-for-next (2f60d62 CPU hotplug, writeback: Don't=
 call writeback_set_ratelimit() too often during hotplug)
Merging arm-dt/devicetree/arm-next (ede338f dt: add documentation of ARM dt=
 boot interface)
Merging hwspinlock/linux-next (8b37fcf hwspinlock: add MAINTAINERS entries)
Merging pinctrl/for-next (8b9e992 Merge branch 'devel' into for-next)
Merging vhost/linux-next (0e9ff68 vhost-blk: add eventfd dependency)
Merging memblock/memblock-kill-early_node_map (7bd0b0f memblock: Reimplemen=
t memblock allocation using reverse free area iterator)
Merging remoteproc/for-next (6f0c058 Linux 3.7-rc2)
Merging irqdomain/irqdomain/next (023bba3 irqdomain: update documentation)
Merging gpio/gpio/next (fc13d5a gpio: Provide the STMPE GPIO driver with it=
s own IRQ Domain)
Merging gpio-lw/for-next (fc13d5a gpio: Provide the STMPE GPIO driver with =
its own IRQ Domain)
Merging arm-soc/for-next (aad05c3 Merge branch 'late/omap-cleanup' into for=
-next)
Merging bcm2835/for-next (2959440 Linux 3.7)
Merging cortex/for-next (77a3018 Cortex-M3: Add support for exception handl=
ing)
CONFLICT (content): Merge conflict in arch/arm/kernel/process.c
Merging ep93xx/ep93xx-for-next (cf92d86 Merge branch 'ep93xx-fixes' into ep=
93xx-for-next)
Merging ixp4xx/next (b94740b IXP4xx: use __iomem for MMIO)
Merging msm/for-next (a0d271c Linux 3.6)
Merging renesas/next (e438fd8 Merge branches 'heads/fixes', 'heads/defconfi=
g', 'heads/boards4', 'heads/soc5' and 'heads/maintainers'; commit 'ab6f6d85=
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
Merging kvmtool/master (5f2ad67 kvm tools: remove max_high field in rb_int_=
node structure)
Merging dma-mapping/dma-mapping-next (4009793 drivers: cma: represent physi=
cal addresses as phys_addr_t)
Merging pwm/for-next (20e8ac3 pwm: samsung: add missing s3c->pwm_id assignm=
ent)
Merging dma-buf/for-next (1d40cc8 dma-buf: remove fallback for !CONFIG_DMA_=
SHARED_BUFFER)
Merging userns/for-next (5155040 userns: Fix typo in description of the lim=
itation of userns_install)
Merging ktest/for-next (95f5783 ktest: Fix ELSE IF statements)
Merging signal/for-next (50ececc alpha: switch to generic sigaltstack)
CONFLICT (content): Merge conflict in arch/x86/include/asm/signal.h
CONFLICT (content): Merge conflict in arch/x86/Kconfig
CONFLICT (content): Merge conflict in arch/cris/include/asm/signal.h
CONFLICT (content): Merge conflict in arch/alpha/include/asm/signal.h
Applying: fix up for unify SS_ONSTACK/SS_DISABLE definitions
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
Merging akpm-current/current (3127f23 Merge branch 'for-linus' of git://git=
.kernel.org/pub/scm/linux/kernel/git/geert/linux-m68k)
$ git checkout akpm
Applying: vfs: d_obtain_alias() needs to use "/" as default name.
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
Applying: fb: rework locking to fix lock ordering on takeover
Applying: fb-rework-locking-to-fix-lock-ordering-on-takeover-fix
Applying: fb-rework-locking-to-fix-lock-ordering-on-takeover-fix-2
Applying: cyber2000fb: avoid palette corruption at higher clocks
Applying: timeconst.pl: remove deprecated defined(@array)
Applying: time: don't inline EXPORT_SYMBOL functions
Applying: mm, mempolicy: introduce spinlock to read shared policy tree
Applying: block: restore /proc/partitions to not display non-partitionable =
removable devices
Applying: vfs: increment iversion when a file is truncated
Applying: fs: change return values from -EACCES to -EPERM
Applying: fs/block_dev.c: no need to check inode->i_bdev in bd_forget()
Applying: watchdog: trigger all-cpu backtrace when locked up and going to p=
anic
Applying: mm: memmap_init_zone() performance improvement
Applying: mm: print out information of file affected by memory error
Applying: mm/mprotect.c: coding-style cleanups
Applying: KSM: numa awareness sysfs knob
Applying: mm: cma: WARN if freed memory is still in use
Applying: drop_caches: add some documentation and info message
Applying: drop_caches-add-some-documentation-and-info-messsge-checkpatch-fi=
xes
Applying: swap: add a simple detector for inappropriate swapin readahead
Applying: swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix
Applying: mm/memblock: reduce overhead in binary search
Applying: drivers/usb/gadget/amd5536udc.c: avoid calling dma_pool_create() =
with NULL dev
Applying: mm/dmapool.c: fix null dev in dma_pool_create()
Applying: memcg: debugging facility to access dangling memcgs
Applying: memcg-debugging-facility-to-access-dangling-memcgs-fix
Applying: mm: add vm event counters for balloon pages compaction
Applying: scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes
Applying: scripts/tags.sh: add magic for declarations of popular kernel type
Applying: sendfile: allows bypassing of notifier events
Applying: backlight: jornada720: fix checkpatch error and warning
Applying: backlight: locomolcd: fix checkpatch error and warning
Applying: backlight: tosa: fix checkpatch error and warning
Applying: drivers/firmware/dmi_scan.c: check dmi version when get system uu=
id
Applying: drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid=
-fix
Applying: drivers/firmware/dmi_scan.c: fetch dmi version from SMBIOS if it =
exists
Applying: drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-ex=
ists-checkpatch-fixes
Applying: epoll: support for disabling items, and a self-test app
Applying: binfmt_elf.c: use get_random_int() to fix entropy depleting
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
Applying: hfsplus: rework processing of hfs_btree_write() returned error
Applying: hfsplus-rework-processing-of-hfs_btree_write-returned-error-fix
Applying: hfsplus: make error message in hfsplus_system_write_inode() more =
compact and detailed
Applying: hfsplus: add error message for the case of failure of sync fs in =
delayed_sync_fs() method
Applying: Documentation/DMA-API-HOWTO.txt: minor grammar corrections
Applying: core_pattern: set core helpers root and namespace to crashing pro=
cess
Applying: core_pattern-set-core-helpers-root-and-namespace-to-crashing-proc=
ess-fix
Applying: core_pattern-set-core-helpers-root-and-namespace-to-crashing-proc=
ess-fix-checkpatch-fixes
Applying: fork: unshare: remove dead code
Applying: exec: do not leave bprm->interp on stack
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
Applying: mtd: mtd_nandecctest: use prandom_bytes instead of get_random_byt=
es()
Applying: mtd: mtd_oobtest: convert to use prandom library
Applying: mtd: mtd_pagetest: convert to use prandom library
Applying: mtd: mtd_speedtest: use prandom_bytes
Applying: mtd: mtd_subpagetest: convert to use prandom library
Applying: mtd: mtd_stresstest: use prandom_bytes()
Applying: Documentation/DMA-API-HOWTO.txt: fix typo
Merging akpm/master (91c20c8 Documentation/DMA-API-HOWTO.txt: fix typo)

--Signature=_Thu__20_Dec_2012_17_46_45_+1100_mZnmtykeGJFvGH/I
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ0rRVAAoJEECxmPOUX5FEdJYQAIkGvQIJTYYmU0HeN+yLdAVO
xWbSVsGJKgHbRSctG1h3SCEhoVCqFtHrrglsNimqEQHZBGNBT/uk5+oU+PtnEvIK
K4BFS/jOMQvKcM/3qFlnKt/sQ3h3Pv8Zuq5oxCtm7QqKNX+cj6v/wJkcNlXUjOhl
SpTc0nQiWrOIKpJokh310Wp/TvlukYXPMO7QDD96dnupPdQNEzYrKt9K9oJIoQjZ
77sOW/X9/LkWNaj4KuGtmTad1gwI6zDUTU/wEi4yaQqB9y3tNo57SQiY1EShHPHv
Af2a/XkpKQtN3fD0SrY82tqLbkiqbDXsadDGvDuScbY8HQOKTZTGeU4Xt9GtqOow
ooJsKfddeyUZAbU1MFITsH0QpmiiSQNja2iB8sxToQBVwzlyBLRJ+aGIcoMGxPA+
9tAfstiMzull04WLbbnZ9HI0saAGk4mUL3SJj3LO0qCgGoCftmcqP+1/RePAvkFU
Xhfhd2xDt1C/2LheHI2+ElWiA/76I5KY3iHmjPRQU58er8YoiyoKHRtiKZxJ8sFs
Cz1DHwdlKr7ek8PVFJVKuOa3ZY9HeKU5jojsi+V7jq0Y5vIjlkh/8TjSlqFX/nDx
GeusSYxzpfM/opKl26slrvalrLntW/zxhqcNqdu+6HFSgj0WmigPLXuC2Yhph5Bk
NMCaHHEcKHyx/1mB97dX
=VSOF
-----END PGP SIGNATURE-----

--Signature=_Thu__20_Dec_2012_17_46_45_+1100_mZnmtykeGJFvGH/I--

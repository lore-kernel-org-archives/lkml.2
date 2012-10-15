Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788Ab2JOCmJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 22:42:09 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:56971 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753711Ab2JOCmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 22:42:04 -0400
Date: Mon, 15 Oct 2012 13:41:56 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <linux-next@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Oct 15
Message-Id: <20121015134156.f46a52fc861143f19e22f354@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__15_Oct_2012_13_41_56_+1100_p6=OYUvaaLmApC+h"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__15_Oct_2012_13_41_56_+1100_p6=OYUvaaLmApC+h
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

The merge window has closed, feel free to add new stuff again.

Changes since 201201012:

The l2-mtd tree still had its build failure so I used the version from
next-20121011.

The tip tree gained a conflict against Linus' tree.

The kvm-ppc tree gained a build failure so I used the version from
next-20121012.

The akpm tree gained a conflict against Linus' tree and lost a couple of
patches that turned up elsewhere.

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
Merging origin/master (ddffeb8 Linux 3.7-rc1)
Merging fixes/master (12250d8 Merge branch 'i2c-embedded/for-next' of git:/=
/git.pengutronix.de/git/wsa/linux)
Merging kbuild-current/rc-fixes (b1e0d8b kbuild: Fix gcc -x syntax)
Merging arm-current/fixes (3d6ee36 Merge branch 'late-for-linus' of git://g=
it.linaro.org/people/rmk/linux-arm)
Merging m68k-current/for-linus (f82735d m68k: Use PTR_RET rather than if(IS=
_ERR(...)) + PTR_ERR)
Merging powerpc-merge/merge (fd3bc66 Merge tag 'disintegrate-powerpc-201210=
09' into merge)
Merging sparc/master (4d7127d Merge branch 'for-linus' of git://git.kernel.=
org/pub/scm/linux/kernel/git/jmorris/linux-security)
Merging net/master (4d7127d Merge branch 'for-linus' of git://git.kernel.or=
g/pub/scm/linux/kernel/git/jmorris/linux-security)
Merging sound-current/for-linus (5d037f9 Merge tag 'asoc-3.6' of git://git.=
kernel.org/pub/scm/linux/kernel/git/broonie/sound into for-linus)
Merging pci-current/for-linus (0ff9514 PCI: Don't print anything while deco=
ding is disabled)
Merging wireless/master (c3e7724 mac80211: use ieee80211_free_txskb to fix =
possible skb leaks)
Merging driver-core.current/driver-core-linus (5698bd7 Linux 3.6-rc6)
Merging tty.current/tty-linus (b70936d tty: serial: sccnxp: Fix bug with un=
terminated platform_id list)
Merging usb.current/usb-linus (d40ce17 Merge tag 'disintegrate-usb-20121009=
' of git://git.infradead.org/users/dhowells/linux-headers into usb-linus)
Merging staging.current/staging-linus (5698bd7 Linux 3.6-rc6)
Merging char-misc.current/char-misc-linus (fea7a08 Linux 3.6-rc3)
Merging input-current/for-linus (0cc8d6a Merge branch 'next' into for-linus)
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
Merging arm/for-next (3d6ee36 Merge branch 'late-for-linus' of git://git.li=
naro.org/people/rmk/linux-arm)
Merging arm-perf/for-next/perf (a0d271c Linux 3.6)
Merging davinci/davinci-next (fe0d422 Linux 3.0-rc6)
Merging xilinx/arm-next (b85a3ef ARM: Xilinx: Adding Xilinx board support)
Merging arm64/upstream (48b3b32 Merge tag 'disintegrate-arm64-20121011' of =
git://git.infradead.org/users/dhowells/linux-headers into uapi)
Merging blackfin/for-linus (9f57151 Merge tag 'disintegrate-blackfin-201210=
09' into for-linus)
Merging c6x/for-linux-next (fbdd63d UAPI: (Scripted) Disintegrate arch/c6x/=
include/asm)
Merging cris/for-next (620614d Merge tag 'disintegrate-cris-20121009' of gi=
t://git.infradead.org/users/dhowells/linux-headers into for-linus)
Merging hexagon/linux-next (5042ab9 various Kconfig cleanup and old platfor=
m build code removal)
Merging ia64/next (d536e0d Merge tag 'disintegrate-ia64-20121009' of git://=
git.infradead.org/users/dhowells/linux-headers into next)
Merging m68k/for-next (f82735d m68k: Use PTR_RET rather than if(IS_ERR(...)=
) + PTR_ERR)
Merging m68knommu/for-next (a255172 m68knommu: fix inconsistent formating i=
n ColdFire 5407 definitions)
Merging microblaze/next (1883baa UAPI: (Scripted) Disintegrate arch/microbl=
aze/include/asm)
Merging mips/mips-for-linux-next (35bafbe Merge tag 'disintegrate-mips-2012=
1009' of git://git.infradead.org/users/dhowells/linux-headers into mips-for=
-linux-next)
Merging openrisc/for-upstream (6257c57 Merge tag 'disintegrate-openrisc-201=
21009' of git://git.infradead.org/users/dhowells/linux-headers)
Merging parisc/for-next (07abad0 [PARISC] asm: redo generic includes)
Merging powerpc/next (d900bd7 powerpc/iommu: Fix multiple issues with IOMMU=
 pools code)
Merging 4xx/next (2074b1d powerpc: Fix irq distribution)
Merging mpc5xxx/next (f3ac712 powerpc/pcm030: add pcm030-audio-fabric to dt=
s)
Merging galak/next (10bfa76 driver/mtd:IFC NAND:Initialise internal SRAM be=
fore any write)
Merging s390/features (86d7c60 s390/chpid: make headers usable (again))
Merging sh/sh-latest (16d74eb sh: pfc: Fix up GPIO mux type reconfig case.)
Merging sparc-next/master (7fe0b14 Merge tag 'spi-3.7' of git://git.kernel.=
org/pub/scm/linux/kernel/git/broonie/misc)
Merging tile/master (c19c6c9 arch/tile: enable interrupts in do_work_pendin=
g())
Merging unicore32/unicore32 (935ce97 UAPI: (Scripted) Disintegrate arch/uni=
core32/include/asm)
Merging xtensa/for_next (70cefe7 xtensa: Setup CROSS_COMPILE at the top)
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
Merging nfsd/nfsd-next (a9ca404 Merge Trond's bugfixes)
Merging ocfs2/linux-next (4538df6 ocfs2: Don't spam on -EDQUOT.)
Merging omfs/for-next (976d167 Linux 3.1-rc9)
Merging squashfs/master (4b0180a Squashfs: add mount time sanity check for =
block_size and block_log match)
Merging v9fs/for-next (552aad0 9P: Fix race between p9_write_work() and p9_=
fd_request())
Merging ubifs/linux-next (a74b6e4 UBIFS: fix mounting problems after power =
cuts)
Merging xfs/for-next (2ea0392 xfs: Make inode32 a remountable option)
Merging vfs/for-next (f81700b procfs: don't need a PATH_MAX allocation to h=
old a string representation of an int)
Merging pci/next (78c8f84 Merge branch 'pci/yinghai-misc' into next)
Merging hid/for-next (0b82411 Merge branch 'hidraw' into for-next)
CONFLICT (content): Merge conflict in drivers/hid/hid-multitouch.c
Merging quilt/i2c (e4b1076 i2c-stub: Move to drivers/i2c)
Merging i2c-embedded/i2c-embedded/for-next (62885f5 MXS: Implement DMA supp=
ort into mxs-i2c)
Merging quilt/jdelvare-hwmon (12250d8 Merge branch 'i2c-embedded/for-next' =
of git://git.pengutronix.de/git/wsa/linux)
Merging hwmon-staging/hwmon-next (17875ef hwmon: DA9055 HWMON driver)
Merging v4l-dvb/master (c3c0b61 Merge /home/v4l/v4l/patchwork)
Merging kbuild/for-next (b974d36 Merge branch 'kbuild/kbuild' into kbuild/f=
or-next)
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
Applying: DMA: PL330: Fix build error (on linux-next-20120924)
Merging dmaengine/next (a2bd114 netdma: adding alignment check for NETDMA o=
ps)
Merging net-next/master (7fe0b14 Merge tag 'spi-3.7' of git://git.kernel.or=
g/pub/scm/linux/kernel/git/broonie/misc)
Merging wireless-next/master (5160b46 ath9k: Fix BTCOEX weight initializati=
on)
Merging bluetooth/master (b699ec0 Bluetooth: Call ops->teardown() without c=
hecking for NULL)
Merging mtd/master (5a6ea4a mtd: ofpart: Fix incorrect NULL check in parse_=
ofoldpart_partitions())
Merging l2-mtd/master (0b72b90 mtd: fsmc_nand: pass the ale and cmd resourc=
e via resource)
$ git reset --hard HEAD^
Merging refs/next/20121011/l2-mtd
Merging crypto/master (c9f97a2 crypto: x86/glue_helper - fix storing of new=
 IV in CBC encryption)
Merging drm/drm-next (1f31c69 Merge branch 'drm-intel-fixes' of git://peopl=
e.freedesktop.org/~danvet/drm-intel into drm-next)
Merging sound/for-next (f7f4b23 ALSA: hda - do not detect jack on internal =
speakers for Realtek)
Merging sound-asoc/for-next (c7c0f2c ASoC: codecs: da9055: Minor improvemen=
t in ALC calibration process)
Merging modules/modules-next (dbadc17 X.509: Fix indefinite length element =
skip error handling)
Merging virtio/virtio-next (d43b716 Merge branch 'rc-fixes' of git://git.ke=
rnel.org/pub/scm/linux/kernel/git/mmarek/kbuild)
Merging input/next (ad5396e Input: mms114 - add device tree bindings)
Merging input-mt/for-next (51c80b7 Input: bcm5974 - Convert to MT-B)
Merging cgroup/for-next (c0a93e2 Merge branch 'for-3.7-hierarchy' into for-=
next)
Merging block/for-next (454832b Merge branch 'for-3.7/drivers' into for-nex=
t)
CONFLICT (content): Merge conflict in init/Kconfig
Merging quilt/device-mapper (0cdaf29 Use the recently-added bio front_pad f=
ield to allocate struct dm_target_io.)
Merging embedded/master (4744b43 embedded: fix vc_translate operator preced=
ence)
Merging firmware/master (6e03a20 firmware: speed up request_firmware(), v3)
Merging pcmcia/master (80af9e6 pcmcia at91_cf: fix raw gpio number usage)
Merging mmc/mmc-next (ecc6260 mmc: rtsx_pci_sdmmc: Add realtek pcie sdmmc h=
ost driver)
Merging kgdb/kgdb-next (58bcdf6 tty/console: fix warnings in drivers/tty/se=
rial/kgdboc.c)
Merging slab/for-next (e2087be Merge branch 'slab/tracing' into slab/for-li=
nus)
Merging uclinux/for-next (a0d271c Linux 3.6)
Merging md/for-next (72f36d5 md: refine reporting of resync/reshape delays.)
Merging mfd/for-next (74d8378 ARM: dts: Enable 88pm860x pmic)
Merging battery/master (18766f0 Merge with upstream to accommodate with MFD=
 changes)
Merging fbdev/fbdev-next (cd9d6f1 gbefb: fix compile error)
Merging viafb/viafb-next (838ac78 viafb: avoid refresh and mode lookup in s=
et_par)
Merging omap_dss2/for-next (13b1ba7 OMAPDSS: add missing include for string=
.h)
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
Merging vfio/next (12250d8 Merge branch 'i2c-embedded/for-next' of git://gi=
t.pengutronix.de/git/wsa/linux)
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
Merging tip/auto-latest (4b84058 Merge branch 'sched/numa')
CONFLICT (content): Merge conflict in mm/mempolicy.c
CONFLICT (content): Merge conflict in mm/huge_memory.c
CONFLICT (content): Merge conflict in include/linux/mempolicy.h
Applying: mm/pol: fixups for UAPI include files split
Merging rcu/rcu/next (d677124 rcu: Advise most users not to enable RCU user=
 mode)
Merging cputime/cputime (c3e0ef9 [S390] fix cputime overflow in uptime_proc=
_show)
Merging uprobes/for-next (0326f5a uprobes/core: Handle breakpoint and singl=
estep exceptions)
Merging kmemleak/kmemleak (ccff9b1 Merge tag 'stable/for-linus-3.7-rc0-tag'=
 of git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen)
Merging kvm/linux-next (03604b3 Merge branch 'for-upstream' of http://githu=
b.com/agraf/linux-2.6 into queue)
CONFLICT (content): Merge conflict in arch/powerpc/include/asm/kvm_para.h
CONFLICT (content): Merge conflict in arch/powerpc/include/asm/Kbuild
Applying: KVM: PPC: fix fallout from UAPI changes
Merging kvm-ppc/kvm-ppc-next (6471d4a KVM: Distangle eventfd code from irqc=
hip)
$ git reset --hard HEAD^
Merging refs/next/20121012/kvm-ppc
CONFLICT (content): Merge conflict in arch/powerpc/kvm/44x_emulate.c
CONFLICT (content): Merge conflict in arch/powerpc/include/asm/kvm_para.h
CONFLICT (content): Merge conflict in arch/powerpc/include/asm/Kbuild
[master f7b1ff9] Merge commit 'refs/next/20121012/kvm-ppc'
Merging oprofile/for-next (61bccf1 oprofile: Remove 'WQ on CPUx, prefer CPU=
y' warning)
Merging xen/upstream/xen (af3a3ab Merge git://git.kernel.org/pub/scm/linux/=
kernel/git/steve/gfs2-3.0-fixes)
Merging xen-two/linux-next (79fef7a Merge branch 'stable/for-linus-3.7' int=
o linux-next)
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
Merging usb/usb-next (0b381a2 Merge tag 'disintegrate-main-20121013' of git=
://git.infradead.org/users/dhowells/linux-headers)
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
Merging pinctrl/for-next (138d68a Merge branch 'samsung' into for-next)
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
Merging gpio-lw/for-next (3fa851e Merge branch 'devel' into for-next)
Merging arm-soc/for-next (ab3ee84 Merge branch 'fixes' into for-next)
Merging ep93xx/ep93xx-for-next (70f0f7c Merge branch 'ep93xx-fixes' into ep=
93xx-for-next)
Merging ixp4xx/next (b94740b IXP4xx: use __iomem for MMIO)
Merging msm/for-next (a0d271c Linux 3.6)
Merging renesas/next (ab48623 Merge branch 'heads/boards' into next)
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
Merging userns/for-next (e9069f4 btrfs: Fix compilation with user namespace=
 support enabled)
Merging ktest/for-next (95f5783 ktest: Fix ELSE IF statements)
Merging signal/for-next (4e21fc1 Merge branch 'for-linus' of git://git.kern=
el.org/pub/scm/linux/kernel/git/viro/signal)
Merging clk/clk-next (494bfec clk: add of_clk_src_onecell_get() support)
Merging random/dev (d2e7c96 random: mix in architectural randomness in extr=
act_buf())
Merging lzo-update/lzo-update (5f70278 lib/lzo: Optimize code for CPUs with=
 inefficient unaligned access)
Merging scsi-post-merge/merge-base:master ()
$ git checkout akpm
Applying: linux/coredump.h needs asm/siginfo.h
Applying: memstick: remove unused field from state struct
Applying: memstick: ms_block: fix compile issue
Applying: memstick: use after free in msb_disk_release()
Applying: memstick: memory leak on error in msb_ftl_scan()
Applying: kernel/sys.c: fix stack memory content leak via UNAME26
Applying: drivers/video/backlight/lm3639_bl.c: return proper error in lm363=
9_bled_mode_store() error paths
Applying: pidns: remove recursion from free_pid_ns()
Applying: pidns-remove-recursion-from-free_pid_ns-v5-fix
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
Applying: olpc: fix olpc-xo1-sci.c build errors
Applying: fs/debugsfs: remove unnecessary inode->i_private initialization
Applying: pcmcia: move unbind/rebind into dev_pm_ops.complete
Applying: drm/i915: optimize DIV_ROUND_CLOSEST() call
Applying: drm: fix radeon printk format warnings
Applying: timeconst.pl: remove deprecated defined(@array)
Applying: time: don't inline EXPORT_SYMBOL functions
Applying: h8300: select generic atomic64_t support
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
Applying: writeback: remove nr_pages_dirtied arg from balance_dirty_pages_r=
atelimited_nr()
Applying: mm: show migration types in show_mem
Applying: memory hotplug: suppress "Device memoryX does not have a release(=
) function" warning
Applying: memory hotplug: suppress "Device nodeX does not have a release() =
function" warning
Applying: mm, memcg: make mem_cgroup_out_of_memory() static
Applying: swap: add a simple detector for inappropriate swapin readahead
Applying: swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix
Applying: mm/memblock: reduce overhead in binary search
Applying: compat: generic compat_sys_sched_rr_get_interval implementation
CONFLICT (content): Merge conflict in arch/arm64/include/asm/unistd32.h
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
Applying: fat: modify nfs mount option
Applying: fat (exportfs): rebuild inode if ilookup() fails
Applying: fat-exportfs-rebuild-inode-if-ilookup-fails-fix
Applying: fat (exportfs): rebuild directory-inode if fat_dget() fails
Applying: Documentation: update nfs option in filesystem/vfat.txt
Applying: kstrto*: add documentation
Applying: simple_strto*: annotate function as obsolete
Applying: proc: don't show nonexistent capabilities
Applying: ipc/sem.c: alternatives to preempt_disable()
Applying: dma-debug: new interfaces to debug dma mapping errors
Applying: linux/compiler.h: add __must_hold macro for functions called with=
 a lock held
Merging akpm/master (a2d7564 linux/compiler.h: add __must_hold macro for fu=
nctions called with a lock held)

--Signature=_Mon__15_Oct_2012_13_41_56_+1100_p6=OYUvaaLmApC+h
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQe3f0AAoJEECxmPOUX5FEyrAP/R6Qq8u/pMks3Lz6cQMsa5xb
id3nUhGv5W6O9mcBpdj+MESPuNlvdvMYTJSFivEVFIEFv0rkjhpbxmiLx9SrvfhB
TNF5VKCgxlC4Tso/77gYP46NJMvUHbs85P+UA6GNVRQfIsARdjxsPYw+j8/e6ts1
hO/NUJZ+TPWAW4TZx3jZVb8eicUb9NrS99Fzypb29eVy+mR+ebDwhFhZ50eiMRYp
yFwWEG5yQO86NrTFU8nFC0EoH5NykymvHdKTihdjFkLL5KprSU3bkwobY8SAZ3r9
ETA/+CRuVvQcNLKOgdvPD4sMtfOIjLYcmS2DMEmDHgNHb+M6DlU2qZ6vSYgybtNC
nOkRDIR4E/Jjqi0g2N+fMIyTOegbNInCZtC0qHxFf+jkjM0vwT4DAS/uvCQ2OyCD
b4GLAWDFnwAIuR4mrm04srqTr17Mj+JTAI0Sqr5r4H9FbMOMFS/rl//PHz7arACJ
gZO9pmPl0fG1jcZ7Cy/xRCHpDYQYPMU4XXfDLyzEWbf1L2GMUipyF6i8Btbv8y8G
3uX/iX+U4b7f1W2HoyFVHaOqVoXo4DYvFsMXr3oMHPpNkogLgF49uzJ/o/L7MUAm
Ad/JapeltyGASuquZYQVy0qr3GzGYuP3UmTBS852Mg7mewtf6k78P5TpMkHxN1KC
hdGmne5iwuxKTaRVrb3t
=LvuQ
-----END PGP SIGNATURE-----

--Signature=_Mon__15_Oct_2012_13_41_56_+1100_p6=OYUvaaLmApC+h--

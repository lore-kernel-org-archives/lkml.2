Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761406Ab2FEDaQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 23:30:16 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:34733 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781Ab2FEDaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 23:30:12 -0400
Date: Tue, 5 Jun 2012 13:30:00 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Jun 5
Message-Id: <20120605133000.f2d21fb02881ef54a7bfe728@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__5_Jun_2012_13_30_00_+1000_qDUgwRzz_a0WMZfd"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__5_Jun_2012_13_30_00_+1000_qDUgwRzz_a0WMZfd
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

There will be no linux-next release tomorrow.

Changes since 20120604:

Removed tree: ep93xx-current (merged into ep93xx)

The infiniband tree lost its conflicts.

The sound-asoc tree lost its build failure but gained another so I used
the version from next-20120601.

The rr tree lost its conflict.

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
Merging origin/master (99becf1 Pull 'for-linus' branches of git://git.kerne=
l.org/pub/scm/linux/kernel/git/viro/{signal,vfs})
Merging fixes/master (b1a808f Merge branch 'for-next' of git://gitorious.or=
g/kernel-hsi/kernel-hsi)
Merging kbuild-current/rc-fixes (e88aa7b Fix modpost failures in fedora 17)
Merging arm-current/fixes (ef0c148 ARM: neponset: make sure neponset_ncr_fr=
ob() is exported)
Merging m68k-current/for-linus (f25e918 m68k: Setup CROSS_COMPILE at the to=
p)
Merging powerpc-merge/merge (7c0482e powerpc/irq: Fix another case of lazy =
IRQ state getting out of sync)
Merging sparc/master (e49e6ff sparc: fix sparc64 build due to leon.h inclus=
ion)
Merging net/master (dc5cd89 net/hyperv: Use wait_event on outstanding sends=
 during device removal)
Merging sound-current/for-linus (fbf2045 Merge tag 'asoc-3.5' of git://git.=
kernel.org/pub/scm/linux/kernel/git/broonie/sound into for-linus)
Merging pci-current/for-linus (314489b Merge tag 'fixes-for-linus' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc)
Merging wireless/master (fcb6ff5 iwlwifi: disable WoWLAN if !CONFIG_PM_SLEE=
P)
Merging driver-core.current/driver-core-linus (f8f5701 Linux 3.5-rc1)
Merging tty.current/tty-linus (f8f5701 Linux 3.5-rc1)
Merging usb.current/usb-linus (f8f5701 Linux 3.5-rc1)
Merging staging.current/staging-linus (f8f5701 Linux 3.5-rc1)
Merging char-misc.current/char-misc-linus (f8f5701 Linux 3.5-rc1)
Merging input-current/for-linus (e644dae Merge branch 'next' into for-linus)
Merging md-current/for-linus (1dff2b8 md/bitmap: record the space available=
 for the bitmap in the superblock.)
Merging audit-current/for-linus (c158a35 audit: no leading space in audit_l=
og_d_path prefix)
Merging crypto-current/master (7c8d518 crypto: aesni-intel - fix unaligned =
cbc decrypt for x86-32)
Merging ide/master (0ab3d8b cy82c693: fix PCI device selection)
Merging dwmw2/master (244dc4e Merge git://git.infradead.org/users/dwmw2/ran=
dom-2.6)
Merging sh-current/sh-fixes-for-linus (3c3c801 Merge branch 'sh/urgent' int=
o sh-fixes-for-linus)
Merging irqdomain-current/irqdomain/merge (15e06bf irqdomain: Fix debugfs f=
ormatting)
Merging devicetree-current/devicetree/merge (4e8383b of: release node fix f=
or of_parse_phandle_with_args)
Merging spi-current/spi/merge (d1c185b of/spi: Fix SPI module loading by us=
ing proper "spi:" modalias prefixes.)
Merging gpio-current/gpio/merge (96b7064 gpio/tca6424: merge I2C transactio=
ns, remove cast)
Merging arm/for-next (bcccc50 ARM: 7420/1: Improve build environment isolat=
ion)
Merging arm-perf/for-next/perf (d0a5710 ARM: perf: remove arm_perf_pmu_ids =
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
Merging hexagon/linux-next (5042ab9 various Kconfig cleanup and old platfor=
m build code removal)
Merging ia64/next (4035c6d [IA64] Liberate the signal layer from IA64 assem=
bler)
Merging m68k/for-next (f25e918 m68k: Setup CROSS_COMPILE at the top)
Merging m68knommu/for-next (983069e m68knommu: m528x qspi definition fix)
Merging microblaze/next (a01ee16 Merge branch 'for-linus' of git://git.open=
-osd.org/linux-open-osd)
Merging mips/mips-for-linux-next (6d26004 Merge branches 'next/jz4740', 'ne=
xt/lantiq' and 'next/netlogic' into mips-for-linux-next)
Merging openrisc/for-upstream (207e715 openrisc: use scratch regs in atomic=
 syscall)
Merging parisc/for-next (2f649c1 [PARISC] fix TLB fault path on PA2.0 narro=
w systems)
Merging powerpc/next (2074b1d powerpc: Fix irq distribution)
Merging 4xx/next (dce4c92 powerpc/40x: Use {upper,lower}_32_bits for msi_ph=
ys)
Merging mpc5xxx/next (f8d5842 powerpc: Option FB_FSL_DIU is not really opti=
onal for mpc512x)
Merging galak/next (fa1b42b powerpc/qe: Update the SNUM table for MPC8569 R=
ev2.0)
Merging s390/features (491af99 s390/uaccess: fix access_ok compile warnings)
Merging sh/sh-latest (1c406e4 sh: use the new generic strnlen_user() functi=
on)
Merging sparc-next/master (31a6710 Fix blocking allocations called very ear=
ly during bootup)
Merging tile/master (f1aebc1 arch/tile: tilegx PCI root complex support)
Merging unicore32/unicore32 (0994695 Merge branch 'akpm' (aka "Andrew's pat=
ch-bomb, take two"))
Merging ceph/master (6bd9adb libceph: fix pg_temp updates)
Merging cifs/for-next (8825736 CIFS: Move get_next_mid to ops struct)
Merging configfs/linux-next (b930c26 Merge branch 'for-linus' of git://git.=
kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (86c47b7 Merge branch 'for-linus' of git://git.kernel=
.org/pub/scm/linux/kernel/git/viro/signal)
Merging ext3/for_next (0324876 ext2: trivial fix to comment for ext2_free_b=
locks)
Merging ext4/dev (5e44f8c ext4: hole-punch use truncate_pagecache_range)
Merging fuse/for-next (203627b fuse: fix blksize calculation)
Merging gfs2/master (72c04af fbdev: sh_mobile_lcdc: Don't confuse line size=
 with pitch)
Merging logfs/master (cd8bfa9 logfs: initialize the number of iovecs in bio)
Merging nfs/linux-next (12cb3e8 Merge branch 'devel' into linux-next)
CONFLICT (content): Merge conflict in fs/inode.c
Merging nfsd/nfsd-next (6eccece nfsd4: fix, consolidate client_has_state)
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
Merging vfs/for-next (f37a02b unexport do_munmap())
CONFLICT (content): Merge conflict in security/security.c
CONFLICT (content): Merge conflict in mm/nommu.c
Merging pci/next (5420e46 microblaze/PCI: fix "io_offset undeclared" error)
Merging hid/for-next (3c2c4b7 Merge branch 'for-linus' of git://git.kernel.=
org/pub/scm/linux/kernel/git/jikos/hid)
Merging quilt/i2c (af56e0a Merge git://git.kernel.org/pub/scm/linux/kernel/=
git/sage/ceph-client)
Merging bjdooks-i2c/next-i2c (fc84fe1 Merge branch 'for_3.3/i2c/misc' of gi=
t://git.kernel.org/pub/scm/linux/kernel/git/khilman/linux-omap-pm into for-=
33/i2c/omap)
CONFLICT (content): Merge conflict in drivers/i2c/busses/i2c-omap.c
Merging i2c-embedded/i2c-embedded/for-next (ae58d1e i2c: Add generic I2C mu=
ltiplexer using pinctrl API)
Merging quilt/jdelvare-hwmon (7ae8d78 hwmon: (coretemp) Improve support of =
recent Atom CPU models)
Merging hwmon-staging/hwmon-next (ab1f19c hwmon: (max34440) Add support for=
 MAX34460)
Merging v4l-dvb/master (20a2218 Merge /home/v4l/v4l/patchwork)
Merging kbuild/for-next (e499c75 Merge branch 'kbuild/misc' into kbuild/for=
-next)
Merging kconfig/for-next (eae1c36 Merge branch 'kconfig/for-linus-2' into k=
config/for-next)
Merging libata/NEXT (2fff275 PATA host controller driver for ep93xx)
Merging infiniband/for-next (16fdcee Merge branches 'cxgb4', 'mlx4' and 'oc=
rdma' into for-next)
Merging acpi/next (2e70185 ACPI: Add a quirk for "AMILO PRO V2030" to ignor=
e the timer overriding)
Merging cpupowerutils/master (f166033 cpupower tools: add install target to=
 the debug tools' makefiles)
Merging ieee1394/for-next (7baab9a firewire: ohci: sanity-check MMIO resour=
ce)
Merging ubi/linux-next (d48b97b Linux 3.4-rc6)
Merging dlm/next (75af271e dlm: NULL dereference on failure in kmem_cache_c=
reate())
Merging scsi/for-next (8d55e50 [SCSI] fcoe, bnx2fc, libfcoe: SW FCoE and bn=
x2fc use FCoE Syfs)
Merging target-updates/for-next (f80e8ed iscsi-target: Fix iov_count calcul=
ation bug in iscsit_allocate_iovecs)
Merging target-merge/for-next-merge (54131ef Merge branch 'sbp-target-merge=
' into for-next-merge)
Merging ibft/linux-next (935a9fe ibft: Fix finding IBFT ACPI table on UEFI)
Merging isci/all (6df8ea3 merge: devel rnc-devel fixes)
Merging slave-dma/next (f8f5701 Linux 3.5-rc1)
Merging dmaengine/next (a2bd114 netdma: adding alignment check for NETDMA o=
ps)
Merging net-next/master (13497f5 stmmac: remove two useless initialisations)
Merging wireless-next/master (f8f5701 Linux 3.5-rc1)
Merging bluetooth/master (b0daec4 Bluetooth: Remove magic disconnect reason)
Merging mtd/master (f5e7e84 Merge tag 'for-linus-3.5-20120601' of git://git=
.infradead.org/linux-mtd)
Merging l2-mtd/master (cd3a745 nand: mxc_nand: Use clk_prepare_enable/clk_d=
isable_unprepare)
Merging crypto/master (ef45b83 crypto: aesni-intel - move more common code =
to ablk_init_common)
Merging drm/drm-next (8c91402 Merge branch 'drm-nouveau-next' of git://anon=
git.freedesktop.org/git/nouveau/linux-2.6 into drm-core-next)
Merging sound/for-next (d5d36b4 Merge tag 'v3.5-rc1' into for-next)
Merging sound-asoc/for-next (3935ff6 Merge branch 'for-3.6' into asoc-next)
$ git reset --hard HEAD^
Merging refs/next/20120601/sound-asoc
Merging quilt/rr (ba528af init: Drop initcall level output)
Merging input/next (8680917 Input: matrix-keymap - fix building keymaps)
Merging input-mt/for-next (27c347d Input: MT - fix null pointer warning)
Merging cgroup/for-next (fa980ca cgroup: superblock can't be released with =
active dentries)
Merging block/for-next (723c0b7 Kill merge marker in Documentation/feature-=
removal.txt)
CONFLICT (content): Merge conflict in Documentation/feature-removal-schedul=
e.txt
Merging quilt/device-mapper (7c66983 Remove the restriction that limits a t=
arget's specified maximum incoming I/O size to be a power of 2.)
Merging embedded/master (4744b43 embedded: fix vc_translate operator preced=
ence)
Merging firmware/master (6e03a20 firmware: speed up request_firmware(), v3)
Merging pcmcia/master (80af9e6 pcmcia at91_cf: fix raw gpio number usage)
Merging mmc/mmc-next (0caaa95 mmc: at91-mci: this driver is now deprecated)
Merging kgdb/kgdb-next (3751d3e x86,kgdb: Fix DEBUG_RODATA limitation using=
 text_poke())
Merging slab/for-next (23910c5 Merge branch 'slub/cleanups' into slab/next)
Merging uclinux/for-next (5e442a4 Revert "proc: fix races against execve() =
of /proc/PID/fd**")
Merging md/for-next (aba336b md: raid1/raid10: fix problem with merge_bvec_=
fn)
Merging mfd/for-next (29f772d mfd: Fix build break of max77693 by adding RE=
GMAP_I2C option)
Merging battery/master (96facd2 smb347-charger: Include missing <linux/err.=
h>)
Merging fbdev/fbdev-next (c895305 video: bfin_adv7393fb: Fix cleanup code)
Merging viafb/viafb-next (838ac78 viafb: avoid refresh and mode lookup in s=
et_par)
Merging omap_dss2/for-next (05dd0f5 OMAPDSS: DISPC: Update Accumulator conf=
iguration for chroma plane)
Merging regulator/for-next (cd325ed Merge branches 'regulator-core' and 're=
gulator-drivers' into regulator-next)
Merging security/next (ff2bb04 Merge branch 'master' of git://git.infradead=
.org/users/eparis/selinux into next)
Merging selinux/master (c737f82 SELinux: remove unused common_audit_data in=
 flush_unauthorized_files)
Merging lblnet/master (7e27d6e Linux 2.6.35-rc3)
Merging watchdog/master (f8f5701 Linux 3.5-rc1)
Merging dwmw2-iommu/master (c3b92c8 Linux 3.1)
Merging iommu/next (eee5353 iommu/amd: Fix deadlock in ppr-handling error p=
ath)
Merging osd/linux-next (8b56a30 exofs:  Add SYSFS info for autologin/pNFS e=
xport)
Merging jc_docs/docs-next (5c050fb docs: update the development process doc=
ument)
Merging trivial/for-next (d2582a7 Doc: document max raw dev number)
Merging audit/for-next (dcd6c92 Linux 3.3-rc1)
Merging pm/linux-next (6da5e30e Merge branch 'pm-acpi' into linux-next)
Merging apm/for-next (f283d22 APM: fix deadlock in APM_IOC_SUSPEND ioctl)
Merging fsnotify/for-next (1aec9c0 inotify: automatically restart syscalls)
Merging edac/linux_next (29a6674 Merge branch 'fixes' into next)
Merging edac-amd/for-next (305f1c3 Merge branch '3.3-pci_device_id' into ed=
ac-for-next)
CONFLICT (content): Merge conflict in drivers/edac/amd64_edac.c
CONFLICT (content): Merge conflict in Documentation/edac.txt
Merging devicetree/devicetree/next (8d6c1ef Merge branch 'devicetree/merge'=
 into devicetree/next)
Merging spi/spi/next (d8e328b spi: Add "spi:" prefix to modalias attribute =
of spi devices)
Merging tip/auto-latest (4b7a762 Merge branch 'x86/urgent')
CONFLICT (content): Merge conflict in kernel/fork.c
CONFLICT (content): Merge conflict in arch/x86/syscalls/syscall_64.tbl
CONFLICT (content): Merge conflict in arch/x86/syscalls/syscall_32.tbl
Merging rcu/rcu/next (860e1cc rcu: Fix broken strings in RCU's source code.)
Merging cputime/cputime (c3e0ef9 [S390] fix cputime overflow in uptime_proc=
_show)
Merging uprobes/for-next (0326f5a uprobes/core: Handle breakpoint and singl=
estep exceptions)
Merging kmemleak/kmemleak (4878677 kmemleak: do not leak object after tree =
insertion error)
Merging kvm/linux-next (b48b2c3 openrisc: use generic strnlen_user() functi=
on)
Merging kvm-ppc/kvm-ppc-next (555b092 KVM: PPC: Not optimizing MSR_CE and M=
SR_ME with paravirt.)
Merging oprofile/for-next (c16fa4f Linux 3.3)
Merging xen/upstream/xen (af3a3ab Merge git://git.kernel.org/pub/scm/linux/=
kernel/git/steve/gfs2-3.0-fixes)
Merging xen-two/linux-next (703daa2 Merge branch 'stable/for-linus-3.5' int=
o linux-next)
Merging xen-pvhvm/linux-next (b056b6a xen: suspend: remove xen_hvm_suspend)
Merging percpu/for-next (61011677 Merge tag 'dlm-3.5' of git://git.kernel.o=
rg/pub/scm/linux/kernel/git/teigland/linux-dlm)
Merging workqueues/for-next (61011677 Merge tag 'dlm-3.5' of git://git.kern=
el.org/pub/scm/linux/kernel/git/teigland/linux-dlm)
Merging drivers-x86/linux-next (d0e0a477 dell-laptop: Add touchpad led supp=
ort for Dell V3450)
Merging hwpoison/hwpoison (46e387b Merge branch 'hwpoison-hugepages' into h=
wpoison)
Merging sysctl/master (4e474a0 sysctl: protect poll() in entries that may g=
o away)
Merging regmap/for-next (154063f Merge branches 'regmap-core' and 'regmap-l=
inus' into regmap-next)
Merging hsi/for-next (43139a6 HSI: hsi_char: Update ioctl-number.txt)
Merging leds/for-next (60b39ec led-triggers: rename *trigger to *trig for u=
nified naming scheme)
Merging driver-core/driver-core-next (f8f5701 Linux 3.5-rc1)
Merging tty/tty-next (f8f5701 Linux 3.5-rc1)
Merging usb/usb-next (f8f5701 Linux 3.5-rc1)
Merging staging/staging-next (f8f5701 Linux 3.5-rc1)
Merging char-misc/char-misc-next (f8f5701 Linux 3.5-rc1)
Merging tmem/linux-next (0f1ea93 Merge branch 'stable/frontswap.v14' into l=
inux-next)
CONFLICT (content): Merge conflict in mm/page_io.c
CONFLICT (add/add): Merge conflict in mm/frontswap.c
CONFLICT (content): Merge conflict in mm/Makefile
CONFLICT (add/add): Merge conflict in include/linux/frontswap.h
CONFLICT (add/add): Merge conflict in Documentation/vm/frontswap.txt
Merging writeback/writeback-for-next (027310a block: Convert BDI proportion=
 calculations to flexible proportions)
Merging arm-dt/devicetree/arm-next (ede338f dt: add documentation of ARM dt=
 boot interface)
Merging hwspinlock/linux-next (8b37fcf hwspinlock: add MAINTAINERS entries)
Merging pinctrl/for-next (7df4227 pinctrl: add pinctrl_add_gpio_ranges func=
tion)
Merging moduleh/for-sfr (f9e1b2b tile: fix compile failure on start_kernel =
in setup.c)
Merging vhost/linux-next (e0953c8 tun: experimental zero copy tx support)
Merging kmap_atomic/kmap_atomic (317b6e1 feature-removal-schedule.txt: sche=
dule the deprecated form of kmap_atomic() for removal)
Merging memblock/memblock-kill-early_node_map (7bd0b0f memblock: Reimplemen=
t memblock allocation using reverse free area iterator)
Merging remoteproc/for-next (d48b97b Linux 3.4-rc6)
Merging irqdomain/irqdomain/next (a87487e irqdomain: Document size paramete=
r of irq_domain_add_linear())
Merging gpio/gpio/next (3e11f7b gpio/generic: initialize basic_mmio_gpio sh=
adow variables properly)
Merging arm-soc/for-next (9bd9695 Merge branch 'devel-late' into for-next)
Merging ep93xx/ep93xx-for-next (762be29 ep93xx: Add IDE support to edb93xx =
boards)
Merging renesas/next (76ab1e9 Merge branch 'renesas-emev2' into renesas-nex=
t)
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/Makefile
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/Kconfig
Merging s5p/for-next (3bd5eba Merge branch 'next/board-samsung-2' into for-=
next)
Merging tegra/for-next (ef14f5c Merge branch 'for-3.5/defconfig2' into for-=
next)
Merging kvmtool/master (c5b40e0 kvm tools: Rename ~/.kvm-tools/ to ~/.lkvm/)
Merging dma-mapping/dma-mapping-next (b28670f Merge branch 'for-next-other'=
 into for-next)
Merging dma-buf/for-next (b48b2c3 openrisc: use generic strnlen_user() func=
tion)
Merging userns/for-next (4b06a81 userns:  Silence silly gcc warning.)
Merging ktest/for-next (648a182 ktest: Allow a test to override REBOOT_ON_S=
UCCESS)
Merging signal/for-next (c0a9b61 Uninclude linux/freezer.h)
Merging scsi-post-merge/merge-base:master ()
$ git checkout akpm
Applying: umem: fix up unplugging
Applying: cciss: fix incorrect scsi status reporting
Applying: arch/x86/platform/iris/iris.c: register a platform device and a p=
latform driver
Applying: arch/x86/include/asm/spinlock.h: fix comment
Applying: timeconst.pl: remove deprecated defined(@array)
Applying: ocfs2: use find_last_bit()
Applying: ocfs2: use bitmap_weight()
Applying: drivers/scsi/ufs: use module_pci_driver
Applying: drivers/scsi/ufs: reverse the ufshcd_is_device_present logic
Applying: drivers/scsi/ufs: fix incorrect return value about SUCCESS and FA=
ILED
Applying: drivers/scsi/atp870u.c: fix bad use of udelay
Applying: fs: symlink restrictions on sticky directories
Applying: fs: hardlink creation restrictions
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
Applying: mm: correctly synchronize rss-counters at exit/exec
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
Applying: locking: add KERN_CONT when needed to self test
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
Applying: NMI watchdog: fix for lockup detector breakage on resume
Applying: nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix
Applying: nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix-fix-f=
ix
Applying: nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix-fix
Applying: watchdog: fix for lockup detector breakage on resume
Applying: nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-v2-fix
Applying: leds: add LED driver for lm3556 chip
Applying: leds-add-led-driver-for-lm3556-chip-checkpatch-fixes
Applying: leds: lm3556: don't call kfree for the memory allocated by devm_k=
zalloc
Applying: kmod: avoid deadlock from recursive kmod call
Applying: proc: unify ptrace_may_access() locking code
Applying: proc/smaps: show amount of hwpoison pages
Applying: proc: use IS_ERR_OR_NULL()
Applying: ipc/sem.c: alternatives to preempt_disable()
Applying: pidns: guarantee that the pidns init will be the last pidns proce=
ss reaped
Applying: fs, proc: introduce /proc/<pid>/task/<tid>/children entry
Applying: c/r: fs, proc: Move children entry back to tid_base_stuff
Applying: c/r: prctl: update prctl_set_mm_exe_file() after mm->num_exe_file=
_vmas removal
Applying: c/r: prctl: add ability to get clear_tid_address
Applying: c/r: prctl: drop VMA flags test on PR_SET_MM_ stack data assignme=
nt
Applying: notify_change(): check that i_mutex is held
Merging quilt/akpm (ca7d450 notify_change(): check that i_mutex is held)

--Signature=_Tue__5_Jun_2012_13_30_00_+1000_qDUgwRzz_a0WMZfd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPzX04AAoJEECxmPOUX5FEO5MP/2MpH+0snTGbxrjg8lxWM0mp
tFkp4VMhOA5suxF0f1dhpabaYmg3Zf8SsVzeYniq5UYhilwzmzfN4VdMax4SPK69
aFDhKH+Lmpay7rvCRzU+bYW0eQdqTtyFKXLqfF+oJpE2boUWhucVea+lVkUMjh2g
yFTlGlCyklAJMDzIKLYPJ9IR1p8aEQYIe4LSNIp43hh21/lur58Ule4PW/mMGk+1
Igpa/yKk4XGQ0MaznwWJDHAz0XUr55sSyDUAjXeGKM00xlCCGBB3a1C9Pyjolu8O
aKewjp+nnbCRom6mUwiaJxto4JVL9RNnZA4O7pyL1q11XEe4ccjrkl0q4LyOuZ/h
OmOLrrDGaXeeIauOH4qe8GTiwBQ8ZsJ7B1nqgkyu6hBmvlM00C+auQB8Dg/2GVu/
L1mkGcN5Fqi+eqmtx+6ZpB4+y9gDYkRjLzTXkYfiLmlmTVKxpef11ghUzKofg5ah
JOu7zflmwr/I16ETpnmyrvksaw8BL4M9yGuj6MSUfTOabpAF60zHygpjRVqvGKgR
HKmmgZByuQ1wt3owCYn1TUvqH2cfqBJTcs5gCrfa0ERuvL0BaFlEAeqYF99RA/29
KOQ24f6A5cNaNJKpeUg5Zb8w6i233x6xSarBb+eyQXF2CWD8WWQwQQ7m4SdWIcpk
S6YPHZ5PLQx30/WS9fd6
=vMwX
-----END PGP SIGNATURE-----

--Signature=_Tue__5_Jun_2012_13_30_00_+1000_qDUgwRzz_a0WMZfd--

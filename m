Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758367Ab2FUGMO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 02:12:14 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:56823 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802Ab2FUGMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 02:12:10 -0400
Date: Thu, 21 Jun 2012 16:12:00 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Jun 21
Message-Id: <20120621161200.9f42414a528897bb016869e2@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta8 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__21_Jun_2012_16_12_00_+1000_86C/.5Uw/O8BHwss"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__21_Jun_2012_16_12_00_+1000_86C/.5Uw/O8BHwss
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Uploads to ra/geb.kernel.org are broken right now, so the tree will not
be available until that is fixed and I have uploaded it.

News: All my builds are now done with gcc 4.6.3 and binutils 2.22.

Changes since 20120620:

The net-next tree lost its conflicts and build failure.

The wireless-next tree lost its conflicts but gained a build failure for
which I reverted a commit.

The regulator tree lost its build failure but gained another so I used
the version from next-20120619.

The pm tree lost its build failure.

The tip tree gained a conflict against the slab tree.

The akpm tree lost some patches that turned up in Linus' tree.

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
Merging origin/master (bc259ad Merge tag 'staging-3.5-rc4' of git://git.ker=
nel.org/pub/scm/linux/kernel/git/gregkh/staging)
Merging fixes/master (9023a40 Merge tag 'mmc-fixes-for-3.5-rc4' of git://gi=
t.kernel.org/pub/scm/linux/kernel/git/cjb/mmc)
Merging kbuild-current/rc-fixes (464076b Makefile: Do not call cc-option be=
fore including the arch's Makefile)
Merging arm-current/fixes (10aa5a3 SPI: fix over-eager devm_xxx() conversio=
n)
Merging m68k-current/for-linus (d8ce726 m68k: Use generic strncpy_from_user=
(), strlen_user(), and strnlen_user())
Merging powerpc-merge/merge (7c0482e powerpc/irq: Fix another case of lazy =
IRQ state getting out of sync)
Merging sparc/master (39a50b4 Merge branch 'hfsplus')
Merging net/master (8633c08 ixgbe: Fix memory leak in ixgbe when receiving =
traffic on DDP enabled rings)
Merging sound-current/for-linus (0b1d8e0 ALSA: 6fire: use NULL instead of 0=
 for pointer assignment)
Merging pci-current/for-linus (314489b Merge tag 'fixes-for-linus' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc)
Merging wireless/master (931cb03 ath9k_htc: configure bssid on ASSOC/IBSS c=
hange)
Merging driver-core.current/driver-core-linus (96c9f05 extcon: max8997: Add=
 missing kfree for info->edev in max8997_muic_remove())
Merging tty.current/tty-linus (78d80c5 serial/amba-pl011: move custom pin c=
ontrol to driver)
Merging usb.current/usb-linus (1e2c4e5 USB: option: add id for Cellient MEN=
-200)
Merging staging.current/staging-linus (3026b0e staging: r8712u: Add new USB=
 IDs)
Merging char-misc.current/char-misc-linus (49fbd3f misc: mei: set WDIOF_ALA=
RMONLY on mei watchdog)
Merging input-current/for-linus (2177905 Input: fix input.h kernel-doc warn=
ing)
Merging md-current/for-linus (aba336b md: raid1/raid10: fix problem with me=
rge_bvec_fn)
Merging audit-current/for-linus (c158a35 audit: no leading space in audit_l=
og_d_path prefix)
Merging crypto-current/master (c475c06 hwrng: atmel-rng - fix data valid ch=
eck)
Merging ide/master (39a50b4 Merge branch 'hfsplus')
Merging dwmw2/master (244dc4e Merge git://git.infradead.org/users/dwmw2/ran=
dom-2.6)
Merging sh-current/sh-fixes-for-linus (790b9d4 Merge tag 'sh-for-linus' of =
git://github.com/pmundt/linux-sh)
Merging irqdomain-current/irqdomain/merge (15e06bf irqdomain: Fix debugfs f=
ormatting)
Merging devicetree-current/devicetree/merge (4e8383b of: release node fix f=
or of_parse_phandle_with_args)
Merging spi-current/spi/merge (d1c185b of/spi: Fix SPI module loading by us=
ing proper "spi:" modalias prefixes.)
Merging gpio-current/gpio/merge (96b7064 gpio/tca6424: merge I2C transactio=
ns, remove cast)
Merging arm/for-next (4d0d790 Merge branches 'fixes' and 'misc' into for-ne=
xt)
Merging arm-perf/for-next/perf (dee8c1b ARM: perf: remove arm_perf_pmu_ids =
global enumeration)
Merging davinci/davinci-next (fe0d422 Linux 3.0-rc6)
Merging samsung/next-samsung (9edb240 ARM: H1940/RX1950: Change default LED=
 triggers)
Merging xilinx/arm-next (b85a3ef ARM: Xilinx: Adding Xilinx board support)
Merging blackfin/for-linus (672552a blackfin: fix build after add bf60x mac=
h/pm.h)
Merging c6x/for-linux-next (485802a Linux 3.5-rc3)
Merging cris/for-next (a29cdb6 cris/PCI: remove pcibios_assign_resources())
Merging hexagon/linux-next (5042ab9 various Kconfig cleanup and old platfor=
m build code removal)
Merging ia64/next (f28fa72 [IA64] Port OOM changes to ia64_do_page_fault)
Merging m68k/for-next (4fa0cff m68knommu: Allow ColdFire CPUs to use unalig=
ned accesses)
Merging m68knommu/for-next (faf6f71 m68knommu: Add clk definitions for m532=
x.)
Merging microblaze/next (a01ee16 Merge branch 'for-linus' of git://git.open=
-osd.org/linux-open-osd)
Merging mips/mips-for-linux-next (d04c60d Merge branches 'next/cavium', 'ne=
xt/jz4740', 'next/lantiq' and 'next/netlogic' into mips-for-linux-next)
Merging openrisc/for-upstream (207e715 openrisc: use scratch regs in atomic=
 syscall)
Merging parisc/for-next (4c01acc [PARISC] fix code to find libgcc)
Merging powerpc/next (2074b1d powerpc: Fix irq distribution)
Merging 4xx/next (2074b1d powerpc: Fix irq distribution)
Merging mpc5xxx/next (f8d5842 powerpc: Option FB_FSL_DIU is not really opti=
onal for mpc512x)
Merging galak/next (fa1b42b powerpc/qe: Update the SNUM table for MPC8569 R=
ev2.0)
Merging s390/features (fbe7656 s390/smp: make absolute lowcore / cpu restar=
t parameter accesses more robust)
Merging sh/sh-latest (e1eaf35 Merge branch 'sh/clkfwk' into sh-latest)
Merging sparc-next/master (31a6710 Fix blocking allocations called very ear=
ly during bootup)
Merging tile/master (7a9349b bounce: allow use of bounce pool via config op=
tion)
Merging unicore32/unicore32 (e4baa56 UniCore32-bugfix: Remove definitions i=
n asm/bug.h to solve difference between native and cross compiler)
Merging ceph/master (26ce171 libceph: fix NULL dereference in reset_connect=
ion())
Merging cifs/for-next (5f7f1ae cifs: fix parsing of password mount option)
Merging configfs/linux-next (b930c26 Merge branch 'for-linus' of git://git.=
kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (d0ecfce eCryptfs: Initialize empty lower files when =
opening them)
Merging ext3/for_next (0324876 ext2: trivial fix to comment for ext2_free_b=
locks)
Merging ext4/dev (b22b1f1 ext4: don't set i_flags in EXT4_IOC_SETFLAGS)
Merging fuse/for-next (203627b fuse: fix blksize calculation)
Merging gfs2/master (666d1d8 GFS2: Combine functions get_local_rgrp and gfs=
2_inplace_reserve)
Merging logfs/master (cd8bfa9 logfs: initialize the number of iovecs in bio)
Merging nfs/linux-next (76d5d4d Merge branch 'devel' into linux-next)
Merging nfsd/nfsd-next (7df302f NFSD: TEST_STATEID should not return NFS4ER=
R_STALE_STATEID)
Merging ocfs2/linux-next (9392557 ocfs2: avoid unaligned access to dqc_bitm=
ap)
Merging omfs/for-next (976d167 Linux 3.1-rc9)
Merging squashfs/master (4b0180a Squashfs: add mount time sanity check for =
block_size and block_log match)
Merging v9fs/for-next (5fcb08b 9p: BUG before corrupting memory)
Merging ubifs/linux-next (1cfb727 UBIFS: fix assertion)
Merging xfs/for-next (51c8422 xfs: fix typo in comment of xfs_dinode_t.)
Merging vfs/for-next (2753683 debugfs: get rid of useless arguments to debu=
gfs_{mkdir,symlink})
Merging pci/next (140217a Merge branch 'topic/jan-intx-masking' into next)
CONFLICT (content): Merge conflict in drivers/pci/quirks.c
Merging hid/for-next (f79185b Merge branch 'uhid' into for-next)
Merging quilt/i2c (54b0574 i2c/writing-clients: Mention module_i2c_driver())
Merging bjdooks-i2c/next-i2c (fc84fe1 Merge branch 'for_3.3/i2c/misc' of gi=
t://git.kernel.org/pub/scm/linux/kernel/git/khilman/linux-omap-pm into for-=
33/i2c/omap)
CONFLICT (content): Merge conflict in drivers/i2c/busses/i2c-omap.c
Merging i2c-embedded/i2c-embedded/for-next (0f009a9 i2c: tegra: make all re=
source allocation through devm_*)
Merging quilt/jdelvare-hwmon (3c1aae2 hwmon: struct x86_cpu_id arrays can b=
e __initconst)
Merging hwmon-staging/hwmon-next (c8a044b hwmon: (w83l785ts) Convert to use=
 devm_ functions)
Merging v4l-dvb/master (9d5c332 Merge /home/v4l/v4l/patchwork)
CONFLICT (content): Merge conflict in drivers/hid/hid-ids.h
Merging kbuild/for-next (c6ff25b Merge branch 'kbuild/rc-fixes' into kbuild=
/for-next)
Merging kconfig/for-next (4503379 localmodconfig: Add debug environment var=
iable LOCALMODCONFIG_DEBUG)
Merging libata/NEXT (2fff275 PATA host controller driver for ep93xx)
Merging infiniband/for-next (a323e3f Merge branch 'cma' into for-next)
Merging acpi/next (4e86d6d Merge branch 'turbostat-v2' into next)
Merging cpupowerutils/master (f166033 cpupower tools: add install target to=
 the debug tools' makefiles)
Merging ieee1394/for-next (e18907c firewire: ohci: initialize multiChanMode=
 bits after reset)
Merging ubi/linux-next (f8f5701 Linux 3.5-rc1)
Merging dlm/next (6b70194 dlm: fix conversion deadlock from recovery)
Merging scsi/for-next (6ef2448 [SCSI] qla4xxx: Update driver version to 5.0=
2.00-k18)
Merging target-updates/for-next (f02b0ba target/iscsi: Remove dead code in =
lio_get_tpg_from_tpg_item())
Merging target-merge/for-next-merge (cfaf025 Linux 3.5-rc2)
Merging ibft/linux-next (935a9fe ibft: Fix finding IBFT ACPI table on UEFI)
Merging isci/all (6df8ea3 merge: devel rnc-devel fixes)
Merging slave-dma/next (0a07603 Merge branch 'fixes' into next)
Merging dmaengine/next (a2bd114 netdma: adding alignment check for NETDMA o=
ps)
Merging net-next/master (1c11a0a Merge branch 'master' of git://git.kernel.=
org/pub/scm/linux/kernel/git/jkirsher/net-next)
CONFLICT (content): Merge conflict in net/ipv6/route.c
Merging wireless-next/master (f761b69 rtlwifi: rtl8192se: Fix gcc 4.7.x war=
ning)
Merging bluetooth/master (790eff4 Bluetooth: Use GFP_KERNEL in mgmt events =
functions)
Merging mtd/master (ea3b2ea mtd: nand: initialize bitflip_threshold prior t=
o BBT scanning)
Merging l2-mtd/master (b27ebae mtd: m25p80: Add support for n25q064)
Merging crypto/master (c45b3b4 crypto: algapi - Move larval completion into=
 algboss)
Merging drm/drm-next (9c19415 Merge tag 'drm-intel-next-2012-06-04' of git:=
//people.freedesktop.org/~danvet/drm-intel into drm-core-next)
Merging sound/for-next (a10e2a4 Merge branch 'topic/hda' into for-next)
Merging sound-asoc/for-next (ddae69b Merge branch 'for-3.6' into asoc-next)
Merging quilt/rr (ba528af init: Drop initcall level output)
Merging input/next (e7ec014 Input: twl6040-vibra - update for device tree s=
upport)
Merging input-mt/for-next (27c347d Input: MT - fix null pointer warning)
Merging cgroup/for-next (f9b6023f Merge branch 'for-3.5-fixes' into for-nex=
t)
Merging block/for-next (f45d342 Merge branch 'for-linus' into for-next)
Merging quilt/device-mapper (12ce893 dm-thin will be most likely used with =
a block size that is a power of two. So it should be optimized for this cas=
e.)
Merging embedded/master (4744b43 embedded: fix vc_translate operator preced=
ence)
Merging firmware/master (6e03a20 firmware: speed up request_firmware(), v3)
Merging pcmcia/master (80af9e6 pcmcia at91_cf: fix raw gpio number usage)
Merging mmc/mmc-next (8922403 mmc: tmio: remove a duplicated comment line)
Merging kgdb/kgdb-next (3751d3e x86,kgdb: Fix DEBUG_RODATA limitation using=
 text_poke())
Merging slab/for-next (43d7786 slub: refactoring unfreeze_partials())
Merging uclinux/for-next (5e442a4 Revert "proc: fix races against execve() =
of /proc/PID/fd**")
Merging md/for-next (aba336b md: raid1/raid10: fix problem with merge_bvec_=
fn)
Merging mfd/for-next (29f772d mfd: Fix build break of max77693 by adding RE=
GMAP_I2C option)
Merging battery/master (f888bb9 test_power: Add VOLTAGE_NOW and BATTERY_TEM=
P properties)
Applying: ACPI-Thermal: fix for an API change
Merging fbdev/fbdev-next (485802a Linux 3.5-rc3)
Merging viafb/viafb-next (838ac78 viafb: avoid refresh and mode lookup in s=
et_par)
Merging omap_dss2/for-next (05dd0f5 OMAPDSS: DISPC: Update Accumulator conf=
iguration for chroma plane)
Merging regulator/for-next (491cd0d Merge branch 'regulator-drivers', tag '=
regulator-3.5' into regulator-next)
$ git reset --hard HEAD^
Merging refs/next/20120619/regulator
Merging security/next (3072928 tpm: check the chip reference before using i=
t)
Merging selinux/master (c737f82 SELinux: remove unused common_audit_data in=
 flush_unauthorized_files)
Merging lblnet/master (7e27d6e Linux 2.6.35-rc3)
Merging watchdog/master (39a50b4 Merge branch 'hfsplus')
Merging dwmw2-iommu/master (c3b92c8 Linux 3.1)
Merging iommu/next (eee5353 iommu/amd: Fix deadlock in ppr-handling error p=
ath)
Merging osd/linux-next (8b56a30 exofs:  Add SYSFS info for autologin/pNFS e=
xport)
Merging jc_docs/docs-next (5c050fb docs: update the development process doc=
ument)
Merging trivial/for-next (c224071 parisc: cleanup quoted include)
Merging audit/for-next (dcd6c92 Linux 3.3-rc1)
Merging pm/linux-next (037d559 PM / ACPI: Fix suspend/resume regression cau=
sed by cpuidle cleanup.)
Merging apm/for-next (f283d22 APM: fix deadlock in APM_IOC_SUSPEND ioctl)
Merging fsnotify/for-next (1aec9c0 inotify: automatically restart syscalls)
Merging edac/linux_next (2d9531a Merge branch 'devel' into next)
Merging edac-amd/for-next (305f1c3 Merge branch '3.3-pci_device_id' into ed=
ac-for-next)
CONFLICT (content): Merge conflict in drivers/edac/amd64_edac.c
CONFLICT (content): Merge conflict in Documentation/edac.txt
Merging devicetree/devicetree/next (efd68e7 devicetree: add helper inline f=
or retrieving a node's full name)
Merging spi/spi/next (d8e328b spi: Add "spi:" prefix to modalias attribute =
of spi devices)
Merging tip/auto-latest (7db54ca Merge branch 'linus')
CONFLICT (content): Merge conflict in mm/slub.c
CONFLICT (content): Merge conflict in mm/slab.c
Merging rcu/rcu/next (3f26dd3 Merge branches 'bigrt.2012.06.20a', 'doctortu=
re.2012.06.15a', 'fixes.2012.06.20a' and 'fnh.2012.06.15a' into dev.3.6.201=
2.06.20a)
Merging cputime/cputime (c3e0ef9 [S390] fix cputime overflow in uptime_proc=
_show)
Merging uprobes/for-next (0326f5a uprobes/core: Handle breakpoint and singl=
estep exceptions)
Merging kmemleak/kmemleak (4878677 kmemleak: do not leak object after tree =
insertion error)
Merging kvm/linux-next (dcce048 KVM: trace events: update list of exit reas=
ons)
Merging kvm-ppc/kvm-ppc-next (5e5054c booke: Added crit/mc exception handle=
r for e500v2)
Merging oprofile/for-next (c16fa4f Linux 3.3)
Merging xen/upstream/xen (af3a3ab Merge git://git.kernel.org/pub/scm/linux/=
kernel/git/steve/gfs2-3.0-fixes)
Merging xen-two/linux-next (e4e7b82 Merge branch 'stable/for-linus-3.6' int=
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
Merging regmap/for-next (dabefce Merge branch 'regmap-page' into regmap-nex=
t)
Merging hsi/for-next (43139a6 HSI: hsi_char: Update ioctl-number.txt)
Merging leds/for-next (2e443cf leds: [trivial]Remove unnecesary return)
Merging driver-core/driver-core-next (6790126 w1: Fix a typo in 'hardware' =
word)
CONFLICT (content): Merge conflict in drivers/extcon/extcon_gpio.c
Merging tty/tty-next (fe89def pch_uart: Add eg20t_port lock field, avoid re=
cursive spinlocks)
Merging usb/usb-next (ff446f2 Merge 3.5-rc3 into usb-next)
Merging staging/staging-next (1e6a9e5 pstore/ram_core: Better ECC size chec=
king)
Merging char-misc/char-misc-next (21c66d1 mei: group wd_interface_reg with =
watchdog variables within struct mei_device)
Merging tmem/linux-next (3bebf5b Merge branch 'stable/for-linus-3.6' into l=
inux-next)
Merging writeback/writeback-for-next (331cbde writeback: Fix some comment e=
rrors)
Merging arm-dt/devicetree/arm-next (ede338f dt: add documentation of ARM dt=
 boot interface)
Merging hwspinlock/linux-next (8b37fcf hwspinlock: add MAINTAINERS entries)
Merging pinctrl/for-next (cc033c4 pinctrl/u300: drop unused variable)
Merging moduleh/for-sfr (f9e1b2b tile: fix compile failure on start_kernel =
in setup.c)
Merging vhost/linux-next (e0953c8 tun: experimental zero copy tx support)
Merging kmap_atomic/kmap_atomic (317b6e1 feature-removal-schedule.txt: sche=
dule the deprecated form of kmap_atomic() for removal)
Merging memblock/memblock-kill-early_node_map (7bd0b0f memblock: Reimplemen=
t memblock allocation using reverse free area iterator)
Merging remoteproc/for-next (5414687 MAINTAINERS: add remoteproc's git)
CONFLICT (content): Merge conflict in drivers/remoteproc/remoteproc_core.c
Merging irqdomain/irqdomain/next (aed9804 irqdomain: Make ops->map hook opt=
ional)
Merging gpio/gpio/next (3e11f7b gpio/generic: initialize basic_mmio_gpio sh=
adow variables properly)
Merging arm-soc/for-next (13bf52c Merge branch 'fixes' into for-next)
Merging ep93xx/ep93xx-for-next (9b6a359 Merge branch 'ep93xx-fixes' into ep=
93xx-for-next)
Merging renesas/next (295756b Merge branch 'renesas-board' into renesas-nex=
t)
Merging s5p/for-next (99f9f4c Merge branch 'v3.5-samsung-fixes-1' into for-=
next)
Merging tegra/for-next (118fef7 Merge branch 'for-3.6/defconfig' into for-n=
ext)
Merging kvmtool/master (5fffd63 kvm tools: set the HYPERVISOR flag in cpuid)
Merging dma-mapping/dma-mapping-next (016887e scatterlist: add sg_alloc_tab=
le_from_pages function)
Merging dma-buf/for-next (b48b2c3 openrisc: use generic strnlen_user() func=
tion)
Merging userns/for-next (491fa9e userns: Allow the usernamespace support to=
 build after the removal of usbfs)
Merging ktest/for-next (648a182 ktest: Allow a test to override REBOOT_ON_S=
UCCESS)
Merging signal/for-next (57760eb Uninclude linux/freezer.h)
Merging scsi-post-merge/merge-base:master ()
$ git checkout akpm
Applying: selinux: fix something
Applying: tmpfs: implement NUMA node interleaving
Applying: tmpfs-implement-numa-node-interleaving-fix
Applying: cciss: fix incorrect scsi status reporting
Applying: arch/x86/platform/iris/iris.c: register a platform device and a p=
latform driver
Applying: arch/x86/include/asm/spinlock.h: fix comment
Applying: timeconst.pl: remove deprecated defined(@array)
Applying: time: don't inline EXPORT_SYMBOL functions
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
Applying: fs: push rcu_barrier() from deactivate_locked_super() to filesyst=
ems
Applying: hfs: push lock_super down
Applying: hfs: get rid of lock_super
Applying: hfs: remove extra mdb write on unmount
Applying: hfs: simplify a bit checking for R/O
Applying: hfs: introduce VFS superblock object back-reference
Applying: hfs: get rid of hfs_sync_super
Applying: hfs-get-rid-of-hfs_sync_super-checkpatch-fixes
Applying: fs/xattr.c:getxattr(): improve handling of allocation failures
Applying: mm/slab: remove duplicate check
Applying: slab: move FULL state transition to an initcall
Applying: vmalloc: walk vmap_areas by sorted list instead of rb_next()
Applying: mm: make vb_alloc() more foolproof
Applying: mm-make-vb_alloc-more-foolproof-fix
Applying: memcg: rename MEM_CGROUP_STAT_SWAPOUT as MEM_CGROUP_STAT_SWAP
Applying: memcg: rename MEM_CGROUP_CHARGE_TYPE_MAPPED as MEM_CGROUP_CHARGE_=
TYPE_ANON
Applying: memcg: remove MEM_CGROUP_CHARGE_TYPE_FORCE
Applying: swap: allow swap readahead to be merged
Applying: documentation: update how page-cluster affects swap I/O
Applying: mm: account the total_vm in the vm_stat_account()
Applying: mm: compaction: handle incorrect MIGRATE_UNMOVABLE type pageblocks
Applying: mm-compaction-handle-incorrect-migrate_unmovable-type-pageblocks-=
fix
Applying: mm/buddy: cleanup on should_fail_alloc_page
Applying: mm: prepare for removal of obsolete /proc/sys/vm/nr_pdflush_threa=
ds
Applying: hugetlb: rename max_hstate to hugetlb_max_hstate
Applying: hugetlb: don't use ERR_PTR with VM_FAULT* values
Applying: hugetlb: add an inline helper for finding hstate index
Applying: hugetlb: use mmu_gather instead of a temporary linked list for ac=
cumulating pages
Applying: hugetlb: avoid taking i_mmap_mutex in unmap_single_vma() for huge=
tlb
Applying: hugetlb: simplify migrate_huge_page()
Applying: hugetlb: add a list for tracking in-use HugeTLB pages
Applying: hugetlb: make some static variables global
Applying: hugeltb: mark hugelb_max_hstate __read_mostly
Applying: mm/hugetlb: add new HugeTLB cgroup
Applying: hugetlb/cgroup: add the cgroup pointer to page lru
Applying: hugetlb/cgroup: add charge/uncharge routines for hugetlb cgroup
Applying: hugetlb/cgroup: add support for cgroup removal
Applying: hugetlb/cgroup: add hugetlb cgroup control files
Applying: hugetlb/cgroup: migrate hugetlb cgroup info from oldpage to new p=
age during migration
Applying: hugetlb/cgroup: add HugeTLB controller documentation
Applying: hugetlb: move all the in use pages to active list
Applying: hugetlb/cgroup: assign the page hugetlb cgroup when we move the p=
age to active list.
Applying: hugetlb/cgroup: remove exclude and wakeup rmdir calls from migrate
Applying: avr32/mm/fault.c: port OOM changes to do_page_fault
Applying: avr32-mm-faultc-port-oom-changes-to-do_page_fault-fix
Applying: clk: add non CONFIG_HAVE_CLK routines
Applying: clk: remove redundant depends on from drivers/Kconfig
Applying: i2c/i2c-pxa: remove conditional compilation of clk code
Applying: usb/marvell: remove conditional compilation of clk code
Applying: usb/musb: remove conditional compilation of clk code
Applying: ata/pata_arasan: remove conditional compilation of clk code
Applying: net/c_can: remove conditional compilation of clk code
Applying: net/stmmac: remove conditional compilation of clk code
Applying: gadget/m66592: remove conditional compilation of clk code
Applying: gadget/r8a66597: remove conditional compilation of clk code
Applying: usb/host/r8a66597: remove conditional compilation of clk code
Applying: clk: validate pointer in __clk_disable()
Applying: NMI watchdog: fix for lockup detector breakage on resume
Applying: kmsg: /dev/kmsg - properly return possible copy_from_user() failu=
re
Applying: printk: add generic functions to find KERN_<LEVEL> headers
Applying: printk: add kern_levels.h to make KERN_<LEVEL> available for asm =
use
Applying: arch: remove direct definitions of KERN_<LEVEL> uses
Applying: btrfs: use printk_get_level and printk_skip_level, add __printf, =
fix fallout
Applying: btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix=
-fallout-fix
Applying: btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix=
-fallout-checkpatch-fixes
Applying: sound: use printk_get_level and printk_skip_level
Applying: printk: convert the format for KERN_<LEVEL> to a 2 byte pattern
Applying: printk: only look for prefix levels in kernel messages
Applying: printk: remove the now unnecessary "C" annotation for KERN_CONT
Applying: vsprintf: add %pMR for Bluetooth MAC address
Applying: drivers/video/backlight/atmel-pwm-bl.c: use devm_ functions
Applying: drivers/video/backlight/ot200_bl.c: use devm_ functions
Applying: drivers/video/backlight/lm3533_bl.c: use devm_ functions
Applying: backlight: atmel-pwm-bl: use devm_gpio_request()
Applying: backlight: ot200_bl: use devm_gpio_request()
Applying: backlight: tosa_lcd: use devm_gpio_request()
Applying: backlight: tosa_bl: use devm_gpio_request()
Applying: backlight: lms283gf05: use devm_gpio_request()
Applying: backlight: corgi_lcd: use devm_gpio_request()
Applying: backlight: l4f00242t03: export and use devm_gpio_request_one()
Applying: backlight-l4f00242t03-use-devm_gpio_request_one-fix
Applying: include/linux/bitops.h: fix warning
Applying: string: introduce memweight()
Applying: string-introduce-memweight-fix
Applying: qnx4fs: use memweight()
Applying: dm: use memweight()
Applying: affs: use memweight()
Applying: video/uvc: use memweight()
Applying: ocfs2: use memweight()
Applying: ext2: use memweight()
Applying: ext3: use memweight()
Applying: ext4: use memweight()
Applying: checkpatch: Update alignment check
Applying: drivers/rtc/rtc-coh901331.c: use clk_prepare/unprepare
Applying: drivers/rtc/rtc-coh901331.c: use devm allocation
Applying: drivers/rtc/rtc-ab8500.c: use IRQF_ONESHOT when requesting a thre=
aded IRQ
Applying: hfsplus: use -ENOMEM when kzalloc() fails
Applying: kmod: avoid deadlock from recursive kmod call
Applying: fork: use vma_pages() to simplify the code
Applying: fork-use-vma_pages-to-simplify-the-code-fix
Applying: ipc/sem.c: alternatives to preempt_disable()
Applying: drivers/char/ipmi/ipmi_watchdog.c: remove local ioctl defines rep=
laced by generic ones
Applying: fs: cachefiles: add support for large files in filesystem caching
Applying: fs-cachefiles-add-support-for-large-files-in-filesystem-caching-f=
ix
Applying: c/r: fcntl: add F_GETOWNER_UIDS option
Applying: notify_change(): check that i_mutex is held
Merging quilt/akpm (2f54a42 notify_change(): check that i_mutex is held)
[master 84ab96c] Revert "brcmfmac: introduce checkdied debugfs functionalit=
y"

--Signature=_Thu__21_Jun_2012_16_12_00_+1000_86C/.5Uw/O8BHwss
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP4rswAAoJEECxmPOUX5FERiUP/1zfEXjDs2ivmZIpvOoXdAHH
nI84UVvCwkA70Rs4x6meM8zQOleCFBo1v2LzNrD5ramJKG9W/6y6MNvaqoA+Y63C
yStu9041tfUo9360Tz7eQ95Q4B6ZXN9zJXNox6m/BsD2lyzKqawr9UAqD2MOWvwZ
ukcRwn0XtKRbwL61Ck5Mt7ZpPAzYYKPdTuW24nlqoxhtKNOe0pH+2J2AAuJnYGUC
RZqWdFz9HDn2zLsBb6YU69FD/CL2I9kO7YY8kZMH/PmJ1GBZEoffhxuP8HW62jrt
No6CNbVYq0/6wLloTyWKnAFN/bxRelsdeOWHr8PXc17HCV+Zqws08QL1fsL8XQRM
7DZGnZzMnLYm9PfMlu4Th/jvA+4/6hlw4EtVAp5LkodJpOA1qVCmzwAXGFStM7zD
3jiLIZq6+c4N4rh70dzMbOBRt4JBMrGn6MWRrn+UTwBfu81nnJoC7fC1gu4mjRJH
JXeVIwCmImdzXIQcxRrg96M7yJp9h22yYjuXBsxBpEAYAJnT1hLX/0Pw+vlo+ayU
uMdEzyejL3SJJ54bo2a0C6HVyn7XRLxw8a0oRC/V/d781ZEIjjzGVwjbyhTiw5Qh
WbVd+LYZjTH+6SrAHCOw75Vq/PpKVEiRdnhFROz+1pYajuJVf4KmbgjytbEEShW+
vFn0oqiRTmpqV+5dl/v7
=PMVt
-----END PGP SIGNATURE-----

--Signature=_Thu__21_Jun_2012_16_12_00_+1000_86C/.5Uw/O8BHwss--

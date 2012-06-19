Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737Ab2FSFF0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 01:05:26 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:35604 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab2FSFFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 01:05:22 -0400
Date: Tue, 19 Jun 2012 15:05:13 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Jun 19
Message-Id: <20120619150513.364d8c9f19a21b4c6feebbbf@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta8 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__19_Jun_2012_15_05_13_+1000_0s1N_X_R37sAlqFw"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__19_Jun_2012_15_05_13_+1000_0s1N_X_R37sAlqFw
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20120618:

My fixes tree is empty again.

The pci tree gained a conflict against Linus' tree.

The v4l-dvb tree gained a conflict against Linus' tree.

The battery tree gained a build failure for which I applied a patch.

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
Merging origin/master (9023a40 Merge tag 'mmc-fixes-for-3.5-rc4' of git://g=
it.kernel.org/pub/scm/linux/kernel/git/cjb/mmc)
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
Merging net/master (8cfe523 Merge branch 'master' of git://git.kernel.org/p=
ub/scm/linux/kernel/git/linville/wireless into for-davem)
Merging sound-current/for-linus (0b1d8e0 ALSA: 6fire: use NULL instead of 0=
 for pointer assignment)
Merging pci-current/for-linus (314489b Merge tag 'fixes-for-linus' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc)
Merging wireless/master (bcb7ad7 ath9k: Fix softlockup in AR9485)
Merging driver-core.current/driver-core-linus (96c9f05 extcon: max8997: Add=
 missing kfree for info->edev in max8997_muic_remove())
Merging tty.current/tty-linus (78d80c5 serial/amba-pl011: move custom pin c=
ontrol to driver)
Merging usb.current/usb-linus (485802a Linux 3.5-rc3)
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
Merging sh-current/sh-fixes-for-linus (380622e Merge branches 'sh/urgent', =
'sh/core', 'sh/clockevents', 'sh/asm-generic' and 'sh/trivial' into sh-fixe=
s-for-linus)
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
Merging c6x/for-linux-next (8ff98b9 C6X: remove unused config items)
Merging cris/for-next (7b91747 cris: Remove old legacy "-traditional" flag =
from arch-v10/lib/Makefile)
Merging hexagon/linux-next (5042ab9 various Kconfig cleanup and old platfor=
m build code removal)
Merging ia64/next (f28fa72 [IA64] Port OOM changes to ia64_do_page_fault)
Merging m68k/for-next (4fa0cff m68knommu: Allow ColdFire CPUs to use unalig=
ned accesses)
Merging m68knommu/for-next (faf6f71 m68knommu: Add clk definitions for m532=
x.)
Merging microblaze/next (a01ee16 Merge branch 'for-linus' of git://git.open=
-osd.org/linux-open-osd)
Merging mips/mips-for-linux-next (bdab8b5 Merge branches 'next/cavium', 'ne=
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
Merging sh/sh-latest (af68d8f Merge branch 'sh/genirq' into sh-latest)
Merging sparc-next/master (31a6710 Fix blocking allocations called very ear=
ly during bootup)
Merging tile/master (7a9349b bounce: allow use of bounce pool via config op=
tion)
Merging unicore32/unicore32 (e4baa56 UniCore32-bugfix: Remove definitions i=
n asm/bug.h to solve difference between native and cross compiler)
Merging ceph/master (9a64e8e Merge tag 'v3.5-rc1')
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
Merging nfs/linux-next (f617a21 Define ENONAMESERVICE and ENAMEUNKNOWN to i=
ndicate name service errors)
Merging nfsd/nfsd-next (bc2df47 nfsd4: BUG_ON(!is_spin_locked()) no good on=
 UP kernels)
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
Merging quilt/i2c (c364c9b i2c/writing-clients: Mention module_i2c_driver())
Merging bjdooks-i2c/next-i2c (fc84fe1 Merge branch 'for_3.3/i2c/misc' of gi=
t://git.kernel.org/pub/scm/linux/kernel/git/khilman/linux-omap-pm into for-=
33/i2c/omap)
CONFLICT (content): Merge conflict in drivers/i2c/busses/i2c-omap.c
Merging i2c-embedded/i2c-embedded/for-next (0f009a9 i2c: tegra: make all re=
source allocation through devm_*)
Merging quilt/jdelvare-hwmon (df13c46 hwmon: (coretemp) Document TjMax for =
3rd generation i5/i7 processors)
Merging hwmon-staging/hwmon-next (703d42b hwmon: (ina2xx) Add support for I=
NA220 and INA230)
Merging v4l-dvb/master (9d5c332 Merge /home/v4l/v4l/patchwork)
CONFLICT (content): Merge conflict in drivers/hid/hid-ids.h
Merging kbuild/for-next (c6ff25b Merge branch 'kbuild/rc-fixes' into kbuild=
/for-next)
Merging kconfig/for-next (eae1c36 Merge branch 'kconfig/for-linus-2' into k=
config/for-next)
Merging libata/NEXT (2fff275 PATA host controller driver for ep93xx)
Merging infiniband/for-next (a3698a9 RDMA/ocrdma: Fixed RQ error CQE pollin=
g)
Merging acpi/next (4e86d6d Merge branch 'turbostat-v2' into next)
Merging cpupowerutils/master (f166033 cpupower tools: add install target to=
 the debug tools' makefiles)
Merging ieee1394/for-next (e18907c firewire: ohci: initialize multiChanMode=
 bits after reset)
Merging ubi/linux-next (f8f5701 Linux 3.5-rc1)
Merging dlm/next (6b70194 dlm: fix conversion deadlock from recovery)
Merging scsi/for-next (24b1b79 Merge branch 'fixes' into for-next)
Merging target-updates/for-next (f02b0ba target/iscsi: Remove dead code in =
lio_get_tpg_from_tpg_item())
Merging target-merge/for-next-merge (cfaf025 Linux 3.5-rc2)
Merging ibft/linux-next (935a9fe ibft: Fix finding IBFT ACPI table on UEFI)
Merging isci/all (6df8ea3 merge: devel rnc-devel fixes)
Merging slave-dma/next (0a07603 Merge branch 'fixes' into next)
Merging dmaengine/next (a2bd114 netdma: adding alignment check for NETDMA o=
ps)
Merging net-next/master (6fac262 ipv4: Cap ADVMSS metric in the FIB rather =
than the routing cache.)
CONFLICT (content): Merge conflict in drivers/net/wireless/ath/ath9k/main.c
Merging wireless-next/master (daf67ce iwlwifi: unlock on error path)
CONFLICT (content): Merge conflict in drivers/net/wireless/iwlwifi/pcie/tra=
ns.c
CONFLICT (content): Merge conflict in drivers/net/wireless/iwlwifi/dvm/test=
mode.c
Merging bluetooth/master (3701f94 Bluetooth: Remove magic value in disconne=
ct mgmt handler)
Merging mtd/master (ea3b2ea mtd: nand: initialize bitflip_threshold prior t=
o BBT scanning)
Merging l2-mtd/master (bfc3af6 mtd: nand: Use the mirror BBT descriptor whe=
n reading its version)
Merging crypto/master (3387e7d crypto: serpent-sse2/avx - allow both to be =
built into kernel)
Merging drm/drm-next (8c91402 Merge branch 'drm-nouveau-next' of git://anon=
git.freedesktop.org/git/nouveau/linux-2.6 into drm-core-next)
Merging sound/for-next (2f7e6bc Merge branch 'topic/misc' into for-next)
Merging sound-asoc/for-next (01f7d81 Merge branch 'for-3.6' into asoc-next)
Merging quilt/rr (ba528af init: Drop initcall level output)
Merging input/next (e7ec014 Input: twl6040-vibra - update for device tree s=
upport)
Merging input-mt/for-next (27c347d Input: MT - fix null pointer warning)
Merging cgroup/for-next (f9b6023f Merge branch 'for-3.5-fixes' into for-nex=
t)
Merging block/for-next (f45d342 Merge branch 'for-linus' into for-next)
Merging quilt/device-mapper (fd3f53e Remove the restriction that limits a t=
arget's specified maximum incoming I/O size to be a power of 2.)
Merging embedded/master (4744b43 embedded: fix vc_translate operator preced=
ence)
Merging firmware/master (6e03a20 firmware: speed up request_firmware(), v3)
Merging pcmcia/master (80af9e6 pcmcia at91_cf: fix raw gpio number usage)
Merging mmc/mmc-next (3e68086 mmc: block: replace __blk_end_request() with =
blk_end_request())
Merging kgdb/kgdb-next (3751d3e x86,kgdb: Fix DEBUG_RODATA limitation using=
 text_poke())
Merging slab/for-next (23910c5 Merge branch 'slub/cleanups' into slab/next)
Merging uclinux/for-next (5e442a4 Revert "proc: fix races against execve() =
of /proc/PID/fd**")
Merging md/for-next (aba336b md: raid1/raid10: fix problem with merge_bvec_=
fn)
Merging mfd/for-next (29f772d mfd: Fix build break of max77693 by adding RE=
GMAP_I2C option)
Merging battery/master (3be330b power_supply: Register battery as a thermal=
 zone)
Merging fbdev/fbdev-next (b679895 video: s3c-fb: fix possible division by z=
ero in s3c_fb_calc_pixclk)
Merging viafb/viafb-next (838ac78 viafb: avoid refresh and mode lookup in s=
et_par)
Merging omap_dss2/for-next (05dd0f5 OMAPDSS: DISPC: Update Accumulator conf=
iguration for chroma plane)
Merging regulator/for-next (89672ee Merge branches 'regulator-core' and 're=
gulator-drivers' into regulator-next)
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
Merging pm/linux-next (96020fa PM / Sleep: add knob for printing device res=
ume times)
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
Merging tip/auto-latest (51b59d6 Merge branch 'perf/urgent')
Merging rcu/rcu/next (5b5dcc9 Merge branches 'barrier.2012.06.06a', 'doctor=
ture.2012.06.06a', 'fixes.2012.06.06a' and 'fnh.2012.06.06a' into HEAD)
Merging cputime/cputime (c3e0ef9 [S390] fix cputime overflow in uptime_proc=
_show)
Merging uprobes/for-next (0326f5a uprobes/core: Handle breakpoint and singl=
estep exceptions)
Merging kmemleak/kmemleak (4878677 kmemleak: do not leak object after tree =
insertion error)
Merging kvm/linux-next (dcce048 KVM: trace events: update list of exit reas=
ons)
Merging kvm-ppc/kvm-ppc-next (555b092 KVM: PPC: Not optimizing MSR_CE and M=
SR_ME with paravirt.)
Merging oprofile/for-next (c16fa4f Linux 3.3)
Merging xen/upstream/xen (af3a3ab Merge git://git.kernel.org/pub/scm/linux/=
kernel/git/steve/gfs2-3.0-fixes)
Merging xen-two/linux-next (33e5c9e Merge branch 'devel/mce.v3' into linux-=
next)
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
Merging regmap/for-next (71692ef Merge branch 'regmap-page' into regmap-nex=
t)
Merging hsi/for-next (43139a6 HSI: hsi_char: Update ioctl-number.txt)
Merging leds/for-next (6d927cd leds: fix sparse warnings due to missing sta=
tic)
Merging driver-core/driver-core-next (6790126 w1: Fix a typo in 'hardware' =
word)
CONFLICT (content): Merge conflict in drivers/extcon/extcon_gpio.c
Merging tty/tty-next (cfe275c serial: pxa: add spin lock for console write)
Merging usb/usb-next (fec1868 USB: properly pad out usb_device_id.driver_in=
fo)
Merging staging/staging-next (dc34814 staging: comedi: fix Kconfig for COME=
DI_PCMCIA_DRIVERS)
Merging char-misc/char-misc-next (002176d misc: at25: Parse dt settings)
Merging tmem/linux-next (cfaf025 Linux 3.5-rc2)
Merging writeback/writeback-for-next (331cbde writeback: Fix some comment e=
rrors)
Merging arm-dt/devicetree/arm-next (ede338f dt: add documentation of ARM dt=
 boot interface)
Merging hwspinlock/linux-next (8b37fcf hwspinlock: add MAINTAINERS entries)
Merging pinctrl/for-next (b79d7d7 pinctrl: add pinctrl_add_gpio_ranges func=
tion)
Merging moduleh/for-sfr (f9e1b2b tile: fix compile failure on start_kernel =
in setup.c)
Merging vhost/linux-next (e0953c8 tun: experimental zero copy tx support)
Merging kmap_atomic/kmap_atomic (317b6e1 feature-removal-schedule.txt: sche=
dule the deprecated form of kmap_atomic() for removal)
Merging memblock/memblock-kill-early_node_map (7bd0b0f memblock: Reimplemen=
t memblock allocation using reverse free area iterator)
Merging remoteproc/for-next (d48b97b Linux 3.4-rc6)
Merging irqdomain/irqdomain/next (aed9804 irqdomain: Make ops->map hook opt=
ional)
Merging gpio/gpio/next (3e11f7b gpio/generic: initialize basic_mmio_gpio sh=
adow variables properly)
Merging arm-soc/for-next (13bf52c Merge branch 'fixes' into for-next)
Merging ep93xx/ep93xx-for-next (9b6a359 Merge branch 'ep93xx-fixes' into ep=
93xx-for-next)
Merging renesas/next (76ab1e9 Merge branch 'renesas-emev2' into renesas-nex=
t)
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/Makefile
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/Kconfig
Merging s5p/for-next (cfaf025 Linux 3.5-rc2)
Merging tegra/for-next (26dc430 Merge branch 'for-3.6/defconfig' into for-n=
ext)
Merging kvmtool/master (55b5e71 kvm tools: Process virito blk requests in s=
eparate thread)
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
Applying: CMA: mo no enable it by default
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
Applying: hugetlb: rename max_hstate to hugetlb_max_hstate
Applying: hugetlbfs: don't use ERR_PTR with VM_FAULT* values
Applying: hugetlbfs: add an inline helper for finding hstate index
Applying: hugetlbfs-add-an-inline-helper-for-finding-hstate-index-fix
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
Applying: hugetlb-simplify-migrate_huge_page-fix
Applying: memcg: add HugeTLB extension
Applying: memcg-add-hugetlb-extension-fix
Applying: memcg-add-hugetlb-extension-fix-fix
Applying: hugetlb: add charge/uncharge calls for HugeTLB alloc/free
Applying: memcg: track resource index in cftype private
Applying: hugetlbfs: add memcg control files for hugetlbfs
Applying: memcg: use scnprintf instead of sprintf
Applying: hugetlbfs-add-memcg-control-files-for-hugetlbfs-use-scnprintf-ins=
tead-of-sprintf-fix
Applying: memcg/hugetlb: Add failcnt support for hugetlb extension
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
Applying: memcg: fix error code in hugetlb_force_memcg_empty()
Applying: memcg-fix-error-code-in-hugetlb_force_memcg_empty-v2
Applying: memcg-fix-error-code-in-hugetlb_force_memcg_empty-v2-checkpatch-f=
ixes
Applying: memcg: use res_counter_uncharge_until() in mem_cgroup_move_hugetl=
b_parent()
Applying: memcg: move charges to root cgroup if use_hierarchy=3D0 in mem_cg=
roup_move_hugetlb_parent()
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
Applying: NMI watchdog: fix for lockup detector breakage on resume
Applying: nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix
Applying: nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix-fix-f=
ix
Applying: nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix-fix
Applying: watchdog: fix for lockup detector breakage on resume
Applying: nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-v2-fix
Applying: kmsg: /dev/kmsg - properly return possible copy_from_user() failu=
re
Applying: ipc/sem.c: alternatives to preempt_disable()
Applying: c/r: fcntl: add F_GETOWNER_UIDS option
Applying: notify_change(): check that i_mutex is held
Merging quilt/akpm (2c89072 notify_change(): check that i_mutex is held)
Applying: ACPI-Thermal: fix for an API change

--Signature=_Tue__19_Jun_2012_15_05_13_+1000_0s1N_X_R37sAlqFw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP4AiJAAoJEECxmPOUX5FEOtYP/AirUNmR2g2G0sSeu//BnsG8
xiYs7YT0iPOcWta1gqFX6EaP0MEipqcknK2m8XDhL4IrsthsY2gUdraAAg5+SjEn
4OeZUEFRnvw7Uhbcdjf746G1TsW+//8i2cyQwJypBkqybED08zMW8HzxJ3LCXCtF
zTRXbquAyZkQOGnm4R1omP57jfEI8/kYwMSCJ3m7qgdhbyghGB4s0mZ2q6Dm1e2/
UFxUrvUP7IajWgcodK2+37lFQfMVlZKSGVwk/whR1k12liaTSGDPCo93oa2ox/06
U3sRECGjUL8TVUas4k0xe9z1PO1/qqfJ9INDNidFU+AH2vRwqC+LjCJBIGnKHlTq
LCEKyKb0lp5A4L8gWeFtynNidcscMBB6k9bkzDt+BPCygoZxAX63Ao+XXrf3GuHz
I3RKITYtZkjopoYq1/Uygk7sp+Do76sswQ26z0o83teHRPEDM6ZWN01DGR+uc9TP
Xe3pbfHMcFWvZmQqbLS7EChSWG4K0J4p/BZKnYP4W0D0szmHOt4LxPqdDRIszLIa
rb856cM4z6Zvn/n1TQ1QZBtjRd1Y/UCG1At9w+7AsYYRSZNyQmf7gFpU8HR+xrAP
mJvekJL4NVf8qQ0AjOjucyx7mpehBW9RWw1wHFzbbRS2NFkm1kpmbdcNTJUo7fNT
zAF7eOYbB0aJv9ivFCg1
=PRKU
-----END PGP SIGNATURE-----

--Signature=_Tue__19_Jun_2012_15_05_13_+1000_0s1N_X_R37sAlqFw--

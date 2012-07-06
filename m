Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932565Ab2GFHbP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 03:31:15 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:48364 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354Ab2GFHbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 03:31:08 -0400
Date: Fri, 6 Jul 2012 17:20:05 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for July 6
Message-Id: <20120706172005.c2ae04f5ca70c654de1f8924@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__6_Jul_2012_17_20_05_+1000_VDUg_d3e7+Piw1kK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__6_Jul_2012_17_20_05_+1000_VDUg_d3e7+Piw1kK
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20120705:

I have not done the powerpc allyesconfig build today as it is too broken.

New trees: gpio-lw, dt-rh

Dropped tree: gpio-lw (build problem)

The infiniband tree gained a build failure so I used the version from
next-20120705.

The dt-rh tree gained a conflict against the l2-mtd tree.

The kvm tree gained a conflict against Linus' tree.

The kvm-ppc tree lost its build failure.

The driver-core tree lost its conflict.

The gpio-lw tree gained a build failure so I dropped it for today.

I reverted 3 commit from the signal tree at the request of the arm
maintainer.

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

We are up to 196 trees (counting Linus' and 26 trees of patches pending
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
Merging origin/master (c4aed35 Merge tag 'fixes-for-linus' of git://git.ker=
nel.org/pub/scm/linux/kernel/git/arm/arm-soc)
Merging fixes/master (9023a40 Merge tag 'mmc-fixes-for-3.5-rc4' of git://gi=
t.kernel.org/pub/scm/linux/kernel/git/cjb/mmc)
Merging kbuild-current/rc-fixes (f8f5701 Linux 3.5-rc1)
Merging arm-current/fixes (09b2ad1 ARM: fix warning caused by wrongly typed=
 arm_dma_limit)
Merging m68k-current/for-linus (d8ce726 m68k: Use generic strncpy_from_user=
(), strlen_user(), and strnlen_user())
Merging powerpc-merge/merge (2f584a1 powerpc/kvm: sldi should be sld)
Merging sparc/master (6a8ead0 sparc32: Remove superfluous extern declaratio=
ns for prom_*() functions)
Merging net/master (9e85a6f Merge tag 'clk-fixes-for-linus' of git://git.li=
naro.org/people/mturquette/linux)
Merging sound-current/for-linus (8663ff7 ALSA: hda - Fix no sound from ALC6=
62 after Windows reboot)
Merging pci-current/for-linus (314489b Merge tag 'fixes-for-linus' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc)
Merging wireless/master (61c9b7c mac80211: fix kzalloc memory corruption in=
troduced in minstrel_ht)
Merging driver-core.current/driver-core-linus (6887a41 Linux 3.5-rc5)
Merging tty.current/tty-linus (6b16351 Linux 3.5-rc4)
Merging usb.current/usb-linus (b086b6b USB: cdc-wdm: fix lockup on error in=
 wdm_read)
Merging staging.current/staging-linus (6887a41 Linux 3.5-rc5)
Merging char-misc.current/char-misc-linus (6b16351 Linux 3.5-rc4)
Merging input-current/for-linus (9b7e31b Input: request threaded-only IRQs =
with IRQF_ONESHOT)
Merging md-current/for-linus (1068411 md/raid10: fix careless build error)
Merging audit-current/for-linus (c158a35 audit: no leading space in audit_l=
og_d_path prefix)
Merging crypto-current/master (c475c06 hwrng: atmel-rng - fix data valid ch=
eck)
Merging ide/master (39a50b4 Merge branch 'hfsplus')
Merging dwmw2/master (244dc4e Merge git://git.infradead.org/users/dwmw2/ran=
dom-2.6)
Merging sh-current/sh-fixes-for-linus (64941d8 sh: Fix up se7721 GPIOLIB=3D=
y build warnings.)
Merging irqdomain-current/irqdomain/merge (15e06bf irqdomain: Fix debugfs f=
ormatting)
Merging devicetree-current/devicetree/merge (4e8383b of: release node fix f=
or of_parse_phandle_with_args)
Merging spi-current/spi/merge (d1c185b of/spi: Fix SPI module loading by us=
ing proper "spi:" modalias prefixes.)
Merging gpio-current/gpio/merge (96b7064 gpio/tca6424: merge I2C transactio=
ns, remove cast)
Merging arm/for-next (d86abf5 Merge branches 'dmaengine', 'fixes', 'misc' a=
nd 'sta2x11' into for-next)
Merging arm-perf/for-next/perf (dee8c1b ARM: perf: remove arm_perf_pmu_ids =
global enumeration)
Merging davinci/davinci-next (fe0d422 Linux 3.0-rc6)
Merging samsung/next-samsung (9edb240 ARM: H1940/RX1950: Change default LED=
 triggers)
Merging xilinx/arm-next (b85a3ef ARM: Xilinx: Adding Xilinx board support)
Merging blackfin/for-linus (672552a blackfin: fix build after add bf60x mac=
h/pm.h)
Merging c6x/for-linux-next (485802a Linux 3.5-rc3)
Merging cris/for-next (2608747 CRIS: Remove VCS simulator specific code)
Merging hexagon/linux-next (5042ab9 various Kconfig cleanup and old platfor=
m build code removal)
Merging ia64/next (f28fa72 [IA64] Port OOM changes to ia64_do_page_fault)
Merging m68k/for-next (a8ab984 m68k: Remove never used asm/shm.h)
Merging m68knommu/for-next (74340c4 m68knommu: Add clk definitions for m532=
x.)
Merging microblaze/next (a01ee16 Merge branch 'for-linus' of git://git.open=
-osd.org/linux-open-osd)
Merging mips/mips-for-linux-next (669a4eb Merge branch 'next/netlogic' into=
 mips-for-linux-next)
Merging openrisc/for-upstream (207e715 openrisc: use scratch regs in atomic=
 syscall)
Merging parisc/for-next (4c01acc [PARISC] fix code to find libgcc)
Merging powerpc/next (a8b91e4 powerpc/mm: remove obsolete comment about pag=
e size name array)
Merging 4xx/next (2074b1d powerpc: Fix irq distribution)
Merging mpc5xxx/next (f8d5842 powerpc: Option FB_FSL_DIU is not really opti=
onal for mpc512x)
Merging galak/next (7bf4602 powerpc/p2041rdb: add NAND node in device tree)
Merging s390/features (6b96f15 s390/hypfs: Add missing get_next_ino())
Merging sh/sh-latest (7b98cf0 Merge branch 'common/pfc' into sh-latest)
Merging sparc-next/master (31a6710 Fix blocking allocations called very ear=
ly during bootup)
Merging tile/master (7a9349b bounce: allow use of bounce pool via config op=
tion)
Merging unicore32/unicore32 (e4baa56 UniCore32-bugfix: Remove definitions i=
n asm/bug.h to solve difference between native and cross compiler)
Merging ceph/master (26ce171 libceph: fix NULL dereference in reset_connect=
ion())
CONFLICT (content): Merge conflict in net/ceph/osd_client.c
Merging cifs/for-next (8f2da46 cifs: when server doesn't set CAP_LARGE_READ=
_X, cap default rsize at MaxBufferSize)
Merging configfs/linux-next (b930c26 Merge branch 'for-linus' of git://git.=
kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (5a52c0d eCryptfs: Initialize empty lower files when =
opening them)
Merging ext3/for_next (7d5a4b0 quota: fix checkpatch.pl warning by replacin=
g <asm/uaccess.h> with <linux/uaccess.h>)
Merging ext4/dev (b22b1f1 ext4: don't set i_flags in EXT4_IOC_SETFLAGS)
Merging fuse/for-next (203627b fuse: fix blksize calculation)
Merging gfs2/master (44b8db1 GFS2: Fixing double brelse'ing bh allocated in=
 gfs2_meta_read when EIO occurs)
Merging logfs/master (cd8bfa9 logfs: initialize the number of iovecs in bio)
Merging nfs/linux-next (a932873 Define ENONAMESERVICE and ENAMEUNKNOWN to i=
ndicate name service errors)
Merging nfsd/nfsd-next (7df302f NFSD: TEST_STATEID should not return NFS4ER=
R_STALE_STATEID)
Merging ocfs2/linux-next (2dfd060 aio: make kiocb->private NUll in init_syn=
c_kiocb())
Merging omfs/for-next (976d167 Linux 3.1-rc9)
Merging squashfs/master (4b0180a Squashfs: add mount time sanity check for =
block_size and block_log match)
Merging v9fs/for-next (5fcb08b 9p: BUG before corrupting memory)
Merging ubifs/linux-next (9a7c6b7 Merge tag 'upstream-3.5-rc5' of git://git=
.infradead.org/linux-ubifs)
Merging xfs/for-next (9b73bd7 xfs: factor buffer reading from xfs_dir2_leaf=
_getdents)
CONFLICT (content): Merge conflict in fs/xfs/xfs_log_priv.h
CONFLICT (content): Merge conflict in fs/xfs/xfs_log.c
CONFLICT (content): Merge conflict in fs/xfs/xfs_buf.c
Merging vfs/for-next (dab5369 hold task_lock around checks in keyctl)
CONFLICT (content): Merge conflict in fs/nfs/nfs4proc.c
CONFLICT (content): Merge conflict in fs/cifs/dir.c
Merging pci/next (a7711ba Merge branch 'pci/rafael-pci_set_power_state-reba=
se' into next)
CONFLICT (content): Merge conflict in drivers/pci/quirks.c
CONFLICT (content): Merge conflict in drivers/pci/pci.c
Merging hid/for-next (4b6f706 Merge branch 'magicmouse' into for-next)
Merging quilt/i2c (d0784b6 i2c-i801: Consolidate polling)
Merging bjdooks-i2c/next-i2c (fc84fe1 Merge branch 'for_3.3/i2c/misc' of gi=
t://git.kernel.org/pub/scm/linux/kernel/git/khilman/linux-omap-pm into for-=
33/i2c/omap)
CONFLICT (content): Merge conflict in drivers/i2c/busses/i2c-omap.c
Merging i2c-embedded/i2c-embedded/for-next (0f009a9 i2c: tegra: make all re=
source allocation through devm_*)
Merging quilt/jdelvare-hwmon (3c1aae2 hwmon: struct x86_cpu_id arrays can b=
e __initconst)
CONFLICT (content): Merge conflict in drivers/hwmon/coretemp.c
Merging hwmon-staging/hwmon-next (7d02d09 hwmon: Honeywell Humidicon HIH-61=
30/HIH-6131 humidity and temperature sensor driver)
Merging v4l-dvb/master (f7823bc Merge /home/v4l/v4l/patchwork)
Merging kbuild/for-next (8837c55 Merge branch 'kbuild/kconfig' into kbuild/=
for-next)
Merging kconfig/for-next (4503379 localmodconfig: Add debug environment var=
iable LOCALMODCONFIG_DEBUG)
Merging libata/NEXT (ee32108 libata-acpi: add missing inlines in libata.h)
Applying: libata-acpi: fix up for acpi_pm_device_sleep_state API change
Merging infiniband/for-next (c459ce4 RDMA/cxgb4: Fix endianness of addition=
 to mpa->private_data_size)
$ git reset --hard HEAD^
Merging refs/next/20120705/infiniband
Merging acpi/next (35a0b81 Merge branches 'acpi_pad', 'acpica', 'cpuidle-co=
upled', 'cpuidle-tweaks', 'intel_idle-ivb', 'ost', 'thermal-spear', 'therma=
l-trip-points', 'turbostat-v2' and 'ying-add-deep-d-state-limit' into next)
CONFLICT (content): Merge conflict in drivers/pci/pci-acpi.c
Merging cpuidle/cpuidle-next (3cf7997 acpi: intel_idle : break dependency b=
etween modules)
CONFLICT (add/add): Merge conflict in drivers/cpuidle/coupled.c
Merging cpupowerutils/master (f166033 cpupower tools: add install target to=
 the debug tools' makefiles)
Merging ieee1394/for-next (e3cbd92 firewire: core: document is_local sysfs =
attribute)
Merging ubi/linux-next (f8f5701 Linux 3.5-rc1)
Merging dlm/next (aefee56 dlm: fix missing dir remove)
Merging scsi/for-next (6ef2448 [SCSI] qla4xxx: Update driver version to 5.0=
2.00-k18)
Merging target-updates/for-next (4318efc target: move unmap to struct spc_o=
ps)
Merging target-merge/for-next-merge (cfaf025 Linux 3.5-rc2)
Merging ibft/linux-next (935a9fe ibft: Fix finding IBFT ACPI table on UEFI)
Merging isci/all (8a9c86c merge: devel fixes)
CONFLICT (content): Merge conflict in drivers/ata/libata-core.c
Merging slave-dma/next (46fb3f8 dma: tegra: set DMA_CYCLIC capability)
CONFLICT (content): Merge conflict in drivers/dma/Makefile
CONFLICT (content): Merge conflict in drivers/dma/Kconfig
Merging dmaengine/next (a2bd114 netdma: adding alignment check for NETDMA o=
ps)
Merging net-next/master (a2de86f ipv6: Initialize the neighbour pointer of =
rt6_info on allocation)
CONFLICT (content): Merge conflict in net/mac80211/mlme.c
Merging wireless-next/master (2f9143c Merge branch 'master' of git://git.ke=
rnel.org/pub/scm/linux/kernel/git/linville/wireless)
Merging bluetooth/master (ce2be9a Bluetooth: Do not auto off AMP controller)
Merging mtd/master (ea3b2ea mtd: nand: initialize bitflip_threshold prior t=
o BBT scanning)
Merging l2-mtd/master (dac2fe7 mtd: spear_smi: handle return value of timeo=
uts properly)
CONFLICT (content): Merge conflict in drivers/mtd/maps/uclinux.c
Merging crypto/master (26c8aae crypto: algapi - Fix hang on crypto allocati=
on)
Merging drm/drm-next (74da01d drm/radeon: move r100_enable_bm to a more log=
ic place)
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/intel_display.c
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/i915_dma.c
Merging sound/for-next (303a68db Merge branch 'topic/misc' into for-next)
Merging sound-asoc/for-next (f8996e8 Merge branch 'for-3.6' into asoc-next)
Merging quilt/rr (3487cc0 virtio-blk: allow toggling host cache between wri=
teback and writethrough)
Merging input/next (404c3bc Merge commit 'v3.5-rc5' into next)
Merging input-mt/for-next (c45361a Revert "Input: atmel_mxt_ts - warn if sy=
sfs could not be created")
CONFLICT (content): Merge conflict in drivers/input/touchscreen/atmel_mxt_t=
s.c
Merging cgroup/for-next (f9b6023f Merge branch 'for-3.5-fixes' into for-nex=
t)
Merging block/for-next (f45d342 Merge branch 'for-linus' into for-next)
Merging quilt/device-mapper (05d9324 dm-thin will be most likely used with =
a block size that is a power of two. So it should be optimized for this cas=
e.)
Merging embedded/master (4744b43 embedded: fix vc_translate operator preced=
ence)
Merging firmware/master (6e03a20 firmware: speed up request_firmware(), v3)
Merging pcmcia/master (80af9e6 pcmcia at91_cf: fix raw gpio number usage)
Merging mmc/mmc-next (5e09ca5 mmc: sdhci: restore host settings when card i=
s removed)
Merging kgdb/kgdb-next (3751d3e x86,kgdb: Fix DEBUG_RODATA limitation using=
 text_poke())
Merging slab/for-next (4b57ad9 mm: Fix signal SIGFPE in slabinfo.c.)
Merging uclinux/for-next (5e442a4 Revert "proc: fix races against execve() =
of /proc/PID/fd**")
Merging md/for-next (e89d56d MD RAID10: Export md_raid10_congested)
Merging mfd/for-next (41aead8 mfd: Add device-tree entry to enable tps65910=
 external 32-kHz oscillator)
Merging battery/master (85a392d test_power: Add VOLTAGE_NOW and BATTERY_TEM=
P properties)
Applying: ACPI-Thermal: fix for an API change
Merging fbdev/fbdev-next (3b9cc4e da8xx-fb: Rounding FB size to satisfy SGX=
 buffer requirements)
Merging viafb/viafb-next (838ac78 viafb: avoid refresh and mode lookup in s=
et_par)
Merging omap_dss2/for-next (974a658 Merge "Apply LCD manager related parame=
ters" from Archit)
Merging regulator/for-next (e08530c Merge branch 'regulator-drivers' into r=
egulator-next)
Merging security/next (659b5e7 security: Fix nommu build.)
Merging selinux/master (c2d7b24 Merge tag 'v3.4' into 20120409)
Merging lblnet/master (7e27d6e Linux 2.6.35-rc3)
Merging watchdog/master (97a50c8 watchdog: bcm63xx_wdt: fix driver section =
mismatch)
Merging dwmw2-iommu/master (c3b92c8 Linux 3.1)
Merging iommu/next (037c008 Merge branches 'iommu/fixes', 'groups' and 'arm=
/tegra' into next)
Merging vfio/next (3e00b05 vfio: Add PCI device driver)
Merging osd/linux-next (8b56a30 exofs:  Add SYSFS info for autologin/pNFS e=
xport)
Merging jc_docs/docs-next (5c050fb docs: update the development process doc=
ument)
Merging trivial/for-next (59f91e5 Merge branch 'master' into for-next)
Merging audit/for-next (dcd6c92 Linux 3.3-rc1)
Merging pm/linux-next (bb6ca8e Merge branch 'pm-cpuidle' into linux-next)
Merging apm/for-next (f283d22 APM: fix deadlock in APM_IOC_SUSPEND ioctl)
Merging fsnotify/for-next (1aec9c0 inotify: automatically restart syscalls)
Merging edac/linux_next (a92cdec Merge branch 'devel' into next)
Merging edac-amd/for-next (305f1c3 Merge branch '3.3-pci_device_id' into ed=
ac-for-next)
CONFLICT (content): Merge conflict in drivers/edac/amd64_edac.c
CONFLICT (content): Merge conflict in Documentation/edac.txt
Merging devicetree/devicetree/next (efd68e7 devicetree: add helper inline f=
or retrieving a node's full name)
Merging dt-rh/for-next (33937e9 devicetree: add helper inline for retrievin=
g a node's full name)
CONFLICT (content): Merge conflict in Documentation/devicetree/bindings/mtd=
/atmel-nand.txt
Merging spi/spi/next (d8e328b spi: Add "spi:" prefix to modalias attribute =
of spi devices)
Merging tip/auto-latest (186b48f Merge branch 'linus')
CONFLICT (content): Merge conflict in mm/slub.c
CONFLICT (content): Merge conflict in mm/slab.c
CONFLICT (content): Merge conflict in kernel/fork.c
Merging rcu/rcu/next (392a5bf rcu: Fix broken strings in RCU's source code.)
Merging cputime/cputime (c3e0ef9 [S390] fix cputime overflow in uptime_proc=
_show)
Merging uprobes/for-next (0326f5a uprobes/core: Handle breakpoint and singl=
estep exceptions)
Merging kmemleak/kmemleak (4878677 kmemleak: do not leak object after tree =
insertion error)
Merging kvm/linux-next (21b26c0 KVM: s390: Fix sigp sense handling.)
CONFLICT (content): Merge conflict in arch/s390/kvm/sigp.c
CONFLICT (add/add): Merge conflict in arch/s390/include/asm/sigp.h
CONFLICT (content): Merge conflict in Documentation/virtual/kvm/api.txt
Merging kvm-ppc/kvm-ppc-next (be534e8 KVM: PPC: e500mc: Fix tlbilx emulatio=
n for 64-bit guests)
CONFLICT (content): Merge conflict in arch/powerpc/include/asm/hw_irq.h
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
Merging drivers-x86/linux-next (3fc1ae3 ACER: Add support for accelerometer=
 sensor)
Merging hwpoison/hwpoison (46e387b Merge branch 'hwpoison-hugepages' into h=
wpoison)
Merging sysctl/master (4e474a0 sysctl: protect poll() in entries that may g=
o away)
Merging regmap/for-next (dabefce Merge branch 'regmap-page' into regmap-nex=
t)
Merging hsi/for-next (43139a6 HSI: hsi_char: Update ioctl-number.txt)
Merging leds/for-next (e601507 leds: Use devm_kzalloc in leds-gpio.c file)
Merging driver-core/driver-core-next (6fbfd05 Merge v3.5-rc5 into driver-co=
re-next)
Merging tty/tty-next (0a44ab4 tty: note race we need to fix)
Merging usb/usb-next (ff9cce8 Merge tag 'xceiv-for-v3.6' of git://git.kerne=
l.org/pub/scm/linux/kernel/git/balbi/usb into usb-next)
CONFLICT (content): Merge conflict in drivers/usb/host/ehci-omap.c
Merging staging/staging-next (2da049b staging: gdm72xx: fix an skb memory l=
eak)
CONFLICT (content): Merge conflict in drivers/staging/gdm72xx/netlink_k.c
CONFLICT (content): Merge conflict in drivers/staging/comedi/drivers/s626.h
Merging char-misc/char-misc-next (726917f mei: revamp host buffer interface=
 function)
Merging tmem/linux-next (3bebf5b Merge branch 'stable/for-linus-3.6' into l=
inux-next)
Merging writeback/writeback-for-next (331cbde writeback: Fix some comment e=
rrors)
Merging arm-dt/devicetree/arm-next (ede338f dt: add documentation of ARM dt=
 boot interface)
Merging hwspinlock/linux-next (8b37fcf hwspinlock: add MAINTAINERS entries)
Merging pinctrl/for-next (3923040 pinctrl/nomadik: add spi2_oc1_2 pin group)
Merging moduleh/for-sfr (6b16351 Linux 3.5-rc4)
Merging vhost/linux-next (e0953c8 tun: experimental zero copy tx support)
Merging kmap_atomic/kmap_atomic (99921b7a pipe: remove KM_USER0 from commen=
ts)
Merging memblock/memblock-kill-early_node_map (7bd0b0f memblock: Reimplemen=
t memblock allocation using reverse free area iterator)
Merging remoteproc/for-next (b0d6bfb MAINTAINERS: add remoteproc's git)
CONFLICT (content): Merge conflict in drivers/remoteproc/remoteproc_core.c
Merging irqdomain/irqdomain/next (aed9804 irqdomain: Make ops->map hook opt=
ional)
Merging gpio/gpio/next (3e11f7b gpio/generic: initialize basic_mmio_gpio sh=
adow variables properly)
Merging gpio-lw/for-next (7aca21c Merge branch 'devel' into for-next)
$ git reset --hard HEAD^
Merging arm-soc/for-next (8249163 Merge branches 'fixes', 'next/fixes-non-c=
ritical', 'next/cleanup', 'next/soc', 'next/dt', 'next/defconfig', 'next/ir=
q', 'next/pinctrl', 'next/pm' and 'next/timer' into for-next)
Merging ep93xx/ep93xx-for-next (9b6a359 Merge branch 'ep93xx-fixes' into ep=
93xx-for-next)
Merging renesas/next (0030953 Merge branch 'renesas-sh7372' into renesas-ne=
xt)
Merging s5p/for-next (2e52959 Merge branches 'next/devel-samsung' and 'next=
/devel-dma-ops' into for-next)
Merging tegra/for-next (c520a4e Merge branch 'for-3.6/defconfig' into for-n=
ext)
Merging kvmtool/master (178bb52 kvm tool: Fix powerpc/kvm-cpu.c for new KVM=
_SET_ONE_REG API)
Merging dma-mapping/dma-mapping-next (b3d4597 ARM: dma-mapping: fix build b=
reak on no-MMU platform)
Merging pwm/for-next (401f7cc pwm: Convert pwm-samsung to use devm_* APIs)
CONFLICT (content): Merge conflict in drivers/pwm/pwm-samsung.c
CONFLICT (content): Merge conflict in arch/arm/plat-samsung/Makefile
CONFLICT (content): Merge conflict in arch/arm/mach-tegra/board-dt-tegra30.c
CONFLICT (content): Merge conflict in arch/arm/mach-tegra/board-dt-tegra20.c
Merging dma-buf/for-next (ca24a14 Merge branch 'fixes' of git://git.linaro.=
org/people/rmk/linux-arm)
Merging userns/for-next (491fa9e userns: Allow the usernamespace support to=
 build after the removal of usbfs)
Merging ktest/for-next (648a182 ktest: Allow a test to override REBOOT_ON_S=
UCCESS)
Merging signal/from-sfr (2e117f2 Revert "arm: pull all work_pending logics =
into C function")
CONFLICT (content): Merge conflict in arch/powerpc/kernel/entry_64.S
CONFLICT (content): Merge conflict in arch/arm/include/asm/thread_info.h
Merging clk/clk-next (ccc96f1 clk: Add CLK_IS_BASIC flag to identify basic =
clocks)
Merging random/dev (0ca6c54 MAINTAINERS: Theodore Ts'o is taking over the r=
andom driver)
Merging scsi-post-merge/merge-base:master ()
$ git checkout akpm
Applying: selinux: fix something
Applying: memory hotplug: fix invalid memory access caused by stale kswapd =
pointer
Applying: memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-p=
ointer-fix
Applying: drivers/rtc/rtc-spear.c: fix use-after-free in spear_rtc_remove()
Applying: mn10300: move setup_jiffies_interrupt() to cevt-mn10300.c
Applying: mn10300: remove duplicate definition of PTRACE_O_TRACESYSGOOD
Applying: mn10300: kernel/internal.h needs <linux/irqreturn.h>
Applying: mn10300: kernel/traps.c needs <linux/export.h>
Applying: mn10300: mm/dma-alloc.c needs <linux/export.h>
Applying: mn10300: use "#elif defined(CONFIG_*)" instead of "#elif CONFIG_*"
Applying: ocfs2: fix NULL pointer dereference in __ocfs2_change_file_space()
Applying: c/r: prctl: less paranoid prctl_set_mm_exe_file()
Applying: drivers/gpio/devres.c: export devm_gpio_request_one() to modules
Applying: mm, thp: abort compaction if migration page cannot be charged to =
memcg
Applying: drivers/rtc/rtc-ab8500.c: use IRQF_ONESHOT when requesting a thre=
aded IRQ
Applying: drivers/rtc/rtc-ab8500.c: ensure correct probing of the AB8500 RT=
C when Device Tree is enabled
Applying: rtc-ensure-correct-probing-of-the-ab8500-rtc-when-device-tree-is-=
enabled-checkpatch-fixes
Applying: mm: fix goal calculating with usemap
Applying: h8300/pgtable: add missing #include <asm-generic/pgtable.h>
Applying: h8300/signal: fix typo "statis"
Applying: h8300/time: add missing #include <asm/irq_regs.h>
Applying: h8300/uaccess: remove assignment to __gu_val in unhandled case of=
 get_user()
Applying: h8300/uaccess: add mising __clear_user()
Applying: mm/memory_hotplug.c: release memory resources if hotadd_new_pgdat=
() fails
Applying: drivers/rtc/rtc-mxc.c: fix irq enabled interrupts warning
Applying: fs: ramfs: file-nommu: add SetPageUptodate()
Applying: sgi-xp: nested calls to spin_lock_irqsave()
Applying: MAINTAINERS: add OMAP CPUfreq driver to OMAP Power Management sec=
tion
Applying: memblock: free allocated memblock_reserved_regions later
Applying: fat: fix non-atomic NFS i_pos read
Applying: cciss: fix incorrect scsi status reporting
Applying: arch/x86/platform/iris/iris.c: register a platform device and a p=
latform driver
Applying: arch/x86/include/asm/spinlock.h: fix comment
Applying: arch/x86/kernel/cpu/perf_event_intel_uncore.h: make UNCORE_PMU_HR=
TIMER_INTERVAL 64-bit
Applying: prctl: remove redunant assignment of "error" to zero
Applying: timeconst.pl: remove deprecated defined(@array)
Applying: time: don't inline EXPORT_SYMBOL functions
Applying: include/linux/time.h: make NSEC_PER_SEC 64-bit on 32-bit architec=
tures
Applying: include-linux-timeh-make-nsec_per_sec-64-bit-on-32-bit-architectu=
res-fix
Applying: include-linux-timeh-make-nsec_per_sec-64-bit-on-32-bit-architectu=
res-fix-fix
Applying: include-linux-timeh-make-nsec_per_sec-64-bit-on-32-bit-architectu=
res-fix-fix-fix
Applying: include-linux-timeh-make-nsec_per_sec-64-bit-on-32-bit-architectu=
res-fix-fix-fix-fix
Applying: thermal: fix potential out-of-bounds memory access
Applying: ocfs2: use find_last_bit()
Applying: ocfs2: use bitmap_weight()
Applying: drivers/scsi/ufs: use module_pci_driver
Applying: drivers/scsi/ufs: reverse the ufshcd_is_device_present logic
Applying: drivers/scsi/ufs: fix incorrect return value about SUCCESS and FA=
ILED
Applying: drivers/scsi/atp870u.c: fix bad use of udelay
Applying: vfs: increment iversion when a file is truncated
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
Applying: fs: add link restrictions
Applying: fs: add link restriction audit reporting
Applying: fs: make dumpable=3D2 require fully qualified path
Applying: coredump: warn about unsafe suid_dumpable / core_pattern combo
Applying: xtensa/mm/fault.c: port OOM changes to do_page_fault
Applying: mm/slab: remove duplicate check
Applying: slab: do not call compound_head() in page_get_cache()
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
Applying: mm-hugetlb-add-new-hugetlb-cgroup-fix
Applying: mm-hugetlb-add-new-hugetlb-cgroup-fix-fix
Applying: hugetlb/cgroup: remove unnecessary NULL checks
Applying: hugetlb/cgroup: Mark root_h_cgroup static
Applying: hugetlb/cgroup: add the cgroup pointer to page lru
Applying: hugetlb/cgroup: add charge/uncharge routines for hugetlb cgroup
Applying: hugetlb/cgroup: Remove unnecessary NULL checks
Applying: hugetlb/cgroup: add support for cgroup removal
Applying: hugetlb/cgroup: add hugetlb cgroup control files
Applying: hugetlb-cgroup-add-hugetlb-cgroup-control-files-fix
Applying: hugetlb-cgroup-add-hugetlb-cgroup-control-files-fix-fix
Applying: hugetlb/cgroup: migrate hugetlb cgroup info from oldpage to new p=
age during migration
Applying: hugetlb/cgroup: add HugeTLB controller documentation
Applying: hugetlb: move all the in use pages to active list
Applying: hugetlb/cgroup: assign the page hugetlb cgroup when we move the p=
age to active list.
Applying: hugetlb/cgroup: remove exclude and wakeup rmdir calls from migrate
Applying: mm, oom: do not schedule if current has been killed
Applying: mm/memblock.c:memblock_double_array(): cosmetic cleanups
Applying: memcg: remove check for signal_pending() during rmdir()
Applying: memcg: clean up force_empty_list() return value check
Applying: memcg: mem_cgroup_move_parent() doesn't need gfp_mask
Applying: memcg: make mem_cgroup_force_empty_list() return bool
Applying: memcg-make-mem_cgroup_force_empty_list-return-bool-fix
Applying: mm/compaction: cleanup on compaction_deferred
Applying: memcg: prevent OOM with too many dirty pages
Applying: mm, fadvise: don't return -EINVAL when filesystem cannot implemen=
t fadvise()
Applying: mm-fadvise-dont-return-einval-when-filesystem-cannot-implement-fa=
dvise-checkpatch-fixes
Applying: mm: clear pages_scanned only if draining a pcp adds pages to the =
buddy allocator again
Applying: mm, oom: fix potential killing of thread that is disabled from oo=
m killing
Applying: mm, oom: replace some information in tasklist dump
Applying: mm: do not use page_count() without a page pin
Applying: mm: clean up __count_immobile_pages()
Applying: memcg: rename config variables
Applying: memcg-rename-config-variables-fix
Applying: memcg-rename-config-variables-fix-fix
Applying: mm: remove unused LRU_ALL_EVICTABLE
Applying: memcg: fix bad behavior in use_hierarchy file
Applying: memcg: rename mem_control_xxx to memcg_xxx
Applying: mm: have order > 0 compaction start off where it left
Applying: mm-have-order-0-compaction-start-off-where-it-left-checkpatch-fix=
es
Applying: mm: CONFIG_HAVE_MEMBLOCK_NODE -> CONFIG_HAVE_MEMBLOCK_NODE_MAP
Applying: vmscan: remove obsolete shrink_control comment
Applying: mm/memory.c:print_vma_addr(): call up_read(&mm->mmap_sem) directly
Applying: tmpfs: implement NUMA node interleaving
Applying: tmpfs-implement-numa-node-interleaving-fix
Applying: isolate_freepages: check that high_pfn is aligned as expected
Applying: frv: kill used but uninitialized variable
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
Applying: arch/arm/mach-netx/fb.c: reuse dummy clk routines for CONFIG_HAVE=
_CLK=3Dn
Applying: clk: validate pointer in __clk_disable()
Applying: panic: fix a possible deadlock in panic()
Applying: NMI watchdog: fix for lockup detector breakage on resume
Applying: kmsg: /dev/kmsg - properly return possible copy_from_user() failu=
re
Applying: printk: add generic functions to find KERN_<LEVEL> headers
Applying: printk-add-generic-functions-to-find-kern_level-headers-fix
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
Applying: Documentation/printk-formats.txt: add description for %pMR
Applying: lib/vsprintf.c: remind people to update Documentation/printk-form=
ats.txt when adding printk formats
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
Applying: string: introduce memweight()
Applying: string-introduce-memweight-fix
Applying: string: fix build error caused by memweight() introduction
Applying: qnx4fs: use memweight()
Applying: dm: use memweight()
Applying: affs: use memweight()
Applying: video/uvc: use memweight()
Applying: ocfs2: use memweight()
Applying: ext2: use memweight()
Applying: ext3: use memweight()
Applying: ext4: use memweight()
Applying: checkpatch: Update alignment check
Applying: checkpatch: test for non-standard signatures
Applying: checkpatch: check usleep_range() arguments
Applying: drivers/rtc/rtc-coh901331.c: use clk_prepare/unprepare
Applying: drivers/rtc/rtc-coh901331.c: use devm allocation
Applying: rtc: pl031: encapsulate per-vendor ops
Applying: rtc: pl031: use per-vendor variables for special init
Applying: rtc: pl031: fix up IRQ flags
Applying: drivers/rtc/rtc-ab8500.c: use UIE emulation
Applying: drivers-rtc-rtc-ab8500c-use-uie-emulation-checkpatch-fixes
Applying: drivers/rtc/rtc-ab8500.c: remove fix for AB8500 ED version
Applying: drivers/rtc/rtc-r9701.c: avoid second call to rtc_valid_tm()
Applying: drivers/rtc/rtc-r9701.c: check that r9701_set_datetime() succeeded
Applying: hfsplus: use -ENOMEM when kzalloc() fails
Applying: hfsplus: make hfsplus_sync_fs() static
Applying: hfsplus: amend debugging print
Applying: hfsplus: remove useless check
Applying: hfsplus: get rid of write_super
Applying: hfsplus-get-rid-of-write_super-checkpatch-fixes
Applying: fat: accessors for msdos_dir_entry 'start' fields
Applying: kmod: avoid deadlock from recursive kmod call
Applying: fork: use vma_pages() to simplify the code
Applying: fork-use-vma_pages-to-simplify-the-code-fix
Applying: ipc/sem.c: alternatives to preempt_disable()
Applying: fs: cachefiles: add support for large files in filesystem caching
Applying: fs-cachefiles-add-support-for-large-files-in-filesystem-caching-f=
ix
Applying: include/linux/aio.h: cpp->C conversions
CONFLICT (content): Merge conflict in include/linux/aio.h
Applying: c/r: fcntl: add F_GETOWNER_UIDS option
Merging quilt/akpm (dece410 c/r: fcntl: add F_GETOWNER_UIDS option)

--Signature=_Fri__6_Jul_2012_17_20_05_+1000_VDUg_d3e7+Piw1kK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP9pGlAAoJEECxmPOUX5FEQ8MP/1RMhD2Z0Y8ila8N175LK+zd
kzH/OUXHk36A7mJuq1yZk0uMNQbfSpQi6zJ12gJ7+aZVK+CYAZx7Zl9dPbjVYYnR
Rmufa1acIXi6a/+HWyhSTWqEXlgrBLKJacf45PbwHafloIDufJ9tgfqKt5i0HfEK
iOHJjnqyhSmSo+XX8maURCkhMebyZAr/FrWixNHHNHD5uc3pBbno2cNteZcLnd3u
C8RFfqU1kxk1GRrMKY7Zz2/jeLzpgKSb5NjDBCgs8tUkjD9yfRTwCVtg6zaC77OF
u681lQuWQ0mXTkKlji9vOz6nvKLs9E+d8MBsdsQNYDrXF4YtI6qqQu9ka6nxrIXi
71+4Bxq4mQbJffJJIqpQixrckT485HRs1JDL/QW6K3o7WxrD+k8NFvbiajRNBqg0
mn0ze02XhSZJDTvgCQ2XkRYRJ0ofN4ouWg/xQ48Kr3hBR+xzo0VpeuifaKzQOvDW
J6VNDp/kwAh8ZZ2+oQJ6FqQJ1fbntZUhMx07yKON6cWpAmObABR3E9Dn/vEbJgvc
0X+1BP5m0YWjOCODS/Ff2Teo5aS4RxlbepzAybtpHrzt9fJ6HvPCI7jf86uOypqP
/AQJfyQZn9mh4stDNudgsvJgYvGExKaLZmpldhCnlPsfU3qqpssmPnQVk/HXRNJp
fioOXV7N/TFlArKCkiL4
=3GDa
-----END PGP SIGNATURE-----

--Signature=_Fri__6_Jul_2012_17_20_05_+1000_VDUg_d3e7+Piw1kK--

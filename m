Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758866Ab2EKG14 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 02:27:56 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:54796 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758808Ab2EKG1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 02:27:48 -0400
Date: Fri, 11 May 2012 16:27:38 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for May 11
Message-Id: <20120511162738.1d65b6efe099a54841be6313@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__11_May_2012_16_27_38_+1000_g2.iGyqYo+vR3INZ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__11_May_2012_16_27_38_+1000_g2.iGyqYo+vR3INZ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 201205010:

The xfs tree lost its build failure.

The sound-asoc tree lost its build failure.

The battery tree still had its build failure for which I reverted 2
commits.

The staging tree gained a conflict against the usb tree.

The akpm tree lost a few patches that turned up elsewhere and gained a
build failure for which I reverted a commit.

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

We are up to 190 trees (counting Linus' and 27 trees of patches pending
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
Merging origin/master (d60b9c1 Merge branch 'parisc' (PA-RISC compile fixes=
))
Merging fixes/master (b1a808f Merge branch 'for-next' of git://gitorious.or=
g/kernel-hsi/kernel-hsi)
Merging kbuild-current/rc-fixes (e88aa7b Fix modpost failures in fedora 17)
Merging arm-current/fixes (fde165b ARM: 7414/1: SMP: prevent use of the con=
sole when using idmap_pgd)
Merging ep93xx-current/ep93xx-fixes (2b3c83e dmaengine/ep93xx_dma: Implemen=
t double buffering for M2M DMA channels)
Merging m68k-current/for-linus (450aed7 m68k/q40: Add missing platform chec=
k before registering platform devices)
Merging powerpc-merge/merge (a3512b2 powerpc/irq: Make alignment & program =
interrupt behave the same)
Merging sparc/master (a5a737e sparc64: Do not clobber %g2 in xcall_fetch_gl=
ob_regs().)
Merging net/master (0e0c551 Merge branch 'sfc-3.4' of git://git.kernel.org/=
pub/scm/linux/kernel/git/bwh/sfc)
Merging sound-current/for-linus (9ea3356 Merge tag 'asoc-3.4' of git://git.=
kernel.org/pub/scm/linux/kernel/git/broonie/sound into for-linus)
Merging pci-current/for-linus (314489b Merge tag 'fixes-for-linus' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc)
Merging wireless/master (ed90542 iwlwifi: fix skb truesize underestimation)
Merging driver-core.current/driver-core-linus (69964ea Linux 3.4-rc5)
Merging tty.current/tty-linus (d48b97b Linux 3.4-rc6)
Merging usb.current/usb-linus (d48b97b Linux 3.4-rc6)
Merging staging.current/staging-linus (69964ea Linux 3.4-rc5)
Merging char-misc.current/char-misc-linus (e816b57 Linux 3.4-rc3)
Merging cpufreq-current/fixes (6139b65 Merge branch 'for_3.4/cpufreq' of gi=
t://git.kernel.org/pub/scm/linux/kernel/git/khilman/linux-omap-pm into fixe=
s)
Merging input-current/for-linus (899c612 Input: synaptics - fix regression =
with "image sensor" trackpads)
Merging md-current/for-linus (b16b1b6 md/bitmap: fix calculation of 'chunks=
' - missing shift.)
Merging audit-current/for-linus (c158a35 audit: no leading space in audit_l=
og_d_path prefix)
Merging crypto-current/master (511d63c crypto: talitos - properly lock acce=
ss to global talitos registers)
Merging ide/master (0ab3d8b cy82c693: fix PCI device selection)
Merging dwmw2/master (244dc4e Merge git://git.infradead.org/users/dwmw2/ran=
dom-2.6)
Merging sh-current/sh-fixes-for-linus (3c3c801 Merge branch 'sh/urgent' int=
o sh-fixes-for-linus)
Merging irqdomain-current/irqdomain/merge (15e06bf irqdomain: Fix debugfs f=
ormatting)
Merging devicetree-current/devicetree/merge (766644d of/irq: add empty irq_=
of_parse_and_map() for non-dt builds)
Merging spi-current/spi/merge (ba2092c spi/topcliff: use correct __devexit_=
p annotation)
Merging gpio-current/gpio/merge (9a5c7d6 gpio/exynos: Fix compiler warning =
in gpio-samsung.c file)
Merging arm/for-next (3d7af9c Merge branch 'v3-removal' into for-next)
Merging arm-perf/for-next/perf (c16fa4f Linux 3.3)
Merging davinci/davinci-next (fe0d422 Linux 3.0-rc6)
Merging renesas/next (5658c94 Merge branch 'renesas-kzm9g' into renesas-soc=
-new)
Merging samsung/next-samsung (9edb240 ARM: H1940/RX1950: Change default LED=
 triggers)
Merging s5p/for-next (de12e47 Merge branch 'next/board-samsung' into for-ne=
xt)
Merging xilinx/arm-next (b85a3ef ARM: Xilinx: Adding Xilinx board support)
Merging blackfin/for-linus (431e69e blackfin: asm: fix blackfin.h broken)
Merging c6x/for-linux-next (18d1470 C6X: change main arch kbuild symbol)
Merging cris/for-next (7b91747 cris: Remove old legacy "-traditional" flag =
from arch-v10/lib/Makefile)
Merging hexagon/linux-next (4bd8193 various Kconfig cleanup and old platfor=
m build code removal)
Merging ia64/next (16f2634 [IA64] Normalize return value of chip->irq_set_a=
ffinity() method)
Merging m68k/for-next (c663600 m68k: Correct the Atari ALLOWINT definition)
Merging m68knommu/for-next (dc19103 m68k: merge the MMU and non-MMU version=
s of the arch dma code)
Merging microblaze/next (258f742 modpost: Fix modpost license checking of v=
mlinux.o)
Merging mips/mips-for-linux-next (d175dcf Merge branches 'fixes-for-linus',=
 'module.h-fixes', 'next/ath79' and 'next/lantiq' into mips-for-linux-next)
Merging openrisc/for-upstream (207e715 openrisc: use scratch regs in atomic=
 syscall)
Merging parisc/for-next (c60dc74 Merge branch 'fixes' into for-next)
Merging powerpc/next (b48d441 Merge remote-tracking branch 'jwb/next' into =
next)
Merging 4xx/next (dce4c92 powerpc/40x: Use {upper,lower}_32_bits for msi_ph=
ys)
Merging mpc5xxx/next (09f61ff powerpc: Option FB_FSL_DIU is not really opti=
onal for mpc512x)
Merging galak/next (fa1b42b powerpc/qe: Update the SNUM table for MPC8569 R=
ev2.0)
Merging s390/features (676d1a4 s390/pfault: add sanity check)
Merging sh/sh-latest (c4f10e5 sh: Fix up comment noise in sh7269 pinmux cod=
e.)
Merging sparc-next/master (aa6f079 sparc: fix build fail in mm/init_64.c wh=
en NEED_MULTIPLE_NODES is off)
Merging tile/master (5e4ce7a arch/tile: tilegx PCI root complex support)
Merging unicore32/unicore32 (0994695 Merge branch 'akpm' (aka "Andrew's pat=
ch-bomb, take two"))
Merging ceph/master (8b39326 crush: warn on do_rule failure)
Merging cifs/for-next (d49b0c3 cifs: add a deprecation warning to CIFS_IOC_=
CHECKUMOUNT ioctl)
Merging configfs/linux-next (b930c26 Merge branch 'for-linus' of git://git.=
kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (6cfd4b4 ecryptfs: remove the second argument of k[un=
]map_atomic())
CONFLICT (content): Merge conflict in fs/ecryptfs/ecryptfs_kernel.h
Merging ext3/for_next (77f0a97 jbd: Write journal superblock with WRITE_FUA=
 after checkpointing)
Merging ext4/dev (f1d470b ext4: add metadata checksumming to the list of su=
pported features)
Merging fuse/for-next (519c604 fuse: optimize fallocate on permanent failur=
e)
Merging gfs2/master (6de1e2f GFS2: Remove redundant metadata block type che=
ck)
Merging logfs/master (cd8bfa9 logfs: initialize the number of iovecs in bio)
Merging nfs/linux-next (1e1c7f2 Merge branch 'devel' into linux-next)
Merging nfsd/nfsd-next (1969c7c LockD: add debug message to start and stop =
functions)
Merging ocfs2/linux-next (9392557 ocfs2: avoid unaligned access to dqc_bitm=
ap)
Merging omfs/for-next (976d167 Linux 3.1-rc9)
Merging squashfs/master (4b0180a Squashfs: add mount time sanity check for =
block_size and block_log match)
Merging v9fs/for-next (01627d9 Merge branch 'drm-fixes-intel' of git://peop=
le.freedesktop.org/~airlied/linux)
Merging ubifs/linux-next (1bdcc63 UBIFS: remove xattr Kconnfig option)
Merging xfs/for-next (821c444 xfs: make xfs_extent_busy_trim not static)
Merging vfs/for-next (9448152 sch_atm.c: get rid of poinless extern)
Merging pci/next (74d24b2 resources: add resource_overlaps())
Merging hid/for-next (0b63659 Merge branch 'multitouch' into for-next)
Merging quilt/i2c (f7c1584 i2c: Split I2C_M_NOSTART support out of I2C_FUNC=
_PROTOCOL_MANGLING)
Merging bjdooks-i2c/next-i2c (fc84fe1 Merge branch 'for_3.3/i2c/misc' of gi=
t://git.kernel.org/pub/scm/linux/kernel/git/khilman/linux-omap-pm into for-=
33/i2c/omap)
CONFLICT (content): Merge conflict in drivers/i2c/busses/i2c-omap.c
Merging i2c-embedded/i2c-embedded/for-next (b5a9352 I2C: xiic: Add OF bindi=
ng support)
Merging quilt/jdelvare-hwmon (e3a9568 hwmon: Add MCP3021 ADC driver)
Merging hwmon-staging/hwmon-next (6112588 hwmon: (ad7314) Remove unused def=
ines, and rename OFFSET to SHIFT)
Merging v4l-dvb/master (49083a0 Merge /home/v4l/v4l/for_upstream)
CONFLICT (content): Merge conflict in drivers/usb/gadget/uvc_queue.c
Merging kbuild/for-next (7eb095a Merge branch 'kbuild/kbuild' into kbuild/f=
or-next)
Merging kconfig/for-next (eae1c36 Merge branch 'kconfig/for-linus-2' into k=
config/for-next)
Merging libata/NEXT (8d899e7 libata-eh don't waste time retrying media erro=
rs (v3))
Merging infiniband/for-next (bf92d23 Merge tag 'v3.4-rc6' into for-next)
Merging acpi/next (29bdc67 Merge branch 'pss-workaround' into next)
Merging cpupowerutils/master (f166033 cpupower tools: add install target to=
 the debug tools' makefiles)
Merging ieee1394/for-next (8527f8e firewire: core: fw_device_refresh(): cle=
an up error handling)
Merging ubi/linux-next (5db60d4 UBI: remove superfluous "!!" operation)
Merging dlm/next (1a058f5 gfs2: fix recovery during unmount)
Merging scsi/for-next (c2ca01e Merge branch 'misc' into for-next)
Merging target-updates/for-next (11e764b target: Remove max_sectors device =
attribute for modern se_task less code)
Merging target-merge/for-next-merge (6222de5 Merge branch 'qla-target-merge=
' into for-next-merge)
Merging ibft/linux-next (935a9fe ibft: Fix finding IBFT ACPI table on UEFI)
Merging isci/all (5d8f50d merge: devel rnc-devel fixes)
Merging slave-dma/next (56cbb3d Merge branch 'fixes' into next)
Merging dmaengine/next (a2bd114 netdma: adding alignment check for NETDMA o=
ps)
Merging net-next/master (8feedbb dsa: Convert compare_ether_addr to ether_a=
ddr_equal)
CONFLICT (content): Merge conflict in net/ceph/osdmap.c
CONFLICT (content): Merge conflict in drivers/net/ethernet/emulex/benet/be.h
Merging wireless-next/master (341352d iwlwifi: fix-up some merge damage fro=
m commit 0d6c4a2)
Merging bluetooth/master (53168e5 Bluetooth: Fixed checkpatch warnings)
Merging mtd/master (b027274 mtd: ams-delta: fix request_mem_region() failur=
e)
Merging l2-mtd/master (3ba1a21 jffs2: get rid of jffs2_sync_super)
Merging crypto/master (8a63b19 crypto: ux500 - Add driver for HASH hardware)
Merging sound/for-next (3e508fa Merge branch 'topic/hda' into for-next)
Merging sound-asoc/for-next (44edda7 Merge branch 'for-3.5' into asoc-next)
CONFLICT (content): Merge conflict in drivers/base/regmap/regmap.c
Merging cpufreq/next (a7b422c provide disable_cpufreq() function to disable=
 the API.)
Merging quilt/rr (f20fa7b brlocks/lglocks: turn into functions)
Merging input/next (06e7df9 Input: sentelic - report device's production se=
rial number)
Merging input-mt/for-next (66f75a5 Linux 3.4-rc4)
Merging cgroup/for-next (0d4dde1 res_counter: Account max_usage when callin=
g res_counter_charge_nofail())
CONFLICT (content): Merge conflict in Documentation/feature-removal-schedul=
e.txt
Merging block/for-next (d634e66 Merge branch 'for-3.5/core' into for-next)
CONFLICT (content): Merge conflict in Documentation/feature-removal-schedul=
e.txt
Merging quilt/device-mapper (0f7a379 After the failure of a group of paths,=
 any alternative paths that need initialising do not become available until=
 further I/O is sent to the device.  Until this has happened, ioctls return=
 -EAGAIN.)
Merging embedded/master (4744b43 embedded: fix vc_translate operator preced=
ence)
Merging firmware/master (6e03a20 firmware: speed up request_firmware(), v3)
Merging pcmcia/master (80af9e6 pcmcia at91_cf: fix raw gpio number usage)
Merging mmc/mmc-next (f6f4459 mmc: core: Remove dead code)
Merging kgdb/kgdb-next (3751d3e x86,kgdb: Fix DEBUG_RODATA limitation using=
 text_poke())
Merging slab/for-next (b80b6c0 Merge branch 'slab/next' into for-next)
Merging uclinux/for-next (5e442a4 Revert "proc: fix races against execve() =
of /proc/PID/fd**")
Merging md/for-next (b842a91 MD RAID1: Further conditionalize 'fullsync')
Merging mfd/for-next (5af7df6 mfd: Add regulator support for twl6040 VIO, V=
2V1 supplies)
Merging battery/master (fcc015c smb347-charger: Clean up battery attributes)
[master c101279] Revert "smb347-charger: Clean up battery attributes"
[master d8b3f64] Revert "smb347-charger: Convert to regmap API"
Merging drm/drm-next (d3029b4 drm/radeon/kms: fix warning on 32-bit in atom=
ic fence printing)
CONFLICT (content): Merge conflict in drivers/gpu/drm/gma500/psb_drv.c
Merging fbdev/fbdev-next (113b668 video: EXYNOS: enable interrupt again aft=
er sw reset)
Merging viafb/viafb-next (838ac78 viafb: avoid refresh and mode lookup in s=
et_par)
Merging omap_dss2/for-next (1dfafbc Merge branch 'archit/set-timing-work')
Merging regulator/for-next (777e1f9 Merge branch 'regulator-regmap' into re=
gulator-next)
Merging security/next (898bfc1 Merge tag 'v3.4-rc5' into next)
CONFLICT (content): Merge conflict in include/linux/filter.h
CONFLICT (content): Merge conflict in arch/x86/Kconfig
Merging selinux/master (c737f82 SELinux: remove unused common_audit_data in=
 flush_unauthorized_files)
Merging lblnet/master (7e27d6e Linux 2.6.35-rc3)
Merging watchdog/master (ef816b3 watchdog: Add watchdog driver for Intel At=
om E6XX)
Merging dwmw2-iommu/master (c3b92c8 Linux 3.1)
Merging iommu/next (7aff2d0 Merge branches 'iommu/fixes', 'dma-debug', 'arm=
/omap' and 'arm/tegra' into next)
Merging osd/linux-next (72749a2 exofs: Cap on the memcpy() size)
Merging jc_docs/docs-next (5c050fb docs: update the development process doc=
ument)
Merging trivial/for-next (c0a788c net: Fix tcp_build_and_update_options com=
ment in struct tcp_sock)
CONFLICT (modify/delete): sound/soc/imx/Kconfig deleted in HEAD and modifie=
d in trivial/for-next. Version trivial/for-next of sound/soc/imx/Kconfig le=
ft in tree.
$ git rm -f sound/soc/imx/Kconfig
Merging audit/for-next (dcd6c92 Linux 3.3-rc1)
Merging pm/linux-next (1fb9873 PM / Domains: Fix computation of maximum dom=
ain off time)
Merging apm/for-next (f283d22 APM: fix deadlock in APM_IOC_SUSPEND ioctl)
Merging fsnotify/for-next (1aec9c0 inotify: automatically restart syscalls)
Merging edac/linux_next (a4b4be3 edac: rename channel_info to rank_info)
Merging edac-amd/for-next (305f1c3 Merge branch '3.3-pci_device_id' into ed=
ac-for-next)
Merging devicetree/devicetree/next (0f22dd3 of: Only compile OF_DYNAMIC on =
PowerPC pseries and iseries)
Merging spi/spi/next (6d6467e spi/ep93xx: clean probe/remove routines)
Merging tip/auto-latest (9a32c60 Merge branch 'perf/urgent')
CONFLICT (content): Merge conflict in arch/x86/Kconfig
CONFLICT (content): Merge conflict in arch/sparc/Kconfig
CONFLICT (content): Merge conflict in arch/hexagon/Kconfig
CONFLICT (content): Merge conflict in Makefile
Applying: kbuild: merge fix for sorting exceptions tables at build time
Merging rcu/rcu/next (2c72556 Merge branches 'barrier.2012.05.09a', 'fixes.=
2012.04.26a', 'inline.2012.05.02b' and 'srcu.2012.05.07a' into dev3.5.2012.=
05.09a)
Merging cputime/cputime (c3e0ef9 [S390] fix cputime overflow in uptime_proc=
_show)
Merging uprobes/for-next (0326f5a uprobes/core: Handle breakpoint and singl=
estep exceptions)
Merging kmemleak/kmemleak (4878677 kmemleak: do not leak object after tree =
insertion error)
Merging kvm/linux-next (f256905 Merge branch 'for-upstream' of git://github=
.com/agraf/linux-2.6 into next)
CONFLICT (content): Merge conflict in Documentation/feature-removal-schedul=
e.txt
Merging kvm-ppc/kvm-ppc-next (878095d KVM: PPC: Factor out guest epapr init=
ialization)
Merging oprofile/for-next (c16fa4f Linux 3.3)
Merging xen/upstream/xen (af3a3ab Merge git://git.kernel.org/pub/scm/linux/=
kernel/git/steve/gfs2-3.0-fixes)
Merging xen-two/linux-next (bdb1a8b Revert "xen: EXPORT_SYMBOL set_phys_to_=
machine")
Merging xen-pvhvm/linux-next (b056b6a xen: suspend: remove xen_hvm_suspend)
Merging percpu/for-next (100d13c kmemleak: Fix the kmemleak tracking of the=
 percpu areas with !SMP)
Merging workqueues/for-next (0976dfc workqueue: Catch more locking problems=
 with flush_work())
Merging drivers-x86/linux-next (ad229c5 toshiba_acpi: Add support for trans=
flective LCD)
Merging hwpoison/hwpoison (46e387b Merge branch 'hwpoison-hugepages' into h=
wpoison)
Merging sysctl/master (4e474a0 sysctl: protect poll() in entries that may g=
o away)
Merging regmap/for-next (8ee09ac Merge tag 'regmap-3.4' into regmap-next)
CONFLICT (content): Merge conflict in drivers/base/regmap/regmap.c
CONFLICT (content): Merge conflict in drivers/base/regmap/internal.h
Merging hsi/for-next (43139a6 HSI: hsi_char: Update ioctl-number.txt)
Merging driver-core/driver-core-next (f8450fc printk: correctly align __log=
_buf)
Merging tty/tty-next (1541f84 tty: move global ldisc idle waitqueue to the =
individual ldisc)
Merging usb/usb-next (d530296 USB: serial: opticon: hook up suspend/resume =
callbacks)
CONFLICT (modify/delete): drivers/usb/core/inode.c deleted in usb/usb-next =
and modified in HEAD. Version HEAD of drivers/usb/core/inode.c left in tree.
CONFLICT (content): Merge conflict in drivers/input/tablet/wacom_wac.c
$ git rm -f drivers/usb/core/inode.c
Merging staging/staging-next (e7f3eb0 staging: android: logger: Fix some sp=
arse and whitespace issues)
CONFLICT (modify/delete): drivers/staging/serial/68360serial.c deleted in s=
taging/staging-next and modified in HEAD. Version HEAD of drivers/staging/s=
erial/68360serial.c left in tree.
CONFLICT (modify/delete): drivers/staging/quatech_usb2/quatech_usb2.c delet=
ed in HEAD and modified in staging/staging-next. Version staging/staging-ne=
xt of drivers/staging/quatech_usb2/quatech_usb2.c left in tree.
CONFLICT (content): Merge conflict in drivers/staging/line6/driver.c
CONFLICT (content): Merge conflict in drivers/staging/android/Makefile
CONFLICT (content): Merge conflict in drivers/staging/android/Kconfig
CONFLICT (content): Merge conflict in drivers/misc/Makefile
CONFLICT (content): Merge conflict in drivers/Makefile
CONFLICT (content): Merge conflict in drivers/Kconfig
$ git rm -f drivers/staging/serial/68360serial.c drivers/staging/quatech_us=
b2/quatech_usb2.c
Merging char-misc/char-misc-next (9912143 parport: remove unused dead code =
from lowlevel drivers)
CONFLICT (content): Merge conflict in drivers/extcon/extcon-max8997.c
Merging tmem/linux-next (0f1ea93 Merge branch 'stable/frontswap.v14' into l=
inux-next)
Merging writeback/writeback-for-next (169ebd9 writeback: Avoid iput() from =
flusher thread)
Merging arm-dt/devicetree/arm-next (ede338f dt: add documentation of ARM dt=
 boot interface)
Merging hwspinlock/linux-next (8b37fcf hwspinlock: add MAINTAINERS entries)
Merging pinctrl/for-next (c7eea50 pinctrl: (cosmetic) fix two entries in Do=
cBook comments)
CONFLICT (content): Merge conflict in drivers/pinctrl/core.c
CONFLICT (content): Merge conflict in Documentation/driver-model/devres.txt
Merging tegra/for-next (7043e30 Merge branch 'for-3.5/ahb' into for-next)
Merging moduleh/for-sfr (d48b97b Linux 3.4-rc6)
Merging vhost/linux-next (53ffd22 virtio-net: remove useless disable on fre=
eze)
CONFLICT (content): Merge conflict in drivers/net/virtio_net.c
Merging kmap_atomic/kmap_atomic (317b6e1 feature-removal-schedule.txt: sche=
dule the deprecated form of kmap_atomic() for removal)
Merging modem-shm/for-next (3cff1cc caif_shm: Add CAIF driver for Shared me=
mory for M7400)
CONFLICT (content): Merge conflict in drivers/Kconfig
Merging memblock/memblock-kill-early_node_map (7bd0b0f memblock: Reimplemen=
t memblock allocation using reverse free area iterator)
Merging remoteproc/for-next (e12bc14 remoteproc: s/big switch/lookup table/)
Merging irqdomain/irqdomain/next (e7cc3ac dt: fix twl4030 for non-dt compil=
e on x86)
Merging gpio/gpio/next (f141ed6 gpio: Move DT support code into drivers/gpi=
o)
Merging arm-soc/for-next (8c86c00 Merge branch 'depends/rmk/clkdev' into fo=
r-next)
CONFLICT (content): Merge conflict in lib/Makefile
CONFLICT (modify/delete): drivers/mfd/ab5500-core.c deleted in arm-soc/for-=
next and modified in HEAD. Version HEAD of drivers/mfd/ab5500-core.c left i=
n tree.
CONFLICT (content): Merge conflict in drivers/char/hw_random/Kconfig
CONFLICT (content): Merge conflict in arch/arm/mach-lpc32xx/common.c
CONFLICT (modify/delete): arch/arm/mach-ixp23xx/roadrunner.c deleted in arm=
-soc/for-next and modified in HEAD. Version HEAD of arch/arm/mach-ixp23xx/r=
oadrunner.c left in tree.
CONFLICT (modify/delete): arch/arm/mach-ixp23xx/pci.c deleted in arm-soc/fo=
r-next and modified in HEAD. Version HEAD of arch/arm/mach-ixp23xx/pci.c le=
ft in tree.
CONFLICT (modify/delete): arch/arm/mach-ixp23xx/ixdp2351.c deleted in arm-s=
oc/for-next and modified in HEAD. Version HEAD of arch/arm/mach-ixp23xx/ixd=
p2351.c left in tree.
CONFLICT (modify/delete): arch/arm/mach-ixp23xx/include/mach/platform.h del=
eted in arm-soc/for-next and modified in HEAD. Version HEAD of arch/arm/mac=
h-ixp23xx/include/mach/platform.h left in tree.
CONFLICT (modify/delete): arch/arm/mach-ixp2000/pci.c deleted in arm-soc/fo=
r-next and modified in HEAD. Version HEAD of arch/arm/mach-ixp2000/pci.c le=
ft in tree.
CONFLICT (modify/delete): arch/arm/mach-ixp2000/ixdp2x01.c deleted in arm-s=
oc/for-next and modified in HEAD. Version HEAD of arch/arm/mach-ixp2000/ixd=
p2x01.c left in tree.
CONFLICT (modify/delete): arch/arm/mach-ixp2000/ixdp2800.c deleted in arm-s=
oc/for-next and modified in HEAD. Version HEAD of arch/arm/mach-ixp2000/ixd=
p2800.c left in tree.
CONFLICT (modify/delete): arch/arm/mach-ixp2000/ixdp2400.c deleted in arm-s=
oc/for-next and modified in HEAD. Version HEAD of arch/arm/mach-ixp2000/ixd=
p2400.c left in tree.
CONFLICT (modify/delete): arch/arm/mach-ixp2000/include/mach/platform.h del=
eted in arm-soc/for-next and modified in HEAD. Version HEAD of arch/arm/mac=
h-ixp2000/include/mach/platform.h left in tree.
CONFLICT (modify/delete): arch/arm/mach-ixp2000/enp2611.c deleted in arm-so=
c/for-next and modified in HEAD. Version HEAD of arch/arm/mach-ixp2000/enp2=
611.c left in tree.
$ git rm -f drivers/mfd/ab5500-core.c
$ git rm -f -r arch/arm/mach-ixp2000 arch/arm/mach-ixp23xx
Merging ep93xx/ep93xx-cleanup (a1eacd7 arm: ep93xx: use gpio_led_register_d=
evice)
Merging kvmtool/master (cdb90a0 kvm tools: increase amount of virtio-9p FID=
s)
Merging dma-mapping/dma-mapping-next (d39d2b8 Merge branch 'for-next-arm-dm=
a' into for-next)
CONFLICT (content): Merge conflict in arch/x86/include/asm/dma-mapping.h
Merging dma-buf/for-next (69964ea Linux 3.4-rc5)
Merging ktest/for-next (648a182 ktest: Allow a test to override REBOOT_ON_S=
UCCESS)
Merging scsi-post-merge/merge-base:master ()
$ git checkout akpm
Applying: pagemap.h: fix warning about possibly used before init var
Applying: umem: fix up unplugging
Applying: cciss: fix incorrect scsi status reporting
Applying: arch/x86/platform/iris/iris.c: register a platform device and a p=
latform driver
Applying: arch/x86/include/asm/spinlock.h: fix comment
Applying: avr32: don't mask signals in the error path
Applying: avr32: use set_current_blocked() in handle_signal/sys_rt_sigreturn
Applying: avr32: use block_sigmask()
Applying: m32r: use set_current_blocked() and block_sigmask()
Applying: m68k: use set_current_blocked() and block_sigmask()
Applying: mn10300: use set_current_blocked() and block_sigmask()
Applying: cpuidle: remove unused hrtimer_peek_ahead_timers() call
Applying: cpuidle: add checks to avoid NULL pointer dereference
Applying: cris: use set_current_blocked() and block_sigmask()
Applying: cris: select GENERIC_ATOMIC64
Applying: video: exynos mipi dsi: Do not use deprecated suspend/resume call=
backs
Applying: video: exynos mipi dsi: Avoid races in probe()
Applying: video: exynos mipi dsi: Properly interpret the interrupt source f=
lags
Applying: video: exynos mipi dsi: support reverse panel type
Applying: timeconst.pl: remove deprecated defined(@array)
Applying: ia64: use set_current_blocked() and block_sigmask()
Applying: microblaze: don't reimplement force_sigsegv()
Applying: microblaze: no need to reset handler if SA_ONESHOT
Applying: microblaze: fix signal masking
Applying: microblaze: use set_current_blocked() and block_sigmask()
Applying: score: don't mask signals if we fail to setup signal stack
Applying: score: use set_current_blocked() and block_sigmask()
Applying: h8300: use set_current_blocked() and block_sigmask()
Applying: drivers/thermal/spear_thermal.c: add Device Tree probing capabili=
ty
Applying: unicore32: use block_sigmask()
Applying: connector/userns: replace netlink uses of cap_raised() with capab=
le()
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
Applying: fsnotify: remove unused parameter from send_to_group()
Applying: fsnotify: handle subfiles' perm events
Applying: blackfin: use set_current_blocked() and block_sigmask()
Applying: mm/memory_failure: let the compiler add the function name
Applying: mm/mempolicy.c: use enum value MPOL_REBIND_ONCE in mpol_rebind_po=
licy()
Applying: mm/hugetlb.c: use long vars instead of int in region_count()
Applying: mm, thp: remove unnecessary ret variable
Applying: mm, thp: allow fallback when pte_alloc_one() fails for huge pmd
Applying: mm: remove swap token code
Applying: mm: vmscan: remove lumpy reclaim
Applying: mm: vmscan: do not stall on writeback during memory compaction
Applying: mm: vmscan: remove reclaim_mode_t
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
Applying: mm: fix off-by-one bug in print_nodes_state()
Applying: mm: use kcalloc() instead of kzalloc() to allocate array
Applying: mm/mmap.c: find_vma(): remove unnecessary if(mm) check
Applying: mm-mmapc-find_vma-remove-unnecessary-ifmm-check-fix
Applying: mm/fork: fix overflow in vma length when copying mmap on clone
Applying: mm/vmstat.c: remove debug fs entries on failure of file creation =
and made extfrag_debug_root dentry local
Applying: mm: correctly synchronize rss-counters at exit/exec
Applying: thp, memcg: split hugepage for memcg oom on cow
Applying: mm: do_migrate_pages() calls migrate_to_node() even if task is al=
ready on a correct node
Applying: mm-do_migrate_pages-calls-migrate_to_node-even-if-task-is-already=
-on-a-correct-node-fix
Applying: mm: do_migrate_pages(): rename arguments
Applying: kernel: cgroup: push rcu read locking from css_is_ancestor() to c=
allsite
Applying: mm: memcg: count pte references from every member of the reclaime=
d hierarchy
Applying: mm-memcg-count-pte-references-from-every-member-of-the-reclaimed-=
hierarchy-fix
Applying: mm: rename is_mlocked_vma() to mlocked_vma_newpage()
Applying: mm-rename-is_mlocked_vma-to-mlocked_vma_newpage-fix
Applying: mm, thp: drop page_table_lock to uncharge memcg pages
Applying: Documentation: memcg: future proof hierarchical statistics docume=
ntation
Applying: Cross Memory Attach: make it Kconfigurable
Applying: bug: introduce BUILD_BUG_ON_INVALID() macro
Applying: bug: completely remove code generated by disabled VM_BUG_ON()
Applying: x86: print e820 physical addresses consistently with other parts =
of kernel
Applying: x86: print physical addresses consistently with other parts of ke=
rnel
Applying: swiotlb: print physical addresses consistently with other parts o=
f kernel
Applying: mm: print physical addresses consistently with other parts of ker=
nel
Applying: kbuild: install kernel-page-flags.h
Applying: tools/vm/page-types.c: cleanups
Applying: mm: move is_vma_temporary_stack() declaration to huge_mm.h
Applying: mm/page_alloc.c: remove pageblock_default_order()
Applying: mm: bootmem: fix checking the bitmap when finally freeing bootmem
Applying: mm: bootmem: remove redundant offset check when finally freeing b=
ootmem
Applying: mm: bootmem: rename alloc_bootmem_core to alloc_bootmem_bdata
Applying: mm: bootmem: split out goal-to-node mapping from goal dropping
Applying: mm: bootmem: allocate in order node+goal, goal, node, anywhere
Applying: mm: bootmem: unify allocation policy of (non-)panicking node allo=
cations
Applying: mm: nobootmem: panic on node-specific allocation failure
Applying: mm: nobootmem: unify allocation policy of (non-)panicking node al=
locations
Applying: mm: bootmem: pass pgdat instead of pgdat->bdata down the stack
Applying: mm: remove sparsemem allocation details from the bootmem allocator
Applying: mm-remove-sparsemem-allocation-details-from-the-bootmem-allocator=
-fix
Applying: mm: compaction: handle incorrect MIGRATE_UNMOVABLE type pageblocks
Applying: memcg: fix/change behavior of shared anon at moving task
Applying: memcg swap: mem_cgroup_move_swap_account never needs fixup
Applying: memcg swap: use mem_cgroup_uncharge_swap()
Applying: mm/memcg: scanning_global_lru means mem_cgroup_disabled
Applying: mm/memcg: move reclaim_stat into lruvec
Applying: mm: push lru index into shrink_[in]active_list()
Applying: mm-push-lru-index-into-shrink_active_list-fix
Applying: mm: mark mm-inline functions as __always_inline
Applying: mm: remove lru type checks from __isolate_lru_page()
Applying: mm/memcg: kill mem_cgroup_lru_del()
Applying: memcg: mark more functions/variables as static
Applying: memcg: remove unused variable
Applying: memcg: mark stat field of mem_cgroup struct as __percpu
Applying: memcg: remove redundant parentheses
Applying: memcg: make threshold index in the right position
Applying: memcg: revise the position of threshold index while unregistering=
 event
Applying: mm/memcg: use vm_swappiness from target memory cgroup
Applying: memcg: add mlock statistic in memory.stat
Applying: memcg-add-mlock-statistic-in-memorystat-fix
Applying: mm/vmscan: store "priority" in struct scan_control
Applying: mm: add link from struct lruvec to struct zone
Applying: mm/vmscan: push lruvec pointer into isolate_lru_pages()
Applying: mm/vmscan: push zone pointer into shrink_page_list()
Applying: mm/vmscan: remove update_isolated_counts()
Applying: mm/vmscan: push lruvec pointer into putback_inactive_pages()
Applying: mm/vmscan: replace zone_nr_lru_pages() with get_lruvec_size()
Applying: mm/vmscan: push lruvec pointer into inactive_list_is_low()
Applying: mm/vmscan: push lruvec pointer into shrink_list()
Applying: mm/vmscan: push lruvec pointer into get_scan_count()
Applying: mm/vmscan: push lruvec pointer into should_continue_reclaim()
Applying: mm/vmscan: kill struct mem_cgroup_zone
Applying: security/keys/keyctl.c: suppress memory allocation failure warning
Applying: frv: use set_current_blocked() and block_sigmask()
Applying: um/kernel/trap.c: port OOM changes to handle_page_fault()
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
Applying: CodingStyle: add kmalloc_array() to memory allocators
Applying: parisc: use set_current_blocked() and block_sigmask()
Applying: introduce SIZE_MAX
Applying: locking: add KERN_CONT when needed to self test
Applying: x86, NMI: add missing KERN_CONT to NMI selftest
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
Applying: kernel/resource.c: correct the comment of allocate_resource()
Applying: sethostname/setdomainname: notify userspace when there is a chang=
e in uts_kern_table
Applying: NMI watchdog: fix for lockup detector breakage on resume
Applying: nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix
Applying: nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix-fix-f=
ix
Applying: nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix-fix
Applying: watchdog: fix for lockup detector breakage on resume
Applying: nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-v2-fix
Applying: task_work_add: generic process-context callbacks
Applying: genirq: reimplement exit_irq_thread() hook via task_work_add()
Applying: hexagon: do_notify_resume() needs tracehook_notify_resume()
Applying: keys: change keyctl_session_to_parent() to use task_work_add()
Applying: keys: kill the dummy key_replace_session_keyring()
Applying: keys: kill task_struct->replacement_session_keyring
Applying: kernel/irq/manage.c: use the pr_foo() infrastructure to prefix pr=
intks
Applying: vsprintf: correctly handle width when '#' flag used in %#p format.
Applying: vsprintf-correctly-handle-width-when-flag-used-in-%p-format-check=
patch-fixes
Applying: vsprintf: further optimize decimal conversion
Applying: vsprintf-further-optimize-decimal-conversion-v2
Applying: vsprintf-further-optimize-decimal-conversion-checkpatch-fixes
Applying: hamradio/scc: orphan driver in MAINTAINERS
Applying: MAINTAINERS: remove Alessandro
Applying: blacklight: remove redundant spi driver bus initialization
Applying: lcd: add callbacks for early fb event blank support
Applying: fbdev: add events for early fb event support
Applying: drivers/video/backlight/apple_bl.c: include header for exported s=
ymbol prototypes
Applying: drivers-video-backlight-apple_blc-include-header-for-exported-sym=
bol-prototypes-fix
Applying: backlight: add LM3533 backlight driver
Applying: backlight-add-lm3533-backlight-driver-fix
Applying: backlight-add-lm3533-backlight-driver-fix-fix
Applying: drivers/leds/leds-lp5521.c: fix lp5521_read() error handling
Applying: leds: driver for DA9052/53 PMIC v2
Applying: leds-led-module-for-da9052-53-pmic-v2-fix
Applying: leds: add LED driver for lm3556 chip
Applying: leds-add-led-driver-for-lm3556-chip-checkpatch-fixes
Applying: leds: lm3556: don't call kfree for the memory allocated by devm_k=
zalloc
Applying: leds: simple_strtoul() cleanup
Applying: leds: Use kcalloc instead of kzalloc to allocate array
Applying: leds: add new field to led_classdev struct to save activation sta=
te
Applying: leds: change existing triggers to use activated flag
Applying: leds: change ledtrig-timer to use activated flag
Applying: include/linux/led-lm3530.h: comment correction about the range of=
 brightness
Applying: drivers/leds/leds-lm3530.c: simplify als configuration on initial=
ization
Applying: leds: heartbeat: stop on shutdown
Applying: leds-heartbeat-stop-on-shutdown-v5
Applying: leds-heartbeat-stop-on-shutdown-checkpatch-fixes
Applying: leds: add new transient trigger for one shot timer activation
Applying: drivers/leds/leds-pca955x.c: fix race condition while setting bri=
ghtness on several LEDs
Applying: list_debug: WARN for adding something already in the list
Applying: lib/test-kstrtox.c: mark const init data with __initconst instead=
 of __initdata
Applying: lib/string_helpers.c: make arrays static
Applying: lib/bitmap.c: fix documentation for scnprintf() functions
Applying: vsprintf: fix %ps on non symbols when using kallsyms
Applying: spinlock_debug: print kallsyms name for lock
Applying: radix-tree: fix preload vector size
Applying: lib/vsprintf.c: "%#o",0 becomes '0' instead of '00'
Applying: checkpatch: suggest pr_<level> over printk(KERN_<LEVEL>
Applying: init: disable sparse checking of the mount.o source files
Applying: rtc/spear: add Device Tree probing capability
Applying: drivers/rtc/rtc-ep93xx.c: convert to use module_platform_driver()
Applying: rtc: add ioctl to get/clear battery low voltage status
Applying: drivers/rtc/rtc-pcf8563.c: add RTC_VL_READ/RTC_VL_CLR ioctl featu=
re
Applying: drivers/rtc/Kconfig: place RTC_DRV_IMXDI and RTC_MXC under "on-CP=
U RTC drivers"
Applying: rtc: rename CONFIG_RTC_MXC to CONFIG_RTC_DRV_MXC
Applying: rtc-rename-config_rtc_mxc-to-config_rtc_drv_mxc-fix
Applying: rtc: ds1307: remove superfluous initialization
Applying: rtc: ds1307: add trickle charger support
Applying: drivers/rtc/rtc-m41t93.c: don't let get_time() reset M41T93_FLAG_=
OF
Applying: drivers/rtc/rtc-lpc32xx.c: add device tree support
Applying: nilfs2: flush disk caches in syncing
Applying: HPFS: remove PRINTK() macro
Applying: fat: introduce special inode for managing the FSINFO block
Applying: fat: introduce mark_fsinfo_dirty helper
Applying: fat: mark superblock as dirty less often
Applying: fat: switch to fsinfo_inode
Applying: kmod: unexport call_usermodehelper_freeinfo()
Applying: kmod: convert two call sites to call_usermodehelper_fns()
Applying: kmod: move call_usermodehelper_fns() to .c file and unexport all =
it's helpers
Applying: kmod.c: fix kernel-doc warning
Applying: kmod: avoid deadlock from recursive kmod call
Applying: cred: remove task_is_dead() from __task_cred() validation
Applying: stack usage: add pid to warning printk in check_stack_usage
Applying: proc: clean up /proc/<pid>/environ handling
Applying: proc-clean-up-proc-pid-environ-handling-checkpatch-fixes
Applying: proc: unify ptrace_may_access() locking code
Applying: proc: remove mm_for_maps()
Applying: proc: use mm_access() instead of ptrace_may_access()
Applying: proc: don't do dummy rcu_read_lock/rcu_read_unlock on error path
Applying: proc: pass "fd" by value in /proc/*/{fd,fdinfo} code
Applying: procfs: use more apprioriate types when dumping /proc/N/stat
Applying: proc: report file/anon bit in /proc/pid/pagemap
Applying: proc/smaps: carefully handle migration entries
Applying: proc/smaps: show amount of nonlinear ptes in vma
Applying: proc/smaps: show amount of hwpoison pages
Applying: proc: use IS_ERR_OR_NULL()
Applying: fork: call complete_vfork_done() after clearing child_tid and flu=
shing rss-counters
Applying: cpu: introduce clear_tasks_mm_cpumask() helper
Applying: arm: use clear_tasks_mm_cpumask()
Applying: powerpc: use clear_tasks_mm_cpumask()
Applying: sh: use clear_tasks_mm_cpumask()
Applying: blackfin: a couple of task->mm handling fixes
Applying: blackfin: fix possible deadlock in decode_address()
Applying: um: should hold tasklist_lock while traversing processes
Applying: um: fix possible race on task->mm
Applying: um: properly check all process' threads for a live mm
Applying: kernel/cpu.c: document clear_tasks_mm_cpumask()
Applying: kernel-cpuc-document-clear_tasks_mm_cpumask-fix
Applying: ipc/sem.c: alternatives to preempt_disable()
Applying: ipc/mqueue: cleanup definition names and locations
Applying: ipc/mqueue: switch back to using non-max values on create
Applying: ipc/mqueue: enforce hard limits
Applying: ipc/mqueue: update maximums for the mqueue subsystem
Applying: ipc/mqueue: using vmalloc requires including vmalloc.h
Applying: mqueue: revert bump up DFLT_*MAX
Applying: mqueue: don't use kmalloc with KMALLOC_MAX_SIZE
Applying: mqueue: separate mqueue default value from maximum value
Applying: selftests: add mq_open_tests
Applying: ipc/mqueue: improve performance of send/recv
Applying: ipc-mqueue-improve-performance-of-send-recv-fix
Applying: ipc/mqueue: correct mq_attr_ok test
Applying: ipc-mqueue-correct-mq_attr_ok-test-fix
Applying: ipc/mqueue: strengthen checks on mqueue creation
Applying: ipc-mqueue-strengthen-checks-on-mqueue-creation-fix
Applying: tools/selftests: add mq_perf_tests
Applying: tools-selftests-add-mq_perf_tests-checkpatch-fixes
Applying: rapidio: add DMA engine support for RIO data transfers
Applying: rapidio/tsi721: add DMA engine support
Applying: pidns: use task_active_pid_ns in do_notify_parent
Applying: pidns: guarantee that the pidns init will be the last pidns proce=
ss reaped
Applying: pidns: make killed children autoreap
Applying: pidns-make-killed-children-autoreap-checkpatch-fixes
Applying: eventfd: change int to __u64 in eventfd_signal()
Applying: eventfd-change-int-to-__u64-in-eventfd_signal-fix
Applying: aio/vfs: cleanup of rw_copy_check_uvector() and compat_rw_copy_ch=
eck_uvector()
Applying: sysctl: make kernel.ns_last_pid control dependent on CHECKPOINT_R=
ESTORE
Applying: fs, proc: introduce /proc/<pid>/task/<tid>/children entry
Applying: c/r: fs, proc: Move children entry back to tid_base_stuff
Applying: syscalls, x86: add __NR_kcmp syscall
Applying: syscalls-x86-add-__nr_kcmp-syscall-v8 comment update
Applying: syscalls-x86-add-__nr_kcmp-syscall-v8-comment-update-fix
Applying: c/r: procfs: add arg_start/end, env_start/end and exit_code membe=
rs to /proc/$pid/stat
Applying: c/r: prctl: extend PR_SET_MM to set up more mm_struct entries
Applying: c/r: prctl: simplify PR_SET_MM on mm::code/data assignment
Applying: c-r-prctl-simplify-pr_set_mm-on-mm-code-data-assignment-fix
Applying: c/r: prctl: return -EFAULT instead of -EINVAL in case if underlie=
d VMA is not found
Applying: c/r: prctl: add ability to set new mm_struct::exe_file
Applying: c/r: prctl: update prctl_set_mm_exe_file() after mm->num_exe_file=
_vmas removal
Applying: c/r: prctl: add ability to get clear_tid_address
Applying: c/r: prctl: drop VMA flags test on PR_SET_MM_ stack data assignme=
nt
Applying: ramoops: use pstore interface
Applying: ramoops: fix printk format warnings
Applying: kconfig: update compression algorithm info
Applying: notify_change(): check that i_mutex is held
Merging quilt/akpm (eb304e3 notify_change(): check that i_mutex is held)
[master 7050e49] Revert "ISDN: add missing KERN_CONT"

--Signature=_Fri__11_May_2012_16_27_38_+1000_g2.iGyqYo+vR3INZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPrLFaAAoJEECxmPOUX5FEuaAP/AkDBjiDhm+FHPviSBW6PDnl
6sTP2qijaJ2PEQZgGwUi6URUiuPsnsFEnWF6M1LgG77oofg8W2Qvrb/BjQ8Kqsmi
Qj7oBmUAG+NrBpD/2VowhL1kppL2HeOJ4MCVzBreSiCKpui7cWUkIMkOFrOhH7j0
4xv2zgD5BHqz81/k2YydjdLIYaQL1wEdzJazBIkEHDa6Vycp6zi03uFsVgLgGAJH
XAKINodutSjEKlZAy6oqL7/dkdOVlwja4A4RF5KTGPSIxWS05yUi+XRczRkHq9VH
TI092m/KYgnKiYBY8iqY3+vCGZ8d/OEKZjK13g8fJg4/FnlpXGPZIvsVA0PZmcvs
iRzX6JyMzKiTIQ2e0f1bUgIrkR0k78akzxnvGAK5tB+nVvwNgB0G9D9XXnbgDeWn
s194YjLSrnvGpRLp5WO8zQ9n+5Vc7Tk0OWbxd/NnWGsSOvlQ5pJAjEqKaaXDf4xg
2OAW9LsVVshqRMg/a8M7CTu9FC0Pmk+ZroMm9VhPQcly55Vy9HWdYBO8y9PAzmcH
NtmuexPrX1+RRiEHF9bQDlglRt3Ytkvm0e3xsAkS8qY8Ne082ydNImXF9HHKXVaJ
MARaEPxj0tjepSyfIcwagjroH7M7GaFID3fBsXECmgQy9YNwhTqxWgVW1qBriumJ
WKioF/A9SqofvAq4wVJp
=nmdd
-----END PGP SIGNATURE-----

--Signature=_Fri__11_May_2012_16_27_38_+1000_g2.iGyqYo+vR3INZ--

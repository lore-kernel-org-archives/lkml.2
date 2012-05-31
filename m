Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183Ab2EaFCD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 01:02:03 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:44191 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304Ab2EaFB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 01:01:57 -0400
Date: Thu, 31 May 2012 15:01:48 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for May 31
Message-Id: <20120531150148.be90fac35fb1679751ff39b0@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__31_May_2012_15_01_48_+1000_QJD8Dc40fXzsvJeX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__31_May_2012_15_01_48_+1000_QJD8Dc40fXzsvJeX
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20120529:

Undropped tree: l2-mtd

The mips tree lost its conflicts.

The sparc tree lost its build failure.

The ceph tree lost its conflicts.

The vfs tree gained a build failure so I used the version from
next-20120529.

The l2-mtd tree lost its conflicts.

The mfd tree lost its conflicts.

The edac tree lost its conflict.

The drivers-x86 tree gained a conflict against Linus' tree.

The vhost tree gained a conflict against the net tree.

The akpm tree gained conflicts against Linus' tree and lost many patches
that turned up in Linus' tree.

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

We are up to 190 trees (counting Linus' and 26 trees of patches pending
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
Merging origin/master (af56e0a Merge git://git.kernel.org/pub/scm/linux/ker=
nel/git/sage/ceph-client)
Merging fixes/master (b1a808f Merge branch 'for-next' of git://gitorious.or=
g/kernel-hsi/kernel-hsi)
Merging kbuild-current/rc-fixes (e88aa7b Fix modpost failures in fedora 17)
Merging arm-current/fixes (ef0c148 ARM: neponset: make sure neponset_ncr_fr=
ob() is exported)
Merging ep93xx-current/ep93xx-fixes (2b3c83e dmaengine/ep93xx_dma: Implemen=
t double buffering for M2M DMA channels)
Merging m68k-current/for-linus (f25e918 m68k: Setup CROSS_COMPILE at the to=
p)
Merging powerpc-merge/merge (7c0482e powerpc/irq: Fix another case of lazy =
IRQ state getting out of sync)
Merging sparc/master (e49e6ff sparc: fix sparc64 build due to leon.h inclus=
ion)
Merging net/master (2e1d4a0 net/smsc911x: Repair broken failure paths)
CONFLICT (content): Merge conflict in Documentation/feature-removal-schedul=
e.txt
Merging sound-current/for-linus (adcc70b ALSA: hda/realtek - Add new codec =
support for ALC269VD)
Merging pci-current/for-linus (314489b Merge tag 'fixes-for-linus' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc)
Merging wireless/master (7b21aea mac80211: fix ADDBA declined after suspend=
 with wowlan)
Merging driver-core.current/driver-core-linus (61011677 Merge tag 'dlm-3.5'=
 of git://git.kernel.org/pub/scm/linux/kernel/git/teigland/linux-dlm)
Merging tty.current/tty-linus (61011677 Merge tag 'dlm-3.5' of git://git.ke=
rnel.org/pub/scm/linux/kernel/git/teigland/linux-dlm)
Merging usb.current/usb-linus (61011677 Merge tag 'dlm-3.5' of git://git.ke=
rnel.org/pub/scm/linux/kernel/git/teigland/linux-dlm)
Merging staging.current/staging-linus (61011677 Merge tag 'dlm-3.5' of git:=
//git.kernel.org/pub/scm/linux/kernel/git/teigland/linux-dlm)
Merging char-misc.current/char-misc-linus (61011677 Merge tag 'dlm-3.5' of =
git://git.kernel.org/pub/scm/linux/kernel/git/teigland/linux-dlm)
Merging input-current/for-linus (e644dae Merge branch 'next' into for-linus)
Merging md-current/for-linus (1dff2b8 md/bitmap: record the space available=
 for the bitmap in the superblock.)
Merging audit-current/for-linus (c158a35 audit: no leading space in audit_l=
og_d_path prefix)
Merging crypto-current/master (ef45b83 crypto: aesni-intel - move more comm=
on code to ablk_init_common)
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
Merging arm/for-next (22d46eb Merge branches 'fixes' and 'signal' into for-=
next)
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
Merging m68knommu/for-next (7094ac0 m68k: add a defconfig for the M5475EVB =
ColdFire with MMU board)
Merging microblaze/next (a01ee16 Merge branch 'for-linus' of git://git.open=
-osd.org/linux-open-osd)
Merging mips/mips-for-linux-next (37a0b49 Merge branches 'next/generic' and=
 'mips/lantiq' into mips-for-linux-next)
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
Merging sh/sh-latest (43d3f86 sh: use the new generic strnlen_user() functi=
on)
Merging sparc-next/master (31a6710 Fix blocking allocations called very ear=
ly during bootup)
Merging tile/master (1fcb78e tile: default to tilegx_defconfig for ARCH=3Dt=
ile)
Merging unicore32/unicore32 (0994695 Merge branch 'akpm' (aka "Andrew's pat=
ch-bomb, take two"))
Merging ceph/master (6bd9adb libceph: fix pg_temp updates)
Merging cifs/for-next (2c0c2a0 cifs: fix oops while traversing open file li=
st (try #4))
Merging configfs/linux-next (b930c26 Merge branch 'for-linus' of git://git.=
kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (6cfd4b4 ecryptfs: remove the second argument of k[un=
]map_atomic())
CONFLICT (content): Merge conflict in fs/ecryptfs/ecryptfs_kernel.h
Merging ext3/for_next (0324876 ext2: trivial fix to comment for ext2_free_b=
locks)
Merging ext4/dev (c1e910e ext4: protect group inode free counting with grou=
p lock)
Merging fuse/for-next (203627b fuse: fix blksize calculation)
Merging gfs2/master (72c04af fbdev: sh_mobile_lcdc: Don't confuse line size=
 with pitch)
Merging logfs/master (cd8bfa9 logfs: initialize the number of iovecs in bio)
Merging nfs/linux-next (12cb3e8 Merge branch 'devel' into linux-next)
Merging nfsd/nfsd-next (887006d nfsd4: fix, consolidate client_has_state)
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
Merging vfs/for-next (46ae73e unexport do_mmap())
$ git reset --hard HEAD^
Merging refs/next/20120529/vfs
CONFLICT (modify/delete): drivers/usb/core/inode.c deleted in HEAD and modi=
fied in refs/next/20120529/vfs. Version refs/next/20120529/vfs of drivers/u=
sb/core/inode.c left in tree.
$ git rm -f drivers/usb/core/inode.c
[master 6388cb3] Merge commit 'refs/next/20120529/vfs'
Merging pci/next (5420e46 microblaze/PCI: fix "io_offset undeclared" error)
Merging hid/for-next (3c2c4b7 Merge branch 'for-linus' of git://git.kernel.=
org/pub/scm/linux/kernel/git/jikos/hid)
Merging quilt/i2c (b2b60dd i2c: Split I2C_M_NOSTART support out of I2C_FUNC=
_PROTOCOL_MANGLING)
Merging bjdooks-i2c/next-i2c (fc84fe1 Merge branch 'for_3.3/i2c/misc' of gi=
t://git.kernel.org/pub/scm/linux/kernel/git/khilman/linux-omap-pm into for-=
33/i2c/omap)
CONFLICT (content): Merge conflict in drivers/i2c/busses/i2c-omap.c
Merging i2c-embedded/i2c-embedded/for-next (9868a06 i2c: davinci: Free requ=
ested IRQ in remove)
Merging quilt/jdelvare-hwmon (7ae8d78 hwmon: (coretemp) Improve support of =
recent Atom CPU models)
Merging hwmon-staging/hwmon-next (4573acb hwmon: (it87) Make temp3 attribut=
e conditional for IT8782F)
Merging v4l-dvb/master (20a2218 Merge /home/v4l/v4l/patchwork)
Merging kbuild/for-next (e499c75 Merge branch 'kbuild/misc' into kbuild/for=
-next)
Merging kconfig/for-next (eae1c36 Merge branch 'kconfig/for-linus-2' into k=
config/for-next)
Merging libata/NEXT (2fff275 PATA host controller driver for ep93xx)
Merging infiniband/for-next (e979fb9 Merge branch 'mlx4' into for-next)
CONFLICT (content): Merge conflict in drivers/net/ethernet/emulex/benet/be_=
main.c
CONFLICT (content): Merge conflict in drivers/net/ethernet/emulex/benet/be_=
cmds.c
CONFLICT (content): Merge conflict in drivers/net/ethernet/emulex/benet/be.h
Merging acpi/next (29bdc67 Merge branch 'pss-workaround' into next)
CONFLICT (content): Merge conflict in drivers/gpu/drm/gma500/psb_drv.c
Merging cpupowerutils/master (f166033 cpupower tools: add install target to=
 the debug tools' makefiles)
Merging ieee1394/for-next (26c72e2 firewire: sbp2: document the absence of =
alignment requirements)
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
Merging slave-dma/next (1dd1ea8 dmaengine: at_hdmac: take maxburst from sla=
ve configuration)
Merging dmaengine/next (a2bd114 netdma: adding alignment check for NETDMA o=
ps)
Merging net-next/master (31a6710 Fix blocking allocations called very early=
 during bootup)
Merging wireless-next/master (05f8f25 Merge branch 'for-upstream' of git://=
git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next)
Merging bluetooth/master (36619d9 Bluetooth: Do not check func ready existe=
nce)
Merging mtd/master (5df41de mtd: cfi_cmdset_0002: Slight cleanup of fixup m=
essages)
CONFLICT (content): Merge conflict in drivers/mtd/nand/gpmi-nand/gpmi-nand.c
Merging l2-mtd/master (667b67e nand: mxc_nand: Use clk_prepare_enable/clk_d=
isable_unprepare)
Merging crypto/master (ef45b83 crypto: aesni-intel - move more common code =
to ablk_init_common)
Merging drm/drm-next (8c91402 Merge branch 'drm-nouveau-next' of git://anon=
git.freedesktop.org/git/nouveau/linux-2.6 into drm-core-next)
Merging sound/for-next (8dce9ae Merge branch 'topic/hda-switcheroo' into fo=
r-next)
Merging sound-asoc/for-next (fbe42f6 ASoC: fsi: bugfix: ensure dma is termi=
nated)
Merging quilt/rr (56abc41 brlocks/lglocks: turn into functions)
Merging input/next (8680917 Input: matrix-keymap - fix building keymaps)
Merging input-mt/for-next (66f75a5 Linux 3.4-rc4)
Merging cgroup/for-next (fa980ca cgroup: superblock can't be released with =
active dentries)
Merging block/for-next (723c0b7 Kill merge marker in Documentation/feature-=
removal.txt)
CONFLICT (content): Merge conflict in Documentation/feature-removal-schedul=
e.txt
Merging quilt/device-mapper (2e16d09 After the failure of a group of paths,=
 any alternative paths that need initialising do not become available until=
 further I/O is sent to the device.  Until this has happened, ioctls return=
 -EAGAIN.)
Merging embedded/master (4744b43 embedded: fix vc_translate operator preced=
ence)
Merging firmware/master (6e03a20 firmware: speed up request_firmware(), v3)
Merging pcmcia/master (80af9e6 pcmcia at91_cf: fix raw gpio number usage)
Merging mmc/mmc-next (0caaa95 mmc: at91-mci: this driver is now deprecated)
Merging kgdb/kgdb-next (3751d3e x86,kgdb: Fix DEBUG_RODATA limitation using=
 text_poke())
Merging slab/for-next (f50d5ae Merge branch 'slab/next' into for-next)
Merging uclinux/for-next (5e442a4 Revert "proc: fix races against execve() =
of /proc/PID/fd**")
Merging md/for-next (1dff2b8 md/bitmap: record the space available for the =
bitmap in the superblock.)
Merging mfd/for-next (29f772d mfd: Fix build break of max77693 by adding RE=
GMAP_I2C option)
Merging battery/master (96facd2 smb347-charger: Include missing <linux/err.=
h>)
Merging fbdev/fbdev-next (c895305 video: bfin_adv7393fb: Fix cleanup code)
Merging viafb/viafb-next (838ac78 viafb: avoid refresh and mode lookup in s=
et_par)
Merging omap_dss2/for-next (05dd0f5 OMAPDSS: DISPC: Update Accumulator conf=
iguration for chroma plane)
Merging regulator/for-next (4d94ce7 regulator: anatop: Use correct __devexi=
t_p annotation)
Merging security/next (ff2bb04 Merge branch 'master' of git://git.infradead=
.org/users/eparis/selinux into next)
Merging selinux/master (c737f82 SELinux: remove unused common_audit_data in=
 flush_unauthorized_files)
Merging lblnet/master (7e27d6e Linux 2.6.35-rc3)
Merging watchdog/master (af56e0a Merge git://git.kernel.org/pub/scm/linux/k=
ernel/git/sage/ceph-client)
Merging dwmw2-iommu/master (c3b92c8 Linux 3.1)
Merging iommu/next (28f8571 Merge branches 'iommu/fixes', 'dma-debug', 'arm=
/omap', 'arm/tegra', 'core' and 'x86/amd' into next)
Merging osd/linux-next (8b56a30 exofs:  Add SYSFS info for autologin/pNFS e=
xport)
Merging jc_docs/docs-next (5c050fb docs: update the development process doc=
ument)
Merging trivial/for-next (d766023 Merge branch 'doc' of git://git.kernel.or=
g/pub/scm/linux/kernel/git/jikos/trivial)
Merging audit/for-next (dcd6c92 Linux 3.3-rc1)
Merging pm/linux-next (6da5e30e Merge branch 'pm-acpi' into linux-next)
Merging apm/for-next (f283d22 APM: fix deadlock in APM_IOC_SUSPEND ioctl)
Merging fsnotify/for-next (1aec9c0 inotify: automatically restart syscalls)
Merging edac/linux_next (cfa0284 Merge branch 'fixes' into next)
Merging edac-amd/for-next (305f1c3 Merge branch '3.3-pci_device_id' into ed=
ac-for-next)
CONFLICT (content): Merge conflict in drivers/edac/amd64_edac.c
CONFLICT (content): Merge conflict in Documentation/edac.txt
Merging devicetree/devicetree/next (8d6c1ef Merge branch 'devicetree/merge'=
 into devicetree/next)
Merging spi/spi/next (d8e328b spi: Add "spi:" prefix to modalias attribute =
of spi devices)
Merging tip/auto-latest (4b7a762 Merge branch 'x86/urgent')
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
Merging drivers-x86/linux-next (ad229c5 toshiba_acpi: Add support for trans=
flective LCD)
CONFLICT (content): Merge conflict in drivers/platform/x86/toshiba_acpi.c
Merging hwpoison/hwpoison (46e387b Merge branch 'hwpoison-hugepages' into h=
wpoison)
Merging sysctl/master (4e474a0 sysctl: protect poll() in entries that may g=
o away)
Merging regmap/for-next (f65750aa regmap: clean up debugfs if regmap_init f=
ails)
Merging hsi/for-next (43139a6 HSI: hsi_char: Update ioctl-number.txt)
Merging driver-core/driver-core-next (61011677 Merge tag 'dlm-3.5' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/teigland/linux-dlm)
Merging tty/tty-next (61011677 Merge tag 'dlm-3.5' of git://git.kernel.org/=
pub/scm/linux/kernel/git/teigland/linux-dlm)
Merging usb/usb-next (61011677 Merge tag 'dlm-3.5' of git://git.kernel.org/=
pub/scm/linux/kernel/git/teigland/linux-dlm)
Merging staging/staging-next (61011677 Merge tag 'dlm-3.5' of git://git.ker=
nel.org/pub/scm/linux/kernel/git/teigland/linux-dlm)
Merging char-misc/char-misc-next (61011677 Merge tag 'dlm-3.5' of git://git=
.kernel.org/pub/scm/linux/kernel/git/teigland/linux-dlm)
Merging tmem/linux-next (0f1ea93 Merge branch 'stable/frontswap.v14' into l=
inux-next)
CONFLICT (content): Merge conflict in mm/Makefile
Merging writeback/writeback-for-next (9bb5082 block: Convert BDI proportion=
 calculations to flexible proportions)
Merging arm-dt/devicetree/arm-next (ede338f dt: add documentation of ARM dt=
 boot interface)
Merging hwspinlock/linux-next (8b37fcf hwspinlock: add MAINTAINERS entries)
Merging pinctrl/for-next (0db193b pinctrl: add pinctrl_add_gpio_ranges func=
tion)
Merging moduleh/for-sfr (f9e1b2b tile: fix compile failure on start_kernel =
in setup.c)
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
Merging remoteproc/for-next (d48b97b Linux 3.4-rc6)
Merging irqdomain/irqdomain/next (a87487e irqdomain: Document size paramete=
r of irq_domain_add_linear())
Merging gpio/gpio/next (3e11f7b gpio/generic: initialize basic_mmio_gpio sh=
adow variables properly)
Merging arm-soc/for-next (9bd9695 Merge branch 'devel-late' into for-next)
Merging ep93xx/ep93xx-cleanup (a1eacd7 arm: ep93xx: use gpio_led_register_d=
evice)
Merging renesas/next (76ab1e9 Merge branch 'renesas-emev2' into renesas-nex=
t)
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/Makefile
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/Kconfig
Merging s5p/for-next (3bd5eba Merge branch 'next/board-samsung-2' into for-=
next)
Merging tegra/for-next (ef14f5c Merge branch 'for-3.5/defconfig2' into for-=
next)
Merging kvmtool/master (65f6411 kvm tools: Remove unused req_mutex variable=
.)
Merging dma-mapping/dma-mapping-next (89e2a7c Merge branch 'for-next-other'=
 into for-next)
Merging dma-buf/for-next (b48b2c3 openrisc: use generic strnlen_user() func=
tion)
Merging userns/for-next (4b06a81 userns:  Silence silly gcc warning.)
Merging ktest/for-next (648a182 ktest: Allow a test to override REBOOT_ON_S=
UCCESS)
Merging signal/for-next (f23ca33 keys: kill task_struct->replacement_sessio=
n_keyring)
CONFLICT (content): Merge conflict in kernel/fork.c
Merging scsi-post-merge/merge-base:master ()
$ git checkout akpm
Applying: umem: fix up unplugging
Applying: cciss: fix incorrect scsi status reporting
Applying: arch/x86/platform/iris/iris.c: register a platform device and a p=
latform driver
Applying: arch/x86/include/asm/spinlock.h: fix comment
Applying: cpuidle: remove unused hrtimer_peek_ahead_timers() call
Applying: cpuidle: add checks to avoid NULL pointer dereference
Applying: timeconst.pl: remove deprecated defined(@array)
Applying: drivers/thermal/spear_thermal.c: add Device Tree probing capabili=
ty
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
CONFLICT (content): Merge conflict in mm/memcontrol.c
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
Applying: security/keys/keyctl.c: suppress memory allocation failure warning
Applying: um/kernel/trap.c: port OOM changes to handle_page_fault()
Applying: sgi-xp: use lockdep_assert_held()
Applying: drivers/scsi/aha152x.c: remove broken usage of spin_is_locked()
Applying: XFS: fix lock ASSERT on UP
Applying: mm/huge_memory.c: use lockdep_assert_held()
CONFLICT (content): Merge conflict in mm/swap.c
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
Applying: introduce SIZE_MAX
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
Applying: kernel/irq/manage.c: use the pr_foo() infrastructure to prefix pr=
intks
Applying: vsprintf: correctly handle width when '#' flag used in %#p format.
Applying: vsprintf-correctly-handle-width-when-flag-used-in-%p-format-check=
patch-fixes
Applying: vsprintf: further optimize decimal conversion
Applying: vsprintf-further-optimize-decimal-conversion-v2
Applying: vsprintf-further-optimize-decimal-conversion-checkpatch-fixes
Applying: leds: add LED driver for lm3556 chip
Applying: leds-add-led-driver-for-lm3556-chip-checkpatch-fixes
Applying: leds: lm3556: don't call kfree for the memory allocated by devm_k=
zalloc
Applying: checkpatch: suggest pr_<level> over printk(KERN_<LEVEL>
Applying: init: disable sparse checking of the mount.o source files
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
Applying: kconfig: update compression algorithm info
Applying: notify_change(): check that i_mutex is held
Applying: isdn-add-missing-kern_cont-fix
Merging quilt/akpm (b9ffc40 isdn-add-missing-kern_cont-fix)

--Signature=_Thu__31_May_2012_15_01_48_+1000_QJD8Dc40fXzsvJeX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPxvs8AAoJEECxmPOUX5FEQOQP/2psWAHnpYREoQ8FtQTtTv9M
qEpIpXvV/V4mJxeKefcYvDYkD+HU7b+6YF5OBvWdKL/irmCjVucAVSgfromK8CDC
PvzP014PtWTNHcFM3qpRedHfHXdHq1wEbNvU6uklpJgeN0AkjZINZ+21NPVOz7uT
uH2154I9U5xk1I5kYGV2TXzBu5XOQNu59/Tb5ixwH0YRqVqMukyOYXiDH8/PktIQ
bGszfaAO7whwigzEODhnfGgsL7hdR1CsX0nsjPPR+1drKnKdcBcHlJWQzFGAcuVw
Br9Xqlh2LeIBPBhMPTkeTvAuMPGkvQxf7mO4nKDaR/Dy0VaeDlXZ7OuDr3/ratUK
fVl0c5RXBi8dj2FG4vUosvuoPA+NyrgRWTHAlqOr5QqSgCdygOP86mSAF4Rnjd8p
MnZ0VwCue2Mmb6IGoOTuGrssGNFTpD8pQf3Ep9OWQEJJw0vR4/+nDSfQUzXc51ld
wtHT1DCqnnrbTE2kgMAWd6Llpf59pvZ/2qXGThtdbc3Ns1wwTwUiNqFBZ8NN782j
BlZsYRucYemcM3heJwu3KQC6pAThbsWgD/lc15rS+iI9uAUqlrYEs0GxrEwhyDS1
8KMIl3qahl2fNMkbfEsETRERVYosutLxPBB3etU3eK+XHuKd72yL/Gzk3VExBkKR
9FedxKgnsckHG0atWldW
=ZkAh
-----END PGP SIGNATURE-----

--Signature=_Thu__31_May_2012_15_01_48_+1000_QJD8Dc40fXzsvJeX--

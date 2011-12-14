Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591Ab1LNH04 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 02:26:56 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:60678 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269Ab1LNH0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 02:26:51 -0500
Date: Wed, 14 Dec 2011 18:26:43 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Dec 14
Message-Id: <20111214182643.06262d032298672024ba8a76@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__14_Dec_2011_18_26_43_+1100_z9iCDtW31U/KzCQ0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__14_Dec_2011_18_26_43_+1100_z9iCDtW31U/KzCQ0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20111213:

New tree: uapi

The net-next tree gained a conflict against the net tree and a build
failure for which I applied a patch.

The sound-asoc tree lost its build failure.

The driver-core tree gained a build failure so I used the version from
next-20111213.

Several patches were dropped from the akpm tree as they conflicted with
the cgroup tree.

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

We are up to 205 trees (counting Linus' and 27 trees of patches pending
for Linus' tree), more are welcome (even if they are currently empty).
Thanks to those who have contributed, and to those who haven't, please do.

Status of my local build tests will be at
http://kisskb.ellerman.id.au/linux-next .  If maintainers want to give
advice about cross compilers/configs that work, we are always open to add
more builds.

Thanks to Randy Dunlap for doing many randconfig builds.

There is a wiki covering stuff to do with linux-next at
http://linux.f-seidel.de/linux-next/pmwiki/ .  Thanks to Frank Seidel.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

$ git checkout master
$ git reset --hard stable
Merging origin/master (373da0a Merge branch 'x86-urgent-for-linus' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/tip/tip)
Merging fixes/master (aaa0b4f iio: iio_event_getfd -- fix ev_int build fail=
ure)
Merging kbuild-current/rc-fixes (44656fa kbuild: Fix missing system calls c=
heck on mips.)
Merging arm-current/fixes (9811ccd ARM: 7204/1: arch/arm/kernel/setup.c: in=
itialize arm_dma_zone_size earlier)
Merging m68k-current/for-linus (5bf1e97 m68k: Wire up process_vm_{read,writ=
e}v)
Merging powerpc-merge/merge (49e4406 powerpc/44x: Add mtd ndfc to the ppx44=
x defconfig)
Merging 52xx-and-virtex-current/powerpc/merge (c49f878 dtc/powerpc: remove =
obsolete .gitignore entries)
Merging sparc/master (dbf2b92 sbus: convert drivers/sbus/char/* to use modu=
le_platform_driver())
Merging scsi-rc-fixes/master (c4189d6 [SCSI] qla4xxx: check for failed conn=
 setup)
Merging net/master (3f1e6d3 sch_gred: should not use GFP_KERNEL while holdi=
ng a spinlock)
Merging sound-current/for-linus (1c89fe3 ALSA: HDA: Set position fix to LPI=
B for an Atom/Poulsbo based device)
Merging pci-current/for-linus (619a518 PCI hotplug: Always allow acpiphp to=
 handle non-PCIe bridges)
Merging wireless/master (10636bc ath9k: fix max phy rate at rate control in=
it)
Merging driver-core.current/driver-core-linus (dc47ce9 Linux 3.2-rc5)
Merging tty.current/tty-linus (caca6a0 Linux 3.2-rc3)
Merging usb.current/usb-linus (02a551c USB: option: Removing one bogus and =
adding some new Huawei combinations)
Merging staging.current/staging-linus (dc47ce9 Linux 3.2-rc5)
Merging char-misc.current/char-misc-linus (dc47ce9 Linux 3.2-rc5)
Merging cpufreq-current/fixes (5983fe2 Merge git://git.kernel.org/pub/scm/l=
inux/kernel/git/davem/net)
Merging input-current/for-linus (8521478 Input: synaptics - fix touchpad no=
t working after S2R on Vostro V13)
Merging md-current/for-linus (5d8c71f md: raid5 crash during degradation)
Merging audit-current/for-linus (def5754 Audit: remove spaces from audit_lo=
g_d_path)
Merging crypto-current/master (2742528 crypto: mv_cesa - fix hashing of chu=
nks > 1920 bytes)
Merging ide/master (0ab3d8b cy82c693: fix PCI device selection)
Merging dwmw2/master (244dc4e Merge git://git.infradead.org/users/dwmw2/ran=
dom-2.6)
Merging sh-current/sh-fixes-for-linus (21d41f2 sh: fix the compile error in=
 setup-sh7757.c)
Merging rmobile-current/rmobile-fixes-for-linus (a408bae ARM: mach-shmobile=
: sh7372 CMT3 and CMT4 clock support)
Merging devicetree-current/devicetree/merge (f88e1ae dt/device: Fix auxdata=
 matching to handle entries without a name override)
Merging spi-current/spi/merge (940ab88 drivercore: Add helper macro for pla=
tform_driver boilerplate)
Merging arm/for-next (738b2fa Merge branch 'restart' into for-next)
CONFLICT (content): Merge conflict in arch/arm/mach-mxs/mach-stmp378x_devb.c
CONFLICT (content): Merge conflict in arch/arm/mach-mxs/mach-m28evk.c
Merging arm-soc/for-next (105fd54 Merge branch 'next/devel' into for-next)
CONFLICT (content): Merge conflict in arch/arm/mach-mxs/include/mach/common=
.h
CONFLICT (content): Merge conflict in arch/arm/mach-at91/at91sam9rl.c
CONFLICT (content): Merge conflict in arch/arm/mach-at91/at91sam9g45.c
CONFLICT (content): Merge conflict in arch/arm/mach-at91/at91sam9263.c
CONFLICT (content): Merge conflict in arch/arm/mach-at91/at91sam9261.c
CONFLICT (content): Merge conflict in arch/arm/mach-at91/at91sam9260.c
CONFLICT (content): Merge conflict in arch/arm/mach-at91/at91cap9.c
Merging arm-perf/for-next/perf (dc47ce9 Linux 3.2-rc5)
Merging at91/at91-next (8748dfa Merge branch 'for-linus' of git://git.kerne=
l.org/pub/scm/linux/kernel/git/aegl/linux)
Merging davinci/davinci-next (fe0d422 Linux 3.0-rc6)
Merging i.MX/for-next (5788f4d Merge branches 'imx-fixes', 'imx-cleanup' an=
d 'imx-features' into master)
CONFLICT (content): Merge conflict in arch/arm/plat-mxc/include/mach/hardwa=
re.h
CONFLICT (modify/delete): arch/arm/mach-mx5/pm-imx5.c deleted in HEAD and m=
odified in i.MX/for-next. Version i.MX/for-next of arch/arm/mach-mx5/pm-imx=
5.c left in tree.
CONFLICT (modify/delete): arch/arm/mach-mx5/Makefile deleted in HEAD and mo=
dified in i.MX/for-next. Version i.MX/for-next of arch/arm/mach-mx5/Makefil=
e left in tree.
CONFLICT (modify/delete): arch/arm/mach-mx5/Kconfig deleted in HEAD and mod=
ified in i.MX/for-next. Version i.MX/for-next of arch/arm/mach-mx5/Kconfig =
left in tree.
CONFLICT (content): Merge conflict in arch/arm/mach-imx/mm-imx5.c
CONFLICT (content): Merge conflict in arch/arm/mach-imx/devices-imx53.h
CONFLICT (content): Merge conflict in arch/arm/mach-imx/clock-mx51-mx53.c
$ git rm -f arch/arm/mach-mx5/pm-imx5.c arch/arm/mach-mx5/Makefile arch/arm=
/mach-mx5/Kconfig
Merging linux-spec/for-next (5111711 Merge branch 'for-2.6.37' of git://lin=
ux-nfs.org/~bfields/linux)
Merging omap/for-next (322a8b0 Linux 3.1-rc1)
Merging pxa/for-next (19d6c13 [ARM] pxa/hx4700: actually use platform_lcd d=
river)
Merging samsung/next-samsung (9edb240 ARM: H1940/RX1950: Change default LED=
 triggers)
Merging s5p/for-next (57894d3 Merge branch 'next-samsung-devel' into for-ne=
xt)
CONFLICT (content): Merge conflict in arch/arm/mach-s3c64xx/mach-crag6410.c
CONFLICT (content): Merge conflict in arch/arm/mach-exynos/include/mach/ent=
ry-macro.S
CONFLICT (content): Merge conflict in arch/arm/mach-exynos/cpu.c
Merging tegra/for-next (2e35cf8 Merge branch 'for-3.3/cleanup' into for-nex=
t)
CONFLICT (content): Merge conflict in arch/arm/mach-tegra/include/mach/entr=
y-macro.S
CONFLICT (content): Merge conflict in arch/arm/mach-tegra/board-dt.c
Merging xilinx/arm-next (b85a3ef ARM: Xilinx: Adding Xilinx board support)
Merging blackfin/for-linus (e5fd47b xen/pm_idle: Make pm_idle be default_id=
le under Xen.)
Merging c6x/for-linux-next (2141355 C6X: MAINTAINERS)
Merging cris/for-next (ea78f5b CRIS: Update documentation)
Merging quilt/hexagon (110b372 Remove unneeded include of version.h from ar=
ch/hexagon/include/asm/spinlock_types.h)
Merging ia64/next (2174f6d pstore: gracefully handle NULL pstore_info funct=
ions)
Merging m68k/for-next (e71ef31 m68k/net: Remove obsolete IRQ_FLG_* users)
Merging m68knommu/for-next (4a7c080 m68knommu: remove unused anchor.h inclu=
de file)
CONFLICT (content): Merge conflict in arch/m68k/Kconfig.debug
Merging microblaze/next (7f80850 Merge branch 'rmobile-fixes-for-linus' of =
git://github.com/pmundt/linux-sh)
Merging mips/mips-for-linux-next (1fc140c Merge branches 'next/ar7', 'next/=
ath79', 'next/bcm63xx', 'next/bmips', 'next/cavium', 'next/generic', 'next/=
kprobes', 'next/lantiq', 'next/perf' and 'next/raza' into mips-for-linux-ne=
xt)
CONFLICT (content): Merge conflict in arch/mips/kernel/perf_event_mipsxx.c
Merging openrisc/for-upstream (b6fd41e Linux 3.1-rc6)
Merging parisc/for-next (fc99a91 futex: Use same lock set as lws calls)
Merging powerpc/next (7c637b0 powerpc: Enable squashfs as a module)
Merging 4xx/next (228d550 powerpc/47x: Add support for the new IBM currituc=
k platform)
CONFLICT (content): Merge conflict in arch/powerpc/platforms/40x/ppc40x_sim=
ple.c
Merging 52xx-and-virtex/powerpc/next (c1395f4 dtc/powerpc: remove obsolete =
.gitignore entries)
Merging galak/next (fa8cbaa powerpc+sparc64/mm: Remove hack in mmap randomi=
ze layout)
Merging s390/features (b4c1eb9 [S390] cleanup trap handling)
Merging sh/sh-latest (b9a3acf Merge branch 'sh/stable-updates' into sh-late=
st)
Merging rmobile/rmobile-latest (b58c580 Merge branch 'rmobile-fixes-for-lin=
us' into rmobile-latest)
Merging sparc-next/master (3ee72ca Merge git://github.com/davem330/net)
Merging tile/master (0c90547 arch/tile: use new generic {enable,disable}_pe=
rcpu_irq() routines)
Merging unicore32/unicore32 (ed96dfb unicore32, exec: remove redundant set_=
fs(USER_DS))
Merging xtensa/master (29aced6 xtensa: remove defining register numbers)
Merging ceph/for-next (3395734 libceph: fix double-free of page vector)
Merging cifs/master (8def5f5 Merge git://git.samba.org/sfrench/cifs-2.6)
Merging configfs/linux-next (b930c26 Merge branch 'for-linus' of git://git.=
kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (aaef29d eCryptfs: Flush file in vma close)
Merging ext3/for_next (ed47a7d udf: Cleanup metadata flags handling)
Merging ext4/dev (5fb0e1c ext4: display the correct mount option in /proc/m=
ounts for [no]init_itable)
Merging fatfs/master (710d440 fat: fat16 support maximum 4GB file/vol size =
as WinXP or 7.)
Merging fuse/for-next (03c9693 cuse: implement memory mapping)
Merging gfs2/master (46cc1e5 GFS2: local functions should be static)
Merging hfsplus/for-next (6596528 hfsplus: ensure bio requests are not smal=
ler than the hardware sectors)
Merging jfs/next (1c8007b jfs: flush journal completely before releasing me=
tadata inodes)
Merging logfs/master (21f3eb8 logfs: update page reference count for pined =
pages)
CONFLICT (content): Merge conflict in fs/logfs/file.c
Merging nfs/linux-next (652f89f NFSv4: Do not accept delegated opens when a=
 delegation recall is in effect)
Merging nfsd/nfsd-next (f32f3c2 nfsd4: initialize special stateid's at comp=
ile time)
Merging nilfs2/for-next (93ee7a9 Linux 3.1-rc2)
Merging ocfs2/linux-next (9392557 ocfs2: avoid unaligned access to dqc_bitm=
ap)
Merging omfs/for-next (976d167 Linux 3.1-rc9)
Merging squashfs/master (7657cac Squashfs: Add an option to set dev block s=
ize to 4K)
Merging v9fs/for-next (883381d Merge branch 'dev' of git://git.kernel.org/p=
ub/scm/linux/kernel/git/tytso/ext4)
Merging ubifs/linux-next (eaecf43 UBIFS: Use kmemdup rather than duplicatin=
g its implementation)
Merging xfs/master (9f9c19e xfs: fix the logspace waiting algorithm)
Merging vfs/for-next (206b1d0 Fix POSIX ACL permission check)
Merging vfs-scale/vfs-scale-working (32385c7 kernel: fix hlist_bl again)
Merging pci/linux-next (f9dc912 PCI: kconfig: English typo in pci/pcie/Kcon=
fig)
Merging hid/for-next (92a0db5 Merge branch 'roccat' into for-next)
Merging quilt/i2c (a682833 i2c-ali1535: enable SPARC support)
Merging bjdooks-i2c/next-i2c (f8420b7 fixup merge)
CONFLICT (add/add): Merge conflict in drivers/i2c/busses/i2c-designware-pla=
tdrv.c
Merging quilt/jdelvare-hwmon (4a96f1a hwmon: (coretemp) Add missing section=
 annotations)
Merging hwmon-staging/hwmon-next (01aa042 hwmon: (f75375s) Add support for =
F75387SG/RG)
Merging quilt/kernel-doc (c3b92c8 Linux 3.1)
Merging docs/docs-move (5c24d8b Merge branch 'docs/docbook/drm' of git://gi=
thub.com/mfwitten/linux into docs-move)
Merging v4l-dvb/master (6dd9380 Merge /home/v4l/v4l/patchwork)
CONFLICT (content): Merge conflict in drivers/staging/media/as102/as102_drv=
.h
Merging kbuild/for-next (ddb550d Merge branch 'kbuild/misc' into kbuild/for=
-next)
Merging kconfig/for-next (eae1c36 Merge branch 'kconfig/for-linus-2' into k=
config/for-next)
Merging libata/NEXT (318072d SATA/PATA: convert drivers/ata/* to use module=
_platform_driver())
Merging infiniband/for-next (5611cc45 Linux 3.2-rc4)
Merging acpi/next (efb9058 Merge branches 'acpi', 'idle', 'mrst-pmu' and 'p=
m-tools' into next)
Merging cpupowerutils/master (498ca79 cpupower: use man(1) when calling "cp=
upower help subcommand")
Merging ieee1394/for-next (a572e68 firewire: ohci: fix isochronous DMA sync=
hronization)
Merging ubi/linux-next (c55d743 UBI: fix missing scrub when there is a bit-=
flip)
Merging dlm/next (9beb3bf dlm: convert rsb list to rb_tree)
Merging scsi/master (7061bba [SCSI] bfa: fix endian and bit field check bug)
Merging target-updates/for-next (5bda90c target: use ->exectute_task for al=
l CDB emulation)
Merging target-merge/for-next-merge (e0d85e5 ib_srpt: Initial SRP Target me=
rge for v3.2-rc1)
Merging ibft/linux-next (935a9fe ibft: Fix finding IBFT ACPI table on UEFI)
Merging slave-dma/next (3506c0d DMA: PL330: Remove pm_runtime_xxx calls fro=
m pl330 probe/remove)
CONFLICT (content): Merge conflict in drivers/dma/pl330.c
Merging async_tx/next (21ef4b8 dmaengine: use DEFINE_IDR for static initial=
ization)
Merging net-next/master (b43faac ipv6: If neigh lookup fails during icmp6 d=
st allocation, propagate error.)
CONFLICT (content): Merge conflict in net/batman-adv/translation-table.c
CONFLICT (content): Merge conflict in drivers/net/ethernet/freescale/fsl_pq=
_mdio.c
Merging wireless-next/master (c252165 mwifiex: do not advertise custom regu=
latory domain capability)
Merging bluetooth/master (5a13b09 Bluetooth: trivial: correct check for LMP=
 version)
Merging mtd/master (7148b79 mtd: pxa2xx-flash.c: It used to fall back to pr=
ovided table.)
Merging l2-mtd/master (a469923 mtd: document that MEMWRITE ioctl is NAND-sp=
ecific)
CONFLICT (content): Merge conflict in drivers/mtd/bcm63xxpart.c
Merging crypto/master (741e8c2 crypto: convert drivers/crypto/* to use modu=
le_platform_driver())
Merging sound/for-next (ad76188 Merge branch 'fix/hda' into for-next)
CONFLICT (content): Merge conflict in arch/arm/mach-s3c64xx/mach-crag6410.c
Merging sound-asoc/for-next (9215aa4 ASoC: Rename ALC5632 MICBIAS to common=
 name convention.)
Merging cpufreq/next (21f2e3c [CPUFREQ] Remove wall variable from cpufreq_g=
ov_dbs_init())
Merging quilt/rr (2570633 kernel/params: replace DEBUGP with pr_debug)
Merging input/next (246835f Input: wacom - add LED support for Cintiq 24HD)
CONFLICT (content): Merge conflict in drivers/input/keyboard/samsung-keypad=
.c
Merging input-mt/next (02f8c6a Linux 3.0)
Merging lsm/for-next (ca05a99 capabilities: remain source compatible with 3=
2-bit raw legacy capability support.)
Merging block/for-next (629baa7 Merge branch 'for-linus' into for-next)
Merging quilt/device-mapper (94956ee Merge git://git.kernel.org/pub/scm/lin=
ux/kernel/git/davem/net)
Merging embedded/master (4744b43 embedded: fix vc_translate operator preced=
ence)
Merging firmware/master (6e03a20 firmware: speed up request_firmware(), v3)
Merging pcmcia/master (74411c0 smc91c92_cs.c: fix bogus compiler warning)
Merging battery/master (00a159a max8925_power: Check at probe time if power=
 to set online)
Merging mmc/mmc-next (ed94591 mmc: core: Fixup delayed work clock gating pa=
tch)
CONFLICT (content): Merge conflict in drivers/mmc/card/block.c
Merging kgdb/kgdb-next (880ba69 lib: rename pack_hex_byte() to hex_byte_pac=
k())
Merging slab/for-next (a1450d6 Merge branch 'slab/urgent' into for-next)
Merging uclinux/for-next (5e442a4 Revert "proc: fix races against execve() =
of /proc/PID/fd**")
Merging md/for-next (5ce1a37 md/raid1: Mark device replaceable when we see =
a write error.)
Merging mfd/for-next (0b34804 mfd: Add device tree probe support for mc13xx=
x)
Merging hdlc/hdlc-next (4a6908a Linux 2.6.28)
Merging drm/drm-next (32faa34 drm/Merge branch 'drm-ttm-glisse' of ../drm-r=
adeon-next into drm-core-next)
CONFLICT (content): Merge conflict in drivers/gpu/drm/nouveau/nouveau_sgdma=
.c
Merging fbdev/fbdev-next (f940b88 video: s3c2410: fix checkpatch error and =
warnings)
Merging viafb/viafb-next (4ce36bb viafb: replace strict_strtoul to kstrto* =
and check return value)
Merging omap_dss2/for-next (3e28189 OMAPDSS: picodlp: add missing #include =
<linux/module.h>)
Merging regulator/for-next (2f288ef Merge branch 'topic/dt' of git://git.ke=
rnel.org/pub/scm/linux/kernel/git/broonie/regulator into regulator-next)
Merging security/next (735e93c Security: tomoyo: add .gitignore file)
CONFLICT (content): Merge conflict in lib/Makefile
Merging selinux/master (ded5098 SELinux: skip file_name_trans_write() when =
policy downgraded.)
Merging lblnet/master (7e27d6e Linux 2.6.35-rc3)
Merging watchdog/linux-next (80fee40 watchdog: move coh901327 state holders)
Merging bdev/master (feaf384 Merge branch 'for-linus' of git://git.kernel.d=
k/linux-2.6-block)
Merging dwmw2-iommu/master (c3b92c8 Linux 3.1)
Merging iommu/next (3a4786b Merge branches 'iommu/fixes', 'arm/omap', 'iomm=
u/page-sizes' and 'iommu/group-id' into next)
Merging cputime/cputime (c5927fe [S390] cputime: add sparse checking and cl=
eanup)
Merging osd/linux-next (dde406e pnfs-obj: Support for RAID5 read-4-write in=
terface.)
Merging jc_docs/docs-next (5c050fb docs: update the development process doc=
ument)
Merging nommu/master (0ce790e Linux 2.6.39-rc1)
Merging trivial/for-next (3f86549 mac80211: drop spelling fix)
CONFLICT (content): Merge conflict in arch/powerpc/platforms/40x/Kconfig
Merging audit/for-next (def5754 Audit: remove spaces from audit_log_d_path)
Merging pm/linux-next (87c1952 Merge branch 'pm-domains' into linux-next)
Merging apm/for-next (282e5aa x86: Kconfig: drop unknown symbol 'APM_MODULE=
')
Merging fsnotify/for-next (ef9bf3b fanotify: only destroy a mark if both it=
s mask and its ignored_mask are cleared)
Merging irda/for-next (94d57c4 enic: Update MAINTAINERS)
Merging edac/linux_next (4d096ca MAINTAINERS: add an entry for Edac Sandy B=
ridge driver)
Merging edac-amd/for-next (ed8ccfa Merge branch '3.3-edac-scrubrate' into e=
dac-for-next)
Merging devicetree/devicetree/next (ae97159 of_mdio: Don't phy_scan_fixups(=
) twice)
Merging spi/spi/next (940ab88 drivercore: Add helper macro for platform_dri=
ver boilerplate)
Merging gpio/gpio/next (15182f6 Merge branch 'pl022' of git://git.kernel.or=
g/pub/scm/linux/kernel/git/linusw/linux-stericsson into gpio/next)
Merging tip/auto-latest (e416e72 Merge branch 'x86/syscall' into auto-lates=
t)
CONFLICT (content): Merge conflict in kernel/sched/core.c
CONFLICT (content): Merge conflict in fs/proc/uptime.c
CONFLICT (content): Merge conflict in fs/proc/stat.c
CONFLICT (content): Merge conflict in drivers/macintosh/rack-meter.c
CONFLICT (content): Merge conflict in drivers/cpufreq/cpufreq_ondemand.c
CONFLICT (content): Merge conflict in drivers/cpufreq/cpufreq_conservative.c
Merging rcu/rcu/next (afe24b1 rcu: Move propagation of ->completed from rcu=
_start_gp() to rcu_report_qs_rsp())
Merging uprobes/for-next (b23a347 x86: skip singlestep where possible)
Merging cgroup/for-next (789244f Merge branch 'for-3.3' into for-next)
Merging kmemleak/kmemleak (029aeff kmemleak: Add support for memory hotplug)
Merging kvm/kvm-updates/3.2 (a3e06bb KVM: emulate lapic tsc deadline timer =
for guest)
Merging oprofile/for-next (8685bbc Merge branch 'oprofile/urgent' into opro=
file/master)
Merging xen/upstream/xen (ec8161f Merge branch 'upstream/microcode' into up=
stream/xen)
CONFLICT (content): Merge conflict in arch/x86/xen/Kconfig
Merging xen-two/linux-next (54e6a3c Merge branch 'stable/for-linus-3.3' int=
o linux-next)
CONFLICT (content): Merge conflict in arch/x86/xen/Kconfig
Merging xen-pvhvm/linux-next (b056b6a xen: suspend: remove xen_hvm_suspend)
Merging percpu/for-next (a34815b Merge branch 'for-3.2-fixes' of git://git.=
kernel.org/pub/scm/linux/kernel/git/tj/cgroup)
Merging workqueues/for-next (9c5a2ba workqueue: separate out drain_workqueu=
e() from destroy_workqueue())
Merging sfi/sfi-test (5b026c4 SFI: use ioremap_cache() instead of ioremap())
Merging asm-generic/next (35dbc0e asm-generic/io.h: allow people to overrid=
e individual funcs)
Merging drivers-x86/linux-next (15b956a acer-wmi: support Lenovo ideapad S2=
05 wifi switch)
Merging hwpoison/hwpoison (46e387b Merge branch 'hwpoison-hugepages' into h=
wpoison)
Merging sysctl/master (c2f5631 sysctl: remove impossible condition check)
Merging namespace/master (7e05c93 proc: Fix the proc access checks to names=
pace files.)
Merging regmap/for-next (681ba97 Merge branch 'regmap/irq' into regmap-next)
CONFLICT (content): Merge conflict in drivers/base/regmap/regmap.c
CONFLICT (content): Merge conflict in drivers/base/regmap/regcache.c
Merging hsi/for-next (a8b4dea HSI: hsi_char: Update ioctl-number.txt)
Merging driver-core/driver-core-next (3c8ed88 kref: Remove the memory barri=
ers)
$ git reset --hard HEAD^
Merging refs/next/20111213/driver-core
Merging tty/tty-next (6485163 serial: bfin-uart: Remove ASYNC_CTS_FLOW flag=
 for hardware automatic CTS.)
CONFLICT (content): Merge conflict in drivers/tty/serial/Makefile
CONFLICT (content): Merge conflict in drivers/tty/serial/Kconfig
Merging usb/usb-next (121a8cd Merge branch 'for-next/gadget' of git://git.k=
ernel.org/pub/scm/linux/kernel/git/balbi/usb into usb-next)
Merging staging/staging-next (0806884 Staging: remove version.h includes in=
 drivers/staging/rts5139)
CONFLICT (content): Merge conflict in drivers/staging/iio/adc/ad799x_core.c
CONFLICT (content): Merge conflict in drivers/staging/hv/Makefile
CONFLICT (content): Merge conflict in drivers/staging/hv/Kconfig
CONFLICT (rename/delete): drivers/hid/hid-hyperv.c deleted in staging/stagi=
ng-next and renamed in HEAD. Version HEAD of drivers/hid/hid-hyperv.c left =
in tree.
Merging char-misc/char-misc-next (1ff9764 char_dev.c: fix up some whitespac=
e errors)
Merging bkl-config/config (4ba8216 BKL: That's all, folks)
Merging tmem/tmem (665c1e6 mm: cleancache: Use __read_mostly as appropiate.)
CONFLICT (content): Merge conflict in mm/swapfile.c
Merging writeback/writeback-for-next (d2c3f73 writeback: Include all dirty =
inodes in background writeback)
Merging arm-dt/devicetree/arm-next (ede338f dt: add documentation of ARM dt=
 boot interface)
Merging hwspinlock/linux-next (8b37fcf hwspinlock: add MAINTAINERS entries)
Merging pinctrl/for-next (4cea691 pinctrl: Don't create a device for each p=
in controller)
Merging moduleh/for-sfr (6aec187 drivers/media: video/a5k6aa is a module an=
d so needs module.h)
Merging vhost/linux-next (193a667 alpha: drop pci_iomap/pci_iounmap from pc=
i-noop.c)
CONFLICT (content): Merge conflict in arch/m68k/Kconfig
CONFLICT (content): Merge conflict in arch/hexagon/Kconfig
Merging kmap_atomic/kmap_atomic (7b8fa32 feature-removal-schedule.txt: add =
the deprecated form of kmap_atomic())
CONFLICT (content): Merge conflict in Documentation/feature-removal-schedul=
e.txt
Merging xshm/xshm-for-next (429471b Fixup build by default-building dummy g=
enio)
Merging memblock/memblock-kill-early_node_map (7bd0b0f memblock: Reimplemen=
t memblock allocation using reverse free area iterator)
CONFLICT (content): Merge conflict in arch/score/Kconfig
CONFLICT (content): Merge conflict in arch/arm/mm/init.c
Merging remoteproc/for-next (d275b1b samples/rpmsg: add an rpmsg driver sam=
ple)
Applying: rpmsg: rename virtqueue_add_buf_gfp to virtqueue_add_buf
Merging kvmtool/master (f9f09f7 kvm tools: Create arch-specific kvm_cpu__em=
ulate_{mm}io())
CONFLICT (content): Merge conflict in scripts/kconfig/Makefile
CONFLICT (content): Merge conflict in include/net/9p/9p.h
Merging uapi/for-next (1632b9e UAPI: Split trivial #if defined(__KERNEL__) =
&& X conditionals)
Merging scsi-post-merge/merge-base:master ()
$ git checkout akpm
Merging akpm (587fddc linux-next: build failure after merge of the akpm tre=
e)
Applying: socket: bad fix for cgroup code breakage

--Signature=_Wed__14_Dec_2011_18_26_43_+1100_z9iCDtW31U/KzCQ0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO6E+zAAoJEECxmPOUX5FEmg4P/RMyIH3b3KnRDye93xyMvMdm
v++ZhRVd6sKOy3bvnRXno5qjPxHVqfkQdbvLUb+Vob0fzNeV16G8A241ERpG8Z7L
lraHuaRi/IxdVGy2PX8YSYFOPakWqckNGGiCNky+Ixshxxj/PZaBLiWMo442JNn6
MIuZeTva05+/D0CZr5Jmn0rUDtEzzKHvaf7fyukc5XTSmZwaWpFnWVl8nDlXM/ip
lNg3Pyh3GLyazPZs01ZkIz/7uM6UnwmOcNtyYFl5E+wo9eYLKWMfZDayl/zXWGBv
kCoMtpulunE+W+zwFvwebd1By9TUlgHpK6AfqdcfcwX6MJFLb+V6zUc4UfOu9b2n
VWNCNNVCfJ0b1wwUtCp2BqRKqmwHOP2XkXN48b1Csq8+Y5NSBYxxLRXgHd5wT1vV
qysDgSU0ipyyN56o5ocTcfHmBfPDxh4/1Yh8aUaVjhtft8oAJenCEPb3DzEIzYN4
yZUTbr65I8VpYFsE958nx89BFrj7Yy+sa5v/vEmV5YanJRKIkqz2oe/8DCpTLBBm
eP46MbKij6pTuYvAbU8rpJoLQjbqiuIQZ4rjrZxnjbDUyjaO2YUIn3xjgE0G7G+q
CO/5u83lfgwiEA/d3cOX/pZY5OtlVkL5XnuLRB6GDonPscx54/zZ6hlspHdZ8Q4V
GaG8bGWi3+zV4Dn+IpaT
=Taus
-----END PGP SIGNATURE-----

--Signature=_Wed__14_Dec_2011_18_26_43_+1100_z9iCDtW31U/KzCQ0--

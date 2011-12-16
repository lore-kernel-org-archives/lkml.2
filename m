Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751643Ab1LPGA4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 01:00:56 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:37973 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293Ab1LPGAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 01:00:52 -0500
Date: Fri, 16 Dec 2011 17:00:42 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Dec 16
Message-Id: <20111216170042.650147ec79e792dce950f6e3@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__16_Dec_2011_17_00_42_+1100_D_RcPhNxLlIrd5xK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__16_Dec_2011_17_00_42_+1100_D_RcPhNxLlIrd5xK
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20111215:

Undropped tree: target-merge

The scsi tree lost its build failure and a conflict.

The target-merge tree still has a build failure for which I applied a
merge fix patch.

The net-next tree lost a conflict but gained another against the net tree
and lost its build failure.

The sound-asoc tree lost its build.

The block tree gained a build failure so I used the version from
next-20111215.

The iommu tree gained a conflict against the pci-current tree.

The regmap tree still has one build failure so I used the version of the
tree from next-20111214.

The driver-core tree lost its build failure.

The akpm tree gained a conflict against the driver-core tree and a build
failure for which I reverted a commit.

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
Merging origin/master (6f12d2e Merge branch 'linux-next' of git://git.kerne=
l.org/pub/scm/linux/kernel/git/konrad/ibft)
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
Merging sparc/master (b1f44e1 sparc32: Be less strict in matching %lo part =
of relocation.)
Merging scsi-rc-fixes/master (6f6c2aa [SCSI] fcoe: fix fcoe in a DCB enviro=
nment by adding DCB notifiers to set skb priority)
Merging net/master (bb3c368 ipv6: Check dest prefix length on original rout=
e not copied one in rt6_alloc_cow().)
Merging sound-current/for-linus (844ec31 Merge branch 'fix/asoc' into for-l=
inus)
Merging pci-current/for-linus (b51306c PCI: Set device power state to PCI_D=
0 for device without native PM support)
Merging wireless/master (78feb35 iwlwifi: allow to switch to HT40 if not as=
sociated)
Merging driver-core.current/driver-core-linus (dc47ce9 Linux 3.2-rc5)
Merging tty.current/tty-linus (caca6a0 Linux 3.2-rc3)
Merging usb.current/usb-linus (02a551c USB: option: Removing one bogus and =
adding some new Huawei combinations)
Merging staging.current/staging-linus (c7caf4d staging: r8712u: Add new USB=
 ID)
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
Merging arm-soc/for-next (f83ef75 Merge branch 'next/devel' into for-next)
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
Merging blackfin/for-linus (13fc35b blackfin: mac: dsa: add vlan mask in bo=
ard file)
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
Merging ext4/dev (5a0dc73 ext4: handle EOF correctly in ext4_bio_write_page=
())
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
Merging pci/linux-next (770aed2 PCI: kconfig: English typo in pci/pcie/Kcon=
fig)
Merging hid/for-next (aba3b66 Merge branch 'multitouch' into for-next)
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
Merging scsi/master (5c41dc3 [SCSI] lpfc 8.3.28: Update driver version to 8=
.3.28)
Merging target-updates/for-next (6d5b597 target: Remove legacy device statu=
s check from transport_execute_tasks)
Merging target-merge/for-next-merge (e0d85e5 ib_srpt: Initial SRP Target me=
rge for v3.2-rc1)
Applying: linux-next: build failure after merge of the target-merge tree
Merging ibft/linux-next (935a9fe ibft: Fix finding IBFT ACPI table on UEFI)
Merging slave-dma/next (3506c0d DMA: PL330: Remove pm_runtime_xxx calls fro=
m pl330 probe/remove)
CONFLICT (content): Merge conflict in drivers/dma/pl330.c
Merging async_tx/next (21ef4b8 dmaengine: use DEFINE_IDR for static initial=
ization)
Merging net-next/master (bcebcc4 tg3: Break out RSS indir table init and as=
signment)
CONFLICT (content): Merge conflict in net/ipv6/route.c
CONFLICT (content): Merge conflict in net/batman-adv/translation-table.c
CONFLICT (content): Merge conflict in drivers/net/wireless/iwlwifi/iwl-agn.c
Merging wireless-next/master (d66be82 b43: N-PHY: check for bustype before =
touching BCMA CC PLLs)
CONFLICT (content): Merge conflict in drivers/net/wireless/iwlwifi/iwl-agn.c
Merging bluetooth/master (5a13b09 Bluetooth: trivial: correct check for LMP=
 version)
Merging mtd/master (7148b79 mtd: pxa2xx-flash.c: It used to fall back to pr=
ovided table.)
Merging l2-mtd/master (a469923 mtd: document that MEMWRITE ioctl is NAND-sp=
ecific)
CONFLICT (content): Merge conflict in drivers/mtd/bcm63xxpart.c
Merging crypto/master (741e8c2 crypto: convert drivers/crypto/* to use modu=
le_platform_driver())
Merging sound/for-next (1b7ac7c Merge branch 'fix/hda' into for-next)
CONFLICT (content): Merge conflict in arch/arm/mach-s3c64xx/mach-crag6410.c
Merging sound-asoc/for-next (00c6516 ASoC: Staticise mfld_msic_dailink)
Merging cpufreq/next (21f2e3c [CPUFREQ] Remove wall variable from cpufreq_g=
ov_dbs_init())
Merging quilt/rr (2570633 kernel/params: replace DEBUGP with pr_debug)
Merging input/next (246835f Input: wacom - add LED support for Cintiq 24HD)
CONFLICT (content): Merge conflict in drivers/input/keyboard/samsung-keypad=
.c
Merging input-mt/next (02f8c6a Linux 3.0)
Merging lsm/for-next (ca05a99 capabilities: remain source compatible with 3=
2-bit raw legacy capability support.)
Merging block/for-next (954adda Merge branch 'for-3.3/core' into for-next)
$ git reset --hard HEAD^
Merging refs/next/20111215/block
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
Merging md/for-next (91a2f19 md/raid1: Mark device replaceable when we see =
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
Merging regulator/for-next (47aed92 regulator: Update da9052-regulator for =
DT changes)
Merging security/next (735e93c Security: tomoyo: add .gitignore file)
CONFLICT (content): Merge conflict in lib/Makefile
Merging selinux/master (ded5098 SELinux: skip file_name_trans_write() when =
policy downgraded.)
Merging lblnet/master (7e27d6e Linux 2.6.35-rc3)
Merging watchdog/linux-next (80fee40 watchdog: move coh901327 state holders)
Merging bdev/master (feaf384 Merge branch 'for-linus' of git://git.kernel.d=
k/linux-2.6-block)
Merging dwmw2-iommu/master (c3b92c8 Linux 3.1)
Merging iommu/next (bf26934 Merge branches 'iommu/fixes', 'arm/omap', 'x86/=
amd', 'iommu/page-sizes' and 'iommu/group-id' into next)
CONFLICT (content): Merge conflict in include/linux/pci_regs.h
CONFLICT (content): Merge conflict in drivers/pci/hotplug/acpiphp_glue.c
Merging cputime/cputime (c5927fe [S390] cputime: add sparse checking and cl=
eanup)
Merging osd/linux-next (dde406e pnfs-obj: Support for RAID5 read-4-write in=
terface.)
Merging jc_docs/docs-next (5c050fb docs: update the development process doc=
ument)
Merging nommu/master (0ce790e Linux 2.6.39-rc1)
Merging trivial/for-next (cb54f25 btrfs: free-space-cache.c: remove extra s=
emicolon.)
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
Merging tip/auto-latest (2d1f83e Merge branch 'x86/mce' into auto-latest)
CONFLICT (content): Merge conflict in kernel/sched/core.c
CONFLICT (content): Merge conflict in fs/proc/uptime.c
CONFLICT (content): Merge conflict in fs/proc/stat.c
CONFLICT (content): Merge conflict in drivers/macintosh/rack-meter.c
CONFLICT (content): Merge conflict in drivers/cpufreq/cpufreq_ondemand.c
CONFLICT (content): Merge conflict in drivers/cpufreq/cpufreq_conservative.c
Merging rcu/rcu/next (a513f6b cpu: Export cpu_up())
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
Merging xen-two/linux-next (82eab1f Merge branch 'stable/for-linus-fixes-3.=
2' into linux-next)
CONFLICT (content): Merge conflict in arch/x86/xen/Kconfig
Merging xen-pvhvm/linux-next (b056b6a xen: suspend: remove xen_hvm_suspend)
Merging percpu/for-next (9f57bd4 percpu: fix per_cpu_ptr_to_phys() handling=
 of non-page-aligned addresses)
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
Merging regmap/for-next (704867e Merge branch 'mfd/da9052' of git://git.ker=
nel.org/pub/scm/linux/kernel/git/broonie/misc into regmap-next)
CONFLICT (content): Merge conflict in drivers/base/regmap/regmap.c
CONFLICT (content): Merge conflict in drivers/base/regmap/regcache.c
Applying: gpio: disable broken driver
$ git reset --hard HEAD^
Merging refs/next/20111214/regmap
CONFLICT (content): Merge conflict in drivers/base/regmap/regmap.c
CONFLICT (content): Merge conflict in drivers/base/regmap/regcache.c
[master 9ac4ca3] Merge commit 'refs/next/20111214/regmap'
Applying: gpio: disable broken driver
[master ec2f13d] Merge commit 'refs/next/20111214/regmap'
Merging hsi/for-next (a8b4dea HSI: hsi_char: Update ioctl-number.txt)
Merging driver-core/driver-core-next (cb0c05c xen: fix build breakage in xe=
n-selfballoon.c caused by sysdev conversion)
Merging tty/tty-next (6485163 serial: bfin-uart: Remove ASYNC_CTS_FLOW flag=
 for hardware automatic CTS.)
CONFLICT (content): Merge conflict in drivers/tty/serial/Makefile
CONFLICT (content): Merge conflict in drivers/tty/serial/Kconfig
Merging usb/usb-next (121a8cd Merge branch 'for-next/gadget' of git://git.k=
ernel.org/pub/scm/linux/kernel/git/balbi/usb into usb-next)
Merging staging/staging-next (89c5db0 Staging: comedi: fix printk issue in =
contec_pci_dio.c)
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
Merging writeback/writeback-for-next (3de7e9f writeback: do strict bdi dirt=
y_exceeded)
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
Merging xshm/xshm-for-next (e17899e caif-xshm: Add CAIF driver for Shared m=
emory for M7400)
Merging memblock/memblock-kill-early_node_map (7bd0b0f memblock: Reimplemen=
t memblock allocation using reverse free area iterator)
CONFLICT (content): Merge conflict in arch/score/Kconfig
CONFLICT (content): Merge conflict in arch/arm/mm/init.c
Merging remoteproc/for-next (d275b1b samples/rpmsg: add an rpmsg driver sam=
ple)
Applying: rpmsg: rename virtqueue_add_buf_gfp to virtqueue_add_buf
Merging kvmtool/master (102ee3b kvm tools: Get correct 64-bit types on PPC6=
4 and link appropriately)
CONFLICT (content): Merge conflict in scripts/kconfig/Makefile
CONFLICT (content): Merge conflict in include/net/9p/9p.h
Merging uapi/for-next (1632b9e UAPI: Split trivial #if defined(__KERNEL__) =
&& X conditionals)
Merging scsi-post-merge/merge-base:master ()
$ git checkout akpm
Applying: cpusets: stall when updating mems_allowed for mempolicy or disjoi=
nt nodemask
Applying: cpusets-stall-when-updating-mems_allowed-for-mempolicy-or-disjoin=
t-nodemask-fix
Applying: cpusets-stall-when-updating-mems_allowed-for-mempolicy-or-disjoin=
t-nodemask-fix-2
Applying: cpusets-stall-when-updating-mems_allowed-for-mempolicy-or-disjoin=
t-nodemask-fix-2-fix-2
Applying: cpusets-stall-when-updating-mems_allowed-for-mempolicy-or-disjoin=
t-nodemask-fix-2-fix-2-fix
Applying: memcg: add mem_cgroup_replace_page_cache() to fix LRU issue
Applying: nilfs2: unbreak compat ioctl
Applying: nilfs2: potential integer overflow in nilfs_ioctl_clean_segments()
Applying: memcg: keep root group unchanged if creation fails
Applying: oom: fix integer overflow of points in oom_badness
Applying: ipmi_watchdog: restore settings when BMC reset
Applying: vmalloc: Remove static declaration of va from __get_vm_area_node
Applying: binary_sysctl(): fix memory leak
Applying: net/netfilter/nf_conntrack_netlink.c: fix Oops on container destr=
oy
Applying: acerhdf: add support for Aspire 1410 BIOS v1.3314
Applying: acerhdf: add support for new hardware
Applying: acerhdf: lowered default temp fanon/fanoff values
Applying: arch/x86/platform/iris/iris.c: register a platform device and a p=
latform driver
Applying: x86, olpc-xo15-sci: enable lid close wakeup control through sysfs
Applying: x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs-f=
ix
Applying: x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs-v2
Applying: mm/vmalloc.c: eliminate extra loop in pcpu_get_vm_areas error path
Applying: mm-vmallocc-eliminate-extra-loop-in-pcpu_get_vm_areas-error-path-=
fix
Applying: x86, olpc: add debugfs interface for EC commands
Applying: drivers/platform/x86/sony-laptop.c: fix scancodes
Applying: drivers-platform-x86-sony-laptopc-fix-scancodes-checkpatch-fixes
Applying: drivers-platform-x86-sony-laptopc-fix-scancodes-v2
Applying: drivers-platform-x86-sony-laptopc-fix-scancodes-v2-checkpatch-fix=
es
Applying: arch/arm/mach-ux500/mbox-db5500.c: world-writable sysfs fifo file
Applying: arm, exec: remove redundant set_fs(USER_DS)
Applying: hrtimers: Special-case zero length sleeps
Applying: tick-sched: add specific do_timer_cpu value for nohz off mode
CONFLICT (content): Merge conflict in drivers/base/sys.c
Applying: tick-sched: add specific do_timer_cpu value for nohz off mode
Applying: ia64, exec: remove redundant set_fs(USER_DS)
Applying: kconfig: add merge_config.sh script
Applying: merge_config.sh: use signal names compatible with dash and bash
Applying: merge_config.sh: whitespace cleanup
Applying: merge_config.sh: fix bug in final check
Applying: ctags: remove struct forward declarations
Applying: ipc/mqueue: cleanup definition names and locations
Applying: ipc/mqueue: switch back to using non-max values on create
Applying: ipc/mqueue: enforce hard limits
Applying: ipc/mqueue: update maximums for the mqueue subsystem
Applying: ipc-mqueue-update-maximums-for-the-mqueue-subsystem-fix
Applying: ipc-mqueue-update-maximums-for-the-mqueue-subsystem-checkpatch-fi=
xes
Applying: debugobjects: Fix selftest for static warnings
Applying: ext4: use proper little-endian bitops
Applying: parisc, exec: remove redundant set_fs(USER_DS)
Applying: scsi: fix a header to include linux/types.h
Applying: drivers/scsi/megaraid.c: fix sparse warnings
Applying: drivers/scsi/aacraid/commctrl.c: fix mem leak in aac_send_raw_srb=
()
Applying: drivers/scsi/sg.c: convert to kstrtoul_from_user()
Applying: drivers/scsi/mpt2sas/mpt2sas_base.c: fix mismatch in mpt2sas_base=
_hard_reset_handler() mutex lock-unlock
Applying: fs: remove unneeded plug in mpage_readpages()
Applying: MAINTAINERS: Staging: cx25821: Add L: linux-media
Applying: slub: document setting min order with debug_guardpage_minorder > 0
Applying: slub-document-setting-min-order-with-debug_guardpage_minorder-0-c=
heckpatch-fixes
Applying: mm/page-writeback.c: make determine_dirtyable_memory static again
Applying: vmscan: promote shared file mapped pages
Applying: vmscan: activate executable pages after first usage
Applying: mm: add free_hot_cold_page_list() helper
Applying: mm-add-free_hot_cold_page_list-helper-v2
Applying: mm-add-free_hot_cold_page_list-helper-v3
Applying: mm: remove unused pagevec_free
Applying: mm-tracepoint: rename page-free events
Applying: mm-tracepoint: fix documentation and examples
Applying: mm: fix page-faults detection in swap-token logic
Applying: mm: add extra free kbytes tunable
Applying: mm-add-extra-free-kbytes-tunable-update
Applying: mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes
Applying: mm: migrate: one less atomic operation
Applying: mm: do not stall in synchronous compaction for THP allocations
Applying: mm-do-not-stall-in-synchronous-compaction-for-thp-allocations-v3
Applying: mm: reduce the amount of work done when updating min_free_kbytes
Applying: mm-reduce-the-amount-of-work-done-when-updating-min_free_kbytes-c=
heckpatch-fixes
Applying: mm: avoid livelock on !__GFP_FS allocations
Applying: mm: account reaped page cache on inode cache pruning
Applying: hugetlb: detect race upon page allocation failure during COW
Applying: hugetlb: clarify hugetlb_instantiation_mutex usage
Applying: mm/hugetlb.c: fix virtual address handling in hugetlb fault
Applying: mm-hugetlbc-fix-virtual-address-handling-in-hugetlb-fault-fix
Applying: kernel.h: add BUILD_BUG() macro
Applying: kernel.h: Add BUILD_BUG() macro.
Applying: hugetlb: replace BUG() with BUILD_BUG() for dummy definitions
Applying: mm: more intensive memory corruption debugging
Applying: mm-more-intensive-memory-corruption-debug-fix
Applying: PM/Hibernate: do not count debug pages as savable
Applying: slub: min order when debug_guardpage_minorder > 0
Applying: fadvise: only initiate writeback for specified range with FADV_DO=
NTNEED
Applying: mm, debug: test for online nid when allocating on single node
Applying: vmscan: add task name to warn_scan_unevictable() messages
Applying: mm: exclude reserved pages from dirtyable memory
Applying: mm-exclude-reserved-pages-from-dirtyable-memory-fix
Applying: mm: writeback: cleanups in preparation for per-zone dirty limits
Applying: mm: try to distribute dirty pages fairly across zones
Applying: mm: filemap: pass __GFP_WRITE from grab_cache_page_write_begin()
Applying: Btrfs: pass __GFP_WRITE for buffered write page allocations
Applying: mm: compaction: push isolate search base of compact control one p=
fn ahead
Applying: bootmem: micro optimize freeing pages in bulk
Applying: mm: fix off-by-two in __zone_watermark_ok()
Applying: mremap: enforce rmap src/dst vma ordering in case of vma_merge() =
succeeding in copy_vma()
Applying: mremap-enforce-rmap-src-dst-vma-ordering-in-case-of-vma_merge-suc=
ceeding-in-copy_vma-update
Applying: mm: simplify find_vma_prev()
Applying: mm-simplify-find_vma_prev-fix
Applying: mm: simplify find_vma_prev
Applying: tracepoint: add tracepoints for debugging oom_score_adj
Applying: hpet: factor timer allocate from open
Applying: intel_idle: fix API misuse
Applying: intel_idle: disable auto_demotion for hotplugged CPUs
Applying: kernel.h: neaten panic prototype
Applying: include/linux/linkage.h: remove unused NORET_AND macro
Applying: treewide: remove useless NORET_TYPE macro and uses
Applying: treewide: convert uses of ATTRIB_NORETURN to __noreturn
Applying: treewide-convert-uses-of-attrib_noreturn-to-__noreturn-checkpatch=
-fixes
Applying: include/linux/linkage.h: remove unused ATTRIB_NORET macro
Applying: mm,slub,x86: decouple size of struct page from CONFIG_CMPXCHG_LOC=
AL
Applying: mm,x86,um: move CMPXCHG_LOCAL config option
Applying: mm,x86,um: move CMPXCHG_DOUBLE config option
Applying: audit: always follow va_copy() with va_end()
Applying: brlocks/lglocks: clean up code
Applying: brlocks-lglocks-clean-up-code-checkpatch-fixes
Applying: ceph, cifs, nfs, fuse: boolean and / or confusion
Applying: core kernel: add refcount type and refcount misuse debugging
Applying: pipe: fail cleanly when root tries F_SETPIPE_SZ with big size
Applying: get_maintainers.pl: follow renames when looking up commit signers
Applying: MAINTAINERS: update various arm F: patterns
Applying: MAINTAINERS: update adp gpio F: patterns
Applying: MAINTAINERS: update bt8xx gpio F: patterns
Applying: MAINTAINERS: update marvell ccic F: patterns
Applying: MAINTAINERS: update mfd F: patterns
Applying: MAINTAINERS: update sdhci F: patterns
Applying: MAINTAINERS: update tulip F: patterns
Applying: MAINTAINERS: update greth F: patterns
Applying: MAINTAINERS: update encrypted-keys F: patterns
Applying: MAINTAINERS: staging: media: update F: patterns
Applying: MAINTAINERS: serial:blackfin: update F: pattern
Applying: MAINTAINERS: spi: update F: patterns
Applying: devfreq: add devfreq maintainer entry
Applying: backlight: remove ADX backlight device support
Applying: backlight: convert drivers/video/backlight/* to use module_platfo=
rm_driver()
Applying: backlight/ld9040.c: regulator control in the driver
Applying: drivers/video/backlight/ep93xx_bl.c: remove duplicated header inc=
lude
Applying: leds: convert led platform drivers to module_platform_driver
Applying: leds: convert led i2c drivers to module_i2c_driver
Applying: leds: convert leds-dac124s085 to module_spi_driver
Applying: drivers/leds/leds-lp5523.c: remove unneeded forward declaration
Applying: drivers/leds/leds-bd2802.c: use gpio_request_one()
Applying: drivers/leds/leds-netxbig.c: use gpio_request_one()
Applying: leds: add driver for TCA6507 LED controller
Applying: leds-add-driver-for-tca6507-led-controller-fix
Applying: leds-add-driver-for-tca6507-led-controller-checkpatch-fixes
Applying: drivers/leds/leds-mc13783.c: fix off-by-one for checking num_leds
Applying: checkpatch: update signature "might be better as" warning
Applying: checkpatch: prefer __printf over __attribute__((format(printf,...=
)))
Applying: checkpatch: correctly track the end of preprocessor commands in c=
ontext
Applying: checkpatch: fix up complex macros context format
Applying: checkpatch: check for common memset parameter issues against stat=
ments
Applying: checkpatch: improve memset and min/max with cast checking
Applying: checkpatch-improve-memset-and-min-max-with-cast-checking-fix
Applying: checkpatch: ## is not a valid modifier
Applying: checkpatch: optimise statement scanner when mid-statement
Applying: checkpatch: only apply kconfig help checks for options which prom=
pt
Applying: checkpatch: fix EXPORT_SYMBOL handling following a function
Applying: checkpatch: complex macro should allow the empty do while loop
Applying: checkpatch: fix 'return is not a function' square bracket handling
Applying: checkpatch: fix complex macros handling of square brackets
Applying: checkpatch: ensure cast type is unique in the context parser
Applying: checkpatch: typeof may have more complex arguments
Applying: checkpatch: catch all occurences of type and cast spacing errors =
per line
Applying: checkpatch-catch-all-occurances-of-type-and-cast-spacing-errors-p=
er-line-checkpatch-fixes
Applying: crc32: optimize inner loop
Applying: epoll: limit paths
Applying: fs: binfmt_elf: create Kconfig variable for PIE randomization
Applying: MIPS: randomize PIE load address
Applying: init/do_mounts.c: create /root if it does not exist
Applying: drivers/rtc/rtc-cmos.c: fix broken NVRAM bank 2 writing
Applying: drivers/rtc/rtc-mxc.c: fix setting time for MX1 SoC
Applying: drivers-rtc-rtc-mxcc-fix-setting-time-for-mx1-soc-fix
Applying: drivers/rtc/rtc-mxc.c: make alarm work
Applying: drivers-rtc-rtc-mxcc-make-alarm-work-fix
Applying: rtc/ab8500: don't disable IRQ:s when suspending
Applying: rtc/ab8500: set can_wake flag
Applying: drivers/rtc/rtc-ab8500.c: change msleep() to usleep_range()
Applying: rtc/ab8500: add calibration attribute to AB8500 RTC
Applying: rtc-ab8500-add-calibration-attribute-to-ab8500-rtc-checkpatch-fix=
es
Applying: rtc-ab8500-add-calibration-attribute-to-ab8500-rtc-v3
Applying: rtc-ab8500-add-calibration-attribute-to-ab8500-rtc-v3-checkpatch-=
fixes
Applying: drivers/rtc/rtc-wm831x.c: remove unused period IRQ handler
Applying: drivers/rtc/rtc-wm831x.c: convert to devm_kzalloc()
Applying: reiserfs: delete comments refering to the BKL
Applying: reiserfs: delay reiserfs lock until journal initialization
Applying: reiserfs: don't lock journal_init()
Applying: reiserfs: don't lock root inode searching
Applying: cpusets, cgroups: disallow attaching kthreadd
Applying: mm: memcg: consolidate hierarchy iteration primitives
Applying: mm: vmscan: distinguish global reclaim from global LRU scanning
Applying: mm: vmscan: distinguish between memcg triggering reclaim and memc=
g being scanned
Applying: mm-vmscan-distinguish-between-memcg-triggering-reclaim-and-memcg-=
being-scanned-checkpatch-fixes
Applying: mm: memcg: per-priority per-zone hierarchy scan generations
Applying: mm: move memcg hierarchy reclaim to generic reclaim code
Applying: mm: memcg: remove optimization of keeping the root_mem_cgroup LRU=
 lists empty
Applying: mm: vmscan: convert global reclaim to per-memcg LRU lists
Applying: mm: collect LRU list heads into struct lruvec
Applying: mm: make per-memcg LRU lists exclusive
Applying: mm: memcg: remove unused node/section info from pc->flags
Applying: mm: memcg: remove unused node/section info from pc->flags fix
Applying: memcg: make mem_cgroup_split_huge_fixup() more efficient
Applying: memcg-make-mem_cgroup_split_huge_fixup-more-efficient-fix
Applying: mm: memcg: shorten preempt-disabled section around event checks
Applying: Documentation/cgroups/memory.txt: fix typo
Applying: memcg: fix pgpgin/pgpgout documentation
Applying: mm: oom_kill: remove memcg argument from oom_kill_task()
Applying: mm: unify remaining mem_cont, mem, etc. variable names to memcg
Applying: mm: memcg: clean up fault accounting
Applying: mm: memcg: lookup_page_cgroup (almost) never returns NULL
Applying: mm: page_cgroup: check page_cgroup arrays in lookup_page_cgroup()=
 only when necessary
Applying: mm: memcg: remove unneeded checks from newpage_charge()
Applying: mm: memcg: remove unneeded checks from uncharge_page()
Applying: page_cgroup: add helper function to get swap_cgroup
Applying: page_cgroup: cleanup lookup_swap_cgroup()
Applying: memcg: free entries in soft_limit_tree if allocation fails
Applying: oom, memcg: fix exclusion of memcg threads after they have detach=
ed their mm
Applying: thp: improve the error code path
Applying: thp: remove unnecessary tlb flush for mprotect
Applying: thp: add tlb_remove_pmd_tlb_entry
Applying: thp: improve order in lru list for split huge page
Applying: procfs: make proc_get_link to use dentry instead of inode
Applying: procfs: introduce the /proc/<pid>/map_files/ directory
Applying: procfs-introduce-the-proc-pid-map_files-directory-checkpatch-fixes
Applying: procfs: parse mount options
Applying: procfs: add hidepid=3D and gid=3D mount options
Applying: procfs: remove superfluous debug output
Applying: proc: fix task_struct memleak
Applying: workqueue: make alloc_workqueue() take printf fmt and args for na=
me
Applying: workqueue-make-alloc_workqueue-take-printf-fmt-and-args-for-name-=
fix
Applying: cpumask: update setup_node_to_cpumask_map() comments
Applying: kexec: remove KMSG_DUMP_KEXEC
Applying: kdump: add missing RAM resource in crash_shrink_memory()
Applying: kdump: add udev events for memory online/offline
Applying: kdump: crashk_res init check for /sys/kernel/kexec_crash_size
Applying: kdump: fix crash_kexec()/smp_send_stop() race in panic()
Applying: ipc/mqueue: simplify reading msgqueue limit
Applying: ipc/sem.c: alternatives to preempt_disable()
Applying: sysctl: add the kernel.ns_last_pid control
Applying: user namespace: make signal.c respect user namespaces
Applying: __send_signal: pass q->info, not info, to userns_fixup_signal_uid=
 (v2)
Applying: ipc/mqueue: lock() =3D> unlock() typo
Applying: drivers/memstick: use kmemdup rather than duplicating its impleme=
ntation
Applying: fs/direct-io.c: calculate fs_count correctly in get_more_blocks()
Applying: vfs: cache request_queue in struct block_device
Applying: dio: optimize cache misses in the submission path
Applying: dio-optimize-cache-misses-in-the-submission-path-v2-checkpatch-fi=
xes
Applying: dio: using prefetch requires including prefetch.h
Applying: c/r: introduce CHECKPOINT_RESTORE symbol
Applying: c/r: procfs: add start_data, end_data, start_brk members to /proc=
/$pid/stat v4
Applying: c-r-procfs-add-start_data-end_data-start_brk-members-to-proc-pid-=
stat-v4-fix
Applying: c/r: prctl: add PR_SET_MM codes to set up mm_struct entries
Applying: c-r-prctl-add-pr_set_mm-codes-to-set-up-mm_struct-entries-fix
Applying: ramoops: fix use of rounddown_pow_of_two()
Applying: ramoops: update parameters only after successful init
Applying: unlzo: Fix input buffer free
Merging akpm (f3dd800 unlzo: Fix input buffer free)
[master d01b1ac] Revert "core kernel: add refcount type and refcount misuse=
 debugging"

--Signature=_Fri__16_Dec_2011_17_00_42_+1100_D_RcPhNxLlIrd5xK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO6t6KAAoJEECxmPOUX5FEb4MP/01MAHXaKBgEcmuSoeDaqI4p
qW2clgjJDNgpcwwhjhNtES6+tQPy9OoawWBAIWuwe/EcfdCC30R+wBQUh4rde+ey
DrwwUicy3eQLFE2DWWrro2dKqh2rQvTm3HPyIoQBpHIL9Ph90uB3jlJQ9aJ29uLb
tP2zsg5mEnPivno39E6umY/pMNDwQz1JzHO373S7zbX54FH+OEYDqNfWgQ6LG4Cx
1DMD/3NrqaqQ9jqql39PGPHhETelYL7Ke0tlevAvzdwVEDOJi4hna2Kj7ZRdjhkH
vz+7oAHxmBswD/ODLMKFVqDrjy3VckcqxWOnulsmimRJh5FRz8snzCKlE53tRCgq
e3k+3nr6qwgfAjZ31uxbtQ3CF4LNtQS3tuKGj7IQwMrG7LjrKfopqhhjhq2AlArC
PHsOi3Eatjnb9CcXq67jmJCutIjNlCV1GOH2CeVDE+PJQ9gjwbGtxOmofr6WnsdI
AqgBa97EMhgrUo/49HEsPnKDvb72fxGrea423rJvjkpDC95H4+skZhiSkcYpplax
5NOQXbLH8qE0+YjfuEMvOZKE7u/emNhKQK8SH3mR1TUjpoycmlN13NvwKTUMOdc1
KjzbVB3ZGS9WrvS9t/HfjmaknnhcobYJaAlnFwYbnoZoyP5iwVV1oWmJrWJavrLo
VSxoc6tcuvlalqOnLwOk
=5Vpw
-----END PGP SIGNATURE-----

--Signature=_Fri__16_Dec_2011_17_00_42_+1100_D_RcPhNxLlIrd5xK--

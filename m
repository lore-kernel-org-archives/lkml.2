Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751574Ab1LIFc6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 00:32:58 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:58156 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886Ab1LIFcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 00:32:54 -0500
Date: Fri, 9 Dec 2011 16:32:47 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Dec 9
Message-Id: <20111209163247.1de15dcb5b735ca5e1ad030b@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__9_Dec_2011_16_32_47_+1100_V38_z4WHkzS6Iwx6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__9_Dec_2011_16_32_47_+1100_V38_z4WHkzS6Iwx6
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20111208:

Undropped tree: memblock

The tegra tree gained conflicts against the arm tree.

The 4xx tree gained a conflict against the powerpc tree.

The memblock tree lost its build failure.

The akpm tree gained a conflict against the memblock tree and a build
failure for which I reverted 2 commits.

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

We are up to 203 trees (counting Linus' and 27 trees of patches pending
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
Merging origin/master (09d9673 Merge branch 'timers-urgent-for-linus' of gi=
t://git.kernel.org/pub/scm/linux/kernel/git/tip/tip)
Merging fixes/master (aaa0b4f iio: iio_event_getfd -- fix ev_int build fail=
ure)
Merging kbuild-current/rc-fixes (44656fa kbuild: Fix missing system calls c=
heck on mips.)
Merging arm-current/fixes (6bd0540 ARM: 7185/1: perf: don't assign platform=
_device on unsupported CPUs)
Merging m68k-current/for-linus (5bf1e97 m68k: Wire up process_vm_{read,writ=
e}v)
Merging powerpc-merge/merge (49e4406 powerpc/44x: Add mtd ndfc to the ppx44=
x defconfig)
Merging 52xx-and-virtex-current/powerpc/merge (c49f878 dtc/powerpc: remove =
obsolete .gitignore entries)
Merging sparc/master (dbf2b92 sbus: convert drivers/sbus/char/* to use modu=
le_platform_driver())
Merging scsi-rc-fixes/master (e5a44df [SCSI] hpsa: Disable ASPM)
Merging net/master (1af32f0 Merge branch 'batman-adv/maint' of git://git.op=
en-mesh.org/linux-merge)
Merging sound-current/for-linus (0a34b42 ALSA: hda/realtek - Fix lost speak=
er volume controls)
Merging pci-current/for-linus (8c45194 PCI: fix ats compile failure)
Merging wireless/master (329456d ssb: fix init regression with SoCs)
Merging driver-core.current/driver-core-linus (caca6a0 Linux 3.2-rc3)
Merging tty.current/tty-linus (caca6a0 Linux 3.2-rc3)
Merging usb.current/usb-linus (8593b6f Merge branch 'for-usb-linus' of git:=
//git.kernel.org/pub/scm/linux/kernel/git/sarah/xhci into usb-linus)
Merging staging.current/staging-linus (34a9d2c Merge branch '3.2-rc-fixes' =
of git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending)
Merging char-misc.current/char-misc-linus (caca6a0 Linux 3.2-rc3)
Merging cpufreq-current/fixes (5983fe2 Merge git://git.kernel.org/pub/scm/l=
inux/kernel/git/davem/net)
Merging input-current/for-linus (77f6ca5 Input: ams_delta_serio - include l=
inux/module.h)
Merging md-current/for-linus (9283d8c md/raid5: never wait for bad-block ac=
ks on failed device.)
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
Merging devicetree-current/devicetree/merge (50e07f8 dt: add empty of_machi=
ne_is_compatible)
Merging spi-current/spi/merge (940ab88 drivercore: Add helper macro for pla=
tform_driver boilerplate)
Merging arm/for-next (c23b458 Merge branch 'restart' into for-next)
CONFLICT (content): Merge conflict in arch/arm/mach-mxs/mach-stmp378x_devb.c
CONFLICT (content): Merge conflict in arch/arm/mach-mxs/mach-m28evk.c
Merging arm-lpae/for-next (cf9a53f ARM: LPAE: Add the Kconfig entries)
CONFLICT (content): Merge conflict in arch/arm/mm/ioremap.c
CONFLICT (content): Merge conflict in arch/arm/mm/idmap.c
Merging arm-soc/for-next (1fc27d6 Merge branch 'fixes' into for-next)
CONFLICT (content): Merge conflict in arch/arm/mach-mxs/include/mach/common=
.h
CONFLICT (content): Merge conflict in arch/arm/mach-at91/setup.c
CONFLICT (content): Merge conflict in arch/arm/mach-at91/at91sam9rl.c
CONFLICT (content): Merge conflict in arch/arm/mach-at91/at91sam9g45.c
CONFLICT (content): Merge conflict in arch/arm/mach-at91/at91sam9263.c
CONFLICT (content): Merge conflict in arch/arm/mach-at91/at91sam9261.c
CONFLICT (content): Merge conflict in arch/arm/mach-at91/at91sam9260.c
CONFLICT (content): Merge conflict in arch/arm/mach-at91/at91cap9.c
Merging arm-perf/for-next/perf (c0b91d4 Merge branches 'perf/event-nos', 'p=
erf/omap4' and 'perf/updates' into for-next/perf)
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
Merging s5p/for-next (d3d936c Merge branch 'samsung-fixes-2' into for-next)
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
Merging m68k/for-next (9b4b926 m68k: Don't comment out syscalls used by gli=
bc)
Merging m68knommu/for-next (1c054ea m68knommu: remove unused anchor.h inclu=
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
Merging 4xx/next (f1ab937 MAINTAINERS: Update PowerPC 4xx git tree)
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
Merging cifs/master (138514b cifs: check for NULL last_entry before calling=
 cifs_save_resume_key)
Merging configfs/linux-next (b930c26 Merge branch 'for-linus' of git://git.=
kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (aaef29d eCryptfs: Flush file in vma close)
Merging ext3/for_next (ed47a7d udf: Cleanup metadata flags handling)
Merging ext4/dev (4c81f04 ext4: fix racy use-after-free in ext4_end_io_dio(=
))
Merging fatfs/master (710d440 fat: fat16 support maximum 4GB file/vol size =
as WinXP or 7.)
Merging fuse/for-next (7818d5e cuse: implement memory mapping)
Merging gfs2/master (46cc1e5 GFS2: local functions should be static)
Merging hfsplus/for-next (6596528 hfsplus: ensure bio requests are not smal=
ler than the hardware sectors)
Merging jfs/next (1c8007b jfs: flush journal completely before releasing me=
tadata inodes)
Merging logfs/master (21f3eb8 logfs: update page reference count for pined =
pages)
CONFLICT (content): Merge conflict in fs/logfs/file.c
Merging nfs/linux-next (111d489 NFSv4.1: Ensure that we handle _all_ SEQUEN=
CE status bits.)
Merging nfsd/nfsd-next (f5c8593b NFSd: use network-namespace-aware cache re=
gistering routines)
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
Merging pci/linux-next (1764d2c PCI: kconfig: English typo in pci/pcie/Kcon=
fig)
Merging hid/for-next (92a0db5 Merge branch 'roccat' into for-next)
Merging quilt/i2c (78f8424 i2c-ali1535: enable SPARC support)
Merging bjdooks-i2c/next-i2c (f8420b7 fixup merge)
CONFLICT (add/add): Merge conflict in drivers/i2c/busses/i2c-designware-pla=
tdrv.c
Merging quilt/jdelvare-hwmon (dda4fa1 hwmon: (lm63) Add support for LM96163)
Merging hwmon-staging/hwmon-next (45d9744 hwmon: (pmbus/zl6100) Only instan=
tiate external temperature sensor if enabled)
Merging quilt/kernel-doc (c3b92c8 Linux 3.1)
Merging docs/docs-move (5c24d8b Merge branch 'docs/docbook/drm' of git://gi=
thub.com/mfwitten/linux into docs-move)
Merging v4l-dvb/master (ed3825f Merge branch 'poll-pwc2' of /home/v4l/v4l/p=
atchwork)
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
Merging scsi/master (f7c9c6b [SCSI] Fix block queue and elevator memory lea=
k in scsi_alloc_sdev)
Merging target-updates/for-next (5bda90c target: use ->exectute_task for al=
l CDB emulation)
Merging target-merge/for-next-merge (e0d85e5 ib_srpt: Initial SRP Target me=
rge for v3.2-rc1)
Merging slave-dma/next (3506c0d DMA: PL330: Remove pm_runtime_xxx calls fro=
m pl330 probe/remove)
CONFLICT (content): Merge conflict in drivers/dma/pl330.c
Merging async_tx/next (21ef4b8 dmaengine: use DEFINE_IDR for static initial=
ization)
Merging net-next/master (f33f1fc bnx2x: fix typo in fcoe stats collection)
CONFLICT (content): Merge conflict in drivers/net/ethernet/freescale/fsl_pq=
_mdio.c
Merging wireless-next/master (f589cf4 Merge branch 'wl12xx-next' into for-l=
inville)
Merging bluetooth/master (5a13b09 Bluetooth: trivial: correct check for LMP=
 version)
Merging mtd/master (7148b79 mtd: pxa2xx-flash.c: It used to fall back to pr=
ovided table.)
Merging l2-mtd/master (af64b37 mtdoops: fix the oops_page_used array size)
CONFLICT (content): Merge conflict in drivers/mtd/bcm63xxpart.c
Merging crypto/master (741e8c2 crypto: convert drivers/crypto/* to use modu=
le_platform_driver())
Merging sound/for-next (14f45e1 Merge branch 'topic/hda' into for-next)
CONFLICT (content): Merge conflict in arch/arm/mach-s3c64xx/mach-crag6410.c
Merging sound-asoc/for-next (7b9b5e1 ASoC: Tegra: Move DAS configuration in=
to DAS driver)
Merging cpufreq/next (b191c54 Merge branch 'for_3.3/omap-cpufreq' of git://=
git.kernel.org/pub/scm/linux/kernel/git/khilman/linux-omap-pm into next)
Merging quilt/rr (bbdfe28 lguest: switch segment-voodoo-numbers to readable=
 symbols)
Merging input/next (e23ed60 Input: htcpen - switch to DMI-based autoloading)
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
Merging kgdb/kgdb-next (880ba69 lib: rename pack_hex_byte() to hex_byte_pac=
k())
Merging slab/for-next (7436099 Merge branch 'slab/next' into for-next)
Merging uclinux/for-next (5e442a4 Revert "proc: fix races against execve() =
of /proc/PID/fd**")
Merging md/for-next (c347124 md/raid1: Mark device replaceable when we see =
a write error.)
Merging mfd/for-next (b958f7a mfd: Fix missing abx500 header file updates)
Merging hdlc/hdlc-next (4a6908a Linux 2.6.28)
Merging drm/drm-next (4b35130 Merge branch 'drm-fixes' of /home/airlied/dev=
el/kernel/linux-2.6/ into drm-core-next)
Merging fbdev/fbdev-next (f940b88 video: s3c2410: fix checkpatch error and =
warnings)
Merging viafb/viafb-next (4ce36bb viafb: replace strict_strtoul to kstrto* =
and check return value)
Merging omap_dss2/for-next (3e28189 OMAPDSS: picodlp: add missing #include =
<linux/module.h>)
Merging regulator/for-next (2f288ef Merge branch 'topic/dt' of git://git.ke=
rnel.org/pub/scm/linux/kernel/git/broonie/regulator into regulator-next)
Merging security/next (143b01d evm: prevent racing during tfm allocation)
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
Merging trivial/for-next (a1d51aa sis900: Fix enum typo 'sis900_rx_bufer_st=
atus')
CONFLICT (content): Merge conflict in net/mac80211/work.c
CONFLICT (content): Merge conflict in arch/powerpc/platforms/40x/Kconfig
Merging audit/for-next (def5754 Audit: remove spaces from audit_log_d_path)
Merging pm/linux-next (f94ce6d PM / Hibernate: Remove deprecated hibernatio=
n snapshot ioctls)
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
Merging gpio/gpio/next (d92ef29 h8300: Move gpio.h to gpio-internal.h)
Merging tip/auto-latest (088f5f2 Merge branch 'x86/asm' into auto-latest)
CONFLICT (content): Merge conflict in kernel/sched/core.c
CONFLICT (content): Merge conflict in fs/proc/uptime.c
CONFLICT (content): Merge conflict in fs/proc/stat.c
CONFLICT (content): Merge conflict in drivers/macintosh/rack-meter.c
CONFLICT (content): Merge conflict in drivers/cpufreq/cpufreq_ondemand.c
CONFLICT (content): Merge conflict in drivers/cpufreq/cpufreq_conservative.c
Merging rcu/rcu/next (afe24b1 rcu: Move propagation of ->completed from rcu=
_start_gp() to rcu_report_qs_rsp())
Merging uprobes/for-next (b23a347 x86: skip singlestep where possible)
Merging cgroup/for-next (a34815b Merge branch 'for-3.2-fixes' of git://git.=
kernel.org/pub/scm/linux/kernel/git/tj/cgroup)
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
Merging hsi/for-next (a8b4dea HSI: hsi_char: Update ioctl-number.txt)
Merging driver-core/driver-core-next (11e3123 uio: convert drivers/uio/* to=
 use module_platform_driver())
Merging tty/tty-next (7962fce tty: n_hdlc not atomic use tty->flags.)
CONFLICT (content): Merge conflict in drivers/tty/serial/Makefile
CONFLICT (content): Merge conflict in drivers/tty/serial/Kconfig
Merging usb/usb-next (b870def USB: ohci-s3c2410: add PM support)
Merging staging/staging-next (f7f9f45 drm/omap: add GEM support for tiled/d=
mm buffers)
CONFLICT (content): Merge conflict in drivers/staging/iio/industrialio-core=
.c
CONFLICT (content): Merge conflict in drivers/staging/iio/adc/ad799x_core.c
CONFLICT (content): Merge conflict in drivers/staging/hv/Makefile
CONFLICT (content): Merge conflict in drivers/staging/hv/Kconfig
CONFLICT (rename/delete): drivers/hid/hid-hyperv.c deleted in staging/stagi=
ng-next and renamed in HEAD. Version HEAD of drivers/hid/hid-hyperv.c left =
in tree.
Merging char-misc/char-misc-next (7f3379d misc: ad525x_dpot: Add support fo=
r SPI module device table matching)
Merging bkl-config/config (4ba8216 BKL: That's all, folks)
Merging tmem/tmem (665c1e6 mm: cleancache: Use __read_mostly as appropiate.)
CONFLICT (content): Merge conflict in mm/swapfile.c
Merging writeback/writeback-for-next (d2c3f73 writeback: Include all dirty =
inodes in background writeback)
Merging arm-dt/devicetree/arm-next (ede338f dt: add documentation of ARM dt=
 boot interface)
Merging hwspinlock/linux-next (8b37fcf hwspinlock: add MAINTAINERS entries)
Merging pinctrl/for-next (9b8da76 pinctrl: add a pin config interface)
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
Merging kvmtool/master (eff4e92 kvm tools: Correctly limit nrcpus to max_cp=
us)
CONFLICT (content): Merge conflict in scripts/kconfig/Makefile
CONFLICT (content): Merge conflict in include/net/9p/9p.h
Merging scsi-post-merge/merge-base:master ()
$ git checkout akpm
Applying: vmscan: fix initial shrinker size handling
Applying: vmscan: use atomic-long for shrinker batching
Applying: fs/proc/meminfo.c: fix compilation error
Applying: thp: reduce khugepaged freezing latency
Applying: CREDITS: update Kees's expired fingerprint and fix details
Applying: drivers/rtc/rtc-s3c.c: fix driver clock enable/disable balance is=
sues
Applying: memcg: update maintainers
Applying: printk: avoid double lock acquire
Applying: thp: add compound tail page _mapcount when mapped
Applying: thp: set compound tail page _count to zero
Applying: mm/migrate.c: pair unlock_page() and lock_page() when migrating h=
uge pages
Applying: mm: Ensure that pfn_valid() is called once per pageblock when res=
erving pageblocks
Applying: cpusets: stall when updating mems_allowed for mempolicy or disjoi=
nt nodemask
Applying: cpusets-stall-when-updating-mems_allowed-for-mempolicy-or-disjoin=
t-nodemask-fix
Applying: mm: vmalloc: check for page allocation failure before vmlist inse=
rtion
Applying: procfs: do not overflow get_{idle,iowait}_time for nohz
Applying: rapidio/tsi721: switch to dma_zalloc_coherent
Applying: rapidio/tsi721: fix mailbox resource reporting
Applying: rapidio/tsi721: modify PCIe capability settings
Applying: sys_getppid: add missing rcu_dereference
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
Applying: ext4: use proper little-endian bitops
Applying: parisc, exec: remove redundant set_fs(USER_DS)
Applying: scsi: fix a header to include linux/types.h
Applying: drivers/scsi/megaraid.c: fix sparse warnings
Applying: drivers/scsi/aacraid/commctrl.c: fix mem leak in aac_send_raw_srb=
()
Applying: drivers/scsi/sg.c: convert to kstrtoul_from_user()
Applying: drivers/scsi/mpt2sas/mpt2sas_base.c: fix mismatch in mpt2sas_base=
_hard_reset_handler() mutex lock-unlock
Applying: drivers/message/fusion/mptbase.c: ensure NUL-termination of MptCa=
llbacksName elements
Applying: fs: remove unneeded plug in mpage_readpages()
Applying: MAINTAINERS: Staging: cx25821: Add L: linux-media
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
Applying: mm: fix off-by-two in __zone_watermark_ok()
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
Applying: include/log2.h: fix rounddown_pow_of_two(1)
Applying: get_maintainers.pl: follow renames when looking up commit signers
Applying: backlight: remove ADX backlight device support
Applying: backlight: convert drivers/video/backlight/* to use module_platfo=
rm_driver()
Applying: leds: convert led platform drivers to module_platform_driver
Applying: leds: convert led i2c drivers to module_i2c_driver
Applying: leds: convert leds-dac124s085 to module_spi_driver
Applying: drivers/leds/leds-lp5523.c: remove unneeded forward declaration
Applying: drivers/leds/leds-bd2802.c: use gpio_request_one()
Applying: drivers/leds/leds-netxbig.c: use gpio_request_one()
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
Applying: checkpatch: catch all occurances of type and cast spacing errors =
per line
Applying: checkpatch-catch-all-occurances-of-type-and-cast-spacing-errors-p=
er-line-checkpatch-fixes
Applying: crc32: optimize inner loop
Applying: epoll: limit paths
Applying: fs: binfmt_elf: create Kconfig variable for PIE randomization
Applying: MIPS: randomize PIE load address
CONFLICT (content): Merge conflict in arch/mips/Kconfig
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
Applying: cgroups: add res_counter_write_u64() API
Applying: cgroups: new resource counter inheritance API
Applying: cgroups: add previous cgroup in can_attach_task/attach_task callb=
acks
Applying: cgroups: new cancel_attach_task() subsystem callback
Applying: cgroups: ability to stop res charge propagation on bounded ancest=
or
Applying: cgroups: add res counter common ancestor searching
Applying: res_counter: allow charge failure pointer to be null
Applying: cgroups: pull up res counter charge failure interpretation to cal=
ler
Applying: cgroups: allow subsystems to cancel a fork
Applying: cgroups: add a task counter subsystem
Applying: cgroups: ERR_PTR needs err.h
Applying: cgroup: Fix task counter common ancestor logic
Applying: cgroup-fix-task-counter-common-ancestor-logic-checkpatch-fixes
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
Applying: ramoops: fix use of rounddown_pow_of_two()
Applying: ramoops: update parameters only after successful init
Applying: unlzo: Fix input buffer free
Applying: cpusets-stall-when-updating-mems_allowed-for-mempolicy-or-disjoin=
t-nodemask-fix-2
Applying: cpusets-stall-when-updating-mems_allowed-for-mempolicy-or-disjoin=
t-nodemask-fix-2-fix
Merging akpm (496f482 cpusets-stall-when-updating-mems_allowed-for-mempolic=
y-or-disjoint-nodemask-fix-2-fix)
[master 4d4d635] Revert "cpusets-stall-when-updating-mems_allowed-for-mempo=
licy-or-disjoint-nodemask-fix-2-fix"
[master fb4146b] Revert "cpusets-stall-when-updating-mems_allowed-for-mempo=
licy-or-disjoint-nodemask-fix-2"

--Signature=_Fri__9_Dec_2011_16_32_47_+1100_V38_z4WHkzS6Iwx6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO4Z1/AAoJEECxmPOUX5FE/8AQAKRvvac/S/fSvk1plDtbNkBE
V0F0UvwtVu1n7hglA0r3IX7pFoHDcClQ4/2Z3jF7pOyIJg3KlAvNzF4R7YpZCQCx
cp2L+PMUKv5B3Pu9PtkhJpawMLv97aGLiezTGx42gl88/JgvKr/ZV3nb4Ll/5hnJ
weD6YeKZ/x+/qgfXoy1axGkDTwU2F0OO8+oeNw9U2s+oTVMSpti+MWN1OR+/7Iw6
nDyuS9vq5A5y9bl8nyo3kpHxurMRV7T1nMIIKnqzUkf9Ab5aV9LFliBxsG7a8d6h
RXWlA7AQq7BgDXvFfu7qTKX43z6p1jAizWaqIPZdSGQYGzHwKG55HjT4z7WAeIMJ
Byxfgj9++CkN8V9hvEc/2OXsGYYi5oS9R5HAHHaxwAQ8i7iawWu1WMEs4NgLwFmZ
bvg0UVlI3cdMUsM79ONs0xYmtAKxxkbAXsleXhUn76aVz7uzawZEv12BcJH1WPck
qnf4WK04ToEz8Sf9FqW4KOqt+B7qhE+RLntDXKfaQasSZHBzQq2uik1hYcUDoVNi
ARA0tLzd7fW4gQWUF/OsiAQNOONkVP+Sh5PC5OI2cOmGfvpNUBC5RZExWUey5i3+
t6sR6501ZfRGaptbKluXUtKIHEbSOMOQsfVhS12Cw+5kw+f7WskvOfflgwRUgnMu
UGuSYJSjgkrhUIQok9Qd
=qyfx
-----END PGP SIGNATURE-----

--Signature=_Fri__9_Dec_2011_16_32_47_+1100_V38_z4WHkzS6Iwx6--

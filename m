Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599Ab2AWDMK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 22:12:10 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:47150 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752030Ab2AWDMF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 22:12:05 -0500
Date: Mon, 23 Jan 2012 14:11:55 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Jan 23
Message-Id: <20120123141155.3e6b665ef655e267f25d4e7f@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__23_Jan_2012_14_11_55_+1100_YccMFxdkaUS0_zV0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__23_Jan_2012_14_11_55_+1100_YccMFxdkaUS0_zV0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20120120:

Removed trees (all because they have not been revived or moved after the
kernel.org "outage"):
	asm-generic
	async_tx
	bdev
	bkl-config
	cpupowerutils
	drivers-x86
	fatfs
	hdlc
	hfsplus
	input-mt
	irda
	jfs
	linux-spec
	lsm
	namespace
	nilfs2
	nommu
	omap
	pcmcia
	pxa
	rmobile-current
	rmobile
	sfi
	sh-current
	sh
	vfs-scale
	xtensa

My fixes tree contains:
	powerpc: make PSERIES_IDLE bool

The m68k-current tree gained a conflict against Linus' tree.

The nfs tree gained a 2 build failures for which I applied a patches.

The crypto tree gained a conflict against the tegra tree.

The sound-asoc tree gained a build failure so I used the version from
next-20120120.

The akpm tree lost its build failure.

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

We are up to 177 trees (counting Linus' and 26 trees of patches pending
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
Merging origin/master (dcd6c92 Linux 3.3-rc1)
Merging fixes/master (38037cd powerpc: make PSERIES_IDLE bool)
Merging kbuild-current/rc-fixes (fa0ad65 kconfig: adapt update-po-config to=
 new UML layout)
Merging arm-current/fixes (f1cfd9e ARM: fix a section mismatch warning with=
 our use of memblock)
Merging m68k-current/for-linus (2a35350 m68k: Fix assembler constraint to p=
revent overeager gcc optimisation)
CONFLICT (content): Merge conflict in arch/m68k/kernel/process_mm.c
Merging powerpc-merge/merge (ebb7f61 powerpc: Fix unpaired __trace_hcall_en=
try and __trace_hcall_exit)
Merging 52xx-and-virtex-current/powerpc/merge (c49f878 dtc/powerpc: remove =
obsolete .gitignore entries)
Merging sparc/master (e51e07e sparc32: forced setting of mode of sun4m per-=
cpu timers)
Merging scsi-rc-fixes/master (6f6c2aa [SCSI] fcoe: fix fcoe in a DCB enviro=
nment by adding DCB notifiers to set skb priority)
Merging net/master (b1cc16b bluetooth: hci: Fix type of "enable_hs" to bool=
.)
Merging sound-current/for-linus (f0e48b6 ALSA: virtuoso: Xonar DS: fix pola=
rity of front output)
Merging pci-current/for-linus (8b6a5af PCI: Add Thinkpad SL510 to pci=3Dnoc=
rs blacklist)
Merging wireless/master (4f3d09d b43: add option to avoid duplicating devic=
e support with brcmsmac)
Merging driver-core.current/driver-core-linus (90a4c0f uml: fix compile for=
 x86-64)
Merging tty.current/tty-linus (6b3da11 Merge branch 'for-3.3' of git://git.=
kernel.org/pub/scm/linux/kernel/git/tj/percpu)
Merging usb.current/usb-linus (90a4c0f uml: fix compile for x86-64)
Merging staging.current/staging-linus (dcd6c92 Linux 3.3-rc1)
Merging char-misc.current/char-misc-linus (dcd6c92 Linux 3.3-rc1)
Merging cpufreq-current/fixes (5983fe2 Merge git://git.kernel.org/pub/scm/l=
inux/kernel/git/davem/net)
Merging input-current/for-linus (52965cc Input: bcm5974 - set BUTTONPAD pro=
perty)
Merging md-current/for-linus (307729c md/raid1: perform bad-block tests for=
 WriteMostly devices too.)
Merging audit-current/for-linus (c158a35 audit: no leading space in audit_l=
og_d_path prefix)
Merging crypto-current/master (51fc6dc crypto: sha512 - reduce stack usage =
to safe number)
Merging ide/master (0ab3d8b cy82c693: fix PCI device selection)
Merging dwmw2/master (244dc4e Merge git://git.infradead.org/users/dwmw2/ran=
dom-2.6)
Merging devicetree-current/devicetree/merge (c89810a ARM: prom.h: Fix build=
 error by removing unneeded header file)
Merging spi-current/spi/merge (e329b8a Merge branch 'spi/s3c64xx' of git://=
git.kernel.org/pub/scm/linux/kernel/git/broonie/misc into spi/merge)
Merging gpio-current/gpio/merge (95120d5 Correct bad gpio naming)
Merging arm/for-next (33710e3 Merge branches 'fixes' and 'restart' into for=
-next)
Merging arm-soc/for-next (0db991d LOCAL: add back arch/arm/arm-soc-for-next=
-contents.txt)
CONFLICT (content): Merge conflict in drivers/media/video/omap3isp/ispccdc.c
CONFLICT (content): Merge conflict in drivers/media/common/tuners/tda18218.c
CONFLICT (content): Merge conflict in drivers/dma/pl330.c
CONFLICT (content): Merge conflict in arch/arm/mach-s3c64xx/mach-crag6410.c
Merging arm-perf/for-next/perf (cdd2a5b Merge branches 'perf/updates' and '=
perf/fixes' into for-next/perf)
Merging at91/at91-next (7f200cf ARM: at91: Add external RTC for Flexibity b=
oard)
Merging davinci/davinci-next (fe0d422 Linux 3.0-rc6)
Merging samsung/next-samsung (9edb240 ARM: H1940/RX1950: Change default LED=
 triggers)
Merging s5p/for-next (e914815 Merge branches 'next-samsung-cleanup2' and 'n=
ext-samsung-devel2' into for-next)
Merging tegra/for-next (4cafe8b ARM: tegra: Pass uncompress.h UART selectio=
n to DEBUG_LL)
Merging xilinx/arm-next (b85a3ef ARM: Xilinx: Adding Xilinx board support)
Merging blackfin/for-linus (c2bc3a3 Merge branch 'x86/rdrand' of git://git.=
kernel.org/pub/scm/linux/kernel/git/tip/tip)
Merging c6x/for-linux-next (dcd6c92 Linux 3.3-rc1)
Merging cris/for-next (ea78f5b CRIS: Update documentation)
Merging quilt/hexagon (110b372 Remove unneeded include of version.h from ar=
ch/hexagon/include/asm/spinlock_types.h)
CONFLICT (content): Merge conflict in arch/hexagon/Kconfig
Merging ia64/next (65cc21b ia64: Add accept4() syscall)
Merging m68k/for-next (2a35350 m68k: Fix assembler constraint to prevent ov=
ereager gcc optimisation)
Merging m68knommu/for-next (1f7034b m68k: allow ColdFire 547x and 548x CPUs=
 to be built with MMU enabled)
Merging microblaze/next (dcd6c92 Linux 3.3-rc1)
Merging mips/mips-for-linux-next (8551715 Merge branches 'fixes-for-linus' =
and 'next/lantiq' into mips-for-linux-next)
Merging openrisc/for-upstream (b6fd41e Linux 3.1-rc6)
Merging parisc/for-next (fc99a91 futex: Use same lock set as lws calls)
Merging powerpc/next (ef88e39 powerpc: fix compile error with 85xx/p1010rdb=
.c)
Merging 4xx/next (ef88e39 powerpc: fix compile error with 85xx/p1010rdb.c)
Merging 52xx-and-virtex/powerpc/next (c1395f4 dtc/powerpc: remove obsolete =
.gitignore entries)
Merging galak/next (ef88e39 powerpc: fix compile error with 85xx/p1010rdb.c)
Merging s390/features (f163303 [S390] dasd: revalidate server for new pathg=
roup)
Merging sparc-next/master (e4e1118 Merge branch 'for-linus' of git://git.ke=
rnel.org/pub/scm/linux/kernel/git/viro/vfs)
Merging tile/master (0c90547 arch/tile: use new generic {enable,disable}_pe=
rcpu_irq() routines)
Merging unicore32/unicore32 (0994695 Merge branch 'akpm' (aka "Andrew's pat=
ch-bomb, take two"))
Merging ceph/for-next (83eb26a ceph: ensure prealloc_blob is in place when =
removing xattr)
Merging cifs/master (acbbb76 CIFS: Rename *UCS* functions to *UTF16*)
Merging configfs/linux-next (b930c26 Merge branch 'for-linus' of git://git.=
kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (f23dea1 eCryptfs: Infinite loop due to overflow in e=
cryptfs_write())
Merging ext3/for_next (46fe44c quota: Pass information that quota is stored=
 in system file to userspace)
Merging ext4/dev (d50f2ab ext4: fix undefined behavior in ext4_fill_flex_in=
fo())
Merging fuse/for-next (03c9693 cuse: implement memory mapping)
Merging gfs2/master (a1b46f1 GFS2: glock statistics gathering)
Merging logfs/master (21f3eb8 logfs: update page reference count for pined =
pages)
CONFLICT (content): Merge conflict in fs/logfs/file.c
CONFLICT (content): Merge conflict in fs/logfs/dev_mtd.c
Merging nfs/linux-next (94457e0 pnfs: clean up initiate_file_draining layou=
t lookup)
Applying: iscsi: in_aton needs linux/inet.h
Merging nfsd/nfsd-next (7a6ef8c nfsd4: nfsd4_create_clid_dir return value i=
s unused)
Merging ocfs2/linux-next (9392557 ocfs2: avoid unaligned access to dqc_bitm=
ap)
Merging omfs/for-next (976d167 Linux 3.1-rc9)
Merging squashfs/master (3d4a1c8 Squashfs: fix i_blocks calculation with ex=
tended regular files)
Merging v9fs/for-next (f766619 fs/9p: iattr_valid flags are kernel internal=
 flags map them to 9p values.)
Merging ubifs/linux-next (1f4f434 UBI: use own macros for the layout volume)
Merging xfs/master (d060646 xfs: cleanup xfs_file_aio_write)
Merging vfs/for-next (dcd6c92 Linux 3.3-rc1)
Merging pci/linux-next (76ccc29 x86/PCI: Expand the x86_msi_ops to have a r=
estore MSIs.)
Merging hid/for-next (f62f619 Merge branch 'for-linus' of git://git.kernel.=
org/pub/scm/linux/kernel/git/jikos/hid)
Merging quilt/i2c (dcd6c92 Linux 3.3-rc1)
Merging bjdooks-i2c/next-i2c (fc84fe1 Merge branch 'for_3.3/i2c/misc' of gi=
t://git.kernel.org/pub/scm/linux/kernel/git/khilman/linux-omap-pm into for-=
33/i2c/omap)
Merging quilt/jdelvare-hwmon (f3b3d0e hwmon: (w83795) Fix multi-line commen=
ts)
Merging hwmon-staging/hwmon-next (e64554f hwmon: (it87) Constify fixed stri=
ng arrays)
Merging quilt/kernel-doc (5851bad The Japanese/Korean/Chinese versions stil=
l need updating.)
Merging docs/docs-move (5c24d8b Merge branch 'docs/docbook/drm' of git://gi=
thub.com/mfwitten/linux into docs-move)
Merging v4l-dvb/master (36be126 [media] as3645a: Fix compilation by includi=
ng slab.h)
Merging kbuild/for-next (b1e0fba Merge branch 'kbuild/kconfig' into kbuild/=
for-next)
Merging kconfig/for-next (eae1c36 Merge branch 'kconfig/for-linus-2' into k=
config/for-next)
Merging libata/NEXT (b73fa46 [libata] ata_piix: Add Toshiba Satellite Pro A=
120 to the quirks list due to broken suspend functionality.)
Merging infiniband/for-next (dcd6c92 Linux 3.3-rc1)
Merging acpi/next (5dd821e Merge branch 'release' into next)
Merging ieee1394/for-next (2ca526b MAINTAINERS: firewire git URL update)
Merging ubi/linux-next (805a6af Linux 3.2)
Merging dlm/next (60f98d1 dlm: add recovery callbacks)
Merging scsi/master (76ffe8a [SCSI] libfc: remove redundant timer init for =
fcp)
Merging target-updates/for-next (895f302 target: Set additional sense lengt=
h field in sense data)
Merging target-merge/for-next-merge (a42d985 ib_srpt: Initial SRP Target me=
rge for v3.3-rc1)
Merging ibft/linux-next (935a9fe ibft: Fix finding IBFT ACPI table on UEFI)
Merging slave-dma/next (e08b881 ARM: mach-shmobile: specify CHCLR registers=
 on SH7372)
Merging net-next/master (356b954 Merge branch 'for-linus' of git://git.kern=
el.org/pub/scm/linux/kernel/git/geert/linux-m68k)
Merging wireless-next/master (c3b5003 tg3: Fix single-vector MSI-X code)
Merging bluetooth/master (c5993de Bluetooth: Correct packet len calculation)
Merging mtd/master (f5eee48 mtd: cfi: AMD/Fujitsu compatibles: add panic wr=
ite support)
Merging l2-mtd/master (fdeb19c MTD: ST SPEAr: Add SMI driver for serial NOR=
 flash)
CONFLICT (content): Merge conflict in drivers/mtd/nand/gpmi-nand/gpmi-lib.c
Merging crypto/master (b85a088 crypto: sha512 - use standard ror64())
CONFLICT (content): Merge conflict in arch/arm/mach-tegra/fuse.c
Merging sound/for-next (9c6a879 Merge branch 'fix/hda' into for-next)
Merging sound-asoc/for-next (9c7602c Merge branch 'for-3.4' into asoc-next)
$ git reset --hard HEAD^
Merging refs/next/20120120/sound-asoc
Merging cpufreq/next (6c523c6 [CPUFREQ] EXYNOS: Removed useless headers and=
 codes)
Merging quilt/rr (53999bf error: implicit declaration of function 'module_f=
lags_taint')
Merging input/next (dab78d7 Input: tc3589x-keypad - add missing kerneldoc)
Merging block/for-next (b3021da Merge branch 'for-3.3/core' into for-next)
Merging quilt/device-mapper (90a4c0f uml: fix compile for x86-64)
Merging embedded/master (4744b43 embedded: fix vc_translate operator preced=
ence)
Merging firmware/master (6e03a20 firmware: speed up request_firmware(), v3)
Merging battery/master (913272b Merge git://git.infradead.org/users/cbou/ba=
ttery-urgent)
Merging mmc/mmc-next (0ac9f78 mmc: MMC-4.5 Data Tag Support)
Merging kgdb/kgdb-next (880ba69 lib: rename pack_hex_byte() to hex_byte_pac=
k())
Merging slab/for-next (a1450d6 Merge branch 'slab/urgent' into for-next)
Merging uclinux/for-next (5e442a4 Revert "proc: fix races against execve() =
of /proc/PID/fd**")
Merging md/for-next (307729c md/raid1: perform bad-block tests for WriteMos=
tly devices too.)
Merging mfd/for-next (74d836c rtc: max8925: Add function to work as wakeup =
source)
Merging drm/drm-next (095f979 drm/nouveau/pm: fix build with HWMON off)
Merging fbdev/fbdev-next (f787f32 module_param: make bool parameters really=
 bool (drivers/video/i810))
Merging viafb/viafb-next (4ce36bb viafb: replace strict_strtoul to kstrto* =
and check return value)
Merging omap_dss2/for-next (9a90168 OMAPDSS: HDMI: Disable DDC internal pul=
l up)
Merging regulator/for-next (17bda61 Merge branch 'regulator-devm' into regu=
lator-next)
Merging security/next (7b7e591 ima: fix invalid memory reference)
Merging selinux/master (f423e5b capabilities: remove __cap_full_set definit=
ion)
Merging lblnet/master (7e27d6e Linux 2.6.35-rc3)
Merging watchdog/linux-next (34de40d watchdog: hpwdt: clean up set_memory_x=
 call for 32 bit)
Merging dwmw2-iommu/master (c3b92c8 Linux 3.1)
Merging iommu/next (1a51a0c ARM: OMAP3: fix build on !CONFIG_IOMMU_API)
Merging osd/linux-next (724577c ore: Must support none-PAGE-aligned IO)
Merging jc_docs/docs-next (5c050fb docs: update the development process doc=
ument)
Merging trivial/for-next (9879326 Merge branch 'for-linus' of git://git.ker=
nel.org/pub/scm/linux/kernel/git/jikos/trivial)
Merging audit/for-next (dcd6c92 Linux 3.3-rc1)
Merging pm/linux-next (7208162 PM / Hibernate: Rewrite unlock_system_sleep(=
) to fix s2disk regression)
Merging apm/for-next (b4a133d Merge branch 'for-linus' of git://git.kernel.=
org/pub/scm/linux/kernel/git/jikos/apm)
Merging fsnotify/for-next (ef9bf3b fanotify: only destroy a mark if both it=
s mask and its ignored_mask are cleared)
Merging edac/linux_next (4d096ca MAINTAINERS: add an entry for Edac Sandy B=
ridge driver)
Merging edac-amd/for-next (ed8ccfa Merge branch '3.3-edac-scrubrate' into e=
dac-for-next)
Merging devicetree/devicetree/next (661db79 of/irq: Add interrupts-names pr=
operty to name an irq resource)
Merging spi/spi/next (14c173e spi/tegra: depend instead of select TEGRA_SYS=
TEM_DMA)
Merging gpio/gpio/next (f408c98 GPIO: sa1100: implement proper gpiolib gpio=
_to_irq conversion)
Merging tip/auto-latest (eb5a6fe Merge branch 'x86/urgent' into auto-latest)
Merging rcu/rcu/next (f0312a5 rcu: Bring RTFP.txt up to date.)
Merging cputime/cputime (c3e0ef9 [S390] fix cputime overflow in uptime_proc=
_show)
Merging uprobes/for-next (af1d40c perf: perf interface for uprobes)
Applying: uprobes: bad merge fix
Merging cgroup/for-next (fb5d2b4 cgroup: replace tasklist_lock with rcu_rea=
d_lock)
Merging kmemleak/kmemleak (b370d29 kmemleak: Disable early logging when kme=
mleak is off by default)
Merging kvm/linux-next (da69dee KVM: PPC: Whitespace fix for kvm.h)
Merging oprofile/for-next (42fcb11 Merge branch 'oprofile/perf-ibs-v4' into=
 oprofile/for-next)
CONFLICT (content): Merge conflict in tools/perf/util/header.h
CONFLICT (content): Merge conflict in tools/perf/util/header.c
Merging xen/upstream/xen (59e9a6b Merge branch 'upstream/ticketlock-cleanup=
' into upstream/xen)
CONFLICT (content): Merge conflict in arch/x86/include/asm/cmpxchg.h
Merging xen-two/linux-next (429de5a Merge branch 'stable/for-linus-fixes-3.=
3' into linux-next)
Merging xen-pvhvm/linux-next (b056b6a xen: suspend: remove xen_hvm_suspend)
Merging percpu/for-next (26dd8e0 percpu: use bitmap_clear)
Merging workqueues/for-next (6b3da11 Merge branch 'for-3.3' of git://git.ke=
rnel.org/pub/scm/linux/kernel/git/tj/percpu)
Merging hwpoison/hwpoison (46e387b Merge branch 'hwpoison-hugepages' into h=
wpoison)
Merging sysctl/master (c2f5631 sysctl: remove impossible condition check)
Merging regmap/for-next (fe19378 Merge branch 'regmap-linus' into regmap-ne=
xt)
Merging hsi/for-next (43139a6 HSI: hsi_char: Update ioctl-number.txt)
Merging driver-core/driver-core-next (90a4c0f uml: fix compile for x86-64)
Merging tty/tty-next (6b3da11 Merge branch 'for-3.3' of git://git.kernel.or=
g/pub/scm/linux/kernel/git/tj/percpu)
Merging usb/usb-next (90a4c0f uml: fix compile for x86-64)
Merging staging/staging-next (dcd6c92 Linux 3.3-rc1)
Merging char-misc/char-misc-next (90a4c0f uml: fix compile for x86-64)
Merging tmem/linux-next (805a6af Linux 3.2)
Merging writeback/writeback-for-next (bc31b86 writeback: move MIN_WRITEBACK=
_PAGES to fs-writeback.c)
Merging arm-dt/devicetree/arm-next (ede338f dt: add documentation of ARM dt=
 boot interface)
Merging hwspinlock/linux-next (8b37fcf hwspinlock: add MAINTAINERS entries)
Merging pinctrl/for-next (fb819fa pinctrl: enable pinmux for mmp series)
Merging moduleh/for-sfr (6aec187 drivers/media: video/a5k6aa is a module an=
d so needs module.h)
Merging vhost/linux-next (193a667 alpha: drop pci_iomap/pci_iounmap from pc=
i-noop.c)
Merging kmap_atomic/kmap_atomic (2c2c817 feature-removal-schedule.txt: add =
the deprecated form of kmap_atomic())
Merging xshm/xshm-for-next (a178183 caif-xshm: Add CAIF driver for Shared m=
emory for M7400)
Merging memblock/memblock-kill-early_node_map (7bd0b0f memblock: Reimplemen=
t memblock allocation using reverse free area iterator)
Merging remoteproc/for-next (238c1e1 rpmsg: depends on EXPERIMENTAL)
Applying: rpmsg: rename virtqueue_add_buf_gfp to virtqueue_add_buf
Applying: remoteproc: don't use virtio's weak barriers
Merging kvmtool/master (0234379 kvm tools: Remove tags/TAGS on "make clean")
CONFLICT (content): Merge conflict in scripts/kconfig/Makefile
CONFLICT (content): Merge conflict in include/net/9p/9p.h
Merging scsi-post-merge/merge-base:master ()
$ git checkout akpm
Applying: mm: fix NULL ptr dereference in __count_immobile_pages
Applying: mm: __count_immobile_pages(): make sure the node is online
Applying: leds: add led driver for Bachmann's ot200
Applying: Kconfig-leds-add-driver-for-bachmans-ot200-fix
Applying: ipc/mqueue: simplify reading msgqueue limit
Applying: kprobes: initialize before using a hlist
Applying: drivers/video/backlight/adp88x0_bl.c: fix bit testing logic
Applying: drivers/video/backlight/l4f00242t03.c: return proper error in l4f=
00242t03_probe if regulator_get() fails
Applying: proc: clear_refs: do not clear reserved pages
Applying: mm: memcg: update the correct soft limit tree during migration
Applying: mm/hugetlb.c: undo change to page mapcount in fault handler
Applying: kdump: define KEXEC_NOTE_BYTES arch specific for s390x
Applying: SHM_UNLOCK: fix long unpreemptible section
Applying: SHM_UNLOCK: fix Unevictable pages stranded after swap
Applying: mm: fix rss count leakage during migration
Applying: score: fix off-by-one index into syscall table
Applying: arch/x86/kernel/nmi_selftest.c needs percpu.h
Applying: net/netfilter/nf_conntrack_netlink.c: fix Oops on container destr=
oy
Applying: vfs: fix panic in __d_lookup() with high dentry hashtable counts
Applying: acerhdf: add support for Aspire 1410 BIOS v1.3314
Applying: acerhdf: add support for new hardware
Applying: acerhdf: lowered default temp fanon/fanoff values
Applying: arch/x86/platform/iris/iris.c: register a platform device and a p=
latform driver
Applying: x86, olpc-xo15-sci: enable lid close wakeup control through sysfs
Applying: geos: platform driver for Geos and Geos2 single-board computers
Applying: x86, olpc: add debugfs interface for EC commands
Applying: x86, mm: fix the size calculation of mapping tables
Applying: drivers/platform/x86/sony-laptop.c: fix scancodes
Applying: arch/arm/mach-ux500/mbox-db5500.c: world-writable sysfs fifo file
Applying: arm, exec: remove redundant set_fs(USER_DS)
Applying: net: use this_cpu_xxx replace percpu_xxx funcs
Applying: xen: use this_cpu_xxx replace percpu_xxx funcs
Applying: x86: use this_cpu_xxx to replace percpu_xxx funcs
Applying: x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs-fix-2
Applying: x86: change percpu_read_stable() to this_cpu_read_stable()
Applying: percpu: remove percpu_xxx() functions
Applying: Subject irqs: fix long-term regression in genirq irq_set_irq_type=
() handling
Applying: irqs: fix handling of pending IRQs at request time
Applying: hrtimers: Special-case zero length sleeps
Applying: debugobjects: Fix selftest for static warnings
Applying: drivers/scsi/aacraid/commctrl.c: fix mem leak in aac_send_raw_srb=
()
Applying: drivers/scsi/mpt2sas/mpt2sas_base.c: fix mismatch in mpt2sas_base=
_hard_reset_handler() mutex lock-unlock
Applying: drivers/scsi/mpt2sas/mpt2sas_scsih.c: spell "primitive" correctly
Applying: MAINTAINERS: Staging: cx25821: Add L: linux-media
Applying: drivers/usb/misc/emi26.c & emi62.c: fix warnings
Applying: mm, oom: avoid looping when chosen thread detaches its mm
Applying: mm, oom: fold oom_kill_task() into oom_kill_process()
Applying: mm, oom: do not emit oom killer warning if chosen thread is alrea=
dy exiting
Applying: mm: add rss counters consistency check
Applying: mm: postpone migrated page mapping reset
Applying: mm/vmscan.c: cleanup with s/reclaim_mode/isolate_mode/
Applying: mm: fix page-faults detection in swap-token logic
Applying: mm: add extra free kbytes tunable
Applying: mm-add-extra-free-kbytes-tunable-update
Applying: mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes
Applying: memcg: replace MEM_CONT by MEM_RES_CTLR
Applying: memcg: replace mem and mem_cont stragglers
Applying: memcg: lru_size instead of MEM_CGROUP_ZSTAT
Applying: memcg: enum lru_list lru
Applying: memcg: remove redundant returns
Applying: hpet: factor timer allocate from open
Applying: ceph, cifs, nfs, fuse: boolean and / or confusion
Applying: prctl: add PR_{SET,GET}_CHILD_SUBREAPER to allow simple process s=
upervision
Applying: prctl-add-pr_setget_child_subreaper-to-allow-simple-process-super=
vision-fix
Applying: prctl-add-pr_setget_child_subreaper-to-allow-simple-process-super=
vision-fix-fix
Applying: prctl-add-pr_setget_child_subreaper-to-allow-simple-process-super=
vision-fix-fix-fix
Applying: vfs: increment iversion when a file is truncated
Applying: brlocks/lglocks: cleanups
Applying: brlocks-lglocks-cleanups-checkpatch-fixes
Applying: backlight: convert backlight i2c drivers to module_i2c_driver
Applying: backlight: convert backlight spi drivers to module_spi_driver
Applying: bitops: rename for_each_set_bit_cont() in favor of analogous list=
.h function
Applying: bitops: remove for_each_set_bit_cont()
Applying: bitops: introduce for_each_clear_bit()
Applying: mtd: use for_each_clear_bit()
Applying: s390/char: use for_each_clear_bit()
Applying: uwb: use for_each_clear_bit()
Applying: x86: use for_each_clear_bit_from()
Applying: crc32: remove two instances of trailing whitespaces
Applying: crc32: move long comment about crc32 fundamentals to Documentatio=
n/
Applying: crc32-move-long-comment-about-crc32-fundamentals-to-documentation=
-fix
Applying: crc32: simplify unit test code
Applying: crc32: miscellaneous cleanups
Applying: crc32: fix mixing of endian-specific types
Applying: crc32: make CRC_*_BITS definition correspond to actual bit counts
Applying: crc32: add slice-by-8 algorithm to existing code
Applying: crc32: optimize loop counter for x86
Applying: crc32: add note about this patchset to crc32.c
Applying: crc32: bolt on crc32c
Applying: crypto: crc32c should use library implementation
Applying: crc32: add self-test code for crc32c
Applying: crc32: select an algorithm via Kconfig
Applying: init/do_mounts.c: create /root if it does not exist
Applying: rtc-spear: fix for balancing the enable_irq_wake in Power Mgmt
Applying: rtc/spear: fix for RTC_AIE_ON and RTC_AIE_OFF ioctl errors
Applying: rtc/rtc-spear: call platform_set_drvdata() before registering rtc=
 device
Applying: ipc/sem.c: alternatives to preempt_disable()
Applying: ipc: provide generic compat versions of IPC syscalls
Applying: sysctl: make kernel.ns_last_pid control dependent on CHECKPOINT_R=
ESTORE
Applying: ramoops: use pstore interface
Applying: notify_change(): check that i_mutex is held
Merging akpm (f73818a notify_change(): check that i_mutex is held)
Applying: SUNRPC: fixup for namespace changes

--Signature=_Mon__23_Jan_2012_14_11_55_+1100_YccMFxdkaUS0_zV0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPHM/7AAoJEECxmPOUX5FESBcQAKHBU2d28kn16yJwXpvt/yyE
3Z3jggW6e1BqEBDDgU02kzUxBdwCVSzag+9SUSoZ4uvLCrgXj1RijVPj3SZd0ngm
MS+IWpDDI/kZpD7Fr9bmexdqV7UIbuOhzhwyUz86x0lafJnAiLhqGPc6b0s9uMmK
wU4ZuEGHvRenPAtyRCYYFQArHDfpKH8IQYVlhVFjavKVwluLYXAOzrLvfCjOVskH
f8BLg6rrFHdiqarOZapJnmH/1/n5Qtgf/RtlZ6ojRRSqzlQ/VTD3Ns1rWDY56Aqg
0rfWxhtqpIxE2Ael2pUamG5HydQOk3mpHpSeBhRNlIHyBgF434oO53lz0N+N9P8/
XzBRXWCVEPausJ6TIqMxavwNhRJIGObgCCg9dgPh8OvdJwf333g+Cu/EtdQhHXhn
+eTmCh7Duh7rdpZ2J5kzIiGUdhHMTpnJd3NXx3EuqN3MjOuTvHB1hVaZO+JOZyPq
+OLG/hxCtge7uYoGmBaClMvsHNQAWfHDPuJqgLq3t970giuICeEarnAikSjNSFOJ
2wDcn4Nv1JPLXcb6hJLTrxIt7a3s/Abj1Q29wRMN8Mms7O8etHC33eK56ZSMAXbd
n9b8hDQJ3Sk6lWi+CyN+5UbnKvvVzqQ5Ce/5OVRK13Z7VQv3ZkwtBcoeSTuBqZtZ
TE4Ul4MgI8SGziOvhr6c
=iEyW
-----END PGP SIGNATURE-----

--Signature=_Mon__23_Jan_2012_14_11_55_+1100_YccMFxdkaUS0_zV0--

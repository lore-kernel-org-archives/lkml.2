Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887Ab2A0EHn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 23:07:43 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:42410 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751759Ab2A0EHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 23:07:40 -0500
Date: Fri, 27 Jan 2012 15:07:28 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Jan 27
Message-Id: <20120127150728.69bcf2016f359d5e944dedd9@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__27_Jan_2012_15_07_28_+1100_a4_0DuKTV95lAeRs"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__27_Jan_2012_15_07_28_+1100_a4_0DuKTV95lAeRs
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20120125:

My fixes tree is empty again.

The m68k-current tree lost its conflict.

The pm tree gained a build failure so I used the version from
next-20120125.

The driver-core tree gained a build failure do I used the version from
next-20120125.

The akpm tree lost a couple of patches that turned up elsewhere.

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

We are up to 180 trees (counting Linus' and 26 trees of patches pending
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
Merging origin/master (2d3c7ef Merge branch 'x86-urgent-for-linus' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/tip/tip)
Merging fixes/master (f8275f9 Merge branch 'release' of git://git.kernel.or=
g/pub/scm/linux/kernel/git/lenb/linux)
Merging kbuild-current/rc-fixes (620c231 kbuild: do not check for ancient m=
odutils tools)
Merging arm-current/fixes (9a95b9e Merge branch 'sa11x0-mcp-fixes' into fix=
es)
CONFLICT (modify/delete): arch/arm/mach-mx5/Kconfig deleted in HEAD and mod=
ified in arm-current/fixes. Version arm-current/fixes of arch/arm/mach-mx5/=
Kconfig left in tree.
$ git rm -f arch/arm/mach-mx5/Kconfig
Applying: ARM: fix up for cache size assumed to be 64 bytes
Merging m68k-current/for-linus (2a35350 m68k: Fix assembler constraint to p=
revent overeager gcc optimisation)
Merging powerpc-merge/merge (3493c85 powerpc: Fix build on some non-freesca=
le platforms)
Merging 52xx-and-virtex-current/powerpc/merge (c49f878 dtc/powerpc: remove =
obsolete .gitignore entries)
Merging sparc/master (e51e07e sparc32: forced setting of mode of sun4m per-=
cpu timers)
Merging scsi-rc-fixes/master (6f6c2aa [SCSI] fcoe: fix fcoe in a DCB enviro=
nment by adding DCB notifiers to set skb priority)
Merging net/master (9018e93 net: explicitly add jump_label.h header to sock=
.h)
Merging sound-current/for-linus (a6a600d ALSA: hda: set mute led polarity f=
or laptops with buggy BIOS based on SSID)
Merging pci-current/for-linus (8b6a5af PCI: Add Thinkpad SL510 to pci=3Dnoc=
rs blacklist)
Merging wireless/master (b49ba04 iwlwifi: fix PCI-E transport "inta" race)
Merging driver-core.current/driver-core-linus (ce59791 sysfs: Complain bitt=
erly about attempts to remove files from nonexistent directories.)
Merging tty.current/tty-linus (523b82e serial: Kill off Moorestown code)
Merging usb.current/usb-linus (a0701f0 uwb & wusb: fix kconfig error)
Merging staging.current/staging-linus (dcd6c92 Linux 3.3-rc1)
Merging char-misc.current/char-misc-linus (7c5763b drivers: misc: Remove MI=
SC_DEVICES config option)
Merging cpufreq-current/fixes (5983fe2 Merge git://git.kernel.org/pub/scm/l=
inux/kernel/git/davem/net)
Merging input-current/for-linus (52965cc Input: bcm5974 - set BUTTONPAD pro=
perty)
Merging md-current/for-linus (307729c md/raid1: perform bad-block tests for=
 WriteMostly devices too.)
Merging audit-current/for-linus (c158a35 audit: no leading space in audit_l=
og_d_path prefix)
Merging crypto-current/master (58d7d18 crypto: sha512 - Use binary and inst=
ead of modulus)
Merging ide/master (0ab3d8b cy82c693: fix PCI device selection)
Merging dwmw2/master (244dc4e Merge git://git.infradead.org/users/dwmw2/ran=
dom-2.6)
Merging devicetree-current/devicetree/merge (c89810a ARM: prom.h: Fix build=
 error by removing unneeded header file)
Merging spi-current/spi/merge (4aab51c spi: Add spi-s3c64xx driver dependen=
cy on ARCH_EXYNOS4)
Merging gpio-current/gpio/merge (95120d5 Correct bad gpio naming)
Merging arm/for-next (2a07f5e Merge branches 'fixes', 'l2', 'mmci', 'pcmcia=
', 'pgt2' and 'misc' into for-next)
Merging arm-soc/for-next (c5b5a02 Merge tag 'arm-soc-drivers-late' into for=
-next)
CONFLICT (content): Merge conflict in arch/arm/mach-exynos/dma.c
Merging arm-perf/for-next/perf (cdd2a5b Merge branches 'perf/updates' and '=
perf/fixes' into for-next/perf)
Merging at91/at91-next (0001061 at91: drop ide driver in favor of the pata =
one)
CONFLICT (content): Merge conflict in arch/arm/mach-exynos/dma.c
Merging davinci/davinci-next (fe0d422 Linux 3.0-rc6)
Merging samsung/next-samsung (9edb240 ARM: H1940/RX1950: Change default LED=
 triggers)
Merging s5p/for-next (a291ade Merge branch 'next/devel-samsung' into for-ne=
xt)
Merging tegra/for-next (042dc16 Merge branch 'fixes' into for-next)
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
Merging m68knommu/for-next (bea0cac m68knommu: clean up linker script)
Merging microblaze/next (eacb6ec microblaze: generic atomic64 support)
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
Merging cifs/master (803ab97 cifs: NULL dereference on allocation failure)
Merging configfs/linux-next (b930c26 Merge branch 'for-linus' of git://git.=
kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (8d6d71e eCryptfs: Fix oops when printing debug info =
in extent crypto functions)
Merging ext3/for_next (46fe44c quota: Pass information that quota is stored=
 in system file to userspace)
Merging ext4/dev (ad63466 ext4: ignore EXT4_INODE_JOURNAL_DATA flag with de=
lalloc)
Merging fuse/for-next (03c9693 cuse: implement memory mapping)
Merging gfs2/master (a1b46f1 GFS2: glock statistics gathering)
Merging logfs/master (21f3eb8 logfs: update page reference count for pined =
pages)
CONFLICT (content): Merge conflict in fs/logfs/file.c
CONFLICT (content): Merge conflict in fs/logfs/dev_mtd.c
Merging nfs/linux-next (610216b Merge branch 'bugfixes' into linux-next)
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
Merging ubifs/linux-next (d193609 UBIFS: make the dbg_lock spinlock static)
Merging xfs/master (9b025eb xfs: Fix missing xfs_iunlock() on error recover=
y path in xfs_readlink())
Merging vfs/for-next (dcd6c92 Linux 3.3-rc1)
Merging pci/linux-next (76ccc29 x86/PCI: Expand the x86_msi_ops to have a r=
estore MSIs.)
Merging hid/for-next (f62f619 Merge branch 'for-linus' of git://git.kernel.=
org/pub/scm/linux/kernel/git/jikos/hid)
Merging quilt/i2c (48260db i2c-i801: Use usleep_range to wait for command c=
ompletion)
Merging bjdooks-i2c/next-i2c (fc84fe1 Merge branch 'for_3.3/i2c/misc' of gi=
t://git.kernel.org/pub/scm/linux/kernel/git/khilman/linux-omap-pm into for-=
33/i2c/omap)
Merging quilt/jdelvare-hwmon (0849a20 hwmon: (lm63) Let the user adjust the=
 lookup table)
Merging hwmon-staging/hwmon-next (05b13ab hwmon: (it87) Fix vrm value range)
Merging quilt/kernel-doc (5851bad The Japanese/Korean/Chinese versions stil=
l need updating.)
Merging docs/docs-move (5c24d8b Merge branch 'docs/docbook/drm' of git://gi=
thub.com/mfwitten/linux into docs-move)
Merging v4l-dvb/master (1854438 Merge /home/v4l/v4l/patchwork)
Merging kbuild/for-next (d90898e Merge branch 'kbuild/misc' into kbuild/for=
-next)
Merging kconfig/for-next (eae1c36 Merge branch 'kconfig/for-linus-2' into k=
config/for-next)
Merging libata/NEXT (b73fa46 [libata] ata_piix: Add Toshiba Satellite Pro A=
120 to the quirks list due to broken suspend functionality.)
Merging infiniband/for-next (dcd6c92 Linux 3.3-rc1)
Merging acpi/next (eb7004e Merge branches 'atomicio-apei', 'hotplug', 'sony=
-nvs-nosave' and 'thermal-netlink' into release)
Merging ieee1394/for-next (d63a665 Merge branch 'fixes' into for-next)
Merging ubi/linux-next (dcd6c92 Linux 3.3-rc1)
Merging dlm/next (60f98d1 dlm: add recovery callbacks)
Merging scsi/master (76ffe8a [SCSI] libfc: remove redundant timer init for =
fcp)
Merging target-updates/for-next (895f302 target: Set additional sense lengt=
h field in sense data)
Merging target-merge/for-next-merge (a42d985 ib_srpt: Initial SRP Target me=
rge for v3.3-rc1)
Merging ibft/linux-next (935a9fe ibft: Fix finding IBFT ACPI table on UEFI)
Merging slave-dma/next (dcd6c92 Linux 3.3-rc1)
Merging dmaengine/next (d07a74a dmaengine: fix missing 'cnt' in ?: in dmate=
st)
Merging net-next/master (a7563f3 ipv6: Use ipv6_addr_any())
Merging wireless-next/master (d7d312c ath9k_htc: claim support for IBSS RSN)
Merging bluetooth/master (c5993de Bluetooth: Correct packet len calculation)
Merging mtd/master (f5eee48 mtd: cfi: AMD/Fujitsu compatibles: add panic wr=
ite support)
Merging l2-mtd/master (fdeb19c MTD: ST SPEAr: Add SMI driver for serial NOR=
 flash)
CONFLICT (content): Merge conflict in drivers/mtd/nand/gpmi-nand/gpmi-lib.c
Merging crypto/master (65a4a57 crypto: caam - fix gcc 4.6 warning)
CONFLICT (content): Merge conflict in arch/arm/mach-tegra/fuse.c
Merging sound/for-next (fbe1eb3 Merge branch 'fix/hda' into for-next)
Merging sound-asoc/for-next (53bd8b0 Merge branch 'for-3.3' into asoc-next)
Merging cpufreq/next (6c523c6 [CPUFREQ] EXYNOS: Removed useless headers and=
 codes)
Merging quilt/rr (53999bf error: implicit declaration of function 'module_f=
lags_taint')
Merging input/next (b6834b0 Input: tegra-kbc - enable key interrupt for wak=
eup)
Merging input-mt/for-next (dcd6c92 Linux 3.3-rc1)
Merging block/for-next (b3021da Merge branch 'for-3.3/core' into for-next)
Merging quilt/device-mapper (dcd6c92 Linux 3.3-rc1)
Merging embedded/master (4744b43 embedded: fix vc_translate operator preced=
ence)
Merging firmware/master (6e03a20 firmware: speed up request_firmware(), v3)
Merging battery/master (913272b Merge git://git.infradead.org/users/cbou/ba=
ttery-urgent)
Merging mmc/mmc-next (0ac9f78 mmc: MMC-4.5 Data Tag Support)
Merging kgdb/kgdb-next (880ba69 lib: rename pack_hex_byte() to hex_byte_pac=
k())
Merging slab/for-next (0ad9500 slub: prefetch next freelist pointer in slab=
_alloc())
Merging uclinux/for-next (5e442a4 Revert "proc: fix races against execve() =
of /proc/PID/fd**")
Merging md/for-next (307729c md/raid1: perform bad-block tests for WriteMos=
tly devices too.)
Merging mfd/for-next (f365f51 mfd: Avoid twl6040-codec PLL reconfiguration =
when not needed)
Merging drm/drm-next (095f979 drm/nouveau/pm: fix build with HWMON off)
Merging fbdev/fbdev-next (f787f32 module_param: make bool parameters really=
 bool (drivers/video/i810))
Merging viafb/viafb-next (4ce36bb viafb: replace strict_strtoul to kstrto* =
and check return value)
Merging omap_dss2/for-next (9a90168 OMAPDSS: HDMI: Disable DDC internal pul=
l up)
Merging regulator/for-next (9d959a6 Merge branches 'regulator-linus' and 'r=
egulator-core' into regulator-next)
Merging security/next (7b7e591 ima: fix invalid memory reference)
Merging selinux/master (f423e5b capabilities: remove __cap_full_set definit=
ion)
Merging lblnet/master (7e27d6e Linux 2.6.35-rc3)
Merging watchdog/linux-next (fd70cf2 watchdog: iTCO_wdt: add Intel Lynx Poi=
nt DeviceIDs)
Merging dwmw2-iommu/master (c3b92c8 Linux 3.1)
Merging iommu/next (05dc8af Merge branches 'iommu/fixes' and 'arm/tegra' in=
to next)
Merging osd/linux-next (724577c ore: Must support none-PAGE-aligned IO)
Merging jc_docs/docs-next (5c050fb docs: update the development process doc=
ument)
Merging trivial/for-next (9879326 Merge branch 'for-linus' of git://git.ker=
nel.org/pub/scm/linux/kernel/git/jikos/trivial)
Merging audit/for-next (dcd6c92 Linux 3.3-rc1)
Merging pm/linux-next (77100bc Merge branch 'pm-devfreq' into linux-next)
$ git reset --hard HEAD^
Merging refs/next/20120125/pm
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
Merging tip/auto-latest (35627ce Merge branch 'x86/urgent' into auto-latest)
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
Merging xen-two/linux-next (681a36e Merge branch 'stable/for-linus-fixes-3.=
3' into linux-next)
Merging xen-pvhvm/linux-next (b056b6a xen: suspend: remove xen_hvm_suspend)
Merging percpu/for-next (26dd8e0 percpu: use bitmap_clear)
Merging workqueues/for-next (6b3da11 Merge branch 'for-3.3' of git://git.ke=
rnel.org/pub/scm/linux/kernel/git/tj/percpu)
Merging hwpoison/hwpoison (46e387b Merge branch 'hwpoison-hugepages' into h=
wpoison)
Merging sysctl/master (c2f5631 sysctl: remove impossible condition check)
Merging regmap/for-next (6c2f6f9 Merge branch 'regmap-core' into regmap-nex=
t)
Merging hsi/for-next (43139a6 HSI: hsi_char: Update ioctl-number.txt)
Merging driver-core/driver-core-next (d6e4868 debugfs: add mode, uid and gi=
d options)
$ git reset --hard HEAD^
Merging refs/next/20120125/driver-core
Merging tty/tty-next (3afbd89 serial/efm32: add new driver)
Merging usb/usb-next (fec67b4 usb: cdc-wdm: Add device-id for Huawei 3G/LTE=
 modems)
CONFLICT (content): Merge conflict in drivers/usb/class/cdc-wdm.c
Merging staging/staging-next (dcd6c92 Linux 3.3-rc1)
Merging char-misc/char-misc-next (a3dc3c9 MISC: convert drivers/misc/* to u=
se module_spi_driver())
Merging tmem/linux-next (a39c00d Merge branch 'stable/cleancache.v13' into =
linux-next)
Merging writeback/writeback-for-next (bc31b86 writeback: move MIN_WRITEBACK=
_PAGES to fs-writeback.c)
Merging arm-dt/devicetree/arm-next (ede338f dt: add documentation of ARM dt=
 boot interface)
Merging hwspinlock/linux-next (8b37fcf hwspinlock: add MAINTAINERS entries)
Merging pinctrl/for-next (b9130b7 pinctrl: add checks for empty function na=
mes)
Merging moduleh/for-sfr (6aec187 drivers/media: video/a5k6aa is a module an=
d so needs module.h)
Merging vhost/linux-next (193a667 alpha: drop pci_iomap/pci_iounmap from pc=
i-noop.c)
Merging kmap_atomic/kmap_atomic (2c2c817 feature-removal-schedule.txt: add =
the deprecated form of kmap_atomic())
CONFLICT (content): Merge conflict in fs/ecryptfs/read_write.c
Merging xshm/xshm-for-next (a178183 caif-xshm: Add CAIF driver for Shared m=
emory for M7400)
Merging memblock/memblock-kill-early_node_map (7bd0b0f memblock: Reimplemen=
t memblock allocation using reverse free area iterator)
Merging remoteproc/for-next (238c1e1 rpmsg: depends on EXPERIMENTAL)
Applying: rpmsg: rename virtqueue_add_buf_gfp to virtqueue_add_buf
Applying: remoteproc: don't use virtio's weak barriers
Merging kvmtool/master (d6fbf06 kvm tools: Fix build breakage with GCC 4.7)
CONFLICT (content): Merge conflict in scripts/kconfig/Makefile
CONFLICT (content): Merge conflict in include/net/9p/9p.h
Merging ktest/for-next (be405f9 ktest: Add INGORE_ERRORS to ignore warnings=
 in boot up)
Merging scsi-post-merge/merge-base:master ()
$ git checkout akpm
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
Merging akpm (6e28727 notify_change(): check that i_mutex is held)

--Signature=_Fri__27_Jan_2012_15_07_28_+1100_a4_0DuKTV95lAeRs
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIbBAEBCAAGBQJPIiMAAAoJEECxmPOUX5FEseEP+Ot2HTXCtF2racMFpzOyEDgz
PlUgK7QUzP0uZ+I8YIb1xEPvMtMmsP/aRaNueBNapurBayIZcely37rTrDYAb9qN
6YdNRPpk1pVybkvfjgtdaniLREyFJ34qFZaI5GGibwzpdmAa46soukW0KQXo6GTQ
A50BbBBmVcRXn9MzJc3RG2ELLZfyKyx+VCNtDayFag5KCXr8XfoVK1EOJvLADjHu
uNhtNfXkR79PO787ssqC/1LdVRFIiwBP6F7AKhI2ftr75/6+B1rXN87XyASq3Len
Oil6tT89Z4yUAvyjSxavKgT+eIbmiK40aeXU1RymqZW584jgH1oBpGjFPyrJIp63
C7SEhh+kXXvkRR1ooj9WnuY19/3SF2P4xIlOP9xyI47c3j1kg2gkjgdzOMDS2XAF
Hh9SWT3aLDyJdrf8HRiICGKNrJ+FDNMG051lxdrXpjuoX0icdsUtTaOcNrLYXThB
Y7wb4eA9R3m/Qbl/HFa0g0DUsXTqj0CUDUX7/JeCWVX0Dkb4NsDKWis4LrcqQwWJ
T1aJGDURhqvt6u72QONOy5vsxh33/4n/vwnX1V6cuCRiCTK6ZVrTJDHwbBCkOFNn
fd2Pp3XyQIRne3xFLWTzJgiiVFPmucY6jVpBq7LquxBxujvywcsWRDxF1yY1qVN4
lIJv8o/IzMZGJTtxP6s=
=0vaj
-----END PGP SIGNATURE-----

--Signature=_Fri__27_Jan_2012_15_07_28_+1100_a4_0DuKTV95lAeRs--

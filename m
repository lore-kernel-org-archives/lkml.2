Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754414Ab2BGGJq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 01:09:46 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:34075 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753816Ab2BGGJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 01:09:43 -0500
Date: Tue, 7 Feb 2012 17:09:33 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Feb 7
Message-Id: <20120207170933.30c4a0a04229ec255ab12041@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__7_Feb_2012_17_09_33_+1100_ku03kK1N50ajL0AK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__7_Feb_2012_17_09_33_+1100_ku03kK1N50ajL0AK
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20120206:

The wireless-next tree lost its conflict.

The l2-mtd tree lost its build failure but gained another so I used the
version from next-20120203.

The sound-asoc tree lost its build failure.

The mmc tree lost its build failure.

The gpio tree still has its build failure for which I reverted a commit.

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
Merging origin/master (23783f8 Merge tag 'pm-fixes-for-3.3-rc3' of git://gi=
t.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm)
Merging fixes/master (f8275f9 Merge branch 'release' of git://git.kernel.or=
g/pub/scm/linux/kernel/git/lenb/linux)
Merging kbuild-current/rc-fixes (620c231 kbuild: do not check for ancient m=
odutils tools)
Merging arm-current/fixes (5a97d0a ARM: 7314/1: kuser: consistently use usr=
_ret for returning from helpers)
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
Merging net/master (7e2eb99 mlx4: fix DMA mapping leak when allocation fail=
s)
Merging sound-current/for-linus (b5bcc18 ALSA: hda - Disable dynamic-power =
control for VIA as default)
Merging pci-current/for-linus (acb42a3 Merge branch 'drm-fixes' of git://pe=
ople.freedesktop.org/~airlied/linux)
Merging wireless/master (2e6b411 bcma: don't fail for bad SPROM CRC)
Merging driver-core.current/driver-core-linus (26417d4 docbook: fix fatal e=
rrors in device-drivers docbook and add DMA Management section)
Merging tty.current/tty-linus (e7c9bba tty: fix a build failure on sparc)
Merging usb.current/usb-linus (90451e6 USB: usbserial: add new PID number (=
0xa951) to the ftdi driver)
Merging staging.current/staging-linus (3b578da Merge branch 'work-linus' in=
to staging-linus)
Merging char-misc.current/char-misc-linus (b5266ea mmc: cb710 core: Add mis=
sing spin_lock_init for irq_lock of struct cb710_chip)
Merging cpufreq-current/fixes (5983fe2 Merge git://git.kernel.org/pub/scm/l=
inux/kernel/git/davem/net)
Merging input-current/for-linus (82b982c Input: i8042 - add Lenovo Ideapad =
U455 to 'reset' blacklist)
Merging md-current/for-linus (307729c md/raid1: perform bad-block tests for=
 WriteMostly devices too.)
Merging audit-current/for-linus (c158a35 audit: no leading space in audit_l=
og_d_path prefix)
Merging crypto-current/master (3a92d68 crypto: sha512 - Avoid stack bloat o=
n i386)
Merging ide/master (0ab3d8b cy82c693: fix PCI device selection)
Merging dwmw2/master (244dc4e Merge git://git.infradead.org/users/dwmw2/ran=
dom-2.6)
Merging devicetree-current/devicetree/merge (810ae3d ARM: devicetree: Add .=
dtb files to arch/arm/boot/.gitignore)
Merging spi-current/spi/merge (c88db23 spi-topcliff-pch: rename pch_spi_pci=
dev to pch_spi_pcidev_driver)
Merging gpio-current/gpio/merge (7e3a70f gpio: Add missing spin_lock_init i=
n gpio-ml-ioh driver)
Merging arm/for-next (fb8e29e Merge branch 'fixes' into for-next)
CONFLICT (content): Merge conflict in arch/arm/mach-at91/at91sam9g45.c
CONFLICT (content): Merge conflict in arch/arm/mach-at91/at91cap9.c
Merging arm-soc/for-next (f8d0078 Merge branch 'fixes' into for-next)
Merging arm-perf/for-next/perf (cdd2a5b Merge branches 'perf/updates' and '=
perf/fixes' into for-next/perf)
CONFLICT (content): Merge conflict in arch/arm/kernel/perf_event_v7.c
Merging davinci/davinci-next (fe0d422 Linux 3.0-rc6)
Merging samsung/next-samsung (9edb240 ARM: H1940/RX1950: Change default LED=
 triggers)
Merging s5p/for-next (a291ade Merge branch 'next/devel-samsung' into for-ne=
xt)
Merging tegra/for-next (944a28c Merge branch 'for-3.4' into for-next)
Merging xilinx/arm-next (b85a3ef ARM: Xilinx: Adding Xilinx board support)
Merging blackfin/for-linus (0476b92 Blackfin: wire up new process_vm syscal=
ls)
Merging c6x/for-linux-next (dcd6c92 Linux 3.3-rc1)
Merging cris/for-next (ea78f5b CRIS: Update documentation)
Merging quilt/hexagon (110b372 Remove unneeded include of version.h from ar=
ch/hexagon/include/asm/spinlock_types.h)
CONFLICT (content): Merge conflict in arch/hexagon/Kconfig
Merging ia64/next (65cc21b ia64: Add accept4() syscall)
Merging m68k/for-next (2a35350 m68k: Fix assembler constraint to prevent ov=
ereager gcc optimisation)
Merging m68knommu/for-next (bea0cac m68knommu: clean up linker script)
Merging microblaze/next (6c073a7 Merge branch 'for-linus' of git://git.kern=
el.org/pub/scm/linux/kernel/git/sage/ceph-client)
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
Merging s390/features (a6cbda8 [S390] cleanup smp code)
Merging sparc-next/master (e4e1118 Merge branch 'for-linus' of git://git.ke=
rnel.org/pub/scm/linux/kernel/git/viro/vfs)
Merging tile/master (0c90547 arch/tile: use new generic {enable,disable}_pe=
rcpu_irq() routines)
Merging unicore32/unicore32 (0994695 Merge branch 'akpm' (aka "Andrew's pat=
ch-bomb, take two"))
Merging ceph/for-next (83eb26a ceph: ensure prealloc_blob is in place when =
removing xattr)
Merging cifs/master (de47a41 cifs: Fix oops in session setup code for null =
user mounts)
Merging configfs/linux-next (b930c26 Merge branch 'for-linus' of git://git.=
kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (74217cb eCryptfs: Write optimization for non-uptodat=
e page)
Merging ext3/for_next (46fe44c quota: Pass information that quota is stored=
 in system file to userspace)
Merging ext4/dev (ad63466 ext4: ignore EXT4_INODE_JOURNAL_DATA flag with de=
lalloc)
Merging fuse/for-next (03c9693 cuse: implement memory mapping)
Merging gfs2/master (a1b46f1 GFS2: glock statistics gathering)
Merging logfs/master (d125666 Merge branch 'fixes' of git://git.linaro.org/=
people/rmk/linux-arm)
Merging nfs/linux-next (a4980e7 NFSv4: ACCESS validation doesn't require a =
full attribute refresh)
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
Merging xfs/for-next (4177af3 Define new macro XFS_ALL_QUOTA_ACTIVE and sim=
ply some usage)
Merging vfs/for-next (dcd6c92 Linux 3.3-rc1)
Merging pci/linux-next (fa423b0 PCI: check for pci bar restore completion a=
nd retry)
Merging hid/for-next (2a495e4 Merge branch 'upstream' into for-next)
Merging quilt/i2c (4dd5804 i2c-i801: Use usleep_range to wait for command c=
ompletion)
Merging bjdooks-i2c/next-i2c (fc84fe1 Merge branch 'for_3.3/i2c/misc' of gi=
t://git.kernel.org/pub/scm/linux/kernel/git/khilman/linux-omap-pm into for-=
33/i2c/omap)
CONFLICT (content): Merge conflict in drivers/i2c/busses/i2c-omap.c
Merging quilt/jdelvare-hwmon (48a9dee hwmon: (mc13xxx-adc) Add support for =
the MC13892 PMIC)
Merging hwmon-staging/hwmon-next (0ef464c hwmon: (hwmon-vid) Fix checkpatch=
 issues)
Merging quilt/kernel-doc (7e7b32a Update quilt tree location for Documentat=
ion/ patches.)
Merging docs/docs-move (5c24d8b Merge branch 'docs/docbook/drm' of git://gi=
thub.com/mfwitten/linux into docs-move)
Merging v4l-dvb/master (1854438 Merge /home/v4l/v4l/patchwork)
Merging kbuild/for-next (d90898e Merge branch 'kbuild/misc' into kbuild/for=
-next)
Merging kconfig/for-next (eae1c36 Merge branch 'kconfig/for-linus-2' into k=
config/for-next)
Merging libata/NEXT (b73fa46 [libata] ata_piix: Add Toshiba Satellite Pro A=
120 to the quirks list due to broken suspend functionality.)
Merging infiniband/for-next (715252d IB/srpt: Don't return freed pointer fr=
om srpt_alloc_ioctx_ring())
Merging acpi/next (eb7004e Merge branches 'atomicio-apei', 'hotplug', 'sony=
-nvs-nosave' and 'thermal-netlink' into release)
Merging ieee1394/for-next (6e01490 Merge branch 'fixes' into for-next)
Merging ubi/linux-next (48a6da5 UBI: fix error handling in ubi_scan())
Merging dlm/next (60f98d1 dlm: add recovery callbacks)
Merging scsi/master (76ffe8a [SCSI] libfc: remove redundant timer init for =
fcp)
Merging target-updates/for-next (895f302 target: Set additional sense lengt=
h field in sense data)
Merging target-merge/for-next-merge (a42d985 ib_srpt: Initial SRP Target me=
rge for v3.3-rc1)
Merging ibft/linux-next (935a9fe ibft: Fix finding IBFT ACPI table on UEFI)
Merging slave-dma/next (b63fd6c i.MX SDMA: Fix burstsize settings)
Merging dmaengine/next (d07a74a dmaengine: fix missing 'cnt' in ?: in dmate=
st)
Merging net-next/master (59d7402 Merge branch 'for-davem' of git://git.kern=
el.org/pub/scm/linux/kernel/git/linville/wireless-next)
CONFLICT (content): Merge conflict in drivers/infiniband/hw/nes/nes_cm.c
Merging wireless-next/master (e1936e9 mac80211: call rate control only afte=
r init)
Merging bluetooth/master (c5993de Bluetooth: Correct packet len calculation)
Merging mtd/master (3c3e51d Merge ../linux-2.6 to bring in 3.3-rc fixes alr=
eady merged)
Merging l2-mtd/master (1e43e2c mtd: remove junk pmc551.h)
CONFLICT (content): Merge conflict in include/linux/mtd/mtd.h
CONFLICT (content): Merge conflict in drivers/mtd/nand/gpmi-nand/gpmi-lib.c
CONFLICT (content): Merge conflict in drivers/mtd/chips/cfi_cmdset_0002.c
$ git reset --hard HEAD^
Merging refs/next/20120203/l2-mtd
CONFLICT (content): Merge conflict in include/linux/mtd/mtd.h
CONFLICT (content): Merge conflict in drivers/mtd/nand/gpmi-nand/gpmi-lib.c
CONFLICT (content): Merge conflict in drivers/mtd/chips/cfi_cmdset_0002.c
[master 33ce3a2] Merge commit 'refs/next/20120203/l2-mtd'
Merging crypto/master (0cfdec7 crypto: In crypto_add_alg(), 'exact' wants t=
o be initialized to 0)
CONFLICT (content): Merge conflict in arch/arm/mach-tegra/fuse.c
Merging sound/for-next (306946a Merge branch 'topic/hda' into for-next)
Merging sound-asoc/for-next (f93a4cf Merge branch 'for-3.4' into asoc-next)
CONFLICT (content): Merge conflict in sound/soc/codecs/wm5100.c
Merging cpufreq/next (6c523c6 [CPUFREQ] EXYNOS: Removed useless headers and=
 codes)
Merging quilt/rr (c8b9155 module: Remove module size limit)
Merging input/next (023cea0 Input: tegra-kbc - allow skipping setting up so=
me of GPIO pins)
Merging input-mt/for-next (b89529a Input: Use accessor for MT values)
Merging block/for-next (b3021da Merge branch 'for-3.3/core' into for-next)
Merging quilt/device-mapper (62aa2b5 Linux 3.3-rc2)
Merging embedded/master (4744b43 embedded: fix vc_translate operator preced=
ence)
Merging firmware/master (6e03a20 firmware: speed up request_firmware(), v3)
Merging battery/master (913272b Merge git://git.infradead.org/users/cbou/ba=
ttery-urgent)
Merging mmc/mmc-next (f7c8cdb mmc: sdhci-tegra: Explicitly support Tegra30)
Merging kgdb/kgdb-next (880ba69 lib: rename pack_hex_byte() to hex_byte_pac=
k())
Merging slab/for-next (66c4c35 slub: Do not hold slub_lock when calling sys=
fs_slab_add())
Merging uclinux/for-next (5e442a4 Revert "proc: fix races against execve() =
of /proc/PID/fd**")
Merging md/for-next (34f8ac6 Prevent DM RAID from loading bitmap twice.)
Merging mfd/for-next (fa884b5 mfd: twl-core: Don't specify regulator consum=
ers by struct device)
Merging drm/drm-next (83b316f drm exynos: use drm_fb_helper_set_par directl=
y)
Merging fbdev/fbdev-next (c6d242a video: convert drivers/video/* to use mod=
ule_spi_driver())
Merging viafb/viafb-next (4ce36bb viafb: replace strict_strtoul to kstrto* =
and check return value)
Merging omap_dss2/for-next (9a90168 OMAPDSS: HDMI: Disable DDC internal pul=
l up)
Merging regulator/for-next (071dd81 Merge branch 'regulator-drivers' into r=
egulator-next)
Merging security/next (7b7e591 ima: fix invalid memory reference)
Merging selinux/master (dc2e1ff Merge commit 'v3.2' into 20120130)
Merging lblnet/master (7e27d6e Linux 2.6.35-rc3)
Merging watchdog/linux-next (1776b7d watchdog: fix error in probe() of s3c2=
410_wdt (reset at booting))
Merging dwmw2-iommu/master (c3b92c8 Linux 3.1)
Merging iommu/next (48d2116 Merge branches 'iommu/fixes' and 'arm/tegra' in=
to next)
Merging osd/linux-next (0aa436b exofs: Cap on the memcpy() size)
Merging jc_docs/docs-next (5c050fb docs: update the development process doc=
ument)
Merging trivial/for-next (481e628 drm: Fix typo in rv515.c)
Merging audit/for-next (dcd6c92 Linux 3.3-rc1)
Merging pm/linux-next (3f9e444 PM / Hibernate: Refactor and simplify freeze=
r_test_done)
Merging apm/for-next (b4a133d Merge branch 'for-linus' of git://git.kernel.=
org/pub/scm/linux/kernel/git/jikos/apm)
Merging fsnotify/for-next (ef9bf3b fanotify: only destroy a mark if both it=
s mask and its ignored_mask are cleared)
Merging edac/linux_next (4d096ca MAINTAINERS: add an entry for Edac Sandy B=
ridge driver)
Merging edac-amd/for-next (ed8ccfa Merge branch '3.3-edac-scrubrate' into e=
dac-for-next)
Merging devicetree/devicetree/next (5411972 arm/dts: OMAP3: Add omap3evm an=
d am335xevm support)
Merging spi/spi/next (14af60b spi/pl022: Add high priority message pump sup=
port)
Merging gpio/gpio/next (4e46cde of_gpio: add support of of_gpio_named_count=
 to be able to count named gpio)
CONFLICT (content): Merge conflict in include/linux/mfd/tps65910.h
Merging tip/auto-latest (7620333 Merge branch 'perf/urgent' into auto-lates=
t)
Merging rcu/rcu/next (710fbb1 cpuidle: Inform RCU of read-side critical sec=
tions)
Merging cputime/cputime (c3e0ef9 [S390] fix cputime overflow in uptime_proc=
_show)
Merging uprobes/for-next (766ec38 perf: perf interface for uprobes)
Merging cgroup/for-next (761b3ef cgroup: remove cgroup_subsys argument from=
 callbacks)
Merging kmemleak/kmemleak (b370d29 kmemleak: Disable early logging when kme=
mleak is off by default)
Merging kvm/linux-next (5753785 KVM: do not #GP on perf MSR writes when vPM=
U is disabled)
Merging oprofile/for-next (42fcb11 Merge branch 'oprofile/perf-ibs-v4' into=
 oprofile/for-next)
CONFLICT (content): Merge conflict in tools/perf/util/header.h
CONFLICT (content): Merge conflict in tools/perf/util/header.c
Merging xen/upstream/xen (59e9a6b Merge branch 'upstream/ticketlock-cleanup=
' into upstream/xen)
CONFLICT (content): Merge conflict in arch/x86/include/asm/cmpxchg.h
Merging xen-two/linux-next (5496167 Merge branch 'stable/for-linus-fixes-3.=
3' into linux-next)
Merging xen-pvhvm/linux-next (b056b6a xen: suspend: remove xen_hvm_suspend)
Merging percpu/for-next (26dd8e0 percpu: use bitmap_clear)
Merging workqueues/for-next (6b3da11 Merge branch 'for-3.3' of git://git.ke=
rnel.org/pub/scm/linux/kernel/git/tj/percpu)
Merging hwpoison/hwpoison (46e387b Merge branch 'hwpoison-hugepages' into h=
wpoison)
Merging sysctl/master (4e75732 sysctl: Don't call sysctl_follow_link unless=
 we are a link.)
Merging regmap/for-next (c81797e Merge branch 'regmap-core' into regmap-nex=
t)
CONFLICT (content): Merge conflict in drivers/base/regmap/regmap.c
Merging hsi/for-next (43139a6 HSI: hsi_char: Update ioctl-number.txt)
Merging driver-core/driver-core-next (b3012e1 cpufreq/gx: Fix the compile e=
rror)
CONFLICT (content): Merge conflict in drivers/base/cpu.c
Merging tty/tty-next (d3bda52 TTY: get rid of BTM around devpts_*)
Merging usb/usb-next (0cb54a3 USB: debugging code shouldn't alter control f=
low)
CONFLICT (content): Merge conflict in drivers/usb/class/cdc-wdm.c
Merging staging/staging-next (e96045a staging: nvec: Fix Kconfig dependenci=
es)
Merging char-misc/char-misc-next (a3dc3c9 MISC: convert drivers/misc/* to u=
se module_spi_driver())
Merging tmem/linux-next (b05b561 Merge branch 'devel/frontswap.v13' into li=
nux-next)
Merging writeback/writeback-for-next (977b7e3 writeback: fix dereferencing =
NULL bdi->dev on trace_writeback_queue)
Merging arm-dt/devicetree/arm-next (ede338f dt: add documentation of ARM dt=
 boot interface)
Merging hwspinlock/linux-next (8b37fcf hwspinlock: add MAINTAINERS entries)
Merging pinctrl/for-next (f4e6698 pinctrl: enable pinmux for mmp series)
Merging moduleh/for-sfr (6aec187 drivers/media: video/a5k6aa is a module an=
d so needs module.h)
Merging vhost/linux-next (1e05b62 sh: use the the PCI channels's io_map_bas=
e)
Merging kmap_atomic/kmap_atomic (2c2c817 feature-removal-schedule.txt: add =
the deprecated form of kmap_atomic())
CONFLICT (content): Merge conflict in fs/ecryptfs/read_write.c
CONFLICT (modify/delete): drivers/staging/gma500/mmu.c deleted in HEAD and =
modified in kmap_atomic/kmap_atomic. Version kmap_atomic/kmap_atomic of dri=
vers/staging/gma500/mmu.c left in tree.
CONFLICT (content): Merge conflict in Documentation/feature-removal-schedul=
e.txt
$ git rm -f drivers/staging/gma500/mmu.c
Merging modem-shm/for-next (3cff1cc caif_shm: Add CAIF driver for Shared me=
mory for M7400)
Merging memblock/memblock-kill-early_node_map (7bd0b0f memblock: Reimplemen=
t memblock allocation using reverse free area iterator)
Merging remoteproc/for-next (238c1e1 rpmsg: depends on EXPERIMENTAL)
Applying: rpmsg: rename virtqueue_add_buf_gfp to virtqueue_add_buf
Applying: remoteproc: don't use virtio's weak barriers
Merging irqdomain/irqdomain/next (98ecf52 irq_domain/microblaze: Convert mi=
croblaze to use irq_domains)
Merging kvmtool/master (3e6efe0 kvm-tool: Don't try to cleanup ioeventfd if=
 we never initialised it)
Merging ktest/for-next (be405f9 ktest: Add INGORE_ERRORS to ignore warnings=
 in boot up)
Merging scsi-post-merge/merge-base:master ()
$ git checkout akpm
Applying: net/netfilter/nf_conntrack_netlink.c: fix Oops on container destr=
oy
Applying: pcmcia: fix socket refcount decrementing on each resume
Applying: vfs: fix panic in __d_lookup() with high dentry hashtable counts
Applying: acerhdf: add support for Aspire 1410 BIOS v1.3314
Applying: acerhdf: add support for new hardware
Applying: acerhdf: lowered default temp fanon/fanoff values
Applying: arch/x86/platform/iris/iris.c: register a platform device and a p=
latform driver
Applying: x86, olpc-xo15-sci: enable lid close wakeup control through sysfs
Applying: geos: platform driver for Geos and Geos2 single-board computers
Applying: platform-drivers-x86: convert drivers/platform/x86/* to use modul=
e_platform_driver()
Applying: x86, olpc: add debugfs interface for EC commands
Applying: x86, mm: fix the size calculation of mapping tables
Applying: alix2: supplement driver to include GPIO button support
Applying: alix2-supplement-driver-to-include-gpio-button-support-fix
Applying: x86: net5501: platform driver for Soekris Engineering net5501 sin=
gle-board computer
Applying: net5501-platform-driver-for-soekris-engineering-net5501-single-bo=
ard-computer-fix
Applying: drivers/platform/x86/sony-laptop.c: fix scancodes
Applying: arch/arm/mach-ux500/mbox-db5500.c: world-writable sysfs fifo file
Applying: arm, exec: remove redundant set_fs(USER_DS)
Applying: fs/btrfs/inode-map.c: fix warnings
Applying: net: use this_cpu_xxx replace percpu_xxx funcs
Applying: x86: use this_cpu_xxx to replace percpu_xxx funcs
Applying: arch/x86/kernel/nmi_selftest.c needs percpu.h
Applying: x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs-fix-2
Applying: x86: change percpu_read_stable() to this_cpu_read_stable()
Applying: percpu: remove percpu_xxx() functions
Applying: Subject irqs: fix long-term regression in genirq irq_set_irq_type=
() handling
Applying: irqs: fix handling of pending IRQs at request time
Applying: hrtimers: Special-case zero length sleeps
Applying: hpet: factor timer allocate from open
Applying: drivers/thermal/thermal_sys.c: fix build warning
Applying: thermal-thermal_sys-fix-build-warning-fix
Applying: thermal_sys: remove unnecessary line continuations
Applying: thermal_sys: remove obfuscating used-once macros
Applying: thermal_sys: kernel style cleanups
Applying: thermal_sys: convert printks to pr_<level>
Applying: bluetooth: add support for BCM20702A0 [0a5c:21e6]
Applying: debugobjects: Fix selftest for static warnings
Applying: ocfs2: use find_last_bit()
Applying: ocfs2: use bitmap_weight()
Applying: drivers/scsi/aacraid/commctrl.c: fix mem leak in aac_send_raw_srb=
()
Applying: drivers/scsi/mpt2sas/mpt2sas_base.c: fix mismatch in mpt2sas_base=
_hard_reset_handler() mutex lock-unlock
Applying: drivers/scsi/mpt2sas/mpt2sas_scsih.c: spell "primitive" correctly
Applying: drivers/scsi/hpsa.c: use find_first_zero_bit()
Applying: bio: don't overflow in bio_get_nr_vecs()
Applying: loop: zero fill bio instead of return -EIO for partial read
Applying: MAINTAINERS: Staging: cx25821: Add L: linux-media
Applying: mm, oom: avoid looping when chosen thread detaches its mm
Applying: mm, oom: fold oom_kill_task() into oom_kill_process()
Applying: mm, oom: do not emit oom killer warning if chosen thread is alrea=
dy exiting
Applying: mm: add rss counters consistency check
Applying: mm/vmscan.c: cleanup with s/reclaim_mode/isolate_mode/
Applying: mm: make get_mm_counter static-inline
Applying: mm: vmscan: fix misused nr_reclaimed in shrink_mem_cgroup_zone()
Applying: mm: make swapin readahead skip over holes
Applying: make-swapin-readahead-skip-over-holes-fix
Applying: vmscan: reclaim at order 0 when compaction is enabled
Applying: vmscan: kswapd carefully call compaction
Applying: vmscan-kswapd-carefully-call-compaction-fix
Applying: vmscan: only defer compaction for failed order and higher
Applying: mm: fix page-faults detection in swap-token logic
Applying: mm: add extra free kbytes tunable
Applying: mm-add-extra-free-kbytes-tunable-update
Applying: mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes
Applying: memcg: replace MEM_CONT by MEM_RES_CTLR
Applying: memcg: replace mem and mem_cont stragglers
Applying: memcg: lru_size instead of MEM_CGROUP_ZSTAT
Applying: memcg: enum lru_list lru
Applying: memcg: remove redundant returns
Applying: memcg: remove unnecessary thp check in page stat accounting
Applying: idr: make idr_get_next() good for rcu_read_lock()
Applying: cgroup: revert ss_id_lock to spinlock
Applying: memcg: let css_get_next() rely upon rcu_read_lock()
Applying: memcg: remove PCG_CACHE page_cgroup flag
Applying: memcg-remove-pcg_cache-page_cgroup-flag-checkpatch-fixes
Applying: magic.h: move some FS magic numbers into magic.h
Applying: ceph, cifs, nfs, fuse: boolean and / or confusion
Applying: prctl: add PR_{SET,GET}_CHILD_SUBREAPER to allow simple process s=
upervision
Applying: prctl-add-pr_setget_child_subreaper-to-allow-simple-process-super=
vision-fix
Applying: prctl-add-pr_setget_child_subreaper-to-allow-simple-process-super=
vision-fix-fix
Applying: prctl-add-pr_setget_child_subreaper-to-allow-simple-process-super=
vision-fix-fix-fix
Applying: kernel/exit.c: if init dies, log a signal which killed it, if any
Applying: kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any-fix
Applying: vfs: increment iversion when a file is truncated
Applying: brlocks/lglocks: cleanups
Applying: brlocks-lglocks-cleanups-checkpatch-fixes
Applying: vfs: correctly set the dir i_mutex lockdep class
Applying: seq_file: fix mishandling of consecutive pread() invocations.
Applying: MAINTAINERS: fix REMOTEPROC F: typo
Applying: backlight: convert backlight i2c drivers to module_i2c_driver
Applying: backlight: convert backlight spi drivers to module_spi_driver
Applying: drivers/video/backlight/wm831x_bl.c: use devm_ functions
Applying: drivers/video/backlight: use devm_ functions
Applying: drivers/video/backlight/adp5520_bl.c: use devm_ functions
Applying: backlight: new backlight driver for LP855x devices
Applying: video: support MIPI-DSI controller driver
Applying: video: backlight: support s6e8ax0 panel driver based on MIPI DSI
Applying: video-backlight-support-s6e8ax0-panel-driver-based-on-mipi-dsi-fix
Applying: WARNING: please write a paragraph that describes the config symbo=
l fully
Applying: bitops: rename for_each_set_bit_cont() in favor of analogous list=
.h function
Applying: bitops: remove for_each_set_bit_cont()
Applying: bitops: introduce for_each_clear_bit()
Applying: mtd: use for_each_clear_bit()
Applying: s390/char: use for_each_clear_bit()
Applying: uwb: use for_each_clear_bit()
Applying: x86: use for_each_clear_bit_from()
Applying: drivers/leds/leds-lp5521.c: fix typo
Applying: drivers/leds/leds-tca6507.c: cleanup error handling in tca6507_pr=
obe()
Applying: drivers/leds/leds-lp5521.c: add 'name' in the lp5521_led_config
Applying: drivers/leds/leds-lp5521.c: add 'update_config' in the lp5521_pla=
tform_data
Applying: drivers/leds/leds-lp5521.c: support led pattern data
Applying: leds-lp5521-support-led-pattern-data-checkpatch-fixes
Applying: drivers/leds/leds-lp5521.c: redefinition of register bits
Applying: drivers/leds/leds-lp5523.c: constify some data
Applying: include/ and checkpatch: prefer __scanf to __attribute__((format(=
scanf,...)
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
Applying: crc32: Don't reference unnecessary crc32 tables in single-bit mode
Applying: crypto: crc32c should use library implementation
Applying: crc32: add self-test code for crc32c
Applying: crc32: select an algorithm via Kconfig
Applying: epoll: comment the funky #ifdef
Applying: init/do_mounts.c: create /root if it does not exist
Applying: rtc-spear: fix for balancing the enable_irq_wake in Power Mgmt
Applying: rtc/spear: fix for RTC_AIE_ON and RTC_AIE_OFF ioctl errors
Applying: rtc/rtc-spear: call platform_set_drvdata() before registering rtc=
 device
Applying: rtc: convert rtc spi drivers to module_spi_driver
Applying: rtc: convert rtc i2c drivers to module_i2c_driver
Applying: MIPS: add RTC support for loongson1B
Applying: drivers/rtc/rtc-twl.c: optimize IRQ bit access
Applying: drivers/rtc/rtc-twl.c: enable RTC irrespective of its prior state
Applying: drivers/rtc/rtc-twl.c: simplify RTC interrupt clearing
Applying: drivers/rtc/rtc-twl.c: return correct RTC event from ISR
Applying: kmod: avoid deadlock from recursive kmod call
Applying: kmod-avoid-deadlock-by-recursive-kmod-call-fix
Applying: fs/proc/kcore.c: make get_sparsemem_vmemmap_info() static
Applying: proc: speedup /proc/stat handling
Applying: procfs: add num_to_str() to speed up /proc/stat
Applying: procfs-add-num_to_str-to-speed-up-proc-stat-fix
Applying: procfs: speed up /proc/pid/stat, statm
Applying: procfs-speed-up-proc-pid-stat-statm-checkpatch-fixes
Applying: proc: clean up /proc/<pid>/environ handling
Applying: smp: introduce a generic on_each_cpu_mask() function
Applying: arm: move arm over to generic on_each_cpu_mask
Applying: tile: move tile to use generic on_each_cpu_mask
Applying: smp: add func to IPI cpus based on parameter func
Applying: smp-add-func-to-ipi-cpus-based-on-parameter-func-fix
Applying: slub: only IPI CPUs that have per cpu obj to flush
Applying: fs: only send IPI to invalidate LRU BH when needed
Applying: mm: only IPI CPUs to drain local pages if they exist
Applying: ipc/sem.c: alternatives to preempt_disable()
Applying: ipc: provide generic compat versions of IPC syscalls
Applying: sysctl: use bitmap library functions
Applying: sysctl: make kernel.ns_last_pid control dependent on CHECKPOINT_R=
ESTORE
Applying: ramoops: use pstore interface
Applying: notify_change(): check that i_mutex is held
Merging akpm (c034ffe notify_change(): check that i_mutex is held)
[master beb25da] Revert "gpio: Add a driver for Sodaville GPIO controller"

--Signature=_Tue__7_Feb_2012_17_09_33_+1100_ku03kK1N50ajL0AK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPMMAdAAoJEECxmPOUX5FEO2QP/iHKTvUwyewwSPfX6EfkWsQp
tNo3mgseH7g1rCv4SGqgt6HAUWmYN0DZvg21IrG2dyZ3ouu7WUCMbQEPTN6wfP7T
Gg2FLuP6D7s5jR+QZqgB3Yt6GfL9S1rUSREi+GF8nMqll+jOteZRKbv1pxuM+mR6
GFJDLCOFCjyEAbLWn3PklfDLljUkYe7OJ7S4vuipuxxqY2MX2u+w7ekyE7BtW0c1
wK8KlJLwukAcqVbnMpn7c9DjMSXm83FetlGawI1tpPcJ8sci0/KYVH8p8btkJ3xQ
B4k6d4fYZir66duYeFGCYeJftOQwC/ydnCRGIeH4RwsGyc23zFIY/q0OnU2cPmlj
juPn4/miT9sCJK5iY5yVJQW6FxrxrKXlO7CGsTFAZoy1e6lNDmAJ2nNBmcrUG+cs
amVzMG8DZKnI9x2jsgYad7Cklrt2MiDPTdSZ4/mDauxeHY7GpEJEmfNgJRmcMrFu
NfJfWKkAz6rDMCjjKFz8Z+1BkYZN5TryoAxHeRuMbdd3av+3cB0T3lp7uwVUTD9U
1Ll6iTGEmAJXmab+TZ1b7Fpe735c2iTcwvXSnVraiCo9MlylG8o2Oj/OaSEDY/4B
8Rz/TzazFjhi+U+QtYobp5Vg72ueqtLYme2H+bWmuke8YroFCMkW2Yohy2O2iBj6
MN2igOBvXySDZUTm9fJU
=fMT7
-----END PGP SIGNATURE-----

--Signature=_Tue__7_Feb_2012_17_09_33_+1100_ku03kK1N50ajL0AK--

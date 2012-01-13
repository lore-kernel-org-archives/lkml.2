Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067Ab2AME62 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 23:58:28 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:54375 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572Ab2AME6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 23:58:21 -0500
Date: Fri, 13 Jan 2012 15:58:08 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Jan 13
Message-Id: <20120113155808.05431d23da358e37b19eee7c@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__13_Jan_2012_15_58_08_+1100_G6BbhoZLrmBIPmmF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__13_Jan_2012_15_58_08_+1100_G6BbhoZLrmBIPmmF
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20120112:

The arm-current tree gained a conflict against Linus' tree.

The sound-current tree lost its conflicts.

The pci tree lost its conflicts.

The 4vl-dvb tree lost lots of conflicts.

The rr tree lost a conflict.

The mmc tree lost its conflicts.

The fbdev tree lost its conflict.

The security tree lost its conflicts.

The tmem tree lost its conflicts.

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

We are up to 205 trees (counting Linus' and 28 trees of patches pending
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
Merging origin/master (2485a4b Merge branch 'for-linus' of git://git.kernel=
.org/pub/scm/linux/kernel/git/dtor/input)
Merging fixes/master (371de6e drm/i915: Disable RC6 on Sandybridge by defau=
lt)
Merging kbuild-current/rc-fixes (fa0ad65 kconfig: adapt update-po-config to=
 new UML layout)
Merging arm-current/fixes (58cbba6 ARM: 7275/1: LPAE: Check the CPU support=
 for the long descriptor format)
CONFLICT (content): Merge conflict in arch/arm/mach-exynos/common.c
Merging m68k-current/for-linus (3bd9e50 m68k/mac: Make CONFIG_HEARTBEAT una=
vailable on Mac)
Merging powerpc-merge/merge (ebb7f61 powerpc: Fix unpaired __trace_hcall_en=
try and __trace_hcall_exit)
Merging 52xx-and-virtex-current/powerpc/merge (c49f878 dtc/powerpc: remove =
obsolete .gitignore entries)
Merging sparc/master (e51e07e sparc32: forced setting of mode of sun4m per-=
cpu timers)
Merging scsi-rc-fixes/master (6f6c2aa [SCSI] fcoe: fix fcoe in a DCB enviro=
nment by adding DCB notifiers to set skb priority)
Merging net/master (72092cc dp83640: Fix NOHZ local_softirq_pending 08 warn=
ing)
Merging sound-current/for-linus (9e4ce16 Merge branch 'topic/hda' into for-=
linus)
Merging pci-current/for-linus (8b6a5af PCI: Add Thinkpad SL510 to pci=3Dnoc=
rs blacklist)
Merging wireless/master (1140afa mac80211: fix rx->key NULL pointer derefer=
ence in promiscuous mode)
Merging driver-core.current/driver-core-linus (c99516c Merge branch 'for-li=
nus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs)
Merging tty.current/tty-linus (6b3da11 Merge branch 'for-3.3' of git://git.=
kernel.org/pub/scm/linux/kernel/git/tj/percpu)
Merging usb.current/usb-linus (6b3da11 Merge branch 'for-3.3' of git://git.=
kernel.org/pub/scm/linux/kernel/git/tj/percpu)
Merging staging.current/staging-linus (6b3da11 Merge branch 'for-3.3' of gi=
t://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu)
Merging char-misc.current/char-misc-linus (6b3da11 Merge branch 'for-3.3' o=
f git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu)
Merging cpufreq-current/fixes (5983fe2 Merge git://git.kernel.org/pub/scm/l=
inux/kernel/git/davem/net)
Merging input-current/for-linus (52965cc Input: bcm5974 - set BUTTONPAD pro=
perty)
Merging md-current/for-linus (307729c md/raid1: perform bad-block tests for=
 WriteMostly devices too.)
Merging audit-current/for-linus (def5754 Audit: remove spaces from audit_lo=
g_d_path)
Merging crypto-current/master (08c70fc crypto: gf128mul - remove leftover "=
(EXPERIMENTAL)" in Kconfig)
Merging ide/master (0ab3d8b cy82c693: fix PCI device selection)
Merging dwmw2/master (244dc4e Merge git://git.infradead.org/users/dwmw2/ran=
dom-2.6)
Merging sh-current/sh-fixes-for-linus (21d41f2 sh: fix the compile error in=
 setup-sh7757.c)
Merging rmobile-current/rmobile-fixes-for-linus (a408bae ARM: mach-shmobile=
: sh7372 CMT3 and CMT4 clock support)
Merging devicetree-current/devicetree/merge (c89810a ARM: prom.h: Fix build=
 error by removing unneeded header file)
Merging spi-current/spi/merge (e583685 Merge branch 'spi/next' (early part)=
 into spi/merge)
Merging gpio-current/gpio/merge (87b9b0e gpio: Fix DA9052 GPIO build errors=
.)
Merging arm/for-next (4ce44b8 Merge branch 'restart' into for-next)
CONFLICT (content): Merge conflict in arch/arm/mach-s5pv210/common.c
CONFLICT (content): Merge conflict in arch/arm/mach-s5pc100/common.c
CONFLICT (content): Merge conflict in arch/arm/mach-omap2/pm34xx.c
CONFLICT (content): Merge conflict in arch/arm/mach-mx5/mm.c
CONFLICT (content): Merge conflict in arch/arm/mach-exynos/common.c
CONFLICT (content): Merge conflict in arch/arm/mach-at91/at91sam9rl.c
CONFLICT (content): Merge conflict in arch/arm/mach-at91/at91sam9263.c
CONFLICT (content): Merge conflict in arch/arm/mach-at91/at91sam9261.c
CONFLICT (content): Merge conflict in arch/arm/mach-at91/at91sam9260.c
Merging arm-soc/for-next (0db991d LOCAL: add back arch/arm/arm-soc-for-next=
-contents.txt)
Merging arm-perf/for-next/perf (7e9523f ARM: perf: remove unused armpmu_get=
_max_events)
Merging at91/at91-next (8748dfa Merge branch 'for-linus' of git://git.kerne=
l.org/pub/scm/linux/kernel/git/aegl/linux)
Merging davinci/davinci-next (fe0d422 Linux 3.0-rc6)
Merging linux-spec/for-next (5111711 Merge branch 'for-2.6.37' of git://lin=
ux-nfs.org/~bfields/linux)
Merging omap/for-next (322a8b0 Linux 3.1-rc1)
Merging pxa/for-next (19d6c13 [ARM] pxa/hx4700: actually use platform_lcd d=
river)
Merging samsung/next-samsung (9edb240 ARM: H1940/RX1950: Change default LED=
 triggers)
Merging s5p/for-next (e914815 Merge branches 'next-samsung-cleanup2' and 'n=
ext-samsung-devel2' into for-next)
Merging tegra/for-next (bdd01cc Merge branch 'for-3.3/dt' into for-next)
Merging xilinx/arm-next (b85a3ef ARM: Xilinx: Adding Xilinx board support)
Merging blackfin/for-linus (dda6779 blackfin: bf561: add adv7183 capture su=
pport)
Merging c6x/for-linux-next (166c0ea C6X: replace tick_nohz_stop/restart_sch=
ed_tick calls)
Merging cris/for-next (ea78f5b CRIS: Update documentation)
Merging quilt/hexagon (110b372 Remove unneeded include of version.h from ar=
ch/hexagon/include/asm/spinlock_types.h)
CONFLICT (content): Merge conflict in arch/hexagon/Kconfig
Merging ia64/next (65cc21b ia64: Add accept4() syscall)
Merging m68k/for-next (3bd9e50 m68k/mac: Make CONFIG_HEARTBEAT unavailable =
on Mac)
Merging m68knommu/for-next (1f7034b m68k: allow ColdFire 547x and 548x CPUs=
 to be built with MMU enabled)
Merging microblaze/next (d761f0c microblaze: Add topology init)
Merging mips/mips-for-linux-next (7bf6612 Merge branches 'next/ar7', 'next/=
ath79', 'next/bcm63xx', 'next/bmips', 'next/cavium', 'next/generic', 'next/=
kprobes', 'next/lantiq', 'next/perf' and 'next/raza' into mips-for-linux-ne=
xt)
CONFLICT (content): Merge conflict in drivers/tty/serial/Makefile
CONFLICT (content): Merge conflict in arch/mips/kernel/perf_event_mipsxx.c
Merging openrisc/for-upstream (b6fd41e Linux 3.1-rc6)
Merging parisc/for-next (fc99a91 futex: Use same lock set as lws calls)
Merging powerpc/next (ef88e39 powerpc: fix compile error with 85xx/p1010rdb=
.c)
Merging 4xx/next (e4f387d powerpc: Fix unpaired probe_hcall_entry and probe=
_hcall_exit)
Merging 52xx-and-virtex/powerpc/next (c1395f4 dtc/powerpc: remove obsolete =
.gitignore entries)
Merging galak/next (ef88e39 powerpc: fix compile error with 85xx/p1010rdb.c)
Merging s390/features (f018e7a [patch 1/1] [PATCH] cleanup entry point defi=
nition)
Merging sh/sh-latest (b9a3acf Merge branch 'sh/stable-updates' into sh-late=
st)
Merging rmobile/rmobile-latest (b58c580 Merge branch 'rmobile-fixes-for-lin=
us' into rmobile-latest)
Merging sparc-next/master (e4e1118 Merge branch 'for-linus' of git://git.ke=
rnel.org/pub/scm/linux/kernel/git/viro/vfs)
Merging tile/master (0c90547 arch/tile: use new generic {enable,disable}_pe=
rcpu_irq() routines)
Merging unicore32/unicore32 (b3a0aa3 rtc-puv3: solve section mismatch in rt=
c-puv3.c)
Merging xtensa/master (29aced6 xtensa: remove defining register numbers)
Merging ceph/for-next (83eb26a ceph: ensure prealloc_blob is in place when =
removing xattr)
CONFLICT (content): Merge conflict in fs/ceph/super.c
Merging cifs/master (7250170 cifs: integer overflow in parse_dacl())
Merging configfs/linux-next (b930c26 Merge branch 'for-linus' of git://git.=
kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (7e6aad6 eCryptfs: Improve statfs reporting)
Merging ext3/for_next (46fe44c quota: Pass information that quota is stored=
 in system file to userspace)
Applying: fs: make put_super global again
Merging ext4/dev (d50f2ab ext4: fix undefined behavior in ext4_fill_flex_in=
fo())
Merging fatfs/master (710d440 fat: fat16 support maximum 4GB file/vol size =
as WinXP or 7.)
Merging fuse/for-next (03c9693 cuse: implement memory mapping)
Merging gfs2/master (66ad863 GFS2: Fix nlink setting on inode creation)
Merging hfsplus/for-next (6596528 hfsplus: ensure bio requests are not smal=
ler than the hardware sectors)
Merging jfs/next (1c8007b jfs: flush journal completely before releasing me=
tadata inodes)
Merging logfs/master (21f3eb8 logfs: update page reference count for pined =
pages)
CONFLICT (content): Merge conflict in fs/logfs/file.c
CONFLICT (content): Merge conflict in fs/logfs/dev_mtd.c
Merging nfs/linux-next (7c5465d pnfsblock: alloc short extent before submit=
 bio)
Merging nfsd/nfsd-next (7a6ef8c nfsd4: nfsd4_create_clid_dir return value i=
s unused)
Merging nilfs2/for-next (93ee7a9 Linux 3.1-rc2)
Merging ocfs2/linux-next (9392557 ocfs2: avoid unaligned access to dqc_bitm=
ap)
Merging omfs/for-next (976d167 Linux 3.1-rc9)
Merging squashfs/master (3d4a1c8 Squashfs: fix i_blocks calculation with ex=
tended regular files)
Merging v9fs/for-next (f766619 fs/9p: iattr_valid flags are kernel internal=
 flags map them to 9p values.)
Merging ubifs/linux-next (e57e0d8 UBI: fix use-after-free on error path)
Merging xfs/master (b1c770c xfs: fix endian conversion issue in discard cod=
e)
Merging vfs/for-next (f84a8bd btrfs: take allocation of ->tree_root into op=
en_ctree())
Merging vfs-scale/vfs-scale-working (32385c7 kernel: fix hlist_bl again)
Merging pci/linux-next (76ccc29 x86/PCI: Expand the x86_msi_ops to have a r=
estore MSIs.)
Merging hid/for-next (f62f619 Merge branch 'for-linus' of git://git.kernel.=
org/pub/scm/linux/kernel/git/jikos/hid)
Merging quilt/i2c (4309f8e MAINTAINERS: List i2c-omap and i2c-davinci drive=
rs)
Merging bjdooks-i2c/next-i2c (fc84fe1 Merge branch 'for_3.3/i2c/misc' of gi=
t://git.kernel.org/pub/scm/linux/kernel/git/khilman/linux-omap-pm into for-=
33/i2c/omap)
Merging quilt/jdelvare-hwmon (69fe4bc hwmon: (adm1031) Fix coding style iss=
ues)
Merging hwmon-staging/hwmon-next (91c8eab max1111.c: fix checkpatch warning)
Merging quilt/kernel-doc (5851bad The Japanese/Korean/Chinese versions stil=
l need updating.)
Merging docs/docs-move (5c24d8b Merge branch 'docs/docbook/drm' of git://gi=
thub.com/mfwitten/linux into docs-move)
Merging v4l-dvb/master (ebe9674 mb86a20s: Add a few more register settings =
at the init seq)
CONFLICT (content): Merge conflict in drivers/media/video/omap3isp/ispccdc.c
CONFLICT (content): Merge conflict in drivers/media/common/tuners/tda18218.c
Merging kbuild/for-next (ceef89b Merge branch 'kbuild/kbuild' into kbuild/f=
or-next)
Merging kconfig/for-next (eae1c36 Merge branch 'kconfig/for-linus-2' into k=
config/for-next)
Merging libata/NEXT (318893e ahci: support the STA2X11 I/O Hub)
Merging infiniband/for-next (1583676 Merge branches 'cma', 'misc', 'mlx4', =
'nes', 'qib' and 'uverbs' into for-next)
Merging acpi/next (efb9058 Merge branches 'acpi', 'idle', 'mrst-pmu' and 'p=
m-tools' into next)
Merging cpupowerutils/master (498ca79 cpupower: use man(1) when calling "cp=
upower help subcommand")
Merging ieee1394/for-next (2ca526b MAINTAINERS: firewire git URL update)
Merging ubi/linux-next (805a6af Linux 3.2)
Merging dlm/next (60f98d1 dlm: add recovery callbacks)
Merging scsi/master (410f02d [SCSI] scsi_dh_alua: Retry the check-condition=
 in case Mode Parameters Changed)
Merging target-updates/for-next (895f302 target: Set additional sense lengt=
h field in sense data)
Merging target-merge/for-next-merge (a42d985 ib_srpt: Initial SRP Target me=
rge for v3.3-rc1)
Merging ibft/linux-next (935a9fe ibft: Fix finding IBFT ACPI table on UEFI)
Merging slave-dma/next (e08b881 ARM: mach-shmobile: specify CHCLR registers=
 on SH7372)
Merging async_tx/next (21ef4b8 dmaengine: use DEFINE_IDR for static initial=
ization)
Merging net-next/master (356b954 Merge branch 'for-linus' of git://git.kern=
el.org/pub/scm/linux/kernel/git/geert/linux-m68k)
Merging wireless-next/master (a8c1f65 igmp: Avoid zero delay when receiving=
 odd mixture of IGMP queries)
Merging bluetooth/master (c5993de Bluetooth: Correct packet len calculation)
Merging mtd/master (f5eee48 mtd: cfi: AMD/Fujitsu compatibles: add panic wr=
ite support)
Merging l2-mtd/master (b16f0ab mtd: cfi: AMD/Fujitsu compatibles: add panic=
 write support)
CONFLICT (content): Merge conflict in drivers/mtd/nand/gpmi-nand/gpmi-lib.c
Merging crypto/master (07d106d vfs: fix up ENOIOCTLCMD error handling)
Merging sound/for-next (f7788fe Merge branch 'topic/asoc' into for-next)
Merging sound-asoc/for-next (40432fc Merge branch 'for-3.3' into asoc-next)
Merging cpufreq/next (6c523c6 [CPUFREQ] EXYNOS: Removed useless headers and=
 codes)
Merging quilt/rr (35c861e intelfbdrv.c: bailearly is an int module_param)
CONFLICT (content): Merge conflict in scripts/mod/file2alias.c
CONFLICT (content): Merge conflict in fs/nfs/client.c
CONFLICT (content): Merge conflict in drivers/input/touchscreen/ucb1400_ts.c
CONFLICT (content): Merge conflict in arch/x86/kvm/mmu.c
Merging input/next (dab78d7 Input: tc3589x-keypad - add missing kerneldoc)
Merging input-mt/next (02f8c6a Linux 3.0)
Merging lsm/for-next (ca05a99 capabilities: remain source compatible with 3=
2-bit raw legacy capability support.)
Merging block/for-next (6f4ac2b Merge branch 'for-3.3/core' into for-next)
CONFLICT (content): Merge conflict in block/blk-cgroup.c
Merging quilt/device-mapper (ecefc36 Merge git://git.kernel.org/pub/scm/lin=
ux/kernel/git/davem/net)
Merging embedded/master (4744b43 embedded: fix vc_translate operator preced=
ence)
Merging firmware/master (6e03a20 firmware: speed up request_firmware(), v3)
Merging pcmcia/master (74411c0 smc91c92_cs.c: fix bogus compiler warning)
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
CONFLICT (content): Merge conflict in scripts/mod/file2alias.c
CONFLICT (content): Merge conflict in drivers/leds/Kconfig
Merging hdlc/hdlc-next (4a6908a Linux 2.6.28)
Merging drm/drm-next (095f979 drm/nouveau/pm: fix build with HWMON off)
Merging fbdev/fbdev-next (f787f32 module_param: make bool parameters really=
 bool (drivers/video/i810))
Merging viafb/viafb-next (4ce36bb viafb: replace strict_strtoul to kstrto* =
and check return value)
Merging omap_dss2/for-next (9a90168 OMAPDSS: HDMI: Disable DDC internal pul=
l up)
Merging regulator/for-next (0c437c4 regulator: set constraints.apply_uV to =
0 in of_get_fixed_voltage_config)
Merging security/next (7b7e591 ima: fix invalid memory reference)
Merging selinux/master (f423e5b capabilities: remove __cap_full_set definit=
ion)
Applying: selinux tree pull for 2012-01-05, known build issue
Merging lblnet/master (7e27d6e Linux 2.6.35-rc3)
Merging watchdog/linux-next (e2bf7c4 watchdog: omap_wdt.c: fix the WDIOC_GE=
TBOOTSTATUS ioctl if not implemented.)
Merging bdev/master (feaf384 Merge branch 'for-linus' of git://git.kernel.d=
k/linux-2.6-block)
Merging dwmw2-iommu/master (c3b92c8 Linux 3.1)
Merging iommu/next (f93ea73 Merge branches 'iommu/page-sizes' and 'iommu/gr=
oup-id' into next)
Merging osd/linux-next (724577c ore: Must support none-PAGE-aligned IO)
Merging jc_docs/docs-next (5c050fb docs: update the development process doc=
ument)
Merging nommu/master (0ce790e Linux 2.6.39-rc1)
Merging trivial/for-next (9879326 Merge branch 'for-linus' of git://git.ker=
nel.org/pub/scm/linux/kernel/git/jikos/trivial)
Merging audit/for-next (def5754 Audit: remove spaces from audit_log_d_path)
Merging pm/linux-next (c233523 Merge branch 'pm-sleep' into pm-for-linus)
Merging apm/for-next (b4a133d Merge branch 'for-linus' of git://git.kernel.=
org/pub/scm/linux/kernel/git/jikos/apm)
Merging fsnotify/for-next (ef9bf3b fanotify: only destroy a mark if both it=
s mask and its ignored_mask are cleared)
Merging irda/for-next (94d57c4 enic: Update MAINTAINERS)
Merging edac/linux_next (4d096ca MAINTAINERS: add an entry for Edac Sandy B=
ridge driver)
Merging edac-amd/for-next (ed8ccfa Merge branch '3.3-edac-scrubrate' into e=
dac-for-next)
Merging devicetree/devicetree/next (b021ca7 ARM: prom.h: Fix build error by=
 removing unneeded header file)
Merging spi/spi/next (14c173e spi/tegra: depend instead of select TEGRA_SYS=
TEM_DMA)
Merging gpio/gpio/next (fda8790 Merge branch 'gpio-for-grant' of git://sour=
ces.calxeda.com/kernel/linux into gpio/next)
Merging tip/auto-latest (f2d7654 Merge branch 'sched/urgent' into auto-late=
st)
Merging rcu/rcu/next (f0312a5 rcu: Bring RTFP.txt up to date.)
Merging cputime/cputime (c3e0ef9 [S390] fix cputime overflow in uptime_proc=
_show)
Merging uprobes/for-next (0a19a93 perf: perf interface for uprobes)
Applying: uprobes: bad merge fix
Merging cgroup/for-next (6b3da11 Merge branch 'for-3.3' of git://git.kernel=
.org/pub/scm/linux/kernel/git/tj/percpu)
Merging kmemleak/kmemleak (029aeff kmemleak: Add support for memory hotplug)
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
Merging percpu/for-next (6b3da11 Merge branch 'for-3.3' of git://git.kernel=
.org/pub/scm/linux/kernel/git/tj/percpu)
Merging workqueues/for-next (6b3da11 Merge branch 'for-3.3' of git://git.ke=
rnel.org/pub/scm/linux/kernel/git/tj/percpu)
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
Merging regmap/for-next (0a92815 mfd: Clearing events requires event regist=
ers to be writable for da9052-core)
Merging hsi/for-next (43139a6 HSI: hsi_char: Update ioctl-number.txt)
Merging driver-core/driver-core-next (c99516c Merge branch 'for-linus' of g=
it://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs)
Merging tty/tty-next (6b3da11 Merge branch 'for-3.3' of git://git.kernel.or=
g/pub/scm/linux/kernel/git/tj/percpu)
Merging usb/usb-next (6b3da11 Merge branch 'for-3.3' of git://git.kernel.or=
g/pub/scm/linux/kernel/git/tj/percpu)
Merging staging/staging-next (6b3da11 Merge branch 'for-3.3' of git://git.k=
ernel.org/pub/scm/linux/kernel/git/tj/percpu)
Merging char-misc/char-misc-next (6b3da11 Merge branch 'for-3.3' of git://g=
it.kernel.org/pub/scm/linux/kernel/git/tj/percpu)
Merging bkl-config/config (4ba8216 BKL: That's all, folks)
Merging tmem/linux-next (805a6af Linux 3.2)
Merging writeback/writeback-for-next (bc31b86 writeback: move MIN_WRITEBACK=
_PAGES to fs-writeback.c)
Merging arm-dt/devicetree/arm-next (ede338f dt: add documentation of ARM dt=
 boot interface)
Merging hwspinlock/linux-next (8b37fcf hwspinlock: add MAINTAINERS entries)
Merging pinctrl/for-next (0d2006b pinctrl: remove unnecessary max pin numbe=
r)
Merging moduleh/for-sfr (6aec187 drivers/media: video/a5k6aa is a module an=
d so needs module.h)
Merging vhost/linux-next (193a667 alpha: drop pci_iomap/pci_iounmap from pc=
i-noop.c)
Merging kmap_atomic/kmap_atomic (bb30431 feature-removal-schedule.txt: add =
the deprecated form of kmap_atomic())
CONFLICT (content): Merge conflict in Documentation/feature-removal-schedul=
e.txt
Merging xshm/xshm-for-next (0d0ab68 caif-xshm: Add CAIF driver for Shared m=
emory for M7400)
Merging memblock/memblock-kill-early_node_map (7bd0b0f memblock: Reimplemen=
t memblock allocation using reverse free area iterator)
Merging remoteproc/for-next (238c1e1 rpmsg: depends on EXPERIMENTAL)
Applying: rpmsg: rename virtqueue_add_buf_gfp to virtqueue_add_buf
Applying: remoteproc: don't use virtio's weak barriers
Merging kvmtool/master (1cf7f48 kvm tools: Simply write_in_full() check sem=
antics)
CONFLICT (content): Merge conflict in scripts/kconfig/Makefile
CONFLICT (content): Merge conflict in include/net/9p/9p.h
Merging uapi/for-next (1632b9e UAPI: Split trivial #if defined(__KERNEL__) =
&& X conditionals)
Merging scsi-post-merge/merge-base:master ()
$ git checkout akpm
Applying: net/netfilter/nf_conntrack_netlink.c: fix Oops on container destr=
oy
Applying: drivers/watchdog/hpwdt.c: mark page executable
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
Applying: ia64, exec: remove redundant set_fs(USER_DS)
Applying: kconfig: add merge_config.sh script
Applying: merge_config.sh: use signal names compatible with dash and bash
Applying: merge_config.sh: whitespace cleanup
Applying: merge_config.sh: fix bug in final check
Applying: ipc/mqueue: cleanup definition names and locations
Applying: ipc/mqueue: switch back to using non-max values on create
Applying: ipc/mqueue: enforce hard limits
Applying: ipc/mqueue: update maximums for the mqueue subsystem
Applying: ipc-mqueue-update-maximums-for-the-mqueue-subsystem-fix
Applying: ipc-mqueue-update-maximums-for-the-mqueue-subsystem-checkpatch-fi=
xes
Applying: debugobjects: Fix selftest for static warnings
Applying: parisc, exec: remove redundant set_fs(USER_DS)
Applying: scsi: fix a header to include linux/types.h
Applying: drivers/scsi/megaraid.c: fix sparse warnings
Applying: drivers/scsi/aacraid/commctrl.c: fix mem leak in aac_send_raw_srb=
()
Applying: drivers/scsi/sg.c: convert to kstrtoul_from_user()
Applying: drivers/scsi/mpt2sas/mpt2sas_base.c: fix mismatch in mpt2sas_base=
_hard_reset_handler() mutex lock-unlock
Applying: MAINTAINERS: Staging: cx25821: Add L: linux-media
Applying: slub: document setting min order with debug_guardpage_minorder > 0
Applying: slub-document-setting-min-order-with-debug_guardpage_minorder-0-c=
heckpatch-fixes
Applying: mm: fix page-faults detection in swap-token logic
Applying: mm: add extra free kbytes tunable
Applying: mm-add-extra-free-kbytes-tunable-update
Applying: mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes
Applying: mm-simplify-find_vma_prev-fix
Applying: mm: simplify find_vma_prev
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
Applying: ceph, cifs, nfs, fuse: boolean and / or confusion
Applying: pipe: fail cleanly when root tries F_SETPIPE_SZ with big size
Applying: epoll: limit paths
Applying: init/do_mounts.c: create /root if it does not exist
Applying: rtc-ab8500-add-calibration-attribute-to-ab8500-rtc-v3
Applying: rtc-ab8500-add-calibration-attribute-to-ab8500-rtc-v3-checkpatch-=
fixes
Applying: cpusets, cgroups: disallow attaching kthreadd
Applying: memcg: add mem_cgroup_replace_page_cache() to fix LRU issue
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
Applying: mm-memcg-lookup_page_cgroup-almost-never-returns-null fix
Applying: mm: page_cgroup: check page_cgroup arrays in lookup_page_cgroup()=
 only when necessary
Applying: mm: memcg: remove unneeded checks from newpage_charge()
Applying: mm: memcg: remove unneeded checks from uncharge_page()
Applying: page_cgroup: add helper function to get swap_cgroup
Applying: page_cgroup: cleanup lookup_swap_cgroup()
Applying: memcg: free entries in soft_limit_tree if allocation fails
Applying: oom, memcg: fix exclusion of memcg threads after they have detach=
ed their mm
Applying: memcg: simplify page cache charging
Applying: memcg: simplify corner case handling of LRU.
Applying: memcg: clear pc->mem_cgorup if necessary.
Applying: memcg-clear-pc-mem_cgorup-if-necessary-fix
Applying: memcg-clear-pc-mem_cgorup-if-necessary-fix-2
Applying: memcg-clear-pc-mem_cgorup-if-necessary-fix-2-fix
Applying: memcg-clear-pc-mem_cgorup-if-necessary-comments
Applying: memcg-clear-pc-mem_cgorup-if-necessary fix 3
Applying: memcg: simplify LRU handling by new rule
Applying: memcg-simplify-lru-handling-by-new-rule-fix
Applying: memcg: return -EINTR at bypassing try_charge()
Applying: memcg-simplify-lru-handling-by-new-rule-memcg-return-eintr-at-byp=
assing-try_charge-fix
Applying: memcg: cleanup for_each_node_state()
Applying: page_alloc: break early in check_for_regular_memory()
Applying: page_cgroup: drop multi CONFIG_MEMORY_HOTPLUG
Applying: thp: improve the error code path
Applying: thp: remove unnecessary tlb flush for mprotect
Applying: thp: add tlb_remove_pmd_tlb_entry
Applying: thp: improve order in lru list for split huge page
Applying: vmscan/trace: Add 'file' info to trace_mm_vmscan_lru_isolate()
Applying: mm: compaction: allow compaction to isolate dirty pages
Applying: mm: compaction: use synchronous compaction for /proc/sys/vm/compa=
ct_memory
Applying: mm: vmscan: check if we isolated a compound page during lumpy scan
Applying: mm: vmscan: do not OOM if aborting reclaim to start compaction
Applying: mm: compaction: determine if dirty pages can be migrated without =
blocking within ->migratepage
Applying: mm: compaction: make isolate_lru_page() filter-aware again
Applying: mm: page allocator: do not call direct reclaim for THP allocation=
s while compaction is deferred
Applying: mm: compaction: introduce sync-light migration for use by compact=
ion
Applying: mm-compaction-introduce-sync-light-migration-for-use-by-compactio=
n-fix
Applying: mm-compaction-introduce-sync-light-migration-for-use-by-compactio=
n-fix-fix
Applying: mm-compaction-introduce-sync-light-migration-for-use-by-compactio=
n-fix-fix-3
Applying: mm: vmscan: when reclaiming for compaction, ensure there are suff=
icient free pages available
Applying: mm: vmscan: check if reclaim should really abort even if compacti=
on_ready() is true for one zone
Applying: mm: isolate pages for immediate reclaim on their own LRU
Applying: mm: isolate pages for immediate reclaim on their own LRU fix
Applying: mm-isolate-pages-for-immediate-reclaim-on-their-own-lru-fix-2
Applying: cpumask: update setup_node_to_cpumask_map() comments
Applying: kexec: remove KMSG_DUMP_KEXEC
Applying: kdump: add missing RAM resource in crash_shrink_memory()
Applying: kdump: add udev events for memory online/offline
Applying: kdump: crashk_res init check for /sys/kernel/kexec_crash_size
Applying: kdump: fix crash_kexec()/smp_send_stop() race in panic()
Applying: ipc/mqueue: simplify reading msgqueue limit
Applying: ipc/sem.c: alternatives to preempt_disable()
Applying: ipc: provide generic compat versions of IPC syscalls
Applying: sysctl: add the kernel.ns_last_pid control
Applying: panic: don't print redundant backtraces on oops
Applying: panic-dont-print-redundant-backtraces-on-oops-fix
Applying: drivers/memstick: use kmemdup rather than duplicating its impleme=
ntation
Applying: fs/direct-io.c: calculate fs_count correctly in get_more_blocks()
Applying: vfs: cache request_queue in struct block_device
Applying: dio: optimize cache misses in the submission path
Applying: radix_tree: remove radix_tree_indirect_to_ptr()
Applying: radix_tree: take radix_tree_path off stack
Applying: radix_tree: expand comment on optimization
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
Applying: notify_change(): check that i_mutex is held
Merging akpm (1f7e0d6 notify_change(): check that i_mutex is held)

--Signature=_Fri__13_Jan_2012_15_58_08_+1100_G6BbhoZLrmBIPmmF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPD7ngAAoJEECxmPOUX5FECNwP/16FY0lBBgNYiaK994ymqjG9
rToqIRdUKbeII4TDP1h9J0wamcpVb/Wse4qFP5MVJyp3fwq/pn0mpuporwLtBEu9
ywMltHOFHe7NDtobuk1ANlVtpxo9/eVbDoQK0XnXGJHyrV1NmrUlJtzxCTN6iAXT
koUfYWexvKfFurP7EngyRVRuN1JmljKYYatq++h8xHMNm4swq4l8WVunM7n+gd5l
1vzYOf9g2t5zlh0bXQRnsKHnxUpfiVnF2EDMRb1wNOjJ6WZGGg4tnTtbzPC8bNfX
QMHjIT5o8fKvlhOeF4yPvMKq13IhaCzKo33K407fA8y1NFyc8wRWS5fNx97ZZocW
m1t9KibzI+4P9sL4oEX/k2ns0lLhwrooAMQW0HE+clLehDuU0DN4OJ3LmXJo30bF
zJpEkJVAb3QUJWrlHXmbSK/NdFTb34aFLa/23/LSZ4mfK4jGhtFoaqduv6k07FsY
/eCnGebrkk7k/la2RtyoKhFOdCjjuLC4EoNP0MMUmUpjgY3BrsTuv9/DQgB3Pzo9
/NPzFMK3V4O91APWT7dFFOCv75e02NKggfDB/20bYEK4g86oKK2DdvnrXblG9i1m
xS6R4wJ5ySx04vJhLM70sOTfPafgD0JyTw4nO0bURSuz1jkbMUAvTimXjrJt8z+l
OwSjkgZ1l9vaBtWFxftt
=j3+7
-----END PGP SIGNATURE-----

--Signature=_Fri__13_Jan_2012_15_58_08_+1100_G6BbhoZLrmBIPmmF--

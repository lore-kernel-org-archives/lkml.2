Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751503Ab2AQC4Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 21:56:24 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:51287 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab2AQC4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 21:56:20 -0500
Date: Tue, 17 Jan 2012 13:56:09 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Jan 17
Message-Id: <20120117135609.51ccdc2f2755f7207d55836c@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__17_Jan_2012_13_56_09_+1100_bCK3VlHwlmzwq1qx"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__17_Jan_2012_13_56_09_+1100_bCK3VlHwlmzwq1qx
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20120116:

Removed tree: uapi (at maintainer request)

The rr tree lost its conflicts.

The akpm tree a couple of patches that turned up in other trees.

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

We are up to 204 trees (counting Linus' and 28 trees of patches pending
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
Merging origin/master (53999bf error: implicit declaration of function 'mod=
ule_flags_taint')
Merging fixes/master (371de6e drm/i915: Disable RC6 on Sandybridge by defau=
lt)
Merging kbuild-current/rc-fixes (fa0ad65 kconfig: adapt update-po-config to=
 new UML layout)
Merging arm-current/fixes (a61c233 ARM: sa11x0: assabet: fix build warning)
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
Merging net/master (7c7c7f0 vhost-net: add module alias (v2.1))
Merging sound-current/for-linus (49b9c40 ALSA: Au88x0 - Reduce the number o=
f playback subdevices of au8830 from 32 to 16)
Merging pci-current/for-linus (8b6a5af PCI: Add Thinkpad SL510 to pci=3Dnoc=
rs blacklist)
Merging wireless/master (d32a102 mac80211: fix tx->skb NULL pointer derefer=
ence)
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
Merging crypto-current/master (51fc6dc crypto: sha512 - reduce stack usage =
to safe number)
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
Merging arm/for-next (33710e3 Merge branches 'fixes' and 'restart' into for=
-next)
Merging arm-soc/for-next (0db991d LOCAL: add back arch/arm/arm-soc-for-next=
-contents.txt)
CONFLICT (content): Merge conflict in drivers/media/video/omap3isp/ispccdc.c
CONFLICT (content): Merge conflict in drivers/media/common/tuners/tda18218.c
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
Merging blackfin/for-linus (0994695 Merge branch 'akpm' (aka "Andrew's patc=
h-bomb, take two"))
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
Merging microblaze/next (7f788ec USB: EHCI: Don't use NO_IRQ in xilinx ehci=
 driver)
Merging mips/mips-for-linux-next (bce2544 Merge branch 'fixes-for-linus' in=
to mips-for-linux-next)
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
Merging unicore32/unicore32 (0994695 Merge branch 'akpm' (aka "Andrew's pat=
ch-bomb, take two"))
Merging xtensa/master (29aced6 xtensa: remove defining register numbers)
Merging ceph/for-next (83eb26a ceph: ensure prealloc_blob is in place when =
removing xattr)
Merging cifs/master (7250170 cifs: integer overflow in parse_dacl())
Merging configfs/linux-next (b930c26 Merge branch 'for-linus' of git://git.=
kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (7e6aad6 eCryptfs: Improve statfs reporting)
Merging ext3/for_next (46fe44c quota: Pass information that quota is stored=
 in system file to userspace)
Merging ext4/dev (d50f2ab ext4: fix undefined behavior in ext4_fill_flex_in=
fo())
Merging fatfs/master (710d440 fat: fat16 support maximum 4GB file/vol size =
as WinXP or 7.)
Merging fuse/for-next (03c9693 cuse: implement memory mapping)
Merging gfs2/master (53999bf error: implicit declaration of function 'modul=
e_flags_taint')
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
Merging ubifs/linux-next (1f4f434 UBI: use own macros for the layout volume)
Merging xfs/master (0994695 Merge branch 'akpm' (aka "Andrew's patch-bomb, =
take two"))
Merging vfs/for-next (f84a8bd btrfs: take allocation of ->tree_root into op=
en_ctree())
Merging vfs-scale/vfs-scale-working (32385c7 kernel: fix hlist_bl again)
Merging pci/linux-next (76ccc29 x86/PCI: Expand the x86_msi_ops to have a r=
estore MSIs.)
Merging hid/for-next (f62f619 Merge branch 'for-linus' of git://git.kernel.=
org/pub/scm/linux/kernel/git/jikos/hid)
Merging quilt/i2c (53999bf error: implicit declaration of function 'module_=
flags_taint')
Merging bjdooks-i2c/next-i2c (fc84fe1 Merge branch 'for_3.3/i2c/misc' of gi=
t://git.kernel.org/pub/scm/linux/kernel/git/khilman/linux-omap-pm into for-=
33/i2c/omap)
Merging quilt/jdelvare-hwmon (90311a5 hwmon: (sysfs-interface) Update tempX=
_type attribute to be more generic)
Merging hwmon-staging/hwmon-next (aca968d hwmon: (pmbus) Replace strict_str=
tol with kstrtol)
Merging quilt/kernel-doc (5851bad The Japanese/Korean/Chinese versions stil=
l need updating.)
Merging docs/docs-move (5c24d8b Merge branch 'docs/docbook/drm' of git://gi=
thub.com/mfwitten/linux into docs-move)
Merging v4l-dvb/master (1264000 [media] revert patch: HDIC HD29L2 DMB-TH US=
B2.0 reference design driver)
Merging kbuild/for-next (b1e0fba Merge branch 'kbuild/kconfig' into kbuild/=
for-next)
Merging kconfig/for-next (eae1c36 Merge branch 'kconfig/for-linus-2' into k=
config/for-next)
Merging libata/NEXT (318893e ahci: support the STA2X11 I/O Hub)
Merging infiniband/for-next (1583676 Merge branches 'cma', 'misc', 'mlx4', =
'nes', 'qib' and 'uverbs' into for-next)
Merging acpi/next (683c4ad Merge branch 'acpica' into next)
Merging cpupowerutils/master (498ca79 cpupower: use man(1) when calling "cp=
upower help subcommand")
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
Merging async_tx/next (21ef4b8 dmaengine: use DEFINE_IDR for static initial=
ization)
Merging net-next/master (356b954 Merge branch 'for-linus' of git://git.kern=
el.org/pub/scm/linux/kernel/git/geert/linux-m68k)
Merging wireless-next/master (a8c1f65 igmp: Avoid zero delay when receiving=
 odd mixture of IGMP queries)
Merging bluetooth/master (c5993de Bluetooth: Correct packet len calculation)
Merging mtd/master (f5eee48 mtd: cfi: AMD/Fujitsu compatibles: add panic wr=
ite support)
Merging l2-mtd/master (f6afb2d mtd: nand: correct comment on nand_chip badb=
lockbits)
CONFLICT (content): Merge conflict in drivers/mtd/nand/gpmi-nand/gpmi-lib.c
Merging crypto/master (b85a088 crypto: sha512 - use standard ror64())
Merging sound/for-next (83a0ac3 Merge branch 'fix/misc' into for-next)
Merging sound-asoc/for-next (fc26e89 Merge branch 'for-3.3' into asoc-next)
Merging cpufreq/next (6c523c6 [CPUFREQ] EXYNOS: Removed useless headers and=
 codes)
Merging quilt/rr (53999bf error: implicit declaration of function 'module_f=
lags_taint')
Merging input/next (dab78d7 Input: tc3589x-keypad - add missing kerneldoc)
Merging input-mt/next (02f8c6a Linux 3.0)
Merging lsm/for-next (ca05a99 capabilities: remain source compatible with 3=
2-bit raw legacy capability support.)
Merging block/for-next (b3021da Merge branch 'for-3.3/core' into for-next)
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
Merging lblnet/master (7e27d6e Linux 2.6.35-rc3)
Merging watchdog/linux-next (c6299d1 watchdog: hpwdt: clean up set_memory_x=
 call for 32 bit)
Merging bdev/master (feaf384 Merge branch 'for-linus' of git://git.kernel.d=
k/linux-2.6-block)
Merging dwmw2-iommu/master (c3b92c8 Linux 3.1)
Merging iommu/next (1a51a0c ARM: OMAP3: fix build on !CONFIG_IOMMU_API)
Merging osd/linux-next (724577c ore: Must support none-PAGE-aligned IO)
Merging jc_docs/docs-next (5c050fb docs: update the development process doc=
ument)
Merging nommu/master (0ce790e Linux 2.6.39-rc1)
Merging trivial/for-next (9879326 Merge branch 'for-linus' of git://git.ker=
nel.org/pub/scm/linux/kernel/git/jikos/trivial)
Merging audit/for-next (def5754 Audit: remove spaces from audit_log_d_path)
Merging pm/linux-next (ee34a37 PM / Hibernate: Drop the check of swap space=
 size for compressed image)
Merging apm/for-next (b4a133d Merge branch 'for-linus' of git://git.kernel.=
org/pub/scm/linux/kernel/git/jikos/apm)
Merging fsnotify/for-next (ef9bf3b fanotify: only destroy a mark if both it=
s mask and its ignored_mask are cleared)
Merging irda/for-next (94d57c4 enic: Update MAINTAINERS)
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
Merging cgroup/for-next (6b3da11 Merge branch 'for-3.3' of git://git.kernel=
.org/pub/scm/linux/kernel/git/tj/percpu)
Merging kmemleak/kmemleak (1502dde kmemleak: only scan non-zero-size sectio=
n)
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
Merging kvmtool/master (0234379 kvm tools: Remove tags/TAGS on "make clean")
CONFLICT (content): Merge conflict in scripts/kconfig/Makefile
CONFLICT (content): Merge conflict in include/net/9p/9p.h
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
Applying: x86, olpc: add debugfs interface for EC commands
Applying: drivers/platform/x86/sony-laptop.c: fix scancodes
Applying: drivers-platform-x86-sony-laptopc-fix-scancodes-checkpatch-fixes
Applying: drivers-platform-x86-sony-laptopc-fix-scancodes-v2
Applying: drivers-platform-x86-sony-laptopc-fix-scancodes-v2-checkpatch-fix=
es
Applying: arch/arm/mach-ux500/mbox-db5500.c: world-writable sysfs fifo file
Applying: arm, exec: remove redundant set_fs(USER_DS)
Applying: hrtimers: Special-case zero length sleeps
Applying: ipc/mqueue: cleanup definition names and locations
Applying: ipc/mqueue: switch back to using non-max values on create
Applying: ipc/mqueue: enforce hard limits
Applying: ipc/mqueue: update maximums for the mqueue subsystem
Applying: ipc-mqueue-update-maximums-for-the-mqueue-subsystem-fix
Applying: ipc-mqueue-update-maximums-for-the-mqueue-subsystem-checkpatch-fi=
xes
Applying: debugobjects: Fix selftest for static warnings
Applying: scsi: fix a header to include linux/types.h
Applying: drivers/scsi/aacraid/commctrl.c: fix mem leak in aac_send_raw_srb=
()
Applying: drivers/scsi/mpt2sas/mpt2sas_base.c: fix mismatch in mpt2sas_base=
_hard_reset_handler() mutex lock-unlock
Applying: MAINTAINERS: Staging: cx25821: Add L: linux-media
Applying: mm: fix page-faults detection in swap-token logic
Applying: mm: add extra free kbytes tunable
Applying: mm-add-extra-free-kbytes-tunable-update
Applying: mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes
Applying: hpet: factor timer allocate from open
Applying: intel_idle: fix API misuse
Applying: intel_idle: disable auto_demotion for hotplugged CPUs
Applying: ceph, cifs, nfs, fuse: boolean and / or confusion
Applying: init/do_mounts.c: create /root if it does not exist
Applying: cpusets, cgroups: disallow attaching kthreadd
Applying: mm: isolate pages for immediate reclaim on their own LRU
Applying: mm: isolate pages for immediate reclaim on their own LRU fix
Applying: mm-isolate-pages-for-immediate-reclaim-on-their-own-lru-fix-2
Applying: ipc/mqueue: simplify reading msgqueue limit
Applying: ipc/sem.c: alternatives to preempt_disable()
Applying: ipc: provide generic compat versions of IPC syscalls
Applying: drivers/memstick: use kmemdup rather than duplicating its impleme=
ntation
Applying: notify_change(): check that i_mutex is held
Merging akpm (11effcd notify_change(): check that i_mutex is held)

--Signature=_Tue__17_Jan_2012_13_56_09_+1100_bCK3VlHwlmzwq1qx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPFONJAAoJEECxmPOUX5FEUTgQAKhgz2c3d5o15l1S+/GGem23
9OKNsPFxqvujWuPh+KIlN1CQBXTbD5pENKVBp6fJ88YxxusB+Cul8BJ2akOQ0EpE
tVnAssa96sKqzVsenYj6Exi18D4p2HGsQ5o186m4ZVR4g2Q0szNjItoINVpXUT/d
Iec65AcAaWkqp2SBUBMG9nPRgLZ0l5z3879VgdTisJZgAVhXejSMWF4+NBkgy6fa
SeIpVwlHL65QbAb7PyW+0dXhhmX4+t172wFR8r9UzXaxykcpeokavBlgiuPpqp5Y
h7i7d9a60Vw7iAvgfL3KvrELye66dhuQ630r+bYyNh/bL4rZOyqus1uBUqqAZywx
+N1L5dj7FKya0aK6CPx0WalbI4zZ6E61B9gheOy5Ff4ahrKv/VTjm20Vz3L2qug6
OK41fueeY2x255Dioc4LXtrP8Xk2R5Hr48YRrWf/ktFOS4bo4+L2XtP320KxMen9
3KkEFAhcA6lVrbyUMod3mw3MMTrMBh3QJmwGOBhmka0IKf8gsH6z3KKbR+gUkQ1L
3oDUVHYQYTofbuwY78nLp4zrpWcDrk3MEgriKMWYT2ej8Nt/oLpST+/NYUjzfYOO
0P+zUUUHL3NzvBwulNzBhJrwNCw52uEk6iYgtm2zGVBOZf8acdUd1h7hdecuGdPs
WAP06tTs7+xuZcY58sNZ
=t+hR
-----END PGP SIGNATURE-----

--Signature=_Tue__17_Jan_2012_13_56_09_+1100_bCK3VlHwlmzwq1qx--

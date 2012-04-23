Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951Ab2DWHHP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 03:07:15 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:46521 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945Ab2DWHHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 03:07:11 -0400
Date: Mon, 23 Apr 2012 17:07:01 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Apr 23
Message-Id: <20120423170701.c96e402234b1387dece11dda@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__23_Apr_2012_17_07_01_+1000_xfKI8eRAbjAGz.M_"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__23_Apr_2012_17_07_01_+1000_xfKI8eRAbjAGz.M_
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20120420:

The md tree lost its build failure.

The net-next tree gained a build failure from a mismerge which I fixed.

The drm tree gained a build failure so I used the version from 20120420.

The kvm tree lost its build failure.

The driver-core tree still lost its build failure.

The usb tree lost its conflict.

The staging tree gained a conflict against the usb tree.

The modem-smh tree gained a conflict against the driver-core tree.

The dma-mapping tree gained a conflict against the tip tree.

The akpm tree gained a conflict against the dma-mapping tree.

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

We are up to 189 trees (counting Linus' and 27 trees of patches pending
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
Merging origin/master (66f75a5 Linux 3.4-rc4)
Merging fixes/master (b1a808f Merge branch 'for-next' of git://gitorious.or=
g/kernel-hsi/kernel-hsi)
Merging kbuild-current/rc-fixes (e88aa7b Fix modpost failures in fedora 17)
Merging arm-current/fixes (3cd88f9 Revert "ARM: 7359/2: smp_twd: Only wait =
for reprogramming on active cpus")
Merging m68k-current/for-linus (450aed7 m68k/q40: Add missing platform chec=
k before registering platform devices)
Merging powerpc-merge/merge (fae2e0f powerpc: Fix typo in runlatch code)
Merging sparc/master (e9a5ea1 sparc32,leon: add notify_cpu_starting())
Merging scsi-rc-fixes/master (41f8ad7 [SCSI] osd_uld: Bump MAX_OSD_DEVICES =
from 64 to 1,048,576)
Merging net/master (d135c52 tcp: fix TCP_MAXSEG for established IPv6 passiv=
e sockets)
Merging sound-current/for-linus (c817eeb Merge branch 'fix/cxt-stable' into=
 fix/hda)
Merging pci-current/for-linus (314489b Merge tag 'fixes-for-linus' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc)
Merging wireless/master (fd09c85 ath9k: Fix TX fragmentation)
Merging driver-core.current/driver-core-linus (e816b57 Linux 3.4-rc3)
Merging tty.current/tty-linus (d3a7b83 drivers/tty/amiserial.c: add missing=
 tty_unlock)
Merging usb.current/usb-linus (66f75a5 Linux 3.4-rc4)
Merging staging.current/staging-linus (e816b57 Linux 3.4-rc3)
Merging char-misc.current/char-misc-linus (e816b57 Linux 3.4-rc3)
Merging cpufreq-current/fixes (6139b65 Merge branch 'for_3.4/cpufreq' of gi=
t://git.kernel.org/pub/scm/linux/kernel/git/khilman/linux-omap-pm into fixe=
s)
Merging input-current/for-linus (899c612 Input: synaptics - fix regression =
with "image sensor" trackpads)
Merging md-current/for-linus (afbaa90 md/bitmap: prevent bitmap_daemon_work=
 running while initialising bitmap)
Merging audit-current/for-linus (c158a35 audit: no leading space in audit_l=
og_d_path prefix)
Merging crypto-current/master (511d63c crypto: talitos - properly lock acce=
ss to global talitos registers)
Merging ide/master (0ab3d8b cy82c693: fix PCI device selection)
Merging dwmw2/master (244dc4e Merge git://git.infradead.org/users/dwmw2/ran=
dom-2.6)
Merging sh-current/sh-fixes-for-linus (691c01c arch/sh/drivers/dma/{dma-g2,=
dmabrg}.c: ensure arguments to request_irq and free_irq are compatible)
Merging irqdomain-current/irqdomain/merge (15e06bf irqdomain: Fix debugfs f=
ormatting)
Merging devicetree-current/devicetree/merge (766644d of/irq: add empty irq_=
of_parse_and_map() for non-dt builds)
Merging spi-current/spi/merge (39ec0d3 spi/imx: prevent NULL pointer derefe=
rence in spi_imx_probe())
Merging gpio-current/gpio/merge (9a5c7d6 gpio/exynos: Fix compiler warning =
in gpio-samsung.c file)
Merging arm/for-next (dc22814 Merge branches 'amba', 'clkdev', 'fixes' and =
'misc' into for-next)
Merging arm-perf/for-next/perf (c16fa4f Linux 3.3)
Merging davinci/davinci-next (fe0d422 Linux 3.0-rc6)
Merging samsung/next-samsung (9edb240 ARM: H1940/RX1950: Change default LED=
 triggers)
Merging s5p/for-next (d0ee53a Merge branch 'next/board-samsung' into for-ne=
xt)
Merging xilinx/arm-next (b85a3ef ARM: Xilinx: Adding Xilinx board support)
Merging blackfin/for-linus (35fe2e7 blackfin: update defconfig for bf527-ez=
kit)
Merging c6x/for-linux-next (c16fa4f Linux 3.3)
Merging cris/for-next (7b91747 cris: Remove old legacy "-traditional" flag =
from arch-v10/lib/Makefile)
Merging hexagon/linux-next (4323328 hexagon: add missing cpu.h include)
Merging ia64/next (16f2634 [IA64] Normalize return value of chip->irq_set_a=
ffinity() method)
Merging m68k/for-next (dd70ca0 m68k/video: Create <asm/vga.h>)
Merging m68knommu/for-next (b97c0bb m68knommu: make sure 2nd FEC eth interf=
ace pins are enabled on 5275 ColdFire)
Merging microblaze/next (258f742 modpost: Fix modpost license checking of v=
mlinux.o)
Merging mips/mips-for-linux-next (2fea377 Merge branch 'fixes-for-linus' in=
to mips-for-linux-next)
Merging openrisc/for-upstream (c88e692 asm-generic: add linux/types.h to cm=
pxchg.h)
Merging parisc/for-next (c60dc74 Merge branch 'fixes' into for-next)
Merging powerpc/next (0195c00 Merge tag 'split-asm_system_h-for-linus-20120=
328' of git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-asm_sy=
stem)
Merging 4xx/next (b5594a7 powerpc/44x: Add additional device support for AP=
M821xx SoC and Bluestone board)
Merging mpc5xxx/next (09f61ff powerpc: Option FB_FSL_DIU is not really opti=
onal for mpc512x)
Merging galak/next (fa1b42b powerpc/qe: Update the SNUM table for MPC8569 R=
ev2.0)
Merging s390/features (1571bae [S390] crash dump: add missing SMP dependenc=
y)
Merging sh/sh-latest (b2212ea sh64: Kill off unused trap_no/error_code from=
 thread_struct.)
Merging sparc-next/master (df2e7f5 sparc32: fix build of pcic)
CONFLICT (content): Merge conflict in arch/sparc/kernel/leon_smp.c
Merging tile/master (a46bf6d arch/tile: tilegx PCI root complex support)
Merging unicore32/unicore32 (0994695 Merge branch 'akpm' (aka "Andrew's pat=
ch-bomb, take two"))
Merging ceph/master (cd9d9f5 rbd: don't hold spinlock during messenger flus=
h)
Merging cifs/master (3af9d8f cifs: fix offset handling in cifs_iovec_write)
Merging configfs/linux-next (b930c26 Merge branch 'for-linus' of git://git.=
kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (6cfd4b4 ecryptfs: remove the second argument of k[un=
]map_atomic())
CONFLICT (content): Merge conflict in fs/ecryptfs/ecryptfs_kernel.h
Merging ext3/for_next (77f0a97 jbd: Write journal superblock with WRITE_FUA=
 after checkpointing)
Merging ext4/dev (57f73c2 ext4: fix handling of journalled quota options)
Merging fuse/for-next (c628ee6 fuse: use flexible array in fuse.h)
Merging gfs2/master (3c1d908 GFS2: Log code fixes)
Merging logfs/master (cd8bfa9 logfs: initialize the number of iovecs in bio)
Merging nfs/linux-next (7bf97bc NFSv4: Keep dropped state owners on the LRU=
 list for a while)
Merging nfsd/nfsd-next (f69adb2 nfsd: allocate id-to-name and name-to-id ca=
ches in per-net operations.)
Merging ocfs2/linux-next (9392557 ocfs2: avoid unaligned access to dqc_bitm=
ap)
Merging omfs/for-next (976d167 Linux 3.1-rc9)
Merging squashfs/master (4b0180a Squashfs: add mount time sanity check for =
block_size and block_log match)
Merging v9fs/for-next (01627d9 Merge branch 'drm-fixes-intel' of git://peop=
le.freedesktop.org/~airlied/linux)
Merging ubifs/linux-next (297fe33 UBIFS: remove douple initialization in ch=
ange_category())
Merging xfs/for-next (bc236c3 xfs: use shared ilock mode for direct IO writ=
es by default)
Merging vfs/for-next (9448152 sch_atm.c: get rid of poinless extern)
Merging pci/next (314489b Merge tag 'fixes-for-linus' of git://git.kernel.o=
rg/pub/scm/linux/kernel/git/arm/arm-soc)
Merging hid/for-next (f0f5396 Merge branch 'multitouch' into for-next)
Merging quilt/i2c (85bb1a8 i2c-dev: Add support for I2C_M_RECV_LEN)
Merging bjdooks-i2c/next-i2c (fc84fe1 Merge branch 'for_3.3/i2c/misc' of gi=
t://git.kernel.org/pub/scm/linux/kernel/git/khilman/linux-omap-pm into for-=
33/i2c/omap)
CONFLICT (content): Merge conflict in drivers/i2c/busses/i2c-omap.c
Merging i2c-embedded/i2c-embedded/for-next (58727eb i2c: designware: Add cl=
k_{un}prepare() support)
Merging quilt/jdelvare-hwmon (e3a9568 hwmon: Add MCP3021 ADC driver)
Merging hwmon-staging/hwmon-next (032c4871 acpi_power_meter: clean up code =
around setup_attrs)
Merging v4l-dvb/master (2a43f0b Merge /home/v4l/v4l/patchwork)
CONFLICT (content): Merge conflict in drivers/usb/gadget/uvc_queue.c
Merging kbuild/for-next (63ce2ed Merge branch 'kbuild/rc-fixes' into kbuild=
/for-next)
Merging kconfig/for-next (eae1c36 Merge branch 'kconfig/for-linus-2' into k=
config/for-next)
Merging libata/NEXT (85d6725 libata: make ata_print_id atomic)
Merging infiniband/for-next (c72adfd be2net: Add functionality to support R=
oCE driver)
Merging acpi/next (eeaab2d Merge branches 'idle-fix' and 'misc' into releas=
e)
Merging cpupowerutils/master (f166033 cpupower tools: add install target to=
 the debug tools' makefiles)
Merging ieee1394/for-next (8527f8e firewire: core: fw_device_refresh(): cle=
an up error handling)
Merging ubi/linux-next (0034102 Linux 3.4-rc2)
Merging dlm/next (1b189b8 dlm: last element of dlm_local_addr[] never used)
Merging scsi/master (6993169 [SCSI] ipr: Driver version 2.5.3)
Merging target-updates/for-next (bfb79ea target/iscsi: Go back to core allo=
cating data buffer for cmd)
Merging target-merge/for-next-merge (3e6e9e9 sbp-target: Initial merge of f=
irewire/ieee-1394 target mode support)
Merging ibft/linux-next (935a9fe ibft: Fix finding IBFT ACPI table on UEFI)
Merging isci/all (475448a merge: libsas devel rnc-devel fixes)
CONFLICT (content): Merge conflict in drivers/ata/libata-scsi.c
Merging slave-dma/next (91ae1e3 dmaengine: mxs-dma: assign cookie in prepar=
e)
Merging dmaengine/next (a2bd114 netdma: adding alignment check for NETDMA o=
ps)
Merging net-next/master (cd754a5 gianfar: add GRO support)
Applying: net ax25: fix up sysctl change mismerge
Merging wireless-next/master (b5abcf0 mwifiex: corrections in timestamp rel=
ated code)
Merging bluetooth/master (3a1fc4c Bluetooth: Remove unneeded initialization=
 in hci_alloc_dev())
Merging mtd/master (7b0e67f mtd: docg3 add protection against concurrency)
Merging l2-mtd/master (15ce11e mtd: omap2: fix resource leak in prefetch-bu=
sy path)
Merging crypto/master (d788fec crypto, xor: Sanitize checksumming function =
selection output)
Merging sound/for-next (0b791a3 Merge branch 'topic/misc' into for-next)
Merging sound-asoc/for-next (1dd97b4 Merge branch 'for-3.5' into asoc-next)
Merging cpufreq/next (a7b422c provide disable_cpufreq() function to disable=
 the API.)
Merging quilt/rr (2a22b63 cpumask: remove old cpu_*_map.)
CONFLICT (content): Merge conflict in init/main.c
CONFLICT (content): Merge conflict in drivers/virtio/virtio_balloon.c
CONFLICT (content): Merge conflict in arch/arm/kernel/kprobes.c
Merging input/next (5d06647 Input: use module_pci_driver)
Merging input-mt/for-next (0034102 Linux 3.4-rc2)
Merging cgroup/for-next (86f82d5 cgroup: remove cgroup_subsys->populate())
CONFLICT (content): Merge conflict in Documentation/feature-removal-schedul=
e.txt
Merging block/for-next (48eee61 Merge branch 'for-3.5/core' into for-next)
CONFLICT (content): Merge conflict in Documentation/feature-removal-schedul=
e.txt
Merging quilt/device-mapper (025716f Fix a memory leak inadvertently introd=
uced during simplification of cell_release_singleton() in commit 6f94a4c45a=
6f744383f9f695dde019998db3df55 ("dm thin: fix stacked bi_next usage").)
Merging embedded/master (4744b43 embedded: fix vc_translate operator preced=
ence)
Merging firmware/master (6e03a20 firmware: speed up request_firmware(), v3)
Merging pcmcia/master (80af9e6 pcmcia at91_cf: fix raw gpio number usage)
Merging mmc/mmc-next (48b332f mmc: omap_hsmmc: release correct resource)
Merging kgdb/kgdb-next (3751d3e x86,kgdb: Fix DEBUG_RODATA limitation using=
 text_poke())
Merging slab/for-next (b80b6c0 Merge branch 'slab/next' into for-next)
Merging uclinux/for-next (5e442a4 Revert "proc: fix races against execve() =
of /proc/PID/fd**")
Merging md/for-next (9010dd6 MD RAID1: Further conditionalize 'fullsync')
Merging mfd/for-next (c00ba41 mfd: No need to check for the GPIO offset fro=
m asic3_gpio_to_irq)
CONFLICT (content): Merge conflict in drivers/mfd/asic3.c
Merging battery/master (5cdd4d7 max17042_battery: Clean up interrupt handli=
ng)
Merging drm/drm-next (160794c vga-switcheroo: select VGA arbitration.)
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/intel_i2c.c
$ git reset --hard HEAD^
Merging refs/next/20120420/drm
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/intel_i2c.c
[master 24172c5] Merge commit 'refs/next/20120420/drm'
Merging fbdev/fbdev-next (d313a86 i.MX28: Shut down the LCD controller to a=
void BootROM sampling bug)
Merging viafb/viafb-next (838ac78 viafb: avoid refresh and mode lookup in s=
et_par)
Merging omap_dss2/for-next (df01d53 OMAPDSS: APPLY: fix clearing shadow dir=
ty flag with manual update)
Merging regulator/for-next (76b7860 Merge branch 'regulator-drivers' into r=
egulator-next)
Merging security/next (561381a samples/seccomp: fix dependencies on arch ma=
cros)
CONFLICT (content): Merge conflict in include/linux/filter.h
Merging selinux/master (c737f82 SELinux: remove unused common_audit_data in=
 flush_unauthorized_files)
Merging lblnet/master (7e27d6e Linux 2.6.35-rc3)
Merging watchdog/master (8fb551c hpwdt: Only BYTE reads/writes to WD Timer =
port 0x72)
Merging dwmw2-iommu/master (c3b92c8 Linux 3.1)
Merging iommu/next (7aff2d0 Merge branches 'iommu/fixes', 'dma-debug', 'arm=
/omap' and 'arm/tegra' into next)
Merging osd/linux-next (72749a2 exofs: Cap on the memcpy() size)
Merging jc_docs/docs-next (5c050fb docs: update the development process doc=
ument)
Merging trivial/for-next (59bf896 Fix "the the" in various Kconfig)
CONFLICT (modify/delete): sound/soc/imx/Kconfig deleted in HEAD and modifie=
d in trivial/for-next. Version trivial/for-next of sound/soc/imx/Kconfig le=
ft in tree.
$ git rm -f sound/soc/imx/Kconfig
Merging audit/for-next (dcd6c92 Linux 3.3-rc1)
Merging pm/linux-next (e9cbc5a PM / Hibernate: fix the number of pages used=
 for hibernate/thaw buffering)
Merging apm/for-next (f283d22 APM: fix deadlock in APM_IOC_SUSPEND ioctl)
Merging fsnotify/for-next (1aec9c0 inotify: automatically restart syscalls)
Merging edac/linux_next (a4b4be3 edac: rename channel_info to rank_info)
Merging edac-amd/for-next (305f1c3 Merge branch '3.3-pci_device_id' into ed=
ac-for-next)
Merging devicetree/devicetree/next (0f22dd3 of: Only compile OF_DYNAMIC on =
PowerPC pseries and iseries)
Merging spi/spi/next (d57a428 spi/devicetree: Move devicetree support code =
into spi directory)
Merging tip/auto-latest (2adb096 Merge branch 'linus')
Merging rcu/rcu/next (dacd1da Merge branches 'fnh.2012.04.19a', 'fixes.2012=
.04.19a' and 'inline.2012.04.18a' of ../linux-2.6-tip into HEAD)
Merging cputime/cputime (c3e0ef9 [S390] fix cputime overflow in uptime_proc=
_show)
Merging uprobes/for-next (0326f5a uprobes/core: Handle breakpoint and singl=
estep exceptions)
Merging kmemleak/kmemleak (4878677 kmemleak: do not leak object after tree =
insertion error)
Merging kvm/linux-next (1f15d10 KVM: add kvm_arch_para_features stub to asm=
-generic/kvm_para.h)
CONFLICT (content): Merge conflict in Documentation/feature-removal-schedul=
e.txt
Merging kvm-ppc/kvm-ppc-next (428d50e KVM: PPC: Use clockevent multiplier a=
nd shifter for decrementer)
Merging oprofile/for-next (c16fa4f Linux 3.3)
Merging xen/upstream/xen (59e9a6b Merge branch 'upstream/ticketlock-cleanup=
' into upstream/xen)
CONFLICT (content): Merge conflict in arch/x86/include/asm/cmpxchg.h
Merging xen-two/linux-next (e300b82 Merge branch 'stable/for-linus-3.4' int=
o linux-next)
Merging xen-pvhvm/linux-next (b056b6a xen: suspend: remove xen_hvm_suspend)
Merging percpu/for-next (adb7950 percpu: fix __this_cpu_{sub,inc,dec}_retur=
n() definition)
Merging workqueues/for-next (f5b2552 workqueue: change BUG_ON() to WARN_ON(=
))
Merging drivers-x86/linux-next (e64c9de dell-laptop: Terminate quirks list =
properly)
Merging hwpoison/hwpoison (46e387b Merge branch 'hwpoison-hugepages' into h=
wpoison)
Merging sysctl/master (4e474a0 sysctl: protect poll() in entries that may g=
o away)
Merging regmap/for-next (b076764 Merge branch 'regmap-stride' into regmap-n=
ext)
Merging hsi/for-next (43139a6 HSI: hsi_char: Update ioctl-number.txt)
Merging driver-core/driver-core-next (3e971db Documentation/extcon: porting=
 guide for Android kernel switch driver.)
Merging tty/tty-next (5f1a389 serial/8250_pci: fix suspend/resume vs init/e=
xit quirks)
CONFLICT (content): Merge conflict in drivers/tty/serial/pch_uart.c
Merging usb/usb-next (09091a4 Merge 3.4-rc4 into usb-next.)
Merging staging/staging-next (542038f staging: comedi: use ARRAY_SIZE inste=
ad of custom n_boardtypes macros)
CONFLICT (content): Merge conflict in drivers/staging/comedi/drivers/dt9812=
.c
Merging char-misc/char-misc-next (9912143 parport: remove unused dead code =
from lowlevel drivers)
Merging tmem/linux-next (0f1ea93 Merge branch 'stable/frontswap.v14' into l=
inux-next)
Merging writeback/writeback-for-next (697e6fe writeback: Remove outdated co=
mment)
Merging arm-dt/devicetree/arm-next (ede338f dt: add documentation of ARM dt=
 boot interface)
Merging hwspinlock/linux-next (8b37fcf hwspinlock: add MAINTAINERS entries)
Merging pinctrl/for-next (dcb5dbc pinctrl: show pin name for pingroups in s=
ysfs)
CONFLICT (content): Merge conflict in drivers/pinctrl/core.c
CONFLICT (content): Merge conflict in Documentation/driver-model/devres.txt
Merging tegra/for-next (cdc6419 Merge branch 'for-3.5/defconfig' into for-n=
ext)
Merging moduleh/for-sfr (30d8846 blackfin: fix ifdef fustercluck in mach-bf=
538/boards/ezkit.c)
Merging vhost/linux-next (33b3aa0 x86: eoi micro-optimization)
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
Merging arm-soc/for-next (3798df5 update contents file)
CONFLICT (content): Merge conflict in arch/arm/mach-lpc32xx/common.c
Merging kvmtool/master (0333eec kvm tools: Update README for CONFIG_FB_VESA)
Merging dma-mapping/dma-mapping-next (c6b1f07 ARM: integrate CMA with DMA-m=
apping subsystem)
CONFLICT (content): Merge conflict in arch/x86/include/asm/dma-mapping.h
Merging dma-buf/for-next (9f28056 dma-buf: Correct dummy function declarati=
ons.)
CONFLICT (content): Merge conflict in include/linux/dma-buf.h
CONFLICT (content): Merge conflict in drivers/base/dma-buf.c
Merging ktest/for-next (648a182 ktest: Allow a test to override REBOOT_ON_S=
UCCESS)
Merging cpuidle-cons/cpuidle_consol_pull (203b52e SH: shmobile: Consolidate=
 time keeping and irq enable)
CONFLICT (content): Merge conflict in include/linux/cpuidle.h
CONFLICT (content): Merge conflict in drivers/cpuidle/cpuidle.c
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/cpuidle.c
CONFLICT (content): Merge conflict in arch/arm/mach-davinci/cpuidle.c
CONFLICT (content): Merge conflict in arch/arm/mach-at91/cpuidle.c
CONFLICT (add/add): Merge conflict in arch/arm/include/asm/cpuidle.h
Merging scsi-post-merge/merge-base:master ()
$ git checkout akpm
Applying: acerhdf: add support for Aspire 1410 BIOS v1.3314
Applying: acerhdf: add support for new hardware
Applying: acerhdf: lowered default temp fanon/fanoff values
Applying: umem: fix up unplugging
Applying: arch/x86/platform/iris/iris.c: register a platform device and a p=
latform driver
Applying: intel_mid_powerbtn: mark irq as IRQF_NO_SUSPEND
Applying: arch/x86/include/asm/spinlock.h: fix comment
Applying: arch/x86/kernel/apic/io_apic.c: move io_apic_level_ack_pending() =
inside CONFIG_GENERIC_PENDING_IRQ
Applying: drivers/xen/Kconfig: fix Kconfig layout
Applying: arch/arm/mach-ux500/mbox-db5500.c: world-writable sysfs fifo file
Applying: avr32: don't mask signals in the error path
Applying: avr32: use set_current_blocked() in handle_signal/sys_rt_sigreturn
Applying: avr32: use block_sigmask()
Applying: m32r: use set_current_blocked() and block_sigmask()
Applying: m68k: use set_current_blocked() and block_sigmask()
Applying: mn10300: use set_current_blocked() and block_sigmask()
Applying: cpuidle: remove unused hrtimer_peek_ahead_timers() call
Applying: cris: use set_current_blocked() and block_sigmask()
Applying: cris: select GENERIC_ATOMIC64
Applying: x86: use this_cpu_xxx to replace percpu_xxx funcs
Applying: x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs-fix
Applying: x86: change percpu_read_stable() to this_cpu_read_stable()
Applying: net: use this_cpu_xxx replace percpu_xxx funcs
Applying: percpu: remove percpu_xxx() functions
Applying: percpu-remove-percpu_xxx-functions-fix
Applying: timeconst.pl: remove deprecated defined(@array)
Applying: ia64: use set_current_blocked() and block_sigmask()
Applying: microblaze: don't reimplement force_sigsegv()
Applying: microblaze: no need to reset handler if SA_ONESHOT
Applying: microblaze: fix signal masking
Applying: microblaze: use set_current_blocked() and block_sigmask()
Applying: MIPS: use set_current_blocked() and block_sigmask()
Applying: score: don't mask signals if we fail to setup signal stack
Applying: score: use set_current_blocked() and block_sigmask()
Applying: h8300: use set_current_blocked() and block_sigmask()
Applying: unicore32: use block_sigmask()
Applying: blackfin: use set_current_blocked() and block_sigmask()
Applying: ocfs2: use find_last_bit()
Applying: ocfs2: use bitmap_weight()
Applying: drivers/scsi/ufs: use module_pci_driver
Applying: vfs: increment iversion when a file is truncated
Applying: fs: symlink restrictions on sticky directories
Applying: fs: hardlink creation restrictions
Applying: fsnotify: remove unused parameter from send_to_group()
Applying: fsnotify: handle subfiles' perm events
Applying: brlocks/lglocks: cleanups
Applying: mm/memory_failure: let the compiler add the function name
Applying: mm/mempolicy.c: use enum value MPOL_REBIND_ONCE in mpol_rebind_po=
licy()
Applying: mm/hugetlb.c: use long vars instead of int in region_count()
Applying: mm, thp: remove unnecessary ret variable
Applying: mm, thp: allow fallback when pte_alloc_one() fails for huge pmd
Applying: mm: vmscan: remove lumpy reclaim
Applying: mm: vmscan: remove reclaim_mode_t
Applying: mm: remove swap token code
Applying: mm: add extra free kbytes tunable
CONFLICT (content): Merge conflict in mm/page_alloc.c
Applying: mm-add-extra-free-kbytes-tunable-update
Applying: mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes
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
Applying: parisc: use set_current_blocked() and block_sigmask()
Applying: vsprintf: further optimize decimal conversion
Applying: vsprintf-further-optimize-decimal-conversion-v2
Applying: vsprintf-further-optimize-decimal-conversion-checkpatch-fixes
Applying: hamradio/scc: orphan driver in MAINTAINERS
Applying: MAINTAINERS: remove Alessandro
Applying: blacklight: remove redundant spi driver bus initialization
Applying: drivers/leds/leds-lp5521.c: fix lp5521_read() error handling
Applying: leds: driver for DA9052/53 PMIC v2
Applying: leds-led-module-for-da9052-53-pmic-v2-fix
Applying: leds: add LED driver for lm3556 chip
Applying: leds-add-led-driver-for-lm3556-chip-checkpatch-fixes
Applying: leds: simple_strtoul() cleanup
Applying: list_debug: WARN for adding something already in the list
Applying: lib/test-kstrtox.c: mark const init data with __initconst instead=
 of __initdata
Applying: checkpatch: suggest pr_<level> over printk(KERN_<LEVEL>
Applying: rtc/spear: add Device Tree probing capability
Applying: drivers/rtc/rtc-ep93xx.c: convert to use module_platform_driver()
Applying: rtc: add ioctl to get/clear battery low voltage status
Applying: drivers/rtc/rtc-pcf8563.c: add RTC_VL_READ/RTC_VL_CLR ioctl featu=
re
Applying: drivers/rtc/Kconfig: place RTC_DRV_IMXDI and RTC_MXC under "on-CP=
U RTC drivers"
Applying: rtc: rename CONFIG_RTC_MXC to CONFIG_RTC_DRV_MXC
Applying: rtc-rename-config_rtc_mxc-to-config_rtc_drv_mxc-fix
Applying: HPFS: remove PRINTK() macro
Applying: kmod: unexport call_usermodehelper_freeinfo()
Applying: kmod: convert two call sites to call_usermodehelper_fns()
Applying: kmod: move call_usermodehelper_fns() to .c file and unexport all =
it's helpers
Applying: kmod: avoid deadlock from recursive kmod call
Applying: proc: clean up /proc/<pid>/environ handling
Applying: proc-clean-up-proc-pid-environ-handling-checkpatch-fixes
Applying: proc: unify ptrace_may_access() locking code
Applying: proc: remove mm_for_maps()
Applying: proc: use mm_access() instead of ptrace_may_access()
Applying: proc: use IS_ERR_OR_NULL()
Applying: ipc/sem.c: alternatives to preempt_disable()
Applying: rapidio: add DMA engine support for RIO data transfers
Applying: rapidio/tsi721: add DMA engine support
Applying: sysctl: make kernel.ns_last_pid control dependent on CHECKPOINT_R=
ESTORE
Applying: fs, proc: introduce /proc/<pid>/task/<tid>/children entry
Applying: syscalls, x86: add __NR_kcmp syscall
Applying: syscalls-x86-add-__nr_kcmp-syscall-v8 comment update
Applying: syscalls-x86-add-__nr_kcmp-syscall-v8-comment-update-fix
Applying: c/r: procfs: add arg_start/end, env_start/end and exit_code membe=
rs to /proc/$pid/stat
Applying: c/r: prctl: extend PR_SET_MM to set up more mm_struct entries
Applying: c/r: prctl: add ability to set new mm_struct::exe_file
Applying: c/r: prctl: add ability to get clear_tid_address
Applying: c/r: ipc: message queue receive cleanup
Applying: c/r: ipc: message queue stealing feature introduced
Applying: ramoops: use pstore interface
Applying: ramoops: fix printk format warnings
Applying: notify_change(): check that i_mutex is held
Merging akpm (22e7092 notify_change(): check that i_mutex is held)

--Signature=_Mon__23_Apr_2012_17_07_01_+1000_xfKI8eRAbjAGz.M_
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPlP+VAAoJEECxmPOUX5FECysP/3FIq5fL8VbXAXaRw5mNaR4/
y82begMEOPqFDw+D70satMsBxcqVBB0RKKIllDVg//cujVV9D1BMnLybe4p8ahHo
G4Xx9/kmOubwQZbXQGGQVu0dNZSlQrAz4W2ePi2pfzagl5EH++asJqwewqmOl7Ye
fZmqPw+qIV/0hWZ+0C+lwFOzS5FaaiAqWW1Jugha2NLX3ZszpVPpPjk1GG5xY/uJ
PCrIIqmnioAW/58oJyz+728Vd5bnu6UYwGuw9En/DM3tKh8pA3H0fUNYXDPGDVdW
UqNFclkDhcVEXsaxBPgfE2lz/eBQEcNb1BUscaoTRZ+Z5QBBcTmmVJ6AYnZpgz0t
IlDN0uS9PEZoEi4AQYrcjs1wZBwDJL4IHVv1goKnPQedZnb2FzxJJRzWysVa8tFB
K78iRaiU0zzBSrpqcSKheotcOo4WJBoYwOESBDXWvllOgDvlRZPkSTlbMDIolu+L
7upuGpiWH2l3bjPqtIY48b0ldIaoQYAOUME83QPCEj8h/XdD00O/m1/a/352eIsX
/dzTnHSwjxNBXaFA7sSfeC9Mj8hx/i+s6SxxievJ+o1pI2JSAExU3I4zB0ha/m/N
Ng0PPPIV6kH85iz0ToDhsZuPj2FAYETvk1nCSjCXGFIOHKIbMlJ/PzAOSQihiEcg
fHbMKULy7gfJKEOD3yp2
=0jFN
-----END PGP SIGNATURE-----

--Signature=_Mon__23_Apr_2012_17_07_01_+1000_xfKI8eRAbjAGz.M_--

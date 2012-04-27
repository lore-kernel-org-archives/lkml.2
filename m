Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755091Ab2D0GMB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 02:12:01 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:48081 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112Ab2D0GLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 02:11:55 -0400
Date: Fri, 27 Apr 2012 16:11:46 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: inux-next: Tree for Apr 27
Message-Id: <20120427161146.95422142968526faaff615d4@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__27_Apr_2012_16_11_46_+1000_uATYjSpFRgXDW6Sp"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__27_Apr_2012_16_11_46_+1000_uATYjSpFRgXDW6Sp
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20120424:

The net-next tree lost its merge fixup, but gained a conflict against the
net tree.

The wireless-next tree lost its conflict.

The drm tree lost its build failure.

The kvm-ppc tree gained a build failure for which I added a patch.

The tip tree gained a conflict against the security tree.

The xen tree lost its conflict.

The usb tree gained a build failure, so I used the version form
next-20120424.

The staging tree gained conflicts against Linus' and the driver-core
trees.

The dma-buf tree lost its conflicts.

The akpm tree gained a build failure for which I added a patch.

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

We are up to 187 trees (counting Linus' and 26 trees of patches pending
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
Merging origin/master (82b7690 Merge branch 'stable' of git://git.kernel.or=
g/pub/scm/linux/kernel/git/cmetcalf/linux-tile)
Merging fixes/master (b1a808f Merge branch 'for-next' of git://gitorious.or=
g/kernel-hsi/kernel-hsi)
Merging kbuild-current/rc-fixes (e88aa7b Fix modpost failures in fedora 17)
Merging arm-current/fixes (3545358 ARM: OMAP: fix DMA vs memory ordering)
Merging m68k-current/for-linus (450aed7 m68k/q40: Add missing platform chec=
k before registering platform devices)
Merging powerpc-merge/merge (446f6d0 powerpc/mpic: Properly set default tri=
ggers)
Merging sparc/master (e9a5ea1 sparc32,leon: add notify_cpu_starting())
Merging net/master (8b6efb7 MAINTAINERS: update sctp maintainer address)
Merging sound-current/for-linus (cff7873 Merge tag 'asoc-3.4' of git://git.=
kernel.org/pub/scm/linux/kernel/git/broonie/sound into for-linus)
Merging pci-current/for-linus (314489b Merge tag 'fixes-for-linus' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc)
Merging wireless/master (afa762f mac80211: call ieee80211_mgd_stop() on int=
erface stop)
Merging driver-core.current/driver-core-linus (e816b57 Linux 3.4-rc3)
Merging tty.current/tty-linus (66f75a5 Linux 3.4-rc4)
Merging usb.current/usb-linus (5c22837 USB: cdc-wdm: fix race leading leadi=
ng to memory corruption)
Merging staging.current/staging-linus (89f21cc staging: ozwpan: Fix bug whe=
re kfree is called twice.)
Merging char-misc.current/char-misc-linus (e816b57 Linux 3.4-rc3)
Merging cpufreq-current/fixes (6139b65 Merge branch 'for_3.4/cpufreq' of gi=
t://git.kernel.org/pub/scm/linux/kernel/git/khilman/linux-omap-pm into fixe=
s)
Merging input-current/for-linus (899c612 Input: synaptics - fix regression =
with "image sensor" trackpads)
Merging md-current/for-linus (30b8aa9 md: fix possible corruption of array =
metadata on shutdown.)
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
Merging arm/for-next (a6e6d51 Merge branches 'amba', 'clkdev', 'fixes', 'mi=
sc' and 'mmci' into for-next)
Merging arm-perf/for-next/perf (c16fa4f Linux 3.3)
Merging davinci/davinci-next (fe0d422 Linux 3.0-rc6)
Merging samsung/next-samsung (9edb240 ARM: H1940/RX1950: Change default LED=
 triggers)
Merging s5p/for-next (de12e47 Merge branch 'next/board-samsung' into for-ne=
xt)
Merging xilinx/arm-next (b85a3ef ARM: Xilinx: Adding Xilinx board support)
Merging blackfin/for-linus (35fe2e7 blackfin: update defconfig for bf527-ez=
kit)
Merging c6x/for-linux-next (c16fa4f Linux 3.3)
Merging cris/for-next (7b91747 cris: Remove old legacy "-traditional" flag =
from arch-v10/lib/Makefile)
Merging hexagon/linux-next (4bd8193 various Kconfig cleanup and old platfor=
m build code removal)
Merging ia64/next (16f2634 [IA64] Normalize return value of chip->irq_set_a=
ffinity() method)
Merging m68k/for-next (dd70ca0 m68k/video: Create <asm/vga.h>)
Merging m68knommu/for-next (b97c0bb m68knommu: make sure 2nd FEC eth interf=
ace pins are enabled on 5275 ColdFire)
Merging microblaze/next (258f742 modpost: Fix modpost license checking of v=
mlinux.o)
Merging mips/mips-for-linux-next (e21e529 Merge branch 'fixes-for-linus' in=
to mips-for-linux-next)
Merging openrisc/for-upstream (c88e692 asm-generic: add linux/types.h to cm=
pxchg.h)
Merging parisc/for-next (c60dc74 Merge branch 'fixes' into for-next)
Merging powerpc/next (0195c00 Merge tag 'split-asm_system_h-for-linus-20120=
328' of git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-asm_sy=
stem)
Merging 4xx/next (0195c00 Merge tag 'split-asm_system_h-for-linus-20120328'=
 of git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-asm_system)
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
Merging tile/master (44727a2 arch/tile: tilegx PCI root complex support)
Merging unicore32/unicore32 (0994695 Merge branch 'akpm' (aka "Andrew's pat=
ch-bomb, take two"))
Merging ceph/master (cd9d9f5 rbd: don't hold spinlock during messenger flus=
h)
Merging cifs/master (28f8881 Use correct conversion specifiers in cifs_show=
_options)
Merging configfs/linux-next (b930c26 Merge branch 'for-linus' of git://git.=
kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (6cfd4b4 ecryptfs: remove the second argument of k[un=
]map_atomic())
CONFLICT (content): Merge conflict in fs/ecryptfs/ecryptfs_kernel.h
Merging ext3/for_next (77f0a97 jbd: Write journal superblock with WRITE_FUA=
 after checkpointing)
Merging ext4/dev (57f73c2 ext4: fix handling of journalled quota options)
Merging fuse/for-next (519c604 fuse: optimize fallocate on permanent failur=
e)
Merging gfs2/master (144a4c2 GFS2: Log code fixes)
Merging logfs/master (cd8bfa9 logfs: initialize the number of iovecs in bio)
Merging nfs/linux-next (ca07929 SUNRPC: set per-net PipeFS superblock befor=
e notification)
Merging nfsd/nfsd-next (b108fe6 nfsd: trivial: use SEEK_SET instead of 0 in=
 vfs_llseek)
Merging ocfs2/linux-next (9392557 ocfs2: avoid unaligned access to dqc_bitm=
ap)
Merging omfs/for-next (976d167 Linux 3.1-rc9)
Merging squashfs/master (4b0180a Squashfs: add mount time sanity check for =
block_size and block_log match)
Merging v9fs/for-next (01627d9 Merge branch 'drm-fixes-intel' of git://peop=
le.freedesktop.org/~airlied/linux)
Merging ubifs/linux-next (65b3219 UBIFS: remove xattr Kconnfig option)
Merging xfs/for-next (bc236c3 xfs: use shared ilock mode for direct IO writ=
es by default)
Merging vfs/for-next (9448152 sch_atm.c: get rid of poinless extern)
Merging pci/next (96650e8 PCI: move mutex locking out of pci_dev_reset func=
tion)
Merging hid/for-next (e3e49c3 Merge branch 'logitech' into for-next)
Merging quilt/i2c (85bb1a8 i2c-dev: Add support for I2C_M_RECV_LEN)
Merging bjdooks-i2c/next-i2c (fc84fe1 Merge branch 'for_3.3/i2c/misc' of gi=
t://git.kernel.org/pub/scm/linux/kernel/git/khilman/linux-omap-pm into for-=
33/i2c/omap)
CONFLICT (content): Merge conflict in drivers/i2c/busses/i2c-omap.c
Merging i2c-embedded/i2c-embedded/for-next (a6979e5 of/i2c: implement of_fi=
nd_i2c_adapter_by_node)
Merging quilt/jdelvare-hwmon (e3a9568 hwmon: Add MCP3021 ADC driver)
Merging hwmon-staging/hwmon-next (ede8fc9 hwmon: (ad7314) Remove unused def=
ines, and rename OFFSET to SHIFT)
Merging v4l-dvb/master (2a43f0b Merge /home/v4l/v4l/patchwork)
CONFLICT (content): Merge conflict in drivers/usb/gadget/uvc_queue.c
Merging kbuild/for-next (63ce2ed Merge branch 'kbuild/rc-fixes' into kbuild=
/for-next)
Merging kconfig/for-next (eae1c36 Merge branch 'kconfig/for-linus-2' into k=
config/for-next)
Merging libata/NEXT (85d6725 libata: make ata_print_id atomic)
Merging infiniband/for-next (754c8d4 Merge branch 'raw-qp' into for-next)
Merging acpi/next (eeaab2d Merge branches 'idle-fix' and 'misc' into releas=
e)
Merging cpupowerutils/master (f166033 cpupower tools: add install target to=
 the debug tools' makefiles)
Merging ieee1394/for-next (8527f8e firewire: core: fw_device_refresh(): cle=
an up error handling)
Merging ubi/linux-next (66f75a5 Linux 3.4-rc4)
Merging dlm/next (1b189b8 dlm: last element of dlm_local_addr[] never used)
Merging scsi/for-next (b965030 Merge branch 'misc' into for-next)
Merging target-updates/for-next (bfb79ea target/iscsi: Go back to core allo=
cating data buffer for cmd)
Merging target-merge/for-next-merge (3e6e9e9 sbp-target: Initial merge of f=
irewire/ieee-1394 target mode support)
Merging ibft/linux-next (935a9fe ibft: Fix finding IBFT ACPI table on UEFI)
Merging isci/all (475448a merge: libsas devel rnc-devel fixes)
CONFLICT (content): Merge conflict in include/scsi/libsas.h
CONFLICT (content): Merge conflict in drivers/scsi/libsas/sas_discover.c
Merging slave-dma/next (56cbb3d Merge branch 'fixes' into next)
Merging dmaengine/next (a2bd114 netdma: adding alignment check for NETDMA o=
ps)
Merging net-next/master (a85c9bb Merge branch 'for-davem' of git://git.kern=
el.org/pub/scm/linux/kernel/git/linville/wireless-next)
CONFLICT (content): Merge conflict in drivers/net/ethernet/intel/e1000e/par=
am.c
CONFLICT (content): Merge conflict in drivers/net/ethernet/emulex/benet/be.h
Merging wireless-next/master (94c514f mac80211: Adds clean sdata helper)
Merging bluetooth/master (139437f Bluetooth: Fix EIR data generation for mg=
mt_device_found)
Merging mtd/master (7b0e67f mtd: docg3 add protection against concurrency)
Merging l2-mtd/master (dc3c67c mtd: fsmc_nand: Add clk_{un}prepare() suppor=
t)
Merging crypto/master (d788fec crypto, xor: Sanitize checksumming function =
selection output)
Merging sound/for-next (dbc3096 Merge branch 'topic/misc' into for-next)
Merging sound-asoc/for-next (7126eae Merge branch 'for-3.5' into asoc-next)
Merging cpufreq/next (a7b422c provide disable_cpufreq() function to disable=
 the API.)
Merging quilt/rr (2a22b63 cpumask: remove old cpu_*_map.)
CONFLICT (content): Merge conflict in init/main.c
CONFLICT (content): Merge conflict in drivers/virtio/virtio_balloon.c
CONFLICT (content): Merge conflict in arch/arm/kernel/kprobes.c
Merging input/next (5d06647 Input: use module_pci_driver)
Merging input-mt/for-next (66f75a5 Linux 3.4-rc4)
Merging cgroup/for-next (c4c27fb cgroups: disallow attaching kthreadd or PF=
_THREAD_BOUND threads)
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
Merging mmc/mmc-next (0e9f480 mmc: cd-gpio: protect against NULL context in=
 mmc_cd_gpio_free())
Merging kgdb/kgdb-next (3751d3e x86,kgdb: Fix DEBUG_RODATA limitation using=
 text_poke())
Merging slab/for-next (b80b6c0 Merge branch 'slab/next' into for-next)
Merging uclinux/for-next (5e442a4 Revert "proc: fix races against execve() =
of /proc/PID/fd**")
Merging md/for-next (732f027 MD RAID1: Further conditionalize 'fullsync')
Merging mfd/for-next (c00ba41 mfd: No need to check for the GPIO offset fro=
m asic3_gpio_to_irq)
CONFLICT (content): Merge conflict in drivers/mfd/asic3.c
Merging battery/master (5cdd4d7 max17042_battery: Clean up interrupt handli=
ng)
Merging drm/drm-next (1b23170 vga: fix build when fbdev is a module)
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/intel_i2c.c
Merging fbdev/fbdev-next (d313a86 i.MX28: Shut down the LCD controller to a=
void BootROM sampling bug)
Merging viafb/viafb-next (838ac78 viafb: avoid refresh and mode lookup in s=
et_par)
Merging omap_dss2/for-next (df01d53 OMAPDSS: APPLY: fix clearing shadow dir=
ty flag with manual update)
Merging regulator/for-next (ac971f0 Merge branch 'regulator-drivers' into r=
egulator-next)
Merging security/next (08162e6 Yama: remove an unused variable)
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
Merging pm/linux-next (2580dbf The file Documentation/power/freezing-of-tas=
ks.txt was still referencing the TIF_FREEZE flag, that was removed by the c=
ommit d88e4cb67197d007fb778d62fe17360e970d5bfa(freezer: remove now unused T=
IF_FREEZE).)
Merging apm/for-next (f283d22 APM: fix deadlock in APM_IOC_SUSPEND ioctl)
Merging fsnotify/for-next (1aec9c0 inotify: automatically restart syscalls)
Merging edac/linux_next (a4b4be3 edac: rename channel_info to rank_info)
Merging edac-amd/for-next (305f1c3 Merge branch '3.3-pci_device_id' into ed=
ac-for-next)
Merging devicetree/devicetree/next (0f22dd3 of: Only compile OF_DYNAMIC on =
PowerPC pseries and iseries)
Merging spi/spi/next (d57a428 spi/devicetree: Move devicetree support code =
into spi directory)
Merging tip/auto-latest (dc71c17 Merge branch 'timers/urgent')
CONFLICT (content): Merge conflict in arch/x86/Kconfig
Merging rcu/rcu/next (b46dbb4 Merge branches 'barrier.2012.04.25a', 'fixes.=
2012.04.25a', 'inline.2012.04.25a' and 'srcu.2012.04.25a' into next.2012.04=
.25a)
Merging cputime/cputime (c3e0ef9 [S390] fix cputime overflow in uptime_proc=
_show)
Merging uprobes/for-next (0326f5a uprobes/core: Handle breakpoint and singl=
estep exceptions)
Merging kmemleak/kmemleak (4878677 kmemleak: do not leak object after tree =
insertion error)
Merging kvm/linux-next (38e8a2d KVM: x86 emulator: fix asm constraint in fl=
ush_pending_x87_faults)
CONFLICT (content): Merge conflict in Documentation/feature-removal-schedul=
e.txt
Merging kvm-ppc/kvm-ppc-next (4831570 KVM: PPC: Book3S: Call into C interru=
pt handlers)
Merging oprofile/for-next (c16fa4f Linux 3.3)
Merging xen/upstream/xen (af3a3ab Merge git://git.kernel.org/pub/scm/linux/=
kernel/git/steve/gfs2-3.0-fixes)
Merging xen-two/linux-next (e300b82 Merge branch 'stable/for-linus-3.4' int=
o linux-next)
Merging xen-pvhvm/linux-next (b056b6a xen: suspend: remove xen_hvm_suspend)
Merging percpu/for-next (adb7950 percpu: fix __this_cpu_{sub,inc,dec}_retur=
n() definition)
Merging workqueues/for-next (0976dfc workqueue: Catch more locking problems=
 with flush_work())
Merging drivers-x86/linux-next (e64c9de dell-laptop: Terminate quirks list =
properly)
Merging hwpoison/hwpoison (46e387b Merge branch 'hwpoison-hugepages' into h=
wpoison)
Merging sysctl/master (4e474a0 sysctl: protect poll() in entries that may g=
o away)
Merging regmap/for-next (b076764 Merge branch 'regmap-stride' into regmap-n=
ext)
Merging hsi/for-next (43139a6 HSI: hsi_char: Update ioctl-number.txt)
Merging driver-core/driver-core-next (a1d26ac Extcon: check for allocation =
failure)
Merging tty/tty-next (5d1a33f vt: push the tty_lock down into the map handl=
ing)
Merging usb/usb-next (b087657 USB: ehci-tegra: remove PORT_RWC_BITS when se=
tting USB_PORT_FEAT_ENABLE)
$ git reset --hard HEAD^
Merging refs/next/20120424/usb
Merging staging/staging-next (db3b9e9 Staging: VME: move VME drivers out of=
 staging)
CONFLICT (content): Merge conflict in drivers/staging/vt6656/ioctl.c
CONFLICT (content): Merge conflict in drivers/staging/line6/driver.c
CONFLICT (content): Merge conflict in drivers/staging/android/Makefile
CONFLICT (content): Merge conflict in drivers/staging/android/Kconfig
CONFLICT (content): Merge conflict in drivers/Makefile
CONFLICT (content): Merge conflict in drivers/Kconfig
Merging char-misc/char-misc-next (9912143 parport: remove unused dead code =
from lowlevel drivers)
Merging tmem/linux-next (0f1ea93 Merge branch 'stable/frontswap.v14' into l=
inux-next)
Merging writeback/writeback-for-next (4cd9069 fs: remove 8 bytes of padding=
 from struct writeback_control on 64 bit builds)
Merging arm-dt/devicetree/arm-next (ede338f dt: add documentation of ARM dt=
 boot interface)
Merging hwspinlock/linux-next (8b37fcf hwspinlock: add MAINTAINERS entries)
Merging pinctrl/for-next (413ba2e pinctrl: support gpio request deferred pr=
obing)
CONFLICT (content): Merge conflict in drivers/pinctrl/core.c
CONFLICT (content): Merge conflict in Documentation/driver-model/devres.txt
Merging tegra/for-next (1de9e51 Merge branch 'for-3.5/defconfig' into for-n=
ext)
Merging moduleh/for-sfr (3c5c69b blackfin: fix ifdef fustercluck in mach-bf=
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
Merging arm-soc/for-next (4ffcc6e Merge branch 'fixes' into for-next)
CONFLICT (content): Merge conflict in arch/arm/mach-lpc32xx/common.c
Merging kvmtool/master (0333eec kvm tools: Update README for CONFIG_FB_VESA)
Merging dma-mapping/dma-mapping-next (c6b1f07 ARM: integrate CMA with DMA-m=
apping subsystem)
CONFLICT (content): Merge conflict in arch/x86/include/asm/dma-mapping.h
Merging dma-buf/for-next (66f75a5 Linux 3.4-rc4)
Merging ktest/for-next (648a182 ktest: Allow a test to override REBOOT_ON_S=
UCCESS)
Merging scsi-post-merge/merge-base:master ()
$ git checkout akpm
Applying: pagemap.h: fix warning about possibly used before init var
Applying: mm: correctly synchronize rss-counters at exit/exec
Applying: mm-correctly-synchronize-rss-counters-at-exit-exec-fix
Applying: mm: set task exit code before complete_vfork_done()
Applying: umem: fix up unplugging
Applying: arch/x86/platform/geode/net5501.c: change active_low to 0 for LED=
 driver
Applying: arch/x86/platform/iris/iris.c: register a platform device and a p=
latform driver
Applying: intel_mid_powerbtn: mark irq as IRQF_NO_SUSPEND
Applying: arch/x86/include/asm/spinlock.h: fix comment
Applying: arch/x86/kernel/apic/io_apic.c: move io_apic_level_ack_pending() =
inside CONFIG_GENERIC_PENDING_IRQ
Applying: drivers/xen/Kconfig: fix Kconfig layout
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
Applying: drm/i915: fix integer overflow in i915_gem_execbuffer2()
Applying: drm/i915: fix integer overflow in i915_gem_do_execbuffer()
Applying: timeconst.pl: remove deprecated defined(@array)
Applying: ia64: use set_current_blocked() and block_sigmask()
Applying: microblaze: don't reimplement force_sigsegv()
Applying: microblaze: no need to reset handler if SA_ONESHOT
Applying: microblaze: fix signal masking
Applying: microblaze: use set_current_blocked() and block_sigmask()
Applying: score: don't mask signals if we fail to setup signal stack
Applying: score: use set_current_blocked() and block_sigmask()
Applying: h8300: use set_current_blocked() and block_sigmask()
Applying: unicore32: use block_sigmask()
Applying: connector/userns: replace netlink uses of cap_raised with capable.
Applying: blackfin: use set_current_blocked() and block_sigmask()
Applying: ocfs2: use find_last_bit()
Applying: ocfs2: use bitmap_weight()
Applying: drivers/scsi/ufs: use module_pci_driver
Applying: drivers/scsi/ufs: reverse the ufshcd_is_device_present logic
Applying: drivers/scsi/ufs: fix evaluation of task_failed status
Applying: drivers/scsi/atp870u.c: fix bad use of udelay
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
Applying: mm: remove swap token code
Applying: mm: vmscan: remove lumpy reclaim
Applying: mm: vmscan: do not stall on writeback during memory compaction
Applying: mm: vmscan: remove reclaim_mode_t
Applying: hugetlb: rename max_hstate to hugetlb_max_hstate
Applying: hugetlbfs: don't use ERR_PTR with VM_FAULT* values
Applying: hugetlbfs: add an inline helper for finding hstate index
Applying: hugetlb: use mmu_gather instead of a temporary linked list for ac=
cumulating pages
Applying: hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-acc=
umulating-pages-fix
Applying: hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-acc=
umulating-pages-fix-fix
Applying: hugetlb: avoid taking i_mmap_mutex in unmap_single_vma() for huge=
tlb
Applying: hugetlb: simplify migrate_huge_page()
Applying: memcg: add HugeTLB extension
Applying: hugetlb: add charge/uncharge calls for HugeTLB alloc/free
Applying: memcg: track resource index in cftype private
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
Applying: memcg: add memory controller documentation for hugetlb management
Applying: mm: fix off-by-one bug in print_nodes_state()
Applying: mm: use kcalloc() instead of kzalloc() to allocate array
Applying: mm/mmap.c: find_vma(): remove unnecessary if(mm) check
Applying: mm-mmapc-find_vma-remove-unnecessary-ifmm-check-fix
Applying: mm/fork: fix overflow in vma length when copying mmap on clone
Applying: mm/vmstat.c: remov debug fs entries on failure of file creation a=
nd made extfrag_debug_root dentry local
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
Applying: CodingStyle: add kmalloc_array() to memory allocators
Applying: parisc: use set_current_blocked() and block_sigmask()
Applying: introduce SIZE_MAX
Applying: sethostname/setdomainname: notify userspace when there is a chang=
e in uts_kern_table
Applying: vsprintf: correctly handle width when '#' flag used in %#p format.
Applying: vsprintf-correctly-handle-width-when-flag-used-in-%p-format-check=
patch-fixes
Applying: vsprintf: further optimize decimal conversion
Applying: vsprintf-further-optimize-decimal-conversion-v2
Applying: vsprintf-further-optimize-decimal-conversion-checkpatch-fixes
Applying: hamradio/scc: orphan driver in MAINTAINERS
Applying: MAINTAINERS: remove Alessandro
Applying: blacklight: remove redundant spi driver bus initialization
Applying: lcd: add callbacks for early fb event blank support
Applying: fbdev: add events for early fb event support
Applying: drivers/leds/leds-lp5521.c: fix lp5521_read() error handling
Applying: leds: driver for DA9052/53 PMIC v2
Applying: leds-led-module-for-da9052-53-pmic-v2-fix
Applying: leds: add LED driver for lm3556 chip
Applying: leds-add-led-driver-for-lm3556-chip-checkpatch-fixes
Applying: leds: lm3556: Don't call kfree for the memory allocated by devm_k=
zalloc
Applying: leds: simple_strtoul() cleanup
Applying: leds: Use kcalloc instead of kzalloc to allocate array
Applying: leds: add new field to led_classdev struct to save activation sta=
te
Applying: leds: change existing triggers to use activated flag
Applying: leds: change ledtrig-timer to use activated flag
Applying: include/linux/led-lm3530.h: comment correction about the range of=
 brightness
Applying: drivers/leds/leds-lm3530.c: simplify als configuration on initial=
ization
Applying: leds: heartbeat: stop on shutdown
Applying: leds-heartbeat-stop-on-shutdown-checkpatch-fixes
Applying: list_debug: WARN for adding something already in the list
Applying: lib/test-kstrtox.c: mark const init data with __initconst instead=
 of __initdata
Applying: lib/string_helpers.c: make arrays static
Applying: lib/bitmap.c: fix documentation for scnprintf() functions
Applying: vsprintf: fix %ps on non symbols when using kallsyms
Applying: spinlock_debug: print kallsyms name for lock
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
Applying: rtc: ds1307: remove superfluous initialization
Applying: rtc: ds1307: add trickle charger support
Applying: drivers/rtc/rtc-m41t93.c: don't let get_time() reset M41T93_FLAG_=
OF
Applying: HPFS: remove PRINTK() macro
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
Applying: proc: use IS_ERR_OR_NULL()
Applying: fork: call complete_vfork_done() after clearing child_tid and flu=
shing rss-counters
Applying: ipc/sem.c: alternatives to preempt_disable()
Applying: ipc/mqueue: cleanup definition names and locations
Applying: ipc/mqueue: switch back to using non-max values on create
Applying: ipc/mqueue: enforce hard limits
Applying: ipc/mqueue: update maximums for the mqueue subsystem
Applying: mqueue: revert bump up DFLT_*MAX
Applying: mqueue: don't use kmalloc with KMALLOC_MAX_SIZE
Applying: mqueue: separate mqueue default value from maximum value
Applying: selftests: add mq_open_tests
Applying: rapidio: add DMA engine support for RIO data transfers
Applying: rapidio/tsi721: add DMA engine support
Applying: eventfd: change int to __u64 in eventfd_signal()
Applying: eventfd-change-int-to-__u64-in-eventfd_signal-fix
Applying: w1: fix ds28e04 build, select CRC16
Applying: aio/vfs: cleanup of rw_copy_check_uvector() and compat_rw_copy_ch=
eck_uvector()
Applying: sysctl: make kernel.ns_last_pid control dependent on CHECKPOINT_R=
ESTORE
Applying: fs, proc: introduce /proc/<pid>/task/<tid>/children entry
Applying: syscalls, x86: add __NR_kcmp syscall
Applying: syscalls-x86-add-__nr_kcmp-syscall-v8 comment update
Applying: syscalls-x86-add-__nr_kcmp-syscall-v8-comment-update-fix
Applying: c/r: procfs: add arg_start/end, env_start/end and exit_code membe=
rs to /proc/$pid/stat
Applying: c/r: prctl: extend PR_SET_MM to set up more mm_struct entries
Applying: c/r: prctl: simplify PR_SET_MM on mm::code/data assignment
Applying: c/r: prctl: return -EFAULT instead of -EINVAL in case if underlie=
d VMA is not found
Applying: c/r: prctl: add ability to set new mm_struct::exe_file
Applying: c/r: prctl: update prctl_set_mm_exe_file() after mm->num_exe_file=
_vmas removal
Applying: c/r: prctl: add ability to get clear_tid_address
Applying: ramoops: use pstore interface
Applying: ramoops: fix printk format warnings
Applying: kconfig: update compression algorithm info
Applying: notify_change(): check that i_mutex is held
Merging akpm (dbbf8c7 notify_change(): check that i_mutex is held)
Applying: ipc/mqueue: using vmalloc requires including vmalloc.h
Applying: KVM/PPC: do not export things twice

--Signature=_Fri__27_Apr_2012_16_11_46_+1000_uATYjSpFRgXDW6Sp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPmjiiAAoJEECxmPOUX5FEF+EP/2E1DbXE/zStWPE0KnX7tTUS
RW/DjsT5NGBx2q5HG2OoRQ4kpCzQC+G5sys8ML0RU9Gpif9bVtb6QhKi1BhBeZ94
aJFPWGlmxjsqOUcJpU3+VL5yRLOMyH67bNLoNLT4ThTO2wNXy3tpGhah5dSX/k/L
UUAcvzLnQU64KUiEhAiuu58wW46PV3ZxTv0Wwi6D6VBeKxDIfSNW4iU5kyR3g1UW
Xy1+U4Br+XDrjdmuCHTn7prmMHMNVKHcsZYPxnJa+9YPcjoEtu7DgSVQ7pyce1zr
6mFH0G1+rwWTVcY9KSHGe/BeZrtu6jhOc4iZjv2y6iEyJNgZWxllu/exxlnKynTp
hdZe/aQBYCZG9unajBc5yCU1PDJRQiJUMiBXPaTPQzF2dA2YZ40o7vqrdRhFmYUT
PcdjZDrvEC6xGy5Tm01YUp2e8wwUHuufyz2ZCkTPEqunQO2yYXZh0wmwBrizGI45
qTs1PQFG3Fl92CJx/O2mk+pswrJ+GPema8Ht8CWPkTRinVpUblL0Ft9cb8ozgRdK
lxy96AJ3iJLkrOd5wlWhLiqkFYA6XxRJrtMVCfU/kUZawkP9Hvi6aYWepwlDZ37v
7Nt4Y9AYbiQx4PjCo2kqNfcbOYGyQLtzzN601udGYFFfzQ3G0lr8vrcAKboT7RO9
n7MmrbzvrIPlzSrwr+yD
=guWN
-----END PGP SIGNATURE-----

--Signature=_Fri__27_Apr_2012_16_11_46_+1000_uATYjSpFRgXDW6Sp--

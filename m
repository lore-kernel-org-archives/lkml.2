Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176Ab1KUCj6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Nov 2011 21:39:58 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:51046 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754888Ab1KUCjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Nov 2011 21:39:53 -0500
Date: Mon, 21 Nov 2011 13:39:36 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Nov 21
Message-Id: <20111121133936.ae0ecadbf39ae50da6b842d1@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__21_Nov_2011_13_39_36_+1100_dSyeJB2+U71bPjYJ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__21_Nov_2011_13_39_36_+1100_dSyeJB2+U71bPjYJ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20111118:

The drm tree still had its build failure so I used the version from
next-20111115.

The slave-dms tree gained a conflict against the s5p tree.

The driver-core tree gained a build failure so I used the version from
next-20111118.

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

We are up to 195 trees (counting Linus' and 27 trees of patches pending
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
Merging origin/master (a767835 Merge branch 'hwmon-for-linus' of git://git.=
kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging)
Merging fixes/master (3155521 Revert "hvc_console: display printk messages =
on console.")
Merging kbuild-current/rc-fixes (44656fa kbuild: Fix missing system calls c=
heck on mips.)
Merging arm-current/fixes (e548984 ARM: wire up process_vm_writev and proce=
ss_vm_readv syscalls)
Merging m68k-current/for-linus (2690e21 m68k/mac: Remove mac_irq_{en,dis}ab=
le() wrappers)
Merging powerpc-merge/merge (a313f4c powerpc/signal32: Fix sigset_t convers=
ion when copying to user)
Merging 52xx-and-virtex-current/powerpc/merge (c49f878 dtc/powerpc: remove =
obsolete .gitignore entries)
Merging sparc/master (0b64120 sparc64: Patch sun4v code sequences properly =
on module load.)
Merging scsi-rc-fixes/master (e5a44df [SCSI] hpsa: Disable ASPM)
Merging net/master (9cc20b2 ipv4: fix redirect handling)
Merging sound-current/for-linus (05ee796 ALSA: hda - Fix the connection sel=
ection of ADCs on Cirrus codecs)
Merging pci-current/for-linus (4cac2eb PCI hotplug: shpchp: don't blindly c=
laim non-AMD 0x7450 device IDs)
Merging wireless/master (2d16181 p54spi: Fix workqueue deadlock)
Merging driver-core.current/driver-core-linus (91a13c2 drivers/base/node.c:=
 fix compilation error with older versions of gcc)
Merging tty.current/tty-linus (0c73c08 TTY: ldisc, wait for ldisc infinitel=
y in hangup)
Merging usb.current/usb-linus (b1ffb4c USB: Fix Corruption issue in USB ftd=
i driver ftdi_sio.c)
Merging staging.current/staging-linus (c9fb041 staging: fix more ET131X bui=
ld errors)
Merging char-misc.current/char-misc-linus (6ac2afb misc: ad525x_dpot: Fix A=
D8400 spi transfer size.)
Merging cpufreq-current/fixes (eb0b38a [CPUFREQ] db8500: fix build error du=
e to undeclared i variable)
Merging input-current/for-linus (77f6ca5 Input: ams_delta_serio - include l=
inux/module.h)
Merging md-current/for-linus (257a4b4 md/raid5: STRIPE_ACTIVE has lock sema=
ntics, add barriers)
Merging audit-current/for-linus (def5754 Audit: remove spaces from audit_lo=
g_d_path)
Merging crypto-current/master (3acc847 crypto: algapi - Fix build problem w=
ith NET disabled)
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
Merging arm/for-next (9a2b593 Merge branches 'fixes', 'misc', 'pgt', 'resta=
rt-base' and 'restart-cleanup' into for-next)
Merging arm-lpae/for-next (bba902c ARM: LPAE: Add the Kconfig entries)
CONFLICT (content): Merge conflict in arch/arm/include/asm/tlb.h
CONFLICT (content): Merge conflict in arch/arm/include/asm/pgtable.h
CONFLICT (content): Merge conflict in arch/arm/include/asm/pgalloc.h
Merging arm-soc/for-next (3155521 Revert "hvc_console: display printk messa=
ges on console.")
Merging at91/at91-next (de21d1d ARM: at91: pm_slowclock rename register to =
named define)
Merging davinci/davinci-next (fe0d422 Linux 3.0-rc6)
Merging i.MX/for-next (5788f4d Merge branches 'imx-fixes', 'imx-cleanup' an=
d 'imx-features' into master)
CONFLICT (content): Merge conflict in arch/arm/plat-mxc/include/mach/hardwa=
re.h
CONFLICT (content): Merge conflict in arch/arm/mach-mx5/mm.c
CONFLICT (content): Merge conflict in arch/arm/mach-mx5/devices-imx53.h
CONFLICT (content): Merge conflict in arch/arm/mach-mx5/clock-mx51-mx53.c
Merging linux-spec/for-next (5111711 Merge branch 'for-2.6.37' of git://lin=
ux-nfs.org/~bfields/linux)
Merging omap/for-next (322a8b0 Linux 3.1-rc1)
Merging pxa/for-next (19d6c13 [ARM] pxa/hx4700: actually use platform_lcd d=
river)
Merging samsung/next-samsung (9edb240 ARM: H1940/RX1950: Change default LED=
 triggers)
Merging s5p/for-next (a188e1e Merge branch 'next-samsung-devel' into for-ne=
xt)
Merging tegra/for-next (b48c54e Merge branch 'for-3.3/boards' into for-next)
Merging xilinx/arm-next (b85a3ef ARM: Xilinx: Adding Xilinx board support)
Merging blackfin/for-linus (9059054 blackfin: Fixup export.h includes)
Merging c6x/for-linux-next (2141355 C6X: MAINTAINERS)
Merging cris/for-next (ea78f5b CRIS: Update documentation)
Merging quilt/hexagon (976d167 Linux 3.1-rc9)
Merging ia64/next (2174f6d pstore: gracefully handle NULL pstore_info funct=
ions)
Merging m68k/for-next (9e9ceea m68k: Don't comment out syscalls used by gli=
bc)
Merging m68knommu/for-next (d0bf61c m68k: make fp register stores consisten=
t for m68k and ColdFire)
CONFLICT (content): Merge conflict in arch/m68k/Kconfig.debug
Merging microblaze/next (7f80850 Merge branch 'rmobile-fixes-for-linus' of =
git://github.com/pmundt/linux-sh)
Merging mips/mips-for-linux-next (4954840 Merge branches 'ar7-for-next', 'a=
th79-for-next', 'bcm63xx-for-next', 'bmips', 'cavium-for-next', 'kprobes-fo=
r-next' and 'raza-for-next' into mips-for-linux-next)
Merging openrisc/for-upstream (b6fd41e Linux 3.1-rc6)
Merging parisc/for-next (fc99a91 futex: Use same lock set as lws calls)
Merging powerpc/next (96cc017 powerpc/p3060qds: Add support for P3060QDS bo=
ard)
Merging 4xx/next (9fcd768 powerpc/40x: Remove obsolete HCU4 board)
Merging 52xx-and-virtex/powerpc/next (c1395f4 dtc/powerpc: remove obsolete =
.gitignore entries)
Merging galak/next (4022ded powerpc/85xx: Update SRIO device tree nodes)
Merging s390/features (100683e [S390] topology: cleanup z10 topology handli=
ng)
Merging sh/sh-latest (b9a3acf Merge branch 'sh/stable-updates' into sh-late=
st)
Merging rmobile/rmobile-latest (b58c580 Merge branch 'rmobile-fixes-for-lin=
us' into rmobile-latest)
Merging sparc-next/master (3ee72ca Merge git://github.com/davem330/net)
Merging tile/master (1583171 Merge branch 'for-linus' of git://github.com/c=
metcalf-tilera/linux-tile)
Merging unicore32/unicore32 (ed96dfb unicore32, exec: remove redundant set_=
fs(USER_DS))
Merging xtensa/master (29aced6 xtensa: remove defining register numbers)
Merging ceph/for-next (3395734 libceph: fix double-free of page vector)
Merging cifs/master (9c32c63 cifs: Fix sparse warning when calling cifs_str=
toUCS)
Merging configfs/linux-next (420118c configfs: Rework configfs_depend_item(=
) locking and make lockdep happy)
Merging ecryptfs/next (985ca0e ecryptfs: Make inode bdi consistent with sup=
erblock bdi)
Merging ext3/for_next (ed47a7d udf: Cleanup metadata flags handling)
Merging ext4/dev (5c8a0fb VFS: fix statfs() automounter semantics regressio=
n)
Merging fatfs/master (710d440 fat: fat16 support maximum 4GB file/vol size =
as WinXP or 7.)
Merging fuse/for-next (cfcfc9e Linux 3.2-rc2)
Merging gfs2/master (b9f417f GFS2: remove vestigial al_alloced)
Merging hfsplus/for-next (6596528 hfsplus: ensure bio requests are not smal=
ler than the hardware sectors)
Merging jfs/next (1c8007b jfs: flush journal completely before releasing me=
tadata inodes)
Merging logfs/master (011a85a logfs: Prevent memory corruption)
CONFLICT (content): Merge conflict in fs/logfs/file.c
Merging nfs/linux-next (62e4a76 NFS: Revert pnfs ugliness from the generic =
NFS read code path)
Merging nfsd/nfsd-next (353de31 nfsd4: fix CONFIG_NFSD_FAULT_INJECTION comp=
ile error)
Merging nilfs2/for-next (93ee7a9 Linux 3.1-rc2)
Merging ocfs2/linux-next (249ec93 ocfs2: Use filemap_write_and_wait() inste=
ad of write_inode_now())
Merging omfs/for-next (976d167 Linux 3.1-rc9)
Merging squashfs/master (7657cac Squashfs: Add an option to set dev block s=
ize to 4K)
Merging v9fs/for-next (14211d0 9p: fix 9p.txt to advertise msize instead of=
 maxdata)
Merging ubifs/linux-next (7606f85 UBIFS: fix the dark space calculation)
Merging xfs/master (c889132 MAINTAINERS: update XFS maintainer entry)
Merging vfs/for-next (206b1d0 Fix POSIX ACL permission check)
Merging vfs-scale/vfs-scale-working (32385c7 kernel: fix hlist_bl again)
Merging pci/linux-next (cfbf1bd PCI: msi: Disable msi interrupts when we in=
itialize a pci device)
Merging hid/for-next (f357a38 Merge branch 'upstream' into for-next)
Merging quilt/i2c (7ed4742 i2c: Delete ANY_I2C_BUS)
Merging bjdooks-i2c/next-i2c (f8420b7 fixup merge)
CONFLICT (add/add): Merge conflict in drivers/i2c/busses/i2c-designware-pla=
tdrv.c
Merging quilt/jdelvare-hwmon (1ea6b8f Linux 3.2-rc1)
Merging hwmon-staging/hwmon-next (3627902 hwmon: (exynos4_tmu) Fix Kconfig =
dependency)
Merging quilt/kernel-doc (c3b92c8 Linux 3.1)
Merging docs/docs-move (5c24d8b Merge branch 'docs/docbook/drm' of git://gi=
thub.com/mfwitten/linux into docs-move)
Merging v4l-dvb/master (eeff030 Merge branch 'poll-pwc' of /home/v4l/v4l/pa=
tchwork)
CONFLICT (content): Merge conflict in drivers/staging/media/as102/as102_drv=
.h
Merging kbuild/for-next (ddb550d Merge branch 'kbuild/misc' into kbuild/for=
-next)
Merging kconfig/for-next (eae1c36 Merge branch 'kconfig/for-linus-2' into k=
config/for-next)
Merging libata/NEXT (3fab0c1 ahci: start engine only during soft/hard reset=
s)
Merging infiniband/for-next (042f36e IB/qib: Don't use schedule_work())
Merging acpi/next (efb9058 Merge branches 'acpi', 'idle', 'mrst-pmu' and 'p=
m-tools' into next)
Merging cpupowerutils/master (498ca79 cpupower: use man(1) when calling "cp=
upower help subcommand")
Merging ieee1394/for-next (a572e68 firewire: ohci: fix isochronous DMA sync=
hronization)
Merging ubi/linux-next (93ee7a9 Linux 3.1-rc2)
Merging dlm/next (9beb3bf dlm: convert rsb list to rb_tree)
Merging scsi/master (f7c9c6b [SCSI] Fix block queue and elevator memory lea=
k in scsi_alloc_sdev)
Merging target-updates/for-next (5bda90c target: use ->exectute_task for al=
l CDB emulation)
Merging target-merge/for-next-merge (e0d85e5 ib_srpt: Initial SRP Target me=
rge for v3.2-rc1)
Merging slave-dma/next (ca21a14 dmaengine: add CSR SiRFprimaII DMAC driver)
CONFLICT (content): Merge conflict in drivers/dma/pl330.c
Merging async_tx/next (21ef4b8 dmaengine: use DEFINE_IDR for static initial=
ization)
Merging net-next/master (f8a15af team: replace kmalloc+memcpy by kmemdup)
CONFLICT (content): Merge conflict in drivers/net/wireless/libertas/cfg.c
CONFLICT (content): Merge conflict in drivers/net/ethernet/nvidia/forcedeth=
.c
Merging wireless-next/master (e3bea1c mwifiex: add support for Marvell sd87=
97 device)
Merging bluetooth/master (a9c81fb Bluetooth: making enable_hs independent f=
rom L2CAP)
Merging mtd/master (e0d6511 Merge git://git.infradead.org/mtd-2.6)
Merging l2-mtd/master (bd1669f mtd: nand: Making MTD_NAND_OMAP2 depend on A=
RCH_OMAP2PLUS)
Merging crypto/master (d19978f crypto: fix typo in crypto/Kconfig)
Merging sound/for-next (d8534d5 Merge branch 'fix/hda' into for-next)
Merging sound-asoc/for-next (2f534ed ASoC: alc5632: Remove volatile registe=
rs from regmap defaults)
Merging cpufreq/next (5aace58 [CPUFREQ] ARM Exynos4210 PM/Suspend compatibi=
lity with different bootloaders)
Merging quilt/rr (a1eabe9 module: Fix performance regression on modules wit=
h large symbol tables)
Merging input/next (59bae1d Input: add EETI eGalax I2C capacitive multi tou=
ch driver)
CONFLICT (content): Merge conflict in drivers/input/keyboard/samsung-keypad=
.c
Merging input-mt/next (02f8c6a Linux 3.0)
Merging lsm/for-next (ca05a99 capabilities: remain source compatible with 3=
2-bit raw legacy capability support.)
Merging block/for-next (747af4c Merge branch 'for-linus' into for-next)
Merging quilt/device-mapper (94956ee Merge git://git.kernel.org/pub/scm/lin=
ux/kernel/git/davem/net)
Merging embedded/master (4744b43 embedded: fix vc_translate operator preced=
ence)
Merging firmware/master (6e03a20 firmware: speed up request_firmware(), v3)
Merging pcmcia/master (74411c0 smc91c92_cs.c: fix bogus compiler warning)
Merging battery/master (85b5fbf power_supply: Fix sysfs format warning)
Merging mmc/mmc-next (ce8fda6 mmc: core: Fix typo at mmc_card_sleep)
Merging kgdb/kgdb-next (880ba69 lib: rename pack_hex_byte() to hex_byte_pac=
k())
Merging slab/for-next (3bd3e0c Merge branch 'slab/next' into for-next)
Merging uclinux/for-next (5e442a4 Revert "proc: fix races against execve() =
of /proc/PID/fd**")
Merging md/for-next (c7eefaf md/raid1: Mark device replaceable when we see =
a write error.)
Merging mfd/for-next (b958f7a mfd: Fix missing abx500 header file updates)
Merging hdlc/hdlc-next (4a6908a Linux 2.6.28)
Merging drm/drm-next (08aa3fe Merge branch 'drm-plane-jbarnes' into drm-cor=
e-next)
$ git reset --hard HEAD^
Merging refs/next/20111115/drm
Merging fbdev/fbdev-next (4420dd2 video: s3c-fb: fix transparency length fo=
r pixel blending)
Merging viafb/viafb-next (4ce36bb viafb: replace strict_strtoul to kstrto* =
and check return value)
Merging omap_dss2/for-next (3e28189 OMAPDSS: picodlp: add missing #include =
<linux/module.h>)
Merging regulator/for-next (a92460d regulator: Don't create voltage sysfs e=
ntries if we can't read voltage)
Merging security/next (4e2c5b2 Merge branch 'next-evm-digsig' of git://git.=
kernel.org/pub/scm/linux/kernel/git/kasatkin/linux-digsig into next)
Merging selinux/master (ded5098 SELinux: skip file_name_trans_write() when =
policy downgraded.)
Merging lblnet/master (7e27d6e Linux 2.6.35-rc3)
Merging watchdog/linux-next (20403e8 watchdog: fix initialisation printout =
in s3c2410_wdt)
Merging bdev/master (feaf384 Merge branch 'for-linus' of git://git.kernel.d=
k/linux-2.6-block)
Merging dwmw2-iommu/master (c3b92c8 Linux 3.1)
Merging iommu/next (a7e892e Merge branches 'iommu/fixes', 'iommu/page-sizes=
' and 'iommu/group-id' into next)
Merging cputime/cputime (c5927fe [S390] cputime: add sparse checking and cl=
eanup)
Merging osd/linux-next (dde406e pnfs-obj: Support for RAID5 read-4-write in=
terface.)
Merging jc_docs/docs-next (5c050fb docs: update the development process doc=
ument)
Merging nommu/master (0ce790e Linux 2.6.39-rc1)
Merging trivial/for-next (67c50a7 qnx4fs: Use kmemdup rather than duplicati=
ng its implementation)
Merging audit/for-next (def5754 Audit: remove spaces from audit_log_d_path)
Merging pm/linux-next (00d255c PM: Fix indentation and remove extraneous wh=
itespaces in kernel/power/main.c)
Merging apm/for-next (73692d9 Merge branch 'for-linus' of git://git.kernel.=
org/pub/scm/linux/kernel/git/jikos/apm)
Merging fsnotify/for-next (ef9bf3b fanotify: only destroy a mark if both it=
s mask and its ignored_mask are cleared)
Merging irda/for-next (94d57c4 enic: Update MAINTAINERS)
Merging edac/linux_next (4d096ca MAINTAINERS: add an entry for Edac Sandy B=
ridge driver)
Merging edac-amd/for-next (1f6189e amd64_edac: Cleanup return type of amd64=
_determine_edac_cap())
Merging devicetree/devicetree/next (ae97159 of_mdio: Don't phy_scan_fixups(=
) twice)
Merging spi/spi/next (940ab88 drivercore: Add helper macro for platform_dri=
ver boilerplate)
Merging gpio/gpio/next (d92ef29 h8300: Move gpio.h to gpio-internal.h)
Merging tip/auto-latest (e79d72b Merge branch 'sched/core' into auto-latest)
Merging rcu/rcu/next (afe24b1 rcu: Move propagation of ->completed from rcu=
_start_gp() to rcu_report_qs_rsp())
Merging kmemleak/kmemleak (99781ba kmemleak: Add support for memory hotplug)
Merging kvm/kvm-updates/3.2 (a3e06bb KVM: emulate lapic tsc deadline timer =
for guest)
Merging oprofile/for-next (de346b6 Merge branch 'perf/core' into oprofile/m=
aster)
Merging xen/upstream/xen (ec8161f Merge branch 'upstream/microcode' into up=
stream/xen)
CONFLICT (content): Merge conflict in arch/x86/xen/Kconfig
Merging xen-two/linux-next (99cb2dd xen-gntalloc: signedness bug in add_gre=
fs())
Merging xen-pvhvm/linux-next (b056b6a xen: suspend: remove xen_hvm_suspend)
Merging percpu/for-next (bc499f9 percpu: rename pcpu_mem_alloc to pcpu_mem_=
zalloc)
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
Merging regmap/for-next (d91e8db regmap: Suppress noop writes in regmap_upd=
ate_bits())
Merging driver-core/driver-core-next (42b4d11 usb: dwc3: fix a warning)
$ git reset --hard HEAD^
Merging refs/next/20111118/driver-core
Merging tty/tty-next (161e773 UART: add CSR SiRFprimaII SoC on-chip uart dr=
ivers)
CONFLICT (content): Merge conflict in drivers/tty/tty_ldisc.c
CONFLICT (content): Merge conflict in drivers/tty/serial/Makefile
CONFLICT (content): Merge conflict in drivers/tty/serial/Kconfig
Merging usb/usb-next (3af5154 usb: Netlogic: Use CPU_XLR in place of NLM_XL=
R)
Merging staging/staging-next (cfcfc9e Linux 3.2-rc2)
Merging char-misc/char-misc-next (7f3379d misc: ad525x_dpot: Add support fo=
r SPI module device table matching)
Merging bkl-config/config (4ba8216 BKL: That's all, folks)
Merging tmem/tmem (665c1e6 mm: cleancache: Use __read_mostly as appropiate.)
CONFLICT (content): Merge conflict in mm/swapfile.c
Merging writeback/writeback-for-next (c37a78e fs: Make write(2) interruptib=
le by SIGKILL)
Merging arm-dt/devicetree/arm-next (ede338f dt: add documentation of ARM dt=
 boot interface)
Merging hwspinlock/linux-next (8b37fcf hwspinlock: add MAINTAINERS entries)
Merging pinctrl/for-next (fb1b0ee pinctrl: indicate GPIO direction on singl=
e GPIO request)
Merging moduleh/for-sfr (6aec187 drivers/media: video/a5k6aa is a module an=
d so needs module.h)
Merging kvmtool/master (e1b4024 kvm tools: Add event idx support to virtio-=
blk)
CONFLICT (content): Merge conflict in scripts/kconfig/Makefile
CONFLICT (content): Merge conflict in include/net/9p/9p.h
Merging scsi-post-merge/merge-base:master ()
$ git checkout akpm
Applying: vmscan: fix initial shrinker size handling
Applying: vmscan: use atomic-long for shrinker batching
Applying: net/netfilter/nf_conntrack_netlink.c: fix Oops on container destr=
oy
Applying: acerhdf: add support for Aspire 1410 BIOS v1.3314
Applying: acerhdf: add support for new hardware
Applying: acerhdf: lowered default temp fanon/fanoff values
Applying: arch/x86/platform/iris/iris.c: register a platform device and a p=
latform driver
Applying: x86: fix mmap random address range
Applying: arch/x86/kernel/e820.c: eliminate bubble sort from sanitize_e820_=
map
Applying: x86: rtc: don't register a platform RTC device for Intel MID plat=
forms
Applying: mrst: battery fixes
Applying: arch/x86/kernel/e820.c: quiet sparse noise about plain integer as=
 NULL pointer
Applying: arch/x86/kernel/ptrace.c: quiet sparse noise
Applying: arch/x86/mm/pageattr.c: quiet sparse noise; local functions shoul=
d be static
Applying: x86: tlb flush avoid superflous leave_mm()
Applying: x86: reduce clock calibration time during slave cpu startup
Applying: x86/paravirt: PTE updates in k(un)map_atomic need to be synchrono=
us, regardless of lazy_mmu mode
Applying: arch/arm/mach-ux500/mbox-db5500.c: world-writable sysfs fifo file
Applying: arm, exec: remove redundant set_fs(USER_DS)
Applying: drivers/edac/mpc85xx_edac.c: fix memory controller compatible for=
 edac
Applying: drivers/gpu/vga/vgaarb.c: add missing kfree
Applying: drm: avoid switching to text console if there is no panic timeout
Applying: hrtimers: Special-case zero length sleeps
Applying: ia64, exec: remove redundant set_fs(USER_DS)
Applying: ipc/mqueue: cleanup definition names and locations
Applying: ipc/mqueue: switch back to using non-max values on create
Applying: ipc/mqueue: enforce hard limits
Applying: ipc/mqueue: update maximums for the mqueue subsystem
Applying: ipc-mqueue-update-maximums-for-the-mqueue-subsystem-fix
Applying: ipc-mqueue-update-maximums-for-the-mqueue-subsystem-checkpatch-fi=
xes
Applying: debugobjects: be smarter about static objects
Applying: debugobjects: extend to assert that an object is initialized
Applying: kernel/timer.c: use debugobjects to catch deletion of uninitializ=
ed timers
Applying: ext4: use proper little-endian bitops
Applying: ocfs2: avoid unaligned access to dqc_bitmap
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
Applying: mm: add vm_area_add_early()
Applying: mm: migrate: one less atomic operation
Applying: mm: do not stall in synchronous compaction for THP allocations
Applying: mm-do-not-stall-in-synchronous-compaction-for-thp-allocations-v3
Applying: mm: avoid livelock on !__GFP_FS allocations
Applying: mm-avoid-livelock-on-__gfp_fs-allocations-fix
Applying: mm: reduce the amount of work done when updating min_free_kbytes
Applying: mm-reduce-the-amount-of-work-done-when-updating-min_free_kbytes-c=
heckpatch-fixes
Applying: thp: reduce khugepaged freezing latency
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
Applying: get_maintainers.pl: follow renames when looking up commit signers
Applying: checkpatch: update signature "might be better as" warning
Applying: checkpatch: prefer __printf over __attribute__((format(printf,...=
)))
Applying: crc32: optimize inner loop
Applying: epoll: limit paths
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
Applying: procfs: make proc_get_link to use dentry instead of inode
Applying: procfs: introduce the /proc/<pid>/map_files/ directory
Applying: procfs-introduce-the-proc-pid-map_files-directory-checkpatch-fixes
Applying: workqueue: make alloc_workqueue() take printf fmt and args for na=
me
Applying: workqueue-make-alloc_workqueue-take-printf-fmt-and-args-for-name-=
fix
Applying: cpumask: update setup_node_to_cpumask_map() comments
Applying: kdump: add missing RAM resource in crash_shrink_memory()
Applying: kdump: fix crash_kexec()/smp_send_stop() race in panic
Applying: kdump: Add udev events for memory online/offline
Applying: ipc/mqueue: simplify reading msgqueue limit
Applying: ipc/sem.c: alternatives to preempt_disable()
Applying: fs/direct-io.c: calculate fs_count correctly in get_more_blocks()
Applying: vfs: cache request_queue in struct block_device
Applying: dio: optimize cache misses in the submission path
Applying: dio-optimize-cache-misses-in-the-submission-path-v2-checkpatch-fi=
xes
Applying: dio: using prefetch requires including prefetch.h
Applying: ramoops: update parameters only after successful init
Merging akpm (c572818 ramoops: update parameters only after successful init)

--Signature=_Mon__21_Nov_2011_13_39_36_+1100_dSyeJB2+U71bPjYJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOybnoAAoJEECxmPOUX5FEzSsP/3eEEsLWx9WubkyNpBDgZcHN
+yd3Bt/u1FjjFVasfFPNIt7vzAFLj0NHF1QP7eObFwfv3zyKgwu2/hkOcCEImNcK
sZ+pXT/3CVQgKCyejFDgDwbMD6FQKoOhJoDPNutlexalvgr3oVL8AZ3xqY41eXRO
TvCK09ZzQEadWMLO0qWzZt0IAPuGPn4xw8fn03jJXCRZrTwDBxe53+67r20sm+rN
BbRSSwkCR23rEqGL0fQFuKO3a05hKUAGdZSAq23nm0PRZFRhkOWRdbsJM5dnEnVt
CqliOJk3TAQjufY/X+P0oW4t1OCrKqo/IJiD5ZTa6/SSKozk8h+Z+cQjWFQF8Dk8
sYXKJxVT45RclfFZH6ZujywenGm9MmFaESY+W793INFVGICPogFMe5jrGhiqA+2r
Z2GgpfU1GMnw/99WBuHGnCq9y7sLLIn0gAX2bD+bo3ePDt9BFyvsJXM43ktF8T9K
NfrCcqueWM4z6B0yD9FmVZy7Hn5M1aIUvBo6+BLlOBptN6bKjjI4vqob7V/7YQwd
HfTs/c7Trz1FcMmuHL76/T+gwmcPpTVUt2i3cyNozop47COPEdWvzDWumdqKk9uk
y+/V541cjpPJEMt0gkSngiXvYOh5rc21A55YnrQzWMlFg1n8q2s83e78NagtX8xm
iy8FC6Wu8zZ2/wZwDNmi
=Phxb
-----END PGP SIGNATURE-----

--Signature=_Mon__21_Nov_2011_13_39_36_+1100_dSyeJB2+U71bPjYJ--

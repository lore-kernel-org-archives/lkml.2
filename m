Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242Ab1KIC6g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 21:58:36 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:33370 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644Ab1KIC6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 21:58:33 -0500
Date: Wed, 9 Nov 2011 13:58:26 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Nov 9
Message-Id: <20111109135826.7f8270fb7151cf7939998942@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__9_Nov_2011_13_58_26_+1100_Na8MidMh./F8Z6HQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__9_Nov_2011_13_58_26_+1100_Na8MidMh./F8Z6HQ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

The linux-next tree on github is no longer being updated and will be
removed soon.

The patch is still absent from kernel.org.

Changes since 20111108:

The m68knommu tree lost 2 conflicts but gained more against the m68k tree.

The gfs2 tree lost its conflict.

The mmc tree gained a build failure so I used the version from
next-20111108.

The writeback tree lost its conflict.

I dropped a patch from the akpm tree that truned up elsewhere.

----------------------------------------------------------------------------

I have created today's linux-next tree at
git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
(patches at http://www.kernel.org/pub/linux/kernel/v2.6/next/ ).  If you
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
Merging origin/master (3b75462 Merge branch 'pm-fixes' of git://git.kernel.=
org/pub/scm/linux/kernel/git/rafael/linux-pm)
Merging fixes/master (3155521 Revert "hvc_console: display printk messages =
on console.")
Merging kbuild-current/rc-fixes (322a8b0 Linux 3.1-rc1)
Merging arm-current/fixes (5f300ac ARM: 7152/1: distclean: Remove generated=
 .dtb files)
Merging m68k-current/for-linus (2690e21 m68k/mac: Remove mac_irq_{en,dis}ab=
le() wrappers)
Merging powerpc-merge/merge (5ccf55d powerpc/kvm: Fix build failure with HV=
 KVM and CBE)
Merging 52xx-and-virtex-current/powerpc/merge (c49f878 dtc/powerpc: remove =
obsolete .gitignore entries)
Merging sparc/master (51ce185 sparc: Hook up process_vm_{readv,writev} sysc=
alls.)
Merging scsi-rc-fixes/master (3ee72ca Merge git://github.com/davem330/net)
Merging net/master (2bc8ca4 ipv4: Fix inetpeer expire time information)
Merging sound-current/for-linus (dcaaf9f ALSA: usb-audio - Fix the missing =
volume quirks at delayed init)
Merging pci-current/for-linus (fdbd3ce PCI: pciehp: Retrieve link speed aft=
er link is trained)
Merging wireless/master (cc438fc wl12xx: fix wl12xx_scan_sched_scan_ssid_li=
st() check that all given ssids are in filters)
Merging driver-core.current/driver-core-linus (1ea6b8f Linux 3.2-rc1)
Merging tty.current/tty-linus (1ea6b8f Linux 3.2-rc1)
Merging usb.current/usb-linus (1ea6b8f Linux 3.2-rc1)
Merging staging.current/staging-linus (1ea6b8f Linux 3.2-rc1)
Merging cpufreq-current/fixes (2f84dd7 autofs4: fix debug printk warning un=
covered by cleanup)
Merging input-current/for-linus (b42c9097 Input: i8042 - add HP Pavilion dv=
4s to 'notimeout' and 'nomux' blacklists)
Merging md-current/for-linus (399b35f md/raid5: abort an pending parity ope=
rations when array fails.)
Merging audit-current/for-linus (def5754 Audit: remove spaces from audit_lo=
g_d_path)
Merging crypto-current/master (0559dcf crypto: algapi - Fix build problem w=
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
Merging arm/for-next (8920b7a Merge branches 'fixes' and 'misc' into for-ne=
xt)
Merging arm-lpae/for-next (b382096 ARM: LPAE: Add the Kconfig entries)
Merging arm-soc/for-next (3155521 Revert "hvc_console: display printk messa=
ges on console.")
Merging at91/at91-next (bcdbf16 hw_random: add driver for atmel true hardwa=
re random number generator)
CONFLICT (content): Merge conflict in drivers/ata/pata_at91.c
CONFLICT (content): Merge conflict in arch/arm/mach-at91/board-sam9m10g45ek=
.c
CONFLICT (content): Merge conflict in arch/arm/mach-at91/board-sam9g20ek.c
CONFLICT (content): Merge conflict in arch/arm/mach-at91/board-rm9200dk.c
CONFLICT (content): Merge conflict in arch/arm/mach-at91/board-neocore926.c
CONFLICT (content): Merge conflict in arch/arm/mach-at91/board-afeb-9260v1.c
CONFLICT (content): Merge conflict in arch/arm/mach-at91/at91sam9g45.c
CONFLICT (content): Merge conflict in arch/arm/mach-at91/at91sam9260.c
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
Merging s5p/for-next (3783f85 Merge branch 'next-samsung-devel' into for-ne=
xt)
Merging tegra/for-next (80d0a76 Merge branches 'for-3.2/cleanup' and 'for-3=
.2/features' into for-next)
Merging xilinx/arm-next (b85a3ef ARM: Xilinx: Adding Xilinx board support)
Merging blackfin/for-linus (e114599 Blackfin: add serial TX IRQ in individu=
al platform resource)
Merging c6x/for-linux-next (2141355 C6X: MAINTAINERS)
Merging cris/for-next (ea78f5b CRIS: Update documentation)
Merging quilt/hexagon (8e116d1 Add extra arch overrides to asm-generic/chec=
ksum.h)
CONFLICT (add/add): Merge conflict in arch/hexagon/mm/strnlen_user.S
CONFLICT (add/add): Merge conflict in arch/hexagon/mm/pgalloc.c
CONFLICT (add/add): Merge conflict in arch/hexagon/mm/Makefile
CONFLICT (add/add): Merge conflict in arch/hexagon/lib/memset.S
CONFLICT (add/add): Merge conflict in arch/hexagon/kernel/vmlinux.lds.S
CONFLICT (add/add): Merge conflict in arch/hexagon/kernel/vm_vectors.S
CONFLICT (add/add): Merge conflict in arch/hexagon/kernel/vdso.c
CONFLICT (add/add): Merge conflict in arch/hexagon/kernel/kgdb.c
CONFLICT (add/add): Merge conflict in arch/hexagon/kernel/hexagon_ksyms.c
CONFLICT (add/add): Merge conflict in arch/hexagon/kernel/head.S
CONFLICT (add/add): Merge conflict in arch/hexagon/kernel/Makefile
CONFLICT (add/add): Merge conflict in arch/hexagon/include/asm/vdso.h
CONFLICT (add/add): Merge conflict in arch/hexagon/include/asm/timex.h
CONFLICT (add/add): Merge conflict in arch/hexagon/include/asm/Kbuild
CONFLICT (add/add): Merge conflict in arch/hexagon/Makefile
Merging ia64/next (0f6a1c0 Pull misc-3.2 into next branch)
Merging m68k/for-next (2690e21 m68k/mac: Remove mac_irq_{en,dis}able() wrap=
pers)
Merging m68knommu/for-next (8de5bbd m68k: make fp register stores consisten=
t for m68k and ColdFire)
CONFLICT (content): Merge conflict in arch/m68k/kernel/Makefile
CONFLICT (content): Merge conflict in arch/m68k/Kconfig
Merging microblaze/next (3155521 Revert "hvc_console: display printk messag=
es on console.")
Merging mips/mips-for-linux-next (3169b63 Merge branch 'fixes-for-linus' in=
to mips-for-linux-next)
Merging openrisc/for-upstream (b6fd41e Linux 3.1-rc6)
Merging parisc/for-next (fc99a91 futex: Use same lock set as lws calls)
Merging powerpc/next (96cc017 powerpc/p3060qds: Add support for P3060QDS bo=
ard)
Merging 4xx/next (9fcd768 powerpc/40x: Remove obsolete HCU4 board)
Merging 52xx-and-virtex/powerpc/next (c1395f4 dtc/powerpc: remove obsolete =
.gitignore entries)
Merging galak/next (96cc017 powerpc/p3060qds: Add support for P3060QDS boar=
d)
Merging s390/features (198b26a [S390] add support for physical memory > 4TB)
Merging sh/sh-latest (b9a3acf Merge branch 'sh/stable-updates' into sh-late=
st)
Merging rmobile/rmobile-latest (b58c580 Merge branch 'rmobile-fixes-for-lin=
us' into rmobile-latest)
Merging sparc-next/master (3ee72ca Merge git://github.com/davem330/net)
Merging tile/master (1583171 Merge branch 'for-linus' of git://github.com/c=
metcalf-tilera/linux-tile)
Merging unicore32/unicore32 (10967fd arch/unicore32: do not use EXTRA_AFLAG=
S or EXTRA_CFLAGS)
Merging xtensa/master (29aced6 xtensa: remove defining register numbers)
Merging ceph/for-next (3395734 libceph: fix double-free of page vector)
Merging cifs/master (ed6c038 CIFS: Add descriptions to the brlock cache fun=
ctions)
Merging configfs/linux-next (420118c configfs: Rework configfs_depend_item(=
) locking and make lockdep happy)
Merging ecryptfs/next (985ca0e ecryptfs: Make inode bdi consistent with sup=
erblock bdi)
Merging ext3/for_next (ed47a7d udf: Cleanup metadata flags handling)
Merging ext4/dev (5c8a0fb VFS: fix statfs() automounter semantics regressio=
n)
Merging fatfs/master (710d440 fat: fat16 support maximum 4GB file/vol size =
as WinXP or 7.)
Merging fuse/for-next (c2183d1 fuse: check size of FUSE_NOTIFY_INVAL_ENTRY =
message)
Merging gfs2/master (8765489 GFS2: More automated code analysis fixes)
Merging hfsplus/for-next (6596528 hfsplus: ensure bio requests are not smal=
ler than the hardware sectors)
Merging jfs/next (1c8007b jfs: flush journal completely before releasing me=
tadata inodes)
Merging logfs/master (51b3089 Merge branch 'master' of github.com:prasad-jo=
shi/logfs)
CONFLICT (content): Merge conflict in fs/logfs/file.c
Merging nfs/linux-next (a6f498a NFS: Fix a regression in the referral code)
Merging nfsd/nfsd-next (c7e8472 NFSD: Remove unnecessary whitespace)
Merging nilfs2/for-next (93ee7a9 Linux 3.1-rc2)
Merging ocfs2/linux-next (c849cc2 ocfs2: make direntry invalid when deletin=
g it)
CONFLICT (content): Merge conflict in fs/ocfs2/xattr.c
Merging omfs/for-next (976d167 Linux 3.1-rc9)
Merging squashfs/master (7657cac Squashfs: Add an option to set dev block s=
ize to 4K)
Merging v9fs/for-next (14211d0 9p: fix 9p.txt to advertise msize instead of=
 maxdata)
Merging ubifs/linux-next (7606f85 UBIFS: fix the dark space calculation)
Merging xfs/master (9e4c109 xfs: add AIL pushing tracepoints)
Merging vfs/for-next (206b1d0 Fix POSIX ACL permission check)
Merging vfs-scale/vfs-scale-working (32385c7 kernel: fix hlist_bl again)
Merging pci/linux-next (44258a5 PCI: Fix PRI and PASID consistency)
Merging hid/for-next (30307c6 Merge branch 'for-linus' of git://git.kernel.=
org/pub/scm/linux/kernel/git/jikos/hid)
Merging quilt/i2c (e415e35 i2c-algo-bit: Generate correct i2c address seque=
nce for 10-bit target)
Merging bjdooks-i2c/next-i2c (f8420b7 fixup merge)
CONFLICT (add/add): Merge conflict in drivers/i2c/busses/i2c-designware-pla=
tdrv.c
Merging quilt/jdelvare-hwmon (c861cd3 Merge branch 'next/devel2' of git://g=
it.linaro.org/people/arnd/arm-soc)
Merging hwmon-staging/hwmon-next (c5794cf hwmon: (w83627ehf) Better fix for=
 negative temperature values)
Merging quilt/kernel-doc (c3b92c8 Linux 3.1)
Merging docs/docs-move (5c24d8b Merge branch 'docs/docbook/drm' of git://gi=
thub.com/mfwitten/linux into docs-move)
Merging v4l-dvb/master (fce333c Merge branch 'poll-pwc' of /home/v4l/v4l/pa=
tchwork)
Merging kbuild/for-next (57b742f Merge branch 'kbuild/kbuild' into kbuild/f=
or-next)
Merging kconfig/for-next (eae1c36 Merge branch 'kconfig/for-linus-2' into k=
config/for-next)
Merging libata/NEXT (a0da191 pata_efar: fix register naming used in efar_se=
t_piomode())
Merging infiniband/for-next (042f36e IB/qib: Don't use schedule_work())
Merging acpi/next (efb9058 Merge branches 'acpi', 'idle', 'mrst-pmu' and 'p=
m-tools' into next)
Merging cpupowerutils/master (498ca79 cpupower: use man(1) when calling "cp=
upower help subcommand")
Merging ieee1394/for-next (a572e68 firewire: ohci: fix isochronous DMA sync=
hronization)
Merging ubi/linux-next (93ee7a9 Linux 3.1-rc2)
Merging dlm/next (c3b92c8 Linux 3.1)
Merging swiotlb/master (25b84fa swiotlb: Export io_tlb_nslabs as swiotlb_ns=
labs and use it.)
CONFLICT (content): Merge conflict in drivers/xen/swiotlb-xen.c
Merging ibft/master (f1b1e06 iscsi-ibft: Fix compile warning introduced by =
'iscsi_ibft: iscsi_ibft_find unused variable i')
Merging scsi/master (f7c9c6b [SCSI] Fix block queue and elevator memory lea=
k in scsi_alloc_sdev)
Merging target-updates/for-next (5bda90c target: use ->exectute_task for al=
l CDB emulation)
Merging target-merge/for-next-merge (e0d85e5 ib_srpt: Initial SRP Target me=
rge for v3.2-rc1)
Merging slave-dma/next (4598fc2 dmaengine: mid_dma: mask_peripheral_interru=
pt only when dmac is idle)
Merging async_tx/next (21ef4b8 dmaengine: use DEFINE_IDR for static initial=
ization)
Merging net-next/master (e56c57d net: rename sk_clone to sk_clone_lock)
Merging wireless-next/master (ae2772b mac80211: allow frame aggregation for=
 mesh)
Merging bluetooth/master (4c659c3 Bluetooth: Add address type fields to mgm=
t messages that need them)
CONFLICT (content): Merge conflict in net/bluetooth/mgmt.c
CONFLICT (content): Merge conflict in net/bluetooth/l2cap_sock.c
CONFLICT (content): Merge conflict in include/net/bluetooth/bluetooth.h
Merging mtd/master (e0d6511 Merge git://git.infradead.org/mtd-2.6)
Merging l2-mtd/master (c0af4d0 mtd: nand: scan 1st and 2nd page for Macroni=
x SLC)
Merging crypto/master (ea8bdfc crypto: user - Add dependency on NET)
Merging sound/for-next (89c20bc Merge branch 'fix/misc' into for-next)
Merging sound-asoc/for-next (4633fa4 Merge branch 'for-3.2' into for-3.3)
Merging cpufreq/next (5aace58 [CPUFREQ] ARM Exynos4210 PM/Suspend compatibi=
lity with different bootloaders)
Merging quilt/rr (05478c6 module,bug: Add TAINT_OOT_MODULE flag for modules=
 not built in-tree)
Merging input/next (7cf801c Input: ALPS - add documentation for protocol ve=
rsions 3 and 4)
Merging input-mt/next (02f8c6a Linux 3.0)
Merging lsm/for-next (ca05a99 capabilities: remain source compatible with 3=
2-bit raw legacy capability support.)
Merging block/for-next (30a4b71 Merge branch 'for-3.2/core' into for-next)
Merging quilt/device-mapper (94956ee Merge git://git.kernel.org/pub/scm/lin=
ux/kernel/git/davem/net)
Merging embedded/master (4744b43 embedded: fix vc_translate operator preced=
ence)
Merging firmware/master (6e03a20 firmware: speed up request_firmware(), v3)
Merging pcmcia/master (74411c0 smc91c92_cs.c: fix bogus compiler warning)
Merging battery/master (85b5fbf power_supply: Fix sysfs format warning)
Merging mmc/mmc-next (f164924 mmc: sd: Macro name cleanup for high speed dt=
r)
$ git reset --hard HEAD^
Merging refs/next/20111108/mmc
Merging kgdb/kgdb-next (880ba69 lib: rename pack_hex_byte() to hex_byte_pac=
k())
Merging slab/for-next (e24daf8 Merge branch 'slab/next' into for-next)
Merging uclinux/for-next (6e86841 Linux 2.6.27-rc1)
Merging md/for-next (e0b361a Merge branch 'block-3.1' into for-next)
CONFLICT (content): Merge conflict in drivers/md/linear.c
Merging mfd/for-next (b958f7a mfd: Fix missing abx500 header file updates)
Merging hdlc/hdlc-next (4a6908a Linux 2.6.28)
Merging drm/drm-next (1717c0e Revert "drm/ttm: add a way to bo_wait for eit=
her the last read or last write")
Merging fbdev/fbdev-next (b57287b video: platinumfb: Add __devexit_p at nec=
essary place)
Merging viafb/viafb-next (4ce36bb viafb: replace strict_strtoul to kstrto* =
and check return value)
Merging omap_dss2/for-next (3e28189 OMAPDSS: picodlp: add missing #include =
<linux/module.h>)
Merging regulator/for-next (60265e0 regulator: TPS65910: VDD1/2 voltage sel=
ector count)
Merging security/next (59df316 TOMOYO: Fix interactive judgment functionali=
ty.)
Merging selinux/master (ded5098 SELinux: skip file_name_trans_write() when =
policy downgraded.)
Merging lblnet/master (7e27d6e Linux 2.6.35-rc3)
Merging watchdog/linux-next (1ea6b8f Linux 3.2-rc1)
Merging bdev/master (feaf384 Merge branch 'for-linus' of git://git.kernel.d=
k/linux-2.6-block)
Merging dwmw2-iommu/master (c3b92c8 Linux 3.1)
Merging iommu/next (1abb4ba Merge branches 'amd/fixes', 'debug/dma-api', 'a=
rm/omap', 'arm/msm', 'core', 'iommu/fault-reporting' and 'api/iommu-ops-per=
-bus' into next)
Merging cputime/cputime (f611671 [S390] cputime: add sparse checking and cl=
eanup)
CONFLICT (content): Merge conflict in kernel/sched_stats.h
CONFLICT (content): Merge conflict in include/asm-generic/cputime.h
CONFLICT (content): Merge conflict in fs/proc/stat.c
Merging osd/linux-next (dde406e pnfs-obj: Support for RAID5 read-4-write in=
terface.)
Merging jc_docs/docs-next (5c050fb docs: update the development process doc=
ument)
Merging nommu/master (0ce790e Linux 2.6.39-rc1)
Merging trivial/for-next (830d7f5 Doc: 53c700: drop never defined (Kconfig)=
 macros)
Merging audit/for-next (def5754 Audit: remove spaces from audit_log_d_path)
Merging pm/linux-next (156acb1 PM / OPP: Use ERR_CAST instead of ERR_PTR(PT=
R_ERR()))
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
Merging tip/auto-latest (e471db8 Merge branch 'perf/core' into auto-latest)
CONFLICT (content): Merge conflict in drivers/char/random.c
CONFLICT (content): Merge conflict in arch/x86/kernel/cpu/amd.c
Merging rcu/rcu/next (afe24b1 rcu: Move propagation of ->completed from rcu=
_start_gp() to rcu_report_qs_rsp())
Merging kmemleak/kmemleak (cbc6e60 kmemleak: Handle percpu memory allocatio=
n)
Merging kvm/kvm-updates/3.2 (a3e06bb KVM: emulate lapic tsc deadline timer =
for guest)
Merging oprofile/for-next (de346b6 Merge branch 'perf/core' into oprofile/m=
aster)
Merging xen/upstream/xen (ec8161f Merge branch 'upstream/microcode' into up=
stream/xen)
CONFLICT (content): Merge conflict in arch/x86/xen/Kconfig
Merging xen-two/linux-next (3155521 Revert "hvc_console: display printk mes=
sages on console.")
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
Merging regmap/for-next (a084481 regmap: Prepare LZO cache for variable blo=
ck sizes)
Merging driver-core/driver-core-next (1ea6b8f Linux 3.2-rc1)
Merging tty/tty-next (1ea6b8f Linux 3.2-rc1)
Merging usb/usb-next (1ea6b8f Linux 3.2-rc1)
Merging staging/staging-next (1ea6b8f Linux 3.2-rc1)
Merging bkl-config/config (4ba8216 BKL: That's all, folks)
Merging tmem/tmem (665c1e6 mm: cleancache: Use __read_mostly as appropiate.)
CONFLICT (content): Merge conflict in mm/swapfile.c
Merging writeback/writeback-for-next (1ea6b8f Linux 3.2-rc1)
Merging arm-dt/devicetree/arm-next (ede338f dt: add documentation of ARM dt=
 boot interface)
Merging hwspinlock/linux-next (8b37fcf hwspinlock: add MAINTAINERS entries)
Merging pinctrl/for-next (ab872c8 pinctrl/sirf: fix sirfsoc_get_group_pins =
prototype)
CONFLICT (add/add): Merge conflict in drivers/pinctrl/core.c
CONFLICT (content): Merge conflict in arch/arm/mach-u300/core.c
CONFLICT (content): Merge conflict in arch/arm/mach-u300/Kconfig
Merging moduleh/for-sfr (6aec187 drivers/media: video/a5k6aa is a module an=
d so needs module.h)
Merging kvmtool/master (dd551ea kvm tools: Add missing 9p rename handler)
CONFLICT (content): Merge conflict in scripts/kconfig/Makefile
CONFLICT (content): Merge conflict in include/net/9p/9p.h
Merging scsi-post-merge/merge-base:master ()
$ git checkout akpm
Applying: drm: fix kconfig unmet dependency warning
Applying: net/netfilter/nf_conntrack_netlink.c: fix Oops on container destr=
oy
Applying: acerhdf: add support for Aspire 1410 BIOS v1.3314
Applying: arch/x86/platform/iris/iris.c: register a platform device and a p=
latform driver
Applying: x86: fix mmap random address range
Applying: arch/x86/kernel/e820.c: eliminate bubble sort from sanitize_e820_=
map
Applying: vrtc: change its year offset from 1960 to 1972
Applying: x86: rtc: don't register a platform RTC device for Intel MID plat=
forms
Applying: mrst: battery fixes
Applying: drivers/power/intel_mid_battery.c: fix build
Applying: x86,mrst: add mapping for bma023
Applying: arch/x86/kernel/e820.c: quiet sparse noise about plain integer as=
 NULL pointer
Applying: arch/x86/kernel/ptrace.c: quiet sparse noise
Applying: arch/x86/mm/pageattr.c: quiet sparse noise; local functions shoul=
d be static
Applying: x86: tlb flush avoid superflous leave_mm()
Applying: x86: reduce clock calibration time during slave cpu startup
Applying: x86-reduce-clock-calibration-time-during-slave-cpu-startup-fix
Applying: x86/paravirt: PTE updates in k(un)map_atomic need to be synchrono=
us, regardless of lazy_mmu mode
Applying: arch/arm/mach-ux500/mbox-db5500.c: world-writable sysfs fifo file
Applying: arm, exec: remove redundant set_fs(USER_DS)
Applying: audit: always follow va_copy() with va_end()
Applying: drivers/edac/mpc85xx_edac.c: fix memory controller compatible for=
 edac
Applying: devtmpfsd: fix task state handling
Applying: drivers/gpu/vga/vgaarb.c: add missing kfree
Applying: drm: avoid switching to text console if there is no panic timeout
Applying: hrtimers: Special-case zero length sleeps
Applying: ia64, exec: remove redundant set_fs(USER_DS)
Applying: brlocks/lglocks: clean up code
Applying: brlocks-lglocks-clean-up-code-checkpatch-fixes
Applying: ipc/mqueue: cleanup definition names and locations
Applying: ipc/mqueue: switch back to using non-max values on create
Applying: ipc/mqueue: enforce hard limits
Applying: ipc/mqueue: update maximums for the mqueue subsystem
Applying: ipc-mqueue-update-maximums-for-the-mqueue-subsystem-fix
Applying: ipc-mqueue-update-maximums-for-the-mqueue-subsystem-checkpatch-fi=
xes
Applying: unicore32, exec: remove redundant set_fs(USER_DS)
Applying: drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe.h: remove unused ma=
cro pr_fmt()
Applying: debugobjects: extend debugobjects to assert that an object is ini=
tialized
Applying: kernel/timer.c: use debugobjects to catch deletion of uninitializ=
ed timers
Applying: ext4: use proper little-endian bitops
Applying: ocfs2: avoid unaligned access to dqc_bitmap
Applying: parisc, exec: remove redundant set_fs(USER_DS)
Applying: drivers/firmware/dmi_scan.c: make dmi_name_in_vendors more focused
Applying: scsi: fix a header to include linux/types.h
Applying: drivers/scsi/megaraid.c: fix sparse warnings
Applying: drivers/scsi/aacraid/commctrl.c: fix mem leak in aac_send_raw_srb=
()
Applying: drivers/scsi/osd/osd_uld.c: use ida_simple_get() to handle id
Applying: drivers/scsi/sg.c: convert to kstrtoul_from_user()
Applying: drivers/scsi/mpt2sas/mpt2sas_base.c: fix mismatch in mpt2sas_base=
_hard_reset_handler() mutex lock-unlock
Applying: drivers/message/fusion/mptbase.c: ensure NUL-termination of MptCa=
llbacksName elements
Applying: loop: prevent information leak after failed read
Applying: loop: cleanup set_status interface
Applying: loop-cleanup-set_status-interface-checkpatch-fixes
Applying: cciss: auto engage SCSI mid layer at driver load time
Applying: block: avoid unnecessary plug list flush
Applying: block: add missed trace_block_plug
Applying: include/linux/bio.h: use a static inline function for bio_integri=
ty_clone()
Applying: bio: change some signed vars to unsigned
Applying: paride: fix potential information leak in pg_read()
Applying: slab: add taint flag outputting to debug paths.
Applying: slub: add taint flag outputting to debug paths
Applying: drivers/tty/serial/pch_uart.c: add console support
Applying: mm/page-writeback.c: make determine_dirtyable_memory static again
Applying: vmscan: fix initial shrinker size handling
Applying: vmscan: use atomic-long for shrinker batching
Applying: vmscan-use-atomic-long-for-shrinker-batching-fix
Applying: vmscan: promote shared file mapped pages
Applying: vmscan: activate executable pages after first usage
Applying: mm: add free_hot_cold_page_list() helper
Applying: mm: fix page-faults detection in swap-token logic
Applying: mm: add extra free kbytes tunable
Applying: mm-add-extra-free-kbytes-tunable-update
Applying: mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes
Applying: mm: add vm_area_add_early()
Applying: selinuxfs: remove custom hex_to_bin()
Applying: include/linux/security.h: fix security_inode_init_security() arg
Applying: hpet: factor timer allocate from open
Applying: intel_idle: fix API misuse
Applying: intel_idle: disable auto_demotion for hotplugged CPUs
Applying: lib/crc: add slice by 8 algorithm to crc32.c
Applying: lib-crc-add-slice-by-8-algorithm-to-crc32c-fix
Applying: epoll: limit paths
Applying: oprofilefs: handle zero-length writes
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
Applying: proc: force dcache drop on unauthorized access
Applying: kdump: fix crash_kexec()/smp_send_stop() race in panic
Applying: kdump: Add udev events for memory online/offline
Applying: ipc/sem.c: alternatives to preempt_disable()
Applying: fs/direct-io.c: calculate fs_count correctly in get_more_blocks()
Applying: vfs: cache request_queue in struct block_device
Applying: dio: optimize cache misses in the submission path
Applying: dio-optimize-cache-misses-in-the-submission-path-v2-checkpatch-fi=
xes
Applying: dio: using prefetch requires including prefetch.h
Applying: ramoops: update parameters only after successful init
Merging akpm (d2064ec ramoops: update parameters only after successful init)

--Signature=_Wed__9_Nov_2011_13_58_26_+1100_Na8MidMh./F8Z6HQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOuexSAAoJEECxmPOUX5FEV+IP/ROvuihUR0DxfdxqJqad28+O
KzOurpBntD5/MwQD6/yWJSRHFl/UcqUKDYoRGXQ3tX3Qso/MJlEfSoP/8aD69Ocd
7cGxF8AdkWURkoVpGDjatY2PpOWvsxeKSusL29H/dnQ1j6VlqQyk0EP85PfmHnh3
GoPvxePIJUJISjxWj7sBY9GeuIk4jDZUzvNhtfByGFxrnrL5RxLLibovcfqb/Z2M
YVjN1iughQdE3vuH+Xvq3TqLwyq5VJ3r4KzZqMSC6bny+KRacXffhAOf/aFxi39a
Msx58m7l1+7Hahydqc7psG37V57QJSwwPstoak+eyGHzy8CFRwGaU0Ipo5LbFvkF
BPwFek2R9O3rLvlc1CwuLzCdqqIHdAqiaFJGpoz4hNvaRN/XOjZTkRbFR/jpsyCA
CZYasD0HXtdBeXDryMNGgyZ8FY1DCUvxMRA3GecZtsu0s3TejsfI5zwNvTztlJ9y
gMlB1UcxHyuDYl1r5muUbM8ETJvyrMUOaw5X0tA/YozALSG9EAnS6V12/zSLrEax
DalhX3Yk79WBGomswhal2jPIA7RfrSq1SNZfLUgmwmXREoBfkzo9qHT5a29qUrvr
+MiaGm//F8bQ6JtDltWLXLdrCPPrxxpCIPRot7zPr8wS/DWeddY4YkgjydZfkmwO
MgHcE227AkTk7CS4bWG3
=nIji
-----END PGP SIGNATURE-----

--Signature=_Wed__9_Nov_2011_13_58_26_+1100_Na8MidMh./F8Z6HQ--

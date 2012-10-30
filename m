Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223Ab2J3GHS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 02:07:18 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:51564 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab2J3GHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 02:07:12 -0400
Date: Tue, 30 Oct 2012 17:07:04 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <linux-next@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Oct 30
Message-Id: <20121030170704.2472d957a16bee0ecd2b430d@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__30_Oct_2012_17_07_04_+1100_rTV8EgRNQRQWuQ4m"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__30_Oct_2012_17_07_04_+1100_rTV8EgRNQRQWuQ4m
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20121029:

The m68knommu tree lost its conflicts.

The v4l-dvb tree still had its build failure so I used the version from
next-20121026.

The sound-asoc tree lost its build failure.

The usb tree lost its conflict.

The staging tree lost its conflict.

The samsung tree gained a conflict against the pinctrl treee.

The clk tree gained a conflict against the arm-soc tree.

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
CONFIG_PROFILE_ALL_BRANCHES - this fails its final link) and i386, sparc,
sparc64 and arm defconfig. These builds also have
CONFIG_ENABLE_WARN_DEPRECATED, CONFIG_ENABLE_MUST_CHECK and
CONFIG_DEBUG_INFO disabled when necessary.

Below is a summary of the state of the merge.

We are up to 207 trees (counting Linus' and 27 trees of patches pending
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
Merging origin/master (35fd3dc Merge branch 'for-linus' of git://git.kernel=
.org/pub/scm/linux/kernel/git/sage/ceph-client)
Merging fixes/master (12250d8 Merge branch 'i2c-embedded/for-next' of git:/=
/git.pengutronix.de/git/wsa/linux)
Merging kbuild-current/rc-fixes (bad9955 menuconfig: Replace CIRCLEQ by lis=
t_head-style lists.)
Merging arm-current/fixes (b43b1ff Merge tag 'fixes-for-rmk' of git://git.k=
ernel.org/pub/scm/linux/kernel/git/arm/arm-soc into fixes)
Merging m68k-current/for-linus (8a745ee m68k: Wire up kcmp)
Merging powerpc-merge/merge (83dac59 cpuidle/powerpc: Fix snooze state prob=
lem in the cpuidle design on pseries.)
Merging sparc/master (f7e8d9f qlogicpti: Fix build warning.)
Merging net/master (e657e07 Merge git://git.kernel.org/pub/scm/linux/kernel=
/git/davem/net)
Merging sound-current/for-linus (1693849 Merge tag 'asoc-3.7' of git://git.=
kernel.org/pub/scm/linux/kernel/git/broonie/sound into for-linus)
Merging pci-current/for-linus (0ff9514 PCI: Don't print anything while deco=
ding is disabled)
Merging wireless/master (8c6e309 ath9k: fix stale pointers potentially caus=
ing access to free'd skbs)
Merging driver-core.current/driver-core-linus (8f0d816 Linux 3.7-rc3)
Merging tty.current/tty-linus (8f0d816 Linux 3.7-rc3)
Merging usb.current/usb-linus (8f0d816 Linux 3.7-rc3)
Merging staging.current/staging-linus (8f0d816 Linux 3.7-rc3)
Merging char-misc.current/char-misc-linus (8f0d816 Linux 3.7-rc3)
Merging input-current/for-linus (88fd449 Input: wacom - add INPUT_PROP_DIRE=
CT flag to Cintiq 24HD)
Merging md-current/for-linus (72f36d5 md: refine reporting of resync/reshap=
e delays.)
Merging audit-current/for-linus (c158a35 audit: no leading space in audit_l=
og_d_path prefix)
Merging crypto-current/master (9efade1 crypto: cryptd - disable softirqs in=
 cryptd_queue_worker to prevent data corruption)
Merging ide/master (9974e43 ide: fix generic_ide_suspend/resume Oops)
Merging dwmw2/master (244dc4e Merge git://git.infradead.org/users/dwmw2/ran=
dom-2.6)
Merging sh-current/sh-fixes-for-linus (4403310 SH: Convert out[bwl] macros =
to inline functions)
Merging irqdomain-current/irqdomain/merge (15e06bf irqdomain: Fix debugfs f=
ormatting)
Merging devicetree-current/devicetree/merge (4e8383b of: release node fix f=
or of_parse_phandle_with_args)
Merging spi-current/spi/merge (d1c185b of/spi: Fix SPI module loading by us=
ing proper "spi:" modalias prefixes.)
Merging gpio-current/gpio/merge (96b7064 gpio/tca6424: merge I2C transactio=
ns, remove cast)
Merging asm-generic/master (9b04ebd asm-generic/io.h: remove asm/cacheflush=
.h include)
Merging arm/for-next (4a83d2e Merge remote-tracking branch 'wildea/asids' i=
nto for-next)
Merging arm-perf/for-next/perf (b481680 Merge branch 'hw-breakpoint' into f=
or-next/perf)
Merging davinci/davinci-next (fe0d422 Linux 3.0-rc6)
Merging xilinx/arm-next (f580077 zynq: move static peripheral mappings)
Merging arm64/upstream (1e4097b arm64: Make the user fault reporting more s=
pecific)
Merging blackfin/for-linus (9d84601 Blackfin: dpmc: use module_platform_dri=
ver macro)
Merging c6x/for-linux-next (fbdd63d UAPI: (Scripted) Disintegrate arch/c6x/=
include/asm)
Merging cris/for-next (eacb25c UAPI: Fix up empty files in arch/cris/)
Merging hexagon/linux-next (e1858b2 Hexagon: Copyright marking changes)
Merging ia64/next (d536e0d Merge tag 'disintegrate-ia64-20121009' of git://=
git.infradead.org/users/dhowells/linux-headers into next)
Merging m68k/for-next (f82735d m68k: Use PTR_RET rather than if(IS_ERR(...)=
) + PTR_ERR)
Merging m68knommu/for-next (6762976 m68knommu: merge ColdFire 5249 and 525x=
 definitions)
Applying: m68k: fix up for UAPI changes
Merging microblaze/next (1883baa UAPI: (Scripted) Disintegrate arch/microbl=
aze/include/asm)
Merging mips/mips-for-linux-next (1996e38 MIPS: Octeon: Simplify code by as=
suming CONFIG_64BIT is always set.)
Merging openrisc/for-upstream (634bd40 openrisc: use kbuild.h instead of de=
fining macros in asm-offset.c)
Merging parisc/for-next (559fd14 Merge tag 'disintegrate-parisc-20121016' i=
nto for-next)
Merging powerpc/next (83dac59 cpuidle/powerpc: Fix snooze state problem in =
the cpuidle design on pseries.)
Merging 4xx/next (2074b1d powerpc: Fix irq distribution)
Merging mpc5xxx/next (fa9b24a powerpc/mpc5200: move lpbfifo node and fix it=
s interrupt property)
Merging galak/next (10bfa76 driver/mtd:IFC NAND:Initialise internal SRAM be=
fore any write)
Merging s390/features (2845a77 s390/crypto: Don't panic after crypto instru=
ction failures)
Merging sh/sh-latest (0dd4d5c sh: Fix up more fallout from pointless ARM __=
iomem churn.)
Merging sparc-next/master (43c422e apparmor: fix apparmor OOPS in audit_log=
_untrustedstring+0x1c/0x40)
Merging tile/master (ddffeb8 Linux 3.7-rc1)
Merging unicore32/unicore32 (200c77a arch/unicore32: remove CONFIG_EXPERIME=
NTAL)
Merging xtensa/for_next (dc241f2 xtensa: switch to generic sys_execve())
Merging btrfs/next (c37b2b6 Btrfs: do not bug when we fail to commit the tr=
ansaction)
Merging ceph/master (3515297 rbd: activate v2 image support)
Merging cifs/for-next (f51de01 cifs: extra sanity checking for cifs.idmap k=
eys)
Merging configfs/linux-next (b930c26 Merge branch 'for-linus' of git://git.=
kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (0d7614f Linux 3.6-rc1)
Merging ext3/for_next (6c29c50 quota: Silence warning about PRJQUOTA not be=
ing handled in need_print_warning())
Merging ext4/dev (5de35e8 ext4: Avoid underflow in ext4_trim_fs())
Merging fuse/for-next (c7a3f5e fuse: Move CUSE Kconfig entry from fs/Kconfi=
g into fs/fuse/Kconfig)
Merging gfs2/master (a86888e GFS2: Rename glops go_xmote_th to go_sync)
Merging jfs/jfs-next (4e7a4b0 jfs: Fix FITRIM argument handling)
Merging logfs/master (ab2ec19 logfs: fix possible memory leak in logfs_mtd_=
can_write_buf())
Merging nfs/linux-next (1d02313 NFSv4.1: Simplify the sequence setup)
Merging nfsd/nfsd-next (ddffeb8 Linux 3.7-rc1)
Merging ocfs2/linux-next (4538df6 ocfs2: Don't spam on -EDQUOT.)
Merging omfs/for-next (976d167 Linux 3.1-rc9)
Merging squashfs/master (4b0180a Squashfs: add mount time sanity check for =
block_size and block_log match)
Merging v9fs/for-next (552aad0 9P: Fix race between p9_write_work() and p9_=
fd_request())
Merging ubifs/linux-next (a28ad42 UBIFS: fix mounting problems after power =
cuts)
Merging xfs/for-next (e04426b xfs: move allocation stack switch up to xfs_b=
mapi_allocate)
Merging vfs/for-next (a736427 missing const in alpha callers of do_mount())
Merging pci/next (6f0c058 Linux 3.7-rc2)
Merging hid/for-next (5277e97 HID: roccat: allow readout of koneplus sensor=
 register data)
Merging quilt/i2c (71af1ef i2c: Mention functionality flags in SMBus protoc=
ol documentation)
Merging i2c-embedded/i2c-embedded/for-next (62885f5 MXS: Implement DMA supp=
ort into mxs-i2c)
Merging quilt/jdelvare-hwmon (1066e41 hwmon (w83627hf) Don't touch nonexist=
ent I2C address registers)
Merging hwmon-staging/hwmon-next (3d5d7f3 hwmon: DA9055 HWMON driver)
Merging v4l-dvb/master (ac5ce7c Merge /home/v4l/v4l/patchwork)
$ git reset --hard HEAD^
Merging refs/next/20121026/v4l-dvb
Merging kbuild/for-next (c582d2a Merge branch 'kbuild/rc-fixes' into kbuild=
/for-next)
Merging kconfig/for-next (4eae518 localmodconfig: Fix localyesconfig to set=
 to 'y' not 'm')
Merging libata/NEXT (13b7408 sata_mv: Fix warnings when no PCI)
Merging infiniband/for-next (1e3474d Merge branches 'cxgb4' and 'mlx4' into=
 for-next)
Merging pstore/master (80c9d03 pstore: Avoid recursive spinlocks in the oop=
s_in_progress case)
Merging acpi/next (d1d4a81 Merge branches 'fixes-for-37', 'ec' and 'thermal=
' into release)
Merging cpuidle/cpuidle-next (3cf7997 acpi: intel_idle : break dependency b=
etween modules)
CONFLICT (content): Merge conflict in include/linux/cpuidle.h
CONFLICT (add/add): Merge conflict in drivers/cpuidle/coupled.c
Merging cpupowerutils/master (f166033 cpupower tools: add install target to=
 the debug tools' makefiles)
Merging thermal/next (a180acf ACPI video: Ignore errors after _DOD evaluati=
on.)
Merging ieee1394/for-next (790198f firewire: cdev: fix user memory corrupti=
on (i386 userland on amd64 kernel))
Merging ubi/linux-next (6a059ab UBI: use list_move_tail instead of list_del=
/list_add_tail)
Merging dlm/next (2b75bc9 dlm: check the maximum size of a request from use=
r)
Merging scsi/for-next (5c1b10a [SCSI] storvsc: Account for in-transit packe=
ts in the RESET path)
Merging target-updates/for-next (a9bb162 target: remove ->get_device_rev)
Merging target-merge/for-next-merge (6f0c058 Linux 3.7-rc2)
Merging ibft/linux-next (935a9fe ibft: Fix finding IBFT ACPI table on UEFI)
Merging isci/all (6734092 isci: add a couple __iomem annotations)
Merging slave-dma/next (d51e88b dma: Convert dev_printk(KERN_<LEVEL> to dev=
_<level>()
Merging dmaengine/next (a2bd114 netdma: adding alignment check for NETDMA o=
ps)
Merging net-next/master (a932657 net: sierra: shut up sparse restricted typ=
e warnings)
Merging wireless-next/master (ab3d59d Merge branch 'master' of git://git.ke=
rnel.org/pub/scm/linux/kernel/git/linville/wireless)
Merging bluetooth/master (a11124c Bluetooth: Add put(hcon) when deleting hc=
han)
Merging mtd/master (5a6ea4a mtd: ofpart: Fix incorrect NULL check in parse_=
ofoldpart_partitions())
Merging l2-mtd/master (2c5e1925 mtd: mtd_oobtest: printk -> pr_{info,err,cr=
it})
Merging crypto/master (3200da8 crypto: tegra - fix missing unlock on error =
case)
Merging drm/drm-next (1f31c69 Merge branch 'drm-intel-fixes' of git://peopl=
e.freedesktop.org/~danvet/drm-intel into drm-next)
Merging sound/for-next (4ee3bff ALSA: Convert dev_printk(KERN_<LEVEL> to de=
v_<level>()
Merging sound-asoc/for-next (1003470 Merge branches 'fix/omap', 'fix/ux500'=
, 'fix/wm8994', 'topic/ak4104', 'topic/arizona', 'topic/atmel', 'topic/cs42=
71', 'topic/da9055', 'topic/davinci', 'topic/fsi', 'topic/fsl', 'topic/jack=
', 'topic/jz4740', 'topic/samsung', 'topic/si476x', 'topic/wm2200', 'topic/=
wm8750', 'topic/wm8770', 'topic/wm8971' and 'topic/wm8994' of git://git.ker=
nel.org/pub/scm/linux/kernel/git/broonie/sound into asoc-next)
Merging modules/modules-next (29183bf Merge branch 'module-signing-fixes' i=
nto modules-next)
Merging virtio/virtio-next (929ce32e virtio_console: Use kmalloc instead of=
 kzalloc)
Merging input/next (a6e8c0a Input: qt2160 - fix qt2160_write() implementati=
on)
Merging input-mt/for-next (6f0c058 Linux 3.7-rc2)
Merging cgroup/for-next (d20e4c5 Merge branch 'cgroup-destroy-updates' into=
 for-next)
Merging block/for-next (454832b Merge branch 'for-3.7/drivers' into for-nex=
t)
CONFLICT (content): Merge conflict in init/Kconfig
Merging quilt/device-mapper (cee3685 track_chunk is always called with inte=
rrupts enabled. Consequently, we do not need to save and restore interrupt =
state in "flags" variable. This patch changes spin_lock_irqsave to spin_loc=
k_irq and spin_unlock_irqrestore to spin_unlock_irq.)
Merging embedded/master (4744b43 embedded: fix vc_translate operator preced=
ence)
Merging firmware/master (6e03a20 firmware: speed up request_firmware(), v3)
Merging pcmcia/master (80af9e6 pcmcia at91_cf: fix raw gpio number usage)
Merging mmc/mmc-next (bd40cb4 mmc: fix sdhci-dove probe/removal)
Merging kgdb/kgdb-next (58bcdf6 tty/console: fix warnings in drivers/tty/se=
rial/kgdboc.c)
Merging slab/for-next (d75f461 Merge branch 'slab/next' into for-next)
Merging uclinux/for-next (ddffeb8 Linux 3.7-rc1)
Merging md/for-next (8814c65 md/raid5: add blktrace calls)
Merging mfd/for-next (8f0d816 Linux 3.7-rc3)
Merging battery/master (18766f0 Merge with upstream to accommodate with MFD=
 changes)
Merging fbdev/fbdev-next (cd9d6f1 gbefb: fix compile error)
Merging viafb/viafb-next (838ac78 viafb: avoid refresh and mode lookup in s=
et_par)
Merging omap_dss2/for-next (13b1ba7 OMAPDSS: add missing include for string=
.h)
Merging regulator/for-next (7ded0f9 Merge remote-tracking branches 'regulat=
or/fix/gpio', 'regulator/fix/put', 'regulator/topic/gpio', 'regulator/topic=
/lp8788', 'regulator/topic/max77686', 'regulator/topic/tps51632', 'regulato=
r/topic/tps65910' and 'regulator/topic/vexpress' into regulator-next)
Merging security/next (61d335d Merge branch 'security-next-keys' of git://g=
it.kernel.org/pub/scm/linux/kernel/git/dhowells/security-keys into next-que=
ue)
CONFLICT (content): Merge conflict in security/keys/process_keys.c
CONFLICT (content): Merge conflict in security/keys/keyring.c
CONFLICT (content): Merge conflict in security/keys/keyctl.c
CONFLICT (content): Merge conflict in net/dns_resolver/dns_key.c
CONFLICT (content): Merge conflict in fs/cifs/cifsacl.c
Merging selinux/master (c2d7b24 Merge tag 'v3.4' into 20120409)
Merging lblnet/master (7e27d6e Linux 2.6.35-rc3)
Merging watchdog/master (58ddfed Merge branch 'master' of ../linux-watchdog)
Merging dwmw2-iommu/master (c3b92c8 Linux 3.1)
Merging iommu/next (f74b527 Merge branches 'iommu/fixes', 'dma-debug' and '=
x86/amd' into next)
Merging vfio/next (12250d8 Merge branch 'i2c-embedded/for-next' of git://gi=
t.pengutronix.de/git/wsa/linux)
Merging osd/linux-next (b6755ff osduld: Add osdname & systemid sysfs at scs=
i_osd class)
Merging jc_docs/docs-next (5c050fb docs: update the development process doc=
ument)
Merging trivial/for-next (83f0d77 md: Fix typo in drivers/md)
Merging audit/for-next (dcd6c92 Linux 3.3-rc1)
Merging pm/linux-next (e083feb Merge branch 'acpi-next' into linux-next)
Merging apm/for-next (fb9d78a Merge branch 'for-linus' of git://git.kernel.=
org/pub/scm/linux/kernel/git/jikos/apm)
Merging fsnotify/for-next (1aec9c0 inotify: automatically restart syscalls)
CONFLICT (content): Merge conflict in kernel/audit_tree.c
Merging edac/linux_next (5e75cbb Merge branch 'devel' into next)
Merging edac-amd/for-next (a8373ec EDAC: Handle error path in edac_mc_sysfs=
_init() properly)
Merging devicetree/devicetree/next (efd68e7 devicetree: add helper inline f=
or retrieving a node's full name)
Merging dt-rh/for-next (2066306 arm: l2cc: doc: fix device tree example typ=
o)
Merging spi/spi/next (d8e328b spi: Add "spi:" prefix to modalias attribute =
of spi devices)
Merging spi-mb/spi-next (32111ab Merge tag 'spi-linus' into spi-next)
Merging tip/auto-latest (4e3859b Merge branch 'numa/core')
Merging rcu/rcu/next (495f365 Merge branches 'doc.2012.10.23c', 'fixes.2012=
.10.27a', 'srcu.2012.10.27a', 'stall.2012.10.24a', 'tracing.2012.10.27a' an=
d 'idle.2012.10.24a' into HEAD)
Merging cputime/cputime (c3e0ef9 [S390] fix cputime overflow in uptime_proc=
_show)
Merging uprobes/for-next (0326f5a uprobes/core: Handle breakpoint and singl=
estep exceptions)
Merging kvm/linux-next (8ca40a7 KVM: Take kvm instead of vcpu to mmu_notifi=
er_retry)
CONFLICT (content): Merge conflict in arch/powerpc/include/asm/kvm_para.h
CONFLICT (content): Merge conflict in arch/powerpc/include/asm/Kbuild
Applying: KVM: PPC: fix fallout from UAPI changes
Merging kvm-ppc/kvm-ppc-next (4c3d168 KVM: PPC: Move mtspr/mfspr emulation =
into own functions)
Merging oprofile/for-next (4400910 oprofile, x86: Fix wrapping bug in op_x8=
6_get_ctrl())
Merging xen/upstream/xen (af3a3ab Merge git://git.kernel.org/pub/scm/linux/=
kernel/git/steve/gfs2-3.0-fixes)
Merging xen-two/linux-next (ad50261 Merge branch 'stable/for-linus-3.7' int=
o linux-next)
Merging xen-pvhvm/linux-next (b056b6a xen: suspend: remove xen_hvm_suspend)
Merging percpu/for-next (b4916cb percpu: make pcpu_free_chunk() use pcpu_me=
m_free() instead of kfree())
Merging workqueues/for-next (b401057 Merge branch 'for-3.8' into for-next)
Merging drivers-x86/linux-next (455f38c eeepc-laptop: fix device reference =
count leakage in eeepc_rfkill_hotplug())
Merging hwpoison/hwpoison (46e387b Merge branch 'hwpoison-hugepages' into h=
wpoison)
Merging sysctl/master (4e474a0 sysctl: protect poll() in entries that may g=
o away)
Merging regmap/for-next (97f99c4 Merge tag 'regmap-fix-mmio' into regmap-ne=
xt)
Merging hsi/for-next (43139a6 HSI: hsi_char: Update ioctl-number.txt)
Merging leds/for-next (1d4badc leds: ledtrig-gpio: replace strict_strtoul()=
 with kstrtoul())
Merging driver-core/driver-core-next (94b086b Merge 3.7-rc3 into driver-cor=
e-next)
Merging tty/tty-next (ca364d8 Merge 3.7-rc3 into tty-next)
Merging usb/usb-next (b472b8e Merge 3.7-rc3 into usb-next.)
Merging staging/staging-next (1ed1b3d staging: comedi: amplc_pci230: use au=
to_attach() hook)
Merging char-misc/char-misc-next (e64de3b Merge 3.7-rc3 into char-misc-next)
Merging tmem/linux-next (a728d5e Merge commit 'v3.6-rc6' into linux-next)
Merging writeback/writeback-for-next (2f60d62 CPU hotplug, writeback: Don't=
 call writeback_set_ratelimit() too often during hotplug)
Merging arm-dt/devicetree/arm-next (ede338f dt: add documentation of ARM dt=
 boot interface)
Merging hwspinlock/linux-next (8b37fcf hwspinlock: add MAINTAINERS entries)
Merging pinctrl/for-next (07bc03b Merge branch 'nomadik' into for-next)
Merging vhost/linux-next (e0953c8 tun: experimental zero copy tx support)
CONFLICT (content): Merge conflict in drivers/net/tun.c
Merging memblock/memblock-kill-early_node_map (7bd0b0f memblock: Reimplemen=
t memblock allocation using reverse free area iterator)
Merging remoteproc/for-next (6f0c058 Linux 3.7-rc2)
Merging irqdomain/irqdomain/next (f5a1ad0 irqdomain: Improve diagnostics wh=
en a domain mapping fails)
Merging gpio/gpio/next (ddf343f Merge branch 'for-linus' of git://git.kerne=
l.org/pub/scm/linux/kernel/git/s390/linux)
Merging gpio-lw/for-next (3121424 Merge branch 'devel' into for-next)
Merging arm-soc/for-next (be792b9 Merge branch 'next/smp' into for-next)
CONFLICT (content): Merge conflict in arch/arm/mach-ux500/cpu-db8500.c
CONFLICT (content): Merge conflict in arch/arm/Kconfig
Merging bcm2835/for-next (d7f292e Merge branch 'for-3.8/defconfig' into for=
-next)
Merging cortex/for-next (77a3018 Cortex-M3: Add support for exception handl=
ing)
Merging ep93xx/ep93xx-for-next (fab1f74 Merge branch 'ep93xx-fixes' into ep=
93xx-for-next)
Merging ixp4xx/next (b94740b IXP4xx: use __iomem for MMIO)
Merging msm/for-next (a0d271c Linux 3.6)
Merging renesas/next (33e6bc3 Merge branches 'heads/fixes', 'heads/defconfi=
g' and 'heads/boards' into next)
Merging samsung/for-next (f789f1e Merge branch 'next/board-samsung' into fo=
r-next)
CONFLICT (content): Merge conflict in arch/arm/boot/dts/exynos4210.dtsi
Merging tegra/for-next (d0c4f64 Merge branch 'for-3.8/defconfig' into for-n=
ext)
Merging kvmtool/master (58bd23d kvm tools: Fix reported RTC century and yea=
r)
Merging dma-mapping/dma-mapping-next (8f0d816 Linux 3.7-rc3)
Merging pwm/for-next (85f8879 pwm: dt: Fix description of second PWM cell)
Merging dma-buf/for-next (ba42051 dma-buf: might_sleep() in dma_buf_unmap_a=
ttachment())
Merging userns/for-next (e9069f4 btrfs: Fix compilation with user namespace=
 support enabled)
Merging ktest/for-next (95f5783 ktest: Fix ELSE IF statements)
Merging signal/for-next (d8e1d84 Merge branch 'arch-powerpc' into for-next)
CONFLICT (content): Merge conflict in arch/sparc/kernel/sys_sparc_64.c
Merging clk/clk-next (05e3659 clk: Common clocks implementation for Versati=
le Express)
CONFLICT (content): Merge conflict in arch/arm/include/asm/hardware/sp810.h
Merging random/dev (c5c1244 random: fix debug format strings)
Merging lzo-update/lzo-update (ba32bf9 lib/lzo: Do not leak implementation =
details in lzo1x_1_compress())
Merging drop-experimental/linux-next (d392c7a tools/lguest: remove depends =
on CONFIG_EXPERIMENTAL)
Merging scsi-post-merge/merge-base:master ()
Merging akpm-current/current (417b23b revert "epoll: support for disabling =
items, and a self-test app")
CONFLICT (modify/delete): tools/testing/selftests/epoll/test_epoll.c delete=
d in akpm-current/current and modified in HEAD. Version HEAD of tools/testi=
ng/selftests/epoll/test_epoll.c left in tree.
$ git rm -f tools/testing/selftests/epoll/test_epoll.c
$ git checkout akpm
Applying: mm: vmscan: scale number of pages reclaimed by reclaim/compaction=
 only in direct reclaim
Applying: proc: check vma->vm_file before dereferencing
Applying: memstick: remove unused field from state struct
Applying: memstick: ms_block: fix compile issue
Applying: memstick: use after free in msb_disk_release()
Applying: memstick: memory leak on error in msb_ftl_scan()
Applying: CRIS: Fix I/O macros
Applying: selinux: fix sel_netnode_insert() suspicious rcu dereference
Applying: vfs: d_obtain_alias() needs to use "/" as default name.
Applying: fs/block_dev.c: page cache wrongly left invalidated after revalid=
ate_disk()
Applying: x86 cpu_hotplug: unmap cpu2node when the cpu is hotremoved
Applying: cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved-fix
Applying: acpi_memhotplug.c: fix memory leak when memory device is unbound =
from the module acpi_memhotplug
Applying: acpi_memhotplug.c: free memory device if acpi_memory_enable_devic=
e() failed
Applying: acpi_memhotplug.c: remove memory info from list before freeing it
Applying: acpi_memhotplug.c: don't allow to eject the memory device if it i=
s being used
Applying: acpi_memhotplug.c: bind the memory device when the driver is bein=
g loaded
Applying: acpi_memhotplug.c: auto bind the memory device which is hotplugge=
d before the driver is loaded
Applying: arch/x86/platform/iris/iris.c: register a platform device and a p=
latform driver
Applying: x86 numa: don't check if node is NUMA_NO_NODE
Applying: arch/x86/tools/insn_sanity.c: identify source of messages
Applying: arch/x86/platform/uv: fix incorrect tlb flush all issue
Applying: olpc: fix olpc-xo1-sci.c build errors
Applying: fs/debugsfs: remove unnecessary inode->i_private initialization
Applying: pcmcia: move unbind/rebind into dev_pm_ops.complete
Applying: drm/i915: optimize DIV_ROUND_CLOSEST() call
Applying: timeconst.pl: remove deprecated defined(@array)
Applying: time: don't inline EXPORT_SYMBOL functions
Applying: fs/pstore/ram.c: fix up section annotations
Applying: h8300: select generic atomic64_t support
Applying: drivers/message/fusion/mptscsih.c: missing break
Applying: cciss: cleanup bitops usage
Applying: cciss: use check_signature()
Applying: block: store partition_meta_info.uuid as a string
Applying: init: reduce PARTUUID min length to 1 from 36
Applying: block: partition: msdos: provide UUIDs for partitions
Applying: drbd: use copy_highpage
Applying: vfs: increment iversion when a file is truncated
Applying: fs: change return values from -EACCES to -EPERM
Applying: fs/block_dev.c: no need to check inode->i_bdev in bd_forget()
Applying: mm/page_alloc.c: remove duplicate check
Applying: writeback: remove nr_pages_dirtied arg from balance_dirty_pages_r=
atelimited_nr()
Applying: mm: show migration types in show_mem
Applying: memory hotplug: suppress "Device memoryX does not have a release(=
) function" warning
Applying: memory hotplug: suppress "Device nodeX does not have a release() =
function" warning
Applying: mm, memcg: make mem_cgroup_out_of_memory() static
Applying: mm: use IS_ENABLED(CONFIG_NUMA) instead of NUMA_BUILD
Applying: mm: use IS_ENABLED(CONFIG_COMPACTION) instead of COMPACTION_BUILD
Applying: thp: clean up __collapse_huge_page_isolate
Applying: thp-clean-up-__collapse_huge_page_isolate v2
Applying: mm: introduce mm_find_pmd()
Applying: thp: introduce hugepage_vma_check()
Applying: thp: cleanup: introduce mk_huge_pmd()
Applying: memory-hotplug: skip HWPoisoned page when offlining pages
Applying: memory-hotplug: update mce_bad_pages when removing the memory
Applying: memory-hotplug-update-mce_bad_pages-when-removing-the-memory-fix
Applying: memory-hotplug: auto offline page_cgroup when onlining memory blo=
ck failed
Applying: memory-hotplug: fix NR_FREE_PAGES mismatch
Applying: memory-hotplug: allocate zone's pcp before onlining pages
Applying: mm: make zone_pcp_reset independent of MEMORY_HOTREMOVE
Applying: memory-hotplug: build zonelist if a zone is populated after onlin=
ing pages
Applying: memory_hotplug: fix possible incorrect node_states[N_NORMAL_MEMOR=
Y]
Applying: slub, hotplug: ignore unrelated node's hot-adding and hot-removing
Applying: slab: ignore internal flags in cache creation
Applying: drop_caches: add some documentation and info messsge
Applying: drop_caches-add-some-documentation-and-info-messsge-checkpatch-fi=
xes
Applying: swap: add a simple detector for inappropriate swapin readahead
Applying: swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix
Applying: mm/memblock: reduce overhead in binary search
Applying: scripts/pnmtologo: fix for plain PBM
Applying: scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes
Applying: include/linux/init.h: use the stringify operator for the __define=
_initcall macro
Applying: scripts/tags.sh: add magic for declarations of popular kernel type
Applying: backlight: da903x_bl: use dev_get_drvdata() instead of platform_g=
et_drvdata()
Applying: backlight: 88pm860x_bl: fix checkpatch warning
Applying: backlight: atmel-pwm-bl: fix checkpatch warning
Applying: backlight: corgi_lcd: fix checkpatch error and warning
Applying: backlight: da903x_bl: fix checkpatch warning
Applying: backlight: generic_bl: fix checkpatch warning
Applying: backlight: hp680_bl: fix checkpatch error and warning
Applying: backlight: ili9320: fix checkpatch error and warning
Applying: backlight: jornada720: fix checkpatch error and warning
Applying: backlight: l4f00242t03: fix checkpatch warning
Applying: backlight: lm3630: fix checkpatch warning
Applying: backlight: locomolcd: fix checkpatch error and warning
Applying: backlight: omap1: fix checkpatch warning
Applying: backlight: pcf50633: fix checkpatch warning
Applying: backlight: platform_lcd: fix checkpatch error
Applying: backlight: tdo24m: fix checkpatch warning
Applying: backlight: tosa: fix checkpatch error and warning
Applying: backlight: vgg2432a4: fix checkpatch warning
Applying: backlight: lms283gf05: use devm_gpio_request_one
Applying: backlight: tosa: use devm_gpio_request_one
Applying: drivers/video/backlight/lp855x_bl.c: use generic PWM functions
Applying: drivers-video-backlight-lp855x_blc-use-generic-pwm-functions-fix
Applying: drivers/video/backlight/lp855x_bl.c: remove unnecessary mutex code
Applying: drivers/video/backlight/da9052_bl.c: add missing const
Applying: drivers/video/backlight/lms283gf05.c: add missing const
Applying: drivers/video/backlight/tdo24m.c: add missing const
Applying: drivers/video/backlight/vgg2432a4.c: add missing const
Applying: drivers/video/backlight/s6e63m0.c: remove unnecessary cast of voi=
d pointer
Applying: string: introduce helper to get base file name from given path
Applying: lib: dynamic_debug: use kbasename()
Applying: mm: use kbasename()
Applying: procfs: use kbasename()
Applying: trace: use kbasename()
Applying: compat: generic compat_sys_sched_rr_get_interval() implementation
Applying: drivers/firmware/dmi_scan.c: check dmi version when get system uu=
id
Applying: drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid=
-fix
Applying: drivers/firmware/dmi_scan.c: fetch dmi version from SMBIOS if it =
exists
Applying: drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-ex=
ists-checkpatch-fixes
Applying: checkpatch: improve network block comment style checking
Applying: binfmt_elf: fix corner case kfree of uninitialized data
Applying: binfmt_elf-fix-corner-case-kfree-of-uninitialized-data-checkpatch=
-fixes
Applying: rtc: omap: kicker mechanism support
Applying: ARM: davinci: remove rtc kicker release
Applying: rtc: omap: dt support
Applying: rtc: omap: depend on am33xx
Applying: rtc: omap: add runtime pm support
Applying: drivers/rtc/rtc-imxdi: support for i.MX53
Applying: drivers/rtc/rtc-imxdi.c: add devicetree support
Applying: ARM: mach-imx: support for DryIce RTC in i.MX53
Applying: hfsplus: add on-disk layout declarations related to attributes tr=
ee
Applying: hfsplus: add functionality of manipulating by records in attribut=
es tree
Applying: hfsplus: rework functionality of getting, setting and deleting of=
 extended attributes
Applying: hfsplus: add support of manipulation by attributes file
Applying: hfsplus-add-support-of-manipulation-by-attributes-file-checkpatch=
-fixes
Applying: hfsplus: code style fixes - reworked support of extended attribut=
es
Applying: fat: modify nfs mount option
Applying: fat (exportfs): rebuild inode if ilookup() fails
Applying: fat-exportfs-rebuild-inode-if-ilookup-fails-fix
Applying: fat (exportfs): rebuild directory-inode if fat_dget() fails
Applying: Documentation: update nfs option in filesystem/vfat.txt
Applying: kstrto*: add documentation
Applying: simple_strto*: annotate function as obsolete
Applying: proc: don't show nonexistent capabilities
Applying: procfs: add VmFlags field in smaps output
Applying: procfs-add-vmflags-field-in-smaps-output-v4-fix
Applying: ipc: remove forced assignment of selected message
Applying: ipc: add sysctl to specify desired next object id
Applying: ipc-add-sysctl-to-specify-desired-next-object-id-checkpatch-fixes
Applying: ipc: message queue receive cleanup
Applying: ipc-message-queue-receive-cleanup-checkpatch-fixes
Applying: ipc: message queue copy feature introduced
Applying: selftests: IPC message queue copy feature test
Applying: selftests-ipc-message-queue-copy-feature-test-checkpatch-fixes
Applying: ipc/sem.c: alternatives to preempt_disable()
Applying: linux/compiler.h: add __must_hold macro for functions called with=
 a lock held
Applying: Documentation/sparse.txt: document context annotations for lock c=
hecking
Applying: aoe: describe the behavior of the "err" character device
Applying: aoe: print warning regarding a common reason for dropped transmits
Applying: aoe-print-warning-regarding-a-common-reason-for-dropped-transmits=
-v2
Applying: aoe: avoid using skb member after dev_queue_xmit
Applying: aoe: update cap on outstanding commands based on config query res=
ponse
Applying: aoe: support the forgetting (flushing) of a user-specified AoE ta=
rget
Applying: aoe: support larger I/O requests via aoe_maxsectors module param
Applying: aoe: "payload" sysfs file exports per-AoE-command data transfer s=
ize
Applying: aoe: cleanup: remove unused ata_scnt function
Applying: aoe: whitespace cleanup
Applying: aoe: update driver-internal version number to 60
Applying: documentation-dma-api-howtotxt-add-dma-mapping-error-check-usage-=
examples-fix
Applying: tools/testing/selftests/kcmp/kcmp_test.c: print reason for failur=
e in kcmp_test
Applying: mm-introduce-mm_find_pmd-fix
Merging akpm/master (b1757a8 mm-introduce-mm_find_pmd-fix)

--Signature=_Tue__30_Oct_2012_17_07_04_+1100_rTV8EgRNQRQWuQ4m
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQj26IAAoJEECxmPOUX5FEGBMQAINGGY/X75qr3bSb+aUo0U6B
DjL4yDeaRaB4uWt9IWACVhLuxw+OAaC1lsRLzLWLufdMjxzLMxALQ8OPg3LT/TKS
zgaAoOUCNfucpr7xRVZ5qoHebB9UfC2zevi7hVLAR1ON+pQtBYCUu1oOJxK4j56k
FyUKUwLeb5MtEZNZb8TETbPXSMItDIbbIyWNLZrPnu0Tk3XjTke87sXoAgh6mfDd
4+Wbjtso/EeIApQe31ID1qr3yHZDwiDZuR/VNZa5LlbFUssf7stU73UOwKzoRKuJ
d7aV5NMwsxehjx4ml+tRbN0jP9kVNTeOdcBKwyfCdNsys0KRoHc1BysAqQZ/0kFi
TWXrG58wi9M8kR6J66Gk9UUczdMAZA+XbMcIFzCenygWwo48dP0MWNsF6tyo03U6
Zt/tlB0b8pHKhN0PiYVHzMaNhRpnD55kxXZrmgGEodljUhtN6HhOe7WQmfi/hczD
1SeQOGNGc1v7isFApqIYPu8fAUyEcBh3Vbm6VY0W0VjFp6EXFNi77xcJCj+gsyjZ
5eySdHlcH5g51gMXnJEoRrjqt4WzEsucUJB4HXl9WuqMy2H0b3a+Jov68IGBTx/J
yq7P4yjwpi93Lm6hasGkPSrZeNpl5T5GIIDC8evqANxrrczOCM1S0QtDweaIiTPS
y3M8/B2eVsDQGopaFnIB
=z9NP
-----END PGP SIGNATURE-----

--Signature=_Tue__30_Oct_2012_17_07_04_+1100_rTV8EgRNQRQWuQ4m--

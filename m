Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751320Ab2KGFPk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 00:15:40 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:44545 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab2KGFPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 00:15:36 -0500
Date: Wed, 7 Nov 2012 16:15:27 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <linux-next@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Nov 7
Message-Id: <20121107161527.9fe7d5f306b45d4ceacd0ffa@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__7_Nov_2012_16_15_27_+1100_taUmG.LhOOw4rRa+"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__7_Nov_2012_16_15_27_+1100_taUmG.LhOOw4rRa+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

/me resists commenting on recent political events

Changes since 20121106:

The pci tree still has its build failure for which I applied a merge fix pa=
tch.

The v4l-dvb tree lost its build failure but gained another so I used the
version from next-20121026.

The pinctrl tree gained a build failure for which I applied a patch.

The arm-soc tree gained a conflict against the l2-mtd and pinctrl trees.

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

We are up to 209 trees (counting Linus' and 28 trees of patches pending
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
Merging origin/master (3d70f8c Linux 3.7-rc4)
Merging fixes/master (12250d8 Merge branch 'i2c-embedded/for-next' of git:/=
/git.pengutronix.de/git/wsa/linux)
Merging kbuild-current/rc-fixes (bad9955 menuconfig: Replace CIRCLEQ by lis=
t_head-style lists.)
Merging arm-current/fixes (6404f0b ARM: 7569/1: mm: uninitialized warning c=
orrections)
Merging m68k-current/for-linus (8a745ee m68k: Wire up kcmp)
Merging powerpc-merge/merge (8c23f40 Merge git://git.kernel.org/pub/scm/vir=
t/kvm/kvm)
Merging sparc/master (f7e8d9f qlogicpti: Fix build warning.)
Merging net/master (cacb6ba net: inet_diag -- Return error code if protocol=
 handler is missed)
Merging sound-current/for-linus (ae24c31 ALSA: hda - Force to reset IEC958 =
status bits for AD codecs)
Merging pci-current/for-linus (ff8e59b PCI/portdrv: Don't create hotplug sl=
ots unless port supports hotplug)
Merging wireless/master (6fe7cc7 ath9k: Test for TID only in BlockAcks whil=
e checking tx status)
Merging driver-core.current/driver-core-linus (8f0d816 Linux 3.7-rc3)
Merging tty.current/tty-linus (8f0d816 Linux 3.7-rc3)
Merging usb.current/usb-linus (d99e65b USB: fix build with XEN and EARLY_PR=
INTK_DBGP enabled but USB_SUPPORT disabled)
Merging staging.current/staging-linus (8f0d816 Linux 3.7-rc3)
Merging char-misc.current/char-misc-linus (8f0d816 Linux 3.7-rc3)
Merging input-current/for-linus (32ed191 Input: tsc40 - remove wrong announ=
cement of pressure support)
Merging md-current/for-linus (ed30be0 MD RAID10: Fix oops when creating RAI=
D10 arrays via dm-raid.c)
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
Merging rr-fixes/fixes (f6a79af modules: don't break modules_install on ext=
ernal modules with no key.)
Merging asm-generic/master (9b04ebd asm-generic/io.h: remove asm/cacheflush=
.h include)
Merging arm/for-next (31ccae2 Merge remote-tracking branch 'wildea/asids' i=
nto for-next)
Merging arm-perf/for-next/perf (85776d5 Merge branch 'hw-breakpoint' into f=
or-next/perf)
Merging davinci/davinci-next (fe0d422 Linux 3.0-rc6)
Merging xilinx/arm-next (f580077 zynq: move static peripheral mappings)
Merging arm64/upstream (811a0c8 arm64: perf: use architected event for CPU =
cycle counter)
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
Merging mips/mips-for-linux-next (99a83df MIPS: Fix harmlessly missing else=
 statement.)
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
Merging s390/features (8e70fa0 s390/mm: move kernel_page_present/kernel_map=
_pages to page_attr.c)
Merging sh/sh-latest (0dd4d5c sh: Fix up more fallout from pointless ARM __=
iomem churn.)
Merging sparc-next/master (43c422e apparmor: fix apparmor OOPS in audit_log=
_untrustedstring+0x1c/0x40)
Merging tile/master (ddffeb8 Linux 3.7-rc1)
Merging unicore32/unicore32 (7bf2799 arch/unicore32: remove CONFIG_EXPERIME=
NTAL)
Merging xtensa/for_next (d83ac75 xtensa: add xtavnet DTS)
Merging btrfs/next (c37b2b6 Btrfs: do not bug when we fail to commit the tr=
ansaction)
Merging ceph/master (3515297 rbd: activate v2 image support)
Merging cifs/for-next (5004f80 cifs: fix SID binary to string conversion)
Merging configfs/linux-next (b930c26 Merge branch 'for-linus' of git://git.=
kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (0d7614f Linux 3.6-rc1)
Merging ext3/for_next (6c29c50 quota: Silence warning about PRJQUOTA not be=
ing handled in need_print_warning())
Merging ext4/dev (ffb5387 ext4: fix unjournaled inode bitmap modification)
Merging fuse/for-next (c7a3f5e fuse: Move CUSE Kconfig entry from fs/Kconfi=
g into fs/fuse/Kconfig)
Merging gfs2/master (76a8364 GFS2: Don't call file_accessed() with a shared=
 glock)
Merging jfs/jfs-next (4e7a4b0 jfs: Fix FITRIM argument handling)
Merging logfs/master (ab2ec19 logfs: fix possible memory leak in logfs_mtd_=
can_write_buf())
Merging nfs/linux-next (070d15d NFSv4.1: Remove the 'FIFO' behaviour for nf=
s41_setup_sequence)
Merging nfsd/nfsd-next (ddffeb8 Linux 3.7-rc1)
Merging ocfs2/linux-next (4538df6 ocfs2: Don't spam on -EDQUOT.)
Merging omfs/for-next (976d167 Linux 3.1-rc9)
Merging squashfs/master (4b0180a Squashfs: add mount time sanity check for =
block_size and block_log match)
Merging v9fs/for-next (552aad0 9P: Fix race between p9_write_work() and p9_=
fd_request())
Merging ubifs/linux-next (a28ad42 UBIFS: fix mounting problems after power =
cuts)
Merging xfs/for-next (c99abb8 xfs: Update mount options documentation)
Merging vfs/for-next (a736427 missing const in alpha callers of do_mount())
Merging pci/next (84a8fb6 Merge branch 'pci/yinghai-for-pci-root-bus-hotplu=
g' into next)
Applying: PCI: fixups for pci_resource_start conversion
Merging hid/for-next (35c9a62 Merge branch 'for-3.8/roccat' into for-next)
Merging i2c/master (5e9c4fe i2c: Mention functionality flags in SMBus proto=
col documentation)
Merging i2c-embedded/i2c-embedded/for-next (60f0a25 i2c: tegra: set irq nam=
e as device name)
Merging jdelvare-hwmon/master (a196a0c hwmon: (it87) Support PECI for addit=
ional chips)
Merging hwmon-staging/hwmon-next (d29d75d hwmon: (da9055) Fix chan_mux[DA90=
55_ADC_ADCIN3] setting)
Merging v4l-dvb/master (c616352 Merge /home/v4l/v4l/patchwork)
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
Merging acpi/next (b63cb74 tools: Allow tools to be installed in a user spe=
cified location)
Merging cpuidle/cpuidle-next (3cf7997 acpi: intel_idle : break dependency b=
etween modules)
CONFLICT (content): Merge conflict in include/linux/cpuidle.h
CONFLICT (add/add): Merge conflict in drivers/cpuidle/coupled.c
Merging cpupowerutils/master (f166033 cpupower tools: add install target to=
 the debug tools' makefiles)
Merging thermal/next (e15cb14 thermal: user_space: Add missing static stora=
ge class specifiers)
Merging ieee1394/for-next (790198f firewire: cdev: fix user memory corrupti=
on (i386 userland on amd64 kernel))
Merging ubi/linux-next (6a059ab UBI: use list_move_tail instead of list_del=
/list_add_tail)
Merging dlm/next (a3de56b fs/dlm: remove CONFIG_EXPERIMENTAL)
Merging swiotlb/linux-next (af51a9f swiotlb: Do not export swiotlb_bounce s=
ince there are no external consumers)
Merging scsi/for-next (5c1b10a [SCSI] storvsc: Account for in-transit packe=
ts in the RESET path)
Merging target-updates/for-next (3a89b51 target: Fix incorrect starting off=
set after MODE_SENSE refactoring)
Merging target-merge/for-next-merge (6f0c058 Linux 3.7-rc2)
Merging ibft/linux-next (935a9fe ibft: Fix finding IBFT ACPI table on UEFI)
Merging isci/all (6734092 isci: add a couple __iomem annotations)
Merging slave-dma/next (8007644 async_tx: use memchr_inv)
Merging dmaengine/next (a2bd114 netdma: adding alignment check for NETDMA o=
ps)
Merging net-next/master (d64ec84 r8169: enable internal ASPM and clock requ=
est settings)
Merging wireless-next/master (38141fc ar5523: make buffer size variable uns=
igned)
Merging bluetooth/master (0c0afed Bluetooth: Fix parameter order of hci_get=
_route)
Merging mtd/master (5a6ea4a mtd: ofpart: Fix incorrect NULL check in parse_=
ofoldpart_partitions())
Merging l2-mtd/master (2c5e1925 mtd: mtd_oobtest: printk -> pr_{info,err,cr=
it})
Merging crypto/master (3200da8 crypto: tegra - fix missing unlock on error =
case)
Merging drm/drm-next (1f31c69 Merge branch 'drm-intel-fixes' of git://peopl=
e.freedesktop.org/~danvet/drm-intel into drm-next)
Merging sound/for-next (4492363 ALSA: virtuoso: Xonar DSX support)
Merging sound-asoc/for-next (eb00058 Merge tag 'v3.7-rc4' into asoc-next)
Merging modules/modules-next (56713a2 MODSIGN: Add modules_sign make target)
Merging virtio/virtio-next (41395df virtio: Convert dev_printk(KERN_<LEVEL>=
 to dev_<level>()
Merging input/next (8ed2757 Input: add DA9055 Onkey driver)
Merging input-mt/for-next (6f0c058 Linux 3.7-rc2)
Merging cgroup/for-next (4b1c784 device_cgroup: add lockdep asserts)
Merging block/for-next (454832b Merge branch 'for-3.7/drivers' into for-nex=
t)
CONFLICT (content): Merge conflict in init/Kconfig
CONFLICT (content): Merge conflict in drivers/block/floppy.c
Merging device-mapper/master (cee3685 track_chunk is always called with int=
errupts enabled. Consequently, we do not need to save and restore interrupt=
 state in "flags" variable. This patch changes spin_lock_irqsave to spin_lo=
ck_irq and spin_unlock_irqrestore to spin_unlock_irq.)
Merging embedded/master (4744b43 embedded: fix vc_translate operator preced=
ence)
Merging firmware/master (6e03a20 firmware: speed up request_firmware(), v3)
Merging pcmcia/master (80af9e6 pcmcia at91_cf: fix raw gpio number usage)
Merging mmc/mmc-next (9c80e2e mmc: dw_mmc: constify dw_mci_idmac_ops in exy=
nos back-end)
Merging kgdb/kgdb-next (58bcdf6 tty/console: fix warnings in drivers/tty/se=
rial/kgdboc.c)
Merging slab/for-next (31841eb Merge branch 'slab/next' into for-next)
CONFLICT (content): Merge conflict in mm/slob.c
Merging uclinux/for-next (ddffeb8 Linux 3.7-rc1)
Merging md/for-next (79acf8a md:Avoid write invalid address if read_seqretr=
y returned true.)
Merging mfd/for-next (0312e02 mfd: mc13xxx: Add support for mc34708)
Merging battery/master (18766f0 Merge with upstream to accommodate with MFD=
 changes)
Merging fbdev/fbdev-next (cd9d6f1 gbefb: fix compile error)
Merging viafb/viafb-next (838ac78 viafb: avoid refresh and mode lookup in s=
et_par)
Merging omap_dss2/for-next (13b1ba7 OMAPDSS: add missing include for string=
.h)
Merging regulator/for-next (fe623ca Merge remote-tracking branches 'regulat=
or/fix/gpio', 'regulator/fix/put', 'regulator/topic/gpio', 'regulator/topic=
/lp8788', 'regulator/topic/max77686', 'regulator/topic/tps51632', 'regulato=
r/topic/tps65910' and 'regulator/topic/vexpress' into regulator-next)
Merging security/next (b566650 drivers/char/tpm: remove tasklet and cleanup)
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
Merging trivial/for-next (926ccfe Btrfs: Fix printk and variable name)
Merging audit/for-next (dcd6c92 Linux 3.3-rc1)
Merging pm/linux-next (e1424ee Merge branch 'pm-qos-next' into linux-next)
CONFLICT (content): Merge conflict in arch/x86/pci/acpi.c
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
Merging spi-mb/spi-next (7032449 Merge branch 'spi-linus' into spi-next)
Merging tip/auto-latest (8a1d31c Merge branch 'x86/urgent')
Merging rcu/rcu/next (155f744 Merge branches 'doc.2012.10.30a', 'fixes.2012=
.10.30a', 'srcu.2012.10.27a', 'stall.2012.10.24a', 'tracing.2012.10.30a' an=
d 'idle.2012.10.24a' into HEAD)
Merging cputime/cputime (c3e0ef9 [S390] fix cputime overflow in uptime_proc=
_show)
Merging uprobes/for-next (0326f5a uprobes/core: Handle breakpoint and singl=
estep exceptions)
Merging kvm/linux-next (f026399 Merge branch 'for-queue' of https://github.=
com/agraf/linux-2.6 into queue)
Merging kvm-ppc/kvm-ppc-next (f534a53 KVM: PPC: Book3S HV: Fix thinko in tr=
y_lock_hpte())
CONFLICT (add/add): Merge conflict in arch/powerpc/include/uapi/asm/epapr_h=
calls.h
CONFLICT (content): Merge conflict in arch/powerpc/include/uapi/asm/Kbuild
CONFLICT (content): Merge conflict in arch/powerpc/include/asm/Kbuild
Merging oprofile/for-next (4400910 oprofile, x86: Fix wrapping bug in op_x8=
6_get_ctrl())
Merging xen/upstream/xen (af3a3ab Merge git://git.kernel.org/pub/scm/linux/=
kernel/git/steve/gfs2-3.0-fixes)
Merging xen-two/linux-next (7595787 Merge branch 'stable/for-linus-3.7' int=
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
Merging regmap/for-next (516edb8 Merge remote-tracking branches 'regmap/top=
ic/core', 'regmap/topic/domain', 'regmap/topic/lock', 'regmap/topic/range' =
and 'regmap/topic/type' into regmap-next)
Merging hsi/for-next (43139a6 HSI: hsi_char: Update ioctl-number.txt)
Merging leds/for-next (c84f14d leds: lm3642: Fix up world writable sysfs fi=
les)
Merging driver-core/driver-core-next (bb3215e Documentation: Fixes a term's=
 translation in Documentation/zh_CN/arm64/memory.txt)
Merging tty/tty-next (76cc438 tty: of_serial: fix return value check in of_=
platform_serial_setup())
CONFLICT (content): Merge conflict in drivers/tty/serial/omap-serial.c
Merging usb/usb-next (cdb2fac USB: EHCI: fix build error in ChipIdea host d=
river)
CONFLICT (content): Merge conflict in drivers/usb/early/ehci-dbgp.c
Merging staging/staging-next (fb7d2eb staging: csr: csr_wifi_hip_unifi_sign=
al_names: Fix pointer position)
CONFLICT (modify/delete): drivers/staging/telephony/Kconfig deleted in stag=
ing/staging-next and modified in HEAD. Version HEAD of drivers/staging/tele=
phony/Kconfig left in tree.
$ git rm -f drivers/staging/telephony/Kconfig
Merging char-misc/char-misc-next (ab5c4a5 mei: move amthif specific code fr=
om mei_write to mei_amthif_write)
Merging tmem/linux-next (8f0d816 Linux 3.7-rc3)
Merging writeback/writeback-for-next (2f60d62 CPU hotplug, writeback: Don't=
 call writeback_set_ratelimit() too often during hotplug)
Merging arm-dt/devicetree/arm-next (ede338f dt: add documentation of ARM dt=
 boot interface)
Merging hwspinlock/linux-next (8b37fcf hwspinlock: add MAINTAINERS entries)
Merging pinctrl/for-next (ed8d3e3 Merge branch 'samsung' into for-next)
Merging vhost/linux-next (e0953c8 tun: experimental zero copy tx support)
CONFLICT (content): Merge conflict in drivers/net/tun.c
Merging memblock/memblock-kill-early_node_map (7bd0b0f memblock: Reimplemen=
t memblock allocation using reverse free area iterator)
Merging remoteproc/for-next (6f0c058 Linux 3.7-rc2)
Merging irqdomain/irqdomain/next (f5a1ad0 irqdomain: Improve diagnostics wh=
en a domain mapping fails)
Merging gpio/gpio/next (ddf343f Merge branch 'for-linus' of git://git.kerne=
l.org/pub/scm/linux/kernel/git/s390/linux)
Merging gpio-lw/for-next (b1ffa4b Merge branch 'devel' into for-next)
Merging arm-soc/for-next (f1464f1 Merge branch 'next/smp' into for-next)
CONFLICT (content): Merge conflict in drivers/pinctrl/pinctrl-nomadik.c
CONFLICT (content): Merge conflict in arch/arm/mach-ux500/cpu-db8500.c
CONFLICT (content): Merge conflict in arch/arm/mach-ux500/board-mop500.c
CONFLICT (content): Merge conflict in arch/arm/mach-ux500/board-mop500-audi=
o.c
CONFLICT (content): Merge conflict in arch/arm/mach-omap2/drm.c
CONFLICT (content): Merge conflict in arch/arm/mach-nomadik/board-nhk8815.c
CONFLICT (content): Merge conflict in arch/arm/Kconfig
Merging bcm2835/for-next (d7f292e Merge branch 'for-3.8/defconfig' into for=
-next)
Merging cortex/for-next (77a3018 Cortex-M3: Add support for exception handl=
ing)
Merging ep93xx/ep93xx-for-next (fab1f74 Merge branch 'ep93xx-fixes' into ep=
93xx-for-next)
Merging ixp4xx/next (b94740b IXP4xx: use __iomem for MMIO)
Merging msm/for-next (a0d271c Linux 3.6)
Merging renesas/next (de39c8b Merge branches 'heads/fixes', 'heads/defconfi=
g', 'heads/boards' and 'heads/soc' into next)
Merging samsung/for-next (f789f1e Merge branch 'next/board-samsung' into fo=
r-next)
CONFLICT (content): Merge conflict in arch/arm/boot/dts/exynos4210.dtsi
Merging tegra/for-next (c76dbd0 Merge branch 'for-3.8/defconfig' into for-n=
ext)
Merging kvmtool/master (cfb8234 kvm tools: Fast A20 gate emulation)
Merging dma-mapping/dma-mapping-next (8f0d816 Linux 3.7-rc3)
Merging pwm/for-next (d5da78e PWM: Add SPEAr PWM chip driver support)
Merging dma-buf/for-next (ba42051 dma-buf: might_sleep() in dma_buf_unmap_a=
ttachment())
Merging userns/for-next (e9069f4 btrfs: Fix compilation with user namespace=
 support enabled)
Merging ktest/for-next (95f5783 ktest: Fix ELSE IF statements)
Merging signal/for-next (f899e0f frv: switch to generic fork/vfork/clone)
CONFLICT (content): Merge conflict in arch/sparc/kernel/sys_sparc_64.c
CONFLICT (content): Merge conflict in arch/arm/kernel/process.c
Merging clk/clk-next (9be9d48 clk: wm831x: Use devm_clk_register() to simpl=
ify code)
Merging random/dev (c5c1244 random: fix debug format strings)
Merging lzo-update/lzo-update (ba32bf9 lib/lzo: Do not leak implementation =
details in lzo1x_1_compress())
Merging drop-experimental/linux-next (f5fd981 tools/lguest: remove depends =
on CONFIG_EXPERIMENTAL)
CONFLICT (content): Merge conflict in drivers/ptp/Kconfig
CONFLICT (content): Merge conflict in drivers/net/ethernet/intel/Kconfig
Merging scsi-post-merge/merge-base:master ()
Merging akpm-current/current (7cd8e78 device_cgroup: fix unchecked cgroup p=
arent usage)
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
Applying: arch/x86/platform/iris/iris.c: register a platform device and a p=
latform driver
Applying: x86 numa: don't check if node is NUMA_NO_NODE
Applying: arch/x86/tools/insn_sanity.c: identify source of messages
Applying: arch/x86/platform/uv: fix incorrect tlb flush all issue
Applying: olpc: fix olpc-xo1-sci.c build errors
Applying: x86: make 'mem=3D' option work for efi platform
Applying: fs/debugsfs: remove unnecessary inode->i_private initialization
Applying: pcmcia: move unbind/rebind into dev_pm_ops.complete
Applying: drm/i915: optimize DIV_ROUND_CLOSEST() call
Applying: timeconst.pl: remove deprecated defined(@array)
Applying: time: don't inline EXPORT_SYMBOL functions
Applying: fs/pstore/ram.c: fix up section annotations
Applying: h8300: select generic atomic64_t support
Applying: drivers/message/fusion/mptscsih.c: missing break
Applying: drivers/scsi/hptiop: support HighPoint RR4520/RR4522 HBA
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
Applying: mm, memcg: make mem_cgroup_out_of_memory() static
Applying: mm: use IS_ENABLED(CONFIG_NUMA) instead of NUMA_BUILD
Applying: mm: use IS_ENABLED(CONFIG_COMPACTION) instead of COMPACTION_BUILD
Applying: thp: clean up __collapse_huge_page_isolate
Applying: thp-clean-up-__collapse_huge_page_isolate v2
Applying: mm: introduce mm_find_pmd()
Applying: mm-introduce-mm_find_pmd-fix
Applying: thp: introduce hugepage_vma_check()
Applying: thp: cleanup: introduce mk_huge_pmd()
Applying: memory hotplug: suppress "Device memoryX does not have a release(=
) function" warning
Applying: memory-hotplug: skip HWPoisoned page when offlining pages
Applying: memory-hotplug: update mce_bad_pages when removing the memory
Applying: memory-hotplug-update-mce_bad_pages-when-removing-the-memory-fix
Applying: memory-hotplug: auto offline page_cgroup when onlining memory blo=
ck failed
Applying: memory-hotplug: fix NR_FREE_PAGES mismatch
Applying: numa: convert static memory to dynamically allocated memory for p=
er node device
Applying: memory-hotplug: suppress "Device nodeX does not have a release() =
function" warning
Applying: memory-hotplug, mm/sparse.c: clear the memory to store struct page
Applying: memory-hotplug: allocate zone's pcp before onlining pages
Applying: mm: make zone_pcp_reset independent of MEMORY_HOTREMOVE
Applying: memory-hotplug: build zonelist if a zone is populated after onlin=
ing pages
Applying: memory_hotplug: fix possible incorrect node_states[N_NORMAL_MEMOR=
Y]
Applying: slub, hotplug: ignore unrelated node's hot-adding and hot-removing
Applying: mm: add comment on storage key dirty bit semantics
Applying: mm,vmscan: only evict file pages when we have plenty
Applying: mmvmscan-only-evict-file-pages-when-we-have-plenty-fix
Applying: mm: refactor reinsert of swap_info in sys_swapoff()
Applying: mm: do not call frontswap_init() during swapoff
Applying: mm, highmem: use PKMAP_NR() to calculate an index of pkmap
Applying: mm, highmem: remove useless pool_lock
Applying: mm, highmem: remove page_address_pool list
Applying: mm-highmem-remove-page_address_pool-list-v2
Applying: mm, highmem: makes flush_all_zero_pkmaps() return index of last f=
lushed entry
Applying: mm-highmem-makes-flush_all_zero_pkmaps-return-index-of-last-flush=
ed-entry-v2
Applying: mm, highmem: get virtual address of the page using PKMAP_ADDR()
Applying: mm: thp: set the accessed flag for old pages on access fault
Applying: mm: memmap_init_zone() performance improvement
Applying: Documentation/cgroups/memory.txt: s/mem_cgroup_charge/mem_cgroup_=
change_common/
Applying: mm, oom: allow exiting threads to have access to memory reserves
Applying: memcg: make it possible to use the stock for more than one page
Applying: memcg: reclaim when more than one page needed
Applying: memcg: change defines to an enum
Applying: memcg: kmem accounting basic infrastructure
Applying: mm: add a __GFP_KMEMCG flag
Applying: memcg: kmem controller infrastructure
Applying: mm: allocate kernel pages to the right memcg
Applying: res_counter: return amount of charges after res_counter_uncharge()
Applying: memcg: kmem accounting lifecycle management
Applying: memcg: use static branches when code not in use
Applying: memcg: allow a memcg with kmem charges to be destructed
Applying: memcg: execute the whole memcg freeing in free_worker()
Applying: fork: protect architectures where THREAD_SIZE >=3D PAGE_SIZE agai=
nst fork bombs
Applying: memcg: add documentation about the kmem controller
Applying: slab/slub: struct memcg_params
Applying: slab: annotate on-slab caches nodelist locks
Applying: slab/slub: consider a memcg parameter in kmem_create_cache
Applying: memcg: allocate memory for memcg caches whenever a new memcg appe=
ars
Applying: memcg: infrastructure to match an allocation to the right cache
Applying: memcg: skip memcg kmem allocations in specified code regions
Applying: sl[au]b: always get the cache from its page in kmem_cache_free()
Applying: sl[au]b: allocate objects from memcg cache
Applying: memcg: destroy memcg caches
Applying: memcg/sl[au]b: track all the memcg children of a kmem_cache
Applying: memcg/sl[au]b: shrink dead caches
Applying: memcg: aggregate memcg cache values in slabinfo
Applying: slab: propagate tunable values
Applying: slub: slub-specific propagation changes
Applying: kmem: add slab-specific documentation about the kmem controller
Applying: drop_caches: add some documentation and info message
Applying: drop_caches-add-some-documentation-and-info-messsge-checkpatch-fi=
xes
Applying: swap: add a simple detector for inappropriate swapin readahead
Applying: swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix
Applying: mm/memblock: reduce overhead in binary search
Applying: scripts/pnmtologo: fix for plain PBM
Applying: scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes
Applying: Documentation/kernel-parameters.txt: update mem=3D option's spec =
according to its implementation
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
Applying: drivers/video/backlight/88pm860x_bl.c: drop devm_kfree of devm_kz=
alloc'd data
Applying: drivers/video/backlight/max8925_bl.c: drop devm_kfree of devm_kza=
lloc'd data
Applying: drivers/video/backlight/lm3639_bl.c: fix up world writable sysfs =
file
Applying: drivers/video/backlight/ep93xx_bl.c: fix section mismatch
Applying: drivers/video/backlight/hp680_bl.c: add missing __devexit macros =
for remove
Applying: drivers/video/backlight/ili9320.c: add missing __devexit macros f=
or remove
Applying: string: introduce helper to get base file name from given path
Applying: lib: dynamic_debug: use kbasename()
Applying: mm: use kbasename()
Applying: procfs: use kbasename()
Applying: proc_devtree: remove duplicated include from proc_devtree.c
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
Applying: checkpatch: warn on unnecessary line continuations
Applying: epoll: support for disabling items, and a self-test app
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
Applying: drivers/rtc/rtc-vt8500.c: convert to use devm_kzalloc
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
Applying: fat: remove parent_logstart check in fat_get_parent
Applying: fat: restructure export operations
Applying: fat: move fat_i_pos_read to fat.h
Applying: fat: (exportfs) move code to rebuild directory-inode to separate =
function
Applying: fat: add mutex lock to fat_build_inode
Applying: Documentation/DMA-API-HOWTO.txt: minor grammar corrections
Applying: kstrto*: add documentation
Applying: simple_strto*: annotate function as obsolete
Applying: proc: don't show nonexistent capabilities
Applying: procfs: add VmFlags field in smaps output
Applying: procfs-add-vmflags-field-in-smaps-output-v4-fix
Applying: /proc/pid/status: add "Seccomp" field
Applying: fork: unshare: remove dead code
Applying: ipc: remove forced assignment of selected message
Applying: ipc: add sysctl to specify desired next object id
Applying: ipc-add-sysctl-to-specify-desired-next-object-id-checkpatch-fixes
Applying: ipc: wrap new sysctls for CRIU inside CONFIG_CHECKPOINT_RESTORE
Applying: Documentation: update sysctl/kernel.txt
Applying: ipc: message queue receive cleanup
Applying: ipc-message-queue-receive-cleanup-checkpatch-fixes
Applying: ipc: introduce message queue copy feature
Applying: ipc: remove redundant MSG_COPY check
Applying: ipc: cleanup do_msgrcv() aroung MSG_COPY feature
Applying: selftests: IPC message queue copy feature test
Applying: test: IPC message queue copy feature test update
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
Merging akpm/master (5c37733 tools/testing/selftests/kcmp/kcmp_test.c: prin=
t reason for failure in kcmp_test)
Applying: gpiolib: fix non CONFIG_GPIOLIB functions

--Signature=_Wed__7_Nov_2012_16_15_27_+1100_taUmG.LhOOw4rRa+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQme5vAAoJEECxmPOUX5FE1dUQAIXg/Mo4Q0xU4RhmDP+Opxnp
mFPu4v6D76WC330YdQOmXrthqeMXrqyqOjNQF+63WhK3LsMx61TZytboy2UZzISn
TugfBL2SQ4uetgpTeD221Xm+WYGt4Ga6GlMofOo2AFPlN7JArI86ZmM+bBnZNGPa
nuQoWkCMhrh+wfwiLoligj+ZgGQ7to4+9lopdxK1iCpWqkRfDlrYRkgSfXyEIqZh
nH5juXbS1Jp/q4RbEumSWq7o9A95GlC+vzpmuDLnfP+tIjmH/T4hw2zypBBw/x/p
DaieFwhFWb43ww63mnm+RysbMZWJdvAlHwE5cks/JvbEmGw0o1kbGBo0TqDD4jKU
lmsBEK7myOl/CmEkZy9ADzAOLroJ7sUwn+lou4h0LCq+VcVfCvPPLmqoqjiU87s2
TeeE8e8KsOES3fkPU/zT3YPHN2v+UnPlONVcGEJxnqORhbesE8DUY1V0w/V4uz4s
lPoxsQ0inON0Jrv1q4gcM9DXiv4GwWln41MEu3u8rDgCrv+vmy2ozOABq+Ow2heP
EUwj2mJ+Xk1iEramn7Kn2RcZMQARWeLtu5LWjJfWCyH6eBNE6vpo+JiiEIyB6GsJ
NXwgFonH5HIwUP5RJyzGohFJ8EMs91bpFljmLx3pdyUSucEKHs7Ml+EXYvHqrJ9q
0Oqxn2IrS7AiEkfvPG+h
=575q
-----END PGP SIGNATURE-----

--Signature=_Wed__7_Nov_2012_16_15_27_+1100_taUmG.LhOOw4rRa+--

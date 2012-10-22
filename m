Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670Ab2JVEgY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 00:36:24 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:58870 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306Ab2JVEgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 00:36:21 -0400
Date: Mon, 22 Oct 2012 15:36:12 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <linux-next@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Oct 22
Message-Id: <20121022153612.12166e1dee1855091616013d@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__22_Oct_2012_15_36_12_+1100_aOsPz4i6s//XpniI"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__22_Oct_2012_15_36_12_+1100_aOsPz4i6s//XpniI
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 201201019:

The xtensa tree gained a conflict against Linus' tree.

The wireless-next tree gained conflicts against the wireless tree.

The modules tree gained a conflict against Linus' tree.

The tip tree lost its conflicts and build fixes.

The akpm tree lost some patches that turned up in Linus' tree.

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

We are up to 204 trees (counting Linus' and 26 trees of patches pending
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
Merging origin/master (6f0c058 Linux 3.7-rc2)
Merging fixes/master (12250d8 Merge branch 'i2c-embedded/for-next' of git:/=
/git.pengutronix.de/git/wsa/linux)
Merging kbuild-current/rc-fixes (b1e0d8b kbuild: Fix gcc -x syntax)
Merging arm-current/fixes (3d6ee36 Merge branch 'late-for-linus' of git://g=
it.linaro.org/people/rmk/linux-arm)
Merging m68k-current/for-linus (8a745ee m68k: Wire up kcmp)
Merging powerpc-merge/merge (83dac59 cpuidle/powerpc: Fix snooze state prob=
lem in the cpuidle design on pseries.)
Merging sparc/master (43c422e apparmor: fix apparmor OOPS in audit_log_untr=
ustedstring+0x1c/0x40)
Merging net/master (db0fe0b Merge tag 'batman-adv-fix-for-davem' of git://g=
it.open-mesh.org/linux-merge)
Merging sound-current/for-linus (edb6689 ALSA: sound/isa/opti9xx/miro.c: el=
iminate possible double free)
Merging pci-current/for-linus (0ff9514 PCI: Don't print anything while deco=
ding is disabled)
Merging wireless/master (290eddc Merge branch 'for-john' of git://git.kerne=
l.org/pub/scm/linux/kernel/git/jberg/mac80211)
Merging driver-core.current/driver-core-linus (ddffeb8 Linux 3.7-rc1)
Merging tty.current/tty-linus (178e485 staging: dgrp: check return value of=
 alloc_tty_driver)
Merging usb.current/usb-linus (4b35f1c USB: option: add more ZTE devices)
Merging staging.current/staging-linus (47c15308 Merge tag 'iio-fixes-for-3.=
7a' of git://git.kernel.org/pub/scm/linux/kernel/git/jic23/iio into staging=
-linus)
Merging char-misc.current/char-misc-linus (ddffeb8 Linux 3.7-rc1)
Merging input-current/for-linus (0cc8d6a Merge branch 'next' into for-linus)
Merging md-current/for-linus (72f36d5 md: refine reporting of resync/reshap=
e delays.)
Merging audit-current/for-linus (c158a35 audit: no leading space in audit_l=
og_d_path prefix)
Merging crypto-current/master (c9f97a2 crypto: x86/glue_helper - fix storin=
g of new IV in CBC encryption)
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
Merging asm-generic/master (c37d615 Merge branch 'disintegrate-asm-generic'=
 of git://git.infradead.org/users/dhowells/linux-headers into asm-generic)
Merging arm/for-next (ef4e305 ARM: mm: use bitmap operations when allocatin=
g new ASIDs)
Merging arm-perf/for-next/perf (eab8fc8 Merge branch 'hw-breakpoint' into f=
or-next/perf)
Merging davinci/davinci-next (fe0d422 Linux 3.0-rc6)
Merging xilinx/arm-next (b85a3ef ARM: Xilinx: Adding Xilinx board support)
Merging arm64/upstream (aeed41a arm64: fix alignment padding in assembly co=
de)
Merging blackfin/for-linus (d255e6f blackfin: Use Kbuild infrastructure for=
 kvm_para.h)
Merging c6x/for-linux-next (fbdd63d UAPI: (Scripted) Disintegrate arch/c6x/=
include/asm)
Merging cris/for-next (21a16be CRIS: locking: fix the return value of arch_=
read_trylock())
Merging hexagon/linux-next (e1858b2 Hexagon: Copyright marking changes)
Merging ia64/next (d536e0d Merge tag 'disintegrate-ia64-20121009' of git://=
git.infradead.org/users/dhowells/linux-headers into next)
Merging m68k/for-next (f82735d m68k: Use PTR_RET rather than if(IS_ERR(...)=
) + PTR_ERR)
Merging m68knommu/for-next (4dbfd6d m68k: switch to using the asm-generic s=
ocket.h)
CONFLICT (rename/delete): arch/m68k/include/uapi/asm/termbits.h deleted in =
m68knommu/for-next and renamed in HEAD. Version HEAD of arch/m68k/include/u=
api/asm/termbits.h left in tree.
CONFLICT (rename/delete): arch/m68k/include/uapi/asm/sockios.h deleted in m=
68knommu/for-next and renamed in HEAD. Version HEAD of arch/m68k/include/ua=
pi/asm/sockios.h left in tree.
CONFLICT (rename/delete): arch/m68k/include/uapi/asm/socket.h deleted in m6=
8knommu/for-next and renamed in HEAD. Version HEAD of arch/m68k/include/uap=
i/asm/socket.h left in tree.
CONFLICT (rename/delete): arch/m68k/include/uapi/asm/shmbuf.h deleted in m6=
8knommu/for-next and renamed in HEAD. Version HEAD of arch/m68k/include/uap=
i/asm/shmbuf.h left in tree.
CONFLICT (rename/delete): arch/m68k/include/uapi/asm/sembuf.h deleted in m6=
8knommu/for-next and renamed in HEAD. Version HEAD of arch/m68k/include/uap=
i/asm/sembuf.h left in tree.
CONFLICT (rename/delete): arch/m68k/include/uapi/asm/msgbuf.h deleted in m6=
8knommu/for-next and renamed in HEAD. Version HEAD of arch/m68k/include/uap=
i/asm/msgbuf.h left in tree.
CONFLICT (rename/delete): arch/m68k/include/uapi/asm/auxvec.h deleted in m6=
8knommu/for-next and renamed in HEAD. Version HEAD of arch/m68k/include/uap=
i/asm/auxvec.h left in tree.
CONFLICT (modify/delete): arch/m68k/include/asm/termios.h deleted in m68kno=
mmu/for-next and modified in HEAD. Version HEAD of arch/m68k/include/asm/te=
rmios.h left in tree.
$ git rm -f arch/m68k/include/asm/termios.h arch/m68k/include/uapi/asm/auxv=
ec.h arch/m68k/include/uapi/asm/msgbuf.h arch/m68k/include/uapi/asm/sembuf.=
h arch/m68k/include/uapi/asm/shmbuf.h arch/m68k/include/uapi/asm/socket.h a=
rch/m68k/include/uapi/asm/sockios.h arch/m68k/include/uapi/asm/termbits.h
Applying: m68k: fix up for UAPI changes
Merging microblaze/next (1883baa UAPI: (Scripted) Disintegrate arch/microbl=
aze/include/asm)
Merging mips/mips-for-linux-next (3f35ead Merge branch 'next/p1/for-linus' =
into mips-for-linux-next)
Merging openrisc/for-upstream (6257c57 Merge tag 'disintegrate-openrisc-201=
21009' of git://git.infradead.org/users/dhowells/linux-headers)
Merging parisc/for-next (559fd14 Merge tag 'disintegrate-parisc-20121016' i=
nto for-next)
Merging powerpc/next (83dac59 cpuidle/powerpc: Fix snooze state problem in =
the cpuidle design on pseries.)
Merging 4xx/next (2074b1d powerpc: Fix irq distribution)
Merging mpc5xxx/next (fa9b24a powerpc/mpc5200: move lpbfifo node and fix it=
s interrupt property)
Merging galak/next (10bfa76 driver/mtd:IFC NAND:Initialise internal SRAM be=
fore any write)
Merging s390/features (c00bd7d s390/traps: preinitialize program check tabl=
e)
Merging sh/sh-latest (0dd4d5c sh: Fix up more fallout from pointless ARM __=
iomem churn.)
Merging sparc-next/master (43c422e apparmor: fix apparmor OOPS in audit_log=
_untrustedstring+0x1c/0x40)
Merging tile/master (c19c6c9 arch/tile: enable interrupts in do_work_pendin=
g())
Merging unicore32/unicore32 (5d05622 unicore32: switch to generic sys_execv=
e())
Merging xtensa/for_next (8c32fab snapshot)
CONFLICT (content): Merge conflict in arch/xtensa/include/uapi/asm/unistd.h
Merging btrfs/next (f46dbe3 btrfs: init ref_index to zero in add_inode_ref)
Merging ceph/master (6285bc2 ceph: avoid 32-bit page index overflow)
Merging cifs/for-next (f51de01 cifs: extra sanity checking for cifs.idmap k=
eys)
Merging configfs/linux-next (b930c26 Merge branch 'for-linus' of git://git.=
kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (0d7614f Linux 3.6-rc1)
Merging ext3/for_next (6c29c50 quota: Silence warning about PRJQUOTA not be=
ing handled in need_print_warning())
Merging ext4/dev (c278531 ext4: fix ext4_flush_completed_IO wait semantics)
Merging fuse/for-next (c7a3f5e fuse: Move CUSE Kconfig entry from fs/Kconfi=
g into fs/fuse/Kconfig)
Merging gfs2/master (3bba80e GFS2: Speed up gfs2_rbm_from_block)
Merging jfs/jfs-next (4e7a4b0 jfs: Fix FITRIM argument handling)
Merging logfs/master (ab2ec19 logfs: fix possible memory leak in logfs_mtd_=
can_write_buf())
Merging nfs/linux-next (4369d32 lockd: Remove BUG_ON()s from fs/lockd/clntp=
roc.c)
Merging nfsd/nfsd-next (ddffeb8 Linux 3.7-rc1)
Merging ocfs2/linux-next (4538df6 ocfs2: Don't spam on -EDQUOT.)
Merging omfs/for-next (976d167 Linux 3.1-rc9)
Merging squashfs/master (4b0180a Squashfs: add mount time sanity check for =
block_size and block_log match)
Merging v9fs/for-next (552aad0 9P: Fix race between p9_write_work() and p9_=
fd_request())
Merging ubifs/linux-next (a74b6e4 UBIFS: fix mounting problems after power =
cuts)
Merging xfs/for-next (e04426b xfs: move allocation stack switch up to xfs_b=
mapi_allocate)
Merging vfs/for-next (a736427 missing const in alpha callers of do_mount())
Merging pci/next (78c8f84 Merge branch 'pci/yinghai-misc' into next)
Merging hid/for-next (5277e97 HID: roccat: allow readout of koneplus sensor=
 register data)
Merging quilt/i2c (13a2e9c i2c-i801: Fix comment)
Merging i2c-embedded/i2c-embedded/for-next (62885f5 MXS: Implement DMA supp=
ort into mxs-i2c)
Merging quilt/jdelvare-hwmon (12250d8 Merge branch 'i2c-embedded/for-next' =
of git://git.pengutronix.de/git/wsa/linux)
Merging hwmon-staging/hwmon-next (502d539 hwmon: DA9055 HWMON driver)
Merging v4l-dvb/master (c3a6417 Merge /home/v4l/v4l/for_upstream)
Merging kbuild/for-next (b974d36 Merge branch 'kbuild/kbuild' into kbuild/f=
or-next)
Merging kconfig/for-next (4eae518 localmodconfig: Fix localyesconfig to set=
 to 'y' not 'm')
Merging libata/NEXT (13b7408 sata_mv: Fix warnings when no PCI)
Merging infiniband/for-next (ddffeb8 Linux 3.7-rc1)
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
Merging thermal/next (6e77a58 thermal: user_space: Add missing static stora=
ge class specifiers)
Merging ieee1394/for-next (790198f firewire: cdev: fix user memory corrupti=
on (i386 userland on amd64 kernel))
Merging ubi/linux-next (ddffeb8 Linux 3.7-rc1)
Merging dlm/next (2b75bc9 dlm: check the maximum size of a request from use=
r)
Merging scsi/for-next (5c1b10a [SCSI] storvsc: Account for in-transit packe=
ts in the RESET path)
Merging target-updates/for-next (cf0eb28 iscsi-target: Bump defaults for no=
pin_timeout + nopin_response_timeout values)
Merging target-merge/for-next-merge (d987569 Linux 3.6-rc2)
Merging ibft/linux-next (935a9fe ibft: Fix finding IBFT ACPI table on UEFI)
Merging isci/all (6734092 isci: add a couple __iomem annotations)
Merging slave-dma/next (ddffeb8 Linux 3.7-rc1)
Merging dmaengine/next (a2bd114 netdma: adding alignment check for NETDMA o=
ps)
Merging net-next/master (72ec301 Merge branch 'master' of git://git.kernel.=
org/pub/scm/linux/kernel/git/jkirsher/net-next)
Merging wireless-next/master (9917c85 brcm80211: remove some truely barftas=
tic code)
CONFLICT (content): Merge conflict in net/mac80211/mlme.c
CONFLICT (content): Merge conflict in drivers/net/wireless/brcm80211/brcmfm=
ac/wl_cfg80211.c
Merging bluetooth/master (f706adf Bluetooth: AMP: Get amp_mgr reference in =
HS hci_conn)
Merging mtd/master (5a6ea4a mtd: ofpart: Fix incorrect NULL check in parse_=
ofoldpart_partitions())
Merging l2-mtd/master (9dfb519 jffs2: Fix lock acquisition order bug in jff=
s2_write_begin)
Merging crypto/master (ba1ee07 crypto: vmac - Make VMAC work when blocks ar=
en't aligned)
Merging drm/drm-next (1f31c69 Merge branch 'drm-intel-fixes' of git://peopl=
e.freedesktop.org/~danvet/drm-intel into drm-next)
Merging sound/for-next (7a75e74 ALSA: usb-audio: USB audio quirk for Roland=
 VG-99 advanced mode)
Merging sound-asoc/for-next (bd2f2ac Merge branch 'asoc-da9055' into asoc-n=
ext)
Merging modules/modules-next (7460bf4 powerpc: add finit_module syscall.)
CONFLICT (content): Merge conflict in kernel/module.c
Merging virtio/virtio-next (1609e71 virtio: tools: make it clear that virtq=
ueue_add_buf() no longer returns > 0)
Merging input/next (f6c0df6 Input: edt-ft5x06 - convert to use simple_open(=
))
Merging input-mt/for-next (6f0c058 Linux 3.7-rc2)
Merging cgroup/for-next (5a9423c Merge branch 'for-3.8' into for-next)
Merging block/for-next (454832b Merge branch 'for-3.7/drivers' into for-nex=
t)
CONFLICT (content): Merge conflict in init/Kconfig
Merging quilt/device-mapper (ddffeb8 Linux 3.7-rc1)
Merging embedded/master (4744b43 embedded: fix vc_translate operator preced=
ence)
Merging firmware/master (6e03a20 firmware: speed up request_firmware(), v3)
Merging pcmcia/master (80af9e6 pcmcia at91_cf: fix raw gpio number usage)
Merging mmc/mmc-next (b35a5c5 mmc: rtsx_pci_sdmmc: Add realtek pcie sdmmc h=
ost driver)
Merging kgdb/kgdb-next (58bcdf6 tty/console: fix warnings in drivers/tty/se=
rial/kgdboc.c)
Merging slab/for-next (837d678 slub: remove one code path and reduce lock c=
ontention in __slab_free())
Merging uclinux/for-next (ddffeb8 Linux 3.7-rc1)
Merging md/for-next (635a2a0 md/raid5: add blktrace calls)
Merging mfd/for-next (74d8378 ARM: dts: Enable 88pm860x pmic)
Merging battery/master (18766f0 Merge with upstream to accommodate with MFD=
 changes)
Merging fbdev/fbdev-next (cd9d6f1 gbefb: fix compile error)
Merging viafb/viafb-next (838ac78 viafb: avoid refresh and mode lookup in s=
et_par)
Merging omap_dss2/for-next (13b1ba7 OMAPDSS: add missing include for string=
.h)
Merging regulator/for-next (ee15eb4 Merge remote-tracking branches 'regulat=
or/topic/gpio', 'regulator/topic/lp8788', 'regulator/topic/max77686', 'regu=
lator/topic/tps51632', 'regulator/topic/tps65910' and 'regulator/topic/vexp=
ress' into regulator-next)
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
Merging iommu/next (0094872 Merge branches 'dma-debug', 'iommu/fixes', 'arm=
/tegra', 'arm/exynos', 'x86/amd', 'x86/vt-d' and 'x86/amd-irq-remapping' in=
to next)
Merging vfio/next (12250d8 Merge branch 'i2c-embedded/for-next' of git://gi=
t.pengutronix.de/git/wsa/linux)
Merging osd/linux-next (b6755ff osduld: Add osdname & systemid sysfs at scs=
i_osd class)
Merging jc_docs/docs-next (5c050fb docs: update the development process doc=
ument)
Merging trivial/for-next (db83101 iscsi: fix check keys)
Merging audit/for-next (dcd6c92 Linux 3.3-rc1)
Merging pm/linux-next (df5a2a1 Merge tag 'firewire-updates' of git://git.ke=
rnel.org/pub/scm/linux/kernel/git/ieee1394/linux1394)
Merging apm/for-next (fb9d78a Merge branch 'for-linus' of git://git.kernel.=
org/pub/scm/linux/kernel/git/jikos/apm)
Merging fsnotify/for-next (1aec9c0 inotify: automatically restart syscalls)
CONFLICT (content): Merge conflict in kernel/audit_tree.c
Merging edac/linux_next (cfe5031 edac: edac_mc no longer deals with kobject=
s directly)
Merging edac-amd/for-next (20fe26b MCE, AMD: Dump error status)
Merging devicetree/devicetree/next (efd68e7 devicetree: add helper inline f=
or retrieving a node's full name)
Merging dt-rh/for-next (205a8eb dtc: fix for_each_*() to skip first object =
if deleted)
Merging spi/spi/next (d8e328b spi: Add "spi:" prefix to modalias attribute =
of spi devices)
Merging spi-mb/spi-next (b4482af Merge branch 'spi-pl022' into spi-next)
Merging tip/auto-latest (0b2b7ed Merge branch 'perf/urgent')
Merging rcu/rcu/next (d677124 rcu: Advise most users not to enable RCU user=
 mode)
Merging cputime/cputime (c3e0ef9 [S390] fix cputime overflow in uptime_proc=
_show)
Merging uprobes/for-next (0326f5a uprobes/core: Handle breakpoint and singl=
estep exceptions)
Merging kvm/linux-next (03604b3 Merge branch 'for-upstream' of http://githu=
b.com/agraf/linux-2.6 into queue)
CONFLICT (content): Merge conflict in arch/powerpc/include/asm/kvm_para.h
CONFLICT (content): Merge conflict in arch/powerpc/include/asm/Kbuild
Applying: KVM: PPC: fix fallout from UAPI changes
Merging kvm-ppc/kvm-ppc-next (f37f444 KVM: PPC: Move mtspr/mfspr emulation =
into own functions)
Merging oprofile/for-next (4400910 oprofile, x86: Fix wrapping bug in op_x8=
6_get_ctrl())
Merging xen/upstream/xen (af3a3ab Merge git://git.kernel.org/pub/scm/linux/=
kernel/git/steve/gfs2-3.0-fixes)
Merging xen-two/linux-next (ad50261 Merge branch 'stable/for-linus-3.7' int=
o linux-next)
Merging xen-pvhvm/linux-next (b056b6a xen: suspend: remove xen_hvm_suspend)
Merging percpu/for-next (61011677 Merge tag 'dlm-3.5' of git://git.kernel.o=
rg/pub/scm/linux/kernel/git/teigland/linux-dlm)
Merging workqueues/for-next (cb11771 workqueue: trivial fix for return stat=
ement in work_busy())
Merging drivers-x86/linux-next (455f38c eeepc-laptop: fix device reference =
count leakage in eeepc_rfkill_hotplug())
Merging hwpoison/hwpoison (46e387b Merge branch 'hwpoison-hugepages' into h=
wpoison)
Merging sysctl/master (4e474a0 sysctl: protect poll() in entries that may g=
o away)
Merging regmap/for-next (97f99c4 Merge tag 'regmap-fix-mmio' into regmap-ne=
xt)
Merging hsi/for-next (43139a6 HSI: hsi_char: Update ioctl-number.txt)
Merging leds/for-next (2f73c39 leds: add output driver configuration for pc=
a9633 led driver)
Merging driver-core/driver-core-next (ddffeb8 Linux 3.7-rc1)
Merging tty/tty-next (ddffeb8 Linux 3.7-rc1)
Merging usb/usb-next (ddffeb8 Linux 3.7-rc1)
Merging staging/staging-next (2807dbe Staging: bcm: Remove null dereference=
 from InterfaceWRM.)
Merging char-misc/char-misc-next (ddffeb8 Linux 3.7-rc1)
Merging tmem/linux-next (a728d5e Merge commit 'v3.6-rc6' into linux-next)
Merging writeback/writeback-for-next (2f60d62 CPU hotplug, writeback: Don't=
 call writeback_set_ratelimit() too often during hotplug)
Merging arm-dt/devicetree/arm-next (ede338f dt: add documentation of ARM dt=
 boot interface)
Merging hwspinlock/linux-next (8b37fcf hwspinlock: add MAINTAINERS entries)
Merging pinctrl/for-next (76e81de Merge branch 'u300' into for-next)
Merging vhost/linux-next (e0953c8 tun: experimental zero copy tx support)
CONFLICT (content): Merge conflict in drivers/net/tun.c
Merging memblock/memblock-kill-early_node_map (7bd0b0f memblock: Reimplemen=
t memblock allocation using reverse free area iterator)
Merging remoteproc/for-next (ed26d19 remoteproc: fix (again) the virtio-rel=
ated build breakage)
Merging irqdomain/irqdomain/next (f5a1ad0 irqdomain: Improve diagnostics wh=
en a domain mapping fails)
Merging gpio/gpio/next (ddf343f Merge branch 'for-linus' of git://git.kerne=
l.org/pub/scm/linux/kernel/git/s390/linux)
Merging gpio-lw/for-next (a1cdd6b Merge branch 'devel' into for-next)
Merging arm-soc/for-next (357dde5 Merge branch 'fixes' into for-next)
Merging cortex/for-next (77a3018 Cortex-M3: Add support for exception handl=
ing)
Merging ep93xx/ep93xx-for-next (fab1f74 Merge branch 'ep93xx-fixes' into ep=
93xx-for-next)
Merging ixp4xx/next (b94740b IXP4xx: use __iomem for MMIO)
Merging msm/for-next (a0d271c Linux 3.6)
Merging renesas/next (d6dbf4c Merge branches 'heads/fixes', 'heads/defconfi=
g' and 'heads/boards' into next)
Merging samsung/for-next (9821dd9 Merge branch 'next/board-samsung' into fo=
r-next)
Merging tegra/for-next (cc8c1c9 Merge branch 'for-3.8/defconfig' into for-n=
ext)
Merging kvmtool/master (e7a74eb kvm tools: Fix SDL and VNC by adding defaul=
t vidmode)
Merging dma-mapping/dma-mapping-next (4751b85 ARM: mm: Remove unused arm_vm=
region priv field)
Merging pwm/for-next (85f8879 pwm: dt: Fix description of second PWM cell)
Merging dma-buf/for-next (ba42051 dma-buf: might_sleep() in dma_buf_unmap_a=
ttachment())
Merging userns/for-next (e9069f4 btrfs: Fix compilation with user namespace=
 support enabled)
Merging ktest/for-next (95f5783 ktest: Fix ELSE IF statements)
Merging signal/for-next (4188f2a Merge branches 'arch-parisc', 'arch-frv', =
'arch-powerpc', 'arch-s390' and 'no-rebases' into for-next)
Merging clk/clk-next (494bfec clk: add of_clk_src_onecell_get() support)
Merging random/dev (d2e7c96 random: mix in architectural randomness in extr=
act_buf())
Merging lzo-update/lzo-update (ba32bf9 lib/lzo: Do not leak implementation =
details in lzo1x_1_compress())
Merging scsi-post-merge/merge-base:master ()
$ git checkout akpm
Applying: memstick: remove unused field from state struct
Applying: memstick: ms_block: fix compile issue
Applying: memstick: use after free in msb_disk_release()
Applying: memstick: memory leak on error in msb_ftl_scan()
Applying: CRIS: Fix I/O macros
Applying: selinux: fix sel_netnode_insert() suspicious rcu dereference
Applying: vfs: d_obtain_alias() needs to use "/" as default name.
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
Applying: h8300: select generic atomic64_t support
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
Applying: swap: add a simple detector for inappropriate swapin readahead
Applying: swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix
Applying: mm/memblock: reduce overhead in binary search
Applying: compat: generic compat_sys_sched_rr_get_interval implementation
Applying: drivers/firmware/dmi_scan.c: check dmi version when get system uu=
id
Applying: drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid=
-fix
Applying: drivers/firmware/dmi_scan.c: fetch dmi version from SMBIOS if it =
exists
Applying: drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-ex=
ists-checkpatch-fixes
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
Applying: ipc/sem.c: alternatives to preempt_disable()
Applying: dma-debug: new interfaces to debug dma mapping errors
Applying: linux/compiler.h: add __must_hold macro for functions called with=
 a lock held
Merging akpm/master (a135440 linux/compiler.h: add __must_hold macro for fu=
nctions called with a lock held)

--Signature=_Mon__22_Oct_2012_15_36_12_+1100_aOsPz4i6s//XpniI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQhM08AAoJEECxmPOUX5FELKUQAJJHPBz4H5qaLM5Cc99grtYR
EaRFbdAycXdcWk3BHfL65Rs1u/drGXBlZWq9Fn/Xm1Pu6/nilr0+Ogo0ag1vwrNv
Z5vEIShXHfe2WuAjmr4JcSEpumyNGNQmo48oKx/1+PhVvie8sAJbHjp3GVMKfFmO
S0WI0Hp3pFF4JxvWmfzuhhZaJh8Xbfmgo5VNNmRAtl6hQaYSnWHMm0WdPSVMNwkV
THFDUqAaLvIzSf0aMSGdi7vpilXvYd7ww+ZKd/IIFYLY0ndniMuUvEVrSd1GKPIs
EOIt2RMIkTHNj9i5/qNtszLJArxLNga2pjyIFw1vle3QTMFDr3xnIWzXjwbolPAC
T9aDIY0keEJh19Os9koUlLBtDVZEw9io3bDongbshTFRSGOG1vUDMtlDer2EQL5W
4R1Ae0+qBLfN65pCfkMYeRTPUsqN9l9O4YH8C+MtmSewyjgPgijZA0B0Hq/3FnMg
+8c8PwQFeizqbb2pVxavmpW9jJ6e3ijrpmGZxUx3y9VJnMuXftHrMAGz2vnA7lBV
f4VhyEUFWGjUkvsn1M4RtyN4PfrS495IvLZBCTlqHcCxYX4n1nJh2J9TPP908hOg
17lv/jvCNnqPFZtBVTwrhiBVq4PT9BxtFntWJK12e+0lcvjvwU5Du8/Re2/ftwZO
fiGrNLpXuqKQSQ9zkkFK
=MYXM
-----END PGP SIGNATURE-----

--Signature=_Mon__22_Oct_2012_15_36_12_+1100_aOsPz4i6s//XpniI--

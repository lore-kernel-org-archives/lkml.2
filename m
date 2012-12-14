Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab2LNHme (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 02:42:34 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:34150 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250Ab2LNHma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 02:42:30 -0500
Date: Fri, 14 Dec 2012 18:42:16 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <linux-next@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Dec 14
Message-Id: <20121214184216.e05d715c71468f475d8bcfeb@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__14_Dec_2012_18_42_16_+1100_PrH4HZPAU/+jdui6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__14_Dec_2012_18_42_16_+1100_PrH4HZPAU/+jdui6
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20121213:

Lots of conflicts are migrating between trees.

The powerpc tree lost its build failure.

The xtensa tree gained a conflict against Linus' tree.

The akpm tree lost lots of commits that turned up elsewhere and lost its
build failure.

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

We are up to 214 trees (counting Linus' and 28 trees of patches pending
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
Merging origin/master (896ea17 Merge tag 'stable/for-linus-3.8-rc0-tag' of =
git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen)
Merging fixes/master (8041853 disable the SB105X driver)
Merging kbuild-current/rc-fixes (bad9955 menuconfig: Replace CIRCLEQ by lis=
t_head-style lists.)
Merging arm-current/fixes (810883f ARM: 7594/1: Add .smp entry for REALVIEW=
_EB)
Merging m68k-current/for-linus (5fec45a m68k/sun3: Fix instruction faults)
Merging powerpc-merge/merge (e716e01 powerpc/eeh: Do not invalidate PE prop=
erly)
Merging sparc/master (df2fc24 Merge branch 'fixes' of git://git.kernel.org/=
pub/scm/linux/kernel/git/rusty/linux)
Merging net/master (eca2a43 bridge: fix icmpv6 endian bug and other sparse =
warnings)
Merging sound-current/for-linus (d846b17 ALSA: hda - Fix build without CONF=
IG_PM)
Merging pci-current/for-linus (ff8e59b PCI/portdrv: Don't create hotplug sl=
ots unless port supports hotplug)
Merging wireless/master (6bdd253 mac80211: fix remain-on-channel (non-)canc=
elling)
Merging driver-core.current/driver-core-linus (6be35c7 Merge git://git.kern=
el.org/pub/scm/linux/kernel/git/davem/net-next)
Merging tty.current/tty-linus (1ebaf4f Merge branch 'x86-timers-for-linus' =
of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip)
Merging usb.current/usb-linus (1ebaf4f Merge branch 'x86-timers-for-linus' =
of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip)
Merging staging.current/staging-linus (1ebaf4f Merge branch 'x86-timers-for=
-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip)
Merging char-misc.current/char-misc-linus (1ebaf4f Merge branch 'x86-timers=
-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip)
Merging input-current/for-linus (e12b3ce Input: wacom - fix touch support f=
or Bamboo Fun CTH-461)
Merging md-current/for-linus (749586b md/raid5: use async_tx_quiesce() inst=
ead of open-coding it.)
Merging audit-current/for-linus (c158a35 audit: no leading space in audit_l=
og_d_path prefix)
Merging crypto-current/master (9efade1 crypto: cryptd - disable softirqs in=
 cryptd_queue_worker to prevent data corruption)
Merging ide/master (9974e43 ide: fix generic_ide_suspend/resume Oops)
Merging dwmw2/master (03a0b4c solos-pci: fix double-free of TX skb in DMA m=
ode)
CONFLICT (content): Merge conflict in arch/x86/Kconfig.cpu
CONFLICT (content): Merge conflict in arch/x86/Kconfig
CONFLICT (content): Merge conflict in arch/powerpc/Kconfig
Merging sh-current/sh-fixes-for-linus (4403310 SH: Convert out[bwl] macros =
to inline functions)
Merging irqdomain-current/irqdomain/merge (a0d271c Linux 3.6)
Merging devicetree-current/devicetree/merge (0e622d3 of/address: sparc: Dec=
lare of_iomap as an extern function for sparc again)
Merging spi-current/spi/merge (a0d271c Linux 3.6)
Merging gpio-current/gpio/merge (96b7064 gpio/tca6424: merge I2C transactio=
ns, remove cast)
Merging rr-fixes/fixes (f3537f9 ASN.1: Fix an indefinite length skip error)
Merging asm-generic/master (fb9de7e xtensa: Use generic asm/mmu.h for nommu)
Merging arm/for-next (cd1ad1c Merge branch 'devel-stable' into for-next)
Merging arm-perf/for-next/perf (3d70f8c Linux 3.7-rc4)
Merging davinci/davinci-next (fe0d422 Linux 3.0-rc6)
Merging xilinx/arm-next (8d32044 ARM: zynq: Remove all unused mach headers)
CONFLICT (content): Merge conflict in drivers/tty/serial/xilinx_uartps.c
CONFLICT (content): Merge conflict in arch/arm/Kconfig.debug
Merging arm64/upstream (d19766e arm64: Update the MAINTAINERS entry)
Merging blackfin/for-linus (4452fec Blackfin: dpmc: use module_platform_dri=
ver macro)
Merging c6x/for-linux-next (93bbd0c c6x: use generic kvm_para.h)
Merging cris/for-next (eacb25c UAPI: Fix up empty files in arch/cris/)
CONFLICT (content): Merge conflict in arch/cris/include/asm/signal.h
Merging hexagon/linux-next (e1858b2 Hexagon: Copyright marking changes)
Merging ia64/next (7843ae0 Merge branch 'pstore_mevent' into next)
Merging m68k/for-next (5fec45a m68k/sun3: Fix instruction faults)
Merging m68knommu/for-next (280ef31 m68knommu: modify clock code so it can =
be used by all ColdFire CPU types)
Merging microblaze/next (4378bb6 microblaze: signal: Declare do_notify_resu=
me)
Merging mips/mips-for-linux-next (241738b Merge branch 'mips-next' of http:=
//dev.phrozen.org/githttp/mips-next into mips-for-linux-next)
CONFLICT (content): Merge conflict in include/linux/bcma/bcma_driver_chipco=
mmon.h
Merging openrisc/for-upstream (634bd40 openrisc: use kbuild.h instead of de=
fining macros in asm-offset.c)
Merging parisc/for-next (949a05d [PARISC] fix virtual aliasing issue in get=
_shared_area())
Merging powerpc/next (d526e85 powerpc+of: Rename and fix OF reconfig notifi=
er error inject module)
CONFLICT (content): Merge conflict in lib/Kconfig.debug
CONFLICT (content): Merge conflict in arch/powerpc/kernel/entry_64.S
Applying: ARM: OMAP: fix build error in arch/arm/mach-omap2/timer.c
Merging 4xx/next (2074b1d powerpc: Fix irq distribution)
Merging mpc5xxx/next (667b504 powerpc: mpc5200: Add a3m071 board support)
Merging galak/next (1723d90 powerpc/dma/raidengine: add raidengine device)
Merging s390/features (6726a80 s390/qdio: rename the misleading PCI flag of=
 qdio devices)
Merging sh/sh-latest (0dd4d5c sh: Fix up more fallout from pointless ARM __=
iomem churn.)
Merging sparc-next/master (476ab8f of_i2c: sparc: Allow OF_I2C for sparc)
Merging tile/master (e2f2950 tile/PCI: use for_each_pci_dev to simplify the=
 code)
Merging unicore32/unicore32 (c284464 arch/unicore32: remove CONFIG_EXPERIME=
NTAL)
Merging xtensa/for_next (e4eb837 xtensa: set the correct ethernet address f=
or xtfpga)
CONFLICT (content): Merge conflict in arch/xtensa/kernel/process.c
CONFLICT (content): Merge conflict in arch/xtensa/Kconfig
Merging btrfs/next (c37b2b6 Btrfs: do not bug when we fail to commit the tr=
ansaction)
Merging ceph/master (3515297 rbd: activate v2 image support)
Merging cifs/for-next (c299dd0 CIFS: Fix write after setting a read lock fo=
r read oplock files)
Merging configfs/linux-next (b930c26 Merge branch 'for-linus' of git://git.=
kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (e4bc652 eCryptfs: Avoid unnecessary disk read and da=
ta decryption during writing)
Merging ext3/for_next (56df127 quota: Use the pre-processor to compile out =
quotactl_cmd_write when !CONFIG_BLOCK)
Merging ext4/dev (bd9926e ext4: zero out inline data using memset() instead=
 of empty_zero_page)
Merging f2fs/dev (6666e6a f2fs: fix tracking parent inode number)
Merging fuse/for-next (23ab0c7 cuse: do not register multiple devices with =
identical names)
Merging gfs2/master (1e2d9d4 GFS2: Set gl_object during inode create)
Merging jfs/jfs-next (4e7a4b0 jfs: Fix FITRIM argument handling)
Merging logfs/master (3394661 Fix the call to BUG() caused by no free segme=
nt found)
Merging nfs/linux-next (48d7a57 nfs: Remove unused list nfs4_clientid_list)
Merging nfsd/nfsd-next (88c4766 nfsd: pass proper net to nfsd_destroy() fro=
m NFSd kthreads)
Merging ocfs2/linux-next (4538df6 ocfs2: Don't spam on -EDQUOT.)
Merging omfs/for-next (976d167 Linux 3.1-rc9)
Merging squashfs/master (4b0180a Squashfs: add mount time sanity check for =
block_size and block_log match)
Merging v9fs/for-next (552aad0 9P: Fix race between p9_write_work() and p9_=
fd_request())
Merging ubifs/linux-next (a28ad42 UBIFS: fix mounting problems after power =
cuts)
Merging xfs/for-next (f9668a0 xfs: fix sparse reported log CRC endian issue)
Merging vfs/for-next (a77cfcb fix off-by-one in argument passed by iterate_=
fd() to callbacks)
Merging pci/next (1cb73f8 Merge branch 'pci/mjg-pci-roms-from-efi' into nex=
t)
Merging hid/for-next (01c4f7e Merge branch 'for-3.8/i2c-hid' into for-next)
Merging i2c/master (c1ec1ae i2c: Mention functionality flags in SMBus proto=
col documentation)
Merging i2c-embedded/i2c-embedded/for-next (972deb4 i2c: omap: Remove the O=
MAP_I2C_FLAG_RESET_REGS_POSTIDLE flag)
CONFLICT (content): Merge conflict in drivers/i2c/busses/i2c-omap.c
CONFLICT (content): Merge conflict in arch/arm/plat-omap/i2c.c
Merging jdelvare-hwmon/master (d2d9cf3 hwmon: (it87) Support PECI for addit=
ional chips)
Merging hwmon-staging/hwmon-next (c996b9d hwmon: (twl4030-madc-hwmon) Fix w=
arning message caused by removal of __devexit)
Merging v4l-dvb/master (db46f44 Merge /home/v4l/v4l/for_upstream)
Merging kbuild/for-next (3868a5e Merge branch 'kbuild/misc' into kbuild/for=
-next)
Merging kconfig/for-next (4eae518 localmodconfig: Fix localyesconfig to set=
 to 'y' not 'm')
Merging libata/NEXT (84043ac pata_of_platform: fix compile error)
Merging infiniband/for-next (01e0336 Merge branch 'nes' into for-next)
CONFLICT (content): Merge conflict in drivers/net/ethernet/mellanox/mlx4/en=
_rx.c
Merging pstore/master (ebacfd1 pstore/ftrace: Adjust for ftrace_ops->func p=
rototype change)
Merging acpi/next (55f1f545 tools: Allow tools to be installed in a user sp=
ecified location)
Merging cpuidle/cpuidle-next (3cf7997 acpi: intel_idle : break dependency b=
etween modules)
CONFLICT (content): Merge conflict in drivers/cpuidle/cpuidle.c
CONFLICT (add/add): Merge conflict in drivers/cpuidle/coupled.c
CONFLICT (content): Merge conflict in drivers/cpuidle/Makefile
CONFLICT (content): Merge conflict in drivers/cpuidle/Kconfig
CONFLICT (content): Merge conflict in drivers/acpi/processor_driver.c
Applying: cpuidle: fix mismerge
Merging cpupowerutils/master (f166033 cpupower tools: add install target to=
 the debug tools' makefiles)
Merging thermal/next (d12250e thermal: rcar: add rcar_zone_to_priv() macro)
Merging ieee1394/for-next (db2cad2 firewire: net: remove unused variable in=
 fwnet_receive_broadcast())
Merging ubi/linux-next (eab7377 UBI: embed ubi_debug_info field in ubi_devi=
ce struct)
Merging dlm/next (da8c666 dlm: fix lvb invalidation conditions)
Merging swiotlb/linux-next (af51a9f swiotlb: Do not export swiotlb_bounce s=
ince there are no external consumers)
Merging scsi/for-next (f92363d [SCSI] mpt3sas: add new driver supporting 12=
GB SAS)
Merging target-updates/for-next (79e62fc target/iscsi_target: Add NodeACL t=
ags for initiator group support)
CONFLICT (content): Merge conflict in drivers/target/target_core_transport.c
Merging target-merge/for-next-merge (6f0c058 Linux 3.7-rc2)
Merging ibft/linux-next (935a9fe ibft: Fix finding IBFT ACPI table on UEFI)
Merging isci/all (6734092 isci: add a couple __iomem annotations)
Merging slave-dma/next (fa774f8 dmaengine/dmatest: terminate transfers only=
 in case of errors)
CONFLICT (content): Merge conflict in drivers/dma/dw_dmac.c
CONFLICT (content): Merge conflict in arch/arm/boot/dts/spear1340.dtsi
Merging dmaengine/next (a2bd114 netdma: adding alignment check for NETDMA o=
ps)
Merging net-next/master (6be35c7 Merge git://git.kernel.org/pub/scm/linux/k=
ernel/git/davem/net-next)
Merging wireless-next/master (c66cfd5 Merge branch 'for-john' of git://git.=
sipsolutions.net/mac80211-next)
Merging bluetooth/master (3101c536 Bluetooth: Remove unnecessary include l2=
cap.h)
Merging mtd/master (35f95d2 Merge tag 'for-linus-20121123' of git://git.inf=
radead.org/mtd-2.6)
Merging l2-mtd/master (d4d4f1b mtd: nand: typo in nand_id_has_period() comm=
ents)
CONFLICT (content): Merge conflict in drivers/mtd/nand/mxc_nand.c
CONFLICT (content): Merge conflict in arch/arm/mach-nomadik/board-nhk8815.c
CONFLICT (content): Merge conflict in Documentation/devicetree/bindings/arm=
/davinci/nand.txt
Merging crypto/master (a2c0911 crypto: caam - Updated SEC-4.0 device tree b=
inding for ERA information.)
Merging drm/drm-next (9add1ac Merge branch 'drm-next-3.8' of git://people.f=
reedesktop.org/~agd5f/linux into drm-next)
Merging sound/for-next (6eb827d ALSA: hda - Move runtime PM check to runtim=
e_idle callback)
Merging sound-asoc/for-next (4465959 Merge remote-tracking branch 'asoc/top=
ic/cs42l73' into asoc-next)
Merging modules/modules-next (005e62d MODSIGN: Fix kbuild output when using=
 default extra_certificates)
Merging virtio/virtio-next (55ef865 virtio: add drv_to_virtio to make code =
clearly)
CONFLICT (content): Merge conflict in drivers/virtio/virtio_balloon.c
CONFLICT (content): Merge conflict in drivers/net/virtio_net.c
Applying: virtnet: for up for virtqueue_get_queue_index removal
Merging input/next (da5ee07 Input: gpio_keys_polled - switch to using gpio_=
request_one())
CONFLICT (content): Merge conflict in arch/arm/mach-ux500/board-mop500-stui=
b.c
Merging input-mt/for-next (6f0c058 Linux 3.7-rc2)
Merging cgroup/for-next (15ef4ff cgroup: update Documentation/cgroups/00-IN=
DEX)
Merging block/for-next (1e374c8d Merge branch 'for-3.8/core' into for-next)
CONFLICT (content): Merge conflict in block/blk-exec.c
Merging device-mapper/master (3b96221 If the parameter buffer is small enou=
gh, try to allocate it with kmalloc() rather than vmalloc().)
Merging embedded/master (4744b43 embedded: fix vc_translate operator preced=
ence)
Merging firmware/master (6e03a20 firmware: speed up request_firmware(), v3)
Merging pcmcia/master (80af9e6 pcmcia at91_cf: fix raw gpio number usage)
Merging mmc/mmc-next (6be35c7 Merge git://git.kernel.org/pub/scm/linux/kern=
el/git/davem/net-next)
Merging kgdb/kgdb-next (58bcdf6 tty/console: fix warnings in drivers/tty/se=
rial/kgdboc.c)
Merging slab/for-next (ce343df Merge branch 'slab/next' into for-next)
CONFLICT (content): Merge conflict in mm/slob.c
Merging uclinux/for-next (b69f085 Linux 3.7-rc8)
Merging md/for-next (20b4fa3 md/raid5: add blktrace calls)
Merging mfd/for-next (1881b68 mfd: tps6507x: Convert to devm_kzalloc)
CONFLICT (content): Merge conflict in include/linux/mfd/tps65090.h
CONFLICT (content): Merge conflict in drivers/power/da9052-battery.c
CONFLICT (add/add): Merge conflict in drivers/mmc/host/rtsx_pci_sdmmc.c
CONFLICT (content): Merge conflict in drivers/mmc/host/Kconfig
CONFLICT (content): Merge conflict in drivers/mfd/twl-core.c
CONFLICT (content): Merge conflict in drivers/mfd/tps65090.c
CONFLICT (content): Merge conflict in drivers/mfd/sta2x11-mfd.c
CONFLICT (add/add): Merge conflict in drivers/mfd/rtsx_pcr.c
CONFLICT (content): Merge conflict in drivers/mfd/da9052-core.c
CONFLICT (content): Merge conflict in drivers/mfd/ab8500-core.c
CONFLICT (content): Merge conflict in drivers/mfd/Makefile
CONFLICT (modify/delete): drivers/input/touchscreen/ti_tscadc.c deleted in =
mfd/for-next and modified in HEAD. Version HEAD of drivers/input/touchscree=
n/ti_tscadc.c left in tree.
CONFLICT (content): Merge conflict in drivers/iio/adc/Makefile
CONFLICT (content): Merge conflict in drivers/iio/adc/Kconfig
CONFLICT (content): Merge conflict in drivers/gpio/gpio-tps6586x.c
$ git rm -f drivers/input/touchscreen/ti_tscadc.c
Merging battery/master (76d8a23 Merge git://git.kernel.org/pub/scm/linux/ke=
rnel/git/torvalds/linux)
CONFLICT (content): Merge conflict in drivers/power/Kconfig
Merging fbdev/fbdev-next (cd9d6f1 gbefb: fix compile error)
Merging viafb/viafb-next (838ac78 viafb: avoid refresh and mode lookup in s=
et_par)
Merging omap_dss2/for-next (e7f5c9a Merge tag 'omapdss-for-3.8' of git://gi=
torious.org/linux-omap-dss2/linux into for-linus)
CONFLICT (content): Merge conflict in drivers/media/platform/omap/omap_vout=
.c
CONFLICT (modify/delete): arch/arm/plat-omap/common.c deleted in HEAD and m=
odified in omap_dss2/for-next. Version omap_dss2/for-next of arch/arm/plat-=
omap/common.c left in tree.
CONFLICT (content): Merge conflict in arch/arm/mach-davinci/devices-da8xx.c
$ git rm -f arch/arm/plat-omap/common.c
Applying: OMAP: common.c: remove init call to vram fixup
Merging regulator/for-next (4ffc45c Merge remote-tracking branch 'regulator=
/topic/sm8767' into regulator-next)
Merging security/next (c91c1bf Smack: create a sysfs mount point for smackf=
s)
CONFLICT (content): Merge conflict in security/keys/process_keys.c
CONFLICT (content): Merge conflict in security/keys/keyring.c
CONFLICT (content): Merge conflict in security/keys/keyctl.c
CONFLICT (content): Merge conflict in net/dns_resolver/dns_key.c
CONFLICT (content): Merge conflict in fs/cifs/cifsacl.c
Merging selinux/master (c2d7b24 Merge tag 'v3.4' into 20120409)
Merging lblnet/master (7e27d6e Linux 2.6.35-rc3)
Merging watchdog/master (206e811 watchdog: sp805_wdt.c: use clk_prepare_ena=
ble and clk_disable_unprepare)
Merging dwmw2-iommu/master (c3b92c8 Linux 3.1)
Merging iommu/next (4cb412e Merge branches 'iommu/fixes', 'dma-debug', 'x86=
/amd', 'x86/vt-d', 'arm/tegra' and 'arm/omap' into next)
CONFLICT (modify/delete): arch/arm/mach-omap2/clock44xx_data.c deleted in H=
EAD and modified in iommu/next. Version iommu/next of arch/arm/mach-omap2/c=
lock44xx_data.c left in tree.
$ git rm -f arch/arm/mach-omap2/clock44xx_data.c
Merging vfio/next (9a92c50 vfio-pci: Enable device before attempting reset)
Merging osd/linux-next (b6755ff osduld: Add osdname & systemid sysfs at scs=
i_osd class)
Merging jc_docs/docs-next (5c050fb docs: update the development process doc=
ument)
Merging trivial/for-next (106f9d9 HOWTO: fix double words typo)
Merging audit/for-next (dcd6c92 Linux 3.3-rc1)
Merging pm/linux-next (f316fc5 Merge branch 'acpi-enumeration')
Merging apm/for-next (fb9d78a Merge branch 'for-linus' of git://git.kernel.=
org/pub/scm/linux/kernel/git/jikos/apm)
Merging fsnotify/for-next (1ca39ab inotify: automatically restart syscalls)
Merging edac/linux_next (c215786 Merge branch 'fixes' into next)
Merging edac-amd/for-next (3bfe5aa EDAC, pci_sysfs: Use for_each_pci_dev to=
 simplify the code)
Merging devicetree/devicetree/next (93c667c of: *node argument to of_parse_=
phandle_with_args should be const)
Merging dt-rh/for-next (58fea35 arm64: Fix the dtbs target building)
Merging spi/spi/next (7cb9436 spi/sparc: Allow of_register_spi_devices for =
sparc)
Merging spi-mb/spi-next (227c4ce spi: omap2-mcspi: remove duplicate inclusi=
on of linux/err.h)
Merging tip/auto-latest (ab81929 Merge branch 'linus')
Merging ftrace/for-next (2faffc4 Merge branch 'trace/tip/perf/urgent' into =
trace/for-next)
Merging rcu/rcu/next (91d1aa43 context_tracking: New context tracking susbs=
ystem)
Merging cputime/cputime (c3e0ef9 [S390] fix cputime overflow in uptime_proc=
_show)
Merging uprobes/for-next (0326f5a uprobes/core: Handle breakpoint and singl=
estep exceptions)
Merging kvm/linux-next (58b7825 KVM: emulator: fix real mode segment checks=
 in address linearization)
CONFLICT (content): Merge conflict in kernel/sched/core.c
Merging kvm-ppc/kvm-ppc-next (916773d KVM: PPC: Fix SREGS documentation ref=
erence)
Merging oprofile/for-next (4400910 oprofile, x86: Fix wrapping bug in op_x8=
6_get_ctrl())
Merging fw-cputime/cputime/adjustment-v2 (fa09205 cputime: Comment cputime'=
s adjusting code)
Merging fw-sched/sched/cputime-v2 (1b2852b vtime: Warn if irqs aren't disab=
led on system time accounting APIs)
Merging fw-nohz/nohz/printk-v8 (74876a9 printk: Wake up klogd using irq_wor=
k)
Merging xen/upstream/xen (af3a3ab Merge git://git.kernel.org/pub/scm/linux/=
kernel/git/steve/gfs2-3.0-fixes)
Merging xen-two/linux-next (76c0672 Merge branch 'stable/pvh.v7' into linux=
-next)
CONFLICT (content): Merge conflict in arch/arm/xen/enlighten.c
Merging xen-pvhvm/linux-next (b056b6a xen: suspend: remove xen_hvm_suspend)
Merging percpu/for-next (5479c78 mm, percpu: Make sure percpu_alloc early p=
arameter has an argument)
Merging workqueues/for-next (dca69d5 Merge branch 'for-3.7-fixes' into for-=
next)
Merging drivers-x86/linux-next (455f38c eeepc-laptop: fix device reference =
count leakage in eeepc_rfkill_hotplug())
Merging hwpoison/hwpoison (46e387b Merge branch 'hwpoison-hugepages' into h=
wpoison)
Merging sysctl/master (4e474a0 sysctl: protect poll() in entries that may g=
o away)
Merging regmap/for-next (7c8a299 Merge remote-tracking branch 'regmap/topic=
/type' into regmap-next)
Merging hsi/for-next (43139a6 HSI: hsi_char: Update ioctl-number.txt)
Merging leds/for-next (2f05e1d leds: leds-lp5521: return an error code on e=
rror in probe())
Merging driver-core/driver-core-next (6be35c7 Merge git://git.kernel.org/pu=
b/scm/linux/kernel/git/davem/net-next)
Merging tty/tty-next (1ebaf4f Merge branch 'x86-timers-for-linus' of git://=
git.kernel.org/pub/scm/linux/kernel/git/tip/tip)
Merging usb/usb-next (1ebaf4f Merge branch 'x86-timers-for-linus' of git://=
git.kernel.org/pub/scm/linux/kernel/git/tip/tip)
Merging staging/staging-next (1ebaf4f Merge branch 'x86-timers-for-linus' o=
f git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip)
Merging char-misc/char-misc-next (962b686 Merge tag 'pull_req_20121122' of =
git://git.kernel.org/pub/scm/linux/kernel/git/mzx/extcon into char-misc-nex=
t)
Merging tmem/linux-next (8f0d816 Linux 3.7-rc3)
Merging writeback/writeback-for-next (2f60d62 CPU hotplug, writeback: Don't=
 call writeback_set_ratelimit() too often during hotplug)
Merging arm-dt/devicetree/arm-next (ede338f dt: add documentation of ARM dt=
 boot interface)
Merging hwspinlock/linux-next (8b37fcf hwspinlock: add MAINTAINERS entries)
Merging pinctrl/for-next (8b9e992 Merge branch 'devel' into for-next)
Merging vhost/linux-next (0e9ff68 vhost-blk: add eventfd dependency)
Merging memblock/memblock-kill-early_node_map (7bd0b0f memblock: Reimplemen=
t memblock allocation using reverse free area iterator)
Merging remoteproc/for-next (6f0c058 Linux 3.7-rc2)
Merging irqdomain/irqdomain/next (023bba3 irqdomain: update documentation)
Merging gpio/gpio/next (fc13d5a gpio: Provide the STMPE GPIO driver with it=
s own IRQ Domain)
Merging gpio-lw/for-next (fc13d5a gpio: Provide the STMPE GPIO driver with =
its own IRQ Domain)
Merging arm-soc/for-next (47f4676 Merge branch 'next/soc' into for-next)
CONFLICT (content): Merge conflict in drivers/dma/mv_xor.c
CONFLICT (content): Merge conflict in drivers/clocksource/Kconfig
CONFLICT (content): Merge conflict in arch/arm/mach-ux500/cpu-db8500.c
CONFLICT (content): Merge conflict in arch/arm/mach-spear13xx/spear13xx.c
CONFLICT (content): Merge conflict in arch/arm/mach-spear13xx/spear1310.c
CONFLICT (content): Merge conflict in arch/arm/boot/dts/spear13xx.dtsi
CONFLICT (content): Merge conflict in arch/arm/boot/dts/spear1340.dtsi
CONFLICT (content): Merge conflict in arch/arm/boot/dts/imx53.dtsi
CONFLICT (content): Merge conflict in arch/arm/boot/dts/imx51.dtsi
CONFLICT (content): Merge conflict in arch/arm/boot/dts/Makefile
Merging bcm2835/for-next (d7f292e Merge branch 'for-3.8/defconfig' into for=
-next)
Merging cortex/for-next (77a3018 Cortex-M3: Add support for exception handl=
ing)
CONFLICT (content): Merge conflict in arch/arm/kernel/process.c
Merging ep93xx/ep93xx-for-next (cf92d86 Merge branch 'ep93xx-fixes' into ep=
93xx-for-next)
Merging ixp4xx/next (b94740b IXP4xx: use __iomem for MMIO)
Merging msm/for-next (a0d271c Linux 3.6)
Merging renesas/next (4bde5ac Merge branches 'heads/fixes', 'heads/defconfi=
g', 'heads/boards3', 'heads/soc5' and 'heads/maintainers'; commit 'ab6f6d85=
210c4d0265cf48e9958c04e08595055a' into next)
Merging samsung/for-next (d1a8169 Merge branch 'next/cleanup-samsung-3' int=
o for-next)
CONFLICT (content): Merge conflict in arch/arm/mach-exynos/mach-exynos5-dt.c
CONFLICT (content): Merge conflict in arch/arm/boot/dts/exynos5250.dtsi
CONFLICT (content): Merge conflict in arch/arm/boot/dts/exynos5250-smdk5250=
.dts
CONFLICT (content): Merge conflict in arch/arm/boot/dts/Makefile
Merging tegra/for-next (3c8d1fc Merge branch 'for-3.8/fixes-for-rc1' into f=
or-next)
Merging kvmtool/master (5f2ad67 kvm tools: remove max_high field in rb_int_=
node structure)
Merging dma-mapping/dma-mapping-next (4009793 drivers: cma: represent physi=
cal addresses as phys_addr_t)
Merging pwm/for-next (8fc6d09 pwm: lpc32xx: Set the chip base for dynamic a=
llocation)
CONFLICT (modify/delete): drivers/pwm/pwm-twl6030.c deleted in pwm/for-next=
 and modified in HEAD. Version HEAD of drivers/pwm/pwm-twl6030.c left in tr=
ee.
CONFLICT (content): Merge conflict in drivers/pwm/pwm-tiehrpwm.c
CONFLICT (content): Merge conflict in drivers/pwm/pwm-tiecap.c
$ git rm -f drivers/pwm/pwm-twl6030.c
Merging dma-buf/for-next (ba42051 dma-buf: might_sleep() in dma_buf_unmap_a=
ttachment())
Merging userns/for-next (98f842e proc: Usable inode numbers for the namespa=
ce file descriptors.)
CONFLICT (content): Merge conflict in kernel/nsproxy.c
CONFLICT (content): Merge conflict in include/net/net_namespace.h
Merging ktest/for-next (95f5783 ktest: Fix ELSE IF statements)
Merging signal/for-next (541880d do_coredump(): get rid of pt_regs argument)
Merging clk/clk-next (8f87189 MAINTAINERS: bad email address for Mike Turqu=
ette)
Merging random/dev (ec8f02da random: prime last_data value per fips require=
ments)
Merging lzo-update/lzo-update (ba32bf9 lib/lzo: Do not leak implementation =
details in lzo1x_1_compress())
Merging drop-experimental/linux-next (dddaa92 tools/lguest: remove depends =
on CONFIG_EXPERIMENTAL)
CONFLICT (content): Merge conflict in net/dsa/Kconfig
CONFLICT (content): Merge conflict in drivers/ptp/Kconfig
CONFLICT (content): Merge conflict in drivers/net/ethernet/intel/Kconfig
Merging scsi-post-merge/merge-base:master ()
Merging akpm-current/current (1afa471 Merge tag 'mmc-fixes-for-3.7' of git:=
//git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc)
$ git checkout akpm
Applying: CRIS: Fix I/O macros
Applying: vfs: d_obtain_alias() needs to use "/" as default name.
Applying: fs/block_dev.c: page cache wrongly left invalidated after revalid=
ate_disk()
Applying: arch/x86/platform/iris/iris.c: register a platform device and a p=
latform driver
Applying: x86 numa: don't check if node is NUMA_NO_NODE
Applying: arch/x86/tools/insn_sanity.c: identify source of messages
Applying: arch/x86/platform/uv: fix incorrect tlb flush all issue
Applying: olpc: fix olpc-xo1-sci.c build errors
Applying: x86: convert update_mmu_cache() and update_mmu_cache_pmd() to fun=
ctions
Applying: x86: fix the argument passed to sync_global_pgds()
Applying: arch/x86/kernel/cpu/perf_event_p6.c: fix section warning
Applying: x86: make 'mem=3D' option to work for efi platform
Applying: audit: create explicit AUDIT_SECCOMP event type
Applying: audit: catch possible NULL audit buffers
Applying: ceph: fix dentry reference leak in ceph_encode_fh()
Applying: cris: Use "int" for ssize_t to match size_t
Applying: pcmcia: move unbind/rebind into dev_pm_ops.complete
Applying: fb: rework locking to fix lock ordering on takeover
Applying: fb-rework-locking-to-fix-lock-ordering-on-takeover-fix
Applying: cyber2000fb: avoid palette corruption at higher clocks
Applying: irq: tsk->comm is an array
Applying: timeconst.pl: remove deprecated defined(@array)
Applying: time: don't inline EXPORT_SYMBOL functions
Applying: Coccinelle: add api/d_find_alias.cocci
Applying: h8300: select generic atomic64_t support
Applying: mm, mempolicy: introduce spinlock to read shared policy tree
Applying: drivers/message/fusion/mptscsih.c: missing break
Applying: block: restore /proc/partitions to not display non-partitionable =
removable devices
Applying: block: remove deadlock in disk_clear_events
Applying: block-remove-deadlock-in-disk_clear_events-fix
Applying: block: prevent race/cleanup
Applying: block-prevent-race-cleanup-fix
Applying: vfs: increment iversion when a file is truncated
Applying: fs: change return values from -EACCES to -EPERM
Applying: fs/block_dev.c: no need to check inode->i_bdev in bd_forget()
Applying: watchdog: trigger all-cpu backtrace when locked up and going to p=
anic
Applying: mm/page_alloc.c: remove duplicate check
Applying: mm: memmap_init_zone() performance improvement
Applying: memcg: make it possible to use the stock for more than one page
Applying: memcg: reclaim when more than one page needed
Applying: memcg: change defines to an enum
Applying: memcg: kmem accounting basic infrastructure
Applying: mm: add a __GFP_KMEMCG flag
CONFLICT (content): Merge conflict in include/linux/gfp.h
Applying: memcg: kmem controller infrastructure
Applying: memcg: replace __always_inline with plain inline
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
Applying: memcg: simplify ida initialization
Applying: memcg: infrastructure to match an allocation to the right cache
Applying: memcg: skip memcg kmem allocations in specified code regions
Applying: memcg: remove test for current->mm in memcg_stop/resume_kmem_acco=
unt
Applying: sl[au]b: always get the cache from its page in kmem_cache_free()
Applying: sl[au]b: allocate objects from memcg cache
Applying: memcg: destroy memcg caches
Applying: move include of workqueue.h to top of slab.h file
Applying: memcg/sl[au]b: track all the memcg children of a kmem_cache
Applying: memcg/sl[au]b: shrink dead caches
Applying: memcg: get rid of once-per-second cache shrinking for dead memcgs
Applying: memcg: aggregate memcg cache values in slabinfo
Applying: slab: propagate tunable values
Applying: slub: slub-specific propagation changes
Applying: slub-slub-specific-propagation-changes-fix
Applying: kmem: add slab-specific documentation about the kmem controller
Applying: memcg: add comments clarifying aspects of cache attribute propaga=
tion
Applying: slub: drop mutex before deleting sysfs entry
Applying: mm: print out information of file affected by memory error
Applying: mm: add vm event counters for balloon pages compaction
Applying: mm: cma: WARN if freed memory is still in use
Applying: mm-memcg-avoid-unnecessary-function-call-when-memcg-is-disabled-f=
ix
Applying: mm: trace filemap add and del
Applying: memcg: do not check for mm in __mem_cgroup_count_vm_event
Applying: drop_caches: add some documentation and info message
Applying: drop_caches-add-some-documentation-and-info-messsge-checkpatch-fi=
xes
Applying: swap: add a simple detector for inappropriate swapin readahead
Applying: swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix
Applying: mm/memblock: reduce overhead in binary search
Applying: drivers/usb/gadget/amd5536udc.c: avoid calling dma_pool_create() =
with NULL dev
Applying: mm/dmapool.c: fix null dev in dma_pool_create()
Applying: memcg: debugging facility to access dangling memcgs
Applying: memcg-debugging-facility-to-access-dangling-memcgs-fix
Applying: frv: fix use of extinct _sbss and _ebss in debug code
Applying: frv: properly use the declarations provided by <asm/sections.h>
Applying: scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes
Applying: Documentation/kernel-parameters.txt: update mem=3D option's spec =
according to its implementation
Applying: include/linux/init.h: use the stringify operator for the __define=
_initcall macro
Applying: scripts/tags.sh: add magic for declarations of popular kernel type
Applying: Documentation: remove reference to feature-removal-schedule.txt
Applying: kernel: remove reference to feature-removal-schedule.txt
Applying: sound: remove reference to feature-removal-schedule.txt
Applying: drivers: remove reference to feature-removal-schedule.txt
Applying: lseek: the "whence" argument is called "whence"
Applying: Kconfig: centralise CONFIG_ARCH_NO_VIRT_TO_BUS
Applying: fs/notify/inode_mark.c: make fsnotify_find_inode_mark_locked() st=
atic
Applying: .gitignore: remove stale entry for generated version.h
Applying: sendfile: allows bypassing of notifier events
Applying: watchdog: store the watchdog sample period as a variable
Applying: printk: boot_delay should only affect output
Applying: lib/vsprintf.c: fix handling of %zd when using ssize_t
Applying: MAINTAINERS: CHINESE MAINTAINERS mailing list is subscribers only
Applying: MAINTAINERS: remove include/linux/ext3*
Applying: Corentin has moved
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
Applying: backlight: add of_find_backlight_by_node()
Applying: backlight-add-of_find_backlight_by_node-function-fix
Applying: backlight-add-of_find_backlight_by_node-function-fix-2
Applying: drivers/video/backlight/pandora_bl.c: change TWL4030_MODULE_PWM0 =
to TWL_MODULE_PWM
Applying: backlight: 88pm860x_bl: remove an unnecessary line continuation
Applying: backlight-88pm860x_bl-remove-an-unnecessary-line-continuation-fix
Applying: drivers/video/backlight/lcd.c: return ENXIO when ops functions ca=
nnot be called
Applying: drivers/video/backlight/lms283gf05.c: use GPIOF_INIT flags when u=
sing devm_gpio_request_one()
Applying: backlight: corgi_lcd: Use gpio_set_value_cansleep() to avoid WARN=
_ON
Applying: string: introduce helper to get base file name from given path
Applying: lib: dynamic_debug: use kbasename()
Applying: mm: use kbasename()
CONFLICT (content): Merge conflict in mm/memory.c
Applying: procfs: use kbasename()
Applying: proc_devtree: remove duplicated include from proc_devtree.c
Applying: trace: use kbasename()
Applying: drivers/of/fdt.c: re-use kernel's kbasename()
Applying: sscanf: don't ignore field widths for numeric conversions
Applying: percpu_rw_semaphore: reimplement to not block the readers unneces=
sarily
Applying: percpu_rw_semaphore-reimplement-to-not-block-the-readers-unnecess=
arilyfix
Applying: percpu_rw_semaphore: kill ->writer_mutex, add ->write_ctr
Applying: percpu_rw_semaphore: add lockdep annotations
Applying: percpu_rw_semaphore: introduce CONFIG_PERCPU_RWSEM
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
Applying: checkpatch: warn about using CONFIG_EXPERIMENTAL
Applying: checkpatch: remove reference to feature-removal-schedule.txt
Applying: checkpatch: consolidate if (foo) bar(foo) checks and add debugfs_=
remove
Applying: checkpatch: allow control over line length warning, default remai=
ns 80
Applying: checkpatch: extend line continuation test
Applying: checkpatch: Add --strict messages for blank lines around braces
Applying: checkpatch: warn when declaring "struct spinlock foo;"
Applying: epoll: support for disabling items, and a self-test app
Applying: binfmt_elf: fix corner case kfree of uninitialized data
Applying: binfmt_elf-fix-corner-case-kfree-of-uninitialized-data-checkpatch=
-fixes
Applying: binfmt_elf.c: use get_random_int() to fix entropy depleting
Applying: rtc: omap: kicker mechanism support
Applying: ARM: davinci: remove rtc kicker release
Applying: rtc: omap: dt support
Applying: rtc: omap: depend on am33xx
Applying: rtc: omap: add runtime pm support
Applying: drivers/rtc/rtc-imxdi: support for i.MX53
Applying: drivers/rtc/rtc-imxdi.c: add devicetree support
Applying: drivers/rtc/rtc-vt8500.c: convert to use devm_kzalloc
Applying: drivers/rtc/rtc-test.c: avoid calling platform_device_put() twice
Applying: rtc-avoid-calling-platform_device_put-twice-in-test_init-fix
Applying: rtc: rtc-spear: use devm_*() routines
Applying: rtc-rtc-spear-use-devm_-routines-fix
Applying: rtc: rtc-spear: Add clk_{un}prepare() support
Applying: rtc: rtc-spear: Provide flag for no support of UIE mode
Applying: drivers/rtc/rtc-tps65910.c: rename irq to match device
Applying: rtc: rtc-davinci: return correct error code if rtc_device_registe=
r() fails
Applying: rtc: rtc-davinci: use devm_kzalloc()
Applying: rtc: add NXP PCF8523 support
Applying: rtc-add-nxp-pcf8523-support-v2
Applying: drivers/rtc/rtc-s3c.c: remove unnecessary err_nores label
Applying: drivers/rtc/rtc-s3c.c: convert to use devm_* API
Applying: drivers/rtc/rtc-dev.c: remove unused code from rtc-dev.c
Applying: drivers/rtc/rtc-tps65910.c: enable RTC power domain on initializa=
tion
Applying: hfsplus: avoid crash on failed block map free
Applying: hfsplus: add osx.* prefix for handling namespace of Mac OS X exte=
nded attributes
Applying: hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extende=
d-attributes-checkpatch-fixes
Applying: hfsplus: add on-disk layout declarations related to attributes tr=
ee
Applying: hfsplus: add functionality of manipulating by records in attribut=
es tree
Applying: hfsplus: rework functionality of getting, setting and deleting of=
 extended attributes
Applying: hfsplus-rework-functionality-of-getting-setting-and-deleting-of-e=
xtended-attributes-fix
Applying: hfsplus: add support of manipulation by attributes file
Applying: hfsplus: rework processing errors in hfsplus_free_extents()
Applying: hfsplus: rework processing of hfs_btree_write() returned error
Applying: hfsplus-rework-processing-of-hfs_btree_write-returned-error-fix
Applying: hfsplus: make error message in hfsplus_system_write_inode() more =
compact and detailed
Applying: hfsplus: add error message for the case of failure of sync fs in =
delayed_sync_fs() method
Applying: fat: notify when discard is not supported
Applying: fat: provide option for setting timezone offset
Applying: fat: ix mount option parsing
Applying: fs/fat: strip "cp" prefix from codepage in display
Applying: Documentation/DMA-API-HOWTO.txt: minor grammar corrections
Applying: Documentation: fix Documentation/security/00-INDEX
Applying: kstrto*: add documentation
Applying: simple_strto*: annotate function as obsolete
Applying: ptrace: introduce PTRACE_O_EXITKILL
Applying: proc: don't show nonexistent capabilities
Applying: procfs: add VmFlags field in smaps output
Applying: procfs-add-vmflags-field-in-smaps-output-v4-fix
Applying: /proc/pid/status: add "Seccomp" field
Applying: proc: pid/status: show all supplementary groups
Applying: fork: unshare: remove dead code
Applying: exec: do not leave bprm->interp on stack
Applying: exec: use -ELOOP for max recursion depth
Applying: ipc: remove forced assignment of selected message
Applying: ipc: add sysctl to specify desired next object id
Applying: ipc-add-sysctl-to-specify-desired-next-object-id-checkpatch-fixes
Applying: ipc: wrap new sysctls for CRIU inside CONFIG_CHECKPOINT_RESTORE
Applying: Documentation: update sysctl/kernel.txt
Applying: ipc: message queue receive cleanup
Applying: ipc-message-queue-receive-cleanup-checkpatch-fixes
Applying: ipc: introduce message queue copy feature
Applying: ipc: remove redundant MSG_COPY check
Applying: ipc: cleanup do_msgrcv() around MSG_COPY feature
Applying: selftests: IPC message queue copy feature test
Applying: test: IPC message queue copy feature test update
Applying: ipc: simplify free_copy() call
Applying: ipc: convert prepare_copy() from macro to function
Applying: ipc-convert-prepare_copy-from-macro-to-function-fix
Applying: ipc: simplify message copying
Applying: ipc: add more comments to message copying related code
Applying: Documentation/sysctl/kernel.txt: document /proc/sys/shmall
Applying: ipc/sem.c: alternatives to preempt_disable()
Applying: pidns: remove unused is_container_init()
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
Applying: aoe: provide ATA identify device content to user on request
Applying: aoe: improve network congestion handling
Applying: aoe: err device: include MAC addresses for unexpected responses
Applying: aoe: manipulate aoedev network stats under lock
Applying: aoe: use high-resolution RTTs with fallback to low-res
Applying: aoe: commands in retransmit queue use new destination on failure
Applying: aoe: update driver-internal version to 64+
Applying: aoe: copy fallback timing information on destination failover
Applying: aoe: remove vestigial request queue allocation
Applying: aoe: increase default cap on outstanding AoE commands in the netw=
ork
Applying: aoe: cleanup: correct comment for aoetgt nout
Applying: aoe: remove call to request handler from I/O completion
Applying: aoe: make error messages more specific in static minor allocation
Applying: aoe: initialize sysminor to avoid compiler warning
Applying: aoe: return real minor number for static minors
Applying: aoe: improve handling of misbehaving network paths
Applying: aoe: avoid races between device destruction and discovery
Applying: aoe: use dynamic number of remote ports for AoE storage target
Applying: aoe: allow user to disable target failure timeout
Applying: aoe: allow comma separator in aoe_iflist value
Applying: aoe: identify source of runt AoE packets
Applying: aoe: update internal version number to 81
Applying: aoe: fix use after free in aoedev_by_aoeaddr()
Applying: random32: rename random32 to prandom
Applying: prandom: introduce prandom_bytes() and prandom_bytes_state()
Applying: bnx2x: use prandom_bytes()
Applying: mtd: nandsim: use prandom_bytes
Applying: ubifs: use prandom_bytes
Applying: mtd: mtd_nandecctest: use prandom_bytes instead of get_random_byt=
es()
Applying: mtd: mtd_oobtest: convert to use prandom library
Applying: mtd: mtd_pagetest: convert to use prandom library
Applying: mtd: mtd_speedtest: use prandom_bytes
Applying: mtd: mtd_subpagetest: convert to use prandom library
Applying: mtd: mtd_stresstest: use prandom_bytes()
Applying: Documentation/DMA-API-HOWTO.txt: fix typo
Applying: vm selftests: print failure status instead of cause make error
Applying: mqueue selftests: print failure status instead of cause make error
Applying: cpu-hotplug selftests: print failure status instead of cause make=
 error
Applying: mem-hotplug selftests: print failure status instead of cause make=
 error
Applying: kcmp selftests: make run_tests fix
Applying: kcmp selftests: print fail status instead of cause make error
Applying: breakpoint selftests: print failure status instead of cause make =
error
Applying: tools/testing/selftests/kcmp/kcmp_test.c: print reason for failur=
e in kcmp_test
Applying: procfs: add ability to plug in auxiliary fdinfo providers
Applying: fs, eventfd: add procfs fdinfo helper
Applying: fs, epoll: add procfs fdinfo helper
Applying: fs, epoll: drop enabled field from fdinfo output
Applying: fdinfo: show sigmask for signalfd fd
Applying: fs, exportfs: escape nil dereference if no s_export_op present
Applying: fs, exportfs: add exportfs_encode_inode_fh() helper
Applying: fs, notify: add procfs fdinfo helper
Applying: fs, notify: Move bare fdinfo helpers to a header
Applying: fs, notify: add missing space after prefix
Applying: fs, notify: don't forget to provide fhandle for inode fanotify
Applying: fs, fanotify: ddd missing pieces in fdinfo for ability to call fa=
notify_init
Applying: docs: add documentation about /proc/<pid>/fdinfo/<fd> output
Applying: docs-add-documentation-about-proc-pid-fdinfo-fd-output-fix
Applying: fs, fanotify: add @mflags field to fanotify output
Applying: docs: update documentation about /proc/<pid>/fdinfo/<fd> fanotify=
 output
Applying: fs-notify-add-procfs-fdinfo-helper-v7-fix
Applying: scatterlist: don't BUG when we can trivially return a proper erro=
r.
Applying: scatterlist-dont-bug-when-we-can-trivially-return-a-proper-error-=
fix
Applying: fb-rework-locking-to-fix-lock-ordering-on-takeover-fix-2
Merging akpm/master (2449f55 fb-rework-locking-to-fix-lock-ordering-on-take=
over-fix-2)

--Signature=_Fri__14_Dec_2012_18_42_16_+1100_PrH4HZPAU/+jdui6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQythYAAoJEECxmPOUX5FEiLUQAIxAdbpeykCxRB6nkLfpd/dd
VqLZdc6d5HnaBU6MK07fW7EdBmyLHdppJrbA0kuRHmhG0SYZd6oXbXVM8BZ7FQb4
3aqJH28T7iF2l4ldklfG3HBRAt4dazGkjvWKI7qZOnC9b3PAIPCD9rFG4PLl4QSE
azEWIbZ9VJqBQvSbDaolBqbiPvE+hQTluk+LSozMYOc3UqmGx0o11DWGucUgat3b
UjgGzjqtpHz9CqqZqzGvd5b9jzg4Uk/iuzR269OB48jjgu002VSVa6Y4Ak6uWlYi
2A0sFQsMTzw56wl6CNWRhodg1BycFeRgQsBtl5jHzEPfgQXd7zM5h8GZ7zxK7Pn2
MNSMWGgXaQaMRmQKqhRIrjLdk033b2iGF510bAMQi8mMZSpCgEmFqIsZsJQ+o0MV
HTAxgwXx3yMOUP8my6Ry49pBj4u+Mu79ELwCKtyhjv2Dq6gAVfN2fSTh4Fs72Es2
ToaJn9CwpBkIhrb80i7qRLLMIAJILQPXvx2YMHZgKDt1n2z5zr1YXHxjyu9IoHoS
OHRKv/jolCq5Ne6cjSYEnuTQ2TOaaA2u/grNZcw8F59IB8/RNdAGPvLpaE3lpfu3
xssEvNOehepvJYSLfKJ9FRT5S5Jsur3K/6313FUlNC1a7eLMpWFP+yzFD6jC5I+8
Gyq9mo0JDF0aa+5SsdoB
=prRQ
-----END PGP SIGNATURE-----

--Signature=_Fri__14_Dec_2012_18_42_16_+1100_PrH4HZPAU/+jdui6--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089Ab2FZGmN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 02:42:13 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:40331 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842Ab2FZGlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 02:41:47 -0400
Date: Tue, 26 Jun 2012 16:41:39 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Jun 26
Message-Id: <20120626164139.38b73813a82ea22ff62965f1@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta9 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__26_Jun_2012_16_41_39_+1000_N1iVBxsvswoKbGk+"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__26_Jun_2012_16_41_39_+1000_N1iVBxsvswoKbGk+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20120625:

New tree: cpuidle

The v4l-dvb tree lost its conflict.

The net-next tree lost its conflicts but gained another against the net
tree.

The sound-asoc tree lost its build failure.

The tip tree gained a conflict against Linus' tree.

The akpm tree lost its build failure.

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

We are up to 190 trees (counting Linus' and 26 trees of patches pending
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
Merging origin/master (aace99e Merge branch 'v4l_for_linus' of git://git.ke=
rnel.org/pub/scm/linux/kernel/git/mchehab/linux-media)
Merging fixes/master (9023a40 Merge tag 'mmc-fixes-for-3.5-rc4' of git://gi=
t.kernel.org/pub/scm/linux/kernel/git/cjb/mmc)
Merging kbuild-current/rc-fixes (464076b Makefile: Do not call cc-option be=
fore including the arch's Makefile)
Merging arm-current/fixes (10aa5a3 SPI: fix over-eager devm_xxx() conversio=
n)
Merging m68k-current/for-linus (d8ce726 m68k: Use generic strncpy_from_user=
(), strlen_user(), and strnlen_user())
Merging powerpc-merge/merge (7c0482e powerpc/irq: Fix another case of lazy =
IRQ state getting out of sync)
Merging sparc/master (39a50b4 Merge branch 'hfsplus')
Merging net/master (8a8e28b mac802154: add missed braces)
Merging sound-current/for-linus (befae82 ALSA: hda - Add Realtek ALC280 cod=
ec support)
Merging pci-current/for-linus (314489b Merge tag 'fixes-for-linus' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc)
Merging wireless/master (eac9ac6 iwlwifi: fix activating inactive stations)
Merging driver-core.current/driver-core-linus (4661e35 printk: fix regressi=
on in SYSLOG_ACTION_CLEAR)
Merging tty.current/tty-linus (78d80c5 serial/amba-pl011: move custom pin c=
ontrol to driver)
Merging usb.current/usb-linus (8f8741c Merge 3.5-rc4 into usb-linus)
Merging staging.current/staging-linus (6b16351 Linux 3.5-rc4)
Merging char-misc.current/char-misc-linus (6b16351 Linux 3.5-rc4)
Merging input-current/for-linus (2177905 Input: fix input.h kernel-doc warn=
ing)
Merging md-current/for-linus (aba336b md: raid1/raid10: fix problem with me=
rge_bvec_fn)
Merging audit-current/for-linus (c158a35 audit: no leading space in audit_l=
og_d_path prefix)
Merging crypto-current/master (c475c06 hwrng: atmel-rng - fix data valid ch=
eck)
Merging ide/master (39a50b4 Merge branch 'hfsplus')
Merging dwmw2/master (244dc4e Merge git://git.infradead.org/users/dwmw2/ran=
dom-2.6)
Merging sh-current/sh-fixes-for-linus (790b9d4 Merge tag 'sh-for-linus' of =
git://github.com/pmundt/linux-sh)
Merging irqdomain-current/irqdomain/merge (15e06bf irqdomain: Fix debugfs f=
ormatting)
Merging devicetree-current/devicetree/merge (4e8383b of: release node fix f=
or of_parse_phandle_with_args)
Merging spi-current/spi/merge (d1c185b of/spi: Fix SPI module loading by us=
ing proper "spi:" modalias prefixes.)
Merging gpio-current/gpio/merge (96b7064 gpio/tca6424: merge I2C transactio=
ns, remove cast)
Merging arm/for-next (4d0d790 Merge branches 'fixes' and 'misc' into for-ne=
xt)
Merging arm-perf/for-next/perf (dee8c1b ARM: perf: remove arm_perf_pmu_ids =
global enumeration)
Merging davinci/davinci-next (fe0d422 Linux 3.0-rc6)
Merging samsung/next-samsung (9edb240 ARM: H1940/RX1950: Change default LED=
 triggers)
Merging xilinx/arm-next (b85a3ef ARM: Xilinx: Adding Xilinx board support)
Merging blackfin/for-linus (672552a blackfin: fix build after add bf60x mac=
h/pm.h)
Merging c6x/for-linux-next (485802a Linux 3.5-rc3)
Merging cris/for-next (2608747 CRIS: Remove VCS simulator specific code)
Merging hexagon/linux-next (5042ab9 various Kconfig cleanup and old platfor=
m build code removal)
Merging ia64/next (f28fa72 [IA64] Port OOM changes to ia64_do_page_fault)
Merging m68k/for-next (4fa0cff m68knommu: Allow ColdFire CPUs to use unalig=
ned accesses)
Merging m68knommu/for-next (cec069e m68knommu: Add clk definitions for m532=
x.)
Merging microblaze/next (a01ee16 Merge branch 'for-linus' of git://git.open=
-osd.org/linux-open-osd)
Merging mips/mips-for-linux-next (1f04189 Merge branch 'next/loongson1b' in=
to mips-for-linux-next)
Merging openrisc/for-upstream (207e715 openrisc: use scratch regs in atomic=
 syscall)
Merging parisc/for-next (4c01acc [PARISC] fix code to find libgcc)
Merging powerpc/next (2074b1d powerpc: Fix irq distribution)
Merging 4xx/next (2074b1d powerpc: Fix irq distribution)
Merging mpc5xxx/next (f8d5842 powerpc: Option FB_FSL_DIU is not really opti=
onal for mpc512x)
Merging galak/next (fa1b42b powerpc/qe: Update the SNUM table for MPC8569 R=
ev2.0)
Merging s390/features (fbe7656 s390/smp: make absolute lowcore / cpu restar=
t parameter accesses more robust)
Merging sh/sh-latest (7b98cf0 Merge branch 'common/pfc' into sh-latest)
Merging sparc-next/master (31a6710 Fix blocking allocations called very ear=
ly during bootup)
Merging tile/master (7a9349b bounce: allow use of bounce pool via config op=
tion)
Merging unicore32/unicore32 (e4baa56 UniCore32-bugfix: Remove definitions i=
n asm/bug.h to solve difference between native and cross compiler)
Merging ceph/master (26ce171 libceph: fix NULL dereference in reset_connect=
ion())
CONFLICT (content): Merge conflict in net/ceph/osd_client.c
Merging cifs/for-next (4d0b178 CIFS: Add SMB2 credits support)
Merging configfs/linux-next (b930c26 Merge branch 'for-linus' of git://git.=
kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (5a52c0d eCryptfs: Initialize empty lower files when =
opening them)
Merging ext3/for_next (7d5a4b0 quota: fix checkpatch.pl warning by replacin=
g <asm/uaccess.h> with <linux/uaccess.h>)
Merging ext4/dev (b22b1f1 ext4: don't set i_flags in EXT4_IOC_SETFLAGS)
Merging fuse/for-next (203627b fuse: fix blksize calculation)
Merging gfs2/master (666d1d8 GFS2: Combine functions get_local_rgrp and gfs=
2_inplace_reserve)
Merging logfs/master (cd8bfa9 logfs: initialize the number of iovecs in bio)
Merging nfs/linux-next (d4c2898 Define ENONAMESERVICE and ENAMEUNKNOWN to i=
ndicate name service errors)
Merging nfsd/nfsd-next (7df302f NFSD: TEST_STATEID should not return NFS4ER=
R_STALE_STATEID)
Merging ocfs2/linux-next (9392557 ocfs2: avoid unaligned access to dqc_bitm=
ap)
Merging omfs/for-next (976d167 Linux 3.1-rc9)
Merging squashfs/master (4b0180a Squashfs: add mount time sanity check for =
block_size and block_log match)
Merging v9fs/for-next (5fcb08b 9p: BUG before corrupting memory)
Merging ubifs/linux-next (1cfb727 UBIFS: fix assertion)
Merging xfs/for-next (9a8d2fd xfs: remove xlog_t typedef)
CONFLICT (content): Merge conflict in fs/xfs/xfs_log_priv.h
CONFLICT (content): Merge conflict in fs/xfs/xfs_log.c
Merging vfs/for-next (01aa470 do_dentry_open(): close the race with mark_fi=
les_ro() in failure exit)
CONFLICT (content): Merge conflict in fs/cifs/dir.c
Merging pci/next (35e7f73 Merge branch 'topic/huang-d3cold-v7' into next)
CONFLICT (content): Merge conflict in drivers/pci/quirks.c
CONFLICT (content): Merge conflict in drivers/pci/pci.c
Merging hid/for-next (f79185b Merge branch 'uhid' into for-next)
Merging quilt/i2c (7f56c63 i2c/writing-clients: Mention module_i2c_driver())
Merging bjdooks-i2c/next-i2c (fc84fe1 Merge branch 'for_3.3/i2c/misc' of gi=
t://git.kernel.org/pub/scm/linux/kernel/git/khilman/linux-omap-pm into for-=
33/i2c/omap)
CONFLICT (content): Merge conflict in drivers/i2c/busses/i2c-omap.c
Merging i2c-embedded/i2c-embedded/for-next (0f009a9 i2c: tegra: make all re=
source allocation through devm_*)
Merging quilt/jdelvare-hwmon (3c1aae2 hwmon: struct x86_cpu_id arrays can b=
e __initconst)
Merging hwmon-staging/hwmon-next (56e42ea hwmon: (applesmc) Skip sensor map=
ping)
Merging v4l-dvb/master (db04b6c Merge tag 'v3.5-rc4')
Merging kbuild/for-next (c6ff25b Merge branch 'kbuild/rc-fixes' into kbuild=
/for-next)
Merging kconfig/for-next (4503379 localmodconfig: Add debug environment var=
iable LOCALMODCONFIG_DEBUG)
Merging libata/NEXT (2fff275 PATA host controller driver for ep93xx)
Merging infiniband/for-next (a323e3f Merge branch 'cma' into for-next)
Merging acpi/next (4e86d6d Merge branch 'turbostat-v2' into next)
CONFLICT (content): Merge conflict in drivers/pci/pci-acpi.c
Merging cpuidle/cpuidle-next (1cdb80c cpuidle: coupled: add parallel barrie=
r function)
CONFLICT (add/add): Merge conflict in drivers/cpuidle/coupled.c
Merging cpupowerutils/master (f166033 cpupower tools: add install target to=
 the debug tools' makefiles)
Merging ieee1394/for-next (e18907c firewire: ohci: initialize multiChanMode=
 bits after reset)
Merging ubi/linux-next (f8f5701 Linux 3.5-rc1)
Merging dlm/next (aefee56 dlm: fix missing dir remove)
Merging scsi/for-next (6ef2448 [SCSI] qla4xxx: Update driver version to 5.0=
2.00-k18)
Merging target-updates/for-next (4318efc target: move unmap to struct spc_o=
ps)
Merging target-merge/for-next-merge (cfaf025 Linux 3.5-rc2)
Merging ibft/linux-next (935a9fe ibft: Fix finding IBFT ACPI table on UEFI)
Merging isci/all (6df8ea3 merge: devel rnc-devel fixes)
Merging slave-dma/next (49d57b5 dmaengine: mmp_tdma: fix the arch dependenc=
y)
Merging dmaengine/next (a2bd114 netdma: adding alignment check for NETDMA o=
ps)
Merging net-next/master (91fa0cb caif-hsi: Remove use of module parameters)
CONFLICT (content): Merge conflict in drivers/net/caif/caif_hsi.c
Merging wireless-next/master (5ea2769 rtlwifi: Change debug level for delet=
ion of an entry in CAM)
Merging bluetooth/master (790eff4 Bluetooth: Use GFP_KERNEL in mgmt events =
functions)
Merging mtd/master (ea3b2ea mtd: nand: initialize bitflip_threshold prior t=
o BBT scanning)
Merging l2-mtd/master (b27ebae mtd: m25p80: Add support for n25q064)
Merging crypto/master (3987103 crypto: algapi - Move larval completion into=
 algboss)
Merging drm/drm-next (9c19415 Merge tag 'drm-intel-next-2012-06-04' of git:=
//people.freedesktop.org/~danvet/drm-intel into drm-core-next)
Merging sound/for-next (4775539 Merge branch 'fix/hda' into for-next)
Merging sound-asoc/for-next (747706d Merge branch 'for-3.6' into asoc-next)
Merging quilt/rr (231e4d6 Taint kernel when lve module is loaded)
Merging input/next (84b63ad Input: nomadik-ske-keypad - get rid of multiple=
 interrupts)
Merging input-mt/for-next (27c347d Input: MT - fix null pointer warning)
Merging cgroup/for-next (f9b6023f Merge branch 'for-3.5-fixes' into for-nex=
t)
Merging block/for-next (f45d342 Merge branch 'for-linus' into for-next)
Merging quilt/device-mapper (f87f942 dm-thin will be most likely used with =
a block size that is a power of two. So it should be optimized for this cas=
e.)
Merging embedded/master (4744b43 embedded: fix vc_translate operator preced=
ence)
Merging firmware/master (6e03a20 firmware: speed up request_firmware(), v3)
Merging pcmcia/master (80af9e6 pcmcia at91_cf: fix raw gpio number usage)
Merging mmc/mmc-next (8da55ef mmc: core: Fix the HPI execution sequence)
Merging kgdb/kgdb-next (3751d3e x86,kgdb: Fix DEBUG_RODATA limitation using=
 text_poke())
Merging slab/for-next (43d7786 slub: refactoring unfreeze_partials())
Merging uclinux/for-next (5e442a4 Revert "proc: fix races against execve() =
of /proc/PID/fd**")
Merging md/for-next (aba336b md: raid1/raid10: fix problem with merge_bvec_=
fn)
Merging mfd/for-next (2912a64 mfd: Add Maxim 77686 driver)
Merging battery/master (85a392d test_power: Add VOLTAGE_NOW and BATTERY_TEM=
P properties)
Applying: ACPI-Thermal: fix for an API change
Merging fbdev/fbdev-next (0f90fa5 Merge branch 'planes' of git://linuxtv.or=
g/pinchartl/fbdev into fbdev-next)
Merging viafb/viafb-next (838ac78 viafb: avoid refresh and mode lookup in s=
et_par)
Merging omap_dss2/for-next (05dd0f5 OMAPDSS: DISPC: Update Accumulator conf=
iguration for chroma plane)
Merging regulator/for-next (c1bdb85 Merge branch 'regulator-drivers' into r=
egulator-next)
Merging security/next (3072928 tpm: check the chip reference before using i=
t)
Merging selinux/master (c737f82 SELinux: remove unused common_audit_data in=
 flush_unauthorized_files)
Merging lblnet/master (7e27d6e Linux 2.6.35-rc3)
Merging watchdog/master (6b16351 Linux 3.5-rc4)
Merging dwmw2-iommu/master (c3b92c8 Linux 3.1)
Merging iommu/next (af4d900 Merge branches 'iommu/fixes', 'groups' and 'arm=
/tegra' into next)
Merging osd/linux-next (8b56a30 exofs:  Add SYSFS info for autologin/pNFS e=
xport)
Merging jc_docs/docs-next (5c050fb docs: update the development process doc=
ument)
Merging trivial/for-next (c224071 parisc: cleanup quoted include)
Merging audit/for-next (dcd6c92 Linux 3.3-rc1)
Merging pm/linux-next (6f5b7ab PM / ACPI: Fix suspend/resume regression cau=
sed by cpuidle cleanup.)
Merging apm/for-next (f283d22 APM: fix deadlock in APM_IOC_SUSPEND ioctl)
Merging fsnotify/for-next (1aec9c0 inotify: automatically restart syscalls)
Merging edac/linux_next (2d9531a Merge branch 'devel' into next)
Merging edac-amd/for-next (305f1c3 Merge branch '3.3-pci_device_id' into ed=
ac-for-next)
CONFLICT (content): Merge conflict in drivers/edac/amd64_edac.c
CONFLICT (content): Merge conflict in Documentation/edac.txt
Merging devicetree/devicetree/next (efd68e7 devicetree: add helper inline f=
or retrieving a node's full name)
Merging spi/spi/next (d8e328b spi: Add "spi:" prefix to modalias attribute =
of spi devices)
Merging tip/auto-latest (061087f Merge branch 'core/urgent')
CONFLICT (content): Merge conflict in mm/slub.c
CONFLICT (content): Merge conflict in mm/slab.c
CONFLICT (content): Merge conflict in include/asm-generic/bug.h
CONFLICT (content): Merge conflict in drivers/hwmon/coretemp.c
Merging rcu/rcu/next (f0fd40c rcu: Allow RCU quiescent-state forcing to be =
preempted)
Merging cputime/cputime (c3e0ef9 [S390] fix cputime overflow in uptime_proc=
_show)
Merging uprobes/for-next (0326f5a uprobes/core: Handle breakpoint and singl=
estep exceptions)
Merging kmemleak/kmemleak (4878677 kmemleak: do not leak object after tree =
insertion error)
Merging kvm/linux-next (dcce048 KVM: trace events: update list of exit reas=
ons)
Merging kvm-ppc/kvm-ppc-next (5e5054c booke: Added crit/mc exception handle=
r for e500v2)
Merging oprofile/for-next (c16fa4f Linux 3.3)
Merging xen/upstream/xen (af3a3ab Merge git://git.kernel.org/pub/scm/linux/=
kernel/git/steve/gfs2-3.0-fixes)
Merging xen-two/linux-next (e4e7b82 Merge branch 'stable/for-linus-3.6' int=
o linux-next)
Merging xen-pvhvm/linux-next (b056b6a xen: suspend: remove xen_hvm_suspend)
Merging percpu/for-next (61011677 Merge tag 'dlm-3.5' of git://git.kernel.o=
rg/pub/scm/linux/kernel/git/teigland/linux-dlm)
Merging workqueues/for-next (61011677 Merge tag 'dlm-3.5' of git://git.kern=
el.org/pub/scm/linux/kernel/git/teigland/linux-dlm)
Merging drivers-x86/linux-next (d0e0a477 dell-laptop: Add touchpad led supp=
ort for Dell V3450)
Merging hwpoison/hwpoison (46e387b Merge branch 'hwpoison-hugepages' into h=
wpoison)
Merging sysctl/master (4e474a0 sysctl: protect poll() in entries that may g=
o away)
Merging regmap/for-next (dabefce Merge branch 'regmap-page' into regmap-nex=
t)
Merging hsi/for-next (43139a6 HSI: hsi_char: Update ioctl-number.txt)
Merging leds/for-next (e15ca58 leds: Add LED driver for lm3556 chip)
Merging driver-core/driver-core-next (8191e0d stable: Allow merging of back=
ports for serious user-visible performance issues)
CONFLICT (content): Merge conflict in drivers/extcon/extcon_gpio.c
Merging tty/tty-next (fe89def pch_uart: Add eg20t_port lock field, avoid re=
cursive spinlocks)
Merging usb/usb-next (023b515 uas: task mgmt & error handling)
Merging staging/staging-next (fa6173a Staging: csr: add WEXT and AP mode su=
pport)
Merging char-misc/char-misc-next (21c66d1 mei: group wd_interface_reg with =
watchdog variables within struct mei_device)
Merging tmem/linux-next (3bebf5b Merge branch 'stable/for-linus-3.6' into l=
inux-next)
Merging writeback/writeback-for-next (331cbde writeback: Fix some comment e=
rrors)
Merging arm-dt/devicetree/arm-next (ede338f dt: add documentation of ARM dt=
 boot interface)
Merging hwspinlock/linux-next (8b37fcf hwspinlock: add MAINTAINERS entries)
Merging pinctrl/for-next (8df6653 pinctrl: pinctrl-imx: fix map setting pro=
blem if NO_PAD_CTL is set)
Merging moduleh/for-sfr (f9e1b2b tile: fix compile failure on start_kernel =
in setup.c)
Merging vhost/linux-next (e0953c8 tun: experimental zero copy tx support)
Merging kmap_atomic/kmap_atomic (cf43378 pipe: remove KM_USER0 from comment=
s)
Merging memblock/memblock-kill-early_node_map (7bd0b0f memblock: Reimplemen=
t memblock allocation using reverse free area iterator)
Merging remoteproc/for-next (5414687 MAINTAINERS: add remoteproc's git)
CONFLICT (content): Merge conflict in drivers/remoteproc/remoteproc_core.c
Merging irqdomain/irqdomain/next (aed9804 irqdomain: Make ops->map hook opt=
ional)
Merging gpio/gpio/next (3e11f7b gpio/generic: initialize basic_mmio_gpio sh=
adow variables properly)
Merging arm-soc/for-next (513bd72 Merge branch 'fixes' into for-next)
Merging ep93xx/ep93xx-for-next (9b6a359 Merge branch 'ep93xx-fixes' into ep=
93xx-for-next)
Merging renesas/next (386213b Merge branch 'renesas-sh7372' into renesas-ne=
xt)
Merging s5p/for-next (99f9f4c Merge branch 'v3.5-samsung-fixes-1' into for-=
next)
Merging tegra/for-next (67eee74 Merge branch 'for-3.6/defconfig' into for-n=
ext)
Merging kvmtool/master (5fffd63 kvm tools: set the HYPERVISOR flag in cpuid)
Merging dma-mapping/dma-mapping-next (17f449a Merge remote branch 'dma-publ=
ic/fixes-for-linus' into for-next)
Merging dma-buf/for-next (b48b2c3 openrisc: use generic strnlen_user() func=
tion)
Merging userns/for-next (491fa9e userns: Allow the usernamespace support to=
 build after the removal of usbfs)
Merging ktest/for-next (648a182 ktest: Allow a test to override REBOOT_ON_S=
UCCESS)
Merging signal/for-next (2c95605 Uninclude linux/freezer.h)
Merging scsi-post-merge/merge-base:master ()
$ git checkout akpm
Applying: selinux: fix something
Applying: memory hotplug: fix invalid memory access caused by stale kswapd =
pointer
Applying: memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-p=
ointer-fix
Applying: drivers/rtc/rtc-spear.c: fix use-after-free in spear_rtc_remove()
Applying: mn10300: move setup_jiffies_interrupt() to cevt-mn10300.c
Applying: mn10300: remove duplicate definition of PTRACE_O_TRACESYSGOOD
Applying: mn10300: kernel/internal.h needs <linux/irqreturn.h>
Applying: mn10300: kernel/traps.c needs <linux/export.h>
Applying: mn10300: mm/dma-alloc.c needs <linux/export.h>
Applying: mn10300: use "#elif defined(CONFIG_*)" instead of "#elif CONFIG_*"
Applying: ocfs2: fix NULL pointer dereference in __ocfs2_change_file_space()
Applying: c/r: prctl: less paranoid prctl_set_mm_exe_file()
Applying: drivers/gpio/devres.c: export devm_gpio_request_one() to modules
Applying: mm, thp: abort compaction if migration page cannot be charged to =
memcg
Applying: cciss: fix incorrect scsi status reporting
Applying: arch/x86/platform/iris/iris.c: register a platform device and a p=
latform driver
Applying: arch/x86/include/asm/spinlock.h: fix comment
Applying: arch/x86/kernel/cpu/perf_event_intel_uncore.h: make UNCORE_PMU_HR=
TIMER_INTERVAL 64-bit
Applying: timeconst.pl: remove deprecated defined(@array)
Applying: time: don't inline EXPORT_SYMBOL functions
Applying: thermal: fix potential out-of-bounds memory access
Applying: ocfs2: use find_last_bit()
Applying: ocfs2: use bitmap_weight()
Applying: drivers/scsi/ufs: use module_pci_driver
Applying: drivers/scsi/ufs: reverse the ufshcd_is_device_present logic
Applying: drivers/scsi/ufs: fix incorrect return value about SUCCESS and FA=
ILED
Applying: drivers/scsi/atp870u.c: fix bad use of udelay
Applying: vfs: increment iversion when a file is truncated
Applying: fs: push rcu_barrier() from deactivate_locked_super() to filesyst=
ems
Applying: hfs: push lock_super down
Applying: hfs: get rid of lock_super
Applying: hfs: remove extra mdb write on unmount
Applying: hfs: simplify a bit checking for R/O
Applying: hfs: introduce VFS superblock object back-reference
Applying: hfs: get rid of hfs_sync_super
Applying: hfs-get-rid-of-hfs_sync_super-checkpatch-fixes
Applying: fs/xattr.c:getxattr(): improve handling of allocation failures
Applying: fs: add link restrictions
Applying: mm/slab: remove duplicate check
Applying: slab: move FULL state transition to an initcall
Applying: vmalloc: walk vmap_areas by sorted list instead of rb_next()
Applying: mm: make vb_alloc() more foolproof
Applying: mm-make-vb_alloc-more-foolproof-fix
Applying: memcg: rename MEM_CGROUP_STAT_SWAPOUT as MEM_CGROUP_STAT_SWAP
Applying: memcg: rename MEM_CGROUP_CHARGE_TYPE_MAPPED as MEM_CGROUP_CHARGE_=
TYPE_ANON
Applying: memcg: remove MEM_CGROUP_CHARGE_TYPE_FORCE
Applying: swap: allow swap readahead to be merged
Applying: documentation: update how page-cluster affects swap I/O
Applying: mm: account the total_vm in the vm_stat_account()
Applying: mm: compaction: handle incorrect MIGRATE_UNMOVABLE type pageblocks
Applying: mm-compaction-handle-incorrect-migrate_unmovable-type-pageblocks-=
fix
Applying: mm/buddy: cleanup on should_fail_alloc_page
Applying: mm: prepare for removal of obsolete /proc/sys/vm/nr_pdflush_threa=
ds
Applying: hugetlb: rename max_hstate to hugetlb_max_hstate
Applying: hugetlb: don't use ERR_PTR with VM_FAULT* values
Applying: hugetlb: add an inline helper for finding hstate index
Applying: hugetlb: use mmu_gather instead of a temporary linked list for ac=
cumulating pages
Applying: hugetlb: avoid taking i_mmap_mutex in unmap_single_vma() for huge=
tlb
Applying: hugetlb: simplify migrate_huge_page()
Applying: hugetlb: add a list for tracking in-use HugeTLB pages
Applying: hugetlb: make some static variables global
Applying: hugeltb: mark hugelb_max_hstate __read_mostly
Applying: mm/hugetlb: add new HugeTLB cgroup
Applying: hugetlb/cgroup: Mark root_h_cgroup static
Applying: hugetlb/cgroup: add the cgroup pointer to page lru
Applying: hugetlb/cgroup: add charge/uncharge routines for hugetlb cgroup
Applying: hugetlb/cgroup: add support for cgroup removal
Applying: hugetlb/cgroup: add hugetlb cgroup control files
Applying: hugetlb/cgroup: migrate hugetlb cgroup info from oldpage to new p=
age during migration
Applying: hugetlb/cgroup: add HugeTLB controller documentation
Applying: hugetlb: move all the in use pages to active list
Applying: hugetlb/cgroup: assign the page hugetlb cgroup when we move the p=
age to active list.
Applying: hugetlb/cgroup: remove exclude and wakeup rmdir calls from migrate
Applying: mm, oom: do not schedule if current has been killed
Applying: mm/memblock.c:memblock_double_array(): cosmetic cleanups
Applying: memcg: remove check for signal_pending() during rmdir()
Applying: memcg: clean up force_empty_list() return value check
Applying: memcg: mem_cgroup_move_parent() doesn't need gfp_mask
Applying: memcg: make mem_cgroup_force_empty_list() return bool
Applying: memcg-make-mem_cgroup_force_empty_list-return-bool-fix
Applying: mm/compaction: cleanup on compaction_deferred
Applying: memcg: prevent OOM with too many dirty pages
Applying: tmpfs: implement NUMA node interleaving
Applying: tmpfs-implement-numa-node-interleaving-fix
Applying: avr32/mm/fault.c: port OOM changes to do_page_fault
Applying: avr32-mm-faultc-port-oom-changes-to-do_page_fault-fix
Applying: clk: add non CONFIG_HAVE_CLK routines
Applying: clk: remove redundant depends on from drivers/Kconfig
Applying: i2c/i2c-pxa: remove conditional compilation of clk code
Applying: usb/marvell: remove conditional compilation of clk code
Applying: usb/musb: remove conditional compilation of clk code
Applying: ata/pata_arasan: remove conditional compilation of clk code
Applying: net/c_can: remove conditional compilation of clk code
Applying: net/stmmac: remove conditional compilation of clk code
Applying: gadget/m66592: remove conditional compilation of clk code
Applying: gadget/r8a66597: remove conditional compilation of clk code
Applying: usb/host/r8a66597: remove conditional compilation of clk code
Applying: clk: validate pointer in __clk_disable()
Applying: NMI watchdog: fix for lockup detector breakage on resume
Applying: kmsg: /dev/kmsg - properly return possible copy_from_user() failu=
re
Applying: printk: add generic functions to find KERN_<LEVEL> headers
Applying: printk-add-generic-functions-to-find-kern_level-headers-fix
Applying: printk: add kern_levels.h to make KERN_<LEVEL> available for asm =
use
Applying: arch: remove direct definitions of KERN_<LEVEL> uses
Applying: btrfs: use printk_get_level and printk_skip_level, add __printf, =
fix fallout
Applying: btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix=
-fallout-fix
Applying: btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix=
-fallout-checkpatch-fixes
Applying: sound: use printk_get_level and printk_skip_level
Applying: printk: convert the format for KERN_<LEVEL> to a 2 byte pattern
Applying: printk: only look for prefix levels in kernel messages
Applying: printk: remove the now unnecessary "C" annotation for KERN_CONT
Applying: vsprintf: add %pMR for Bluetooth MAC address
Applying: Documentation/printk-formats.txt: add description for %pMR
Applying: lib/vsprintf.c: remind people to update Documentation/printk-form=
ats.txt when adding printk formats
Applying: drivers/video/backlight/atmel-pwm-bl.c: use devm_ functions
Applying: drivers/video/backlight/ot200_bl.c: use devm_ functions
Applying: drivers/video/backlight/lm3533_bl.c: use devm_ functions
Applying: backlight: atmel-pwm-bl: use devm_gpio_request()
Applying: backlight: ot200_bl: use devm_gpio_request()
Applying: backlight: tosa_lcd: use devm_gpio_request()
Applying: backlight: tosa_bl: use devm_gpio_request()
Applying: backlight: lms283gf05: use devm_gpio_request()
Applying: backlight: corgi_lcd: use devm_gpio_request()
Applying: backlight: l4f00242t03: export and use devm_gpio_request_one()
Applying: string: introduce memweight()
Applying: string-introduce-memweight-fix
Applying: string: fix build error caused by memweight() introduction
Applying: qnx4fs: use memweight()
Applying: dm: use memweight()
Applying: affs: use memweight()
Applying: video/uvc: use memweight()
Applying: ocfs2: use memweight()
Applying: ext2: use memweight()
Applying: ext3: use memweight()
Applying: ext4: use memweight()
Applying: checkpatch: Update alignment check
Applying: checkpatch: test for non-standard signatures
Applying: checkpatch: check usleep_range() arguments
Applying: drivers/rtc/rtc-coh901331.c: use clk_prepare/unprepare
Applying: drivers/rtc/rtc-coh901331.c: use devm allocation
Applying: drivers/rtc/rtc-ab8500.c: use IRQF_ONESHOT when requesting a thre=
aded IRQ
Applying: rtc: pl031: encapsulate per-vendor ops
Applying: rtc: pl031: use per-vendor variables for special init
Applying: rtc: pl031: fix up IRQ flags
Applying: drivers/rtc/rtc-ab8500.c: use UIE emulation
Applying: drivers-rtc-rtc-ab8500c-use-uie-emulation-checkpatch-fixes
Applying: drivers/rtc/rtc-ab8500.c: remove fix for AB8500 ED version
Applying: drivers/rtc/rtc-r9701.c: avoid second call to rtc_valid_tm()
Applying: drivers/rtc/rtc-r9701.c: check that r9701_set_datetime() succeeded
Applying: hfsplus: use -ENOMEM when kzalloc() fails
Applying: hfsplus: make hfsplus_sync_fs() static
Applying: hfsplus: amend debugging print
Applying: hfsplus: remove useless check
Applying: hfsplus: get rid of write_super
Applying: hfsplus-get-rid-of-write_super-checkpatch-fixes
Applying: kmod: avoid deadlock from recursive kmod call
Applying: fork: use vma_pages() to simplify the code
Applying: fork-use-vma_pages-to-simplify-the-code-fix
Applying: ipc/sem.c: alternatives to preempt_disable()
Applying: drivers/char/ipmi/ipmi_watchdog.c: remove local ioctl defines rep=
laced by generic ones
Applying: fs: cachefiles: add support for large files in filesystem caching
Applying: fs-cachefiles-add-support-for-large-files-in-filesystem-caching-f=
ix
Applying: c/r: fcntl: add F_GETOWNER_UIDS option
Merging quilt/akpm (5e84c96 c/r: fcntl: add F_GETOWNER_UIDS option)

--Signature=_Tue__26_Jun_2012_16_41_39_+1000_N1iVBxsvswoKbGk+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP6VmjAAoJEECxmPOUX5FEG14P/jfvxLTFkReF2/WmN80FKsNz
2Jns4K1y+04u8cDYRBlGc2kVc+A1m3KH7J+li7CokbWMDrHsCdoV+BPNF/wvYvCY
BwnENNzaZDPwisI2K97e6QfM/PwqsxvO3lLRKWKwP/hZr+BYk+aONT4aQecRiOET
glwFNsUuu4JYGNdT/vdg75x+rL2vHbz9H7vXpJuoXv+PPf1CJYny4K2Xnfbg/n0J
9PAU+/UA7RR9GTBOP+RB7VmymUoOAuiNu+IdgFlryOJrWuqgS/hVOm8SnJkfTYQu
3uHDjy5jNUG22peFw206hl5NcHN7fuy4AX72V3EGPr5gi9DL1gig73tJb9vc1iLy
SXZ3z9AiqLtsG5wVOm6NeHkpQtniC1nvc07EoXh4F23ACNBfNGzhGpyvFh9VpLEy
5ifndKX6OEV9cbHtpQt5FOcnqBXc4l9V+0YvOrXWt+dAhne6aw73uAYkUrkcuhEh
cm1Q6h/OPjgKSkAwEBIGRwkvNn/eadpJ1qLlAitaITtgriZxES6/9MFtM1kHOHWO
kIyR8cwVEWcdHileaKFHpveCsKt1ReHRG+mCR3qzSt8ithLcqSv/tbMwf01CUsnz
msZerEs1lfgEDvmBnfbabc7F3hcGJMTAyLWmnXHdVwJ78QVNftdUly3vQwLX+/eC
nZ9Kve8/ydYfWc+Dq798
=imVn
-----END PGP SIGNATURE-----

--Signature=_Tue__26_Jun_2012_16_41_39_+1000_N1iVBxsvswoKbGk+--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832Ab2ITHp3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 03:45:29 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:37987 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753144Ab2ITHpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 03:45:20 -0400
Date: Thu, 20 Sep 2012 17:45:18 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Sept 20
Message-Id: <20120920174518.1118618219c531ba92b7a22f@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__20_Sep_2012_17_45_18_+1000_/GtmF7gXEXgIxqUt"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__20_Sep_2012_17_45_18_+1000_/GtmF7gXEXgIxqUt
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 201209019:

The net-next tree gained a build failure for which I reverted a commit.

The bluetooth tree lost its build failure.

The rr tree lost its conflicts.

The arm-soc tree gained conflicts against the arm and sound-asoc trees.

The ixp4xx tree gained a conflict against the arm-soc tree.

The signal tree gained a conflict against the tip tree.

The akpm tree lost a patch that turned up elsewhere.

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

We are up to 200 trees (counting Linus' and 26 trees of patches pending
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
Merging origin/master (c46de22 Merge branch 'for-linus' of git://git.kernel=
.dk/linux-block)
Merging fixes/master (9023a40 Merge tag 'mmc-fixes-for-3.5-rc4' of git://gi=
t.kernel.org/pub/scm/linux/kernel/git/cjb/mmc)
Merging kbuild-current/rc-fixes (6c7080a firmware: fix directory creation r=
ule matching with make 3.82)
Merging arm-current/fixes (6f7dad7 Merge branch 'clkdev' into fixes)
Merging m68k-current/for-linus (3be7184 m68k: Add missing RCU idle APIs on =
idle loop)
Merging powerpc-merge/merge (636802e powerpc: Don't use __put_user() in pat=
ch_instruction)
Merging sparc/master (5698bd7 Linux 3.6-rc6)
Merging net/master (8ea853f net/core: fix comment in skb_try_coalesce)
Merging sound-current/for-linus (5d037f9 Merge tag 'asoc-3.6' of git://git.=
kernel.org/pub/scm/linux/kernel/git/broonie/sound into for-linus)
Merging pci-current/for-linus (0ff9514 PCI: Don't print anything while deco=
ding is disabled)
Merging wireless/master (a7be50b iwlwifi: don't double free the interrupt i=
n failure path)
Merging driver-core.current/driver-core-linus (5698bd7 Linux 3.6-rc6)
Merging tty.current/tty-linus (5698bd7 Linux 3.6-rc6)
Merging usb.current/usb-linus (5698bd7 Linux 3.6-rc6)
Merging staging.current/staging-linus (5698bd7 Linux 3.6-rc6)
Merging char-misc.current/char-misc-linus (fea7a08 Linux 3.6-rc3)
Merging input-current/for-linus (35b1da4 Input: edt-ft5x06 - return -EFAULT=
 on copy_to_user() error)
Merging md-current/for-linus (58e94ae md/raid1: close some possible races o=
n write errors during resync)
Merging audit-current/for-linus (c158a35 audit: no leading space in audit_l=
og_d_path prefix)
Merging crypto-current/master (9b2f4cb crypto: authenc - Fix crash with zer=
o-length assoc data)
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
Merging arm/for-next (18824d9 Merge branches 'arch-timers', 'atags', 'cache=
-l2x0', 'clkdev', 'fixes', 'integrator', 'misc' and 'opcodes' into for-next)
Merging arm-perf/for-next/perf (b90c4b9 Merge branch 'hw-breakpoint' into f=
or-next/perf)
CONFLICT (content): Merge conflict in arch/arm/kernel/hw_breakpoint.c
Merging davinci/davinci-next (fe0d422 Linux 3.0-rc6)
Merging xilinx/arm-next (b85a3ef ARM: Xilinx: Adding Xilinx board support)
Merging arm64/upstream (3807422 arm64: MAINTAINERS update)
Merging blackfin/for-linus (6895f97 kbuild: add symbol prefix arg to kallsy=
ms)
Merging c6x/for-linux-next (55d512e Linux 3.6-rc5)
Merging cris/for-next (2608747 CRIS: Remove VCS simulator specific code)
Merging hexagon/linux-next (5042ab9 various Kconfig cleanup and old platfor=
m build code removal)
Merging ia64/next (36a45e7 [IA64] kexec: Move the dereference below the NUL=
L test)
Merging m68k/for-next (f82735d m68k: Use PTR_RET rather than if(IS_ERR(...)=
) + PTR_ERR)
Merging m68knommu/for-next (42ec574 m68knommu: use "r", not "i" constraint =
in cacheflus asm's)
Merging microblaze/next (a01ee16 Merge branch 'for-linus' of git://git.open=
-osd.org/linux-open-osd)
Merging mips/mips-for-linux-next (f50296d Merge branch 'next/p3/trace' into=
 mips-for-linux-next)
Merging openrisc/for-upstream (807607f openrisc: delay: fix handling of cou=
nter overflow)
Merging parisc/for-next (5b24c42 [PARISC] fix personality flag check in cop=
y_thread())
Merging s390/features (dfc09c0 s390/cmpxchg,percpu: implement cmpxchg_doubl=
e())
Merging sh/sh-latest (5e071e2 sh: Fix up TIF_NOTIFY_RESUME sans TIF_SIGPEND=
ING handling.)
Merging sparc-next/master (65d5fcf sparc64: Fix IV handling bug in des_spar=
c64_cbc_decrypt)
Merging tile/master (bdc0077 Merge tag 'scsi-misc' of git://git.kernel.org/=
pub/scm/linux/kernel/git/jejb/scsi)
Merging unicore32/unicore32 (e4baa56 UniCore32-bugfix: Remove definitions i=
n asm/bug.h to solve difference between native and cross compiler)
Merging xtensa/for_next (c46de22 Merge branch 'for-linus' of git://git.kern=
el.dk/linux-block)
Merging ceph/master (1fe5e99 rbd: create rbd_refresh_helper())
Merging cifs/for-next (fdb4dbe [CIFS] Allow SMB3 negotiation)
Merging configfs/linux-next (b930c26 Merge branch 'for-linus' of git://git.=
kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (0d7614f Linux 3.6-rc1)
Merging ext3/for_next (09e05d4 jbd: Fix assertion failure in commit code du=
e to lacking transaction credits)
Merging ext4/dev (59e31c1 ext4: fix online resizing when the # of block gro=
ups is constant)
Merging fuse/for-next (c7a3f5e fuse: Move CUSE Kconfig entry from fs/Kconfi=
g into fs/fuse/Kconfig)
Merging gfs2/master (a8b7d6c GFS2: Fix infinite loop in rbm_find)
CONFLICT (content): Merge conflict in fs/gfs2/rgrp.c
Merging jfs/jfs-next (84f4141 jfs: Fix do_div precision in commit b40c2e66)
Merging logfs/master (ab2ec19 logfs: fix possible memory leak in logfs_mtd_=
can_write_buf())
Merging nfs/linux-next (a519fc7 SUNRPC: Ensure that the TCP socket is close=
d when in CLOSE_WAIT)
Merging nfsd/nfsd-next (fac7a17 nfsd4: cast readlink() bug argument)
Merging ocfs2/linux-next (4538df6 ocfs2: Don't spam on -EDQUOT.)
Merging omfs/for-next (976d167 Linux 3.1-rc9)
Merging squashfs/master (4b0180a Squashfs: add mount time sanity check for =
block_size and block_log match)
Merging v9fs/for-next (552aad0 9P: Fix race between p9_write_work() and p9_=
fd_request())
Merging ubifs/linux-next (3668b70 UBIFS: print less)
Merging xfs/for-next (4026c9f xfs: stop the sync worker before xfs_unmountf=
s)
Merging vfs/for-next (61a1384 fanotify: sanitize failure exits in copy_even=
t_to_user())
Merging pci/next (9b9a6d2 Merge branch 'pci/thierry-fixup-irqs' into next)
Merging powerpc/next (caa1d63 Merge remote-tracking branch 'kumar/next' int=
o next)
Merging 4xx/next (2074b1d powerpc: Fix irq distribution)
Merging mpc5xxx/next (9d9fd88 powerpc/mpc52xx_lpbfifo: optionally defer fif=
o transfer start)
Merging galak/next (4d56dec powerpc/fsl-pci: fix warning when CONFIG_SWIOTL=
B is disabled)
Merging hid/for-next (77acb89 Merge branch 'from-henrik' into for-next)
Merging quilt/i2c (3969d54 i2c: Make I2C available on UML)
Merging i2c-embedded/i2c-embedded/for-next (2bdbfa9 i2c: davinci: preparati=
on for switch to common clock framework)
Merging quilt/jdelvare-hwmon (820d1e2 hwmon: (coretemp) Use get_online_cpus=
 to avoid races involving CPU hotplug)
Merging hwmon-staging/hwmon-next (d6f4ee0 hwmon: (lm70) Simplify show_name =
function)
Merging v4l-dvb/master (624bfcc Merge /home/v4l/v4l/patchwork)
CONFLICT (content): Merge conflict in arch/arm/mach-imx/mach-imx27_visstrim=
_m10.c
Merging kbuild/for-next (c781288 Merge branches 'kbuild/kbuild', 'kbuild/kc=
onfig' and 'kbuild/misc' into kbuild/for-next)
Merging kconfig/for-next (45f4c81 localmodconfig: Use my variable for loop =
in streamline_config.pl)
Merging libata/NEXT (633de4c [libata] export ata_dev_set_feature())
Merging infiniband/for-next (17e9ba4 Merge branches 'cma' and 'mlx4-sriov' =
into for-next)
Merging pstore/master (65f8c95 pstore/ftrace: Convert to its own enable/dis=
able debugfs knob)
Merging acpi/next (9d0b01a Merge branches 'delete-gts-bfs', 'misc', 'novell=
-bugzilla-757888-numa' and 'osc-pcie' into base)
Merging cpuidle/cpuidle-next (3cf7997 acpi: intel_idle : break dependency b=
etween modules)
CONFLICT (content): Merge conflict in include/linux/cpuidle.h
CONFLICT (add/add): Merge conflict in drivers/cpuidle/coupled.c
Merging cpupowerutils/master (f166033 cpupower tools: add install target to=
 the debug tools' makefiles)
Merging thermal/next (2de237a thermal: exynos: Use devm_* functions)
Merging ieee1394/for-next (e3cbd92 firewire: core: document is_local sysfs =
attribute)
Merging ubi/linux-next (9bfd58f UBI: fix trivial typo 'it' =3D> 'is')
Merging dlm/next (2b75bc9 dlm: check the maximum size of a request from use=
r)
Merging scsi/for-next (cea6340 Merge branch 'misc' into for-next)
CONFLICT (content): Merge conflict in drivers/scsi/qla2xxx/qla_nx.c
CONFLICT (content): Merge conflict in drivers/scsi/ipr.c
Merging target-updates/for-next (37bb789 target: fix return code in target_=
core_init_configfs error path)
Merging target-merge/for-next-merge (d987569 Linux 3.6-rc2)
Merging ibft/linux-next (935a9fe ibft: Fix finding IBFT ACPI table on UEFI)
Merging isci/all (6734092 isci: add a couple __iomem annotations)
Merging slave-dma/next (0274788 DMA: PL330: return ENOMEM instead of 0 from=
 pl330_alloc_chan_resources)
Merging dmaengine/next (a2bd114 netdma: adding alignment check for NETDMA o=
ps)
Merging net-next/master (aee77e4 r8169: use unlimited DMA burst for TX)
CONFLICT (content): Merge conflict in net/socket.c
CONFLICT (content): Merge conflict in net/ipv4/route.c
CONFLICT (content): Merge conflict in net/ipv4/fib_frontend.c
Applying: net: cope with sock_alloc_file() API change
Merging wireless-next/master (7a5f799 rtlwifi: Remove EXPERIMENTAL as pre-r=
equisite for the drivers)
Merging bluetooth/master (0c1abbd Bluetooth: Add support for BCM20702A0 [04=
ca, 2003])
Merging mtd/master (2361f73 Merge tag 'v3.6-rc2' of git://git.kernel.org/pu=
b/scm/linux/kernel/git/torvalds/linux)
Merging l2-mtd/master (a124642 mtd: basic (read only) driver for BCMA seria=
l flash)
Merging crypto/master (821873a hwrng: mxc-rnga - Access data via structure)
CONFLICT (content): Merge conflict in crypto/Kconfig
Merging drm/drm-next (7facf16 Merge branch 'for-airlied' of git://people.fr=
eedesktop.org/~danvet/drm-intel into drm-next)
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/intel_sdvo.c
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/i915_dma.c
Merging sound/for-next (c40bd91 ALSA: hda - avoid non-standard "Docking" na=
me in mixers)
Merging sound-asoc/for-next (7f0f58f Merge branch 'for-3.7' into asoc-next)
CONFLICT (content): Merge conflict in arch/arm/mach-imx/mach-imx27_visstrim=
_m10.c
Merging quilt/rr (98bec22 drivers/virtio/virtio_pci.c: fix error return cod=
e)
Merging input/next (fb4f552 Input: hgpk - use %*ph to dump small buffer)
Merging input-mt/for-next (51c80b7 Input: bcm5974 - Convert to MT-B)
Merging cgroup/for-next (c0a93e2 Merge branch 'for-3.7-hierarchy' into for-=
next)
Merging block/for-next (3406fea Merge branch 'for-3.7/drivers' into for-nex=
t)
Merging quilt/device-mapper (e56559b Use the recently-added bio front_pad f=
ield to allocate struct dm_target_io.)
Merging embedded/master (4744b43 embedded: fix vc_translate operator preced=
ence)
Merging firmware/master (6e03a20 firmware: speed up request_firmware(), v3)
Merging pcmcia/master (80af9e6 pcmcia at91_cf: fix raw gpio number usage)
Merging mmc/mmc-next (273ec98 mmc: sdhci-pxav3: Use sdhci_get_of_property f=
or parsing DT quirks)
Merging kgdb/kgdb-next (15d7ea0 kgdboc: Accept either kbd or kdb to activat=
e the vga + keyboard kdb shell)
Merging slab/for-next (333115f Merge branch 'slab/next' into for-next)
Merging uclinux/for-next (5e442a4 Revert "proc: fix races against execve() =
of /proc/PID/fd**")
Merging md/for-next (4f75eef raid: replace list_for_each_continue_rcu with =
new interface)
Merging mfd/for-next (144c94c mfd: Add lp8788 mfd driver)
CONFLICT (content): Merge conflict in drivers/regulator/anatop-regulator.c
CONFLICT (content): Merge conflict in drivers/mfd/tc3589x.c
CONFLICT (content): Merge conflict in drivers/mfd/max8925-core.c
CONFLICT (content): Merge conflict in drivers/mfd/88pm860x-core.c
CONFLICT (content): Merge conflict in Documentation/devicetree/bindings/reg=
ulator/tps6586x.txt
Merging battery/master (2815b78 power_supply: Add new power supply properti=
es CHARGE_CURRENT/VOLTAGE_MAX)
Merging fbdev/fbdev-next (75435c7 video: exynos_dp: move setting analog par=
ameter and interrupt to after sw reset)
Merging viafb/viafb-next (838ac78 viafb: avoid refresh and mode lookup in s=
et_par)
Merging omap_dss2/for-next (6659145 Merge branch 'fbdev-for-linus' of git:/=
/github.com/schandinat/linux-2.6)
Merging regulator/for-next (be9bfd9 Merge branch 'regulator-drivers' into r=
egulator-next)
CONFLICT (content): Merge conflict in Documentation/devicetree/bindings/reg=
ulator/tps6586x.txt
Merging security/next (46a2f3b Smack: setprocattr memory leak fix)
Merging selinux/master (c2d7b24 Merge tag 'v3.4' into 20120409)
Merging lblnet/master (7e27d6e Linux 2.6.35-rc3)
Merging watchdog/master (b232a70 watchdog: move the dereference below the N=
ULL test)
Merging dwmw2-iommu/master (c3b92c8 Linux 3.1)
Merging iommu/next (c9e7432 Merge branches 'iommu/fixes', 'arm/tegra', 'arm=
/exynos', 'x86/amd' and 'x86/vt-d' into next)
Merging vfio/next (d987569 Linux 3.6-rc2)
Merging osd/linux-next (b8017d2 exofs: check for allocation failure in uri_=
store())
Merging jc_docs/docs-next (5c050fb docs: update the development process doc=
ument)
Merging trivial/for-next (527a136 btrfs: fix trivial typo for the comment o=
f BTRFS_FREE_INO_OBJECTID)
CONFLICT (content): Merge conflict in drivers/video/backlight/88pm860x_bl.c
CONFLICT (content): Merge conflict in drivers/scsi/ipr.c
Merging audit/for-next (dcd6c92 Linux 3.3-rc1)
Merging pm/linux-next (56e9f9d Merge branch 'pm-cpufreq-next' into linux-ne=
xt)
CONFLICT (content): Merge conflict in drivers/cpufreq/powernow-k8.c
Merging apm/for-next (fb9d78a Merge branch 'for-linus' of git://git.kernel.=
org/pub/scm/linux/kernel/git/jikos/apm)
Merging fsnotify/for-next (1aec9c0 inotify: automatically restart syscalls)
CONFLICT (content): Merge conflict in kernel/audit_tree.c
Merging edac/linux_next (a92cdec Merge branch 'devel' into next)
Merging edac-amd/for-next (305f1c3 Merge branch '3.3-pci_device_id' into ed=
ac-for-next)
CONFLICT (content): Merge conflict in drivers/edac/amd64_edac.c
CONFLICT (content): Merge conflict in Documentation/edac.txt
Merging devicetree/devicetree/next (efd68e7 devicetree: add helper inline f=
or retrieving a node's full name)
Merging dt-rh/for-next (ee67016 of: i2c: add support for wakeup-source prop=
erty)
Merging spi/spi/next (d8e328b spi: Add "spi:" prefix to modalias attribute =
of spi devices)
Merging spi-mb/spi-next (337ef8d Merge branch 'spi-drivers' into spi-next)
CONFLICT (content): Merge conflict in drivers/mmc/host/mxs-mmc.c
Merging tip/auto-latest (0ce2151 Merge branch 'x86/cleanups')
CONFLICT (content): Merge conflict in arch/s390/Kconfig
CONFLICT (content): Merge conflict in arch/Kconfig
Merging rcu/rcu/next (f417d2b Merge branches 'bigrt.2012.09.17c', 'doctortu=
re.2012.09.18a', 'fixes.2012.09.17a', 'hotplug.2012.09.17a' and 'idle.2012.=
09.18b' into HEAD)
CONFLICT (content): Merge conflict in kernel/sched/core.c
CONFLICT (content): Merge conflict in kernel/rcutree_plugin.h
CONFLICT (content): Merge conflict in kernel/rcutree.h
CONFLICT (content): Merge conflict in arch/x86/Kconfig
CONFLICT (content): Merge conflict in arch/Kconfig
Merging cputime/cputime (c3e0ef9 [S390] fix cputime overflow in uptime_proc=
_show)
Merging uprobes/for-next (0326f5a uprobes/core: Handle breakpoint and singl=
estep exceptions)
Merging kmemleak/kmemleak (4878677 kmemleak: do not leak object after tree =
insertion error)
Merging kvm/linux-next (ecba9a5 KVM: x86: lapic: Clean up find_highest_vect=
or() and count_vectors())
CONFLICT (content): Merge conflict in arch/x86/kvm/i8259.c
CONFLICT (content): Merge conflict in arch/s390/include/asm/processor.h
Merging kvm-ppc/kvm-ppc-next (a805aef KVM: Move some PPC ioctl definitions =
to the correct place)
Merging oprofile/for-next (61bccf1 oprofile: Remove 'WQ on CPUx, prefer CPU=
y' warning)
Merging xen/upstream/xen (af3a3ab Merge git://git.kernel.org/pub/scm/linux/=
kernel/git/steve/gfs2-3.0-fixes)
Merging xen-two/linux-next (7a97c2a Merge branch 'stable/for-linus-3.6' int=
o linux-next)
Merging xen-pvhvm/linux-next (b056b6a xen: suspend: remove xen_hvm_suspend)
Merging percpu/for-next (61011677 Merge tag 'dlm-3.5' of git://git.kernel.o=
rg/pub/scm/linux/kernel/git/teigland/linux-dlm)
Merging workqueues/for-next (f767d86 Merge branch 'for-3.7' into for-next)
CONFLICT (content): Merge conflict in drivers/video/omap2/displays/panel-ta=
al.c
CONFLICT (content): Merge conflict in drivers/isdn/mISDN/hwchannel.c
CONFLICT (modify/delete): drivers/hid/hid-picolcd.c deleted in HEAD and mod=
ified in workqueues/for-next. Version workqueues/for-next of drivers/hid/hi=
d-picolcd.c left in tree.
$ git rm -f drivers/hid/hid-picolcd.c
Merging drivers-x86/linux-next (455f38c eeepc-laptop: fix device reference =
count leakage in eeepc_rfkill_hotplug())
Merging hwpoison/hwpoison (46e387b Merge branch 'hwpoison-hugepages' into h=
wpoison)
Merging sysctl/master (4e474a0 sysctl: protect poll() in entries that may g=
o away)
Merging regmap/for-next (e9bfb35 Merge branch 'regmap-irq' into regmap-next)
Merging hsi/for-next (43139a6 HSI: hsi_char: Update ioctl-number.txt)
Merging leds/for-next (8b7cfbe leds: Add new LED driver for lm3642 chips)
Merging driver-core/driver-core-next (666f355 device and dynamic_debug: Use=
 dev_vprintk_emit and dev_printk_emit)
Applying: extcon: adc_jack: update for INIT_DELAYED_WORK_DEFERRABLE name ch=
ange
Merging tty/tty-next (5de6934 tty/serial: put (EXPERIMENTAL) marking back o=
n N_GSM and SERIAL_IFX6X60)
Merging usb/usb-next (44b0f08 USB: serial: fix up bug with missing {})
CONFLICT (content): Merge conflict in drivers/usb/serial/mos7840.c
CONFLICT (content): Merge conflict in drivers/usb/serial/mos7720.c
CONFLICT (content): Merge conflict in drivers/usb/serial/kl5kusb105.c
CONFLICT (content): Merge conflict in drivers/usb/serial/io_ti.c
CONFLICT (content): Merge conflict in drivers/usb/serial/io_edgeport.c
CONFLICT (content): Merge conflict in drivers/usb/serial/digi_acceleport.c
Applying: USB: serial: fix vizzini driver for move of the termios object
Merging staging/staging-next (5d06e3d staging: comedi: don't dereference us=
er memory for INSN_INTTRIG)
CONFLICT (content): Merge conflict in drivers/staging/serqt_usb2/serqt_usb2=
.c
CONFLICT (content): Merge conflict in drivers/staging/omap-thermal/omap-the=
rmal-common.c
CONFLICT (content): Merge conflict in drivers/staging/ipack/devices/ipoctal=
.c
Applying: HID: sensors: fix up for mfd_add_devices() API change
Merging char-misc/char-misc-next (6592921 char/misc: remove CONFIG_EXPERIME=
NTAL dependencies)
Merging tmem/linux-next (15773b6 Merge branch 'stable/for-linus-3.6' into l=
inux-next)
Merging writeback/writeback-for-next (0e2f2b2 writeback: correct comment fo=
r move_expired_inodes())
Merging arm-dt/devicetree/arm-next (ede338f dt: add documentation of ARM dt=
 boot interface)
Merging hwspinlock/linux-next (8b37fcf hwspinlock: add MAINTAINERS entries)
Merging pinctrl/for-next (01194d6 ARM: ux500: tidy up pin sleep modes)
Merging vhost/linux-next (e0953c8 tun: experimental zero copy tx support)
CONFLICT (content): Merge conflict in drivers/net/tun.c
Merging memblock/memblock-kill-early_node_map (7bd0b0f memblock: Reimplemen=
t memblock allocation using reverse free area iterator)
Merging remoteproc/for-next (2e37abb remoteproc: create a 'recovery' debugf=
s entry)
Merging irqdomain/irqdomain/next (f5a1ad0 irqdomain: Improve diagnostics wh=
en a domain mapping fails)
Merging gpio/gpio/next (ddf343f Merge branch 'for-linus' of git://git.kerne=
l.org/pub/scm/linux/kernel/git/s390/linux)
Merging gpio-lw/for-next (78c703f Merge branch 'devel' into for-next)
Merging arm-soc/for-next (8ebc882 Merge branch 'next/cleanup' into for-next)
CONFLICT (modify/delete): sound/soc/omap/overo.c deleted in HEAD and modifi=
ed in arm-soc/for-next. Version arm-soc/for-next of sound/soc/omap/overo.c =
left in tree.
CONFLICT (modify/delete): sound/soc/omap/omap3evm.c deleted in HEAD and mod=
ified in arm-soc/for-next. Version arm-soc/for-next of sound/soc/omap/omap3=
evm.c left in tree.
CONFLICT (modify/delete): sound/soc/omap/omap3beagle.c deleted in HEAD and =
modified in arm-soc/for-next. Version arm-soc/for-next of sound/soc/omap/om=
ap3beagle.c left in tree.
CONFLICT (modify/delete): sound/soc/omap/igep0020.c deleted in HEAD and mod=
ified in arm-soc/for-next. Version arm-soc/for-next of sound/soc/omap/igep0=
020.c left in tree.
CONFLICT (content): Merge conflict in drivers/w1/masters/omap_hdq.c
CONFLICT (content): Merge conflict in drivers/video/omap2/dss/dispc.c
CONFLICT (content): Merge conflict in drivers/usb/host/Kconfig
CONFLICT (content): Merge conflict in drivers/staging/tidspbridge/core/wdt.c
CONFLICT (content): Merge conflict in drivers/mtd/nand/Kconfig
CONFLICT (content): Merge conflict in drivers/mmc/host/omap.c
CONFLICT (content): Merge conflict in drivers/input/keyboard/omap-keypad.c
CONFLICT (content): Merge conflict in drivers/i2c/busses/i2c-omap.c
CONFLICT (content): Merge conflict in arch/arm/mach-ux500/cpu-db8500.c
CONFLICT (content): Merge conflict in arch/arm/mach-integrator/integrator_c=
p.c
CONFLICT (content): Merge conflict in arch/arm/mach-imx/clk-imx51-imx53.c
$ git rm -f sound/soc/omap/igep0020.c sound/soc/omap/omap3beagle.c sound/so=
c/omap/omap3evm.c sound/soc/omap/overo.c
Merging ep93xx/ep93xx-for-next (70f0f7c Merge branch 'ep93xx-fixes' into ep=
93xx-for-next)
Merging ixp4xx/next (1d2d793 ixp4xx: Declare MODULE_FIRMWARE usage)
CONFLICT (content): Merge conflict in arch/arm/mach-ixp4xx/include/mach/ixp=
4xx-regs.h
CONFLICT (content): Merge conflict in arch/arm/mach-ixp4xx/common.c
Merging msm/for-next (fe3a47b ARM: msm: Allow 8960 and 8660 to compile toge=
ther)
CONFLICT (rename/delete): arch/arm/mach-vt8500/include/mach/restart.h delet=
ed in msm/for-next and renamed in HEAD. Version HEAD of arch/arm/mach-vt850=
0/include/mach/restart.h left in tree.
Merging renesas/next (2e2e9d5 Merge branch 'heads/boards' into next)
Merging samsung/for-next (5779e9a Merge branch 'v3.7-samsung-fixes-1' into =
for-next)
CONFLICT (content): Merge conflict in drivers/pinctrl/Makefile
Merging tegra/for-next (e0d5f8c Merge branch 'for-3.7/dt2' into for-next)
CONFLICT (modify/delete): arch/arm/mach-tegra/devices.c deleted in tegra/fo=
r-next and modified in HEAD. Version HEAD of arch/arm/mach-tegra/devices.c =
left in tree.
$ git rm -f arch/arm/mach-tegra/devices.c
Merging kvmtool/master (5a337ac kvm tools: don't exit on debug ioport write)
Merging dma-mapping/dma-mapping-next (5306ea4 Merge branch 'next-cleanup' i=
nto HEAD)
CONFLICT (content): Merge conflict in arch/arm/boot/dts/highbank.dts
CONFLICT (content): Merge conflict in Documentation/devicetree/bindings/ata=
/ahci-platform.txt
Merging pwm/for-next (7b27c16 pwm: i.MX: fix clock lookup)
Merging dma-buf/for-next (55d512e Linux 3.6-rc5)
Merging userns/for-next (5fce5e0 userns: Convert drm to use kuid and kgid a=
nd struct pid where appropriate)
Merging ktest/for-next (648a182 ktest: Allow a test to override REBOOT_ON_S=
UCCESS)
Merging signal/for-next (b40400e alpha: don't open-code trace_report_syscal=
l_{enter,exit})
CONFLICT (content): Merge conflict in arch/x86/kernel/signal.c
CONFLICT (content): Merge conflict in arch/x86/kernel/process_32.c
CONFLICT (content): Merge conflict in arch/sh/kernel/entry-common.S
CONFLICT (content): Merge conflict in arch/sh/kernel/cpu/sh5/entry.S
CONFLICT (content): Merge conflict in arch/m32r/include/asm/Kbuild
CONFLICT (content): Merge conflict in arch/h8300/include/asm/Kbuild
CONFLICT (content): Merge conflict in arch/cris/include/asm/Kbuild
Merging clk/clk-next (494bfec clk: add of_clk_src_onecell_get() support)
Merging random/dev (d2e7c96 random: mix in architectural randomness in extr=
act_buf())
Merging scsi-post-merge/merge-base:master ()
$ git checkout akpm
Applying: idr: rename MAX_LEVEL to MAX_IDR_LEVEL
Applying: idr-rename-max_level-to-max_idr_level-fix
Applying: idr-rename-max_level-to-max_idr_level-fix-fix-2
Applying: idr-rename-max_level-to-max_idr_level-fix-3
Applying: CRIS: Fix I/O macros
Applying: selinux: fix sel_netnode_insert() suspicious rcu dereference
Applying: vfs: d_obtain_alias() needs to use "/" as default name.
Applying: x86 cpu_hotplug: unmap cpu2node when the cpu is hotremoved
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
Applying: audit.h: replace defines with C stubs
Applying: mn10300: only add -mmem-funcs to KBUILD_CFLAGS if gcc supports it
Applying: drivers/dma/dmaengine.c: lower the priority of 'failed to get' dm=
a channel message
Applying: pcmcia: move unbind/rebind into dev_pm_ops.complete
Applying: drm/i915: optimize DIV_ROUND_CLOSEST() call
Applying: timeconst.pl: remove deprecated defined(@array)
Applying: time: don't inline EXPORT_SYMBOL functions
Applying: checksyscalls: fix "here document" handling
Applying: kbuild: make: fix if_changed when command contains backslashes
Applying: h8300: select generic atomic64_t support
Applying: unicore32: select generic atomic64_t support
Applying: readahead: fault retry breaks mmap file read random detection
Applying: drivers/scsi/atp870u.c: fix bad use of udelay
Applying: cciss: cleanup bitops usage
Applying: cciss: use check_signature()
Applying: block: store partition_meta_info.uuid as a string
Applying: init: reduce PARTUUID min length to 1 from 36
Applying: block: partition: msdos: provide UUIDs for partitions
Applying: vfs: increment iversion when a file is truncated
Applying: fs: push rcu_barrier() from deactivate_locked_super() to filesyst=
ems
Applying: mm/page_alloc.c: remove duplicate check
Applying: mm: remove __GFP_NO_KSWAPD
Applying: x86, pat: remove the dependency on 'vm_pgoff' in track/untrack pf=
n vma routines
Applying: x86, pat: separate the pfn attribute tracking for remap_pfn_range=
 and vm_insert_pfn
Applying: x86-pat-separate-the-pfn-attribute-tracking-for-remap_pfn_range-a=
nd-vm_insert_pfn-fix
Applying: mm, x86, pat: rework linear pfn-mmap tracking
Applying: mm: introduce arch-specific vma flag VM_ARCH_1
Applying: mm: kill vma flag VM_INSERTPAGE
Applying: mm: kill vma flag VM_CAN_NONLINEAR
Applying: mm: use mm->exe_file instead of first VM_EXECUTABLE vma->vm_file
Applying: mm: kill vma flag VM_EXECUTABLE and mm->num_exe_file_vmas
Applying: mm: prepare VM_DONTDUMP for using in drivers
Applying: mm: kill vma flag VM_RESERVED and mm->reserved_vm counter
Applying: mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix
Applying: mm: fix nonuniform page status when writing new file with small b=
uffer
Applying: mm-fix-nonuniform-page-status-when-writing-new-file-with-small-bu=
ffer-fix
Applying: mm-fix-nonuniform-page-status-when-writing-new-file-with-small-bu=
ffer-fix-fix
Applying: mm/mmap.c: replace find_vma_prepare() with clearer find_vma_links=
()
Applying: mm-mmapc-replace-find_vma_prepare-with-clearer-find_vma_links fix
Applying: mm: compaction: update comment in try_to_compact_pages
Applying: mm: vmscan: scale number of pages reclaimed by reclaim/compaction=
 based on failures
Applying: mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-b=
ased-on-failures-fix
Applying: mm: compaction: capture a suitable high-order page immediately wh=
en it is made available
Applying: Revert "mm: mempolicy: Let vma_merge and vma_split handle vma->vm=
_policy linkages"
Applying: mempolicy: remove mempolicy sharing
Applying: mempolicy: fix a race in shared_policy_replace()
Applying: mempolicy: fix refcount leak in mpol_set_shared_policy()
Applying: mempolicy: fix a memory corruption by refcount imbalance in alloc=
_pages_vma()
Applying: mempolicy-fix-a-memory-corruption-by-refcount-imbalance-in-alloc_=
pages_vma-v2
Applying: mm: mmu_notifier: fix inconsistent memory between secondary MMU a=
nd host
Applying: mm-mmu_notifier-fix-inconsistent-memory-between-secondary-mmu-and=
-host-fix
Applying: mm: mmu_notifier: have mmu_notifiers use a global SRCU so they ma=
y safely schedule
Applying: mm/mmu_notifier: init notifier if necessary
Applying: mm/mmu_notifier: init notifier if necessary
Applying: mm/vmscan: fix error number for failed kthread
Applying: oom: remove deprecated oom_adj
Applying: mm: hugetlb: add arch hook for clearing page flags before enterin=
g pool
Applying: mm: adjust final #endif position in mm/internal.h
Applying: thp: fix the count of THP_COLLAPSE_ALLOC
Applying: thp: remove unnecessary check in start_khugepaged
Applying: thp: move khugepaged_mutex out of khugepaged
Applying: thp: remove unnecessary khugepaged_thread check
Applying: thp: remove wake_up_interruptible in the exit path
Applying: thp: remove some code depend on CONFIG_NUMA
Applying: thp: merge page pre-alloc in khugepaged_loop into khugepaged_do_s=
can
Applying: thp: release page in page pre-alloc path
Applying: thp: introduce khugepaged_prealloc_page and khugepaged_alloc_page
Applying: thp: remove khugepaged_loop
Applying: thp: use khugepaged_enabled to remove duplicate code
Applying: thp: remove unnecessary set_recommended_min_free_kbytes
Applying: mm: fix potential anon_vma locking issue in mprotect()
Applying: thp, x86: introduce HAVE_ARCH_TRANSPARENT_HUGEPAGE
Applying: thp: remove assumptions on pgtable_t type
Applying: thp: introduce pmdp_invalidate()
Applying: thp: make MADV_HUGEPAGE check for mm->def_flags
Applying: thp, s390: thp splitting backend for s390
Applying: thp, s390: thp pagetable pre-allocation for s390
Applying: thp, s390: disable thp for kvm host on s390
Applying: thp, s390: architecture backend for thp on s390
Applying: ipc/mqueue: remove unnecessary rb_init_node() calls
Applying: rbtree: reference Documentation/rbtree.txt for usage instructions
Applying: rbtree: empty nodes have no color
Applying: rbtree-empty-nodes-have-no-color-fix
Applying: rbtree: fix incorrect rbtree node insertion in fs/proc/proc_sysct=
l.c
Applying: rbtree: move some implementation details from rbtree.h to rbtree.c
Applying: rbtree: fix jffs2 build issue due to renamed __rb_parent_color fi=
eld
Applying: rbtree: performance and correctness test
Applying: rbtree-performance-and-correctness-test-fix
Applying: rbtree: break out of rb_insert_color loop after tree rotation
Applying: rbtree: adjust root color in rb_insert_color() only when necessary
Applying: rbtree: low level optimizations in rb_insert_color()
Applying: rbtree: adjust node color in __rb_erase_color() only when necessa=
ry
Applying: perf tools: fix build for another rbtree.c change
Applying: rbtree: optimize case selection logic in __rb_erase_color()
Applying: rbtree: low level optimizations in __rb_erase_color()
Applying: rbtree: coding style adjustments
Applying: rbtree: optimize fetching of sibling node
Applying: rbtree test: fix sparse warning about 64-bit constant
Applying: rbtree: add __rb_change_child() helper function
Applying: rbtree: place easiest case first in rb_erase()
Applying: rbtree: handle 1-child recoloring in rb_erase() instead of rb_era=
se_color()
Applying: rbtree: low level optimizations in rb_erase()
Applying: rbtree: augmented rbtree test
Applying: rbtree: faster augmented rbtree manipulation
Applying: rbtree: remove prior augmented rbtree implementation
Applying: rbtree: add RB_DECLARE_CALLBACKS() macro
Applying: rbtree: add prio tree and interval tree tests
Applying: mm: replace vma prio_tree with an interval tree
Applying: kmemleak: use rbtree instead of prio tree
Applying: prio_tree: remove
Applying: rbtree: move augmented rbtree functionality to rbtree_augmented.h
Applying: mm: interval tree updates
Applying: mm anon rmap: remove anon_vma_moveto_tail
Applying: mm anon rmap: replace same_anon_vma linked list with an interval =
tree.
Applying: mm rmap: remove vma_address check for address inside vma
Applying: mm: add CONFIG_DEBUG_VM_RB build option
Applying: mm: avoid taking rmap locks in move_ptes()
Applying: memory-hotplug: build zonelists when offlining pages
Applying: mm: mmu_notifier: make the mmu_notifier srcu static
Applying: mm: cma: discard clean pages during contiguous allocation instead=
 of migration
Applying: mm: page_alloc: use get_freepage_migratetype() instead of page_pr=
ivate()
Applying: mm: remain migratetype in freed page
Applying: memory-hotplug: bug fix race between isolation and allocation
Applying: memory-hotplug: fix pages missed by race rather than failing
Applying: memory-hotplug-fix-pages-missed-by-race-rather-than-failng-fix
Applying: atomic: implement generic atomic_dec_if_positive()
Applying: atomic-implement-generic-atomic_dec_if_positive-fix
Applying: swap: add a simple detector for inappropriate swapin readahead
Applying: swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix
Applying: mm/memblock: reduce overhead in binary search
Applying: mm/memblock: use existing interface to set nid
Applying: mm/memblock: cleanup early_node_map[] related comments
Applying: mm: compaction: abort compaction loop if lock is contended or run=
 too long
Applying: mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-t=
oo-long-fix
Applying: mm: compaction: check lock contention first before taking lock
Applying: mm/hugetlb.c: remove duplicate inclusion of header file
Applying: mm/page_alloc: refactor out __alloc_contig_migrate_alloc()
Applying: mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc-checkpatc=
h-fixes
Applying: memory-hotplug: don't replace lowmem pages with highmem
Applying: thp: khugepaged_prealloc_page() forgot to reset the page alloc in=
dicator
Applying: mm: compaction: move fatal signal check out of compact_checklock_=
irqsave
Applying: mm: compaction: Update try_to_compact_pages()kerneldoc comment
Applying: frv: kill used but uninitialized variable
Applying: score: select generic atomic64_t support
Applying: drivers/misc/lis3lv02d: add generic DT matching code
Applying: drivers/misc/lis3lv02d/lis3lv02d_spi.c: add DT matching table pas=
sthru code
Applying: lis3: lis3lv02d_spi.c: include linux/of.h
Applying: cross-arch: don't corrupt personality flags upon exec()
Applying: tile: fix personality bits handling upon exec()
Applying: kernel/sys.c: call disable_nonboot_cpus() in kernel_restart()
Applying: lib: vsprintf: optimize division by 10 for small integers
Applying: lib: vsprintf: optimize division by 10000
Applying: lib: vsprintf: optimize put_dec_trunc8()
Applying: lib: vsprintf: fix broken comments
Applying: lib/vsprintf: update documentation to cover all of %p[Mm][FR]
Applying: MAINTAINERS: update gpio subsystem file list
Applying: MAINTAINERS: add defconfig file to IMX section
Applying: MAINTAINERS: Update gianfar_ptp after renaming
Applying: drivers/video/backlight/pwm_bl.c: add device tree support for Low=
 Threshold Brightness
Applying: drivers/video/backlight/da9052_bl.c: use usleep_range() instead o=
f msleep() for small sleeps
Applying: drivers/video/backlight/ltv350qv.c: use usleep_range() instead of=
 msleep() for small sleeps
Applying: drivers/video/backlight/kb3886_bl.c: use usleep_range() instead o=
f msleep() for small sleeps
Applying: backlight: lp855x: add FAST bit description for LP8556
Applying: backlight: add Backlight driver for lm3630 chip
Applying: backlight-add-backlight-driver-for-lm3630-chip-fix
Applying: backlight: add new lm3639 backlight driver
Applying: backlight-add-new-lm3639-backlight-driver-fix
Applying: backlight-add-new-lm3639-backlight-driver-fix-2
Applying: backlight: remove ProGear driver
Applying: drivers/video/backlight/pwm_bl.c: use devm_pwm_get()
Applying: lib/parser.c: avoid overflow in match_number()
Applying: lib-parserc-avoid-overflow-in-match_number-fix
Applying: lib/Kconfig.debug: adjust hard-lockup related Kconfig options
Applying: lib/gcd.c: prevent possible div by 0
Applying: compat_ioctl: Remove unused local typedef
Applying: drivers/firmware/dmi_scan.c: check dmi version when get system uu=
id
Applying: drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid=
-fix
Applying: drivers/firmware/dmi_scan.c: fetch dmi version from SMBIOS if it =
exists
Applying: drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-ex=
ists-checkpatch-fixes
Applying: checkpatch: check utf-8 content from a commit log when it's missi=
ng from charset
Applying: checkpatch: update suggested printk conversions
Applying: checkpatch: check networking specific block comment style
Applying: CodingStyle: add networking specific block comment style
Applying: epoll: support for disabling items, and a self-test app
Applying: drivers/rtc/rtc-isl1208.c: add support for the ISL1218
Applying: rtc-proc: permit the /proc/driver/rtc device to use other devices
Applying: rtc: add Dallas DS2404 driver
Applying: rtc-add-dallas-ds2404-driver-fix
Applying: rtc: snvs: add Freescale rtc-snvs driver
Applying: rtc: snvs: change timeout to use a fixed number of loop
Applying: rtc: recycle id when unloading a rtc driver
Applying: drivers/rtc/rtc-at91sam9.c: use module_platform_driver() macro
Applying: rtc: tps65910: add RTC driver for TPS65910 PMIC RTC
Applying: rtc: add MAX8907 RTC driver
Applying: rtc: kconfig: remove unnecessary dependencies.
Applying: drivers/rtc/rtc-jz4740.c: fix IRQ error check
Applying: drivers/rtc/rtc-spear.c: fix several error checks
Applying: rtc: rc5t583: add ricoh rc5t583 RTC driver
Applying: drivers/rtc/rtc-coh901331.c: use clk_prepare_enable() and clk_dis=
able_unprepare()
Applying: rtc: rtc-mxc: adapt to the new i.mx clock framework
Applying: rtc: rtc-mxc: convert to module_platform_driver
Applying: rtc_sysfs_show_hctosys(): display 0 if resume failed
Applying: rtc_sysfs_show_hctosys-return-0-if-resume-failed-fix
Applying: rtc_sysfs_show_hctosys-return-0-if-resume-failed-fix-fix
Applying: fat: use accessor function for msdos_dir_entry 'start'
Applying: fat (exportfs): move NFS support code
Applying: fat (exportfs): fix dentry reconnection
Applying: fs/fat: fix a checkpatch issue in namei_msdos.c
Applying: fs/fat: fix some checkpatch issues in fat.h
Applying: fs/fat: chang indentation of some comments in fat.h
Applying: fs/fat: fix two checkpatch issues in cache.c
Applying: fs/fat: fix some small checkpatch issues in dir.c
Applying: fs/fat: fix all other checkpatch issues in dir.c
Applying: fs-fat-fix-all-other-checkpatch-issues-in-dirc-fix
Applying: fs/fat: fix checkpatch issues in fatent.c
Applying: fat: no need to reset EOF in ent_put for FAT32
Applying: fat: simplify writeback_inode()
Applying: fat-simplify-writeback_inode-checkpatch-fixes
Applying: fat-simplify-writeback_inode-checkpatch-fixes-fix
Applying: device_cgroup: add "deny_all" in dev_cgroup structure
Applying: device_cgroup: introduce dev_whitelist_clean()
Applying: device_cgroup: convert device_cgroup internally to policy + excep=
tions
Applying: device_cgroup: rename whitelist to exception list
Applying: coredump: prevent double-free on an error path in core dumper
Applying: coredump: move core dump functionality into its own file
Applying: coredump: make core dump functionality optional
Applying: fs: amended coredump-related sysctl functions
Applying: coredump-make-core-dump-functionality-optional-fix-fix
Applying: coredump: update coredump-related headers
Applying: proc: return -ENOMEM when inode allocation failed
Applying: proc: no need to initialize proc_inode->fd in proc_get_inode()
Applying: proc: use kzalloc instead of kmalloc and memset
Applying: proc-use-kzalloc-instead-of-kmalloc-and-memset-fix
Applying: proc_sysctl.c: use BUG_ON instead of BUG
Applying: fs/proc/root.c: use NULL instead of 0 for pointer
Applying: kdump: remove unneeded include
Applying: ipc/sem.c: alternatives to preempt_disable()
Applying: rapidio/tsi721: modify mport name assignment
Applying: nbd: add set flags ioctl
Applying: nbd: handle discard requests
Applying: aoe: for performance support larger packet payloads
Applying: aoe: kernel thread handles I/O completions for simple locking
Applying: aoe: cleanup an allocation a bit
Applying: aoe: become I/O request queue handler for increased user control
Applying: aoe: use a kernel thread for transmissions
Applying: aoe: use packets that work with the smallest-MTU local interface
Applying: aoe: failover remote interface based on aoe_deadsecs parameter
Applying: aoe: do revalidation steps in order
Applying: aoe: disallow unsupported AoE minor addresses
Applying: aoe: associate frames with the AoE storage target
Applying: aoe: increase net_device reference count while using it
Applying: aoe: remove unused code and add cosmetic improvements
Applying: aoe: update internal version number to 49
Applying: aoe: update copyright year in touched files
Applying: aoe: update documentation with new URL and VM settings reference
Applying: taskstats: cgroupstats_user_cmd() may leak on error
Applying: kernel/resource.c: fix stack overflow in __reserve_region_with_sp=
lit()
Applying: lib/decompress.c add __init to decompress_method and data
Merging akpm/master (7e926d7 lib/decompress.c add __init to decompress_meth=
od and data)
[master 6e93b16] Revert "i825xx: znet: fix compiler warnings when building =
a 64-bit kernel"

--Signature=_Thu__20_Sep_2012_17_45_18_+1000_/GtmF7gXEXgIxqUt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQWsmOAAoJEECxmPOUX5FEvlwP/315YIznidGK53qyN84kr4xW
MyRzEu01cTeueorUes4BYOGcQuNSwwnIJ8Esn314UPX1Dexwd/dDKZXfWrwxdOL+
WmZswnkLwAHKJbtATnK0oZs4q96gC6CmH6LWM2xUXmBDh45n5ff8ofBQr6N3IpNy
kMmtzIt6LKSjiK6Mvas2TMgIgzR02K5siLapKfKacvF1rZN8uK8yo+fbjgzSMHiF
bmpJqcYX830Y/Zj7ICNHuO2o5xPekbC8s+KCFFSp7cfMEtEBshnq/OrJSV762Npn
VJwirKtMmQRo91mStd/08zItzUxi54jrU1kaQ12xFc1qaa2V/di+QL82OANAvcLY
PN1vtgwBMWdu3wog0RFWOfS7URlIau3uy4M53KVKQ71cD+AEo8OGG12WuX6+fpYL
lyrU62Oi9BFM5WBxYh54sVFCREsTm5lsM81B0quB+as46TvzzDPGk16bn1B4xqt8
9fXjjDO1rmckGZ7Z+DLuQmG6TizQL27zDwIkvf9C2xot79ye4AnXa8YcsovXNimE
3WR2D2yZ7ckMu9wxy4ZI7WSV6PgTYEe17Uc1UH46j0spusnclMDBeaiTocln2Zpd
y3eN1+pzqV+pHk5jvBJdoljg6IsS/72IdD1L6FmdqrkGmC+3R0V0mnWiT5NwryjI
zzM6YOgysTTaTffOOXRB
=qB9+
-----END PGP SIGNATURE-----

--Signature=_Thu__20_Sep_2012_17_45_18_+1000_/GtmF7gXEXgIxqUt--

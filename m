Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980Ab2HXH2d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 03:28:33 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:45619 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382Ab2HXH2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 03:28:23 -0400
Date: Fri, 24 Aug 2012 17:28:20 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Aug 24
Message-Id: <20120824172820.ee0f412d2944b08789414207@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__24_Aug_2012_17_28_20_+1000_v4g5KjHVYyw3_uAj"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__24_Aug_2012_17_28_20_+1000_v4g5KjHVYyw3_uAj
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20120823:

The ubi tree gained a build failure so I used the version from
next-20120823.

The drm tree gained conflicts against Linus' tree and a build failure so
I used the version from next-20120823.

The sound tree gained a build failure for which I reverted a commit.

The kvm tree gained a build failure so I used the version from
next-20120822.

The drivers-x86 tree lost its build failure.

I have still reverted 3 commits from the signal tree at the request of
the arm maintainer.

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

We are up to 196 trees (counting Linus' and 26 trees of patches pending
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
Merging origin/master (fea7a08 Linux 3.6-rc3)
Merging fixes/master (9023a40 Merge tag 'mmc-fixes-for-3.5-rc4' of git://gi=
t.kernel.org/pub/scm/linux/kernel/git/cjb/mmc)
Merging kbuild-current/rc-fixes (f8f5701 Linux 3.5-rc1)
Merging arm-current/fixes (8986873 ARM: 7490/1: Drop duplicate select for G=
ENERIC_IRQ_PROBE)
Merging m68k-current/for-linus (3be7184 m68k: Add missing RCU idle APIs on =
idle loop)
Merging powerpc-merge/merge (ad36cb0 powerpc/kvm/book3s_32: Fix MTMSR_EERI =
macro)
Merging sparc/master (6dab7ed Merge branch 'fixes' of git://git.linaro.org/=
people/rmk/linux-arm)
Merging net/master (a0dfb26 af_packet: match_fanout_group() can be static)
Merging sound-current/for-linus (042b92c ALSA: hda - Do not set GPIOs for s=
peakers on IDT if there are no speakers)
Merging pci-current/for-linus (046c653 PCI/PM: Add ABI document for sysfs f=
ile d3cold_allowed)
Merging wireless/master (c6b6eed Merge branch 'for-john' of git://git.kerne=
l.org/pub/scm/linux/kernel/git/jberg/mac80211)
Merging driver-core.current/driver-core-linus (ebdc828 dyndbg: fix for SOH =
in logging messages)
Merging tty.current/tty-linus (38f8eef pmac_zilog,kdb: Fix console poll hoo=
k to return instead of loop)
Merging usb.current/usb-linus (8f057d7 gpu/mfd/usb: Fix USB randconfig prob=
lems)
Merging staging.current/staging-linus (6dab7ed Merge branch 'fixes' of git:=
//git.linaro.org/people/rmk/linux-arm)
Merging char-misc.current/char-misc-linus (f3261df 1-Wire: Add support for =
the maxim ds1825 temperature sensor)
Merging input-current/for-linus (6f4d038 Input: wacom - add support for EMR=
 on Cintiq 24HD touch)
Merging md-current/for-linus (58e94ae md/raid1: close some possible races o=
n write errors during resync)
Merging audit-current/for-linus (c158a35 audit: no leading space in audit_l=
og_d_path prefix)
Merging crypto-current/master (ce026cb crypto: caam - fix possible deadlock=
 condition)
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
Merging arm/for-next (22018e9 Merge branches 'fixes' and 'misc' into for-ne=
xt)
Merging arm-perf/for-next/perf (b90c4b9 Merge branch 'hw-breakpoint' into f=
or-next/perf)
Merging davinci/davinci-next (fe0d422 Linux 3.0-rc6)
Merging xilinx/arm-next (b85a3ef ARM: Xilinx: Adding Xilinx board support)
Merging blackfin/for-linus (719154c bf60x: fix build warning)
Merging c6x/for-linux-next (01ddd9a C6X: select GENERIC_ATOMIC64)
Merging cris/for-next (2608747 CRIS: Remove VCS simulator specific code)
Merging hexagon/linux-next (5042ab9 various Kconfig cleanup and old platfor=
m build code removal)
Merging ia64/next (a119365 [IA64] Redefine ATOMIC_INIT and ATOMIC64_INIT to=
 drop the casts)
Merging m68k/for-next (f82735d m68k: Use PTR_RET rather than if(IS_ERR(...)=
) + PTR_ERR)
Merging m68knommu/for-next (c4d1911 m68k: drop unused parts of 68VZ328 Make=
file)
Merging microblaze/next (a01ee16 Merge branch 'for-linus' of git://git.open=
-osd.org/linux-open-osd)
Merging mips/mips-for-linux-next (0e3127c Merge branch 'master' of git://de=
v.phrozen.org/mips-next into mips-for-linux-next)
Merging openrisc/for-upstream (207e715 openrisc: use scratch regs in atomic=
 syscall)
Merging parisc/for-next (5b24c42 [PARISC] fix personality flag check in cop=
y_thread())
Merging powerpc/next (bdc0077 Merge tag 'scsi-misc' of git://git.kernel.org=
/pub/scm/linux/kernel/git/jejb/scsi)
Merging 4xx/next (2074b1d powerpc: Fix irq distribution)
Merging mpc5xxx/next (4d2f4e1 powerpc: Option FB_FSL_DIU is not really opti=
onal for mpc512x)
Merging galak/next (a108cd4 powerpc/mpc85xx: Add new ext fields to Integrat=
ed FLash Controller)
Merging s390/features (53f6538 s390: update defconfig)
Merging sh/sh-latest (d4b7c5d sh: intc: Fix up multi-evt irq association.)
Merging sparc-next/master (442a7c4 sparc64: Add CRC32C driver making use of=
 the new crc32c opcode.)
Merging tile/master (bdc0077 Merge tag 'scsi-misc' of git://git.kernel.org/=
pub/scm/linux/kernel/git/jejb/scsi)
Merging unicore32/unicore32 (e4baa56 UniCore32-bugfix: Remove definitions i=
n asm/bug.h to solve difference between native and cross compiler)
Merging xtensa/for_next (499d9ec xtensa: ISS: exit simulator in case of hal=
t or panic)
Merging ceph/master (1fe5e99 rbd: create rbd_refresh_helper())
Merging cifs/for-next (ea7b488 CIFS: Fix cifs_do_create error hadnling)
Merging configfs/linux-next (b930c26 Merge branch 'for-linus' of git://git.=
kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (0d7614f Linux 3.6-rc1)
Merging ext3/for_next (68766a2 udf: fix retun value on error path in udf_lo=
ad_logicalvol)
Merging ext4/dev (8a2f846 ext4: remove duplicated declarations in inode.c)
Merging fuse/for-next (fb6ccff fuse: verify all ioctl retry iov elements)
Merging gfs2/master (400a0f5 GFS2: Fix ->show_options() for statfs slow)
Merging logfs/master (9f0bbd8 logfs: query block device for number of pages=
 to send with bio)
Merging nfs/linux-next (0866004 NFSv3: Ensure that do_proc_get_root() repor=
ts errors correctly)
Merging nfsd/nfsd-next (21179d8 knfsd: don't allocate file_locks on the sta=
ck)
Merging ocfs2/linux-next (4538df6 ocfs2: Don't spam on -EDQUOT.)
Merging omfs/for-next (976d167 Linux 3.1-rc9)
Merging squashfs/master (4b0180a Squashfs: add mount time sanity check for =
block_size and block_log match)
Merging v9fs/for-next (5fcb08b 9p: BUG before corrupting memory)
Merging ubifs/linux-next (69f9025 UBIFS: fix error messages spelling)
Merging xfs/for-next (643bfc0 xfs: check for possible overflow in xfs_ioc_t=
rim)
Merging vfs/for-next (61a1384 fanotify: sanitize failure exits in copy_even=
t_to_user())
Merging pci/next (0d7614f Linux 3.6-rc1)
Merging hid/for-next (b2b4948 Merge branch 'picolcd' into for-next)
Merging quilt/i2c (a918790 i2c: Convert struct i2c_msg initialization to C9=
9 format)
Merging i2c-embedded/i2c-embedded/for-next (c7751af ARM: davinci: i2c: add =
OF support)
Merging quilt/jdelvare-hwmon (4ac1223 hwmon: (coretemp) Use get_online_cpus=
 to avoid races involving CPU hotplug)
Merging hwmon-staging/hwmon-next (be6c078 hwmon: (adt7410) handle errors fr=
om adt7410_update_device())
Merging v4l-dvb/master (624bfcc Merge /home/v4l/v4l/patchwork)
Merging kbuild/for-next (85b170e Merge branches 'kbuild/kconfig' and 'kbuil=
d/misc' into kbuild/for-next)
Merging kconfig/for-next (45f4c81 localmodconfig: Use my variable for loop =
in streamline_config.pl)
Merging libata/NEXT (1b26d29 [libata] scsi: implement MODE SELECT command)
Merging infiniband/for-next (c0369b2 Merge branches 'cma', 'ipoib', 'misc',=
 'mlx4', 'ocrdma', 'qib' and 'srp' into for-next)
Merging pstore/master (1752548 pstore/ram: Add missing platform_device_unre=
gister)
Merging acpi/next (9d0b01a Merge branches 'delete-gts-bfs', 'misc', 'novell=
-bugzilla-757888-numa' and 'osc-pcie' into base)
Merging cpuidle/cpuidle-next (3cf7997 acpi: intel_idle : break dependency b=
etween modules)
CONFLICT (add/add): Merge conflict in drivers/cpuidle/coupled.c
Merging cpupowerutils/master (f166033 cpupower tools: add install target to=
 the debug tools' makefiles)
Merging thermal/next (449488c thermal: Fix potential NULL pointer accesses)
Merging ieee1394/for-next (e3cbd92 firewire: core: document is_local sysfs =
attribute)
Merging ubi/linux-next (8eb7106 UBI: disallow max_beb_per1024 on NOR flash)
$ git reset --hard HEAD^
Merging refs/next/20120823/ubi
Merging dlm/next (9c5bef5 dlm: cleanup send_to_sock routine)
Merging scsi/for-next (641aa03 Merge branch 'misc' into for-next)
CONFLICT (content): Merge conflict in drivers/ata/libata-core.c
Merging target-updates/for-next (038ade5 target/rd: Allow WriteCacheEnabled=
=3D1 operation with rd_mcp backends)
Merging target-merge/for-next-merge (d987569 Linux 3.6-rc2)
Merging ibft/linux-next (935a9fe ibft: Fix finding IBFT ACPI table on UEFI)
Merging isci/all (6734092 isci: add a couple __iomem annotations)
Merging slave-dma/next (983d7be drivers/dma/amba-pl08x.c: fix error return =
code)
Merging dmaengine/next (a2bd114 netdma: adding alignment check for NETDMA o=
ps)
Merging net-next/master (f63c45e packet: fix broken build.)
Merging wireless-next/master (a4881cc Merge branch 'for-john' of git://git.=
kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next)
Merging bluetooth/master (82e7054 Bluetooth: Add USB_VENDOR_AND_INTERFACE_I=
NFO() for Broadcom/Foxconn)
Merging mtd/master (2361f73 Merge tag 'v3.6-rc2' of git://git.kernel.org/pu=
b/scm/linux/kernel/git/torvalds/linux)
Merging l2-mtd/master (61a5d43 mtd: nand: davinci: add OF support for davin=
ci nand controller)
Merging crypto/master (88adbe4 crypto: talitos - consolidate common cra_* a=
ssignments)
Merging drm/drm-next (3228503 gma500: remove an unreachable return statemen=
t)
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/intel_modes.c
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/i915_gem.c
$ git reset --hard HEAD^
Merging refs/next/20120823/drm
Merging sound/for-next (b8dfc46 ALSA: hda - add runtime PM support)
Merging sound-asoc/for-next (ac74821 Merge branch 'for-3.7' into asoc-next)
Merging quilt/rr (ba05c76 virtio-blk: Add REQ_FLUSH and REQ_FUA support to =
bio path)
CONFLICT (content): Merge conflict in arch/xtensa/Kconfig
CONFLICT (content): Merge conflict in arch/s390/Kconfig
CONFLICT (content): Merge conflict in arch/mips/kernel/module.c
CONFLICT (content): Merge conflict in arch/alpha/Kconfig
Merging input/next (31b95bf Input: samsung-keypad - use of_get_child_count(=
) helper)
Merging input-mt/for-next (0d7614f Linux 3.6-rc1)
Merging cgroup/for-next (4b2ebf0 Merge branch 'for-3.6' into for-next)
Merging block/for-next (79df9b4 Merge branch 'for-jens' of git://git.drbd.o=
rg/linux-drbd into for-linus)
Merging quilt/device-mapper (057d040 Overflow checking in dm-verity was not=
 sufficient. It would check overflow if sector_t was smaller than long long=
 but not if sector_t and long long have the same size. This patch implement=
s proper overflow checking.)
Merging embedded/master (4744b43 embedded: fix vc_translate operator preced=
ence)
Merging firmware/master (6e03a20 firmware: speed up request_firmware(), v3)
Merging pcmcia/master (80af9e6 pcmcia at91_cf: fix raw gpio number usage)
Merging mmc/mmc-next (72d0f11 mmc: bfin_sdh: Reset SD controller when resum=
e from power saving mode.)
Merging kgdb/kgdb-next (15d7ea0 kgdboc: Accept either kbd or kdb to activat=
e the vga + keyboard kdb shell)
Merging slab/for-next (77be4b1 mm/slab: restructure kmem_cache_create() deb=
ug checks)
Merging uclinux/for-next (5e442a4 Revert "proc: fix races against execve() =
of /proc/PID/fd**")
Merging md/for-next (eef0978 md: avoid taking the mutex on some ioctls.)
Merging mfd/for-next (092369e mfd: lpc_ich: Fix a 3.5 kernel regression for=
 iTCO_wdt driver)
Merging battery/master (2815b78 power_supply: Add new power supply properti=
es CHARGE_CURRENT/VOLTAGE_MAX)
Merging fbdev/fbdev-next (75435c7 video: exynos_dp: move setting analog par=
ameter and interrupt to after sw reset)
Merging viafb/viafb-next (838ac78 viafb: avoid refresh and mode lookup in s=
et_par)
Merging omap_dss2/for-next (974a658 Merge "Apply LCD manager related parame=
ters" from Archit)
Merging regulator/for-next (5231ac8 Merge branches 'regulator-core' and 're=
gulator-drivers' into regulator-next)
Merging security/next (51b743f Merge tag 'v3.6-rc2' into next)
Merging selinux/master (c2d7b24 Merge tag 'v3.4' into 20120409)
Merging lblnet/master (7e27d6e Linux 2.6.35-rc3)
Merging watchdog/master (c95aa0a watchdog: da9052: Remove duplicate inclusi=
on of delay.h)
Merging dwmw2-iommu/master (c3b92c8 Linux 3.1)
Merging iommu/next (6f286cc Merge branches 'iommu/fixes' and 'arm/tegra' in=
to next)
Merging vfio/next (d987569 Linux 3.6-rc2)
Merging osd/linux-next (b8017d2 exofs: check for allocation failure in uri_=
store())
Merging jc_docs/docs-next (5c050fb docs: update the development process doc=
ument)
Merging trivial/for-next (ef706fb irqdesc: delete now orphaned references t=
o timer_rand_state)
Merging audit/for-next (dcd6c92 Linux 3.3-rc1)
Merging pm/linux-next (4609919 Merge branch 'pm-sleep-next' into linux-next)
Merging apm/for-next (f283d22 APM: fix deadlock in APM_IOC_SUSPEND ioctl)
Merging fsnotify/for-next (1aec9c0 inotify: automatically restart syscalls)
CONFLICT (content): Merge conflict in kernel/audit_tree.c
Merging edac/linux_next (a92cdec Merge branch 'devel' into next)
Merging edac-amd/for-next (305f1c3 Merge branch '3.3-pci_device_id' into ed=
ac-for-next)
CONFLICT (content): Merge conflict in drivers/edac/amd64_edac.c
CONFLICT (content): Merge conflict in Documentation/edac.txt
Merging devicetree/devicetree/next (efd68e7 devicetree: add helper inline f=
or retrieving a node's full name)
Merging dt-rh/for-next (5d61b16 of: Allow busses with #size-cells=3D0)
Merging spi/spi/next (d8e328b spi: Add "spi:" prefix to modalias attribute =
of spi devices)
Merging spi-mb/spi-next (93cd5a7 Merge branch 'spi-drivers' into spi-next)
Merging tip/auto-latest (592b4c6 Merge branch 'linus')
CONFLICT (content): Merge conflict in arch/Kconfig
Merging rcu/rcu/next (d1d61c1 Merge branches 'bigrt.2012.07.31a', 'doctortu=
re.2012.08.03a', 'fixes.2012.08.03a', 'hotplug.2012.08.03a' and 'idle.2012.=
07.31a' into dev.3.7.2012.08.03a)
CONFLICT (content): Merge conflict in kernel/rcutree_plugin.h
CONFLICT (content): Merge conflict in kernel/rcutree.h
CONFLICT (content): Merge conflict in include/linux/sched.h
CONFLICT (content): Merge conflict in arch/x86/Kconfig
CONFLICT (content): Merge conflict in arch/Kconfig
Merging cputime/cputime (c3e0ef9 [S390] fix cputime overflow in uptime_proc=
_show)
Merging uprobes/for-next (0326f5a uprobes/core: Handle breakpoint and singl=
estep exceptions)
Merging kmemleak/kmemleak (4878677 kmemleak: do not leak object after tree =
insertion error)
Merging kvm/linux-next (4d8b81a KVM: introduce readonly memslot)
CONFLICT (content): Merge conflict in arch/s390/include/asm/processor.h
$ git reset --hard HEAD^
Merging refs/next/20120822/kvm
CONFLICT (content): Merge conflict in arch/s390/include/asm/processor.h
[master f87bec5] Merge commit 'refs/next/20120822/kvm'
Merging kvm-ppc/kvm-ppc-next (e9908a4 KVM: PPC: BookE: Support FPU on non-h=
v systems)
Merging oprofile/for-next (c16fa4f Linux 3.3)
Merging xen/upstream/xen (af3a3ab Merge git://git.kernel.org/pub/scm/linux/=
kernel/git/steve/gfs2-3.0-fixes)
Merging xen-two/linux-next (7b124e0 Merge branch 'stable/for-linus-3.7' int=
o linux-next)
Merging xen-pvhvm/linux-next (b056b6a xen: suspend: remove xen_hvm_suspend)
Merging percpu/for-next (61011677 Merge tag 'dlm-3.5' of git://git.kernel.o=
rg/pub/scm/linux/kernel/git/teigland/linux-dlm)
Merging workqueues/for-next (136b572 workqueue: deprecate __cancel_delayed_=
work())
CONFLICT (modify/delete): drivers/hid/hid-picolcd.c deleted in HEAD and mod=
ified in workqueues/for-next. Version workqueues/for-next of drivers/hid/hi=
d-picolcd.c left in tree.
$ git rm -f drivers/hid/hid-picolcd.c
Merging drivers-x86/linux-next (973713e classmate-laptop: always call input=
_sync() after input_report_switch())
Merging hwpoison/hwpoison (46e387b Merge branch 'hwpoison-hugepages' into h=
wpoison)
Merging sysctl/master (4e474a0 sysctl: protect poll() in entries that may g=
o away)
Merging regmap/for-next (c7700f9 Merge tag 'topic/domain' into regmap-next)
Merging hsi/for-next (43139a6 HSI: hsi_char: Update ioctl-number.txt)
Merging leds/for-next (84a74b1 leds-lp5523: minor code style fixes)
Merging driver-core/driver-core-next (0592969 hv: fail the probing immediat=
ely when we are not in hyperv platform)
Merging tty/tty-next (5d4121c TTY: check if tty->port is assigned)
Merging usb/usb-next (7fda953 usb: convert USB_QUIRK_RESET_MORPHS to USB_QU=
IRK_RESET)
Merging staging/staging-next (d602a06 staging: comedi: contec_pci: remove m=
anual legacy attach)
Merging char-misc/char-misc-next (877cdf3 drivers/misc/ti-st: check chip_aw=
ake NULL check)
CONFLICT (content): Merge conflict in drivers/misc/mei/interrupt.c
Merging tmem/linux-next (15773b6 Merge branch 'stable/for-linus-3.6' into l=
inux-next)
Merging writeback/writeback-for-next (331cbde writeback: Fix some comment e=
rrors)
Merging arm-dt/devicetree/arm-next (ede338f dt: add documentation of ARM dt=
 boot interface)
Merging hwspinlock/linux-next (8b37fcf hwspinlock: add MAINTAINERS entries)
Merging pinctrl/for-next (5ee9093 Merge branch 'devel' into for-next)
Merging vhost/linux-next (e0953c8 tun: experimental zero copy tx support)
CONFLICT (content): Merge conflict in drivers/net/tun.c
Merging memblock/memblock-kill-early_node_map (7bd0b0f memblock: Reimplemen=
t memblock allocation using reverse free area iterator)
Merging remoteproc/for-next (6bb697b MAINTAINERS: add remoteproc's git)
Merging irqdomain/irqdomain/next (f5a1ad0 irqdomain: Improve diagnostics wh=
en a domain mapping fails)
Merging gpio/gpio/next (ddf343f Merge branch 'for-linus' of git://git.kerne=
l.org/pub/scm/linux/kernel/git/s390/linux)
Merging gpio-lw/for-next (de91a63 Merge branch 'devel' into for-next)
Merging arm-soc/for-next (6486a93 Merge branch 'next/drivers' into for-next)
CONFLICT (content): Merge conflict in drivers/mtd/nand/Kconfig
Merging ep93xx/ep93xx-for-next (fbad878 Merge branch 'ep93xx-cleanup' into =
ep93xx-for-next)
Merging renesas/next (6c0274c ARM: shmobile: sh73a0: fixup RELOC_BASE of in=
tca_irq_pins_desc)
Merging samsung/for-next (c1f9bee Merge branch 'next/board-samsung' into fo=
r-next)
Merging tegra/for-next (f109140 Merge branch 'for-3.7/defconfig' into for-n=
ext)
Merging kvmtool/master (27b0421 kvm tools: Respect guest tcp window size)
Merging dma-mapping/dma-mapping-next (a02d48a Merge branch 'next-coherent-d=
ma-ops' into HEAD)
Merging pwm/for-next (c5d0b8a pwm: add devm_pwm_get() and devm_pwm_put())
Merging dma-buf/for-next (42a579a Merge branches 'timers-urgent-for-linus' =
and 'perf-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/gi=
t/tip/tip)
Merging userns/for-next (898132a ipv6: move dereference after check in fl_f=
ree())
Merging ktest/for-next (648a182 ktest: Allow a test to override REBOOT_ON_S=
UCCESS)
Merging signal/from-sfr (2e117f2 Revert "arm: pull all work_pending logics =
into C function")
CONFLICT (content): Merge conflict in arch/x86/kernel/signal.c
CONFLICT (content): Merge conflict in arch/powerpc/kernel/entry_64.S
CONFLICT (content): Merge conflict in arch/arm/include/asm/thread_info.h
CONFLICT (content): Merge conflict in arch/alpha/kernel/process.c
Merging clk/clk-next (137f8a7 clk: fix compile for OF && !COMMON_CLK)
Merging random/dev (d2e7c96 random: mix in architectural randomness in extr=
act_buf())
Merging scsi-post-merge/merge-base:master ()
$ git checkout akpm
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
Applying: mn10300: only add -mmem-funcs to KBUILD_CFLAGS if gcc supports it
Applying: drivers/dma/dmaengine.c: lower the priority of 'failed to get' dm=
a channel message
Applying: pcmcia: move unbind/rebind into dev_pm_ops.complete
Applying: timeconst.pl: remove deprecated defined(@array)
Applying: time: don't inline EXPORT_SYMBOL functions
Applying: thermal: add generic cpufreq cooling implementation
Applying: hwmon: exynos4: move thermal sensor driver to driver/thermal dire=
ctory
Applying: thermal: exynos5: add exynos5 thermal sensor driver support
Applying: thermal: exynos: register the tmu sensor with the kernel thermal =
layer
Applying: ARM: exynos: add thermal sensor driver platform data support
Applying: drivers/scsi/atp870u.c: fix bad use of udelay
Applying: vfs: increment iversion when a file is truncated
Applying: fs: push rcu_barrier() from deactivate_locked_super() to filesyst=
ems
Applying: mm/slab: remove duplicate check
Applying: mm: remove __GFP_NO_KSWAPD
Applying: mm: remove __GFP_NO_KSWAPD fixes
Applying: remove-__gfp_no_kswapd-fixes-fix
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
Applying: frv: kill used but uninitialized variable
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
Applying: rbtree: optimize case selection logic in __rb_erase_color()
Applying: rbtree: low level optimizations in __rb_erase_color()
Applying: rbtree: coding style adjustments
Applying: rbtree: rb_erase updates and comments
Applying: rbtree: optimize fetching of sibling node
Applying: drivers/firmware/dmi_scan.c: check dmi version when get system uu=
id
Applying: drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid=
-fix
Applying: drivers/firmware/dmi_scan.c: fetch dmi version from SMBIOS if it =
exists
Applying: drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-ex=
ists-checkpatch-fixes
Applying: fat (exportfs): move NFS support code
Applying: fat (exportfs): fix dentry reconnection
Applying: ipc/sem.c: alternatives to preempt_disable()
Merging akpm/master (2be3ef9 ipc/sem.c: alternatives to preempt_disable())
[master f91b6b6] Revert "ALSA: hda - add runtime PM support"

--Signature=_Fri__24_Aug_2012_17_28_20_+1000_v4g5KjHVYyw3_uAj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQNy0UAAoJEECxmPOUX5FEwoMP/0OqIp3hwp23g7f/yc2esAYv
HgANfkLsNQfTD3Qvtaa2tu6qu26Cnej+yvVVkH7mU73e+nR43rUj5LDf79d4VIrM
zp0jfTIrDold1jYsxo/OKV7HzM+5y+YNX7fJypOProdEQp7Y5IpCcPmRLRBBzFeg
vuI8RwSpXOi5AWxhphJB98DCsHvwrc6O0O5NajNINR/p9nOX1LaKssrmxBJCJ/NK
BVQgYEmqaUUr5K9hvoEj8kComLypLHYPFpWRcI+iQ1Hd3vFCYkRoFZEXCB1tGuzX
165sYoacr89pistT+tiVuZindyoV8VXIhJ2KhiElPgusA45spO997/ecCxVzVL9y
GV3r8N6WAPXCIaKsdq7Ss2HzRH0g/TNhFAYeORXF8/IbzYNvf3yOKhUpMIKItnR8
JLGyDpzaJoGq+E3TzSHwev5E/4aqRMWGOAe3tMBBoF4Y4ZDZgyIrBpBG3DGFLEyF
0uQr+zmlWh78ZiZ13QxT85sK40mEdONQrFVhf6pf8ljlgpQXM7yFLHvBz/MQKm1Z
bh6wCPd7Wz131lbZy076PsH1cQbrrLrEA1hMoGghMN+9tDJkqgZ5QVXSr+Ikj/fR
EcQGYjrBxeOhpZG7C/wz8wW42+xfAALR4DDpabVKcPe9eSQ3ibJfUKfiFs612Jp/
nIG0HK86eDIKV7g3q+2n
=Z04Z
-----END PGP SIGNATURE-----

--Signature=_Fri__24_Aug_2012_17_28_20_+1000_v4g5KjHVYyw3_uAj--

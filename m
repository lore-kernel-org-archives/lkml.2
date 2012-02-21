Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357Ab2BUE6v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 23:58:51 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:48735 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab2BUE6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 23:58:44 -0500
Date: Tue, 21 Feb 2012 15:58:22 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Feb 21
Message-Id: <20120221155822.3f2820f6e30427e83954ee2c@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__21_Feb_2012_15_58_22_+1100_PcFpOMK/pMvNeJ5N"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__21_Feb_2012_15_58_22_+1100_PcFpOMK/pMvNeJ5N
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20120220:

The net-next tree lost its build failure.

The mfd tree gained a build failure so I used the version from
next-20120220.

The akpm tree still has a couple of build failures for which I reverted a
patch and applied a patch.

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

We are up to 182 trees (counting Linus' and 26 trees of patches pending
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
Merging origin/master (b01543d Linux 3.3-rc4)
Merging fixes/master (2b79574 tty/powerpc: early udbg consoles can't be mod=
ules)
Merging kbuild-current/rc-fixes (6c63522 builddeb: Don't create files in /t=
mp with predictable names)
Merging arm-current/fixes (fee6a3c ARM: 7327/1: need to include asm/system.=
h in asm/processor.h)
Merging m68k-current/for-linus (2a35350 m68k: Fix assembler constraint to p=
revent overeager gcc optimisation)
Merging powerpc-merge/merge (9a45a94 powerpc/perf: power_pmu_start restores=
 incorrect values, breaking frequency events)
Merging 52xx-and-virtex-current/powerpc/merge (c49f878 dtc/powerpc: remove =
obsolete .gitignore entries)
Merging sparc/master (e51e07e sparc32: forced setting of mode of sun4m per-=
cpu timers)
Merging scsi-rc-fixes/master (fea6d60 [SCSI] scsi_pm: Fix bug in the SCSI p=
ower management handler)
Merging net/master (64f0a83 b44: remove __exit from b44_pci_exit())
Merging sound-current/for-linus (27c3afe ALSA: intel8x0: Fix default inaudi=
ble sound on Gateway M520)
Merging pci-current/for-linus (3682a39 PCI: Fix pci cardbus removal)
Merging wireless/master (2504a64 ath9k: stop on rates with idx -1 in ath9k =
rate control's .tx_status)
Merging driver-core.current/driver-core-linus (29bb5d4 driver-core: cpu: fi=
x kobject warning when hotplugging a cpu)
Merging tty.current/tty-linus (b01543d Linux 3.3-rc4)
Merging usb.current/usb-linus (b9e44fe USB: option: cleanup zte 3g-dongle's=
 pid in option.c)
Merging staging.current/staging-linus (b01543d Linux 3.3-rc4)
Merging char-misc.current/char-misc-linus (b5266ea mmc: cb710 core: Add mis=
sing spin_lock_init for irq_lock of struct cb710_chip)
Merging cpufreq-current/fixes (5983fe2 Merge git://git.kernel.org/pub/scm/l=
inux/kernel/git/davem/net)
Merging input-current/for-linus (82b982c Input: i8042 - add Lenovo Ideapad =
U455 to 'reset' blacklist)
Merging md-current/for-linus (db91ff5 md: two small fixes to handling inter=
rupt resync.)
Merging audit-current/for-linus (c158a35 audit: no leading space in audit_l=
og_d_path prefix)
Merging crypto-current/master (f2ea0f5 crypto: sha512 - use standard ror64(=
))
Merging ide/master (0ab3d8b cy82c693: fix PCI device selection)
Merging dwmw2/master (244dc4e Merge git://git.infradead.org/users/dwmw2/ran=
dom-2.6)
Merging devicetree-current/devicetree/merge (2261cc6 dt: add empty of_find_=
compatible_node function)
Merging spi-current/spi/merge (c88db23 spi-topcliff-pch: rename pch_spi_pci=
dev to pch_spi_pcidev_driver)
Merging gpio-current/gpio/merge (7e3a70f gpio: Add missing spin_lock_init i=
n gpio-ml-ioh driver)
Merging arm/for-next (41bc99e Merge branch 'devel-stable' into for-next)
Merging arm-perf/for-next/perf (cdd2a5b Merge branches 'perf/updates' and '=
perf/fixes' into for-next/perf)
Merging davinci/davinci-next (fe0d422 Linux 3.0-rc6)
Merging samsung/next-samsung (9edb240 ARM: H1940/RX1950: Change default LED=
 triggers)
Merging s5p/for-next (e8a4c2f Merge branch 'v3.4-for-rafael' into for-next)
Merging tegra/for-next (9048201 Merge branch 'for-3.4/soc-drivers' into for=
-next)
Merging xilinx/arm-next (b85a3ef ARM: Xilinx: Adding Xilinx board support)
Merging blackfin/for-linus (e651fe5 Blackfin: wire up new process_vm syscal=
ls)
Merging c6x/for-linux-next (62e37ca Kbuild: Use dtc's -d (dependency) optio=
n)
Merging cris/for-next (ea78f5b CRIS: Update documentation)
Merging quilt/hexagon (110b372 Remove unneeded include of version.h from ar=
ch/hexagon/include/asm/spinlock_types.h)
CONFLICT (content): Merge conflict in arch/hexagon/Kconfig
Merging ia64/next (0f261ed [IA64] disable interrupts when exiting from ia64=
_mca_cmc_int_handler())
Merging m68k/for-next (2a35350 m68k: Fix assembler constraint to prevent ov=
ereager gcc optimisation)
Merging m68knommu/for-next (9720227 m68knommu: clean up linker script)
Merging microblaze/next (8597559 Merge tag 'gpio-for-linus' of git://git.se=
cretlab.ca/git/linux-2.6)
Merging mips/mips-for-linux-next (2fea377 Merge branch 'fixes-for-linus' in=
to mips-for-linux-next)
Merging openrisc/for-upstream (754d5c2 openrisc: Set shortest clock event t=
o 100 ticks)
Merging parisc/for-next (fc99a91 futex: Use same lock set as lws calls)
Merging powerpc/next (ef88e39 powerpc: fix compile error with 85xx/p1010rdb=
.c)
Merging 4xx/next (ef88e39 powerpc: fix compile error with 85xx/p1010rdb.c)
Merging 52xx-and-virtex/powerpc/next (c1395f4 dtc/powerpc: remove obsolete =
.gitignore entries)
Merging galak/next (ef88e39 powerpc: fix compile error with 85xx/p1010rdb.c)
Merging s390/features (486f0b4 [S390] irq: external interrupt code passing)
Merging sparc-next/master (b409650 arch/sparc/kernel/unaligned_64.c: includ=
ed linux/bitops.h twice)
Merging tile/master (0c90547 arch/tile: use new generic {enable,disable}_pe=
rcpu_irq() routines)
Merging unicore32/unicore32 (0994695 Merge branch 'akpm' (aka "Andrew's pat=
ch-bomb, take two"))
Merging ceph/for-next (83eb26a ceph: ensure prealloc_blob is in place when =
removing xattr)
Merging cifs/master (4903062 i387: move AMD K7/K8 fpu fxsave/fxrstor workar=
ound from save to restore)
Merging configfs/linux-next (b930c26 Merge branch 'for-linus' of git://git.=
kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (6cfd4b4 ecryptfs: remove the second argument of k[un=
]map_atomic())
CONFLICT (content): Merge conflict in fs/ecryptfs/ecryptfs_kernel.h
Merging ext3/for_next (62aa2b5 Linux 3.3-rc2)
Merging ext4/dev (d2403ca ext4: using PTR_ERR() on the wrong variable in ex=
t4_ext_migrate())
Merging fuse/for-next (03c9693 cuse: implement memory mapping)
Merging gfs2/master (2b86c11 GFS2: Ensure rindex is uptodate for fallocate)
Merging logfs/master (b01543d Linux 3.3-rc4)
Merging nfs/linux-next (36925a2 Merge branch 'nfs-for-next' into linux-next)
Merging nfsd/nfsd-next (03cfb42 NFSD: Clean up the test_stateid function)
Merging ocfs2/linux-next (9392557 ocfs2: avoid unaligned access to dqc_bitm=
ap)
Merging omfs/for-next (976d167 Linux 3.1-rc9)
Merging squashfs/master (3d4a1c8 Squashfs: fix i_blocks calculation with ex=
tended regular files)
Merging v9fs/for-next (f766619 fs/9p: iattr_valid flags are kernel internal=
 flags map them to 9p values.)
Merging ubifs/linux-next (72d3ef6 UBIFS: do not use inc_link when i_nlink i=
s zero)
Merging xfs/for-next (f65020a XFS: xfs_trans_add_item() - don't assign in A=
SSERT() when compare is intended)
Merging vfs/for-next (9a3b4c1 qnx4fs: small cleanup)
Merging pci/linux-next (5b415f1 PCI / PM: Disable wakeup during shutdown fo=
r devices not enabled to wake up)
Merging hid/for-next (9d23d8a Merge branch 'upstream' into for-next)
Merging quilt/i2c (c3632e0 i2c-i801: Use usleep_range to wait for command c=
ompletion)
Merging bjdooks-i2c/next-i2c (fc84fe1 Merge branch 'for_3.3/i2c/misc' of gi=
t://git.kernel.org/pub/scm/linux/kernel/git/khilman/linux-omap-pm into for-=
33/i2c/omap)
CONFLICT (content): Merge conflict in drivers/i2c/busses/i2c-omap.c
Merging quilt/jdelvare-hwmon (127e71e hwmon: (mc13xxx-adc) Add support for =
the MC13892 PMIC)
Merging hwmon-staging/hwmon-next (de69184 hwmon: (hwmon-vid) Fix checkpatch=
 issues)
Merging quilt/kernel-doc (7e7b32a Update quilt tree location for Documentat=
ion/ patches.)
Merging docs/docs-move (5c24d8b Merge branch 'docs/docbook/drm' of git://gi=
thub.com/mfwitten/linux into docs-move)
Merging v4l-dvb/master (d345066 Merge /home/v4l/v4l/patchwork)
Merging kbuild/for-next (75cb742 Merge branch 'kbuild/rc-fixes' into kbuild=
/for-next)
Merging kconfig/for-next (eae1c36 Merge branch 'kconfig/for-linus-2' into k=
config/for-next)
Merging libata/NEXT (96c4d29 pata_legacy: correctly mask recovery field for=
 HT6560B)
Merging infiniband/for-next (715252d IB/srpt: Don't return freed pointer fr=
om srpt_alloc_ioctx_ring())
Merging acpi/next (eb7004e Merge branches 'atomicio-apei', 'hotplug', 'sony=
-nvs-nosave' and 'thermal-netlink' into release)
Merging ieee1394/for-next (6e01490 Merge branch 'fixes' into for-next)
Merging ubi/linux-next (ecaabdb UBI: fix error handling in ubi_scan())
Merging dlm/next (60f98d1 dlm: add recovery callbacks)
Merging scsi/master (50824d6 [SCSI] libsas: async ata-eh)
Merging target-updates/for-next (24d2f08 tcm_fc: Remove cmd->cdb data membe=
r)
Merging target-merge/for-next-merge (d65b4e9 Linux 3.3-rc3)
Merging ibft/linux-next (935a9fe ibft: Fix finding IBFT ACPI table on UEFI)
Merging isci/all (57872c2 Merge branches 'devel' and 'fixes' into all)
CONFLICT (content): Merge conflict in include/scsi/sas_ata.h
CONFLICT (content): Merge conflict in include/scsi/libsas.h
CONFLICT (content): Merge conflict in drivers/scsi/libsas/sas_scsi_host.c
CONFLICT (content): Merge conflict in drivers/scsi/libsas/sas_port.c
CONFLICT (content): Merge conflict in drivers/scsi/libsas/sas_internal.h
CONFLICT (content): Merge conflict in drivers/scsi/libsas/sas_init.c
CONFLICT (content): Merge conflict in drivers/scsi/libsas/sas_expander.c
CONFLICT (content): Merge conflict in drivers/scsi/libsas/sas_event.c
CONFLICT (content): Merge conflict in drivers/scsi/libsas/sas_discover.c
CONFLICT (content): Merge conflict in drivers/scsi/libsas/sas_ata.c
CONFLICT (content): Merge conflict in drivers/scsi/isci/registers.h
Merging slave-dma/next (b63fd6c i.MX SDMA: Fix burstsize settings)
Merging dmaengine/next (d07a74a dmaengine: fix missing 'cnt' in ?: in dmate=
st)
Merging net-next/master (2b68c18 enic: Add support for fw init command on s=
riov vf's)
CONFLICT (content): Merge conflict in net/mac80211/sta_info.h
CONFLICT (content): Merge conflict in net/mac80211/debugfs_sta.c
Merging wireless-next/master (ca994a3 Merge branch 'master' of git://git.ke=
rnel.org/pub/scm/linux/kernel/git/linville/wireless)
CONFLICT (content): Merge conflict in net/mac80211/sta_info.h
CONFLICT (content): Merge conflict in net/mac80211/debugfs_sta.c
Merging bluetooth/master (c5993de Bluetooth: Correct packet len calculation)
Merging mtd/master (3c3e51d Merge ../linux-2.6 to bring in 3.3-rc fixes alr=
eady merged)
Merging l2-mtd/master (783dbd6 sfc: mtd: Use MTD_FAIL_ADDR_UNKNOWN instead =
of 0xffffffff)
CONFLICT (content): Merge conflict in drivers/mtd/chips/cfi_cmdset_0002.c
Merging crypto/master (d97055e Merge git://git.kernel.org/pub/scm/linux/ker=
nel/git/herbert/crypto-2.6)
CONFLICT (content): Merge conflict in arch/arm/mach-tegra/fuse.c
Merging sound/for-next (b7ce846 Merge branch 'topic/hda' into for-next)
Merging sound-asoc/for-next (d3dc516 Merge branch 'for-3.4' into asoc-next)
CONFLICT (content): Merge conflict in sound/soc/codecs/wm5100.c
Merging cpufreq/next (6c523c6 [CPUFREQ] EXYNOS: Removed useless headers and=
 codes)
Merging quilt/rr (42d5bdd virtio: update documentation to v0.9.4 of spec)
Merging input/next (023cea0 Input: tegra-kbc - allow skipping setting up so=
me of GPIO pins)
Merging input-mt/for-next (7491f3d bcm5974: Add pointer and buttonpad prope=
rties)
Merging block/for-next (b3021da Merge branch 'for-3.3/core' into for-next)
Merging quilt/device-mapper (1e5f0da Commit unwritten data every second to =
prevent too much building up. In future we might make the commit interval t=
unable.)
Merging embedded/master (4744b43 embedded: fix vc_translate operator preced=
ence)
Merging firmware/master (6e03a20 firmware: speed up request_firmware(), v3)
Merging battery/master (913272b Merge git://git.infradead.org/users/cbou/ba=
ttery-urgent)
Merging mmc/mmc-next (5ef8edf mmc: dw_mmc: Regression fix for non-IDMAC DMA)
Merging kgdb/kgdb-next (880ba69 lib: rename pack_hex_byte() to hex_byte_pac=
k())
Merging slab/for-next (96438bc Merge branch 'slub/cleanups' into for-next)
Merging uclinux/for-next (5e442a4 Revert "proc: fix races against execve() =
of /proc/PID/fd**")
Merging md/for-next (fae8cc5 md/raid10: fix handling of error on last worki=
ng device in array.)
Merging mfd/for-next (c04eaf3 mfd: Add regulator support for twl6040 VIO, V=
2V1 supplies)
$ git reset --hard HEAD^
Merging refs/next/20120220/mfd
Merging drm/drm-next (019d96c drm: add some caps for userspace to discover =
more info for dumb KMS driver (v2))
Merging fbdev/fbdev-next (94f61a7 i740fb: fix compile error when CONFIG_MTR=
R is not selected)
Merging viafb/viafb-next (c572c8b viafb: NULL dereference on allocation fai=
lure in query_edid())
Merging omap_dss2/for-next (9a90168 OMAPDSS: HDMI: Disable DDC internal pul=
l up)
Merging regulator/for-next (2d0306c Merge branch 'regulator-core' into regu=
lator-next)
Merging security/next (b0d5de4 IMA: fix audit res field to indicate 1 for s=
uccess and 0 for failure)
Merging selinux/master (a9ab18a selinux: include flow.h where used rather t=
han get it indirectly)
Merging lblnet/master (7e27d6e Linux 2.6.35-rc3)
Merging watchdog/linux-next (1776b7d watchdog: fix error in probe() of s3c2=
410_wdt (reset at booting))
Merging dwmw2-iommu/master (c3b92c8 Linux 3.1)
Merging iommu/next (48d2116 Merge branches 'iommu/fixes' and 'arm/tegra' in=
to next)
Merging osd/linux-next (0aa436b exofs: Cap on the memcpy() size)
Merging jc_docs/docs-next (5c050fb docs: update the development process doc=
ument)
Merging trivial/for-next (2105b9a Only include linux/sched.h once in arch/a=
rm/mach-bcmring/dma.c)
Merging audit/for-next (dcd6c92 Linux 3.3-rc1)
Merging pm/linux-next (98f7e95 PM / Hibernate: Enable usermodehelpers in hi=
bernate() error path)
Merging apm/for-next (b4a133d Merge branch 'for-linus' of git://git.kernel.=
org/pub/scm/linux/kernel/git/jikos/apm)
Merging fsnotify/for-next (ef9bf3b fanotify: only destroy a mark if both it=
s mask and its ignored_mask are cleared)
Merging edac/linux_next (4d096ca MAINTAINERS: add an entry for Edac Sandy B=
ridge driver)
Merging edac-amd/for-next (5a42394 Merge remote-tracking branch 'kepek/3.3-=
edac-dbam' into edac-for-next)
Merging devicetree/devicetree/next (301b605 of: Only compile OF_DYNAMIC on =
PowerPC pseries and iseries)
Merging spi/spi/next (14af60b spi/pl022: Add high priority message pump sup=
port)
Merging gpio/gpio/next (ff64abe of_gpio: add support of of_gpio_named_count=
 to be able to count named gpio)
CONFLICT (content): Merge conflict in include/linux/mfd/tps65910.h
Merging tip/auto-latest (630e0fd Merge branch 'x86/urgent' into auto-latest)
Merging rcu/rcu/next (710fbb1 cpuidle: Inform RCU of read-side critical sec=
tions)
Merging cputime/cputime (c3e0ef9 [S390] fix cputime overflow in uptime_proc=
_show)
Merging uprobes/for-next (4e44798 perf: perf interface for uprobes)
CONFLICT (content): Merge conflict in tools/perf/util/probe-event.c
CONFLICT (content): Merge conflict in tools/perf/builtin-probe.c
Merging cgroup/for-next (761b3ef cgroup: remove cgroup_subsys argument from=
 callbacks)
Merging kmemleak/kmemleak (d65b4e9 Linux 3.3-rc3)
Merging kvm/linux-next (4b99f72 KVM: mmu_notifier: Flush TLBs before releas=
ing mmu_lock)
Merging oprofile/for-next (b9e7f8e Merge branches 'oprofile/urgent' and 'op=
rofile/core' into oprofile/master)
Merging xen/upstream/xen (59e9a6b Merge branch 'upstream/ticketlock-cleanup=
' into upstream/xen)
CONFLICT (content): Merge conflict in arch/x86/include/asm/cmpxchg.h
Merging xen-two/linux-next (53eaea0 Merge branch 'stable/for-linus-fixes-3.=
3' into linux-next)
Merging xen-pvhvm/linux-next (b056b6a xen: suspend: remove xen_hvm_suspend)
Merging percpu/for-next (26dd8e0 percpu: use bitmap_clear)
Merging workqueues/for-next (6b3da11 Merge branch 'for-3.3' of git://git.ke=
rnel.org/pub/scm/linux/kernel/git/tj/percpu)
Merging hwpoison/hwpoison (46e387b Merge branch 'hwpoison-hugepages' into h=
wpoison)
Merging sysctl/master (4e75732 sysctl: Don't call sysctl_follow_link unless=
 we are a link.)
CONFLICT (content): Merge conflict in fs/proc/proc_sysctl.c
Merging regmap/for-next (e140036 Merge branch 'regmap-introspection' into r=
egmap-next)
Merging hsi/for-next (43139a6 HSI: hsi_char: Update ioctl-number.txt)
Merging driver-core/driver-core-next (8bf1193 intel_idle: Revert change of =
auto_demotion_disable_flags for Nehalem)
CONFLICT (content): Merge conflict in drivers/base/cpu.c
Merging tty/tty-next (6816383 tty: sparc: rename drivers/tty/serial/suncore=
.h -> include/linux/sunserialcore.h)
CONFLICT (modify/delete): drivers/tty/serial/m32r_sio.c deleted in HEAD and=
 modified in tty/tty-next. Version tty/tty-next of drivers/tty/serial/m32r_=
sio.c left in tree.
Merging usb/usb-next (5407a3c usb: host: ehci: allow ehci_* symbols to be u=
nused)
Merging tmem/linux-next (b05b561 Merge branch 'devel/frontswap.v13' into li=
nux-next)
Applying: mm: frontswap: update for security_vm_enough_memory API change
Merging staging/staging-next (3e80914 Staging: ramster: mark BROKEN)
Merging char-misc/char-misc-next (838d51b char: Fix typo in tlclk.c)
Merging arm-soc/for-next (8a6b82f Merge branch 'next/fixes-non-critical' in=
to for-next)
Merging writeback/writeback-for-next (977b7e3 writeback: fix dereferencing =
NULL bdi->dev on trace_writeback_queue)
Merging arm-dt/devicetree/arm-next (ede338f dt: add documentation of ARM dt=
 boot interface)
Merging hwspinlock/linux-next (8b37fcf hwspinlock: add MAINTAINERS entries)
Merging pinctrl/for-next (5ecb3ad Merge branch 'pinctrl-tegra-for-next-diet=
' into for-next)
Merging moduleh/for-sfr (6aec187 drivers/media: video/a5k6aa is a module an=
d so needs module.h)
Merging vhost/linux-next (1e05b62 sh: use the the PCI channels's io_map_bas=
e)
Merging kmap_atomic/kmap_atomic (019e9ad feature-removal-schedule.txt: sche=
dule the deprecated form of kmap_atomic() for removal)
CONFLICT (content): Merge conflict in drivers/staging/zram/zram_drv.c
CONFLICT (content): Merge conflict in drivers/staging/zcache/zcache-main.c
CONFLICT (content): Merge conflict in drivers/scsi/storvsc_drv.c
CONFLICT (content): Merge conflict in drivers/net/ethernet/intel/e1000e/net=
dev.c
CONFLICT (content): Merge conflict in Documentation/feature-removal-schedul=
e.txt
Merging modem-shm/for-next (3cff1cc caif_shm: Add CAIF driver for Shared me=
mory for M7400)
Merging memblock/memblock-kill-early_node_map (7bd0b0f memblock: Reimplemen=
t memblock allocation using reverse free area iterator)
Merging remoteproc/for-next (6c7b643 remoteproc: s/big switch/lookup table/)
CONFLICT (content): Merge conflict in include/linux/virtio_ids.h
Merging irqdomain/irqdomain/next (2462bac irq_domain/microblaze: Convert mi=
croblaze to use irq_domains)
CONFLICT (content): Merge conflict in arch/c6x/Kconfig
CONFLICT (content): Merge conflict in arch/arm/common/gic.c
Merging kvmtool/master (52b7a79 kvm tools: Fix "vm setup" help text)
Merging dma-mapping/dma-mapping-next (e972541 common: DMA-mapping: add NON-=
CONSISTENT attribute)
Merging ktest/for-next (be405f9 ktest: Add INGORE_ERRORS to ignore warnings=
 in boot up)
Merging scsi-post-merge/merge-base:master ()
$ git checkout akpm
Applying: kmsg_dump: don't run on non-error paths by default
Applying: kprobes: return proper error code from register_kprobe()
Applying: aio: wake up waiters when freeing unused kiocbs
Applying: net/netfilter/nf_conntrack_netlink.c: fix Oops on container destr=
oy
Applying: acerhdf: add support for Aspire 1410 BIOS v1.3314
Applying: acerhdf: add support for new hardware
Applying: acerhdf: lowered default temp fanon/fanoff values
Applying: arch/x86/platform/iris/iris.c: register a platform device and a p=
latform driver
Applying: x86, olpc-xo15-sci: enable lid close wakeup control through sysfs
Applying: geos: platform driver for Geos and Geos2 single-board computers
Applying: platform-drivers-x86: convert drivers/platform/x86/* to use modul=
e_platform_driver()
Applying: drivers/platform/x86/sony-laptop.c: fix scancodes
Applying: platform, x86: kill off Moorestown
Applying: intel_scu_ipc: remove Moorestown support
Applying: platform-x86: intel_mid_thermal: add msic_thermal alias
Applying: platform-x86: intel_mid_thermal: convert to use Intel MSIC API
Applying: platform-x86: intel_mid_thermal: turn off thermistor voltage by d=
efault
Applying: intel_mid_powerbtn: use MSIC read/write instead of ipc_scu
Applying: intel_mid_powerbtn: mark irq as IRQF_NO_SUSPEND
Applying: x86, olpc: add debugfs interface for EC commands
Applying: x86, mm: fix the size calculation of mapping tables
Applying: alix2: supplement driver to include GPIO button support
Applying: x86: net5501: platform driver for Soekris Engineering net5501 sin=
gle-board computer
Applying: x86: use this_cpu_xxx to replace percpu_xxx funcs
Applying: x86: change percpu_read_stable() to this_cpu_read_stable()
Applying: arch/arm/mach-ux500/mbox-db5500.c: world-writable sysfs fifo file
Applying: arm, exec: remove redundant set_fs(USER_DS)
Applying: arm: use set_current_blocked() and block_sigmask()
Applying: avr32: don't mask signals in the error path
Applying: avr32: use set_current_blocked() in handle_signal/sys_rt_sigreturn
Applying: avr32: use block_sigmask()
Applying: fs/btrfs/inode-map.c: fix warnings
Applying: powerpc: use set_current_blocked() and block_sigmask()
Applying: Hexagon: use set_current_blocked() and block_sigmask()
Applying: irqs: fix long-term regression in genirq irq_set_irq_type() handl=
ing
Applying: irqs: fix handling of pending IRQs at request time
Applying: softirq: reduce invoke_softirq() code duplication
Applying: tile: use set_current_blocked() and block_sigmask()
Applying: hrtimers: Special-case zero length sleeps
Applying: cs5535-clockevt: don't ignore MFGPT on SMP-capable kernels
Applying: cs5535-clockevt: allow the MFGPT IRQ to be shared
Applying: hpet: factor timer allocate from open
Applying: ia64: use set_current_blocked() and block_sigmask()
Applying: microblaze: don't reimplement force_sigsegv()
Applying: microblaze: no need to reset handler if SA_ONESHOT
Applying: microblaze: fix signal masking
Applying: microblaze: use set_current_blocked() and block_sigmask()
Applying: MIPS: use set_current_blocked() and block_sigmask()
Applying: score: don't mask signals if we fail to setup signal stack
Applying: score: use set_current_blocked() and block_sigmask()
Applying: drivers/thermal/thermal_sys.c: fix build warning
Applying: thermal_sys: remove unnecessary line continuations
Applying: thermal_sys: remove obfuscating used-once macros
Applying: thermal_sys: kernel style cleanups
Applying: thermal_sys: convert printks to pr_<level>
Applying: unicore32: use block_sigmask()
Applying: blackfin: use set_current_blocked() and block_sigmask()
Applying: bluetooth: add support for BCM20702A0 [0a5c:21e6]
Applying: debugobjects: Fix selftest for static warnings
Applying: ocfs2: use find_last_bit()
Applying: ocfs2: use bitmap_weight()
Applying: parisc: use set_current_blocked() and block_sigmask()
Applying: S390: use block_sigmask()
Applying: xtensa: don't reimplement force_sigsegv()
Applying: xtensa: no need to reset handler if SA_ONESHOT
Applying: xtensa: don't mask signals if we fail to setup signal stack
Applying: xtensa: use set_current_blocked() and block_sigmask()
Applying: slab: introduce kmalloc_array()
Applying: sparc: use block_sigmask()
Applying: mm, oom: avoid looping when chosen thread detaches its mm
Applying: mm, oom: fold oom_kill_task() into oom_kill_process()
Applying: mm, oom: do not emit oom killer warning if chosen thread is alrea=
dy exiting
Applying: mm, oom: introduce independent oom killer ratelimit state
Applying: mm: add rss counters consistency check
Applying: mm/vmscan.c: cleanup with s/reclaim_mode/isolate_mode/
Applying: mm: make get_mm_counter static-inline
Applying: mm: vmscan: fix misused nr_reclaimed in shrink_mem_cgroup_zone()
Applying: mm: make swapin readahead skip over holes
Applying: make-swapin-readahead-skip-over-holes-fix
Applying: vmscan: reclaim at order 0 when compaction is enabled
Applying: vmscan: kswapd carefully call compaction
Applying: vmscan-kswapd-carefully-call-compaction-fix
Applying: vmscan: only defer compaction for failed order and higher
Applying: compact_pgdat: workaround lockdep warning in kswapd
Applying: mm: compaction: make compact_control order signed
Applying: mm-compaction-make-compact_control-order-signed-fix
Applying: hugetlbfs: fix hugetlb_get_unmapped_area()
Applying: hugetlb: drop prev_vma in hugetlb_get_unmapped_area_topdown()
Applying: hugetlb: try to search again if it is really needed
Applying: hugetlb-try-to-search-again-if-it-is-really-needed-fix
Applying: mm: do not reset cached_hole_size when vma is unmapped
Applying: mm: search from free_area_cache for the bigger size
Applying: pagemap: avoid splitting thp when reading /proc/pid/pagemap
Applying: thp: optimize away unnecessary page table locking
Applying: pagemap: export KPF_THP
Applying: pagemap: document KPF_THP and make page-types aware of it
Applying: pagemap: introduce data structure for pagemap entry
Applying: mm: replace PAGE_MIGRATION with IS_ENABLED(CONFIG_MIGRATION)
Applying: mm: vmscan: forcibly scan highmem if there are too many buffer_he=
ads pinning highmem
Applying: mm: hugetlb: defer freeing pages when gathering surplus pages
Applying: mm: replace COMPACTION_BUILD with IS_ENABLED(CONFIG_COMPACTION)
Applying: mm-replace-compaction_build-with-is_enabledconfig_compaction-fix
Applying: mm: fix page-faults detection in swap-token logic
Applying: mm: add extra free kbytes tunable
Applying: mm-add-extra-free-kbytes-tunable-update
Applying: mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes
Applying: memcg: replace MEM_CONT by MEM_RES_CTLR
Applying: memcg: replace mem and mem_cont stragglers
Applying: memcg: lru_size instead of MEM_CGROUP_ZSTAT
Applying: memcg: enum lru_list lru
Applying: memcg: remove redundant returns
Applying: memcg: remove unnecessary thp check in page stat accounting
Applying: idr: make idr_get_next() good for rcu_read_lock()
Applying: cgroup: revert ss_id_lock to spinlock
Applying: memcg: let css_get_next() rely upon rcu_read_lock()
Applying: memcg: remove PCG_CACHE page_cgroup flag
Applying: memcg-remove-pcg_cache-page_cgroup-flag-checkpatch-fixes
Applying: memcg: kill dead prev_priority stubs
Applying: frv: use set_current_blocked() and block_sigmask()
Applying: sh: no need to reset handler if SA_ONESHOT
Applying: sh: use set_current_blocked() and block_sigmask()
Applying: h8300: use set_current_blocked() and block_sigmask()
Applying: alpha: use set_current_blocked() and block_sigmask()
Applying: m32r: use set_current_blocked() and block_sigmask()
Applying: m68k: use set_current_blocked() and block_sigmask()
Applying: mn10300: use set_current_blocked() and block_sigmask()
Applying: C6X: use set_current_blocked() and block_sigmask()
Applying: cris: use set_current_blocked() and block_sigmask()
Applying: um: don't restore current->blocked on error
Applying: um: use set_current_blocked() and block_sigmask()
Applying: magic.h: move some FS magic numbers into magic.h
Applying: nmi watchdog: do not use cpp symbol in Kconfig
Applying: ceph, cifs, nfs, fuse: boolean and / or confusion
Applying: net: use this_cpu_xxx replace percpu_xxx funcs
Applying: percpu: remove percpu_xxx() functions
Applying: prctl: add PR_{SET,GET}_CHILD_SUBREAPER to allow simple process s=
upervision
Applying: prctl-add-pr_setget_child_subreaper-to-allow-simple-process-super=
vision-fix
Applying: prctl-add-pr_setget_child_subreaper-to-allow-simple-process-super=
vision-fix-fix
Applying: kernel/exit.c: if init dies, log a signal which killed it, if any
Applying: kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any-fix
Applying: posix_types: make __kernel_[ug]id32_t default to unsigned int
Applying: posix_types: make it possible to override __kernel_fsid_t
Applying: alpha: use generic posix_types.h
Applying: arm: use generic posix_types.h
Applying: avr32: use generic posix_types.h
Applying: cris: use generic posix_types.h
Applying: frv: use generic posix_types.h
Applying: h8300: use generic posix_types.h
Applying: ia64: use generic posix_types.h
Applying: m32r: use generic posix_types.h
Applying: m68k: use generic posix_types.h
Applying: mips: use generic posix_types.h
Applying: mn10300: use generic posix_types.h
Applying: parisc: use generic posix_types.h
Applying: powerpc: use generic posix_types.h
Applying: s390: use generic posix_types.h
Applying: sh: remove unnecessary posix_types.h type overrides
Applying: sparc: use generic posix_types.h
Applying: x86: use generic posix_types.h
Applying: xtensa: use generic posix_types.h
Applying: posix_types: remove fd_set macros
Applying: posix_types-remove-fd_set-macros-checkpatch-fixes
Applying: vfs: increment iversion when a file is truncated
Applying: brlocks/lglocks: cleanups
Applying: brlocks-lglocks-cleanups-checkpatch-fixes
Applying: vfs: correctly set the dir i_mutex lockdep class
Applying: seq_file: fix mishandling of consecutive pread() invocations.
Applying: MAINTAINERS: fix REMOTEPROC F: typo
Applying: MAINTAINERS: Update MCA section
CONFLICT (content): Merge conflict in MAINTAINERS
Applying: MAINTAINERS: update git urls for 2.6 deletions
Applying: backlight: convert backlight i2c drivers to module_i2c_driver
Applying: backlight: convert backlight spi drivers to module_spi_driver
Applying: drivers/video/backlight/wm831x_bl.c: use devm_ functions
Applying: drivers/video/backlight: use devm_ functions
Applying: drivers/video/backlight/adp5520_bl.c: use devm_ functions
Applying: backlight: new backlight driver for LP855x devices
Applying: backlight: lp855x_bl: Add missing mutex_unlock in lp855x_read_byt=
e error path
Applying: backlight/lp855x_bl.c: check platform data in lp855x_probe()
Applying: backlight/lp855x_bl.c: small cleanups
Applying: backlight: add driver for Bachmann's ot200
Applying: backlight-add-driver-for-bachmanns-ot200-fix
Applying: backlight: add support for Pandora backlight
Applying: backlight-add-support-for-pandora-backlight-v2
Applying: bitops: rename for_each_set_bit_cont() in favor of analogous list=
.h function
Applying: bitops: remove for_each_set_bit_cont()
Applying: bitops: introduce for_each_clear_bit()
Applying: mtd: use for_each_clear_bit()
Applying: s390/char: use for_each_clear_bit()
Applying: uwb: use for_each_clear_bit()
Applying: x86: use for_each_clear_bit_from()
Applying: drivers/leds/leds-lp5521.c: fix typo
Applying: drivers/leds/leds-tca6507.c: cleanup error handling in tca6507_pr=
obe()
Applying: drivers/leds/leds-lp5521.c: add 'name' in the lp5521_led_config
Applying: drivers/leds/leds-lp5521.c: add 'update_config' in the lp5521_pla=
tform_data
Applying: drivers/leds/leds-lp5521.c: support led pattern data
Applying: leds-lp5521-support-led-pattern-data-checkpatch-fixes
Applying: drivers/leds/leds-lp5521.c: redefinition of register bits
Applying: drivers/leds/leds-lp5523.c: constify some data
Applying: drivers/leds: add driver for PCA9633 I2C chip
Applying: drivers-leds-add-driver-for-pca9663-i2c-chip-fix
Applying: drivers-leds-add-driver-for-pca9663-i2c-chip-fix-2
Applying: drivers/leds/leds-gpio.c: use linux/gpio.h rather than asm/gpio.h
Applying: leds-lm3530: set the max_brightness to 127
Applying: leds-lm3530: replace i2c_client with led_classdev
Applying: leds-lm3530-replace-i2c_client-with-led_classdev-fix
Applying: leds-lm3530: support pwm input mode
Applying: leds-lm3530: remove LM3530_ALS_ZONE_REG code
Applying: leds-lm3530: replace pltfm with pdata
Applying: drivers/leds/leds-pca9633.c: remove unused 'adapter' variable
Applying: drivers/leds/leds-lm3530.c: move the code setting gen_config to o=
ne place
Applying: drivers-leds-leds-lm3530c-move-the-code-setting-gen_config-to-one=
-place-fix
Applying: string: memchr_inv speed improvements
Applying: prio_tree: remove unnecessary code in prio_tree_replace
Applying: prio_tree: cleanup prio_tree_left()/prio_tree_right()
Applying: prio_tree: simplify prio_tree_expand()
Applying: prio_tree: introduce prio_set_parent()
Applying: include/ and checkpatch: prefer __scanf to __attribute__((format(=
scanf,...)
Applying: crc32: remove two instances of trailing whitespaces
Applying: crc32: move long comment about crc32 fundamentals to Documentatio=
n/
Applying: crc32-move-long-comment-about-crc32-fundamentals-to-documentation=
-fix
Applying: crc32: simplify unit test code
Applying: crc32: miscellaneous cleanups
Applying: crc32: fix mixing of endian-specific types
Applying: crc32: make CRC_*_BITS definition correspond to actual bit counts
Applying: crc32: add slice-by-8 algorithm to existing code
Applying: crc32: optimize loop counter for x86
Applying: crc32: add note about this patchset to crc32.c
Applying: crc32: bolt on crc32c
Applying: crc32: Don't reference unnecessary crc32 tables in single-bit mode
Applying: crypto: crc32c should use library implementation
Applying: crc32: add self-test code for crc32c
Applying: crc32: select an algorithm via Kconfig
Applying: epoll: comment the funky #ifdef
Applying: init/do_mounts.c: create /root if it does not exist
Applying: rtc-spear: fix for balancing the enable_irq_wake in Power Mgmt
Applying: rtc/spear: fix for RTC_AIE_ON and RTC_AIE_OFF ioctl errors
Applying: rtc/rtc-spear: call platform_set_drvdata() before registering rtc=
 device
Applying: rtc: convert rtc spi drivers to module_spi_driver
Applying: rtc: convert rtc i2c drivers to module_i2c_driver
Applying: MIPS: add RTC support for loongson1B
Applying: drivers/rtc/rtc-twl.c: optimize IRQ bit access
Applying: drivers/rtc/rtc-twl.c: enable RTC irrespective of its prior state
Applying: drivers/rtc/rtc-twl.c: simplify RTC interrupt clearing
Applying: drivers/rtc/rtc-twl.c: return correct RTC event from ISR
Applying: drivers/rtc: remove IRQF_DISABLED
Applying: drivers/rtc/rtc-pm8xxx.c: make pm8xxx_rtc_pm_ops static
Applying: drivers/rtc/rtc-max8925.c: fix max8925_rtc_read_alarm() return va=
lue error
Applying: drivers/rtc/rtc-max8925.c: fix alarm->enabled mistake in max8925_=
rtc_read_alarm/max8925_rtc_set_alarm
Applying: rtc: driver for DA9052/53 PMIC v1
Applying: rtc-rtc-driver-for-da9052-53-pmic-v1-fix
Applying: ptrace: the killed tracee should not enter the syscall
Applying: ptrace: don't send SIGTRAP on exec if SEIZED
Applying: ptrace: don't modify flags on PTRACE_SETOPTIONS failure
Applying: ptrace: simplify PTRACE_foo constants and PTRACE_SETOPTIONS code
Applying: ptrace: make PTRACE_SEIZE set ptrace options specified in 'data' =
parameter
Applying: ptrace: renumber PTRACE_EVENT_STOP so that future new options and=
 events can match
Applying: ptrace: remove PTRACE_SEIZE_DEVEL bit
Applying: signal: give SEND_SIG_FORCED more power to beat SIGNAL_UNKILLABLE
Applying: signal: cosmetic, s/from_ancestor_ns/force/ in prepare_signal() p=
aths
Applying: signal: oom_kill_task: use SEND_SIG_FORCED instead of force_sig()
Applying: signal: zap_pid_ns_processes: s/SEND_SIG_NOINFO/SEND_SIG_FORCED/
Applying: usermodehelper: use UMH_WAIT_PROC consistently
Applying: usermodehelper: introduce umh_complete(sub_info)
Applying: usermodehelper: implement UMH_KILLABLE
Applying: usermodehelper: kill umh_wait, renumber UMH_* constants
Applying: usermodehelper: ____call_usermodehelper() doesn't need do_exit()
Applying: kmod: introduce call_modprobe() helper
Applying: kmod: make __request_module() killable
Applying: kmod: avoid deadlock from recursive kmod call
Applying: kmod-avoid-deadlock-by-recursive-kmod-call-fix
Applying: fs/proc/kcore.c: make get_sparsemem_vmemmap_info() static
Applying: proc: speedup /proc/stat handling
Applying: procfs: add num_to_str() to speed up /proc/stat
Applying: procfs-add-num_to_str-to-speed-up-proc-stat-fix
Applying: procfs: avoid breaking the ABI in /proc/stat
Applying: procfs: speed up /proc/pid/stat, statm
Applying: procfs-speed-up-proc-pid-stat-statm-checkpatch-fixes
Applying: proc: clean up /proc/<pid>/environ handling
Applying: seq_file: add seq_set_overflow(), seq_overflow()
Applying: seq_file-add-seq_set_overflow-seq_overflow-fix
Applying: smp: introduce a generic on_each_cpu_mask() function
Applying: arm: move arm over to generic on_each_cpu_mask
Applying: tile: move tile to use generic on_each_cpu_mask
Applying: smp: add func to IPI cpus based on parameter func
Applying: smp-add-func-to-ipi-cpus-based-on-parameter-func-fix
Applying: smp-add-func-to-ipi-cpus-based-on-parameter-func-update
Applying: smp-add-func-to-ipi-cpus-based-on-parameter-func-update-fix
Applying: smp: add func to IPI cpus based on parameter func
Applying: smp-add-func-to-ipi-cpus-based-on-parameter-func-v9-fix
Applying: slub: only IPI CPUs that have per cpu obj to flush
Applying: fs: only send IPI to invalidate LRU BH when needed
Applying: mm: only IPI CPUs to drain local pages if they exist
Applying: mm-only-ipi-cpus-to-drain-local-pages-if-they-exist-update
Applying: mm-only-ipi-cpus-to-drain-local-pages-if-they-exist-v9
Applying: lib/cpumask.c: remove __any_online_cpu()
Applying: arch/ia64: remove references to cpu_*_map
Applying: cpumask: avoid mask based num_possible_cpus() and num_online_cpus=
()
Applying: ipc/sem.c: alternatives to preempt_disable()
Applying: ipc: provide generic compat versions of IPC syscalls
Applying: ipmi: decrease the IPMI message transaction time in interrupt mode
Applying: ipmi: increase KCS timeouts
Applying: ipmi: use a tasklet for handling received messages
Applying: ipmi: fix message handling during panics
Applying: ipmi: simplify locking
Applying: ipmi: use locks on watchdog timeout set on reboot
Applying: sysctl: use bitmap library functions
Applying: pidns: add reboot_pid_ns() to handle the reboot syscall
Applying: pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-fix
Applying: pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-checkpatch-f=
ixes
Applying: fs/proc/namespaces.c: prevent crash when ns_entries[] is empty
Applying: selftests: launch individual selftests from the main Makefile
Applying: selftests/Makefile: make `run_tests' depend on `all'
Applying: mm: move page-types.c from Documentation to tools/vm
Applying: mm: move slabinfo.c to tools/vm
Applying: mm: move hugepage test examples to tools/testing/selftests/vm
Applying: move-hugepage-test-examples-to-tools-testing-selftests-vm-fix
Applying: move-hugepage-test-examples-to-tools-testing-selftests-vm-fix-fix
Applying: sysctl: make kernel.ns_last_pid control dependent on CHECKPOINT_R=
ESTORE
Applying: fs, proc: introduce /proc/<pid>/task/<tid>/children entry
Applying: syscalls, x86: add __NR_kcmp syscall
Applying: c/r: procfs: add arg_start/end, env_start/end and exit_code membe=
rs to /proc/$pid/stat
Applying: c/r: prctl: extend PR_SET_MM to set up more mm_struct entries
Applying: ramoops: use pstore interface
Applying: ramoops: fix printk format warnings
Applying: notify_change(): check that i_mutex is held
Applying: syscalls-x86-add-__nr_kcmp-syscall-v8-fix
Merging akpm (79bad61 syscalls-x86-add-__nr_kcmp-syscall-v8-fix)
[master 985d4c8] Revert "posix_types-remove-fd_set-macros-checkpatch-fixes"
[master d7f37eb] Revert "posix_types: remove fd_set macros"
Applying: powerpc: use generic posix_types.h fix

--Signature=_Tue__21_Feb_2012_15_58_22_+1100_PcFpOMK/pMvNeJ5N
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPQyRuAAoJEECxmPOUX5FEuzYQAKISZiscoBrQoGyc8s+vS323
/nuDZsFkHJvq8FyeAwciGlpC9qwCxfeDO+YnBKNlQ9T/kLWpuJRHNhEB3hMoBH4o
zDFmby9sSRMiKRQsosLhvp7kwSYqQr8dQwmUc5YxX/0BfpHh7hKXF2MZCVoCJ3pK
GGAxPYa3fbu9TRvgdxMGBWU06YWhdXBKww+zhntlbIv0XvR/ri+l8VxSUkCpcSf+
vYbuEVVg+vFfb7dqE0cfhjgUJ1UCedtTkP/YbKIjVTCwNDovJzuTHAKcXisg+7Pn
Iz1jH0dcs69K4OjEaXQBS5GUc/oSTkP9gI/WxijPhpyGCUbfQM57zEPRn9sCnPxS
9UvHrxTAAtDuTXCrUFlV4RZJWHS1mt43E/0B/cle9mKYq3k0iliInemrwKLHC8Sb
KWd1xJ1FRVQg1MxjG6MR6WKMZ5E4pEOy+DvnPQpdX8Ak1VCHmCln3WvZHlol9Qel
0qtSVTO2shj76gii4X0GkKSZCp/2xzZmDUkZtJVEReMqgwSlkDwjNPPBLwnmo7Zd
wOqSaQf+Xeu4gEB9OtJpS/vB+Ma6XTAGQESKGEFTwYM6vhEqrWljLE5QsJXvzrFI
5SsM8Hc+1c+G7X9iJstg2nAZ6umvbelNCnxDNR692VK3BMlfg6RedSlB6ZZO7vmb
rRtV8gw/JHg32a3ohwLk
=kjCO
-----END PGP SIGNATURE-----

--Signature=_Tue__21_Feb_2012_15_58_22_+1100_PcFpOMK/pMvNeJ5N--

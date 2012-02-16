Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189Ab2BPFmN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 00:42:13 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:41704 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193Ab2BPFlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 00:41:53 -0500
Date: Thu, 16 Feb 2012 16:41:44 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Feb 16
Message-Id: <20120216164144.35e98f5ee8f1b1f545406309@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__16_Feb_2012_16_41_44_+1100_yXTKB7v1OyVBvqgH"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__16_Feb_2012_16_41_44_+1100_yXTKB7v1OyVBvqgH
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20120215:

The net-net tree gained conflicts against the net and wireless trees.

The fbdev tree gained a build failure for which I reverted a commit.

I reverted a commit from the rr tree that causes build failures on some
PowerPC builds.

The oprofile tree lost its conflict.

The staging tree gained a build failure so I used the version from
next-20120215.

The akpm tree gained a conflict against the wireless tree.  I also
reverted a patch that caused boot failures on (at least) some PowerPC
servers.

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
Merging origin/master (c38e234 i387: fix sense of sanity check)
Merging fixes/master (f8275f9 Merge branch 'release' of git://git.kernel.or=
g/pub/scm/linux/kernel/git/lenb/linux)
Merging kbuild-current/rc-fixes (620c231 kbuild: do not check for ancient m=
odutils tools)
Merging arm-current/fixes (bdf800c ARM: 7322/1: Print BUG instead of undefi=
ned instruction on BUG_ON())
Merging m68k-current/for-linus (2a35350 m68k: Fix assembler constraint to p=
revent overeager gcc optimisation)
Merging powerpc-merge/merge (778a785 powerpc/pseries/eeh: Fix crash when er=
ror happens during device probe)
Merging 52xx-and-virtex-current/powerpc/merge (c49f878 dtc/powerpc: remove =
obsolete .gitignore entries)
Merging sparc/master (e51e07e sparc32: forced setting of mode of sun4m per-=
cpu timers)
Merging scsi-rc-fixes/master (6f6c2aa [SCSI] fcoe: fix fcoe in a DCB enviro=
nment by adding DCB notifiers to set skb priority)
Merging net/master (6c23e41 net/ethernet: ks8851_mll fix irq handling)
Merging sound-current/for-linus (27c3afe ALSA: intel8x0: Fix default inaudi=
ble sound on Gateway M520)
Merging pci-current/for-linus (3682a39 PCI: Fix pci cardbus removal)
Merging wireless/master (2504a64 ath9k: stop on rates with idx -1 in ath9k =
rate control's .tx_status)
Merging driver-core.current/driver-core-linus (29bb5d4 driver-core: cpu: fi=
x kobject warning when hotplugging a cpu)
Merging tty.current/tty-linus (19e00f2 Merge tag 'tty-3.3-rc3' of git://git=
.kernel.org/pub/scm/linux/kernel/git/gregkh/tty)
Merging usb.current/usb-linus (b9e44fe USB: option: cleanup zte 3g-dongle's=
 pid in option.c)
Merging staging.current/staging-linus (b05ee6b Merge tag 'staging-3.3-rc3' =
of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging)
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
Merging crypto-current/master (3a92d68 crypto: sha512 - Avoid stack bloat o=
n i386)
Merging ide/master (0ab3d8b cy82c693: fix PCI device selection)
Merging dwmw2/master (244dc4e Merge git://git.infradead.org/users/dwmw2/ran=
dom-2.6)
Merging devicetree-current/devicetree/merge (2261cc6 dt: add empty of_find_=
compatible_node function)
Merging spi-current/spi/merge (c88db23 spi-topcliff-pch: rename pch_spi_pci=
dev to pch_spi_pcidev_driver)
Merging gpio-current/gpio/merge (7e3a70f gpio: Add missing spin_lock_init i=
n gpio-ml-ioh driver)
Merging arm/for-next (827dcfb Merge branch 'sa11x0' into for-next)
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
Merging mips/mips-for-linux-next (8551715 Merge branches 'fixes-for-linus' =
and 'next/lantiq' into mips-for-linux-next)
Merging openrisc/for-upstream (9fdd35e OpenRISC: Use set_current_blocked() =
and block_sigmask())
Merging parisc/for-next (fc99a91 futex: Use same lock set as lws calls)
Merging powerpc/next (ef88e39 powerpc: fix compile error with 85xx/p1010rdb=
.c)
Merging 4xx/next (ef88e39 powerpc: fix compile error with 85xx/p1010rdb.c)
Merging 52xx-and-virtex/powerpc/next (c1395f4 dtc/powerpc: remove obsolete =
.gitignore entries)
Merging galak/next (ef88e39 powerpc: fix compile error with 85xx/p1010rdb.c)
Merging s390/features (7014bc6 [S390] irq: external interrupt code passing)
Merging sparc-next/master (b409650 arch/sparc/kernel/unaligned_64.c: includ=
ed linux/bitops.h twice)
Merging tile/master (0c90547 arch/tile: use new generic {enable,disable}_pe=
rcpu_irq() routines)
Merging unicore32/unicore32 (0994695 Merge branch 'akpm' (aka "Andrew's pat=
ch-bomb, take two"))
Merging ceph/for-next (83eb26a ceph: ensure prealloc_blob is in place when =
removing xattr)
Merging cifs/master (7ada1dd Merge tag 'for-linus' of git://git.kernel.org/=
pub/scm/linux/kernel/git/broonie/regulator)
Merging configfs/linux-next (b930c26 Merge branch 'for-linus' of git://git.=
kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (6cfd4b4 ecryptfs: remove the second argument of k[un=
]map_atomic())
Merging ext3/for_next (62aa2b5 Linux 3.3-rc2)
Merging ext4/dev (d2403ca ext4: using PTR_ERR() on the wrong variable in ex=
t4_ext_migrate())
Merging fuse/for-next (03c9693 cuse: implement memory mapping)
Merging gfs2/master (bc5fd03 GFS2: Sort the ordered write list)
Merging logfs/master (3b582f3 Merge tag 'battery-fixes-for-v3.3-rc2' of git=
://git.infradead.org/users/cbou/battery-urgent)
Merging nfs/linux-next (aedfdbf Merge branch 'nfs-for-next' into linux-next)
Merging nfsd/nfsd-next (37c593c nfsd41: use current stateid by value)
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
Merging pci/linux-next (a78cfc93 PCI / PM: Disable wakeup during shutdown f=
or devices not enabled to wake up)
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
Merging kbuild/for-next (d90898e Merge branch 'kbuild/misc' into kbuild/for=
-next)
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
Merging scsi/master (76ffe8a [SCSI] libfc: remove redundant timer init for =
fcp)
Merging target-updates/for-next (24d2f08 tcm_fc: Remove cmd->cdb data membe=
r)
Merging target-merge/for-next-merge (d65b4e9 Linux 3.3-rc3)
Merging ibft/linux-next (935a9fe ibft: Fix finding IBFT ACPI table on UEFI)
Merging isci/all (57872c2 Merge branches 'devel' and 'fixes' into all)
Merging slave-dma/next (b63fd6c i.MX SDMA: Fix burstsize settings)
Merging dmaengine/next (d07a74a dmaengine: fix missing 'cnt' in ?: in dmate=
st)
Merging net-next/master (80703d2 ipv4: Eliminate spurious argument to __ipv=
4_neigh_lookup)
CONFLICT (content): Merge conflict in net/mac80211/sta_info.h
CONFLICT (content): Merge conflict in net/mac80211/debugfs_sta.c
CONFLICT (content): Merge conflict in drivers/net/ethernet/broadcom/bnx2x/b=
nx2x_stats.c
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
Merging crypto/master (0cfdec7 crypto: In crypto_add_alg(), 'exact' wants t=
o be initialized to 0)
CONFLICT (content): Merge conflict in arch/arm/mach-tegra/fuse.c
Merging sound/for-next (c35804a Merge branch 'fix/misc' into for-next)
Merging sound-asoc/for-next (df98b37 Merge branch 'for-3.4' into asoc-next)
CONFLICT (content): Merge conflict in sound/soc/codecs/wm5100.c
Merging cpufreq/next (6c523c6 [CPUFREQ] EXYNOS: Removed useless headers and=
 codes)
Merging quilt/rr (b7e745a virtio: update documentation to v0.9.4 of spec)
[master 4cb43e0] Revert "params: Add missing init level name"
[master 11b4ae4] Revert "params: <level>_initcall-like kernel parameters"
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
Merging mmc/mmc-next (8b4e801 mmc: dw_mmc: shift with slot-id for CLKENA re=
gister)
Merging kgdb/kgdb-next (880ba69 lib: rename pack_hex_byte() to hex_byte_pac=
k())
Merging slab/for-next (4de900b slub: include include for prefetch)
Merging uclinux/for-next (5e442a4 Revert "proc: fix races against execve() =
of /proc/PID/fd**")
Merging md/for-next (fae8cc5 md/raid10: fix handling of error on last worki=
ng device in array.)
Merging mfd/for-next (fa884b5 mfd: twl-core: Don't specify regulator consum=
ers by struct device)
Merging drm/drm-next (cdbe8b5 Merge tag 'drm-intel-next-2012-02-07' of git:=
//people.freedesktop.org/~danvet/drm-intel into drm-core-next)
Merging fbdev/fbdev-next (5350c65 Resurrect Intel740 driver: i740fb)
Merging viafb/viafb-next (7b91812 Merge branch 'viafb-aux' into viafb-next)
Merging omap_dss2/for-next (9a90168 OMAPDSS: HDMI: Disable DDC internal pul=
l up)
Merging regulator/for-next (d46f5ea Merge branch 'regulator-supply' into re=
gulator-next)
Merging security/next (bf06189 Yama: add PR_SET_PTRACER_ANY)
Merging selinux/master (dc2e1ff Merge commit 'v3.2' into 20120130)
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
Merging pm/linux-next (40bd93b PM / Hibernate: print physical addresses con=
sistently with other parts of kernel)
Merging apm/for-next (b4a133d Merge branch 'for-linus' of git://git.kernel.=
org/pub/scm/linux/kernel/git/jikos/apm)
Merging fsnotify/for-next (ef9bf3b fanotify: only destroy a mark if both it=
s mask and its ignored_mask are cleared)
Merging edac/linux_next (4d096ca MAINTAINERS: add an entry for Edac Sandy B=
ridge driver)
Merging edac-amd/for-next (5a42394 Merge remote-tracking branch 'kepek/3.3-=
edac-dbam' into edac-for-next)
Merging devicetree/devicetree/next (5411972 arm/dts: OMAP3: Add omap3evm an=
d am335xevm support)
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
Merging regmap/for-next (bfe55e9 Merge branch 'regmap-linus' into regmap-ne=
xt)
Merging hsi/for-next (43139a6 HSI: hsi_char: Update ioctl-number.txt)
Merging driver-core/driver-core-next (bc5bca5 driver-core: documentation: f=
ix up Greg's email address)
CONFLICT (content): Merge conflict in drivers/base/cpu.c
Merging tty/tty-next (6816383 tty: sparc: rename drivers/tty/serial/suncore=
.h -> include/linux/sunserialcore.h)
Merging usb/usb-next (03a41f3 Merge tag 'for-usb-next-2012-02-14' of git://=
git.kernel.org/pub/scm/linux/kernel/git/sarah/xhci into usb-next)
Merging staging/staging-next (2140dc9 staging: clean up Greg's email addres=
s in some TODO files)
$ git reset --hard HEAD^
Merging refs/next/20120215/staging
Merging char-misc/char-misc-next (838d51b char: Fix typo in tlclk.c)
Merging arm-soc/for-next (69bae69 Merge branch 'next/soc2' into for-next)
Merging tmem/linux-next (b05b561 Merge branch 'devel/frontswap.v13' into li=
nux-next)
Applying: mm: frontswap: update for security_vm_enough_memory API change
Merging writeback/writeback-for-next (977b7e3 writeback: fix dereferencing =
NULL bdi->dev on trace_writeback_queue)
Merging arm-dt/devicetree/arm-next (ede338f dt: add documentation of ARM dt=
 boot interface)
Merging hwspinlock/linux-next (8b37fcf hwspinlock: add MAINTAINERS entries)
Merging pinctrl/for-next (77a5988 pinctrl: changes hog mechanism to be self=
-referential)
Merging moduleh/for-sfr (6aec187 drivers/media: video/a5k6aa is a module an=
d so needs module.h)
Merging vhost/linux-next (1e05b62 sh: use the the PCI channels's io_map_bas=
e)
Merging kmap_atomic/kmap_atomic (019e9ad feature-removal-schedule.txt: sche=
dule the deprecated form of kmap_atomic() for removal)
CONFLICT (content): Merge conflict in drivers/staging/zram/zram_drv.c
CONFLICT (modify/delete): drivers/staging/zram/xvmalloc.c deleted in HEAD a=
nd modified in kmap_atomic/kmap_atomic. Version kmap_atomic/kmap_atomic of =
drivers/staging/zram/xvmalloc.c left in tree.
CONFLICT (content): Merge conflict in drivers/staging/zcache/zcache-main.c
CONFLICT (content): Merge conflict in drivers/scsi/storvsc_drv.c
CONFLICT (content): Merge conflict in drivers/net/ethernet/intel/e1000e/net=
dev.c
CONFLICT (content): Merge conflict in Documentation/feature-removal-schedul=
e.txt
$ git rm -f drivers/staging/zram/xvmalloc.c
Merging modem-shm/for-next (3cff1cc caif_shm: Add CAIF driver for Shared me=
mory for M7400)
Merging memblock/memblock-kill-early_node_map (7bd0b0f memblock: Reimplemen=
t memblock allocation using reverse free area iterator)
Merging remoteproc/for-next (6c7b643 remoteproc: s/big switch/lookup table/)
Merging irqdomain/irqdomain/next (98ecf52 irq_domain/microblaze: Convert mi=
croblaze to use irq_domains)
CONFLICT (content): Merge conflict in drivers/mfd/twl-core.c
CONFLICT (content): Merge conflict in arch/arm/common/gic.c
Merging kvmtool/master (8bff3eb kvm tools: Add guest/init_stage2 to .gitign=
ore)
Merging dma-mapping/dma-mapping-next (e972541 common: DMA-mapping: add NON-=
CONSISTENT attribute)
Merging ktest/for-next (be405f9 ktest: Add INGORE_ERRORS to ignore warnings=
 in boot up)
Merging scsi-post-merge/merge-base:master ()
$ git checkout akpm
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
Applying: alix2-supplement-driver-to-include-gpio-button-support-fix
Applying: alix2-supplement-driver-to-include-gpio-button-support-fix-2
Applying: x86: net5501: platform driver for Soekris Engineering net5501 sin=
gle-board computer
Applying: net5501-platform-driver-for-soekris-engineering-net5501-single-bo=
ard-computer-fix
Applying: drivers/platform/x86/sony-laptop.c: fix scancodes
Applying: arch/arm/mach-ux500/mbox-db5500.c: world-writable sysfs fifo file
Applying: arm, exec: remove redundant set_fs(USER_DS)
Applying: fs/btrfs/inode-map.c: fix warnings
Applying: net: use this_cpu_xxx replace percpu_xxx funcs
Applying: x86: use this_cpu_xxx to replace percpu_xxx funcs
Applying: x86: change percpu_read_stable() to this_cpu_read_stable()
Applying: percpu: remove percpu_xxx() functions
Applying: Subject irqs: fix long-term regression in genirq irq_set_irq_type=
() handling
Applying: irqs: fix handling of pending IRQs at request time
Applying: hrtimers: Special-case zero length sleeps
Applying: cs5535-clockevt: don't ignore MFGPT on SMP-capable kernels
Applying: cs5535-clockevt: allow the MFGPT IRQ to be shared
Applying: hpet: factor timer allocate from open
Applying: drivers/thermal/thermal_sys.c: fix build warning
Applying: thermal-thermal_sys-fix-build-warning-fix
Applying: thermal_sys: remove unnecessary line continuations
Applying: thermal_sys: remove obfuscating used-once macros
Applying: thermal_sys: kernel style cleanups
Applying: thermal_sys: convert printks to pr_<level>
Applying: bluetooth: add support for BCM20702A0 [0a5c:21e6]
CONFLICT (content): Merge conflict in drivers/bluetooth/btusb.c
Applying: debugobjects: Fix selftest for static warnings
Applying: ocfs2: use find_last_bit()
Applying: ocfs2: use bitmap_weight()
Applying: drivers/scsi/aacraid/commctrl.c: fix mem leak in aac_send_raw_srb=
()
Applying: drivers/scsi/mpt2sas/mpt2sas_base.c: fix mismatch in mpt2sas_base=
_hard_reset_handler() mutex lock-unlock
Applying: drivers/scsi/mpt2sas/mpt2sas_scsih.c: spell "primitive" correctly
Applying: drivers/scsi/hpsa.c: use find_first_zero_bit()
Applying: MAINTAINERS: Staging: cx25821: Add L: linux-media
Applying: mm, oom: avoid looping when chosen thread detaches its mm
Applying: mm, oom: fold oom_kill_task() into oom_kill_process()
Applying: mm, oom: do not emit oom killer warning if chosen thread is alrea=
dy exiting
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
Applying: magic.h: move some FS magic numbers into magic.h
Applying: nmi watchdog: do not use cpp symbol in Kconfig
Applying: ceph, cifs, nfs, fuse: boolean and / or confusion
Applying: prctl: add PR_{SET,GET}_CHILD_SUBREAPER to allow simple process s=
upervision
Applying: prctl-add-pr_setget_child_subreaper-to-allow-simple-process-super=
vision-fix
Applying: prctl-add-pr_setget_child_subreaper-to-allow-simple-process-super=
vision-fix-fix
Applying: prctl-add-pr_setget_child_subreaper-to-allow-simple-process-super=
vision-fix-fix-fix
Applying: kernel/exit.c: if init dies, log a signal which killed it, if any
Applying: kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any-fix
Applying: smp: start up non-boot CPUs asynchronously
Applying: smp-start-up-non-boot-cpus-asynchronously-fix
Applying: vfs: increment iversion when a file is truncated
Applying: brlocks/lglocks: cleanups
Applying: brlocks-lglocks-cleanups-checkpatch-fixes
Applying: vfs: correctly set the dir i_mutex lockdep class
Applying: seq_file: fix mishandling of consecutive pread() invocations.
Applying: MAINTAINERS: fix REMOTEPROC F: typo
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
Applying: drivers/leds: add driver for PCA9663 I2C chip
Applying: drivers-leds-add-driver-for-pca9663-i2c-chip-fix
Applying: drivers-leds-add-driver-for-pca9663-i2c-chip-fix-2
Applying: drivers/leds/leds-gpio.c: use linux/gpio.h rather than asm/gpio.h
Applying: string: memchr_inv speed improvements
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
Applying: drivers/rtc/rtc-ds1307.c: generalise ram size and offset
Applying: drivers/rtc/rtc-max8925.c: fix max8925_rtc_read_alarm() return va=
lue error
Applying: drivers/rtc/rtc-max8925.c: fix alarm->enabled mistake in max8925_=
rtc_read_alarm/max8925_rtc_set_alarm
Applying: rtc: driver for DA9052/53 PMIC v1
Applying: rtc-rtc-driver-for-da9052-53-pmic-v1-fix
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
Applying: slub: only IPI CPUs that have per cpu obj to flush
Applying: fs: only send IPI to invalidate LRU BH when needed
Applying: mm: only IPI CPUs to drain local pages if they exist
Applying: mm-only-ipi-cpus-to-drain-local-pages-if-they-exist-update
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
Applying: sysctl: make kernel.ns_last_pid control dependent on CHECKPOINT_R=
ESTORE
Applying: ramoops: use pstore interface
Applying: ramoops: fix printk format warnings
Applying: notify_change(): check that i_mutex is held
Merging akpm (afd6a7a notify_change(): check that i_mutex is held)
[master 86161d9] Revert "smp-start-up-non-boot-cpus-asynchronously-fix"
[master f2be678] Revert "smp: start up non-boot CPUs asynchronously"

--Signature=_Thu__16_Feb_2012_16_41_44_+1100_yXTKB7v1OyVBvqgH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPPJcYAAoJEECxmPOUX5FEa5AP/1IzNvoH0bbVb1kkgLPLmSsO
IATcvOvh4Q2HYUWnHlvVS8xLh46/fQtnXS/1bqy2rXft0SC320IKC+CeJ8zhb/5b
Q3mrZRkozp0Fbw7mnmwzu1jfiaPMCmhEYP2I8FDOZ3TtpfDFVc6Tv3ThhcnVlwVW
gWvATROOXPS2etainHzKDSaFi+zxpzKea6eu6sZi112a5/r/qVeaS3yFNJ8yZz3R
lJLy2RI6xit++RxWnsbGbtPw6med4CR1hrWt7A1/osAlGgMv4Mr0W9zQyvgMOgpd
vD1v+KmwCAgWcGIEEh3CtDVZ0dabAvZad6J1zxRaDUnYvGY4NmaVmqGorFItPdGN
0dReWapSMYRV5eki8GTeolmf4z//ukVOBHM+mRknHwhWv5XLahdO6DsEi0AwpdQt
E2IrVU6p82dXJ1tXn4ZqSHyM6BwSOcOf5nHO7OJhCgzNFqX45AzRi580OY6g0AFH
mGcYp9Atx0CZa1eTdI6aCgO7p5d83Gf2LoA3JQQ8YDu4sGbAaD9u+8UIKeSThl8z
Fu0GwnkCXhxdDEapDuvets9sR7OcIxiloah3ERE9HcenkbzSpA2YOBbTjdqRXlkO
R9GCR4eqUrMxcIiOCDZ640f0eb7FAbCPxyIpLAg69mWunCQ7mfPcVZ4TEGl52YgR
yK683sEEcQZIWpexbP54
=XURD
-----END PGP SIGNATURE-----

--Signature=_Thu__16_Feb_2012_16_41_44_+1100_yXTKB7v1OyVBvqgH--

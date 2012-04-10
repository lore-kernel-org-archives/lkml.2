Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072Ab2DJEz7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 00:55:59 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:58751 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471Ab2DJEz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 00:55:56 -0400
Date: Tue, 10 Apr 2012 14:55:46 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Apr 10
Message-Id: <20120410145546.65b54b0d515db38e23bb4624@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__10_Apr_2012_14_55_46_+1000_+a7rOhTNjPqYieEC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__10_Apr_2012_14_55_46_+1000_+a7rOhTNjPqYieEC
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20120405:

New trees: sh-current, sh

The tile tree gained conflicts against Linus' tree.

The net-next tree lost its build failure.

The wireless-next tree gained a conflict against the net-next tree.

The trivial tree lost its conflict.

The tty tree gained a build failure so I used the version from
next-20120405.

The pinctrl tree still had its build failure so I used the version from
next-20120403.

The akpm tree lost several patches that turned up in Linus' tree.

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

We are up to 186 trees (counting Linus' and 26 trees of patches pending
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
Merging origin/master (0034102 Linux 3.4-rc2)
Merging fixes/master (b1a808f Merge branch 'for-next' of git://gitorious.or=
g/kernel-hsi/kernel-hsi)
Merging kbuild-current/rc-fixes (0eb043d Subject: [PATCH] tags.sh: Add miss=
ing quotes)
Merging arm-current/fixes (6d00889 ARM: fix more fallout from 9f97da78bf (D=
isintegrate asm/system.h for ARM))
Merging m68k-current/for-linus (450aed7 m68k/q40: Add missing platform chec=
k before registering platform devices)
Merging powerpc-merge/merge (9b218f6 powerpc/eeh: Fix use of set_current_st=
ate() in eeh event handling set_current_state() wart)
Merging sparc/master (ca6f327 serial/sunzilog: fix keyboard on SUN SPARCsta=
tion)
Merging scsi-rc-fixes/master (41f8ad7 [SCSI] osd_uld: Bump MAX_OSD_DEVICES =
from 64 to 1,048,576)
Merging net/master (f68e556 Make the "word-at-a-time" helper functions more=
 commonly usable)
Merging sound-current/for-linus (c38f62b Merge tag 'asoc-3.4' of git://git.=
kernel.org/pub/scm/linux/kernel/git/broonie/sound into for-linus)
Merging pci-current/for-linus (314489b Merge tag 'fixes-for-linus' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc)
Merging wireless/master (7ab2485b net/wireless/wext-core.c: add missing kfr=
ee)
Merging driver-core.current/driver-core-linus (70fa4a6 sysfs: Update the na=
me hash for an entry after changing the namespace)
Merging tty.current/tty-linus (11bbd5b pch_uart: Add Kontron COMe-mTT10 uar=
t clock quirk)
Merging usb.current/usb-linus (b446b96 UHCI: hub_status_data should indicat=
e if ports are resuming)
Merging staging.current/staging-linus (0034102 Linux 3.4-rc2)
Merging char-misc.current/char-misc-linus (0034102 Linux 3.4-rc2)
Merging cpufreq-current/fixes (6139b65 Merge branch 'for_3.4/cpufreq' of gi=
t://git.kernel.org/pub/scm/linux/kernel/git/khilman/linux-omap-pm into fixe=
s)
Merging input-current/for-linus (d626dad Input: sentelic - filter taps in a=
bsolute mode)
Merging md-current/for-linus (5020ad7 md/raid1,raid10: don't compare excess=
 byte during consistency check.)
Merging audit-current/for-linus (c158a35 audit: no leading space in audit_l=
og_d_path prefix)
Merging crypto-current/master (511d63c crypto: talitos - properly lock acce=
ss to global talitos registers)
Merging ide/master (0ab3d8b cy82c693: fix PCI device selection)
Merging dwmw2/master (244dc4e Merge git://git.infradead.org/users/dwmw2/ran=
dom-2.6)
Merging sh-current/sh-fixes-for-linus (691c01c arch/sh/drivers/dma/{dma-g2,=
dmabrg}.c: ensure arguments to request_irq and free_irq are compatible)
Merging irqdomain-current/irqdomain/merge (d4886bc irqdomain/powerpc: updat=
ed defconfigs for VIRQ_DEBUG rename)
Merging devicetree-current/devicetree/merge (31134ef dt: Linux DT usage mod=
el documentation)
Merging spi-current/spi/merge (cc4d22a spi/imx: mark base member in spi_imx=
_data as __iomem)
Merging gpio-current/gpio/merge (d7ce1db gpio/sodaville: Convert sodaville =
driver to new irqdomain API)
Merging arm/for-next (6d00889 ARM: fix more fallout from 9f97da78bf (Disint=
egrate asm/system.h for ARM))
Merging arm-perf/for-next/perf (c16fa4f Linux 3.3)
Merging davinci/davinci-next (fe0d422 Linux 3.0-rc6)
Merging samsung/next-samsung (9edb240 ARM: H1940/RX1950: Change default LED=
 triggers)
Merging s5p/for-next (e62a334 Merge branch 'v3.4-cpufreq-exynos-fixes' into=
 for-next)
Merging tegra/for-next (4a3398e gpio: tegra: Iterate over the correct numbe=
r of banks)
Merging xilinx/arm-next (b85a3ef ARM: Xilinx: Adding Xilinx board support)
Merging blackfin/for-linus (35fe2e7 blackfin: update defconfig for bf527-ez=
kit)
Merging c6x/for-linux-next (fde7d90 Linux 3.3-rc7)
Merging cris/for-next (4d5914d cris/mm/fault.c: Port OOM changes to do_page=
_fault)
Merging quilt/hexagon (110b372 Remove unneeded include of version.h from ar=
ch/hexagon/include/asm/spinlock_types.h)
CONFLICT (content): Merge conflict in arch/hexagon/Kconfig
Merging ia64/next (16f2634 [IA64] Normalize return value of chip->irq_set_a=
ffinity() method)
Merging m68k/for-next (25d0b90 scsi/atari: Make more functions static)
Merging m68knommu/for-next (de6bd4f m68k: merge the MMU and non-MMU signal.=
c code)
Merging microblaze/next (0dd90aa microblaze: Fix ret_from_fork declaration)
Merging mips/mips-for-linux-next (2fea377 Merge branch 'fixes-for-linus' in=
to mips-for-linux-next)
Merging openrisc/for-upstream (c88e692 asm-generic: add linux/types.h to cm=
pxchg.h)
Merging parisc/for-next (c60dc74 Merge branch 'fixes' into for-next)
Merging powerpc/next (0195c00 Merge tag 'split-asm_system_h-for-linus-20120=
328' of git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-asm_sy=
stem)
Merging 4xx/next (b5594a7 powerpc/44x: Add additional device support for AP=
M821xx SoC and Bluestone board)
Merging mpc5xxx/next (7b6bb64 powerpc/5200: convert mpc5200 to use of_platf=
orm_populate())
Merging galak/next (fa1b42b powerpc/qe: Update the SNUM table for MPC8569 R=
ev2.0)
Merging s390/features (b7918da [S390] update default configuration)
Merging sh/sh-latest (bbb4ce5 serial: sh-sci: modify sci_break_ctl())
Merging sparc-next/master (e9b57cc sparc: Use vsprintf extention %pf with b=
uiltin_return_address)
Merging tile/master (a6a18aa arch/tile: add descriptive text if the kernel =
reports a bad trap)
CONFLICT (content): Merge conflict in arch/tile/kernel/stack.c
CONFLICT (content): Merge conflict in arch/tile/kernel/single_step.c
Merging unicore32/unicore32 (0994695 Merge branch 'akpm' (aka "Andrew's pat=
ch-bomb, take two"))
Merging ceph/master (c666601 rbd: move snap_rwsem to the device, rename to =
header_rwsem)
Merging cifs/master (f68e556 Make the "word-at-a-time" helper functions mor=
e commonly usable)
Merging configfs/linux-next (b930c26 Merge branch 'for-linus' of git://git.=
kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (6cfd4b4 ecryptfs: remove the second argument of k[un=
]map_atomic())
CONFLICT (content): Merge conflict in fs/ecryptfs/ecryptfs_kernel.h
Merging ext3/for_next (c2d9fae ext2: Remove s_dirt handling)
Merging ext4/dev (9d547c3 vfs: remove unused superblock helpers)
Merging fuse/for-next (4273b79 fuse: O_DIRECT support for files)
Merging gfs2/master (779ac58 GFS2: Make sure rindex is uptodate before star=
ting transactions)
Merging logfs/master (cd8bfa9 logfs: initialize the number of iovecs in bio)
Merging nfs/linux-next (f30fb85 NFS: check for req=3D=3DNULL in nfs_try_to_=
update_request cleanup)
Merging nfsd/nfsd-next (797a9d7 nfsd: only register cld pipe notifier when =
CONFIG_NFSD_V4 is enabled)
Merging ocfs2/linux-next (9392557 ocfs2: avoid unaligned access to dqc_bitm=
ap)
Merging omfs/for-next (976d167 Linux 3.1-rc9)
Merging squashfs/master (4b0180a Squashfs: add mount time sanity check for =
block_size and block_log match)
Merging v9fs/for-next (01627d9 Merge branch 'drm-fixes-intel' of git://peop=
le.freedesktop.org/~airlied/linux)
Merging ubifs/linux-next (dd775ae Linux 3.4-rc1)
Merging xfs/for-next (5a5881c xfs: add lots of attribute trace points)
Merging vfs/for-next (07c0c5d ext4: initialization of ext4_li_mtx needs to =
be done earlier)
Merging pci/next (314489b Merge tag 'fixes-for-linus' of git://git.kernel.o=
rg/pub/scm/linux/kernel/git/arm/arm-soc)
Merging hid/for-next (2c8cee0 Merge branches 'logitech', 'wacom' and 'walto=
p' into for-next)
Merging quilt/i2c (85bb1a8 i2c-dev: Add support for I2C_M_RECV_LEN)
Merging bjdooks-i2c/next-i2c (fc84fe1 Merge branch 'for_3.3/i2c/misc' of gi=
t://git.kernel.org/pub/scm/linux/kernel/git/khilman/linux-omap-pm into for-=
33/i2c/omap)
CONFLICT (content): Merge conflict in drivers/i2c/busses/i2c-omap.c
Merging i2c-embedded/i2c-embedded/for-next (bbceeee i2c-eg20t: Remove write=
-only variables)
Merging quilt/jdelvare-hwmon (e3a9568 hwmon: Add MCP3021 ADC driver)
Merging hwmon-staging/hwmon-next (e0367870 hwmon: use module_pci_driver)
Merging v4l-dvb/master (866c386 Merge /home/v4l/v4l/patchwork)
Merging kbuild/for-next (51cbc3e Merge branch 'kbuild/rc-fixes' into kbuild=
/for-next)
Merging kconfig/for-next (eae1c36 Merge branch 'kconfig/for-linus-2' into k=
config/for-next)
Merging libata/NEXT (b8cec3c pata_cmd64x: implement sff_irq_check() method)
Merging infiniband/for-next (dd775ae Linux 3.4-rc1)
Merging acpi/next (eeaab2d Merge branches 'idle-fix' and 'misc' into releas=
e)
Merging cpupowerutils/master (f166033 cpupower tools: add install target to=
 the debug tools' makefiles)
Merging ieee1394/for-next (19f8399 Merge branch 'iso-flush' into for-next)
Merging ubi/linux-next (cc83146 UBI: rename MOVE_CANCEL_BITFLIPS to MOVE_TA=
RGET_BITFLIPS)
Merging dlm/next (1b189b8 dlm: last element of dlm_local_addr[] never used)
Merging scsi/master (6993169 [SCSI] ipr: Driver version 2.5.3)
Merging target-updates/for-next (187e70a ib_srpt: Fix srpt_handle_cmd send_=
ioctx->ioctx_kref leak on exception)
Merging target-merge/for-next-merge (06de5ee tcm_qla2xxx: Add >=3D 24xx ser=
ies fabric module for target-core)
Merging ibft/linux-next (935a9fe ibft: Fix finding IBFT ACPI table on UEFI)
Merging isci/all (fbabacb Merge branches 'devel', 'rnc-devel' and 'fixes' i=
nto all)
Merging slave-dma/next (91ae1e3 dmaengine: mxs-dma: assign cookie in prepar=
e)
Merging dmaengine/next (a2bd114 netdma: adding alignment check for NETDMA o=
ps)
Merging net-next/master (2f6f9d6 fealnx: Remove unused local label 'out' in=
 netdev_open().)
Merging wireless-next/master (47107e8 iwlwifi: split POWER_PMI status bit)
CONFLICT (content): Merge conflict in drivers/net/wireless/iwlwifi/iwl-test=
mode.c
Merging bluetooth/master (30720c9 Bluetooth: Adds set_default function in L=
2CAP setup)
Merging mtd/master (7b0e67f mtd: docg3 add protection against concurrency)
Merging l2-mtd/master (711ab3a sh: Use the plat_nand default partition pars=
er)
Merging crypto/master (d788fec crypto, xor: Sanitize checksumming function =
selection output)
Merging sound/for-next (251d89d Merge branch 'for-linus' into for-next)
Merging sound-asoc/for-next (a8188c0 Merge branch 'for-3.5' into asoc-next)
Merging cpufreq/next (a7b422c provide disable_cpufreq() function to disable=
 the API.)
Merging quilt/rr (2a22b63 cpumask: remove old cpu_*_map.)
CONFLICT (content): Merge conflict in drivers/virtio/virtio_balloon.c
CONFLICT (content): Merge conflict in arch/arm/kernel/kprobes.c
Merging input/next (98a8413 Input: gameport - use module_gameport_driver)
Merging input-mt/for-next (7491f3d bcm5974: Add pointer and buttonpad prope=
rties)
Merging cgroup/for-next (48ddbe1 cgroup: make css->refcnt clearing on cgrou=
p removal optional)
Merging block/for-next (f52b69f Merge tag 'sh-for-linus' of git://github.co=
m/pmundt/linux-sh)
Merging quilt/device-mapper (4b63eba This device-mapper target creates a re=
ad-only device that transparently validates the data on one underlying devi=
ce against a pre-generated tree of cryptographic checksums stored on a seco=
nd device.)
Merging embedded/master (4744b43 embedded: fix vc_translate operator preced=
ence)
Merging firmware/master (6e03a20 firmware: speed up request_firmware(), v3)
Merging pcmcia/master (80af9e6 pcmcia at91_cf: fix raw gpio number usage)
Merging mmc/mmc-next (86ae21d mmc: omap_hsmmc: Cleanup use of cpu_is_* for =
debounce_clock)
Merging kgdb/kgdb-next (3751d3e x86,kgdb: Fix DEBUG_RODATA limitation using=
 text_poke())
Merging slab/for-next (b80b6c0 Merge branch 'slab/next' into for-next)
Merging uclinux/for-next (5e442a4 Revert "proc: fix races against execve() =
of /proc/PID/fd**")
Merging md/for-next (bee6cd3 md/raid10: add reshape support)
Merging mfd/for-next (b8589e2 gpio/twl: Add DT support to gpio-twl4030 driv=
er)
Merging battery/master (5cdd4d7 max17042_battery: Clean up interrupt handli=
ng)
Merging drm/drm-next (5466c7b drm/i915: use DDC_ADDR instead of hard-coding=
 it)
Merging fbdev/fbdev-next (688ec34 video: pxa3xx-gcu: Simplify the logic to =
exit while loop in pxa3xx_gcu_wait_idle)
Merging viafb/viafb-next (838ac78 viafb: avoid refresh and mode lookup in s=
et_par)
Merging omap_dss2/for-next (df01d53 OMAPDSS: APPLY: fix clearing shadow dir=
ty flag with manual update)
Merging regulator/for-next (c2cb39b Merge branch 'regulator-drivers' into r=
egulator-next)
$ git reset --hard HEAD^
Merging refs/next/20120405/regulator
Merging security/next (9ccf010 maintainers: update wiki url for the securit=
y subsystem)
Merging selinux/master (ecf093d SELinux: add default_type statements)
Merging lblnet/master (7e27d6e Linux 2.6.35-rc3)
Merging watchdog/master (0034102 Linux 3.4-rc2)
Merging dwmw2-iommu/master (c3b92c8 Linux 3.1)
Merging iommu/next (7de4730 Merge branches 'iommu/fixes', 'arm/tegra' and '=
x86/amd' into next)
Merging osd/linux-next (72749a2 exofs: Cap on the memcpy() size)
Merging jc_docs/docs-next (5c050fb docs: update the development process doc=
ument)
Merging trivial/for-next (e75d660 Merge branch 'master' into for-next)
Merging audit/for-next (dcd6c92 Linux 3.3-rc1)
Merging pm/linux-next (c4772d1 PM / QoS: add pm_qos_update_request_timeout(=
) API)
Merging apm/for-next (f283d22 APM: fix deadlock in APM_IOC_SUSPEND ioctl)
Merging fsnotify/for-next (1aec9c0 inotify: automatically restart syscalls)
Merging edac/linux_next (a4b4be3 edac: rename channel_info to rank_info)
Merging edac-amd/for-next (305f1c3 Merge branch '3.3-pci_device_id' into ed=
ac-for-next)
Merging devicetree/devicetree/next (0f22dd3 of: Only compile OF_DYNAMIC on =
PowerPC pseries and iseries)
Merging spi/spi/next (3d414f3 Merge branch 'spi' of git://gitorious.org/lin=
us-tree/linus-tree into spi/next)
Merging tip/auto-latest (911bcb2 Merge branch 'linus')
CONFLICT (content): Merge conflict in Documentation/feature-removal-schedul=
e.txt
Merging rcu/rcu/next (1cc8596 rcu: Stop spurious warnings from synchronize_=
sched_expedited)
Merging cputime/cputime (c3e0ef9 [S390] fix cputime overflow in uptime_proc=
_show)
Merging uprobes/for-next (0326f5a uprobes/core: Handle breakpoint and singl=
estep exceptions)
Merging kmemleak/kmemleak (d65b4e9 Linux 3.3-rc3)
Merging kvm/linux-next (e087592 KVM: Resolve RCU vs. async page fault probl=
em)
Merging oprofile/for-next (c16fa4f Linux 3.3)
Merging xen/upstream/xen (59e9a6b Merge branch 'upstream/ticketlock-cleanup=
' into upstream/xen)
CONFLICT (content): Merge conflict in arch/x86/include/asm/cmpxchg.h
Merging xen-two/linux-next (2efe928 Merge branch 'stable/for-linus-3.4' int=
o linux-next)
CONFLICT (content): Merge conflict in arch/x86/kernel/apic/io_apic.c
CONFLICT (content): Merge conflict in arch/x86/include/asm/io_apic.h
Merging xen-pvhvm/linux-next (b056b6a xen: suspend: remove xen_hvm_suspend)
Merging percpu/for-next (adb7950 percpu: fix __this_cpu_{sub,inc,dec}_retur=
n() definition)
Merging workqueues/for-next (e06ffa1 workqueue: use percpu allocator for cw=
q on UP)
Merging drivers-x86/linux-next (86924de acer-wmi: add quirk table for video=
 backlight vendor mode)
Merging hwpoison/hwpoison (46e387b Merge branch 'hwpoison-hugepages' into h=
wpoison)
Merging sysctl/master (4e474a0 sysctl: protect poll() in entries that may g=
o away)
Merging regmap/for-next (41326c1 Merge branch 'regmap-mmio' into regmap-nex=
t)
Merging hsi/for-next (43139a6 HSI: hsi_char: Update ioctl-number.txt)
Merging driver-core/driver-core-next (ecf1948 w1: fix slave driver registra=
tion error message)
Merging tty/tty-next (c56a00a tty: hold lock across tty buffer finding and =
buffer filling)
$ git reset --hard HEAD^
Merging refs/next/20120405/tty
Merging usb/usb-next (0034102 Linux 3.4-rc2)
Merging staging/staging-next (0034102 Linux 3.4-rc2)
Merging char-misc/char-misc-next (0034102 Linux 3.4-rc2)
Merging tmem/linux-next (9c9fc31 Merge commit 'e22057c8599373e5caef0bc42bdb=
95d2a361ab0d' into linux-next)
Merging writeback/writeback-for-next (697e6fe writeback: Remove outdated co=
mment)
Merging arm-dt/devicetree/arm-next (ede338f dt: add documentation of ARM dt=
 boot interface)
Merging hwspinlock/linux-next (8b37fcf hwspinlock: add MAINTAINERS entries)
Merging pinctrl/for-next (8cfa831 pinctrl: replace list_*() with get_*_coun=
t())
$ git reset --hard HEAD^
Merging refs/next/20120403/pinctrl
Merging moduleh/for-sfr (ed93e94 ia64: populate the cmpxchg header with app=
ropriate code)
Merging vhost/linux-next (437578b virtio-pci: switch to PM ops macro to ini=
tialise PM functions)
Merging kmap_atomic/kmap_atomic (317b6e1 feature-removal-schedule.txt: sche=
dule the deprecated form of kmap_atomic() for removal)
Merging modem-shm/for-next (3cff1cc caif_shm: Add CAIF driver for Shared me=
mory for M7400)
Merging memblock/memblock-kill-early_node_map (7bd0b0f memblock: Reimplemen=
t memblock allocation using reverse free area iterator)
Merging remoteproc/for-next (e12bc14 remoteproc: s/big switch/lookup table/)
Merging irqdomain/irqdomain/next (409a6f6 Merge branch 'irqdomain-for-grant=
' of git://sources.calxeda.com/kernel/linux into irqdomain/next)
CONFLICT (content): Merge conflict in arch/arm/Kconfig
Merging gpio/gpio/next (c77c8a6 gpio/ep93xx: Remove unused inline function =
and useless pr_err message)
Merging arm-soc/for-next (ce9f68e Merge branch 'fixes' into for-next)
Merging kvmtool/master (63091b3 kvm tools: Drop unnecessary headers in barr=
ier.h)
Merging dma-mapping/dma-mapping-next (5d32c88 Merge branch 'akpm' (Andrew's=
 patch-bomb))
Merging dma-buf/for-next (9f28056 dma-buf: Correct dummy function declarati=
ons.)
CONFLICT (content): Merge conflict in include/linux/dma-buf.h
Merging ktest/for-next (648a182 ktest: Allow a test to override REBOOT_ON_S=
UCCESS)
Merging cpuidle-cons/cpuidle_consol_pull (203b52e SH: shmobile: Consolidate=
 time keeping and irq enable)
CONFLICT (content): Merge conflict in include/linux/cpuidle.h
CONFLICT (content): Merge conflict in drivers/cpuidle/cpuidle.c
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/cpuidle.c
CONFLICT (content): Merge conflict in arch/arm/mach-davinci/cpuidle.c
CONFLICT (content): Merge conflict in arch/arm/mach-at91/cpuidle.c
CONFLICT (add/add): Merge conflict in arch/arm/include/asm/cpuidle.h
Merging scsi-post-merge/merge-base:master ()
$ git checkout akpm
Applying: acerhdf: add support for Aspire 1410 BIOS v1.3314
Applying: acerhdf: add support for new hardware
Applying: acerhdf: lowered default temp fanon/fanoff values
Applying: arch/x86/platform/iris/iris.c: register a platform device and a p=
latform driver
Applying: intel_mid_powerbtn: mark irq as IRQF_NO_SUSPEND
Applying: drivers/xen/Kconfig: fix Kconfig layout
Applying: arch/arm/mach-ux500/mbox-db5500.c: world-writable sysfs fifo file
Applying: avr32: don't mask signals in the error path
Applying: avr32: use set_current_blocked() in handle_signal/sys_rt_sigreturn
Applying: avr32: use block_sigmask()
Applying: m32r: use set_current_blocked() and block_sigmask()
Applying: m68k: use set_current_blocked() and block_sigmask()
Applying: mn10300: use set_current_blocked() and block_sigmask()
Applying: cris: use set_current_blocked() and block_sigmask()
Applying: cris: select GENERIC_ATOMIC64
Applying: x86: use this_cpu_xxx to replace percpu_xxx funcs
Applying: x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs-fix
Applying: x86: change percpu_read_stable() to this_cpu_read_stable()
Applying: net: use this_cpu_xxx replace percpu_xxx funcs
Applying: percpu: remove percpu_xxx() functions
Applying: percpu-remove-percpu_xxx-functions-fix
Applying: ia64: use set_current_blocked() and block_sigmask()
Applying: microblaze: don't reimplement force_sigsegv()
Applying: microblaze: no need to reset handler if SA_ONESHOT
Applying: microblaze: fix signal masking
Applying: microblaze: use set_current_blocked() and block_sigmask()
Applying: MIPS: use set_current_blocked() and block_sigmask()
Applying: score: don't mask signals if we fail to setup signal stack
Applying: score: use set_current_blocked() and block_sigmask()
Applying: h8300: use set_current_blocked() and block_sigmask()
Applying: unicore32: use block_sigmask()
Applying: blackfin: use set_current_blocked() and block_sigmask()
Applying: ocfs2: use find_last_bit()
Applying: ocfs2: use bitmap_weight()
Applying: parisc: use set_current_blocked() and block_sigmask()
Applying: vfs: increment iversion when a file is truncated
Applying: fs: symlink restrictions on sticky directories
Applying: fs: hardlink creation restrictions
Applying: brlocks/lglocks: cleanups
Applying: mm/memory_failure: let the compiler add the function name
Applying: mm: fix page-faults detection in swap-token logic
Applying: mm: add extra free kbytes tunable
Applying: mm-add-extra-free-kbytes-tunable-update
Applying: mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes
Applying: memcg: fix/change behavior of shared anon at moving task
Applying: memcg swap: mem_cgroup_move_swap_account never needs fixup
Applying: memcg swap: use mem_cgroup_uncharge_swap()
Applying: mm/memcg: scanning_global_lru means mem_cgroup_disabled
Applying: mm/memcg: move reclaim_stat into lruvec
Applying: mm: push lru index into shrink_[in]active_list()
Applying: mm-push-lru-index-into-shrink_active_list-fix
Applying: mm: mark mm-inline functions as __always_inline
Applying: mm: remove lru type checks from __isolate_lru_page()
Applying: mm/memcg: kill mem_cgroup_lru_del()
Applying: mm/memcg: use vm_swappiness from target memory cgroup
Applying: security/keys/keyctl.c: suppress memory allocation failure warning
Applying: frv: use set_current_blocked() and block_sigmask()
Applying: um/kernel/trap.c: port OOM changes to handle_page_fault()
Applying: block: use lockdep_assert_held() for queue locking
Applying: sgi-xp: use lockdep_assert_held()
Applying: drivers/scsi/aha152x.c: remove broken usage of spin_is_locked()
Applying: XFS: fix lock ASSERT on UP
Applying: mm/huge_memory.c: use lockdep_assert_held()
Applying: futex: use lockdep_assert_held() for lock checking
Applying: drivers/net/irda/sir_dev.c: remove spin_is_locked()
Applying: drivers/net/ethernet/smsc/smsc911x.h: use lockdep_assert_held() i=
nstead of home grown buggy construct
Applying: spinlocks.txt: add a discussion on why spin_is_locked() is bad
Applying: spinlockstxt-add-a-discussion-on-why-spin_is_locked-is-bad-fix
Applying: include/linux/spinlock.h: add a kerneldoc comment to spin_is_lock=
ed() that discourages its use
Applying: checkpatch: check for spin_is_locked()
Applying: vsprintf: further optimize decimal conversion
Applying: vsprintf-further-optimize-decimal-conversion-v2
Applying: vsprintf-further-optimize-decimal-conversion-checkpatch-fixes
Applying: leds: add LED driver for lm3556 chip
Applying: leds-add-led-driver-for-lm3556-chip-fix-2
Applying: leds-add-led-driver-for-lm3556-chip-checkpatch-fixes
Applying: leds-add-led-driver-for-lm3556-chip-fix
Applying: checkpatch: suggest pr_<level> over printk(KERN_<LEVEL>
Applying: rtc/spear: add Device Tree probing capability
Applying: kmod: unexport call_usermodehelper_freeinfo()
Applying: kmod: convert two call sites to call_usermodehelper_fns()
Applying: kmod: move call_usermodehelper_fns() to .c file and unexport all =
it's helpers
Applying: kmod: avoid deadlock from recursive kmod call
Applying: ipc/sem.c: alternatives to preempt_disable()
Applying: rapidio: add DMA engine support for RIO data transfers
Applying: rapidio/tsi721: add DMA engine support
Applying: sysctl: make kernel.ns_last_pid control dependent on CHECKPOINT_R=
ESTORE
Applying: fs, proc: introduce /proc/<pid>/task/<tid>/children entry
Applying: syscalls, x86: add __NR_kcmp syscall
Applying: c/r: procfs: add arg_start/end, env_start/end and exit_code membe=
rs to /proc/$pid/stat
Applying: c/r: prctl: extend PR_SET_MM to set up more mm_struct entries
Applying: c/r: prctl: add ability to set new mm_struct::exe_file
Applying: c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-v2
Applying: c/r: prctl: add ability to get clear_tid_address
Applying: c-r-prctl-add-ability-to-get-clear_tid_address-fix
Applying: ramoops: use pstore interface
Applying: ramoops: fix printk format warnings
Applying: notify_change(): check that i_mutex is held
Merging akpm (949e4ed notify_change(): check that i_mutex is held)

--Signature=_Tue__10_Apr_2012_14_55_46_+1000_+a7rOhTNjPqYieEC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPg71SAAoJEECxmPOUX5FE3dQP/jdoeIWGyMbqCLycjOuIHDu+
xzeWMEmr+swH7Va6bp0BmJYxyJdkTjc2ZVP4GgKqMH7NUEVIOiefaP9wK0/PV4td
OZFgLVMwzUUp5KS4gsb0Yp95pnXCgviup3bfmCE1tbpegLAO6W7yiLSi9UHMrQ4v
XjBWd6VShapZVyrW6oabk2D4TYGJBjSfRPAkJTVFP9Ip9VFhRBKd5BUMqQBBXO+E
nx0w+GFe5NkzDL7XTvrJvKQt3EfJT/udNmXZlIDMeq4NPv31Rg+kCuAwMa3shKC+
Wak9BsHgv/yJ32WugZq363kGm47Kn+9fj+IgTi/kp/83Tkz7XpYGZY5LMjcubOiE
dHvfIQyPUr3XR2iW/bOeeaIRAo8raR1bKG0S37UYhWbr9GjiJwDEF1Ez+3kiaGX7
oQd0k9jeaz1D5WzAEBvpWoZ9X64O4jVAfaXUQ9Pk1hS/Cs3nNweERkM9DmDWzRrL
qfBFa4hoRfb3pJP7rep01Nj/zFK1bf0a1EdqBIB3rarSDbVX6gkLV2ss5UKWMzed
5BZJ9PkRRSf66B7vN/SS9Mz5oxi0HtfcM4GhdJomLHBG4t24QI88XzYj4pIIEmea
mAqZ3Jw+Gx1M9GsXqdDQh7IWh4acA01jyOv57Yoipf9Ec0K/9pqXBWBPKwrdycgb
XLX00rOF54q057XK+pP7
=8F4g
-----END PGP SIGNATURE-----

--Signature=_Tue__10_Apr_2012_14_55_46_+1000_+a7rOhTNjPqYieEC--

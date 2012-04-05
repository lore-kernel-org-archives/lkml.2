Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932564Ab2DEDb4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 23:31:56 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:45861 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250Ab2DEDbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 23:31:53 -0400
Date: Thu, 5 Apr 2012 13:31:43 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Apr 5
Message-Id: <20120405133143.fc46503b5af6c370df4b2b3b@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__5_Apr_2012_13_31_43_+1000_Ue4xMdsoD.N7B7=f"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__5_Apr_2012_13_31_43_+1000_Ue4xMdsoD.N7B7=f
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

There will be no linux-next release until April 10 due to Easter holidays.

Changes since 20120404:

Tree removed:	docs

The net-next tree gained a build failure for which I applied a patch.

The pinctrl tree still had its build failure so I used the version from
next-20120403.

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
Merging origin/master (64ebe98 Merge tag 'pm-for-3.4-part-2' of git://git.k=
ernel.org/pub/scm/linux/kernel/git/rafael/linux-pm)
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
Merging net/master (03f2eec stmmac: re-add IFF_UNICAST_FLT for dwmac1000)
Merging sound-current/for-linus (c578ae0 ALSA: fix isa/opti9xx module param=
 type)
Merging pci-current/for-linus (4949be1 PCI: ignore pre-1.1 ASPM quirking wh=
en ASPM is disabled)
Merging wireless/master (de312db mac80211: fix oper channel timestamp updat=
ion)
Merging driver-core.current/driver-core-linus (dd775ae Linux 3.4-rc1)
Merging tty.current/tty-linus (dd775ae Linux 3.4-rc1)
Merging usb.current/usb-linus (dd775ae Linux 3.4-rc1)
Merging staging.current/staging-linus (dd775ae Linux 3.4-rc1)
Merging char-misc.current/char-misc-linus (dd775ae Linux 3.4-rc1)
Merging cpufreq-current/fixes (6139b65 Merge branch 'for_3.4/cpufreq' of gi=
t://git.kernel.org/pub/scm/linux/kernel/git/khilman/linux-omap-pm into fixe=
s)
Merging input-current/for-linus (d626dad Input: sentelic - filter taps in a=
bsolute mode)
Merging md-current/for-linus (5020ad7 md/raid1,raid10: don't compare excess=
 byte during consistency check.)
Merging audit-current/for-linus (c158a35 audit: no leading space in audit_l=
og_d_path prefix)
Merging crypto-current/master (5219a53 crypto: user - Fix size of netlink d=
ump message)
Merging ide/master (0ab3d8b cy82c693: fix PCI device selection)
Merging dwmw2/master (244dc4e Merge git://git.infradead.org/users/dwmw2/ran=
dom-2.6)
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
Merging blackfin/for-linus (0172c0a blackfin: gpio: fix compile error if !C=
ONFIG_GPIOLIB)
Merging c6x/for-linux-next (fde7d90 Linux 3.3-rc7)
Merging cris/for-next (4d5914d cris/mm/fault.c: Port OOM changes to do_page=
_fault)
Merging quilt/hexagon (110b372 Remove unneeded include of version.h from ar=
ch/hexagon/include/asm/spinlock_types.h)
CONFLICT (content): Merge conflict in arch/hexagon/Kconfig
Merging ia64/next (16f2634 [IA64] Normalize return value of chip->irq_set_a=
ffinity() method)
Merging m68k/for-next (1a9268f scsi/atari: Make more functions static)
Merging m68knommu/for-next (de6bd4f m68k: merge the MMU and non-MMU signal.=
c code)
Merging microblaze/next (0dd90aa microblaze: Fix ret_from_fork declaration)
Merging mips/mips-for-linux-next (2fea377 Merge branch 'fixes-for-linus' in=
to mips-for-linux-next)
Merging openrisc/for-upstream (fa8d9d7 OpenRISC: Remove memory_start/end pr=
ototypes)
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
Merging sparc-next/master (e9b57cc sparc: Use vsprintf extention %pf with b=
uiltin_return_address)
Merging tile/master (a6a18aa arch/tile: add descriptive text if the kernel =
reports a bad trap)
Merging unicore32/unicore32 (0994695 Merge branch 'akpm' (aka "Andrew's pat=
ch-bomb, take two"))
Merging ceph/master (c666601 rbd: move snap_rwsem to the device, rename to =
header_rwsem)
Merging cifs/master (e4b41fb Fix UNC parsing on mount)
Merging configfs/linux-next (b930c26 Merge branch 'for-linus' of git://git.=
kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (6cfd4b4 ecryptfs: remove the second argument of k[un=
]map_atomic())
CONFLICT (content): Merge conflict in fs/ecryptfs/ecryptfs_kernel.h
Merging ext3/for_next (c2d9fae ext2: Remove s_dirt handling)
Merging ext4/dev (9d547c3 vfs: remove unused superblock helpers)
Merging fuse/for-next (4273b79 fuse: O_DIRECT support for files)
Merging gfs2/master (dfa8511 GFS2: use depends instead of select in kconfig)
Merging logfs/master (cd8bfa9 logfs: initialize the number of iovecs in bio)
Merging nfs/linux-next (01627d9 Merge branch 'drm-fixes-intel' of git://peo=
ple.freedesktop.org/~airlied/linux)
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
Merging pci/linux-next (1488d51 PCI: Bjorn gets PCI hotplug too)
Merging hid/for-next (2c8cee0 Merge branches 'logitech', 'wacom' and 'walto=
p' into for-next)
Merging quilt/i2c (48a4675 Merge tag 'sound-3.4' of git://git.kernel.org/pu=
b/scm/linux/kernel/git/tiwai/sound)
Merging bjdooks-i2c/next-i2c (fc84fe1 Merge branch 'for_3.3/i2c/misc' of gi=
t://git.kernel.org/pub/scm/linux/kernel/git/khilman/linux-omap-pm into for-=
33/i2c/omap)
CONFLICT (content): Merge conflict in drivers/i2c/busses/i2c-omap.c
Merging i2c-embedded/i2c-embedded/for-next (bbceeee i2c-eg20t: Remove write=
-only variables)
Merging quilt/jdelvare-hwmon (e3a9568 hwmon: Add MCP3021 ADC driver)
Merging hwmon-staging/hwmon-next (e0367870 hwmon: use module_pci_driver)
Merging v4l-dvb/master (2f6edcb Merge branch 'poll')
Merging kbuild/for-next (51cbc3e Merge branch 'kbuild/rc-fixes' into kbuild=
/for-next)
Merging kconfig/for-next (eae1c36 Merge branch 'kconfig/for-linus-2' into k=
config/for-next)
Merging libata/NEXT (b8cec3c pata_cmd64x: implement sff_irq_check() method)
Merging infiniband/for-next (dd775ae Linux 3.4-rc1)
Merging acpi/next (d326f44 Merge branch 'tboot' into release)
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
Merging slave-dma/next (dd775ae Linux 3.4-rc1)
Merging dmaengine/next (3d9ea9e iop-adma: Corrected array overflow in RAID6=
 Xscale(R) test.)
Merging net-next/master (bd85661 stmmac: update the driver version March 20=
12)
Merging wireless-next/master (8a78335 usbnet: consider device busy at each =
recieved packet)
Merging bluetooth/master (e027b5c Bluetooth: Send correct address type for =
LTK)
Merging mtd/master (7b0e67f mtd: docg3 add protection against concurrency)
Merging l2-mtd/master (711ab3a sh: Use the plat_nand default partition pars=
er)
Merging crypto/master (a0ea0f6 crypto: caam - add backward compatible strin=
g sec4.0)
Merging sound/for-next (c81486a Merge branch 'for-linus' into for-next)
Merging sound-asoc/for-next (16bf8c8 Merge branches 'for-3.4' and 'for-3.5'=
 into asoc-next)
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
Merging mmc/mmc-next (e7f9850 mmc: sdhci-dove: Fix compile error by includi=
ng module.h)
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
Merging fbdev/fbdev-next (6bff98b Revert "video:uvesafb: Fix oops that uves=
afb try to execute NX-protected page")
Merging viafb/viafb-next (838ac78 viafb: avoid refresh and mode lookup in s=
et_par)
Merging omap_dss2/for-next (df01d53 OMAPDSS: APPLY: fix clearing shadow dir=
ty flag with manual update)
Merging regulator/for-next (86f8c00 Merge branch 'regulator-drivers' into r=
egulator-next)
Merging security/next (09f61cd Merge branch 'for-security' of git://git.ker=
nel.org/pub/scm/linux/kernel/git/jj/linux-apparmor into next)
Merging selinux/master (ecf093d SELinux: add default_type statements)
Merging lblnet/master (7e27d6e Linux 2.6.35-rc3)
Merging watchdog/master (dd775ae Linux 3.4-rc1)
Merging dwmw2-iommu/master (c3b92c8 Linux 3.1)
Merging iommu/next (7de4730 Merge branches 'iommu/fixes', 'arm/tegra' and '=
x86/amd' into next)
Merging osd/linux-next (72749a2 exofs: Cap on the memcpy() size)
Merging jc_docs/docs-next (5c050fb docs: update the development process doc=
ument)
Merging trivial/for-next (a03abdc w1: fix slave driver registration error m=
essage)
CONFLICT (content): Merge conflict in drivers/net/ethernet/realtek/r8169.c
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
Merging kvm/linux-next (5cd512a Merge tag 'powerpc-fixes' of git://github.c=
om/paulusmack/linux into kvm-updates/3.4)
Merging oprofile/for-next (c16fa4f Linux 3.3)
Merging xen/upstream/xen (59e9a6b Merge branch 'upstream/ticketlock-cleanup=
' into upstream/xen)
CONFLICT (content): Merge conflict in arch/x86/include/asm/cmpxchg.h
Merging xen-two/linux-next (2faaa4d Merge branch 'stable/for-linus-3.4' int=
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
Merging regmap/for-next (3a05a70 Merge tag 'topic/mmio' into regmap-next)
Merging hsi/for-next (43139a6 HSI: hsi_char: Update ioctl-number.txt)
Merging driver-core/driver-core-next (dd775ae Linux 3.4-rc1)
Merging tty/tty-next (dd775ae Linux 3.4-rc1)
Merging usb/usb-next (dd775ae Linux 3.4-rc1)
Merging staging/staging-next (dd775ae Linux 3.4-rc1)
Merging char-misc/char-misc-next (dd775ae Linux 3.4-rc1)
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
Merging arm-soc/for-next (4def39c Merge branch 'fixes' into for-next)
Merging kvmtool/master (dcf1396 tools/kvm: Fix compilation fallout from sys=
tem.h split-up)
Merging dma-mapping/dma-mapping-next (64d70fe common: DMA-mapping: add NON-=
CONSISTENT attribute)
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
Applying: proc: fix mount -t proc -o AAA
Applying: sysrq: use SEND_SIG_FORCED instead of force_sig()
Applying: fs/xattr.c: suppress page allocation failure warnings from sys_li=
stxattr()
Applying: fs/xattr.c:listxattr(): fall back to vmalloc() if kmalloc() failed
Applying: fs-xattrc-listxattr-fall-back-to-vmalloc-if-kmalloc-failed-fix
Applying: fs/xattr.c:setxattr(): improve handling of allocation failures
Applying: drivers/rtc/rtc-88pm860x.c: fix rtc irq enable callback
Applying: hugetlbfs: remove unregister_filesystem() when initializing module
Applying: libfs: add simple_open()
Applying: scripts/coccinelle/api/simple_open.cocci: semantic patch for simp=
le_open()
Applying: simple_open: automatically convert to simple_open()
Applying: simple_open-automatically-convert-to-simple_open-checkpatch-fixes
Applying: alpha: use set_current_blocked() and block_sigmask()
Applying: MAINTAINERS: fix REMOTEPROC F: typo
Applying: MAINTAINERS: add entry for sparse checker
Applying: C6X: use set_current_blocked() and block_sigmask()
Applying: MAINTAINERS: update git url for ACPI
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
Applying: syscalls-x86-add-__nr_kcmp-syscall-v8-fix
Applying: syscalls-x86-add-__nr_kcmp-syscall-v8-fix-2
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
Merging akpm (c2f5948 notify_change(): check that i_mutex is held)
Applying: stmmac: hack to make it build

--Signature=_Thu__5_Apr_2012_13_31_43_+1000_Ue4xMdsoD.N7B7=f
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPfRIfAAoJEECxmPOUX5FEWLoP/jaSRHngO7F/cg0PdstNTsjH
Ex0l41bVF6wStTyR+pMCmvffV+ILB5NGiLqnD3Jd00W1DYjUXDAlbD57zl8E8Jjk
czJeoU7qYzz78T0TjQkt4m9TLjpLzcV9KggnBCDGhjP7c7PeJudvvzZ6Ouz+8rlF
J7kL76e+M7SnI6cShC/aCG5j5TEcxYq5+MSH7a+NdRtfyqIxKI0UgHzNMi2RAZAG
a9DsU3kJ2m1ExEgb90FitK5ISAvEd+r3C0VSwdKdQ6k+AslZnHUfiqlkdCwBHErc
nZGnYuNUjUo84X6UsDjbXNLGg/cdmj5QNnd+jB8waSb3y/VdfgnqtSdCfMGtkrJt
u75EjpTAJihiSLeggplDu/XxQpZxULMRAADpX9s/ktOXFqCn5AWspDUyDA4yP2LN
L1WXIOrL65vPmJOKhd1i/d1DwkAnQZQhE+OBbRsokkUs7O+zxlgi6w6C91AdM97r
S6ZOUq8MS7ViT+FAePp6fNZ9Tudk2dZ0OYp4Z/fFt1lU4bgOvRWQQR1Z4oHRozdK
QhyL4D+R3cozue7Apb2tMZRrrlx6Dv9KcqrQpH9q+OE6xLAO8iupN976P868BTqn
kB8tWiXbiyX1KCCzB4A0ZTF8HFWFAgka0ozEVhWdaYAHMVgsa2JFIdiW+EksWXhm
8/5RvVQ+n4WNNRigjN+H
=st6k
-----END PGP SIGNATURE-----

--Signature=_Thu__5_Apr_2012_13_31_43_+1000_Ue4xMdsoD.N7B7=f--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379Ab2KOHRy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 02:17:54 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:51858 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970Ab2KOHRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 02:17:49 -0500
Date: Thu, 15 Nov 2012 18:17:40 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <linux-next@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Linus <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next: Tree for Nov 15
Message-Id: <20121115181740.4fb08780f0b92149a5ed2ca4@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__15_Nov_2012_18_17_40_+1100_mKmBOhyO.pYwLOuO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__15_Nov_2012_18_17_40_+1100_mKmBOhyO.pYwLOuO
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

News: this one will be the last release until next-20121126 (which should
be just be after -rc7, I guess - assuming that Linus does not release
v3.7 before then).

Changes since 20121114:

The v4l-dvb tree still had its build failure so I used the version from
next-20121026.

The wireless-next tree gained a conflict against the wireless tree.

The spi tree gained a conflict against Linus' tree.

The arm-soc tree gained a conflict against the i2c-embedded tree.

The powerpc tree gained a conflict against the signal tree and a build
failure for which I applied a patch.

The akpm-current tree gained a conflict against the cgroup tree.

The akpm tree gained a conflict against the tip tree.

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

We are up to 210 trees (counting Linus' and 28 trees of patches pending
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
Merging origin/master (79e979e Merge branch 'release' of git://git.kernel.o=
rg/pub/scm/linux/kernel/git/lenb/linux)
Merging fixes/master (12250d8 Merge branch 'i2c-embedded/for-next' of git:/=
/git.pengutronix.de/git/wsa/linux)
Merging kbuild-current/rc-fixes (bad9955 menuconfig: Replace CIRCLEQ by lis=
t_head-style lists.)
Merging arm-current/fixes (2b6e204 ARM: 7572/1: proc-v6.S: fix comment)
Merging m68k-current/for-linus (8a745ee m68k: Wire up kcmp)
Merging powerpc-merge/merge (8c23f40 Merge git://git.kernel.org/pub/scm/vir=
t/kvm/kvm)
Merging sparc/master (b251f0f Merge git://git.kernel.org/pub/scm/linux/kern=
el/git/davem/net)
Merging net/master (1ba56fb vxlan: Update hard_header_len based on lowerdev=
 when instantiating VXLAN)
Merging sound-current/for-linus (10e4423 ALSA: usb-audio: Fix mutex deadloc=
k at disconnection)
Merging pci-current/for-linus (ff8e59b PCI/portdrv: Don't create hotplug sl=
ots unless port supports hotplug)
Merging wireless/master (d61f978 brcmfmac: fix typo in CONFIG_BRCMISCAN)
Merging driver-core.current/driver-core-linus (77b6706 Linux 3.7-rc5)
Merging tty.current/tty-linus (1838b8c tty: serial: max310x: Add terminatin=
g entry for spi_device_id table)
Merging usb.current/usb-linus (e592c5d Revert "USB/host: Cleanup unneccessa=
ry irq disable code")
Merging staging.current/staging-linus (d38e0e3 Revert "Staging: Android ala=
rm: IOCTL command encoding fix")
Merging char-misc.current/char-misc-linus (8f0d816 Linux 3.7-rc3)
Merging input-current/for-linus (40a8120 Input: MT - document new 'flags' a=
rgument of input_mt_init_slots())
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
Merging rr-fixes/fixes (237242b virtio: Don't access index after unregister=
.)
Merging asm-generic/master (9b04ebd asm-generic/io.h: remove asm/cacheflush=
.h include)
Merging arm/for-next (38fa68b Merge remote-tracking branch 'wildea/asids' i=
nto for-next)
Merging arm-perf/for-next/perf (ae0c7b2 Merge branch 'hw-breakpoint' into f=
or-next/perf)
Merging davinci/davinci-next (fe0d422 Linux 3.0-rc6)
Merging xilinx/arm-next (91dc985 ARM: zynq: add clk binding support to the =
ttc)
Merging arm64/upstream (908816d Merge branch 'execve' into upstream)
Merging blackfin/for-linus (9d84601 Blackfin: dpmc: use module_platform_dri=
ver macro)
Merging c6x/for-linux-next (fbdd63d UAPI: (Scripted) Disintegrate arch/c6x/=
include/asm)
Merging cris/for-next (eacb25c UAPI: Fix up empty files in arch/cris/)
Merging hexagon/linux-next (e1858b2 Hexagon: Copyright marking changes)
Merging ia64/next (773be5d Merge branch 'pstore-mevent' into next)
Merging m68k/for-next (5fec45a m68k/sun3: Fix instruction faults)
Merging m68knommu/for-next (e561d37 m68k: fix unused variable warning in me=
mpcy.c)
Applying: m68k: fix up for UAPI changes
Merging microblaze/next (f229605 microblaze: dma-mapping: Support debug_dma=
_mapping_error)
Merging mips/mips-for-linux-next (b4d04a1 Merge branch 'current/for-linus' =
into mips-for-linux-next)
Merging openrisc/for-upstream (634bd40 openrisc: use kbuild.h instead of de=
fining macros in asm-offset.c)
Merging parisc/for-next (559fd14 Merge tag 'disintegrate-parisc-20121016' i=
nto for-next)
Merging s390/features (2423b9d s390/topology: cleanup topology code)
Merging sh/sh-latest (0dd4d5c sh: Fix up more fallout from pointless ARM __=
iomem churn.)
Merging sparc-next/master (43c422e apparmor: fix apparmor OOPS in audit_log=
_untrustedstring+0x1c/0x40)
Merging tile/master (ddffeb8 Linux 3.7-rc1)
Merging unicore32/unicore32 (c284464 arch/unicore32: remove CONFIG_EXPERIME=
NTAL)
Merging xtensa/for_next (d83ac75 xtensa: add xtavnet DTS)
Merging btrfs/next (c37b2b6 Btrfs: do not bug when we fail to commit the tr=
ansaction)
Merging ceph/master (3515297 rbd: activate v2 image support)
Merging cifs/for-next (5004f80 cifs: fix SID binary to string conversion)
Merging configfs/linux-next (b930c26 Merge branch 'for-linus' of git://git.=
kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (e4bc652 eCryptfs: Avoid unnecessary disk read and da=
ta decryption during writing)
Merging ext3/for_next (6c29c50 quota: Silence warning about PRJQUOTA not be=
ing handled in need_print_warning())
Merging ext4/dev (989e94e ext4: init pagevec in ext4_da_block_invalidatepag=
es)
Merging fuse/for-next (8888785 fuse: remove unused variable in fuse_try_mov=
e_page())
Merging gfs2/master (fb6791d GFS2: skip dlm_unlock calls in unmount)
Merging jfs/jfs-next (4e7a4b0 jfs: Fix FITRIM argument handling)
Merging logfs/master (ab2ec19 logfs: fix possible memory leak in logfs_mtd_=
can_write_buf())
Merging nfs/linux-next (8ede994 Merge branch 'bugfixes' into linux-next)
Merging nfsd/nfsd-next (2b4cf66 nfsd4: get_backchannel_cred should be stati=
c)
Merging ocfs2/linux-next (4538df6 ocfs2: Don't spam on -EDQUOT.)
Merging omfs/for-next (976d167 Linux 3.1-rc9)
Merging squashfs/master (4b0180a Squashfs: add mount time sanity check for =
block_size and block_log match)
Merging v9fs/for-next (552aad0 9P: Fix race between p9_write_work() and p9_=
fd_request())
Merging ubifs/linux-next (a28ad42 UBIFS: fix mounting problems after power =
cuts)
Merging xfs/for-next (fb59581 xfs: remove xfs_flushinval_pages)
Merging vfs/for-next (a736427 missing const in alpha callers of do_mount())
Merging pci/next (7db78a9 Merge branch 'pci/misc' into next)
Merging hid/for-next (f61aaf1 Merge branch 'for-3.8/roccat' into for-next)
Merging i2c/master (3d84243 i2c: Mention functionality flags in SMBus proto=
col documentation)
Merging i2c-embedded/i2c-embedded/for-next (ca85e24 i2c: omap: cleanup the =
sysc write)
Merging jdelvare-hwmon/master (fe85ffb hwmon: (it87) Support PECI for addit=
ional chips)
Merging hwmon-staging/hwmon-next (87d0fb5 hwmon: (da9055) Fix chan_mux[DA90=
55_ADC_ADCIN3] setting)
Merging v4l-dvb/master (54db30f Merge /home/v4l/v4l/patchwork)
$ git reset --hard HEAD^
Merging refs/next/20121026/v4l-dvb
Merging kbuild/for-next (c582d2a Merge branch 'kbuild/rc-fixes' into kbuild=
/for-next)
Merging kconfig/for-next (4eae518 localmodconfig: Fix localyesconfig to set=
 to 'y' not 'm')
Merging libata/NEXT (13b7408 sata_mv: Fix warnings when no PCI)
Merging infiniband/for-next (1e3474d Merge branches 'cxgb4' and 'mlx4' into=
 for-next)
Merging pstore/master (9924a19 Merge git://git.kernel.org/pub/scm/virt/kvm/=
kvm)
Merging acpi/next (f3c7bfa tools/power turbostat: print Watts)
Merging cpuidle/cpuidle-next (3cf7997 acpi: intel_idle : break dependency b=
etween modules)
CONFLICT (content): Merge conflict in include/linux/cpuidle.h
CONFLICT (add/add): Merge conflict in drivers/cpuidle/coupled.c
Merging cpupowerutils/master (f166033 cpupower tools: add install target to=
 the debug tools' makefiles)
Merging thermal/next (160b7d8 Thermal: Remove the cooling_cpufreq_list.)
Merging ieee1394/for-next (790198f firewire: cdev: fix user memory corrupti=
on (i386 userland on amd64 kernel))
Merging ubi/linux-next (6a059ab UBI: use list_move_tail instead of list_del=
/list_add_tail)
Merging dlm/next (a3de56b fs/dlm: remove CONFIG_EXPERIMENTAL)
Merging swiotlb/linux-next (af51a9f swiotlb: Do not export swiotlb_bounce s=
ince there are no external consumers)
Merging scsi/for-next (5c1b10a [SCSI] storvsc: Account for in-transit packe=
ts in the RESET path)
Merging target-updates/for-next (3735648 target: Update copyright informati=
on to 2012)
Merging target-merge/for-next-merge (6f0c058 Linux 3.7-rc2)
Merging ibft/linux-next (935a9fe ibft: Fix finding IBFT ACPI table on UEFI)
Merging isci/all (6734092 isci: add a couple __iomem annotations)
Merging slave-dma/next (8007644 async_tx: use memchr_inv)
Merging dmaengine/next (a2bd114 netdma: adding alignment check for NETDMA o=
ps)
Merging net-next/master (bf0098f ARM: net: bpf_jit_32: add VLAN instruction=
s for BPF JIT)
CONFLICT (modify/delete): arch/m68k/include/uapi/asm/socket.h deleted in HE=
AD and modified in net-next/master. Version net-next/master of arch/m68k/in=
clude/uapi/asm/socket.h left in tree.
$ git rm -f arch/m68k/include/uapi/asm/socket.h
Merging wireless-next/master (b8d9e57 mwl8k: Set packet timestamp to 0 when=
 life time expiry is not used)
CONFLICT (content): Merge conflict in drivers/net/wireless/brcm80211/brcmfm=
ac/wl_cfg80211.c
Merging bluetooth/master (5187464 Bluetooth: Fix updating advertising state=
 flags and data)
Merging mtd/master (5a6ea4a mtd: ofpart: Fix incorrect NULL check in parse_=
ofoldpart_partitions())
Merging l2-mtd/master (33a9d7c mtd: Fix kernel-doc content to avoid warning=
.)
Merging crypto/master (a465348 crypto: s5p-sss - Fix compilation error)
Merging drm/drm-next (6380813 gma500: medfield: drop bogus NULL check in md=
fld_dsi_output_init())
Merging sound/for-next (701ef32 ALSA: core: fix NULL checking in snd_pcm_pl=
ug_slave_size())
Merging sound-asoc/for-next (c0af3c4 Merge branches 'fix/core', 'fix/cs4271=
', 'fix/cs42l52', 'fix/mxs', 'fix/samsung', 'fix/wm8978', 'topic/ab8500', '=
topic/ak4104', 'topic/arizona', 'topic/atmel', 'topic/cs4271', 'topic/da905=
5', 'topic/davinci', 'topic/fsi', 'topic/fsl', 'topic/jack', 'topic/jz4740'=
, 'topic/samsung', 'topic/si476x', 'topic/tlv320aic32x4', 'topic/ux500', 't=
opic/wm0010', 'topic/wm8750', 'topic/wm8770', 'topic/wm8971' and 'topic/wm8=
994' of git://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound into as=
oc-next)
Merging modules/modules-next (56713a2 MODSIGN: Add modules_sign make target)
Merging virtio/virtio-next (41395df virtio: Convert dev_printk(KERN_<LEVEL>=
 to dev_<level>()
Merging input/next (5383116 Input: marix-keymap - automatically allocate me=
mory for keymap)
Merging input-mt/for-next (6f0c058 Linux 3.7-rc2)
Merging cgroup/for-next (ef9fe98 cgroup_freezer: implement proper hierarchy=
 support)
Merging block/for-next (95678ef Merge branch 'for-3.8/core' into for-next)
Merging device-mapper/master (cee3685 track_chunk is always called with int=
errupts enabled. Consequently, we do not need to save and restore interrupt=
 state in "flags" variable. This patch changes spin_lock_irqsave to spin_lo=
ck_irq and spin_unlock_irqrestore to spin_unlock_irq.)
Merging embedded/master (4744b43 embedded: fix vc_translate operator preced=
ence)
Merging firmware/master (6e03a20 firmware: speed up request_firmware(), v3)
Merging pcmcia/master (80af9e6 pcmcia at91_cf: fix raw gpio number usage)
Merging mmc/mmc-next (d5b5205 mmc: sdhci: apply voltage range check only fo=
r non-fixed regulators)
Merging kgdb/kgdb-next (58bcdf6 tty/console: fix warnings in drivers/tty/se=
rial/kgdboc.c)
Merging slab/for-next (31841eb Merge branch 'slab/next' into for-next)
CONFLICT (content): Merge conflict in mm/slob.c
Merging uclinux/for-next (ddffeb8 Linux 3.7-rc1)
Merging md/for-next (79acf8a md:Avoid write invalid address if read_seqretr=
y returned true.)
Merging mfd/for-next (fe39f2f mfd: Implement tps6586x gpio_to_irq)
Merging battery/master (18766f0 Merge with upstream to accommodate with MFD=
 changes)
Merging fbdev/fbdev-next (cd9d6f1 gbefb: fix compile error)
Merging viafb/viafb-next (838ac78 viafb: avoid refresh and mode lookup in s=
et_par)
Merging omap_dss2/for-next (13b1ba7 OMAPDSS: add missing include for string=
.h)
Merging regulator/for-next (0a5fcf1 Merge remote-tracking branches 'regulat=
or/fix/gpio', 'regulator/fix/put', 'regulator/fix/supp-volt', 'regulator/to=
pic/gpio', 'regulator/topic/lp8788', 'regulator/topic/max77686', 'regulator=
/topic/max8925', 'regulator/topic/tol', 'regulator/topic/tps51632', 'regula=
tor/topic/tps65090', 'regulator/topic/tps65910', 'regulator/topic/tps80031'=
 and 'regulator/topic/vexpress' into regulator-next)
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
Merging vfio/next (c5fafed vfio: simplify kmalloc+copy_from_user to memdup_=
user)
Merging osd/linux-next (b6755ff osduld: Add osdname & systemid sysfs at scs=
i_osd class)
Merging jc_docs/docs-next (5c050fb docs: update the development process doc=
ument)
Merging trivial/for-next (8166ea0 alpha: use BUG_ON where possible)
Merging audit/for-next (dcd6c92 Linux 3.3-rc1)
Merging pm/linux-next (ea9c8e2 Merge branch 'acpi-enumeration-next' into li=
nux-next)
CONFLICT (content): Merge conflict in arch/x86/pci/acpi.c
Merging apm/for-next (fb9d78a Merge branch 'for-linus' of git://git.kernel.=
org/pub/scm/linux/kernel/git/jikos/apm)
Merging fsnotify/for-next (1aec9c0 inotify: automatically restart syscalls)
CONFLICT (content): Merge conflict in kernel/audit_tree.c
Merging edac/linux_next (5e75cbb Merge branch 'devel' into next)
Merging edac-amd/for-next (a8373ec EDAC: Handle error path in edac_mc_sysfs=
_init() properly)
Merging devicetree/devicetree/next (07269d4 Merge branch 'for-next' from gi=
t://sources.calxeda.com/kernel/linux.git)
Merging dt-rh/for-next (55020c8 of: Add vendor prefix for ON Semiconductor =
Corp.)
Merging spi/spi/next (614050c spi/bitbang: (cosmetic) simplify list manipul=
ation)
CONFLICT (add/add): Merge conflict in drivers/spi/spi-xcomm.c
Merging spi-mb/spi-next (170c2d0 Merge branch 'spi-mcspi' into spi-next)
Merging tip/auto-latest (9a4242f Merge branch 'numa/core')
Merging ftrace/for-next (1c7d667 tracing: Kill unused and puzzled sample co=
de in ftrace.h)
Merging rcu/rcu/next (81ecf12 sched: Mark RCU reader in sched_show_task())
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
Merging xen-two/linux-next (9e9b9e6 Merge branch 'stable/for-linus-3.7' int=
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
Merging leds/for-next (b11339c leds: lm3642: Fix up world writable sysfs fi=
les)
Merging driver-core/driver-core-next (6a92785 firmware loader: document fir=
mware cache mechanism)
Merging tty/tty-next (54d5f88 Merge v3.7-rc5 into tty-next)
CONFLICT (content): Merge conflict in drivers/tty/serial/omap-serial.c
Merging usb/usb-next (9d94e16 usb: otg: twl4030: Change TWL4030_MODULE_* id=
s to TWL_MODULE_*)
CONFLICT (content): Merge conflict in drivers/usb/musb/ux500.c
CONFLICT (modify/delete): drivers/usb/host/ohci-xls.c deleted in usb/usb-ne=
xt and modified in HEAD. Version HEAD of drivers/usb/host/ohci-xls.c left i=
n tree.
CONFLICT (modify/delete): drivers/usb/host/ehci-ls1x.c deleted in usb/usb-n=
ext and modified in HEAD. Version HEAD of drivers/usb/host/ehci-ls1x.c left=
 in tree.
CONFLICT (content): Merge conflict in drivers/usb/early/ehci-dbgp.c
$ git rm -f drivers/usb/host/ehci-ls1x.c drivers/usb/host/ohci-xls.c
Merging staging/staging-next (1f168db staging: comedi: Kconfig: remove VIRT=
_TO_BUS depends on)
CONFLICT (content): Merge conflict in drivers/iio/adc/Makefile
CONFLICT (content): Merge conflict in drivers/iio/adc/Kconfig
Merging char-misc/char-misc-next (ab5c4a5 mei: move amthif specific code fr=
om mei_write to mei_amthif_write)
Merging tmem/linux-next (8f0d816 Linux 3.7-rc3)
Merging writeback/writeback-for-next (2f60d62 CPU hotplug, writeback: Don't=
 call writeback_set_ratelimit() too often during hotplug)
Merging arm-dt/devicetree/arm-next (ede338f dt: add documentation of ARM dt=
 boot interface)
Merging hwspinlock/linux-next (8b37fcf hwspinlock: add MAINTAINERS entries)
Merging pinctrl/for-next (e38d457 pinctrl: pinmux: Release all taken pins i=
n pinmux_enable_setting error paths)
CONFLICT (content): Merge conflict in arch/arm/boot/dts/spear1340.dtsi
Merging vhost/linux-next (e0953c8 tun: experimental zero copy tx support)
CONFLICT (content): Merge conflict in drivers/net/tun.c
Merging memblock/memblock-kill-early_node_map (7bd0b0f memblock: Reimplemen=
t memblock allocation using reverse free area iterator)
Merging remoteproc/for-next (6f0c058 Linux 3.7-rc2)
Merging irqdomain/irqdomain/next (f5a1ad0 irqdomain: Improve diagnostics wh=
en a domain mapping fails)
Merging gpio/gpio/next (ddf343f Merge branch 'for-linus' of git://git.kerne=
l.org/pub/scm/linux/kernel/git/s390/linux)
Merging gpio-lw/for-next (4b0ce207 Merge branch 'devel' into for-next)
Merging arm-soc/for-next (c9cc10c Merge branch 'next/soc2' into for-next)
CONFLICT (content): Merge conflict in drivers/tty/serial/atmel_serial.c
CONFLICT (content): Merge conflict in drivers/pinctrl/pinctrl-nomadik.c
CONFLICT (content): Merge conflict in drivers/net/ethernet/cadence/at91_eth=
er.c
CONFLICT (content): Merge conflict in arch/arm/plat-omap/i2c.c
CONFLICT (content): Merge conflict in arch/arm/mach-ux500/cpu-db8500.c
CONFLICT (content): Merge conflict in arch/arm/mach-ux500/board-mop500.c
CONFLICT (content): Merge conflict in arch/arm/mach-ux500/board-mop500-audi=
o.c
CONFLICT (content): Merge conflict in arch/arm/mach-omap2/drm.c
CONFLICT (content): Merge conflict in arch/arm/mach-nomadik/board-nhk8815.c
CONFLICT (modify/delete): arch/arm/configs/stamp9g20_defconfig deleted in a=
rm-soc/for-next and modified in HEAD. Version HEAD of arch/arm/configs/stam=
p9g20_defconfig left in tree.
CONFLICT (modify/delete): arch/arm/configs/afeb9260_defconfig deleted in ar=
m-soc/for-next and modified in HEAD. Version HEAD of arch/arm/configs/afeb9=
260_defconfig left in tree.
CONFLICT (content): Merge conflict in arch/arm/Kconfig
$ git rm -f arch/arm/configs/afeb9260_defconfig arch/arm/configs/stamp9g20_=
defconfig
Merging bcm2835/for-next (d7f292e Merge branch 'for-3.8/defconfig' into for=
-next)
Merging cortex/for-next (77a3018 Cortex-M3: Add support for exception handl=
ing)
Merging ep93xx/ep93xx-for-next (fab1f74 Merge branch 'ep93xx-fixes' into ep=
93xx-for-next)
Merging ixp4xx/next (b94740b IXP4xx: use __iomem for MMIO)
Merging msm/for-next (a0d271c Linux 3.6)
Merging renesas/next (adb5641 Merge branches 'heads/fixes', 'heads/defconfi=
g' and 'heads/soc4'; commit 'ab6f6d85210c4d0265cf48e9958c04e08595055a' into=
 next)
Merging samsung/for-next (a9fe9f0 Merge branch 'next/cleanup-samsung-2' int=
o for-next)
Merging tegra/for-next (2418c73 Merge branch 'for-3.8/defconfig' into for-n=
ext)
Merging kvmtool/master (a6d404d kvm tools: allow arch to specify default vi=
rtio transport)
Merging dma-mapping/dma-mapping-next (f75b86d mm: dmapool: use provided gfp=
 flags for all dma_alloc_coherent() calls)
Merging pwm/for-next (5bca7cc pwm: spear: Staticize spear_pwm_config())
Merging dma-buf/for-next (ba42051 dma-buf: might_sleep() in dma_buf_unmap_a=
ttachment())
Merging userns/for-next (e9069f4 btrfs: Fix compilation with user namespace=
 support enabled)
Merging ktest/for-next (95f5783 ktest: Fix ELSE IF statements)
Merging signal/for-next (fae4535 frv: switch to generic fork/vfork/clone)
CONFLICT (content): Merge conflict in arch/sparc/kernel/sys_sparc_64.c
CONFLICT (content): Merge conflict in arch/arm/kernel/process.c
Merging clk/clk-next (749a267 clk: ux500: Register nomadik keypad clock loo=
kups for u8500)
Merging random/dev (ec8f02da random: prime last_data value per fips require=
ments)
Merging lzo-update/lzo-update (ba32bf9 lib/lzo: Do not leak implementation =
details in lzo1x_1_compress())
Merging powerpc/next (cedddd8 powerpc: Disable relocation on exceptions whe=
n kexecing)
CONFLICT (content): Merge conflict in arch/powerpc/kernel/entry_64.S
Merging 4xx/next (2074b1d powerpc: Fix irq distribution)
Merging mpc5xxx/next (fa9b24a powerpc/mpc5200: move lpbfifo node and fix it=
s interrupt property)
Merging galak/next (10bfa76 driver/mtd:IFC NAND:Initialise internal SRAM be=
fore any write)
Merging drop-experimental/linux-next (12f42dc tools/lguest: remove depends =
on CONFIG_EXPERIMENTAL)
CONFLICT (content): Merge conflict in drivers/ptp/Kconfig
CONFLICT (content): Merge conflict in drivers/net/ethernet/intel/Kconfig
Merging scsi-post-merge/merge-base:master ()
Merging akpm-current/current (4bfe832 memcg: fix hotplugged memory zone oop=
s)
CONFLICT (content): Merge conflict in mm/memcontrol.c
$ git checkout akpm
Applying: swapfile: fix name leak in swapoff
Applying: swapfile-fix-name-leak-in-swapoff-fix
Applying: rapidio: fix kernel-doc warnings
Applying: tmpfs: fix shmem_getpage_gfp VM_BUG_ON
Applying: tmpfs: change final i_blocks BUG to WARNING
Applying: mm: fix a regression with HIGHMEM
Applying: proc: check vma->vm_file before dereferencing
Applying: mm: revert "mm: vmscan: scale number of pages reclaimed by reclai=
m/compaction based on failures"
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
Applying: x86: make 'mem=3D' option to work for efi platform
Applying: fs/debugsfs: remove unnecessary inode->i_private initialization
Applying: pcmcia: move unbind/rebind into dev_pm_ops.complete
Applying: drm/i915: optimize DIV_ROUND_CLOSEST() call
Applying: irq: tsk->comm is an array
Applying: timeconst.pl: remove deprecated defined(@array)
Applying: time: don't inline EXPORT_SYMBOL functions
Applying: fs/pstore/ram.c: fix up section annotations
Applying: h8300: select generic atomic64_t support
Applying: drivers/tty/serial/serial_core.c: fix uart_get_attr_port() shift
Applying: tasklet: ignore disabled tasklet in tasklet_action()
Applying: drivers/message/fusion/mptscsih.c: missing break
Applying: drivers/scsi/hptiop: support HighPoint RR4520/RR4522 HBA
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
Applying: memory-hotplug: fix NR_FREE_PAGES mismatch's fix
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
Applying: mm/memory_hotplug.c: update start_pfn in zone and pg_data when sp=
anned_pages =3D=3D 0.
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
Applying: dmapool: make DMAPOOL_DEBUG detect corruption of free marker
Applying: dmapool-make-dmapool_debug-detect-corruption-of-free-marker-fix
Applying: mm: hwpoison: fix action_result() to print out dirty/clean
Applying: mm: print out information of file affected by memory error
Applying: mm: support more pagesizes for MAP_HUGETLB/SHM_HUGETLB
Applying: mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix
Applying: mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix-fix
Applying: MM: Support more pagesizes for MAP_HUGETLB/SHM_HUGETLB v7 fix fix=
 fix
Applying: MM: Support more pagesizes for MAP_HUGETLB/SHM_HUGETLB v7 fix fix=
 fix fix
Applying: mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix-fix-=
fix-fix-checkpatch-fixes
Applying: selftests: add a test program for variable huge page sizes in mma=
p/shmget
Applying: mm: augment vma rbtree with rb_subtree_gap
Applying: mm: ensure safe rb_subtree_gap update when inserting new VMA
Applying: mm: ensure safe rb_subtree_gap update when removing VMA
Applying: mm: debug code to verify rb_subtree_gap updates are safe
Applying: mm: check rb_subtree_gap correctness
Applying: mm-check-rb_subtree_gap-correctness-fix
Applying: mm: rearrange vm_area_struct for fewer cache misses
Applying: mm-rearrange-vm_area_struct-for-fewer-cache-misses-checkpatch-fix=
es
Applying: mm: vm_unmapped_area() lookup function
Applying: mm-vm_unmapped_area-lookup-function-checkpatch-fixes
Applying: mm: use vm_unmapped_area() on x86_64 architecture
Applying: mm: fix cache coloring on x86_64 architecture
Applying: mm: use vm_unmapped_area() in hugetlbfs
Applying: mm: use vm_unmapped_area() in hugetlbfs on i386 architecture
Applying: mm-use-vm_unmapped_area-in-hugetlbfs-on-i386-architecture-fix
Applying: mm: use vm_unmapped_area() on mips architecture
Applying: mm-use-vm_unmapped_area-on-mips-architecture-fix
Applying: mm: use vm_unmapped_area() on arm architecture
Applying: mm-use-vm_unmapped_area-on-arm-architecture-fix
Applying: mm-use-vm_unmapped_area-on-arm-architecture-fix-fix
Applying: mm: use vm_unmapped_area() on sh architecture
Applying: mm-use-vm_unmapped_area-on-sh-architecture-fix
Applying: mm: use vm_unmapped_area() on sparc32 architecture
Applying: mm-use-vm_unmapped_area-on-sparc32-architecture-fix
Applying: mm-use-vm_unmapped_area-on-sparc32-architecture-fix-fix
Applying: mm: use vm_unmapped_area() in hugetlbfs on tile architecture
Applying: mm-use-vm_unmapped_area-in-hugetlbfs-on-tile-architecture-fix
Applying: mm: use vm_unmapped_area() on sparc64 architecture
Applying: mm-use-vm_unmapped_area-on-sparc64-architecture-fix
Applying: linux-next: build warning after merge of the final tree (akpm tre=
e related)
Applying: mm: use vm_unmapped_area() in hugetlbfs on sparc64 architecture
Applying: mm-use-vm_unmapped_area-in-hugetlbfs-on-sparc64-architecture-fix
Applying: arch/sparc/kernel/sys_sparc_64.c: s/COLOUR/COLOR/
Applying: mm/vmscan.c: try_to_freeze() returns boolean
Applying: mm, mempolicy: remove duplicate code
Applying: mm: adjust address_space_operations.migratepage() return code
Applying: mm-adjust-address_space_operationsmigratepage-return-code-fix
Applying: mm: redefine address_space.assoc_mapping
Applying: mm: introduce a common interface for balloon pages mobility
Applying: mm-introduce-a-common-interface-for-balloon-pages-mobility-fix
Applying: mm-introduce-a-common-interface-for-balloon-pages-mobility-fix-fix
Applying: mm-introduce-a-common-interface-for-balloon-pages-mobility-fix-fi=
x-fix
Applying: mm: introduce compaction and migration for ballooned pages
Applying: virtio_balloon: introduce migration primitives to balloon pages
Applying: virtio: balloon: fix missing unlock on error in fill_balloon()
Applying: virtio_balloon-introduce-migration-primitives-to-balloon-pages-fi=
x-fix
Applying: virtio_balloon-introduce-migration-primitives-to-balloon-pages-fi=
x-fix-fix
Applying: mm: introduce putback_movable_pages()
Applying: mm: add vm event counters for balloon pages compaction
Applying: mm: fix slab.c kernel-doc warnings
Applying: mm: cleanup register_node()
Applying: mm, oom: change type of oom_score_adj to short
Applying: mm, oom: fix race when specifying a thread as the oom origin
Applying: mm: cma: skip watermarks check for already isolated blocks in spl=
it_free_page()
Applying: mm: cma: remove watermark hacks
Applying: mm: cma: remove watermark hacks (fix)
Applying: bootmem: remove not implemented function call, bootmem_arch_prefe=
rred_node()
Applying: avr32, kconfig: remove HAVE_ARCH_BOOTMEM
Applying: bootmem: remove alloc_arch_preferred_bootmem()
Applying: bootmem: fix wrong call parameter for free_bootmem()
Applying: bootmem-fix-wrong-call-parameter-for-free_bootmem-fix
Applying: mm: export a function to get vm committed memory
Applying: mm-export-a-function-to-get-vm-committed-memory-fix
Applying: mm: cma: WARN if freed memory is still in use
Applying: drivers/base/node.c: cleanup node_state_attr[]
Applying: mm, memory-hotplug: dynamic configure movable memory and portion =
memory
Applying: mm-memory-hotplug-dynamic-configure-movable-memory-and-portion-me=
mory-fix
Applying: memory_hotplug: handle empty zone when online_movable/online_kern=
el
Applying: memory_hotplug: ensure every online node has NORMAL memory
Applying: thp: huge zero page: basic preparation
Applying: thp: zap_huge_pmd(): zap huge zero pmd
Applying: thp: copy_huge_pmd(): copy huge zero page
Applying: thp: do_huge_pmd_wp_page(): handle huge zero page
Applying: thp: change_huge_pmd(): keep huge zero page write-protected
Applying: thp: change split_huge_page_pmd() interface
CONFLICT (content): Merge conflict in mm/mprotect.c
Applying: thp: implement splitting pmd for huge zero page
Applying: thp: setup huge zero page on non-write page fault
Applying: thp: lazy huge zero page allocation
Applying: thp: implement refcounting for huge zero page
Applying: thp, vmstat: implement HZP_ALLOC and HZP_ALLOC_FAILED events
Applying: mm: compaction: Fix compiler warning
Applying: mm: use migrate_prep() instead of migrate_prep_local()
Applying: drop_caches: add some documentation and info message
Applying: drop_caches-add-some-documentation-and-info-messsge-checkpatch-fi=
xes
Applying: swap: add a simple detector for inappropriate swapin readahead
Applying: swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix
Applying: mm/memblock: reduce overhead in binary search
Applying: mm/dmapool.c: fix null dev in dma_pool_create()
Applying: scripts/pnmtologo: fix for plain PBM
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
Applying: Kconfig: centralise CONFIG_ARCH_NO_VIRT_TO_BUS
Applying: printk: boot_delay should only affect output
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
Applying: drivers/of/fdt.c: re-use kernel's kbasename()
Applying: drivers-of-fdtc-re-use-kernels-kbasename-fix
Applying: sscanf: don't ignore field widths for numeric conversions
Applying: percpu_rw_semaphore: reimplement to not block the readers unneces=
sarily
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
Applying: MAINTAINERS: add Joe to checkpatch maintainers
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
Applying: drivers/rtc/rtc-test.c: avoid calling platform_device_put() twice
Applying: rtc-avoid-calling-platform_device_put-twice-in-test_init-fix
Applying: rtc: rtc-spear: use devm_*() routines
Applying: rtc-rtc-spear-use-devm_-routines-fix
Applying: rtc: rtc-spear: Add clk_{un}prepare() support
Applying: rtc: rtc-spear: Provide flag for no support of UIE mode
Applying: hfsplus: avoid crash on failed block map free
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
Applying: fat: notify when discard is not supported
Applying: fat: provide option for setting timezone offset
Applying: fat: ix mount option parsing
Applying: Documentation/DMA-API-HOWTO.txt: minor grammar corrections
Applying: Documentation: fix Documentation/security/00-INDEX
Applying: kstrto*: add documentation
Applying: simple_strto*: annotate function as obsolete
Applying: proc: don't show nonexistent capabilities
Applying: procfs: add VmFlags field in smaps output
Applying: procfs-add-vmflags-field-in-smaps-output-v4-fix
Applying: /proc/pid/status: add "Seccomp" field
Applying: fork: unshare: remove dead code
Applying: exec: do not leave bprm->interp on stack
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
Applying: aoe: provide ATA identify device content to user on request
Applying: aoe: improve network congestion handling
Applying: aoe: err device: include MAC addresses for unexpected responses
Applying: aoe: manipulate aoedev network stats under lock
Applying: aoe: use high-resolution RTTs with fallback to low-res
Applying: aoe: commands in retransmit queue use new destination on failure
Applying: aoe: update driver-internal version to 64+
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
Applying: tools/testing/selftests/kcmp/kcmp_test.c: print reason for failur=
e in kcmp_test
Applying: scatterlist: don't BUG when we can trivially return a proper erro=
r.
Applying: scatterlist-dont-bug-when-we-can-trivially-return-a-proper-error-=
fix
Merging akpm/master (d3faae6 scatterlist-dont-bug-when-we-can-trivially-ret=
urn-a-proper-error-fix)
Applying: lib: disable PSERIES_RECONFIG_NOTIFIER_ERROR_INJECT

--Signature=_Thu__15_Nov_2012_18_17_40_+1100_mKmBOhyO.pYwLOuO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQpJcUAAoJEECxmPOUX5FE/UAP/iutJSvFugGFxmdLwPzo+R4r
P0WbOhd1+2UCaaclRTVIp13PjuaVckFfaYHAnXGU8yKTDpbcYb8tv0p3B3s3zOgx
GXWOAld/eDsTzW087nXLsg58aLKUsykaY1dXEFb22NMdfaCkkePaDpWQVKPQ+TBJ
NWsi9huCzN/QQh/IiCwkvvujZ0xwpNGV5HoXD4LmzbSGDh2K+hKp83dhVL8yj2Tl
Ut817RHOKBSsUTKL8KqEnod4a8U3dBfAZq0Uomvz9Ufb8SJyz1hdnFgS7x5tzBoU
fKo7GA1hVJoI65WH3cEtTDP2xiOfUVpLooQx1i/5y+wakT7iwfnsoUvvBKoNb4vk
OGKygRsykvFFRtJEIB/pVWT+9h+mQ/k2/YaA1kNXP2+muJHzJXR/PeajuzxlH7Ut
6YjPK/FvcyIrhcsYeSJzOTA5gnTxeCpr0wHo1liUA1SnUUNzoYLBiggIFWWyCJT3
57nI+dobgrWwvekqbuYUyGfQlGShHyDwiN3i0qu1jOcD8h9d0daRya/ny8BTrH03
g7JfSIEOIU83nvhCAP6pkg8ZQGOF6XDzvksMXzNjXGHqhKmD3g844r6FNa7dREBk
0i6vhmkx8b8yM7DlfVQgFgLIzXyAu+DjUe5J/TMUfjIoqqfEOSItN9PNAQ14Gtx+
+fPeF3P5+hlSWnj2Kpql
=508o
-----END PGP SIGNATURE-----

--Signature=_Thu__15_Nov_2012_18_17_40_+1100_mKmBOhyO.pYwLOuO--

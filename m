Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759354Ab2AFXyq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 18:54:46 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:34821 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759333Ab2AFXyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 18:54:32 -0500
X-Sasl-enc: cqr6RYHFBXqp2QZ+gCr6/9/bQaVe01Z7w0YEld+FdRs4 1325894071
Date: Fri, 6 Jan 2012 15:52:30 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Subject: Linux 3.0.16
Message-ID: <20120106235230.GA15091@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0F1p//8PRICkK4MW"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.0.16 kernel.

All users of the 3.0 kernel series must upgrade.

The updated 3.0.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.0.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git=
;a=3Dsummary

thanks,

greg k-h

------------

 Makefile                                     |    2=20
 arch/arm/mach-omap2/board-rx51-peripherals.c |    2=20
 arch/arm/oprofile/common.c                   |    2=20
 arch/arm/plat-mxc/pwm.c                      |   16=20
 arch/s390/oprofile/init.c                    |    2=20
 arch/sh/oprofile/common.c                    |    4=20
 arch/sparc/include/asm/pgtable_32.h          |   20=20
 arch/sparc/include/asm/pgtable_64.h          |   20=20
 arch/sparc/kernel/entry.h                    |    7=20
 arch/sparc/kernel/module.c                   |   27=20
 arch/sparc/kernel/pci_sun4v.c                |    4=20
 arch/sparc/kernel/setup_64.c                 |   48 -
 arch/sparc/kernel/signal32.c                 |   18=20
 arch/sparc/kernel/signal_32.c                |   30 -
 arch/sparc/kernel/signal_64.c                |   42 -
 arch/sparc/kernel/visemul.c                  |   32 -
 arch/sparc/lib/memcpy.S                      |  804 +++-------------------=
-----
 arch/sparc/mm/Makefile                       |    1=20
 arch/sparc/mm/btfixup.c                      |    3=20
 arch/sparc/mm/generic_32.c                   |   98 ---
 arch/sparc/mm/generic_64.c                   |  164 -----
 arch/x86/net/bpf_jit_comp.c                  |    4=20
 block/blk-core.c                             |   14=20
 block/cfq-iosched.c                          |   16=20
 drivers/gpu/drm/i915/i915_dma.c              |   10=20
 drivers/gpu/drm/i915/i915_drv.h              |    1=20
 drivers/gpu/drm/radeon/evergreen.c           |   12=20
 drivers/gpu/drm/radeon/radeon_atombios.c     |    6=20
 drivers/input/mouse/synaptics.c              |   11=20
 drivers/media/video/s5p-fimc/fimc-core.c     |    2=20
 drivers/mfd/twl-core.c                       |   16=20
 drivers/mfd/twl4030-madc.c                   |   35 +
 drivers/mmc/host/mmci.c                      |   14=20
 drivers/mmc/host/vub300.c                    |    2=20
 drivers/net/pptp.c                           |    4=20
 drivers/net/wireless/ath/ath9k/main.c        |    3=20
 drivers/net/wireless/ath/ath9k/rc.c          |    4=20
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c  |    4=20
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c    |   10=20
 drivers/oprofile/oprofile_files.c            |    7=20
 drivers/oprofile/oprofilefs.c                |   11=20
 drivers/rtc/interface.c                      |   44 -
 drivers/rtc/rtc-m41t80.c                     |    9=20
 drivers/s390/scsi/zfcp_scsi.c                |    4=20
 drivers/scsi/fcoe/fcoe.c                     |    1=20
 drivers/scsi/mpt2sas/mpt2sas_base.c          |   59 -
 drivers/scsi/mpt2sas/mpt2sas_base.h          |    4=20
 drivers/scsi/mpt2sas/mpt2sas_scsih.c         |    2=20
 drivers/ssb/driver_pcicore.c                 |    8=20
 drivers/watchdog/hpwdt.c                     |    5=20
 drivers/xen/swiotlb-xen.c                    |    2=20
 fs/nfs/nfs4state.c                           |    8=20
 fs/nilfs2/ioctl.c                            |   13=20
 fs/xfs/linux-2.6/xfs_super.c                 |   30 -
 fs/xfs/linux-2.6/xfs_sync.c                  |   37 +
 fs/xfs/linux-2.6/xfs_sync.h                  |    2=20
 include/linux/blkdev.h                       |    3=20
 include/linux/i2c/twl4030-madc.h             |    4=20
 include/linux/lglock.h                       |   36 +
 include/net/sctp/structs.h                   |    4=20
 kernel/cgroup.c                              |    5=20
 kernel/exit.c                                |    9=20
 kernel/futex.c                               |   28=20
 kernel/hung_task.c                           |   14=20
 kernel/sysctl_binary.c                       |    2=20
 mm/filemap.c                                 |    7=20
 mm/hugetlb.c                                 |    2=20
 mm/memcontrol.c                              |    3=20
 mm/oom_kill.c                                |    2=20
 mm/percpu.c                                  |    6=20
 net/ipv4/devinet.c                           |    5=20
 net/ipv4/ipconfig.c                          |    4=20
 net/ipv4/ipip.c                              |    7=20
 net/ipv4/route.c                             |  107 +++
 net/ipv6/sit.c                               |    7=20
 net/llc/af_llc.c                             |   14=20
 net/mac80211/agg-tx.c                        |   86 +-
 net/sched/sch_gred.c                         |    2=20
 net/sched/sch_mqprio.c                       |    2=20
 net/sctp/associola.c                         |    2=20
 net/sctp/output.c                            |    8=20
 net/sctp/outqueue.c                          |    6=20
 net/sctp/protocol.c                          |    3=20
 net/sctp/socket.c                            |    2=20
 net/sctp/sysctl.c                            |   13=20
 security/selinux/netport.c                   |    4=20
 86 files changed, 823 insertions(+), 1334 deletions(-)

Alex Deucher (1):
      drm/radeon/kms: bail on BTC parts if MC ucode is missing

Alex Juncu (1):
      llc: llc_cmsg_rcv was getting called after sk_eat_skb.

Alexander M=FCller (1):
      drm/radeon/kms/atom: fix possible segfault in pm setup

Anton Blanchard (1):
      SCSI: mpt2sas: _scsih_smart_predicted_fault uses GFP_KERNEL in interr=
upt context

Christoph Hellwig (2):
      xfs: log the inode in ->write_inode calls for kupdate
      xfs: log all dirty inodes in xfs_fs_sync_fs

Dave Kleikamp (1):
      vfs: __read_cache_page should use gfp argument rather than GFP_KERNEL

David Howells (1):
      SELinux: Fix RCU deref check warning in sel_netport_insert()

David S. Miller (9):
      sparc64: Fix MSIQ HV call ordering in pci_sun4v_msiq_build_irq().
      sparc32: Be less strict in matching %lo part of relocation.
      sparc64: Patch sun4v code sequences properly on module load.
      sparc: Kill custom io_remap_pfn_range().
      sparc32: Remove non-kernel code from memcpy implementation.
      sparc32: Remove uses of %g7 in memcpy implementation.
      sparc32: Correct the return value of memcpy.
      sparc64: Fix masking and shifting in VIS fpcmp emulation.
      sparc: Fix handling of orig_i0 wrt. debugging when restarting syscall=
s.

Djalal Harouni (1):
      ppp: fix pptp double release_sock in pptp_bind()

Dmitry Torokhov (1):
      Input: synaptics - fix touchpad not working after S2R on Vostro V13

Emmanuel Grumbach (1):
      iwlwifi: update SCD BC table for all SCD queues

Eric Dumazet (2):
      sch_gred: should not use GFP_KERNEL while holding a spinlock
      ipv4: reintroduce route cache garbage collector

Eugene Surovegin (1):
      percpu: fix per_cpu_ptr_to_phys() handling of non-page-aligned addres=
ses

Eugeni Dodonov (1):
      drm/i915: prevent division by zero when asking for chipset power

Felipe Contreras (1):
      ARM: OMAP: rx51: fix USB

Frantisek Hrbata (1):
      oom: fix integer overflow of points in oom_badness

Gerlando Falauto (1):
      net: have ipconfig not wait if no dev is available

Greg Kroah-Hartman (1):
      Linux 3.0.16

Hauke Mehrtens (1):
      ssb: fix init regression with SoCs

Hillf Danton (2):
      memcg: keep root group unchanged if creation fails
      mm: hugetlb: fix non-atomic enqueue of huge page

Hugh Dickins (1):
      futex: Fix uninterruptible loop due to gate_area

Ilya Yanok (1):
      mfd: Fix twl-core oops while calling twl_i2c_* for unbound driver

Jason Chen (2):
      MXC PWM: should active during DOZE/WAIT/DBG mode
      ARM:imx:fix pwm period value

Johannes Berg (1):
      mac80211: fix another race in aggregation start

John Stultz (1):
      rtc: m41t80: Workaround broken alarm functionality

Konrad Rzeszutek Wilk (1):
      xen/swiotlb: Use page alignment for early buffer allocation.

Kyle Manna (3):
      mfd: Copy the device pointer to the twl4030-madc structure
      mfd: Check for twl4030-madc NULL pointer
      mfd: Turn on the twl4030-madc MADC clock

Linus Torvalds (1):
      Revert "rtc: Disable the alarm in the hardware"

Mandeep Singh Baines (2):
      cgroups: fix a css_set not found bug in cgroup_attach_proc
      hung_task: fix false positive during vfork

Markus K=F6tter (1):
      net: bpf_jit: fix an off-one bug in x86_64 cond jump target

Michel Lespinasse (1):
      binary_sysctl(): fix memory leak

Mike Snitzer (1):
      block: initialize request_queue's numa node during

Mingarelli, Thomas (1):
      watchdog: hpwdt: Changes to handle NX secure bit in 32bit path

Mohammed Shafi Shajakhan (1):
      ath9k: Fix kernel panic in AR2427 in AP mode

Nagalakshmi Nandigama (1):
      mpt2sas: fix non-x86 crash on shutdown

Oleg Nesterov (1):
      ptrace: partially fix the do_wait(WEXITED) vs EXIT_DEAD->EXIT_ZOMBIE =
race

Rajkumar Manoharan (1):
      ath9k: fix max phy rate at rate control init

Robert Richter (1):
      oprofile: Fix uninitialized memory access when writing to writing to =
oprofilefs

Rusty Russell (1):
      mmc: vub300: fix type of firmware_rom_wait_states module parameter

Sanjeev Premi (1):
      mfd: Fix mismatch in twl4030 mutex lock-unlock

Srivatsa S. Bhat (1):
      VFS: Fix race between CPU hotplug and lglocks

Steffen Maier (1):
      SCSI: zfcp: return early from slave_destroy if slave_alloc returned e=
arly

Stephen Rothwell (1):
      ipv4: using prefetch requires including prefetch.h

Sylwester Nawrocki (1):
      media: s5p-fimc: Use correct fourcc for RGB565 colour format

Ted Feng (1):
      ipip, sit: copy parms.name after register_netdevice

Thomas Gleixner (1):
      SCSI: fcoe: Fix preempt count leak in fcoe_filter_frames()

Thomas Graf (2):
      mqprio: Avoid panic if no options are provided
      sctp: Do not account for sizeof(struct sk_buff) in estimated rwnd

Thomas Meyer (1):
      nilfs2: unbreak compat ioctl

Trond Myklebust (1):
      NFSv4.1: Ensure that we handle _all_ SEQUENCE status bits.

Ulf Hansson (2):
      ARM: 7214/1: mmc: mmci: Fixup handling of MCI_STARTBITERR
      ARM: 7220/1: mmc: mmci: Fixup error handling for dma

Vladimir Zapolskiy (1):
      oprofile, arm/sh: Fix oprofile_arch_exit() linkage issue

Weiping Pan (1):
      ipv4: flush route cache after change accept_local

Wey-Yi Guy (2):
      iwlwifi: do not set the sequence control bit is not needed
      iwlwifi: allow to switch to HT40 if not associated

Xi Wang (1):
      sctp: fix incorrect overflow check on autoclose

Yasuaki Ishimatsu (1):
      cfq-iosched: fix cfq_cic_link() race confition

majianpeng (1):
      cfq-iosched: free cic_index if blkio_alloc_blkg_stats fails


--0F1p//8PRICkK4MW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJPB4k+AAoJEDjbvchgkmk+NCcQAJT5BPCZ2IemxndvQDJ9j81v
LoUyRCw1EVb6yaJW3zDjeyWEZoLrl5cgSxju5XuY4l2ekSMK6Ag4K1W0JSa8Qsq3
j7qJPqjLJtwFwUVSOATfldUkIQcO6YYTz3CBIPXB6UIxGwniqzHncm396HNmc0IH
Lg2gW4U3d68G9K5kC32fDEaBpD4cPr8uu9LK4VGwpF8SK3ZIW5dyT3KduNGLB+L9
Qx3RvpbmkXN/+gqcG1scGyCRcmoQCp4AKFTtkkV+qhlZUylB0IpcuHgsykuX5Kj5
ufEqiF7i5eQDhdCBOIqnQTjocAjMxJLeyYPv+CI2AzU5mqk0uZJBaDwjjYZqs9bJ
d1E0ePcGoKMvFD8uGdzd5mvRDoX3UZaumJjdwo7YLMM4jlgpclO/3MgYjAXoJWrA
YCaeG5wg/dgYjxRjTBu3FuoNZwnu1054AxqVemcPUsW/pLA/LKg8jIDZ+5W2xMvn
FLR9S8Jv4bYCTeNUMMh/FwZN4NB2sOqBOpowpxtflysTWftxDibU0gHtoqg8oXFX
jXWLNb6V4dyN+7Qc6P2dICVHnxdx5Kkn+J9IpXUsvNxWU0kO4S4qf5+kZwRqHo3G
QQbCotEBgfXpstj5OaYTuRPII4AsNkogoTy6PwbQRRlpdym9CSZL4A5e680a2Xh7
ol81zDl9w87P3dUtlW/c
=dXcd
-----END PGP SIGNATURE-----

--0F1p//8PRICkK4MW--

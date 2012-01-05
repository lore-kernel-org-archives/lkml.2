Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932272Ab2AEAvy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 19:51:54 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:51293 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932119Ab2AEAvt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 19:51:49 -0500
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 4 Jan 2012 16:51:27 -0800
X-Google-Sender-Auth: MatMZPEFzu15pDlgJdgSFV6ivp4
Message-ID: <CA+55aFzQrdFP3Sie2ug8uicNyqpD2mYEedj8srgcphfM2rP8JQ@mail.gmail.com>
Subject: Linux 3.2
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So 3.2 is out, and the merge window for 3.3 is thus officially open.

I delayed 3.2 first a few days to wait for the final linux-next
("final" in the sense that that's what I'll fetch to decide whether
something has been in linux-next for 3.3 or not), and then some more
as people were coming back from holidays and sorting out some
regressions. So we do have a few last-minute reverts and small fixes.

Still, there's not a whole lot of changes since -rc7 (shortlog
appended), and almost all of them are *tiny*. So despite the few
annoying last-minute reverts, I'm feeling pretty happy about it.

                                          Linus

---
Al Viro (1):
      minixfs: misplaced checks lead to dentry leak

Alex Deucher (1):
      drm/radeon/kms: bail on BTC parts if MC ucode is missing

Alex Williamson (2):
      KVM: Remove ability to assign a device without iommu support
      KVM: Device assignment permission checks

Alexander Müller (1):
      drm/radeon/kms/atom: fix possible segfault in pm setup

Amitkumar Karwar (1):
      mwifiex: fix crash during simultaneous scan and connect

Andreas Schwab (3):
      KVM: PPC: move compute_tlbie_rb to book3s_64 common header
      KVM: PPC: protect use of kvmppc_h_pr
      procfs: do not confuse jiffies with cputime64_t

Christoph Hellwig (2):
      xfs: log the inode in ->write_inode calls for kupdate
      xfs: log all dirty inodes in xfs_fs_sync_fs

Dan Williams (1):
      block: fix blk_queue_end_tag()

Dave Martin (2):
      ARM: 7196/1: errata: Remove SMP dependency for erratum 720789
      ARM: 7197/1: errata: Remove SMP dependency for erratum 751472

Denis Kuzmenko (1):
      ARM: SAMSUNG: Fix build error when selecting
CPU_FREQ_S3C24XX_DEBUGFS on S3C2440

Eric Bénard (7):
      cpuimx25sd: fix Kconfig
      imx_v4_v5_defconfig: update default configuration
      dma: MX3_IPU fix depends
      clock-imx35: fix reboot in internal boot mode
      cpuimx35sd: fix Kconfig
      cpuimx35: fix touchscreen support
      enable uncompress log on cpuimx35sd

Eric Dumazet (2):
      netem: dont call vfree() under spinlock and BH disabled
      sch_qfq: fix overflow in qfq_update_start()

Felipe Contreras (1):
      ARM: OMAP: hwmod data: fix iva and mailbox hwmods for OMAP 3

Florian Zumbiehl (1):
      skge: restore rx multicast filter on resume and after config changes

Grant Likely (1):
      dt/device: Fix auxdata matching to handle entries without a name override

Guennadi Liakhovetski (1):
      b43: fix regression in PIO case

Gustavo F. Padovan (1):
      Revert "Bluetooth: Increase HCI reset timeout in hci_dev_do_close"

Hans de Goede (1):
      gspca: Fix bulk mode cameras no longer working (regression fix)

Hillf Danton (1):
      mm: hugetlb: fix non-atomic enqueue of huge page

Holger Brunck (1):
      ARM: plat-orion: make gpiochip label unique

Hugh Dickins (1):
      futex: Fix uninterruptible loop due to gate_area

Jan Kara (1):
      security: Fix security_old_inode_init_security() when
CONFIG_SECURITY is not set

Jan Kiszka (2):
      KVM: x86: Prevent starting PIT timers in the absence of irqchip support
      KVM: Don't automatically expose the TSC deadline timer in cpuid

Jason Chen (1):
      ARM:imx:fix pwm period value

Javi Merino (1):
      ARM: 7237/1: PL330: Fix driver freeze

Jeff Layton (1):
      cifs: fix bad buffer length check in coalesce_t2

Joachim Eastwood (1):
      ASoC: wm8776: add missing break in sample size switch

Julian Anastasov (1):
      ipvs: try also real server with port 0 in backup server

KOSAKI Motohiro (1):
      mm/mempolicy.c: refix mbind_range() vma issue

Keith Packard (2):
      drm/i915: Disable semaphores by default on SNB
      drm/i915: Disable RC6 on Sandybridge by default

KyongHo Cho (1):
      iommu: Initialize domain->handler in iommu_domain_alloc()

Linus Torvalds (5):
      vfs: fix handling of lock allocation failure in lease-break case
      Revert "clockevents: Set noop handler in clockevents_exchange_device()"
      Revert "rtc: Disable the alarm in the hardware"
      Revert "rtc: Expire alarms after the time is set."
      Linux 3.2

Linus Walleij (1):
      watchdog: move coh901327 state holders

Mandeep Singh Baines (1):
      hung_task: fix false positive during vfork

Mauro Carvalho Chehab (1):
      gspca: Fix falling back to lower isoc alt settings

Michael Neuling (1):
      KVM: PPC: fix kvmppc_start_thread() for CONFIG_SMP=N

Mingarelli, Thomas (1):
      watchdog: hpwdt: Changes to handle NX secure bit in 32bit path

Mohammed Shafi Shajakhan (1):
      ath9k: Fix kernel panic in AR2427 in AP mode

Nick Bowler (1):
      watchdog: sp805: Fix section mismatch in ID table.

Oleg Nesterov (2):
      ptrace: partially fix the do_wait(WEXITED) vs EXIT_DEAD->EXIT_ZOMBIE race
      ptrace: ensure JOBCTL_STOP_SIGMASK is not zero after detach

Oliver Hartkopp (2):
      CAN MAINTAINERS update
      fix CAN MAINTAINERS SCM tree type

Pablo Neira Ayuso (2):
      netfilter: ctnetlink: fix return value of ctnetlink_get_expect()
      netfilter: ctnetlink: fix scheduling while atomic if helper is autoloaded

Richard Zhao (1):
      arm/imx: fix cpufreq section mismatch

Robert Richter (1):
      perf/x86: Fix raw_spin_unlock_irqrestore() usage

Sage Weil (1):
      ceph: disable use of dcache for readdir etc.

Scott Wood (1):
      KVM: PPC: e500: include linux/export.h

Shaohua Li (1):
      block, cfq: fix empty queue crash caused by request merge

Stefan Richter (1):
      MAINTAINERS: firewire git URL update

Steve French (1):
      [CIFS] default ntlmv2 for cifs mount delayed to 3.3

Tai-hwa Liang (2):
      Input: sentelic - release mutex upon register write failure
      Input: sentelic - fix retrieving number of buttons

Thomas Abraham (1):
      ARM: EXYNOS: Remove duplicated SROMC static memory mapping

Ulf Hansson (2):
      ARM: 7214/1: mmc: mmci: Fixup handling of MCI_STARTBITERR
      ARM: 7220/1: mmc: mmci: Fixup error handling for dma

Vladimir Zapolskiy (1):
      oprofile, arm/sh: Fix oprofile_arch_exit() linkage issue

Wei Yongjun (1):
      packet: fix possible dev refcnt leak when bind fail

Wim Van Sebroeck (1):
      watchdog: iTCO_wdt.c - problems with newer hardware due to SMI
clearing (part 2)

Wolfram Sang (1):
      net: fsl: fec: fix build for mx23-only kernel

Xi Wang (2):
      vmwgfx: fix incorrect VRAM size check in vmw_kms_fb_create()
      netfilter: ctnetlink: fix timeout calculation

Yevgeny Petrilin (1):
      mlx4_en: nullify cq->vector field when closing completion queue

majianpeng (1):
      block: re-use existing 'reading' variable instead of checking
direction again

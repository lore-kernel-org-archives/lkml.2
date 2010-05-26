Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934482Ab0EZW11 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 18:27:27 -0400
Received: from kroah.org ([198.145.64.141]:58613 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933312Ab0EZW1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 18:27:12 -0400
Date: Wed, 26 May 2010 15:24:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.32.14
Message-ID: <20100526222458.GC29493@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.32.14 kernel.

All users of the 2.6.32 kernel series should upgrade.

The updated 2.6.32.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.32.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.32.y.git;a=summary

thanks,

greg k-h

------------

 Documentation/filesystems/proc.txt       |    5 -
 Makefile                                 |    2 
 arch/parisc/kernel/pci.c                 |    7 --
 arch/powerpc/include/asm/hw_irq.h        |   38 ------------
 arch/powerpc/kernel/asm-offsets.c        |    1 
 arch/powerpc/kernel/entry_64.S           |    9 ---
 arch/powerpc/kernel/irq.c                |    6 --
 arch/powerpc/kernel/time.c               |   60 ++++++++++++++++----
 arch/s390/kernel/ptrace.c                |    5 -
 arch/x86/include/asm/k8.h                |    5 +
 arch/x86/kernel/cpu/intel_cacheinfo.c    |    4 +
 arch/x86/kernel/process.c                |   12 ++--
 crypto/authenc.c                         |   16 +++--
 drivers/acpi/sleep.c                     |   90 ------------------------------
 drivers/hwmon/hp_accel.c                 |    2 
 drivers/mmc/host/atmel-mci.c             |   14 ++--
 drivers/net/wireless/ath/ath9k/xmit.c    |    4 -
 drivers/net/wireless/iwlwifi/iwl-4965.c  |    5 +
 drivers/net/wireless/iwlwifi/iwl-5000.c  |    5 +
 drivers/net/wireless/p54/eeprom.c        |   31 ++++++----
 drivers/scsi/megaraid/megaraid_sas.c     |   18 +++++-
 drivers/serial/imx.c                     |   10 +++
 drivers/video/bfin-t350mcqb-fb.c         |   15 ++---
 fs/btrfs/ioctl.c                         |    5 +
 fs/cachefiles/security.c                 |    4 +
 fs/cifs/cifsglob.h                       |    1 
 fs/cifs/inode.c                          |   21 ++++++-
 fs/compat.c                              |    2 
 fs/exec.c                                |    2 
 fs/nilfs2/super.c                        |    1 
 fs/notify/inotify/inotify_fsnotify.c     |    2 
 fs/notify/inotify/inotify_user.c         |    9 ++-
 fs/proc/array.c                          |   92 -------------------------------
 fs/proc/task_mmu.c                       |   19 ------
 include/asm-generic/dma-mapping-common.h |    4 -
 include/linux/module.h                   |    2 
 include/linux/sched.h                    |    1 
 kernel/fork.c                            |    2 
 kernel/profile.c                         |    4 +
 mm/hugetlb.c                             |    2 
 net/ipv4/udp.c                           |    6 +-
 security/min_addr.c                      |    2 
 sound/pci/hda/hda_intel.c                |    1 
 sound/pci/hda/patch_conexant.c           |    7 +-
 sound/pci/ice1712/maya44.c               |    6 +-
 45 files changed, 213 insertions(+), 346 deletions(-)

Alex Chiang (1):
      ACPI: sleep: eliminate duplicate entries in acpisleep_dmi_table[]

Andreas Herrmann (1):
      x86, amd: Check X86_FEATURE_OSVW bit before accessing OSVW MSRs

Bjørn Mork (1):
      ipv4: udp: fix short packet and bad checksum logging

Borislav Petkov (1):
      x86, k8: Fix build error when K8_NB is disabled

Christian Lamparter (1):
      p54: disable channels with incomplete calibration data sets

Dan Rosenberg (1):
      Btrfs: check for read permission on src file in the clone ioctl

Daniel T Chen (1):
      ALSA: hda: Fix 0 dB for Lenovo models using Conexant CX20549 (Venice)

David Howells (1):
      CacheFiles: Fix error handling in cachefiles_determine_cache_security()

Eric Paris (1):
      inotify: race use after free/double free in inotify inode marks

FUJITA Tomonori (1):
      dma-mapping: fix dma_sync_single_range_*

Frank Arnold (1):
      x86, cacheinfo: Turn off L3 cache index disable feature in virtualized environments

Gerald Schaefer (1):
      ptrace: fix return value of do_syscall_trace_enter()

Greg Kroah-Hartman (3):
      Revert "module: fix __module_ref_addr()"
      Revert "parisc: Set PCI CLS early in boot."
      Linux 2.6.32.14

Herbert Xu (1):
      crypto: authenc - Add EINPROGRESS check

Hugh Dickins (1):
      profile: fix stats and data leakage

Jeff Layton (1):
      cifs: guard against hardlinking directories

KOSAKI Motohiro (1):
      proc: partially revert "procfs: provide stack information for threads"

Kees Cook (1):
      mmap_min_addr check CAP_SYS_RAWIO only for write

Luis R. Rodriguez (1):
      Revert "ath9k: fix lockdep warning when unloading module" on stable kernels

Mel Gorman (1):
      hugetlbfs: kill applications that use MAP_NORESERVE with SIGBUS instead of OOM-killer

Michael Hennerich (1):
      fbdev: bfin-t350mcqb-fb: fix fbmem allocation with blanking lines

Nicolas Ferre (3):
      mmc: atmel-mci: fix two parameters swapped
      mmc: atmel-mci: prevent kernel oops while removing card
      mmc: atmel-mci: remove data error interrupt after xfer

Oliver Neukum (1):
      hp_accel: fix race in device removal

Paul Mackerras (1):
      powerpc/perf_event: Fix oops due to perf_event_do_pending call

Pavel Emelyanov (1):
      inotify: don't leak user struct on inotify release

Robin Holt (1):
      revert "procfs: provide stack information for threads" and its fixup commits

Ryusuke Konishi (1):
      nilfs2: fix sync silent failure

Takashi Iwai (1):
      ALSA: ice1724 - Fix ESI Maya44 capture source control

Tomas Henzl (1):
      megaraid_sas: fix for 32bit apps

Valentin Longchamp (1):
      serial: imx.c: fix CTS trigger level lower to avoid lost chars

Vitaliy Kulikov (1):
      ALSA: hda - New Intel HDA controller

Wey-Yi Guy (1):
      iwlwifi: clear all the stop_queue flag after load firmware


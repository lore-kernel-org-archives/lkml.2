Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757351Ab1EUWXL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 18:23:11 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:41205 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754820Ab1EUWXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 18:23:09 -0400
X-Sasl-enc: LI+dxRsBom9FZPfczGzV217Xv6NWoNZNxXgeZ18abAuF 1306016588
Date: Sat, 21 May 2011 15:21:19 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.38.7
Message-ID: <20110521222119.GA3842@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.38.7 kernel.

All users of the 2.6.38 kernel series must upgrade.

The updated 2.6.38.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.38.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.38.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                                   |    2 
 arch/arm/boot/compressed/Makefile          |    2 
 arch/arm/boot/compressed/vmlinux.lds.in    |    1 
 arch/powerpc/kernel/ptrace.c               |   12 ++
 arch/x86/include/asm/apicdef.h             |    1 
 arch/x86/include/asm/uv/uv_bau.h           |   17 ++-
 arch/x86/kernel/cpu/amd.c                  |    4 
 arch/x86/kernel/cpu/mcheck/mce_amd.c       |    1 
 arch/x86/kernel/cpu/mcheck/therm_throt.c   |   12 +-
 arch/x86/kernel/ptrace.c                   |   36 ++++--
 arch/x86/platform/uv/tlb_uv.c              |   92 +++++++++++------
 drivers/ata/libata-eh.c                    |    2 
 drivers/cdrom/cdrom.c                      |    6 -
 drivers/gpu/drm/i915/intel_display.c       |    4 
 drivers/gpu/drm/i915/intel_dp.c            |   17 ++-
 drivers/gpu/drm/i915/intel_lvds.c          |    3 
 drivers/gpu/drm/radeon/evergreen.c         |   17 +--
 drivers/gpu/drm/radeon/evergreend.h        |    5 
 drivers/gpu/drm/radeon/radeon_atombios.c   |   18 ++-
 drivers/gpu/drm/radeon/radeon_kms.c        |    3 
 drivers/media/video/cx88/cx88-input.c      |    2 
 drivers/media/video/v4l2-device.c          |    5 
 drivers/mmc/core/host.c                    |    9 -
 drivers/net/Kconfig                        |    8 +
 drivers/net/Makefile                       |    6 -
 drivers/net/can/sja1000/sja1000.c          |    2 
 drivers/net/can/slcan.c                    |    4 
 drivers/net/ehea/ehea_ethtool.c            |   21 ++-
 drivers/net/ehea/ehea_main.c               |    6 -
 drivers/net/hydra.c                        |   14 +-
 drivers/net/ne-h8300.c                     |   16 +--
 drivers/net/pch_gbe/pch_gbe_main.c         |   23 +++-
 drivers/net/slip.c                         |    4 
 drivers/net/usb/ipheth.c                   |   14 +-
 drivers/net/vmxnet3/vmxnet3_drv.c          |   10 +
 drivers/net/vmxnet3/vmxnet3_ethtool.c      |    3 
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |    1 
 drivers/net/wireless/iwlwifi/iwl-agn.c     |    6 +
 drivers/net/wireless/iwlwifi/iwl-core.h    |    2 
 drivers/net/wireless/iwlwifi/iwl-legacy.c  |    7 +
 drivers/net/wireless/iwlwifi/iwl-rx.c      |    8 +
 drivers/net/wireless/libertas/cmd.c        |    6 -
 drivers/net/zorro8390.c                    |   12 +-
 drivers/platform/x86/thinkpad_acpi.c       |    6 -
 drivers/rapidio/switches/idt_gen2.c        |    9 +
 drivers/rapidio/switches/idtcps.c          |    6 +
 drivers/rapidio/switches/tsi57x.c          |    6 +
 drivers/rtc/rtc-s3c.c                      |   13 +-
 drivers/scsi/megaraid/megaraid_sas_base.c  |    3 
 drivers/scsi/sd.c                          |   63 +++--------
 fs/cifs/cifs_unicode.c                     |   49 ++++-----
 fs/cifs/cifs_unicode.h                     |    2 
 fs/cifs/connect.c                          |  130 ++++++++++++++----------
 fs/cifs/sess.c                             |   19 ---
 fs/partitions/efi.c                        |    6 +
 fs/proc/task_mmu.c                         |   12 +-
 include/drm/radeon_drm.h                   |    1 
 include/linux/bootmem.h                    |    2 
 include/linux/mm.h                         |   24 ++++
 include/linux/mmc/host.h                   |    1 
 include/linux/ptrace.h                     |   13 ++
 include/linux/sched.h                      |    3 
 kernel/exit.c                              |    2 
 kernel/power/suspend.c                     |    4 
 kernel/power/user.c                        |    5 
 kernel/ptrace.c                            |   17 +++
 kernel/time/clocksource.c                  |    4 
 kernel/time/tick-broadcast.c               |   12 ++
 mm/memory.c                                |   16 +--
 mm/mmap.c                                  |   11 +-
 mm/page_alloc.c                            |    7 -
 mm/shmem.c                                 |  154 ++++++++++++++++-------------
 net/core/dev.c                             |   10 +
 net/dccp/options.c                         |    2 
 net/ipv4/ip_fragment.c                     |   31 ++---
 sound/soc/codecs/ssm2602.c                 |    2 
 sound/soc/codecs/uda134x.c                 |    2 
 77 files changed, 684 insertions(+), 407 deletions(-)

Alex Deucher (3):
      drm/radeon/kms: add pci id to acer travelmate quirk for 5730
      drm/radeon/kms: fix gart setup on fusion parts (v2) backport
      drm/radeon/kms: fix extended lvds info parsing

Alex Williamson (1):
      drm/i915/lvds: Only act on lid notify when the device is on

Alexandre Bounine (1):
      rapidio: fix default routing initialization

Anton Blanchard (1):
      ehea: Fix memory hotplug oops

Ben Dooks (1):
      drivers/rtc/rtc-s3c.c: fixup wake support for rtc

Ben Hutchings (1):
      ipheth: Properly distinguish length and alignment in URBs and skbs

Bjørn Mork (1):
      megaraid_sas: Sanity check user supplied length before passing it to dma_alloc_coherent()

Borislav Petkov (2):
      Revert "x86, AMD: Fix APIC timer erratum 400 affecting K8 Rev.A-E processors"
      x86, AMD: Fix ARAT feature setting again

Chris Ball (1):
      Revert "mmc: fix a race between card-detect rescan and clock-gate work instances"

Chris Wilson (2):
      drm/i915/dp: Be paranoid in case we disable a DP before it is attached
      drm/i915: Release object along create user fb error path

Cliff Wickman (1):
      x86: Fix UV BAU for non-consecutive nasids

Dan Rosenberg (1):
      dccp: handle invalid feature options length

Eric Dumazet (2):
      net: ip_expire() must revalidate route
      net: dev_close() should check IFF_UP

Frederic Weisbecker (3):
      x86, hw_breakpoints: Fix racy access to ptrace breakpoints
      ptrace: Prepare to fix racy accesses on task breakpoints
      hw_breakpoints, powerpc: Fix CONFIG_HAVE_HW_BREAKPOINT off-case in ptrace_set_debugreg()

Geert Uytterhoeven (3):
      ne-h8300: Fix regression caused during net_device_ops conversion
      hydra: Fix regression caused during net_device_ops conversion
      zorro8390: Fix regression caused during net_device_ops conversion

Greg Kroah-Hartman (1):
      Linux 2.6.38.7

Hugh Dickins (7):
      vm: fix vm_pgoff wrap in upward expansion
      tmpfs: fix race between umount and swapoff
      tmpfs: fix race between umount and writepage
      tmpfs: fix race between swapoff and writepage
      tmpfs: fix off-by-one in max_blocks checks
      tmpfs: fix spurious ENOSPC when racing with unswap
      tmpfs: fix highmem swapoff crash regression

James Bottomley (1):
      Revert "[SCSI] Retrieve the Caching mode page"

Jeff Layton (8):
      cifs: change bleft in decode_unicode_ssetup back to signed type
      cifs: check for bytes_remaining going to zero in CIFS_SessSetup
      cifs: sanitize length checking in coalesce_t2 (try #3)
      cifs: refactor mid finding loop in cifs_demultiplex_thread
      cifs: handle errors from coalesce_t2
      cifs: add fallback in is_path_accessible for old servers
      cifs: clean up various nits in unicode routines (try #2)
      cifs: fix cifsConvertToUCS() for the mapchars case

John Stultz (1):
      clocksource: Install completely before selecting

Julia Lawall (1):
      x86, mce, AMD: Fix leaving freed data in a list

Kleber Sacilotto de Souza (1):
      ehea: fix wrongly reported speed and port

Kurt Van Dijck (1):
      can: fix SJA1000 dlc for RTR packets

Lars-Peter Clausen (1):
      ASoC: SSM2602: Fix 'Mic Boost2' control

Laurent Pinchart (1):
      v4l: Release module if subdev registration fails

Lawrence Rust (1):
      Fix cx88 remote control input

Manoj Iyer (1):
      thinkpad-acpi: module autoloading for newer Lenovo ThinkPads.

Marek Belisko (1):
      ASoC: UDA134x: Remove POWER_OFF_ON_STANDBY define.

Matvejchikov Ilya (1):
      NET: slip, fix ldisc->open retval

Mikulas Patocka (1):
      Don't lock guardpage if the stack is growing up

Nicolas Pitre (1):
      ARM: zImage: make sure the stack is 64-bit aligned

Oliver Hartkopp (1):
      slcan: fix ldisc->open retval

Paul Fox (1):
      libertas: fix cmdpendingq locking

Pavel Shilovsky (1):
      CIFS: Fix memory over bound bug in cifs_parse_mount_options

Rafael J. Wysocki (3):
      PM: Fix warning in pm_restrict_gfp_mask() during SNAPSHOT_S2RAM ioctl
      PM / Hibernate: Make snapshot_release() restore GFP mask
      PM / Hibernate: Fix ioctl SNAPSHOT_S2RAM

Roland Dreier (1):
      vmxnet3: Consistently disable irqs when taking adapter->cmd_lock

Stanislaw Gruszka (2):
      iwlwifi: add {ack, plpc}_check module parameters
      iwlegacy: fix IBSS mode crashes

Tejun Heo (2):
      libata: fix oops when LPM is used with PMP
      cdrom: always check_disk_change() on open

Thomas Gleixner (1):
      tick: Clear broadcast active bit when switching to oneshot

Thomas Jarosch (1):
      vmxnet3: Fix inconsistent LRO state after initialization

Timo Warns (1):
      Validate size of EFI GUID partition entries.

Tomoya (1):
      pch_gbe: support ML7223 IOH

Toshiharu Okada (2):
      PCH_GbE : Fixed the issue of collision detection
      PCH_GbE : Fixed the issue of checksum judgment

Yinghai Lu (1):
      mm: use alloc_bootmem_node_nopanic() on really needed path

Youquan Song (1):
      x86, apic: Fix spurious error interrupts triggering on all non-boot APs


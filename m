Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757865Ab0ITVpn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 17:45:43 -0400
Received: from kroah.org ([198.145.64.141]:45351 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757824Ab0ITVpe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 17:45:34 -0400
Date: Mon, 20 Sep 2010 14:45:01 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.35.5
Message-ID: <20100920214501.GB26382@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.35.5 kernel.

All users of the 2.6.35 kernel series must upgrade.

The updated 2.6.35.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.35.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.35.y.git;a=summary

thanks,

greg k-h

------------


 Documentation/sound/alsa/HD-Audio-Models.txt   |    1 
 Makefile                                       |    2 
 arch/arm/kernel/entry-common.S                 |    2 
 arch/ia64/include/asm/compat.h                 |    2 
 arch/ia64/kernel/msi_ia64.c                    |    2 
 arch/ia64/sn/kernel/msi_sn.c                   |    2 
 arch/mips/include/asm/compat.h                 |    2 
 arch/parisc/include/asm/compat.h               |    2 
 arch/powerpc/include/asm/compat.h              |    2 
 arch/powerpc/kernel/time.c                     |   23 +-
 arch/s390/include/asm/compat.h                 |    2 
 arch/sparc/include/asm/compat.h                |    2 
 arch/x86/ia32/ia32entry.S                      |   22 +-
 arch/x86/include/asm/compat.h                  |    2 
 arch/x86/include/asm/hpet.h                    |    1 
 arch/x86/include/asm/tsc.h                     |    2 
 arch/x86/kernel/apic/io_apic.c                 |    2 
 arch/x86/kernel/cpu/perf_event_p4.c            |    2 
 arch/x86/kernel/early-quirks.c                 |   18 -
 arch/x86/kernel/hpet.c                         |   31 +--
 arch/x86/kernel/tsc.c                          |   38 +++
 arch/x86/oprofile/nmi_int.c                    |   22 +-
 arch/x86/power/cpu.c                           |    2 
 drivers/ata/libahci.c                          |    2 
 drivers/ata/libata-core.c                      |   14 +
 drivers/ata/libata-eh.c                        |    4 
 drivers/ata/libata-sff.c                       |    7 
 drivers/ata/pata_cmd64x.c                      |    6 
 drivers/ata/pata_via.c                         |    2 
 drivers/ata/sata_mv.c                          |   44 +++-
 drivers/char/agp/intel-gtt.c                   |    8 
 drivers/gpu/drm/drm_crtc_helper.c              |    4 
 drivers/gpu/drm/i915/i915_dma.c                |   36 ++-
 drivers/gpu/drm/i915/i915_gem.c                |    1 
 drivers/gpu/drm/i915/i915_reg.h                |    9 
 drivers/gpu/drm/i915/intel_display.c           |   11 -
 drivers/gpu/drm/i915/intel_dp.c                |   58 ++---
 drivers/gpu/drm/i915/intel_lvds.c              |    2 
 drivers/gpu/drm/i915/intel_ringbuffer.c        |    8 
 drivers/gpu/drm/radeon/atombios_crtc.c         |   23 +-
 drivers/gpu/drm/radeon/evergreen.c             |   66 +++++-
 drivers/gpu/drm/radeon/r600.c                  |    7 
 drivers/gpu/drm/radeon/radeon.h                |    6 
 drivers/gpu/drm/radeon/rv770.c                 |   52 +++++
 drivers/hid/usbhid/hid-core.c                  |    3 
 drivers/hwmon/ads7871.c                        |   38 +--
 drivers/hwmon/emc1403.c                        |    1 
 drivers/hwmon/f75375s.c                        |    6 
 drivers/hwmon/hp_accel.c                       |    2 
 drivers/hwmon/k8temp.c                         |   35 +++
 drivers/infiniband/hw/cxgb3/cxio_hal.h         |    2 
 drivers/input/mouse/appletouch.c               |    6 
 drivers/input/serio/i8042.c                    |   67 ++++--
 drivers/mmc/core/core.c                        |   83 +++++---
 drivers/mmc/core/host.c                        |    6 
 drivers/mmc/host/tmio_mmc.c                    |    7 
 drivers/mmc/host/tmio_mmc.h                    |   13 -
 drivers/net/wireless/ath/ath5k/base.c          |    4 
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |    2 
 drivers/net/wireless/ath/ath9k/eeprom.h        |    2 
 drivers/net/wireless/ath/ath9k/htc_drv_main.c  |    3 
 drivers/net/wireless/ath/regd.h                |    1 
 drivers/net/wireless/p54/txrx.c                |    2 
 drivers/oprofile/buffer_sync.c                 |   27 +-
 drivers/oprofile/cpu_buffer.c                  |    2 
 drivers/pci/msi.c                              |   27 ++
 drivers/power/apm_power.c                      |    1 
 drivers/serial/bfin_sport_uart.c               |    2 
 drivers/staging/hv/netvsc_drv.c                |    3 
 drivers/staging/hv/ring_buffer.c               |    3 
 drivers/staging/hv/storvsc_api.h               |    4 
 drivers/staging/hv/storvsc_drv.c               |   11 -
 drivers/staging/rt2860/usb_main_dev.c          |   41 +++-
 drivers/usb/atm/cxacru.c                       |   24 ++
 drivers/usb/class/cdc-acm.c                    |   23 ++
 drivers/usb/core/message.c                     |   22 +-
 drivers/usb/gadget/rndis.c                     |   10 -
 drivers/usb/host/ehci-ppc-of.c                 |   12 -
 drivers/usb/serial/cp210x.c                    |   10 -
 drivers/usb/serial/ftdi_sio.c                  |    8 
 drivers/usb/serial/ftdi_sio_ids.h              |   12 +
 drivers/usb/serial/mos7840.c                   |   32 ++-
 drivers/xen/events.c                           |   21 +-
 fs/binfmt_misc.c                               |    2 
 fs/cifs/connect.c                              |    6 
 fs/direct-io.c                                 |   30 +--
 fs/ext4/ext4.h                                 |    4 
 fs/ext4/inode.c                                |   17 +
 fs/fuse/dev.c                                  |   16 +
 fs/minix/namei.c                               |    2 
 fs/nfs/client.c                                |    2 
 fs/nfs/super.c                                 |    8 
 fs/ocfs2/aops.c                                |    7 
 fs/ocfs2/inode.c                               |    6 
 fs/sysfs/file.c                                |    2 
 fs/xfs/linux-2.6/xfs_aops.c                    |   24 ++
 fs/xfs/linux-2.6/xfs_aops.h                    |    2 
 fs/xfs/xfs_ialloc.c                            |   16 +
 fs/xfs/xfs_inode.c                             |   49 ++---
 include/linux/compat.h                         |    3 
 include/linux/fs.h                             |    3 
 include/linux/libata.h                         |    1 
 include/linux/mmc/host.h                       |    3 
 include/linux/msi.h                            |    2 
 include/linux/swap.h                           |    3 
 kernel/compat.c                                |   21 ++
 kernel/gcov/fs.c                               |  244 ++++++++++++++++++-------
 kernel/groups.c                                |    5 
 kernel/trace/ftrace.c                          |   19 +
 mm/bounce.c                                    |    2 
 mm/compaction.c                                |    7 
 mm/memory_hotplug.c                            |   16 -
 mm/page-writeback.c                            |   26 +-
 mm/swapfile.c                                  |   35 ++-
 net/ipv4/netfilter/arp_tables.c                |    3 
 net/ipv4/netfilter/ip_tables.c                 |    3 
 net/ipv6/netfilter/ip6_tables.c                |    3 
 net/irda/irlan/irlan_common.c                  |    2 
 net/mac80211/main.c                            |    6 
 net/sunrpc/auth_gss/auth_gss.c                 |    9 
 net/sunrpc/rpc_pipe.c                          |    6 
 net/wireless/wext-compat.c                     |    3 
 net/wireless/wext-core.c                       |   16 +
 security/integrity/ima/ima.h                   |    1 
 security/integrity/ima/ima_iint.c              |    4 
 security/integrity/ima/ima_main.c              |    8 
 sound/core/seq/oss/seq_oss_init.c              |    9 
 sound/pci/hda/hda_codec.c                      |    2 
 sound/pci/hda/patch_cirrus.c                   |   50 +++++
 sound/pci/hda/patch_conexant.c                 |   58 +++++
 sound/pci/hda/patch_nvhdmi.c                   |   61 ++++--
 sound/pci/hda/patch_realtek.c                  |   20 +-
 sound/pci/oxygen/oxygen.h                      |    1 
 sound/pci/oxygen/oxygen_lib.c                  |   21 +-
 sound/pci/oxygen/virtuoso.c                    |    1 
 sound/pci/oxygen/xonar_wm87x6.c                |   22 ++
 sound/usb/card.c                               |   19 +
 sound/usb/clock.c                              |    3 
 sound/usb/endpoint.c                           |   11 -
 sound/usb/format.c                             |   14 +
 sound/usb/mixer.c                              |   10 -
 sound/usb/pcm.c                                |    3 
 tools/perf/util/callchain.h                    |    1 
 143 files changed, 1516 insertions(+), 571 deletions(-)

Al Viro (1):
      arm: fix really nasty sigreturn bug

Alan Ott (1):
      HID: Set Report ID properly for Output reports on the Control endpoint.

Alex Deucher (6):
      drm/radeon/kms: fix a regression on r7xx AGP due to the HDP flush fix
      drm/radeon/kms: force legacy pll algo for RV515 LVDS
      drm/radeon/kms: force legacy pll algo for RV620 LVDS
      drm/radeon/kms: properly set crtc high base on r7xx
      drm/radeon/kms/evergreen: fix gpu hangs in userspace accel code
      drm/radeon/kms/evergreen: fix backend setup

Andreas Herrmann (1):
      hwmon: (k8temp) Differentiate between AM2 and ASB1

Anton Vorontsov (1):
      apm_power: Add missing break statement

Axel Lin (1):
      hwmon: (ads7871) Fix ads7871_probe error paths

Ben Hutchings (3):
      PCI: MSI: Remove unsafe and unnecessary hardware access
      PCI: MSI: Restore read_msi_msg_desc(); add get_cached_msi_msg_desc()
      Staging: rt2870sta: Add more device IDs from vendor drivers

Benjamin Herrenschmidt (1):
      Revert "Input: appletouch - fix integer overflow issue"

Brian Austin (1):
      ALSA: hda - Add errata initverb sequence for CS42xx codecs

Chris Wilson (6):
      agp/intel: Promote warning about failure to setup flush to error.
      drm/i915/dp: Really try 5 times before giving up.
      drm/i915: Allocate the PCI resource for the MCHBAR
      drm/i915: Prevent double dpms on
      Revert "drm/i915: Allow LVDS on pipe A on gen4+"
      drm: Only decouple the old_fb from the crtc is we call mode_set*

Chris Wright (1):
      tracing: t_start: reset FTRACE_ITER_HASH in case of seek/pread

Christian Lamparter (1):
      p54: fix tx feedback status flag check

Christoph Hellwig (3):
      direct-io: move aio_complete into ->end_io
      xfs: move aio completion after unwritten extent conversion
      swap: do not send discards as barriers

Clemens Ladisch (3):
      ALSA: usb-audio: fix detection of vendor-specific device protocol settings
      ALSA: virtuoso: work around missing reset in the Xonar DS Windows driver
      ALSA: virtuoso: fix setting of Xonar DS line-in/mic-in controls

Craig Shelley (1):
      USB: CP210x Add new device ID

Dan Carpenter (5):
      USB: ehci-ppc-of: problems in unwind
      sysfs: checking for NULL instead of ERR_PTR
      irda: off by one
      i915: return -EFAULT if copy_to_user fails
      i915_gem: return -EFAULT if copy_to_user fails

Daniel Mack (1):
      ALSA: usb-audio: Assume first control interface is for audio

Daniel Vetter (1):
      drm/i915: overlay on gen2 can't address above 1G

Dave Chinner (3):
      xfs: fix untrusted inode number lookup
      xfs: ensure we mark all inodes in a freed cluster XFS_ISTALE
      writeback: write_cache_pages doesn't terminate at nr_to_write <= 0

Dave Ludlow (2):
      usb: serial: mos7840: Add USB ID to support the B&B Electronics USOPTL4-2P.
      usb: serial: mos7840: Add USB IDs to support more B&B USB/RS485 converters.

David Henningsson (5):
      ALSA: hda - Add Sony VAIO quirk for ALC269
      ALSA: HDA: Use model=auto for LG R510
      ALSA: hda - Rename iMic to Int Mic on Lenovo NB0763
      ALSA: hda - Add a new hp-laptop model for Conexant 5066, tested on HP G60
      ALSA: HDA: Enable internal speaker on Dell M101z

Dmitry Torokhov (2):
      Input: i8042 - fix device removal on unload
      Input: i8042 - reset keyboard controller wehen resuming from S2R

Florian Westphal (1):
      netfilter: fix CONFIG_COMPAT support

Frederic Weisbecker (1):
      perf: Initialize callchains roots's childen hits

Gary King (1):
      bounce: call flush_dcache_page() after bounce_copy_vec()

Greg Kroah-Hartman (1):
      Linux 2.6.35.5

Guennadi Liakhovetski (1):
      mmc: fix the use of kunmap_atomic() in tmio_mmc.h

Guillem Jover (2):
      hwmon: (f75375s) Shift control mode to the correct bit position
      hwmon: (f75375s) Do not overwrite values read from registers

H. Peter Anvin (2):
      x86-64, compat: Test %rax for the syscall number, not %eax
      compat: Make compat_alloc_user_space() incorporate the access_ok()

Haiyang Zhang (2):
      staging: hv: Fix missing functions for net_device_ops
      staging: hv: Fixed the value of the 64bit-hole inside ring buffer

Hank Janssen (3):
      staging: hv: Fixed bounce kmap problem by using correct index
      staging: hv: Increased storvsc ringbuffer and max_io_requests
      staging: hv: Fixed lockup problem with bounce_buffer scatter list

Hugh Dickins (2):
      swap: prevent reuse during hibernation
      swap: discard while swapping only if SWAP_FLAG_DISCARD

Jan Sembera (1):
      binfmt_misc: fix binfmt_misc priority

Jason Detring (1):
      USB: cp210x: Add B&G H3000 link cable ID

Jeff Layton (1):
      cifs: fix potential double put of TCP session reference

Jeff Moyer (1):
      O_DIRECT: fix the splitting up of contiguous I/O

Jeremy Fitzhardinge (2):
      xen: handle events as edge-triggered
      xen: use percpu interrupts for IPIs and VIRQs

Jerome Marchand (1):
      kernel/groups.c: fix integer overflow in groups_search

Jesse Barnes (1):
      drm/i915: don't enable self-refresh on Ironlake

Jiaying Zhang (1):
      ext4: move aio completion after unwritten extent conversion

Johannes Berg (2):
      mac80211: delete work timer
      wireless extensions: fix kernel heap content leak

John W. Linville (1):
      ath5k: check return value of ieee80211_get_tx_rate

Jorge Boncompte [DTI2] (1):
      minix: fix regression in minix_mkdir()

KAMEZAWA Hiroyuki (1):
      memory hotplug: fix next block calculation in is_removable

Li Zefan (1):
      tracing: Fix a race in function profile

Lin Ming (1):
      perf, x86, Pentium4: Clear the P4_CCCR_FORCE_OVF flag

Luis R. Rodriguez (2):
      ath9k_hw: Fix EEPROM uncompress block reading on AR9003
      ath9k_hw: fix parsing of HT40 5 GHz CTLs

Luke Lowrey (1):
      USB: ftdi_sio: Added custom PIDs for ChamSys products

Mark Lord (2):
      libata-sff: remove harmful BUG_ON from ata_bmdma_qc_issue
      sata_mv: fix broken DSM/TRIM support (v2)

Maxim Levitsky (1):
      mmc: fix all hangs related to mmc/sd card insert/removal during suspend/resume

Maxim Osipov (1):
      USB: Fix kernel oops with g_ether and Windows

Menyhart Zoltan (1):
      statfs() gives ESTALE error

Miklos Szeredi (1):
      fuse: flush background queue on connection close

Mimi Zohar (1):
      ima: always maintain counters

Minchan Kim (1):
      mm: compaction: handle active and inactive fairly in too_many_isolated

Paul Mackerras (1):
      powerpc/perf_event: Reduce latency of calling perf_event_do_pending

Peter Oberparleiter (1):
      gcov: fix null-pointer dereference for certain module types

Peter Zijlstra (1):
      x86, tsc: Fix a preemption leak in restore_sched_clock_state()

Philippe Corbes (1):
      USB: cdc-acm: Add pseudo modem without AT command capabilities

Robert Richter (3):
      oprofile: fix crash when accessing freed task structs
      oprofile, x86: fix init_sysfs error handling
      oprofile, x86: fix init_sysfs() function stub

Roland McGrath (1):
      x86-64, compat: Retruncate rax after ia32 syscall entry tracing

Simon Arlott (1):
      USB: cxacru: Use a bulk/int URB to access the command endpoint

Sonic Zhang (1):
      serial: bfin_sport_uart: restore transmit frame sync fix

Stephen Warren (1):
      ALSA: hda - patch_nvhdmi.c: Add missing codec IDs, unify names

Steve Wise (1):
      RDMA/cxgb3: Don't exceed the max HW CQ depth

Steven Rostedt (1):
      tracing: Do not allow llseek to set_ftrace_filter

Sunil Mushran (1):
      ocfs2: Fix incorrect checksum validation error

Suresh Siddha (1):
      x86, tsc, sched: Recompute cyc2ns_offset's during resume from sleep states

Takashi Iwai (7):
      ALSA: hda - Handle missing NID 0x1b on ALC259 codec
      ALSA: hda - Handle pin NID 0x1a on ALC259/269
      ALSA: seq/oss - Fix double-free at error path of snd_seq_oss_open()
      ALSA: usb - Release capture substream URBs properly
      ALSA: hda - Add quirk for Lenovo T400s
      ALSA: hda - Fix wrong HP pin detection in snd_hda_parse_pin_def_config()
      hp_accel: add quirks for HP ProBook 532x and HP Mini 5102

Tejun Heo (4):
      pata_cmd64x: revert commit d62f5576
      libata: skip EH autopsy and recovery during suspend
      libata,pata_via: revert ata_wait_idle() removal from ata_sff/via_tf_load()
      ahci: fix hang on failed softreset

Thadeu Lima de Souza Cascardo (1):
      usb: allow drivers to use allocated bandwidth until unbound

Thomas Gleixner (1):
      x86: hpet: Work around hardware stupidity

Toby Gray (2):
      USB: cdc-acm: Adding second ACM channel support for various Nokia and one Samsung phones
      USB: cdc-acm: Fixing crash when ACM probing interfaces with no endpoint descriptors.

Trond Myklebust (2):
      NFS: Fix a typo in nfs_sockaddr_match_ipaddr6
      SUNRPC: Fix race corrupting rpc upcall

Uwe Kleine-König (1):
      mmc: build fix: mmc_pm_notify is only available with CONFIG_PM=y

Vivek Natarajan (1):
      ath9k_htc: Fix disconnect issue in HT40 mode.

Yong Wang (1):
      hwmon: (emc1403) Remove unnecessary hwmon_device_unregister

Yusuke Goda (1):
      tmio_mmc: don't clear unhandled pending interrupts

Zhenyu Wang (1):
      drm/i915: Enable MI_FLUSH on Sandybridge


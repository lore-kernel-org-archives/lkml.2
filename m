Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841Ab1BRASl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 19:18:41 -0500
Received: from kroah.org ([198.145.64.141]:48702 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942Ab1BRASj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 19:18:39 -0500
Date: Thu, 17 Feb 2011 16:15:30 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.32.29
Message-ID: <20110218001530.GA9342@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.32.29 kernel.

All users of the 2.6.32 kernel series must upgrade.

The updated 2.6.32.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/longterm/linux-2.6.32.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/longterm/linux-2.6.32.y.git;a=summary

thanks,

greg k-h

------------

 Documentation/kernel-parameters.txt        |    5 
 Makefile                                   |    2 
 arch/ia64/include/asm/system.h             |    4 
 arch/parisc/kernel/firmware.c              |   13 
 arch/powerpc/include/asm/system.h          |    4 
 arch/powerpc/kernel/cpu_setup_6xx.S        |   40 +-
 arch/powerpc/sysdev/fsl_rio.c              |    1 
 arch/s390/include/asm/system.h             |    1 
 arch/s390/include/asm/vdso.h               |    2 
 arch/x86/Kconfig                           |   11 
 arch/x86/include/asm/mmu_context.h         |    5 
 arch/x86/kernel/cpu/mtrr/main.c            |   10 
 arch/x86/kernel/tsc.c                      |    8 
 drivers/ata/pata_mpc52xx.c                 |    2 
 drivers/char/hvc_iucv.c                    |    6 
 drivers/char/tpm/tpm.c                     |   28 +-
 drivers/char/tpm/tpm.h                     |    2 
 drivers/char/tpm/tpm_tis.c                 |    4 
 drivers/gpu/drm/Kconfig                    |    3 
 drivers/gpu/drm/i915/intel_lvds.c          |    8 
 drivers/gpu/drm/radeon/radeon_atombios.c   |   16 -
 drivers/gpu/drm/radeon/radeon_display.c    |    4 
 drivers/hwmon/via686a.c                    |   14 -
 drivers/i2c/i2c-core.c                     |   14 -
 drivers/input/mouse/bcm5974.c              |   40 ++
 drivers/input/serio/i8042-x86ia64io.h      |   21 +
 drivers/input/serio/i8042.c                |    6 
 drivers/md/dm-mpath.c                      |   12 
 drivers/md/dm.c                            |    5 
 drivers/md/md.c                            |    5 
 drivers/media/radio/radio-aimslab.c        |   23 -
 drivers/media/video/em28xx/em28xx-cards.c  |    4 
 drivers/net/wireless/ath/ath9k/ath9k.h     |    4 
 drivers/net/wireless/hostap/hostap_cs.c    |   10 
 drivers/net/wireless/iwlwifi/iwl-agn.c     |   15 -
 drivers/net/wireless/iwlwifi/iwl-helpers.h |    6 
 drivers/net/wireless/p54/txrx.c            |    2 
 drivers/net/wireless/rt2x00/rt73usb.c      |    1 
 drivers/pci/pci-stub.c                     |    3 
 drivers/power/ds2760_battery.c             |    2 
 drivers/rtc/rtc-cmos.c                     |   16 -
 drivers/scsi/libsas/sas_scsi_host.c        |    1 
 drivers/scsi/mpt2sas/mpt2sas_base.c        |   19 +
 drivers/scsi/mpt2sas/mpt2sas_scsih.c       |    3 
 drivers/scsi/sd.c                          |    9 
 drivers/serial/8250.c                      |    3 
 drivers/staging/comedi/drivers/jr3_pci.c   |    7 
 drivers/staging/comedi/drivers/ni_labpc.c  |    3 
 drivers/staging/hv/blkvsc_drv.c            |    1 
 drivers/staging/hv/netvsc_drv.c            |    1 
 drivers/staging/usbip/vhci_hcd.c           |   14 -
 drivers/usb/class/cdc-acm.c                |    1 
 drivers/usb/core/hub.c                     |   26 +
 drivers/usb/gadget/printer.c               |   14 -
 drivers/usb/host/ehci-hcd.c                |   27 +
 drivers/usb/host/ehci-pci.c                |   39 ++
 drivers/usb/host/ehci-sched.c              |   79 +++++
 drivers/usb/host/ehci.h                    |    1 
 drivers/usb/serial/ch341.c                 |   10 
 drivers/usb/serial/cp210x.c                |   16 -
 drivers/usb/serial/digi_acceleport.c       |   10 
 drivers/usb/serial/ftdi_sio.c              |   39 ++
 drivers/usb/serial/ftdi_sio_ids.h          |   32 ++
 drivers/usb/serial/generic.c               |   20 +
 drivers/usb/serial/io_edgeport.c           |    4 
 drivers/usb/serial/keyspan_pda.c           |   17 -
 drivers/usb/serial/option.c                |   23 +
 drivers/usb/serial/pl2303.c                |   13 
 drivers/usb/serial/pl2303.h                |    2 
 drivers/usb/serial/spcp8x5.c               |    6 
 drivers/usb/serial/ti_usb_3410_5052.c      |    2 
 drivers/usb/storage/unusual_cypress.h      |    5 
 drivers/usb/storage/unusual_devs.h         |   32 ++
 drivers/virtio/virtio_pci.c                |   20 -
 fs/nfs/direct.c                            |   34 +-
 include/drm/drm_pciids.h                   |    1 
 include/linux/hardirq.h                    |    9 
 include/linux/ieee80211.h                  |    2 
 include/linux/klist.h                      |    2 
 include/linux/sched.h                      |   39 +-
 include/linux/usb/serial.h                 |    3 
 init/Kconfig                               |   80 ++---
 init/calibrate.c                           |    6 
 kernel/capability.c                        |    1 
 kernel/cred-internals.h                    |   21 -
 kernel/cred.c                              |    3 
 kernel/exit.c                              |    1 
 kernel/ksysfs.c                            |    8 
 kernel/ptrace.c                            |    2 
 kernel/sched.c                             |  392 ++++++++++++++++++-----------
 kernel/sched_debug.c                       |    5 
 kernel/sched_fair.c                        |   56 +++-
 kernel/sched_features.h                    |    5 
 kernel/sched_rt.c                          |   34 +-
 kernel/smp.c                               |   30 ++
 kernel/softirq.c                           |   64 +++-
 kernel/sys.c                               |    5 
 kernel/user.c                              |  318 -----------------------
 net/sched/cls_cgroup.c                     |    2 
 security/selinux/hooks.c                   |    5 
 security/selinux/nlmsgtab.c                |    2 
 sound/core/hrtimer.c                       |    5 
 sound/pci/au88x0/au88x0_pcm.c              |   24 +
 sound/pci/hda/hda_eld.c                    |    2 
 sound/pci/hda/patch_conexant.c             |    8 
 sound/soc/blackfin/bf5xx-ac97.c            |    4 
 sound/soc/codecs/wm8990.c                  |   10 
 sound/usb/usx2y/us122l.c                   |   41 +--
 108 files changed, 1189 insertions(+), 916 deletions(-)

Alan Stern (5):
      USB: usb-storage: unusual_devs entry for CamSport Evo
      USB: usb-storage: unusual_devs entry for Coby MP3 player
      USB: EHCI: fix DMA deallocation bug
      USB: g_printer: fix bug in module parameter definitions
      USB: prevent buggy hubs from crashing the USB stack

Alex Deucher (5):
      drm/radeon/kms: add quirk for Mac Radeon HD 2600 card
      drm/radeon/kms: make the mac rv630 quirk generic
      drm/radeon/kms: add pll debugging output
      drm/radeon: remove 0x4243 pci id
      drm/radeon/kms: fix s/r issues with bios scratch regs

Alex He (2):
      USB: EHCI: ASPM quirk of ISOC on AMD SB800
      USB: EHCI: ASPM quirk of ISOC on AMD Hudson

Alex Shi (1):
      sched: Fix volanomark performance regression

Amitkumar Karwar (1):
      ieee80211: correct IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK macro

Anton Blanchard (1):
      kernel/smp.c: fix smp_call_function_many() SMP race

Arvid Ephraim Picciani (1):
      USB: cdc-acm: Adding second ACM channel support for Nokia N8

Benjamin Herrenschmidt (1):
      powerpc: Fix some 6xx/7xxx CPU setup functions

Bjørn Mork (1):
      USB: io_edgeport: fix the reported firmware major and minor

Chris Wilson (1):
      drm/i915: Add dependency on CONFIG_TMPFS

Christian Lamparter (1):
      p54: fix sequence no. accounting off-by-one error

Chuck Lever (1):
      NFS: Fix "kernel BUG at fs/aio.c:554!"

Clemens Ladisch (1):
      ALSA: hrtimer: handle delayed timer interrupts

Craig Shelley (2):
      USB: CP210x Add two device IDs
      USB: CP210x Removed incorrect device ID

Dan Carpenter (1):
      sched: Remove some dead code

Dario Lombardo (1):
      drivers: update to pl2303 usb-serial to support Motorola cables

Dave Young (1):
      sched: Remove unused PF_ALIGNWARN flag

David Henningsson (1):
      ALSA: HDA: Fix dmesg output of HDMI supported bits

David Miller (1):
      klist: Fix object alignment on 64-bit.

Dhaval Giani (1):
      sched: Remove USER_SCHED

Dimitris Papastamos (1):
      ASoC: WM8990: msleep() takes milliseconds not jiffies

Don Fry (1):
      iwlagn: Re-enable RF_KILL interrupt when down

Edgar (gimli) Hucek (1):
      input: bcm5974: Add support for MacBookAir3

Eric Paris (2):
      SELinux: define permissions for DCB netlink messages
      SELinux: do not compute transition labels on mountpoint labeled filesystems

Greg Kroah-Hartman (2):
      rt2x00: add device id for windy31 usb device
      Linux 2.6.32.29

Guy Martin (1):
      parisc : Remove broken line wrapping handling pdc_iodc_print()

Haiyang Zhang (1):
      staging: hv: Enable sending GARP packet after live migration

Hendrik Brueckner (1):
      hvc_iucv: allocate memory buffers for IUCV in zone DMA

Ian Abbott (1):
      staging: comedi: ni_labpc: Use shared IRQ for PCMCIA card

Ingo Molnar (1):
      sched: Export account_system_vtime()

Ionut Nicu (1):
      USB: ti_usb: fix module removal

James Bottomley (2):
      fix medium error problems with some arrays which can cause data corruption
      libsas: fix runaway error handler problem

Jean Delvare (2):
      hwmon: (via686a) Initialize fan_div values
      i2c: Unregister dummy devices last on adapter removal

Jean-Christophe PLAGNIOL-VILLARD (1):
      USB: ftdi_sio: add ST Micro Connect Lite uart support

Jiri Kosina (1):
      Input: i8042 - introduce 'notimeout' blacklist for Dell Vostro V13

Karsten Wiese (1):
      ALSA: snd-usb-us122l: Fix missing NULL checks

Kashyap, Desai (3):
      mpt2sas: Fix device removal handshake for zoned devices
      mpt2sas: Correct resizing calculation for max_queue_depth
      mpt2sas: Kernel Panic during Large Topology discovery

Knut Petersen (1):
      drm/i915/lvds: Add AOpen i915GMm-HFS to the list of false-positive LVDS

Ky Srinivasan (1):
      Staging: hv: fix sysfs symlink on hv block device

Li Zefan (1):
      sched: Remove remaining USER_SCHED code

Libor Pechacek (1):
      USB: serial: handle Data Carrier Detect changes

Martin Schwidefsky (1):
      correct vdso version string

Mauro Carvalho Chehab (2):
      radio-aimslab.c: Fix gcc 4.5+ bug
      em28xx: Fix audio input for Terratec Grabby

Michael Williamson (1):
      USB: ftdi_sio: Add VID=0x0647, PID=0x0100 for Acton Research spectrograph

Mike Frysinger (1):
      ASoC: Blackfin AC97: fix build error after multi-component update

Mike Snitzer (2):
      dm: dont take i_mutex to change device size
      dm mpath: disable blk_abort_queue

Milton Miller (1):
      virtio: remove virtio-pci root device

Márton Németh (1):
      staging: usbip: remove double giveback of URB

Namhyung Kim (1):
      kernel/user.c: add lock release annotation on free_user()

NeilBrown (1):
      md: fix regression with re-adding devices to arrays with no metadata

Nick Holloway (1):
      USB: Storage: Add unusual_devs entry for VTech Kidizoom

Nicolaus Colberg (1):
      USB: adding USB support for Cinterion's HC2x, EU3 and PH8 products

Nikhil Rao (5):
      sched: Do not consider SCHED_IDLE tasks to be cache hot
      sched: Set group_imb only a task can be pulled from the busiest cpu
      sched: Force balancing on newidle balance if local group has capacity
      sched: Drop group_capacity to 1 only if local group has extra capacity
      sched: Fix idle balancing

Paul E. McKenney (1):
      sched: suppress RCU lockdep splat in task_fork_fair

Paul Fox (1):
      rtc-cmos: fix suspend/resume

Pavel Machek (1):
      serial: unbreak billionton CF card

Peter Zijlstra (4):
      sched: fix RCU lockdep splat from task_group()
      sched, cgroup: Fixup broken cgroup movement
      sched: Fix cross-sched-class wakeup preemption
      sched: Fix wake_affine() vs RT tasks

Pieter Maes (1):
      USB: serial: Updated support for ICOM devices

Rajiv Andrade (1):
      TPM: Long default timeout fix

Raymond Yau (1):
      ALSA : au88x0 - Limit number of channels to fix Oops via OSS emu

Richard Schütz (2):
      USB: usb-storage: unusual_devs update for Cypress ATACB
      USB: usb-storage: unusual_devs update for TrekStor DataStation maxi g.u external hard drive enclosure

Ruben Smits (1):
      staging: comedi: add support for newer jr3 1-channel pci board

Sarah Sharp (1):
      usb: Realloc xHCI structures after a hub is verified.

Simone Contini (1):
      USB: serial: pl2303: Hybrid reader Uniform HCR331

Stanislaw Gruszka (2):
      iwlagn: enable only rfkill interrupt when device is down
      hostap_cs: fix sleeping function called from invalid context

Stefan Berger (1):
      tpm_tis: Use timeouts returned from TPM

Steven Rostedt (1):
      sched: Try not to migrate higher priority RT tasks

Suresh Siddha (4):
      x86, mtrr: Avoid MTRR reprogramming on BP during boot on UP platforms
      x86, mm: avoid possible bogus tlb entries by clearing prev mm_cpumask after switching mm
      sched: Move sched_avg_update() to update_cpu_load()
      sched: Use group weight, idle cpu metrics to fix imbalances during idle

Sven Neumann (1):
      ds2760_battery: Fix calculation of time_to_empty_now

Takashi Iwai (1):
      ALSA: hda - Fix memory leaks in conexant jack arrays

Tejun Heo (3):
      PCI: pci-stub: ignore zero-length id parameters
      ptrace: use safer wake up on ptrace_detach()
      pata_mpc52xx: inherit from ata_bmdma_port_ops

Thomas Taranowski (1):
      rapidio: fix hang on RapidIO doorbell queue full condition

Tim Deegan (1):
      fix jiffy calculations in calibrate_delay_direct to handle overflow

Vasanthakumar Thiagarajan (1):
      ath9k: Fix bug in delimiter padding computation

Venkatesh Pallipadi (9):
      sched: Increment cache_nice_tries only on periodic lb
      sched: Fix softirq time accounting
      sched: Consolidate account_system_vtime extern declaration
      sched: Add a PF flag for ksoftirqd identification
      sched: Add IRQ_TIME_ACCOUNTING, finer accounting of irq time
      x86: Add IRQ_TIME_ACCOUNTING
      sched: Do not account irq time to current task
      sched: Remove irq time from available CPU power
      sched: Call tick_check_idle before __irq_enter

stable-bot for Steven Rostedt (1):
      sched: Give CPU bound RT tasks preference


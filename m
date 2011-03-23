Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933379Ab1CWUhT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 16:37:19 -0400
Received: from kroah.org ([198.145.64.141]:56329 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933342Ab1CWUgc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 16:36:32 -0400
Date: Wed, 23 Mar 2011 13:35:45 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.38.1
Message-ID: <20110323203545.GG7709@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.38.1 kernel.

All users of the 2.6.38 kernel series must upgrade.

The updated 2.6.38.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.38.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.38.y.git;a=summary

thanks,

greg k-h

------------

 Documentation/i2c/instantiating-devices        |    2 
 Makefile                                       |    2 
 arch/arm/mach-davinci/board-dm644x-evm.c       |    8 -
 arch/microblaze/include/asm/uaccess.h          |    8 -
 arch/parisc/kernel/irq.c                       |    2 
 arch/powerpc/include/asm/reg.h                 |    1 
 arch/powerpc/kernel/perf_event.c               |   24 +++++
 arch/x86/include/asm/pgtable-3level.h          |   11 --
 arch/x86/kernel/alternative.c                  |    7 +
 arch/x86/kernel/e820.c                         |   10 +-
 arch/x86/kernel/early-quirks.c                 |    7 +
 arch/x86/kernel/entry_64.S                     |    2 
 arch/x86/mm/pgtable.c                          |    3 
 drivers/ata/ahci.c                             |    3 
 drivers/ata/libata-eh.c                        |    2 
 drivers/gpu/drm/drm_sysfs.c                    |    7 +
 drivers/gpu/drm/i915/i915_irq.c                |    9 +
 drivers/gpu/drm/i915/i915_reg.h                |    5 -
 drivers/gpu/drm/radeon/atombios_crtc.c         |    4 
 drivers/hid/Kconfig                            |   14 ++-
 drivers/hid/Makefile                           |    2 
 drivers/hid/hid-apple.c                        |    6 +
 drivers/hid/hid-axff.c                         |   31 ++++++
 drivers/hid/hid-core.c                         |    9 +
 drivers/hid/hid-ids.h                          |    4 
 drivers/hid/hid-input.c                        |   30 ++++--
 drivers/hid/hid-magicmouse.c                   |    4 
 drivers/hid/hid-multitouch.c                   |    2 
 drivers/hid/hid-ortek.c                        |    3 
 drivers/hwmon/sht15.c                          |    4 
 drivers/infiniband/core/cm.c                   |    1 
 drivers/infiniband/core/cma.c                  |   15 +++
 drivers/input/mouse/bcm5974.c                  |   20 ++++
 drivers/mmc/core/sdio.c                        |    8 +
 drivers/mmc/host/sdhci-pci.c                   |    8 +
 drivers/net/wireless/ath/ath9k/hw.c            |   21 ++--
 drivers/net/wireless/ath/ath9k/recv.c          |    4 
 drivers/net/wireless/rtl818x/rtl8187/dev.c     |   25 ++++-
 drivers/net/wireless/rtl818x/rtl8187/rtl8187.h |    2 
 drivers/pci/pci-sysfs.c                        |    2 
 drivers/pci/quirks.c                           |  113 +++++++++++--------------
 drivers/scsi/device_handler/scsi_dh_alua.c     |    3 
 drivers/staging/tidspbridge/rmgr/proc.c        |   19 +++-
 drivers/staging/winbond/core.h                 |    1 
 drivers/target/target_core_cdb.c               |    8 +
 drivers/tty/serial/8250.c                      |   33 ++++---
 drivers/tty/serial/mrst_max3110.c              |    2 
 drivers/usb/core/hcd-pci.c                     |   13 +-
 drivers/usb/core/hcd.c                         |   55 +++++++++---
 drivers/usb/core/urb.c                         |   11 ++
 drivers/usb/host/ehci-hub.c                    |   23 ++++-
 drivers/usb/host/isp1760-hcd.c                 |   22 +++-
 drivers/usb/host/isp1760-hcd.h                 |    1 
 drivers/usb/host/xhci-ring.c                   |   43 ++++++++-
 drivers/usb/host/xhci.h                        |    9 +
 drivers/usb/serial/ch341.c                     |    1 
 drivers/usb/serial/kobil_sct.c                 |    2 
 drivers/usb/serial/option.c                    |    3 
 drivers/usb/serial/usb-serial.c                |    5 -
 fs/dcache.c                                    |   95 +++++++++------------
 fs/ext3/namei.c                                |    2 
 fs/partitions/osf.c                            |    2 
 include/linux/ftrace.h                         |    2 
 include/linux/hid.h                            |    2 
 include/linux/usb/ch9.h                        |    2 
 include/linux/usb/hcd.h                        |    4 
 include/linux/usb/serial.h                     |    3 
 kernel/perf_event.c                            |    4 
 kernel/sched.c                                 |    2 
 kernel/smp.c                                   |   55 +++++++++---
 kernel/trace/ftrace.c                          |   52 +++++++++--
 net/sunrpc/clnt.c                              |    4 
 net/sunrpc/sched.c                             |   14 +--
 security/tomoyo/file.c                         |    5 -
 sound/drivers/aloop.c                          |   19 +---
 sound/pci/asihpi/hpioctl.c                     |    5 +
 sound/pci/ctxfi/ctatc.c                        |    2 
 sound/pci/ctxfi/ctdaio.c                       |    2 
 sound/pci/ctxfi/ctmixer.c                      |   19 +---
 sound/pci/hda/patch_realtek.c                  |   79 ++++++++++++-----
 sound/pci/hda/patch_sigmatel.c                 |   11 +-
 sound/soc/pxa/z2.c                             |    2 
 tools/perf/util/PERF-VERSION-GEN               |    8 -
 83 files changed, 756 insertions(+), 338 deletions(-)

Alan Stern (2):
      USB: serial drivers need to use larger bulk-in buffers
      USB: move usbcore away from hcd->state

Alex Deucher (1):
      drm/radeon/kms: fix typo in atom overscan setup

Alexander van Heukelum (1):
      x86, binutils, xen: Fix another wrong size directive

Andreas Herrmann (1):
      x86, quirk: Fix SB600 revision check

Andy Botting (1):
      Input: bcm5974 - add support for MacBookPro8

Anton Blanchard (1):
      perf, powerpc: Handle events that raise an exception without overflowing

Ben Hutchings (1):
      PCI: sysfs: Fix failure path for addition of "vpd" attribute

Brandeburg, Jesse (1):
      PCI: remove quirk for pre-production systems

Chris Wilson (2):
      drm/i915: Replace vblank PM QoS with "Interrupt-Based AGPBUSY#"
      drm: Hold the mode mutex whilst probing for sysfs status

Dan Carpenter (1):
      serial: mrst_max3110: make buffer larger

Dan Rosenberg (1):
      ALSA: sound/pci/asihpi: check adapter index in hpi_ioctl

David Henningsson (4):
      ALSA: HDA: Enable surround and subwoofer on Lenovo Ideapad Y530
      ALSA: HDA: Fix volume control naming for surround speakers on Realtek auto-parser
      ALSA: HDA: Fixup unnecessary volume control index on Realtek ALC88x
      ALSA: HDA: Realtek ALC88x: Do not over-initialize speakers and hp that are primary outputs

Dmitry Torokhov (1):
      HID: ACRUX - activate the device immediately after binding

Eric Sandeen (1):
      ext3: Always set dx_node's fake_dirent explicitly.

Felipe Contreras (1):
      staging: tidspbridge: protect dmm_map properly

Felix Fietkau (1):
      ath9k: remove support for the FIF_PROMISC_IN_BSS filter flag

Frederic Weisbecker (2):
      perf: Fix the software events state check
      perf: Handle stopped state with tracepoints

Greg Kroah-Hartman (1):
      Linux 2.6.38.1

Henrik Rydberg (2):
      HID: hid-magicmouse: Correct touch orientation direction
      HID: Do not create input devices for feature reports

Herton Ronaldo Krzesinski (2):
      USB: serial: option: Apply OPTION_BLACKLIST_SENDSETUP also for ZTE MF626
      HID: add support for Ortek PKB-1700

Jeff Mahoney (1):
      staging: winbond: needs <linux/delay.h> for msleep and friends

Jiri Slaby (3):
      USB: serial/kobil_sct, fix potential tty NULL dereference
      PCI: add more checking to ICH region quirks
      PCI: do not create quirk I/O regions below PCIBIOS_MIN_IO for ICH

Joseph Gruher (1):
      scsi_dh_alua: fix deadlock in stpg_endio

Josh Hunt (1):
      perf tools: Version incorrect with some versions of grep

Kamal Mostafa (2):
      x86: Fix panic when handling "mem={invalid}" param
      x86: Emit "mem=nopentium ignored" warning when not supported

Larry Finger (1):
      rtl8187: Change rate-control feedback

Linus Torvalds (2):
      dcache.c: create helper function for duplicated functionality
      Increase OSF partition limit from 8 to 18

Manoj Iyer (1):
      mmc: sdhci: Add Ricoh e823 PCI ID

Mathieu Desnoyers (1):
      x86: stop_machine_text_poke() should issue sync_core()

Matthew Garrett (1):
      ehci: Check individual port status registers on resume

Milton Miller (3):
      call_function_many: fix list delete vs add race
      call_function_many: add missing ordering
      smp_call_function_many: handle concurrent clearing of mask

Nicholas Bellinger (1):
      target: Fix volume size misreporting for volumes > 2TB

Paul Zimmerman (1):
      USB: Add support for SuperSpeed isoc endpoints

Per Jessen (1):
      ahci: recognize Marvell 88se9125 PCIe SATA 6.0 Gb/s controller

Przemyslaw Bruski (3):
      ALSA: ctxfi - Fix incorrect SPDIF status bit mask
      ALSA: ctxfi - Fix SPDIF status retrieval
      ALSA: ctxfi - Clear input settings before initialization

Roman Fietze (1):
      i2c: Fix typo in instantiating-devices document

Sarah Sharp (2):
      xhci: Update internal dequeue pointers after stalls.
      xhci: Fix cycle bit calculation during stall handling.

Sean Hefty (2):
      RDMA/cma: Fix crash in request handlers
      IB/cm: Bump reference count on cm_id before invoking callback

Sebastian Andrzej Siewior (1):
      USB: isp1760: Implement solution for erratum 2

Senthil Balasubramanian (2):
      ath9k_hw: read and backup AR_WA register value even before chip reset on.
      ath9k_hw: Fix incorrect macversion and macrev checks

Sergei Shtylyov (1):
      davinci: DM644x EVM: register MUSB device earlier

Seth Heasley (1):
      ahci: AHCI mode SATA patch for Intel Patsburg SATA RAID controller

Shaohua Li (1):
      x86: Flush TLB if PGD entry is changed in i386 PAE mode

Stanislav Kinsbursky (1):
      RPC: killing RPC tasks races fixed

Stefan Nilsson XK (1):
      mmc: sdio: remember new card RCA when redetecting card

Steven J. Magnani (1):
      microblaze: Fix /dev/zero corruption from __clear_user()

Steven Rostedt (1):
      ftrace: Fix memory leak with function graph and cpu hotplug

Takashi Iwai (2):
      ALSA: hda - Initialize special cases for input src in init phase
      ALSA: aloop - Fix possible IRQ lock inversion

Tejun Heo (1):
      libata: fix hotplug for drivers which don't implement LPM

Tetsuo Handa (1):
      TOMOYO: Fix memory leak upon file open.

Thomas Gleixner (1):
      fix per-cpu flag problem in the cpu affinity checkers

Trond Myklebust (2):
      VFS: Fix the nfs sillyrename regression in kernel 2.6.38
      SUNRPC: Ensure we always run the tk_callback before tk_action

Vasily Khoruzhick (1):
      ASoC: PXA: Z2: Fix codec pin name

Vitaliy Kulikov (1):
      ALSA: hda - fix digital mic selection in mixer on 92HD8X codecs

Vivien Didelot (1):
      hwmon: (sht15) Fix integer overflow in humidity calculation

Yin Kangkai (2):
      serial: also set the uartclk value in resume after goes to highspeed
      serial: change the divisor latch only when prescalar actually changed

wangyanqing (1):
      USB: serial: ch341: add new id


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756659Ab1BXXyz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 18:54:55 -0500
Received: from kroah.org ([198.145.64.141]:46533 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756554Ab1BXXyx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 18:54:53 -0500
Date: Thu, 24 Feb 2011 15:54:32 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.37.2
Message-ID: <20110224235432.GA23906@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.37.2 kernel.

All users of the 2.6.37 kernel series must upgrade.

The updated 2.6.37.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.37.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.37.y.git;a=summary

thanks,

greg k-h

------------

 Documentation/hwmon/jc42                 |   21 +++++++++----
 Documentation/hwmon/k10temp              |    8 ++++-
 Makefile                                 |    2 -
 arch/arm/kernel/signal.c                 |    4 +-
 arch/arm/kernel/vmlinux.lds.S            |    9 +++++
 arch/arm/mach-sa1100/simpad.c            |    7 ++--
 arch/s390/include/asm/processor.h        |    5 ---
 arch/s390/kernel/traps.c                 |   37 ------------------------
 arch/x86/include/asm/cpu.h               |    1 
 arch/x86/kernel/apb_timer.c              |    8 +++--
 arch/x86/kernel/irq_32.c                 |    7 +---
 arch/x86/kernel/process.c                |    5 +--
 arch/x86/kernel/smpboot.c                |    3 +
 arch/x86/xen/mmu.c                       |   12 +++++++
 drivers/acpi/wakeup.c                    |    6 +++
 drivers/char/tpm/tpm.c                   |   18 +----------
 drivers/char/tpm/tpm.h                   |    2 -
 drivers/char/tpm/tpm_tis.c               |    4 --
 drivers/gpu/drm/i915/intel_dp.c          |   27 +++++++++++++++--
 drivers/gpu/drm/i915/intel_sdvo.c        |   32 +++++++++++++++++----
 drivers/gpu/drm/nouveau/Kconfig          |    2 -
 drivers/gpu/drm/radeon/atombios_crtc.c   |   46 +++++++++---------------------
 drivers/gpu/drm/radeon/r600_cs.c         |   46 +++++++++++++++++-------------
 drivers/gpu/drm/radeon/radeon_combios.c  |   47 +++++++++++++++++++++++++++++++
 drivers/gpu/drm/radeon/radeon_display.c  |   10 ++++++
 drivers/gpu/drm/radeon/radeon_encoders.c |   20 +++++++++----
 drivers/gpu/drm/radeon/radeon_mode.h     |    1 
 drivers/gpu/drm/radeon/radeon_ttm.c      |    4 +-
 drivers/hid/hid-cando.c                  |    2 +
 drivers/hid/hid-core.c                   |    2 +
 drivers/hid/hid-ids.h                    |    1 
 drivers/hid/hid-magicmouse.c             |    5 +++
 drivers/hid/hid-mosart.c                 |    1 
 drivers/hid/usbhid/hid-quirks.c          |    1 
 drivers/hwmon/Kconfig                    |   19 ++++++------
 drivers/hwmon/jc42.c                     |   35 +++++++++++++++++++----
 drivers/hwmon/k10temp.c                  |    5 +--
 drivers/hwmon/lm85.c                     |   23 +++++++++++++--
 drivers/media/dvb/ttpci/av7110_ca.c      |    2 -
 drivers/media/radio/radio-aimslab.c      |    1 
 drivers/message/fusion/mptctl.c          |    8 +++++
 drivers/message/fusion/mptscsih.c        |    7 ++--
 drivers/net/can/janz-ican3.c             |    2 -
 drivers/net/wireless/iwlwifi/iwl-3945.c  |    1 
 drivers/pci/pci-sysfs.c                  |    3 +
 drivers/pcmcia/pcmcia_resource.c         |    2 +
 drivers/platform/x86/acer-wmi.c          |    4 +-
 drivers/platform/x86/asus_acpi.c         |    8 -----
 drivers/platform/x86/tc1100-wmi.c        |    2 -
 drivers/tty/vt/vt.c                      |    9 ++++-
 drivers/usb/core/hub.c                   |    5 ---
 fs/btrfs/ioctl.c                         |   10 +++++-
 fs/cifs/netmisc.c                        |    8 ++---
 fs/cifs/sess.c                           |    8 ++---
 fs/ecryptfs/inode.c                      |    2 +
 fs/file_table.c                          |    2 -
 fs/nfsd/nfs4xdr.c                        |    8 ++---
 fs/nfsd/vfs.c                            |    2 -
 fs/partitions/mac.c                      |   17 +++++------
 fs/proc/array.c                          |    3 -
 fs/xfs/quota/xfs_qm.c                    |   46 +++++++++++++-----------------
 include/linux/pci_ids.h                  |    1 
 include/linux/security.h                 |    6 +--
 include/pcmcia/ds.h                      |    1 
 kernel/capability.c                      |    2 -
 kernel/cred.c                            |   16 ++++++----
 kernel/irq/internals.h                   |    6 +++
 kernel/irq/irqdesc.c                     |   11 ++++++-
 kernel/irq/manage.c                      |    2 -
 kernel/irq/resend.c                      |    2 -
 kernel/perf_event.c                      |   19 +++++++++---
 kernel/power/snapshot.c                  |    7 +---
 kernel/workqueue.c                       |   13 +++++++-
 net/core/dev.c                           |    2 +
 net/netfilter/nf_conntrack_netlink.c     |   15 +++------
 security/security.c                      |    5 +--
 security/selinux/hooks.c                 |    6 +++
 sound/pci/hda/hda_intel.c                |    1 
 sound/pci/hda/patch_conexant.c           |    2 -
 sound/soc/codecs/wm8903.c                |    2 -
 sound/usb/caiaq/audio.c                  |    2 -
 sound/usb/caiaq/midi.c                   |    2 -
 tools/perf/builtin-timechart.c           |    2 -
 83 files changed, 482 insertions(+), 291 deletions(-)


Alex Deucher (6):
      drm/radeon/kms: fix interlaced modes on dce4+
      drm/radeon/kms: add connector table for mac g5 9600
      drm/radeon/kms: improve 6xx/7xx CS error output
      drm/radeon/kms: add bounds checking to avivo pll algo
      drm/radeon/kms: hopefully fix pll issues for real (v3)
      drm/radeon/kms: add missing frac fb div flag for dce4+

Ben Hutchings (1):
      drm/nouveau: Only select ACPI_VIDEO if its dependencies are met

Benjamin Tissoires (2):
      HID: add Add Cando touch screen 10.1-inch product id
      HID: Switch turbox/mosart touchscreen to hid-mosart

Borislav Petkov (1):
      x86, hotplug: Fix powersavings with offlined cores on AMD

Brian Gerst (1):
      x86: Clear irqstack thread_info

Chase Douglas (1):
      HID: magicmouse: Don't report REL_{X, Y} for Magic Trackpad

Chris Wilson (1):
      drm/i915/sdvo: If we have an EDID confirm it matches the mode of the connection

Chris Wright (2):
      security: add cred argument to security_capable()
      pci: use security_capable() when checking capablities during config space read

Clemens Ladisch (4):
      hwmon: (k10temp) add support for AMD Family 12h/14h CPUs
      hwmon: (jc42) fix type mismatch
      hwmon: (jc42) more helpful documentation
      hwmon: (jc42) do not allow writing to locked registers

Dan Carpenter (1):
      av7110: check for negative array offset

Dan Rosenberg (1):
      btrfs: prevent heap corruption in btrfs_ioctl_space_info()

Dave Airlie (2):
      drm/radeon: fix memory debugging since d961db75ce86a84f1f04e91ad1014653ed7d9f46
      vt: fix issue when fbcon wants to takeover a second time.

Dave Chinner (1):
      xfs: fix dquot shaker deadlock

David Henningsson (2):
      ALSA: HDA: Add position_fix quirk for an Asus device
      ALSA: HDA: Do not announce false surround in Conexant auto

Dominik Brodowski (1):
      pcmcia: re-enable Zoomed Video support

Eric Dumazet (1):
      net: deinit automatic LIST_HEAD

Geert Uytterhoeven (1):
      radio-aimslab.c needs #include <linux/delay.h>

Greg Kroah-Hartman (3):
      Revert "USB: prevent buggy hubs from crashing the USB stack"
      Revert: tpm_tis: Use timeouts returned from TPM
      Linux 2.6.37.2

Jacob Pan (1):
      x86, mrst: Set correct APB timer IRQ affinity for secondary cpu

Jan Beulich (1):
      hwmon: (lm85) extend to support EMC6D103 chips

Jeff Layton (1):
      cifs: fix handling of scopeid in cifs_convert_address

Jesse Barnes (1):
      drm/i915: make DP training try a little harder

Jochen Friedrich (1):
      ARM: 6606/1: sa1100: Fix platform device registration

Kashyap, Desai (2):
      mptfusion: mptctl_release is required in mptctl.c
      mptfusion: Fix Incorrect return value in mptscsih_dev_reset

Konstantin Khorenko (1):
      NFSD: memory corruption due to writing beyond the stat array

Martin Schwidefsky (1):
      s390: remove task_show_regs

Matthew Garrett (1):
      acer-wmi: Fix capitalisation of GUID

NeilBrown (1):
      nfsd: correctly handle return value from nfsd_map_name_to_*

Pablo Neira Ayuso (1):
      netfilter: ctnetlink: fix missing refcount increment during dumps

Peter Zijlstra (1):
      perf: Fix throttle logic

Rafael J. Wysocki (1):
      ACPI / Wakeup: Enable button GPEs unconditionally during initialization

Robert Richter (1):
      x86, AMD, PCI: Add AMD northbridge PCI device id for CPU families 12h and 14h

Russell King (2):
      ARM: Ensure predictable endian state on signal handler entry
      ARM: Keep exit text/data around for SMP_ON_UP

Shirish Pargaonkar (1):
      cifs: Fix regression in LANMAN (LM) auth code

Stanislaw Gruszka (2):
      PM / Hibernate: Return error code when alloc_image_page() fails
      iwl3945: remove plcp check

Stefan Bader (2):
      xen: p2m: correctly initialize partial p2m leaf
      xen/p2m: Mark INVALID_P2M_ENTRY the mfn_list past max_pfn.

Stephen Hemminger (1):
      netfilter: fix race in conntrack between dump_table and destroy

Stephen Warren (1):
      ASoC: WM8903: Fix mic detection enable logic

Takashi Iwai (1):
      ALSA: caiaq - Fix possible string-buffer overflow

Tejun Heo (2):
      workqueue: wake up a worker when a rescuer is leaving a gcwq
      workqueue: make sure MAYDAY_INITIAL_TIMEOUT is at least 2 jiffies long

Tetsuo Handa (3):
      CRED: Fix kernel panic upon security_file_alloc() failure.
      CRED: Fix BUG() upon security_cred_alloc_blank() failure
      CRED: Fix memory and refcount leaks upon security_prepare_creds() failure

Thomas Gleixner (2):
      genirq: Prevent access beyond allocated_irqs bitmap
      genirq: Disable the SHIRQ_DEBUG call in request_threaded_irq for now

Thomas Renninger (1):
      perf timechart: Adjust perf timechart to the new power events

Timo Warns (1):
      fs/partitions: Validate map_count in Mac partition tables

Tyler Hicks (1):
      eCryptfs: Copy up lower inode attrs in getattr

Vasiliy Kulikov (4):
      net: can: janz-ican3: world-writable sysfs termination file
      platform: x86: acer-wmi: world-writable sysfs threeg file
      platform: x86: asus_acpi: world-writable procfs files
      platform: x86: tc1100-wmi: world-writable sysfs wireless and jogdial files


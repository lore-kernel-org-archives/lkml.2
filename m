Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932312Ab1EIW1V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 18:27:21 -0400
Received: from kroah.org ([198.145.64.141]:33104 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755272Ab1EIW1S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 18:27:18 -0400
Date: Mon, 9 May 2011 15:24:33 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.38.6
Message-ID: <20110509222433.GA23928@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.38.6 kernel.

All users of the 2.6.38 kernel series must upgrade.

The updated 2.6.38.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.38.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.38.y.git;a=summary

thanks,

greg k-h

------------

 Documentation/flexible-arrays.txt         |    4 +--
 Makefile                                  |    2 -
 arch/arm/kernel/sys_oabi-compat.c         |    2 -
 arch/x86/kernel/cpu/amd.c                 |    2 -
 arch/x86/kvm/svm.c                        |   10 ++++++-
 drivers/firewire/ohci.c                   |   39 +++++++++++++++++++-----------
 drivers/gpu/drm/radeon/radeon_atombios.c  |    5 ++-
 drivers/i2c/busses/i2c-parport.c          |   27 ++++++++++----------
 drivers/media/radio/saa7706h.c            |    2 -
 drivers/media/radio/tef6862.c             |    2 -
 drivers/media/rc/imon.c                   |   31 ++++++++++++++++++++---
 drivers/media/video/cx88/cx88-input.c     |    2 -
 drivers/media/video/m52790.c              |    2 -
 drivers/media/video/tda9840.c             |    2 -
 drivers/media/video/tea6415c.c            |    2 -
 drivers/media/video/tea6420.c             |    2 -
 drivers/media/video/upd64031a.c           |    2 -
 drivers/media/video/upd64083.c            |    2 -
 drivers/mmc/core/host.c                   |    9 +++---
 drivers/mmc/host/sdhci-pci.c              |    1 
 drivers/mmc/host/sdhci.c                  |    9 ++++++
 drivers/net/atl1c/atl1c.h                 |    6 ++--
 drivers/net/atl1c/atl1c_main.c            |   14 +++-------
 drivers/net/usb/cdc_ether.c               |   14 +++++++++-
 drivers/net/wireless/ath/ath9k/recv.c     |    2 -
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c |   27 +++++++++++++-------
 drivers/scsi/device_handler/scsi_dh.c     |    9 ++++--
 drivers/scsi/mpt2sas/mpt2sas_ctl.c        |   23 ++++++++++++++++-
 drivers/scsi/pmcraid.c                    |    3 ++
 drivers/scsi/scsi_lib.c                   |    7 ++++-
 drivers/scsi/scsi_sysfs.c                 |   16 ++++++------
 drivers/staging/usbip/vhci_hcd.c          |    2 -
 fs/nfsd/vfs.c                             |    9 ++++++
 fs/partitions/ldm.c                       |   16 +++++++++---
 fs/ubifs/log.c                            |   20 ---------------
 fs/ubifs/replay.c                         |   18 +++++++++----
 fs/ubifs/super.c                          |   15 +++--------
 include/drm/drm_pciids.h                  |    4 +++
 include/linux/flex_array.h                |    2 -
 include/linux/mmc/host.h                  |    1 
 kernel/workqueue.c                        |    8 +++++-
 lib/flex_array.c                          |   24 +++++++++++++-----
 lib/xz/xz_dec_lzma2.c                     |    6 ++--
 mm/memory.c                               |    7 ++---
 mm/mlock.c                                |    5 ---
 net/can/bcm.c                             |    7 ++++-
 net/can/raw.c                             |    7 ++++-
 net/mac80211/cfg.c                        |    2 +
 net/mac80211/debugfs_netdev.c             |    4 +--
 net/unix/af_unix.c                        |   16 +++++++++++-
 security/selinux/ss/policydb.c            |    6 ++--
 sound/pci/hda/patch_realtek.c             |   29 +++++++---------------
 52 files changed, 306 insertions(+), 182 deletions(-)

Alan Stern (1):
      USB: fix regression in usbip by setting has_tt flag

Alex Deucher (1):
      drm/radeon/kms: add some new pci ids

Artem Bityutskiy (2):
      UBIFS: do not free write-buffers when in R/O mode
      UBIFS: seek journal heads to the latest bud in replay

Avi Kivity (1):
      KVM: SVM: check for progress after IRET interception

B.J. Buchalter (1):
      firewire: Fix for broken configrom updates in quick succession

Ben Dooks (1):
      mmc: sdhci: Check mrq->cmd in sdhci_tasklet_finish

Boris Ostrovsky (1):
      x86, AMD: Fix APIC timer erratum 400 affecting K8 Rev.A-E processors

Chris Ball (2):
      mmc: sdhci-pci: Fix error case in sdhci_pci_probe_slot()
      mmc: sdhci: Check mrq != NULL in sdhci_tasklet_finish

Dan Rosenberg (3):
      pmcraid: reject negative request size
      mpt2sas: prevent heap overflows and unchecked reads
      ARM: 6891/1: prevent heap corruption in OABI semtimedop

Dan Williams (1):
      usbnet: add support for some Huawei modems with cdc-ether ports

Dave Airlie (1):
      drm/radeon: fix regression on atom cards with hardcoded EDID record.

Dave Jones (1):
      can: Add missing socket check in can/bcm release.

David Henningsson (1):
      ALSA: HDA: Fix automute for Gateway NV79

Eric Paris (2):
      flex_array: flex_array_prealloc takes a number of elements, not an end
      flex_arrays: allow zero length flex arrays

Eric W. Biederman (1):
      af_unix: Only allow recv on connected seqpacket sockets.

Felix Fietkau (1):
      ath9k: fix the return value of ath_stoprecv

Greg Kroah-Hartman (1):
      Linux 2.6.38.6

Guennadi Liakhovetski (1):
      mmc: fix a race between card-detect rescan and clock-gate work instances

Herton Ronaldo Krzesinski (1):
      v4l: make sure drivers supply a zeroed struct v4l2_subdev

James Bottomley (2):
      put stricter guards on queue dead checks
      fix oops in scsi_run_queue()

Jarod Wilson (1):
      imon: add conditional locking in change_protocol

Jean Delvare (1):
      i2c-parport: Fix adapter list handling

Johannes Berg (1):
      mac80211: fix SMPS debugfs locking

Lasse Collin (1):
      XZ decompressor: Fix decoding of empty LZMA2 streams

Lawrence Rust (1):
      cx88: Fix HVR4000 IR keymap

Linus Torvalds (1):
      VM: skip the stack guard page lookup in get_user_pages only for mlock

Mike Snitzer (1):
      scsi_dh: fix reference counting in scsi_dh_activate error path

Oliver Hartkopp (1):
      can: add missing socket check in can/raw release

Sachin Prabhu (1):
      Open with O_CREAT flag set fails to open existing files on non writable directories

Stanislaw Gruszka (2):
      iwlwifi: fix skb usage after free
      iwlagn: fix "Received BA when not expected"

Takashi Iwai (2):
      Revert "ALSA: hda - Fix pin-config of Gigabyte mobo"
      ALSA: hda - Fix Realtek's chained fixup checks

Tejun Heo (1):
      workqueue: fix deadlock in worker_maybe_bind_and_lock()

Tim Gardner (1):
      atl1c: Fix work event interrupt/task races

Timo Warns (1):
      fs/partitions/ldm.c: fix oops caused by corrupted partition table


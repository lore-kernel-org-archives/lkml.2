Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388Ab1EFANQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:13:16 -0400
Received: from kroah.org ([198.145.64.141]:32792 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754223Ab1EFANO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:13:14 -0400
Date: Thu, 5 May 2011 17:12:25 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [patch 00/38] 2.6.38.6-stable review
Message-ID: <20110506001225.GA10547@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is the start of the stable review cycle for the 2.6.38.6 release.
There are 38 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Sunday, May 8, 2011, 00:01:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.38.6-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

 Documentation/flexible-arrays.txt         |    4 +-
 Makefile                                  |    2 +-
 arch/arm/kernel/sys_oabi-compat.c         |    2 +-
 arch/x86/kernel/cpu/amd.c                 |    2 +-
 arch/x86/kvm/svm.c                        |   10 ++++++-
 drivers/firewire/ohci.c                   |   39 ++++++++++++++++++----------
 drivers/gpu/drm/radeon/radeon_atombios.c  |    5 ++-
 drivers/i2c/busses/i2c-parport.c          |   27 ++++++++++---------
 drivers/media/radio/saa7706h.c            |    2 +-
 drivers/media/radio/tef6862.c             |    2 +-
 drivers/media/rc/imon.c                   |   31 ++++++++++++++++++++---
 drivers/media/video/cx88/cx88-input.c     |    2 +-
 drivers/media/video/m52790.c              |    2 +-
 drivers/media/video/tda9840.c             |    2 +-
 drivers/media/video/tea6415c.c            |    2 +-
 drivers/media/video/tea6420.c             |    2 +-
 drivers/media/video/upd64031a.c           |    2 +-
 drivers/media/video/upd64083.c            |    2 +-
 drivers/mmc/core/host.c                   |    9 +++---
 drivers/mmc/host/sdhci-pci.c              |    1 +
 drivers/mmc/host/sdhci.c                  |    9 ++++++-
 drivers/net/atl1c/atl1c.h                 |    6 ++--
 drivers/net/atl1c/atl1c_main.c            |   14 +++------
 drivers/net/usb/cdc_ether.c               |   14 +++++++++-
 drivers/net/wireless/ath/ath9k/recv.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c |   27 +++++++++++++------
 drivers/scsi/device_handler/scsi_dh.c     |    9 ++++--
 drivers/scsi/mpt2sas/mpt2sas_ctl.c        |   23 +++++++++++++++-
 drivers/scsi/pmcraid.c                    |    3 ++
 drivers/scsi/scsi_sysfs.c                 |   16 ++++++------
 drivers/staging/usbip/vhci_hcd.c          |    2 +-
 fs/nfsd/vfs.c                             |    9 ++++++-
 fs/partitions/ldm.c                       |   16 +++++++++---
 fs/ubifs/log.c                            |   20 ---------------
 fs/ubifs/replay.c                         |   18 +++++++++----
 fs/ubifs/super.c                          |   15 +++--------
 include/drm/drm_pciids.h                  |    4 +++
 include/linux/flex_array.h                |    2 +-
 include/linux/mmc/host.h                  |    1 -
 kernel/workqueue.c                        |    8 +++++-
 lib/flex_array.c                          |   24 +++++++++++++----
 lib/xz/xz_dec_lzma2.c                     |    6 ++--
 net/can/bcm.c                             |    7 ++++-
 net/mac80211/cfg.c                        |    2 +
 net/mac80211/debugfs_netdev.c             |    4 +-
 net/unix/af_unix.c                        |   16 +++++++++++-
 security/selinux/ss/policydb.c            |    6 ++--
 sound/pci/hda/patch_realtek.c             |   29 +++++++--------------
 48 files changed, 290 insertions(+), 172 deletions(-)
